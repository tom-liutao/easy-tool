#! /bin/bash
THIS_VERSION="2.0"

devices=`adb devices`
result=$(echo $devices | grep -w "device")
deviceNum=${result% *}
deviceNum=${deviceNum#*attached }

readonly menu_array=("Set LED Pattern"     "./script/led.sh"\
		"WiFi Connection" "./script/wifi.sh"\
		"Alexa Onboard"   "./script/alexa.sh"\
		"BT Modify" 	  "./script/bt.sh"\
		"Development" 	  "./script/development.sh"\
		"Reboot" 	  "adb reboot"\
		"Quit" 		  "exit 0")

chmod -R +x ./script

if [[ -n ${result} ]]
then
	./script/sys/is_exist.sh &
	clear
  	while :
	do
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

