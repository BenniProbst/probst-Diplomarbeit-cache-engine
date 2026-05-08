# STRUKTUR_NOTIZ — P29 userspace-rcu (Desnoyers/McKenney)

**Paper:** P29 — McKenney et al. 2001 — "Read-Copy Update" (OLS 2001) — Userspace-Implementation seither industriell weiterentwickelt
**Repo:** `urcu/userspace-rcu` (Mathieu Desnoyers + Paul E. McKenney)
**Lokal:** `Forschungsarbeiten/code/P29-RCU-McKenney/userspace-rcu/`
**Lizenz:** **LGPL-2.1+** (REUSE-compliant; siehe `LICENSE.md`, `LICENSES/`, `lgpl-relicensing.md`). Architekt-Direktive 2026-05-08: LGPL ist KEIN Hinderungsgrund (DYNAMISCH linken erlaubt). Bausteine_Matrix verweist `CONCURRENCY_RCU` jedoch trotzdem auf `ext/P29-RCU/userspace-rcu/` — F2-Beschluss waehlt aber EIGENE RCU-Implementation als bessere Architektur-Wahl.
**Voranalyse:** `_voranalyse_output_klasse_a/P29-RCU-McKenney__userspace-rcu.txt` (2026-05-09)
**Stand der Notiz:** 2026-05-09

---

## 1. Repository-Klassifikation

| Feld | Wert |
|------|------|
| Klasse | A — geklonter Originalcode (Reference Implementation, industriell gepflegt) |
| Originalpaper-Code? | **JA**, Userspace-Adaption durch die OLS-2001-Autoren |
| **Sprache** | **C** (nicht C++!) |
| Build-System | Autotools (`bootstrap`, `configure.ac` 413 Zeilen, `Makefile.am`, `m4/`) |
| Compiler-Anforderungen | gcc/clang; alle Linux-Architekturen unterstuetzt |
| ISA-Anforderungen | viele Architekturen via `include/urcu/arch/*.h`: aarch64, alpha, arm, gcc, hppa, ia64, loongarch, m68k, mips, nios2, ppc, riscv, s390, sparc64, tile, x86, generic |
| Externe Abhaengigkeiten | nur libc + pthread |
| LOC (gesamt source) | 31 228 |
| Top-LOC-Datei | `src/rculfhash.c` (2 342) — RCU-protected lock-free hash table |
| Lizenz-Trennung | Reference: LGPL-2.1+, einige Header optional dual-licensed (siehe `lgpl-relicensing.md`) |
| Architekturen | aarch64, x86_64, ppc, riscv, s390, mips, sparc64, ARM, ia64, alpha, hppa, m68k, nios2, loongarch, tile (=zu allen) |

## 2. Verzeichnis-Hierarchie

```
userspace-rcu/
├── include/urcu/
│   ├── arch/            — pro-Architektur Memory-Barriers + Atomics (16 Dateien)
│   ├── uatomic/         — User-Space-Atomics (uatomic.h, generic.h, x86.h, …)
│   ├── static/          — Header-only Lock-free Datenstrukturen (wfcqueue.h 675 LOC, wfstack.h 452, …)
│   ├── map/             — Mapping zwischen liburcu-Flavors
│   ├── rculfhash.h      — RCU lock-free hash table (666 LOC Header)
│   ├── annotate.h       — Memory-Annotations
│   └── …                — viele weitere Header
├── src/
│   ├── urcu.c           (559)  — Mainline RCU
│   ├── urcu-bp.c        (774)  — RCU Bulletproof
│   ├── urcu-qsbr.c      (516)  — Quiescent State Based RCU
│   ├── urcu-call-rcu-impl.h (1112) — call-rcu Mechanismus
│   ├── urcu-defer-impl.h (476)
│   ├── rculfhash.c      (2342) — RCU lock-free hash table impl
│   └── workqueue.c      (483)
├── tests/
│   ├── benchmark/        — test_urcu_hash, _wfcq, _wfs, _lfs (jeweils 500-700 LOC)
│   ├── regression/rcutorture.h (679 LOC)
│   ├── unit/, common/, utils/
├── doc/examples/         — Code-Beispiele zu hlist, lfstack, list, rculfhash, rculfqueue, urcu-flavors, wfcqueue, wfstack
├── extras/abi/           — ABI-Snapshots fuer 0.9, 0.10, 0.11, 0.12, 0.13, 0.14
├── m4/, scripts/         — Hilfen
├── ChangeLog (49 KB), README.md (17.7 KB), CodingStyle.md
├── LICENSE.md, lgpl-relicensing.md, LICENSES/  — REUSE-compliant
```

