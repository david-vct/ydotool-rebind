#!/bin/bash

set -euo pipefail

PROJECT_NAME="ydotool-rebind"
PREFIX="/usr/local"
BIN_DIR="$PREFIX/bin"
LIB_DIR="$PREFIX/lib/$PROJECT_NAME"
SHARE_DIR="$PREFIX/share/$PROJECT_NAME"
CONFIG_PATH="$PREFIX/etc/$PROJECT_NAME.conf"

WRAPPER_PATH="$BIN_DIR/ydotool"
UTILS_PATH="$LIB_DIR/utils.sh"
LAYOUT_LIB_PATH="$LIB_DIR/layout.sh"
TRANSLATE_PATH="$LIB_DIR/translate.sh"
LAYOUT_DIR="$SHARE_DIR/layouts"

SYSTEM_YDOTOOL="/usr/bin/ydotool"
LEGACY_REAL_YDOTOOL="/usr/bin/ydotool-real"

echo "Uninstalling $PROJECT_NAME..."

if [[ "$EUID" -ne 0 ]]; then
    echo "This uninstallation must be run with sudo" >&2
    exit 1
fi

if [[ -e "$WRAPPER_PATH" || -e "$UTILS_PATH" || -e "$LAYOUT_LIB_PATH" || -e "$TRANSLATE_PATH" || -d "$SHARE_DIR" || -e "$CONFIG_PATH" ]]; then
    echo "Removing files from $PREFIX..."
    rm -f "$WRAPPER_PATH" "$UTILS_PATH" "$LAYOUT_LIB_PATH" "$TRANSLATE_PATH" "$CONFIG_PATH"
    rm -rf "$LAYOUT_DIR"
    rmdir "$LIB_DIR" 2>/dev/null || true
    rmdir "$SHARE_DIR" 2>/dev/null || true
fi

if [[ -f "$LEGACY_REAL_YDOTOOL" ]]; then
    echo "Restoring legacy system ydotool in /usr/bin..."
    rm -f "$SYSTEM_YDOTOOL" /usr/bin/ydotool-wrapper.sh /usr/bin/ydotool-translate.sh
    mv "$LEGACY_REAL_YDOTOOL" "$SYSTEM_YDOTOOL"
fi

echo "Uninstallation successful!"
