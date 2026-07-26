MELDUNG SYNTHESE - RETIRE+MERGE-BAUPLAN (TEIL-V-Entwurf, §71). Read-only eingehalten; Kern-Anker der Straenge live nachgeprueft (Spot-Greps 26.07. spaet): ce CMakeLists.txt:33 (Option OFF), super Code/CMakeLists.txt:90-102 (V36.B-Default ON inkl. PRT-ART-Zwilling), super Code/02_messung_driver/main.cpp:641 (ungegatetes Startgate), ce ext/CMakeLists.txt:17-19/:57/:123 (Vendor-Defaults = ${COMDARE_BUILD_PERMUTATIONS}), ce tests/unit/CMakeLists.txt:3787-3803 (byte-identity-Tests), super .gitlab-ci.yml:370-371 (Manifest-Pflicht hart), ce CMakeLists.txt:569-590 (globales USE-Baking + link_libraries). Alle uebrigen datei:zeile-Anker stammen aus Strang A/B/C und sind dort als literal geprueft bzw. UNGEPRUEFT markiert.

== (1) VERDIKT ZUR OWNER-VERMUTUNG ==

BESTAETIGT MIT AUFLAGEN. Der Kern des Alt-Kanals ist im neuen Fassaden-Kanal gruendlich und durchweg feiner ersetzt: Enumeration (17 Achsen lazy statt 5, ce libs/cache_engine/profile_facade/lazy_adhoc_source_gen.hpp:2-24), Host-ISA-Gate (profile_run_entry.hpp:206-209/:759), SIMD-Flag-Emission single-source in der Achse (simd_sub_axis.hpp:71-87, zeichengleich belegt test_c3b_kanal_merge_beleg.cpp:16-24/:81-96), Quell-Emission (adhoc_emitter.hpp:84), selective rebuild organ-genau (build_orchestrator.hpp:245-287), Allokator-Breite 26+ statt 7 (axes/alloc/, profile_run_facade.cpp:133-149). Der Direkt-Compile ohne CMake (make_gpp_compile_fn, build_orchestrator.hpp:717) erfuellt die Praemisse "Arbeit an den C++23-Compiler" architektonisch besser als der Alt-Kanal. FEHLT-LISTE (vollstaendig, 5 Punkte): F1 SIMD-Zellen sse4.2/neon fehlen der neuen System-Achse (simd_sub_axis.hpp:98-99 nur no_extension/avx2/avx512 vs Tool :391/:403-413) - Owner-Punkt. F2 Vendor-Allokator-Provisioning haengt am Retire-Flag (ext/CMakeLists.txt:17-19/:57/:123/:158/:179/:202) - harte Merge-Substanz, MUSS vor Retire entkoppelt werden. F3 Configure-Zeit-Bestandsinventar (permutations_manifest.txt) hat 3 lebende Konsumenten (main.cpp:641; super .gitlab-ci.yml:370-371; Code/CMakeLists.txt:276-289) - harte Merge-Substanz. F4 MSVC/Windows-Bauweg existiert im neuen Builder nicht (build_orchestrator.hpp:699 nur Kommentar) - Owner-Punkt, unter CI==baremetal(Linux) verschmerzbar. F5 perm_<id>_run-Vergleichsfaehigkeit (COMDARE_LEGACY_MESSREIHEN, LED:536 B2) endet faktisch - nur Verbuchung noetig, §71 deckt ab.

== (2) TEIL-V-ENTWURF (direkt anhaengbar) ==

# TEIL V - RETIRE+MERGE V36.B-CODEGEN-CMAKE-KANAL -> FASSADEN-KANAL (Owner-Entscheid §71, O-8-Vorab-GO §72 LED:3545-3547)

FRIST-KLAMMER: V-1..V-4 sind Bau-Arbeit; die Mo-27.07.-CSV-Kette (erste CSV auf NAS) haengt am heutigen Startgate main.cpp:641. V-2 und V-3 duerfen NICHT vor der Mo-CSV-Landung scharf werden, ausser sie landen in EINEM Zug mit Doppel-Verifikation (Treiber-Lauf ohne Manifest rc 0 VOR Merge).

