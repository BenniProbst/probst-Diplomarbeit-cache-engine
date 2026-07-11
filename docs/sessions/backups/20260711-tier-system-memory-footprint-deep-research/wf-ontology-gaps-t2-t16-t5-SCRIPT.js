export const meta = {
  name: 'ontology-gaps-t2-t16-t5',
  description: 'Praezise in-pattern Edits fuer die 3 nicht-blockierenden Achsen-Ontologie-Luecken T2(mapping)/T16(filter)/T5(memory_layout), golden/ABI/TABU-neutral',
  phases: [
    { title: 'Prescribe' },
    { title: 'Refute' },
  ],
}

const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'

// HARTE gemeinsame Constraints, an JEDEN Agenten weitergereicht.
const TABU = `HARTE CONSTRAINTS (Diplomarbeit, nicht verhandelbar):
- TABU unberuehrt: permutation_axes.xml, golden_fullpilot_320_binary_ids.txt, POD sizeof==1416, conformance-Oracle, GenusBindingTraits, ABI-MAJOR==4 (kein Bump).
- Gate-1-Zaehlinvariante: binary_count()==∏ mp_size(Enabled_i)==137.594.142.720.000. Das HINZUFUEGEN eines Registry-WERTES zu einer Kompositions-Achse AENDERT dieses Produkt UND ggf. golden-320 → TABU-Bruch. golden-320 = T0(search_algo)×T4(node_type)×T5(memory_layout)×T7(prefetch) = 4×4×5×4. Ein neuer memory_layout- oder mapping-WERT bricht die golden-320-Kardinalitaet bzw. Gate-1.
- Metaprogrammierung: compile-time only im Hot-Path (Templates/if constexpr/Concepts/CRTP), kein Runtime-Switch/vtable im Hot-Path. Nur benannte Lehrbuch-Design-Patterns (GoF/CRTP/Registry/Strategy/Observer), keine musterlose Konstrukte.
- Nur benannte, zitierfaehige Patterns; kein Neubau — "surface-not-build": Property-/Statistik-Flaechen im BESTEHENDEN Observer-/Registry-/AxisBase-Muster ergaenzen.
- PRINZIP: sauberste + wartbarste Loesung, nie die einfachste. Wo die "ziel-treue" Option (neuer Achsenwert) die golden/Gate-1-TABU BRICHT, ist die EHRLICHE, korrekte Loesung die dokumentierte Scope-Limitation (Achse als engere Groesse deklarieren) statt eines TABU-Bruchs. Sag das explizit.
- Jeder Edit muss ABI-neutral sein (kein POD-Layout-Change der eingefrorenen Mess-PODs; eine filterlokale Statistik ist nur ABI-neutral wenn sie NICHT teil des eingefrorenen 1416-POD ist — pruefe das).`

const EDIT_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['axis', 'chosen_option', 'is_golden_abi_neutral', 'edits', 'rationale', 'verification'],
  properties: {
    axis: { type: 'string' },
    chosen_option: { type: 'string', description: 'z.B. "T5(b) tote stride_pattern_tag-Deklaration entfernen" oder "T2 Scope-Limitation dokumentieren"' },
    is_golden_abi_neutral: { type: 'boolean', description: 'true = bricht weder golden-320 noch Gate-1 noch ABI/POD' },
    edits: {
      type: 'array',
      description: 'Konkrete Edits (leer wenn nur Doku-Scope-Limitation, dann in rationale beschreiben)',
      items: {
        type: 'object', additionalProperties: false,
        required: ['file', 'anchor', 'change', 'code'],
        properties: {
          file: { type: 'string', description: 'repo-relativer Pfad' },
          anchor: { type: 'string', description: 'exakte alte Zeile(n) / Zeilennummer als Anker' },
          change: { type: 'string', enum: ['insert', 'replace', 'delete'] },
          code: { type: 'string', description: 'exakter neuer Code (leer bei delete)' },
        },
      },
    },
    rationale: { type: 'string' },
    verification: { type: 'string', description: 'Welcher Test/Build beweist die Korrektheit + golden/ABI-Neutralitaet' },
  },
}

