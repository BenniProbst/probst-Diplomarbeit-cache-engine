export const meta = {
  name: 'lane-a-vor-planung-final',
  description: 'VOR-Planung (Direktive: Planung ist Quelle der Wahrheit): Bauplan A1-A9 mit AVX512-Korrektur + NUMA/page-Organ-Realitaet integrieren, dann adversarial gegen Ledger/Direktiven pruefen',
  phases: [
    { title: 'Integration', detail: '3 Opus: AVX512-Paket, NUMA/page-Doppel-Seite, Rest-Bauplan A7-A9 + Lane C' },
    { title: 'Adversarial', detail: 'Plan gegen Ledger/Direktiven/TABU pruefen - VOR dem Bau' },
    { title: 'Freigabe', detail: 'Konsolidierter Bauplan v2 + Startsignal-Kriterien' },
  ],
}
const ROOT = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = ROOT + '/Code/external/comdare-cache-engine'
const MEAS = CE + '/libs/cache_engine/include/cache_engine/measurement'
const AUFTRAG = ROOT + '/docs/sessions/20260726-AUFTRAG-lane-a-sys-tax-und-lane-c-hub.md'
const BP = ROOT + '/docs/sessions/backups/20260726-matrix-layer-numa-messbeweis-workflow'
const BASIS =
  'KONTEXT: Der Manager hat eine Lane-A-Welle beauftragt, BEVOR die Planung fertig war (Direktiv-Verstoss, korrigiert: Bau ist gestoppt). Die Planung ist per Owner-Direktive die QUELLE DER WAHRHEIT; der Bau folgt ihr; danach kommt eine adversariale NACH-Pruefung. Jetzt wird die Planung vollstaendig gemacht.\n' +
  'VORHANDENER AUFTRAGS-STAND (enthaelt bekannte FEHLER, siehe unten): ' + AUFTRAG + '\n' +
  'DREI BEFUNDE, die den Auftrag korrigieren:\n' +
  'B-1 AVX512 FEHLT im opt/simd-Paket. Registry ' + MEAS + '/system_axis_registry.xml: sub_axis simd hat DREI Optionen (no_extension, avx2, avx512 mit -mavx512f/-arch:AVX512), prod1_zen5 traegt 13 AVX512-Flags, Host-Praedikat profile_run_entry.hpp:214 kennt __builtin_cpu_supports("avx512f") und der Kommentar :208 sagt "Fused-off-AVX512 (prod2) meldet sich hier korrekt als nicht verfuegbar". Das golden-Profil all_axes_golden.profile.xml hat avx512 als "nicht universell" HERAUSDEFINIERT = stiller Filter, verstoesst gegen §62-A Planer-Universalitaet (Warnung statt Filter) und §33 (>=2 Algorithmen je Achse; simd hat 3, es laufen 2).\n' +
  'B-2 NUMA/page sind HEUTE ORGAN-seitig: axes/alloc/alloc_hw_config.hpp:48-52 AllocHwConfig{numa_node,page}, if-constexpr-HW-Gate :89-93; builder/experiment_tree/profile_to_tree.hpp:81-87 erzeugt alloc_hw.numa_node/alloc_hw.page als STATISCHE Organ-Level -> sie gehen in die binary_id, SOBALD ein Profil sie aktiviert. validate_profile.hpp:206-209/:776 umgeht die Registry (alloc_hw-Sonderzweig). Die neue System-Kante darf keine Doppelung und keinen golden-Bruch erzeugen.\n' +
  'B-3 Die Kante "Unter-Achse unter der ISA" existiert NICHT: simd haengt unter extension_hardware (simd_sub_axis.hpp:38), target_isa traegt GAR KEINE sub_axis (registry :98-101), ISA-Zulassung ist hartkodiert #if defined(__x86_64__)+cpuid und fragt den HOST statt die Haupt-Achse. Zusaetzlich ist der Freigabe-Pilot INERT: simd_build_gate.hpp:185-187 Hooks liefern {}, active_machine_signature() liest die 3 XML-Signaturen nicht, admit_organ_on_machine ohne Aufrufer.\n' +
  'BINDENDE OWNER-KERNE: Dual-Natur (NUMA/page = RT-Unter unter ISA an der CEB, CT-Haupt am Tier; "es gibt mehrere solcher zwei-geteilter Faelle") - System gibt frei/Organ setzt durch (System=Bibliothek, Organ=Initialisierung) - opt permutiert "ueber alle verfuegbaren Stufen, in der Regel O0,O1,O2,O3" - Ofast bleibt aus - std::variant nur CEB, in ALLEN Tier-Typen verboten - Test-Skip nur als Lagerhaltungs-Skip fuer gruen inventarisierte Binaries.\n' +
  'ASCII-only, jede Behauptung mit datei:zeile. Wo die Quellen nichts sagen: das EXPLIZIT sagen, NIE raten.\n'

