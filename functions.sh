#!/bin/bash


print_pbar(){
  # !!! ADD ERROR EXPLANATIONS !!! #
  local title="$1"
  local msg="$2"
  local current="$3"
  local time="${4} remaining"
  local bar_len="$5"

  # Defining the block sizes
  cols=$(tput cols)
  (( _title_blanks=2%${#title} ))
  (( _blank_block=cols-(_title_blanks+${#title}+2+${#msg}+${#time}+${bar_len}+6) ))
  
  # Setting the maximum blank size
  if [[ ${_blank_block} -gt 40 ]]; then
    _blank_block=40
  fi
  # Calculating the pbar symbols
  (( _hash_num=$current ))
  (( _dash_num=bar_len-_hash_num))
  (( short_length=_title_blanks+${#title}+2+${#time}+${bar_len}+6 )) 
  if [ $_hash_num -eq 0 ]; then
    hash_string=''
  else
    hash_string=$(seq -s# $_hash_num |tr -d '[:digit:]') 
  fi
   title_block=$(echo " $title")

# Printing with or without the message depending on the window size
  clear
  if [ $_blank_block -lt 2 ] && [ $cols -gt $short_length ]; then
    printf "\r ${title}%${_title_blanks}s [${hash_string}%${_dash_num}s] ${time}%${_blank_block}s"
  elif [[ $cols -lt $short_length ]]; then
    printf "\r ${title}%${_title_blanks}s ${time}"
  else
    printf "\r ${title}%${_title_blanks}s [${hash_string}%${_dash_num}s] ${time}%${_blank_block}s\033[0;34m~ ${msg}\033[0m"
  fi
}

launch_timer (){
  
  local title="$1"
  local msg="$2"
  local bar_len="$3"
  local duration="$4"
  #echo "BAR_LEN:${bar_len};   DURATION:${duration}"
  counter=0
  local partial=0
  rem_secs=$duration
  fraction=$(echo "scale=2; $duration/ $bar_len" | bc) 
  while [ $counter -ne $bar_len ]
  do
    local partial=$(($partial+1))
    if (( $(echo "$partial > $fraction" | bc -l) ))
    then
      local counter=$(($counter+1))
      local partial=0
    fi
    #(( cur_perc=(counter*100)/bar_len ))
    #(( rem_secs=duration-(duration*cur_perc/100) ))
    (( rem_secs-=1))
    (( m=rem_secs/60 ))
    (( s=rem_secs%60 ))
    local time=$(printf "%02d:%02d" $m $s)

    print_pbar ${title} ${msg} ${counter} ${time} ${bar_len}
    sleep 1
  done
  echo -e "\nAll done!"
} 
#launch_timer "My_title" "Let's_go!" 35 60

launch_timer2 (){
  local title="$1"
  local msg="$2"
  local bar_len="$3"
  local duration="$4"

  secs_passed=0
  while [ $secs_passed -le $duration ]
  do
    cur_perc=$(echo "scale=2; $secs_passed/$duration" | bc)
    counter=$( echo "scale=0; $cur_perc*$bar_len" | bc)

    (( rem_secs=$duration-$secs_passed))
    (( m=rem_secs/60 ))
    (( s=rem_secs%60 ))
    local time=$(printf "%02d:%02d" $m $s)
    
    if (( $(echo "$counter < 1" | bc -l) )); then
      counter=0
    fi
    print_pbar ${title} ${msg} ${counter%.*} ${time} ${bar_len}
    sleep 1
    (( secs_passed=secs_passed+1 ))
  done
   afplay assets/$my_sound
 }

start_timer() {
  clear
  echo -n "Timer duration in seconds: "
  read cur_duration
  launch_timer2 "Timer" "Timer_running" 35 $cur_duration

  sleep 1
  clear
  menu
}
