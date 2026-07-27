export const meta = {
  name: 'verify-opt-b-plan',
  description: 'Adversariale Konformitäts-Verifikation des 2c.opt-b-Bauplans gegen Code + Ledger + Plandocs',
  phases: [
    { title: 'Verify', detail: '4 Dimensionen parallel gegen echten Code + Doku' },
    { title: 'Judge', detail: 'adversarialer Konformitäts-Richter + Synthese' },
  ],
}

const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const LEDGER = `${SUP}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`
const MASTER = `${SUP}/docs/sessions/backups/20260717-inc2copt-planung/BAUPLAN-INC2C-OPT-KORRIGIERT-COMPILER-UNTERACHSEN.md`
const DOSSIER = `${SUP}/docs/sessions/backups/20260717-inc2copt-planung/BAUPLAN-INC2C-OPT-B-COMPILEFN-NAHT.md`

const PLAN = `
2c.opt-b SOLL (zu verifizieren):
1. make_gpp_compile_fn (${CE}/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp:466-468):
   5. Param 'std::string opt_flag = "-O2"' HINTER link_libs anhängen + in Lambda-Capture (:469-470) aufnehmen.
2. Emit ersetzen (:476): 'rf << "-O2\\n";' -> 'rf << opt_flag << "\\n";'
3. Beide Aufrufer profile_run_facade.cpp:226 und :402 UNVERÄNDERT (Default -O2 -> Byte-Identität).
4. Gate: Default-.so/.rsp byte-identisch. ABI-neutral, opt_flag NIE in binary_id. Verdrahtung an opt_level-Unter-Achse erst opt-c.
`

const VSCHEMA = {
  type: 'object',
  properties: {
    dimension: { type: 'string' },
    conforms: { type: 'boolean' },
    findings: { type: 'array', items: { type: 'object', properties: {
      severity: { type: 'string', enum: ['blocker','major','minor','nit'] },
      issue: { type: 'string' }, evidence: { type: 'string' } },
      required: ['severity','issue','evidence'] } },
    refinements: { type: 'array', items: { type: 'string' } },
  },
  required: ['dimension','conforms','findings','refinements'],
}

const DIMS = [
  { key: 'naht', prompt: `Verifiziere die NAHT-Korrektheit des opt-b-Plans. Lies ${CE}/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp (Zeilen 460-495) UND ${CE}/libs/cache_engine/profile_facade/profile_run_facade.cpp um Zeile 226 und 402. Prüfe: (a) sitzt der -O2-Emit exakt bei :476 zwischen -std=c++23 und -fPIC? (b) übergeben BEIDE Aufrufer wirklich nur 4 positionale Args (dann greift der Default)? (c) GIBT ES WEITERE hartkodierte -O-Flags oder andere CompileFn-Emit-Stellen (grep '\\-O[0-3s]' und 'rf <<' im build_orchestrator + make_system_compile_fn MSVC-Zweig), die opt-b übersehen würde? (d) bricht das Anhängen als 5. Param (nach link_libs) irgendeinen bestehenden Aufruf? Nenne konkrete datei:zeile-Belege.` },
  { key: 'conformance', prompt: `Verifiziere die KONFORMITÄT des opt-b-Plans gegen die Architektur-Rulings. Lies im Ledger ${LEDGER} die 2c.opt-Abschnitte (grep '2c.opt', 'OF-1','OF-2','OF-3','opt_level') und ${MASTER}. Prüfe: (a) ist opt_flag als VOLLER Flag-String ("-O2"/"-O3") konsistent zur opt_level-Unter-Achse aus opt-a (OptO*SubAxis::gcc_opt_flag, siehe ${CE}/tests/unit/test_striktheit_axis_dach_guard.cpp Block J)? (b) respektiert opt-b die Trennung opt-b(Kanal öffnen)/opt-c(Verdrahtung an XML-Achse)? (c) verletzt der Plan OF-2 (Default-Politik: CEB-Default Ofast vs. Mess-Default -O2 für Byte-Identität — ist der -O2-Default hier korrekt oder ein Widerspruch zu OF-2)? Das ist der heikelste Punkt: kläre, ob -O2-Default in opt-b mit "CEB-Default Ofast" vereinbar ist. Nenne datei:zeile-Belege.` },
  { key: 'tabu', prompt: `Verifiziere die TABU-/Regressions-Sicherheit des opt-b-Plans. Prüfe gegen den harten TABU-Katalog (permutation_axes.xml, golden_fullpilot_320, CatalogAxes<4,4,5,4>=320, POD sizeof==1416, kV3AxisSchema, GenusBindingTraits): berührt der opt-b-Diff (nur build_orchestrator.hpp Signatur+Emit) IRGENDEINE dieser Größen? Grep im ${CE} ob make_gpp_compile_fn/opt_flag irgendwo mit binary_id/profile_to_tree/kCompositionAxisNames/golden verbunden ist. Prüfe auch: wird make_system_compile_fn (MSVC, build_orchestrator.hpp:450-461) durch opt-b still inkonsistent (hat es einen eigenen -O/O2-Emit, der abweicht)? Nenne datei:zeile.` },
  { key: 'byte_identity', prompt: `Verifiziere den BYTE-IDENTITÄTS-Beweis von opt-b. Lies build_orchestrator.hpp:471-490 (die .rsp-Emit-Sequenz). Prüfe: (a) reproduziert 'rf << opt_flag << "\\n"' mit opt_flag=="-O2" die aktuelle Ausgabe 'rf << "-O2\\n"' BYTE-genau (gleicher String, gleiche Position)? (b) welcher konkrete Test-/Verifikationsschritt beweist Byte-Identität am belastbarsten — .rsp-diff, sha256 der .so, oder ein bestehender Test? Gibt es einen bestehenden ce-Test, der eine Default-Perm-.so baut und den man dafür nutzen kann (grep tests/ nach buildvariant_dll/perm .so)? (c) Fallstricke: könnte std::move(opt_flag) + Default-Argument in irgendeiner Übersetzungseinheit anders binden? Nenne datei:zeile.` },
]

