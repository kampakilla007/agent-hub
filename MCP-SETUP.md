# MCP Server Setup Guide

## Last Updated: August 27, 2026

---

## Quick Setup (MacBook)

```bash
# Run the setup script
bash ~/.local/bin/setup-mcp-servers.sh
```

## Manual Setup

### Prerequisites
- Node.js v22+ (via mise or nvm)
- Python 3.11+ (via uv)

### Install MCP Servers

```bash
# Create local bin directory
mkdir -p ~/.local/bin

# Install via npm/npx
npm install -g @anthropic-ai/mcp-server-filesystem
npm install -g @anthropic-ai/mcp-server-sequential-thinking
npm install -g @anthropic-ai/playwright-mcp
npm install -g @anthropic-ai/context7-mcp

# Blender MCP
uv tool install blender-mcp

# Network Diagram MCP
npm install -g network-diagram-mcp
```

### Configure opencode

Edit `~/.config/opencode/opencode.jsonc`:

```json
{
  "mcp": {
    "context7": {
      "type": "local",
      "command": ["~/.local/bin/context7-mcp"],
      "enabled": true
    },
    "filesystem": {
      "type": "local",
      "command": ["~/.local/bin/mcp-server-filesystem", "~"],
      "enabled": true
    },
    "playwright": {
      "type": "local",
      "command": ["~/.local/bin/playwright-mcp", "--headless"],
      "enabled": true
    },
    "sequential-thinking": {
      "type": "local",
      "command": ["~/.local/bin/mcp-server-sequential-thinking"],
      "enabled": true
    }
  }
}
```

## VPS MCP Servers

Located at `/opt/mcp-servers/mcp-config.json`:
- chrome-devtools
- context7
- filesystem
- playwright
- sequential-thinking
- openscad
