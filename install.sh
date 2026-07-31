#!/bin/bash

set -euo pipefail

PROJECT_NAME="ydotool-rebind"
PREFIX="/usr/local"
BIN_DIR="$PREFIX/bin"
LIB_DIR="$PREFIX/lib/$PROJECT_NAME"
SHARE_DIR="$PREFIX/share/$PROJECT_NAME"
LAYOUT_DIR="$SHARE_DIR/layouts"
CONFIG_DIR="$PREFIX/etc"

WRAPPER_SOURCE="bin/ydotool-rebind.sh"
LIB_SOURCE_DIR="lib"
LAYOUT_SOURCE_DIR="share/layouts"
CONFIG_SOURCE="config/$PROJECT_NAME.conf"

WRAPPER_TARGET="$BIN_DIR/ydotool"
CONFIG_TARGET="$CONFIG_DIR/$PROJECT_NAME.conf"

SYSTEM_YDOTOOL="/usr/bin/ydotool"
LEGACY_REAL_YDOTOOL="/usr/bin/ydotool-real"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing $PROJECT_NAME..."

if [[ "$EUID" -ne 0 ]]; then
    echo "This installation must be run with sudo" >&2
    exit 1
fi

if [[ ! -x "$SYSTEM_YDOTOOL" && ! -x "$LEGACY_REAL_YDOTOOL" ]]; then
    echo "ydotool is not installed in /usr/bin. Please install ydotool first" >&2
    exit 1
fi

if [[ -f "$LEGACY_REAL_YDOTOOL" ]]; then
    echo "Legacy installation detected, restoring /usr/bin/ydotool..."
    rm -f /usr/bin/ydotool /usr/bin/ydotool-wrapper.sh /usr/bin/ydotool-translate.sh
    mv "$LEGACY_REAL_YDOTOOL" "$SYSTEM_YDOTOOL"
fi

echo "Installing executable, library, and shared layouts under $PREFIX..."
install -d "$BIN_DIR" "$LIB_DIR" "$LAYOUT_DIR" "$CONFIG_DIR"
install -m 755 "$SCRIPT_DIR/$WRAPPER_SOURCE" "$WRAPPER_TARGET"
install -m 644 "$SCRIPT_DIR/$LIB_SOURCE_DIR/utils.sh" "$LIB_DIR/utils.sh"
install -m 644 "$SCRIPT_DIR/$LIB_SOURCE_DIR/layout.sh" "$LIB_DIR/layout.sh"
install -m 755 "$SCRIPT_DIR/$LIB_SOURCE_DIR/translate.sh" "$LIB_DIR/translate.sh"
install -m 644 "$SCRIPT_DIR/$LAYOUT_SOURCE_DIR"/*.sh "$LAYOUT_DIR/"

if [[ -f "$CONFIG_TARGET" ]]; then
    echo "Config already exists, keeping current settings"
else
    echo "Installing default config from $CONFIG_SOURCE..."
    install -m 644 "$SCRIPT_DIR/$CONFIG_SOURCE" "$CONFIG_TARGET"
fi

echo
echo "Installation successful!"
echo
echo "Configuration: $CONFIG_TARGET"
echo "Available layouts: $(find "$LAYOUT_DIR" -maxdepth 1 -type f -name '*.sh' -printf '%f\n' | sed 's/\.sh$//' | sort | tr '\n' ' ')"
echo
echo "Next steps:"
echo "  1. Edit $CONFIG_TARGET to set your layout (LAYOUT=fr|de|be|it|es|ch_fr|us)"
echo "  2. Or set YDOTOOL_LAYOUT=xx as an environment variable"
echo "  3. Test with: ydotool type \"Hello\""
echo "  4. Uninstall with: sudo ./uninstall.sh"
echo
echo "Installed files:"
echo "  - $WRAPPER_TARGET"
echo "  - $LIB_DIR/utils.sh"
echo "  - $LIB_DIR/layout.sh"
echo "  - $LIB_DIR/translate.sh"
echo "  - $LAYOUT_DIR/*.sh"
echo "  - $CONFIG_TARGET"
