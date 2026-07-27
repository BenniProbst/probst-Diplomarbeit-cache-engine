export const meta = {
  name: 'f-simd-schritt2-4-vor-planung',
  description: 'VOR-Planung F-SIMD Schritt 2-4: <simd>-Container-Symmetrie in XSD/golden/Parser + Consumer-Migration, konform gegen opt_level-Vorbild',
  phases: [
    { title: 'Kartierung', detail: '4 parallele Kartierer: XSD, beide golden, Parser, Consumer' },
    { title: 'Plan', detail: 'konformitaetsgepruefter Edit-Plan + Migrations-Checkliste' },
  ],
}

const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'

phase('Kartierung')

const readers = [
  {
    label: 'xsd',
    prompt: `Lies NUR (read-only, keine Edits) die XSD ${SUPER}/Code/test_data_xml/experiment_schema.xsd.
ZIEL: Wie ist die <system_axes>-Struktur schema-seitig definiert? Gib EXAKT (datei:zeile) wieder:
(1) Wie wird <compiler> mit <opt_level> mit <option> im Schema definiert (die 3-Ebenen-Kette compiler->opt_level->option) — das SYMMETRIE-VORBILD.
(2) Wie wird <extension_hardware> derzeit definiert — hat es einen <simd>-Zwischen-Container oder haengen <option> direkt drunter (die ASYMMETRIE)?
(3) Welche exakten xs:element/xs:complexType-Bloecke muessten ergaenzt/umgebaut werden, damit <extension_hardware> ein <simd>-Zwischenelement bekommt, das <option> traegt — spiegelbildlich zu <opt_level>?
Gib die relevanten XSD-Zeilen woertlich + Zeilennummern. KEINE Aenderung, nur Kartierung.`,
  },
  {
    label: 'golden',
    prompt: `Lies NUR (read-only) BEIDE golden-XML:
  A) ${CE}/tests/unit/thesis_tiere/experiment_golden.xml
  B) ${SUPER}/Code/test_data_xml/experiment_golden.xml
ZIEL: Zeige fuer BEIDE den <system_axes>-Block WOERTLICH mit Zeilennummern, speziell:
(1) den <compiler><opt_level><option>-Block (Vorbild, 3 Ebenen),
(2) den <extension_hardware>...<option>-Block (aktuell 2 Ebenen, ASYMMETRISCH).
(3) Sind A und B byte-identisch in diesem Block oder gibt es Unterschiede (welche Optionen: no_extension/avx2/avx512)?
(4) Wie muss der <extension_hardware>-Block je Datei aussehen NACH Umbau auf <extension_hardware><simd><option>...</simd></extension_hardware> — gib den Ziel-XML-Block woertlich fuer beide Dateien an.
Betone: opt_level+simd sind system_config = binary_id-NEUTRAL, golden binary_count MUSS ==320 bleiben (der Block permutiert nur Provenienz, keine Komposition).`,
  },
  {
    label: 'parser',
    prompt: `Lies NUR (read-only) den Parser:
  ${CE}/libs/common/serialization/xml_config_parser/xml_config_parser.cpp (Fokus ~Zeile 415-435)
  ${CE}/libs/common/serialization/xml_config_parser/xml_config_parser.hpp (Struktur ExperimentProfile: compiler/opt_levels + extension_hardware/options)
ZIEL, exakt datei:zeile:
(1) Wie liest der Parser HEUTE opt_level: geht er ueber den <opt_level>-Container und dann ueber <option>? Zeig die Zeilen woertlich (das Vorbild).
(2) Wie liest der Parser HEUTE <extension_hardware>: direkt ueber <option> (asymmetrisch)? Zeig die Zeilen woertlich.
(3) Welche Datenfelder tragen das Ergebnis (ExperimentProfile.compiler.opt_levels vs ExperimentProfile.extension_hardware.options)? Struktur-Definition mit Zeilen.
(4) Welche exakte Code-Aenderung macht das extension_hardware-Lesen symmetrisch: erst child("simd")-Container, dann dessen children_named("option")? Skizziere das Ziel-Snippet.
KEINE Aenderung, nur Kartierung.`,
  },
  {
    label: 'consumer',
    prompt: `Lies NUR (read-only) diese Dateien und finde JEDE Stelle, die die ALTE extension_hardware-Achsen-Familie oder ep.extension_hardware.options verwendet:
  ${CE}/libs/cache_engine/include/cache_engine/measurement/extension_hardware_system_axis.hpp  (die alte Familie: Generic/Avx2/Avx512ExtensionHardwareAxis o.ae.)
  ${CE}/libs/cache_engine/profile_facade/experiment_run_entry.hpp  (Permutations-Schleife / experiment_march_of / compile_for_perm)
  ${CE}/libs/cache_engine/profile_facade/profile_run_facade.cpp  (active_simd_policy / perm_extension_hardware_cflags)
  ${CE}/libs/cache_engine/profile_facade/validate_profile.hpp  (Validierung extension_hardware-Optionen)
Vergleiche mit der NEUEN Achse ${CE}/libs/cache_engine/include/cache_engine/measurement/simd_sub_axis.hpp (SimdNoExtOption/SimdAvx2Option/SimdAvx512Option, do_axis_label=="simd", parent=="extension_hardware", gcc/clang_march_flag).
ZIEL, exakt datei:zeile je Stelle:
(1) Welche Typen der ALTEN Familie existieren in extension_hardware_system_axis.hpp und was liefern sie (id, march-flag)? Sind sie deckungsgleich zu den neuen SimdSubAxis-Optionen?
(2) JEDE Consumer-Stelle auflisten, die von der alten Familie auf die neue SimdSubAxis-Option migriert werden muss (march-flag-Ermittlung, active_simd_policy, perm cflags, Validierung).
(3) Gibt es Risiken (z.B. die alte Familie wird auch woanders gebraucht, ABI, golden)? Was bleibt, was faellt weg?
KEINE Aenderung, nur Kartierung.`,
  },
]

