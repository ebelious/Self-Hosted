#!/bin/bash
#       _          _ _
#   ___| |__   ___| (_) ___  _   _ ___
#  / _ \ '_ \ / _ \ | |/ _ \| | | / __|
# |  __/ |_) |  __/ | | (_) | |_| \__ \
#  \___|_.__/ \___|_|_|\___/ \__,_|___/
# https://github.com/ebelious
#
# Toggle between pywal (wallpaper-derived) and static colors.
#
# Usage:
#   theme.sh toggle    flip between modes
#   theme.sh wal       force pywal colors
#   theme.sh static    force the static theme
#   theme.sh reload    re-apply whatever mode is current
#   theme.sh status    print the current mode
#
# How it works: ~/.cache/theme is a symlink pointing at either ~/.cache/wal
# or ~/.config/theme/static. foot and waybar read through that fixed path.
# mako is different - its colors are written directly into its config file
# between marker comments, because include= is not supported on all builds.
#
# Consumers:
#   foot    include=/home/USER/.cache/theme/foot-colors.ini
#   waybar  @import url("file:///home/USER/.cache/theme/colors-waybar.css");
#   mako    # THEME-START / # THEME-END markers in ~/.config/mako/config
#   river   riverctl at runtime
#   shells  cat ~/.cache/theme/sequences
#

STATICDIR="$HOME/.config/theme/static"
WALDIR="$HOME/.cache/wal"
LINK="$HOME/.cache/theme"
STATE="$HOME/.cache/theme-mode"
MAKOCFG="$HOME/.config/mako/config"

# How far to pull the background toward an accent color, as a percentage.
# pywal's default backend crushes the background to near-black on every
# image; this blends it back toward a color actually found in the wallpaper.
# 0 = pure pywal (near-black), 20 = subtle tint, 35 = strong tint.
TINT_PERCENT=20

# Minimum foreground brightness (0-255 average). If pywal picks a foreground
# darker than this, it gets replaced - bright wallpapers can otherwise
# produce unreadable terminals. Set to 0 to disable.
MIN_FG_BRIGHTNESS=140
FALLBACK_FG='#ebdbb2'

# --- static palette --------------------------------------------------------
# Edit these to change your fallback theme. Currently gruvbox dark.

write_static_palette() {
    mkdir -p "$STATICDIR"
    cat > "$STATICDIR/colors.sh" << 'EOF'
background='#282828'
foreground='#ebdbb2'
cursor='#ebdbb2'
color0='#282828'
color1='#cc241d'
color2='#98971a'
color3='#d79921'
color4='#458588'
color5='#b16286'
color6='#689d6a'
color7='#a89984'
color8='#928374'
color9='#fb4934'
color10='#b8bb26'
color11='#fabd2f'
color12='#83a598'
color13='#d3869b'
color14='#8ec07c'
color15='#ebdbb2'
EOF
}

# --- color helpers ---------------------------------------------------------

# Average brightness of a #rrggbb value, 0-255.
brightness() {
    local h="${1#\#}"
    echo $(( (0x${h:0:2} + 0x${h:2:2} + 0x${h:4:2}) / 3 ))
}

# Blend $1 toward $2 by $3 percent.
blend() {
    local a="${1#\#}" b="${2#\#}" p="$3" q=$((100 - $3))
    printf '#%02x%02x%02x' \
        $(( (0x${a:0:2} * q + 0x${b:0:2} * p) / 100 )) \
        $(( (0x${a:2:2} * q + 0x${b:2:2} * p) / 100 )) \
        $(( (0x${a:4:2} * q + 0x${b:4:2} * p) / 100 ))
}

# --- fix up a pywal palette ------------------------------------------------
# Rewrites ~/.cache/wal/colors.sh in place. Safe to run repeatedly: the
# marker file records the last image so a palette is only adjusted once.

