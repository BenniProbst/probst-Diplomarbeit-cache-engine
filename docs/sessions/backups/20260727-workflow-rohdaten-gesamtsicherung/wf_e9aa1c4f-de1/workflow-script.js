export const meta = {
  name: 'new-golden-all-axes-xml-vor',
  description: 'VOR: XML-Grundlage die ALLE 17 Achsen abdeckt -> Permutations-Zahl N>320 als neues golden-Ziel (Generator/CatalogAxes/Test-Umstellung), messdaten-erhaltend',
  phases: [
    { title: 'Kartierung', detail: '4 Kartierer: Achsen+Varianten / Catalog-320-Mechanik / Generator+Tests / XML-Format' },
    { title: 'Plan', detail: 'N berechnen + XML-Grundlage + Code-Umstellung + Konformitaet + Forks' },
  ],
}

const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'

phase('Kartierung')

const readers = [
  {
    label: 'achsen-varianten',
    prompt: `Read-only Kartierung: die 17 Komposition-Achsen (nach INC-2d, isa raus) + die VARIANTEN-ZAHL je Achse. Lies:
  ${CE}/libs/cache_engine/builder/experiment_tree/axis_path_serialization.hpp (kCompositionAxisNames = die 17)
  ${CE}/libs/cache_engine/builder/experiment_tree/registry_to_axis_levels.hpp (EnabledStrategies -> AxisLevel je Achse; enabled_count)
  ${CE}/libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml (die Registry mit den Achsen + Varianten)
  ${CE}/libs/cache_engine/profile_facade/source_catalog.hpp (StaticAxisVariants_00..16, mp_size je Achse)
ZIEL, exakt datei:zeile + eine TABELLE:
(1) Fuer JEDE der 17 Achsen (search_algo, cache_traversal, mapping, path_compression, node_type, memory_layout, allocator, prefetch, concurrency, serialization, value_handle, index_organization, io_dispatch, migration_policy, filter, queuing_q1, queuing_q2): wie viele ENABLED Varianten hat sie (mp_size der StaticAxisVariants / EnabledStrategies-Count)? Nenne die Zahl je Achse.
(2) Welche 4 Achsen variieren heute in der golden-320 (search_algo=4, node_type=4, memory_layout=5, prefetch=4 -> 4*4*5*4=320)? Belege die 4 Zahlen.
(3) Das VOLLE Produkt aller 17 mp_size (der theoretische All-Achsen-Permutationsraum) = ? Rechne es aus (kann riesig sein). Und: welche Achsen haben nur 1 Variante (Fanout-1, tragen x1 bei)?
(4) Gibt es eine Registry/Enable-Konfiguration, die die per-Achse-Varianten-Zahl steuert (welche Varianten "enabled" sind)? Wo?
NUR Kartierung.`,
  },
  {
    label: 'catalog-320-mechanik',
    prompt: `Read-only Kartierung: die CatalogAxes<4,4,5,4>=320-Mechanik (wie die 320 gebaut werden). Lies:
  ${CE}/libs/cache_engine/profile_facade/source_catalog.hpp (FullSourceCatalog, CatalogAxes<...>, welche Achsen mp_take_c<...,1>-gepinnt = Fanout 1, welche voll variiert; CatalogCfg)
  ${CE}/libs/cache_engine/builder/experiment_tree/experiment_tree.hpp (StaticBinaryView, binary_count, PermutationEngine)
ZIEL, exakt datei:zeile:
(1) Wie definiert CatalogAxes<4,4,5,4> die 320? Welche Template-Params bedeuten was (die 4 variierenden Achsen-Varianten-Zahlen)? Wie werden die anderen 13 Achsen gepinnt (mp_take_c<StaticAxisVariants_XX,1> = nur 1. Variante)?
(2) Wenn ich ALLE 17 Achsen variieren lassen will (statt nur 4): wie aendere ich CatalogAxes? Braucht es <v0,v1,...,v16> mit je der vollen mp_size, oder eine kuratierte per-Achse-Zahl? Wo genau steht die Pinnung (mp_take_c<...,1>) je Achse?
(3) binary_count()/mp_size-Produkt: wie berechnet der Code die Gesamtzahl? Ist sie ein compile-time-static_assert (== 320)? Wo?
(4) Gibt es eine natuerliche, MATERIALISIERBARE All-Achsen-Zahl (z.B. je Achse 2 Varianten = 2^17, oder je Achse die volle mp_size)? Was ist gross vs. handhabbar? Welche Zwischenstufe (z.B. alle Achsen mit 2-3 Varianten) gibt ein N im Tausender-Bereich?
NUR Kartierung.`,
  },
  {
    label: 'generator-tests-320',
    prompt: `Read-only Kartierung: der golden-Generator + ALLE Stellen, die 320 hartkodieren. Lies + grep:
  ${CE}/tools/gen_golden_fullpilot/main.cpp (Generator, Count-Wache ==320)
  ${CE}/tests/unit/thesis_tiere/test_profile_roundtrip.cpp (binary_count==320, static_levels)
Grep im ${CE}: alle Vorkommen von "320" (in libs/, tools/, tests/) die die golden-Zahl meinen (nicht zufaellige 320er); alle "4, 4, 5, 4"/"4,4,5,4"/CatalogAxes; alle "== 320"/"320u"/binary_count-Asserts.
ZIEL, exakt datei:zeile:
(1) Liste JEDE Stelle, die 320 (oder 4,4,5,4) als golden-Zahl hartkodiert: Generator-Count-Wache, test_profile_roundtrip, source_catalog CatalogAxes-Params, evtl. weitere Tests/Kommentare/golden-Header.
(2) Der Generator: wie erzeugt er die 320 ids (catalog_static_levels<FullSourceCatalog> -> StaticBinaryView)? Wenn CatalogAxes auf N Achsen erweitert wird, produziert er automatisch N ids? Oder ist N woanders hartkodiert?
(3) Welche Tests wuerden bei 320->N brechen und muessen die Zahl nachziehen (compile-static_assert + Laufzeit-EXPECT)?
(4) golden_fullpilot_320_binary_ids.txt: der Dateiname enthaelt "320" — muss die Datei/der Test-Fixture-Pfad umbenannt werden bei N!=320, oder bleibt der Name?
NUR Kartierung.`,
  },
  {
    label: 'xml-format',
    prompt: `Read-only Kartierung: das Experiment-XML-Format (wie Achsen deklariert werden) fuer die neue All-Achsen-Grundlage. Lies:
  ${CE}/tests/unit/thesis_tiere/experiment_golden.xml (die golden-Experiment-XML, <system_axes>/<compile_dims>/<permute_axes>/<axes_default_lookup>)
  ${SUPER}/Code/test_data_xml/experiment_schema.xsd (das Schema)
  ${CE}/libs/cache_engine/algorithm_profiles/thesis_profiles/m3v2_study.profile.xml (falls existent, ein reiches Profil mit axis_sweeps)
  ${CE}/libs/cache_engine/profile_facade/validate_profile.hpp (wie <permute_axes>/<axis ref><value> validiert werden)
ZIEL, exakt datei:zeile:
(1) Wie deklariert eine Experiment-XML die zu permutierenden Achsen + ihre Werte (<permute_axes><axis ref="X"><value>...)? Zeig das Format woertlich.
(2) Gibt es schon eine XML, die MEHR als 4 Achsen permutiert (Richtung All-Achsen)? Wie sieht die Achsen-Deklaration aus?
(3) Wie wuerde eine XML-Grundlage aussehen, die ALLE 17 Achsen mit je >1 Variante deklariert (die neue >320-golden-Basis)? Skizziere das XML-Skelett.
(4) Verbindung XML <-> CatalogAxes: wird die golden-320 heute aus einer XML generiert, oder ist CatalogAxes<4,4,5,4> C++-hartkodiert und die XML separat? Wie koppelt die neue XML-Grundlage an den Generator (damit die XML die golden-Zahl treibt)?
NUR Kartierung.`,
  },
]

