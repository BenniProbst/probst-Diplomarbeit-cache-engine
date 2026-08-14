# LESER 9 — Teil 2 (whrh78rq1, wa3azpzk6)

### [whrh78rq1.json] 19
GEGENSTAND: BEFUND BESTAETIGT: super hatte KEINE eigene ASCII-/Breiten-Wache; Code/tests/CMakeLists.txt:202 verwies woertlich auf (scripts/ci_diff_ascii_width_guard.sh) — Pfad existierte im super nicht (git ls-files scripts/ leer).
ORT: super Code/tests/CMakeLists.txt:202; scripts/ fehlte
SOLL/FIX: Wache gespiegelt (siehe naechster Posten). Teilbefund korrigiert: super-CI faehrt lint:secrets/lint:format/lint:static, aber ASCII prueft keiner; lint:format laesst 140-Spalten-ASCII-Kommentare (ReflowComments: false), Umlaut-String-Literale und die realen 121-123-Byte-Zeilen in Code/02_messung_driver/main.cpp durch; Scope nur \.(c|cc|cxx|cpp|h|hh|hxx|hpp)$ — .cmake/CMakeLists.txt/.sh ungeprueft. Bestand: 15 rein-ASCII-Zeilen >120 Byte in .cpp/.hpp, die lint:format heute durchlaesst.
STATUS LT. QUELLE: behoben@7780c6af (Wache gebaut; Bestand NICHT saniert)
ABHAENGIGKEIT/FLAECHE: super-CI .gitlab-ci.yml; ce-Vorlage (Spiegel-Drift bewusst in Kauf)

### [whrh78rq1.json] 20
GEGENSTAND: Neue super-eigene Diff-Hygiene-Wache: scripts/ci_diff_ascii_width_guard.sh + neuer CI-Job lint:diff-hygiene (stage lint, GIT_DEPTH: 0, KEIN allow_failure); Spiegelung statt zentraler ce-Wache begruendet (GIT_SUBMODULE_STRATEGY: none macht zentral technisch unmoeglich; Gitlink-Drift-Risiko; anderer Scope: 5 super-eigene .sh, .tex/.md/.yml bewusst draussen).
ORT: Commit 7780c6afd55ef71074ebbb0939412d870c05bf7e auf b-super-ascii-wache (von development), nicht gepusht; /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/scripts/ci_diff_ascii_width_guard.sh + .gitlab-ci.yml (2 Dateien, 610 Zeilen, rein additiv; YAML 29->30 Jobs, bestehende Jobs bitgleich)
SOLL/FIX: Landung steht aus. Biss-Nachweis: GRUEN 558/0/0; ROT auf Wegwerf-Branch 99f9185e (NICHT-ASCII :2, >120 :3, 130 Byte), Wegwerf-Branch geloescht. FATAL-Pfade EXIT=2 verifiziert (blanker SHA, fehlendes awk, unaufloesbare Basis).
STATUS LT. QUELLE: behoben@7780c6af (nicht gelandet)
ABHAENGIGKEIT/FLAECHE: super .gitlab-ci.yml (Merge-Flaeche mit jedem anderen CI-Strang, z.B. texlive-gate-haertung); Task-Rahmen nennt landereif "bau/wachen-floor-inventar" (ce) — Abgleich beim Designer

### [whrh78rq1.json] 21
GEGENSTAND: Nebenbefund Bau: Alt-Bestand wird bewusst NICHT gegatet — --bestand meldet 845 Nicht-ASCII- und 174 Breiten-Zeilen aus 18714 super-eigenen Codezeilen; Bestands-Wache waere am Einfuehrungstag rot geboren, deshalb Diff-Wache. Grossteil der 174 Breiten-Meldungen ist Folge des ASCII-Verstosses (U+2500-Trennlinien: 80 Zeichen = 234 Byte, Wache misst byteweise).
ORT: super Alt-Bestand (18714 Zeilen Nenner)
SOLL/FIX: Quelle: "Sie stoppt neue Verstoesse, sie saniert keine alten." Sanierung des Alt-Bestands = eigener, nicht beauftragter Posten.
STATUS LT. QUELLE: offen (bewusst ausgeklammert)
ABHAENGIGKEIT/FLAECHE: -

