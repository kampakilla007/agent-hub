# Free OpenRouter Models

## Last Updated: August 31, 2026

---

## Confirmed Working (Tested via OmniRoute Gateway)

| Model | Context | Status |
|-------|---------|--------|
| nvidia/nemotron-3-ultra-550b-a55b:free | 1M | WORKS |
| nvidia/nemotron-3-super-120b-a12b:free | 262K | WORKS (slow - reasoning) |

## Requires Provider Credentials in OmniRoute

| Model | Context | Status |
|-------|---------|--------|
| google/gemma-4-31b-it:free | 262K | Needs Google credentials |
| z-ai/glm-5.2:free | 256K | Needs z-ai credentials |
| minimax/minimax-m3:free | 1M | Needs minimax credentials |
| minimax/minimax-m2.7:free | 204K | Needs minimax credentials |
| poolside/laguna-s-2.1:free | 1M | Needs poolside credentials |
| cohere/north-mini-code:free | 256K | Needs cohere credentials |
| liquid/lfm-2.5-2.6b:free | 131K | Needs liquid credentials |

## EXCLUDED (Broken/Restricted)
- thinkingmachines/inkling:free — 403 restricted
- thinkingmachines/inkling-small:free — 403 restricted

## Auto-Routing Aliases (Always Work)

These don't need any provider credentials — OmniRoute routes to the best model.

| Model | Context | Notes |
|-------|---------|-------|
| auto/best-coding | 1M | Routes to best coding model |
| auto/best-reasoning | 1M | Routes to best reasoning model |
| auto/best-fast | 1M | Routes to fastest model |
| auto/best-vision | 1M | Routes to best vision model |

## Usage
All models accessed via VPS gateway:
- Base URL: http://100.104.79.55:20128/v1
- API Key: omniroute (shared placeholder)
- Shared config: opencode/cloud.json (installed by sync.sh)
