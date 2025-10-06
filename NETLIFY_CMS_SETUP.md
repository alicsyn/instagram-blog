# 🎨 Netlify CMS 完整配置指南

## 📋 概述

本指南将帮助你在 1-2 小时内完成 Netlify CMS 的配置，实现网页端编辑功能。

**完成后你将拥有**:
- ✅ 网页端文章编辑器（Markdown）
- ✅ 图片拖拽上传功能
- ✅ 实时预览
- ✅ 草稿工作流
- ✅ 移动端编辑支持
- ✅ 中文界面

---

## 🎯 前置要求

### 必需
- ✅ GitHub 账号（免费）
- ✅ Netlify 账号（免费）
- ✅ 项目已部署到 Hostinger（已完成）

### 可选
- ⏳ 自定义域名（可以后续添加）

---

## 📝 详细步骤

### 第一部分: GitHub 配置（15 分钟）

#### 步骤 1: 创建 GitHub 账号

如果还没有 GitHub 账号：

1. 访问: https://github.com/signup
2. 填写信息:
   - Email: 你的邮箱
   - Password: 设置密码
   - Username: 选择用户名
3. 验证邮箱
4. 完成注册

#### 步骤 2: 创建新仓库

1. 登录 GitHub
2. 点击右上角 "+" → "New repository"
3. 填写仓库信息:
   ```
   Repository name: instagram-blog
   Description: Instagram 风格个人博客
   Visibility: Public（公开）
   ❌ 不要勾选 "Initialize this repository with a README"
   ```
4. 点击 "Create repository"

#### 步骤 3: 推送代码到 GitHub

**在 Hostinger 终端执行**:

```bash
# 1. 进入项目目录
cd /home/u811056906/projects/instagram-blog

# 2. 检查 Git 状态
git status

# 3. 添加远程仓库（替换为你的用户名）
git remote add origin https://github.com/你的用户名/instagram-blog.git

# 4. 重命名分支为 main
git branch -M main

# 5. 推送代码
git push -u origin main
```

**如果需要输入凭据**:
- Username: 你的 GitHub 用户名
- Password: 使用 Personal Access Token（不是密码）

**创建 Personal Access Token**:
1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token (classic)
3. 勾选 `repo` 权限
4. 生成并复制 token
5. 使用 token 作为密码

**验证推送成功**:
```bash
# 查看远程仓库
git remote -v

# 应该显示:
# origin  https://github.com/你的用户名/instagram-blog.git (fetch)
# origin  https://github.com/你的用户名/instagram-blog.git (push)
```

---

### 第二部分: Netlify 配置（30 分钟）

#### 步骤 4: 注册 Netlify 账号

1. 访问: https://app.netlify.com/signup
2. 选择 "Sign up with GitHub"
3. 授权 Netlify 访问 GitHub
4. 完成注册

#### 步骤 5: 导入项目

1. 登录 Netlify 后，点击 "Add new site"
2. 选择 "Import an existing project"
3. 选择 "Deploy with GitHub"
4. 授权 Netlify 访问你的仓库
5. 选择 `instagram-blog` 仓库

#### 步骤 6: 配置构建设置

在 "Site settings" 页面:

```
Site name: 选择一个名称（例如: my-instagram-blog）
Branch to deploy: main
Build command: hugo --minify
Publish directory: public
```

**高级设置**（点击 "Show advanced"）:

添加环境变量:
```
Key: HUGO_VERSION
Value: 0.121.2
```

点击 "Deploy site"

#### 步骤 7: 等待首次部署

1. Netlify 开始构建
2. 查看构建日志（Deploy log）
3. 等待 2-5 分钟
4. 看到 "Site is live" 表示成功

**验证部署**:
- 访问: `https://你的站点名.netlify.app`
- 应该看到你的博客

---

### 第三部分: Netlify Identity 配置（15 分钟）

#### 步骤 8: 启用 Identity

1. 在 Netlify 站点控制面板
2. 点击 "Site settings"
3. 左侧菜单找到 "Identity"
4. 点击 "Enable Identity"

#### 步骤 9: 配置注册设置

1. Identity → Settings → Registration preferences
2. 选择 "Invite only"（仅邀请）
3. 保存设置

**为什么选择 "Invite only"**:
- ✅ 防止陌生人注册
- ✅ 只有你邀请的人可以访问
- ✅ 更安全

#### 步骤 10: 启用 Git Gateway

1. Identity → Settings → Services
2. 找到 "Git Gateway"
3. 点击 "Enable Git Gateway"
4. 确认启用

**Git Gateway 的作用**:
- 允许 Netlify CMS 直接提交到 GitHub
- 无需配置 GitHub OAuth App
- 更简单、更安全

#### 步骤 11: 邀请管理员

1. 回到 "Identity" 标签页
2. 点击 "Invite users"
3. 输入你的邮箱地址
4. 点击 "Send"

#### 步骤 12: 接受邀请

