#!/bin/bash

###############################################################################
# Netlify Identity 修复和部署脚本
###############################################################################

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}🔧 Netlify Identity 修复和部署${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# 进入项目目录
cd /home/u811056906/projects/instagram-blog || exit 1

# 1. 检查更改
echo -e "${YELLOW}📋 检查文件更改...${NC}"
git status
echo ""

# 2. 添加更改
echo -e "${YELLOW}➕ 添加更改到 Git...${NC}"
git add themes/instagram/layouts/_default/baseof.html
git add static/admin/index.html
echo -e "${GREEN}✅ 文件已添加${NC}"
echo ""

# 3. 提交更改
echo -e "${YELLOW}💾 提交更改...${NC}"
git commit -m "Fix: Add Netlify Identity Widget for password setup"
echo -e "${GREEN}✅ 更改已提交${NC}"
echo ""

# 4. 推送到 GitHub
echo -e "${YELLOW}📤 推送到 GitHub...${NC}"
echo -e "${BLUE}提示: 如果需要输入凭据，请使用 Personal Access Token${NC}"
git push origin main
echo -e "${GREEN}✅ 已推送到 GitHub${NC}"
echo ""

# 5. 等待提示
echo -e "${YELLOW}⏰ 请等待 2-3 分钟让 Netlify 自动部署...${NC}"
echo ""
echo -e "${BLUE}你可以在 Netlify 控制面板查看部署进度：${NC}"
echo -e "${BLUE}https://app.netlify.com${NC}"
echo ""

# 6. 询问是否继续部署到 Hostinger
read -p "是否现在部署到 Hostinger? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo -e "${YELLOW}🚀 开始部署到 Hostinger...${NC}"
    bash deploy.sh
else
    echo -e "${YELLOW}⏸️  跳过 Hostinger 部署${NC}"
    echo -e "${BLUE}稍后可以手动运行: bash deploy.sh${NC}"
fi

echo ""
echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}✅ 修复完成！${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""
echo -e "${YELLOW}📝 下一步操作：${NC}"
echo ""
echo -e "  ${BLUE}1.${NC} 等待 Netlify 部署完成（2-3 分钟）"
echo -e "     查看: https://app.netlify.com"
echo ""
echo -e "  ${BLUE}2.${NC} 在 Netlify 控制面板重新发送邀请"
echo -e "     Identity → 你的邮箱 → ... → Resend invite"
echo ""
echo -e "  ${BLUE}3.${NC} 检查邮件并点击邀请链接"
echo ""
echo -e "  ${BLUE}4.${NC} 现在应该看到密码设置表单了！"
echo ""
echo -e "  ${BLUE}5.${NC} 设置密码并登录"
echo -e "     https://rad-dasik-e25922.netlify.app/admin/"
echo ""
echo -e "${GREEN}祝你成功！ 🎉${NC}"
echo ""

