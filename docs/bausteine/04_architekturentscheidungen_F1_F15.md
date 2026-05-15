# Architekturentscheidungen F1-F15 + F-EXTRA-1 bis F-EXTRA-8 — Master (ADR-Stil)

**Stand:** 2026-05-15 (K-E.5)
**Quelle:** `../termine/20260508 Termin 7/Architekturentscheidungen_F1_F15.txt` (975 Zeilen)
**Format:** ADR-Stil (Architecture Decision Records)
**Beschluss-Datum:** 2026-05-04 durch den Architekten (Nutzer)

---

## §1 Uebersicht aller 25 Entscheidungen

| ID | Titel | Status | Quelle (Z) |
|---|---|---|---|
| **F1** | CacheEngineRuntime-Singleton-Implementierung | DONE (heap-allokierter Singleton mit std::unique_ptr + COMDARE_EXPERIMENT_MODE Flag) | 27 |
| **F2** | Observer-Mechanik | DONE (synchroner Push + Command-Pattern Lambda-Entscheidungs-baeume mit DELAY/EXECUTE/SKIP) | 59 |
| **F3** | Visitor-Granularitaet | DONE (Mid-Granularitaet) | 116 |
| **F4** | Permutationsraum | DONE (vollstaendig + Bit-Maskierung als Filter) | 129 |
| **F5** | Measurement-Persistierung | DONE (In-Memory MeasurementBuffer, KEINE externe Datenbank) | 152 |
| **F6** | ConcurrencyManager-Komposition | DONE (Klassen + Policy-Template) | 188 |
| **F7** | Adapter-Strategie fuer Originalcode | DONE (Adapter-Pattern, Habich-Direktive) | 203 |
| **F8** | ValueHandle-`switch_array` Repraesentation | DONE (std::variant + Concept-Constraint) | 239 |
| **F9** | ABI-Stabilitaet via C++23-Modules | DONE (ABI-Stabiles C++23-Modul + ModuleLoader) | 254 |
| **F10** | Codegen-Strategie im CacheEngineBuilder | DONE (CMake-Skript, pre-built) — KORRIGIERT durch F10-K | 285 |
| **F11** | Mikrobenchmark-Triggering | DONE (Sampled 1:N als Default; trigger-on-demand) | 329 |
| **F12** | CacheEngine-Lebens-Lokation | DONE (im CacheEngineBuilder, KEIN separater Singleton) — KORRIGIERT durch F12-K | 343 |
| **F13** | Cross-Compilation-Toolchain | DONE (Compile-Time vs Runtime SIMD-Detection gegenseitig ausschliessend; ZIH Runtime, sonst Compile-Time) | 403 |
| **F14** | Datasets-Akquise | DONE (Pflicht-Korpus + Custom-Datasets via F-EXTRA-2) | 436 |
| **F15** | Vergleichsbasis + Bausteine-Quer-Permutation | DONE (zentrales Forschungs-Prinzip; Bausteine_Matrix; Universal-Vergleich) | 459 |
| **F10-K** | Korrektur des Permutations-Identifikator-Schemas | DONE (Flag-System statt perm_id, Intel-CPUID-aehnliches Schema) | 552 |
| **F12-K** | Korrektur der CacheEngine-Lokation | DONE (CacheEngine ist trotzdem Heap-Singleton, lebt IM Builder-Prozess als globale Variable) | 643 |
| **F-EXTRA-1** | Original-Compiler-Versionen pro Algorithmus | DONE (pro ext-Repo eigene Compiler-Toolchain registriert; Hauptcompiler vs Original-Compiler Layering) | 694 |
| **F-EXTRA-2** | Custom-Datasets | DONE (zusaetzlich zu Pflicht-Korpus) | 731 |
| **F-EXTRA-3** | SOCKS5-ZIH-Lieferung + Architektur-Erweiterung | DONE (SOCKS5-Lieferung als Default fuer ZIH-Cluster) | 758 |
| **F-EXTRA-4** | Self-Built Compiler auf Pi 5 + VisionFive 2 | DONE (Cross-Build-Pfad fuer Exotik-Plattformen) | 785 |
| **F-EXTRA-5** | `build_permutations.cmake` Konkretisierung | DONE (KEIN Python — nur CMake/sh/bat) | 795 |
| **F-EXTRA-6** | DecisionLambdaTree-Format (KORRIGIERT) | DONE (pro Baustein eigener Tree, statt zentral) | 831 |
| **F-EXTRA-7** | Mess-Kategorien × Algorithmus-Details Vollstaendigkeits-Matrix | DONE (Default-Mess-Hooks pro Algorithmus-Detail + Algo-spezifischer Override) | 875 |
| **F-EXTRA-8** | ABI-Stabilitaets-Test + Google Tests | DONE (CI-pruefung + generische + spezifische GTests) | 894 |

---

## §2 ADR-Stil pro Entscheidung

Jede Entscheidung folgt diesem Pattern (siehe Original-Datei fuer Voll-Inhalt):

