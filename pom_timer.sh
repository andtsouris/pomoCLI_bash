#!/bin/bash

# Welcome text
echo "Welcome to PomodoroCLI!"
echo "Let's automatically launch a $1 second interval."


# Basic timer function
# arg1: timer duration (seconds)
# arg2: progress bar length
launch_timer () {
  counter=0
  divider=20

  while [ $counter -ne $divider ]
    do
      counter=$(($counter+1))
      echo -ne "#"
      fraction=$(echo "scale=2; $1/ $divider" | bc)
      sleep $fraction
    done
  echo ""
  echo "All done!"
}

# Main script
cur_duration=$1
launch_timer $cur_duration
