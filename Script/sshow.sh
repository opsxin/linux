#!/bin/bash

test -f ~/.ssh/config || ( echo "未存在 config 文件" && exit 1 )

hosts+=($(awk '/^Host/{print $2}' ~/.ssh/config))

PS3="选择要连接的主机 ID: "
select host in "${hosts[@]}"; do
    ssh -o ConnectTimeout=10 "${host}"
    break
done