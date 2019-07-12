#!/bin/bash

#####
# CentOS 
# yum安装MySQL5.7
###
# 注意SELinux需要关闭
# setenforce 0(临时关闭)
# sed -i "s/SELINUX=enforcing/SELINUX=permissive/" 
#    /etc/selinux/config（永久关闭）
###
# 初始ROOT密码
# grep 'temporary password' /var/log/mysqld.log
# 修改密码
# set password for root@localhost = password('PASSWORD');
#####

set -e -u

Mysql_Path="/data01/mysql"
Mysql_Binlog_Path="/data01/mysql-binlog"
Mysql_Community_Repository="https://mirrors.ustc.edu.cn/mysql-repo/mysql57-community-release-el7-9.noarch.rpm"
Mysql_Config="""[client]
socket=${Mysql_Path}/mysql.sock
default-character-set=utf8
[mysql]
no-auto-rehash
default-character-set=utf8
[mysqld]
character-set-server=utf8
# 慢日志
# slow_query_log = 1
# slow_query_log_file = ${Mysql_Path}/mysql-slow.log
# long_query_time = 1
server-id=1
# 开启bin_log
log_bin=${Mysql_Binlog_Path}/mysql-bin
datadir=${Mysql_Path}
socket=${Mysql_Path}/mysql.sock
symbolic-links=0
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid"""

# 添加EPEL和Remi源
add_mysql_source() {
    # 更新Cache
    yum makecache
    # 删除已有mariadb
    yum remove -y mariadb-server mariadb mariadb-devel
    # 添加中科大MySQL源
    rpm -ivh ${Mysql_Community_Repository}
}

# 修改MySQL源为国内地址，加速下载
mod_mysql_source() {
    # 修改下载源为USTC源
    sed -i 's#http://repo.mysql.com#https://mirrors.ustc.edu.cn/mysql-repo#g' \
        /etc/yum.repos.d/mysql-community.repo
    # 更新Cache
    yum makecache
}

install_mysql57() {
    # 安装mysql
    # 因为ustc同步迟缓，latest还是5.7.25
    yum install -y mysql-community-libs-5.7.25 \
        mysql-community-common-5.7.25 mysql-community-libs-compat-5.7.25 \
        mysql-community-server-5.7.25 mysql-community-client-5.7.25
}

# 修改MySQL的一些启动文件
mod_mysql_conf() {
    echo -e "${Mysql_Config}" > /etc/my.cnf
}

# 数据存放的文件夹
set_mysql_path() {
    # 数据data和bin_log存放路径
    if [ -d "${Mysql_Path}" -a -d "${Mysql_Binlog_Path}" ]; then
        echo "数据目录已存在"
        echo "请手动修改/etc/my.cnf中的数据路径"
        exit 1
    else
        mkdir -p /data01/mysql /data01/mysql-binlog
        chown -R mysql:mysql /data01/mysql /data01/mysql-binlog
    fi

    # PID存放路径
    if [ ! -d "/var/run/mysqld" ]; then
        mkdir /var/run/mysqld
        chown -R mysql:mysql /var/run/mysqld
    else
        chown -R mysql:mysql /var/run/mysqld
    fi
}

add_mysql_source
mod_mysql_source
install_mysql57
mod_mysql_conf
set_mysql_path
