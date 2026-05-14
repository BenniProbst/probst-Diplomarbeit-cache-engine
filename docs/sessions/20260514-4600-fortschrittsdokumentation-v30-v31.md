# Fortschrittsdokumentation V30 + V31 (2026-05-14, 46:00)

**Vorgaenger:** `20260514-4500-habich-termin-8-briefing-refresh-v19-v31.md`
**Hauptthema:** Konsolidierte Fortschrittsdokumentation nach Sprint V30 (libs/-Migration) + Sprint V31 (Adapter-Inhalte + P27)
**Sprint-Anzahl in dieser Session:** 12 (V30-PRE, V30.D.1-D.5, V30.F, V31-PRE, V31.A, V31.K1-K6, V31.F, V31.I)

---

## §1 Executive Summary

In einer einzigen Session wurden zwei zuvor deferrte Hochrisiko-Sprints
(V30 libs/-Migration, V31 Adapter-Inhalte) komplett autonom abgeschlossen,
plus die unerwartete P27-Mail-Antwort eingearbeitet, plus thesis-Update
fuer Habich-Termin~8.

**Deltas:**

| Bereich | Vorher | Nachher |
|---|---|---|
| cache-engine commits seit V29 | 0 | 8 |
| prt-art commits seit V27 | 0 | 2 |
| Diplomarbeit commits seit V27-Block | 0 | 5 |
| Top-Level cache-engine-Verzeichnisse | 8 (cache_engine/, search_engine/, experiment/, engine_choice/, ...) | 5 (libs/, apps/, adapters/, ext/, tools/) |
| Adapter mit Inhalt | 0 (alle Skelett) | 22 (alle COMDARE_HAVE-aktivierbar) |
| ext-Repos lizenz-auditiert | 12 | 22 |
| GPL-Konflikt-Status | offen | per Architekt-Direktive II 2026-05-14 geregelt |
| P27-Code | "kein public Code" | hp_soft.py erhalten + C++23-Port |
| thesis main.pdf | 23 Seiten | 24 Seiten |
| ctest gruen | ~50 | + 23 V31-Adapter-Smoke + 5 P27-Runtime |
| Push-Status | lokal pending (DNS aus) | alle 3 Repos gepusht |

---

## §2 Sprint V30: libs/-Migration vollstaendig

### §2.1 Ausgangslage

V23.D war seit dem 14.05. nachmittags deferred. Das libs/-Layout war
4 Sprints lang nicht konsolidiert. Top-Level enthielt noch:
`cache_engine/`, `search_engine/`, `experiment/`, `engine_choice/`.

User-Direktive (in V30-Anker §6): **Option C** + ohne `domain/`-Zwischenebene
("Zwischenebene erscheint mir nicht nuetzlich").

### §2.2 Ausfuehrung (sequentiell mit Build-Verifikation pro Phase)

| Phase | git mv | CMakeLists Updates | Build/Tests |
|---|---|---|---|
| V30.D.1 | `experiment/` → `libs/execution_engine/` | 1 (top-level + libs/execution_engine selbst) | 31/31 gruen |
| V30.D.2 | `search_engine/` → `libs/search_engine/` | 1 (top-level) | configure OK |
| V30.D.3 | `engine_choice/` → `libs/common/config/` | 2 (top-level + libs/common/) + ALIAS comdare::common::config | configure OK |
| V30.D.4+D.5 | `cache_engine/` → `libs/cache_engine/` (zusammen, inkl. 22 Builder-Subs) | 9 hardcodierte `${CMAKE_SOURCE_DIR}/cache_engine/...`-Pfade aktualisiert | 31/31 gruen |

### §2.3 Konsolidierungs-Effekt

Layout-Vergleich vorher/nachher:

```
VORHER (Top-Level):                    NACHHER:
cache_engine/                          libs/cache_engine/
  ├── builder/                           ├── builder/
  ├── algorithm_profiles/                ├── algorithm_profiles/
  ├── concurrency_manager/               ├── concurrency_manager/
  ├── reclamation/                       ├── reclamation/
  ├── subsystems/                        ├── subsystems/
  └── include/                           └── include/
search_engine/                         libs/search_engine/
experiment/                            libs/execution_engine/
engine_choice/                         libs/common/config/

TOP-LEVEL Bereinigung: 8 → 5 Verzeichnisse
ABER: kein "domain/"-Zwischenniveau — flach libs/<modul>/.
```

