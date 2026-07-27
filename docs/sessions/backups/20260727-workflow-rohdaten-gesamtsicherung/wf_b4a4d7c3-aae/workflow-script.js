export const meta = {
  name: 'full-project-line-review',
  description: 'Voll-Review jede Zeile aller 4 Repos + Ist/Soll/Diff + Architektur-Synthese + Dead-Code/Artefakte',
  phases: [
    { title: 'Review', detail: 'Partition-Reviewer über alle Repos (jede Zeile) + Diff + Architektur + Dead-Code' },
    { title: 'Verify', detail: 'adversariale Verifikation je Finding' },
    { title: 'Synthese', detail: 'konsolidierter Bericht + Aufräum-Liste' },
  ],
}

const ROOT = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = ROOT + '/Code/external/comdare-cache-engine'
const PRT = ROOT + '/Code/external/comdare-prt-art'
const TH = ROOT + '/thesis/diplomarbeit'

const FINDINGS = {
  type: 'object', additionalProperties: false,
  properties: {
    coverage_note: { type: 'string', description: 'welche Dateien gelesen wurden (Anzahl + ggf. bewusst uebersprungene mit Grund)' },
    findings: { type: 'array', items: {
      type: 'object', additionalProperties: false,
      properties: {
        file: { type: 'string' }, line: { type: 'integer' },
        category: { type: 'string', description: 'correctness|architecture|dead-code|cleanup|doc-drift|test-gap' },
        severity: { type: 'string', description: 'critical|major|minor|info' },
        summary: { type: 'string' }, evidence: { type: 'string', description: 'konkreter Code-/Beleg-Auszug' },
      }, required: ['file','line','category','severity','summary','evidence'],
    } },
  }, required: ['coverage_note','findings'],
}

const COMMON = `Du bist ein zeilenweiser Code-Reviewer der TU-Dresden-Diplomarbeit cache-engine (comdare). LIES JEDE DATEI DEINER PARTITION VOLLSTAENDIG (keine Stichproben — der Auftrag ist 'jede einzelne Zeile'). Suche: (1) CORRECTNESS-Bugs (Logik, UB, Off-by-one, Races, Ressourcen-Lecks, falsche Semantik), (2) ARCHITECTURE-Verstoesse gegen die Doktrin (compile-time-Metaprogrammierung im Hot-Path — kein Runtime-Switch/vtable; CRTP+Concepts; benannte Lehrbuch-Patterns; Baseline-Layering; WAS/WIE-Trennung ce=Framework super=Definition; Anti-Phantom: kein Messwert ohne echte Quelle, honest-0/n/a statt erfundener Werte), (3) DEAD-CODE (Funktionen/Klassen/Dateien/Targets ohne Konsumenten — belege mit grep ueber das Repo!), (4) CLEANUP-Artefakte (Scratch-Reste, verwaiste Configs, stale Kommentare die falsches behaupten, doppelte Logik), (5) DOC-DRIFT (Kommentar/Doku widerspricht Code), (6) TEST-GAPS (ausgelieferte Logik ohne Test / nicht-registrierte Tests). TABU-Kontext (NICHT als Finding melden, das ist gewollt eingefroren): golden_fullpilot_320_binary_ids.txt, permutation_axes.xml, POD sizeof==1416, ABI-MAJOR==4. Melde NUR echte Findings mit datei:zeile+Evidence — kein Stil-Rauschen, keine Geschmacksfragen. Sei skeptisch: lieber 5 harte Findings als 50 weiche.`

