---
name: feedback_codex_mcp_always_newest_model_xhigh
description: "User-Direktive 2026-07-05: Codex (MCP wie CLI) IMMER auf das neueste verfuegbare Modell und model_reasoning_effort=xhigh stellen"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 34effcef-618b-4cb2-bd80-87d2a502062e
---

User 2026-07-05 (prod1/comdare): „Bitte stelle codex plugin mcp immer auf das neueste modell und auf xhigh."

**Why:** Codex ist der Implementierer im Manager-Modus ([[feedback_codex_implements_from_dossier_claude_corrects]]) — schwächere Modelle/Effort erzeugen Review-Mehraufwand und Fehlstarts.

**How to apply:**
- MCP-Registrierung: `claude mcp add codex --scope user -- codex mcp-server -c 'model="<neuestes>"' -c 'model_reasoning_effort="xhigh"'` (Stand 2026-07-05: gpt-5.5; bei neuem Modell-Release Registrierung UND ~/.codex/config.toml nachziehen).
- CLI-Dispatches: immer `-m <neuestes> -c 'model_reasoning_effort="xhigh"'` (Handover-§1-Kommando-Muster).
- Bei jedem Codex-Setup auf neuen Maschinen beides prüfen.

Siehe [[reference_prod1_comdare_env_setup]].

**UPDATE (User 2026-07-10):** Default umgestellt auf `model = "gpt-5.6"` + `model_reasoning_effort = "max"` (~/.codex/config.toml, sed-verifiziert). Regel bleibt: immer das neueste verfügbare Modell + höchste Effort-Stufe als Codex-Default; MCP-Aufrufe OHNE model-Override nutzen diesen Default.

**KORREKTUR (literal getestet 2026-07-10):** `gpt-5.6` → API-400 „not supported when using Codex with a ChatGPT account"; Effort `max` → API-400 „Supported values: none/minimal/low/medium/high/xhigh". Der User-Wunsch 5.6/max ist mit diesem Account (Stand 10.07.) NICHT möglich → zurück auf das verifizierte Maximum `gpt-5.5` + `xhigh`. Bei künftigen Modell-Releases erneut testen (sed auf ~/.codex/config.toml + Probe-Call).
