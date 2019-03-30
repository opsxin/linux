#!/bin/bash

#* * * * * bash $0

DOMAINS=("www.baidu.com" "www.qq.com")
DINGDING="https://oapi.dingtalk.com/robot/send?access_token="
HEAD='{"msgtype":"markdown", "markdown":{"title":"域名证书信息", "text":"'
TAIL='"}}'

for domain in ${DOMAINS[@]}
do
    expired_time=$(timeout 2 openssl s_client -connect ${domain}:443 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
    expired_time_format=$(date -d "${expired_time}" "+%Y/%m/%d %H:%M:%S")

    d1=$(date +%s -d ${expired_time_format%\ *})
    d2=$(date +%s -d $(date +%F))
    days=$(((d1-d2)/86400))

    body="查询域名：${domain} \n - **到期时间**：${expired_time_format} \n - **距今还有**：${days}天 [详情](https://myssl.com/${domain}) \n"
    full_info=${HEAD}${body}${TAIL}
    
    #证书到期时间一个月，15天，小于7天报警
    if [[ ${days} -eq 30 || ${days} -eq 15 || ${days} -le 7 ]] 
    then
	    curl -s "${DINGDING}" -H 'Content-Type: application/json' -d "${full_info}"
    fi
done

