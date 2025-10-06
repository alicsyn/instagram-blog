#!/bin/bash

###############################################################################
# Instagram 博客快速启动脚本
# 用于首次部署和测试
###############################################################################

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}📸 Instagram 博客快速启动${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# 项目目录
PROJECT_DIR="/home/u811056906/projects/instagram-blog"
HUGO_BIN="/home/u811056906/bin/hugo"

cd "$PROJECT_DIR" || exit 1

# 1. 检查 Hugo
echo -e "${YELLOW}1. 检查 Hugo...${NC}"
if [ -f "$HUGO_BIN" ]; then
    echo -e "${GREEN}✅ Hugo 已安装${NC}"
    $HUGO_BIN version
else
    echo -e "${RED}❌ Hugo 未找到${NC}"
    exit 1
fi
echo ""

# 2. 检查项目结构
echo -e "${YELLOW}2. 检查项目结构...${NC}"
if [ -f "hugo.toml" ] && [ -d "themes/instagram" ]; then
    echo -e "${GREEN}✅ 项目结构正常${NC}"
else
    echo -e "${RED}❌ 项目结构不完整${NC}"
    exit 1
fi
echo ""

# 3. 测试构建
echo -e "${YELLOW}3. 测试构建网站...${NC}"
if $HUGO_BIN --minify --cleanDestinationDir; then
    echo -e "${GREEN}✅ 构建成功${NC}"
    
    # 统计信息
    FILE_COUNT=$(find public -type f | wc -l)
    TOTAL_SIZE=$(du -sh public | cut -f1)
    echo -e "${BLUE}📊 生成了 $FILE_COUNT 个文件，总大小: $TOTAL_SIZE${NC}"
else
    echo -e "${RED}❌ 构建失败${NC}"
    exit 1
fi
echo ""

# 4. 显示下一步
echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}✅ 快速启动完成！${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""
echo -e "${YELLOW}📋 下一步操作：${NC}"
echo ""
echo -e "  ${BLUE}1.${NC} 查看构建结果："
echo -e "     ls -la public/"
echo ""
echo -e "  ${BLUE}2.${NC} 部署到生产环境："
echo -e "     ./deploy.sh"
echo ""
echo -e "  ${BLUE}3.${NC} 访问网站："
echo -e "     https://lightcyan-lark-256774.hostingersite.com"
echo ""
echo -e "  ${BLUE}4.${NC} 访问管理后台（配置后）："
echo -e "     https://lightcyan-lark-256774.hostingersite.com/admin/"
echo ""
echo -e "${YELLOW}📚 查看完整文档：${NC}"
echo -e "  cat README.md"
echo -e "  cat INSTALLATION.md"
echo ""
echo -e "${GREEN}祝你使用愉快！ 🎉${NC}"
echo ""

