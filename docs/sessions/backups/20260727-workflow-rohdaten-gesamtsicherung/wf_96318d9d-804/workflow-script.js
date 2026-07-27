export const meta = {
  name: 'inc-0-vor-deep-research-flag-trennung',
  description: 'INC-0 VOR-Deep-Research: malloc->Allokator-Organ-Achse / Compile-Flags(-mcx16)->Compiler-System-Achse klar trennen; golden-neutral, konform',
  phases: [
    { title: 'Kartierung', detail: '4 Kartierer: Allokator-Organ / Flag-Mischung / Compiler-System-Achse / golden-Impact' },
    { title: 'Plan', detail: 'Deep-Research-Trennungsplan + golden-Neutralitaet + Konformitaets-Verdikt' },
  ],
}

const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'

phase('Kartierung')

const readers = [
  {
    label: 'allokator-organ',
    prompt: `Read-only Kartierung der ALLOKATOR-ORGAN-ACHSE (INC-0). Lies:
  ${CE}/libs/cache_engine/axes/alloc/  (axis_06_allocator_*.hpp Familie: ptmalloc2/snmalloc/hoard/numalloc/lrmalloc/vmem_mag/exgen/vampir_nfp)
  ${CE}/libs/cache_engine/axes/alloc/vendor_includes/snmalloc_include.hpp
  ${CE}/libs/cache_engine/topics/allocator/topic_allocator_config_set.hpp
  ${CE}/libs/cache_engine/topics/allocator/axis_06_allocator/axis_06_allocator_snmalloc.hpp
  ${CE}/libs/cache_engine/builder/permutation_codegen_tool/permutation_codegen_tool.cpp (~149-154, 400-410: COMDARE_PERM_ALLOC_IS_SNMALLOC / COMDARE_ALLOC-Makros / axis6-Liste)
ZIEL, exakt datei:zeile:
(1) Wie waehlt/kompiliert die Allokator-Organ-Achse einen Allokator in eine Tier-Binary (der COMDARE_PERM_ALLOC_IS_SNMALLOC-Pfad + #include snmalloc + COMDARE_ALLOC/COMDARE_FREE-Makros)? Ist 'allocator' in kCompositionAxisNames (T6, Organ, binary_id-relevant)?
(2) Bekommt snmalloc SEINE Interface-Defs (SNMALLOC_HEADER_ONLY_LIBRARY=1 etc.) HEUTE ueber die Organ-Achse/Vendor-Include, ODER nur ueber die gebackenen Facade-cflags (der Leak)? Wo genau werden die SNMALLOC_*-Defs erwartet?
(3) Braucht der snmalloc-Codegen-Pfad -mcx16 (double-width CAS)? Ist -mcx16 allokator-spezifisch (nur snmalloc) oder generell?
(4) Gibt es schon einen Ort auf der Organ-Achse, wo allokator-spezifische Compile-Anforderungen (Defs/Flags) deklarativ haengen koennten (analog wie simd_sub_axis das -march traegt)?
NUR Kartierung, keine Edits.`,
  },
  {
    label: 'flag-mischung',
    prompt: `Read-only Kartierung der FLAG-MISCHUNG (INC-0, der zu behebende Defekt). Lies:
  ${CE}/libs/cache_engine/profile_facade/CMakeLists.txt (~155-180: SNMALLOC-Defs + -mcx16 -> _facade_perm_extra_cflags -> COMDARE_FACADE_PERM_EXTRA_CFLAGS)
  ${CE}/libs/cache_engine/profile_facade/profile_run_facade.cpp (~98-160: baked_perm_extra_cflags / perm_mess_defines / perm_extension_hardware_cflags; ~270-290 + ~460-475: wo perm_mess_defines an make_gpp_compile_fn geht)
ZIEL, exakt datei:zeile:
(1) Was GENAU wird in COMDARE_FACADE_PERM_EXTRA_CFLAGS gebacken? Liste jeden Eintrag: welche sind ALLOKATOR-spezifisch (SNMALLOC_*-Defs), welche sind reine COMPILER-Flags (-mcx16), welche sind etwas anderes?
(2) perm_mess_defines(): welche Eintraege sind Mess-/OS-/Arch-Defines (gehoeren zur Mess-Schicht) und welche sind die eingemischten baked_perm_extra_cflags + simd-cflags? Zeige die Vermischung woertlich.
(3) Wird COMDARE_FACADE_PERM_EXTRA_CFLAGS UNKONDITIONAL an JEDE Tier-Binary gegeben (auch wenn der gewaehlte Allokator NICHT snmalloc ist)? Das waere der Kern-Defekt (snmalloc-Flags kontaminieren alle Binaries).
(4) Ist die Bedingung COMDARE_HAVE_SNMALLOC/TARGET comdare_vendor_snmalloc in CMake die einzige Gate, oder gibt es eine per-Permutation-Allokator-Gate?
NUR Kartierung, keine Edits.`,
  },
  {
    label: 'compiler-system-achse',
    prompt: `Read-only Kartierung der COMPILER-SYSTEM-ACHSE als Ziel-Heimat fuer reine Compiler-Flags (INC-0). Lies:
  ${CE}/libs/cache_engine/include/cache_engine/measurement/compiler_system_axis.hpp (GccCompilerAxis/ClangCompilerAxis: driver_default/supports_fno_gnu_unique/flags)
  ${CE}/libs/cache_engine/include/cache_engine/measurement/optimization_level_sub_axis.hpp (das Vorbild: opt_level-Unter-Achse traegt -O<n>-Flags je Dialekt)
  ${CE}/libs/cache_engine/include/cache_engine/measurement/simd_sub_axis.hpp (simd-Unter-Achse traegt -march je Dialekt -- das frische F-SIMD-Muster)
ZIEL, exakt datei:zeile:
(1) Wie traegt die Compiler-System-Haupt-Achse (compiler_system_axis.hpp) heute Flags? Hat sie schon Unter-Achsen (opt_level, simd) als parent? Welche Methoden (gcc_*/clang_*)?
(2) Ist -mcx16 ein Codegen-/ISA-Flag (128-bit CMPXCHG16B, x86-64) -- gehoert es semantisch zur Compiler-Achse (Flags) oder zur Hardware-ISA-Achse (INC-2d, isa)? Deep-Research-Einschaetzung: -mcx16 aktiviert eine ISA-Instruktion, ist aber ein Compiler-Flag. Wo ist der konforme Ort nach dem Freigabe-Prinzip (System-Achse gibt HW frei, Organ setzt durch)?
(3) Wenn -mcx16 eine neue Compiler-Unter-Achse oder ein Compiler-Achsen-Flag-Feld braucht: wie sieht das minimal-symmetrisch zu opt_level/simd aus (do_axis_label, parent_axis_label==compiler, gcc/clang/msvc-Flag)?
(4) binary_id-Neutralitaet: system_config-Flags stehen NIE in kCompositionAxisNames. Bleibt das bei -mcx16 gewahrt?
NUR Kartierung, keine Edits.`,
  },
  {
    label: 'golden-impact',
    prompt: `Read-only Kartierung des GOLDEN/MESS-IMPACTS der INC-0-Trennung (Risiko-Analyse). Kontext: heute gibt perm_mess_defines() die snmalloc-Defs + -mcx16 UNKONDITIONAL an jede Tier-Binary. INC-0 will das trennen: snmalloc-Defs -> Allokator-Organ-Achse (nur wenn snmalloc gewaehlt), -mcx16 -> Compiler-System-Achse.
Lies/grep im ${CE}:
(1) Welcher Allokator ist der golden-DEFAULT (der in den 320 golden-Binaries kompilierte)? Grep permutation_codegen_tool + golden-Fixtures + axis_06-Default. Ist es snmalloc oder ptmalloc2/std?
(2) WENN der golden-Default NICHT snmalloc ist: dann bekommen die golden-Binaries HEUTE trotzdem die snmalloc-Defs+-mcx16 (unkonditional) -- aendert deren Entfernung das Codegen/ABI/Verhalten der golden-Binaries? Oder sind die Defs no-ops wenn snmalloc nicht #included wird?
(3) WENN der golden-Default snmalloc IST: dann ist -mcx16 build-KRITISCH (CAS16) -- die Trennung muss sicherstellen, dass snmalloc-Binaries -mcx16 WEITER bekommen (ueber die Organ-Achse/Compiler-Achse), sonst Link/Run-Bruch.
(4) Beruehrt irgendetwas davon binary_id / golden==320 / kCompositionAxisNames? (allocator IST T6-Organ und binary_id-relevant -- aber die FLAGS sind es nicht.) Wo ist die Grenze?
Gib eine klare Risiko-Einschaetzung: ist die Trennung golden-neutral, oder gibt es einen Pfad, der die golden-Binaries veraendert/bricht?
NUR Kartierung, keine Edits.`,
  },
]

