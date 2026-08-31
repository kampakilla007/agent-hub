# AGENTS.md — Shared Instructions for All opencode Instances

## Last Updated: August 27, 2026

---

## Infrastructure Overview
- **VPS:** 89.117.23.163 (Tailscale: 100.104.79.55)
- **OmniRoute Gateway:** http://100.104.79.55:20128 (password: see VPS-BRIEFING.md)
- **Default Model:** vps-gateway/nvidia/nemotron-3-ultra-550b-a55b:free
- **Free Models Only:** Never use paid models

## SSH Access
```bash
# From MacBook
ssh -i ~/.ssh/vps_key root@89.117.23.163

# From Windows (using key)
ssh root@89.117.23.163
```

## Model Access (all devices)
- All models go through the **VPS OmniRoute gateway**: base URL
  `http://100.104.79.55:20128/v1` (Tailscale only — start Tailscale first).
- Shared provider config lives in `opencode/cloud.json`; `sync.sh` installs it
  on a device's first run. Merge it manually if a device already has a config.
- The gateway mirrors the full OpenRouter catalog. Keep the `:free` variants
  and `auto/*` aliases for everyday use; add named models to `cloud.json` as needed.
- Never put the actual OmniRoute/OpenRouter API key in this repo — use the
  placeholder and let each gateway hold the real key.

## Project Status
- **Bitcloudit.com:** Live, SSL + Cloudflare active
- **CPUVets.com:** Built, needs hosting
- **Container Design:** v7 with logo emboss in progress

## Blender Container Project
- Script: `container_v7.py` with logo emboss
- 3D Printer: Bambu H2D or H2C
- O-ring: 70mm OD x 2mm cross-section
- Logo: JSF/3D3SIGNS embossed on cylinder body

## Rules
1. Always use FREE models via VPS gateway
2. Don't commit passwords or API keys
3. Pull this repo before starting work
4. Push changes when done
5. Keep VPS-BRIEFING.md updated with infrastructure changes
