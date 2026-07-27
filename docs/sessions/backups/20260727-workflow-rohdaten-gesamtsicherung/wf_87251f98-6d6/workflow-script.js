export const meta = {
  name: 'vergessene-features-sweep',
  description: 'Batch-Sweep ALLER Ledger-Punkte + Plandocs/Workflow-Backups der letzten 3 Tage -> vergessene Features/Bloecke/Wellen (nicht im §48-Block) + Rueckfragen zu alten Punkten',
  phases: [
    { title: 'Sweep', detail: '7 Reader ueber disjunkte Quellen (Ledger-Baender + Plandocs + Backups)' },
    { title: 'Abgleich', detail: '1 Synthese: Ergaenzungen (nicht-widersprechend) + Rueckfragen (alt/zweifelhaft)' },
  ],
}
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const LEDGER = SUPER + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'
const COMMON = `Diplomarbeit-Doku. super=${SUPER}. REFERENZ = der §48-KONSOLIDIERTE GESAMTBLOCK im Ledger ${LEDGER} (Grep '## §48', ~180 Zeilen, 437 bereits erfasste offene Ziele in 8 Straengen). Lies IHN ZUERST als Referenz dessen, was SCHON erfasst ist. Deine Aufgabe: in deiner Quelle Features/Bloecke/Wellen finden, die im §48-Block NICHT (oder nur unvollstaendig) vorkommen = VERGESSEN. Antworte NUR mit StructuredOutput. Lange Ledger-Zeilen -> Read in ~250-Zeilen-Chunks.`

const VSCHEMA = { type:'object', required:['vergessen'], properties:{
  vergessen: { type:'array', items:{ type:'object', required:['beschreibung','typ','quelle','status_48'], properties:{
    beschreibung: {type:'string', description:'das vergessene Feature/Block/Welle in 1-2 Saetzen'},
    typ: {type:'string', description:'Feature | Block | Welle | Direktive | Fork'},
    quelle: {type:'string', description:'datei:zeile bzw. §-Anker'},
    status_48: {type:'string', description:'FEHLT_GANZ | FEHLT_TEILWEISE | WIDERSPRICHT_§48 | UNKLAR'},
    rueckfrage: {type:'string', description:'falls alt/zweifelhaft/widersprechend: die konkrete Frage an den User (uebernehmen vs beiseite legen); sonst leer'},
    prioritaet: {type:'string'},
  }}},
}}