const maps = await parallel(readers.map(r => () => agent(r.prompt, { label: r.label, phase: 'Kartierung' })))

phase('Plan')

const PLAN_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['separation', 'golden_impact', 'edits', 'conformance_verdict', 'risks', 'open_decisions'],
  properties: {
    separation: {
      type: 'object', additionalProperties: false,
      required: ['to_organ_axis', 'to_compiler_system_axis', 'stays_measurement', 'rationale'],
      properties: {
        to_organ_axis: { type: 'array', items: { type: 'string' }, description: 'Was auf die Allokator-Organ-Achse wandert (snmalloc-Defs etc.)' },
        to_compiler_system_axis: { type: 'array', items: { type: 'string' }, description: 'Was auf die Compiler-System-Achse wandert (-mcx16 etc.)' },
        stays_measurement: { type: 'array', items: { type: 'string' }, description: 'Was in perm_mess_defines bleibt (echte Mess-/OS-/Arch-Defines)' },
        rationale: { type: 'string', description: 'Deep-Research-Begruendung inkl. -mcx16 Compiler-vs-ISA-Frage' },
      },
    },
    golden_impact: { type: 'string', description: 'golden-Default-Allokator + ob die Trennung golden==320/ABI/Verhalten neutral ist + warum' },
    edits: {
      type: 'array',
      items: {
        type: 'object', additionalProperties: false,
        required: ['file', 'anchor', 'change'],
        properties: { file: { type: 'string' }, anchor: { type: 'string' }, change: { type: 'string' } },
      },
    },
    conformance_verdict: { type: 'string', description: 'Ist der Plan konform zum Freigabe-Prinzip (System gibt frei / Organ setzt durch) + Haupt-Unter-Option + compile-time-only? Ja/Nein + Begruendung' },
    risks: { type: 'array', items: { type: 'string' } },
    open_decisions: { type: 'array', items: { type: 'string' }, description: 'Echte Entscheidungs-Forks fuer den User (z.B. -mcx16 auf Compiler- vs ISA-Achse), falls Doku keine eindeutige Antwort gibt' },
  },
}

