# Sammelstrecke gruppe_03.txt (Z3967-...) -- Vollaudit Existenz Features/Aufgaben

Quelle: /home/comdare/.claude/jobs/5a19728e/tmp/vollaudit/gruppe_03.txt (4057 Zeilen)
Gelesen: Zeilen 1-300 (KONTEXT-FENSTER 4, Beginn Z3967)

| KUERZEL/Name | Klasse | Quelle | Status LAUT QUELLE | Traeger/Task |
|---|---|---|---|---|
| Gattung/Genus = 4. Layer Observer-Stufe (CEB<->Tier-Vertrag) | FEATURE | Z15,Z37,Z111,Z113 | GEPLANT (vergessen, nicht neu) | Architektur-KERN |
| Wallclock je Tier-Binary-Funktion + Lastkombination JEWEILS gemessen | OWNER-ENTSCHEID | Z16,Z38,Z112 | Owner-Korrektur (Mikro/Makro FALSCH verworfen) | Mess-Layer V5-Kanon |
| Explore IMMER Sonnet 5 max effort "very thourough", nie Fable | OWNER-ENTSCHEID | Z17,Z113 | bindend | Arbeitsweise |
| Maximal parallele Wellen-Bearbeitung | OWNER-ENTSCHEID | Z18,Z114 | bindend | Arbeitsweise |
| Lager-Plan-Korrektur: persistierter sortierter Build-Plan = Inventar-Batch-Cache ueber Sammel-Batch-Segmente | OWNER-ENTSCHEID | Z19,Z115 | bindend, GEPLANT | Lager |
| CI-Loch: Ausschluss loest Wurzel NICHT, verboten | OWNER-ENTSCHEID | Z20,Z117 | bindend | CI |
| Parallele Codex-Scopes statt seriellem Voll-Scope | OWNER-ENTSCHEID | Z21,Z118 | bindend | Arbeitsweise |
| F7 Option b: gesondertes Versionierungs-Interface + CT-Namensfunktion je Stufe (Planer/CEB/Tier) | OWNER-ENTSCHEID | Z22,Z119 | bindend, F7=b gewaehlt | Stempel/Versionierung |
| Konsolidierung vergessener Arbeit: neueste Aussagen gewinnen | OWNER-ENTSCHEID | Z24,Z122 | bindend | Konsolidierung |
| Modell-Matrix: Fable aufgebraucht -> Opus 5 max effort | OWNER-ENTSCHEID | Z25,Z123 | bindend (temporaer fuer diese Session) | Arbeitsweise |
| Cache-Line-Deep-Research: dynamisch/fest je Maschine | AUFGABE | Z26,Z42,Z101,Z125 | BEANTWORTET: 64B in Silizium (Ryzen 9 9950X3D), nur Zaehl-Dimension Phantom | Deep-Research |
| Abbruchsichere Pause (nur Codex-Workflows auslaufen) | OWNER-ENTSCHEID | Z27,Z126 | ausgefuehrt | Betrieb |
| Codex-Timeout auf 2h persistent in Config | OWNER-ENTSCHEID | Z29,Z129 | umgesetzt (settings.json MCP_TIMEOUT/MCP_TOOL_TIMEOUT 7200000) | Config |
| Stempel-Test-Zeichenkette / Lager-Aufbau-Pruefung mit Dummy-Textdokumenten (wieso nicht gelesen?) | AUFGABE | Z30,Z130,Z148,Z164 | OFFEN->dann per Explore BEANTWORTET (s.u. OE-B-Dummy-Lager, Z207) | Verifikation |
| P0 Neuanker (T2-A) | AUFGABE | Z96,Z136 | GEBAUT: 12 Commits a6a6875b..a9a352bb, alle Review-Befunde geheilt | T2-A |
| Trigger-Blocker (CI-Job rot nach Voll-Resume) | REGRESSION | Z97 | BEHOBEN (847c93c9) | CI |
| CI-Wurzel: 9 (nicht 1) ungedeckte Tests | REGRESSION | Z98 | GESCHLOSSEN, Abdeckungs-Invariante gesetzt, empirisch belegt (13.07.-Rueckfall) | CI |
| A/B/C-Delta: 20 Positionen ohne Beleg (vergessene Arbeit) | AUFGABE | Z99 | Konsolidierung: 10 uebernommen/4 superseded/5 erledigt/1 Owner-Entscheid, 3 Befunde entlastet | Konsolidierung |
| B14 CLU-Blocker (Cache-Line-Unit-Konsument, Literal 64) | REGRESSION | Z76,Z100,Z137 | war BLOCKIERT (Fix wuerde Falschwerte 8/16/33/66% statt ~16% erzeugen) -> spaeter BEHOBEN s.u. | B14/system_axis.hpp:336 |
| Zwei-Schreiber-Kollision im Graph-Worktree (SendMessage an laufenden Workflow-Agenten erzeugt 2. Instanz) | REGRESSION | Z82 | BEHOBEN (Ein-Schreiber wiederhergestellt), als Dauer-Falle verbucht | Workflow-Infra |
| Owner-Korrektur "kein CSV-Lager" (Lead hatte xlsx als Sicht auf CSV-Lager dargestellt) | REGRESSION | Z83 | BEHOBEN (richtig: xlsx=Default im Strategy-Pattern) | Lager-Doku |
| Owner-Korrektur Vertragskette Planer->CEB->Tier fehlte in Architektur-Darstellung | REGRESSION | Z84 | BEHOBEN (Dock-Muster nachgeholt) | Architektur-Doku |
| Owner-Korrektur Mikro/Makro: Lead-Zuordnung war Fabrikation ohne Quelle | REGRESSION | Z85 | BEHOBEN (Explore rekonstruierte V5-Kanon) | Mess-Layer |
| Owner-Korrektur Lager-Plan: Lead hatte Codex-Befund mit Code-Kommentar entkraeftet statt Ledger zu pruefen | REGRESSION | Z86 | als Lead-Fehler verbucht | Lager |
| Workflow-Script-Parse-Fehler (Template-Interpolation) | REGRESSION | Z88 | BEHOBEN (auf Array+join umgestellt) | Workflow-Tooling |
| Blindes Resume waere gescheitert (T2-A-Gate verlangt sauberen Baum, 8 WIP-Dateien lagen vor) | REGRESSION | Z89 | umgangen (Fortsetzungs-Welle mit angepasstem Gate) | T2-A-Gate |
| .gitignore *.log schluckt Gate-Logs stumm (3x) | REGRESSION | Z90 | BEHOBEN (force-add) | CI/Gates |
| 404-vs-408-Falle: 2-Pass-Configure | REGRESSION | Z91 | erkannt/dokumentiert (configure->BAU->configure) | Build |
| Codex-Timeouts (4x): git diff darf Codex nicht selbst ausfuehren | REGRESSION | Z92 | BEHOBEN (Workaround: Diff-Text mitliefern + Datei-Lesewerkzeuge) | Codex-Workflow |
| Doppelter CI-Schluessel (contract:axis-version-lock doppelt definiert) | REGRESSION | Z141,Z193 | Agent gestartet zum Heilen (Z194,Z233f Bump-Entscheidung getroffen) | CI |
| LAGER-BASIS-TESTS (Owner-KERN 06.08.): Dummy-Strategien der Stempel-Erkennung | FEATURE | Z171,Z198f | Task #9 CREATED | Lager/Stempel |
| OE-B-Dummy-Lager Testwelle (Textdateien statt Shell/minio-Hydration) | FEATURE | Z206f (Explore-Befund) | GEBAUT, laeuft in CI (Owner-Beschluss 01.08.); liest ABER einen ANDEREN Stempel als die Kostenklammer betrifft | tests/unit/test_lb0_lager_pfad_grammatik.cpp, test_lb1_knoten_heuristik_log.cpp, test_f3_lager_key_provider_iterator.cpp, test_g3_prune.cpp, test_g3_artifact_cache_transport.cpp |
| Factory Pattern zur Stempel-Erkennung aus echter Binary/xlsx | FEATURE | Z207 (Explore-Befund Abschnitt 3) | GAP: nirgends als Ledger-Absatz spezifiziert, NICHTS gebaut (kein Reader gefunden) | Stempel/Versionierung |
| Kostenklammer plan_identitaet_of (cache_engine_builder_iterator.hpp:1167-1171) | REGRESSION | Z207 (Abschnitt 4) | GEPRUEFT: Kollision ENTWARNT/praezisiert; zweites Klammer-Glied ist fail-safe (verhindert std::bad_function_call) | cache_engine_builder_iterator.hpp |
| Kostenklammern-Jagd (4-stufig: alle Klammern finden -> Plan-Soll vs Code-Ist diffen -> Codex-Review -> Anklageschrift) | AUFGABE | Z105,Z229f | GESTARTET (Workflow wif8xpy56) | Kostenklammern |
| plan_ablage_ohne_anker (Wache, aktuell "return false" -- BISS-ZWISCHENSTAND) | REGRESSION | Z268-296 (Reviewer-Meldung EILT A) | UNCOMMITTED, kein Defekt laut Reviewer aber Risiko "tote Wache landet"; NB3-Agent misst Alt-Stand nach | wt-b2-neuanker/cache_engine_builder_iterator.hpp |
| Zweites Klammer-Glied (!cfg.bestand_fingerprint_fn) ist FAIL-SAFE, nicht nur Kosten | FEATURE | Z207,Z293-296 | erkannt (fiele es, entstuende bad_function_call in plan_bau_digest) | cache_engine_builder_iterator.hpp |
| B14 CLU-Blocker geheilt (Weg ii, ABI-POD-Loesung) | REGRESSION | Z163,Z165,Z255-257 | BEHOBEN: Verbraucher hinter Modul-ABI liest POD aus geladener Bibliothek, Zeilengroesse ist Compile-Zeit-Eigenschaft der Binary | B14/NB4-Welle |
| CI-Paket (Rotstelle, Verursacher-Commits, Strategie-Header vom Lock erfasst) | REGRESSION | Z147,Z249 | FERTIG/sauber: genau eine Rotstelle, beide Verursacher-Commits belegt, kein blinder Fleck; Bump entschaerft Wache NICHT, nur umdatiert | CI-Invariante |
| clang-format Gate-Luecke (NB4-Welle ehrlich als "steht aus" gemeldet) | REGRESSION | Z266 | OFFEN, wird nachgeprueft (Auflage: erst melden, nicht selbst durchformatieren) | B14-NB4 |
| unautorisierte Live-Edits im B14-Worktree (codex-b14-super-2 Meldung) | REGRESSION | Z258-266 | gemeldet als KRITISCH, Aufloesung + Gegenpruefung angestossen | B14-super-Worktree |
| Task #1 P0: T2-A -> Dual-Review -> L1-Buendel-Landung | AUFGABE | Z136 | Dual-Review laeuft | T2-A |
| Task #2 P1: B14 (CLU + 11 super-Befunde) | AUFGABE | Z137 | war blockiert, NB4-Voll-Fassung laeuft -> dann geheilt | B14 |
| Task #3 P2: A1-NB2 -> cf22 auf prod1 + Lens + #12-Scope-Zustimmung | AUFGABE | Z138 | offen, P2-P8-Bau nach B14-ce | A1-NB2 |
| Task #4 P3: Ebene-B-Push aktivieren, Lager-Gate G1, E8, Platz-Wache, O-3, super-Host-Belegung batch_plan_datei | AUFGABE | Z139 | offen | diverse |
| Task #5 P4: E18-SNAP-NB3, Graph-Landung (+Gate 8), B12, Aufraeumpass (9 Kandidaten) | AUFGABE | Z140 | offen | diverse |
| Task #6: CI-Invariante gelandet-bereit | AUFGABE | Z141 | gelandet-bereit | CI |
| Task #7: F3-Plan fertig; F6 offen | AUFGABE | Z142 | F3 fertig, F6 OFFEN (Paragraph-47-Achse verworfen? Owner-Frage) | F3/F6 |
| Task #8: Vergessen-Liste V-01..V-20, offen O-4 Anhang-A-Reichweite | AUFGABE | Z143 | OFFEN: O-4 | Vergessen-Liste |
| Offene Owner-Fragen: F6, F8 (Fingerprint-Doktrin), O-4, B14-Bump-Frage | AUFGABE | Z144 | OFFEN | diverse |
| Session-Log-Explore nach vergessener Arbeit + Codex-Rechte mitgeben | AUFGABE | Z11,Z105 | Auftrag erteilt, Codex-Rechte-Wunsch: keine Approval-Prompts | Arbeitsweise |
| Gezieltes Nachlesen der Praeer-Compact-Kartierungen | AUFGABE | Z12,Z107 | Auftrag erteilt | Konsolidierung |
| Architektur-Korrekturen: kein CSV-Lager; Vertragskette Planer->CEB->Tier fehlte | OWNER-ENTSCHEID | Z13,Z109 | bindend, s.o. | Architektur |
| KERN-Regel: keine Unklarheiten nach 1500 Fragen, nur Gedaechtnisluecken; Behauptungen immer pruefen | OWNER-ENTSCHEID | Z14,Z110 | bindend, Dauerregel | Arbeitsweise |
| Codex-git-Haenger-Workaround | FEATURE | Z66 | dokumentiert (Memory feedback_codex_mcp_schreibrechte_mitgeben.md) | Codex-Infra |
| Frozen-Fingerprint Format 3 (8 Glieder, 2 Vektoren je Repo-Kontext) | REFERENCE | Z39 | dokumentiert, TABU (darf nicht fallen) | Fingerprint |
| Lager-Inventar-Batch-Cache (2 Ebenen: grober Zaehler-Resume + feine PresenceFn) | FEATURE | Z40 | GEPLANT, dokumentiert | Lager |
| Cache-Line-Wahrheit (prod1 Ryzen 9 9950X3D, 64B alle Ebenen, Achse permutiert per Header/ALIGNMENT) | REFERENCE | Z42,Z101 | BEANTWORTET | Cache-Line |

