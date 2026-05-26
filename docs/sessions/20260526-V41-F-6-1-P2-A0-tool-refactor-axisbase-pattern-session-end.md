# V41.F.6.1.P2.A0 — Tool-Refactor-Iterationen + AxisBase Wurzel-Pattern (Session-Ende 2026-05-26 nacht)

**Stand:** 2026-05-26 spaete Nacht, Kontext-Ende
**Vorgaenger:** `20260526-V41-F-6-1-traversal-konsolidierung-paper-legacy-pattern-session.md` (commit 35999ea)
**Master-Doc:** `docs/architektur/13_paper_legacy_code_architektur.md` (Erweiterung Phase B.2.E pending)
**Pflicht-Pre-Read fuer naechste Session:** dieses Dokument + axis_base.hpp + alle 7 Memory-Files

---

## §1 Session-Zusammenfassung — 4 substantielle Tool-Iterationen + AxisBase

Heute Nacht wurden **4 substantielle Architektur-Iterationen** am Pre-Build-Tool
fuer Paper-Legacy-Code-Validierung durchgefuehrt, getrieben durch 4 schrittweise
User-Korrekturen:

1. **P2.A0** — Tool Single-Function-CLI → Multi-Function-Manifest
2. **P2.A0.5** — Auto-Discovery via Regex + Brace-Balancer + Lock-File-Pattern + Mixin-Generation
3. **P2.A0.6** — Achsen-generischer Mixin-Template-Pattern (statt wrapper-spezifischer Mixin) + Multi-File-Paper-Support
4. **P2.A0.7** — AxisBase Wurzel-Pattern in `topics/` + `get_compiler()` Cross-Axis-Property + Rename

Plus: **MSVC-Stop-Episode** (Runtime-Workaround verboten, Pre-Build-Tool-Pattern verankert) bereits in vorheriger Session dokumentiert.

---

## §2 Kontext: 5 schrittweise User-Direktiven (verbatim)

Die 4 Iterationen entstanden durch direkte User-Stops und Architektur-Korrekturen:

### Direktive 1 (vor P2.A0)
> "Hinweis: das 'is_original' muss fuer jeden function body als Funktion
> wiederverwendbar sein, die derzeitige Hilfs-App sollte Argumente aufnehmen
> und auswerten koennen. Das jetzt nur fuer mimalloc_is_original.hpp ist
> schwachsinn. Das generelle is_original constexpr bool zu bauen, geht ja
> immer noch wenn wir die einzelnen function bodies auswerten."

### Direktive 2 (vor P2.A0.5)
> "Wie kommt jetzt das statische constexpr boolean in die jeweilige is_original
> Eigenschaft einer jeden Funktion? Ich wuensche ausserdem, dass die in der
> compile time abzugleichenden Function bodies ueber den Funktions Namen im
> Original Paper file gefunden und von allein per regex ausgewertet und dann
> gehasht werden. Die Registrierung muss voll dynamisch sein, alles was der
> User tut, ist die Achse zu definieren und moeglicherweise den Pfad fuer
> die Paper-source anzugeben, was bedeutet, dass wir bei der Kompilation
> einer Permutation-binary automatisch zur compile time die is_original flags
> der function bodies setzen, ohne diese irgendwo manuell registrieren zu muessen."

### Direktive 3 (vor P2.A0.6)
> "Ein paper hat vielleicht multiple source files, welche die zu referenzierenden
> Funktionen verteilt beinhalten und in einem source file koennen mehrere
> relevante function bodies existieren. Das heisst wir suchen nach der Identitaet
> der original code Sequenz eines function body, indem wir die fuer eine Achse
> definierten Function interfaces zuerst fuer die Achse ueber alle Paper-
> Algorithmen der Achse in den Zielnamen statisch uebersetzen (kann im
> Concept-definition als Liste aus string_view uebersetzt sein). Diese lassen
> sich dann auto registriert in der App aufrufen, uebersetzen und in der
> Paper-source nachschlagen. Mimalloc ist ein spezielles Konstrukt struct, es
> sollte von einem Achsen-generischen struct fuer die Interface-Uebersetzung
> erben, um es allen Algorithmen einer Achse jeweils zur Verfuegung zu stellen.
> Immer noch zu speziell und keine Vererbung vorbereitet."

