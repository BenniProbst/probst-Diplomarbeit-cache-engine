---
name: feedback_compile_time_only_no_runtime
description: "Wo Compile-Time-Auswertung möglich ist, ist sie PFLICHT — Runtime-Auswertung von Properties/Validierungs-Checks bei latenz-kritischen Suchalgorithmen VERBOTEN; bei constexpr-Compiler-Bug NICHT Runtime-Fallback, sondern Pre-Build-Codegen-Tool (Output = constexpr-Header)"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive (2026-05-26, verbatim-Kern):** „Wir hatten compile time definiert, runtime ist VERBOTEN, wir haben latenzkritische Suchalgorithmen. Workaround wäre ein separates Programm für is_original, welches zur compile time ausgewertet wird."

**Why:** Latenz-kritische Such-Algorithmen (Diplomarbeit-Mess-Pfad) dürfen ZERO Runtime-Overhead für Properties haben. Eine SHA256-Berechnung zur Runtime wäre ~100k Ops pro Lookup — inakzeptabel. Auch „einmalig beim Programmstart" ist verboten, weil es die Mess-Reihe verfälscht (Initialisierungs-Phase).

**How to apply — Pflicht-Reihenfolge bei constexpr-Problemen:**
1. `consteval`/`constexpr` funktioniert auf allen Ziel-Compilern → NUTZEN.
2. Compiler-constexpr-Bug (z. B. MSVC) → **NICHT Runtime-Fallback**, sondern **Pre-Build-Codegen-Tool** (Standalone-C++-Binary, AUSSERHALB des ce-Compiles), das den Wert zur Build-Time berechnet und als `inline constexpr bool k... = true;`-Header emittiert; der Wrapper gibt direkt den Literal zurück (zero cost).
3. Nicht consteval-fähig (externe Lib) → Pre-Build-Tool ruft die Lib, Output ist constexpr-Header.
- **Anti-Pattern (verboten):** Runtime-`sha256(...)` im Test statt `static_assert`; Lazy-Init-Cache beim Programmstart.
- Tests für `is_original_*()` via `static_assert` (Compile-Time); `EXPECT_*` nur als Doppel-Check danach.

**Herkunft:** konsolidiert aus Infra-Agent-Handover (Cluster `docs/agent-memories-infra/`, cwd `C--WINDOWS-system32`), übernommen 2026-07-08. Überlagert [[feedback_no_runtime_switch]] explizit für Validation-Checks; verschärft [[feedback_metaprogrammierung_compile_time_zwingend_durchsetzen]]; Pre-Build-Tool = C++-Binary, kein Python ([[feedback_no_python_in_buildchain]]).