fixup_wal() {
    [[ -f $WALDIR/colors.sh ]] || return 0

    local stamp="$WALDIR/.themed"
    local img
    img=$(cat "$WALDIR/wal" 2>/dev/null)
    [[ -f $stamp && $(cat "$stamp") == "$img" ]] && return 0

    # shellcheck source=/dev/null
    . "$WALDIR/colors.sh"

    # Tint the near-black background toward an accent from the image.
    if (( TINT_PERCENT > 0 )); then
        local newbg
        newbg=$(blend "$background" "$color4" "$TINT_PERCENT")
        sed -i "s|^background=.*|background='$newbg'|" "$WALDIR/colors.sh"
    fi

    # Replace an unreadably dark foreground.
    if (( MIN_FG_BRIGHTNESS > 0 )); then
        if (( $(brightness "$foreground") < MIN_FG_BRIGHTNESS )); then
            sed -i "s|^foreground=.*|foreground='$FALLBACK_FG'|" "$WALDIR/colors.sh"
            sed -i "s|^cursor=.*|cursor='$FALLBACK_FG'|" "$WALDIR/colors.sh"
        fi
    fi

    echo "$img" > "$stamp"

    # colors.sh is now out of step with the other files pywal rendered from
    # the original palette, so rebuild them from the corrected values.
    rebuild_from "$WALDIR"
}

# --- build derived files from a colors.sh ----------------------------------
# Writes foot / waybar / mako / sequences into $1, which must contain a
# colors.sh. Used for both the static dir and the corrected pywal cache,
# so both sides of the symlink are always interchangeable.

rebuild_from() {
    local d="$1"
    [[ -f $d/colors.sh ]] || return 1

    # shellcheck source=/dev/null
    . "$d/colors.sh"

    # foot wants hex with no leading '#'. [colors] is deprecated since 1.26.
    {
        echo "[colors-dark]"
        echo "background=${background#\#}"
        echo "foreground=${foreground#\#}"
        for i in {0..7}; do
            eval "c=\$color$i"
            echo "regular$i=${c#\#}"
        done
        for i in {8..15}; do
            eval "c=\$color$i"
            echo "bright$((i - 8))=${c#\#}"
        done
    } > "$d/foot-colors.ini"

    # GTK does not understand CSS custom properties, so use @define-color
    {
        echo "@define-color background $background;"
        echo "@define-color foreground $foreground;"
        echo "@define-color cursor $cursor;"
        for i in {0..15}; do
            eval "c=\$color$i"
            echo "@define-color color$i $c;"
        done
    } > "$d/colors-waybar.css"

    # mako colors, spliced into its config between markers
    {
        echo "background-color=$background"
        echo "text-color=$foreground"
        echo "border-color=$color4"
        echo "progress-color=over $color8"
        echo ""
        echo "[urgency=low]"
        echo "background-color=$background"
        echo "text-color=$color8"
        echo "border-color=$color8"
        echo ""
        echo "[urgency=normal]"
        echo "background-color=$background"
        echo "text-color=$foreground"
        echo "border-color=$color4"
        echo ""
        echo "[urgency=critical]"
        echo "background-color=$background"
        echo "text-color=#fb4934"
        echo "border-color=#fb4934"
    } > "$d/colors-mako"

    # OSC escape sequences for repainting live terminals
    {
        for i in {0..15}; do
            eval "c=\$color$i"
            printf '\033]4;%d;%s\033\\' "$i" "$c"
        done
        printf '\033]10;%s\033\\' "$foreground"
        printf '\033]11;%s\033\\' "$background"
        printf '\033]12;%s\033\\' "$cursor"
    } > "$d/sequences"
}

build_static() {
    [[ -f $STATICDIR/colors.sh ]] || write_static_palette
    rebuild_from "$STATICDIR"
}

# --- mako ------------------------------------------------------------------
# Rewrites the block between "# THEME-START" and "# THEME-END" in mako's
# config. Direct rewriting rather than include= so it works on every mako
# version. Adds the markers automatically on first run.

