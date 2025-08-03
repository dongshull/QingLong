#!/bin/bash

echo "===================================="
echo "🔍 青龙面板全能环境测试脚本 (修复版)"
echo "⏰ 测试时间：$(date '+%Y-%m-%d %H:%M:%S')"
echo "💡 本脚本在测试前会自动优化环境配置"
echo "===================================="

# === 0. (增强) 优化内部环境配置 ===
echo "🔧 正在优化环境配置..."

# 配置 pip 使用阿里云镜像源
pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple/
pip3 config set global.trusted-host mirrors.aliyun.com

# 配置 npm 使用淘宝镜像
npm config set registry https://registry.npmmirror.com

echo "✅ 环境配置优化完成，开始测试..."

# === 1. 测试 Linux 系统命令 ===
echo -e "\n🐧 正在测试 Linux 基础命令..."
for cmd in curl wget git pip3 npm pnpm python3 node; do
    if command -v $cmd &> /dev/null; then
        echo "✅ $cmd: 已安装 ($(command -v $cmd))"
    else
        echo "❌ $cmd: 未找到"
    fi
done

# === 2. 测试网络连通性 ===
echo -e "\n🌐 正在测试网络连通性..."
if curl -s --head https://mirrors.aliyun.com > /dev/null; then
    echo "✅ 网络正常：可以访问 阿里云镜像源"
else
    echo "❌ 网络异常：无法访问 阿里云镜像源"
fi

if curl -s --head https://api.uomg.com/api/rand.qinghua > /dev/null; then
    echo "✅ 网络正常：可以访问 国内测试API (api.uomg.com)"
else
    echo "❌ 网络异常：无法访问 国内测试API (api.uomg.com)"
fi

# === 3. 测试 Python 环境 ===
echo -e "\n🐍 正在测试 Python 环境..."

# 关键修改：使用 EOF 而不是 'EOF'
python3 << EOF
print("=== 测试 Python 核心库 ===")
try:
    import requests
    print("✅ requests: 导入成功，版本:", requests.__version__)
    res = requests.get("https://api.uomg.com/api/rand.qinghua", timeout=5)
    if res.status_code == 200:
        print("✅ requests: 网络请求测试成功，返回数据:", res.json())
    else:
        print(f"❌ requests: 网络请求失败，状态码: {res.status_code}")
except Exception as e:
    print("❌ requests: 导入或请求失败:", e)

try:
    from Crypto.Cipher import AES
    print("✅ pycryptodome: 导入成功")
except Exception as e:
    print("❌ pycryptodome: 导入失败:", e)

try:
    import jieba
    print("✅ jieba: 导入成功")
except Exception as e:
    print("❌ jieba: 导入失败:", e)

try:
    import numpy
    print("✅ numpy: 导入成功，版本:", numpy.__version__)
except Exception as e:
    print("❌ numpy: 导入失败:", e)
EOF

# === 4. 测试 Node.js 环境 ===
echo -e "\n📘 正在测试 Node.js 环境..."

# 关键修改：使用 EOF 而不是 'EOF'
node << EOF
console.log("=== 测试 Node.js 核心库 ===");

// 将 /ql/data/scripts/node_modules 加入模块搜索路径
const path = require('path');
module.paths.push(path.resolve('/ql/data/scripts/node_modules'));

try {
    const axios = require('axios');
    console.log(\`✅ axios: 加载成功，版本: \${axios.VERSION}\`);
    
    axios.get('https://api.uomg.com/api/rand.qinghua', { timeout: 5000 })
        .then(res => {
            if (res.status === 200) {
                console.log(\`✅ axios: 网络请求测试成功，返回数据:\`, res.data);
            } else {
                console.log(\`❌ axios: 网络请求失败，状态码: \${res.status}\`);
            }
        })
        .catch(err => {
            console.log('❌ axios: 网络请求失败:', err.message);
        });
} catch (e) {
    console.log('❌ axios: 加载失败:', e.message);
}

try {
    const crypto = require('crypto-js');
    const encrypted = crypto.AES.encrypt('Hello, QingLong!', 'secret-key');
    console.log('✅ crypto-js: 加密功能测试成功');
} catch (e) {
    console.log('❌ crypto-js: 加载或使用失败:', e.message);
}

try {
    const cheerio = require('cheerio');
    const $ = cheerio.load('<h2 class="title">Hello world</h2>');
    console.log('✅ cheerio: HTML 解析功能测试成功');
} catch (e) {
    console.log('❌ cheerio: 加载失败:', e.message);
}
EOF

# === 5. 测试青龙面板内部命令 ===
echo -e "\n🛠️  正在测试青龙面板内部命令..."
if command -v ql &> /dev/null; then
    echo "✅ ql: 命令已存在"
    VERSION=$(ql --version 2>&1 | head -n 1)
    if [ -n "$VERSION" ]; then
        echo "📌 青龙版本: $VERSION"
    else
        echo "⚠️  ql --version 未返回有效信息"
    fi
else
    echo "❌ ql: 命令未找到"
fi

# === 6. 测试关键目录存在性 ===
echo -e "\n📁 正在检查关键目录..."
for dir in "/ql/data" "/ql/data/scripts" "/ql/data/scripts/node_modules" "/usr/local/lib/python3.11/site-packages"; do
    if [ -d "$dir" ]; then
        echo "✅ 目录存在: $dir"
        if [ "$dir" = "/ql/data/scripts/node_modules" ]; then
            echo "    包含: $(ls /ql/data/scripts/node_modules | grep -E '^(axios|crypto-js|cheerio)' | head -n 3 | xargs)"
        fi
    else
        echo "❌ 目录不存在: $dir"
    fi
done

echo -e "\n===================================="
echo "🎉 所有环境测试完成！"
echo "💡 请根据上面的 ✅ 和 ❌ 结果，检查你的环境。"
echo "💡 任何 ❌ 都需要重点关注和修复。"
echo "===================================="