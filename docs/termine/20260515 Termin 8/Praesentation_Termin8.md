---
title: "PRT-ART Termin 8 — Sprint V12-V31 Stand"
author: "Benjamin Probst"
date: "2026-05-15"
---

# Slide 1 — Titel

**PRT-ART Diplomarbeit — Termin 8**

Sprint-Block V12-V31 (20 Sprints seit Termin 7)

Stand 2026-05-15 · Benjamin Probst · TU Dresden

---

# Slide 2 — Agenda

1. Wo wir stehen (Repo-Stand + Pin-Kette)
2. Sprint-Block V12-V18 — std-API + Manuskript + Codegen-Templates
3. Sprint-Block V19-V22 — Profile-Stack + Mess-Pipeline E2E
4. Sprint-Block V23-V24 — cache-engine Layout-Refactoring
5. Sprint-Block V25-V29 — Profile-Erweiterung + Allokator-Override
6. Sprint V30 — libs/-Migration vollstaendig
7. Sprint V31 — 22 Adapter + P27 hp-soft-Integration
8. Architekt-Direktive II (User 2026-05-14)
9. Diskussionspunkte
10. Naechster Termin

---

# Slide 3 — Drei-Repo-Stand (Bestaetigung)

| Repo | Rolle | HEAD | Push |
|------|-------|------|------|
| `comdare-cache-engine` | WIE + Werkzeuge | `16176ee` | OK |
| `comdare-prt-art` | Pruefling | `1a36ab4` | OK |
| `Diplomarbeit/Code/` | WAS + Auswertung | `75e92d8` | OK |

- Pin-Kette gespiegelt durch Diplomarbeit/Code/external/-Submodules
- ~180 Tests gruen ueber alle 3 Repos
- thesis/main.pdf 24 Seiten

---

# Slide 4 — Sprint V12-V18

**std-API + Manuskript + Codegen-Templates**

- V12: Vector-API +5 / Map-API +8 / Container-Vertraege / Naming-Audit
- V13: runtime_codegen + functional_tests + CMake Stage-1/2 + thesis/-Skelett (9 Kapitel)
- V14: 76 neue Tests + CI Test-Discovery-Workaround + Manuskript Kapitel 02-04
- V15: Manuskript Kapitel 01+05+06+07
- V16: Build-Verifikation + ART (P01) Module-Body Vorlage
- V17: 7 Rang-1 SOTA-Module-Body-Templates
- V18: Codegen Multi-Template-Path (cache-engine + prt-art)

---

# Slide 5 — Sprint V19-V22

**Profile-Stack + Mess-Pipeline E2E**

- V19: `<expected_workload>`-Tag in algorithm_profiles XML-Schema
- V20: PermutationResult.workload_used Field + ResultAggregator CSV/JSON
- V21: Sample-Mess-Daten + thesis chapter 06 Sample-Diagramm
- V22: diagram_generator plot_by_workload + End-to-End Sample-Pipeline-Test

**Ergebnis:** Mess-Pipeline E2E-faehig OHNE reale Hardware (Sample-Daten).

---

# Slide 6 — Sprint V23-V24

**cache-engine Layout-Refactoring (Pitchfork Layout)**

- V23.A Cleanup (build-Dirs, .gitignore, CMakePresets)
- V23.B `apps/cache_engine_builder/` extrahieren
- V23.C `libs/common/{succinct,serialization,platform,measurement}/`
- V23.D `libs/domain/` — DEFERRED → V30
- V23.E `libs/deprecated/prt_art_legacy/` (Folly-Idiom)
- V23.F `libs/test_infra/{workload_generator,test_data,benchmark_suite}/`
- V24.A-E: prt-art + Diplomarbeit Cleanup + 3 PROJECT_LAYER_MAPs Update

---

# Slide 7 — Sprint V25-V29

**Profile-Erweiterung + Allokator-Override**

