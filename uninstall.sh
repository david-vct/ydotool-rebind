#!/bin/bash

# Uninstallation script for ydotool-rebind

set -e

echo "Uninstalling ydotool-rebind..."

# Check if running as root
if [ "$EUID" -ne 0 ]; then
   echo "This uninstallation must be run with sudo"
   exit 1
fi

# Restore the original ydotool
if [ -f /usr/bin/ydotool-real ]; then
    echo "Restoring real ydotool..."
    rm -f /usr/bin/ydotool
    mv /usr/bin/ydotool-real /usr/bin/ydotool
else
    echo "/usr/bin/ydotool-real not found"
fi

echo "✅ Uninstallation successful!"