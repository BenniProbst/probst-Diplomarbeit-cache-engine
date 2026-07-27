export const meta = {
  name: 'konformitaets-sweep-3-tage-kette',
  description: 'Je Thema der Abarbeitungskette (16.-18.07.) EIN eigener Design-Konformitäts-Review: Plan-SOLL vs Ist-Impl, adversariales Diff',
  phases: [
    { title: 'Map', detail: 'je Thema: Plan-SOLL lesen + Ist-Impl kartieren (8 parallel)' },
    { title: 'Diff', detail: 'je Thema: adversariales Konformitäts-Diff (Verstöße + Fix)' },
    { title: 'Synth', detail: 'Quer-Synthese: kritische Non-Konformitäten ranken' },
  ],
}

const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUP + '/Code/external/comdare-cache-engine'
const BK = SUP + '/docs/sessions/backups'
const NACHSCHLAG = BK + '/20260717-achsen-nachschlagewerk/ACHSEN-NACHSCHLAGEWERK.md'

const CHECKLIST = `
KONFORMITÄTS-CHECKLISTE (aus dem opt-g-Beinahe-Fehltritt gelernt — jede Dimension prüfen):
1. ACHSEN-EBENEN: Haupt-(System-)Achse → Unter-Achse → Option/Ausprägung strikt getrennt? Werden Optionen
   fälschlich als Unter-Achsen geführt (Namensfalle/XML-Flachheit)? Autoritative Tabelle: ${NACHSCHLAG} +
   V35 §2.1 (docs/sessions/20260522-...-compiler-axis.md).
2. BLUT-DIREKTIVE: Organ- vs System-Achsen NIE gemischt? Mess-Achsen (system_measurement) vs Config-Achsen
   (system_config) über GETRENNTE Wurzeln, aber formal beide System unter EINEM Dach topics::Axis?
3. binary_id-NEUTRALITÄT: system_config-Achsen (opt/simd/compiler/telemetry) stehen NIE in kCompositionAxisNames
   → golden==320 unberührt? Provenienz nur in build_version/Sidecar?
4. COMPILE-TIME-ONLY Hot-Path: CRTP+Concept, empty base, KEINE vtable, kein Runtime-Switch? Nur benannte Patterns?
5. WAS/WIE-Layering: ce=Framework, super=Definition? Keine Aufwärts-Greifer/Zyklen (measurement↛builder)?
6. ABI: kV3AxisSchema/POD/GenusBindingTraits unberührt (bzw. bewusst im GO-Fenster)? Wire-Naht #156 byte-verbatim?
7. NAMEN: spiegeln die Bezeichner die Ebene (Achse vs Option) korrekt wider, ohne Fehl-Lesart zu triggern?
Verdikt je Thema: KONFORM / ABWEICHUNG (mit datei:zeile + konkretem Fix). Adversarial: DEFAULT = "finde den Verstoß".
`

