#!/bin/bash
# Sync Claude Code OAuth token to OpenCode
# Reads the token from macOS Keychain and writes it to OpenCode's auth.json

set -euo pipefail

FORCE=false
if [ "${1:-}" = "--force" ] || [ "${1:-}" = "-f" ]; then
  FORCE=true
fi

AUTH_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/opencode"
AUTH_FILE="$AUTH_DIR/auth.json"

if [ "$FORCE" = false ] && [ -f "$AUTH_FILE" ]; then
  EXISTING_EXPIRES=$(jq -r '.anthropic.expires // 0' "$AUTH_FILE")
  NOW_MS=$(($(date +%s) * 1000))
  REMAINING=$((EXISTING_EXPIRES - NOW_MS))
  if [ "$REMAINING" -gt 300000 ]; then
    echo "Token still valid for $((REMAINING / 60000)) minutes. Skipping refresh. (use --force to override)"
    exit 0
  fi
fi

# Force a token refresh by making a trivial Claude Code request
claude -p . --model claude-haiku-4-5 > /dev/null 2>&1

# Read Claude Code credentials from macOS Keychain
TOKEN_JSON=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null || true)
if [ -z "$TOKEN_JSON" ]; then
  echo "Error: No Claude Code credentials found in Keychain."
  echo "Make sure Claude Code is installed and you are logged in (run: claude auth status)"
  exit 1
fi

# Extract OAuth tokens
ACCESS=$(echo "$TOKEN_JSON" | jq -r '.claudeAiOauth.accessToken // empty')
REFRESH=$(echo "$TOKEN_JSON" | jq -r '.claudeAiOauth.refreshToken // empty')
EXPIRES=$(echo "$TOKEN_JSON" | jq -r '.claudeAiOauth.expiresAt // empty')

if [ -z "$ACCESS" ] || [ -z "$REFRESH" ] || [ -z "$EXPIRES" ]; then
  echo "Error: Could not extract tokens from credentials."
  exit 1
fi

# Write to OpenCode auth.json, merging with existing data to preserve other providers
mkdir -p "$AUTH_DIR"

EXISTING='{}'
if [ -f "$AUTH_FILE" ]; then
  EXISTING=$(jq '.' "$AUTH_FILE" 2>/dev/null || echo '{}')
fi

echo "$EXISTING" | jq \
  --arg access "$ACCESS" \
  --arg refresh "$REFRESH" \
  --argjson expires "$EXPIRES" \
  '.anthropic = {type: "oauth", access: $access, refresh: $refresh, expires: $expires}' \
  > "$AUTH_FILE"

echo "Done! Anthropic token synced to OpenCode."
echo "Expires: $(date -r $((EXPIRES / 1000)) 2>/dev/null || echo "timestamp $EXPIRES")"
