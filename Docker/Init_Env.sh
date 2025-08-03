#!/bin/bash

echo "===================================="
echo "🚀 青龙面板首次环境初始化脚本 (最终极·永久稳定版)"
echo "⏳ 开始时间：$(date '+%Y-%m-%d %H:%M:%S')"
echo "💡 本脚本将持久化安装 Python/Node.js 常用依赖，重启不丢失"
echo "💡 所有包安装在 /ql/data/ 下，确保永久保存"
echo "===================================="

# 启用颜色输出
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[36m'
RESET='\033[0m'

log_info() {
    echo -e "${BLUE}📋 INFO: $1${RESET}"
}

log_success() {
    echo -e "${GREEN}✅ SUCCESS: $1${RESET}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  WARNING: $1${RESET}"
}

log_error() {
    echo -e "${RED}❌ ERROR: $1${RESET}"
}

# ==================== 1. 配置持久化路径 ====================
# 调整为青龙默认的 dep_cache 路径
PYTHON_SITE="/ql/data/dep_cache/python3/lib/python3.11/site-packages"
NODE_MODULES_DIR="/ql/data/scripts/node_modules"

log_info "设置持久化路径"
mkdir -p "$PYTHON_SITE"
mkdir -p "$NODE_MODULES_DIR"

# ==================== 2. 配置 pip 使用阿里云镜像 ====================
log_info "配置 pip 使用阿里云镜像源"
pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple/    
pip3 config set global.trusted-host mirrors.aliyun.com

# ==================== 3. 升级 pip ====================
log_info "升级 pip"
# 使用 --root-user-action=ignore 代替 --break-system-packages，更兼容
if pip3 install --upgrade pip --root-user-action=ignore 2>/dev/null; then
    log_success "pip 升级成功"
else
    log_warning "pip 升级失败（可能权限问题），继续执行..."
fi

# ==================== 4. 安装 Python 常用依赖到持久化目录 ====================
log_info "安装 Python 常用库到持久化目录: $PYTHON_SITE"
PYTHON_PKGS="requests pillow lxml pycryptodome qrcode jieba beautifulsoup4 httpx numpy pandas matplotlib oss2"

# 优先使用 --root-user-action=ignore
if pip3 install --target "$PYTHON_SITE" $PYTHON_PKGS --root-user-action=ignore 2>/dev/null; then
    log_success "Python 依赖安装成功"
elif pip3 install --target "$PYTHON_SITE" $PYTHON_PKGS 2>/dev/null; then
    log_success "Python 依赖安装成功 (无 ignore)"
else
    log_error "Python 依赖安装失败，请检查网络或手动安装"
fi

# ==================== 5. 配置 npm 和 pnpm 使用淘宝镜像 ====================
log_info "配置 npm 使用 npmmirror (原淘宝镜像)"
npm config set registry https://registry.npmmirror.com    

log_info "安装 pnpm 并配置镜像"
npm install -g pnpm --registry https://registry.npmmirror.com    
pnpm config set registry https://registry.npmmirror.com    

# ==================== 6. 安装 Node.js 依赖到 /ql/data/scripts/node_modules ====================
log_info "安装 Node.js 依赖到: $NODE_MODULES_DIR"
cd /ql/data/scripts || { log_error "无法进入 /ql/data/scripts"; exit 1; }

# 清理旧的 node_modules（可选，首次运行可注释）
# rm -rf node_modules

# 使用 pnpm add 而不是 pnpm install，更明确
pnpm add axios crypto-js tslib request form-data cheerio jimp png-js

if [ $? -eq 0 ]; then
    log_success "Node.js 依赖安装成功"
else
    log_error "Node.js 依赖安装失败"
fi

# ==================== 7. 设置 PYTHONPATH 环境变量（关键！）====================
log_info "设置 PYTHONPATH 环境变量，确保脚本能找到持久化包"

# 检查是否已添加
if ! grep -q "PYTHONPATH=/ql/data/dep_cache/python3/lib/python3.11/site-packages" ~/.bashrc; then
    echo 'export PYTHONPATH="/ql/data/dep_cache/python3/lib/python3.11/site-packages:$PYTHONPATH"' >> ~/.bashrc
    log_success "已将 PYTHONPATH 添加到 ~/.bashrc"
else
    log_info "PYTHONPATH 已存在，跳过添加"
fi

# 同时写入 /etc/profile（更全局）
if ! grep -q "PYTHONPATH=/ql/data/dep_cache/python3/lib/python3.11/site-packages" /etc/profile; then
    echo 'export PYTHONPATH="/ql/data/dep_cache/python3/lib/python3.11/site-packages:$PYTHONPATH"' >> /etc/profile
    log_success "已将 PYTHONPATH 添加到 /etc/profile"
else
    log_info "PYTHONPATH 已存在，跳过添加"
fi

# ==================== 8. 最终环境测试 ====================
log_info "开始最终环境测试..."

# 测试 Python
python3 << 'EOF'
import sys
print("=== Python 环境测试 ===")
print(f"PYTHONPATH: {sys.path}")

missing = False
pkgs = {
    "requests": "requests",
    "Crypto": "pycryptodome",
    "jieba": "jieba",
    "lxml": "lxml",
    "PIL": "Pillow",
    "bs4": "beautifulsoup4"
}

for import_name, pkg_name in pkgs.items():
    try:
        __import__(import_name)
        print(f"✅ {pkg_name} 导入成功")
    except ImportError as e:
        print(f"❌ {pkg_name} 导入失败: {e}")
        missing = True

if not missing:
    print("🎉 所有 Python 包导入成功！")
else:
    print("⚠️  有包缺失，请检查安装")
EOF

# 测试 Node.js
node << 'EOF'
console.log("=== Node.js 环境测试 ===");
const testPackages = ['axios', 'crypto-js', 'cheerio', 'jimp'];

let allOk = true;
testPackages.forEach(pkg => {
    try {
        require(pkg);
        console.log(`✅ ${pkg} 加载成功`);
    } catch (e) {
        console.log(`❌ ${pkg} 加载失败: ${e.message}`);
        allOk = false;
    }
});

if (allOk) {
    console.log("🎉 所有 Node.js 包加载成功！");
    console.log("💡 你现在可以在任何 JS 脚本中使用：const axios = require('axios');");
} else {
    console.log("⚠️  有 Node.js 包缺失，请检查 node_modules");
}
EOF

# ==================== 9. 清理缓存（可选）====================
log_info "清理 pip 和 npm 缓存以节省空间"
pip3 cache purge 2>/dev/null || log_warning "清理 pip 缓存失败"
npm cache clean --force 2>/dev/null || log_warning "清理 npm 缓存失败"

# ==================== 10. 完成提示 ====================
echo "===================================="
echo -e "${GREEN}🎉 恭喜！青龙面板环境初始化完成！${RESET}"
echo "📌 所有依赖已安装到 /ql/data/ 目录，重启不丢失"
echo "📌 Python 包路径: /ql/data/dep_cache/python3/lib/python3.11/site-packages"
echo "📌 Node.js 包路径: /ql/data/scripts/node_modules"
echo "📌 已自动配置 PYTHONPATH，无需每次设置"
echo "💡 推荐添加脚本仓库："
echo "    ql repo https://github.com/lxk0301/jd_scripts.git    "
echo "💡 从此，JS 脚本可直接使用：const axios = require('axios');"
echo "💡 Python 脚本可直接使用：import requests"
echo "===================================="