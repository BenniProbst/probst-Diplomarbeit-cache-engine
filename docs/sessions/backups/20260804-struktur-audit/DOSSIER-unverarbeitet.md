# DOSSIER: Struktur-Audit der Projekt-Einteilung (SYNTHESE S1-S4)

Datum: 2026-08-04 | Synthese-Los des Struktur-Audits wf (Owner-Auftrag: "Einteilung sauber+korrekt?")
Objekt: ce development 19f27223 (E-24-b-Merge) == wt-e24 Branch e24-b HEAD 54521360
(Tree-Identitaet 3c9945c3 per rev-parse bewiesen, S2). READ-ONLY: keine Code-Aenderung,
kein Commit, kein Build; S3-Solo-Proben g++ -fsyntax-only Scratchpad-only.
Pfade relativ zu libs/cache_engine/ sofern nicht anders benannt; super = probst-diplomarbeit-cache-engine.
MASSSTAEBE (bindend, nicht neu erfunden): (1) Baseline-Layering IN STEIN (n -> n-1);
(2) WAS/WIE (ce=Framework/WIE, super=Experiment/WAS, PROJECT_LAYER_MAP.md REV 7.6);
(3) FINALES Zwei-Ebenen-Modell (Owner-KERN NACHTRAG 4+5, LEDGER:3836/:3838);
(4) deklarierte M3/E-24-Layer-Kanten; (5) G8-Negativliste
(ce docs/architecture/20260804-e24_g8_negativliste_gesperrte_abi_flaechen.md).
ASCII-only.

---

## 1. GESAMT-VERDIKT

**SCHNITT-FEHLER-VORHANDEN -- genau EINER; alles Uebrige STRUKTUR-OK oder Schoenheitsfehler.**

Begruendung (ehrlich): Die Aufwaertskante `anatomy/container_framework.hpp:37 ->
builder/experiment_tree/genus_binding_traits.hpp` ist die EINZIGE anatomy->builder-Kante des
Repos (Synthese-Nachweis am Objekt 04.08.: grep ueber anatomy/ liefert exakt diesen einen
Treffer) und verletzt Massstab 1 (Baseline-Layering in Stein: die Gattungs-/Genus-Ebene
referenziert die darueberliegende Bau-Orchestrierung; Verzeichnis-Zyklus, da
genus_binding_traits.hpp:13-19 SIEBEN anatomy-Header zurueck-inkludiert; Zahlwort per
Nachbesserung B3 korrigiert, am Objekt gezaehlt). Sie ist DEKLARIERT
(Include-Kommentar benennt die Bau-Bindung), datei-zyklus-frei und compile-sauber
(S3: 6/6 Solo-TUs PASS, DFS ueber 255 Knoten/541 Kanten ohne Include-Zyklus) -- aber eine
deklarierte Verletzung bleibt eine Verletzung; die Heilung (Traits-Split) waere source-only,
faellt jedoch seit C11 unter G8 (container_framework = ABI-sichtbare Gattungs-Flaeche) und
braucht deshalb ein OWNER-FENSTER, nie eine stille Ausfuehrung. Alle uebrigen Befunde sind
STRUKTUR-OK (Zwei-Ebenen-Modell vollzogen, Matrix 5x9 vollstaendig -- per Nachbesserung B1
um Modul-ABI-Makros + Kompositionen erweitert, beide Klassen je Genus belegt --, Achsen typ-seitig sauber
unter den Genera, WAS/WIE-Trennung haelt, CT-rekursiv/RT-imperativ bewiesen) oder
Schoenheitsfehler-Klasse (Aufraeumpass-Posten 39-53, Abschnitt 4; 53 = B1-Nachtrag).

Verdikts-Skala des Auftrags: SAUBER / SAUBER-MIT-SCHOENHEITSFEHLERN / SCHNITT-FEHLER-VORHANDEN.
Der eine echte Fehler ist bekannt-deklariert und heute gesperrt -- das aendert die KLASSE nicht
(Massstab ist das Layering, nicht die Bequemlichkeit), wohl aber die MASSNAHME (Fenster statt Fix).

---

## 2. EBENEN-MATRIX: 5 Genera x 9 Artefakt-Klassen (+ Graph-Zeile)

Erhoben von S2 am Objekt, hier konsolidiert; per Nachbesserung B1 (04.08.) um ZWEI zuvor
nicht getragene per-Genus-Artefakt-Klassen erweitert (Modul-ABI-Makro, Komposition -- am
Objekt nachverifiziert). VOLLSTAENDIG jetzt mit dieser Herleitung -- die urspruengliche
5x7-Zusicherung war unter-hergeleitet (B1), OHNE versteckten Luecken-Defekt: beide
nachgetragenen Klassen sind je Genus belegt.
Ebene 1 (Gattung) per anatomy_base.hpp:55-57: Map=0, Container=1, Graph=2 (Stub);
gattung_of :125-134 bildet SA->Map, Set/Sequence/Adapter/View->Container.

