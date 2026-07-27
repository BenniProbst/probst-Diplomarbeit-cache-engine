export const meta = {
  name: 'vorlauf-todo-sweep',
  description: 'Completeness-Sweep: vergessene Vor-Lauf-TODOs aus Ledger/Memory/Sessions (ohne Credentials-Bereiche)',
  phases: [
    { title: 'Sweep', detail: '3 Sucher: Ledger, Memory, Session-Docs — explizite Vor-Lauf/Vor-320er-Forderungen' },
    { title: 'Kritik', detail: 'Completeness-Critic gegen die Kandidatenliste' },
  ],
}
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const MEM = '/home/comdare/.claude/projects/-home-comdare/memory'
const SCHEMA = {
  type: 'object',
  properties: {
    funde: { type: 'array', items: { type: 'object', properties: {
      punkt: { type: 'string' }, forderung: { type: 'string', description: 'woertliche/sinngemaesse VOR-Bedingung' },
      quelle: { type: 'string' }, status_einschaetzung: { type: 'string' } },
      required: ['punkt', 'forderung', 'quelle', 'status_einschaetzung'] } },
  },
  required: ['funde'],
}
const AUSSCHLUSS = 'AUSSCHLUSS (User-Auflage): Lies NICHTS zu Login/Credentials/Vault/Tokens/Passwoertern — ueberspringe solche Dateien/Abschnitte komplett, zitiere sie nicht.'
phase('Sweep')
const SUCHER = [
  { key: 'ledger', prompt: `Durchsuche ${SUPER}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (grep nach 'VOR dem|vor dem 320|vor Voll|VOR/MIT|zwingend|Pflicht vor|W9|H-10|Vorbedingung|bevor' + Umfeld lesen) nach ALLEN Punkten, die explizit VOR dem Voll-Bau, VOR dem 320er-Messlauf oder VOR der naechsten Bau-Welle gefordert sind und moeglicherweise NICHT erledigt wurden. Kläre insbesondere: Was ist W9.1 / H-10-Sidecar genau (§41-Konsequenz 'bleibt VOR dem 320er-Messlauf zwingend') und ist es erledigt? ${AUSSCHLUSS}` },
  { key: 'memory', prompt: `Lies ${MEM}/MEMORY.md + die project_*- und juengsten feedback_*-Dateien (17.-23.07.). Sammle alle Direktiven/Punkte mit expliziter VOR-Bedingung bezueglich golden-Bau, 320er, Messlauf oder Batch-Kette, die noch offen sein koennten (z.B. neue-golden-Voraussetzungen, std::variant-Regression-Behebung als golden-Voraussetzung, Speicher-Voraussetzungen, W-Wellen). ${AUSSCHLUSS}` },
  { key: 'sessions', prompt: `Lies in ${SUPER}/docs/sessions/ die Dokumente vom 22.07. und 23.07. (alle 2026072*-Dateien ausser backups/). Sammle alle als 'vor dem 320er/Voll-Bau/naechster Welle' markierten Merkposten, Auflagen, Gates und pruefe je, ob der juengste Stand (Nacht-/Vormittags-Doc + Pause-Handover) sie als erledigt fuehrt. ${AUSSCHLUSS}` },
]
const funde = await parallel(SUCHER.map(s => () =>
  agent(s.prompt + ' Antworte NUR strukturiert mit datei:zeile-Quellen.', { label: `sweep:${s.key}`, phase: 'Sweep', schema: SCHEMA, effort: 'high' })
    .then(r => ({ key: s.key, ...r }))))
phase('Kritik')
const KANDIDATEN = `Bereits identifiziert und in Arbeit/geplant: (1) GIT_CLEAN-gn_out-Persistenz [in Bau]; (2) #27 Slice-Takt-Testat every_n=K + tee in Trace [in Bau]; (3) #29 Cancel-trap-Prozessgruppe minimal [in Bau]; (4) K-Label-Kosmetik [in Bau]; (5) lokaler Resume-Skip-Beweis vor Trigger [geplant]; (6) W9.1/H-10-Sidecar als Board-Task vor 320er [Nachschlag laeuft]; (7) Aufraeum-Vorlauf: 12713-Cancel+Waisen+Wachen [geplant]; (8) Push-Wellen-Gruen-Check der letzten docs-Pushes [geplant].`
const KRITIK_SCHEMA = {
  type: 'object',
  properties: {
    fehlend: { type: 'array', items: { type: 'object', properties: {
      punkt: { type: 'string' }, warum_vor_lauf: { type: 'string' }, quelle: { type: 'string' } },
      required: ['punkt', 'warum_vor_lauf', 'quelle'] } },
    bestaetigt_abgedeckt: { type: 'array', items: { type: 'string' } },
    nicht_vor_lauf: { type: 'array', items: { type: 'string' }, description: 'Funde, die NICHT vor den Lauf gehoeren, mit Grund' },
  },
  required: ['fehlend', 'bestaetigt_abgedeckt', 'nicht_vor_lauf'],
}
const kritik = await agent(
  `Du bist Completeness-Critic. Kandidatenliste des Managers: ${KANDIDATEN}\n\nSweep-Funde (3 Sucher):\n${JSON.stringify(funde.filter(Boolean), null, 1)}\n\nPruefe streng: (a) Welche Sweep-Funde fehlen auf der Kandidatenliste und gehoeren WIRKLICH vor den neuen Voll-Bau-Lauf (nicht vor den 320er — das ist spaeter — ausser sie sind billig und im selben Touch)? (b) Welche Funde sind schon abgedeckt/erledigt (mit Beleg)? (c) Welche gehoeren explizit NICHT vor den Lauf? Lies bei Zweifel die Quellen nach. ${AUSSCHLUSS}`,
  { label: 'kritik', phase: 'Kritik', schema: KRITIK_SCHEMA, effort: 'xhigh' })
return { kritik, sweep_kurz: funde.filter(Boolean).map(f => ({ key: f.key, n: (f.funde||[]).length })) }