### Direktive 4 (vor P2.A0.7)
> "Weitere abrufbare constexpr Eigenschaft je Achse: std::string_view get_compiler()
> ist standard ein Text 'original' und kann in einem Paper-Algorithmus einer Achse
> mit dem Zielcompiler ueberschrieben werden. Bisher hatten wir nur is_eigenschaft,
> jetzt erweitern wir um dieses string pattern und erfordern dieses als Interface
> aller topics und Achsen. Daraus folgt, dass die Achsen diese Eigenschaft aus
> einer abstract class aus der Ebene der topics erben und je Algorithmus optional
> per overload setzen. Derzeit sind zwar die Eigenschaften aller Achsen
> strukturell synchron, aber sie haben noch keine Wurzelklasse axis_base.hpp als
> concept Basis-Pattern file im topics Ordner direkt."

### Direktive 5 (kritisch, MSVC-Stop, vor P2.A0)
> "Wir hatten compile time definiert, runtime ist VERBOTEN, wir haben
> Latenzkritische Suchalgorithmen. Workaround waere ein separates Programm
> fuer is_original, welches zur compile time ausgewertet wird"

---

## §3 P2.A0 — Tool Multi-Function-Manifest-Refactor

**Vorher:** single-function CLI `--source --function --expected --output --namespace` → 1 Header mit 1 Boolean.

**Nachher:** Manifest-basiert. CLI:
```bash
is_original_validator --manifest <path> --base-dir <path> --output <header.hpp> --namespace <ns>
```

Manifest-Format (3-Feld + @-Annotations):
```
@experiment_compiler gcc-9.5
@has_original_paper_code true
@mixin_name MimallocAllocator_OriginalCodeMixin

# wrapper_fn  paper_fn   source_path
allocate      mi_malloc  src/alloc.c
deallocate    mi_free    src/alloc.c
```

Generierter Header: `kIsOriginal_<wrapper_fn>` pro Function + `kIsOriginal_module = mp_all_of`.

**Commit:** `dd62dac` (cache-engine), `0304625` (Diplomarbeit submodule).

---

## §4 P2.A0.5 — Auto-Discovery + Lock-File + Mixin

**3 neue Tool-Kapabilitaeten:**

1. **AUTO-DISCOVERY (Regex + Brace-Balancer):**
   - Tool findet Function-Body via `\b<paper_fn>\s*\([^)]*\)[^{;]*\{` Regex
   - Brace-Balancer-State-Machine mit String/Char/Line-/Block-Comment-Behandlung
   - Extrahiert von Signatur bis matching `}`
   - Deckt typische C-Variationen ab: Comment zwischen `)` und `{`, `__attribute__`, etc.

2. **LOCK-FILE-PATTERN:**
   - `sha256_locked.txt` im legacy_code/paper_<id>/ Verzeichnis
   - First-Time-Init: Tool berechnet SHAs, schreibt Lock-File, User committed
   - Spaetere Builds: Tool vergleicht aktuelle Source-SHAs gegen Lock-File
   - **Modifikation erkannt** → `kIsOriginal_<fn> = false` → `kIsOriginal_module = false`

3. **MIXIN-GENERATION (User-Direktive "voll dynamisch"):**
   - Tool generiert komplette Mixin-Struct, KEINE Macros mehr
   - Wrapper erbt von `generated::<paper>::MyClass_OriginalCodeMixin`
   - Alle Pflicht-API automatisch via Vererbung

**End-to-End validiert:** Body-Modification in mi_free erkannt (1/3 MISMATCH).

**Commit:** `ff9ea60` (cache-engine), `3fd8a53` (Diplomarbeit).

---

## §5 P2.A0.6 — Achsen-generischer Mixin-Template + Multi-File

**User-Korrektur:** "Mimalloc ist ein spezielles Konstrukt struct, es sollte
von einem Achsen-generischen struct fuer die Interface-Uebersetzung erben"

