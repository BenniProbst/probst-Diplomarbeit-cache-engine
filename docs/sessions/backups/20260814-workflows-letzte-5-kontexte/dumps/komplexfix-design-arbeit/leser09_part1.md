# LESER 9 — Teil 1 (wqxpvgwwt, wsb78kl70, wqjxtc4jv)

### [wqxpvgwwt.json] 1
GEGENSTAND: Gate 8 (Graph-Landung) fertig: 23 neue Abbildungs-Namen je Sprache in A_measurements.tex (DE+EN) im 289-Thesis-Repo eingetragen, neue Sektionen A.4/A.5/A.8.
ORT: Commit 8970465dcc6fff41a1e1ab74606d6dce2a457224 auf Branch b-gate8-graph-abbildungen, Worktree /home/comdare/wt-b-gate8 (Basis origin/main = 29a1700); Dateien anhang/de/A_measurements.tex + anhang/en/A_measurements.tex (+199/-2)
SOLL/FIX: Landung des Commits steht aus ("Kein Push, kein Merge"). Proben literal gruen: latexmk de RC=0 (202 pages), en RC=0 (192 pages), toc-Eintraege A.4/A.5/A.8 vorhanden, Einbindungs-Probe mit Stellvertreter-Datei greift (lof-Eintrag erscheint nur mit Datei).
STATUS LT. QUELLE: behoben@8970465d (Bau fertig, NICHT gelandet/gepusht)
ABHAENGIGKEIT/FLAECHE: Thesis-Repo (289) main; Namensquelle Code 08_appendix_generator (test :216/:232 = 29 Dateien; volle Ausgabe appendix_generator.cpp:337-520)

### [wqxpvgwwt.json] 2
GEGENSTAND: Bewusste Abweichungen vom Bestandsmuster in A_measurements.tex (im Commit dokumentiert): (1) nur der ERSTE InputIfFileExists einer 6er/3er-Gruppe traegt kursiven Ersatztext, Rest leeres {}; (2) Referenz-Abschnitt A.8 steht VOR der Achsen-Austauschbarkeit (Regel "Verweise rueckwaerts", \ref{sec:measurements:reference}); (3) Kopf-Kommentar "die vier folgenden Darstellungen" auf "die folgenden Darstellungen" korrigiert.
ORT: anhang/{de,en}/A_measurements.tex @ 8970465d
SOLL/FIX: keine Auflage; als Kommentar in den Dateien dokumentiert. Encoding-Konvention: ASCII mit LaTeX-Escapes, eingehalten.
STATUS LT. QUELLE: nur-hinweis (begruendete Abweichungen, erledigt)
ABHAENGIGKEIT/FLAECHE: -

### [wqxpvgwwt.json] 3
GEGENSTAND: NEBENBEFUND: axis_inventory.tex wird von der Facade geschrieben (appendix_generator.cpp:423), ist aber in KEINER .tex des Thesis-Repos eingebunden — dieselbe Luecke wie die 23 Graph-Dateien, nur aelter (nicht aus dem Graph-Umbau).
ORT: appendix_generator.cpp:423 (Writer); Thesis-Repo anhang/ (fehlende Einbindung)
SOLL/FIX: verbatim: "Bewusst nicht mitgeloest, da der Auftrag auf die Graph-Umbau-Dateien lautet; braucht eine eigene Entscheidung, in welchen Abschnitt die Tabelle gehoert."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Owner-/Design-Entscheidung Abschnittszuordnung; Thesis-Repo