| Kostenklammer plan_identitaet_of Glied (1) cfg.batch_plan_datei.empty() | REGRESSION | Z301-320 | Empfehlung: FALLEN LASSEN (Grenzfall, verbotene Begruendungsform aber kein Verhaltensverlust) | cache_engine_builder_iterator.hpp |
| Kostenklammer plan_identitaet_of Glied (2) !cfg.bestand_fingerprint_fn | REGRESSION | Z318-320 | MUSS BLEIBEN (fail-safe) | cache_engine_builder_iterator.hpp |
| LazyRunConfig::batch_plan_korn ohne Produzenten (kein RunProfileArgs-/XML-Feld) | REGRESSION | Z322-325 | GEBAUT aber produktiv NICHT AUSLOESBAR | LazyRunConfig |
| batch_plan_datei im super-Host unbelegt (0 Treffer ueber Code/) | REGRESSION | Z326-327 | ganze F4-Ebene im Trigger-Lauf INERT | F4-Ebene |
| OPT-IN-Naehte: cache_push leer, Reservierung ohne Transport, golden_range_count==0, Messwert-Lager unverdrahtet | UNKLAR | Z328-332 | nur ueberflogen, NICHT einzeln geprueft (keine Kostenklammern, Betreiber laesst Faehigkeit aus) | diverse |
| Gate-Belege-Sicherung Commit 0bda94aa (14 Dateien, 7147 insertions, docs/sessions/backups/20260806-neuanker-t2a-nb2-gates-a9a352bb/) | AUFGABE | Z337-364 | VOLLZOGEN, ungepusht/ungemergt; Vollzaehligkeit 14/14/14 belegt | T2-A-NB2-Gates |
| .gitignore *.log Falle bei Gate-Logs (7 Logs waeren ohne -f verschwunden) | REGRESSION | Z362-364 | BESTAETIGT/belegt, mit -f abgelegt | Gate-Backups |
| Credential-Pruefung der Gate-Logs (glpat/gldt/AKIA/ghp_/PEM/etc.) | AUFGABE | Z366-369 | 0 Treffer, kein Env-Dump | Gate-Backups |
| ugrep-ASCII-Gate-Falle (git diff\|grep '^+'\|grep -P... bricht mit stiller 0 auf ugrep-Hosts) | REGRESSION | Z384-397 | GEFUNDEN, als Memory dokumentiert (reference_ugrep_ascii_gate_stille_null.md); betrifft vermutlich mehrere Wellen rueckwirkend | ASCII-Gates projektweit |
| ASCII-Beleg neu erhoben (Python byteweise): 3310 Zusatzzeilen, 0 Nicht-ASCII, 2 ueber 120 Spalten | REFERENCE | Z394 | gemessen, belastbar | T2A-NB2-Gates |
| Sonden (3 Quellen, 4 Binaries) dauerhaft gesichert | AUFGABE | Z406-410 | BEREIT (Quellen im Commit, Binaries lokal, Bau-Baum steht) | T2A-NB2-Sonden |
| ugrep-Falle relativiert: auf diesem Host (prod1) ist grep=GNU grep 3.11, -P verhaelt sich korrekt, KEINE stille Null | REGRESSION | Z458-468 | WIDERLEGT fuer diesen Host; Warnung bleibt fuer prod1/prod2 relevant, dort ungeprueft | Mess-Falle-Praezisierung |
| Praezisierung: exakt 12 von 18 Belegdateien waren von .gitignore ignoriert (nicht "die meisten") | REFERENCE | Z472 | praezisiert | Gate-Backups |
| B14-NB3-Gate-Belege Commit 9c858a73 (18 Dateien, 22094 insertions, .txt statt .log) | AUFGABE | Z454-531 | VOLLZOGEN, Credential-Scan 0 Treffer (18 Dateien/21990 Zeilen/2790913 Bytes), Vollzaehligkeit 20/20 belegt | B14-NB3-Gates |
| Endung .txt statt git add -f fuer Gate-Logs (Konsistenz mit NB4-Welle) | OWNER-ENTSCHEID | Z485-490 | umgesetzt (Owner-Wunsch: Konsistenz, .log-Name loest Falle weiter aus) | Gate-Backups-Konvention |
| B14-NB4-WIP-Sicherung Commit c1cdc0da | AUFGABE | Z527 | VOLLZOGEN (Provenienz-Beleg + Richtigstellung Fehldeutung) | B14-NB4 |
| Doppelablage NB4-Logs auf development sichtbar (NB3 auf development, NB4 auf b14-golden-kf6 9934a7e5) | REGRESSION | Z529 | als ABSICHT dokumentiert, kein Defekt | Gate-Backups |
| AUFLAGE 1 Barrieren-Kontrakt: drain() gegen paralleles close() haelt nicht (async_push_pump.hpp:96, if (closed_) return;) | REGRESSION | Z541,Z550-599 | ECHT, vom Erst-Review UEBERSEHEN (falsche Frage gestellt); heute NICHT produktiv erreichbar (nur 1 Treiber-Thread); Empfehlung: IN DEN PATCH (Zeile streichen) | async_push_pump.hpp |
| AUFLAGE 2 Fingerprint-Form | REGRESSION | Z543 | ECHT UND PRODUKTIV ERREICHBAR, schaerfer als Codex wusste; Empfehlung ZWINGEND IN DEN PATCH (Details folgen naechster Block) | T2A-NB2-Patch |
| TSAN-Sonde des Erst-Reviews stellte falsche Frage (pushed_count erst nach join/close geprueft) | REGRESSION | Z552-557 | Reviewer-Selbstkorrektur, Codex hatte die richtige Frage gestellt | Review-Methodik |

| AUFLAGE 1 Bau-Anweisung: async_push_pump.hpp drain() Z.94-98, "if (closed_) return;" streichen | REGRESSION | Z603-616 | Bau-Anweisung erteilt (BISS-Kriterium formuliert) | async_push_pump.hpp |
| AUFLAGE 2 (2a) einzelnes leeres Atom deckt sich nicht mit dll_is_current | REGRESSION | Z636,Z651-654 | WAHRSCHEINLICHER Fall, still (Binary fehlt spaeter in Matrix) | plan_bau_digest |
| AUFLAGE 2 (2b) ALLE Atome leer -> Stempel identisch fuer jeden Bau-Stand | REGRESSION | Z639-641,Z647-650 | SCHWERSTER Befund: fail-closed-Wache aus Befund1 greift NICHT | plan_bau_digest |
| AUFLAGE 2 (2c) Trenner '\n' bricht Injektivitaet des Preimage | REGRESSION | Z642,Z655-660 | HEUTE THEORIE (Provider liefert nur "" oder 128 Hex, nicht erreichbar), aber ungeprüfte Annahme im Kommentar | plan_bau_digest |
| Bau-Anweisung Auflage 2: fp_is_hex_128-Praedikat in Digest-Schleife, ueber plan_ablage_ohne_anker | REGRESSION | Z668-691 | Bau-Anweisung erteilt (keine zweite Formwache, Pruefung kostenneutral in Digest-Schleife) | planer_driven_build.hpp/cache_engine_builder_iterator.hpp |
| ugrep-Meldung 2. Korrektur: Ursache ist `grep -v '^\+\+\+'`, nicht `-P`; nur agenten-gemessene Gate-Zusagen betroffen, CI/Skripte/Menschen nicht | REGRESSION | Z699-718 | Reichweite kleiner als gemeldet, Memory korrigiert | Mess-Falle |
| ugrep-Herkunft geklaert: Claude-Code-Bash injiziert Shell-Funktion (exec -a ugrep), echtes /usr/bin/grep=GNU 3.11 | REFERENCE | Z747-755 (codex-t2a-final) | GEKLAERT (kein Host-Unterschied, Werkzeug-Unterschied) | Mess-Falle |
| Eigentlicher Fehler: `grep -v '^\+\+\+'` auf BEIDEN Engines kaputt (BRE \+ = 1-oder-mehr, wirft z.B. "+abc" faelschlich raus) | REGRESSION | Z757-764 | GEFUNDEN (schwerer als gedacht), Korrektur: `grep -v '^+++'` unescaped auf beiden korrekt | ASCII-Gate-Prozedur |
| Live-Gates-Suche: Diff-Pipe-Muster existiert NICHT als persistiertes CI/Skript/CMake-Gate (0 Treffer beide Repos) | REGRESSION | Z768-776 | ENTWARNUNG: kein CI-Ergebnis falsch-gruen; nur manuelle Merkfeld-Prozedur betroffen | ASCII-Selbstcheck-Prozedur |
| pgrep-Selbstmatch-Klammer-Trick (super/.gitlab-ci.yml:138,144) | REFERENCE | Z778 | bereits korrekt, kein neuer Befund | CI-Skripte |
| Empfehlung PIPESTATUS statt pipefail allein (pipefail rettet hier nicht, mittlere Stufe exit 2 geht unter) | AUFGABE | Z784 | EMPFOHLEN, nicht umgesetzt in diesem Abschnitt | ASCII-Gate-Prozedur |
| Ledger-Nachtrag nachmittag-6 (super d938c577, 78 Zeilen) | AUFGABE | Z806-807 | GESCHRIEBEN, nicht gepusht/gemergt | Ledger |
| SHA-Korrektur: super-B14-Heilung ist 2c631551 (nicht 9934a7e5, das ist nur Gate-Spiegel) | REGRESSION | Z817-821 | Doku-Fehler BEHOBEN | super/B14 |
| SHA-Korrektur: CI-Invariante (597ecffe+557d8023, contract:axis-version-lock) liegt im ce-Repo (branch b-r4-ci-abdeckung), nicht im super | REGRESSION | Z822-825 | Doku-Fehler BEHOBEN | ce/CI |
| Status: ALLE VIER (4b38d072, 597ecffe, 557d8023, T2-A-Serie a9a352bb) UNGELANDET, kein Vorfahr von ce origin/development | AUFGABE | Z826-828 | UNGELANDET (Stand dieser Session) | Landung |
| ce-B14-Heilung 4b38d072 | REGRESSION | Z829 | BESTAETIGT | ce/B14 |
| clang-format-Gate bei B14 | REGRESSION | Z832-833 | als UNBELEGT gekennzeichnet (nicht nachgemessen), nicht weggelassen | B14-Gates |
| Fremdstand nachmittag-5 (Owner-KERN Lager-Basis-Tests, 23 Zeilen) im Ledger-Commit mitgegangen | AUFGABE | Z838-847 | bewusst mitgenommen, im Commit-Text benannt | Ledger |
| Owner-Entscheid fortgeschrieben: Kostenklammer Glied (1) faellt GANZ (vorher offen zwischen 3 Optionen) | OWNER-ENTSCHEID | Z843-845 | ENDGUELTIG entschieden | Kostenklammer |
| Host-Belegung pa.batch_plan_datei fehlt weiterhin (0 Treffer Code/) | REGRESSION | Z880-882 | BESTAETIGT weiterhin offen, F4-Ebene inert | F4-Ebene |
| LazyRunConfig::batch_plan_korn ohne Produzenten | REGRESSION | Z882 | BESTAETIGT weiterhin offen | LazyRunConfig |
| Lehre: Heilung von Befund(a) liess "Tuer daneben offen" (Existenz-Bedingung statt Deckungs-Frage) | REFERENCE | Z858-862 | als Prozess-Lehre festgehalten | Review-Methodik |

