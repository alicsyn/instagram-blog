#!/bin/bash

###############################################################################
# Instagram 博客自动部署脚本
# 功能：构建 Hugo 网站并部署到生产环境
###############################################################################

set -e  # 遇到错误立即退出

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置变量
PROJECT_DIR="/home/u811056906/projects/instagram-blog"
PROD_DIR="/home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html"
BACKUP_DIR="/home/u811056906/backups/instagram-blog"
HUGO_BIN="/home/u811056906/bin/hugo"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$PROJECT_DIR/deploy.log"

# 打印带颜色的消息
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# 记录日志
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 错误处理
error_exit() {
    print_message "$RED" "❌ 错误: $1"
    log "ERROR: $1"
    exit 1
}

# 开始部署
print_message "$BLUE" "========================================="
print_message "$BLUE" "🚀 开始部署 Instagram 博客"
print_message "$BLUE" "========================================="
log "开始部署"

# 1. 检查 Hugo 是否存在
print_message "$YELLOW" "📋 检查 Hugo..."
if [ ! -f "$HUGO_BIN" ]; then
    error_exit "Hugo 未找到: $HUGO_BIN"
fi
log "Hugo 版本: $($HUGO_BIN version)"

# 2. 进入项目目录
print_message "$YELLOW" "📂 进入项目目录..."
cd "$PROJECT_DIR" || error_exit "无法进入项目目录: $PROJECT_DIR"
log "当前目录: $(pwd)"

# 3. 创建备份目录
print_message "$YELLOW" "📦 准备备份..."
mkdir -p "$BACKUP_DIR"

# 4. 备份当前生产环境
if [ -d "$PROD_DIR" ] && [ "$(ls -A $PROD_DIR 2>/dev/null)" ]; then
    print_message "$YELLOW" "💾 备份当前生产环境..."
    BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"
    
    tar -czf "$BACKUP_FILE" -C "$PROD_DIR" . 2>/dev/null || {
        print_message "$YELLOW" "⚠️  备份失败，继续部署..."
    }
    
    if [ -f "$BACKUP_FILE" ]; then
        BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
        print_message "$GREEN" "✅ 备份完成: $BACKUP_FILE ($BACKUP_SIZE)"
        log "备份文件: $BACKUP_FILE"
        
        # 只保留最近 5 个备份
        cd "$BACKUP_DIR"
        ls -t backup_*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm
        print_message "$YELLOW" "🗑️  清理旧备份，保留最近 5 个"
    fi
fi

# 5. 清理旧的 public 目录
print_message "$YELLOW" "🧹 清理旧的构建文件..."
if [ -d "$PROJECT_DIR/public" ]; then
    rm -rf "$PROJECT_DIR/public"
    log "已清理 public 目录"
fi

# 6. 构建网站
print_message "$YELLOW" "🔨 构建 Hugo 网站..."
BUILD_START=$(date +%s)

if $HUGO_BIN --minify --cleanDestinationDir >> "$LOG_FILE" 2>&1; then
    BUILD_END=$(date +%s)
    BUILD_TIME=$((BUILD_END - BUILD_START))
    print_message "$GREEN" "✅ 构建成功 (耗时: ${BUILD_TIME}秒)"
    log "构建成功，耗时: ${BUILD_TIME}秒"
else
    error_exit "Hugo 构建失败，请查看日志: $LOG_FILE"
fi

# 7. 检查构建结果
if [ ! -d "$PROJECT_DIR/public" ]; then
    error_exit "构建目录不存在: $PROJECT_DIR/public"
fi

FILE_COUNT=$(find "$PROJECT_DIR/public" -type f | wc -l)
TOTAL_SIZE=$(du -sh "$PROJECT_DIR/public" | cut -f1)
print_message "$BLUE" "📊 构建统计: $FILE_COUNT 个文件, 总大小: $TOTAL_SIZE"
log "构建统计: $FILE_COUNT 个文件, 总大小: $TOTAL_SIZE"

# 8. 部署到生产环境
print_message "$YELLOW" "📤 部署到生产环境..."

# 确保生产目录存在
mkdir -p "$PROD_DIR"

# 使用 rsync 同步文件
if rsync -av --delete \
    --exclude='.git' \
    --exclude='.gitignore' \
    --exclude='README.md' \
    --exclude='.htaccess' \
    "$PROJECT_DIR/public/" "$PROD_DIR/" >> "$LOG_FILE" 2>&1; then
    print_message "$GREEN" "✅ 文件同步成功"
    log "文件同步成功"
else
    error_exit "文件同步失败"
fi

# 9. 设置正确的文件权限
print_message "$YELLOW" "🔐 设置文件权限..."
find "$PROD_DIR" -type f -exec chmod 644 {} \; 2>/dev/null || true
find "$PROD_DIR" -type d -exec chmod 755 {} \; 2>/dev/null || true
print_message "$GREEN" "✅ 权限设置完成"
log "权限设置完成"

# 10. 验证部署
print_message "$YELLOW" "🔍 验证部署..."
if [ -f "$PROD_DIR/index.html" ]; then
    PROD_FILE_COUNT=$(find "$PROD_DIR" -type f | wc -l)
    PROD_SIZE=$(du -sh "$PROD_DIR" | cut -f1)
    print_message "$GREEN" "✅ 部署验证成功"
    print_message "$BLUE" "📊 生产环境: $PROD_FILE_COUNT 个文件, 总大小: $PROD_SIZE"
    log "生产环境: $PROD_FILE_COUNT 个文件, 总大小: $PROD_SIZE"
else
    error_exit "部署验证失败: index.html 不存在"
fi

# 11. 完成
DEPLOY_END=$(date +%s)
TOTAL_TIME=$((DEPLOY_END - $(date -d "$(head -1 $LOG_FILE | cut -d']' -f1 | tr -d '[')" +%s 2>/dev/null || echo $DEPLOY_END)))

print_message "$GREEN" "========================================="
print_message "$GREEN" "✅ 部署完成！"
print_message "$GREEN" "========================================="
print_message "$BLUE" "⏱️  总耗时: ${TOTAL_TIME}秒"
print_message "$BLUE" "📦 备份位置: $BACKUP_FILE"
print_message "$BLUE" "🌐 网站地址: https://lightcyan-lark-256774.hostingersite.com"
print_message "$BLUE" "📝 日志文件: $LOG_FILE"
print_message "$GREEN" "========================================="

log "部署完成，总耗时: ${TOTAL_TIME}秒"

# 显示最近的备份
print_message "$YELLOW" "\n📋 最近的备份:"
ls -lht "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | head -5 || echo "无备份文件"

exit 0

