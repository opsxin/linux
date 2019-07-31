#!/bin/bash

set -e -u

while getopts ":dj::mnp" arg
do
    case $arg in 
        d)
            echo "开始安装Docker"
            bash $(pwd)/script/install-docker.sh
            ;;
        j)
            if [ $OPTARG == "u" ]; then 
                echo "开始安装Java"
                bash $(pwd)/script/install-java7.sh u
            elif [ $OPTARG == "d" ]; then 
                read -p "请输入URL: " url
                echo "开始安装Java"
                bash $(pwd)/script/install-java7.sh d ${url}
            else
                echo "$0 -j <d|u>"
            fi
            ;;
        m)
            echo "开始安装Mysql"
            bash $(pwd)/script/install-mysql57.sh
            ;;
        n)
            echo "开始安装Nginx"
            bash $(pwd)/script/install-nginx.sh
            ;;
        p)
            echo "开始安装PHP"
            bash $(pwd)/script/install-php56.sh
            ;;
        ?)
            echo "$0 -d -m -n -p -j <u|d>"
            ;;
    esac
done

