#!/bin/bash

# Wrapper for ydotool that translates AZERTY to QWERTY for 'type' command
# This allows using ydotool with French AZERTY keyboards

# Find the real ydotool (renamed to ydotool-real)
REAL_YDOTOOL="/usr/bin/ydotool-real"
# Resolve the real path of this script (follows symlinks)
SCRIPT_REAL_PATH="$(readlink -f "$0")"
TRANSLATOR="$(dirname "$SCRIPT_REAL_PATH")/ydotool-translate.sh"

# Check if translator exists
if [ ! -f "$TRANSLATOR" ]; then
    echo "Error: translator not found at $TRANSLATOR" >&2
    exit 1
fi

# Check if real ydotool exists
if [ ! -f "$REAL_YDOTOOL" ]; then
    echo "Error: original ydotool not found at $REAL_YDOTOOL" >&2
    exit 1
fi

# Intercept 'type' command and translate AZERTY to QWERTY
if [ "$1" = "type" ]; then
    # Remove 'type' from arguments
    shift
    # Translate and execute with real ydotool
    "$TRANSLATOR" "$@"
else
    # Pass all other commands directly to real ydotool
    "$REAL_YDOTOOL" "$@"
fi
