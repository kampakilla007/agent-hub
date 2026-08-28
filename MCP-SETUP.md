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

# Draw.io MCP (for Visio-like diagrams with Cisco icons)
uv tool install drawio-mcp
```

### Draw.io MCP Setup (Special Instructions)

The draw.io MCP server requires a compatible mcp version. If you encounter import errors:

```bash
# Create a venv with compatible mcp version
mkdir -p ~/.local/share/drawio-mcp
cd ~/.local/share/drawio-mcp
uv venv
echo "drawio-mcp>=1.0.0" > requirements.txt
echo "mcp<2" >> requirements.txt
uv pip install -r requirements.txt

# Create wrapper script
cat > ~/.local/bin/drawio-mcp << 'EOF'
#!/bin/bash
exec ~/.local/share/drawio-mcp/.venv/bin/python -c "from drawio_mcp.server import main; main()" "$@"
EOF
chmod +x ~/.local/bin/drawio-mcp
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
    },
    "drawio": {
      "type": "local",
      "command": ["~/.local/bin/drawio-mcp"],
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

## Available MCP Tools

### Draw.io MCP (NEW)
- `diagram` — Create, open, save, import, list .drawio files
- `draw` — Add/update/delete vertices, edges, groups, titles
- `style` — Build styles, apply themes, list presets (310+ presets)
- `layout` — Auto-layout (Sugiyama, tree, grid, flowchart)
- `inspect` — List cells, check overlaps, get info

### Network Diagram MCP
- 44 tools for network topology diagrams
- Node types: server, router, switch, firewall, etc.
- Import from nmap, CSV, JSON
- Export to PNG, PDF, JSON

### Other MCPs
- context7: Library documentation lookup
- filesystem: File operations
- playwright: Browser automation
- sequential-thinking: Reasoning assistance
- blender: 3D modeling
- fusion360: CAD design
