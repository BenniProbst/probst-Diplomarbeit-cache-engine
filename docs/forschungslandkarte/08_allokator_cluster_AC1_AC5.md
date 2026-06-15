# Allokator-Cluster AC1-AC5 + 7 Achsen AA1-AA7

**Stand:** 2026-05-15 (K-F.9)
**Quellen:**
- `../termine/20260508 Termin 7/Allokator_Matrix.txt` (801 Z, Architekt-Direktive 2026-05-13 REV7 §2)
- `../termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions_allocators/` (alle Paper-Extraktionen)
**Inhalt:** 23 Allokator-Paper A01-A23 in 5 Cluster + 7 Achsen

---

## §1 7 Allokator-Achsen (AA1-AA7)

| Achse | Name | Bedeutung |
|---|---|---|
| **AA1** | FREE-LIST-TOPOLOGIE | Wie ist die Free-List strukturiert (Single, Per-Thread, Per-Page, Sharded) |
| **AA2** | SIZE-CLASS-SCHEMA | Welche Groessen-Klassen + wie ausgelegt |
| **AA3** | THREAD-LOCALITY | Per-Thread vs Per-CPU vs Global Cache |
| **AA4** | SYNCHRONIZATION | Lock vs Lock-Free vs Message-Passing |
| **AA5** | ALLOCATION-POLICY | First-Fit vs Best-Fit vs Sharding-First |
| **AA6** | RECLAMATION | Bulk-Free vs Decommit vs Compact |
| **AA7** | FRAGMENTATION-STRATEGY | Buddy vs Slab vs Region vs No-Compact |

Detail: `../bausteine/02_allokator_matrix.md` §2.

---

## §2 5 Cluster (AC1-AC5)

### AC1 — Foundation Allokatoren

**Quelle:** Phase 6.2.B Cluster AC1 — Tieflektuere foundationaler Allokatoren

| A-ID | Paper / Allokator | V31-Adapter |
|---|---|---|
| A20 | dlmalloc (Doug Lea 1987-, Public Domain) | ✅ `comdare::adapter::a20_dlmalloc::DlmallocAdapter` |
| A21 | ptmalloc2 (glibc 2.26+, LGPL) | (System default) |

**Charakter:** Klassische single-arena Allokatoren, Buddy + Best-Fit. dlmalloc Referenz-Implementierung der "boundary tags + bins + treebins"-Architektur.

### AC2 — Modern Production

**Quelle:** Phase 6.2.B Cluster AC2 — Modern Production-Grade Allokatoren

| A-ID | Paper / Allokator | V31-Adapter |
|---|---|---|
| A04 | Mimalloc (Leijen MSR 2019, APLAS 2019) | ✅ `MimallocAdapter` MIT |
| A05 | jemalloc (Evans BSDCan 2006) | ✅ `JemallocAdapter` BSD-2 |
| A06 | TCMalloc (Google 2009 / Modern 2024 Zhou ASPLOS) | ✅ `TcmallocAdapter` Apache-2.0 |

**Charakter:** Multi-Arena + Thread-Cache + Size-Classes. Modernste Production-Implementierungen.

### AC3 — NUMA + Hardware

**Quelle:** Phase 6.2.B Cluster AC3 — NUMA + Hardware-spezifisch

| A-ID | Paper / Allokator | V31-Adapter |
|---|---|---|
| A09 | NUMAlloc (Liu/Berger 2023, ISMM) | (nicht geklont) |
| A14 | tcmalloc Warehouse-Scale (Zhou 2024 ASPLOS) | (in A06 enthalten) |
| A15 | HMalloc | (IEEE Code unklar) |
| A16 | PIM-malloc | (UPMEM-Hardware-only) |

**Charakter:** NUMA-aware Allocation, Cache-Locality. HBM-Ebenen-Awareness (P32 Schmidt TUD).

### AC4 — Concurrent + Formal

**Quelle:** Phase 6.2.B Cluster AC4 — Lock-Free + Formal Verified

| A-ID | Paper / Allokator | V31-Adapter |
|---|---|---|
| A03 | Maged Michael Lock-Free (PLDI 2004 Re-Impl) | ✅ `MichaelAdapter` MIT (IBM-Patent) |
| A07 | snmalloc (Lietar et al. ISMM 2019) | ✅ `SnmallocAdapter` MIT |
| A11 | LRMalloc (Leite/Rocha 2018 VECPAR) | ✅ `LrmallocAdapter` MIT |
| A13 | StarMalloc (Bourgeat/Erbsen 2024 arXiv) | (komplexer F* Build, nicht geklont) |
| A17 | Crystalline (Penn State, Ruslan Nikolaev) | (nicht geklont) |
| A22 | N3916 PMR (C++17 Standard-Library) | (Compiler-included) |

