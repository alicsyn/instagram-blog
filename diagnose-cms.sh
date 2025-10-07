#!/bin/bash
# Netlify CMS 登录问题诊断脚本

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}🔍 Netlify CMS 登录问题诊断${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

SITE_URL="https://rad-dasik-e25922.netlify.app"

# 1. 检查 Identity 服务
echo -e "${YELLOW}1️⃣  检查 Netlify Identity 服务...${NC}"
IDENTITY_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$SITE_URL/.netlify/identity/settings")

if [ "$IDENTITY_CODE" = "200" ]; then
    echo -e "${GREEN}✅ Identity 服务正常 (HTTP $IDENTITY_CODE)${NC}"
else
    echo -e "${RED}❌ Identity 服务异常 (HTTP $IDENTITY_CODE)${NC}"
fi
echo ""

# 2. 检查本地配置
echo -e "${YELLOW}2️⃣  检查本地配置文件...${NC}"

if grep -q "local_backend: true" static/admin/config.yml 2>/dev/null; then
    echo -e "${RED}❌ 发现 local_backend: true（这会导致登录失败）${NC}"
else
    echo -e "${GREEN}✅ 无 local_backend 配置${NC}"
fi

if grep -q "netlify-cms@" static/admin/index.html 2>/dev/null; then
    echo -e "${YELLOW}⚠️  使用旧版 Netlify CMS（已停止维护）${NC}"
    echo -e "${YELLOW}   建议: 迁移到 Decap CMS${NC}"
elif grep -q "decap-cms@" static/admin/index.html 2>/dev/null; then
    echo -e "${GREEN}✅ 使用 Decap CMS${NC}"
fi
echo ""

echo -e "${BLUE}=========================================${NC}"
echo -e "${YELLOW}推荐操作:${NC}"
echo -e "  ${GREEN}1. 迁移到 Decap CMS（5 分钟）${NC}"
echo -e "  ${GREEN}2. 查看完整方案: cat CMS_LOGIN_DIAGNOSIS_AND_ALTERNATIVES.md${NC}"
echo -e "${BLUE}=========================================${NC}"

