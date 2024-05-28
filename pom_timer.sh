#!/bin/bash

source ./functions.sh
cols=$(tput cols)
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
  local work_int=25; local s_break=5; local l_break=15, local reps=4
# Showing a menu
  echo -e "The default time intervals are:
1. Work: 25 minutes 
2. Short break: 5 minutes
3. Long break: 15 minutes
4. Long break after 4 work intervals
Do you want to change these intervals [y/N]?"
  read a
  
# Defining custom interval durations
if [[ "$a" == "y" ]]; then
  for ((i=1; i<=cols; i++)); do printf '=%.0s'; done
  echo "Insert new interval durations:
Work (minutes): "
  read work_int
  echo "Short break (mins): "
  read s_break
  echo "Long break (mins): "
  read l_break
  echo "Work repetition before a long break: "
  read reps
  fi

  # Starting the session loop
  local work=1
  local work_done=0
  local run=1
  cols=$(tput cols)
  echo ""
  clear
#  for ((i=1; i<=cols; i++)); do printf '=%.0s'; done

  echo "Use Ctrl+c to exit."
  while [ $run -eq 1 ]; do
    if [[ $work -eq 1 ]]; then
      work=0
      launch_timer2 "Work_session" "No_slacking_allowed!" 35 $(( work_int*60 ))
      (( work_done=work_done+1))
    fi
    (( to_l_break=work_done%reps))
    if [[ $work -eq 0 ]]; then
      work=1
      if [[ $to_l_break -eq 0 ]]; then
        launch_timer2 "Long_break" "Go_get_some_coffee,_you_earned_it" 10 $(( l_break*60 ))
      else
        launch_timer2 "Short_break" "Stretch_out_and_back_to_work." 20 $(( s_break*60 ))
      fi 
    fi
  done



}

# Defining the main menu
menu(){
  echo -ne "$(ColorGreen '1)') Start a Pomorodo session
$(ColorGreen '2)') Start a timer
$(ColorGreen '3)') View today's stats 
$(ColorGreen '4)') Settings
$(ColorGreen '0)') Quit
Select one of the options above: "
  read a
  for ((i=1; i<=cols; i++)); do printf '=%.0s'; done

  case $a in
    1) start_session ;;
    2) start_timer ;;
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
