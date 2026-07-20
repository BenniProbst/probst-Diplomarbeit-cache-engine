# 23 — SYSTEMACHSEN-KONZEPT: WIEDERHERSTELLUNGS-DOSSIER (F4/F3i, 2026-07-16)

> **Auftrag:** 20-Seiten-Dossier zur Wiederherstellung des Systemachsen-Konzepts nach der
> USER-KONZEPT-KLÄRUNG vom 2026-07-16 (LEDGER:368; „wir brauchen ein 20-Seiten-Dossier, um den
> Überblick wiederherzustellen"). Erstellt read-only (einzige Schreiboperation = diese Datei);
> TABU-/golden-Bestände unberührt (reine Lektüre).
>
> **Pfad-Konventionen:** `super` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`;
> `ce` = `super/Code/external/comdare-cache-engine`; `SUPER/Code` = `super/Code`;
> `THESIS` = `super/thesis/diplomarbeit`; `LEDGER` = `super/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`;
> `MEM` = `~/.claude/projects/-home-comdare/memory/`; `REGISTRY` =
> `ce/libs/cache_engine/builder/commands/axis_library_registry.hpp`. Zeilenangaben = Arbeitskopie-Stand
> 2026-07-16, erhoben und doppelt verifiziert in den 5 Rohdaten-Strängen A–E
> (`super/docs/sessions/backups/20260716-f4-systemachsen-dossier/rohdaten/`).
>
> **Ehrlichkeits-Doktrin dieses Dossiers:** Jede tragende Aussage ist `datei:zeile`-belegt. Lücken
> werden als Lücken benannt (kein Raten, MEM `feedback_never_guess_always_lookup_state_of_art_and_docs`).
> Nichts wird als entschieden dargestellt, was ein offener User-Fork ist (§7). Wo eine Aussage nur im
> User-Wortlaut existiert und nirgends sonst verankert ist, steht das explizit dabei.

---

## 0. AUFTRAG + USER-WORTLAUT (bindend, wörtlich)

Die autoritative Quelle des Konzepts ist der wörtlich verankerte User-Eintrag **LEDGER:368**
(„USER-KONZEPT-KLÄRUNG F3i/F4/F5 — AUTORITATIV, wörtlich; korrigiert die ‚Duplikat'-These
GRUNDLEGEND; 20-Seiten-Dossier beauftragt"). Die sechs bindenden Kernsätze:

1. **Getrennte Konzepte:** „Systemachsen und Algorithmus-Gattungs-Achsen sind getrennte Konzepte,
   auch wenn beide compile-time-Hauptachsen und dynamische runtime-Unter-Achsen haben." (LEDGER:368)
2. **Verortung:** „Per Plan liegen die Systemachsen in der CacheEngineBuilder (und werden dort
   hineinkompiliert); die anderen Achsen werden VON der CacheEngineBuilder EINKOMPILIERT IN die
   Tier-Binaries." Messung der Systemachsen „nach einer Strategie". (LEDGER:368)
3. **F4 (Konzept-Korrektur):** „Scheduling/Hardware/NUMA/Locking sind PFLICHT-SYSTEMACHSEN
   (‚sollten als System-Achsen NEBEN den Mess-System-Achsen liegen; sind TODO') — KEINE Duplikate,
   sondern 3 missverstandene Stellen des Konzeptes. Das Konzept ist Pflicht und kaputt — Reparatur
   durch gründliche Recherche." (LEDGER:368)
4. **F3i(1) — NEUE Compiler-SYSTEMACHSE:** „in der XML muss es möglich sein, sowohl den
   CacheEngineBuilder als auch JEDE einzelne Tier-Binary-Permutation entweder mit gcc oder mit clang
   zu bauen (eigene Achse zur compile time bei runtime der CacheEngineBuilder und NEUE SYSTEMACHSE)."
   (LEDGER:368)
5. **F3i(2)+(3) — Voll-Vergleich + „alt gegen neu":** „Vergleich einer Tier-Binary unter Last gegen
   ALLE anderen Tier-Binaries — wir wollen wissen, welche Achsen-Permutationen unter welchen
   Datenlasten mit welchen Compilern auf welchen ISA+OS am besten laufen"; „alt gegen neu" MEINT
   „den bestehenden Stand der Technik gegen einen Prüfling neuer Techniken für bestimmte Achsen
   (wie PRT-ART) zu prüfen … für alle genannten Ketten"; die „4. Kategorie" ist eine EIGENE Kategorie
   mit Unterkategorien, **JE STUFE auszuführen** (für die 3 gemessenen Stufen — **KEINE 4. Stufe**).
   (LEDGER:368)
6. **Dritte Anwendung:** „Der Experiment-B+-Baum ist ein Resultat der PLANUNG des Gesamtsystems, hat
   aber einen Filter für die Stufe der CacheEngineBuilder und der durch ihn zu bauenden und am
   Prüfdock zu messenden Tier-Binaries — **der Experiment-Planer mit XML-Interpreter ist eine NEUE
   DRITTE ANWENDUNG im Framework der CacheEngine.**" (LEDGER:368)

Flankierende, gleichrangig bindende User-Entscheide desselben Tages: **F1** (XML-Programmier-Bibliothek
für Experimente UND Auswertung), **F3(ii)** (4 CEB-Betriebsmodi als XML-Element = PFLICHT/BASISFEATURE,
Dossier 19 = Planungsquelle), **F4** (Option 3 Reparatur — ABER erst Revert `804aa3c2` untersuchen →
erneute Rückfrage; diese Rückfrage-Grundlage liefert §2/§7), **F6** (XML steuert CI über einen
INTERPRETER, Live-Tracking, JEDES Feature XML-gestützt), **F12(i)** (DEADLINE 28.07.: CI- UND
Standalone-Messfähigkeit, cmake+C++23, EINE Maschine) — alle LEDGER:370. Dazu die
Brücken-Entscheidungsrunde E1–E16 (LEDGER:371; u. a. E3 n_repeats≥3-Pflicht, E10 offizielle Strecke
zuerst/V32-Rückbau danach, E11 Phasen-Kardinalität, E13 „#37-3-Achsen"-Klärung) und der bindende
Fork-A-Entscheid Option A („IMMER offizielle Architektur, NIE Parallelstrecke", LEDGER:372 bzw.
§12-Eintrag; MEM `feedback_vor_aufgaben_erst_projektstruktur_analyse`).

**Warum „kaputt" die richtige Diagnose ist (Beweis in Kurzform, Details §2):** Die vier
Pflicht-Systemachsen-Themen existieren im Code nur (a) als toter vtable-Entwurf von 2026-05-18
(4 Header, 0 Include-Konsumenten, B-Rohdaten §0; Commit `7a6c563f`), (b) als davon abweichende,
teils phantomhafte Registry-Strings (B §5.1), (c) als Organ-/Build-Bausteine der GATTUNGS-Seite
(C §1–5) und (d) als unimplementierte Subsystem-Skelette (`c11_scheduler_engine` u. a., C §5).
Eine SYSTEMACHSEN-Ausprägung („neben den Mess-System-Achsen", in der CEB, gemessen nach Strategie)
existiert **nirgends** (grep-Befund D §1.8: SystemAxis-Treffer nur `system_axis.hpp`,
`measurement_axis_registry.hpp`, `validate_profile.hpp`). Der Deprecation-Versuch `414ed8c2`
(2026-07-13, „4 vtable-Achsen … grep=0 Konsumenten") wurde 27 Minuten später kommentarlos revertiert
(`804aa3c2`, B §7) — der Schwebezustand ist exakt die vom User adressierte „missverstandene Stelle".

---

## 1. DAS WIEDERHERGESTELLTE KONZEPT

### 1.1 Die zwei getrennten Achsen-Systeme

Das Konzept hat eine seit 09.–10.07. dokumentierte Wurzel und wird durch LEDGER:368 präzisiert und
erweitert. Die bindende Grundunterscheidung (super `docs/architektur/18_MESS_METHODIK_…:15-30`,
Gegenüberstellungstabelle; MEM `feedback_system_axes_measurement_own_abstract_root_blood`;
Kern-Direktive LEDGER:100/118 „System-Achsen=„Blut" (eigene abstrakte Wurzel)"):

| Merkmal | **ALGORITHMUS-GATTUNGS-ACHSEN** (Organ-Achsen) | **SYSTEMACHSEN** („Blut") |
|---|---|---|
| Verortung | VON der CEB IN die Tier-Binaries EINKOMPILIERT (LEDGER:368; Emission `adhoc_emitter.hpp:83-108`, D §1.8) | IN der CEB (dort hineinkompiliert, host-seitig; LEDGER:368; `system_axis.hpp:1-5,143-145`) |
| Rolle | das Gemessene/Optimierte (18:20) | Mess-Instrumente + Plattform-/System-Regie (18:20; erweitert um F4/F3i(1)) |
| Bestand | 19 Komposition-Slots T0..T18 (`composition_factory.hpp:51-70`) + 3 Build-Achsen (`registry_to_axis_levels.hpp:6-9`) | heute: 16 Mess-Kategorien (`measurement_category.hpp:10-27`); SOLL zusätzlich: 4 Pflicht-Systemachsen + Compiler-Systemachse (§1.2) |
| Identität | `binary_id` (`axis_path_serialization.hpp:30-34`) | NIE in der `binary_id` (TABU: super 18:104, 19:23) |
| Austauschbarkeit | permutierbar (Composition, 18:24) | nicht austauschbar, immer präsent sobald Messung an (18:25-26; `system_axis.hpp:145`) |
| Wurzel im Typsystem | `AdHocComposition<T0..T18>` (18:27) | CRTP `SystemAxis<Derived>` + `SystemAxisConcept` (`system_axis.hpp:147-190`) |
| E-Ebene | E2/E3-Permutationsbaum (18:28) | E0-Querschnitt M (18:28; super 19:13/21) |

**Beide** Konzepte tragen dieselbe innere Struktur — **compile-time-HAUPTACHSEN + dynamische
runtime-UNTER-ACHSEN** (LEDGER:368). Der dokumentierte Präzedenzfall dieses Haupt-/Unter-Modells ist
super `docs/architektur/21_…:29-31` („eine Unter-Achse ist eine VOLL-Achse, die unter der
compile-time-Haupt-Achse ausgeführt wird; der frühere ‚Laufzeit-Skalar' (RC-POD-Feld) ist in Wahrheit
eine Unter-Achse") und 21:137-138 („hw_prefetcher bleibt System-/Wurzel-Unter-Achse" — der belegte
Fall einer dynamischen Unter-Achse einer SYSTEMachse). Live-Stand je Seite:

- **Gattungs-Seite (gebaut):** Hauptachsen = 19 Slots + 3 Build-Achsen; Unter-Achsen = RC-POD
  `ComdareResourceControlV1` (6 Felder, `resource_controllable_tier.hpp:34-43`) + 2 dynamische
  Baum-Ebenen `concurrency.thread_count`/`prefetch.hw_prefetcher` (`profile_to_tree.hpp:85-95`) +
  compile-time-Unterachsen wie `alloc_hw` (NUMA/Page-Kante, `alloc_hw_config.hpp:2-10`).
- **System-Seite (teilgebaut):** Hauptachsen = 16 Mess-Kategorien in flacher Registry
  (`measurement_axis_registry.hpp:32-49`); **KEINE Haupt-/Unter-Struktur im Code** (C §7-Befund:
  „Für MESS-System-Achsen gibt es KEINE dynamischen Unter-Achsen — die 16 Kategorien sind rein
  statisch/constexpr"). Die Reparatur muss die Haupt-/Unter-Struktur der System-Seite nachziehen
  (Bauplan-Vorbild: Doc 21:21-23/235-241 — Wurzel = System-Achsen mit Visitor+Strategy).

### 1.2 Die Systemachsen-Familie im SOLL (drei Gruppen, EINE Wurzel)

Alle drei Gruppen hängen an der EINEN bestehenden CRTP-Wurzel `SystemAxis<Derived>` +
`SystemAxisConcept` (`system_axis.hpp:147-190`; kein vtable, empty-base, Blut-Direktive
`:143-145`) — keine zweite Wurzel, keine Parallelstruktur:

1. **Mess-System-Achsen (GEBAUT, konsumentenlos-gated):** 16 Kategorien, Regime-Zweiteilung
   TimeObserver(9)/PmcCounter(7) thesis-wörtlich (`system_axis.hpp:20-53,55-80`; Thesis
   `03_messsystem_prtart.tex:382-386` + `06_evaluation_methodology.tex:119-126`); 3 konkrete
   Strategien WallClock/ObserverSnapshot/Pmc (`system_axis.hpp:192/238/283`); Registry + Mess-Visitor
   `for_each_measurement_axis` (`measurement_axis_registry.hpp:32-49,70-75`); vendor-neutrale Quellen
   `IMeasurementSource` (`i_measurement_source.hpp:24-85`). Konsum bewusst #156-DATA-gated
   (LEDGER:150/402; MEM `reference_tier_metaphor_system_axis_properties_verified_complete`).
2. **Pflicht-Systemachsen (TODO, F4):** Scheduling, Hardware, NUMA, Locking — „NEBEN den
   Mess-System-Achsen" (LEDGER:368). Einzige Verankerung ist der User-Wortlaut selbst; keine Doku-,
   keine Code-Stelle modelliert sie heute als Systemachsen (A §7-Befund). Bauplan §2/§6.
3. **Compiler-Systemachse (TODO, F3i(1), NEU):** gcc XOR clang, XML-gewählt, (a) je
   Tier-Binary-Permutation und (b) für den CEB selbst. Einzige Verankerung: LEDGER:368 (A §8).
   Design §3. Sie ist strukturell die fünfte Achse der Pflicht-Familie und folgt demselben Bauplan
   (D §2.3: „compile-time-Haupt = Toolchain-Identität/Provenienz + runtime-Unter =
   Ausführungskontext").

Zur HYBRID-Heuristik-Systemachse (Diplomarbeits-ZIEL, ebenfalls eine EIGENE SYSTEMACHSE per
User-Direktive 10.07., super 19:71/73/75 + LEDGER:92/295/655(c)): sie bleibt #156-DATA-gated mit
Deep-Research-Pflicht VOR dem Bau (LEDGER:295/665) und ist NICHT Teil dieser Reparatur — sie ist im
Diagramm als künftiges Familienmitglied vermerkt, mehr nicht.

### 1.3 Gesamtbild (ASCII)

```
                 ┌───────────────────────────────────────────────────────────────────┐
                 │ ANWENDUNG 3 (NEU, TODO): EXPERIMENT-PLANER mit XML-INTERPRETER     │
                 │  · parst Registry-XMLs + Experiment-XML (Parser-Kern existiert:    │
                 │    xml_config_parser.hpp:323, test_experiment_parser.cpp:1-16)     │
                 │  · Experiment-"B+"-Baum = PLANUNGS-Resultat (experiment_tree.hpp)  │
                 │  · FILTER für die CEB-Stufe = CoR-Kette (selection_filter_chain)   │
                 │  · wählt Host-Artefakt: gcc-CEB | clang-CEB (CMakePresets:37-55)   │
                 └────────────────────────────┬──────────────────────────────────────┘
                                              │ startet/steuert (XML = Bauanleitung)
   ┌──────────────────────────────────────────▼──────────────────────────────────────┐
   │ ANWENDUNG 2: CACHEENGINEBUILDER (CEB) — Host; hält Parser+Prüfdock+Messsystem   │
   │ (LEDGER:89/1178)                                                                │
   │                                                                                 │
   │  SYSTEMACHSEN — IN den CEB HINEINKOMPILIERT ("Blut", host-seitig)               │
   │  ├─ Mess-System-Achsen: 16 Kategorien, Regime TimeObserver|PmcCounter  [GEBAUT] │
   │  │    Wurzel: CRTP SystemAxis<Derived>, system_axis.hpp:147-190                 │
   │  ├─ PFLICHT-Systemachsen: Scheduling|Hardware|NUMA|Locking             [TODO]   │
   │  ├─ Compiler-Systemachse: Host-Toolchain gcc|clang (Provenienz)        [TODO]   │
   │  └─ (später, gated: HYBRID-Heuristik-Systemachse, 19:71)                        │
   │     je Achse: compile-time-HAUPTACHSE + runtime-UNTER-ACHSEN                    │
   │     Messung "nach einer Strategie" (Strategy je Achse, 18:40-42)                │
   │                                                                                 │
   │  baut ZUR LAUFZEIT (C++-orchestriert, adhoc_emitter) ────────────────────┐      │
   └──────────────────────────────────────────────────────────────────────────┼──────┘
                                                                              ▼
   ┌─────────────────────────────────────────────────────────────────────────────────┐
   │ TIER-BINARIES (DLLs) — GATTUNGS-/ORGAN-ACHSEN, VON der CEB EINKOMPILIERT        │
   │  ├─ 19 Komposition-Slots T0..T18 = binary_id (axis_path_serialization:30-34)    │
   │  ├─ Build-Achsen DERSELBEN Binary: page_type | simd_ext/09b | general_hw/12     │
   │  │    (+ NEU: Tier-Toolchain gcc|clang als 4. Build-Achse, §3)                  │
   │  └─ runtime-UNTER-ACHSEN: RC-POD (prefetch_distance, pool_budget_bytes, …)      │
   │       + dynamische Baum-Ebenen (thread_count, hw_prefetcher)                    │
   └───────────────────────────────────────▲─────────────────────────────────────────┘
                                           │ am Prüfdock gemessen; die Systemachsen
                                           │ umklammern host-seitig den run_workload-
                                           │ Aufruf (i_measurement_source.hpp:4-6)
   ANWENDUNG 1: messung_driver (E4-Host, "WAS"; SUPER/Code/02_messung_driver/main.cpp:4-12)
```

### 1.4 Begriffs-Disambiguierung (Pflichtteil — hier entstanden die Missverständnisse)

| Begriff | Meint | Meint NICHT | Beleg |
|---|---|---|---|
| **Systemachse** | host-/CEB-seitige Achse mit CRTP-SystemAxis-Wurzel, immer präsent bei Messung | einen Organ-Slot; eine Mess-KATEGORIE allein; ein Subsystem-Skelett | `system_axis.hpp:143-145`; 18:15-30 |
| **Mess-System-Achse** | die 16 MeasurementCategory-Achsen (Untergruppe der Systemachsen) | die GANZE Systemachsen-Familie — F4 fordert Pflicht-Systemachsen „NEBEN" ihnen | `measurement_axis_registry.hpp:2-5`; LEDGER:368 |
| **Gattungs-Achse / Organ-Achse** | T0..T18-Slot, einkompiliert, binary_id | „Gattung" im Prüf-Dock-Sinn (= Außen-Interface Search/Container/Graph, ce `34_…:15-34`) | `composition_factory.hpp:51-70` |
| **Build-Achse** | Build-Parameter DERSELBEN Binary (page_type/09b/12; kein 20. Slot, keine binary_id) | eine eigene Gattung oder ein Composition-Slot | ce Doc `27_…:79-102`; `build_variant_inspection.hpp:8-9` |
| **„Blut"** | die Systemachsen-Metapher (Mess-Ebene, seit 09.07.) | das ALT-Bild „Blutkreislauf (allocator)" der Säugetier-Anatomie-Tabelle — ein ORGAN-Bild, begrifflich abgelöst | super 14:494 vs. 18:20; A §3.1 |
| **Haupt-/Unter-Achse** | compile-time-Hauptachse + VOLL-wertige dynamische Unter-Achse darunter (beide Konzepte) | „Skalar-Parameter zweiter Klasse" | super 21:29-31 |
| **#37-Scheduling** | heute geplant als 27. PERMUTATIONS-Achse (ORGAN-Lesart, TABU-GO) — Spannungsfeld zu F4 | die Scheduling-SYSTEMachse des 07-16-Konzepts | LEDGER:392(c)/102; §7 Fork S-1 |
| **c11_scheduler** | datenstruktur-internes Page-Type-/Deferral-Scheduling (Skelett) | OS-Thread-Scheduling — auch inhaltlich KEINE Deckung der Scheduling-Systemachse | `i_scheduler_engine.hpp:2-14`; C §5 |
| **Compiler (Achse 15)** | Registry-Permutationsachse der TIER-Binaries (AutoPermutator-Tabelle) | die Compiler-SYSTEMACHSE inkl. CEB-Selbst-Wahl (F3i(1)) | REGISTRY:274-313; B §5.2 |
| **`AxisBase::get_compiler()`** | Paper-Provenance-Metadatum je Organ (Habich-Compliance) | Build-Compiler-Steuerung | ce `topics/axis_base.hpp:58-70`; C §8 |

**Abgrenzung gegen die E11-„Phasen"-Taxonomie** (Klärung `super/docs/audits/20260716-e11-phasen-e13-kontext-SYNTHESE-E11-E13.md`):
„Phase" ist dort mindestens 5-fach überladen (XML-Prüf-Phase, CEB-Betriebs-„Phase", Treiberphasen
1–5/7-Phasen-Pipeline, Roadmap-Phase, Zwei-Phasen-Op-Schleife; SYNTHESE L4 :38). **Systemachsen sind
KEINE Phase in irgendeinem dieser Vokabulare:** sie sind ein E0-QUERSCHNITT über alle Phasen
(18:48-50), präsent in jeder Prüf-Phase und jedem Betriebsmodus, sobald Messung an ist. Die
SYNTHESE selbst nutzt die Organ-vs-System-Trennung bereits als Verbots-Analogie („Prüf- und
Lebenszyklus-Dimension vermischen … Verbot analog Organ-vs-System-Achsen", SYNTHESE :53) — dieselbe
Disziplin gilt umgekehrt: die 4 CEB-Betriebsmodi (Mess→Auswertung→Arbeit→Hybrid, super 19:62-73)
sind eine LEBENSZYKLUS-Dimension des CEB, KEINE Systemachsen; die Systemachsen sind die
Instrumenten-/Regie-Familie, die in allen Modi identisch verankert bleibt.

---

## 2. DELTA-MATRIX (elaborat, PFLICHT — je Entwurfs-Element ↔ Live ↔ Verdikt)

Vokabular der Verdikte: **live-gedeckt** (Substanz existiert im offiziellen Live-Bestand; toter
Entwurf ist dafür KEIN Nachbau-Auftrag) · **TODO-Systemachse** (fehlende compile-time-HAUPTACHSE
der System-Seite) · **TODO-runtime-Unterachse** (fehlende/unverankerte dynamische Unter-Achse; bei
Andockung an Bestehendes: NICHT duplizieren, referenzieren — Duplikat-Verbot D §2.3/R6) ·
**obsolet** (Entwurfs-Form doktrinwidrig/ersetzt) · **Registry-Reparatur** (String-Wahrheit).

Herkunfts-Gesamtstatus der 4 Entwurfs-Header: EIN Geburts-Commit `7a6c563f` (2026-05-18, V32.EE.5),
seither inhaltlich unverändert; **0 Include-Konsumenten** (einzige Ausnahme numa_affinity→
hardware_strategy für das `NumaStrategy`-Enum, `numa_affinity.hpp:10`); alle Interfaces
**vtable-basiert** — im Widerspruch zur CRTP+Concept-Doktrin (MEM `feedback_crtp_concept_guard_mix_pattern`;
Commit-Wortlaut `414ed8c2`: „4 vtable-Achsen … vtable statt CRTP … grep=0 Konsumenten"; Revert
`804aa3c2` 27 min später ohne Begründung). Belege: B §0/§7.

### 2.1 H1 `hardware_strategy.hpp` (Achse 12, 74 Z.) — Thema HARDWARE

Selbst-Abgrenzung des Entwurfs (wichtig!): „NICHT identisch mit K09 C8 Hardware-Probing-Heuristik!
K09 C8 = wie ENTDECKT die CE die Hardware (CE-Service); Achse 12 = welche Hardware NUTZT der
Algorithmus AKTIV" (`hardware_strategy.hpp:11-13`) — der Entwurf trennt also SELBST schon
System-Seite (Entdecken/CE-Service) von Gattungs-Seite (aktives Nutzen). Er modelliert dann aber
ausschließlich die GATTUNGS-Seite („Algorithmus-aktive Hardware-Strategie … CEB-AutoPermutator
iteriert", `:40-41`).

| Entwurfs-Element (Beleg) | Live-Gegenstück (Beleg) | Verdikt |
|---|---|---|
| `SimdFamily {Scalar, AVX2, AVX512, NEON, SVE2}` (hardware_strategy.hpp:19-20) | Gattungs-/Build-Seite VOLL live: ISA-Achse T12 im 19-Slot (`composition_factory.hpp:51-70`, `isa=T12`), Build-Achse simd_extension/09b (`registry_to_axis_levels.hpp:67-76`) mit echten Flag-Kopplungen + FATAL_ERROR-Wahrheits-Gate (`isa_features.cmake:126-184`), Cross-Constraints ISA×SIMD×Plattform (`topic_hardware_config_set.hpp:46-88`); Thesis-Soll T12/SE1-SE3 (`03_messsystem_prtart.tex:80,129`) | **live-gedeckt** (Gattungs-/Build-Seite). System-Seite (Host-SIMD-Faktum): Quelle existiert als Provenienz `isa_built_for`/`isa_ran_on` (`provenance_manifest.hpp:58-69,83`) → in Hardware-SYSTEMachse aufnehmen = **TODO-Systemachse** |
| `CacheLevelTarget {L1Aware, L2Aware, L3Aware, HBMAware}` (:22-23) | Konstanten-Seite live: `hw_cache_line` im Build-POD (`build_variant_definition.hpp:17-34`), `COMDARE_CACHE_LINE_SIZE`-Define je DLL (`profile_run_facade.cpp:71-93`), Heuristik-Prototyp `cacheline_policy_selector` (super 18:121-122). Als TREIBENDE Achse: nichts | teils **live-gedeckt** (Definition); Ziel-Level-Steuerung als Achse = weder Organ noch System vorhanden → Deep-Research-TODO (MEM `feedback_axes_optimization_semantics_deep_research_observer_strategy`), Zuordnungs-Fork §7 S-6 |
| `NumaStrategy {Local, Interleave, Preferred, Bind}` (:25-26) | Gattungs-Kante live (F-B): compile-time-Unterachse `alloc_hw` mit `AllocNumaNode {Auto,-Node0,Node1}` + `AllocPageHint` (`alloc_hw_config.hpp:37,42`), if-constexpr-Gate über `numa_capable` (`:94-102`), profil-gated binary_id-relevant (`:16-17`; Baum-Andockung `profile_to_tree.hpp:69-74`); GO4-F-B-Entscheid LEDGER:360 | **live-gedeckt** (Allocator-/Gattungs-Kante). Host-NUMA-Regie (Topologie/Pinning des Mess-Prozesses) = **TODO-Systemachse** NUMA (Skelette: `i_pinning_engine.hpp:10-16` mit `NumaLocalCore=3`, `c10_topologie_engine` — 0 Impl, C §5) |
| `PrefetchHwInstruction {None, Prefetch, PrefetchNta, PrefetchW}` (:28-29) | Gattung live: axis_07-Organe inkl. `HardwarePrefetch` (`axis_07_prefetch_registry.hpp:18`), PF1-Tag trigger_mechanism=hw-instruction (`axis_07_prefetch_subaxes_pf1_to_pf3.hpp:7`); dynamische Baum-Ebene `prefetch.hw_prefetcher` (`profile_to_tree.hpp:94-95`, MSR nur Cluster-real `abi_adapter.hpp:258-259`) | **live-gedeckt** (Gattung). `hw_prefetcher` ist per Doc 21:137-138 „System-/Wurzel-Unter-Achse" — die Verankerung als runtime-UNTER-ACHSE der Hardware-SYSTEMachse fehlt im Code = **TODO-runtime-Unterachse** (referenzieren, nicht doppeln) |
| `AtomicFamily {None, CAS, LLSC, RmwExtended}` (:31-32) | keine Live-Achse; nur implizit in axis_08-Organen (LockFree/WaitFree/OLC nutzen CAS-Primitive, `axis_08_concurrency_registry.hpp:23-25`) | **kein Live-Gegenstück**; Registry 12.5 divergiert zusätzlich (Granularität CAS_64/128 vs. Familie, REGISTRY:229-234) → Deep-Research-TODO + **Registry-Reparatur** |
| `IHardwareStrategy` (5 pure-virtual Getter + vDtor, :45-51) | CRTP+Concept-Substanz live: Pflicht-Properties `cache_line_size()/memory_page_size()/simd_width_bits()/numa_capable()/huge_page_capable()` (`axis_12_general_hardware_concept.hpp:21-25`), CRTP-Basis mit 3-fach Concept-Check (`axis_12_general_hardware_strategy_base.hpp:16-29`) | **obsolet** (vtable-Form); Substanz **live-gedeckt** als compile-time-Properties. WICHTIG: axis_12 ist DefinitionOnly/build-only (`axis_observer_classification.hpp:68`), NICHT in binary_id (C §1) — als gemessene System-HAUPTACHSE mit Unter-Achsen = **TODO-Systemachse** Hardware |
| `DefaultHardwareStrategy` (Defaults AVX2/L1/Local/Prefetch/CAS, :55-70) | Live-Defaults = CMake-enabled-Flags (`Root-CMakeLists.txt:272-274`) + Registry-enabled | **obsolet** |

### 2.2 H2 `locking_mode.hpp` (Achse 8.2, 39 Z.) — Thema LOCKING

| Entwurfs-Element (Beleg) | Live-Gegenstück (Beleg) | Verdikt |
|---|---|---|
| `LockingMode::ReadOnly` („std::shared_mutex shared", locking_mode.hpp:21) | Organ `ReaderWriterConcurrency` (`axis_08_concurrency_registry.hpp:23-25`) | **live-gedeckt** (Organ/Gattung) |
| `LockingMode::ReadWrite` („std::mutex exclusive", :22) | Organ `BlockingConcurrency` = echter coarse-grained std::mutex mit ehrlicher Contention-Zählung (`axis_08_concurrency_blocking.hpp:17-19`; `axis_08_concurrency_observable.hpp:89-100`) | **live-gedeckt** (Organ/Gattung) |
| `LockingMode::Upgradeable` („boost::shared_mutex upgrade", :23) | kein Organ vorhanden (9 Organe, Registry-Liste C §2) | Organ-Lücke der GATTUNGS-Seite (kein Systemachsen-Thema); Kandidat für Achsen-Katalog-Erweiterung, eigener Fork — hier nur registriert |
| `LockingMode::OptimisticValidation` („OLC, HTM", :24) | Organe `OlcOptimisticConcurrency` + `OlcReservedBlocksConcurrency` (Registry ebd.) | **live-gedeckt** (OLC); HTM ohne Live-Anker |
| `preferred_mode()` (vtable, :34-35) | compile-time-Tag CC1 `synchronization_pattern_tag` (`axis_08_concurrency_subaxes_cc1_to_cc2.hpp:13`; Doku: Locking-Mode+Coherence fallen zur Reclamation-Dimension CC2 zusammen, `:4-8`) | **obsolet** (vtable); Substanz live als Sub-Achsen-Tags. Die LOCKING-SYSTEMACHSE (host-seitige Lock-/Contention-Regie+Messung „neben den Mess-System-Achsen") existiert dagegen NIRGENDS (`system_axis.hpp` kennt nur WallClock/ObserverSnapshot/Pmc, C §2) = **TODO-Systemachse** |
| Registry-Achse 8.2: `{Optimistic, Pessimistic, LockFree, WaitFree}` (REGISTRY:164-168) | Header hat `{ReadOnly, ReadWrite, Upgradeable, OptimisticValidation}` (locking_mode.hpp:20-25) — **kein einziger Registry-Name existiert** | **Registry-Reparatur** (4/4 Phantom-Enumeratoren) |

### 2.3 H3 `numa_affinity.hpp` (Achse 6.3, 29 Z.) — Thema NUMA

| Entwurfs-Element (Beleg) | Live-Gegenstück (Beleg) | Verdikt |
|---|---|---|
| `INumaAffinity::preferred_strategy()` → `NumaStrategy` (numa_affinity.hpp:24; Wertevorrat aus H1 via Include :10,20 — Header definiert KEIN eigenes Enum, B §3.2) | Allocator-Kante live: AA5 allocation_policy-Tag (NUMA-origin-aware/cache-set-aware/…, `axis_06_allocator_subaxes_aa1_to_aa7.hpp:66-70`) + F-B-`alloc_hw` (s. §2.1 Zeile 3) + HW3 memory_topology-Doku-Tag (`axis_12_…_subaxes_hw1_to_hw4.hpp:36`) | **live-gedeckt** (Gattungs-/Allocator-Kante, compile-time-Unterachse). Host-NUMA-SYSTEMachse = **TODO-Systemachse**; Laufzeit-Node-Bindung des Mess-Prozesses = **TODO-runtime-Unterachse** (Anker: `i_pinning_engine.hpp` Skelett; `hugepage_manager`/`hybrid_core_pinning` nur .gitkeep, C §5) |
| Registry-Achse 6.3: `numa_affinity.hpp::NumaAffinity::{Local,Interleave,Preferred,Bind}` (REGISTRY:122-126) | Enum `NumaAffinity` **existiert nicht** (Werte leben als `NumaStrategy` in hardware_strategy.hpp:26) | **Registry-Reparatur** (Phantom-Symbol ×4); Doppel-Führung 6.3/12.3 desselben Wertevorrats registriert (B §5.1 Zusatzbefund) |

### 2.4 H4 `scheduling_strategy.hpp` (Achse 13, 68 Z.) — Thema SCHEDULING

| Entwurfs-Element (Beleg) | Live-Gegenstück (Beleg) | Verdikt |
|---|---|---|
| `WorkerPoolLayout {ThreadPerCore, WorkStealing, CpuPinning, FreePool}` (scheduling_strategy.hpp:16-17) | KEINE Live-Entsprechung. Das einzige „Scheduling" im Code ist das Subsystem-Skelett `c11_scheduler_engine` — semantisch Page-Type-Wechsel/Op-Deferral, NICHT OS-/Thread-Scheduling (`i_scheduler_engine.hpp:2-14`; 0 Impl, 0 lib-Konsumenten, CMake fehl-etikettiert `CMakeLists.txt:1-5`; C §5) | **TODO-Systemachse** Scheduling (Hauptachse). Härtester Live-Beleg für „Pflicht und kaputt". Thesis führt Scheduling nur DESKRIPTIV je Paper (`03_messsystem_prtart.tex:194-197` + Tab. hw-sched `:204-219`; E §3.5) |
| `get_simd_worker_count_limit()` als `size_t`, Default 2 („Hardware-Limit", :40,55) | RC-Feld `thread_count` (`resource_controllable_tier.hpp:35`): durchgereicht, zählt NIE als applied, in-Prozess wirkungslos, echter Threading-Konsum = Fix A #221 deferred (`abi_adapter.hpp:254-262`); dynamische Baum-Ebene `concurrency.thread_count` (`profile_to_tree.hpp:92-93`) | **TODO-runtime-Unterachse** der Scheduling-Systemachse: `thread_count` REFERENZIEREN (Steuerkanal existiert), nicht duplizieren (D §2.3); Wirksamkeit hängt an #221 |
| `HeteroCoreDispatch {None, HybridAware, PCoresOnly, ECoresOnly}` (:19-20) | Mess-Cap `hybrid_core_aware` existiert (`i_measurement_source.hpp:55`); P-/E-Core-Trennung im Thesis-Messplan (`05_evaluation.tex:61-67`); Treiber-Seite = G-270a, GEPARKT (LEDGER:371 E17-Kontext, LEDGER:1122) | teils: Mess-Erkennungs-Seite live; Dispatch-Regie = **TODO-runtime-Unterachse** der Scheduling-Systemachse (gated durch G-270a-Parkstatus — Fork-Hinweis §7 S-1) |
| `CoRoutineStrategy {None, Interleave, DependencyTracking}` (:22-23) | nichts; Registry 13.4 bezeichnet unter derselben ID „Memory-Interleave {NoInterleave, RoundRobin, FirstTouch}" (REGISTRY:255-259) — **Achsen-ID-Kollision** | kein Live-Gegenstück; **Registry-Reparatur** (ID-Kollision auflösen); Neubau nur nach Deep-Research |
| `BatchGranularity {Single, MicroBatch, MacroBatch}` (:25-26) | RC-Feld `batch_size` real adapter-konsumiert, genus-invariant (`abi_adapter.hpp:281-284`) | **live-gedeckt** als runtime-Unterachse der GATTUNGS-Seite (axis_03a-Fenster-Semantik) |
| `ISchedulingStrategy` (5 Getter, vtable, :39-45) + `DefaultSchedulingStrategy` (:49-64) | Ersatzform für die System-Seite = CRTP-SystemAxis-Wurzel (`system_axis.hpp:147-190`) | **obsolet** (vtable-Form doktrinwidrig) |
| `SubEngineSlot::C11_Scheduler` (i_sub_engine.hpp:14-15,26; Pipeline-letzter :30-36) | dopplungsfreier Runtime-Slot der CE-Pipeline; KEINE Code-Verbindung zur Achse 13 (grep-Befund B §4.5) | Doppel-Modellierung ohne Verbindung = die dritte „missverstandene Stelle"; Auflösung: Slot bleibt CE-Runtime-Konzept, Systemachse wird eigenständig gebaut (§6 S-2) |

### 2.5 Registry-Wahrheits-Matrix (AxisLibraryRegistry ↔ Header — vollständig)

Die Registry wurde 3 Tage NACH den Headern voll ausgebaut und von Anfang an nicht gegen sie
geschrieben (Commits `7a6c563f` 18.05. → `04a2bd1c` 21.05.; B §7/§9-Zeitfolge):

| Achse | Registry sagt (Beleg) | Header-Realität | Befund |
|---|---|---|---|
| 6.3 | Enum `NumaAffinity` ×4 (REGISTRY:122-126) | Enum existiert nicht | PHANTOM-SYMBOL |
| 8.2 | `{Optimistic, Pessimistic, LockFree, WaitFree}` (REGISTRY:164-168) | `{ReadOnly, ReadWrite, Upgradeable, OptimisticValidation}` (locking_mode.hpp:20-25) | PHANTOM ×4/4 |
| 12.1 | SimdFamily ×5 (REGISTRY:197-201) | identisch (hardware_strategy.hpp:20) | MATCH 5/5 |
| 12.2 | CacheLevelTarget ×4 (REGISTRY:203-211) | identisch (:23) | MATCH 4/4 |
| 12.3 | NumaStrategy ×4 (REGISTRY:213-219) | identisch (:26) | MATCH 4/4 |
| 12.4 | „Prefetch-Distance" T0/T1/T2/NTA-Hints (REGISTRY:221-227) | „Prefetch-Hardware" Instruktionsfamilie (:28-29) | DIVERGENZ (Name+Werte) |
| 12.5 | „Atomic-Granularity" CAS_64/128/LL_SC/Ordering (REGISTRY:229-234) | `AtomicFamily` (:31-32) | DIVERGENZ |
| 13.1 | WorkerPoolLayout ×3 (REGISTRY:237-243) | ×4 — `FreePool` fehlt (scheduling_strategy.hpp:17) | UNVOLLSTÄNDIG |
| 13.2 | diskret {1,2,4} (REGISTRY:245-248) | kontinuierlich `size_t`, Default 2 (:40,55) | semantisch ok, Form divergiert |
| 13.3 | „Heterogeneous-Awareness" ×2 (REGISTRY:250-253) | `HeteroCoreDispatch` ×4 (:20) | DIVERGENZ |
| 13.4 | „Memory-Interleave" ×3 (REGISTRY:255-259) | „Co-Routine-Strategy" ×3 (:22-23) | **ID-KOLLISION** |
| 13.5 | Batch ×3 (REGISTRY:261-265) | identische Namen (:26) | MATCH 3/3 |

Zusatz: Der f6-Migrationsplan zitiert die KORREKTEN Header-Enumeratoren, die Registry die falschen —
die Registry ist gegen beide Quellen inkonsistent (ce `docs/architecture/19_f6_prtart_migration_plan.md:41-47`
vs. REGISTRY:164-168; B §6). Verdrahtungs-Vorsicht: `AutoPermutator::discover_axis_implementations()`
ruft `AxisLibraryRegistry::lookup` real auf (REGISTRY:321-323) — ob dieser Pfad im OFFIZIELLEN
E4-Weg konsumiert wird, ist NICHT belegt (kein Beleg in Strang C/E für AutoPermutator im
E4-Pfad); vor der Registry-Reparatur ist der Konsumstatus zu verifizieren (§6 S-1, VERIFY V-2).

### 2.6 Compiler + Stufen (Kontext-Zeilen der Delta-Matrix)

| Element | Entwurf/Registry | Live | Verdikt |
|---|---|---|---|
| Compiler je TIER-Permutation | Registry-Achse 15.1–15.5 (GCC/Clang/AppleClang/MSVC + Opt/LTO/PGO/Arch; V35.B.1 `2863b3f1`; REGISTRY:274-313) — als AutoPermutator-TIER-Achse modelliert | EIN globaler Env-Knopf `COMDARE_CXX` (Default `g++-16`, `profile_run_facade.cpp:95-98`, Injektion `:150`); `make_gpp_compile_fn(…, cxx)` compiler-parametrisiert (`build_orchestrator.hpp:466-489`); nicht XML-getrieben, nicht per Permutation, nicht binary_id | **TODO-Systemachse** (Neu-Design §3; Registry-15 ist NICHT die geforderte Systemachse, B §5.2) |
| Compiler für den CEB SELBST | nichts (grep-Befund B §0/§5.2: „keinerlei Bestand") | CMake-Configure-Entscheidung; Presets `gcc-release`/`clang-release` existieren (`CMakePresets.json:37-55`); `-clang`-Build-Tree koexistiert (base-pipeline.yml:845) | **TODO-Systemachse** (Host-Hälfte, §3.3) |
| Stufen-Zählung | Registry-Achse 14 ENGINE-CHOICE führt 4-stufig V1–V4 (REGISTRY:267-272, V4 „CEB enumeriert alle V32-Permutationen") | 3 Stufen kanonisch: `Stufe1_CeOnly/Stufe2_PrueflingReplace/Stufe3_FullJoin` (`pruefling_merge.hpp:130-134` via `experiment_phase_strategy.hpp:53-57`; ce 34:81-85) | Spannungsfeld zum User-Diktum „KEINE 4. Stufe" — Registry-14 ist eine ANDERE Dimension (Engine-Betriebswahl), keine Prüfstufe; Klarstellung/Etikettierung = Fork §7 S-3 |
| Mess-System-Achsen (Vergleichszeile) | — (kein Entwurfs-Header) | VOLL gebaut, konsumentenlos-gated: `system_axis.hpp`/`measurement_axis_registry.hpp`/`i_measurement_source.hpp`/`curve_fit`/CoR (C §6; LEDGER:150/402/655) | **live-gedeckt** (Wurzel + 16 Kategorien); E4-Wiring = Folge-Increment (#156/E4′), KEIN Reparatur-Gegenstand |

**Delta-Matrix-Fazit:** Von den 4 Pflicht-Themen ist die GATTUNGS-Substanz überall dort live, wo der
Entwurf Algorithmus-Verhalten meinte (SIMD/ISA, NUMA-Allocator-Kante, Locking-Organe, batch_size).
Die SYSTEM-Seite derselben Themen (Host-Regie + Messung „nach einer Strategie") existiert für ALLE
VIER nicht — plus fehlende Compiler-Systemachse, plus flache 16er-Registry ohne Haupt-/Unter-Struktur,
plus inkonsistente AxisLibraryRegistry. Das deckt die drei „missverstandenen Stellen" (LEDGER:368):
(i) die vtable-Header wurden als „Duplikate" gelesen, obwohl das PFLICHT-KONZEPT dahinter
(Systemachsen-Familie) nie gebaut wurde; (ii) #37 plante Scheduling als 27. ORGAN-Achse statt als
Systemachse (LEDGER:392(c)/102); (iii) NUMA/Locking wurden auf Allocator-Knopf/Organ-Achse
reduziert (LEDGER:360; super 18:95).

---

## 3. COMPILER-SYSTEMACHSEN-DESIGN (gcc|clang je CEB + je Tier-Binary; XML; golden-neutral)

### 3.1 Grundsatz und Zerlegung

Die Compiler-Systemachse hat per F3i(1) zwei Hälften mit verschiedener Mechanik, aber EINEM
Achsen-Konzept (compile-time-Hauptachse + runtime-Unterachsen, LEDGER:368):

- **(a) Tier-Hälfte:** gcc|clang je Tier-Binary-PERMUTATION — wirkt in der Laufzeit-Bau-Orchestrierung
  des CEB (der die Tier-Binaries ZUR LAUFZEIT baut, LEDGER:89/118).
- **(b) Host-Hälfte:** gcc|clang für den CEB SELBST — eine Configure-Zeit-Entscheidung, die der
  laufende CEB nicht an sich selbst vollziehen kann (er müsste sich selbst neu bauen, D §2.2);
  sie gehört auf die Orchestrierungs-Ebene DARÜBER: den Experiment-Planer (§5).

Direktiven-Rahmen: strikt compile-time-Hauptachse, KEIN Runtime-Switch (MEM
`feedback_no_runtime_switch`, `feedback_compile_time_only_no_runtime`); dynamisches Laden nur
cold-start über die bestehende DLL-Naht.

### 3.2 (a) Tier-Hälfte: Compiler als 4. BUILD-ACHSE (Build-Varianten-Muster, EMPFOHLEN)

Drei Kandidaten wurden geprüft (D §2.1); zwei scheiden aus, einer trägt:

1. **binary_id-Segment — HART ABGELEHNT.** `StaticBinaryView::operator[]` emittiert JEDE statische
   Ebene, auch gepinnt (`experiment_tree.hpp:266-288`) ⇒ eine zusätzliche Ebene ändert JEDEN der 320
   eingefrorenen golden ids (`golden_fullpilot_320_binary_ids.txt:1-4` „NICHT neu generieren") und
   bricht `test_profile_roundtrip` (POSITIONSIDENTISCH, `test_profile_roundtrip.cpp:5-10,87-94`;
   CI-Gate `contract:profile_coverage`, ce `.gitlab-ci.yml:281-293`). Zudem Verstoß gegen die
   Tag-Doktrin „Lauf-Konfiguration reist NICHT in der binary_id"
   (`cache_engine_builder_iterator.hpp:89-94`).
2. **Nur .version-Sidecar — unzureichend, aber notwendiger Bestandteil.** `build_version` ist ein
   freier String (`build_orchestrator.hpp:62`); compiler-augmentiert (z. B. `m3v2+clang22`) macht
   `dll_is_current` sofort compiler-korrekt (`:166-174`) — liefert aber weder Koexistenz beider
   Artefakte (gleicher Pfad würde überschrieben) noch CSV-Trennung noch abfragbare Identität.
3. **Build-Varianten-Muster (EMPFOHLEN):** Compiler als **4. Build-Achse analog page_type/09b/12** —
   „Build-Parameter DERSELBEN 19-Slot-Binary, KEINE eigene Gattung, kein 20. Slot" (ce Doc
   `27_…:79-102,161`; `build_variant_inspection.hpp:8-9`; Beweis-Test `genus_adhoc_buildvariant.cpp:1-7`).

Konkrete Bausteine des empfohlenen Musters (alle Andockpunkte existieren, D §3-Tabelle):

| Baustein | Mechanik | Beleg |
|---|---|---|
| Hauptachsen-Wert je Permutation | Toolchain-Pass je Wert: je Toolchain ein `provision_all`-Pass mit eigenem CompileFn — `make_gpp_compile_fn` ist bereits compiler-parametrisiert (`cxx`-String) | `build_orchestrator.hpp:466-489,198-202`; Pass-Vorbild Sweep/SOTA `profile_run_entry.hpp:243-244` |
| Artefakt-Koexistenz | je Toolchain ein Unterbaum `dll_dir/<toolchain>/<stem>/perm.dll` (per_binary_subdirs-Layout je Baum unverändert) — der Voll-Vergleich braucht gcc- UND clang-Artefakt derselben Permutation GLEICHZEITIG | `build_orchestrator.hpp:265-274,63-65` |
| Build-Resume | compiler-augmentierte `build_version` im `.version`-Sidecar (Kandidat 2 als Bestandteil) | `build_orchestrator.hpp:62,161-179,282-287,322` |
| Mess-Resume | neuer Lauf-Freiheitsgrad ⇒ PFLICHT-Stamp-Bump resume-v5→v6 mit `|cxx=<id>` (dokumentierte Disziplin: jeder neue Freiheitsgrad MUSS in den Stamp, sonst stale-Resume) | `cache_engine_builder_iterator.hpp:559-613, 573-584` |
| Selbst-beweisende Identität | additives extern-"C"-Symbol `comdare_toolchain_inspect` im generierten perm.cpp (Emission single-source `render_adhoc_module_source`), befüllt aus `__clang__`/`__GNUC__`-Prädefinitionen — die DLL SAGT, womit sie WIRKLICH gebaut wurde (Deklarations-Wahrheit wie beim ISA-Kohärenz-Guard) | `adhoc_emitter.hpp:83-89`; Muster `build_variant_inspection.hpp:6,18-37`; `anatomy_module_abi_v1.hpp:73-82` |
| CSV/Auswertung | neue Tag-Spalte `toolchain` nach dem platform/build_version-Muster (NICHT binary_id; additiv ans Ende wie PMC-Spalten) | `cache_engine_builder_iterator.hpp:89-94,178-182,267` |
| XML-Steuerung | eigener `<toolchains>`-Block in Registry-/Experiment-XML (Bausteine je Engine analog `cache_engine_axis_registry.xml`) + Lauf-Default in `<run_options>` (trägt heute schon platform/build_version) | `m3v2_study.profile.xml:152`; MEM `feedback_unified_experiment_xml_plus_system_registry_xml` |
| Gating additiv, Default-OFF | Vorbild CI: `COMDARE_CLANG_MATRIX=="1"` opt-in advisory + `COMDARE_ISA_MATRIX` | ce `.gitlab-ci.yml:68-80,114-135`; base-pipeline.yml:832-846 |

**Golden-320-Neutralität (Beweis-Skizze):** Default = genau 1 Toolchain-Wert `gcc`
(cxx=`g++-16` wie heute, `profile_run_facade.cpp:97`) ⇒ 1 Pass, byte-identische
binary_ids/Stems/Pfade/Sidecars/CSV-Kernspalten; clang = zusätzlicher Wert, Default-OFF, additiv
gated. Der Stem hängt NUR am binary_id+index — compiler-frei (`build_orchestrator.hpp:152-159`).

**Runtime-UNTER-ACHSEN der Tier-Compiler-Hauptachse:** „welcher Compiler unter WELCHER Datenlast"
(F3i(2)) entsteht bereits als Kreuz Compiler-Pass × bestehender dynamischer Filterbaum
(`RuntimeVariableLoop` über `tree.dynamic_filter()`, `cache_engine_builder_iterator.hpp:13-16,82-86`)
— ohne neuen Mechanismus. Compiler-SPEZIFISCHE Runtime-Knöpfe (glibc-Tunables/LD-Optionen) wären
eine echte eigene Unter-Achse — HEUTE OHNE Code-Anker, Deep-Research-TODO (MEM
`feedback_axes_optimization_semantics_deep_research_observer_strategy`); NICHT raten.

### 3.3 (b) Host-Hälfte: HostToolchainSystemAxis + Planer-Start

- Die XML-Wahl der CEB-Toolchain vollzieht der **Experiment-Planer** (dritte Anwendung, §5): er
  interpretiert die Experiment-XML und startet das passende, bereits koexistente Host-Artefakt
  (gcc-CEB oder clang-CEB; Presets `CMakePresets.json:37-55`, `-clang`-Tree base-pipeline.yml:845).
  Das folgt dem E4-Prinzip „XML steuert den Versuchsaufbau; CEB orchestriert" (MEM
  `feedback_e4_xml_autoritative_bauanleitung_ceb_orchestriert`).
- Die compile-time-HAUPTACHSEN-Identität des CEB ist bereits HINEINKOMPILIERT — als Provenienz
  `compiler_id/compiler_version/cxx_flags/isa_built_for` (`build_provenance.hpp.in:8-11`;
  `provenance.cmake:42-67`) mit Manifest-Export je Mess-Lauf (`provenance_manifest.hpp:73-96`).
  Eine **`HostToolchainSystemAxis`** nach der bestehenden CRTP-Wurzel (`system_axis.hpp:147-180`)
  ist eine reine Definitions-/Provenienz-Achse: `collect` liest die constexpr-Provenienz statt
  Counter („Definition statt Observer", ce Doc 27:202-212) — konsistent mit „immer präsent"
  (`system_axis.hpp:143-145`). Export: Manifest-Sidecar + CSV-Tag-Spalte `host_compiler`.
- **runtime-UNTER-ACHSE der Host-Hauptachse:** das Muster existiert wörtlich — compile-time-Identität
  `isa_built_for` + runtime-Faktum `isa_ran_on` (cpuid) im selben Manifest
  (`provenance_manifest.hpp:58-69,83`). Analog trägt die Host-Toolchain-Achse als Runtime-Unterebene
  die Ausführungsumgebung des konkreten Laufs (Host-CPU/OS) — vorhandene Quellen, keine Duplikate.

### 3.4 ISA+OS-Einordnung

Die Compiler-Achse ist ORTHOGONAL zu ISA und OS und darf sie nicht doppeln:
- **ISA:** bereits zweifach getragen — T12-ISA-Kompositionsachse + simd_extension/09b-Build-Achse
  (Thesis `03:80,129`; `registry_to_axis_levels.hpp:67-76`); 3-ISA-Kanon amd64/arm64/riscv64 als
  Pflicht-Matrix (`docs/sessions/20260706-276-VOLL-PLATTFORM-MATRIX.md:54`; CI `build:arm64-smoke`
  ce `.gitlab-ci.yml:114-135`). Die dortige Compiler-Zeile („mindestens g++ 15.3 UND neuester clang",
  ebd. :3) ist der dokumentierte Vorläufer von F3i(1).
- **OS:** zwei Betriebssystem-Regimes sind im Thesis-Messplan verankert (Talos immutable vs.
  root-Linux perf/MSR; `05_evaluation.tex:67-74`, `06_fazit.tex:61-62`); Windows bleibt Grenze:
  `make_system_compile_fn` ist MSVC-fest, eine gcc|clang-Achse ist dort heute nicht abbildbar
  (`build_orchestrator.hpp:450-461`; Risiko R3, clang-cl = eigener späterer Baustein).

### 3.5 Risiken/Verifikationen (ehrlich, KEIN Raten)

- **V-1 (PFLICHT VOR BAU):** Die festen rsp-Flags von `make_gpp_compile_fn` — insbesondere
  `-fno-gnu-unique` — sind gegen das konkrete clang-Release zu verifizieren
  (`build_orchestrator.hpp:474-479`). Der grüne clang-CI-Build (clang-22.1.8, `.gitlab-ci.yml:70`)
  belegt nur den HOST-Pfad, NICHT den rsp-DLL-Pfad (D §4 R2).
- **ABI-Mischbetrieb** (gcc-Host lädt clang-DLL): die ABI-Grenze ist bewusst extern-"C"+uint64-PODs
  (`build_variant_definition.hpp:9,16`; `anatomy_module_abi_v1.hpp:15`) — trägt Cross-Compiler-Laden;
  trotzdem explizites Smoke-Gate gcc-Host×clang-DLL in CI (Muster contract:-Jobs,
  `.gitlab-ci.yml:188-213`; D §4 R4).
- **Golden:** jede Variante, die binary_id/Stems/Default-Pfade ändert, bricht Roundtrip+Resume —
  das empfohlene Muster lässt den Default-Pfad byte-identisch (D §4 R1).

---

## 4. VOLL-VERGLEICHS-SPEZIFIKATION JE STUFE (F3i)

### 4.1 Die Vergleichs-Matrix

F3i(2) (LEDGER:368) definiert den Voll-Vergleich als: **jede Tier-Binary unter Last gegen ALLE
anderen** — Erkenntnisziel „welche Achsen-Permutationen unter welchen Datenlasten mit welchen
Compilern auf welchen ISA+OS am besten laufen". Als Matrix (Träger je Dimension, alle existent
außer Compiler):

| Dimension | Träger (IST) | Beleg |
|---|---|---|
| Achsen-Permutation | 19-Slot-binary_id + Build-Achsen; lazy StaticBinaryView (nie voll materialisiert) | `axis_path_serialization.hpp:30-34`; `experiment_tree.hpp:14-25,235` |
| Datenlast | Achse-2-Lastprofile / E4-Workloads (YCSB-ähnlich per Aufgabenstellung) | `profile_run_facade.cpp:105-143`; `aufgabenstellung/de.tex:75-84` |
| Compiler | **NEU** — Tier-Toolchain (2 Werte je Permutation) × Host-Toolchain (2) | §3; LEDGER:368 F3i(1) |
| ISA | T12 + 09b + 3-ISA-Kanon amd64/arm64/riscv64 | `03:80,129`; `20260706-276-…:54` |
| OS | 2 Mess-Regimes Talos vs. root-Linux (#276-Matrix als Träger) | `05_evaluation.tex:67-74` |

Die paarweise Rangbildung „jede gegen alle" hat zwei dokumentierte Unterbauten: (i) das
Hybrid-„Compare-Feature auf E4" („kombinierte Wall-Clock … cross alle Tier-Binaries über alle
Operationen mitloggt", super 19:71 — Hybrid-Strecke, gated) und (ii) die Thesis-Sensitivitäts-/
Rang-Analyse (welche Achse trägt die meiste Varianz; Rangbildung über 3 Granularitäten →
Standard-Konfig je Workload-Klasse, `05_evaluation.tex:114-124`). Der explizit PAARWEISE
Voll-Vergleich mit Compiler+ISA+OS als Vergleichs-Schlüsseln ist dagegen NUR in LEDGER:368
verankert (A §9) = Neubau-Anteil.

### 4.2 Statistik-Bezug (Welch / Reihe C)

- Werkzeug existiert: `f15_compare` = „CLI-Treiber F15-Messlauf … Welch + Holm-FWER gegen Baseline"
  (`CE/apps/f15_compare/main.cpp:2-9`); historischer CEB-Auftrag „Mess-Aggregation Welch-t" (super
  14:740-753).
- User-Entscheide binden die Ausführung: **E2** Welch-Konsument = EIGENE Pipeline-Stufe;
  **E3** „3 Wiederholungen je Messkonstellation PFLICHT … Welch rechnet auf der WIDE-CSV über die
  Wiederholungen; n_repeats≥3 wird Pflicht-Validierung" (LEDGER:371). Brücken-Increment **I6**
  (Welch-CSV-Konsument: Gruppierung + welch_t_test/MWU aus persistierter CSV, Pairwise-Ausgabe,
  Fixture-Gate mit handgerechnetem p) ist der Bauplatz
  (`20260716-fork-a-bruecken-dossier/DOSSIER-ENTWURF.md:85`).
- Der Voll-Vergleich erweitert I6 um die neuen Gruppierungs-Schlüssel `toolchain`/`host_compiler`
  (CSV-Tag-Spalten, §3.2) + platform/OS — KEINE neue Statistik-Maschinerie.

### 4.3 „Alt gegen neu" = SdT vs. Prüfling, JE der 3 Stufen (KEINE 4. Stufe)

- Die 3 Stufen sind kanonisch und code-verankert: `Stufe1_CeOnly / Stufe2_PrueflingReplace /
  Stufe3_FullJoin` (ce `anatomy/pruefling_merge.hpp:130-134`, Alias
  `experiment_phase_strategy.hpp:53-57`; Doktrin ce 34:81-85, Ursprung super 14:777-849;
  3-Phasen-Experiment-XML LEDGER:118). SOTA-Pässe je Stufe existieren (`sota_catalog.hpp:202,237`
  mit eigener `sota_binary_id` `:73`); 3 offizielle Experiment-XMLs liegen vor
  (`Code/experiment_config/config_a_prt_art_vs_sota.xml`, `config_b_cache_engine_perms.xml`,
  `config_c_merge_alt_neu.xml`; C §9).
- **User-Neudefinition (bindend):** „alt gegen neu" = SdT vs. Prüfling (PRT-ART), „für alle genannten
  Ketten", als EIGENE Kategorie mit Unterkategorien **JE STUFE** — KEINE 4. Stufe (LEDGER:368).
  Rollen-Doktrin: PRT_ART=Prüfling, CacheEngine=Werkzeug (MEM `feedback_prt_art_consumes_cache_engine`).
- **Thesis-Konflikt (ehrlich benannt, Nachführung nötig):** Die Thesis definiert Reihe C heute als
  build-/versions-übergreifende REGRESSION derselben Konfiguration („build-übergreifend: alt gegen
  neu derselben Konfiguration → C", `03_messsystem_prtart.tex:465-470,479-482`; `05_evaluation.tex:103-106`)
  — NICHT deckungsgleich mit der User-Semantik. Zweiter Konflikt: die Fairness ist heute an
  „identische Compiler- und Flag-Basis" GEBUNDEN (`06_fazit.tex:14,53-59`) — mit der Compiler-Achse
  wird daraus „Compiler als kontrollierte, protokollierte Vergleichs-Dimension; Fairness = Vergleiche
  INNERHALB einer Compiler-Belegung, Achsen-Vergleich ÜBER Belegungen" (E §3.1/§3.5). Beides ist
  Thesis-Text-Arbeit (F11 „Ist-Stand an ALLEN Stellen updaten", LEDGER:370) — gehört ins
  Thesis-Repo, nicht ins Impl-Repo (MEM `feedback_text_agent_sessions_belong_in_thesis_not_impl_repo`).
- **Registry-Achse 14 (V1–V4)** ist KEINE vierte Prüfstufe, sondern eine Engine-Betriebswahl-Achse
  (REGISTRY:267-272) — die Etikettierung ist gegen das „keine 4. Stufe"-Diktum klarzustellen
  (Fork §7 S-3). Ebenso ist der von E11/R-C(i) geflaggte „4. merge-Wert" (build-übergreifend)
  eine SEPARATE Design-Entscheidung (SYNTHESE-E11-E13 :60), die der User mit F3(i) explizit auf
  „erst UNTERSUCHEN" gestellt hat (LEDGER:370) — hier NICHT entschieden.

### 4.4 Ausführungs-Semantik (Zusammenführung)

Je Stufe s ∈ {1,2,3} gilt: SdT-vs-Prüfling ist der **MergeStrategy-Diskriminator INNERHALB der
Stufe** (pruefling_merge), und der Voll-Vergleich läuft als Rang-/Paar-Analyse über das
Kreuzprodukt (Permutationen der Stufe) × Datenlast × Tier-Compiler × Host-Compiler × ISA × OS —
Compiler/ISA/OS sind GRUPPIERUNGS-Schlüssel der Auswertung (CSV-Tags + Manifest), NIE Teil der
binary_id (§3.2; `cache_engine_builder_iterator.hpp:89-94`). Mess-Gültigkeit bleibt unangetastet:
Zwei-Phasen-Op-Schleife + Konformitäts-Gate (ce 34:104-106), 3 Wiederholungen Pflicht (E3),
honest-0 vor Phantomwert (super 18:105; LEDGER:118).

---

## 5. DIE DRITTE ANWENDUNG: EXPERIMENT-PLANER MIT XML-INTERPRETER

### 5.1 Anwendungs-Zählung (Abgrenzung)

Das Framework trägt heute ZWEI tragende Anwendungen im Sinne des Thesis-M-Modells
(`03_messsystem_prtart.tex:393-396,412-415`):
1. **`messung_driver`** (SUPER/Code/02_messung_driver) = das WAS — „Master-Orchestrator fuer die 3
   Pflicht-Messreihen A/B/C … konsumiert comdare::builder::ExperimentDriver" (`main.cpp:4-12`);
   E4-XML = DEFAULT-/ALLEINWEG (`main.cpp:561-625`).
2. **`CacheEngineBuilder`** = das WIE — „autonomes Plattform-Ausmess-System" (`03:395-396`); als
   App heute ein dünner Demo-Wrapper um die ExperimentDriver-Lib (Selbstauskunft „This Builder is
   the cache-engine-Demo-Driver", `CE/apps/cache_engine_builder/main.cpp:2-12,84-86`).

Die übrigen 7 ce-Apps sind Werkzeuge (Codegen/Validatoren/Prüfdock-Runner `perm_runner`/
`f15_compare`; E §2.1-Tabelle), die 8 super-Stufen 01–09 sind Auswertungs-CLIs (E §2.2). Ein
Executable mit der Aufgabe „Experiment PLANEN" existiert nicht (E §2.3): der Experiment-XML-Parser
ist nur ein Lib-Modul (`parse_experiment_profile`, `xml_config_parser.hpp:323`;
`validate_experiment_profile`, `validate_profile.hpp:444ff`), die Planungs-Bausteine
(ExperimentTree/StaticBinaryView/BuildSelection/CoR/Repetition-Plan/SLURM-Launcher) sind
ausnahmslos Header, und die heutige Experiment-XML-AUSFÜHRUNG ist die per Fork A deprecatete
v32-Parallelstrecke. **Der Planer ist die dritte Anwendung** (das PLANEN/„WANN-WAS-WOMIT") —
einzige Verankerung LEDGER:368, anschlussfähig an F1 (XML-Programmier-Bibliothek) und F6
(CI-Interpreter + Live-Tracking, beide LEDGER:370).

### 5.2 Sein Kern: der Experiment-B+-Baum-FILTER für die CEB-Stufe

- Der „Experiment-B+-Baum" des Users ist der achsen-geschichtete Präfixbaum (Benennungs-Ehrlichkeit:
  kein textbook-B+-Baum, Name historisch/aspirational, `experiment_tree.hpp:4-10`) — das
  PLANUNGS-Resultat: lazy, nie voll materialisiert, `binary_count()` = ∏, dynamische Variablen als
  virtuelle for-Schleifen (`experiment_tree.hpp:14-26`).
- Der geforderte **„Filter für die Stufe der CacheEngineBuilder"** existiert exakt als
  CoR-Filterkette `selection_filter_chain.hpp` (S4: „Chain of Responsibility (GoF) im
  CacheEngineBuilder fuer die Kontrolle der Tier-Binary-GENERIERUNG (Doc 20 §C). Schliesst die …
  Feedback-Kante Auswertung (best_binary_selector) → Generierung (build_orchestrator provision_all)",
  `:2-6`; `FilterVerdict`/`FilterHandler`/`ResumeFilter` `:32-83`; Runner → reduzierte
  `BuildSelection` mit Provenance `…|filtered:cor` `:87-101`; Slice 1, ce `076b71cf`).
- **KERNBEFUND:** Der Filter ist UNVERDRAHTET — einziger Konsument ist `test_d15`
  (`tests/unit/CMakeLists.txt:1515`); der offizielle E4-Pfad selektiert ausschließlich per
  `select_explicit` OHNE Filterglied vor `provision_all` (`profile_runner.hpp:238,268`;
  `profile_run_entry.hpp:314,341,397`). Andockpunkt = die Pass-Schleife
  `run_lazy_static_then_dynamic(tree, sel, a.compile, …)` (`profile_run_entry.hpp:328,355,413`;
  Iterator `cache_engine_builder_iterator.hpp:666`): dort muss `sel` künftig durch die CoR-Kette
  laufen (Kandidaten = Selektion + MeasurementRow-Join über binary_id), bevor gebaut wird (E §1.4).
  Gated-Restglieder laut Doc 20 §E: PaperComparison (data-gated) + Pareto/Dominanz (braucht
  Messkurven-Typsystem) — additiv als weitere Kettenglieder (super 20:66; `selection_filter_chain.hpp:15-20`).

### 5.3 Funktionsumfang (SOLL aus den User-Direktiven) + Andockpunkte

| Planer-Funktion | User-Anker | Existierender Unterbau (Andockpunkt, KEINE Parallelstruktur) |
|---|---|---|
| Experiment-XML interpretieren (2 Registries + Experiment-XML, 3-Phasen) | LEDGER:118/368; MEM `feedback_unified_experiment_xml…` | Parser INC-D: `parse_experiment_profile` + `validate_experiment_profile`, golden-getestet gegen die REALEN Registries (`test_experiment_parser.cpp:1-16`) |
| Planung „nach einer Strategie" | LEDGER:368 | Strategy-Familie `PhaseStrategyFor<S>`/CRTP (`experiment_phase_strategy.hpp:70-138`); MergeStrategy-Single-Source (`pruefling_merge.hpp:130-134`) |
| CEB-Stufen-Filter | LEDGER:368 | CoR-Kette + BuildSelection + StaticBinaryView (§5.2; `coverage_selection.hpp:25-30,37-76`; `provision_all` `build_orchestrator.hpp:191-202`) |
| Host-Toolchain-Wahl (gcc-CEB xor clang-CEB) | LEDGER:368 F3i(1) | Presets + koexistente Build-Trees (§3.3; `CMakePresets.json:37-55`; base-pipeline.yml:845) |
| Auswertung/Veröffentlichung/Speicherort je Experiment wählbar | F1 (LEDGER:370) | Auswertungs-Stufen 01–09 als CLIs (E §2.2); E8 EINE CSV; E9-Serie (Envelope-Root, F2) |
| CI-Interpreter + Live-Feature-Tracking | F6 (LEDGER:370) | CI-Template-Familie (base-pipeline.yml); Doc 22 (CI-Interaktive-Anhang-Automation) — Ausbau-Increment, hier nur referenziert |

**Doppelbau-Verbot (bindend):** Die dritte Anwendung MUSS den EINEN offiziellen Pfad
(run_profile-Unterbau → BuildOrchestrator → AnatomyModuleLoader → Prüfdock → offizielle CSV) als
Unterbau konsumieren — Fork-A-Option-A + MEM `feedback_vor_aufgaben_erst_projektstruktur_analyse`
(„NIE Parallelstruktur"; Anlass war exakt eine v32-Parallel-Engine). Sie ersetzt NICHT
messung_driver (der bleibt E4-Mess-Host der 3 Reihen) und NICHT den CEB (der bleibt Bau-/Mess-
Orchestrator) — sie ist die Ebene DARÜBER: WAS-WANN-WOMIT-Planung, Stufen-Filterung, Host-Artefakt-
Wahl, Serien-Abarbeitung (E9), Live-Tracking (F6).

### 5.4 Offene Struktur-Fragen (→ Forks §7)

Ort der App (ce/apps vs. SUPER/Code), Verhältnis zur Brücken-Fassade I4, und ob der Planer die
`<toolchains>`-Interpretation selbst hält oder an die profile_facade delegiert — echte
Design-Entscheidungen, nicht hier zu dekretieren (§7 S-5).

---

## 6. REPARATUR-ROADMAP (geordnete Increments, je mit TABU-/golden-Nachweis)

**Rahmenbedingungen der Ordnung:** (1) DEADLINE 28.07. = CI- UND Standalone-Messfähigkeit (F12(i),
LEDGER:370) — nichts in dieser Roadmap darf den Mess-Pfad destabilisieren; (2) die Brücken-Increments
I1–I7 (Fork A) sind der aktuell beschlossene Arbeitsstrang und werden um die E-Entscheide revidiert
(LEDGER:1230; `20260716-fork-a-bruecken-dossier/DOSSIER-ENTWURF.md:80-86`) — die Systemachsen-
Reparatur ordnet sich dahinter/daneben ein und dockt an, statt zu forken; (3) CI grün + messfähig ⇒
nur punktuelle Refactorings (MEM `feedback_ci_gruen_messfaehig_nur_punktuelle_refactorings`);
(4) je Schicht Interface + testbar, 1 Review/Backup (MEM `feedback_e_schichten_separat_fertigstellen_top_down`).

| # | Increment | Inhalt | Abhängigkeit / Einordnung | TABU-/golden-Nachweis |
|---|---|---|---|---|
| **S-0** | Konzept-Verankerung (Doku) | Dieses Dossier 23 + Ledger-§-Nachtrag + Disambiguierungs-Tabelle (§1.4) in den Doku-Index; Doc-14-„Blutkreislauf"-Altbild mit Abgrenzungs-Vermerk versehen (nur additiv, MEM `feedback_never_delete_documentation`) | sofort; kein Code | reine Doku — 0 Code-/Daten-Berührung |
| **V-2** | VERIFY AutoPermutator-Konsum | Belegen, ob `AxisLibraryRegistry::lookup` (REGISTRY:321-323) im offiziellen E4-Pfad erreichbar ist (heute unbelegt, §2.5) | vor S-1 | read-only grep/Trace |
| **S-1** | Registry-Wahrheit + Header-Disposition | Gemäß Fork-Entscheid S-2 (§7): Provenienz-Strings der AxisLibraryRegistry von den toten Headern auf die Live-CRTP-Substanz umbiegen (Phantome 6.3/8.2, Divergenzen 12.4/12.5/13.3, ID-Kollision 13.4, FreePool 13.1 — §2.5) + Header-Banner-Disposition | NACH User-Entscheid Fork S-2 (F4-Rückfrage-Pflicht, LEDGER:370) | Strings/Banner sind Metadaten: kein binary_id-Einfluss (Stems compiler-/registry-frei, `build_orchestrator.hpp:152-159`); ctest-Vollsuite + `test_profile_roundtrip`==320 als Gate |
| **S-2** | Pflicht-Systemachsen-Familie (Kern der F4-Reparatur) | 4 CRTP-Ableitungen der bestehenden Wurzel (`system_axis.hpp:147-190`): `SchedulingSystemAxis`, `HardwareSystemAxis`, `NumaSystemAxis`, `LockingSystemAxis` — je compile-time-Haupt (Definition/Provenienz: Build-POD-Felder, cpuid, Topologie) + runtime-Unter (Referenz auf `thread_count`-RC-Kanal, `hw_prefetcher`-Ebene, Laufzeit-Fakten) — honest-0 wo keine Quelle; Contract-Test analog `test_m_contract_system_axis_wurzel.cpp`; KEINE Erweiterung der 16er-Mess-Registry (Fork S-4-Default) | nach S-0; parallel zu I1–I7 möglich (host-only-Header) | host-seitige Header, keine ABI-/POD-/binary_id-Berührung (Blut-TABU super 18:104/19:23 wird eingehalten, nicht verletzt); Duplikat-Verbote D §2.3/R6 (thread_count referenzieren, axis_08/axis_12 unangetastet); Suite + golden-Gate |
| **S-3** | Haupt-/Unter-Struktur der System-Seite | Typsystem-Increment nach Doc-21-Bauplan (Wurzel=System-Achsen, Visitor+Strategy, 21:21-23/235-241): Haupt-Achse↔Unter-Achsen-Beziehung im Code (heute flache 16er-Registry, §1.1); `hw_prefetcher` formal als System-Unter-Achse verankern (21:137-138) | nach S-2 (braucht die 4 Hauptachsen als Träger) | wie S-2 host-only; `profile_to_tree`-Ebenen UNVERÄNDERT (nur Zuordnungs-Metadaten) |
| **S-4** | Compiler-Systemachse (a) Tier | Nach VERIFY V-1 (clang-rsp-Flags, §3.5): Toolchain-Pass + `dll_dir/<toolchain>/`-Unterbaum + augmentierte build_version + resume-v5→v6 + `comdare_toolchain_inspect`-Symbol + CSV-Tag `toolchain` + `<toolchains>`-XML-Block, Default-OFF | nach I3/I4 (Pass-/Fassaden-Struktur der Brücke; DOSSIER-ENTWURF:82-83); NICHT vor dem 28.07.-Mess-Nachweis aktivieren | Default 1×gcc ⇒ byte-identischer Pfad (§3.2-Beweis-Skizze); resume-Bump invalidiert Alt-Resumes EHRLICH (dokumentierte Disziplin `cache_engine_builder_iterator.hpp:573-579`); golden-320-Liste ungeändert; CI opt-in advisory |
| **S-5** | Compiler-Systemachse (b) Host | `HostToolchainSystemAxis` (Provenienz-lesend, §3.3) + Manifest-/CSV-Export `host_compiler` | nach S-2 (Wurzel-Familie steht) | Provenienz existiert bereits einkompiliert (`build_provenance.hpp.in:8-11`) — reine Lese-Achse, 0 ABI |
| **S-6** | Dritte Anwendung: Experiment-Planer | App-Wrapper (Ort per Fork S-5) über Parser INC-D + Strategy INC-E + CoR-Verdrahtung in der Pass-Schleife (`run_lazy_static_then_dynamic`, §5.2) + Host-Artefakt-Wahl + E9-Serie; F6-CI-Interpreter als Folge-Ausbau | nach I1–I7 (die Brücke liefert Fassade+Kontrakte, DOSSIER-ENTWURF:80-86); Fork S-5 entschieden | konsumiert NUR den offiziellen Pfad (Option-A-Direktive); Smoke-Gate wie I4 (measurements.csv mit offiziellem Header, wörtliche Zeilen-Zählung) |
| **S-7** | Voll-Vergleich je Stufe | I6-Welch-Konsument + neue Gruppierungs-Schlüssel toolchain/host_compiler/platform/OS + paarweise Rangbildung je Stufe; SdT-vs-Prüfling via MergeStrategy je Stufe (§4.4) | nach I6 + S-4 (braucht Tag-Spalten + beide Artefakte) | reine CSV-Auswertung (Messdaten additiv, nie löschen — MEM `feedback_messdaten_nie_loeschen_abi_darf_brechen`) |
| **S-8** | Thesis-Nachführung | Fairness-Formulierung (06_fazit:14/58), Reihe-C-Schärfung (03:482), Systemachsen-/Compiler-Achsen-Kapitelstand (F11) | Text-Agent, Thesis-Repo (MEM `feedback_text_agent_sessions_belong_in_thesis_not_impl_repo`); Querverweise nur rückwärts (MEM `feedback_thesis_sequential_referencing_rule`) | Thesis-Repo; Impl-Repos unberührt |

**Bezug #37-Design:** #37-A (Scheduling als 27. Permutations-Achse, TABU-GO Ledger:392(c)/102) wird
durch diese Roadmap NICHT ausgeführt und NICHT verworfen — er ist unter der 07-16-Lesart neu
vorzulegen (Fork S-1 in §7). Die E13-Klärung (SYNTHESE-E11-E13, TEIL E13) bleibt die
Entscheidungsvorlage für die 3 Nicht-Scheduling-Header (Fork S-2 in §7). **Bezug Deadline:** Bis
28.07. haben I1–I7 + Mess-Nachweis Vorrang; aus dieser Roadmap sind bis dahin nur S-0, V-1/V-2 und
(nach Fork-GO) S-1/S-2 realistisch — beide golden-neutral und mess-pfad-fern.

---

## 7. OFFENE USER-FORKS (nur echte, je mit Empfehlung — NICHTS hiervon ist entschieden)

**FORK S-1 — #37-Scheduling: Organ-Achse, Systemachse oder beides?**
IST: #37-A ist als echte 27. Permutations-Achse `topics/scheduling/axis_13` mit explizitem TABU-GO
geplant (bricht golden_320/kV3AxisSchema/POD/ABI/26-Invariante; LEDGER:392(c), V5.8-Ausnahme
LEDGER:102); F4 sagt: Scheduling ist PFLICHT-SYSTEMACHSE (LEDGER:368). Der Entwurf selbst trennt
die zwei Seiten bereits („K09 C8 = Entdecken/CE-Service vs. Achse = aktives Nutzen",
`hardware_strategy.hpp:11-13` — analog für Scheduling: Host-Regie vs. Algorithmus-Scheduling).
*Optionen:* (a) NUR Systemachse (S-2), #37-A verwerfen; (b) beides — Systemachse jetzt (S-2),
#37-A-Organ-Achse später als separater TABU-GO; (c) nur #37-A. — **Empfehlung: (b)** — die
Seiten sind komplementär, nicht konkurrent; S-2 ist golden-neutral und sofort baubar, #37-A bleibt
eigener, teurer TABU-Entscheid mit Deep-Research-Auflage (LEDGER:371 E13). P/E-Core-Dispatch bleibt
dabei G-270a-gepark (LEDGER:371 GEPARKT-Liste).

**FORK S-2 — Disposition der 3 Nicht-Scheduling-vtable-Header (F4-Rückfrage).**
F4-Entscheid lautete „Option 3 (Reparatur) — ABER erst Revert `804aa3c2` untersuchen → erneute
Rückfrage" (LEDGER:370). Die Untersuchung liegt vor (B §7 + SYNTHESE-E11-E13 TEIL E13): die Header
sind ALGORITHMUS-Achsen-Entwürfe (Selbstauskunft „Algorithmus-aktive/-spezifische …", B §8), ihre
Gattungs-Substanz existiert live als CRTP (T19/T08/T06), und das „Pflicht und kaputt"-Konzept
betrifft die SYSTEM-Seite, die diese Header nie modellierten. *Optionen (E13):* (1) Header honest
deprecaten + Registry-Strings auf Live-Substanz umbiegen; (2) nur Registry-Strings; (3) Header
reparieren/verdrahten. — **Empfehlung: (1), PLUS S-2-Neubau der Systemachsen** — das versöhnt beide
Wahrheiten: die vtable-ENTWÜRFE sind Duplikate der Gattungs-Substanz (deprecaten), das
Systemachsen-KONZEPT ist Pflicht und wird NEU gebaut (nicht aus den Headern „repariert", was eine
Parallelstruktur zur Live-Substanz erzeugte — Verstoß gegen MEM
`feedback_vor_aufgaben_erst_projektstruktur_analyse`).

**FORK S-3 — Registry-Achse 14 (V1–V4) vs. „keine 4. Stufe".**
Die 4-stufige ENGINE-CHOICE-Achse (REGISTRY:267-272) kollidiert begrifflich mit dem Diktum „JE der
3 Stufen, keine 4. Stufe" (LEDGER:368), ist aber sachlich eine Betriebswahl-, keine Prüfstufen-
Dimension (§4.3). *Optionen:* (a) umbenennen/kommentieren (Betriebswahl ≠ Prüfstufe); (b) als
Legacy-Registry-Eintrag deprecaten. — **Empfehlung: (a)**, im Zuge von S-1; KEIN Bezug zum
separaten F3(i)-„4. merge-Wert"-Untersuchungsauftrag (der bleibt eigenständig offen, LEDGER:370).

**FORK S-4 — Mess-Kategorien-Erweiterung für die Pflicht-Systemachsen?**
Sollen Scheduling/Hardware/NUMA/Locking eigene MeasurementCategory-Einträge erhalten (Registry
16→N)? Das bräche `kMeasurementCategoryCount`-static_asserts + CSV-/POD-Umfeld (vgl. die
dokumentierte Ablehnung des CLU-Einbaus aus genau diesem Grund, LEDGER:296-303). — **Empfehlung:
NEIN im ersten Schritt** — S-2 baut Definitions-/Provenienz-Achsen mit honest-0-Kanälen; eine
Kategorie-Erweiterung ist ein eigener, #156-/E4′-gebundener Design-Entscheid.

**FORK S-5 — Ort und Zuschnitt der dritten Anwendung.**
*Optionen:* (a) `ce/apps/experiment_planner` (Framework-App; F1-Wortlaut „die Cache Engine stellt
als Framework eine BIBLIOTHEK bereit" spricht für Planer-Logik als ce-Lib + dünner App-Wrapper);
(b) SUPER/Code-Ebene (nahe messung_driver). — **Empfehlung: (a)** mit Lib-Kern in ce (Planer-Logik
bibliotheksfähig, App = dünner Wrapper wie alle 9 ce-Apps, `CE/apps/CMakeLists.txt:1-4`), Host-
Artefakt-Wahl (§3.3) gehört zwingend in die App-Schicht (sie startet den CEB, nicht umgekehrt).

**FORK S-6 — Werteraum + Reichweite der Compiler-Achse im ersten Ausbau.**
User-Wortlaut nennt exakt „gcc ODER clang" (LEDGER:368); Registry-15 führt zusätzlich
AppleClang/MSVC + Opt/LTO/PGO/Arch (REGISTRY:274-313); Windows ist heute MSVC-fest
(`build_orchestrator.hpp:450-461`). — **Empfehlung: strikt 2-wertig gcc|clang** im ersten Ausbau
(User-Wortlaut), Opt/LTO/PGO als spätere additive Build-Unterdimensionen NUR nach eigenem Entscheid;
Windows/clang-cl = eigener späterer Baustein (D §4 R3).

**FORK S-7 — Upgradeable-Locking-Organ (Gattungs-Lücke aus §2.2).**
Kein Systemachsen-Thema, aber in der Delta-Matrix aufgedeckt: `Upgradeable` hat kein Organ in
axis_08 (9 Organe, C §2). — **Empfehlung: als Achsen-Katalog-Kandidat in den regulären
Organ-Erweiterungs-Prozess geben** (SOTA-Vendoring-Doktrin MEM
`feedback_vendoring_doctrine_ordered_vendor_faithful_selfcontained`), NICHT in die
Systemachsen-Reparatur mischen (Trennungs-Disziplin super 19:23).

*Keine Forks (sondern Pflicht-Verifikationen, bereits in §6):* V-1 clang-rsp-Flags,
V-2 AutoPermutator-Konsumstatus.

---

## 8. QUELLENVERZEICHNIS

**Rohdaten dieses Dossiers** (`super/docs/sessions/backups/20260716-f4-systemachsen-dossier/rohdaten/`):
- `A-systemachsen-soll.md` — dokumentiertes SOLL: 18/19/20/21-Dossiers, Ledger-Anker, Wurzel-Code,
  HYBRID, Delta-Übersicht (11 Elemente), Quellen-Index.
- `B-header-seziert.md` — die 4 Entwurfs-Header vollständig (Enums/Methoden/Defaults), Registry-
  Abgleich, Git-Historie `7a6c563f`/`414ed8c2`/`804aa3c2`, Achse 15/14.
- `C-live-bestand.md` — Live-Klassifikation axis_06/07/08/12, c11_scheduler, Mess-System-Achsen,
  RC-Unter-Achsen, Compiler-IST, Delta-Kondensat.
- `D-compiler-achse.md` — CEB-Compile-Architektur, Build-Varianten-Analogie, 20 Andockpunkte,
  Risiken R1–R6.
- `E-planer-thesis.md` — CoR-Filter-Verortung, Anwendungs-Landschaft, Thesis-Soll/Konflikte.

**Primärquellen (Auswahl der tragenden Anker):**
- LEDGER `super/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`: 79 · 89 · 92 · 100 · 102 · 118 ·
  150 · 289-311 · 360 · **368** (User-Konzept wörtlich) · **370** (F1–F12, DEADLINE 28.07.) ·
  **371** (E1–E16, I1–I7-Revision) · 372/§12 (Fork A Option A) · 388 · 392 · 402 · 655 · 665 ·
  1178 · 1230 · 1268-1271.
- super `docs/architektur/`: `14_…organ_metapher.md` (494, 740-849, 1018-1208) ·
  `18_…KONSOLIDIERT.md` (15-30, 40-50, 104-105, 121-122, 149-150) · `19_…VERTRAEGE.md` (13, 21, 23,
  32, 51, 62-75, 89) · `20_…FILTERKETTE.md` (17-107, 122-141) · `21_…ENTSCHEIDUNGEN.md` (14-51,
  134-138, 228-241).
- super `docs/sessions/backups/`: `20260716-fork-a-bruecken-dossier/DOSSIER-ENTWURF.md` (I1–I7:
  80-86) · `20260716-e11-phasen-e13-kontext/SYNTHESE-E11-E13.md` (E11-Taxonomie, E13-Optionen).
- ce `docs/architecture/`: `24_messmodell_…` (§2:30-80) · `27_experiment_baum_…` (79-102, 161,
  202-225) · `34_KONSOLIDIERTER_MASTER_IST_STAND.md` (15-34, 46-48, 52-71, 73-85, 81-85, 87-106) ·
  `19_f6_prtart_migration_plan.md` (41-47, 139-143).
- ce Code — Systemachsen/Messung: `measurement/system_axis.hpp` (1-5, 20-80, 100-145, 147-190,
  192-336) · `measurement/measurement_axis_registry.hpp` (2-5, 32-49, 52-75) ·
  `measurement/i_measurement_source.hpp` (1-11, 24-85, 100, 136) · `measurement/measurement_category.hpp`
  (10-32) · `builder/curve_fit/curve_fit.hpp` (2-12, 36-62) · `tests/unit/test_m_contract_system_axis_wurzel.cpp`.
- ce Code — Entwürfe/Registry: `concepts/hardware_strategy.hpp` (2-70) · `concepts/locking_mode.hpp`
  (2-36) · `concepts/numa_affinity.hpp` (2-26) · `concepts/scheduling_strategy.hpp` (2-64) ·
  `concepts/i_sub_engine.hpp` (14-64) · REGISTRY `builder/commands/axis_library_registry.hpp`
  (13-23, 122-126, 164-168, 197-313, 321-323) · `builder/commands/auto_permutator.hpp` (26-32).
- ce Code — Gattungs-Seite: `anatomy/composition_factory.hpp` (51-70) ·
  `builder/experiment_tree/axis_path_serialization.hpp` (27-34) · `…/registry_to_axis_levels.hpp`
  (6-9, 56-58, 67-76, 90-92, 103, 124) · `…/axis_observer_classification.hpp` (9-11, 47-79) ·
  `axes/alloc/…` (Registry 78-99; aa1_to_aa7 12-90; alloc_hw_config 2-102) · `axes/prefetch_axis/…`
  (Registry 18; pf1_to_pf3 7-13; observable 119) · `axes/concurrency_axis/…` (Registry 23-30;
  blocking 17-19; observable 82-100) · `topics/hardware/axis_12_…` (Concept 21-25; subaxes 26-41;
  strategy_base 16-29; config_set 46-133) · `anatomy/resource_controllable_tier.hpp` (14-68) ·
  `anatomy/abi_adapter.hpp` (224-284) · `builder/experiment_tree/profile_to_tree.hpp` (68-95) ·
  `topics/axis_base.hpp` (58-70) · `subsystems/c11_scheduler_engine/i_scheduler_engine.hpp` (2-27) ·
  `subsystems/c02_pinning_engine/i_pinning_engine.hpp` (10-28).
- ce Code — Bau/Identität/Planung: `builder/build_orchestrator/build_orchestrator.hpp` (15, 62-65,
  86-92, 115-117, 152-179, 184-202, 265-287, 322, 405-443, 450-489) ·
  `builder/experiment_tree/experiment_tree.hpp` (2-26, 223-288, 458) · `…/coverage_selection.hpp`
  (10-30, 37-76) · `…/selection_filter_chain.hpp` (2-101) · `…/cache_engine_builder_iterator.hpp`
  (13-16, 82-94, 178-182, 267, 442, 559-660, 666, 707-734) · `…/e2e_pipeline.hpp` (4-5) ·
  `abi/anatomy_module_abi_v1.hpp` (15, 73-82) · `abi/build_variant_inspection.hpp` (2-37) ·
  `anatomy/build_variant_definition.hpp` (9-34, 60-72) · `builder/adhoc_emitter.hpp` (83-108) ·
  `anatomy/pruefling_merge.hpp` (130-134) · `profile_facade/profile_run_facade.cpp` (71-98, 102,
  105-143, 150) · `profile_facade/profile_run_entry.hpp` (74-75, 152-157, 243-244, 314-413) ·
  `profile_facade/profile_runner.hpp` (238, 268) · `profile_facade/validate_profile.hpp` (55-56,
  298, 444ff, 450-460) · `profile_facade/sota_catalog.hpp` (73, 80-85, 202, 237) ·
  `libs/common/serialization/xml_config_parser/xml_config_parser.hpp` (268-323) ·
  `builder/provenance_manifest.hpp` (58-96) · `cmake/provenance.cmake` (42-67) +
  `cmake/build_provenance.hpp.in` (8-11) · `cmake/isa_features.cmake` (126-184) ·
  `CMakePresets.json` (37-55) · `.gitlab-ci.yml` (68-80, 114-135, 188-213, 281-293) ·
  `algorithm_profiles/thesis_profiles/m3v2_study.profile.xml` (152) ·
  `tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt` (1-4) ·
  `tests/unit/thesis_tiere/test_profile_roundtrip.cpp` (5-10, 87-94) ·
  `tests/unit/thesis_tiere/test_experiment_parser.cpp` (1-16) ·
  `tests/unit/test_d15_selection_filter_chain.cpp` + `tests/unit/CMakeLists.txt` (1515, 2787-2788) ·
  `tests/unit/genus_adhoc_buildvariant.cpp` (1-7, 19-23) · `apps/*/main.cpp` (E §2.1-Tabelle).
- SUPER/Code: `02_messung_driver/main.cpp` (4-12, 233-251, 561-632) ·
  `02_messung_driver/experiment_phase_strategy.hpp` (53-57, 70-138, 147-169) ·
  `experiment_config/config_{a,b,c}_*.xml` (ls-verifiziert).
- THESIS `thesis/diplomarbeit/`: `aufgabenstellung/de.tex` (75-96, 116, 128-129) ·
  `kapitel/de/03_messsystem_prtart.tex` (76, 80, 120, 129, 155, 193-219, 382-386, 393-396, 412-415,
  427-443, 465-489, 569-582) · `kapitel/de/05_evaluation.tex` (61-74, 81-82, 94-95, 103-124) ·
  `kapitel/de/06_fazit.tex` (14, 25-34, 53-62, 95-103) · `kapitel/de/06_evaluation_methodology.tex`
  (41-48, 110-126, 154-172).
- Cluster-Infra (lokaler Klon): `/home/comdare/Projekte/Cluster/_infra/ci-templates/base-pipeline.yml`
  (832-846) · super `docs/sessions/20260706-276-VOLL-PLATTFORM-MATRIX.md` (3, 54, §1-2).
- MEM-Direktiven: `feedback_system_axes_measurement_own_abstract_root_blood` ·
  `feedback_crtp_concept_guard_mix_pattern` · `feedback_no_runtime_switch` ·
  `feedback_compile_time_only_no_runtime` · `feedback_vor_aufgaben_erst_projektstruktur_analyse` ·
  `feedback_e4_xml_autoritative_bauanleitung_ceb_orchestriert` ·
  `feedback_unified_experiment_xml_plus_system_registry_xml` ·
  `feedback_axes_optimization_semantics_deep_research_observer_strategy` ·
  `feedback_prt_art_consumes_cache_engine` · `feedback_never_delete_documentation` ·
  `feedback_messdaten_nie_loeschen_abi_darf_brechen` ·
  `feedback_ci_gruen_messfaehig_nur_punktuelle_refactorings` ·
  `feedback_e_schichten_separat_fertigstellen_top_down` ·
  `feedback_text_agent_sessions_belong_in_thesis_not_impl_repo` ·
  `feedback_vendoring_doctrine_ordered_vendor_faithful_selfcontained` ·
  `reference_tier_metaphor_system_axis_properties_verified_complete`.

*Ende Dossier 23. Erstellt 2026-07-16; read-only außer dieser Datei; TABU/golden unberührt.*

---

### → §59 KERN-Mess-Schema (2026-07-20)

> Additiver Querverweis (kein Duplikat). Die System-Achsen dieses Dossiers werden von der KERN-Mess-Schema-Steuerung getrieben (Ledger §59): der Planer parst die XML, die **Haupt-Achsen sind statisch per Metaprogrammierung in die CEB einkompiliert** (Interpreter je Haupt-Achse fix), die CEB-Laufzeit treibt den Tier-Emit. Beim Stempel kommt zu den zwei §58-Arrays der Tier-Binary (System-Array, Organ-Array) ein **dritter Tier-Binary-Stempel = die Merge-Kombination** hinzu; je **Prüfling-Merge** ein eigener id-Satz. golden ce-only `0xF1C1F26A1232073B` byte-identisch (Merges additiv). Volle Fassung: **Ledger §59**.
