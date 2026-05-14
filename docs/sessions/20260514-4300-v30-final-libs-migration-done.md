# V30 Final — libs/-Migration ABGESCHLOSSEN (2026-05-14, 43:00)

**Vorgaenger:** `20260514-4200-v27-v31-final-stand.md`
**Hauptthema:** V30.D.1-D.5 vollstaendig autonom umgesetzt (User-Direktive
                "autonome Verarbeitung Default")
**Risiko:** ABGESCHLOSSEN (HOCH war Schaetzung; in Wirklichkeit clean migration)

---

## §1 Zusammenfassung

V23.D libs/domain/ Migration war seit V23.F (5 Sprints lang) deferred.
V30 hat diese letzte Phase nachgeholt — **ohne** das im V30-Anker
vorgesehene `domain/`-Zwischenniveau (User-Entscheidung Option C+):
flach `libs/<modul>/` statt `libs/domain/<modul>/`.

---

## §2 Migrations-Mapping

| Vorher (Top-Level) | Nachher (libs/) | Inhalt |
|---|---|---|
| `experiment/` | `libs/execution_engine/` | 4 Files (V30.D.1) |
| `search_engine/` | `libs/search_engine/` | 8 INTERFACE-Subs (V30.D.2) |
| `engine_choice/` | `libs/common/config/` | 1 INTERFACE + ALIAS comdare::common::config (V30.D.3) |
| `cache_engine/` | `libs/cache_engine/` | 134 .hpp + 7 .cpp + 22 Builder-Subs (V30.D.4+D.5) |

**Gesamt:** ca. 280 Source-Dateien sauber migriert in 4 sequentiellen
Commits mit jeweils ctest-Verifikation (31/31 gruen).

---

## §3 Include-Pfad-Konsolidierung

9 hardcodierte `${CMAKE_SOURCE_DIR}/cache_engine/...`-Pfade in einem Schritt
aktualisiert (im V30.D.4+D.5 Commit zusammen):

- apps/cache_engine_builder/CMakeLists.txt
- libs/cache_engine/builder/{module_loader,experiment_runner,experiment_driver}/CMakeLists.txt
- tests/unit/CMakeLists.txt (3 Stellen: include + subsystems + zusaetzliche)
- libs/test_infra/workload_generator/CMakeLists.txt
- libs/execution_engine/CMakeLists.txt

**Kein Include-Crash, kein Build-Bruch**: weil die Refactorings V23.A-F
schon die meisten Pfade ueber ALIAS-Targets (comdare::xxx) statt
hardcodierte Pfade aufgeloest hatten.

---

## §4 Commit-Kette

| Repo | Commit | Inhalt |
|---|---|---|
| cache-engine | 37e2ce1 | V30.D.1 |
| cache-engine | 9c3a2ab | V30.D.2 |
| cache-engine | ce46b7c | V30.D.3 |
| cache-engine | ac13e2f | V30.D.4+D.5 |
| prt-art | e83e52f | Pin cache-engine -> ac13e2f |
| Diplomarbeit | (V32 commit) | Pin cache-engine + prt-art bumps |

**Push-Status:** lokal pending wegen DNS-Ausfall — User pusht manuell sobald
Internet wieder stabil.

---

## §5 Was V30 NICHT gemacht hat

- **NICHT:** domain/-Zwischenebene angelegt (User explizit "Zwischenebene
  erscheint mir nicht nuetzlich")
- **NICHT:** adapters/ migriert — bleibt Top-Level (adapters/ und ext/
  haben keine analogen libs/-Kandidaten in PFL/ClickHouse-Stil)
- **NICHT:** tools/ migriert — bleibt Top-Level (analog ClickHouse)
- **NICHT:** ext/ migriert — bleibt Top-Level (Original-Code mit
  Original-Compilern)

---

## §6 Layout-Zustand (Stand V30 Final)

```
comdare-cache-engine/
├── apps/
│   └── cache_engine_builder/         # Top-Level Executable (V23.B)
├── adapters/                         # 21 INTERFACE-Skelette (V25.C+V26.B)
├── ext/                              # Originalcode (P01-P32 + A01-A20)
├── tools/                            # ycsb_cli, etc.
├── tests/
└── libs/
    ├── cache_engine/                 # Domaene 2 (V30.D.4+D.5)
    │   ├── algorithm_profiles/
    │   ├── builder/                  # 22 Subkomponenten
    │   ├── concurrency_manager/
    │   ├── include/
    │   ├── reclamation/
    │   └── subsystems/
    ├── execution_engine/             # Phase 7.3+7.4 (V30.D.1)
    ├── search_engine/                # Domaene 1 INTERFACE-Skelette (V30.D.2)
    ├── common/                       # Cross-Cutting
    │   ├── config/                   # V30.D.3 (engine_choice subsumed)
    │   ├── measurement/
    │   ├── platform/
    │   ├── serialization/
    │   └── succinct/
    ├── test_infra/                   # V23.F
    │   ├── workload_generator/
    │   ├── test_data/
    │   └── benchmark_suite/
    └── deprecated/                   # V23.E (prt_art_legacy)
```

**Konsistent mit:** ClickHouse-src/Common-Stil, PFL (Pitchfork Layout),
Folly-experimental/-Idiom.

---

## §7 Build-Verifikation

```
cmake --preset msvc-release   # 5.3s
cmake --build msvc-release    # MSVC 19.39 OK
ctest -R "Codegen|Workload|ResultAggregator|ExperimentDemo"
# 31/31 Tests passed in 1.51 sec
```

---

## §8 Was V30 fuer V31 freigibt

- libs/-Layout ist final konsolidiert
- adapters/ bleibt unveraendert (V31 fuellt diese Sub-Dirs)
- ext/-Repos sind klonbar; Aktivierung pro Adapter-Pilot moeglich

V31 (K) kann jetzt starten — entweder:
- Option D (komplette Adapter-Inhalte autonom) — User-Entscheidung
  laut V31-Anker §7
- gefolgt von Option C (Lizenz-Audit fuer GPL-2 Vermischung)

---

## §9 Querverweis

- V27-V31 Final-Stand: `20260514-4200-v27-v31-final-stand.md`
- V30 Anker (jetzt mit §7 DONE-Sektion): `20260514-4000-v30-anker-G-libs-domain.md`
- V31 Anker (DRAN, User Option D+C): `20260514-4100-v31-anker-K-adapter-inhalte.md`
- thesis main.pdf 23 Seiten (V28)
- Pin-Kette: cache-engine ac13e2f, prt-art e83e52f, Diplomarbeit (this commit)
