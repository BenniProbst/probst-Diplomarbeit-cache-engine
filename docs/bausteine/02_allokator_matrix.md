# Allokator-Matrix — Master (Konsolidierung)

**Stand:** 2026-05-15 (K-E.3)
**Quelle:** `../termine/20260508 Termin 7/Allokator_Matrix.txt` (801 Zeilen)
**Erweitert um:** V31-Adapter-Status-Spalte

---

## §1 Zweck

Die Allokator-Matrix ist die parallele Struktur zur Bausteine-Matrix
(`01_bausteine_matrix.md`), aber fuer Memory-Allokatoren (A01-A23). Sie
hat **7 Achsen** (AA1-AA7) statt der 11 Achsen der Algorithmus-Bausteine.

PRT-ART nutzt Allokatoren als **Bausteine-Achse 6** in der Algorithmus-
Matrix UND als eigene F15-Permutations-Dimension.

---

## §2 7 Achsen (Allokator-Permutations-Dimensionen)

| Achse | Name | Bedeutung | Quelle (Z) |
|---|---|---|---|
| AA1 | FREE-LIST-TOPOLOGIE | Wie ist die Free-List strukturiert (Single, Per-Thread, Per-Page, Sharded) | 38 |
| AA2 | SIZE-CLASS-SCHEMA | Welche Groessen-Klassen + wie ausgelegt | 200 |
| AA3 | THREAD-LOCALITY | Per-Thread vs Per-CPU vs Global Cache | 274 |
| AA4 | SYNCHRONIZATION | Lock vs Lock-Free vs Message-Passing | 328 |
| AA5 | ALLOCATION-POLICY | First-Fit vs Best-Fit vs Sharding-First | 414 |
| AA6 | RECLAMATION | Bulk-Free vs Decommit vs Compact | 491 |
| AA7 | FRAGMENTATION-STRATEGY | Buddy vs Slab vs Region vs No-Compact | 596 |

---

## §3 23 Allokator-Quellen (A01-A23) mit V31-Adapter-Status

