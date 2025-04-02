#!/bin/bash
#       _          _ _
#   ___| |__   ___| (_) ___  _   _ ___
#  / _ \ '_ \ / _ \ | |/ _ \| | | / __|
# |  __/ |_) |  __/ | | (_) | |_| \__ \
#  \___|_.__/ \___|_|_|\___/ \__,_|___/
# https://github.com/ebelious
#
# Toggles waybar visibility
# Requires: waybar
 
# Toggles waybar with keybind in river init
PROC=$(pidof waybar)
if [ -z "$PROC" ]; then
    exec waybar
elif [ -n "$PROC" ]; then
   pkill waybar
fi
