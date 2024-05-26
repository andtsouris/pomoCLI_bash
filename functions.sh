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
  hash_string=$(seq -s# ${_hash_num}|tr -d '[:digit:]')
  title_block=$(echo " $title")

# Printing with or without the message depending on the window size
  if [ $_blank_block -lt 2 ]
  then
      printf "\r ${title}%${_title_blanks}s [${hash_string}%${_dash_num}s] ${time}%${_blank_block}s"
  else
      printf "\r ${title}%${_title_blanks}s [${hash_string}%${_dash_num}s] ${time}%${_blank_block}s\033[0;34m~ ${msg}\033[0m"
  fi
}

launch_timer (){
  
  local title="$1"
  local msg="$2"
  local bar_len="$3"
  local duration="$4"
  echo "BAR_LEN:${bar_len};   DURATION:${duration}"
  counter=0
  fraction=$(echo "scale=2; $duration/ $bar_len" | bc) 
  while [ $counter -ne $bar_len ]
    do
      local counter=$(($counter+1))

      (( cur_perc=(counter*100)/bar_len ))
      (( rem_secs=duration-(duration*cur_perc/100) ))
      (( m=rem_secs/60 ))
      (( s=rem_secs%60 ))
      local time=$(printf "%02d:%02d" $m $s)

      print_pbar ${title} ${msg} ${counter} ${time} ${bar_len}
      fraction=$(echo "scale=2; $duration/ $bar_len" | bc)
      sleep $fraction
    done
  echo ""
  echo "All done!"
}  