### [wsb78kl70.json] 4
GEGENSTAND: T2-A-Nachbesserung nach Dual-Review FERTIG: 4 Commits auf b2-neuanker-format3, HEAD=6c300e68 (Eintritt 847c93c9), kein Push, keine Landung, Working Tree sauber.
ORT: Branch b2-neuanker-format3 @ 6c300e68, Worktree /home/comdare/wt-b2-neuanker
SOLL/FIX: Landung steht aus; Gates literal: 2-Pass-Configure gruen, ctest 2x seriell "100% tests passed, 0 tests failed out of 409" (2x), golden 12/12, golden-320-Waechter 5/5, FROZEN-Beweis 3 Fixtures blob-identisch zu 847c93c9, TABU 0, ASCII 0, Zeilen>120: 0.
STATUS LT. QUELLE: behoben@6c300e68 (nicht gelandet)
ABHAENGIGKEIT/FLAECHE: ce-Repo bestandslog/builder-Flaeche; kollidiert potenziell mit anderen ce-Straengen an batch_planner/planer_driven_build

### [wsb78kl70.json] 5
GEGENSTAND: BEFUND 1 [KRITISCH] Phasen-Zaehler bindet nicht an die Indexfolge: batchplan-v1-Stempel identisch fuer A={0,1,2,3} und B={0,5,7,9} (gleiche front/size/grain) -> fremder Zaehler wird AKZEPTIERT (plan_resume_faecher(B,4)==1).
ORT: libs/cache_engine/builder/bestandslog/batch_planner.hpp (+ planer_driven_build.hpp), Test test_g3_planer_driven.cpp::IndexfolgeIstImStempelGebunden
SOLL/FIX: Geheilt: slice_index_digest = sha512 (ctsha512.hpp) ueber die \n-abgeschlossene Dezimalfolge (injektives Preimage, bewiesen an {1,23} vs {12,3} und {1,2,3} vs {3,2,1}); Format-Bump batchplan-v1 -> v2 (resume-v5->v6-Vorbild); NEU gelesen als B: ABGELEHNT (fail-closed). Ehrlich benannt: Digest != Identitaet (Kollision moeglich). Mitgenommen: Ueberlauf in plan_atome (saettigend + parse_batch_plan verwirft nicht darstellbare Summen) und plan_resume_faecher (f.count > zaehler - kumuliert), Biss mit Fach 2^64-2. Namens-Pin: resume_gemessen() -> vorgefundene_mess_bilanz().
STATUS LT. QUELLE: behoben@511671c9
ABHAENGIGKEIT/FLAECHE: Format-Bump batchplan v1->v2 (On-Disk-Format-Flaeche; Alt-Stempel invalide)

### [wsb78kl70.json] 6
GEGENSTAND: BEFUND 2 [ECHT] fester .tmp-Name in der Ablage: 8 Schreiber x 8 Runden -> 45 bzw. 48 Fehlschlaege (Multi-Writer-Kollision).
ORT: bestandslog-Ablage (builder_registration.hpp-Umfeld), Test AblageIstMultiWriterSicher
SOLL/FIX: Geheilt: tmp-Name = pid + Nanosekunden-Marke + prozess-lokaler Zaehler (kein random_device — Hausdoktrin retry_jitter), .tmp bleibt Endung; Streamstatus nach explizitem close(); Reste auf JEDEM Fehlerpfad geraeumt; current_pid() nach libs/cache_engine/builder/bestandslog/prozess_identitaet.hpp extrahiert (Praezedenz fingerprint_sidecar.hpp). Gruen: 17/17, 0 Fehlschlaege.
STATUS LT. QUELLE: behoben@bcc49119
ABHAENGIGKEIT/FLAECHE: neues Header prozess_identitaet.hpp (geteilte Flaeche mit fingerprint_sidecar-Nutzern)

### [wsb78kl70.json] 7
GEGENSTAND: BEFUND 3 [MITTEL] |fpr=-Form nicht gehaertet: Ablage mit "…128hex…|rows=1\nweiterer-muell" wird fuer KUERZEREN Fingerprint als gueltiger Stamp akzeptiert.
ORT: bestandslog Stamp-Lesepfad; Test Fall 6f
SOLL/FIX: Geheilt: Pruefung ueber detail::fp_is_hex_128 (die EINE Sidecar-Lese-Wahrheit), fail-closed kein Resume/kein Stamp + literale Logzeile. Verschaerfung am Objekt: Alt-Stamp faellt SOFORT am Punkt der Erkennung (erste Fassung liess ihn liegen, Test schlug fehl; Aufruf steigt bei nicht ladbarer .so vorher aus), geprueft im TP1FK1-B10/CX-W4-Muster.
STATUS LT. QUELLE: behoben@823f6eb5
ABHAENGIGKEIT/FLAECHE: fp_is_hex_128 als Single-Source (Sidecar-Flaeche)

