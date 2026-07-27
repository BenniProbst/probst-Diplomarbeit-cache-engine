export const meta = {
  name: 'kontext-neugruendung-diplomarbeit',
  description: 'Voll-Einlesung nach Kompaktierung: Architektur komplett + letzte 5 Sessions + Plaene + Transkript-Nachrichten (Opus xhigh)',
  phases: [
    { title: 'Inventar', detail: 'Architektur-Gruppen balancieren + Transkript-Nachrichten extrahieren' },
    { title: 'Einlesen', detail: 'parallele Opus-xhigh-Voll-Leser', model: 'opus' },
    { title: 'Synthese', detail: 'Lage-Dossier fuer den Architekten', model: 'opus' },
  ],
}

const S = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const SP = '/tmp/claude-1001/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489/scratchpad'
const TK = '/home/comdare/.claude/projects/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489.jsonl'

const INV = { type: 'object', properties: { groups: { type: 'array', items: { type: 'array', items: { type: 'string' } } } }, required: ['groups'] }
const CHUNKS = { type: 'object', properties: { chunks: { type: 'array', items: { type: 'string' } } }, required: ['chunks'] }

phase('Inventar')
const [inv, ex] = await parallel([
  () => agent(
    `Liste alle .md-Dateien unter ${S}/docs/architektur/ (absolute Pfade) mit Zeilenzahl (wc -l). ` +
    `Teile sie in 4 nach Gesamt-Zeilenzahl moeglichst balancierte Gruppen (jede Datei genau EINMAL, keine Datei auslassen). ` +
    `Gib NUR das JSON {"groups":[[pfad,...],[...],[...],[...]]} zurueck.`,
    { label: 'inventar-architektur', schema: INV, effort: 'low' }
  ),
  () => agent(
    `Extrahiere aus ${TK} (216 MB JSONL, Claude-Code-Session-Transkript) chronologisch NUR die sichtbare Konversation: ` +
    `fuer jede JSONL-Zeile mit .type=="user" oder .type=="assistant" alle message.content[]-Elemente mit type=="text" als Klartext, ` +
    `mit Prefix "USER:" bzw. "ASSISTANT:". tool_use-, tool_result- und thinking-Bloecke KOMPLETT weglassen. ` +
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
  `Bestimme in ${S}/docs/sessions/ und (falls vorhanden) ${S}/Code/external/comdare-cache-engine/docs/sessions/ ` +
  `je die 5 NEUESTEN .md-Dateien nach DATEINAMEN-Datum (nicht mtime, die mtimes sind durch Checkouts verfaelscht) und lies sie VOLLSTAENDIG. ` +
  `Liefere chronologisch (aelteste zuerst): Stand je Session, gelandete Commits/Scheiben, offene Faeden, User-Direktiven. ` +
  `Keine Secret-Werte zitieren.`,
  { label: 'sessions-letzte-5', phase: 'Einlesen', model: 'opus', effort: 'xhigh' }
))

readers.push(() => agent(
  `Lies VOLLSTAENDIG (grosse Dateien in Abschnitten, aber luecklos): ` +
  `${S}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md , ${S}/docs/MASTERPLAN_KONSOLIDIERUNG_TERMINE.md , ` +
  `${S}/docs/INDEX.md , ${S}/docs/HANDOVER-ANHANG-TODO-BOARD-20260705.md , /home/comdare/.claude/plans/noble-shimmying-fairy.md . ` +
  `Liefere den Plan-Ueberblick: (a) beschlossene Roadmap + Gates in Reihenfolge, (b) offene Punkte mit Nummern (#NN) und Status, ` +
  `(c) Termine/Fristen, (d) was der Ledger als bindend markiert. Keine Secret-Werte zitieren.`,
  { label: 'plaene-ledger', phase: 'Einlesen', model: 'opus', effort: 'xhigh' }
))

chunks.forEach((c, i) => readers.push(() => agent(
  `Lies ${c} VOLLSTAENDIG. Es ist der redigierte Konversations-Auszug (nur User/Assistant-Text) der letzten Kontext-Session ` +
  `der Diplomarbeit-Managersession (Chunk ${i + 1}/${chunks.length}, chronologisch). ` +
  `Extrahiere chronologisch: (a) User-Direktiven (WOERTLICH wo bindend), (b) Architektur-/Scope-Entscheidungen mit Begruendung, ` +
  `(c) Paketmeldungen/Abnahmen/Commits, (d) Fehler+Fixes, (e) offene Faeden am Chunk-Ende. ` +
  `NIE Secret-Werte zitieren (auch nicht teilweise).`,
  { label: `transkript-${i + 1}`, phase: 'Einlesen', model: 'opus', effort: 'xhigh' }
)))

const results = await parallel(readers)
const n = readers.length
const archN = archGroups.length
const arch = results.slice(0, archN).filter(Boolean)
const sess = results[archN] || '(sessions-Leser ausgefallen)'
const plaene = results[archN + 1] || '(plaene-Leser ausgefallen)'
const tk = results.slice(archN + 2).filter(Boolean)
log(`Einlesen fertig: ${arch.length}/${archN} arch, sessions=${!!results[archN]}, plaene=${!!results[archN + 1]}, ${tk.length}/${chunks.length} transkript`)

phase('Synthese')
const dossier = await agent(
  `Du bist der Synthese-Agent der Diplomarbeit-Neugruendung. Unten die Teil-Berichte paralleler Voll-Leser. ` +
  `Erstelle DAS Lage-Dossier fuer den Architekten (Manager-Session), gegliedert: ` +
  `(1) bindende User-Direktiven (dedupliziert, mit Quelle), (2) Architektur-Vertraege+Invarianten (mit datei:zeile), ` +
  `(3) exakter Implementierungs-Stand (Commit-Kette, was gelandet, was in Bau), (4) offene Arbeit in Gate-Reihenfolge, ` +
  `(5) Widersprueche/Luecken zwischen den Quellen (explizit benennen, nicht glaetten), (6) unmittelbar naechste Schritte. ` +
  `Sei vollstaendig vor knapp; keine Secret-Werte.\n\n` +
  `===== ARCHITEKTUR =====\n${arch.join('\n\n----- naechste Gruppe -----\n\n')}\n\n` +
  `===== LETZTE 5 SESSIONS =====\n${sess}\n\n` +
  `===== PLAENE/LEDGER =====\n${plaene}\n\n` +
  `===== TRANSKRIPT LETZTER KONTEXT (chronologisch) =====\n${tk.join('\n\n----- naechster Chunk -----\n\n')}`,
  { label: 'synthese-lage-dossier', model: 'opus', effort: 'xhigh' }
)

return { dossier }