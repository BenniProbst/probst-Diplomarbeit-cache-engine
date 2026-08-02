export const meta = {
  name: 'kontext-neugruendung-diplomarbeit-20260802',
  description: 'Voll-Einlesung nach Kompaktierung 02.08. abends: Architektur + letzte 5 Sessions + Plaene/Ledger + Wellen-Backups (2b/2c) + Transkript-Nachrichten',
  phases: [
    { title: 'Inventar', detail: 'Architektur-Gruppen balancieren + Transkript-Nachrichten extrahieren' },
    { title: 'Einlesen', detail: 'parallele Opus-xhigh-Voll-Leser', model: 'opus' },
    { title: 'Synthese', detail: 'Lage-Dossier fuer den Architekten (Fable, v2.1)' },
  ],
}

const S = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = S + '/Code/external/comdare-cache-engine'
const SP = '/tmp/claude-1001/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489/scratchpad/neugruendung-20260802'
const TK = '/home/comdare/.claude/projects/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489.jsonl'
const BK = S + '/docs/sessions/backups'

const INV = { type: 'object', properties: { groups: { type: 'array', items: { type: 'array', items: { type: 'string' } } } }, required: ['groups'] }
const CHUNKS = { type: 'object', properties: { chunks: { type: 'array', items: { type: 'string' } } }, required: ['chunks'] }

phase('Inventar')
const [inv, ex] = await parallel([
  () => agent(
    `Liste alle .md-Dateien unter ${S}/docs/architektur/ UND ${S}/docs/architecture/ UND ${CE}/docs/architecture/ ` +
    `(absolute Pfade, jede vorhandene Wurzel; fehlende Wurzeln still ueberspringen) mit Zeilenzahl (wc -l). ` +
    `Teile sie in 4 nach Gesamt-Zeilenzahl moeglichst balancierte Gruppen (jede Datei genau EINMAL, keine Datei auslassen). ` +
    `Gib NUR das JSON {"groups":[[pfad,...],[...],[...],[...]]} zurueck.`,
    { label: 'inventar-architektur', schema: INV, effort: 'low' }
  ),
  () => agent(
    `Extrahiere aus ${TK} (272 MB JSONL, Claude-Code-Session-Transkript) chronologisch NUR die sichtbare Konversation: ` +
    `fuer jede JSONL-Zeile mit .type=="user" oder .type=="assistant" alle message.content[]-Elemente mit type=="text" als Klartext, ` +
    `mit Prefix "USER:" bzw. "ASSISTANT:". tool_use-, tool_result- und thinking-Bloecke KOMPLETT weglassen. ` +
    `ZUSAETZLICH (Wahrheits-Anker-Extraktor-Lehre): auch .queued_command.prompt-Felder als "USER(queued):" mitziehen, falls vorhanden. ` +
    `Nutze jq streaming-faehig (jq -r pro Zeile; bei String-content von user-messages auch den String selbst nehmen). ` +
    `WICHTIG (Sicherheits-Pflicht): danach ein sed-Redaktions-Pass ueber das Ergebnis, der die Muster ` +
    `glpat-[A-Za-z0-9._-]{15,} , github_pat_[A-Za-z0-9_]{30,} , ghp_[A-Za-z0-9]{30,} durch [REDACTED] ersetzt. ` +
    `Splitte das redigierte Ergebnis in Chunks von je max 300 KB nach ${SP}/tk_NN.txt (NN = 01,02,... chronologisch, split -C 300k geht). ` +
    `Die Rohdatei NIE kopieren, nur die redigierte Extraktion ablegen. Gib NUR JSON {"chunks":[absolute Pfade in chronologischer Reihenfolge]} zurueck.`,
    { label: 'transkript-extraktion', schema: CHUNKS, effort: 'low' }
  ),
])

if (!inv || !ex) { log('Inventar unvollstaendig: inv=' + !!inv + ' ex=' + !!ex) }

phase('Einlesen')
const archGroups = (inv && inv.groups) ? inv.groups : []
const chunks = (ex && ex.chunks) ? ex.chunks : []
log(`Architektur-Gruppen: ${archGroups.length}, Transkript-Chunks: ${chunks.length}`)

const readers = []

archGroups.forEach((g, i) => readers.push(() => agent(
  `Du liest fuer den Architekten der Diplomarbeit (Cache-Engine-Experiment-System, C++/Drogon, comdare) nach einem Kontextverlust. ` +
  `Lies JEDE dieser Architektur-Dateien VOLLSTAENDIG:\n${g.join('\n')}\n` +
  `Liefere: (a) je Datei eine dichte Zusammenfassung (bindende Vertraege, Invarianten, Architektur-Entscheidungen, offene Punkte, ` +
  `datei:zeile-Anker fuer das Wichtigste), (b) eine Querschnitts-Liste der HARTEN Direktiven/Verbote, (c) Widersprueche zwischen den Dateien. ` +
  `Keine Secret-Werte zitieren. Rueckgabe als strukturierter Klartext.`,
  { label: `arch-${i + 1}`, phase: 'Einlesen', model: 'opus', effort: 'xhigh' }
)))

readers.push(() => agent(
  `Bestimme in ${S}/docs/sessions/ und ${CE}/docs/sessions/ (falls vorhanden) ` +
  `je die 5 NEUESTEN .md-Dateien nach DATEINAMEN-Datum (nicht mtime, die mtimes sind durch Checkouts verfaelscht) und lies sie VOLLSTAENDIG. ` +
  `Liefere chronologisch (aelteste zuerst): Stand je Session, gelandete Commits/Scheiben, offene Faeden, User-Direktiven. ` +
  `Keine Secret-Werte zitieren.`,
  { label: 'sessions-letzte-5', phase: 'Einlesen', model: 'opus', effort: 'xhigh' }
))