### [wsb78kl70.json] 8
GEGENSTAND: BEFUND 4 [MITTEL] Fingerprint-Provider wurde ZWEIMAL je Binary befragt (zustandsabhaengiger Provider kFpA->kFpB: Gate und Stamp speisten sich aus verschiedenen Werten, Resume griff nicht).
ORT: build_orchestrator.hpp / provision_core; Test Fall 6h
SOLL/FIX: Geheilt: BuildResult::fingerprint traegt den EINEN in provision_core gelesenen Wert (Muster algo_sig). Gruen: 1 Aufruf, Resume greift. Zusatztests: (6e) literaler v5-On-Disk-Stamp wird invalidiert + Gegenprobe Wache trennt statt sperrt; (6g) F8-Doktrin als ERWARTUNG festgeschrieben (gleicher Fingerprint -> spaeterer Lauf resumiert) + Doktrin-Absatz im Code, KEIN Verbot gebaut. STAMP entsteht jetzt erst NACH dem Bau-Fehler-Zweig.
STATUS LT. QUELLE: behoben@823f6eb5
ABHAENGIGKEIT/FLAECHE: F8 bleibt Owner-Frage (Cross-Run-Verbot bewusst nicht gebaut)

### [wsb78kl70.json] 9
GEGENSTAND: BEFUND 5 [HOCH] F1-Spiegel im Experiment-Zwilling: ENTSCHEID = SPIEGELN; compose_system_zell_pfad-Spiegel (5 Zeilen) in experiment_run_entry.hpp, da der Defekt real und produktiv ist (super Code/02_messung_driver/main.cpp:1200/:1247) und perm_parts im Zwilling bereits steht (Lane F R3).
ORT: libs/cache_engine/profile_facade/experiment_run_entry.hpp @ 6c300e68
SOLL/FIX: Umgesetzt. EHRLICH-Vermerk verbatim: "fuer die WIRKUNG (output_dir je Zelle) gibt es in KEINEM der beiden Zwillinge einen Verhaltenstest — auch der Ur-F1-Commit 61a95bae hat nur die reine Funktion gewacht (T-d). Der Spiegel ist so gedeckt wie sein Vorbild, nicht besser."
STATUS LT. QUELLE: behoben@6c300e68 (Verhaltenstest-Luecke output_dir je Zelle bleibt OFFEN in beiden Zwillingen)
ABHAENGIGKEIT/FLAECHE: F1-Flaeche (super 02_messung_driver <-> ce profile_facade Zwilling); Test-Luecke = Folge-Posten

### [wsb78kl70.json] 10
GEGENSTAND: clang-format-Gate STEHT AUS: auf der Maschine nicht verfuegbar (command -v clang-format -> nicht vorhanden, kein /usr/bin/clang-format*, kein /usr/lib/llvm*/bin/clang-format). Als "Nicht bestanden" gemeldet.
ORT: Worktree /home/comdare/wt-b2-neuanker, Branch b2-neuanker-format3
SOLL/FIX: clang-format-Gate vor/bei Landung nachholen (Werkzeug beschaffen oder Gate auf anderer Maschine fahren).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Lande-Gate der T2-A-NB-Commits

