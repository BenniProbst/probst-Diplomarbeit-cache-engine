# Welle 5 — §38-Dock-Protokoll: Bauplan (19.07.2026, IMPL/Architekt)

> Grundlage: ultracode-Erhebung (4 Opus-Reader) ueber Ledger §30–§38.b + topdown-BAUPLAN + FINALES-DESIGN-ABSTRACT (SOLL) und ce-Code + super-Treiber + .gitlab-ci.yml (IST). Alle Belege datei:zeile in der Erhebung (Session 19.07. abends). User-GO: „Volles GO fuer alle Punkte" (19.07.).

## Architektur-Entscheide (Fable, aus dokumentierten Doktrinen abgeleitet)

**E-W5-1 Wire-Format der Teilbaum-Ranges (Designluecke 1):** Serialisierung als **XML-Fragment deckungsgleich mit der R5-Range-Syntax** (`<values>` enumeriert / `<range start count>`), AxisKind-gefaerbt — konsistent mit „NUR EIN XML-Programm", dem Registry-/.pom-Modell (§27/§28) und D12 des Design-Abstracts. In-process reist die Nutzlast als POD (`ExperimentSubtreePayload`), der XML-Emitter+Parser bekommt ein **Byte-Roundtrip-Gate** nach §28-Muster. Transport heute: String/Datei in-process durchgereicht (die Naht ist damit prozessgrenzen-ready, ohne heute eine Prozessgrenze zu erzwingen — Fork C bleibt offen und ungeblockt).

**E-W5-2 Fortschritts-Rueck-Kanal (Designluecke 2):** Neuer POD `ProgressDelta` = { fenster-relativer Cursor (perm-Index), Liste geaenderter Achsen {axis_id, variant_id}, done-Flag }. Erste Meldung eines Fensters = Voll-Konfiguration (alle Achsen), danach mixed-radix-minimale Deltas in StaticBinaryView-Ordnung; `done=true` = das §38.b-Fertig-Signal. KEIN Mess-Daten-Rueckfluss. Injektion als `ProgressSinkFn` in `LazyRunConfig` **exakt nach der bestehenden No-Op-Naht-Doktrin** von CachePushFn/MeasurementSinkFn (iterator:61-62, :149-150, Feuerpunkt :942-954) — byte-neutral, Default No-Op, golden-neutral.

**E-W5-3 Dritte-Engine-Gefahr (adversarialer Befund):** Der `ExperimentPlanDirector` ist die FORMALISIERUNG des E4-Alleinwegs (spiegelt run_profile-Walk), KEINE neue Engine; der v32-Antrieb (`v32_messreihe_antrieb.hpp`) bleibt Legacy-Opt-in hinter `COMDARE_LEGACY_MESSREIHEN=1` (main.cpp:784). Reconciliation = Doku-Vermerk + Contract-Test-Pflicht (Director-Walk == run_profile-Walk), kein Umbau des Legacy-Pfads.

**E-W5-4 §38.b CI-Mechanik:** `resource_group: "ceb-measurement-exclusive"` NUR an measure:smoke (:471ff) und measure:golden-320 (:547ff); Bau-Pool (gn-…-Gruppen) UNANGETASTET. (Erledigt IMPL selbst, gleiche Session.)

## Arbeitspakete

**W5-A (CI, IMPL selbst):** die zwei resource_group-Zeilen + §38.b-Kommentar. DoD: CI-Lint valid.

**W5-B (Opus-Agent 1, planner-Strang):** `--dump-plan`-CLI neu schreiben (W3-B-Patch-Text verloren): Fassaden-Export (Planer-Header gehoert laut experiment_plan_director.hpp:42-43 in die Fassaden-.cpp, nicht in den Treiber) + Arg-Zweig in super main.cpp:317-355 analog `--validate` (Profil laden, Root-Tag-Sniff, Director+PlanTextBuilder, Text→stdout, exit 0 ohne Bau/Messung). Danach **I2 CMakeGraphBuilder**: zweiter ConcreteBuilder am SELBEN Director-Walk, emittiert `experiment_plan.cmake` nach Blaupause catalog_codegen.cmake:27-37; Contract-Test Topologie-Isomorphie (gleiche PhaseStep-Menge/Kanten wie PlanTextBuilder). NICHT das Legacy-CodegenEngine (codegen.hpp:24) verwenden.

**W5-C (Opus-Agent 2, Dock-Nutzlast-Strang):** `planner/experiment_dock_payload.hpp`: `ExperimentSubtreePayload` (System-+Organ-Achsen-Ranges, AxisKind-gefaerbt) + R5-XML-Emitter/Parser + Byte-Roundtrip-Gate-Test; `ProgressDelta`-POD + `ProgressSinkFn`-Naht in LazyRunConfig/RunProfileArgs (No-Op-Default) + Feuerung an der Per-Binary-Synchron-Naht; Unit-Test: Delta-Folge ueber ein kleines Fenster rekonstruiert exakt die StaticBinaryView-Permutationsfolge; done-Signal am Fensterende.

**Nachfolge (nicht W5):** aktive CEB-Generierung je Messsystem (Fork C .so-Schnitt), Hybrid-Dock der rekursiven Delegation, System-/Mess-Join (PL-21, nach Abgabe).

## Guardrails (beide Agenten)
Kein Commit durch Agenten (Integration+Commit durch IMPL); golden-/byte-neutral (alle Defaults No-Op); static_assert==131072 + CRC64-Anker unberuehrt; keine CT→RT-Degradation; ASCII-Kommentare; Naht-Doktrin exakt kopieren, keine neuen Abhaengigkeiten; ctest-Belege literal.
