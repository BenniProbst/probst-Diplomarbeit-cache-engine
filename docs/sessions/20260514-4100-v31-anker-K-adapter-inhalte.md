# V31 (K) — Anker: Adapter-Inhalte wirklich implementieren (2026-05-14, 41:00)

**Vorgaenger:** `20260514-4000-v30-anker-G-libs-domain.md`
**Hauptthema:** K — Adapter-Inhalte (P01-P30 + A01-A20)
**Risiko:** **HOCH** (21 INTERFACE-Adapter, jeder braucht ext/-Repo-Aktivierung,
                     Header-Code, Tests, ggf. Lizenz-Updates in NOTICE)
**Status:** **ANKER NUR — keine Code-Aenderung in V31 ohne User-Approval**

---

## §1 Was K ist

V25.C + V26.B haben 21 Adapter-Sub-Dirs in cache-engine `adapters/`
aktiviert (11 SOTA + 10 Allokator). Heute sind das alle **leere
INTERFACE-Libs mit nur README + CMakeLists**. Inhalt: 0 Header-Files,
0 Implementations.

V31 wuerde pro Adapter 2-5 Header-Files schreiben, die zwischen
Original-API (im ext/-Submodule) und unseren `comdare::*` C++23-Concepts
uebersetzen.

---

## §2 Was pro Adapter rein muss

Pro SOTA-Adapter (z.B. P01-ART):
| File | Zweck |
|---|---|
| `<adapter>_db_adapter.hpp` | Wrapper Original-API → ICacheEngine/ISearchEngine |
| `<adapter>_workload_runner.hpp` | YCSB-Workload-Setup + run_workload-Implementation |
| `<adapter>_traits.hpp` | Plattform-Probe (NUMA, AVX2, ...) — optional |

Pro Allokator-Adapter (z.B. A01-hoard):
| File | Zweck |
|---|---|
| `<adapter>_adapter.hpp` | Wrapper malloc/free → IAllocator |
| `<adapter>_traits.hpp` | NUMA, thread_local Properties — optional |

**Geschaetzt:** 11 SOTA × 2-3 Files + 10 Allokator × 1-2 Files
= ca. 35-50 Header-Files.

---

## §3 Voraussetzungen

### 3.1 ext/-Repos aktiviert
Aktuell sind alle ext/P*-Repos und ext/A*-Repos geklont, aber NICHT
gebaut. Das `art_body.hpp.template` (V21.1) hat einen `#if
defined(COMDARE_HAVE_UNODB)` Block — das Pattern ist klar, aber niemand
aktiviert das Flag.

V31 braucht:
1. Pro ext/-Repo: CMake-Aktivierungs-Logik in `ext/CMakeLists.txt`
2. Pro Adapter: `target_link_libraries(comdare_adapter_p01_art INTERFACE unodb)`
3. NOTICE-Datei aktualisieren (12+ Lizenzen aus ext/)

### 3.2 Lizenz-Compliance
- P01-ART/unodb: Apache-2.0 → NOTICE
- P02-HOT: BSD-3
- P03-Masstree: BSD-3 / GPL-2 (CRITICAL — GPL-2 vermischt sich nicht mit Apache-2.0)
- P04-CoCo-trie: Apache-2.0
- ...

**Memory-Direktive K35:** "VOR Loeschen/Einschraenken IMMER Rueckfragen"
— gilt auch fuer Lizenz-Vermischung. **GPL-2-Komponenten brauchen
explizite User-Bestaetigung.**

### 3.3 Build-Verifikation pro Adapter
Aktivierung eines ext-Repos kann fehlschlagen (CMake-Inkompatibilitaet,
Plattform-spezifische Macros, etc.). Pro Adapter:
1. Wir aktivieren ext-Build via CMake-Flag
2. Header-Adapter schreiben + cmake configure
3. Build verifizieren auf MSVC + GCC
4. Tests (mind. konstruieren + destroying ohne crash)

---

## §4 V31-Plan (bei User-Approval)

| # | Phase | Risiko |
|---|---|---|
| V31-PRE | Lizenz-Audit aller 22 ext/-Repos (ist GPL-2 in P03-Masstree, etc.) | mittel |
| V31.A | NOTICE-Datei aktualisieren mit allen Lizenzen | niedrig |
| V31.K1 | P01-ART unodb-Adapter (Pilot, Apache-2.0, einfach) | mittel |
| V31.K2 | A04-mimalloc-Adapter (Pilot Allokator, MIT, einfach) | mittel |
| V31.K3 | Restliche 9 SOTA-Adapter | hoch |
| V31.K4 | Restliche 9 Allokator-Adapter | hoch |
| V31.F | Tests + Pin-Bumps + Doku | mittel |

**Geschaetzte Dauer:** ~3-5 Sessions, jede Phase braucht ext-Repo-Build-Verifikation.

---

## §5 Risiko gegen Nutzen

**Risiko:**
- 35-50 neue Files in cache-engine adapters/
- 22 ext-Repos werden gebaut (Plattform-Inkompatibilitaeten moeglich)
- GPL-2 in P03-Masstree (Lizenz-Vermischung mit Apache-2.0-Code)
- NOTICE-Update + ggf. LICENSE-Update

**Nutzen:**
- Adapter sind die Voraussetzung fuer die Mess-Reihe V21.2
  (echte Vergleichbarkeit Pruefling-vs-SOTA)
- Habich-Direktive verlangt explizit Adapter-Pattern (Termin~7)

---

## §6 Empfehlung

V31 ist die **direkteste Voraussetzung fuer V21.2 (HW-E2E)**. Ohne
Adapter-Inhalte gibt es keine echte Vergleichbarkeit Pruefling-vs-SOTA.

**Aber:** V31 hat 3 Risiko-Dimensionen, die User-Bestaetigung brauchen:
1. **Lizenz-Audit** (insb. GPL-2 in P03-Masstree)
2. **ext-Repo-Build-Aktivierung** (kann auf MSVC fehlschlagen)
3. **Adapter-API-Design** (welche Concepts wirklich konsumiert werden,
   z.B. ISearchEngine + IAllocator + ICachePage)

**Alternative:** V31.K1-Pilot (P01-ART unodb) als Proof-of-Concept,
um die 3 Risikodimensionen einzeln zu verifizieren.

---

## §7 V31 STOPP-Punkt

**Naechster Schritt:** USER-Entscheidung:
- Option A: V31 komplett deferrieren bis nach V21.2 + Habich-Termin~8
- Option B: V31.K1-Pilot autonom (1 Adapter, P01-ART unodb)
- Option C: Lizenz-Audit V31-PRE autonom + User entscheidet ueber Rest
- Option D: V31.A-K4 sequentiell autonom (3-5 Sessions)

**Bis zur Entscheidung:** keine ext-Repo-Aktivierung, keine Adapter-Header.

---

## §8 Querverweis V27-V31

| Sprint | Risiko | Status |
|---|---|---|
| V27 (N) PROJECT_LAYER_MAPs | niedrig | DONE |
| V28 (M) thesis ch02 SOTA-Tabellen | niedrig | DONE |
| V29 (L) ExperimentDriver Allokator-Override | mittel | DONE (Infrastruktur) |
| V30 (G) libs/domain/ Migration | HOCH | ANKER + STOPP |
| V31 (K) Adapter-Inhalte | HOCH | ANKER + STOPP |

3 von 5 Themen autonom abgeschlossen. 2 hochrisikante warten auf User-Entscheidung.
