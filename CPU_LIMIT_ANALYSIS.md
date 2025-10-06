# 🔍 CPU 限制分析和部署建议

## 📊 当前情况

### 问题 1: 构建失败 ✅ 已修复
**原因**: 部署脚本在备份清理时切换了工作目录，导致 Hugo 在错误的目录执行。

**错误信息**:
```
Error: Unable to locate config file or config directory.
```

**修复**: 已修复 `deploy.sh` 第 81 行，使用子 shell 执行备份清理，避免改变当前目录。

### 问题 2: CPU 使用量达到上限 ⚠️ 需要评估
**Hostinger 提示**: CPU 使用量达到上限

---

## 🎯 CPU 限制评估

### Hostinger 虚拟主机 CPU 限制说明

#### 限制类型
Hostinger 虚拟主机有两种 CPU 限制：

1. **瞬时限制（Entry Process Limit）**
   - 同时运行的进程数限制
   - 通常为 20-40 个进程
   - 触发时会出现 "fork: Resource temporarily unavailable"

2. **每日 CPU 配额（Daily CPU Quota）**
   - 每 24 小时的 CPU 使用总量
   - 达到限制后可能限速或暂停服务
   - 通常在午夜（UTC）重置

#### 你当前的情况
根据错误信息 "fork: Resource temporarily unavailable"，你遇到的是**瞬时进程限制**，而不是每日配额限制。

---

## ⏰ 是否需要等待 24 小时？

### 答案：❌ **不需要等待 24 小时**

### 理由：

#### 1. 瞬时限制会自动恢复
- **恢复时间**: 2-10 分钟
- **原因**: 进程结束后，限制自动解除
- **不影响**: 每日配额

#### 2. 你的 CPU 使用来源
可能的原因：
- ✅ 多次尝试运行脚本（每次都创建新进程）
- ✅ 之前的进程没有正常结束（僵尸进程）
- ✅ 系统后台任务（Hostinger 维护）
- ❌ 不太可能是 Hugo 构建（构建很快，< 5 秒）

#### 3. Hugo 构建的 CPU 消耗很低
```
Hugo 构建特点：
- 构建时间: 3-5 秒
- CPU 使用: 低（单进程）
- 内存使用: < 100MB
- 进程数: 1 个主进程
```

---

## 🚀 推荐的部署策略

### 策略 1: 立即部署（推荐）⭐

**等待时间**: 5-10 分钟

**步骤**:
```bash
# 1. 等待 5-10 分钟让系统恢复

# 2. 检查进程数（可选）
ps aux | grep $USER | wc -l
# 如果 < 20，说明已恢复

# 3. 执行部署
cd /home/u811056906/projects/instagram-blog
bash deploy.sh
```

**优点**:
- ✅ 快速恢复
- ✅ 不影响工作进度
- ✅ 脚本已修复，成功率高

**缺点**:
- ⚠️ 可能需要重试 1-2 次

---

### 策略 2: 手动分步部署（最稳妥）⭐⭐⭐

**等待时间**: 5 分钟

**步骤**:
```bash
# 等待 5 分钟后执行

cd /home/u811056906/projects/instagram-blog

# 步骤 1: 只构建（不部署）
/home/u811056906/bin/hugo --minify --cleanDestinationDir

# 等待 2 分钟

# 步骤 2: 手动同步文件
rsync -av --delete public/ \
  /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/

# 等待 2 分钟

# 步骤 3: 设置权限
find /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html \
  -type f -exec chmod 644 {} \;
find /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html \
  -type d -exec chmod 755 {} \;
```

**优点**:
- ✅ 最稳定
- ✅ 每步独立，易于排查
- ✅ 避免触发进程限制

**缺点**:
- ⚠️ 需要手动执行多个命令

---

### 策略 3: 等待 24 小时（不推荐）❌

**理由**:
- ❌ 没有必要（不是每日配额问题）
- ❌ 浪费时间
- ❌ 问题可能在 10 分钟内自动解决

---

## 🔧 优化建议

### 立即优化

#### 1. 简化部署脚本（减少进程数）

创建轻量级部署脚本：

