# BEFUND — E4′ §C CoR-Filterkette (2026-07-11): Slice 1 gebaut, thesis-payoff-Handler gated

> Deep-Research wf_749c9118 (2 Research + Design + 2 adversariale Kritiker) + eigene Verifikation. ce 076b71cf.

## Umgesetzt (Slice 1, rein additiv, CI-grün, ctest 203/203)
`libs/cache_engine/builder/experiment_tree/selection_filter_chain.hpp` — Chain of Responsibility (GoF) im CEB
fuer die Tier-Binary-GENERIERUNGS-Kontrolle (Doc 20 §C, war „0 Code-Treffer"). Schliesst die fehlende Feedback-
Kante Auswertung (best_binary_selector) → Generierung (build_orchestrator `provision_all`):
- `FilterVerdict{Pass/Reject/PassToNext}` + abstraktes `FilterHandler` (successor-Link) + **wohldefinierte
  Survive-Regel** (ueberlebt ⇔ dispatch != Reject — korrigiert den vom Review gefundenen Terminal-Defekt, wo
  jeder Ueberlebende auf PassToNext endete und der Runner 0 sammelte).
- `ResumeFilter` (Resume KF-16b + Mess-Ehrlichkeit §D): bereits `two_phase_valid` gemessene Permutationen →
  Reject (nicht neu bauen/messen); unmess/invalide → PassToNext (bauen). Korrekt-gerichtet (Review-Fix: H1 hatte
  invalid→reject = falsche Richtung fuer Generierung) und nicht-duplikativ zum DLL-Cache-Skip des Orchestrators.
- `run_selection_filter_chain` → reduzierte `BuildSelection` (+ provenance-Audit).
- `test_d15_selection_filter_chain.cpp` (Mock-Kandidaten, keine Cluster-Daten): valide→Reject, invalide/unmess→
  behalten, leere Kette=Identitaet, provenance fortgeschrieben.
Cold-path (build-time) → GoF-CoR mit Handler-Objekten zulaessig (nicht im gemessenen Hot-Path). golden/POD/
mp_list/ABI TABU: byte-unberuehrt (kein Produktions-Code beruehrt). Nur benannte Patterns.

## Review-Findings (alle adressiert)
- Faktenfehler: `sota_catalog.hpp` existiert doch (`tests/unit/thesis_tiere/`) — ist aber ein Materialisierungs-
  Katalog, KEINE Paper-Wall-Clock-Referenz. Korrekt neu gefasst.
- Survive-Regel-Terminal-Defekt: behoben (siehe oben).
- H1 falsche Richtung / H2 kein Filter: durch den korrekt-gerichteten ResumeFilter ersetzt.

## DEFERRED (additiv, gated — je weitere Kettenglieder)
- **PaperComparisonHandler** (§D-Schritt-4, „Paper geht vor"): braucht eine Wall-Clock-Referenzquelle der Paper-
  Algorithmen — **data-gated** (existiert nicht; sota_catalog liefert nur Quelltext). §C-vs-§D-Semantik
  (Reihenfolge-Vorrang vs. Hart-Reject) beim Nachziehen klaeren.
- **DominanceHandler/Pareto** (§B): je Messkurven-Typsystem-Schluessel (framework×workload×op×size) nur die
  nicht-dominierte Pareto-Front passieren — braucht das **Messkurven-Typsystem (§B, noch nicht gebaut)**.
- ResourceBudgetHandler (§ RAM): Bestands-RAM-Admission ist ein Scheduler (defer), kein Hart-Filter — Semantik
  (reject vs defer) doc-unklar.

## Meta
Der Slice liefert den CoR-MECHANISMUS + die Kern-Feedback-Kante (ResumeFilter). Die thesis-payoff-Handler sind
gated (Typsystem-first bzw. data). Die CoR ist der Extension-Point: weitere Handler additiv, sobald ihre
Datenquellen/das Typsystem existieren. Konsistent mit dem Muster der Session: die tiefere E4′-Strecke ist
gated (Typsystem/Cluster-Daten), aber die Mechanismus-/Vorbau-Schicht ist buildbar.