```
F<n> — <TITEL>
  ENTSCHEIDUNG (X)  — Was beschlossen wurde (kanonisch, verbindlich)
  PRAEZISIERUNG     — Architektonische Verfeinerung des Architekten
  FOLGEN            — Auswirkung auf Architektur/Implementation
  QUELLE            — Wo es im Domaenenmodell v3 vertieft wird
```

---

## §3 F1-F15 Voll-Detail (Verweis auf Original)

### F1 — CacheEngineRuntime-Singleton-Implementierung
**Ort:** Architekturentscheidungen_F1_F15.txt:27-58
**Beschluss:** Heap-allokierter Singleton mit `std::unique_ptr` + COMDARE_EXPERIMENT_MODE-Flag.
**V31 Code:** `cache-engine/libs/cache_engine/builder/experiment_driver/`

### F2 — Observer-Mechanik
**Ort:** Z 59-115
**Beschluss:** Synchroner Push + Command-Pattern Lambda-Entscheidungs-Baeume (DELAY/EXECUTE/SKIP).
**Forschungs-Belege:** P02 Konsolidierung, P03 Permutation Field, P05 Rewiring, P08 OLC, P18 Multi-Level Reloc, P28 Histogram, P29 RCU.
**V31 Code:** `prt-art/prt_art/legacy_reimpl/...notify_*-Methoden`

### F3 — Visitor-Granularitaet
**Ort:** Z 116-128
**Beschluss:** Mid-Granularitaet (zwischen Coarse Top-Level und Fine Per-Operation).

### F4 — Permutationsraum
**Ort:** Z 129-151
**Beschluss:** Vollstaendiger Permutationsraum, ConstraintFilter via Bit-Maskierung in CMake compile-time.

### F5 — Measurement-Persistierung
**Ort:** Z 152-187
**Beschluss:** In-Memory MeasurementBuffer; KEINE externe Datenbank.
**V31 Code:** `cache-engine/libs/cache_engine/measurement/InMemoryMeasurementBuffer`

### F6 — ConcurrencyManager-Komposition
**Ort:** Z 188-202
**Beschluss:** Klassen + Policy-Template fuer Concurrency-Composition.

### F7 — Adapter-Strategie fuer Originalcode (HABICH-DIREKTIVE)
**Ort:** Z 203-238
**Beschluss:** Adapter-Pattern. Originalcode bleibt bit-identisch in `ext/`, Adapter wrappen mit C++23-Concepts.
**V31 Code:** 22 Adapter in `cache-engine/adapters/{P,A}*/`

### F8 — ValueHandle-switch_array Repraesentation
**Ort:** Z 239-253
**Beschluss:** `std::variant` + Concept-Constraint.
**V31 Code:** `prt-art/prt_art/identity/value_handle.hpp`

### F9 — ABI-Stabilitaet via C++23-Modules
**Ort:** Z 254-284
**Beschluss:** ABI-Stabiles C++23-Modul + ModuleLoader (LoadLibrary/dlopen).
**V31 Code:** `cache-engine/libs/cache_engine/builder/module_loader/`

### F10 — Codegen-Strategie im CacheEngineBuilder
**Ort:** Z 285-328
**Beschluss:** CMake-Skript pre-built; per Compile-Time-Permutation eine .dll/.so erzeugen.
**KORREKTUR:** F10-K (Flag-System).
**V31 Code:** `cache-engine/libs/cache_engine/builder/codegen/`

### F11 — Mikrobenchmark-Triggering
**Ort:** Z 329-342
**Beschluss:** Sampled 1:N als Default (jeder N-te Zugriff zaehlt).

### F12 — CacheEngine-Lebens-Lokation (KOMPLETT NEU)
**Ort:** Z 343-402
**Beschluss:** CacheEngine lebt IM CacheEngineBuilder (kein separates globales Singleton-Heap-Modul). Wird zwischen Modul-Experimenten zurueckgesetzt.
**KORREKTUR:** F12-K (Heap-Singleton-Klarstellung).

### F13 — Cross-Compilation-Toolchain
**Ort:** Z 403-435
**Beschluss:** Compile-Time vs Runtime SIMD-Detection gegenseitig ausschliessend. ZIH-Cluster nutzt Runtime, sonst Compile-Time.

### F14 — Datasets-Akquise
**Ort:** Z 436-458
**Beschluss:** Pflicht-Korpus (YCSB Workloads A-F) + Custom-Datasets via F-EXTRA-2.

### F15 — Vergleichsbasis + Bausteine-Quer-Permutation (ZENTRALES FORSCHUNGS-PRINZIP)
**Ort:** Z 459-551
**Beschluss:** Bausteine-Quer-Permutation als zentrales Forschungs-Prinzip. Algorithmen werden in austauschbare Bausteine zerlegt; uniformer Vergleich unter heuristischer und informierter Engine-Variante.
**V31 Code:** Bausteine-Matrix mit 11 Achsen (siehe `01_bausteine_matrix.md`).

---

## §4 Korrekturen K (2026-05-04)

