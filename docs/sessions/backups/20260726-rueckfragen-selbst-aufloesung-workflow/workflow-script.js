export const meta = {
  name: 'rueckfragen-selbst-aufloesung',
  description: 'ultracode: 6 offene Klaerungspunkte aus vorhandenen Owner-Definitionen SELBST aufloesen (Ziel: 0 Owner-Rueckfragen)',
  phases: [
    { title: 'Aufloesung', detail: '6 parallele Opus-Aufloeser mit Beleg-Pflicht' },
    { title: 'Verdikt', detail: 'xhigh-Synthese: Entscheid-Liste + echter Restbedarf' },
  ],
}
const ROOT = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = ROOT + '/Code/external/comdare-cache-engine'
const Q = ROOT + '/docs/sessions/backups/20260726-session-plaintext-verlauf'
const LEDGER = ROOT + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'
const ANKER = ROOT + '/docs/sessions/20260726-SESSION-wahrheits-anker-voll-abgleich-982-E01-E26.md'
const REGEL = 'AUFLOESUNGS-REGEL: Neueste Owner-Aussage gewinnt; Ebenen sauber trennen; jede Aussage mit Quelle:Zeile belegen; wenn die Quellen die Frage nicht entscheiden, sage das EXPLIZIT statt zu raten. ASCII-only, max 80 Zeilen.\n'

const pA = REGEL +
  'PUNKT A - TEST-SKIP: Owner nr26 (06.07., jsonl:1623): "die Pipeline sollte lazy cachen auf allen Ebenen ... Wir kompilieren und Testen nur Aenderungen neu" VS neuere Doktrin "GESAMTE Pipeline hart gruen" + Voll-ctest je Welle. Loese auf: Gilt der Test-Skip noch, und auf welcher Ebene? Lies: (1) grep -n "lazy\\|cache\\|skip\\|nur Aenderungen" ' + Q + '/verlauf-queued-ergaenzung-*.txt mit Kontext (chronologisch - gibt es SPAETERE Owner-Aussagen zu Skip/Lazy/hart-gruen?); (2) grep -n "hart gruen\\|allow_failure\\|GN_DECISION\\|dll_is_current" ' + LEDGER + ' + die Ist-CI ' + ROOT + '/.gitlab-ci.yml (Skip-Mechaniken heute); (3) das Wahrheits-Anker-Doc E-26/W6 in ' + ANKER + '. HYPOTHESE zu pruefen: Lazy gilt fuer BAU-Artefakte (Binary-Reuse mit Beweis, GN_DECISION/ccache/Bestandslog), Test-GATES bleiben hart - zwei Ebenen, kein Widerspruch.'

const pB = REGEL +
  'PUNKT B - XML-DEAKTIVIERUNG ACHSE vs BAUSTEIN (Q-1-Nuance): Owner: "Die Achse wird per XML deaktiviert und das muss unterstuetzt sein." Gebaut (ORG-18): Baustein disk_writeback enabled=false via flags-Header, Registry zeigt ihn nicht. Loese auf: Was MUSS die Anwender-XML koennen, damit der Owner-Satz erfuellt ist - und genuegt das Gebaute? Lies: (1) die "keine Achse ist optional"-Doktrin: grep -rn "optional\\|Durchreich\\|NoBuffer\\|NonePrefetch" ' + ROOT + '/docs/architektur/ --include="*.md" | head -8 + Treffer lesen; (2) Registry=ANGEBOT/.pom: grep -n "ANGEBOT\\|pom\\|Resolver" ' + LEDGER + ' (Paragraph 27) + Kontext; (3) Owner-Wortlaute: grep -n "deaktivier\\|abschalt\\|disabled\\|enabled" ' + Q + '/verlauf-queued-ergaenzung-*.txt mit Kontext; (4) Ist: ' + CE + '/libs/cache_engine/axes/persistence_target/ (wie enabled heute faellt). LIEFERE die Definition + Verdikt ob Nachtrag-Arbeitspaket noetig (dann Scope-Skizze), KEINE Owner-Frage.'

