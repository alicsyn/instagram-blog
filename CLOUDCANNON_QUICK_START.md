# 🚀 CloudCannon 快速开始指南

## 📊 当前状况

❌ **Netlify 已达使用限制，本月无法使用管理后台**

✅ **解决方案**: CloudCannon + GitHub（21 天免费试用）

---

## ⏰ 快速实施（30 分钟）

### 步骤 1: 注册 CloudCannon（5 分钟）

#### 访问注册页面

**URL**: https://cloudcannon.com

#### 注册流程

```
1. 点击 "Start 21-day trial" 或 "Get started"
2. 选择 "Standard" 计划（推荐）
3. 使用 Google 账号注册 ✅
   - 点击 "Sign up with Google"
   - 选择您的 Google 账号
   - 授权 CloudCannon
4. 填写基本信息:
   - Organization name: Instagram Blog（或任意名称）
   - 确认邮箱
5. 完成注册
```

**重要**: 
- ✅ 可以使用 Google 账号
- ✅ 21 天内完全免费
- ✅ 无需信用卡（试用期间）

---

### 步骤 2: 创建站点（5 分钟）

#### 添加新站点

```
1. 在 CloudCannon 控制台
2. 点击 "Add new site" 或 "Create site"
3. 输入站点名称: Instagram Blog
4. 点击 "Create site"
```

#### 连接 GitHub

```
1. 选择 "Connect your own files"
2. 选择 "GitHub"
3. 点击 "Authorize CloudCannon"
4. 在 GitHub 授权页面:
   - 查看权限请求
   - 点击 "Authorize CloudCannon"
5. 返回 CloudCannon
```

#### 选择仓库

```
1. 在仓库列表中找到: alicsyn/instagram-blog
2. 点击选择
3. 选择分支: main
4. 点击 "Sync files"
```

---

### 步骤 3: 配置构建（5 分钟）

#### 自动检测

CloudCannon 会自动检测 Hugo 配置。

**如果自动检测成功**:
- ✅ 直接进入下一步

**如果需要手动配置**:

```
1. 在站点设置中找到 "Build"
2. 配置以下选项:

   Static Site Generator: Hugo
   
   Hugo Version: 0.121.2
   （或查看您的项目使用的版本）
   
   Build Command: hugo
   
   Output Directory: public
   
   Environment Variables（如需要）:
   HUGO_ENV=production
```

#### 验证配置

```
1. 点击 "Save"
2. 点击 "Build site"
3. 等待构建完成（通常 1-2 分钟）
4. 查看构建日志，确认无错误
```

---

### 步骤 4: 配置内容编辑（10 分钟）

#### 自动检测内容

CloudCannon 会自动检测:
- ✅ 内容集合（content/posts/）
- ✅ 数据文件（data/）
- ✅ 配置文件（config.toml）

#### 配置集合（可选）

**如果需要自定义**:

```
1. 在站点设置中找到 "Collections"
2. CloudCannon 应该已经检测到 "posts" 集合
3. 点击 "posts" 进行配置:
   
   Name: 博客文章
   Path: content/posts
   
   Schema（字段配置）:
   - title: 标题
   - date: 发布日期
   - cover: 封面图片
   - description: 摘要
   - tags: 标签
   - categories: 分类
   - body: 内容
```

#### 配置可视化编辑（可选）

```
1. 在站点设置中找到 "Visual Editor"
2. 启用可视化编辑
3. 配置编辑区域
```

---

### 步骤 5: 测试编辑（5 分钟）

#### 访问 CMS

```
1. 在 CloudCannon 控制台
2. 点击站点名称
3. 点击 "Collections" 或 "Content"
4. 选择 "博客文章"（posts）
```

#### 测试创建文章

```
1. 点击 "Add new post" 或 "Create"
2. 填写文章信息:
   - 标题: 测试文章
   - 内容: 这是一篇测试文章
3. 点击 "Save"
4. 查看是否自动提交到 GitHub
```

#### 验证 GitHub 同步

```
1. 访问 GitHub 仓库: https://github.com/alicsyn/instagram-blog
2. 查看最新提交
3. 应该看到 CloudCannon 的自动提交
```

---

### 步骤 6: 配置域名（可选，5 分钟）

#### 测试域名

CloudCannon 自动提供测试域名:
```
yoursite.cloudvent.net
```

#### 配置自定义域名

**如果要使用自己的域名**:

```
1. 在站点设置中找到 "Hosting"
2. 点击 "Add domain"
3. 输入域名: yourdomain.com
4. 按照指示配置 DNS:
   
   添加 CNAME 记录:
   Name: @ 或 www
   Value: [CloudCannon 提供的值]
   
5. 等待 DNS 传播（通常 5-30 分钟）
6. CloudCannon 自动配置 HTTPS
```

