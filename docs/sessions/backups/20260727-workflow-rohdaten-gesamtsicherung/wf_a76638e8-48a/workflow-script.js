export const meta = {
  name: 'design-two-registries-experiment-strategy',
  description: 'Finale Architektur: ce-Registry-XML(SOTA)+prt-art-Registry-XML(gleiches Schema, Bausteine je Achse je Engine) + Diplomarbeit-Experiment-XML(3-Phasen-Vorlage, referenziert Registries, KEINE Bausteine) + Parser als ce-Modul + v32→Strategy-Pattern der Experiment-Configs — TABU-neutral',
  phases: [
    { title: 'Recherche', detail: 'Registry-Mechanik(ce+prt-art) · Experiment-XML+Parser-Modul · Strategy+C.1-C.3 · TABU+Backups' },
    { title: 'Synthese', detail: 'Increment-Plan zur finalen Zwei-Registry+Strategy-Architektur' },
  ],
}

const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'
const PRT = SUPER + '/Code/external/comdare-prt-art'

const CTX = `
FINALE ZIEL-ARCHITEKTUR (User 2026-07-13, bindend — das vollständige Prinzip):
1. Cache-Engine-REGISTRY-XML (Stand der Technik): katalogisiert die je Achse in der CACHE-ENGINE vorhandenen Bausteine (Achsen-Algorithmen). System-Ebene.
2. PRT-ART-REGISTRY-XML (Prüfling): GLEICHES Schema wie (1), katalogisiert die je Achse im PRT-ART vorhandenen Bausteine — abstrakt, auf Basis der Cache-Engine-C++23-Bibliothek. System-Ebene.
   ⇒ Die Bausteine je Achse stehen NICHT in der Diplomarbeit-XML, sondern je Engine in DEREN Registry (nach dort vorhandenen Achsen-Algorithmen).
3. Diplomarbeit-EXPERIMENT-XML (individuelle Config): definiert NUR die Experimentier-VORLAGE — die 3 PHASEN der Prüfung (Phase 1 prt-art, Phase 2 cache-engine, Phase 3 kombinierte Achsen von beiden) + welche Engines/Lebewesen + Mess-Settings (3 Mess-Modi, workloads, datasets, measurement_categories, op_types, output). Sie REFERENZIERT die zwei Registries, listet SELBST keine per-Achse-Bausteine. Sie weist die Cache-Engine an, den prt-art mit seiner abstrakten Registry-Definition durchzumessen.
4. Der XML-Parser ist ein MODUL im allgemeinen ce-Parser (ce/libs/common/serialization/xml_config_parser); der 13.07. gebaute standalone super/Code/02_messung_driver/messreihe_v32_parser.hpp integriert dort (super deprecaten, nicht löschen).
5. Das v32-Modul soll nach professioneller Softwarearchitektur in ein STRATEGY-PATTERN der Experimentier-Configs überführt werden (jede Phase/Config = eine Strategy).
Die 3 Phasen bilden auf den bereits gebauten 3-Stufen-Join ab (pruefling_merge.hpp: Stufe1 CE-only / Stufe2 Prüfling-ersetzt / Stufe3 Voll-Join). Rollback-Anker ce 9f05c6db / super 8f813d1 (+Parser 6a40fb9).
DIREKTIVEN: compile-time-only Hot-Path (CRTP+Concepts, kein Runtime-Switch/vtable, benannte Patterns); WAS/WIE (ce=Framework/super=Definition); sauberster Weg; TABU (permutation_axes.xml/golden_fullpilot_320/POD-1416/ABI-4/kV3AxisSchema/GenusBindingTraits/Registry-mp_list) UNBERÜHRT — additiv/golden-neutral/Default-OFF; Doku/Messdaten nie löschen. honest-100%; belege datei:zeile; Unbelegtes=UNBELEGT.
`

phase('Recherche')