apply_mako() {
    [[ -f $MAKOCFG ]] || return 0
    [[ -f $LINK/colors-mako ]] || return 0

    if ! grep -q '^# THEME-START$' "$MAKOCFG"; then
        cp "$MAKOCFG" "$MAKOCFG.bak.$(date +%s)"
        sed -i -E 's/^(background-color=|text-color=|border-color=|progress-color=)/#\1/' "$MAKOCFG"
        sed -i '/^include=.*colors-mako/d' "$MAKOCFG"
        printf '\n# THEME-START\n# THEME-END\n' >> "$MAKOCFG"
    fi

    awk -v colors="$(cat "$LINK/colors-mako")" '
        /^# THEME-START$/ { print; print colors; skip = 1; next }
        /^# THEME-END$/   { skip = 0 }
        !skip
    ' "$MAKOCFG" > "$MAKOCFG.tmp" && mv "$MAKOCFG.tmp" "$MAKOCFG"

    if pgrep -x mako >/dev/null; then
        pkill -x mako
        sleep 0.2
    fi
    mako >/dev/null 2>&1 &
    disown
}

# --- waybar ----------------------------------------------------------------
# Full restart: GTK caches the resolved CSS import, and because ~/.cache/theme
# is a symlink the underlying path changes on toggle, so SIGUSR2 can reload
# and still render the old palette.

apply_waybar() {
    pgrep -x waybar >/dev/null || return 0
    pkill -x waybar
    sleep 0.3
    waybar >/dev/null 2>&1 &
    disown
}

# --- apply -----------------------------------------------------------------

apply() {
    local mode="$1" target

    if [[ $mode == wal ]]; then
        if [[ ! -f $WALDIR/colors.sh ]]; then
            echo "No pywal cache yet - run wallpaper-set.sh first" >&2
            return 1
        fi
        fixup_wal
        target="$WALDIR"
    else
        build_static
        target="$STATICDIR"
    fi

    # -n is required: without it ln nests the link inside the existing dir
    ln -sfn "$target" "$LINK"
    echo "$mode" > "$STATE"

    # Repaint every open terminal
    if [[ -f $LINK/sequences ]]; then
        for t in /dev/pts/[0-9]*; do
            [[ -w $t ]] && cat "$LINK/sequences" > "$t" &
        done
    fi

    # River takes colors at runtime
    if [[ -f $LINK/colors.sh ]]; then
        # shellcheck source=/dev/null
        . "$LINK/colors.sh"
        riverctl background-color       "0x${background#\#}"
        riverctl border-color-focused   "0x${color4#\#}"
        riverctl border-color-unfocused "0x${color8#\#}"
    fi

    apply_mako
    apply_waybar

    command -v notify-send >/dev/null 2>&1 && notify-send "Theme" "Switched to $mode"
}

# --- entry point -----------------------------------------------------------

current() {
    [[ -f $STATE ]] && cat "$STATE" || echo static
}

case "${1:-toggle}" in
    toggle)
        if [[ $(current) == wal ]]; then apply static; else apply wal; fi
        ;;
    wal|static)
        apply "$1"
        ;;
    reload)
        apply "$(current)"
        ;;
    status)
        echo "mode: $(current)"
        echo "link: $(readlink -f "$LINK" 2>/dev/null || echo '(none)')"
        echo "mako markers: $(grep -c '^# THEME-START$' "$MAKOCFG" 2>/dev/null || echo 0)"
        if [[ -f $LINK/colors.sh ]]; then
            # shellcheck source=/dev/null
            . "$LINK/colors.sh"
            echo "background: $background (brightness $(brightness "$background"))"
            echo "foreground: $foreground (brightness $(brightness "$foreground"))"
        fi
        ;;
    *)
        echo "usage: ${0##*/} {toggle|wal|static|reload|status}" >&2
        exit 1
        ;;
esac
