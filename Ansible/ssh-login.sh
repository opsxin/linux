#!/bin/bash

### 第一种方式
# 生成ssh Key
ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa

# 保存原先分割符
OLD_IFS=${IFS}

# 使用":"作为分割符
IFS=":"
cat passwd.txt | while read host_ip host_user host_passwd 
do
	# StrictHostKeychecking，在第一次连接不用输入 yes
	sshpass -p ${host_passwd} ssh-copy-id -o StrictHostKeychecking=no ${host_user}@${host_ip}
done

# 还原分割符
IFS=${OLD_IFS}

### 第二种方式
## 生成ssh Key
#ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
#
#for line in $(cat passwd.txt)
#do
#	host_ip=$(awk -F: '{print $1}' <(echo ${line}))
#	host_user=$(awk -F: '{print $2}' <(echo ${line}))
#	host_passwd=$(awk -F: '{print $3}' <(echo ${line}))
#
#	# StrictHostKeychecking,在第一次连接不用输入yes
#	sshpass -p ${host_passwd} ssh-copy-id -o StrictHostKeychecking=no ${host_user}@${host_ip}
#done

