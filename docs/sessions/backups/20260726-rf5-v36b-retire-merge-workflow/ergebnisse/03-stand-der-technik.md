MELDUNG STRANG C - STAND DER TECHNIK (Web-Recherche 26.07.2026, nur oeffentliche Quellen, generische Suchbegriffe)

== (1) 'Leicht installierbar': C++23-Toolchain reproduzierbar auf Ubuntu/Debian + CI ==

Faktenlage:
- GCC 16.1 ist seit 30.04.2026 released (major release, C++20 jetzt Default-Dialekt; C++26-Teile experimentell). Quellen: https://gcc.gnu.org/gcc-16/ , https://lists.gnu.org/archive/html/info-gnu/2026-04/msg00013.html , https://lwn.net/Articles/1070649/ , https://isocpp.org/blog/2026/04/gcc-16.1
- Ubuntu 24.04 liefert default GCC 13, Archiv bis gcc-14; GCC 15/16 kommen auf Ubuntu offiziell nur ueber das Toolchain-PPA ppa:ubuntu-toolchain-r/test (versionierte Pakete g++-16 parallel installierbar). Quellen: https://launchpad.net/~ubuntu-toolchain-r/+archive/ubuntu/test , https://linuxcapable.com/how-to-install-gcc-compiler-on-ubuntu-linux/
- Clang: apt.llvm.org ist der offizielle Kanal fuer Debian/Ubuntu (versionierte Pakete clang-21 usw., Script llvm.sh; Branches derzeit 21/22/23 laut Seite - welcher davon 'stable' heisst: UNGEPRUEFT). Quelle: https://apt.llvm.org/
- Container: offizielles Docker-Image `gcc` (Docker Hub) hat Tags 16.1.0/16.1/16 und 15.3.0 auf Debian-trixie/bookworm-Basis. Quelle: https://hub.docker.com/_/gcc
- Reproduzierbarkeit: Stand der Technik ist Digest-Pinning (@sha256) statt mutabler Tags fuer CI-/Prod-Images, plus Paketversions-Pinning, plus automatisierte Digest-Updates via Renovate/Dependabot. Quellen: https://how2.sh/posts/how-to-devops-pin-docker-base-images/ , https://oneuptime.com/blog/post/2026-02-08-how-to-build-reproducible-docker-images-with-locked-dependencies/view , https://edu.chainguard.dev/chainguard/chainguard-images/how-to-use/container-image-digests/
- Build-Frontend: Konsens ist CMake>=3.19 mit CMakePresets.json (Generator+Toolchain+Buildtype vollstaendig im Preset, Basis-Presets hidden) + Ninja. Quellen: https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html , https://softwarecraft.ch/cmake-presets-best-practices/

Empfehlung fuer unsere Flotte: Baremetal (prod1/prod2, g++-16 vorhanden) beim Toolchain-PPA mit versionierten Binaries bleiben und die exakte Paketversion dokumentieren/apt-pinnen (das PPA heisst ausdruecklich 'test builds', Pakete sind mutabel). CI==baremetal erreicht man am saubersten, indem die 7 buildtools-Docker-Images den IDENTISCHEN Installationsweg nutzen (gleiche apt-Quellen/PPA bzw. apt.llvm.org, gleiche Versionsnummern) und per Digest gepinnt werden; zusaetzlich Compiler-Version im Build-Frontend hart asserten (CMake prueft CMAKE_CXX_COMPILER_VERSION). Das offizielle gcc-Docker-Image ist die Alternative fuer reine CI-Container, bricht aber die CI==baremetal-Praemisse (Debian-Basis statt Ubuntu-Baremetal) - daher nur zweite Wahl.

== (2) 'Arbeit an den Compiler statt CMake-Codegen': was ist REAL nutzbar ==

