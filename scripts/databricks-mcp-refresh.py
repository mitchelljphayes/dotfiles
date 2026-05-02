#!/usr/bin/python3
"""Inject Databricks access token into OpenCode's mcp-auth.json.

Uses the token already maintained by databricks-token-refresh.sh (via the
Databricks CLI). This avoids maintaining a separate OAuth session which
conflicts with the CLI's session (Databricks revokes old refresh tokens
when a new auth grant is issued).

Run via launchd every 45 minutes (access tokens expire after 60 min).
"""

import json
import os
import sys
import time

AUTH_FILE = os.path.expanduser("~/.local/share/opencode/mcp-auth.json")
TOKEN_CACHE = os.path.expanduser("~/.cache/databricks-token")

# MCP server entries in mcp-auth.json that need Databricks token injection
SERVERS = ["databricks-sql", "databricks-uc-functions"]

# Skip update if token has more than this many seconds remaining
REFRESH_THRESHOLD = 900  # 15 minutes

# Databricks access tokens last ~60 minutes
TOKEN_LIFETIME = 3600


def log(msg):
    print(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] {msg}")


def get_cli_token():
    """Read the access token cached by databricks-token-refresh.sh."""
    if not os.path.exists(TOKEN_CACHE):
        return None

    # Check staleness — if the cache file is older than 70 min, it's stale
    age = time.time() - os.path.getmtime(TOKEN_CACHE)
    if age > 4200:  # 70 minutes
        log(f"  Token cache is stale ({age / 60:.0f} min old)")
        return None

    with open(TOKEN_CACHE) as f:
        token = f.read().strip()

    return token if token else None


def update_server(server_name, data, token):
    """Update the access token for one MCP server entry.

    Mutates ``data[server_name]`` in place. Returns True if tokens were updated.
    """
    entry = data.get(server_name)
    if not entry:
        # Create a minimal entry if it doesn't exist
        data[server_name] = {"tokens": {}}
        entry = data[server_name]

    if "tokens" not in entry:
        entry["tokens"] = {}

    # Don't update tokens that are still fresh
    expires_at = entry["tokens"].get("expiresAt", 0)
    remaining = expires_at - time.time()
    if remaining > REFRESH_THRESHOLD:
        current_token = entry["tokens"].get("accessToken", "")
        # Still update if the actual token value differs (CLI got a new one)
        if current_token == token:
            log(f"  {server_name}: still valid ({remaining / 60:.0f} min left)")
            return False

    # Inject the CLI token — no refresh token needed since the CLI manages that
    entry["tokens"]["accessToken"] = token
    entry["tokens"]["expiresAt"] = time.time() + TOKEN_LIFETIME
    # Remove stale refresh token to avoid confusion
    entry["tokens"].pop("refreshToken", None)

    expires_min = TOKEN_LIFETIME / 60
    log(f"  {server_name}: updated (expires in {expires_min:.0f} min)")
    return True


def main():
    token = get_cli_token()
    if not token:
        log("No valid token from CLI — is databricks-token-refresh running?")
        sys.exit(1)

    if not os.path.exists(AUTH_FILE):
        log(f"Auth file not found: {AUTH_FILE} — creating it")
        data = {}
    else:
        with open(AUTH_FILE) as f:
            data = json.load(f)

    updated = False
    for server in SERVERS:
        if update_server(server, data, token):
            updated = True

    if updated:
        # Write atomically via temp file
        tmp = AUTH_FILE + ".tmp"
        os.makedirs(os.path.dirname(AUTH_FILE), exist_ok=True)
        with open(tmp, "w") as f:
            json.dump(data, f, indent=4)
        os.replace(tmp, AUTH_FILE)
        log(f"  Wrote {AUTH_FILE}")

    log("Done")


if __name__ == "__main__":
    main()
