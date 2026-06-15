# Implementierungsverlauf V19–V22 (Stand 2026-05-14, 29:00)

**Zweck:** Elaborate Session-Doku als Stand-der-Diplomarbeit-Snapshot
nach Sprint V19–V22, vor dem grossen V23-Refactoring der cache-engine
Ordnerstruktur. Dient als Referenz fuer Habich-Termin~8 (V21.5) und
als Wieder-Einstiegspunkt nach Kontext-Reset.

**Vorgaenger:** `20260514-2330-v18-final-stand.md` (Ende V18-Reihe)

---

## §1 Sprint-Uebersicht V19–V22

Vier Sprints, alle vollautonom abgeschlossen, alle 3 Repos gepusht.

| Sprint | Fokus | Tasks | Repos | End-State |
|---|---|---|---|---|
| V19 | Profile-Tag `<expected_workload>` ueberschreibt traversal-Heuristik | 5 | cache-engine + prt-art + Diplomarbeit | gruen |
| V20 | `workload_used`-Feld bis ins CSV/JSON-Export durchgereicht | 5 | cache-engine + Diplomarbeit | gruen |
| V21 | art-Template ext-Skelett + Sample-Mess-Daten + thesis chapter~06 | 5 | cache-engine + Diplomarbeit | gruen, 2 USER-PENDING |
| V22 | diagram_generator nutzt Sample-CSV → echte TikZ-Diagramme + thesis re-built | 5 | Diplomarbeit | gruen |

**Pin-Bumps cache-engine**: 2f0222d (V18) → 08aca46 (V19) → ccb1555 (V20) → eee33fb (V21–V22).
**Pin-Bumps prt-art**: eca14a2 (V18) → bc877ed (V19, danach unveraendert).
**Diplomarbeit Branch main**: 28e34f1 (V18) → 520ddd4 (V19) → db7e957 (V20) → 45116a0 (V21) → 245abf1 (V22).

---

## §2 V19 im Detail — Profile-getriebenes Workload-Routing

**Ausgangsbeobachtung:** V11.2 routete Workloads heuristisch aus dem
`<traversal>`-Achsen-Tag. Aber nicht jeder Algorithmus passt zu seiner
traversal-Klasse: SuRF ist Range-Filter, profitiert aber von YCSB-A
(Read+Update fuer adaptive Filter). Das traversal-Mapping war zu starr.

**V19.1** — `<expected_workload>` als optionales Tag in Profile-XML.
Sechs Profile haben jetzt explizite Workload-Affinitaet:
- `surf` (cache-engine) → YCSB_A
- `coco_trie` (cache-engine) → YCSB_C
- `btreesareback` (cache-engine) → YCSB_E
- `mahling` (cache-engine) → YCSB_E
- `kuehn` (cache-engine) → YCSB_C
- `prtart` (prt-art) → YCSB_F

Die uebrigen 25+ SOTA-Profile bleiben heuristisch.

**V19.2** — `AlgorithmProfile.expected_workload` Feld + Parser-Erweiterung
in `xml_config_parser.cpp`. Regex-basiert:
```cpp
std::regex ew{R"(<expected_workload>([^<]+)</expected_workload>)"};
```

**V19.3** — `ExperimentDriver::phase5_run_workload`:
```cpp
if (!p.expected_workload.empty()) {
    fp_to_workload[fp] = parse_expected_workload(p.expected_workload);
} else {
    auto it = p.axes.find("traversal");
    fp_to_workload[fp] = pick_workload_for_traversal(...);
}
```
Reihenfolge: `expected_workload` > `traversal-Heuristik` > Default.

**V19.4** — 2 neue Tests in `test_codegen_from_profile`:
`ParsesExpectedWorkloadTag`, `ExpectedWorkloadOptionalEmpty`. 14/14 gruen.

**V18-Bug nebenbei gefixt:** `ExperimentDriverOptions.prt_art_root` Field
fehlte (V18.1 hatte nur `CodegenOptions` erweitert, nicht
`ExperimentDriverOptions`). Build war seit V18 still gebrochen, V19.4
deckte es auf.

---

## §3 V20 im Detail — workload_used bis ins Export

**Problem:** V19 fuehrte das Routing ein, aber das Export-CSV zeigte nicht
welcher Workload pro Permutation gelaufen ist. Auswertung kannte keinen
Weg, die `expected_workload`-Override-Effekte aus den Mess-Daten zu
rekonstruieren.