| Repo-Bestandsaufnahme: super Arbeitsbaum DIRTY (Submodul-Pointer veraltet 3 Commits, Ledger geaendert, 4 untracked) | REGRESSION | Z914,Z921 | AUFFAELLIGKEIT dokumentiert | super-Repo |
| super main-Remotes divergieren (origin/main 9d0f1bad != github/main 030d2c62) | REGRESSION | Z914,Z921 | AUFFAELLIGKEIT, sollte geprueft werden ob gewollt | super-Remotes |
| 8 ungelandete Pakete (T2-A, B14 super, B14 ce, A1-NB2, E18-SNAP, Graph, CI-Invariante, CI-Invariante-Folge) | AUFGABE | Z914,Z921 | ALLE UNGELANDET, aber lueckenlos per rescue-Ref auf beiden Remotes gesichert | Landung |
| Lebend-Check (Bauprozesse/Worktree-Belegung) | AUFGABE | Z914 | 0 Treffer, kein Bauprozess laeuft | Betrieb |
| B14 clang-format-Bericht: super 0 C/C++-Dateien betroffen; ce 4 von 13 Dateien mit Style-Abweichungen | REGRESSION | Z928-938 | GEFUNDEN, NICHT formatiert (wartet Entscheidung) | ce/B14 |
| NB4-Gegenpruefung (A): B1/B2/B4/B5/B6/B7-B11 echte, nicht-tautologische Heilungen | REGRESSION | Z946-947 | BEHOBEN/bestaetigt (3 HOCH + 3 von 5 MITTEL) | B14-NB4 |
| xs:include/xs:import-Blindheit der Schema-Vokabular-Zaehlung (fixture_schema_subset_check.cmake) | REGRESSION | Z950 | VOLLSTAENDIG UNGEHEILT | fixture_schema_subset_check.cmake |
| Namespace-Fragilitaet golden_n_consistency_check.cmake XPath (kein local-name()/namespace-uri()) | REGRESSION | Z951 | VOLLSTAENDIG UNGEHEILT (auch neue B2-Wurzelverankerung erbt Schwaeche, aber fail-closed) | golden_n_consistency_check.cmake |
| comdare_xml_count() erkennt %g-Notation nicht (z.B. "1e+06") | REGRESSION | Z952 | VOLLSTAENDIG UNGEHEILT (aktuell irrelevant bei ~19 Achsen, generische Infra-Schwaeche) | cmake-Infra |
| Temp-Datei-Handling comdare_xml_open (RANDOM LENGTH 8, kein TIMEOUT, kein Cleanup bei FATAL_ERROR) | REGRESSION | Z953 | VOLLSTAENDIG UNGEHEILT | comdare_xml_open |
| Opus-XXE-Befund (i): xmllint --noent liest lokale Datei-Entities erfolgreich, RC=0 leer | REGRESSION | Z924,Z956-960 | WEITERHIN OFFEN nach B14-NB4, LIVE bewiesen (Kanarienvogel-Test); B3-stderr-Riegel loest ANDERES Problem (False-Negative bei blockierter Netz-Entity), nicht den echten XXE | xmllint-Aufrufe |
| NEUER Befund (D): golden_n_consistency_check.cmake foreach(_mi RANGE 1 _n_modes) bei _n_modes=0 iteriert "1;0" statt 0mal (CMake 4.3.4 empirisch) | REGRESSION | Z962-964 | NEU GEFUNDEN, heute DORMANT (_n_modes=1 in Praxis), unter Kostenklammer-Doktrin nicht mehr entlastbar | golden_n_consistency_check.cmake |
| Nebenbefund (E): _has_active in B6 lehnt jeden Wert ab (auch active="true") | UNKLAR | Z966 | laut Code-Kommentar bewusster Stolperdraht, niedrige Prio | B6/XML-Wachen |
| GESAMTURTEIL NB4: NICHT landereif wegen (C) XXE und (D) foreach-Bug | REGRESSION | Z968,Z972,Z975 | Lead-Korrektur: "B14 doch nicht landereif" | B14-NB4 |
| Host-Belegung batch_plan_datei Vorarbeit (super Commit 6dc01930, Plan 301 Zeilen) | AUFGABE | Z985-986 | GESCHRIEBEN, nicht gepusht | Host-Belegung-Plan |
| Formwache-Test gegen 320 golden-ids: 320/320 gueltig, Gegenprobe 3 Alt-ABI-Formen je 320/320 LEER | REGRESSION | Z989-1007 | ENTWARNT, GEMESSEN (Formwache greift scharf, wuerde Plan-Ablage nicht stilllegen) | Formwache/plan_identitaet_of |
| Eigentlicher Blocker F7: bis zu 156 Paesse ueberschreiben dieselbe Plan-Datei (jede Ueberschreibung invalidiert vorige) | REGRESSION | Z1012-1023 | ERKANNT, entscheidet ueber Wert der Host-Belegungs-Welle | F7/batch_plan_datei |
| Spezifikation "liegt fertig vor" (Ledger mittag-16) verweist auf KEIN auffindbares Dokument | REGRESSION | Z1028-1034 | Doku-Luecke erkannt, inhaltlich richtig aber kein Dokument; neuer Plan schliesst Luecke | Spezifikation/Host-Belegung |
| "F7=Option b" vs "Option 1 bis Abgabe" | REFERENCE | Z1036-1040 | KEIN Widerspruch, aufgeloest (Zielform vs Zwischenstand) | F7 |
| batch_plan_korn Empfehlung: NICHT VERDRAHTEN (fehlende Kette, Divergenz-Risiko Bau/Mess) | AUFGABE | Z1054-1059 | EMPFOHLEN als eigener Posten NACH Abgabe | batch_plan_korn |
| VIER OWNER-ENTSCHEIDE benannt: (1) Ebene vor Abgabe scharf? (2) Plan-Datei-Ort? (3) Option2 als Zwischenschritt? (4) Env oder XML? | OWNER-ENTSCHEID | Z1062-1076 | (1) und (2)-(4) als EMPFEHLUNGEN vorgelegt, (1) SPAETER REVIDIERT (s.u.) | Host-Belegung |
| CI-Diff-ASCII-Width-Guard Skript (ci_diff_ascii_width_guard.sh, 348 Zeilen, POSIX sh+awk, ersetzt grep-Prozedur) | FEATURE | Z1112-1118 | GEBAUT, 4 Biss-Beweise BESTANDEN (Nicht-ASCII, >120-Spalten, Regressionstest "+++"+Umlaut, sauberer Diff) | ci_diff_ascii_width_guard.sh |
| Staging-Kollision: 9 statt 2 Dateien im Index (7 fremde Bau-Agent-Dateien bereits staged) | REGRESSION | Z1103-1123 | SOFORT korrekt behandelt (restore --staged nur eigene Pfade), kein Schaden, GO fuer Commit-Weg abgefragt | wt-b2-neuanker Index |
| CI-Anbindung .gitlab-ci.yml fuer ASCII-Width-Guard (an lint:format angehaengt, kein neuer Job) | FEATURE | Z1119-1121 | GEBAUT, wartet auf GO (Umzug nach wt-b-r4-ci angeordnet) | .gitlab-ci.yml |
| T2-A-Patch (Fail-closed Plan-Stempel: Klammer Glied1 weg, Barriere async_push_pump, Fingerprint-Formwache) | AUFGABE | Z1130-1133 | GEBAUT: Commit 71b5586a | T2-A-Patch |
| Selektions-Paesse Zahl: 18, nicht 1 (all_axes_golden/m3_golden_coverage/m3_smoke_coverage 17->18; m3v2_study/sota_pilot 8->9; m3v2_smoke 2->3) | REGRESSION | Z1143-1160 | GEMESSEN (statisch, ohne Lauf); bestaetigt Ledger-Rechnung 4x(1+17+21)=156 | profile_sweep_passes |
| Verschaerfender Fund: teuerster Pass ist der ERSTE (Chunk-Fenster nur fuer Basis-Pass, von 17 Folge-Paessen ueberschrieben) | REGRESSION | Z1163-1175 | NEU GEFUNDEN, macht Host-Belegung fuer den eigentlichen Zweck WIRKUNGSLOS | Chunk-Fenster/profile_run_entry.hpp:762 |
| Zahl auf 1 bringen? Mechanisch moeglich, fachlich NEIN (Sweep-Paesse = eigene Mess-Substanz, Ruecknahme waere GO-5 B.1 rueckgaengig) | REGRESSION | Z1178-1187 | ABGELEHNT als Option | Selektions-Paesse |
| Owner-Entscheid 1 Empfehlung REVIDIERT: Host-Belegung NICHT vor Abgabe scharf stellen | OWNER-ENTSCHEID | Z1143,Z1190-1199 | Empfehlung gekippt (Bedingung "Pass-Zahl=1" nicht erfuellt); Belegung+Option2 gehoeren in dieselbe Welle NACH Abgabe (haengt an Versionierungs-Interface) | Host-Belegung |

