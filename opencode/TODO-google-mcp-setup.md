# Google Workspace MCP Setup - Multi-Workspace Configuration

## Overview

This setup enables **directory-scoped** Google Workspace and Linear MCPs, allowing different accounts/workspaces per project directory.

## How It Works

```
~/work/client-a/     -> Client A's Google + Linear workspace
~/work/client-b/     -> Client B's Google + Linear workspace  
~/personal/          -> Personal Google account, no Linear
```

**Key technologies:**
- **direnv**: Loads environment variables per-directory
- **opencode project configs**: Per-project `opencode.json` with MCP definitions
- **Separate credential directories**: Isolates OAuth tokens per workspace

---

## Prerequisites

### 1. direnv (installed)
```bash
brew install direnv
```

Shell hook added to `~/.dotfiles/zsh/plugins_after.zsh`

### 2. Google Cloud OAuth Credentials

For each workspace, you need separate OAuth credentials:

1. Go to https://console.cloud.google.com/
2. Create/select the appropriate project
3. Navigate to **APIs & Services > Credentials**
4. Click **Create Credentials > OAuth Client ID**
5. Choose **Desktop Application**
6. Note the **Client ID** and **Client Secret**

Enable required APIs for each project:
- [Calendar](https://console.cloud.google.com/flows/enableapi?apiid=calendar-json.googleapis.com)
- [Drive](https://console.cloud.google.com/flows/enableapi?apiid=drive.googleapis.com)
- [Gmail](https://console.cloud.google.com/flows/enableapi?apiid=gmail.googleapis.com)
- [Docs](https://console.cloud.google.com/flows/enableapi?apiid=docs.googleapis.com)
- [Sheets](https://console.cloud.google.com/flows/enableapi?apiid=sheets.googleapis.com)
- [Tasks](https://console.cloud.google.com/flows/enableapi?apiid=tasks.googleapis.com)

---

## Setup Per Workspace

### Step 1: Create 1Password Items

For each workspace, create a 1Password item:

**Item: `Google OAuth - Client A`**
- `client_id` → OAuth Client ID
- `client_secret` → OAuth Client Secret

**Item: `Google OAuth - Client B`**
- `client_id` → OAuth Client ID  
- `client_secret` → OAuth Client Secret

### Step 2: Create Directory Structure

```bash
# Create credential storage directories
mkdir -p ~/.workspace-mcp/client-a
mkdir -p ~/.workspace-mcp/client-b
mkdir -p ~/.workspace-mcp/personal
```

### Step 3: Create `.envrc` Files

**`~/work/client-a/.envrc`:**
```bash
# Client A - Google Workspace MCP credentials
# Uses 1Password secret references (resolved by `op run`)

export GOOGLE_OAUTH_CLIENT_ID="op://Work/Google OAuth - Client A/client_id"
export GOOGLE_OAUTH_CLIENT_SECRET="op://Work/Google OAuth - Client A/client_secret"
export GOOGLE_MCP_CREDENTIALS_DIR="$HOME/.workspace-mcp/client-a"
export OAUTHLIB_INSECURE_TRANSPORT=1

# Optional: Default user email for single-user mode
# export USER_GOOGLE_EMAIL="me@client-a.com"
```

**`~/work/client-b/.envrc`:**
```bash
# Client B - Google Workspace MCP credentials
export GOOGLE_OAUTH_CLIENT_ID="op://Work/Google OAuth - Client B/client_id"
export GOOGLE_OAUTH_CLIENT_SECRET="op://Work/Google OAuth - Client B/client_secret"
export GOOGLE_MCP_CREDENTIALS_DIR="$HOME/.workspace-mcp/client-b"
export OAUTHLIB_INSECURE_TRANSPORT=1
```

**`~/personal/.envrc`:**
```bash
# Personal Google account
export GOOGLE_OAUTH_CLIENT_ID="op://Personal/Google OAuth Personal/client_id"
export GOOGLE_OAUTH_CLIENT_SECRET="op://Personal/Google OAuth Personal/client_secret"
export GOOGLE_MCP_CREDENTIALS_DIR="$HOME/.workspace-mcp/personal"
export OAUTHLIB_INSECURE_TRANSPORT=1
```

### Step 4: Allow direnv

```bash
cd ~/work/client-a && direnv allow
cd ~/work/client-b && direnv allow
cd ~/personal && direnv allow
```

### Step 5: Create Per-Project `opencode.json`

**`~/work/client-a/opencode.json`:**
```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "google_workspace": {
      "type": "local",
      "command": ["uvx", "workspace-mcp", "--tool-tier", "core"],
      "environment": {
        "GOOGLE_OAUTH_CLIENT_ID": "{env:GOOGLE_OAUTH_CLIENT_ID}",
        "GOOGLE_OAUTH_CLIENT_SECRET": "{env:GOOGLE_OAUTH_CLIENT_SECRET}",
        "GOOGLE_MCP_CREDENTIALS_DIR": "{env:GOOGLE_MCP_CREDENTIALS_DIR}",
        "OAUTHLIB_INSECURE_TRANSPORT": "1"
      }
    },
    "linear": {
      "type": "remote",
      "url": "https://mcp.linear.app/mcp"
    }
  }
}
```

---

## Running opencode with 1Password

Since `.envrc` uses 1Password secret references, run opencode with `op run`:

```bash
cd ~/work/client-a
op run -- opencode
```

Or add an alias to `~/.dotfiles/shell/aliases.sh`:
```bash
alias oc='op run -- opencode'
```

---

## First-Time OAuth Flow

On first use in each directory:

1. Run `op run -- opencode` in the project directory
2. Use a Google Workspace tool (e.g., "list my calendar events")
3. Server returns an authorization URL
4. Open URL in browser, authorize with the correct Google account
5. Tokens are stored in the workspace-specific credential directory

---

## Linear Workspace Scoping

Linear's remote MCP uses OAuth per-session. For different Linear workspaces:

1. Run `opencode mcp auth linear` in each project directory
2. Authorize with the appropriate Linear account
3. Tokens are stored per opencode session

**Note:** Linear OAuth tokens are managed by opencode, stored in:
`~/.local/share/opencode/mcp-auth.json`

For true workspace isolation, you may need separate opencode data directories
(set via `OPENCODE_DATA_DIR` environment variable).

---

## Tool Tiers Reference

| Tier | Flag | Description |
|------|------|-------------|
| Core | `--tool-tier core` | Essential read/create/search |
| Extended | `--tool-tier extended` | + labels, folders, batch ops |
| Complete | `--tool-tier complete` | All tools including admin |

---

## Troubleshooting

### direnv not loading
```bash
direnv allow  # Must run in each directory
```

### Token issues for wrong account
Delete the workspace-specific credentials and re-auth:
```bash
rm -rf ~/.workspace-mcp/client-a/*
# Then run opencode and re-authorize
```

### 1Password not resolving
Ensure you're running with `op run`:
```bash
op run -- opencode
```

### Check active environment
```bash
echo $GOOGLE_MCP_CREDENTIALS_DIR
# Should show the workspace-specific path
```

---

## References

- [workspace-mcp GitHub](https://github.com/taylorwilsdon/google_workspace_mcp)
- [workspace-mcp PyPI](https://pypi.org/project/workspace-mcp/)
- [opencode MCP docs](https://opencode.ai/docs/mcp-servers)
- [direnv docs](https://direnv.net/)
- [1Password CLI](https://developer.1password.com/docs/cli/secret-references)
