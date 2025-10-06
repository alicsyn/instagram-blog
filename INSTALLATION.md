# 📦 Instagram 博客安装和部署指南

## 🎯 概述

本指南将帮助你完成 Instagram 风格博客的安装、配置和部署。

## ✅ 环境检查

### 1. 验证 Hugo 安装

```bash
/home/u811056906/bin/hugo version
```

应该显示: `hugo v0.121.2+extended`

### 2. 验证 Git 安装

```bash
git --version
```

### 3. 验证项目结构

```bash
cd /home/u811056906/projects/instagram-blog
ls -la
```

应该看到以下文件和目录：
- `hugo.toml` - Hugo 配置文件
- `content/` - 内容目录
- `themes/` - 主题目录
- `static/` - 静态资源
- `deploy.sh` - 部署脚本
- `rollback.sh` - 回滚脚本

## 🚀 首次部署步骤

### 步骤 1: 测试构建

```bash
cd /home/u811056906/projects/instagram-blog

# 构建网站
/home/u811056906/bin/hugo --minify

# 检查构建结果
ls -la public/
```

如果构建成功，你应该看到 `public/` 目录包含生成的 HTML 文件。

### 步骤 2: 执行首次部署

```bash
# 确保脚本有执行权限
chmod +x deploy.sh rollback.sh

# 执行部署
./deploy.sh
```

部署脚本会：
1. ✅ 备份当前生产环境（如果存在）
2. ✅ 构建 Hugo 网站
3. ✅ 同步文件到生产目录
4. ✅ 设置正确的文件权限
5. ✅ 验证部署结果

### 步骤 3: 验证部署

访问你的网站：
```
https://lightcyan-lark-256774.hostingersite.com
```

你应该看到：
- ✅ Instagram 风格的首页
- ✅ 欢迎文章
- ✅ 导航菜单（首页、文章、讨论区、关于）
- ✅ 响应式设计

## 📝 配置 Netlify CMS

### 步骤 1: 创建 GitHub 仓库

```bash
# 在 GitHub 上创建新仓库（例如: instagram-blog）

# 添加远程仓库
cd /home/u811056906/projects/instagram-blog
git remote add origin https://github.com/yourusername/instagram-blog.git

# 推送代码
git push -u origin master
```

### 步骤 2: 配置 Netlify

