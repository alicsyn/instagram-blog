# 🚀 Instagram 博客部署指南

## 📋 部署前准备

### 1. 验证环境

```bash
# 检查 Hugo
/home/u811056906/bin/hugo version
# 应显示: hugo v0.121.2+extended

# 检查 Git
git --version
# 应显示: git version 2.43.7

# 检查项目目录
cd /home/u811056906/projects/instagram-blog
ls -la
```

### 2. 验证文件完整性

```bash
# 检查关键文件
ls -la hugo.toml
ls -la deploy.sh
ls -la themes/instagram/
ls -la content/posts/
```

---

## 🎯 快速部署（推荐）

### 一键部署

```bash
cd /home/u811056906/projects/instagram-blog

# 1. 运行快速启动脚本
chmod +x quickstart.sh
./quickstart.sh

# 2. 如果测试成功，执行部署
chmod +x deploy.sh
./deploy.sh
```

### 预期输出

```
=========================================
🚀 开始部署 Instagram 博客
=========================================
📋 检查 Hugo...
✅ Hugo 已安装
🧹 清理旧的构建文件...
🔨 构建 Hugo 网站...
✅ 构建成功 (耗时: 3秒)
📊 生成了 28 个文件，总大小: 456K
💾 备份当前生产环境...
✅ 备份完成: backup_20250115_143022.tar.gz
📤 部署到生产环境...
✅ 文件同步成功
🔐 设置文件权限...
✅ 权限设置完成
🔍 验证部署...
✅ 部署验证成功
=========================================
✅ 部署完成！
=========================================
⏱️  总耗时: 8秒
🌐 网站地址: https://lightcyan-lark-256774.hostingersite.com
```

---

## 📝 手动部署步骤

### 步骤 1: 构建网站

```bash
cd /home/u811056906/projects/instagram-blog

# 清理旧文件
rm -rf public/

# 构建网站
/home/u811056906/bin/hugo --minify --cleanDestinationDir

# 检查结果
ls -la public/
```

### 步骤 2: 备份生产环境

```bash
# 创建备份目录
mkdir -p /home/u811056906/backups/instagram-blog

# 备份当前生产环境
PROD_DIR="/home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html"
BACKUP_FILE="/home/u811056906/backups/instagram-blog/manual_backup_$(date +%Y%m%d_%H%M%S).tar.gz"

tar -czf "$BACKUP_FILE" -C "$PROD_DIR" .

echo "备份完成: $BACKUP_FILE"
```

### 步骤 3: 同步文件

```bash
# 同步到生产环境
rsync -av --delete \
  /home/u811056906/projects/instagram-blog/public/ \
  /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/
```

### 步骤 4: 设置权限

```bash
PROD_DIR="/home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html"

# 设置文件权限
find "$PROD_DIR" -type f -exec chmod 644 {} \;
find "$PROD_DIR" -type d -exec chmod 755 {} \;

echo "权限设置完成"
```

### 步骤 5: 验证部署

```bash
# 检查关键文件
ls -la /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/index.html

# 统计文件
find /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html -type f | wc -l

# 访问网站
echo "请访问: https://lightcyan-lark-256774.hostingersite.com"
```

---

## 🔄 更新部署

### 更新内容后重新部署

```bash
cd /home/u811056906/projects/instagram-blog

# 1. 提交更改到 Git
git add .
git commit -m "Update content"

# 2. 重新部署
./deploy.sh
```

### 只更新特定文件

```bash
# 如果只修改了 CSS
rsync -av themes/instagram/static/css/ \
  /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/css/

# 如果只修改了 JS
rsync -av themes/instagram/static/js/ \
  /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/js/
```

---

## 🔙 回滚部署

### 使用回滚脚本

```bash
cd /home/u811056906/projects/instagram-blog

# 运行回滚脚本
./rollback.sh

# 按提示选择要恢复的备份
```

### 手动回滚

```bash
# 1. 查看可用备份
ls -lht /home/u811056906/backups/instagram-blog/

# 2. 选择备份文件
BACKUP_FILE="/home/u811056906/backups/instagram-blog/backup_20250115_143022.tar.gz"
PROD_DIR="/home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html"

# 3. 清空生产目录
rm -rf "$PROD_DIR"/*

# 4. 解压备份
tar -xzf "$BACKUP_FILE" -C "$PROD_DIR"

# 5. 设置权限
find "$PROD_DIR" -type f -exec chmod 644 {} \;
find "$PROD_DIR" -type d -exec chmod 755 {} \;

echo "回滚完成"
```

---

## 🔧 故障排除

### 问题 1: 部署脚本权限错误

```bash
# 解决方案
chmod +x deploy.sh rollback.sh quickstart.sh
```

### 问题 2: Hugo 构建失败

```bash
# 查看详细错误
/home/u811056906/bin/hugo -v

# 检查配置文件
/home/u811056906/bin/hugo config

# 验证内容文件
find content/ -name "*.md" -exec head -5 {} \;
```

