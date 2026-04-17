#!/bin/bash
# ~/.config/matugen/scripts/reload-gtk.sh

# Reload gsettings theme
gsettings set org.gnome.desktop.interface color-scheme ""
gsettings set org.gnome.desktop.interface color-scheme prefer-dark

# Short process names (under 15 chars) - use pgrep -x
RELAUNCH_SHORT=(
)

# Long process names (over 15 chars) - use pgrep -f
RELAUNCH_LONG=(
)

# Short process names (under 15 chars) - use pgrep -x
KILL_ONLY_SHORT=(
    blueman-manager
    nwg-look
)

# Long process names (over 15 chars) - use pgrep -f
KILL_ONLY_LONG=(
    nm-connection-editor
)

for app in "${RELAUNCH_SHORT[@]}"; do
    if pgrep -x "$app" > /dev/null; then
        pkill -x "$app"
        sleep 0.5
        hyprctl dispatch exec "[silent] $app"
    fi
done

for app in "${RELAUNCH_LONG[@]}"; do
    if pgrep -f "$app" > /dev/null; then
        pkill -f "$app"
        sleep 0.5
        hyprctl dispatch exec "[silent] $app"
    fi
done

for app in "${KILL_ONLY_SHORT[@]}"; do
    if pgrep -x "$app" > /dev/null; then
        pkill -x "$app"
    fi
done

for app in "${KILL_ONLY_LONG[@]}"; do
    if pgrep -f "$app" > /dev/null; then
        pkill -f "$app"
    fi
done

sleep 3

# Restart portal services for file picker theme update
systemctl --user restart xdg-desktop-portal-gtk xdg-desktop-portal