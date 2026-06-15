# Arbeitsergebnis Termin 8 — PRT-ART Diplomarbeit (2026-05-15)

**Stand:** 2026-05-15 (Termin 8)
**Vorgaenger:** `../20260508 Termin 7/HABICH_TERMIN7_ZUSAMMENFASSUNG_2026_05_13.md`
**Zweck:** Konkrete Resultate seit Termin 7 — was hat der Code real geleistet,
was wurde gemessen, was wurde dokumentiert.

---

## §1 Repositories und Push-Status

| Repo | Branch | HEAD | Push | letzte Aktivitaet |
|------|--------|------|------|-------------------|
| `comdare-cache-engine` | main | `16176ee` | OK | 2026-05-14 (V31.F) |
| `comdare-prt-art` | development | `1a36ab4` | OK | 2026-05-14 (V31.F Pin) |
| `Diplomarbeit/Code/` | main | `75e92d8` | OK | 2026-05-14 (Fortschrittsdoku) |

Alle 3 Repos GitHub-gepusht; cache-engine + prt-art parallele Submodules in Diplomarbeit/Code/external/ gepinnt auf 16176ee + 1a36ab4.

---

## §2 Mess-Pipeline (E2E-faehig, ohne reale Hardware)

### 2.1 Workload-Generator (V19-V20)
- **30 SOTA-Profile** (P01 ART bis P32 Schmidt) mit `<expected_workload>`-Tag
- **10 Allokator-Profile** (A01 Hoard bis A20 dlmalloc) mit Workload-Tag
- **6 YCSB-Workloads** (A bis F) implementiert
- **Total:** 30 × 10 × 6 = **1800 deklarierte Permutationen**

### 2.2 ExperimentDriver Phase 1-7 (V8.5-V11.4)
- Phase 1: enumerate (Profile-Pickup aus algorithm_profiles/)
- Phase 2: codegen (Module-Sources via generate_module_from_profile)
- Phase 3: compile (CMake Stage-1/2)
- Phase 4: load (ModuleLoader LoadLibrary/dlopen)
- Phase 5: run (Profile-aware Workload-Routing via expected_workload)
- Phase 6: measure (perf-Counter, falls aktiv)
- Phase 7: export (CSV/JSON via ResultAggregator)

### 2.3 Codegen-Templates (V17-V18)
- art_body.hpp.template (P01-ART Vorlage)
- 7 weitere Rang-1 SOTA-Templates (P02-P08)
- prtart_body.hpp.template (im prt-art Repo)
- Multi-Template-Path (cache-engine + prt-art) mit Fallback

### 2.4 Diagramm-Generator (V21.3-V22.2)
- C++ → TikZ Konvertierung mit A4-Awareness
- Bar / Scatter / Heatmap-Plots
- `plot_by_workload`-Funktion
- Sample-Mess-Daten + End-to-End-Pipeline-Test laeuft

---

## §3 Adapter-Inventar (V31.K1-K6)

### 3.1 SOTA-Adapter (12 Stueck)

| ID | Paper | Lizenz | Header | Smoke-Test |
|---|---|---|---|---|
| P01 | ART (Leis 2013) | Apache-2.0 | `UnodbDbAdapter` | gruen |
| P02 | HOT (Binna 2018) | ISC | `HotAdapter` | gruen |
| P03 | Masstree (Mao 2012) | MIT | `MasstreeAdapter` | gruen |
| P04 | CoCo-trie (Boffa 2024) | GPL-3 ⚠️ | `CocoTrieAdapter` | gruen |
| P05 | START (Fent 2020) | MIT | `StartAdapter` | gruen |
| P06 | B²-Tree (Schmeisser 2022) | NO LICENSE ⚠️ | `B2TreeAdapter` | gruen |
| P07 | Wormhole (Wu 2019) | GPL-3 ⚠️ | `WormholeAdapter` | gruen |
| P10 | SuRF (Zhang 2018) | Apache-2.0 | `SurfAdapter` | gruen |
| P20 | LeanStore (Mueller 2025) | MIT | `LeanStoreAdapter` | gruen |
| P25 | Mahling (2025) | NO LICENSE ⚠️ | `FillBufferProbe` | gruen |
| P29 | RCU (McKenney 2001) | LGPL-2.1+ ⚠️ | `LiburcuAdapter` | gruen |
| P30 | Hazard Pointers (Michael 2004) | NO LICENSE ⚠️ | `HazardPointerAdapter` | gruen |

### 3.2 Allokator-Adapter (10 Stueck)

