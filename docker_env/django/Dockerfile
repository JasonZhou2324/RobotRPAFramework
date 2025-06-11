# 使用统一基础镜像
FROM youirpa/fullstack-base:latest

# 切换到 root 用户进行安装
USER root

# 设置工作目录
WORKDIR /cere_pro

# 设置环境变量
ENV DJANGO_SETTINGS_MODULE=application.settings \
    DATABASE_HOST=youirpa-mysql \
    REDIS_HOST=youirpa-redis

# 复制项目的 requirements.txt
COPY ./cere_pro/requirements.txt .

# 安装项目特定依赖（基于 cere_pro/requirements.txt）
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple/ \
    --no-cache-dir -r requirements.txt

# 复制应用代码
COPY ./cere_pro/ .

# 创建必要的目录并设置权限
RUN mkdir -p /var/log/django /cere_pro/media /cere_pro/static && \
    chown -R app:app /cere_pro /var/log/django && \
    chmod -R 755 /cere_pro/media /cere_pro/static

# 复制并配置环境文件
RUN if [ -f ./conf/env.example.py ]; then \
    cp ./conf/env.example.py ./conf/env.py && \
    sed -i "s|DATABASE_HOST = '127.0.0.1'|DATABASE_HOST = '${DATABASE_HOST}'|g" ./conf/env.py && \
    sed -i "s|REDIS_HOST = '127.0.0.1'|REDIS_HOST = '${REDIS_HOST}'|g" ./conf/env.py && \
    chown app:app ./conf/env.py; \
    fi

# 切换到应用用户
USER app

# 收集静态文件
RUN python manage.py collectstatic --noinput || echo "静态文件收集跳过"

# 切换回 root 创建启动脚本
USER root
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
echo "🚀 启动 Django 服务..."\n\
echo "等待数据库连接..."\n\
while ! nc -z ${DATABASE_HOST:-mysql} 3306; do\n\
    echo "⏳ 等待 MySQL 就绪..."\n\
    sleep 2\n\
done\n\
echo "✅ MySQL 已就绪"\n\
\n\
echo "等待 Redis 连接..."\n\
while ! nc -z ${REDIS_HOST:-redis} 6379; do\n\
    echo "⏳ 等待 Redis 就绪..."\n\
    sleep 2\n\
done\n\
echo "✅ Redis 已就绪"\n\
\n\
echo "🔄 执行数据库迁移..."\n\
python manage.py migrate --noinput\n\
\n\
echo "🎯 启动 Django 应用服务器..."\n\
exec gunicorn application.wsgi:application \\\n\
    --bind 0.0.0.0:8000 \\\n\
    --workers 4 \\\n\
    --threads 2 \\\n\
    --timeout 60 \\\n\
    --keepalive 2 \\\n\
    --max-requests 1000 \\\n\
    --max-requests-jitter 50 \\\n\
    --access-logfile /var/log/django/access.log \\\n\
    --error-logfile /var/log/django/error.log \\\n\
    --log-level info\n\
' > /cere_pro/docker_start.sh && \
    chmod +x /cere_pro/docker_start.sh && \
    chown app:app /cere_pro/docker_start.sh

# 设置健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:8000/health/ || python -c "import requests; requests.get('http://localhost:8000', timeout=5)" || exit 1

# 切换到应用用户
USER app

# 设置启动命令
CMD ["/cere_pro/docker_start.sh"]

# 添加标签
LABEL maintainer="youirpa-team" \
    version="1.0" \
    service="django" \
    description="Django application for YOUIRPA"

# 暴露端口
EXPOSE 8000