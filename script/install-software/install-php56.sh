#!/bin/bash

###
# CentOS 
# yum安装PHP5.6
###

set -e -u

Remi_Repository="https://mirrors.tuna.tsinghua.edu.cn/remi/enterprise/remi-release-7.rpm"
Remi_PHP56_BaseUrl='https://mirrors.tuna.tsinghua.edu.cn/remi/enterprise/7/php56/$basearch/'

# 添加EPEL和Remi源
add_php_source() {
    # 更新Cache
    yum makecache
    # 删除已有PHP
    yum remove -y php.x86_64 php-cli.x86_64 \
        php-common.x86_64 php-gd.x86_64 php-ldap.x86_64 \
        php-mbstring.x86_64 php-mcrypt.x86_64 php-mysql.x86_64 \
        php-pdo.x86_64
    # 安装EPEL源
    yum install -y epel-release
    # 添加Remi源
    rpm -ivh ${Remi_Repository}
}

# 修改Remi源为国内地址，加速下载
mod_php_source() {
    # 修改remi_php56的下载源为清华源
    sed -i -e "/php56\/\$basearch/a baseurl=${Remi_PHP56_BaseUrl}" \
        -e '/php56\/mirror/s/mirrorlist/#mirrorlist/' \
        /etc/yum.repos.d/remi.repo
    # 更新Cache
    yum makecache
}

install_php56() {
    # 安装php，php-fpm，其他模块同样方法安装
    # 修改remi.repo的enabled=1，则不需加--enablerepo
    yum install -y --enablerepo=remi --enablerepo=remi-php56 \
        php php-fpm 
}

add_php_source
mod_php_source
install_php56