const TOPICS = [
  { key: 'INC-0 DLL-Load Option B',
    plan: `${BK}/20260717-inc0-bauplan/BAUPLAN-INC0-DLL-LOAD-B.md`,
    ist: `${CE}/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp (make_gpp_compile_fn link_libs-Param + RSP-Emit), ${CE}/libs/cache_engine/profile_facade/profile_run_facade.cpp (perm_link_libs/baked_perm_link_libs/baked_perm_extra_cflags), ${CE}/libs/cache_engine/profile_facade/CMakeLists.txt (COMDARE_FACADE_PERM_LINK_LIBS/EXTRA_CFLAGS)` },
  { key: 'INC-1 CEB-System-Achsen-Schichtung (Q1 Dach / Q2 Vorlage / Q3 Compiler)',
    plan: `${BK}/20260717-inc1-bauplan/BAUPLAN-INC1-CEB-SYSTEMACHSEN-SCHICHTUNG.md + ${BK}/20260717-inc1-bauplan/ADDENDUM-Q1-DACH-Q2-VORLAGE-Q3-COMPILER.md + ${NACHSCHLAG}`,
    ist: `${CE}/libs/cache_engine/include/cache_engine/topics/axis.hpp + measurement/{system_axis,ceb_system_axis,scheduling_system_axis,extension_hardware_system_axis,hardware_isa_system_axis,load_framework_system_axis,compiler_system_axis}.hpp + ${CE}/tests/unit/test_striktheit_axis_dach_guard.cpp` },
  { key: 'INC-2c Telemetrie 19→18 / ABI-5 (POD 1344, 5 Gattungen)',
    plan: `${BK}/20260717-konstruktionslogik-durchdringung/F12III-DESIGN-VORLAGE.md + ${BK}/20260717-inc2c-konformitaet-audit/VERDIKT.md`,
    ist: `${CE}/libs/cache_engine/builder/experiment_tree/axis_path_serialization.hpp (kCompositionAxisNames = 18, telemetry raus) + der Tier-Observer-POD/kV3AxisSchema + die 5 Gattungs-AbiAdapter (grep telemetry/1344/ABI)` },
  { key: 'Fehlerklassen-Framework (INC-29, D1/D2)',
    plan: `${BK}/20260717-fehlerklassen-framework/DESIGN-FEHLERKLASSEN-FRAMEWORK.md`,
    ist: `${CE}/libs/cache_engine/include/cache_engine/measurement/axis_error.hpp (CompilerCompilerErrorClass/SampleStatus + Labels) + build_orchestrator.hpp (BuildResult.outcome=std::expected) + cache_engine_builder_iterator.hpp (D1-Log) + builder/experiment_tree/perm_runner.hpp (D2 catch/failed-Zelle)` },
  { key: 'opt-arc (opt-b CompileFn-Naht / opt-c O3-Default / opt-d fno-gnu-unique / d1 Fehlerklasse-Carrier)',
    plan: `${BK}/20260717-inc2copt-planung/BAUPLAN-INC2C-OPT-B-COMPILEFN-NAHT.md + OPT-C-UEBERSETZER.md + OPT-OPTIMIERUNGSSTUFE.md + OPT-KORRIGIERT-COMPILER-UNTERACHSEN.md (im selben Ordner)`,
    ist: `${CE}/libs/cache_engine/include/cache_engine/measurement/optimization_level_sub_axis.hpp (DefaultOptLevelSubAxis=OptO3SubAxis) + profile_run_facade.cpp (perm_opt_level_cflags/facade_supports_fno_gnu_unique/system_axes_version_suffix) + build_orchestrator.hpp (opt_flag-Param, emit_fno_gnu_unique-Gate, BuildResult.outcome)` },
  { key: 'opt-f (XML <system_axes>-Schema + Parser)',
    plan: `${BK}/20260717-inc2copt-planung/BAUPLAN-INC2C-OPT-F-XML-SCHEMA.md + ${NACHSCHLAG}`,
    ist: `${SUP}/Code/test_data_xml/experiment_schema.xsd (SystemAxesType compiler/opt_level/option + extension_hardware/option) + ${CE}/libs/common/serialization/xml_config_parser/xml_config_parser.hpp (CompilerAxisSel/ExtensionHardwareAxisSel) + .cpp (Parse) + libs/cache_engine/profile_facade/validate_profile.hpp + tests/unit/thesis_tiere/experiment_golden.xml` },
  { key: 'opt-g (Planer permutiert opt×simd — POST-Konformitäts-Korrektur nachprüfen)',
    plan: `${BK}/20260718-optg-systemachsen-neue-golden/DESIGN-optg-a2neben-neue-golden.md + ${NACHSCHLAG}`,
    ist: `${CE}/libs/cache_engine/profile_facade/experiment_run_entry.hpp (Perm-Schleife opt_perms×simd_perms + experiment_opt_flag_of/march_of/host_supports_simd + ep.compiler.opt_levels/ep.extension_hardware.options) + profile_run_facade.cpp (compile_for_perm-Fabrik)` },
  { key: 'A2-Neben (builder↔measurement-Zyklus-Bruch — PRE-Build Plan-Konformität)',
    plan: `${BK}/20260718-optg-systemachsen-neue-golden/DESIGN-optg-a2neben-neue-golden.md (§3) + ${BK}/20260718-a1a2-arch-klaerung/`,
    ist: `${CE}/libs/cache_engine/builder/pmc_source.hpp (PmcCounters/IPmcSource, namespace) + include/cache_engine/measurement/system_axis.hpp:10 + i_measurement_source.hpp:13 (Aufwärts-Includes) + builder/experiment_tree/perm_runner.hpp + die Includer (grep pmc_source.hpp/perm_runner.hpp)` },
]

