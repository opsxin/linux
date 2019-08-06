#/bin/bash 

# 命令执行返回不为 0 就退出
set -e

# 脚本执行用户
exec_user=$(whoami)
# 程序运行用户
startup_user="tomcat"
# JAR 包名
PACKAGE_NAME="test-0.0.1-SNAPSHOT"

# 启动参数
start_parameter=""
#start_parameter="-Xms500m -Xmx1024m"

# Spring 启动参数
spring_parameter=""
# 开发
#spring_parameter="--spring.profiles.active=dev"
# 测试
#spring_parameter="--spring.profiles.active=test"
# 生产
#spring_parameter="--spring.profiles.active=prod"

PROCESSID=$(ps axo pid,cmd | grep "${PACKAGE_NAME}.jar" | grep -v grep | awk '{print $1}')

function status() {
    processnum=$(ps axo pid,cmd | grep "${PACKAGE_NAME}.jar" | grep -v grep | wc -l)
    if [ ${processnum} -eq 1 ]; then 
        echo "程序已运行,pid 为 ${PROCESSID}"
    else 
        echo "程序未运行"
    fi
}

function start() {
    processnum=$(ps axo pid,cmd | grep "${PACKAGE_NAME}.jar" | grep -v grep | wc -l)
    if [ ${processnum} -eq 1 ]; then 
        echo "程序已运行,pid 为 ${PROCESSID}"
        exit 1 
    fi
    
    # 将原先日志文件移动到文件夹内 
    if [ -d logs ]; then
        if [ -f ${package_name}.log ]; then
            mv ${package_name}.log logs/${package_name}.log_$(date +%y%m%d-%H%M)
        fi
    else
        mkdir logs
        if [ -f ${package_name}.log ]; then
            mv ${package_name}.log logs/${package_name}.log_$(date +%y%m%d-%H%M)
        fi
    fi

    if [ "${exec_user}" == "${startup_user}" ]; then
        nohup java ${start_parameter} -jar ${package_name}.jar ${spring_parameter} >> ${package_name}.log 2>&1 &
    elif [ "${exec_user}" == "root" ]; then 
        su -c "nohup java ${start_parameter} -jar ${package_name}.jar ${spring_parameter} >> ${package_name}.log 2>&1 &" ${startup_user}
    else
        echo "请使用 ${startup_user} 用户运行程序"
        exit 1
    fi
}

function stop() {
    kill ${PROCESSID}
}

function restart() {
    stop
    sleep 1
    start
}

case $1 in
    status)
        status
        ;;
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    *)
        echo "$0 <status|start|stop|restart>"
        ;;
esac

