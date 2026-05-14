# V31 Final — Adapter-Inhalte + P27 hp-soft + Architekt-Direktive II (2026-05-14, 44:00)

**Vorgaenger:** `20260514-4300-v30-final-libs-migration-done.md`
**Hauptthema:** V31.A+K1+K2+K3+K4+K5+K6+F vollstaendig autonom
**Anlass:** User-Direktive 2026-05-14 ("Komplett autonom: K1+K2+K3+K4+K5+K6+A+F")

---

## §1 Zusammenfassung

V31 hat **22 Adapter-Skelette** + **P27 Bundle Finder** + **NOTICE
Architekt-Direktive II** in einem Sprint nachgezogen. Jeder Adapter
ist eine kompilierende C++23-Header-only INTERFACE-Library mit
COMDARE_HAVE_<X>-Flag, die im Off-Modus per std::malloc-Fallback
oder std::runtime_error funktioniert.

**Build:** 23/23 V31-Adapter-Smoke-Tests gruen.

---

## §2 Migrations-Mapping

| Phase | Inhalt | Files | Tests |
|---|---|---|---|
| V31.A | NOTICE Architekt-Direktive II + LICENSE_AUDIT_EXT.md erweitert | 2 | n/a |
| V31.K1 | P01-ART (Apache-2.0) Pilot | 2 | 1 smoke |
| V31.K2 | A04-mimalloc (MIT) Pilot | 2 | 2 smoke |
| V31.K3 | 11 SOTA-Adapter (P02-P30) | 22 | 11 smoke |
| V31.K4 | 9 Allokator-Adapter (A01-A20) | 18 | 9 smoke |
| V31.K5 | P27 hp_soft.py → C++23 (`tools/p27_bundle_finder/`) | 3 | n/a (Tool) |
| V31.K6 | P27 Runtime (im prt-art Repo, schon vollstaendig 2026-05-12) | 0 (existed) | 5 (existed) |
| V31.F  | test_v31_adapters.cpp Smoke-Suite + Bug-Fix A04-Mimalloc-Fallback | 2 | 23 total |

**Gesamt cache-engine:** ca. 50 neue Files, alle in einem Schwung.

---

## §3 Architekt-Direktive II (User-Klarstellung 2026-05-14)

> "Da wir alle Algorithmus-Bestandteile zerschneiden, entsteht fuer alle
> Permutations-Achsen ein neues Werk. Das gilt fuer alle Lizenztypen."

**Konsequenz:** Alle 22 ext-Repos sind freigegeben (keine User-Bestaetigung
pro Repo mehr). NOTICE hat einen neuen Abschnitt 'ARCHITEKT-DIREKTIVE II
(2026-05-14)' mit Implikationen pro Lizenz-Klasse (GPL-3, LGPL-2.1+,
no-LICENSE, permissive).

---

## §4 P27 hp-soft.zip Mail-Antwort

**Inhalt:** `hp_soft.py` (Build-Time Call-Graph-Analyse, 3751 B) +
`readme.txt`. Mehr kommt nicht (User-Hinweis: stolzer + zynischer Autor).

**Re-Implementation:**
- **Build-Time:** `tools/p27_bundle_finder/` (C++23-Port).
  CallGraph + parse_symbol_table + parse_disassembly + DFS +
  Threshold-Filter. Aufgebaut analog hp_soft.py, aber als Library
  (tests-fähig).
- **Runtime:** `prt_art/legacy_reimpl/P27-Zhang-ASPLOS-Hierarchical/`
  (existiert seit 2026-05-12). HierarchicalBundlePrefetcher mit
  Bundle-Verwaltung + L1/L2/L3-Tracking. 5 GTest-Tests gruen.

---

## §5 V31 Bug-Fix

**A04-Mimalloc Fallback-Bug:** Im OFF-Modus mischte allocate/deallocate
`std::malloc` + `_aligned_free` auf Windows → Heap-Korruption (0xc0000374).
Fix: `used_aligned_alloc_`-Flag pro Adapter-Instanz.

**Bug-Lokalisierung:** Test #78 V31AdapterAlloc.A04_Mimalloc Crash bei
ctest-Lauf. Fix war 5 Zeilen.

---

## §6 Pin-Kette + Push

| Repo | Commit | Push |
|---|---|---|
| cache-engine main | 16176ee | ✅ pushed (DNS wieder da) |
| prt-art development | 1a36ab4 | ✅ pushed |
| Diplomarbeit main | 4a06797 | ✅ pushed |

cache-engine commits seit V29: 6 (V30.D.1, V30.D.2, V30.D.3, V30.D.4+5,
V31-PRE, V31.A+K1-K4, V31.K5, V31.F)
prt-art commits seit V27: 2 (V30 Pin, V31.F Pin)
Diplomarbeit commits seit V27 sprint-block: 4 (V30 Final, P27 hp-soft,
V30.D.5 Pin Pre, V31.F Pin)

---

## §7 Was V31 NOCH NICHT macht

- **ext/-Repos NICHT aktiviert.** Adapter sind jetzt da, aber
  `-DCOMDARE_HAVE_<X>=ON` ist OFF default. Aktivierung pro Repo
  braucht Original-Compiler-Setup (Habich-Direktive F-EXTRA-1) — das
  ist ein eigener Sprint, vermutlich Cluster-bezogen.
- **HW-E2E (V21.2)** unveraendert offen — User-Aktion, brauche reale
  Hardware.

---

## §8 Layout-Zustand (Stand V31.F)

```
comdare-cache-engine/
├── apps/                                # Top-Level Executables
├── adapters/                            # 22 V31-Adapter-Skelette
│   ├── P01-ART/...P30-HazardPointers/   # 12 SOTA-Header
│   └── A01-hoard/...A20-dlmalloc/       # 10 Allokator-Header
├── ext/                                 # Originalcode (22 Repos, OFF default)
├── tools/
│   ├── ycsb_cli/, latex_anhang/, ...
│   └── p27_bundle_finder/               # NEU V31.K5 (C++23-Port hp_soft.py)
├── tests/unit/
│   └── test_v31_adapters.cpp            # NEU V31.F (23 Smoke-Tests)
└── libs/                                # V30-Migration komplett
    ├── cache_engine/, execution_engine/, search_engine/
    ├── common/{succinct,serialization,platform,measurement,config}/
    ├── test_infra/, deprecated/
```

---

## §9 Was als naechstes (V31.I + Cluster)

- **V31.I:** thesis chapter 04 +V19-V31 Section + Habich-Termin~8
  Briefing-Refresh (in Arbeit)
- **Cluster (paralleler User-Agent):** Original-Compiler-Setup pro
  ext-Repo, dann V21.2 HW-E2E
- **Habich-Termin~8:** User-Termin

---

## §10 Querverweis

- V30 Final: `20260514-4300-v30-final-libs-migration-done.md`
- V27-V31 Stand vor V30/V31: `20260514-4200-v27-v31-final-stand.md`
- LICENSE_AUDIT_EXT.md (cache-engine root)
- NOTICE (cache-engine root, jetzt mit Architekt-Direktive II)
- P27 STATUS.md (Forschungsarbeiten/code/P27-Zhang-ASPLOS-Hierarchical/)
