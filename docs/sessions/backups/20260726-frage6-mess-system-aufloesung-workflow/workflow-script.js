export const meta = {
  name: 'frage6-selbst-aufloesung-mess-system',
  description: 'ultracode: Mess/System-Relation (Ordnung, Steuer-Verantwortung, kSystemAxisOrder) aus den vorhandenen Definitionen SELBST aufloesen - Owner nicht erneut fragen',
  phases: [
    { title: 'Belege', detail: '3 Opus-Sucher: Ledger, Owner-Wortlaute+Session-Docs, Ist-Code' },
    { title: 'Aufloesung', detail: 'xhigh-Synthese: widerspruchsfreies Regelwerk als Lane-A-Vorgabe' },
  ],
}
const ROOT = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = ROOT + '/Code/external/comdare-cache-engine'
const QDIR = ROOT + '/docs/sessions/backups/20260726-session-plaintext-verlauf'
const LEDGER = ROOT + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'

const FRAGE =
  'DIE AUFZULOESENDE FRAGE (Owner: "es ist wirklich alles definiert, loese es selbst auf"): Wie verhalten sich (i) die bindende SORTIERUNG (Mess-Tooling als Position 1 der Verzeichnis-/Ordnungs-Kette vor target_isa/os/external_utils/Organ) und (ii) die VERANTWORTLICHKEITS-Trennung (Owner F6 26.07.: "Die Mess-Achsen wurden jetzt in den Planer getrennt, die System-Achsen steuern jetzt nur noch Kompilation, System und Scheduling fuer die Basics einer Binary") zueinander - und was folgt EXAKT fuer kSystemAxisOrder (Inhalt, Reihenfolge, was gehoert NICHT hinein), fuer die Stempel-/Suffix-Ordnung (W-13/Lane F) und fuer die Lager-Baum-Kaskaden? Insbesondere: Ist die Mess-Position-1 eine LAGER-/BENENNUNGS-Ordnung (Verzeichnis-Kaskade) waehrend die Steuer-Verantwortung beim Planer liegt (kein Widerspruch, zwei Ebenen)? Wo haengt scheduling (R-B: Unter-Achse von target_isa) in der F6-Formel "Kompilation, System und Scheduling"?\n'

const p1 = FRAGE +
  'DEIN PART: LEDGER-Belege. Lies gezielt in ' + LEDGER + ' die Paragraphen zu Mess/System-Relation, Kette und Ordnung: grep -n nach "§24\\|§27\\|§28\\|§30\\|§37\\|§47\\|§54\\|§56\\|§57\\|§58\\|§61\\|§62\\|§64\\|§66" plus Stichworte "Planer = Mess\\|CEB = System\\|Sortierung\\|Ordnung\\|steuer" - dann die Treffer-Sektionen mit Kontext LESEN (nicht nur greppen).\n' +
  'LIEFERE (ASCII, max 80 Zeilen): jede relevante Ledger-Aussage wortgenau mit LEDGER:Zeile, chronologisch-nach-Paragraph, plus 1-Satz-Einordnung was sie zur Frage beitraegt.'

const p2 = FRAGE +
  'DEIN PART: Owner-Wortlaute. Der Owner hat das "schon 6 mal beantwortet" - finde ALLE Stellen: (1) grep -n "Mess\\|Planer\\|System-Achse\\|steuer\\|Sortierung\\|Ordnung" ' + QDIR + '/verlauf-queued-ergaenzung-*.txt (die 982 getippten Owner-Nachrichten; Treffer mit Kontext lesen, die relevanten VOLL zitieren); (2) die Session-Docs ' + ROOT + '/docs/sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md + 20260726-SESSION-layer-modell-antworten-QA-QF-stempel-doktrin.md vollstaendig; (3) E-05/W4 + die F6-Antwort im Wahrheits-Anker-Doc 20260726-SESSION-wahrheits-anker-voll-abgleich-982-E01-E26.md.\n' +
  'LIEFERE (ASCII, max 100 Zeilen): die chronologische Liste ALLER Owner-Aussagen zur Mess/System-Relation (wortgenau, mit Quelle+Zeile), Alt nach Neu, mit Markierung welche durch spaetere ersetzt wurden.'

const p3 = FRAGE +
  'DEIN PART: Ist-Code. Lies in ' + CE + ': (1) libs/cache_engine/algorithm_profiles/system_axis_registry.xml (Kopf+Achsen-Liste) + die Mess-Registry (ls algorithm_profiles/ nach measurement/mess); (2) include/cache_engine/abi/system_axis_code_versions.hpp (kSystemAxisCodeCount + Liste); (3) builder/experiment_tree/plan_legend.hpp (Legenden-Vertrag: ceb:build [a,b,c] vs tier:build [d,e,f][g,h,i]); (4) builder/experiment_tree/registry_to_axis_levels.hpp (build_system_axis_levels - welche 5); (5) grep -rn "system_axes_version_suffix\\|build_version_suffix" libs/cache_engine/builder/profile_facade/*.cpp | head -5 und die Suffix-Bau-Stelle lesen (W-13-Kontext: +ext+cxx+opt-Ordnung).\n' +
  'LIEFERE (ASCII, max 80 Zeilen): was der Code HEUTE als Ordnung/Trennung lebt (welche Achsen wo, welche Reihenfolgen wo kodiert, wo Mess und System sich beruehren), mit datei:zeile.'

phase('Belege')
const r = await parallel([
  () => agent(p1, { label: 'ledger-belege', phase: 'Belege', model: 'opus', effort: 'high' }),
  () => agent(p2, { label: 'owner-wortlaute', phase: 'Belege', model: 'opus', effort: 'high' }),
  () => agent(p3, { label: 'ist-code', phase: 'Belege', model: 'opus', effort: 'high' }),
])
const [led, own, code] = [r[0] || 'FEHLT', r[1] || 'FEHLT', r[2] || 'FEHLT']

phase('Aufloesung')
const final = await agent(
  FRAGE +
  '\nDU BIST DIE AUFLOESUNG. Drei Beleg-Sammlungen:\n\n=== LEDGER ===\n' + String(led).slice(0, 15000) +
  '\n\n=== OWNER-WORTLAUTE (Alt->Neu) ===\n' + String(own).slice(0, 20000) +
  '\n\n=== IST-CODE ===\n' + String(code).slice(0, 15000) +
  '\n\nREGEL: Neueste Owner-Aussage gewinnt (F6 26.07. ist die neueste: Mess=Planer, System=nur Kompilation/System/Scheduling, neue Ordnung strikt, alles andere veraltet). LIEFERE (ASCII, max 100 Zeilen): (1) DAS AUFGELOESTE REGELWERK in 5-10 numerierten Saetzen (Ordnungs-Ebene vs Steuer-Ebene sauber getrennt, jeder Satz mit Beleg-Referenz), (2) die EXAKTE kSystemAxisOrder-Spezifikation fuer Lane A (Inhalt, Reihenfolge, Ausschluesse, wo scheduling haengt), (3) die Folge fuer W-13/Lane-F-Suffix-Ordnung und die Lager-Baum-Kaskade, (4) NUR falls ein echter unaufloesbarer Widerspruch bleibt: die eine praezise Restfrage - sonst explizit "KEINE RESTFRAGE".',
  { label: 'aufloesung', phase: 'Aufloesung', model: 'opus', effort: 'xhigh' }
)
return { ledger: led, owner: own, code, aufloesung: final }