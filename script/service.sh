#/bin/bash 

PACKAGE_NAME="test-0.0.1-SNAPSHOT"
PROCESSID=$(ps axo pid,cmd | grep "java -jar ${PACKAGE_NAME}.jar" | grep -v grep | awk '{print $1}')

function status() {
    processnum=$(ps axo pid,cmd | grep "java -jar ${PACKAGE_NAME}.jar" | grep -v grep | wc -l)
    if [ ${processnum} -eq 1 ]
    then 
        echo "程序已运行,pid为${PROCESSID}"
    else 
		echo "程序未运行"
    fi
}

function start() {
    processnum=$(ps axo pid,cmd | grep "java -jar ${PACKAGE_NAME}.jar" | grep -v grep | wc -l)
    if [ ${processnum} -eq 1 ]
    then 
		echo "程序已运行,pid为${PROCESSID}"
		exit 1 
    fi
    if [ -f ${PACKAGE_NAME}.log ]
    then
        mv ${PACKAGE_NAME}.log ${PACKAGE_NAME}.log_$(date +%y%m%d-%H%M)
    fi
    nohup java -jar ${PACKAGE_NAME}.jar --spring.profiles.active=test >> ${PACKAGE_NAME}.log 2>&1 &
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