### 问题 3: 文件同步失败

```bash
# 检查目标目录权限
ls -la /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/

# 手动创建目录
mkdir -p /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html

# 重试同步
rsync -av --delete public/ /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/
```

### 问题 4: 网站显示 404

```bash
# 检查 index.html 是否存在
ls -la /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/index.html

# 检查文件权限
ls -la /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/

# 重新设置权限
find /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html -type f -exec chmod 644 {} \;
find /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html -type d -exec chmod 755 {} \;
```

---

## 📊 部署验证清单

### 基础验证

- [ ] 网站首页可访问
- [ ] 导航菜单正常工作
- [ ] 文章列表显示正确
- [ ] 文章详情页可访问
- [ ] 关于页面正常
- [ ] 讨论区页面正常

### 样式验证

- [ ] CSS 样式加载正常
- [ ] Instagram 风格显示正确
- [ ] 响应式设计工作正常
- [ ] 移动端显示正常

### 功能验证

- [ ] 图片加载正常
- [ ] 链接跳转正确
- [ ] 返回顶部按钮工作
- [ ] 代码高亮显示正常

### 性能验证

- [ ] 首页加载时间 < 2秒
- [ ] 文章页加载时间 < 2秒
- [ ] 图片优化正常
- [ ] 无 JavaScript 错误

---

## 🔐 安全检查

### 文件权限

```bash
# 检查文件权限
find /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html -type f ! -perm 644

# 检查目录权限
find /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html -type d ! -perm 755
```

### 敏感文件检查

```bash
# 确保这些文件不在生产环境
PROD_DIR="/home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html"

ls -la "$PROD_DIR/.git" 2>/dev/null && echo "⚠️  警告: .git 目录存在" || echo "✅ .git 目录不存在"
ls -la "$PROD_DIR/.env" 2>/dev/null && echo "⚠️  警告: .env 文件存在" || echo "✅ .env 文件不存在"
ls -la "$PROD_DIR/deploy.sh" 2>/dev/null && echo "⚠️  警告: deploy.sh 存在" || echo "✅ deploy.sh 不存在"
```

---

## 📈 性能优化

### 启用 Gzip 压缩

创建 `.htaccess` 文件：

```bash
cat > /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/.htaccess << 'EOF'
# Gzip 压缩
<IfModule mod_deflate.c>
  AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css text/javascript application/javascript
</IfModule>

# 浏览器缓存
<IfModule mod_expires.c>
  ExpiresActive On
  ExpiresByType image/jpg "access plus 1 year"
  ExpiresByType image/jpeg "access plus 1 year"
  ExpiresByType image/png "access plus 1 year"
  ExpiresByType image/svg+xml "access plus 1 year"
  ExpiresByType text/css "access plus 1 month"
  ExpiresByType application/javascript "access plus 1 month"
</IfModule>
EOF
```

---

## 🔄 自动化部署

### 使用 Cron 定时部署

```bash
# 编辑 crontab
crontab -e

# 添加定时任务（每小时检查更新）
0 * * * * cd /home/u811056906/projects/instagram-blog && git pull && /home/u811056906/projects/instagram-blog/deploy.sh >> /home/u811056906/projects/instagram-blog/cron.log 2>&1
```

### 使用 Git Hooks

```bash
# 创建 post-receive hook
cat > /home/u811056906/projects/instagram-blog/.git/hooks/post-receive << 'EOF'
#!/bin/bash
cd /home/u811056906/projects/instagram-blog
/home/u811056906/projects/instagram-blog/deploy.sh
EOF

chmod +x /home/u811056906/projects/instagram-blog/.git/hooks/post-receive
```

---

## 📝 部署日志

### 查看部署日志

```bash
# 查看最近的部署日志
tail -50 /home/u811056906/projects/instagram-blog/deploy.log

# 实时查看日志
tail -f /home/u811056906/projects/instagram-blog/deploy.log

# 搜索错误
grep -i error /home/u811056906/projects/instagram-blog/deploy.log
```

### 清理日志

```bash
# 备份日志
cp deploy.log deploy.log.backup

# 清空日志
> deploy.log

# 或者只保留最近 100 行
tail -100 deploy.log > deploy.log.tmp && mv deploy.log.tmp deploy.log
```

---

## 🎯 下一步

部署成功后：

1. **验证网站** - 访问 https://lightcyan-lark-256774.hostingersite.com
2. **配置 CMS** - 参考 INSTALLATION.md 配置 Netlify CMS
3. **配置评论** - 参考 INSTALLATION.md 配置 Giscus
4. **创建内容** - 开始创作你的第一篇文章
5. **自定义** - 修改配置、上传头像、调整样式

---

## 📞 获取帮助

如果遇到问题：

1. 查看 `deploy.log` 日志文件
2. 查看 `CHECKLIST.md` 检查清单
3. 查看 `INSTALLATION.md` 安装指南
4. 查看 Hugo 文档: https://gohugo.io/documentation/

---

**祝部署顺利！** 🎉

