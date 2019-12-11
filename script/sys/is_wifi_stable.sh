#! /bin/bash

while :
do	
	`adb shell ifconfig > ./tmp`
	num=`adb shell ifconfig | grep -n "wlan0"`
	num=${num%:wlan0*}
	ip=`sed -n "$[$num+1]p" ./tmp | grep -w "Bcast"`
	rm -rf ./tmp
	if [[ -n $ip ]]
	then
		gnome-terminal -x adb shell "adk-message-send 'connectivity_wifi_completeonboarding{}'"
		pid=`ps -ef | grep "is_wifi_stable.sh" | grep -v "grep" | awk '{print $2}'`
		kill -9 $pid
		clear
	fi
	sleep 1s
done
