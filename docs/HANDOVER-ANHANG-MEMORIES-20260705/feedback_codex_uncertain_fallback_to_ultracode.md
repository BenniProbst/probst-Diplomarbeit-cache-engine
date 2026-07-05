---
name: feedback_codex_uncertain_fallback_to_ultracode
description: Liefert Codex keine sicheren/eindeutigen Ergebnisse → auf ultracode-Workflow zurückfallen (nicht raten)
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 78cf67f8-571e-4fcd-a907-1556dbc5be72
---

User-Direktive (2026-07-04): Wenn ein Codex-Agent **keine sicheren/eindeutigen Ergebnisse** liefert (unklarer Befund, §7-STOPP, widersprüchlich, nicht literal verifizierbar), NICHT raten und NICHT die Codex-Ausgabe blind übernehmen — auf den **ultracode-Workflow** (Multi-Agent-Orchestrierung via Workflow-Tool) zurückfallen: fan-out + adversariale Verifikation bis Klarheit.

**Why:** Codex ist der Standard-Implementierer (schnell, aus Dossier), aber bei Unsicherheit braucht es die Mehr-Perspektiven-Absicherung des ultracode-Workflows statt einer Annahme.
**How to apply:** Codex-Ergebnis STETS manuell kontrollieren; bei Unsicherheit/Nicht-Verifizierbarkeit → ultracode-Workflow. Ergänzt [[feedback_ultracode_workflow_for_uncertainty_and_absolute_claims]] · [[feedback_codex_implements_from_dossier_claude_corrects]] · [[feedback_codex_mcp_review_before_code_complete]].
