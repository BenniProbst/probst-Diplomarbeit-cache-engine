export const meta = {
  name: 'neugruendung-einlesen-2607',
  description: 'Nach-Compact-Neugruendung: Session-Log-Delta gegen Dossier + Architektur/Bauplan-Einlesen + Ist-Code-Kartierung',
  phases: [
    { title: 'Log-Delta', detail: 'verlauf-01..30 gegen Kompaktierungs-Dossier' },
    { title: 'Architektur', detail: 'Lese-Reihenfolge-Docs + Lane-A-Bauplan + Ist-Code read-only' },
    { title: 'Synthese', detail: 'Lage-Report fuer den Manager' },
  ],
}
const ROOT = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = ROOT + '/Code/external/comdare-cache-engine'
const DOSSIER = ROOT + '/docs/sessions/20260726-DOSSIER-session-gesamtstand-kompaktierungs-anker.md'
const CHUNKDIR = ROOT + '/docs/sessions/backups/20260726-session-plaintext-verlauf'
const BACKUPS = ROOT + '/docs/sessions/backups'

const DELTA_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['chunk', 'deltas'],
  properties: {
    chunk: { type: 'string' },
    deltas: {
      type: 'array',
      items: {
        type: 'object', additionalProperties: false,
        required: ['kategorie', 'was', 'beleg'],
        properties: {
          kategorie: { enum: ['user_direktive', 'owner_entscheid', 'fakt', 'widerspruch_zum_dossier', 'offener_faden'] },
          was: { type: 'string' },
          beleg: { type: 'string' },
        },
      },
    },
  },
}

const nums = []
for (let i = 1; i <= 30; i++) nums.push(String(i).padStart(2, '0'))

const chunkPrompt = (n) =>
  'Du bist ein Delta-Leser fuer eine Manager-Session-Neugruendung (Diplomarbeit Cache-Engine).\n' +
  'SCHRITT 1: Lies das autoritative Kompaktierungs-Dossier VOLLSTAENDIG: ' + DOSSIER + ' (349 Zeilen).\n' +
  'SCHRITT 2: Lies den Session-Log-Chunk VOLLSTAENDIG: ' + CHUNKDIR + '/verlauf-' + n + '.txt\n' +
  'AUFGABE: Extrahiere NUR Deltas, d.h. Inhalte des Chunks, die im Dossier FEHLEN oder ihm WIDERSPRECHEN:\n' +
  '- user_direktive: bindende Anweisungen des Users/Owners, die das Dossier nicht abdeckt\n' +
  '- owner_entscheid: Entscheidungen mit Wortlaut-Kern, die im Dossier fehlen oder abweichen\n' +
  '- widerspruch_zum_dossier: Chunk sagt X, Dossier sagt Y (beides zitieren)\n' +
  '- offener_faden: zugesagte/angefangene Arbeit ohne dokumentierten Abschluss, die im Dossier-Board fehlt\n' +
  '- fakt: technisch tragende Fakten (Pfade, Werte, Commits), die im Dossier fehlen\n' +
  'KEINE Deltas melden fuer: reine Umformulierungen, Zwischenstaende die spaeter im Dossier konsolidiert sind, Tool-Rauschen.\n' +
  'beleg = "verlauf-' + n + '.txt:ZEILE". Wenn der Chunk keine Deltas enthaelt, gib deltas=[] zurueck. Sei streng: lieber 3 echte Deltas als 20 Pseudo-Deltas.'

const archPrompt =
  'Lies fuer eine Manager-Neugruendung (Architekt-Rolle, Diplomarbeit Cache-Engine) folgende Dokumente VOLLSTAENDIG:\n' +
  '1. ' + ROOT + '/docs/sessions/20260726-SESSION-layer-modell-antworten-QA-QF-stempel-doktrin.md\n' +
  '2. ' + ROOT + '/docs/sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md\n' +
  '3. ' + BACKUPS + '/20260726-explore-q3-klammerung/REPORT-hinweis.md\n' +
  '4. Das neueste HANDOVER-Dokument in ' + ROOT + '/docs/sessions/ (HANDOVER-6, per ls finden)\n' +
  'LIEFERE als Endtext einen kompakten ASCII-Report (max 120 Zeilen): (a) die 10 wichtigsten bindenden Architektur-Saetze mit datei:zeile, (b) alles was fuer die Beauftragung von Lane A (SYS-TAX: Achsen-Neuordnung R-A..R-D im Code) unmittelbar gebraucht wird: welche Doktrin-Punkte der Implementierer wortgenau einhalten muss (Klammer-Hierarchie Ebene 0-3, Stempel-Doktrin, Layer-Modell-Korrekturen D1/D3/D4/D5, external_utils-Rename, kSystemAxisOrder), (c) Unklarheiten/Luecken, die der Manager vor Lane-A-Start klaeren muss.'

