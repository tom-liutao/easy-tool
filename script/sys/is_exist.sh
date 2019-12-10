#! /bin/bash

function _process () {
	pid=`ps -ef | grep $1 | grep -v grep | awk '{print $2}'`
	kill -9 $pid
}

while : 
do
	is_exist=`adb devices | grep -w "device"`
        if [[ -z ${is_exist} ]]
        then
		_process easyTool.sh ;
		_process is_exist.sh ;
		_process wifi_success.sh ;
	else
		pid=`ps -ef | grep easyTool.sh | grep -v grep | awk '{print $2}'`
		if [[ -z ${pid} ]]
		then
			_process is_exist.sh ;
			_process wifi_success.sh ;
		fi
        fi
	sleep 1s
done