const maps = await parallel(readers.map(r => () => agent(r.prompt, { label: r.label, phase: 'Kartierung' })))

phase('Plan')

const PLAN_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['axis_variant_table', 'new_golden_N', 'xml_grundlage', 'code_changes', 'messdaten_erhaltend', 'conformance_verdict', 'open_decisions', 'risks'],
  properties: {
    axis_variant_table: { type: 'string', description: 'Tabelle: je der 17 Achsen die enabled-Varianten-Zahl (mp_size)' },
    new_golden_N: { type: 'string', description: 'Die berechnete neue golden-Zahl N: das Produkt (welche Achsen mit welcher Varianten-Zahl), N>320, materialisierbar; die exakte Rechnung' },
    xml_grundlage: { type: 'string', description: 'Wie die neue All-Achsen-XML-Grundlage aussieht (Skelett + welche Achsen/Werte) + wie sie an den Generator koppelt' },
    code_changes: {
      type: 'array', description: 'Geordnete Code-Aenderungen (CatalogAxes, Generator, Tests, static_asserts, golden-Datei)',
      items: { type: 'object', additionalProperties: false, required: ['file', 'change'], properties: { file: { type: 'string' }, change: { type: 'string' } } },
    },
    messdaten_erhaltend: { type: 'string', description: 'Wie die alte golden-320 additiv gesichert wird (Snapshot) + neue N-golden erzeugt' },
    conformance_verdict: { type: 'string', description: 'Konform (alle Achsen abgedeckt, N materialisierbar, compile+test verankert, messdaten-erhaltend, TABU im GO-Fenster)? + Begruendung' },
    open_decisions: { type: 'array', items: { type: 'string' }, description: 'ECHTE Forks fuer den User (v.a. die per-Achse-Varianten-Zahl / welches N genau, wenn mehrere sinnvoll)' },
    risks: { type: 'array', items: { type: 'string' } },
  },
}

