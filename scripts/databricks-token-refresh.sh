#!/bin/bash
# Refreshes Databricks OAuth token every 45 minutes via launchd.
# The token is set via launchctl setenv so GUI apps (OpenCode, etc.) pick it up.
# Uses the Databricks CLI's cached refresh token — no browser popups.

set -euo pipefail

TOKEN=$(/opt/homebrew/bin/databricks auth token --profile ordermentum 2>/dev/null \
    | /usr/bin/python3 -c "import sys,json; print(json.load(sys.stdin)['access_token'])" 2>/dev/null)

if [[ -n "$TOKEN" ]]; then
    launchctl setenv DATABRICKS_TOKEN "$TOKEN"
    echo "$(date '+%Y-%m-%d %H:%M:%S') Token refreshed"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') Failed to refresh token" >&2
    exit 1
fi
