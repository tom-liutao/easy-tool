#! /bin/bash

readonly view_menu_array=("LED DB File"   "viewFile led ;"\
                         "Button DB File" "viewFile button ;"\
                         "Rules DB File"  "viewFile rules ;"\
                         "Back"           "break")

function viewFile () {
	mkdir -p ./sql
	adb pull /data/adk.$1.db .
	sqlite3 adk.$1.db ".dump" > ./sql/$1.sql
	gnome-terminal -x bash -c "cat ./sql/$1.sql; exec bash;"
	rm adk.$1.db
}

function view_menu () {
	while : 
	do
		clear
                echo "            View"
                echo ""
                for ((i=0; i<$[${#view_menu_array[*]}/2]; i++))
                do
                        echo "      $[$i+1]. ${view_menu_array[$i*2]}"
                done
                echo ""
                read -p "Enter Number:" menuNum
                if [ $[${menuNum}-1] -lt $[${#view_menu_array[*]}/2] ]
                then
                        clear
                        ${view_menu_array[$[$[${menuNum}-1]*2+1]]}
                else
                        echo "Enter Error"
                fi
	done
	rm -rf ./sql
}

view_menu
