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

settings() {
  clear
  read -ep "Settings:
$(ColorGreen '1)') Change default interval times
$(ColorGreen '2)') Choose sound
$(ColorGreen '0)') Got to menu
Select one of the options above: " choice
  case $choice in
    1) change_intervals;;
    2) change_sound;;
    *) clear; menu;;
  esac
  for ((i=1; i<=cols; i++)); do printf '=%.0s'; done
  settings
}
change_intervals() {
  read -p "Work duration (minutes): " work_int
  read -p "Short break duration (minutes): " s_break
  read -p "Long break duration (minutes): " l_break
  read -p "Work repetitions before a long break: " reps
}

change_sound() {
  clear

  echo -e "Select one of the following sounds $(ColorBlue '(selected sound has *)'):
$(ColorGreen '1)') Bell   $sel1
$(ColorGreen '2)') Tone 1 $sel2
$(ColorGreen '3)') Tone 2 $sel3
$(ColorGreen '4)') Tone 3 $sel4"
  read choice
  case $choice in 
    1) sel1='*'; sel2=''; sel3=''; sel4=''; my_sound='bell.mp3';;
    2) sel1=''; sel2='*'; sel3=''; sel4=''; my_sound='tone1.mp3';;
    3) sel1=''; sel2=''; sel3='*'; sel4=''; my_sound='tone2.mp3';;
    4) sel1=''; sel2=''; sel3=''; sel4='*'; my_sound='tone3.mp3';;
    *) echo 'Wrong choice!'
  esac
  afplay assets/$my_sound
  settings
  }

start_session() {

# Showing a menu
  echo -e "The default time intervals are:
1. Work: $work_int minutes 
2. Short break: $s_break minutes
3. Long break: $l_break minutes
4. Long break after $reps work intervals
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
      launch_timer2 "Work_session" "No_slacking_allowed!" 30 $(( work_int*60 ))
      (( work_done=work_done+1))
    fi
    (( to_l_break=work_done%reps))
    if [[ $work -eq 0 ]]; then
      work=1
      if [[ $to_l_break -eq 0 ]]; then
        launch_timer2 "Long_break" "Go_get_some_coffee,_you_earned_it" 30 $(( l_break*60 ))
      else
        launch_timer2 "Short_break" "Stretch_out_and_back_to_work." 30 $(( s_break*60 ))
      fi 
    fi
  done



}
 docs() {
   clear; clear
   echo "$(ColorGreen '---------- PomodoroCLI documentation ------------')
PomodoroCLI is a simple pomodoro timer with the aim of improving the user's 
productivity without much distraction.

$(ColorGreen 'POMODORO SESSION')
In the Main menu you can find a Pomodoro. You can use the default times or change 
each interval duration.

$(ColorGreen 'SIMPLE TIMER')
The timer mode consists of a simple timer. The simple time is set in seconds, whereas
the Pomodoro sessions are set in minutes.

$(ColorGreen 'THE POMODORO TECHNIQUE')
The Pomodoro Technique is a time management method that involves working in focused
intervals, typically 25 minutes, followed by a short break of 5 minutes. After completing
four intervals, a longer break of 15-30 minutes is taken. This technique helps improve
productivity and maintain mental clarity."
 }
# Defining the main menu
menu(){
  echo -ne "Main menu
$(ColorGreen '1)') Start a Pomorodo session
$(ColorGreen '2)') Start a timer
$(ColorGreen '3)') Settings
$(ColorGreen '4)') Documentation
$(ColorGreen '0)') Quit
Select one of the options above: "
  read a
  for ((i=1; i<=cols; i++)); do printf '=%.0s'; done

  case $a in
    1) start_session ;;
    2) start_timer ;;
    3) settings;; 
    4) docs;;
    0) exit;;
    *) echo -e $red"Wrong option.";;
  esac
}


# Main script
echo -ne "Welcome to PomodoroCLI! \n"
sel1='*'; sel2=''; sel3=''; sel4=''; my_sound='bell.mp3'
work_int=25; s_break=5; l_break=15; reps=4
menu
cur_duration=$1
#launch_timer "Title" "Message" 20 25 ${cur_duration}
