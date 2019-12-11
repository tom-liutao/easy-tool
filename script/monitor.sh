#! /bin/bash

readonly monitor_menu_array=("Adk Monitor"    "adk_monitor"\
                             "Hexdump Button" "hexdump_button"\
                             "Back"           "break")

function adk_monitor () {
	gnome-terminal -x adb shell "adk-message-monitor -a"
}

function hexdump_button () {
	nodeNum=`adb shell ls -l /dev/input | grep "event" | wc -l`
	nodeNum=$[nodeNum-1]
	echo "TIPS:Event Num:(0~$nodeNum)" 
	read -p "Enter Event Num:" eventNum
	gnome-terminal -x adb shell "hd /dev/input/event$eventNum"
}

function monitor_menu () {
	while :
	do
		clear
                echo "            Monitor"
                echo ""
                for ((i=0; i<$[${#monitor_menu_array[*]}/2]; i++))
                do
                        echo "      $[$i+1]. ${monitor_menu_array[$i*2]}"
                done
                echo ""
                read -p "Enter Number:" menuNum
                if [ $[${menuNum}-1] -lt $[${#monitor_menu_array[*]}/2] ]
                then
                        clear
                        ${monitor_menu_array[$[$[${menuNum}-1]*2+1]]}
                else
                        echo "Enter Error"
                fi
	done	
}

monitor_menu
