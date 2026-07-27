export const meta = {
  name: 'rf5-v36b-retire-merge-planung',
  description: 'RF-5/§71: V36.B-Codegen-CMake-Kanal untersuchen (was hat er, was fehlt) + Stand-der-Technik-Recherche + Retire+Merge-Bauplan unter Ein-Kanal-Praemisse',
  phases: [
    { title: 'Erhebung', detail: 'Alt-Kanal-Inventar + Neu-Kanal-Abdeckung + Stand der Technik' },
    { title: 'Merge-Plan', detail: 'Synthese: TEIL-V-Bauplan Retire+Merge' },
  ],
}

const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const COMMON = `Du bist ein Fable-5-xhigh-Agent der Diplomarbeit-Session (26.07.2026 spaet). super = ${SUPER}; ce = super/Code/external/comdare-cache-engine (HEAD dbc98fd6). REGELN: read-only (keine Edits/Commits); ASCII-Meldung (Paragraph erlaubt); jede Behauptung mit datei:zeile; UNGEPRUEFT ehrlich markieren; keine Secrets.
OWNER-ENTSCHEID §71 (bindend): Der aeltere V36.B-Codegen-CMake-Kanal wird RETIRED und in den neueren Kanal (Fassade / direkte C++23-Metaprogrammierung) GEMERGED. Praemissen: EIN Kanal je Achsen-Typ (Planer=Mess / CEB=System+Organ); CI==baremetal; leicht installierbar nach Stand der Technik + User-Manual; keine CMake-Umwege wo verhinderbar, Arbeit an den C++23-Compiler. Der #25-B-Byte-Vertrag des Alt-Kanals ist mit dem Retire abgeloest (Owner-GO liegt vor).`

phase('Erhebung')
const [altKanal, neuKanal, standDerTechnik] = await parallel([
  () => agent(`${COMMON}

STRANG A - ALT-KANAL-INVENTAR (V36.B-Codegen-CMake): Kartiere den Kanal VOLLSTAENDIG: (1) Bestandteile: cmake/isa_features.cmake (AVX-Zweige ~:117-161), builder/permutation_codegen_tool/permutation_codegen_tool.cpp (simd_flags ~:43-48, Emission ~:477-483), zugehoerige CMake-Targets, V36.B-Namensgebung (grep V36), die Byte-Identitaets-Tests (test_permutation_codegen_byte_identity_*, #25-B) und den GO-2-Vertrag (Ledger LED:458/540); (2) KONSUMENTEN: wer ruft den Kanal heute wirklich (CI-Jobs? lokale Targets? Tests only?) - literal per grep ueber CMakeLists/cmake/.gitlab-ci.yml/tools; (3) FAEHIGKEITEN-INVENTAR: was KANN der Kanal, aufgeschluesselt (welche Flags/Perms/Codegen-Leistungen), und je Faehigkeit: hat der NEUE Kanal (Fassade profile_run_facade + CompileFn + lazy_adhoc_source_gen + C++23-Metaprogrammierung) das AEQUIVALENT schon - mit Beleg-Paar (alt datei:zeile vs neu datei:zeile)? (4) WAS FEHLT UNS: Faehigkeiten des Alt-Kanals OHNE Neu-Kanal-Aequivalent (die Merge-Substanz) - ehrlich, auch wenn die Antwort 'nichts' ist (Owner-Vermutung: gruendlich ersetzt); (5) RETIRE-FOLGEN: welche Tests/Targets/CI-Zeilen fallen oder wandern; Byte-Folgen (was davon ist O-8-Fenster-pflichtig). MELDUNG: Inventar-Tabellen + Fehlt-Liste + Retire-Folgen-Liste.`, { label: 'alt-kanal-inventar', phase: 'Erhebung', effort: 'xhigh' }),

  () => agent(`${COMMON}

STRANG B - NEU-KANAL-ABDECKUNG + EIN-KANAL-PRAEMISSE: (1) Kartiere den NEUEN Kanal end-to-end: XML -> Planer (experiment_plan_director, Mess-Achsen-Konfiguration) -> CEB (profile_run_entry/profile_run_facade: System-Perm-Schleife, CompileFn make_gpp_compile_fn, Gate-Naht) -> Tier-Codegen (lazy_adhoc_source_gen, adhoc_emitter) - je Stufe datei:zeile; pruefe die Ein-Kanal-Praemisse: ist die Konfiguration heute WIRKLICH so verteilt (Planer=Mess / CEB=System+Organ) oder gibt es weitere Neben-Kanaele ausser V36.B (z.B. catalog_codegen, direkte CMake-option()-Schienen, .gitlab-ci-Matrix-Reste per RF-4 schon zum Archiv bestimmt)? Liste ALLE Konfigurations-Eintrittspunkte und klassifiziere: Haupt-Kanal / V36.B (retire) / sonstiger Neben-Kanal (benennen!). (2) CI==BAREMETAL-Gleichlauf: laeuft der Haupt-Kanal in beiden Umgebungen identisch (planer:delegate vs lokaler Aufruf) - Belege; wo divergiert es. (3) INSTALLIERBARKEIT heute: welche Toolchain braucht der Haupt-Kanal (Compiler-Version g++/clang, CMake-Minimum, ninja, xmllint, boost?) - aus CMakeLists/README/docs belegen; existiert ein User-Manual (README/docs) fuer 'Kanal anwenden' und was fehlt ihm. MELDUNG: Kanal-Karte + Neben-Kanal-Liste + Gleichlauf-Befund + Toolchain/Manual-Ist.`, { label: 'neu-kanal-abdeckung', phase: 'Erhebung', effort: 'xhigh' }),

  () => agent(`${COMMON}

STRANG C - STAND DER TECHNIK (Owner verlangt Web-Recherche): Recherchiere per WebSearch/WebFetch den aktuellen Stand der Technik (2025/2026) fuer die zwei Owner-Praemissen: (1) 'leicht installierbar': Was ist heute der sauberste Weg, eine C++23-Toolchain (GCC 14/15/16, Clang 18-21) + Build-Frontend reproduzierbar auf Ubuntu/Debian-Servern UND in CI-Containern bereitzustellen (Distro-Pakete vs toolchain-Container vs apt.llvm.org/ppa; Pin-Strategien) - mit Blick auf die vorhandene Flotte (Ubuntu-Baremetal prod1/prod2 mit g++-16, 7 buildtools-Docker-Distros)? (2) 'Arbeit an den Compiler statt CMake-Codegen': Welche C++23/26-Metaprogrammierungs-Techniken ersetzen heute klassische Build-Zeit-Codegen-Schritte (consteval/constinit, NTTP, mp11-artige Typlisten, static reflection P2996-Status, #embed/std::embed-Status, deducing this) - was ist in GCC 16/Clang 21 REAL nutzbar (Feature-Status belegen), was bleibt Zukunft? (3) Kurz: Best Practice fuer 'ein Werkzeug, ein Manual' (CLI-UX-Konventionen fuer Forschungs-Tools). WICHTIG: Nur oeffentliche Quellen, URLs nennen; KEINE Projekt-Interna in Suchanfragen (generische Begriffe wie 'C++23 consteval codegen replacement', 'GCC 16 feature status', nie Projekt-/Firmennamen). MELDUNG: je Punkt Empfehlung + Quellen-URLs + was davon fuer unsere Flotte direkt passt.`, { label: 'stand-der-technik-web', phase: 'Erhebung', effort: 'xhigh' }),
])