const GAPS = [
  {
    key: 'T5-memory_layout',
    prompt: `${TABU}\n\nLUECKE T5 (memory_layout, LOW/Hygiene). Kontext: toter Tag \`stride_pattern_tag\` deklariert in ${CE}/libs/cache_engine/axes/layout/axis_05_memory_layout_subaxes_hm1_to_hm4.hpp:24, repo-weit NULL Referenzen. Alle 5 Wrapper tragen nur HM1/HM2/HM3 (cache_line_aligned.hpp:23, aos_strict.hpp:23, soa.hpp:23, aosoa.hpp:35, packed_bitmap.hpp:23). IMC-Heuristik docs/architecture/16_axis_05_imc_runtime_heuristik.md ist doku-only Backlog (compile-time-only-Doktrin, korrekt).\nWICHTIG: memory_layout ist eine GOLDEN-320-Achse (5 Werte = die gesampelten). Ein NEUER Wert (HM4 als permutierbarer Layout) bricht golden-320. Option (a) "HM4 lebendig machen als permutierbarer Wert" ist daher TABU-verdaechtig — pruefe genau: aendert das Taggen bestehender Reps mit stride_pattern_tag die Achsen-KARDINALITAET/binary_id? Falls das Tag nur SUB-Achsen-Metadaten (kein neuer Kompositionswert) ist, ist Taggen evtl. neutral; falls es einen neuen Achsenwert erzeugt, NICHT. Empfehle die golden/ABI-neutrale Option — mit hoher Wahrscheinlichkeit (b): die tote \`stride_pattern_tag\`-Deklaration ersatzlos entfernen (kein Waisen-Slot, reine Hygiene). Lies die Dateien + verifiziere die Null-Referenz. Liefere den exakten Edit.`,
  },
  {
    key: 'T16-filter',
    prompt: `${TABU}\n\nLUECKE T16 (filter, MEDIUM). Kern: Space-Effizienz @ Ziel-FPR (deklarierter Kern-Trade-off) ist ueber die 4 Achsenwerte nicht vergleichbar; Maschinerie halb vorhanden, nicht angebunden. Fundstellen: ${CE}/.../axis_filter_registry.hpp:18 (4 Werte); axis_filter_bloom.hpp:41-42,72 (kBitmapBytes/kHashes fix, nur probe_multiplicity); axis_filter_observable.hpp:37-42 (FilterStatistics OHNE FPR-Feld); surf_filter_organ_concept.hpp:39 + louds_sparse_filter_store.hpp:157 (bits_per_key() existiert im getrennten composable/-Subsystem, nicht an AllFilters verdrahtet). Finde die echten Pfade via grep.\nVORGESCHLAGENER FIX (surface-not-build, in-pattern): (a) constexpr \`bits_per_key()\`-Property an jeden der 4 AllFilters-Werte haengen (den vorhandenen composable/-Accessor spiegelnd, ableitbar aus kBitmapBytes/kBuckets/kSlots/kNodeBytes) — reine compile-time-Property, KEIN neuer Achsenwert → golden/Gate-1-neutral. (b) FP-Rate-Feld in FilterStatistics ergaenzen, im filter_scan gegen bekannte Negativ-Probe-Menge gemessen (queries_positive/negative wird bereits getrackt). KRITISCH PRUEFEN: ist FilterStatistics teil des eingefrorenen 1416-Mess-POD (dann waere ein neues Feld ein ABI/POD-Bruch = TABU) ODER eine filterlokale Struct ausserhalb des POD (dann ABI-neutral)? Belege das mit datei:zeile. Falls (b) den POD braeche, (b) als ABI-Major-gated deferren und nur (a) prescriben. Liefere exakte Edits.`,
  },
  {
    key: 'T2-mapping',
    prompt: `${TABU}\n\nLUECKE T2 (mapping, HIGH — hoechstes "misst-am-Ziel-vorbei"-Risiko). Kontext: ${CE}/libs/cache_engine/axes/mapping/axis_03m_mapping_registry.hpp:16-20 hat nur {DirectPlacement, PoolRelative}; MP03/MP04 als Roadmap auskommentiert. direct_placement.hpp:54-56 nur strukturelle Praedikate, keine Mess-Objective. BEFUND.md §4: Separabilitaet offen. Permutations-Index existiert schon (masstree_layer_pool_store.hpp:44 kpermuter) aber unter T0/lookup gebunden, nicht T2.\nENTSCHEIDENDE ABWAEGUNG: mapping ist eine KOMPOSITIONS-Achse (Teil der 137T Gate-1-Zaehlung). Das HINZUFUEGEN von MP03 PermutationIndexed + MP04 HashedOffset als neue Registry-WERTE aendert mp_size(mapping) von 2 auf 4 → bricht Gate-1 (137.594.142.720.000) UND den golden-320-Roundtrip (mapping-Index-Radix aendert sich). Das ist ein TABU-BRUCH. Daher ist die "ziel-treue" Option (a) NICHT golden/Gate-1-neutral. Verifiziere diese Zaehl-Implikation genau (lies axis_03m + wie mp_size in die binary_count()/StaticBinaryView-Radix eingeht). Empfehlung mit hoher Wahrscheinlichkeit: die EHRLICHE Option — T2 als dokumentierte Scope-Limitation re-framen (mapping misst die engere Groesse Indirektions-CM ueber die 2 Basis-Werte; MP03/MP04 bleiben Roadmap bis zu einem bewussten Gate-1/golden-Neuschnitt mit User-GO). Formuliere die exakte Doku-Ergaenzung (welche Datei/Kommentar) + begruende warum ein Achsenwert-Add hier GO-pflichtig ist. Falls du einen golden/Gate-1-NEUTRALEN Weg findest, eine echte Indirektionskosten-Mess-Op an die 2 BESTEHENDEN mapping-Werte zu haengen (ohne neuen Achsenwert), prescribe DEN. Liefere den Edit ODER die Doku-Scope-Formulierung.`,
  },
]

