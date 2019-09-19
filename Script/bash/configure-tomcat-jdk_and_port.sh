#!/bin/bash

set -eu

java_7_path="/usr/local/java/jdk1.7"
java_8_path="/usr/local/java/jdk1.8"
tomcat_7_name="apache-tomcat-7.0.96.tar.gz"
tomcat_8_name="apache-tomcat-8.5.45.tar.gz"

if [ $# -ne 2 ]; then
    echo "$0 <Jdk_Version> <Port>"
    exit 1
else
    if [[ $1 -ne 7 && $1 -ne 8 ]]; then
        echo "Jdk version only 7 or 8"
        exit 1
    fi
    # 端口只能是 0 至 99
    if [[ $2 -le 0 || $2 -ge 99 ]]; then
        echo "Port only between 0 and 99"
        exit 2
    fi
fi

if [ $1 -eq 7 ]; then
    tar zxf ${tomcat_7_name} && mv ${tomcat_7_name:0:-7} tomcat_7_82$2 
    # 修改启动端口，避免端口冲突
    sed -i -e "s/8005/81$2/" -e "s/8080/82$2/" -e "s/8009/83$2/" \
        tomcat_7_82$2/conf/server.xml 
    # 设置 JAVA_HOME   
    sed -i "2a export JAVA_HOME=${java_7_path}" tomcat_7_82$2/bin/setclasspath.sh
else    
    tar zxf ${tomcat_8_name} && mv ${tomcat_8_name:0:-7} tomcat_8_82$2 
    sed -i -e "s/8005/81$2/" -e "s/8080/82$2/" -e "s/8009/83$2/" \
        tomcat_8_82$2/conf/server.xml    
    sed -i "2a export JAVA_HOME=${java_8_path}" tomcat_8_82$2/bin/setclasspath.sh
fi

