#!/bin/bash 

NOW=$(date +%y%m%d-%H%M) 
# 项目路径
TOMCAT_PATH="/home/tomcat/tomcat"
# jenkins 打包好的包路径
SOURCE_PATH="/home/jenkins/target"
# 原 JAR/WAR 备份路径
BACKUP_PATH="/home/tomcat/backup" 

######
# 包类型
# jar 用 java 启动
# war 用 tomcat 启动
######
PACKAGE_NAME="test"
PACKAGE_TYPE="jar"
PACKAGE_FULL="${PACKAGE_NAME}.${PACKAGE_TYPE}"
 
# Jenkins 是否生成安装包
file_is_exists(){
    echo "time is ${NOW}"
    if [ -e "${SOURCE_PATH}/${PACKAGE_FULL}" ]; then
        echo "${PACKAGE_FULL} exists"  
    else   
        echo "${PACKAGE_FULL} not exists"  
        exit 1  
    fi  
}

# 创建备份路径 
create_backup_dir(){
    if [ ! -d "${BACKUP_PATH}" ]; then
        mkdir -p "${BACKUP_PATH}"  
    fi  
    echo "backup path: ${BACKUP_PATH}"  
}

# 停止 Tomcat
stop_tomcat(){
    echo 'try to stop tomcat...'  
    bash -c "${TOMCAT_PATH}/bin/shutdown.sh"
    sleep 1
    echo 'stop tomcat finished...'  
}

# 停止 jar
stop_jar(){
    echo 'try to stop jar...'
    bash -c "${TOMCAT_PATH}/service.sh stop"
    echo 'stop jar finished...'  
}

# 备份原文件
backup_old_tomcat(){
    echo 'backup old tomcat...'  
    if [ -f "${TOMCAT_PATH}/webapps/${PACKAGE_FULL}" ]; then
    	mv "${TOMCAT_PATH}/webapps/${PACKAGE_FULL}" "${BACKUP_PATH}/${PACKAGE_FULL}_${NOW}"
    fi  
    echo "backup tomcat finished..." 
}

backup_old_jar(){
    echo 'backup old jar...'  
    if [ -f "${TOMCAT_PATH}/${PACKAGE_FULL}" ]; then
        mv "${TOMCAT_PATH}/${PACKAGE_FULL}" "${BACKUP_PATH}/${PACKAGE_FULL}_${NOW}"
    fi
    echo "backup jar finished..." 
}

copy_tomcat_to_web(){
    echo "copy ${PACKAGE_FULL} archive to tomcat.."
    mv ${SOURCE_PATH}/${PACKAGE_FULL} "${TOMCAT_PATH}/webapps/ROOT.war"
	rm -rf "${TOMCAT_PATH:?}/webapps/ROOT"
    echo "${SOURCE_PATH}/${PACKAGE_FULL} to ${TOMCAT_PATH}/webapps/"  
}

copy_jar_to_web(){
    echo "copy ${PACKAGE_FULL} archive to jar.."
    mv ${SOURCE_PATH}/${PACKAGE_FULL} "${TOMCAT_PATH}/${PACKAGE_FULL}"
    echo "${SOURCE_PATH}/${PACKAGE_FULL} to ${TOMCAT_PATH}/${PACKAGE_FULL}"
}

start_tomcat(){
    echo 'startup tomcat...'  
    bash -c "${TOMCAT_PATH}/bin/startup.sh"  
}

start_jar(){
    echo 'startup jar...'
    bash -c "${TOMCAT_PATH}/service.sh start"
	sleep 3
    bash -c "${TOMCAT_PATH}/service.sh status"
}

file_is_exists
create_backup_dir
if [ ${PACKAGE_TYPE:-jar} == "war" ]; then 
    stop_tomcat
    backup_old_tomcat
    copy_tomcat_to_web
    start_tomcat
else
    stop_jar
    sleep 1
    backup_old_jar
    copy_jar_to_web
    start_jar
fi

