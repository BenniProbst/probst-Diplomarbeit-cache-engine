# PROJECT_LAYER_MAP — Diplomarbeit (2026-05-13)

Strategische Strukturübersicht für **manuelles Code-Review**.
Dieses Repo enthält die wissenschaftliche Dokumentation; die Code-Repos
`comdare-cache-engine` und `comdare-prt-art` sind separat.

---

## 0. Repo-Rolle

`probst-Diplomarbeit-cache-engine` ist das **Wissenschafts-Repo** der
Diplomarbeit am Lehrstuhl Habich, TU Dresden. Es enthält:

- Recherche (33 Such-Paper P01–P33, 21 Allokator-Paper A01–A23)
- Architektur-Skizzen (REV 1 bis REV 7.5)
- Termin-Protokolle (Termin 1–7)
- Begriffsglossar (v1–v5)
- Habich-Sprechstunden-Protokolle
- Email-Korrespondenz mit Paper-Autoren
- Datasets-Spezifikationen
- LaTeX-Anhang-Outputs

Das Repo führt **keinen Code** aus, ist aber die **Konzept-Quelle** für
beide Code-Repos.

---

## 1. Top-Level-Hierarchie (chronologisch nach Phasen)

```
Diplomarbeit/
├─ Phase 1: Recherche
│   ├─ Forschungsarbeiten/   (33 Original-PDFs + Volltexte)
│   ├─ Allokator_Recherche/  (21 Allokator-PDFs + Volltexte)
│   └─ Begriffsglossar_v*.md (Domänen-Identitäten)
│
├─ Phase 2: Tieflektüre
│   └─ Phase3_Tieflektuere/    (Cluster A–F, Konsolidierung G+H)
│
├─ Phase 3: Domänenmodell + Bausteine-Matrix
│   ├─ Bausteine_Matrix.txt
│   ├─ Allokator_Matrix.txt
│   ├─ Domaenenmodell_v3.md
│   └─ Flag_System.txt
│
├─ Phase 4: Setup + Code-Strukturierung
│   ├─ STATUS_PROJEKT.md
│   ├─ ADR_Beschluesse_F*.md
│   └─ Lizenz_Analyse_v2.md
│
├─ Phase 5: UML + Architektur
│   └─ 20260508 Termin 7/Phase5_UML_Detail/
│      ├─ 11..23_*.md          (REV 3 bis REV 6)
│      ├─ 24_architektur_skizze_REV7_2026_05_13.md
│      ├─ 25_…hybrid_search_engine_…md         NEU heute
│      ├─ 26_…legacy_reimpl_…md                NEU heute
│      ├─ 27_…ycsb_cli_…md                     NEU heute
│      ├─ 28_…cmake_pipeline_…md               NEU heute
│      ├─ 29_…phase4_7_loader_…md              NEU heute
│      └─ phase5_uml_detail_REV6.drawio
│
├─ Phase 6: Code-Setup (REV 6/7 INK-1..INK-8 + 12 Sub-Engines)
│
├─ Phase 7: Permutations-Builder + Experiment-Loop
│
├─ Termin 1..7/  (Habich-Sprechstunden-Protokolle)
│   ├─ Termin 1 — Erster Termin Notizen.md
│   ├─ Termin 2 — *
│   ├─ ...
│   └─ 20260508 Termin 7/        (8. Mai, langer Terminanlass)
│       ├─ Termin 7 — Habich-Sprechstunde.md
│       ├─ Termin 7 — H1/H2/H3/H4 Direktiven.md
│       ├─ Phase5_UML_Detail/    (s.o.)
│       ├─ Bausteine_Matrix.txt
│       └─ NOTES.md
│
└─ EMAIL_KONTAKTE.md            (P26/P27 Zhang, P06, P28 Kuehn, P31-P33 Habich)
```

---

## 2. Lese-Reihenfolge (empfohlen für strategisches Gegenlesen)

### Variante A: "Erstes Mal in die Diplomarbeit eintauchen"

| # | Dokument | Zweck |
|---|---|---|
| 1 | `20260508 Termin 7/Termin 7 — Habich-Sprechstunde.md` | Aktueller Stand des Projekts mit Habich |
| 2 | `20260508 Termin 7/Phase5_UML_Detail/24_architektur_skizze_REV7_2026_05_13.md` | **Master-Architektur-Doku** mit 23 Allokator-Achsen + 3-Schichten-Hierarchie |
| 3 | `Domaenenmodell_v3.md` | High-level Konzept (Such-Algorithmen vs. Cache-Engine) |
| 4 | `Begriffsglossar_v5.md` | Vokabular vor Tieflektüre |
| 5 | `Bausteine_Matrix.txt` | Was wird wo verwendet (P01..P33 ↔ Code-Adapter) |
| 6 | Termin-Protokolle 1–6 chronologisch | Entwicklung der Konzepte |

### Variante B: "Heutigen Sprint nachvollziehen"

