#! /bin/bash

development_menu_array=("Monitor" "./script/monitor.sh"\
		"GPIO Configuration" "./script/gpio.sh"\
		"" "./script/mute.sh"\
		"Back" "break")

while :
do
	muteValue=`adb shell "cat sys/class/gpio/gpio42/value"`
	if [[ $muteValue == 1* ]]
	then
		development_menu_array[4]="Mute"
	else
		development_menu_array[4]="UnMute"
	fi
	echo "            Development"
	echo " "                
	for ((i=0; i<$[${#development_menu_array[*]}/2]; i++))
	do
		echo "      $[$i+1]. ${development_menu_array[$[${i}*2]]}"
	done
	echo " "                
	read -p "Enter Number:" menuNum
	if [ $[${menuNum}-1] -lt $[${#development_menu_array[*]}/2] ]
	then
		clear
		${development_menu_array[$[$[$menuNum-1]*2+1]]}
		clear
	else
		echo "Enter Error"
	fi
done