// Partitionen: [label, wurzel, include-hint]
const PARTS = [
  ['ce-axes-1', CE, 'libs/cache_engine/axes/{alloc,cacheline,node,layout}'],
  ['ce-axes-2', CE, 'libs/cache_engine/axes/{lookup,simd,mapping,path_compression,composable}'],
  ['ce-axes-3', CE, 'libs/cache_engine/axes/{filter,filter_axis,queuing,serialization,telemetry,value_handle}'],
  ['ce-axes-4', CE, 'libs/cache_engine/axes — ALLE restlichen Unterverzeichnisse die nicht in den Partitionen ce-axes-1..3 liegen (io_dispatch, migration, index_organization, concurrency, prefetch, general_hardware, cache_traversal, …; verifiziere per ls, dass NICHTS unreviewt bleibt)'],
  ['ce-builder-1', CE, 'libs/cache_engine/builder/experiment_tree'],
  ['ce-builder-2', CE, 'libs/cache_engine/builder — alles AUSSER experiment_tree (codegen, curve_fit, anatomy_codegen_tool, permutation_codegen_tool, …)'],
  ['ce-anatomy', CE, 'libs/cache_engine/anatomy'],
  ['ce-include-1', CE, 'libs/cache_engine/include/cache_engine/{measurement,abi}'],
  ['ce-include-2', CE, 'libs/cache_engine/include — alles AUSSER measurement+abi'],
  ['ce-topics-1', CE, 'libs/cache_engine/topics/hardware'],
  ['ce-topics-2', CE, 'libs/cache_engine/topics — alles AUSSER hardware'],
  ['ce-facade-profiles', CE, 'libs/cache_engine/profile_facade + libs/cache_engine/algorithm_profiles (inkl. ALLER *.profile.xml + SCHEMA.md + sota/)'],
  ['ce-misc-libs', CE, 'libs/cache_engine/{compositions,concurrency_manager,execution_engine,reclamation,src,subsystems,virus} + libs/cache_engine/CMakeLists.txt'],
  ['ce-common', CE, 'libs/common (inkl. serialization/xml_config_parser)'],
  ['ce-apps-tools', CE, 'apps/ + tools/ (inkl. permutation_codegen: codegen.cmake NUR lesend gegen cpp-Backend-Konsistenz)'],
  ['ce-cmake', CE, 'cmake/ + CMakeLists.txt (Root) + ext/CMakeLists.txt (Vendor-Wiring; ext-Paper-Code selbst NICHT reviewen = read-only fremd)'],
  ['ce-tests-1', CE, 'tests/unit — Dateien alphabetisch a..e (inkl. CMakeLists.txt Abschnitte dazu)'],
  ['ce-tests-2', CE, 'tests/unit — Dateien f..m'],
  ['ce-tests-3', CE, 'tests/unit — Dateien n..s'],
  ['ce-tests-4', CE, 'tests/unit — Dateien t..z + thesis_tiere/ + fixtures-Struktur (nicht Fixture-INHALTE zeilenweise, aber Konsistenz)'],
  ['ce-tests-cmake', CE, 'tests/unit/CMakeLists.txt VOLLSTAENDIG (Registrierungs-Luecken! welche test_*.cpp existieren aber sind NICHT registriert — vollstaendige Liste) + tests/ Rest'],
  ['super-01-03', ROOT, 'Code/01_sample_data_generator + Code/02_messung_driver + Code/03_binary_to_csv + Code/experiment_config/*.xml + Code/test_data_xml/*.xml'],
  ['super-04-05', ROOT, 'Code/04_csv_to_latex + Code/05_diagram_generator'],
  ['super-06-09', ROOT, 'Code/06_latex_to_pdf + Code/07_tier_binary_report + Code/08_appendix_generator + Code/09_tex_formatter + Code/CMakeLists.txt + Code/cmake/'],
  ['super-ci-docs', ROOT, '.gitlab-ci.yml (jede Zeile; Job-Logik, Rules, Loop-Schutz, Token-Handling) + docs/architektur/-Dateiliste (Struktur-Artefakte, nicht jede Doku-Zeile)'],
  ['prt-art', PRT, 'ALLES (7,4k LOC: src/include/tests/CMake)'],
  ['thesis-de', TH, 'kapitel/de/*.tex + aufgabenstellung (LaTeX-Review: kaputte refs/labels, \\input auf nicht-existente Dateien, doppelte Labels innerhalb einer Sprache, Prosa-Code-Drift bei technischen Behauptungen mit Zahlen)'],
  ['thesis-en', TH, 'kapitel/en/*.tex (dito + DE/EN-Struktur-Symmetrie)'],
  ['thesis-anhang', TH, 'anhang/de + anhang/en (inkl. tabellen/*.tex Konsistenz zu den Generator-Formaten) + diplomarbeit.tex + config/ + tools/format_tex.py (Abloese-Status)'],
]

phase('Review')
const partResults = PARTS.map(([label, root, scope]) => () =>
  agent(`${COMMON}\n\nDEINE PARTITION: Repo-Wurzel ${root} — Scope: ${scope}\n\nArbeite systematisch: erst \`find\`/ls fuer die vollstaendige Dateiliste deiner Partition, dann JEDE Datei lesen. Fuer dead-code-Behauptungen: repo-weiter grep als Beleg (0 Konsumenten). coverage_note MUSS die gelesene Dateizahl nennen.`,
    { label: `review:${label}`, phase: 'Review', schema: FINDINGS }))

