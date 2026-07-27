export const meta = {
  name: 'board-restore-verify',
  description: 'Memory+Sessions+Architektur+Ledger einlesen und Board-Vollstaendigkeit verifizieren',
  phases: [
    { title: 'Einlesen', detail: '4 parallele Reader: Memory, Sessions, Ledger, Architektur' },
    { title: 'Synthese', detail: 'Abgleich gegen 17-Punkte-Restore-Liste' },
  ],
}

const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const MEM = '/home/comdare/.claude/projects/-home-comdare/memory'

const STRAENGE_SCHEMA = {
  type: 'object',
  properties: {
    straenge: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          name: { type: 'string' },
          status: { type: 'string', description: 'offen | gated | laufend | erledigt | unklar' },
          warum_offen: { type: 'string' },
          quelle: { type: 'string', description: 'datei:zeile oder Doc-Name' },
        },
        required: ['name', 'status', 'warum_offen', 'quelle'],
      },
    },
    hinweise: { type: 'array', items: { type: 'string' } },
  },
  required: ['straenge'],
}

phase('Einlesen')
const READERS = [
  { key: 'memory', prompt: `Lies das Memory-Verzeichnis ${MEM}: zuerst MEMORY.md (Index), dann ALLE project_*- und die neuesten feedback_*-Dateien (ab 17.07. besonders gruendlich, erkennbar an Index-Sektionen). Extrahiere JEDEN noch offenen Arbeitsstrang / jede offene Kette / jedes offene Gate der Diplomarbeit (z.B. §62-B-Praezisierungen, §64, K7b, Batch-Emission, 320er, S7/S8, #46b, #47, #34-#37, #49, #51, #48, G-Gruppen, CI-Wartung, Runtime-Beweise, G7, post-v3 R1-R3, COMPARE, Lanes). Ignoriere reine Verhaltensdirektiven ohne Arbeitsauftrag. Gib je Strang: Name, Status, warum offen, Quelle (Datei).` },
  { key: 'sessions', prompt: `Lies in ${SUPER}/docs/sessions/ die NEUESTEN 5 Session-Dokumente (nach Dateiname/Datum rueckwaerts sortiert, 20260722-* zuerst; das Abend-Doc 20260722-SESSION-KONTEXTUEBERGABE-abend-k7b-komplett.md VOLLSTAENDIG). Extrahiere alle offenen Punkte, laufenden Threads, Gates, Merkposten und deren Reihenfolge. Gib je Strang: Name, Status, warum offen, Quelle (datei:zeile).` },
  { key: 'ledger', prompt: `Lies ${SUPER}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md. Die Datei ist gross: verschaffe dir per grep -n einen Ueberblick ueber §-Sektionen und #-Nummern, lies dann die Sektionen zu OFFENEN Punkten (insbesondere §61-§64, #31-#54, G-Gruppen, PV-4, W12, CI-Wartung) gezielt. Extrahiere jeden offenen #-Punkt / §-Auftrag mit Status, warum offen, Quelle (zeile).` },
  { key: 'architektur', prompt: `Lies in ${SUPER}/docs/architektur/ (und falls vorhanden ${SUPER}/docs/architecture/) die NEUESTEN 3-4 Dokumente (Datum im Namen bzw. ls -t). Besonders: das juengste Architektur-Konsolidierungs-Doc (Stand 22.07., SOLL/IST-Beschreibung) und das Reihenfolge-/Praezisierungs-Doc. Extrahiere: offene Umbauten, SOLL-IST-Deltas, geplante Ketten mit Reihenfolge. Gib je Strang: Name, Status, warum offen, Quelle (datei:zeile).` },
]

const gelesen = await parallel(READERS.map(r => () =>
  agent(r.prompt + ' Antworte NUR strukturiert.', { label: `lese:${r.key}`, phase: 'Einlesen', schema: STRAENGE_SCHEMA, effort: 'medium' })
    .then(x => ({ key: r.key, ...x }))))

phase('Synthese')
const RESTORE_LISTE = `1 Sweep-Ausgang verifizieren; 2 BATCH-EMISSION (O(Maschinen)-Batch-Jobs + Log-Flush + Smoke-Umfangs-Selektor, VOR 320er); 3 320er m3v2-320 (vereinte [all]-Lane, K7b-Stempel); 4 S7 Hybrid+M-4+Mess->PDF+Release-Wallclock; 5 S8 Thesis-PDF DE+EN (END-GATE 28.07.); 6 dev->main-Merge; 7 #46b Bestandslog-System (§62-B P1-P4); 8 #47 COMPARE; 9 #54 emit-Vertrags-Kette; 10 #34-#37 POST-v3-Kern; 11 #49 Hardware-Achsen; 12 #51 tier150-Ersatz; 13 #48-Scheibe-6 (gegated); 14 #38-#44 G-Gruppen + PV-4 + W12; 15 CI-WARTUNG (contract-Label, prt-art-Race, Suffix-Single-Source, 14min-Treiberbau, xmllint, Testing/); 16 2 Runtime-Beweise (R8b-Key-Gleichheit, R1/R2-HIT); 17 G7-User-Punkte. ERLEDIGT: S5/S6-Gate, K7b 1-4.`

const SYNTH_SCHEMA = {
  type: 'object',
  properties: {
    board_vollstaendig: { type: 'boolean' },
    fehlende_straenge: { type: 'array', items: { type: 'object', properties: {
      name: { type: 'string' }, warum_offen: { type: 'string' }, quelle: { type: 'string' },
      einordnung: { type: 'string', description: 'wo in der Kette einordnen / eigener Strang' } },
      required: ['name', 'warum_offen', 'quelle', 'einordnung'] } },
    korrekturen: { type: 'array', items: { type: 'string' }, description: 'stale/falsch formulierte Punkte der Restore-Liste' },
    bestaetigungen: { type: 'array', items: { type: 'string' } },
  },
  required: ['board_vollstaendig', 'fehlende_straenge', 'korrekturen', 'bestaetigungen'],
}

const synth = await agent(
  `Du bist Vollstaendigkeits-Pruefer fuer ein Task-Board der Diplomarbeit (Stand 22.07.2026 abends). SOLL-Board (17-Punkte-Restore-Liste aus der massgeblichen Abend-Uebergabe): ${RESTORE_LISTE}\n\nHier die Befunde von 4 unabhaengigen Readern (Memory / Sessions / Ledger / Architektur) als JSON:\n${JSON.stringify(gelesen.filter(Boolean), null, 1)}\n\nPruefe: (a) Fehlt auf der 17-Punkte-Liste ein noch offener Strang, den mindestens ein Reader belegt? (b) Ist ein Listenpunkt stale (in Wirklichkeit schon erledigt oder anders definiert)? (c) Stimmen Reihenfolge/Gates? Sei streng: nur Straenge mit konkreter Quelle als fehlend melden, keine Verhaltensdirektiven. Lies bei Zweifel die genannte Quelle selbst nach (du hast Lesezugriff).`,
  { label: 'synthese', phase: 'Synthese', schema: SYNTH_SCHEMA, effort: 'high' })

return { synthese: synth, reader_hinweise: gelesen.filter(Boolean).map(g => ({ key: g.key, n: (g.straenge||[]).length, hinweise: g.hinweise || [] })) }