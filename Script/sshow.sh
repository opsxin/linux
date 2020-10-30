#!/bin/bash

parameter="$@"

test -f ~/.ssh/config || ( echo "未存在 SSH config 文件" && exit 1 )

hosts+=($(awk '/^[Hh]ost/{print $2}' ~/.ssh/config))

PS3="选择要连接的主机 ID: "
select host in "${hosts[@]}"; do
    if [ -z "${host}" ]; then break; fi
    ssh -o ConnectTimeout=10 ${parameter} "${host}"
    break
done
