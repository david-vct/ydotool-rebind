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

# Install the wrapper and translator
echo "Installing ydotool wrapper..."
cp "$SCRIPT_DIR/src/ydotool-wrapper.sh"  /usr/bin/ydotool-wrapper.sh
cp "$SCRIPT_DIR/src/ydotool-translate.sh"  /usr/bin/ydotool-translate.sh
ln -sf /usr/bin/ydotool-wrapper.sh /usr/bin/ydotool
chmod +x /usr/bin/ydotool-wrapper.sh
chmod +x /usr/bin/ydotool-translate.sh

# Install layouts
echo "Installing keyboard layouts..."
mkdir -p /etc/ydotool-rebind/layouts
cp "$SCRIPT_DIR"/layouts/*.sh /etc/ydotool-rebind/layouts/
chmod +r /etc/ydotool-rebind/layouts/*.sh

# Create default config if it doesn't exist
if [ ! -f /etc/ydotool-rebind/config ]; then
    echo "Creating default config (LAYOUT=fr)..."
    echo "LAYOUT=fr" > /etc/ydotool-rebind/config
else
    echo "Config already exists, keeping current settings"
fi

echo ""
echo "Installation successful!"
echo ""
echo "Configuration: /etc/ydotool-rebind/config"
echo "Available layouts: $(ls /etc/ydotool-rebind/layouts/ | sed 's/\.sh//g' | tr '\n' ' ')"
echo ""
echo "Next steps:"
echo "  1. Edit /etc/ydotool-rebind/config to set your layout (LAYOUT=fr|de|be|it)"
echo "  2. Or set YDOTOOL_LAYOUT=xx environment variable"
echo "  3. Test with: ydotool type \"Hello\""
echo "  4. Uninstall with: sudo ./uninstall.sh"
echo ""
