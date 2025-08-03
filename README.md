# 🐉 QingLong 青龙面板脚本管理 <img align="right" width="100" height="100" src="https://raw.githubusercontent.com/black2c7/TheMagic-Icons/main/Icons/Xiaoheizi1.png" alt="european-dragon">

![Version](https://img.shields.io/badge/version-2.11.3-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue)
![Python](https://img.shields.io/badge/python-3.8%2B-blue)
![Node.js](https://img.shields.io/badge/node.js-14%2B-green)

> 一个强大、灵活的青龙面板脚本部署与管理，专为自动化任务和脚本学习设计。

---

## 🌟 项目概述

**QingLong** 是一款基于青龙面板的脚本管理，旨在简化脚本的部署、运行和监控流程。您可以灵活控制脚本的执行权限，同时支持环境一键初始化，让您专注于脚本开发而非环境配置。

---

## 🚀 核心功能

- **📦 一键环境初始化**  
  自动安装 Python 和 Node.js 的常用依赖库，无需手动操作。
- **🔒 持久化依赖管理**  
  所有依赖安装在 `/ql/data/` 目录下，重启后依然保留。
- **📊 环境状态监控**  
  实时检测系统命令、网络连通性、Python 和 Node.js 环境状态。
- **📂 文件结构探测**  
  可视化查看青龙面板内部文件结构，便于调试和管理。

---

## 🛠️ 快速开始

### 1. 青龙面板搭建
请参考以下文档:⬇️
- [📖 青龙面板文档](https://qinglong.online/index)
- [🚀 安装青龙面板-宝塔](https://qinglong.online/guide/getting-started/installation-guide)
- [🚀 安装青龙面板-1panel](https://qinglong.online/guide/getting-started/installation-guide/1panel)
- [🚀 安装青龙面板-Docker](https://qinglong.online/guide/getting-started/installation-guide/docker)
- [🌱 快速入门](https://qinglong.online/guide/getting-started)
### 2. 自用comepose安装
```yaml
services:
  qinglong:
    image: whyour/qinglong:debian
    container_name: QingLong
    hostname: qinglong
    volumes:
      - ./data:/ql/data
    ports:
      - "5700:5700"
    environment:
      TZ: Asia/Shanghai
      QlBaseUrl: '/'
      HTTP_PROXY: http://IP:端口
      HTTPS_PROXY: http://IP:端口
      NO_PROXY: localhost,127.0.0.1,.local
      ProxyUrl: http://IP:端口
    restart: unless-stopped
```    
### 3. 青龙面板拉库命令

```bash
ql repo https://github.com/dongshull/QingLong.git main
```

```bash
ql repo https://ghfast.top/https://github.com/dongshull/QingLong.git main
```

### 4. 愉快的开始使用你的青龙脚本吧

---

## 🤝 贡献指南

欢迎提交 Pull Request 或 Issue！请确保您的代码符合项目规范，并附上详细的说明。

---

## 📜 许可证

本项目基于 [MIT License](LICENSE) 开源。

---

## ⚠️ 免责声明

1. **脚本用途**  
   本仓库中的脚本仅用于测试和学习研究，禁止用于商业用途。不能保证其合法性、准确性、完整性和有效性，请根据情况自行判断。

2. **资源文件**  
   仓库内所有资源文件，禁止任何公众号、自媒体进行任何形式的转载或发布。

3. **责任限制**  
   - dongshull 对任何脚本问题概不负责，包括但不限于由脚本错误导致的任何损失或损害。  
   - 间接使用脚本的任何用户（如建立 VPS 或违反国家/地区法律的行为），dongshull 对由此引起的隐私泄漏或其他后果概不负责。

4. **侵权处理**  
   若认为脚本涉嫌侵犯您的权利，请及时提供身份证明和所有权证明，我们将在收到认证文件后删除相关脚本。

5. **使用条款**  
   任何使用或复制本项目脚本的行为，视为您已接受此免责声明。dongshull 保留随时更改或补充此声明的权利。

6. **删除要求**  
   您必须在下载后的 24 小时内从设备中完全删除相关内容。严禁利用脚本产生任何利益链！