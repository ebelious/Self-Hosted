#!/bin/bash
#       _          _ _
#   ___| |__   ___| (_) ___  _   _ ___
#  / _ \ '_ \ / _ \ | |/ _ \| | | / __|
# |  __/ |_) |  __/ | | (_) | |_| \__ \
#  \___|_.__/ \___|_|_|\___/ \__,_|___/
# https://github.com/ebelious
#
# Sets wallpaper (river window manager)
# Requires: river, nsxiv (or sxiv), swaybg
# Optional: pywal + ~/.config/theme.sh for wallpaper-derived colors
#
# Select an image with 'M', then quit with 'Q' to apply it.
#
# Colors are only regenerated when theme.sh is in 'wal' mode. In 'static'
# mode the wallpaper changes and the colorscheme is left alone.
# Toggle with: ~/.config/theme.sh toggle
#

WALLDIR="$HOME/.config/Wallpapers"
LOG="/tmp/wallpaper-set.log"

# River spawns this with no terminal attached, so send errors somewhere readable.
exec 2>>"$LOG"
echo "--- $(date) ---" >&2

# --- helpers ---------------------------------------------------------------

msg() {
    command -v notify-send >/dev/null 2>&1 && notify-send "Wallpaper" "$1"
    echo -e "$1"
}

err() {
    echo -e "\e[0;31m[Err]\e[0m $1"
    echo "[Err] $1" >&2
    command -v notify-send >/dev/null 2>&1 && notify-send -u critical "Wallpaper" "$1"
}

# --- dependency checks -----------------------------------------------------

# nsxiv replaced sxiv on most systems; accept either.
if command -v nsxiv >/dev/null 2>&1; then
    VIEWER=nsxiv
elif command -v sxiv >/dev/null 2>&1; then
    VIEWER=sxiv
else
    err "Neither nsxiv nor sxiv is installed"
    exit 1
fi

if ! command -v swaybg >/dev/null 2>&1; then
    err "swaybg is not installed"
    exit 1
fi

if [[ ! -d $WALLDIR ]]; then
    err "Wallpaper directory not found: $WALLDIR"
    exit 1
fi

# pywal 3.3.0 shells out to 'convert', which ImageMagick 7 renamed to 'magick'.
# Without this shim pywal silently fails and reuses its cached palette.
if ! command -v convert >/dev/null 2>&1 && command -v magick >/dev/null 2>&1; then
    mkdir -p "$HOME/.local/bin"
    if [[ ! -x $HOME/.local/bin/convert ]]; then
        printf '#!/bin/sh\nexec magick "$@"\n' > "$HOME/.local/bin/convert"
        chmod +x "$HOME/.local/bin/convert"
        echo "Created ImageMagick 7 shim at ~/.local/bin/convert" >&2
    fi
fi

# River gives this script a minimal PATH; make sure the shim is reachable.
case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) PATH="$HOME/.local/bin:$PATH" ;;
esac
export PATH

# --- pick the image --------------------------------------------------------

echo -e "Use 'M' to mark an image and 'Q' to quit\nScraping wallpapers from: $WALLDIR"

WALLPAPER=$("$VIEWER" -to "$WALLDIR" | awk -F'/' '{print $NF}')

if [[ -z $WALLPAPER ]]; then
    err "Wallpaper not selected - no changes made"
    exit 1
fi

IMAGE="$WALLDIR/$WALLPAPER"

if [[ ! -f $IMAGE ]]; then
    err "Selected file does not exist: $IMAGE"
    exit 1
fi

# --- set the wallpaper -----------------------------------------------------

pkill swaybg
swaybg -m fill -i "$IMAGE" &>/dev/null &

# --- generate the colorscheme ----------------------------------------------

# Only in 'wal' mode. theme.sh handles the terminal sequences, river borders,
# mako and waybar, so none of that is duplicated here.
if [[ $(cat "$HOME/.cache/theme-mode" 2>/dev/null) == wal ]]; then
    if command -v wal >/dev/null 2>&1; then
        # No -q: it would hide the errors you need when this runs from a keybind.
        if wal -i "$IMAGE" -n; then
            "$HOME/.config/theme.sh" reload
        else
            err "pywal failed to generate colors - see $LOG"
        fi
    else
        echo "pywal not installed - wallpaper set, colors unchanged" >&2
    fi
fi

# --- persist the selection -------------------------------------------------

# No sudo. Both files are owned by the user, and river spawns this script
# without a terminal, so sudo has nowhere to prompt and fails silently.
sed -i "/export WALLPAPER=/s/\".*\"/\"$WALLPAPER\"/" "$HOME/.bashrc"
sed -i "/^WALLPAPER=/s/\".*\"/\"$WALLPAPER\"/" "$HOME/.config/river/init"

msg "Set to $WALLPAPER"
