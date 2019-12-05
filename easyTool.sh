#! /bin/bash
THIS_VERSION="1.0"

function led_menu () {
	mkdir -p ~/sql
	adb pull /data/adk.led.db .
	sqlite3 adk.led.db ".dump" > ~/sql/led.sql
	rm adk.led.db
	while :
	do
		clear
		echo "******************************"
		echo "*         Set LED            *"
		echo "*  1. Set Normal Pattern     *"
		echo "*  2. Set Indicate Pattern   *"
		echo "*  3. Set Reverse Pattern    *"
		echo "*  4. Back                   *"
		echo "******************************"
		read -p "Enter Number:" LEDCase 
		
		mapNum=`grep -rn "INSERT INTO \"config_table\" VALUES('ui.led.pattern.*.type" ~/sql/led.sql | wc -l`
		for ((i=0; i<$mapNum; i++))
		do
			info=`grep -rn "INSERT INTO \"config_table\" VALUES('ui.led.pattern.$i.type" ~/sql/led.sql`
			if [ $i -lt 10 ]
			then
				info=${info:63}
				substr=${info%%\'*}
				array[$i]="$substr"
			else
				info=${info:64}
				substr=${info%%\'*}
				array[$i]="$substr"
			fi  
		done

		

		case $LEDCase in
		1)
		clear
		for ((i=0; i<$mapNum; i++))
		do
			if [ "${array[$i]}" = "trail" ] || [ "${array[$i]}" = "pulse" ] || [ "${array[$i]}" = "basic" ]
			then
				echo "Enter Pattren Number $i to Set * ${array[$i]} * Pattern"
			fi  
		done
		read -p "Enter Pattern Number:" patternNum
		LEDMsgStr="adk-message-send 'led_start_pattern{pattern:$patternNum}'"
		gnome-terminal -x adb shell "$LEDMsgStr"
		;;
		2)
		clear
		for ((i=0; i<$mapNum; i++))
		do
			if [ "${array[$i]}" = "direction" ]
			then
				echo "Enter Pattren Number $i to Set * ${array[$i]} * Pattern"
			fi  
		done
		read -p "Enter Pattern Number:" patternNum
		LEDMsgStr="adk-message-send 'led_indicate_direction_pattern{pattern:$patternNum direction:0}'"
		gnome-terminal -x adb shell "$LEDMsgStr"
		;;
		3)
		clear
		for ((i=0; i<$mapNum; i++))
		do
			if [ "${array[$i]}" = "reverse" ]
			then
				echo "Enter Pattren Number $i to Set * ${array[$i]} * Pattern"
			fi  
		done
		read -p "Enter Pattern Number:" patternNum
		LEDMsgStr="adk-message-send 'led_reverse_direction_pattern{pattern:$patternNum direction:0}'"
		gnome-terminal -x adb shell "$LEDMsgStr"
		;;
		4)break
		;;
		*)clear
		echo "Error Quited"
		esac
	done
	rm ~/sql/led.sql 
}

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

function view_menu () {
	echo "******************************"
	echo "*           View             *"
	echo "*      1. Led DB File        *"
	echo "*      2. Button DB File     *"
	echo "*      3. Rules DB File      *"
	echo "*      4. Back               *"
	echo "******************************"
	while : 
	do
		read -p "Enter Number:" viewCase
		case $viewCase in
		1)
		adb pull /data/adk.led.db .
		sqlite3 adk.led.db ".dump" > ~/sql/led.sql
		gnome-terminal -x bash -c "cat ~/sql/led.sql; exec bash;"
		rm adk.led.db
		;;
		2)
		adb pull /data/adk.button.db .
		sqlite3 adk.button.db ".dump" > ~/sql/button.sql
		gnome-terminal -x bash -c "cat ~/sql/button.sql; exec bash;"
		rm adk.button.db
		;;
		3)
		adb pull /data/adk.rules.db .
		sqlite3 adk.rules.db ".dump" > ~/sql/rules.sql
		gnome-terminal -x bash -c "cat ~/sql/rules.sql; exec bash;"
		rm adk.rules.db
		;;
		4)
		break
		;;
		*)
		echo "Error Re-Type"
		;;
		esac
	done
}

function gpio_menu () {
	read -p "Enter GPIO_Num:" gpioNum
	read -p "Enter GPIO_Behaviour:" gpioBehaviour
	read -p "Enter GPIO_Value:" gpioValue
	gpioStr1="echo $gpioNum > /sys/class/gpio/export"
	gpioStr2="echo $gpioBehaviour > /sys/class/gpio/gpio$gpioNum/direction"
	gpioStr3="echo $gpioValue > /sys/class/gpio/gpio$gpioNum/value"
	gpioStr4="echo $gpioNum > /sys/class/gpio/unexport"
	gnome-terminal -x adb shell "$gpioStr1"
	gnome-terminal -x adb shell "$gpioStr2"
	gnome-terminal -x adb shell "$gpioStr3"
	gnome-terminal -x adb shell "$gpioStr4"
	read pause
}

