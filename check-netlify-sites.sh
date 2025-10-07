#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}🔍 检查 Netlify 站点状态${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

SITE1="https://rad-dasik-e25922.netlify.app"
SITE2="https://kaleidoscopic-choux-d28ea2.netlify.app"

# 检查站点 1
echo -e "${YELLOW}站点 1: rad-dasik-e25922${NC}"
echo -e "${BLUE}URL: $SITE1${NC}"
STATUS1=$(curl -s -o /dev/null -w "%{http_code}" "$SITE1/")
if [ "$STATUS1" = "200" ]; then
    echo -e "${GREEN}✅ 状态: HTTP $STATUS1 (正常)${NC}"
else
    echo -e "${RED}❌ 状态: HTTP $STATUS1 (异常)${NC}"
fi

# 检查管理后台
ADMIN1=$(curl -s -o /dev/null -w "%{http_code}" "$SITE1/admin/")
if [ "$ADMIN1" = "200" ]; then
    echo -e "${GREEN}✅ 管理后台: HTTP $ADMIN1 (可访问)${NC}"
else
    echo -e "${RED}❌ 管理后台: HTTP $ADMIN1 (不可访问)${NC}"
fi

# 检查 Decap CMS
if curl -s "$SITE1/admin/" | grep -q "decap-cms"; then
    echo -e "${GREEN}✅ CMS: Decap CMS 已加载${NC}"
elif curl -s "$SITE1/admin/" | grep -q "netlify-cms"; then
    echo -e "${YELLOW}⚠️  CMS: 仍使用 Netlify CMS${NC}"
else
    echo -e "${RED}❌ CMS: 未检测到 CMS${NC}"
fi
echo ""

# 检查站点 2
echo -e "${YELLOW}站点 2: kaleidoscopic-choux-d28ea2${NC}"
echo -e "${BLUE}URL: $SITE2${NC}"
STATUS2=$(curl -s -o /dev/null -w "%{http_code}" "$SITE2/")
if [ "$STATUS2" = "200" ]; then
    echo -e "${GREEN}✅ 状态: HTTP $STATUS2 (正常)${NC}"
elif [ "$STATUS2" = "404" ]; then
    echo -e "${RED}❌ 状态: HTTP $STATUS2 (页面不存在)${NC}"
else
    echo -e "${YELLOW}⚠️  状态: HTTP $STATUS2${NC}"
fi

# 检查管理后台
ADMIN2=$(curl -s -o /dev/null -w "%{http_code}" "$SITE2/admin/")
if [ "$ADMIN2" = "200" ]; then
    echo -e "${GREEN}✅ 管理后台: HTTP $ADMIN2 (可访问)${NC}"
else
    echo -e "${RED}❌ 管理后台: HTTP $ADMIN2 (不可访问)${NC}"
fi
echo ""

# 检查本地配置
echo -e "${YELLOW}本地配置检查:${NC}"
CONFIG_SITE=$(grep "site_url:" static/admin/config.yml | head -1)
echo -e "${BLUE}$CONFIG_SITE${NC}"

if echo "$CONFIG_SITE" | grep -q "rad-dasik-e25922"; then
    echo -e "${GREEN}✅ 配置指向: rad-dasik-e25922 (站点 1)${NC}"
elif echo "$CONFIG_SITE" | grep -q "kaleidoscopic-choux-d28ea2"; then
    echo -e "${YELLOW}⚠️  配置指向: kaleidoscopic-choux-d28ea2 (站点 2)${NC}"
else
    echo -e "${RED}❌ 配置指向: 未知站点${NC}"
fi
echo ""

# 总结
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}📊 总结${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

if [ "$STATUS1" = "200" ] && [ "$STATUS2" = "404" ]; then
    echo -e "${GREEN}✅ 站点 1 (rad-dasik-e25922) 正常工作${NC}"
    echo -e "${RED}❌ 站点 2 (kaleidoscopic-choux-d28ea2) 返回 404${NC}"
    echo ""
    echo -e "${YELLOW}推荐操作:${NC}"
    echo -e "  1. 保留站点 1 (rad-dasik-e25922)"
    echo -e "  2. 在 Netlify 控制台删除站点 2"
    echo -e "  3. 继续使用站点 1"
    echo ""
    echo -e "${BLUE}详细步骤:${NC}"
    echo -e "  cat NETLIFY_SITE_ISSUE_DIAGNOSIS.md"
elif [ "$STATUS1" = "200" ] && [ "$STATUS2" = "200" ]; then
    echo -e "${GREEN}✅ 两个站点都正常工作${NC}"
    echo ""
    echo -e "${YELLOW}推荐操作:${NC}"
    echo -e "  1. 决定保留哪个站点"
    echo -e "  2. 删除另一个站点"
    echo -e "  3. 更新 CMS 配置（如果需要）"
else
    echo -e "${RED}❌ 站点状态异常${NC}"
    echo ""
    echo -e "${YELLOW}需要进一步诊断${NC}"
fi

echo ""
echo -e "${BLUE}=========================================${NC}"

