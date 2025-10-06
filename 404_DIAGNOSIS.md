# 🔍 文章 404 问题深度诊断报告

## 📊 问题概述

### 症状
- ✅ 在 Netlify CMS 中创建并发布了文章 "猫咪"
- ✅ CMS 显示发布成功
- ❌ 访问文章页面显示 404 错误
- ❌ URL: `https://lightcyan-lark-256774.hostingersite.com/posts/2025-10-06-猫咪-index`

### 错误信息
```
404: This Page Does Not Exist
Sorry, the page you are looking for could not be found.
```

---

## 🔬 根本原因分析

### 原因 1: 文章是草稿状态 🔴 主要原因

**发现**:
```yaml
# content/posts/2025-10-06-猫咪/index.md
---
title: 猫咪
date: 2025-10-06T15:42:23+08:00
cover: https://ucarecdn.com/92b51f1c-83ae-4d7b-8b6b-822451657430/
draft: true  # ❌ 这是问题所在！
---
```

**影响**:
- Hugo 默认不会构建草稿文章
- 草稿文章不会出现在网站上
- 访问草稿文章的 URL 会显示 404

**为什么是草稿？**

查看 CMS 配置:
```yaml
# static/admin/config.yml
publish_mode: editorial_workflow
```

这启用了 **编辑工作流**，文章默认保存为草稿。

**工作流程**:
```
创建文章 → 保存 → draft: true (草稿)
    ↓
需要手动发布 → draft: false (发布)
```

---

### 原因 2: Hostinger 站点未同步 🟡 次要原因

**流程分析**:

```
1. 在 CMS 创建文章
   ↓
2. 提交到 GitHub ✅
   ↓
3. Netlify 自动部署 ✅
   ↓
4. Hostinger 需要手动部署 ❌ (未执行)
```

**结果**:
- Netlify 站点: 有最新文章（但因为是草稿，也不显示）
- Hostinger 站点: 没有最新文章

---

### 原因 3: URL 路径错误 🟢 URL 问题

**错误的 URL**:
```
https://lightcyan-lark-256774.hostingersite.com/posts/2025-10-06-猫咪-index
                                                                    ^^^^^^
                                                                    多了 -index
```

**正确的 URL**:
```
https://lightcyan-lark-256774.hostingersite.com/posts/2025-10-06-猫咪/
                                                                    ^
                                                                    斜杠结尾
```

**为什么会有 -index？**

这可能是 CMS 配置的问题:
```yaml
# config.yml
collections:
  - name: "posts"
    path: "{{slug}}/index"  # 这里配置了 index
```

但 Hugo 的 URL 结构是:
```
content/posts/2025-10-06-猫咪/index.md
                              ↓
URL: /posts/2025-10-06-猫咪/
```

---

### 原因 4: 图片使用外部 CDN 🔵 图片问题

**发现**:
```yaml
cover: https://ucarecdn.com/92b51f1c-83ae-4d7b-8b6b-822451657430/
```

**问题**:
- 使用 Uploadcare CDN
- 使用的是 demo public key
- 图片可能无法长期访问

**CMS 配置**:
```yaml
# config.yml
media_library:
  name: uploadcare
  config:
    publicKey: demopublickey  # ❌ Demo key
```

---

## 🎯 完整解决方案

### 解决方案 1: 发布草稿文章（必须）

#### 方法 A: 在 CMS 中发布（推荐）⭐

**步骤**:

1. **访问 CMS**
   ```
   https://rad-dasik-e25922.netlify.app/admin/
   ```

2. **进入工作流**
   - 点击顶部 "工作流" 标签
   - 看到三列: Drafts, In Review, Ready

3. **找到文章**
   - 在 "Drafts" 列找到 "猫咪" 文章

4. **移动到 Ready**
   - 拖动文章到 "Ready" 列
   - 或点击文章 → "Set status" → "Ready"

5. **发布**
   - 点击文章
   - 点击 "发布" 按钮
   - 确认发布

**预期结果**:
- `draft: true` 变为 `draft: false`
- 或者 `draft` 字段被删除
- 文章提交到 GitHub
- Netlify 自动重新部署

---

#### 方法 B: 直接编辑文章（快速）

**步骤**:

1. **访问 CMS**
   ```
   https://rad-dasik-e25922.netlify.app/admin/
   ```

2. **编辑文章**
   - 点击 "博客文章"
   - 找到 "猫咪" 文章
   - 点击编辑

3. **关闭草稿**
   - 找到 "草稿" 开关
   - 关闭它（变为灰色）

4. **发布**
   - 点击 "发布" 按钮
   - 确认发布

---

#### 方法 C: 手动修改文件（高级）

```bash
# 编辑文章
nano /home/u811056906/projects/instagram-blog/content/posts/2025-10-06-猫咪/index.md

# 修改 front matter
# 将 draft: true 改为 draft: false
# 或者直接删除 draft: true 这一行

# 保存并提交
git add .
git commit -m "Publish: 猫咪"
git push origin main
```

---

### 解决方案 2: 同步到 Hostinger（必须）

```bash
cd /home/u811056906/projects/instagram-blog

# 拉取最新更改
git pull origin main

# 部署到 Hostinger
bash deploy.sh
```

**或使用一键脚本**:
```bash
chmod +x fix-cms-issues.sh
bash fix-cms-issues.sh
```

---

### 解决方案 3: 修复图片配置（推荐）

