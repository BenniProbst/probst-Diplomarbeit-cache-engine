export const meta = {
  name: 'bauplan-v3-adversarial-nachcheck',
  description: 'Bauplan V3: adversariale NACH-Verifikation der GEHEILTEN v2 (nie selbst geprueft) + LaneC-Funde (BLOCKER-1-Praezisierung, O-6 disjunkte Flag-Kanaele) einarbeiten, Verdikt baufaehig',
  phases: [
    { title: 'Reverify', detail: 'adversariale Pruefung der geheilten v2 gegen TABU/Doktrin/Konsistenz/Byte' },
    { title: 'V3-Delta', detail: 'Verdikt + Delta v2->v3 (O-6 Kanal-Merge, Q-11-Wache, Restblocker)' },
  ],
}
const DOC = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260726-BAUPLAN-V2-lane-a-sys-tax-lane-c-hub-ADVERSARIAL.md'
const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const LANEC =
 'LANE-C-FUNDE (26.07., NACH v2-Synthese; einzuarbeiten):\n' +
 'F1 BLOCKER-1-Praezisierung: die SIMD-Achse ist NICHT inert - sie hat einen LEBENDEN Flag-Kanal ' +
 '(permutation_codegen_tool.cpp:43-45 simd_flags() -> avx512={/arch:AVX512,-mavx512f}; :477-483 emittiert target_compile_options je Perm; cmake/isa_features.cmake:139-153). INERT ist NUR das Section-37-Freigabe-Gate (simd_build_gate.hpp).\n' +
 'F2 (der Kern-Fund, NEU): die zwei Flag-Kanaele sind DISJUNKT. Gate-Kanal auf prod1/filter/Avx512 emittiert {-mgfni,-mavx512bitalg,-mavx512vpopcntdq}; Codegen-Kanal simd_flags("avx512") emittiert {-mavx512f}. Null Ueberschneidung; die Gate-Menge enthaelt die Baseline -mavx512f NICHT. Eine Scharfschaltung OHNE vorherige ZUSAMMENFUEHRUNG der beiden Kanaele erzeugt Code, den niemand entworfen hat.\n' +
 'F3 Das Gate ist DREIFACH inert: Schalter A (dominant, build_orchestrator.hpp:457-459 betritt Block nur bei !required.empty(); alle 9 Organ-Klassen kRequiredNone, static_assert :88) / A prime (pruef_dock:109 leeres required -> NotApplicable) / B (active_machine_signature()=={}, :187). Stub B allein fuellen = No-Op.\n' +
 'F4 C-3-Byte-Neutralitaet haengt NICHT an der Gate-Inertheit, sondern daran, dass der Hub NULL Konsumenten hat (Registry-XML sha256 3-Wege-identisch, Gift-Header-Beweis). Q-11-Wache umbenannt "NurDasFreigabeGateIstInertNichtDieSimdAchse", nagelt 3 Dinge getrennt fest.\n' +
 'F5 NEU O-6: Kanal-Zusammenfuehrung (Gate-Maximum vs Codegen-Einzelflag) = eigenes benanntes Paket VOR jeder Scharfschaltung; beruehrt permutation_codegen_tool.cpp + Fassade; Vorbedingung von Q-11, nicht Detail davon.\n'

const p1 =
  'Du bist der ADVERSARIALE NACH-PRUEFER von Bauplan V2 (die Direktive verlangt VOR- UND NACH-Pruefung; die GEHEILTE v2 wurde nie selbst adversarial geprueft - das ist der Grund fuer diese V3-Runde).\n' +
  'Lies das committete Bauplan-Dokument VOLLSTAENDIG: ' + DOC + '\n' + LANEC + '\n' +
  'ce-Wurzel = ' + CE + ' (Belege gegen HEAD abef03ce). ASCII-only, jede Behauptung mit datei:zeile.\n' +
  'AUFGABE: Versuche die GEHEILTE v2 zu widerlegen. Pruefe: (1) TABU (permutation_axes.xml, golden_fullpilot_320, POD-sizeof, ABI-Major, GenusBindingTraits, Registry-mp_list, kV3AxisSchema, conformance-Oracle, kNewGolden131072Crc64) - beruehrt ein Paket eines ohne GO-Fenster? (2) Doktrin (compile-time-only Hot-Path, kein std::variant im Tier, keine Achse optional, Registry=ANGEBOT, System-gibt-frei/Organ-setzt-durch, binary_id Organ-only, Messung nie Nullen, §62-A Warnung-statt-Filter, §33 >=2 Algorithmen). (3) Hat die HEILUNG der 5 Blocker NEUE Fehler eingefuehrt? Pruefe jede "eingearbeitet"-Behauptung. (4) Sind LaneCs F1-F5 im Plan korrekt reflektiert oder widersprechen sie ihm (v2 sagt "Freigabe-Pilot inert" - ist das nach F1-F3 noch haltbar)? (5) Byte-Neutralitaets-Behauptungen je Paket: belegt oder nur behauptet? (6) Sperrmengen-Matrix: beansprucht eine Datei zwei exklusive Besitzer? Ist die Reihenfolge kreisfrei?\n' +
  'LIEFERE (max 90 Zeilen): je Fund SCHWERE (BLOCKER/WARNUNG/HINWEIS) + was falsch/fehlend + Heilung. Am Ende VERDIKT: "V2 BAUFAEHIG (V3=v2+Delta)" oder "NICHT BAUFAEHIG - N neue Blocker".'

const p2 =
  'Du konsolidierst BAUPLAN V3 aus der geheilten v2 + der adversarialen NACH-Pruefung + LaneCs Funden.\n' + LANEC +
  '\nADVERSARIALE NACH-PRUEFUNG:\n{{ADV}}\n' +
  'LIEFERE (ASCII, max 80 Zeilen) das DELTA v2->v3 (nur was sich AENDERT, damit ich es additiv an das committete v2-Doc anhaenge): (1) korrigierte/neue Pakete (insbesondere O-6 Kanal-Merge als eigenes Paket mit Dateien/Gates/Reihenfolge; die "Freigabe-Pilot inert"-Formulierung auf F1-F3 korrigieren; C-3a-Byte-Begruendung auf "Hub hat null Konsumenten" umstellen); (2) Sperrmengen-Matrix-Aenderungen (permutation_codegen_tool.cpp neu als Besitzer von O-6); (3) welche der 5 alten Blocker jetzt WIRKLICH geheilt sind (je 1 Beleg); (4) FINAL-VERDIKT: PLAN BAUFAEHIG (welche Pakete duerfen SOFORT starten - nur byte-neutrale P0/Lane-C) oder weitere Heil-Runde noetig; (5) offene Owner-Entscheide O-1/O-2/O-3/O-6 als Liste.'

phase('Reverify')
const adv = await agent(p1, { label: 'adversarial-v3', phase: 'Reverify', model: 'opus', effort: 'xhigh' })

phase('V3-Delta')
const delta = await agent(p2.replace('{{ADV}}', String(adv || 'FEHLT').slice(0, 16000)),
  { label: 'v3-delta', phase: 'V3-Delta', model: 'opus', effort: 'xhigh' })

return { adversarial: String(adv), v3delta: String(delta) }