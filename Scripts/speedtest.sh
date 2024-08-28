#!/bin/bash
#      _          _ _
#   ___| |__   ___| (_) ___  _   _ ___
#  / _ \ '_ \ / _ \ | |/ _ \| | | / __|
# |  __/ |_) |  __/ | | (_) | |_| \__ \
#  \___|_.__/ \___|_|_|\___/ \__,_|___/
# https://github.com/ebelious
#
# This is for testing internet connection upload and download speeds
# Requires: speedtest-cli
#

# Different animations
spinn=( '\\' '|' '/' '-' )
#spinn=( Ooooo oOooo ooOoo oooOo ooooO )
#spinn=( '#....' '.#...' '..#..' '...#.' '....#' )
#spinn=( '>____' '_>___' '__>__' '___>_' '____>' )
HOSTED=$(grep Hosted speedtest.tmp)
DL=$(grep Download $HOME/Scripts/speedtest/speedtest.tmp | awk '{print $2 $3}')
UL=$(grep Upload $HOME/Scripts/speedtest/speedtest.tmp | awk '{print $2 $3}')

clear

process(){
 spin &
 pid=$!
  speedtest-cli > $HOME/Scripts/speedtest/speedtest.tmp
  kill $pid
clear
echo
echo -e "$HOSTED"
echo
echo -e "\e[0;36mDownload:\e[0m $DL"
echo -e "\e[0;32mUpload:\e[0m $UL"
}

spin(){
  while [ 1 ]
  do
    for i in "${spinn[@]}"
    do
      echo -ne "\r\e[0;32m[\e[0m\e[0;36m$i\e[0;32m]\e[0m Testing Connection"
      sleep 0.175
    done
  done
}

process

echo
echo
echo -e "\e[3;37mSelect 'R' to re-run the test, or any other key to exit\e[0m"
read -p 'Would you like to test again: ' OPTION

if [[ $OPTION == R ]] || [[ $OPTION == r ]]
then
  ./speedtest.sh
else
  echo -e "\e[0;35mExiting\e[0m " 
  sleep 1.5
  clear
  exit 0
fi
