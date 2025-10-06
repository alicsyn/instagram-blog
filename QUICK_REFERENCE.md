# 📸 Instagram 博客快速参考卡片

## 🚀 快速命令

### 首次部署
```bash
cd /home/u811056906/projects/instagram-blog
./quickstart.sh  # 测试构建
./deploy.sh      # 部署到生产环境
```

### 日常使用
```bash
# 创建新文章
/home/u811056906/bin/hugo new posts/my-post/index.md

# 本地预览（如果支持）
/home/u811056906/bin/hugo server -D

# 构建网站
/home/u811056906/bin/hugo --minify

# 部署
./deploy.sh

# 回滚
./rollback.sh
```

---

## 📁 重要路径

```bash
# 开发环境
/home/u811056906/projects/instagram-blog/

# 生产环境
/home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/

# 备份目录
/home/u811056906/backups/instagram-blog/

# Hugo 可执行文件
/home/u811056906/bin/hugo
```

---

## 📝 文件位置

```bash
# 配置文件
hugo.toml                          # Hugo 主配置

# 内容文件
content/posts/                     # 博客文章
content/about/_index.md            # 关于页面
content/discussions/_index.md      # 讨论区

# 主题文件
themes/instagram/layouts/          # HTML 模板
themes/instagram/static/css/       # CSS 样式
themes/instagram/static/js/        # JavaScript

# CMS 配置
static/admin/config.yml            # Netlify CMS 配置
static/admin/index.html            # CMS 入口

# 图片资源
static/images/uploads/             # 上传的图片
static/images/avatar.jpg           # 头像
static/images/default-cover.jpg    # 默认封面

# 脚本
deploy.sh                          # 部署脚本
rollback.sh                        # 回滚脚本
quickstart.sh                      # 快速启动

# 日志
deploy.log                         # 部署日志
```

---

## 🎨 配置修改

### 修改网站信息
```bash
nano hugo.toml

# 修改以下内容:
baseURL = 'https://your-domain.com/'
title = '你的博客名称'
[params]
  description = "博客描述"
  author = "你的名字"
```

### 修改社交链接
```bash
nano hugo.toml

# 找到 [[params.social]] 部分修改
```

### 上传自定义头像
```bash
# 上传图片到
/home/u811056906/projects/instagram-blog/static/images/avatar.jpg
```

---

## 📄 创建新文章

### 方式 1: 命令行
```bash
# 创建文章目录
mkdir -p content/posts/2025-01-16-my-post

# 创建文章文件
cat > content/posts/2025-01-16-my-post/index.md << 'EOF'
---
title: "我的新文章"
date: 2025-01-16T10:00:00+08:00
cover: "/images/uploads/cover.jpg"
description: "文章摘要"
tags: ["标签1", "标签2"]
categories: ["分类"]
draft: false
---

## 文章内容

这里是正文...
EOF
```

### 方式 2: Netlify CMS
```
访问: https://your-site.com/admin/
登录 → 新建文章 → 编辑 → 发布
```

---

## 🔄 Git 操作

```bash
cd /home/u811056906/projects/instagram-blog

# 查看状态
git status

# 添加文件
git add .

# 提交
git commit -m "Update content"

# 推送到远程（如果配置了）
git push origin master

# 查看日志
git log --oneline
```

---

## 🔍 故障排查

### 检查 Hugo
```bash
/home/u811056906/bin/hugo version
/home/u811056906/bin/hugo -v
```

### 检查构建
```bash
cd /home/u811056906/projects/instagram-blog
/home/u811056906/bin/hugo --minify
ls -la public/
```

### 检查部署
```bash
# 查看日志
tail -50 deploy.log

# 检查生产环境
ls -la /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/

# 检查权限
find /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html -type f ! -perm 644
```

### 检查备份
```bash
ls -lht /home/u811056906/backups/instagram-blog/
```

---

## 🌐 访问地址

```
网站首页:
https://lightcyan-lark-256774.hostingersite.com

管理后台（配置后）:
https://lightcyan-lark-256774.hostingersite.com/admin/

讨论区:
https://lightcyan-lark-256774.hostingersite.com/discussions/

关于页面:
https://lightcyan-lark-256774.hostingersite.com/about/
```

---

## 📚 文档索引

```
README.md              - 项目概述和快速开始
INSTALLATION.md        - 详细安装配置指南
PROJECT_SUMMARY.md     - 完整技术总结
CHECKLIST.md           - 部署配置检查清单
DEPLOYMENT_GUIDE.md    - 详细部署操作指南
DELIVERY_REPORT.md     - 项目交付报告
QUICK_REFERENCE.md     - 本快速参考（你正在看）
```

---

## 🔧 常用操作

### 备份项目
```bash
tar -czf ~/instagram-blog-backup-$(date +%Y%m%d).tar.gz \
  -C /home/u811056906/projects instagram-blog
```

### 清理构建
```bash
cd /home/u811056906/projects/instagram-blog
rm -rf public/
```

### 重新部署
```bash
cd /home/u811056906/projects/instagram-blog
./deploy.sh
```

### 查看网站统计
```bash
# 文件数量
find /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html -type f | wc -l

# 总大小
du -sh /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html
```

---

## 🎯 下一步行动

### 立即执行
```bash
1. cd /home/u811056906/projects/instagram-blog
2. ./quickstart.sh
3. ./deploy.sh
4. 访问网站验证
```

### 配置任务
```
5. 配置 Netlify CMS（参考 INSTALLATION.md）
6. 配置 Giscus 评论（参考 INSTALLATION.md）
7. 上传自定义头像
8. 修改网站信息
```

### 内容创作
```
9. 创建第一篇真实文章
10. 编辑关于页面
11. 测试所有功能
```

---

## 💡 提示和技巧

### 图片优化
```bash
# 建议图片尺寸
封面图: 1200x1200 (方形)
文章图片: 最大宽度 1200px
头像: 200x200

# 建议格式
JPEG: 照片
PNG: 图标、透明图
SVG: 矢量图
```

### 性能优化
```bash
# 启用 minify
/home/u811056906/bin/hugo --minify

# 图片压缩（如果有 ImageMagick）
convert input.jpg -quality 85 output.jpg
```

### 安全建议
```bash
# 定期备份
每周: ./deploy.sh（自动备份）
每月: 下载备份到本地

# 检查权限
find /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html -type f ! -perm 644
find /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html -type d ! -perm 755
```

---

## 📞 获取帮助

### 问题排查顺序
```
1. 查看 deploy.log
2. 查看 CHECKLIST.md
3. 查看 DEPLOYMENT_GUIDE.md
4. 查看 Hugo 文档
```

### 外部资源
```
Hugo: https://gohugo.io/documentation/
Netlify CMS: https://www.netlifycms.org/docs/
Giscus: https://giscus.app/zh-CN
Markdown: https://www.markdownguide.org/
```

---

## ⚡ 快捷键盘

```bash
# 创建别名（可选）
echo "alias blog-deploy='cd /home/u811056906/projects/instagram-blog && ./deploy.sh'" >> ~/.bashrc
echo "alias blog-edit='cd /home/u811056906/projects/instagram-blog'" >> ~/.bashrc
source ~/.bashrc

# 使用
blog-edit    # 进入项目目录
blog-deploy  # 快速部署
```

---

**保存此文件以便快速查阅！** 📌

