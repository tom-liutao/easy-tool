#! /bin/bash

readonly led_menu_array=("Set Normal Pattern" "set_normal_pattern"\
			 "Set Indicate Pattern" "set_indicate_pattern"\
			 "Set Reverse Pattern" "set_reverse_pattern"\
			 "Back" "break")

function list () {
	mapNum=`grep -rn "INSERT INTO \"config_table\" VALUES('ui.led.pattern.*.type" ./sql/led.sql | wc -l`
	for ((i=0; i<$mapNum; i++))
	do
		info=`grep -rn "INSERT INTO \"config_table\" VALUES('ui.led.pattern.$i.type" ./sql/led.sql`
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
}

function set_normal_pattern () {
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
}

function set_indicate_pattern () {
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
}

function set_reverse_pattern () {
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
}

function led_menu () {
	mkdir -p ./sql
	adb pull /data/adk.led.db .
	sqlite3 adk.led.db ".dump" > ./sql/led.sql
	rm adk.led.db
	while :
	do
		clear
		echo "            Set LED Pattern"
		echo ""
		for ((i=0; i<$[${#led_menu_array[*]}/2]; i++))
		do
			echo "      $[$i+1]. ${led_menu_array[$i*2]}"
		done
		echo ""
		read -p "Enter Number:" menuNum
		if [ $[${menuNum}-1] -lt $[${#led_menu_array[*]}/2] ]
		then
			list
			clear	
			${led_menu_array[$[$[${menuNum}-1]*2+1]]}
		else
			echo "Enter Error"
		fi
	done
	rm -rf ./sql
}

led_menu
