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

### Manual Sync (if needed)
```bash
cd ~/agent-hub && git pull    # Get latest
cd ~/agent-hub && ./sync.sh   # Push your changes
```

## Sensitive Data
Passwords and API keys are NOT stored here. See `VPS-BRIEFING.md` for credential locations.