const p1 = BASIS +
  'DEIN PART: das SIMD/opt-PAKET neu planen (ersetzt A6 des Auftrags).\n' +
  'Lies: ' + MEAS + '/system_axis_registry.xml (sub_axis simd + machine_signatures) · ' + MEAS + '/simd_sub_axis.hpp · ' + MEAS + '/simd_build_gate.hpp + simd_organ_requirement.hpp + simd_organ_sensibility.hpp + simd_feature_flag.hpp + machine_simd_signature.hpp · ' + CE + '/libs/cache_engine/profile_facade/profile_run_entry.hpp:198-230,741-790 · ' + CE + '/libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml (simd/opt-Bloecke + Kommentar) · ' + CE + '/tests/unit/thesis_tiere/experiment_golden.xml.\n' +
  'LIEFERE (max 100 Zeilen): (a) Arbeitspaket "SIMD-VOLL + opt-VOLL": welche Dateien, damit 4 opt x 3 simd = 12 System-Perms GEPLANT werden und der Ausschluss maschinenseitig per Freigabe+WARNUNG faellt (nicht im Profil); (b) welche Wachen/Tests das beruehrt und ob sie byte-neutral bleiben (binary_id vs +ext=/+opt=-Sidecar - literal belegen); (c) wie die WARNUNG aussehen muss (Fehlerklasse, Log-Zeile, CSV-Sichtbarkeit "failed" nie null) damit prod2 die avx512-Perms sichtbar ueberspringt; (d) Bau-Volumen-Rechnung je Maschine; (e) ob AVX10 (es gibt ein AVX10-Feld im Stempel-POD) mitgeplant werden muss oder bewusst spaeter.'

const p2 = BASIS +
  'DEIN PART: die NUMA/page-DOPPEL-SEITE planen (praezisiert A4+A5 des Auftrags) - die schwierigste Naht.\n' +
  'Lies: ' + CE + '/libs/cache_engine/axes/alloc/alloc_hw_config.hpp (ganz) · ' + CE + '/libs/cache_engine/topics/hardware/axis_12_general_hardware_subaxes_hw1_to_hw4.hpp · ' + CE + '/libs/cache_engine/builder/experiment_tree/profile_to_tree.hpp:70-100 · ' + CE + '/libs/cache_engine/builder/profile_facade/validate_profile.hpp:200-215 + :770-780 · ' + MEAS + '/axis_error.hpp (welche Fehlerklassen existieren WIRKLICH) · ' + MEAS + '/system_axis_registry.xml:98-117 (target_isa-Block) · alle Profile in ' + CE + '/libs/cache_engine/algorithm_profiles/thesis_profiles/ auf "alloc_hw" pruefen (grep -l) und in ' + CE + '/tests/unit/thesis_tiere/*.xml.\n' +
  'LIEFERE (max 110 Zeilen): (a) PFLICHT-BEWEIS P-1 literal: aktiviert IRGENDEIN golden-/320er-/Test-Profil alloc_hw-Level? (grep-Ausgabe zeigen) - wenn ja, ist die Naht NICHT byte-neutral und der Plan muss das benennen; (b) das Arbeitspaket fuer die Zwei-Stufen-Naht: CEB-RT-Unter-Achsen unter target_isa (Registry-Kante + Header nach simd_sub_axis-Muster) UND wie die bestehende Organ-Seite (AllocHwConfig/if-constexpr-Gate) daran angeschlossen wird, ohne Doppelung und ohne binary_id-Wachstum; (c) welche Fehlerklasse fuer "hugetlbfs/Kernel nicht konfiguriert" existiert oder NEU gebraucht wird (nicht erfinden - pruefen); (d) die Reihenfolge Bruch-zuerst-dann-Draht mit Gates; (e) Risiken + was der Manager VOR dem Bau entscheiden muss.'

const p3 = BASIS +
  'DEIN PART: den REST-BAUPLAN vervollstaendigen (A7-A9 + Lane C) und die Sperrmengen-Matrix erstellen.\n' +
  'Lies den bereits erstellten Bauplan-Teil im Backup: ' + ROOT + '/docs/sessions/backups/20260726-matrix-layer-numa-messbeweis-workflow/ergebnisse/ (alle Dateien) und ' + ROOT + '/docs/sessions/backups/20260726-strukt-r-planung-workflow/ergebnisse/ (Lane-A/C/F-Bauplan; ACHTUNG teils ueberholt). Ergaenzend: ' + CE + '/libs/cache_engine/include/cache_engine/abi/anatomy_version_stamp.hpp + system_axis_code_versions.hpp · ' + CE + '/libs/cache_engine/builder/profile_facade/profile_run_facade.cpp (Suffix-Bau) · ' + CE + '/tests/unit/CMakeLists.txt (Test-Registrierung, Konflikt-Zone).\n' +
  'LIEFERE (max 110 Zeilen): (a) die Pakete NACH dem CT-Draht: kSystemAxisOrder-Single-Source, Stempel A-II/A-III (System-Array systemisch erweiterbar + Organ-Meta-Meta-Array + SHA512-Overlay), XML-Regen/Roundtrip, XML-DEAKT (active="true|false"), je mit Dateien/Gates/Byte-Folge; (b) Lane C C-1/C-2/C-3/C-5 praezisiert inkl. des Befunds, dass der Freigabe-Pilot inert ist (Hooks leer, Signatur nicht konsumiert) - was davon gehoert in C-3; (c) die SPERRMENGEN-MATRIX: Datei -> welches Paket besitzt sie exklusiv -> welche Pakete koennen echt parallel laufen (2 Agenten) und welche streng seriell; (d) wo genau das EINE Byte-Ereignis sitzt und welche Pakete es mitfahren muessen.'

