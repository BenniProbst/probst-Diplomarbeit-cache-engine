# Cluster E — Prefetching 2 + Telemetry

**Stand:** 2026-05-15 (K-F.7)
**Quelle:** `../termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions/cluster_E_prefetching_telemetry.md` (682 Z)
**Inhalt:** 5 Prefetching+Telemetry-Paper P24, P25, P26, P27, P28

---

## §1 Cluster-Mitglieder

| P-ID | Paper | Autoren / Jahr / Venue | V31-Adapter |
|---|---|---|---|
| **P24** | Useless Prefetch Study | Naderan-Tahan/Sarbazi-Azad (2016) | LEGACY_REIMPL |
| **P25** | Fetch Me If You Can | Mahling/Weisgut/Rabl (2025, DaMoN) | `comdare::adapter::p25_mahling::FillBufferProbe` ✅ no-LICENSE ⚠️ |
| **P26** | A prefetching indexing scheme | Q. Zhang et al. (2024, FGCS) | LEGACY_REIMPL |
| **P27** | Hierarchical Prefetching | T. Zhang et al. (2025, ASPLOS) | **tools/p27_bundle_finder/** (V31.K5) + **prt-art/legacy_reimpl/P27-*/** (V31.K6) |
| **P28** | Towards Data-Based Cache Optimization | Kuehn et al. (2023, DaMoN) | (Kuehn-Erkenntnisse in Begriffsglossar v7 + Bausteine Achse 11) |

---

## §2 Cluster-Kernkonzepte

### 2.1 Telemetry-Erfassung

**P28 Kuehn** ist die Schluessel-Quelle fuer **Achse 11 TELEMETRY-COLLECTION-STRATEGY** (NEU 2026-05-09):

| Telemetrie-Strategie | Eingefuehrt durch | Glossar v7 BLOCK |
|---|---|---|
| Per-Knoten Counter (klassisch, publiziert) | P28 Kuehn DAMON 2023 | AI (Cache-Coherence-Anti-Pattern) |
| LeafOnly-Counter (Kuehn NEU 2026-05-08 Mailverlauf) | P28 Kuehn 2026-05-08 | AJ |
| LeafOnly-Sampled-Counter<N> | P28 Kuehn NEU | AL |
| RetroactiveAggregation | P28 Kuehn NEU | AK |
| Path-Read-Counter | P26 Zhang FGCS 2024 | (in Bausteine Achse 11) |
| Probability-Hints-Header | P16 Bender (siehe Cluster C) | (in Bausteine Achse 11) |

### 2.2 Cache-Coherence-Anti-Pattern (P28 + v7)

P28 Kuehn 2026-05-08 Mailverlauf identifizierte das Cache-Kohaerenz-Ping-Pong-Problem fuer Per-Knoten-Telemetrie auf Multi-Core. Loesung: LeafOnly-Counter (untere Baum-Ebenen haben weniger Multi-Thread-Konkurrenz).

**Konsequenz fuer V31:** Cache-Coherence-Cost als Cost-Funktion in ConcurrencyManager (siehe Bausteine Achse 8 Ergaenzung).

### 2.3 P25 Fill Buffer

P25 Mahling 2025 DaMoN: Fill-Buffer-Occupancy-Studie. **Fetch Me If You Can** — Cache-Prefetching-Reliability auf High-Latency-Memory.

Direkter Bezug zu V31-Adapter: `comdare::adapter::p25_mahling::FillBufferProbe`.

### 2.4 P27 Hierarchical Prefetching + hp-soft.zip Mail-Antwort

**P27 Zhang ASPLOS 2025** — Boris Grot + Youhui Zhang lieferten 2026-05-14 die Mail-Antwort:

| Datei | Bytes | Inhalt |
|---|---|---|
| `hp-soft.zip/hp_soft.py` | 3751 | Build-Time Call-Graph-Analyse via objdump |
| `hp-soft.zip/readme.txt` | 436 | Input-Spec |

**V31 Integration:**
- C++23-Port: `comdare-cache-engine/tools/p27_bundle_finder/` (Library + CLI)
- Runtime-Skelett: `comdare-prt-art/prt_art/legacy_reimpl/P27-Zhang-ASPLOS-Hierarchical/HierarchicalBundlePrefetcher` (5 Tests gruen)

