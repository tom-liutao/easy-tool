#! /bin/bash

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

gpio_menu
