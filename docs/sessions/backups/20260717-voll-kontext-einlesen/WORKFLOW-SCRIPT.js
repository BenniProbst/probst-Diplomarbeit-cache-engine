export const meta = {
  name: 'voll-kontext-einlesen',
  description: 'Gesamtes Ledger + letzte Sessions + Plandocs + Goal/Architektur tief einlesen und synthetisieren',
  phases: [
    { title: 'Lesen', detail: '9 parallele Tiefen-Leser' },
    { title: 'Synthese', detail: 'Konsolidiertes Arbeitsbriefing' },
  ],
}
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const LEDGER = SUPER + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'
const BK = SUPER + '/docs/sessions/backups'
const SCHEMA = {
  type: 'object', additionalProperties: false,
  properties: {
    direktiven: { type: 'array', items: { type: 'string' }, description: 'Bindende User-Direktiven/Regeln, je mit Quelle datei:zeile' },
    entscheidungen: { type: 'array', items: { type: 'string' }, description: 'Getroffene Entscheidungen/Rulings (mit User-Wortlaut wo vorhanden)' },
    offene_arbeit: { type: 'array', items: { type: 'string' }, description: 'Offene TODOs/Phasen mit Status und Gate' },
    tabus_und_gates: { type: 'array', items: { type: 'string' } },
    architektur_kern: { type: 'array', items: { type: 'string' }, description: 'Tragende Architektur-Fakten (Modelle, ABIs, Schichten, Zahlen)' },
    konflikte_oder_stale: { type: 'array', items: { type: 'string' }, description: 'Widersprüche/veraltete Aussagen zwischen Quellen' },
  },
  required: ['direktiven','entscheidungen','offene_arbeit','tabus_und_gates','architektur_kern','konflikte_oder_stale'],
}
const COMMON = `Du bist Tiefen-Leser für die Diplomarbeit-Session. Lies die genannten Quellen VOLLSTÄNDIG (Read, ggf. in Abschnitten mit offset/limit) und extrahiere maximal dicht. Neuere Fakten schlagen ältere. Jede Aussage mit Quelle (datei:zeile oder §). Keine Vermutungen — nur Belegtes.`
const readers = [
  { label: 'ledger-§0-§11I', src: `${LEDGER} Zeilen 1-412 (§0 GOAL bis §11-I)` },
  { label: 'ledger-§12', src: `${LEDGER} Zeilen 413-1003 (§12 Fortschreibungs-Log)` },
  { label: 'ledger-§13-§16', src: `${LEDGER} Zeilen 1004-1566 (§13-§16)` },
  { label: 'ledger-§17-§20', src: `${LEDGER} Zeilen 1567-1945 (§17-§20, NEUESTE Einstiege — §20 zuerst, dann §19, §18, §17)` },
  { label: 'inc2+inc1-plaene', src: `Alle Dateien in ${BK}/20260717-inc2-planung/ und ${BK}/20260717-inc1-bauplan/` },
  { label: 'parallel+inc0', src: `Alle Dateien in ${BK}/20260717-parallelisierungs-strategie/ und ${BK}/20260717-inc0-bauplan/` },
  { label: 'vollkonsol+konstruktionslogik', src: `Alle Dateien in ${BK}/20260717-voll-konsolidierung/ und ${BK}/20260717-konstruktionslogik-durchdringung/` },
  { label: 'sessions-20260716', src: `Alle Dateien in ${BK}/20260716-dll-load-mimalloc-diagnose/ und ${BK}/20260716-experiment-planer-codegen-design/` },
  { label: 'architektur-master', src: `${SUPER}/Code/external/comdare-cache-engine/docs/architecture/: dort die neuesten/autoritativen Master-Dokumente (ls zuerst; insbesondere Konsolidierter-Master-IST-Stand ~34, Doc 30 §8.0-artige Slot-Konventionen, Dossiers 16/17/19/20 zu E1-E4/CEB/Heuristik) + ${SUPER}/docs/architektur/ (ls zuerst, neueste zuerst). Fokus: bindende Slot-/ABI-/Schicht-Konventionen für Bau-INC-2/3` },
]
phase('Lesen')
const results = await parallel(readers.map(r => () =>
  agent(`${COMMON}\n\nQUELLEN: ${r.src}\n\nKontext: Wir stehen mitten in Bau-INC-2c (F12iii Telemetrie-Herauslösung aus der 19er-Komposition → 18 Slots, ABI-5). Extrahiere ALLES, was für INC-2c..2h, Bau-INC-3 (golden-Neubau, W3=A), geparkte Stränge (CI-Nachzug, Messlauf @SYNC-2, F10-LaTeX, Anhang A) und die Direktiven-Lage relevant ist.`, { label: r.label, phase: 'Lesen', schema: SCHEMA })
))
phase('Synthese')
const valid = results.filter(Boolean)
log(`${valid.length}/9 Leser erfolgreich`)
const syn = await agent(`Du bist Synthese-Agent. Hier die strukturierten Extrakte von ${valid.length} Tiefen-Lesern über Ledger (§0-§20), Session-Backups 16.-17.07., Baupläne INC-0..2, Parallelisierungs-Strategie und Architektur-Master:\n\n${JSON.stringify(valid, null, 1)}\n\nErzeuge EIN konsolidiertes Arbeitsbriefing (Markdown, dicht, max ~250 Zeilen) mit: (1) STAND JETZT (was ist verifiziert fertig, mit Commits); (2) AKTUELLE PHASE Bau-INC-2c Restschritte exakt; (3) DANACH 2d-2h + INC-3 je mit Kern-Designvorgaben aus den Bauplänen; (4) GEPARKTE STRÄNGE mit Entsperr-Bedingung; (5) BINDENDE DIREKTIVEN-KURZLISTE (dedupliziert, neueste Fassung); (6) TABUS/GO-Fenster; (7) KONFLIKTE/STALE-Punkte die Aufmerksamkeit brauchen. Neuere Fakten schlagen ältere (§20 > §19 > §18 > ...).`, { label: 'synthese', phase: 'Synthese' })
return { briefing: syn, leser_ok: valid.length }