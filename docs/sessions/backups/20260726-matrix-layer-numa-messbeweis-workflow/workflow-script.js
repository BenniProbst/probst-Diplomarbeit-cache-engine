export const meta = {
  name: 'matrix-layer-numa-messbeweis-planung',
  description: 'ultracode: Comdare-Matrix-Layer-Zuordnung (Owner F2) + NUMA/page_type-Bauplan (golden-Bruch vor Trigger, Owner F5) + Mo-Mess-Beweis-Lauf-Rezept (D-03)',
  phases: [
    { title: 'Planung', detail: '3 Opus-Leser: Matrix-Doku, Achsen-Bauplan, Mess-Rezept' },
  ],
}
const ROOT = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = ROOT + '/Code/external/comdare-cache-engine'
const ANKER = ROOT + '/docs/sessions/20260726-SESSION-wahrheits-anker-voll-abgleich-982-E01-E26.md'

const p1 =
  'OWNER-AUFTRAG (26.07., woertlich): Die Layer-Zuordnung der zwei oberen Diplomarbeit-Schichten "ist die Comdare Matrix Struktur mit Produktfassaden vs Modules, das muss per ultracode geplant werden, weil es gut dokumentiert ist."\n' +
  'Lies VOLLSTAENDIG die Matrix-Doku: ' + ROOT + '/docs/ - suche und lies MATRIX-GRUNDLAGEN*, STANDARDPROZESS*, alles zu Umbrella/Baseline/Produktfassade (grep -rli "produktfassade\\|matrix\\|umbrella\\|baseline" docs/ --include="*.md" | head -15, dann die Treffer). Ergaenzend die Memories /home/comdare/.claude/projects/-home-comdare/memory/{feedback_baseline_system_in_stein_gemeisselt_layering,feedback_standardprozess_research_zu_product_matrix_3d,feedback_umbrella_soll_struktur_trackt_alles_ausser_baseline_zellen}.md und den E-13-Kontext in ' + ANKER + '.\n' +
  'LIEFERE (ASCII, max 100 Zeilen): (a) die dokumentierte Matrix-Struktur praezise (Umbrella/Baseline/Modul/Produktfassade/Instanziierungs-Matrix), (b) den ZUORDNUNGS-PLAN: welche der Diplomarbeit-Schichten (Experiment-Planer, CEB, Tier, Mess-Auswertung, LaTeX-Kette) gehoert in welches Repo/welche Matrix-Zelle (Produktfassade vs Modul), mit Begruendung aus der Doku, (c) was die W2-Aussagen (Layer hat nichts mit Repos zu tun VS Owner: doch, Comdare-Matrix) versoehnt, (d) offene Owner-Fragen.'

const p2 =
  'OWNER-GO (26.07.): "Wir brechen es [das golden] sofort vor dem Trigger, weil es nicht taugt, die Struktur der Achsen hatte nachweisbar regressionen, die zu beheben sind." => E-08 wird STRUKT-R-Scope: SIEBTE System-Achse NUMA/locking ("sofern compile-statisch erkennbar; ansonsten dynamische System-Unter-Achse unter der ISA-Achse") + page_type-Achse ("fuer Cache-Awareness PFLICHT") + Meta-Meta-DEFINITION ("Haupt-Achsen eines statischen Arrays unter einer Manager-Haupt-Achse heissen Meta-Meta-Achsen").\n' +
  'Lies: (1) den E-08/E-09/E-10-Kontext in ' + ANKER + '; (2) Ist-Code-Reste: grep -rn "numa\\|NUMA" ' + CE + '/libs ' + CE + '/_ce-scratch 2>/dev/null | head -20 und grep -rn "page_type" ' + CE + '/libs ' + CE + '/_ce-scratch 2>/dev/null | head -20 (Reste lesen); (3) die ORG-18-Blaupause als Prozedur-Vorbild: ' + ROOT + '/docs/sessions/20260726-SESSION-HANDOVER-6-lagerwelle-komplett-abnahmen-struktr.md + das Achsen-Neuordnungs-Doc 20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md; (4) System-Achsen-Ist: ' + CE + '/libs/cache_engine/algorithm_profiles/system_axis_registry.xml.\n' +
  'LIEFERE (ASCII, max 120 Zeilen): (a) BAUPLAN-SKIZZE fuer beide Achsen nach ORG-18-Muster (Wo einhaengen: System-Realm als 7. Haupt-Achse vs Organ? page_type: Organ T18 oder System? Slots/POD/ABI/CSV/Registry/golden-Folgen je Variante), (b) die Compile-statisch-Erkennbarkeits-Frage konkret (libnuma/Configure-Detection? Was ist auf prod1/prod2 erkennbar?), (c) Konflikt-/Sperrmengen-Analyse gegen Lane A/C/F, (d) Owner-Fragen die VOR dem Bau beantwortet sein muessen. KEINE Implementierung, nur Plan.'

const p3 =
  'FRIST-AUFTRAG (D-03, Mo 27.07.): "Die ersten Messergebnisse werden rechtzeitig auf dem NAS landen ... Prof. Habich reicht es die ersten Mess-CSV eintreffen zu sehen." Plane den KLEINSTEN EHRLICHEN Mess-Beweis-Lauf auf dem frisch gelandeten 18-Slot-Stand (ce dc8e1dc7).\n' +
  'Lies: (1) das GN-11-Bare-Metal-Rezept (grep -rn "GN-11\\|K7b\\|16 echte Mess-Zeilen\\|bare-metal" ' + ROOT + '/docs/sessions/ --include="*.md" -l | head -5, neueste zuerst lesen); (2) das Mess-Profil-Ist: ' + CE + '/libs/cache_engine/algorithm_profiles/thesis_profiles/ (ls + m3v2_smoke oder base_pilot Kopf); (3) NAS-Ziel: E-14/D-04-Kontext in ' + ANKER + ' + grep -rn "Cluster_NFS\\|measure-drop\\|PR4100" ' + ROOT + '/docs/sessions/ --include="*.md" | head -10; (4) die Storage-Doktrin M32 (Messwerte -> git measurement/<ts>/ UND NFS).\n' +
  'LIEFERE (ASCII, max 100 Zeilen): (a) das exakte Lauf-Rezept (Kommandos/CI-Trigger, Profil, 1-Thread-Messung, erwartete CSV-Zeilen), (b) den NAS-Schreibpfad + Preflight-Liste (Mount? Credentials aus Vault noetig? Endpoint-Falle wie mc?), (c) Zeitschaetzung + Risiken, (d) was davon HEUTE abends vs morgen frueh laufen muss, damit Mo die CSV auf dem NAS liegt.'

phase('Planung')
const r = await parallel([
  () => agent(p1, { label: 'matrix-layer', phase: 'Planung', model: 'opus', effort: 'high' }),
  () => agent(p2, { label: 'numa-pagetype-plan', phase: 'Planung', model: 'opus', effort: 'xhigh' }),
  () => agent(p3, { label: 'mess-beweis-rezept', phase: 'Planung', model: 'opus', effort: 'high' }),
])
return { matrix: r[0] || 'FEHLT', numa: r[1] || 'FEHLT', messRezept: r[2] || 'FEHLT' }