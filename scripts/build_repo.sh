#!/bin/bash
# 统一 Sileo 源索引生成脚本
# 用法: ./scripts/build_repo.sh [REPO_ROOT]
# 约定: 所有 .deb 已放入 $REPO_ROOT/debs/ 下
set -e

REPO_DIR="${1:-.}"
cd "$REPO_DIR"

# GitHub Pages 关闭 Jekyll, 否则下划线开头目录/文件会被吞
touch .nojekyll

if [ -z "$(ls -A debs/*.deb 2>/dev/null)" ]; then
    echo "ERROR: debs/ 下没有任何 .deb"
    exit 1
fi

echo "[*] 待收录的包:"
ls -1 debs/*.deb

# 索引: 明文 Packages + bz2 + gz (bz2 是 Sileo 生态主流)
dpkg-scanpackages debs /dev/null > Packages
bzip2 -9kc Packages > Packages.bz2
gzip  -9c  Packages > Packages.gz

cat > Release << 'EOF'
Origin: rickbrian repo
Label: rickbrian
Suite: stable
Version: 1.0
Codename: ios
Architectures: iphoneos-arm iphoneos-arm64
Components: main
Description: rickbrian 自编译 iOS 插件统一源 (GumJS WebSocket / TrollVNC ...)
EOF

# 动态生成首页, 从 Packages 列出全部软件包
{
cat << 'HEAD'
<!DOCTYPE html>
<html lang="zh-CN"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>rickbrian repo</title>
<style>
body{font-family:-apple-system,BlinkMacSystemFont,sans-serif;margin:0;padding:24px;background:#0f1021;color:#e8e8f0;max-width:640px;margin:0 auto}
h1{color:#00d2ff;font-size:24px}
h2{font-size:16px;color:#9aa0b5;margin-top:28px;text-transform:uppercase;letter-spacing:1px}
code{display:block;background:#1c1f3a;padding:12px 14px;border-radius:8px;color:#5dff9d;font-size:14px;word-break:break-all;user-select:all}
.card{background:#181a33;padding:16px 18px;border-radius:12px;margin:14px 0;border:1px solid #262a4d}
.pkg-name{font-size:17px;font-weight:600;color:#fff}
.pkg-ver{display:inline-block;background:#00d2ff22;color:#00d2ff;padding:1px 8px;border-radius:6px;font-size:12px;margin-left:6px}
.pkg-id{color:#6b7099;font-size:12px;margin:4px 0}
.pkg-desc{font-size:13px;color:#c2c6da;line-height:1.5}
a{color:#00d2ff}
</style></head><body>
<h1>rickbrian repo</h1>
<h2>添加到 Sileo / Zebra</h2>
<code>https://rickbrian.github.io/repo/</code>
<h2>软件包</h2>
HEAD

awk -F': ' '
  function flush(){ if(p!=""){ printf "<div class=\"card\"><div class=\"pkg-name\">%s<span class=\"pkg-ver\">%s</span></div><div class=\"pkg-id\">%s</div><div class=\"pkg-desc\">%s</div></div>\n",(n!=""?n:p),v,p,d; } p="";n="";v="";d=""; }
  /^Package: /{flush(); p=$2}
  /^Name: /{n=$2}
  /^Version: /{v=$2}
  /^Description: /{d=$2}
  END{flush()}
' Packages

cat << 'FOOT'
<h2>直接下载</h2>
<div class="card"><a href="debs/">浏览全部 .deb 文件</a></div>
</body></html>
FOOT
} > index.html

echo "[+] 索引生成完毕, 收录 $(ls debs/*.deb | wc -l | tr -d ' ') 个包"