## 3. Bausteine-Klassifikation (Achsen 1-11)

| Achse | Identifizierte Implementierung | Quelldatei(en) |
|-------|-------------------------------|----------------|
| **1 Page** | irrelevant — RCU ist Memory-Reclamation, keine Page-Verwaltung | — |
| **2 Node** | irrelevant — generisches Memory-Pattern | — |
| **3 Traversal** | RCU-protected Listen, Hash-Tables, Queues, Stacks | `rculfhash.c`, `cds_*.c` Examples |
| **4 ValueHandle** | Beliebige Pointer mit RCU-Reclamation | API generisch |
| **5 MemoryLayout** | Memory-Reclamation via Quiescent States | `urcu.c`, `urcu-qsbr.c` |
| **6 Allocator** | nicht eigenstaendig | — |
| **7 Prefetch** | nicht relevant | — |
| **8 Concurrency** | **6 RCU-Flavors:** mainline, bulletproof, qsbr, mb (memory-barrier), membarrier, signal — komplette RCU-Family-Implementation | `urcu*.c`, `arch/*` |
| **9 ISA** | komplette Memory-Barrier-Abstraction fuer 17+ Architekturen | `arch/aarch64.h`, `x86.h`, `arm.h`, `riscv.h` etc. |
| **10 Measurement** | umfangreiche Benchmark-Suite (`tests/benchmark/`) | `tests/benchmark/` |
| **11 Telemetry-Strategy** | Histogram (1 Datei grep) — keine ausgepraegte Telemetrie | grep |

**Hervorhebung:** P29 ist die **kanonische Userspace-RCU-Implementation der Originalpaper-Autoren**. Ist Konzept-Quelle fuer Task #104 (eigene comdare-RCU).

## 4. Adapter-Strategie fuer comdare-cache-engine