1. 检查你的邮箱
2. 找到 Netlify 的邀请邮件
3. 点击 "Accept the invite"
4. 设置密码（至少 6 个字符）
5. 确认密码

---

### 第四部分: 访问 CMS 管理后台（5 分钟）

#### 步骤 13: 访问管理后台

**方式 1: 通过 Netlify 域名**
```
https://你的站点名.netlify.app/admin/
```

**方式 2: 通过 Hostinger 域名（需要先同步）**
```
https://lightcyan-lark-256774.hostingersite.com/admin/
```

#### 步骤 14: 登录

1. 在 `/admin/` 页面
2. 输入邮箱和密码
3. 点击 "登录"

**首次登录**:
- 可能需要验证邮箱
- 可能需要等待几秒钟

**登录成功后**:
- 看到 Netlify CMS 管理界面
- 中文界面
- 左侧菜单: 博客文章、页面、网站设置

---

### 第五部分: 测试编辑功能（20 分钟）

#### 步骤 15: 创建第一篇文章

1. 点击左侧 "博客文章"
2. 点击 "新建文章"
3. 填写表单:

```
标题: 我的第一篇网页编辑文章
发布日期: 选择当前日期和时间
封面图片: 点击上传（稍后测试）
摘要: 这是我第一次使用网页编辑器创建的文章
标签: 测试, 网页编辑
分类: 日记
草稿: 关闭（发布）
内容: 
## 欢迎

这是我第一次使用 Netlify CMS 创建文章！

### 功能测试

- [x] Markdown 编辑
- [x] 实时预览
- [ ] 图片上传（下一步测试）

**太棒了！** 🎉
```

4. 点击右上角 "保存"

#### 步骤 16: 测试图片上传

1. 在内容编辑器中
2. 点击工具栏的图片按钮（📷）
3. 选择上传方式:
   - **拖拽图片** 到上传区域
   - 或点击 "Choose an image"
4. 选择一张图片（建议 < 2MB）
5. 等待上传完成
6. 图片自动插入到内容中

**图片 Markdown 格式**:
```markdown
![图片描述](/images/uploads/your-image.jpg)
```

#### 步骤 17: 预览文章

1. 点击右上角 "预览" 按钮
2. 在新标签页查看文章效果
3. 检查:
   - ✅ 标题显示正确
   - ✅ 内容格式正确
   - ✅ 图片加载正常
   - ✅ Instagram 风格样式

#### 步骤 18: 发布文章

**方式 1: 直接发布**
1. 点击 "保存" 旁边的下拉菜单
2. 选择 "发布"
3. 确认发布

**方式 2: 编辑工作流（草稿）**
1. 点击 "保存"
2. 文章保存为草稿
3. 在 "工作流" 标签页查看
4. 拖动到 "Ready" 列
5. 点击 "发布"

#### 步骤 19: 验证发布

1. Netlify 自动触发构建
2. 等待 2-3 分钟
3. 访问 Netlify 站点:
   ```
   https://你的站点名.netlify.app
   ```
4. 应该看到新文章

---

### 第六部分: 同步到 Hostinger（10 分钟）

#### 步骤 20: 拉取更新

```bash
# 1. 进入项目目录
cd /home/u811056906/projects/instagram-blog

# 2. 拉取 GitHub 更新
git pull origin main

# 3. 查看更改
git log --oneline -5

# 应该看到 Netlify CMS 的提交记录
```

#### 步骤 21: 部署到 Hostinger

```bash
# 使用部署脚本
bash deploy.sh

# 或使用简化脚本
bash deploy-simple.sh
```

#### 步骤 22: 验证 Hostinger 站点

访问:
```
https://lightcyan-lark-256774.hostingersite.com
```

应该看到新文章。

---

## 🎨 CMS 功能详解

### 文章管理

#### 创建文章
- 点击 "博客文章" → "新建文章"
- 填写所有字段
- 保存或发布

#### 编辑文章
- 在文章列表中点击文章
- 修改内容
- 保存更改

#### 删除文章
- 在文章列表中点击文章
- 点击右上角 "删除"
- 确认删除

### 图片管理

#### 上传图片
1. 在编辑器中点击图片按钮
2. 拖拽或选择图片
3. 自动上传到 `/static/images/uploads/`

#### 图片库
- 点击 "媒体" 查看所有图片
- 可以删除不需要的图片
- 可以重命名图片

### 草稿工作流

#### 保存草稿
1. 编辑文章
2. 点击 "保存"（不点击发布）
3. 文章保存为草稿

#### 查看草稿
1. 点击顶部 "工作流" 标签
2. 看到三列:
   - **Drafts**: 草稿
   - **In Review**: 审核中
   - **Ready**: 准备发布

#### 发布草稿
1. 将文章拖动到 "Ready" 列
2. 点击文章
3. 点击 "发布"

---

## 📱 移动端使用

### 在手机上编辑

1. 在手机浏览器访问:
   ```
   https://你的站点名.netlify.app/admin/
   ```

