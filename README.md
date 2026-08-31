# Agent Hub — Central Knowledge Base

This repo keeps all your agents (opencode instances) in sync across machines.

## What's Here
- `AGENTS.md` — Main instructions for all agents
- `VPS-BRIEFING.md` — VPS details, credentials, infrastructure
- `FREE-MODELS.md` — Current free OpenRouter models
- `MCP-SETUP.md` — MCP server installation guide
- `CONTAINER-PROJECT.md` — Blender container design status
- `plugins/agent-hub-sync.js` — Auto-sync plugin for opencode

## Quick Setup

### First Time (per machine)
```bash
git clone https://github.com/kampakilla007/agent-hub.git ~/agent-hub
cd ~/agent-hub && ./sync.sh
```

### Auto-Sync Plugin
The `agent-hub-sync.js` plugin is installed automatically by `sync.sh`. It:
- **Pulls** latest changes when opencode starts
- **Pushes** changes when you finish a session

No manual git commands needed after initial setup.

### Shared Model Config (one gateway for all devices)
All devices reach the same models through the **OmniRoute gateway on the VPS**
(`opencode/cloud.json` → the `vps-gateway` provider). No per-device keys needed.

- `sync.sh` installs `opencode/cloud.json` into `~/.config/opencode/opencode.jsonc`
  on a device's **first run only** — it never overwrites an existing config.
- The gateway serves the full OpenRouter catalog (~1130 models) plus free
  `:free` variants and `auto/*` routing aliases.
- To use more models, add them to `opencode/cloud.json` and commit — every
  device pulls the same list.
- **Requires Tailscale running** — the gateway is at `100.104.79.55:20128`
  (VPN only). If the gateway is unreachable, start Tailscale first.

### Per-Device First-Time Setup
```bash
# 1. Start Tailscale (must be running to reach the gateway)
# 2. Clone + sync once
git clone https://github.com/kampakilla007/agent-hub.git ~/agent-hub
cd ~/agent-hub && ./sync.sh
# 3. opencode will pick up the shared vps-gateway provider on next launch
```

### Manual Sync (if needed)
```bash
cd ~/agent-hub && git pull    # Get latest
cd ~/agent-hub && ./sync.sh   # Push your changes
```

## Sensitive Data
Passwords and API keys are NOT stored here. See `VPS-BRIEFING.md` for credential locations.