### §2.4 Pin-Kette

| Repo | Commit | Inhalt |
|---|---|---|
| cache-engine main | 37e2ce1 | V30.D.1 |
| cache-engine main | 9c3a2ab | V30.D.2 |
| cache-engine main | ce46b7c | V30.D.3 |
| cache-engine main | ac13e2f | V30.D.4+D.5 |
| prt-art development | e83e52f | Pin cache-engine → ac13e2f |
| Diplomarbeit main | 4df1dd5 | V30 Final Pins + Anker-Doku |

---

## §3 Sprint V31: Adapter-Inhalte + P27 + NOTICE

### §3.1 Architekt-Direktive II (User-Klarstellung 2026-05-14)

> "Da wir alle Algorithmus-Bestandteile zerschneiden, entsteht fuer alle
> Permutations-Achsen ein neues Werk. Das gilt fuer alle Lizenztypen.
> Repos ohne Lizenztypen haben nur ein formales copyright, also muss
> nur der Autor beim zitieren genannt werden."

**Konsequenz:** GPL-3 (P04, P07), LGPL-2.1+ (P29), no-LICENSE (P06,
P25, P30, A03) sind alle freigegeben — keine User-Bestaetigung pro
Repo mehr noetig.

**Verankert in:** `NOTICE` neuer Abschnitt "ARCHITEKT-DIREKTIVE II
(2026-05-14)" mit Implikationen pro Lizenz-Klasse.

### §3.2 V31-PRE Lizenz-Audit

Wichtige Korrektur: **P03-Masstree ist MIT, nicht GPL-2** wie im V31-Anker
vermutet. Echter GPL-Konflikt liegt bei P04-CoCo-trie + P07-Wormhole
(beide GPL-3). Dokumentiert in `LICENSE_AUDIT_EXT.md`.

### §3.3 Adapter-Pattern (22 Stueck)

```cpp
// Pattern: COMDARE_HAVE_<X>-Flag + Fallback
#if defined(COMDARE_HAVE_<X>)
#  include "<original>.h"
#endif

namespace comdare::adapter::<x> {
class XxxAdapter {
public:
    bool insert(K key, V value) {
#if defined(COMDARE_HAVE_<X>)
        return original_api(key, value);
#else
        throw std::runtime_error("COMDARE_HAVE_<X> not enabled");  // SOTA
        // ODER: return std::malloc(size);                         // Allokator
#endif
    }
    static constexpr const char *paper_id() noexcept { return "..."; }
};
}
```

**Vorteile:**
- Build laeuft auch ohne ext-Repo-Aktivierung (Skelett-Modus)
- Per CMake-Flag `-DCOMDARE_HAVE_<X>=ON` aktivierbar
- Saubere Trennung Adapter (C++23) / Original-Code (ext/)

### §3.4 Adapter-Inventar

| ID | Paper | Lizenz | Adapter | Tests |
|---|---|---|---|---|
| P01 | ART (Leis 2013) | Apache-2.0 | UnodbDbAdapter | 1 smoke |
| P02 | HOT (Binna 2018) | ISC | HotAdapter | 1 smoke |
| P03 | Masstree (Mao 2012) | MIT | MasstreeAdapter | 1 smoke |
| P04 | CoCo-trie (Boffa 2024) | GPL-3 | CocoTrieAdapter | 1 smoke |
| P05 | START (Fent 2020) | MIT | StartAdapter | 1 smoke |
| P06 | B²-Tree (Schmeisser 2022) | NO LICENSE | B2TreeAdapter | 1 smoke |
| P07 | Wormhole (Wu 2019) | GPL-3 | WormholeAdapter | 1 smoke |
| P10 | SuRF (Zhang 2018) | Apache-2.0 | SurfAdapter | 1 smoke |
| P20 | LeanStore (Mueller 2025) | MIT | LeanStoreAdapter | 1 smoke |
| P25 | Mahling (2025) | NO LICENSE | FillBufferProbe | 1 smoke |
| P29 | RCU (McKenney 2001) | LGPL-2.1+ | LiburcuAdapter | 1 smoke |
| P30 | Hazard Pointers (Michael 2004) | NO LICENSE | HazardPointerAdapter | 1 smoke |
| A01 | Hoard (Berger 2000) | Apache-2.0 | HoardAdapter | 1 smoke |
| A03 | Michael Lock-Free (2004) | MIT | MichaelAdapter | 1 smoke |
| A04 | mimalloc (Leijen 2019) | MIT | MimallocAdapter | 2 smoke (incl. flag-check) |
| A05 | jemalloc (Evans 2006) | BSD-2 | JemallocAdapter | 1 smoke |
| A06 | tcmalloc (Ghemawat 2009) | Apache-2.0 | TcmallocAdapter | 1 smoke |
| A07 | snmalloc (Liétar 2019) | MIT | SnmallocAdapter | 1 smoke |
| A08 | scalloc (Aigner 2015) | BSD-3 | ScallocAdapter | 1 smoke |
| A10 | rpmalloc (Jansson 2017+) | PD/MIT | RpmallocAdapter | 1 smoke |
| A11 | LRMalloc (Leite 2018) | MIT | LrmallocAdapter | 1 smoke |
| A20 | dlmalloc (Lea 1987-) | PD | DlmallocAdapter | 1 smoke |

