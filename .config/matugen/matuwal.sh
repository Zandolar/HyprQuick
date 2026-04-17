#!/bin/bash
IMAGE="$1"

# Extract several dominant colors from the image using imagemagick
COLORS=$(magick "$IMAGE" -resize 100x100 -colors 16 -format "%c" histogram:info:- \
  | grep -oP '#[0-9a-fA-F]{6}' | head -8)

# Pick one at random
COLOR=$(echo "$COLORS" | shuf -n 1)

SCHEMES=("scheme-fidelity" "scheme-content" "scheme-tonal-spot")
SCHEME=${SCHEMES[$RANDOM % ${#SCHEMES[@]}]}

# Randomise lightness-dark between -1.0 and 0.0
LIGHTNESS=$(awk -v seed=$RANDOM 'BEGIN { srand(seed); printf "%.2f", -(rand() * 0.2) }')
 
echo "Using color: $COLOR with scheme: $SCHEME and lightness: $LIGHTNESS" >> /tmp/matuwal.log
 
matugen --mode dark --type "$SCHEME" --lightness-dark "0.1" color hex "$COLOR"


