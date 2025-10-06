#!/bin/bash

###############################################################################
# 简化部署脚本 - 降低资源使用，避免 CPU 限制
###############################################################################

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}🚀 简化部署模式（资源友好）${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

cd /home/u811056906/projects/instagram-blog || exit 1

# 1. 拉取最新更改
echo -e "${YELLOW}📥 步骤 1/7: 拉取最新更改...${NC}"
git pull origin main
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Git 拉取失败${NC}"
    exit 1
fi
echo -e "${GREEN}✅ 拉取成功${NC}"
echo ""

# 2. 清理旧的构建文件
echo -e "${YELLOW}🧹 步骤 2/7: 清理旧文件...${NC}"
rm -rf public/*
echo -e "${GREEN}✅ 清理完成${NC}"
echo ""

# 3. 等待 5 秒（让系统稳定）
echo -e "${YELLOW}⏰ 步骤 3/7: 等待 5 秒...${NC}"
sleep 5
echo -e "${GREEN}✅ 等待完成${NC}"
echo ""

# 4. 使用单线程模式构建
echo -e "${YELLOW}🔨 步骤 4/7: 构建网站（单线程模式）...${NC}"
echo -e "${BLUE}   使用 GOMAXPROCS=1 限制 CPU 使用${NC}"

# 设置环境变量限制资源使用
export GOMAXPROCS=1
export GOGC=50

# 执行构建
/home/u811056906/bin/hugo --minify --cleanDestinationDir 2>&1

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 构建失败${NC}"
    echo ""
    echo -e "${YELLOW}可能的原因：${NC}"
    echo -e "  1. CPU 资源仍然不足"
    echo -e "  2. 系统进程限制"
    echo ""
    echo -e "${YELLOW}建议：${NC}"
    echo -e "  1. 等待 10-15 分钟后重试"
    echo -e "  2. 或使用 Netlify 自动部署"
    echo ""
    exit 1
fi

echo -e "${GREEN}✅ 构建成功${NC}"
echo ""

# 5. 等待 5 秒（让系统稳定）
echo -e "${YELLOW}⏰ 步骤 5/7: 等待 5 秒...${NC}"
sleep 5
echo -e "${GREEN}✅ 等待完成${NC}"
echo ""

# 6. 同步到生产环境
echo -e "${YELLOW}📤 步骤 6/7: 同步到生产环境...${NC}"
rsync -av --delete \
    --exclude='.git' \
    --exclude='.gitignore' \
    --exclude='README.md' \
    --exclude='*.sh' \
    public/ \
    /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 同步失败${NC}"
    exit 1
fi

echo -e "${GREEN}✅ 同步完成${NC}"
echo ""

# 7. 设置权限
echo -e "${YELLOW}🔐 步骤 7/7: 设置文件权限...${NC}"
chmod -R 755 /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/
echo -e "${GREEN}✅ 权限设置完成${NC}"
echo ""

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}✅ 部署完成！${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""
echo -e "${YELLOW}📊 部署信息：${NC}"
echo -e "  网站地址: https://lightcyan-lark-256774.hostingersite.com"
echo -e "  部署时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo -e "  构建模式: 单线程（资源友好）"
echo ""
echo -e "${YELLOW}💡 提示：${NC}"
echo -e "  如果经常遇到 CPU 限制，建议主要使用 Netlify 站点"
echo -e "  Netlify: https://rad-dasik-e25922.netlify.app"
echo ""

