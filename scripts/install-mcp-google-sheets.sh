#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="${MCP_GOOGLE_SHEETS_DIR:-$HOME/mcp-google-sheets}"
REPO_URL="https://github.com/diitrashed/mcp-google-sheets.git"
CREDENTIALS_DIR="$INSTALL_DIR/credentials"
MCP_CONFIG="${CURSOR_MCP_CONFIG:-$HOME/.cursor/mcp.json}"

echo "Installing mcp-google-sheets to $INSTALL_DIR"

if [ -d "$INSTALL_DIR/.git" ]; then
  git -C "$INSTALL_DIR" pull --ff-only
else
  git clone "$REPO_URL" "$INSTALL_DIR"
fi

cd "$INSTALL_DIR"
npm install
npm run build

mkdir -p "$CREDENTIALS_DIR"
chmod 700 "$CREDENTIALS_DIR"

if [ ! -f "$CREDENTIALS_DIR/service-account.json" ]; then
  echo
  echo "Next: save your Google service account JSON to:"
  echo "  $CREDENTIALS_DIR/service-account.json"
  echo
  echo "Then share your Google Sheet with the service account email (Editor)."
fi

mkdir -p "$(dirname "$MCP_CONFIG")"

node <<'NODE' "$INSTALL_DIR" "$CREDENTIALS_DIR/service-account.json" "$MCP_CONFIG"
const fs = require('fs');
const path = require('path');

const installDir = process.argv[2];
const credentialsPath = process.argv[3];
const mcpConfigPath = process.argv[4];

const entry = {
  command: 'node',
  args: [path.join(installDir, 'dist/index.js')],
  env: {
    SERVICE_ACCOUNT_PATH: credentialsPath,
  },
};

let config = { mcpServers: {} };
if (fs.existsSync(mcpConfigPath)) {
  config = JSON.parse(fs.readFileSync(mcpConfigPath, 'utf8'));
  config.mcpServers ||= {};
}

config.mcpServers['google-sheets'] = entry;
fs.writeFileSync(mcpConfigPath, JSON.stringify(config, null, 2) + '\n');
console.log(`Updated MCP config: ${mcpConfigPath}`);
NODE

echo "Done. Restart MCP servers in Cursor (Settings → MCP)."
