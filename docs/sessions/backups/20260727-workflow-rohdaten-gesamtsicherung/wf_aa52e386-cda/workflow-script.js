export const meta = {
  name: 'bauplan-v3-fable-xhigh-gruendlich',
  description: 'Bauplan V3 GRUENDLICH mit Fable-5-xhigh: jeden geheilten Blocker GEGEN IST-CODE re-verifizieren + LaneC-Funde + adversarial + Verdikt baufaehig',
  phases: [
    { title: 'Re-Verify', detail: '4 Fable-xhigh: Blocker 1+O6, Blocker 2+3, Blocker 4+5, adversariale Gegenpruefung' },
    { title: 'V3', detail: 'Fable-xhigh Synthese: Verdikt + V3-Delta + startbare Pakete' },
  ],
}
const ROOT = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = ROOT + '/Code/external/comdare-cache-engine'
const DOC = ROOT + '/docs/sessions/20260726-BAUPLAN-V2-lane-a-sys-tax-lane-c-hub-ADVERSARIAL.md'
const BASIS =
 'ROLLE: Du bist Fable-5-xhigh-Verifikator im Team eines CTO/Managers (Diplomarbeit Cache-Engine). Direktive: NIE raten, JEDE Behauptung gegen den IST-CODE belegen (datei:zeile an ce-HEAD abef03ce), ASCII-only. Das committete Bauplan-Dokument (die GEHEILTE v2, die nie selbst adversarial geprueft wurde): ' + DOC + ' - VOLLSTAENDIG lesen.\n' +
 'ce-Wurzel = ' + CE + '. Owner-KERNE (Gesetz): 3 Achsen-Typen (Mess->Planer, System->CEB, Organ->Tier binary_id-only); System-Haupt-Achsen = target_isa/operating_system/external_utils (external_utils=HUB der Meta-Metas, load_framework=ERSTE Meta-Meta NICHT 4. Haupt-Achse); compiler=Unter-Gruppe, scheduling=Unter von target_isa; Dual-Natur NUMA/page (RT-Unter unter ISA an CEB + CT-Haupt am Tier, golden-neutral); opt O0-O3 x simd{no_extension,avx2,avx512}=12 Perms (avx512 nur wo Maschine freigibt, sonst Skip+WARNUNG §62-A; Ofast aus); std::variant nur CEB nie Tier; Registry=ANGEBOT.\n' +
 'LANE-C-FUNDE (bindend einzuarbeiten): (F1) SIMD-Achse ist NICHT inert - lebender Codegen-Flag-Kanal (permutation_codegen_tool.cpp:43-45 simd_flags avx512->{/arch:AVX512,-mavx512f}; :477-483; cmake/isa_features.cmake:139-153); inert ist NUR das Section-37-Freigabe-Gate (simd_build_gate.hpp). (F2/O-6) die zwei Kanaele sind DISJUNKT: Gate prod1/filter/Avx512 -> {-mgfni,-mavx512bitalg,-mavx512vpopcntdq}, Codegen -> {-mavx512f}, null Ueberschneidung, Gate ohne Baseline -> Kanal-MERGE ist Vorbedingung jeder Scharfschaltung. (F3) Gate dreifach inert: Schalter A (build_orchestrator.hpp:457-459 nur bei !required.empty; 9 Organ kRequiredNone static_assert :88) / A prime (pruef_dock:109) / B (active_machine_signature()=={} :187); Stub B allein = No-Op. (F4) C-3-Byte-Neutralitaet haengt an "Hub hat null Konsumenten" (sha256-belegt), NICHT an Gate-Inertheit.\n'

const p1 = BASIS +
 'DEIN FOKUS: BLOCKER-1 + O-6 (SIMD-Freigabe/Flag-Kanaele). Verifiziere GEGEN CODE: (a) stimmen die zwei disjunkten Flag-Mengen (F2)? Lies permutation_codegen_tool.cpp (simd_flags + Emission), simd_build_gate.hpp (das Gate-Maximum + pruef_dock), simd_organ_sensibility.hpp (kSensibilityFilterFlags), machine_simd_signature.hpp (die 3 Signaturen). (b) Ist die v2-Formulierung "Freigabe-Pilot inert" nach F1-F3 haltbar oder muss sie praezisiert werden? (c) Ist O-6 (Kanal-Merge) im v2-Doc als Paket vorhanden oder FEHLT es? (d) Ist die A6-Byte-Neutralitaet (opt/simd nur Suffix/Sidecar, binary_id="never") gegen den Code korrekt? LIEFERE max 70 Zeilen: bestaetigte/widerlegte Behauptungen + was in V3 rein muss.'

const p2 = BASIS +
 'DEIN FOKUS: BLOCKER-2 (Baum-Grundierung/A1) + BLOCKER-3 (5-vs-4 Haupt-Achsen). Verifiziere GEGEN CODE: (a) git status ce - liegen die 4 A1-Dateien (axis.hpp, system_axis_order.hpp, ceb_sub_axis.hpp, meta_meta_identity.hpp) so vor wie das v2-P0 behauptet? (b) system_axis_order.hpp: welche Ordnung/Anzahl steht drin (die A1-Kommentarzeilen 17-20 tragen den Opus-Fehler "VIER Haupt-Achsen inkl load_framework")? system_axis_code_versions.hpp:28 kCount? (c) KERN-Frage: muss load_framework aus kSystemAxisOrder/kSystemAxisCodeVersions RAUS (weil Meta-Meta), und was zieht das nach (Stempel, XML, Suffix)? (d) ceb_sub_axis.hpp - fehlt <cstddef> (LaneC-Befund)? LIEFERE max 70 Zeilen: der korrekte End-Zustand der System-Haupt-Achsen-Liste + die A1-Nachzug-Auflagen + was A3 byte-tragend macht.'

