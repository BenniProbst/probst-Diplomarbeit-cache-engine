export const meta = {
  name: 'design-unified-experiment-xml-registry',
  description: 'EIN Experiment-XML (alle Settings, vereint Familie A+C) + separate System-Registry-XML (baustein→slot, a+b konfigurierbar) + Parser als MODUL im allgemeinen ce-Parser + C.1-C.3-Verdrahtung (Verdikt→reale Katalog-DLLs) — TABU-neutral',
  phases: [
    { title: 'Recherche', detail: 'Vereinheitlichung+Parser-Modul · Registry-XML+L6 · C.1-C.3-Verdrahtung · TABU+Backups' },
    { title: 'Synthese', detail: 'Increment-Plan zur korrigierten Unified-XML-Architektur' },
  ],
}

const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'

const CTX = `
KORRIGIERTE ZIEL-ARCHITEKTUR (User 2026-07-13, bindend):
- Es gibt genau EIN Experiment-XML-Dokument (= individuelle Config) für ALLE Einstellungen EINES Experiments: die 3 Durchlauf-/Mess-Modi, die dann verfügbaren Achsen + gewählte Bausteine, Workloads, Datasets, measurement_categories, execution_engines (EE-A/EE-B = SOTA-vs-Prüfling), op_types, Output. Das VEREINT die heutige Familie A (comdare_thesis_profile) UND Familie C (messreihe_v32) in EINEM Dokument. KEIN separates Dokument je Aspekt.
- Es gibt eine SEPARATE System-Registry-XML (Registry = System-Ebene): der Slot/Baustein-Katalog, der die verfügbaren Bausteine je Achse + deren Abbildung auf compile-time-Slots definiert. Dadurch ist BEIDES konfigurierbar — (a) Baustein-je-Achse UND (b) lebewesen+merge — ALLES in XML.
- Der XML-Parser muss ein MODUL im ALLGEMEINEN Cache-Engine-Parser sein (ce/libs/common/serialization/xml_config_parser, den die Diplomarbeit nutzt), NICHT standalone. Der eben gebaute standalone-Parser super/Code/02_messung_driver/messreihe_v32_parser.hpp (super 6a40fb9) integriert dort als Modul.
IST-STAND: getrennt — allgemeiner Parser parse_thesis_profile (Familie A, ce/libs/common/serialization/xml_config_parser) vs standalone messreihe_v32_parser (Familie C, super/Code/02). Rollback-Anker ce 9f05c6db / super 8f813d1 (+Parser 6a40fb9). Metaprog-Plan-Backup: ${SUPER}/docs/sessions/backups/20260713-achsen-gattungen-metaprog/wf-RESULT-raw.json §2 (pruefling_merge/sota_catalog/serialize_composition_path/PrueflingSlot).
DIREKTIVEN: compile-time-only Hot-Path (CRTP+Concepts, kein Runtime-Switch/vtable, benannte Patterns); WAS/WIE (ce=Framework/super=Definition); sauberster Weg; TABU (permutation_axes.xml/golden_fullpilot_320/POD-1416/ABI-4/kV3AxisSchema/GenusBindingTraits/Registry-mp_list) unberührt — Erweiterungen golden-neutral/Default-OFF; Doku/Messdaten nie löschen. honest-100%; belege datei:zeile; Unbelegtes=UNBELEGT.
`

phase('Recherche')

