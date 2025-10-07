#!/bin/bash

# Decap CMS 测试脚本
# 用于验证 Decap CMS 迁移是否成功

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}   Decap CMS 迁移验证测试${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# 测试 1: 检查文件是否存在
echo -e "${YELLOW}📁 测试 1: 检查管理后台文件...${NC}"
if [ -f "static/admin/index.html" ] && [ -f "static/admin/config.yml" ]; then
    echo -e "${GREEN}✅ 管理后台文件存在${NC}"
else
    echo -e "${RED}❌ 管理后台文件缺失${NC}"
    exit 1
fi
echo ""

# 测试 2: 检查是否使用 Decap CMS
echo -e "${YELLOW}🔍 测试 2: 检查 CMS 版本...${NC}"
if grep -q "decap-cms" static/admin/index.html; then
    echo -e "${GREEN}✅ 已使用 Decap CMS${NC}"
    DECAP_VERSION=$(grep -o "decap-cms@[^/]*" static/admin/index.html | head -1)
    echo -e "${BLUE}   版本: ${DECAP_VERSION}${NC}"
else
    echo -e "${RED}❌ 仍在使用 Netlify CMS${NC}"
    exit 1
fi
echo ""

# 测试 3: 检查配置文件
echo -e "${YELLOW}⚙️  测试 3: 检查配置文件...${NC}"
if grep -q "git-gateway" static/admin/config.yml; then
    echo -e "${GREEN}✅ Git Gateway 配置正确${NC}"
else
    echo -e "${RED}❌ Git Gateway 配置错误${NC}"
    exit 1
fi

if grep -q "zh_Hans" static/admin/config.yml; then
    echo -e "${GREEN}✅ 中文界面已启用${NC}"
else
    echo -e "${YELLOW}⚠️  未启用中文界面${NC}"
fi
echo ""

# 测试 4: 检查 Git 状态
echo -e "${YELLOW}📊 测试 4: 检查 Git 状态...${NC}"
git fetch origin main --quiet
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})

if [ "$LOCAL" = "$REMOTE" ]; then
    echo -e "${GREEN}✅ 本地代码与远程同步${NC}"
else
    echo -e "${YELLOW}⚠️  本地代码与远程不同步${NC}"
    echo -e "${BLUE}   运行 'git pull origin main' 同步${NC}"
fi
echo ""

# 测试 5: 检查 Netlify 部署状态
echo -e "${YELLOW}🌐 测试 5: 检查 Netlify 部署...${NC}"
ADMIN_URL="https://rad-dasik-e25922.netlify.app/admin/"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$ADMIN_URL")

if [ "$HTTP_CODE" = "200" ]; then
    echo -e "${GREEN}✅ 管理后台可访问 (HTTP $HTTP_CODE)${NC}"
    echo -e "${BLUE}   URL: $ADMIN_URL${NC}"
else
    echo -e "${RED}❌ 管理后台无法访问 (HTTP $HTTP_CODE)${NC}"
fi
echo ""

# 测试 6: 检查 Identity 服务
echo -e "${YELLOW}🔐 测试 6: 检查 Netlify Identity...${NC}"
IDENTITY_URL="https://rad-dasik-e25922.netlify.app/.netlify/identity"
IDENTITY_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$IDENTITY_URL")

if [ "$IDENTITY_CODE" = "200" ]; then
    echo -e "${GREEN}✅ Netlify Identity 服务正常 (HTTP $IDENTITY_CODE)${NC}"
else
    echo -e "${YELLOW}⚠️  Netlify Identity 响应异常 (HTTP $IDENTITY_CODE)${NC}"
fi
echo ""

# 测试 7: 检查最近的提交
echo -e "${YELLOW}📝 测试 7: 检查最近的提交...${NC}"
echo -e "${BLUE}最近 3 次提交:${NC}"
git log --oneline -3 | while read line; do
    echo -e "${BLUE}   $line${NC}"
done
echo ""

# 总结
echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}✅ 测试完成！${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

echo -e "${YELLOW}📋 下一步操作:${NC}"
echo ""
echo -e "${BLUE}1. 清除浏览器缓存${NC}"
echo -e "   Chrome/Edge: Ctrl+Shift+Delete"
echo -e "   Firefox: Ctrl+Shift+Delete"
echo -e "   Safari: Cmd+Shift+Delete"
echo ""
echo -e "${BLUE}2. 访问管理后台${NC}"
echo -e "   ${ADMIN_URL}"
echo ""
echo -e "${BLUE}3. 使用 Netlify Identity 登录${NC}"
echo -e "   输入邮箱和密码"
echo ""
echo -e "${BLUE}4. 测试功能${NC}"
echo -e "   - 查看现有文章"
echo -e "   - 创建测试文章"
echo -e "   - 上传图片"
echo -e "   - 发布文章"
echo ""
echo -e "${GREEN}如果遇到问题，请查看:${NC}"
echo -e "${BLUE}   DECAP_CMS_MIGRATION_COMPLETE.md${NC}"
echo ""

