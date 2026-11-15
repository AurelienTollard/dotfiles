#!/usr/bin/env bash
# Usage: toggle-app.sh <app-id regex (case-insensitive)> <command...>
# Hide (close) the app if focused, focus it if open, otherwise launch it.
APP_RE=$1; shift

focused_app=$(niri msg focused-window 2>/dev/null | awk -F'"' '/App ID:/ {print $2; exit}')
if [[ ${focused_app,,} =~ ${APP_RE,,} ]]; then
    niri msg action close-window
    exit 0
fi

win_id=$(niri msg windows | RE="${APP_RE,,}" awk -F'"' '
    /^Window ID/ { split($0, a, /[ :]+/); id = a[3] }
    /App ID:/    { if (tolower($2) ~ ENVIRON["RE"]) { print id; exit } }')

if [[ -n $win_id ]]; then
    niri msg action focus-window --id "$win_id"
else
    "$@" &>/dev/null & disown
fi
