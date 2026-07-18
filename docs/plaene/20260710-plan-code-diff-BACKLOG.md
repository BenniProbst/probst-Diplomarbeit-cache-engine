# BACKLOG — Plan↔Code-Diff (verifiziert), 2026-07-10

> Workflow `wf_d4d9e410-a97` (66 Agenten, 3,67M Tokens): 5 Plan-Gruppen (Dossiers 16-19, BEFUNDe/Analysen, F7+Ledger-W1-W5, Thesis-Kernkapitel) → 60 prüfbare SOLL-Ansprüche extrahiert → JEDER am Code (main ce `5d67eecd`) verifiziert → dedupliziert+klassifiziert. **Statistik: 60 geprüft · 4 bereits voll implementiert · 56 offen.** Rohdaten: `rohdaten/` (Ergebnis + Journal mit allen 60 Einzel-Verdikten datei:zeile + Skript). Anlass: User-Freigabe 10.07. „alle GO-Increments" + Workflow-Wunsch.

## NON_GATED (jetzt baubar — Reihenfolge nach Diplomarbeits-Ziel-Wert)
1. **Limits-Entkopplung (Dossier 17 Phase 4 = #229-Kern; GO-Increment, freigegeben 10.07.):** (a) `CatalogAxes<4,4,5,4>` (source_catalog.hpp:113) aus `ThesisProfile.permute_axes` ableiten; (b) Pre-Build-Codegen der binary_id→Source-Map aus der XML (pilot_source_map = Pilot-only); (c) `adhoc_emitter/main.cpp:139` PilotEngine → XML-Achsenliste. Randbedingungen: Pre-Build-Codegen (KEIN Runtime), golden-Roundtrip==320 Pflicht-Gate, kein ABI-Bump. Design-Grundlage: `../20260710-schicht-e3-impl/LIMITS-ENTKOPPLUNG-ANALYSE.md`. **Wert HOCH:** öffnet den XML-Achsenraum jenseits golden-320 = Voraussetzung für Heuristik-Kurven-Breite + Hybrid-Rekombination.
2. **Parser-/Gating-Konsolidierung (Dossier 17 Phase 7):** XmlConfigParser 2→1 Reader (+ 3. Duplikat-Regex im messung_driver), `COMDARE_EXPERIMENT_MODE` real verdrahten (heute 0 Konsumenten), stille-{}-Falle der 4-Datei-Erwartung bereinigen (parse_one liefert still {}). Gate: nur Regressions-ctest.

## DATEN_GATED (#215→#156 Cluster-Fenster; Code-Vorbau teils möglich)
- **#215 → #156/#162:** Code-Seite DONE (neue Spalten batch_size/batch_visited=T1[6/7], budget_reject=T6[5] eingefroren); es fehlen DLL-Bestand nach `3ddbb0d6` + CSVs mit neuen Headern.
- **Mess-System Phase-6-Rest:** vendor-neutrale `IMeasurementSource` + Mess-Achsen-Registry + Prüf-Dock→POD-Verdrahtung + `<measurement_categories>`-XML — SystemAxis-Wurzel (M ✓) ist das Fundament; Registry-/Interface-Anteile technisch VORBAUBAR, Abnahme hängt an PMC-/Messdaten.
- **E4′-Kurven-Fit:** CSV→Kurven→Schätzer-Stufe existiert nicht; Fundament (cacheline_policy_selector + Objectives-BEFUND + Cluster-BEFUND) komplett; Skeleton vorbereitbar, Fit ist datengetrieben.

## EXTERN_GATED (echte Forks/Owner — je GEPARKT mit Empfehlung im Handover)
- **W/D/K-XML-Strecke** (MessreihenSpec+`<datasets>`+`<measurement_categories>`+XML-only-Abnahme): R1/R2-Fork — die 10.07.-GO-Freigabe deckt GO-Increments, beantwortet aber NICHT den R1/R2-Fork (Empfehlungen liegen im Handover §3).
- **Dataset-Wahrheitsquelle:** test_data_sets.xml existiert 0× (stiller Parser-Slot) vs. 6-Kanon-Akten → R2-Entscheid.
- **V32-/comdare_experiment-Altlast:** vollenden (Option B) oder toten Pfad tilgen → Fork.
- **Framework×Workload-Bibliothek** (13-Registry + LP01-14 + Loader in comdare-workloads) + **C.1-Konsum** (ce konsumiert measurement-all zur Laufzeit): gated auf Migrationsplan-Schritt 13 + 6-vs-48.
- Weitere (Journal): P/E-Core-Zähler-Domänen (AP-13-Rest), Fairness-Modus common-denominator/native, H2-Quality-Score maschinenlesbar, baseline_3-analysis, prt-art-Pool/Multilevel-Anbindung, sosd/xml-Akten-Rest.

## NÄCHSTER SCHRITT
NON_GATED-1 (Limits-Entkopplung) nach voller Kadenz: Codex-Dossier aus der LIMITS-ANALYSE → Erstimpl. → Schicht-artiger Review + Backup → doppelt-literal + golden-Roundtrip → CI.
