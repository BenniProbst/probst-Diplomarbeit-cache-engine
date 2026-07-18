# DOSSIER — Phase 0.1: SIMD-Dispatch (Hebel A), erster Slice

> Doc 21 §F Phase 0.1. Ziel: die BUILD-Varianten-Achse simd_extension (09b) echt auf den SIMD-Compute wirken
> lassen. Rahmung: punktuelle Refactorings, CI grün+messfähig, ce `c022ce05`. Selbst-Implementierung.

## 0. HARTE VERBOTE
Wie stets (golden/m3v2/PODs/ABI-MAJOR==4/GenusBindingTraits/modules/ext/thesis TABU; ue/ae/oe; kein Python;
kein Runtime-Switch im Hot-Path). ZUSÄTZLICH: (a) KEINE Signatur-Änderung an `simd_field_sum` (Aufrufer
abi_adapter.hpp:749 + observe_simd_field_sum-Hüllen unberührt); (b) KEINE Build-Flag-Änderung an Produktiv-
Targets in diesem Slice (die AVX-Pfade sind compiler-makro-guarded → kompilieren überall, honest-Fallback wenn
Flag fehlt; die -mavx2/-mavx512f-Test-Varianten sind neue, isolierte Test-Targets).
(c) **KORREKTUR ggü. Erst-Entwurf (Review wf_fd87be00):** die ursprünglich geplante per-lane-32-bit-Akkumulation
ist NICHT semantik-erhaltend — sie divergiert build-abhängig unter Überlauf (SSE2 2 Werte/128b-Lane vs.
AVX2/AVX-512 1 Wert/Lane). Deshalb akkumulieren ALLE Pfade in **uint64** (32→64 gewidened vor der Addition) →
die WAHRE Summe, **build-invariant** über SSE2/AVX2/AVX-512/Skalar. Das ist die einzuhaltende Semantik.

## 1. IST (verifiziert)
- `Amd64Isa::simd_field_sum(buf,n)` (`axes/simd/axis_09_isa_amd64.hpp`): hartkodiert **SSE2** (128b,
  `_mm_add_epi32`, 4 uint32-Lanes) unter `#if defined(__x86_64__)`, sonst skalar. Include `<emmintrin.h>`.
- simd_extension (09b) = **BUILD-Varianten-Achse** (`build_variant_definition.hpp:3,42` `detect_avx512<SE>`),
  Extension liefert `vector_width_bits()` (SSE2=128/AVX2=256/AVX512=512) + `provides_avx2/avx512f()` (rein
  deklarativ). Realisierung SOLL über `cmake/isa_features.cmake` (`-mavx2`/`-mavx512f`) per Target.
- **Utilization-Lücke (2-teilig):** (i) `simd_field_sum` reagierte gar nicht auf die SIMD-Stufe (immer SSE2);
  (ii) selbst mit breiterem Pfad ruft KEIN Produktiv-Target `cmake/isa_features.cmake`'s Flag-Setter auf → die
  Kopplung 09b-Achse→`-mavx2`-Flag ist noch offen. **Dieser Slice schließt (i)** (Dispatch reagiert jetzt auf
  `__AVX2__`/`__AVX512F__`); **(ii) bleibt Folge-Slice** (Build-System-Verdrahtung 09b→Flag).
- Aufrufer: `abi_adapter.hpp:749` `Isa::simd_field_sum(lbuf,kRecords)`; über `observe_simd_field_sum`-Hüllen in
  node/swiss-Stores (`axis_04_node_type_chunked_store.hpp`, `swiss_group_pool_store.hpp` u.a.).
- **Mess-Kopplung:** `axis_09_isa_observable.hpp::lane_width_()` liefert die Lane-Breite für
  `simd_iterations`/`scalar_fallback_count` (T12-Zeile) — MUSS dieselbe Kaskade wie der Compute spiegeln.