const p3 = BASIS +
 'DEIN FOKUS: BLOCKER-4 (NUMA/page ohne XSD/Parser) + BLOCKER-5 (page_topology-Kollision). Verifiziere GEGEN CODE: (a) alloc_hw_config.hpp (AllocHwConfig, page/numa-Werte, Defaults), profile_to_tree.hpp:70-100 (alloc_hw als Organ-Level - geht es in die binary_id?), grep alloc_hw ueber alle thesis_profiles/*.xml + tests/unit/thesis_tiere/*.xml (P-1: aktiviert IRGENDEIN golden/320-Profil alloc_hw?). (b) target_isa in system_axis_registry.xml (0 sub_axes?) + experiment_schema.xsd target_isa-Block (erlaubt es Unter-Elemente?) + xml_config_parser (liest es target_isa-Unterelemente?). (c) BLOCKER-5: registry_to_axis_levels.hpp:120 (page_type als System-Achse?) + driver_build_variant_signature.hpp:41/47 (find ";page_type[") - kollidiert der neue Name page_topology? (d) Fehlerklasse hugetlbfs: existiert eine passende in axis_error.hpp oder muss additiv? LIEFERE max 80 Zeilen: byte-Neutralitaets-Verdikt der NUMA-Naht + XSD/Parser-Notwendigkeit + Namens-Entscheidung (nicht page_topology falls Kollision).'

const p4 = BASIS +
 'DEIN FOKUS: ADVERSARIALE GEGENPRUEFUNG des GESAMTEN v2-Docs (versuche es zu widerlegen). (a) TABU: beruehrt ein Paket permutation_axes.xml, golden_fullpilot_320, POD-sizeof, ABI-Major, GenusBindingTraits, Registry-mp_list, kV3AxisSchema, conformance-Oracle, kNewGolden131072Crc64 - ohne GO-Fenster? (b) Hat die HEILUNG der 5 Blocker in v2 NEUE Fehler oder Widersprueche eingefuehrt? Pruefe jede "eingearbeitet"-Behauptung. (c) Sperrmengen-Matrix: beansprucht eine Datei zwei exklusive Besitzer? Ist die Paket-Reihenfolge kreisfrei? (d) Das "EINE Byte-Ereignis" (Lane F): ist die MUSS-MITFAHREN-Liste vollstaendig (fehlt ein Stempel-/Suffix-/Cache-Key-Konsument)? (e) Widersprechen die drei Doktrinen-Ebenen (Owner-KERN vs Ledger-§ vs Ist-Code) an irgendeiner Naht? LIEFERE max 80 Zeilen: je Fund SCHWERE + Heilung.'

phase('Re-Verify')
const r = await parallel([
  () => agent(p1, { label: 'blocker1-o6', phase: 'Re-Verify', model: 'fable', effort: 'xhigh' }),
  () => agent(p2, { label: 'blocker2-3-achsen', phase: 'Re-Verify', model: 'fable', effort: 'xhigh' }),
  () => agent(p3, { label: 'blocker4-5-numa-page', phase: 'Re-Verify', model: 'fable', effort: 'xhigh' }),
  () => agent(p4, { label: 'adversarial', phase: 'Re-Verify', model: 'fable', effort: 'xhigh' }),
])
const [b1, b2, b3, adv] = r.map(x => String(x || 'FEHLT'))

phase('V3')
const v3 = await agent(
  BASIS + '\nDU KONSOLIDIERST BAUPLAN V3 aus vier Fable-xhigh-Re-Verifikationen der geheilten v2:\n' +
  '\n=== BLOCKER-1 + O-6 ===\n' + b1.slice(0, 12000) +
  '\n=== BLOCKER-2/3 (Achsen) ===\n' + b2.slice(0, 12000) +
  '\n=== BLOCKER-4/5 (NUMA/page) ===\n' + b3.slice(0, 12000) +
  '\n=== ADVERSARIAL ===\n' + adv.slice(0, 12000) +
  '\nLIEFERE ein DELTA-DOKUMENT v2->v3 (ASCII, max 100 Zeilen, das ich additiv an das v2-Doc anhaenge): (1) je geheiltem Blocker: WIRKLICH geheilt (Beleg) oder Rest offen; (2) NEUE/korrigierte Pakete (O-6 Kanal-Merge als eigenes Paket; "Freigabe-Pilot inert"->F1-F3 praezisiert; load_framework RAUS aus kSystemAxisOrder; page_topology-Namenskonflikt geloest); (3) Sperrmengen-Matrix-Aenderungen; (4) FINAL-VERDIKT: PLAN BAUFAEHIG - welche Pakete duerfen SOFORT starten (nur byte-neutrale: P0 A1-Nachzug + Lane C C-1/C-2/C-5) und welche bleiben im EINEN Byte-Fenster; ODER weitere Heil-Runde noetig mit N Blockern; (5) offene Owner-Entscheide O-1/O-2/O-3/O-6.',
  { label: 'v3-synthese', phase: 'V3', model: 'fable', effort: 'xhigh' })

return { blocker1_o6: b1, blocker2_3: b2, blocker4_5: b3, adversarial: adv, v3delta: String(v3) }