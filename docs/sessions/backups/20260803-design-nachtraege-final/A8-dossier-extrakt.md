# DESIGN-DOSSIER A8/F2 — Benchmarking-Schnitt (Micro = Achsen-Interface, 3 Wallclock-Ebenen)

Datum: 02.08.2026 (nachmittags) · Design-Agent: Fable 5 xhigh · Status: DESIGN, KEINE Code-Aenderung, read-only
Paket: Katalog A8 (trigger-blockierend, Owner-bestaetigte Regression; Dossier Abschn. 5 Nr. 10 — in keiner Welle verplant)

## Quellen (alle Anker verifiziert am 02.08.2026)

Basis-Pfade:
- SUPER = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine
- CE = SUPER/Code/external/comdare-cache-engine (ce-Repo)
- Pflicht-Doku: SUPER/docs/sessions/20260802-KATALOG-offene-strecke-gesamtplan.md:24 (A8-Zeile) · SUPER/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:3368-3391 (Ledger Abschn. 64: Vereinigungs-Default + Schichten-Zuordnung) · SUPER/thesis/diplomarbeit/sessions/20260801-THESIS-FAKTEN-KANON.md:377-397 (NACHTRAG 2 = F2-Owner-Gesetz, verbatim-nah) + :311 (Benchmarking-Schnitt-Zeile: Thesis beschreibt SOLL, Impl zieht nach) · SUPER/docs/sessions/backups/20260802-kontext-neugruendung-abend-workflows/ergebnisse/48-c90c5b72.md:66 (Kanon-Punkt 34, F2) · SUPER/docs/sessions/20260802-UEBERGABE-kontextende-neugruendung.md:58-59
- ce-Ist (kartiert): CE/libs/cache_engine/include/cache_engine/measurement/measurement_tooling_registry.hpp · CE/libs/cache_engine/anatomy/{observable_tier.hpp, measurable_workload.hpp, abi_adapter.hpp, search_algorithm_anatomy.hpp} · CE/libs/cache_engine/harness/perm_runner.hpp · CE/libs/cache_engine/builder/{experiment_tree/host_measure_loop.hpp, experiment_tree/node_value_measurement.hpp, experiment_tree/cache_engine_builder_iterator.hpp, experiment_tree/axis_path_serialization.hpp, workload_driver/workload_orchestrator.hpp, anatomy_commands/tier_observe_trace_abi.hpp, linux_perf_pmc_source.hpp} · CE/libs/cache_engine/include/cache_engine/measurement/pmc_source.hpp · CE/libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp · CE/libs/cache_engine/topics/{axis.hpp, axis_base.hpp, organ_axis.hpp, allocator/concepts/topic_allocator_concept.hpp} · CE/libs/cache_engine/axes/** (Stichproben + Zaehlung)

---

## 0. Das F2-Gesetz (Owner 01.08., bindend — Fakten-Kanon:379-397)

1. Jede Achse hat ein ACHSEN-INTERFACE: Funktionen, die ALLE Algorithmen dieser Achse liefern muessen (Bsp. Allokator: Speicher bereitstellen). MICRO-BENCHMARK = die ACHSE ueber ihr Achsen-Interface durchmessen (achsen-spezifische Haupteigenschaften intern).
2. Die Achse ist NICHT eine Interface-Funktion des Suchalgorithmus. Die Gattungs-(Suchalgorithmus-)Interface-Funktionen VERWENDEN die Achsen-Interfaces; Achsen-Algorithmen duerfen andere Achsen-Interfaces verwenden ("Container werden ueberall gebraucht").
3. SCHNITT-REGEL: Alle Achsen-Algorithmen so schneiden, dass NUR NOCH Achsen-Interfaces statt generischer OS-Calls verwendet werden — inline per Metaprogrammierung; std::variant verboten.
4. Die CEB misst ZUSAETZLICH drei Wallclock-Ebenen: (E1) Wallclock der ACHSEN-Interfaces unter jedem Algorithmus (Gegenmessung zur internen Micro), (E2) Wallclock der GATTUNGS-Interfaces, (E3) Wallclock einer Test-Last aus den Last-Frameworks.
5. Ist-Implementierung ist FALSCH geschnitten (Owner-bestaetigt); der Impl-Nachzug folgt DIESEM Modell. Rahmen: Ledger Abschn. 64 (Schichten-Zuordnung: Wallclock = CEB-Seite; Macro+Micro = CEB UND Tier-Binary ueber das Pruef-Dock einkompiliert; Vereint-Default EINE CEB).

---

## 1. Ist-Schnitt-Kartierung (wo misst "Micro" heute WAS)

### 1.1 Tooling-Haupt-Achse: Micro ist heute ein Etikett ohne Traeger
- CE/libs/.../measurement/measurement_tooling_registry.hpp:27-31: enum {WallClock, Macro, Micro}; :30 deklariert Micro als "feinkoernige PMC/Counter-Instrumentierung" — das widerspricht F2 (Micro = Achsen-Interface, nicht PMC).
- Repo-weiter grep: MeasurementTooling::Micro/Macro/WallClock hat AUSSERHALB der Registry KEINEN Consumer (0 Treffer in libs/apps/tools). Die Tooling-Wahl faechert nur Planer-Lanes auf (experiment_plan_director.hpp:94-102, :491-500, :1694-1700, :1836, :1862) und stempelt (measurement_stamp_line); sie veraendert NICHT, welche Instrumentierung kompiliert wird. Die realen Schalter sind COMDARE_MEASUREMENT_ON / COMDARE_CE_ENABLE_STATISTICS / COMDARE_ENABLE_PMC.

### 1.2 Die drei real existierenden Mess-Pfade

(A) Pfad A — in-DLL, SYNTHETISCH (die "Micro"-Achsen-Messung im heutigen Selbstverstaendnis):
- abi_adapter.hpp:380-478 run_workload (4-Segment-do_batch), :483-563 run_workload_segmented (V1-POD), :583-877 run_workload_segmented_v2 (18 Segmente).
- Getrieben werden mess-eigene STATISCHE Kerne auf einem synthetischen Roh-Puffer lbuf (16384x48/64 B): scan_field_sum, serialize_scan, node_find_scan, index_org_scan, io_dispatch_scan, migration_decide_scan, filter_probe_scan, persistence_writeback_scan (z.B. abi_adapter.hpp:707-846). Diese *_scan-Funktionen sind statics der Achsen-Strategien (z.B. axes/layout/axis_05_memory_layout_soa.hpp:54), aber sie sind MESS-Sonder-Eintrittspunkte ("Zugriffsmuster ist das Achsen-Signal", :576-582), NICHT das Achsen-Interface, das die Gattungs-Funktionen verwenden.
- Live-Anbindung: drive_segment_latencies (perm_runner.hpp:351-357) hat KEINEN Live-Aufrufer (nur Doc-Kommentar :17-19 + Unit-Tests test_all19_segment_timer.cpp u.a.). Pfad A ist im Mess-Betrieb faktisch tot; die CSV-seg-Spalten kommen aus Pfad B (cache_engine_builder_iterator.hpp:265-266, :552).

(B) Pfad B — in-DLL, ueber die REALE Komposition (heutige seg_ns-Quelle):
- abi_adapter.hpp:1444-1714 fill_segment_timing_v3, ausgeloest durch tier_observe (:1721-1736, fixe Sequenz Observer-READ -> Timing -> Reset).
- Je Segment MISCHFORMEN dreier Vertragsarten: (i) echte Achsen-Interface-Ops der realen Komposition (T0 container_algorithm_.lookup :1486-1492; T1 ct_organ_.resolve :1493-1503; T2 map_organ_.resolve_offset :1504-1516; T3 pc_organ_.compress :1517-1524; T8 observe_critical_section :1571-1580; T15/T16 put/get bzw. should_flush :1633-1660; T17 observe_writeback :1661-1670), (ii) Mess-Huellen-Scans UEBER das Store-Backing der Gattung (store_observe_node_type/layout/serialization/value_handle/index_org/io_dispatch/migration/filter, :1525-1632 — Umweg ueber den Container, nicht das nackte Achsen-Interface), (iii) reiner Stats-READ statt Achsen-Op: T6 allocator = store_allocator_statistics()-Lesen (:1543-1554) — allocate/deallocate wird in Ebene 1 NICHT gemessen.

(C) Host-Seite (CEB) — Wallclock + PMC:
- run_observable_perm: perm_runner.hpp:194-216 — EINE steady_clock-Klammer um die ganze insert+lookup-Last -> total_ns (heutige "Gesamt-Wallclock").
- run_workload_perm: perm_runner.hpp:234-334 — Lastprofil ueber workload_orchestrator/run_workload_profile; JE Gattungs-Op einzeln getimt via two_phase_measure/abi_dur_ns (tier_observe_trace_abi.hpp:63-64, :110-180, :218-246) -> op_lat p50/p99 je {insert, lookup, erase, clear, scan, rmw} (perm_runner.hpp:95-114).
- PMC (#156): pmc_source.hpp:19-38 + linux_perf_pmc_source.hpp:217, :247 — Delta-Klammer um die GANZE Run-Phase (perm_runner.hpp:120-124, :303-307). PMC ist also heute eine Ebene-3-Klammer, keine Micro-/Achsen-Messung.
- Weitere Host-Treiber: host_measure_loop.hpp:36-72 (Settings x Wiederholungen, nur Observer, KEINE Wallclock je Ebene), node_value_measurement.hpp:35-87 (in-process, Observer-Projektion).

### 1.3 Falsch-Schnitt-Befunde (nummeriert, fuer Ledger-Nachtrag)

- B-1 Micro ohne Traeger: Tooling-id "micro" hat keinen kompilierten Effekt; Registry-Doku definiert Micro als PMC (measurement_tooling_registry.hpp:30) — F2-widrig.
- B-2 Pfad A = der vom Owner verworfene Schnitt: Achsen werden als Interface-Funktionen des Suchalgorithmus-Messtreibers behandelt (synthetische *_scan-Parallelwelt auf lbuf), nicht ueber ihr Achsen-Interface gemessen.
- B-3 Pfad B mischt Vertragsarten (1.2-B i/ii/iii): Ebene-1-Zeiten sind je Achse NICHT einheitlich "Achsen-Interface unter dem realen Algorithmus"; T6 misst gar keine Achsen-Op.
- B-4 Gattung verwendet Achsen teils NUR als Mess-Nebenwirkung: tier_insert treibt konstitutiv nur container_algorithm_ (search/node/layout/alloc-Kette, abi_adapter.hpp:886-907); T1/T2/T7/T8/T15/T16 laufen als Auto-Kopplung NUR unter COMDARE_MEASUREMENT_ON (:913-985) — im Release-Build existieren diese Achsen-Ops im Hot-Path nicht. "Gattungs-Funktionen VERWENDEN Achsen-Interfaces" ist im Ist nur fuer die konstitutive Store-Kette erfuellt.
- B-5 Schnitt-Regel verletzt: 54 Achsen-Header unter CE/libs/cache_engine/axes/ nutzen std::vector/std::map/std::unordered_map mit Default-Allokator (= generische OS-/libc-Allokation am Allokator-Achsen-Interface vorbei); Belege: axes/cache_traversal/axis_03b_cache_traversal_hash_lookup.hpp:247/:270, axes/lookup/axis_03a_search_algo_btree.hpp:452-453 (Liste per grep ableiten, nie handpflegen).
- B-6 DEFEKT (CONFIRMED, Mess-Verlust T17): abi_adapter.hpp:861 (Pfad A) und :1687 (Pfad B) kopieren nur `for i < 17` von 18 acc-Slots — acc[17] (persistence_target, gemessen :845-848 bzw. :1664-1670) wird NIE nach out->seg_ns[17] geschrieben und fehlt in total_ns; die Zeit fliesst still in seg_framework_ns (:871, :1699). Ebenso node_value_measurement.hpp:72-75 (`t < 17`). Die CSV schreibt aber 18 seg-Spalten (cache_engine_builder_iterator.hpp:557 + :563 iterieren kCompositionAxisNames.size()==18, axis_path_serialization.hpp:40-44) -> Spalte seg persistence_target ist immer 0 (nicht "n/a") = stiller Messwert-Verlust, verstoesst gegen die Ehrlichkeits-Doktrin.
- B-7 Ebenen unbenannt/unvollstaendig: E2 (op_lat) und E3 (total_ns, PMC-Klammer) existieren mechanisch, sind aber nicht als F2-Ebenen geschnitten/etikettiert; E1 als CEB-GEGENMESSUNG zur internen Micro fehlt konzeptionell (seg_ns ist DLL-intern und misst B-3-Mischvertraege).

---

## 2. Soll-Schnitt nach F2 (Interface-Vertraege)

### 2.1 Achsen-Interface = Concept-Kette (bestehende Heimat, kein Neubau)
Das Achsen-Interface ist die Funktionsmenge des jeweiligen Achsen-Concepts (Drei-Stufen-Kette Topic-Concept -> Achsen-Concept -> Permutations-Concept + CRTP-Basis; topics/axis.hpp:46-58 AxisConcept, topics/organ_axis.hpp:34-47, topics/<topic>/.../concepts/). SOLL: je Achse T0..T17 wird der VERTRAGSKERN als Single-Source-Tabelle festgeschrieben (neues Doku-Artefakt + static_assert-Haertung im Achsen-Concept), abgeleitet aus dem Ist:

| Achse | Achsen-Interface-Kern (Ebene-1-Messvertrag) |
|---|---|
| T0 search_algo | insert/lookup/erase/clear (std::map-aequivalent) |
| T1 cache_traversal | register_entry/resolve |
| T2 mapping | register_slot/resolve_offset |
| T3 path_compression | compress (+ prefix-Ops) |
| T4 node_type | Slot-/Node-Find-Zugriff (node-find) |
| T5 memory_layout | Feld-/Stride-Zugriff (record-scan ueber das reale Backing) |
| T6 allocator | allocate/deallocate (REALE Ops, kein Stats-READ) |
| T7 prefetch | prefetch-Hint je Descent (observe_prefetch_descent-Vertragskern) |
| T8 concurrency | acquire/release |
| T9 serialization | encode/decode ueber reale Records |
| T10 value_handle | access/deref |
| T11 index_organization | Index-Ordnung-Scan/Lookup |
| T12 io_dispatch | dispatch |
| T13 migration_policy | decide (+ migrate_step via IMigratableTier) |
| T14 filter | probe (+ insert) |
| T15 queuing_q1 | put/get |
| T16 queuing_q2 | should_flush/on_flush_complete |
| T17 persistence_target | stage/writeback |

Regeln: (a) None-/0-Overhead-Strategien = deklarierte Vergleichs-Nullpunkte (ehrlich, kein n/a-Fake — heutiges Muster bleibt); (b) je Slot AUSSCHLIESSLICH Achsen-Interface-Aufrufe der REALEN Komposition (kein synthetischer Parallel-Puffer, kein Store-Umweg, kein Stats-READ als Zeit-Surrogat).

### 2.2 Schichtenmodell SOLL (konsistent mit Ledger Abschn. 64-Schichten-Zuordnung)
- MICRO (im Tier-Binary, Pruef-Dock einkompiliert): die Achse ueber ihr Achsen-Interface durchmessen; intern deren achsen-spezifische Haupteigenschaften (Observer-Zaehler axis_stats + achsen-eigene Kenngroessen). Traeger bleibt der EINE konsolidierte Snapshot (I1).
- E1 CEB-Wallclock der ACHSEN-Interfaces unter jedem Algorithmus: Gegenmessung zur internen Micro. Realisierung: die CEB ORCHESTRIERT, die Zeitnahme ist im Tier einkompiliert (Ledger:3389-3391: Wallclock CEB-Seite "sofern einkompiliert"; Macro/Micro beidseitig ueber das Pruef-Dock) und reist ueber die bestehenden seg_ns[18]-Slots — deren Semantik wird auf den 2.1-Vertrag UMGEWIDMET (Werte-, nicht Layout-Aenderung).
- E2 CEB-Wallclock der GATTUNGS-Interfaces: heutiges op_lat (je tier_insert/lookup/erase/clear/scan/rmw, two_phase) wird explizit Ebene 2.
- E3 CEB-Wallclock der Test-Last (Last-Frameworks/Benutzungs-Konfiguration): aeussere Klammer um den Profil-Lauf (heutiges total_ns-Analog); die PMC-Klammer bleibt hier verankert.
- Konsistenz-Invariante (P-MD3-Prinzip fortgefuehrt): Summe(E1-konstitutiv) <= E2 <= E3; jeder Rest EXPLIZIT benannt (framework/orchestration), Coverage gegen den je-Ebene kommensurablen Nenner.

### 2.3 Gattungs-Vertrag ("Suchalgorithmus-Interfaces VERWENDEN Achsen-Interfaces")
- Je (Gattungs-Funktion x Achse) eine deklarierte Rolle: KONSTITUTIV (die Funktion ruft das Achsen-Interface im Hot-Path — heute die Store-Kette search/node/layout/alloc) oder BEOBACHTEND (Mess-Organ, nur unter Messung-AN). SOLL: die Konstitutiv-Matrix wird hergestellt und dokumentiert; wo eine Achse im Hot-Path semantisch nichts beitraegt, bleibt sie ehrlich beobachtend mit eigenem E1-Treiber (Vergleichs-Nullpunkt) — F2 erlaubt das ("Achse ist NICHT eine Interface-Funktion des Suchalgorithmus"), verbietet aber, den Mess-Schnitt daran auszurichten.
- Achsen duerfen andere Achsen-Interfaces verwenden (Container ueberall) — Abhaengigkeitsrichtung dokumentieren (keine Zyklen; Allokator ist unterste Versorger-Achse).

### 2.4 Schnitt-Regel (Architektur-Auflage)
- In Achsen-Algorithmen keine generischen OS-Calls: Speicher NUR ueber das Allokator-Achsen-Interface (54-Dateien-Bestand B-5 abbauen); Sync-Primitive nur in der Concurrency-Achse; I/O nur in io_dispatch/persistence_target. Inline einkompiliert per Metaprogrammierung (CT-Dispatch, CRTP/Concept-Muster); std::variant verboten (einzige Ausnahme Hybrid-Tier-Stufe HINTER der CEB, Owner-E1 — von A8 unberuehrt).
- ext/-vendored Paper-Originalcode bleibt faithful; die Uebersetzung leistet der Adapter (EV-4, Owner bestaetigen).

### 2.5 Tooling-Neuzuordnung (byte-stabil)
WallClock = die 3 CEB-Ebenen · Macro = Gattungs-/Ende-zu-Ende (Observer + E2/E3) · Micro = Achsen-Interface intern. Die ids/Stempel-Token "wallclock"/"macro"/"micro" + Versionen v1.0.0 bleiben BYTE-STABIL (Stempel/golden/Legenden unberuehrt); nur Doku/Semantik-Kommentare ziehen nach (deprecaten, nie loeschen).

---

## 3. Byte-/golden-Wirkungs-Analyse

GOLDEN-NEUTRAL (kein Fenster noetig):
- Alle Aenderungen an Mess-TREIBERN und Host-Code: abi_adapter-Messpfade, perm_runner, workload_orchestrator, host_measure_loop, PMC-Verdrahtung — beruehren weder binary_id/kCompositionAxisNames/serialize-Pfad noch Codegen-Bytes noch POD-Layouts. golden-320 (Byte-Wache) und CRC-Anker 0x56F1B721C72DC10E bleiben unberuehrt.
- seg_ns-SEMANTIK-Umwidmung (2.2): reine WERTE-Aenderung im selben Layout (sizeof 1344, Assert observable_tier.hpp:160-162 unangetastet).
- Neue ABI-Flaechen NUR als additive Sub-Interfaces (L-74c-Muster wie IMeasurableWorkloadV2/V3, IMigratableTier: eigenstaendig, dynamic_cast, Alt-DLL-Degrade) — KEIN ABI-Major-Bump.
- CSV: Wire-Format 169 Felder (perm_runner.hpp:82-88) nur ADDITIV hinten erweitern; Reader akzeptiert Alt-Laengen (Q-9-Praezedenz). Alt-Mess-CSV = Archiv, nie loeschen.

FENSTER/BEACHTUNG (kein golden-Bruch, aber koordinationspflichtig):
- (a) JEDE Snapshot-POD-Erweiterung (z.B. per-Funktions-E1-Zeiten) = sizeof-Bruch + ABI-Major -> NICHT in A8; Bedarf in den EINEN E-24-ABI-Schritt falten (E-24 MUSS ohnehin VOR dem Voll-Bau-4-Trigger liegen, HY-D2-Kante).
- (b) Mess-WERTE aendern sich flaechig (E1-Neuvertrag, T17-Fix, S5-Scrub) -> dokumentierter Archiv-Schnitt der Alt-CSV (Struktur-Modernisierungs-Doktrin), CSV-Spalten-NAMEN stabil.
- (c) SEQUENZIERUNGS-KERN: abi_adapter.hpp + axes/-Header sind in JEDES Tier-Binary einkompiliert. Jede A8-Scheibe, die sie beruehrt, dreht die SHA512-Fingerprints -> das F7-Skip-Gate baut neu. LANDET A8 NACH dem Voll-Bau-4-Trigger, ist der komplette 12 x 2^17-Bestand (1.572.864 Binaries) neu zu bauen — exakt der von Owner-E3 ausgeschlossene Zustand. A8 (alle binary-beruehrenden Scheiben) MUSS vor dem Trigger liegen; die Bauplan-Zeile "Do 07.: Benchmarking-Schnitt parallel zum Trigger" kollidiert damit (Eskalation EV-5).
- (d) Tooling-/Achsen-Versions-Literale (v1.0.0) NICHT anfassen; Flag-Grammatik-Migration v1.0.0c laeuft separat im A13-M2/M3-Fenster.
- (e) Tests zementieren die alte Ordnung (3x real bei O-8): Fixture-Strings (z.B. test_striktheit_scan_kernel_purity.cpp, test_all19_segment_timer.cpp) BEWUSST nachziehen, nie stumm gruen buegeln.

---

## 4. Migrationsplan in landbaren Scheiben (mit Gates)

Gate-Grundkadenz JEDER Scheibe: lokaler Voll-Bau + 321 Tests gruen (Dual-Weg CI UND lokal, offizielle CMake/ctest-Targets) · golden-320-Byte-Wache gruen · J-Kette N=316 (NUR mit V32_ENABLE=ON) · kein ABI-Major, sizeof-Asserts unveraendert · literaler Output je Verifikation · Working-Tree-Freeze nach Paketmeldung.

- S1 (SOFORT, klein, defekt-getrieben): T17-Verlust-Fix — die drei `< 17`-Schleifen auf kV3AxisCount heben (abi_adapter.hpp:861, :1687; node_value_measurement.hpp:72-75) + Regressionstest "18-Slot-Vollzaehligkeit gegen kV3AxisCount, nie Literal" + Test, dass Sum(seg_ns)+framework==run_total die T17-Zeit enthaelt. Werte-Aenderung dokumentieren (Alt-CSV-Archiv-Notiz). GATE: Grundkadenz.
- S2 (Ebenen-Etikettierung, host-only): E2/E3 explizit machen — op_lat = E2, aeussere Lauf-Klammer = E3 (run_observable_perm/run_workload_perm), PMC als E3-Klammer deklarieren; CSV nur ADDITIV (Ebenen-Summen-Spalten hinten, Reader-Toleranz-Test), Doku-Kommentare an den Messstellen auf F2-Vokabular. GATE: Grundkadenz + CSV-Feldzahl-Toleranz-Test.
- S3 (E1/Micro-Neuschnitt in der DLL, Kern der Regression): fill_segment_timing_v3 wird DER EINE E1-Treiber; je Segment NUR 2.1-Vertragsops der REALEN Komposition (T6: echter allocate/deallocate-Churn ueber den Kompositions-Allokator statt Stats-READ; store_observe_*-Umwege durch direkte Achsen-Interface-Ops ersetzen, wo sie Gattungs-Umwege sind); Vertrag je Segment als Kopf-Kommentar + Concept-static_asserts. Pfad A (run_workload/segmented/v2 + drive_segment_latencies) DEPRECATEN (Kandidatenliste Abschluss-Aufraeumpass; Entfernung erst am Ende, Doku bleibt). GATE: Grundkadenz + Strategie-Differenzierungs-Tests je Achse (distinkte Zeiten je Strategie-Wahl, Nullpunkte deklariert) + Coverage-Abnahme Sum(seg)+framework==run_total.
- S4 (Gattungs-Vertrag): Konstitutiv-Matrix (2.3) herstellen und pruefen — je Gattungs-Funktion dokumentieren, welche Achsen-Interfaces sie konstitutiv verwendet; Release-Pfad-Neutralitaet fuer die konstitutive Kette per Wallclock-Beweis (Abschn.-61-Release-Modus) belegen; beobachtende Achsen ehrlich deklarieren. GATE: Grundkadenz + Release-Verhaltens-Beweis.
- S5 (GROSS, familienweise): OS-Call-/std-Container-Scrub der 54 Achsen-Header (B-5) — je Organ-Gruppen-Scheibe (01_read_path, 02_layout, 03_placement, 04_execution, 05_write_path_io); Speicher ueber die Allokator-Achse, inline CT, kein std::variant; Datei-Liste je Scheibe AUS DEM GREP abgeleitet. GATE je Familie: Grundkadenz + Konformitaets-GTest der Familie + Perf-Sanity (keine 0-/Phantom-Zeiten).
- S6 (Abschluss/Doku): Tooling-Semantik-Nachzug (measurement_tooling_registry-Kommentare, Director-Lane-Kommentare, plan_legend), Ledger-Nachtrag (Befunde B-1..B-7 + Vollzug), Thesis-Anschluss (Fakten-Kanon:311: SOLL steht in der Thesis, Ist-Vermerk aufloesen). GATE: Doku-only, CI gruen.

Reihenfolge/Einordnung: S1 sofort (Defekt); S2-S4+S6 = A8-Kern, trigger-blockierend; S5 VOR dem Trigger PFLICHT (3-c-Neubau-Argument), familienweise parallelisierbar. Zeitbudget-Kollision mit Bauplan-Do-07. -> EV-5 an Owner/Manager.

---

## 5. Auflagen fuer Worker (bindend)

1. KEIN ABI-Major-Bump, keine POD-Layout-Aenderung; sizeof-/static_assert-Wachen (1344) unangetastet. Neue ABI-Flaechen nur als additive Sub-Interfaces nach L-74c-Muster. POD-Bedarf -> STOPP + Eskalation (E-24-Fenster).
2. golden-Tabu: binary_id, kCompositionAxisNames, serialize_composition_path, Codegen-Ausgaben, CRC-Anker NICHT anfassen; golden-320 + J-Kette (V32_ENABLE=ON) je Scheibe literal belegen.
3. CSV: Spalten nur ADDITIV hinten; Wire-Laengen-Toleranz im Reader; Alt-Mess-CSV nie loeschen (Archiv); Fehler-Zellen "failed"/"n/a", NIE stille 0 (B-6 ist das Negativ-Beispiel).
4. Tooling-/Versions-Literale byte-stabil ("wallclock"/"macro"/"micro", v1.0.0); Flag-Grammatik-Migration NUR im A13-M2/M3-Fenster, nicht in A8.
5. CT-Doktrin: kein Runtime-Switch, kein std::variant (Ausnahme Hybrid-Stufe irrelevant fuer A8), CRTP+Concept, GoF-Muster; Konzept-Haertung per static_assert statt Laufzeit-Checks.
6. Ehrlichkeit: None-Strategien = deklarierte Nullpunkte; keine erfundenen Werte; kein Erfolgs-Haken ohne literalen Output; jede Messwert-Semantik-Aenderung im Scheiben-Log dokumentieren.
7. Tests: zementierende Fixtures BEWUSST nachziehen (Commit-Notiz je geaendertem Fixture); neue Wachen gegen kV3AxisCount/kCompositionAxisNames ableiten, NIE Zahlen-Literale.
8. Dual-Weg je Scheibe (CI und lokal, offizielle Targets, keine Behelfswege); Datei-Listen (54er-Bestand) aus grep ableiten, nie handgepflegt.
9. Prozess: vor jeder Scheibe Ledger + dieses Dossier lesen; je Paket ultracode-Planung; Working-Tree-Freeze nach Paketmeldung mit literalem diff-stat; ASCII-only-Kommentare + Selbstcheck; Doku nur deprecaten, nie loeschen.
10. Scope-Grenzen: KEIN Beruehren von Stempel-/Lager-Logik (A13/A2), KEINE Registry-XML-Aenderung, KEIN Overleaf/Thesis-Haupttext (S6 nur Impl-Doku + Ledger; Thesis-Anschluss als Vorlage an den Text-Strang).

---

## 6. Befund-Uebergabe

B-1..B-7 (Abschn. 1.3) sind als Ledger-Nachtrag vorzumerken (A11-Sammelpaket); B-6 ist ein CONFIRMED-Defekt mit stillem Messwert-Verlust (T17-Spalte immer 0 statt Messwert) und Vorrang (S1).

