#!/bin/bash

# Installation script for ydotool-rebind

set -e

echo "Installing ydotool-rebind..."

# Check if running as root
if [ "$EUID" -ne 0 ]; then
   echo "This installation must be run with sudo"
   exit 1
fi

# Check if ydotool is installed
if ! command -v ydotool &> /dev/null; then
    echo "ydotool is not installed. Please install ydotool first"
    exit 1
fi

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if ydotool is already wrapped
if [ -f /usr/bin/ydotool-real ]; then
    echo "ydotool appears to be already wrapped"
else
    echo "Backing up real ydotool..."
    mv /usr/bin/ydotool /usr/bin/ydotool-real
fi

# Install the wrapper
echo "Installing ydotool wrapper..."
ln -sf "$SCRIPT_DIR/src/ydotool-wrapper.sh" /usr/bin/ydotool
chmod +x "$SCRIPT_DIR/src/ydotool-wrapper.sh"

# Make the translator executable
echo "Setting up AZERTY to QWERTY translator..."
chmod +x "$SCRIPT_DIR/src/ydotool-translate.sh"

echo ""
echo "✅ Installation successful!"
echo ""
echo "Next steps:"
echo "  1. Test with: ydotool type \"Hello\""
echo "  2. Uninstall with: sudo ./uninstall.sh"
echo ""
