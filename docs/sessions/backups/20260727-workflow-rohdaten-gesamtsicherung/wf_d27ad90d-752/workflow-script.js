export const meta = {
  name: 'review-optg-achsen-konformitaet',
  description: 'ultracode Code-Review: opt-f/opt-g-Ist-Impl gegen den führenden Achsen-Taxonomie-Plan (Haupt/Unter-Achse/Optionen); Design-Diff',
  phases: [
    { title: 'Scout', detail: 'Plan-Tabelle (Haupt/Unter/Option) extrahieren · Ist-Impl kartieren' },
    { title: 'Diff', detail: 'Konformitäts-Diff + konkrete Korrektur-Struktur' },
  ],
}

const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUP + '/Code/external/comdare-cache-engine'

const CTX = `
KONTEXT: User-Konformitäts-Einwand (2026-07-18): "Du vertauscht schon wieder Haupt und Unterachsen, dazu gibt es
eine workflow-belegte Tabelle. Formal sind die Mess-Achsen auch System-Achsen, werden aber getrennt gehandelt.
Du hast gerade alle Opt-Typen als Unterachse deklariert, aber sie sind Optionen der Optimierungs-Unter-Achse."
KORREKTE HIERARCHIE (zu verifizieren gegen die Tabelle): Haupt-(System-)Achse 'compiler' → Unter-Achse 'opt_level'
→ OPTIONEN/Ausprägungen {O0,O1,O2,O3,Ofast}. Analog: Haupt-Achse 'extension_hardware' → (Unter-Achse?) simd →
Optionen {no_extension,avx2,avx512}. Mess-Achsen (system_measurement) sind FORMAL System-Achsen, getrennt gehandelt.
Die frisch gebaute opt-f/opt-g-Impl (Ist) muss dagegen geprüft werden.
`

const SCH = {
  type: 'object',
  properties: {
    area: { type: 'string' },
    findings: { type: 'array', items: { type: 'object', properties: {
      point: { type: 'string' }, evidence: { type: 'string' } }, required: ['point','evidence'] } },
    summary: { type: 'string' },
  },
  required: ['area','findings','summary'],
}

