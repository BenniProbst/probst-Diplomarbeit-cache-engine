# V30 (G) — Anker: V23.D libs/domain/ Migration (2026-05-14, 40:00)

**Vorgaenger:** `20260514-3900-v29-anker-L-allocator-override.md`
**Hauptthema:** G — V23.D libs/domain/ Migration (deferred seit V23.F)
**Risiko:** **HOCH** (~280 Source-Dateien, 22 Builder-Subkomponenten,
                     41 CMakeLists, Submodule-Pin-Kette in 3 Repos)
**Status:** **ANKER NUR — keine Code-Aenderung in V30 ohne User-Approval**

---

## §1 Was V23.D ist

V23 (Layout-Refactoring cache-engine, 2026-05-14) hatte 6 Phasen:
- V23.A Cleanup ✅
- V23.B `apps/cache_engine_builder/` ✅
- V23.C `libs/common/{succinct,serialization,platform,measurement}/` ✅
- V23.D **`libs/domain/`** — DEFERRED
- V23.E `libs/deprecated/prt_art_legacy/` ✅
- V23.F `libs/test_infra/{workload_generator,test_data,benchmark_suite}/` ✅

V23.D ist die letzte fehlende Phase und gleichzeitig die groesste.

---

## §2 Was migriert werden muss (Inventur)

| Heute (cache-engine root) | Ziel | Files |
|---|---|---|
| `cache_engine/` | `libs/domain/cache_engine/` (Kern) + `libs/domain/builder/` (22 Subkomponenten) + `libs/domain/allocator/` (4+2 Pools) | 134 .hpp + 7 .cpp + 41 CMakeLists |
| `experiment/` | `libs/domain/execution_engine/` | 2 .hpp + 1 .cpp + 1 CMakeLists |
| `search_engine/` | `libs/domain/search_engine/` | 9 CMakeLists (Skelette) |
| `adapters/` | bleibt | 21 INTERFACE-Libs |
| `engine_choice/` | `libs/common/config/` | 1 CMakeLists |

**Gesamt:** ca. 280 Source-Dateien betroffen.

---

## §3 Risiko-Analyse

### 3.1 Include-Pfade
~150 Dateien haben `#include "cache_engine/..."` oder `#include
"experiment/..."`. Alle muessen umgestellt werden.

### 3.2 CMake target_link_libraries
~30 Stellen referenzieren `comdare::cache_engine`, `comdare::experiment`,
etc. — die ALIAS-Targets bleiben gleich (semantisch identisch), aber
der `add_subdirectory()`-Pfad aendert sich in jedem
`cache_engine/builder/<sub>/CMakeLists.txt`.

### 3.3 Submodule-Pin-Kette
- prt-art konsumiert cache-engine via `external/comdare-cache-engine`
- Diplomarbeit konsumiert beide via `Code/external/`
- Nach V23.D-Push: prt-art Pin-Bump + Diplomarbeit Pin-Bump (2-stufig)

### 3.4 CI-Pipelines
GitLab + GitHub Actions in cache-engine + prt-art + Diplomarbeit
referenzieren ggf. konkrete Pfade. Mussen nach V23.D verifiziert werden.

### 3.5 14 weitere Sessions sind betroffen
Das System hat seit V23.F 4 weitere Sprints (V24-V29) ohne libs/domain/
ueberlebt — der Kern-Code lebt noch in den Top-Level-Pfaden. Das heisst:
**V23.D ist NICHT blockierend** fuer Profile/Adapter/Mess-Pipeline.

---

## §4 V30-Plan (bei User-Approval)

| # | Phase | Risiko | Reversibilitaet |
|---|---|---|---|
| V30-PRE | Tag `v29-final` in 3 Repos | niedrig | Rollback-Punkt |
| V30.D.1 | `experiment/` → `libs/domain/execution_engine/` (klein, 4 Files) | mittel | mittel |
| V30.D.2 | `search_engine/` → `libs/domain/search_engine/` (Skelette) | niedrig | hoch |
| V30.D.3 | `cache_engine/builder/` → `libs/domain/builder/` (22 Subkomponenten) | **HOCH** | mittel |
| V30.D.4 | `cache_engine/` (Restkern) → `libs/domain/cache_engine/` | **SEHR HOCH** | niedrig |
| V30.D.5 | `engine_choice/` → `libs/common/config/` | niedrig | mittel |
| V30.D.6 | Includes aktualisieren (~150 Files) | hoch | mittel |
| V30.F | Tests + Pin-Bumps + Final | mittel | (final) |