2. 登录（使用相同的邮箱密码）

3. 界面自动适配移动端

4. 可以:
   - ✅ 创建文章
   - ✅ 编辑文章
   - ✅ 上传图片（从相册）
   - ✅ 发布文章

**提示**:
- 建议使用 Chrome 或 Safari
- 横屏模式体验更好
- 可以添加到主屏幕

---

## 🔧 高级配置

### 自定义编辑器

编辑 `/static/admin/config.yml`:

```yaml
# 添加更多字段
fields:
  - {label: "作者", name: "author", widget: "string"}
  - {label: "阅读时间", name: "readingTime", widget: "number"}
  - {label: "特色文章", name: "featured", widget: "boolean"}
```

### 自定义预览

编辑 `/static/admin/index.html`:

```html
<script>
CMS.registerPreviewStyle("/css/main.css");
</script>
```

### 添加更多集合

在 `config.yml` 中添加:

```yaml
collections:
  - name: "gallery"
    label: "图片库"
    folder: "content/gallery"
    create: true
    fields:
      - {label: "标题", name: "title", widget: "string"}
      - {label: "图片", name: "images", widget: "list", field: {label: "图片", name: "image", widget: "image"}}
```

---

## 🐛 故障排除

### 问题 1: 无法登录

**症状**: 输入邮箱密码后无反应

**解决**:
1. 检查是否已启用 Identity
2. 检查是否已启用 Git Gateway
3. 清除浏览器缓存
4. 尝试无痕模式

### 问题 2: 图片上传失败

**症状**: 上传图片时出错

**解决**:
1. 检查图片大小（< 10MB）
2. 检查图片格式（JPG, PNG, GIF）
3. 检查网络连接
4. 重试上传

### 问题 3: 发布后看不到文章

**症状**: 发布文章后网站没有更新

**解决**:
1. 检查 Netlify 构建状态
2. 等待 2-3 分钟
3. 清除浏览器缓存
4. 检查文章是否设置为草稿

### 问题 4: Git Gateway 错误

**症状**: "Error: Failed to persist entry"

**解决**:
1. 检查 Git Gateway 是否启用
2. 检查 GitHub 仓库权限
3. 重新启用 Git Gateway
4. 联系 Netlify 支持

---

## 📊 工作流程图

```
创建文章 → 编辑内容 → 上传图片 → 预览 → 保存/发布
                                              ↓
                                         提交到 GitHub
                                              ↓
                                      Netlify 自动构建
                                              ↓
                                         部署到 CDN
                                              ↓
                                    (可选) 同步到 Hostinger
```

---

## 🎯 最佳实践

### 文章编写

1. **使用有意义的标题**
   - ✅ "如何使用 Netlify CMS 管理博客"
   - ❌ "文章1"

2. **添加摘要**
   - 简短描述文章内容
   - 用于 SEO 和文章列表

3. **使用标签和分类**
   - 标签: 具体主题（"Hugo", "CMS", "教程"）
   - 分类: 大类别（"技术", "生活", "旅行"）

4. **优化图片**
   - 压缩图片（< 500KB）
   - 使用描述性文件名
   - 添加 alt 文本

### 图片管理

1. **命名规范**
   ```
   ✅ 2025-01-15-sunset-beach.jpg
   ❌ IMG_1234.jpg
   ```

2. **尺寸建议**
   - 封面图: 1200x1200 (方形)
   - 文章图片: 最大宽度 1200px
   - 缩略图: 300x300

3. **格式选择**
   - 照片: JPEG (85% 质量)
   - 图标/图表: PNG
   - 动画: GIF 或 WebP

---

## 📝 快速参考

### 常用 Markdown 语法

```markdown
# 一级标题
## 二级标题
### 三级标题

**粗体** *斜体* ~~删除线~~

[链接文字](https://example.com)

![图片描述](/images/photo.jpg)

- 无序列表
- 项目 2

1. 有序列表
2. 项目 2

> 引用文字

`代码`

​```python
# 代码块
print("Hello")
​```
```

### 快捷键

- `Ctrl/Cmd + S`: 保存
- `Ctrl/Cmd + P`: 预览
- `Ctrl/Cmd + B`: 粗体
- `Ctrl/Cmd + I`: 斜体

---

## 🎉 完成检查清单

配置完成后，确认以下所有项目:

- [ ] GitHub 仓库已创建
- [ ] 代码已推送到 GitHub
- [ ] Netlify 站点已部署
- [ ] Netlify Identity 已启用
- [ ] Git Gateway 已启用
- [ ] 管理员账号已创建
- [ ] 可以访问 `/admin/`
- [ ] 可以创建文章
- [ ] 可以上传图片
- [ ] 可以预览文章
- [ ] 可以发布文章
- [ ] Netlify 自动构建正常
- [ ] 文章显示在网站上
- [ ] 移动端可以访问

---

**恭喜！你现在拥有完整的网页端编辑功能！** 🎉

下一步: 创建更多内容，自定义网站信息！

