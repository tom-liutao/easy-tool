#! /bin/bash

readonly bt_menu_array=("BT Addr Modify" bt_addr\
			"BT Name Modify" bt_name\
			"Back" break)
readonly addr_array=("70:c9:4e:b7:f6:54" "70:c9:4e:7f:63:7a" "70:c9:4e:5b:b3:fe" "70:c9:4e:5b:b9:4e" "70:c9:4e:7f:6d:0e")

function bt_addr () {
	clear
	echo "            BT Addr Modify"
        for ((i=0; i<${#addr_array[*]}; i++))
        do
                echo "$[$i+1]  ADDR$[$i+1] : ${addr_array[${i}]}"
        done
        read -p "Enter Number:" btAddr
        if [ $[${btAddr}-1] -lt ${#addr_array[*]} ]
        then
                adb shell setprop persist.vendor.service.bdroid.bdaddr ${addr_array[$[${btAddr}-1]]}
        else
                echo "Enter Error"
        fi
	echo "Setting Success"
        setaddr=`adb shell getprop persist.vendor.service.bdroid.bdaddr`
	echo "Current BT ADDR: ${setaddr}"
        read -p "Any Key to Continue" p
}

function bt_name () {
	clear
	echo "            BT Name Modify"
	read -p "Enter New BT Name:" btName
	gnome-terminal -x adb shell "adk-message-send 'connectivity_bt_setname {name:\"$btName\"}'"
}

function bt_menu () {
	echo "           BT Modify"
	echo ""
	currBTName=`adb shell adkcfg -f /data/adk.connectivity.bt.db read connectivity.bt.device_name`
	echo "   Current BT Name: $currBTName"
	for ((i=0; i<$[${#bt_menu_array[*]}/2]; i++))
	do
		echo "      $[$i+1]. ${bt_menu_array[$[$i*2]]}"	
	done
	echo ""
	read -p "Enter Number:" menuNum
	if [ $[${menuNum}-1] -lt $[ ${#bt_menu_array[*]}/2 ] ]
        then
		${bt_menu_array[$[$[$menuNum-1]*2 +1]]}
        else
                echo "Enter Error"
        fi
}

bt_menu
