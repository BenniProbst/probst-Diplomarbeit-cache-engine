export const meta = {
  name: 'persist-measurements-writeback-design',
  description: 'Design + adversariale Prüfung des persist:measurements CI-Jobs (#22): Auswertungsdokumente sammeln → measurement/<datiert>/ → commit-back nach development mit Write-Token + Loop-Schutz',
  phases: [
    { title: 'Investigate' },
    { title: 'Design' },
    { title: 'Refute' },
  ],
}

const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CITEMPL = '/home/comdare/Projekte/Cluster/_infra/ci-templates/base-pipeline.yml'

phase('Investigate')
const DIM = [
  {
    key: 'artifact-flow',
    prompt: `Lies ${SUPER}/.gitlab-ci.yml (READ-ONLY). Kartiere den ARTEFAKT-FLUSS für den geplanten persist:measurements-Job: (1) welche Jobs erzeugen welche Auswertungsdokumente + wo (Pfade)? Konkret: thesis:pdf → thesis/diplomarbeit/*.pdf (artifacts); manifest:provenance → manifest_out/build_manifest.txt (artifacts); prebackup:measurements → prebackup_store/ (artifacts); analyse:thesis-data baut die Tools comdare_binary_to_csv/csv_to_latex/diagram_generator + holt optional ce pmc:amd-Artefakt (ce-measure/). (2) Wie kommt ein NACHGELAGERTER Job an diese Artefakte? (GitLab needs:[{job,artifacts:true}] Mechanik). (3) In welcher STAGE läuft der persist-Job (nach thesis-pdf = letzte)? Gibt es eine measurement-off vs. -on Unterscheidung (COMDARE_RUN_MEASURE?) die beeinflusst WAS an CSV existiert? Belege mit datei:zeile. NICHTS ändern.`,
  },
  {
    key: 'push-back-mechanics',
    prompt: `GitLab-CI-Rückschreib-Mechanik (der KRITISCHE Teil). Frage: wie schreibt ein CI-Job robust einen Commit zurück auf den AKTUELLEN Branch (development), ohne (a) eine rekursive Pipeline zu triggern (Loop), (b) an non-fast-forward zu scheitern (development ist seit Pipeline-Start evtl. weitergewandert), (c) mit welchem CREDENTIAL (CI_JOB_TOKEN kann NICHT auf protected branches pushen; nötig = Project-Access-Token/Deploy-Token mit write_repository)? Erwartete Bausteine: git config user; git checkout/fetch des aktuellen development; commit mit "[skip ci]" ODER git push -o ci.skip (Loop-Schutz); push via https://<user>:<WRITE_TOKEN>@host/<CI_PROJECT_PATH>.git HEAD:<branch>; bei non-ff: fetch+rebase-onto-remote-HEAD ODER retry-Schleife (der measurement/<datiert>/-Ordner ist NEU je Lauf → sollte konfliktfrei mergen, aber development-tip kann sich bewegt haben). KRITISCH: ist development ein PROTECTED branch? dann muss das Write-Token protected-branch-push dürfen (allowed_to_push). Nenne die genaue, robusteste Sequenz + die Loop-Schutz-Fallstricke (skip ci muss im Commit-Message-Body ODER via push-option; GitLab wertet [skip ci] in der HEAD-Commit-Message). Bewerte git-Bloat (User ist sich bewusst, einfachste Variante zuerst).`,
  },
  {
    key: 'existing-patterns',
    prompt: `Lies in ${SUPER}/.gitlab-ci.yml die Jobs prebackup:measurements + manifest:provenance VOLLSTÄNDIG (READ-ONLY). Extrahiere das WIEDERVERWENDBARE Muster für persist:measurements: (a) prebackup's additive sha256-verifizierte nie-überschreiben-Logik (prebackup()-Funktion) — wie übernehme ich sie für measurement/<datiert>/? (b) manifest's date -u +%Y-%m-%dT%H:%M:%SZ-Zeitstempel + Provenance-Felder. (c) Der FS-sichere Datums-Ordner: der User-Wunsch war "YYYYMMTT-HH:SS" aber ":" bricht Windows/NTFS → welches Format (YYYYMMDD-HHMMSS)? (d) Muss der persist-Job das before_script (Submodul-Deploy-Token-Klon, REV 17) überschreiben (before_script:[])? Braucht er GIT_SUBMODULE_STRATEGY:none? Er braucht das thesis-Submodul für das PDF — oder holt er das PDF via needs-artifacts (dann kein Submodul-Klon nötig)? Belege datei:zeile.`,
  },
]
const invest = await parallel(DIM.map(d => () => agent(d.prompt, { label: `invest:${d.key}`, phase: 'Investigate' })))
const investText = DIM.map((d, i) => `### ${d.key}\n${invest[i] || '(kein Ergebnis)'}`).join('\n\n')