## 2. FIX (dieser Slice, nach Review korrigiert)
`Amd64Isa::simd_field_sum` um breitere Vektor-Pfade erweitern, **guarded durch die Compiler-SIMD-Makros**
— compile-time-strikt, kein Runtime-Switch. **Alle Pfade akkumulieren in uint64** (32→64 gewidened VOR der
Addition) → wahre, build-invariante Summe (kein per-lane-32-bit-Overflow-Drift):
```
#if   defined(__AVX512F__)  → 16 uint32/Iter, 2× _mm512_cvtepu32_epi64 (aus 2×256b-Load), _mm512_add_epi64, 8 uint64-Lanes
#elif defined(__AVX2__)     →  8 uint32/Iter, 2× _mm256_cvtepu32_epi64 (aus 2×128b-Load), _mm256_add_epi64, 4 uint64-Lanes
#elif defined(__x86_64__)||_M_X64 → 4 uint32/Iter, _mm_unpack{lo,hi}_epi32 mit 0 → _mm_add_epi64, 2 uint64-Lanes
#else                       → skalar (Bestand)
+ skalarer Tail-Rest (Bestand, uint64)
```
Include `<immintrin.h>` unter `#if defined(__AVX2__)||defined(__AVX512F__)`. **Zusätzlich (Review-Fixes):**
- `axis_09_isa_observable.hpp::lane_width_()` spiegelt die 16/8/4-Kaskade (statt hartkodiert 4) → keine
  Desynchronisation der T12-Messzeile (`simd_iterations`/`scalar_fallback_count`).
- `abi_adapter.hpp:747` Kommentar auf die neue Dispatch-Wahrheit gezogen (nur Kommentar; ABI-Logik tabu).
- CI-Deckung: je ISA-Stufe eine Test-Variante (`_avx2`/`_avx512`), IMMER kompiliert (Compile-Deckung aller
  #if-Zweige), AUSGEFÜHRT nur bei Host-ISA-Support (Probe `__builtin_cpu_supports`, ohne ISA-Flag kompiliert →
  kein SIGILL; Cross-Compile → nur Compile).

**Scope-Grenze:** nur Amd64Isa (dominante Server-Plattform). aarch64-NEON/riscv-RVV-`simd_field_sum` = Folge-
Slice. Das Routing der übrigen skalaren `*_scan`-Kerne über isa + die 09b→Flag-Build-Verdrahtung = Folge-Slices.

## 3. BEWEIS-TEST (NEU, Label `axes;simd`, CI-aktiv)
`tests/unit/test_simd_field_sum_dispatch.cpp` (Standalone): (a) Korrektheit — `simd_field_sum` == uint64-
Referenzsumme für n ∈ {0,1,2,3,4,5,7,8,9,15,16,17,31,32,33,100,128} (Tail-Handling aller Lane-Breiten);
(b) **Build-Invarianz unter Überlauf** — derselbe n-Sweep mit Werten 0xC0000000+k (>2^31): der load-bearende
Kontrakt, den der alte per-lane-32-bit-Pfad gerissen hätte; identische Checksummen über SSE2/AVX2/AVX-512
verifiziert; (c) aktiver Pfad meldet sich (`__AVX512F__/__AVX2__/__x86_64__`-Makro-Report ins Log, honest).
Belegt (standalone g++-16, `-O2`, je Flag): SSE2/AVX2/AVX-512 alle **ALLE OK**, Overflow-Checksummen identisch.

## 4. DoD (doppelt-literal, g++-16)
Neuer Test (3 Varianten) + voller ctest 100%; clang-format-22==0; Mojibake==0; git status NUR die berührten
Dateien; golden/m3v2/ABI/PODs byte-unberührt (git-diff-Beleg). Danach adversarialer Review-Workflow (Re-Verify)
+ Rohdaten-Backup hierher, Fixes, granulare Commits beide Remotes (development), CI strikt grün.
