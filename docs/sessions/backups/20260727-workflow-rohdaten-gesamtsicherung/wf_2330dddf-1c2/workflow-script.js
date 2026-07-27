export const meta = {
  name: 'new-golden-suche',
  description: 'ultracode (Owner-Auftrag): new-golden-Doktrin vollstaendig zusammentragen - Definition, Anker, Folgen des Achsen-Umbaus (NUMA/page_type/O0-O3-Permutation)',
  phases: [
    { title: 'Suche', detail: '2 Opus-Leser: Doktrin-Quellen + Ist-Code-Anker' },
    { title: 'Synthese', detail: 'new-golden-Zielbild nach dem golden-Bruch' },
  ],
}
const ROOT = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = ROOT + '/Code/external/comdare-cache-engine'
const Q = ROOT + '/docs/sessions/backups/20260726-session-plaintext-verlauf'
const LEDGER = ROOT + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'

const p1 =
  'OWNER-AUFTRAG (26.07., woertlich): "Golden Bruch, wir bauen es nach Plan, das alte golden ist verweest und ueberholt, new golden ist angesagt, bitte suche new golden per ultracode."\n' +
  'DEIN PART: die new-golden-DOKTRIN vollstaendig zusammentragen. Lies: (1) ' + LEDGER + ' - grep -n "new-golden\\|new golden\\|GN-\\|Voll-Konfiguration\\|2^17\\|§33\\|§41" + Kontext-Sektionen LESEN; (2) Owner-Wortlaute: grep -n "golden" ' + Q + '/verlauf-queued-ergaenzung-*.txt mit Kontext (chronologisch; besonders Aussagen zu new-golden/Neuanker/Kardinalitaet); (3) das Memory /home/comdare/.claude/projects/-home-comdare/memory/feedback_new_golden_all_axes_xml_gt320.md; (4) die 26.07.-Docs zu golden (Achsen-Neuordnung + Wahrheits-Anker E-08-Kontext).\n' +
  'LIEFERE (ASCII, max 90 Zeilen): (a) die new-golden-DEFINITION wortgenau (was ist der legitime Beweis, was ist die 320er-Byte-Wache), (b) die Anker-Historie (alt-CRC -> ORG-18-CRC 0x56F1B721C72DC10E), (c) ALLE Owner-Aussagen zur golden-Zukunft chronologisch, (d) was "das alte golden ist verweest" fuer die bestehenden Wachen heisst (320er-Datei, CatalogAxes<4,4,5,4>, Roundtrip-Gates).'

const p2 =
  'DEIN PART: die Ist-Code-Anker des golden-Systems + die Folgen des beschlossenen Umbaus kartieren. KONTEXT: Owner-GO golden-Bruch VOR Voll-Bau-4; kommende Aenderungen: NUMA/locking als neue System-Haupt-Achse (ISA-abhaengig), page_type-Achse (Cache-Awareness PFLICHT), Bau permutiert opt O0-O3 ("wie gehabt ueber alle verfuegbaren Stufen"), external_utils-Rename, kSystemAxisOrder neu.\n' +
  'Lies in ' + CE + ': (1) libs/cache_engine/builder/profile_facade/source_catalog.hpp (FullSourceCatalog, kNewGolden131072Crc64, golden_320_catalog, Anti-Materialisierungs-Guard); (2) tools/gen_golden_fullpilot/main.cpp (Modi --crc64/--golden320); (3) tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt (Kopf); (4) grep -rn "kNewGolden\\|golden_320\\|CatalogAxes" ' + CE + '/libs ' + CE + '/tests/unit --include="*.hpp" --include="*.cpp" -l | head -12 (Konsumenten-Liste); (5) die Registry system_axis_registry.xml (welche System-Achsen sind heute golden-relevant - Organ-only binary_id!).\n' +
  'LIEFERE (ASCII, max 90 Zeilen): (a) alle golden-Anker mit datei:zeile, (b) WELCHE der kommenden Aenderungen die binary_id/Kardinalitaet beruehren (NUMA/page_type: System oder Organ? Organ-only-binary_id-Doktrin!) und welche NUR System-Perm-Raum sind (opt O0-O3), (c) die Konsumenten-Menge die ein new-golden-Neuanker anfassen muss, (d) Empfehlung: new-golden-Prozedur nach ORG-18-Blaupause (additive Einfrierung, Regen, CRC-Neuanker) fuer den kommenden Umbau.'

phase('Suche')
const r = await parallel([
  () => agent(p1, { label: 'doktrin', phase: 'Suche', model: 'opus', effort: 'high' }),
  () => agent(p2, { label: 'ist-anker', phase: 'Suche', model: 'opus', effort: 'high' }),
])
phase('Synthese')
const synth = await agent(
  'Synthese des new-golden-Suchauftrags (Owner: "das alte golden ist verweest und ueberholt, new golden ist angesagt"). Doktrin:\n' + String(r[0] || 'FEHLT').slice(0, 15000) +
  '\n\nIst-Anker:\n' + String(r[1] || 'FEHLT').slice(0, 15000) +
  '\n\nLIEFERE (ASCII, max 80 Zeilen): (1) DAS NEW-GOLDEN-ZIELBILD nach dem beschlossenen Umbau (Kardinalitaet, Anker, Wachen-Zukunft: was bleibt Byte-Wache, was wird neu geankert, was wird deprecated), (2) die Einbau-Reihenfolge relativ zu Lane A/C/F + NUMA/page_type (wer bricht golden wann, wie oft ankern wir neu - Ziel: EIN koordinierter Neuanker statt drei), (3) offene Punkte.',
  { label: 'synthese', phase: 'Synthese', model: 'opus', effort: 'xhigh' }
)
return { doktrin: r[0], istAnker: r[1], synthese: synth }