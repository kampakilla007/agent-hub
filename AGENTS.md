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
