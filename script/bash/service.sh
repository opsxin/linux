#/bin/bash 

# 命令执行返回不为0就退出
set -e

user=$(whoami)
PACKAGE_NAME="test-0.0.1-SNAPSHOT"
# 启动参数,可以为空
start_parameter=""
#start_parameter=" -Xms500m -Xmx1024m"
PROCESSID=$(ps axo pid,cmd | grep "${PACKAGE_NAME}.jar" | grep -v grep | awk '{print $1}')

function status() {
    processnum=$(ps axo pid,cmd | grep "${PACKAGE_NAME}.jar" | grep -v grep | wc -l)
    if [ ${processnum} -eq 1 ]; then 
        echo "程序已运行,pid为${PROCESSID}"
    else 
        echo "程序未运行"
    fi
}

function start() {
    processnum=$(ps axo pid,cmd | grep "${PACKAGE_NAME}.jar" | grep -v grep | wc -l)
    if [ ${processnum} -eq 1 ]; then 
        echo "程序已运行,pid为${PROCESSID}"
        exit 1 
    fi

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

    if [ "${user}" == "tomcat" ]; then
        nohup java ${start_parameter} -jar ${package_name}.jar --spring.profiles.active=test >> ${package_name}.log 2>&1 &
    elif [ "${user}" == "root" ]; then 
        su -c "nohup java ${start_parameter} -jar ${package_name}.jar --spring.profiles.active=test >> ${package_name}.log 2>&1 &" tomca
    else
        echo "请使用tomcat用户运行程序"
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
        echo 'service.sh (status|start|stop|restart)'
        ;;
esac