**V20.1** — `experiment::PermutationResult.workload_used` (std::string).
**V20.2** — `ExperimentDriver` Phase 5 setzt das Feld pro Permutation
mit neuer Lambda `workload_to_string(YcsbWorkload -> "YCSB_X")`. Fallback
auf `WorkloadOptions::workload` fuer Nicht-Profile-Module.
**V20.3** — `ResultAggregator::export_csv` schreibt `workload_used` als
4. Spalte. `export_json` schreibt `"workload_used": "..."` als zusaetzliches
Feld pro Result.
**V20.4** — Test `ResultAggregator.ExportContainsWorkloadUsedColumn`
verifiziert Header + Daten in CSV und JSON. 6/6 ResultAggregator-Tests
gruen.

**Neues CSV-Schema (16 Spalten):**
```
permutation_id, fingerprint, succeeded, workload_used,
op_count, total_cycles,
cache_misses_l1, cache_misses_l2, cache_misses_l3,
dtlb_misses, coherence_invalidations, energy_micro_joules,
bytes_allocated, bytes_in_use_peak, external_frag, internal_frag
```

---

## §4 V21 im Detail — ext-Skelett + Sample-Daten + thesis Pipeline

**Ziel:** Auf reale HW-Mess-Reihe vorbereiten, ohne sie zu erzwingen.
Der User braucht das Tooling als Pipeline-Blueprint bevor die Hardware
laeuft.

**V21.1** — `art_body.hpp.template` bekommt `#if defined(COMDARE_HAVE_UNODB)`-
Block. Bei aktiviertem Flag wird `unodb::db<std::uint64_t, std::uint64_t>`
aus `ext/P01-ART/unodb` instanziiert. Default-Path bleibt der V16.3-Stub.
**Nicht aktiviert** — braucht spaetere CMake-Integration + NOTICE-Update
(unodb Apache 2.0).

**V21.2** — **USER-PENDING.** Echte HW-Mess-Reihe braucht Stunden-Tage
Laufzeit auf i7-1270P-Workstation oder TU-Dresden-ZIH-Cluster
(SLURM-Submission, eduVPN). Cluster-Masterplan Phase~8 markiert
Singularity-Container-Upload + SLURM-Job-Templates explizit als
"MIT USER ABSPRECHEN".

**V21.3** — `Code/sample_data_generator/`:
- C++23 CLI-Tool, 10 Permutationen
- Deterministisch (mt19937_64 mit Seed 42)
- Schreibt V20.3-konforme CSV mit 16 Spalten
- Output: `Code/experiment_config/sample_data/v21_sample_measurements.csv`
- Pseudo-realistische Werte (5 SOTA Rang-1 + 4 weitere + prtart-Baseline)

Workload-Verteilung:
| Workload | Profile |
|---|---|
| YCSB_A | masstree, surf |
| YCSB_C | art, hot, coco_trie, start, b2tree |
| YCSB_E | wormhole, btreesareback |
| YCSB_F | prtart_baseline |

**V21.4** — `thesis/chapters/06_auswertung.tex` neuer Abschnitt
"Sample-Mess-Pipeline (V20+V21.3)". Beschreibt V19/V20-Erweiterung,
verweist auf Sample-CSV, markiert V21.2 explizit als USER-PENDING.

**V21.5** — **USER-PENDING.** Habich-Termin~8.

---

## §5 V22 im Detail — diagram_generator nutzt CSV → TikZ → PDF

**V22.1** — `diagram_generator`:
- `CsvRow` Struct
- `load_csv_with_workload_used()` parst V20.3-CSV (16 Spalten,
  `std::from_chars` fuer numerische Felder)
- `write_throughput_by_workload()` sortiert stabil nach `workload_used`,
  berechnet `throughput = op_count * 1e9 / total_cycles`,
  delegiert an `write_bar_chart` mit Label-Format `"<id> [<workload>]"`
- CLI-Subcommand `--by-workload <input.csv> <output.tex>`

**V22.2** — End-to-End-Pipeline:
```
sample_data_generator                                   (V21.3)
    -> v21_sample_measurements.csv                      (10 Permutationen)
diagram-generator --by-workload                         (V22.1)
    -> v22_throughput_by_workload.tikz                  (4 YCSB-Gruppen)
```