**Charakter:** Lock-Free Allocation + Message-Passing. A13 StarMalloc ist formal verifiziert.

### AC5 — Standard + Optimizing

**Quelle:** Phase 6.2.B Cluster AC5 — Klassische + Optimierende Allokatoren

| A-ID | Paper / Allokator | V31-Adapter |
|---|---|---|
| A01 | Hoard (Berger/McKinley/Blumofe/Wilson 2000 ASPLOS) | ✅ `HoardAdapter` Apache-2.0 |
| A08 | scalloc (Aigner/Kirsch/Lippautz/Sokolova 2015 OOPSLA) | ✅ `ScallocAdapter` BSD-3 |
| A10 | rpmalloc (Mattias Jansson 2017+) | ✅ `RpmallocAdapter` PD/MIT |
| A18 | Exgen-Malloc (UT Austin SysML) | (nicht geklont) |
| A19 | Buddy (Linux mm/page_alloc.c als Reference) | (Eigene Re-Impl Skelett) |
| A23 | Vmem+Magazines (illumos kmem.c / FreeBSD UMA) | (nicht geklont, CDDL) |

**Charakter:** Klassische Multi-Threaded Allokatoren (Hoard 2000 als Pionier). Heutige Produkt-Allokatoren bauen auf diese Konzepte.

---

## §3 V31 Implementation Status

**V31 hat 10 Allokator-Adapter implementiert** (siehe NOTICE Architekt-Direktive II 2026-05-14):

| Cluster | Implementiert | Nicht implementiert |
|---|---|---|
| AC1 | A20 (1/2) | A21 (System) |
| AC2 | A04, A05, A06 (3/3) | — |
| AC3 | (0/4) | A09, A14, A15, A16 |
| AC4 | A03, A07, A11 (3/6) | A13, A17, A22 |
| AC5 | A01, A08, A10 (3/6) | A18, A19, A23 |

**Total: 10/23 Adapter** als COMDARE_HAVE_<X>-konfigurierbare Wrapper.

---

## §4 PRT-ART Pool-Mapping (siehe `../bausteine/02_allokator_matrix.md` §5)

PRT-ART nutzt 4+2 Allocator-Pools, jeweils mit empfohlener AA-Konfiguration:

| Pool | Inhalt | Empfohlene AA-Konfiguration |
|---|---|---|
| A | Trie-Inner-Knoten | AA3=PerThread, AA4=Lockfree, AA1=PerPageType |
| B | Trie-Leaf-Knoten | AA3=PerThread, AA4=Lockfree, AA7=Compact |
| C | Page-Header (kleine Allocs) | AA2=Slab, AA1=PerCacheLine |
| D | Page-Body (grosse Allocs) | AA2=BuddyOrSlab, AA7=Decommit |
| R | Reclamation-Buffer (RCU) | AA6=BulkFree |
| V | ValueHandle-Storage | AA5=BestFitOrInline |

**V-static + V-dynamic** je nach VALUEHANDLE-Achse 4.

---

## §5 V31 Allokator-Adapter Pattern

Pattern (zentral fuer alle 10 implementierten Allokator-Adapter):

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

Smoke-Test: 10/10 Allokator-Tests gruen in `comdare-cache-engine/tests/unit/test_v31_adapters.cpp` (allocate(64) + memset(0xAB) + deallocate + paper_id()).

---

## §6 NOTICE Architekt-Direktive II + Lizenz-Audit

**Architekt-Direktive II 2026-05-14 (User-Direktive in NOTICE verankert):**

> "Da wir alle Algorithmus-Bestandteile zerschneiden, entsteht fuer alle
> Permutations-Achsen ein neues Werk. Das gilt fuer alle Lizenztypen.
> Repos ohne Lizenztypen haben nur ein formales copyright."

→ Lizenz-Vermischung GPL-3/LGPL/no-LICENSE durch Adapter-Pattern unproblematisch (siehe LICENSE_AUDIT_EXT.md fuer Detail).

---

## §7 Querverweise

- Original-Quelle (UNVERAENDERT): `../termine/20260508 Termin 7/Allokator_Matrix.txt`
- Paper-Extractions Allokatoren: `../termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions_allocators/`
- Allokator-Matrix Master: `../bausteine/02_allokator_matrix.md` (K-E.3)
- Quellen-Gesamtkatalog Allokator-Sektion: `01_quellen_gesamtkatalog.md` §3 (K-F.2)
- LICENSE-Audit V31-Adapter: `../../Code/external/comdare-cache-engine/LICENSE_AUDIT_EXT.md`
- NOTICE Architekt-Direktive II: `../../Code/external/comdare-cache-engine/NOTICE`
- V31-Adapter-Smoke-Tests: `../../Code/external/comdare-cache-engine/tests/unit/test_v31_adapters.cpp`