- **30 SOTA-Profile** mit `<expected_workload>` (V25.B)
- **10 Allokator-Profile** A01-A20 mit Workload-Tag (V26.A)
- **21 Adapter-Skelette** (V25.C 11 SOTA + V26.B 10 Allokator)
- thesis chapter 02 +SOTA/Allokator-Profile-Tabellen (V28)
- ExperimentDriver `<allocator_override>`-Tag (V29) — z.B. "ART nutzt mimalloc statt jemalloc"

**Permutationsraum:** 30 × 10 × 6 = **1800 deklarierte Permutationen**

---

# Slide 8 — Sprint V30

**libs/-Migration vollstaendig (User-Direktive Option C+: ohne `domain/`)**

| Phase | Migration | Tests |
|---|---|---|
| V30.D.1 | `experiment/` → `libs/execution_engine/` | 31/31 |
| V30.D.2 | `search_engine/` → `libs/search_engine/` | OK |
| V30.D.3 | `engine_choice/` → `libs/common/config/` + ALIAS | OK |
| V30.D.4+5 | `cache_engine/` → `libs/cache_engine/` (134 .hpp + 7 .cpp + 22 Builder-Subs) | 31/31 |

**Top-Level cache-engine:** 8 → 5 Verzeichnisse (libs/, apps/, adapters/, ext/, tools/).
**9 hardcodierte Pfade** aktualisiert.

---

# Slide 9 — Sprint V31

**22 Adapter + P27 hp-soft + NOTICE Architekt-Direktive II**

- V31-PRE: Lizenz-Audit aller 22 ext/-Repos
- V31.A: NOTICE +Architekt-Direktive II 2026-05-14
- V31.K1-K4: 12 SOTA + 10 Allokator-Adapter (Header + CMake-Flag)
- V31.K5: P27 `tools/p27_bundle_finder/` (C++23-Port hp_soft.py)
- V31.K6: P27 `HierarchicalBundlePrefetcher` (5 Tests gruen)
- V31.F: 23/23 V31-Adapter-Smoke-Tests gruen (incl. A04-Mimalloc Bug-Fix)
- V31.I: thesis chapter 04 +V25-V31 + Habich-Briefing-Refresh

---

# Slide 10 — Adapter-Pattern

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
        throw std::runtime_error("not enabled");
        // ODER std::malloc(size) bei Allokatoren
