#!/bin/bash
# Double-click trên macOS để cài tự động pull code từ GitHub (không cần gõ lệnh sau này).
set -euo pipefail

REPO_URL="${MTVN_REPO_URL:-https://github.com/hoangtuan8911/mtvn-ft-pi-team.git}"
REPO_DIR="${MTVN_REPO_DIR:-$HOME/Documents/MTVN_FT_PI}"
BRANCH="${MTVN_BRANCH:-main}"
PLIST_ID="com.mtvn.ftpi.autosync"
PLIST_DST="$HOME/Library/LaunchAgents/${PLIST_ID}.plist"
LOG_DIR="$HOME/Library/Logs/MTVN_FT_PI"

clear
echo "============================================"
echo "  MTVN FT PI — Cài tự động backup từ GitHub"
echo "============================================"
echo
echo "Thư mục: $REPO_DIR"
echo "Nhánh:   $BRANCH"
echo "Lịch:    mỗi 1 giờ + ngay khi mở máy / đăng nhập"
echo

mkdir -p "$LOG_DIR" "$HOME/Library/LaunchAgents" "$(dirname "$REPO_DIR")"

if ! command -v git >/dev/null 2>&1; then
  echo "Chưa có git. Đang mở cài Xcode Command Line Tools..."
  xcode-select --install || true
  echo "Sau khi cài xong, double-click lại file này."
  read -r -p "Nhấn Enter để đóng..."
  exit 1
fi

if [[ ! -d "$REPO_DIR/.git" ]]; then
  echo "Đang clone repo lần đầu..."
  rm -rf "$REPO_DIR"
  git clone --branch "$BRANCH" "$REPO_URL" "$REPO_DIR"
else
  echo "Repo đã có — cập nhật lần đầu..."
  export MTVN_REPO_DIR="$REPO_DIR" MTVN_BRANCH="$BRANCH"
  bash "$REPO_DIR/tools/mac-auto-sync/mtvn-pull.sh" || {
    # Nếu clone cũ chưa có script (trước khi pull), fetch trực tiếp
    cd "$REPO_DIR"
    git fetch origin "$BRANCH"
    git checkout "$BRANCH"
    git reset --hard "origin/$BRANCH"
  }
fi

SCRIPT="$REPO_DIR/tools/mac-auto-sync/mtvn-pull.sh"
TEMPLATE="$REPO_DIR/tools/mac-auto-sync/com.mtvn.ftpi.autosync.plist"
if [[ ! -f "$SCRIPT" || ! -f "$TEMPLATE" ]]; then
  echo "ERROR: thiếu file sync trong repo. Kiểm tra đã pull main mới nhất chưa."
  read -r -p "Nhấn Enter để đóng..."
  exit 1
fi

chmod +x "$SCRIPT" "$REPO_DIR/tools/mac-auto-sync/Cai-dat-tu-dong-backup.command" 2>/dev/null || true

# Gỡ job cũ nếu có
launchctl bootout "gui/$(id -u)/$PLIST_ID" 2>/dev/null || launchctl unload "$PLIST_DST" 2>/dev/null || true

sed -e "s|REPO_DIR_PLACEHOLDER|$REPO_DIR|g" -e "s|HOME_PLACEHOLDER|$HOME|g" "$TEMPLATE" > "$PLIST_DST"
launchctl bootstrap "gui/$(id -u)" "$PLIST_DST" 2>/dev/null || launchctl load "$PLIST_DST"
launchctl kickstart -k "gui/$(id -u)/$PLIST_ID" 2>/dev/null || true

echo
echo "XONG. Mac mini sẽ tự kéo code từ GitHub về:"
echo "  $REPO_DIR"
echo
echo "Xem log:"
echo "  $LOG_DIR/auto-sync.log"
echo
echo "Gỡ cài đặt: double-click Go-tu-dong-backup.command (nếu có) hoặc:"
echo "  launchctl bootout gui/\$(id -u)/$PLIST_ID"
echo
read -r -p "Nhấn Enter để đóng..."
