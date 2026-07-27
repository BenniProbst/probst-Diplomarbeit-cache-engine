export const meta = {
  name: 'cmd2-container-attribution-research',
  description: 'CMD-2/#252 ContainerObserver E2-Sidecar: c1/c2/c3-Semantik thesis+code-geerdet ergründen, adversarial prüfen, buildbares Design-Spec',
  phases: [
    { title: 'Research', detail: 'Thesis-Semantik + Code-Anker + adversariale Phantom-Prüfung parallel' },
    { title: 'Synthese', detail: 'buildbares Design-Spec konsolidieren' },
  ],
}

const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUP + '/Code/external/comdare-cache-engine'

const RESEARCH_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['findings', 'anchors', 'risks'],
  properties: {
    findings: { type: 'array', items: { type: 'string' }, description: 'Kernbefunde, jeweils mit datei:zeile' },
    anchors: { type: 'array', items: { type: 'string' }, description: 'konkrete datei:zeile-Anker (Code oder Thesis-.tex)' },
    risks: { type: 'array', items: { type: 'string' }, description: 'Phantom-/Doppelzähl-/ABI-/TABU-Risiken' },
  },
}

phase('Research')
const [thesis, code, adversarial] = await parallel([
  () => agent(
    `Thesis-Semantik-Recherche für CMD-2/#252 „ContainerObserver real" (Container-in-SearchAlgorithm-Attribution). ` +
    `Die Diplomarbeit-LaTeX ist die DESIGN-QUELLE. Finde die thesis-geerdete Bedeutung, wie der Beitrag eines ` +
    `Containers INNERHALB der SearchAlgorithm-Messung aufgeschlüsselt/attribuiert wird: Zugriffs-Anzahl (c1), ` +
    `Anteil (c2), Store-Anteil (c3). Suche in ${SUP}/thesis/diplomarbeit (falls Klon vorhanden) UND in ` +
    `${CE}/docs (Architektur-/Konzept-Docs, Doc 24 Mess-Architektur, Doc 27/30) + ` +
    `${SUP}/docs/sessions/20260705-268-CMD2-RESERVE-PRUEFUNG-BERICHT.md nach: der Definition „SA-Store-Anteil wird ` +
    `über T4/T5/T6/T11/T13 gemessen", der Attribution=Etikettierung/Aggregation-Doktrin, und wie „Container in der ` +
    `SA-Achse mitgemessen und aufgeschlüsselt" gemeint ist. Ziel: die inhaltliche Semantik von c1/c2/c3 im Sinne ` +
    `des Diplomarbeits-Ziels (Achsen-Güte-Vergleich, nicht Latenz). Zitiere Anker datei:zeile. NIE erfinden — wenn ` +
    `die Thesis eine Definition NICHT hergibt, sag das explizit.`,
    { label: 'thesis-semantik', phase: 'Research', schema: RESEARCH_SCHEMA }
  ),
  () => agent(
    `Code-Anker-Recherche für CMD-2/#252 E2-Sidecar (host-seitige Container-Attribution, ABI-neutral, 0 neue POD-Spalten). ` +
    `Ermittle EXAKT datei:zeile: (1) das kV3AxisSchema (in ${CE}/libs/cache_engine — observable_tier.hpp/abi_adapter.hpp): ` +
    `was bedeuten die axis_stats-Subspalten [0][0], [0][3], [0][4] für Achse 0 (search_algo)? Welche Subspalten tragen ` +
    `T4(node_type)/T5(memory_layout)/T6(allocator)/T11(value_handle)/T13(index_organization)? (2) Die ComdareTierObserverSnapshot-` +
    `POD-Struktur (axis_stats[19][8]+seg_ns+Meta, sizeof==1416) — wo wird sie host-seitig gelesen? (3) Der Mess-Export-Andockpunkt ` +
    `für einen HOST-Sidecar analog AP-1/AP-8/AP-9 (measurement_snapshot.hpp / provenance_manifest.hpp / workload_orchestrator-CSV / ` +
    `best_binary_selector): WO würde eine ContainerAttribution{c1,c2,c3} berechnet + ausgegeben, OHNE axis_stats/POD/extern-C zu ändern? ` +
    `(4) ObservableComposedContainer (${CE}/libs/cache_engine/axes/lookup/composable/observable_composed_container.hpp): welche 6 SA-Zähler ` +
    `+ Durchreichen (occupied_count/for_each_record/store_allocator_statistics) sind da? Zitiere alles datei:zeile.`,
    { label: 'code-anker', phase: 'Research', schema: RESEARCH_SCHEMA }
  ),
  () => agent(
    `Adversariale Phantom-/TABU-Prüfung für den geplanten CMD-2/#252-Sidecar (c1=Σaxis_stats[0][0,3,4], c2=Host-Ratio, ` +
    `c3=Host-Aggregation T4/T5/T6/T11/T13). Prüfe SKEPTISCH: (1) Doppelzählung — überlappen die Subspalten [0][0,3,4] ` +
    `semantisch, sodass die Summe doppelzählt? Überlappt c3 mit c1? (2) Phantom — liefern T4/T5/T6/T11/T13 im realen ` +
    `Referenz-Tier überhaupt nicht-null axis_stats, oder wäre c3 ein honest-0/Phantom (wie die 14 honest-0-Achsen aus dem ` +
    `M0-BEFUND ${SUP}/docs/sessions/backups/20260709-axes-optimization-deep-research/BEFUND.md)? (3) TABU — verletzt der ` +
    `Sidecar irgendetwas: ComdareTierObserverSnapshot sizeof==1416, ABI-Major 4, permutation_axes.xml, golden_fullpilot_320, ` +
    `GenusBindingTraits, die ContainerObserver-Klassifikations-Kategorie (die für die ECHTE Container-Gattung Variante b ` +
    `reserviert ist und NICHT angefasst werden darf)? (4) Ist c3 ohne #156-Cluster-Daten überhaupt UNIT-testbar (synthetische ` +
    `axis_stats einspeisen → c1/c2/c3 prüfen), oder ist es faktisch data-gated? Lies ${SUP}/docs/sessions/20260705-268-CMD2-RESERVE-PRUEFUNG-BERICHT.md ` +
    `+ die kV3AxisSchema-Definition. Default zu „Risiko bestätigt" bei Unsicherheit. Zitiere datei:zeile.`,
    { label: 'adversarial-phantom', phase: 'Research', schema: RESEARCH_SCHEMA }
  ),
])