| ID | Paper | Lizenz | V31-Adapter | Quelle (Z) |
|---|---|---|---|---|
| A01 | Hoard (Berger ASPLOS 2000) | Apache-2.0 | `comdare::adapter::a01_hoard::HoardAdapter` ✅ | 50, 209, 283, 337, 428, 506 |
| A02 | Bonwick Slab (Linux SLUB / illumos kmem) | CDDL/GPL | (nicht geklont, ext-Repo offen) | 778 |
| A03 | Michael Lock-Free (PLDI 2004 Re-Impl) | MIT (IBM patent) | `comdare::adapter::a03_michael::MichaelAdapter` ✅ | (verstreut) |
| A04 | mimalloc (Leijen MSR 2019, APLAS 2019) | MIT | `comdare::adapter::a04_mimalloc::MimallocAdapter` ✅ | 72, 233, 293, 355, 524 |
| A05 | jemalloc (Evans BSDCan 2006) | BSD-2 | `comdare::adapter::a05_jemalloc::JemallocAdapter` ✅ | 80, 220, 293, 361, 530 |
| A06 | tcmalloc (Google 2009 / Modern 2024) | Apache-2.0 | `comdare::adapter::a06_tcmalloc::TcmallocAdapter` ✅ | 87, 227, 293, 299, 366, 536 |
| A07 | snmalloc (Lietar et al. ISMM 2019) | MIT | `comdare::adapter::a07_snmalloc::SnmallocAdapter` ✅ | 95, 246, 293, 371, 440 |
| A08 | scalloc (Aigner et al. OOPSLA 2015) | BSD-3 | `comdare::adapter::a08_scalloc::ScallocAdapter` ✅ | 102, 240, 376 |
| A09 | NUMAlloc (Tongping Liu UMass) | (Forschungsprototyp) | (nicht geklont) | 778 |
| A10 | rpmalloc (Jansson Public Domain/MIT) | PD/MIT | `comdare::adapter::a10_rpmalloc::RpmallocAdapter` ✅ | 116, 386 |
| A11 | LRMalloc (Leite/Rocha VECPAR 2018) | MIT | `comdare::adapter::a11_lrmalloc::LrmallocAdapter` ✅ | (verstreut) |
| A12 | CAMA (Saarland Forschungsprototyp) | n/a | (nicht geklont) | 778 |
| A13 | StarMalloc (Inria-Prosecco F*) | (komplexer Build) | (nicht geklont) | 778 |
| A14 | tcmalloc Warehouse-Scale Characterization (Zhou ASPLOS 2024) | (covered by A06) | (siehe A06) | (n/a) |
| A15 | HMalloc | (IEEE Code unklar) | (nicht geklont) | 778 |
| A16 | PIM-malloc (VIA-Research, UPMEM-Hardware) | (UPMEM-only) | (nicht geklont) | 778 |
| A17 | Crystalline (Penn State, Ruslan Nikolaev) | n/a | (nicht geklont) | 778 |
| A18 | Exgen-Malloc (UT Austin SysML) | n/a | (nicht geklont) | 278, 778 |
| A19 | Buddy (Linux mm/page_alloc.c als Reference) | (Eigene Re-Impl) | (Skelett) | 278, 332, 778 |
| A20 | dlmalloc (Doug Lea 1987-, Public Domain) | PD | `comdare::adapter::a20_dlmalloc::DlmallocAdapter` ✅ | 42, 256, 278, 418, 423, 495 |
| A21 | ptmalloc2 (glibc 2.26+, LGPL) | LGPL | (System default, nicht geklont) | 293, 361, 473, 495, 778 |
| A22 | N3916 PMR (C++17 Standard-Library) | (Compiler-included) | (Compiler-included) | 778 |
| A23 | Vmem+Magazines (illumos kmem.c / FreeBSD UMA) | CDDL | (nicht geklont) | 778 |

**V31 implementiert: 10 Adapter** (A01, A03, A04, A05, A06, A07, A08, A10, A11, A20).
**V31 nicht implementiert: 13** (A02, A09, A12-A19, A21-A23 — Forschungsprototypen oder Hardware-only).

---

## §4 5 Allokator-Cluster (AC1-AC5)

Aus Phase 6.2.B Tieflektuere (Sessions 168-172):

| Cluster | Name | Quelle (Z) | A-IDs |
|---|---|---|---|
| AC1 | Foundation Allokatoren | (Phase 6.2.B Cluster AC1) | A20 dlmalloc, A21 ptmalloc2 |
| AC2 | Modern Production | (Phase 6.2.B Cluster AC2) | A04 mimalloc, A05 jemalloc, A06 tcmalloc |
| AC3 | NUMA + Hardware | (Phase 6.2.B Cluster AC3) | A09 NUMAlloc, A14 (in A06), A15 HMalloc, A16 PIM-malloc |
| AC4 | Concurrent + Formal | (Phase 6.2.B Cluster AC4) | A03 Michael, A07 snmalloc, A11 LRMalloc, A13 StarMalloc, A17 Crystalline, A22 N3916 PMR |
| AC5 | Standard + Optimizing | (Phase 6.2.B Cluster AC5) | A01 Hoard, A08 scalloc, A10 rpmalloc, A18 Exgen, A19 Buddy, A23 Vmem+Magazines |

---

## §5 PRT-ART Pool-Mapping zu Allokator-Achsen (Z 719-744)

PRT-ART nutzt 4+2 Allocator-Pools:

| Pool | Inhalt | Empfohlene AA-Konfiguration |
|---|---|---|
| A | Trie-Inner-Knoten | AA3=PerThread, AA4=Lockfree, AA1=PerPageType |
| B | Trie-Leaf-Knoten | AA3=PerThread, AA4=Lockfree, AA7=Compact |
| C | Page-Header (kleine Allocs) | AA2=Slab, AA1=PerCacheLine |
| D | Page-Body (grosse Allocs) | AA2=BuddyOrSlab, AA7=Decommit |
| R | Reclamation-Buffer (RCU) | AA6=BulkFree |
| V | ValueHandle-Storage | AA5=BestFitOrInline |

