#!/bin/bash
# Auto-pull latest code from GitHub into the local clone.
set -euo pipefail

REPO_DIR="${MTVN_REPO_DIR:-$HOME/Documents/MTVN_FT_PI}"
LOG_DIR="${MTVN_SYNC_LOG_DIR:-$HOME/Library/Logs/MTVN_FT_PI}"
BRANCH="${MTVN_BRANCH:-main}"
REMOTE="${MTVN_REMOTE:-origin}"

mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/auto-sync.log"
ts() { date '+%Y-%m-%d %H:%M:%S'; }

{
  echo "===== $(ts) start ====="
  if [[ ! -d "$REPO_DIR/.git" ]]; then
    echo "ERROR: chưa có git repo tại: $REPO_DIR"
    echo "Chạy file Cai-dat-tu-dong-backup.command một lần để clone."
    exit 1
  fi
  cd "$REPO_DIR"
  # Discard only tracked local edits so pull luôn lấy bản GitHub (backup code).
  # Không đụng file untracked.
  git fetch "$REMOTE" "$BRANCH"
  git checkout "$BRANCH"
  git reset --hard "$REMOTE/$BRANCH"
  echo "OK: $(git rev-parse --short HEAD) on $BRANCH"
  echo "===== $(ts) done ====="
} >>"$LOG_FILE" 2>&1
