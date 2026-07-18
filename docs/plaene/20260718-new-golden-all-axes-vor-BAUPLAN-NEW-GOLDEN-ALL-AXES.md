# BAUPLAN-DOSSIER — Neue golden-Grundlage: XML deckt ALLE 17 Achsen ab → N>320

> **Status:** VOR-Deep-Research (Workflow `wf_e9aa1c4f`, 5 Agenten, ~447k tokens), dem User als Klartext vorgelegt
> 2026-07-18. **GATED auf User-Entscheid (Ziel-N)** + explizite Freigabe (TABU-Fenster: CatalogAxes/golden_fullpilot_320).
> Roots: **ce** = `Code/external/comdare-cache-engine`. Basis = Stand nach INC-2d (17 Komposition-Achsen, isa raus).

## 0. Auftrag (User-Direktive verbatim, 2026-07-18)
> „erstelle eine neue Grundlage für ein XML welches **ALLE Achsen abdeckt** und daher ein new golden baut, aber es
> werden laut **Permutations-Mathematik mehr als 320** Rekombinationen werden, nimm diese **neu ermittelte Zahl** mit
> **compile und test** als neues golden Ziel." + Präzisierung: „sobald der Standard der neuen golden **über alle
> Achsen** angehoben wurde um **echte Regressionen über das gesamte System** zu erkennen" (dann Hauptstrang weiter).

**EINSCHUB, kein Ersatz:** Zweck = die golden-Referenz von einem 4-Achsen-320-Subset auf einen **Ganz-System-
Regressions-Detektor** (alle 17 Achsen) heben. Danach Hauptstrang: A2-Neben → FF0–FF4-Messlauf → Thesis-PDF.

## 1. Varianten-Tabelle (17 Achsen nach INC-2d, enabled mp_size)
| # | Achse | Slot | enabled mp_size | golden-320-take | All-Vary-2^17-take |
|---|---|---|:-:|:-:|:-:|
| 1 | search_algo | L00 | 4 | 4 | 2 |
| 2 | cache_traversal | L01 | 3 | 1 | 2 |
| 3 | mapping | L02 | 2 | 1 | 2 (=voll) |
| 4 | path_compression | L03 | 3 | 1 | 2 |
| 5 | node_type | L04 | 4 | 4 | 2 |
| 6 | memory_layout | L05 | 5 | 5 | 2 |
| 7 | allocator | L06 | 3 | 1 | 2 |
| 8 | prefetch | L07 | 4 | 4 | 2 |
| 9 | concurrency | L08 | 9 | 1 | 2 |
| 10 | serialization | L09 | 4 | 1 | 2 |
| 11 | value_handle | L10 | 5 | 1 | 2 |
| 12 | index_organization | L11 | 4 | 1 | 2 |
| 13 | io_dispatch | L12 | 4 | 1 | 2 |
| 14 | migration_policy | L13 | 4 | 1 | 2 |
| 15 | filter | L14 | 4 | 1 | 2 |
| 16 | queuing_q1 | L15 | 15 | 1 | 2 |
| 17 | queuing_q2 | L16 | 5 | 1 | 2 |

- Voll-Produkt (jede Achse voll) = 4·3·2·3·4·5·3·4·9·4·5·4·4·4·4·15·5 = **59.719.680.000** (~6·10¹⁰) — compile-unmaterialisierbar, VERWORFEN.
- golden-320 = 4·4·5·4 = 320 (nur 4 Achsen voll, 13 gepinnt take=1). isa (war T11) ist NICHT mehr unter den 17 (INC-2d System-Achse).
- **Kleinstes Inventar mapping=2 → KEINE Achse ist Fanout-1; jede kann ≥2 variieren.**

## 2. Die neue golden-Zahl N (Kern-Mathematik)
**Entscheidender Satz:** „alle 17 Achsen abgedeckt UND jede variiert" = kartesisch jede Achse take≥2 → **Minimum =
2¹⁷ = 131.072**. **Zwischen 320 und 2¹⁷ existiert KEINE reine All-Vary-Kartesik** (jede kleinere Zahl pinnt ≥1 Achse).

**Optionen:**
- **OPTION 1 (empfohlen, faithful):** alle 17 je 2 → **N = 2¹⁷ = 131.072.** Einzige reine All-Vary-Rekombination >320, <10¹².
- OPTION 2 (all-vary, reicher): golden-4 voll + 13 je 2 → N = 320·2¹³ = 2.621.440.
- OPTION 3 (kuratiert, DLL-baubar, ABER nur 7–8 Achsen): golden-4 voll ·2^k: k=3→2.560, k=4→5.120.
- OPTION 4 (hybrid additiv, alle 17 berührt): 320-Basis + Σ(enabled−1)=52 Sweeps → N = 372 (additiv, nicht Rekombination).

## 3. Materialisierbarkeit — die kritische Präzisierung
- **golden-REFERENZ** (Count-`static_assert` + N-Zeilen-id-Datei + Roundtrip = der Ganz-System-Regressions-Detektor):
  bei N=2¹⁷ **machbar** — `static_assert(count==N)` ist reine mp_size-Arithmetik (billig auch bei 2¹⁷); id-Datei =
  131.072 Textzeilen (wenige MB); StaticBinaryView-Iteration lazy.
