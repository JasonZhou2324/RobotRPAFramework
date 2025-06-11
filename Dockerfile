# =====================================
# 构建阶段 1：基础镜像，包含 Python 3.12 + Node.js 22 + 构建工具
# =====================================
FROM python:3.12 AS base

# 设置元信息
LABEL maintainer="YOUIRPAFLOW"
LABEL version="1.0"
LABEL description="YOUIRPAFLOW Fullstack Base Image with Python 3.12, Node.js 22.12.0, and Vue 3 + pnpm support"

# 设置环境变量
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    NODE_VERSION=22.12.0 \
    TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive

# 安装系统依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        pkg-config \
        libssl-dev \
        curl \
        git \
        vim \
        supervisor \
        nginx \
        ca-certificates \
        software-properties-common \
        lsb-release \
        nodejs \
        npm && \
    # 清理 apt 缓存
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # 安装 pnpm 并配置镜像源
    npm install -g pnpm && \
    pnpm config set registry https://registry.npmmirror.com

# 设置时区
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 创建非 root 用户 app，并初始化应用目录
RUN useradd --create-home --shell /bin/bash --uid 1000 app && \
    mkdir -p /app /app/logs /app/media /app/static /app/web/dist && \
    chown -R app:app /app /var/log/app

# =====================================
# 构建阶段 2：前端开发环境镜像
# =====================================
FROM base AS web_lumen-dev

# 设置前端开发目录
WORKDIR /app/web_lumen

# 拷贝前端依赖文件
COPY web_lumen/package.json web_lumen/pnpm-lock.yaml ./

# 安装前端依赖
RUN pnpm install --frozen-lockfile

# 启动前端开发服务器
CMD ["pnpm", "run", "dev"]

# =====================================
# 构建阶段 3：前端生产构建镜像
# =====================================
FROM base AS web_lumen-prod

# 设置工作目录
WORKDIR /app/web_lumen

# 拷贝并安装依赖
COPY web_lumen/package.json web_lumen/pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

# 拷贝完整代码用于构建
COPY web_lumen ./

# 使用 pnpm 构建生产版本
RUN pnpm build

# =====================================
# 构建阶段 4：前端部署镜像（基于 nginx）
# =====================================
FROM nginx:alpine AS web_lumen-final

# 设置部署工作目录
WORKDIR /app

# 拷贝构建好的前端资源到 nginx 静态目录
COPY --from=web_lumen-prod /app/web_lumen/dist /usr/share/nginx/custom_html

# 拷贝自定义 nginx 配置（如配置入口路由、缓存策略等）
COPY nginx.conf /etc/nginx/nginx.conf

# 暴露 nginx 端口
EXPOSE 8080

# 启动 nginx 前台进程
CMD ["nginx", "-g", "daemon off;"]

# =====================================
# 构建阶段 5：后端服务镜像
# =====================================
FROM base AS cere_pro

# 设置后端服务目录
WORKDIR /app

# 拷贝并安装 Python 后端依赖
COPY cere_pro/requirements.txt /tmp/requirements.txt
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple/ --no-cache-dir -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

# 拷贝后端源代码
COPY cere_pro /app

# 拷贝自定义容器启动脚本
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# 拷贝健康检查脚本
COPY health-check.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/health-check.sh

# 拷贝 supervisor 配置文件
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 使用非 root 用户运行后端服务
USER app

# 容器入口：执行 entrypoint 脚本初始化（如迁移数据库）
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# 启动命令：以 supervisor 启动多进程（如 Django + Celery）
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
