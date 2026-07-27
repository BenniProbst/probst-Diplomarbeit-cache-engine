export const meta = {
  name: 'opus-turns-verify',
  description: 'Adversariale Verifikation der letzten 5 Turn-Artefakte (Commits, Ledger, Creds-Handling)',
  phases: [
    { title: 'Pruefen', detail: '3 unabhaengige Pruefer: T-Werte-Commit, Ledger-Nachtraege, Secret-Hygiene' },
  ],
}
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'
const SCHEMA = {
  type: 'object',
  properties: {
    verdikt: { type: 'string', enum: ['SAUBER', 'MAENGEL'] },
    befunde: { type: 'array', items: { type: 'string' } },
    belege: { type: 'array', items: { type: 'string' } },
  },
  required: ['verdikt', 'befunde', 'belege'],
}
phase('Pruefen')
const PRUEFER = [
  { key: 'twert-commit', prompt: `Pruefe adversarial den ce-Commit 007bdc3b (Repo ${CE}, git show 007bdc3b): Er soll lane_build_parallelism amd 24->32 / intel 16->24 setzen. Versuche zu WIDERLEGEN, dass er korrekt ist: (a) Sind wirklich NUR die 2 Dateien (director-Header + Planner-Test) betroffen, keine versteckten Nebenaenderungen? (b) Stimmen die neuen Literale 32/24 ueberall konsistent (grep im Diff nach 24/16/32 — kein Rest-Pin)? (c) Ist die Testdatei konsistent (kein widerspruechlicher Alt-Wert)? (d) Kommentare ASCII-konform (§ erlaubt)? Lies den Diff komplett.` },
  { key: 'ledger', prompt: `Pruefe adversarial die juengsten Ledger-Nachtraege in ${SUPER}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (Datei-Ende, ab '§62-B-NACHTRAG-2' bis Dateiende; auch den Batch-Planungs-Absatz und die Plattform-Auflage): (a) Widersprechen sich Nachtraege untereinander oder mit der Testat-Grammatik/Layer-Trennung weiter oben im §62-B-NACHTRAG? (b) Ist die io_uring/IoRing/IOCP-Backend-Auflage in sich konsistent (CT-Wahl, kein Runtime-Switch — kollidiert das mit 'Statischer Dispatch'-Doktrin? Sollte es NICHT: CT-Wahl ist konform — pruefe die Formulierung)? (c) Fehlt etwas Diktiertes: per-Binary-Erkennung, async Planung VOR ETA, Start ab erstem Batch, Slice-Queue, 256MB, avg_size, Dutzend-Trigger, zweiter Thread? (d) Mojibake-Check der neuen Absaetze (grep 'Ã|â€').` },
  { key: 'secret-hygiene', prompt: `Pruefe Secret-Hygiene der letzten Operationen: (a) ${SUPER}: 'git log --oneline -8' + fuer die letzten 8 Commits 'git show <sha> --stat' — ist KEINE Credentials-/Desktop-Datei committet? (b) grep -rE 'glpat-|github_pat_|ghp_' in ${SUPER}/docs/sessions/ (nur Zaehlung je Datei, KEINE Treffer-Inhalte ausgeben!) — alles 0? (c) Existiert ~/Desktop/comdare-prod1-op-creds.txt und hat sie chmod 600 (ls -la, NICHT lesen!)? (d) Liegt sie AUSSERHALB von ~/Desktop/DIPLOMARBEIT-PLAIN-BACKUP/ und ist der Backup-Ordner frei von ihr (ls, nicht lesen)? (e) Ist die Datei in KEINEM git-Arbeitsverzeichnis (~/Desktop kein Repo? git -C ~/Desktop rev-parse 2>&1)? WICHTIG: NIEMALS Datei-Inhalte der Creds-Datei oder Vault-Werte ausgeben — nur Metadaten/Zaehlungen.` },
]
const res = await parallel(PRUEFER.map(p => () =>
  agent(p.prompt + ' Antworte NUR strukturiert; Belege als datei:zeile bzw. Kommando+Metadaten-Resultat.', { label: `pruef:${p.key}`, phase: 'Pruefen', schema: SCHEMA, effort: 'high' })
    .then(r => ({ key: p.key, ...r }))))
return { pruefungen: res.filter(Boolean) }