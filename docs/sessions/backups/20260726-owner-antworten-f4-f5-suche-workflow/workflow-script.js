export const meta = {
  name: 'owner-antworten-f4-f5-suche',
  description: 'ultracode: Owner-Originalstellen zu Q-1/A-1/R-F/CT-RT-XOR + Definition von 2.4-(8) im Session-Log finden',
  phases: [
    { title: 'Suche', detail: '3 Opus-Leser ueber Chunks + Session-Docs + Plaene' },
    { title: 'Synthese', detail: 'wortgenaue Belege + 2.4-(8)-Definition' },
  ],
}
const ROOT = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CHUNKS = ROOT + '/docs/sessions/backups/20260726-session-plaintext-verlauf'
const BACKUPS = ROOT + '/docs/sessions/backups'

const p1 =
  'AUFGABE (Frage 4 des Owners): Finde die WORTGENAUEN Owner-Originalstellen zu vier Kern-Entscheiden im Session-Log. Der Owner sagt, er hat sie im letzten Kontext beantwortet. Suche in ' + CHUNKS + '/ (32 Dateien verlauf-NN.txt; beginne mit den NEUESTEN: 32,31,30,29,28; grep zuerst, dann Kontext-Zeilen lesen):\n' +
  '(1) Q-1: disk_writeback enabled=false (Suchworte: disk_writeback, Messwert, Luege, deaktivier)\n' +
  '(2) A-1: Truncate-Regeln Bestandslog (Suchworte: Truncate, 4KB, 4 KB, Build-Ende, Lock)\n' +
  '(3) R-F: SIMD/AVX = Meta-Meta-Achsen (Suchworte: SIMD, AVX, Meta)\n' +
  '(4) CT/RT-strikt-XOR-Haertung (Suchworte: compile time, runtime, XOR, statisch, dynamisch, Haupt, Unter)\n' +
  'LIEFERE je Punkt: das WOERTLICHE Owner-Zitat (transliteriert ASCII), Datei:Zeile, 1-Satz-Kontext, und das Verdikt ob es den paraphrasierten Dossier-Stand BESTAETIGT oder ABWEICHT (Dossier-Stand: (1) enabled=false weil kein echter Disk-Pfad=Messwert-Luege, XML-Deaktivierbarkeit Pflicht, Raum 2^17; (2) Truncate am Build-Ende oder >4KB, nur unter Knoten-Lock; (3) SIMD/AVX sind Meta-Meta-Achsen, nicht Unter-Achsen von extension_hardware; (4) Haupt=CT/Unter=RT als striktes XOR, stufen-relativ). ASCII-only, max 100 Zeilen.'

const p2 =
  'AUFGABE (Frage 5 des Owners): Finde die DEFINITION des Punkts "2.4-(8)" - der Owner weiss selbst nicht mehr, was es ist; bekannt ist nur: es ist eine Vor-01.08.-Pflicht, die NIE als erledigt gefuehrt wird (Fundstelle dieser Aussage: ' + CHUNKS + '/verlauf-32.txt um Zeile 460, Abschnitt C).\n' +
  'VORGEHEN: (a) Lies verlauf-32.txt Zeilen 400-520 VOLLSTAENDIG fuer den Kontext der 2.4-(8)-Erwaehnung. (b) Suche "2.4" (auch "2.4-(", "2.4 (", "Punkt 8", "(8)") in: ' + CHUNKS + '/verlauf-3*.txt, ' + ROOT + '/docs/sessions/*.md (die 20260725er und 20260726er zuerst), ' + BACKUPS + '/20260726-bestandslog-plan-nachlese-workflow/ (alle Dateien), ' + BACKUPS + '/20260725* (falls vorhanden). Das Nummern-Schema "2.4" stammt vermutlich aus einem Plan-/Nachlese-Dokument mit nummerierten Abschnitten (2.1, 2.2, ...) - finde das Dokument, dessen Abschnitt 2.4 acht oder mehr Unterpunkte hat.\n' +
  'LIEFERE: (1) das Quell-Dokument + woertlicher Text von Abschnitt 2.4 Punkt (8), (2) den verlauf-32-Kontext der Owner-Frist-Aussage, (3) eine 2-Satz-Definition fuer das Task-Board. Wenn NICHT auffindbar: sage das klar und liste, wo du gesucht hast. ASCII-only, max 80 Zeilen.'

phase('Suche')
const r = await parallel([
  () => agent(p1, { label: 'f4-vier-kerne', phase: 'Suche', model: 'opus', effort: 'xhigh' }),
  () => agent(p2, { label: 'f5-punkt-2-4-8', phase: 'Suche', model: 'opus', effort: 'xhigh' }),
])
return { f4: r[0] || 'FEHLT: f4-Leser lieferte nichts', f5: r[1] || 'FEHLT: f5-Leser lieferte nichts' }