# 🔧 故障排除指南

## 问题 1: Permission Denied（权限被拒绝）

### 症状
```bash
./quickstart.sh
# 输出: bash: ./quickstart.sh: Permission denied
```

### 原因
脚本文件没有执行权限。

### 解决方案

#### 方法 1: 使用修复脚本（推荐）
```bash
cd /home/u811056906/projects/instagram-blog
bash fix-permissions.sh
```

#### 方法 2: 手动修复
```bash
cd /home/u811056906/projects/instagram-blog
chmod +x deploy.sh rollback.sh quickstart.sh build.sh
```

#### 方法 3: 直接用 bash 运行
```bash
cd /home/u811056906/projects/instagram-blog
bash quickstart.sh
bash deploy.sh
```

### 验证修复
```bash
ls -la *.sh
# 应该看到 -rwxr-xr-x (带 x 表示可执行)
```

---

## 问题 2: Fork: Resource Temporarily Unavailable

### 症状
```
bash: fork: retry: Resource temporarily unavailable
```

### 原因
系统进程数达到限制，这是 Hostinger 虚拟主机的临时限制。

### 解决方案

#### 等待几分钟
这通常是临时问题，等待 2-5 分钟后重试。

#### 使用简化命令
不要同时运行多个命令，一次只运行一个：

```bash
# ❌ 不要这样
cd /home/u811056906/projects/instagram-blog && ./deploy.sh && echo "Done"

# ✅ 应该这样
cd /home/u811056906/projects/instagram-blog
./deploy.sh
```

#### 检查后台进程
```bash
ps aux | grep $USER | wc -l
# 如果数量很大（>50），可能有僵尸进程
```

---

## 问题 3: Hugo 构建失败

### 症状
```
Error: failed to build site
```

### 检查步骤

#### 1. 验证 Hugo 安装
```bash
/home/u811056906/bin/hugo version
```

#### 2. 检查配置文件
```bash
/home/u811056906/bin/hugo config
```

#### 3. 详细构建
```bash
cd /home/u811056906/projects/instagram-blog
/home/u811056906/bin/hugo -v
```

#### 4. 检查内容文件
```bash
# 检查 Markdown 语法
find content/ -name "*.md" -exec head -10 {} \;
```

### 常见错误

#### Front Matter 格式错误
```yaml
# ❌ 错误
---
title: 文章标题
date: 2025-01-15
---

# ✅ 正确
---
title: "文章标题"
date: 2025-01-15T10:00:00+08:00
---
```

#### 模板语法错误
检查 `themes/instagram/layouts/` 中的模板文件。

---

## 问题 4: 部署后网站显示 404

### 检查步骤

#### 1. 验证文件已部署
```bash
ls -la /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/
```

#### 2. 检查 index.html
```bash
ls -la /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/index.html
```

#### 3. 检查文件权限
```bash
find /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html -type f ! -perm 644
find /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html -type d ! -perm 755
```

#### 4. 重新设置权限
```bash
PROD_DIR="/home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html"
find "$PROD_DIR" -type f -exec chmod 644 {} \;
find "$PROD_DIR" -type d -exec chmod 755 {} \;
```

---

## 问题 5: 样式丢失（CSS 不加载）

### 症状
网站显示纯文本，没有样式。

### 检查步骤

#### 1. 检查 baseURL
```bash
grep baseURL /home/u811056906/projects/instagram-blog/hugo.toml
```

应该是：
```toml
baseURL = 'https://lightcyan-lark-256774.hostingersite.com/'
```

#### 2. 检查 CSS 文件
```bash
ls -la /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/css/
```

#### 3. 重新构建
```bash
cd /home/u811056906/projects/instagram-blog
rm -rf public/
/home/u811056906/bin/hugo --minify
./deploy.sh
```

---

## 问题 6: 图片无法显示

### 检查步骤

#### 1. 验证图片路径
Markdown 中应使用绝对路径：
```markdown
# ✅ 正确
![图片](/images/uploads/photo.jpg)

# ❌ 错误
![图片](photo.jpg)
![图片](../images/photo.jpg)
```

#### 2. 检查图片文件
```bash
ls -la /home/u811056906/projects/instagram-blog/static/images/
```

#### 3. 检查权限
```bash
find /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/images -type f ! -perm 644
```

---

## 问题 7: 部署脚本卡住

### 症状
运行 `./deploy.sh` 后长时间无响应。

### 解决方案

#### 1. 检查进程
```bash
ps aux | grep hugo
ps aux | grep rsync
```

#### 2. 手动终止
```bash
killall hugo
killall rsync
```

#### 3. 手动部署
参考 DEPLOYMENT_GUIDE.md 中的手动部署步骤。

---

## 问题 8: 备份失败

### 症状
```
Error: Cannot create backup
```

### 检查步骤

#### 1. 检查备份目录
```bash
ls -la /home/u811056906/backups/
```

#### 2. 创建备份目录
```bash
mkdir -p /home/u811056906/backups/instagram-blog
chmod 755 /home/u811056906/backups/instagram-blog
```

#### 3. 检查磁盘空间
```bash
df -h /home/u811056906/
```

---

## 完整诊断流程

### 步骤 1: 环境检查
```bash
# Hugo
/home/u811056906/bin/hugo version

# Git
git --version

# 磁盘空间
df -h

# 进程数
ps aux | grep $USER | wc -l
```

### 步骤 2: 项目检查
```bash
cd /home/u811056906/projects/instagram-blog

# 文件完整性
ls -la hugo.toml
ls -la themes/instagram/
ls -la content/

# 权限
ls -la *.sh
```

### 步骤 3: 构建测试
```bash
# 清理
rm -rf public/

# 构建
/home/u811056906/bin/hugo --minify -v

# 检查结果
ls -la public/
```

### 步骤 4: 部署测试
```bash
# 手动部署
bash deploy.sh

# 检查日志
tail -50 deploy.log

# 验证
ls -la /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/
```

---

## 快速修复命令集合

### 修复所有权限
```bash
cd /home/u811056906/projects/instagram-blog
bash fix-permissions.sh
```

### 完全重新部署
```bash
cd /home/u811056906/projects/instagram-blog
rm -rf public/
/home/u811056906/bin/hugo --minify --cleanDestinationDir
bash deploy.sh
```

### 紧急回滚
```bash
cd /home/u811056906/projects/instagram-blog
bash rollback.sh
```

### 清理并重启
```bash
cd /home/u811056906/projects/instagram-blog
rm -rf public/
rm -f deploy.log
bash quickstart.sh
```

---

## 获取帮助

### 查看日志
```bash
# 部署日志
tail -100 /home/u811056906/projects/instagram-blog/deploy.log

# 实时日志
tail -f /home/u811056906/projects/instagram-blog/deploy.log
```

### 检查系统状态
```bash
# 内存使用
free -h

# 磁盘使用
df -h

# 进程列表
ps aux | grep $USER
```

---

## 联系支持

如果以上方法都无法解决问题：

1. 收集错误信息
2. 查看 deploy.log
3. 记录执行的命令
4. 查看 Hugo 文档: https://gohugo.io/documentation/

---

**最后更新**: 2025-01-15

