#!/bin/bash

# 切换到 GitHub OAuth Backend 脚本
# 用于将 Decap CMS 从 Netlify Identity 切换到 GitHub OAuth

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}🔐 切换到 GitHub OAuth Backend${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# 检查当前配置
echo -e "${YELLOW}📋 步骤 1/5: 检查当前配置...${NC}"
if grep -q "name: git-gateway" static/admin/config.yml; then
    echo -e "${CYAN}   当前使用: Git Gateway (Netlify Identity)${NC}"
    echo -e "${YELLOW}   将切换到: GitHub OAuth${NC}"
elif grep -q "name: github" static/admin/config.yml; then
    echo -e "${GREEN}✅ 已经使用 GitHub OAuth Backend${NC}"
    echo -e "${YELLOW}   无需切换${NC}"
    exit 0
else
    echo -e "${RED}❌ 无法识别当前配置${NC}"
    exit 1
fi
echo ""

# 获取 GitHub 仓库信息
echo -e "${YELLOW}📋 步骤 2/5: 获取 GitHub 仓库信息...${NC}"
REMOTE_URL=$(git config --get remote.origin.url)
echo -e "${CYAN}   远程仓库: $REMOTE_URL${NC}"

# 提取仓库名称
if [[ $REMOTE_URL =~ github\.com[:/](.+)\.git ]]; then
    REPO_NAME="${BASH_REMATCH[1]}"
elif [[ $REMOTE_URL =~ github\.com[:/](.+) ]]; then
    REPO_NAME="${BASH_REMATCH[1]}"
else
    echo -e "${RED}❌ 无法从远程 URL 提取仓库名称${NC}"
    echo -e "${YELLOW}   请手动输入仓库名称（格式: 用户名/仓库名）:${NC}"
    read -r REPO_NAME
fi

echo -e "${GREEN}   仓库名称: $REPO_NAME${NC}"
echo ""

# 确认操作
echo -e "${YELLOW}📋 步骤 3/5: 确认操作...${NC}"
echo -e "${CYAN}   即将进行以下操作:${NC}"
echo -e "${CYAN}   1. 备份当前配置文件${NC}"
echo -e "${CYAN}   2. 修改 backend 为 github${NC}"
echo -e "${CYAN}   3. 设置 repo 为: $REPO_NAME${NC}"
echo -e "${CYAN}   4. 移除 local_backend 配置（如果有）${NC}"
echo ""
echo -e "${YELLOW}   是否继续? (y/n): ${NC}"
read -r CONFIRM

if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
    echo -e "${RED}❌ 操作已取消${NC}"
    exit 0
fi
echo ""

# 备份配置文件
echo -e "${YELLOW}📋 步骤 4/5: 备份配置文件...${NC}"
BACKUP_FILE="static/admin/config.yml.backup.$(date +%Y%m%d_%H%M%S)"
cp static/admin/config.yml "$BACKUP_FILE"
echo -e "${GREEN}✅ 已备份到: $BACKUP_FILE${NC}"
echo ""

# 修改配置文件
echo -e "${YELLOW}📋 步骤 5/5: 修改配置文件...${NC}"

# 创建临时文件
TEMP_FILE=$(mktemp)

# 使用 awk 处理配置文件
awk -v repo="$REPO_NAME" '
BEGIN { in_backend = 0; backend_done = 0 }

# 检测 backend 部分开始
/^backend:/ {
    in_backend = 1
    print "# 后端配置"
    print "backend:"
    print "  name: github"
    print "  repo: " repo
    print "  branch: main"
    print "  use_graphql: true"
    backend_done = 1
    next
}

# 跳过 backend 部分的其他行
in_backend && /^  / {
    next
}

# backend 部分结束
in_backend && !/^  / {
    in_backend = 0
}

# 移除 local_backend
/^local_backend:/ {
    next
}

# 保留其他所有行
!in_backend {
    print
}
' static/admin/config.yml > "$TEMP_FILE"

# 替换原文件
mv "$TEMP_FILE" static/admin/config.yml

echo -e "${GREEN}✅ 配置文件已更新${NC}"
echo ""

# 显示更改
echo -e "${BLUE}=========================================${NC}"
echo -e "${CYAN}📝 配置更改:${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""
echo -e "${CYAN}新的 backend 配置:${NC}"
grep -A 5 "^backend:" static/admin/config.yml
echo ""

# 提示下一步操作
echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}✅ 配置文件修改完成！${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

echo -e "${YELLOW}📋 下一步操作:${NC}"
echo ""
echo -e "${CYAN}1️⃣  创建 GitHub OAuth App${NC}"
echo -e "   访问: ${BLUE}https://github.com/settings/developers${NC}"
echo -e "   点击: New OAuth App"
echo -e "   填写:"
echo -e "     Application name: Instagram Blog CMS"
echo -e "     Homepage URL: https://rad-dasik-e25922.netlify.app"
echo -e "     Callback URL: https://api.netlify.com/auth/done"
echo -e "   复制 Client ID 和 Client Secret"
echo ""

echo -e "${CYAN}2️⃣  配置 Netlify OAuth${NC}"
echo -e "   访问: ${BLUE}https://app.netlify.com${NC}"
echo -e "   进入站点: rad-dasik-e25922"
echo -e "   Site settings → Access control → OAuth"
echo -e "   Install provider → GitHub"
echo -e "   粘贴 Client ID 和 Client Secret"
echo ""

echo -e "${CYAN}3️⃣  提交并部署${NC}"
echo -e "   ${GREEN}git add static/admin/config.yml${NC}"
echo -e "   ${GREEN}git commit -m \"Config: Switch to GitHub OAuth backend\"${NC}"
echo -e "   ${GREEN}git push origin main${NC}"
echo ""

echo -e "${CYAN}4️⃣  测试登录${NC}"
echo -e "   等待 Netlify 部署完成（2-3 分钟）"
echo -e "   清除浏览器缓存"
echo -e "   访问: ${BLUE}https://rad-dasik-e25922.netlify.app/admin/${NC}"
echo -e "   点击 \"Login with GitHub\""
echo ""

echo -e "${BLUE}=========================================${NC}"
echo -e "${YELLOW}📚 详细指南:${NC}"
echo -e "   查看: ${GREEN}GITHUB_OAUTH_SETUP_GUIDE.md${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# 询问是否立即提交
echo -e "${YELLOW}是否立即提交更改到 GitHub? (y/n): ${NC}"
read -r COMMIT_NOW

if [[ $COMMIT_NOW =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${YELLOW}📤 提交更改...${NC}"
    
    git add static/admin/config.yml
    git commit -m "Config: Switch to GitHub OAuth backend"
    
    echo ""
    echo -e "${YELLOW}📤 推送到 GitHub...${NC}"
    git push origin main
    
    echo ""
    echo -e "${GREEN}✅ 已推送到 GitHub${NC}"
    echo -e "${YELLOW}⏰ 等待 Netlify 部署完成（2-3 分钟）${NC}"
    echo ""
    echo -e "${CYAN}在完成 GitHub OAuth App 和 Netlify OAuth 配置后:${NC}"
    echo -e "   访问: ${BLUE}https://rad-dasik-e25922.netlify.app/admin/${NC}"
else
    echo ""
    echo -e "${YELLOW}⚠️  记得手动提交更改:${NC}"
    echo -e "   ${GREEN}git add static/admin/config.yml${NC}"
    echo -e "   ${GREEN}git commit -m \"Config: Switch to GitHub OAuth backend\"${NC}"
    echo -e "   ${GREEN}git push origin main${NC}"
fi

echo ""
echo -e "${GREEN}🎉 脚本执行完成！${NC}"
echo ""

