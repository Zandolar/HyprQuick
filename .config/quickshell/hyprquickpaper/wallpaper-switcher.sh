#!/bin/bash
if pgrep -f "quickshell.*hyprquickpaper" | grep -v $$ > /dev/null; then
    exit 0
else
    quickshell -p /home/matt/.config/quickshell/hyprquickpaper/
fi