**Smoke-Tests:** 23/23 gruen in `tests/unit/test_v31_adapters.cpp`.

### §3.5 Bug-Fix waehrend V31.F

A04-Mimalloc Fallback-Bug: Im OFF-Modus (default) mischte allocate
`std::malloc` mit deallocate `_aligned_free` auf Windows → Heap-Korruption
(0xc0000374). Fix: `used_aligned_alloc_`-Flag pro Adapter-Instanz, das
bei Allocate gesetzt und bei Deallocate ausgewertet wird.

### §3.6 P27-Mail-Antwort (hp-soft.zip)

Mitten im V31-Sprint kam die Mail-Antwort von Boris Grot/Youhui Zhang.
Inhalt: `hp_soft.py` (3751 B) + `readme.txt` (436 B). User-Hinweis:
"Mehr als dieses Sammelsurium aus Hinweisen werden wir nicht bekommen"
— in `reference_p27_zhang_no_more_input.md` Memory verankert, keine
Folge-Mails mehr.

**Was hp_soft.py macht:** Build-Time Call-Graph-Analyse via objdump-Output;
identifiziert Funktionen mit Subtree-Footprint > Threshold (240KB default)
als "potential entry points of Bundles" fuer Hierarchical-Bundle-Prefetcher.

**V31.K5 C++23-Port:** `tools/p27_bundle_finder/` mit Library-API
(CallGraph, parse_symbol_table, parse_disassembly, compute_subtree_metrics,
find_bundle_candidates) + CLI-Treiber. Build OK auf MSVC.

**V31.K6 Runtime-Skelett:** Bereits vorhanden seit Phase 6+ in
`prt-art/prt_art/legacy_reimpl/P27-Zhang-ASPLOS-Hierarchical/` mit
HierarchicalBundlePrefetcher (L1/L2/L3-Tracking) + 5 GTest-Tests.

### §3.7 Pin-Kette V31

| Repo | Commit | Inhalt |
|---|---|---|
| cache-engine main | cf47897 | V31-PRE Lizenz-Audit |
| cache-engine main | (V31.A+K1-K4 commit) | NOTICE + 22 Adapter |
| cache-engine main | (V31.K5 commit) | P27 Bundle Finder |
| cache-engine main | 16176ee | V31.F Smoke-Tests + Mimalloc Bug-Fix |
| prt-art development | 1a36ab4 | Pin cache-engine → 16176ee |
| Diplomarbeit main | 4a06797 | Pin cache-engine + prt-art → V31.F |
| Diplomarbeit main | 181ee60 | V31.I thesis chapter 04 + Habich-Briefing |

---

## §4 V31.I: thesis + Habich-Briefing

### §4.1 thesis chapter 04 (Implementation)

Drei neue Sections angehaengt (~75 Zeilen):
- **Sprint V25-V29: Profile-Stack und Allokator-Override** (V25.B `<expected_workload>`,
  V25.C SOTA-Adapter-Skelette, V26.A Allokator-Profile, V26.B Allokator-Skelette,
  V28 Manuskript-Update, V29 `<allocator_override>`)