const maps = await parallel(readers.map(r => () => agent(r.prompt, { label: r.label, phase: 'Kartierung' })))

phase('Plan')

const PLAN_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['golden_neutral', 'edits', 'migration_sites', 'verification', 'risks', 'conformance_verdict'],
  properties: {
    golden_neutral: { type: 'string', description: 'Warum golden binary_count==320 unberuehrt bleibt (system_config/binary_id-neutral)' },
    edits: {
      type: 'array', description: 'Geordnete konkrete Edits, je datei:zeile',
      items: {
        type: 'object', additionalProperties: false,
        required: ['file', 'anchor', 'change'],
        properties: {
          file: { type: 'string' },
          anchor: { type: 'string', description: 'Zeile(n)/Symbol' },
          change: { type: 'string', description: 'Was genau aendern, symmetrisch zu opt_level' },
        },
      },
    },
    migration_sites: {
      type: 'array', description: 'Consumer-Stellen alt->neu (SimdSubAxis-Option)',
      items: { type: 'string' },
    },
    verification: { type: 'array', items: { type: 'string' }, description: 'Verifikations-Kadenz (dach-guard/golden==320/parser-roundtrip/cf22/Mojibake/super-sub-build)' },
    risks: { type: 'array', items: { type: 'string' } },
    conformance_verdict: { type: 'string', description: 'Ist der Plan strikt symmetrisch zu compiler/opt_level/option? Ja/Nein + Begruendung' },
  },
}

const plan = await agent(
  `Du bist der Konformitaets-Architekt. Aufgabe F-SIMD Schritt 2-4: <extension_hardware><option> soll SYMMETRISCH zu <compiler><opt_level><option> werden, d.h. eine <simd>-Unter-Achse einziehen: <extension_hardware><simd><option .../></simd></extension_hardware>. Die typisierte Achse (SimdSubAxis, Schritt 1) ist bereits committed. Jetzt fehlen XSD, beide golden.xml, Parser und Consumer-Migration.

Fuehrender Plan (Quelle der Wahrheit): opt_level/compiler ist das strikte Vorbild; simd MUSS spiegelbildlich unter extension_hardware haengen (Haupt->Unter->Option-Ebenung, V35-Tabelle). system_config ist binary_id-NEUTRAL -> golden binary_count MUSS ==320 bleiben. Metaprog compile-time-only, keine vtable.

Hier die 4 Kartierungen (XSD / golden / Parser / Consumer):

=== XSD ===
${maps[0]}

=== GOLDEN (beide) ===
${maps[1]}

=== PARSER ===
${maps[2]}

=== CONSUMER ===
${maps[3]}

Erstelle den praezisen, geordneten Edit-Plan (je datei:zeile), die vollstaendige Consumer-Migrations-Checkliste (alte extension_hardware-Familie -> neue SimdSubAxis-Optionen), die golden-Neutralitaets-Begruendung, Risiken und ein Konformitaets-Verdikt (ist der Plan strikt symmetrisch zu opt_level?). Wenn eine Kartierung eine Luecke offen laesst, benenne sie explizit statt zu raten.`,
  { label: 'synthese', phase: 'Plan', schema: PLAN_SCHEMA, effort: 'high' }
)

return plan
