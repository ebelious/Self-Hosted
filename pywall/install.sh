#!/bin/bash
#       _          _ _
#   ___| |__   ___| (_) ___  _   _ ___
#  / _ \ '_ \ / _ \ | |/ _ \| | | / __|
# |  __/ |_) |  __/ | | (_) | |_| \__ \
#  \___|_.__/ \___|_|_|\___/ \__,_|___/
# https://github.com/ebelious
#
# Installs the pywal theming setup. Run from the repo root:
#   ./install.sh
#
# Scripts and the static palette are symlinked, so `git pull` updates them
# in place. Config files that you own (foot.ini, mako/config) are only
# patched, never overwritten.
#

set -e
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP=$(date +%s)

backup() {
    [[ -e $1 && ! -L $1 ]] && cp -r "$1" "$1.bak.$STAMP" && echo "  backed up $1"
    return 0
}

echo "Installing from $SRC"

# --- scripts ---------------------------------------------------------------
mkdir -p "$HOME/.config"
backup "$HOME/.config/theme.sh"
backup "$HOME/.config/wallpaper-set.sh"
ln -sfn "$SRC/bin/theme.sh"          "$HOME/.config/theme.sh"
ln -sfn "$SRC/bin/wallpaper-set.sh"  "$HOME/.config/wallpaper-set.sh"
chmod +x "$SRC/bin/theme.sh" "$SRC/bin/wallpaper-set.sh"
echo "  scripts -> ~/.config/"

# --- static palette --------------------------------------------------------
# Copied, not symlinked: theme.sh writes generated files into this directory
# and they should not land in the repo.
mkdir -p "$HOME/.config/theme/static"
if [[ ! -f $HOME/.config/theme/static/colors.sh ]]; then
    cp "$SRC/static/colors.sh" "$HOME/.config/theme/static/colors.sh"
    echo "  static palette installed"
else
    echo "  static palette already exists, left alone"
fi

# --- pywal templates -------------------------------------------------------
# This path is not configurable; pywal only reads ~/.config/wal/templates/
mkdir -p "$HOME/.config/wal/templates"
for t in foot-colors.ini colors-waybar.css colors-mako; do
    ln -sfn "$SRC/templates/$t" "$HOME/.config/wal/templates/$t"
done
echo "  templates -> ~/.config/wal/templates/"

# --- waybar ----------------------------------------------------------------
if [[ -d $HOME/.config/waybar ]]; then
    backup "$HOME/.config/waybar/style.css"
    ln -sfn "$SRC/waybar/style.css" "$HOME/.config/waybar/style.css"
    echo "  waybar style.css -> repo"
else
    echo "  no ~/.config/waybar, skipped"
fi

# --- foot ------------------------------------------------------------------
FOOT="$HOME/.config/foot/foot.ini"
if [[ -f $FOOT ]]; then
    if ! grep -q 'theme/foot-colors.ini' "$FOOT"; then
        backup "$FOOT"
        # remove any existing colors section, then add the include
        sed -i '/^\[colors\(-dark\)\?\]/,/^\[/{/^\[colors\(-dark\)\?\]/d}' "$FOOT"
        echo "include=$HOME/.cache/theme/foot-colors.ini" >> "$FOOT"
        echo "  foot.ini patched"
    else
        echo "  foot.ini already patched"
    fi
else
    echo "  no foot.ini, skipped"
fi

# --- mako ------------------------------------------------------------------
# theme.sh adds its own markers on first run, so nothing to do here.
echo "  mako is patched by theme.sh on first run"

# --- done ------------------------------------------------------------------
echo
echo "Done. Next:"
echo "  ~/.config/theme.sh static      # apply the fallback theme"
echo "  ~/.config/theme.sh status      # check state"
echo
echo "Add to your river init:"
echo "  riverctl map normal Super+Shift C spawn \"\$HOME/.config/theme.sh toggle\""
echo "  riverctl map normal Super+Shift P spawn \"\$HOME/.config/wallpaper-set.sh\""
echo "  riverctl spawn \"\$HOME/.config/theme.sh reload\""
