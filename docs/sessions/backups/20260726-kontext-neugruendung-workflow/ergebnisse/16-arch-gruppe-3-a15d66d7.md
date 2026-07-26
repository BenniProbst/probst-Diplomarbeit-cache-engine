# ARCHITEKTUR-LEKTUERE (5 Dateien, vollstaendig gelesen)

Pfad-Kuerzel: `SUPER` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`; `ARCH` = `SUPER/docs/architektur`; `ce` = `SUPER/Code/external/comdare-cache-engine`.

====================================================================
## (a) JE DATEI: DICHTE ZUSAMMENFASSUNG
====================================================================

--------------------------------------------------------------------
### A1. ARCH/13_paper_legacy_code_architektur.md (1981 Z., V41.F.6.1, 2026-05-26, Teile A-I + Nachtrag 2026-07-15)
--------------------------------------------------------------------

**Status/Vorrang.** KEIN Superseded-Banner. Interne Konfliktregel: **Teil C > Teil B > Teil A** (13:407 "Bei Konflikten zwischen Teil A und Teil B ist Teil B verbindlich"; 13:888 "Bei Konflikten mit Teil A/B ist Teil C verbindlich"); Teile D-I additiv, jeweils "bei Konflikten verbindlich" (13:1171). Alle Teile bleiben stehen (`[[never-delete-documentation]]`, 13:407/885/1038/1169).

**Bindender Vertrag (Habich-Compliance).** 13:27-30 (woertlich Habich): "Fuer alle Paper moeglichst der Original-Code mit dem jeweils Original-Compiler kompiliert werden muss, sofern moeglich." Loesungsprinzip 13:31-34: **Architektur bleibt unveraendert, Code wird gelinkt statt kopiert.** User-Direktive 13:1257-1258: "extern ueber Wrapper den Original code mit original compiler bauen und linken und eigene Implementierung nur als fallback."

**4-Schichten-Architektur (13:38-88).** S1 C++23-Concept-System (unveraendert) -> S2 `extern "C"`-Adapter je Paper-Wrapper -> S3 kuratierter Paper-Original-Code unter `topics/<topic>/axis_<NN>/legacy_code/paper_<id>_<name>/` (Snapshot + LICENSE + compiler_info.txt + sha256_originals.txt + README.md + MODIFICATIONS.md) -> S4 `compiler_cache/` (on-demand fetch+build, `cmake/compiler_cache.cmake`, `comdare_ensure_compiler`, 13:166-223). **Pflicht:** Compiler-Cache-Aufruf VOR CacheEngineBuilder-Precompile-Run (13:221-222).

**Endstand-Typsystem (Teil B/C, verbindlich).**
- Wurzel `topics/axis_base.hpp` (13:425-447, Endstand 13:929-950): `struct AxisBase { get_compiler() = "original"; is_original_module() = false; }` + `AxisBaseConcept`. Direkt in `topics/`, NICHT in `axis_<NN>_*/`.
- CRTP-Henne-Ei: Concept-Constraint als template-clause geht NICHT (Derived incomplete) -> `static_assert` im Konstruktor (13:460-475).
- Diamond CRTP-Pfad + Mixin-Pfad, beide enden in `AxisBase`; **keine virtual base** (kein State, nur static constexpr), Mixin gewinnt per expliziter `using`-Disambiguation (13:725, 13:1372-1408).
- `LegacyOriginalCodePflicht` **reduziert auf 2 Properties** (`get_compiler`, `is_original_module`); `has_original_paper_code` ENTFERNT als Redundanz (13:920-923, 13:952-975). `HasOriginalCode<W>` = `get_compiler() != "original"/"self"/"system"`; `PaperOriginalValidated<W>` = `is_original_module()`.
- Wertebereich `get_compiler()` (13:449-459): `"original"` (Default) / `"self"` (Re-Impl) / `"system"` (libc/PMR) / konkrete Toolchain (`"gcc-9.5"`, `"clang-12"`, ...).

**Pre-Build-Tool (13:499-607).** `apps/is_original_validator/main.cpp` (~390 LoC, C++23 Standalone). **Architektur-Entscheidung (kritisch, 13:505-506): Compile-Time-Issues duerfen NICHT zu Runtime-Fallback fuehren** -> Auslagerung in Pre-Build-Tool, Output = constexpr-Bool-Header. Auto-Discovery per Regex `\b<paper_fn>\s*\([^)]*\)[^{;]*\{` + Brace-Balancer (String-Literale/Kommentare/Escapes, 13:526-533). Lock-File `sha256_locked.txt`: First-Build erzeugt Referenz-SHAs, spaetere Builds vergleichen; Mismatch -> `kIsOriginal_<fn>=false` als deklarativer Hinweis (13:540-555). Multi-File-Paper: `source_relative_path` pro Function (13:557-569). Tool generiert `PaperManifest` + `using OriginalCodeMixin = ...` -> **KEINE Macros mehr** (13:571-606).

**Manifest-Format (13:610-655).** `manifest.txt`: 3 Pflicht-Annotations `@compiler`, `@has_original_paper_code`, `@axis_mixin_type` + 3-Feld-Mappings `wrapper_fn paper_fn source_relative_path`.

**Luecken-Pattern (User-Direktive, 13:1177-1187, bindend).** "per-Function is_original markiert nur ob die Funktion original ist. Ist eine Luecke da, ist es auch false. Es ist nur true, wenn der Original code vorliegt." Zweck: die PermutationEngine kann spaeter Kombinationen abwaehlen, die Voraussetzungen nicht erfuellen. 3 Kategorien (13:1191-1195): Pure-Original / Teil-Original mit Luecken / Re-Impl ohne Paper-Binding. Mixin-Refactor `if constexpr (requires { PaperManifest::kIsOriginal_<fn>; })` in allen 6 Achs-Mixins (13:1209-1229).

**Naming-Konvention cross-axis (13:784-826, Pflicht).** `is_*`/`has_*`/`supports_*`/`requires_*` -> bool; `get_*` -> string_view; enum-class-int fuer ordinale Klassifikationen mit Implikations-Hierarchie (`ProgressGuarantee { Blocking=0, ObstructionFree=1, LockFree=2, WaitFree=3 }`, 13:808-816); snake_case Pflicht.

**CMake-Schalter (13:977-997).** `option(COMDARE_CE_ENABLE_ORIGINAL_CODE_VALIDATION ON)`. OFF-Konsequenzen dokumentiert (kein Codegen; Mixin-Header fehlt -> Wrapper-Includes muessen mit-deaktiviert werden; alle 50 Wrapper `false` via AxisBase-Default).

**IST-Stand / Luecken.**
- 49 von 50 Wrappern brauchen ZERO Code (AxisBase-Default), 13:1012-1014.
- Allocator: 6 integriert (mimalloc, jemalloc, snmalloc, dlmalloc, rpmalloc, lrmalloc), 4 deferred (tcmalloc/hoard/michael_lf/scalloc, Bazel bzw. Custom-Shims), 14 ohne ext/-Source (13:1093-1103).
- Traversal s2: 3 NEUE Wrapper `OriginalArtSearchAlgo` (4/4 original), `OriginalHotSearchAlgo` (2/4), `OriginalStartSearchAlgo` (2/4) — als NEUE Klassen NEBEN den Re-Impls, NICHT Umbau (User-Option B, 13:1338-1349).
- Queuing-Audit P2.D.q: **0 ext/-Sources** (13:1568); Pilot Q15 `OriginalLockFreeMpmcConcurrentQueue` (moodycamel, BSD-2, 2/6 original) 13:1872-1914.
- **HARTE LUECKE (13:1269-1281):** Compiler-Cache nur Skelett, NICHT aktiv; Paper-Library wird NICHT mit Original-Compiler gebaut; Wrapper linken derzeit gegen System-Build. Folge-Sprint P2.A.W + P2.D.tr.s4 (Task #689), Cross-Platform 3 OS + 4 ISAs.
- ext/-Reorganisation nach Topic (13:1667-1691) + Namenskonvention `ext/<topic>/<PREFIX><NN>-<name>/` (13:1752-1771); Pattern A ZIP-Subtree (22 Snapshots), Pattern B git submodule (1: Q01-concurrentqueue; **Ausnahme zu `[[no-git-submodules]]` fuer cache-engine**, 13:1719), Pattern C Lazy-Clone NICHT implementiert (13:1748).
- Test-Stand-Historie: 569 -> 587 -> 593 -> 654 -> 714 -> **732** (13:1926).

**Offene Punkte.** P2.F 14 Achsen-Mixin-Templates (13:848), P2.A 4 CMake-Module (~400 LoC), P2.D.tr.s3 (9 weitere Traversal-Paper), P2.D.q.s2.t2 (RocksDB/Bw-Tree/Masstree, braucht User-`git submodule add`), P2.D.t2 (#685), P2.A.W/s4 (#689) — Liste 13:1958-1968. CMake-Dependency-Edge Tool-Target -> Test-Target fehlt (13:1944-1948).

**Nachtrag 2026-07-15 (13:1976-1981).** R8: SHA256-Locking + Original-Compiler-Linking = **Provenienz-Fundament der honest-100%-Anforderung**; komplementaer, NICHT deckungsgleich zum W4-Gate (reale Katalog-DLLs statt `unordered_map`-Surrogat).

--------------------------------------------------------------------
### A2. ARCH/23_SYSTEMACHSEN_KONZEPT_WIEDERHERSTELLUNG_DOSSIER.md (796 Z., 2026-07-16, + Nachtraege 2026-07-20)
--------------------------------------------------------------------

**Auftrag/Autoritaet.** 20-Seiten-Dossier zur Wiederherstellung des Systemachsen-Konzepts nach USER-KONZEPT-KLAERUNG LEDGER:368. **Ehrlichkeits-Doktrin (23:16-19): jede tragende Aussage `datei:zeile`-belegt; Luecken werden als Luecken benannt; nichts wird als entschieden dargestellt, was ein offener User-Fork ist.**

**Die 6 bindenden User-Kernsaetze (23:29-52, woertlich):**
1. Systemachsen und Algorithmus-Gattungs-Achsen sind **getrennte Konzepte**, beide mit compile-time-Hauptachsen + dynamischen runtime-Unter-Achsen.
2. **Verortung:** Systemachsen liegen IN der CEB (dort hineinkompiliert); die anderen Achsen werden VON der CEB EINKOMPILIERT IN die Tier-Binaries. Messung der Systemachsen "nach einer Strategie".
3. **F4:** Scheduling/Hardware/NUMA/Locking sind **PFLICHT-SYSTEMACHSEN** "neben den Mess-System-Achsen"; KEINE Duplikate, sondern 3 missverstandene Stellen. "Das Konzept ist Pflicht und kaputt."
4. **F3i(1):** NEUE Compiler-SYSTEMACHSE — in der XML muss sowohl der CEB als auch JEDE Tier-Binary-Permutation mit gcc oder clang baubar sein.
5. **F3i(2)+(3):** Voll-Vergleich jeder Tier-Binary gegen ALLE anderen; "alt gegen neu" = SdT gegen Pruefling (PRT-ART); die "4. Kategorie" ist eine EIGENE Kategorie mit Unterkategorien, **JE STUFE auszufuehren — KEINE 4. Stufe**.
6. **Dritte Anwendung:** Der Experiment-Planer mit XML-Interpreter ist eine NEUE DRITTE ANWENDUNG im Framework.

Flankierend bindend (23:54-63): F1 (XML-Bibliothek fuer Experimente UND Auswertung), F3(ii) (4 CEB-Betriebsmodi als XML-Element = PFLICHT), F6 (XML steuert CI ueber INTERPRETER), F12(i) DEADLINE 28.07. (CI- UND Standalone-Messfaehigkeit), E1-E16 (u.a. E3 n_repeats>=3 Pflicht, E10 offizielle Strecke zuerst), **Fork-A Option A: "IMMER offizielle Architektur, NIE Parallelstrecke"**.

**Diagnose "kaputt" (23:64-74).** Die 4 Pflicht-Themen existieren nur als (a) toter vtable-Entwurf vom 18.05. (4 Header, Geburts-Commit `7a6c563f`, **0 Include-Konsumenten**), (b) davon abweichende, teils phantomhafte Registry-Strings, (c) Organ-/Build-Bausteine der Gattungs-Seite, (d) unimplementierte Subsystem-Skelette. Eine SYSTEMACHSEN-Auspraegung existiert **nirgends**. Deprecation-Versuch `414ed8c2` (13.07.) wurde 27 Minuten spaeter kommentarlos revertiert (`804aa3c2`).

**Gegenueberstellungs-Tabelle (23:87-95, Kern-Invariante).** Organ-Achsen: von CEB IN Tier-Binaries einkompiliert, permutierbar, `binary_id`, Wurzel `AdHocComposition`, E2/E3. Systemachsen ("Blut"): IN der CEB, **NIE in der binary_id (TABU)**, nicht austauschbar, immer praesent sobald Messung an, Wurzel CRTP `SystemAxis<Derived>` + `SystemAxisConcept` (`system_axis.hpp:147-190`), E0-Querschnitt.

**SOLL-Familie: 3 Gruppen, EINE Wurzel (23:124-149).** (1) Mess-System-Achsen GEBAUT, konsumentenlos-gated (16 Kategorien, Regime TimeObserver(9)/PmcCounter(7), 3 Strategien WallClock/ObserverSnapshot/Pmc, #156-DATA-gated). (2) Pflicht-Systemachsen TODO: Scheduling, Hardware, NUMA, Locking. (3) Compiler-Systemachse TODO. HYBRID-Heuristik-Systemachse: eigene Systemachse, #156-gated, Deep-Research-Pflicht VOR Bau, NICHT Teil dieser Reparatur.

**Begriffs-Disambiguierung (23:193-206, Pflichtteil).** Kritische Trennungen: `AxisBase::get_compiler()` = **Paper-Provenance-Metadatum je Organ (Habich-Compliance), NICHT Build-Compiler-Steuerung**; Registry-Achse 15 Compiler = Tier-Permutationsachse, NICHT die Compiler-Systemachse; `c11_scheduler` = datenstruktur-internes Page-Type-/Deferral-Scheduling, **inhaltlich KEINE Deckung mit OS-Thread-Scheduling**; "Blut" (Mess-Ebene, seit 09.07.) loest das ALT-Bild "Blutkreislauf (allocator)" der Saeugetier-Anatomie ab; Systemachsen sind **KEINE Phase** in irgendeinem der 5 ueberladenen Phasen-Vokabulare, sondern E0-Querschnitt (23:216-225).

**Delta-Matrix (23:229-337).** Verdikt-Vokabular: live-gedeckt / TODO-Systemachse / TODO-runtime-Unterachse / obsolet (vtable-Form doktrinwidrig) / Registry-Reparatur. Fazit 23:329-337: Gattungs-Substanz ist ueberall live wo der Entwurf Algorithmus-Verhalten meinte; die SYSTEM-Seite existiert fuer ALLE VIER nicht.

**Registry-Wahrheits-Matrix (23:293-318, harte Befunde).** 6.3 `NumaAffinity` = **PHANTOM-SYMBOL** (Enum existiert nicht); 8.2 = **PHANTOM 4/4**; 12.4/12.5/13.3 DIVERGENZ; **13.4 ID-KOLLISION** (Registry "Memory-Interleave" vs. Header "Co-Routine-Strategy"); 13.1 UNVOLLSTAENDIG (FreePool fehlt); 12.1/12.2/12.3/13.5 MATCH. Registry wurde 3 Tage NACH den Headern gebaut und nie gegen sie geschrieben.

**Compiler-Systemachsen-Design (23:341-445).**
- Kandidat 1 binary_id-Segment: **HART ABGELEHNT** — `StaticBinaryView::operator[]` emittiert JEDE statische Ebene auch gepinnt -> bricht alle 320 golden ids + `test_profile_roundtrip` + CI-Gate `contract:profile_coverage`; Verstoss gegen Tag-Doktrin "Lauf-Konfiguration reist NICHT in der binary_id".
- Kandidat 2 `.version`-Sidecar: notwendig, aber unzureichend.
- **Kandidat 3 EMPFOHLEN: Compiler als 4. BUILD-ACHSE** analog page_type/09b/12 (kein 20. Slot, keine eigene Gattung). Bausteine 23:379-388: Toolchain-Pass je Wert; Artefakt-Koexistenz `dll_dir/<toolchain>/<stem>/perm.dll`; compiler-augmentierte `build_version`; **PFLICHT-Stamp-Bump resume-v5->v6 mit `|cxx=<id>`** (jeder neue Freiheitsgrad MUSS in den Stamp, sonst stale-Resume); additives `comdare_toolchain_inspect`-Symbol (Deklarations-Wahrheit); CSV-Tag-Spalte `toolchain`; `<toolchains>`-XML-Block; **Gating additiv, Default-OFF**.
- Golden-320-Neutralitaet (23:390-393): Default = genau 1 Toolchain -> byte-identische ids/Stems/Pfade/Sidecars.
- Host-Haelfte 23:402-419: `HostToolchainSystemAxis` als reine Definitions-/Provenienz-Achse ("Definition statt Observer"); Wahl vollzieht der Planer, nicht der laufende CEB (der muesste sich selbst neu bauen).
- **V-1 PFLICHT VOR BAU (23:436-439):** `-fno-gnu-unique` und die festen rsp-Flags gegen das konkrete clang-Release verifizieren; gruener clang-CI-Build belegt nur den HOST-Pfad, NICHT den rsp-DLL-Pfad.

**Voll-Vergleich je Stufe (23:449-523).** 3 Stufen kanonisch code-verankert: `Stufe1_CeOnly / Stufe2_PrueflingReplace / Stufe3_FullJoin`. SdT-vs-Pruefling = **MergeStrategy-Diskriminator INNERHALB der Stufe**. Compiler/ISA/OS = **GRUPPIERUNGS-Schluessel der Auswertung (CSV-Tags + Manifest), NIE Teil der binary_id**. Statistik: Welch + Holm-FWER (`f15_compare`), E3 n_repeats>=3 Pflicht, Brueckenincrement I6 als Bauplatz — KEINE neue Statistik-Maschinerie. **Thesis-Konflikt ehrlich benannt (23:500-508):** Thesis definiert Reihe C heute als build-/versions-uebergreifende Regression derselben Konfiguration, NICHT deckungsgleich mit der User-Semantik; ausserdem ist Fairness heute an "identische Compiler- und Flag-Basis" gebunden -> wird zu "Fairness = Vergleiche INNERHALB einer Compiler-Belegung".

**Dritte Anwendung (23:527-596).** Heute 2 tragende Anwendungen (`messung_driver` = WAS, `CacheEngineBuilder` = WIE, als App nur duenner Demo-Wrapper). Planer = das PLANEN/"WANN-WAS-WOMIT". **KERNBEFUND 23:563-571:** die CoR-Filterkette `selection_filter_chain.hpp` existiert, ist aber **UNVERDRAHTET** — einziger Konsument `test_d15`; der offizielle E4-Pfad selektiert per `select_explicit` OHNE Filterglied vor `provision_all`. Andockpunkt = `run_lazy_static_then_dynamic(tree, sel, a.compile, ...)`. **Doppelbau-Verbot (23:584-590):** die dritte Anwendung MUSS den EINEN offiziellen Pfad konsumieren; sie ersetzt weder messung_driver noch CEB.

**Reparatur-Roadmap (23:600-628).** S-0 Doku / V-2 VERIFY AutoPermutator-Konsum / S-1 Registry-Wahrheit (nach User-Entscheid Fork S-2) / **S-2 Pflicht-Systemachsen-Familie (Kern)** / S-3 Haupt-/Unter-Struktur / S-4 Compiler-Tier / S-5 Compiler-Host / S-6 Planer / S-7 Voll-Vergleich / S-8 Thesis. Rahmenbedingung: bis 28.07. haben I1-I7 + Mess-Nachweis Vorrang; realistisch nur S-0, V-1/V-2 und nach Fork-GO S-1/S-2.

**7 OFFENE USER-FORKS (23:632-695, NICHTS entschieden).** S-1 #37-Scheduling Organ vs. System (Empfehlung b: beides); S-2 Disposition der 3 vtable-Header (Empfehlung 1: deprecaten + Systemachsen NEU bauen, nicht "reparieren"); S-3 Registry-Achse 14 V1-V4 vs. "keine 4. Stufe" (Empfehlung a: umbenennen); S-4 Mess-Kategorien-Erweiterung (Empfehlung NEIN — braeche `kMeasurementCategoryCount`-static_asserts); S-5 Ort der 3. Anwendung (Empfehlung a: ce-Lib + duenner Wrapper); S-6 Compiler-Werteraum (Empfehlung: strikt 2-wertig gcc|clang); S-7 Upgradeable-Locking-Organ (nicht in die Systemachsen-Reparatur mischen).

**Nachtraege 2026-07-20 (additiv).** §47/§54-T2 (23:114-122, 23:208-214): **Mess-HAUPT-Achse ist das MESS-TOOLING {nur Wallclock, Makro-Benchmarks, Micro-Benchmarks ueber die Observer}** — statisch/CT, je Tooling-Wahl eine eigene hart kompilierte CEB (`ceb:build:[a,b,c]`); die 16 measurement_categories sind **UNTER-Achse** (CSV-Spalten). §54-T1: kanonisch heisst der Achsen-TYP **"Organ-Achse"**; "Gattung" ist reserviert fuer das Tier-Binary-INTERFACE (Search/Container/Graph), **NIE eine Achse**. §59 (23:793-795): dritter Tier-Binary-Stempel = Merge-Kombination; je Pruefling-Merge eigener id-Satz; golden ce-only `0xF1C1F26A1232073B` byte-identisch.

--------------------------------------------------------------------
### A3. ARCH/20260717-achsen-nachschlagewerk-ACHSEN-NACHSCHLAGEWERK.md (341 Z., Stand nach INC-2c)
--------------------------------------------------------------------

Das aktuellste und operativ verbindlichste der fuenf Dokumente. Synthese aus 172 kartierten Achsen-Eintraegen ueber 5 orthogonale Dimensionen.

**INC-2c-Delta (NW:7).** Telemetrie aus der binary_id herausgeloest -> **Organ-Achsen 19 -> 18**; ABI-Major 4 -> 5 (ce `86769bc9`); Observer-POD-Version 5 -> 6; `sizeof` 1416 -> 1344 (-72); **golden-Roundtrip == 320 intakt** (telemetry war single-enabled). Das Telemetrie-Organ lebt als Mess-Infrastruktur weiter, permutiert aber nicht mehr.

**Lesehinweise = harte Semantik (NW:10-13).** Ausprägungs-Zahlen = `AllStrategies`-Registry-Inventar (Design-Space-Kardinalitaet), NICHT die `Enabled`-Teilmenge; wo golden pinnt = `mp_take_c<Enabled,1>`. **binary_id-Disziplin: NUR die 18 Organ-Achsen permutieren die binary_id; alle System-/Compile-/Shape-Achsen sind binary_id-orthogonal, Provenienz gehoert ins H-10-Sidecar (`system_axes_version_suffix` in `build_version`), NIE in die binary_id.** honest-0: nicht real gemessene Kategorien liefern ehrliche 0.

**Kanonische Zaehlung (NW:17-27).** System-Konfig (CEB) **6** Haupt + 3 Wurzeln; Organ **18** (T0..T17); Gattung Ebene-1 **3**; Genus Ebene-2 **5**; Mess-Dimensionen **3**; Mess-Kategorien **16**; System-Mess-Kollektoren **3**; Build/Shape **7**.

**Die 6 System-Achsen (NW:36-46).** Scheduling (#37, gebaut Header, Wiring geplant) / Hardware-ISA (Host-Deskriptor + Mess-Gate, **treibt nichts**) / Telemetrie (INC-2c herausgeloest, Active|Silent) / Last-Frameworks H-9 (Ycsb) / **Compiler (gebaut + verdrahtet, +cxx=, Gcc g++-16 | Clang clang++-22)** / **Erweiterungshardware (gebaut + verdrahtet, +ext=, Generic|Avx2|Avx512)**. Wurzeln: `Axis<Derived>` (Dach, AxisKind-Diskriminator, empty base, kein vtable), `CebSystemAxis<Derived>` (Konfig-Root), `SystemAxis<Derived>` (Mess-Blut-Root). **e18-Rollentrennung (NW:280): Erweiterungshardware ist die EINZIGE Bau-Treiberin (-march-Flag-QUELLE an `make_gpp_compile_fn`); Hardware/ISA ist reiner Host-Deskriptor.** Hartes Bau-Gate: `supports_fno_gnu_unique` gcc=true / clang=false (NW:74).

**Die 18 Organ-Achsen T0..T17 (NW:91-110).** Autoritative Reihenfolge = `kCompositionAxisNames` `std::array<...,18>` (`axis_path_serialization.hpp:31-34`), `static_assert sizeof...==18` in `composition_factory.hpp:55-94`, Observer-Schema `kV3AxisSchema[18]`. Reihenfolge: T0 search_algo(22) / T1 cache_traversal(3) / T2 mapping(2) / T3 path_compression(3) / T4 node_type(4) / T5 memory_layout(5) / T6 allocator(26) / T7 prefetch(4) / T8 concurrency(9) / T9 serialization(4) / T10 value_handle(5) / T11 isa(4) / T12 index_organization(4) / T13 io_dispatch(4) / T14 migration_policy(4) / T15 filter(4) / T16 queuing_q1(15) / T17 queuing_q2(5). Varianten-Summe 127; Voll-Permutation `all_axes_binary_count() == 137.594.142.720.000`.

**Gattung/Genus (NW:130-152).** 3-Ebenen-Modell `anatomy_base.hpp:30-109`. Ebene-1 AnatomyGattung = Aussen-Interface/Pruef-Dock = 3 (SearchAlgorithm | Container | Graph). Ebene-2 AnatomyGenus = 5 (SearchAlgorithm=18 slots | Set=14 | Sequence=10 | Adapter=12 | View=6). **Cross-Genus type-unmoeglich.** Warnung NW:142: **stale `k*SlotCount`-Konstanten (set=15/seq=11/view=7/adapter=13, alle +1 telemetry) — belastbar ist NUR struct-internes `slot_count` + `axis_names().size()`.**

**golden-320 (NW:265-273, autoritativ `source_catalog.hpp:83-113`).** `FullSourceCatalog = CatalogAxes<4,4,5,4> = 320`. **NUR 4 Achsen FREI:** search_algo x4, node_type x4, memory_layout x5, prefetch x4. Die uebrigen 14 Slots je `mp_take_c<...,1>` GEPINNT (Liste NW:273). Verifiziert gegen `golden_fullpilot_320_binary_ids.txt`. `SmallSourceCatalog = CatalogAxes<1,2,2,1> = 4`.

**Compiler-Achse-Ruling (NW:259, User 2026-07-17, hart).** "Opt-Level (O0..Ofast) + Flags + Commands + march sind **Unterachsen UNTER** der Compiler-Haupt-Achse — KEINE dedizierten Geschwister. **In einem dynamischen XML-System existiert 'global' NICHT.**" Der INC-2c.opt-Bauplan §2/F1/F3 (`OptimizationLevelSystemAxis`-Geschwister) ist per KORREKTUR-KOPF **verworfen**.

**Orthogonalitaets-Invarianten (NW:277-291).** System-Achsen ⊥ Organ-Achsen (keine der 6 steht je in `kCompositionAxisNames`/`serialize_composition_path`/`P::variants`; golden bleibt 320). **BUILD ⊥ LASTENPROFIL = die ZWEI Haupt-Experiment-Achsen; COMPILE-RELEASE ist AUSDRUECKLICH KEINE 3. Experiment-Achse (nur Build-Schalter).** IST-Wiring: nur Erweiterungshardware (+ext=) und Compiler (+cxx=) sind variabel im `build_version` verdrahtet.

**gated / TABU (NW:293-295).** gated: PMC honest-0 bis #26; golden-320-Voll-Messlauf #156 (mehrtaegig); D-Loader-Mess-Konsum; Vollworkload. **TABU/eingefroren: `golden_fullpilot_320`, `CatalogAxes<4,4,5,4>`, `kV3AxisSchema`, `kCompositionAxisNames`, Registry-`mp_list`, POD-sizeof.** mapping-Erweiterung (MP03/MP04), node-shape-Aktivierung, per-K-Enable nur unter explizitem User-GO im koordinierten Bau-INC-2. `permutation_axes.xml` = read-only.

**OFFENE AUDIT-AUFLAGE (NW:297, nicht-blockierend, VOR Messlauf zwingend).** `build_system_axis_levels()` (`registry_to_axis_levels.hpp:112`) hat **repo-weit KEINEN Aufrufer** -> telemetry-Wahl (Active/Silent) landet in KEINEM Sidecar; page_type und simd_extension ebenso betroffen. Provenienz laeuft real nur ueber `system_axes_version_suffix` (`profile_run_facade.cpp:172`).

**Zaehl-Fallen A-L (NW:301-341), die wichtigsten:**
- (A) 9 konkurrierende Zaehlungen sauber getrennt; **16 (Mess-KATEGORIEN) vs 18 (Observer-ACHSEN) vs 8 (Feld-SLOTS) NIE verwechseln.**
- (B) **19 -> 18 = haeufigste Stale-Falle.** Belege sagen noch "19": `ceb_system_axis.hpp:7-8`, LEDGER 1668/1679, `genus_binding_traits.hpp:42/12`, `anatomy_base.hpp:169`. **Immer Registry-XML als Ist nehmen; Code-Kommentare/Ledger als stale.** Slot-Verschiebung: value_handle Alt-T11 -> T10, isa Alt-T12 -> T11, ..., queuing_q2 Alt-T18 -> T17.
- (D) **Drei inkompatible ID-Systeme** fuer "dieselben" Achsen (string-IDs T00-T17 / numerisch 1-14 + 15.1-15.5 / Legacy-GROSS-Aliasse), NICHT austauschbar.
- (E) 5%-Doppeldeutigkeit: Compiler-5% (gcc vs clang) vs memory_layout-5% (Stride 48 vs 64, nur -O3).
- (G) `ComdareMeasurementSnapshotV1` heisst "16+6", volle CSV schreibt **24 Spalten**.
- (H) page_type liegt in `build_system_axis_levels()`, ist aber **KEINE der 6** benannten System-Achsen.
- (I) **Kardinalitaets-Formel-Inkonsistenz:** `all_axes_binary_count()` multipliziert weiterhin `enabled_count<axes26::T10_telemetry>` mit, obwohl telemetry System-Achse wurde.
- (J) `queuing` != Gattung: q1/q2 sind 2 gleichrangige Komposition-Slots (Kategorienfehler-Korrektur 2026-06-03).
- (K) Richtwert "~279 Sub-Achsen" **nicht belegt**.
- (L) Deprecated steht DANEBEN, ersetzt nicht (`ISchedulingStrategy`-vtable + 3 Schwestern, gesamter `messreihe_v32`-Pfad, Telemetrie-Organ).

--------------------------------------------------------------------
### A4. ARCH/02_aktueller_master_REV7_7.md (378 Z., Stand 2026-05-15 / V31)
--------------------------------------------------------------------

**STATUS: SUPERSEDED (02:3-6).** "Dieser REV7.7/V31-Master ist vom Code ueberholt (axis-zentrische Restruktur F.2, Plugin-Pruefling-Modell, DLL-F15-Pipeline, sezierte Organe). IST-treue Single-Source-of-Truth: `ce/docs/ledger-sections/architektur-ziele-offene-punkte-ledger.md` + `.../20260531-e2e-abnahme-audit-und-entscheidungen.md`. **Niemals loeschen — nur Banner (Direktive).**" Interne Konfliktregel 02:13: REV7.7 > REV7.6 > REV7 > REV6 > REV5 > REV4 > REV3.

**Was daraus noch traegt (historisch/konzeptionell):**
- **Drei-Saeulen-Architektur (02:17-42), als "REV3 -> REV7.7 unveraendert" markiert.** E1 `IExecutingEngine` (ISearchEngine | IFutureEngine) -> E2 Suchalgorithmus-Datenstruktur -> E3 CacheEngine + Plattform-Modell. Trennungs-Prinzip: E2 weiss nichts direkt von CPU/Caches, konsumiert nur `ICacheStrategy`; E3 plattform-agnostisch im Code, plattform-konkret im Verhalten via Auto-Discovery.
- **Wichtiger Verweis (02:48, Phase M 2026-05-18):** Die Drei-Repo-Aufteilung ist **orthogonal** zur 4-Subsystem-Trennung (messung_driver -> CacheEngineBuilder -> CacheEngine <-> Pruefling). **CEB und CE wohnen im selben Repo, sind aber 2 unabhaengige Subsysteme.** Details `10_schichten_modell_M.md`.
- **Drei-Pflicht-Messreihen A/B/C (02:57-63):** `config_a_prt_art_vs_sota.xml`, `config_b_cache_engine_perms.xml`, `config_c_merge_alt_neu.xml`. Diese 3 XMLs sind in Dossier 23 §4.3 als weiterhin real vorliegend bestaetigt.
- **Zwei parallele Bausteine-Stacks (02:69-83):** Such-Algorithmus-Stack (33 Paper, 11 Achsen 1-11) und Allokations-Stack (21/23 Paper, 7 Achsen AA1-AA7, 5 Cluster AC1-AC5), beide vom CEB per Permutation kombiniert. Allokator-Anforderungen A1-A8 (02:87-99): Typsicherheit ueber `std::allocator<T>`, PMR-Konformanz, Default 1-Writer/N-Reader via `shared_mutex`, Container-Tests mit vector/map/unordered_map/deque/list/set, **Cache-Page-Awareness**, 9-Plattform-Verifikation, Permutierbarkeit.
- **PRT-ART als Pruefling (02:148-164):** EINE konkrete Algorithmus-Variante im Permutations-Framework. REV6-Korrektur: im PRT-ART-Code selbst nur **2 Node-Typen** (Redirect + B+), im Framework aber 6 Pflicht-Seitentypen permutierbar. 4 Suchtypen (Exact/Prefix/Range/Hash-Anchor), 4+2 Allokator-Pools.
- **CEB als eigenstaendiges Programm (02:167-184):** 7-Phasen-Pipeline enumerate/codegen/compile/load/run/measure/export. 22 Builder-Subkomponenten aufgelistet.
- **NOTICE Architekt-Direktive II (02:188-199, User 2026-05-14, bindend):** "Da wir alle Algorithmus-Bestandteile zerschneiden, entsteht fuer alle Permutations-Achsen ein neues Werk. Das gilt fuer alle Lizenztypen. Repos ohne Lizenztypen haben nur ein formales copyright, also muss nur der Autor beim zitieren genannt werden." -> GPL-3 (P04, P07), LGPL (P29), no-LICENSE (P06, P25, P30, A03) **alle freigegeben**.
- **libs/-Migration (02:255-276), User-Direktive Option C+:** ohne `domain/`-Zwischenebene, flach `libs/<modul>/`; Top-Level 8 -> 5 (libs/, apps/, adapters/, ext/, tools/).
- **P27 hp-soft (02:237-251):** Mail-Antwort Grot/Zhang; C++23-Port in `tools/p27_bundle_finder/`; **User-Hinweis "Mehr kommt nicht" — keine Folge-Mails an Zhang/Grot.**
- 22 V31-Adapter (12 SOTA + 10 Allokator), Adapter-Pattern-Skizze mit `COMDARE_HAVE_<X>`-Gate (02:203-233).
- Permutationsraum V31: 30 SOTA x 10 Allokator x 6 Workloads = **1800 deklarierte Permutationen** (02:298).
- Offene Punkte V31 (02:349-358): V21.2 HW-E2E Mess-Reihe (User-Aktion), #74 Email-Antworten P06/P28/P31/P32/P33, #95 Kuehn-Code-Download P28.

--------------------------------------------------------------------
### A5. ARCH/07_cross_reference.md (132 Z., Stand 2026-05-15, K-C.8)
--------------------------------------------------------------------

**STATUS: SUPERSEDED (07:3)** — identischer Banner wie 02. "Niemals loeschen — nur Banner."

Reine Mapping-Tabelle (Habich-Anforderung H1: Cross-References Klassen-Diagramme <-> ER-Modell). Vier Mappings:

1. **§1 (07:13-25): 11 Bausteine-Achsen <-> UML-Concept <-> ER-Feld `PermutationFlags.bank_*` <-> Glossar-v7-Block.** Achsen: 1 PAGE-TYPE, 2 NODE-TYPE, 3 TRAVERSAL, 4 VALUEHANDLE, 5 MEMORY-LAYOUT, 6 ALLOCATOR, 7 PREFETCH, 8 CONCURRENCY (Discipline + Mechanic), 9 ISA (Compiler-Flags + `target_clones`), 10 MEASUREMENT (`Measure<Category,Detail>` constexpr), 11 TELEMETRY-COLLECTION-STRATEGY (NEU 2026-05-09 Kuehn).
2. **§2 (07:31-56): 23 ADRs F1-F15 + F-EXTRA-1..8.** Relevant: F4 Permutationsraum + ISA-Filter; **F7 Adapter-Pattern fuer Originalcode (HABICH-DIREKTIVE)**; F9 ABI-stabiles C++23-Modul + ModuleLoader; F10-K Flag-System statt perm_id (CPUID-Vorbild, 9 Banken); F13 Cross-Compilation (ZIH Runtime, sonst Compile-Time); **F15 Bausteine-Quer-Permutation = zentrales Forschungs-Prinzip**; F-EXTRA-1 Original-Compiler pro Algorithmus (Layering); **F-EXTRA-5 KEIN Python in Build (CMake/sh/bat)**; F-EXTRA-6 DecisionLambdaTrees PRO Baustein; F-EXTRA-7 Default-Mess-Hooks + Algo-Override; F-EXTRA-8 ABI-Stabilitaets-Test + GTests.
3. **§3 (07:61-95): 33 Paper P01-P33 <-> Achsen <-> V31-Adapter-Status.** 12 mit echtem Adapter (mit Lizenz-Annotation), Rest `LEGACY_REIMPL` oder Survey. **Dies ist die einzige der 5 Dateien mit der vollstaendigen Paper-ID -> Achsen-Zuordnung** und damit trotz Superseded-Banner ein nuetzlicher Index fuer Doc 13 (ext/traversal/P0X).
4. **§4/§5 (07:99-120):** 23 Allokator-Paper A01-A23 (10 Adapter); V31-Sprints V12-V31.K <-> Doku-Update-Matrix.

Offene Punkte: keine eigenen; verweist auf `../forschungslandkarte/01_quellen_gesamtkatalog.md` (K-F.2, "in Arbeit").

====================================================================
## (b) QUERSCHNITT: HARTE DIREKTIVEN UND VERBOTE
====================================================================

**B1. Dokumentation und Vorrang**
- Doku NIE loeschen, nur Banner/deprecaten (02:6, 07:3, 13:407/885/1038/1169/1510/1653/1865). **Scope-Einschraenkung (13:1325):** gilt nur fuer `docs/`, NICHT fuer redundante Source-Klone.
- Konfliktregeln: Doc 13 Teil C > B > A, spaetere Teile bindend; Doc 02 REV7.7 > REV7.6 > REV7 > REV6 > REV5 > REV4 > REV3 (02:13).
- **Superseded-Vorrang:** Doc 02 + Doc 07 sind IST-untauglich; IST-Quelle ist der ce-Ledger + E2E-Abnahme-Audit. Doc 23 ist Stand 16.07. mit 07-20-Nachtraegen; **Doc 20260717-Nachschlagewerk (INC-2c) ist der aktuellste Achsen-Ist**.
- Ehrlichkeits-Doktrin (23:16-19): jede tragende Aussage `datei:zeile`-belegt; Luecken als Luecken benennen; nichts als entschieden darstellen, was ein offener Fork ist.

**B2. binary_id / golden / TABU (haerteste Klasse)**
- **NUR die 18 Organ-Achsen permutieren die binary_id** (NW:12). Alle System-/Compile-/Shape-Achsen binary_id-orthogonal.
- **Systemachsen NIE in der binary_id** (23:92 TABU; NW:278).
- **"Lauf-Konfiguration reist NICHT in der binary_id"** (Tag-Doktrin, 23:367).
- Compiler/ISA/OS = Gruppierungs-Schluessel der Auswertung (CSV-Tags + Manifest), NIE binary_id (23:520-521).
- binary_id-Segment fuer Compiler: **HART ABGELEHNT** (23:362-368) — `StaticBinaryView::operator[]` emittiert jede statische Ebene auch gepinnt.
- TABU/eingefroren (NW:295): `golden_fullpilot_320`, `CatalogAxes<4,4,5,4>`, `kV3AxisSchema`, `kCompositionAxisNames`, Registry-`mp_list`, POD-sizeof. Aenderung nur unter explizitem User-GO im koordinierten Bau-INC-2.
- `permutation_axes.xml` = read-only/TABU (NW:239/295).
- Provenienz von System-Achsen gehoert ins H-10-Sidecar `system_axes_version_suffix`, nicht in die binary_id (NW:12).
- Jeder neue Lauf-Freiheitsgrad MUSS in den Resume-Stamp (v5 -> v6 mit `|cxx=`), sonst stale-Resume (23:384).

**B3. Compile-Time-Doktrin**
- **Compile-Time-Issues duerfen NICHT zu Runtime-Fallback fuehren** -> Pre-Build-Tool (13:505-506).
- KEIN Runtime-Switch, compile-time-Hauptachse strikt; dynamisches Laden nur cold-start ueber die DLL-Naht (23:354-356).
- vtable-Form ist doktrinwidrig -> CRTP + Concept (23:240, 23:290); `ISchedulingStrategy` und Schwestern deprecated, 0 Konsumenten (NW:65, NW:341).
- `Axis<Derived>` = empty base, kein vtable (NW:38).
- Haupt-Achse = compile-time, Unter-Achse = dynamisch/runtime, aber **eine Unter-Achse ist eine VOLL-Achse**, kein "Skalar zweiter Klasse" (23:98-102, 23:202).
- Mess-Registry ist constexpr, **KEIN Runtime-Switch** (NW:226).

**B4. Keine Parallelstrukturen / kein Doppelbau**
- Fork-A Option A: **"IMMER offizielle Architektur, NIE Parallelstrecke"** (23:62).
- Doppelbau-Verbot: die dritte Anwendung MUSS den EINEN offiziellen Pfad konsumieren (23:584-590).
- **Duplikat-Verbot:** bei Andockung an Bestehendes referenzieren, nicht duplizieren (`thread_count`-RC-Kanal, `hw_prefetcher`-Ebene, axis_08/axis_12 unangetastet) — 23:234, 23:286, 23:615.
- Reparatur der Systemachsen = NEUBAU an der bestehenden Wurzel, NICHT "Reparatur" der toten Header (das erzeugte eine Parallelstruktur), 23:653-657.
- Cross-Axis-Defaults gehoeren in `topics/axis_base.hpp`, NICHT in CRTP-Bases oder Wrapper (13:1027).
- Redundante Properties verboten: 1 Property + Computed-Derivative (13:910, 13:1021-1022).
- Kein Test-Bloat: TYPED_TEST_SUITE-Skalierung ueber Type-Listen (13:1068-1090, 13:1441-1445).

**B5. Achsen-Taxonomie (harte Rulings)**
- **Compiler-Achse ⊃ Unterachsen** (User-Ruling 17.07., NW:259): Opt-Level, Flags, Commands, march sind Unterachsen UNTER der Compiler-Hauptachse, KEINE Geschwister. **"In einem dynamischen XML-System existiert 'global' NICHT."** INC-2c.opt-Bauplan §2/F1/F3 verworfen.
- **Q2 Option C:** Erweiterungshardware = 6. System-Achse und **einzige Bau-Treiberin**; Hardware/ISA = reiner Host-Deskriptor (NW:32, NW:280).
- **Mess-HAUPT-Achse = Mess-Tooling {Wallclock | Makro | Micro}**, je Wahl eine eigene hart kompilierte CEB-Strecke `ceb:build:[a,b,c]`; die 16 Kategorien sind UNTER-Achse/CSV-Projektion (§47/§54-T2, NW:172, 23:114-122).
- **§54-T1:** kanonischer Typname ist **"Organ-Achse"**; "Gattung" ist reserviert fuer das Tier-Binary-INTERFACE (Search/Container/Graph), NIE eine Achse (23:211-213).
- **BUILD ⊥ LASTENPROFIL** = die 2 Haupt-Experiment-Achsen; **COMPILE-RELEASE ist AUSDRUECKLICH KEINE 3. Experiment-Achse** (NW:279).
- `queuing` ist keine Gattung: q1/q2 = 2 regulaere Komposition-Slots (NW:338).
- Systemachsen sind **KEINE Phase** in irgendeinem der 5 Phasen-Vokabulare, sondern E0-Querschnitt (23:218-220).
- Die 4 CEB-Betriebsmodi sind eine LEBENSZYKLUS-Dimension, KEINE Systemachsen (23:223-225).
- Genus-Slot-Zahlen: belastbar NUR `slot_count` + `axis_names().size()`, nicht die stale `k*SlotCount` (NW:142).
- Immer Registry-XML als Ist nehmen; Code-Kommentare/Ledger als stale (NW:319).

**B6. Stufen und Vergleich**
- **3 Stufen kanonisch: Stufe1_CeOnly / Stufe2_PrueflingReplace / Stufe3_FullJoin. KEINE 4. Stufe** (23:47, 23:488-498).
- "alt gegen neu" = SdT vs. Pruefling (PRT-ART), eigene Kategorie mit Unterkategorien, JE STUFE (23:44-48).
- SdT-vs-Pruefling ist der MergeStrategy-Diskriminator INNERHALB der Stufe (23:517).
- Rollen-Doktrin: PRT_ART = Pruefling, CacheEngine = Werkzeug (23:499).
- Registry-Achse 14 (V1-V4) ist Betriebswahl, KEINE Pruefstufe (23:509-511, offener Fork S-3).

**B7. Messung / Ehrlichkeit**
- **honest-0 vor Phantomwert** (NW:13, NW:192-193, 23:523).
- **n_repeats >= 3 Pflicht**, Welch rechnet auf der WIDE-CSV ueber die Wiederholungen (E3, 23:480-482).
- Zwei-Phasen-Op-Schleife + Konformitaets-Gate (23:522).
- Messdaten additiv, nie loeschen (23:620).
- Mess-Gates: PMC honest-0 bis #26; golden-320-Voll-Messlauf #156; Vollworkload gated (NW:294).
- SHA256-Locking + Original-Compiler-Linking = Provenienz-Fundament der honest-100%-Anforderung; "Schummeln" per SHA-Tracking ausgeschlossen (13:24, 13:1980).
- Per-Function `is_original` nur true wenn Original-Code vorliegt; **Luecke = false** (13:1179-1180).

**B8. Build / Toolchain**
- **KEIN Python im Build** (07:52 F-EXTRA-5; CMake/sh/bat).
- Compiler-Cache-Aufruf PFLICHT vor CEB-Precompile-Run (13:221).
- Adapter-Pattern fuer Originalcode = HABICH-DIREKTIVE (07:39 F7).
- Original-Code **linken, nicht kopieren**; eigene Impl nur als Fallback (13:34, 13:1258).
- Optionale Feature-Schichten brauchen CMake-`option()` mit Default ON und dokumentiertem OFF-Pfad (13:1028).
- Neue Features additiv + Default-OFF gaten (23:388, 23:617).
- Pro Source-Pfad ein eigener Build-Pfad; niemals `cmake-build-release/` zwischen Source-Baeumen mixen (13:1320-1321).
- ABI-Grenze bewusst `extern "C"` + uint64-PODs -> traegt Cross-Compiler-Laden, trotzdem explizites Smoke-Gate gcc-Host x clang-DLL (23:440-443).
- Namens-Konvention `ext/<topic>/<PREFIX><NN>-<name>/` verbindlich seit P2.D.q.s2 (13:1752-1763).
- git-submodule-Verbot: Ausnahme fuer cache-engine `ext/` (13:1719).
- Windows/MSVC: `make_system_compile_fn` ist MSVC-fest; gcc|clang-Achse dort heute nicht abbildbar; clang-cl = eigener spaeterer Baustein (23:430-432, 23:685).

**B9. Pflicht-Verifikationen vor Bau**
- **V-1:** rsp-Flags von `make_gpp_compile_fn`, insbesondere `-fno-gnu-unique`, gegen das konkrete clang-Release verifizieren; gruener clang-CI-Build belegt nur den HOST-Pfad (23:436-439).
- **V-2:** Konsumstatus von `AxisLibraryRegistry::lookup` im offiziellen E4-Pfad belegen, BEVOR Registry-Reparatur (23:313-318, 23:613).
- **Vor Messlauf zwingend:** `build_system_axis_levels()` hat keinen Aufrufer -> telemetry/page_type/simd_extension landen in KEINEM Sidecar (NW:297).
- Deep-Research-Pflicht (nie raten) fuer: CacheLevelTarget-Steuerung, AtomicFamily, CoRoutineStrategy, compiler-spezifische Runtime-Knoepfe, HW-Erweiterungs-Unterachsen, HYBRID-Heuristik (23:256/259/288/399, NW:83).

**B10. Lizenz / Zitation**
- NOTICE Architekt-Direktive II (02:190-197): alle Lizenztypen freigegeben, weil durch das Zerschneiden fuer jede Permutations-Achse ein neues Werk entsteht; bei Repos ohne Lizenz nur Autor-Nennung beim Zitieren.
- Lizenz-Audit vor Integration externer Repos (13:1622).

**B11. Arbeitsteilung**
- Thesis-Text-Arbeit gehoert ins Thesis-Repo, nicht ins Impl-Repo (23:508, 23:621); Thesis-Querverweise nur rueckwaerts.
- CI gruen + messfaehig => nur punktuelle Refactorings (23:607).
- Je Schicht Interface + testbar, 1 Review/Backup (23:608).
- **7 Forks sind NICHT entschieden** (23:632) — S-1..S-7; kein Bau ohne User-GO an diesen Stellen.

====================================================================
## (c) WIDERSPRUECHE ZWISCHEN DEN DATEIEN
====================================================================

**C1. Slot-Zahl 19 vs 18 (haerteste, live-relevante Divergenz).**
Dossier 23 fuehrt durchgaengig **19 Komposition-Slots T0..T18** (23:91 "19 Komposition-Slots T0..T18 `composition_factory.hpp:51-70`"; 23:104; 23:181; 23:460 "19-Slot-binary_id"; 23:374 "19-Slot-Binary"). Nachschlagewerk: **18 (T0..T17)** nach INC-2c, `static_assert sizeof...==18`, `kV3AxisCount=18`, POD-Version 6, sizeof 1344 (NW:7, NW:89, NW:307).
**Aufloesung:** Dossier 23 ist Pre-INC-2c (16.07.); Nachschlagewerk ist Ist. NW:319 nennt dies explizit "haeufigste Stale-Falle" und listet Dossier-aehnliche Belege als stale. **Regel: 18 gilt.**

**C2. Slot-Indizes verschoben.**
Dossier 23 spricht von "ISA-Achse T12" (23:255, 23:424, 23:463) und in Fork S-2 von "T19/T08/T06" (23:650). Nachschlagewerk: isa = **T11** (Alt-T12), value_handle = **T10** (Alt-T11), queuing_q2 = **T17** (Alt-T18); ein T19 existiert in keiner Zaehlung (NW:319). Jede Uebernahme von T-Indizes aus Dossier 23 ist falsch.

**C3. Compiler-Systemachse: TODO vs. gebaut.**
Dossier 23 fuehrt die Compiler-Systemachse durchgaengig als **TODO** (23:141, 23:171, 23:324-325 "EIN globaler Env-Knopf `COMDARE_CXX` ... nicht XML-getrieben, nicht per Permutation") und plant sie als Increment S-4/S-5. Nachschlagewerk: `CompilerSystemAxis` **gebaut + verdrahtet (+cxx=)** mit 2 Werten Gcc(g++-16)/Clang(clang++-22) (NW:45, NW:255); `ExtensionHardwareSystemAxis` ebenfalls gebaut + verdrahtet (+ext=). Der Dossier-23-Ist-Befund ist ueberholt; das Dossier-23-DESIGN (Build-Achsen-Muster, Sidecar, Default-OFF) ist offenbar realisiert worden.

**C4. Zusammensetzung der System-Achsen-Familie (echte inhaltliche Divergenz, nicht nur Stale).**
Dossier 23 / F4 fordert **4 Pflicht-Systemachsen: Scheduling, Hardware, NUMA, Locking** (23:137-139) + Compiler = 5. Der Nachschlagewerk-Kanon nennt **6 CEB-Konfig-Achsen: Scheduling, Hardware/ISA, Telemetrie, Last/Frameworks, Compiler, Erweiterungshardware** (NW:19, NW:308). **NUMA und Locking fehlen im Kanon; Telemetrie, Last/Frameworks und Erweiterungshardware fehlen in F4.** Das ist ein offener, in keiner der Dateien aufgeloester Punkt: entweder sind NUMA/Locking als Systemachsen still fallengelassen worden (dann Regression gegen F4/LEDGER:368), oder sie sind noch TODO und der 6er-Kanon ist unvollstaendig. **Zur Klaerung vorlegen.**

**C5. Mess-Haupt-/Unter-Achse: Basistext vs. Nachtrag.**
Beide Dateien enthalten den Basistext "16 Mess-Kategorien = (Haupt-)Achsen in flacher Registry" (23:108-112, NW:189-191) UND den 07-20-Nachtrag, der genau das korrigiert (Mess-Tooling = HAUPT, 16 Kategorien = UNTER; 23:114-122, NW:172). Die Basis-Tabellen wurden NICHT nachgezogen. Bei jeder Nutzung gilt der Nachtrag; die Tabellen sind CSV-/Registry-Projektion.

**C6. Begriff "Gattung": Ruling vs. laufender Text.**
§54-T1 (23:211-213) dekretiert: kanonisch heisst der Achsen-Typ "Organ-Achse"; "Gattung" ist reserviert fuer das Tier-Binary-INTERFACE und **NIE eine Achse**. Dem widerspricht der laufende Text derselben Datei ("ALGORITHMUS-GATTUNGS-ACHSEN", 23:87; "Gattungs-Achse / Organ-Achse", 23:199) und die Ueberschrift NW:130 "GATTUNGS-ACHSEN-MATRIX". Das Nachschlagewerk verwendet "Gattung" ausserdem in einer dritten Bedeutung: Ebene-1 AnatomyGattung (3) vs. Ebene-2 Genus (5), NW:132 mit dem Hinweis, dass der User-Begriff "Gattung" umgangssprachlich Ebene-2 meint. **Drei Bedeutungen im Umlauf; nur §54-T1 ist Ruling.**

**C7. Achsen-Zaehlung und -Nummerierung 11 vs 18/26 (Superseded-Ebene).**
Doc 07 §1 und Doc 02 §12 fuehren **11 Bausteine-Achsen** (1 PAGE-TYPE ... 10 MEASUREMENT, 11 TELEMETRY) mit ER-Feldern `PermutationFlags.bank_*`. Das ist ein **viertes ID-System** neben den drei in NW:323-326 genannten und deckt sich auch nicht exakt mit dem Legacy-`permutation_axes.xml`-11er-Satz (dort `reclamation` statt `MEASUREMENT`, NW:239). Konsequenz: Achsen-Nummern aus Doc 02/07 sind mit nichts im heutigen Code kompatibel; sie taugen nur noch als Paper-zu-Thema-Index (Doc 07 §3).

**C8. ADR-Entscheide in Doc 07 gegen heutige Doktrin.**
- **F8 "ValueHandle: std::variant + Concept-Constraint"** (07:40) widerspricht der spaeteren Direktive "kein `std::variant` (Bloat)" und dem heutigen `value_handle`-Registry mit 5 CT-Varianten (NW:103).
- **F1/F12-K "CacheEngineRuntime-Singleton + Heap-Allokation"** (07:33/44) und **F3 "Visitor mid-granularity"** kollidieren mit der CRTP+Concept-/kein-vtable-Doktrin (23:240).
- **F13 "Cross-Compilation-Toolchain (ZIH Runtime, sonst Compile-Time)"** (07:45) kollidiert mit `feedback_compile_time_only_no_runtime` / 23:354.
- **F10-K Flag-System (9 Banken) statt perm_id** (07:42) ist durch die heutige binary_id-/Segment-Serialisierung abgeloest.
Alle vier stehen unter dem Superseded-Banner, sind also nicht bindend — aber sie werden in Doc 02 §16 und Doc 07 §6 weiterhin als "F1-F15 Architekturentscheidungen" verlinkt, was bei fluechtiger Lektuere als gueltig missverstehbar ist.

**C9. Compiler als Permutations-Dimension: Organ vs. System.**
Doc 13 plant "Phase D (V42): Compiler-Matrix-Permutationen (V41.B4) als CartesianProduct mit `experiment_compiler`" (13:400-401) und Doc 07 ordnet Achse 9 ISA "(Compiler-Flags + target_clones)" zu (07:23). Das liest sich als Compiler-Permutation auf der Organ-/Baustein-Seite. Dossier 23 und das Nachschlagewerk entscheiden dagegen: Compiler ist **System-Achse, binary_id-orthogonal, H-10-Sidecar** (23:362-368 hart abgelehnt als binary_id-Segment; NW:286). Ebenso disambiguiert 23:206 explizit, dass `AxisBase::get_compiler()` (Doc 13) **Paper-Provenance je Organ** ist und **NICHT Build-Compiler-Steuerung**. **Doc-13-Phase-D darf nicht als Bauauftrag fuer eine Compiler-Permutationsachse gelesen werden.**

**C10. Compiler-Werteraum.**
Doc 13 arbeitet mit historischen Paper-Compilern (`gcc-9.5`, `clang-12`, `msvc-19.30`, `icc-2021`, 13:456-458) und einem Compiler-Cache, der beliebige Versionen holt und baut (13:214-218). Nachschlagewerk-Ist: genau 2 Werte, `g++-16` und `clang++-22` (NW:45/73). Fork S-6 empfiehlt explizit "strikt 2-wertig gcc|clang" (23:683). Der Doc-13-Compiler-Cache ist ausserdem selbst als **nicht aktiv** ausgewiesen (13:1275). Kein Widerspruch in der Sache (zwei verschiedene Compiler-Begriffe: Paper-Original-Build vs. Tier-/Host-Toolchain), aber eine reale Kollisionsgefahr im Vokabular und im spaeteren `<toolchains>`-XML-Block.

**C11. Doc-13-interne Restwidersprueche.**
- Teil A §4 fordert 3 Properties (`experiment_compiler`, `has_original_paper_code`, `is_original_module`, 13:136-141) und `experiment_compiler()`; Teil C reduziert auf 2 (`get_compiler`, `is_original_module`) und streicht `has_original_paper_code` (13:920-923). Teil C bindend, Teil A bleibt stehen.
- `manifest.txt` fuehrt `@has_original_paper_code` weiterhin als **Pflicht-Annotation** (13:618/634) und das Tool emittiert `kHasOriginalPaperCode` — laut 13:927 bewusst nur noch als Diagnose-Info, nicht als API. Wer §14 isoliert liest, baut die geloeschte Property nach.
- §18.1-Tabelle ist durch §19.6 explizit ueberholt ("ueberholt §18.1", 13:999).
- Wrapper-Zahlen inkonsistent ueber die Teile: 50 Wrapper (§9/§18) vs. spaeter 24 Allocator + 19 queuing + 6 traversal + 3 neue Original-SearchAlgo + Q15.

**C12. Permutationsraum-Groessenordnungen.**
Doc 02 §11.3: "30 SOTA x 10 Allokator x 6 Workloads = 1800 deklarierte Permutationen". Nachschlagewerk: golden = 320, Voll-Permutation = 137.594.142.720.000 (NW:126/265). Verschiedene Epochen und verschiedene Objekte (Profile-Permutationen vs. Achsen-Kartesik); die 1800 haben heute keine Entsprechung.

**C13. Schichtungs-Modell.**
Doc 02 §4.1 zeichnet eine **Vererbungs**-Kette `CacheEngine <- execution_engine <- search_engine <- prt_art` (02:112-120) und `status_t`-errno-ABI (02:130-133). Heutiger Stand laut Dossier 23: ABI-Grenze = `extern "C"` + uint64-PODs, Komposition statt Vererbung, CRTP (23:440-441). Superseded, aber die Drei-Saeulen-Skizze (02:17-42) wird dort als "REV3 -> REV7.7 unveraendert" ausgewiesen und ist damit die einzige Stelle, die Ebene-1/2/3 sauber trennt — sie bleibt konzeptionell brauchbar, ihre Klassen-/ABI-Details nicht.

**C14. "Drei Anwendungen" vs. "vier Subsysteme".**
Dossier 23 §5.1 zaehlt 2 tragende Anwendungen + Planer als 3. Doc 02:48 zaehlt eine **4-Subsystem-Trennung** (messung_driver -> CEB -> CE <-> Pruefling) und betont, dass diese orthogonal zur Drei-Repo-Aufteilung ist. Kein echter Widerspruch (Anwendungen != Subsysteme), aber die Zahlen 3 und 4 kollidieren rhetorisch; Doc 23 nennt die 4-Subsystem-Sicht nicht.

**C15. Nachschlagewerk-interne Inkonsistenzen (dort selbst deklariert, hier nur gespiegelt).**
(I) `all_axes_binary_count()` multipliziert weiterhin `enabled_count<axes26::T10_telemetry>` mit, obwohl telemetry System-Achse wurde (NW:336). (C) stale `k*SlotCount` set=15/seq=11/view=7/adapter=13 (NW:142/321). (H) page_type in `build_system_axis_levels()`, aber keine der 6 System-Achsen (NW:334). Diese sind als Fallen dokumentiert, nicht behoben.

--------------------------------------------------------------------
SELBSTCHECK: Alle 5 Dateien vollstaendig gelesen (13: 1981/1981 Z. in 4 Lesungen; 23: 796/796 in 2; NW: 341/341; 02: 378/378; 07: 132/132). Keine Datei geschrieben oder geaendert; reine Lektuere. Keine Secret-Werte zitiert (Token/PAT/Passwoerter kamen in keiner der Dateien vor). Ausgabe ASCII-only ausser deutschen Umlauten und §; keine Box-Drawing-/Em-Dash-Zeichen.