| ID | Paper | Lizenz | Header | Smoke-Test |
|---|---|---|---|---|
| A01 | Hoard (Berger 2000) | Apache-2.0 | `HoardAdapter` | gruen |
| A03 | Michael Lock-Free (2004) | MIT | `MichaelAdapter` | gruen |
| A04 | mimalloc (Leijen 2019) | MIT | `MimallocAdapter` | gruen + Flag-Check |
| A05 | jemalloc (Evans 2006) | BSD-2 | `JemallocAdapter` | gruen |
| A06 | tcmalloc (Ghemawat 2009) | Apache-2.0 | `TcmallocAdapter` | gruen |
| A07 | snmalloc (Liétar 2019) | MIT | `SnmallocAdapter` | gruen |
| A08 | scalloc (Aigner 2015) | BSD-3 | `ScallocAdapter` | gruen |
| A10 | rpmalloc (Jansson 2017+) | PD/MIT | `RpmallocAdapter` | gruen |
| A11 | LRMalloc (Leite 2018) | MIT | `LrmallocAdapter` | gruen |
| A20 | dlmalloc (Lea 1987-) | PD | `DlmallocAdapter` | gruen |

⚠️ = unter Architekt-Direktive II 2026-05-14 freigegeben.

### 3.3 Adapter-Pattern (zentral)
```cpp
#if defined(COMDARE_HAVE_<X>)
#  include "<original>.h"
#endif

namespace comdare::adapter::<x> {
class XxxAdapter {
    bool insert(K k, V v) {
#if defined(COMDARE_HAVE_<X>)
        return original_api(k, v);
#else
        throw std::runtime_error("COMDARE_HAVE_<X> not enabled");
        // ODER: return std::malloc(size);  // bei Allokatoren
#endif
    }
    static constexpr const char* paper_id() noexcept { return "..."; }
};
}
```

---

## §4 P27 hp-soft-Integration (V31.K5)

### 4.1 Erhalten (2026-05-14)
`hp-soft.zip` (1981 B) per Mail von Boris Grot + Youhui Zhang. Inhalt:
- `hp_soft.py` (3751 B): Build-Time Call-Graph-Analyse
- `readme.txt` (436 B): Input-Spec

### 4.2 C++23-Port (`tools/p27_bundle_finder/`)
- **Library-API**: `CallGraph`, `parse_symbol_table`, `parse_disassembly`, `compute_subtree_metrics`, `find_bundle_candidates`
- **CLI-Treiber**: `main.cpp` mit objdump-Reader (regex), iterativem DFS, descending sort by footprint, threshold-Filter (default 240KB)
- **Build**: configure 4.4s + Release-Build OK (p27_bundle_finder.exe)

### 4.3 Runtime-Skelett (`prt_art/legacy_reimpl/P27-Zhang-ASPLOS-Hierarchical/`)
- `HierarchicalBundlePrefetcher` mit Bundle-Verwaltung + L1/L2/L3-Tracking
- **5 GTest-Tests gruen** (EmptyOnInit, AddAddressesToL1, AdditionalAddressOpensNewBundle, BundleLevelTracked, InvalidLevelRejected)

### 4.4 Provenance + Lizenz
- ZIP enthielt KEIN LICENSE → Architekt-Direktive II 2026-05-14: Autoren-Zitation reicht
- Autor-Hinweis: "Mehr kommt nicht" → keine Folge-Mails

---

## §5 libs/-Migration cache-engine (V30, ohne `domain/`)

### Vorher (Top-Level)
```
cache_engine/, search_engine/, experiment/, engine_choice/
```

### Nachher (libs/-konsolidiert)
```
libs/cache_engine/        (134 .hpp + 7 .cpp + 22 Builder-Subs)
libs/execution_engine/    (V30.D.1 ex-experiment/)
libs/search_engine/       (V30.D.2 ex-search_engine/, 8 INTERFACE-Subs)
libs/common/{succinct,serialization,platform,measurement,config}/
                          (config = V30.D.3 ex-engine_choice/, ALIAS comdare::common::config)
libs/test_infra/{workload_generator,test_data,benchmark_suite}/
libs/deprecated/prt_art_legacy/ (V23.E)
```

**Top-Level cache-engine:** 8 → 5 Verzeichnisse (libs/, apps/, adapters/, ext/, tools/).
**Build:** 31/31 Tests gruen pro Phase.

---

## §6 NOTICE Architekt-Direktive II (V31.A)

Neuer Abschnitt in `NOTICE` (cache-engine root):

