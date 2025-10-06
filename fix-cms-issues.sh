#!/bin/bash

###############################################################################
# CMS 问题一键修复脚本
###############################################################################

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}🔧 CMS 问题一键修复${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

cd /home/u811056906/projects/instagram-blog || exit 1

# 1. 提交文本方向修复
echo -e "${YELLOW}📝 步骤 1/5: 提交文本方向修复...${NC}"
git add static/admin/index.html
if git diff --cached --quiet; then
    echo -e "${BLUE}   没有需要提交的更改${NC}"
else
    git commit -m "Fix: RTL text direction issue in CMS editor"
    git push origin main
    echo -e "${GREEN}✅ 已推送到 GitHub${NC}"
fi
echo ""

# 2. 等待 Netlify 部署
echo -e "${YELLOW}⏰ 步骤 2/5: 等待 Netlify 部署...${NC}"
echo -e "${BLUE}   建议等待 2-3 分钟让 Netlify 完成部署${NC}"
echo -e "${BLUE}   你可以访问 https://app.netlify.com 查看部署进度${NC}"
echo ""
echo -e "${YELLOW}   按 Enter 继续，或等待 2 分钟后按 Enter...${NC}"
read -r
echo ""

# 3. 拉取最新更改
echo -e "${YELLOW}📥 步骤 3/5: 拉取最新更改...${NC}"
git pull origin main
echo -e "${GREEN}✅ 已拉取最新代码${NC}"
echo ""

# 4. 检查文章状态
echo -e "${YELLOW}🔍 步骤 4/5: 检查文章状态...${NC}"
if [ -f "content/posts/2025-10-06-猫咪/index.md" ]; then
    echo -e "${BLUE}   找到文章: 猫咪${NC}"
    
    # 检查是否是草稿
    if grep -q "draft: true" "content/posts/2025-10-06-猫咪/index.md"; then
        echo -e "${RED}   ⚠️  文章是草稿状态！${NC}"
        echo -e "${YELLOW}   需要在 CMS 中将文章改为发布状态${NC}"
        echo ""
        echo -e "${BLUE}   操作步骤：${NC}"
        echo -e "${BLUE}   1. 访问: https://rad-dasik-e25922.netlify.app/admin/${NC}"
        echo -e "${BLUE}   2. 点击 '工作流' 标签${NC}"
        echo -e "${BLUE}   3. 找到 '猫咪' 文章${NC}"
        echo -e "${BLUE}   4. 将文章拖到 'Ready' 列${NC}"
        echo -e "${BLUE}   5. 点击 '发布'${NC}"
        echo ""
    else
        echo -e "${GREEN}   ✅ 文章已发布${NC}"
    fi
else
    echo -e "${BLUE}   没有找到新文章${NC}"
fi
echo ""

# 5. 部署到 Hostinger
echo -e "${YELLOW}🚀 步骤 5/5: 部署到 Hostinger...${NC}"
bash deploy.sh
echo ""

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}✅ 修复完成！${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

echo -e "${YELLOW}📋 验证步骤：${NC}"
echo ""
echo -e "${BLUE}1. 测试文本方向修复${NC}"
echo -e "   访问: https://rad-dasik-e25922.netlify.app/admin/"
echo -e "   创建新文章，测试文字输入方向"
echo -e "   应该从左向右输入 ✅"
echo ""
echo -e "${BLUE}2. 发布草稿文章${NC}"
echo -e "   在 CMS 中将 '猫咪' 文章改为发布状态"
echo -e "   （如果还是草稿的话）"
echo ""
echo -e "${BLUE}3. 验证文章显示${NC}"
echo -e "   Netlify: https://rad-dasik-e25922.netlify.app"
echo -e "   Hostinger: https://lightcyan-lark-256774.hostingersite.com"
echo ""
echo -e "${GREEN}祝你使用愉快！ 🎉${NC}"
echo ""