#endif
    }
};
}
```

**Vorteile:**
- Build laeuft ohne ext-Repo-Aktivierung
- Per `-DCOMDARE_HAVE_<X>=ON` aktivierbar
- Saubere Trennung Adapter (C++23) / Original (ext/)

---

# Slide 11 — Architekt-Direktive II (User 2026-05-14)

> "Da wir alle Algorithmus-Bestandteile zerschneiden, entsteht fuer alle
> Permutations-Achsen ein neues Werk. Das gilt fuer alle Lizenztypen.
> Repos ohne Lizenztypen haben nur ein formales copyright."

**Konsequenz:**

| Lizenz-Klasse | Repos | Status |
|---|---|---|
| Apache-2.0 / MIT / ISC / BSD | 13 | safe |
| **GPL-3** | P04-CoCo-trie, P07-Wormhole | **freigegeben** |
| **LGPL-2.1+** | P29-RCU/userspace-rcu | **freigegeben** |
| **No-LICENSE** | P06, P25, P30, A03 | **freigegeben (Zitation)** |

In `NOTICE` verankert mit Implikationen pro Klasse.

---

# Slide 12 — P27 hp-soft Integration

**Mail-Antwort Boris Grot/Youhui Zhang 2026-05-14:**

`hp-soft.zip` (1981 B) mit `hp_soft.py` + `readme.txt`.

**Was es leistet:**
- Build-Time Call-Graph-Analyse via `objdump -d` / `objdump -t`
- Identifiziert Funktionen mit Subtree-Footprint > Threshold (240KB)
- → "Potential entry points of Bundles" fuer Hierarchical-Bundle-Prefetcher

**Unsere Integration:**
- C++23-Port als `tools/p27_bundle_finder/` (Library + CLI)
- Runtime: `HierarchicalBundlePrefetcher` (5 Tests gruen)
- User-Hinweis: "Mehr kommt nicht" → keine Folge-Mails

---

# Slide 13 — Test-Status (~180 Tests gruen)

| Repo | Suite | Anzahl | Status |
|------|-------|--------|--------|
| cache-engine | Codegen+Workload+Aggregator | 31 | gruen |
| cache-engine | V31 Adapter Smoke | 23 | gruen |
| cache-engine | Concepts (HBM, succinct, RCU) | ~15 | gruen |
| cache-engine | ModuleLoader + Permutation | ~10 | gruen |
| prt-art | PrtArtSearchEngine Identity | 66+ | gruen |
| prt-art | P27 BundlePrefetcher | 5 | gruen |
| prt-art | Adapter + ValueHandle + Memory | ~20 | gruen |
| Diplomarbeit/Code | messung_driver + diagram_gen | 13+ | konfiguriert |

---

# Slide 14 — Diskussionspunkte (1/3)

**1. Architekt-Direktive II OK?**
GPL-3 / LGPL / no-LICENSE-Adapter freigegeben.
→ Habich-Bestaetigung erbeten.

**2. libs/-Layout ohne `domain/`-Zwischenebene OK?**
User-Direktive "Option C+": flach `libs/<modul>/`.
→ Habich-Sichtweise?

**3. P27 hp_soft Sammelsurium akzeptabel?**
Build-Time-Tool da, Runtime ist Skelett.
→ Was fehlt fuer wissenschaftliche Akzeptanz?

---

# Slide 15 — Diskussionspunkte (2/3)

**4. HW-E2E Mess-Reihe — konkretes Setup?**
- i7-1270P lokal (Cache + DRAM, kein NUMA)
- ZIH Barnard (CPU, NUMA)
- ZIH Capella (GPU NVIDIA A100)
- HBM-Hardware (welche genau?)

**5. Manuskript-Tiefe pro Kapitel?**
thesis 24 S Skelett — Habich-Richtwert?

---

# Slide 16 — Diskussionspunkte (3/3)

**6. Permutationsexplosion (5,5 × 10^9)**
Strategie: Profile-Filter + MessreihenMode::Defined fuer Manuskript-Plots,
Full-Mode nur fuer ZIH-Cluster-Laeufe.
→ Habich-Bestaetigung?

**7. Naechster Termin?**

---

# Slide 17 — Was als Naechstes (Prio-Plan)

**Prio 1 (kurzfristig):**
- HW-E2E Mess-Reihe (V21.2) — User-Aktion
- Cluster-Migration (paralleler User-Agent)

**Prio 2 (mittelfristig):**
- Master-Plan Phasen K-B bis K-J (~11 Tage)
- docs/architektur/, docs/glossar/, docs/bausteine/, docs/forschungslandkarte/
- drawio REV7 (REV6 erweitern + Master-Tab)

**Prio 3 (laengerfristig):**
- ext-Repo-Aktivierung (Original-Compiler-Setup)
- Manuskript-Vollausbau Kapitel 06 mit echten Mess-Daten

---

# Slide 18 — Querverweise

- **Arbeitsplan**: `Arbeitsplan_Termin8.md`
- **Arbeitsergebnis**: `Arbeitsergebnis_Termin8.md`
- **Master-Plan**: `docs/MASTERPLAN_KONSOLIDIERUNG_TERMINE.md`
- **Fortschrittsdoku**: `docs/sessions/20260514-4600-fortschrittsdokumentation-v30-v31.md`
- **Briefing-Refresh**: `docs/sessions/20260514-4500-habich-termin-8-briefing-refresh-v19-v31.md`
- **Termin-7-Stand**: `docs/termine/20260508 Termin 7/HABICH_TERMIN7_ZUSAMMENFASSUNG_2026_05_13.md`
- **thesis main.pdf**: `thesis/main.pdf` (24 Seiten)

---

# Slide 19 — Fragen?

**Vielen Dank fuer Ihre Zeit, Herr Habich.**

Repository-Links auf Wunsch.
