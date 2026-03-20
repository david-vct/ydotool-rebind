#!/bin/bash

# Wrapper for ydotool that translates AZERTY to QWERTY for 'type' command
# This allows using ydotool with French AZERTY keyboards

PROJECT_NAME="ydotool-rebind"
SYSTEM_YDOTOOL="/usr/bin/ydotool"
TRANSLATOR="/usr/local/lib/$PROJECT_NAME/ydotool-translate.sh"

# Check if translator exists
if [ ! -f "$TRANSLATOR" ]; then
    echo "Error: translator not found at $TRANSLATOR" >&2
    exit 1
fi

# Check if real ydotool exists
if [ ! -x "$SYSTEM_YDOTOOL" ]; then
    echo "Error: ydotool not found at $SYSTEM_YDOTOOL" >&2
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
    "$SYSTEM_YDOTOOL" "$@"
fi