phase('Integration')
const r = await parallel([
  () => agent(p1, { label: 'simd-opt-voll', phase: 'Integration', model: 'opus', effort: 'high' }),
  () => agent(p2, { label: 'numa-page-doppel', phase: 'Integration', model: 'opus', effort: 'xhigh' }),
  () => agent(p3, { label: 'rest-bauplan-sperrmatrix', phase: 'Integration', model: 'opus', effort: 'high' }),
])
const [simd, numa, rest] = r.map(x => String(x || 'FEHLT'))

phase('Adversarial')
const adv = await agent(
  BASIS + '\nDU BIST DER ADVERSARIALE PRUEFER (VOR dem Bau, nicht danach). Drei Planungs-Teile:\n\n=== SIMD/opt ===\n' + simd.slice(0, 14000) +
  '\n\n=== NUMA/page ===\n' + numa.slice(0, 16000) +
  '\n\n=== REST + SPERRMATRIX ===\n' + rest.slice(0, 14000) +
  '\n\nAUFGABE: Versuche den Plan zu WIDERLEGEN. Pruefe gegen: (1) TABU-Liste (permutation_axes.xml, golden_fullpilot_320, POD-sizeof, ABI-Major, GenusBindingTraits, Registry-mp_list, kV3AxisSchema, conformance-Oracle) - verletzt ein Paket ein TABU ohne GO-Fenster? (2) die Doktrinen: compile-time-only Hot-Path/keine vtable, kein std::variant im Tier, keine Achse optional (Durchreich statt Weglassen), Registry=ANGEBOT/XML=ANZEIGE, System gibt frei/Organ setzt durch, binary_id Organ-only, Messung nie als Nullen, honest-0 vor Phantom; (3) innere Konsistenz: widersprechen sich die drei Teile? Gibt es eine Datei, die zwei Pakete gleichzeitig exklusiv beanspruchen? (4) Vollstaendigkeit: fehlt ein Konsument, eine Wache, ein Test, ein Generator? (5) die Byte-Neutralitaets-Behauptungen: ist jede belegt oder nur behauptet?\n' +
  'LIEFERE (max 90 Zeilen): je Fund: SCHWERE (BLOCKER/WARNUNG/HINWEIS), was genau falsch/fehlend ist, welcher Beleg fehlt, wie zu heilen. Am Ende: Verdikt "PLAN BAUFAEHIG" oder "PLAN NICHT BAUFAEHIG - N Blocker". Sei streng: es ist billiger, hier zu finden als nach dem Bau.',
  { label: 'adversarial', phase: 'Adversarial', model: 'opus', effort: 'xhigh' }
)

phase('Freigabe')
const final = await agent(
  BASIS + '\nDU KONSOLIDIERST DEN BAUPLAN v2 (die Quelle der Wahrheit fuer den Bau).\nPlanungs-Teile:\n=== SIMD/opt ===\n' + simd.slice(0, 12000) +
  '\n=== NUMA/page ===\n' + numa.slice(0, 14000) +
  '\n=== REST + SPERRMATRIX ===\n' + rest.slice(0, 12000) +
  '\n=== ADVERSARIALE PRUEFUNG ===\n' + String(adv).slice(0, 14000) +
  '\n\nLIEFERE ein fertiges BAUPLAN-DOKUMENT (ASCII, max 150 Zeilen, Markdown), das der Manager 1:1 als Auftrag committen kann: (1) Kopf mit Autoritaets-Kette + Stand; (2) die Pakete in bindender Reihenfolge mit Ziel/Dateien/Gates/Byte-Folge/Sperrmenge - Blocker der adversarialen Pruefung EINGEARBEITET (nicht angehaengt); (3) die Sperrmengen-Matrix als Tabelle; (4) das EINE Byte-Ereignis und wer mitfaehrt; (5) Agenten-Zuschnitt (wer baut was, parallel vs seriell); (6) NACH-Pruefungs-Auftrag: welche Konformitaets-Fragen die adversariale NACH-Pruefung nach dem Bau stellen MUSS; (7) offene Owner-Entscheide (nur echte Blocker).',
  { label: 'bauplan-v2', phase: 'Freigabe', model: 'opus', effort: 'xhigh' }
)
return { simd, numa, rest, adversarial: String(adv), bauplanV2: String(final) }