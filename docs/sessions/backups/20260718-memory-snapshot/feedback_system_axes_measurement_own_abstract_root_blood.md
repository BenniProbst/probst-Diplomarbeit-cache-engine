---
name: feedback_system_axes_measurement_own_abstract_root_blood
description: "Architektur (User 09.07.): das Mess-System hat eigene SYSTEM-ACHSEN mit einer eigenen abstrakten Klassen-Wurzel — unabhängig von den Tier-Binary-(Organ-)Achsen, IMMER präsent bei eingeschalteter Messung, NICHT Teil der Gattungen, nicht austauschbar = 'Blut' in der Tier-Metapher (zentrale Systembestandteile). Distinkt von den ~19 permutierbaren Algorithmus-/Organ-Achsen."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive 2026-07-09 (Mess-Architektur, bindend):** Es gibt **zwei distinkte Achsen-Systeme**, die nie zu vermischen sind:

1. **Tier-Binary-/Algorithmus-Achsen** (~19, T0–T18): die **Organe** der Tier-Metapher — permutierbar, compile-time, Teil der **Gattungen/Lebewesen**, das *Gemessene und zu Optimierende*. Austauschbar (Composition). Jede hat eine Min/Max-Optimierungs-Eigenschaft ([[feedback_axes_optimization_semantics_deep_research_observer_strategy]]).

2. **System-Achsen des Mess-Systems**: haben eine **EIGENE abstrakte Klassen-Wurzel**, existieren **unabhängig** von den Tier-Achsen und sind **IMMER präsent, sobald Messung eingeschaltet ist**. Sie zählen **NICHT zu den Gattungen** — es sind **zentrale, nicht austauschbare Systembestandteile**, in der Tier-Metapher = **„Blut"** (nicht ein Organ, sondern durchdringend/immer da). Das sind die Mess-Instrumente/Kategorien selbst (Cache-Line-Auslastung, Cache-Miss L1/L2/L3, dTLB-Miss, Branch-Miss, IPC/CPI, Latenz, Durchsatz, Energie, Speicher-Fußabdruck).

**Formalisiert** den bisher nur fragmentiert vorliegenden „parallelen Achsen-Messsystem"-Befund (Dossier 17 Teil B.3; code-review-Agent 2): der Code hat `MeasurementCategory`-Enum + `IPmcSource` + POD-Spalten + Klassifikationen, aber **keine gemeinsame abstrakte Wurzel** — genau die ist der SOLL-Zustand: eine `SystemAxis`/`IMeasurementSource`-Basis, immer instanziiert unter Messung, orthogonal zu den Organ-Achsen.

**Konsequenz für die Implementierung:**
- Die System-Achsen (Blut) bekommen eine eigene abstrakte Basis-Klasse (Wurzel), immer präsent bei Messung, NICHT im Composition-/Gattungs-Baum.
- Die Organ-Achsen (Tier) werden VON den System-Achsen gemessen; ihre Wirkungsweise = Observer-Strategy ([[feedback_axes_optimization_semantics_deep_research_observer_strategy]]), aber die Observer-INFRASTRUKTUR selbst = System-Achsen (Blut).
- E4→E0-Interface-Layer strikt einhalten; System-Achsen sind ein Querschnitt (E0-nah/Mess), nicht Teil des E2/E3-Permutationsbaums.
- Bei #221/Mess-Neuimpl.: Organ-Achsen-Effekte (Min/Max) NICHT mit System-Achsen (Mess-Instrumenten) vermischen. Siehe [[feedback_no_whole_tier_axes_genus_configurator]] [[feedback_crtp_concept_guard_mix_pattern]] [[feedback_e4_xml_autoritative_bauanleitung_ceb_orchestriert]].