const research = await parallel([
  // R1 — Registry-Mechanik (ce + prt-art, gleiches Schema)
  () => agent(
`ULTRACODE-Recherche + Design, belege datei:zeile. Wie sehen die ZWEI Registries aus (ce-SOTA + prt-art-abstrakt, GLEICHES Schema, Bausteine je Achse je Engine)?
- Existiert schon eine ce-Registry-XML für den Stand der Technik? WICHTIG: ist ${CE}/**/permutation_axes.xml (TABU!) diese Registry, oder etwas anderes? Lies sie READ-ONLY + prüfe ihr Schema (Achse→verfügbare Bausteine). ${CE}/libs/**/axis_library_registry.hpp, registry_to_axis_levels.hpp, AllX=mp_list-Registries je Achse, sota_catalog.hpp.
- Die prt-art-Seite: ${PRT}/prt_art/** — die 4 vorhandenen Slots (axis_01_page_type/07_prefetch/11_telemetry/14_value_handle), prt_art_reference.hpp (PrtArtComposition, 19 Achsen). Wie würde eine prt-art-Registry-XML (gleiches Schema, prt-arts Bausteine je Achse, auf Basis der ce-C++23-Lib) aussehen + wie generiert man sie aus dem prt-art-Code?
- Der compile-time-Bezug: wie bildet ein Registry-XML-Baustein-Name (String) je Achse auf den realen compile-time-Slot/Strategy-Typ ab (pruefling_merge PrueflingSlot, serialize_composition_path TABU-read-only)? Die String→Typ-Brücke.
- TABU: permutation_axes.xml + golden_fullpilot_320 UNBERÜHRT — die prt-art-Registry + Experiment-Referenzierung sind ADDITIV.
${CTX}
Liefere: das gemeinsame Registry-XML-Schema + ob permutation_axes.xml die ce-Registry IST (dann TABU-read-only, prt-art-Registry als additives Gegenstück) + die String→compile-time-Slot-Brücke + wie die prt-art-Registry aus prt-art-Code entsteht, datei:zeile.`,
    { label: 'R1:zwei-registries', phase: 'Recherche' }),

  // R2 — Experiment-XML (3-Phasen) + Parser-Modul
  () => agent(
`ULTRACODE-Recherche + Design, belege datei:zeile. Wie sieht das Diplomarbeit-Experiment-XML (3-Phasen-Vorlage, referenziert Registries, KEINE Bausteine) aus + wie wird der Parser ein Modul im allgemeinen ce-Parser?
- Der allgemeine Parser: ${CE}/libs/common/serialization/xml_config_parser/xml_config_parser.{hpp,cpp} (ThesisProfile :195, parse_thesis_profile :248, modulare Element-Reader). Wie ist er aufgebaut?
- Der standalone v32-Parser: ${SUPER}/Code/02_messung_driver/messreihe_v32_parser.hpp (MessreiheV32). Welche Experiment-Aspekte (3 Phasen, Engine-Wahl, Registry-Referenz) fehlen im allgemeinen Parser?
- DESIGN Experiment-XML: eine Wurzel mit den 3 PHASEN (Phase1 prt-art / Phase2 cache-engine / Phase3 kombiniert = Stufe1/2/3 3-Stufen-Join, pruefling_merge.hpp), Engine-Referenzen auf die zwei Registries, Mess-Settings (workloads/datasets/measurement_categories/op_types/output) — aber KEINE per-Achse-Bausteine (die kommen aus den Registries). Wie bildet Phase→Stufe ab (sota_catalog sota_module_for merge)?
- DESIGN Parser-Modul: wie wandert der v32-Parser als Modul in den allgemeinen ce-Parser (WAS/WIE: ce=Framework); Migrations-/Deprecation-Weg des super-Standalone.
${CTX}
Liefere: das Experiment-XML-Schema (3-Phasen-Vorlage, referenziert Registries) + Phase→Stufe-Mapping + Parser-Modul-Integrations-Spec, datei:zeile.`,
    { label: 'R2:experiment-xml-parser', phase: 'Recherche' }),

  // R3 — Strategy-Pattern + C.1-C.3
  () => agent(
`ULTRACODE-Recherche + Design, belege datei:zeile. (A) Wie wird das v32-Modul in ein STRATEGY-PATTERN der Experimentier-Configs überführt (professionelle Architektur)? (B) C.1-C.3-Verdrahtung.
- (A) Strategy: jede Experiment-Phase/Config = eine Strategy. ${SUPER}/Code/02_messung_driver/v32_orchestrator.hpp (execute_messreihe Stub :81-85, execute_one_permutation :148-180, run_messreihe_for_op_type :139-144). Wie kapselt man die 3 Phasen (Stufe1/2/3) als Strategy-Familie (benanntes Strategy-Pattern, compile-time wo möglich)? Bezug zu bestehenden Command/Strategy-Nutzungen (compare_engine_command @command_pattern).
- (B) C.1 Surrogat (PrtArtHashBackend=unordered_map) → reale Stufe-1/2/3-Katalog-DLLs (AnatomyModuleLoader→dynamic_cast<IObservableTier*>, tier_observe). C.2 execute_messreihe an Experiment-XML(R2)+Registries(R1) verdrahten → Katalog-Build → 3 Mess-Modi → CompareEngineCommand/welch_t_test → MessreiheReport. C.3 messung_driver-Antrieb INERT-by-default (COMDARE_V32_DRIVER_ENABLE), Export via messreihe_report_exporter → xml→pdf-Anhang.
${CTX}
Liefere: das Strategy-Pattern-Design (Phase-Strategies) + C.1/C.2/C.3-Spec (Dateien/Zeilen, Patterns, compile-time-Grenze, INERT-Flag), TABU-Check.`,
    { label: 'R3:strategy-C1-C3', phase: 'Recherche' }),

  // R4 — TABU + Backups
  () => agent(
`ULTRACODE-Recherche, belege datei:zeile. TABU-Leitplanken + vorgeschriebene Backups.
- TABU: ist permutation_axes.xml die ce-SOTA-Registry (dann read-only, additive prt-art-Registry daneben)? golden_fullpilot_320 + CatalogAxes<4,4,5,4>=320 (#229, docs/architektur/17 B.1) — die Experiment-XML/Registry-Referenzierung darf die Achsen-Grenze NICHT über 320 treiben ohne GO. serialize_composition_path/POD-1416/kV3AxisSchema/ABI-4/GenusBindingTraits — golden-neutral halten (additiv, Default-OFF COMDARE_V32_DRIVER_ENABLE).
- LIES ${SUPER}/docs/sessions/backups/20260712-full-line-review/ + .../20260712-forgotten-todo-sweep/ — offene/vergessene Punkte zu XML-Parser/thesis_profile/v32/EE-A-EE-B/Registry/Katalog/#229/#230.
- Ledger W4 ~:961 (3 quarantänisierte ALT-Pfade) + #229/#230 — Abgrenzung bestätigen.
${CTX}
Liefere: TABU-Leitplanken je Increment (insb. permutation_axes.xml-Status) + relevante vergessene Punkte aus den 2 Backups + golden-Neutralitäts-Nachweis, datei:zeile.`,
    { label: 'R4:tabu-backups', phase: 'Recherche' }),
])