const lanePrompt =
  'Lies fuer eine Manager-Neugruendung den STRUKT-R-Bauplan-Workflow-Backup-Ordner VOLLSTAENDIG:\n' +
  BACKUPS + '/20260726-strukt-r-planung-workflow/ (alle Dateien, ls zuerst)\n' +
  'sowie ergaenzend: ' + BACKUPS + '/20260726-layer-modell-erhebung-workflow/ (Synthese/Report-Dateien)\n' +
  'LIEFERE als Endtext einen ASCII-Report (max 120 Zeilen): (a) Lane-A-Bauplan im Detail (Arbeitspakete, Dateien, Reihenfolge, Gates), (b) Lane C und Lane F (W-13) Bauplaene, (c) welche Punkte des alten Bauplans durch die spaeteren Owner-Korrekturen (Q-2: OS=Komplex-Haupt; Meta-Metas=volle Achsen; offene Rekursion; generischer Wrapper; Q-4: CUSTOM_COMPILE=CLI-Feature; R-F: SIMD/AVX=Meta-Meta) UEBERHOLT sind und wie die korrigierte Fassung lautet, (d) Aufwands-/Risiko-Einschaetzung des kritischen Pfads A -> Join -> F.'

const istPrompt =
  'READ-ONLY-Kartierung (STRIKT: KEINE Builds, KEINE Datei-Aenderungen, KEIN ctest, KEIN cmake - ein anderer Agent arbeitet moeglicherweise im selben Tree; nur git-Lese-Kommandos und Datei-Reads).\n' +
  'Repo 1 (super): ' + ROOT + '\nRepo 2 (ce): ' + CE + '\n' +
  'AUFGABE: (1) In ce: git status --porcelain vollstaendig erfassen und die ~96 Eintraege in Gruppen kartieren: welche gehoeren zum Org18-WIP (18. Organ-Achse persistence_target, axes/persistence_target/, anatomy/, experiment_tree/, source_catalog, Registry-XML, Tests) und welche zum (d2)-WIP (planer_block_value.hpp, experiment_plan_director.hpp, profile_run_facade.*, planer-Tests)? Gibt es Eintraege, die zu KEINEM der beiden Pakete passen (= Verdacht auf Streu/Fremdarbeit)?\n' +
  '(2) git diff --stat HEAD in ce (nur Statistik) und die 5 untracked Dateien benennen.\n' +
  '(3) In ce: git log --oneline e3a0c6ff..HEAD (die 2 lokalen Commits verifizieren).\n' +
  '(4) In super: git diff --stat HEAD fuer Code/02_messung_driver/main.cpp ((d2)-super-Teil).\n' +
  '(5) Pruefe ob golden_fullpilot_320_binary_ids.txt und eine _abi6-Einfrierungs-Kopie existieren (ls + wc -l + head -3, NICHT aendern) - das zeigt den B-15-Stand.\n' +
  'LIEFERE als Endtext einen ASCII-Report (max 100 Zeilen) mit den literalen Befehls-Ausgaben (gekuerzt) und der Gruppen-Kartierung.'

phase('Log-Delta')
const results = await parallel([
  () => pipeline(nums, (n) => agent(chunkPrompt(n), { label: 'delta-' + n, phase: 'Log-Delta', schema: DELTA_SCHEMA, model: 'opus', effort: 'medium' })),
  () => agent(archPrompt, { label: 'arch-doktrin', phase: 'Architektur', model: 'opus', effort: 'high' }),
  () => agent(lanePrompt, { label: 'lane-bauplaene', phase: 'Architektur', model: 'opus', effort: 'high' }),
  () => agent(istPrompt, { label: 'ist-code-readonly', phase: 'Architektur', model: 'opus', effort: 'medium' }),
])

const chunkDeltas = (results[0] || []).filter(Boolean)
const arch = results[1] || 'FEHLT: arch-doktrin-Agent lieferte nichts'
const lane = results[2] || 'FEHLT: lane-bauplaene-Agent lieferte nichts'
const ist = results[3] || 'FEHLT: ist-code-Agent lieferte nichts'

const allDeltas = chunkDeltas.flatMap(r => (r.deltas || []).map(d => ({ ...d, chunk: r.chunk })))
log('Log-Delta fertig: ' + allDeltas.length + ' Deltas aus ' + chunkDeltas.length + '/30 Chunks')

phase('Synthese')
const deltaText = JSON.stringify(allDeltas).slice(0, 60000)
const synth = await agent(
  'Du bist der Synthese-Schritt einer Manager-Neugruendung. Lies zuerst das Dossier ' + DOSSIER + ' vollstaendig.\n' +
  'Hier die Delta-Funde aus 30 Session-Log-Chunks (JSON):\n' + deltaText + '\n\n' +
  'Hier der Ist-Code-Report:\n' + String(ist).slice(0, 15000) + '\n\n' +
  'AUFGABE: Erstelle einen ASCII-Lage-Report (max 100 Zeilen) fuer den Manager: (1) Welche Deltas sind ECHT handlungsrelevant (dedupliziert, priorisiert) - insbesondere Widersprueche zum Dossier und offene Faeden, die im Board fehlen? (2) Welche sind Rauschen/bereits konsolidiert (nur zaehlen, nicht auflisten)? (3) Passt der Ist-Code-Stand zum Dossier-Stand (Org18-WIP + d2-WIP, keine Fremdarbeit)? (4) Konkrete Empfehlungs-Liste: was muss der Manager JETZT tun, in Reihenfolge.',
  { label: 'synthese', phase: 'Synthese', model: 'opus', effort: 'xhigh' }
)

return { deltaCount: allDeltas.length, deltas: allDeltas, arch, lane, ist, synthese: synth }