### [whrh78rq1.json] 22
GEGENSTAND: Verify GESAMTVERDIKT: 6 von 6 Auftragspunkten HAELT (Umlaut-Zeile, >120-Spalten inkl. Grenze 120/121, Verstoss aus FRUEHEREM Commit der Serie via merge-base..HEAD, Plus-Praefix-Zeilen mit Nenner-Beweis, stille-0-Werkzeugausfaelle inkl. mawk/busybox-Portabilitaet, echter gerechneter Nenner mit namentlicher Skip-Liste). Kontrast-Messung: die ALTE grep-Kette verlor ALLE 9 Zusatzzeilen (^\+ matcht auf GNU grep 3.11 und ugrep nichts) — schlimmer als der Bau-Bericht (5) behauptet.
ORT: Verify-Lauf im Hardlink-Klon /tmp/wachtest (entfernt); Original unveraendert HEAD 7780c6af
SOLL/FIX: keine Auflage aus den 6 Punkten; cat-Ausfall = schwaechste Stelle (Verstossliste weg, Nenner+ROT bleiben), dirname-Ausfall meldet mit falscher Begruendung aber laut.
STATUS LT. QUELLE: nur-hinweis (bestanden)
ABHAENGIGKEIT/FLAECHE: -

### [whrh78rq1.json] 23
GEGENSTAND: LUECKE A (echt, vom Bau-Bericht NICHT genannt): Arbeitsbaum-Modus der Wache sieht ungetrackte Dateien NICHT — liefert die nackte gruene Null, die der Kopf ausschliesst (?? probe_alpha.cpp mit Umlaut+133-Byte-Zeile -> GRUEN EXIT=0, 0 Zeilen geprueft; nach git add -> ROT). Ursache: git diff HEAD zeigt Untracked nie. Der Kopf nennt diesen Modus woertlich "die manuelle Vor-Paketmeldung-Pruefung" — genau der Lauf vor der Paketmeldung, genau der Fall brandneue Datei. CI NICHT betroffen (--seit-basis).
ORT: scripts/ci_diff_ascii_width_guard.sh (Arbeitsbaum-Modus) @ 7780c6af
SOLL/FIX: verbatim: "Minimale Heilung: im Arbeitsbaum-Modus `git ls-files --others --exclude-standard` mitpruefen, oder wenigstens bei nichtleerer Untracked-Liste FATAL/Warnung ausgeben."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Nachbesserung VOR/BEI Landung von b-super-ascii-wache sinnvoll (gleiche Datei)

### [whrh78rq1.json] 24
GEGENSTAND: LUECKE B (echt, Fehlalarm-Richtung): is_scoped() kennt keine Pfad-Ausnahme — 897 getrackte Fremdcode-Dateien (Code/external/ + Forschungsarbeiten/) liegen im Scope, Nenner nennt sie "super-eigenen Code". Simulierter Vendor-Drop (unodb/art.hpp unveraendert kopiert+gestaged) -> ROT (NICHT-ASCII :1506/:1613); Job hat kein allow_failure -> naechster Vendor-Import unter Forschungsarbeiten/code/ faehrt die Pipeline rot, gegen die Vendoring-Doktrin (vendor -> faithful -> selfcontained, unveraendert lassen). Code/external/ heute nur durch GIT_SUBMODULE_STRATEGY: none zufaellig entlastet.
ORT: scripts/ci_diff_ascii_width_guard.sh is_scoped() @ 7780c6af
SOLL/FIX: verbatim: "Heilung: Pfad-Ausschluss `^Code/external/`, `^Forschungsarbeiten/` in `is_scoped()`, und die Nenner-Zeile ehrlich als 'im Scope' statt 'in super-eigenem Code' beschriften."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Nachbesserung VOR/BEI Landung von b-super-ascii-wache (gleiche Datei); Vendoring-Doktrin