## Paket V-0: Doku-Verbuchung (SOFORT)
Ziel: #25-B-Byte-Vertrag als ABGELOEST verbuchen (nie loeschen, nur deprecaten); Abloesungs-Vermerk mit §71/§72-Referenz neben den GO-2-Eintraegen; Deprecations-Banner in den Alt-Kanal-Koepfen.
Dateien: super docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (Vermerk zu :458/:540); super/Code/MANUAL_RUN.md (Banner, :50 "comdare_perms_all ZWINGEND" wird irrefuehrend); ce tools/permutation_codegen/codegen.cmake:1-12 (Banner).
Byte-Klasse: byte-neutral. Gates: CI gruen. Besitzer: Doku/Ledger-Agent.

## Paket V-1: Vendor-Provisioning-Entkopplung (ERSTE Code-Aenderung, O-8-FENSTER)
Ziel: Alle COMDARE_VENDOR_*-Defaults von COMDARE_BUILD_PERMUTATIONS auf einen EIGENEN Schalter umhaengen (Vorschlag: COMDARE_PROVISION_VENDOR_ALLOCATORS; Effektiv-Werte identisch: super ON, ce-standalone OFF). Die add_subdirectory(ext)- und link_libraries-Bloecke (ce CMakeLists.txt:567-570/:586-604) auf den neuen Schalter; USE-Baking (:571-588) unveraendert.
Dateien: ce ext/CMakeLists.txt:17-19/:57/:123/:158/:179/:202; ce CMakeLists.txt:567-604; super Code/CMakeLists.txt (neuer set ON).
Byte-Klasse: O-8-FENSTER - einzige byte-tragende Stelle des ganzen Retires: kippt ein COMDARE_AXIS_06_USE_*-Flag (global gebacken via axis_06_allocator_flags.hpp.in), aendert sich der Codegen ALLER Tier-Binaries. Byte-neutral machbar und zu BEWEISEN.
Gates: G1 Byte-Diff generated/axes/alloc/axis_06_allocator_flags.hpp vor/nach identisch (super-Tree UND ce-standalone); G2 voller lokaler Bau (Referenz falsches Gruen); G3 CI hart gruen. Besitzer: Impl-Agent mit O-8-Fenster-Anmeldung.

## Paket V-2: Bestandsinventar-Umzug (byte-neutral, MESS-KRITISCH)
Ziel: Alle Konsumenten von generated/permutations_manifest.txt vom Configure-Zeit-Artefakt loesen, BEVOR der Codegen faellt.
2a Treiber-Startgate: main.cpp:641 + permutations_runtime_check.hpp:87-100 ersatzlos deprecaten ODER auf Planer-Plan/Bestandslog-Gate umziehen (OWNER-PUNKT Q3); Defines Code/02_messung_driver/CMakeLists.txt:141-142 raus; Legacy-Bloecke main.cpp:651-676 bleiben COMDARE_LEGACY_MESSREIHEN-gegatet.
2b super-CI visibility:tier-binaries (.gitlab-ci.yml:346-372): Umbau auf Planer --dump-plan/Bestandslog oder Entfall - INFRA-HANDOUT (LED:3539: .gitlab-ci.yml = Infra-Gebiet).
2c write_perm_all_manifest (Code/CMakeLists.txt:276-289 + cmake/write_perm_all_manifest.cmake) und tier_binary_visibility (:431-443) auf Planer-Plan umziehen.
Byte-Klasse: byte-neutral, aber operativ mess-kritisch (sonst Exit 2 fuer JEDEN Messlauf).
Gates: Treiber ohne Manifest: --validate und Smoke-Lauf rc 0; Visibility-Ersatz in CI gruen; Manual-Handlauf Stufe 1-2. Besitzer: Impl (Treiber/CMake) + Infra (CI-YAML).

