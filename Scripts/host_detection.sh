# .bashrc
#       _          _ _
#   ___| |__   ___| (_) ___  _   _ ___
#  / _ \ '_ \ / _ \ | |/ _ \| | | / __|
# |  __/ |_) |  __/ | | (_) | |_| \__ \
#  \___|_.__/ \___|_|_|\___/ \__,_|___/
# https://github.com/ebelious
#
#

# Different animations
spinn=( '\\' '|' '/' '-' )
#spinn=( Ooooo oOooo ooOoo oooOo ooooO )
#spinn=( '#....' '.#...' '..#..' '...#.' '....#' )
#spinn=( '>____' '_>___' '__>__' '___>_' '____>' )
RESULTS=$(cat host_detection.tmp | grep report | awk '{print $5}')

clear
process(){
 spin &
 pid=$!
 nmap -sn -T4 $TARGET > $HOME/Scripts/host_detection/host_detection.tmp
 kill $pid
 clear
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
read TARGET
clear

process

echo "Detected Hosts"
echo
echo "$RESULTS"
echo
echo -e "\e[3;37mSelect 'R' to re-run the test, or any other key to exit\e[0m"
read -p 'Would you like to test again: ' OPTION

if [[ $OPTION == R ]] || [[ $OPTION == r ]]
then
  $HOME/Scripts/host_detection/host_detection.sh
else
  clear
  echo -e "\e[0;35mExiting\e[0m " 
  sleep 1
  clear
  exit 0
fi
