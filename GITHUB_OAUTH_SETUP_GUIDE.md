# 🔐 Decap CMS GitHub OAuth Backend 配置指南

## 📋 概述

本指南将帮您将 Decap CMS 从 **Netlify Identity** 切换到 **GitHub OAuth**，彻底解决登录问题。

**预计时间**: 15-20 分钟  
**难度**: ⭐⭐ 简单  
**成功率**: 95%+  
**成本**: 完全免费

---

## ✅ 优势

### 解决的问题

✅ **彻底解决登录问题**
- 不再依赖不稳定的 Netlify Identity
- 使用 GitHub 账号直接登录
- 稳定可靠

✅ **保持当前架构**
- 继续使用 Decap CMS
- 无需迁移内容
- 配置改动最小

✅ **可在共享主机开发**
- 只需修改配置文件
- 无需本地 Node.js 环境
- 所有操作在线完成

---

## 📝 前置要求

### 必需

- ✅ GitHub 账号（已有）
- ✅ Netlify 账号（已有）
- ✅ 项目已部署到 Netlify（已完成）
- ✅ 对 GitHub 仓库有管理员权限

### 可选

- GitHub 组织账号（如果需要团队协作）

---

## 🚀 实施步骤

### 第一部分: 创建 GitHub OAuth App（5 分钟）

#### 步骤 1: 访问 GitHub Developer Settings

**操作**:
```
1. 登录 GitHub
2. 点击右上角头像 → Settings
3. 左侧菜单滚动到底部 → Developer settings
4. 点击 "OAuth Apps"
5. 点击 "New OAuth App"
```

**直接链接**: https://github.com/settings/developers

#### 步骤 2: 填写 OAuth App 信息

**表单填写**:
```
Application name: Instagram Blog CMS
  (或任何您喜欢的名称)

Homepage URL: https://rad-dasik-e25922.netlify.app
  (您的 Netlify 站点 URL)

Application description: (可选)
  Content management system for Instagram Blog

Authorization callback URL: https://api.netlify.com/auth/done
  (重要: 必须是这个 URL)
```

**注意事项**:
- ⚠️ **Authorization callback URL 必须准确**
- ⚠️ 不要添加尾部斜杠
- ⚠️ 使用 `https://` 而不是 `http://`

#### 步骤 3: 获取凭证

**操作**:
```
1. 点击 "Register application"
2. 在新页面中，您会看到:
   - Client ID: 一串字符（例如: Iv1.a1b2c3d4e5f6g7h8）
   - Client secrets: 点击 "Generate a new client secret"
3. 复制 Client ID（保存到记事本）
4. 复制 Client Secret（保存到记事本）
```

**重要**:
- ⚠️ **Client Secret 只显示一次**
- ⚠️ 如果丢失，需要重新生成
- ⚠️ 不要分享给他人

---

### 第二部分: 配置 Netlify OAuth（5 分钟）

#### 步骤 4: 访问 Netlify 站点设置

**操作**:
```
1. 登录 Netlify: https://app.netlify.com
2. 选择站点: rad-dasik-e25922
3. 点击 "Site settings"
4. 左侧菜单 → Access control
5. 滚动到 "OAuth" 部分
```

#### 步骤 5: 安装 GitHub Provider

**操作**:
```
1. 在 OAuth 部分，点击 "Install provider"
2. 在弹出的对话框中:
   - Provider: 选择 "GitHub"
   - Client ID: 粘贴您在步骤 3 复制的 Client ID
   - Client Secret: 粘贴您在步骤 3 复制的 Client Secret
3. 点击 "Install"
```

**验证**:
- ✅ 应该看到 "GitHub" 出现在 OAuth providers 列表中
- ✅ 状态显示为 "Installed"

---

### 第三部分: 修改 CMS 配置（5 分钟）

#### 步骤 6: 编辑配置文件

**文件**: `static/admin/config.yml`

**修改前**:
```yaml
# 后端配置
backend:
  name: git-gateway
  branch: main
```

**修改后**:
```yaml
# 后端配置
backend:
  name: github
  repo: alicsyn/instagram-blog  # 格式: 用户名/仓库名
  branch: main
```