const [r1, r2, r3, r4] = research.map(r => r || '(kein Ergebnis)')

phase('Synthese')

const plan = await agent(
`Du bist der Architekt. honest-100%, Goal-V4. Fasse die 4 Berichte zu EINEM Increment-Plan für die finale Zwei-Registry+Experiment+Strategy-Architektur zusammen (zur User-Bestätigung; NEUE Architektur → Optionen+Empfehlung, kein Bau).

=== R1 Zwei Registries ===
${r1}
=== R2 Experiment-XML+Parser-Modul ===
${r2}
=== R3 Strategy+C.1-C.3 ===
${r3}
=== R4 TABU+Backups ===
${r4}

${CTX}

Liefere:
1. **DREI XML-SCHEMATA** — ce-Registry(SOTA), prt-art-Registry(gleiches Schema), Experiment-XML(3-Phasen, referenziert Registries, keine Bausteine) — konkret. + Ist permutation_axes.xml die ce-Registry (TABU-read-only)?
2. **PARSER-MODUL + STRATEGY-PATTERN** — Parser als ce-Modul; v32→Strategy-Familie der Phase-Configs (benannte Patterns).
3. **String→compile-time-Slot-Brücke** (Baustein-Name je Achse → realer Slot/Strategy), TABU-neutral.
4. **INCREMENT-PLAN** (geordnet: Registry-Schema/prt-art-Registry/Experiment-XML/Parser-Modul/Strategy zuerst, dann C.1-C.3-Verdrahtung), je Increment: Dateien/Zeilen · Mechanik/Patterns · Gate (ctest/golden-320==320/cf22/mojibake) · INERT-Flag.
5. **TABU-CHECK** + **vergessene Punkte** aus den 2 Backups.
6. **Die Rest-Entscheidungen für den User** + benannte deep-research-Bedarfe.
Konkret genug für direkte Umsetzung nach GO. Markiere unbelegte Annahmen.`,
  { label: 'synthese:final-plan', phase: 'Synthese' })

return { plan, recherche: { r1, r2, r3, r4 } }