const research = await parallel([
  // R1 — Vereinheitlichung + Parser-als-Modul
  () => agent(
`ULTRACODE-Recherche + Design, belege datei:zeile. Wie wird EIN Experiment-XML gebaut, das Familie A (comdare_thesis_profile) + Familie C (messreihe_v32) VEREINT, und der Parser ein MODUL im allgemeinen ce-Parser?
- Der allgemeine Parser: ${CE}/libs/common/serialization/xml_config_parser/xml_config_parser.{hpp,cpp} — struct ThesisProfile (:195), parse_thesis_profile (:248), die Elemente (base_tiers/permute_axes/workloads/datasets/measurement_categories/sota_series/run_options/modes). Wie ist er modular aufgebaut (pro Element ein Reader)?
- Der standalone v32-Parser: ${SUPER}/Code/02_messung_driver/messreihe_v32_parser.hpp (MessreiheV32: engines/default_lookup/tupel{workload,op_type,hardware/scheduling/compiler,axes{id,baustein}}/output). Welche v32-Aspekte FEHLEN im allgemeinen Parser (engines/op_type/axes-baustein-Wahl/comparison_metrics)?
- DESIGN: wie fügt man die v32-Aspekte als MODUL(e) in den allgemeinen Parser ein (ein vereintes <comdare_experiment>- bzw. erweitertes <comdare_thesis_profile>-Schema)? WAS/WIE: der Parser gehört nach ce (Framework). Wie wandert der super-standalone-Parser sauber nach ce als Modul (Deprecaten des super-Standalone, nicht löschen)?
- Wie bleiben die schon gebauten Familie-A-Felder (datasets/measurement_categories) + golden-320 unberührt?
${CTX}
Liefere: das vereinte Experiment-XML-Schema (alle Elemente, eine Wurzel) + die Parser-Modularisierungs-Spec (wo je Modul, wie der v32-Parser integriert) + Migrations-/Deprecation-Weg, datei:zeile.`,
    { label: 'R1:unify-parser-modul', phase: 'Recherche' }),

  // R2 — System-Registry-XML + L-6 (beides via Registry)
  () => agent(
`ULTRACODE-Recherche + Design, belege datei:zeile. Design die SEPARATE System-Registry-XML + wie sie L-6 löst (beides a+b konfigurierbar).
- Registry = System: eine separate XML, die je Achse die verfügbaren Bausteine + deren Abbildung auf compile-time-Slots/Kompositionen katalogisiert. Existiert schon ein System-Katalog im Code? ${CE}/libs/**/axis_library_registry.hpp, sota_catalog.hpp, registry_to_axis_levels.hpp, DefaultLookupRegistry, permutation_axes.xml (TABU — nur als Muster lesen).
- L-6-Mechanik: wie bildet ein Registry-XML-Baustein-Name (String) auf einen compile-time PrueflingSlot/Kompositions-Typ ab? ${CE}/libs/cache_engine/anatomy/pruefling_merge.hpp + compositions/prt_art_merge_reference.hpp (die 4 Slots) + serialize_composition_path (golden, TABU — read-only). Die String→Typ-Brücke: mp_list-Lookup? Codegen-Emission (wie sota_catalog COMDARE_DEFINE_ANATOMY_MODULE)? Auto-Permutator?
- BEIDES konfigurierbar: (a) Experiment-XML wählt je Achse einen Baustein aus der Registry; (b) Experiment-XML wählt lebewesen+merge (Stufe) — beides gültig, alles in XML.
- TABU: golden_fullpilot_320/serialize_composition_path/permutation_axes.xml UNBERÜHRT (die Registry-XML ist additiv, System-Ebene; das binary_id-Format bleibt). golden-neutral halten.
${CTX}
Liefere: das Registry-XML-Schema (System) + die belegte compile-time String→Slot-Brücke + wie a+b im Experiment-XML konfiguriert werden + TABU-Nachweis, datei:zeile.`,
    { label: 'R2:registry-xml-L6', phase: 'Recherche' }),

  // R3 — C.1-C.3 Verdrahtung
  () => agent(
`ULTRACODE-Recherche, belege datei:zeile. Spezifiziere die Verdrahtung des Verdikt-Layers an die REALEN Katalog-DLLs, gespeist aus dem vereinten Experiment-XML.
- C.1 Surrogat-Ersatz: ${SUPER}/Code/02_messung_driver/v32_orchestrator.hpp:148-180 (EE-A/EE-B-Adapter, PrtArtHashBackend=unordered_map Surrogat) → stattdessen reale Stufe-1/Stufe-2-Katalog-DLLs (AnatomyModuleLoader→dynamic_cast<IObservableTier*>, tier_observe). Braucht es einen Tier→EngineCallable-Adapter?
- C.2 execute_messreihe (v32_orchestrator.hpp:81-85 Stub return 0) an das vereinte Experiment-XML (aus R1-Parser) + Registry (R2) verdrahten → Katalog-Build → 3 Mess-Dimensionen → CompareEngineCommand/welch_t_test → MessreiheReport.
- C.3 messung_driver-Antrieb (main.cpp ruft execute_messreihe nie; #230 test-harness-Einsperrung) — INERT-by-default (eigener Flag COMDARE_V32_DRIVER_ENABLE); Export via messreihe_report_exporter → xml→pdf-Anhang-Kette.
- op_type OP-1..6 (op_type_filter.hpp) → cmd::WorkloadKind Einspeisung.
${CTX}
Liefere: C.1/C.2/C.3-Spec (Dateien/Zeilen, benannte Patterns, compile-time-Grenze, INERT-Flag, Export-Anschluss), TABU-Check.`,
    { label: 'R3:C1-C3-verdrahtung', phase: 'Recherche' }),

  // R4 — TABU + vorgeschriebene Backups
  () => agent(
`ULTRACODE-Recherche, belege datei:zeile. TABU-Leitplanken + die vom Goal vorgeschriebenen Backups lesen.
- TABU für die Unified-XML+Registry+Verdrahtung: golden_fullpilot_320 + CatalogAxes<4,4,5,4>=320 (#229, docs/architektur/17 B.1) — darf das vereinte XML die Achsen-Grenze über 320 hinaus treiben? (NEIN ohne GO). serialize_composition_path/POD-1416/kV3AxisSchema/ABI-4/GenusBindingTraits/permutation_axes.xml — welche berührt die Vereinheitlichung/Registry potentiell, wie golden-neutral halten (additiv, Default-OFF)?
- LIES ${SUPER}/docs/sessions/backups/20260712-full-line-review/ (REVIEW-BERICHT.md+MANIFEST.md) + ${SUPER}/docs/sessions/backups/20260712-forgotten-todo-sweep/ — welche offenen/vergessenen Punkte betreffen den XML-Parser / thesis_profile / v32 / EE-A-EE-B / Katalog / #229 / #230 / die Achsen-Registry?
- Ledger W4 ~:961 (3 quarantänisierte ALT-Pfade) + #229/#230 — Abgrenzung bestätigen.
${CTX}
Liefere: TABU-Leitplanken je Increment + relevante vergessene/offene Punkte aus den 2 Backups (datei:zeile) + golden-Neutralitäts-Nachweis.`,
    { label: 'R4:tabu-backups', phase: 'Recherche' }),
])

