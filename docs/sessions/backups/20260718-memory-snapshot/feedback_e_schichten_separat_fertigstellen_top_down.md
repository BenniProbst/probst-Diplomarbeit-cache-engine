---
name: feedback_e_schichten_separat_fertigstellen_top_down
description: "Vorgehens-Direktive (User 2026-07-09): die E-Ebenen E4→E1 (+Mess-Querschnitt) NACHEINANDER separat fertigstellen, je Schicht saubere Interfaces + getrennte Testbarkeit — 'das System ist für multiple Ebenen gleichzeitig zu groß'. Top-down-Fertigstellungs-Richtung; ORIGIN = SESSION-ENDE-9 + ce-Kontext-Dossier §13/§16 (28.06.)."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive 2026-07-09 (Arbeitsorganisation, bindend):** „Wir möchten jede dieser Schichten [E4 bis E1] mit sauberen Interfaces **nacheinander separat fertigstellen und getrennt testen** können. Das System ist für multiple Ebenen gleichzeitig zu groß."

**Why:** Zwei revertierte Implementierungen (Phase 1 #230, Phase 2 #221) schnitten quer durch mehrere Ebenen und scheiterten an Wechselwirkungen, die erst zur Mess-Laufzeit/im super-Sub-Build manifestierten. Schichtweise Fertigstellung mit Interface-Verträgen begrenzt den Blast-Radius und macht jede Ebene einzeln abnehmbar.

**How to apply:**
1. **Reihenfolge = top-down E4→E3→E2→E1, E0 zuletzt** — re-etabliert die ORIGIN-Direktive vom 28.06. (super `docs/sessions/20260628-SESSION-ENDE-9-…md` §7; ce `docs/sessions/20260628-KONTEXT-DOSSIER-…md` §13 Vier-Ebenen-Definition + §16 „top-down ab E4; E0 = Schlussphase").
2. **Je Schicht:** (a) Interface-Vertrag zur Nachbar-Ebene explizit festschreiben (E4→E3: XML→`ThesisProfile`→`AxisLevel`; E3→E2: `StaticBinaryView`/binary_id→DLL-Bau; E2→E1: ABI `IResourceControllableTier`/`ComdareResourceControlV1`; E1→E4: Snapshot-POD/`kV3AxisSchema`→CSV), (b) Definition-of-Done je Ebene, (c) **separater Test-Harness pro Ebene** mit Fake/Stub der Nachbar-Ebene (Contract-Tests), so dass eine Ebene FERTIG werden kann, bevor die darunterliegende ihre Werte konsumiert.
3. Das Mess-System (System-Achsen „Blut", [[feedback_system_axes_measurement_own_abstract_root_blood]]) ist KEINE E-Schicht, sondern Querschnitt — als eigenes, separat testbares Modul mit eigener Wurzel behandeln.
4. Keine Increments mehr, die mehrere Ebenen gleichzeitig umbauen; ebenen-übergreifende Arbeiten in je-Ebene-Teilschritte mit Vertrags-Grenze zerlegen. Siehe [[feedback_axes_optimization_semantics_deep_research_observer_strategy]] (E4→E0 interface-strikt), [[feedback_e4_xml_autoritative_bauanleitung_ceb_orchestriert]].

**ERGÄNZUNG (User 09.07. abends):** (a) **Abstraktions-Semantik:** E4 = abstrakteste Anwender-Ebene des Frameworks, E1/E0 = präziseste Detailimplementierung ([[feedback_ceb_drei_modi_arbeitsmodus_hot_tier_switching]]). (b) **Review-Kadenz je Schicht:** für JEDE Schicht genau EINEN einzelnen GROSSEN adversarialen Review-Workflow fahren und dessen Rohdaten+Synthese jeweils einzeln in einem eigenen Backup-Ordner unter super `docs/sessions/backups/` sichern — so lässt sich jede Schicht später dokumentiert nachlesen und Details per ultracode-Workflow abfragen ([[feedback_consult_analysis_backups_via_ultracode_before_decisions]]).
