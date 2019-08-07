#!/bin/bash

# 返回不为 0，或变量未定义，后续脚本就不执行
set -eu

jars_path=("/home/tomcat/tomcat-01" "/home/tomcat/tomcat-02")
date_day=$(date +%d)
date_year_month=$(date +%Y-%m)
last_month=$(date -d 'last-month' +%Y-%m)
date_yesterday=$(date -d 'yesterday' +%Y-%m-%d)

# 将日志移动到备份文件夹
move_log() {
    jar_path=$1
    backed_log_path=$2
    time=$3
    cd ${jar_path}
    # 确保月份的备份文件夹存在
    if [ ! -d ${backed_log_path}/${time} ]; then
        mkdir ${backed_log_path}/${time}
    fi

    # 将最新日志分割
    for log in $(ls *.log)
    do 
        cp ${log} "${backed_log_path}/${time}/${log}_${date_yesterday}"
        # 清空日志
        > ${log}
    done
}

tar_log() {
    backed_log_path=$1
    cd ${backed_log_path}
    # 打包日志，删除源文件
    tar zcf ${last_month}.tgz ${last_month} --remove-files
    mkdir ${date_year_month}
}

for jar_path in ${jars_path[@]}
do
    # 确保备份文件夹存在
    backed_log_path="${jar_path}/backed_logs"
    if [ ! -d ${backed_log_path} ]; then
        mkdir -p ${backed_log_path}
    fi
    
    if [ ${date_day} -eq 01 ]; then 
        # 备份日志
        move_log ${jar_path} ${backed_log_path} ${last_month}
        # 将上月日志打包
        tar_log ${backed_log_path}
    else
        move_log ${jar_path} ${backed_log_path} ${date_year_month}
    fi
done

