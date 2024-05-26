#!/bin/bash

source ./functions.sh

# Welcome text

# Launching the main menu
## Define the colours
green='\033[32m'
blue='\033[34m'
red='\033[31m'
clear='\033[0m'
##
# Color Functions
##
ColorGreen(){
	echo -ne $green$1$clear
}
ColorBlue(){
	echo -ne $blue$1$clear
}
ColorRed(){
  echo -ne $red$1$clear
}

start_session() {
  clear
  echo "Let's start our session..."
  echo -e "
${green}1)$clear Start a work interval
${green}2)$clear Exit
  "
  my_msg="Have fun."
  rest_msg="Let\'s get some rest."
  read a
  case $a in
    1) {
      launch_timer "Work" "\${my_msg}" 35 2400
      launch_timer "Break" "\{rest_msg}" 35 300
      launch_timer "Work" "\${my_msg}" 35 2400
      launch_timer "Break" "\{rest_msg}" 35 300
      launch_timer "Work" "\${my_msg}" 35 2400
      launch_timer "Break" "\{rest_msg}" 35 300 
      launch_timer "Work" "\${my_msg}" 35 2400
      launch_timer "Long Break" "\{rest_msg}" 35 900
    };;
    *) exit;;
  esac
}

# Defining the main menu
menu(){
  echo -ne "
$(ColorGreen '1)') Start a Pomorodo session
$(ColorGreen '2)') Start a timer
$(ColorGreen '3)') View today's stats 
$(ColorGreen '4)') Settings
$(ColorGreen '0)') Quit
"
  read a
  case $a in
    1) start_session ;;
    2) echo 'Timer duration (HH:MM:SS):';;
    3) echo 'Viewing stats!';;
    4) echo 'Settings opened';;
    0) exit;;
    *) echo -e $red"Wrong option.";;
  esac
}


# Main script
echo -ne "Welcome to PomodoroCLI! \n"
menu
cur_duration=$1
#launch_timer "Title" "Message" 20 25 ${cur_duration}
