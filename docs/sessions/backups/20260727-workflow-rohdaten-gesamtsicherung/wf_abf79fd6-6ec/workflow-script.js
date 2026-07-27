export const meta = {
  name: 'inc2copt-planung',
  description: 'Bau-INC-2c.opt (Option A) planen: Optimierungsstufe als Hardware-System-Achse-Flag Richtung -O3, gegen Ledger+Pläne+Ist-Code',
  phases: [
    { title: 'Erfassen', detail: '4 parallele Kartierer' },
    { title: 'Bauplan', detail: 'Dossier-Synthese' },
  ],
}
const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const LEDGER = SUPER + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'
const BK = SUPER + '/docs/sessions/backups/20260717-inc1-bauplan'
const SCHEMA = {
  type: 'object', additionalProperties: false,
  properties: {
    ist_fakten: { type: 'array', items: { type: 'string' }, description: 'Verifizierte Ist-Fakten mit datei:zeile' },
    plan_vorgaben: { type: 'array', items: { type: 'string' }, description: 'Bindende Plan-/Ledger-/Direktiven-Vorgaben mit Quelle (§/datei:zeile)' },
    andockpunkte: { type: 'array', items: { type: 'string' }, description: 'Konkrete Code-Nähte, an denen Option A ansetzt (datei:zeile)' },
    risiken_tabus: { type: 'array', items: { type: 'string' }, description: 'TABUs/Risiken/Fallen für diese Änderung' },
    offene_fragen: { type: 'array', items: { type: 'string' }, description: 'Was NICHT aus Doku/Code auflösbar ist (nur echt-leere Suche)' },
  },
  required: ['ist_fakten','plan_vorgaben','andockpunkte','risiken_tabus','offene_fragen'],
}
const COMMON = `Du bist Kartierer für die Planung von Bau-INC-2c.opt (Option A, User-Ruling 2026-07-17): die Compiler-OPTIMIERUNGSSTUFE (Richtung -O3) soll ein HARDWARE-SYSTEM-ACHSE-Flag werden — statt hartkodiert -O2 in build_orchestrator.hpp:476 — angewandt an (1) die CompileFn-Naht (baut die Mess-Tier-Binaries) und (2) die mess-charakteristischen Verifikations-Test-Targets (test_all19_segment_timer misst Cache-Line-Layout, nur unter Optimierung >5% sichtbar). WICHTIG (User-Klärung): die Compiler-Achsen-5% (verschiedene Compiler-Binaries gcc|clang → bis 5% Delta gegen dieselbe Achsenkonfig) ist eine SEPARATE Sache über die Compiler-System-Achse — NICHT die memory_layout-5% des Layout-Checks. Regeln: NIEMALS raten — jede Aussage mit datei:zeile oder §-Beleg. Nutze Read/Grep/Bash im ce (${CE}) + super (${SUPER}).`
phase('Erfassen')
const dims = [
  { key: 'ledger-direktiven', prompt: `Lies ${LEDGER} §18 + §19 + §20 (System-Achsen-Design, die 6 CEB-System-Achsen inkl. Hardware/ISA + Erweiterungshardware + Compiler, Q2-C-Ruling, das frische Option-A-Ruling + die neue "nie raten/ultracode-zuerst"-Direktive). Extrahiere die BINDENDEN Vorgaben für Option A: Wie ist die Optimierungsstufe architektonisch einzuordnen (welche der 6 System-Achsen)? Gehört die Optimierungsstufe zur Hardware/ISA-Achse, zur Erweiterungshardware-Achse (Q2-C SIMD), oder zur Compiler-Achse? Was sagt der Ledger über die CompileFn-Naht + H-10-Sidecar-Provenienz (System-Achsen NIE in binary_id)?` },
  { key: 'inc1-bauplan', prompt: `Lies die Dateien in ${BK}/ (INC-1-Bauplan: die 6 CEB-System-Achsen, insbesondere die Hardware/ISA-Achse + Erweiterungshardware-Achse Q2-C + perm_extension_hardware_cflags-Design + die CompileFn-Naht). Wie hat INC-1d die Erweiterungshardware-Flags (-march/-mavx) an die CompileFn angedockt? Wo ist die "Naht", an der System-Achse-Flags in die Compile-Kette gehen? Ist die Optimierungsstufe dort schon vorgesehen oder eine Lücke? Belege mit den Bauplan-Abschnitten.` },
  { key: 'ist-compilefn-registry', prompt: `Kartiere im ce-Code den IST-Zustand: (a) build_orchestrator.hpp make_gpp_compile_fn (~466-482) — die hartkodierte -O2-Zeile + wie -fno-gnu-unique/Dialekt-Gate (INC-1h) + perm_extension_hardware_cflags angedockt sind; (b) profile_run_facade.cpp perm_extension_hardware_cflags() (~116) + wo es konsumiert wird (~156); (c) axis_library_registry.hpp Achse 15.2 (Optimization O0-O3) + 15.5 (Target-Arch -march) — sind das nur DATEN (Registry-Einträge) oder verdrahtet? (d) HardwareIsaSystemAxis / ExtensionHardwareSystemAxis (INC-1d) — tragen die schon eine Optimierungsstufe? Zeige die exakten Nähte (datei:zeile), an denen Option A die Optimierungsstufe einhängen würde.` },
  { key: 'ist-ctest-flags', prompt: `Kartiere, wie die ctest-Verifikations-Test-Targets im ce ihre Compile-Flags bekommen: (a) CMAKE_CXX_FLAGS / CMAKE_BUILD_TYPE in ${CE}/build-conf/CMakeCache.txt (ist es unoptimiert/-O0?); (b) wie test_all19_segment_timer + die anderen Segment-Timer-Tests in tests/unit/CMakeLists.txt definiert werden (add_executable/target_compile_options); (c) gibt es eine bestehende zentrale CMake-Funktion für per-Target-Optimierungs-/Hardware-Flags? Zeige den saubersten Andockpunkt, um mess-charakteristische Test-Targets unter der Hardware-Achse-Optimierungsstufe (-O3) zu bauen — OHNE die gesamte Suite zu ändern.` },
]
const results = await parallel(dims.map(d => () =>
  agent(`${COMMON}\n\nDIMENSION: ${d.prompt}`, { label: d.key, phase: 'Erfassen', schema: SCHEMA })
))
phase('Bauplan')
const valid = results.filter(Boolean)
const dossier = await agent(`Du bist der Bauplan-Architekt für Bau-INC-2c.opt (Option A). Hier die 4 Kartierungen (Ledger-Direktiven / INC-1-Bauplan / Ist-CompileFn+Registry / Ist-ctest-Flags):\n\n${JSON.stringify(valid, null, 1)}\n\nErzeuge ein BAUPLAN-DOSSIER (Markdown, ~80-120 Zeilen) für Option A: die Optimierungsstufe (Richtung -O3) als Hardware-System-Achse-Flag. Struktur: (1) ZWECK + Abgrenzung (Layout-5% ≠ Compiler-5%); (2) ARCHITEKTONISCHE VERORTUNG — zu welcher der 6 System-Achsen gehört die Optimierungsstufe? (belegt, nicht geraten); (3) IST-Nähte (CompileFn -O2 hartkodiert + ctest unoptimiert, mit datei:zeile); (4) SOLL — konkrete Mini-Increment-Schritte (2c.opt-a, -b, ...) je mit Andockpunkt + Verifikation; (5) Reihenfolge + Gates (dual-grün, cf22, golden-neutral); (6) TABUS/Risiken; (7) OFFENE FRAGEN (nur wenn echt nicht aus Doku/Code auflösbar — sonst leer). Sei streng planbasiert: wenn die architektonische Verortung nicht eindeutig aus Ledger+Bauplan folgt, markiere sie als User-Entscheidungs-Fork (Klartext, KEINE Erfindung).`, { label: 'bauplan-dossier', phase: 'Bauplan' })
return { dossier, kartierer_ok: valid.length }