- **compile-materialisierter Quell-Katalog** (`generated_source_catalog.hpp`, 1 Typname je Permutation für DLL-Codegen):
  bei 131k = GB-TU → **Explosion / g++-ICE-Risiko** ([[reference_ci_runner_ice_cold_cache_instability]]). MUSS entkoppelt
  kleiner bleiben (320/kuratiert).
- **echter DLL-Messlauf** N=2¹⁷ = ~409× golden-320 (bereits mehrtägig) → unpraktisch, opt-in/gestaffelt (CI-Grün=Messung AUS).

⇒ **golden-REFERENZ (2¹⁷, alle Achsen, compile+test) ≠ materialisierter Bau-/Mess-Satz (kleiner).** Genau die Trennung
„Regressionen erkennen" (Referenz) vs „messen" (opt-in). Der golden-Referenz-Detektor ist der geforderte Standard.

## 4. Code-Umstellung (geordnet)
1. **NEU** `libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml` — comdare_thesis_profile,
   `permute_axes` über ALLE 17 Achsen in kanonischer kCompositionAxisNames-Reihenfolge (Pflicht, sonst catalog_codegen-
   Fehler main.cpp:193-201), je Achse die Ziel-Varianten-Zahl an `<value>` (N=2¹⁷: je 2 konkrete name()-Werte). Additiv
   neben m3v2 (TABU-schonend).
2. `cmake/catalog_codegen.cmake:17` — `_comdare_limits_profile_xml` auf die neue XML repointen (oder Zweitziel).
3. `source_catalog.hpp:82-108` — `CatalogAxes` von 4 Params auf 17 K00..K16 generalisieren; alte `<4,4,5,4>` als
   benannter `golden_320`-Alias `CatalogAxes<4,1,1,1,4,5,1,4,1,1,1,1,1,1,1,1,1>` erhalten.
4. `source_catalog.hpp:112` — `FullSourceCatalog` auf N-Grade; **NEU nach :112**
   `static_assert(FullSourceCatalog::Engine::count()==N, "neues golden Ziel")` — der geforderte compile-Guard (existiert
   heute NICHT).
5. `tools/gen_golden_fullpilot/main.cpp:53` — Exit-Guard `==320` → `==N`; Header-Signatur.
6. `tools/axis_registry_gen/main.cpp:204-211` — 2. Grad-Hartkodierung `golden_wired` synchron nachziehen (oder entkoppeln).
7. Tests: `test_profile_roundtrip.cpp` (320→N), `test_limits_entkopplung_vorstufe.cpp`, `test_smoke_coverage_profile.cpp`;
   `tests/unit/CMakeLists.txt` `COMDARE_GOLDEN_320_IDS`→neue N-Datei (oder `_N_IDS`); golden-Diff-Fixtures regenerieren.
8. **NEU** `golden_fullpilot_<N>_binary_ids.txt` via gen_golden_fullpilot (additiv, ersetzt 320-Datei NICHT).

## 5. Messdaten-erhaltend
1. Aktive 320-golden (ABI-6) als Snapshot `_abi6.txt` neben `_abi4/_abi5` — nie überschreiben.
2. `golden_320`-Alias-Katalog + additiver `test_golden_320_snapshot` (count==320 + Diff==leer) → 320-Grundlage bleibt
   compile+test-verankert, während N das neue Ziel wird.
3. Neue N-golden = additive Datei. Vorhandene `measurement/<datiert>/`-CSV unberührt.

## 6. Konformitäts-Verdikt: KONFORM
Alle 17 abgedeckt+variierend (N=2¹⁷) · compile+test verankert (neuer static_assert + Runtime-Count) · messdaten-erhaltend
(320-Alias+Snapshot) · TABU im GO-Fenster · [[feedback_no_whole_tier_axes_genus_configurator]] gewahrt. Einzige
Sollbruchstelle = die N-Wahl (User-Design).

## 7. Offene Entscheidungen (dem User vorgelegt)
- **[KERN] Ziel-N:** Opt 1 (2¹⁷=131.072, faithful all-vary, empfohlen) vs Opt 4 (372, alle-berührt additiv) vs Opt 3
  (2.560/5.120, kuratiert). Faithful „jede Achse variiert" = reine Kartesik erzwingt ≥2¹⁷.
- **golden-REFERENZ vs materialisierter Katalog entkoppeln** (bei 2¹⁷ nötig, sonst Compile-Explosion) — Design-Bestätigung.
- neue XML additiv vs m3v2 in-place; `COMDARE_GOLDEN_320_IDS`-Makro umbenennen; 2 Grad-Hartkodierungen synchron/entkoppelt.
- **GAP:** die 2. Variant-name() je Achse — mechanischer Lookup aus EnabledStrategies name() (vor XML-Fertigstellung).

## 8. Risiken
- 2¹⁷ echter Messlauf ~409× (>1 Jahr Dauerlauf) → gestaffelt/gesampelt, Opt-4-Sweeps für Kurvenmessung.
- `generated_source_catalog.hpp` bei 131k = GB-TU/ICE → materialisierter Katalog MUSS kleiner bleiben (entkoppeln).
- 2 unabhängige Grad-Hartkodierungen (source_catalog + axis_registry_gen) driften → synchron oder entkoppeln.
- permute_axes-Reihenfolge nicht-kanonisch → harter Codegen-Fehler; strikt kCompositionAxisNames-Reihenfolge.
- golden-Diff-Tests brechen über Positionsvergleich → Fixture-Regeneration, nicht nur Zahl-Edit.
