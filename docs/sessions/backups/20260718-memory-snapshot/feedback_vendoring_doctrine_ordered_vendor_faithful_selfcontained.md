---
name: feedback_vendoring_doctrine_ordered_vendor_faithful_selfcontained
description: "Feste 3-Stufen-Doktrin für externe Algorithmen/Bibliotheken/Paper-Codes, STRIKT in dieser Reihenfolge (erst wenn eine Stufe unmöglich, die nächste): (1) echtes Vendoring is_original=true mit Compiler → (2) faithful Re-Implementierung (is_original=false) → (3) self-contained Re-Impl als letzter Ausweg"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive (2026-07-04, „das war schon immer Fakt … LESEN"):** Für die Integration externer Algorithmen/Bibliotheken/Paper-Codes gilt session-übergreifend eine feste Doktrin, STRIKT in dieser Reihenfolge:

1. **Vendor `is_original=true` mit Compiler** — wo echter Quellcode existiert UND integrierbar ist: den ECHTEN Code von der offiziellen Quelle vendoren + compilieren (höchste wissenschaftliche Ehrlichkeit). Präzedenz: HdrHistogram_c (AP-8, CC0).
2. **Faithful Re-Implementierung** — wo KEINE Implementierung existiert (nur Paper/Poster/Beschreibung): haargenau wie beschrieben nachbauen + Re-Impl-Annotation (`is_original=false`). Präzedenz: SwissTable (AP-7, #27), VampirNfp (P33).
3. **Self-contained Re-Impl** — nur als LETZTER Ausweg, wenn faithful Re-Impl unmöglich.

**Why:** Ehrlichkeit + Nachvollziehbarkeit der Thesis; echter Code schlägt Nachbau schlägt Behelf. Nicht fragen — die Reihenfolge anwenden.

**How to apply:** Bei jeder externen-Code-Aufgabe die Stufe bestimmen und anwenden. Doktrin dokumentiert in `axes/*/PAPER_REFERENCES.md` + `docs/architecture/18_*map.md` + `cmake/is_original_codegen.cmake`.

**Herkunft:** konsolidiert aus Infra-Agent-Handover (Cluster `docs/agent-memories-infra/`, cwd `C--WINDOWS-system32`), übernommen 2026-07-08. Verwandt: [[feedback_all_comdare_cpp_drogon_other_langs_are_feature_sources]], [[feedback_never_guess_always_lookup_state_of_art_and_docs]], [[feedback_ext_paper_organisation_separates_axes_from_paper_code]].
