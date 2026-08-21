# Sammelstrecke Leser 5 — Ledger Zeilen 18401-23000

Quelle: docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (exklusives Segment 18401-23000 von 32210)

| KUERZEL/Name | Klasse | Quelle (Z-Anker) | Status LAUT QUELLE | Traeger/Task |
|---|---|---|---|---|
| LAG-Z1 Fingerprint-Provider SIMD-Schluessel (Datenintegritaets-Alarm) | REGRESSION | Z18404-18471 | GEPRUEFT/WIDERLEGT am Hauptweg (12/16 Treiber tragen COMDARE_GN_SIMD); echt ist Provenienz-Verlust bei statischen super-Jobs, nicht falscher SKIP; Fix bewusst NICHT gebaut | ce 9f92d49f, Strang 20 |
| LAG-Z1 --mutant Rot-Beleg (lauf-konstanter Schluessel = historischer Rueckfall) | REGRESSION | Z18456-18471 | CI-BEWIESEN rot: rc=1, 3/3 Trennfaelle gerissen, 0/320 binary_ids getrennt | test_lagz1_lager_schluessel_simd.cpp |
| LAG-Z1 Testregistrierung #409/#410 (T-7) | AUFGABE | Z18469-18471 | GELANDET/CI-BEWIESEN (Inventur 463->465, Abdeckung 465/465) | ce 9f92d49f |
| ZWEI PARSES EINE ENTSCHEIDUNG (profile_run_facade.cpp:605 vs profile_run_entry.hpp:948 lesen Profil doppelt) | REGRESSION | Z18478-18481 | OFFEN (eigenes Paket, bei Drift laeuft Perm-Schleife ohne compile_for_perm) | - |
| GitLab-Gruppen-/Projekt-Variable COMDARE_BESTANDSLOG | AUFGABE | Z18482-18483 | OFFEN/UNKLAR (aus Repo nicht entscheidbar, API nicht abgefragt) | - |
| LAG-Z1-Wache nur in wt-ce-xml, nicht im super-eingebundenen ce-Stand | AUFGABE | Z18484-18485 | OFFEN (Vendoring-Nachzug fehlt) | - |
| Mess-Jobs Falle wc-l-Leerheitspruefung + Konkatenation ohne awk1 (Anhang-Kern-Kopie) | REGRESSION | Z18486-18509 | BEHOBEN (wc -l < WIDE 2->0 Nennungen, P4-Probe 0->1) | super 80538ef1 |
| Mess-Ausbeute-Bissprobe Strang 4 (11h Laufzeit) | AUFGABE | Z18488 | GELANDET | super 2610687e |
| A7-Kommentar-Blindheit (Bauer formt eigenen Kommentar um, damit Pfad nicht literal im Kommentar steht) | REGRESSION | Z18504-18511 | BEHOBEN (Probe-Pfad) | super 80538ef1 |
| Testluecke: 2 Kopien Mess-Jobs-Logik ungedeckt durch Anhang-Kern-Probe | REGRESSION | Z18513-18522 | OFFEN, Vorschlag ci/wide_aggregat.sh zusammenziehen, eigenes Paket | - |
| Zweite unabhaengige Registrierungs-Wache ci/tests/*.sh gegen .gitlab-ci.yml | AUFGABE | Z18524-18527 | OFFEN (Zirkularitaetsproblem: Wache kann eigene Abwesenheit nicht melden) | - |
| Mess-Ausbeute-Wache: erster exit-1-Zweig bei MINDEST>=1 nicht beobachtbar | REGRESSION | Z18529-18539 | BEHOBEN (Fall MINDEST=0 ergaenzt, einziger Toeter) | - |
| Regel: Mutations-Koeder-Beobachtbarkeit vor Geltung pruefen | OWNER-ENTSCHEID | Z18541-18545 | FESTGELEGT, ins Memory aufgenommen | - |
| D3-2 Wellenplan-Selbstwiderspruch (Zeile 306 "==0 (heute 2)" vs Nachtrag "bereits gelandet") | REGRESSION | Z18547-18556 | BEHOBEN (Tabelle korrigiert; grep -cF=2 vs grep -c ohne -F=stille 0/rc=1; neuer Fall F10 mit gewuerfeltem Koeder) | - |
| Kein Push/keine echte Pipeline wegen GitLab-500 (LAG-Bereich) | AUFGABE | Z18560-18562 | OFFEN/BLOCKIERT | - |
| Mess-Jobs inert-by-default in Normalpipeline | AUFGABE | Z18563-18564 | OFFEN | - |
| A7 Kommentar-vs-Aufruf-Unterscheidung im Kern-Pfad | REGRESSION | Z18565-18566 | OFFEN (Probe-Pfad geloest, Kern-Pfad nicht) | - |
| Vier von fuenf CI-gerufenen Wachen ohne Selbsttest | AUFGABE | Z18567 | OFFEN | - |
| Anhang-Kanal Falle 1: Glob *.result.csv trifft reale Datei result.csv nie | REGRESSION | Z18577-18580, 18597-18604 | BEHOBEN (Kern nimmt jetzt beide Formen; CI weiterhin nur exakte Form) | ce 6d2e3dce |
| Anhang-Kanal Falle 2: wc -l verwirft die eine Datenzeile (zweifach berechnet) | REGRESSION | Z18581-18582 | BEHOBEN | ce 6d2e3dce |
| Anhang-Kanal Falle 3: WIDE-Konkatenation ohne awk1 (Zeilen verkleben ab 2 Permutationen) | REGRESSION | Z18583-18586 | BEHOBEN | ce 6d2e3dce |
| Anhang-Kanal Falle 4: 0-Byte-CSV stiehlt Header-Flag | REGRESSION | Z18588-18590 | BEHOBEN (erst Nachsatz fand sie) | ce 652083d1 |
| CI und Kern nutzen verschiedene Selektoren fuer dieselbe Datei (result.csv vs *.result.csv) | REGRESSION | Z18597-18604 | TEILWEISE BEHOBEN (Kern beidseitig ab P4, CI weiterhin nur exakt) | - |
| OV-17 Namensform-Entscheid (result.csv vs Archivform <stem>.result.csv) | AUFGABE | Z18603, 18613-18614 | OFFEN, Owner-Entscheid noetig (beide Formen real im Bestand: 18 Dateien, 8 im Archivformat) | - |
| AF_CORPUS_ROOT zeigt ins Leere (Default "measurement" existiert nicht am Repo-Root) | REGRESSION | Z18606-18611 | OFFEN | .gitlab-ci.yml:1524 |
| Anhang-Kanal P5: xlsx im Sammler | FEATURE | Z18570 | GELANDET | ce d7b779f7 |
| P4-Proben-Job ci/tests/anhang_forward_probe.sh (4 Wegwerf-Mutanten) | AUFGABE | Z18630-18642 | GEBAUT, NICHT VERDRAHTET (gesperrte Datei, faehrt in keiner Pipeline) | - |
| KONFORMITAETS-REGISTER Werkzeugfehler: Extraktion 346 Aussagen, Synthese nur 87 (.slice(0,150000) kuerzte) | REGRESSION | Z18651-18657 | DOKUMENTIERT, Nenner korrigiert auf 87 von 346 | - |
| s7-release-hybrid komplett aus Extraktion ausgefallen (StructuredOutput retry cap) | REGRESSION | Z18659-18663 | OFFEN (Nachholen noetig, HYBRID gilt als 0% gebaut) | - |
| Konformitaets-Bilanz 87 Aussagen: ERFUELLT 20/23%, TEILWEISE 47/54%, NUR_PAPIER 14/16%, VERLETZT 5/6%, NICHT_PRUEFBAR 1/1% | UNKLAR | Z18665-18680 | STATUS-SNAPSHOT, Untergrenze (Station 6: 0 Treffer ausserhalb tests/; Station 7: nur README; Station 8: csv=33 CI-Treffer, xlsx=0) | docs/sessions/20260809-KONFORMITAETS-REGISTER-soll-gegen-ist.md |
| Fristrechnung Konformitaets-Register: ~770h Bedarf vs 440-590h Budget | AUFGABE | Z18682-18696 | OFFEN, Fehlbetrag 180-330h, Owner-Reaktion noetig | - |
| Streichungsvorschlag CEB-27 Arbeitsmodus Hot-Switching -> Minimalform (-40h) | FEATURE | Z18697-18712 | VORGESCHLAGEN, OFFEN (Owner-GO je Zeile ausstehend) | Entscheidungsvorlage |
| Streichungsvorschlag CEB-43 + Post-v3 .so/<modules>-Schnitt (-64h) | FEATURE | Z18697-18712 | VORGESCHLAGEN, OFFEN | Entscheidungsvorlage |
| Streichungsvorschlag CEB-12 Wallclock-Vollausbau -> Nullpunkt+eine Checkpoint-Ebene (-28h) | FEATURE | Z18697-18712 | VORGESCHLAGEN, OFFEN | Entscheidungsvorlage |
| Streichungsvorschlag CEB-34 Release-Rekonstruktion (-24h) | FEATURE | Z18697-18712 | VORGESCHLAGEN, OFFEN | Entscheidungsvorlage |
| Streichungsvorschlag CEB-18 P/E-Core -> nur prod2-Probe (-16h) | FEATURE | Z18697-18712 | VORGESCHLAGEN, OFFEN | Entscheidungsvorlage |
| Streichungsvorschlag CEB-20 L2/Kohaerenz -> eine RAW-Zeile je uArch (-12h) | FEATURE | Z18697-18712 | VORGESCHLAGEN, OFFEN | Entscheidungsvorlage |
| Streichungsvorschlag Paper-XML -> 3 Referenz-Paper statt Generator fuer 33 (-22h) | FEATURE | Z18697-18712 | VORGESCHLAGEN, OFFEN | Entscheidungsvorlage |
| Streichungsvorschlag Compiler-Unterachsen Toolchain-Permutation (-12h) | FEATURE | Z18697-18712 | VORGESCHLAGEN, OFFEN | Entscheidungsvorlage |
| Streichungsvorschlag CEB-19 Pinning-Kette -> Resolver nur core_class (-10h) | FEATURE | Z18697-18712 | VORGESCHLAGEN, OFFEN | Entscheidungsvorlage |
| Bau-Reihenfolge Datenintegritaets-Trias (Zell-Env ~2h Strang 20, PMC-Glied ~12h, G3-Gate ~16h) | AUFGABE | Z18717-18723 | GEPLANT | Strang 20 u.a. |
| Bau-Reihenfolge Rest (Mess-Deckel ~38h, Lane->Lager ~24h, Zeit-Nullpunkt ~12h, Auswertungs-Anschluss ~32h, xlsx-Durchstich, Hybrid-Minimal ~55h) | AUFGABE | Z18722-18723 | GEPLANT | - |
| Lager simd-blindes Dedup (Befund 1 der Schwereliste) | REGRESSION | Z18725-18738 | GEPRUEFT: entkraeftet als falscher SKIP, echt ist Provenienz-Verlust (siehe LAG-Z1 oben, Z18404) | Strang 20 |
| Blockierende Entscheide Frist Mi 12.08.: D-3, D-5, K1/K2/K4/K5 Hybrid, PMC-als-Preimage-Glied, CEB-Identitaet A/B, CEB-38, Wallclock-Schichtzuordnung, std::variant-Ausnahme | AUFGABE | Z18740-18748 | OFFEN, Entscheid ausstehend, Frist 12.08. | Owner |
| D-3 vs 08.08.-Aussage Selbstwiderspruch (Bau folgt Mess vs groesserer Bau-Satz) | REGRESSION | Z18742-18744 | OFFEN, Bestand widerspricht sich selbst | - |
| Provenienz-Fehlzuordnung Commit 58805728 (677 Zeilen LAG-P1-Arbeit unter fremdem Commit-Namen "docs: Rangfolge richtiggestellt") | REGRESSION | Z18751-18784 | RICHTIGGESTELLT per Dokumentation (kein Rebase; 4/4 Dateien byte-identisch per cmp -s verifiziert) | - |
| Regel EIN SCHREIBER JE WORKTREE (Ursache: 3 Schreiber gleichzeitig im selben Worktree) | OWNER-ENTSCHEID | Z18774-18781 | FESTGELEGT, ins Memory gebrannt | - |
| Mein Abnahme-Entwurf war Stellvertreter (aktiv-Zeile beweist scharfes Lager nicht, Schreibweg kann danach scheitern ohne Abbruch) | REGRESSION | Z18787-18804 | ERKANNT; vollstaendige Abnahme (object_stat) NICHT ERBRACHT, GitLab-500 blockiert Push/Trigger | - |
| LAG-P4: 4096er-Korn compile-hart gebunden (3 Konstanten per static_assert verbunden) | FEATURE | Z18807-18821 | GELANDET | ce 8cbf83d5 |
| Spiegel-Kommentar-Drift (223 Zeilen Abweichung, doppelt gedriftet auf falsche Zeile 439 statt 662) | REGRESSION | Z18813-18816 | BEHOBEN, strukturell durch static_assert unmoeglich gemacht | ce 8cbf83d5 |
| LAG-P2: Messwert-Genus bekommt Schluessel (3 tote Felder belegt, ce-Seite 4/4/2 verifiziert) | FEATURE | Z18823-18832 | GELANDET (ce-Seite) | ce 59cc9428 |
| M-1a-Rueckstellung aufgehoben (M-1a bereits 07.08. gelandet als bba4d90f, Vorfahr von HEAD) | OWNER-ENTSCHEID | Z18833-18835 | UEBERHOLT/AUFGEHOBEN | - |
| LAG-P2 Host-Anbindung fehlt (mess_bestandslog_active bleibt false in Produktion) | REGRESSION | Z18839-18851 | OFFEN: 3 Deklarationen in super main.cpp, 3 pa.*-Durchreichzeilen, neue Var COMDARE_BESTANDSLOG_MESS_DOC_KEY fehlt in Forward-Liste (experiment_plan_director.hpp:1008-1011) | - |
| Mutant M3 stumm (Marker-Zeilen-Erkennung ungedeckt) | REGRESSION | Z18860-18864 | BEHOBEN (Fall WARNUNG mit doc_key+owner ergaenzt, 3/3 Mutanten erkannt) | - |
| Eigener Arbeitsfehler: Kommentarzeile mit # statt // in main.cpp (haette Bau gebrochen) | REGRESSION | Z18866-18869 | BEHOBEN vor dem Bau | - |
| Wache hart bei COMDARE_BESTANDSLOG=true trotz fehlender Ebene B | UNKLAR | Z18875-18879 | AUSLEGUNG, KEINE FESTLEGUNG (Owner-Einwand moeglich) | - |
| doc_key-Default bestandslog/binary_bestand.xml | UNKLAR | Z18881-18884 | WAHL, KEINE FESTLEGUNG, ueberschreibbar per COMDARE_BESTANDSLOG_DOC_KEY | - |
| D5-1 Perzentil-Kanon (ceil(q*n)-1, Hyndman/Fan Typ 1, Median als Fall q=0.5) | FEATURE | Z18885-18900 | GELANDET, Verdikt TRAEGT MIT MAENGELN | ce c98b4b95, 0ebc5759, 87e7fac4 |
| nearest_rank_p ersatzlos geloescht | FEATURE | Z18895-18898 | GELANDET, verifiziert (3 Vorkommen nur noch in Kommentaren, 0 als Bezeichner) | ce c98b4b95 |
| Plan-Zahl "34 unbewachte Stellen" falsch, real 38 (5 Zaehlweisen durchprobiert) | REGRESSION | Z18901-18909 | KORRIGIERT: Sachaussage haelt, Zahl auf 38 korrigiert (Grund: Plan zaehlte aus wt-ce-fk statt wt-ce-xml) | - |
| Plan-Zahl "Pin 51->50" unvollstaendig, real DREI Pins (p99 100->99 zusaetzlich, p95-Pin fehlte ganz) | REGRESSION | Z18911-18915 | BEHOBEN (p95 96->95 ergaenzt) | - |
| Plan-Zahl "Definitionen 1 (heute 2)" vs roter Lauf zeigte 3 | REGRESSION | Z18917-18921 | ERKLAERT, kein Widerspruch (Reihenfolgeneffekt Kanon-Index+alte Formel = 3) | - |
| T-1 zwei Stufen: Compile-Fehler-Rot dann echter Werte-Rot-Lauf (51/96/100) | AUFGABE | Z18923-18932 | BEIDE ROTE LAEUFE DOKUMENTIERT, Abweichung ausdruecklich benannt | - |
| Diff-Hygiene-Wache im Default-Modus blind ("Wache die nicht wacht", 2. Fall) | REGRESSION | Z18936-18939 | BEHOBEN, Selbsttest gebaut+verdrahtet | ce 87e7fac4, scripts/ci_diff_ascii_width_guard.selbsttest.sh |
| D5-2 Befund: vals[(n-1)/2] IST bereits Kanon-Fall q=0.5, best_binary_selector rechnete seit jeher kanonisch | FEATURE | Z18941-18950 | BESTAETIGT (verkleinert D5-2-Restarbeit) | - |
| Median-Divergenz super-Seite diagram_generator.cpp:1783/1784 (obere statt untere Mitte) | REGRESSION | Z18945-18969 | OFFEN fuer D5-2 (bewusst unangetastet, aggregiert ueber Konfigurationen nicht Proben) | - |
| Median obere Mitte in cache_engine_builder_iterator.hpp:970 (haette Kanon gebrochen) | REGRESSION | Z18948-18950 | BEHOBEN (in D5-1 mitgenommen) | ce c98b4b95 |
| Kreuz-Test-Falle: vendorierter ce-Stand in super 98 Commits hinter HEAD, vor D5-1 | REGRESSION | Z18952-18961 | ERKANNT, Test bewusst NICHT gefahren (waere blind), ersetzt durch 3 echte ce-Ausgabepfade Bit-Gleichheit | - |
| delete_p99_ns existiert weiterhin 0-mal (serialize_abi_tier_trace_json exportiert fuer delete nur p50/p95) | REGRESSION | Z18965-18966 | OFFEN, bestaetigt D5-4 | - |
| Kreuz-Test super-Werkzeuge erst aussagefaehig nach Vendoring-Nachzug (98 Commits) | AUFGABE | Z18970-18971 | OFFEN | - |
| F1-DURCHSTICH-Zusage (GOAL v8, Fr 14.08.: CSV->persist->xlsx->anhang:forward->PDF) | FEATURE | Z18979-18986 | TRAEGT NICHT: Kette existiert als Werkzeugkasten, nicht verbunden | - |
| A1: Stage-Reihenfolge macht Durchstich strukturell unmoeglich (thesis-pdf laeuft VOR measure/persist) | REGRESSION | Z18988-19003 | OFFEN (Topologie-Problem, kein Skript-Bug) | .gitlab-ci.yml:25-38 |
| ergebnis:holen sitzt in Stage planer, noch vor measure/persist | REGRESSION | Z18999-19000 | OFFEN | - |
| A4: persist:measurements sammelt kein *.xlsx trotz Owner-KERN "xlsx ist die Ausgabe" | REGRESSION | Z19035-19036 | OFFEN (Sammler kennt nur *.csv/*.tex) | - |
| A4: anhang:forward hat keine needs-Kante zu persist:measurements | REGRESSION | Z19037-19038 | OFFEN (Formel persist->xlsx->anhang:forward beschreibt keine reale CI-Kante) | - |
| A4: ergebnis:holen Skelett mit auskommentierter Sammellogik, wird laut Plan erst 28.08. scharf | REGRESSION | Z19039-19041 | OFFEN, Terminwiderspruch (2 Wochen NACH Durchstich-Termin 14.08.) | - |
| Lokalstrecke als F1-Durchstich-Ersatz (5 Stufen: messen 1 Binary/1 Perm, persist_sammler.sh lokal, CSV->xlsx, anhang_forward_core.sh AF_NO_PUSH, PDF-Gate) | AUFGABE | Z19046-19055 | EMPFOHLEN/GEPLANT statt CI (CI-Nachzug folgt separat) | Strang 18 |
| OV-16 allow_failure am Mess-Batch behalten oder entfernen | AUFGABE | Z19057-19064 | OFFEN, WIDERSPRUCH: Wellenplan-OV-Tabelle "entfernen" vs GOAL v8 Teil IX bindend "behalten"; Frist 12.08. | Owner |
| OV-18 (neu) Wegewahl: genuegt Lokalbeweis mit CI-Nachzug fuer F1? | AUFGABE | Z19069-19072 | OFFEN, Empfehlung Lokalbeweis+CI-Nachzug(a); Frist 12.08. | Owner |
| Nenner-Divergenz "429->456" aufgeloest: doppelter Kategorienfehler (2 verschiedene Commits UND Baumzustaende) | REGRESSION | Z19076-19097 | BEHOBEN/AUFGELOEST (431-2 Platzhalter+27 gtest=456, per git archive reproduziert) | - |
| Test-Inventurzahlen prod1 nach Zustand (432 Configure / 457 make / 461 make inventar / 459 make check -LE pmc / 281 Quelltext-Reg. / 27 gtest) | UNKLAR | Z19099-19108 | STATUS-SNAPSHOT (Referenzzahlen, kein Einzelposten) | - |
| prod2-Simulation (prod2 nicht im Netz, rc=2), AVX-512 abgeschaltet auf prod1 simuliert (428/457) | AUFGABE | Z19110-19118 | ERSATZWEISE SIMULIERT, ausdruecklich als Simulation gekennzeichnet, nicht als Messung | - |
| Abnahmeformel: Vergleich nur gueltig bei gleichem Commit+Baumzustand+Host-Klasse, alle drei gehoeren in die Ausgabe | AUFGABE | Z19120-19128 | FESTGELEGT (Analyse-Konsequenz), Werkzeug existiert | scripts/ci_host_klassen_bericht.sh |
| RANGFOLGE-KORREKTUR: geltende Rangfolge ist OWNER > PLAN > THESIS (Stufe 3 nicht Stufe 1); erst Ausschluss pruefen, dann MERGEN bei mehr Gruendlichkeit; Thesis-Nachzug erlaubt | OWNER-ENTSCHEID | Z19131-19149 | FESTGELEGT (Korrektur einer fehlerhaften fruehen Rang-Anwendung) | - |
| D5-5-Begruendung "Thesis schlaegt Plan" zurueckgezogen, Ergebnis (HDR bleibt) bleibt aus 2 staerkeren Gruenden bestehen | OWNER-ENTSCHEID | Z19141-19149 | FESTGELEGT (Korrektur) | - |
| Explore-Pflicht vor jeder Design-/Bau-Phase je Welle+Strang (Owner 09.08.) | OWNER-ENTSCHEID | Z19152-19154 | FESTGELEGT | - |
| Strang 9 (D5-1) und Strang 10 (D2-G4/D5-3) gingen vor Explore-Pflicht-Ansage ohne Explore in Bau | REGRESSION | Z19154-19156 | GEPRUEFT via Strang 14, kein Ruecknahme-Fall | Strang 14 |
| Urteil Ruecknahme-Pruefung: kein Ruecknahme-Fall, echter Widerspruch liegt eine Ebene hoeher (Mechanismus statt Index-Formel), trifft ungebauten Posten | REGRESSION | Z19158-19162 | GEPRUEFT, KEINE RUECKNAHME NOETIG | Strang 14 |
| K1: Thesis sagt HDR im Praesens zu (3 Fundstellen), "entfernen"-Option fuer D5-5 ist rangwidrig | OWNER-ENTSCHEID | Z19164-19188 | THESIS GEWINNT: HDR bleibt, muss verdrahtet werden | - |
| latency_hdr_histogram.hpp: 0 Produktions-Konsumenten (nur test_ap8_hdr_histogram.cpp) | REGRESSION | Z19190-19192 | OFFEN, Thesis sagt "erhebt", Code erhebt nichts | - |
| D5-5 neu definiert: HDR verdrahten + Je-Lauf-Persistenz + 0-ns-Zaehler + Toleranz aus significant_figures=3 | AUFGABE | Z19194-19198 | NEU DEFINIERT (aus Rutschliste entfernt), 2h-Schaetzung hinfaellig, OFFEN | - |
| K3: D5-1 "alle vorher erhobenen p50/p95/p99 ungueltig" kollidiert mit Thesis-Anhang (alte Zahlen unmarkiert gueltig) | REGRESSION | Z19200-19210 | OFFEN, Textpflicht bis 15.09. (markieren oder neu erheben nicht festgelegt) | A_measurements.tex:46-49, bias_matrix_table.tex:2 |
| Thesis intern zweistimmig beim Median-Mechanismus (Hauptkapitel HDR, Anhang nearest-rank) | REGRESSION | Z19212-19214 | OFFEN, keine Quelle loest Binnendifferenz auf | - |
| Formel ceil(q*n)-1, Median-Regel "untere Mitte", Interpolations-Ausschluss sind NEU ohne aeltere Grundlage (4 Linsen bestaetigt) | OWNER-ENTSCHEID | Z19216-19225 | FESTGELEGT als NEU, darf nicht als "war schon immer so" gelten | - |
| "entfernen"-Option fuer D5-5 selbst ist neu (vor 08.08. nur "Text angleichen"/"nicht verdrahtet") | UNKLAR | Z19224-19225 | FESTSTELLUNG, dokumentiert | - |
| Nachpruefquote: von 22 markierten Konflikten hielten 10, fielen 11, blieb 1 unklar (3 Fehlalarme aus toten Thesis-Dateien) | UNKLAR | Z19227-19233 | STATISTIK-BEFUND | - |
| Eigener Memory-Fehler Owner-Textzahl: nicht ~40 sondern 472 Texte NUR ueber Pfad 2 sichtbar (Faktor-12-Korrektur) | REGRESSION | Z19235-19249 | BEHOBEN/KORRIGIERT | Strang 12 |
| Dritter Extraktionspfad entdeckt: queue-operation/enqueue nicht redundant, 49 distinkte Texte NUR dort | REGRESSION | Z19251-19254 | ERKANNT, Regel korrigiert (UNION aus 3 Zweigen statt 2) | - |
| Thesis-Bauverpflichtung: CSV exportiert kein p95 (LATENCY_P95 deklariert, nicht exportiert) | REGRESSION | Z19265-19266 | OFFEN | - |
| Thesis-Bauverpflichtung: Fairness-Protokollierung je Fremdbibliothek (Compiler/Flags/ISA-Pfad/Allokator/Commit-Hash) fehlt im Mess-Output vollstaendig | REGRESSION | Z19267-19268 | OFFEN | - |
| Thesis-Bauverpflichtung: Datensatz-Akte (Quelle/Pruefsumme/Seed-Regel je Datensatz), <datasets>-Bindung offen | AUFGABE | Z19269 | OFFEN | - |
| Thesis-Bauverpflichtung: Berichtsgroessen Mittel+Perzentile p50-p999, p999-Produzenten-Grenzen ungepinnt | REGRESSION | Z19270 | OFFEN | - |
| Hardware-Job-Pool = §62 MULTI-MASCHINEN-ARCHITEKTUR SYMMETRIE-PRINZIP, bereits seit 19.-22.07 festgelegt (Owner 21.07., Ledger:3851-3862) | OWNER-ENTSCHEID | Z19289-19302 | BESTAETIGT bereits FESTGELEGT (Begriff neu 09.08., Sache nicht) | - |
| Koordinationsdesign: gelocktes Bestandslog auf minio, Batch-Reservierung 4096 mit Zeitstempel, Gleichverteilungspflicht, First-come, Takeover ETA+50%, Schreib-Lock 1800s Obergrenze | FEATURE | Z19304-19309 | ENTWURF VOLLSTAENDIG, Scharfschaltung fehlt (s.u.) | - |
| AVX-Maximum-Mechanismus: -march=native verworfen (17.07.), Maximum per CEB-Achsen-Permutation (no_extension/avx2/avx512), Fehlerklasse HardwareErweiterungFehlt statt CI-Vorfilter | OWNER-ENTSCHEID | Z19310-19319 | ENTWURF VOLLSTAENDIG, bestaetigt | - |
| binary_id traegt SIMD nie (binary_id="never", 26.07.), Trennung ueber build_version+ext-Sidecar+SHA512-Fingerprint | OWNER-ENTSCHEID | Z19320-19326 | BESTAETIGT bestehend | - |
| Fingerprint-Format 3 unterscheidet ISA bereits ueber toolchain_stamp_glied; Kommentar bestandslog_document.hpp:22-26 veraltet | REGRESSION | Z19323-19326 | OFFEN (Kommentar-Korrektur noetig) | - |
| Lager-Koordination in Produktion AUS (COMDARE_BESTANDSLOG 0 von 2 aktiven .gitlab-ci.yml) | REGRESSION | Z19336-19339 | ADRESSIERT durch LAG-P1 (siehe oben Z18749ff) | - |
| LagerBaumWriter 0 Produktions-Aufrufer (Realm-Wurzeln zeigen nicht auf Mount, prod2 nicht belegt) | REGRESSION | Z19342-19343 | OFFEN, LAG-P3 adressiert (6h) | - |
| simd_build_gate scharf aber wirkungslos (alle 9 Organ-Klassen kRequiredNone, Maschinen-Deklaration leer, filtert 0 Compiles) | REGRESSION | Z19344-19346 | OFFEN | - |
| Vier Pakete Lager-Scharfschaltung: LAG-P1 6h, LAG-P2 8h, LAG-P3 Realm-Wurzeln+prod2-Mount 6h, LAG-P4 static_assert 2h | AUFGABE | Z19393-19396 | GEPLANT (P1/P2/P4 inzwischen gelandet lt. obigen Nachtraegen, P3 offen) | docs/sessions/20260809-EXPLORE-lagerhaltung-hardware-job-pool-avx-maximum.md |
| Eigener Zaehlfehler "44 von 48 Jobs floaten" falsch, Agenten-Gegenrechnung "42 von 48" auch falsch, korrekt 45 von 51 tag-tragenden Jobs | REGRESSION | Z19352-19365 | BEHOBEN/KORRIGIERT (Tabelle super 24/31, ce 21/24) | - |
| Ursache Zaehlfehler: Tags in Flow-Syntax, Block-Syntax-Parser liefert stille Null | REGRESSION | Z19367-19373 | ERKANNT als Lehre dokumentiert | - |
| prod2 Etikett-Widerspruch: machine_simd_signature.hpp:90 sagt i9-14900KS Raptor Lake, live gemessen i9-12900K Alder Lake | REGRESSION | Z19377-19387 | ERKANNT, Thesis korrekt "Alder Lake"; Etikett prod2_raptor_lake falsch; Byte-Ereignis, Vorschlag: dulden bis nach Abgabe | - |
| AVX-512 in golden-Bau-Matrix aufnehmen? (kippt zweifach deklariertes Owner-Wort "avx512 nicht universell, bleibt draussen") | AUFGABE | Z19399-19402 | OFFEN, bewusste Umkehr noetig, kein Nachziehen | experiment_golden_kern.xml:339 |
| Cross-Maschinen-SKIP fuer no_extension (gleicher Fingerprint auf prod1/prod2, prod2 koennte prod1-Binary per SKIP uebernehmen) | REGRESSION | Z19403-19406 | OFFEN, gewollt fuer Bau, heikel fuer Mess-Provenienz | - |
| W0b-7/D2-G5 Gegenorakel: scripts/ci_host_klassen_gegenorakel.sh (CMake selbst befragt statt Quelltext-Scan) | FEATURE | Z19411-19417 | GELANDET, Selbsttest 9 Faelle, Job test:host-klassen-bericht ohne allow_failure | - |
| Messung Praesenz-Klassen: avx512f->avx2 verlieren exakt 4 Tests (namentlich belegt), avx2->basis exakt 2, Gegenrichtungen leer, 429/425/423 je Klasse | FEATURE | Z19419-19430 | CI-BEWIESEN | - |
| --ctest-liste-Gegeneingang haengt an echten Listen (dreimal passend rc0, gekreuzt rc1 mit 2 Widerspruechen) | FEATURE | Z19432-19434 | CI-BEWIESEN | - |
| TDD-Protokoll Gegenorakel: T-1 rot zuerst, 3 gewuerfelte Koeder B1/B2/B3 gebissen, Fail-closed 3 Faelle rc2, T-7 3 Wegwerf-Mutationen rot | AUFGABE | Z19436-19444 | CI-BEWIESEN, Selbsttests 9/9 und 12/12 gruen | - |
| Schwester-Beleg ce-Sichtbarkeits-Wache belegt avx512f-Sprosse zweimaschinig (461 lokal/prod1 vs 457 CI-Runner ohne AVX-512) | FEATURE | Z19447-19450 | BESTAETIGT | ce 404ff6cf |
| SPANNUNG offen: Wellenplan OV-5 "prod2 existiert nicht" (DNS-Sicht) vs ce-Wache belegt CI-Lauf auf Runner ohne AVX-512 (Runner-Sicht) | UNKLAR | Z19451-19454 | OFFEN, notiert nicht entschieden; fuer D2-G5 seit heute irrelevant (Preset-Technik braucht keine 2. Maschine) | - |
| Plansatz-Zahl "428" ist Historie, deklarierter Stand 429 (avx512f-Klasse) | REGRESSION | Z19455-19457 | BEHOBEN, An-8 im Wellenplan nachgetragen | - |
| Offen aus 3b13bf4a-Landung: gitleaks lokal nicht installiert, Pipeline-Gruen-Verifikation durch GitLab-Auth-500 blockiert | AUFGABE | Z19459-19461 | OFFEN unveraendert (Batch-Schuld seit W0b-1/D3-3) | - |
| ce-Submodul-Arbeitsbaum steht auf a1d0c201 neben gitlink, Gegenorakel bricht fail-closed ab | REGRESSION | Z19462-19463 | OFFEN, wird in eigenem ce-Strang geheilt | - |
| "EIN BLECH"-Regel-Begruendung widerlegt: 2 bare-metal-Runner (id=16 prod1 AVX512, id=17 prod2 Intel), 44 von 48 Jobs floaten super+ce | REGRESSION | Z19464-19503 | BEFUND HAELT, spaetere DEUTUNG zurueckgezogen (siehe Richtigstellung unten) | - |
| Pipeline 15412 rot: test_ap5_simd_extension_coherence + test_buildvariant_dll_real im CI-Baum unsichtbar (lokal sichtbar) | REGRESSION | Z19466-19469 | URSACHE GEFUNDEN: CPU-Unterschied prod2 statt prod1 (Alder Lake ohne AVX-512), CI-BEWIESEN | - |
| Messkampagne gedeckt: measure:golden-320 + measure:smoke tragen echten Maschinen-Pin [prod,baremetal,amd] | FEATURE | Z19507-19513 | BESTAETIGT, kein Datenschaden moeglich | - |
| persist:measurements floatet (tags:[baremetal]), maschinenabhaengige Annahmen ungeprueft | AUFGABE | Z19515-19517 | OFFEN | - |
| RICHTIGSTELLUNG 09.08: Owner korrigiert Deutung -- "Floaten ist der Entwurf, nicht sein Fehlen", Koordination laeuft ueber Lagerhaltung/Bestand, nicht GitLab-Tags | OWNER-ENTSCHEID | Z19531-19560 | FESTGELEGT, 2 fruehere Lead-Aussagen zurueckgezogen | - |
| Echte Restaufgabe aus EIN-BLECH-Befund: (1) Wache-Nenner muss erhebende Maschine ausweisen, (2) Frage ob jede Maschine zum eigenen Maximum baut und Lager Ergebnisse unterscheidet (Strang 8) | AUFGABE | Z19562-19576 | OFFEN, wird geprueft (verbindet sich mit LAG-Z1-Ergebnis, siehe Z18404 oben) | Strang 8 |
| T-6: Hardware-Klasse hat 4 Mitglieder ueber ${_tgt}, Wache sieht/prueft nur die statisch aufloesbaren, faellt in "19 nicht statisch aufloesbar" | REGRESSION | Z19590-19595 | OFFEN, Luecke hat jetzt eine Zahl statt Schweigen | - |
| W-1/ST-CTestWache gelandet (12 Koeder, 17 Befunde, 6 Eigenfehler) | FEATURE | Z19598-19601 | GELANDET | ce 1f88cfec, 7dc372c7, 1a897c98 |
| enable_testing()-Heilung allein haette neuen Defekt eingebaut: comdare_tests baut test_commands/test_engine_adapters nicht (0 Kanten) | REGRESSION | Z19603-19616 | ERKANNT vor Landung, Fehlschlag als _NOT_BUILT-Platzhalter belegt (ctest -N=431) | - |
| CI nur zufaellig gedeckt (test:unit heute auf make umgestellt), build:clang waere betroffen gewesen | REGRESSION | Z19617-19621 | BEHOBEN per set_property GLOBAL APPEND COMDARE_TEST_TARGETS (ctest -N=456, clang uebersetzt beide TUs) | - |
| Wache ci_test_sichtbarkeit_wache war NICHT in CI verdrahtet (0 von 6 Wachen-Skript-Nennungen) | REGRESSION | Z19622-19630 | BEHOBEN, jetzt in test:coverage-guard, CI rc=0 belegt | - |
| SOLL-Scanner blind fuer mehrzeilige Schreibweise (3 registrierte Tests fehlten im SOLL) | REGRESSION | Z19634-19636 | BEHOBEN, SOLL 277->280 | - |
| IST-Erkennung faelschlich in beide Richtungen (gieriges sed griff letzten Schraegstrich jeder Zeile, 446 falsche Vergleichs-Tokens) | REGRESSION | Z19637-19641 | BEHOBEN (Teil der W-1-Landung) | - |
| Tabulator-Loch in Allowlist-Pruefung (cut -d' ' -f2- liess Tabulator-Zeile als begruendet durchgehen) | REGRESSION | Z19642-19645 | BEHOBEN (Teil der W-1-Landung) | - |
| 19 Registrierungen tragen Namen in CMake-Variable, statisch nicht aufloesbar (braucht cmake --trace als SOLL-Quelle) | REGRESSION | Z19646-19649 | TEILWEISE: nicht heilbar per Regex, jetzt als eigene Zahl ausgewiesen statt Schweigen | - |
| Sechs Eigenfehler des Abnahme-Agenten (falscher grep-Gegenstand, Zeitrichtung reconfigurierter Baum, run_in_background/nohup Exit-Code, until-pgrep wartet auf sich selbst, pkill -f eigene Shell, "429->456" Sprung ueber 2 Grundgesamtheiten) | REGRESSION | Z19651-19664 | SELBST GEMELDET und dokumentiert | - |
| gitleaks erkennt zufaellig erzeugtes AWS-Schluesselpaar NICHT (Projekt-Config und Default, beide rc=0) | REGRESSION | Z19667-19670 | ERKANNT, als Falle dokumentiert (Biss nur mit Private-Key-Block belegt) | reference_fallen_20260808 |
| Codex aus Workflow-Subagenten nicht erreichbar (Kritiker-Stufe 0 Beweismaterial, Top-Level-Kontext normal) | REGRESSION | Z19672-19676 | ERKANNT, Folge: Lead ruft Codex selbst, uebergibt Ausgabe an Fable-Meta-Reviewer | - |
| Review-Verdikt W-1: Wache prueft weder Frische noch Zugehoerigkeit ihrer IST-Quelle (stale Baum -> stale Inventar unbemerkt) | REGRESSION | Z19682-19686 | OFFEN | - |
| super-Schwesterstelle derselben W-1-Konstellation existiert latent (heute ungefaehrlich) | REGRESSION | Z19687-19689 | OFFEN/BEOBACHTET | - |
| A1 Doktrin ueberholt: 06.08.-Stand "Fable faellt komplett aus" gilt seit 08.08. nicht mehr | OWNER-ENTSCHEID | Z19691-19714 | FESTGELEGT/ERSETZT | - |
| Modell-Matrix aktuell: Lead/Bau=Opus5max (+Fable5xhigh nachsetzen bei Bau), Explore=Sonnet5max thorough, Design=Fable5xhigh/max, Review-Meta=Fable5xhigh ueber Codex-Pass, Schwer-Impl=Codex | OWNER-ENTSCHEID | Z19716-19725 | FESTGELEGT | - |
| A1-Eintrag komplett geloescht statt als UEBERHOLT markiert (Ausnahme von Doktrin-Pflegeregel 3) | OWNER-ENTSCHEID | Z19727-19736 | FESTGELEGT (Ausnahme ausdruecklich autorisiert) | - |
| Regel: datierte woertliche Owner-Zitate im Regelteil brauchen Gueltigkeitsvermerk, nicht nur Entstehungsdatum | OWNER-ENTSCHEID | Z19738-19743 | FESTGELEGT | - |
| Top-Level-Agent-Werkzeug kennt kein effort-Feld, Effort-Vorgaben nur ueber Workflow-Werkzeug moeglich | UNKLAR | Z19745-19748 | BESTAETIGT weiterhin gueltige Einschraenkung | - |
| Vier Landungen 08.08 abends: ce XML-Wohlgeformtheit+Wache, super XML+Gitlink+gefallene Ausnahme, D3 leeres Messfenster, D4 Drift-Gate bei Median 0 | FEATURE | Z19756-19765 | GELANDET, alle mit Bissbeweis; beide Phase-6-Blocker gefallen | ce 25fe4fbf, super 4a9d3d02, super ce7d4007, ce 5922bb99 |
| D1 (Blocker "check:all ohne Configure") IST EIN FEHLBEFUND | REGRESSION | Z19767-19803 | AUFGELOEST/WIDERLEGT: Makefile:91 sagt check:inventar MIT Reconfigure, 427/431-Unterschied existiert real nicht (beide 429); Ursache: historischer 06.08.-Kommentar als Ist-Zustand gelesen | - |
| D2 (Blocker adhoc_emitter) IST ECHT: kein ce-Job baut comdare_adhoc_emitter_cli, 2 Tests fehlen in Inventur | REGRESSION | Z19805-19816 | BESTAETIGT UND OFFEN | test_v41_anatomy_adhoc_autobuilt_load, f15_compare_cli_smoke |
| Zwischenstand fuenf Blocker: D3 erledigt, D4 erledigt, D1 existiert nicht, D2 bestaetigt+offen, D5 offen | UNKLAR | Z19817 | STATUS-SNAPSHOT | - |
| GO-0 BLANKO-GO fuer alle Phasen autonom, bis kritische Rueckfrage, wirklich ALLE am Stueck | OWNER-ENTSCHEID | Z19825-19834 | FESTGELEGT | - |
| GO-1 Messlauf wird durchgefuehrt, NICHT mehrtaegig (Praemisse war Lead-Schaetzung); --check-size ist Vorbedingung der Messplanung | OWNER-ENTSCHEID | Z19836-19849 | FESTGELEGT | - |
| Messlauf-Durchfuehrung erst nach D3+D4 (leeres Fenster als Erfolg + degenerierte Messung als stabil verhindern) | AUFGABE | Z19850-19853 | VORBEDINGUNG ERFUELLT (D3/D4 oben gelandet) | - |
| GO-2 Deploy Key nur im privaten CI-Template, nicht public sichtbar, Keys im cred vault | OWNER-ENTSCHEID | Z19855-19865 | FESTGELEGT | - |
| GO-3 HYBRID ist Pflicht (auch bei 0% gebaut, 5 Freitage Rest) und ist eine GATTUNG (HEURISTIK-ADAPTER, Genus Function-Interface-Reroute) | OWNER-ENTSCHEID | Z19867-19883 | FESTGELEGT, vollstaendige Architektur-Spezifikation gegeben | - |
| Hybrid-Macro-Benchmarking: 3 Mess-Ebenen -> 4 im Hybrid-Fall (dazwischengequetscht), Overhead am Hybrid-Pruefdock gemessen | OWNER-ENTSCHEID | Z19876-19887 | FESTGELEGT (Design), 5. Mess-Ebene bleibt separat unbelegt | - |
| Verschraenkung: Gattungen rufen andere Gattungen auf (SearchAlgorithm->Container), Heuristik-Hybrid-Achse wirkt auf BAUPLAN nicht nur Bauinhalt | OWNER-ENTSCHEID | Z19889-19899 | FESTGELEGT, muss bei --check-size mitgerechnet werden | - |
| R-1 (07.08.-Owner-Entscheid) Generator dreht Thesis-Korrektur zurueck | REGRESSION | Z19914 | ERLEDIGT (3 Drifts gefunden statt 1) | super 6d837e7d |
| R-2 cpe-Grammatik (drei Teilfragen) | AUFGABE | Z19915 | GEGENSTANDSLOS, abgeloest durch Flag-Grammatik v2 | Ledger:10662 |
| R-3 xlsx-Blattform | OWNER-ENTSCHEID | Z19916 | ERLEDIGT (heute vom Owner entschieden) | - |
| G-6 Dual-Review-Pflicht gilt sie weiter | OWNER-ENTSCHEID | Z19917 | BEANTWORTET: Doktrin v3.1 fuehrt Landungsklassen ein (Code/Skript/CMake/CI=2 Lenses, Soll-Design=1 Lens, Doku=keiner, Gitlink-Bump=2 Gates) | - |
| G-7 cpe im Ledger widerspruechlich | REGRESSION | Z19918 | ERLEDIGT, additiv korrigiert | - |
| Weiterhin offen: G-1 (6 STOPP-Gate-Entscheide E-A-E-F), G-2 (T19 persistence_target Min/Max), G-3 (4 Entscheide Welle C Pareto), G-4 (5 Entscheide Welle D Cluster), G-5 (RunMethodology-Enum-Reihenfolge) | AUFGABE | Z19922-19927 | OFFEN, G-5 bleibt bewusst beim Owner (Stempel-/ABI-Ereignis, teurer Umbau ohne Defekt) | - |
| Meta-Befund: veraltete "offen"-Liste (5 von 10 laengst erledigt) kostet dieselbe Aufmerksamkeit wie echte Posten | REGRESSION | Z19929-19938 | ERKANNT als Prozess-Lehre (Schwester des Paragraph75-Befunds) | - |
| build:clang lief in ce NIE (COMDARE_CLANG_MATRIX nirgends in ce gesetzt, nur in super) | REGRESSION | Z19941-19953 | BEHOBEN, seit Pipeline 15357 laeuft er (22 statt 21 Jobs) | ce 274e4ed2 |
| resource_group gegen OOM-Kill blockierte 3 Pipelines (waiting_for_resource) | REGRESSION | Z19963-19975 | ZURUECKGENOMMEN | ce 75ff9f89 |
| Eigener Deutungsfehler: "resource_group wirkt, kein Stau" war falsche Lesart (Zustand gesehen statt gemessen) | REGRESSION | Z19977-19980 | ERKANNT/dokumentiert (V11-Figur: Eindruck statt Zahl) | - |
| Alle 7 Nachtraege des Tages per cat >> ans Dateiende gehaengt statt B.3-Regel (rueckwaerts, neueste oben) | REGRESSION | Z19991-19994 | BEHOBEN, scripts/ledger_nachtrag.sh bestimmt Einfuegepunkt automatisch, 2 Koeder rc=2 belegt | - |
| Neun weitere Doktrin-Luecken (u.a. L1 Owner-Sequenz nicht im Dokument, L2 Gedaechtnis-Lesen-Delegation) | AUFGABE | Z20005-20007 | OFFEN, Owner-Freigabe noetig | - |
| DoD Definition of Done GOAL (6 Punkte: Spur-S-ABI-Kette, 8 Blocker, 4 Projekte CI-gruen, FF3-Mess-Kette echt, #193 Handbedienbarkeit, Mess-Ergebnis-Persistenz) | FEATURE | Z20019-20035 | GOAL-DEFINITION autoritativ (Referenz /goal), Teilerfuellung siehe Folgeposten | §0 GOAL/MISSION |
| DoD-4 FF3: golden-320-Voll-Messlauf #9916 als Systembeweis behauptet | REGRESSION | Z20056-20059 | GESTRICHEN/UEBERHOLT per SUPERSEDED-Vermerk 2026-07-19: #9916 nie persistiert, golden-320 KEIN Systembeweis; Ersatz new-golden N=131072, Voll-Lauf #46 (Roadmap M-1) | §33 |
| DoD-6 Mess->PDF-Persistenz (persist:measurements merge-basiert, Write-Token id=54) | FEATURE | Z20060-20062 | GELANDET/SCHARF (Stand 26.07), end-to-end validiert, 2 kritische Bugs gefunden+gefixt | - |
| CI-interaktive Diplomarbeit #24: Increment1 (08_appendix_generator C++23 statt .ps1) + P6 Log-Heatmaps + P4 Segment-Attribution | FEATURE | Z20063-20066 | CI-GRUEN/VERIFIZIERT | - |
| CI-interaktive Diplomarbeit Rest: Writer P3/P2/P5, Inc-2-Pipeline-Verdrahtung, #25 format_tex.py/codegen.sh->C++23 | AUFGABE | Z20063-20066 | OFFEN | - |
| Genuin gated Posten #3/#5/#8/#9 (extern/design/GO), #11 (durch #9916 entsperrt), #17-Vollendung | AUFGABE | Z20067-20068 | GATED/OFFEN (autonom nicht loesbar) | - |
| GOAL V7 (26.07 konsolidiert) loest V6 ab, V6/V5/V4 als Historie erhalten | OWNER-ENTSCHEID | Z20072-20074 | FESTGELEGT, V7 ist DELTA nicht Aufhebung | - |
| V7.1 IST-ANKER: ABI-Major 7, Observer-POD sizeof 1344 (V8), CSV 169 Spalten, 18 Organ-Achsen, golden=new-golden N=131072 CRC64 0x56F1B721C72DC10E, golden-320 NUR Byte-Wache; Lager-Gate KOMPLETT gebaut+gepusht | FEATURE | Z20076 | Stand 26.07 GELANDET | - |
| V7.2 Achsen-Architektur: 3 Achsen-Typen (Mess->Planer, System->CEB, Organ->Tier); System-Haupt-Achsen target_isa/operating_system(NEU)/external_utils(Rename) | OWNER-ENTSCHEID | Z20078-20080 | FESTGELEGT (spaeter praezisiert) | - |
| Hub-Zuordnung load_framework SUPERSEDED (Stand 26.07 abends -> §69.1/R-G): load_framework=Meta-Meta-Haupt-Achse der MESS-Achsen (Planer-Stufe), NICHT unter external_utils | REGRESSION | Z20081 | UEBERHOLT/KORRIGIERT | - |
| opt permutiert O0-O3 x simd{no_extension,avx2,avx512}=12 System-Perms, avx512 nur wo Maschine freigibt, Ofast bleibt AUS | OWNER-ENTSCHEID | Z20083 | FESTGELEGT | - |
| std::variant nur in CEB geduldet, in ALLEN Tier-Binary-Typen verboten | OWNER-ENTSCHEID | Z20085 | FESTGELEGT (spaeter praezisiert, s.u.) | - |
| std::variant-Verbot PRAEZISIERT (Stand 02.08 -> Owner-E1): Scope=PLAIN Tier-Binaries; HYBRID-Tier-Binary eigene Stufe hinter CEB, EINE Ausnahme (variant nur als Dock-Typ-Traeger via Abstract-Factory) | OWNER-ENTSCHEID | Z20086 | FESTGELEGT/PRAEZISIERT, E-11-Regelkonflikt AUFGELOEST (2 Geltungsbereiche statt Konflikt) | - |
| LEDGER:187(e) Framing "Hybrid=eigene Systemachse" superseded durch Stufen-Modell, Rest-Klaerung Q6 | REGRESSION | Z20087 | UEBERHOLT, Rest als Owner-Frage Q6 OFFEN | - |
| V7.3 STRUKT-R-Kernwelle (ORG-18 persistence_target, B-16/B-17, planer_block, MODE COMPARE, Bestandslog-Lanes) | FEATURE | Z20090 | GELANDET, 314/314 Manager-verifiziert | - |
| Vorgaenger-Auftrag lane-a-sys-tax-lane-c-hub SUPERSEDED (3 Fehler+5 Blocker) | REGRESSION | Z20090 | UEBERHOLT/GEHEILT durch Bauplan v3 | - |
| Fehlerklassen-Nachtrag V7.3: 3 Opus-Achsen-Fehler (load_framework faelschlich 4. Haupt-Achse, NUMA/page_type faelschlich reine RT-Unter-Achse, AVX512 aus Permutationsmatrix vergessen) | REGRESSION | Z20092 | BEHOBEN, Bauplan v3 verdiktet PLAN BAUFAEHIG | - |
| V7.4 Gate-Reihenfolge bis Voll-Bau-4+Abgabe (Lane A/C/F -> W-13 -> 4+1 Beweise -> G6 -> Voll-Bau-4-Trigger -> 320er-Abgabemessung -> S7 Hybrid -> G8 -> S8 PDF); Frist Mo 27.07 ZWISCHEN-Abgabe | OWNER-ENTSCHEID | Z20094-20095 | HISTORISCH GEPLANT (spaeter durch neuere GOAL-Versionen fortgeschrieben, siehe Memory GOAL v8) | - |
| V7.6 SICHTBARE-TODO-DOKTRIN E-21 (TODO-Stack-Form, Rueckfragen verbose, Vollpersistenz aller Owner-Nachrichten je Kontext) | OWNER-ENTSCHEID | Z20099 | FESTGELEGT/PFLICHT seit Owner-R7 02.08. | - |
| GOAL V6 (2026-07-17) | OWNER-ENTSCHEID | Z20120-20122 | GESTRICHEN/UEBERHOLT durch V7 (26.07.), Inhalt teils bindend fortgeschrieben | §0-GOAL-V6 |
| Bau-INC-0 DLL-Load Option B (link_libs-Kanal, loest §17.E measured=0, entsperrt Mess-Lauf) | FEATURE | Z20130 | HISTORISCH GEPLANT, inzwischen durch spaetere ABI-Stufen (bis ABI-7) UEBERHOLT/erledigt | - |
| Bau-INC-1 CEB-System-Achsen-Schichtung (4 Systemachsen als Schicht ueber 19 Organ-Achsen) | FEATURE | Z20131 | HISTORISCH GEPLANT, UEBERHOLT durch spaeteren Stand (18 Organ-Achsen bei ABI-7) | - |
| Bau-INC-2 DER EINE koordinierte 4->5-ABI-Bump am Experiment-Planer-Dock (=DoD-1) | FEATURE | Z20132-20135 | GESTRICHEN/UEBERHOLT: SUPERSEDED 19.07. (real ZWEI Bumps INC-2c 4->5 + INC-2d 5->6), weiterer Vermerk 26.07. (aktuell ABI-7, 18 Organ-Achsen) | - |
| TABU-Praezisierung V6.5 (permutation_axes.xml hart-TABU dauerhaft; GO-bedingtes Aenderungsfenster nur im koordinierten Bau-INC-2 fuer POD-1416/kV3AxisSchema/GenusBindingTraits) | OWNER-ENTSCHEID | Z20143-20144 | FESTGELEGT (damals), seither mehrfach fortgeschrieben | - |
| TABU ABI-MAJOR==4 | OWNER-ENTSCHEID | Z20145-20147 | GESTRICHEN/UEBERHOLT: Kette 4->5->6 gelandet (POD 1272/17 Achsen), dann weiter bis ABI-7/1344/18 Achsen (26.07.) | - |
| Deadline-Anker V6.6: Mess-Lauf muss VOR 28.07.2026 starten | OWNER-ENTSCHEID | Z20149 | HISTORISCH (Termin laengst verstrichen bei aktuellem Ledger-Stand) | - |
| Verifikations-Kadenz V6.7 (golden-Roundtrip==320 + cf22 + Mojibake==0 + Remotes ref-gleich + CI, super-Sub-Build PFLICHT) | OWNER-ENTSCHEID | Z20151 | TEILWEISE UEBERHOLT: golden-Roundtrip==320 seit §33 kein Systembeweis mehr (SUPERSEDED 19.07.) | - |
| V6.8 Widerspruchs-Aufloesungstabelle V5->V6 (8 Posten, additiv) | UNKLAR | Z20155-20167 | HISTORISCH dokumentiert | - |
| §0-GOAL-MATRIX (26.07., additiv): Diplom-Ziel und Comdare-Matrix-Ziel gelten PARALLEL, duerfen sich nie still verlieren | OWNER-ENTSCHEID | Z20169-20171 | FESTGELEGT | - |
| Matrix-Ziel 3 Dimensionen (Familien x Baseline-Stufen x Module), Invarianten INV-1..4 | OWNER-ENTSCHEID | Z20174-20175 | FESTGELEGT | - |
| Taxonomie-Anker (Owner 07.07.): comdare-cache-engine=Framework-MODUL, Diplomarbeit=dessen PRODUCT | OWNER-ENTSCHEID | Z20177 | FESTGELEGT | - |
| LAYER<->REPO-AUFLOESUNG (Owner 26.07., loest W2/E-13): jede Diplomarbeits-Schicht hat GENAU ZWEI Adressen (Modul-Zelle + Product-Zelle) | OWNER-ENTSCHEID | Z20178 | FESTGELEGT | - |
| comdare-cacheengine-all verletzt INV-1 (keine baseline_N, keine Root-CMakeLists); comdare-*-product fuer Diplomarbeit existiert noch nicht | REGRESSION | Z20180 | OFFEN (Stand 26.07.) | - |
| GOAL V5 (2026-07-15) | OWNER-ENTSCHEID | Z20187-20231 | GESTRICHEN/UEBERHOLT durch V6 (17.07.), additiv als Historie erhalten | §0-GOAL-V5 |
| Scheduling Task-Nummer #36 vs #37 uneindeutig | REGRESSION | Z20191 | BEHOBEN/AUFGELOEST 16.07. (Ledger eindeutig: #37=Scheduling TABU-GO, #36=Bit-Bank-Tilgung DONE, is_original=#38) | ce ebcc5498 |
| DoD-7 XML-Experiment-Architektur als Abnahme-Kriterium (User-Bestaetigung ausstehend) | OWNER-ENTSCHEID | Z20191, 20195 | ENTSCHIEDEN (E9, User 16.07.): JA, je Experiment | - |
| TABU V5.8: Scheduling-27.-Achse als EINZIGE GO-Ausnahme vom ABI-4-TABU (MAJOR-Increment, Design VOR jeder golden/ABI-Aenderung) | OWNER-ENTSCHEID | Z20215 | FESTGELEGT (historisch, spaeter in Bau-INC-2 aufgegangen) | - |
| permutation_axes.xml E12: Legacy-11-Achsen-Katalog, NICHT redundant zur ce-Registry, bleibt TABU-read-only | OWNER-ENTSCHEID | Z20215 | ENTSCHIEDEN (User 16.07. "Ja bitte zieh das nach") | - |
| GOAL V4 (2026-07-12) G-Stack G1-G8 (CI-Gruen/Sync, Mess-Integritaet, Korrektheit, Aufraeum, Migration, Messlauf, gated, Abgabe-Blocker) | OWNER-ENTSCHEID | Z20235-20260 | GESTRICHEN/UEBERHOLT durch V5-G-Stack, dann V6-Bau-INC, dann V7-Lane-Modell; additiv als Historie erhalten | §0-GOAL-V4 |
| G2 Mess-Integritaets-Funde (sota_catalog.hpp:159 Stufe-2 ignoriert lebewesen, measurement_writer.hpp:102 fabrizierte Zyklen, .gitlab-ci.yml:617 synthetische CSVs committet, hartkodierte H1/H2/H3 immer validated) | REGRESSION | Z20245 | HISTORISCH (V4-Review-Fund), Nachverfolgung in diesem Segment nicht bestaetigt | - |
| G3 40 major Correctness-Findings (abi_adapter.hpp:390 Alloc-Null, cpuid_probe.hpp:103 AVX-512 SIGILL-Risiko, axis_filter_cuckoo.hpp:67 False-Negatives, rcu.hpp:61/66 Grace-Period-Race, SIMDOps.hpp:180 avx2 uninit/Carry, prt-art array_65535.hpp:21 Off-by-one, abi_adapter.hpp:588/896 uint16-Narrow-Cast-Trunkierung) | REGRESSION | Z20247 | HISTORISCH (V4-Review-Funde), Nachverfolgung in diesem Segment nicht bestaetigt | - |
| G4 Aufraeum (66 dead-code+44 cleanup, ~9.1GB gitignorte build-Trees mit getrackter tier150_measurements.csv, doc-drift 114, Infra-Exposition socks5-README mit ZIH-Login-Pfaden) | AUFGABE | Z20249 | HISTORISCH V4, je-GO-Loeschung vorgesehen | - |
| G5 comdare-measurement-all-Migration #274 (5a Extraktion seit 07.07. vergessen, 5b Struktur) | AUFGABE | Z20251 | HISTORISCH, Design-Fork an User (spaeter G5 laut V6.2 ans Projektende verschoben) | - |
| G8 Abgabe-Blocker: Anhaenge B+E trotz "DONE"-Vermerk nur 4-Zeilen-Stubs im Thesis-Working-Tree, gebauter PDF hat LEERE Anhaenge B (Code-Struktur) + E (12 ADRs) | REGRESSION | Z20257 | HISTORISCH V4-Fund (User-GO ausstehend zum Zeitpunkt), spaeterer Stand in diesem Segment nicht bestaetigt | - |
| G-INFRA CRC64-Platzhalter (binary_blob_writer.hpp:50 schreibt u32-Null statt echte CRC64, Format-Drift Layout-Doku 4B vs 8B) | REGRESSION | Z20259 | HISTORISCH, kein Blocker (test_infra) | - |
| Forgotten-TODO-Sweep 12.07.: 8 Modalitaeten x 40 Kandidaten, nur 4 genuin vergessen (36 widerlegt) | UNKLAR | Z20261 | STATUS-SNAPSHOT (Restprojekt lueckenlos getrackt) | - |
| 6 Architektur-Synthese-Muster A-F (Anti-Phantom, noexcept-Alloc-Haertung, Null-Consumer-Trap, Super-Sub-Build-Pfad-Divergenz, Doku-Drift-Epidemie 114, Test-Registrierungsluecken 26) | REGRESSION | Z20263 | HISTORISCH kategorisiert, auf G2-G4/G7 gemappt | - |
| Zwei User-Gates 13.07.: 40-major-Abschluss-Gate (ce28/super7/prt-art3/thesis2), #274 metrics-Transfer G5a | OWNER-ENTSCHEID | Z20267 | FESTGELEGT (historisch) | - |
| FF0 Multi-Plattform-Generalitaet (#163, #189, AP-13/#247) | AUFGABE | Z20282 | OFFEN, OWNER-Aussage fehlt explizit (nur implizit gated) | - |
| FF1 Cache-Line/Layout-Hebel (#164,#167,#160) | FEATURE | Z20283 | Teilaufgaben DONE, reale Messung #156 als Abgabe-Blocker offen | - |
| FF2 Permutations-Architektur traegt (#188 S1-S9, #250 done, #217, CMD-1/2) | FEATURE | Z20284 | Spur S gruen als Abgabe-Blocker | - |
| FF3 SOTA-Konkurrenzfaehigkeit (AP-2/#236 HART blockt #162/#156) | FEATURE | Z20285 | AP-2/#236 DONE per W4 (Nachzug 16.07.), Rest-Blocker #162/#156 | - |
| FF4 Reproduzierbarkeit/Provenance (AP-9/#243, #139 done, quality_flag #165) | FEATURE | Z20286 | AP-1/AP-9+Mess-Manifest als Abgabe-Blocker offen | - |
| B1 #193 manuelle Bedienbarkeit fehlt vollstaendig im Plan (Widerspruch TOP-PRIO vs [E0]-ZULETZT) | REGRESSION | Z20291 | HISTORISCH OFFEN, als Welle P-0 aufgenommen; Widerspruch spaeter aufgeloest (§10) | - |
| B2 .test-Vorlage fehlte in ci-templates | REGRESSION | Z20292 | ERLEDIGT | 5e46040 |
| B3 2-Pass-Codegen PFLICHT nicht optional (sonst Schein-Gruen R5.I/F15/F.5 SKIPPED) | REGRESSION | Z20293 | HISTORISCH OFFEN | - |
| B4 kein ABI-Bump-Budget -> mehrere ungeplante Bumps+320-Rebuilds | REGRESSION | Z20294 | HISTORISCH OFFEN, ABI-Freeze §4 als Exit-Kriterium | - |
| B5 algorithm_profiles-Kurzpfade zeigen auf leeren Decoy-Spiegel (cache_engine/ vs libs/cache_engine/) | REGRESSION | Z20295 | HISTORISCH OFFEN | - |
| B6 P-A nicht disjunkt (AP-3/AP-13 teilen platform/, AP-2/AP-8 teilen execution_result.hpp) | REGRESSION | Z20296 | HISTORISCH OFFEN | - |
| B7 #216-H2 muss vor Spur-P-Fan-out gepusht sein | REGRESSION | Z20297 | ERLEDIGT | 919db6c, 20e24ff |
| B8 AP-2/#236 mess-validitaets-kritisch, blockt #162/#156 | REGRESSION | Z20298 | GESTRICHEN/UEBERHOLT: AP-2-neu DONE per W4 (Nachzug 16.07.), Definition durch Katalog-Pfad-Gate ersetzt | - |
| S1 #216-H2 tier_reset_statistics() daten-erhaltend nach Load (ABI 3->4) | FEATURE | Z20303 | DONE, Pipeline verifiziert | 20e24ff |
| S2 #217-2a Container-Kapazitaets-Constraint | FEATURE | Z20304 | DONE (3/3 Tests, ABI-neutral), 2b deferred | d28108f6 |
| S3 AP-7/#241 SwissTable S22 | FEATURE | Z20305 | AP-7a DONE (2/2 Tests), AP-7b deferred | 75071224 |
| S4 #221 RC/DynamicVariableNode (RC-apply Vertrags-Freeze zuerst) | AUFGABE | Z20306 | HISTORISCH IN_PROGRESS | - |
| S5 CMD-1/#251 Limitations-Interface/Mess-Visitor | AUFGABE | Z20307 | HISTORISCH OFFEN HOCH, Re-Root-Plan VERWORFEN (ABI-neutral) | - |
| S6 CMD-2/#252 ContainerObserver real (EINZIGER Bump-Kandidat 4->5) | AUFGABE | Z20308 | HISTORISCH OFFEN HOCH | - |
| S7 #234 Node-Shape-Achse+nativer Pool-Store+observe-Hooks | AUFGABE | Z20309 | HISTORISCH IN_PROGRESS | - |
| S8 #215 CoW real fuer die 320 (DER EINE 320-DLL-Neubau) | AUFGABE | Z20310 | HISTORISCH OFFEN | - |
| S9 #224 GoF-Etiketten-Hygiene ZULETZT | AUFGABE | Z20311 | HISTORISCH OFFEN | - |
| Aktueller ABI-Major 4 (3->4 committet #216-H2) | UNKLAR | Z20314 | GESTRICHEN/UEBERHOLT: SUPERSEDED 19.07., Host-Major real 6 nach INC-2c(4->5)+INC-2d(5->6) | - |
| Erlaubter naechster Bump GENAU EIN 4->5 (Kandidat CMD-2/#252) | OWNER-ENTSCHEID | Z20316 | HISTORISCH; real wurden es zwei koordinierte Bumps | - |
| P-0 #193 TOP-PRIO (EXPERIMENT_MODE-Preset, ExperimentDriver-Fix, MANUAL_RUN.md) | AUFGABE | Z20322 | HISTORISCH GEPLANT | - |
| Hartes Gate AP-2/#236 (echter PRT-ART-Pfad, 90ns-Stub raus) | REGRESSION | Z20323 | GESTRICHEN/UEBERHOLT: ersetzt durch Katalog-Pfad-Gate (Nachzug 16.07.), AP-2-neu DONE | - |
| Welle P-A (AP-3/#237 Single-Owner platform/, AP-8-Vendoring POD->S6) | AUFGABE | Z20324 | HISTORISCH GEPLANT | - |
| Welle P-B (AP-6/#240 SOTA+Allokator-XML, AP-10/#244 Datensatz-Akten, AP-11/#245) | AUFGABE | Z20325 | HISTORISCH GEPLANT | - |
| #156 M3-Gesamtlauf Gate-Grund korrigiert (nicht PMC-Mangel, sondern Zeitfenster+MinIO-500-Fix+gruene Pipeline+prod2-I/O #207) | REGRESSION | Z20330 | KORRIGIERT (Gate-Grund-Fehldiagnose behoben) | - |
| CI-1 .test-Vorlage nach development | FEATURE | Z20336 | ERLEDIGT | 5e46040 |
| CI-2 Sammel-Target comdare_tests via GLOBAL-Property-Registry | AUFGABE | Z20337 | HISTORISCH OFFEN | - |
| CI-3 cache-engine-Job MUSS 2-Pass (configure->build codegen-cli->RE-configure->build tests->ctest) | AUFGABE | Z20338 | HISTORISCH OFFEN | - |
| CI-4 prt-art array_256.hpp real implementieren+alle 12 lokal | AUFGABE | Z20339 | HISTORISCH OFFEN | - |
| CI-5 -j/RAM-Politik je Runner-Tag vor Hard-Gate | AUFGABE | Z20340 | Probelauf offen | super test:unit b37d702 |
| CI-6 neue Test-Stage zuerst allow_failure/when:manual | AUFGABE | Z20341 | LAUFENDE Prozess-Regel | - |
| Infra-Handoff gated Posten (#189,#199,#200,#201,#202,#204,#205,#207,#208,#209,#210,#231) | AUFGABE | Z20344 | GATED (read-only-verify, Infra-Rolle) | - |
| User-gated Posten (#225 Second-Execution-Grundsatz, #25 Diplomarbeit-Text, #24 Cluster-Tasks extern) | AUFGABE | Z20345 | GATED (User) | - |
| Messgebunden gated Posten (#156,#152,#163,#162,#187,#165,#226) | AUFGABE | Z20346-20347 | GATED (Messung) | - |
| Explizit-deferred (#125 lazy-DLL Content-Hash, #10 V42-Infra+Nicht-SA-Gattungs-Docks, #149 MP-E/#229) | AUFGABE | Z20347 | DEFERRED | - |
| C2 Grace-Hopper/GH200-Messkampagne (Miet-Antrag erneut gestellt) | AUFGABE | Z20348 | GATED extern, Entsperr-Bedingung=Zusage/Zugang | - |
| Metaprogrammierungs-/Interface-Doktrin comdare-Matrix (User 06.07.): Template-Metaprog intern erlaubt, an Produkt-Interfaces VERBOTEN | OWNER-ENTSCHEID | Z20351 | FESTGELEGT | - |
| Praezisierung: Product-Matrix ist Instanziierungs-Schicht (User 06.07.) | OWNER-ENTSCHEID | Z20351 | FESTGELEGT | - |
| Erweiterung: Research=early Products, gilt fuer Diplomarbeit (Tier-DLLs sind binary End-Interfaces der Research-Matrix) | OWNER-ENTSCHEID | Z20351 | FESTGELEGT, superseded GOALV2-Teil-4-Ableitung | - |
| Worktree-Lektion (persistenter Pfad, Codex committet im Branch, NIE worktree remove --force auf uncommitted, NIE git add -A) | OWNER-ENTSCHEID | Z20355 | FESTGELEGT als Regel | - |
| Widerspruch #193=TOP-PRIO vs [E0]-ZULETZT | REGRESSION | Z20359 | AUFGELOEST (#193=Welle P-0, [E0]=Audit-Ebene nicht Reihenfolge) | - |
| E0-E4-Rehabilitierung: vierstufige Experiment-Maschinerie (E4=XML-Definition+Auswertung, E3=Permutations-B+-Baum, E2=Tier-Binaries compile-time, E1=RC-Laufzeit, E0=Querschnitt) | OWNER-ENTSCHEID | Z20365-20377 | FESTGELEGT, additiv rehabilitiert (GENEHMIGT 09.07.) | - |
| E4 Produktions-Track #229: NUR EIN Anwendungsprogramm messung_driver, ausschliesslich XML-orchestriert, Behelfsprogramme geloescht | OWNER-ENTSCHEID | Z20367 | FESTGELEGT (User-Produktionsanspruch) | - |
| P0-P3/G1-G5 XML-Suffizienz-Gaps geschlossen (Engine-Eintritt gehoben, Workload-Achse+working_set_sweep+n_ops/n_repeats XML-steuerbar) | FEATURE | Z20368-20371 | GELANDET (ctest 209/209, golden-Roundtrip Diff leer), Commits lokal nicht gepusht (Submodul-CI-Block) | ce 6b384d6e, fbc0411b, adbb5f42, e72dba1d; super 80f3c14 |
| DD-C: 4 RC-Achsen ins golden-Profil DEFER wg. 8 CONFIRMED Mess-Defekten | REGRESSION | Z20372 | BEKRAEFTIGT DEFER (DATA-gated #156) | - |
| Offen aus E4-Handover: P5 Capability-Paritaet, Behelfsweg-Loeschung Tier1-3, P6 E4-XML-Alleinweg, golden-320-Vollmesslauf, goldener Coverage-Test #18 | AUFGABE | Z20373 | HISTORISCH OFFEN | - |
| Vierfache "E"-Ueberladung disambiguiert (E0-E4 / DD-A-DD-E ex E-A-E-E / §13.9-Gate E1-E3 / E2-Sidecar) | OWNER-ENTSCHEID | Z20381-20388 | FESTGELEGT, additiv kollisionsfrei aufgeloest | - |
| Umbenennung E-A..E-E -> DD-A..DD-E (Decision-Defaults) | OWNER-ENTSCHEID | Z20390 | FESTGELEGT, Original-Marker bleiben additiv stehen | - |
| S<->E-Kreuz-Map (S1-S4-Schichten-Sicht gegenlaeufig zu E4-E1; Spur-S S1-S9 ist dritter S-Scope) | UNKLAR | Z20392 | KLARSTELLUNG dokumentiert | - |
| §11-A #188-Architektur (Spur S) DONE-Nachzug: #221, CMD-1/#251, CMD-2/#252(E2-Sidecar, Rest gated), AP-1/AP-8(host-seitig), #234, #224 | FEATURE | Z20395 | GROSSTEILS DONE, real offen nur #215 (HELD, S8) | - |
| §11-B Mess-Gate P0: AP-3/4/5/6 DONE, AP-7a DONE/7b deferred; Runway-Satz obsolet (4->5-Bump laeuft ueber Scheduling-27.-Achse #37 statt AP-6-Kette) | REGRESSION | Z20396 | UEBERHOLT/KORRIGIERT, realer Rest #162-HELD/G6 | - |
| §11-C P1 Mess-Qualitaet AP-8..AP-15: AP-8/9/10/11 DONE, AP-13 TEIL (3-ISA-Rest infra-gated), AP-15 map+container DONE (Sequence=Planung user-gated), AP-12/#246 offen, AP-14/#248 offen (Gate NACH #215/#156) | AUFGABE | Z20397 | TEILWEISE OFFEN | - |
| §11-E User-Prio #193 P-0-KERN DONE (A/B/C/D verifiziert, Residual Voll-Codegen->#215); #179 Wartbarkeits-Sweep XL; #186 EPIC CI laufend | FEATURE | Z20399 | TEILWEISE DONE | - |
| 23 fehlende TODOs aus Validierung (M1-M23) auf bestehende Posten gemappt | UNKLAR | Z20401 | HISTORISCH, alle eingeordnet (u.a. M12/M18 bereits erledigt) | - |
| §11-H Tier-Metapher+System-Achsen Eigenschafts-Verifikation (deep research 11.07.) | FEATURE | Z20403-20406 | VERIFIZIERT VOLLSTAENDIG, keine unbenannten Pflicht-Properties | - |
| Phantom-Gaps NICHT bauen (Container-Genera-Messung V42-deferred, Graph-Gattung Stub, Latenz-Perzentile schon da) | REGRESSION-Kandidat | Z20407-20409 | ADVERSARIAL WIDERLEGT, bewusst nicht bauen | - |
| H-1 LATENCY_MEAN+THROUGHPUT redundant zu golden-CSV, CLU wuerde CSV-Schema+ABI-POD brechen (TABU) | REGRESSION | Z20411-20417 | AUFGELOEST 11.07. (correctly-gated-do-not-build), sauberer Weg = E1/M2-Single-Source-Replace design-gated | - |
| H-2 bytes_in_use_peak honest-0 ist KORREKT (fehlender Chokepoint, EBO-CRTP ohne Datenmember, Peak-Semantik unbestimmt) | REGRESSION | Z20417-20423 | AUFGELOEST 11.07., honest-0 bleibt (kein Bau noetig) | - |
| §11-G Erweiterung §0-GOAL: Mess-Ergebnis-Rueckschreibung/Persistenz (User 11.07.), Pipeline schreibt Auswertungsdokumente automatisch nach development zurueck | OWNER-ENTSCHEID | Z20427-20436 | FESTGELEGT (Praezisierung bestehendes Ziel) | - |
| G-a offen: ":" im Zeitstempelformat FS-unsicher auf Windows/msvc-Build-Matrix | REGRESSION | Z20433-20434 | OFFEN (zum Zeitpunkt der Niederschrift) | - |
| Phase 2 (spaeter additiv): Ordner PARALLEL nach backup1.comdare.de/Cluster_NFS/cache-engine-experiment | AUFGABE | Z20437-20438 | GEPLANT fuer spaeter | - |
| G-b Project Access Token id=54 writeback-measurements angelegt (write_repository-ONLY), development PROTECTED | FEATURE | Z20439-20447 | GELOEST/GEBAUT (Security-Deep-Research 11.07.), COMDARE_PERSIST_MEASUREMENTS inert bis Aktivierung | - |
| G-c Aktivierung: NAS-Backup-Vorbehalt aufgeloest (User GO), Aktivierungs-Modell per-Pipeline statt global | OWNER-ENTSCHEID | Z20449-20457 | FESTGELEGT/AKTIVIERT | - |
| G-d Mess-Job: mehrtaegiger golden-320-Voll-Messlauf als opt-in CI-Job measure:golden-320 gebaut | FEATURE | Z20459-20460 | GEBAUT | super 0d86098 |
| GO 1 UMGESETZT: Overleaf-Anhang-Verdrahtung #24, CI-interaktive Kette END-TO-END geschlossen | FEATURE | Z20472 | GELANDET | thesis 73947aa, super 54d3983 |
| GO 3 FREIGEGEBEN: #5 Hebel-A-Rest (*_scan-Routing) | AUFGABE | Z20473 | VOLLZOGEN (Nachzug 16.07.) | - |
| GO 4 ENTSCHIEDEN: F-C (Cacheline-Werteset+Knoten-Breite) UND F-B (NUMA/Page-Permutations-Mess-Knopf) | OWNER-ENTSCHEID | Z20474 | FESTGELEGT und VOLLZOGEN | - |
| GO 5 KOMPLETT AUTONOM: #3+#9 Forks ohne Rueckfrage | OWNER-ENTSCHEID | Z20475 | VOLLZOGEN (alle 7 Forks) | - |
| GO 2 ALS LETZTER PUNKT: cpp-Codegen-Backend Swap-to-Default (+graceful-skip), gekoppelt an mehrtaegige Messung | OWNER-ENTSCHEID | Z20476 | VOLLZOGEN (Nachzug 16.07.) | - |
| #25-B Byte-Identitaets-Vertrag V36.B-Codegen-Kanal | REGRESSION | Z20477 | GESTRICHEN/UEBERHOLT (26.07. abends): RETIRE V36.B + MERGE in Fassaden-Kanal (Ein-Hauptkanal-Doktrin §73.1) | ce e99e968f |
| Frage 6 entschieden: prod1-Runner-concurrency->3, #9916=bewusster PoC unter Fremdlast, zusaetzlich Smoke-/Coverage-Mess-Profil bauen | OWNER-ENTSCHEID | Z20478 | FESTGELEGT | - |
| Frage 7 entschieden: NAS-Writeback via V80-Filterpod ueber V20-NAS, V60-Runner duerfen Cluster_NFS nie sehen | OWNER-ENTSCHEID | Z20479 | FESTGELEGT, Infra-Handover geschrieben | - |
| Generelle Freigabe "vollautonome Arbeit" (12.07.) | OWNER-ENTSCHEID | Z20480 | FESTGELEGT | - |
| golden-N-CRC64-Fixture (all_axes_golden.profile.xml, kNewGolden131072Crc64, Anker 0xF1C1F26A1232073B) | FEATURE | Z20483-20484 | GELANDET | ce aa25c9a4 |
| #50 Caching Incremental-Tier-Cache + #51 Storage-Naehte (Verbund 4 Commits) | FEATURE | Z20483-20493 | GELANDET (#50), #51 CE-fertig aber INERT via Weg-A-CI-Gate | ce d0313bf2, 4334f1b8, ea2c544c, 93a21233 |
| #51 Storage CI-Gate COMDARE_STORAGE_CACHE inert-by-default | FEATURE | Z20498 | GELANDET/INERT (bewusst) | super 0b669e9 |
| #52 std::variant-Verbot fuer statische Achsen abgesichert | FEATURE | Z20489 | GELANDET | ce 9614ae0e |
| #45 A2-Neben-Achsen (opt x simd) | FEATURE | Z20490-20491 | GELANDET | ce ce0e252d, cb775ea3 |
| #49 Beweis-Traeger (§33): nur Fixture-Teil gelandet | REGRESSION | Z20504 | OFFEN (Register-Kritik 2), erst new-golden-Voll-Konfig-Messlauf schliesst ihn | - |
| Hybrid = ABGABE-PFLICHT vor 28.07. (§31): PL-20 wandert aus M7+-Nach-Abgabe-Scope in Vor-Deadline-Scope | OWNER-ENTSCHEID | Z20504 | FESTGELEGT (Scope-Verschiebung) | - |
| VOLLES GO 17.07.: Q1-Q5 bestaetigt, DLL-Load=Option B (voll), koordinierter 4->5-Umbau+CEB-System-Achsen-Schichtung freigegeben | OWNER-ENTSCHEID | Z20505 | FESTGELEGT | super 8488d1d-53cbecf |
| F6-Nachzieh: "4-vtable-deprecated"-Ueberclaim auf 3+1 korrigiert (Scheduling erst jetzt markiert) | REGRESSION | Z20505-20506 | BEHOBEN/KORRIGIERT | ce 871f6d2e |
| scheduling_strategy.hpp DEPRECATED-Banner nachgezogen (4. vtable-Achse, war einzige ohne Marker; konsumfrei per grep verifiziert) | REGRESSION | Z20506 | BEHOBEN | ce 95f76805 |
| comdare_is_original_macro.hpp DEPRECATED-Banner (echt-tot, 0 Includer/0 Makro-Aufrufe) | REGRESSION | Z20506 | BEHOBEN | ce 57330d32 |
| EHRLICHE ABWEICHUNG: ctsha.hpp NICHT deprecated (lebt, realer Konsument apps/is_original_validator/main.cpp via cmake/is_original_codegen.cmake) | UNKLAR | Z20506 | KORREKT bewusst unberuehrt gelassen (Sibling LegacyOriginalCodePflicht lebt ebenfalls) | - |
| REV7-Baustein-Cluster (resolve_baustein.hpp+baustein_variants.hpp+algorithm_baustein.hpp) TEST-ONLY-Marker (module_abi_v1.hpp als Ausnahme NICHT markiert, reale Lib-Konsumenten) | FEATURE | Z20506 | GELANDET, Gates CI-BEWIESEN (cf22=0, Mojibake=0, test_abi_interface 19/19, test_profile_roundtrip 320=320 Diff leer) | ce 871f6d2e |
| Konstruktionslogik-Durchdringung: Ist deckt User-Modell ~70% (Fundamente da, SCHICHTUNG fehlt) | REGRESSION | Z20507 | ERKANNT (Basis fuer spaeteren Bau-INC-1) | wf_83ed4865 |
| Delta fehlende Schichtung: 4 CEB-System-Achsen keine gemeinsame Schicht (Telemetrie=Organ-Slot, Scheduling=verwaiste Runtime-vtable Doktrin-Verletzung, Last=ABI-Antriebspunkt statt Systemachse); 26 Achsen FLACH statt geschichtet | REGRESSION | Z20507 | ERKANNT, spaeter durch Bau-INC-1 adressiert | - |
| DLL-LOAD Option B empfohlen (Option A -rdynamic bricht Allokator-als-Algorithmus-Achse durch Arena-Kontamination) | OWNER-ENTSCHEID | Z20507 | EMPFOHLEN/FESTGELEGT als spaeteres Bau-INC-0 | - |
| 5 Gegenpruefungsfragen an User (Gattung Ebene-1 3vs4, Scheduling-CRTP-Systemachse, Telemetrie-Herausloesung POD-Bruch, Pruef-Dock einziger Traeger, H-7 -march-Kopplung) | AUFGABE | Z20507 | GATED, User-Antwort zum Zeitpunkt ausstehend (spaeter beantwortet, s. Bau-INC-2 oben) | - |
| Dock-Terminologie-Schaerfung (User 17.07.): Experiment-Dock=EINDIMENSIONAL (Planer<->CEB), Pruef-Dock=BIDIREKTIONAL (CEB<->Tier-Binary) | OWNER-ENTSCHEID | Z20507 | FESTGELEGT | - |
| Rekursive Dock-Architektur (User-Schaerfung 17.07.): Ebene1 Planer<->CEB, Ebene2 CEB<->Tier-Binary, dasselbe Dock/ABI-.so-Vertragsmuster REKURSIV | OWNER-ENTSCHEID | Z20508 | FESTGELEGT autoritativ | - |
| F1 DLL-Load kann NICHT beantwortet werden (Konstruktionslogik fehlt generell), User tendiert Option B | OWNER-ENTSCHEID | Z20509 | GEKLAERT spaeter via ultracode-Durchdringung (s. Bau-INC-0) | - |
| F2 4->5-Schritt BESTAETIGT: Scheduling-Achse zunaechst SYSTEM-Achse; golden wird ZERLEGT+UMGEBAUT (bewusster Umbau, nicht erhaltend) | OWNER-ENTSCHEID | Z20509 | FESTGELEGT | - |
| F12iii Telemetrie ist SYSTEM-Achse in CEB -> ultracode-Design-Vorlage, GATED nach User-Gegenpruefung | OWNER-ENTSCHEID | Z20509 | FESTGELEGT | - |
| H-7 Tier-Binary durch CEB-System-Achse STATISCH fuer system-passende Optimierung kompiliert (AVX512 wahlweise ein/nicht einkompiliert) | OWNER-ENTSCHEID | Z20509 | FESTGELEGT | - |
| H-8 Governor+Prefetcher = Tier-Binary-Achse (Strategy-/Heuristik-Command-Pattern) | OWNER-ENTSCHEID | Z20509 | FESTGELEGT | - |
| H-9 dynamische System-Unter-Achse via Pruef-Dock an Tier-Binary gesendet; Last+Last-Frameworks = System-Achse | OWNER-ENTSCHEID | Z20509 | FESTGELEGT | - |
| H-10 AVX10-Versionsfeld JA, jede statische Kompilation IMMER versioniert+dokumentiert | OWNER-ENTSCHEID | Z20509 | FESTGELEGT | - |
| F5 PF1-PF4 Planer-Codegen (Runtime der CEB befehligt Tier-Binary am Pruef-Dock; Runner=ISAxOSxSystem-Achsen disjunkt parallel, concurrency1 je Maschine beim Messen) | OWNER-ENTSCHEID | Z20509 | FESTGELEGT | - |
| Fork-A-Bruecke Increment 4: duenne Lauf-Fassade run_experiment_profile_facade + E4-Run-Block-Root-Tag-Dispatch | FEATURE | Z20510 | GELANDET, Gates CI-BEWIESEN (Bau gruen, cf22=0, Mojibake=0, --validate rc0, test_experiment_parser 13/13, test_experiment_projection 3/3, test_profile_roundtrip 320=320) | ce dad91fe5-8bacde51, super c78359d |
| Smoke-Lauf I4: 0 Datenzeilen (measured=0), 7 SOTA-DLLs bauen aber laden nicht (undefinierte mi_malloc_aligned/mi_free Vendor-Symbole) | REGRESSION | Z20510 | PRE-EXISTING BEWIESEN (identisch im unveraenderten Thesis-Weg reproduziert) - Vendor-/Link-Grenze, NICHT I4-Code-Fehler | - |
| #31 <workload>/OP-Pfad LIVE in CI (tote Insel workload_matrix.hpp existiert nicht im Code-Baum) | REGRESSION-Kandidat | Z20511 | WIDERLEGT/NICHT OFFEN (verifiziert LIVE) | - |
| main->development Back-Merge sauber (topologisch erledigt) | REGRESSION | Z20511 | BEHOBEN/ERLEDIGT, alter §12-OFFEN-Vermerk veraltet | - |
| #40 Dead-Code Review-Liste an >=2 Stellen STALE (cache_engine.hpp via #35-Fassade konsumiert, abi_v1_to_v2_mapper bereits getilgt) | REGRESSION | Z20511 | TEILWEISE UEBERHOLT, Reklassifizierung als Nachzug noetig | - |
| F1a Set/Gattung-Vokabular-Versoehnung (User: "Gattung"="Genus"; Set bereits eigenes Genus mit eigener ABI) | FEATURE | Z20512 | GELANDET (reine Doku/Kommentar, kein ABI-Touch), CI-BEWIESEN | ce f4d87059 |
| container_framework.hpp #29-GEPARKT als ENTPARKT markiert, Genus->Ebene-1-Umstrukturierung F1b freigegeben | AUFGABE | Z20512 | FREIGEGEBEN als spaeterer koordinierter 4->5-Schritt | - |
| Bruecke I3: Projektion ExperimentProfile->(merge x lebewesen)-Paesse (19 Paesse, nullopt ehrlich ausgelassen) | FEATURE | Z20513 | GELANDET, CI-BEWIESEN | ce 730831d2-f4d87059 |
| Fehler-Sichtbarkeit honest-100%-Verschaerfung: Messwert-Zelle "failed" statt null/0 + Log neben CSV, Harness misst nach per-Algorithmus-Fehler weiter | OWNER-ENTSCHEID | Z20514 | FESTGELEGT | - |
| A07-snmalloc-Laufzeit-Segfault: auf dieser ISA+OS ehrlich "failed" statt versteckte Null | REGRESSION | Z20514 | Konsequenz aus Fehler-Sichtbarkeits-Regel dokumentiert | - |
| Serialisierung Q1-Q4 FIXIERT (flach+Sidecar-Manifest, statische Spalten weg/Baum in Planer, additiv gespiegelt Host->OS->Toolchain->ISA, On-Disk-Baum+Index-Manifest+atomarer Copy) | OWNER-ENTSCHEID | Z20514 | FESTGELEGT (Konzept fixiert) | - |
| HYGIENE-TODO: F12i-snmalloc-§12-Eintrag fehlplatziert im Ledger | AUFGABE | Z20514 | OFFEN (Housekeeping) | - |
| Bruecke I2: validate_experiment_profile_facade + --validate-Root-Tag-Dispatch (2-Registry-Kanon) | FEATURE | Z20515 | GELANDET, CI-BEWIESEN (rc0/rc1/rc5-Belege) | ce cb841787-16874347 |
| INFRA-BLOCK: voller messung_driver-Bau bricht vorbestehend an ext/allocator/A07-snmalloc (SNMALLOC_USE_WAIT_ON_ADDRESS undeklariert) | REGRESSION | Z20515 | ERKANNT (super-sub-build-Config-Gap), ext/ read-only daher nicht angefasst | - |
| Bruecke I1: Workload-Gate in validate_experiment_profile (known_workload_ids-Pruefung) | FEATURE | Z20516 | GELANDET, CI-BEWIESEN | ce a22007d6-cb841787 |
| Luecke: deprecateter Antrieb validierte ohne Workload-Gegenpruefung (getippte id fiel erst im teuren CEB-Lauf auf) | REGRESSION | Z20516 | BEHOBEN durch Bruecke I1 | - |
| #35 F5.R1 cache_engine-Gesamtfassade get_cache_engine() (4 Provider real verdrahtet, f15_compare als erster Konsument) | FEATURE | Z20517 | GELANDET, CI-BEWIESEN (test_v41_cache_engine_facade 7/7) | ce 780459ec-a22007d6, super 6e71e10-e87ae40 |
| R3 api::ICacheEngine vs concepts::ICacheEngine Namensraum-Kollision | REGRESSION | Z20517 | GELOEST per Rollen-Doku (kein Rename, load-bearing Symbole geschont) | - |
| DEFERRED-#274 (V42) ehrlich markiert: ISearchEngineProvider+ICacheEngineCoreProvider (libs/search_engine/ leer) | AUFGABE | Z20517 | HONEST DEFERRED, deferred_providers() macht Zustand testbar | - |
| S-2a: 3 tote V32.EE.5-vtable-Header deprecated (hardware_strategy/locking_mode/numa_affinity) | REGRESSION | Z20518 | BEHOBEN | ce dc1b735d |
| S-2b: axis_library_registry.hpp-Provenienz umgebogen (Phantome->Live-Pfade, 12.2/CacheLevelTarget ehrlich als fehlende Live-Achse markiert) | REGRESSION | Z20518 | BEHOBEN | ce 452a1b6f |
| S-3: Achse-14 ENGINE-CHOICE kommentiert (Betriebswahl != Pruefstufe) | FEATURE | Z20518 | GELANDET | ce 780459ec |
| S-7-PLAN komplett (OptiQL-faithful-Reimpl + ARTSynchronized-Vendoring, UpgradeableConcurrency=10. Organ) | AUFGABE | Z20518 | PLANUNG VOLLSTAENDIG, naechster Bau-Kandidat S-7-INC-1 | super 0e87b64 |
| WP-4: F30 Registry-Praefix+Drift-Guard, F29 Round-Trip-ctest beide Registries, F33/F66 Fixture-Provenienz, F34 README-Nachzieh, F23/F25 Fixes | FEATURE | Z20519 | GELANDET | ce ee892f20, prt-art 9b8dd09, super cecc0a5 |
| WP-3-orthogonal: F26-1 BOM-Skip+F26-2 Close-Tag-Abgleich, F22/F28-Haertung, F12-Validator-Haelfte (op_types HART gegen XSD-Enum) | REGRESSION | Z20519 | BEHOBEN (176/176 XMLs Regressionslauf byte-identisch) | - |
| E11-gated dispositioniert (3-Phasen-Haertung, engine/engines-XOR, merge-Enum-Kardinalitaet) | AUFGABE | Z20519 | GATED, NICHT gebaut (K7) | - |
| S-1 Entscheid: Scheduling-SYSTEMACHSE jetzt (golden-neutral), #37-Organ-Achse separater TABU-Entscheid | OWNER-ENTSCHEID | Z20520 | FESTGELEGT | - |
| S-2 Entscheid: 3 vtable-Header deprecaten + Registry-Strings umbiegen + 4 Pflicht-Systemachsen NEU bauen (CRTP in CEB) | OWNER-ENTSCHEID | Z20520 | FESTGELEGT | - |
| S-4 Entscheid: keine Kategorie-Erweiterung zunaechst + spaetere eigene Mess-Kategorie als TODO | OWNER-ENTSCHEID | Z20520 | FESTGELEGT | - |
| S-5 Architektur-Praezisierung: Experiment-Planer=XML-Interpreter/Uebersetzer fuer CEB-Kompilation, baut VERSCHIEDENE CEB auf | OWNER-ENTSCHEID | Z20520 | FESTGELEGT | - |
| S-6 Entscheid: strikt gcc|clang zunaechst, dynamisch je Compiler-Verfuegbarkeit erweiterbar | OWNER-ENTSCHEID | Z20520 | FESTGELEGT | - |
| S-7 VERSCHAERFT: PFLICHT deep research+ultracode, Achse in SearchAlgorithm+Container-Gattung echt verwendet, alle Gattungen Observer-Messwerte echt | OWNER-ENTSCHEID | Z20520 | FESTGELEGT, aber S-7-Deep-Research RUHT (Fable-Sicherheitsmassnahmen blockierten Web-Recherche), GEPARKT | - |
| F3i "4. Kategorie" = EIGENE Kategorie JE STUFE (Compiler-Systemachse gcc/clang, Voll-Vergleich, "alt gegen neu"=SOTA vs Pruefling) | OWNER-ENTSCHEID | Z20521 | FESTGELEGT | - |
| F4 KONZEPT-KORREKTUR: Scheduling/Hardware/NUMA/Locking sind PFLICHT-SYSTEMACHSEN, keine Duplikate sondern missverstandene Konzeptstellen | REGRESSION | Z20521 | ERKANNT als Konzeptfehler, 20-Seiten-Dossier beauftragt | - |
| F5 Klarstellung: Achsen-Tests waren echt (269/269), nur Gesamt-Fassade als Eintrittspunkt fehlte | REGRESSION | Z20521 | KLARGESTELLT (kein Fehlbefund) | - |
| WP-5/F56: 30 REV-IDs dispositioniert, 7 JETZT gefixt (DATA-01 Capability-Zell-Invalidierung, DATA-04 from_chars-Parser, DATA-05 Artefakt-Allowlist, DATA-06 atomarer Publish, DATA-07 Zell-Raster-Stratifizierung, CXX-02 OLC-CAS, CXX-05 noexcept-Entfernung) | REGRESSION | Z20522 | BEHOBEN (7/30), 1 reject, 15 gated | ce c38144e5, prt-art fc80c61 |
| WP-5/F57 Muster B: 16 noexcept-auf-Alloc-Bodies verifiziert (14x entfernt, 2x Allokation herausgehoben); fruehere G3-"erschoepft"-Behauptung korrigiert | REGRESSION | Z20522 | BEHOBEN, frueherer Status-Claim korrigiert | - |
| I-PMC-1 (F9 User-PFLICHT): -DCOMDARE_ENABLE_PMC=ON in measure:smoke+measure:golden-320 | FEATURE | Z20522 | GELANDET, CI-BEWIESEN | super 9fa0107 |
| Offen: I-PMC-2 (L3-Mapping+branch_misses), I-PMC-3 (#187 L2+coherence Zen-5-RAW), Standalone-Preset F12-Paritaetsstrecke | AUFGABE | Z20522 | OFFEN | - |
| F1 JA+Erweiterung: <phases> 1..unbounded, Anwender waehlt in XML Auswertung/Veroeffentlichung/Speicherung | OWNER-ENTSCHEID | Z20523 | FESTGELEGT | - |
| F3(ii): 4 CEB-Betriebsmodi als XML-Element sind PFLICHT und BASISFEATURE, nicht vertagen | OWNER-ENTSCHEID | Z20523 | FESTGELEGT | - |
| F5 JA (#35->#38->#37) + AUFTRAG: Feature muss REPARIERT werden, AUDIT der Fassaden-Kette noetig | OWNER-ENTSCHEID | Z20523 | FESTGELEGT | - |
| F6 JA+GROSSE ERWEITERUNG: XML steuert dynamisch CI ueber INTERPRETER, JEDES Feature muss XML-unterstuetzt+CI-getrackt sein | OWNER-ENTSCHEID | Z20523 | FESTGELEGT (grosse neue Anforderung) | - |
| F7(ii): jemalloc NICHT loeschen, in Allokator-Achse einbinden | OWNER-ENTSCHEID | Z20523 | FESTGELEGT | - |
| F7(iii): ZIH-README wird BENOETIGT (Antrag auf ZIH-Rechenressourcen laeuft) | OWNER-ENTSCHEID | Z20523 | FESTGELEGT | - |
| F8 GO: alle 4 Branch-Loeschungen (super x3, thesis x1), nur main+development behalten | OWNER-ENTSCHEID | Z20523 | FESTGELEGT/GO | - |
| F9 ENTSPERRT: PMC-Infra MUSS als PFLICHT installiert werden fuer Vollstaendigkeit aller perf-Messwerte | OWNER-ENTSCHEID | Z20523 | FESTGELEGT | - |
| F10: LaTeX-Schnittstelle uebernimmt Messabschnitt aus fest verdrahtetem Output, ueberschreibt bei JEDER Messung | OWNER-ENTSCHEID | Z20523 | FESTGELEGT | - |
| F11: 48er verworfen, Thesis-Set kanonisch, Ist-Stand an ALLEN Stellen updaten | OWNER-ENTSCHEID | Z20523 | FESTGELEGT | - |
| F12(i) DEADLINE 28.07.: SOWOHL CI ALS AUCH standalone messbar, perfekt synchron | OWNER-ENTSCHEID | Z20523 | FESTGELEGT (historischer Termin) | - |
| E1 CSV erweitert: je Achse Algorithmus-Wahl-Spalte + ;phase;engine | OWNER-ENTSCHEID | Z20524 | FESTGELEGT | - |
| E3: n_repeats>=3 wird Pflicht-Validierung im Experiment-Pfad | OWNER-ENTSCHEID | Z20524 | FESTGELEGT | - |
| E4 ZIEL-ANSPRUCH: EINE XML fuer ALLE Tier-Binaries, Testdaten, Ablaeufe, Ausgabedokumente + Binary-Reproduktion | OWNER-ENTSCHEID | Z20524 | FESTGELEGT | - |
| E7 Single-Source (b): EINE Quelle der Wahrheit, Fixture-Duplikate eliminieren | OWNER-ENTSCHEID | Z20524 | FESTGELEGT | - |
| E9 DoD-7=JA je Experiment + Schema-Erweiterung: XML muss MEHRERE Experimente in Reihe messen (Serie) | OWNER-ENTSCHEID | Z20524 | FESTGELEGT | - |
| E10: erst offizielle Strecke voll erweitern, dann V32 als Irrweg zurueckbauen | OWNER-ENTSCHEID | Z20524 | FESTGELEGT | - |
| E11 Phasen-Kardinalitaet ==3 ist KOMPLETT FALSCH ("es gibt mehr als 3 Phasen") | REGRESSION | Z20524 | ERKANNT als Fehlannahme, ultracode-Klaerung beauftragt | - |
| E14 statt Branch-Loeschung: ALLE Extra-Branches erst auf Features pruefen, wertvolle mergen | OWNER-ENTSCHEID | Z20524 | FESTGELEGT (praezisiert F8-GO) | - |
| E17-E21 GEPARKT unbeantwortet (G-270a, G-AP15, Loesch-GOs KEIN GO, Kernfeature-Reihenfolge Default, Anhaenge-B/E-Zustaendigkeit) | AUFGABE | Z20524 | GEPARKT/OFFEN | - |
| WP-1-Agent haertete v32-Parallelstrecke faelschlich ("zweite sinnlose parallele Engine") | REGRESSION | Z20525 | ERKANNT+GESTOPPT, halbfertige Edits als patch gesichert | - |
| FORK-ENTSCHEID Option A: v32-Strecke wird DUENNE Orchestrierung ueber EINEM offiziellen E4/CEB-Pfad zurueckgeschnitten | OWNER-ENTSCHEID | Z20525 | FESTGELEGT (bindend), "IMMER offizielle Architektur" als Generalregel | - |
| Neue Direktive: vor JEDER Aufgabe erst Projektstruktur-Analyse, NIE zweite Strecke bauen | OWNER-ENTSCHEID | Z20525 | FESTGELEGT | - |
| Voll-Audit Sessions/Plaene/Architektur: 83 bestaetigte Befunde (9 high/38 med/36 low) | REGRESSION | Z20526 | ERHOBEN | wf_0de715c9 |
| v32-Weg NICHT messreif (F01 Gate gated nicht, F02 mode nie konsumiert, F03 WorkloadKind Phantom, F08/F61 Aktivierungskette tot, F09/F60 in-process statt Laufzeit-DLLs Overclaim, F10 Workloads hartkodiert, F62 CI zementiert Surrogat) | REGRESSION | Z20526 | ERKANNT, WP-1 zwingend vor jedem echten v32-Lauf | - |
| F18: 3 frische Tests in KEINEM CI-Job (3. Muster-F-Loch) | REGRESSION | Z20526 | ERKANNT | - |
| Ledger-Peripherie 14+ stale Eintraege (F35-F55); Nummernraum #33-#40 doppelt belegt (F40); #34 aus allen Boards gefallen (F39) | REGRESSION | Z20526 | ERKANNT | - |
| beide ce-Alt-Ledger unmarkiert Single-Source + von UML-Bannern angesteuert (F67 high), 10 supersedierte Punkte (F68-F83) | REGRESSION | Z20526 | ERKANNT | - |
| EHRLICHE SELBSTKORREKTUR: G2/G3-"autonom erschoepft"-Meldungen waren UEBERCLAIMT (F56 >=9 undispositionierte Findings, F57 Muster B nie umgesetzt) | REGRESSION | Z20526 | ERKANNT (eigener Overclaim korrigiert) | - |
| Abarbeitung WP-0..WP-6 geplant + Design-Buendel A (offizieller XML-Weg messreif) + 9 kleinere Forks B-J | AUFGABE | Z20526 | GEPLANT | - |
| G3: 18/20 Correctness-Befunde bereits gefixt (verify-first), 2 trivial nachgezogen (M-SU-02 XML-Escaping, M-CE-26 write_temp-Fehlerpruefung) | REGRESSION | Z20527 | BEHOBEN (18 bereits + 2 nachgezogen), G3 autonom erschoepft | ce 9d95346d-8eb37261 |
| G2: 10/12 Anti-Phantom-Befunde bereits gefixt (verify-first), 1 n/a, 1 partial (q1-is-original user-gated) | REGRESSION | Z20528 | BEHOBEN (10), G2 autonom erschoepft (spaeter teilweise als Overclaim korrigiert, s. F56/F57) | wf_888f6e2f |
| q1-is-original Nummer-Korrektur: gehoert zu #38 nicht #37 | REGRESSION | Z20528 | KORRIGIERT (Nachzug 16.07.) | - |
| M-CE-27: test_profile_roundtrip fehlte dedizierter -R-Gate in .gitlab-ci.yml | REGRESSION | Z20529 | BEHOBEN (in contract:profile_coverage-Job aufgenommen) | ce 02e0176f-9d95346d |
| INC-7: Thesis observer_detail.tex DE+EN verdrahtet (Per-Achsen-Observer-Detail A.4.1) | FEATURE | Z20530 | GELANDET, HONEST-EMPTY CI-BEWIESEN (Fallback greift mangels Messlauf) | thesis 83c4ab9-8d156a5 |
| Task #6 HEADER-FILL: COMDARE_DEFINE_ORGAN_LOCATION auf 76 ce-Achsen-Wrapper, Registry-header befuellt (0 leere Baustein-Header von 90) | FEATURE | Z20531 | GELANDET, CI-BEWIESEN (265/265 Tests, golden 320) | ce 50c2aac1-02e0176f |
| Task #21 snmalloc-Voll-Bau-Fix: Pflicht-Compile-Flags nur am geguardeten Vendor-Target statt self-contained am Adapter (Root-Cause ext/ nach adapters/ konfiguriert) | REGRESSION | Z20532 | BEHOBEN (Flags direkt als INTERFACE am Adapter) | ce 64a5938d-50c2aac1 |
| SEPARATER PRE-EXISTIERENDER BEFUND: Laufzeit-Smoke V31AdapterAlloc.A07_Snmalloc segfaultet (ThreadAlloc::alloc) | REGRESSION | Z20532 | NICHT gefixt, latenter header-only-snmalloc-Laufzeit-Bug, separat zu tracken | - |
| INC-G+INC-H: execute_messreihe-Antrieb (parse->validate->Phasen-Strategy->INC-F-Katalog-Treiber) + CSV/TikZ-Export, INERT main.cpp-Andock | FEATURE | Z20533 | GELANDET, CI-BEWIESEN (Welch-Verdikt gebildet, W4-Gate 0 Alt-Pfad-Marker, golden 320 unveraendert) | super (kein Gitlink-Bump) |
| Hinweis Infra pre-existing: voller messung_driver-Binary-Link bricht weiterhin in ext/allocator/A07-snmalloc | REGRESSION | Z20533 | BEKANNT/UNABHAENGIG, Verifikation ueber Test-Target statt vollem Link; Push gitlab deferred Modus a | - |
| INC-F: Surrogat PrtArtHashBackend im Mess-Pfad AUSgehaengt, ersetzt durch reale CEB-Katalog-Tier (W4-Gate) | FEATURE | Z20534 | GELANDET, CI-BEWIESEN (0 Alt-Pfad-Marker, 7/7 Consumer-Tests, golden 320), INERT via COMDARE_V32_DRIVER_ENABLE | super v32_katalog_driver.hpp |
| M-CE-10-Fix: EINE HOT-Pilot-Stufe2-Binary auf 5 reale per-Host-Kompositionen aufgefaechert | REGRESSION | Z20534 | BEHOBEN (test_sota_st2_dedup 14->19 Paesse) | - |
| INC-E: Strategy-Pattern der Experiment-Configs (3 Phasen als GoF-Strategy+Policy-Based-Design+CRTP-Concept-Guard) | FEATURE | Z20535 | GELANDET, CI-BEWIESEN (19 Runtime+22 compile-time Checks), HEADER-ONLY+INERT bis Stufe G | super experiment_phase_strategy.hpp |
| INC-D: Experiment-Parser als MODUL im ce-Parser (parse_experiment_profile common + validate_experiment_profile cache_engine-Schicht) | FEATURE | Z20536 | GELANDET, CI-BEWIESEN (5/5 Tests, golden 320) | ce 3f4bff19 |
| Interim-Standalone messreihe_v32_parser.hpp als deprecated markiert, nicht geloescht | REGRESSION | Z20536 | BEHOBEN/markiert (Doku-nie-loeschen) | - |
| INC-C: comdare_experiment-XML-Schema (experiment_golden.xml + experiment_schema.xsd, 3-Phasen-Vorlage) | FEATURE | Z20537 | GELANDET, CI-BEWIESEN (xmllint validates), INERT bis INC-D | - |
| Legacy v32-Fixture BEHALTEN, nicht geloescht | UNKLAR | Z20537 | bewusst erhalten (Doku-nie-loeschen) | - |
| INC-B: prt-art-Registry-XML (gleiches Schema wie ce-Registry) + R-B-Makro COMDARE_DEFINE_ORGAN_LOCATION | FEATURE | Z20538 | GELANDET, CI-BEWIESEN (Generator baut+laeuft, golden 320) | ce 80df4a6f-47157c6e, prt-art 12ca4413-1d66ded8 |
| §2c-Luecke: type/header in prt-art-Registry waren leer, jetzt reflektierbar durch R-B-Makro | REGRESSION | Z20538 | BEHOBEN | - |
| Kollision verifiziert: golden-Organ ist BARE ce-Strategie PatriciaPathCompression (kein prtart_-Name), direkt reflektiert | UNKLAR | Z20538 | VERIFIZIERT/dokumentiert | - |
| INC-A: ce-Registry-XML per compile-time-Reflektion generiert (tools/axis_registry_gen) | FEATURE | Z20539 | GELANDET, CI-BEWIESEN | ce 9f05c6db-80df4a6f |
| header="" bewusst leer (CE-Wrapper ohne cpp_type_name/header_include), Folge-Bedarf notiert | AUFGABE | Z20539 | ERKANNT, spaeter durch Task #6 HEADER-FILL behoben (s.o.) | - |
| INC-V32-C.parser: typisierter XML->Struct-Parser fuer messreihe-v32-Interface | FEATURE | Z20540 | GELANDET, CI-BEWIESEN (57 Checks) | super messreihe_v32_parser.hpp |
| INC-3: <measurement_categories> im comdare_thesis_profile (K-Dimension GEBAUT) | FEATURE | Z20541 | GELANDET, CI-BEWIESEN (264/264) | ce 7b0d2e41-9f05c6db |
| INC-4: Modus-2 Per-Achsen-Observer-Detail-Writer, honest-empty | FEATURE | Z20542 | GELANDET, CI-BEWIESEN (36/36) | super 5191e7c |
| INC-1: latex_anhang 15-col-Legacy->16-col header-getrieben (Legacy stoull-Wurf auf workload-Spalte) | REGRESSION | Z20543 | BEHOBEN | ce 7b0d2e41 |
| GitLab-Blocker geloest: .de abgeschaltet, kanonisch .local, alle 4 Repos migriert | REGRESSION | Z20544 | BEHOBEN | - |
| #24 predicate_evals ECHTE Messung (honest-100%, Option A) | FEATURE | Z20544 | GELANDET, CI-BEWIESEN | ce 513622e2 |
| Branch-Doktrin: immer development, main immer Vorfahr | OWNER-ENTSCHEID | Z20544 | FESTGELEGT | - |
| NEUE BINDENDE DOKTRIN honest-100%: in-code-berechenbare Werte MUESSEN real implementiert werden | OWNER-ENTSCHEID | Z20545 | FESTGELEGT | - |
| DEAD-CODE-FEHLER KORRIGIERT: #16-Muster-C-Deprecation (5 Header) war falsch, unverdrahtet != tot | REGRESSION | Z20545 | BEHOBEN (Banner revertiert) | ce 804aa3c2 |
| FORK-ENTSCHEIDUNGEN: #37-Scheduling=A+B Prio A (TABU-GO), #24=Option A+Overleaf-GO, #39=HAUPT-ZIEL xml->pdf-Voll-Matrix | OWNER-ENTSCHEID | Z20545 | FESTGELEGT | - |
| #25 rcu-Eigentumsmodell-Inversion (Thread-Ende+Shutdown-UAF behoben) | REGRESSION | Z20545 | BEHOBEN | ce 95d11383 |
| #23 RC-applied echt + #36 V32-Bit-Bank-Tilgung | FEATURE/REGRESSION | Z20545 | GELANDET/BEHOBEN | ce b9a39aa9, ebcc5498 |
| Nummernraum #33-#40 ZWEIFACH belegt (07-08 vs 07-13) | REGRESSION | Z20545 | ERKANNT (Nachzug 16.07., 07-13-Raum gueltig) | - |
| 3 Lizenz-Labels korrigiert (tcmalloc->Apache-2.0, lrmalloc->MIT, michael->LGPL-2.1) | REGRESSION | Z20546 | BEHOBEN | ce 5768faeb |
| G5-Praemisse "metrics-Transfer Schritt3 vergessen(#18)" WIDERLEGT (bereits vollzogen+CI-gruen) | REGRESSION | Z20546 | KORRIGIERT, #18 obsolet | - |
| G4-#16: 5 verifiziert-tote Header deprecated-in-place (AbiV1ToV2Mapper, 4 vtable-Achsen, cache_engine.hpp, comdare_is_original_macro) | REGRESSION | Z20547 | BEHOBEN | ce 414ed8c2, super 64eccac |
| verify-first fing 3 stale Review-Dead-Code-Behauptungen (i_c01-12, algorithm_baustein, IConcurrencyManager alle LEBENDIG) | REGRESSION | Z20547 | WIDERLEGT (Review-Liste hohe FP-Rate) | - |
| 7 medium-Funde: 2 FIXED (#6 Stufe-03-Fixture-Writer v1/v2-Bug), 5 GATED; +1 jemalloc-Detection-Pfad-Zwilling | REGRESSION | Z20548 | BEHOBEN (3) | super 9147932, ce 614c0e4d |
| #17 40-major-Gate: fruehere "erschoepft ~29/40" war VOREILIG, 6 Findings weder gefixt noch gated (M-CE-15/17/18/20/21/26) | REGRESSION | Z20549 | ERKANNT als eigener Overclaim | - |
| #33: M-CE-21 snmalloc-Detection IMMER OFF (Mess-Integritaets-Bug) + M-CE-26/15/17/20 | REGRESSION | Z20549 | BEHOBEN (5 der 6) | ce 2dc821d5 |
| M-CE-18 (latex_anhang tot) = SUPERSEDED | REGRESSION | Z20549 | GESTRICHEN/UEBERHOLT | - |
| G4-#9: 114-Findings-Cluster Doku-Drift in 3 Increments (Zaehl-Drift, Behelfsweg-Banner, Attribution inkl. Kuehn-LeafOnly-Fehlattribution) | REGRESSION | Z20550 | BEHOBEN | ce 2dfb981b, e6d51674, c3e26aa5 |
| G3-#30: 4 Observer-Tests via Deep-Research auf honest-0 korrigiert (DESIGN-MANDATED) | REGRESSION | Z20551 | BEHOBEN | ce 46093d50, super 794e92f |
| Anti-Output-Fitting-Fang: Erst-Justification "Art/Hot Prefetch=10" war FALSCH | REGRESSION | Z20551 | ERKANNT+korrigiert | - |
| #25 rcu readers_-Dangling = DESIGN-FORK (naiver Fix fuehrt zu neuem Shutdown-UAF) | REGRESSION | Z20552 | ERKANNT als Architektur-Entscheidung (STOPP-Regel) | - |
| #13 CRC64-Platzhalter: echte CRC64 waere Phantom (kein Konsument) | REGRESSION | Z20552 | eingeordnet als #9-je-GO-Doku-Drift | - |
| G3/G4-#29 Muster-D: 205 Instanzen CMAKE_SOURCE_DIR/BINARY_DIR -> PROJECT_SOURCE/BINARY_DIR (Embed-Bau brach) | REGRESSION | Z20553 | BEHOBEN | ce 27f263c2, super 095fe0b |
| 2-Tage-Sweep: 4 genuin vergessene Funde (B1 major LeafOnlyCounter USE-AFTER-FREE, B2 major ungegateter Legacy-Mikrobench, B3/B4 minor) | REGRESSION | Z20554 | ERKANNT, Board #19-#22 aufgenommen | - |
| G2-#3 Workload-id-Cluster geschlossen (validate_profile prueft <workloads> gegen reale IDs) | REGRESSION | Z20555 | BEHOBEN | ce 8cde40b0, super 49c7a79 |
| E0-E4-Konsolidierung: Fehl-Kategorisierung #16 korrigiert (Null-Consumer-Trap war bewusster E4'-Vorbau, kein Dead-Code) | REGRESSION | Z20555 | KORRIGIERT | - |
| MERGE-DIREKTIVE: NIE rebase, IMMER merge | OWNER-ENTSCHEID | Z20555 | FESTGELEGT | - |
| Selbstkorrektur: G2-#3-ce-Push wurde versehentlich rebased statt gemerged | REGRESSION | Z20555 | ERKANNT, NICHT force-rewritten | - |
| Voll-Zeilen-Review aller 4 Repos: 368 verifizierte Findings (0 critical/40 major) | REGRESSION | Z20556 | ERHOBEN (Quelle vieler obiger Fixes) | - |
| §12-Eintraege "#89/#90 DONE" waren stale (Anhaenge B+E nur 4-Zeilen-Stubs) | REGRESSION | Z20556 | ERKANNT als frueherer Overclaim | - |
| #6 Mimalloc-Grenze aufgeloest: link_libraries im perms-ON-Zweig (Definition-global/Include-target-scoped Asymmetrie) | REGRESSION | Z20557 | BEHOBEN (perms-ON 0->216/216 bauende Tests) | ce e5946cdb, super d55c8d3 |
| Forks 1+2+6: <datasets> additiv im E4-Schema, Dataset-Single-Source, fairness-Attribut | FEATURE | Z20559 | GELANDET | ce d2815c02 |
| Fork 7: H2-Score als TOOL-BERECHNETE Akte (h2_code_quality_score CSV-Endspalte) | FEATURE | Z20559 | GELANDET | ce 91bf2083 |
| Aufraeum: 3 Studien-Profile kanonisiert, cap=0 Bug (leere Basis-Selektion) behoben | REGRESSION | Z20559 | BEHOBEN | ce bc8eecfd |
| GO 2 FINAL: cpp-Codegen-Backend ist DEFAULT (LAUTER Single-Pass-Fallback) | FEATURE | Z20559 | GELANDET | ce e99e968f, super ff3fedd |
| mimalloc-Include-Vererbung bricht ~70 Targets im perms-ON-Tree | REGRESSION | Z20559 | ERKANNT, spaeter behoben (s. #6 Mimalloc-Grenze) | - |
| #26/#9 Multi-Sweep-Fix: run_profile fuhr nur EINEN Selektions-Pass, axis_sweeps blieben ungemessen | REGRESSION | Z20560 | BEHOBEN (profile_sweep_passes) | ce 0a1a2e3b, super 4569924 |
| m3_smoke_coverage.profile.xml + inerter CI-Job measure:smoke | FEATURE | Z20560 | GELANDET | - |
| F-B: alloc_hw-Unterachse (NumaNode x PageHint), honest-0 beseitigt (memory_page_size/huge_page_capable erster Konsument) | FEATURE | Z20560 | GELANDET | ce 1211749e, super 7054853 |
| GO 1: Overleaf-Anhang verdrahtet (4 CI-interaktive Darstellungen), #24 COMPLETED | FEATURE | Z20561 | GELANDET | thesis 73947aa, super 54d3983 |
| GO4/F-C: Cacheline-Werteset {B32,B64,B128,B256} + node_width-Unterachse | FEATURE | Z20561 | GELANDET | ce a08a60ca |
| GO 3: Deklarations-Wahrheit+Mess-Kern-Reinheit, #5 COMPLETED | FEATURE | Z20561 | GELANDET | ce def62b0a |
| #217 Kartierung: SEQUENZ-KORREKTUR (zerfaellt in 2a ABI-neutral vs 2b #188/#234-entangled) | REGRESSION | Z20564 | ERKANNT | - |
| #217-ENTSCHEIDUNG User: Array = spezieller Container, KEINE neue Gattung; 2a jetzt, 2b spaeter | OWNER-ENTSCHEID | Z20565 | FESTGELEGT | - |
| P-0/#193-B DONE: 16 tracked .ps1 von Maschinen-Hartkodierung entkoppelt | REGRESSION | Z20566 | BEHOBEN | ce 243edc1 |
| P-0/#193-A DONE: SOTA-Profil-Verzeichnis-Aufloesung gefixt (CWD-abhaengiger Fallback) | REGRESSION | Z20567 | BEHOBEN | ce a0b514c |
| NEUE DEG: codegen.cpp hat dieselbe Fehlklasse (comdare_root/"cache_engine" ohne libs/) | REGRESSION | Z20567 | ERKANNT, Follow-up an #215 gekoppelt (nicht gebuendelt) | - |
| CI-LUECKE: kein CI-Gate baut comdare_builder_experiment_driver | REGRESSION | Z20567 | ERKANNT -> §7-CI-2, spaeter behoben | - |
| P-0/#193-C+D DONE: --help + MANUAL_RUN.md + Demo-Preset; #193 KERN ERLEDIGT | FEATURE | Z20568 | GELANDET | ce d4641a3 |
| CI-2/#193-A-CI-Luecke GESCHLOSSEN: contract:experiment_driver-Gate | REGRESSION | Z20569 | BEHOBEN | ce 1b27608 |
| S2/#217-2a Kartierung: KORREKTUR fruehere Annahme (keine aktive Trunkierung mehr, reale Unehrlichkeit=max_fanout nicht erzwungen) | REGRESSION | Z20570 | KORRIGIERT | - |
| S2/#217-2a DONE: CapacityConstraint/CapacityKind{Static,Advisory}, Runtime-Guard fuer Static | FEATURE | Z20570 | GELANDET, CI-BEWIESEN (3/3) | ce d28108f6 |
| Geflaggt Follow-up: ungeguardeter uint16-Narrow-Cast im Mapping-Observer-Seitenpfad | REGRESSION | Z20570 | OFFEN (Follow-up) | - |
| S3/AP-7a DONE: faithful SwissTableSearchAlgo, golden-neutrale OFF-Registrierung | FEATURE | Z20571 | GELANDET, CI-BEWIESEN (2/2) | ce 75071224 |
| Spur-P/AP-3/#237 DONE: IPlatformProbe real (CPUID)+HardwareFilter verdrahtet | FEATURE | Z20572 | GELANDET, CI-BEWIESEN | ce dd1079ff |
| Spur-P/AP-5/#239 DONE: FullSampled-Messreihen-Modus (FNV-1a-64 statt std::hash fuer Toolchain-Stabilitaet) | FEATURE | Z20573 | GELANDET, CI-BEWIESEN | ce 859915e1 |
| CODEX-ENV-FIX: Codex-Impl brach mit §8-STOPP ab (injizierter workflow-orchestrator-Hook), 3 Fehlstarts | REGRESSION | Z20573 | BEHOBEN (temp CODEX_HOME) | - |
| AP-4/#238 Kartierung: Stufe2/Stufe3 IMMER dieselbe Komposition (lebewesen nur Anzeige-Name), Dedup-Falle | REGRESSION | Z20574 | ERKANNT, zunaechst deferred | - |
| KORREKTUR nach Explore-Vollmap: "A_full" existiert NICHT literal, AP-4 ist doch moderater Increment | REGRESSION | Z20575 | KORRIGIERT (Defer-Entscheid revidiert) | - |
| AP-4/#238 DONE: 5 neue per-Host-Stufe3-Kompositionen (6 reale distinkte B-Module) | FEATURE | Z20576 | GELANDET, CI-BEWIESEN (distinkte DLL-Groessen) | ce 2782325f |
| AP-6/#240 SCOPING User-Korrektur: P08/P09/P33 als ABSTRAKTE Profile anlegen statt Nicht-Profile | OWNER-ENTSCHEID | Z20577 | FESTGELEGT | - |
| P33 GELOEST (User 04.07. generelle Doktrin): fehlender Paper-Code wird haargenau nachgebaut+als Re-Impl markiert | OWNER-ENTSCHEID | Z20577 | FESTGELEGT | - |
| Prozess-Korrektur: nach JEDEM Push gitlab-Pipeline auf GRUEN pruefen | OWNER-ENTSCHEID | Z20578 | FESTGELEGT | - |
| AP-6/#240 BASIS DONE: 3 abstrakte SOTA-Profile (olc/louds/vampir) + 13 Allokator-XMLs + Coverage-Gate | FEATURE | Z20579 | GELANDET, CI-BEWIESEN | ce 28f3a9e9 |
| Rolle-Korrektur: Diplomarbeit-IMPL-Agent Cluster NUR lesend, KEIN Infra, WireGuard VERBOTEN | OWNER-ENTSCHEID | Z20579 | FESTGELEGT | - |
| AP-6/P33 ECHTNACHBAU DONE: VampirNfpAllocator (axis_06, family A24), partieller faithful Nachbau | FEATURE | Z20580 | GELANDET, CI-BEWIESEN (7 static_asserts) | ce 0e89a1a0 |
| Option B (NfpTierPlacedMemoryLayout) = dokumentierter Folge-Increment | AUFGABE | Z20580 | OFFEN | - |
| PIPELINE-SYNC: super-Pipeline PENDING = Runner-Stall #210 (Infra, nicht Code) | REGRESSION | Z20580 | ERKANNT als Infra-Problem | - |
| #221/AUDIT-A3-K1 DONE: RC prefetch_distance -> realer T7 (RC war write-only, nie gelesen) | REGRESSION | Z20581 | BEHOBEN | ce d3cb2980 |
| HONESTY-CATCH: vorgeschlagener "contained slice" haette bereits gestoppten synthetischen Pfad A getroffen | REGRESSION | Z20581 | ERKANNT+vermieden | - |
| #224/AUDIT-A4-K10 DONE: GoF-Etiketten-Hygiene (R1-R4 Kommentar-Klarstellungen, KOMMENTAR-ONLY) | REGRESSION | Z20582 | BEHOBEN | ce 996adc74 |
| Kartierung reframte "grossen 4->5-Bump": golden-320 ist golden-NEUTRAL, 3 von 4 Features ABI-neutral+separabel | REGRESSION | Z20583 | ERKANNT (Bump schrumpft auf CMD-2) | - |
| AP-1/#235 DONE: branch_misses+throughput_ops_per_sec in voller CSV (23->25) | FEATURE | Z20583 | GELANDET, CI-BEWIESEN | ce a16a72c1 |
| AP-8/#242 DONE: HdrHistogram_c vendored + LatencyHdrHistogram + p95 | FEATURE | Z20584 | GELANDET, CI-BEWIESEN | ce 6379b41d |
| Modul-Konsolidierung A: 6 GitHub-only Sub-Submodule waren 0/6 legit, entnestet+Remotes geloescht | REGRESSION | Z20585 | BEHOBEN | ce 53ff03a3 |
| Reuse-Plan B (comdare-foundation-all+config-all via Weg A) | AUFGABE | Z20585 | GEPARKT fuer User | - |
| AP-11/#245 DONE: ehrliche Katalogisierung statt Attrappen (lp_id-Attribut, Anti-Fake-Doktrin) | REGRESSION | Z20585 | BEHOBEN | ce 92b6f536 |
| AP-9/#243 DONE: Provenance-Manifest im Mess-Export (Sidecar, 4x git_sha, cpuid REAL) | FEATURE | Z20586 | GELANDET, CI-BEWIESEN | ce 1c7d1c29 |
| AP-10/#244 Mechanik-Teil DONE: Dataset-Akte-Manifest + String->uint64-Loader | FEATURE | Z20587 | GELANDET (Mechanik), kanonische 8-Datensaetze fehlen im Repo | ce eb0261f2 |
| USER-GATED Rest #244: kanonische 8-Datensaetze-Liste + Option A vs B Entscheidung | AUFGABE | Z20587 | OFFEN | - |
| AP-13/#247 IPinningPolicy-Teil v1 DONE: host-seitiges Mess-Thread-Pinning | FEATURE | Z20588 | GELANDET, CI-BEWIESEN | ce e9cf4f3f |
| AUFGESCHOBEN: P/E-Core-Auto-Erkennung + 3-ISA-Build-Matrix | AUFGABE | Z20588 | OFFEN | - |
| Nebenbefund: perm_runner VORBESTEHENDER lokaler Build-Bug (Include-Pfad-Defekt xml_reader.hpp) | REGRESSION | Z20588 | ERKANNT, nicht committet (User-Zone) | - |
| #258-Fix-Paket: 3 deterministische ce-Fixes (contract:conformance CMake-Kante, cppcheck-CTU False-Positive, MSVC-blinder abi-Namespace-Kollision mit cxxabi.h) | REGRESSION | Z20590 | BEHOBEN | ce d51ef9a0 |
| A2/T2-Befund: gcc-16-trunk+gcc-13.3 vorhanden, KEIN gcc-15/14; Pin NICHT deployt | UNKLAR | Z20590 | dokumentiert, Folgepunkt #272/Strang F | - |
| test_v41_anatomy_codegen lokal nicht baubar (VORBESTEHENDER Include-Pfad-Defekt) | REGRESSION | Z20590 | ERKANNT, wird mit CI-2 relevant | - |
| S7-2/#261 DONE: BTree-Pool-Familie, 2. honest-0-DEG echt gemacht | REGRESSION | Z20592 | BEHOBEN, CI-BEWIESEN (5/5) | ce 883a4ff1 |
| #268 CMD-2-Reserve-Pruefung: VERDIKT RESERVE-REICHT, 4->5-Bump wird von CMD-2 NICHT konsumiert | REGRESSION | Z20594 | GEKLAERT (kein Bump noetig) | - |
| S7-3/#261 DONE: SkipList-Pool, 3. honest-0-DEG echt gemacht | REGRESSION | Z20596 | BEHOBEN, CI-BEWIESEN (6/6) | ce dd704d67 |
| #271/DEG-5 DONE: perm_runner-CMake-Fix (libs/common Include-Pfad) | REGRESSION | Z20598 | BEHOBEN | ce 19d7f701 |
| S7-4/#261 DONE: Hash-Pool, 4. honest-0-DEG echt | REGRESSION | Z20600 | BEHOBEN, CI-BEWIESEN (7/7) | ce b9cc4fdb |
| S7-6/#261 DONE: HOT-Pool, 5. honest-0-DEG echt + Gesamtkarte 4 Original*-Familien | REGRESSION | Z20602 | BEHOBEN, CI-BEWIESEN (9/9) | ce 26461649 |
| S7-5/#261 DONE: ART-Pool, 6. honest-0-DEG echt (live_nodes ON-DEMAND) | REGRESSION | Z20604 | BEHOBEN, CI-BEWIESEN (10/10) | ce 83a51faf |
| S7-7/#261 DONE: START-Pool, 7. honest-0-DEG echt | REGRESSION | Z20606 | BEHOBEN, CI-BEWIESEN (11/11) | ce 67acf1f4 |
| S7-8/#261 DONE: Wormhole-Pool, alle 4 Original*-Familien fertig (8/10 gesamt) | REGRESSION | Z20608 | BEHOBEN, CI-BEWIESEN (12/12) | ce 514d8a88 |
| S7-9/#261 DONE: SuRF-Pool, 9. honest-0-DEG echt | REGRESSION | Z20610 | BEHOBEN, CI-BEWIESEN (13/13) | ce 810e2089 |
| S7-10/#261 DONE: MEILENSTEIN alle 10 S7-Pool-Familien echt (Swiss-A letzte) | REGRESSION | Z20612 | BEHOBEN, CI-BEWIESEN (8/8), Serie geschlossen | ce 3a5ae23c |
| 234-V GEPARKT: echter Architektur-Fork (Kette Baum->DLL reisst an 2 Stellen, keine dokumentierte Entscheidung per-Source vs CMake-Flag) | REGRESSION | Z20614 | GEPARKT/Eskalation, ZUR USER-ENTSCHEIDUNG (Option A empfohlen) | - |
| AP-15-2/#263 DONE: get_allocator als POD-Proxy (non-dagger) | FEATURE | Z20616 | GELANDET, CI-BEWIESEN (7/7) | ce 81d0b6bb |
| AP-15-3/#263 DONE: CRTP DriveableMapContract, #263 KOMPLETT | FEATURE | Z20618 | GELANDET, CI-BEWIESEN (6/6) | ce 4cc8c75e |
| #264/CI-2 264-a+264-a2 DONE: comdare_tests-Registry+Hermetik-Welle, EHRLICHES Suite-Inventar (erster Vollauf 184 Tests, 126 passed/58 failed) | REGRESSION | Z20620 | TEILWEISE BEHOBEN (5 Defektklassen geschlossen), 58 failed als Basis fuer 264-b/d dokumentiert | ce ce1af878, 8669210d |
| #264 264-b+#204-Teil DONE: test-Stage+test:unit-Probelauf (allow_failure), sanitize erweitert+neu tsan | FEATURE | Z20622 | GELANDET (advisory) | ce 3895a3a5 |
| #264 264-c+c2 DONE: prt-art 3 fehlende Header real + ECHTER Data-Race-Fund gefixt (LeafOnlyCounter lock-freie Map-Mutation) | REGRESSION | Z20624 | BEHOBEN (211/211, vorher Abort) | prt-art 8cb32fe |
| USER-DIREKTIVE Matrix-Reuse (bindend): Auslagerung bevorzugt in bestehende Module | OWNER-ENTSCHEID | Z20625 | FESTGELEGT | - |
| Pipeline STRIKT GRUEN nach jeder grossen Aufgabe; Fehler-Korrekturen MANUELL ohne Codex | OWNER-ENTSCHEID | Z20625 | FESTGELEGT | - |
| #258/#273 build:clang-Fix: super hatte kein Root-CMakeLists, Template cmake't Default -S "." | REGRESSION | Z20626 | BEHOBEN (Code/CMakeLists.txt + comdare_da_tools) | super 3d23d7ae |
| #274 MIGRATIONSPLAN-ENTWURF: comdare-metrics existiert bereits, treecore-all fuehrt ART/BPlusTree, 16-Schritt-Folge 12 GATED | AUFGABE | Z20627 | ENTWURF, wartet auf User-GO | - |
| NACHREVIEW Nacht-Commits KOMPLETT: 19 ce-Commits Zeile fuer Zeile nachreviewt | REGRESSION | Z20628 | VERIFIZIERT, BEFUND 0 Korrektur-Bedarf | - |
| #265 265-a DONE: foundation-Vendoring comdare::platform+comdare::simd (byte-identisch, MANUELL statt Codex) | FEATURE | Z20630 | GELANDET, CI-BEWIESEN (diff -r==0) | ce 80bfab51 |
| ci.skip-Regel KORRIGIERT: ci.skip-Pushes zaehlen als neuere Pipeline und cancellen laufende Jobs | REGRESSION | Z20634 | ERKANNT+KORRIGIERT (Kadenz-Regel angepasst) | - |
| USER-DIREKTIVEN nachmittags: Tests NIE manual (super test:unit auf AUTOMATISCH+HART) | OWNER-ENTSCHEID | Z20636 | FESTGELEGT/UMGESETZT | - |
| #276 Multi-Plattform-Support als LETZTE Ledger-Aufgabe eingebucht | AUFGABE | Z20636 | EINGEBUCHT (spaetere Prioritaet) | - |
| Runner-Fleet-Mandat: prod1 concurrent=2, node7 reaktiviert, K87-INFRA-HANDOVER H1-H9 | AUFGABE | Z20636 | UMGESETZT/dokumentiert | - |
| TEST-GRUEN-STRECKE super: 5 Alt-Fails+1 Skip-Maskierung gefixt (Fixture-Writer 15->16-Spalten, XML-Tags kanonisiert, config_dir Silent-Skip, GTEST_SKIP-Maskierung) | REGRESSION | Z20638 | BEHOBEN (ctest -L da_unit 100%/103) | super fe94eca, ce aeb27b88 |
| #277-Fortschritt: prod1 runners.cache von prod-MinIO auf dev-MinIO umgestellt (Versehen frueheren Agenten korrigiert) | REGRESSION | Z20640 | BEHOBEN | - |
| #267 CMD-1-a: Codex-Erstimplementierung AxisCommand-Concept + Voll-Review + manuelle Korrekturen | FEATURE | Z20642 | GELANDET (spaeter CI-bewiesen) | - |
| #258/K1 TEIL-DONE: Pipeline 8066 success, build:clang CI-bewiesen | FEATURE | Z20644 | GELANDET/BEWIESEN | - |
| GITLAB-STALL-WURZEL: Job-Finalisierungs-Stall (~5.5min je Job) wegen Sidekiq-Deferred-Queue mit 1956 Altlasten (DNS-Ausfall) | REGRESSION | Z20644 | BEHOBEN (Drain 1956->0, Finalisierung 5.3min->3.3s) | - |
| Runner-Freeze-Zwischenfall: prod1-Runner-Prozess fror Polling ein | REGRESSION | Z20646 | BEHOBEN (systemctl restart) | - |
| #277-Fortschritt: lint-Cache-Redesign (citools-Sammel-Cache archivierte KOMPLETT inkl. dl/, >1.3GB je lint-Job) | REGRESSION | Z20648 | BEHOBEN (per-Tool-Mini-Cache) | ci-templates d68050d5 |
| USER-KORREKTUR: #277-Lazy-Rules loeschten faelschlich trigger:thesis-Bridge ("Fehler beheben, nicht Test loeschen") | REGRESSION | Z20650 | ERKANNT+BEHOBEN (Revert) | super 2a34d00 |
| Diplomarbeit-TEXT-Architektur ist normative Referenz fuer Soll-Gesamtpipeline | OWNER-ENTSCHEID | Z20650 | FESTGELEGT | - |
| BEWEIS-DUO: Cache-Redesign End-to-End bewiesen + CMD-1-a in CI bewiesen (#267 DoD KOMPLETT) | FEATURE | Z20652 | CI-BEWIESEN | - |
| COMPLIANCE-VERMERK: TABU-AUDIT ueber Tagesarbeit, alle unberuehrt | UNKLAR | Z20654 | VERIFIZIERT (Selbstaudit, 0 Funde) | - |
| #278 A3 GEFIXT: module_loader-Fail wegen CMake lib-Praefix-Konvention (Mock-DLL Name-Mismatch) | REGRESSION | Z20656 | BEHOBEN | ce A3-Commit |
| #278-Serie: 2 Include-Wurzeln (view_composition.hpp ohne cstdint, axis_05 ohne strategy_base-Include) | REGRESSION | Z20658 | BEHOBEN | ce efe51d15 |
| #278 A2 GEFIXT: R6A_KeyRange-Fail war KEIN Generator-Bug (dokumentierter K7b-Insert-Pfad) | REGRESSION | Z20660 | BEHOBEN/KLARGESTELLT (Test-Vertrag praezisiert) | ce d5d3bb6f |
| #278 Klasse-B-Fix: 52 "Not Run" hatten EINE Wurzel (3 Standalone-foreach-Gruppen ohne COMDARE_TEST_TARGETS-Property) | REGRESSION | Z20662 | BEHOBEN | ce 53c3e937 |
| ce-test:unit-Strecke: Build brach nicht in 58 Laufzeit-Fails sondern im BUILD selbst (Codegen-Konsumenten-Liste, fehlende LIB, fehlendes Include) | REGRESSION | Z20664 | BEHOBEN (3 Commits) | ce b3d02002, e3e52f92, ec0ce62a |
| #267 CMD-1-b ENDSTATUS: komplett gruen | FEATURE | Z20666 | CI-BEWIESEN | ce 8093, super 8094 |
| MONITOR-LEKTION: Event-Monitor trackte nur neueste Pipeline je ref, Pipeline 8093 fiel aus Blickfeld | REGRESSION | Z20666 | ERKANNT+BEHOBEN (Redesign: alle nicht-terminalen Pipelines+Heartbeat) | - |
| K1-ENDSTATUS: ALLE 4 REPOS STRIKT GRUEN (erster harter CI-Gruen-Lauf da_unit-Suite ueberhaupt) | FEATURE | Z20668 | CI-BEWIESEN (100%/103) | - |
| OFFENE-PUNKTE-KONSOLIDIERUNG: K87b-Montags-Audit (H11 CoreDNS nur LIVE=Wiederholungsgefahr, H12 Sidekiq-Dead-Set, H13 queue_size, H18 Runner-Freeze) | AUFGABE | Z20670 | OFFEN (Infra-Audit-Liste) | - |
| ce-/tmp-Klasse+JUnit-Pfad (feste /tmp-Namen kollidieren, JUnit-XML no matching files) | REGRESSION | Z20670 | OFFEN (Task #24, spaeter teilweise behoben) | - |
| USER-DIREKTIVE #279 NEUER Katalogpunkt (vorletzte Aufgabe): Mess-Durchfuehrung im RELEASE-Modus VOR PDF-Erstellung; LUECKE CEB+Tier-Bau nicht dynamisch sichtbar | OWNER-ENTSCHEID | Z20672 | FESTGELEGT (neuer Task #279) | - |
| KORREKTUR CMD-1-a: MeasurementVisitable-Vorwurf "Scope-Ueberschreitung" war FALSCH (Dossier forderte es) | REGRESSION | Z20674 | KORRIGIERT (eigener Fehlbefund), Concept auskommentiert GEPARKT belassen | - |
| #278 EINZELFIX-SERIE finale 15: Pilot-DLL lib-Praefix, prefetch-Treiber Array256-Domaenen-Verletzung, CMD-1-b honest-0-Platzhalter eingeloest, d_v42_memory_layout-Kontrakt, migration_two_tier Spiegel-Eliminierung, /tmp-Kollisionsklasse | REGRESSION | Z20676 | BEHOBEN (7 Commits, lokal 164/164) | ce 9754d692, 861dce2d, b0f2a92f, 473301de, 074a97f9, 9cf14469 |
| LEHRE: Pipeline "success" mit allow_failure LUEGT (nur Job-Status zaehlt); lokal-gruen beweist bei Umgebungs-Klassen nichts | REGRESSION | Z20676 | ERKANNT als Prozess-Lehre | - |
| #278 ENDSTATUS HARTE GATES: JUnit-Report-Wurzel (ctest --output-junit relativ zu --test-dir, artifacts.paths fand nie was) | REGRESSION | Z20678 | BEHOBEN | ci-templates 4c603ec |
| thesis-lint W8/W36 begonnen (964->665): .chktexrc Dokument-Konvention, 251 als False-Positives klassifiziert | REGRESSION | Z20678 | TEILWEISE BEHOBEN | thesis 007405c, 75b95d9 |
| thesis-lint-STRECKE KOMPLETT: lint:latex HART 964->0 | REGRESSION | Z20680 | BEHOBEN, CI-BEWIESEN | thesis 4936e97, c740f20, 35b7d54 |
| #278 SCHLUSSSTEIN prt-art: sanitize:asan-ubsan HART, 0 allow_failure im GESAMTEN System (Ausnahme is_original:relock) | REGRESSION | Z20682 | BEHOBEN | prt-art 9c64b2a |
| LEKTION Cross-Projekt-auto-cancel: super-Welle canceled weil paralleler prt-art-Push deren Kind-Bridge auto-cancelte | REGRESSION | Z20682 | ERKANNT als Prozess-Regel (keine Pushes waehrend Beweis-Pipeline, auch projektuebergreifend) | - |
| #267 CMD-1-c+d: CMD-1(a-d) KOMPLETT (14 tote Command-/Visitor-Dateien entfernt, RuntimeMeasureVisitor->HostMeasureLoop) | FEATURE | Z20684 | GELANDET, CI-BEWIESEN (162/162) | ce 07a40255, 4983a554 |
| KORREKTUR CMD-1-c: super-Endwelle failed, compare_engine_command.hpp hatte uebersehenen Konsumenten in super | REGRESSION | Z20686 | ERKANNT+BEHOBEN (wiederhergestellt), MATRIX-WEIT-Lektion | ce 29ff5d2a |
| #265-b: AP-3-Follow-up-Konsum (ARM/sysfs-Laufzeitprobe via vendored comdare::platform) | FEATURE | Z20688 | GELANDET, CI-BEWIESEN (9/9) | ce 58387d32 |
| KORREKTUR #265-b: super-Welle failed (neue Include-Kante brach super-V32-TUs) | REGRESSION | Z20690 | ERKANNT+BEHOBEN, Matrix-weit-Regel gilt auch fuer neue Abhaengigkeiten | super 051661b |
| #12 SKIP-AUDIT matrix-weit: 1 echte Maskierung gefunden+gefixt (pdflatex-Smoke wertete rc!=0 als GTEST_SKIP statt Fehler) | REGRESSION | Z20692 | BEHOBEN | super b5dc671 |
| #266 GEPARKT per V3-Regel: Q2 config-Owner bleibt offenes User-Gate | AUFGABE | Z20694 | GEPARKT, Empfehlung config-all | - |
| AP-2-neu/#236 nach W4: Katalog-Pfad-E2E-Gate + Stub-Quarantaene (beweist echte Composition ohne Alt-Pfad-Marker) | FEATURE | Z20696 | GELANDET, CI-BEWIESEN (4/4, 165/165) | ce 19a10e37, prt-art 7d10003 |
| #184 Loader-Verdrahtung: Loader-Slot hatte keinen Aufrufer im Mess-Pfad | REGRESSION | Z20698 | BEHOBEN (4/4 Test) | ce test_184 |
| #269/#244 Bestands-Akten gegen ECHTE Dateien (english_words, pizzachili_dna) | FEATURE | Z20698 | GELANDET | - |
| EHRLICHKEITS-BEFUND: sosd_books_200M NICHT angereichert (Fetch truncatiert 580MB statt 1.6GB) | REGRESSION | Z20698 | ERKANNT, bewusst KEINE Fabrikation | - |
| GEPARKT 6-vs-48-Gate: 5 neue Datensatz-Akten + exakter Datensatz-Set + Binaer-vs-Text-Loader-Frage | AUFGABE | Z20698 | GEPARKT (Task #18), spaeter entschieden (s. G-6v48) | - |
| #270b 3-ISA-Teilmatrix INSTANZIIERT: build:arm64-smoke Job (opt-in, advisory) | FEATURE | Z20700 | GELANDET, CI-BEWIESEN neutral | ce 9fd24322 |
| GRUEN-BEWEIS BLOCKIERT: node7-Job-Acceptance-Freeze (online+idle, nimmt keine Jobs an) | REGRESSION | Z20700 | ERKANNT, GEPARKT an Task #23 Infra | - |
| #279-a non-gated Slice: konfigurierbarer Mess-Modus + Tier-Binary-Build-Sichtbarkeit (Modul Code/07_tier_binary_report) | FEATURE | Z20704 | GELANDET, CI-BEWIESEN | super 009ada3 |
| HOOK-KORREKTUR: §14.9 faelschlich "kein non-gated Slice mehr" war falsch (2 echte Slices existierten) | REGRESSION | Z20704 | ERKANNT+KORRIGIERT | - |
| #266-P3 Konsum-Kartierung DONE: comdare-memory NICHT vendorn (ce hat keinen konkreten Konsumenten-Bedarf) | REGRESSION | Z20706 | ENTSCHIEDEN (kein Vorrats-Gewicht) | - |
| USER-KORREKTUR 07.07.: axis_06/axis_03a sind Tier-Binary-KONSTRUKTIONS-Achsen, NICHT Mess-Achsen (getrenntes System) | OWNER-ENTSCHEID | Z20706 | FESTGELEGT (Begriffskorrektur) | - |
| C3 Kadenz-Abweichung: Codex-MCP auf prod1 shell-defekt (bwrap loopback RTM_NEWADDR) | REGRESSION | Z20708 | ERKANNT als Infra-Problem, manuell umgangen | - |
| USER-ENTSCHEID ~06:45: ALLE §14.1-GATES bestaetigt (G-Q2=config-all, G-234V-a=Option A, G-234V-b=Ja default-OFF, G-6v48=Thesis-tab:datasets kanonisch, G-7b3=axis_09b, G-270a=eigener Increment, G-AP15=Folge-Gattungen, G-268=KEIN ABI-Bump, G-274-GO=Migrationsplan wie empfohlen) | OWNER-ENTSCHEID | Z20710 | FESTGELEGT (9 Gates) | - |
| USER-PRUEFAUFTRAG Migration: wf_b770955b VERDIKT architektur-konform | FEATURE | Z20712 | VERIFIZIERT | - |
| MAJOR-Befund: test_cpuid_probe erwartete has_software_prefetch=FALSE auf aarch64, Probe setzt seit #265-b TRUE (arm64-Smoke waere rot geworden) | REGRESSION | Z20712 | BEHOBEN vor dem Montags-Beweis entschaerft | ce 655c0314 |
| MINOR-Befund: Modules-Klon comdare-cacheengine-all stale | REGRESSION | Z20712 | BEHOBEN (ff-only-Sync) | - |
| USER-ANTWORTEN F1-F14 + G-AP15-KONKRETISIERUNG: buildsystem.xml NICHT anfassen, BINDENDE VISION ISA+OS+Compiler-Beschleuniger-Buildsystem, NEUE ACHSEN-DOKTRIN Kopf-Framework-Interface je Achsen-Thema, Diplomarbeit lesen fuer Mess-Frameworks-x-Workloads-Matrix | OWNER-ENTSCHEID | Z20714 | FESTGELEGT (grosser Entscheidungsblock) | - |
| G-AP15 KONKRETISIERT: container-Gattung->comdare::container, Sequence NUR Planung, linked list+std-Container=weitere Container-TYPEN nicht eigene Gattungen | OWNER-ENTSCHEID | Z20714 | FESTGELEGT | - |
| GESAMT-GO Matrix-Migrationsplan: User gibt GO fuer gesamten #274-Plan (16 Schritte) UND alle G1-G12 Unter-GOs | OWNER-ENTSCHEID | Z20716 | FESTGELEGT (finale Freigabe) | - |
| 234-V-a DONE: Shaped-Emission Mechanik + btree_order-Beweis, default-OFF | FEATURE | Z20718 | GELANDET, CI-BEWIESEN (179/182) | ce 02e4df36 |
| Codex-MCP Wurzelursache bestaetigt (kernel.apparmor_restrict_unprivileged_userns=1) | REGRESSION | Z20718 | ERKANNT+umgangen (sandbox=danger-full-access) | - |
| G12 DONE: PAT-Migration Remote-URLs -> Credential-Helper (294 Repos, 296 Remotes tokenlos) | REGRESSION | Z20720 | BEHOBEN (Sicherheitsluecke geschlossen) | - |
| USER-KLARSTELLUNG Matrix-Taxonomie: DREIDIMENSIONAL Familien x Baseline-Stufen x MODULE, Research=Products mit gelockerten Eigenschaften | OWNER-ENTSCHEID | Z20722 | FESTGELEGT | - |
| GitLab-Gruppen-vs-Ordner-DIFF: 268/294 Repos weichen ab | REGRESSION | Z20722 | ERKANNT, keine Bewegung ausgefuehrt (wartet auf Konvention) | - |
| USER-ANTWORTEN A-E Matrix: Product-Familien comdare-<familie>-product, prt-art=Achsen-erweiterndes Modul IN ce-Familie | OWNER-ENTSCHEID | Z20724 | FESTGELEGT | - |
| GOALV2 GEFUNDEN: MATRIX-GRUNDLAGEN-GOALV2.md (lag Tiefe 5, auch User unbekannt) | UNKLAR | Z20724 | GEFUNDEN, deckt sich mit Praezisierungen | - |
| #274 SCHRITT 0 AUSGEFUEHRT: measurement-all Remote+Skelett angelegt | FEATURE | Z20726 | GELANDET | - |
| root master-token lag ~300 Remote-URLs offen | REGRESSION | Z20726 | ERKANNT als Sicherheitsrisiko (Rotation dringend, K88) | - |
| lint:static Leer-Fall: cppcheck exit1 bei NULL Quellen | REGRESSION | Z20726 | BEHOBEN (Leer-Guard im Template) | ci-templates 1b392a3 |
| MONITOR-LEKTION: Pipelines-API matcht ?sha= nicht als Praefix, Kurz-SHA machte Monitor blind | REGRESSION | Z20726 | ERKANNT (Kadenz-Anpassung) | - |
| BRANCH-DOKTRIN (User, fleet-weit): main=Default/stabil, development>=main, master nur loeschen wenn Subset | OWNER-ENTSCHEID | Z20728 | FESTGELEGT | - |
| OWNER-SAUBERUNG: root als DIREKTER Owner in ALLE 297 Projekte+46 Gruppen eingetragen | REGRESSION | Z20728 | BEHOBEN (vorher nur vererbt) | - |
| Fleet-Branch-Dry-Run: 160 master-AHEAD gefunden | REGRESSION | Z20728 | ERKANNT, Klassifikator angesetzt | - |
| #274 SCHRITT 2 VOLLZOGEN: Fleet-Branch-Konsolidierung (297 Projekte, 240 master beweisgefuehrt entfernt, 23 MRs gemerged) | REGRESSION | Z20730 | BEHOBEN | - |
| STRUKTUR-REGRESSION notiert: geteilte Klone statt Instanz-Repos (Opus-4.1-Ära); ALT-NAMING "redcomponent"+"bep" regressiv | REGRESSION | Z20730 | ERKANNT, eigenes #274-Arbeitspaket (nicht sofort behoben) | - |
| transiente GitLab-500er liessen 25 real befuellte Repos als "leer" erscheinen | REGRESSION | Z20730 | ERKANNT+BEHOBEN (API-Fehler != leer im Skript) | - |
| Infra-Befund: Runner-Fetch-Stoerung last-korreliert mit Massen-Konsolidierung | REGRESSION | Z20730 | BEHOBEN (Retry-Variablen fleet-weit) | ci-templates acd05ec |
| #274 SCHRITT 3 VOLLZOGEN: metrics-TRANSFER | FEATURE | Z20732 | GELANDET | - |
| AUTONOMER INFRA-FIX: dev-CoreDNS-Override zeigte auf tote IP, Registry 9 TAGE ohne Storage | REGRESSION | Z20732 | BEHOBEN | - |
| UMBRELLA-AUDIT-BEFUND: 8 Umbrellas tracken 21 Zellen-VOLL-Inhalte (Struktur-Fehler) | REGRESSION | Z20732 | ERKANNT+BEHOBEN (#33/#34) | - |
| #33+#34 VOLLZOGEN: 21 Voll-Zellen als eigenstaendige Repos gesichert, Gruppenstruktur-Spiegelplan (311 Projekte) | REGRESSION | Z20732 | BEHOBEN | - |
| #35 VOLLZOGEN: 6 behaltene master archiviert (Fleet 100% master-frei) | REGRESSION | Z20732 | BEHOBEN | - |
| OBJECT-STORE-VORFALL (Folgefehler CoreDNS-Fix): Artefakt-Uploads 500 (CoreDNS-Fix heilte :443, brach :9000) | REGRESSION | Z20734 | BEHOBEN, E2E-BEWIESEN (Pipeline 8837) | - |
| AUFSCHIEBE-AUDIT: 13-Stationen-Verkettung rekonstruiert, 4 neue Tasks #41-#44 erfasst | AUFGABE | Z20736 | ERKANNT/dokumentiert | - |
| #41 Schritt-5-REST pmc-Voll-Review (gtest-Tarball vendored, Entscheid noetig) | AUFGABE | Z20736 | OFFEN | - |
| #42 metrics-Zelle standalone DEFEKT (tests/CMakeLists fehlt) | REGRESSION | Z20736 | OFFEN, Fix in Schritt 6 geplant | - |
| #274 SCHRITT 5 VOLLZOGEN: comdare-pmc-Zelle live | FEATURE | Z20738 | GELANDET, CI-BEWIESEN (4/4) | - |
| INFRA-VORFALL: Pipeline-Sturm durch ~500 Branch-Anlagen (eigenverursacht), OOM-Verdacht widerlegt, prod2 HART DOWN | REGRESSION | Z20738 | ERKANNT+BEHOBEN (Cancel-Sweep), prod2 bleibt physisch offen | - |
| TEMPLATE-SAGA .lint-static ABGESCHLOSSEN: v3-Doppel-Beweis (find-Expansion Fix) | REGRESSION | Z20740 | BEHOBEN | ci-templates 2352bcf |
| #274 SCHRITT 6 VOLLZOGEN: HDR additiv IN comdare-metrics + #42-Fix | FEATURE | Z20742 | GELANDET, CI-BEWIESEN (280/280) | - |
| #274 SCHRITT 7 VOLLZOGEN: comdare-workloads live, Migrationsschritte 0-7 komplett | FEATURE | Z20744 | GELANDET, CI-BEWIESEN | - |
| #26 234-V-b VOLLZOGEN: Rest-Familien Shaped-Emission + binary_id-Shape-Segment + Baum->Emitter-Verdrahtung, default-OFF | FEATURE | Z20746 | GELANDET, CI-BEWIESEN (2/2) | ce fd767073, super f535e0c |
| #43 Handover-DOKUMENT: Alt-Matrix-CI strukturell defekt (fleet-weite Evidenz, Exoten-Runner-Timeouts) | REGRESSION | Z20748 | ERKANNT (Empfehlung schlanke Zellen-CI), Owner-Aufgabe | - |
| HO-B KORREKTUR: fruehere #38-Annahme "comdare-db-client-* fehlplatziert" war FALSCH | REGRESSION | Z20748 | KORRIGIERT (eigener Fehlbefund) | - |
| #27 7b-3 GEPARKT: echter Architektur-Fork (SwissTable REIN SKALAR, axis_09b ist KEIN Composition-Slot, Kollision mit User-Gate G-7b3) | REGRESSION | Z20750 | GEPARKT/Eskalation, ZUR USER-ENTSCHEIDUNG (Option B empfohlen) | - |
| #11/#266-P1 AUFGELOEST: comdare-config NICHT vendorn (kein konkreter Konsument) | REGRESSION | Z20752 | ENTSCHIEDEN, #266 vollstaendig aufgeloest | - |
| #29 Schritt 1 GEPARKT: Container-Gattung IST bereits voll gebaut (4 Genus Adapter/Set/Sequence/View); Spannung mit AP-15-Plan (Typen vs separate Genus) | REGRESSION | Z20754 | GEPARKT (Terminologie-Klaerung noetig) | - |
| #29 SCHRITT 1 VOLLZOGEN: comdare::container Kopf-Framework, additiv golden/ABI-neutral | FEATURE | Z20756 | GELANDET, CI-BEWIESEN (1/1) | ce 8ffc9c0c, super 2b610aa |
| OFFEN User-Gate: echte Umstrukturierung Set/Sequence->Typen statt eigener Genus | AUFGABE | Z20756 | OFFEN | - |
| #27 7b-3 Option B VOLLZOGEN: SwissTable-SIMD-Gruppen-Match als ISA-static-Methode, golden/ABI-neutral | FEATURE | Z20758 | GELANDET, CI-BEWIESEN | ce 9f60216f, super 94695b2 |
| 5 unautorisierte Codex-Scope-Creeps revertiert (abi_adapter -Wshadow u.a., alle pre-existing/CI-toleriert) | REGRESSION | Z20758 | BEHOBEN im Voll-Review | - |
| #25 VOLLZOGEN: 6er-Kanon-Datensatz-Akten, echte Pruefsummen (4 neue echte Akten via FNV-1a-64) | FEATURE | Z20762 | GELANDET, CI-BEWIESEN (3/3) | ce 0225396d, super 1f7976c |
| cppcheck forderte Default-Member-Init (uninitMemberVarNoCtor) | REGRESSION | Z20762 | BEHOBEN | - |
| STRUKTUR: ce-Framework-Modul-Klon war stale (ff-gesynct); Namespace-Verdacht widerlegt (kein 286-Transfer noetig) | REGRESSION | Z20763 | BEHOBEN/GEKLAERT | - |
| TASK-KONSOLIDIERUNG: #45 sosd-Loader, #46 Fleet-github-Sweep neu erfasst | AUFGABE | Z20765 | ERKANNT/dokumentiert | - |
| #29-Rest AP-15-Planung: Container-Typen-Planungsdoc 37 (weitere std-Container Taxonomie-Fork A/B) | AUFGABE | Z20767 | GEPLANT, Option A empfohlen, User-Wahl bei Realisierung offen | - |
| #31 F7 Mess-Frameworks x Workloads-2D-Matrix-PLANUNG (Doc 15) | AUFGABE | Z20769 | GEPLANT, Struktur-Fork A/B/C offen (Option A empfohlen) | - |
| #45 SOSD-Binaer-Loader VOLLZOGEN | FEATURE | Z20771 | GELANDET, CI-BEWIESEN (1/1) | ce 029a3e71 |
| g++-13/16 ICE-Segfaulten transient auf Cold-Cache-Builds (Runner-Instabilitaet) | REGRESSION | Z20773 | ERKANNT als Infra-Problem, nicht Code | - |
| #175 pmc:intel INFRA-SEITIG ENTSPERRT (Gate-Variable COMDARE_PROD2_AVAILABLE war false), prod2 wieder verfuegbar (NVMe-APST-Bug gefixt) | REGRESSION | Z20775 | BEHOBEN (Infra-Agent) | - |
| METAPROG-STRIKTHEITS-GUARD VOLLZOGEN: prospektiver Guard verankert compile-time-Striktheit als stehende Invariante | FEATURE | Z20776 | GELANDET, CI-BEWIESEN | ce 5c378082, super 16ab84d |
| FOLGE-Increment #50 VOLLZOGEN: Guard von Tier-Ebene auf ORGAN-Ebene ausgedehnt (26 Achsen) | FEATURE | Z20776 | GELANDET, CI-BEWIESEN | ce 2cb3cd34 |
| INFRA-RUECKMELDUNG: prod-Runner concurrency=3+-j10 ausgefuehrt (Infra-Agent) | REGRESSION | Z20779 | UMGESETZT | - |
| ICE-VERSCHAERFUNG: prod2 ist ICE-/OOM-Engpass, g++-ICE RAM-druck-korreliert (nicht nur Cold-Cache) | REGRESSION | Z20779 | ERKANNT/praezisiert | - |
| INFRA-FIX prod2 dev-MinIO-Cache: prod2 36% Job-Fehlerrate vs prod1 11% wegen totem MinIO-Endpoint | REGRESSION | Z20781 | BEHOBEN | - |
| prod2-Fix END-TO-END VERIFIZIERT | FEATURE | Z20783 | CI-BEWIESEN (Pipeline 9043) | - |
| POD-Guard #50-Rest vollzogen: 12 ABI-Transport-Snapshot-PODs zentral gebuendelt | FEATURE | Z20785 | GELANDET, CI-BEWIESEN (3/3) | ce 60a710a9 |
| Pipeline-rot war TRANSIENT: prod2 erster Cold-Build nach dev-MinIO-Umstellung | REGRESSION | Z20785 | BEHOBEN (1x Retry) | - |
| USER-FREIGABE 08.07.: ALLE angezeigten Board-TODOs freigegeben, STOP-Bedingung AUFGEHOBEN | OWNER-ENTSCHEID | Z20785 | FESTGELEGT | - |
| NEUER PFLICHT-PROZESS: VOR jedem TODO GESAMTES Ledger mit Agent lesen | OWNER-ENTSCHEID | Z20785 | FESTGELEGT | - |
| #31-Fork-AUFLOESUNG (User): Workload-Profile werden HYBRID compile-time+runtime, NICHT rein compile-time | OWNER-ENTSCHEID | Z20785 | FESTGELEGT | - |
| #31-Hybrid Schritt-1-VERSUCH gebaut+GRUEN, dann REVERTIERT: WorkloadProfile war dritter konkurrierender Workload-Enum (Wildwuchs) | REGRESSION | Z20787 | ERKANNT+BEHOBEN (revertiert) | ce 7c8692bd, super 43aa364 |
| PROZESS-LEHRE: Ledger-Agent VOR dem Bau abwarten, nicht parallel bauen | REGRESSION | Z20787 | ERKANNT als Prozess-Lehre | - |
| #31-Hybrid Schritt-1 KORREKT VOLLZOGEN via WorkloadKind-Reuse | FEATURE | Z20789 | GELANDET, CI-BEWIESEN | ce 88738285, super a2dce21 |
| Schritt-1b: Dataset-Achse D vollzogen (6 Workloads x 6 Datasets = 36 Zellen) | FEATURE | Z20790 | GELANDET, CI-BEWIESEN | ce 4d8aedce, super 434bfe0 |
| CI-Pipeline echt-rot: fruehere "transient"-Einschaetzung war FALSCH (User-Korrektur), Root-Job pmc:intel haengt 60min | REGRESSION | Z20792 | ERKANNT als eigener Fehlbefund, BEHOBEN (Kill-Switch) | ce 3fb7dea8 |
| Nachtrag: prod2 doch NICHT geheilt, Runner pausiert | REGRESSION | Z20793 | BESTAETIGT weiterhin defekt | - |
| ROOT-CAUSE GEFUNDEN: cmake/cc1plus gehen auf prod2 in permanenten uninterruptible D-state | REGRESSION | Z20794 | ERKANNT, Fix=prod2-Reboot ausserhalb meiner Rechte (Infra) | - |
| E0-E4-KONSOLIDIERUNG Phase 0+G2-Revert: workload_matrix.hpp (tote compile-time-Insel, E2-Fehlbau) entfernt | REGRESSION | Z20796 | BEHOBEN (Revert) | ce 8c73ef7c, super f01bdaa |
| Phase 4/#31 (E4-XML) GATED: Fork-Analyse korrigiert Fork-Rahmung, doppelt gated (User-Fork R1/R2 + main.cpp-Freeze) | AUFGABE | Z20796 | GEPARKT, wartet auf GO | - |
| Phase 1 (#230 run_profile-Produktiv-Fassade) gebaut, super-CI ROT | REGRESSION | Z20798 | GEBAUT dann REVERTIERT (Neubau-Spec liegt vor) | ce 698977fe |
| Phase 2 (#221 RC-Verdrahtung) gebaut CI gruen, dann Review fand 15 Mess-Defekte (8 CONFIRMED) | REGRESSION | Z20798 | GEBAUT dann REVERTIERT | ce 1f9c2eef |
| M0-Deep-Research: 5 RC-steuerbare Achsen, 14 honest-0-Achsen | FEATURE | Z20798 | ERHOBEN (Grundlage E1-Schicht) | - |
| USER-DIREKTIVE 09.07. SCHICHT-FERTIGSTELLUNG: E-Schichten nacheinander separat (Sequenz E4->E3->E2->M->E1->E0) | OWNER-ENTSCHEID | Z20798 | FESTGELEGT | - |
| Betriebsbefund: Task-/Agent-Store durch /goal+/model-Wechsel ZWEIMAL geleert | REGRESSION | Z20798 | ERKANNT (Prozess-Lehre) | - |
| SCHICHT E4 VOLLZOGEN: #230 produktiv + B4-1-XML-Eingang + E4-Contract-Test | FEATURE | Z20800 | GELANDET, CI-BEWIESEN | ce 03691aa8, super a170edf |
| Schicht-Review wf_ca5b3523: 9 Fixes manuell (kritisch: E4-Opt-in ohne Lastprofile waere mehrtaegiger Fehllauf mit exit0 gewesen) | REGRESSION | Z20800 | BEHOBEN vor Commit | - |
| SCHICHT E3 vollzogen: #223-STALE-Aufloesung (Gate war bereits geheilt, nur Beweis-Tests fehlten) | REGRESSION | Z20802 | KLARGESTELLT+bewiesen | ce 08322478 |
| Limits-Entkopplung bewusst NUR als Analyse geliefert | AUFGABE | Z20802 | GEPLANT (eigener GO-Increment) | - |
| KATALOG-BILANZ #253-#276 item-belegt: pauschale Bilanz vom Vortag jetzt verifiziert | REGRESSION | Z20804 | KORRIGIERT/verifiziert | - |
| SCHICHT E2 vollzogen: E2-ABI-Contract-Test + #188-Kommentar-Wahrheit (12 Dateien) | FEATURE | Z20806 | GELANDET, CI-BEWIESEN (8/8) | ce e0203341 |
| Schicht-Review wf_b69db553: 3 CONFIRMED Kommentar-Wahrheits-Defekte gefixt | REGRESSION | Z20806 | BEHOBEN | - |
| QUERSCHNITT M vollzogen: SystemAxis-Wurzel "Blut" + CMD-1-b | FEATURE | Z20808 | GELANDET, CI-BEWIESEN (10/10) | ce 2a231cf5 |
| Schicht-Review wf_f1604ba3: critical Fund (AxisCommand-Konjunkt haette observe_all fuer alle Referenz-Kompositionen gebrochen) | REGRESSION | Z20808 | BEHOBEN vor Commit | - |
| USER-DIREKTIVE 10.07.: VIERTER Modus = HYBRID-MODUS = ZIEL der Diplomarbeit (Heuristik-Optimierungs-Achse als eigene Systemachse) | OWNER-ENTSCHEID | Z20808 | FESTGELEGT | - |
| SCHICHT E1 vollzogen: #221 EHRLICH abgeschlossen (T6/T8/T1/T11-RC-Konsum) | FEATURE | Z20810 | GELANDET, CI-BEWIESEN (11/11) | ce 3ddbb0d6 |
| Schicht-Review wf_3017934d: critical Fund (quadratische Batch-Arbeit haette #156-Pipeline auf Wochen gestreckt) | REGRESSION | Z20810 | BEHOBEN vor Commit | - |
| SEQUENZ E4->E3->E2->M->E1 KOMPLETT | UNKLAR | Z20810 | STATUS-MEILENSTEIN | - |
| prod1-SYSTEMABSTURZ killte laufende CI-Jobs | REGRESSION | Z20812 | BEHOBEN (1x Retry, transient/Infra) | - |
| NACHZIEH-Korrektur (16.07.): #266-Q2 "offen"-Nennung war Re-Gating-Artefakt (bereits entschieden) | REGRESSION | Z20812 | KORRIGIERT | - |
| USER-FREIGABE "ALLE GO-INCREMENTS" + PLAN<->CODE-DIFF wf_d4d9e410: 4 voll implementiert, 56 offen (BACKLOG) | OWNER-ENTSCHEID | Z20814 | FESTGELEGT+ERHOBEN | - |
| STALE-KORREKTUR: "234-V gated/ungebaut" war falsch (bereits seit 08.07. vollzogen) | REGRESSION | Z20814 | KORRIGIERT (eigener Fehlbefund) | - |
| GO-INCREMENT 1 VOLLZOGEN: LIMITS-ENTKOPPLUNG VORSTUFE (Codegen-Tool + Golden-Gates 1-3) | FEATURE | Z20815 | GELANDET, CI-BEWIESEN (9/9) | ce fb67caa0 |
| Schicht-Review wf_fce92d2c: 2 CONFIRMED empirisch (Profil-Achsenordnung stumm normalisiert statt validiert, cacheline-ref stumm verworfen) | REGRESSION | Z20815 | BEHOBEN vor Commit | - |
| GO-INCREMENT 1b VOLLZOGEN: LIMITS-ENTKOPPLUNG PRODUKTIVUMSCHALTUNG Stufe 4-6 | FEATURE | Z20816 | GELANDET, CI-BEWIESEN (197/197) | ce fd8167f4 |
| IMPLEMENTIERUNGS-UEBERGANG Codex->Claude: Codex-MCP hing 1800s, ab sofort implementiert Claude selbst | OWNER-ENTSCHEID | Z20816 | FESTGELEGT | - |
| Review wf_1009d16f: 5 CONFIRMED (beide PS1-Wege stiessen Build-zeitigen Codegen nie an) | REGRESSION | Z20816 | BEHOBEN vor Commit | - |
| NON_GATED-2 VOLLZOGEN: PARSER-/GATING-KONSOLIDIERUNG Phase 7 (2->1 Reader) | REGRESSION | Z20817 | BEHOBEN | ce 90653f02 |
| Review wf_8508f98c: 10 CONFIRMED gefixt (masstree Entity-Dekodierung, Root-Fallback entfernt) | REGRESSION | Z20817 | BEHOBEN vor Commit | - |
| DATEN_GATED-VORBAU VOLLZOGEN: PHASE-6-REGISTRY + IMeasurementSource + E4'-Kurven-Skeleton | FEATURE | Z20818 | GELANDET, CI-BEWIESEN (199/199) | ce c022ce05 |
| Review wf_c99a2132: 14 CONFIRMED (1 critical, 4 major) gefixt | REGRESSION | Z20818 | BEHOBEN | - |
| USER-VISION DOKUMENTIERT: HEURISTIK-MESSKURVEN-TYPSYSTEM + FILTERKETTE + MONOLITH-DOKTRIN (Doc 20) | OWNER-ENTSCHEID | Z20819 | FESTGELEGT | - |
| KARDINALITAETEN-DEEP-RESEARCH: 71 Bestand-Befunde, 3 Kardinalitaets-Klassen, 7 User-Forks blockieren Typsystem | AUFGABE | Z20820 | ERHOBEN | - |
| AXIS-BINDING-REGISTRY GEBAUT->REVIEWT->VERWORFEN: Doppelquellen-Lehre | REGRESSION | Z20821 | ERKANNT+VERWORFEN (bewusst nicht committet) | - |
| 7 FORK-ENTSCHEIDUNGEN GETROFFEN (H1-H7) + Achsen-Utilization-Audit wf_73129d50 | OWNER-ENTSCHEID | Z20823 | FESTGELEGT | - |
| Achsen-Utilization-Audit: 16 Utilization-Luecken, telemetry FAELSCHLICH Organ-Slot T10 statt Root | REGRESSION | Z20823 | ERKANNT | - |
| 5 CI-gruene Increments (Phase 0.1 SIMD-Dispatch, Phase 0.3a COW-safe Memento-Pool-Store 3 Familien, E4' §C CoR-Filterkette) | FEATURE | Z20825 | GELANDET, CI-BEWIESEN | ce 8175c802, 96d5c422, 78334902, 21a9af74, 076b71cf |
| CMD-2/#252 GEBAUT: ContainerObserver E2-Sidecar, letztes Spur-S-Architektur-Item | FEATURE | Z20827 | GELANDET, CI-BEWIESEN (204/204) | ce 0b790034 |
| SELBSTKORREKTUR: Einordnung "CMD-2 = ABI-4->5-Bump = User-GO" war STALE (zweite Stale-Gating-Falle nach #221) | REGRESSION | Z20827 | KORRIGIERT (eigener Fehlbefund) | - |
| c2+c3-Skalar bewusst NICHT gebaut trotz Freigabe (waere Phantom, Anti-Phantom-Doktrin) | UNKLAR | Z20827 | bewusst nicht gebaut | - |
| #31 E4-XML-Workload-Drive GEBAUT: innerhalb Submodul-CI-Grenze re-architektiert (kein ce-Bump noetig) | FEATURE | Z20829 | GELANDET, CI-BEWIESEN | super 6f15a82 |
| Selbstkorrektur: #31 faelschlich als "infra-blockiert" abgelegt | REGRESSION | Z20829 | KORRIGIERT (eigener Fehlbefund), Loesung gefunden | - |
| GRENZEN-ROADMAP+SLICE1: best_binary_selector Produktionslogik war UNGETESTET | REGRESSION | Z20831 | BEHOBEN (Charakterisierungstest) | ce 22ddf94c |
| §B/§D bleiben genuin gated (Doppelquelle-Risiko), DD-A ABGELEHNT | REGRESSION | Z20831 | ANALYSIERT/abgelehnt (Risiko-Vermeidung) | - |
| SYSTEMATISCHE CHRONOLOGISCHE DISPOSITION F1-F14: alle Items belegt DONE/DIREKTIVE-befolgt/gated | UNKLAR | Z20833 | VERIFIZIERT (Meta-Audit) | - |
| PRAEZISIONS-KORREKTUR: build_axis_levels hat 1 statt 0 Nicht-Test-Aufrufer | REGRESSION | Z20833 | KORRIGIERT | - |
| T8-Phantom: thread_count meldete sich faelschlich als "applied" (Vertragsbruch) | REGRESSION | Z20835 | BEHOBEN | ce fa9f31ac, b3224369 |
| Ontologie T5/T16/T2: toter stride_pattern_tag entfernt, T16 Filter-Space-Seite, T2 Indirektionskosten reservierter POD-Slot | REGRESSION | Z20835 | BEHOBEN | ce 895546f4, 270c6c8c |
| CI-Submodul-Fetch REV17 GELOEST: git submodule update --init ueberschrieb submodule.url-Overrides | REGRESSION | Z20835 | BEHOBEN (Deploy-Token-URLs direkt in .gitmodules, 3 Vorversuche gescheitert) | - |
| #22 persist:measurements: merge-basierter Ruecktschreib-Job INERT-by-default gebaut+gemergt | FEATURE | Z20835 | GELANDET, CI-BEWIESEN | super 3a2d06d |
| #22 G-b/G-c/G-d VOLLZOGEN: sicherer Write-Token + Mess-Job scharfgeschaltet + Messlauf angestossen | FEATURE | Z20837 | GELANDET | super 47fb6dc, 0d86098 |
| PIPELINE END-TO-END mit ECHTEN golden-320-Daten VALIDIERT (5 Stufen, 0 Anomalien, 6480 Datenzeilen) | FEATURE | Z20838 | VERIFIZIERT | - |
| 2 KRITISCHE persist-Bugs gefunden+gefixt: .gitignore *.csv haette CSVs still gedroppt, measure_out mit ~320 DLL-Binaries haette Artefakt gebläht | REGRESSION | Z20839 | BEHOBEN | super 57f774f |
| NEUER AUFTRAG: CI-INTERAKTIVE DIPLOMARBEIT (Anhaenge automatisiert aus Messwerten) | OWNER-ENTSCHEID | Z20840 | FESTGELEGT | - |
| AUTOMATIONS-LUECKE: tabellen/*.tex auto-generated aber statisch committet, .ps1-Orchestrator = Behelfsweg | REGRESSION | Z20840 | ERKANNT | - |
| #24 INCREMENT 1: C++23 Code/08_appendix_generator ersetzt PowerShell-Behelfsweg | FEATURE | Z20842 | GELANDET, CI-BEWIESEN | super 0750c21 |
| INFRA-CONTENTION: Messlauf drosselt super-CI (tags:[baremetal] Mismatch mit bare-metal) | REGRESSION | Z20843 | ERKANNT, INFRA-HANDOVER noetig | - |
| #24 P6: Log-Farbskala der Latenz-Heatmaps (lineare Skala ueber 4 Dekaden saettigte) | REGRESSION | Z20844 | BEHOBEN | super df00e81 |
| #24 P4 SEMANTIK-DEEP-RESEARCH: Segment-Attribution-Zerlegung verifiziert, Phantom-Falle vermieden (Sigma seg vs total_ns unkommensurabel) | REGRESSION | Z20845 | ERKANNT+vermieden | - |
| #24 P4 GEBAUT: write_segment_attribution_stacked_bar | FEATURE | Z20845 | GELANDET, CI-BEWIESEN | super 69d7c93 |
| #24 P3: Latenz-Verteilung (write_latency_range_bar+write_latency_ecdf) | FEATURE | Z20846 | GELANDET, CI-BEWIESEN | super 8e46012 |
| #24 P2 SEMANTIK-DEEP-RESEARCH -> PHANTOM, NICHT gebaut: Space-Metrik honest-0 (0/162 populiert) | REGRESSION | Z20847 | ERKANNT, bewusst NICHT gebaut (Anti-Phantom) | - |
| #24 P5 + WRITER-BLOCK KOMPLETT: write_exchange_forest_plot | FEATURE | Z20848 | GELANDET, CI-BEWIESEN | super 2fb60a9 |
| #24 Inc-2a: appendix_generator konsolidiert ALLE Darstellungen (16 statt 12 .tex) | FEATURE | Z20850 | GELANDET, CI-BEWIESEN | super d1a476a |
| #25 Teil A: format_tex.py -> C++23 (Code/09_tex_formatter) | REGRESSION | Z20851 | BEHOBEN (Python-Behelfsweg abgeloest) | super 4a7fce2 |
| #25 Teil B DISPOSITION KORRIGIERT: fruehere Einschaetzung "praematur" war Lesefehler (codegen.cmake=672 Zeilen echte Logik) | REGRESSION | Z20851 | KORRIGIERT (eigener Fehlbefund) | - |
| #25 Teil B INCREMENT 1: Permutations-Codegen C++23 (opt-in cpp-Backend, byte-identisch zu cmake) | FEATURE | Z20852 | GELANDET, CI-BEWIESEN | ce 4fc267e |
| #25 Teil B VOLLSTAENDIG: per-Perm-Wrapper-Port, cpp-Backend = voller Bau-Ersatz | FEATURE | Z20853 | GELANDET, CI-BEWIESEN (byte-identisch) | ce f0f20acc |
| #24 CI-INTERAKTIVE SCHLEIFE MECHANISCH KOMPLETT: measure->Anhang-Regen->persist + ready-to-apply Thesis-Wiring | FEATURE | Z20854 | GELANDET, CI-BEWIESEN | super 2d232f7, e7ae375 |
| USER-INFO: i9-14900KS (prod2) GESTORBEN, RMA/Austausch, Rueckkehr erst ~September 2026 | REGRESSION | Z20855-20856 | HARDWARE-DEFEKT (kritisches Infra-Ereignis) | - |
| Konsequenzen prod2-Ausfall: pmc:intel/#175/P-E-Core-Messungen blockiert bis September, COMDARE_PROD2_AVAILABLE=false bleibt | REGRESSION | Z20860-20862 | BLOCKIERT bis September | - |
| Mess-Fleet-Planung: Hybrid-CPU-Klasse hat bis September keine freigegebene Messmaschine | AUFGABE | Z20863-20865 | OFFEN, User-Entscheid noetig (i7-1270P-Ausschluss re-evaluieren?) | - |
| Anhang-D-Faktenfehler Barnard/Capella (Xeon vs EPYC) | REGRESSION | Z20866-20868 | BEHOBEN | thesis 10.07. |
| HABICH-RUNDE 2: Struktur-Kritik (Inhalt top, Struktur mangelhaft trotz Runde 1), Konsolidierungs-Auftrag AP-H2-0..11 | REGRESSION | Z20871-20887 | ERKANNT, Refactor-Plan A-G persistiert | - |
| Direktive: Kap.2 STRIKT nur Stand der Technik/bekannte Konzepte, Kap.3 = eigenes Konzept, Software-Architektur strikt Kap.4 | OWNER-ENTSCHEID | Z20872-20878 | FESTGELEGT (Prof. Habich) | - |
| Direktive: E4->E0-Schichten + neue Pruef-Stufen in Thesis konsolidieren, Evaluation neu dimensioniert (heuristischer Gegenbeweis Hybrid-Modus) | OWNER-ENTSCHEID | Z20878-20880 | FESTGELEGT (Prof. Habich) | - |
| Alt-Gegenlese: 23-Punkte-Verlustliste gefunden (HOCH: Heuristik-§2.1.6, Cracking/learned-indexes, YCSB A-F, Workload-Begriffe) | REGRESSION | Z20895-20897 | ERKANNT, Wiederherstellung in Phase B | - |
| AP-H2-8 ERLEDIGT: fig:m-model-resizebox Upscale (12,4pt-Schrift) entfernt | REGRESSION | Z20898-20900 | BEHOBEN | thesis |
| Refactor-Phasen A-C VOLLZOGEN: Kap.2 entkernt (0 Eigenbegriffe), Kap.2 mit Nur-Bekanntem gefuellt (+8 Cites), §3.1 neu geframet + neue §3.3.4/§3.4/§3.6.2/§3.6.3 | FEATURE | Z20901-20908 | GELANDET (4 Commits) | thesis cbde82a, fea6143, 2307591, 9fd0ea7 |
| USER-QUALITAETS-DIREKTIVE: Informationsdichte+Research-Qualitaet gegen aeltere Fassungen pruefen, Voll-Abgleich literatur.bib (AP-H2-12) | OWNER-ENTSCHEID | Z20909-20916 | FESTGELEGT | - |
| Refactor-Phasen D+E+F VOLLZOGEN: Kap.4 ausgebaut (NEU 4.4 Contract-Tests, NEU 4.5 System-Achsen), 10 MITTEL-Verluste restauriert, heuristischer Gegenbeweis als 4. Eval-Dimension | FEATURE | Z20917-20923 | GELANDET | thesis cba5a04, bb6a4b4 |
| Refactor-Phase G VOLLZOGEN -> AP-H2-11 DONE: §1.5 Aufbau der Arbeit vervollstaendigt, SOTA-Begriffsdefinition nachgeholt, Anhang-Remaps | FEATURE | Z20926-20936 | GELANDET | thesis 60cb3c7 |
| AP-H2-12 VOLLZOGEN -> HABICH-RUNDE 2 KOMPLETT (AP-H2-0..12 alle DONE): Cite-Abgleich 162 Keys LOST=0, Gap-Report 33 Gruppen alle eingearbeitet, 2 sachliche Verzerrungen behoben | FEATURE | Z20941-20956 | GELANDET | thesis a457018, 1a0a6eb |
| AP-H2-13 VOLLZOGEN: Verlustliste NIEDRIG #16-23 KOMPLETT restauriert (GoF-Negativliste, Biomedizin-Provenienz, SPL-Feature-Mapping) | FEATURE | Z20965-20978 | GELANDET | thesis 4eeb83c |
| Ueberbreiten/Figuren-Regel ALLE geschlossen: 4 Figuren gestaucht, resizebox-Aufblasungen entfernt | REGRESSION | Z20979-20983 | BEHOBEN | - |
| Damit ist aus Habich-Runde 2 NICHTS mehr offen (weder Pflicht noch optional) | UNKLAR | Z20994 | STATUS-MEILENSTEIN | - |
| ALT-TASK-ABSCHLUSS: #87 AP-B3+#89 AP-B4+#90 AP-B5 alle DONE, Task-Board #59-#110 GESCHLOSSEN | FEATURE | Z20995-21016 | GELANDET | thesis 828310b, be4ac6a |
| Code-Diskrepanz §4.1: ABI-Header-Liste war code-widrig (search_engine/execution_engine sind Bibliotheken keine ABI-Header) | REGRESSION | Z21006-21009 | BEHOBEN (Nebenprodukt) | - |
| FRISCH-LESER-REVIEW VOLLZOGEN: 7-Leser-Panel 79 Befunde (11 HOCH/45 MITTEL/23 NIEDRIG), 73 eingearbeitet | REGRESSION | Z21019-21031 | BEHOBEN (73/79) | thesis 65e477a |
| best_binary_selector-Widerspruch Einleitung<->Fazit an Code-Wahrheit aufgeloest | REGRESSION | Z21023 | BEHOBEN | - |
| Vier-Linsen-Review: 30 offene session-lokale TODOs (REV-CXX/DATA/CI/TEX, 3 kritisch/19 hoch/7 mittel/1 niedrig) | REGRESSION | Z21039-21043 | ERHOBEN (nicht in diesem Eintrag gefixt) | - |
| SESSION-ABSCHLUSS 13.07.: letzte Rest-Punkte erledigt (Acht-zu-Sechs-Beziehung der Pruefling-Bausteine aufgeloest) | FEATURE | Z21044-21051 | GELANDET | thesis c2d3c51 |
| Text-Agent-Stand ALLES geschlossen, einziges Gate = Kap.5-Ergebnisteil (wartet auf #156) | UNKLAR | Z21050-21051 | STATUS-MEILENSTEIN | - |
| GITLAB-AUSFALL 13.07.: gitlab.comdare.de liefert HTTP 404 | REGRESSION | Z21052-21056 | ERKANNT, GitLab-Push steht aus (GitHub synchron) | - |
| GITLAB-AUSFALL AUFGELOEST: Ursache war Realm-Split-Migration (.local statt .de) + keeper-root-PAT-Rotation, kein echter Ausfall | REGRESSION | Z21058-21066 | BEHOBEN, Push nachgeholt | super cc4582a-ebe6498 |
| F12i offizieller messung_driver-Binary-Bau: brach an -mcx16-Fehler (globaler snmalloc-Flag ohne INTERFACE-Belange fuer alle Ziele) | REGRESSION | Z21067-21076 | ERKANNT (Fix im Folgeeintrag) | - |
| F12i Fix: directory-scope link_libraries(comdare::vendor_snmalloc) direkt neben mimalloc | REGRESSION | Z21077-21093 | BEHOBEN, CI-BEWIESEN (--validate rc0/rc1/rc5, golden 320 unveraendert) | ce 730831d2 |
| NACHT-AUDIT 05.07. R1: adversariale Schaden-Suche, KEINE Git-Schaeden gefunden | REGRESSION | Z21099 | VERIFIZIERT kein Schaden | - |
| SCHADEN AUSSERHALB GIT: 6 GitHub-Remotes per gh repo delete geloescht (Loesch-Audit uebersah Klone im Baseline-Matrix-System) | REGRESSION | Z21100 | ERKANNT, User hat wiederhergestellt (Web-Restore+OneDrive) | - |
| LEHRE: Remote-Repos NIE loeschen ohne expliziten User-Auftrag JE Repo, vor Loeschung Matrix-System auf Klone pruefen | OWNER-ENTSCHEID | Z21100 | FESTGELEGT (neue harte Regel) | - |
| CI-Befund kritisch: KEIN Nacht-Commit ab 996adc74 CI-geprueft (Runner-Stau), 2 deterministische ce-Ursachen | REGRESSION | Z21101 | ERKANNT (spaeter behoben via #257-Fix-Paket) | - |
| GOAL V1 nicht terminiert: 7 Gruende analysiert (unerfuellbare Zielsetzung, keine Entscheidungs-Defaults, keine Stop-Bedingung, Runner-Stall-Kollision, keine Live-Edit-Kollisionsregel, Ledger-Widersprueche, kein Hygiene-Schlussprotokoll) | REGRESSION | Z21107 | ERKANNT als Prozess-Meta-Analyse | - |
| A1 (Modul-Ursprung KORRIGIERT 05.07.): 6 cacheengine-Module gehoeren NICHT als eigene Familie, sondern zu comdare-db/buildsystem | OWNER-ENTSCHEID | Z21171 | FESTGELEGT | - |
| A2 (Ownership): Owner aller Module = BEP Venture UG/Comdare, Interfaces STABIL | OWNER-ENTSCHEID | Z21172 | FESTGELEGT | - |
| A3 (Namespace): generisch comdare::<modul> + Uebergangs-Alias | OWNER-ENTSCHEID | Z21173 | FESTGELEGT | - |
| A4 (Include-Layout): entscheidet jeweiliger Untermodul-Owner | OWNER-ENTSCHEID | Z21174 | FESTGELEGT | - |
| A5 (Branch): development ja, main/master auf einen main konsolidieren | OWNER-ENTSCHEID | Z21175 | FESTGELEGT | - |
| A6 (Umbrella KORRIGIERT): Umbrella=Kategorien nach Funktionalitaet nicht Projekte, cache-engine->buildsystem-Fraktion, KEIN comdare-cacheengine-all | OWNER-ENTSCHEID | Z21176 | FESTGELEGT (spaeter 08.07. praezisiert, s. Namespace-Verdacht-Widerlegung oben) | - |
| F-S7-b DOKU-STELLE ANGELEGT: Architektur-Sektion Doc 30 §8.2, W2-Luecke Task #19 erledigt | REGRESSION | Z21163 | BEHOBEN | ce 41ab5522 |
| S7-1/#261 DONE: BST-Pool A-Param + T6-DEG-Route, erster DEG-Zaehler der Pool-Familien | REGRESSION | Z21165 | BEHOBEN, CI-BEWIESEN (4/4) | ce ec1ffb34 |
| AP-7b/#262 DONE bis auf 7b-3: SwissTableOrgan Weg-B, 10. Pool-Familie | FEATURE | Z21166 | GELANDET (7b-3 spaeter separat geloest, s. #27 oben) | ce a4e7c59f, c9a7e44e |
| Neue User-Direktive: JEDES Codex-Artefakt nach Fertigstellung VOLL manuell reviewen | OWNER-ENTSCHEID | Z21166 | FESTGELEGT | - |
| A7 (metrics/measurement KORRIGIERT): "comdare-cache-engine-all" ist als Name VERBOTEN | OWNER-ENTSCHEID | Z21177 | FESTGELEGT | - |
| B1 (AP-2): eigene Lead-Empfehlung war FALSCH, PRT-ART ist ABSTRAKT und wird zur COMPILE TIME als Library geladen | REGRESSION | Z21179 | ERKANNT (eigener Fehlbefund korrigiert) | - |
| D4 (AP-15-Scope): nicht explizit beantwortet | UNKLAR | Z21186 | OFFEN zum Zeitpunkt (spaeter geklaert, s. G-AP15) | - |
| W1-W5 ultracode-Architektur-Verifikation: B+-Experiment-Baum als Loesungsweg fuer S7-Threading bestaetigt (kritische Restluecke 234-V DEFERRED), memory_layout-Achse autoritativ fuer flat bestaetigt (Pools noch nicht, L=Node-Array-Backing-Politik als SOLL identifiziert) | REGRESSION | Z21193-21206 | ERHOBEN (Grundlage fuer spaetere Landungen S7-Serie und 234-V) | - |
| AP-15-1/#263 T1 DONE: 17-Dagger-Gate (RF1-RF14) | FEATURE | Z21240 | GELANDET, CI-BEWIESEN | ce c4eb7d7f |
| Voll-Review fing Codex-Mojibake (UTF-8-Kommentare doppelkodiert trotz gruener Claims) | REGRESSION | Z21240 | BEHOBEN, neue Pflicht-Kadenz (grep Mojibake=0) etabliert | - |
| #273 T1 DEPLOYED: .toolchain-probe + .build-clang-latest (Compiler-Inventar) | FEATURE | Z21243 | GELANDET | ci-templates b919bc8 |
| Credential-Befund: ~/.git-credentials ohne GitLab-Eintrag, WCM einzige lebende Quelle | REGRESSION | Z21244 | ERKANNT (Infra-Empfehlung Rotation) | - |
| super-Pipelines waren nach #273-Rollout TOT (0 Jobs, stage:build existiert im super nicht) | REGRESSION | Z21246 | BEHOBEN (stage:analyse-Override) | - |
| ce contract:conformance+lint:static rot: vorbestehender Include auf nicht-existente Legacy-Datei | REGRESSION | Z21246 | ERKANNT, an Abteilung uebergeben | - |
| W1-W5 OFFEN-Liste (05.07.): 234-V-Materialisierung, Baum-Pruning, S7-Serienplan, L-Semantik-Doku, 7b-3-Kopplung, m3v2-Artefakt-Stand, PRT-ART-Restfragen, Schichten/Datensatz-Restfragen | AUFGABE | Z21229-21239 | ERHOBEN als Luecken-Katalog, GROSSTEILS spaeter geloest (S7-Serie, 234-V, 7b-3, s.o.) | - |
| GOAL-TEXT V3 (KONSOLIDIERT 06.07., wf_4a092c79): 58 Korrekturen (7 BLOCKER/35 STATUS-STALE/16 NACHRICHTLICH) + 27 geschlossene Punkte, konsolidiert Vorrang-Regel+Kadenz+TABUs | OWNER-ENTSCHEID | Z21248-21286 | FESTGELEGT (06.07.), SUPERSEDED durch V4(12.07.)->V5(15.07.) [Nachzug 16.07.] | - |
| GOAL-V3-ERGAENZUNG (07.07.): #274/#256-Matrix-Migration als gleichrangiger Goal-Bestandteil, 5 normative Referenzdokumente geladen | OWNER-ENTSCHEID | Z21259-21266 | FESTGELEGT | - |
| node7-rpi5-arm64 reproduziert denselben Runner-Job-Acceptance-Freeze wie prod1 (stuetzt H18-Server-These) | REGRESSION | Z21309 | ERKANNT, staerkt Diagnose (Freeze nicht maschinenspezifisch) | - |
| INC-5 (Live-Token Projekt 289) + INC-6 (2 inerte CI-Writeback-Stages) an Infra-Agent DELEGIERT (User-GO 14.07.) | AUFGABE | Z21395 | DELEGIERT, Impl-Seite pausiert bis Infra liefert | - |
| G5-Vorlage-Workflow wf_800861e9 AM FABLE-529 GESTORBEN (0 Output) | REGRESSION | Z21403 | ERKANNT, neu gestartet mit Opus | - |
| F12(iii) ABI-Interface-Grenzen: Design-Session noetig (telemetry-Phase-6+Subject-Rename+Container-POD beruehren alle ABI) | AUFGABE | Z21412 | OFFEN, User-Entscheidung noetig | - |
| SUPERSEDED-Vermerk 19.07.: v32-Strang NICHT zurueckbauen, sondern als offizielles Planer-Skelett wiederverwendet (Fork A/PL-0) | OWNER-ENTSCHEID | Z21439 | FESTGELEGT (Korrektur einer frueheren Plan-Annahme) | - |
| NACHZIEH-BOARD 16.07.: mehrere restaurierte verlorene Punkte (#34 honest-100%-Audit war aus allen Boards gefallen, axis_05-IMC-Runtime-Heuristik lebte nur als Code-Kommentar, G7-Vorlauf alloc_hw-Codegen-Baeckung fehlte, Branch-Hygiene ci-test-ce-bump rot auf origin) | REGRESSION | Z21460-21466 | ERKANNT als Tracking-Luecken, ins Board nachgezogen | - |
| §16.1-C1 SUPERSEDED-Vermerk 19.07.: "2 Registries" praezisiert zu DREI art-spezifischen Achsen-Registries je Modul (Organ+System+Mess) | REGRESSION | Z21493 | UEBERHOLT/PRAEZISIERT | - |
| §16 FINALE ENTSCHEIDUNGS-KONSOLIDIERUNG 16.07.: Nachhol-Dokumentation vieler bereits gefallener Owner-Entscheide (2-Registry-Kanon, Experiment-Planer als 3. Framework-Anwendung/versteckte root-Minimal-Binary, I2-registry_dir-Fork Option c, PRT-ART=Modul der CacheEngine) an einer autoritativen Stelle gebuendelt | OWNER-ENTSCHEID | Z21479-21516 | FESTGELEGT (Konsolidierung bereits bekannter Entscheide, teils bereits als Bruecke I1-I7 gelandet) | - |
| §16.2-M1: Mess-Modi Debug-parallel/Mess-1-Thread, perf auf beiden prod-Clustern, Planer generiert CI ODER cmake synchron | OWNER-ENTSCHEID | Z21521-21525 | FESTGELEGT (Nachhol-Dokumentation, vorher nur Memory) | - |
| §16.2-M2: Serialisierung flach(Systemachsen-Ordner)/tief(Tier-Achsen+CSV-Baum), NUR dynamische Unter-Achsen als Spalten, Reihe C=Option C (beides: SdT-Vergleich + Build-Regression) | OWNER-ENTSCHEID | Z21527-21531 | FESTGELEGT (Nachhol-Dokumentation) | - |
| §16.2-M3: Zwei-Phasen-Op-Schleife (save-warmup-rollback-measure) 3x wiederholt, #225=kein neuer Grundsatz | OWNER-ENTSCHEID | Z21533-21537 | FESTGELEGT | - |
| §16.3-F3i: Reihe C=Option C (beides), KEINE 4. Stufe, KEIN 4. MergeStrategy-Enum (bleibt bei 3) | OWNER-ENTSCHEID | Z21560-21564 | FESTGELEGT (Nachhol-Dokumentation) | - |
| §16.3-E17: P/E-Core separate Systemachse, aber DYNAMISCHE Unter-Achse unter Hardware-Systemachse (H-1 wie empfohlen), loest GEPARKT-Status auf | OWNER-ENTSCHEID | Z21567-21570 | FESTGELEGT (Nachhol-Dokumentation, echte Ledger-Luecke ohne Memory) | - |
| §16.3-E18: Set = eigenes Genus mit eigener ABI, Gattungen non-intersecting aber mutual-use; F1b=ABI/golden-GO GEWAEHRT (MAJOR, koordiniert mit 4->5-Bump #37) | OWNER-ENTSCHEID | Z21572-21579 | FESTGELEGT (Nachhol-Dokumentation, echte Ledger-Luecke) | - |
| §16.4-G5: G5/#274 measurement-all-Migration ans PROJEKTENDE verschoben (nach Comdare-Prinzip: erst wenn Diplomarbeit+Cache Engine stehen) | OWNER-ENTSCHEID | Z21585-21589 | FESTGELEGT (Nachhol-Dokumentation) | - |
| §16.4-E19: Loeschpolitik=(a) behalten, bei neuen Loeschzielen zuerst fragen (gated, kein pauschales Lösch-GO) | OWNER-ENTSCHEID | Z21591-21595 | FESTGELEGT (Nachhol-Dokumentation, Praezisierung) | - |
| Bau-Freigabe INC-0 ERTEILT ("BAU freigegeben"); DUAL-VERIFIKATIONS-DIREKTIVE (CI+lokal parallel) danach GEPARKT bis Projektabschluss (lokal-first) | OWNER-ENTSCHEID | Z22015 | FESTGELEGT | - |
| Bau-INC-1 Rulings: Q1 CebSystemAxis als Axis<Derived>-Konzept unter gemeinsamem Dach; Q3 Compiler=VOLLE 5. System-Achse; Q2=Option C (CEB permutiert simd_extension SELBST zur Laufzeit, 6. Systemachse Erweiterungshardware) | OWNER-ENTSCHEID | Z22016 | FESTGELEGT, VOLLES GO fuer Bau-INC-1 | - |
| Bau-INC-1 GEBAUT+VERIFIZIERT: 6 CEB-System-Achsen als compile-time-Schicht (Dach, Scheduling, ExtensionHardware, HardwareIsa, LoadFramework, Compiler) | FEATURE | Z22017 | GELANDET, CI-BEWIESEN (6 Commits) | ce 0bca27d3-f748a37f |
| STRANG-THESIS: Anhaenge B+E im Thesis-Submodul autoriert (aus realem Baum) | FEATURE | Z22018 | GELANDET lokal, Push ausstehend | thesis 61f2557, 66cf85c |
| @SYNC-1-FREIGABEN: W3=A (golden-Neu-Materialisierung eigenes Bau-INC-3), Bau-INC-2 FREIGEGEBEN, Thesis-Push freigegeben | OWNER-ENTSCHEID | Z22019 | FESTGELEGT | - |
| INC-2-Bau 2a+2b: 2a Pruef-Dock scharf; 2b DER KOORDINIERTE ABI-BUMP 4->5 (Magic .A5.), Alt-golden additiv erhalten, Loader-Ablehnung als Regressionstest | FEATURE | Z22020 | GELANDET, CI-BEWIESEN (273/273, 55 Messzeilen end-to-end ueber ABI-5-DLL) | ce 5ee005af, 86769bc9 |
| Neue User-Doktrin: alt-golden-320 darf fuer Wartbarkeit brechen, erst additiv, Aufraeumen nur unter Absprache | OWNER-ENTSCHEID | Z22020 | FESTGELEGT | - |
| INC-2c: Telemetrie aus Komposition herausgeloest (19->18 Slots), sizeof 1416->1344 (Delta -72), ABI-Major bleibt 5 | FEATURE | Z22021 | GELANDET, CI-BEWIESEN (272/273, adversarialer Konformitaets-Richter COMMIT_OK) | ce 5fe811db |
| 1 roter Test test_all19_segment_timer (memory_layout-Sensitivitaet >5%, orthogonal/vorbestehender Cache-Line-Effekt) | REGRESSION | Z22021 | ERKANNT, Fix geplant in INC-2c.opt (Option A) | - |
| User-Klaerung: "bis 5%" gehoeren zur COMPILER-Systemachse nicht memory_layout; Ruling Option A: Optimierungsstufe wird Hardware-System-Achse-Flag statt hartkodiert -O2 | OWNER-ENTSCHEID | Z22022 | FESTGELEGT | - |
| INC-2c.opt Bauplan-Dossier verortete Optimierungsstufe FALSCH als Geschwister-Achse (Verstaendnisfehler) | REGRESSION | Z22023 | ERKANNT als eigener Fehlbefund, vom User als schlecht bewertet | - |
| KORRIGIERTE VERORTUNG F1/F2/F3-RULINGS: Optimierungsstufe=dynamische Unterachse unter Compiler-Hauptachse; F2 VOLL {O0..Ofast}+HW-Erweiterungs-Unterachsen; F3 XML-konfigurierbar, "global" existiert nicht | OWNER-ENTSCHEID | Z22023 | FESTGELEGT | - |
| INC-2c.opt NEUPLANUNG OF-1/2/3-RULINGS: OF-1 CPU-Erweiterungen=Compiler-Unterachse, GPU/FPGA=eigenes dyn. System-Hauptachsen-Array; OF-2 Default=Ofast statt -O2, XML ranges/batches/einzeln beweglich; OF-3 Compiler-Hauptachse traegt parallele Unterachsen (opt_level/flags/commands/CPU-SIMD) | OWNER-ENTSCHEID | Z22024 | FESTGELEGT | - |
| ACHSEN-NACHSCHLAGEWERK abgelegt: 172 Achsen-Eintraege Uebersicht (System/Organ/Gattung/Mess/Build) | FEATURE | Z22025 | GELANDET (Dokumentation) | - |
| CI WIEDER ONLINE + DUAL-VERIFIKATIONS-DIREKTIVE REAKTIVIERT (CI+lokal parallel wieder Pflicht) | OWNER-ENTSCHEID | Z22026 | FESTGELEGT | - |
| CI-ROT SIMD/AVX512-Configure-Bug: check_cxx_source_runs setzt Variable auf leeren String bei run-failure, 4 ungequotete Aufrufe kollabieren Arg-Zaehlung, prod2(Intel ohne AVX512) reisst Configure | REGRESSION | Z22027 | BEHOBEN (Quoting-Fix, honest-100%-Verletzung: gruen-AMD/rot-Intel war Schein-Gruen) | ce 355faa7f |
| XML->CI-AUTOMATISIERUNG VERSTANDEN: es gibt KEINE XML->CI-Generierung, .gitlab-ci.yml ist HAND-geschrieben (Soll=F5-Planer-Codegen) | UNKLAR | Z22028 | KLARGESTELLT (Ist-Stand-Feststellung) | - |
| CI-ROT test:unit Layout-Check behoben via INC-2c.opt-a: opt_level-Unterachse unter Compiler-Hauptachse, O3 auf test_all19_segment_timer | REGRESSION | Z22029 | BEHOBEN (-33% bis -42% stabil, Deep-Research-Vorhersage bestaetigt) | ce e8c32ecb |
| CI-DIREKTIVE VERSCHAERFT: gesamte Pipeline IMMER hart gruen (jeder Job, jede Maschine, kein allow_failure-Freibrief) | OWNER-ENTSCHEID | Z22030 | FESTGELEGT | - |
| ARCHITEKTUR-GAP FEHLERKLASSIFIZIERUNGEN FEHLEN (PFLICHT-Direktive): Fehlerklassen fuer alle Achsen->Unterachsen->Algorithmen Pflicht | OWNER-ENTSCHEID | Z22031 | FESTGELEGT (grosse neue Anforderung) | - |
| CI-ROT boost/mp11-Compile-Fehler: test_v41_scan_range_organ nicht gegen Boost::mp11 gelinkt (System-Boost maskierte lokal) | REGRESSION | Z22032 | BEHOBEN | ce 245ab4fe |
| CI-ROT boost/mp11-Straggler 2/2: test_m_contract_system_axis_wurzel (Audit-Blindfleck add_executable statt comdare_add_test) | REGRESSION | Z22033 | BEHOBEN, Lehre: Sibling-Audits muessen beide Erzeugungsmuster erfassen | ce a87d6d5b |
| super-Status failed wegen trigger:cache-engine haert auf branch:main, ce-main 114 Commits hinter development | REGRESSION | Z22034 | ERKANNT, Entscheidung erforderlich (Merge vs. Akzeptieren) | - |
| ENTSCHEIDUNG (A) VOLLZOGEN: ce development->main FF-Merge, GESAMTE Pipeline (ce dev+main+super+3 Downstreams) hart-gruen | REGRESSION | Z22035 | BEHOBEN (FF-Merge, main stets Vorfahr gewahrt) | ce 22ddf94c-a87d6d5b |
| Bau-INC-2c.opt-b GEBAUT: opt_flag-Kanal, -O2 als transitionaler Fallback, Byte-Identitaet via .rsp-cmp statt .so-sha256 | FEATURE | Z22036 | GELANDET, CI-BEWIESEN (236/236, g++ UND clang) | ce 3b7a83df |
| Bau-INC-2c.opt-c GEPLANT+GEBLOCKT auf OF-2-KERN-Entscheidung: Ofast bricht IEEE-754-Determinismus fuer golden-Mess-Binaries | AUFGABE | Z22037 | GEPLANT, PAUSIERT auf User-GO (Lesart A vs B) | - |
| Fehlerklassifizierungs-Framework (Task #29) GEPLANT: "failed"-Literal existiert NIRGENDS, Bruch von "Messung nie als Nullen" (perm_runner schreibt genullte POD-Zeile) | REGRESSION | Z22038 | ERKANNT+Design-Vorlage geplant (D1 CompilerCompilerErrorClass, D2 SampleStatus) | - |
| OVERNIGHT-5-BUILD-LAUF VOLLZOGEN: INC-29.0 axis_error-Taxonomie, opt-c-Uebersetzer, INC-29.1/D2 SampleStatus+CSV"failed", INC-29.2/D1 CMake-Warner, INC-29.1b Log | FEATURE | Z22039 | GELANDET, CI-BEWIESEN (5 Commits, je 241/241) | ce 428d639f, efd9060a, 122c1783, f9c208e3, 70ae091c |
| A1/A2/A3-RULINGS 18.07.: A1=CEB-Default O3 nicht O2/Ofast (vorheriger O2-Pin war Fehler); A2=Layering-Hybrid; A3=opt_level als XML-Liste/Range | OWNER-ENTSCHEID | Z22040 | FESTGELEGT | - |
| opt-Arc-KORREKTUR-BAU: opt-c-O3-Korrektur (O2-Byte-Anker entfernt), opt-d (-fno-gnu-unique als Facade-Wert), d1-carrier+d1-log (BuildResult.outcome=std::expected) | FEATURE | Z22040 | GELANDET, CI-BEWIESEN (241/241, g++ UND clang) | ce 504f8234, cfe736d9, 2a714a7d |
| Echter Architektur-Verstoss gefunden: Verzeichnis-ZYKLUS builder<->measurement (measurement/system_axis.hpp -> builder/pmc_source.hpp) | REGRESSION | Z22040 | ERKANNT, gesonderte User-Absprache noetig (A2-Neben) | - |
| PRAEZISIERUNG 02.08.: "Fehlerklassen-Framework end-to-end verdrahtet" galt NUR fuer Naht-Ebene, Achsen-/Unterachsen-Ebene = 0% umgesetzt | REGRESSION | Z22041 | KORRIGIERT (eigener Overclaim) | - |
| INC-0 DLL-Load Option B GEBAUT+VERIFIZIERT: link_libs-Kanal, mi_malloc_aligned jetzt definiert (T statt U), 105 echte Messzeilen, 26 snmalloc-Sweep-Zellen fehlerfrei | FEATURE | Z22043-22048 | GELANDET, lokal-doppelt verifiziert (6/6, 140/140), CI-Nachzug ausstehend | ce 418e4b76 |
| B3: cpuid_probe.hpp IST-Luecken fuer H-1/H-7/H-9 (Leaf 0x1A nie aufgerufen, physical_cores/logical_cores nie befuellt) | REGRESSION | Z22053 | ERKANNT, Empfehlung sysfs fuer INC-1 | - |
| §21.A BRUCH-RULINGS 18.07.: golden_fullpilot_320/CatalogAxes additiv-Zwang AUFGEHOBEN ("die 320er ist ueberholt und darf gebrochen werden") | OWNER-ENTSCHEID | Z22073 | FESTGELEGT (TABU konditional geloest) | - |
| §21.C E1-E5 ENTSCHIEDEN: E1 Organ-Matrix 320 bleibt+SIMD als System-Achse; E1b O2/O3 in Mess-golden; E2 rm freigegeben (git-reversibel); E3 A2-Neben Namespace sauber; E4 beide A2-Stufen; E5 abi4.txt behalten | OWNER-ENTSCHEID | Z22079-22085 | FESTGELEGT, BAU-REIHENFOLGE freigegeben (opt-f->opt-g->A2-Neben) | - |
| §21.D KONFORMITAETS-KORREKTUR: User ruegte Haupt/Unter-Achsen-Vertauschung, opt-f/opt-g-XML war fehlerhaft abgeflacht | REGRESSION | Z22087-22088 | ERKANNT (eigener Fehlbefund), KORRIGIERT (XSD/Parser auf verschachtelte Container-Struktur) | - |
| §21.E KONFORMITAETS-SWEEP: 0/8 Themen der 3-Tage-Kette voll konform, aber KEIN golden-320-Regress | REGRESSION | Z22091 | ERKANNT, neues Freigabe-Prinzip (System gibt HW-Ressourcen frei, Organ setzt durch) | - |
| INC-29-Kern GELANDET: InfraError-Domaene getrennt, isa_features FATAL->WARNING | FEATURE | Z22091 | GELANDET, CI-BEWIESEN | ce 5e47f009 |
| §24 VOLLES GO ALLE PAKETE: #50 Caching, #51 Storage, #52 std::variant-Bloat-Behebung = GO | OWNER-ENTSCHEID | Z22095-22098 | FESTGELEGT | - |
| §24.B INFRA-MODUS-AUSNAHME: fuer Caching+Storage-Einrichtung Ausnahme von Cluster-read-only-Regel gewaehrt | OWNER-ENTSCHEID | Z22100-22101 | FESTGELEGT (Ausnahme, Scope strikt Caching/Storage) | - |
| §24.C ACHSEN-KETTEN-STATIK: Haupt-Achse=statisch/Unter-Achse=Runtime ist stufen-relativ (Planer->CEB->Tier-Kette, Vorstufen-Dynamik wird Folgestufen-Compile-Konstante) | OWNER-ENTSCHEID | Z22103-22104 | FESTGELEGT/Klarstellung | - |
| §24.D KORREKTUR Session-Start-Ritus: NICHT gesamtes Memory einlesen, sondern per ultracode gezielt Direktiven+Learnings+Umgebungsvariablen zum Thema | OWNER-ENTSCHEID | Z22107 | FESTGELEGT (Korrektur) | - |
| §24.G 3 GOLDEN-N-VORAUSSETZUNGEN CE-SEITIG FERTIG: #50 Caching, #51 Storage CE-Seite (Aktivierung gated auf Infra-Handout #56), #52 variant-Bloat-Guard | FEATURE | Z22109-22115 | GELANDET, CI-BEWIESEN (275/275, golden 131072-CRC64) | ce d0313bf2, ea2c544c, 93a21233, 9614ae0e |
| §24.F STORAGE #51 ENTSCHEIDE: OPN-Key VERFUEGBAR (fruehere Annahme "kein OPN-Zugang" war FALSCH); Ebene C=V80-measure-drop-Pfad; Ebene B=prod-MinIO auf V91 via Infra-Handout | OWNER-ENTSCHEID | Z22117-22122 | FESTGELEGT, korrigiert fruehere Fehlannahme | - |
| §24.E TODO Task #54: Nachweis dass Achsen-Steuerung weiterhin durch Experiment-B+-Baum/XML erfolgt (kein Bypass entstanden) | AUFGABE | Z22124-22125 | OFFEN | - |
| §23 PLANUNGSDIREKTIVE std::variant-VERBOT fuer alle statischen Haupt-Achsen (Runtime-Overhead+Code-Bloat: 131072 Binaries x 60MB=7.5TB > 6TB verfuegbar) | OWNER-ENTSCHEID | Z22127-22140 | FESTGELEGT als 3. Voraussetzung fuers neue golden N | - |
| §23.C IST-BEFUND: REGRESSIONS-KERN std::variant in algorithm_baustein.hpp+baustein_variants.hpp gefunden, aber LATENT nicht im Live-Hot-Path (Insel, nur test_abi_interface.cpp Konsument) | REGRESSION | Z22142-22144 | ERKANNT, kleiner Radius (praeventiv, Live-Codegen nicht betroffen) | - |
| §22 Standing-Direktive: autonome Weiterarbeit OHNE Rueckfragen fuer ALLE Cache-Engine+Diplomarbeit-Code-Arbeit, NICHT fuer Diplomarbeit-Haupt-Text (Ausnahme Messwerte-in-LaTeX+PDF) | OWNER-ENTSCHEID | Z22157 | FESTGELEGT | - |
| GELANDET koordinierte Reihenfolge 18.07.: INC-29-Nachbesserung+Namensfalle+INC-1a/b (Dach topics::OrganAxis), F-SIMD symmetrisch KOMPLETT, Single-Source Validate, INC-0(malloc/Flag-Trennung) KOMPLETT | FEATURE | Z22159-22163 | GELANDET, CI-BEWIESEN (COMMIT_OK) | ce 23a4d443, 538b0758, 4ed5a87c, d9ad000b-0947a64b, bf6d414d, e5eb990f, 01748163 |
| INC-2d ENTSCHIEDEN+GO: TargetIsaSystemAxis Variante A (neue Haupt-System-Achse target_isa) | OWNER-ENTSCHEID | Z22165 | FESTGELEGT | - |
| INC-2d KOMPLETT GELANDET: ABI-Major 5->6 (Magic 0x35->0x36), POD sizeof 1344->1272, isa raus aus Komposition (18->17 Slots), golden 320 IDs ohne isa-Segment neu regeneriert | FEATURE | Z22166 | GELANDET, CI-BEWIESEN (275/275, golden 320 Roundtrip, sizeof==1272) | ce bc5ae9a3-eeb91f11, super 65bf1bf |
| 3 echte Regressionen bei eigener Verifikation gefunden+gefixt (stale Test-Labels durch INC-2d-Reindex); Subagent-Report "270/275" war durch stale binaries verfaelscht | REGRESSION | Z22166 | ERKANNT+BEHOBEN (eigene Force-Recompile-Verifikation deckte Subagent-Fehlbericht auf) | - |
| NEUE USER-DIREKTIVE: neue XML-Grundlage die ALLE 17 Achsen abdeckt, N>320 als neues golden-Ziel (messdaten-erhaltend) | OWNER-ENTSCHEID | Z22167 | FESTGELEGT (Task #49) | - |
| §25 #50 Caching war STALE-GRUEN, hatte realen CI-Bruch (algo_version in Strategie-Klassen statt Observable*-Wrapper-Huellen) | REGRESSION | Z22175 | BEHOBEN (11 Huellen nachgezogen) | ce 5da2caf7 |
| LEHRE: Stale-Binary-Falle wiederholt sich, Build-Task erst "completed" nach CLEAN-Rebuild/CI-Gruen nie nach inkrementellem Lokal-Build | REGRESSION | Z22175 | ERKANNT als Prozess-Lehre | - |
| Weg A Storage #51 CI-Aktivierung inert-by-default (Hidden-Job .storage_cache_activation) | FEATURE | Z22177 | GELANDET | ce 0b669e9 |
| Infra-Handout P5 DRINGEND: vault-PAT durch Shell-Bug (${PAT:-NEIN}) in lokales Transkript geleakt | REGRESSION | Z22179 | ERKANNT als Sicherheitsvorfall, Rotation dringend | - |
| 2 Konformitaets-Audits persistiert: 9-Dim 4/9 konform (0 hart), Ketten Planer->CEB->Tier 3/5 konform (0 hart) | REGRESSION | Z22181 | ERHOBEN, Fix-Listen G1-G10/P1-P8 | - |
| §26 KRITIK-KORREKTUR: #49 golden-N faelschlich als "nur Infra-gated" behauptet (CE-seitiger Bau tatsaechlich nicht erfolgt) | REGRESSION | Z22192 | ERKANNT (eigener Overclaim korrigiert) | - |
| §26 KRITIK-KORREKTUR: "super-Sub clang-gruen" war ueberstellt, 3 build-i2-Tests stale-rot durch vorbestehenden B2/B4-Include-Root-Gap | REGRESSION | Z22193 | ERKANNT (eigener Overclaim korrigiert) | - |
| §26 KRITIK-KORREKTUR: §22 "F-SIMD symmetrisch KOMPLETT" war ueberstellt (kein aktiver CebSystemAxis traegt das Label, verwaister Knoten) | REGRESSION | Z22194 | ERKANNT (eigener Overclaim korrigiert) | - |
| §27 PLANUNGSDIREKTIVE Registry=ANGEBOT / Anwender-XML=ANZEIGE (.pom-Resolver-Modell, deklaratives Manifest+Resolution gegen Repository) | OWNER-ENTSCHEID | Z22209-22211 | FESTGELEGT | - |
| §28 PRAEZISIERUNG: DREI Achsen-Art-Registries je Modul (Organ/System/Mess), Haupt-Achse statisch traegt Unter-Achsen meist dynamisch | OWNER-ENTSCHEID | Z22215-22217 | FESTGELEGT (spaeter 26.07. als V7.2 weiter praezisiert) | - |
| §54-T2 Nachtrag 20.07.: Mess-Registry-Angebot Haupt(Tooling)/Unter(Ablaufmethodik+Workloads+Kategorien) geteilt | OWNER-ENTSCHEID | Z22221 | FESTGELEGT | - |
| ce-CI-REPARATUR: ce-Pipelines seit INC-2d ROT wegen Registry-Byte-Drift (nur super/288 geprueft, ce/286 uebersehen) | REGRESSION | Z22235 | BEHOBEN, NEUE REGEL CI-Verifikation IMMER beide Projekte 286+288 | ce a9c433d0, super 339cc9f |
| §30 ARCHITEKTUR-ENTSCHEID: Stufen-Zuordnung Planer=Mess-Achsen, CEB=System-Achsen, Tier=Organ-Achsen (+Hybrid-Einschub), Mess-Achsen-Permutation wandert von CEB in Planer (revidiert fruehere Zuordnung) | OWNER-ENTSCHEID | Z22239-22258 | FESTGELEGT | - |
| KORREKTUR-VERWEIS 05.08.: Stufen-Doktrin weiter konsolidiert (Mess=dreistufig dehnbar, System=zweistufig dehnbar, Organ=zweistufig, Hybrid=Factory-Facade-Adapter organ-frei) | OWNER-ENTSCHEID | Z22243 | FESTGELEGT (spaeter praezisiert) | - |
| §31 DESIGN-BESTAETIGUNG A1: AxisKind existiert schon als Faerbungs-Traeger, muss aber ausgebaut werden | OWNER-ENTSCHEID | Z22263 | FESTGELEGT | - |
| §31-A4 Storage-Stufen-Zuordnung: CI-Cache(dev)=NUR Planer-Binary; prod-MinIO=ALLE generierten Folge-Stufen-Binaries+Sidecars | OWNER-ENTSCHEID | Z22265 | FESTGELEGT | - |
| §32 RUECKFRAGEN-RUNDE F1-F8: F1 volles golden N Ziel; F2 Aufbau-Reihenfolge (erst N-Satz dann golden-320); F4 opt-Stufen O2+O3 nie Ofast + CI-Tripwire hart-rot; F5 measure-drop Default; F6 Generator-aus-Code fuer alle 3 Registries; F7 3 Modi Debug/Mess/Release + selektives Messsystem; F8 Hybrid-DoD mit Spline-Heuristik+3 Break-Even-Optionen | OWNER-ENTSCHEID | Z22272-22292 | FESTGELEGT | - |
| F8 bewusste eng begrenzte Ausnahme vom §23-variant-Verbot im Heuristik-Hybrid-Kontext (Break-Even-Details derselben Achse) | OWNER-ENTSCHEID | Z22287 | FESTGELEGT (Ausnahme) | - |
| §33 BEWEIS-DOKTRIN: golden-320 ist KEIN legitimer Systembeweis (nur Byte-Regressions-Wache), nur new-golden unter VOLL-Konfiguration beweist das System | OWNER-ENTSCHEID | Z22293-22303 | FESTGELEGT (Ursprungsdefinition, seither mehrfach referenziert) | - |
| §34 VOLLES GO fuer alle weiteren Punkte: F9/INC-G6 Materialisierungs-Architektur, Planer-I1, Hybrid-Spline-Vorbau, GN-8-Rest, Mess-Pipelines interruptible:false | OWNER-ENTSCHEID | Z22304-22306 | FESTGELEGT | - |
| §35 PRIORITAET Cluster-parallele System-Achsen-Builds (CI-Staffelung x algo_sig-Invalidierung): Runner-Tags nach SIMD-Faehigkeit, Cross-Runner-Sync via MinIO (skip+pull) | OWNER-ENTSCHEID | Z22308-22316 | FESTGELEGT | - |
| §36 POOL-MODELL-PRAEZISIERUNG: Node-bevorzugte Builds unter LOCKING (GitLab resource_group je Permutations-Zelle), N amd64-Nodes, Freigabe-Kopplung System->Organ generalisiert | OWNER-ENTSCHEID | Z22318-22330 | FESTGELEGT | - |
| §37 FREIGABE-PRINZIP GENERALISIERT: alle System-Achsen koppeln gegen Organ-Achsen (SIMD=Pilot fuers Prinzip), Cross-Compile-Definition fuer spaeter vermerkt | OWNER-ENTSCHEID | Z22332-22342 | FESTGELEGT | - |
| §37.b Nachtrag: System-Consumer-Achsen werden faktisch in Tier-Binaries eingebaut, aber von CEB zur Laufzeit aus Freigaben gebaut/delegiert | OWNER-ENTSCHEID | Z22348-22352 | FESTGELEGT | - |
| §38 REVISION: "kein Rueckkanal Planer<->CEB" ist UEBERHOLT, sparser Fortschritts-Rueckkanal CEB->Planer existiert doch (Cursor-Protokoll, kein Messdaten-Rueckfluss) | OWNER-ENTSCHEID | Z22354-22363 | FESTGELEGT/REVISION widerspricht frueheren "eindimensional"-Aussagen (Z18404, Z20508, Z21710 etc.) | - |
| §38.b NUR EINE CEB gleichzeitig (Mess-Exklusivitaet), multiple CEBs laufen SEQUENTIELL bei messenden Laeufen | OWNER-ENTSCHEID | Z22365-22372 | FESTGELEGT | - |
| §39 Infra-Autonomie-Freigabe: Cluster nur fuer diese Session reserviert, Freigabe Infrastruktur autonom mit Cred-Vault-Schluesseln einzurichten | OWNER-ENTSCHEID | Z22376-22381 | FESTGELEGT (groessere Ausnahme von Read-only-Regel als §24.B) | - |
| Ebene-C-401 aufgeklaert: measure-drop verlangt HTTP-Basic-Auth, CE-Client sendete faelschlich Bearer-Token | REGRESSION | Z22382 | BEHOBEN (Client-Fix artifact_cache.hpp) | - |
| §40 SIMD-Flag-Signaturen+dynamische Planer-CI+Bare-Metal-Pflicht: statische 24-Zellen-Matrix ist nur erfolgreicher PILOT, SOLL=Planer emittiert Folge-CI dynamisch (Planer->CEB->Tier zweistufig), Bare-Metal-Pflicht bislang unerfuellt | REGRESSION | Z22387-22398 | ERKANNT (statische Loesung unzureichend), OWNER-ENTSCHEID fuer SOLL (W10-Kette) | - |
| §41 GN-11-ENTSCHEID: Bau=new-golden VOLL, Messung bis Abgabe=320er, new-golden-VOLL-MESSUNG erst ab 01.08. (nach Abgabe) | OWNER-ENTSCHEID | Z22401-22409 | FESTGELEGT (wichtiger Meilenstein-Entscheid) | - |
| §42 CI-Architektur-Korrektur: GN_MSYS="default" ist konzeptloser Platzhalter, Mess-Achsen-Stufe fehlt komplett in laufender CI; SOLL=DREI dynamische Stufen (Mess->CEB-Typ->System-Achsen->Tier-Binaries/Hybrid) | REGRESSION | Z22415-22421 | ERKANNT (aktuelle CI-Architektur grundlegend unvollstaendig), OWNER-ENTSCHEID fuer W10-SOLL | - |
| §42.b Unter-Achsen-Praezisierung: Haupt-Achsen geben Unter-Achsen-Raum frei, EINE Haupt-Achsen-Permutation ergibt EINEN Mess-Job der alle Unter-Achsen-Permutationen als CSV zurueckschreibt | OWNER-ENTSCHEID | Z22423 | FESTGELEGT | - |
| §43 Einkompilierte string_view-Versionierungs-Stempel je Binary-Stufe: jede Achse traegt gewaehlten Algorithmus als string_view, chirurgische Cache-Invalidierung nur bei geaenderter Achse | OWNER-ENTSCHEID | Z22429-22436 | FESTGELEGT | - |
| §43.b Planer-Stempel+X.Y.Z-Versions-Schema (Feature-Version.Revision) fuer jeden Achsen-Algorithmus + Experiment-Planer | OWNER-ENTSCHEID | Z22438 | FESTGELEGT, W11-GO erteilt | - |
| §44 AKUT-FUND: .golden_n_build timeout:2h war zu kurz fuer 8h-Zellen, 5 laufende Voll-Bau-Zellen waeren am Timeout gestorben | REGRESSION | Z22446 | BEHOBEN (Timeout auf 30h) | ce 4189b87 |
| §44 Kalibrierung 11453: 24/24 Zellen success, Zellen-Filter-Bug+Bearer-Bug gefunden+gefixt | REGRESSION | Z22449 | BEHOBEN | - |
| §44 Storage-Transport-Modell C de facto entschieden: measure-drop HTTPS-PUT mit Basic-Auth ist PRODUKTIV, alter POSIX-Copy-Konflikt obsolet | OWNER-ENTSCHEID | Z22455 | FESTGELEGT | - |
| §45 Voll-Bau-GATE: erst optimierte Pipeline dann Voll-Build, Zwischenperiode ROT ausdruecklich akzeptiert (temporaere Ausnahme von Hart-Gruen-Doktrin) | OWNER-ENTSCHEID | Z22464-22471 | FESTGELEGT | - |
| §45-GATE-STAND: alle Gate-Bausteine geliefert (W9 Konformitaet+H-10, W11 Async-Push, #31 Sweep-Kollaps -75% Bau, W12-A Stempel, W10 Legenden-Kette) | FEATURE | Z22471 | GELANDET | - |
| §46 §45-GATE ERFUELLT: CE-gesteuerte dreistufige Kette produktionsreif, VOLL-BUILD gestartet (COMDARE_GN_TOTAL=131072) | FEATURE | Z22475-22480 | GELANDET, CI-BEWIESEN (5 E2E-Haertungsrunden, 28 Director-Contract-Tests, 16/16 Legenden-Jobs gruen) | - |
| Zwischenperiode-rot-Ausnahme ENDET, hart-gruen gilt wieder uneingeschraenkt | OWNER-ENTSCHEID | Z22479 | FESTGELEGT (Ende der Ausnahme) | - |
| §47 MESS-ACHSEN HAUPT/UNTER FINAL AUFGELOEST: Mess-Tooling(Wallclock/Makro/Micro)=Haupt statisch, Ablaufmethodik(Debug/Messen/Release)=Unter dynamisch-delegiert | OWNER-ENTSCHEID | Z22488-22496 | FESTGELEGT, loest F1/F7-Konflikt auf (F1 korrekt, F7 falsche Haupt-Achse) | - |
| §48 KONSOLIDIERTER GESAMTBLOCK aller offenen Ziele (Stand 20.07., spaeter durch §55 abgeloest) | UNKLAR | Z22498-22552 | Index-Konsolidierung bereits geloggter Punkte (§16-§47) | - |
| §26 Guard-2^17 ERLEDIGT 20.07. (A11-Audit): bereits durch GN-2-Guard gedeckt (source_catalog.hpp Cap 4096), kein separater TU-Guard noetig | REGRESSION | Z22531 | BEHOBEN/entkraeftet | - |
| §26 Quick-Wins ERLEDIGT 20.07. (A11-Audit): 4/4 gelandet (sizeof==1272, host_compatible_with, all_axes_matrix_count-Rename, reflect_versions_all17 im Default-ctest) | REGRESSION | Z22532 | BEHOBEN | - |
| §47-DOKU-NACHZUG ERLEDIGT 20.07. (A10): widersprechende Docs (Doc23/Doc16/Nachschlagewerk/§28) auf Mess-Tooling=Haupt/Ablaufmethodik+Workloads=Unter nachgezogen | REGRESSION | Z22561 | BEHOBEN (additiv korrigiert) | - |
| §40.c Bare-Metal-Pflicht ERLEDIGT (W10-A-Refactor 19.07. + A8(c)-Re-Beweis 20.07.): MANUAL_RUN §1-§5b an HEAD, perm.dll=69, rc=0 | FEATURE | Z22627 | GELANDET, CI-BEWIESEN | - |
| §49 DESIGN-FREIGABEN: std::variant im Hybrid-Tier freigegeben (Break-Even Option1+3), Dock-Array mit Verdraengungs-Strategie, Fallback R1 kompromisslos VOLL (alle Messmethoden+Observer-Pruefdock) als S9 | OWNER-ENTSCHEID | Z22677-22684 | FESTGELEGT | - |
| §49-KORREKTUR: std::variant-Freigabe im Hybrid ist LIMITIERT (nur fuer abweichende Unter-Pruefdock-Typen via Abstract-Factory, NICHT Haupt-Kommunikation zu Tier-Binary-Observern) | OWNER-ENTSCHEID | Z22686 | FESTGELEGT (Praezisierung/Einschraenkung von §49) | - |
| §50 Vergessene-Features-Sweep (7-Batch-ultracode 20.07.): ergaenzt §48-Katalog additiv um fehlende Bau-Kette-Punkte (F2 Set-ABI, F12iii, H-7/H-10, INC-1-Schichtung, Fehlerklassen-Framework-Detail, Resolver-Forks R1-R8) | AUFGABE | Z22691-22710 | ERHOBEN (Katalog-Ergaenzung bereits bekannter offener Punkte) | - |
| K-5 best_binary_selector ABI-Spiegel stale (kAbiMajor=5/'.A5.' vs Host 6), schreibt falsche Provenienz | REGRESSION | Z22716 | ERKANNT, OFFEN (hoch, Daten-Korrektheit) | - |
| §32-F4/GN-8-Rest Prioritaet UEBERHOLT 11.08. (KON16-08): Owner-Entscheid "hoch" statt "niedrig" | REGRESSION | Z22714 | KORRIGIERT (Prioritaet) | - |
| §51 B1 VERBINDLICH: new-golden ist neue PFLICHT (Bau), 320er nur fuer Zwischenergebnis-Messung | OWNER-ENTSCHEID | Z22746 | FESTGELEGT | - |
| §51 B4: ISA-System-Achse per Fork A bauen (FREIGABE-HAUPT-ACHSE fuer Organ-Achsen), Stempel muessen erweiterbar sein | OWNER-ENTSCHEID | Z22747 | FESTGELEGT | - |
| §51 B8: 6 System-Achsen korrekt, erweitert um 7. NUMA/Locking-System-Achse (compile-statisch=Haupt, sonst dynamische Unter-Achse unter ISA) | OWNER-ENTSCHEID | Z22750 | FESTGELEGT | - |
| §51 B9: Thesis-Profile VOLLSTAENDIG uebernehmen samt Mess-Tooling-Unter-Achsen fuer Mess-Frameworks+Workload-Delegation | OWNER-ENTSCHEID | Z22751 | FESTGELEGT | - |
| §51 NEUE ACHSEN-KONZEPTE B3+Meta-Meta-Achsen: extension_hardware wird dynamisches Array (jeder HW-Typ eigene Achse), neuer Begriff "Meta-Meta-Achsen" fuer Haupt-Achsen eines statischen Arrays unter Manager-Hauptachse | OWNER-ENTSCHEID | Z22754-22758 | FESTGELEGT (neues Architektur-Konzept) | - |
| §52 B2 Gattungs-Vervollstaendigung SearchAlgorithm+Container+Set | FEATURE | Z22760,22771 | BAUPLAN (ABI-Schritt ZULETZT, eigene ultracode-Planung); Gerüst existiert für alle 5 Genera, Tiefe asymmetrisch (SearchAlgorithm 9 reale Organe, Set/Sequence/Adapter/View je 1); Cross-Genus-Komposition-als-Sub-Organ via `OrganConcept` | ce |
| §51-B10 page_type ISA-Unter-Achse Frage | AUFGABE | Z22761 | GEPLANT (verifizieren) -> aufgeloest s.u. B10 | - |
| §51-B11 INC-0 DLL-Load Option B Status pruefen | AUFGABE | Z22762 | GEPLANT (mit ultracode rekonstruieren) -> aufgeloest s.u. B11 ERLEDIGT | - |
| §51-B12 F-SPREAD erklaeren | AUFGABE | Z22763 | GEPLANT -> aufgeloest s.u. B12 | - |
| §51-B13 9dim-Fixes verifizieren | AUFGABE | Z22764 | GEPLANT -> aufgeloest s.u. B13 7/7 ERLEDIGT | - |
| §51-B14 §38/§38.b Dock-Serialisierung pruefen | AUFGABE | Z22765 | GEPLANT -> aufgeloest s.u. B14 TEIL | - |
| §52 B3 Meta-Meta-Achsen+Hardware-Erweiterungs-Array | FEATURE | Z22772 | KONZEPT-DESIGN (CRTP+mp11, 3 CRTP-Ebenen ExtensionHardwareAxis/HardwareManagerSystemAxis/MetaMetaAxisConcept, mp_for_each Single-Source); Session-Plan S10 | - |
| §52 B10 page_type AUFGELOEST | REGRESSION | Z22773 | BEHOBEN (Missverstaendnis ausgeraeumt: page_type NICHT dynamisch, NICHT ISA-Unter-Achse, KEINE neue Achse; Ist-Code bereits korrekt System(Raum)/Organ(Durchsetzung) getrennt; §48-Mess-Kette ergaenzt) | - |
| §52 B11 INC-0 DLL-Load Option B / measured=0-Fix | REGRESSION | Z22774 | BEHOBEN+VERIFIZIERT (ce 418e4b76, §20.C; `make_gpp_compile_fn` link_libs, nm-Beweis mi_malloc_aligned=T, 105 echte Messzeilen); NICHT ueberholt, Fundament fuer W6-W12; Rest §26-L5 build-i2 stale-rot vor Vollmesslauf klaeren | ce 418e4b76 |
| §52 B12 F-SPREAD erklaert (first-2 vs Max-Kontrast) | FEATURE | Z22775 | ENTSCHIEDEN first-2 als HAUPT-Lauf (§41/§32-F2, CRC64-Fixture); Max-Kontrast = optionaler INC-G7, geparkt bis nach 01.08., GO-pflichtig | - |
| §52 B13 9dim-Fixes 7/7 verifiziert (G4/G5/G8/G9/G10/#29/a1a2) | REGRESSION | Z22776 | BEHOBEN (7/7 im IST-Code); 2 unkritische Rest-Drifts (Doku/Label-Kosmetik, kein ABI) bleiben als niedrig-Rest | - |
| §52 B14 §38/§38.b Diff STRUKTUR erfuellt, Kettenlauf-Integration offen | REGRESSION | Z22777 | TEIL (Struktur ERFUELLT ce d7d35c36: beide PODs, R5-XML, LIVE-Feuerung; 3 REST-OFFEN gated hinter §47: ProgressSink kein Konsument, ExperimentSubtreePayload nicht im Kettenlauf, resource_group fehlt am dynamischen emit_measure_job) | ce d7d35c36 |
| §52 B15 Migration A1/A5/A7 | OWNER-ENTSCHEID | Z22778 | VOLLES GO unter 3 Auflagen (A5-Master-Loeschung je-Repo-GO, Schritt-13 supersediert im Mechanismus, neue Remotes je-Repo-GO); ans Projektende geparkt | - |
| §51-B8 NUMA/Locking Achsen-Zuordnung | AUFGABE | Z22781 | OFFEN (Verifikation = Session-Plan S11; User-Einschaetzung: dynamisch -> Unter-Achse unter ISA) | - |
| §51-B9 Thesis-Profile vollstaendig uebernehmen | AUFGABE | Z22782 | GEPLANT (WAS/WIE aus Thesis-Profilen in measurement_tooling-Unter-Achsen; fliesst in S4+S9) | - |
| Session-Plan-Erweiterung V2 voll erweitert | AUFGABE | Z22784 | ZUR FREIGABE (wf_a612d2db, `docs/plaene/20260720-SESSION-PLAN-V2-voll-erweitert-alle-straenge.md`); A-E Bloecke: Korrekturen D0-D6, Schaerfungen, neue Straenge S10-S23, BAND-Tabelle, kritischer Pfad -> §53 FREIGEGEBEN | - |
| §53 Session-Plan V2 VOLLES GO | OWNER-ENTSCHEID | Z22786-22788 | ENTSCHIEDEN 20.07.2026 (User): volle Roadmap S1-S8+S10-S23 freigegeben; Gate a/b, ABI/golden-Fenster, 320er when:manual, ISA-Alt-Ausbau, Gattung-Genus-GO, 2-Stufen-ABI-Fenster Q4 bleiben je vorzulegen | - |
| §53 W11 ASYNC VERBINDLICHE TRENNUNG | OWNER-ENTSCHEID | Z22789 | ENTSCHIEDEN 20.07.2026 (User verbatim): async NUR fuer Binary-Erstellung/-Upload auf minio.comdare.de freigegeben+PFLICHT; git-Push UND Mess-Rueckschrieb-Sink bleiben SYNCHRON (Storage-Naht-Doktrin); ersetzt fruehere pauschale "W11 verworfen"-Notiz; in S14 aufgenommen | - |
| §53 Naechster Schritt S1/A1 P-TOTAL Forward-Fix | AUFGABE | Z22790 | OFFEN (an Opus delegiert; COMDARE_GN_TOTAL vererbungssicher forwarden, sonst baut Kette nur 16 statt 131072) | Opus |
| §54 T1 Gattung=Tier-Binary-Interface, KEINE Achsen-Gattungen | REGRESSION | Z22792,22794 | BEHOBEN (Terminologie-Korrektur, User 20.07.: fruehere "Achsen-Gattung" in §48/§51 = Fehlbenennung; kanonisch Achsen-TYP (Organ/System/Mess) fuer Achsen, Gattung nur fuer Tier-Interface) | - |
| §54 T2 measurement_categories = Mess-Tooling-UNTER-Achse | REGRESSION | Z22792,22796 | BEHOBEN (korrigiert §47/§48: measurement_categories + Rueckschrieb-Methoden sind Planer-UNTER-Achsen unter Mess-Tooling-HAUPT, nicht nur CSV-Spalten) | - |
| §54 T3 Freigabe-Materialisierung Organ=System-freigegeben∪17-Organ | FEATURE | Z22792,22798 | PRAEZISIERT (binary_id bleibt 17-Organ-Kern, Tier-Binary-Achsen-Satz = freigegeben∪17-Organ, gestempelt); [Stand 26.07→V7.1]: heute 18 Organ-Achsen T00-T17 (T17=persistence_target, ABI-7) | - |
| §54 T4 Permutations-Baum je ACHSEN-TYP nicht je Gattung | REGRESSION | Z22792,22802 | BEHOBEN (korrigiert fruehere E3-Formulierung "B+-Baum pro Gattung" -> "pro Achsen-Typ") | - |
| §54 T5 Meta-Meta-Achse per Command-Pattern | FEATURE | Z22792,22804 | PRAEZISIERT (Hardware-Haupt-Achse verwaltet+gibt frei Meta-Meta-Achsen, die dann Organ-Achsen freigeben; Achsen-Zahl waechst DYNAMISCH je Maschine); [Stand 26.07→V7.2]: Traeger heisst heute `external_utils`=HUB (Rename von extension_hardware), `load_framework`=ERSTE Meta-Meta unter Hub, NICHT 4. Haupt-Achse | - |
| §54 T6 Tier-Build-Array vs Measurement 3-Stufen-Legende | FEATURE | Z22808-22809 | KORRIGIERT (code-verifiziert experiment_plan_director.hpp; STUFE 1 CiYamlBuilder ceb:build/emit/trigger, [a,b,c]=Mess-Tooling-HAUPT) — Fortsetzung folgt | - |
| §54 T6/T7 Stufe2/3 Tier-Build-Legende + zweischichtige Kern-Permutation | REGRESSION | Z22810-22815 | OFFEN-REGRESSION (WURZEL-Regression: `plan_legend.hpp:109` emittiert live noch Fehlform `tier:build:[a,b,c][d,e,f]:chunk<k>` statt korrekt `[d,e,f][g,h,i]`; Fix GO-pflichtig §56); T7 zweischichtige Kern-Permutation (Existenz+Werte compile-time) neu praezisiert; [Stand 26.07→V7.2] Traeger=`external_utils`=HUB | - |
| §55 KONSOLIDIERTER GESAMTBLOCK v2 (loest §48 additiv ab) | UNKLAR | Z22819-22843 | Konsolidations-Kopf, spaeter selbst als Historie markiert ([Stand 26.07→V7.1] Z22836: "§55 = Historie, Single-Source = §0-GOAL-V7") — Inhalt s. Einzelzeilen | - |
| §55 Bau-Kette Executive Summary 1-7 (28.07-Zwischenabgabe) | UNKLAR | Z22823-22830 | Index/Zusammenfassung bereits geloggter Punkte (golden-N Pflicht, Mess-Vollzug offen, Planer fehlt, neue Achsen-Konzepte, Gattung 5 Genera, Hybrid Abgabe-Pflicht, Mess-Smoke 24.07+320er 28.07) — keine neuen Fakten | - |
| §55/§26#49 golden-N Systembeweis Bau-Nachweis 24.07 | AUFGABE | Z22846 | OFFEN (kritisch, CRC64 0xF1C1F26A1232073B, kein Stale-Green) | - |
| §55/§37/§37.b Freigabe-Prinzip generalisiert (G7-constexpr-Gate wird Bau-Gate) | FEATURE | Z22856 | OFFEN (SIMD=Pilot, Dual-Aufnahme via State-Pattern durchs Pruef-Dock) | - |
| §55/§18.1.3 Pruef-Dock-ABI-Vertrag 3-teilig | AUFGABE | Z22859 | OFFEN (Set/Sequence-Docks V42, Iterator-Bypass beseitigen) | - |
| §55/§18.1.4 Allokatoren=Algorithmen axis_06 | AUFGABE | Z22860 | OFFEN (Rest nach INC-0) | - |
| §55/§50-F2 native Set-ABI (ISetTier+SetObserverSnapshotV1/V2+SetDock) | FEATURE | Z22861 | OFFEN (niedrig, abh. Set-Promotion-Entscheid) | - |
| §55 INC-Roadmap INC-0..4 (INC-1 System-Achsen-Schichtung, INC-1b genus_organ_binding.hpp, INC-1c freigabe_contract.hpp) | AUFGABE | Z22862 | TEIL (je Schicht CI-gruen+messfaehig) | - |
| §55/§50-F12iii Telemetrie T10 aus binary_id herausloesen | AUFGABE | Z22863 | OFFEN (hoch, ABI-Major-Bruch, kV3AxisSchema) | - |
| §55 opt-Arc (opt-f/opt-g, -march/-mavx-Kopplung, codegen-Minor-Tripwire) | FEATURE | Z22864 | TEIL (Default O3, Ofast NIE) | - |
| §55/§21.D-Ebenen 3 vertagte Kern-Library-Punkte (near-TABU) | AUFGABE | Z22865 | TEIL (nur mit GO: OptO*SubAxis-Rename, symm. SimdSubAxis, Doku Ofast->O3) | - |
| §13.3-#262/7b-3 AP-7b SwissTable SIMD-Gruppen-Probe | REGRESSION | Z22866 | OFFEN-REGRESSION (faelschlich in §48-Erledigt-Zeilen als erledigt gefuehrt, hiermit als OFFEN korrigiert; gated) | - |
| §55/§50-CompilerAtomicSubAxis Ziel-ISA-Degradierung | AUFGABE | Z22867 | OFFEN (niedrig, Laufzeit-Check statt Host-Makro) | - |
| §55/§20.D-B3 cpuid_probe-Luecken H-1/H-7/H-9 | AUFGABE | Z22868 | OFFEN (mittel, Leaf 0x1A/0xB/0x1F, sysfs) | - |
| §55/§38 Planer-CEB B+-Teilbaum-Serialisierung+Ruecklauf-Kanal | REGRESSION | Z22869 | TEIL (STRUKTUR erfuellt ce d7d35c36; 3 Rest-offen gated §47 — dup von §52-B14) | - |
| §55/§35-algo_sig Invalidierer+Ein-Build-pro-Permutation | FEATURE | Z22870 | TEIL (inkrementeller Cache FREIGEGEBEN §51-B7, Voraussetzung N=2^17) | - |
| §55/§43 Versionierungs-Stempel Luecke kMeasurementAxisVersionLine | REGRESSION | Z22871 | OFFEN-REGRESSION (fehlt; nur kOrganAxisVersionLine+kSystemAxisVersionLine existieren; X.Y.Z-Migration offen) | - |
| §55/§13.10-234V B+-Baum Shape-Materialisierung (S7-Serienplan, Cross-Familie-Pruning) | AUFGABE | Z22872 | OFFEN/GEPARKT (mittel/niedrig) | - |
| §55/§50-Fehlerklassen-#29 INC-29.0 axis_error.hpp Enum-Kern | AUFGABE | Z22873 | OFFEN (mittel) | - |
| §55/§50-CoR-Andockpunkt run_selection_filter_chain Dead-Code | AUFGABE | Z22874 | OFFEN (mittel, 0 Prod-Treffer) | - |
| §55/§23.D-#52 variant-Insel-Triade DEPRECATED-markieren | AUFGABE | Z22875 | TEIL (niedrig, Guard HotPathIsVariantFree done, Insel offen) | - |
| §55/§26 Guard-2^17 Golden-Hygiene | REGRESSION | Z22876 | TEIL->BEHOBEN (Guard-2^17-Teil ERLEDIGT GN-2/A11 20.07.2026; GN-10-Fixture-Kanonizitaet bleibt F27-user-gated) | - |
| §55/§26-L5 build-i2-Tests stale-rot (EINZIGER INC-0-Rest) | REGRESSION | Z22877 | OFFEN-REGRESSION (hoch, Hart-Gruen-Doktrin, dup §52-B11) | - |
| §55/§15.8-g-F72 Vendor-Allokatoren jemalloc/tcmalloc/hoard/scalloc | AUFGABE | Z22878 | OFFEN (mittel, K78-CE-D4-gated) | - |
| §55/§50-K-17 A07-snmalloc Runtime-Segfault | REGRESSION | Z22879 | OFFEN-REGRESSION (niedrig, ehrliche 'failed'-Zelle+Log bis Vendor-Untersuchung) | - |
| §55/§15.8-g-F58 G7-Vorlauf alloc_hw-Codegen fb_numa_page_study | AUFGABE | Z22880 | OFFEN (niedrig, NUMA-Fenster-gated) | - |
| §55/§37-HW kuenftige Beschleuniger-Hardware-Achsen NUMA/NPU/GPU/FPGA | FEATURE | Z22881 | GEPARKT (niedrig, Zukunft) | - |
| §55/§10.1-E4 #229 Diplomarbeit aendert nur die XML | AUFGABE | Z22882 | TEIL (hoch, P5/P6, Behelfsweg-Loeschung Tier1-3) | - |
| §55/§11-E #179 Wartbarkeits-Sweep XL | AUFGABE | Z22883 | TEIL (mittel) | - |
| §55/§20.D-B7 v32-Restwarnungen F02/F08/F61 | REGRESSION | Z22884 | OFFEN-REGRESSION (niedrig) | - |
| §55/§30-OrganJoin Organ-Join-Modi Stufe1/2/3 | AUFGABE | Z22885 | TEIL (mittel) | - |
| §55/§30-Sys/MessJoin System-/Mess-Achsen-Algorithmus-Join | AUFGABE | Z22886 | GEPARKT (niedrig, nach Abgabe) | - |
| §55/§18.3.1-S7 Deep-Research Locking (OptiQL/ARTSynchronized) | AUFGABE | Z22887 | GEPARKT (mittel, ehrlich offen, Opus-Session) | - |
| §55 Erledigt/ueberholt Bau-Kette Sammel-Zeile | UNKLAR | Z22889 | GESTRICHEN/ERLEDIGT-Index (§0-DoD1/DoD5/V5.4b-SUP, §2-B1/B4-B7, §3-S1-S9 je Status, §4-ABI SUPERSEDED §24 ABI-6, §5/§17/§18/§19/§20/§21 Bloecke, §13.10-AP2 W4 mit Korrektur "7b-3 NICHT erledigt", §38-STRUKTUR dup §52-B14, §45/§46 Voll-Bau-GATE mit WURZEL-Regression-Verweis) — Detail bereits in Einzelzeilen | - |
| §3-S5/#251-CMD-1 Re-Root VERWORFEN | OWNER-ENTSCHEID | Z22889 | GESTRICHEN (Limitations-Interface/Mess-Visitor via #267 ABI-neutraler compile-time-Visitor GEBAUT; Re-Root-Ansatz VERWORFEN) | - |
| §14.3-HELD Voll-per-Host-Messlauf (m3v2/#156/#215/#216, Pipeline 286 NIE pollen) | AUFGABE | Z22893 | GEPARKT/HELD (kritisch, 320-DLL-Neubau, MinIO-500-Fix+prod2-I/O #207 als Gate-Grund) | - |
| §41 golden-320 VOLL-Messlauf Abgabe-Messdatensatz 28.07. | AUFGABE | Z22894 | GEPARKT/HELD (kritisch, F2-Regime, Ein-CEB-Exklusiv §38.b) | - |
| §55/§41 Mess-Smoke Messfaehigkeits-Nachweis measure:smoke | AUFGABE | Z22896 | OFFEN (kritisch, 24.07.) | - |
| §55/§47 Mess-Tooling-HAUPT-Auffaecherung measurement_combos_of | AUFGABE | Z22897 | OFFEN (kritisch, heute nur [all]; Design §47 final, CODE fehlt) | - |
| §55/§47 realer Mess-Vollzug emit_measure_job | AUFGABE | Z22898 | OFFEN (hoch, nur when:manual-Echo-Skelett, COMDARE_RUN_MEASURE auskommentiert; 320er vor 28.07.) | - |
| §55/§42.b 4. Mess-Emissions-Ebene Mess-UNTER-Sweep-Jobs | FEATURE | Z22899 | OFFEN (hoch, gated hinter 320er) | - |
| §55/§49/S9 Observer-Pruefdock ALLE Messmethoden kompromisslos-voll | AUFGABE | Z22901 | OFFEN (kritisch, Fallback R1 nicht reduzieren; Design freigegeben §49, IMPL fehlt) | - |
| §55/§47 ZWEI getrennte Achsen-Regularien (Mess-Tooling-HAUPT vs Ablaufmethodik-UNTER) | REGRESSION | Z22902 | TEIL->BEHOBEN (Korrektur: NICHT "3 Modi" in einer Liste, §32-F7 neu gedeutet) | - |
| §55/§16.2-M4 Fehler-Sichtbarkeit CSV-Zelle 'failed' | AUFGABE | Z22903 | TEIL (hoch, bindende User-Doktrin) | - |
| §55/§38.b NUR EINE messende CEB gleichzeitig | FEATURE | Z22904 | TEIL (hoch, resource_group fehlt noch am dynamischen emit_measure_job, dup §52-B14) | - |
| §55/§1-FF3 FF-Gate-Kette AP-2->#162->#156/M3 | AUFGABE | Z22905 | TEIL (kritisch/hoch) | - |
| §55/§1-FF0 FF0-Owner Multi-Plattform-Generalitaet fehlt | REGRESSION | Z22906 | OFFEN-REGRESSION (hoch, Abgabe-Blocker) | - |
| §55/§12-PMC #152/#187/#165 Cache-Misses/PMC-Auto-Adaption/Residual | AUFGABE | Z22907 | TEIL/GEPARKT (hoch/mittel) | - |
| §55/§32-F2/F3 Aufbau-Reihenfolge System vs golden-320 | AUFGABE | Z22908 | OFFEN (hoch/mittel) | - |
| §55/§10.1-GOLDCOV/#18 Goldener Coverage-Test | AUFGABE | Z22909 | OFFEN (mittel) | - |
| §55/§11-C P1 Mess-Qualitaet-Rest AP-12/13/14/10 | AUFGABE | Z22910 | TEIL (mittel) | - |
| §55/§15.8-g-F39 #34 honest-100%-Audit | AUFGABE | Z22911 | TEIL (mittel, run-gated) | - |
| §55/§13.10 m3v2-Neu-Build 326 Basis-DLLs nicht belegbar | REGRESSION | Z22912 | OFFEN-REGRESSION (mittel) | - |
| §55/§50-M-8 Achsen-Sensitivitaetsanalyse-Writer | AUFGABE | Z22913 | OFFEN (hoch) | - |
| §55/§50-M-9 vier Heuristik-Kurven-Writer | AUFGABE | Z22914 | OFFEN (mittel) | - |
| §55/§50-M-15/E2 Welch-Konsument WIDE-CSV | AUFGABE | Z22915 | OFFEN (mittel) | - |
| §55/§50-M-4 19->17-Achsen-Nachzug | REGRESSION | Z22916 | OFFEN-REGRESSION (hoch, Thesis-Text "neunzehn Achsen" veraltet) | - |
| §55/§50-GN-9 Bloat-/Kalibrierungs-Report 6TB-Feasibility-Gate | AUFGABE | Z22917 | OFFEN (hoch, VOR Voll-Matrix) | - |
| §55/§50-W10/§37a CEB-Selbst-Emission Stufe-2 | REGRESSION | Z22918 | TEIL->BEHOBEN (KERN ERLEDIGT A8-Befund 20.07.: --emit-tier-ci/-cmake+Combo-Selektor; Fork-C .so-Schnitt DEFERRED) | - |
| §55/§50-PL-12 CEB schreibt selbst ans XML-Ziel zurueck | AUFGABE | Z22919 | OFFEN (mittel) | - |
| §55/§44.4 W8-Gate-Aktivierungs-Nachlauf | AUFGABE | Z22920 | OFFEN (mittel) | - |
| §55/§40.a-Deliverables Organ-Sinnhaftigkeits-Matrix | AUFGABE | Z22921 | OFFEN (hoch) | - |
| §52-B10 page_type Anerkennung+Benennung | AUFGABE | Z22922 | AUFGELOEST (KEINE neue Achse; Anerkennung/Benennung offen, mittel; dup §52-B10) | - |
| §55/§47-DOKU-NACHZUG additive Korrektur auf §54-T2 | AUFGABE | Z22923 | ERLEDIGT (20.07.2026, A10: Doc23/Doc16/NW1/NW2/Ledger §28+§47 gesetzt) | - |
| §55/§15.8-g-F79 axis_05-IMC-Runtime-Heuristik | AUFGABE | Z22924 | OFFEN (niedrig) | - |
| §55/§15.8-g-F74/§8-C2 GH200-ARM-Strategie | AUFGABE | Z22925 | GEPARKT (niedrig, Miet-Antrag laeuft) | - |
| §55 Erledigt/ueberholt Mess-Kette Sammel-Zeile | UNKLAR | Z22927 | GESTRICHEN/ERLEDIGT-Index (§11-H Tier-Metapher vollstaendig verifiziert; §13.10-AP2 7b-3 hier ENTFERNT, bleibt gated-offen s. Bau-Kette; §15.8-g-F60/F61 DLL-Load Fork A = §52-B11 dup; §13.10-234V page_type = §52-B10 dup) | - |
| §55 Thesis/PDF G8 Abgabe-Blocker (Anhaenge A/B/E, FF0-Owner, DoD7, Gattungs-Docks PL-19/21) | AUFGABE | Z22930 | OFFEN/TEIL (hoch, 28.07.) | - |
| §55/§0-DoD6 Mess->PDF-Persistenz-Rueckschrieb E2E | FEATURE | Z22931 | TEIL (hoch, LaTeX-Mess-Schnittstelle, Overleaf-Git-Push bleibt SYNCHRON §53-W11) | - |
| §55 CI-interaktive Diplomarbeit (XML->Kette->Auswertung dynamisch) | FEATURE | Z22932 | OFFEN/TEIL (hoch, Anhaenge A-F DE+EN automatisiert) | - |
| §55/Kap5-Gate Ergebnisteil wartet auf reale Messdaten | AUFGABE | Z22933 | GATED (hoch, daten-gated, Hybrid 14900KS-RMA) | - |
| §55/§15.6 INC-5 Live-Token Proj289 + INC-6 CI-Writeback-Stages | AUFGABE | Z22934 | TEIL (mittel, infra-delegiert) | - |
| §55/§13.10-OFFEN-LDoku "L gilt fuer Node-Pools" | AUFGABE | Z22935 | TEIL (mittel, per-Familie-Spezifikation offen) | - |
| §55/§8-USERGATED #24/#25/#226 Overleaf-Text/Diplomarbeit-Text/Appendix | AUFGABE | Z22936 | GEPARKT (niedrig, User schreibt) | - |
| §55 Erledigt/ueberholt Thesis/PDF Sammel-Zeile + Terminologie-Nachzug §54-T1-T7 bindend | REGRESSION | Z22938 | TEIL->BEHOBEN (17 statt 19 Organ-Achsen, Gattung=Tier-Interface, measurement_categories=Mess-Tooling-UNTER; Text-Umsetzung laeuft als §50-M-4; DoD6/DoD7/G8 bleiben Abgabe-Blocker) | - |
| §31-A2/§32-F8 Hybrid-Binary 4.Ketten-Glied ABGABE-PFLICHT | AUFGABE | Z22942 | OFFEN (kritisch, vor 28.07.; minimale Baseline+Spline-Funktion; dup bereits mehrfach geloggt) | - |
| §0-MISSION uebergeordnetes Ziel top-down FF0-FF4 honest-100% | AUFGABE | Z22943 | OFFEN (kritisch, laufende Mission) | - |
| §15.10-B DEADLINE 28.07. CI+Standalone messbar | AUFGABE | Z22944 | OFFEN (kritisch) | - |
| §15.10-D Konzept-Stand §54-T1-korrigiert System/Organ getrennt | REGRESSION | Z22945 | OFFEN-REGRESSION (kritisch, "Gattungs-Achsen"-Terminologie korrigiert) | - |
| §15.10-F Autonom baubar Bruecke-I-Reste/S-2c/F12i/F9-11/E16/#40/S-7-INC-1/#276 | AUFGABE | Z22946 | TEIL (kritisch, Deadline-Prioritaet) | - |
| §18.5.1-Danach Nach-4->5-Bauliste Planer-Codegen/F10/F11/S-7/#276 | AUFGABE | Z22947 | TEIL (hoch/kritisch) | - |
| §32-F8-3-Break-Even Option 1+3 ENTSCHIEDEN | OWNER-ENTSCHEID | Z22948 | ENTSCHIEDEN (§49: Option1=variant NUR Hybrid-Unter-Pruefdock via Abstract-Factory limitiert, Option3=Array multipler Docks+Verdraengung; Haupt-Observer-Kommunikation bleibt statisch; IMPL-OFFEN) | - |
| §50-Hybrid-Transport rekursives Delegations-/Transport-Protokoll | FEATURE | Z22949 | OFFEN (hoch, Protokoll-Impl fehlt) | - |
| §15.10-E genuin offene User-Entscheidungen G5/#274/S-7/F12iii/F3i | AUFGABE | Z22950 | OFFEN (hoch, user-gated) | - |
| §12-20260710-HYBRID Heuristik-Optimierungs-Achse eigene System-Achse | FEATURE | Z22951 | OFFEN (hoch, gated, Bau nach E4') | - |
| §15.5 Elaborierter Plan Rest Zentralisierung+E2E-Re-Audit | AUFGABE | Z22952 | TEIL (hoch) | - |
| §55 Erledigt/ueberholt Hybrid Sammel-Zeile | UNKLAR | Z22954 | GESTRICHEN/ERLEDIGT-Index (§32-F8-3 3-Optionen-OFFEN -> ENTSCHIEDEN via §49; §23.A variant-Verbot -> limitierte Hybrid-Ausnahme; §15.10-D Gattungs-Achsen -> Organ-Achsen) | - |
| §58 Versionierungs-Modell+Caching-Replay+Async-MinIO | FEATURE | Z22958 | OFFEN (hoch, autoritativ; Planer=1 Stempel, CEB=Array je Mess-Algo, Tier=2 Arrays System+Organ, CSV=Voll-permutativer Stempel; Folge-TODOs §58-STEMPEL/CSV-STEMPEL/REPLAY/MINIO) | - |
| §59 KERN-MESS-SCHEMA-Steuerung | FEATURE | Z22959 | OFFEN (kritisch, autoritativ "User schon immer Gesetz"; Default=ALLES messen, XML=Blacklisting, 3 Stufen CE/Pruefling/kombiniert; Bau K1-K8 KERN-A/B/Post-Abgabe gestuft; golden ce-only 0xF1C1F26A1232073B byte-identisch) | - |
| §0-DoD6/§11-G Mess->development-Rueckschrieb Mechanik scharf | FEATURE | Z22960 | TEIL (hoch, INERT bis Aktivierung; Sink bleibt SYNCHRON §53-W11) | - |
| §24.G/§51-B5/B6 Storage-Routing Ebene B=dev-MinIO V90/Ebene C=prod-NFS V91 | REGRESSION | Z22961 | TEIL/ENTSCHIEDEN (hoch, #72-Kopplung GESTRICHEN; AKTIVIERUNG gated auf Infra-Handout #56) | - |
| W12-B Versionierungs-Stempel-Konsumption cache_key_prefix | AUFGABE | Z22962 | TEIL (hoch, Pull-Key muss = Push-Key sein) | - |
| §51-B7 Inkrementeller CEB/Tier-Cache FREIGABE | FEATURE | Z22963 | FREIGEGEBEN/IMPL-OFFEN (hoch, Voraussetzung N=2^17; dup bereits geloggt) | - |
| §53-W11 async Binary-Erstellung/-Upload FREIGEGEBEN+PFLICHT | OWNER-ENTSCHEID | Z22964 | FREIGEGEBEN+PFLICHT/IMPL-OFFEN (dup §53, Owner-Zitat bereits geloggt) | - |
| §16.1-C2/§47-Schema-Nachzug Serialisierung Q1-Q4 | FEATURE | Z22965 | TEIL (hoch, measurement_categories=Mess-Tooling-UNTER-Achse KORRIGIERT §54-T2) | - |
| §14.1-G-6v48 Datensatz-Akten 8er-Liste 5 fehlen | REGRESSION | Z22966 | TEIL (hoch, user-gated, #184 Loader-Verdrahtung ungeprueft) | - |
| §32-F5 measure-drop als XML-DEFAULT | AUFGABE | Z22967 | TEIL (hoch, Pull als 2.Increment) | - |
| §12-0716-SER Serialisierungs-Konzept FIXIERT Umsetzung offen | AUFGABE | Z22968 | OFFEN (mittel, failed statt null) | - |
| §15.4-Dataset-Doppelquelle test_data_sets.xml DEPRECATED-Marker | AUFGABE | Z22969 | OFFEN (niedrig) | - |
| §55 Erledigt/ueberholt Storage Sammel-Zeile | UNKLAR | Z22971 | GESTRICHEN/ERLEDIGT-Index (§31-A3 SUPERSEDED §54-T2; §24.F-Routing KORRIGIERT §51-B5/B6; §35-algo_sig->§51-B7; W11 async-Trennung bestaetigt) | - |
| §20.B-hartgruen Pipeline hart-gruen stehende Direktive | OWNER-ENTSCHEID | Z22974 | OFFEN (kritisch, stehende Direktive: GESAMTE Pipeline ce+super/prod1+prod2/alle Stages IMMER hart gruen, keine Schein-Gruen-Toleranz) | - |
| §40.b/§42 Dynamische Planer/CEB-CI duenne super-CI-Delegation | FEATURE | Z22975 | TEIL (kritisch, W10-Legenden-Skelett via §46 produktiv; Grandchild-Selbst-Emission offen, dup §50-W10/§37a) | - |
| §40.c Bare-Metal-Pflicht CMakeGraphBuilder | REGRESSION | Z22976 | TEIL->ERLEDIGT (hoch, A8(c) 20.07.: identischer Bau ohne GitLab-CI, topologie-isomorph) | - |
| §7-CI2..CI6/§2-B3 CI-Test-Haertung comdare_tests Hard-Gate | AUFGABE | Z22977 | OFFEN/TEIL (hoch, 2-Pass-Pflicht gegen Schein-Gruen) | - |
| §14.2-#21 Runner-Cache-Vereinheitlichung dev-MinIO/ccache-S3 | AUFGABE | Z22978 | OFFEN (hoch, infra-gated) | - |
| §13.3-#273 CI-Toolchain gcc-15.3-Pin+clang-Matrix | AUFGABE | Z22979 | TEIL (hoch, T3 clang done, T2 toolchain-gated) | - |
| §13.3-#270b arm64-3-ISA Runner-Freeze H11-H18 | AUFGABE | Z22980 | OFFEN (hoch, infra-gated) | - |
| §15.3-G-a2 baremetal-Runner offline Modus a | AUFGABE | Z22981 | OFFEN (hoch, infra-gated) | - |
| §24.B-Infra Infra-Modus Caching+Storage minio/NFS/HAProxy | AUFGABE | Z22982 | OFFEN (hoch, gated #56) | - |
| §25-Infra-Handout PAT-Rotation #327 exponierter Vault-PAT | REGRESSION | Z22983 | OFFEN-REGRESSION (hoch/SOFORT — Security SOFORT, deadline-unabhaengig) | - |
| §35 Cluster-parallele System-Achsen-Builds parallel:matrix | AUFGABE | Z22984 | TEIL (hoch) | - |
| §36 Pool-Modell Node-bevorzugte Builds resource_group-Locking | AUFGABE | Z22985 | TEIL (hoch) | - |
| §46-avx512 avx512-Erweiterung der Kette Anschluss-Increment | AUFGABE | Z22986 | OFFEN (hoch, nicht im §33-Kern no_ext/avx2) | - |
| §11-E/#186 EPIC CI laufend eigener Sammel-Anker | AUFGABE | Z22987 | TEIL (mittel) | - |
| §8-INFRA Infra-Handover-Paket (Runner ISA×OS, k8s, NAS, MinIO-Rotation) | AUFGABE | Z22988 | GEPARKT (mittel) | - |
| §13.3-#270a P/E-Core-Auto CPUID Leaf 0x1A | AUFGABE | Z22989 | OFFEN (mittel, hw-gated, 14900KS-RMA) | - |
| §13.3-#204 sanitize-hart+TSan-Job | AUFGABE | Z22990 | OFFEN/GEPARKT (mittel, infra/hw-gated) | - |
| §14.6-#277 ccache-S3-Archivgroessen-Messung | AUFGABE | Z22991 | TEIL (mittel) | - |
| §20.B-XMLCI SIMD-Gate-Jobs ISA-Pinning | AUFGABE | Z22992 | OFFEN (mittel, user-gated) | - |
| §44.6 Marker-SKIP-Livebeweis Dedup-HIT | AUFGABE | Z22993 | OFFEN (mittel) | - |
| §13.9-A2/§13.12-BLOCKER-7/#266 config-Owner-Gate foundation-b1 vs config-all | REGRESSION | Z22994 | OFFEN-REGRESSION (mittel — in §48 faelschlich als erledigt gelistet, hierher als offene Zeile gezogen; DAS EINE genuin offene Gate) | - |
| §15.8-g-F59 Branch-Hygiene ci-test-ce-bump Loesch-GO | AUFGABE | Z22995 | OFFEN (mittel, je-Repo-GO) | - |
| §13.3-#276 3-ISA-Teilmatrix amd64+arm64 HARTE CI-PFLICHT | AUFGABE | Z22996 | OFFEN (niedrig, ausdruecklich ALLERLETZTE Aufgabe nach Abgabe) | - |
| §13.3-#256/#274/§52-B15 measurement-all-Modul-Migration A1/A5/A7 | OWNER-ENTSCHEID | Z22997 | GO/GEPARKT (niedrig, Projektende; dup §52-B15) | - |
| §13.3-#254 OneDrive-Verbleib-Klaerung ce/modules-Klone | AUFGABE | Z22998 | TEIL (niedrig) | - |
| §0-V4-GINFRA CRC64-Platzhalter binary_blob_writer.hpp:50 | REGRESSION | Z23000 | OFFEN-REGRESSION (niedrig, echte CRC64 ODER Layout-Doku auf 4B/CRC32 korrigieren) | - |

<!-- Segment 18401-23000 vollstaendig gelesen und extrahiert. Ende der Sammelstrecke Leser 5. -->

