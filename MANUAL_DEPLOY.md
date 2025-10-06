# 📝 手动分步部署指南

## 🎯 适用场景

当遇到以下情况时使用此手动部署方法：
- ❌ 自动部署脚本失败
- ❌ CPU 使用量达到限制
- ❌ 出现 "fork: Resource temporarily unavailable" 错误
- ✅ 需要最稳定的部署方式

---

## ⏰ 部署前准备

### 1. 等待系统恢复（5-10 分钟）

如果刚遇到 CPU 限制错误，请等待 5-10 分钟。

### 2. 检查系统状态（可选）

```bash
# 检查进程数
ps aux | grep $USER | wc -l
# 如果 < 20，说明可以继续

# 检查磁盘空间
df -h /home/u811056906/
# 确保有足够空间（至少 100MB）
```

---

## 🚀 手动部署步骤

### 步骤 1: 进入项目目录

```bash
cd /home/u811056906/projects/instagram-blog
```

**验证**:
```bash
pwd
# 应显示: /home/u811056906/projects/instagram-blog
```

---

### 步骤 2: 清理旧构建（可选）

```bash
rm -rf public/
```

**说明**: 删除之前的构建文件，确保全新构建。

---

### 步骤 3: 构建 Hugo 网站

```bash
/home/u811056906/bin/hugo --minify --cleanDestinationDir
```

**预期输出**:
```
Start building sites … 
hugo v0.121.2+extended

                   | ZH-CN  
-------------------+--------
  Pages            |    28  
  Paginator pages  |     0  
  Non-page files   |     2  
  Static files     |     5  
  Processed images |     0  
  Aliases          |     8  
  Sitemaps         |     1  
  Cleaned          |     0  

Total in 123 ms
```

**如果成功**:
- ✅ 看到 "Total in XXX ms"
- ✅ 没有 "Error" 字样
- ✅ 继续下一步

**如果失败**:
- ❌ 看到 "Error: ..." 
- ❌ 检查错误信息
- ❌ 参考 TROUBLESHOOTING.md

---

### 步骤 4: 验证构建结果

```bash
ls -la public/
```

**应该看到**:
```
drwxr-xr-x  index.html
drwxr-xr-x  css/
drwxr-xr-x  js/
drwxr-xr-x  images/
drwxr-xr-x  posts/
drwxr-xr-x  about/
drwxr-xr-x  discussions/
...
```

**检查关键文件**:
```bash
ls -la public/index.html
ls -la public/css/main.css
ls -la public/js/main.js
```

---

### 步骤 5: 等待 2 分钟（重要）⏰

**为什么要等待**:
- 让系统进程完全结束
- 避免触发 CPU 限制
- 确保文件系统同步

```bash
# 可以做点别的事情，或者运行：
sleep 120
```

---

### 步骤 6: 创建生产目录（如果不存在）

```bash
mkdir -p /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html
```

**验证**:
```bash
ls -la /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/
```

---

### 步骤 7: 同步文件到生产环境

```bash
rsync -av --delete public/ \
  /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/
```

**预期输出**:
```
sending incremental file list
./
index.html
css/
css/main.css
js/
js/main.js
...

sent 123,456 bytes  received 789 bytes  total size 456,789
```

**如果成功**:
- ✅ 看到文件列表
- ✅ 看到 "sent XXX bytes"
- ✅ 没有错误信息

**如果失败**:
- ❌ 检查目标目录权限
- ❌ 检查磁盘空间
- ❌ 重试命令

---

### 步骤 8: 等待 2 分钟（重要）⏰

```bash
sleep 120
```

---

### 步骤 9: 设置文件权限

```bash
# 设置文件权限为 644
find /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html \
  -type f -exec chmod 644 {} \;
```

**等待 1 分钟**:
```bash
sleep 60
```

```bash
# 设置目录权限为 755
find /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html \
  -type d -exec chmod 755 {} \;
```

---

### 步骤 10: 验证部署

