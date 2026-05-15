# Architektur-Delta REV 7.1 — Hybride PrtArtSearchEngine (2026-05-13)

**Status:** Delta-Erweiterung zu `24_architektur_skizze_REV7_2026_05_13.md`
**Anlass (User-Direktive 2026-05-13):**

> *"Bedenke: die SearchEngine ist eine hybride abstrakte Klasse, welche ALLE
> Funktionsinterfaces einer std::map bei 2+ Parametern fordert, alle
> Funktionsinterfaces einer std::vector bei nur einem Parameter.
> Schreiboperatoren returnen immer error number (alle IO Operationen)."*

**Verbindliche Klarstellungen** (per Rueckfrage 2026-05-13):
- Schreib-/IO-Operatoren returnen `int` im **errno-Style** (0 = ok, > 0 = Fehlercode).
- `lookup()` behaelt `std::optional<V>` (Reads bekommen ihren natuerlichen Typ).

---

## §1 Begruendung

Die in REV 6 / REV 7 §4 dargestellte `search_engine<Collection, ConfigPermutation>`
war als Singleton-Template gedacht und stellte die Schreibmethoden mit
`bool`/`void`/`pair<iter,bool>` bereit. Damit war die API:

- **nicht ABI-stabil** (Throwing-Operationen verstoßen gegen REV 7 §5 Pflicht
  fuer das C++23-Modul-Interface),
- **nicht symmetrisch** zu STL-Containern (kein `push_back`/`pop_back` fuer
  Vector-aehnliche Anwendungen),
- **nicht erweiterbar** auf Multi-Value-Records (z. B. fuer
  Density+Hotness-Tracking, das mehrere Werte pro Schluessel speichert).

Die hybride Form behebt alle drei Punkte.

---

## §2 Spezifikation

### §2.1 Template-Signatur

```cpp
namespace comdare::prt_art::identity {
    template <typename... Ts>
    class PrtArtSearchEngine;                                  // primary: undefiniert

    template <typename Value>
    class PrtArtSearchEngine<Value>;                           // 1 Param  → vector-API

    template <typename Key, typename First, typename... Rest>
    class PrtArtSearchEngine<Key, First, Rest...>;             // 2+ Params → map-API
}
```

### §2.2 Variadic-Magic fuer Spezialisierung B

- `kValueArity == 1` (= 2 Template-Parameter total) → `mapped_type = First`
- `kValueArity  > 1` (= N>2 Template-Parameter total) → `mapped_type = std::tuple<First, Rest...>`

`std::conditional_t` waehlt zwischen den beiden Auspraegungen. Der `insert`-Operator
ist ueberladen:

```cpp
status_t insert(Key, First);                       // N==1
status_t insert(Key, First, Rest...);              // N>1 (variadic, packt zu tuple)
```

### §2.3 Status-Codes (errno-Style)

```cpp
namespace comdare::prt_art {
    using status_t = int;
    inline constexpr status_t status_ok                      = 0;
    inline constexpr status_t status_key_already_exists      = 1;
    inline constexpr status_t status_key_not_found           = 2;
    inline constexpr status_t status_out_of_memory           = 3;
    inline constexpr status_t status_invalid_argument        = 4;
    inline constexpr status_t status_capacity_exceeded       = 5;
    inline constexpr status_t status_locked                  = 6;
    inline constexpr status_t status_out_of_range            = 7;
    inline constexpr status_t status_empty_container         = 8;
    inline constexpr status_t status_concurrent_modification = 9;
    inline constexpr status_t status_io_error                = 10;
}
```

### §2.4 Vector-API (Spezialisierung A)

| Methode | Rueckgabetyp | Anmerkung |
|---|---|---|
| `push_back(T)`, `push_back(T&&)` | `status_t` | `status_out_of_memory` bei bad_alloc |
| `pop_back()` | `status_t` | `status_empty_container` bei `data_.empty()` |
| `set_at(idx, T)` | `status_t` | `status_out_of_range` bei `idx >= size` |
| `insert_at(idx, T)` | `status_t` | `idx > size` → out_of_range |
| `erase_at(idx)` | `status_t` | |
| `clear()`, `resize(n)`, `resize(n, T)` | `status_t` | |
| `reserve(n)`, `shrink_to_fit()`, `assign(n, T)` | `status_t` | |
| `at(idx)`, `front()`, `back()` | `std::optional<T>` | Read |
| `data()`, `begin()/end()`, `cbegin()/cend()` | `T const*` / `const_iterator` | Read |
| `size()`, `empty()`, `capacity()`, `max_size()` | `size_t` / `bool` | Read |