1. 访问 [Netlify](https://app.netlify.com)
2. 点击 "Add new site" → "Import an existing project"
3. 选择你的 GitHub 仓库
4. 构建设置：
   - Build command: `hugo --minify`
   - Publish directory: `public`
5. 点击 "Deploy site"

### 步骤 3: 启用 Netlify Identity

1. 在 Netlify 站点设置中，找到 "Identity"
2. 点击 "Enable Identity"
3. 在 "Registration" 设置中，选择 "Invite only"
4. 在 "Services" 中，启用 "Git Gateway"

### 步骤 4: 邀请用户

1. 在 Identity 标签页，点击 "Invite users"
2. 输入你的邮箱地址
3. 检查邮件并设置密码

### 步骤 5: 访问管理后台

访问: `https://your-netlify-site.netlify.app/admin/`

使用刚才设置的邮箱和密码登录。

## 💬 配置 Giscus 评论系统

### 步骤 1: 准备 GitHub 仓库

1. 确保你的 GitHub 仓库是公开的
2. 在仓库设置中启用 Discussions:
   - Settings → General → Features → ✅ Discussions

### 步骤 2: 获取 Giscus 配置

1. 访问 [giscus.app/zh-CN](https://giscus.app/zh-CN)
2. 输入你的仓库信息: `yourusername/instagram-blog`
3. 选择 Discussion 分类（建议创建 "General" 分类）
4. 选择其他选项（推荐设置）:
   - ✅ 启用反应
   - 输入位置: 评论框在上方
   - 主题: light
   - 语言: zh-CN

### 步骤 3: 更新配置

复制 Giscus 生成的代码，编辑文件：

```bash
nano themes/instagram/layouts/discussions/list.html
```

找到 Giscus 脚本部分，替换以下参数：

```html
<script src="https://giscus.app/client.js"
        data-repo="yourusername/instagram-blog"
        data-repo-id="YOUR_REPO_ID"
        data-category="General"
        data-category-id="YOUR_CATEGORY_ID"
        ...>
</script>
```

### 步骤 4: 重新部署

```bash
git add .
git commit -m "Configure Giscus comments"
git push

# 部署到生产环境
./deploy.sh
```

## 🎨 自定义配置

### 修改网站信息

编辑 `hugo.toml`:

```bash
nano hugo.toml
```

修改以下内容：

```toml
baseURL = 'https://your-domain.com/'
title = '你的博客名称'

[params]
  description = "你的博客描述"
  author = "你的名字"
  avatar = "/images/avatar.jpg"
```

### 上传自定义头像

```bash
# 上传你的头像图片到
/home/u811056906/projects/instagram-blog/static/images/avatar.jpg

# 或者使用 SFTP/FTP 上传
```

### 修改社交链接

在 `hugo.toml` 中：

```toml
[[params.social]]
  name = "GitHub"
  icon = "github"
  url = "https://github.com/yourusername"

[[params.social]]
  name = "Email"
  icon = "email"
  url = "mailto:your@email.com"
```

## 📝 创建新文章

### 方式 1: 使用 Netlify CMS（推荐）

1. 访问 `https://your-site.com/admin/`
2. 登录
3. 点击 "博客文章" → "新建文章"
4. 填写标题、内容、上传封面图
5. 点击 "发布"

### 方式 2: 手动创建

```bash
# 创建新文章目录
mkdir -p content/posts/2025-01-16-my-post

# 创建文章文件
nano content/posts/2025-01-16-my-post/index.md
```

添加内容：

```markdown
---
title: "我的新文章"
date: 2025-01-16T10:00:00+08:00
cover: "/images/uploads/my-cover.jpg"
description: "文章摘要"
tags: ["标签1", "标签2"]
categories: ["分类"]
draft: false
---

## 文章内容

这里是文章正文...
```

保存后部署：

```bash
./deploy.sh
```

## 🔄 日常工作流程

### 发布新文章

```bash
# 1. 创建文章（使用 Netlify CMS 或手动）
# 2. 提交到 Git
git add .
git commit -m "Add new post: 文章标题"
git push

# 3. 部署到生产环境
./deploy.sh
```

### 更新现有文章

```bash
# 1. 编辑文章
nano content/posts/existing-post/index.md

# 2. 提交更改
git add .
git commit -m "Update post: 文章标题"
git push

# 3. 重新部署
./deploy.sh
```

### 查看部署日志

```bash
# 查看最近的部署日志
tail -50 deploy.log

# 实时查看日志
tail -f deploy.log
```

## 🔧 故障排除

### 问题 1: 部署脚本权限错误

```bash
chmod +x deploy.sh rollback.sh
```

### 问题 2: Hugo 构建失败

```bash
# 查看详细错误
/home/u811056906/bin/hugo -v

# 检查配置文件语法
/home/u811056906/bin/hugo config
```

### 问题 3: 样式丢失

检查 `hugo.toml` 中的 `baseURL` 是否正确：

```toml
baseURL = 'https://lightcyan-lark-256774.hostingersite.com/'
```

### 问题 4: 图片无法显示

确保图片路径使用绝对路径：

```markdown
![图片](/images/uploads/image.jpg)
```

而不是相对路径：

```markdown
![图片](image.jpg)  # ❌ 错误
```

## 📊 备份和恢复

### 查看可用备份

```bash
ls -lh /home/u811056906/backups/instagram-blog/
```

### 恢复备份

```bash
./rollback.sh
```

按提示选择要恢复的备份版本。

### 手动备份

```bash
# 创建手动备份
tar -czf ~/manual-backup-$(date +%Y%m%d).tar.gz \
  -C /home/u811056906/projects/instagram-blog .
```

## 🌐 域名配置（未来步骤）

### 使用 Cloudflare

1. 在 Cloudflare 注册域名
2. 添加 DNS 记录：
   - Type: CNAME
   - Name: @
   - Target: lightcyan-lark-256774.hostingersite.com
3. 更新 `hugo.toml` 中的 `baseURL`
4. 重新部署

## 📈 性能优化

### 图片优化

```bash
# 安装 ImageMagick（如果可用）
# 批量优化图片
for img in static/images/uploads/*.jpg; do
  convert "$img" -quality 85 -resize 1200x1200\> "$img"
done
```

### 启用缓存

在生产目录创建 `.htaccess`:

```apache
# 浏览器缓存
<IfModule mod_expires.c>
  ExpiresActive On
  ExpiresByType image/jpg "access plus 1 year"
  ExpiresByType image/jpeg "access plus 1 year"
  ExpiresByType image/png "access plus 1 year"
  ExpiresByType text/css "access plus 1 month"
  ExpiresByType application/javascript "access plus 1 month"
</IfModule>
```

## 🎯 下一步

- [ ] 配置 Netlify CMS
- [ ] 配置 Giscus 评论
- [ ] 上传自定义头像和封面图
- [ ] 创建更多示例文章
- [ ] 注册正式域名
- [ ] 配置 SSL 证书
- [ ] 添加 Google Analytics

## 📞 获取帮助

如果遇到问题：

1. 查看 `deploy.log` 日志文件
2. 检查 Hugo 文档: https://gohugo.io/documentation/
3. 查看 Netlify CMS 文档: https://www.netlifycms.org/docs/
4. 查看 Giscus 文档: https://giscus.app/zh-CN

---

**祝你使用愉快！** 🎉