**Vererbungs-Hierarchie etabliert:**
```
::topics::AxisBase                                  ← Wurzel (NEU in P2.A0.7)
   └── ::concepts::OriginalCodeMixinBase<M>         ← Cross-Topic
         └── AllocatorOriginalCodeMixin<M>           ← Pro Achse
               └── generated::<paper>::OriginalCodeMixin (Tool-Alias)
                     └── class MimallocAllocator (Wrapper)
```

**Tool-Output-Aenderung:**
- Statt eigenen Mixin-Struct: PaperManifest + `using OriginalCodeMixin = ::AxisOriginalCodeMixin<PaperManifest>`
- CLI-Arg `@axis_mixin_type` (fully-qualified Template-Name) ersetzt `@mixin_name`

**Multi-File-Support:** Pro Mapping eigener `source_relative_path` (war bereits unterstuetzt, jetzt explizit dokumentiert + Demo-validiert mit `alloc.c` + `heap.c`).

**Achsen-Interface-Functions-Liste:** `std::array<string_view> kAxisInterfaceFunctions` pro Achse (Concept-Definition) — Implementation steht aus in Phase B.2.B/F.

**NEUE Datei:** `libs/cache_engine/src/concepts/axis_original_code_mixin_base.hpp` (cross-topic OriginalCodeMixinBase).

**Commit:** `67d471d` (cache-engine), `526277e` (Diplomarbeit).

---

## §6 P2.A0.7 — AxisBase Wurzel-Pattern + get_compiler Cross-Axis-Property

**User-Direktive:** Wurzelklasse fehlt — `axis_base.hpp` direkt im `topics/` Ordner mit cross-axis Pflicht-Property `get_compiler()`.

**NEUE Wurzel-Datei:** `libs/cache_engine/topics/axis_base.hpp`
```cpp
namespace comdare::cache_engine::topics {
struct AxisBase {
    [[nodiscard]] static constexpr std::string_view get_compiler() noexcept {
        return "original";  // Default — Wrapper kann ueberschreiben
    }
};
template <typename T>
concept AxisBaseConcept = requires {
    { T::get_compiler() } -> std::convertible_to<std::string_view>;
};
}
```

**RENAME (Paper-spezifisch → Cross-Axis):**
| Vorher | Nachher |
|---|---|
| `experiment_compiler()` | `get_compiler()` |
| `kExperimentCompiler` | `kCompiler` |
| `@experiment_compiler` | `@compiler` |

**Naming-Konvention etabliert:**
- `is_<eigenschaft>()` → bool (Boolean-Properties)
- `get_<eigenschaft>()` → std::string_view (String-Properties)
- `<name>()` → enum class (Stufen-Properties)
- `statistics()`/`snapshot()`/`observer()` → Struct/Type (Mess-Properties)

**Konvention der get_compiler-Werte:**
- `"original"` Default in AxisBase — beliebiger Compiler OK
- `"self"` Re-Impl ohne Paper-Bindung
- `"system"` C-Standard-libc (StdMalloc, PMR)
- `"gcc-9.5"` / `"clang-12"` / `"msvc-19.30"` konkrete Paper-Compiler

**OriginalCodeMixinBase erbt jetzt von AxisBase** und ueberschreibt `get_compiler()` mit `PaperManifest::kCompiler`.

**Commit:** `b29a34c` (cache-engine), `e27b2d7` (Diplomarbeit).

---

## §7 Tests-Bilanz (Endstand)

| Topic / Komponente | Tests | Aenderung heute Nacht |
|---|:---:|:---:|
| allocator (axis_06) | 252 | unveraendert |
| queuing (axis_q1 + axis_q2) | 205 | unveraendert |
| traversal (axis_03a + 03b + 03m) | 95 | unveraendert |
| paper_legacy_code | 17 | +6 (AxisBase Tests) — TOTAL ALLE compile-time static_assert |
| **TOTAL Cache-Engine** | **569** | **+5 heute Nacht** |
| Diplomarbeit-Container | 104 | unveraendert |

