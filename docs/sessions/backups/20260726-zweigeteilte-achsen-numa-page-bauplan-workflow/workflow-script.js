export const meta = {
  name: 'zweigeteilte-achsen-lane-a-bauplan',
  description: 'ultracode: Zwei-Stufen-Modell (CEB-RT-Unter unter ISA -> Tier-CT-Haupt) fuer NUMA/page_type belegen + vollstaendiges Dual-Natur-Register + Lane-A-Bauplan mit golden-Verdikt',
  phases: [
    { title: 'Erhebung', detail: '3 Opus-Leser: Freigabe-Mechanik im Ist-Code, Dual-Natur-Faelle, golden-Beruehrung' },
    { title: 'Bauplan', detail: 'xhigh: Lane-A-Bauplan + EIN golden-Verdikt' },
  ],
}
const ROOT = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = ROOT + '/Code/external/comdare-cache-engine'
const LEDGER = ROOT + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'
const KERN =
 'OWNER-KERN (26.07. spaet, bindend, woertlich): "NUMA und page_type muessen in der CEB fuer eine Architektur freigegeben werden, bevor sie tatsaechlich als Tier-Binary gebaut werden, daher sind NUMA und page_type eigentlich doch Unter-Achsen unter der ISA zur Laufzeit der CEB und compile-time statische Haupt-Achsen bei den Tier-Binaries, es gibt mehrere solcher zwei-geteilter Faelle, bitte korrigiere das entsprechend."\n' +
 'Bekannte weitere Dual-Natur-Faelle: Mess-Tooling + load_framework (RT-Unter am Planer, CT-Haupt an der CEB); compiler/opt_level/atomic128 (RT-Unter aus CEB-Sicht, CT am Tier); SIMD/AVX als Meta-Metas unter external_utils.\n' +
 'GESETZE: §24-C stufen-relativ (dyn. Einstellung der Vorstufe = CT-Draht der Folgestufe) · §37 System gibt frei / Organ setzt durch (nur statische System-HAUPT-Achsen geben frei) · §54-T3 binary_id = Organ-only, System-Achsen im build_version-Sidecar · §57/§58 Stempel: CEB=[a,b,c], Tier=[d,e,f]+[g,h,i] zwei Arrays.\n' +
 'ASCII-only, jede Behauptung mit datei:zeile oder LEDGER:Zeile.\n'

const p1 = KERN +
  'DEIN PART: die FREIGABE-MECHANIK im Ist-Code kartieren - wie gibt heute eine System-Haupt-Achse etwas frei, das das Tier dann CT-statisch einkompiliert? Lies in ' + CE + ': (1) libs/cache_engine/measurement/simd_build_gate.hpp + simd_organ_requirement.hpp + simd_organ_sensibility.hpp (das ist der PILOT des Freigabe-Prinzips!); (2) libs/cache_engine/measurement/simd_sub_axis.hpp (Unter-Achse unter welcher Haupt-Achse?); (3) grep -rn "freigabe\\|Freigabe\\|release\\|permit\\|gate" ' + CE + '/libs/cache_engine/measurement/*.hpp | head -20; (4) wie kommt die Freigabe in den Bau? grep -rn "simd\\|march" ' + CE + '/libs/cache_engine/builder/build_orchestrator.hpp | head -10; (5) system_axis_registry.xml: welche Achsen tragen binary_id="never", welche Unter-Achsen gibt es unter target_isa?\n' +
  'LIEFERE (max 90 Zeilen): (a) die Freigabe-Kette Schritt fuer Schritt mit datei:zeile (wer entscheidet, wo wird der CT-Draht gezogen, wo landet der Stempel), (b) ob SIMD schon exakt das Owner-Muster erfuellt (CEB-RT-Unter unter ISA -> Tier-CT) und wo es abweicht, (c) welche Bausteine fuer NUMA/page_type nach demselben Muster NEU gebraucht werden.'

const p2 = KERN +
  'DEIN PART: das DUAL-NATUR-REGISTER vollstaendig machen - finde ALLE zwei-geteilten Faelle (der Owner sagt "es gibt mehrere"). Lies: (1) ' + LEDGER + ' - grep -n "stufen-relativ\\|Vorstufe\\|Folgestufe\\|Dual-Natur\\|zur Laufzeit austauschbar\\|delegiert" + Kontext; (2) die Owner-Wortlaute: grep -n "Unter-Achse\\|Haupt-Achse\\|stufe" ' + ROOT + '/docs/sessions/backups/20260726-session-plaintext-verlauf/verlauf-queued-ergaenzung-*.txt mit Kontext (chronologisch, die Aussagen zur Stufen-Rolle je Achse); (3) ' + ROOT + '/docs/sessions/20260726-SESSION-layer-modell-antworten-QA-QF-stempel-doktrin.md + 20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md.\n' +
  'LIEFERE (max 90 Zeilen): (a) das VOLLSTAENDIGE Dual-Natur-Register als Tabelle (Achse | RT-Unter an welcher Stufe | CT-Haupt an welcher Stufe | Beleg), (b) welche Achsen NICHT dual sind (rein einstufig) und warum, (c) die generische Regel in 3 Saetzen, wie man bei einer NEUEN Achse entscheidet, ob und wie sie dual ist.'

