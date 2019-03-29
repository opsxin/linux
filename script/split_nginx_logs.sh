#!/bin/bash

#0 0 1 * * shell 

DATE_YM=$(date +%Y-%m)
NGINX_LOGS="/usr/local/nginx/logs"
BACKUP_LOGS="/usr/local/nginx/logs/backup"
BACKUP_DIR=${BACKUP_LOGS}/${DATE_YM}

if [ ! -d ${BACKUP_DIR} ]
then
    mkdir -p ${BACKUP_DIR}
fi
cp ${NGINX_LOGS}/*.log ${BACKUP_DIR}

for log in $(ls ${NGINX_LOGS}/*.log)
do
    > ${log}
done

cd ${BACKUP_DIR}
tar zcf logs_${DATE_YM}.tgz *.log --remove-files
echo "已备份Nginx Logs-${DATE_YM}" >> /dev/null