const [r1, r2, r3, r4] = research.map(r => r || '(kein Ergebnis)')

phase('Synthese')

const plan = await agent(
`Du bist der Architekt. honest-100%, Goal-V4. Fasse die 4 Berichte zu EINEM Increment-Plan für die korrigierte Unified-XML-Architektur zusammen (zur User-Bestätigung; NEUE Architektur → Optionen+Empfehlung, kein Bau).

=== R1 Vereinheitlichung+Parser-Modul ===
${r1}
=== R2 Registry-XML+L6 ===
${r2}
=== R3 C.1-C.3 Verdrahtung ===
${r3}
=== R4 TABU+Backups ===
${r4}

${CTX}

Liefere:
1. **VEREINTES EXPERIMENT-XML-SCHEMA** (eine Wurzel, alle Settings; wie Familie A+C verschmelzen) + **SYSTEM-REGISTRY-XML-SCHEMA** (baustein→slot) — konkret.
2. **PARSER-MODUL-MIGRATION** — wie der Parser Modul im allgemeinen ce-Parser wird (v32-Standalone → ce-Modul, super deprecaten), WAS/WIE-konform.
3. **L-6 = beides via Registry** — die compile-time String→Slot-Brücke, a+b konfigurierbar, TABU-neutral.
4. **INCREMENT-PLAN** (geordnet: Vereinheitlichung/Registry/Parser-Modul zuerst, dann C.1-C.3-Verdrahtung), je Increment: Dateien/Zeilen · Mechanik/Patterns · Gate (ctest/golden-320==320/cf22/mojibake) · INERT-Flag.
5. **TABU-CHECK** + **vergessene Punkte** aus den 2 Backups.
6. **Die 1-2 Rest-Entscheidungen für den User** (z.B. #229 CatalogAxes-Grenze berühren?) + benannte deep-research-Bedarfe.
Konkret genug für direkte Umsetzung nach GO. Markiere unbelegte Annahmen.`,
  { label: 'synthese:unified-plan', phase: 'Synthese' })

return { plan, recherche: { r1, r2, r3, r4 } }
