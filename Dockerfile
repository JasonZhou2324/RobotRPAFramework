# =====================================
# 构建阶段 1：基础镜像
# =====================================
FROM python:3.13-slim AS rpaflow_base

LABEL maintainer="YOUIRPAFLOW"
LABEL version="1.0"
LABEL description="Base image with Python 3.13, Node.js 22.16.0, and pnpm"

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    NODE_VERSION=22.16.0 \
    TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive \
    PATH="/opt/node/bin:$PATH"

# 安装依赖环境库
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        gnupg \
        build-essential \
        pkg-config \
        libssl-dev \
        libpq-dev \
        xz-utils \
        libmariadb-dev \
        supervisor && \
    curl -fsSL https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz | \
        tar -xJf - -C /opt && \
    mv /opt/node-v$NODE_VERSION-linux-x64 /opt/node && \
    ln -s /opt/node/bin/node /usr/local/bin/node && \
    ln -s /opt/node/bin/npm /usr/local/bin/npm && \
    npm install -g pnpm && \
    pnpm config set registry https://registry.npmmirror.com && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 设置时区
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 创建非 root 用户和工作目录
RUN useradd --create-home --shell /bin/bash --uid 1000 youirpaflow && \
    mkdir -p /app && chown -R youirpaflow:youirpaflow /app

# =====================================
# 构建阶段 2：前端开发环境镜像
# =====================================
FROM rpaflow_base AS web_lumen-dev

WORKDIR /app/web_lumen
RUN mkdir -p /app/web_lumen && chown -R youirpaflow:youirpaflow /app/web_lumen
USER youirpaflow

COPY web_lumen/package.json web_lumen/pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

CMD ["pnpm", "run", "dev"]

# =====================================
# 构建阶段 3：前端生产构建镜像
# =====================================
FROM rpaflow_base AS web_lumen-prod

WORKDIR /app/web_lumen
RUN mkdir -p /app/web_lumen && chown -R youirpaflow:youirpaflow /app/web_lumen
USER youirpaflow

COPY web_lumen/package.json web_lumen/pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
COPY web_lumen ./
RUN pnpm build

# =====================================
# 构建阶段 4：前端部署镜像
# =====================================
FROM nginx:alpine AS web_lumen-final

RUN adduser -D -u 1000 youirpaflow
WORKDIR /app

# 拷贝构建产物
COPY --from=web_lumen-prod /app/web_lumen/dist /usr/share/nginx/custom_html
RUN chown -R youirpaflow:youirpaflow /usr/share/nginx/custom_html

COPY docker_env/nginx/nginx_prod.conf /etc/nginx/nginx.conf

USER youirpaflow
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]


# =====================================
# 构建阶段 5：后端服务镜像
# =====================================
FROM rpaflow_base AS cere_pro

WORKDIR /app

COPY cere_pro/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

COPY cere_pro /app
COPY docker-entrypoint.sh /usr/local/bin/
COPY health-check.sh /usr/local/bin/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chmod +x /usr/local/bin/docker-entrypoint.sh /usr/local/bin/health-check.sh

USER youirpaflow

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