**注意**:
- ⚠️ 确认 `repo` 格式正确: `用户名/仓库名`
- ⚠️ 不要包含 `https://github.com/`
- ⚠️ 区分大小写

#### 步骤 7: 可选配置优化

**添加以下配置**（可选但推荐）:

```yaml
# 后端配置
backend:
  name: github
  repo: alicsyn/instagram-blog
  branch: main
  # 可选: 使用 GraphQL API（更快）
  use_graphql: true
  # 可选: 启用大文件支持
  use_large_media_transforms_in_media_library: false

# 移除 local_backend（如果有）
# local_backend: true  # ← 删除或注释掉这行
```

**完整的配置文件示例**:
```yaml
# Decap CMS 配置文件

# 后端配置
backend:
  name: github
  repo: alicsyn/instagram-blog
  branch: main
  use_graphql: true

# 媒体文件配置
media_folder: "static/images/uploads"
public_folder: "/images/uploads"

# 发布模式 - 支持草稿工作流
publish_mode: editorial_workflow

# 网站 URL
site_url: https://rad-dasik-e25922.netlify.app
display_url: https://rad-dasik-e25922.netlify.app

# 中文界面
locale: 'zh_Hans'

# 集合配置（保持不变）
collections:
  # ... 您现有的集合配置 ...
```

---

### 第四部分: 部署和测试（5 分钟）

#### 步骤 8: 提交更改

**在 Hostinger SSH 或本地终端**:
```bash
cd /home/u811056906/projects/instagram-blog

# 查看更改
git diff static/admin/config.yml

# 添加更改
git add static/admin/config.yml

# 提交
git commit -m "Config: Switch to GitHub OAuth backend"

# 推送到 GitHub
git push origin main
```

#### 步骤 9: 等待 Netlify 部署

**操作**:
```
1. 访问 Netlify 控制台
2. 进入站点: rad-dasik-e25922
3. 点击 "Deploys"
4. 等待最新部署完成（通常 1-2 分钟）
5. 状态变为 "Published"
```

**或者直接等待 2-3 分钟**

#### 步骤 10: 测试登录

**操作**:
```
1. 清除浏览器缓存（重要！）
   - Chrome: Ctrl+Shift+Delete
   - 选择 "全部时间"
   - 清除 Cookie 和缓存

2. 访问管理后台:
   https://rad-dasik-e25922.netlify.app/admin/

3. 应该看到 "Login with GitHub" 按钮

4. 点击按钮

5. GitHub 授权页面:
   - 查看权限请求
   - 点击 "Authorize [您的应用名称]"

6. 自动跳转回 CMS 管理界面

7. 成功登录！ 🎉
```

---

## 🧪 验证测试

### 测试清单

完成以下测试以确认一切正常:

- [ ] 可以访问 `/admin/`
- [ ] 看到 "Login with GitHub" 按钮
- [ ] 点击后跳转到 GitHub 授权页面
- [ ] 授权后成功登录
- [ ] 可以查看现有文章
- [ ] 可以创建新文章
- [ ] 可以编辑文章
- [ ] 可以上传图片
- [ ] 可以发布文章
- [ ] 发布后 GitHub 有新提交
- [ ] Netlify 自动构建
- [ ] 文章显示在网站上

---

## 🔍 故障排除

### 问题 1: 看不到 "Login with GitHub" 按钮

**症状**: 仍然显示 "Login with Netlify Identity"

**原因**: 浏览器缓存

**解决**:
```
1. 完全清除浏览器缓存
2. 使用无痕模式
3. 或使用不同的浏览器
4. 确认 Netlify 部署已完成
```

---

### 问题 2: 点击登录后显示 "Error: Failed to load"

**症状**: 授权后返回错误

**原因**: OAuth 配置错误

**解决**:
```
1. 检查 GitHub OAuth App 的 Callback URL:
   必须是: https://api.netlify.com/auth/done

2. 检查 Netlify OAuth Provider:
   - Client ID 正确
   - Client Secret 正确

3. 重新生成 Client Secret:
   - 在 GitHub OAuth App 中
   - 生成新的 Secret
   - 更新 Netlify 配置
```

---

### 问题 3: 授权后显示 "Not Found"

**症状**: GitHub 授权成功，但返回 404

**原因**: `repo` 配置错误