phase('Sweep')
const quellen = [
  { label:'ledger:§0-§13', prompt:`Quelle: Ledger-Bereich Zeilen 1-1000 (§0-GOAL bis ~§13). Extrahiere vergessene Features/Bloecke/Direktiven/Forks, die NICHT im §48-Block sind. Achte auf: alte DoD-Punkte, F-Reste (F1-F29), S-Punkte, AP-Punkte, #-TODOs, die im §48 fehlen.` },
  { label:'ledger:§14-§19', prompt:`Quelle: Ledger-Bereich Zeilen 1000-1936 (§14-§19). Extrahiere vergessene Punkte, die NICHT im §48-Block sind (Gattungs-/Container-Plaene, Serialisierung, INC-Reihenfolgen, User-Entscheide A1-A8/B1/C1-C2, Bau-Roadmap-Details).` },
  { label:'ledger:§20-§47', prompt:`Quelle: Ledger-Bereich Zeilen 1936-2416 (§20-§47, OHNE §48). Extrahiere vergessene Punkte, die im §48-Block NICHT vollstaendig erfasst sind (feinere Sub-Direktiven aus §21-§47, die im 437-Ziel-Fold evtl. zusammengefasst/verloren wurden).` },
  { label:'plaene:17+18.07', prompt:`Quelle: Plandocs ${SUPER}/docs/plaene/20260717-*.md und 20260718-*.md (per Glob; lies je die Kern-Abschnitte/Zusammenfassungen). Finde geplante Bloecke/Wellen/Increments (INC-*, Bauplaene, Roadmap-Meilensteine), die im §48-Block NICHT vorkommen.` },
  { label:'plaene:19.07 (W5-W12+Kette)', prompt:`Quelle: Plandocs ${SUPER}/docs/plaene/20260719-*.md (per Glob — die W5-W12/Legenden-Kette/Registry/Roadmap-Bauplaene). Finde geplante Wellen/Bloecke/Forks, die im §48-Block NICHT (vollstaendig) erfasst sind. WICHTIG: Die W5-W12-Wellen sind teils schon gebaut — pruefe welche Folge-Increments/Forks (R1-R6, PL-*, GN-*) noch offen und NICHT im §48 sind.` },
  { label:'backups:17+18.07', prompt:`Quelle: Workflow-Backup-Ordner ${SUPER}/docs/sessions/backups/20260717-* und 20260718-* (per ls; lies je die SYNTHESE-/README-/Ergebnis-Datei). Finde Workflow-Ergebnisse/Empfehlungen/Befunde mit Handlungsbedarf, die im §48-Block NICHT erfasst sind (konformitaets-audits, fehlerklassen, parallelisierung, storage-verortung, optg-systemachsen).` },
  { label:'backups:19.07 + architektur + handovers', prompt:`Quelle: ${SUPER}/docs/sessions/backups/20260719-* + ${SUPER}/docs/architektur/2026071*.md + ${SUPER}/docs/sessions/2026-07-1[789]-*.md (per Glob/ls; Kern-Dateien). Der User betont: die Workflows von GESTERN (19.07.) sind weiterhin relevant. Finde vergessene Bloecke/Wellen/Direktiven aus diesen Quellen, die im §48-Block NICHT sind (Anforderungs-Ueberblick, achsen-nachschlagewerk-Deltas, Session-Handover-Restpunkte).` },
]
const sweepResults = await parallel(quellen.map(q => () =>
  agent(`${COMMON}\nAUFGABE: ${q.prompt}\nSei EXHAUSTIV. Fuer jeden Fund: status_48 (FEHLT_GANZ/FEHLT_TEILWEISE/WIDERSPRICHT/UNKLAR) + rueckfrage (nur falls alt/zweifelhaft/widersprechend). Wenn ein Fund dem §48-Block widerspricht ODER ein alter Punkt zweifelhaft ist (evtl. ueberholt) -> rueckfrage formulieren (uebernehmen vs beiseite legen), NICHT einfach ergaenzen.`,
    { label: q.label, phase:'Sweep', schema:VSCHEMA, model:'opus', effort:'high' })
))
const alle = sweepResults.filter(Boolean).flatMap(r => r.vergessen)
log(`Sweep: ${alle.length} vergessene/zweifelhafte Punkte roh erhoben`)

phase('Abgleich')
const synthese = await agent(`Du bist der Ledger-Chef-Redakteur. ${alle.length} roh-erhobene "vergessene/zweifelhafte" Punkte (aus 7 Batches ueber Ledger §0-§47 + Plandocs + Workflow-Backups der letzten 3 Tage) sind gegen den §48-Gesamtblock (437 erfasste Ziele) zu pruefen.

ROH-FUNDE (JSON):
${JSON.stringify(alle, null, 1)}

ERZEUGE zwei getrennte, deduplizierte Markdown-Listen:

## A) ERGAENZUNGEN (in §48 einzuarbeiten)
Nur Punkte mit status_48 = FEHLT_GANZ oder FEHLT_TEILWEISE UND OHNE Widerspruch zum §48-Block und OHNE rueckfrage. Format je Zeile: **[Strang]** Kurzname — Feature (Quelle, Prioritaet, empfohlener §48-Strang: Bau-Kette/Mess-Kette/Thesis/Hybrid/Storage/Infra/Konformitaet/Bookkeeping). Dedupliziere hart (gleiche Features aus mehreren Batches EINMAL). Wenn ein Punkt bei genauer Pruefung DOCH schon im §48 ist (der Reader hat ihn uebersehen), NICHT auflisten.

## B) RUECKFRAGEN AN DEN USER (alte Punkte: uebernehmen vs beiseite legen)
Alle Punkte mit status_48 = WIDERSPRICHT oder UNKLAR, oder mit gesetzter rueckfrage, oder alte/zweifelhafte Punkte die evtl. ueberholt sind. Format je Zeile: **[Nr]** Punkt (Quelle) — die konkrete Frage: WEITER-UEBERNEHMEN (weil ...) ODER BEISEITE-LEGEN (weil evtl. ueberholt durch ...). Gruppiere nach Thema. Gib je Rueckfrage eine EMPFEHLUNG (uebernehmen/beiseite) mit 1-Satz-Begruendung, damit der User schnell entscheiden kann. Max ~15 Rueckfragen (die wichtigsten; triviale weglassen).

Sei praezise und knapp. ASCII + deutsche Umlaute ok. Gib NUR die zwei Listen zurueck (ab '## A)').`, {label:'synthese:abgleich', phase:'Abgleich', model:'opus', effort:'high'})

return { synthese, roh_anzahl: alle.length }