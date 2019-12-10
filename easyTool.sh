#! /bin/bash
THIS_VERSION="1.0"

devices=`adb devices`
result=$(echo $devices | grep -w "device")
deviceNum=${result% *}
deviceNum=${deviceNum#*attached }

menu_array=("Set LED Pattern"     "./script/led.sh"\
		"Monitor"	  "./script/monitor.sh"\
		"View DB File"    "./script/viewDb.sh"\
		"Configure Gpio"  "./script/gpio.sh"\
		"WiFi Connection" "./script/wifi.sh"\
		"Alexa Onboard"   "./script/alexa.sh"\
		" " 		  "./script/mute.sh"\
		"BT Modify" 	  "./script/bt.sh"\
		"Reboot" 	  "adb reboot"\
		"Quit" 		  "exit 0")

if [[ -n ${result} ]]
then
	./script/sys/is_exist.sh &
	./script/sys/wifi_success.sh &
	clear
  	while :
	do
		muteValue=`adb shell "cat sys/class/gpio/gpio42/value"`
		if [[ $muteValue == 1* ]]
		then
			menu_array[12]="Mute"
		else
			menu_array[12]="UnMute"
		fi
		echo " "		
		echo "         Version: $THIS_VERSION"
		echo "    Device : $deviceNum exist"
		echo " "		
		for ((i=0; i<$[${#menu_array[*]}/2]; i++))
		do
			echo "      $[$i+1]. ${menu_array[$[${i}*2]]}"
		done
		echo " "		
		read -p "Enter Number:" menuNum
		if [ $[${menuNum}-1] -lt $[${#menu_array[*]}/2] ]
		then
			clear
			${menu_array[$[$[$menuNum-1]*2+1]]}
			clear
		else
			echo "Enter Error"
		fi
	done
else
	permission=`adb devices | grep -w "no permissions" | wc -l`
        if [[ $permission == 1* ]]
        then
                pid=`ps -ef | grep adb | grep -v grep | awk '{print $2}'`
                kill -9 $pid
                sudo adb devices
        else
                echo "devices not exist, re-plug USB or reboot please"
        fi
fi

