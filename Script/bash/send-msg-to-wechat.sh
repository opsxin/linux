#!/bin/bash

# Server 酱
URL="https://sc.ftqq.com/YOU_KEY.send"

# 标题（必填）
[ -n "$1" ] && TEXT=$1 || { echo "usage: $0 TEXT [DESP]"; exit 1; }
# 内容（选填）
[ -n "$2" ] && DESP=$2 || DESP="![Worship](https://i.loli.net/2019/04/18/5cb7ddd2324a6.gif)"

curl ${URL} -d "text=${TEXT}&desp=${DESP}"