---

## ✅ 完成检查清单

- [ ] 注册 CloudCannon 账号（使用 Google）
- [ ] 创建站点
- [ ] 连接 GitHub 仓库
- [ ] 配置 Hugo 构建
- [ ] 验证构建成功
- [ ] 配置内容集合
- [ ] 测试创建文章
- [ ] 验证 GitHub 同步
- [ ] （可选）配置自定义域名
- [ ] 测试编辑功能

---

## 🎯 使用 CloudCannon CMS

### 登录

**URL**: https://app.cloudcannon.com

**方式**:
- ✅ 使用 Google 账号登录
- ✅ 或使用邮箱密码

### 编辑内容

#### 方式 1: 内容编辑器

```
1. 登录 CloudCannon
2. 选择站点
3. 点击 "Collections"
4. 选择 "博客文章"
5. 点击文章或创建新文章
6. 使用 Markdown 编辑器编辑
7. 点击 "Save"
8. 自动提交到 GitHub
9. 自动触发构建
```

#### 方式 2: 可视化编辑器（如已配置）

```
1. 点击 "Visual Editor"
2. 直接在页面上编辑
3. 实时预览
4. 保存后自动同步
```

### 上传图片

```
1. 在编辑器中
2. 点击图片图标
3. 选择 "Upload"
4. 选择图片文件
5. 自动上传并插入
```

### 发布文章

```
1. 编辑完成后
2. 点击 "Save"
3. CloudCannon 自动:
   - 提交到 GitHub
   - 触发构建
   - 部署到 CDN
4. 几分钟后文章上线
```

---

## 💰 费用说明

### 试用期（21 天）

**完全免费**:
- ✅ 所有功能
- ✅ 无限站点
- ✅ 无需信用卡

### 试用结束后

**需要选择**:

#### 选项 A: 继续使用（推荐）

**Standard 计划**:
- 月付: $55/月
- 年付: $49/月（节省 $72/年）

**包含**:
- 无限站点
- 3 个用户
- 75GB 带宽
- 5 个自定义域名

#### 选项 B: 暂停账号

**如果不付费**:
- 账号将被暂停
- 无法编辑内容
- 可以导出数据

#### 选项 C: 申请延长试用

**联系销售团队**:
- 说明情况
- 可能获得延长
- 邮箱: sales@cloudcannon.com

---

## 🔄 从 Netlify 迁移

### 保留 Netlify 托管（可选）

**架构**:
```
CloudCannon CMS（内容管理）
  ↓
GitHub（代码仓库）
  ↓
Netlify（托管）← 如果 Netlify 限制解除
```

**配置**:
1. CloudCannon 只用于 CMS
2. 禁用 CloudCannon 托管
3. 继续使用 Netlify 托管
4. GitHub 同时触发两边构建

### 完全迁移到 CloudCannon（推荐）

**架构**:
```
CloudCannon CMS + 托管（一站式）
  ↓
GitHub（代码仓库）
```

**优势**:
- ✅ 简化架构
- ✅ 统一管理
- ✅ 不受 Netlify 限制

---

## 🆚 CloudCannon vs Netlify

| 特性 | CloudCannon | Netlify 免费 |
|------|------------|-------------|
| **CMS** | 内置，稳定 | Decap CMS，不稳定 |
| **可视化编辑** | ✅ | ❌ |
| **Google 登录** | ✅ | ❌ |
| **构建时间** | 无限制 | 300 分钟/月 |
| **带宽** | 75GB | 100GB |
| **支持** | 专业支持 | 社区支持 |
| **价格** | $49/月起 | 免费 |

---

## 📞 获取帮助

### CloudCannon 资源

**文档**: https://cloudcannon.com/documentation/  
**社区**: https://community.cloudcannon.com/  
**支持**: 应用内聊天或 support@cloudcannon.com

### Hugo 资源

**文档**: https://gohugo.io/documentation/  
**社区**: https://discourse.gohugo.io/

---

## 🎉 总结

### 立即行动

1. **现在**: 注册 CloudCannon 21 天试用
2. **今天**: 连接 GitHub，配置构建
3. **今天**: 测试编辑功能
4. **21 天内**: 决定是否继续

### 预期结果

✅ **30 分钟内**:
- 完成所有配置
- 可以开始编辑内容
- 解决 Netlify 限制问题

✅ **21 天试用期**:
- 充分评估功能
- 决定是否付费
- 无风险尝试

---

**现在就开始，立即解决 Netlify 限制问题！** 🚀

**注册链接**: https://cloudcannon.com

