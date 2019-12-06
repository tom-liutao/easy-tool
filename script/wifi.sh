#! /bin/bash

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

wifi_menu