(Sub-Variant: V-static + V-dynamic je nach VALUEHANDLE-Achse)

---

## §6 Cross-Paper-Permutations-Matrix (Auszug, Z 666-717)

Welche Allokator-Paper teilen welche Konzepte? Siehe Original-Datei.

---

## §7 Implementierungs-Pfade (Phase 6.2.C Klone-Plan, Z 746-777)

10 Allokator-Repos sind in `Code/external/comdare-cache-engine/ext/A*/` geklont (siehe `LICENSE_AUDIT_EXT.md`).

```
ext/A01-hoard/
ext/A03-michael-lockfree/
ext/A04-mimalloc/
ext/A05-jemalloc/
ext/A06-tcmalloc/
ext/A07-snmalloc/
ext/A08-scalloc/
ext/A10-rpmalloc/
ext/A11-lrmalloc/
ext/A20-dlmalloc/
```

---

## §8 V31-Adapter-Pattern fuer Allokatoren

Pattern fuer alle 10 V31-Allokator-Adapter:

```cpp
namespace comdare::adapter::axx_<name> {
class XxxAdapter {
public:
    [[nodiscard]] void *allocate(std::size_t size) {
#if defined(COMDARE_HAVE_<X>)
        return <name>_malloc(size);
#else
        return std::malloc(size);  // Fallback, kein throw
#endif
    }
    void deallocate(void *p) noexcept {
#if defined(COMDARE_HAVE_<X>)
        <name>_free(p);
#else
        std::free(p);
#endif
    }
    static constexpr const char *paper_id() noexcept { return "Axx-..."; }
};
}
```

Smoke-Test: `tests/unit/test_v31_adapters.cpp` — 10/10 Allokator-Tests gruen.

---

## §10 N-Phase Faltung 2026-05-18 — Allokatoren in Sub-Achsen 6.1-6.5 reorganisiert

