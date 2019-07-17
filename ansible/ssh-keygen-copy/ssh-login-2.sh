#!/bin/bash

# 生成ssh Key
ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa

# 使用":"作为分割符
IFS=":"
cat passwd.txt | while read host_ip host_user host_passwd 
do
	# StrictHostKeychecking,在第一次连接不用输入yes
	sshpass -p ${host_passwd} ssh-copy-id -o StrictHostKeychecking=no ${host_user}@${host_ip}
done

