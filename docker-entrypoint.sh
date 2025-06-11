#!/bin/bash
# 通用容器启动脚本，支持多种服务类型

set -e

# 设置环境变量文件路径
ENV_FILE=".env"
SERVICE_TYPE=${SERVICE_TYPE:-"django"}
ENVIRONMENT=${ENVIRONMENT:-"production"}

# 颜色输出函数
log_info() {
    echo -e "\033[32m[INFO]\033[0m $1"
}

log_warn() {
    echo -e "\033[33m[WARN]\033[0m $1"
}

log_error() {
    echo -e "\033[31m[ERROR]\033[0m $1"
}

# 检查 .env 文件是否存在，不存在则生成并写入随机密码
if [ -f "$ENV_FILE" ]; then
    log_info "$ENV_FILE 文件已存在。"
else
    # 生成MYSQL随机密码
    MYSQL_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 18)
    echo "MYSQL_PASSWORD=$MYSQL_PASSWORD" >> "$ENV_FILE"
    log_info "MYSQL随机密码已生成并写入 $ENV_FILE 文件！"

    # 生成REDIS随机密码
    REDIS_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)
    echo "REDIS_PASSWORD=$REDIS_PASSWORD" >> "$ENV_FILE"
    log_info "REDIS随机密码已生成并写入 $ENV_FILE 文件。"

    # 替换配置文件中的数据库和Redis密码
    log_info "更新数据库和Redis配置..."
    sed -i "s|DATABASE_HOST = '127.0.0.1'|DATABASE_HOST = '177.10.0.13'|g" ./backend/conf/env.py
    sed -i "s|REDIS_HOST = '127.0.0.1'|REDIS_HOST = '177.10.0.15'|g" ./backend/conf/env.py
    sed -i "s|DATABASE_PASSWORD = 'DVADMIN3'|DATABASE_PASSWORD = '$MYSQL_PASSWORD'|g" ./backend/conf/env.py
    sed -i "s|REDIS_PASSWORD = 'DVADMIN3'|REDIS_PASSWORD = '$REDIS_PASSWORD'|g" ./backend/conf/env.py
    log_info "初始化密码创建并配置文件更新成功"
fi

# 等待服务就绪函数
wait_for_service() {
    local host=$1
    local port=$2
    local service_name=$3
    local timeout=${4:-30}

    log_info "等待 $service_name 服务就绪..."
    local count=0
    while ! nc -z "$host" "$port"; do
        if [ $count -ge $timeout ]; then
            log_error "$service_name 服务连接超时"
            exit 1
        fi
        count=$((count + 1))
        sleep 1
    done
    log_info "$service_name 服务已就绪!"
}

# 初始化数据库
init_database() {
    if [ "$SERVICE_TYPE" = "django" ] || [ "$SERVICE_TYPE" = "celery" ]; then
        if [ -n "$DATABASE_HOST" ]; then
            wait_for_service "$DATABASE_HOST" 3306 "MySQL数据库"
        fi

        if [ -n "$REDIS_HOST" ]; then
            wait_for_service "$REDIS_HOST" 6379 "Redis缓存"
        fi

        if [ "$SERVICE_TYPE" = "django" ]; then
            log_info "执行数据库迁移..."
            # 后台执行数据库迁移，避免阻塞
            python manage.py migrate --noinput &

            log_info "收集静态文件..."
            # 后台执行静态文件收集，避免阻塞
            python manage.py collectstatic --noinput &

            # 创建超级用户（如果环境变量存在）
            if [ -n "$DJANGO_SUPERUSER_USERNAME" ] && [ -n "$DJANGO_SUPERUSER_PASSWORD" ]; then
                log_info "创建超级用户..."
                python manage.py shell -c "
from django.contrib.auth import get_user_model;
User = get_user_model();
if not User.objects.filter(username='$DJANGO_SUPERUSER_USERNAME').exists():
    User.objects.create_superuser('$DJANGO_SUPERUSER_USERNAME', '$DJANGO_SUPERUSER_EMAIL', '$DJANGO_SUPERUSER_PASSWORD');
    print('超级用户创建成功')
else:
    print('超级用户已存在')
"
            fi
        fi
    fi
}

# 设置文件权限
setup_permissions() {
    log_info "设置文件权限..."

    # 确保日志目录存在且有正确权限
    mkdir -p /var/log/django /var/log/nginx /var/log/supervisor
    chown -R appuser:appuser /var/log/django

    # 确保应用目录权限
    if [ -d "/app" ]; then
        chown -R appuser:appuser /app
    fi

    # 确保媒体和静态文件目录权限
    if [ -d "/app/media" ]; then
        chmod -R 755 /app/media
    fi

    if [ -d "/app/static" ]; then
        chmod -R 755 /app/static
    fi
}

# 启动Django应用
start_django() {
    log_info "启动Django应用..."

    if [ "$ENVIRONMENT" = "development" ]; then
        log_info "开发模式启动..."
        exec python manage.py runserver 0.0.0.0:8000
    else
        log_info "生产模式启动..."
        exec gunicorn application.wsgi:application \
            --bind 0.0.0.0:8000 \
            --workers ${GUNICORN_WORKERS:-4} \
            --threads ${GUNICORN_THREADS:-2} \
            --timeout ${GUNICORN_TIMEOUT:-60} \
            --max-requests ${GUNICORN_MAX_REQUESTS:-1000} \
            --max-requests-jitter ${GUNICORN_MAX_REQUESTS_JITTER:-100} \
            --access-logfile /var/log/django/access.log \
            --error-logfile /var/log/django/error.log \
            --log-level info
    fi
}

# 启动Celery Worker
start_celery() {
    log_info "启动Celery Worker..."

    exec celery -A application worker \
        --loglevel=${CELERY_LOG_LEVEL:-info} \
        --concurrency=${CELERY_CONCURRENCY:-4} \
        --max-tasks-per-child=${CELERY_MAX_TASKS_PER_CHILD:-1000} \
        --logfile=/var/log/django/celery.log
}

# 启动前端应用
start_web() {
    log_info "启动前端应用..."

    if [ "$ENVIRONMENT" = "development" ]; then
        log_info "开发模式启动..."
        cd /app/web_lumen
        exec yarn serve
    else
        log_info "生产模式启动..."
        exec nginx -g "daemon off;"
    fi
}

# 主函数
main() {
    log_info "容器启动中..."
    log_info "服务类型: $SERVICE_TYPE"
    log_info "环境模式: $ENVIRONMENT"

    # 设置权限
    setup_permissions

    # 根据服务类型执行不同的初始化
    case "$SERVICE_TYPE" in
        "django")
            init_database
            start_django
            ;;
        "celery")
            init_database
            start_celery
            ;;
        "web")
            start_web
            ;;
        *)
            log_error "未知的服务类型: $SERVICE_TYPE"
            log_info "支持的服务类型: django, celery, web"
            exit 1
            ;;
    esac
}

# 信号处理
trap 'log_info "接收到停止信号，正在关闭..."; exit 0' SIGTERM SIGINT

# 如果有参数传入，直接执行
if [ $# -gt 0 ]; then
    exec "$@"
else
    main
fi
