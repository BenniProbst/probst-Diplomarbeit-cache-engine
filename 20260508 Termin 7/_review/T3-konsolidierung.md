# Termin 3 — Konsolidierung

**Datum:** 2026-04-09
**Hauptthema:** Benchmark-, Datensatz- und Messplan · Baseline-Katalog · Fairnessregeln
**Zustand:** Mess-Plan v1

## Zentrale Texte

- `20260409 Termin 3__20260409_PRT_ART_Benchmark_und_Datensatzplan_Termin3_final.docx`
- `20260409 Termin 3__20260409_Arbeitsaufstellung_PRT_ART_Termin3_final.docx`

## Plattformmatrix T3

| Plattform | Profil | Verpflichtender Messmodus | Besonderheit |
|---|---|---|---|
| Lokal: Intel Core i7-1270P | Hybrid CPU, Vanilla + AVX2, P+E-Cores getrennt | Single P, Single E, All-P, All-E; perf cpu_core/* + cpu_atom/* | Hybrid-Counter + ISA-Umschaltlogik |
| ZIH Barnard | 2× Xeon Platinum 8470, AVX-512, 512 GiB RAM | homogene Serverkerne, Scalar/AVX2/AVX-512 via Slurm | Skalierende Referenz |

## Datensatzkatalog (6 Pflichtdatensaetze)

| Datensatz | Charakteristik | Test-Schwerpunkt |
|---|---|---|
| `url` | sehr lange Schluessel, lange LCPs, mittleres Alphabet | Redirects, Praefixkollabierung, Cache-Lokalitaet |
| `dna` | kleines Alphabet, sehr grosse Daten, hohe Wiederholung | Praefix-Entropie, tiefe Trie-Strukturen |
| `tpcds-id` | datenbanknahe IDs | Gegenpol zu textartigen/biologischen Daten |
| `trec-terms` | Term-/Suchindex-artige Woerter | Exact/Prefix bei realen Woerterbuechern |
| `protein` | biologische Sequenzen, mittleres Alphabet | Gegenpol zu DNA und Text |
| `xml` | strukturierte Strings mit wiederkehrenden Praefixen | Praefix- und Enumerationspfade |

Erweiterungen optional: enwiki-titles, aol-queries, uk-2002, webbase-2001, Pizza&Chili Subsets

## Baseline-Katalog (Wrapper-Strategie)

| Baseline | Referenzimpl. | Sprache | Status |
|---|---|---|---|
| ART | libart (UnoDB optional) | C99 / C++20 | Pflicht |
| HOT | speedskater/hot | C++14/CMake | Pflicht |
| Masstree | kohler/masstree-beta | C++/autotools | Pflicht |
| B+-Baum | habedi/bptree (Primaer), embedded2016/bplus-tree (Alt) | C/Make | Pflicht |
| Hash | absl::flat_hash_map / node_hash_map | C++/Bazel | Pflicht |
| START | (Papiernachbar; jungmair/START verfuegbar) | — | Literaturbaseline (REV4: Code gefunden) |
| CSS / CSB+ / B² / CoCo | Papier-/Konzeptnachbar | — | Literaturbaseline |

**Wrapper-Regel:** Fremdalgorithmen werden NICHT neu implementiert. Erlaubt: Build-Patches, Adapter, Mess-Hooks, gemeinsames Interface (Load/Get/Prefix/Scan/Insert/Delete).

## Workload-/Policy-Matrix

| Achse | Pflichtwerte |
|---|---|
| Operationen | Bulk build, exact hit, exact miss, prefix hit, prefix miss, prefix enumeration, insert, update, delete |
| YCSB-Mischungen | A (50/50), B (95/5), C (read only), D (latest), E (short ranges), F (read-modify-write) |
| Ordnungsmodus | unsortiert, lokal geordnet, lexikographisch |
| Value-Modus | inline, external handle |
| ISA-Modus | scalar, AVX2, AVX-512 |
| Core-Modus | Single P, Single E, All-P, All-E, Barnard homogeneous |
| Wiederholungen | **5 Laeufe je Konfiguration, Rohwerte getrennt** (KEINE Mittelung von Perzentilen) |

## Fairnessregeln

- **Common-Denominator vs Native Mode**: Trennung "vergleichbarer Minimal-Modus" (externe Payload, keine PRT-ART-Spezialtricks) vs. "PRT-ART-Native" (Inline + Cache-Engine + Seitentyp-Scheduler)
- **Gleiche Schluesselraeume** fuer alle Baselines
- **Gleiche Warmups + Seeds**, dokumentiert
- **Keine verdeckte Emulation** (z.B. Hash-Baseline darf Prefix nicht emulieren -> N/A)
- **Build-Transparenz**: Compiler, Flags, ISA, Allocator, Commit-Hash protokolliert

## Mess-Setup (Tooling)

| Ebene | Pflichtmetriken | Werkzeug |
|---|---|---|
| End-to-End | Throughput, p50/p95/p99, Build-Zeit, Bytes/Key/Value | eigener Harness + HDR-Histogramme |
| Counter lokal | cycles, instructions, branches, branch-misses, cache-misses, LLC-load-misses, dTLB-load-misses | perf stat JSON + cpu_core/* + cpu_atom/* |
| Counter Barnard | dieselben Kernzaehler homogen | perf stat / record |
| Memory-Access | CLU, Simulated Memory Footprint, modellierte Cache-Misses | Intel Advisor MAP + Cache Simulation |

## Erwaehnte Quellen — Cross-Referenz

| Erwaehnt | Katalog | PDF |
|---|---|---|
| ART libart | F.4 (Repo) | n/a |
| HOT speedskater | F.2 | n/a |
| Masstree | F.3 | n/a |
| B+-Baum bptree/bplus-tree | F.7, F.8 | n/a |
| Hash absl | F.9 | n/a |
| START Paper | A2.6 | ✓ (REV4) |
| CSS/CSB+/B²/CoCo | A1.1, A1.2, A2.7, A2.8 | ✓ |
| Pizza&Chili | E.3 (Tool) | n/a |
| Intel Advisor MAP/CacheSim | C.1, C.2 | n/a |
| YCSB | C.11 | n/a |
| perf hybrid | C.6 | n/a |

**Alle erwaehnten Werkzeuge/Repos sind im Quellenkatalog.**