| # | Dokument | Inhalt |
|---|---|---|
| 1 | `25_architektur_delta_hybrid_search_engine_2026_05_13.md` | **REV 7.1** — Hybride PrtArtSearchEngine (Vector-/Map-/Tuple-API + errno-style) |
| 2 | `26_architektur_delta_legacy_reimpl_2026_05_13.md` | **REV 7.2** — 14 LEGACY_REIMPL Skelette ausgefüllt |
| 3 | `27_architektur_delta_ycsb_cli_2026_05_13.md` | **REV 7.3** — YCSB-Generator-CLI als Datasets-Tool |
| 4 | `28_architektur_delta_cmake_pipeline_2026_05_13.md` | **REV 7.4** — echte cmake-Pipeline (54 DLLs gebaut) |
| 5 | `29_architektur_delta_phase4_7_loader_2026_05_13.md` | **REV 7.5** — Phase 4-7 Loader + RunWorkload + Aggregator |

### Variante C: "Paper-Tieflektüre nachvollziehen"

| Cluster | Doc-Pfad | Paper |
|---|---|---|
| A — Trie | `Phase3_Tieflektuere/Cluster_A_Trie.md` | P01, P02, P04, P05, P09, P10 |
| B — Hybrid + B+ | `Phase3_Tieflektuere/Cluster_B_Hybrid_BPlus.md` | P03, P06, P07, P11, P12, P13 |
| C — Layout | `Phase3_Tieflektuere/Cluster_C_Layout.md` | P14, P15, P16, P17, P18, P19 |
| D — Prefetch 1 | `Phase3_Tieflektuere/Cluster_D_Prefetch1.md` | P20, P21, P22, P23 |
| E — Prefetch 2 + Telemetry | `Phase3_Tieflektuere/Cluster_E_Prefetch2.md` | P24, P25, P26, P27, P28 |
| F — Sync + TUD-Habich | `Phase3_Tieflektuere/Cluster_F_Sync_TUD.md` | P08, P29, P30, P31, P32, P33 |
| Konsolidierung G | `Phase3_Tieflektuere/Konsolidierung_G_Cache_Strategien.md` | Cache-Strategien-Taxonomie |
| Konsolidierung H | `Phase3_Tieflektuere/Konsolidierung_H_Algorithmus_Strategien.md` | Iterator-Inventar |

---

## 3. Cross-Projekt-Referenzen (in Doc-Texten)

Die Diplomarbeit referenziert **beide Code-Repos** in folgenden Mustern:

### `comdare-cache-engine/...` Pfade

Sind in Architektur-Skizzen REV 6/7 als konkrete Code-Pfade angegeben.
Beispiele in `24_architektur_skizze_REV7_2026_05_13.md`:
- `cache_engine/include/cache_engine/abi/module_abi_v1.hpp`
- `cache_engine/builder/main.cpp` (Phase 1–7)
- `cache_engine/include/cache_engine/allocators/families/aXX_*/`

### `prt_art/include/prt_art/...` Pfade

Sind in REV 6 §5.17 als PRT-ART-Bausteine spezifiziert.
Beispiele:
- `prt_art/identity/prt_art_search_engine.hpp` (heute hybride API)
- `prt_art/allocator/pool_set.hpp` (4+2 Pools)
- `prt_art/concurrency/olc_with_reserved_blocks.hpp`

### Paper-IDs

Konsistente Naming-Convention:
- **P01..P33** — 33 Such-Algorithmus-Paper (Phase 3.B)
- **A01..A23** — 23 Allokator-Paper (Phase 6.2.B)

Bei externer Kommunikation (Habich, Email-Autoren) NIEMALS P-IDs benutzen,
immer vollständige Bibliografie (siehe `EMAIL_KONTAKTE.md`).

---

## 4. Habich-Direktiven (Hierarchie)

Habich hat im Lauf der Sprechstunden folgende H-Direktiven gegeben:

| ID | Kurzbeschreibung | Status |
|---|---|---|
| **H1** | nur 1 Hauptcompiler (C++23) — andere optional | umgesetzt |
| **H2** | Code-Qualitäts-Bewertung pro Bausteine-Quelle | **HEUTE FERTIG** — `docs/quality_audit/HABICH_H2_CODE_QUALITY_2026_05_13.md` in cache-engine |
| **H3** | LaTeX-Toolchain mit dynamischer Diagramm-Compile | **HEUTE FERTIG** — `tools/latex_toolchain/` in cache-engine |
| **H4** | Repo-Separation + GitHub-Push | **HEUTE FERTIG** — 3 Repos gepusht (today) |
| H5 | Habich-Sprechstunde-Protokoll-Format | umgesetzt |
| H6 | NO Python in Build-Pipeline | F-EXTRA-5 KORREKTUR |

---

## 5. Heutige Änderungen (zum priorisierten Review)

Nur **5 neue Dokumente** + IDE-Config:

| Datei | Wichtigkeit | Inhalt |
|---|---|---|
| `25_..._hybrid_search_engine_2026_05_13.md` | **HOCH** | REV 7.1 Architektur-Korrektur: Hybride Klasse |
| `26_..._legacy_reimpl_2026_05_13.md` | MITTEL | REV 7.2 14 LEGACY_REIMPL ausgefüllt |
| `27_..._ycsb_cli_2026_05_13.md` | MITTEL | REV 7.3 YCSB-CLI |
| `28_..._cmake_pipeline_2026_05_13.md` | **HOCH** | REV 7.4 cmake-Pipeline + 54 DLLs |
| `29_..._phase4_7_loader_2026_05_13.md` | **HOCH** | REV 7.5 Phase 4-7 voll funktional |
| `.idea/` | NIEDRIG | IntelliJ/CLion-Config |