function wifi_menu () {
	adb pull /etc/misc/wifi/wpa_supplicant.conf .
	wifiName=`grep 'ssid=\"' ./wpa_supplicant.conf`
	wifiNameStr=${wifiName#*\"}
	wifiNameStr=${wifiNameStr%\"*}
	rm ./wpa_supplicant.conf
	while :
	do		 		
		clear
		echo "******************************"
		echo "*      Wifi Connection       *"
		echo "*                            *"
		echo "* Connecting : $wifiNameStr  "
		echo "*                            *"
		echo "*     1. Connect Wifi        *"
		echo "*     2. Change  Wifi        *"
		echo "*     3. Scan Wifi List      *"
		echo "*     4. Refresh Connection  *"
		echo "*     5. Back                *"
		echo "******************************"
		read -p "Enter Number:" wifiCase
		case $wifiCase in
		1)
		read -p "Enter ssid:" wifissid
		read -p "Enter Password:" wifipassw
		wifiMsgStr="adk-message-send 'connectivity_wifi_connect {ssid:\"$wifissid\"password:\"$wifipassw\" homeap:true}'"
		gnome-terminal -x adb shell "adk-message-send 'connectivity_wifi_disable{}'"
		gnome-terminal -x adb shell "adk-message-send 'connectivity_wifi_enable{}'"
		gnome-terminal -x adb shell "adk-message-send 'connectivity_wifi_scan{}'"
		gnome-terminal -x adb shell "$wifiMsgStr"
		;;
		2)
		read -p "Enter ssid:" wifissid
		read -p "Enter Password:" wifipassw
		gnome-terminal -x adb shell "adk-message-send 'connectivity_wifi_onboard{}'"
		wifiMsgStr="adk-message-send 'connectivity_wifi_connect {ssid:\"$wifissid\"password:\"$wifipassw\" homeap:true}'"
		gnome-terminal -x adb shell "$wifiMsgStr"
		;;
		3)
		gnome-terminal -x adb shell "adk-message-monitor -a"
		gnome-terminal -x adb shell "adk-message-send 'connectivity_wifi_scan{}'"	
		;;
		4)
		adb pull /etc/misc/wifi/wpa_supplicant.conf .
		wifiName=`grep 'ssid=\"' ./wpa_supplicant.conf`
		wifiNameStr=${wifiName#*\"}
		wifiNameStr=${wifiNameStr%\"*}
		rm ./wpa_supplicant.conf
		;;
		5)
		break
		;;
		*)
		;;
		esac
	done
}

function alexa_menu () {
	gnome-terminal -x adb shell "adk-message-monitor -a"
	gnome-terminal -x adb shell "adk-message-send 'voiceui_start_onboarding{client:\"AVS\"}'"	
}

function mute_menu () {
	muteValue=`adb shell "cat /sys/class/gpio/gpio42/value"`
	if [[ $muteValue == 1* ]]
	then
		adb shell "echo 0 > /sys/class/gpio/gpio42/value"
	else
		adb shell "echo 1 > /sys/class/gpio/gpio42/value"
	fi
}

devices=`adb devices`
result=$(echo $devices | grep -w "device")
deviceNum=${result% *}
deviceNum=${deviceNum#*attached }

if [[ -n $result ]]
then
	clear
  	while :
	do
		muteValue=`adb shell "cat sys/class/gpio/gpio42/value"`
		if [[ $muteValue == 1* ]]
		then
			mute="Mute"
		else
			mute="UnMute"
		fi
  		echo "******************************"
  		echo "*   Version: $THIS_VERSION             *"
  		echo "*   Device : $deviceNum exist   *"
  		echo "*                            *"
  		echo "*********** M E N U **********"
  		echo "*                            *"
  		echo "*      1. Set LED Pattern    *"
 	 	echo "*      2. Monitor            *"
  		echo "*      3. View DB File       *"
 	 	echo "*      4. Configure Gpio     *"
 	 	echo "*      5. Wifi Connect       *"
 	 	echo "*      6. Alexa Onboard      *"
  		echo "*      7. $mute               *"
  		echo "*      8. Reboot             *"
  		echo "*      9. Quit               *"
  		echo "******************************"
  		read -p "Enter Number:" menuNum
  
  		case $menuNum in
  		1)
		clear
		led_menu		
  		;;

		2)
		clear
		monitor_menu
		;;

		3)
		clear
		view_menu	
		;;

		4)
		clear
		gpio_menu	
		;;

		5)
		wifi_menu	
		;;
		
		6)
		alexa_menu
		;;
		
		7)
		mute_menu
		;;

		8)
		adb reboot
		exit 0
		;;

		9)
		exit 0
		;;

		*)
		clear
		echo "***Error Re-type***";;
		esac
		clear
	done
else
	echo "devices not exist, re-plug USB or reboot please"
fi

