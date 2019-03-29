#!/bin/bash

DOMAINS=("google.cn" "baidu.com" "cheng.xin")
DINDING="https://oapi.dingtalk.com/robot/send?access_token=48069c1f554a0ce416e85c3bbb381260b8c41352e1fb1af111b5a8d134cf0d00"
HEAD='{"msgtype":"markdown", "markdown":{"title":"域名信息", "text":"'
TAIL='"}}'

for DOMAIN in ${DOMAINS[@]}
do
    WHOIS_SOURCE=$(whois ${DOMAIN} -H)

    if [ ${DOMAIN##*.} == "cn" ]; then
        DOMAIN_NAME=$(echo "${WHOIS_SOURCE}" | grep 'Domain Name' | cut -d: -f2)
        CREATION_DATE=$(echo "${WHOIS_SOURCE}" | awk '/Registration Time/ {print $3}')
        EXPIRY_DATE=$(echo "${WHOIS_SOURCE}" | awk '/Expiration Time/ {print $3}')
        REGISTRANT_ORGANIZATION=$(echo "${WHOIS_SOURCE}" | grep 'Registrant:' | cut -d: -f2)
        REGISTRANT_CONTACT_EMAIL=$(echo "${WHOIS_SOURCE}" | grep 'Registrant Contact Email' | cut -d: -f2)
        SPONSORING_REGISTRAR=$(echo "${WHOIS_SOURCE}" | grep 'Sponsoring Registrar' | cut -d: -f2)

        d1=$(date +%s -d ${EXPIRY_DATE})
        d2=$(date +%s -d $(date +%F))

        body="查询域名:${DOMAIN_NAME} \n - **注册时间**:${CREATION_DATE} \n - **到期时间**:${EXPIRY_DATE} \n - **注册组织**:${REGISTRANT_ORGANIZATION} \n - **注册邮箱**:${REGISTRANT_CONTACT_EMAIL} \n - **注册商**:${SPONSORING_REGISTRAR} \n - **到期还有**:$(((d1-d2)/86400))天 \n - **查询时间**: $(date +%Y-%m-%d\ %H:%M:%S) [详情](http://whois.chinaz.com/${DOMAIN})"
    else
        DOMAIN_NAME=$(echo "${WHOIS_SOURCE}" | grep 'Domain Name' | cut -d: -f2)
        CREATION_DATE=$(echo "${WHOIS_SOURCE}" | grep 'Creation Date' | cut -d: -f2 | cut -dT -f1)
        EXPIRY_DATE=$(echo "${WHOIS_SOURCE}" | grep 'Expiry Date' | cut -d: -f2 | cut -dT -f1)
        REGISTRANT_ORGANIZATION=$(echo "${WHOIS_SOURCE}" | grep 'Registrant Organization' | cut -d: -f2)
        REGISTRANT_STATE_PROVINCE=$(echo "${WHOIS_SOURCE}" | grep 'Registrant State' | cut -d: -f2)
        REGISTRANT_COUNTRY=$(echo "${WHOIS_SOURCE}" | grep 'Registrant Country' | cut -d: -f2)

        d1=$(date +%s -d ${EXPIRY_DATE})
        d2=$(date +%s -d $(date +%F))

        body="查询域名:${DOMAIN_NAME} \n - **注册时间**:${CREATION_DATE} \n - **过期时间**:${EXPIRY_DATE} \n - **注册组织**:${REGISTRANT_ORGANIZATION} \n - **注册省份**:${REGISTRANT_STATE_PROVINCE} \n - **注册国家**:${REGISTRANT_COUNTRY} \n - **到期还有**:$(((d1-d2)/86400))天 \n - **查询时间**: $(date +%Y-%m-%d\ %H:%M:%S) [详情](http://whois.chinaz.com/${DOMAIN})"
    fi

    full_info=${HEAD}${body}${TAIL}
    curl  -s "${DINDING}" -H 'Content-Type: application/json' -d "${full_info}"
done

