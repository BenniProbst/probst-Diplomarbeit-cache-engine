# Sammelstrecke — Vollaudit gruppe_07.txt (KONTEXT-FENSTER 10ff, Z15925-Z17739)

Quelle: /home/comdare/.claude/jobs/5a19728e/tmp/vollaudit/gruppe_07.txt (1739 Zeilen)
Format je Zeile: | KUERZEL/Name | Klasse | Quelle | Status LAUT QUELLE | Traeger/Task |

Gelesen: Z1-Z1739 (Datei-Zeilen 1-1739) von 1739 gesamt — VOLLSTAENDIG.

| KUERZEL/Name | Klasse | Quelle | Status | Traeger/Task |
|---|---|---|---|---|
| Eigentumslage Thesis privat BEP / ce+super+prtart = BEP Venture UG | OWNER-ENTSCHEID | Z8-Z10 (Summary 07.08.) | GESETZT | Owner |
| Gesamten Bestand invalidieren ("das erleichtert spaeter das Leben") | OWNER-ENTSCHEID | Z15 | GESETZT | Owner |
| Bis zu 8 Arbeitsstraenge parallel (disjunkte Straenge) | OWNER-ENTSCHEID | Z16, Z75 | GESETZT | Owner |
| Volles GO / sauberste Planung (Limits-Entkopplung) | OWNER-ENTSCHEID | Z17, Z77 | GESETZT | Owner |
| Keine Punkte zurueckstellen, volle Implementierung non stop | OWNER-ENTSCHEID | Z18 | GESETZT | Owner |
| Flag-Grammatik v2 (algo_semver.hpp, 8 Regeln, Pos/Neg static_assert) | FEATURE | Z30, Z38 | GEBAUT | ce |
| flag_grammar_catalog.hpp (NEU, 660 Z., 104 static_asserts, MMX-Frage gepinnt) | FEATURE | Z39 | GEBAUT | ce |
| Fingerprint-Preimage 9 Glieder, fingerprint_format=4, Overlay Pos.7 | FEATURE | Z31, Z40 | GEBAUT (Overlay-Wert heute leer) | ce |
| std::variant strukturell verboten (Bloat + Jitter) | OWNER-ENTSCHEID | Z32, Z83, Z89 | GESETZT (Begruendung verschaerft) | Owner |
| branch_misses_source_available (pmc_source.hpp NEU) | FEATURE | Z42-43 | GEBAUT | ce |
| axis_error_traits.hpp (NEU, FK-3, 20 Familien) + axis_error_traits_organ.hpp (FK-4, 18 Slots) | FEATURE | Z44 | GEBAUT | ce |
| E-A Preimage-Hash-Laenge | OWNER-ENTSCHEID | Z21, Z84 | GESETZT: SHA256 (statt SHA512) | Owner |
| E-B golden-CRC bricht (Lagerhaltung-Plan schlaegt Sidecar-Vorschlag) | OWNER-ENTSCHEID | Z21, Z83 | GESETZT: "Wir brechen golden-CRC!" | Owner |
| E-C Sidecar-Sinnhaftigkeit vs. std::variant-Verbot | OWNER-ENTSCHEID | Z83 | GESETZT: mitziehen, noch nichts gebaut = nichts verloren | Owner |
| E-E Konkatenation + 3 kanonische Achsen-Ordnungen (Mess/System/Organ) | OWNER-ENTSCHEID | Z21, Z81, Z86 | GESETZT (Freigabe erteilt) | Owner |
| Lizenz: restriktiv, Einblick+Compile+Linken, kein gewerbl. Verkauf, Doppellizenz freie Forschung (ce/super/prtart); Thesis Copyright BEP | OWNER-ENTSCHEID | Z22, Z81 | GESETZT | Owner |
| golden-320-Messdaten veraltet, duerfen geloescht werden | OWNER-ENTSCHEID | Z79 | GESETZT (Ausnahme zur Messdaten-Regel) | Owner |
| Worktrees bleiben, hier wird gearbeitet | OWNER-ENTSCHEID | Z79 | GESETZT | Owner |
| A1 MMX/3DNow Webrecherche, Kriterium gemeinsamer Registersatz->Basis/unabhaengig->Token | AUFGABE | Z89 (Frage1), Z96 | GESETZT/GEPLANT, dann A1-mmx-Bau gestartet Z216 | Owner->Agent A1 |
| A2 System-Permutationen prod1+prod2 durchrechnen, Paper-getrieben | AUFGABE | Z89 (Frage2), Z97 | LAEUFT | Agent (implizit A2) |
| A3 ETA-System-Verstaendnis (Gespraech, kein Bau) | AUFGABE | Z89 (Frage3), Z98 | BEANTWORTET (Z16020/Z16029, Code-basiert) | Owner-Frage->Assist-Antwort |
| A4 Thesis nachziehen, DE fuehrt, EN wird uebersetzt | AUFGABE | Z89 (Frage4), Z99 | Freigabe erteilt, Bau gestartet Z186 (background) | Agent A4-thesis-nachzug |
| A5 Erst-Klammerung Mess/System/Organ-Achse, Abgleich mit lager_pfad_grammatik.hpp | AUFGABE | Z89 (Frage5), Z100 | GEFUNDEN (19./20.07.), Abgleich offen | - |
| A6 NAS-Skript-Kommentar (backup1 gesund) nachziehen | AUFGABE | Z89 (Frage6), Z101 | BEHOBEN/committed 169366b9 (Z212) | ce (wt-ce-allocators) |
| backup1.comdare.de fuer Cluster prod verwenden (backup2 nur Zweitziel) | OWNER-ENTSCHEID | Z89 (Frage6) | GESETZT | Owner |
| NAS-Kapazitaet: 16TB frei (statt urspruenglich genannter 7,5TB grob aufgerundet), Rueckfall auf PR4100 fuer 8TB | OWNER-ENTSCHEID | Z85, Z89 (Frage7) | GESETZT, dann Widerspruch gefunden (siehe F1 unten) | Owner |
| A8 Infra-Ausnahme: VLAN-Tabelle lesen, Cluster-Lesen freischalten (Ausnahme zu read-only) | AUFGABE | Z89 (Frage8), Z102, Z92 | LAEUFT: Befund praevaliert Praemisse (kein Cross-VLAN-Problem, Cluster_NFS bereits rw von backup2 gemountet) | Owner->Assist selbst |
| A9 scharfer Code-Review std::variant/virtual/std::function/Laufzeitumwege | AUFGABE | Z89 (Frage9), Z103 | Agent gestartet Z128 (A9-jitter-review), Korrektur wg. veraltetem Checkout Z159 | Agent A9-jitter-review |
| Phasen-Fehlzuordnung (Dossier 17 vs. Fahrplan vs. Dossier 16) | REGRESSION | Z54 | BEHOBEN (verifiziert ueber letzten Kontext, Z73) | - |
| Fehlbefund "Limits-Entkopplung nicht verdrahtet" | REGRESSION | Z55 | BEHOBEN (Fehlbefund korrigiert, Aufruf existiert via cmake_language DEFER) | - |
| Fehlbefund "allocators vergessen" | REGRESSION | Z56 | BEHOBEN (alle 23 Akten tragen DOKU-Vermerk seit 22.07.) | - |
| git add -A docs/ neben arbeitendem Agenten -> fremder Zwischenstand gepusht (Klasse 8) | REGRESSION | Z57 | dokumentiert als Fehlerklasse, kein expliziter Fix-Status hier sichtbar | - |
| Basis-SHA im Auftragstext von Agent uebernommen statt erhoben (Klasse 9) | REGRESSION | Z58 | dokumentiert als Fehlerklasse | - |
| ASCII-Pruefung ueber ganze Datei statt Zusatzzeilen | REGRESSION | Z59 | dokumentiert (Fallen-Register) | - |
| Bissprobe mit untrackter Datei (git diff zeigt sie nicht) | REGRESSION | Z60 | dokumentiert (Fallen-Register) | - |
| git merge ohne Branch-Argument (wiederholt) | REGRESSION | Z61 | dokumentiert, "wiederholt" -> OFFEN-REGRESSION (wiederkehrend) | - |
| Overlay-Schnitt zu eng (anatomy/ 54 Dateien fehlte, Glob 28 statt 18) | REGRESSION | Z62 | BEHOBEN (Begruendung als falsch erkannt, ext=Bau-Schalter) | - |
| Rote Pipeline 15221 (ld: No space left on device, 14GB gitleaks-Klone) | REGRESSION | Z63 | dokumentiert, Fix impliziert (Klasse Pipeline-Register) | CI |
| Rote Pipeline 15239 (lint:static, cppcheck #error) | REGRESSION | Z64 | BEHOBEN (Suppression mit Begruendung) | CI |
| Fehlbefund grep -c 'static_assert(sizeof' traf Kommentar | REGRESSION | Z65 | BEHOBEN (Agent hatte recht) | - |
| E-E-Bau (bau/ee-overlay-glied) gegen gemergten Stand | FEATURE | Z104, Z188-212 | Lead-Gegenlesung bestanden (12 static_asserts, Z190/Z42), dann CTEST rot | ce (wt-ce-overlay) |
| Platte 97% voll (7,8GB frei) auf prod1 vor E-E-Bau | REGRESSION | Z195-196 | BEHOBEN (Build-Verzeichnisse geraeumt, 33GB frei, Z199-202) | prod1 |
| E-E-Bau CTEST rc=8, 4 von 424 Tests failed (Generator-Tool nicht gebaut, EXCLUDE_FROM_ALL) | REGRESSION | Z221, Z224, Z229 | BEHOBEN: 3 von 4 nach Nachbau gruen (Z241-247), 4. (test_profile_roundtrip) danach ebenfalls ok (Z247) | ce (wt-ce-overlay) |
| CTEST3 danach erneut rc=8, 4 Tests failed (test_v41_anatomy_r5i_configure_codegen, test_v41_anatomy_f15_measurem...) | REGRESSION | Z248-250 | OFFEN (Ursache wird gerade gelesen, Fortsetzung noetig) | ce (wt-ce-overlay) |
| A6 NAS-Skript Edit (copy_results_to_nas.sh) | AUFGABE | Z206-212 | BEHOBEN/committed 169366b9, ASCII sauber, 110 Spalten | ce (wt-ce-allocators) |
| F1 — 8TB passen nicht auf PR4100 (Widerspruch zu Owner-Aussage 16TB frei) | REGRESSION | Z232 | OFFEN, dem Owner zur Klaerung vorgelegt (Tabelle gekappt) | Owner-Rueckfrage |
| ETA-System = selbstkalibrierendes Lease, keine Fortschrittsanzeige (A3-Antwort) | AUFGABE | Z184, Z20 | BEANTWORTET (Code-basiert, 5-Saetze-Erklaerung) | Assist->Owner |
| E-E: 4 Executables nachgebaut (test_v41_anatomy_r5i_configure_codegen, _f15_measurement, _adhoc_autobuilt_load, comdare_adhoc_emitter_cli) | REGRESSION | Z251-254 | BEHOBEN: 428/428 gruen (Z255) | ce (wt-ce-overlay) |
| E-E gelandet (Vor-Push-Wache gruen, gitleaks no leaks found, FF) | FEATURE | Z255-264 | GELANDET: ce development=986c0a8c | ce |
| development war vor E-E bereits rot (Pipeline 15245, fea430d0) | REGRESSION | Z267-272 | Ursache identifiziert: 1 roter Job lint:static | CI ce |
| Pipeline-ID versehentlich als Job-ID geparst | REGRESSION | Z270 | BEHOBEN sofort (sauberes Parsing Z271-272) | - |
| lint:static rot: cppcheck-suppress gilt nur fuer naechste Zeile, Suppression Z48 vs. #error auf Z50 (spaeter zusaetzlich Z59) | REGRESSION | Z273-320 | BEHOBEN: beide #error-Stellen jetzt unterdrueckt, rc=0, lokal+CI reproduziert und verifiziert | ce (wt-ce-allocators/wt-ce-overlay) |
| rc=$? nach einer Pipe misst head, nicht cppcheck (Messfehler) | REGRESSION | Z303 | BEHOBEN (sauber neu gemessen Z304-305) | - |
| cppcheck-Heilung + A6 gelandet | FEATURE/AUFGABE | Z336-353 | GELANDET: ce development=a2b928eb, Volllauf rc=0 | ce (wt-ce-allocators) |
| F2 Cred-Rotation pruefen (comdare uid=1001, Passwort 40 Zeichen, prod1+prod2) | AUFGABE | Z344-352 | BEHOBEN: sudo funktioniert nach Korrektur der Regex (Z347-353) | Owner-Vorgabe/Assist |
| Vault-Datei gegrept statt blind verarbeitet (eigener Fehler) | REGRESSION | Z375-377 | BEHOBEN: Lehre als Memory reference_vault_dateien_nie_greppen dokumentiert | - |
| A8 backup1 ueber 10.0.20.241 erreichbar (nicht VIP), rw gemountet, Schreib/Lese-Probe erfolgreich | AUFGABE | Z353-390 | VOLLZOGEN/BEHOBEN (Task #44) | Assist (Cluster) |
| A8 reboot-fest: fstab gesichert, systemd-Automounts fuer backup1+backup2 aktiv | AUFGABE | Z361-413 | BEHOBEN/VOLLZOGEN | Assist (Cluster) |
| F1 NAS-Kapazitaet: 8TB passen NICHT auf PR4100 (19T gesamt, 15T belegt, 3,6T frei) | REGRESSION | Z356, Z384, Z449-450 | OFFEN: Task #43 angelegt, praezisiert auf ~11T in /mnt/HD/HD_a2/sort (Messung laeuft) | Owner-Rueckfrage |
| MEMORY.md Index-Kompaktierung (20356 -> 19384 Bytes, Limit 24400/Ziel 17100) | AUFGABE | Z398-431 | BEHOBEN/durchgefuehrt (Eigeninitiative) | Assist |
| A9-Befund 2: execute_engine_command.hpp angeblich ohne Konsumenten | REGRESSION | Z432-438 | Praezisiert: nur Kommentar-Erwaehnung in mess_achsen_naht.hpp, kein echter Include -> A9-Befund "tot" BESTAETIGT | Assist-Review |
| Phase-6-Go-Punkt (Owner-Direktive, Gedaechtnisluecke) | AUFGABE | Z441-443 | Explore-Agent gestartet, LAEUFT | Agent |
| Task #39 E-E GELANDET (ce a2b928eb, Pipeline 15250 GRUEN) | FEATURE | Z447-448, Z465-467 | GELANDET/CI-BEWIESEN | ce |
| Vor-Push-Wache: fehlendes cppcheck-Gate (Werkzeug fuer fehlend erklaert) | REGRESSION | Z455-459 | BEHOBEN: Gate eingebaut, POSIX-konform (dash statt bash-Process-Substitution) | ce (wt-ce-allocators) |
| Wachen-Gate Bissprobe: erst untauglicher Koeder (Makro nie definiert), dann echter Koeder rc=1 ROT bestaetigt | REGRESSION | Z618-635 | BEHOBEN, Wache verifiziert (schlaegt an), gelandet ce development=db6cc047 | ce (wt-ce-allocators) |
| F4 Owner-Entscheid referenziert: MMX bleibt deklariert | OWNER-ENTSCHEID | Z309 (SendMessage an A1-mmx-bau) | GESETZT (Referenz auf fruehere Owner-Entscheidung F4, hier nicht verbatim) | Owner (referenziert) |
| A2 Paper-Permutationen: 132 Binaries (33 Paper x 4 System-Perms), Faktor 3.972 gg. 524.288 | AUFGABE | Z494-536 | GELIEFERT/EMPFOHLEN, Owner-Entscheid ausstehend (~1min Bauzeit, 58MB) | Agent Analyse-Paper-Permutationen |
| U-1 Paper-Kopplung heute NICHT verdrahtet (getrennte Vokabulare, permute_axes=Listen-Praefix, drop_tier_level zieht Paper-Ebene ab) | REGRESSION | Z520 | OFFEN (schwerwiegend, "ehrliche Antwort waere heute 0" statt 132) | ce (base_tiers) |
| 5. D-2-Kandidat 917.504 (Paper-Tier-Ebene is_static, 7 base_tiers x 2^17), heute inaktiv (drop_tier_level) | FEATURE | Z522 | GEFUNDEN/OFFEN (kein bekannter Kandidat rechnet das) | ce |
| compare-Modus vergleicht heute nichts (D2 ungebaut, misst nicht einmal) | REGRESSION | Z524 | OFFEN (Owner nennt ihn als Minimum, Paket D2 ungebaut) | ce |
| prod1 L3-Domaenen-Korrektur: 8 physische Kerne je Domaene (nicht 16 wie Owner-Vorgabe) | REGRESSION | Z528 | BEHOBEN (korrigiert, live gemessen via core_id) | prod1 |
| prod2 kein AVX-512 -> 12-Perm-Doktrin strukturell unerfuellbar, nur 8 System-Perms vergleichbar | REGRESSION | Z530 | OFFEN (strukturelle Grenze, kein Fix moeglich) | prod2 |
| Harte Platz-Schranke prod1: 4,8GB frei (99% voll), 33.600 Binaries (14,3GB) passen nicht | REGRESSION | Z532 | OFFEN (ohne MinIO-Abfluss unbaubar jenseits 132) | prod1 |
| U-2 Zuordnung Paper-Achse->Kompositions-Slot nicht am Code belegt (traversal unsicher), 33.600 weicher als andere Zahlen | REGRESSION | Z541 | OFFEN (unverifiziert) | Agent-Analyse |
| U-3 Platz-Zahlen auf 0,437MB/Binary abgeleitet, keine gemessene .so-Groesse im Repo (0 Treffer so_size) | REGRESSION | Z542 | OFFEN | - |
| U-5 gerechnet gegen 23 Commits alten Branch-Stand (bau/flag-grammatik-v2-s1@44397f58) | REGRESSION | Z543 | OFFEN (Basis veraltet) | - |
| PAPER_REFERENCES.md verweist auf REPO_INVENTAR_FINAL.md — existiert nicht (auch nicht in Historie) | REGRESSION | Z545 | OFFEN | Doku |
| Prod2RaptorLakeSignature: Kommentar "i9-14900KS" veraltet, Maschine ist Alder-Lake-12900K (Flags korrekt) | REGRESSION | Z545 | OFFEN (kosmetisch) | ce |
| A4 B1 ADR-2 (2^17-Stolperstelle) DE+EN Thesis nachgezogen | AUFGABE | Z552-560 | GEBAUT, committed 99d966c (kein Push) | Agent A4-thesis-bau |
| A4 B2 Lizenz-Tabelle: 3 falsche Werte (michael_lockfree BSD-3->LGPL-2.1-or-later, tcmalloc BSD-3->Apache-2.0, lrmalloc BSD-3->MIT) | REGRESSION | Z562-567 | BEHOBEN in DE+EN (8 Fundorte) | Agent A4-thesis-bau |
| A4 B3 Flag-Grammatik v2 Thesis-Nachzug (BNF v2, e=efficiency-core, "experimentell"-Aussage entfernt) | AUFGABE | Z569-571 | GEBAUT | Agent A4-thesis-bau |
| A4 B4 branch_misses real erhoben — Thesis-Text nachgezogen (05_evaluation.tex, 06_fazit.tex, DE+EN) | AUFGABE | Z573-575 | GEBAUT | Agent A4-thesis-bau |
| Thesis-Bau DE 204 Seiten / EN 194 Seiten, latexmk exit 0, 0 Warnings | FEATURE | Z577-580 | GEBAUT/verifiziert (kein Push) | thesis |
| chktex-Fund: fehlende Tilde vor \ref (durch A4-Bearbeitung selbst entstanden) | REGRESSION | Z581 | BEHOBEN (Zeilenumbruch verschoben, 0 Funde danach) | Agent A4-thesis-bau |
| A4 B3-Erweiterung ueber Auftrag hinaus (Namens-/Suffix-Ebene->Namens-Ebene) | AUFGABE | Z589 | OFFEN: Agent bittet um Owner-Gegenlesung | Owner-Review noetig |
| A4 B4 Zusatzkorrektur "drei"->"vier generische Zaehler" (nicht explizit beauftragt) | AUFGABE | Z590 | OFFEN: Agent bittet um Owner-Gegenlesung | Owner-Review noetig |
| A1 m64-Basis gebaut (flag_grammar_catalog.hpp: MedienBasis/MedienSubset ersetzt BasislosFamilie, m64-Block) | FEATURE | Z598-619 | GEBAUT, committed 941c4050 (nicht gepusht/gemergt) | Agent A1-mmx-bau |
| A1 algo_semver.hpp Formbeispiele auf m64{...}, kVollausbau Knotenzahl 58->59 | FEATURE | Z614-619 | GEBAUT | Agent A1-mmx-bau |
| A1 4 Bissbeweise (m64{mmx} gruen inkl. Roundtrip, x128{mmx} rot, alte x64-Form rot, Entscheide-Zaehler==0) | FEATURE | Z625-658 | BEHOBEN/lokal bewiesen (g++ 15.3.0, nicht CI) | Agent A1-mmx-bau |
| A1 N-1 Entscheid mmxext-Schalter gpp="-msse" (nicht "") | AUFGABE | Z660-676, Z721 | ENTSCHIEDEN durch Agent (keine Owner-Weisung, "vertretbar waere auch leer") | Agent A1-mmx-bau |
| A1 N-2 Owner-Frage: soll mmx (x86-64-Grundlinie, in jedem Preimage) notationell unterdrueckt werden? | AUFGABE | Z728-733 | OFFEN: Owner-Rueckfrage, im Katalog-Kommentar offen gehalten | Owner-Rueckfrage |
| A1 N-3 3dnowprefetch: entscheid_offen entfernt (APM-Beleg) | REGRESSION | Z608, Z690-693 | BEHOBEN (Entscheide-Zaehler 6->0 gesamt) | Agent A1-mmx-bau |
| A1 Testzahl 424/424 vs. Referenz 428/428 aus Auftrag — Differenz NICHT erklaert | REGRESSION | Z696-701 | OFFEN (nicht nachgeprueft, evtl. andere Build-Optionen/Basis) | Agent A1-mmx-bau |
| A1: 2 projekteigene 2-Pass-Bauluecken (Registry-Generatoren, test_profile_roundtrip, EXCLUDE_FROM_ALL) | REGRESSION | Z703-707 | BEHOBEN lokal; ob ECHTE CI betroffen ist, NICHT geprueft | Agent A1-mmx-bau |
| A1: zweite, aeltere SIMD-Katalog-Quelle widerspricht ("AMD APM ueberhaupt nicht gelesen") | REGRESSION | Z712-718 | BEHOBEN/geklaert: Agent stuetzt sich auf spaetere, primaerquellenbelegte Recherche | Agent A1-mmx-bau |
| Phase-6 Go-Punkt Kartierung: mind. 4 disjunkte "Phase N"-Zaehlkreise (Reihe A Fahrplan / B Dossier17 / C Dossier16 / D Randfunde) + S-Schema | REGRESSION | Z751-761 | GEKLAERT: Reihe A (Fahrplan 03.08.) ist massgeblich | Agent Phase6-recherche |
| Reihe B (Dossier 17 Teil D E4-XML-Vollvision) als STALE bestaetigt (ABI-MAJOR TABU=4 vs Ist=8, Andockpunkt main.cpp:513-521 existiert nicht mehr) | REGRESSION | Z755 | BEHOBEN/GEKLAERT (Ledger abend-2 Befund 5) | Doku |
| Phase 6 (Reihe A) Definition: E.0 KERN-Mess-Schema -> 320er-GO -> Voll-Messung-GO -> Rueckschrieb -> Auswertung -> Hybrid -> COMPARE/D2 -> Thesis C5 | FEATURE | Z766-767 | GEPLANT (Primaerquelle, hoher Sicherheitsgrad) | Fahrplan |
| Go-Punkt fuer Messung = Owner persoenlich, keine Delegation gefunden (4-fach Ledger-Beleg) | OWNER-ENTSCHEID | Z774-780, Z802 | GESETZT/bestaetigt | Owner |
| Phase 5 (Trigger-Sequenz) im Fahrplan als "AUTONOM" markiert — Agent darf selbst durchlaufen | AUFGABE | Z780, Z809 | GEPLANT/Erlaubnis erteilt | Fahrplan |
| Reihe-A-Stand: Phase1 Lager erledigt (f40dfb4b, W10 51c012c5), Phase2 Stempel/ABI Major 7->8 + A2-Eichung 86be2420 erledigt | FEATURE | Z789-790 | GELANDET | ce |
| Phase 3: 12 Pakete gelandet (Flag-Grammatik-v2 5060489e, allocators-Gate 5adf59ea, M-3a branch_misses 6a8ab995, S2-Katalogwache 5788dc12, A9-S1 xlsx-Vendor 351205f5, A5/ETA 73f9a56f, FK-3/FK-4 f2709599, cppcheck-Heilung fea430d0, 175 stale Doku-Anker, Paragraph55-Reconcile, STOPP-Gates-Vorlage) | FEATURE | Z791 | GELANDET | ce/super |
| 6 STOPP-Gate-Entscheide E-A..E-F ALLE entschieden (E-E zum Doku-Zeitpunkt noch im Bau) | OWNER-ENTSCHEID | Z791 | GESETZT (E-E danach ebenfalls gelandet, s.o.) | Owner |
| Phase 4 "Limits-Entkopplung" (Dossier-17-Lesart) widerrufen/bestaetigt vollzogen, haerter gebaut als geplant | FEATURE | Z792 | GELANDET/BEHOBEN | ce |
| Phase 5 (Trigger-Sequenz) faktisch NICHT begonnen ("Null Binaries gemessen") | AUFGABE | Z795 | OFFEN/GEPLANT (naechster Schritt) | - |
| Vollstaendigkeit A3 "Beweise 1-5" / A4 "12-Perm" (Fahrplan-Phase-4) unklar belegt | REGRESSION | Z796, Z814 | OFFEN (Luecke in eigener Kartierung, explizit benannt) | Agent Phase6-recherche |
| Q2 Bau-Menge D-2 (mehrere Kandidaten inkl. neuem 917.504, Faktor 16) faellig vor Voll-Messung | AUFGABE | Z798 | OFFEN | Owner-Entscheid noetig |
| Phase 6 = STOPP fuer Assist (kein reines Ziel), vierfach Ledger-belegt; heutige Owner-Formulierung passt strukturell | OWNER-ENTSCHEID | Z800-802 | GESETZT/bestaetigt (Sicherheitsgrad hoch) | Owner |
| Platz-Diskrepanz 4,8GB vs. vorher gemessene 33GB aufgeklaert (Agent maass vor Raeumung) | REGRESSION | Z823-826 | BEHOBEN/geklaert (32GB/87% aktuell) | prod1 |
| A1 N-2-Korrektur (RISC-V-Punkt) am Code nachgezogen | FEATURE | Z833-835 | GEBAUT, committed 3a9f9c70 | ce (wt-ce-s2) |
| A1 Bau: v41-Targets in falscher Reihenfolge gebaut (existieren erst nach Re-Configure) | REGRESSION | Z836-841 | BEHOBEN: richtige Reihenfolge, 428/428 gruen; Differenz zu vorherigen 424 damit erklaert | ce (wt-ce-s2) |
| Vor-Push-Wache faengt eigenen Fehler: rm -rf build loeschte getrackte Mess-CSV | REGRESSION | Z697, Z846-848 | BEHOBEN (git checkout -- wiederhergestellt) | ce (wt-ce-s2) |
| Vor-Push-Wache rot: 2/3 Dateien Format-Abweichungen (A1-Agent hatte clang-format nicht geprueft) | REGRESSION | Z849-855 | BEHOBEN (formatiert, Tests danach 100% pass, Wache gruen) | ce (wt-ce-s2) |
| A1 (MMX/m64) gelandet | FEATURE | Z856, Z720 | GELANDET: ce development=15522cdc | ce |
| A4-Erweiterung 1 (Namens-/Suffix-Ebene->Namens-Ebene) gegengelesen | AUFGABE | Z857-859 | BESTAETIGT durch Lead-Gegenlesung als richtig+noetig | Assist-Review |
| A4-Erweiterung 2 ("drei"->"vier generische Zaehler") verifiziert am Code (real geoeffnete PMC-Counter) | AUFGABE | Z860-865 | BESTAETIGT/belegt ("TATSAECHLICH GEOEFFNET werden VIER") | Assist-Review |
| Thesis gelandet (Merge, Bau DE+EN, gitleaks) | FEATURE | Z866-881 | GELANDET: thesis 798e946, DE 204/EN 194 Seiten | thesis |
| BibTeX-"Warnung" war Fehlalarm des eigenen greps (Statistikzeile) | REGRESSION | Z875-878 | BEHOBEN/Fehlalarm erkannt (tatsaechlich 0 Warnungen) | - |
| super Gitlinks (ce, thesis) haengen 37 Commits zurueck | REGRESSION | Z886-899 | BEHOBEN: beide gebumpt mit Vorwaerts-Beweis (super 6d8dd432) | super |
| Fehlbefund "a1d0c201 ist alter Juni-Stand" (git describe zeigte altes Tag) | REGRESSION | Z889-895 | BEHOBEN: sofort korrigiert, Commit ist von heute 11:53 | - |
| Alle vier Refs (ce/super/thesis/cluster) gleichauf, alle Pipelines gruen | FEATURE | Z899-912 | CI-BEWIESEN (ce 15256, super 15258, thesis 15257) | Gesamt |
| F1 NAS-Kapazitaet Zwischenstand: 10,1T verfuegbar (3,6+6,5) | REGRESSION | Z910 | TEILBEHOBEN (Task #43 update, Text gekappt) | - |
| Owner: NAS Volume_2 bereitgestellt (nfs://backup1.comdare.de/nfs/Comdare-Buildsystem, 14TB frei, NUR Buildsystem) | OWNER-ENTSCHEID | Z913 | GESETZT (loest F1) | Owner |
| Owner Frage 2: mehr Kontext noetig — welches Allocator-Profil in welchem Bau? | AUFGABE | Z913 | GESTELLT, Agent F2-profil-kontext gestartet (Antwort s.u.) | Owner->Agent |
| Owner Frage 3/PFLICHT: XML-getriebene LaTeX-Kapitel-Generierung (Zielordner, Messwerte/Tabellen aus XML, automat. CI-Einbindung, schaltende Textbausteine) | OWNER-ENTSCHEID | Z913 | GESETZT (PFLICHT), Workflow-Entwurf gestartet (latex-anlage-xml-getrieben) | Owner |
| F1 endgueltig geloest: Comdare-Buildsystem-Volume gemountet, 20T gesamt/15T frei (28%) | REGRESSION | Z919-929 | BEHOBEN (Task #43 completed), reboot-fest, Bissprobe bestanden | Cluster |
| Nebenbefund: Buildsystem-Export steht auf `*` statt `10.0.20.0/24` (auch V60 erreichbar) | REGRESSION | Z930 | Gemeldet, Text gekappt — Fortsetzung naechster Block | Cluster |
| F2-profil-kontext T1: Bau-Arten (CI-Stages) kartiert, CebMode/debug_parallel NICHT verifiziert (Suche leer) | AUFGABE | Z932-946 | BEANTWORTET/mit Einschraenkung (als nicht relevant gewertet, aber ungeprueft) | Agent F2-profil-kontext |
| F2 T2: zwei unabhaengige Schalter-Familien (axis_06 vs. adapters/) fuer denselben Allocator-Vendor, Namenskollision bei 6 Vendoren (mimalloc/jemalloc/tcmalloc/snmalloc/scalloc/hoard) | REGRESSION | Z948-955, Z979-983 | OFFEN (Architektur-Unsauberkeit, HAVE-Variable geteilt) | ce |
| F2 T3: A03/Michael-Lockfree NIRGENDS aktivierbar (2 unabhaengige Blocker: fehlender Detection-Block + falscher Include-Name; adapters-Pfad kompiliert michael.c nicht) | REGRESSION | Z959-970, Z978 | OFFEN (Achse strukturell tot); WICHTIG: LGPL-Code wird NICHT ins Abgabe-Artefakt gelinkt (verifiziert, kein Lizenzrisiko) | ce |
| F2 T4: Allocator-Statustabelle (23 Profile) — nur pmr_resource/pool_resource/std_malloc "ueberall aktiv"; mimalloc/jemalloc/tcmalloc/snmalloc/scalloc nur env-abhaengig aktiv; michael/rpmalloc/lrmalloc/dlmalloc strukturell tot (HAVE nie gesetzt); 13 Profile "nicht vendoriert" | REGRESSION | Z972-1000 | OFFEN (grosse strukturelle Luecke in der Allocator-Achse, betrifft Thesis-Vergleichbarkeit) | ce |
| F2 T2 Namenskollision (axis_06 CACHE FORCE ueberschreibt adapters-Option) — PRAEZISIERT: kein Bug, sondern Absicht (CMakeLists.txt:641-654 erklaert zwingende Compile-Belange snmalloc/mimalloc: -mcx16, SNMALLOC_HEADER_ONLY_LIBRARY) | REGRESSION | Z1041-1056 | KORRIGIERT/entkraeftet (Assist-Selbstkorrektur, Reihenfolge-Angabe des Agenten war zudem falsch: ext:615 vor adapters:679) | ce (wt-ce-s2) |
| T5 golden-Bau: golden_fullpilot_320_binary_ids.txt real committet (320 Zeilen), allocator NUR std_malloc, Michael nirgends darin | AUFGABE | Z1006 | BEANTWORTET | ce |
| 2^17=131072 ist KEIN materialisierter Bau, nur LAZY-deklarative Referenz (kommt NICHT ins git, 62MB Repo-Bloat vermieden) | FEATURE | Z1007 | dokumentiert/bestaetigt (bewusste Auslegung) | ce |
| Owner Frage 2 final beantwortet: A03/Michael in KEINEM Bau aktiv, LGPL-Code wird nicht gelinkt (3 unabhaengige Blocker, selbst gegengeprueft) | AUFGABE | Z1013-1019, Z1032-1034, Z1917 | BEANTWORTET/ENTLASTUNG (Task #42: "LIZENZ A03/LGPL entschaerft, dreifach blockiert") | Assist->Owner |
| Owner Z1057 Frage1-Korrektur: LaTeX-Anlage = Auswertung (Break-Even, beste Version je Eingangslast), NICHT Rohdaten; mehrere Experimente->mehrere Anhaenge; nur Handvoll/Top-5 Ergebnisse in Anhaengen | OWNER-ENTSCHEID | Z1057 | GESETZT (Korrektur des Assist-Verstaendnisses) | Owner |
| Owner Z1057: Messwerte+Binaries jetzt in 2 getrennten Baeumen/Wurzeln im neuen Buildsystem-Ordner | OWNER-ENTSCHEID | Z1057 | GESETZT (Faktum) | Owner |
| Owner Z1057: 5 querschneidende Mess-Ebenen (Micro/Macro/Wallclock x Achsen-Algorithmen/Gattung-Genus-Interfaces/Gesamtlast) | OWNER-ENTSCHEID/FEATURE | Z1057 | GESETZT, Explore noetig fuer Details | Owner |
| Owner Z1057 Frage3: Compare-Stufe (D2) noch nicht gebaut, braucht ultracode Break-Even-Planung ueber 6 Wochen (irgendwo definiert) | REGRESSION | Z1057, Z1064-1065 | OFFEN: Task #46 angelegt | Owner-Auftrag |
| Owner Z1057 Frage4: korrekt+gewollt — AVX-System-Achsen-Konfig + Lager-Batches + ETA-Sync prod1/prod2 aus letzten 3 Wochen suchen | AUFGABE | Z1057, Z1066-1067 | OFFEN: Task #47 angelegt | Owner-Auftrag |
| Owner Z1057 Frage5: Messung ist PFLICHT, muss durchgesetzt werden | OWNER-ENTSCHEID | Z1057 | GESETZT | Owner |
| Owner Z1057 Frage6: Befund an Infra-Agenten per Handout melden | AUFGABE | Z1057, Z1076-1077 | BEHOBEN: Handout raus (super 30458580) | Assist |
| Board/TODOs wiederherstellen (Tasks #45-#51) | AUFGABE | Z1061-1077 | BEHOBEN: 7 Tasks angelegt | Assist |
| Task #45 LATEX-ANLAGE neu verstanden (Auswertung statt Rohdaten, Break-Even) | AUFGABE | Z1062-1063 | OFFEN (angelegt) | - |
| Task #46 COMPARE-STUFE (D2) UNGEBAUT — braucht Break-Even-Definition der letzten 6 Wochen | REGRESSION | Z1064-1065 | OFFEN | - |
| Task #47 AVX-System-Achsen-Konfig + Lager-Batches + ETA-Sync prod1/prod2 | AUFGABE | Z1066-1067 | OFFEN | - |
| Task #48 L3-ASYMMETRIE-MESSUNG IST PFLICHT (8 Kerne/Domaene, 96MB vs 32MB, heute nicht konfiguriert) | AUFGABE | Z1068-1069 | OFFEN | - |
| Task #49 PAPER-KOPPLUNG NICHT VERDRAHTET — ehrliche Zahl heute 0, nicht 132 | REGRESSION | Z1070-1071 | OFFEN (formalisiert U-1) | - |
| Task #50 ZWEI BAEUME IM BUILDSYSTEM (Messwerte/Binaries getrennt) — Struktur suchen und bauen | AUFGABE | Z1072-1073 | OFFEN | - |
| Task #51 PHASE 5 ist naechste AUTONOME Strecke, Phase 6 (Messung) bleibt USER-GO-STOPP | AUFGABE | Z1074-1075 | Orientierungs-Task angelegt | - |
| Owner Frage 2 (build_axis_levels vs. build_profile_basis_levels, welcher Baum-Pfad fuer Voll-Bau) mit Kontext beantwortet | AUFGABE | Z1079-1084 | BEANTWORTET | Assist->Owner |
| Owner Z1085: alle uebrigen Rueckfragen stellen, memory lesen, Fable5-xhigh-Durchsuchung letzte 6 Kontexte, Gesamt-Dossier konsolidieren, Stand Phasensystem A/B/C erfragt | OWNER-ENTSCHEID | Z1085 | GESETZT (Arbeitsanweisung) | Owner |
| Workflow gesamt-dossier-sechs-kontexte (Fable5 xhigh) gestartet | AUFGABE | Z1090-1092 | LAEUFT | Workflow |
| Phasensystem A/B/C/D als DRITTES System entdeckt (neben Fahrplan Phase1-7 und Wellenplan A-F); "Phase B" 16x, "Phase A" 4x im Ledger; "Phase B GELANDET" (:4061), A8-S5 inkl. Phase B (ce 24e07219, Gate 403) | REGRESSION | Z1093-1096 | OFFEN (Luecke: Vollstaendigkeit A/C/D ungeklaert) | Ledger |
| Owner Z1097: Rueckfragen erst stellen wenn Workflows zurueck sind, dann anhalten | OWNER-ENTSCHEID | Z1097 | GESETZT (Ablaufsteuerung) | Owner |
| Workflow latex-anlage-xml-getrieben Ergebnis: 3 Entwuerfe (minimal/ct-rein/thesis-erst), ALLE 0/3 Stimmen — minimal faellt durch mit 5 bestaetigten Defekten | REGRESSION | Z1104-1105, Z1112 | OFFEN (Entwurfsstufe, vor Owner-Entscheid O-4) | Workflow (20 Agenten) |
| Defekt 1: CI wuerde falsche XML-Familie durchreichen (COMDARE_THESIS_PROFILE=m3_smoke_coverage statt comdare_experiment-Wurzel) | REGRESSION | Z1105 | OFFEN (im gepruefter Entwurf, noch nicht gebaut) | ce/CI |
| Defekt 2: measure:golden-320 wuerde abbrechen (Variable nur in measure:smoke gesetzt, unbound unter set -euo pipefail) | REGRESSION | Z1105 | OFFEN | ce/CI |
| Defekt 3: Kapitel-Anlage wird kopiert aber NIE committet (anhang_forward_core.sh stagt nur tabellen/-Pfad) | REGRESSION | Z1105 | OFFEN (stiller Ausfall) | ce/CI |
| Defekt 4: "Filter" erzeugt stille Staleness (17 blanke \input-Fragmente, Kanal loescht nie, PDF zeigt alte Zahlen ohne Warnung) | REGRESSION | Z1105 | OFFEN | thesis |
| KORREKTUR zu Defekt 2 (measure:golden-320 Abbruch-Behauptung) | REGRESSION | Z1125-1128 | FEHLALARM: Job liest COMDARE_THESIS_PROFILE gar nicht, kein Blocker | Assist-Gegenpruefung |
| Gesamt-Dossier (Fable5 xhigh, 6 Kontexte): 360 Owner-Nachrichten, 79 Frage-Antwort-Paare konsolidiert | AUFGABE | Z1134-1140 | GELIEFERT, committed super (versch. Commits bis e72025b5) | Workflow (6 Agenten) |
| Memory-Regel falsch: "queued_command.prompt existiert seit 06.08. NICHT MEHR" — tatsaechlich 252x nach 06.08. belegt, ~40 Owner-Nachrichten dadurch uebersehen | REGRESSION | Z1142-1150 | BEHOBEN: MEMORY.md korrigiert + neue reference_transkript_extraktor_zwei_pfade angelegt | Assist |
| Dossier-Fund: Break-Even bereits VOLLSTAENDIG definiert (Owner 06.08. 23:20, Micro/Macro/Macro-large-scope) — vom Lead zweimal uebersehen | REGRESSION | Z1136, Z1150-1153 | GEKLAERT (Wissensluecke behoben durch Dossier) | Assist-Selbsterkenntnis |
| Dossier-Fund: 14 Faelle, in denen Lead fragte obwohl beantwortet (4 davon mit sachlich falscher Empfehlung) | REGRESSION | Z1145, Z1156, Z1165 | dokumentiert/gebucht (Lehre, super gesichert) | Assist (Muster) |
| Dossier-Fund D-2 Bau-Menge: 4 konkurrierende Zahlen vorgelegt 07.08 07:27, Owner beantwortete D-1/B-4/D-3/O-C, D-2 blieb unbeantwortet; 5. Kandidat 08.08 dazu; Task #21 offen | REGRESSION | Z1135 | OFFEN (spaeter praezisiert, s.u. --check-size) | Owner-Entscheid noetig |
| Dossier-Fund: "mehrelementige Front" — Owner fragte 07.08 12:19 zurueck, Lead nie darauf zurueckgekommen | REGRESSION | Z1135 | OFFEN bis Dossier, dann vom Assist selbst beantwortet (Z1187) | Assist |
| Dossier-Fund: Welle D (Cluster) — k-Wahl-Konsens, Linkage-Kriterium, Noise-Schwellwert ohne Setzung | AUFGABE | Z1135 | OFFEN | Owner-Entscheid noetig |
| Dossier-Fund: Bruecke CSV-Spalte->Katalog-Zielgroessen-ID existiert nirgends (Agent hat sie nicht erfunden) | REGRESSION | Z1135 | OFFEN (Owner antwortete nur zum Whitelisting-Prinzip) | ce |
| "doppelt_gestellt": compare-Modus dreifach erklaert — release+compare beinhalten measure als Basis, compare formal vor release | OWNER-ENTSCHEID | Z1135 | GESETZT (mehrfach wiederholt: 07.08 07:47, 09:10, 08.08 07:03) | Owner |
| "doppelt_gestellt": xlsx ist Standard-Mess-Format (dreifach angesagt: 06.08 05:49/11:15, 07.08 07:02) | OWNER-ENTSCHEID | Z1135 | GESETZT | Owner |
| "doppelt_gestellt": Planer UND CEB tragen je EIGENES Stempel-System (OE-C 01.08, praezisiert 06.08/07.08) | OWNER-ENTSCHEID | Z1135 | GESETZT | Owner |
| "doppelt_gestellt": ZWEIPHASIG/DREIPHASIG fuer alle 3 Achsen-Kategorien (Owner verlangte Explore zweimal, 06.08/07.08) | AUFGABE | Z1135 | GESETZT/Explore verlangt | Owner |
| "doppelt_gestellt": PMC-Architektur Hybrid — EINE CEB startet dieselbe Binary zweimal gepinnt (nicht zwei CEB-Kompilate), Lead-Irrtum zweimal | OWNER-ENTSCHEID | Z1135 | GESETZT (Korrektur, zweimal noetig) | Owner |
| "doppelt_gestellt": Bestandslog ist verteiltes System, viel weiter geplant als "eine Datei", NIE YAML gesagt — zweimal als "irrsinnig" zurueckgewiesen | OWNER-ENTSCHEID | Z1135 | GESETZT (OE-E 01.08, E-B 07.08) | Owner |
| "doppelt_gestellt": Fehlerklassen/stilles Durchwinken — stiller Ruckfall geht nicht, error anzeigen (viermal nachgeschaerft 06.08.) | OWNER-ENTSCHEID | Z1135 | GESETZT | Owner |
| Phase-2-Audit (Fahrplan-Reihe A): 5/12 Posten ✅ voll belegt (W10-Zellwerte, E-24 ABI 7->8, A8-Kopplung S1/S3/S4/S5, E-24-Fensterbauplan, M0-organ_concept), 1 planmaessig nach Abgabe (Graph-Gattung Q5) | FEATURE | Z1172 (2.1-2.6) | GELANDET/GEPLANT je Posten | ce |
| Phase-2.7 A2-SHA512-Skip-Gate Bau ✅ (426aeaef+deee6406, Pipeline 14659) | FEATURE | Z1172 | GELANDET | ce |
| Phase-2.8 A2-Eichung "EINMALIG ZULETZT" formal gebrochen: kFrozenFingerprintV1 seit Anker 5x gedreht | REGRESSION | Z1172 | OFFEN (mit Entlastung an anderer Stelle vermerkt) | ce |
| Phase-2.9 TP1-FINAL-Inventur ueberholt, Nullbefund ueber 6 Suchmuster | REGRESSION | Z1172 | OFFEN (Wiederholung zugesagt, nicht eingeloest) | ce |
| Phase-2.10 L14 leeres Overlay-Glied->Heilung am Objekt gebaut (E-E, c7158b2b), aber Ledger-Vollzugsvermerk fehlt | REGRESSION | Z1172 | OFFEN (reine Buchfuehrungs-Luecke) | ce/Ledger |
| Phase-2.11 Doku-Drift am Skip-Gate: build_orchestrator.hpp behauptet 4 falsche Dinge (leeres Overlay, Heilung Phase6, format=3, ACHT Glieder — real: format=4, NEUN Glieder) | REGRESSION | Z1172 | OFFEN | ce |
| Phase-2.12 SF-1 Fenster VOR Abgabe (Owner 06.08., supersediert aeltere "nach Abgabe"-Zeile) | OWNER-ENTSCHEID | Z1172 | GESETZT, Bau steht aus (s.u. SF-1-Analyse) | Owner |
| Verdikt Phase 2: Bau-Posten fertig, Ordnungs-Zusage (Ledger-Vollzug) nicht — Gate offen | REGRESSION | Z1172 | OFFEN | ce/Ledger |
| Phase-3-Audit (16 Posten, Fahrplan Z.20-23): 6 ✅ voll (A8-S1/S3/S4/S5, A9-S1 xlsx-Vendor, A15 FK-3/4), 2 teilweise, 8 offen/nie begonnen | REGRESSION | Z1172 | Verdikt: Phase 3 NICHT fertig (Ledger selbst B9: "Ausfalten nachzuholen") | ce |
| Phase-3.5 A8-S2 (Ebenen-Etikettierung E2/E3) BESITZERLOS: 0 Ledger-Treffer trotz "trigger-blockierend"-Einstufung, unaufgeloester Widerspruch ob je vergeben | REGRESSION | Z1172 | OFFEN (kritisch) | ce |
| Phase-3.9 A9-S3/S4/S5 (Writer-Kern/CLI/Erstbeleg) NIE GEBAUT: xlsx-Weg ist reiner Vendor OHNE einzigen Schreiber (0 Treffer) | REGRESSION | Z1172 | OFFEN (kritisch) | ce |
| Phase-3.8 A9-S2 Grammatik halb: lager_pfad_grammatik.hpp existiert, stammt aber aus A1-LB-Welle nicht A9; ergebnis_dateiname.hpp existiert nicht | REGRESSION | Z1172 | OFFEN | ce |
| Phase-3.11 Z-06 am Objekt WIDERLEGT: slice_marker.hpp traegt weiter alte marker_fenster(begin,count)-Form | REGRESSION | Z1172 | OFFEN | ce |
| Phase-3.12/3.13 Mess-Marker-v2 ("mess"-Kopf) und OS-U4/Z-04 (Provenienz-Anschluss): beide NICHT gebaut (0 Treffer, nur Kommentare) | REGRESSION | Z1172 | OFFEN | ce |
| Phase-4.1 A3/Beweise 1-5: kein einziger Beweis auf geeichtem Stand erbracht, [PRUNE-TESTAT]=0 Treffer | REGRESSION | Z1172 | OFFEN | ce |
| Owner Z1188 Frage1: Paper-Research-Auftrag praezisiert — "ein Paper = ein Experiment-XML", keine Kandidaten-Schaetzung mehr; Planer-CLI-Flag `cache_engine --check-size FILE` (Groesse/Dauer wird auf Ziel-CEB berechnet, HW-Erkennung, CEB wird ggf. vorsorglich gebaut) | OWNER-ENTSCHEID | Z1188 | GESETZT (NIE mehr pauschal schaetzen) | Owner |
| Task #21 aktualisiert: --check-size BAUEN statt schaetzen | AUFGABE | Z1195-1196 | OFFEN | - |
| Task #49 aktualisiert: PAPER-RESEARCH — Auftrag "ein Paper=ein Experiment-XML" stand bereits seit 3 Monaten | AUFGABE | Z1197-1198 | Praezisiert, weiter in Bearbeitung | - |
| Owner Z1188 Frage3: 3 Mess-Stufen (Micro/Macro/kombiniert) x 3! Permutationen = 6 CEB-Varianten zur Messfehler-Herausrechnung per Differenzbildung (Korrektur: 6 nicht 5) | OWNER-ENTSCHEID | Z1188 | GESETZT | Owner |
| Owner Z1188: Break-Even-Heuristik = Spline B=3 Interpolation der Checkpoint-Messwerte, als parsebarer String gespeichert | OWNER-ENTSCHEID/FEATURE | Z1188 | GESETZT | Owner |
| Workflow planer-cli-check-size-und-messkette gestartet | AUFGABE | Z1190-1191 | LAEUFT | Workflow |
| Owner Z1200 Frage2+3: Experiment-B+-Baum als Vergleichsordnung — jede Achse=Node fester Tiefe, Diff isoliert Break-Even je Achse, Wiederholung fuer alle Haupt-/Unter-Achsen, konsolidierte (zusammengefuehrte) Implementierung | OWNER-ENTSCHEID | Z1200 | GESETZT | Owner |
| Owner Z1200 Frage2: Planer-Interpreter muss Altsystem abloesen | OWNER-ENTSCHEID | Z1200 | GESETZT | Owner |
| Owner Z1200 Frage4: "hoert sich fuerchterlich falsch an", mehr Kontext gefordert | AUFGABE | Z1200 | OFFEN (Rueckfrage) | Owner-Rueckfrage |
| Owner Z1200 Frage5: 5 Mess-Ebenen praezisiert (Planer<->CLI, CEB-Pruefdock wallclock 2 Ebenen, Tier-Binary Macro+Micro = insges. 5) | OWNER-ENTSCHEID | Z1200 | GESETZT (Klarstellung) | Owner |
| Owner Z1200 Frage6: GO zum Bauen unter sorgfaeltiger Design-Planung, Ruecksprache im Detail Pflicht | OWNER-ENTSCHEID | Z1200 | GESETZT | Owner |
| Owner Z1200 Frage7: Ziel = Diplomarbeit mit Messwerten/Auswertung allein aus XML-Wuenschen generierbar (Abgabe-Scope) | OWNER-ENTSCHEID | Z1200 | GESETZT | Owner |
| Owner Z1200 Frage8: Bausteine duerfen jetzt AUCH in Evaluation/Auswertung UND Implementierung (XML-Konfig aendert kompilierte Realitaet) — Scope-Entscheidung neu, Freigabe unter gemeinsamer Design-Planung | OWNER-ENTSCHEID | Z1200 | GESETZT (Scope-Erweiterung) | Owner |
| Owner Z1200 Frage9-12: "bitte mehr Kontext, ich verstehe dich nicht" | AUFGABE | Z1200 | OFFEN (Lead-Fragen unklar formuliert) | Owner-Rueckfrage |
| Task #52 ERSTES TODO: Experiment-Groesse erheben — Planer-CLI --check-size | AUFGABE | Z1215-1216 | OFFEN (angelegt) | - |
| Owner Z1245: Bestaetigung "genau erfasst" — Break-Even je isolierter Achsen-Permutation/Baum-Node-Tiefe; Experiment-Groesse als ERSTES TODO fuer Planer offen (Groesse nicht genau bekannt); eigene Frage5 (Vorversion) war falsch | OWNER-ENTSCHEID | Z1245 | GESETZT/Korrektur | Owner |
| Owner Z1245 Frage1: Mess-Baum hat 3 Ebenen (Wurzel=Gesamtverlauf/wallclock CEB-root, Macro=je Funktionsaufruf, Micro=je Achse), 3!=6 CEB-Varianten (reaffirmiert) | OWNER-ENTSCHEID | Z1245 | GESETZT | Owner |
| Owner Z1245: Break-Even wird 3-fach berechnet (Achsen-Ebene, Funktions-Ebene, Gesamt-Ebene = Micro/Macro/combined) | OWNER-ENTSCHEID/FEATURE | Z1245 | GESETZT | Owner |
| Owner Z1245 Frage2: Schichten muessen strikt einsortiert werden (Gattung->Genus->Implementierung), "Fenster ist JETZT, bevor es teuer wird" | OWNER-ENTSCHEID | Z1245 | GESETZT (PFLICHT jetzt, nicht spaeter) | Owner |
| Owner Z1245 Frage3: "Flattern als Signal" — gemittelte beste Binary fuer Normalfall, Hybrid erkennt+nutzt genau die flatternden Lastbereiche zur Laufzeit-Orchestrierung | OWNER-ENTSCHEID/FEATURE | Z1245 | GESETZT | Owner |
| SF-1-Schichtverletzung identifiziert: container_framework.hpp:37 (anatomy/) inkludiert unzulaessig aus builder/experiment_tree/genus_binding_traits.hpp | REGRESSION | Z1210-1214, Z1267 | OFFEN: Agent SF1-schichtschnitt Analyse gestartet | Agent SF1-schichtschnitt |
| SF-1-Analyse (A-E) komplett: NUR diese eine Verletzung im ganzen Baum (Schichtung axes<anatomy<builder<profile_facade<abi bestaetigt), Empfehlung Weg 2 (Abhaengigkeit umkehren via Concept-Parameter, ABI-Flaeche NULL, 1 Header+14 Tests) | REGRESSION | Z1234-1325 | ANALYSIERT, Weg 2 zum Bau freigegeben | Agent SF1-schichtschnitt |
| Keine bestehende Wache gegen Schichtverletzungs-Fehlerklasse (Nullbefund mit bestandener Gegenprobe); Vorschlag scripts/lint_layer_includes.sh | REGRESSION | Z1314-1319 | OFFEN (neue Wache vorgeschlagen, noch nicht gebaut) | ce |
| Andersartige Auffaelligkeit: anatomy/abi_adapter.hpp includiert direkt ~20 konkrete axes/topics-Header (Gegenrichtung zur ueblichen Kopplung ueber organ_location.hpp) | UNKLAR | Z1286 | Gemeldet, Einordnung unsicher, separat von SF-1 zu behandeln | ce |
| Assist-Gegenlesung SF-1: 3 Belege bestaetigt, 2 Praezisierungen (4 statt 2 anatomy-Verzichts-Dateien, 69 statt ~30 Nutzer von axis_path_serialization.hpp, 2 statt 0 Produktionskonsumenten von container_framework.hpp, weiterhin 0 ABI-Konsumenten) | REGRESSION | Z1329-1331 | Verifiziert/praezisiert | Assist-Review |
| SF-1-Bau (Weg 2) gestartet | AUFGABE | Z1332-1334 | LAEUFT (Agent SF1-bau) | Agent SF1-bau |
| NFS-Export (* statt 10.0.20.0/24) Klaerung: KEIN Versehen, sondern Absicht — alle Maschinen bedienen die Lagerhaltung, Sync per File geplant | REGRESSION | Z1334 | GEKLAERT (Korrektur zum fruehen Nebenbefund: kein Bug) | Cluster |
| SF1-bau Blockade: wt-ce-fk Checkout hatte fremden Branch-Stand + untrackte Datei err1.txt (87 Byte gcc-Fehlerausgabe vom MMX-Bau) | REGRESSION | Z1341-1358 | BEHOBEN: Streu-Datei entfernt (Inhalt bereits im Commit/Ledger), Bau entblockt | Assist/Agent SF1-bau |
| SF1-bau STOP-Meldung: wartet auf Owner/Lead-GO statt fremden Worktree anzufassen (korrektes Verhalten) | AUFGABE | Z1356-1372 | BEHOBEN: GO erteilt nach Verifikation (Z1373-1381) | Agent SF1-bau |
| Eigener pgrep-Selbstmatch (fand sich selbst, weil Kommandozeile "wt-ce-fk" enthielt) | REGRESSION | Z1367-1379 | BEHOBEN sofort erkannt/korrigiert | Assist |
| Owner Z1383 (Schock-Reaktion): 6-CEB-Bau reaffirmiert — ohne mit/ohne Mess-Einrichtung je Mess-Stufe "klappt es nicht"; Vertraege zwischen 3 Mess-Ebenen (Snapshot nach jedem Durchfuehrungszeitpunkt, Replay je Komponente zur Messfehler-Herausrechnung) | OWNER-ENTSCHEID | Z1383 | GESETZT | Owner |
| Owner Z1383: Release-Modus (nach compare) definiert — lazy Pruefung Gesamtkette, Ausgabe/Neu-Kompilation Tier-/Hybrid-Binary aus dokumentierter compare-Messwert-Bibliothek, ggf. nur Wallclock ohne Messfuehler gegen Pruefdock-GoogleTests verifiziert | OWNER-ENTSCHEID/FEATURE | Z1383 | GESETZT | Owner |
| Eigener F-3-Alarm ueberzogen: Halbsatz nach Semikolon nicht gelesen ("getrennt/Teilmengen bleibt XML-Recht") — Doktrin steht NICHT gegen die 6 CEBs | REGRESSION | Z1384-1401 | BEHOBEN/entkraeftet (Fehlalarm) | Assist |
| Session-Doku 20260808-SESSION-messkette-paper-xml-und-die-vier-ultracode-laeufe.md geschrieben | AUFGABE | Z1391-1394 | BEHOBEN (super 3603962d) | Assist |
| Owner Z1396: Umbrella-Verwechslung — Annahme wt-super-landung sei "kuenstlich", fordert Verschiebung aller Doku ins "echte probst-Diplomarbeit umbrella" + Git-Tracking + Scope-Trennung (Kette/Durchfuehrung->Umbrella, Technik->ce) | OWNER-ENTSCHEID | Z1396 | GESETZT, dann als Missverstaendnis aufgeklaert (s.u.) | Owner |
| Workflow repo-scope-sortierung gestartet | AUFGABE | Z1409-1410 | LAEUFT | Workflow |
| Klarstellung: wt-super-landung IST bereits das echte Umbrella (github BenniProbst/probst-Diplomarbeit-cache-engine, gitlab research/probst-diplomarbeit-cache-engine) — Owner-Praemisse war falsch (irrefuehrender Name) | REGRESSION | Z1399-1411, Z1412 | GEKLAERT/entkraeftet, Owner bestaetigt Missverstaendnis ("Namen nicht erkannt") | Assist->Owner |
| Echte Luecke gefunden: 2 ungetrackte Dateien in docs/ (Paper-Permutations-Analyse, MMX-Recherche) waeren bei rm -rf verloren gegangen | REGRESSION | Z1403-1408 | BEHOBEN (committed, super a15a74a0) | wt-super-landung |
| Owner Z1477: Aufraeum-Auftrag — measurements-Ordner in super-Wurzel evtl. obsolet (Buildsystem ersetzt), aehnliche Deprecated-Faelle identifizieren | AUFGABE | Z1477 | GESETZT | Owner |
| Agent Deprecated-Inventar beide Repos gestartet | AUFGABE | Z1498-1499 | LAEUFT | Agent |
| measurement/ (Singular) + Messdaten-Backup/ enthalten ECHTE Messdaten (Erstbeleg 26.07. + Petrischalen-Auswertung 120.960 Messzeilen/320 Binaries, fertiges PDF) — Owner-Vermutung "nicht mehr noetig" widerlegt durch Messdaten-nie-loeschen-Doktrin | REGRESSION | Z1416-1467 | BEHOBEN: NICHT geloescht, stattdessen verschoben mit erhaltener Historie (git mv, 17 Dateien) nach docs/architektur/measurement/ | wt-super-landung |
| 134 Dateien (u.a. Ledger) verweisen auf alte Wurzel-Pfade nach Verschiebung — kein CI-Bezug, historische Sessions unangetastet (Doktrin), Wegweiser-README am neuen Ort erstellt | AUFGABE | Z1470-1478 | BEHOBEN (super 00c5c1cf) | wt-super-landung |
| SF-1-Bau FERTIG: Weg 2 gebaut (container_framework.hpp Include entfernt, GenusBuildBinding-Concept, neuer Adapter container_type_traits.hpp, 14 Test-TUs umgestellt) | FEATURE | Z1425-1449 | GEBAUT, 428/428 gruen, 2 Commits (f09751f4, b000ccc6) auf bau/sf1-schichtschnitt | Agent SF1-bau |
| SF-1: neue Wache scripts/lint_layer_includes.sh + CI-Job lint:layer-includes gebaut | FEATURE | Z1432, Z1436-1439 | GEBAUT, Bissprobe bestanden (54 Header, Koeder gefangen an exakter Zeile) | Agent SF1-bau |
| SF-1-Bau: 1. Vor-Push-Wache-Runde fand 1 ASCII-Verstoss (Box-Drawing-Zeichen) + 8 clang-format-Abweichungen | REGRESSION | Z1439 | BEHOBEN (2. Runde gruen) | Agent SF1-bau |
| SF-1-Bau: erste Mock-Bindung schlug fehl (GCC instanziiert Binding::template Foo schon bei Klassen-Instanziierung, nicht erst bei Nutzung) | REGRESSION | Z1446 | BEHOBEN (nachgebessert, im Code kommentiert) | Agent SF1-bau |
| Assist-Gegenlesung SF-1-Bau: alle 3 Kernbehauptungen bestaetigt (Kante entfernt 0 Treffer, Wache greift beide Richtungen, 428/428 gruen nach eigenem Bau) | REGRESSION | Z1452-1461 | Verifiziert | Assist-Review |
| SF-1 gelandet (18 Dateien, Vor-Push-Wache gruen, gitleaks sauber) | FEATURE | Z1462-1464 | GELANDET: ce development=b000ccc6 | ce (wt-ce-fk) |
| Deprecated-Inventar K1-1 CE ZIH/SLURM/Apptainer-Pfad (slurm_launcher.hpp, deploy/*), DEPRECATED 16.07., nicht verdrahtet | REGRESSION | Z1489 | Empfehlung: bleibt (bereits doktrinkonform) | ce |
| Deprecated-Inventar K1-2 super Submodul-Gitlink Code/external/20260931-overleaf-diplomarbeit ist TOT (im .gitmodules dokumentiert), Nachfolger thesis/diplomarbeit | REGRESSION | Z1491 | OFFEN: Owner-Entscheid "Loeschung=GO" noetig | super |
| Deprecated-Inventar K1-3/K1-4/K1-6/K1-9/K1-10/K1-12: diverse CE-DEPRECATED-Marker (extension_hardware_system_axis.hpp, 4 Concept-Header, test_data_sets.xml, .gitmodules.template.obsolete, modules/, Kommentar-Historie) sauber markiert | REGRESSION | Z1493-1499, Z1505-1511 | Empfehlung: bleibt (bis auf K1-9: Owner-Entscheid noetig wg. Widerspruch zur A1/A6/A7-Supersession) | ce |
| Deprecated-Inventar K1-5 CE adhoc_emitter/main.cpp SUPERSEDED, aber bewusst als Diagnostik-Monolith weiter gebaut | REGRESSION | Z1497 | Empfehlung: bleibt | ce |
| Deprecated-Inventar K1-7 super Code/02_messung_driver/* (ganzer V32-Treiberpfad) DEPRECATED-BY-DESIGN, Code nennt selbst Ledger §75 als ausstehenden Aufraeumschritt | REGRESSION | Z1501 | OFFEN: Owner-Entscheid/Statusabgleich Ledger §75 noetig | super |
| Deprecated-Inventar K1-8 Kreuz-Repo: thesis .ps1-Skripte (generate_measurement/wide_appendix.ps1) OHNE eigenen Deprecated-Marker (Abloesung nur CE-seitig dokumentiert) | REGRESSION | Z1503 | ZUNAECHST Empfehlung "deprecaten", dann PRAEZISIERT: beide tragen bereits Marker seit 03.08. (Agent-Fehlbefund) | thesis |
| Deprecated-Inventar K2-1 super Code/tools/ (5 Dateien, 44K) 0 Treffer ueberall, moeglicher Behelfsweg gegen "NUR EIN XML-Programm"-Doktrin | REGRESSION | Z1515 | OFFEN: Owner-Entscheid noetig | super |
| Deprecated-Inventar K2-2 Messdaten-Backup/analyze_ff.py 0 Treffer, kein Marker | REGRESSION | Z1517 | BEHOBEN: Marker ergaenzt (s.u.) | super |
| Deprecated-Inventar K3-1 (WICHTIGSTER FUND) super measurement/-Wurzel + Job persist:measurements — Umzug auf Buildsystem-Mount BEREITS ENTSCHIEDEN, laeuft in Strang A-4, kein neuer Owner-Entscheid noetig | FEATURE | Z1521 | GEPLANT (nur Vollzug abwarten) | A-4-Strang |
| Deprecated-Inventar K3-2 CE build/thesis_tiere/tier150_measurements.csv (einzige getrackte Datei unter build/) | AUFGABE | Z1523 | OFFEN: Owner-Entscheid noetig (mitwandern oder golden bleiben), NIE loeschen | ce |
| Deprecated-Inventar K4-1 CE docs/architektur/ (1 Datei) vs. docs/architecture/ (43 Dateien) — EN/DE-Namenskollision, keine Inhaltsdopplung | REGRESSION | Z1527 | BEHOBEN: git mv, Historie erhalten (s.u.) | ce |
| Deprecated-Inventar K4-3 docs/termine/ vs. docs/termine_konsolidiert/ — KEINE Dopplung (Referenz-statt-Kopie), aber Termine 9-11 noch nicht konsolidiert | AUFGABE | Z1531 | OFFEN (Fortschritts-Luecke, kein Aufraeum-Fund) | Doku |
| Deprecated-Inventar K5-1 CE Root 4 Python-Skripte (_analyze_licenses.py u.a.), 0 CI/CMake-Bindung | REGRESSION | Z1535 | ZUNAECHST "Owner-Entscheid noetig", dann PRAEZISIERT: alle 4 tragen bereits W9.5/G10-Vermerk als bewusste Ausnahme — KEIN Doktrin-Verstoss (Agent-Fehlbefund) | ce |
| Deprecated-Inventar K6: Forschungsarbeiten/ (220MB) + docs/sessions/backups/ (166MB) bestaetigt KEIN Aufraeum-Kandidat (Paper-Vendoring bzw. aktiv zitierte Rohdaten-Backups) | REGRESSION | Z1541-1547 | Empfehlung: bleibt zwingend | Doku |
| Assist behebt 3 der 5 lohnendsten Punkte: K4-1 (docs/architektur->docs/architecture git mv), K5-1+K1-8 als Fehlbefunde entkraeftet (Marker bereits vorhanden), K2-2 (analyze_ff.py Marker ergaenzt) | REGRESSION | Z1582-1605 | BEHOBEN: gelandet ce e347d313 + super 01aee9b9 | Assist |
| Owner Z1602: 5. Wiederholung — xlsx (nicht CSV) ist Standardausgabe laut XML, Sheet-Aufbau bereits definiert | OWNER-ENTSCHEID | Z1602 | GESETZT (5x wiederholt, Frustration) | Owner |
| Eigenes wiederholtes Versaeumnis: xlsx-Standard 5x uebersehen, Wurzel = A9-S3/S4/S5 nie begonnen (xlsx-Weg reiner Vendor ohne Schreiber) | REGRESSION | Z1603, Z1616, Z1621 | dokumentiert (dup von Phase-3.9-Fund), Agent xlsx-Sheet-Aufbau gestartet | Assist |
| xlsx-definition Kartierung (F1-F5): Sheet-Definition EXISTIERT (F1), teilweise gebaut (lager_pfad_grammatik.hpp, A9-S1-Vendor), Writer fehlt komplett (F4), 2. offene Owner-Frage zu Blattform (Mess-Profil-Charts) ergaenzt die erste | REGRESSION | Z1608-1610 | Ergebnis TEILWEISE gesehen, Fortsetzung naechster Block | Agent xlsx-definition |
| F1 Fassung 1 (26.07., KERN=Gesetz): xlsx=DEFAULT, CSV Fallback; xlsx=1 Datei/1 Sheet je Unter-Achsen-Permutation + INFO-Sheet | OWNER-ENTSCHEID | Z1613-1616 | GESETZT (entschieden) | Owner |
| F1 Fassung 2 (02.-03.08., A9-Design-Dossier): C++-API konkretisiert (Sheet-Name<=31 Zeichen, Zeilenlimit-Fehlerklasse, Dateiname-Grammatik, CSV-Fallback gleiche Factory, 11-Ebenen-Ablage-Baum) — "TRAGFAEHIG mit Auflagen" abgenommen | FEATURE | Z1618-1623 | GEPLANT/API-fertig, nicht gebaut | ce-Design |
| F1 Fassung 3 (06.-07.08., O-B "Mess-Profil als xlsx"): xlsx auch Traeger des Mess-PROFILS (Zeitreihe, nicht nur Endergebnis) | OWNER-ENTSCHEID | Z1625-1628 | GESETZT (erweitert Fassung 1/2) | Owner |
| R-3 xlsx-Blattform fuers Profil: Lead-Empfehlung unbeantwortet, blockierte A9-S3-Writer-Bau | REGRESSION | Z1630-1633 | ZUNAECHST OFFEN, dann BEANTWORTET (s.u. Owner Z1698) | Owner-Entscheid |
| Erkenntnis: Fassung 1/2 (Zeile-pro-Ergebnis) und Fassung 3 (Zeitreihe/Chart) sind STRUKTURELL VERSCHIEDENE Tabellenformen, Bruecke fehlt | REGRESSION | Z1635 | OFFEN (durch Owner-Antwort Z1698 mitgeloest) | ce |
| F2 XML-Schalter: KEIN xlsx-Wert in writeback_method_registry.hpp (nur Csv/LatexTable/ComparisonMetrics, kWritebackMethodCount=3 static_assert-gesperrt) | REGRESSION | Z1637-1643 | OFFEN | ce |
| F3 Ist-Stand: CSV an 2 Stellen geschrieben (pro-Binary result.csv + aggregierte measurements.csv), Legacy-Zweitkopf result_aggregator.hpp; KEIN xlsx-Schreiber existiert (0 Treffer) | REGRESSION | Z1645-1656 | OFFEN | ce |
| F4 A9-Paket-Stand: S1 Vendor GELANDET (351205f5), S2 Grammatik HALB (ergebnis_dateiname.hpp/31-Zeichen-Wache/ErgebnisSchreibFehler fehlen), S3/S4/S5 (Writer-Kern/CLI/Erstbeleg) NICHT BEGONNEN, 10-Schritte-Bauplan benannt | REGRESSION | Z1657-1674 | OFFEN (dup/Praezisierung von Phase-3.8/3.9) | ce |
| F5 CSV bleibt legitim in 5 Faellen (Fallback, Heuristik-Eingabe, Test/Golden, Roh-Archiv, Legacy-Zweitkopf=LED-75-Kandidat) | FEATURE | Z1676-1687 | GEPLANT/dokumentiert | ce |
| Owner-Zitat 05.08. (Ledger:4163): "CSV xor xlsx, xlsx Default, Strategy Pattern nicht Chain of Responsibility" | OWNER-ENTSCHEID | Z1678-1680 | GESETZT | Owner |
| Nicht geklaert: fail-closed bei unbekanntem 4. writeback-Wert? exakte Owner-Antwort-Uhrzeit "xlsx Standard"? | REGRESSION | Z1690-1692 | OFFEN | ce |
| A9-S3 xlsx-Writer-Bau gestartet (Fassung 1/2, der entschiedene+API-fertige Teil) | AUFGABE | Z1708-1710 | LAEUFT (Agent A9-S3) | Agent |
| Task #53 A9-S3 XLSX-WRITER IM BAU — "Vendor lag 5 Owner-Ansagen lang ohne Rohr dahinter" | AUFGABE | Z1711-1712 | OFFEN/LAEUFT | - |
| Owner Z1655 Entscheid 1: Code/external/20260931-overleaf-diplomarbeit MUSS BLEIBEN (widerspricht Deprecated-Inventar-Empfehlung K1-2) — CI+lokal synchronisieren beide dorthin, statischer Pfad fuer LaTeX-Anlagen-Ergebnis | OWNER-ENTSCHEID | Z1655 | GESETZT (widerlegt K1-2-Empfehlung) | Owner |
| Owner Z1655 Frage2: Explore zum Zustand des Ledger-§75-Aufraeumpasses (Vermutung: kritisch halb fertig) | AUFGABE | Z1655 | GESETZT | Owner |
| Owner Z1655 Frage3: einziges offizielles Linux-Bau-Verfahren = configure.sh/make/make install/make check im Wurzelordner (Web-Recherche PFLICHT); super entscheidet XML-Auswertung, Mechanik liegt als Framework in ce (Planer/CEB/Tier-Binaries); Anwender ruft Planer-CLI nach Install auf | OWNER-ENTSCHEID | Z1655 | GESETZT (PFLICHT-Standard-Interface + Architektur-Trennung super/ce) | Owner |
| Owner Z1655 Frage4: tier150_measurements.csv ARCHIVIEREN (veraltet, Gesamtstrang wird neu gemessen) | OWNER-ENTSCHEID | Z1655 | GESETZT (entscheidet K3-2) | Owner |
| Workflow repo-scope-sortierung Ergebnis gesichert (19097 Zeichen) | AUFGABE | Z1681-1683 | GELIEFERT | Workflow |
| Kontextuebergabe 20260808-KONTEXTUEBERGABE-messkette-xlsx-repo-scope.md geschrieben | AUFGABE | Z1684-1694 | BEHOBEN (super 141333c0) | Assist |
| Owner Z1698: R-3 Blattform final beantwortet — CSV flach mit Zeitraum+Ebene im Namen; XLSX je Ebene/Messbereich, 1 Sheet je Achse (Micro) bzw. je Funktion (Macro) gegen Sheet-Explosion, Micro<->Macro verlinkt, sequenzielles Logging (Aufrufer+Zeitpunkt+Messwerte), Gattungs-Interface-Ebene via Macro-Benchmarking mitgemessen | OWNER-ENTSCHEID | Z1698 | GESETZT (loest R-3 endgueltig) | Owner |
| R-3 Status-Fortschreibung: von OFFEN zu BEANTWORTET (Ledger-Nachtrag OWNER-ENTSCHEID, Kontextuebergabe aktualisiert) | REGRESSION | Z1727, Z1739 | BEHOBEN | Assist |
| Python-Syntaxfehler beim Bearbeiten der Kontextuebergabe (Anfuehrungszeichen im Text) | REGRESSION | Z1722-1723 | BEHOBEN (zeilenbasiert erneut ausgefuehrt) | Assist |
| E-18-Vorwaertskanal (ci/anhang_forward_core.sh, Job anhang:forward) gelandet 06.08., aber INERT (Job-Liste ohne ihn, Token/Var-Scharfschaltung fehlt) | FEATURE | Z1029 (Dossier-Zitat) | GEBAUT/GELANDET aber INERT (Owner-offen: Ziel-Branch development vs. main/Overleaf R2) | ce/CI |
| M08 appendix_generator: schreibt alle Darstellungsformen (Heatmap/3D/Ratio/Normbar/Sweep/Forest/Pareto/ECDF/Range/Segment-Attribution/Observer-Detail/Achsen-Inventar/Bias/Exchange/Limitierung), honest-empty-fest | FEATURE | Z1029 | GEBAUT | ce |
| Anhang-Verdrahtung Weg A (\InputIfFileExists, eigener Ersatztext) in anhang/de/A_measurements.tex, 30 Eintraege | FEATURE | Z1029 | GEBAUT/verifiziert | thesis |
| Owner-Zitat 11.-12.07.: CI-interaktive Diplomarbeit (XML-Einstellung -> dynamisch ausgewertete Messwerte/Tabellen/Diagramme) | OWNER-ENTSCHEID | Z1029 (Dossier-Zitat, Quelle Transkript-Chunk 10/38) | GESETZT (Datum unsicher) | Owner |
| Owner-Zitat 13.-14.07.: "Generieren der LaTeX-Anhaenge ist Haupt-Ziel des Gesamt-Systems" | OWNER-ENTSCHEID | Z1029 | GESETZT | Owner |
| Ledger-Gesetz 16.07. F1 JA+ERWEITERUNG: XML waehlt Auswertung/Speicherort je Experiment (Bibliothek+XML-Programmierung) | OWNER-ENTSCHEID | Z1029 (LEDGER:533) | GESETZT (gebucht) | Owner/Ledger |
| §16.1-C2 (16.07.): XML nennt nur Ziel-Ordner, build->ziel-Copy FEHLT HEUTE | REGRESSION | Z1029 (LEDGER:1509) | OFFEN (seit 16.07. dokumentierte Luecke) | ce |
| E-18 = LaTeX-Anhang-Vorwaerts-Kanal je CI = HAUPT-ZIEL des Gesamtsystems (26.07., §68c) | OWNER-ENTSCHEID | Z1029 (LEDGER:3554) | GESETZT | Owner/Ledger |
| Auftrag 08.08 NEU: Auswahl/Reihenfolge+Aufmachung aus XML, schaltende Textbausteine im Hauptteil — widerspricht F10 ("FEST VERDRAHTETER Output") | REGRESSION | Z1029 | OFFEN: Konflikt, braucht Owner-Entscheid O-4 | Owner-Entscheid noetig |
| Betreuer-Feedback H3 (08.05.): vordefinierte Textbausteine NUR im Appendix (Compile-Zeit, Binary-Dumps) — Spannung zum 08.08-Auftrag (auch Evaluation/Auswertung) | REGRESSION | Z1029 | OFFEN: braucht Owner-Entscheid O-4 | Betreuer/Owner |