#### 选项 A: 使用本地图片存储（推荐）⭐

**修改 config.yml**:

```yaml
# 注释掉或删除 media_library 配置
# media_library:
#   name: uploadcare
#   config:
#     publicKey: demopublickey
#     ...
```

**效果**:
- 图片上传到 `static/images/uploads/`
- 图片存储在 Git 仓库中
- 完全控制图片

**重新上传封面图**:
1. 编辑 "猫咪" 文章
2. 删除当前封面图
3. 上传本地图片
4. 保存并发布

---

#### 选项 B: 配置自己的 Uploadcare 账号

1. **注册 Uploadcare**
   - 访问: https://uploadcare.com
   - 注册免费账号

2. **获取 Public Key**
   - Dashboard → API keys
   - 复制 Public Key

3. **更新配置**
   ```yaml
   media_library:
     name: uploadcare
     config:
       publicKey: your_actual_public_key
   ```

---

### 解决方案 4: 简化工作流（可选）

如果不需要草稿功能，可以禁用编辑工作流:

**修改 config.yml**:
```yaml
# 注释掉这行
# publish_mode: editorial_workflow
```

**效果**:
- 文章直接发布，不需要工作流
- 保存即发布
- 更简单的工作流程

---

## 📊 两个站点的状态对比

### Netlify 站点
```
URL: https://rad-dasik-e25922.netlify.app
状态: 自动部署，总是最新
文章: 有 "猫咪" 文章（但是草稿，不显示）
更新: 推送到 GitHub 后 2-3 分钟自动更新
```

### Hostinger 站点
```
URL: https://lightcyan-lark-256774.hostingersite.com
状态: 手动部署，可能不是最新
文章: 没有 "猫咪" 文章（未同步）
更新: 需要手动运行 deploy.sh
```

---

## 🧪 验证步骤

### 步骤 1: 验证文章已发布

```bash
# 检查文章状态
cat /home/u811056906/projects/instagram-blog/content/posts/2025-10-06-猫咪/index.md | grep draft

# 应该看到:
# draft: false
# 或者没有 draft 字段
```

### 步骤 2: 验证 Netlify 站点

1. 访问: `https://rad-dasik-e25922.netlify.app`
2. 应该看到 "猫咪" 文章在首页
3. 点击文章
4. 应该能正常访问

### 步骤 3: 验证 Hostinger 站点

1. 访问: `https://lightcyan-lark-256774.hostingersite.com`
2. 应该看到 "猫咪" 文章在首页
3. 点击文章
4. 应该能正常访问

### 步骤 4: 验证 URL

**正确的 URL**:
```
https://lightcyan-lark-256774.hostingersite.com/posts/2025-10-06-猫咪/
```

**测试**:
```bash
# 使用 curl 测试
curl -I https://lightcyan-lark-256774.hostingersite.com/posts/2025-10-06-猫咪/

# 应该返回 200 OK
# 而不是 404
```

---

## 🎯 推荐工作流程

### 正确的发布流程

#### 步骤 1: 创建文章

1. 访问 CMS: `https://rad-dasik-e25922.netlify.app/admin/`
2. 点击 "博客文章" → "新建文章"
3. 填写所有字段
4. **重要**: 关闭 "草稿" 开关
5. 点击 "发布"

#### 步骤 2: 等待 Netlify 部署

1. 等待 2-3 分钟
2. 访问 Netlify 站点验证

#### 步骤 3: 同步到 Hostinger

```bash
cd /home/u811056906/projects/instagram-blog
git pull origin main
bash deploy.sh
```

#### 步骤 4: 验证两个站点

- Netlify: `https://rad-dasik-e25922.netlify.app`
- Hostinger: `https://lightcyan-lark-256774.hostingersite.com`

---

## 💡 避免问题的建议

### 建议 1: 主要使用 Netlify 站点

**理由**:
- ✅ 完全自动化
- ✅ 推送即部署
- ✅ 全球 CDN
- ✅ 免费 HTTPS

**操作**:
- 将 Netlify 站点作为主站
- Hostinger 作为备份
- 或配置自定义域名到 Netlify

---

### 建议 2: 禁用编辑工作流

**如果不需要草稿功能**:

```yaml
# config.yml
# 注释掉这行
# publish_mode: editorial_workflow
```

**效果**:
- 保存即发布
- 不需要手动发布
- 更简单

---

### 建议 3: 使用本地图片

**修改 config.yml**:
```yaml
# 删除 media_library 配置
```

**效果**:
- 图片存储在 Git
- 完全控制
- 不依赖第三方 CDN

---

## 🎉 预期结果

完成所有修复后:

- ✅ "猫咪" 文章已发布（非草稿）
- ✅ Netlify 站点显示文章
- ✅ Hostinger 站点显示文章
- ✅ URL 正确可访问
- ✅ 图片正常显示
- ✅ 未来文章直接发布

---

## 📞 快速参考

### 发布草稿文章
```
CMS → 工作流 → 拖到 Ready → 发布
```

### 同步到 Hostinger
```bash
cd /home/u811056906/projects/instagram-blog
git pull origin main
bash deploy.sh
```

### 一键修复
```bash
chmod +x fix-cms-issues.sh
bash fix-cms-issues.sh
```

---

**现在请执行修复步骤！** 🚀

1. 在 CMS 中发布 "猫咪" 文章
2. 运行 `bash fix-cms-issues.sh`
3. 验证两个站点

