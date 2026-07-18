---
name: feedback_lehrbuch_design_patterns_only_zero_cost_metaprog
description: "NUR benannte Lehrbuch-/erweiterte Design-Patterns (web-verifizierbar, mit Benennungskonvention); musterlose Ad-hoc-Konstrukte verboten. Erweitert durch exzessive Metaprogrammierung — aber NUR zero-cost (keine Laufzeit-Einschränkung im Hot-/Mess-Pfad). Software-Architektur = User-Spezialgebiet, er verteidigt sie fachlich."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive (2026-06-11, verbatim-Kern):** „Bezüglich Software Architecture bin ich tatsächlich immer für Lehrbuch Design patterns (gerne web recherche) und erweiterte Design pattern. Alles was weder einem ganz bestimmten Muster, noch den Benennungskonventionen entspricht, möchte ich nicht verwenden. Dies wird allerdings erweitert durch exzessive Metaprogrammierung, welche keine Laufzeit Einschränkungen für den Code mit sich bringt."

**Why:** Der User reviewt/verteidigt die Architektur fachlich (Thesis + Spezialgebiet). Jede Struktur muss einem zitierfähigen, benannten Muster zuordenbar sein (GoF + etablierte erweiterte C++-Patterns: CRTP, Policy-Based Design, Type Erasure, Registry, Expression Templates, Tag Dispatching, Traits/Mixin) inkl. Benennungskonvention. Ad-hoc-Konstrukte ohne Muster-Zuordnung sind nicht verteidigbar → unerwünscht.

**How to apply:** (1) Bei JEDEM neuen Design zuerst das passende benannte Pattern wählen, Implementierung + Benennung daran ausrichten (bei Unsicherheit Web-Recherche zur kanonischen Definition — erwünscht). (2) Musterlose Strukturen: einem Muster zuordnen/umbauen oder als Befund melden, NICHT fortschreiben. (3) Pattern-Namen nur tragen, wenn korrekt umgesetzt (falsch etikettiert ist schlimmer als unbenannt). (4) Metaprogrammierung (mp11/Concepts/`if constexpr`/CRTP) frei — aber Laufzeitkosten daraus (virtuelle Dispatches wo compile-time möglich, `dynamic_cast` im Hot-Loop, `std::function`/Heap via Meta-Konstrukte, Runtime-Switch statt `if constexpr`) sind Verstöße.

**Herkunft:** konsolidiert aus Infra-Agent-Handover (Cluster `docs/agent-memories-infra/`, cwd `C--WINDOWS-system32`), übernommen 2026-07-08. Trägt [[feedback_no_runtime_switch]], [[feedback_compile_time_only_no_runtime]], [[reference_meta_driven_concept_hardening_pattern]]; siehe [[feedback_never_guess_always_lookup_state_of_art_and_docs]].
