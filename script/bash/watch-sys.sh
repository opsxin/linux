#!/bin/bash

DATE_NOW=$(date +%Y%m%d-%H%M%S)
LOG_DIR="/home/user/watch_sys.log"
USER_NAME="tomcat"

function echo_mem() {
    free -h | awk '/Mem/ {print "mem total:" $2 " free:" $4}' >> ${LOG_DIR} 2>&1
}

function echo_disk() {
    df -h | awk '/\/$/ {print "disk total:" $2 " free:" $4}' >> ${LOG_DIR} 2>&1
}

function echo_cpu() {
    vmstat 1 5 | awk 'NR>=3 {id += $15} END {print "cpu id:" id/5}' >> ${LOG_DIR} 2>&1
}

function echo_app() {
    ps -e -o 'pid,args,user,pmem' | grep "${USER_NAME}" | grep 'java' | grep -v 'grep' | awk '{print "app use mem:" 0.15*$4 "G"}' >> ${LOG_DIR} 2>&1
}

echo "BEGIN_${DATE_NOW}" >> ${LOG_DIR} 2>&1
echo_cpu
echo_mem
echo_disk
echo_app
echo "-----------------" >> ${LOG_DIR} 2>&1
