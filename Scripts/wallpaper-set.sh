#!/bin/bash
#       _          _ _
#   ___| |__   ___| (_) ___  _   _ ___
#  / _ \ '_ \ / _ \ | |/ _ \| | | / __|
# |  __/ |_) |  __/ | | (_) | |_| \__ \
#  \___|_.__/ \___|_|_|\___/ \__,_|___/
# https://github.com/ebelious
#
# Sets wallpaper (river window manager)
# Requires: river, sxiv, swaybg
#

# This is a script for setting a persistent wallpaper - writes variable to .bash_profile, .bashrc and river ini (the only way to get persistant)
# This uses sxiv to select a image from a wlalpaper directory. Selecting an image with 'M' then exit with "Q" will set the wall paper

# Add this to the river init file:
# WALLPAPER=""
# riverctl spawn swaybg -m fit -i /path/to/wallpapers/$WALLPAPER &
#
# Modify the script to match the wallpaper path

# Set the image in a variable to pass to swaybg - sets WALLPAPER variable in river init file to be persistant

echo -e "Use 'M' to select the wallpaper and 'Q to quit the program'\nVerify the directory is correct to scrape the wallpapersi\nThis is configure to be persistant with the River Window manager"

WALLPAPER=$(sxiv -to $HOME/.config/Self-Hosted/Wallpapers/ | awk -F'/' '{print $NF}')

if [[ -z $WALLPAPER ]]; then
    echo -e "\e[0;31m[Err]\e[0m Wallpaper not selected - No Changes Made"
    exit 1
elif [[ $? -ne -0 ]];then
    echo -e "\e[0;31m[Err]\e[0m sxvi had an error - No Changes Made"
    exit 1
else
    pkill swaybg
    swaybg -m fill -i $HOME/.config/Self-Hosted/Wallpapers/$WALLPAPER &>/dev/null &
   # sed -i "/export WALLPAPER=/s/\".*\"/\"$WALLPAPER\"/" $HOME/.bashrc
   # sed -i "/export WALLPAPER=/s/\".*\"/\"$WALLPAPER\"/" $HOME/.bash_profile
    sudo sed -i "/WALLPAPER=/s/\".*\"/\"$WALLPAPER\"/" $HOME/.config/river/init
fi
echo -e "Use 'M' to select the wallpaper and 'Q to quit the program'\n\nVerify the directory is correct to scrape the wallpapers"