| Genus (Gattung) | Anatomie | Komposition (B1) | ABI-Adapter | Tier-IF V1 | Tier-IF V2 | Dock | Perm-Engine | Wire-Form | Modul-ABI-Makro (B1) |
|---|---|---|---|---|---|---|---|---|---|
| SearchAlgorithm (Map) | search_algorithm_anatomy.hpp:35 | AdHocComposition anatomy/composition_factory.hpp:67 (ad-hoc, 18 Achsen; KEINE eigene Datei -- s. Asymmetrie-Note) | abi_adapter.hpp:176 | IDriveableTier idriveable_tier.hpp:42 | AEQUIVALENT: IObservableTier V3 observable_tier.hpp:50/:133-134/:167 + IMeasurableWorkloadV2/V3 measurable_workload.hpp:68/:127 (siehe Luecken-Note) | search_algorithm_dock.hpp:26 | search_algorithm_permutation_engine.hpp:71 | ObserverSnapshot axis_stats[18][8], 1344 B | abi/anatomy_module_abi_v1.hpp:50/:72/:84 |
| Set (Container) | set_anatomy.hpp:114 | SetComposition anatomy/set_composition.hpp:20 (eigene Datei) | set_abi_adapter.hpp:25 (+erbt ISetTierV2 + ISetAlgebraTier) | ISetTier set_tier.hpp | ISetTierV2 set_tier_v2.hpp:98 | set_dock.hpp:100 | set_permutation_engine.hpp:61 | SetObserverAggregate<13> set_tier_v2.hpp:48, 1008 B | abi/set_module_abi_v1.hpp:13 |
| Sequence (Container) | sequence_anatomy.hpp:81 | SequenceComposition anatomy/sequence_composition.hpp:37 (eigene Datei) | sequence_abi_adapter.hpp:21 | ISequenceTier sequence_tier.hpp:32 | ISequenceTierV2 sequence_tier_v2.hpp:88 | sequence_dock.hpp:96 | sequence_permutation_engine.hpp:58 | GenusObserverAggregate<Sequence,9> sequence_tier_v2.hpp:41/:53, 720 B | abi/sequence_module_abi_v1.hpp:14 |
| Adapter (Container) | adapter_anatomy.hpp:250 | AdapterComposition EINGEBETTET anatomy/adapter_anatomy.hpp:165 (KEINE eigene Datei -- s. Asymmetrie-Note) | adapter_abi_adapter.hpp:33 | IAdapterTier adapter_tier.hpp | IAdapterTierV2 adapter_tier_v2.hpp:89 | adapter_dock.hpp:97 | adapter_permutation_engine.hpp:76 | <11> adapter_tier_v2.hpp:38, 864 B | abi/adapter_module_abi_v1.hpp:23 |
| View (Container) | view_anatomy.hpp:69 | ViewComposition anatomy/view_composition.hpp:53 (eigene Datei) | view_abi_adapter.hpp:23 | IViewTier view_tier.hpp:31 | IViewTierV2 view_tier_v2.hpp:73 | view_dock.hpp:100 | view_permutation_engine.hpp:58 | <5> view_tier_v2.hpp:36, 432 B | abi/view_module_abi_v1.hpp:12 |
| -- (Graph, STUB) | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |

- Alle Wire-Formen via GenusObserverAggregate<G,N> (genus_observer_aggregate.hpp:119-120)
  mit standard_layout/trivially_copyable/sizeof-Pins.
- Dock-Registry registriert alle 5 (pruef_dock_registry_default.hpp:39-44).
- MODUL-ABI-MAKROS (B1-Spalte): 5/5 am Objekt vorhanden -- COMDARE_DEFINE_ANATOMY_MODULE
  [SA, +_ADHOC :72 +_ADHOC_BUILDVARIANT :84] / _SET_ / _SEQUENCE_ / _ADAPTER_ / _VIEW_MODULE;
  G8 Par.1.1 fuehrt exakt diese 5 Dateien als gesperrte Flaeche ('Modul-Makros', G8-Zeile 38)
  => strukturtragend, gehoert in die Matrix.
- KOMPOSITIONS-ASYMMETRIE-NOTE (B1-Spalte, -> Posten 53): Platzierung uneinheitlich --
  Set/Sequence/View als EIGENE anatomy/-Dateien (set_composition.hpp:20,
  sequence_composition.hpp:37, view_composition.hpp:53), AdapterComposition EINGEBETTET in
  anatomy/adapter_anatomy.hpp:165, SA ohne Genus-Kompositions-Datei (AdHocComposition,
  anatomy/composition_factory.hpp:67). Beide Klassen je Genus BELEGT (kein Luecken-Defekt),
  nur die Platzierung asymmetrisch und bisher unerfasst.
- TEST-SEITEN-NOTE (B1, mild): genus_module_{set,sequence,adapter,view}.cpp-Fixtures ohne
  SA-Pendant -- SA-Modul-Pfad getestet via tests/unit/mock_permutation_module.cpp +
  auto_emitted_perm_module.cpp (am Objekt vorhanden); Asymmetrie dokumentiert, kein Befund.
- GRAPH-ZEILE = beabsichtigte Luecke (Owner-KERN NACHTRAG 4: "derzeit stub"): constexpr-Bau-Wache
  weist Graph ab (genus_build_admission.hpp:189-195); der EINZIGE implementierte Graph-Code
  (GraphBfs) liegt im Virus-Zweig AUSSERHALB beider Ebenen (G8 Par.5.2, P11-B-Verdikt; S2-grep
  deckungsgleich: AnatomyGattung::Graph nur anatomy_base.hpp + Admission-Wache).
- MARKIERTE LUECKEN-NOTE (SA-Zeile, V2-Zelle): kein IDriveableTierV2 -- die Zelle ist durch das
  VOR C6 existierende V3-Schema besetzt (Design-Asymmetrie, KEINE Luecke); als bewusste
  Matrix-Entscheidung bisher NIRGENDS kommentiert -> Posten 47.
- C7-Vollzug an der Matrix: gattung() an allen 4 Container-Anatomien via gattung_of abgeleitet
  (set_anatomy.hpp:137, sequence_anatomy.hpp:93, adapter_anatomy.hpp:263, view_anatomy.hpp:82);
  SA ohne gattung()-Member ist auflagenkonform (C7-7-Scope = die 4 Container-Genera);
  IAnatomyBase BEWUSST ohne gattung() (anatomy_base.hpp:227-229, C7-6).

---

## 3. VERZEICHNIS-EINTEILUNG (IST, S1) -- Kurzreferenz

- anatomy/ (54 hpp) = Gattungs-/Genus-Ebene: 5 Anatomien + Kompositionen + Permutation-Engines
  + ALLE ABI-Adapter + ALLE Tier-Sub-Interfaces + Wire-PODs + container_framework.hpp.
- include/cache_engine/abi/ (25 hpp) = Modul-ABI-Grenze: extern-C-Makros je Genus, Loader-Decl,
  Fingerprint/Stempel, System-Achsen-Ordnung.
- axes/ (340 hpp) + topics/ (422 hpp) = EINE Bausteine-Schicht in ZWEI Wurzeln (241/288
  bidirektionale Kanten; historisch -- Posten 43, NACH Abgabe).
- builder/ (150 Dateien) = Bau-/Mess-Orchestrierung (WIE): experiment_tree, anatomy_commands,
  pruef_dock, bestandslog, artifact_transport, build_orchestrator, anatomy_module_loader,
  commands (GEPARKTE V32-Insel).
- include/cache_engine/measurement/ (~60 hpp) = host-seitige System-Achsen + FK-7/FK-8 +
  Mess-Grundtypen; profile_facade/ = oberste Fassade; src/ = Basis-Kern (permutations, sha512,
  concepts -- abwaerts-Basis MIT genau EINER deklarierten Bausteine-Kante:
  src/concepts/axis_original_code_mixin_base.hpp:27 -> ../../topics/axis_base.hpp, s. Par.5
  B2-Nachtrag; KEIN Doppel zu builder/permutation_loop).
