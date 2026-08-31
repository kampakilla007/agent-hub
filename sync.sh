#!/bin/bash
# Agent Hub Sync Script
# Run this before starting work to pull latest changes
# Run this after finishing work to push your changes

set -e

HUB_DIR="$HOME/agent-hub"

# Check if repo exists
if [ ! -d "$HUB_DIR/.git" ]; then
    echo "Cloning agent-hub..."
    git clone https://github.com/kampakilla007/agent-hub.git "$HUB_DIR"
fi

cd "$HUB_DIR"

# Pull latest
echo "Pulling latest changes..."
git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || echo "No remote changes"

# Install opencode plugin if it exists
if [ -f "$HUB_DIR/plugins/agent-hub-sync.js" ]; then
    PLUGIN_DIR="$HOME/.config/opencode/plugins"
    mkdir -p "$PLUGIN_DIR"
    cp "$HUB_DIR/plugins/agent-hub-sync.js" "$PLUGIN_DIR/"
    echo "Plugin installed: agent-hub-sync.js"
fi

# Install shared opencode config template on first-run only.
# Never overwrite an existing config so per-device edits are preserved.
if [ -f "$HUB_DIR/opencode/cloud.json" ]; then
    OPENCODE_DIR="$HOME/.config/opencode"
    CONFIG_FILE="$OPENCODE_DIR/opencode.jsonc"
    mkdir -p "$OPENCODE_DIR"
    if [ ! -f "$CONFIG_FILE" ]; then
        cp "$HUB_DIR/opencode/cloud.json" "$CONFIG_FILE"
        echo "Installed shared config: $CONFIG_FILE"
        echo "  -> Contains the vps-gateway (OmniRoute) provider with free models."
        echo "  -> Start Tailscale first: the gateway is reached over the VPN (100.104.79.55)."
    else
        echo "Existing config found at $CONFIG_FILE - not overwriting it."
        echo "  (If you want the shared vps-gateway provider, merge opencode/cloud.json manually.)"
    fi
fi

# Show status
echo ""
echo "Agent Hub Status:"
git status --short

# Auto-commit and push if there are changes
if [ -n "$(git status --porcelain)" ]; then
    echo ""
    read -p "Push changes? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add -A
        git commit -m "Update from $(hostname) at $(date '+%Y-%m-%d %H:%M')"
        git push
        echo "Changes pushed!"
    fi
fi

echo ""
echo "Done! Your agents are up to date."
