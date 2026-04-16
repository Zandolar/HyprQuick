#!/bin/bash
swww img $1 -t grow --transition-duration 1
ln -sf "$1" ~/.cache/.current_wallpaper
bash /home/matt/.config/waypaper/matuwal.sh "$1"


