export const meta = {
  name: 'e4prime-hybrid-mode-scoping',
  description: 'E4′ §D Hybrid-/Arbeitsmodus (Diplomarbeits-ZIEL): buildbaren Mechanismus-Anteil vs. data-gated Rest scopen, Design-Anker + nächster Increment',
  phases: [
    { title: 'Scoping', detail: 'ZIEL-Semantik (Doc19/20) + Code-Ist + adversariale Buildbarkeit parallel' },
    { title: 'Synthese', detail: 'nächster buildbarer Mechanismus-Increment' },
  ],
}

const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUP + '/Code/external/comdare-cache-engine'

const S = {
  type: 'object', additionalProperties: false, required: ['findings', 'anchors', 'gated_vs_buildable'],
  properties: {
    findings: { type: 'array', items: { type: 'string' } },
    anchors: { type: 'array', items: { type: 'string' }, description: 'datei:zeile' },
    gated_vs_buildable: { type: 'array', items: { type: 'string' }, description: 'je Teilstück: BUILDBAR-MECHANISMUS / DATA-GATED / ARCHITEKTUR-BLOCKIERT + Begründung' },
  },
}

phase('Scoping')
const [ziel, code, adversarial] = await parallel([
  () => agent(
    `ZIEL-Semantik-Recherche: E4′ §D „Hybrid-/Arbeitsmodus" ist das erklärte ZIEL der Diplomarbeit (User-Direktive 10.07.). ` +
    `Lies ${SUP}/docs/architektur/19_SCHICHTEN_FERTIGSTELLUNG_E4_E1_INTERFACE_VERTRAEGE.md (Teil G) + ` +
    `${SUP}/docs/architektur/20_HEURISTIK_MESSKURVEN_TYPSYSTEM_UND_FILTERKETTE.md (§D/§B/§E) + die Thesis-LaTeX ` +
    `(${SUP}/thesis/diplomarbeit, bes. 04_concept_architecture Heuristik-Auswahl/ML-Klassifikator + Arbeitsmodus). ` +
    `Ermittle PRÄZISE: was IST der Hybrid-/Arbeitsmodus (die Heuristik-Optimierungs-Achse als EIGENE System-Achse, die per ` +
    `Metaprogrammierung die Gattung ihrer Tier-Binaries übernimmt, ein Arbeits-Dock hat, SELBST zur Tier-Binary kompiliert wird, ` +
    `am CEB-Prüfdock andockt, Mess-Command-Pattern an statisch zugewiesene echte Tier-Binaries)? Welche Design-Pattern-Rahmung ` +
    `(Command/Strategy/Visitor/Facade)? Was ist der MINIMALE Mechanismus-Kern vs. was braucht echte #156-Mess-Daten? Zitiere datei:zeile.`,
    { label: 'ziel-semantik', phase: 'Scoping', schema: S }
  ),
  () => agent(
    `Code-Ist-Recherche für den E4′ §D Hybrid-/Arbeitsmodus in ${CE}. Was existiert schon, was fehlt? Suche: (1) die CEB-Modi ` +
    `(Mess/Auswertung/Arbeits/Hybrid) — gibt es einen Modus-Enum/Dispatch (grep COMDARE_*_MODE / EXPERIMENT_MODE / MESSUNG)? ` +
    `(2) das CEB-Prüfdock (PruefDockRegistry / select_for / genus()) + die best_binary_selector-Auswertung (RankingCriterion Strategy); ` +
    `(3) die Heuristik-Auswahl-Prototypen (cacheline_policy_selector.hpp GoF-Strategy, best_binary_selector); ` +
    `(4) die E4′ §C CoR-Filterkette (selection_filter_chain.hpp — mein 076b71cf) als Andock; (5) ob eine „System-Achse" (system_axis.hpp „Blut"-Wurzel, 2a231cf5) ` +
    `als Träger einer Heuristik-Achse dienen kann. Ermittle den konkreten Andockpunkt für einen Hybrid-Modus-Mechanismus, ABI-neutral + host-seitig wo möglich. Zitiere datei:zeile.`,
    { label: 'code-ist', phase: 'Scoping', schema: S }
  ),
  () => agent(
    `Adversariale Buildbarkeits-Prüfung für einen E4′ §D Hybrid-Modus-Increment JETZT (nach CMD-2). Prüfe SKEPTISCH je Teilstück, ` +
    `ob es ein sauberer non-gated Mechanismus-Increment wäre ODER eine Falle: (a) Null-Consumer-Trap (Doc 20 §I: compile-time-Konstrukt ohne echten Konsumenten — wie axis_binding_registry-Revert)? ` +
    `(b) Doppelquelle (wie §B WURZEL zu profile_to_tree.hpp)? (c) data-gated (braucht echte #156-Mess-Kurven, die es nicht gibt)? ` +
    `(d) TABU-Bruch (ABI-Major 4, sizeof==1416, golden_fullpilot_320, permutation_axes.xml, GenusBindingTraits, main.cpp-V31.F-Freeze)? ` +
    `(e) Metaprogrammierungs-Striktheit (kein Runtime-Switch/vtable im Hot-Path; die Heuristik-Tier-Binary als eigene compile-time-Achse)? ` +
    `Lies ${SUP}/docs/sessions/backups/20260711-e4prime-messkurven-typsystem-wurzel/BEFUND.md (der §B-Null-Consumer-Befund) + ` +
    `${SUP}/docs/sessions/backups/20260709-axes-optimization-deep-research/BEFUND.md. Default zu „Falle bestätigt" bei Unsicherheit. Nenne die EINE saubere buildbare Mechanismus-Slice, falls es sie gibt. Zitiere datei:zeile.`,
    { label: 'adversarial-buildbarkeit', phase: 'Scoping', schema: S }
  ),
])

phase('Synthese')
const synth = await agent(
  `Konsolidiere zu einer Increment-Entscheidung für den E4′ §D Hybrid-/Arbeitsmodus (Diplomarbeits-ZIEL). ` +
  `ZIEL: ${JSON.stringify(ziel)} CODE: ${JSON.stringify(code)} ADVERSARIAL: ${JSON.stringify(adversarial)} ` +
  `Liefere: (a) VERDIKT — gibt es JETZT eine saubere, non-gated, synthetisch-testbare Mechanismus-Slice des Hybrid-Modus (JA/NEIN, wie beim CMD-2 c1)? ` +
  `(b) falls JA: die konkrete Slice (neue Datei + Konsument + Design-Pattern + Unit-Test-Plan + die exakten Andockpunkte datei:zeile), ABI-neutral, ` +
  `golden/POD-TABU-sicher, ohne Null-Consumer/Doppelquelle; (c) falls NEIN: warum (data-/architektur-gated) + welcher ANDERE released-gate-Increment ` +
  `(AP-15 Set/Sequence, 234-V, Phase 0.2-Rest, Hebel-A-Rest) ist der sauberste nächste Mechanismus-Bau; (d) was am Hybrid-Modus echt #156-data-gated bleibt. ` +
  `Sei ehrlich wie beim CMD-2/§B-WURZEL-Fall: baue nichts Phantomes/Null-Consumeriges, auch wenn der User-Gate freigegeben ist.`,
  { label: 'synthese', phase: 'Synthese' }
)

return { ziel, code, adversarial, synthese: synth }