```
ARCHITEKT-DIREKTIVE II  (2026-05-14)

  "Da wir alle Algorithmus-Bestandteile zerschneiden, entsteht fuer alle
   Permutations-Achsen ein neues Werk. ... Das gilt fuer alle Lizenztypen.
   Repos ohne Lizenztypen haben nur ein formales copyright, also muss nur
   der Autor beim zitieren genannt werden."

Konsequenz fuer ext/:
  • Original-LICENSE-Dateien bleiben bit-identisch
  • Adapter zerschneiden Code in Bausteine entlang Permutations-Achsen
  • Resultierendes Permutations-Modul = neues Werk im Forschungs-Sinne
  • Original-Werk-Zitation in NOTICE bleibt Pflicht
```

GPL-3 / LGPL / no-LICENSE-Implikationen explizit dokumentiert.

---

## §7 Test-Status (Total)

| Repo | Suite | Anzahl | Status |
|------|-------|--------|--------|
| cache-engine | Codegen + Workload + ResultAggregator + ExperimentDemo | 31 | gruen |
| cache-engine | V31 Adapter Smoke-Tests | 23 | gruen |
| cache-engine | Cache Engine Concepts (HBM, succinct, RCU, etc.) | ~15 | gruen |
| cache-engine | ModuleLoader + Permutation E2E | ~10 | gruen |
| prt-art | PrtArtSearchEngine Identity (MapApi/TupleApi/VectorApi/Status) | 66+ | gruen |
| prt-art | P27 HierarchicalBundlePrefetcher | 5 | gruen |
| prt-art | Adapter-Subklassen + ValueHandle + Memory-Layout | ~20 | gruen |
| Diplomarbeit/Code | messung_driver + diagram_generator | 13+ | konfiguriert |

**Total: ~180 Tests gruen** (cache-engine + prt-art); Diplomarbeit-ctest steht aus (User-Aufgabe).

---

## §8 thesis/main.pdf-Stand

- **24 Seiten** (war 21 zu Termin 7)
- Kapitel 01 Einleitung
- Kapitel 02 Stand der Technik (mit 30+10 Profile-Tabellen V28)
- Kapitel 03 Architektur
- Kapitel 04 Implementation (V19-V31 Sections, V31.I)
- Kapitel 05 Messverfahren
- Kapitel 06 Auswertung (Sample-Diagramm V21.4)
- Kapitel 07 Fazit
- + Literatur (33 Paper)

**pdflatex-Build:** 2× pdflatex erfolgreich, ca. 8s.

---

## §9 Doku-Stand

### docs/ (Diplomarbeit)
- `MASTERPLAN_KONSOLIDIERUNG_TERMINE.md` (NEU 2026-05-15, 10 Phasen-Plan)
- `NAMING_CONVENTIONS.md` (V12.5)
- `sessions/` mit ~80 Anker + Final-Sessions (V8 bis V31)
- `sessions/20260514-4400-v31-final-adapters-and-p27.md`
- `sessions/20260514-4500-habich-termin-8-briefing-refresh-v19-v31.md`
- `sessions/20260514-4600-fortschrittsdokumentation-v30-v31.md` (371 Zeilen)
- `termine/INDEX.md` + 8 Termin-Verzeichnisse

### Pro Repo
- `PROJECT_LAYER_MAP.md` mit V12-V31 Delta-Sektionen
- `FINDINGS_REV7_6_*.md` (Master + 2 Repos)
- `STRUCTURAL_CORRECTION_*.md` (Master + 2 Repos)
- cache-engine: `NOTICE` (Architekt-Direktive II), `LICENSE_AUDIT_EXT.md`

---

## §10 Was NICHT in V12-V31 enthalten ist (offen fuer naechsten Termin)

- HW-E2E Mess-Reihe (V21.2) — User-Aktion (reale Hardware)
- Cluster-Migration (User-Agent parallel)
- ext-Repo-Aktivierung pro Adapter (Original-Compiler-Setup, Cluster-Aufgabe)
- docs/-Konsolidierung Phasen K-B bis K-J (~11 Tage, mehrere Sessions)
- Mess-Daten-PDF mit echten Mess-Reihen
- thesis chapter 06 mit echten Daten ueber Sample hinaus

---

## §11 Querverweis

- Arbeitsplan: `Arbeitsplan_Termin8.md` (Schwester-Dokument)
- Praesentation: `Praesentation_Termin8.md` (Schwester-Dokument)
- ChatGPT-Vorab-Versuch: `_archive_chatgpt/` (3 .docx/.pptx archiviert)
- Master-Plan: `../../MASTERPLAN_KONSOLIDIERUNG_TERMINE.md`
- Fortschrittsdokumentation: `../../sessions/20260514-4600-fortschrittsdokumentation-v30-v31.md`
- Termin-7-Stand: `../20260508 Termin 7/HABICH_TERMIN7_ZUSAMMENFASSUNG_2026_05_13.md`
