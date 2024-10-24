#!/bin/bash
#       _          _ _
#   ___| |__   ___| (_) ___  _   _ ___
#  / _ \ '_ \ / _ \ | |/ _ \| | | / __|
# |  __/ |_) |  __/ | | (_) | |_| \__ \
#  \___|_.__/ \___|_|_|\___/ \__,_|___/
# https://github.com/ebelious
#
# OUI lookup Tool - Uses Wireshare DB
# 
# You need to download and reference this file for DB lookups (need to decompress, and reference in the db file path in the script)
# https://www.wireshark.org/download/automated/data/manuf.gz
#

get_oui(){
if [[ $1 =~ ^([0-9A-Fa-f]{2}[:]){5}([0-9A-Fa-f]{2})$ ]]
then
        OUI=$(echo "$1" | cut -d ':' -f 1-3 | tr '[:lower:]' '[:upper:]')
        cat ./manuf | grep $OUI
        exit 0

elif [[ $1 =~ ^([0-9A-Fa-f]{2}[-]){5}([0-9A-Fa-f]{2})$ ]]
then
        OUI=$(echo "$1" | tr -d '-' | sed -e 's/[0-9A-Fa-f]\{2\}/&:/g' -e 's/:$//' | cut -d ':' -f 1-3 | tr '[:lower:]' '[:upper:]')
        cat ./manuf | grep $OUI
        exit 0

elif [[ $1 =~ ^([0-9A-Fa-f]{4}[.]){2}([0-9A-Fa-f]{4})$ ]]
then
        OUI=$(echo "$1" | tr -d '.' | sed -e 's/[0-9A-Fa-f]\{2\}/&:/g' -e 's/:$//' | cut -d ':' -f 1-3 | tr '[:lower:]' '[:upper:]')
        cat ./manuf | grep $OUI
        exit 0

elif [[ $1 =~ ^([0-9A-Fa-f]{2}[:]){2}([0-9A-Fa-f]{2})$ ]]
then
        OUI=$(echo "$1" | cut -d ':' -f 1-3 | tr '[:lower:]' '[:upper:]')
        cat ./manuf | grep $OUI
        exit 0

elif [[ $1 =~ ^([0-9A-Fa-f]{4}[.])([0-9A-Fa-f]{2})$ ]]
then
        OUI=$(echo "$1" | tr -d '.' | sed -e 's/[0-9A-Fa-f]\{2\}/&:/g' -e 's/:$//' | cut -d ':' -f 1-3 | tr '[:lower:]' '[:upper:]')
        cat ./manuf | grep $OUI
        exit 0

elif [[ $1 =~ ^([0-9A-Fa-f]{2}[-]){2}([0-9A-Fa-f]{2})$ ]]
then
        OUI=$(echo "$1" | cut -d ':' -f 1-3 | tr '[:lower:]' '[:upper:]')
        cat ./manuf | grep $OUI
        exit 0
else
        echo -e "\e[0:35m This is not in the correct format \e[0m"
        echo
        echo -e "USAGE: oui [MAC_ADDRESS]\n\n Mac Address Formats: \n    xx:xx:xx:xx:xx \n    xx-xx-xx-xx-xx-xx \n    xxxx.xxxx.xxxx \n    xx:xx:xx \n    xx-xx-xx \n    xxxx.xx \n\n Example: oui 00d9.d110.21f9"
fi
}

get_oui $1

if [ $? -ne 0 ]; then
	echo "No OUI was found."
	exit 1
fi