## Paket V-3: Super-Abschaltung (byte-neutral)
Ziel: super-Configure fuehrt keinen Codegen mehr aus; Re-Export-Targets weg.
Dateien: super Code/CMakeLists.txt:92-102 (Defaults/Modes/Profile inkl. PRT-ART :94/:98/:102), :212-216 (comdare_perms_ce), :222-227 (comdare_perms_pa), Reste aus :276-289. PRT-ART-Zwilling V36.C inkl. prt_art_permutations_manifest.txt (:283) in den Scope, da das V36.D-Gate CE||PA prueft (permutations_runtime_check.hpp:88-89); prt-art-Repo-Innereien UNGEPRUEFT (OWNER-PUNKT Q2).
Gates: Configure sauber; voller lokaler Bau; CI gruen; grep permutations_manifest ueber super = 0 Live-Treffer. Besitzer: Impl.

## Paket V-4: ce-Retire (byte-neutral)
Ziel: Alt-Kanal in ce stilllegen; Doku-nie-loeschen beachten (Deprecations-Banner bzw. Archiv-Verschiebung, KEINE Loeschung von codegen.cmake/sh/bat/axes_versions.txt als Doku-Artefakte - Loesch- vs. Banner-Frage nur fuer Quellcode-Targets).
Dateien: ce CMakeLists.txt:33 (Option), :560-609 (Include :562-563, Targets :606-608; :567-604 wurde in V-1 umgehaengt); cmake/permutations.cmake ganz (Stale-Verweis :47 faellt mit); libs/cache_engine/builder/permutation_codegen_tool/ + apps/permutation_codegen_tool/; tests/unit/CMakeLists.txt:3787-3803 + tests/unit/perm_codegen_byte_identity.cmake (fallen mit dem #25-B-Vertrag, Owner-GO §71 liegt vor - im Ledger als abgeloest verbucht per V-0); ce .gitlab-ci.yml:453 (comdare_permutation_codegen_cli aus Prebuild; CI-YAML = Infra).
Kommentar-Nachzuege: isa_features.cmake:136-137 (GO-2-Scoping historisieren; comdare_apply_simd_extension_flags/_optimization_level_flags BLEIBEN, lebende Konsumenten tests/unit/CMakeLists.txt:1795/:3079-3080); test_c3b_kanal_merge_beleg.cpp:7/:16-18 (Kanal-A-Verweise historisieren, Test als Flag-Wert-Regression BEHALTEN); Beifang: COMDARE_apply_simd_flags (isa_features.cmake:103-123, 0 Aufrufer) mit entfernen.
Byte-Klasse: byte-neutral (perm_*-DLLs sind nicht die Tier-Binaries; kein ce-Runtime-Konsument, Strang A (2)).
Gates: ctest-Delta exakt -2 Tests, sonst gruen; CI hart gruen; grep V36/permutation_codegen = nur noch Doku/Archiv-Treffer. Besitzer: Impl; CI-Zeile Infra.

## Paket V-5: Merge-Substanz Faehigkeiten (additiv, NUR nach Owner-Entscheid)
5a sse4.2/neon als neue System-Zellen (simd_sub_axis.hpp:98-99; Flag-Werte aus codegen.cmake:577-580 uebernehmen) - Q1. Byte-Klasse: additiv, golden-neutral solange Golden-Profil unveraendert.
5b make_msvc_compile_fn (build_orchestrator.hpp:699/:717); msvc-Flag-Werte liegen in den Achsen bereits deklariert (simd_sub_axis.hpp:73/:80/:87) - Q4.
5c COMDARE_LEGACY_MESSREIHEN-Vergleichspfad (main.cpp:651/:668) als ABGELOEST verbuchen (Doku-Vermerk, Gate bleibt vorerst im Code; golden-320-Subsumtion lt. LED:536 B2 unbestaetigt). Byte-neutral.
Gates: neue Zellen ausserhalb golden; Beleg-Test erweitern. Besitzer: Impl nach Owner-GO.

## Paket V-6: Toolchain + Manual + Install ("leicht installierbar nach Stand der Technik")
(i) install()-Targets fuer Treiber und Planer/CEB-CLI (heute 0 Treffer in ce/super-CMakeLists, Strang B (4)iv). (ii) CMakePresets.json ausbauen (Presets = Konsens, Strang C (1); reales Minimum bleibt cmake 3.28, ce CMakeLists.txt:7). (iii) Harter Compiler-Assert CMAKE_CXX_COMPILER_VERSION == g++-16-Pin; Toolchain-PPA-Paketversion dokumentieren/apt-pinnen (PPA-Pakete mutabel, Strang C). (iv) CI-Container: IDENTISCHER Installationsweg wie baremetal (gleiches PPA, gleiche Versionsnummern) + Digest-Pinning der buildtools-Images; offizielles gcc-Docker-Image nur 2. Wahl (Debian-Basis bricht CI==baremetal) - INFRA. (v) Manual-Konsolidierung: super/MANUAL_RUN.md = Master; Stufe-3-Messlauf ausschreiben (heute Skelett :191-195); Toolchain-Tabelle :18 auf cmake>=3.28 korrigieren; super/Code/MANUAL_RUN.md deprecaten (nie loeschen); ce/MANUAL_RUN.md:15-17 angleichen. (vi) Manual-Gliederung (je Werkzeug EIN Manual, clig.dev): 1 Toolchain-Install (Pin-Tabelle) / 2 Repo+Vendor (mp11-Pflichtpfad) / 3 Bau (Preset) / 4 Validieren / 5 Planen (--dump-plan/--dump-cmake) / 6 Tier-Bau (--emit-tier-*) / 7 Echter Messlauf (Env-Pins) / 8 CI-Anwendung (planer:delegate + Lint) / 9 Exit-Codes+Troubleshooting / 10 --version-Selbstauskunft. CLI-Subcommand-Umbau der --dump/--emit-Flags: OWNER-PUNKT Q7 (nachrangig).
Byte-Klasse: byte-neutral. Gates: wortgetreuer Handlauf auf Zweitmaschine (prod2, §61 Dual-Weg); Aufruf aus Installationspfad rc 0. Besitzer: Impl (Manual/Install), Infra (Images).

## Paket V-7: CI==baremetal-Gleichlauf-Gates (dauerhafte Abnahme-Checkliste)
G-A Single-Source-Walk bleibt test-gestuetzt (construct_plan_into profile_run_facade.cpp:804; Byte-Determinismus-Zusage profile_run_facade.hpp:263-265). G-B CI-Zell-Bau == Manual-Handlauf-Block gegenlesen bei jeder Aenderung (super .gitlab-ci.yml:858/:860/:1010-1012 vs MANUAL_RUN.md:40-41). G-C Gewollte Divergenzen dokumentieren (CI-Smoke m3v2_smoke :1239-1242; Mess-Stufe beidseits gated :1289). G-D Toolchain-Gleichheit per Versions-Assert (V-6iii) in beiden Welten. Besitzer: Infra+Impl gemeinsam.

## Neben-Kanal-Behandlung (Strang-B-Funde, Vorschlaege - Entscheid beim Owner wo markiert)
(a) catalog_codegen (ce CMakeLists.txt:655): MERGE-Kandidat (CMake-Umweg), traegt aber heute den GN-2-Guard -> BEHALTEN bis Guard-Ersatz im Fassaden-Kanal, dann eigenes Retire-Paket. OWNER-PUNKT (nicht fristkritisch).
(b) Registry-Generatoren (ce tools/CMakeLists.txt:11-17): BEHALTEN - ANGEBOT-Doktrin, kein Steuer-Kanal.
(c) anatomy_codegen_runner (ce cmake/anatomy_codegen_runner.cmake:1-12): MERGE-Kandidat spaeter (Configure-Zeit-execute_process = CMake-Umweg). OWNER-PUNKT, nicht fristkritisch.
(d) Direkte CMake-option()-Schienen (AXIS_06_ENABLE_*, MEASUREMENT_MODE/RELEASE_MODE, STATISTICS, OBSERVER_PUSH, PMC/PAPI; ce CMakeLists.txt:44/:57/:112-113/:133/:145/:156-179): Ein-Kanal-Praemisse hier NICHT erfuellt; Vorschlag: eigenes Band "Angebots-Zuschnitt in Profil-XML" NACH TEIL-V; PMC/PAPI/MEASUREMENT_MODE sind Host-Belange und bleiben evtl. bewusst CMake-seitig. OWNER-PUNKT Q6.
(e) CI-Matrix-Reste (super .gitlab-ci.yml:631/:713/:1044/:1070): Entscheid liegt vor (RF-4 LED:3539 archivieren per Infra-Handout), Umsetzung offen -> ins Infra-Handout, KEIN neuer Entscheid.
(f) messreihen.xml (V9.6): bleibt gegatet; mit V-5c als abgeloest verbuchen; endgueltige Entfernung erst nach golden-320-Subsumtions-Bestaetigung. OWNER-PUNKT nur fuer Entfernung.
(g) CMakePresets.json: BEHALTEN und in V-6 ausbauen.

## Reihenfolge (bindend)
V-0 -> V-1 (O-8-Fenster) -> V-2 -> V-3 -> V-4 -> V-5 (nach Owner-Entscheiden) -> V-6 -> V-7 als Dauer-Gate. V-2 und V-3 in einem Zug oder V-2 strikt vor V-3; nichts davon vor der Mo-CSV-Landung scharf.

== (3) RESTFRAGEN AN DEN OWNER (nur echte) ==

Q1: sse4.2 (-msse4.2/CRC32) und neon als neue System-Zellen in die simd-Unterachse mergen, oder bewusst als Design-Space-Vokabular entfallen lassen (prod1/prod2 = x86, SSE2 = ABI-Baseline)? Es ist die einzige literale Faehigkeits-Differenz im Kern.
Q2: PRT-ART-Zwilling (V36.C): darf der Retire-Scope prt-art ohne vorherige Repo-Inspektion mitziehen (Innereien UNGEPRUEFT), oder erst Inventar-Pass im prt-art-Repo?
Q3: messung_driver-Startgate: ersatzlos fallen lassen oder durch ein Bestandslog/Planer-Plan-Gate ersetzen (Empfehlung: Ersatz-Gate, damit ein leerer Bau weiter frueh mit klarem Exit stirbt)?
Q4: Windows/MSVC-Bauweg: make_msvc_compile_fn als Merge-Substanz bauen oder Windows mit dem Retire offiziell aus dem Zielbild nehmen (Praemisse CI==baremetal Linux legt Letzteres nahe)?
Q5: Compiler-Doktrin fuer den gemergten Kanal: Ein-Compiler g++-16 (dann sind P2996-Reflection/template-for real nutzbar, aber experimentell und nicht Clang-portabel) oder C++23-Floor + Mp11-Muster mit Reflection als spaeterem Drop-in?
Q6: Neben-Kanal (d): XML-Ueberfuehrung des Angebots-Zuschnitts als eigenes Band nach TEIL-V einplanen - ja/nein, und welche Schalter bleiben bewusst Host-/CMake-seitig?
Q7: CLI-UX-Umbau (--dump/--emit-Flags -> clig.dev-Subcommands je Werkzeug): jetzt in V-6 oder nach der Frist?

SELBSTCHECK: ASCII-only geprueft (keine Bytes >= 0x80 in dieser Meldung); read-only eingehalten (keine Edits/Commits, keine Dateien geschrieben); 7 Kern-Anker live per Spot-Grep verifiziert, alle uebrigen Anker aus Straengen A/B/C uebernommen; UNGEPRUEFT-Stellen markiert (prt-art-Innereien, codegen.bat, Strang-C-Sekundaerquellen, weitere Handlauf-Doks unter docs/plaene).