| Gegenpruefung T2-A-Patch 71b5586a | AUFGABE | Z1254 | VERDIKT: LANDEN (beide Befunde+beide Codex-Auflagen gebaut oder begruendet offen, kein Blocker) | T2-A-Patch |
| Befund 1 (Kollisions-Eimer/ohne-anker) wirklich zu | REGRESSION | Z1261-1269 | BEHOBEN, literal bestaetigt (fail-closed, kein Plan-Dokument, kein Phasen-Zaehler) | plan_anker_befund |
| Praefix-Abschneidung an offen>0 mit present_-Gate | REGRESSION | Z1271-1272,Z1309-1332,Z1395-1396 | NICHT GEBAUT, bewusst; Loesung skizziert (present_-Gate); Auflage fuer NACH-ABGABE-Welle | filter_window_for_build/planer_driven_build.hpp:137-140 |
| Keine neue stille Stelle im Patch gefunden | REGRESSION | Z1274-1276 | GEPRUEFT, KEINE gefunden (ein Gate, eine Meldezeile fuer beide Wege) | T2-A-Patch |
| TSAN+Gates nach Patch: 0 Warnungen, 409 Tests 100% (2 Laeufe), Frozen-Vektor unbewegt | AUFGABE | Z1278-1285 | BESTAETIGT gruen | T2-A-Patch-Verifikation |
| Formwache laeuft IN Digest-Schleife (1 Durchlauf je Selektion) | REGRESSION | Z1287-1289 | BESTAETIGT (kein zweiter Provider-Aufruf) | plan_bau_digest |
| Formwache geht ueber erweitertes plan_anker_befund (statt 2. Klammer) | REGRESSION | Z1290-1292 | BESTAETIGT, besser als vorgeschlagen (ein Gate statt zwei) | plan_anker_befund |
| Bauer-Begruendung Nicht-Abbruch bei Verstoss (Kosten 320fp=2ms, ~820ms/2^17) | REGRESSION | Z1297-1304 | GEPRUEFT, TRAEGT (kein Kostenklammer-Argument, richtig so gebaut) | plan_bau_digest |
| Formwache plan-global statt atom-fein (1/1 LEER bei Minimal-Profil laesst Ebene inert) | REGRESSION | Z1334-1345 | GEMESSEN als RICHTIG (kein Defekt); Verfeinerung = Folgeposten niedrige Prio | Formwache |
| Fassaden-Test verifiziert: alter gruener Stand hielt nur weil COMDARE_BESTANDSLOG ungesetzt war | REGRESSION | Z1347-1360 | war "gruene Tests zementieren falsche Ordnung"; Bauer hat Test nachgefuehrt (setenv gesetzt), NICHT geloescht -> jetzt scharf | Fassaden-Test |
| clang-format: verfuegbar (cf22), Patch bringt +26 Abweichungen (Delta-Tabelle 4 Dateien) | REGRESSION | Z1363-1378 | GEFUNDEN, Auflage: vor L1-Landung clang-format -i + Gates wiederholen | T2-A-Patch/3 Dateien |
| Minor: gefallene Kostenklammer asymmetrisch (Bau-Weg unbedingt, Mess-Weg noch Pfad-Klammer) | REGRESSION | Z1383-1390 | dokumentiert, KEIN Handlungsbedarf (Struktur-Gate im Mess-Weg gerechtfertigt) | plan_anker_befund |
| P0 T2-A Gesamtstatus | AUFGABE | Z1427 | LANDEREIF (TaskUpdate #1) | T2-A |
| Landungs-Trockenprobe vor L1-Buendel-Merge (Konflikte zw. Paketen, Frozen/Schutz-Frage) | AUFGABE | Z1417 | GESTARTET (read-only) | L1-Landung |
| clang-format-Fehlmeldung "nicht installiert" | REGRESSION | Z1439-1440 | war EIGENER FEHLER (find / lief in 120s-Timeout), korrigiert -- clang-format war vorhanden | Werkzeug-Diagnose |
| clang-format-Nachzug Commit 034e0068 (3 Dateien, +102/-111) | AUFGABE | Z1437,Z1449-1456 | GEBAUT, nicht gepusht/gemergt | T2-A-Format-Nachzug |
| Gates nach Format-Nachzug: 409 Tests x2 100%, 8 Frozen-Dateien identisch, ASCII 0/102, TABU 0/3, Trockenlauf 7 Dateien 0 Ausgabe | AUFGABE | Z1461-1493 | BESTAETIGT gruen | T2-A-Format-Verifikation |
| Fachliche Substanz nach Format unveraendert (tp1: 245 OK, facade: 20 OK) | AUFGABE | Z1496 | BESTAETIGT unveraendert | T2-A-Tests |

| Landungs-Trockenprobe (git merge-tree --write-tree, rein rechnerisch) | AUFGABE | Z1504-1509 | FERTIG: 0 Merge-Konflikte in allen Kombinationen, aber Reihenfolge nicht frei | L1-Landung |
| Additiver Fallstrick (CMakeLists.txt Ueberschneidungen A1/T2A/B14) | REGRESSION | Z1520-1527 | GEPRUEFT: 0 doppelte Targets/Tests (75->77, 5100->5227 Zeilen) | tests/unit/CMakeLists.txt |
| R4CI und CI-Invariante sind EIN Paket (b-r4-ci-abdeckung traegt 557d8023 als Vorfahr) | REFERENCE | Z1526-1527 | BESTAETIGT (Owner-Vermutung) | R4CI |
| Neue Wache ci_diff_ascii_width_guard stellt 2 Pakete ROT: b2-neuanker-format3 (9 Zeilen>120), b14-ce-anteil (2 Zeilen>120, davon 1x 138 Byte) | REGRESSION | Z1530-1550 | GEFUNDEN (Landereihenfolgen-Blocker: R4CI muss ZULETZT landen) | ci_diff_ascii_width_guard.sh |
| Empfohlene Landereihenfolge: ce(T2-A->A1-NB2->B14-ce->R4CI zuletzt), super(B14-super/Graph/E18-SNAP frei) | AUFGABE | Z1558-1576 | EMPFOHLEN | L1-Landung |
| Frozen/TABU-Pruefung ueber gesamtes Buendel | REFERENCE | Z1579-1593 | HAELT: 0 Reste Alt-Vektor, TABU unbewegt, CRC64-Anker unveraendert | L1-Landung |
| Submodul-Zeiger-Rezept (ce zuerst landen, dann Zeiger als eigener Commit, dann super-Pakete) | AUFGABE | Z1596-1616 | KLARGESTELLT: kein Paket fasst Zeiger an, Rezept vorgegeben | Submodul-Landung |
| main-Divergenz-Meldung war Fehldeutung (9d0f1bad = lokaler 10 Tage alter Branch, keine Remote-Divergenz) | REGRESSION | Z1619-1640,Z1707 | Lead-Fehlmeldung KORRIGIERT (Zeile falsch gelesen); Falle bleibt: checkout main landet auf altem Stand | super/main |
| XXE-Befund (i) endgueltig geheilt: --noent ueberall entfernt + DOCTYPE strukturell verboten (comdare_xml_has_doctype) | REGRESSION | Z1665-1672 | BEHOBEN (super cb4b15e9), Kanarienvogel-Test VORHER/NACHHER belegt (RC=0->RC=1) | XML-Wachen |
| B6 foreach(RANGE)-Defekt (D) geheilt: explizite Null-Pruefung vor foreach | REGRESSION | Z1674-1678 | BEHOBEN (super cb4b15e9), Gegenproben bestanden | golden_n_consistency_check.cmake |
| xs:include/xs:import Restposten | REGRESSION | Z1681 | TEILWEISE BEHOBEN (eine Ebene jetzt mitgezaehlt) | fixture_schema_subset_check.cmake |
| Namespace-Fragilitaet Restposten | REGRESSION | Z1682 | BEWUSST NICHT GEFIXT (Parser selbst namensraum-unwissend, Wache waere sonst permissiver als Parser) | golden_n_consistency_check.cmake |
| comdare_xml_count %g-Grenze Restposten | REGRESSION | Z1683 | NICHT BEHOBEN, aber GETESTET dokumentiert (Schwelle 10^9-10^12, irrelevant bei <20 Achsen) | comdare_xml_count |
| Temp-Handling Restposten (16 statt 8 Hex, EXISTS-Gegenprobe, TIMEOUT 10, Sweep) | REGRESSION | Z1684 | TEILWEISE BEHOBEN; Cleanup bei FATAL zwischen open/close STRUKTURELL ungeloest (CMake-Grenze) | comdare_xml_open |
| clang-format ce (4 Dateien, eigener Commit) | REGRESSION | Z1686-1687 | BEHOBEN: RC=0 leer ueber alle 13 Dateien der B14-Welle | ce/B14-Format |
| Stolperdraht-Meldung (E) nachgeschaerft (Wert-irrelevant-Hinweis in FATAL-Text) | REGRESSION | Z1689-1690 | VERBESSERT (kein Fix noetig, nur Meldungstext) | B6/XML-Wachen |
| Eigener Fast-Fehler ASCII-Check (Pipe-Exit-Code $? nach grep\|head war head's RC) | REGRESSION | Z1701 | SELBST erkannt und korrigiert, kein Schaden | codex-b14-super-2/Selbstcheck |
| B14-super/ce FAZIT NB5 | AUFGABE | Z1703 | "sollte jetzt kein Blocker mehr sein", bereit fuer Gegenpruefung | B14-NB5 |
| Auflage: B14-ce abi_adapter.hpp:78 (138 Byte) kuerzen vor Landung | AUFGABE | Z1708 | ERTEILT | B14-ce |
| T2-A Wache-Wiederholung NACH Format-Commit: WEITERHIN ROT, dieselben 9 Verstoesse | REGRESSION | Z1727-1769 | NICHT LANDEREIF (Format-Commit 034e0068 hatte FALSCHE Dateien angefasst -- 0 Ueberschneidung mit Verstoss-Dateien) | T2-A-Serie/ci_diff_ascii_width_guard |
| Nachpruefung: 8 von 9 Verstoessen heilt clang-format auf den RICHTIGEN 5 Dateien, 1 bleibt (toolchain_stamp_glied.hpp:521, Doxygen-Kommentar 121 Byte, aus aa46c524) | REGRESSION | Z1774-1797 | Fix klein/eindeutig identifiziert (clang-format -i auf 5 Dateien + 1 manuelle Zeile) | toolchain_stamp_glied.hpp |

| T2-A Wache-Blocker: 2 Wege vorgeschlagen (heilen vs R4CI zuletzt+stehenlassen) | AUFGABE | Z1807-1816 | Lead waehlt Weg1 (heilen), inkl. B14-Mitloesung | T2-A/B14 |
| K-01 Kostenklammer: plan_identitaet_of/Bestandslog-Fingerprint-Gate in JEDEM real existierenden Aufruf TOT (COMDARE_BESTANDSLOG nirgends gesetzt) | REGRESSION | Z1848 (K-01) | GEFUNDEN von Kostenklammern-Jagd, dann zur Pruefung geschickt -> SPAETER WIDERLEGT (s.u.) | plan_identitaet_of/lazy_fingerprint |
| K-01(e) ZERSTOERT GEPLANTE ARBEIT: plan_ablage_ohne_anker macht stillen Fehler laut, aber Mechanismus bleibt funktionslos | REGRESSION | Z1848 | Zusatzbefund zu K-01, ebenfalls spaeter zu bewerten | plan_ablage_ohne_anker |
| K-02 plan_bau_digest: kPlanOhneAnker als Dauerzustand statt Ausnahme | REGRESSION | Z1848 | VERZOEGERT eingestuft (Code selbst korrekt/fail-closed, aber Zweig nie betreten wegen K-01) | planer_driven_build.hpp:297-312 |
| K-03 plan_resume_faecher liest PlanFach::offen nirgends (nur Fach-, nicht Atom-Granularitaet beim Resume) | REGRESSION | Z1848 | VERZOEGERT eingestuft, bewusst dokumentiert aber Owner-Auftrag verlangt keinen Freispruch; wartet auf ETA/Kalibrierungs-Architektur F5/F6 | batch_planner.hpp:160-166,217-232 |
| (weitere K-04+ Kostenklammern, Ergebnis 57006 Zeichen gekappt/truncated) | UNKLAR | Z1849 | Volltext nicht vollstaendig sichtbar in diesem Extrakt (gekappt) | Kostenklammer-Anklage |
| B14-ce Width-Guard-Auflage: Diff-Referenzpunkt-Diskrepanz (16a173f2 vs merge-base c837d830) | REGRESSION | Z1863 | GEFUNDEN, ueber BEIDE Diffs gefahren (identisches Ergebnis), als moegliche Luecke gemeldet | B14-ce/Diff-Referenz |
| Eigene Panne codex-b14-super-2: clang-format -i ueber ganze Testdatei reformatierte 3 unbeteiligte Stellen | REGRESSION | Z1865 | SELBST bemerkt+korrigiert (git checkout, dann manueller gezielter Umbruch) | test_b14_abi_adapter_line_subaxis_paths.cpp |
| B14-ce 2 Verstoesse (abi_adapter.hpp:78, test_b14_..._paths.cpp:138) gekuerzt | REGRESSION | Z1867-1886 | BEHOBEN: Wache VORHER ROT(2)->NACHHER GRUEN(0); Commit cc20b63d | B14-ce |
| B14-ce Tests nach Kuerzung (4/4, 11/11, 6/6) | AUFGABE | Z1891-1892 | BESTAETIGT PASSED | B14-ce-Tests |
| B14-ce Gesamtstatus | AUFGABE | Z1897,Z1913 | LANDBEREIT (Task #2 Update: beide Blocker geheilt, Wache gruen) | B14 |
| Pruefbereich-Fehlermuster generalisiert (Format-Commit/enger Anker vs korrekte merge-base) | REFERENCE | Z1901-1904,Z2026 | ALS MUSTER erkannt, 3x bestaetigt (T2-A, B14-ce, b14-super eigenes Paket) | Gate-Pruefmethodik |
| T2-A Nachzug Commit b6d87c08 (9 Spaltenbreiten-Verstoesse der Serie geheilt) | REGRESSION | Z1923-1988 | BEHOBEN: 5 Dateien formatiert (10/6/4/15/16 ->0 je), 9. Zeile von Hand (toolchain_stamp_glied.hpp) umgebrochen, Inhalt maschinell identisch belegt; Wache GRUEN (0/7333, 27 Commits) | T2-A-Serie |
| Zwischenfehler bei Nachzug: verkettete Serien+Arbeitsbaum-Diff, zaehlte Alt-Zeilen doppelt | REGRESSION | Z1975 | SELBST gemacht+korrigiert | Wache-Messung |
| Gates nach T2-A-Nachzug (Voll-Bau, 2x ctest 409/409, Frozen 8/8, TABU 0/5, clang-format 0 Ausgabe) | AUFGABE | Z1980-1984 | BESTAETIGT gruen | T2-A-Verifikation |
| L1-Bundle-Vollmessung aller 6 Pakete gegen korrekte merge-base | AUFGABE | Z1996-2029 | a1 GRUEN, r4 GRUEN, e18snap GRUEN* (0 im Scope, korrekt), b14-ce GRUEN; graph ROT (2), b14-super ROT (2) | L1-Bundle |
| graph 2 Verstoesse (diagram_generator.cpp:432,1130, eigene Branch-Commits Opus 5) | REGRESSION | Z2013-2016 | GEFUNDEN, noch NICHT geheilt (Auftrag erteilt Z2034) | Code/05_diagram_generator/diagram_generator.cpp |
| b14-super 2 Verstoesse (CMakeLists.txt:205, golden_n_consistency_check.cmake:14) | REGRESSION | Z2018-2021 | GEFUNDEN, geerbte Altlast aus B14-NB2 (953ce412), AELTER als eigene NB3/NB5-Arbeit; noch NICHT geheilt (Auftrag erteilt) | Code/tests/CMakeLists.txt |
| Heilungsauftrag graph+b14-super (4 Verstoesse) | AUFGABE | Z2033-2034 | ERTEILT | graph/b14-super |
| Owner-Auftrag: "Pipeline irgendwann auch mal laufen, mit durch codex exzessiv vorgeschlagenen Tests grün durchlaufen" | OWNER-ENTSCHEID | Z2044 | ERTEILT (nach Abschluss dieses Blocks) | Pipeline/Testoffensive |
| Workflow anklage-rest-und-testoffensive (restliche Kostenklammer-Posten + Codex-Testoffensive) | AUFGABE | Z2046-2047 | GESTARTET (Task ww7eb5key) | Kostenklammer-Rest/Testoffensive |
| T2-A Landung ausgeloest (ce-Reihenfolge, lokal, kein Push) | AUFGABE | Z2049-2050 | GESTARTET | T2-A-Landung |
| merge-base 7969b399 fuer T2-A bestaetigt (kein B14-Fehler wiederholt) | REFERENCE | Z2059-2069 | BESTAETIGT korrekt von Anfang an gemessen | T2-A/merge-base |
| T2-A dritte Messung: GRUEN, LANDEREIF | AUFGABE | Z2075-2087 | BESTAETIGT final gruen (0 Verstoesse/7333, Frozen unbewegt, 409/409x2, golden/roundtrip 12/12) | T2-A |
| Praezisierung Formulierung "3 Frozen-Fixtures blob-identisch" gilt NICHT mehr seit b6d87c08 (Frozen-BLOCK weiterhin byte-identisch) | REFERENCE | Z2089-2092 | Formulierung korrigiert (test_m_w12 mitformatiert, Hunks ausserhalb Frozen-BLOCK) | Frozen-Vektor-Formulierung |
| K-01 IST WIDERLEGT (Repo-Grep mit Laufzeit-Aussage verwechselt) | REGRESSION | Z2095-2100 (Fortsetzung im naechsten Block) | WIDERLEGT (Details folgen Block 8) | K-01/plan_identitaet_of |

| K-01 WIDERLEGT: COMDARE_BESTANDSLOG WIRD gesetzt, ueber Emissions-Weg (experiment_plan_director.hpp:952-955, append_forward_var_literal ins generierte CI-YAML) | REGRESSION | Z2105-2119 | K-01 WIDERLEGT: Kette existiert und ist GETESTET (test_experiment_plan_director.cpp:845-860); Repo-Grep-Aussage war richtig, Laufzeit-Schlussfolgerung falsch | experiment_plan_director.hpp |
| Widerspruch K-01 vs Formwache-Messung aufgeloest (gleiches Wurzel-Gate, verschiedene 2. Bedingung: tier_realversion_ist_bekannt() vs minio_enabled()) | REFERENCE | Z2121-2132 | AUFGELOEST, beide Aussagen richtig nebeneinander | lazy_fingerprint/bestand_key_of |
| Landefaehigkeit T2-A durch K-01-Widerlegung UNVERAENDERT, aber staerker begruendet (Ebene erreichbar, nicht nur theoretisch korrekt) | REGRESSION | Z2134-2137 | BESTAETIGT | T2-A |
| Ehrliche Grenze: ob TRIGGER-Lauf COMDARE_BESTANDSLOG real traegt, ist Owner-/Infra-Frage, keine Code-Frage | UNKLAR | Z2139-2143 | OFFEN (Infra/Runner-Env, nicht code-seitig entscheidbar) | Trigger-Lauf-Umgebung |
| Ledger-Nachtrag nachmittag-7 (super 7a26b754, 178 Zeilen) | AUFGABE | Z2148-2149 | GESCHRIEBEN, nicht gepusht | Ledger |
| super-Trockenprobe (b14-super, graph, e18snap) via merge-tree | AUFGABE | Z2185-2203 | GRUEN: paarweise+kaskadiert RC=0, Duplikat-Check 427 Tests 0 Duplikate, TABU nicht beruehrt | super-Landung |
| E18-SNAP altes Verdikt (NICHT-LANDEN, Anforderungen 2-5 nicht erfuellt, CI-Patch nicht angewandt) | REGRESSION | Z2206-2215 | Status BESTAETIGT WEITERHIN GUELTIG (2 Stichproben live nachgemessen: CI-Patch greift noch sauber = nicht eingespielt; Bash-case-Hex-Bug reproduziert) | e18-snap-welle |
| E18-SNAP Abgabe-Relevanz | AUFGABE | Z2217-2219 | NICHT ABGABE-RELEVANT (P4, CI-Job heute inert); EMPFEHLUNG: NB3 NICHT jetzt, nach Abgabe | E18-SNAP |
| GO fuer super-Landung ohne E18-SNAP | AUFGABE | Z2224-2227 | ERTEILT (Task #5 Update) | super-Landung |
| ce-LANDUNG VOLLZOGEN: T2-A (86be2420), B14 (f577f886), Wache/R4CI (b5e0e4e7) in development | AUFGABE | Z2238-2246 | GELANDET (--no-ff, kein rebase), 46 Commits ungepusht, main unberuehrt | ce/development |
| A1-NB2 NICHT in der Landung enthalten (bewusst uebersprungen, fehlende Lens-Bestaetigung) | AUFGABE | Z2250-2255 | UEBERSPRUNGEN, Wache waere gruen gewesen, wartet auf Freigabe | A1-NB2 |
| B14-Widerspruch (ROT vs GRUEN) aufgeloest: kein Wachen-Defekt, Branch bewegte sich unter Messung | REGRESSION | Z2258-2265 | AUFGELOEST (Messung an 2a58e2ed war ROT korrekt, cc20b63d ist GRUEN korrekt) | B14/Wachen-Koordinaten |
| Gates je Merge (T2-A/B14/Wache): 0 error, 405/407/407 Tests 100% x2 | AUFGABE | Z2270-2272 | BESTAETIGT gruen | ce-Landung |
| Testzahl-Diskrepanz 407 vs 409 geklaert (4 Tests haengen an Configure-Zeit-Bau-Zustand, nicht Code) | REGRESSION | Z2274-2283 | GEKLAERT, kein Testverlust (405 frisch + 2 neue B14 = 407) | Test-Registrierung |
| Probe aufs Exempel: gelandete Wache ueber gelandeten Stand (3bbcb8ed..HEAD) | AUFGABE | Z2288-2296 | BESTAETIGT GRUEN (8792 Zusatzzeilen, 0 Verstoesse) | ce-Landung |
| Abdeckungs-Invariante nach Landung (407/407 Tests von fahrendem Job ausgefuehrt) | AUFGABE | Z2299-2306 | BESTAETIGT GRUEN, kein blinder Fleck | CI-Coverage |
| Frozen/TABU ueber gelandeten ce-Stand | REFERENCE | Z2309-2316 | HAELT, unbewegt, Alt-Vektor 0 Treffer | ce-Landung |
| Offene Punkte nach ce-Landung (Push+main-FF, super wartet auf Breiten-Heilung, Submodul-Bump, A1 bei Lens-OK, erster Pipeline-Lauf) | AUFGABE | Z2318-2327 | LISTE erstellt, an Lead uebergeben | ce-Landung-Nachfolge |
| Vollzugs-Nachtrag + Push mit gitleaks angewiesen | AUFGABE | Z2336-2338 | ERTEILT | ce-Landung |
| super-Landung (b14-super, graph) auf Scratch-Branch l1-super-landung-scratch | AUFGABE | Z2342-2360 | GELANDET auf Scratch (0 Verstoesse, +3/+27 neue Tests alle bestanden, 402 Vorbestand-Fehlschlaege byte-identisch = kein Regressions-Neuzugang) | super-Landung |
| Ursache 402 Fehlschlaege in super: "Use Cache-Engine sub: OFF" (Vorbestand, nicht durch Landung verursacht) | REGRESSION | Z2360 | GEKLAERT, kein neuer Defekt | super-Configure |
| Frozen-Block super-seitig gesucht, NICHT gefunden (Lead-Auflage war ce-seitig gemeint) | REGRESSION | Z2364 | AUFGELOEST (Missverstaendnis, kein Defekt) | super-Frozen |
| Hindernis: development-Ref-Update blockiert (Worktree-Konflikt, primaerer Checkout dirty durch Fremdarbeit an Submodul-Zeiger) | REGRESSION | Z2366-2369 | NICHT umgangen (kein force), 3 Wege vorgeschlagen, an Lead eskaliert | super-Landung/development-Ref |
| Blockade development-Ref geloest (Lead fuehrt Fast-Forward-Merge selbst aus) | AUFGABE | Z2373-2378 | GELOEST: development steht auf 725ead43 | super/development |
| Beide Repos gelandet (ce 3 Pakete, super 2 Pakete), Pushes laufen | AUFGABE | Z2381-2388 | ERLEDIGT/laufend | ce+super-Landung |
| Ledger-Nachtrag nachmittag-8 (super ff52ccde, 148 Zeilen) | AUFGABE | Z2391-2397 | GESCHRIEBEN als NEUER Nachtrag (nicht Ergaenzung), nicht gepusht | Ledger |

| Sechste Regel-Zeile (spaeter benannt): SECHSTE REGEL ist eigentlich "Ein gruenes Gate deckt nur seinen eigenen Gegenstand" | REFERENCE | Z2404-2419,Z2644-2646 | als Lehre im Ledger nachmittag-8 festgehalten (4 gleichartige Faelle desselben Tages) | Gate-Methodik |
| Eigener Nicht-ASCII-Fehler im Ledger-Entwurf (7 Zeilen, 9 Mittelpunkte) | REGRESSION | Z2421-2424 | SELBST vor Commit gefunden+korrigiert (Endstand 0 Nicht-ASCII) | Ledger-Nachtrag nachmittag-8 |
| FF-Stand-Verifikation (HEAD ff52ccde statt erwartet 725ead43, additiver Ledger-Commit) | REFERENCE | Z2447-2450 | GEKLAERT, kein Fremdinhalt | super/development |
| Probe aufs Exempel super: ci_diff_ascii_width_guard.sh liegt NICHT im super-Repo | REFERENCE | Z2452-2453 | REPO-GRENZE bestaetigt, keine Luecke | super-Repo |
| GITLEAKS-Funde super: 776 Token in 2 Dateien (e23-Backup-ndjson), Commit 44820451 (02.08.) | REGRESSION | Z2455-2464 | GEFUNDEN, liegt NICHT in development (nur Backup-Refs), development-only-Scan RC=0 sauber; Push GESTOPPT bis Owner-GO | super/Backup-Refs |
| GO fuer super-Push (Backup-Refs bleiben unangetastet) | AUFGABE | Z2468-2470 | ERTEILT | super-Push |
| KRITISCHER SICHERHEITSBEFUND: refs/backup/pre-secret-scrub-20260802 liegt BEREITS auf origin/gitlab (776 Runner-Token ueber Git-Protokoll erreichbar) | REGRESSION | Z2481-2490 | GEFUNDEN, NICHT durch diesen Push verursacht (aelter, vermutlich seit 02.08.); NICHTS veraendert/geloescht (Auflage), an Owner eskaliert | gitlab origin/refs/backup |
| Task #10 SICHERHEIT (OWNER-ENTSCHEID): 776 Runner-Token auf gitlab origin erreichbar | AUFGABE | Z2508-2509 | ERSTELLT, OFFEN (Token rotieren + Ref serverseitig entfernen ausstehend) | Sicherheit/gitlab-Backup-Ref |
| super-Push erledigt (development b2bd4760..3cd50a2a, beide Remotes) | AUFGABE | Z2492-2496 | ERLEDIGT | super-Push |
| Pipeline super (Projekt 288, ID 15023) nach Push | AUFGABE | Z2520-2529 | FAILED: 12/13 gruen, 1 rot (lint:format); lint:secrets GRUEN bestaetigt Push sauber | super-Pipeline |
| lint:format ROT super: 160 Verstoesse in 8 graph-Dateien (clang-format nie gefahren vor Landung) | REGRESSION | Z2531-2548 | GEFUNDEN, Formatierungsauftrag erteilt | graph-Paket (Code/04,05,08_*) |
| ce-Push (b5e0e4e7) bereits durch, beide Repos synchron, main unangetastet | AUFGABE | Z2569-2582 | BESTAETIGT | ce+super-Push |
| Pipeline ce (Projekt 286, ID 15022) nach Push | AUFGABE | Z2585-2603 | FAILED nach 289s: 17 success, 1 manual, 2 failed (lint:format, lint:static); Substanz (Tests, Sanitizer, Contracts) GRUEN | ce-Pipeline |
| contract:axis-version-lock in CI wieder scharf (Tripwire war 3 Wochen aus) | REGRESSION | Z2596,Z2604-2606 | BEHOBEN, in CI GRUEN bestaetigt | CI/axis-version-lock |
| test:coverage-guard in CI (neu gelandete Abdeckungs-Invariante) | AUFGABE | Z2597,Z2604-2606 | BESTAETIGT GRUEN in CI | CI/coverage-guard |
| lint:format ROT ce: 94 Verstoesse in 13 Dateien (Diff-Hygiene-Wache != clang-format-Konformitaet, 2 verschiedene Gates) | REGRESSION | Z2609-2622 | GEFUNDEN, Reviewer-eigener Reichweiten-Fehler benannt ("+26 kosmetisch" war die spaetere Ursache); Fix vorgeschlagen, wartet GO | ce/lint:format |
| lint:static ROT ce: cppcheck syntaxError bei constexpr-Lambda in static_assert (system_version_suffix.hpp:249) | REGRESSION | Z2625-2635 | FALSE POSITIVE bestaetigt (g++-15 -std=c++23 RC=0), cppcheck-Parser-Limit, kein Code-Defekt | system_version_suffix.hpp |
| GO fuer beide Fixes (13 Dateien clang-format + cppcheck-Unterdrueckung) | AUFGABE | Z2557-2558,Z2661-2662 | ERTEILT | ce/lint-Fixes |
| graph-Formatierung 8 Dateien durchgefuehrt, Job-Selektion verifiziert (59 Dateien echte Definition, nicht geraten) | AUFGABE | Z2669-2674 | ERLEDIGT, RC=0 leer nach Format | super/graph |
| Breiten-/ASCII-Wache nach graph-Formatierung: ROT (2 vorbestehende Nicht-ASCII-Zeichen, durch Format-Diff sichtbar geworden) | REGRESSION | Z2677-2685 | GEFUNDEN: ECHTER vorbestehender ASCII-Verstoss in graph (Pfeil, Ü in Kommentaren), bisher nie aufgefallen; NICHT eigenmaechtig transliteriert, Entscheidung angefragt | diagram_generator.cpp/hpp |
| Build+ctest nach graph-Formatierung (555 Tests, 402 Fehlschlaege byte-identisch) | AUFGABE | Z2687-2688 | BESTAETIGT: 0 neue Fehlschlaege, Formatierung folgenlos | super/graph-Tests |
| Entscheidung Transliterations-Weg fuer graph ASCII-Fund | OWNER-ENTSCHEID | Z2695-2697 | Weg (a) gewaehlt: transliterieren im selben Commit, dann committen/pushen | graph/ASCII-Fix |

| graph-ASCII-Transliteration durchgefuehrt (2 Zeichen), Wache GRUEN, Commit b35aea1b, gepusht | REGRESSION | Z2710-2733 | BEHOBEN, gitleaks development-only sauber, Backup-Refs unveraendert | super/graph |
| Pipeline super 15024 nach Fix | AUFGABE | Z2736 | Status RUNNING (kein Endergebnis in diesem Abschnitt) | super-Pipeline |
| K-04 PMC-Flag fehlt im einzigen realen Voll-Mess-Pfad (131.072-Zellen-Matrix misst OHNE Cache-Zaehler) | REGRESSION | Z2765 (Posten 1) | BESTAETIGT (schwerster Befund des Tages); Task #11 erstellt P0-MESSUNG | experiment_plan_director.hpp:841,877,1194,1342 |
| K-05 allow_failure:true auf demselben Voll-Mess-Batch (experiment_plan_director.hpp:1333) | REGRESSION | Z2765 (Posten 2) | BESTAETIGT, verstaerkt K-04 (3 Wachen hintereinander, keine loest aus) | experiment_plan_director.hpp:1333 |
| K-06 contract:axis-version-lock doppelt definiert, Tripwire seit Wochen aus, REAL Drift durchgelassen (Bisektion fand 2 unbemerkte Semantik-Aenderungen am Kurven-Lader) | REGRESSION | Z2765 (Posten 3) | BESTAETIGT+VERSCHAERFT; Fix existiert fertig aber UNGELANDET (597ecffe/557d8023 auf b-r4-ci-abdeckung) | .gitlab-ci.yml:343 vs :502 |
| K-07 234-V-b Shaped-Emission fertig gebaut, nie an Produktivpfad angeschlossen | REGRESSION | Z2765 (Posten 4) | BESTAETIGT (nur von 2 Testdateien aufgerufen, kein Aufrufer im Experiment-Baum) | adhoc_emitter_shaped.hpp/pilot_source_map_shaped.hpp |
| K-08 target_isa-Unterachsen (numa_node/page) geparst, KOMPLETT ohne Konsumenten | REGRESSION | Z2765 (Posten 5) | BESTAETIGT staerker als Fund-Text (0 Treffer im gesamten Baum ausser Parser selbst) | xml_config_parser.cpp:130,132 |
| K-09 doppeltes Fingerprint-Leeren (na-Zellwert + T2-C-Sonde) | REGRESSION | Z2765 (Posten 6) | Mechanismus BESTAETIGT, Wirkung abhaengig von K-01 (UNGEPRUEFT bzgl. Wirkung, da K-01 widerlegt) | profile_run_entry.hpp:1012,434-451 |
| K-10 kPlanOhneAnker Dauerzustand statt Ausnahme (=KK-8, dup. zu K-02) | REGRESSION | Z2765 (Posten 7) | BESTAETIGT Code-Existenz, Wirkung abhaengig von K-01 | planer_driven_build.hpp:297,301 |
| KK-4 bestandslog_active prueft Funktions-Existenz statt Fingerprint-Identitaet | REGRESSION | Z2765 (Posten 8) | BESTAETIGT: "laeuft still falsch, sobald naechste Stufe (K-01) geoeffnet wird" | cache_engine_builder_iterator.hpp:1658-1660 |
| KK-9 COMDARE_VARIANT_GATE Cross-Maschinen-Drift-Vergleich (Text gekappt) | UNKLAR | Z2765 (Posten 9, abgeschnitten) | Detail nicht vollstaendig sichtbar in diesem Extrakt | COMDARE_VARIANT_GATE |
| Task #11 P0-MESSUNG: PMC-Flag fehlt im Voll-Mess-Pfad | AUFGABE | Z2772-2775 | ERSTELLT, als schwerster Befund eingestuft | Messung/PMC |
| Pipeline ce 15025: SUCCESS, 19/19 gruen | AUFGABE | Z2778-2793 | Owner-Auftrag fuer ce erfuellt; ce development=e7aa1244 | ce-Pipeline |
| Format-Nachzug ce (98952e02): Job lokal reproduziert (1731 Dateien, nicht 59), 94 Verstoesse in 13 Dateien deckungsgleich mit CI-Trace | REGRESSION | Z2796-2812 | BEHOBEN, ganze Datei formatiert (korrekt fuer diesen Job-Typ, anders als Breiten-Wache) | ce/lint:format |
| lint:static ce (e7aa1244): cppcheck-Limit isoliert (Lambda+Schleife-Kombination in static_assert), 3 Minimalproben, g++ RC=0 | REGRESSION | Z2815-2833 | BEHOBEN via begrenzte Inline-Unterdrueckung mit Beleg-Kommentar (kein Code-Umbau) | system_version_suffix.hpp |
| Betriebsdoktrin: gitleaks immer MIT Repo-Config UND ueber Push-Inhalt | REFERENCE | Z2840-2844 | als Lehre festgehalten | gitleaks-Praxis |
| Frueherer gitleaks-Fehlalarm (Text mit "key") entstand weil .gitleaks.toml vergessen wurde | REGRESSION | Z2843-2844 | SELBST erkannt+korrigiert (kein echter Fund) | gitleaks-Config |
| Submodul-Bump super 9a2ef3b2 (ce-Gitlink 7969b399->e7aa1244) | AUFGABE | Z2893-2898 | COMMITTET, NICHT gepusht (bewusst, wartet super-Pipeline) | super/Submodul-Zeiger |
| overleaf-Submodul-Drift im super (29a1700d->ef448e4b), "herrenlos" | UNKLAR | Z2900-2902,Z2988-2989 | OFFEN, unberuehrt gelassen, braucht Eigentuemer | Code/external/20260931-overleaf-diplomarbeit |
| Ledger-Nachtrag nachmittag-9 (super 5534c23c, 111 Zeilen) | AUFGABE | Z2947-2949 | GESCHRIEBEN, nicht gepusht | Ledger |
| PMC-Befund VERSCHAERFT: Option-Beschreibung "Windows..." irrefuehrend, gated aber auch LINUX-Pfad (ohne Flag GAR KEINE PMC-Quelle auf Linux, Code kompiliert sich weg) | REGRESSION | Z2952-2969 | VERSCHAERFUNG bestaetigt (macht Posten schwerer, Fehlbeschreibung als Risikofaktor) | CMakeLists.txt:67-77 |
| Klaerung: pmc:amd/pmc:intel CI-Jobs zeigen nur dass PMC-Faehigkeit BAUT, nicht dass Mess-Lauf sie EINSCHALTET | REFERENCE | Z2971-2973 | Klaerung, an Regel(6) angebunden | PMC/CI |
| main-FF fuer beide Repos | AUFGABE | Z2929-2931,Z2979-2987 | UNANGETASTET, wartet auf Owner-Entscheidung (Kandidat ce: e7aa1244) | main-Branch |
| Sieben Regel-Zeilen an einem Tag (gleiches Fehlermuster, auch Autoren selbst erwischt) | REFERENCE | Z2994-2999 | Zusammenfassung/Meta-Lehre des Tages | Gate-Methodik |

| Owner-Auftrag: Explore Opus max effort ueber gesamten Wellenplan (Kontext fehlt dem Lead) | OWNER-ENTSCHEID | Z3009 | ERTEILT, 3-stufig mit Gegenpruefung aufgesetzt | Wellenplan/Kontext |
| Workflow wellenplan-vollbild-und-parallelisierung | AUFGABE | Z3011-3013 | GESTARTET | Wellenplan |
| Owner-Auftrag: Befunde der Session sammeln, an codex focus tasks delegieren (Planung/Ledger zuerst) | OWNER-ENTSCHEID | Z3014 | ERTEILT | Delegation |
| 3 Codex-Focus-Agenten (PMC-Mess-Kette, tote Faehigkeiten, Bestandslog-Kette) | AUFGABE | Z3016-3022 | GESTARTET | Analyse-Delegation |
| Overleaf-Submodul-Zeiger zeigt RUECKWAERTS 78 Commits (Working-Tree-Stand ist Vorfahr des committeten) | REGRESSION | Z3034-3057 | GEFUNDEN, KRITISCH (Thesis-Kapitel 3/5/6 gefaehrdet bei ungepatchtem Commit); Task #12 erstellt; NICHT angefasst (nur gelesen); ce-Zeiger zur Gegenprobe korrekt vorwaerts | Code/external/20260931-overleaf-diplomarbeit |
| super-Pipeline 15024 (graph-Format-Fix) | AUFGABE | Z3062 | SUCCESS, 125s | super-Pipeline |
| super gepusht (5534c23c), Backup-Ref-Check (nichts Neues) | AUFGABE | Z3065-3073 | ERLEDIGT, sauber | super-Push |
| Pipeline super 15026 nach Push | AUFGABE | Z3075-3086 | SUCCESS 13/13, verify:submodules bestaetigt Bump | super-Pipeline |
| Gesamtstand beide Repos gruen (ce e7aa1244/Pipeline 15025, super 5534c23c/Pipeline 15026), main unangetastet | AUFGABE | Z3089-3096 | Owner-Auftrag "Pipeline gruen" FUER BEIDE REPOS ERFUELLT | ce+super-Pipelines |
| Achte Regel-Zeile (Vorschlag): Submodul-Zeiger im Working Tree kann RUECKWAERTS zeigen, "M" heisst nicht "neuer" | REFERENCE | Z3110-3111 | vorgeschlagen als Lehre | Gate-Methodik |
| Task #12 Overleaf-Submodul 78 Commits RUECKWAERTS | AUFGABE | Z3119-3120 | ERSTELLT | Overleaf/Thesis |
| Owner-Freigabe main-FF: "Sprung freigegeben, commit und push bitte" | OWNER-ENTSCHEID | Z3129 | ERTEILT | main-FF |
| main-FF ausgefuehrt (ce c837d830->e7aa1244, super 030d2c62->5534c23c) | AUFGABE | Z3130-3138 | ERLEDIGT nach FF-Verifikation | ce+super/main |
| Thesis-Stand: neuerer Rettungs-Ref gefunden (Gate-8-Graph-Abbildungen, 23 Abbildungen Anhang A DE+EN), nie gelandet | REGRESSION | Z3141-3153 | GEFUNDEN (Rettungs-Ref != Landung), NACHGEZOGEN als echter FF (Commit 8970465), auf beide Remotes gepusht | Thesis/Anhang-A |
| Submodul-Zeiger super auf Thesis-HEAD 8970465 gesetzt | AUFGABE | Z3155-3161 | ERLEDIGT (Commit 85b74237) | super/Thesis-Zeiger |
| Task #12 Status final | AUFGABE | Z3161-3162 | ERLEDIGT: Thesis-Stand aktualisiert, Gate 8 gelandet, Zeiger vorgezogen | Overleaf/Thesis |
| Neunte Regel-Zeile: "Eine Rettungs-Referenz ist keine Landung" | REFERENCE | Z3228 | als Lehre festgehalten | Gate-Methodik |
| A1-NB2 Lens-Pass Verdikt: LANDEN MIT EINER AUFLAGE | AUFGABE | Z3166 | Ergebnis, 4/5 Pruefpunkte sauber | A1-NB2 |
| A1-NB2 Bump-Inkonsistenz (Verzicht auf Bump bei reallocate()-Fix widerspricht Vorwelle) | REGRESSION | Z3170-3174 | GEFUNDEN (Mittel, selbst+unabhaengig Codex bestaetigt), verstoesst gegen Kostenklammer-Doktrin; Auflage: Bump nachholen ODER begruenden | A1/ReallocatingStrategy |
| A1-NB2 Sub-Concepts Zahl-Korrektur (VIER statt drei) | REGRESSION | Z3176-3177 | kleiner Tracking-Fehler, KORRIGIERT, keine inhaltliche Konsequenz | A1-NB2 |
| A1-NB2 Tautologie-Check der 4 Sub-Concepts | AUFGABE | Z3178-3180 | KEIN Befund (alle echt zusaetzlich bestaetigt) | A1-NB2 |
| A1-NB2 Versions-Orakel+Basic-Garantie-Pin-Tests | AUFGABE | Z3182-3184 | KEIN Befund (echte, deterministische wert-pruefende Tests bestaetigt) | A1-NB2 |
| A1-NB2 24 Fundstellen reallocate-Fix | AUFGABE | Z3186-3187 | BESTAETIGT (24 von 26, Diskrepanz erklaert) | A1-NB2 |
| A1-NB2 Nebenbefund Exception-Sicherheit copy_from_ Asymmetrie | UNKLAR | Z3192 | Niedrig, kein Landeblocker, Kommentar-Nachtrag vorgemerkt | A1/Store |
| Bump-Nachholung angewiesen, dann A1 landen | AUFGABE | Z3198-3199 | ERTEILT | A1-NB2 |
| Owner-Auftrag: offene Rueckfragen/Entscheidungen sammeln, erst gegen Plan pruefen | OWNER-ENTSCHEID | Z3209 | ERTEILT | Rueckfragen |
| Workflow offene-fragen-gegen-plan (19 offene Punkte gesammelt) | AUFGABE | Z3211-3214 | GESTARTET | Offene Fragen |
| KORREKTUR eigener Fehleinordnung: "Ich erwarte laut Plan" (Owner) HAT Deckung fuer Stufe 1 (OE-B GO-Entscheid 01.08.) | REGRESSION | Z3235-3247 | SELBST widerlegt und korrigiert (falsche Suchbegriffe waren Ursache) | Lager-Basis-Tests/Stufe1 |
| NEUER BEFUND: F9/LB-Paketschnitt buchhalterisch verlorengegangen (0 Treffer LB-[0-9]/OE-B/F9-Paketschnitt im Ledger/TODO-Register) | REGRESSION | Z3256-3266 | GEFUNDEN (2. Fall der Verlustklasse aus A/B/C-Delta, INNERHALB 14-Tage-Fenster) | Ledger/LB-Kette |
| ENTWARNUNG: LB-Kette in AUSFUEHRUNG nicht verloren (LB-0/LB-1/LB-2/LB-3 gebaut, LB-6 teilweise) | REGRESSION | Z3268-3274 | TEILWEISE BEHOBEN: LB-0 fertig, LB-1 fertig (23 Tests inkl. Owner-Auflage A-1), LB-2/LB-3 fertig; LB-6 OFFEN (Baum-Form-Erweiterung+Stufe2 fehlen) | LB-0..LB-6/tests |
| Revidierte Termin-Einordnung: Stufe 1 ist VOR-TRIGGER-POSTEN (nicht optional) | AUFGABE | Z3278-3283 | EMPFEHLUNG: vor Trigger Do 07.08.; Stufe2+Factory+xlsx bleiben nach Abgabe | Lager-Basis-Tests/Stufe1 |
| Verbesserte Bau-Anweisung Stufe 2 (Vorlage gefunden: genus_buildvariant_avx2.cpp) | AUFGABE | Z3287-3298 | EMPFEHLUNG mit Vorlage; Beleg Stufe2=0 vollstaendig (mehrere 0-Treffer-Nachweise) | Lager-Basis-Tests/Stufe2 |

| Versionierungs-Interface ist AELTER als F7 (Ledger:3339, 22.07. Praezisierung-2: SHA512-Constexpr-Funktion je CEB/Tier) | REFERENCE | Z3304 | F7=Option b ist WIEDERAUFNAHME einer 2 Wochen alten Festlegung, keine Neuforderung | Versionierungs-Interface |
| Posten (A)(B)(C)(D) aus Codex-Focus "tote Faehigkeiten" | REGRESSION | Z3310 | UNVERAENDERT: (A)/(B)/(D) ENTLASTET, (C) plan-global reicht fuer Trigger | Kostenklammer-Scope |
| Owner-Auftrag: verlorene Buchfuehrung mit Codex neu als Analyse+Code-Review anfragen | OWNER-ENTSCHEID | Z3321 | ERTEILT | Buchfuehrung |
| Workflow verlorene-buchfuehrung | AUFGABE | Z3322-3324 | GESTARTET | Buchfuehrung |
| Sechs Themen-Workflows (PMC-Baupaket, Lager-Basis-Tests, P2-P8-Katalog, F3/F5/R4-Aufraeumpass, Kostenklammer-Rest, Thesis+Testoffensive) | AUFGABE | Z3326-3338 | ALLE GESTARTET (disjunkt als Analyse) | diverse Themen |
| Eigene Luecke: 4 Pushes heute OHNE Pipeline-Verifikation | REGRESSION | Z3340,Z3353 | SELBST erkannt, nachgeholt | Betriebs-Sorgfalt |
| Task #13 RESTPOSTEN aus 3 Codex-Focus-Scopes | AUFGABE | Z3351-3352 | ERSTELLT | Restposten |
| Task #1/#6 Status final aktualisiert (T2-A gelandet+gepusht; CI-Wurzel geschlossen+Tripwire reaktiviert) | AUFGABE | Z3331-3334,Z3356-3359 | ERLEDIGT/bestaetigt | T2-A/CI |
| Task #14 ENTLASTUNGEN des Tages (was NICHT gebaut werden muss) | AUFGABE | Z3335-3336,Z3360-3361 | ERSTELLT (Tracking) | Entlastungen |
| A1-NB2 Umsetzung 24-vs-26-Bump (PmrResourceAllocator+VampirNfpAllocator NICHT gebumpt, kein reallocate()) | REGRESSION | Z3364-3376 | BEGRUENDET/erledigt (4 Commits) | A1-NB2/axis_06 |
| A1-NB2 Kette bis letzten Verbraucher (31 Fundstellen v1.0.1c, TU redesignt fail-closed) | AUFGABE | Z3376 | ERLEDIGT (kritischste Auflage geloest, besser als verlangt) | A1-NB2/Tests |
| A1-NB2 Stempel/Frozen-Frage vor Bau gemessen (3 gefrorene Fixtures synthetisch, Bump bewegt sie nicht) | REGRESSION | Z3378 | BESTAETIGT: Golden faellt NICHT | A1-NB2/Frozen |
| A1-NB2 Bau-Gate: transiente Build-Graph-Race (generated_source_catalog.hpp, vorbestehend, unabhaengig von A1) | REGRESSION | Z3385 | GEFUNDEN, 3. Versuch lief sauber; LUECKE erkannt (Workflow luecke-buildgraph-race-planung gestartet) | Build-System |
| A1-NB2 ctest-Zahl 408 statt erwarteter 409/410 | REGRESSION | Z3386 | ERKLAERT (fehlende CI-Flags), ehrliche Grenze, nicht nachgestellt | A1-NB2-Tests |
| A1-NB2 EIGENSTAENDIGER FUND: 3 Dateien der URSPRUENGLICHEN A1-NB2-Serie schon vorher nicht clang-format-sauber (Vorwelle-Luecke) | REGRESSION | Z3390 | GEFUNDEN+BEHOBEN (4. Commit, sauber getrennt) | axis_06_allocator_concept.hpp u.a. |
| GO fuer A1-Landung (Push+Pipeline) | AUFGABE | Z3397-3398 | ERTEILT | A1-NB2 |
| Memory "Luecke ist Auftrag" persistiert (Ausloeser-Woerter: weiss niemand/unbelegt/vermutlich) | REFERENCE | Z3399-3401 | GESCHRIEBEN (dauerhafte Arbeitsweise-Regel, im MEMORY-Index verlinkt) | Arbeitsweise |
| A1 gebaut/committet (b20eeabc) aber NICHT gelandet (Meldungs-Missverstaendnis) | REGRESSION | Z3391,Z3415 | GEKLAERT (kein Doppel-Schreiber-Fehler, Lead fuehrt Landung nicht parallel aus) | A1-NB2 |
| Thesis-Baubarkeit verifiziert (Deutsch 202 Seiten, Englisch 192), alle 4 Pushes ausgeloeste Laeufe alle GRUEN | AUFGABE | Z3406,Z3425 | BESTAETIGT, Luecke geschlossen | Thesis-Build |
| LB-6 Stufe1 Befund: Delta identifiziert (3 Bausteine, keiner vereint Dateisystem+Zeilen-Ruecklesung) | AUFGABE | Z3432 | Bau-Anweisung erstellt (klein, kein neuer Header/CMake-Ziel) | LB-0/LB-1 Tests |
| Beweis 1 (Batch-Wiederaufnahme) und Beweis 4 (Bestandslog-E2E gegen echtes minio) | REGRESSION | Z3432 | WEITERHIN UNBELEGT (Ledger B10 offen, kein Vollzug seit 01.08.); Beweis4 ausserhalb Reichweite (Cluster-read-only) | Vor-Trigger-Checkliste B10 |
| Truncate-/Spin-Lock-Konkurrenz-Test deckt nur Teil (FakeAblage, sequenziell statt echte Nebenlaeufigkeit) | REGRESSION | Z3432 | GAP: echte Dateisystem-Konkurrenz (2 Threads) fehlt | test_lb1_knoten_heuristik_log.cpp |
| LB6-Stufe1-Bau-mit-Verifikation Workflow | AUFGABE | Z3440-3441 | GESTARTET | LB-6 |
| Wellenplan-Vollerhebung: Lage-Korrektur "super development 2 ungepusht" | REGRESSION | Z3449 | FALSCH war Lead-Annahme, KORRIGIERT: 0 ungepusht (bereits auf beiden Remotes) | super/development |
| Wellenplan-Vollerhebung: main..development Zahlen korrigiert (ce 50 statt 48, super 95 statt 93) | REGRESSION | Z3449 | KORRIGIERT | main-FF-Distanz |
| Wellenplan-Vollerhebung: overleaf-Submodul-Drift RICHTUNG re-bestaetigt (Arbeitskopie=Vorfahr=stale Checkout, KEINE ungesicherte Arbeit) | REGRESSION | Z3449 | Klaerung: Heilung ist nur `git submodule update`, kein Besitzer-Bedarf (widerspricht frueherer "braucht Besitzer"-Einordnung teilweise) | Overleaf-Submodul |
| Wellenplan-Vollerhebung: ce-Submodul-Arbeitskopie "DRECKIG" Angabe war UEBERHOLT (jetzt sauber) | REGRESSION | Z3449 | KORRIGIERT, Testplan-Blocker gegenstandslos | ce-Submodul |
| NEUER BEFUND: 4 Wellenplan-Dokumente UNVERSIONIERT im super-Baum (VERLUSTRISIKO wie .gitignore-Falle) | REGRESSION | Z3449 | GEFUNDEN: juengster Plan + 3 weitere Dokumente uncommitted, git clean wuerde sie vernichten | docs/plaene,sessions/20260806-* |
| refs/backup/pre-secret-scrub-20260802 weiterhin auf origin (776-Token-Posten) | REGRESSION | Z3449 | BESTAETIGT weiterhin OFFEN | gitlab-Backup-Ref |
| JUENGSTER PLAN (testoffensive-und-gruene-pipeline, 18:06, UNCOMMITTED): dominierender Befund super triggert ce fest auf main statt development | REGRESSION | Z3449 (§1) | KRITISCH GEFUNDEN: "gruener Lauf war ueber Code, den niemand mehr faehrt"; ci_yaml_key_guard.sh gegen ce/main EXIT=1 (Doppelschluessel weiterhin da), gegen ce/dev EXIT=0 | super/.gitlab-ci.yml:242-255 |
| Testplan-Klasse (i): T-i-1 XXE-/Entity-Bissbeweis fehlt (0 Testdateien mit DOCTYPE/ENTITY/XXE in ce tests/) | REGRESSION | Z3449 (§2) | BESTAETIGT LUECKE: "Sperre gelandet, ohne dass ein Test sie festhaelt" | ce/tests (XXE-Heilung) |
| Testplan T-i-2 Mutationsprobe contract:axis-version-lock fehlt | REGRESSION | Z3449 (§2) | GEFUNDEN: "gruener Job von inertem Job nicht zu unterscheiden ohne Mutationsprobe" | axis_version_lock |
| Testplan T-i-3 Abdeckungs-Wache an Landelinie nachmessen | AUFGABE | Z3449 (§2) | ALS ERSTER Posten des ganzen Plans eingestuft | CI-Coverage |
| Testplan Klasse(ii)/(iii): PMC-Flag-Vertrag, Fingerprint-Kreuzprobe, bestandslog_active-Bindung, u.v.a. Nach-Abgabe-Posten | AUFGABE | Z3449 (§2 Rest) | GELISTET (abhaengig von Owner-Entscheiden O-A/O-C) | diverse |

| Sechs unversionierte Wellenplan-Dokumente gesichert (4090 Zeilen) | AUFGABE | Z3456-3461 | GERETTET/committet | docs/plaene,sessions |
| super-Pipeline triggert ce fest auf main statt development | REGRESSION | Z3462-3467 | BESTAETIGT am Objekt; Task #15 erstellt STRUKTURELL | super/.gitlab-ci.yml |
| Owner-Anweisung: "commit und push auf development egal was, auf Remote sind Daten sicher" | OWNER-ENTSCHEID | Z3469 | ERTEILT (Dauerregel fuer diese Phase) | Push-Politik |
| A1-NB2 gelandet (Commit 47c4ef1d, 36 Dateien +2331/-81, beide Remotes) | AUFGABE | Z3474-3485 | GELANDET/GEPUSHT | A1-NB2 |
| Offene-Fragen A1 (allow_failure-Kollision) | AUFGABE | Z3489 | BEANTWORTET: Kollision existiert nicht (verschiedene Ebenen: Zelle vs Job) | Mess-Doktrin |
| Offene-Fragen A2 (Neubau-Fenster ccache-Invalidierung) | AUFGABE | Z3489 | BEANTWORTET: Praemisse zu gross (ccache trifft nur Treiber-Bau, nicht 1,57 Mio Tier-Binaries) | ccache/Bestandslog |
| Offene-Fragen A3 (Haerte-Grad pmc:amd/intel) | AUFGABE | Z3489 | BEANTWORTET via §66-N2+Praezisierung "Verschiffbarkeit" | pmc-Jobs |
| Offene-Fragen A4 (Anhang-Umfang bei L3/LL=0) | AUFGABE | Z3489 | TEILWEISE: Regel steht (Satz MUSS nachgezogen werden), Umfangs-Entscheid bleibt OFFEN (verengt auf L1D+dTLB) | Anhang-A/PMC |
| Offene-Fragen A5 (Alt-Jobs measure:smoke/golden-320) | AUFGABE | Z3489 | BEANTWORTET: golden-320 ist geplante Abgabe-Messung, kein Alt-Job, bleibt | CI-Jobs |
| Task #16 OWNER-ENTSCHEIDE: 8 echte Fragen (13/20 im Plan beantwortet) | AUFGABE | Z3506-3507 | ERSTELLT | Owner-Fragen |
| Owner-Auftrag: alle verpassten Nachrichten sequentiell auswerten, fehlendes selbst landen | OWNER-ENTSCHEID | Z3509 | ERTEILT | Nacharbeitung |
| Disjunktheits-Beweis Kernsatz: mehr als 1 Cache-Engine-Gate+1 uebergeordneter Slot+beliebige Analysen ist NICHT parallelisierbar | REFERENCE | Z3516 | wichtige Erkenntnis zur Parallelisierungs-Grenze | Workflow-Parallelisierung |
| Eigene Luecke: A1 gepusht, aber Kette T-1 (Bump+main-Sprung, 5 Schritte seriell) nicht vollendet | REGRESSION | Z3513-3514,Z3540 | SELBST erkannt, nachgeholt (main-FF fuer A1 nachgezogen) | A1-Landekette |
| Frage N-3 I-PMC-2/I-PMC-3 (#187): L2/L3/Kohaerenz-Events VOR Voll-Lauf nachruesten? | AUFGABE | Z3525 | OFFENE Owner-Frage | PMC-Messkette |
| F3/Weg a: Vorbedingung erfuellt (B14 gelandet), R1-Stumm-Wachen-Risiko weiterhin ungemindert | REGRESSION | Z3535 | GEFUNDEN: MUSS im selben Commit wie Rename gehaertet werden (bindende Auflage, Weg a selbst noch nicht gebaut) | fixture_schema_subset_check.cmake |
| R4 SOFORT-POSTEN | REGRESSION | Z3535 | ERLEDIGT AN DER WURZEL (contract-Ausschluss komplett entfernt, staerker als Plan verlangte) | ce/.gitlab-ci.yml |
| F5-Golden-Planung additiver Teil (S0-S5, G1-G6) | REGRESSION | Z3535 | BEREITS GEBAUT als Teil von B14-NB2 (verifiziert am Objekt: allowed_variants, run_options, combo, XSD, Interpreter) | experiment_golden_kern.xml |
| Task #7 Status (R4 erledigt, F5 additiv gebaut, F3/Weg a faellig) | AUFGABE | Z3542-3543 | AKTUALISIERT | F3/F5/R4 |
| KRITISCHER ABGABE-BEFUND: 28 Abbildungs-Eintraege in Anhang A, 0 Dateien existieren, 17 voellig stumm | REGRESSION | Z3544-3546 | GEFUNDEN, KRITISCH; Task #18 erstellt | Thesis/Anhang-A |
| Pipeline nach A1-Landung (15043) | AUFGABE | Z3547 | GRUEN, 411/411 Tests (gestiegen von 407) | ce-Pipeline |
| ZWEITE Thesis-Submodul-Einbindung: CI baut die AELTERE (Gate-8-Landung nur EINE von ZWEI Einbindungen erreicht) | REGRESSION | Z3576-3586 | KRITISCH GEFUNDEN ("Beinahe-Verlust": PDF haette 23 neue Abbildungen NICHT enthalten); SOFORT GEHEILT (2. Zeiger auch auf 8970465 gesetzt, gepusht) | thesis/diplomarbeit (2. Submodul-Pfad) |
| Build-Graph-Race URSACHE gefunden: fehlende add_dependencies-Kante (comdare_attach_generated_catalog fehlt fuer test_experiment_plan_director) | REGRESSION | Z3593 | BESTAETIGT, seit 4 Tagen im Ledger dokumentiert (02.08.), NICHT behoben; Bau-Anweisung 1-Zeilen-Fix vorgelegt | tests/unit/CMakeLists.txt (nach Z.3454) |
| Build-Graph-Race Reproduktion (kalt 100% Fehlschlag 3/3+1/1, semi-kalt/warm 0/0) | REGRESSION | Z3593 | QUANTIFIZIERT | CMake-Build-Graph |
| Build-Graph-Race "vier Tests nicht von ninja all erreichbar" | UNKLAR | Z3593 | ANDERE URSACHE, kein Race (EXCLUDE_FROM_ALL, Doku-Befund, CI gedeckt) | ninja-all-Ziele |
| Build-Graph-Race is_original-Klasse (13 comdare_paper_*_codegen) | UNKLAR | Z3593 | UNBELEGT (nicht vollstaendig einzeln geprueft), empirisch nie gebrochen | is_original-Codegen |
| Struktur-Haertung Build-Graph (eigener Include-Root, INTERFACE-Ziel) | AUFGABE | Z3593 | EMPFOHLEN als Zukunftsschutz, am Mikro-Projekt verifiziert | CMake-Struktur |

| O-4 Anhang-A-Reichweite (Owner-Entscheid) | AUFGABE | Z3609-3610 | WEITERHIN OFFEN/unentschieden | Thesis/Anhang-A |
| Anhang-A Ist-Stand: 44 Fragmente DE/EN, 16 existieren, 28 fehlen (27 Abbildungen inkl. alle 23 neuen Gate-8) | REGRESSION | Z3610 | QUANTIFIZIERT, gated ueber InputIfFileExists (bricht Kompilation nicht) | Anhang-A |
| PMC-Bezug im Thesis-Text | AUFGABE | Z3610 | ENTLASTET (kein Beleg fuer Ueberversprechung, durchgehend gehedgt) | Thesis-Kapitel |
| Restrisiko: 05_evaluation.tex suggeriert Vollstaendigkeit der PMC-Kategorien die Apparat nicht einloest | REGRESSION | Z3610 | GEFUNDEN (Praezisionsluecke, kein Fehler); sollte vor 131072er-Messung geschaerft werden | kapitel/de/05_evaluation.tex:86-92 |
| Node-Shape-Varianten im Thesis-Text | AUFGABE | Z3610 | ENTLASTET (0 Treffer, kein Abgabe-Risiko) | Thesis-Kapitel |
| Thesis baut (Pipeline 15026/15030/15034 SUCCESS) | AUFGABE | Z3610 | BESTAETIGT | Thesis-CI |
| O-A Bau-Matrix-Umfang (2.097.152 Tier-Binaries gekappt auf 131.072) | AUFGABE | Z3610 | WICHTIGSTER offener Owner-Entscheid vor Trigger | Bau-Matrix/Kapitel5 |
| Task #18 Status: Arbeit BAUT sauber | AUFGABE | Z3618-3620 | AKTUALISIERT, 2 von 3 Warnungen entlastet | Thesis/Anhang-A |
| OWNER-GROSSANTWORT (8 Fragen): Freigabe-Kriterium, Fixen+Neumessen Pflicht, PMC Pflicht in CEB, Anhang mit in Abgabe, Observer-Vertrag audit, Fingerprint-Determinismus, Rueckfall+Wiederaufnahme, PMC-Nachruestung Pflicht | OWNER-ENTSCHEID | Z3630 | ACHT BINDENDE ENTSCHEIDUNGEN erteilt (Frist 15.09.2026, woechentliche Freitags-Lieferung) | Messkette/PMC/CEB-Vertrag |
| Memory project_owner_kerne_20260806_abend_frist... persistiert | REFERENCE | Z3632-3633 | GESCHRIEBEN (im MEMORY-Index verlinkt als "OWNER-ANTWORTEN") | Owner-KERNe |
| Workflow kern-messkette-ceb-observabletier (DEEP RESEARCH 3-phasig/2-phasig) | AUFGABE | Z3634-3635 | GESTARTET | CEB/ObservableTier-Vertrag |
| Eigene Fehlannahme: Frist war 15.09. nicht 08.08., ganzer Abend gegen falsche Frist priorisiert | REGRESSION | Z3636 | SELBST erkannt und korrigiert (wichtigste Fehlannahme des Tages) | Terminplanung |
| Owner-Auftrag: offene Fragen sammeln, Explore-Buendel dann Bau-ultracode-Workflows | OWNER-ENTSCHEID | Z3637 | ERTEILT, maximale Gruendlichkeit | Owner-Antworten-Umsetzung |
| Workflow owner-antworten-vertiefung (5 thematische Deep-Research-Scopes) | AUFGABE | Z3639-3641 | GESTARTET | Owner-Antworten |
| K-08 COMDARE_VARIANT_GATE | REGRESSION | Z3666 | ENTLASTET (funktional obsolet per F7-b, bvset-Identitaet deckt ab) | build_variant_sidecar.hpp |
| K-07 234-V-b Shaped-Emission | REGRESSION | Z3666 | ENTLASTET (default-OFF = spezifizierter Zustand laut Auftrag) | adhoc_emitter_shaped.hpp |
| K-09 target_isa-Unterachsen im Kern ENTLASTET | REGRESSION | Z3666 | REVIDIERT: echte Konsumenten existieren (target_isa_sub_axes.hpp, alloc_hw_config.hpp, numa_page_probe_linux.hpp), Restluecke nur Validierungsabdeckung -- widerspricht frueherem "0 Konsumenten"-Befund teilweise | target_isa-Achsen |
| K-02/K-03/KK-4/KK-6/KK-8 Bestandslog-Scope | AUFGABE | Z3666 | bearbeitet: als vertagte, ENTSCHIEDENE Position bestaetigt (present_-Gate nach Abgabe) | Bestandslog |
| K-06 NEU [ZERSTOERT GEPLANTE FAEHIGKEIT]: COMDARE_CE_ENABLE_OBSERVER_PUSH nie erreichbar ueber .so-Grenze | REGRESSION | Z3666 | NEU GEFUNDEN (Codex-bestaetigt), architektonisch ungeloest, Termin nach Abgabe | measurable_concept.hpp:5-13,51-58,65-83 |
| KK-5 [MESSVALIDITAET] allow_failure:true am Voll-Mess-Batch deckt auch Config/Build-Fehler+fehlenden Treiber+PMC-Preflight | REGRESSION | Z3666 | VERSCHAERFT (nicht nur Mess-Zell-Fehler wie Kommentar behauptet), Termin VOR TRIGGER | experiment_plan_director.hpp:1332-1363 |
| K-10 [VERZOEGERT/NIVEAU]: COMDARE_LEGACY_MESSREIHEN zitiertes Gate existiert im Code NICHT | REGRESSION | Z3666 | NEU GEFUNDEN (falsches Sicherheitsgefuehl, Schaden strukturell nicht aktuell), Termin nach Abgabe | xml_config_parser.cpp:147 |
| KK-7 [VERZOEGERT/NIVEAU]: active_telemetry_is_silent() liefert literal false | REGRESSION | Z3666 | BESTAETIGT unveraendert, Termin Golden-Update-Fenster | profile_run_facade.cpp:240-241,505 |
| K-04 doppeltes Fingerprint-Leeren RECLASSIFIED | REGRESSION | Z3666 | "BEWUSST BEZAHLTE VOLLSTAENDIGKEIT = kein Befund" (Reklassifizierung, Detail gekappt) | profile_run_entry.hpp:1005-1012 |
| Task #11 aktualisiert (PMC+allow_failure kombiniert, Owner-Entscheid "fixen und neu messen ist Pflicht") | AUFGABE | Z3673-3676 | AKTUALISIERT | PMC/Messung |
| Owner-Auftrag: 20-seitiges Dossier/Checkheft aller Regressionen | OWNER-ENTSCHEID | Z3677 | ERTEILT | Dossier |
| Workflow dossier-regressionen-checkheft (5 Kapitel parallel) | AUFGABE | Z3679-3681 | GESTARTET | Dossier |
| Thesis-Ersatztexte-Verifikation: erster Befund (0 Treffer) war EXTRAKTIONS-ARTEFAKT | REGRESSION | Z3737-3745 | FALSE-POSITIVE, SELBST korrigiert (Ersatztexte stehen tatsaechlich im PDF) | Thesis-PDF-Verifikation |
| Memory "bis jemand anderes das macht" = Aufforderung selbst zu tun | OWNER-ENTSCHEID | Z3725-3728 | ERTEILT, Dauerregel persistiert (im MEMORY-Index verlinkt) | Arbeitsweise |
| Thesis-Git-Stand-Frage: Ist Thesis auf aktuellstem Stand? | AUFGABE | Z3746-3750 | ANTWORT: NEIN, an drei Stellen zurueck (4 Verbesserungen nur lokal, nicht gepusht) | Thesis/Git-Stand |

| Thesis 4 lokale Commits gelandet+gepusht (beide Submodul-Zeiger nachgezogen) | AUFGABE | Z3753-3763 | BEHOBEN (drei Stellen waren zurueck: 2 Remote-Zweige + 2 Submodul-Zeiger) | Thesis/Anhang-A |
| Build-Graph-Kanten-Fix (codex-t2a-final, Commit 678a4487): voller Zensus 5 TUs, 1 ohne Kante bestaetigt | REGRESSION | Z3766-3793 | BEHOBEN (1-Zeilen-Fix), Struktur-Verifikation (5/5 fail vorher, 7/7 success nachher), Bau 1823/1823, ctest gruen | tests/unit/CMakeLists.txt |
| is_original-Codegen-Muster geprueft: LUECKENFREI (0 Luecken, automatische Umbrella-Kante) | AUFGABE | Z3779 | ENTLASTET, kein drittes Codegen-Muster im Repo | is_original_codegen.cmake |
| Eigene Falle gefangen: scheinbare 413-vs-409-Testzahl-Differenz war CMakeCache-Stale-Kondition, keine Regression | REGRESSION | Z3790 | SELBST erkannt+aufgeloest (nur --fresh-Vergleich massgeblich) | Testzahl-Messmethodik |
| Nebenfund (nicht angefasst): 4 Registry-Roundtrip-Tests brauchen vorab gebaute EXCLUDE_FROM_ALL-Tools (pre-existing 2-Pass-Erfordernis) | UNKLAR | Z3796 | dokumentiert, nicht im Scope repariert | Registry-Roundtrip-Tests |
| Build-Graph-Fix gelandet (Merge f57801d3) | AUFGABE | Z3811 | GELANDET/GEPUSHT | Build-Graph |
| LB-6 Stufe1 gebaut und gelandet (Commit 3558466d/b241a272, echte Race gefunden+gemessen) | AUFGABE | Z3816-3819 | GELANDET/GEPUSHT | LB-6/Lager-Basis-Tests |
| Owner-Auftrag: eigene Arbeitsfehler-Erkenntnisse in Memory festhalten | OWNER-ENTSCHEID | Z3820 | ERTEILT | Selbstreflexion |
| Memory feedback_eigene_arbeitsfehler_lead... (16 Fehler in 5 Klassen) persistiert | REFERENCE | Z3822-3827 | GESCHRIEBEN (im MEMORY-Index als K1-K17 verlinkt) | Arbeitsweise-Lehre |
| codex-t2a-final Nachmessung: deterministischer Biss bestaetigt (2 frische Klone, 1/1 fail->1/1 success) | REGRESSION | Z3831-3837 | BESTAETIGT | Build-Graph-Fix |
| Ledger-Vorbeleg fuer Build-Graph-Race ist AELTER als gedacht (Abschnitt "2c-INFRA-LEHRE" vor 02.08.) | REGRESSION | Z3839 | Korrektur: kein neuer Bug, seit noch laenger bekannt/geloggt | Ledger/Build-Graph |
| Bezugsgroesse 411 fuer ctest geklaert (3 Zahlen aus 3 Bau-Zustaenden: 409 nullter Pass, 413 Ueberzaehlung/CMakeCache-Stale, 411 offizieller 2-Pass) | REFERENCE | Z3845-3849 | GEKLAERT, wichtige Methoden-Lehre | Testzahl-Referenz |
| Struktur-Haertung Codegen-Include-Leck bewusst NICHT in dieses Paket (eigener Explore-Umfang noetig) | AUFGABE | Z3857 | ALS FOLGEPOSTEN empfohlen; Task #20 erstellt | Codegen-Include-Leck |
| Zwei Vor-Messbeginn-Posten unangefasst: G-E3 Host-Binder (toter Code, 3 Felder leer) + E14 | REGRESSION | Z3874-3877 | GEFUNDEN, niemand hatte sie angefasst; Auftrag erteilt | Host-Binder/E14 |
| Owner-Auftrag: Arbeitsweise+Arbeitsfehler-Lehren mergen, als Doktrin ins Projekt-Git kopieren | OWNER-ENTSCHEID | Z3878 | ERTEILT | Doktrin |
| docs/ARBEITSWEISE-GESAMT-DOKTRIN.md (400 Zeilen) erstellt und gepusht | AUFGABE | Z3882-3891 | ERLEDIGT, auf beiden Remotes | Arbeitsweise-Doktrin |

| F9/LB-0..LB-6 Buchungsstand 0/0 in Ledger/Register trotz substanziellem Bau | REGRESSION | Z3901 | BESTAETIGT: Verlust-Klasse(a), Anklage widerlegt "fertig" (haengt an nie geschriebener Fingerprint-Blattidentitaet) | Ledger/F9-LB-Kette |
| A10 HW-Erkennung P4-P6 | REGRESSION | Z3901 | NICHT GEBAUT (Code markiert P5 selbst als Zukunft), Buchfuehrung seit 05.08. verloren (0/0) | hardware_probe_factory.hpp |
| A11 Klein-Sammel (ccache-Allowlist-Drop) | REGRESSION | Z3901 | NICHT VOLLZOGEN, widerspricht Code-Kommentar ("MUSS hier stehen"); braucht Owner-Entscheid ob A11 noch gilt | .gitleaks.toml:23-29 |
| A12/E-14 NAS-Creds backup1/backup2 | REGRESSION | Z3901 | 0/0 Buchung, Status (erledigt/verworfen/offen) nicht auffindbar | NAS-Creds |
| KK-1..KK-9+O-A Kalibrier-Stichprobe fehlt in jeder Liste (frischster/schwerster Buchfuehrungs-Fund) | REGRESSION | Z3901,Z3908-3911 | GEFUNDEN: Vor-Trigger-Posten "Sprung ins Dunkle" ohne sie; Task #21 erstellt | Kalibrier-Stichprobe/O-A |
| Owner-Frage: 11s Compile/Binary plausibel? | AUFGABE | Z3912 | BEANTWORTET: EXAKT bestaetigt (realer Lauf Pipeline 12690: prod1 6.8s, prod2 11.3s/Binary 1-Thread) | Compile-Zeit-Kalibrierung |
| Workflow buchfuehrung-nachtragen | AUFGABE | Z3917-3919 | GESTARTET | Ledger-Nachtrag |
| Owner-Auftrag: exzessiv praezise Kontextuebergabe vor Kompaktierung | OWNER-ENTSCHEID | Z3920 | ERTEILT, docs/sessions/20260806-KONTEXTUEBERGABE-abend-praezise.md geschrieben+gepusht | Kontextuebergabe |
| Owner-Auftrag: alle ungesicherten Workflows+Rohdaten in Backup-Ordner sichern | OWNER-ENTSCHEID | Z3929 | ERTEILT | Workflow-Rohdaten-Sicherung |
| 269 Workflow-Ergebnisse+63 Journale (25MB) gesichert | AUFGABE | Z3931-3935 | ERLEDIGT (zunaechst in docs/sessions/backups, dann ausserhalb git nach /home/comdare/backups-workflow/20260806-workflow-rohdaten/) | Workflow-Rohdaten |
| Geheimnis-Fehlalarm in Rohdaten (Beschreibung eines Suchmusters, kein echter Schluessel) | REGRESSION | Z3936-3940 | FALSE-POSITIVE geklaert | Rohdaten-Pruefung |
| gitleaks 1552 Treffer in Rohdaten gefunden, Pruefung unterbrochen | UNKLAR | Z3941-3945 | OFFEN am Ende dieses Transkript-Ausschnitts (Owner unterbrach: erst kopieren dann pruefen) | Workflow-Rohdaten/Geheimnis-Scan |
| Dossier-Regressionen-Checkheft (20 Seiten, 10 Regeln) Kapitel I | REGRESSION | Z3958-3959 | Vorbemerkung: alle Termin-Dringlichkeiten dieser Session muessen relativiert werden (15.09. statt 08.08.) | Dossier-Checkheft |
| Regel 1 "Keine Null ohne Nenner": super hat KEINE Kopie der ASCII/Breiten-Wache | REGRESSION | Z3959 | TEILWEISE: im ce geheilt (ci_diff_ascii_width_guard.sh), im super OFFEN (0 Treffer bei find) | super-Repo/ASCII-Wache |
| Regel 2 "Pruefbereich=Dateimenge+Commit-Bereich=merge-base" | REGRESSION | Z3959 | TEILWEISE: dreimal aufgetreten (T2-A, B14-ce, b14-super), CI-Verdrahtung noch offen | Gate-Pruefmethodik |
| Dossier gesichert (1590 Zeilen, 143KB) | AUFGABE | Z3968-3970 | ERLEDIGT, gepusht | Dossier-Checkheft |
| Struktur-Haertung Codegen-Include-Leck Workflow1: eigene Korrektur "build_provenance.hpp 0 Konsumenten" war FALSCH | REGRESSION | Z3975 | SELBST korrigiert (aelterer Checkout gemessen); urspruenglicher Verengungs-Plan VERWORFEN (haette 141+26 echte Konsumenten gebrochen) | build_provenance.hpp |
| Neue kleinere Empfehlung: racy Datei in generated/limits-Unterverzeichnis ziehen | AUFGABE | Z3986-3996 | SPEZIFIZIERT (Workflow1=Planung), NICHT ausgefuehrt, wartet GO | catalog_codegen.cmake:21 |
| G-E3 Host-Binder (3 mess_bestand_*-Felder, 0 Konsumenten) IST-Stand | REGRESSION | Z4004-4021 | BESTAETIGT: Kette existiert NUR im Iterator, nicht davor (anders als Genus1 bestand_key_of, das volle Kette hat) | cache_engine_builder_iterator.hpp:259-271 |
| make_messwert_key_fn() muss NEU geschrieben werden (echte neue Logik) | AUFGABE | Z4013 | Design-Luecke identifiziert, Bau-Anweisung (4 Schritte) vorgelegt | G-E3/messwert_key_source.hpp |
| E14 Nofilter-Blatt Diskrepanz (04.08. golden-320-BRUCH vs 06.08. volles GO) aufgeloest | REGRESSION | Z4033-4047 | GEMESSEN geklaert: mit End-Append+Default-OFF bricht golden-320 NICHT (K14-Index bleibt 1); 04.08.-Sorge galt nur naiver Erweiterung; Bau-Anweisung (3 Schritte) vorgelegt, KEIN neuer Owner-Entscheid noetig | axis_filter_registry.hpp/E14 |

**ENDE DER QUELLE (Zeile 4057). Vollstaendig gelesen: 4057/4057 Zeilen.**
