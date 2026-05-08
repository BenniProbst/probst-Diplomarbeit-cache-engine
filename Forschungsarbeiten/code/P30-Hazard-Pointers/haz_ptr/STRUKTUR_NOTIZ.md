# STRUKTUR_NOTIZ — P30 haz_ptr (huangjiahua/haz_ptr)

**Paper:** P30 — Michael 2004 — "Hazard Pointers: Safe Memory Reclamation for Lock-Free Objects" (IEEE TPDS 2004)
**Repo:** `huangjiahua/haz_ptr`
**Lokal:** `Forschungsarbeiten/code/P30-Hazard-Pointers/haz_ptr/`
**Lizenz:** **KEINE LICENSE-Datei**
**Voranalyse:** `_voranalyse_output_klasse_a/P30-Hazard-Pointers__haz_ptr.txt` (2026-05-09)
**Stand der Notiz:** 2026-05-09

---

## 1. Repository-Klassifikation

| Feld | Wert |
|------|------|
| Klasse | A — geklonter Originalcode (Drittanbieter Re-Impl. von Maged Michaels Paper) |
| Originalpaper-Code? | NEIN — Drittanbieter (Huang Jiahua); Maged Michael hat nicht eigenen Code-Drop |
| C++-Standard | impliziert C++11 (`std::atomic`); kein CMake/Makefile! |
| Build-System | **KEIN Build-System** (KEIN CMakeLists.txt, KEIN Makefile) |
| Compiler-Anforderungen | nicht spezifiziert |
| ISA-Anforderungen | C++11 atomics — alle modernen ISAs |
| Externe Abhaengigkeiten | nur `<atomic>` + `<thread>` |
| LOC (gesamt source) | 453 (haz_ptr.h 430 LOC, haz_ptr.cpp 23 LOC) |
| Aktuelle Architektur-Entscheidung | **NICHT im aktuellen Permutations-Raum** — Bausteine_Matrix.txt Achse 8 listet OLC/ROWEX/RCU als Concurrency-Mechaniken; Hazard-Pointers stehen dort NICHT explizit. KEIN F12-K-Verbot (F12-K betrifft CacheEngine-Lokation, nicht Concurrency). |

## 2. Verzeichnis-Hierarchie

```
haz_ptr/  (FLACH)
├── haz_ptr.h         (430 LOC)  — komplette Hazard-Pointer-Impl. als Header
├── haz_ptr.cpp       (23 LOC)   — Globale State-Definition (optional alternativ Macro `ENABLE_LOCAL_DOMAIN`)
└── README.md         (2.5 KB)   — Wikipedia-Erklaerung + Usage-Beispiele
```

## 3. Bausteine-Klassifikation (Achsen 1-11)

| Achse | Identifizierte Implementierung | Quelldatei(en) |
|-------|-------------------------------|----------------|
| **1 Page** | irrelevant | — |
| **2 Node** | irrelevant — Memory-Reclamation-Pattern | — |
| **3 Traversal** | irrelevant | — |
| **4 ValueHandle** | atomare Pointer-Pin via `HazPointerHolder::Pin(atomic_ptr)` | `haz_ptr.h` |
| **5 MemoryLayout** | irrelevant | — |
| **6 Allocator** | irrelevant | — |
| **7 Prefetch** | irrelevant | — |
| **8 Concurrency** | **Hazard-Pointers (Michael 2004)** — alternative zu RCU | `haz_ptr.h` |
| **9 ISA** | C++11 std::atomic (plattformunabhaengig) | `haz_ptr.h` |
| **10 Measurement** | nicht vorhanden | — |
| **11 Telemetry-Strategy** | nicht vorhanden | — |

**Bausteine_Matrix.txt Achse 8 (Concurrency-Mechaniken)** listet aktuell OLC, ROWEX, RCU; Hazard-Pointers fehlen dort. Faktisch ist b2-tree-master's `include/hazard.hpp` Originalcode bereits in `ext/P06-B2tree/b2-tree-master/` einbindbar — eine Bausteine-Matrix-Erweiterung um Hazard-Pointers ist also moeglich, aber bisher nicht beschlossen.

## 4. Adapter-Strategie fuer comdare-cache-engine