**V22.3** — `pdflatex thesis/main.tex` re-built. 21 Seiten, 396 KB
(+1 Seite ggue. V21.4-Build).

---

## §6 Was die Pipeline jetzt kann

**Ohne reale Hardware:**
1. Profile mit XML-Tag `<expected_workload>` definieren
2. ExperimentDriver routet Workload korrekt
3. Sample-Daten erzeugen
4. CSV → TikZ → PDF baut durch
5. Thesis re-baut ohne Errors

**Was fehlt nur noch:**
- Echte CSV statt Sample-CSV (Drop-in: einfach Datei tauschen)
- Das ist V21.2

---

## §7 Code-Pfade — komplette Liste fuer Habich-Termin~8

### cache-engine (eee33fb, branch main)
| Pfad | V-Reihe | Zweck |
|---|---|---|
| `cache_engine/algorithm_profiles/sota/*.profile.xml` | V19.1 | 5 Profile mit `<expected_workload>` |
| `cache_engine/builder/xml_config_parser/xml_config_parser.{hpp,cpp}` | V19.2 | Parser fuer neues Tag |
| `cache_engine/builder/experiment_driver/experiment_driver.{hpp,cpp}` | V19.3 + V20.2 | Phase~5 Override + workload_used |
| `experiment/include/comdare/experiment/result_aggregator.hpp` | V20.1 | PermutationResult.workload_used |
| `experiment/src/result_aggregator.cpp` | V20.3 | CSV/JSON-Export |
| `cache_engine/builder/codegen/templates/art_body.hpp.template` | V21.1 | ext-Skelett (HAVE_UNODB-gated) |
| `tests/unit/test_codegen_from_profile.cpp` | V19.4 | +2 Tests |
| `tests/unit/test_workload_and_experiment.cpp` | V20.4 | +1 Test |

### prt-art (bc877ed, branch development)
| Pfad | V-Reihe | Zweck |
|---|---|---|
| `prt_art/algorithm_profiles/prtart_pruefling.profile.xml` | V19.1 | YCSB_F-Tag |

### Diplomarbeit (245abf1, branch main)
| Pfad | V-Reihe | Zweck |
|---|---|---|
| `Code/sample_data_generator/{sample_data_generator.cpp,CMakeLists.txt}` | V21.3 | CLI-Tool |
| `Code/CMakeLists.txt` | V21.3 | add_subdirectory |
| `Code/experiment_config/sample_data/v21_sample_measurements.csv` | V21.3 | 10 Permutationen |
| `Code/experiment_config/sample_data/v22_throughput_by_workload.tikz` | V22.2 | E2E-Pipeline-Output |
| `Code/diagram_generator/{diagram_generator.{hpp,cpp},main_cli.cpp}` | V22.1 | workload-Gruppen-Plot |
| `thesis/chapters/06_auswertung.tex` | V21.4 | Sample-Pipeline-Abschnitt |
| `thesis/main.pdf` | V22.3 | re-built 21 Seiten |
| `docs/sessions/20260514-2400-v19-anker.md` | V19.0 | Anker |
| `docs/sessions/20260514-2430-v19-final-stand.md` | V19.4 | Final |
| `docs/sessions/20260514-2500-v20-anker.md` | V20.0 | Anker |
| `docs/sessions/20260514-2530-v20-final-stand.md` | V20.4 | Final |
| `docs/sessions/20260514-2600-v21-anker.md` | V21.0 | Anker |
| `docs/sessions/20260514-2700-v21-final-stand.md` | V21.5 | Final |
| `docs/sessions/20260514-2730-v22-anker.md` | V22.0 | Anker |
| `docs/sessions/20260514-2800-v22-final-stand.md` | V22.4 | Final |
| `docs/sessions/20260514-2900-implementierungsverlauf-V19-V22.md` | (this) | Diese Doku |

---

## §8 USER-PENDING (autonom NICHT moeglich)

### V21.2 — HW-E2E-Mess-Reihe
**Was:** Echte Permutations-Mess-Reihe gegen lokal i7-1270P oder ZIH-Cluster.
**Wie:** `messung_driver --messreihe A_full --output _runs/2026-05-14/`.
**Output:** ersetzt `Code/experiment_config/sample_data/v21_sample_measurements.csv`.
**Begruendung autonom-NICHT:** Stunden-Tage Laufzeit, Cluster-Job-Submission
braucht User-Auth (eduVPN, Singularity-Upload), Cluster-Masterplan Phase~8
explizit User-pending.