### [wsb78kl70.json] 11
GEGENSTAND: NICHT GEHEILT (bewusst): Cross-Run/F8 nur als Doktrin festgeschrieben (Test 6g + Code-Absatz), kein Verbot — bleibt Owner-Frage F8; read_batch_plan nie aufgerufen: fail-closed by design, unberuehrt.
ORT: bestandslog (batch_planner/planer_driven_build)
SOLL/FIX: Owner-Frage F8 entscheiden; read_batch_plan bewusst unberuehrt.
STATUS LT. QUELLE: offen (Owner-Frage)
ABHAENGIGKEIT/FLAECHE: Owner-Frage F8

### [wsb78kl70.json] 12
GEGENSTAND: NEU NOTIERT (am Objekt verifiziert, nicht im Auftrag): cache_engine_builder_iterator.hpp:2340 bildet den Plan-Stempel des MESS-Laufs mit hartem bestandslog::kBuildSliceGrain, waehrend der Bau-Weg das Korn als Parameter fuehrt (:1109). Bei abweichendem Korn divergieren die Stempel -> fail-closed (kein Zaehlerschrieb), heute nur aus Tests erreichbar.
ORT: libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:2340 vs :1109
SOLL/FIX: Quelle nennt keinen Fix; Konsistenz Korn-Parameter vs. hartes kBuildSliceGrain herstellen (Design-Posten).
STATUS LT. QUELLE: offen (nur notiert)
ABHAENGIGKEIT/FLAECHE: Beruehrt batchplan-v2-Stempelflaeche aus Befund 1

### [wsb78kl70.json] 13
GEGENSTAND: Die 4 Voll-Scope-Befunde aus der Task-Liste waren NICHT Teil dieses Auftrags und sind NICHT angefasst: (a) Bau-Zaehler vor Push-Drain, (b) Mess-Zaehler kein Praefix, (c) zwei Fortschritts-Wahrheiten, (d) Zaehler umgeht dll_is_current.
ORT: bestandslog/builder (genaue Orte in der Task-Liste des Voll-Scopes)
SOLL/FIX: separat beheben (Voll-Scope-Task-Liste).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: gleiche Zaehler-/bestandslog-Flaeche wie Befunde 1-4; Dedup mit anderen Lesern noetig

### [wqjxtc4jv.json] 14
GEGENSTAND: P4-Vorzieher HONEST-EMPTY im Stufe-05-Flaechen-Writer FERTIG: op_<art>_n gelesen, Phantom-0 getilgt, Platzhalter statt pgfplots-Fatal; ein Commit, Fable-Review-Verdikt LANDEBEREIT.
ORT: Commit ba5e48eb auf b-honest-empty (Basis b247661a = origin/development), Worktree /home/comdare/wt-b-honest-empty; Dateien Code/05_diagram_generator/{diagram_generator.cpp,diagram_generator.hpp,tests/test_05_diagram_generator_cached_fixtures.cpp} (+419/-43)
SOLL/FIX: Landung steht aus (kein Push, kein Merge). Gates literal gruen: BUILD_RC=0, Modul-Tests 2x [PASSED] 25, ctest 2x "100% tests passed, 0 tests failed out of 38", D-03-Probe vorher pgfplots-Fatal/nachher PDFLATEX_RC=0, ASCII TREFFER=0, porcelain 0. Review reproduzierte alle Kernbehauptungen unabhaengig (eigener Frischbau + Gegenbau der Basis).
STATUS LT. QUELLE: behoben@ba5e48eb, Review LANDEBEREIT (nicht gelandet)
ABHAENGIGKEIT/FLAECHE: super-Branch (Task-Rahmen nennt landereif "bau/f1-1x1-honest-empty" — Objektname hier b-honest-empty, Abgleich beim Designer); Stufe-05-Flaeche