| Strategie-Punkt | Entscheidung |
|-----------------|--------------|
| Einbindung-Form | **NICHT im aktuellen Bausteine-Permutations-Raum** — Bausteine_Matrix Achse 8 listet OLC/ROWEX/RCU. Architekt-Direktive 2026-05-08: keine-Lizenz/GPL/LGPL ist KEIN Hinderungsgrund (modularisierte Bruchstuecke + C++23-Metaprogrammierung = neues Werk). Hazard-Pointers koennen daher technisch eingebunden werden, falls die Bausteine-Matrix erweitert wird. |
| Konzept-Quelle | als alternative MV-Strategie in Diplomarbeit-Concurrency-Kapitel diskutiert; PRT-ART nutzt vorzugsweise OLC + RCU (QSBR) |
| Lizenz-Vermerk | NOTICE (PENDING — KEINE LICENSE) — Architekt-Direktive klassifiziert das als „akademische Nutzung im Forschungskontext", kein Block. |
| Vergleichs-Hinweis | Hazard-Pointer haben Per-Read-Overhead (write+memory_barrier); RCU/QSBR amortisiert besser fuer dichte Read-Pfade — Argument fuer F2-Beschluss eigene RCU |
| LEGACY_REIMPL-Bedarf | **NEIN aktuell** — falls Achse 8 in Phase 6+ um Hazard-Pointers erweitert wird, kann b2-tree-master's `include/hazard.hpp` als bereits vorhandener Originalcode genutzt werden (statt huangjiahua/haz_ptr) |

## 5. Code-Qualitaets-Bewertung (Habich H2: Quelle/Ziel/Aenderung)

| Kriterium | Bewertung (★ 1-5) | Begruendung |
|-----------|-------------------|-------------|
| Quelle gepflegt | ★ | Drittanbieter, single-author, kein erkennbarer Wartungs­zyklus |
| Doku-Qualitaet | ★★ | README knapp (2.5 KB) mit Wikipedia-Zitat + Usage-Beispielen |
| Test-Abdeckung | ★ (KEINE Tests) | nur 23 LOC `haz_ptr.cpp` Globale-State-Definition |
| Ueberein­stimmung mit Originalpaper | ★★ (geschätzt, ohne Vergleich) | Drittanbieter-Re-Impl., kein peer-reviewed Reference |
| Adapter-Aufwand | ★★★★ (sehr klein) | falls aktiviert — single-header reicht; aber b2-tree-master/hazard.hpp ist die bessere Originalcode-Quelle |
| **Bauszenario** | **Quelle:** keine Lizenz, single-header Hazard-Pointers → **Ziel:** zur Zeit nicht aktiv im Permutations-Raum — Bausteine_Matrix Achse 8 erweitern, falls relevant → **Aenderung:** keine waehrend Phase 5; Konzept-Erwaehnung in Diplomarbeit als Alternative zu RCU |

## 6. Compile-Test-Plan

| Aktion | Erfolgs-Kriterium |
|--------|-------------------|
| (a) Klon im Cluster | ✅ erledigt |
| (b)-(d) | OPTIONAL — nur falls Bausteine_Matrix Achse 8 in Phase 6+ um Hazard-Pointers erweitert wird |

## 7. Offene Punkte / Beobachtungen

- **Korrektur Re-Verifikation 2026-05-09:** F12-K bezieht sich auf CacheEngine-Lokation (Heap-Singleton im Builder-Prozess), NICHT auf Hazard-Pointers. Das war ein Klassifikations-Fehler in der ersten Version dieses Dokuments. Hazard-Pointers sind aktuell schlicht nicht im Bausteine-Matrix-Permutations-Raum (Achse 8), was eine bewusste Entscheidung ist, aber kein Verbot.
- **KEINE LICENSE:** Architekt-Direktive 2026-05-08 erlaubt akademische Nutzung im Forschungskontext (keine-Lizenz = kein Block).
- **Drittanbieter-Re-Impl.:** Maged Michael (Originalpaper-Author) hat keinen oeffentlichen Code-Drop dieser Art. P30-Originalpaper-Code-Spalte = "(kein Code von Author verfuegbar)".
- **Diplomarbeit-Erwaehnung:** im Concurrency-Vergleichs-Kapitel als alternative MV-Strategie diskutieren, mit Verweis auf P29 RCU als gewaehlte Variante.
- **Vergleich zu b2-tree-master:** P06a (b2-tree-master) hat eigene `hazard.hpp` Implementation. Falls Hazard-Pointers in Phase 6+ in die Bausteine_Matrix aufgenommen werden, ist b2-tree-master/include/hazard.hpp die bevorzugte Quelle (qualitativ besser dokumentiert als huangjiahua/haz_ptr).

## 8. Verweise

- **Voranalyse-Output:** `_voranalyse_output_klasse_a/P30-Hazard-Pointers__haz_ptr.txt`
- **NOTICE-Eintrag:** `comdare-cache-engine/NOTICE` (PENDING — KEINE LICENSE; akademische Nutzung im Forschungskontext gemaess Architekt-Direktive 2026-05-08)
- **Bausteine_Matrix:** **NICHT enthalten** (Achse 8 listet OLC/ROWEX/RCU, Hazard-Pointers nicht im aktuellen Permutations-Raum) — kein Verbot, sondern Architektur-Wahl
- **Re-Impl. Modul:** **KEIN aktuell** — falls aktiviert, b2-tree-master/include/hazard.hpp bevorzugt
- **Bezug zu F2 (Concurrency):** F2 entschied EIGENE RCU-Implementation (statt liburcu) — Hazard-Pointers sind alternative Strategie, mit Per-Read-Overhead-Nachteil
