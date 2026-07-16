#!/usr/bin/env bash
set -euo pipefail

# WorkBuddy Guide —— 一键部署到 www.decard.cc
# 用法:  ./deploy.sh            # 普通部署
#        ./deploy.sh --no-build # 跳过构建，只上传上次构建结果

DEPLOY_DIR="/var/www/decard.cc"
SSH_HOST="decard.cc"

echo "=== WorkBuddy Guide Deploy ==="

if [[ "${1:-}" != "--no-build" ]]; then
    echo "→ 构建静态站点..."
    npm run docs:build
fi

echo "→ 上传到 ${SSH_HOST}:${DEPLOY_DIR} ..."
rsync -avz --delete \
    --progress \
    docs/.vitepress/dist/ \
    "${SSH_HOST}:${DEPLOY_DIR}/"

echo "→ 刷新 Nginx 缓存..."
ssh "${SSH_HOST}" "nginx -t && systemctl reload nginx"

echo ""
echo "✅ 部署完成！"
echo "   https://www.decard.cc/"
echo "   https://www.decard.cc/app/ (Next.js 旧站)"
