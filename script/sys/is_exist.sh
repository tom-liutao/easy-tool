#! /bin/bash

function processKill () {
	pid=`ps -ef | grep -w $1 | grep -v "grep" | awk '{print $2}'`
	kill -9 $pid
}

while : 
do
	is_exist=`adb devices | grep -w "device"`
        if [[ -z ${is_exist} ]]
        then
		processKill easyTool.sh ;
		pid=`ps -ef | grep -w "is_wifi_stable.sh" | grep -v "grep" | awk '{print $2}'`
		if [[ -n ${pid} ]]
		then
			processKill is_wifi_stable.sh ;
		fi
		processKill is_exist.sh ;
	else
		pid=`ps -ef | grep -w "easyTool.sh" | grep -v "grep" | awk '{print $2}'`
		if [[ -z ${pid} ]]
		then
			pid=`ps -ef | grep -w "is_wifi_stable.sh" | grep -v "grep" | awk '{print $2}'`
			if [[ -n ${pid} ]]
			then
				processKill is_wifi_stable.sh ;
			fi
			processKill is_exist.sh ;
		fi
        fi
	sleep 1s
done
