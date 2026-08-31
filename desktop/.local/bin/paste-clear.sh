#!/usr/bin/env bash

# Check if ydotool and wl-paste are installed
if ! command -v ydotool &> /dev/null; then
  echo "ydotool is not installed."
  exit 1
fi

if ! command -v wl-paste &> /dev/null; then
  echo "wl-paste is not installed."
  exit 1
fi

sleep 0.5

# Extract only plain text
CLIP_TEXT=$(wl-paste --type text/plain 2>/dev/null)

# Exit if nothing is copied
if [ -z "$CLIP_TEXT" ]; then
  exit 0
fi

# Type the text and then wipe the clipboard
ydotool type "$CLIP_TEXT"
wl-copy --clear
