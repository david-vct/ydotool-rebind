#!/bin/bash

# Uninstallation script for ydotool-rebind

set -e

PROJECT_NAME="ydotool-rebind"
PREFIX="/usr/local"
BIN_DIR="$PREFIX/bin"
LIB_DIR="$PREFIX/lib/$PROJECT_NAME"
LIB_WRAPPER_PATH="$LIB_DIR/ydotool-wrapper.sh"
WRAPPER_PATH="$BIN_DIR/ydotool"
TRANSLATOR_PATH="$LIB_DIR/ydotool-translate.sh"
SYSTEM_YDOTOOL="/usr/bin/ydotool"
LEGACY_REAL_YDOTOOL="/usr/bin/ydotool-real"

echo "Uninstalling ydotool-rebind..."

# Check if running as root
if [ "$EUID" -ne 0 ]; then
   echo "This uninstallation must be run with sudo"
   exit 1
fi

# Remove current installation under /usr/local
if [ -L "$WRAPPER_PATH" ] || [ -f "$WRAPPER_PATH" ] || [ -f "$LIB_WRAPPER_PATH" ] || [ -f "$TRANSLATOR_PATH" ]; then
    echo "Removing files from $PREFIX..."
    rm -f "$WRAPPER_PATH"
    rm -f "$LIB_WRAPPER_PATH"
    rm -f "$TRANSLATOR_PATH"
    rmdir "$LIB_DIR" 2>/dev/null || true
fi

# Restore the original ydotool from the legacy installation layout
if [ -f "$LEGACY_REAL_YDOTOOL" ]; then
    echo "Restoring legacy system ydotool in /usr/bin..."
    rm -f "$SYSTEM_YDOTOOL"
    rm -f /usr/bin/ydotool-wrapper.sh
    rm -f /usr/bin/ydotool-translate.sh
    mv "$LEGACY_REAL_YDOTOOL" "$SYSTEM_YDOTOOL"
fi

echo "✅ Uninstallation successful!"