### F10-K — Korrektur des Permutations-Identifikator-Schemas
**Ort:** Z 552-642
**Korrektur:** Statt fortlaufender perm_id ein Flag-System (Intel-CPUID-aehnliches Schema):
- Pro Permutations-Achse eine Bit-Bank
- Flag-Bank-Bit-Konfiguration ist die Permutation-ID
- Gut sortierbare Wohl-Ordnung
- ConstraintFilter als einfache Bit-Maskierung

**Folge:** `Flag_System.txt` als Referenz-Dokument (siehe `05_flag_system.md`).

### F12-K — Korrektur der CacheEngine-Lokation
**Ort:** Z 643-693
**Korrektur:** CacheEngine ist trotzdem Heap-Singleton, lebt IM Builder-Prozess als globale Variable; wird Modulen als Ressource bereitgestellt (statt separater Heap-Singleton-Modul).

---

## §5 F-EXTRA-Beschluesse (8 nachgelagerte Detail-Entscheidungen)

### F-EXTRA-1 — Original-Compiler-Versionen pro Algorithmus
**Ort:** Z 694-730
**Beschluss:** Pro ext-Repo eigene Compiler-Toolchain registriert. Hauptcompiler (C++23 fuer Adapter) vs Original-Compiler (fuer Bausteine-Quellcode) Layering.
**V31 Status:** Adapter-Skelette mit COMDARE_HAVE_<X>-Flag, ext-Repo-Aktivierung pro Repo (Cluster-Aufgabe).

### F-EXTRA-2 — Custom-Datasets
**Ort:** Z 731-757
**Beschluss:** Zusaetzlich zu Pflicht-Korpus auch Custom-Datasets fuer spezielle Mess-Reihen.

### F-EXTRA-3 — SOCKS5-ZIH-Lieferung + Architektur-Erweiterung
**Ort:** Z 758-784
**Beschluss:** SOCKS5-Lieferung als Default fuer ZIH-Cluster.

### F-EXTRA-4 — Self-Built Compiler auf Pi 5 + VisionFive 2
**Ort:** Z 785-794
**Beschluss:** Cross-Build-Pfad fuer Exotik-Plattformen (ARM, RISC-V).

### F-EXTRA-5 — `build_permutations.cmake` Konkretisierung
**Ort:** Z 795-830
**Beschluss:** **KEIN Python** im PRT-ART-Build — nur CMake-Funktionen + sh/bat (Memory-Direktive `feedback_no_python_in_buildchain`).
**V31 Status:** alle Codegen + Orchestrator in CMake/sh/bat.

### F-EXTRA-6 — DecisionLambdaTree-Format (KORRIGIERT)
**Ort:** Z 831-874
**Korrektur:** Pro Baustein eigener DecisionLambdaTree, statt zentralem Tree.
**V31 Status:** Domaenenmodell v4 D-2.

### F-EXTRA-7 — Mess-Kategorien × Algorithmus-Details Vollstaendigkeits-Matrix
**Ort:** Z 875-893
**Beschluss:** Default-Mess-Hooks pro Algorithmus-Detail + Algo-spezifischer Override.
**V31 Code:** `cache-engine/libs/cache_engine/measurement/Measure-Matrix`.

### F-EXTRA-8 — ABI-Stabilitaets-Test + Google Tests
**Ort:** Z 894-(Ende)
**Beschluss:** CI-Pruefung der ABI-Stabilitaet + generische GTests (CacheEngineBuilder) + spezifische GTests (pro Modul).
**V31 Status:** GitLab-CI + GitHub-Actions in alle 3 Repos (V11.7); 23/23 V31-Adapter-Smoke-Tests gruen.

---

## §6 Status-Zusammenfassung (V31 Stand 2026-05-15)

| Kategorie | Anzahl | DONE | OPEN |
|---|---|---|---|
| F1-F15 (Initialbeschluesse) | 15 | 15 | 0 |
| Korrekturen K | 2 | 2 | 0 |
| F-EXTRA | 8 | 8 | 0 |
| **Total** | **25** | **25** | **0** |

Alle Architekturentscheidungen sind in V31 (2026-05-14) implementiert oder durch Code-Skelette vorbereitet. ext-Repo-Aktivierung pro Adapter (F-EXTRA-1) ist die einzige Restaufgabe (Cluster-Migration).

---

## §7 Querverweise

- Original-Quelle (UNVERAENDERT): `../termine/20260508 Termin 7/Architekturentscheidungen_F1_F15.txt`
- Bausteine-Matrix (F15-Operationalisierung): `01_bausteine_matrix.md` (K-E.2)
- Allokator-Matrix: `02_allokator_matrix.md` (K-E.3)
- Flag-System (F10-K): `05_flag_system.md` (K-E.6)
- Domaenenmodell v4 (mit allen Korrekturen eingearbeitet): `../glossar/02_domaenenmodell_v4_master.md`
- Begriffsglossar v6 (F-EXTRA-Begriffe): `../glossar/01_begriffsglossar_v7_master.md` §6
- Memory-Direktive `feedback_no_python_in_buildchain`: `~/.claude/.../memory/MEMORY.md`
- V31-Final-Bericht: `../sessions/20260514-4600-fortschrittsdokumentation-v30-v31.md`
