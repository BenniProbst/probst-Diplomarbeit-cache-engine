# V41.F.6.1.P2.D.tr.s1 Session-Ende — Traversal Roll-out s1 + Lücken-Pattern + Mixin-Refactor (2026-05-26 nacht)

**Stand:** 2026-05-26 nacht (Kontext-Ende nach 5 substantiellen Sub-Phasen — Fortsetzung nach P2.D.b2-Session)
**Vorgaenger:** `20260526-V41-F-6-1-P2-D-b2-rollout-typed-test-papers-session-end.md`
**Master-Doc:** `docs/architektur/13_paper_legacy_code_architektur.md` (jetzt 5-teilig A+B+C+D+E, ~1300 Zeilen)
**Pflicht-Pre-Read fuer naechste Session:** dieses Dokument + Doku 13 Teil E + Memory `[[paper-original-code-pattern]]`

---

## §1 Session-Zusammenfassung — 5 substantielle Sub-Phasen

Diese Session begann nach Session-End-Doku der vorigen Session ("Pause empfohlen"). User wollte aber direkt mit naechstem TODO weitermachen — Task #686 P2.D.tr. Was kam:

1. **Audit traversal-Wrappers** — wichtige Entdeckung: existing Wrappers sind **Re-Implementation, nicht ART/HOT/START linked**!
2. **User-Entscheidung Option B**: NEUE Original-Wrapper-Klassen parallel anlegen
3. **User-Kritik 1: per-Function `is_original` ist Pflicht** — markiert Lücken
4. **User-Klarstellung: extern Linking Original-Compiler + Fallback** — Direktive nachschlagen
5. **P2.D.tr.s1 Implementation:** Mixin-Refactor (alle 6 Achsen) + 3 traversal Paper-Skelette + Tool-Pipeline

---

## §2 Audit-Ergebnis (Entdeckung)

**Vorher gedacht:** traversal-Wrappers (Array256/VectorU8U8/VectorU16U16) sind ART/HOT/START gelinkt → analoges Roll-out-Pattern wie Allocator.

**Realitaet:** Array256 ist `std::array<std::optional<value>, 256>` (Standalone-Re-Impl).
VectorU8U8 + VectorU16U16 sind ähnlich Re-Impl inspiriert von HOT/START.

**Wrapper-Header zitiert:**
> "Standalone-Implementation: std::array<std::optional<value>, 256> mit O(1) Lookup/Insert/Erase."

**Konsequenz:** Einfaches Roll-out-Pattern funktioniert NICHT — Wrapper-Methods rufen NICHT
die Paper-APIs auf. Drei Strategien diskutiert:
- A: get_compiler="self" Override fuer existing (Re-Impl explizit markiert)
- B: NEUE Original-Wrappers parallel anlegen (User-Wahl ✓)
- C: TODO defer

---

## §3 User-Klarstellung Lücken-Pattern (Architektur)

User-Direktive (verbatim):
> "Anhand der Tabelle sehen wir jetzt, warum ich die is_original Eigenschaft JE
> FUNKTION vorgeschlagen hatte: Wir benoetigen einige zusaetzliche Funktionen,
> die noch nicht implementiert sind, aber ohne die der gesamte Experiment Aufbau
> nicht funktioniert. Es ist unsere Aufgabe diese Luecken zu fuellen und die
> Probleme zu loesen, aber wir muessen diese Funktionen als nicht original
> markieren. So koennen wir in der Permutation Engine ueber die Konfiguration
> der CacheEngineBuilder spaeter Kombinationen abwaehlen, die bestimmte
> Voraussetzungen nicht erfuellen."

Plus Folge-Klarstellung:
> "per-Function is_original markiert nur ob die Funktion original ist. Ist eine
> Luecke da, ist es auch false. Es ist nur true, wenn der Original code vorliegt."

**Pattern-Konsequenz: 3 Wrapper-Klassen-Kategorien:**

