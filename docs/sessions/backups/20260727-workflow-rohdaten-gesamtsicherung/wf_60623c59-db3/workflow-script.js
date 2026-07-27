export const meta = {
  name: 'inc-0-nach-pruefung',
  description: 'NACH-Pruefung INC-0: adversariale Lenses gegen den gelandeten Zustand (Korrektheit/Byte-Neutralitaet + Konformitaet/Gate-Sicherheit) + Verdikt',
  phases: [
    { title: 'Adversarial', detail: '2 Lenses versuchen INC-0 zu widerlegen' },
    { title: 'Verdikt', detail: 'Richter: bestaetigte Defekte oder COMMIT_OK' },
  ],
}

const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'

phase('Adversarial')

const FIND_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['defects', 'lens_verdict'],
  properties: {
    defects: {
      type: 'array',
      items: {
        type: 'object', additionalProperties: false,
        required: ['severity', 'file_line', 'claim', 'evidence'],
        properties: {
          severity: { type: 'string', enum: ['KRITISCH', 'MITTEL', 'GERING', 'HINWEIS'] },
          file_line: { type: 'string' },
          claim: { type: 'string' },
          evidence: { type: 'string' },
        },
      },
    },
    lens_verdict: { type: 'string' },
  },
}

const lenses = [
  {
    label: 'korrektheit-byteneutral',
    prompt: `Adversariale NACH-Pruefung INC-0 (Lens 1: KORREKTHEIT + BYTE-NEUTRALITAET). Commit ce 01748163 (Schritt 2) + e5eb990f (Schritt 1). Die Aenderung trennt in profile_run_facade.cpp die frueher in perm_mess_defines() FLACH gemischten Flags in getrennte, achsen-gespeiste Kanaele.
Lies ${CE}/libs/cache_engine/profile_facade/profile_run_facade.cpp (perm_mess_defines / perm_alloc_organ_cflags / perm_compiler_isa_cflags / perm_compile_flags / die 3 CompileFn-Naehte) + ${CE}/libs/cache_engine/axes/alloc/axis_06_allocator_snmalloc.hpp (vendor_compile_defs) + ${CE}/libs/cache_engine/include/cache_engine/measurement/compiler_atomic_sub_axis.hpp (Cx16Option).
VERSUCHE ZU WIDERLEGEN:
(1) Liefert perm_compile_flags() bei USE_SNMALLOC=1 GENAU dieselben Flags wie der alte Bake (4x SNMALLOC_*-Defs + -mcx16)? Vergleiche vendor_compile_defs() woertlich gegen die alten CMake-Bake-Werte (CMakeLists.txt:164-169). Fehlt eine Def? Ist die Reihenfolge/Anzahl gleich?
(2) Byte-Neutralitaet bei USE_SNMALLOC=0 (conf/go2): sind BEIDE neuen Kanaele dann wirklich leer ({})? Pruefe die #if-Gates. Kann ein Pfad die Flags doch emittieren?
(3) Doppel-Emission: wird IRGENDEIN Flag jetzt DOPPELT angehaengt (alter Bake NOCH konsumiert + neuer Kanal)? Grep, ob baked_perm_extra_cflags() noch aufgerufen wird.
(4) Alle 3 CompileFn-Naehte (a.compile Einzel + compile_for_perm-Lambda + Fallback) auf perm_compile_flags() umgestellt, oder blieb eine auf perm_mess_defines() (dann fehlen dort die Achsen-Flags)?
Melde JEDEN echten Defekt mit datei:zeile.`,
  },
  {
    label: 'konformitaet-gate',
    prompt: `Adversariale NACH-Pruefung INC-0 (Lens 2: KONFORMITAET + GATE-SICHERHEIT). Direktiven: malloc->Organ-Achse, Flags->Compiler-System-Achse; Freigabe-Prinzip; das Gate MUSS global (COMDARE_AXIS_06_USE_SNMALLOC) sein, NIE per-Tier-Allokatorwahl (sonst brechen Nicht-snmalloc-Tiers am ds/aba.h #error); compile-time-only; binary_id-neutral; -mcx16 auf Compiler-Achse (nicht extension_hardware, weil Baseline-x86-64).
Lies ${CE}/libs/cache_engine/profile_facade/profile_run_facade.cpp + ${CE}/libs/cache_engine/include/cache_engine/measurement/compiler_atomic_sub_axis.hpp + ${CE}/libs/cache_engine/axes/alloc/axis_06_allocator_snmalloc.hpp + ${CE}/tests/unit/test_striktheit_axis_dach_guard.cpp (Block K).
VERSUCHE ZU WIDERLEGEN:
(1) GATE-FALLE (Kern-Risiko): gaten perm_alloc_organ_cflags() + perm_compiler_isa_cflags() wirklich auf das GLOBALE COMDARE_AXIS_06_USE_SNMALLOC (nicht auf eine per-Perm/per-Tier-Allokatorwahl)? Ein per-Tier-Gate waere KRITISCH.
(2) -mcx16-Heimat: haengt Cx16Option wirklich unter parent_axis_label()=="compiler" (nicht extension_hardware)? Ist die Baseline-vs-Extension-Begruendung im Header haltbar, oder ist -mcx16 doch ein extension_hardware-Fall (widerspraeche es dem F-SIMD-Praezedenzfall)?
(3) compile-time-only + binary_id-neutral: sind CompilerAtomicSubAxis + vendor_compile_defs() constexpr/CRTP+Concept, keine vtable? Steht "atomic128" NICHT in kCompositionAxisNames (golden==320)?
(4) x86_64-Gate: ist -mcx16 wirklich zusaetzlich auf COMDARE_ARCH_X86_64 gegated (ARM64 darf -mcx16 NICHT bekommen)?
(5) Freigabe-Prinzip sauber umgesetzt (System gibt frei / Organ erzwingt), oder nur behauptet?
Melde JEDEN echten Konformitaets-Verstoss mit datei:zeile. Unterscheide NEUER-Defekt von Bestand.`,
  },
]

