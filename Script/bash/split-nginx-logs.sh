#!/bin/bash

# 0 0 1 * * bash $0

DATE_YM=$(date +%Y-%m)
NGINX_PATH="/usr/local/nginx"
NGINX_LOGS="${NGINX_PATH}/logs"
BACKUP_DIR="/backup/${DATE_YM}"

# 确保备份文件夹存在
if [ ! -d ${BACKUP_DIR} ]; then
    mkdir -p ${BACKUP_DIR}
fi

# 移动日志文件到备份文件夹
# 向 Nginx 发送信号，重新打开日志文件
mv ${NGINX_LOGS}/*.log ${BACKUP_DIR}
if [ $? -eq 0]; then
    ${NGINX_PATH}/sbin/nginx -s reopen
fi

# 将日志打包，并删除原文件
cd ${BACKUP_DIR}
tar zcf nginx-logs-${DATE_YM}.tgz *.log --remove-files
echo "已备份 Nginx Logs-${DATE_YM}" >> /dev/null