| Kategorie | get_compiler() | is_original_<fn>() | is_original_module() |
|---|---|---|---|
| Pure-Original | "gcc-9.5" via Mixin | true (alle) | true |
| Teil-Original mit Luecken | "gcc-9.5" via Mixin | true (Paper-API), false (Luecken) | false |
| Re-Impl ohne Paper-Binding | "self" oder "original" Default | false (alle) | false |

---

## §4 User-Direktive: extern Linking nachgeschlagen

User-Direktive heute:
> "Zur Entdeckung war die direktive: extern ueber Wrapper den Original code mit
> original compiler bauen und linken und eigene Implementierung nur als fallback.
> Bitte schlage diese dokumentierte Direktive in allen dokus von heute nach"

**Verifiziert (Doku-Suche durchgefuehrt):** Direktive ist in mehreren Stellen dokumentiert:
- Doku 13 §1 Z28: "Original-Code mit jeweils Original-Compiler kompiliert"
- Doku 13 §1 Z34: "Code wird gelinkt statt kopiert"
- Doku 13 §5 + §6: CMake-Module compiler_cache + paper_binary
- Doku 13 §8: extern "C" Adapter Pattern
- Memory [[paper-original-code-pattern]] + [[experiment-compiler-property]]: voll beschrieben

**Implementation-Realitaet (LUECKE):**

| Komponente | Stand |
|---|---|
| SHA-Validierung Source-Identity | ✅ aktiv (Tool-Pipeline) |
| Mixin liefert get_compiler="gcc-9.5" Marker | ✅ aktiv |
| Compiler-Cache aktiv genutzt | ❌ nur Skelett, NICHT aktiv |
| Paper-Library mit Original-Compiler gebaut | ❌ NICHT aktiv |
| Wrapper linkt gegen Original-built-Library | ⚠️ aktuell gegen System-built-Library |
| Eigene Implementation als Fallback | ✅ vendor_includes/-Shim-Pattern |

→ **Architektur dokumentiert, Implementation TODO Sprint P2.A.W + P2.D.tr.s4.**

---

## §5 P2.D.tr.s1 Mixin-Refactor (alle 6 Achsen)

**Problem:** Wenn Paper-API Teil-Funktionen hat (z.B. HOT/START kein remove/clear),
generiert Tool PaperManifest mit weniger Feldern. Achs-Mixin erwartete vorher ALLE
Felder → Compile-Error bei Inheritance.

**Loesung:** Alle 6 Achs-Mixin-Templates refactored mit `if constexpr requires`:

```cpp
[[nodiscard]] static constexpr bool is_original_erase() noexcept {
    if constexpr (requires { PaperManifest::kIsOriginal_erase; })
        return PaperManifest::kIsOriginal_erase;
    else
        return false;  // Luecke: Function nicht im Paper, eigene Erweiterung
}
```

**Geaendert (alle backward-compatible):**
- axis_06_allocator_original_code_mixin.hpp (2 Functions)
- axis_q1_queuing_original_code_mixin.hpp (6 Functions)
- axis_q2_queuing_original_code_mixin.hpp (2 Functions)
- axis_03a_search_algo_original_code_mixin.hpp (4 Functions)
- axis_03b_cache_traversal_original_code_mixin.hpp (4 Functions)
- axis_03m_mapping_original_code_mixin.hpp (4 Functions)

---

## §6 P2.D.tr.s1 — 3 Traversal Paper-Skelette

Helper-Aufruf `comdare_register_paper_wrapper()` analog Allocator-Pattern,
mit AXIS_MIXIN_TYPE = SearchAlgoOriginalCodeMixin Override.