const p3 = KERN +
  'DEIN PART: GOLDEN-BERUEHRUNG der beiden neuen Achsen entscheiden. Zentrale Frage: Wenn NUMA/locking und page_type am TIER CT-statische HAUPT-Achsen sind - landen sie damit in der binary_id (= golden-Neuanker noetig) oder im build_version-Sidecar/System-Stempel (= golden UNBERUEHRT, CRC 0x56F1B721C72DC10E bleibt)?\n' +
  'Lies in ' + CE + ': (1) libs/cache_engine/builder/experiment_tree/axis_path_serialization.hpp (kCompositionAxisNames - was genau bildet die binary_id?); (2) builder/experiment_tree/profile_to_tree.hpp (is_organ_composition_axis - der Organ-only-Guard); (3) libs/cache_engine/builder/profile_facade/source_catalog.hpp (FullSourceCatalog/CatalogAxes/kNewGolden131072Crc64); (4) libs/cache_engine/topics/nodes/ - ist axis_01_page_type in die Komposition verdrahtet oder nicht (topic_nodes_config_set.hpp: StaticAxisVariants_01 vorhanden?), und welche Semantik haben die 6 Varianten (DenseByte/SparsePatricia/BPlus = Knoten-Seitenstrukturen?); (5) wo landet heute die SIMD-Wahl (Sidecar +ext= / build_version) - grep -rn "system_axes_version_suffix\\|\\+ext=" ' + CE + '/libs/cache_engine/builder/profile_facade/profile_run_facade.cpp | head -5.\n' +
  'LIEFERE (max 90 Zeilen): (a) VERDIKT mit Beleg: binary_id-beruehrend JA/NEIN je Achse (NUMA, page_type) unter dem Zwei-Stufen-Modell, (b) falls page_type als Knoten-Seitenstruktur ORGAN-semantisch ist: wie passt das zum Owner-Modell (System gibt frei / Organ setzt durch via Interface) - ist die Freigabe die System-Seite und die 6 Varianten die Organ-Seite?, (c) ob ein golden-Neuanker noetig ist und wenn ja fuer welche Achse allein, (d) welche Stempel-/POD-/ABI-Folgen es gibt (System-Stempel-Array-Wachstum -> AnatomyVersionLines?).'

phase('Erhebung')
const r = await parallel([
  () => agent(p1, { label: 'freigabe-mechanik', phase: 'Erhebung', model: 'opus', effort: 'high' }),
  () => agent(p2, { label: 'dual-natur-register', phase: 'Erhebung', model: 'opus', effort: 'high' }),
  () => agent(p3, { label: 'golden-beruehrung', phase: 'Erhebung', model: 'opus', effort: 'xhigh' }),
])
const [fm, dr, gb] = r.map(x => String(x || 'FEHLT'))

phase('Bauplan')
const plan = await agent(
  KERN + '\nDU BAUST DEN LANE-A-BAUPLAN. Drei Erhebungen:\n\n=== FREIGABE-MECHANIK (SIMD-Pilot) ===\n' + fm.slice(0, 16000) +
  '\n\n=== DUAL-NATUR-REGISTER ===\n' + dr.slice(0, 14000) +
  '\n\n=== GOLDEN-BERUEHRUNG ===\n' + gb.slice(0, 16000) +
  '\n\nWEITERER SCOPE derselben Welle (Owner-Entscheide 26.07.): R-A OS als Komplex-Glied (Unter-Achsen os_version/kernel/build, Update-Zustand IN build gemerged, XML-erweiterbar) · R-B scheduling -> Unter-Achse von target_isa · R-C load_framework -> Meta-Meta (letztes CEB-Glied, ERSTE Meta-Meta, on/off im Namen) · R-D compiler+opt_level+atomic128 als untrennbare Unter-Achsen-GRUPPE der Komplex-Haupt-Achse · R-E/R-F external_utils = KOPF aller Meta-Metas (Rename ext_hw, SIMD/AVX sind Meta-Metas) · kSystemAxisOrder als Single-Source (Kette Mess-Tooling -> target_isa -> operating_system -> external_utils -> Organ) · opt permutiert O0-O3 · Stempel A-II/A-III nach Klammer-Hierarchie Ebene 0-3 · Binaries-Lager-Kaskade System -> ORGAN -> Mess.\n' +
  'LIEFERE einen BAUPLAN (ASCII, max 130 Zeilen): (1) Arbeitspakete A1..An in bindender Reihenfolge, je Paket: Ziel in 1 Satz, betroffene Dateien, Gates/Wachen die gruen bleiben MUESSEN, Sperrmenge; (2) explizit: WO sitzt der EINE golden-Neuanker (oder: keiner noetig - dann begruenden) und welche Pakete sind byte-neutral; (3) welche Pakete parallel laufen koennen (mehrere Impl-Agenten) und welche seriell; (4) Lane F (W-13) Einordnung; (5) die 3-5 Punkte, die der Owner VOR Baubeginn entscheiden muss (nur echte Blocker, alles andere selbst entschieden mit Begruendung).',
  { label: 'lane-a-bauplan', phase: 'Bauplan', model: 'opus', effort: 'xhigh' }
)
return { freigabe: fm, register: dr, golden: gb, bauplan: plan }