const plan = await agent(
  `Du bist der Deep-Research-Architekt fuer INC-0. User-Ruling verbatim: "alle malloc sind Allokatoren auf der Allokator-Organ-Achse. Sie haben auf den Systemachsen nichts zu suchen. Die anderen Flags allerdings gehoeren auf die Compiler Achse der System-Achsen, bitte klar trennen. Bitte direkt beheben unter deep research."

Heute (der Defekt): profile_facade/CMakeLists.txt backt SNMALLOC-INTERFACE-Defs + -mcx16 in COMDARE_FACADE_PERM_EXTRA_CFLAGS; profile_run_facade.cpp perm_mess_defines() gibt sie UNKONDITIONAL an jede Tier-Binary (Mess-Pfad-Vermischung + snmalloc-Flags auf Nicht-snmalloc-Binaries).

Direktiven: Freigabe-Prinzip (System-Achse gibt HW-Ressource frei, Organ-Achse setzt durch; Organ <= System-Zulassung). compile-time-only (CRTP+Concept, keine vtable). binary_id-neutral (system_config nie in kCompositionAxisNames; allocator IST T6-Organ + binary_id-relevant, aber die FLAGS nicht). golden==320 messdaten-erhaltend. erst-additiv, Aufraeumen unter Absprache. F-SIMD (simd_sub_axis.hpp) ist das frische Muster fuer eine flag-tragende Achse.

Vier Kartierungen:

=== ALLOKATOR-ORGAN ===
${maps[0]}

=== FLAG-MISCHUNG ===
${maps[1]}

=== COMPILER-SYSTEM-ACHSE ===
${maps[2]}

=== GOLDEN-IMPACT ===
${maps[3]}

Erstelle den Deep-Research-Trennungsplan: (a) exakte Zuordnung jedes gebackenen Flags/Defs zu Organ-Achse / Compiler-System-Achse / bleibt-Mess; (b) golden-Impact-Verdikt (welcher Allokator ist golden-Default, ist die Trennung neutral); (c) geordnete Edits je datei:zeile; (d) Konformitaets-Verdikt zum Freigabe-Prinzip; (e) Risiken; (f) ECHTE offene Entscheidungs-Forks fuer den User NUR falls die Doku keine eindeutige Antwort gibt (speziell: gehoert -mcx16 auf die Compiler-Flags-Achse oder die Hardware-ISA-Achse INC-2d? begruende beide Optionen). Wenn eine Kartierung eine Luecke laesst, benenne sie explizit statt zu raten.`,
  { label: 'synthese', phase: 'Plan', schema: PLAN_SCHEMA, effort: 'high' }
)

return plan
