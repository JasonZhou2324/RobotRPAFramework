#!/bin/bash

# 配置
source .env 2>/dev/null || true
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-"your_secure_password"}
MYSQL_DATABASE=${MYSQL_DATABASE:-"your_database"}
MYSQL_USER=${MYSQL_USER:-"root"}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-"youibot"}
MYSQL_VERSION=${MYSQL_VERSION:-"5.7"}

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# 日志函数
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
    exit 1
}

# 检查目录
check_directories() {
    local dirs=("logs" "data" "run" "backups")
    for dir in "${dirs[@]}"; do
        mkdir -p "$dir" || error "Failed to create directory: $dir"
    done
}

# 备份函数
backup_mysql() {
    local backup_dir="backups"
    local date=$(date +%Y%m%d_%H%M%S)
    log "Creating backup..."

    docker exec mysql mysqldump -u root -p$MYSQL_ROOT_PASSWORD --all-databases > "$backup_dir/backup_$date.sql" \
        || error "Backup failed"

    log "Backup created: $backup_dir/backup_$date.sql"
}

# 清理函数
cleanup() {
    log "Cleaning up old containers..."
    docker rm -f mysql 2>/dev/null || true
}

# 启动容器
start_mysql() {
    log "Starting MySQL container..."

    docker run -d \
        --name mysql \
        --restart unless-stopped \
        --health-cmd="mysqladmin ping -h localhost -u root -p$MYSQL_ROOT_PASSWORD" \
        --health-interval=10s \
        --health-timeout=5s \
        --health-retries=3 \
        --privileged=true \
        -p 3306:3306 \
        -v $PWD/logs:/logs \
        -v $PWD/data:/var/lib/mysql \
        -v $PWD/conf.d/my.cnf:/etc/mysql/mysql.conf.d/mysqld.cnf \
        -v $PWD/run/:/var/run/mysql \
        -e MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" \
        -e MYSQL_DATABASE="$MYSQL_DATABASE" \
        -e MYSQL_USER="$MYSQL_USER" \
        -e MYSQL_PASSWORD="$MYSQL_PASSWORD" \
        mysql:$MYSQL_VERSION || error "Failed to start MySQL container"
}

# 等待健康检查
wait_for_healthy() {
    log "Waiting for MySQL to be healthy..."
    local timeout=60
    local counter=0

    while [ $(docker inspect --format='{{.State.Health.Status}}' mysql) != "healthy" ]; do
        sleep 1
        counter=$((counter + 1))
        if [ $counter -ge $timeout ]; then
            error "MySQL failed to become healthy within $timeout seconds"
        fi
    done

    log "MySQL is healthy"
}

# 主函数
main() {
    check_directories
    cleanup
    backup_mysql
    start_mysql
    wait_for_healthy
    log "MySQL container is ready"
}

# 执行主函数
main
