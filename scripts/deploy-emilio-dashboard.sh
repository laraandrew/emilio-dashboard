#!/usr/bin/env bash
set -euo pipefail

# Safe-ish atomic deploy helper for Raspberry Pi.
# Intended to be run with sudo from CI or manually.

REPO_URL="git@github.com:laraandrew/emilio-dashboard.git"
REPO_DIR="/var/lib/emilio/repos/emilio-dashboard"
RELEASES_DIR="/opt/emilio-dashboard/releases"
CURRENT_LINK="/opt/emilio-dashboard/current"
NGINX_SITE_FILE="/etc/nginx/sites-available/emilio-dashboard"
REF="${1:-origin/main}"
KEEP_RELEASES="${KEEP_RELEASES:-5}"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

mkdir -p "$RELEASES_DIR"

if [[ ! -d "$REPO_DIR/.git" ]]; then
  log "Cloning repo into $REPO_DIR"
  mkdir -p "$(dirname "$REPO_DIR")"
  git clone "$REPO_URL" "$REPO_DIR"
fi

log "Fetching latest refs"
git -C "$REPO_DIR" fetch --prune origin
SHA="$(git -C "$REPO_DIR" rev-parse "$REF")"
STAMP="$(date +%Y%m%d-%H%M%S)"
REL="$RELEASES_DIR/$STAMP-$SHA"

log "Creating release $REL"
mkdir -p "$REL"
git -C "$REPO_DIR" archive "$SHA" | tar -x -C "$REL"

[[ -f "$REL/index.html" ]] || { log "index.html missing in release"; exit 1; }

PREV=""
if [[ -L "$CURRENT_LINK" ]]; then
  PREV="$(readlink -f "$CURRENT_LINK")"
fi

log "Switching current symlink"
ln -sfn "$REL" "$CURRENT_LINK"

if [[ -f "$NGINX_SITE_FILE" ]] && ! grep -q "$CURRENT_LINK" "$NGINX_SITE_FILE"; then
  log "WARNING: nginx site file does not reference $CURRENT_LINK"
  log "Update nginx root to '$CURRENT_LINK' for atomic release switching."
fi

log "Testing and reloading nginx"
nginx -t
systemctl reload nginx

log "Health checks"
curl -fsS http://localhost >/dev/null

log "Pruning old releases (keep $KEEP_RELEASES)"
ls -1dt "$RELEASES_DIR"/* 2>/dev/null | tail -n +$((KEEP_RELEASES+1)) | xargs -r rm -rf

log "Deploy complete: $SHA"
