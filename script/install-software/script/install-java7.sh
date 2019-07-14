#!/bin/bash

#####
# CentOS 
# 安装Java7
###

set -e -u

Choice=${1:-}
Java_Download_Url=${2:-}
Java_Add_Parameter="""export JAVA_HOME=/usr/local/jdk1.7.0_80
export CLASSPATH=.:\$JAVA_HOME/jre/lib/rt.jar:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar 
export PATH=\$PATH:\$JAVA_HOME/bin"""

mod_profile() {
    # 追加JAVA_HOME到环境变量
    echo -e "${Java_Add_Parameter}" >> /etc/profile
    source /etc/profile
}

# 从网上下载
download_java() {
    # 如果未填URL，退出
    if [ ${Java_Download_Url:-no} == "no" ]; then
        echo "请输入URL"
        exit 1
    else
        wget -O jdk-7u80-linux-x64.tar.gz ${Java_Download_Url}
    fi

    if [ $? -eq 0 ]; then 
        tar zxf jdk-7u80-linux-x64.tar.gz -C /usr/local
        mod_profile
    else 
        echo "下载失败，请重试"
        exit 1
    fi
}

# 本地线上传，路径和此脚本相同
unzip_java() {
    if [ -f "jdk-7u80-linux-x64.tar.gz" ]; then
        tar zxf jdk-7u80-linux-x64.tar.gz -C /usr/local
        mod_profile
    else 
        echo "未找到Java安装包"
        echo "或安装包名不为“jdk-7u80-linux-x64.tar.gz”"
        echo "请将安装包放到此脚本同目录或重命名"
        exit 1
    fi
}

case ${Choice} in
    d)
        download_java
        ;;
    u)
        unzip_java
        ;;
    *)
        echo "1: ./$0 d URL"
        echo "2: ./$0 u"
        echo "d: 从URL下载，u：本地文件"
        exit 1
        ;;
esac
