#!/bin/bash
# Refreshes Databricks OAuth token every 45 minutes via launchd.
# The token is set via launchctl setenv so NEW processes (OpenCode, etc.) pick it up.
# Uses the Databricks CLI's cached refresh token — no browser popups.
#
# NOTE: launchctl setenv only affects newly spawned processes.
# Long-running apps (like OpenCode) need a restart to pick up the new token.
# Databricks access tokens expire after ~1 hour.

set -euo pipefail

TOKEN=$(/opt/homebrew/bin/databricks auth token --profile ordermentum 2>/dev/null \
    | /usr/bin/python3 -c "import sys,json; print(json.load(sys.stdin)['access_token'])" 2>/dev/null)

if [[ -n "$TOKEN" ]]; then
    launchctl setenv DATABRICKS_TOKEN "$TOKEN"
    # Also write to a file so scripts can source a fresh token without launchctl
    echo "$TOKEN" > "$HOME/.cache/databricks-token"
    chmod 600 "$HOME/.cache/databricks-token"
    echo "$(date '+%Y-%m-%d %H:%M:%S') Token refreshed"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') Failed to refresh token" >&2
    exit 1
fi