const pC = REGEL +
  'PUNKT C - PAGE_TYPE-HEIMAT + NUMA-DETAILS: Owner-GO 26.07.: NUMA/locking als 7. System-Achse "sofern compile-statisch erkennbar, sonst dynamische System-Unter-Achse unter der ISA-Achse"; page_type "fuer Cache-Awareness PFLICHT". Alt-offene Frage G-i: page_type-Heimat (Organ / System / registry-los). Loese auf: (1) grep -n "page_type\\|numa\\|NUMA\\|locking" ' + Q + '/verlauf-queued-ergaenzung-*.txt - ALLE Owner-Aussagen chronologisch mit Kontext; (2) grep -n "page_type\\|NUMA" ' + LEDGER + ' + Kontext (S11-Planung!); (3) Historie: page_type war "Build-Achse/Codegen-Variante derselben Binary" - grep -rn "page_type" ' + ROOT + '/docs/architektur/*.md | head -8 + lesen; (4) Ist: grep -rn "page_type" ' + CE + '/libs | head -8. LIEFERE: Heimat-Verdikt (mit Beleg) + praezisierte Bauplan-Eckpunkte + was compile-statisch erkennbar heisst (Ist prod1: numactl/libnuma? NUR aus Doku, nichts installieren).'

const pD = REGEL +
  'PUNKT D - OPT-STUFE VOLL-BAU-4 (E-15): Owner: "mit flags je hardware Achse richtung O3". Loese auf: Mit welcher Optimierungs-Stufe laufen (a) der Voll-Bau 2^17 und (b) die Mess-/Cache-Line-Beweise? Lies: (1) grep -n "O3\\|opt_level\\|Ofast\\|optimier" ' + Q + '/verlauf-queued-ergaenzung-*.txt mit Kontext; (2) ' + LEDGER + ' Paragraph 61 (Modi: Debug/Messung/Release, Dual-Compile) + 2c.opt-Historie: grep -n "opt_level\\|2c.opt" ' + LEDGER + ' | head -10 + Kontext; (3) Ist: ' + CE + '/libs/cache_engine/measurement/optimization_level_sub_axis.hpp (Werte+Default) + die O3-Begruendung in ' + CE + '/tests/unit/CMakeLists.txt um Zeile 1788; (4) System-Perm-Zellen: welche opt-Werte sind in den 4 System-Perms des Voll-Baus (grep "opt=" in ' + ROOT + '/docs/sessions/20260726*.md + aeltere K7b-Stempel-Belege). LIEFERE: die Stufen-Festlegung je Lauf-Art mit Beleg.'

const pE = REGEL +
  'PUNKT E - LANE-C-BLOCKER-ANALYSE (Owner-Auftrag: "erst untersuchen, ob diese Lane vorher keine Blocker bei A und B hat. Sonst volles GO"): Lane C = external_utils-HUB/Ident (Command-Pattern-Hub, Rename ext_hw->external_utils, R-E/R-F-Materialisierung). Lane A = SYS-TAX (kSystemAxisOrder, OS-Komplex-Achse, R-A..R-D). Lane B = Org18/ORG-18 (GELANDET, dc8e1dc7). Loese auf: (1) Lies den Lane-C-Bauplan: ' + ROOT + '/docs/sessions/backups/20260726-strukt-r-planung-workflow/ergebnisse/ (ls, Bauplan-Datei lesen, Lane-C-Abschnitt); (2) Datei-Berührungsflaechen: grep -rln "extension_hardware\\|ExtensionHardware\\|ext_hw" ' + CE + '/libs ' + CE + '/tools ' + CE + '/tests/unit | head -30 - welche davon fasst Lane A auch an (system_axis_registry.xml, system_axis_code_versions.hpp, validate_profile, Registry-Gen-Tools)?; (3) logische Abhaengigkeiten: braucht der Hub die neue kSystemAxisOrder oder die OS-Komplex-Achse als Vorleistung? LIEFERE: Blocker-Matrix (Datei-Ueberlapp + Logik-Abhaengigkeit) + Verdikt: Lane C parallel zu A moeglich (mit Sperrmengen) ODER seriell nach A - mit Begruendung.'

