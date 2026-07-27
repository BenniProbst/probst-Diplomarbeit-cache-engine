export const meta = {
  name: 'plan-optg-systemachsen-neue-golden',
  description: 'Geschaerfte opt-g-Planung: System-Achsen vs Mess-Achsen im mehrstufigen Build + neue golden-Basis (Bruch-Rulings, alte golden+Messwerte geloescht)',
  phases: [
    { title: 'Scout', detail: '2 Kartierungen: 3-Schichten-Achsen-Architektur · golden-Regeneration+Loeschumfang' },
    { title: 'Plan', detail: 'praezises opt-g-Design (System-vs-Mess) + neue-golden-Prozess + Entscheidungs-Rahmen' },
  ],
}

const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'

const CTX = `
KONTEXT (2026-07-18, User-Bruch-Rulings, "so sauber wie moeglich nach Plan"):
- Die golden_fullpilot_320 (reine Organ-Komposition T0..T18) ist UEBERHOLT: die Achsenstruktur/-anzahl ist gewachsen.
  Der User hat "Bruch-Freigabe" erteilt: additiv AUFGEHOBEN, golden==320-TABU AUFGEHOBEN, alte golden + Messwerte
  werden GELOESCHT, neue golden-Version von vorn (git-Historie bewahrt Altstand). Byte-Identitaet NICHT mehr Pflicht.
- opt-g SOLL: der Experiment-PLANER permutiert opt_level (System-Achse: Unter-Achse der Compiler-Haupt-System-Achse)
  und spaeter simd_extension aus dem XML selbst, je Permutation eigene CompileFn(opt_flag) + eigenes build_version-Sidecar.
- Q2 Option C (bisher): opt/simd = System-Achsen-Provenienz -> ins build_version/Sidecar, NIE in binary_id.
- User-Praezisions-Einwand: opt-g war "nicht ganz praezise unter dem mehrstufigen System-Achsen vs Mess-Achsen build".
- Code-Andockpunkt ist bereits kartiert (Vor-Workflow): Permutations-Schleife INNERHALB run_experiment_profile
  (experiment_run_entry.hpp) unter dem CSV-Header-Write, sota_seen_bids pro opt zuruecksetzen, +opt in build_version.
  DIESER Workflow soll NICHT den Code-Loop neu kartieren, sondern die ACHSEN-SCHICHTUNG praezisieren + die neue golden
  definieren.
`

const MAP = {
  type: 'object',
  properties: {
    area: { type: 'string' },
    findings: { type: 'array', items: { type: 'object', properties: {
      point: { type: 'string' }, evidence: { type: 'string' } }, required: ['point','evidence'] } },
    recommendation: { type: 'string' },
    open_points: { type: 'array', items: { type: 'string' } },
  },
  required: ['area','findings','recommendation','open_points'],
}

const AREAS = [
  { key: 'achsen_schichtung', prompt: `Praezisiere die 3-Schichten-Achsen-Architektur und wo opt_level EXAKT sitzt. Lies im ce-Repo (${CE}): libs/cache_engine/include/cache_engine/measurement/system_axis.hpp, ceb_system_axis.hpp, compiler_system_axis.hpp, optimization_level_sub_axis.hpp, extension_hardware_system_axis.hpp; und im super-Ledger (${SUP}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md) die Abschnitte zur Achsen-Taxonomie/AxisKind (grep 'AxisKind', 'system_measurement', 'system_config', 'organ'). KERNFRAGEN: (1) Welche 3(+1) Achsen-SCHICHTEN existieren — Organ-Achsen (T0..T18, AxisKind::organ, bestimmen binary_id/WELCHE Binary), System-Achsen (AxisKind::system_config: compiler+opt_level/isa/simd/scheduling/load_framework/ceb, bestimmen WIE kompiliert/WO gelaufen), Mess-Achsen (AxisKind::system_measurement: wall_clock/observer/pmc, gemessen INNERHALB einer geladenen Binary)? Belege die Diskriminanten. (2) Ist binary_id HEUTE ausschliesslich die Organ-Komposition (System-Achsen NICHT drin)? Wo genau wird binary_id gebildet (grep serialize_composition_path / kCompositionAxisNames / sota_tier)? (3) opt_level = Unter-Achse UNTER compiler (parent_axis_label=='compiler') — bestaetige, dass es eine SYSTEM-Achsen-Dimension ist, orthogonal zu Organ (binary_id) UND zu Mess-Achsen. (4) Wo lebt heute die System-Achsen-Provenienz (build_version-Suffix +opt=, Sidecar .version)? Formuliere das 'mehrstufige Build'-Modell praezise: Stufe System-Achsen (Compile-Config) x Stufe Organ-Achsen (Komposition->binary_id) -> Tier-Binary; dann Mess-Achsen messen sie. Nenne datei:zeile.\n\n${CTX}` },
  { key: 'golden_regen_loesch', prompt: `Kartiere die golden-REGENERATION + den exakten LOESCH-Umfang fuer die neue golden-Version. Im ce-Repo (${CE}): finde+lies den golden-Generator (tools/gen_golden_fullpilot/ — grep nach gen_golden_fullpilot, wie wird golden_fullpilot_320_binary_ids.txt erzeugt?), libs/cache_engine/algorithm_profiles/permutation_axes.xml (die Achsen-Definition, aus der die Matrix entsteht — welche Achsen/Kardinalitaeten ergeben 320?), tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt (+_abi4.txt), cmake/permutations.cmake (getrackter Katalog), tests/unit/thesis_tiere/experiment_golden.xml + ${SUP}/Code/test_data_xml/experiment_golden.xml. KERNFRAGEN: (1) Wie genau wird die golden-Matrix HEUTE regeneriert (Tool-Aufruf, CMake-Target, welche Inputs)? (2) Welche Achsen mit welchen Kardinalitaeten ergeben die 320 (Produkt-Zerlegung)? (3) Wenn die System-Achse opt_level als EXPLIZITE golden-Dimension hinzukommt: waechst die golden-Matrix auf Organ(320) x |opt_levels| — bleibt binary_id=Organ-only (System-Provenienz nur im build_version/Katalog-Spalte) ODER wandert opt in binary_id? Was ist der SAUBERSTE Weg, opt als golden-Dimension zu fuehren OHNE binary_id zu verunreinigen? (4) LOESCH-UMFANG praezise: welche GETRACKTEN Dateien sind die alte golden + Messwerte (golden_fullpilot_320_binary_ids.txt/_abi4.txt, permutation_axes.xml?, experiment_golden.xml?, cmake/permutations.cmake?, tests/unit/thesis_tiere/*_measurements.csv, super measurement/) — und welche davon werden REGENERIERT (nicht von Hand geloescht) vs. wirklich rm? (5) Welche Tests haengen an der 320 (grep golden_fullpilot, 320) und muessen auf die neue golden-Version umgestellt werden? Nenne datei:zeile.\n\n${CTX}` },
]

