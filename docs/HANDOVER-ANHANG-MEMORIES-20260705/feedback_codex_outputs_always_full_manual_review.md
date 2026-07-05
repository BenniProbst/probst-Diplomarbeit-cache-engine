---
name: feedback_codex_outputs_always_full_manual_review
description: "ALLE Codex-Artefakte nach Fertigstellung IMMER vollständig manuell reviewen (Dateien selbst lesen, Zeile für Zeile) — nicht nur Whitelist/TABU/Claims prüfen"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 78cf67f8-571e-4fcd-a907-1556dbc5be72
---

User-Direktive 2026-07-05 (Diplomarbeit-Session, während AP-7b): „Bitte merke dir alle Dokumente von codex bitte stets nochmal manuell zu reviewen, sobald es fertig ist."

**Why:** Codex-Verifikations-Claims (PASSED-Zeilen, Diffs im Output) sind Selbstauskünfte. Whitelist-/TABU-/Claim-Checks fangen Scope-Verstöße, aber nicht inhaltliche Abweichungen INNERHALB der erlaubten Dateien (z.B. nicht-faithful Logik-Abweichungen, stille Vereinfachungen, falsche Kommentar-Attributionen, subtile Semantik-Drifts). Frühere Sessions fanden genau solche Fälle erst im manuellen Datei-Review (z.B. Adapter-Naht-Verallgemeinerung breiter als beauftragt bei S7-1 — dort ok, aber nur Review stellte das fest).

**How to apply:** Nach JEDEM `codex exec`-Abschluss, VOR dem Commit, zusätzlich zu Whitelist/TABU/Claims: (1) jede neue Datei per Read VOLLSTÄNDIG lesen; (2) jede modifizierte Datei per git diff im Volltext (nicht nur grep-Auszüge) prüfen; (3) bei faithful-Ports die Kern-Logik gegen die Referenz-Quelle abgleichen (Zeilen-Anker aus der Kartierung); (4) Befunde im Commit-Text dokumentieren („manuell reviewt: …"). Gilt für ALLE Artefakt-Typen (Code, Tests, CMake, Docs, Schemas). Ergänzt [[feedback_codex_mcp_review_before_code_complete]] und die Goal-V2-Kadenz (Ledger §13.4 „manuelle Zeile-für-Zeile-Kontrolle") — diese Direktive macht den Voll-Review explizit UNVERHANDELBAR, auch wenn Claims vollständig aussehen. [[feedback_codex_uncertain_fallback_to_ultracode]] · [[feedback_no_success_marks_without_literal_output]]
