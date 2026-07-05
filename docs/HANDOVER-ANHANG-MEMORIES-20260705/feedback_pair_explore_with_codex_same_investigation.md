---
name: feedback_pair_explore_with_codex_same_investigation
description: Bei JEDEM Explore-Agent-Aufruf parallel einen mcp-Codex-Agenten mit EXAKT derselben Aufgabe starten — Codex sieht mehr als die schnellen Explore-Agenten; beide Ergebnisse gegenprüfen bevor gehandelt wird.
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 78cf67f8-571e-4fcd-a907-1556dbc5be72
---

Immer wenn ich einen **Explore-Agenten** (oder ähnlichen schnellen read-only Such-Agenten) für eine Untersuchung/Mapping starte, parallel **denselben Auftrag zusätzlich an einen `mcp__codex__codex`-Agenten** geben (sandbox `read-only`, approval `never`, `model_reasoning_effort: xhigh`, model weglassen) — mit exakt demselben Prompt/derselben Frage.

**Warum:** Codex analysiert gründlicher/sieht mehr als die schnellen Explore-Agenten. Die Kombination erhöht die Präzision. Beide Ergebnisse gegenprüfen: Konvergenz = hohe Konfidenz; Divergenz = genauer hinschauen, bevor ein (evtl. nicht verifizierbarer) Edit gemacht wird.

**How to apply:** Explore-Aufruf und Codex-Aufruf möglichst im SELBEN Zug (parallel) absetzen. Codex NUR auf Code-Repos (cache-engine/prt-art/super/thesis), NIE Cluster/keys/machines (siehe [[feedback_codex_mcp_review_before_code_complete]]). Gilt für Untersuchungen/Mapping generell, nicht nur für Pre-„done"-Reviews. Verwandt: [[feedback_thorough_assumptions_workflow_planning]] · [[feedback_never_guess_always_lookup_state_of_art_and_docs]].
