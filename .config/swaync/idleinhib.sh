#!/bin/bash
if pgrep -x hypridle > /dev/null; then
    pkill hypridle
    notify-send -u low "Hypridle" "Idle inhibited 󱫭" -t 2000
else
    hypridle &
    notify-send -u low "Hypridle" "Idle active 󰒲" -t 2000
fi