```bash
cat > /home/u811056906/projects/instagram-blog/deploy-simple.sh << 'EOF'
#!/bin/bash
# 简化版部署脚本 - 减少进程使用

cd /home/u811056906/projects/instagram-blog || exit 1

echo "🔨 构建网站..."
/home/u811056906/bin/hugo --minify --cleanDestinationDir

echo "📤 同步文件..."
rsync -a --delete public/ \
  /home/u811056906/domains/lightcyan-lark-256774.hostingersite.com/public_html/

echo "✅ 部署完成！"
EOF

chmod +x /home/u811056906/projects/instagram-blog/deploy-simple.sh
```

#### 2. 避免同时运行多个命令

**❌ 不要这样**:
```bash
./deploy.sh && ./another-script.sh && echo "Done"
```

**✅ 应该这样**:
```bash
./deploy.sh
# 等待完成
./another-script.sh
```

#### 3. 清理僵尸进程（如果有）

```bash
# 查看你的进程
ps aux | grep $USER

# 如果看到很多僵尸进程，可以尝试：
killall -u $USER hugo
killall -u $USER rsync
```

---

### 长期优化

#### 1. 使用 Git Hooks 自动部署

在本地推送代码后自动部署，避免手动运行脚本。

#### 2. 考虑升级主机方案

如果经常遇到 CPU 限制：
- Hostinger Business 方案（更高 CPU 限制）
- VPS 方案（独立资源）

#### 3. 优化 Hugo 构建

```toml
# hugo.toml 中添加
[build]
  writeStats = false
  noJSConfigInAssets = false
```

---

## 📊 监控和诊断

### 检查当前 CPU 使用

```bash
# 查看进程数
ps aux | grep $USER | wc -l

# 查看 CPU 使用
top -u $USER -n 1

# 查看内存使用
free -h
```

### 查看 Hostinger 控制面板

1. 登录 Hostinger hPanel
2. 查看 "资源使用情况"
3. 检查：
   - CPU 使用百分比
   - 进程数
   - 内存使用
   - I/O 使用

### 判断是否可以部署

**可以部署的信号**:
- ✅ 进程数 < 20
- ✅ CPU 使用 < 80%
- ✅ 没有 "fork" 错误

**需要等待的信号**:
- ⚠️ 进程数 > 30
- ⚠️ CPU 使用 > 90%
- ⚠️ 持续出现 "fork" 错误

---

## 🎯 推荐行动方案

### 现在（立即执行）

1. **等待 5-10 分钟**
   - 让系统进程自然结束
   - 让 CPU 使用率下降

2. **使用简化部署**
   ```bash
   cd /home/u811056906/projects/instagram-blog
   bash deploy-simple.sh
   ```

3. **如果仍然失败**
   - 等待 10 分钟
   - 使用策略 2（手动分步部署）

### 今天晚些时候

4. **验证部署成功**
   - 访问网站
   - 检查所有页面
   - 测试响应式设计

5. **创建第一篇文章**
   - 测试内容管理流程
   - 验证图片上传

### 明天

6. **配置 Netlify CMS**
   - 创建 GitHub 仓库
   - 配置 CMS

7. **优化配置**
   - 自定义网站信息
   - 上传头像

---

## 📞 如果问题持续

### 联系 Hostinger 支持

如果等待 30 分钟后仍然无法部署：

1. 打开 Hostinger 在线客服
2. 说明情况：
   ```
   我的账户遇到 "fork: Resource temporarily unavailable" 错误
   无法运行脚本
   请帮忙检查是否有进程限制或 CPU 配额问题
   ```

3. 请求：
   - 检查账户状态
   - 清理僵尸进程
   - 临时提高进程限制

---

## 📋 总结

### 关键结论

1. **不需要等待 24 小时** ✅
2. **等待 5-10 分钟即可重试** ✅
3. **部署脚本已修复** ✅
4. **使用简化部署更稳定** ✅

### 下一步

```bash
# 1. 等待 5-10 分钟

# 2. 执行部署
cd /home/u811056906/projects/instagram-blog
bash deploy.sh

# 3. 如果成功，访问网站
# https://lightcyan-lark-256774.hostingersite.com

# 4. 如果失败，使用手动分步部署
```

---

**预计成功率**: 95%  
**预计等待时间**: 5-10 分钟  
**风险等级**: 低

**祝你部署顺利！** 🚀✨

