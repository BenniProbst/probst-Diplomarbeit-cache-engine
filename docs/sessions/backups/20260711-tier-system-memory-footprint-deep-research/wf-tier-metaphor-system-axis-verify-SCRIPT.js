export const meta = {
  name: 'tier-metaphor-system-axis-property-verify',
  description: 'Deep-Research: welche Eigenschaften SOLLEN die Tier-Metapher-Konstrukte (Gattung/Lebewesen/AbiAdapter) + die System-Achsen ("Blut") haben (Diplomarbeit-Ziel) — vollstaendig im Code? Gated vs. TABU-neutral buildbar?',
  phases: [{ title: 'Investigate' }, { title: 'Synthesize' }, { title: 'Refute' }],
}

const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const THESIS = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/thesis/diplomarbeit'
const DOCS = CE + '/docs/architecture'
const COMMON = `KONTEXT (autoritativ, aus Plan-Dossier TEIL A + Memories): 3-Ebenen-Anatomie: (1) Gattung = Aussen-Interface/Pruef-Dock (3: SearchAlgorithm/Container/Graph, AnatomyGattung); (2) Lebewesen-Unterklasse = fester Achsen-Satz (5: SearchAlgorithm/Set/Sequence/Adapter/View, AnatomyGenus/GenusBindingTraits<G>); (3) Achse=Organ (19 T0-T18). AbiAdapter (A3) = Laufzeit-DLL-Sicht (SearchAlgorithmAbiAdapter<A> : IAnatomyBase,IMeasurableWorkload,IObservableTier, Reihenfolge EINGEFROREN). SYSTEM-Achsen = eigenes Mess-System mit eigener abstrakter Wurzel "Blut" (Organ-Achsen vs. System-Achsen NIE vermischen; E4->E0 interface-strikt) — im Gegensatz zu den 19 Organ-Achsen. TABU: golden_fullpilot_320, POD sizeof==1416, ABI-MAJOR==4, GenusBindingTraits, permutation_axes.xml, Gate-1 137.594.142.720.000. Nur benannte Lehrbuch-Patterns (CRTP/Concept/Registry/Strategy/Observer), compile-time-only Hot-Path. "Achsen=nur Organe, Tiere unter Gattung seziert" — nie Ganz-Tier-Achsen; alle Achsen getrieben+gemessen.`

phase('Investigate')
const DIM = [
  {
    key: 'tier-metaphor-soll',
    prompt: `${COMMON}\n\nAufgabe: Welche EIGENSCHAFTEN SOLLEN die Tier-Metapher-Konstrukte im Sinne des Diplomarbeit-Ziels haben? Lies die Architektur-Doku ${DOCS} (bes. 14/34/36 = Organ-Metapher/Master-Ist-Stand/2-Baeume-Fix) + ggf. ${THESIS}/kapitel (Anatomie-Metapher §3.3). Fuer JEDE Ebene — (a) Gattung (AnatomyGattung, Pruef-Dock), (b) Lebewesen/Genus (AnatomyGenus, GenusBindingTraits<G>, die 5 mit Slot-Zahlen 19/15/11/13/7), (c) AbiAdapter (die 3 eingefrorenen Interfaces) — nenne die GEFORDERTEN Eigenschaften/Vertraege (welche Methoden/Properties/Invarianten MUSS jede Ebene laut Thesis-Ziel exponieren: z.B. genus(), observe_all(), tier_observe, GenusBindingTraits-Slot-Kohaerenz, Cross-Genus-Type-Unmoeglichkeit). Belege datei:zeile (Doku UND Code). Fokus: was ist GEFORDERT (SOLL), unabhaengig vom IST.`,
  },
  {
    key: 'system-axis-soll',
    prompt: `${COMMON}\n\nAufgabe: Die SYSTEM-Achsen ("Blut"-Mess-System, eigene abstrakte Wurzel, getrennt von den 19 Organ-Achsen). Frage: welche Eigenschaften/Achsen SOLL das System-Mess-Achsen-Konstrukt haben (Diplomarbeit-Ziel)? Suche im Code (${CE}, grep nach SystemAxis/system_axis/Blut/blood/measurement-system-root/Regime/16 Kategorien) + Doku ${DOCS} (bes. die Mess-Architektur-Docs 21/24/31 + system-axes) + Memory-Hinweise (SystemAxis/Regime/16 Kategorien, IMeasurementSource/Registry, Heuristik-Tier-Binary als eigene Systemachse mit Arbeits-Dock). Nenne die GEFORDERTEN System-Achsen + ihre Eigenschaften (z.B. thread_count/hw_prefetcher als runtime-dynamische System-Achsen? Heuristik-Tier-Switch-Achse? Regime-Kategorien?). Belege datei:zeile. Was ist SOLL laut Ziel?`,
  },
  {
    key: 'ist-code',
    prompt: `${COMMON}\n\nAufgabe: IST-Zustand im Code ${CE}. (1) Fuer die 3 Anatomie-Ebenen: welche geforderten Methoden/Vertraege sind implementiert? grep genus()/observe_all()/tier_observe/GenusBindingTraits/AnatomyGenus/AnatomyGattung + die 5 Genus-Slot-Zahlen (19/15/11/13/7). Sind alle 5 Genera gleich vollstaendig, oder nur SearchAlgorithm voll + Set/Sequence/Adapter/View als Bindings? (2) Fuer die System-Achsen: was existiert (SystemAxis-Root, Regime, measurement-system) vs. was fehlt? (3) Gibt es benannte-aber-nicht-implementierte ("SOLL aber nicht IST") Eigenschaften auf Tier-/System-Ebene — analog zu den 4 Organ-Achsen-Luecken T8/T2/T16/T5? Belege datei:zeile. Sei ehrlich ueber test-only/Stub/Null-Consumer.`,
  },
]
const invest = await parallel(DIM.map(d => () => agent(d.prompt, { label: `invest:${d.key}`, phase: 'Investigate' })))
const investText = DIM.map((d, i) => `### ${d.key}\n${invest[i] || '(kein Ergebnis)'}`).join('\n\n')

