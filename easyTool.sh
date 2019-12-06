#! /bin/bash
THIS_VERSION="1.0"

devices=`adb devices`
result=$(echo $devices | grep -w "device")
deviceNum=${result% *}
deviceNum=${deviceNum#*attached }

if [[ -n ${result} ]]
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
  		echo "*      8. Bt Addr Modify     *"
  		echo "*      9. Reboot             *"
  		echo "*      10. Quit              *"
  		echo "*                            *"
  		echo "******************************"
  		read -p "Enter Number:" menuNum
  
  		case $menuNum in
  		1)
		clear
		./script/led.sh		
		clear
  		;;

		2)
		clear
		./script/monitor.sh
		clear
		;;

		3)
		clear
		./script/viewDb.sh	
		clear
		;;

		4)
		clear
		./script/gpio.sh
		clear
		;;

		5)
		clear
		./script/wifi.sh
		clear
		;;
		
		6)
		clear
		./script/alexa.sh
		clear
		;;
		
		7)
		clear
		./script/mute.sh
		clear
		;;

		8)
		clear
		./script/bt_addr.sh
		clear
		;;

		9)
		adb reboot
		exit 0
		;;

		10)
		exit 0
		;;

		*)
		clear
		esac
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

