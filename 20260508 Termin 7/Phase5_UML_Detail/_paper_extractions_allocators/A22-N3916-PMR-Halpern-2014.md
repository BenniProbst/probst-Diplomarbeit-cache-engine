# A22 — N3916: Polymorphic Memory Resources (C++17 std::pmr)

## Bibliographie
- **Titel:** N3916 — Polymorphic Memory Resources, R2
- **Author:** Pablo Halpern (Bloomberg)
- **Vorgaenger-Paper:** N3525 (2013), N3726 (2013)
- **Venue:** ISO C++ Standards Committee Working Paper, 2014
- **PDF-Quelle:** [open-std.org/jtc1/sc22/wg21/docs/papers/2014/n3916.pdf](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2014/n3916.pdf)
- **C++17 Standardisierung:** Verabschiedet als `std::pmr::*` Namespace in C++17
- **C++20+:** Library Fundamentals TS v3
- **Status:** **C++ Standard** — Pflicht-Konformitaets-Anforderung fuer Comdare!

## Kerninnovation — Type-Erased Allocators

**Problem:** Klassische `std::allocator<T>` ist **Compile-Time-typsiert** → Container mit unterschiedlichen Allokatoren sind **inkompatible Typen**:

```cpp
std::vector<int, MyAllocA<int>> v1;
std::vector<int, MyAllocB<int>> v2;
v1 = v2;  // ERROR: different types!
```

**Loesung:** `std::pmr::polymorphic_allocator<T>` — wraps a `memory_resource*` → **Runtime-Polymorph**:

```cpp
std::pmr::vector<int> v1{&resource_a};
std::pmr::vector<int> v2{&resource_b};
v1 = v2;  // OK — same type, different runtime resources!
```

## Core API

### `std::pmr::memory_resource` (Abstract Base Class)

```cpp
class memory_resource {
public:
    virtual ~memory_resource();
    void* allocate(size_t bytes, size_t alignment = max_align);
    void  deallocate(void* p, size_t bytes, size_t alignment = max_align);
    bool  is_equal(const memory_resource& other) const noexcept;

protected:
    // Implement these in derived class
    virtual void* do_allocate(size_t bytes, size_t alignment) = 0;
    virtual void  do_deallocate(void* p, size_t bytes, size_t alignment) = 0;
    virtual bool  do_is_equal(const memory_resource& other) const noexcept = 0;
};
```

### `std::pmr::polymorphic_allocator<T>` (Stateless Wrapper)

```cpp
template <class T>
class polymorphic_allocator {
public:
    using value_type = T;

    polymorphic_allocator(memory_resource* r) : resource_(r) {}

    T* allocate(size_t n) {
        return static_cast<T*>(resource_->allocate(n * sizeof(T), alignof(T)));
    }

    void deallocate(T* p, size_t n) {
        resource_->deallocate(p, n * sizeof(T), alignof(T));
    }

    memory_resource* resource() const noexcept { return resource_; }

    // construct/destroy via uses-allocator construction
    template <class U, class... Args>
    void construct(U* p, Args&&... args);
};
```

## Standard Memory Resources

C++17 ships mit fertigen `memory_resource`-Implementationen:

| Resource | Beschreibung |
|----------|--------------|
| **`new_delete_resource()`** | Wraps global `operator new`/`operator delete` (Standard-Default) |
| **`null_memory_resource()`** | Throws `std::bad_alloc` on Allocation (fuer Debugging/Testing) |
| **`monotonic_buffer_resource`** | Bump-Pointer aus User-Buffer; **kein** individuelles Free; alles freed bei Destruction |
| **`synchronized_pool_resource`** | Thread-Safe Memory-Pool mit konfigurierbaren Pool-Sizes |
| **`unsynchronized_pool_resource`** | Wie oben, aber **single-threaded** (no locks) |

### `monotonic_buffer_resource` (Performance-Hot)
```cpp
char buffer[10000];
std::pmr::monotonic_buffer_resource pool(buffer, 10000);
std::pmr::vector<int> v{&pool};
v.push_back(1);  v.push_back(2);  // alloc from buffer (bump pointer, NULL on overflow)
```

### `unsynchronized_pool_resource` (Pool-Allocator)
```cpp
std::pmr::pool_options opts;
opts.max_blocks_per_chunk = 100;
opts.largest_required_pool_block = 1024;
std::pmr::unsynchronized_pool_resource pool(opts);
std::pmr::vector<int> v{&pool};
// Allocations from pool, fast, no locks (single-thread)
```

## Allocator Propagation

PMR-Allokatoren respektieren Container-Propagation-Traits:

```cpp
using allocator_type = polymorphic_allocator<T>;
allocator_type select_on_container_copy_construction() const {
    return allocator_type{};  // NEW resource (NOT propagated by default!)
}
// propagate_on_container_copy_assignment = false_type (default)
// propagate_on_container_move_assignment = false_type
// propagate_on_container_swap            = false_type
```

→ Bei Container-Copy: **neue** Allokator-Instanz mit Default-Resource (vermeidet ungewollte Resource-Sharing).