### [whrh78rq1.json] 25
GEGENSTAND: BEFUND C (kein Fehler): lint:diff-hygiene laeuft mangels if-Rule auch auf main mit 0/0/0 gruen (merge-base==HEAD) — ERKLAERTE Null (Bereichsbreite + HINWEIS), kostet nur einen Runner-Slot je main-Pipeline. RESTRISIKO nicht entscheidbar: ob origin/$CI_DEFAULT_BRANCH auf dem baremetal-Runner als Remote-Tracking-Ref existiert, laesst sich nur in echter Pipeline messen; Ausfall waere EXIT=2 laut (GIT_DEPTH: 0-Hinweis), nie gruen.
ORT: .gitlab-ci.yml Job lint:diff-hygiene @ 7780c6af
SOLL/FIX: optional if-Rule; Erst-Pipeline nach Landung beobachten (Restrisiko-Messung).
STATUS LT. QUELLE: nur-hinweis (Restrisiko offen bis erste echte Pipeline)
ABHAENGIGKEIT/FLAECHE: super-CI; Push->gruen-Doktrin

### [whrh78rq1.json] 26
GEGENSTAND: Nicht angefasst im Wache-Bau: vorbestehende Submodul-Aenderung "M Code/external/comdare-cache-engine" und untracked "?? Code/measure_out_d03/" blieben ungestaged im super-Hauptklon.
ORT: /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine (Working Tree)
SOLL/FIX: keiner benannt; Zustand beim Landen beruecksichtigen (Ein-Schreiber-je-Worktree-Regel).
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: super-Hauptklon-Zustand

