#!/bin/bash

# 定义服务健康检查的 URL
HEALTH_URL="http://localhost:8000/health/"

# 向健康检查端点发送请求
HTTP_RESPONSE=$(curl --write-out "%{http_code}" --silent --output /dev/null "$HEALTH_URL")

# 检查 HTTP 响应码是否为 200
if [ "$HTTP_RESPONSE" -eq 200 ]; then
  echo "Health check passed!"
  exit 0
else
  echo "Health check failed! Response code: $HTTP_RESPONSE"
  exit 1
fi
