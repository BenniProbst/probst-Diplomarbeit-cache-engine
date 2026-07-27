export const meta = {
  name: 'cpp23-replacement-audit',
  description: 'Kette-weiter Audit: welche Nicht-C++-Stellen (Python/.ps1/shell/awk) sollten durch performante C++23-Apps ersetzt werden',
  phases: [
    { title: 'Discover', detail: 'parallele Sweeps je Repo/Dimension nach Nicht-C++-Stellen + Perf-Hotspots auf gigantischen Tabellen' },
    { title: 'Assess', detail: 'adversariale Prüfung je Kandidat: echt C++23-ersetzbar oder legitim non-C++?' },
    { title: 'Synthesize', detail: 'priorisierte TODO-Liste' },
  ],
}

const ROOT = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'

const CAND_SCHEMA = {
  type: 'object', additionalProperties: false,
  properties: {
    candidates: { type: 'array', items: {
      type: 'object', additionalProperties: false,
      properties: {
        file: { type: 'string', description: 'repo-relativer Pfad' },
        language: { type: 'string', description: 'python|powershell|shell|awk|sed|batch|other' },
        role: { type: 'string', description: 'was es in der Mess->CSV->Auswerte->PDF->persist-Kette tut' },
        why_replace: { type: 'string', description: 'behelfsweg | perf-hot-path-big-tables | python-in-buildchain | fragile-shell | anderes' },
        perf_on_big_tables: { type: 'boolean', description: 'verarbeitet es (potenziell) gigantische Messwerttabellen?' },
        evidence: { type: 'string', description: 'datei:zeile Beleg' },
      },
      required: ['file', 'language', 'role', 'why_replace', 'perf_on_big_tables', 'evidence'],
    } },
  },
  required: ['candidates'],
}

const VERDICT_SCHEMA = {
  type: 'object', additionalProperties: false,
  properties: {
    file: { type: 'string' },
    is_real_candidate: { type: 'boolean', description: 'sollte GENUINE durch eine C++23-App ersetzt werden (nicht legitim non-C++ wie CI-YAML, Einmal-Dev-Helper, .tex)' },
    reason: { type: 'string' },
    severity: { type: 'string', description: 'high|medium|low' },
    perf_impact: { type: 'string', description: 'konkreter Perf-/Skalierungs-Effekt auf gigantische Tabellen' },
    cpp23_replacement: { type: 'string', description: 'was die C++23-App konkret waere (Ein-/Ausgang, wo in CMake/CI)' },
    effort: { type: 'string', description: 'S|M|L' },
  },
  required: ['file', 'is_real_candidate', 'reason', 'severity', 'cpp23_replacement', 'effort'],
}

const DIMS = [
  { key: 'super-code-ci', prompt: `Repo-Wurzel ${ROOT} (super). Durchsuche NUR: Code/ (alle Unterordner ausser build*/), tools/, .gitlab-ci.yml, *.ps1/*.sh/*.py im Wurzel + Code/. Finde JEDE Nicht-C++-Stelle in der Mess->CSV->Auswerte->PDF->persist-Kette: Python-Skripte, PowerShell (.ps1), fragile shell/awk/sed-Datenverarbeitung, insb. alles das CSV/Messwerte PARST/AGGREGIERT/TRANSFORMIERT. Ignoriere: CMakeLists.txt, echte C++-Quellen, Fixtures, generierte build/-Artefakte. Fuer jeden Fund datei:zeile.` },
  { key: 'thesis', prompt: `Repo-Wurzel ${ROOT}. Durchsuche NUR thesis/diplomarbeit/ (tools/, config/, *.ps1, *.py, build-Skripte, aber NICHT die *.tex-Inhaltsdateien selbst). Finde JEDE Nicht-C++-Stelle die (a) Messwerte -> LaTeX generiert/orchestriert (z.B. generate_measurement_appendix.ps1, build_all.ps1), (b) .tex formatiert/nachbearbeitet (tools/format_tex.py), (c) sonst Python/PowerShell in der Diplomarbeit-Build-Kette. Fuer jeden datei:zeile + was es tut + ob es Messwerte in grossem Umfang verarbeitet.` },
  { key: 'ce-codegen', prompt: `Durchsuche NUR ${ROOT}/Code/external/comdare-cache-engine/ (aber NICHT build*/). Finde Nicht-C++-Stellen in der Codegen-/Build-/Mess-Kette: Python/.ps1/shell die Permutationen generieren, CSV/Messwerte verarbeiten, oder als Build-Orchestrator dienen (statt CMake/C++). Der Kern ist C++; suche die RAENDER (Skript-Helfer). datei:zeile je Fund.` },
  { key: 'modules-and-scripts', prompt: `Repo-Wurzel ${ROOT}. Suche kette-weit (super + ce + thesis + evtl. Modules/comdare-*) nach Build-/CI-/Helfer-Skripten in Python/PowerShell/komplexem shell die (a) als Orchestrator/Build-Treiber dienen, (b) Daten aufbereiten. Nutze grep/glob fuer *.py, *.ps1, *.sh mit nicht-trivialer Logik. Schliesse reine 3-Zeilen-Wrapper und CI-YAML aus. datei:zeile + Rolle.` },
  { key: 'perf-lens', prompt: `Repo-Wurzel ${ROOT}. PERFORMANCE-LINSE: der User hat GIGANTISCHE Messwerttabellen (golden-320 = 320 Permutationen x ~163 Zeilen; Permutationsraum bis 137 Bio.). Suche kette-weit JEDE Stelle, die diese Tabellen in einer LANGSAMEN Sprache/Weise verarbeitet: Python-CSV-Parsing (csv/pandas), shell-Schleifen ueber CSV-Zeilen (while read / awk / sed / cut auf grossen Dateien), PowerShell-Import-Csv, mehrfaches Re-Parsing. Auch INNERHALB der .gitlab-ci.yml (python3 -c Inline-Snippets die Messdaten verarbeiten). Bewerte je Fund die Skalierungs-Gefahr. datei:zeile.` },
]