### [wa3azpzk6.json] 27
GEGENSTAND: Teil-2-Uebernahme: 5 von 6 Paketen FERTIG und je einzeln voll gegatet (T2-D-FERTIG, T2-B, T2-C, T2-E, T2-F); T2-A OFFEN (bewusster Stopp). Commits auf b2-neuanker-format3 (Basis b1d33cbe): cb9a7204 (T2-D/NB-3), dbdd2f9b (T2-B per-Perm-Glied [5]), bbd72c2a (T2-C RT-Realversions-Sonde), e2c95179 (T2-E tc=1-Alt/Neu), a6a6875b (T2-F C-4-Rest). 12 Dateien +1139/-80. Kein Push, keine Landung.
ORT: Branch b2-neuanker-format3 @ a6a6875b, Worktree /home/comdare/wt-b2-neuanker
SOLL/FIX: Gates je Commit literal: ctest 2x seriell "100% tests passed, 0 tests failed out of 408" (alle 5 Commits, beide Laeufe), MAKE_ALL_RC=0/MAKE_ZUSATZ_RC=0, golden 5/5 (#320/#321/#322/#367/#378), Frozen-Digest 17148e5a…8ce89374 unveraendert (Preimage 560 Bytes), TABU 0, ASCII 0. GATE_BASIS 408: 10 neue gtest-Faelle in bestehender TU test_m_w12_stamp_bausteine (31->41), daher keine neue ctest-Nummer.
STATUS LT. QUELLE: teilweise (5/6 fertig; T2-A offen; ungelandet)
ABHAENGIGKEIT/FLAECHE: HINWEIS Kette: wsb78kl70 (T2-A-NB, HEAD 6c300e68, Eintritt 847c93c9) liegt ZEITLICH NACH diesem Stand auf demselben Branch — Designer muss die Branch-Historie b1d33cbe -> a6a6875b -> … -> 847c93c9 -> 6c300e68 abgleichen

### [wa3azpzk6.json] 28
GEGENSTAND: Vorarbeits-Verdikt T2-D: UEBERNOMMEN, ABER NICHT BAUBAR — `explicit ToolchainGlied(std::string&&) = delete;` machte jede Konstruktion aus String-Literal mehrdeutig (gcc: "call of overloaded 'ToolchainGlied(<brace-enclosed initializer list>)' is ambiguous", MAKE_RC=2, comdare_tests unbaubar; betroffen static_asserts anatomy_fingerprint.hpp:454-461, alle Test-Literale, alle consteval-Zwillinge). Korrektur: geloeschter Konstruktor als constrained Template ueber Konzept `GliedSterbenderString` (S == std::string exakt) — Literal: Kandidat existiert nicht; benannter String: erlaubt; Temporary: geloescht.
ORT: anatomy_fingerprint.hpp (+ toolchain_stamp_naht.hpp byte-identisch uebernommen, toolchain_stamp_glied.hpp Diagnose-Text) @ cb9a7204
SOLL/FIX: umgesetzt; Fertigstellung der 2 fehlenden Vorarbeits-Punkte: Diagnose-Text profile_run_facade.cpp ("traegt NUR den Dialekt" seit NB2-1/R1 falsch) + bvset-PAAR-Wache CT zweistufig (emittierte Liste build_variant_set_signature.hpp + VOLLE Registry-Listen All* in driver_build_variant_signature.hpp).
STATUS LT. QUELLE: behoben@cb9a7204
ABHAENGIGKEIT/FLAECHE: Fable-Review M1 verweist auf Rest-Luecke im Konzept (siehe Posten 32)

### [wa3azpzk6.json] 29
GEGENSTAND: Bewusste Abweichungen der T2-Welle: (1) T2-B/C/E/F vor T2-A gezogen (T2-B und T2-C sind die beiden KRITISCH-Punkte, dateidisjunkt zu F4); (2) STOP-GATE der drei C-3-Dateien eingehalten — profile_run_entry.hpp und experiment_run_entry.hpp nur fuer die T2-B-Scheibe, experiment_plan_director.hpp und cache_engine_builder_iterator.hpp blob-identisch (Beleg T2B-STOP-GATE-TABU-FROZEN.txt); (3) LIVE-Glied [5] bewegte sich zweimal BEWUSST (T2-B: atomic128; T2-C: erhobene Realversion), Frozen-Vektor rechnet ueber Literale, unberuehrt, nachgemessen; kein Bestands-Artefakt auf Vorher-Werten (Buendel ungelandet), STOPP-Klausel nie ausgeloest; (4) T2-E: KEIN Format-Bump, verifiziert (V1 Alt-Form nicht mehr herstellbar fail-loud, V2 Neu-Form traegt genau ein ':'), zusaetzlich Ergebnis-Wache im Renderer; (5) 2 Doku-Ehrlichkeits-Nachzuege (Kopf test_m_w12_stamp_bausteine "keine Registries" stimmt seit NB/CX-4 nicht; Renderer-Fehlerzeile toolchain_stamp_glied.hpp).
ORT: b2-neuanker-format3, Commits dbdd2f9b/bbd72c2a/e2c95179/a6a6875b
SOLL/FIX: keine — dokumentierte, belegte Abweichungen.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

### [wa3azpzk6.json] 30
GEGENSTAND: OFFEN 1: T2-A (F1 + F4 Zaehler-Resume) NICHT ANGEFASST, bewusster Stopp — F4 = Owner-KERN "Batch-Plan [Reihenfolge+Faecher] PERSISTENT VOR dem Lauf; Resume = Zaehler je Phase kompiliert/gemessen": neues persistentes Format + resume-v5->v6-Bump + Kopplung an b.skipped. Recherchierte Anker fuer den Fortfuehrer (alle am Objekt geprueft): Stamp-Praefix lazy_resume_stamp_prefix cache_engine_builder_iterator.hpp:883; Literal `resume-v5|build=` Z.904 (EINZIGER Ort des Formatworts); W5-Konstante kLazyResumeRowsKey[] = "|rows=" Z.876, Leser Z.952, Schreiber Z.1950 — F4 haengt `|fpr=` an DIESE Konstanten-Ordnung an und legt KEIN viertes Literal daneben; F1-Anker cfg.output_dir = a.dll_dir profile_run_entry.hpp:584 und Director-Emission dll_dir = "$CI_PROJECT_DIR/Code/gn_out/" + slug + "/" + host + "/perm" + idx experiment_plan_director.hpp:1236. Beide Dateien blob-identisch zu b1d33cbe.
ORT: cache_engine_builder_iterator.hpp:883/:904/:876/:952/:1950; profile_run_entry.hpp:584; experiment_plan_director.hpp:1236
SOLL/FIX: T2-A als eigener Folge-Bau (spaeter teilweise geschehen: siehe wsb78kl70 T2-A-NB mit batchplan-v2 + |fpr=-Haertung — Designer muss abgleichen, was von T2-A durch die NB abgedeckt ist und was noch fehlt).
STATUS LT. QUELLE: offen (zum Berichtszeitpunkt)
ABHAENGIGKEIT/FLAECHE: Codex-KRITISCH-Befunde (Posten 33) zielen auf genau diese Luecke

### [wa3azpzk6.json] 31
GEGENSTAND: OFFEN 2-4 der T2-Welle: (2) TU-Abhaengigkeit der atomic128-Wahl — active_atomic128_wahl() liest COMDARE_AXIS_06_USE_SNMALLOC (im Naht-Header inkludiert) und COMDARE_ARCH_X86_64 (globale Compile-Definition); auf dieser Flotte SNMALLOC=0 -> no_cx16, arch-unabhaengig; bei SNMALLOC=1 haengt sie an der globalen Definition — bestand vor T2-B, kein Regress, als Falle notiert. (3) Debug-Ueber-Diskriminierung: bei COMDARE_BUILD_TYPE=Debug ersetzt CompileFn opt durch "-O0 -g", Glied nennt die opt-ACHSE — zwei Debug-Perms O2/O3 ueber-diskriminiert (ein Neubau zuviel), nie unter-diskriminiert, fail-closed, Kandidat Aufraeumpass. (4) ct_realversion_deckt_treiber seit T2-C aus dem Entscheidungspfad, nur Trace-Zusatzinfo, bewusst nicht geloescht (Deprecate-Doktrin), Kandidaten-Liste Abschluss-Aufraeumpass.
ORT: toolchain_stamp_naht.hpp (atomic128, ct_realversion_deckt_treiber); CompileFn/Glied (Debug-Pfad)
SOLL/FIX: Aufraeumpass-Kandidaten; keine Blocker.
STATUS LT. QUELLE: offen (Kandidaten-Liste)
ABHAENGIGKEIT/FLAECHE: Abschluss-Aufraeumpass

### [wa3azpzk6.json] 32
GEGENSTAND: FABLE-REVIEW (adversarial, b1d33cbe..a6a6875b): VERDIKT LANDEBEREIT — alle 6 Nachmess-Punkte am Objekt bestanden, KRITISCH-Befunde CX-B1 und [K] beweisbar geheilt, Frozen-Vektor unbewegt (eigene RT-Nachrechnung 560 Bytes / 17148e5a…8ce89374), Basis 408 stabil, eigener Doppellauf 2x 408/408, golden 5/5, Vorarbeit vollstaendig uebernommen. T2-A bleibt OFFEN — kein Einwand gegen Landung der 5 Pakete. MINDER-BEFUNDE (nicht landeblockierend): M1 GliedSterbenderString faengt const-qualifizierte std::string-Rvalues nicht (S deduziert std::string const -> Konzept falsch -> string_view-Bindung an sterbendes const-Temporary moeglich; Haertung: std::remove_cvref_t<S> im Konzept); M2 T2-C-Diagnose in profile_run_entry.hpp etikettiert Sonden-Ausfall als KonfigXmlParse (semantisch fremde Fehlerklasse, Kosmetik); M3 active_atomic128_wahl() verlagert #if in Mehr-TU-Header, ODR-sicher nur solange COMDARE_ARCH_X86_64/AXIS_06 flottenweit einheitlich (compiler_flags.cmake tut das heute) — Beobachtungsposten.
ORT: Review auf a6a6875b; M1 anatomy_fingerprint.hpp (Konzept), M2 profile_run_entry.hpp, M3 toolchain_stamp_naht.hpp
SOLL/FIX: verbatim: "Die drei Minder-Befunde M1-M3 als Kandidaten fuer den Abschluss-Aufraeumpass mitfuehren, nicht vor der Landung."
STATUS LT. QUELLE: M1-M3 offen (Aufraeumpass); Landefreigabe der 5 Pakete erteilt
ABHAENGIGKEIT/FLAECHE: M1 deckungsgleich mit Codex-MITTEL "const std::string&&" (Posten 33); Dedup

### [wa3azpzk6.json] 33
GEGENSTAND: CODEX-REVIEW (lens=codex, Thread 019fd669-2e19-7bc0-a76e-09c71c000924, b1d33cbe..HEAD, rein statisch): "Nicht freigabefaehig. Im Bereich b1d33cbe..HEAD stehen T2-B bis T2-F, aber kein T2-A; mehrere Skip-/Resume-Pfade bleiben fail-open." Befunde woertlich:
(K1) KRITISCH — persistenter Batch-Plan und Phasenzaehler fehlen vollstaendig: Planer streamt RAM-Slices sofort zum Consumer (batch_planner.hpp:87); Ergebnis nur globale fluechtige Summen (experiment_run_entry.hpp:107); keine "Plan dauerhaft schreiben, dann laufen"-Reihenfolge; Crash verliert Plan+Fortschritt; Neustart plant aus evtl. veraendertem XML/Bestandslog neu; IDs bereits vor Bau/Messung gezaehlt (experiment_run_entry.hpp:362, profile_run_entry.hpp:806), also auch Fehlversuche.
(K2) KRITISCH — Mess-Resume nicht an neuen Fingerprint gekoppelt: Stamp bleibt resume-v5 (cache_engine_builder_iterator.hpp:904), enthaelt je Binary nur algo_sig (:1668), wird auch nach echtem Neubau geprueft (:1822). Beispiel: g++-16 16.0.1->16.3 baut DLL wegen Fingerprint-Drift neu, uebernimmt danach aber alte Messwerte aus result.csv.
(H1) HOCH — leere Zellfelder kollabieren per-Perm-Fingerprints: Umschaltung haengt faelschlich an !perm_cell_values.empty() (profile_run_entry.hpp:943), obwohl leere Zellfelder dokumentierter API-Default; mit compile_for_perm werden O2/O3 verschieden kompiliert, erhalten aber denselben Live-Fingerprint; O3 kann O2-DLL skippen.
(H2) HOCH — compile_for_perm-Fallback stempelt anderen Bau: bei leerer Factory wird a.compile verwendet (profile_run_entry.hpp:925), Soll-Fingerprint bei belegten Zellwerten dennoch per-Perm (:951); Orchestrator schreibt Sollwert ins Sidecar (build_orchestrator.hpp:689); Folgelaeufe skippen die falsch geflaggte/-gestempelte DLL.
(H3) HOCH — beide target_isa-Zweige gebrochen: target_isa allein aktiviert Permutationspfad nicht (profile_run_facade.cpp:569); Einzelpfad kompiliert target-spezifisch, verwendet aber achsenleeres Live-Glied (toolchain_stamp_naht.hpp:400); mit opt/simd verwirft perm_compile_flags(nullptr,false) die Profil-Targetflags (profile_run_facade.cpp:650), waehrend Ziel-ISA als Zelle gestempelt wird -> x86/aarch64-Kollision bzw. native x86-DLL mit aarch64-Identitaet.
(H4) HOCH — positiver Realversionscache vergiftbar: prozessglobaler Cache nur mit literalem Treiber-Tag indiziert (toolchain_stamp_naht.hpp:318); aendern sich PATH/Symlink/Alternatives/Executable zwischen Laeufen bzw. Sonde und Compile, bleibt alte Version erhalten -> falscher Stempel, falscher Skip.
(H5) HOCH — Shell-Sondenwache erlaubt Globbing: [/] passieren die Allowlist (anatomy_fingerprint.hpp:139); Tag unquotiert an popen (toolchain_stamp_naht.hpp:332); /tmp/g++[12] kann anderes Executable sondieren als der literale Compile-Pfad.
(H6) HOCH — result.csv/Stamp nicht crash-atomar: CSV direkt trunciert, alter Stamp bleibt liegen (cache_engine_builder_iterator.hpp:1941); Leser zaehlt unvollstaendige letzte Zeile mit (:972); Crash kann Teil-CSV unter altem gueltigem Stamp hinterlassen.
(M1c) MITTEL — nichtleerer Gate-Beitrag unbaubar: Produktionswert gate=[…] (simd_build_gate.hpp:369); '=' im Toolchain-Feldwert verboten (toolchain_stamp_glied.hpp:384); sobald Gate-Flags aktiviert, wirft per-Perm-Gliedbildung vor dem Bau.
(M2c) MITTEL — T2-D sperrt nicht alle sterbenden Strings: GliedSterbenderString matcht nur exakt std::string (anatomy_fingerprint.hpp:242); const std::string&& umgeht den geloeschten Konstruktor, dangling string_view in allen drei Traegern moeglich.
(M3c) MITTEL — Sondenantwort nicht vollstaendig fail-closed: einzelnes fgets mit 256 Bytes ohne Vollstaendigkeitspruefung akzeptiert (toolchain_stamp_naht.hpp:271); lange Versionen koennen auf denselben Praefix kollabieren; Timeout und Prozessbegrenzung fehlen, waehrend globaler Mutex gehalten wird.
OHNE BEFUND: tc=1-Alt/Neu-Zerlegbarkeit, gemeinsame atomic128-Quelle, bvset-Paar-Wache. Gesamtantwort: (1) nein, (2) nein, (3) nein, (4) nein.
ORT: /home/comdare/wt-b2-neuanker, Diff b1d33cbe..a6a6875b (statische Nur-Lese-Pruefung)
SOLL/FIX: Codex verlangt T2-A-Substanz (persistenter Plan, Fingerprint-Kopplung) vor Freigabe; Fable gibt 5 Pakete frei mit T2-A offen. KONFLIKT der Verdikte (Fable LANDEBEREIT vs. Codex nicht freigabefaehig) — Aufloesung: K1/K2 zielen auf den bewusst gestoppten T2-A-Scope; wsb78kl70 (T2-A-NB) heilt spaeter Indexfolge-Bindung (batchplan-v2), |fpr=-Form, Provider-Einmal-Lesen, tmp-Namen — Designer MUSS pruefen, welche der Codex-Punkte K1/K2/H1-H6/M1c-M3c durch 511671c9/bcc49119/823f6eb5/6c300e68 abgedeckt sind und welche offen bleiben (insb. H1-H4, H6, M1c, M3c tauchen in der NB-Liste NICHT auf).
STATUS LT. QUELLE: offen (zum Berichtszeitpunkt; Teilmenge spaeter adressiert)
ABHAENGIGKEIT/FLAECHE: T2-A/F4-Flaeche; resume-v5-Format; Sidecar; Verdikt-Konflikt Fable vs. Codex
