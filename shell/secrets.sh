#!/usr/bin/env bash
# 1Password secrets injection for shell environment
# Caches secrets at session level - auth once per login session
#
# Supports:
#   - macOS: launchctl setenv (inherited by all GUI processes)
#   - Linux: systemd user environment + cache file
#
# Usage: source this file early in shell startup (.zshrc, .bashrc)
#
# To add new secrets:
#   Add an entry to the SECRETS array below:
#   "ENV_VAR_NAME:op://vault/item/field"

# Configuration
OP_ACCOUNT="ordermentum.1password.com"
SECRETS_CACHE="${XDG_RUNTIME_DIR:-$HOME/.cache}/secrets.env"

# Define all secrets: ENV_VAR_NAME:op_reference
SECRETS=(
    "LINEAR_API_KEY:op://Employee/Ordermentum Linear API key/credential"
    "OMNI_API_KEY:op://Employee/Omni Analytics API Key/credential"
    "FIGMA_API_KEY:op://Employee/Figma API Key/credential"
)

# Skip if secrets already in environment
[[ -n "${LINEAR_API_KEY:-}" ]] && return 0

# Find op binary
_find_op() {
    local paths=("/opt/homebrew/bin/op" "/usr/local/bin/op" "/usr/bin/op")
    for p in "${paths[@]}"; do
        [[ -x "$p" ]] && echo "$p" && return 0
    done
    command -v op 2>/dev/null
}
OP_BIN=$(_find_op)

# Platform detection
_is_macos() { [[ "$OSTYPE" == darwin* ]]; }
_is_linux() { [[ "$OSTYPE" == linux* ]]; }

# Cache operations (platform-specific)
_cache_set() {
    local key="$1" val="$2"
    if _is_macos; then
        launchctl setenv "$key" "$val"
    elif _is_linux; then
        # Try systemd user environment first
        if command -v systemctl &>/dev/null && [[ -n "$DBUS_SESSION_BUS_ADDRESS" ]]; then
            systemctl --user set-environment "$key=$val" 2>/dev/null
        fi
        # Also write to cache file for non-systemd sessions
        mkdir -p "$(dirname "$SECRETS_CACHE")"
        grep -v "^$key=" "$SECRETS_CACHE" 2>/dev/null > "$SECRETS_CACHE.tmp" || true
        echo "$key=$val" >> "$SECRETS_CACHE.tmp"
        mv "$SECRETS_CACHE.tmp" "$SECRETS_CACHE"
        chmod 600 "$SECRETS_CACHE"
    fi
}

_cache_get() {
    local key="$1"
    if _is_macos; then
        launchctl getenv "$key" 2>/dev/null
    elif _is_linux; then
        # Try systemd first
        if command -v systemctl &>/dev/null && [[ -n "$DBUS_SESSION_BUS_ADDRESS" ]]; then
            systemctl --user show-environment 2>/dev/null | grep "^$key=" | cut -d= -f2-
            return
        fi
        # Fall back to cache file
        [[ -f "$SECRETS_CACHE" ]] && grep "^$key=" "$SECRETS_CACHE" 2>/dev/null | cut -d= -f2-
    fi
}

# Try to load from cache first (no 1Password auth needed)
_secrets_from_cache() {
    local entry key val all_found=true
    for entry in "${SECRETS[@]}"; do
        key="${entry%%:*}"
        val=$(_cache_get "$key")
        if [[ -n "$val" ]]; then
            export "$key=$val"
        else
            all_found=false
        fi
    done
    $all_found
}

# Fetch from 1Password and cache
_secrets_from_1password() {
    [[ -z "$OP_BIN" || ! -x "$OP_BIN" ]] && return 1

    local entry key ref val
    for entry in "${SECRETS[@]}"; do
        key="${entry%%:*}"
        ref="${entry#*:}"
        val=$("$OP_BIN" read "$ref" --account="$OP_ACCOUNT" 2>/dev/null) || continue
        _cache_set "$key" "$val"
        export "$key=$val"
    done
}

# Main: try cache first, fall back to 1Password
_secrets_from_cache || _secrets_from_1password