Alle Tests Compile-Time via `static_assert` — KEIN Runtime-Aufruf von `ctsha::sha256` mehr.

---

## §8 Commits heute Nacht (chronologisch)

| Commit | Inhalt | Repo |
|---|---|---|
| `35999ea` | Session-Doku (heute Abend) | Diplomarbeit |
| `dd62dac` | P2.A0 Tool Multi-Function-Manifest | cache-engine |
| `0304625` | P2.A0 Submodule-Bump | Diplomarbeit |
| `ff9ea60` | P2.A0.5 Auto-Discovery + Lock + Mixin | cache-engine |
| `3fd8a53` | P2.A0.5 Submodule-Bump | Diplomarbeit |
| `67d471d` | P2.A0.6 Achsen-generischer Mixin + Multi-File | cache-engine |
| `526277e` | P2.A0.6 Submodule-Bump | Diplomarbeit |
| `b29a34c` | P2.A0.7 AxisBase + get_compiler Rename | cache-engine |
| `e27b2d7` | P2.A0.7 Submodule-Bump | Diplomarbeit |
| `<pending>` | **Diese Session-End-Doku** | Diplomarbeit |

---

## §9 Memory-Files heute Nacht (Neu + Erweitert)

**NEU:**
1. `feedback_axis_base_pattern.md` — Wurzel-Pattern + Naming-Konvention + Konvention der get_compiler-Werte

**Erweitert (mehrfach iterativ):**
- `feedback_legacy_code_sha256_validation.md` (4 User-Direktiven-Erweiterungen)
- `reference_consteval_sha256_function_validation.md` (xxd-Auto-Install + Multi-Function-Manifest)
- `feedback_compile_time_only_no_runtime.md` (war bereits da, blieb stabil)

**MEMORY.md Index:** 1 neuer Eintrag (axis-base-pattern).

---

## §10 Status Endstand Phase B.2

| Sub-Task | Status |
|---|---|
| ~~P2.A0 Tool Multi-Function~~ | ✅ |
| ~~P2.A0.5 Auto-Discovery + Lock + Mixin~~ | ✅ |
| ~~P2.A0.6 Achsen-generischer Mixin-Template + Multi-File~~ | ✅ |
| ~~P2.A0.7 AxisBase Wurzel + get_compiler Rename~~ | ✅ |
| **P2.A** CMake-Infrastruktur (is_original_codegen + compiler_cache + paper_binary + tools_cache xxd) | pending |
| **P2.B** mimalloc Pilot End-to-End (legacy_code Snapshot + Wrapper Refactor) | pending |
| **P2.C** Concept-Pflicht-Erweiterung + Mass-Update 50 Wrapper | pending |
| **P2.C.1** (Vor-Schritt zu P2.C) AxisBase-Inheritance Mass-Update 50 Wrapper | pending NEU |
| **P2.D** Roll-out 3 weitere Allocator (jemalloc + tcmalloc + snmalloc) | pending |
| **P2.E** Architektur-Doku 13 elaborate erweitern | pending NEU |
| **P2.F** 14 Achsen-Mixin-Templates anlegen (vor Paper-Roll-out) | pending NEU |

---

## §11 Detaillierte Aufgabenliste fuer naechste Session

### Prioritaet HOCH (Pflicht vor mimalloc-Pilot)

**Task #683 (P2.E):** Architektur-Doku-Erweiterung in `docs/architektur/13_paper_legacy_code_architektur.md`:
- §X NEU AxisBase Wurzel-Pattern mit Vererbungs-Hierarchie-Diagram
- §X Pre-Build-Tool-Workflow vollstaendig dokumentieren (Auto-Discovery + Lock + Mixin)
- §X Manifest-Format mit allen @-Annotations (@compiler / @has_original_paper_code / @axis_mixin_type)
- §X User-Pflicht pro Achse vs pro Paper-Wrapper trennen
- §X Naming-Konvention `is_*` / `get_*` / Stufen / Mess
- §X get_compiler-Konvention "original" / "self" / "system" / konkret
- §X Migrations-Plan 50 Wrapper