- Repo-Ebene: apps/ = CLI-Frontends (cache_engine_builder = das EINE XML-Programm),
  tools/ = Generatoren/Wartung, tests/ = 374 Test-Dateien + Fixtures.

---

## 4. BEFUND-LISTE je Klasse (OK / SCHOENHEITSFEHLER -> Posten / ECHTER SCHNITT-FEHLER -> Fenster)

Klassifizierungs-Kanon: STRUKTUR-OK = Massstab erfuellt; SCHOENHEITSFEHLER = Fehlplatzierung/
Prosa/Buchhaltung ohne Layering-Bruch der tragenden Richtung -> Abschluss-Aufraeumpass
(Nummern FORTGESCHRIEBEN ab 39, Anschluss an G8 Par.6 Nr. 33-38 -- nie neu nummerieren);
ECHTER SCHNITT-FEHLER = Layering-/Ebenen-Bruch -> benanntes Fenster.

### 4.1 ECHTER SCHNITT-FEHLER (1)

**SF-1 -- anatomy->builder-Aufwaertskante (Kanten-Richtung gegen Baseline-Layering):**
`anatomy/container_framework.hpp:37` inkludiert
`builder/experiment_tree/genus_binding_traits.hpp` (einzige Kante dieser Richtung;
Synthese-grep 04.08. am Objekt bestaetigt). Gegenrichtung: genus_binding_traits.hpp:13-19
inkludiert 7 anatomy-Header zurueck (anatomy_base, composition_factory,
search_algorithm/adapter/set/sequence/view_anatomy -- SIEBEN, Zahlwort-Fix B3; die
Dateiliste war schon immer die richtige) => Verzeichnis-Zyklus
anatomy<->builder/experiment_tree; KEIN Datei-Zyklus (S3-DFS-Beweis). Genutzt werden
GenusBound (:59) + GenusBindingTraits (:86-97) -- Kern der C7-Formgebung (Gattung als
ABI-Flaeche ueber dem type_traits-Re-Export, Gattungs-Dossier Par.5).
- FENSTER-VORSCHLAG (NICHT still ausfuehren): Traits-Split -- Interface-Anteil
  (slot_count/name/axis_names) nach anatomy, Bau-Bindung (CompositionFor/AnatomyFor) bleibt
  builder. Source-only am heutigen Ist, aber container_framework ist seit C7/C11 ABI-sichtbare
  Flaeche => G8-Sperre; Aufhebung NUR per Owner-Entscheid (G8 Par.0). Bis dahin: benannter Posten
  im Aufraeumpass-Register + Owner-Vorlage im naechsten Entscheidungs-Block. Kein
  Vor-Anker-Bedarf (die Kante ist seit dem b-Teil gebaut, golden-320 je Commit gruen --
  der Fehler ist strukturell, nicht funktional).

### 4.2 STRUKTUR-OK (Auswahl der explizit geprueften Punkte)

| Punkt | Beleg |
|---|---|
| Zwei-Ebenen-Modell vollzogen (C7) | anatomy_base.hpp:49-58 (Map=0/Container=1/Graph=2, Werte-TABU), gattung_name :61-68, gattung_of :125-134; ContainerGattungsKern {Identitaet+observe_axes+size} + clear gestuft mit View-Ausnahme (container_framework.hpp:190-199, :170-172); ElementTypeFor ABGELEITET (:100-116); Self-proving Asserts :121-129 |
| C7-4 Map-Kern-Benennung | idriveable_tier.hpp:23-34 (de-facto Map-Gattungs-Kern BENANNT, Reichweite als offener Entscheid deklariert) |
| C7-6 Wire ohne Gattungs-String | module_gattung host-seitig (anatomy_base.hpp:161/:233); kein Gattungs-String/-Feld in include/cache_engine/abi/ (S2-grep leer) |
| FK-8 Manager-Entscheid umgesetzt | axis_error.hpp:53-58 (Etiketten BELASSEN + Kommentar-Heilung), Nummern 5/6 gepinnt :424-425 |
| genus_observer_aggregate.hpp gehoert nach anatomy/ | inkludiert nur anatomy_base.hpp (:45) + std; ALLE Wire-PODs liegen in anatomy/; G8 Par.1.2 pinnt exakt diesen Pfad; abi->anatomy-Richtung (0 Gegenkanten) bliebe bei Umzug gebrochen -- E-24-Frage (b) beantwortet: KEIN Umzug |
| pruef_dock-Neubauten | alle Kanten abwaerts/builder-intern (sequence_dock.hpp:36-44; dock_error_classification.hpp:36-39); FK-7 NEBEN dem HY-D2-Vertrag, exakt G8 Par.1.7 |
| cross_genus-Zweiteilung | Bauformen anatomy/cross_genus_organ.hpp (:34-38 nur anatomy-intern), Opt-in-Registries getrennt builder/experiment_tree/cross_genus_composition.hpp (:24-30), NICHT in permutation_axes.xml (golden-320-neutral by construction, Kopf :25-31) |
| Achsen typ-seitig UNTER den Genera | 0 Referenzen AnatomyGattung/AnatomyGenus in axes/ + topics/ (S2-grep leer); Include-Richtung anatomy->axes/topics (Ausnahmen = Posten 40/41) -- exakt NACHTRAG 5 |
| organ_concept-Layer-Entscheid | einziger Projekt-Include anatomy_base.hpp (organ_concept.hpp:39; Deklarations-Block :24-31 -- Zitat-Drift S1/S3 hiermit aufgeloest, siehe Par.8) |
| Deklarierte Kanten einbahnig | abi->axes (subaxis_valueset_segment.hpp:25-27, Rueckkante leer), bestandslog->abi exakt 3 Stellen (lager_baum_writer.hpp:52, bestandslog_index.hpp:26, bestandslog_factory.hpp:26; Rueckkante leer), abi->anatomy (Modul-Makros; anatomy->abi = 0) |
| Solo-Uebersetzung + Zyklen-Freiheit | S3: 6/6 PASS (g++ 15.3.0 -std=c++23 -fsyntax-only, Flags literal aus build.ninja); DFS 255 Knoten/541 Kanten: keine Include-Zyklen |
| Test-Gate | ctest -N literal 'Total Tests: 377' (build-e24, HEAD 54521360); alle aus tests/unit(+thesis_tiere); integration/generic/module_specific = deklarierte Phase-4.B-Skelette |
| e24-TU-Namen | 37 test_e24_* durchgaengig test_e24_c<N>[v]_<thema>; kein c8-TU konsistent (C8 via C10-Wachen geprueft) |
| Doku-Orte | ce docs/architecture = Framework-SOLL (G8, A8, A9, E24-ABI-Dossier), super docs/sessions = Planung -- Doku-Policy 20.07. eingehalten |