phase('Discover')
const discovered = await parallel(DIMS.map(d => () =>
  agent(`Du bist ein read-only Audit-Agent (Antwort Deutsch). Ziel: Kandidaten fuer Ersetzung durch eine performante C++23-Anwendung finden (User-Direktive: kein Python, Performance auf gigantischen Messwerttabellen, keine Behelfswege). ${d.prompt}\n\nSei praezise + belege mit datei:zeile. Erfinde nichts; wenn eine Dimension leer ist, gib candidates:[] zurueck.`,
    { label: `discover:${d.key}`, phase: 'Discover', schema: CAND_SCHEMA })
))

// Flatten + dedup nach file (plain code, kein Agent)
const seen = new Set()
const cands = []
for (const r of discovered.filter(Boolean)) {
  for (const c of (r.candidates || [])) {
    const key = (c.file || '').trim()
    if (!key || seen.has(key)) continue
    seen.add(key); cands.push(c)
  }
}
log(`Discover: ${cands.length} eindeutige Kandidaten ueber ${DIMS.length} Dimensionen`)

phase('Assess')
const verdicts = (await parallel(cands.map(c => () =>
  agent(`Du pruefst ADVERSARIAL, ob dieser Fund GENUINE durch eine saubere, performante C++23-Anwendung ersetzt werden sollte — oder ob er legitim non-C++ ist (CI-YAML das YAML bleiben muss, Einmal-Dev-Helper, reine .tex, 3-Zeilen-Wrapper, etwas das CMake nativ besser macht). Default-Skepsis: im Zweifel is_real_candidate=false mit Begruendung.\n\nKandidat: file=${c.file} lang=${c.language} rolle=${c.role} grund=${c.why_replace} perf_big=${c.perf_on_big_tables} beleg=${c.evidence}\n\nRepo-Wurzel ${ROOT} — LIES die Datei real, urteile am Code. Bei is_real_candidate=true: nenne die konkrete C++23-App (Ein-/Ausgang, Andockpunkt in CMake/CI, ob sie die bestehenden Libs 04_csv_to_latex/05_diagram_generator nutzt) + Perf-Impact auf gigantische Tabellen + Aufwand S/M/L.`,
    { label: `assess:${(c.file || '').split('/').pop()}`, phase: 'Assess', schema: VERDICT_SCHEMA })
    .then(v => ({ ...v, cand: c }))
))).filter(Boolean)

const confirmed = verdicts.filter(v => v.is_real_candidate)
log(`Assess: ${confirmed.length}/${verdicts.length} als echte C++23-Ersetzungs-Kandidaten bestaetigt`)

phase('Synthesize')
const synthesis = await agent(
  `Synthetisiere aus diesen adversarial-bestaetigten Kandidaten eine PRIORISIERTE TODO-Liste „Nicht-C++-Stelle -> C++23-App" fuer die Diplomarbeit-Kette. User-Kontext: kein Python, Performance auf gigantischen Messwerttabellen, keine Behelfswege, immer der sauberste Weg. Gruppiere nach Prioritaet (high/medium/low severity), nenne je Eintrag: die Stelle (datei), was ersetzt wird, die konkrete C++23-App (Ein-/Ausgang + CMake/CI-Andockpunkt + ob sie bestehende Libs nutzt), Perf-Begruendung, Aufwand. Markiere, was bereits als #24 (Anhang-Generator C++23) abgedeckt ist, um Doppelung zu vermeiden. Ausgabe: knappe, umsetzbare Markdown-TODO-Liste (das ist der Rueckgabewert).\n\nBestaetigte Kandidaten (JSON):\n${JSON.stringify(confirmed.map(v => ({ file: v.file, severity: v.severity, reason: v.reason, cpp23: v.cpp23_replacement, perf: v.perf_impact, effort: v.effort })), null, 1)}`,
  { label: 'synthesize:todo', phase: 'Synthesize' })

return { total_candidates: cands.length, confirmed: confirmed.length, confirmed_list: confirmed.map(v => ({ file: v.file, severity: v.severity, effort: v.effort, cpp23: v.cpp23_replacement })), synthesis }