**Task #684 (P2.F):** 14 Achsen-Mixin-Templates pro Achse anlegen (1 pro existierender Achse, plus 8 fuer zukuenftige Topics-Achsen):
- `topics/allocator/axis_06_allocator/concepts/axis_06_allocator_original_code_mixin.hpp` mit `template<typename M> struct AllocatorOriginalCodeMixin : OriginalCodeMixinBase<M> { is_original_allocate/deallocate/reallocate + is_original_module }`
- `topics/allocator/axis_06_allocator/concepts/axis_06_allocator_interface_functions.hpp` mit `kAxisInterfaceFunctions = {"allocate", "deallocate", "reallocate"}`
- queuing axis_q1: `is_original_put/get/peek_front/peek_back/clear` etc.
- queuing axis_q2: `is_original_should_flush/on_flush_complete` etc.
- traversal axis_03a: `is_original_insert/lookup/erase` etc.
- traversal axis_03b: `is_original_register_entry/resolve/unregister` etc.
- traversal axis_03m: `is_original_register_slot/resolve_offset/reverse_lookup` etc.

**Task #682 (P2.C.1):** AxisBase-Inheritance Mass-Update fuer 50 Wrapper (sed-basiert):
- Pro Wrapper: `#include <topics/axis_base.hpp>` + Inheritance `: public ::comdare::cache_engine::topics::AxisBase` nach existierender Base
- Pro Wrapper Footer: `static_assert(AxisBaseConcept<W>)`
- Defaults: StdMalloc/PMR-Resource = "system" Override, alle anderen Default "original"
- Build + alle 569 Tests gruen halten

### Prioritaet MITTEL (mimalloc Pilot)

**Task #674 (P2.A):** CMake-Infrastruktur (3 Module + xxd):
- `cmake/is_original_codegen.cmake` mit `comdare_generate_is_original_mixin(WRAPPER_NAME PAPER_ID LEGACY_CODE_DIR OUTPUT_HEADER NAMESPACE AXIS_MIXIN_TYPE)`
- `cmake/compiler_cache.cmake` mit `comdare_ensure_compiler(NAME URL SHA256 BUILD_WITH)` — Auto-Download+Build, Marker-File, Cross-Platform 3 OS + 4 ISAs
- `cmake/paper_binary.cmake` mit `comdare_build_paper_binary(PAPER COMPILER SOURCES FLAGS OUTPUT)`
- `cmake/tools_cache.cmake` mit xxd-Auto-Install via vim-Repo

**Task #675 (P2.B):** mimalloc Pilot End-to-End:
- `legacy_code/paper_a04_mimalloc/` mit kuratiertem Snapshot (alloc.c, heap.c, init.c, options.c, mimalloc.h, LICENSE MIT, compiler_info.txt, sha256_locked.txt, README.md, MODIFICATIONS.md)
- `manifest.txt` mit `@compiler gcc-9.5` + Function-Mappings
- `axis_06_allocator_mimalloc_original.hpp+cpp` extern "C" Adapter
- `axis_06_allocator_mimalloc.hpp` Refactor: erbt von `generated::a04_mimalloc::OriginalCodeMixin`
- Tests: get_compiler="gcc-9.5", is_original_module Compile-Time-Validierung

**Task #676 (P2.C):** Concept-Pflicht-Erweiterung (alle Achsen-Permutation-Concepts):
- Allocator: `&& AxisBaseConcept<A> && LegacyOriginalCodePflicht<A>`
- queuing q1/q2 analog
- traversal 03a/03b/03m analog
- Mass-Update der 50 Wrapper mit Sub-Concept-Statics (kommt nach P2.C.1)

### Prioritaet NIEDRIG (Roll-out auf weitere Allocator)

**Task #677 (P2.D):** 3 weitere Allocator mit Paper-Linking:
- A05 jemalloc (BSD-Build-System)
- A06 tcmalloc (Bazel-Build, kompliziert — eventuell Phase B.3)
- A07 snmalloc (modern C++17)

---