Pro Phase: cmake configure + ctest verifizieren, dann commit + push +
Pin-Bump in Diplomarbeit (V23.A-F-Disziplin).

**Geschaetzte Dauer:** ~2-3 Sessions (autonom moeglich, aber jede Phase
braucht eigene Build-Verifikation).

---

## §5 Empfehlung

Da:
- V23.D nicht blockiert (4 Sprints V24-V29 ohne probleme)
- Der Refactoring 280 Files anfaesst
- Mass-Include-Update hochrisikant ist
- Bestehende `comdare::*` ALIAS-Targets schon stabil sind

empfehle ich **V30 zu DEFERRIEREN** bis nach Habich-Termin~8 (V21.5).
Habich kann beim Termin entscheiden ob die Strukturkonsistenz (PFL-100%)
fuer die Verteidigung wichtig ist oder ob die jetzige Mischstruktur
(top-level + libs/) akzeptabel ist.

**Alternative:** kleinere V30.D.1-Pilot-Migration (`experiment/` → 
`libs/domain/execution_engine/`, nur 4 Files) als Proof-of-Concept.

---

## §6 V30 STOPP-Punkt

**Naechster Schritt:** USER-Entscheidung
- Option A: V30 komplett deferrieren bis nach Habich-Termin~8
- Option B: V30.D.1-Pilot autonom (klein, 4 Files)
- Option C: V30.D.1-D.6 sequentiell autonom (2-3 Sessions, hochrisikant)

**Bis zur Entscheidung:** kein Code-Refactoring in cache-engine V23.D-Bereich.

Entscheidung: Option C, wir machen das ordentlich und konsistent von cache-engine als Wurzel über prt-art bis hin zur Diplomarbeit. Allerdings brauchen wir den Unterordner "Domain" nicht dazwischen, wir gehen einfach direkt mit libs/execution_engine und so weiter, die Zwischenebene erscheint mir nicht nützlich.

---

## §7 V30 DONE (2026-05-14, autonom umgesetzt)

| Phase | Commit | Inhalt | Build |
|---|---|---|---|
| V30-PRE | (Tags) | v29-final in 3 Repos | OK |
| V30.D.1 | 37e2ce1 | experiment/ -> libs/execution_engine/ (4 Files) | 31/31 Tests |
| V30.D.2 | 9c3a2ab | search_engine/ -> libs/search_engine/ (8 INTERFACE-Subs) | configure OK |
| V30.D.3 | ce46b7c | engine_choice/ -> libs/common/config/ + ALIAS comdare::common::config | configure OK |
| V30.D.4+D.5 | ac13e2f | cache_engine/ -> libs/cache_engine/ (134 .hpp + 7 .cpp + 22 Builder-Subs) | 31/31 Tests |

**Konsolidierung:** 9 hardcodierte `${CMAKE_SOURCE_DIR}/cache_engine/...`-Pfade
in einem Schritt aktualisiert (apps/cache_engine_builder, builder/{module_loader,
experiment_runner, experiment_driver}, tests/unit (3 Stellen), libs/test_infra/
workload_generator, libs/execution_engine).

**Pin-Kette:**
- prt-art e83e52f: cache-engine -> ac13e2f
- Diplomarbeit (V32 commit): cache-engine -> ac13e2f, prt-art -> e83e52f

**Push:** lokal pending (DNS-Ausfall fuer github.com — User pusht manuell oder
spaeter, wenn Internet stabil).

**Layout-Zustand:**
- ✅ libs/cache_engine/ (Domaene 2, Restkern + Builder)
- ✅ libs/execution_engine/ (Phase 7.3+7.4)
- ✅ libs/search_engine/ (Domaene 1, INTERFACE-Skelette)
- ✅ libs/common/{succinct,serialization,platform,measurement,config}/
- ✅ libs/test_infra/{workload_generator,test_data,benchmark_suite}/
- ✅ libs/deprecated/prt_art_legacy/
- ✅ apps/cache_engine_builder/ (Top-Level Executable)
- ✅ adapters/ (21 INTERFACE-Skelette, V31 fuellt diese)
- ✅ ext/ (Originalcode, mit Original-Compilern)

**Kein domain/-Zwischenebene** (User-Direktive verifiziert).

V23.D ist damit ABGESCHLOSSEN. V31 (K) Adapter-Inhalte folgt.