const MAP = { type: 'object', properties: {
  topic: { type: 'string' }, soll: { type: 'string', description: 'Plan-SOLL (Design-Absicht) mit datei:zeile' },
  ist: { type: 'string', description: 'Ist-Impl mit datei:zeile' },
  belege: { type: 'array', items: { type: 'string' } } }, required: ['topic','soll','ist','belege'] }

const DIFF = { type: 'object', properties: {
  topic: { type: 'string' }, verdikt: { type: 'string', enum: ['KONFORM','ABWEICHUNG'] },
  verstoesse: { type: 'array', items: { type: 'object', properties: {
    dimension: { type: 'string' }, soll: { type: 'string' }, ist: { type: 'string' }, fix: { type: 'string' },
    schwere: { type: 'string', enum: ['kritisch','mittel','gering'] } }, required: ['dimension','soll','ist','fix','schwere'] } },
  zusammenfassung: { type: 'string' } }, required: ['topic','verdikt','verstoesse','zusammenfassung'] }

phase('Map')
const results = await pipeline(TOPICS,
  (t) => agent(`KONFORMITÄTS-MAP für das Thema "${t.key}". Lies den führenden PLAN: ${t.plan}. Lies die IST-Impl: ${t.ist}.
Extrahiere (a) soll = die Design-Absicht/Ebenen-Struktur/Verträge aus dem Plan (datei:zeile), (b) ist = wie der Code
es real umsetzt (datei:zeile). Fokus auf die Achsen-Ebenen (Haupt/Unter/Option), Layering, compile-time-only, ABI,
binary_id-Neutralität. Sei präzise, keine Bewertung hier — nur SOLL + IST kartieren.\n\n${CHECKLIST}`,
    { label: `map:${t.key.slice(0,22)}`, phase: 'Map', schema: { ...MAP }, effort: 'high' }).then(r => r ? { ...r, _t: t } : null),
  (m) => m ? agent(`ADVERSARIALES KONFORMITÄTS-DIFF für "${m._t.key}". Gegeben SOLL + IST (unten). DEFAULT-Haltung:
"finde den Verstoß" (wie beim opt-g-Fehltritt: Optionen als Unter-Achsen, XML-Flachheit, Namensfalle). Prüfe JEDE
Checklisten-Dimension. Liste verstoesse (dimension/soll/ist/fix/schwere) + verdikt (KONFORM nur wenn KEIN Verstoß).
Nenne datei:zeile + byte-genauen Fix.\n\nSOLL:\n${m.soll}\n\nIST:\n${m.ist}\n\nBELEGE:\n${JSON.stringify(m.belege)}\n\n${CHECKLIST}`,
    { label: `diff:${m._t.key.slice(0,22)}`, phase: 'Diff', schema: { ...DIFF }, effort: 'high' }) : null)

phase('Synth')
const valid = results.filter(Boolean)
const SYN = { type: 'object', properties: {
  kritische_nonkonform: { type: 'array', items: { type: 'object', properties: {
    topic: { type: 'string' }, verstoss: { type: 'string' }, fix: { type: 'string' } }, required: ['topic','verstoss','fix'] } },
  konforme_themen: { type: 'array', items: { type: 'string' } },
  gesamt_verdikt: { type: 'string' }, empfohlene_reihenfolge: { type: 'array', items: { type: 'string' } } },
  required: ['kritische_nonkonform','konforme_themen','gesamt_verdikt','empfohlene_reihenfolge'] }
const synth = await agent(
  `Quer-Synthese des Konformitäts-Sweeps über alle ${valid.length} Themen der Abarbeitungskette. Ranke die KRITISCHEN
Non-Konformitäten (topic/verstoss/fix), liste die KONFORMEN Themen, gib ein gesamt_verdikt + eine empfohlene
Korrektur-Reihenfolge (kritisch zuerst; near-TABU-Library-Änderungen nur mit explizitem GO markieren).\n\n${valid.map(r => `## ${r.topic}\nverdikt: ${r.verdikt}\nverstoesse: ${JSON.stringify(r.verstoesse)}\nzus: ${r.zusammenfassung}`).join('\n\n')}`,
  { label: 'synth:quer', phase: 'Synth', schema: SYN, effort: 'high' })
return { perTopic: valid, synth }