## §12 Naechste Session beginnt mit

**Pflicht-Pre-Read (in dieser Reihenfolge):**
1. `MEMORY.md` (Index)
2. **Dieses Dokument** (`20260526-V41-F-6-1-P2-A0-tool-refactor-axisbase-pattern-session-end.md`)
3. `20260526-V41-F-6-1-traversal-konsolidierung-paper-legacy-pattern-session.md` (Phase A Doku + erste B-Iteration)
4. `docs/architektur/13_paper_legacy_code_architektur.md` (Architektur-Schichten — Erweiterung pending in P2.E)
5. Memory `[[axis-base-pattern]]` (Wurzel-Pattern)
6. Memory `[[compile-time-only-no-runtime]]` (kritische Pflicht-Direktive)
7. Memory `[[legacy-code-sha256-validation]]` (4 User-Direktiven-Iterationen)
8. Memory `[[paper-original-code-pattern]]` (Verzeichnis-Struktur)
9. `libs/cache_engine/topics/axis_base.hpp` (Wurzel-Datei lesen)
10. `apps/is_original_validator/main.cpp` (Tool-Struktur lesen, ~390 LoC mit Auto-Discovery)

**Build-Verifikation:** 252 allocator + 205 queuing + 95 traversal + 17 paper_legacy_code = **569 Cache-Engine gruen** + **104 Diplomarbeit gruen**.

**Empfohlene Start-Reihenfolge:**
1. **P2.E** Doku-Erweiterung (Architektur-Doku 13 elaborate) — Pattern verankern bevor weiterer Code
2. **P2.F** 14 Achsen-Mixin-Templates pro Achse anlegen
3. **P2.C.1** AxisBase-Inheritance Mass-Update fuer 50 Wrapper
4. **P2.A** CMake-Infrastruktur (4 Module: is_original_codegen + compiler_cache + paper_binary + tools_cache)
5. **P2.B** mimalloc Pilot End-to-End
6. **P2.C** Concept-Pflicht-Erweiterung (cleanup nach Mass-Update)
7. **P2.D** Roll-out 3 weitere Allocator (optional)

---

## §13 Lessons-Learned heute Nacht (4 Hauptpunkte)

1. **Iterative User-Direktiven-Refactor: pragmatisch + sauber** — jede der 4
   Iterationen brachte eine echte Architektur-Verbesserung. Statt zuerst alles
   perfekt zu durchdenken, hat schrittweises Implementieren + Korrigieren ein
   sauberes Endergebnis geliefert (Tool: 7 zu single-fn CLI, dann 7 zu
   multi-fn Manifest, dann 7 zu Auto-Discovery + Mixin, dann 7 zu Achsen-
   generischem Vererbungs-Pattern). Diese Iteration ist akzeptabel **wenn der
   Code zwischenzeitlich grun bleibt** und User-Validierung passiert.

2. **MSVC-constexpr-Bugs: immer Pre-Build-Tool als Fallback erwaegen** —
   `[[compile-time-only-no-runtime]]` ist die richtige Reaktion bei
   MSVC-Issues, NICHT Runtime-Workarounds. Das gilt fuer alle Latenz-
   kritischen Pattern.

3. **Wurzel-Pattern erst nach 4 Achsen klar** — wir haben allocator, queuing,
   traversal etabliert und gemerkt dass es **strukturell synchron** ist aber
   ohne gemeinsame Wurzel. Erst da wurde klar dass `topics/axis_base.hpp`
   die fehlende Basis-Schicht ist. Lesson: gemeinsame Pattern erst nach 3+
   konkreten Achsen verallgemeinern.

4. **Naming-Konvention `is_*` vs `get_*` macht Pattern-Symmetrie sichtbar** —
   die Boolean-Properties (`is_simd_capable`, `is_versioned`, etc.) waren
   alle synchron, aber String-Properties (`get_compiler`) fehlten. Klare
   Naming-Konvention macht Symmetrie-Luecken im Audit sichtbar.

---

**Ende Session-End-Doku 2026-05-26 spaete Nacht. Kontext endet hier.**