const pF = REGEL +
  'PUNKT F - VERIFIKATION DER F5-LESART: Der Manager las die Owner-Antwort "Wir brechen es sofort vor dem Trigger, weil es nicht taugt, die Struktur der Achsen hatte nachweisbar regressionen" als golden-Bruch-GO (NUMA+page_type VOR Voll-Bau-4) - NICHT als Antwort auf die Test-Skip-Frage. Pruefe die Lesart gegen die Quellen: (1) grep -n "golden\\|brechen\\|Bruch\\|Trigger" ' + Q + '/verlauf-queued-ergaenzung-*.txt - wie benutzt der Owner das Verb "brechen" historisch (golden-Kontext oder Prozess-Kontext)?; (2) gibt es Owner-Aussagen zum ZEITPUNKT von NUMA/page_type (vor/nach Trigger)?; (3) das D-01-KERN-Zitat ("Regressionen muessen vor dem voll Build fest behoben und eingebaut sein") in ' + ROOT + '/.claude-Erinnerung ist nicht lesbar - nimm es aus ' + ANKER + '. LIEFERE: Verdikt BESTAETIGT/ZWEIFELHAFT mit Belegen; bei ZWEIFELHAFT die praezise Formulierung der einen noetigen Owner-Rueckfrage.'

phase('Aufloesung')
const r = await parallel([
  () => agent(pA, { label: 'A-test-skip', phase: 'Aufloesung', model: 'opus', effort: 'high' }),
  () => agent(pB, { label: 'B-xml-deakt', phase: 'Aufloesung', model: 'opus', effort: 'high' }),
  () => agent(pC, { label: 'C-pagetype-numa', phase: 'Aufloesung', model: 'opus', effort: 'xhigh' }),
  () => agent(pD, { label: 'D-opt-stufe', phase: 'Aufloesung', model: 'opus', effort: 'high' }),
  () => agent(pE, { label: 'E-lane-c-blocker', phase: 'Aufloesung', model: 'opus', effort: 'high' }),
  () => agent(pF, { label: 'F-f5-lesart', phase: 'Aufloesung', model: 'opus', effort: 'high' }),
])
const names = ['A-TestSkip','B-XmlDeakt','C-PageTypeNuma','D-OptStufe','E-LaneCBlocker','F-F5Lesart']
let bundle = ''
for (let i = 0; i < 6; i++) bundle += '\n\n=== ' + names[i] + ' ===\n' + String(r[i] || 'FEHLT').slice(0, 12000)

phase('Verdikt')
const verdikt = await agent(
  'Du bist das Schluss-Verdikt einer Selbst-Aufloesungs-Runde (Owner: "loese es selbst auf, wir haben diese Fragen schon 6 mal beantwortet"). Sechs Aufloeser-Reports:' + bundle +
  '\n\nLIEFERE (ASCII, max 80 Zeilen): (1) je Punkt A-F den ENTSCHEID in 1-3 Saetzen mit dem staerksten Beleg, (2) welche Entscheide SOFORT in Lane-A/C-Beauftragung, Trigger-Rezept oder Board einfliessen, (3) die ehrliche Rest-Liste: Punkte, die die Quellen NICHT entscheiden konnten (Ziel: leer; wenn nicht leer, je EINE praezise formulierte Owner-Frage), (4) Selbstcheck-Zeile.',
  { label: 'verdikt', phase: 'Verdikt', model: 'opus', effort: 'xhigh' }
)
return { A: r[0], B: r[1], C: r[2], D: r[3], E: r[4], F: r[5], verdikt }