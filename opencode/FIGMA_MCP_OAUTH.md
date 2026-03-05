# Figma MCP OAuth Workaround for opencode

Figma's official MCP server blocks OAuth dynamic client registration from opencode (only allows Claude Code, Cursor, VS Code). This workaround uses Claude Code's registered OAuth client credentials to authenticate.

## Prerequisites

- Claude Code installed (we borrow its OAuth client registration)
- opencode configured with Figma remote MCP

## Step 1: Get Claude Code's OAuth Client Credentials

```bash
security find-generic-password -s "Claude Code-credentials" -a "$(whoami)" -w | jq '.mcpOAuth'
```

Look for the Figma entry with `clientId` and `clientSecret`.

As of Jan 2026:
- **clientId**: `1VnaWyJZl7rJlwfDhaJE9T`
- **clientSecret**: `rXF4U6sxJMpSJZzlQA3yuy0RBgxcpa`

## Step 2: Generate PKCE Values and Auth URL

```bash
CODE_VERIFIER=$(openssl rand -base64 43 | tr -d '=' | tr '+/' '-_' | cut -c1-43)
CODE_CHALLENGE=$(printf '%s' "$CODE_VERIFIER" | openssl sha256 -binary | base64 | tr -d '=' | tr '+/' '-_')

echo "Save this CODE_VERIFIER: $CODE_VERIFIER"
echo ""
echo "Open this URL in browser:"
echo "https://www.figma.com/oauth/mcp?client_id=1VnaWyJZl7rJlwfDhaJE9T&redirect_uri=http://localhost:8080/callback&scope=mcp:connect&response_type=code&state=opencode&code_challenge=${CODE_CHALLENGE}&code_challenge_method=S256"
```

## Step 3: Authorize and Get Code

1. Open the URL in browser
2. Click "Allow access"
3. You'll get redirected to `http://localhost:8080/callback?code=XXXXX&state=opencode`
4. Copy the `code` value from the URL (the page won't load - that's expected)

## Step 4: Exchange Code for Tokens

Replace `YOUR_CODE` and `YOUR_CODE_VERIFIER`:

```bash
curl -s -X POST "https://api.figma.com/v1/oauth/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=1VnaWyJZl7rJlwfDhaJE9T" \
  -d "client_secret=rXF4U6sxJMpSJZzlQA3yuy0RBgxcpa" \
  -d "redirect_uri=http://localhost:8080/callback" \
  -d "code=YOUR_CODE" \
  -d "grant_type=authorization_code" \
  -d "code_verifier=YOUR_CODE_VERIFIER" | jq '.'
```

You'll get back `access_token`, `refresh_token`, and `expires_in`.

## Step 5: Inject Tokens into opencode

Replace the token values from Step 4:

```bash
EXPIRES_AT=$(python3 -c "import time; print(time.time() + 7776000)")

cat ~/.local/share/opencode/mcp-auth.json | jq \
  --arg at "YOUR_ACCESS_TOKEN" \
  --arg rt "YOUR_REFRESH_TOKEN" \
  --argjson exp "$EXPIRES_AT" \
  '.figma = {
    "clientInfo": {
      "clientId": "1VnaWyJZl7rJlwfDhaJE9T",
      "clientSecret": "rXF4U6sxJMpSJZzlQA3yuy0RBgxcpa",
      "clientIdIssuedAt": 1736500000
    },
    "serverUrl": "https://mcp.figma.com/mcp",
    "tokens": {
      "accessToken": $at,
      "refreshToken": $rt,
      "expiresAt": $exp,
      "scope": "mcp:connect"
    }
  }' > /tmp/mcp-auth-updated.json && mv /tmp/mcp-auth-updated.json ~/.local/share/opencode/mcp-auth.json
```

## Step 6: Update opencode Config

Ensure `opencode.json` has:

```json
"figma": {
  "type": "remote",
  "url": "https://mcp.figma.com/mcp",
  "oauth": {
    "clientId": "1VnaWyJZl7rJlwfDhaJE9T",
    "clientSecret": "rXF4U6sxJMpSJZzlQA3yuy0RBgxcpa"
  }
}
```

## Step 7: Restart opencode

Figma MCP should now connect. Tokens are valid for 90 days.

## Why This Works

- Claude Code registered an OAuth client with Figma that accepts `http://localhost:PORT/callback` redirect URIs
- We use that client's credentials to complete the OAuth flow manually
- opencode accepts pre-injected tokens in its auth file

## Troubleshooting

- **"Invalid redirect URL"**: Try `http://127.0.0.1:8080/callback` instead of `localhost`
- **"invalid_grant"**: Code expired or code_verifier doesn't match - start from Step 2
- **Tokens expired**: Repeat Steps 2-5 (opencode should auto-refresh, but if not...)
