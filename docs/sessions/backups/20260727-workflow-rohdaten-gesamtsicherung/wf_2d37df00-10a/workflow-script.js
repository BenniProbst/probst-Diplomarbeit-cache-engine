export const meta = {
  name: 'verify-registry-generator-facts',
  description: 'Pre-GO Codebase-Verifikation für den Registry/Experiment-Bau: (1) alle Wrapper::name() über die 19/26 Achsen + Kollisions-/serialize-Konsistenz, (2) FQ-Typ+Header der 4+1 prt-art-Slots, (3) M-CE-11/12/28 Studien-Profil-workloads + Dataset-Doppelquelle re-verifizieren',
  phases: [
    { title: 'Verifikation', detail: 'Achsen-name()-Enumeration · prt-art-Slot-Typen · Studien-Profil-Re-Verify parallel' },
    { title: 'Synthese', detail: 'verifizierte Fakten für Generator/Parser + Blocker-Verdikt' },
  ],
}

const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'
const PRT = SUPER + '/Code/external/comdare-prt-art'

const CTX = `
KONTEXT: Pre-GO-Verifikation für den erweiterten XML-Registry/Experiment-Bau (Design-Backup ${SUPER}/docs/sessions/backups/20260713-design-zwei-registry-experiment-strategy/wf-RESULT-raw.json). ce-Registry wird per compile-time-Reflektion aus den AllX=mp_list generiert; der Registry-baustein-name MUSS = Wrapper::name() = der serialize_composition_path-Schlüssel sein. Rein LESEND. TABU (permutation_axes.xml/golden_320) unberührt. honest-100%; belege datei:zeile.
`

phase('Verifikation')

const verif = await parallel([
  // V1 — alle Wrapper::name() über die 19/26 Achsen
  () => agent(
`ULTRACODE-Codebase-Enumeration, belege datei:zeile. Enumeriere ALLE Baustein-Namen (Wrapper::name()) über die 19/26 Achsen der cache-engine.
- Dach: ${CE}/libs/cache_engine/builder/experiment_tree/registry_to_axis_levels.hpp (:47-111, die Achsen-Reflektion) + axis_path_serialization.hpp (:30-34 kCompositionAxisNames, :47-60 serialize_composition_path).
- Je Achse die AllX=mp_list-Registry (z.B. axis_01..axis_16 + topics/queuing q1/q2 + node/page). Liste je Achse: alle Wrapper + deren name()-String.
- KRITISCH: (a) sind die name()-Strings innerhalb einer Achse kollisionsfrei? (b) stimmen sie BYTE-GENAU mit dem überein, was serialize_composition_path emittiert (der Schlüssel, den die Experiment-XML referenzieren wird)? (c) gibt es Achsen ohne saubere name()-Strings (opake Token)?
${CTX}
Liefere: je Achse die vollständige name()-Liste (datei:zeile) + Kollisions-/serialize-Konsistenz-Verdikt (Blocker für INC-A/C ja/nein).`,
    { label: 'V1:achsen-names', phase: 'Verifikation' }),

  // V2 — prt-art-Slot-Typen + Header
  () => agent(
`ULTRACODE-Codebase-Enumeration, belege datei:zeile. Ermittle FQ-Typ + Header je prt-art-Slot (Grundlage für die prt-art-Registry-Generierung + Fork R-B).
- Die 4 repo-Slots: ${PRT}/prt_art/include/prt_art/slots/axis_{01_page_type,07_prefetch,11_telemetry,14_value_handle}_*_slot.hpp — je Slot: PrueflingVariants=mp_list<Wrapper>, der Wrapper-FQ-Typ, dessen Header, name(), genus.
- Der 1 golden-verdrahtete ce-seitige Slot: ${CE}/libs/cache_engine/compositions/prt_art_merge_reference.hpp:42 (PrtArtPathCompressionSlot) + prt_art_reference.hpp (:56/:88-89 COMDARE_DEFINE_COMPOSITION_LOCATION).
- KRITISCH (Fork R-B): tragen die per-Organ-Wrapper heute cpp_type_name/header_include (für Einzel-Organ-Codegen), oder nur name()/family_name()/flag_suffix()? Was fehlt für die Registry-Generierung?
${CTX}
Liefere: je Slot {FQ-Typ, Header, name(), genus, golden_wired} + was für die per-name-Codegen-Instanziierung fehlt (Blocker für INC-B).`,
    { label: 'V2:prtart-slots', phase: 'Verifikation' }),

  // V3 — M-CE-11/12/28 + Dataset-Doppelquelle
  () => agent(
`ULTRACODE-Re-Verifikation, belege datei:zeile. Prüfe gegen den IST-Stand (nicht Ledger-Behauptung):
- M-CE-11/12/28: Studien-Profil-workloads — ${CE}/libs/**/thesis_profiles/*.profile.xml (ff2_node_width_study.profile.xml:48 u.a.) — tragen sie noch Legacy <workloads> A B C D E F statt ycsb_a..f (→ E4 exit 4)? Fängt validate_profile.hpp das? §0-V4 G1 (Ledger:83) behauptet gefixt — stimmt das am Code?
- GO-5-Fork-2 Dataset-Doppelquelle: ${CE}/libs/**/builder/example_configs/test_data_sets.xml (existiert? git-tracked? von wem geparst?) vs. der <datasets>-Block in thesis_profiles — echte Doppelquelle? Wie single-source konsolidieren (ohne Messdaten/Doku zu löschen)?
- M-CE-10 (sota_catalog.hpp:159): Stufe2_PrueflingReplace ignoriert lebewesen → 7× identische binary_id. Bestätige den Ist-Bug (der mit F/G zu fixen ist).
${CTX}
Liefere: Ist-Verdikt je Punkt (gefixt/offen, datei:zeile) + präziser Fix-Bedarf für den Experiment-XML-Bau.`,
    { label: 'V3:studien-profil-reverify', phase: 'Verifikation' }),
])

const [v1, v2, v3] = verif.map(r => r || '(kein Ergebnis)')

phase('Synthese')

const facts = await agent(
`Du bist der Architekt. honest-100%. Konsolidiere die 3 Verifikations-Berichte zu den harten Fakten für den Registry/Experiment-Bau.

=== V1 Achsen-name() ===
${v1}
=== V2 prt-art-Slots ===
${v2}
=== V3 Studien-Profil-Re-Verify ===
${v3}

Liefere:
1. **BLOCKER-VERDIKT** je Pre-GO-Punkt: name()-Kollision/serialize-Konsistenz (INC-A/C), prt-art-Slot-Typen+Location-Lücke (INC-B), M-CE-11/12/28+Dataset-Doppelquelle+M-CE-10 (INC-F/G) — jeweils GRÜN (baubar) / GELB (mit Zusatz-Fix baubar) / ROT (blockiert).
2. **KONKRETE FAKTEN für den Generator**: die Achsen-name()-Struktur, die prt-art-Slot-{Typ,Header}-Tabelle, was für Fork R-B fehlt.
3. **ZUSATZ-FIXE**, die mit dem Bau einhergehen müssen (M-CE-10 bei R-C(i); Studien-Profil-workloads; Dataset-single-source).
Markiere Unbelegtes. Konkret genug, dass nach User-Fork-GO INC-A..E direkt baubar sind.`,
  { label: 'synthese:fakten', phase: 'Synthese' })

return { facts, verif: { v1, v2, v3 } }
