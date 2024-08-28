#!/bin/bash
#       _          _ _
#   ___| |__   ___| (_) ___  _   _ ___
#  / _ \ '_ \ / _ \ | |/ _ \| | | / __|
# |  __/ |_) |  __/ | | (_) | |_| \__ \
#  \___|_.__/ \___|_|_|\___/ \__,_|___/
# https://github.com/ebelious
#
# multi-lingual dictionary
#
# Requires: dictd
#
# may be good to add alias to script path : alias def='/path/to/file/def.sh'

# Setting the language definitions
WORD2=$2
WORD1=$1
# Language Selection
# Latin
lat(){
dict -d fd-lat-eng $WORD2 | less -I
}
# Spanish
spa(){
dict -d fd-spa-eng $WORD2 | less -I
}
#Portuguese
por(){
dict -d fd-por-eng $WORD2 | less -I
}
# Japanese
jpn(){
dict -d fd-jpn-eng $WORD2 | less -I
}
# English
eng(){
dict $WORD2 | less -I
}
# All Dictionaries
all(){
dict -d all $WORD2 | less -I
}
# Help Menu
help(){
echo
echo -e "This is for defining words in a specific language"
echo -e "Usage: \e[3;37mdef [OPTION] [ARGUMENT]\e[0m"

echo -e "Example: \e[3;32mdef -l oppidum\e[0m"
echo
echo -e "-l \e[0;33m--\e[0m Latin"
echo -e "-s \e[0;33m--\e[0m Spanish"
echo -e "-p \e[0;33m--\e[0m Portuguese"
echo -e "-j \e[0;33m--\e[0m Japanese"
echo -e "-e \e[0;33m--\e[0m English"
echo -e "-a \e[0;33m--\e[0m All"
echo -e "-h \e[0;33m--\e[0m Help"
echo
echo -e "\e[3;mIf you would like to search the results just enter '/' and then the search term\e[0m"
echo -e "Example: \e[3;37m/spanish\e[0m"
echo
echo "Enter 'Q' to exit"
}

# Language Options
while getopts l:s:p:j:e:a:h OPTION
do
  case "$OPTION" in
    l) lat;;
    s) spa;;
    p) por;;
    j) jpn;;
    e) eng;;
    a) all;;
    h) help;;
    *) help;; 
 esac
done