| Paper | Source | API-Mapping | Tool-Output |
|---|---|---|---|
| **P01 ART** (Leis ICDE 2013) | ext/P01-ART/unodb/art.hpp | insert→insert_internal, lookup→get, erase→remove_internal, clear→clear | 4 functions, ALL ORIGINAL |
| **P02 HOT** (Binna PVLDB 2018) | ext/P02-HOT/hot/libs/.../HOTRowex.hpp | insert→insert, lookup→lookup (KEIN erase/clear) | 2 functions, ALL ORIGINAL (insert+lookup), erase+clear → AxisMixin defaults false |
| **P05 START** (Mertens ICDE 2024) | ext/P05-START/START/sosd-competitor-adapter-START.h | insert→insertLater, lookup→EqualityLookup | 2 functions, analog |

**Wichtige Korrektur (Build-Test):** START manifest hatte zuerst `insertKey` als
paper_fn — falsch, das ist nur ein **Method-Call** im sosd-Adapter. Echte Function-Def
ist `insertLater` (umbenannt im manifest).

**Skelett pro Wrapper (5-6 Files):** LICENSE + README.md + manifest.txt + compiler_info.txt +
MODIFICATIONS.md + .gitignore + sha256_locked.txt (auto-generated).

---

## §7 Pending Sub-Stufen (s2 + s4)

