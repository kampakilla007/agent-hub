# VPS Setup Briefing

## Last Updated: August 27, 2026

---

## VPS Details
- **Provider:** Hostinger
- **IP:** 89.117.23.163
- **Hostname:** vmi3533121
- **OS:** Ubuntu 26.04.1 LTS
- **Tailscale IP:** 100.104.79.55
- **SSH:** Key-only auth (password disabled)

## Tailscale Network
| Device | IP | Hostname |
|--------|-----|----------|
| VPS | 100.104.79.55 | vmi3533121 |
| MacBook Pro | 100.104.160.43 | — |
| Alienware Laptop | 100.84.22.73 | lpt-aw1 |

## Docker Containers

### OpenCode Server
- **Ports:** 4096
- **Web UI:** http://100.104.79.55:4096/app
- **Config:** /root/opencode-server/config/opencode.json

### OmniRoute (AI Gateway)
- **Ports:** 20128
- **Dashboard:** http://100.104.79.55:20128
- **Container:** omniroute
- **Restart:** docker restart omniroute

## MCP Servers

### VPS MCP Servers
- chrome-devtools, context7, filesystem, playwright, sequential-thinking, openscad
- Config: /opt/mcp-servers/mcp-config.json

### MacBook MCPs
- context7, filesystem, playwright, sequential-thinking
- fusion360, blender, network-diagram

### Windows MCPs
- playwright, context7, filesystem, sequential-thinking
- visio, fusion360, blender

## Websites
- **bitcloudit.com** — Live, SSL + Cloudflare
- **cpuvets.com** — Built, needs hosting

## Credential Locations
- SSH keys: ~/.ssh/vps_key
- OmniRoute password: See dashboard
- OpenRouter key: See OmniRoute dashboard