| Strategie-Punkt | Entscheidung |
|-----------------|--------------|
| Einbindung-Form | **F2-Beschluss: KEIN direkter Code-Adapter** — COMDARE nutzt **eigene RCU**-Implementation (Task #104). userspace-rcu dient als Konzept-Referenz. **Kein Lizenz-Block** (LGPL erlaubt dynamic-linking), sondern Architektur-Wahl. |
| Lizenz-Vermerk | LGPL-2.1+ — dynamic-linking waere erlaubt; Bausteine_Matrix listet trotzdem `CONCURRENCY_RCU → ext/P29-RCU/userspace-rcu/ [P29 LGPL — DYNAMISCH linken!]` als Fallback-Pfad falls eigene RCU verzoegert |
| Compiler-Layering (F-EXTRA-1) | C-Code; falls eingebunden mit GCC 4+ (sehr breit unterstuetzt); `extern "C"`-Anbindung im C++23-Modul-Wrapper |
| Memory-Barrier-Architektur | `include/urcu/arch/*.h` ist sehr lehrreich — wir uebernehmen das Pattern fuer COMDARE-eigene Memory-Barriers |
| 6 RCU-Flavors | Mainline, Bulletproof, **QSBR**, MB, Membarrier, Signal — Konzept-Quelle. PRT-ART eigene RCU implementiert wahrscheinlich QSBR (passend zu OLC) |
| Talos-Kompatibilitaet | userspace-rcu unterstuetzt aarch64+x86_64 — beide auf COMDARE-Production (Ryzen 9950X3D + i9-14900KS) verfuegbar |
| LEGACY_REIMPL-Bedarf | **JA** — Task #104 ist die eigentliche eigene Implementation. Pfad: `cache_engine/reclamation/comdare_rcu/` (gemaess F2-Praezisierung im Habich-Feedback). KEIN klassisches `legacy_reimpl/`-Skelett, sondern Production-Code. |

## 5. Code-Qualitaets-Bewertung (Habich H2: Quelle/Ziel/Aenderung)

| Kriterium | Bewertung (★ 1-5) | Begruendung |
|-----------|-------------------|-------------|
| Quelle gepflegt | ★★★★★ | Industriell gepflegt seit 2009; ChangeLog 49 KB; ABI-Snapshots fuer 6 Versionen; aktiv 2025 (SPDX 2025 EfficiOS) |
| Doku-Qualitaet | ★★★★★ | README 17.7 KB, CodingStyle.md, doc/examples mit 33+ Beispielen, ABI-Doku, lgpl-relicensing.md |
| Test-Abdeckung | ★★★★★ | umfassende benchmark+regression+unit Suite, rcutorture (679 LOC) |
| Ueberein­stimmung mit Originalpaper | ★★★★★ | Co-Author McKenney maintaint dies; produktionsreife Userspace-Adaption |
| Adapter-Aufwand | ★★★ | LGPL erlaubt Linking; F2-Beschluss waehlt aber eigene Lib aus Architektur-Gruenden (Optimierungs-Kontrolle) |
| **Bauszenario** | **Quelle:** LGPL-2.1+, C, 17 Architekturen, 6 RCU-Flavors → **Ziel:** eigene `comdare-rcu` in C++23 fuer x86+aarch64 (Task #104, Pfad `cache_engine/reclamation/comdare_rcu/`) → **Aenderung:** Vollstaendig neu implementieren mit C++23-Atomics, QSBR-Variante als Default |

## 6. Compile-Test-Plan

| Aktion | Erfolgs-Kriterium |
|--------|-------------------|
| (a) Klon im Cluster | ✅ erledigt |
| (b) Autotools-Build | OPTIONAL — nur fuer Konzept-Verifikation lokal |
| (c) rcutorture-Lauf | OPTIONAL |
| (d) Adapter-Build | **ENTFAELLT** — eigene RCU per Task #104 |

## 7. Offene Punkte / Beobachtungen

- **F2-Beschluss „eigene RCU"**: Begruendung war Build-Komplexitaet + Architektur-Entscheidung. Die produktive comdare-RCU-Implementation ist Task #104.
- **`include/urcu/arch/*.h` als Vorlage:** sehr lehrreich; zeigt, wie pro-Architektur Memory-Barriers + Atomics abstrahiert werden. Konzept-Quelle fuer COMDARE Memory-Barrier-Schicht (insbes. fuer aarch64-Compat fuer Cluster-Knoten i9 + Ryzen X3D).
- **6 RCU-Flavors:** Auswahl fuer COMDARE = QSBR (passend zu unodb-OLC F8). Alternative: Membarrier (membarrier(2)-syscall, schneller).
- **REUSE-Compliance:** `LICENSE.md` + `LICENSES/`-Verzeichnis — wir muessen unsere comdare-RCU ebenfalls REUSE-compliant machen, aber nicht-LGPL.
- **`rculfhash.c` 2 342 LOC:** lock-free hash table als RCU-Anwendung — nicht direkt fuer PRT-ART noetig, aber Studienreferenz.

## 8. Verweise

- **Voranalyse-Output:** `_voranalyse_output_klasse_a/P29-RCU-McKenney__userspace-rcu.txt`
- **NOTICE-Eintrag:** `comdare-cache-engine/NOTICE` (LGPL-2.1+, Konzept-Quelle, Copyright Desnoyers/McKenney/EfficiOS)
- **Bausteine_Matrix:** Achse 8 RCU_QSBR (P29 Konzept), 6 RCU-Flavors-Vergleich (P29)
- **Re-Impl. Modul:** Task #104 — eigene `comdare-rcu` in C++23
- **Memory-Barrier-Schicht:** `include/urcu/arch/*.h` als Vorlage fuer COMDARE-eigene Architektur-Abstraction