const findings = await parallel(lenses.map(l => () => agent(l.prompt, { label: l.label, phase: 'Adversarial', schema: FIND_SCHEMA, effort: 'high' })))

phase('Verdikt')

const VERDICT_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['confirmed_defects', 'dismissed', 'overall_verdict', 'action'],
  properties: {
    confirmed_defects: {
      type: 'array',
      items: {
        type: 'object', additionalProperties: false,
        required: ['severity', 'file_line', 'defect', 'fix'],
        properties: {
          severity: { type: 'string', enum: ['KRITISCH', 'MITTEL', 'GERING'] },
          file_line: { type: 'string' }, defect: { type: 'string' }, fix: { type: 'string' },
        },
      },
    },
    dismissed: { type: 'array', items: { type: 'string' } },
    overall_verdict: { type: 'string', enum: ['COMMIT_OK', 'NACHBESSERN'] },
    action: { type: 'string' },
  },
}

const verdict = await agent(
  `Konformitaets-Richter der NACH-Pruefung INC-0. Zwei adversariale Lenses haben versucht, INC-0 zu widerlegen. Bewerte JEDEN Befund: echter NEUER Defekt dieses Commits (-> confirmed + Fix), Bestand ausserhalb Scope (-> dismissed mit Grund), oder unbegruendet (-> dismissed).

Kontext (verifiziert): ce-standalone 275/275 (USE_SNMALLOC=0 inert), super-Sub(clang, USE_SNMALLOC=1) Facade baut + profile-Tests 3/3, golden==320, cf22 CLEAN, Mojibake 0. Direktiven: Doku-nie-loeschen (Deprecate-statt-Delete korrekt), Aufraeumen-unter-Absprache (Bake+baked_perm_extra_cflags additiv belassen ist gewollt), -mcx16->Compiler-Achse aus User-INC-0-Ruling + Baseline-Semantik.

LENS 1 (Korrektheit/Byte-Neutral): ${JSON.stringify(findings[0])}

LENS 2 (Konformitaet/Gate): ${JSON.stringify(findings[1])}

Gib das Gesamt-Verdikt: COMMIT_OK oder NACHBESSERN (mit priorisierter Fix-Liste). Nur ECHTE belegte Defekte dieses Commits fuehren zu NACHBESSERN.`,
  { label: 'richter', phase: 'Verdikt', schema: VERDICT_SCHEMA, effort: 'high' }
)

return verdict