```bash
# 检查关键文件
ls -la /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/index.html

# 统计文件数
find /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html -type f | wc -l

# 检查总大小
du -sh /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html
```

**预期结果**:
```
-rw-r--r-- 1 u811056906 ... index.html
28  (文件数)
456K  (总大小)
```

---

### 步骤 11: 访问网站验证

打开浏览器访问：
```
https://lightcyan-lark-256774.hostingersite.com
```

**检查清单**:
- [ ] 首页正常显示
- [ ] Instagram 风格样式正确
- [ ] 导航菜单工作正常
- [ ] 文章列表显示
- [ ] 图片加载正常
- [ ] 移动端响应式正常

---

## 🔧 故障排除

### 问题 1: Hugo 构建失败

**错误**: `Error: Unable to locate config file`

**解决**:
```bash
# 确认在正确目录
pwd
# 应该是: /home/u811056906/projects/instagram-blog

# 检查配置文件
ls -la hugo.toml

# 如果不在正确目录
cd /home/u811056906/projects/instagram-blog
```

---

### 问题 2: rsync 失败

**错误**: `rsync: failed to set permissions`

**解决**:
```bash
# 检查目标目录权限
ls -la /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/

# 创建目录
mkdir -p /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html

# 重试 rsync
```

---

### 问题 3: 网站显示 404

**解决**:
```bash
# 检查 index.html
ls -la /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/index.html

# 如果不存在，重新同步
rsync -av public/ \
  /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/
```

---

### 问题 4: 样式丢失

**解决**:
```bash
# 检查 CSS 文件
ls -la /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/css/

# 检查 baseURL
grep baseURL /home/u811056906/projects/instagram-blog/hugo.toml

# 应该是: baseURL = 'https://lightcyan-lark-256774.hostingersite.com/'
```

---

## 📊 部署后检查

### 1. 文件完整性检查

```bash
# 检查关键文件
PROD_DIR="/home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html"

ls -la "$PROD_DIR/index.html"
ls -la "$PROD_DIR/css/main.css"
ls -la "$PROD_DIR/js/main.js"
ls -la "$PROD_DIR/images/"
ls -la "$PROD_DIR/posts/"
```

### 2. 权限检查

```bash
# 检查文件权限（应该是 644）
find "$PROD_DIR" -type f ! -perm 644 | head -10

# 检查目录权限（应该是 755）
find "$PROD_DIR" -type d ! -perm 755 | head -10
```

### 3. 大小检查

```bash
# 开发环境
du -sh /home/u811056906/projects/instagram-blog/public

# 生产环境
du -sh /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html

# 两者应该大小相近
```

---

## 🎯 成功标志

当你看到以下所有内容时，部署成功：

- ✅ Hugo 构建成功（Total in XXX ms）
- ✅ rsync 同步成功（sent XXX bytes）
- ✅ index.html 存在于生产目录
- ✅ 网站可以访问
- ✅ 样式正常显示
- ✅ 所有页面可访问

---

## 📝 部署记录

建议记录每次部署：

```bash
# 创建部署记录
echo "$(date '+%Y-%m-%d %H:%M:%S') - 手动部署成功" >> \
  /home/u811056906/projects/instagram-blog/manual-deploy.log
```

---

## 🔄 下次部署

下次更新内容后，重复以下步骤：

```bash
# 1. 进入目录
cd /home/u811056906/projects/instagram-blog

# 2. 构建
/home/u811056906/bin/hugo --minify --cleanDestinationDir

# 3. 等待 2 分钟
sleep 120

# 4. 同步
rsync -av --delete public/ \
  /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/

# 5. 完成
echo "✅ 部署完成"
```

---

## 💡 提示

### 最佳实践

1. **每步之间等待** - 避免触发 CPU 限制
2. **验证每一步** - 确保没有错误再继续
3. **记录日志** - 方便排查问题
4. **定期备份** - 在重大更改前备份

### 时间估算

- 总时间: 约 10-15 分钟
- 实际操作: 5 分钟
- 等待时间: 5-10 分钟

---

**祝你部署顺利！** 🚀✨

