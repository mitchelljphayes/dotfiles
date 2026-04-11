#!/usr/bin/python3
"""Refresh Databricks MCP OAuth tokens in OpenCode's mcp-auth.json.

OpenCode can't auto-refresh Databricks tokens because Databricks serves
OAuth metadata at /oidc/.well-known/... instead of /.well-known/... which
the MCP SDK expects. This script calls the token endpoint directly using
the stored refresh tokens.

Run via launchd every 45 minutes (access tokens expire after 60 min).
"""

import json
import os
import sys
import time
import urllib.parse
import urllib.request

AUTH_FILE = os.path.expanduser("~/.local/share/opencode/mcp-auth.json")
TOKEN_ENDPOINT = "https://dbc-664c297c-acf0.cloud.databricks.com/oidc/v1/token"
CLIENT_ID = "99c262dc-0437-41c7-98c3-3086147cb73e"

# MCP server entries in mcp-auth.json that need Databricks token refresh
SERVERS = ["databricks-sql", "databricks-uc-functions"]

# Skip refresh if token has more than this many seconds remaining
REFRESH_THRESHOLD = 900  # 15 minutes


def log(msg):
    print(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] {msg}")


def refresh_server(server_name, data):
    """Refresh the OAuth token for one Databricks MCP server entry.

    Mutates ``data[server_name]`` in place. Returns True if tokens were updated.
    """
    entry = data.get(server_name)
    if not entry or not entry.get("tokens", {}).get("refreshToken"):
        log(f"  {server_name}: no refresh token — skipping")
        return False

    # Don't refresh tokens that are still fresh
    expires_at = entry["tokens"].get("expiresAt", 0)
    remaining = expires_at - time.time()
    if remaining > REFRESH_THRESHOLD:
        log(f"  {server_name}: still valid ({remaining / 60:.0f} min left)")
        return False

    refresh_token = entry["tokens"]["refreshToken"]

    params = urllib.parse.urlencode(
        {
            "grant_type": "refresh_token",
            "client_id": CLIENT_ID,
            "refresh_token": refresh_token,
        }
    ).encode()

    req = urllib.request.Request(TOKEN_ENDPOINT, data=params, method="POST")
    req.add_header("Content-Type", "application/x-www-form-urlencoded")

    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            result = json.loads(resp.read())
    except urllib.error.HTTPError as e:
        body = e.read().decode("utf-8", errors="replace")
        log(f"  {server_name}: HTTP {e.code} — {body}")
        return False
    except Exception as e:
        log(f"  {server_name}: request failed — {e}")
        return False

    if "error" in result:
        log(
            f"  {server_name}: {result['error']}: {result.get('error_description', '')}"
        )
        return False

    # Update tokens in place
    entry["tokens"]["accessToken"] = result["access_token"]
    entry["tokens"]["expiresAt"] = time.time() + result.get("expires_in", 3600)
    if "refresh_token" in result:
        entry["tokens"]["refreshToken"] = result["refresh_token"]
    if "scope" in result:
        entry["tokens"]["scope"] = result["scope"]

    expires_min = result.get("expires_in", 3600) / 60
    log(f"  {server_name}: refreshed (expires in {expires_min:.0f} min)")
    return True


def main():
    if not os.path.exists(AUTH_FILE):
        log(f"Auth file not found: {AUTH_FILE}")
        sys.exit(1)

    with open(AUTH_FILE) as f:
        data = json.load(f)

    updated = False
    for server in SERVERS:
        if refresh_server(server, data):
            updated = True

    if updated:
        # Write atomically via temp file to avoid corrupting mcp-auth.json
        tmp = AUTH_FILE + ".tmp"
        with open(tmp, "w") as f:
            json.dump(data, f, indent=4)
        os.replace(tmp, AUTH_FILE)
        log(f"  Wrote {AUTH_FILE}")

    log("Done")


if __name__ == "__main__":
    main()