**User-Hinweis (Memory):** "Mehr kommt nicht" — keine Folge-Mails an Zhang/Grot.

### 2.5 P24 Useless Prefetch

P24 Naderan-Tahan 2016 — Untersuchung wann Prefetching mehr schadet als hilft. Sicht in DecisionLambdaTree-Strategien.

### 2.6 P26 Read Counter + Frequent Access Paths

P26 Zhang FGCS 2024 — "blocks tagged with read counters; blocks with high read counters form frequent access paths". 3 Prefetcher-Komponenten:
- CP (Counter-Prefetcher)
- PP (Path-Prefetcher)
- MP (Memory-Prefetcher)

(Hybrid → atomare Commands, siehe REV5 K3.4)

---

## §3 Vollangaben (siehe Original)

Detail-Konzept-Extraktionen pro Paper:
`../termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions/cluster_E_prefetching_telemetry.md`

---

## §4 Bausteine-Matrix-Mapping (Achse 7 Prefetch + Achse 11 Telemetry)

| Bausteine-ID | Achse | Paper |
|---|---|---|
| `PREFETCH_FILL_BUFFER_AWARE` | 7 | P25 |
| `PREFETCH_HOT_PATH` | 7 | P26 |
| `PREFETCH_HIERARCHICAL_BUNDLE` | 7 | P27 |
| `TELEMETRY_PER_NODE_COUNTER` | 11 | P28 (klassisch publiziert; ⚠️ Cache-Coherence-Anti-Pattern) |
| `TELEMETRY_LEAFONLY_COUNTER` | 11 | P28 Kuehn NEU 2026-05-08 |
| `TELEMETRY_LEAFONLY_SAMPLED_COUNTER` | 11 | P28 Kuehn NEU 2026-05-08 |
| `TELEMETRY_RETROACTIVE_AGGREGATION` | 11 | P28 Kuehn NEU 2026-05-08 |
| `TELEMETRY_PATH_READ_COUNTER` | 11 | P26 |
| `TELEMETRY_PROBABILITY_HINTS_HEADER` | 11 | P16 (Cluster C) |

---

## §5 V31-Code-Stand fuer Cluster E

| Komponente | Pfad |
|---|---|
| P25 Adapter | `comdare-cache-engine/adapters/P25-Mahling/p25_mahling_adapter.hpp` |
| P27 Bundle Finder Tool | `comdare-cache-engine/tools/p27_bundle_finder/` (Library + CLI) |
| P27 Runtime Skelett | `comdare-prt-art/prt_art/legacy_reimpl/P27-Zhang-ASPLOS-Hierarchical/HierarchicalBundlePrefetcher.hpp` |
| P27 Tests | `comdare-prt-art/prt_art/tests/test_legacy_p27_zhang_asplos.cpp` (5 Tests gruen) |
| P28 Kuehn-Erkenntnisse v7 Glossar | `../glossar/01_begriffsglossar_v7_master.md` §7 (BLOCK AI bis AP) |

---

## §6 Querverweise

- Original-Quelle (UNVERAENDERT): `../termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions/cluster_E_prefetching_telemetry.md`
- Cluster D (Prefetching 1): `05_cluster_D_prefetching_1.md`
- Cluster F (Sync + TUD-Habich): `07_cluster_F_sync_tud_habich.md`
- Quellen-Gesamtkatalog: `01_quellen_gesamtkatalog.md` §2 B
- Bausteine-Matrix: `../bausteine/01_bausteine_matrix.md` §9+§13 (Prefetch + Telemetry)
- Begriffsglossar v7 Master: `../glossar/01_begriffsglossar_v7_master.md` §7 (Kuehn-Erkenntnisse BLOCK AI-AP)
- Memory-Direktive P27: `~/.claude/.../memory/reference_p27_zhang_no_more_input.md`
- Kuehn-Erkenntnisse-Originaldatei: `../termine/20260508 Termin 7/Kuehn_Erkenntnisse_Einarbeitung_2026_05_09.txt`
- hp-soft Provenance: `../../Forschungsarbeiten/code/P27-Zhang-ASPLOS-Hierarchical/STATUS.md`