## Bausteine-Achsen-Mapping (AA1-AA7)

| Achse | N3916/std::pmr-Konkretisierung |
|-------|----------------------------------|
| **AA1 FreeList-Topologie** | Resource-spezifisch (z.B. monotonic = bump-pointer; pool = power-of-2 bins) |
| **AA2 Size-Class-Schema** | `pool_options.max_blocks_per_chunk` + `largest_required_pool_block` konfigurierbar |
| **AA3 Thread-Locality** | `synchronized` vs `unsynchronized` PoolResource = explizit waehlbar |
| **AA4 Synchronization** | `synchronized_pool_resource` thread-safe; `unsynchronized` lockless |
| **AA5 Allocation-Policy** | Resource-spezifisch (Monotonic = bump; Pool = bin-search) |
| **AA6 Reclamation** | Monotonic = nie individual; Pool = pro-block; chained-resources moeglich |
| **AA7 Fragmentation-Strategy** | Resource-spezifisch (Monotonic = sehr niedrig falls Buffer-Size passend; Pool = power-of-2 typisch) |

## Bedeutung fuer Comdare-CacheEngine — KRITISCH!

### A22 ist **Pflicht-Konformitaets-Standard** fuer Comdare!

Aus REV-7 §3.1 (Allokator-Concept):
> "Bausteine erweitern den `std::allocator<T>`-Standard typsicher. **Zusaetzlich:** Bausteine bieten `std::pmr::memory_resource`-Konformanz."

→ **JEDER** Comdare-Allokator-Baustein **MUSS** sowohl:
1. Eine `std::allocator<T>`-konforme Klasse exponieren
2. Eine `std::pmr::memory_resource` ableiten (ueberschreibt `do_allocate`/`do_deallocate`/`do_is_equal`)

### Konkrete Bedeutung

1. **`comdare::cache_engine::allocator::CacheEnginePmrResource`** = **Pflicht-Wurzel-Klasse** fuer alle Comdare-Allokatoren als PMR-Resource
2. **`std::pmr::*`-Container** wird **first-class supported** in Comdare-CacheEngine — User kann beliebige std-Container mit Comdare-Allokatoren nutzen
3. **Pool-Resource-Pattern** (synchronized + unsynchronized) = direkt im Comdare-Allokator-Stack als 2 Konkretisierungen
4. **Monotonic-Resource** = perfekt fuer **Comdare TestDataSetAccumulationEngine** (bulk-load test data, no individual frees)
5. **Chained-Resources** (`upstream_resource`-Pattern) = analog Comdare's Layer-Provider-Hierarchy (REV 7 §4.2(f)): SearchEngine-Resource → ExecutionEngine-Resource → CacheEngine-Resource
6. **Polymorphic_allocator-Wrapping** loest das Comdare-Multi-Tenant-Problem: gleiche std-Container-Typen mit verschiedenen Allokator-Resources

### Compile-time vs Runtime Polymorphism

| Approach | Beispiel | Comdare-Anwendung |
|----------|----------|---------------------|
| **Compile-Time** (`std::allocator`) | `std::vector<T, MyAlloc<T>>` | Hot-Path Suche-Algorithmen mit feststehender Allokator-Strategie |
| **Runtime** (`std::pmr::polymorphic_allocator`) | `std::pmr::vector<T>{&resource}` | Test-Data-Container, Benchmark-Suite (verschiedene Resources austauschbar) |

→ Comdare nutzt **beide** je nach Layer.

## Test-Pflicht (REV-7 §3.2)

Pro Comdare-Allokator-Baustein **PFLICHT**:
- `std::pmr::vector<T>` Insert/Erase/Clear Tests
- `std::pmr::map<K,V>` Insert/Erase/Find Tests
- `std::pmr::unordered_map<K,V>` Tests
- `std::pmr::deque<T>` Tests
- `std::pmr::list<T>` Tests
- `std::pmr::set<T>` Tests
- Resource-Equality-Tests (`is_equal()` Korrektheit)
- Allocator-Propagation-Tests bei Container-Copy/Move/Swap

## Lizenz + Verfuegbarkeit

- **Standard:** ISO C++17 — keine Lizenz noetig (Standard-Library)
- **Implementierungen:** libc++ (Apple), libstdc++ (GNU GCC), MSVC STL — alle bieten std::pmr
- **C++23 Compiler-Pflicht:** GCC ≥ 11, Clang ≥ 13, MSVC 19.30+
- **Nicht klone-pflichtig** (in Standard enthalten)
- **Reference fuer Comdare:** N3916 PDF + cppreference.com `std::pmr::*`

## Verwandte Werke

- N3525, N3726 — Vorlaeufer-Papers
- C++17 Standard `std::pmr::*` Subnamespace
- C++20 Library Fundamentals TS v3
- A04 mimalloc — bietet PMR-konforme Wrapper-Header
- A06 tcmalloc — bietet PMR-konforme Wrapper-Header
- A05 jemalloc — bietet PMR-konforme Wrapper-Header
- Boost.Container — Vorlaeufer-Implementation polymorpher Allokatoren
