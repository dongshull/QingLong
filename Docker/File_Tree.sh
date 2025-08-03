#!/bin/bash

echo "===================================="
echo "🔍 青龙面板内部文件结构探测脚本 (容器内版)"
echo "⏰ 探测时间：$(date '+%Y-%m-%d %H:%M:%S')"
echo "💡 当前环境: 青龙面板容器内部"
echo "===================================="

# === 1. 探测 /ql/data 目录（核心数据区）===
echo "📁 正在探测核心数据目录: /ql/data"
echo "----------------------------------------"
find /ql/data -type d -maxdepth 2 2>/dev/null | sort

# 用 ls -l 列出 scripts 和 config 目录的详细信息
echo -e "\n📋 /ql/data/scripts 目录内容:"
ls -l /ql/data/scripts/ 2>/dev/null || echo "   目录为空或不存在"

echo -e "\n📋 /ql/data/config 目录内容:"
ls -l /ql/data/config/ 2>/dev/null || echo "   目录为空或不存在"

# === 2. 探测 Python 环境 ===
echo -e "\n🐍 正在探测 Python 环境..."
echo "----------------------------------------"
echo "📦 Python 版本:"
python3 --version

echo -e "\n📦 已安装的 Python 包 (前10个):"
pip3 list | head -n 10

echo -e "\n📁 Python 库安装路径 (/usr/local/lib/python3.11/site-packages/) 中的包:"
ls /usr/local/lib/python3.11/site-packages/ | grep -E "^(requests|pycryptodome|numpy|jieba)" | xargs

# === 3. 探测 Node.js 环境 ===
echo -e "\n📘 正在探测 Node.js 环境..."
echo "----------------------------------------"
echo "📦 Node.js 版本:"
node --version

echo -e "\n📦 npm 版本:"
npm --version

echo -e "\n📦 pnpm 版本:"
pnpm --version

echo -e "\n📁 Node.js 依赖目录 (/ql/data/scripts/node_modules/) 中的包:"
ls /ql/data/scripts/node_modules/ | grep -E "^(axios|crypto-js|cheerio)" | xargs

# === 4. 探测系统命令和路径 ===
echo -e "\n🐧 正在探测系统命令..."
echo "----------------------------------------"
for cmd in curl wget git python3 node npm pnpm; do
    path=$(which "$cmd" 2>/dev/null)
    if [ -n "$path" ]; then
        echo "✅ $cmd: $path"
    else
        echo "❌ $cmd: 未找到"
    fi
done

# === 5. 探测关键文件 ===
echo -e "\n📄 正在探测关键文件..."
echo "----------------------------------------"
declare -a files=(
    "/ql/data/config/auth.json" 
    "/ql/data/config/env.sh" 
    "/ql/data/config/config.sh"
    "/ql/data/scripts/node_modules/axios/package.json"
    "/ql/data/scripts/node_modules/crypto-js/package.json"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        size=$(stat -c%s "$file" 2>/dev/null)
        echo "✅ 文件存在: $file (大小: ${size:-?} 字节)"
    else
        echo "❌ 文件不存在: $file"
    fi
done

echo -e "\n===================================="
echo "🎉 探测完成！"
echo "💡 以上是当前容器内部的主要文件结构。"
echo "💡 重要提示：所有数据都存储在宿主机。"
echo "===================================="