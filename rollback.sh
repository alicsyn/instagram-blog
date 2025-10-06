#!/bin/bash

###############################################################################
# Instagram 博客回滚脚本
# 功能：从备份恢复生产环境
###############################################################################

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 配置变量
BACKUP_DIR="/home/u811056906/backups/instagram-blog"
PROD_DIR="/home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html"
LOG_FILE="/home/u811056906/projects/instagram-blog/rollback.log"

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

# 开始回滚
print_message "$BLUE" "========================================="
print_message "$BLUE" "🔄 Instagram 博客回滚工具"
print_message "$BLUE" "========================================="

# 检查备份目录
if [ ! -d "$BACKUP_DIR" ]; then
    error_exit "备份目录不存在: $BACKUP_DIR"
fi

# 列出可用的备份
print_message "$YELLOW" "\n📋 可用的备份文件:\n"
BACKUPS=($(ls -t "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null))

if [ ${#BACKUPS[@]} -eq 0 ]; then
    error_exit "没有找到备份文件"
fi

# 显示备份列表
for i in "${!BACKUPS[@]}"; do
    BACKUP_FILE="${BACKUPS[$i]}"
    BACKUP_NAME=$(basename "$BACKUP_FILE")
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    BACKUP_DATE=$(echo "$BACKUP_NAME" | sed 's/backup_\([0-9]\{8\}_[0-9]\{6\}\).*/\1/' | sed 's/_/ /')
    
    print_message "$BLUE" "  [$((i+1))] $BACKUP_NAME"
    print_message "$NC" "      大小: $BACKUP_SIZE | 日期: $BACKUP_DATE"
done

# 选择备份
echo ""
read -p "请选择要恢复的备份编号 (1-${#BACKUPS[@]}) 或输入完整文件名: " choice

# 确定备份文件
if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#BACKUPS[@]}" ]; then
    SELECTED_BACKUP="${BACKUPS[$((choice-1))]}"
elif [ -f "$BACKUP_DIR/$choice" ]; then
    SELECTED_BACKUP="$BACKUP_DIR/$choice"
elif [ -f "$choice" ]; then
    SELECTED_BACKUP="$choice"
else
    error_exit "无效的选择"
fi

BACKUP_NAME=$(basename "$SELECTED_BACKUP")
print_message "$YELLOW" "\n✅ 已选择: $BACKUP_NAME"

# 确认回滚
print_message "$RED" "\n⚠️  警告: 此操作将覆盖当前的生产环境！"
read -p "确定要继续吗? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    print_message "$YELLOW" "❌ 回滚已取消"
    exit 0
fi

# 开始回滚
print_message "$YELLOW" "\n🔄 开始回滚..."
log "开始回滚，使用备份: $BACKUP_NAME"

# 创建当前状态的备份
EMERGENCY_BACKUP="$BACKUP_DIR/emergency_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
if [ -d "$PROD_DIR" ] && [ "$(ls -A $PROD_DIR 2>/dev/null)" ]; then
    print_message "$YELLOW" "💾 创建紧急备份..."
    tar -czf "$EMERGENCY_BACKUP" -C "$PROD_DIR" . 2>/dev/null || {
        print_message "$YELLOW" "⚠️  紧急备份失败，继续回滚..."
    }
    if [ -f "$EMERGENCY_BACKUP" ]; then
        print_message "$GREEN" "✅ 紧急备份已创建: $EMERGENCY_BACKUP"
        log "紧急备份: $EMERGENCY_BACKUP"
    fi
fi

# 清空生产目录
print_message "$YELLOW" "🗑️  清空生产目录..."
rm -rf "$PROD_DIR"/*
rm -rf "$PROD_DIR"/.[!.]*
log "已清空生产目录"

# 解压备份
print_message "$YELLOW" "📦 恢复备份文件..."
if tar -xzf "$SELECTED_BACKUP" -C "$PROD_DIR" 2>/dev/null; then
    print_message "$GREEN" "✅ 备份恢复成功"
    log "备份恢复成功"
else
    error_exit "备份恢复失败"
fi

# 设置权限
print_message "$YELLOW" "🔐 设置文件权限..."
find "$PROD_DIR" -type f -exec chmod 644 {} \; 2>/dev/null || true
find "$PROD_DIR" -type d -exec chmod 755 {} \; 2>/dev/null || true
print_message "$GREEN" "✅ 权限设置完成"

# 验证恢复
print_message "$YELLOW" "🔍 验证恢复..."
if [ -f "$PROD_DIR/index.html" ]; then
    FILE_COUNT=$(find "$PROD_DIR" -type f | wc -l)
    TOTAL_SIZE=$(du -sh "$PROD_DIR" | cut -f1)
    print_message "$GREEN" "✅ 恢复验证成功"
    print_message "$BLUE" "📊 恢复统计: $FILE_COUNT 个文件, 总大小: $TOTAL_SIZE"
    log "恢复统计: $FILE_COUNT 个文件, 总大小: $TOTAL_SIZE"
else
    error_exit "恢复验证失败: index.html 不存在"
fi

# 完成
print_message "$GREEN" "\n========================================="
print_message "$GREEN" "✅ 回滚完成！"
print_message "$GREEN" "========================================="
print_message "$BLUE" "📦 使用的备份: $BACKUP_NAME"
print_message "$BLUE" "💾 紧急备份: $EMERGENCY_BACKUP"
print_message "$BLUE" "🌐 网站地址: https://lightcyan-lark-256774.hostingersite.com"
print_message "$BLUE" "📝 日志文件: $LOG_FILE"
print_message "$GREEN" "========================================="

log "回滚完成"

exit 0

