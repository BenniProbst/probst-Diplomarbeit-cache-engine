export const meta = {
  name: 'letzte-chunks-owner-antworten',
  description: 'verlauf-31+32 wortgenau einlesen: alle Owner/User-Antworten extrahieren, Delta gegen Dossier',
  phases: [
    { title: 'Extraktion', detail: 'je Chunk ein Opus-xhigh-Leser, wortgenaue Owner-Passagen' },
    { title: 'Abgleich', detail: 'Delta gegen Kompaktierungs-Dossier + Board' },
  ],
}
const ROOT = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const DIR = ROOT + '/docs/sessions/backups/20260726-session-plaintext-verlauf'
const DOSSIER = ROOT + '/docs/sessions/20260726-DOSSIER-session-gesamtstand-kompaktierungs-anker.md'

const mk = (n, lines) =>
  'Du liest den SCHLUSS-Teil eines Manager-Session-Logs (Diplomarbeit Cache-Engine). Datei: ' + DIR + '/verlauf-' + n + '.txt (' + lines + ' Zeilen, ca. 290KB - lies sie VOLLSTAENDIG in Teilen per Read mit offset/limit, ca. 600 Zeilen je Read, bis zum Ende; KEINE Zeile auslassen).\n' +
  'AUFGABE: Extrahiere ALLE Passagen, in denen der USER/OWNER spricht (Fragen, Antworten, Entscheide, Direktiven, Korrekturen) - WORTGENAU zitiert, mit Zeilennummer. Der Kontext: durch API-Stoerungen gingen Owner-Antworten verloren; JEDE Owner-Aussage zaehlt.\n' +
  'Markiere je Passage: (1) ZITAT wortgenau, (2) Zeile, (3) worauf sie antwortet (1 Satz Kontext aus dem Log), (4) Einordnung: Entscheid / Direktive / Frage / Smalltalk.\n' +
  'LIEFERE als Endtext: die vollstaendige chronologische Liste ALLER Owner-Passagen (auch scheinbar kleine), ASCII-only. Assistenten-Text nur als 1-Satz-Kontext, nie in Laenge zitieren.'

phase('Extraktion')
const results = await parallel([
  () => agent(mk('31', 1789), { label: 'chunk-31', phase: 'Extraktion', model: 'opus', effort: 'xhigh' }),
  () => agent(mk('32', 897), { label: 'chunk-32', phase: 'Extraktion', model: 'opus', effort: 'xhigh' }),
])
const c31 = results[0] || 'FEHLT: chunk-31-Leser lieferte nichts'
const c32 = results[1] || 'FEHLT: chunk-32-Leser lieferte nichts'

phase('Abgleich')
const delta = await agent(
  'Lies das autoritative Kompaktierungs-Dossier VOLLSTAENDIG: ' + DOSSIER + ' (349 Zeilen).\n' +
  'Hier die wortgenauen Owner-Passagen aus den letzten beiden Session-Log-Chunks:\n\n=== CHUNK 31 ===\n' + String(c31).slice(0, 40000) + '\n\n=== CHUNK 32 ===\n' + String(c32).slice(0, 40000) + '\n\n' +
  'AUFGABE: Welche dieser Owner-Aussagen sind im Dossier NICHT oder FALSCH abgedeckt? Liste jedes Delta mit: (1) Owner-Zitat, (2) was das Dossier stattdessen sagt (oder FEHLT), (3) Handlungs-Konsequenz fuer den Manager (was ist dadurch ungeplant?). Sei streng aber vollstaendig - lieber ein Grenzfall-Delta zu viel. ASCII-only, max 120 Zeilen.',
  { label: 'delta-abgleich', phase: 'Abgleich', model: 'opus', effort: 'xhigh' }
)
return { chunk31: c31, chunk32: c32, delta }