### 4.3 SCHOENHEITSFEHLER -> Aufraeumpass-Posten (fortgeschrieben ab 39)

| # | Kandidat | Quelle | datei:zeile / Kommando |
|---|---|---|---|
| 39 | abi->builder-Altkante + Fehlplatzierung: `include/cache_engine/abi/cache_engine_execution_engine_adapter.hpp:14-16` inkludiert builder/commands/{execute_engine_command,execution_result,workload}.hpp; kein Modul-ABI-Baustein, konzeptionell Facade-Adapter im falschen Ordner. GEPARKTE V32-AUSNAHME (i_command.hpp:2-7, #267, default OFF). MASSNAHME: Entfernung der V32-Insel (builder/commands + Adapter) mit FRISCHEM 0-Konsumenten-Beweis am dann-Ist (heute am Objekt, B5-nachverifiziert: NUR 2 Kommentar-Referenzen builder/commands/i_command.hpp:3 + execute_engine_command.hpp:3 sowie 1 Test-TU builder/commands/tests/test_engine_adapters.cpp:6 -- totes Blatt ohne Rueckkante, Kur=Entfernung) -- deprecated-Code-Doktrin. Kein Fenster (keine G8-Flaeche; B5-Gegenprobe: 'execution_engine_adapter' hat 0 Treffer in der G8-Negativliste). | S1-V2 + S3-Nebenbefund (deckungsgleich, EIN Posten) | :14-16; i_command.hpp:2-4 |
| 40 | Achsen-Bausteine im Gattungs-Verzeichnis: Policy-Concepts/Default-Policies liegen in anatomy/*_composition.hpp, topics zieht aufwaerts -- view_registries.hpp:7 + view_policies.hpp:11 -> anatomy/view_composition.hpp; axis_growth_registry.hpp:7 + axis_growth_policies.hpp:12 -> anatomy/sequence_composition.hpp (Include-Kommentar deklariert 'ebenfalls Teil der Achse'); axis_command_base.hpp:9 -> anatomy/observer_aggregate.hpp. Kein Zyklus, CT-only; Flaechen G8-gesperrt (Par.1.2/Par.1.6) => nur Doku/Aufraeumpass; ZIEL-ORT OFFEN (Par.9 Punkt 5) | S1-V3 | topics/view/view_registries.hpp:7 u.a. |
| 41 | organ_location.hpp (dependency-freies Blatt-Utility, :18-19 nur std) liegt in anatomy/, wird von 79 Bausteine-Dateien AUFWAERTS inkludiert (59 axes + 20 topics; einzige axes->anatomy-Treffer-Klasse). Praktisch harmlos; platzierungs-logisch unter/neben die Achsen-Schicht. G8 Par.1.6 (binary-beruehrend via Codegen) => fruehestens Aufraeumpass, ggf. NACH Abgabe mit 43 buendeln | S1-V4 | anatomy/organ_location.hpp; z.B. axes/path_compression/axis_02_path_compression_byte_wise.hpp:15 |
| 42 | builder/-Duenn-/Stub-Verzeichnisse: permutation_engine/, measurement_matrix/, in_memory_measurement_buffer/ (je NUR CMakeLists.txt; KEIN Inhalts-Doppel zum measurement-Header) + builder/measurement/ (nur thread_pinning.hpp -- Ziel-Einordnung offen, Par.9 Punkt 6) | S1-V6 | builder/* |
| 43 | **NACH ABGABE, eigenes Fenster (binary-beruehrend!):** axes/ vs topics/ Doppel-Wurzel EINER Schicht, 11 thematische Doppel-Namen (alloc/allocator, filter_axis/filter, node/nodes, cache_traversal/traversal, io_dispatch/io, layout/memory_layout, migration_policy/migration, prefetch_axis/prefetch, serialization_axis/serialization, telemetry_axis/telemetry, value_handle_axis/value_handle), 241/288 bidirektionale Kanten. G8 Par.1.6: 340 axes-hpp EINKOMPILIERT; header_include-Pfade reisen im per-Organ-Codegen => NICHT vor dem Anker | S1-V5 | axes/ + topics/ |
| 44 | Terminologie-Sweep-ERWEITERUNG (eigener Posten NEBEN 36): Muster `<Genus>-Gattung\|SA-Gattung\|Ebene-2-Gattung` = 176 Treffer (libs 106, tests 70) + 'fuenf/5 Gattungen'-Zaehlweise = 18 Treffer -- Posten 36 deckt nur das 29er-grep 'SearchAlgorithm-Gattung'. PFLICHT-EINSCHLUSS der >=26 Treffer in NACH-Dossier-Dateien (b-Teil-Reproduktion: 4x *_tier_v2.hpp, genus_observer_aggregate.hpp:106, set_tier_algebra.hpp, view_policies_observable.hpp, growth_policy_observable.hpp; ferner container_framework.hpp:162, genus_build_admission.hpp:16, genus_conformance_gate.hpp:9, organ_concept.hpp:572, test_e24_c3_cross_genus.cpp:304). Datei-Liste IMMER aus grep, nie handgepflegt. Klasse K1: compile-/golden-/ABI-neutral. KOMMANDOS LITERAL (B6, bindend ist das Kommando -- G8-Vorbild; reproduziert 04.08. am HEAD 54521360, ab Repo-Wurzel wt-e24): `grep -rEn --include='*.cpp' --include='*.hpp' "(Set\|Sequence\|Adapter\|View)-Gattung\|SA-Gattung\|Ebene-2-Gattung" libs/` = 106; dito `tests/` = 70 (Summe 176); `grep -rEn --include='*.cpp' --include='*.hpp' "(fuenf\|5) Gattungen" libs/ tests/` = 18 (case-sensitiv). OHNE den cpp/hpp-Filter traegt tests/ 74 (+3 tests/unit/CMakeLists.txt, +1 tests/unit/thesis_tiere/README.md) -- der Filter gehoert zum Kommando | S2 + B6-Reproduktion | Kommandos links literal |
| 45 | Stale-Zahlen-Kommentare (gleiche Klasse wie C11-OP-9, dort NICHT gezogen): observable_tier.hpp:15 ('axis_stats[17][8] + seg_ns[17]' -- Ist kV3AxisCount=18, :50) + :17 ('aktuell Major 6' -- Ist 8, anatomy_module_abi_v1_decl.hpp:89) + anatomy_base.hpp:224 ('Pflicht 17 ... andere Gattungen' -- Ist 18/ORG-18, 'Gattungen' ist Ebene-2-Sprache) | S2 | s. links |
| 46 | G8-Par.1.2-Dateitabelle FORTSCHREIBEN (Doku-only, sofort moeglich -- G8 ist per Selbstdeklaration fortzuschreiben): die 4 *_tier_v2.hpp (+sizeof-Pins), set_tier_algebra.hpp (ISetAlgebraTier quert die Modul-Grenze, geerbt vom SetAbiAdapter set_abi_adapter.hpp:25), measurable_workload.hpp (IMeasurableWorkload/V2/V3 + Latenz-PODs, ABI-Asserts :57-60/:117-118) namentlich als gesperrte Flaechen nachtragen | S2 | G8 Par.1.2 |
| 47 | SA-Matrix-Asymmetrie KOMMENTIEREN: V2-Zelle durch IObservableTier-V3-Aequivalent besetzt (kein IDriveableTierV2) -- bewusste Entscheidung, nirgends dokumentiert. Kommentar-Kandidat, kein Baubedarf | S2 | observable_tier.hpp Kopf |
| 48 | e24-Label-Nachzug: nur 18/37 test_e24_*-Tests tragen Label 'e24'. Zaehlung (B4-reproduziert): 4 c6v (:1670, 'e24;c6v') + 7 c6 + 5 c7 (:1707, 'e24;c6;c7') + 2 c10 (:3374/:3383) = 18; OHNE e24: c0-c5, c9_fk5, c10_g6 (:1580/:1635/:1796/:1819 -- die label-lose C5-FK7-Zeile liegt bei :1819, NICHT im frueher zitierten Bereich :1794-1817; C4-Dock :1796; Zeilen-Fix B4). Labels sind CI-Filter, keine ABI-Flaeche | S4 + B4-Praezisierung | tests/unit/CMakeLists.txt:1580/:1635/:1670/:1707/:1796/:1819/:3374/:3383 |
| 49 | 3 Testnamen ohne test_-Praefix (f15_compare_cli_smoke :1529-1531; m3v2_pmc_smoke, linux_perf_pmc_smoke aus thesis_tiere) -- gelabelte Legacy-Smokes, Umbenennung allenfalls im Aufraeumpass | S4 | tests/unit/CMakeLists.txt:1529-1531 |
| 50 | (super-Seite) messreihe_v32_parser.hpp (Kopf :28-31 DEPRECATED, abgeloest durch parse_experiment_profile in ce) + Test test_messreihe_v32_parser.cpp entfernen NACH golden-320-Subsumtions-Bestaetigung (Ledger:3597, V-5c; gehoert in die super-Kandidatenliste, nicht in G8 Par.6) | S4 | super Code/02_messung_driver/messreihe_v32_parser.hpp:28-31 |
| 51 | ce docs/INDEX.md (Stand 2026-05-08; listet architektur/audits/ledger-sections/plaene/sessions NICHT) + docs/architecture/INDEX.md (trackt nur 1 Datei von 2026-05) fortschreiben -- Doku-nie-loeschen, nur nachziehen | S4 | ce docs/INDEX.md |
| 52 | ce docs/architektur/ (dt. Schreibweise) traegt genau EINE Datei (20260613-ARCHITEKTUR-KORREKTUR-achsenaustausch-im-baum.md) neben dem Kanon-Ort docs/architecture/ -- Einzeldatei ueberfuehren (docs-only) | S4 | ce docs/architektur/ |
| 53 | Kompositions-Platzierungs-Asymmetrie (B1): Set/Sequence/View-Komposition als eigene anatomy/-Dateien (set_composition.hpp:20, sequence_composition.hpp:37, view_composition.hpp:53), AdapterComposition EINGEBETTET in anatomy/adapter_anatomy.hpp:165, SA via AdHocComposition (anatomy/composition_factory.hpp:67, keine eigene Datei). Beide Artefakt-Klassen je Genus belegt -- KEIN Luecken-Defekt, reine Platzierungs-Uneinheitlichkeit. Vereinheitlichung (z.B. AdapterComposition in eigene Datei) = Aufraeumpass; anatomy-Flaechen G8-beruehrt => nicht still, mit Include-Pfad-Vorsicht (genus_binding_traits.hpp:16 konsumiert adapter_anatomy.hpp AUCH fuer AdapterComposition) | Nachbesserung B1 | anatomy/adapter_anatomy.hpp:165; anatomy/composition_factory.hpp:67 |

---

## 5. INCLUDE-/LAYER-KANTEN-KARTE (bewiesene Richtungen)

Legende: `->` = Include-Richtung, Zahl = Kantenzahl (S1-Zaehlung am Objekt), [OK] = abwaerts
konform, [!] = Aufwaertskante.

```
profile_facade -> builder 42 | measurement 33 | topics 15 | abi 9 | axes 3 | anatomy 1   [OK, oberste Schicht]
builder        -> anatomy 65 | topics 48 | abi 19 | measurement 18 | axes 12             [OK]
  bestandslog  -> abi EXAKT 3 (lager_baum_writer.hpp:52, bestandslog_index.hpp:26,
                  bestandslog_factory.hpp:26); Rueckkante abi->bestandslog LEER            [OK, deklariert]
abi            -> anatomy (Modul-Makros: set_module_abi_v1.hpp:7, anatomy_module_abi_v1.hpp:28-30,
                  decl:17-20) | axes (subaxis_valueset_segment.hpp:25-27, M3-Kante;
                  Rueckkante LEER) | topics (build_variant_inspection.hpp:13)              [OK, deklariert]
anatomy        -> axes 18 | topics 1 (abi_adapter.hpp:68) | execution_engine 6 | src 6
                  | compositions 11; anatomy -> abi = 0 (Synthese-grep bestaetigt)        [OK]
  organ_concept.hpp -> NUR anatomy_base.hpp (:39)                                         [OK, deklarierter Schnitt :24-31]
abi            -> measurement 9 (B2-Nachtrag: anatomy_version_stamp.hpp:17-20,
                  meta_meta_stamp_suffix.hpp:35-37, anatomy_stamp_entries.hpp:96,
                  system_axis_code_versions.hpp:20 -- 9 exakt, am Objekt gezaehlt)        [OK unter Ordnung unten]
measurement    -> builder 0                                                               [OK]
measurement    -> anatomy 1 (B2-Nachtrag: include/cache_engine/measurement/
                  system_axis.hpp:10 -> ../../../anatomy/observable_tier.hpp --
                  observable_tier = G8-Par.1.2-Flaeche)                                   [OK unter Ordnung unten]
measurement    -> topics 3 (Nachbesserungs-Erhebung 04.08.: ceb_system_axis.hpp:12,
                  measurement_meta_meta_axis.hpp:27, system_axis.hpp:12 -> topics/axis.hpp)
                  | abi 0 | axes 0 (grep leer) => measurement damit VOLL kartiert          [OK, abwaerts]
src            -> topics 1 (B2-Nachtrag: src/concepts/axis_original_code_mixin_base.hpp:27
                  -> ../../topics/axis_base.hpp; Par.3-Wort 'abwaerts-Basis' gilt damit
                  fuer alles AUSSER dieser EINEN deklarierten Bausteine-Kante)            [OK unter Ordnung unten]
axes <-> topics: 241 / 288 bidirektional = faktisch EINE Schicht in 2 Wurzeln             [Posten 43]

ORDNUNGS-DEKLARATION (B2 -- vorher NIRGENDS im Dossier deklariert, jetzt bindend fuer
diese Karte): konsistente Gesamt-Ordnung anatomy < measurement < abi < builder
(darunter src/axes/topics als Basis-/Bausteine-Schicht; profile_facade oberste Schicht).
Unter DIESER Ordnung ist keine der drei B2-nachgetragenen Kanten aufwaerts -- die
AUFWAERTSKANTEN-Liste unten haelt sachlich, stand aber bis zur Nachbesserung unter einer
unausgesprochenen measurement-Position; das ist hiermit geheilt.

AUFWAERTSKANTEN (vollstaendig UNTER der oben deklarierten Ordnung -- B2-Heilung):
[!] anatomy -> builder: 1 -- container_framework.hpp:37 -> genus_binding_traits.hpp        SF-1 (ECHT)
[!] abi     -> builder: 1 -- cache_engine_execution_engine_adapter.hpp:14-16               Posten 39
[!] topics  -> anatomy (Nicht-Basis-Header): view_registries.hpp:7, view_policies.hpp:11,
    axis_growth_registry.hpp:7, axis_growth_policies.hpp:12, axis_command_base.hpp:9      Posten 40
[!] axes    -> anatomy: NUR organ_location.hpp (79 Dateien)                               Posten 41

ZYKLEN: 0 Datei-Zyklen (S3-DFS, 255 Knoten/541 Kanten ab den 6 Kern-Wurzeln);
1 VERZEICHNIS-Zyklus anatomy<->builder/experiment_tree (via SF-1).
```

---

## 6. CT/RT-INVARIANTEN-BEFUND (Owner-Nachtrag 3d + NACHTRAG 5: CT-rekursiv / RT-imperativ)

STRUKTUR-OK, am Objekt deklariert UND bewiesen (S3):
- DEKLARATION im Code: genus_observer_aggregate.hpp:38-41 ('Einsammlung FLACH und IMPERATIV je
  Ebene -- kein rekursiver Laufzeit-Abstieg; bewusst KEIN geschachteltes Aggregat-Member') +
  set_tier_v2.hpp:106-107.
- BELEG je Gattung: Einsammlungen = flache if-constexpr-Ketten OHNE Selbstaufruf
  (SA search_algorithm_anatomy.hpp:65-115; Set set_anatomy.hpp:261-296; Sequence :175-201;
  Adapter :391-424; View :157-176); Wire-Fills flach (set_tier_v2.hpp:112-149 usw.; einzige
  Schleifen = CT-konstant begrenzte seg_ns-Sentinel-Loops).
- Forwarding: ObservableOrgan statistics()/observe_all() -> organ_.observe_all()
  (organ_concept.hpp:341/:344) -- Aufruf-Tiefe == TYP-Schachtelungstiefe, compile-time
  aufgeloest; Negativ-Greps (Selbstaufrufe, drive_-Symbole in anatomy/) leer.
- PROBEN: (A) Nest<64> compiliert, snapshot_t ueber alle Ebenen identisch,
  sizeof(L64)==sizeof(MinimalOrgan) -- Zero-Cost haelt; (B) Selbstbezug bricht COMPILE-HART an
  organ_concept.hpp:62 -> :78 (Constraint-Kette literal); (C) -ftemplate-depth-Deckel faengt
  jede Tiefen-Eskalation compile-hart -- NIE stilles/unbeschraenktes Wachstum.
- Exakt die Owner-Klammer (NACHTRAG 5): Adapter/ObservableOrgan-Huellen tragen die
  cross-Verwendung metaprogrammatisch-rekursiv im TYP-Graph, zur LAUFZEIT flach-imperativ.
- Scope-Grenze ehrlich: Invariante verbietet Rekursion UEBER Achsen-/Organ-Grenzen; ein
  axes-interner Selbstaufruf-Sweep (Algorithmen INNERHALB einer Achse) war nicht Gegenstand
  (A8-S5-naher Eigen-Posten, Par.9 Punkt 9).

---

## 7. WAS/WIE-BILANZ (ce=Framework/WIE, super=Experiment/WAS)

STRUKTUR-OK -- die Trennung haelt an allen geprueften Naehten (S4):
- super Code/02_messung_driver = KANONISCHER E4/S1-WAS-Traeger (Dossier 16 A.3; Ledger:1225
  Schichten-Modell); konsumiert ce als Bibliothek, re-implementiert nichts.
- ce enthaelt KEINE Code-/CMake-Referenz auf super (alle Treffer Doku-Kommentare) --
  Baseline-Layering der Haeuser intakt; ce-Registry kennt das prt-art-Layout nicht
  (2-Registry-Kanon, je Engine EINE Registry im eigenen Haus).
- E1-E4-Traeger in den richtigen Haeusern: E4 super-Treiber + E4-XML (Fassaden-Parse als WIE
  in ce profile_facade); E3 ce experiment_tree; E2 ce lazy_adhoc_source_gen + Loader;
  E1 ce algorithm_resource_control + resource_controllable_tier.
- Historischer Ebenen-Fehlbau #31 (workload_matrix als tote E2-Insel in ce) am Ist BESEITIGT
  (0 Treffer); Workload-Drive ebenen-richtig als E4-XML.
- Legacy-Mechanik in super GEGATET, nicht wild (plugin_loader nur unter
  COMDARE_LEGACY_MESSREIHEN==1, main.cpp:948-953; Abloesung V-5c gebucht).
- DOKUMENTIERTE SPANNUNG (kein Schnitt-Fehler): die 5 thesis_profiles/*.profile.xml
  (Studien-Definition = WAS) liegen im S3-Slot des WIE-Hauses ce -- kanonisch dokumentiert
  (Ledger:1225), golden-Fixture-Rolle, G8-gesperrt (m3v2_study byte-stabil). Nach-Abgabe-Frage
  = nicht gestellter Owner-Entscheid (Par.9 Punkt 4, NUR-KENNTNIS).
- Gewachte Duplikation: experiment_golden.xml in BEIDEN Haeusern, byte-identisch ohne
  Provenienz-Block, Sync-Gate test_fixture_sync_experiment_golden; Kanonik = F27 (user-gated).

---

## 8. WIDERSPRUCHS-AUFLOESUNG S1-S4 (am Objekt, read-only)

- **W-A (Verdikt-Spannung SF-1):** S1 klassifiziert die anatomy->builder-Kante als ECHTEN
  Schnitt-Fehler; S3 verdiktet 'KEIN echter Schnitt-Fehler'. KEIN Sach-Widerspruch, sondern
  Scope-Differenz: S3 bewies Datei-Zyklus-Freiheit + Compile-Sauberkeit (beides stimmt),
  bewertete aber die VERZEICHNIS-Layering-Richtung nicht; S1 bewertete genau diese. Am Objekt
  verifiziert (04.08.): container_framework.hpp:37 existiert, genus_binding_traits.hpp:13-19
  inkludiert zurueck. Nach Massstab 1 ist die Aufwaertskante ein echter Schnitt-Fehler;
  S3-Beweise mildern die MASSNAHME (kein Not-Fix noetig), nicht die KLASSE. Synthese-Verdikt:
  SF-1 steht (Abschnitt 4.1).
- **W-B (Zitat-Drift organ_concept):** S1 zitierte :28-30, S3 :26-29 fuer denselben
  LAYER-SCHNITT-Kommentar. Am Objekt: Block :24-31, Include :39. Beide meinten denselben
  Block; Aussage identisch, Drift buchhalterisch.
- **W-C (gattung()-Symmetrie):** Gattungs-Dossier (Stand 44bcda99, VOR C7) nannte nur
  AdapterAnatomy::gattung(); S2 (Stand 54521360, NACH C7-7) belegt alle 4 Container-Anatomien.
  Zeitliche Abfolge, kein Widerspruch -- S2 ist der massgebliche Nach-C7-Ist.
- **W-D (abi->builder doppelt gemeldet):** S1-V2 und S3-Nebenbefund beschreiben dieselbe Kante
  (:14-16) mit derselben Klasse (Schoenheitsfehler, geparkte V32-Ausnahme) -- konsolidiert zu
  EINEM Posten 39.
- **W-E (Zeilen-Drift Graph-Wache):** S2 zitiert genus_build_admission.hpp:189-195, das
  Gattungs-Dossier :190-192 -- derselbe static_assert-Block, Drift buchhalterisch.
- **W-F (Gate-Zahl):** S4 erhob 377 live am build-e24 (HEAD 54521360); Ledger-Nachtrag abend
  bestaetigt 2x377/377 am selben Stand -- konsistent; auf development nicht separat erhoben
  (Merge tree-identisch; Kanon: N je Bau live erheben).

---

## 9. OFFENE ENTSCHEIDE (nur echtes NICHT-GEFUNDEN / nicht entschieden)

1. **SF-1-Heilungs-Entscheid (Owner):** Traits-Split von genus_binding_traits (Interface-Anteil
   nach anatomy) -- source-only, aber G8-Flaeche => Owner-Fenster; bis dahin benannter Posten,
   NICHT still ausfuehren.
2. **Posten-43-Fenster (Owner, NACH Abgabe):** axes/-vs-topics/-Vereinigung -- binary-beruehrend
   (G8 Par.1.6 + Codegen-header_include); dieses Audit liefert die Doppel-Namens-Liste, KEINE
   Umzugs-Planung.
3. **F27 (user-gated, seit 16.07.):** kanonische experiment_golden.xml-Kopie (super
   Code/test_data_xml vs ce tests/unit/thesis_tiere); bis dahin Sync-Pflicht + ctest-Gate.
4. **thesis_profiles-Ort nach Abgabe** (WAS-Definition im WIE-Haus, S3-Slot): nicht gestellter
   Owner-Entscheid -- NUR-KENNTNIS, kein Handlungsbedarf vor Abgabe (G8-gesperrt).
5. **Ziel-Ort der Posten-40/41-Bausteine** (eigenes Basis-Verzeichnis vs topics/): nicht
   entschieden; Vorschlag gehoert in den Abschluss-Aufraeumpass; Flaechen bis dahin G8-gesperrt.
6. **builder/measurement/thread_pinning.hpp Einordnung** (nach include/cache_engine/measurement/
   oder zu experiment_runner?): offen, mit Posten 42 fuehren.
7. **K5 (nach Abgabe, Owner):** echte <T>/<Key,Value>-Template-Parametrisierung der
   Anatomie-Huellen (Gattungs-Dossier Par.7-3); C7 fuehrt sie als deklarierte Luecke.
8. **Map-Gattungs-Kern-Reichweite** (Mess-Subinterfaces zum Kern?): deklariert offen
   (idriveable_tier.hpp:31-34; Gattungs-Dossier Par.7-2; A8-S3-Nachbarschaft).
9. **axes-interner Rekursions-Sweep** (Selbstaufrufe INNERHALB einer Achse -- von der Invariante
   nicht verboten, aber nie kartiert): eigener A8-S5-naher Posten, falls gewuenscht.
10. **V32-Insel-Entfernung (Posten 39):** braucht frischen 0-Konsumenten-Beweis am dann-Ist --
    Beweis-Zeitpunkt = Aufraeumpass, nicht heute.
11. **Nicht kartierte Flaechen (Scope-Grenze, KEIN Befund):** uebrige include/cache_engine-
    Unterverzeichnisse (allocators/api/concepts/fingerprint/hbm/indexes/platform/platform_probe),
    compositions/, harness/, heuristik/, reclamation/, subsystems/, virus/,
    concurrency_manager/, algorithm_profiles/ (nur Stichproben); CMake-Target-Ebene; OFF-Pfad
    ENABLE_STATISTICS=0 (bekannte C6-V-Luecke); super Code/adapters//tools/-Kettenglieder;
    prt-art-Seite der 2-Registry-Doktrin; Voll-Zyklen-Scan ueber alle 340 axes-Header
    (S3 deckte den transitiven Graphen der 6 Kern-Wurzeln). B2-KLARSTELLUNG:
    include/cache_engine/measurement/ gehoert NICHT (mehr) in diese Ausnahme-Liste --
    seit dem B2-Nachtrag in Par.5 ist es voll kartiert (-> builder 0, abi 0, axes 0,
    anatomy 1, topics 3; eingehend abi 9, builder 18, profile_facade 33) und seine
    Position in der Gesamt-Ordnung deklariert.

---

## 10. NACHBESSERUNGS-PROTOKOLL (04.08., Befunde B1-B6 -- je Befund quittiert)

Alle sechs Befunde wurden VOR Einarbeitung am Objekt nachverifiziert (wt-e24 HEAD
545213600962ba7431c09033a5a3e59fb4ec76a4, Working Tree sauber; read-only, kein Build).

- **B1 QUITTIERT (eingearbeitet):** Matrix trug 2 per-Genus-Artefakt-Klassen nicht.
  Nachgeprueft: 5/5 Modul-ABI-Makro-Header vorhanden (abi/anatomy_module_abi_v1.hpp:50,
  set:13, sequence:14, adapter:23, view:12; G8 Par.1.1 'Modul-Makros' = gesperrte Flaeche,
  G8-Zeile 38) und Kompositions-Belegung 5/5 mit Platzierungs-Asymmetrie (eigene Dateien
  set:20/sequence:37/view:53 vs eingebettet adapter_anatomy.hpp:165 vs AdHocComposition
  composition_factory.hpp:67). Fix additiv vollzogen: Par.2 = 5x9 (2 neue Spalten + 3 Noten,
  inkl. Test-Seiten-Note genus_module_*.cpp ohne SA-Pendant); neuer Posten 53. Kein
  versteckter Luecken-Defekt -- die alte VOLLSTAENDIG-Zusicherung war unter-hergeleitet,
  Par.1-Verdikts-Begruendung entsprechend angepasst.
- **B2 QUITTIERT (eingearbeitet):** Kanten-Karte war als KARTE unvollstaendig; Zusicherung
  stand unter undeklarierter measurement-Position. Nachgeprueft: abi->measurement EXAKT 9
  (grep-Zaehlung; anatomy_version_stamp.hpp:17-20, meta_meta_stamp_suffix.hpp:35-37,
  anatomy_stamp_entries.hpp:96, system_axis_code_versions.hpp:20), measurement->anatomy
  EXAKT 1 (system_axis.hpp:10), src->topics EXAKT 1 (axis_original_code_mixin_base.hpp:27).
  Fix vollzogen: 3 Kanten-Zeilen + measurement->topics 3 (Ehrlichkeits-Nachtrag) in Par.5,
  ORDNUNGS-DEKLARATION anatomy < measurement < abi < builder, AUFWAERTSKANTEN-Titel
  qualifiziert, Par.3-src-Wortlaut praezisiert, Par.9 Punkt 11 B2-Klarstellung. Unter der
  deklarierten Ordnung ist keine der Kanten aufwaerts -- SF-Bestand unveraendert.
- **B3 QUITTIERT (eingearbeitet):** Zahlwort 'sechs' -> SIEBEN zurueck-inkludierte
  anatomy-Header (genus_binding_traits.hpp:13-19; am Objekt gezaehlt: anatomy_base,
  composition_factory, search_algorithm/adapter/set/sequence/view_anatomy = 7). Par.1 +
  Par.4.1 korrigiert; Zeilenbereich und Dateiliste waren korrekt, nur das Zahlwort nicht.
- **B4 QUITTIERT (eingearbeitet):** Posten-48-Zeilenzitat :1794-1817 war impraezise -- die
  label-lose C5-FK7-Zeile liegt bei :1819 (am Objekt: set_tests_properties
  _comdare_e24_c5_fk7_tu, LABELS 'goal_v6;phase_d' OHNE e24; C4-Dock analog :1796).
  18/37-Zaehlung reproduziert exakt (4 c6v :1670 + 7 c6 + 5 c7 :1707 + 2 c10 :3374/:3383
  = 18; 37 distinkte test_e24_*-Targets). Posten 48 praezisiert.
- **B5 QUITTIERT (KEINE Textaenderung am Verdikt noetig -- Bestaetigung):** Der
  Widerlegungs-Versuch gegen Fragen a+e ist FEHLGESCHLAGEN; das Gesamt-Verdikt
  'SCHNITT-FEHLER-VORHANDEN, genau EINER' steht ungeschoent. Eigen-Nachpruefung 04.08.:
  anatomy->builder EXAKT 1 (container_framework.hpp:37, grep-Zaehlung 1); abi->builder
  EXAKT 1 Datei mit Konsumenten-Bild 2 Kommentar-Referenzen (i_command.hpp:3,
  execute_engine_command.hpp:3) + 1 Test-TU (test_engine_adapters.cpp:6) = totes Blatt;
  'execution_engine_adapter' 0 Treffer in der G8-Negativliste => Posten-39-Herabstufung
  gedeckt. Posten 39 um diese datei:zeile-Belege angereichert (einzige B5-Folge-Edition).
- **B6 QUITTIERT (eingearbeitet):** Posten-44-Zahlen reproduziert (106 libs + 70 tests
  = 176; 18 'fuenf/5 Gattungen', case-sensitiv) -- Nicht-Belegbarkeits-Vorwurf entfaellt.
  Restwunsch erfuellt: grep-Kommandos stehen jetzt LITERAL in Posten 44 (G8-Vorbild
  'bindend ist das Kommando'), inklusive des sinntragenden --include-Filters
  (ohne Filter: tests=74, +3 CMakeLists.txt +1 README.md -- Delta aufgeklaert, S2-Zahl 70
  ist die Code-Datei-Zahl).

ENDE DOSSIER. Read-only-Synthese; keine Code-Aenderung, kein Commit, kein Build.
Aufraeumpass-Nummern 39-53 = Fortschreibung an G8 Par.6 (33-38) -- bei Uebernahme in die
verbindliche Liste dort NICHT neu nummerieren, nur anhaengen (50 gehoert in die
super-Kandidatenliste Ledger:3597; 53 = B1-Nachtrag dieser Nachbesserung).
