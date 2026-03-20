#!/bin/bash

# Installation script for ydotool-rebind

set -e

PROJECT_NAME="ydotool-rebind"
PREFIX="/usr/local"
BIN_DIR="$PREFIX/bin"
LIB_DIR="$PREFIX/lib/$PROJECT_NAME"
LIB_WRAPPER_PATH="$LIB_DIR/ydotool-wrapper.sh"
WRAPPER_PATH="$BIN_DIR/ydotool"
SYSTEM_YDOTOOL="/usr/bin/ydotool"
LEGACY_REAL_YDOTOOL="/usr/bin/ydotool-real"

echo "Installing ydotool-rebind..."

# Check if running as root
if [ "$EUID" -ne 0 ]; then
   echo "This installation must be run with sudo"
   exit 1
fi

# Check if ydotool is installed in the system path
if [ ! -x "$SYSTEM_YDOTOOL" ] && [ ! -x "$LEGACY_REAL_YDOTOOL" ]; then
    echo "ydotool is not installed in /usr/bin. Please install ydotool first"
    exit 1
fi

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Clean up legacy installation if present
if [ -f "$LEGACY_REAL_YDOTOOL" ]; then
    echo "Legacy installation detected, restoring system ydotool..."
    rm -f /usr/bin/ydotool
    rm -f /usr/bin/ydotool-wrapper.sh
    rm -f /usr/bin/ydotool-translate.sh
    mv "$LEGACY_REAL_YDOTOOL" "$SYSTEM_YDOTOOL"
fi

# Install the wrapper and internal helper scripts
echo "Installing ydotool wrapper into $LIB_DIR and linking it from $BIN_DIR..."
install -d "$BIN_DIR" "$LIB_DIR"
install -m 755 "$SCRIPT_DIR/src/ydotool-wrapper.sh" "$LIB_WRAPPER_PATH"
install -m 755 "$SCRIPT_DIR/src/ydotool-translate.sh" "$LIB_DIR/ydotool-translate.sh"
ln -sfn "$LIB_WRAPPER_PATH" "$WRAPPER_PATH"

echo "Setting up AZERTY to QWERTY translator..."

echo ""
echo "✅ Installation successful!"
echo ""
echo "Next steps:"
echo "  1. Test with: ydotool type \"Hello\""
echo "  2. Uninstall with: sudo ./uninstall.sh"
echo ""
echo "Installed files:"
echo "  - $WRAPPER_PATH -> $LIB_WRAPPER_PATH"
echo "  - $LIB_WRAPPER_PATH"
echo "  - $LIB_DIR/ydotool-translate.sh"
echo ""
