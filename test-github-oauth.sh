#!/bin/bash

# GitHub OAuth Backend 测试验证脚本

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}🧪 GitHub OAuth Backend 测试验证${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# 测试计数
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# 测试函数
test_pass() {
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    PASSED_TESTS=$((PASSED_TESTS + 1))
    echo -e "${GREEN}✅ $1${NC}"
}

test_fail() {
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    FAILED_TESTS=$((FAILED_TESTS + 1))
    echo -e "${RED}❌ $1${NC}"
}

test_warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

test_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

# 测试 1: 检查配置文件
echo -e "${YELLOW}📋 测试 1/7: 检查配置文件...${NC}"
if [ -f "static/admin/config.yml" ]; then
    test_pass "配置文件存在"
    
    # 检查 backend 配置
    if grep -q "name: github" static/admin/config.yml; then
        test_pass "Backend 已设置为 github"
    else
        test_fail "Backend 未设置为 github"
    fi
    
    # 检查 repo 配置
    if grep -q "repo: alicsyn/instagram-blog" static/admin/config.yml; then
        test_pass "仓库配置正确"
    else
        test_fail "仓库配置不正确"
    fi
    
    # 检查 GraphQL
    if grep -q "use_graphql: true" static/admin/config.yml; then
        test_pass "GraphQL API 已启用"
    else
        test_warn "GraphQL API 未启用（可选）"
    fi
else
    test_fail "配置文件不存在"
fi
echo ""

# 测试 2: 检查 Git 状态
echo -e "${YELLOW}📋 测试 2/7: 检查 Git 状态...${NC}"
if git rev-parse --git-dir > /dev/null 2>&1; then
    test_pass "Git 仓库正常"
    
    # 检查是否有未提交的更改
    if git diff-index --quiet HEAD --; then
        test_pass "所有更改已提交"
    else
        test_warn "有未提交的更改"
        git status --short
    fi
    
    # 检查远程同步
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u} 2>/dev/null)
    if [ "$LOCAL" = "$REMOTE" ]; then
        test_pass "本地与远程同步"
    else
        test_warn "本地与远程不同步"
    fi
else
    test_fail "不是 Git 仓库"
fi
echo ""

# 测试 3: 检查最新提交
echo -e "${YELLOW}📋 测试 3/7: 检查最新提交...${NC}"
LATEST_COMMIT=$(git log -1 --pretty=format:"%s")
if [[ "$LATEST_COMMIT" == *"GitHub OAuth"* ]] || [[ "$LATEST_COMMIT" == *"github"* ]]; then
    test_pass "最新提交与 GitHub OAuth 相关"
    test_info "提交信息: $LATEST_COMMIT"
else
    test_warn "最新提交可能不是 OAuth 配置"
    test_info "提交信息: $LATEST_COMMIT"
fi
echo ""

# 测试 4: 检查管理后台文件
echo -e "${YELLOW}📋 测试 4/7: 检查管理后台文件...${NC}"
if [ -f "static/admin/index.html" ]; then
    test_pass "管理后台 HTML 存在"
    
    # 检查 Decap CMS 版本
    if grep -q "decap-cms" static/admin/index.html; then
        VERSION=$(grep -o 'decap-cms@[^/]*' static/admin/index.html | head -1)
        test_pass "使用 Decap CMS: $VERSION"
    else
        test_warn "未找到 Decap CMS 引用"
    fi
else
    test_fail "管理后台 HTML 不存在"
fi
echo ""

# 测试 5: 测试网络连接
echo -e "${YELLOW}📋 测试 5/7: 测试网络连接...${NC}"

# 测试 GitHub API
if curl -s --head https://api.github.com | grep "200 OK" > /dev/null; then
    test_pass "GitHub API 可访问"
else
    test_fail "GitHub API 不可访问"
fi

# 测试 Netlify 站点
if curl -s --head https://rad-dasik-e25922.netlify.app | grep "200" > /dev/null; then
    test_pass "Netlify 站点可访问"
else
    test_fail "Netlify 站点不可访问"
fi

# 测试管理后台
if curl -s --head https://rad-dasik-e25922.netlify.app/admin/ | grep "200" > /dev/null; then
    test_pass "管理后台可访问"
