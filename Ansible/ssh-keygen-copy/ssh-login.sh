#!/bin/bash

# 生成ssh Key
ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa

for line in $(cat passwd.txt)
do
	host_ip=$(awk -F: '{print $1}' <(echo ${line}))
	host_user=$(awk -F: '{print $2}' <(echo ${line}))
	host_passwd=$(awk -F: '{print $3}' <(echo ${line}))

	# StrictHostKeychecking,在第一次连接不用输入yes
	sshpass -p ${host_passwd} ssh-copy-id -o StrictHostKeychecking=no ${host_user}@${host_ip}
done

