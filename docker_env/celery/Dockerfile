# 使用多阶段构建
FROM registry.cn-zhangjiakou.aliyuncs.com/dvadmin-pro/dvadmin3-base-backend:latest as builder

# 设置工作目录
WORKDIR /cere_pro

# 设置环境变量
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# 首先只复制依赖文件，利用 Docker 缓存层
COPY ./cere_pro/requirements.txt .

# 安装依赖
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple/ --no-cache-dir -r requirements.txt

# 第二阶段：运行环境
FROM registry.cn-zhangjiakou.aliyuncs.com/dvadmin-pro/dvadmin3-base-backend:latest

# 设置工作目录
WORKDIR /cere_pro

# 设置环境变量
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    TZ=Asia/Shanghai

# 从构建阶段复制已安装的依赖
COPY --from=builder /usr/local/lib/python3.8/site-packages/ /usr/local/lib/python3.12/site-packages/

# 复制应用代码
COPY ./cere_pro/ .

# 创建必要的目录
RUN mkdir -p /var/log/celery && \
    mkdir -p /var/run/celery

# 复制环境配置文件
RUN if [ -f ./conf/env.example.py ]; then \
    cp ./conf/env.example.py ./conf/env.py; \
    fi

# 设置健康检查
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD celery -A application inspect ping -d celery@$HOSTNAME || exit 1

# 设置启动命令
CMD ["celery", "-A", "application", "worker", "-B", "--loglevel=info", \
    "--concurrency=4", \
    "--max-tasks-per-child=1000", \
    "--events", \
    "--pidfile=/var/run/celery/celery.pid", \
    "--logfile=/var/log/celery/celery.log"]

# 添加标签
LABEL maintainer="zhouming" \
    version="1.0" \
    description="Celery worker for YOUIRPA application"