### V21.5 — Habich-Termin~8
**Was:** Sprechstunde Mo 13:30~Uhr.
**Vorbereitung fertig:** `20260508 Termin 7/HABICH_TERMIN8_VORBEREITUNG_2026_05_14.md`
mit 6 Diskussionspunkten (Hardware-Validierung, Manuskript-Schreibphase,
Workload-Routing, Module-Bodies, Permutationsexplosion, Sprechstunden-Plan).
**Begruendung autonom-NICHT:** physischer Termin.

---

## §9 V23+ Pending (User-Direktive vom 2026-05-14)

Direkte User-Anfrage am Ende V22:

> "cache-engine aufraeumen — viele Ordner im Root, viele leer, prt-art-Reste,
>  CoCo-Trie Testdaten fehlen, Build-Ordner global+ephemeral, Best-Practices
>  recherchieren, prt-art-Restsubsumption pruefen."

Aufgesplittet in V23-Tasks (in `20260514-2930-v23-anker.md` zu definieren):

| # | Task | Risiko |
|---|---|---|
| V23.1 | Web-Recherche C++ Best Practices Layout | niedrig |
| V23.2 | Bestandsaufnahme cache-engine: Ordner + leer + Inhalt | niedrig |
| V23.3 | prt-art-Restsubsumption pruefen | mittel |
| V23.4 | CoCo-Trie + andere Benchmark-Daten — Recherche Download-URLs | niedrig |
| V23.5 | Plan vorlegen + User-Approval | (Plan-Mode) |
| V23.6 | Refactoring cache-engine Ordnerstruktur | **HOCH** (CMake, Submodule, CI) |
| V23.7 | Build-Ordner global+ephemeral konfigurieren | mittel |
| V23.8 | Diplomarbeit: eigenes test_data_xml/ Verzeichnis | niedrig |
| V23.9 | Tests + Builds verifizieren in allen 3 Repos | (CI) |
| V23.10 | Doku-Update + Final | (letzter) |

**Wichtig:** V23.6 (Ordner-Refactoring) ist hochrisikant — 3 Repos
mit Submodule-Pin-Abhaengigkeiten + CI-Pipelines + Include-Pfaden.
Erst Plan vorlegen, dann ausfuehren.

---

## §10 Drei-Repo-Abhaengigkeitsgraph (V22 Stand)

```
Diplomarbeit  (probst-Diplomarbeit-cache-engine, branch main)
    ├─ external/comdare-prt-art  (Submodule, pinned bc877ed)
    │      └─ Adapter, PrtArtSearchEngine
    └─ external/comdare-cache-engine  (Submodule, pinned eee33fb)
           ├─ cache_engine/  (Builder, Codegen, Profiles)
           ├─ experiment/  (ResultAggregator)
           ├─ workload_generator/  (YCSB-Synthetic)
           └─ ext/  (12 SOTA-Repos: P01-ART/unodb, P02-HOT, ..., A01-hoard, ...)

prt-art        (comdare-prt-art, branch development)
    └─ depends-on: cache-engine ABI (search_engine, module_abi_v1)
```

**Submodule-Pin-Disziplin:** Bei jedem cache-engine-Push → in
Diplomarbeit `git fetch && git checkout <commit>` im Submodule, dann
Pin-Bump-Commit in Diplomarbeit. Identisch fuer prt-art.

---

## §11 Querverweis-Index

- V18-Final: `20260514-2330-v18-final-stand.md`
- V19-Anker: `20260514-2400-v19-anker.md`
- V19-Final: `20260514-2430-v19-final-stand.md`
- V20-Anker: `20260514-2500-v20-anker.md`
- V20-Final: `20260514-2530-v20-final-stand.md`
- V21-Anker: `20260514-2600-v21-anker.md`
- V21-Final: `20260514-2700-v21-final-stand.md`
- V22-Anker: `20260514-2730-v22-anker.md`
- V22-Final: `20260514-2800-v22-final-stand.md`
- HABICH_TERMIN8: `20260508 Termin 7/HABICH_TERMIN8_VORBEREITUNG_2026_05_14.md`
- Cluster-Masterplan: `Cluster/sessions/2026-02-03-architektur-migrations-masterplan-session.md`
