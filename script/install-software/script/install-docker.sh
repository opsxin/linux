#!/bin/bash

###
#CentOS 7
#Docker and Docker-compose
###

Docker_Registry_mirrors="""{
	\"registry-mirrors\": [
        \"http://f1361db2.m.daocloud.io\",
        \"https://hub-mirror.c.163.com\"]
}"""

install_docker() {
    # 移除旧Docker
    yum remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
    # 安装必要的包
    yum install -y yum-utils lvm2 \
        device-mapper-persistent-data 
    # 添加阿里源
    yum-config-manager \
        --add-repo \
        http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    # 更新Cache
    yum makecache
    # 安装docker
    yum install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io
}

add_docker_hub_source() {
    if [ ! -d /etc/docker ]; then 
        mkdir /etc/docker
        echo -e "${Docker_Registry_mirrors}" > \
            /etc/docker/daemon.json
    else 
        if [ -f /etc/docker/daemon.json ]; then 
            mv /etc/docker/daemon.json /etc/docker/daemon.json.bak
        fi
        echo -e "${Docker_Registry_mirrors}" > \
            /etc/docker/daemon.json
    fi
}

install_docker-compose() {
    curl -o /usr/local/bin/docker-compose -L \
        "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)"
    chmod +x /usr/local/bin/docker-compose
}

install_docker
add_docker_hub_source
install_docker-compose
