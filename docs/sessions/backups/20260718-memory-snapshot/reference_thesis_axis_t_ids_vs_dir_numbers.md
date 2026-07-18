---
name: reference_thesis_axis_t_ids_vs_dir_numbers
description: "Thesis-Achsen-IDs = T0–T18 fortlaufend (tab:axes-overview), NICHT die axis_NN-Code-Verzeichnisnummern; Zuordnung der oft verwechselten Achsen"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 2d70c447-50f5-41bf-a389-d9c5da819589
---

In der Diplomarbeit (cache-engine) gibt es ZWEI Achsen-Nummerierungen, die NICHT übereinstimmen:
- **T0–T18** = die 19 Hauptachsen, fortlaufend, kanonisch in `tab:axes-overview` (`kapitel/de/04_concept_architecture.tex` ~Z.88–106; auch `03_state_of_the_art.tex`). **Das ist die im Text/in Bildern zu verwendende ID.**
- **axis_NN** = Code-Verzeichnisnamen (`axis_06_allocator`, `axis_10_serialization`, `axis_14_value_handle`, …) — NICHT-fortlaufend (Sub-Buchstaben 03a/03b/09b, Lücken), **≠ T-IDs**.

Korrekte T-IDs (oft verwechselt): T4=Node-Type, T5=Memory-Layout, T6=Allocator, T7=Prefetch, T8=Concurrency, **T9=Serialization**, **T10=Telemetry**, **T11=Value-Handle**, T12=ISA, T13=Index-Organization, **T14=I/O-Dispatch**, T15=Migration, T16=Filter, T17/T18=Queuing.

**How to apply:** Beim Beschriften von Achsen (Bilder, Text) IMMER die T-ID gegen `tab:axes-overview` prüfen, nie aus `axis_NN` ableiten. Fehler-Beispiel (2026-06-29, `fig:usage`): Serialisierung als T10 statt T9, Wert-Hülle als T14 statt T11 — von Codex gefangen, gegen die echte Tabelle korrigiert. Verwandt: [[reference_anatomie_gattungen]], [[feedback_never_guess_always_lookup_state_of_art_and_docs]].
