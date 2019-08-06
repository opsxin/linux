#!/bin/bash

# 1 0 * * * bash $0 

base_dir="/home/tomcat"
log_name="split_tomcat_logs.log"
# tomcat 项目日志文件夹
logs_dirs=("/home/tomcat/tomcat-01/logs" "/home/tomcat/tomcat-02/logs")
date_y=$(date +%Y)
date_m=$(date +%m)
date_d=$(date +%d)
date_yesterday=$(date -d 'yesterday' +%Y-%m-%d)
last_month=$(date -d last-month +%Y-%m)

move_logs() {
    cd ${logs_dir}
    for i in $(ls *.${date_yesterday}* 2>/dev/null)
    do
        mv ${i} ${backed_logs_dir}/$1
    done
    cp ${logs_dir}/catalina.out ${backed_logs_dir}/$1/catalina.out_${date_yesterday}
    > ${logs_dir}/catalina.out
    echo "${date_yesterday} 的日志文件移动到备份文件夹 ${backed_logs_dir}/$1" >> \
		${base_dir}/${log_name}
}

tar_logs() {
    mkdir ${backed_logs_dir}/${date_y}-${date_m}
    echo "${date_y}-${date_m}-${date_d} 新建 ${backed_logs_dir}/${date_y}-${date_m} 文件夹" >> \
		${base_dir}/${log_name}
    cd ${backed_logs_dir}
    tar zcf "tomcat_logs_${last_month}.tgz" "${last_month}" --remove-file
    echo "打包 ${backed_logs_dir}/${last_month} 日志成功" >> ${base_dir}/${log_name}
}

for logs_dir in ${logs_dirs[@]}
do
    backed_logs_dir="${logs_dir}/backed_logs"

	# 如果是 1 号，则将上个月的日志打包
    if [ ${date_d} -eq 01 ]; then
        move_logs ${last_month}
        tar_logs
    else 
        move_logs ${date_y}-${date_m}
    fi
done

