---
name: feedback_crtp_concept_guard_mix_pattern
description: "ce-Achsen-Klassen = MIX aus CRTP-Basis (Default-Methoden via Compile-Time-Inlining) + C++23-Concept-Guard (API-Vollständigkeit); pro Ordner-/Hierarchie-Ebene GENAU EIN Concept-File; keine vtable/virtual/dynamischer Dispatch"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive (2026-05-25, RQ-1):** cache-engine-Achsen-Klassen verwenden ein **Mix-Pattern CRTP + Concept-Guard**: die CRTP-Basis liefert Default-Methoden via Compile-Time-Inlining, das Concept-Constraint sichert die API-Vollständigkeit ab.

**Why:** CRTP allein hat keine API-Garantie, reines Concept allein keine Default-Methoden. Der Mix liefert beides: Compile-Time-Polymorphie + Vertragsverletzungs-Fehler bei Concept-Failure (klare Compiler-Diagnostik statt Runtime-Crash).

**How to apply:**
- Pro Ordner/Unterordner GENAU EIN Concept-File (`topics/<topic>/concepts/topic_concept.hpp` + `axis_NN/concepts/axis_concept.hpp` + `sub_NN/concepts/sub_concept.hpp`).
- Topic-Concept breit (z. B. `AllocatorComponent` fordert allocate/deallocate); Achsen-Concept erweitert es eng (`AllocatorStrategy` fordert zusätzlich pool_kind/bytes_in_use).
- CRTP-Basis trägt `requires concepts::<AxisConcept><Derived>` als Template-Constraint; Default-Methoden via `static_cast<Derived*>(this)->impl_method()`.
- KEINE virtuellen Funktionen, KEINE vtable, KEIN dynamischer Dispatch. Concept-Failure → Build-Error.

**Herkunft:** konsolidiert aus Infra-Agent-Handover (Cluster `docs/agent-memories-infra/`, cwd `C--WINDOWS-system32`), übernommen 2026-07-08. Instanz von [[reference_meta_driven_concept_hardening_pattern]] (CRTP = M1-Generalisierung); trägt [[feedback_no_runtime_switch]], [[feedback_lehrbuch_design_patterns_only_zero_cost_metaprog]].
