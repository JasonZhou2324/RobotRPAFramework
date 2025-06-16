#!/bin/bash

# ========================================
# YOUIRPAFLOW Docker 构建自动化脚本
# ========================================

set -e

# 权限检查
if ! docker info > /dev/null 2>&1; then
  echo "❌ 当前用户无权限使用 docker。请执行以下操作之一："
  echo "  👉 将用户加入 docker 组：sudo usermod -aG docker \$USER && newgrp docker"
  echo "  👉 或在 docker 命令前加 sudo（不推荐整段 sudo 执行）"
  exit 1
fi

# 交互式构建阶段选择
echo "构建镜像阶段："
echo "  1) base     （基础镜像）"
echo "  2) dev      （前端开发）"
echo "  3) prod     （前端构建）"
echo "  4) final    （前端部署）"
echo "  5) backend  （后端服务）"
echo "  6) all      （全部构建）"
read -p "请输入对应的构建选项编号（1-6）: " choice

case "$choice" in
  1) TARGET="base" ;;
  2) TARGET="dev" ;;
  3) TARGET="prod" ;;
  4) TARGET="final" ;;
  5) TARGET="backend" ;;
  6) TARGET="all" ;;
  *) echo "❌ 无效输入，退出。" && exit 1 ;;
esac

# 版本号输入
read -p "请输入版本号（默认: v1.0.0）: " VERSION
VERSION=${VERSION:-v1.0.0}

# 日志模式选择
read -p "是否输出详细构建日志？(y/n，默认 n): " verbose_choice
if [[ "$verbose_choice" == "y" || "$verbose_choice" == "Y" ]]; then
  VERBOSE=true
else
  VERBOSE=false
fi

# 镜像名定义
BASE_IMAGE=rpaflow_base:$VERSION
DEV_IMAGE=web_lumen-dev:$VERSION
PROD_IMAGE=web_lumen-prod:$VERSION
FINAL_IMAGE=web_lumen-final:$VERSION
BACKEND_IMAGE=cere_pro:$VERSION

# 构建函数（支持 tee 输出日志）
build_image() {
  local image_tag=$1
  local target=$2

  mkdir -p build_logs
  LOG_FILE="logs/build_${target}.log"

  echo "🔨 正在构建镜像: $image_tag（阶段: $target）"

  if $VERBOSE; then
    docker build -t $image_tag --target $target . 2>&1 | tee "$LOG_FILE"
  else
    docker build -t $image_tag --target $target . > "$LOG_FILE" 2>&1
  fi

  echo "✅ 构建完成: $image_tag"
  echo "📄 构建日志: $LOG_FILE"
  echo "------------------------------------"
}

# 执行构建
echo "🚀 开始构建（阶段: $TARGET，版本: $VERSION）"
echo "===================================="

case "$TARGET" in
  base)
    build_image $BASE_IMAGE rpaflow_base
    ;;
  dev)
    build_image $DEV_IMAGE web_lumen-dev
    ;;
  prod)
    build_image $PROD_IMAGE web_lumen-prod
    ;;
  final)
    build_image $FINAL_IMAGE web_lumen-final
    ;;
  backend)
    build_image $BACKEND_IMAGE cere_pro
    ;;
  all)
    build_image $BASE_IMAGE rpaflow_base
    build_image $DEV_IMAGE web_lumen-dev
    build_image $PROD_IMAGE web_lumen-prod
    build_image $FINAL_IMAGE web_lumen-final
    build_image $BACKEND_IMAGE cere_pro
    ;;
esac

echo "🎉 所有镜像构建完成（版本: $VERSION）"
