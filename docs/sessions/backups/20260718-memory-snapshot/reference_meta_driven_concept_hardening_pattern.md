---
name: reference_meta_driven_concept_hardening_pattern
description: "Zitierfähige Fach-Benennung des ce-Architekturmusters (C++23-Concepts + MP11 + CRTP + CMake-Codegen) = Compile-Time Meta-Object Protocol / statisch validierte M2→M1-Transformation (MOF); mit MOF-M0–M3-Mapping, Java-Meta-Model-Äquivalenten und wissenschaftlichen Primärquellen für Thesis-Outbound-Zitate"
metadata:
  node_type: memory
  type: reference
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**Zweck (Thesis-Zitierbarkeit):** Das ce-Architekturmuster (Concept-constrained Type-List-Computation + CRTP-Basis + Boost.MP11-Registry + CMake `configure_file`-Codegen) hat eine kanonische, zitierfähige Fach-Bezeichnung — für die Thesis nutzbar statt Ad-hoc-Beschreibung.

**Benennungen:** akademisch = „Compile-Time Meta-Object Protocol mit Concept-constrained Type-List Computation"; Industrie = „Static Concept-driven Meta-Programming with Type-Registry Codegen"; Sheard-2001-Taxonomie = „compile-time, generative, homogeneous meta-programming"; OMG/MDE = „statisch validierte M2→M1-Transformation mit externer M2-Konfiguration via CMake".

**MOF-Schicht-Mapping (OMG MOF 2.5.1):** M0 = konkrete Instanz (`MyAllocator a;`) · M1 = User-Modell (Wrapper-Klasse) · M2 = Meta-Modell (C++23-`concept`) · M3 = C++-Type-System selbst. Java-Äquivalente für Kommunikation: `@interface`→`concept`; Reflection `getMethod`→`requires`-Ausdruck; EMF `EClass`→`AxisTraits` + `mp_list`; APT-Processor→`configure_file` + `mp_for_each`; `ClassCastException`(runtime)→`static_assert`(compile-time). Vorteil: Zero-Cost, Compile-Time-Korrektheit, deterministisches Layout.

**Primärquellen (vollständige Angaben für Outbound-Zitate):** Kiczales/des Rivières/Bobrow, *The Art of the Metaobject Protocol*, MIT Press 1991 · Bézivin, *On the Unification Power of Models*, SoSyM 4(2) 2005 · Stahl/Völter/Czarnecki, *Model-Driven Software Development*, Wiley 2006 · OMG, *MOF Core Spec 2.5.1*, formal/2016-11-01 · Gregor/Järvi/Siek/Stroustrup u. a., *Concepts: Linguistic Support for Generic Programming in C++*, OOPSLA 2006, S. 291–310 · Sheard, *Accomplishments and Research Challenges in Meta-programming*, SAIG 2001 (LNCS 2196), S. 2–44.

**Herkunft:** konsolidiert aus Infra-Agent-Handover (Cluster `docs/agent-memories-infra/`, cwd `C--WINDOWS-system32`), übernommen 2026-07-08. Verwandt: [[feedback_lehrbuch_design_patterns_only_zero_cost_metaprog]], [[feedback_crtp_concept_guard_mix_pattern]], [[feedback_no_runtime_switch]], [[reference_thesis_core_contribution_axis_library]]. Outbound-Zitier-Disziplin: nur Primärquellen ([[feedback_never_guess_always_lookup_state_of_art_and_docs]]).
