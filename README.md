# Agent Hub — Central Knowledge Base

This repo keeps all your agents (opencode instances) in sync across machines.

## What's Here
- `AGENTS.md` — Main instructions for all agents
- `VPS-BRIEFING.md` — VPS details, credentials, infrastructure
- `FREE-MODELS.md` — Current free OpenRouter models
- `MCP-SETUP.md` — MCP server installation guide
- `CONTAINER-PROJECT.md` — Blender container design status

## How to Use
Each machine should clone this repo and pull before starting work:

```bash
# First time setup
git clone https://github.com/kampakilla007/agent-hub.git ~/agent-hub

# Before each session
cd ~/agent-hub && git pull

# After making changes
cd ~/agent-hub
git add -A
git commit -m "update: description of change"
git push
```

## Sensitive Data
Passwords and API keys are NOT stored here. See `VPS-BRIEFING.md` for credential locations.
