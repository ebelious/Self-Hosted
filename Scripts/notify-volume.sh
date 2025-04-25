#!/bin/bash
#       _          _ _
#   ___| |__   ___| (_) ___  _   _ ___
#  / _ \ '_ \ / _ \ | |/ _ \| | | / __|
# |  __/ |_) |  __/ | | (_) | |_| \__ \
#  \___|_.__/ \___|_|_|\___/ \__,_|___/
# https://github.com/ebelious
#
# Sends notification when volume changes are detected
# Requires: libnotify,notification daemon,pamixer
# This is ran as a daemon

VOL_ID=0
LAST_VOL=$(pamixer --get-volume-human)  # Set initial volume so no notification at startup

while true; do
    # Get current volume
    CUR_VOL=$(pamixer --get-volume-human)

    # Only update if the volume changed
    if [[ "$CUR_VOL" != "$LAST_VOL" ]]; then
        VOL_ID=$(notify-send -t 1000 -r "$VOL_ID" -p "$CUR_VOL")
        LAST_VOL="$CUR_VOL"
    fi

    sleep 0.1
done