phase('Verify')
const verifs = await parallel(DIMS.map(d => () =>
  agent(`${d.prompt}\n\nKONTEXT-PLAN:\n${PLAN}\n\nGib ein striktes Urteil zurück: conforms=true nur wenn die Dimension vollständig sauber ist.`,
    { label: `verify:${d.key}`, phase: 'Verify', schema: { ...VSCHEMA }, effort: 'high' })
    .then(r => r ? { ...r, dimension: r.dimension || d.key } : null)))

const clean = verifs.filter(Boolean)

phase('Judge')
const JSCHEMA = {
  type: 'object',
  properties: {
    verdict: { type: 'string', enum: ['PLAN_SOUND','PLAN_NEEDS_REVISION'] },
    refutation_attempts: { type: 'array', items: { type: 'string' } },
    surviving_concerns: { type: 'array', items: { type: 'object', properties: {
      severity: { type: 'string', enum: ['blocker','major','minor','nit'] }, issue: { type: 'string' } },
      required: ['severity','issue'] } },
    of2_default_ruling: { type: 'string' },
    go_recommendation: { type: 'string' },
  },
  required: ['verdict','refutation_attempts','surviving_concerns','of2_default_ruling','go_recommendation'],
}

const judgeInput = clean.map(v => `## ${v.dimension} (conforms=${v.conforms})\nfindings: ${JSON.stringify(v.findings)}\nrefinements: ${JSON.stringify(v.refinements)}`).join('\n\n')

const judge = await agent(
  `Du bist der adversariale Konformitäts-Richter für den 2c.opt-b-Bauplan. Versuche AKTIV, den Plan zu WIDERLEGEN — finde jeden Weg, wie opt-b wie spezifiziert (a) etwas Bestehendes bricht, (b) die Byte-Identität verletzt, (c) gegen die Doktrin/Architektur-Rulings verstößt. Der HEIKELSTE Punkt, den du entscheiden musst: opt-b setzt den CompileFn-Default auf "-O2" (für Byte-Identität mit den persistierten Messreihen), aber OF-2 sagt "CEB-Default = Ofast". Ist das ein Widerspruch oder korrekt getrennt (Signatur-Default vs. Planer-Auswahl)? Gib ein klares of2_default_ruling.\n\nVERIFIKATIONS-BEFUNDE:\n${judgeInput}\n\nKONTEXT-PLAN:\n${PLAN}\n\nSetze verdict=PLAN_NEEDS_REVISION wenn ein blocker/major überlebt; sonst PLAN_SOUND. surviving_concerns = nur was deine Widerlegungsversuche NICHT ausräumen konnten.`,
  { label: 'judge:conformance', phase: 'Judge', schema: JSCHEMA, effort: 'high' })

return { verifs: clean, judge }