readers.push(() => agent(
  `Lies VOLLSTAENDIG (grosse Dateien in Abschnitten, aber luecklos): ` +
  `${S}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md , ` +
  `${S}/docs/sessions/20260802-KATALOG-offene-strecke-gesamtplan.md , ` +
  `${S}/docs/sessions/20260802-BAUPLAN-owner-entscheide-synthese-kritischer-pfad.md , ` +
  `${S}/docs/sessions/20260802-PAUSE-abbruchsicher-mittagsstand-wiederaufnahme.md , ` +
  `${S}/docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md . ` +
  `Liefere den Plan-Ueberblick: (a) beschlossene Roadmap + Gates in Reihenfolge, (b) offene Punkte mit Kennungen (A13/E-NN/#NN) und Status, ` +
  `(c) Termine/Fristen, (d) was Ledger + Owner-Entscheide als BINDEND markieren (woertlich wo noetig). Keine Secret-Werte zitieren.`,
  { label: 'plaene-ledger', phase: 'Einlesen', model: 'opus', effort: 'xhigh' }
))

readers.push(() => agent(
  `Lies VOLLSTAENDIG die Wellen-Workflow-Backups des 02.08. unter ${BK}/: ` +
  `20260802-bauplan-welle1-workflows/ , 20260802-bauplan-welle2a-workflows/ , 20260802-bauplan-welle2b-workflows/ ` +
  `(insbesondere 00-welle2b-result.json KOMPLETT inkl. aller review.befunde und ledger_texte) , ` +
  `20260802-codex-dualreview/ (00-codex-review-tp1-w1-w2a.md + 01-welle2c-result.json + 02-welle2c-journal.jsonl). ` +
  `Liefere: (a) je Welle: Straenge, Commits, Verdikte, NACHBESSERN-Befunde WOERTLICH, ledger_texte-Liste, offene_punkte; ` +
  `(b) den Landungs-Stand (was ist schon auf ce dev gelandet, was wartet in Worktrees wt-w2b-*/wt-w2c-*); ` +
  `(c) alle an den Manager delegierten Nachpflichten (rescue-Refs, Ledger-Nachzug, Owner-Vorlagen). ` +
  `Keine Secret-Werte zitieren.`,
  { label: 'wellen-backups', phase: 'Einlesen', model: 'opus', effort: 'xhigh' }
))

chunks.forEach((c, i) => readers.push(() => agent(
  `Lies ${c} VOLLSTAENDIG. Es ist der redigierte Konversations-Auszug (nur User/Assistant-Text) der laufenden Kontext-Session ` +
  `der Diplomarbeit-Managersession (Chunk ${i + 1}/${chunks.length}, chronologisch). ` +
  `Extrahiere chronologisch: (a) User-Direktiven (WOERTLICH wo bindend), (b) Architektur-/Scope-Entscheidungen mit Begruendung, ` +
  `(c) Paketmeldungen/Abnahmen/Commits, (d) Fehler+Fixes, (e) offene Faeden am Chunk-Ende. ` +
  `NIE Secret-Werte zitieren (auch nicht teilweise).`,
  { label: `transkript-${i + 1}`, phase: 'Einlesen', model: 'opus', effort: 'xhigh' }
)))

const results = await parallel(readers)
const archN = archGroups.length
const arch = results.slice(0, archN).filter(Boolean)
const sess = results[archN] || '(sessions-Leser ausgefallen)'
const plaene = results[archN + 1] || '(plaene-Leser ausgefallen)'
const wellen = results[archN + 2] || '(wellen-Leser ausgefallen)'
const tk = results.slice(archN + 3).filter(Boolean)
log(`Einlesen fertig: ${arch.length}/${archN} arch, sessions=${!!results[archN]}, plaene=${!!results[archN + 1]}, wellen=${!!results[archN + 2]}, ${tk.length}/${chunks.length} transkript`)

phase('Synthese')
const dossier = await agent(
  `Du bist der Synthese-Agent der Diplomarbeit-Neugruendung (Fable, Arbeitsweise v2.1: Synthese nie Opus). ` +
  `Unten die Teil-Berichte paralleler Voll-Leser. ` +
  `Erstelle DAS Lage-Dossier fuer den Architekten (Manager-Session), gegliedert: ` +
  `(1) bindende User-Direktiven (dedupliziert, mit Quelle; neueste Owner-Aussage verdraengt aeltere -- Verdraengungen explizit), ` +
  `(2) Architektur-Vertraege+Invarianten (mit datei:zeile), ` +
  `(3) exakter Implementierungs-Stand (Commit-Kette, was gelandet, was in Worktrees wartet, was ungepusht ist), ` +
  `(4) offene Arbeit in Gate-Reihenfolge bis zum Trigger-Ziel Do 07.08. (Frist Fr 08.08.), ` +
  `(5) Widersprueche/Luecken zwischen den Quellen (explizit benennen, nicht glaetten), (6) unmittelbar naechste Schritte. ` +
  `Sei vollstaendig vor knapp; keine Secret-Werte.\n\n` +
  `===== ARCHITEKTUR =====\n${arch.join('\n\n----- naechste Gruppe -----\n\n')}\n\n` +
  `===== LETZTE 5 SESSIONS =====\n${sess}\n\n` +
  `===== PLAENE/LEDGER =====\n${plaene}\n\n` +
  `===== WELLEN-BACKUPS (1/2a/2b/2c + Codex-Review) =====\n${wellen}\n\n` +
  `===== TRANSKRIPT LAUFENDE SESSION (chronologisch) =====\n${tk.join('\n\n----- naechster Chunk -----\n\n')}`,
  { label: 'synthese-lage-dossier', effort: 'xhigh' }
)

return { dossier }
