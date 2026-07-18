---
name: feedback_no_runtime_switch
description: "cache-engine Hot-Path-Dispatch muss statisch (Templates + C++23-Concepts/if constexpr) sein — KEIN std::variant/switch/enum-Dispatch, KEINE vtable/virtual, KEINE Runtime-Registrierung im Hot-Path; dynamisches Laden (dlopen/Modul-import) NUR cold-start vor Mess-Beginn"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive (2026-05-25):** Im cache-engine-Suchalgorithmus-Hot-Path sind dynamische Dispatch-Mechaniken VERBOTEN — es muss statische Metaprogrammierung verwendet werden.

**Why:** Die Cache-Engine baut zehntausende Permutations-Binaries (default static, geladen als C++23-Modul). Auf Zielsystemen mit ±0,1 % Mess-Präzision ist Runtime-Switch-Overhead messbar und verfälscht die Algorithmus-Vergleiche — genau das misst die Thesis. Präzedenz-Fehler: 2 traversal-Stubs als Monolith mit `std::variant` + Runtime-Switch → mussten zurückgerollt werden.

**How to apply (Hot-Path):**
- KEIN `std::variant`/`if`/`switch`/`enum`-Dispatch, KEINE virtuellen Funktionen/vtable, KEINE Runtime-Registrierung.
- Dispatch nötig → `if constexpr` (Compile-Time-Branch) oder Template-Spezialisierung; Varianten zur Compile-Time auflösen (`cartesian_product_t<AxisListA, AxisListB>`), pro Permutation eine eigene Template-Instantiation; Concept-Constraints in `requires` (Vertragsverletzung bricht Build sofort).
- **Erlaubt dynamisch:** Plugin-Loader (dlopen/LoadLibrary) + C++23-`import` der Permutations-Binaries — aber NUR vor Mess-Beginn (cold start), NIE im Hot-Path.

**Herkunft:** konsolidiert aus Infra-Agent-Handover (Cluster-Repo `docs/agent-memories-infra/`, 322 redigierte Memories, cwd `C--WINDOWS-system32`), übernommen 2026-07-08. Verschärft [[feedback_metaprogrammierung_compile_time_zwingend_durchsetzen]]; siehe [[feedback_compile_time_only_no_runtime]], [[feedback_crtp_concept_guard_mix_pattern]], [[feedback_lehrbuch_design_patterns_only_zero_cost_metaprog]].