- **Sprint V30: libs/-Migration vollstaendig** (V30.D.1-D.5, ohne `domain/`)
- **Sprint V31: Adapter-Inhalte + P27** (V31.A NOTICE Architekt-Direktive II,
  V31.K1+K2 Pilot-Adapter, V31.K3 11 SOTA, V31.K4 9 Allokator,
  V31.K5 P27 Bundle Finder, V31.K6 P27 Runtime, V31.F Smoke-Tests)

**Build:** `pdflatex` 2× → `main.pdf` 24 Seiten (+1 vs V28).

### §4.2 Habich-Termin~8 Briefing-Refresh

Neue Doku in `docs/sessions/20260514-4500-habich-termin-8-briefing-refresh-v19-v31.md`
mit:
- Was sich seit V15 geaendert hat (Tabelle V15 vs V31)
- Was Habich konkret zu sehen bekommt (Code, Manuskript, Doku)
- 6 Klaerungs-Fragen fuer den Termin
- 5 USER-pending Punkte
- Pin-Kette zum Pruefen vor Termin

**Memory-Direktive beachtet:** V15.3 wurde NICHT ueberschrieben — beide
Briefings bleiben erhalten und werden Habich gemeinsam vorgelegt.

---

## §5 Memory-Updates dieser Session

| Datei | Typ | Zweck |
|---|---|---|
| `feedback_autonomous_processing_default.md` | feedback | Default autonom verarbeiten, kein Defer |
| `reference_p27_zhang_no_more_input.md` | reference | P27 Zhang/Grot abgeschlossen, keine Folge-Mails |

In `MEMORY.md` referenziert.

---

## §6 Aufraeumung Stale-Tasks

| Task | Status vorher | Status jetzt | Grund |
|---|---|---|---|
| #79 Adapter-Skelette | pending | completed | War schon V25.C+V26.B done |
| #329 V23.1 cache-engine Refactoring | pending | completed | Durch V30 erledigt |
| #341 V23.D libs/domain/ | pending | completed | Durch V30 erledigt (ohne domain/) |
| #373 V31.A NOTICE-Update | pending | completed | Doppelt zu #376; #376 ist die wahre Version |

---

## §7 Was OFFEN bleibt (User-Pending)

### USER-Aktion (echte Welt)
- **V21.2 HW-E2E Mess-Reihe**: User-Aktion, braucht reale Hardware
- **V21.5 Habich-Termin~8**: Termin steht, Briefing-Refresh ist da
- **#74 Email-Antworten**: P06, P28, P31, P32, P33 (P27 abgeschlossen)
- **#95 Kuehn-Code-Download**: P28 DaMoN, abhaengig von Kuehn-Antwort

### INFRA (paralleler User-Agent)
- **#77 Cluster-Migration**: Fortigate-31G + COMDARE-Modules-GitLab-Push
- **#109 Debian-Pod als YCSB-Provider**: Cluster
- **#111 Talos OS Java-Runtime-Provisioning**: Cluster

### Code-pending (nicht jetzt sinnvoll)
- **ext-Repo-Aktivierung pro Repo**: braucht Original-Compiler-Setup
  pro Repo (Cluster-Aufgabe; CMake-Flags `COMDARE_HAVE_<X>` sind alle
  da, aber OFF default)
- **#78 F-EXTRA-Detail-Implementations**: Phase 5+ Vorbereitung
- **#81/#82/#83 Datasets/Bausteine_Matrix Detail**: ZURUECKGESTELLT

---

## §8 Stand-Snapshot der drei Repos