// Spezial-Reviewer
const specials = [
  ['diff-ist-soll', `${COMMON}\n\nSPEZIAL-AUFTRAG DIFF + IST/SOLL: Reviewe die Aenderungen der Freigaben-Session: ce-Range 270c6c8c..e5946cdb (git -C ${CE} log --oneline + git diff je Commit-Gruppe) und super-Range 47fb6dc..HEAD (git -C ${ROOT}). Pruefe je Commit: (a) tut der Diff was die Message behauptet, (b) Regressions-Risiken/Wechselwirkungen ZWISCHEN den Commits (z.B. Multi-Sweep-Fix x cap-0-Fix x fairness-Stamp x H2-Spalte — Stamp-/CSV-Header-Konsistenz ueber alle!), (c) Ist-Zustand vs. geplantes Soll (Ledger §11-I Freigaben + §12-Eintraege in ${ROOT}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md): ist alles Behauptete wirklich im Code, fehlt etwas, widerspricht etwas.`],
  ['arch-synthese', `${COMMON}\n\nSPEZIAL-AUFTRAG ARCHITEKTUR-SYNTHESE: Pruefe die dokumentierte Architektur gegen den Ist-Code auf SYNTHESE-FEHLER. Quellen: ${ROOT}/docs/architektur/ (insb. 20/21/22 + E1-E4-Konsolidierung), ce docs/ (34_KONSOLIDIERTER_MASTER falls vorhanden), Ledger §0/§10/§11. Pruefe: (a) E4->E1-Schichtung real eingehalten (messung_driver=E4-WAS, ce=WIE)? (b) 3-Ebenen-Anatomie (Gattung/Genus/AbiAdapter) konsistent? (c) System-Achsen 'Blut' vs. 19 Organ-Achsen sauber getrennt? (d) Widersprueche zwischen Doks untereinander oder Dok vs. Code (mit datei:zeile beider Seiten), (e) verwaiste/ueberholte Architektur-Dokumente die als aufzuraeumende Artefakte zu markieren sind (deprecaten, nie loeschen).`],
  ['dead-artefakte-sweep', `${COMMON}\n\nSPEZIAL-AUFTRAG DEAD-CODE/ARTEFAKTE-SWEEP (repo-weit, tool-gestuetzt): (1) ce+super: alle .cpp/.hpp ohne Include-/Link-Konsumenten (grep-belegt); CMake-Targets die nirgends gebaut/gebraucht werden; EXCLUDE_FROM_ALL-/nicht-registrierte Tests (Liste!); (2) verwaiste Dateien: *.ps1 (Abloese-Status nach C++23-Portierung — generate_*_appendix.ps1, build*.ps1), format_tex.py (abgeloest durch 09_tex_formatter), leere/Stub-Dateien, $null-Junk, Backup-/Scratch-Reste in den Repos, build-go2*/build-perms-fix-Trees (gitignored? aufraeumbar?); (3) super docs/: doppelte/uebersessene Session-Docs die konsolidiert gehoeren (nur MARKIEREN); (4) tote XML-Profile/Configs ohne Konsument; (5) prt-art + thesis: verwaiste Dateien. Jede Markierung mit grep-Beleg (0 Konsumenten) + Empfehlung (deprecaten/verschieben/loeschen-mit-User-GO).`],
]
const specialResults = specials.map(([label, prompt]) => () =>
  agent(prompt, { label: `review:${label}`, phase: 'Review', schema: FINDINGS }))

const all = await parallel([...partResults, ...specialResults])
const okResults = all.filter(Boolean)
const rawFindings = okResults.flatMap((r, i) => (r.findings || []).map(f => ({ ...f })))
const coverage = okResults.map((r, i) => r.coverage_note)
log(`Review: ${okResults.length}/${PARTS.length + 3} Reviewer fertig, ${rawFindings.length} Roh-Findings`)

// Dedup (file:line:category)
const seen = new Map()
for (const f of rawFindings) {
  const k = `${f.file}:${f.line}:${f.category}`
  if (!seen.has(k)) seen.set(k, f)
}
const deduped = [...seen.values()]
log(`Dedup: ${deduped.length} eindeutige Findings`)

phase('Verify')
const VERDICT = {
  type: 'object', additionalProperties: false,
  properties: {
    confirmed: { type: 'boolean' }, adjusted_severity: { type: 'string' },
    reasoning: { type: 'string', description: 'kurz: warum bestaetigt/widerlegt (code-belegt)' },
  }, required: ['confirmed','adjusted_severity','reasoning'],
}
const hard = deduped.filter(f => f.severity === 'critical' || f.severity === 'major')
const soft = deduped.filter(f => f.severity !== 'critical' && f.severity !== 'major')
log(`Verify: ${hard.length} hart (einzeln adversarial) + ${soft.length} weich (gebuendelt)`)

