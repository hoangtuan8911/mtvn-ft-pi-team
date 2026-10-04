#!/bin/bash
# Double-click để gỡ tự động sync.
set -euo pipefail
PLIST_ID="com.mtvn.ftpi.autosync"
PLIST_DST="$HOME/Library/LaunchAgents/${PLIST_ID}.plist"
launchctl bootout "gui/$(id -u)/$PLIST_ID" 2>/dev/null || launchctl unload "$PLIST_DST" 2>/dev/null || true
rm -f "$PLIST_DST"
echo "Đã gỡ tự động backup GitHub."
read -r -p "Nhấn Enter để đóng..."