const plan = await agent(
  `Du bist der Architekt fuer die NEUE golden-Grundlage. User-Direktive (2026-07-18, verbatim): "erstelle eine neue Grundlage fuer ein XML welches ALLE Achsen abdeckt und daher ein new golden baut, aber es werden laut Permutations-Mathematik MEHR als 320 Rekombinationen werden, nimm diese neu ermittelte Zahl mit compile und test als neues golden Ziel".

Kontext: die aktuelle golden-320 = CatalogAxes<4,4,5,4> variiert NUR 4 Achsen (search_algo=4, node_type=4, memory_layout=5, prefetch=4), die anderen 13 der 17 Komposition-Achsen sind Fanout-1-gepinnt. Nach INC-2d sind es 17 Achsen (isa raus). Der volle Permutationsraum aller Achsen ist riesig (~10^12+). Die neue Grundlage soll ALLE Achsen abdecken (jede variiert), aber MATERIALISIERBAR bleiben -> ein N>320.

Direktiven: compile-time (CatalogAxes-Template + static_assert) + test (test_profile_roundtrip binary_count==N) verankern; messdaten-erhaltend (alte 320-golden additiv als Snapshot, nie loeschen); TABU (CatalogAxes/golden_fullpilot_320) nur im GO-Fenster (User hat GO); der isa-Organ-Typ bleibt (INC-2d), aber isa ist keine Komposition-Achse mehr (nicht in den 17).

Vier Kartierungen:

=== ACHSEN + VARIANTEN ===
${maps[0]}

=== CATALOG-320-MECHANIK ===
${maps[1]}

=== GENERATOR + 320-STELLEN ===
${maps[2]}

=== XML-FORMAT ===
${maps[3]}

Erstelle den Plan: (a) die Varianten-Tabelle je Achse; (b) die neue golden-Zahl N — WELCHE Achsen mit WELCHER Varianten-Zahl (z.B. alle 17 mit voller mp_size, ODER alle mit min. 2, ODER eine kuratierte materialisierbare Menge), die EXAKTE Permutations-Rechnung, N>320 aber handhabbar (nicht 10^12); (c) die XML-Grundlage (Skelett + Kopplung an den Generator); (d) die geordneten Code-Aenderungen (CatalogAxes-Params, Generator, alle 320-Stellen -> N, static_asserts, golden-Datei/Name); (e) messdaten-erhaltend; (f) Konformitaets-Verdikt; (g) ECHTE offene Entscheidungen fuer den User — v.a.: WELCHES N genau (die per-Achse-Varianten-Zahl ist eine Design-Wahl; nenne 2-3 sinnvolle Optionen mit ihren N-Werten, z.B. "alle Achsen 2 Varianten = 2^k", "volle mp_size = M", "kuratiert = X"); (h) Risiken. Wenn eine Kartierung eine Luecke laesst, benenne sie explizit. Rechne die N-Optionen KONKRET aus den mp_size-Zahlen der Kartierung.`,
  { label: 'synthese', phase: 'Plan', schema: PLAN_SCHEMA, effort: 'high' }
)

return plan
