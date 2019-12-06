#! /bin/bash

function mute_menu () {
	muteValue=`adb shell "cat /sys/class/gpio/gpio42/value"`
	if [[ $muteValue == 1* ]]
	then
		adb shell "echo 0 > /sys/class/gpio/gpio42/value"
	else
		adb shell "echo 1 > /sys/class/gpio/gpio42/value"
	fi
}

mute_menu
