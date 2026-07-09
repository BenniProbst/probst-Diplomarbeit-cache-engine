# RECHERCHE (READ-ONLY): #188-4c-Increment-Schnitt + Command-Pattern-Kartierung + Mess-Visitor-Grundlagen + Container-in-SA-Karte

Repos: `C:\Users\benja\OneDrive\Desktop\Diplomarbeit - Datenbanken\Code\external\comdare-cache-engine` (HEAD a1f6024)
+ Architektur-Docs `CE/docs/architecture/` (autoritativ: Doc 30 §8.0 > Doc 34 > Einzel-Docs; Doc 36 EINE-Architektur;
Kontext-Dossier super `docs/sessions/20260628-KONTEXT-DOSSIER-…A2welle.md` §17-4c) + Thesis
`C:\Users\benja\OneDrive\Desktop\Diplomarbeit - Datenbanken\thesis\` (ch2/ch4/Anhang F). file:line überall. KEINE Edits. Deutsch.

## Bindende User-Direktiven (2026-07-02, Rahmen — nicht hinterfragen)
D1: #188-4c = Spiegel-ELIMINIERUNG (search_organ_-Entfall Rest-Gruppe) + container_→storage_organ_-Rename im selben Zug.
D2: Command-Pattern-Basis-Interface aller Achsen per Metaprogrammierung; jede Achse führt Mess-Bestandteile als
    VISITOR im Interface mit („Limitations-Interface"). User-These: „Die Command-Pattern-Hierarchie ist im Code
    deutlich sichtbar, hauptsächlich als compile-time-Metaprogrammierung umgesetzt."
D3: Container-Gattung wird als Teilbereich IN der SA-Achsen-Messung aufgeschlüsselt (ContainerObserver-Kategorie
    real befüllen; Container = erheblicher Zugriffs-Anteil der Suchalgorithmen). Kein separater Container-Lauf.

## Fragen

### F1 — COMMAND-/VISITOR-KARTIERUNG (User-These D2 verifizieren)
Kartiere ALLE bestehenden Command-artigen und Visitor-artigen Bausteine mit file:line + Einordnung
(echtes GoF-Command/Visitor compile-time? Etikett? Teilmuster?):
- WorkloadOp/WorkloadOpKind + Last-Generator (workload_config/workload_orchestrator) — Op-Objekte als Commands?
- builder/anatomy_commands/* (z.B. tier_observe_trace_abi) + builder/commands/* (execute_engine_command,
  execution_result) — der „Kommando-Pfad"?
- IDriveableTier/IObservableTier-tier_*-Ops (ABI-Verben) — Command-Empfänger?
- runtime_measure_visitor + der „hybride Visitor" (memento_all, #44) + node_value_measurement/
  workload_orchestrator-Besucher — echte Visitors?
- Achsen-seitig: CRTP-Basen + zweischichtige Concepts (Thesis ch4:84-86), mp_for_each/mp_list-Traversierungen
  (ObserverAggregate, observe_all, build_axis_levels) — compile-time-Iteration als Visitor-Analogon?
- GoF-Etiketten-Inventar: wo steht „Command"/„Visitor" in Kommentaren, und stimmt es (#224-Bezug)?
VERDIKT: Ist die User-These haltbar (Command-Hierarchie sichtbar)? Wo sind die Lücken zur Formalisierung
(EIN Basis-Interface statt verstreuter Bausteine)?

### F2 — MESS-VISITOR-ANKNÜPFUNG (D2-Design-Grundlage, NICHT designen — nur Grundlagen)
- Exakte Ist-Verträge: MeasurableComponent (measurable_concept.hpp), ObservableAxis, ObserverAggregate,
  Observable*-Hüllen-Familie (welche Achsen haben Hüllen, welche nicht), axis_observer_classification
  (SearchAlgorithmObserver/DefinitionOnly/ContainerObserver-Mechanik), COMDARE_MEASUREMENT_ON/STATISTICS-Gating-Matrix.
- Wo würde ein uniformes „Achsen-Command-Interface mit Mess-Visitor-Slot" andocken (axis_base? Topic-Concepts?
  die CRTP-Basen? die Composition?), OHNE Runtime-Switch und OHNE die 26-Achsen-Klassifikation zu brechen?
- Capability-/Limitations-Auskunft heute: Konformitäts-Gatter (conformance_gate), le_limitierung-Generator
  (csv_to_latex), IResourceControllableTier-caps, supports_*()-statics der Achsen — die Bausteine, die ein
  Limitations-Interface konsolidieren würde.

### F3 — #188-4c-INCREMENT-SCHNITT (D1, der eigentliche nächste Manager-Zyklus)
Aus Kontext-Dossier §17-4c + Code-Ist: Schneide den search_organ_-Entfall + Rename in god-header-konforme
Increments (je EIN abi_adapter-Increment, je CI-verifizierbar). Prüfe je Increment:
- 4c-i: Die 11 Reference-/PaperBinding-Compositions authoritativ machen (Hülle = Organ; welche Mechanik:
  organ_for-Spezialisierungen? StoreTraversable-Marker? dritter Weg container_t=search_algo-Typ direkt?
  Was passt zur bestehenden Weichen-Architektur :1931-1963?). Welche Tests decken die 11 (test_cow_memento,
  Äquivalenz)? Memento/CoW-Umbau (saved_search_ entfällt mit?).
- 4c-ii: markerlose Flach-Wrapper (Array256/VectorU8U8/VectorU16U16/Array65535): faithful Traversals bauen
  (Array256=Direkt-Adress!) ODER anders authoritativ? Sind sie in EnabledStrategies überhaupt AN (flags)?
- 4c-iii: search_organ_-Member + else-Zweige + tier_search_routes_through_store + fill_observer_v3-else +
  Key-Ernte-Zweige 3/4 ENTFERNEN; welche Stellen genau (Dossier §17-Liste verifizieren + vervollständigen).
- 4c-iv: Rename container_→storage_organ_ (+ flat_container_t/container_is_authoritative_/
  container_is_store_backed_-Namen): reiner Rename-Sweep, welche Konsumenten außerhalb abi_adapter
  (perm_runner? Tests? codegen?) referenzieren die Namen?
- #216-H2 (stat_*-Reset nach Load): fällt er mit 4c weg oder bleibt ein Rest? Beleg.
- Reihenfolge-Empfehlung + Risiko je Increment + was CI-seitig je Increment beweist.

### F4 — CONTAINER-IN-SA-KARTE (D3-Grundlage)
- Welche SA-Achsen/Organe sind Container-artig (Stores: LayoutAwareChunkedStore/NodePool-Stores/RawSlotStore;
  node_type-Achse; value_handle? index_organization? queuing-Puffer?) — Kandidatenliste mit Begründung je Achse.
- Wie ist axis_observer_classification erweiterbar, sodass diese Organe ContainerObserver-klassifiziert werden
  (Mechanik der Klassifikation heute: woran hängt die Kategorie je Achse?) — und wo landen die Zahlen
  (axis_stats[19][8]? eigene Spalten?), damit der Container-Anteil je SA-Tier AUFSCHLÜSSELBAR wird?
- Was sagt die Thesis über Container-Anteile in Suchalgorithmen (ch2/ch4 — Belegstellen für D3-Motivation)?

## Output
F1-Kartierungstabelle + Verdikt; F2-Vertrags-/Andock-Liste; F3-Increment-Plan (nummeriert, mit Berührungspunkten
file:line + Test-/CI-Ankern + Reihenfolge); F4-Kandidaten-/Mechanik-Karte. Am Ende „OFFENE FRAGEN". KEINE Edits.