**Review-Schwerpunkt:** REV 7.1 (User-Direktive zur hybriden Klasse) und REV 7.5
(End-to-End-Pipeline-Verifikation).

---

## 6. Termin-7-Struktur (8. Mai 2026 — der große Anlass)

`20260508 Termin 7/` ist der wichtigste Sub-Tree:

```
20260508 Termin 7/
├── Termin 7 — Habich-Sprechstunde.md       (Protokoll)
├── Termin 7 — H1/H2/H3/H4 Direktiven.md   (4 H-Direktiven aus Habich)
├── Bausteine_Matrix.txt                     (P01..P33 ↔ Code-Adapter)
├── Allokator_Matrix.txt                    (A01..A23 ↔ Code-Adapter)
├── NOTES.md
├── _archive_code_pre_migration/            (lokal nur, ignored)
└── Phase5_UML_Detail/
    ├── 00..10_*.md   (Vor-Vorbereitung)
    ├── 11..13_*.md   (Domänenmodell + Cache-Strategien)
    ├── 14..19_*.md   (Allokator-Recherche)
    ├── 20_architektur_skizze_REV3_2026_05_10.md
    ├── 21_architektur_skizze_REV4_2026_05_10.md
    ├── 22_architektur_skizze_REV5_2026_05_11.md
    ├── 23_architektur_skizze_REV6_2026_05_11.md
    ├── 24_architektur_skizze_REV7_2026_05_13.md      ← MASTER
    ├── 25..29_*.md   ← NEU heute (Delta REV 7.1..7.5)
    └── phase5_uml_detail_REV{3..6}.drawio
```

**Master-Architektur:** `24_…REV7_2026_05_13.md` (872 Zeilen) — bei
Tiefes Verständnis Pflicht.

---

## 7. Strategie für vollständiges Gegenlesen

### Tag 1 (Architektur, Konzept)
- `20260508 Termin 7/Phase5_UML_Detail/24_architektur_skizze_REV7_2026_05_13.md`
- Begriffsglossar
- Domänenmodell v3
- Bausteine_Matrix + Allokator_Matrix

### Tag 2 (Heutige Updates)
- 5 neue Delta-Docs (25–29) in Reihenfolge

### Tag 3 (Code-Review: cache-engine)
- `comdare-cache-engine/PROJECT_LAYER_MAP.md` zuerst
- `cache_engine/include/cache_engine/abi/module_abi_v1.hpp` (zentral)
- `cache_engine/builder/main.cpp` (heutige Phase 4-7)
- `cache_engine/builder/codegen/codegen.cpp` (heutige Aggregator)
- `cache_engine/builder/module_loader/{hpp,cpp}` (heute NEU)

### Tag 4 (Code-Review: prt-art)
- `comdare-prt-art/PROJECT_LAYER_MAP.md` zuerst
- `prt_art/include/prt_art/identity/prt_art_search_engine.hpp` (heutige hybride API)
- 51 neue Tests in `tests/unit/test_prt_art_identity.cpp`

### Tag 5 (Tools + LEGACY_REIMPL + Stand der Technik)
- `cache-engine/tools/{ycsb_cli,latex_anhang,latex_toolchain}/`
- 14 LEGACY_REIMPL Skelette (P11–P27) — je 1 Header
- `docs/quality_audit/HABICH_H2_CODE_QUALITY_2026_05_13.md`

---

## 8. Querverweis zu Code-Repos

```
comdare-cache-engine  →  github.com/BenniProbst/comdare-cache-engine
                          letzter Commit: a8f12cf (heute, main)

comdare-prt-art        →  github.com/BenniProbst/comdare-prt-art
                          letzter Commit: a7d86c7 (heute, development)

Diplomarbeit (this)    →  github.com/BenniProbst/probst-Diplomarbeit-cache-engine
                          letzter Commit: c6523db (heute, main)
```

Die `PROJECT_LAYER_MAP.md` von **jedem** der drei Repos ist die Ausgangs-
basis für das systematische Review.

---

## 9. Bekannte offene Items (Phase 8+)

1. **#74 Email-Antworten warten** (P06, P28, P31, P32, P33 von Habich)
2. **#77 Cluster-Migration** (Fortigate-31G + COMDARE-Modules-GitLab-Push)
3. **#88 ↔ LaTeX-Anhang-Tool** in cache-engine ist gebaut, aber das echte
   Diplomarbeits-LaTeX-Manuskript existiert noch nicht in diesem Repo
4. **Habich-Termine 8+ folgen** — nächste Sprechstunde-Protokolle
5. **Diplomarbeits-Manuskript (`*.tex`)** muss noch geschrieben werden;
   `tools/latex_toolchain` von cache-engine ist bereit es zu kompilieren