const hardVerified = await parallel(hard.map(f => () =>
  agent(`Adversariale Verifikation eines Code-Review-Findings (Diplomarbeit cache-engine). Repo-Wurzeln: super=${ROOT}, ce=${CE}, prt=${PRT}, thesis=${TH}. LIES die Datei an der Stelle + Kontext + ggf. Konsumenten und versuche das Finding zu WIDERLEGEN (Default-Skepsis: confirmed=false wenn unsicher oder wenn es TABU-gewollt/bereits-dokumentiert-gated ist).\n\nFINDING: [${f.severity}/${f.category}] ${f.file}:${f.line} — ${f.summary}\nEVIDENCE: ${f.evidence}`,
    { label: `verify:${(f.file||'').split('/').pop()}:${f.line}`, phase: 'Verify', schema: VERDICT, effort: 'high' })
    .then(v => v ? { ...f, verdict: v } : null)))

// weiche Findings gebuendelt je ~15
const chunks = []
for (let i = 0; i < soft.length; i += 15) chunks.push(soft.slice(i, i + 15))
const SOFTV = { type: 'object', additionalProperties: false, properties: {
  verdicts: { type: 'array', items: { type: 'object', additionalProperties: false, properties: {
    idx: { type: 'integer' }, confirmed: { type: 'boolean' }, note: { type: 'string' } },
    required: ['idx','confirmed','note'] } } }, required: ['verdicts'] }
const softVerified = await parallel(chunks.map((ch, ci) => () =>
  agent(`Pruefe diese ${ch.length} minor/info-Review-Findings zuegig am Code (Repo-Wurzeln: super=${ROOT}, ce=${CE}, prt=${PRT}, thesis=${TH}). Je Finding: existiert die Stelle + stimmt die Aussage im Kern? confirmed=false bei Zweifel/TABU-gewollt/schon-dokumentiert.\n\n${ch.map((f, i) => `[${i}] ${f.file}:${f.line} (${f.category}) ${f.summary} | Evidence: ${f.evidence.slice(0, 200)}`).join('\n')}`,
    { label: `verify:soft-${ci}`, phase: 'Verify', schema: SOFTV, effort: 'low' })
    .then(v => v ? ch.map((f, i) => {
      const vv = (v.verdicts || []).find(x => x.idx === i)
      return vv && vv.confirmed ? { ...f, verdict: { confirmed: true, adjusted_severity: f.severity, reasoning: vv.note } } : null
    }).filter(Boolean) : [])))

const confirmed = [...hardVerified.filter(Boolean).filter(f => f.verdict.confirmed), ...softVerified.flat()]
log(`Verify: ${confirmed.length} CONFIRMED (${hardVerified.filter(Boolean).filter(f=>f.verdict.confirmed).length} hart)`)

phase('Synthese')
const synth = await agent(
  `Schreibe den konsolidierten Voll-Review-Bericht der Diplomarbeit (4 Repos, jede Zeile reviewt, adversarial verifiziert) als Markdown-Datei nach ${ROOT}/docs/sessions/backups/20260712-full-line-review/REVIEW-BERICHT.md (Verzeichnis anlegen). Struktur: (1) Executive Summary (Zahlen: Reviewer/Findings/Confirmed je Kategorie+Schwere), (2) CRITICAL+MAJOR-Findings je Repo (datei:zeile, Summary, Evidence, empfohlener Fix), (3) Architektur-Synthese-Befund, (4) AUFRAEUM-LISTE (dead-code + Artefakte, je mit grep-Beleg + Empfehlung deprecaten/loeschen-mit-GO), (5) Ist/Soll/Diff-Befund (Freigaben-Session), (6) Coverage-Nachweis (welche Partitionen, gelesene Dateien). Kein Finding erfinden — NUR aus den Daten unten. Schreibe die Datei + gib eine Kurzfassung (Top-10-Findings + Aufraeum-Highlights) als Endnachricht zurueck.\n\nCOVERAGE:\n${JSON.stringify(coverage, null, 0).slice(0, 4000)}\n\nCONFIRMED FINDINGS (${confirmed.length}):\n${JSON.stringify(confirmed.map(f => ({ file: f.file, line: f.line, cat: f.category, sev: f.verdict.adjusted_severity || f.severity, summary: f.summary, evidence: (f.evidence||'').slice(0, 300), why: (f.verdict.reasoning||'').slice(0, 200) })), null, 0)}`,
  { label: 'synthese:bericht', phase: 'Synthese', effort: 'high' })

return { reviewers: okResults.length, raw: rawFindings.length, deduped: deduped.length, confirmed: confirmed.length, report: synth }