**s2 (Task #686 in_progress, eigener Sprint):** 3 NEUE Wrapper-Klassen
- OriginalArtSearchAlgo (4/4 originall)
- OriginalHotSearchAlgo (2/4 — erase+clear Luecken)
- OriginalStartSearchAlgo (2/4 — erase+clear Luecken)

Komplex weil ART/HOT/START sind Templated C++17. Body-Strategie:
- Concept-Conformance SearchAlgoVariant (4 Methods Pflicht)
- Inheritance vom generated Paper-Mixin + using-Disambiguation
- Body: `if constexpr (enabled) ... else fallback` Pattern
- Konkrete Type-Instantiation (ART Templated db<K,V>)

**s4 (Task neu, separater Sprint):** Library-Build mit Original-Compiler aktivieren
- compiler_cache.cmake aktivieren (gcc-9.5 download + build)
- paper_binary.cmake aktivieren (Library aus legacy_code/ mit Paper-Compiler)
- Wrapper-Methods linken gegen Original-built-Library
- Cross-Platform 3 OS + 4 ISAs (substantieller Sprint)

---

## §8 CLion-Build-Bug (User-Report)

**Bug heute:**
```
cmake ... -S Modules/comdare-cacheengine-all/comdare-cache-engine
       -B Modules/.../cmake-build-release
CMake Error: ... different than the directory
  Research/comdare-cache-engine/cmake-build-release/_deps/googletest-subbuild
```

**Root-Cause:** Stale Cache zeigt auf alten Source-Pfad (Research/).

**Loesung dokumentiert (Doku 13 §30):** `cmake-build-release/` loeschen + neu konfigurieren.
Pflicht-Disziplin: pro Source-Pfad eigener Build-Pfad.

**Empfohlener Task (separat):** `Research/comdare-cache-engine/` Backup-Pfad pruefen +
ggf. archivieren (kein aktiver Klon mehr noetig).

---

## §9 Tests-Bilanz Endstand

| Test-Target | Tests | Aenderung |
|---|:---:|---|
| test_v41_topic_allocator_axis_06 | 252 | unveraendert (Mixin-Refactor backward-compatible) |
| test_v41_topic_queuing | 205 | unveraendert (nicht neu gebaut, aber Mixin-Refactor backward-compat) |
| test_v41_topic_traversal | 95 | unveraendert |
| test_v41_paper_legacy_code | 102 | unveraendert (s1 nur Skelett, keine Wrappers) |
| **TOTAL** | **654** | **unveraendert** (s1 ist Pre-Code, s2 bringt neue Tests) |

Cache-engine: 252+205+95+102 = 654 gruen. Diplomarbeit-Container: 104 gruen.

---

## §10 Commits heute (chronologisch)

| # | Commit | Repo | Inhalt |
|:-:|---|---|---|
| 1 | `3b4fd20` | cache-engine | P2.D.tr.s1: Mixin-Refactor (alle 6 Achsen) + 3 Traversal Paper-Skelette |
| 2 | `4b25b2b` | Diplomarbeit | Submodule-Bump P2.D.tr.s1 |
| 3 | (pending) | Diplomarbeit | Doku 13 Teil E + diese Session-End-Doku |

---

## §11 Architektur-Endstand P2.D.tr.s1

| Sub-Task | Status |
|---|---|
| ~~P2.B/P2.D + P2.D.b2~~ Allocator-Roll-out (6 Paper-Wrappers) | ✅ vorherige Sessions |
| ~~P2.D.tr.s1~~ Traversal Skelette + Mixin-Refactor | ✅ **heute** |
| **P2.D.tr.s2** Wrapper-Klassen (OriginalArtSearchAlgo etc.) | **pending** Task #686 |
| **P2.D.tr.s4** Library-Build Original-Compiler aktiv | **pending** Task neu (mit P2.A.W) |
| **P2.D.t2** 4 deferred Allocator (Bazel + Shims) | **pending** Task #685 |
| **P2.D.q** queuing Paper-Source-Audit | **pending** Task #687 |

---

## §12 Naechste Session beginnt mit

**Pflicht-Pre-Read (in dieser Reihenfolge):**
1. `MEMORY.md` (Index)
2. **Dieses Dokument** (`20260526-V41-F-6-1-P2-D-tr-s1-traversal-luecken-pattern-session-end.md`)
3. `docs/architektur/13_paper_legacy_code_architektur.md` (jetzt 5-teilig A+B+C+D+E)
4. Memory `[[paper-original-code-pattern]]` (Coexistence-Pattern)
5. Memory `[[legacy-code-sha256-validation]]` (Tool-Pipeline + Mixin)
6. Memory `[[axis-base-pattern]]` (Wurzel + Defaults)
7. Memory `[[cross-axis-defaults-no-bloat]]` (Pattern-Disziplin)

**Build-Verifikation:** 252+205+95+102 = 654 cache-engine gruen + 104 Diplomarbeit gruen.

**Empfohlene Start-Reihenfolge:**
1. **P2.D.tr.s2** (Task #686) — 3 Wrapper-Klassen (OriginalArt/Hot/StartSearchAlgo)
2. **P2.D.t2** (Task #685) — 4 deferred Allocator
3. **P2.D.q** (Task #687) — queuing-Audit
4. **P2.A.W + P2.D.tr.s4** — Library-Build Original-Compiler (separater Sprint)

**Hinweis CLion-Build:** Doku 13 §30 fuer Build-Fix. `cmake-build-release/` loeschen
wenn stale-Cache-Konflikt mit anderem Source-Pfad.

---

## §13 Lessons-Learned (3 Hauptpunkte)

1. **Audit VOR Roll-out kritisch** — existing Wrappers waren Re-Impl, nicht Linked.
   Roll-out-Pattern haette ohne Audit zu falscher Semantik gefuehrt (is_original=true
   trotz fehlender Linking). Pflicht-Disziplin: Audit jeder Wrapper-Body-Implementation
   VOR Mixin-Inheritance-Refactor.

2. **`if constexpr requires` als Mixin-Pattern fuer Optional-Fields** —
   Achs-Mixin-Templates duerfen nicht alle PaperManifest-Felder hart erwarten.
   `if constexpr (requires { PaperManifest::kIsOriginal_<fn>; }) return ...; else return false;`
   liefert eleganten Default + Backward-Compat + Lücken-Markierung.

3. **Architektur-Direktive vs Implementation-Status muss explizit dokumentiert sein** —
   "extern Linking + Original-Compiler" Direktive war in Doku 13 + 2 Memorys dokumentiert,
   ABER Implementation war nur Skelett (Compiler-Cache nicht aktiv). User-Frage zeigte
   diese Diskrepanz. Doku 13 §29 jetzt explizit "LUECKE-Tabelle: dokumentiert vs aktiv".

---

**Ende Session-End-Doku 2026-05-26 nacht (5 Sub-Phasen P2.D.tr.s1).**
