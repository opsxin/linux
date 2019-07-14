1. 此脚本仅适用于CentOS 7。

2. 使用方法

   - 安装Docker

     ```bash
     ./start.sh -d
     ```

   - 安装Nginx

     ```bash
     ./start.sh -n
     ```

   - 安装Mysql

     ```bash
     ./start.sh -m
     ```

   - 安装PHP

     ```bash
     ./start.sh -p
     ```

   - 安装Java

     ```bash
     ./start.sh -j <u|d>
     # u使用本地安装包
     # d会要求输入URL，用于下载
     ```

   - 安装多个程序

     ```bash
     # 安装Docker、Nginx、Mysql、Java
     ./start.sh -d -n -m -j u
     # 安装Docker，Nginx
     ./start.sh -dn
     ```

     

   