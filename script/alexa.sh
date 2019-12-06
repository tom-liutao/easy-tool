#! /bin/bash

function alexa_menu () {
	gnome-terminal -x adb shell "adk-message-monitor -a"
	gnome-terminal -x adb shell "adk-message-send 'voiceui_start_onboarding{client:\"AVS\"}'"	
}

alexa_menu
