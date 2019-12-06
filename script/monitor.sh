#! /bin/bash

function monitor_menu () {
	echo "******************************"
	echo "*          Monitor           *"
	echo "*      1. Adk Monitor        *"
	echo "*      2. HD Button Event    *"
	echo "*      3. Back               *"
	echo "******************************"
	while :
	do
		read -p "Enter Number:" monitorCase
		case $monitorCase in
		1)gnome-terminal -x adb shell "adk-message-monitor -a"
		;;

		2)
		nodeNum=`adb shell ls -l /dev/input | grep "event" | wc -l`
		nodeNum=$[nodeNum-1]
		echo "TIPS:Event Num:(0~$nodeNum)" 
		read -p "Enter Event Num:" eventNum
		gnome-terminal -x adb shell "hd /dev/input/event$eventNum";;

		3)break;;
		*)exit 0;;
		esac
	done	
}

monitor_menu
