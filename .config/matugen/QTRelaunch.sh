#!/bin/bash
# ~/.config/matugen/scripts/reload-qt.sh

# Apps to kill and relaunch
RELAUNCH_APPS=(
    krusader
    chromium
    pcmanfm-qt
)

# Apps to just kill (scratchpad/other launcher will reopen them)
KILL_ONLY_APPS=(
    pavucontrol-qt
    qt5ct
    qt6ct
)

for app in "${RELAUNCH_APPS[@]}"; do
    if pgrep -x "$app" > /dev/null; then
        pkill -x "$app"
        sleep 0.5
        hyprctl dispatch exec "[silent] $app"
    fi
done

for app in "${KILL_ONLY_APPS[@]}"; do
    if pgrep -x "$app" > /dev/null; then
        pkill -x "$app"
    fi
done