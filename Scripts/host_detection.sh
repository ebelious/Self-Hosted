#!/bin/bash
#       _          _ _
#   ___| |__   ___| (_) ___  _   _ ___
#  / _ \ '_ \ / _ \ | |/ _ \| | | / __|
# |  __/ |_) |  __/ | | (_) | |_| \__ \
#  \___|_.__/ \___|_|_|\___/ \__,_|___/
# https://github.com/ebelious
#
# This is for detecting hosts in a specific network
# Requires: nmap
#

# Different animations
spinn=( '\\' '|' '/' '-' )
#spinn=( Ooooo oOooo ooOoo oooOo ooooO )
#spinn=( '#....' '.#...' '..#..' '...#.' '....#' )
#spinn=( '>____' '_>___' '__>__' '___>_' '____>' )

clear

process(){
 spin &
 pid=$!
 nmap -sn $TARGET > $HOME/Scripts/host_detection/host_detection.tmp
 kill $pid
 clear
 sleep .5
}

spin(){
  while [ 1 ]
  do
    for i in "${spinn[@]}"
    do
      echo -ne "\r\e[0;32m[\e[0m\e[0;36m$i\e[0;32m]\e[0m Scanning Hosts"
      sleep 0.175
    done
  done
}

echo -e "\e[3;37mExample 10.1.1.0/24\e[0m"
echo "Enter a Network to Scan"
echo -e "\e[3;32m"
read TARGET
echo -e "\e[0m"
clear

process

echo -e  "Detected Hosts on \e[0;32m$TARGET\e[0m Network"
echo
cat $HOME/Scripts/host_detection/host_detection.tmp | grep report | awk '{print $5}'
echo
echo -e "\e[3;37mEnter 'R' to re-run the scan, or any other key to exit\e[0m"
echo -e "Would you like to scan again:"
echo
read  OPTION

if [[ $OPTION == R ]] || [[ $OPTION == r ]]
then
  rm $HOME/Scripts/host_detection/host_detection.tmp
  $HOME/Scripts/host_detection/host_detection.sh
else
  $HOME/Scripts/host_detection/host_detection.tmp
  clear
  echo
  echo -e "\e[0;35mExiting\e[0m " 
  sleep 1
  clear
  exit 0
fi
