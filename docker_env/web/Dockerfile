# 构建阶段 - 使用统一基础镜像
FROM youirpa/fullstack-base:latest AS builder

# 设置构建参数
ARG NODE_ENV=production
ARG VUE_APP_API_URL
ARG VUE_APP_BASE_API

# 切换到 root 用户
USER root

# 设置工作目录
WORKDIR /app

# 复制前端项目文件
COPY web/package.json web/yarn.lock* ./

# 安装依赖
RUN yarn install --frozen-lockfile --network-timeout 300000

# 复制源代码
COPY web/ .

# 构建应用
RUN yarn build

# 生产阶段 - 使用轻量级 Nginx 镜像
FROM nginx:alpine

# 设置标签
LABEL maintainer="youirpa-team"
LABEL version="1.0"
LABEL service="web"
LABEL description="YOUIRPA Web Application"

# 安装必要的工具
RUN apk add --no-cache curl netcat-openbsd

# 创建非 root 用户
RUN adduser -D -H -u 101 -s /sbin/nologin nginx-user

# 复制构建产物
COPY --from=builder /app/dist /usr/share/nginx/html

# 创建 Nginx 配置目录
RUN mkdir -p /etc/nginx/conf.d

# 复制默认 Nginx 配置
COPY ./docker_env/nginx/nginx_prod.conf /etc/nginx/conf.d/default.conf

# 设置目录权限
RUN chown -R nginx-user:nginx-user /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html && \
    chown -R nginx-user:nginx-user /var/cache/nginx && \
    chown -R nginx-user:nginx-user /var/log/nginx && \
    chown -R nginx-user:nginx-user /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown nginx-user:nginx-user /var/run/nginx.pid

# 创建启动脚本
RUN echo '#!/bin/sh\n\
set -e\n\
\n\
echo "🚀 启动 Web 服务..."\n\
\n\
# 检查后端服务是否就绪\n\
echo "⏳ 等待后端服务就绪..."\n\
while ! nc -z youirpa-django 8000; do\n\
    echo "等待 Django 服务..."\n\
    sleep 2\n\
done\n\
echo "✅ 后端服务已就绪"\n\
\n\
echo "🎯 启动 Nginx..."\n\
exec nginx -g "daemon off;"\n\
' > /docker-entrypoint.sh && \
    chmod +x /docker-entrypoint.sh && \
    chown nginx-user:nginx-user /docker-entrypoint.sh

# 切换到非 root 用户
USER nginx-user

# 暴露端口
EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# 启动命令
CMD ["/docker-entrypoint.sh"]