**Trigger:** N.9 (#472), User-Direktive Allokations-Strategien feingliedrig
**Pflicht-Pre-Read:** `07_bausteine_matrix_N_erweitert.md` §2 (Achse 6 Split)

### §10.1 Aenderung: AA1-AA7 -> 6.1-6.5

Vor N: 7 Allokator-Achsen AA1-AA7 als Hauptachsen.
Nach N: Allokatoren als Bausteine in Sub-Achsen 6.1-6.5 der Bausteine-Matrix.

| AA-Achse (alt) | Sub-Achse (neu) | Beschreibung |
|---|---|---|
| AA1 Allocation-Strategy | **6.1** | slab/buddy/region/pool/object-cache/stack-allocator |
| AA2 Huge-Page-Policy | **6.4** | transparent (THP), explicit (madvise), none |
| AA3 Free-List-Strategy | **6.5** | size-class/best-fit/first-fit/segregated-fit |
| AA4 Reclamation-Policy | **6.2** | epoch/RCU/HP/QSBR/mark-sweep |
| AA5 NUMA-Affinity | **6.3** | local/interleave/preferred/bind/none |
| AA6 Concurrent-Discipline | (Sonderfall, gehoert eigentlich zu Achse 8.1) | lock-free/coarse-locked/fine-locked |
| AA7 Special-Hardware-Bind | (Sonderfall, gehoert eigentlich zu Achse 12.3) | GPU-Allocator/HBM-Allocator/Persistent-Memory |

### §10.2 23 Allokatoren A01-A23 mit neuer Sub-Achsen-Zuordnung

| Allokator | 6.1 Allocation | 6.2 Reclamation | 6.3 NUMA | 6.4 HugePage | 6.5 FreeList |
|---|---|---|---|---|---|
| A01 Hoard | object-cache | mark-sweep | local | transparent | size-class |
| A02 Lockless | pool | epoch | local | none | first-fit |
| A03 Michael Lock-Free | pool | hazard-pointer | local | none | best-fit |
| A04 mimalloc | slab | thread-local | local | transparent | size-class |
| A05 jemalloc | slab | thread-local | local | transparent | size-class |
| A06 tcmalloc | slab + thread-cache | thread-local | local | transparent | size-class |
| A07 snmalloc | message-passing | epoch | local | transparent | size-class |
| A08 scalloc | per-CPU + size-class | epoch | local | transparent | size-class |
| A09 Hoard-extended | object-cache | mark-sweep | local | transparent | size-class |
| A10 rpmalloc | thread-local + global | RCU | local | transparent | size-class |
| A11 LRMalloc | lock-free | epoch | local | transparent | size-class |
| A12 SuperMalloc | pool + arena | mark-sweep | NUMA-aware | transparent | best-fit |
| A13 Streamflow | per-CPU + lock-free | hazard-pointer | NUMA-aware | transparent | best-fit |
| A14 NUMA-aware | region + pool | epoch | NUMA-aware | explicit | size-class |
| A15 Memkind (HBM) | region | mark-sweep | NUMA-aware | explicit | best-fit |
| A16 HBM-Allocator | region | RCU | preferred (HBM) | explicit | best-fit |
| A17 PMDK (Persistent) | region + log | epoch + persistence | local | none | best-fit |
| A18 PMEM-vmalloc | region + log | epoch | local | explicit | size-class |
| A19 Coz (Causal) | wrapper + profiling | mark-sweep | local | none | first-fit |
| A20 dlmalloc | best-fit | mark-sweep | none | none | best-fit |
| A21 LZ-FAST | size-class | epoch | NUMA-aware | transparent | size-class |
| A22 Multi-Tier (HBM+DRAM+NVRAM) | region + tier-cache | epoch | preferred (HBM) | explicit | best-fit |
| A23 Idma-Allocator | region | mark-sweep | NUMA-aware | explicit | best-fit |

### §10.3 5 Cluster AC1-AC5 (BLEIBEN als Cluster, orthogonal zu Sub-Achsen)

| Cluster | Allokatoren | Cluster-Eigenschaft |
|---|---|---|
| AC1 Foundation | A04, A05, A06 | Modern production-grade (mimalloc/jemalloc/tcmalloc) |
| AC2 Lock-Free | A02, A03, A07, A11, A13 | Lock-free + Hazard-Pointer-Familie |
| AC3 NUMA + Hardware | A14, A15, A16, A22, A23 | NUMA-aware + HBM/Persistent |
| AC4 Standard | A01, A09, A20 | Traditionelle Allokatoren |
| AC5 Special | A17, A18, A19, A21 | Profiling / Persistent / LZ-Fast |

Cluster sind orthogonal zu Sub-Achsen — pro Cluster-Klasse koennen mehrere Sub-Achsen-Auspraegungen vorkommen.

---

## §9 Querverweise

- Original-Quelle (UNVERAENDERT): `../termine/20260508 Termin 7/Allokator_Matrix.txt`
- Bausteine-Matrix Achse 6: `01_bausteine_matrix.md` §8 (K-E.2)
- Forschungslandkarte Allokator-Cluster: `../forschungslandkarte/08_allokator_cluster_AC1_AC5.md` (K-F.9)
- LICENSE-Audit fuer Adapter: `../../Code/external/comdare-cache-engine/LICENSE_AUDIT_EXT.md`
- NOTICE-Datei: `../../Code/external/comdare-cache-engine/NOTICE` (Architekt-Direktive II)
- Adapter-Code: `../../Code/external/comdare-cache-engine/adapters/A*/`
- Smoke-Tests: `../../Code/external/comdare-cache-engine/tests/unit/test_v31_adapters.cpp`
