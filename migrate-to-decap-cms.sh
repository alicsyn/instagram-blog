#!/bin/bash

###############################################################################
# 一键迁移到 Decap CMS - 解决登录问题
###############################################################################

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}🚀 迁移到 Decap CMS${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

echo -e "${YELLOW}📋 关于 Decap CMS:${NC}"
echo -e "  • Netlify CMS 的官方继任者"
echo -e "  • 完全兼容现有配置"
echo -e "  • 修复了登录和兼容性问题"
echo -e "  • 持续维护和更新"
echo -e "  • 免费开源"
echo ""

echo -e "${YELLOW}⏰ 预计时间: 5 分钟${NC}"
echo ""

read -p "按 Enter 开始迁移..." 

cd /home/u811056906/projects/instagram-blog || exit 1

# 1. 备份原文件
echo -e "${YELLOW}📦 备份原文件...${NC}"
cp static/admin/index.html static/admin/index.html.backup
echo -e "${GREEN}✅ 已备份到 index.html.backup${NC}"
echo ""

# 2. 替换 CMS 脚本
echo -e "${YELLOW}🔄 替换 CMS 脚本...${NC}"

# 使用 sed 替换
sed -i 's|https://unpkg.com/netlify-cms@\^2.0.0/dist/netlify-cms.js|https://unpkg.com/decap-cms@^3.0.0/dist/decap-cms.js|g' static/admin/index.html

if grep -q "decap-cms" static/admin/index.html; then
    echo -e "${GREEN}✅ 已替换为 Decap CMS${NC}"
else
    echo -e "${RED}❌ 替换失败，请手动检查${NC}"
    exit 1
fi
echo ""

# 3. 验证修改
echo -e "${YELLOW}🔍 验证修改...${NC}"
echo -e "${BLUE}修改内容:${NC}"
grep -n "decap-cms" static/admin/index.html
echo ""

# 4. 提交到 Git
echo -e "${YELLOW}📤 提交到 Git...${NC}"
git add static/admin/index.html
git add static/admin/index.html.backup

if git diff --cached --quiet; then
    echo -e "${YELLOW}⚠️  没有需要提交的更改${NC}"
else
    git commit -m "Upgrade: 迁移到 Decap CMS 解决登录问题

- 从 Netlify CMS v2 迁移到 Decap CMS v3
- Decap CMS 是 Netlify CMS 的官方继任者
- 修复登录和浏览器兼容性问题
- 完全兼容现有配置，零配置迁移"
    
    echo -e "${GREEN}✅ 已提交到本地仓库${NC}"
fi
echo ""

# 5. 推送到 GitHub
echo -e "${YELLOW}🚀 推送到 GitHub...${NC}"
git push origin main

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ 已推送到 GitHub${NC}"
else
    echo -e "${RED}❌ 推送失败，请检查网络连接${NC}"
    exit 1
fi
echo ""

# 6. 等待 Netlify 部署
echo -e "${YELLOW}⏰ 等待 Netlify 部署...${NC}"
echo -e "${BLUE}   Netlify 正在自动部署新版本...${NC}"
echo -e "${BLUE}   预计需要 2-3 分钟${NC}"
echo ""
echo -e "${BLUE}   你可以访问以下链接查看部署进度:${NC}"
echo -e "${BLUE}   https://app.netlify.com/sites/rad-dasik-e25922/deploys${NC}"
echo ""

echo -e "${YELLOW}   等待 30 秒后继续...${NC}"
for i in {30..1}; do
    echo -ne "   ${i} 秒\r"
    sleep 1
done
echo ""
echo ""

# 7. 测试新版本
echo -e "${YELLOW}🧪 测试新版本...${NC}"
echo -e "${BLUE}   检查 Decap CMS 是否加载...${NC}"

sleep 5

ADMIN_PAGE=$(curl -s https://rad-dasik-e25922.netlify.app/admin/)

if echo "$ADMIN_PAGE" | grep -q "decap-cms"; then
    echo -e "${GREEN}✅ Decap CMS 已成功部署！${NC}"
else
    echo -e "${YELLOW}⚠️  可能还在部署中，请稍后再试${NC}"
fi
echo ""

# 8. 完成
echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}✅ 迁移完成！${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

echo -e "${YELLOW}📊 迁移总结:${NC}"
echo ""
echo -e "${GREEN}✅ 已从 Netlify CMS v2 迁移到 Decap CMS v3${NC}"
echo -e "${GREEN}✅ 已提交并推送到 GitHub${NC}"
echo -e "${GREEN}✅ Netlify 正在自动部署${NC}"
echo ""

echo -e "${YELLOW}🔍 下一步验证:${NC}"
echo ""
echo -e "${BLUE}1. 清除浏览器缓存${NC}"
echo -e "   Chrome/Edge: Ctrl + Shift + Delete"
echo -e "   选择 '缓存的图片和文件'"
echo -e "   时间范围: '过去 1 小时'"
echo -e "   点击 '清除数据'"
echo ""

echo -e "${BLUE}2. 或使用无痕模式${NC}"
echo -e "   Chrome/Edge: Ctrl + Shift + N"
echo ""

echo -e "${BLUE}3. 访问管理后台${NC}"
echo -e "   https://rad-dasik-e25922.netlify.app/admin/"
echo ""

echo -e "${BLUE}4. 尝试登录${NC}"
echo -e "   - 应该看到 Netlify Identity 登录框"
echo -e "   - 输入邮箱和密码"
echo -e "   - 登录应该成功"
echo ""

echo -e "${YELLOW}💡 如果仍然无法登录:${NC}"
echo ""
echo -e "${BLUE}1. 检查 Netlify 控制台${NC}"
echo -e "   访问: https://app.netlify.com"
echo -e "   进入: Site → Identity"
echo -e "   确认: Enable Identity 已开启"
echo -e "   进入: Services → Git Gateway"
echo -e "   确认: Enable Git Gateway 已开启"
echo ""

echo -e "${BLUE}2. 检查用户账号${NC}"
echo -e "   进入: Identity → Users"
echo -e "   确认: 你的邮箱在列表中"
echo -e "   如果没有: 点击 'Invite users' 添加"
echo ""

echo -e "${BLUE}3. 在浏览器 Console 执行${NC}"
echo -e "   F12 → Console → 输入:"
echo -e "   window.netlifyIdentity"
echo -e "   应该返回一个对象（不是 undefined）"
echo ""

echo -e "${BLUE}4. 强制唤起登录框${NC}"
echo -e "   在 Console 输入:"
echo -e "   window.netlifyIdentity.open()"
echo ""

echo -e "${YELLOW}📚 查看完整诊断报告:${NC}"
echo -e "   cat CMS_LOGIN_DIAGNOSIS_AND_ALTERNATIVES.md"
echo ""

echo -e "${YELLOW}🔄 如果需要回滚:${NC}"
echo -e "   cp static/admin/index.html.backup static/admin/index.html"
echo -e "   git add static/admin/index.html"
echo -e "   git commit -m 'Rollback: 回滚到 Netlify CMS'"
echo -e "   git push origin main"
echo ""

echo -e "${GREEN}祝你使用愉快！ 🎉${NC}"
echo ""