### §2.5 Map-API (Spezialisierung B)

| Methode | Rueckgabetyp | Anmerkung |
|---|---|---|
| `insert(K, V)` / `insert(K, V1, ..., VN)` | `status_t` | `status_key_already_exists` bei Dup. |
| `set(K, V)` | `status_t` | Update-or-Insert |
| `erase(K)` | `status_t` | `status_key_not_found` |
| `clear()` | `status_t` | |
| `lookup(K)`, `find(K)`, `at(K)` | `std::optional<V>` / `std::optional<tuple<...>>` | Read |
| `contains(K)`, `count(K)` | `bool` / `size_t` | Read |
| `lower_bound(K)`, `upper_bound(K)`, `equal_range(K)` | `const_iterator(_pair)` | Read |
| `range_scan(K, max_count)` | `std::vector<mapped_type>` | PRT-ART-spezifisch (REV 7 §4.2(f)) |
| `begin()/end()`, `cbegin()/cend()` | `const_iterator` | Read |
| `size()`, `empty()` | `size_t` / `bool` | Read |

---

## §3 Integration mit existing Komponenten

Die hybride Klasse umfasst weiterhin alle 7 PRT-ART-Bausteine via
`PrtArtComponents`-Bundle (DRY-Aggregation):

- `PoolSet` (4+2 Allocator-Pools, REV 6 §5.17)
- `OlcWithReservedValueBlocks` (Multi-Writer-Concurrency)
- `MultiLevelLayout` (TLB-Offset + cache-line-aligned)
- `PathOrientedPrefetch` (Distance-Estimator + Path-Prefetch)
- `DensityTracker` (speist Reklassifizierung)
- `PrtArtHypothesisMetrics` (H1/H2/H3-Metriken)

Bei jedem Schreib-Op wird:
1. `WriteGuard` (OLC) konstruiert → reserviert exklusiven Value-Block, inkrementiert
   Version-Marker
2. `std::unique_lock<std::shared_mutex>` haelt RW-Lock (Reader/Writer-Disziplin)
3. Bei Speicheraenderung: `DensityTracker::record(synthetic_node_id, density_pct)`
4. `WriteGuard`-Destruktor commit-toggle die Version

Reader (`lookup`, `at`, `count`) nutzen `std::shared_lock` — concurrent OK.

---

## §4 Tests (51 neue Tests, 100% pass)

| Suite | Anzahl | Inhalt |
|---|---|---|
| `PrtArtIdentity` | 7 | PermutationFlags-Tag, Identifier-String |
| `MapApi` | 20 | insert/lookup/erase Roundtrip, status-Codes, range_scan, threading, density |
| `TupleApi` | 4 | Variadic-Pack zu `tuple<V1..VN>`, Type-Trait Check |
| `VectorApi` | 19 | push_back/pop_back/at/erase_at/resize/reserve/data/iter |
| `Status` | 1 | Status-Codes distinct, `status_is_ok/error` Pruedikate |
| **gesamt** | **51** | **MSVC i7-1270P Debug C++23** |

Plus volles ctest-Sweep: **181/181 Tests, 6.94s**, kein Regression in den
9 Geschwister-Tests (test_prt_art_nodes/internal_search/value_handle/
memory_layout/allocator_pools/olc/prefetch/measurement/serialization).

---

## §5 Offene Items (P3, nicht jetzt)

- **`comdare::search_engine` in cache_engine/abi/** — die in REV 7 §4 dokumentierte
  Basisklasse `search_engine<Collection, ConfigPermutation>` muss auf den hybriden
  Stil migriert werden (heute noch `bool`/`void`). Wird in Phase 7.2 bei der
  Permutations-Build-Pipeline mit-erledigt.
- **`status_t` als `enum class` statt int** — pruefen, ob enum-class besser ist;
  aktuell `int` wegen ABI-Stabilitaet (REV 7 §5).
- **`std::expected<V, status_t>` als Reader-Variante** — vom User explizit
  verworfen: Reads behalten `std::optional`.

---

## §6 Querverweis

- Memory: [[feedback-hybrid-search-engine-interface]]
- REV 7 Doku: `24_architektur_skizze_REV7_2026_05_13.md` §4 (Drei-Schichten-Hierarchie)
- Code: `comdare-prt-art/prt_art/include/prt_art/identity/prt_art_search_engine.hpp`
- Status-Header: `comdare-prt-art/prt_art/include/prt_art/identity/status.hpp`
- Tests: `comdare-prt-art/tests/unit/test_prt_art_identity.cpp`