phase('Synthese')
const synth = await agent(
  `Konsolidiere die drei CMD-2/#252-Recherchen zu einem BUILDBAREN Design-Spec für den host-seitigen E2-Sidecar ` +
  `(ContainerAttribution, ABI-neutral, 0 neue POD-Spalten). ` +
  `THESIS-SEMANTIK: ${JSON.stringify(thesis)} ` +
  `CODE-ANKER: ${JSON.stringify(code)} ` +
  `ADVERSARIAL: ${JSON.stringify(adversarial)} ` +
  `Liefere: (a) die EXAKTEN Formeln c1/c2/c3 mit axis_stats-Indizes + kV3AxisSchema-Spaltennamen (oder markiere sie als ` +
  `honest-0/nicht-definierbar, falls die Recherche keine Grundlage hergab); (b) den genauen Andockpunkt datei:zeile für den ` +
  `Sidecar (neue Header-Datei + Konsument); (c) den Unit-Test-Plan (synthetische axis_stats → erwartete c1/c2/c3, Edge-Cases: ` +
  `alle-0, Doppelzähl-Schutz); (d) das VERDIKT: ist CMD-2 JETZT non-gated buildbar (mechanik-testbar ohne #156) — JA/NEIN + ` +
  `Begründung; (e) alle TABU-/Phantom-Vermeidungs-Auflagen. Sei ehrlich: wenn die Recherche zeigt, dass c1/c2/c3 ohne ` +
  `Cluster-Daten oder ohne User-Semantik-Entscheid nur ein Phantom wären, sag NEIN und begründe (wie der §B-WURZEL-Null-Consumer-Fall).`,
  { label: 'synthese', phase: 'Synthese' }
)

return { thesis, code, adversarial, synthese: synth }
