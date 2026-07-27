export const meta = {
  name: 'kartierung-265-foundation-vendoring',
  description: 'Fresh-context-Kartierung für #265: comdare-simd/platform aus foundation-all in die cache-engine vendorn (E-A-Default)',
  phases: [{ title: 'Kartierung', detail: '3 parallele read-only-Kartierer' }],
}

const FND = '/home/comdare/Projekte/Modules/comdare-foundation-all/comdare-baseline_0-foundation'
const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'

const SCHEMA = {
  type: 'object',
  properties: {
    befunde: { type: 'array', items: { type: 'string' }, description: 'Kernbefunde mit datei:zeile-Belegen' },
    dossier_bausteine: { type: 'array', items: { type: 'string' }, description: 'Konkrete Vorgaben für das Codex-Dossier (Pfade, APIs, Verbote, DoD)' },
    risiken: { type: 'array', items: { type: 'string' } },
  },
  required: ['befunde', 'dossier_bausteine', 'risiken'],
}

phase('Kartierung')
const [quelle, ziel, konsumenten] = await parallel([
  () => agent(`Kartiere READ-ONLY die QUELL-Zellen für #265-Vendoring:
1. ${FND}/comdare-simd/ — VOLLSTÄNDIG: CMakeLists.txt, alle Header (include-Layout, namespace, Alias), buildsystem.xml, tests/-Struktur, Abhängigkeit zu comdare-platform (welche Form: find_package? Pfad? konditional?)
2. ${FND}/comdare-platform/ — VOLLSTÄNDIG analog (SIMDDetect/CPUFeatures/cpuid — exakte Header-Liste + API-Oberfläche)
3. Gibt es weitere intra-baseline_0-Kanten (threading→platform)? Welche externen Deps (GTest-Version, Boost)?
4. git-Stand beider Zellen-Repos (log -3, Branch, Remotes — sind das eigene nested Repos oder Ordner im Umbrella?).
WICHTIG: Diese Klone sind die RESTAURIERTEN Matrix-Klone (GitHub-Vollstand) — verifiziere via git log, dass sie nicht der drift-veraltete Stand sind. Antworte auf Deutsch.`, { label: 'quelle-foundation', phase: 'Kartierung', schema: SCHEMA }),

  () => agent(`Kartiere READ-ONLY das VENDORING-ZIEL im cache-engine-Monolithen ${CE}:
1. Das etablierte ext/-Vendor-Muster: ls ext/ (Struktur je Vendor-Baum), wie ist ext/allocator/A04-mimalloc committed (vendored) vs. ext/queuing/Q01 (Submodul)? Wie bindet CMake ext/ ein (grep ext/ CMakeLists.txt + cmake/)? Wie ist der vendor/.clang-format-DisableFormat-Schutz umgesetzt (hdr_histogram_wrapper-Muster)?
2. Wo würden comdare-simd/comdare-platform-Vendor-Bäume liegen (Empfehlung nach Bestand: ext/foundation/? libs/common/platform/? — es existiert libs/common/platform/isa_dispatch NUR mit CMakeLists laut W-Befund: prüfen was drin ist und ob das der geplante Andockpunkt ist)
3. Verbote prüfen: keine internen HTTP-FetchContent-Fallbacks (baseline-system.md:299-Regel), Boost.MP11-prerequisites-Muster als offizieller Offline-Weg.
4. Wie viele CMake-Targets/Includes müssten angefasst werden, damit comdare::simd/comdare::platform als INTERFACE-Targets im ce-Build verfügbar sind (minimal-invasiv)? Antworte auf Deutsch mit Belegen.`, { label: 'ziel-ce-ext', phase: 'Kartierung', schema: SCHEMA }),

  () => agent(`Kartiere READ-ONLY die KONSUMENTEN in ${CE}, die #265 entsperrt:
1. AP-13-Rest/#270b "3-ISA-Matrix ← blockiert von #265": grep nach AP-13/ISA-Matrix in docs/sessions + libs (was genau braucht die 3-ISA-Matrix von comdare::simd?)
2. AP-3 IPlatformProbe (04.07. gelandet): wo lebt es (libs/cache_engine/... platform_probe), welche Follow-ups nennt der Ledger/die Session-Docs ("schließt AP-3-Follow-ups")?
3. axis_09/axis_09b (isa-Achse, AUTORITATIV per D2): welche eigenen cpuid-/Feature-Flags-Implementierungen dort würden durch comdare::platform-Konsum ersetzbar (NICHT jetzt umbauen — nur kartieren, 7b-3-Bezug)?
4. Duplikat-Check: existiert im ce bereits SIMD-/CPUID-Detection-Code, der mit comdare-platform kollidiert (grep cpuid/__cpuid/getauxval in libs/)? Antworte auf Deutsch mit datei:zeile.`, { label: 'konsumenten-ce', phase: 'Kartierung', schema: SCHEMA }),
])

return { quelle, ziel, konsumenten: konsumenten }