phase('Scout')
const maps = (await parallel(AREAS.map(a => () =>
  agent(a.prompt, { label: `scout:${a.key}`, phase: 'Scout', schema: { ...MAP }, effort: 'high' })
    .then(r => r ? { ...r, area: r.area || a.key } : null)))).filter(Boolean)

phase('Plan')
const SYN = {
  type: 'object',
  properties: {
    achsen_modell: { type: 'string', description: 'das praezise 3-Schichten-System-vs-Mess-vs-Organ-Modell + wo opt_level sitzt' },
    optg_design: { type: 'string', description: 'opt-g praezise unter der Achsen-Schichtung: permutierte System-Achse, binary_id=Organ, Provenienz Sidecar' },
    neue_golden_prozess: { type: 'string', description: 'Loeschen + Regenerieren: exakte Datei-Liste rm vs regen, neue Matrix-Definition, Test-Umstellung' },
    entscheidungen: { type: 'array', items: { type: 'object', properties: {
      id: { type: 'string' }, frage: { type: 'string' }, empfehlung: { type: 'string' }, destruktiv: { type: 'boolean' } },
      required: ['id','frage','empfehlung','destruktiv'] } },
  },
  required: ['achsen_modell','optg_design','neue_golden_prozess','entscheidungen'],
}
const synInput = maps.map(m => `## ${m.area}\nfindings: ${JSON.stringify(m.findings)}\nrec: ${m.recommendation}\nopen: ${JSON.stringify(m.open_points)}`).join('\n\n')
const synth = await agent(
  `Synthetisiere den praezisen opt-g-Design-Plan unter der System-Achsen-vs-Mess-Achsen-Schichtung + den neue-golden-Prozess. Adressiere EXPLIZIT den User-Einwand 'nicht ganz praezise unter dem mehrstufigen System-Achsen vs Mess-Achsen build': mache klar, dass opt_level eine SYSTEM-Achsen-Dimension (Compile-Config-Stufe) ist, orthogonal zu Organ (binary_id) und zu Mess-Achsen, und wie die neue golden-Matrix = Organ x System-Achsen(opt) mit binary_id=Organ-only und System-Provenienz im Sidecar/build_version aussieht. neue_golden_prozess: exakte getrackte Datei-Liste (was rm, was wird regeneriert), neue Matrix-Definition, welche opt-Stufen in die golden gehoeren, Test-Umstellung. entscheidungen: die offenen Weichen als nummerierte Liste (id/frage/empfehlung/destruktiv) — insbesondere: neue-golden-Matrix-Form + welche opt-Stufen; Loesch-Umfang (destruktiv); opt-in-golden-Katalog vs rein-runtime; simd jetzt-oder-Folge; A2-Neben Namespace sauber-umbenennen-jetzt-da-Byte-Identitaet-aufgehoben. Loese Grundsatz-Weichen NICHT eigenmaechtig.\n\nSCOUTS:\n${synInput}\n\n${CTX}`,
  { label: 'synth:plan', phase: 'Plan', schema: SYN, effort: 'high' })
return { maps, synth }