### [wqjxtc4jv.json] 15
GEGENSTAND: Begruendete Plan-Abweichungen im HONEST-EMPTY-Fix: (1) z-Koordinate wird NICHT nan (pgfplots verwirft nan-Koordinaten -> stille Fehl-Darstellung; unbounded coords=jump -> Fatal; reine (x,y)-Paare -> Fatal) — gewaehlt: Auslass ueber point meta = nan, dritte Koordinate blanker Mesh-Traeger 0; (2) Achsen schrumpfen NICHT auf Datenteilmenge (mesh/cols=1 / 1-zeilige Matrix selbst fatal); (3) Plan-Aenderungen B (Stufe 08) und C (A_measurements.tex) nicht mehr noetig — Platzhalter liefert status_ok und existierende Datei; (4) write_surface3d mitgezogen (Task nannte nur write_heatmap).
ORT: Code/05_diagram_generator/diagram_generator.cpp @ ba5e48eb
SOLL/FIX: keine — empirisch belegte Abweichungen; Review bestaetigt Abweichung 3 am Code (appendix_generator.cpp:347-352 hard-failt bei rc != status_ok, status_ok des Platzhalters tragend und richtig).
STATUS LT. QUELLE: nur-hinweis (erledigt, dokumentiert)
ABHAENGIGKEIT/FLAECHE: Falls ein anderer Strang Plan-Aenderungen B/C an Stufe 08 / A_measurements umsetzt: KONFLIKT — laut diesem Stand nicht mehr noetig

### [wqjxtc4jv.json] 16
GEGENSTAND: Latenter Bestandsfehler (ausserhalb Auftrag, nicht angefasst): Korpus mit nur EINEM search_algo ODER nur EINEM workload erzeugt 1xN-/Nx1-Matrix -> matrix plot* bricht fatal ("'matrix input=image' is unsupported for line plots", Probe belegt). Review: nach Code-Lektuere plausibel, vorbestehend.
ORT: Code/05_diagram_generator/diagram_generator.cpp (write_heatmap/matrix-plot-Pfad)
SOLL/FIX: verbatim: "Kandidat fuer einen Folge-Posten." Vom HONEST-EMPTY-Fix weder verursacht noch behoben.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Stufe-05-Flaeche; unabhaengig vom gelandeten Fix

### [wqjxtc4jv.json] 17
GEGENSTAND: Review-Zusatzbefund: test_axis_registry_roundtrip failt mit BYTE-DRIFT (committete Registry-XML vs. Code-Reflektion) INNERHALB des gepinnten CE-Submoduls (ce=7969b399) im Voll-ctest ausserhalb des zitierten Gates; nicht dem Fix attributierbar (Gitlink HEAD~1->HEAD identisch). 2 Geschwister-Roundtrips brauchen nur den dokumentierten 2-Pass-Generator-Bau (lokale Bau-Luecke). Kalter Voll-Lauf zeigt reihenfolge-abhaengige Erstlauf-Failures, die sich im Zweitlauf selbst heilen (bekanntes Voll-Bau-Luecken-Muster).
ORT: super Voll-ctest, ce-Submodul-Pin 7969b399; test_axis_registry_roundtrip
SOLL/FIX: Quelle: vorbestehend bei ce=7969b399 unter dieser Konfiguration; kein Fix im Scope. Abgleich mit J-1..J-4-Doktrin (Vollbau-Luecken = falsches Gruen) noetig.
STATUS LT. QUELLE: offen (vorbestehend)
ABHAENGIGKEIT/FLAECHE: ce-Submodul-Pin in super; Registry-XML-Drift-Flaeche

### [wqjxtc4jv.json] 18
GEGENSTAND: Review-Hinweis: 3D-Pfad bei TEIL-Daten hebt nicht-ausgefuehrte Zellen weiter auf den 1e-3-Boden — vorbestehendes Darstellungsverhalten, unveraendert; nur Voll-Datenlosigkeit ist jetzt ehrlich.
ORT: Code/05_diagram_generator/diagram_generator.cpp (write_surface3d, Teil-Daten-Pfad)
SOLL/FIX: keiner benannt (scope-konform belassen); moeglicher Folge-Posten Ehrlichkeit des 3D-Teil-Daten-Pfads.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Stufe-05 3D-Pfad
