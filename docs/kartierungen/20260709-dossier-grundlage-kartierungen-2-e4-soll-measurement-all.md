I have the complete picture. Here is the structured SOLL-Bild.

---

## Legende (Wurzeln, absolut)
- **super** = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`
- **ce** = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine`
- **mod** = `/home/comdare/Projekte/Modules/comdare-measurement-all`

---

## 1 — Der 28.06.-E1–E4-Plan (Dossier §12–§17)

Datei: `ce/docs/sessions/20260628-KONTEXT-DOSSIER-mess-echtheit-gattungen-observer-pruefdock-A2welle.md` (570 Z.)

**Die vier E-Ebenen** (Definition Z.32; §13-Tabelle Z.385–390, Ablauf Z.393):
- **E4 — XML-Experiment-Definition** (oberste, „das WAS"): `comdare_thesis_profile` = `ce/libs/cache_engine/algorithm_profiles/thesis_profiles/*.profile.xml` + `SCHEMA.md`. Ist-Delta (Z.387): Profile liegen physisch in der Bibliothek, **gehören konzeptionell ins Superprojekt**.
- **E3 — Permutations-B+-Baum PRO GATTUNG** (Abstract Factory): `profile_to_tree.hpp::build_axis_levels` + `experiment_tree.hpp` (Z.388).
- **E2 — StaticAxisNode → Tier-Binaries** (compile-time, je Static-Pfad eine eigene DLL): `cache_engine_builder_iterator.hpp` (Z.389).
- **E1 — DynamicVariableNode → RC** (Laufzeit-FOR-Schleife auf geladener Binary): `runtime_variable_loop.hpp` + `IResourceControllableTier` (Z.390).

**Zwei Knotenarten** (§12 Z.370–373): StaticAxisNode = compile-time = DLL-Wechsel zur Mess-Laufzeit; DynamicVariableNode = RC-Schleife auf der geladenen Binary (kein Neubau). **Blatt = 1 Mess-Lauf = (Binary × 1 Laufzeit-Einstellung)** (Z.373). RC = `Algorithm_Resource_Control`, POD `ComdareResourceControlV1` mit 5 Feldern (Z.377).

**Nacharbeits-Reihenfolge** (§14 Z.443, §15 Z.451–456) — deckt sich mit Deiner Sequenz:
`#188 (E2-Wurzel; +#211/#214/#216/#213/#217)` → `#221 (E1-RC-Konsum, löst B4-1)` → `#223 (E3-Gate)` → `#215 (320-DLL-Neubau = Wirksamkeits-Schleuse)` → `[#210 Infra]` → `#156/#162 (E4 A/B/C-Aktivierung)`.

**Audit-Befunde** (§14 Z.412–435). Achtung: ich finde **7 gelabelte Befunde** (B4-1/-2, B3-1/-2, B2-1/-2, B1-1), nicht 8 — kein B1-2 im §14-Log:
- **B4-1** (Z.419): die 4 algorithmus-internen RC-POD-Felder (prefetch_distance/pool_budget/batch_size/inline_threshold) haben **keinen XML-Eingang / kein ThesisProfile-Feld / keinen SCHEMA-Eintrag / kein emit** → aktuell gar nicht XML-definierbar. `profile_to_tree.hpp:74-85`, `runtime_variable_loop.hpp:53-60`. Fix E2-abhängig.
- **B4-2** (Z.421–422): Auswertungs-Kette **komplett+reproduzierbar** (WIDE-CSV → `csv-to-latex.exe`/`04_csv_to_latex` + `diagram-generator.exe`/`05_diagram_generator` → `thesis/diplomarbeit/generate_wide_appendix.ps1` → 11 Tabellen → bilinguale PDF). **KERN-LÜCKE:** die 3 Messreihen A/B/C parametrisch übersprungen (fehlt m3v2-Matrix #156, gated #162/#215/#210); Tool-Seite fertig.
- **B3-1** (Z.423): Abstract-Factory-pro-Gattung via `GenusBindingTraits<G>` (`genus_binding_traits.hpp`); SearchAlgorithm = verifiziert (19 Slots); Graph offen.
- **B3-2** (Z.425): Konformitäts-Gate angeblich nicht im Voll-Lauf — **später als STALE/FALSCH korrigiert** (Z.475, Z.534): Gate feuert real in `perm_runner.hpp:154-155/:233-234`; #223 auf Regressions-Test + CI-Job geschrumpft (done `d0dd6a5`).
- **B2-1** (Z.429): **#188 = E2-Wurzel** — `container_`/`search_organ_`-Doppel-Spaltung; Weg-A (Array) gelöst, Weg-B (SOTA-Bäume) = paralleler Spiegel-Apparat → Meta-Lehre #3 verletzt.
- **B2-2** (Z.431): Cache-Line compile-time eingewoben, aber **KEINE Laufzeit-RC-Setter** an den Achsen (E1→E2-Konsum fehlt).
- **B1-1** (Z.433–434): definitiv **kein Organ liest `ComdareResourceControlV1` zur Laufzeit**; `apply1` endet im Null-Object `applied_rc_` (`abi_adapter.hpp:1729`, 0 Reader). #221 = pro Achse Laufzeit-Konsum-Setter + apply1-Verdrahtung.

Gesamt-Verdikt (Z.438–443): Pipeline strukturell gesund + XML-only-fähig im Gerüst; **2 Wurzel-Lücken (#188, #221) + 2 Verdrahtungs-Lücken (#223, B4-1)**.

**#188-Plan §17** (Z.489–513): SOLL = EIN Speicher `container_ = ObservableComposedSearch<traversal_for_search_algo_t<…>, LayoutAwareChunkedStore>` für ALLE Familien; `search_organ_` entfällt. Inkremente 4a (k-ary/Eytzinger als StoreTraversable) → 4b (Pool-Familie Tree/Trie/Hash) → 4c (`search_organ_`-Entfall, ABI-Berührpunkte `abi_adapter.hpp` ~:1660-1673/:942-947/:1515-1519/:1552-1553/:1170-1197) → #215 → #156/#162.

---

## 2 — measurement-all-Familie + #31-Vokabular-Verortung

Struktur (`mod/README.md` Z.5–11; Baum verifiziert):
- **`comdare-baseline_0-core/comdare-metrics`** — Mess-Kern, generische Observer-/Zähler-Verträge — #274 **Schritt 3** (noch nicht transferiert)
- **`comdare-baseline_1-instrumentation/comdare-pmc`** — Schritt 5
- **`comdare-baseline_2-workloads/comdare-workloads`** — inkl. `dataset_loader`/`workload_generator` — **Schritt 7 (befüllt)**
- **`3-analysis`** — per F14 **VORGESEHEN, aber noch NICHT angelegt** (Regel: leere Baseline = kein Ordner, README Z.11)
- Abgrenzung (Z.15): `metrics` = generisch; die **measurement-Domäne der cache-engine bleibt Research-seitig**. Provenienz #274 Schritt 0, GitLab-Projekt-ID 300 (Z.23).

**comdare-workloads** (`mod/comdare-baseline_2-workloads/comdare-workloads/README.md`):
- Inhalt (Z.6–8): YCSB-Kern `comdare::workloads`, driver-Generika `comdare::workloads::driver`, Dataset-Slot `comdare::workloads::dataset`.
- Vokabular real: `include/comdare/workloads/workload_generator.hpp:20-27` = `enum class YcsbWorkload { A..F }` (identisch zu #31s A–F).
- **Der gated Migrationsplan-Schritt 13** = wörtlich README Z.28–29: *„Der Monolith (CI 286) bleibt unangetastet; Research-Verdrahtung ist **Schritt 13**."* — bestätigt in `workload_generator.hpp:73-74` (`to_abi_descriptor` bewusst NICHT migriert, ABI-Naht bleibt im Monolithen bis Schritt 13). Bewusste Auslassungen auch `workload_orchestrator`, `load_profile_parser/writer` (Z.21–24).

**„Option A"** = die **Doku-25-Modul-Split-Entscheidung**, nicht ein measurement-all-„Doc 15". Beleg: `ce/docs/sessions/architektur-ziele-offene-punkte-ledger.md:40` — *„User wählte nach Doku 25 **Option A** → alle 6 modules/-Repos mit kuratiertem Public-Header-Set … non-destruktiv, modules/ NICHT im Build-Graph"*; **Option B** = echte Konsumptions-Migration (Monolith baut FROM Submodulen), gated auf GitLab-/DependencyManager-Reife.

**Verortung des #31-Vokabulars (SOLL):** Das Workload-Vokabular (YCSB A–F) gehört **jetzt schon** zu `comdare-workloads` (baseline_2). Die Dataset-Achse (6 Kanon-Datensätze) + die **Mess-Kategorie** (Granularität Micro/Macro/Overall, s. §4) gehören in die **noch anzulegende Stufe `3-analysis`**. Nach Option A bleibt beides bis **Schritt 13** ein reines Modul-Public-Interface; die Research-Pipeline (Monolith) konsumiert es erst mit der Verdrahtung — bis dahin ist der Monolith unangetastet.

**Ehrlichkeits-Flag:** Ein literales „Doc 15" zur measurement-Migration existiert in den Repos **nicht** — der einzige In-Repo-Treffer „Doku 15" ist die unverwandte ISA-Schichten-Architektur-Doku (`ce/docs/architecture/17_paper_kartografie_r7_6.md:240`, `.../16_axis_05_imc_runtime_heuristik.md:5`). Die tragenden Fakten Deines Hinweises sind: Option A = Doku 25 (Ledger:40), Schritt 13 = workloads-README:28-29.

---

## 3 — Die konkreten E4-XML-Dateien + #31-Andockpunkte

**#31-Kern = die „tote compile-time-Insel":** `ce/libs/cache_engine/builder/workload_driver/workload_matrix.hpp`
- Header-Selbstbeschreibung Z.2–20: „compile-time-Workload-Achse der 2D-Mess-Matrix … **REUSE** des bestehenden `enum class WorkloadKind` … Achse W wie eine **DynamicVariableNode-Wertmenge des experiment_tree, KEINE Binary-Identitäts-Achse** … analog #29-Schritt-1 (`container_framework`)".
- Inhalt: `ycsb_profile_list` (A–F, Z.57–63), `CanonicalDataset { Url,Dna,Protein,Xml,TpcdsId,TrecTerms }` (Z.80), `matrix_cells = mp_product` (Z.105) → `matrix_cell_count == 36` (Z.110, static_assert 6×6).
- **Tot verifiziert:** einziger Konsument ist `ce/tests/unit/test_31_workload_matrix.cpp` (grep über gesamtes ce). Nur `static_assert`/`mp_for_each`-Selbstbeweis, kein Mess-Pfad-Konsum.

**Die realen E4-XML-Andockpunkte:**

1. **`super/Code/experiment_config/config_b_cache_engine_perms.xml:17-20`** — Workloads bereits als XML: `<workloads><workload type="ycsb">C</workload> <…>A</workload></workloads>` (REV-7.6-Messreihen-Format, nur 2 Workloads, keine Dataset-/Kategorie-Achse). **Beweis, dass Workload-als-XML funktioniert.**

2. **`ce/libs/cache_engine/algorithm_profiles/thesis_profiles/m3v2_study.profile.xml`** — der reife E4-Anker:
   - `:127-131` `<compile_dims><workloads>A B C D E F</workloads>` **← exakt der SOLL-Ort für #31s Achse W** (YCSB A–F als je-Binary-gebackene compile-time-Dim).
   - `:133-138` `<runtime_dynamic>` (thread_count/hw_prefetcher = E1); `:123-125` `<working_set_sweep>`; `:110-121` `<sota_series_set>` A/B/C.
   - **Fehlt:** eine `<datasets>`-Dim (die 6 CanonicalDataset) und eine Mess-Kategorie-Dim → genau das, was #31 hier ergänzen müsste.

3. **`super/Code/test_data_xml/messreihe_v32_schema.xsd`** — das v32-Tupel-Schema:
   - Root `messreihe` (`:12-23`) = metadata + execution_engines + `axes_default_lookup` + `tupel`(unbounded) + output.
   - `TupelType` (`:65-147`): `<workload kind/record_count/operation_count/seed>` (`:67-74`) + `op_type` OP-1..6 (`:76-87`) + `hardware_strategy` (`:88-99`) + `scheduling_strategy` (`:100-111`) + `compiler_strategy` (`:112-132`) + `axes` (`:133-144`).
   - **Fehlt für #31:** KEIN `<dataset>`-Element und KEINE Mess-Kategorie-Enumeration im `TupelType` → hier müsste #31 die Dataset-Achse (analog `op_type`-Enum `:76-87`) + Mess-Kategorie schema-seitig ergänzen.

4. **`super/Code/02_messung_driver/main.cpp`** — die Laufzeit-Konsum-Stelle:
   - `load_messreihen` `:167-204`: minimaler Regex-XML-Reader, zieht NUR `<messreihe id>` + `<mode>` + `<profile>`-Liste — **liest weder Workload noch Dataset**.
   - Hartkodierter Workload `:476-483`: `WorkloadOptions w; w.config.random_seed=42; … w.workload = wg::YcsbWorkload::C;` (`:483`) — der einzelne fest verdrahtete Workload C. **Das ist der Punkt, den #31-ebenen-richtig durch XML-gelesene (Workload × Dataset)-Zellen ersetzen müsste.**

**SOLL-Andockung #31:** Die 36 mp11-Zellen aus `workload_matrix.hpp` wandern von der toten compile-time-Insel in die **E4-XML** — konkret als `<compile_dims><workloads>` (existiert, `m3v2_study.profile.xml:129`) **plus** neuer `<datasets>`-Dim **plus** Mess-Kategorie; das XSD (`messreihe_v32_schema.xsd:65-147`) bekommt Dataset-/Kategorie-Elemente; `main.cpp:483` + `load_messreihen:167-204` lesen die Zellen statt sie hartzukodieren. So wird #31 eine E4-Definitionsachse (das WAS), nicht eine `mp_product`-Insel ohne Konsument.

---

## 4 — Der reale Mess-Visitor + die 2 Mess-Dimensionen

**Doc 24** `ce/docs/architecture/24_messmodell_korrektur_zwei_dimensionen.md` (675 Z.) — zwei getrennte Dimensionen + eine Vergleichs-Dimension (Z.34):
- **§2.1 Lebewesen-Ebene** (Z.36–47): der ganze Suchalgorithmus, gemessen durch den **CacheEngineBuilder** als **Wall-Clock** (Latenz über Element-Füllstand, r/w/d getrennt) + Ressourcen. Wall-Clock bleibt hier.
- **§2.2 Achsen-Ebene** (Z.51–58): **Per-Achsen-Statistics-Observer** (Anatomie) via `observe_all()` → `ObserverAggregate` über alle 17/19 Achsen.
- **§2.3 Achsen-VERGLEICH** (Z.63–71): welche Achsen-Variante besser = **Tests gegen vereinheitlichtes Interface vs. bekannte Algorithmen**, NICHT über den Latenz-Benchmark.
- Merksatz-Tabelle Z.77–81. Die korrigierte Abweichung (Z.23–28): F15 maß Wall-Clock über nur **3 künstlich variierte Achsen** (search×allocator×layout) statt Per-Achsen-Observer.

**Doc 31** `ce/docs/architecture/31_observer_interface_konsolidierung_i1.md` (122 Z.) — der EINE reale Mess-Visitor:
- **`IObservableTier::tier_observe(ComdareTierObserverSnapshot*)`** pure virtual `=0` (Z.84) — quert die Modul-Binary-Grenze als komposition-unabhängiger **memcpy-POD** (Z.19). **Pfad B.**
- Historie V1→V2→V3→V4 (Z.35–42), je +1 Mess-Dimension: **V3** = generische `axis_stats[19][8]`-Matrix ALLER 19 SearchAlgorithm-Achsen (Z.41); **V4** = Per-Achsen-TIMING `seg_ns[19]` über die reale composite-Struktur (Z.42, Pfad B).
- **`kV3AxisSchema`** (Z.45, Z.64) = das autoritative Schema (19 Achsen × bis 8 Felder), single-source in `observable_tier.hpp::kV3AxisSchema`; neue Achse = reines Weiter-Befüllen.
- I1-Konsolidierung (Z.84–85): EINE `tier_observe` + EIN versionierter POD; V2/V3/V4 + Snapshots entfallen. Pfad A (`IMeasurableWorkload::run_workload`, isolierter Achsen-Bench, Wall-Clock) bleibt getrennt (Z.20, §7 Z.105–110).

**`ce/libs/cache_engine/builder/measurement_snapshot.hpp`** (194 Z.) — der Ziel-POD beider Dimensionen:
- **`ComdareMeasurementSnapshotV1`** (Z.34–66, Task #50) = der EINE autoritative Mess-POD **16+6 Spalten** (Z.2): 16 Performance/Meta (u.a. `total_cycles` = Wall-Clock-Latenz, Z.42) + 6 funktionale Observer-Spalten (`search_insert/lookup/hit/miss/erase/peak`, Z.56–62).
- `measurement_from_workload_result` (Z.96–115): zieht die Allocator-Werte aus `observer.axis_stats[6]` und die Search-Werte aus `axis_stats[0]` — **d.h. direkt aus der V3-`axis_stats`-Matrix** (die Per-Achsen-Dimension). Wall-Clock `total_cycles` = `merged_p50_ns` (Z.102).
- HW-Counter P4/PMC-gated mit `pmc_available`-Ehrlichkeits-Flag (Z.15–16, Z.50). Kanonischer Serializer Z.139–167; `pipeline16` Z.171–192.

**Zusammenfassung 2D:** **Lebewesen-Wall-Clock** (CacheEngineBuilder, Doc 24 §2.1, `total_cycles`) ⟂ **Per-Achsen-Observer** (`IObservableTier::tier_observe` → `axis_stats[19][8]` nach `kV3AxisSchema`, Doc 24 §2.2 / Doc 31); beide landen im EINEN `ComdareMeasurementSnapshotV1`. Die **Mess-Kategorie** aus #31 (Granularität Micro/Macro/Overall, Doc 24 §2 Merksatz / Dossier §14 Z.401) ist die dritte, orthogonale Wähl-Achse, die E4-XML deklarieren müsste — parallel zu Workload×Dataset.

---

**Read-only eingehalten** — keine Datei erstellt/geändert. Zwei offene Ehrlichkeits-Punkte: (a) im §14-Audit-Log finde ich **7** gelabelte Befunde (B4-1..B1-1), nicht 8 (kein B1-2); (b) ein literales „Doc 15" zur measurement-all-Migration existiert nicht — die tragenden Belege sind Ledger:40 (Option A = Doku 25) und workloads-README:28-29 (Schritt 13).