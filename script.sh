#!/bin/sh
# 该脚本用于启动和停止一个Python3程序
# 使用方法：./script.sh [start|stop] [program_name.py]

if [ $# -ne 2 ]; then
    echo "Usage: $0 [start|stop|status] [program_name.py]"
    exit 1
fi

#dir=$(dirname $2)
#cd $dir
appname=$(basename $2)

if [ "$1" = "start" ]; then
    echo "$2" | awk -F '/' '{print "path:" $1 "\nname:" $2}'
    dir=$(dirname $2)
    cd $dir
    appname=$(basename $2)
    # 检查程序是否已经在运行
    pid=$(ps -ef | grep "python3" | grep $appname | grep -v grep | awk '{print $2}')
    if [ -n "$pid" ]; then
        echo "Program $2 is already running with PID $pid"
        exit 1
    fi
    # 启动程序
    nohup python3 "$appname" >nohup.out 2>&1 &
    echo "Program $2 started"
elif [ "$1" = "restart" ]; then
 echo "$2" | awk -F '/' '{print "path:" $1 "\nname:" $2}'
    dir=$(dirname $2)
    cd $dir
    appname=$(basename $2)
    # 停止程序
    pid=$(ps -ef | grep "python3" | grep $appname | grep -v grep | awk '{print $2}')
    if [ -n "$pid" ]; then
        kill -9 $pid
        echo "Program $2 stopped"
    fi
    # 启动程序
    nohup python3 "$appname" >nohup.out 2>&1 &
    echo "Program $2 restarted"
elif [ "$1" = "stop" ]; then
    # 停止程序
    pid=$(ps -ef | grep "python3" | grep $appname | grep -v grep | awk '{print $2}')
    if [ -z "$pid" ]; then
        echo "Program $2 is not running"
        exit 1
    fi
    kill -9 $pid
    echo "Program $2 stopped"

elif  [ "$1" = "status" ]; then
   #查询状态
   pid=$(ps -ef | grep "python3" | grep $appname | grep -v grep | awk '{print $2}')
   # pid=$(pgrep -f $appname)
   #echo "$pid"
   if [ -z "$pid" ]; then
        echo "Program $2 is not running"
        exit 1
    fi
    echo "Program $2 is running"
   
else
    echo "Usage: $0 [start|stop|status] [program_name.py]"
    exit 1
fi

exit 0
