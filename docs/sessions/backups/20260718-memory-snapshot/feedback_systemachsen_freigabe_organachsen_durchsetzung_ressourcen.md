---
name: feedback_systemachsen_freigabe_organachsen_durchsetzung_ressourcen
description: "System-Achsen geben HW-Ressourcen frei, Organ-Achsen setzen sie durch; kein opt/OptO-Haupt-Achse; malloc=Organ/Compile-Flags=System"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

Ressourcen-Freigabe-Prinzip zwischen den Achsen-Familien (User-Ruling 2026-07-18, nach Konformitäts-Sweep):

**Vertrag Freigabe → Durchsetzung:**
- **System-Achsen = „Freigabe der Existenz zu testender Hardware-Eigenschaften"**: geben Ressourcen/HW-Features frei (extension_hardware/simd gibt AVX2/AVX512 frei; compiler gibt opt_level/-march/-mcx16 frei; hardware_isa gibt die Ziel-ISA frei, inkl. Cross-Compile x86→ARM64).
- **Organ-Achsen = „Durchsetzung verfügbarer Hardware NACH der Freigabe der System-Achsen"**: ein Organ-Algorithmus darf ein HW-Feature nur nutzen/durchsetzen, wenn die System-Achse es freigegeben hat (**Organ-Nutzung ≤ System-Freigabe**).

**Verortung (klar trennen):**
- **KEINE opt/OptO-Haupt-Achse** — die gibt es nicht, weder in System- noch Organ-Achsen. `opt_level` ist AUSSCHLIESSLICH Unter-Achse unter der `compiler`-System-Haupt-Achse. Optionen O0..Ofast heißen `OptO*Option` (nicht `SubAxis`).
- **Alle malloc (mimalloc/jemalloc/snmalloc/std_malloc) = Allokator-ORGAN-Achse** (eine der 19 Organ-Achsen), NICHT System-Achse. Das Allokator-Bibliotheks-Linking (mimalloc.a …) ist Organ-getrieben.
- **Compile-Flags (opt, -march, -mcx16, SNMALLOC_*-Defs, -fno-gnu-unique) = Compiler-System-Achse.** snmalloc (header-only Allokator=Organ) braucht -mcx16 → die Compiler-System-Achse gibt es frei (Freigabe-Prinzip in Aktion).

**Gemeinsames Dach:** Mess-Achse + System-Achse + Organ-Achse hängen unter EINEM Header/Dach `topics::Axis`; die Organ-Achsen definieren parallel die **Gattungen** (welche Gattung welche Organ-Achsen verwendet/braucht). Verwandt: [[feedback_q2_option_c_erweiterungshardware_sechste_systemachse]], [[feedback_gattung_own_genus_own_abi_nonintersecting_mutually_usable]], [[feedback_system_axes_measurement_own_abstract_root_blood]], [[feedback_jede_aufgabe_ultracode_planungssession_ledger_alle_plandocs]].