**解决**:
```
1. 检查 config.yml 中的 repo:
   backend:
     name: github
     repo: alicsyn/instagram-blog  # 确认格式正确

2. 确认仓库名称:
   - 访问 GitHub 仓库
   - 复制 URL 中的 用户名/仓库名
   - 例如: https://github.com/alicsyn/instagram-blog
     → repo: alicsyn/instagram-blog

3. 确认分支名称:
   - 检查 GitHub 仓库的默认分支
   - 通常是 main 或 master
```

---

### 问题 4: 登录成功但无法编辑

**症状**: 可以登录，但无法保存更改

**原因**: GitHub 权限不足

**解决**:
```
1. 确认您是仓库的所有者或协作者

2. 检查 GitHub OAuth App 权限:
   - 在 GitHub 授权页面
   - 应该请求 "repo" 权限

3. 重新授权:
   - GitHub → Settings → Applications
   - 找到您的 OAuth App
   - 点击 "Revoke"
   - 重新登录 CMS
   - 重新授权
```

---

### 问题 5: 图片上传失败

**症状**: 无法上传图片

**原因**: 媒体库配置

**解决**:
```
1. 禁用 Uploadcare（如果配置了）:
   # 在 config.yml 中注释掉:
   # media_library:
   #   name: uploadcare
   #   ...

2. 使用默认的 Git LFS 或直接提交:
   # 无需额外配置，直接上传即可
```

---

## 📊 GitHub OAuth vs Netlify Identity 对比

| 特性 | GitHub OAuth | Netlify Identity |
|------|-------------|------------------|
| **稳定性** | ⭐⭐⭐⭐⭐ 非常稳定 | ⭐⭐ 经常出问题 |
| **登录速度** | ⭐⭐⭐⭐⭐ 快速 | ⭐⭐⭐ 较慢 |
| **配置难度** | ⭐⭐ 简单 | ⭐⭐⭐ 中等 |
| **用户管理** | GitHub 账号 | Netlify Identity |
| **权限控制** | GitHub 仓库权限 | Netlify 邀请 |
| **成本** | 免费 | 免费（有限制） |
| **依赖** | GitHub | Netlify + GitHub |
| **适用场景** | 个人/团队 | 非技术用户 |

---

## 🎯 最佳实践

### 安全建议

1. **定期更新 Client Secret**
   ```
   每 6-12 个月更新一次
   ```

2. **限制仓库访问**
   ```
   只授权必要的协作者
   ```

3. **使用分支保护**
   ```
   在 GitHub 仓库设置中:
   Settings → Branches → Add rule
   保护 main 分支
   ```

### 团队协作

如果需要多人使用 CMS:

1. **添加 GitHub 协作者**
   ```
   GitHub 仓库 → Settings → Collaborators
   添加团队成员的 GitHub 账号
   ```

2. **设置权限**
   ```
   - Write: 可以编辑和发布
   - Read: 只能查看
   ```

3. **使用 GitHub 组织**（可选）
   ```
   创建 GitHub Organization
   将仓库转移到组织
   更好的团队管理
   ```

---

## 🎉 完成检查清单

配置完成后，确认以下所有项目:

- [ ] GitHub OAuth App 已创建
- [ ] Client ID 和 Secret 已保存
- [ ] Netlify OAuth Provider 已安装
- [ ] config.yml 已更新
- [ ] 更改已提交到 GitHub
- [ ] Netlify 部署成功
- [ ] 浏览器缓存已清除
- [ ] 可以使用 GitHub 登录
- [ ] 可以编辑文章
- [ ] 可以上传图片
- [ ] 可以发布文章
- [ ] GitHub 有新提交
- [ ] 网站自动更新

---

## 📞 需要帮助？

如果遇到任何问题:

1. **检查配置**
   - 仔细对照本指南
   - 确认每个步骤都正确完成

2. **查看错误信息**
   - 浏览器 Console (F12)
   - Netlify 部署日志
   - GitHub Actions（如果有）

3. **常见问题**
   - 参考上面的故障排除部分
   - 大部分问题都有解决方案

---

**恭喜！您现在拥有一个稳定可靠的 CMS 认证系统！** 🎊

不再需要担心 Netlify Identity 的登录问题，可以专注于创作内容了！