phase('Prescribe')
const REFUTE_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['refuted', 'reason', 'tabu_or_golden_break', 'correction'],
  properties: {
    refuted: { type: 'boolean' },
    reason: { type: 'string' },
    tabu_or_golden_break: { type: 'boolean', description: 'true wenn der Edit golden-320/Gate-1/ABI/POD-TABU bricht' },
    correction: { type: 'string' },
  },
}

const results = await pipeline(
  GAPS,
  g => agent(g.prompt, { label: `prescribe:${g.key}`, phase: 'Prescribe', schema: EDIT_SCHEMA }),
  (spec, g) => {
    if (!spec) return { gap: g.key, spec: null, verdicts: [] }
    const specStr = JSON.stringify(spec, null, 1)
    const lenses = [
      `golden-320/Gate-1: aendert IRGENDEIN Edit die Achsen-Kardinalitaet, die mp_size-Radix, oder golden_fullpilot_320_binary_ids? Default tabu_or_golden_break=true bei Unsicherheit.`,
      `ABI/POD: aendert ein Edit das Layout eines eingefrorenen Mess-POD (1416) / ABI-MAJOR? Ist eine "filterlokale" Statistik wirklich ausserhalb des POD?`,
      `In-Pattern + Korrektheit: ist der Edit ein benanntes Pattern (Registry/Strategy/Observer/CRTP/Property), tatsaechlich in-place kompilierbar, und loest er die deklarierte Luecke — oder ist er kosmetisch/falsch verankert (datei:zeile pruefen)?`,
    ]
    return parallel(lenses.map((lens, i) => () =>
      agent(`Adversariale Pruefung des Ontologie-Fix-Vorschlags fuer ${g.key} durch die LINSE: "${lens}". Lies bei Bedarf die genannten ${CE}-Dateien. Sei streng; ein TABU-Bruch ist ein K.O.\n\nVORSCHLAG:\n${specStr}`,
        { label: `refute:${g.key}:${i}`, phase: 'Refute', schema: REFUTE_SCHEMA })))
      .then(vs => ({ gap: g.key, spec, verdicts: vs.filter(Boolean) }))
  },
)

return {
  gaps: results.filter(Boolean).map(r => ({
    gap: r.gap,
    spec: r.spec,
    any_tabu_break: r.verdicts.some(v => v.tabu_or_golden_break),
    any_refuted: r.verdicts.some(v => v.refuted),
    verdicts: r.verdicts,
  })),
}
