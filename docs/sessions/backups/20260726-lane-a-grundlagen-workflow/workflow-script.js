export const meta = {
  name: 'lane-a-grundlagen-leser',
  description: 'Gezielt: Architektur-Doktrin + Lane-Bauplaene fuer die Lane-A-Beauftragung einlesen',
  phases: [
    { title: 'Einlesen', detail: 'Doktrin-Docs + STRUKT-R-Bauplan (2 Opus-Leser)' },
  ],
}
const ROOT = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const BACKUPS = ROOT + '/docs/sessions/backups'

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

phase('Einlesen')
const results = await parallel([
  () => agent(archPrompt, { label: 'arch-doktrin', phase: 'Einlesen', model: 'opus', effort: 'high' }),
  () => agent(lanePrompt, { label: 'lane-bauplaene', phase: 'Einlesen', model: 'opus', effort: 'high' }),
])
return { arch: results[0] || 'FEHLT: arch-doktrin lieferte nichts', lane: results[1] || 'FEHLT: lane-bauplaene lieferte nichts' }