else
    test_fail "管理后台不可访问"
fi
echo ""

# 测试 6: 检查 Netlify 部署
echo -e "${YELLOW}📋 测试 6/7: 检查 Netlify 部署...${NC}"
ADMIN_RESPONSE=$(curl -s https://rad-dasik-e25922.netlify.app/admin/)

if echo "$ADMIN_RESPONSE" | grep -q "decap-cms"; then
    test_pass "管理后台加载 Decap CMS"
else
    test_warn "未检测到 Decap CMS（可能是缓存）"
fi

# 检查是否还有 Netlify Identity
if echo "$ADMIN_RESPONSE" | grep -q "netlify-identity-widget"; then
    test_warn "仍然加载 Netlify Identity Widget（正常，用于兼容）"
else
    test_info "未加载 Netlify Identity Widget"
fi
echo ""

# 测试 7: 检查 GitHub 仓库
echo -e "${YELLOW}📋 测试 7/7: 检查 GitHub 仓库...${NC}"
REPO_URL="https://api.github.com/repos/alicsyn/instagram-blog"
REPO_INFO=$(curl -s "$REPO_URL")

if echo "$REPO_INFO" | grep -q '"name"'; then
    test_pass "GitHub 仓库可访问"
    
    # 检查默认分支
    DEFAULT_BRANCH=$(echo "$REPO_INFO" | grep -o '"default_branch":"[^"]*' | cut -d'"' -f4)
    if [ "$DEFAULT_BRANCH" = "main" ]; then
        test_pass "默认分支是 main"
    else
        test_warn "默认分支是 $DEFAULT_BRANCH（配置中使用 main）"
    fi
else
    test_fail "GitHub 仓库不可访问或不存在"
fi
echo ""

# 测试总结
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}📊 测试总结${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""
echo -e "${CYAN}总测试数: $TOTAL_TESTS${NC}"
echo -e "${GREEN}通过: $PASSED_TESTS${NC}"
echo -e "${RED}失败: $FAILED_TESTS${NC}"
echo ""

# 计算通过率
if [ $TOTAL_TESTS -gt 0 ]; then
    PASS_RATE=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    echo -e "${CYAN}通过率: ${PASS_RATE}%${NC}"
    echo ""
fi

# 最终建议
if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}🎉 所有测试通过！${NC}"
    echo ""
    echo -e "${CYAN}下一步操作:${NC}"
    echo -e "1. 清除浏览器缓存"
    echo -e "2. 访问: ${BLUE}https://rad-dasik-e25922.netlify.app/admin/${NC}"
    echo -e "3. 点击 \"Login with GitHub\""
    echo -e "4. 授权应用"
    echo -e "5. 开始使用！"
else
    echo -e "${YELLOW}⚠️  有 $FAILED_TESTS 个测试失败${NC}"
    echo ""
    echo -e "${CYAN}建议操作:${NC}"
    echo -e "1. 检查失败的测试项"
    echo -e "2. 查看 ${GREEN}GITHUB_OAUTH_DEPLOYMENT_COMPLETE.md${NC} 中的故障排除部分"
    echo -e "3. 确认 GitHub OAuth App 和 Netlify OAuth 配置正确"
    echo -e "4. 如需帮助，请查看详细文档"
fi

echo ""
echo -e "${BLUE}=========================================${NC}"
echo ""

# 额外信息
echo -e "${CYAN}📚 相关文档:${NC}"
echo -e "  - GITHUB_OAUTH_SETUP_GUIDE.md"
echo -e "  - GITHUB_OAUTH_DEPLOYMENT_COMPLETE.md"
echo -e "  - COMPREHENSIVE_CMS_SOLUTION_ANALYSIS.md"
echo ""

echo -e "${CYAN}🔗 重要链接:${NC}"
echo -e "  - 管理后台: ${BLUE}https://rad-dasik-e25922.netlify.app/admin/${NC}"
echo -e "  - GitHub 仓库: ${BLUE}https://github.com/alicsyn/instagram-blog${NC}"
echo -e "  - Netlify 控制台: ${BLUE}https://app.netlify.com/sites/rad-dasik-e25922${NC}"
echo ""

exit 0

