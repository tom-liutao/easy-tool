#! /bin/bash

function led_menu () {
	mkdir -p ~/sql
	adb pull /data/adk.led.db .
	sqlite3 adk.led.db ".dump" > ~/sql/led.sql
	rm adk.led.db
	while :
	do
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

led_menu