phase('Merge-Plan')
const mergePlan = await agent(`${COMMON}

SYNTHESE - RETIRE+MERGE-BAUPLAN (TEIL-V-Entwurf, direkt anhaengbar ans Bauplan-Doc). Eingaben:

=== STRANG A (Alt-Kanal) ===\n${typeof altKanal === 'string' ? altKanal : JSON.stringify(altKanal)}\n
=== STRANG B (Neu-Kanal) ===\n${typeof neuKanal === 'string' ? neuKanal : JSON.stringify(neuKanal)}\n
=== STRANG C (Stand der Technik) ===\n${typeof standDerTechnik === 'string' ? standDerTechnik : JSON.stringify(standDerTechnik)}\n
LIEFERE als reine Meldung (keine Datei schreiben): (1) VERDIKT zur Owner-Vermutung ('gruendlich durch C++23-Metaprogrammierung ersetzt') - bestaetigt/widerlegt mit der Fehlt-Liste; (2) TEIL-V-ENTWURF als fertiger Markdown-Text: Retire+Merge-Pakete in bindender Reihenfolge (je Paket: Ziel, Dateien, Byte-Klasse byte-neutral/O-8-Fenster, Gates, Besitzer-Vorschlag), inkl. Behandlung der Byte-Identitaets-Tests und des abgeloesten #25-B-Vertrags (Doku-Vermerk, nie loeschen), Neben-Kanal-Behandlung (falls Strang B weitere fand: je Kanal Vorschlag retire/merge/behalten mit Begruendung - NICHT eigenmaechtig entscheiden, als Owner-Punkt kennzeichnen wo noetig), Toolchain-/Manual-Paket (Stand-der-Technik-Empfehlung aus C auf die Flotte gemappt; User-Manual-Gliederung), CI==baremetal-Gleichlauf-Gates; (3) RESTFRAGEN an den Owner (nur echte). ASCII-only, Selbstcheck-Zeile.`, { label: 'merge-plan-synthese', phase: 'Merge-Plan', effort: 'xhigh' })

return { altKanal, neuKanal, standDerTechnik, mergePlan }