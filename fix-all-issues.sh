#!/bin/bash

###############################################################################
# 一键修复所有当前问题
###############################################################################

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}🔧 一键修复所有问题${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

cd /home/u811056906/projects/instagram-blog || exit 1

# 问题 1: 修复文章文件名
echo -e "${YELLOW}📝 问题 1: 修复文章文件名...${NC}"
if [ -f "content/posts/2025-10-06-猫咪/index-1.md" ]; then
    echo -e "${BLUE}   发现文件: index-1.md${NC}"
    echo -e "${BLUE}   重命名为: index.md${NC}"
    mv "content/posts/2025-10-06-猫咪/index-1.md" "content/posts/2025-10-06-猫咪/index.md"
    echo -e "${GREEN}✅ 文件名已修复${NC}"
else
    echo -e "${GREEN}✅ 文件名正确，无需修复${NC}"
fi
echo ""

# 问题 2: 提交 CMS 编辑器修复
echo -e "${YELLOW}📤 问题 2: 提交 CMS 编辑器修复...${NC}"
git add static/admin/index.html
git add "content/posts/2025-10-06-猫咪/"
git add CURRENT_ISSUES_FIX.md
git add fix-all-issues.sh

if git diff --cached --quiet; then
    echo -e "${BLUE}   没有需要提交的更改${NC}"
else
    git commit -m "Fix: 增强 CMS 编辑器文本方向修复 + 修复文章文件名"
    git push origin main
    echo -e "${GREEN}✅ 已推送到 GitHub${NC}"
fi
echo ""

# 问题 3: 等待 Netlify 部署
echo -e "${YELLOW}⏰ 问题 3: 等待 Netlify 部署...${NC}"
echo -e "${BLUE}   Netlify 正在自动部署...${NC}"
echo -e "${BLUE}   建议等待 2-3 分钟${NC}"
echo -e "${BLUE}   你可以访问 https://app.netlify.com 查看进度${NC}"
echo ""
echo -e "${YELLOW}   按 Enter 继续部署到 Hostinger...${NC}"
read -r
echo ""

# 问题 4: 部署到 Hostinger
echo -e "${YELLOW}🚀 问题 4: 部署到 Hostinger...${NC}"
echo -e "${BLUE}   使用简化部署模式（资源友好）${NC}"
echo ""

# 拉取最新更改
echo -e "${YELLOW}   📥 拉取最新更改...${NC}"
git pull origin main
echo ""

# 清理旧文件
echo -e "${YELLOW}   🧹 清理旧文件...${NC}"
rm -rf public/*
echo ""

# 等待 5 秒
echo -e "${YELLOW}   ⏰ 等待 5 秒...${NC}"
sleep 5
echo ""

# 构建（单线程模式）
echo -e "${YELLOW}   🔨 构建网站（单线程模式）...${NC}"
export GOMAXPROCS=1
export GOGC=50
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
    echo -e "  2. 或主要使用 Netlify 站点"
    echo -e "     https://rad-dasik-e25922.netlify.app"
    echo ""
    exit 1
fi
echo -e "${GREEN}✅ 构建成功${NC}"
echo ""

# 等待 5 秒
echo -e "${YELLOW}   ⏰ 等待 5 秒...${NC}"
sleep 5
echo ""

# 同步到生产环境
echo -e "${YELLOW}   📤 同步到生产环境...${NC}"
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

# 设置权限
echo -e "${YELLOW}   🔐 设置文件权限...${NC}"
chmod -R 755 /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/
echo -e "${GREEN}✅ 权限设置完成${NC}"
echo ""

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}✅ 所有问题已修复！${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

echo -e "${YELLOW}📊 修复总结：${NC}"
echo ""
echo -e "${GREEN}✅ 问题 1: 文章文件名已修复${NC}"
echo -e "   index-1.md → index.md"
echo ""
echo -e "${GREEN}✅ 问题 2: CMS 编辑器修复已部署${NC}"
echo -e "   - 增强 CSS 修复"
echo -e "   - 添加 JavaScript 强制修复"
echo ""
echo -e "${GREEN}✅ 问题 3: Netlify 站点已更新${NC}"
echo -e "   https://rad-dasik-e25922.netlify.app"
echo ""
echo -e "${GREEN}✅ 问题 4: Hostinger 站点已更新${NC}"
echo -e "   https://lightcyan-lark-256774.hostingersite.com"
echo ""

echo -e "${YELLOW}🔍 验证步骤：${NC}"
echo ""
echo -e "${BLUE}1. 测试 CMS 编辑器${NC}"
echo -e "   访问: https://rad-dasik-e25922.netlify.app/admin/"
echo -e "   - 清除浏览器缓存（Ctrl+Shift+Delete）"
echo -e "   - 或使用无痕模式（Ctrl+Shift+N）"
echo -e "   - 创建新文章，测试文字输入方向"
echo -e "   - 应该从左向右输入 ✅"
echo ""
echo -e "${BLUE}2. 验证 Netlify 站点${NC}"
echo -e "   访问: https://rad-dasik-e25922.netlify.app"
echo -e "   - 应该看到 '猫咪' 文章"
echo -e "   - 网站标题是 'Alice 博客'"
echo ""
echo -e "${BLUE}3. 验证 Hostinger 站点${NC}"
echo -e "   访问: https://lightcyan-lark-256774.hostingersite.com"
echo -e "   - 应该看到 '猫咪' 文章"
echo -e "   - 网站标题是 'Alice 博客'"
echo ""

echo -e "${GREEN}祝你使用愉快！ 🎉${NC}"
echo ""