phase('Scout')
const [plan, ist] = await parallel([
  () => agent(`PLAN-TABELLE extrahieren: Lies den führenden Optimierungs-Achsen-Plan + die Achsen-Taxonomie.
Primär: ${SUP}/docs/sessions/backups/20260717-inc2copt-planung/BAUPLAN-INC2C-OPT-OPTIMIERUNGSSTUFE.md und
BAUPLAN-INC2C-OPT-C-UEBERSETZER.md. Ergänzend: ${SUP}/docs/sessions/20260522-5300-V35-sprint-pipeline-restructure-compiler-axis.md,
${SUP}/docs/sessions/20260709-BACKUP-impl-sessions-rohdaten-memories/memory-vollexport/project_compiler_axis_v35.md,
${SUP}/docs/sessions/20260709-BACKUP-impl-sessions-rohdaten-memories/memory-vollexport/reference_n_phase_achsen_erweiterung.md.
Und die Code-Wahrheit der Struktur: ${CE}/libs/cache_engine/include/cache_engine/topics/axis.hpp (AxisKind),
ceb_system_axis.hpp, compiler_system_axis.hpp, optimization_level_sub_axis.hpp, extension_hardware_system_axis.hpp.
KERNFRAGEN: (1) Wie lautet die AUTORITATIVE Tabelle Haupt-(System-)Achse → Unter-Achse → Optionen/Ausprägungen?
Für 'compiler': ist opt_level eine Unter-Achse und O0..Ofast ihre OPTIONEN? Ist 'compiler' selbst die Haupt-Achse
mit eigenen Optionen (gcc/clang)? (2) Ist 'extension_hardware' eine Haupt-Achse und simd (no_extension/avx2/avx512)
ihre Optionen ODER ist simd eine Unter-Achse? (3) Wie sind Mess-Achsen (system_measurement) formal als System-Achsen
eingeordnet, getrennt gehandelt? (4) Wie SOLL die XML/Konfig die Ebenen abbilden — Achse als Container/Ordner, nur
Optionen als permutierte Werte (vgl. MEMORY feedback_serialization_flat_systemaxis_folders...: statische Achsen in
Ordner/Beschriftung, nur dynamische Unter-Achsen als Spalten)? Nenne die Tabelle wörtlich (datei:zeile).\n\n${CTX}`,
    { label: 'scout:plan', phase: 'Scout', schema: { ...SCH }, effort: 'high' }),
  () => agent(`IST-ZUSTAND kartieren: die frisch gebaute opt-f/opt-g-Impl. Lies:
(a) XSD ${SUP}/Code/test_data_xml/experiment_schema.xsd — der SystemAxesType-Block (compiler/opt_level/extension_hardware/simd).
(b) ${CE}/libs/common/serialization/xml_config_parser/xml_config_parser.hpp (ExperimentProfile-Felder opt_levels/simd_extensions)
    + xml_config_parser.cpp (der <system_axes>-Parse-Block).
(c) ${CE}/tests/unit/thesis_tiere/experiment_golden.xml — die <system_axes>-Instanz.
(d) ${CE}/libs/cache_engine/profile_facade/experiment_run_entry.hpp — die opt-g-Helfer (experiment_opt_flag_of/
    experiment_march_of/experiment_host_supports_simd) + die Permutations-Schleife (opt_perms × simd_perms).
(e) ${CE}/libs/cache_engine/profile_facade/profile_run_facade.cpp — die compile_for_perm-Fabrik.
KERNFRAGEN: (1) Wie repräsentiert die Ist-Impl compiler/opt_level/simd — als Achse, Unter-Achse oder Option? Konkret:
das XSD hat '<compiler><opt_level value="O2"/><opt_level value="O3"/>' — behandelt das O2/O3 als OPTIONEN einer
opt_level-Unter-Achse oder als flache Liste von 'opt_level'-Einträgen (Option maskiert als Unter-Achse)? (2) Trägt die
Impl die Haupt-Achse 'compiler' als Container und opt_level als Unter-Achse, oder ist die Ebene compiler übersprungen?
(3) simd unter extension_hardware — Haupt-Achse + Optionen oder flach? (4) Fehlt die formale Einordnung Mess=System?
Beschreibe die Ist-Struktur PRÄZISE mit datei:zeile.\n\n${CTX}`,
    { label: 'scout:ist', phase: 'Scout', schema: { ...SCH }, effort: 'high' }),
])

phase('Diff')
const DIFF = {
  type: 'object',
  properties: {
    plan_tabelle: { type: 'string', description: 'die autoritative Haupt/Unter/Option-Tabelle wörtlich' },
    diffs: { type: 'array', items: { type: 'object', properties: {
      ebene: { type: 'string' }, soll: { type: 'string' }, ist: { type: 'string' }, verstoss: { type: 'boolean' },
      fix: { type: 'string' } }, required: ['ebene','soll','ist','verstoss','fix'] } },
    korrektur_struktur: { type: 'string', description: 'die konkrete konforme XSD/Parser/Loop-Struktur (compiler→opt_level→Optionen)' },
    verdikt: { type: 'string' },
  },
  required: ['plan_tabelle','diffs','korrektur_struktur','verdikt'],
}
const diff = await agent(
  `Ermittle das DESIGN-DIFF: Ist-opt-f/opt-g-Impl vs. führender Achsen-Taxonomie-Plan. Fokus auf den User-Einwand:
(1) O0..Ofast sind OPTIONEN der opt_level-UNTER-Achse (nicht selbst Unter-Achsen); compiler = Haupt-System-Achse.
(2) Mess-Achsen sind formal System-Achsen, getrennt gehandelt. (3) simd = Optionen der extension_hardware-Achse.
Liste je Ebene (Haupt-Achse/Unter-Achse/Option/Mess-vs-System) soll vs ist + verstoss + konkreter fix. Gib die
konforme Ziel-Struktur (XSD compiler→opt_level→Optionen; Parser-Felder; Perm-Loop) an, so dass die Ebenen NICHT
mehr vertauscht sind. Nenne, was byte-genau geändert werden muss.\n\nPLAN:\n${JSON.stringify(plan)}\n\nIST:\n${JSON.stringify(ist)}\n\n${CTX}`,
  { label: 'diff:synth', phase: 'Diff', schema: DIFF, effort: 'high' })
return { plan, ist, diff }