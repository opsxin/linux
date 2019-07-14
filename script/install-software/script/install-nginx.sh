#!/bin/bash

###
# CentOS 
# 编译安装Nginx
###

set -e -u

Ngixn_Version="1.16.0"
Nginx_Path="/usr/local/nginx"
Nginx_Download_Url="https://nginx.org/download/nginx-${Ngixn_Version}.tar.gz"
OpenSSL_Download_Url="https://github.com/openssl/openssl/archive/OpenSSL_1_1_1c.tar.gz"
Pcre_Download_Url="https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz"
Zlib_Download_Url="https://zlib.net/zlib-1.2.11.tar.gz"
Nginx_Configure_Parameter="""--prefix=${Nginx_Path:-} --user=nobody --group=nobody \
    --with-http_stub_status_module --with-http_ssl_module \
    --with-http_gzip_static_module --with-stream \
    --with-http_sub_module --with-http_v2_module \
    --with-zlib=../zlib-1.2.11 --with-pcre=../pcre-8.43 \
    --with-openssl=../openssl-OpenSSL_1_1_1c"""
Nginx_Configuration="""user  nobody nobody;
worker_processes  auto;

error_log  logs/error.log;

events {
    use epoll;
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    log_format  main  '\$remote_addr' - '\$remote_user' ['\$time_local'] '\$request'
                      '\$status' '\$body_bytes_sent' '\$http_referer'
                      '\$http_user_agent' '\$http_x_forwarded_for';
 
    charset      utf-8;
    sendfile        on;
    tcp_nopush      on;
    tcp_nodelay     on;
    server_tokens  off;

    keepalive_timeout  300;
    client_max_body_size 8m;

    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;
    fastcgi_read_timeout 300;
    fastcgi_buffer_size 64k;
    fastcgi_buffers 4 64k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_temp_file_write_size 128k;

    gzip  on;
    gzip_min_length 1k;
    gzip_buffers 4 16k;
    gzip_comp_level 2;
    gzip_types text/plain application/x-javascript text/css application/xml text/javascript application/x-httpd-php image/jpeg image/gif image/png;
    gzip_vary on;
    gzip_disable 'MSIE [1-6]\.';

    include ${Nginx_Path}/conf/conf.d/*.conf;
}
"""

download_files() {
    # 更新Cache
    yum makecache
    # 安装依赖
    yum install -y wget make gcc gcc-c++
    # 临时文件夹
    mkdir install-nginx-tmp && cd install-nginx-tmp
    # 下载文件
    wget -O nginx.tgz ${Nginx_Download_Url} 
    wget -O openssl.tgz ${OpenSSL_Download_Url} 
    wget -O pcre.tgz ${Pcre_Download_Url} 
    wget -O zlib.tgz ${Zlib_Download_Url}
}

compile_nginx() {
    if [ -d "${Nginx_Path}" ]; then
        echo "安装目录已存在，请修改编译参数后重试"
        exit 1
    else
        echo "开始解压文件"
        tar zxf nginx.tgz && tar zxf openssl.tgz && \
            tar zxf pcre.tgz && tar zxf zlib.tgz
        cd nginx-${Ngixn_Version} 
        sh configure ${Nginx_Configure_Parameter} && make && make install 
        # 删除临时文件夹
        cd .. && rm -rf install-nginx-tmp
    fi
}

mod_nginx_config() {
    echo -e "${Nginx_Configuration}" > ${Nginx_Path}/conf/nginx.conf
    mkdir ${Nginx_Path}/conf/conf.d
}

download_files
compile_nginx
mod_nginx_config
