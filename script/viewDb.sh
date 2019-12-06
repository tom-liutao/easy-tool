#! /bin/bash

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

view_menu