REAL heute, portabel ueber GCC UND Clang (belegt via https://gcc.gnu.org/projects/cxx-status.html und https://clang.llvm.org/cxx_status.html ):
- Deducing this (P0847): GCC 14+, Clang 18+.
- if consteval / consteval-Propagation (P2564): GCC 14, Clang 14+ (Basisform frueher; exakte P1938-Erstversion UNGEPRUEFT).
- static operator() (P1169): GCC 13, Clang 16.
- #embed (P1967, C++26; als Extension auch in aelteren Modi): GCC 15+, Clang 19+ (Clang 19 implementierte C23-#embed als erster). Ersetzt xxd/Codegen-Schritte fuer Binaerdaten direkt im Compiler. std::embed (P1040) ist eingefroren/abgeloest - #embed ist der kanonische Weg. Quellen: https://www.phoronix.com/news/LLVM-Clang-19-C23-Embed , https://releases.llvm.org/19.1.0/tools/clang/docs/ReleaseNotes.html , https://github.com/cplusplus/papers/issues/28 , https://en.cppreference.com/cpp/preprocessor/embed
- Pack indexing (P2662): GCC 15, Clang 19 - reduziert klassische Typlisten-Gymnastik.
- constexpr placement new (P2747): GCC 15, Clang 20.
- NTTP mit strukturellen Klassentypen: etabliertes C++20 (Erstversionen UNGEPRUEFT, in GCC14/Clang18 unstrittig vorhanden).

NUR GCC 16 (experimentell), NICHT in Mainline-Clang 18-21:
- Static Reflection P2996: GCC 16.1 via -std=c++26 -freflection (experimentell, keine Rueckwaertskompatibilitaets-Garantie); Clang mainline: Nein (nur Bloomberg-Fork clang-p2996); MSVC: nichts. Quellen: https://gcc.gnu.org/gcc-16/changes.html , https://github.com/bloomberg/clang-p2996 , https://isocpp.org/blog/2026/04/gcc-16.1
- Expansion statements 'template for' (P1306): GCC 16; Clang erst 23 partial (Zukunft). Quelle: https://clang.llvm.org/cxx_status.html
- Contracts (P2900): GCC 16 experimentell; Clang: Nein.

Empfehlung: Der portable Ersatz fuer Build-Zeit-Codegen ist heute die Kombination consteval/constexpr-Funktionen + NTTP + Typlisten (Boost.Mp11 bleibt die Referenzbibliothek dafuer: https://www.boost.org/doc/libs/develop/libs/mp11/ ) + #embed fuer Daten. P2996-Reflection und template-for koennen auf der g++-16-Flotte (prod1/prod2) real benutzt werden, sind aber (a) experimentell mit explizitem Bruch-Vorbehalt und (b) nicht Clang-portabel - fuer den gemergten Fassaden-Kanal also nur einsetzen, wenn die Doktrin Ein-Compiler (g++-16) ist; sonst C++23-Floor + Mp11-Muster und Reflection als spaeterer Drop-in.

== (3) 'Ein Werkzeug, ein Manual': CLI-UX ==

De-facto-Standard ist clig.dev (Command Line Interface Guidelines): ein Binary mit Subcommands, --help auf jeder Ebene, Mensch-lesbare Ausgabe default + maschinenlesbar per Flag (--json), Daten auf stdout / Meldungen auf stderr, klare Exit-Codes, Konfig-Praezedenz Flags > Env > Datei. Quellen: https://clig.dev/ , https://github.com/cli-guidelines/cli-guidelines
Fuer unsere Flotte direkt passend: Planer und CEB jeweils als EIN Binary mit Subcommands und einem Manual je Werkzeug erfuellt die Owner-Praemisse 'ein Kanal je Achsen-Typ' auch auf UX-Ebene; CSV/XML-Ausgaben auf stdout, Diagnostik auf stderr, Versions-/Toolchain-Selbstauskunft per --version.

UNGEPRUEFT-Sammelliste: apt.llvm.org-Stable-Branch-Nummer im Juli 2026; P1938-Erstversionen; NTTP-Erstversionen; alle Feature-Angaben stammen aus den zitierten Status-Seiten (Sekundaer-Fetch), nicht aus eigenen Compile-Tests auf prod1/prod2.