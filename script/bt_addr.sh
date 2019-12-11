#! /bin/bash

readonly addr_array=("70:c9:4e:b7:f6:54" "70:c9:4e:7f:63:7a" "70:c9:4e:5b:b3:fe" "70:c9:4e:5b:b9:4e" "70:c9:4e:7f:6d:0e")

function bt_menu () {
        for ((i=0; i<${#addr_array[*]}; i++))
        do
                echo "$[$i+1]  ADDR$[$i+1] : ${addr_array[${i}]}"
        done
        read -p "Enter Number:" btAddr
        if [ $[${btAddr}-1] -lt ${#addr_array[*]} ]
        then
                #echo "Set BT ADDR:${addr_array[$[${btAddr}-1]]}"
                adb shell setprop persist.vendor.service.bdroid.bdaddr ${addr_array[$[${btAddr}-1]]}
        else
                echo "Enter Error"
        fi
	echo "Setting Success"
        setaddr=`adb shell getprop persist.vendor.service.bdroid.bdaddr`
	echo "Current BT ADDR: ${setaddr}"
        read -p "Any Key to Continue" p
}

bt_menu