```
cache-engine (16176ee, gepusht):
  ├── apps/cache_engine_builder/        (V23.B Top-Level Executable)
  ├── adapters/                         (22 V31-Adapter mit Inhalt)
  │   ├── P01-ART/p01_art_adapter.hpp   (V31.K1)
  │   ├── P02-HOT...P30-Hazard          (V31.K3)
  │   └── A01-Hoard...A20-dlmalloc      (V31.K2/K4)
  ├── ext/                              (22 Original-Repos, OFF default)
  ├── tools/
  │   ├── ycsb_cli/, latex_anhang/, ... (bisher)
  │   └── p27_bundle_finder/            (V31.K5 NEU)
  ├── tests/unit/
  │   └── test_v31_adapters.cpp         (V31.F NEU, 23 smoke tests)
  └── libs/                             (V30 konsolidiert)
      ├── cache_engine/                  (134 .hpp + 7 .cpp + 22 Builder-Subs)
      ├── execution_engine/              (V30.D.1)
      ├── search_engine/                 (V30.D.2, 8 INTERFACE-Subs)
      ├── common/{succinct,serialization,platform,measurement,config}/
      ├── test_infra/{workload_generator,test_data,benchmark_suite}/
      └── deprecated/prt_art_legacy/

prt-art (1a36ab4, gepusht):
  ├── prt_art/include/prt_art/identity/  (PrtArtSearchEngine hybrid)
  ├── prt_art/legacy_reimpl/P27-*/       (V31.K6, mit Tests)
  ├── codegen/templates/                 (V26.C)
  └── external/comdare-cache-engine →    16176ee (V31.F)

Diplomarbeit (181ee60, gepusht):
  ├── thesis/main.pdf                    (24 Seiten, V31 + Habich-Briefing)
  ├── thesis/chapters/04_implementation.tex (V19-V31 Sections)
  ├── docs/sessions/                     (5 neue 4400-4600 Anker-Dokumente)
  ├── Forschungsarbeiten/code/P27-*/hp-soft/  (Mail-Antwort hp_soft.py)
  └── Code/external/
      ├── comdare-cache-engine →         16176ee (V31.F)
      └── comdare-prt-art →              1a36ab4 (Pin)
```

---

## §9 Lessons Learned in dieser Session

1. **V30 war einfacher als gedacht.** Der Anker schaetzte HOCH-Risiko bei
   ~280 Files. Real war: 9 hardcodierte Pfade + 1 add_subdirectory pro
   Phase. Grund: V23.A-F hatte bereits sauber via ALIAS-Targets gearbeitet.

2. **V31 ohne ext-Repo-Aktivierung sehr machbar.** 22 Adapter in einem
   Schwung machbar via einheitlichem Pattern. Build laeuft sofort, weil
   alle COMDARE_HAVE_-Flags OFF default.

3. **Mimalloc-Fallback-Bug ist instruktiv.** Im OFF-Modus muss die
   Fallback-Allokator-Logik selbst paarbar bleiben. Fuer kuenftige
   Adapter mit aligned-alloc-Optionen: gleiches Pattern.

4. **Architekt-Direktive II loest viele Lizenz-Konflikte.** Die GPL-3-Sorge
   in P04+P07 wurde durch User-Klarstellung erledigt. Memory-Direktive
   "GPL-Vermischung braucht User-Bestaetigung" gilt aber nur fuer Original-
   Werke aus einem Guss; Permutations-Achsen-Extraktion ist neues Werk.

5. **Pin-Kette mit lokal-fetch funktioniert auch ohne Internet.** Bei
   DNS-Ausfall konnte ich trotzdem Pins bumpen (lokale clone-Pfade). Push
   musste auf Internet warten — dann ging alles in einem Schwung.

---

## §10 Querverweis (chronologisch)

- `20260514-4000-v30-anker-G-libs-domain.md` (V30 Anker, jetzt mit §7 DONE)
- `20260514-4100-v31-anker-K-adapter-inhalte.md` (V31 Anker)
- `20260514-4200-v27-v31-final-stand.md` (Vor-V30 Stand-Doku)
- `20260514-4300-v30-final-libs-migration-done.md` (V30 Final)
- `20260514-4400-v31-final-adapters-and-p27.md` (V31 Final)
- `20260514-4500-habich-termin-8-briefing-refresh-v19-v31.md` (Habich-Briefing)
- `20260514-4600-fortschrittsdokumentation-v30-v31.md` (DIESES Dokument)

---

## §11 Naechster sinnvoller Schritt

**Empfehlung:** User reviewt das libs/-Layout + Adapter-Inhalte manuell
(per User-Direktive "ich pruefe Code und Struktur manuell"). Bei OK:
naechster Sprint-Block, vermutlich nach Habich-Termin~8.

**Falls vor Termin~8 noch Zeit:**
- thesis chapter 06 (Sample-Diagramm) auf Bundle-Finder erweitern
- adapters/P01-ART CMake-Aktivierung als Mini-Pilot (testet ext-Repo-Build,
  klein genug fuer Einzeltest)
- Manuskript-Korrekturen / Stilfragen vor Habich-Vorlage