phase('Design')
const DESIGN_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['job_yaml', 'stage_change', 'artifact_sources', 'writeback_sequence', 'loop_guard', 'write_token_setup', 'inert_by_default', 'risks', 'local_test_plan'],
  properties: {
    job_yaml: { type: 'string', description: 'Der komplette persist:measurements-Job als GitLab-CI-YAML (inkl. rules-Gate, needs, script). INERT-by-default (rules: nur wenn COMDARE_PERSIST_MEASUREMENTS==true).' },
    stage_change: { type: 'string', description: 'Welche stages:-Änderung nötig (neue finale stage "persist" nach thesis-pdf?)' },
    artifact_sources: { type: 'string', description: 'Woher jedes Auswertungsdokument (PDF/CSV/Manifest) kommt (needs-artifacts vs. Submodul)' },
    writeback_sequence: { type: 'string', description: 'Die exakte git-commit-back-Sequenz (fetch/commit/push, non-ff-Handling)' },
    loop_guard: { type: 'string', description: 'Wie der rekursive Pipeline-Trigger verhindert wird ([skip ci] / ci.skip)' },
    write_token_setup: { type: 'string', description: 'Welches Write-Credential (Scope, protected, masked) + wie es als CI-Var referenziert wird — NICHT das Token-Value, nur der Mechanismus' },
    inert_by_default: { type: 'boolean', description: 'true = der Job läuft ohne explizites Enable-Flag NICHT (kein Auto-Push auf development bis bewusst aktiviert)' },
    risks: { type: 'string', description: 'git-Bloat, non-ff-Race, protected-branch, Token-Leak, Loop' },
    local_test_plan: { type: 'string', description: 'Wie ich die Sammel-/Ordner-/Commit-Logik LOKAL (bash, ohne Push) verifiziere' },
  },
}
const draft = await agent(
  `Du bist GitLab-CI-Architekt. Entwirf den persist:measurements-Job (#22) für super/.gitlab-ci.yml.\n\nZIEL (User 2026-07-11, Ledger §11-G): am ENDE des Pipelinelaufs die Auswertungsdokumente (LaTeX-PDF + Messwerte-CSV + Provenance-Manifest) sammeln, additiv nach measurement/<YYYYMMDD-HHMMSS>/ im super-Root schreiben, und per commit+push nach development zurückschreiben — sonst gehen die Ergebnisse verloren.\n\nHARTE CONSTRAINTS:\n- INERT-by-default: der Job pusht NICHT auf development, solange nicht ein explizites Flag (COMDARE_PERSIST_MEASUREMENTS==true) UND ein Write-Token gesetzt sind. (Sicherheit: kein ungewollter Auto-Push auf die geteilte Branch.)\n- FS-sicheres Datumsformat (kein ":", Windows-Matrix): YYYYMMDD-HHMMSS.\n- Loop-Schutz zwingend: der Auto-Commit darf KEINE rekursive Pipeline triggern ([skip ci] in der Commit-Message ODER push -o ci.skip).\n- additiv/nie-überschreiben (prebackup-Muster); neuer Ordner je Lauf → normalerweise konfliktfrei.\n- Write-Token: NUR als CI-Var-Referenz (COMDARE_WRITEBACK_USER/COMDARE_WRITEBACK_TOKEN), NIE Token-Wert im yaml. Das Token wird SEPARAT (Infra) angelegt — der Job referenziert es nur.\n- ci-templates (${CITEMPL}) TABU. Der persist-Job braucht KEINE Submodule zum Pushen (holt PDF/CSV via needs-artifacts) → before_script:[] + GIT_SUBMODULE_STRATEGY:none, um den REV-17-Submodul-Klon zu überspringen.\n- sauberste, robusteste Variante (non-ff-Race sauber behandeln).\n\nINVESTIGATION:\n${investText}`,
  { label: 'design:job', phase: 'Design', schema: DESIGN_SCHEMA },
)

phase('Refute')
const REFUTE_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['refuted', 'issue', 'fix'],
  properties: { refuted: { type: 'boolean' }, issue: { type: 'string' }, fix: { type: 'string' } },
}
const lenses = [
  'Loop-Risiko: kann der Auto-Commit/Push trotz [skip ci] eine rekursive Pipeline triggern (z.B. skip-ci wird nur in der HEAD-Commit-Message gewertet, nicht bei merge/mehreren Commits; oder push-option greift nicht)? Default refuted=true bei Restrisiko.',
  'non-ff + protected-branch: schlägt der Push fehl, wenn development seit Pipeline-Start weitergewandert ist ODER development protected ist und das Write-Token nicht push-berechtigt? Ist die fetch/rebase/retry-Sequenz korrekt?',
  'Inertheit + Sicherheit: läuft der Job WIRKLICH nicht (kein Push) ohne das Enable-Flag+Token? Kann das Write-Token im Log leaken? Bricht before_script:[]/STRATEGY:none den Job (fehlt ihm ein Submodul/Artefakt)?',
]
const draftStr = JSON.stringify(draft, null, 1)
const verdicts = await parallel(lenses.map((lens, i) => () =>
  agent(`Adversariale Prüfung des persist:measurements-Job-Designs durch die LINSE: "${lens}". Lies bei Bedarf ${SUPER}/.gitlab-ci.yml (READ-ONLY).\n\nDESIGN:\n${draftStr}`,
    { label: `refute:${i}`, phase: 'Refute', schema: REFUTE_SCHEMA })))

return { draft, investigation: investText, refutations: verdicts.filter(Boolean), survives: verdicts.filter(Boolean).every(v => !v.refuted) }
