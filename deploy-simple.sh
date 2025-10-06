#!/bin/bash

###############################################################################
# Instagram 博客简化部署脚本
# 用途：减少进程使用，避免触发 CPU 限制
###############################################################################

# 配置
PROJECT_DIR="/home/u811056906/projects/instagram-blog"
PROD_DIR="/home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html"
HUGO_BIN="/home/u811056906/bin/hugo"

# 进入项目目录
cd "$PROJECT_DIR" || exit 1

echo "========================================="
echo "🚀 Instagram 博客简化部署"
echo "========================================="
echo ""

# 1. 检查 Hugo
echo "📋 检查 Hugo..."
if [ ! -f "$HUGO_BIN" ]; then
    echo "❌ Hugo 未找到: $HUGO_BIN"
    exit 1
fi
echo "✅ Hugo 已安装"
echo ""

# 2. 清理旧构建
echo "🧹 清理旧构建..."
rm -rf public/
echo "✅ 清理完成"
echo ""

# 3. 构建网站
echo "🔨 构建 Hugo 网站..."
if $HUGO_BIN --minify --cleanDestinationDir; then
    echo "✅ 构建成功"
    
    # 统计
    FILE_COUNT=$(find public -type f 2>/dev/null | wc -l)
    TOTAL_SIZE=$(du -sh public 2>/dev/null | cut -f1)
    echo "📊 生成了 $FILE_COUNT 个文件，总大小: $TOTAL_SIZE"
else
    echo "❌ 构建失败"
    exit 1
fi
echo ""

# 4. 同步文件
echo "📤 同步文件到生产环境..."
if rsync -a --delete public/ "$PROD_DIR/"; then
    echo "✅ 文件同步成功"
else
    echo "❌ 文件同步失败"
    exit 1
fi
echo ""

# 5. 设置权限
echo "🔐 设置文件权限..."
find "$PROD_DIR" -type f -exec chmod 644 {} \; 2>/dev/null
find "$PROD_DIR" -type d -exec chmod 755 {} \; 2>/dev/null
echo "✅ 权限设置完成"
echo ""

# 6. 验证部署
echo "🔍 验证部署..."
if [ -f "$PROD_DIR/index.html" ]; then
    echo "✅ 部署验证成功"
else
    echo "⚠️  警告: index.html 未找到"
fi
echo ""

echo "========================================="
echo "✅ 部署完成！"
echo "========================================="
echo ""
echo "🌐 网站地址: https://lightcyan-lark-256774.hostingersite.com"
echo ""