phase('Synthesize')
const GAP_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['verdict', 'gaps'],
  properties: {
    verdict: { type: 'string', description: 'Gesamt: sind die Tier-Metapher- + System-Achsen-Konstrukte eigenschafts-vollstaendig (SOLL==IST)? Ehrlich + differenziert.' },
    gaps: {
      type: 'array',
      description: 'Bestaetigte Luecken: geforderte-aber-nicht-benannte/implementierte Eigenschaft auf Tier-/System-Ebene',
      items: {
        type: 'object', additionalProperties: false,
        required: ['level', 'missing_property', 'evidence', 'severity', 'fix_class'],
        properties: {
          level: { type: 'string', description: 'Gattung/Genus/AbiAdapter/SystemAxis' },
          missing_property: { type: 'string' },
          evidence: { type: 'string', description: 'datei:zeile SOLL (Doku/Thesis) vs. IST (Code fehlt)' },
          severity: { type: 'string', enum: ['high', 'medium', 'low'] },
          fix_class: { type: 'string', enum: ['tabu-neutral-buildable', 'gated-abi-bump', 'gated-data-156', 'gated-design-GO', 'text-agent-domain', 'no-gap-doku-only'], description: 'Ist die Schliessung JETZT TABU-neutral buildbar ODER gated?' },
        },
      },
    },
  },
}
const synth = await agent(
  `${COMMON}\n\nSynthetisiere aus der Investigation die BESTAETIGTEN Eigenschafts-Luecken der Tier-Metapher- + System-Achsen-Konstrukte (SOLL laut Diplomarbeit-Ziel, aber nicht benannt/implementiert im Code) — analog zur Organ-Achsen-Ontologie-Verifikation (die T8/T2/T16/T5 fand). WICHTIG: klassifiziere JEDE Luecke ehrlich als (tabu-neutral-buildbar JETZT) vs. (gated: ABI-Bump/#156-Data/Design-GO/Text-Agent). Kein Erfinden von Achsen (Direktive: nie Ganz-Tier-Achsen; Min/Max erforschen statt erfinden). Wenn alles vollstaendig/nur-gated → sag das ehrlich (leere/kurze gaps-Liste ist ein valides Ergebnis).\n\nINVESTIGATION:\n${investText}`,
  { label: 'synth:gaps', phase: 'Synthesize', schema: GAP_SCHEMA },
)

phase('Refute')
const REFUTE_SCHEMA = { type: 'object', additionalProperties: false, required: ['gap_ref', 'is_real', 'is_tabu_neutral', 'reasoning'],
  properties: { gap_ref: { type: 'string' }, is_real: { type: 'boolean' }, is_tabu_neutral: { type: 'boolean' }, reasoning: { type: 'string' } } }
const gaps = (synth && synth.gaps) || []
const verds = await parallel(gaps.slice(0, 8).map((g, i) => () =>
  agent(`${COMMON}\n\nAdversariale Pruefung EINER behaupteten Tier-/System-Eigenschafts-Luecke. Ist sie (a) REAL (geforderte Eigenschaft fehlt wirklich, nicht bloss anders benannt/schon da) und (b) TABU-NEUTRAL jetzt buildbar (bricht NICHT golden/Gate-1/POD-1416/ABI-4)? Lies bei Bedarf ${CE}. Default is_real=false bei Zweifel (kein Phantom-Gap erfinden).\n\nLUECKE:\n${JSON.stringify(g, null, 1)}`,
    { label: `refute:${i}`, phase: 'Refute', schema: REFUTE_SCHEMA })))

return { verdict: synth && synth.verdict, gaps, refutations: verds.filter(Boolean),
  confirmed_buildable: verds.filter(Boolean).filter(v => v.is_real && v.is_tabu_neutral).map(v => v.gap_ref) }
