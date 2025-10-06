# 📸 Instagram 风格博客

一个采用 Instagram 设计风格的现代化个人博客，基于 Hugo 静态网站生成器构建，部署在 Hostinger 虚拟主机环境。

## ✨ 特性

- 🎨 **Instagram 风格设计** - 精美的网格布局、卡片式设计、极简配色
- ⚡ **极速加载** - 静态网站，加载速度极快
- 📱 **响应式设计** - 完美适配各种设备
- 🎛️ **Netlify CMS** - 网页端内容管理系统
- 💬 **Giscus 评论** - 基于 GitHub Discussions 的评论系统
- 🔍 **SEO 优化** - 搜索引擎友好
- 🚀 **自动化部署** - 一键部署到生产环境

## 📁 项目结构

```
instagram-blog/
├── archetypes/          # 内容模板
├── content/             # 内容目录
│   ├── posts/          # 博客文章
│   ├── about/          # 关于页面
│   └── discussions/    # 讨论区页面
├── static/              # 静态资源
│   ├── admin/          # Netlify CMS 配置
│   ├── css/            # 样式文件
│   ├── js/             # JavaScript 文件
│   └── images/         # 图片资源
├── themes/              # 主题目录
│   └── instagram/      # Instagram 风格主题
│       ├── layouts/    # HTML 模板
│       └── static/     # 主题静态资源
├── hugo.toml           # Hugo 配置文件
├── deploy.sh           # 部署脚本
├── rollback.sh         # 回滚脚本
└── README.md           # 本文件
```

## 🚀 快速开始

### 1. 环境要求

- Hugo Extended v0.121.0+
- Git
- Hostinger 虚拟主机（或其他支持静态网站的主机）

### 2. 本地预览

```bash
# 进入项目目录
cd /home/u811056906/projects/instagram-blog

# 启动本地服务器
/home/u811056906/bin/hugo server -D

# 访问 http://localhost:1313
```

### 3. 创建新文章

#### 方式 A: 使用 Netlify CMS（推荐）

1. 访问 `https://your-domain.com/admin/`
2. 登录后台
3. 点击"新建文章"
4. 编写内容并发布

#### 方式 B: 使用命令行

```bash
# 创建新文章
/home/u811056906/bin/hugo new posts/my-new-post/index.md

# 编辑文章
nano content/posts/my-new-post/index.md
```

### 4. 部署到生产环境

```bash
# 一键部署
./deploy.sh
```

部署脚本会自动：
- 备份当前生产环境
- 构建 Hugo 网站
- 同步文件到生产目录
- 设置正确的文件权限
- 验证部署结果

### 5. 回滚到之前的版本

```bash
# 运行回滚脚本
./rollback.sh

# 按提示选择要恢复的备份
```

## 📝 内容管理

### 文章 Front Matter 示例

```yaml
---
title: "文章标题"
date: 2025-01-15T10:00:00+08:00
cover: "/images/uploads/cover.jpg"
description: "文章摘要"
tags: ["标签1", "标签2"]
categories: ["分类"]
draft: false
---

文章内容...
```

### 图片管理

- **上传位置**: `static/images/uploads/`
- **引用方式**: `/images/uploads/filename.jpg`
- **建议尺寸**: 
  - 封面图: 1200x1200 (方形)
  - 文章图片: 最大宽度 1200px

## 🎨 自定义配置

### 修改网站信息

编辑 `hugo.toml` 文件：

```toml
baseURL = 'https://your-domain.com/'
title = '你的博客名称'

[params]
  description = "博客描述"
  author = "你的名字"
  avatar = "/images/avatar.jpg"
```

### 修改菜单

在 `hugo.toml` 中编辑菜单配置：

```toml
[menu]
  [[menu.main]]
    name = "首页"
    url = "/"
    weight = 1
```

### 修改社交链接

```toml
[[params.social]]
  name = "GitHub"
  icon = "github"
  url = "https://github.com/yourusername"
```

## 💬 配置 Giscus 评论系统

1. 在 GitHub 创建公开仓库
2. 启用 Discussions 功能
3. 访问 [giscus.app](https://giscus.app/zh-CN)
4. 按照指引获取配置代码
5. 编辑 `themes/instagram/layouts/discussions/list.html`
6. 替换 Giscus 配置参数

## 🔧 Netlify CMS 配置

### 使用 Git Gateway（推荐）

1. 在 [Netlify](https://app.netlify.com) 创建站点
2. 启用 Identity 服务
3. 启用 Git Gateway
4. 邀请用户

### 使用 GitHub 后端

编辑 `static/admin/config.yml`:

```yaml
backend:
  name: github
  repo: yourusername/your-repo
  branch: main
```

## 📊 部署选项

### 选项 1: 手动部署（当前方案）

```bash
./deploy.sh
```

### 选项 2: Cron 定时部署

```bash
# 编辑 crontab
crontab -e

# 添加定时任务（每小时检查更新）
0 * * * * cd /home/u811056906/projects/instagram-blog && git pull && ./deploy.sh
```

### 选项 3: Webhook 自动部署

创建 `webhook.php` 文件处理 GitHub Webhook，自动触发部署。

## 🔒 安全建议

1. **保护管理后台**
   - 使用强密码
   - 启用 IP 白名单
   - 定期更新依赖

2. **备份策略**
   - 自动备份保留 5 个版本
   - 定期下载备份到本地
   - 使用 Git 版本控制

3. **文件权限**
   - 文件: 644
   - 目录: 755
   - 脚本: 755

## 🐛 故障排除

### 问题 1: Hugo 构建失败

```bash
# 检查 Hugo 版本
/home/u811056906/bin/hugo version

# 查看详细错误
/home/u811056906/bin/hugo -v
```

### 问题 2: 部署后样式丢失

检查 `hugo.toml` 中的 `baseURL` 是否正确。

### 问题 3: 图片无法显示

确保图片路径正确，使用绝对路径 `/images/...`

## 📚 相关资源

- [Hugo 官方文档](https://gohugo.io/documentation/)
- [Netlify CMS 文档](https://www.netlifycms.org/docs/)
- [Giscus 文档](https://giscus.app/zh-CN)
- [Markdown 语法](https://www.markdownguide.org/)

## 🎯 下一步计划

- [ ] 配置 Giscus 评论系统
- [ ] 添加更多示例文章
- [ ] 配置 Netlify CMS
- [ ] 注册正式域名
- [ ] 配置 Cloudflare CDN
- [ ] 添加 Google Analytics
- [ ] 实现暗色模式

## 📄 许可证

MIT License

## 🙏 致谢

- [Hugo](https://gohugo.io/) - 静态网站生成器
- [Netlify CMS](https://www.netlifycms.org/) - 内容管理系统
- [Giscus](https://giscus.app/) - 评论系统
- [Instagram](https://www.instagram.com/) - 设计灵感

---

**Made with ❤️ using Hugo**

