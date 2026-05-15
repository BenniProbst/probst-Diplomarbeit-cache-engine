# Cluster F — Sync + TUD-Habich-Linie

**Stand:** 2026-05-15 (K-F.8)
**Quelle:** `../termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions/cluster_F_sync_tud_habich.md` (648 Z)
**Inhalt:** 6 Paper P08, P29, P30, P31, P32, P33

---

## §1 Cluster-Mitglieder

| P-ID | Paper | Autoren / Jahr / Venue | V31-Adapter |
|---|---|---|---|
| **P08** | The ART of Practical Synchronization | Leis/Scheibner/Kemper/Neumann (2016) | (in OLC-Concurrency, nicht V31.K) |
| **P29** | Read-Copy-Update (RCU) | McKenney et al. (2001, OLS) | `comdare::adapter::p29_rcu::LiburcuAdapter` ✅ LGPL-2.1+ ⚠️ |
| **P30** | Hazard Pointers — Safe Memory Reclamation | Michael (2004, IEEE TPDS 15(6)) | `comdare::adapter::p30_hazard_pointers::HazardPointerAdapter` ✅ no-LICENSE (REV4 F12-K ENTFERNT, RCU bevorzugt) |
| **P31** | Overview of Hardware Optimizations for Database Engines | Ungethuem et al. (2017) — TUD-HABICH | (Survey) |
| **P32** | To Stride or Not to Stride | Schmidt/Kuehn/Krause/Teubner (2025, DIMES) — TUD-HABICH | (Survey + Konsequenzen fuer Stride-Prefetch) |
| **P33** | VAMPIR Poster (SPP2377 Phase-1 Kickoff) | Berthold/Schmidt + PIs Lehner/Habich (2023) — TUD-HABICH | (Tool-Verweis) |

---

## §2 Cluster-Kernkonzepte

### 2.1 Concurrency-Mechaniken (P08, P29, P30)

| Paper | Mechanik |
|---|---|
| P08 Leis 2016 | OLC (Optimistic Lock Coupling) fuer ART |
| P29 McKenney 2001 | RCU (Read-Copy-Update) — Read-Side Wait-Free |
| P30 Michael 2004 | Hazard Pointers — Safe Memory Reclamation fuer Lock-Free |

**REV4 F12-K Beschluss:** Hazard Pointers ENTFERNT, RCU bevorzugt (Begruendung: memory-leak == undefined behavior, RCU bietet sauberes Reclamation-Modell). P30 bleibt aber im Bausteine-Inventar als Adapter-Skelett.

### 2.2 8 Concurrency-Disziplinen (V8.7 INK-3, gespeist aus P08/P29/P30)

1. SingleThreadedRead
2. SingleThreadedWrite
3. MultiReadSingleWrite (Default)
4. MultiReadMultiWrite (mit OLC-Variante von P08)
5. MutexBased
6. SharedMutexBased
7. ScopedLockBased (Hierarchical)
8. RcuBased (mit 6 Flavor-Varianten aus P29 McKenney)

### 2.3 TUD-Habich-Linie (P31, P32, P33)

**P31 Ungethuem 2017** — Survey: Overview of Hardware Optimizations for Database Engines. Sicht in Plattform-Modell (siehe `../architektur/04_konzepte_saeule_b.md`).

**P32 Schmidt 2025 DIMES** — "To Stride or Not to Stride" — Untersuchung von Hardware-Stride-Prefetching. **HBM-Tier-Awareness** + Hugepage-Lehre.

**P33 VAMPIR 2023** — TUD Tool fuer Performance-Tracing. Branch-Prediction-Awareness.

### 2.4 6-Flavor-RCU-Klassifikation (REV5 K08)

Aus P29 McKenney 2001 + V8.7 INK-3:

| RCU-Flavor | Memory-Barrier-Verhalten | Use-Case |
|---|---|---|
| Classic RCU | Sleeping reader | Linux Kernel |
| SRCU (Sleepable RCU) | Reader kann blockieren | Userspace mit Sleep |
| Tasks RCU | Voluntary preemption | Linux Kernel |
| Tree RCU | Hierarchical | Linux Kernel skalierbar |
| Tiny RCU | Single-CPU | Embedded |
| Real-Time RCU | Preemptible reader | RT-Linux |

---

## §3 Vollangaben (siehe Original)

Detail-Konzept-Extraktionen pro Paper:
`../termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions/cluster_F_sync_tud_habich.md`

---

## §4 Bausteine-Matrix-Mapping (Achse 8 Concurrency)

| Bausteine-ID | Achse | Paper |
|---|---|---|
| (OLC-Variante in CONCURRENCY Achse 8) | 8 | P08 |
| (RcuBased Disziplin + 6 Flavors) | 8 | P29 |
| (Hazard Pointers — REV4 ENTFERNT, Skelett bleibt) | 8 | P30 |
| (HBM-Awareness) | 6+5 | P32 |
| (Branch-Prediction-Awareness) | 9 | P33 |

---

## §5 Architekturentscheidungs-Bezug

| Paper | ADR-Bezug |
|---|---|
| P08 | F23 IConcurrencyStrategy (OLC) |
| P29 | F23 IConcurrencyStrategy (RCU); F-EXTRA-6 DecisionLambdaTrees |
| P30 | F12-K (Hazard Pointers ENTFERNT, RCU bevorzugt) — siehe Memory-Direktive `feedback_allocator_basisdisziplin_and_abi_interface` |
| P31 | F13 Cross-Compilation-Toolchain (TUD-Hardware-Survey) |
| P32 | F-EXTRA-7 (HBM-Tier-Awareness, Hugepage-Lehre) |
| P33 | F27 IBranchPredictionAwareStrategy (VAMPIR-Tool-Verweis) |

---

## §6 V31-Code-Stand fuer Cluster F

| Komponente | Pfad |
|---|---|
| Eigene RCU-Implementation (V8.6 Phase 6) | `comdare-cache-engine/libs/cache_engine/reclamation/rcu/` |
| P29 Adapter (Verweis, kein Code-Active) | `comdare-cache-engine/adapters/P29-RCU/p29_rcu_adapter.hpp` |
| P30 Adapter Skelett (F12-K ENTFERNT) | `comdare-cache-engine/adapters/P30-HazardPointers/p30_hazard_pointers_adapter.hpp` |
| ConcurrencyManager mit 8 Disziplinen | `comdare-cache-engine/libs/cache_engine/concurrency_manager/` |
| Plattform-Modell (P31-P33-Bezug) | `comdare-cache-engine/libs/common/platform/` |

---

## §7 Querverweise

- Original-Quelle (UNVERAENDERT): `../termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions/cluster_F_sync_tud_habich.md`
- Cluster D+E (Prefetching): `05_cluster_D_prefetching_1.md` + `06_cluster_E_prefetching_telemetry.md`
- Quellen-Gesamtkatalog: `01_quellen_gesamtkatalog.md` §2 A.3 (Habich-Dresden-Linie) + B (RCU, HP)
- Bausteine-Matrix Achse 8: `../bausteine/01_bausteine_matrix.md` §10
- Architekturentscheidung F23 IConcurrencyStrategy: `../bausteine/04_architekturentscheidungen_F1_F15.md`
- Saeule B Plattform-Modell: `../architektur/04_konzepte_saeule_b.md`
- Memory-Direktive RCU bevorzugt: `~/.claude/.../memory/feedback_allocator_basisdisziplin_and_abi_interface.md`
