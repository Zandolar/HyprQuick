#!/bin/bash
THEME="$HOME/.config/kitty/themes/Matugen.conf"

# Persist for new windows
cp "$THEME" "$HOME/.config/kitty/current-theme.conf"
cp "$THEME" "$HOME/.config/kitty/dark-theme.auto.conf"
cp "$THEME" "$HOME/.config/kitty/light-theme.auto.conf"
cp "$THEME" "$HOME/.config/kitty/no-preference-theme.auto.conf"

# Apply to all existing kitty windows via each socket
for SOCKET in /tmp/kitty-socket-*; do
    kitty @ --to unix://$SOCKET set-colors --all --configured "$THEME"
done