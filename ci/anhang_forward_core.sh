#!/usr/bin/env bash
# =====================================================================================
# anhang_forward_core.sh -- KERN des LaTeX-Anhang-VORWAERTS-Kanals (E-18, Paket B1).
#
# WARUM DIESE DATEI EXISTIERT (und nicht alles im YAML steht):
#   Der Kanal MUSS ohne CI und ohne echte Messung an einem Fixture beweisbar sein
#   (Idempotenz, Whitelist, NO-OP, Nichts-Loeschen). Ein YAML-Script-Block ist nicht
#   fahrbar; darum liegt die gesamte Kern-Logik hier, env-parametrisiert, und die
#   .gitlab-ci.yml umhuellt sie nur mit Credentials + Klon + Gitlink-Bump.
#   EINE Quelle statt zwei -- was die CI tut, ist genau das, was das Fixture beweist.
#
# WAS DER KERN TUT (Quellen-Kaskade, deterministisch):
#   (1) frische Pipeline-Artefakte  <root>/<lang>/tabellen/*.tex   (AF_ARTIFACT_ROOTS,
#       in DEKLARIERTER Reihenfolge; der erste Wurzel-Kandidat mit >0 .tex gewinnt)
#   (2) sonst Korpus-Regeneration aus dem NEUESTEN <AF_CORPUS_ROOT>/<RUN_TS>/ mit
#       Mess-CSV (Selektor AF_RESULT_NAMEN: 'result.csv' UND '*.result.csv';
#       replace-Semantik: neuester Lauf gewinnt) -> WIDE-Konkatenation
#       -> appendix-generator
#   (3) sonst honest-empty: NO-OP-Testat, Exit 0, KEIN Commit
#       (die Thesis haelt das per \InputIfFileExists aus -- Weg A ist gebaut)
#   Danach: Whitelist-Kopie nach <AF_DEST_REPO>/anhang/<lang>/tabellen/, Idempotenz-
#   Pruefung (Commit NUR bei Byte-Delta), Commit mit Provenance, Push mit MERGE-Retry.
#
# HARTE ZUSAGEN (am Fixture bewiesen, s. Plan-Dossier Abschnitt B-2):
#   * schreibt AUSSCHLIESSLICH nach anhang/<lang>/tabellen/<name>.tex  (Whitelist)
#   * loescht NIEMALS Bestand im Ziel-Repo: kein `git rm`, kein `git clean`, kein --force.
#     Der EINZIGE rm-Pfad im Ziel-Repo ist der Rollback bei ROTEM PDF-Gate, und der
#     entfernt AUSSCHLIESSLICH Pfade, die DIESER Lauf selbst neu angelegt hat: Grundlage
#     ist die Buchfuehrungs-Liste $COPIED_LIST, jeder Eintrag wird zusaetzlich gegen
#     `git ls-files --error-unmatch` geprueft. Getrackte Dateien werden per `git checkout`
#     zurueckgeholt (nie geloescht); fremde unversionierte Dateien im selben Verzeichnis
#     bleiben unangetastet (am Fixture sha256-identisch nachgewiesen).
#     (Der zweite rm-Pfad liegt AUSSERHALB des Ziel-Repos und beruehrt keinen Bestand:
#      das trap-Cleanup der EIGENEN, unveroeffentlichten .tmp-Ordner, s. E-18-SNAP unten.)
#   * ohne Byte-Delta entsteht KEIN Commit  (Loop-/Rausch-Wache) -- und "kein Delta"
#     ist BELEGT, nicht behauptet: jede kopierte .tex wird gegen den Index des
#     Ziel-Repos nachgezaehlt; erreicht eine den Index nicht, bricht der Kanal LAUT
#     ab statt "IDEMPOTENT" zu melden (##20, 10.08.2026, Falle F5 unten).
#     E-18-SNAP macht daraus KEINE Ausnahme: "0 Byte-Delta" beendet den Kanal erst,
#     wenn zusaetzlich ein gueltiger Compile-Beleg zum 289-Stand existiert (s.u.).
#   * ohne Quelle entsteht KEIN Commit und KEIN Fehler (honest-empty)
#   * landet AUF EINEM TeX-FAEHIGEN RUNNER nie einen Stand, mit dem die Thesis-PDF nicht
#     mehr baut (PDF-GATE; deklarierter Geltungsbereich + Grenzen s.u. -- ohne
#     TeX-Toolchain prueft AF_PDF_GATE=auto NICHTS und sagt das literal)
#   * kein Haken ohne Ausgabe: jede Stufe druckt ihren literalen Zaehler
#
# FUENF TRANSPORT-FALLEN, GEHEILT AM 09./10.08.2026 (P4 + Nachsatz + ##20) -- alle still:
#   (F1) DER SELEKTOR TRAF DIE REALE DATEI NIE. Gesucht wurde '-name "*.result.csv"'
#        (:149 :153 :165 der Vorfassung); der lebende Messweg schreibt 'result.csv'
#        OHNE Praefix. Der Glob verlangt mindestens ein Zeichen plus Punkt davor.
#        Selbst nachgemessen: ein Verzeichnis mit result.csv UND perm_007.result.csv,
#        dann 'find -name "*.result.csv"' liefert ausschliesslich perm_007.result.csv.
#   (F2) DIE LEERHEITSPRUEFUNG VERWARF GENAU EINE DATENZEILE. 'wc -l' zaehlt
#        Zeilenumbrueche; Kopfzeile + EINE Datenzeile ohne Schluss-Newline ergab 1
#        und galt als leer. Das ist exakt der Mini-Messwert des Durchstichs.
#   (F3) DIE KONKATENATION VERKLEBTE ZEILEN. 'tail -n +2 >>' ohne 'awk 1' haengte
#        die erste Datenzeile der naechsten Datei an die letzte der vorigen, sobald
#        der Schluss-Newline fehlte -- aus zwei Messwerten wurde eine kaputte Zeile.
#   (F4) DER HEADER-DIEB (Nachsatz, :277 der Fassung davor). Der Header wurde von
#        der ersten Datei genommen, die der Schleife unterkam -- ohne zu pruefen, ob
#        die ueberhaupt eine erste Zeile HAT. Eine 0-Byte-result.csv, die im 'sort'
#        vor der vollen liegt, lieferte nichts und setzte trotzdem '_hdr=1'; die
#        volle Datei danach kam nur noch durch 'tail -n +2' und verlor ihre
#        Kopfzeile. Das Aggregat war KOPFLOS. Mit EINER Datenzeile der Nachbardatei
#        galt es als leer -> honest-empty, kein Commit, Messwert weg. Mit ZWEI
#        Datenzeilen landete der Commit, und jeder NR>1-Konsument -- auch der echte
#        appendix-generator -- frass die erste Datenzeile als Kopfzeile: ein
#        GRUENER Commit mit einem Messwert weniger. Die Log-Zeile log dabei mit
#        ("1 Zeilen (inkl. 1 Header)", obwohl kein Header da war).
#   (F5) DIE UEBERNAHME INS ZIEL-REPO WURDE NIE NACHGEZAEHLT (10.08.2026, ##20).
#        Gestagt wurde das VERZEICHNIS mit geschluckten Fehlern; ob die kopierten
#        .tex im Index ankamen, hat niemand gefragt. Nahm git sie nicht, sagte der
#        Kanal "IDEMPOTENT: 0 Aenderungen" und ging mit rc=0 -- dasselbe Wort fuer
#        "nichts geaendert" und "nichts angekommen". Ausfuehrlich am Abschnitt (3).
#   Alle fuenf endeten mit rc=0 und einer Ausgabe, die wie ein ehrliches "nichts zu
#   tun" aussah (F4b sogar mit gruenem Commit). Deshalb druckt der Korpus-Zweig
#   jetzt IMMER einen Nenner (korpus_wurzel/vorhanden + laufordner_geprueft/
#   mit_material + header=ja|nein/Datenzeilen) und die Uebernahme ebenfalls
#   (kopiert/im_index/nicht_uebernommen/git_add_fehler): eine Null ohne Nenner ist
#   von einem echten Freispruch nicht zu unterscheiden.
#   Beweis: ci/tests/anhang_forward_probe.sh (Faelle A1-A18, Selbstbiss N1-N7);
#   A15-A18 decken seit 11.08.2026 die zwei E-18-SNAP-Wachen JE MIT GEGENPROBE.
#   Die EINBUCHUNG des Schnappschusses in das 288-Repo liegt NICHT hier, sondern
#   in ci/anhang_snapshot_einbuchen.sh -- Beweis dort in
#   ci/tests/anhang_snapshot_einbuchen_probe.sh (S1-S10, Selbstbiss N1-N3).
#
# WO DIE KONKATENATION SEIT DEM 09.08.2026 WOHNT (P4c):
#   NICHT MEHR HIER. F2/F3/F4 sassen in Zeilen, die WORTGLEICH auch in den beiden
#   measure-Jobs der .gitlab-ci.yml standen -- drei Kopien, von denen nur diese
#   gedeckt war. Sie stehen jetzt EINMAL in ci/wide_aggregat.sh, und alle drei
#   rufen sie. Die Mutanten N2/N3/N5 greifen dort an und decken damit alle drei
#   Aufrufer; Fall A11 haelt fest, dass kein vierter Zwilling zurueckkehrt.
#   HIER GEBLIEBEN ist, was nur den Anhang-Kanal angeht: der Selektor (F1), das
#   'sort' und das Urteil ueber die Zahl (honest-empty).
#
# OFFEN, ausdruecklich NICHT geraten: AF_CORPUS_ROOT zeigt in der Voreinstellung
#   (und im CI-Job, .gitlab-ci.yml AF_CORPUS_ROOT="measurement") auf 'measurement'
#   am Repo-Root. Dieses Verzeichnis EXISTIERT dort nicht mehr -- 'git ls-files
#   measurement/*' liefert 0 Eintraege, der getrackte Korpus liegt seit dem
#   08.08.2026 unter docs/architektur/measurement/ (18 Dateien). Zur CI-Laufzeit
#   legt persist:measurements den Pfad auf dem baremetal-Workspace selbst an; ob
#   der Kanal DEN oder den getrackten Korpus lesen soll, ist eine Owner-Frage und
#   wird hier NICHT durch eine geratene Zweit-Wurzel beantwortet: der archivierte
#   Baum liegt eine Ebene tiefer verschachtelt, eine automatische Aufnahme wuerde
#   den Erstbeleg vom 26.07. als "neuesten Lauf" vorwaerts schieben. Statt zu
#   raten sagt der Kanal jetzt literal 'vorhanden=nein' und nennt den Nenner.
#
# PDF-GATE -- WARUM ES HIER STEHT UND NICHT ERST IN DER 289-PIPELINE:
#   Am Fixture (2026-08-05, echte D-03-Erstbeleg-Daten) hat sich gezeigt, dass der
#   Generator fuer eine Metrik OHNE Messwerte trotzdem eine Heatmap schreibt, deren
#   z-Matrix komplett 0.0000 ist; pgfplots bricht daran FATAL ab ("Error using 'plot
#   graphics': I got too few coordinates") und es entsteht GAR KEINE PDF. Die 12
#   Kern-Tabellen haengen in A_measurements.tex an blankem \input (nur die 5
#   Darstellungs-.tex an \InputIfFileExists) -- eine einzelne Datei wegzulassen ist also
#   KEINE Rettung. Der Kanal prueft darum VOR dem Commit, ob die Thesis mit dem neuen
#   Stand noch baut, und verweigert im Fehlerfall ALLES (alles-oder-nichts, fail-loud).
#   Ohne diese Wache wuerde E-18 einen kaputten Anhang in die Thesis schieben und die
#   PDF-Strecke reissen -- das genaue Gegenteil seines Zwecks.
#
# PDF-GATE -- DEKLARIERTER GELTUNGSBEREICH (bewusste Grenze, kein Versehen):
#   (a) EIN Hauptdokument. run_pdf_gate waehlt das ERSTE Top-Level-*.tex mit \documentclass
#       (`grep -lE '^[^%]*\\documentclass' -- *.tex | head -1`) und baut NUR dieses. Heute
#       deckungsgleich mit dem Vollbestand, weil Projekt 289 genau EIN Top-Level-Haupt-
#       dokument traegt (diplomarbeit.tex; am Gitlink-Checkout 05.08.2026 verifiziert).
#       SEIT 2026-08-13 WACHT DAS GATE SELBST (Verify-Fall E): bei MEHR als einem Haupt-
#       dokument ist on ein FEHLER (Teil-Pruefung als Gruen waere eine Luege) und auto sagt
#       LAUT, was ungeprueft bleibt. Wer ein zweites einfuehrt (z.B. ein EN-Hauptdokument),
#       erweitert diese Auswahl auf eine LISTE; bis dahin gilt die Zusage ausdruecklich nur
#       fuer das erste Hauptdokument.
#   (b) KEINE TeX-Toolchain => KEINE Pruefung. AF_PDF_GATE=auto ueberspringt das Gate auf
#       Runnern ohne latexmk/pdflatex und LOGGT das literal ("hier wurde NICHT geprueft").
#       Die Zusage "landet nie einen kaputten Stand" gilt also nur auf TeX-faehigen
#       Runnern; das Restnetz ausserhalb davon ist die 289-Pipeline NACH dem Push.
#       Wer die Pruefung erzwingen will, setzt AF_PDF_GATE=on (fehlende Toolchain = Fehler).
#   (c) Das Gate prueft die BAUBARKEIT, nicht die inhaltliche Richtigkeit der Tabellen.
#
# E-18-SNAP -- COMPILE-SCHNAPPSCHUSS (OWNER-KERN, Ledger frueh-6, VERBATIM):
#   "in Zukunft soll die Diplomarbeit einerseits fertig auf den branch gepusht werden, aber
#    andererseits wird sie zusaetzlich in einen Ordner an der Wurzel der Messwerte kopiert, samt
#    latex compile-export (Benennung nach Datum und Uhrzeit). so laesst sich ein compile
#    nachvollziehen."
#   UMSETZUNG: das PDF-Gate baut die Thesis-PDF ohnehin schon (s.o.) -- E-18-SNAP ERNTET dieses
#   Bau-Produkt, statt ein zweites Mal zu kompilieren. Es landet zusaetzlich unter
#   <AF_SNAPSHOT_ROOT>/<JJJJMMTT-HHMMSS>-<LAUF-KENNUNG>/ :
#     <haupt>.pdf         die kompilierte Diplomarbeit (Kopie, sha256-verifiziert)
#     compile-export.txt  der vollstaendige latexmk/pdflatex-Lauf (der "latex compile-export")
#     QUELLSTAND.txt      289-SHA + 288-SHA + Kanal-Lauf-ID -> der Compile ist nachvollziehbar
#
#   WARUM compile-export.txt UND NICHT compile.log (load-bearing, nicht kosmetisch): die super-
#   .gitignore ignoriert global `*.log` (Zeile 49) und hat -- anders als fuer `*.csv` (Zeile 43
#   `!measurement/**/*.csv`) -- KEINE Gegenausnahme fuer measurement/. Ein `compile.log` wuerde vom
#   `git add` des Writebacks STILL weggeworfen; der Schnappschuss kaeme ohne sein Kernstueck an.
#   Die .txt-Endung haelt den Schnappschuss ohne .gitignore-Aenderung trackbar; Alternative waere
#   ein `!measurement/**/*.log` analog zur CSV-Zeile (Entscheid Lead, s. Backup-ANWENDUNG.md).
#
#   (NB2-1) RUNNERUEBERGREIFEND EINDEUTIGER NAME statt verteilter Reservierung (Codex HOCH-2):
#   der Zeitstempel allein kollidiert, sobald zwei Laeufe in derselben Sekunde auf VERSCHIEDENEN
#   Runnern liegen -- und dagegen hilft KEIN lokaler Lock: getrennte Dateisysteme, beide sehen den
#   Remote-Stand frei. Der Ordnername traegt darum die LAUF-KENNUNG:
#       r<CI_RUNNER_ID>-j<CI_JOB_ID>        in der CI (job-global eindeutig, von GitLab vergeben)
#       h<hostname>-p<PID>                  lokal/Fixture (Rueckfall, wenn die CI-Variablen fehlen)
#   Damit ist der Name OHNE jede Reservierung disjunkt. Die drei Kollisions-Wachen (lokal ->
#   REMOTE -> mkdir-Lock) bleiben als GURT bestehen, aber der mkdir-Fehler wird jetzt nach ART
#   unterschieden: nur ein bereits existierender Pfad ist eine Kollision (-> naechstes Suffix);
#   EACCES/ENOSPC/fehlender Parent sind FATAL und brechen SOFORT ab, statt 99 sinnlose Retries zu
#   drehen (Codex: Liveness).
#
#   (NB2-5) TRANSAKTIONALES SCHREIBEN: der Schnappschuss entsteht in einem VERSTECKTEN Ordner
#   ".<name>.tmp" und wird erst nach der vollstaendigen Beleg-Pruefung ATOMAR per `mv` auf seinen
#   Endnamen gezogen. Ein abgerissener Lauf hinterlaesst darum NIE einen halben Ordner unter dem
#   Endnamen; sein eigener .tmp-Rest wird per trap aufgeraeumt (nur EIGENE, nie fremde). Der
#   Endname existiert erst, wenn der Beleg vollstaendig und geprueft ist.
#
#   ADDITIV, NIE UEBERSCHREIBEN (Messdaten-Doktrin): existiert der Endname wider Erwarten schon,
#   waechst ein Kollisions-Suffix -2, -3, ... an. Ein bestehender Ordner wird NIE angefasst, nie
#   ueberschrieben, nie geloescht -- auch nicht teilweise.
#
#   (NB2-3) EIN GEMEINSAMER BELEG-VALIDATOR: ob ein Schnappschuss "existiert", entscheidet AN
#   JEDER STELLE dieselbe Funktion -- lokal wie im Remote-Stand. Sie verlangt ALLE Pflichtstuecke
#   (<haupt>.pdf nicht leer + compile-export.txt nicht leer + QUELLSTAND.txt), die VOLLSTAENDIGE
#   Zeile `thesis_commit_sha=<40-hex>` (nicht irgendein Teiltreffer), eine nicht-leere 288-SHA und
#   Lauf-ID sowie sha256-Konsistenz zwischen `pdf_sha256=` und der danebenliegenden PDF. Ein
#   HALBER Ordner gilt damit NIE als Beleg -- weder als Grund, den Compile zu ueberspringen, noch
#   als belegter Kollisionsname. Die REMOTE-Suche laeuft ausschliesslich ueber QUELLSTAND.txt-
#   Pfade UNTERHALB der Schnappschuss-Wurzel (Pfadvergleich literal, kein Glob, kein Pathspec).
#
#   ENTKOPPELT VOM ANHANG-BYTE-DELTA (Codex HOCH-1, load-bearing): frueher entschied ALLEIN das
#   Byte-Delta im Anhang, ob ueberhaupt ein Compile und damit ein Schnappschuss entsteht. Ein Lauf,
#   der 289 erfolgreich pusht und danach stirbt (Runner-Crash, 288-Writeback rot), verlor seinen
#   Compile-Beleg damit DAUERHAFT: der Retry findet einen idempotenten Anhang (0 Delta) und stieg vor
#   dem PDF-Gate aus. Ein Marker im Workspace hilft nicht -- der Workspace stirbt mit dem Job.
#   WAHRE QUELLE ist darum der VERGLEICH 289 gegen 288: existiert unter <AF_SNAPSHOT_ROOT> (lokal
#   ODER im Remote-Stand) ein gueltiger Beleg mit `thesis_commit_sha=<289-SHA>`? Wenn nein, holt der
#   Kanal den Beleg NACH (Modus "nachholen"/"recovery": Gate bauen, ernten, ablegen) -- OHNE
#   289-Commit und OHNE Push, denn es gibt kein Delta.
#
#   (NB2-2) RECOVERY-IDENTITAET -- gegen WELCHE SHA der Retry prueft (Codex HOCH-1-Rest): der
#   aktuelle 289-HEAD ist die FALSCHE Frage, sobald zwischen Absturz und Retry ein FREMDER Commit
#   gelandet ist. Der Kanal fuehrt darum zwei vom aktuellen HEAD unabhaengige Quellen:
#     (i)  MARKER im 288-Baum: VOR jedem Push-Versuch schreibt der Kanal
#          <AF_SNAPSHOT_ROOT>/PENDING-<LAUF-KENNUNG>.txt mit der SHA, die gleich gepusht wird.
#          Der 288-Writeback stagt diese Datei mit; ein spaeterer Lauf liest sie (lokal ODER aus
#          dem Remote-Stand) und weiss, welcher 289-Stand einen Beleg schuldet. Erfuellte Marker
#          werden NICHT geloescht, sondern um `erfuellt_durch=<snapshot_id>` ERGAENZT (additiv).
#          GRENZE (deklariert): erreicht ein Lauf den 288-Writeback ueberhaupt nicht mehr, stirbt
#          auch sein Marker mit dem Workspace -- dafuer gibt es (ii).
#     (ii) BOT-HISTORIE in 289: die Commits des Kanal-Bots auf dem Ziel-Branch sind selbst die
#          dauerhafte Spur. Der Kanal sucht die juengsten AF_RECOVER_TIEFE Bot-Commits ab und
#          nimmt den juengsten OHNE gueltigen Beleg. Diese Quelle ueberlebt jeden Runner-Tod.
#   Der Beleg wird dann fuer GENAU DIESE SHA gebaut: der 289-Klon wird auf sie detached, das Gate
#   laeuft ERZWUNGEN neu (s.u.), danach wird der Klon nachweislich auf seinen Ausgangs-HEAD
#   zurueckgesetzt -- ein zurueckgelassener alter HEAD wuerde den Gitlink des Writebacks RUECKWAERTS
#   setzen. Pro Lauf wird hoechstens AF_RECOVER_MAX Beleg nachgeholt; der naechste Lauf holt den
#   naechsten (monotoner Fortschritt statt langer Nachhol-Ketten in einem Job).
#
#   RE-FIXIERUNG NACH NON-FF-PUSH (Codex HOCH-3): der Push-Retry (5) kann einen MERGE-Commit
#   erzeugen. Dann ist der tatsaechlich gelandete HEAD ein anderer als der, aus dessen Baum die PDF
#   gebaut wurde -- ein Schnappschuss mit der alten SHA waere eine DIVERGENTE Dokumentation ("diese
#   PDF gehoert zu Commit X", obwohl X nie so auf dem Branch stand). Phase 2 laeuft darum NACH dem
#   Push und vergleicht den gepushten BAUM mit dem gebauten: gleich => das Bau-Produkt gilt
#   unveraendert; ungleich => RE-ERNTE aus dem gemergten Baum.
#   (NB2-4) DIE RE-ERNTE IST ERZWUNGEN FRISCH: `latexmk -gg` (bzw. beim pdflatex-Rueckfall das
#   Loeschen der Zwischenprodukte) PLUS Loeschen der alten PDF PLUS Neuheits-Wache (die PDF MUSS
#   juenger sein als der Bau-Beginn). Ohne das koennte latexmk "Nothing to do" melden und die ALTE
#   PDF wuerde mit der NEUEN SHA beschriftet -- genau die Luege, die HOCH-3 verhindern soll.
#   Scheitert die Re-Ernte, wird KEIN Schnappschuss abgelegt und der Kanal bricht LAUT ab.
#
#   DEKLARIERTE GRENZE (bewusst, kein Versehen): OHNE Compile gibt es KEINEN Schnappschuss. Wird
#   AF_PDF_GATE uebersprungen (auto ohne TeX-Toolchain) oder ist es off, entsteht gar kein
#   Bau-Produkt -- dann sagt die Funktion das LITERAL, statt einen leeren Ordner anzulegen. Die
#   AF_PDF_GATE-Semantik bleibt dadurch UNVERAENDERT: E-18-SNAP erzwingt kein Gate und verschiebt
#   keine Gate-Grenze, es erntet ausschliesslich, was das Gate ohnehin baut.
#
#   WER COMMITTET: der Kern LEGT den Schnappschuss nur an. In das super-Repo (288) bringt ihn der
#   BESTEHENDE 288-Writeback des Job-Blocks (heute der Gitlink-Bump) -- der muss measurement/
#   mitstagen. Solange diese Job-Block-Aenderung nicht angewandt ist, entsteht der Ordner im
#   CI-Workspace und wird am Pipeline-Ende verworfen (kein Datenverlust, aber auch kein Nutzen).
#
# ENV-KONTRAKT
#   AF_DEST_REPO      (Pflicht) Arbeitsklon des Thesis-Repos (Projekt 289)
#   AF_BRANCH         Ziel-Branch im Ziel-Repo                      (Default: development)
#   AF_LANGS          Komma-Liste der Sprachen                      (Default: de,en)
#                     KONTRAKT: je Eintrag nur [A-Za-z0-9_-]; Duplikate werden entfernt.
#   AF_WORK_ROOT      Basis fuer Artefakt-/Korpus-Pfade             (Default: .)
#   AF_ARTIFACT_ROOTS Leerzeichen-Liste der Artefakt-Wurzeln
#                     (Default: Code/measure_out/appendix Code/measure_out_smoke/appendix)
#   AF_CORPUS_ROOT    Rueckschreibe-Korpus                          (Default: measurement)
#                     ACHTUNG: dieser Default zeigt am Repo-Root ins Leere, s.o.
#   AF_RESULT_NAMEN   Namensformen der Mess-CSV, Leerzeichen-Liste
#                     (Default: "result.csv *.result.csv" -- BEIDE; OV-17 ERFUELLT, 6d2e3dce 09.08.2026; par.25)
#   AF_GENERATOR      Pfad zur appendix-generator-Binary            (Default: leer)
#   AF_WIDE_AGGREGAT  Pfad zur EINEN WIDE-Konkatenation
#                     (Default: <verzeichnis dieser datei>/wide_aggregat.sh)
#                     Die Probe setzt ihn auf ihre Mutanten (Selbstbiss N2/N3/N5).
#   AF_TMP            Arbeitsverzeichnis                            (Default: mktemp -d)
#   AF_DRY_RUN        true => kopieren+stagen, aber KEIN Commit, KEIN Push
#   AF_NO_PUSH        true => Commit ja, Push nein (Fixture ohne Remote)
#   AF_PDF_GATE       auto (Default) | on | off -- PDF-Bau-Wache vor dem Commit. Jeder ANDERE
#                     Wert ist seit 2026-08-13 ein sofortiger FEHLER (wirkte vorher still wie auto).
#                     auto: laeuft, wenn TeX-Toolchain UND Haupt-.tex vorhanden sind;
#                     on:   fehlende Toolchain ODER mehr als EIN Haupt-.tex ist ein FEHLER;
#                     off:  bewusst abgeschaltet.
#                     Geltungsbereich s.o. (a)-(c): NUR das ERSTE Top-Level-Haupt-.tex.
#   AF_PUSH_RETRIES   Push-/Merge-Versuche                          (Default: 5)
#   AF_PROV_*         Provenance fuer die Commit-Botschaft (PIPELINE_ID/URL/SUPER_SHA/REF)
#   AF_COMPILE_SNAPSHOT true (Default) | false -- E-18-SNAP-Compile-Schnappschuss an/aus
#   AF_SNAPSHOT_ROOT  Wurzel der Schnappschuss-Ordner ("Wurzel der Messwerte")
#                     (Default: <AF_WORK_ROOT>/<AF_CORPUS_ROOT>/thesis_compiles)
#                     KONTRAKT (durchgesetzt, s. AF_SNAP_ROOT_STRICT): der Pfad MUSS im
#                     Arbeitsbaum des 288-Repos liegen, DARF NICHT dessen Toplevel selbst sein
#                     und DARF NICHT von .gitignore ignoriert werden -- sonst kann ihn der
#                     288-Writeback nicht committen und der Job waere gruen ohne Beleg.
#   AF_SNAP_ROOT_STRICT true (Default) | false -- Vertrags-Durchsetzung fuer AF_SNAPSHOT_ROOT.
#                     false loggt den Verstoss literal und laeuft ohne REMOTE-Wache weiter
#                     (nur fuer Fixture-/Laborlaeufe; die CI setzt es NIE).
#   AF_SNAP_REMOTE_STRICT true (Default) | false -- FAIL-CLOSED auch beim ERSTEN Fetch der
#                     REMOTE-Wache. Der Re-Fetch vor dem Schreiben war das immer; der Erst-Fetch
#                     lief bis 11.08.2026 mit einer blossen Warnung weiter -- und weil der
#                     Re-Fetch ohne gesetzten REMOTE-Stand sofort mit rc 0 zurueckkehrt, war
#                     sein fail-closed-Zweig genau dann unerreichbar, wenn man ihn braucht.
#                     false = bewusster Rueckfall (Fixture/Labor ohne Remote), literal gemeldet.
#   AF_SNAP_REMOTE    Remote fuer die REMOTE-Wache der Suffix-/Nachhol-Entscheidung (Default: origin)
#   AF_SNAP_REMOTE_BRANCH  Branch dort (Default: $AF_PROV_SUPER_REF; "NA"/leer => REMOTE-Wache aus,
#                     literal gemeldet, Rueckfall auf lokale Pruefung + mkdir-Lock)
#   AF_SNAP_LAUF_KENNUNG  Ordner-Kennung ueberschreiben (Default: r<RUNNER>-j<JOB> bzw. h<host>-p<pid>).
#                     Nur fuer Proben, die eine Kollision ERZWINGEN muessen; die CI setzt es nie.
#   AF_RECOVER_MAX    max. nachgeholte Fremd-Belege je Lauf         (Default: 1)
#   AF_RECOVER_TIEFE  wie viele Bot-Commits die Historien-Recovery absucht (Default: 20)
#
# EXIT: 0 = Commit gelandet ODER bewusst nichts zu tun. 1 = fail-loud (nie stilles Gruen).
# =====================================================================================

# ---- BASH-WACHE (POSIX-Teilmenge; MUSS vor dem ersten Bashismus stehen) -------------
# Dieses Script ist bash (Shebang Zeile 1). Ein Aufruf ueber 'sh' (dash/POSIX-sh)
# starb bisher VOR jeder Arbeit wortkarg an "set: Illegal option -o pipefail" (rc=2,
# F1-Fix-Stufe 13.08.2026). Diese Wache macht den Fehl-Aufruf LAUT, nennt den
# richtigen Aufruf und bleibt im dokumentierten Exit-Vertrag (1 = fail-loud).
if [ -z "${BASH_VERSION:-}" ]; then
  echo "FEHLER: ci/anhang_forward_core.sh ist ein bash-Script (Shebang Zeile 1)." >&2
  echo "        Der Aufruf lief NICHT unter bash (BASH_VERSION leer -- z.B. sh/dash/zsh/ksh)." >&2
  echo "        Richtig: bash ci/anhang_forward_core.sh (die CI ruft es direkt, Shebang greift)." >&2
  exit 1
fi

set -euo pipefail

AF_DEST_REPO="${AF_DEST_REPO:-}"
AF_BRANCH="${AF_BRANCH:-development}"
AF_LANGS="${AF_LANGS:-de,en}"
AF_WORK_ROOT="${AF_WORK_ROOT:-.}"
AF_ARTIFACT_ROOTS="${AF_ARTIFACT_ROOTS:-Code/measure_out/appendix Code/measure_out_smoke/appendix}"
AF_CORPUS_ROOT="${AF_CORPUS_ROOT:-measurement}"
AF_GENERATOR="${AF_GENERATOR:-}"
AF_DRY_RUN="${AF_DRY_RUN:-false}"
AF_NO_PUSH="${AF_NO_PUSH:-false}"
AF_PDF_GATE="${AF_PDF_GATE:-auto}"
# HAERTUNG 2026-08-13 (Verify-Fund 16, F1-Kette): AF_PDF_GATE war ein UNGEPRUEFTES Enum --
# jeder Wert ausser exakt on/off wirkte still wie auto und haette ohne TeX-Toolchain still
# uebersprungen. Fail-closed (II.7): unbekannter Modus stirbt hier LAUT, vor jeder Wirkung.
case "$AF_PDF_GATE" in
  on|off|auto) : ;;
  *) echo "FEHLER: AF_PDF_GATE='$AF_PDF_GATE' ist kein gueltiger Modus (erlaubt: on|off|auto)" >&2; exit 1 ;;
esac
AF_PUSH_RETRIES="${AF_PUSH_RETRIES:-5}"
AF_PROV_PIPELINE_ID="${AF_PROV_PIPELINE_ID:-NA}"
AF_PROV_PIPELINE_URL="${AF_PROV_PIPELINE_URL:-NA}"
AF_PROV_SUPER_SHA="${AF_PROV_SUPER_SHA:-NA}"
AF_PROV_SUPER_REF="${AF_PROV_SUPER_REF:-NA}"
AF_COMPILE_SNAPSHOT="${AF_COMPILE_SNAPSHOT:-true}"
# "Wurzel der Messwerte" = der Rueckschreibe-Korpus; thesis_compiles/ ist dort ein GESCHWISTER der
# measurement/<RUN_TS>/-Laufordner. Das ist mit der Korpus-Kaskade (1b) vertraeglich, WEIL deren
# Laufordner-Auswahl einen Ordner nur nimmt, wenn er *.result.csv enthaelt -- der Schnappschuss legt
# ausschliesslich .pdf/.txt ab und kann daher nie als Mess-Laufordner missgedeutet werden.
# (Wer hier je eine *.result.csv ablegt, bricht genau diese Zusage.)
AF_SNAPSHOT_ROOT="${AF_SNAPSHOT_ROOT:-$AF_WORK_ROOT/$AF_CORPUS_ROOT/thesis_compiles}"
AF_SNAP_ROOT_STRICT="${AF_SNAP_ROOT_STRICT:-true}"
# NB2-REST (a): der ERST-Fetch der REMOTE-Wache ist fail-closed wie der Re-Fetch. Default true.
AF_SNAP_REMOTE_STRICT="${AF_SNAP_REMOTE_STRICT:-true}"
AF_SNAP_REMOTE="${AF_SNAP_REMOTE:-origin}"
AF_SNAP_REMOTE_BRANCH="${AF_SNAP_REMOTE_BRANCH:-$AF_PROV_SUPER_REF}"
AF_RECOVER_MAX="${AF_RECOVER_MAX:-1}"
AF_RECOVER_TIEFE="${AF_RECOVER_TIEFE:-20}"
# Beide steuern Schleifen bzw. `git log -n` -- ein nicht-numerischer Wert waere ein spaeterer,
# schwer lesbarer Fehler mitten im Lauf. Lieber sofort und literal.
case "$AF_RECOVER_MAX" in *[!0-9]* | "")
  echo "FEHLER: AF_RECOVER_MAX='$AF_RECOVER_MAX' ist keine Zahl" >&2; exit 1 ;;
esac
case "$AF_RECOVER_TIEFE" in *[!0-9]* | "")
  echo "FEHLER: AF_RECOVER_TIEFE='$AF_RECOVER_TIEFE' ist keine Zahl" >&2; exit 1 ;;
esac
# Bau-Produkt-Buchfuehrung des PDF-Gates (von run_pdf_gate gesetzt; leer = es wurde NICHT gebaut).
AF_GATE_MAIN=""
AF_GATE_TOOL=""
AF_GATE_PDF=""
# Betriebsmodus: "vorwaerts" = es gibt ein Anhang-Byte-Delta (Commit+Push);
#                "nachholen" = 0 Delta, aber der Compile-Beleg zum 289-HEAD fehlt (kein Commit);
#                "recovery"  = 0 Delta, und der Beleg fehlt einem FRUEHEREN 289-Stand (Marker/Bot-
#                              Historie) -- fuer den wird der Klon eigens detached und neu gebaut.
AF_MODE="vorwaerts"
# REMOTE-Wache (Kollisions- + Nachhol-Entscheidung); von af_snap_remote_init einmalig gesetzt.
AF_SNAP_GIT_TOP=""
AF_SNAP_REL=""
AF_SNAP_REMOTE_REF=""
AF_SNAP_REMOTE_LISTE=""
AF_SNAP_REMOTE_INIT=0
# Lauf-Kennung + transaktionale Buchfuehrung
AF_SNAP_KENNUNG=""
AF_SNAP_TMP_EIGEN=""     # newline-getrennte Liste EIGENER, noch unveroeffentlichter .tmp-Ordner
AF_SNAP_MARKER=""        # Pfad des PENDING-Markers dieses Laufs (leer = noch keiner)
AF_RECOVER_QUELLE=""     # "marker" | "bot-historie" (nur im Modus recovery gesetzt)
AF_DEST_ZURUECK=""       # Ausgangs-HEAD/Branch des 289-Klons (Recovery MUSS ihn wiederherstellen)

# ---- DIE EINE WIDE-KONKATENATION: DREI AUFRUFER, EINE DATEI ---------------------------
# SELBSTCHECK (P4c, 2026-08-09):
#   DER DEFEKT, den das heilt: dieselbe Aggregation stand DREIMAL im Bestand --
#     hier, in .gitlab-ci.yml Job measure:smoke und in Job measure:golden-320.
#     Nur DIESE Kopie war gedeckt. Am Objekt nachgemessen, bevor die Datei
#     entstand: ein Mutant, der den beiden YAML-Kopien ihr 'awk 1' nimmt, liess
#     SECHS von sechs lauffaehigen Wachen gruen (die siebte war mit und ohne
#     Mutation gleich rot und taugt nicht als Unterscheider).
#   ZUGESICHERT: es gibt die Konkatenation und die Zaehlung ab jetzt genau
#     einmal, in ci/wide_aggregat.sh. Wer sie dort mutiert, macht diese Probe
#     rot -- und deckt damit alle drei Aufrufer.
#   NICHT zugesichert: dass niemand eine VIERTE Kopie einfuegt. Dagegen steht
#     Fall A11 der Probe (kein Inline-Zwilling mehr in der .gitlab-ci.yml).
AF_SELBST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
AF_WIDE_AGGREGAT="${AF_WIDE_AGGREGAT:-$AF_SELBST_DIR/wide_aggregat.sh}"

# ---- DER SELEKTOR: EINE Definition, DREI Verwendungen ---------------------------------
# SELBSTCHECK (P4, 2026-08-09):
#   ZUGESICHERT: alle drei Fundstellen der Korpus-Kaskade -- Laufordner-Suche,
#     Zaehlung, Konkatenation -- benutzen GENAU DIESE Namensliste. Sie koennen
#     nicht mehr auseinanderlaufen, weil es nur noch eine Stelle gibt, an der ein
#     Name steht. Vor diesem Paket standen drei Kopien des Musters nebeneinander
#     (:149, :153, :165).
#   ZUGESICHERT: BEIDE Namensformen werden akzeptiert.
#     * 'result.csv' OHNE Praefix ist der LEBENDE Messweg. Beleg: ce
#       libs/cache_engine/profile_facade/planner/planner_status_types.hpp:33
#       'inline constexpr char kResultCsvName[] = "result.csv"' und
#       libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:1142
#       'std::filesystem::path const csv_p = dir / "result.csv"'.
#     * '<stem>.result.csv' ist die ARCHIVFORM. Sie existiert real: 8 Dateien
#       unter docs/architektur/measurement/erstbeleg-d03-20260726/.../per_binary/.
#   ENTSCHIEDEN -- und damit ist die Doppelung die Endform: OV-17 (Owner,
#     Wellenplan :1051, vor Frist 12.08.): '<stem>.result.csv' ist ein
#     ARCHIV-Artefakt des handgefahrenen D-03-Erstbelegs; das Suchmuster
#     nimmt BEIDE Formen dauerhaft. Am Default unten aendert sich nichts.
#     (Kommentar-Nachzug 24.08.2026, Z21-docs-Sammel/par.25.2; d10-Order.)
#   DER DEFEKT, den das heilt: '-name "*.result.csv"' verlangt mindestens ein
#     Zeichen plus Punkt vor 'result.csv' und traf die reale Datei damit NIE --
#     still, mit rc=0 und der Zeile "kein Korpus-Laufordner".
AF_RESULT_NAMEN="${AF_RESULT_NAMEN:-result.csv *.result.csv}"

af_finde_result_csv() {   # $1 = Wurzel ; alle weiteren Argumente = zusaetzliche find-Praedikate
  local wurzel="$1"; shift
  local ausdruck="" n rc=0
  # set -f (Glob-Sperre) ist hier PFLICHT, nicht Stil: die Namensliste enthaelt
  # '*'. Ohne die Sperre loeste die Shell sie gegen das ARBEITSVERZEICHNIS auf,
  # bevor find sie ueberhaupt zu sehen bekaeme -- und je nach cwd kaeme ein
  # anderer Selektor heraus. Danach wird sie sofort wieder aufgehoben.
  set -f
  for n in $AF_RESULT_NAMEN; do
    if [ -z "$ausdruck" ]; then ausdruck="-name $n"; else ausdruck="$ausdruck -o -name $n"; fi
  done
  # shellcheck disable=SC2086 -- $ausdruck MUSS wortgetrennt werden, das ist die find-Syntax.
  find "$wurzel" -type f \( $ausdruck \) "$@" || rc=$?
  set +f
  return "$rc"
}

echo "== anhang:forward KERN (E-18 Vorwaerts-Kanal) =="

# ---- (0) Vorbedingungen: fail-loud statt stilles Gruen -------------------------------
if [ -z "$AF_DEST_REPO" ]; then
  echo "FEHLER: AF_DEST_REPO fehlt (Arbeitsklon des Thesis-Repos 289)" >&2; exit 1
fi
if [ ! -d "$AF_DEST_REPO/.git" ]; then
  echo "FEHLER: AF_DEST_REPO='$AF_DEST_REPO' ist kein git-Arbeitsbaum" >&2; exit 1
fi
AF_TMP="${AF_TMP:-$(mktemp -d)}"
mkdir -p "$AF_TMP"
# EINE Quelle fuer den Gate-Log-Pfad: run_pdf_gate schreibt ihn, E-18-SNAP erntet ihn als
# "compile-export". Zwei Literale wuerden hier stumm auseinanderlaufen.
AF_GATE_LOG="$AF_TMP/pdf_gate.log"

# SPRACH-KONTRAKT (Codex MITTEL-3-Rest): AF_LANGS speist (a) Pfade und (b) die Rollback-
# Buchfuehrung, deren Feldtrenner '|' ist. Ein '|' in einer Sprachmarke wuerde das Protokoll
# zerschneiden und der Rollback liefe auf den falschen Pfad; Duplikate wuerden denselben Pfad
# zweimal buchen und die Restore-Reihenfolge verderben. Beides wird hier ABGEWIESEN bzw. entfernt,
# statt es spaeter zu "reparieren". Das Array ersetzt zugleich jedes `for lang in $LANGS`
# (Wort-Splitting UND Pfad-Globbing waeren dort wirksam).
AF_LANG_LIST=()
_langs_roh="$(printf '%s' "$AF_LANGS" | tr ',' '\n')"
while IFS= read -r _l; do
  [ -n "$_l" ] || continue
  case "$_l" in
    *[!A-Za-z0-9_-]*)
      echo "FEHLER: AF_LANGS-Eintrag '$_l' enthaelt unerlaubte Zeichen (erlaubt: A-Z a-z 0-9 _ -)." >&2
      echo "       Insbesondere '|' ist verboten: es ist der Feldtrenner der Rollback-Buchfuehrung." >&2
      exit 1 ;;
  esac
  _dup=0
  for _v in ${AF_LANG_LIST[@]+"${AF_LANG_LIST[@]}"}; do
    if [ "$_v" = "$_l" ]; then _dup=1; break; fi
  done
  if [ "$_dup" = "1" ]; then echo "   HINWEIS: AF_LANGS-Duplikat '$_l' entfernt (Rollback-Reihenfolge)"; continue; fi
  AF_LANG_LIST+=("$_l")
done <<EOF
$_langs_roh
EOF
if [ "${#AF_LANG_LIST[@]}" -eq 0 ]; then
  echo "FEHLER: AF_LANGS='$AF_LANGS' ergibt 0 gueltige Sprachen -> nichts zu tun waere stilles Gruen" >&2; exit 1
fi
LANGS="${AF_LANG_LIST[*]}"
echo "   ziel_repo=$AF_DEST_REPO  branch=$AF_BRANCH  sprachen=[$LANGS]"
echo "   work_root=$AF_WORK_ROOT  dry_run=$AF_DRY_RUN  no_push=$AF_NO_PUSH"

# ---- (0b) Lauf-Kennung + trap-Cleanup der EIGENEN .tmp-Reste (NB2-1 / NB2-5) ---------
# Die Kennung macht den Ordnernamen runneruebergreifend eindeutig, OHNE verteilte Reservierung.
# CI_RUNNER_ID+CI_JOB_ID sind von GitLab vergeben und global disjunkt; lokal treten hostname+PID an
# ihre Stelle (auf einer Maschine disjunkt, und mehr braucht ein lokaler Lauf nicht).
af_kennung_saeubern() { printf '%s' "$1" | tr -c 'A-Za-z0-9' '_' | cut -c1-24; }
af_lauf_kennung() {
  local r j h
  r="${CI_RUNNER_ID:-}"; j="${CI_JOB_ID:-}"
  if [ -n "$r" ] && [ -n "$j" ]; then
    printf 'r%s-j%s' "$(af_kennung_saeubern "$r")" "$(af_kennung_saeubern "$j")"; return 0
  fi
  h="$(hostname 2>/dev/null || echo unbekannt)"
  printf 'h%s-p%s' "$(af_kennung_saeubern "$h")" "$$"
}
AF_SNAP_KENNUNG="${AF_SNAP_LAUF_KENNUNG:-$(af_lauf_kennung)}"
case "$AF_SNAP_KENNUNG" in
  *[!A-Za-z0-9_-]* | "" )
    echo "FEHLER: Lauf-Kennung '$AF_SNAP_KENNUNG' ist kein schlichter Ordner-Namensteil" >&2; exit 1 ;;
esac
echo "   E-18-SNAP: Lauf-Kennung=$AF_SNAP_KENNUNG (runneruebergreifend eindeutiger Ordnername)"

# Raeumt AUSSCHLIESSLICH die .tmp-Ordner weg, die DIESER Lauf angelegt und nicht veroeffentlicht
# hat. Fremde Reste bleiben unangetastet (Messdaten-Doktrin: nie fremden Bestand anfassen).
af_snap_trap_cleanup() {
  local rest
  [ -n "$AF_SNAP_TMP_EIGEN" ] || return 0
  while IFS= read -r rest; do
    [ -n "$rest" ] || continue
    if [ -d "$rest" ]; then
      if rm -rf -- "$rest" 2>/dev/null; then
        echo "   E-18-SNAP: eigener unveroeffentlichter Rest aufgeraeumt -> $rest" >&2
      else
        echo "   E-18-SNAP: eigener Rest '$rest' liess sich NICHT aufraeumen (literal gemeldet)" >&2
      fi
    fi
  done <<EOF
$AF_SNAP_TMP_EIGEN
EOF
  AF_SNAP_TMP_EIGEN=""
}
trap af_snap_trap_cleanup EXIT INT TERM

# ---- (1) Quellen-Kaskade -------------------------------------------------------------
echo "-- (1) Quellen-Kaskade --"
SRC_ROOT=""
SRC_KIND=""
SRC_NOTE=""

# (1a) frische Pipeline-Artefakte, in DEKLARIERTER Reihenfolge
for root in $AF_ARTIFACT_ROOTS; do
  cand="$AF_WORK_ROOT/$root"
  [ -d "$cand" ] || { echo "   [1a] $root: nicht vorhanden"; continue; }
  n=0
  for lang in "${AF_LANG_LIST[@]}"; do
    [ -d "$cand/$lang/tabellen" ] || continue
    c=$(find "$cand/$lang/tabellen" -maxdepth 1 -type f -name '*.tex' | awk 'END{print NR+0}')
    n=$((n + c))
  done
  echo "   [1a] $root: $n .tex"
  if [ "$n" -gt 0 ] && [ -z "$SRC_ROOT" ]; then
    SRC_ROOT="$cand"; SRC_KIND="artefakt"; SRC_NOTE="$root"
  fi
done

# (1b) sonst Korpus-Regeneration (replace-Semantik: NEUESTER Laufordner gewinnt)
# SELBSTCHECK Nenner (P4, 2026-08-09):
#   ZUGESICHERT: dieser Zweig druckt IMMER zwei Zahlen mit Nenner --
#     'korpus_wurzel=<pfad> vorhanden=ja|nein' und
#     'laufordner_geprueft=<N> mit_material=<M>'.
#     EINE NULL OHNE NENNER IST VON EINEM ECHTEN FREISPRUCH NICHT ZU
#     UNTERSCHEIDEN. Vorher stand hier nur "kein Korpus-Laufordner mit
#     *.result.csv" -- dieselbe Zeile bei "Korpus leer", "Korpus existiert
#     nicht" und "Selektor trifft nicht". Genau diese Ununterscheidbarkeit hat
#     die Glob-Falle so lange getragen.
#   PREIS, ausdruecklich benannt: fuer den Nenner werden ALLE Laufordner
#     angesehen und nicht mehr beim ersten Treffer abgebrochen. Ordner MIT
#     Material kosten nichts ('-print -quit' haelt beim ersten Fund), Ordner
#     OHNE Material kosten je einen vollen Baumlauf. Das ist der Preis dafuer,
#     dass die Null einen Nenner hat.
#   NICHT geaendert: die replace-Semantik. Der NEUESTE Laufordner (sort -r) mit
#     Material gewinnt weiterhin, jetzt ueber die erste Zuweisung statt ueber
#     ein break.
if [ -z "$SRC_ROOT" ]; then
  CORPUS="$AF_WORK_ROOT/$AF_CORPUS_ROOT"
  RUN_DIR=""
  n_laufordner=0
  n_mit_material=0
  korpus_da=nein
  if [ -d "$CORPUS" ]; then
    korpus_da=ja
    while IFS= read -r d; do
      [ -n "$d" ] || continue
      n_laufordner=$((n_laufordner + 1))
      if [ -n "$(af_finde_result_csv "$d" -print -quit)" ]; then
        n_mit_material=$((n_mit_material + 1))
        [ -z "$RUN_DIR" ] && RUN_DIR="$d"
      fi
    done < <(find "$CORPUS" -mindepth 1 -maxdepth 1 -type d | sort -r)
  fi
  echo "   [1b] korpus_wurzel=$CORPUS vorhanden=$korpus_da"
  echo "   [1b] laufordner_geprueft=$n_laufordner mit_material=$n_mit_material (Selektor: $AF_RESULT_NAMEN)"
  if [ -n "$RUN_DIR" ]; then
    n_csv=$(af_finde_result_csv "$RUN_DIR" | awk 'END{print NR+0}')
    echo "   [1b] Korpus-Regeneration aus $(basename "$RUN_DIR") ($n_csv result.csv, replace-Semantik: neuester Lauf gewinnt)"
    if [ -z "$AF_GENERATOR" ] || [ ! -x "$AF_GENERATOR" ]; then
      echo "FEHLER: Korpus-Daten vorhanden ($n_csv result.csv), aber AF_GENERATOR fehlt/ist nicht ausfuehrbar ('$AF_GENERATOR')." >&2
      echo "       Das ist KEIN honest-empty-Fall, sondern eine kaputte Job-Konfiguration -> Abbruch (kein stilles Gruen)." >&2
      exit 1
    fi
    # WIDE-Aggregat = Header EINMAL + alle Datenzeilen. DIE LOGIK STEHT NICHT MEHR HIER,
    # sondern in ci/wide_aggregat.sh -- gemeinsam mit den beiden measure-Jobs der
    # .gitlab-ci.yml, die vorher jeder eine eigene Kopie trugen (Begruendung und die
    # drei geheilten Defekte F2/F3/F4 ausfuehrlich im Kopf jener Datei).
    # SELBSTCHECK Arbeitsteilung (P4c, 2026-08-09):
    #   ZUGESICHERT: HIER bleibt, was NUR den Anhang-Kanal angeht -- welche Dateien
    #     ueberhaupt gefunden werden (af_finde_result_csv/AF_RESULT_NAMEN), das 'sort',
    #     und das URTEIL ueber die Zahl (honest-empty). DORT liegt, was alle drei
    #     Aufrufer teilen: die Konkatenation und die Zaehlung.
    #   WARUM DAS 'sort' HIER BLEIBT: sonst haetten Kern und CI zwei verschiedene
    #     'sort'-Aufrufe, und die Frage "welche Datei stellt den Header" haette zwei
    #     Antworten. Der Aufrufer legt die Reihenfolge fest, der Aggregator folgt ihr.
    #   NICHT zugesichert: dass der Aggregator existiert. Deshalb der 'test -x'-Vorspann
    #     -- sein Verschwinden als DATEI ist fail-loud, nicht honest-empty.
    WIDE="$AF_TMP/wide_aggregate.csv"
    AF_RC_LISTE="$AF_TMP/wide_rc_liste.txt"
    AF_KENNZAHLEN="$AF_TMP/wide_kennzahlen.env"
    af_finde_result_csv "$RUN_DIR" | sort > "$AF_RC_LISTE"
    if [ ! -x "$AF_WIDE_AGGREGAT" ]; then
      echo "FEHLER: WIDE-Aggregator '$AF_WIDE_AGGREGAT' fehlt oder ist nicht ausfuehrbar." >&2
      echo "       Ohne ihn gaebe es kein Aggregat -- und ein leeres Aggregat waere von" >&2
      echo "       einem echten honest-empty nicht zu unterscheiden. Abbruch." >&2
      exit 1
    fi
    # K11: kein 'rc=$?' hinter einer Pipe. Der Status wird direkt am Aufruf genommen.
    _agg_rc=0
    sh "$AF_WIDE_AGGREGAT" "$AF_RC_LISTE" "$WIDE" "$AF_KENNZAHLEN" || _agg_rc=$?
    if [ "$_agg_rc" -ne 0 ]; then
      echo "FEHLER: WIDE-Aggregation fehlgeschlagen (rc=$_agg_rc) -> Abbruch, kein stilles Gruen." >&2
      exit 1
    fi
    # shellcheck source=/dev/null -- Kennzahlen-Datei, vom Aggregator eben geschrieben.
    . "$AF_KENNZAHLEN"
    _hdr_txt="$WIDE_HEADER"
    # Der Nachsatz steht in einer Variablen, damit die Zeile unter 120 Spalten
    # bleibt (Diff-Hygiene-Wache). Die AUSGABE ist Zeichen fuer Zeichen dieselbe
    # wie vorher -- die Probe prueft sie literal (A1/A3/A6/A8/A9/A10).
    _zaehlweise="Zaehlweise awk NR"
    echo "   [1b] WIDE-Aggregat: $WIDE_ZEILEN Zeilen (header=$_hdr_txt, davon Datenzeilen=$WIDE_DATEN), $_zaehlweise"
    # P29 (10.08.2026) DER NENNER GEHOERT IN DIE AUSGABE (V-1). Die Zeile oben nennt nur
    # das ERGEBNIS; ohne die Grundgesamtheit ist "0 Datenzeilen" nicht von "0 Quellen
    # gelistet" zu unterscheiden. Sie steht ZUSAETZLICH, nicht anstelle: die Probe
    # (A1/A3/A6/A8/A9/A10) fordert die obere Zeile literal.
    _nenner="$WIDE_QUELLEN Quelle(n) gelistet -- $WIDE_MIT_DATEN mit Daten,"
    echo "   [1b] WIDE-Nenner: $_nenner $WIDE_OHNE_DATEN ohne Daten, $WIDE_FEHLEND nicht lesbar"
    if [ "$WIDE_DATEN" -le 0 ]; then
      echo "   [1b] WIDE-Aggregat hat keine Datenzeile -> honest-empty"
    else
      GEN_OUT="$AF_TMP/appendix"
      mkdir -p "$GEN_OUT"
      # honest-empty-tolerant: Teil-Output (n/a-Spalten) ist KEIN Fehler (Spiegel der measure-Jobs).
      "$AF_GENERATOR" "$WIDE" "$GEN_OUT" "--langs=$AF_LANGS" \
        || echo "   [1b] appendix-generator: honest-empty/Teil-Output (n/a-Spalten) -- kein Fehler"
      n=0
      for lang in "${AF_LANG_LIST[@]}"; do
        [ -d "$GEN_OUT/$lang/tabellen" ] || continue
        c=$(find "$GEN_OUT/$lang/tabellen" -maxdepth 1 -type f -name '*.tex' | awk 'END{print NR+0}')
        n=$((n + c))
      done
      echo "   [1b] regeneriert: $n .tex"
      if [ "$n" -gt 0 ]; then
        SRC_ROOT="$GEN_OUT"; SRC_KIND="korpus"; SRC_NOTE="$(basename "$RUN_DIR")"
      fi
    fi
  else
    echo "   [1b] kein Laufordner mit Mess-CSV (Selektor: $AF_RESULT_NAMEN) unter $AF_CORPUS_ROOT/"
    echo "   [1b] das ist eine Null MIT Nenner: $n_laufordner Laufordner angesehen, $n_mit_material mit Material"
  fi
fi

# (1c) honest-empty
if [ -z "$SRC_ROOT" ]; then
  echo "=== anhang:forward NO-OP: keine Anhang-Quelle (weder Artefakt noch Korpus) ==="
  echo "    Die Thesis bleibt gruen -- A_measurements.tex bindet die Tabellen per"
  echo "    \\InputIfFileExists ein (Weg A). Kein Commit, kein Fehler."
  exit 0
fi
echo "   QUELLE: kind=$SRC_KIND ref=$SRC_NOTE root=$SRC_ROOT"

# ---- (2) Whitelist-Kopie: NUR anhang/<lang>/tabellen/<name>.tex ----------------------
echo "-- (2) Whitelist-Kopie nach anhang/<lang>/tabellen/ (nie loeschen, nie ausserhalb) --"
copied=0
# Buchfuehrung ueber GENAU die Pfade, die dieser Lauf angefasst hat. Ein etwaiger Rollback
# (PDF-Gate rot) darf ausschliesslich diese wieder wegnehmen -- kein `git clean` ueber ein
# ganzes Verzeichnis, damit fremde unversionierte Dateien im Ziel niemals mitgerissen werden.
#
# JE ZEILE: "<zustand_vorher>|<sicherung>|<relativer pfad>" -- der Zustand VOR dem cp entscheidet
# den Rollback (Codex MITTEL-3). Ohne ihn loeschte der Rollback auch Dateien, die es vorher schon
# gab, wenn sie nur unversioniert waren -- also FREMDE Dateien, die dieser Lauf lediglich
# ueberschrieben hat:
#   neu       -- existierte vorher NICHT  -> Rollback loescht sie (sie ist selbst erzeugt)
#   getrackt  -- existierte, ist getrackt -> `git checkout` holt sie zurueck, NIE loeschen
#   fremd     -- existierte, unversioniert-> vor dem cp nach $PREEXIST_DIR gesichert, Rollback
#                stellt den Original-Inhalt WIEDER HER (und loescht sie ebenfalls nie)
COPIED_LIST="$AF_TMP/kopierte_pfade.txt"; : > "$COPIED_LIST"
PREEXIST_DIR="$AF_TMP/vorbestand"; mkdir -p "$PREEXIST_DIR"
preexist_n=0

# ZENTRALER Rollback (Codex MITTEL-3-Rest: "frueher exit 1 ohne zentralen Rollback"). Jeder
# Abbruch NACH der ersten Kopie laeuft hier durch -- nicht nur der PDF-Gate-Pfad.
anhang_rollback() {
  local anlass="$1" zustand sicherung rel zurueck=0 erhalten=0 wieder=0
  [ -s "$COPIED_LIST" ] || { echo "   Rollback ($anlass): nichts kopiert -> nichts zurueckzunehmen" >&2; return 0; }
  git -C "$AF_DEST_REPO" reset -q HEAD -- anhang || true
  git -C "$AF_DEST_REPO" checkout -q -- anhang || true
  # Entscheidend ist der Zustand VOR dem cp (Codex MITTEL-3), nicht der jetzige: eine fremde
  # unversionierte Datei, die dieser Lauf nur UEBERSCHRIEBEN hat, ist heute genauso
  # "unversioniert" wie eine selbst angelegte -- die alte Pruefung haette sie geloescht.
  #   neu      -> loeschen (selbst erzeugt)
  #   getrackt -> nichts tun (das `git checkout` oben hat sie schon zurueckgeholt)
  #   fremd    -> Original-Inhalt aus der Sicherung WIEDERHERSTELLEN, niemals loeschen
  while IFS='|' read -r zustand sicherung rel; do
    [ -n "$rel" ] || continue
    case "$zustand" in
      neu)
        if git -C "$AF_DEST_REPO" ls-files --error-unmatch -- "$rel" >/dev/null 2>&1; then
          erhalten=$((erhalten + 1))   # wider Erwarten getrackt -> checkout hat entschieden
        else
          rm -f -- "$AF_DEST_REPO/$rel"; zurueck=$((zurueck + 1))
        fi
        ;;
      fremd)
        if cp -- "$PREEXIST_DIR/$sicherung" "$AF_DEST_REPO/$rel"; then
          wieder=$((wieder + 1))
        else
          echo "FEHLER: Rollback konnte den Vorbestand '$rel' nicht wiederherstellen" >&2
        fi
        ;;
      *)
        erhalten=$((erhalten + 1))
        ;;
    esac
  done < "$COPIED_LIST"
  echo "   Rollback ($anlass): $zurueck selbst angelegte Datei(en) entfernt, $wieder fremde Datei(en) im" >&2
  echo "   Original-Inhalt wiederhergestellt, $erhalten getrackte per checkout zurueckgeholt" >&2
  return 0
}

for lang in "${AF_LANG_LIST[@]}"; do
  src="$SRC_ROOT/$lang/tabellen"
  if [ ! -d "$src" ]; then echo "   [$lang] Quelle fehlt -> 0 kopiert"; continue; fi
  dst="$AF_DEST_REPO/anhang/$lang/tabellen"
  mkdir -p "$dst"
  n=0
  while IFS= read -r f; do
    base="$(basename "$f")"
    # Namens-Wache: nur schlichte .tex-Dateinamen (kein Pfad, kein '..', kein Sonderzeichen).
    case "$base" in
      *[!A-Za-z0-9._-]* | .* | *..* ) echo "   [$lang] UEBERSPRUNGEN (Namens-Wache): $base"; continue ;;
    esac
    rel="anhang/$lang/tabellen/$base"
    # Zustand VOR dem cp feststellen -- danach ist er nicht mehr rekonstruierbar.
    # TOCTOU-MINIMIERUNG (Codex MITTEL-3-Rest): der "neu"-Fall wird nicht nur GEPRUEFT, sondern
    # mit `set -o noclobber` ATOMAR BELEGT (O_EXCL). Erscheint die Datei zwischen Pruefung und
    # Anlage doch noch, schlaegt das Belegen fehl und der Zustand wird NEU bestimmt -- damit kann
    # der Rollback keine fremde Datei mehr als "selbst erzeugt" einstufen.
    sicherung=""
    zustand=""
    if [ ! -e "$dst/$base" ]; then
      if ( set -o noclobber; : > "$dst/$base" ) 2>/dev/null; then
        zustand="neu"
      else
        echo "   [$lang] HINWEIS: '$rel' ist zwischen Pruefung und Anlage entstanden -> Zustand neu bestimmt"
      fi
    fi
    if [ -z "$zustand" ]; then
      if git -C "$AF_DEST_REPO" ls-files --error-unmatch -- "$rel" >/dev/null 2>&1; then
        zustand="getrackt"
      else
        zustand="fremd"
        preexist_n=$((preexist_n + 1))
        sicherung="$preexist_n.bin"
        if ! cp -- "$dst/$base" "$PREEXIST_DIR/$sicherung"; then
          echo "FEHLER: Vorbestand '$rel' liess sich nicht sichern -> kein Ueberschreiben" >&2
          anhang_rollback "Vorbestand-Sicherung fehlgeschlagen"
          exit 1
        fi
        echo "   [$lang] Vorbestand gesichert (unversioniert, fremd): $rel -> $sicherung"
      fi
    fi
    if ! cp -- "$f" "$dst/$base"; then
      echo "FEHLER: cp '$f' -> '$dst/$base' fehlgeschlagen" >&2
      printf '%s|%s|%s\n' "$zustand" "$sicherung" "$rel" >> "$COPIED_LIST"
      anhang_rollback "cp fehlgeschlagen"
      exit 1
    fi
    printf '%s|%s|%s\n' "$zustand" "$sicherung" "$rel" >> "$COPIED_LIST"
    n=$((n + 1))
  done < <(find "$src" -maxdepth 1 -type f -name '*.tex' | sort)
  echo "   [$lang] kopiert: $n .tex -> anhang/$lang/tabellen/"
  copied=$((copied + n))
done
echo "   kopiert gesamt: $copied .tex"
if [ "$copied" -eq 0 ]; then
  # KEIN Abbruch mehr (Codex HOCH-1-Rest): 0 uebernommene .tex sind ein 0-Byte-Delta wie jedes
  # andere. Frueher stieg der Kanal hier aus -- VOR der Nachhol-/Recovery-Wache -- und ein
  # fehlender Compile-Beleg blieb dauerhaft unbemerkt. Die Entscheidung faellt jetzt einheitlich
  # in (3): gibt es fuer den relevanten 289-Stand einen gueltigen Beleg?
  echo "   HINWEIS: 0 uebernommene .tex -> 0 Byte-Delta. Die Beleg-Wache in (3) entscheidet weiter"
  echo "   (kein Frueh-Ausstieg vor der Nachhol-/Recovery-Pruefung)."
fi

# ---- (2b) E-18-SNAP-Wachen: REMOTE-Stand, Beleg-Validator, Recovery-Identitaet --------
# Alle Wachen brauchen DENSELBEN Remote-Blick, darum EINE Initialisierung, einmal ausgefuehrt.
# Sie laeuft VOR der Idempotenz-Entscheidung, weil genau diese Entscheidung ihre Antwort braucht.

# Vertrags-Pruefung fuer AF_SNAPSHOT_ROOT (Codex MITTEL-2-Randbefund): der Pfad muss vom
# 288-Writeback committet werden KOENNEN. Drei Arten, wie das still scheitert -- alle werden hier
# benannt statt spaeter zu gruenem Nichts zu fuehren.
af_snap_root_vertrag() {   # setzt AF_SNAP_GIT_TOP/AF_SNAP_REL; echoed Befund; rc 1 = Vertragsbruch
  local top_abs snap_abs work_top=""
  AF_SNAP_GIT_TOP="$(git -C "$AF_SNAPSHOT_ROOT" rev-parse --show-toplevel 2>/dev/null || true)"
  if [ -z "$AF_SNAP_GIT_TOP" ]; then
    echo "   E-18-SNAP-VERTRAG: '$AF_SNAPSHOT_ROOT' liegt in KEINEM git-Arbeitsbaum -- der"
    echo "   288-Writeback kann den Schnappschuss dort NIE committen."
    return 1
  fi
  top_abs="$(cd "$AF_SNAP_GIT_TOP" && pwd -P)" || return 1
  snap_abs="$(cd "$AF_SNAPSHOT_ROOT" && pwd -P)" || return 1
  if [ "$snap_abs" = "$top_abs" ]; then
    echo "   E-18-SNAP-VERTRAG: '$AF_SNAPSHOT_ROOT' IST das Toplevel des Arbeitsbaums. Der"
    echo "   Schnappschuss braucht einen eigenen Unterpfad (sonst stagt der Writeback das ganze Repo)."
    return 1
  fi
  case "$snap_abs" in
    "$top_abs"/*) AF_SNAP_REL="${snap_abs#"$top_abs"/}" ;;
    *)            AF_SNAP_REL=""; echo "   E-18-SNAP-VERTRAG: '$snap_abs' liegt nicht unter '$top_abs'"; return 1 ;;
  esac
  # Liegt der Pfad im SELBEN Arbeitsbaum wie die Mess-Wurzel (= das 288-Repo)? Ein fremdes Repo
  # waere gruen, aber der Writeback des Jobs sieht es nie.
  work_top="$(git -C "$AF_WORK_ROOT" rev-parse --show-toplevel 2>/dev/null || true)"
  if [ -n "$work_top" ]; then
    work_top="$(cd "$work_top" && pwd -P)"
    if [ "$work_top" != "$top_abs" ]; then
      echo "   E-18-SNAP-VERTRAG: '$snap_abs' liegt im Arbeitsbaum '$top_abs', die Mess-Wurzel"
      echo "   '$AF_WORK_ROOT' aber in '$work_top' -- das ist NICHT der 288-Baum des Writebacks."
      return 1
    fi
  else
    echo "   E-18-SNAP-VERTRAG: AF_WORK_ROOT='$AF_WORK_ROOT' ist kein git-Arbeitsbaum -> die"
    echo "   288-Identitaet der Schnappschuss-Wurzel konnte NICHT gegengeprueft werden (literal)."
  fi
  if git -C "$AF_SNAP_GIT_TOP" check-ignore -q -- "$AF_SNAP_REL" 2>/dev/null; then
    echo "   E-18-SNAP-VERTRAG: '$AF_SNAP_REL' wird von .gitignore IGNORIERT -- ein git add wuerde den"
    echo "   Beleg still wegwerfen (genau die Falle, die compile-export.txt statt compile.log erzwang)."
    return 1
  fi
  echo "   E-18-SNAP-VERTRAG: erfuellt (Arbeitsbaum '$top_abs', repo-relativ '$AF_SNAP_REL', nicht ignoriert)"
  return 0
}

# Remote-Pfadliste EINMAL ziehen und literal auswerten (Codex: git-grep-PATHSPEC-Glob).
# Es wird BEWUSST kein Pathspec uebergeben: Glob-Zeichen in AF_SNAP_REL koennten sonst als Muster
# wirken. Gefiltert wird per String-Praefix in der Shell -- literal, ohne jede Musterdeutung.
af_snap_remote_liste_bauen() {
  local out="$AF_TMP/remote_pfade.txt" err="$AF_TMP/remote_pfade.err" rc=0
  [ -n "$AF_SNAP_REMOTE_REF" ] || { AF_SNAP_REMOTE_LISTE=""; return 0; }
  # -z: NUL-getrennt und UNGEQUOTET. Das super-Repo traegt Pfade mit Leerzeichen; eine gequotete
  # oder falsch gesplittete Zeile wuerde die Praefix-Pruefung stumm daneben greifen lassen.
  git -C "$AF_SNAP_GIT_TOP" ls-tree -r -z --name-only "$AF_SNAP_REMOTE_REF" > "$out" 2>"$err" || rc=$?
  if [ "$rc" -ne 0 ]; then
    echo "FEHLER: REMOTE-Stand '$AF_SNAP_REMOTE_REF' nicht auflistbar (git ls-tree rc=$rc)." >&2
    sed 's/^/       /' "$err" >&2
    echo "       FAIL-CLOSED: ein Remote-Fehler gilt NICHT mehr als 'Pfad frei' (Codex)." >&2
    return 1
  fi
  AF_SNAP_REMOTE_LISTE="$out"
  echo "   E-18-SNAP-WACHE: REMOTE-Pfadliste geholt ($(tr -cd '\0' < "$out" | wc -c) Eintraege)"
  return 0
}

# Gibt alle Remote-Pfade aus, die literal unter "$1/" liegen (Praefix-Vergleich als STRING,
# kein Glob, kein Pathspec -- Glob-Zeichen in der Wurzel koennen darum nichts anrichten).
af_snap_remote_pfade_unter() {
  local praefix="$1" p rest
  [ -n "$AF_SNAP_REMOTE_LISTE" ] || return 0
  while IFS= read -r -d '' p; do
    rest="${p#"$praefix"/}"
    [ "$rest" != "$p" ] || continue
    printf '%s\n' "$p"
  done < "$AF_SNAP_REMOTE_LISTE"
  return 0
}

af_snap_remote_init_impl() {
  # Legt NUR das (leere) Wurzelverzeichnis an -- fuer git ist ein leerer Ordner unsichtbar, es
  # entsteht also nichts Commitbares. Es ist der Bezugspunkt fuer rev-parse --show-toplevel.
  mkdir -p "$AF_SNAPSHOT_ROOT" \
    || { echo "FEHLER: Schnappschuss-Wurzel '$AF_SNAPSHOT_ROOT' nicht anlegbar" >&2; return 1; }
  if ! af_snap_root_vertrag; then
    if [ "$AF_SNAP_ROOT_STRICT" != "false" ]; then
      echo "FEHLER: AF_SNAPSHOT_ROOT-Vertrag VERLETZT (s.o.) -> Abbruch statt gruenem Job ohne Beleg." >&2
      echo "       Wer das bewusst will (Fixture/Labor), setzt AF_SNAP_ROOT_STRICT=false." >&2
      return 1
    fi
    echo "   E-18-SNAP-VERTRAG: AF_SNAP_ROOT_STRICT=false -> Verstoss BEWUSST hingenommen;"
    echo "   REMOTE-Wache bleibt AUS, Suffix-Entscheidung nur lokal + mkdir-Lock."
    AF_SNAP_REMOTE_REF=""; AF_SNAP_REMOTE_LISTE=""
    return 0
  fi
  if [ -z "$AF_SNAP_REMOTE_BRANCH" ] || [ "$AF_SNAP_REMOTE_BRANCH" = "NA" ]; then
    echo "   E-18-SNAP-WACHE: REMOTE-Stand AUS (branch='$AF_SNAP_REMOTE_BRANCH')"
    echo "   -> Suffix-/Nachhol-Entscheidung nur lokal + mkdir-Lock (kein Haken ohne Ausgabe)"
    return 0
  fi
  if git -C "$AF_SNAP_GIT_TOP" fetch -q "$AF_SNAP_REMOTE" "$AF_SNAP_REMOTE_BRANCH" 2>/dev/null; then
    # FETCH_HEAD ist eine DATEI, die jede parallele git-Operation im selben Repo ueberschreibt
    # (Codex: "FETCH_HEAD als Referent austauschbar"). Sofort auf die unveraenderliche SHA aufloesen.
    AF_SNAP_REMOTE_REF="$(git -C "$AF_SNAP_GIT_TOP" rev-parse FETCH_HEAD 2>/dev/null || true)"
    if [ -z "$AF_SNAP_REMOTE_REF" ]; then
      echo "FEHLER: fetch war gruen, aber FETCH_HEAD nicht aufloesbar -> FAIL-CLOSED" >&2; return 1
    fi
    echo "   E-18-SNAP-WACHE: REMOTE-Stand geholt" \
         "($AF_SNAP_REMOTE/$AF_SNAP_REMOTE_BRANCH -> $AF_SNAP_REMOTE_REF), Pfad '$AF_SNAP_REL'"
    af_snap_remote_liste_bauen || return 1
  else
    # NB2-REST (a), GEHEILT AM 11.08.2026 -- DIE ASYMMETRIE WAR DAS LOCH:
    #   af_snap_remote_refresh (der RE-Fetch unmittelbar vor dem Schreiben) ist seit jeher
    #   FAIL-CLOSED ("lieber kein Beleg als ein Beleg auf einem blind gewaehlten Namen").
    #   Der ERST-Fetch hier war es NICHT -- er lief mit einer Warnung weiter. Und weil
    #   af_snap_remote_refresh bei leerem AF_SNAP_REMOTE_REF sofort mit rc 0 zurueckkehrt
    #   (die Zeile "Remote-Wache war schon aus -> bleibt aus"), war der fail-closed-Zweig
    #   AUSGERECHNET in dem Fall unerreichbar, fuer den er gebaut wurde: Erst-Fetch kaputt
    #   => refresh still gruen => Suffix- und Nachhol-Entscheidung fielen blind, ohne dass
    #   irgendeine Wache das noch sagen konnte. Ein blind gewaehlter Name endet im
    #   288-Merge als add/add-Konflikt (= verlorener Beleg), eine blinde Nachhol-Frage
    #   erzeugt einen ZWEITEN Beleg zu einem Stand, der laengst einen hat.
    # Die Vorgabe ist damit dieselbe wie beim Re-Fetch: ABBRUCH. Wer den Rueckfall
    # bewusst will (Fixture/Labor ohne Remote), setzt AF_SNAP_REMOTE_STRICT=false --
    # dann steht der Verstoss literal im Protokoll, statt still zu passieren.
    if [ "$AF_SNAP_REMOTE_STRICT" != "false" ]; then
      echo "FEHLER: Erst-Fetch '$AF_SNAP_REMOTE/$AF_SNAP_REMOTE_BRANCH' fehlgeschlagen -- der" >&2
      echo "       REMOTE-Stand ist unbekannt. FAIL-CLOSED, genau wie der Re-Fetch: eine" >&2
      echo "       Suffix-/Nachhol-Entscheidung auf blinder Grundlage ist kein Schutz." >&2
      echo "       Bewusster Rueckfall nur mit AF_SNAP_REMOTE_STRICT=false." >&2
      return 1
    fi
    echo "   E-18-SNAP-WACHE: fetch '$AF_SNAP_REMOTE/$AF_SNAP_REMOTE_BRANCH' fehlgeschlagen ->"
    echo "   AF_SNAP_REMOTE_STRICT=false -> REMOTE-Stand NICHT geprueft; Rueckfall auf lokale"
    echo "   Pruefung + mkdir-Lock (literal, kein stiller Teil-Schutz)"
  fi
  return 0
}

# INIT-Flag erst NACH Erfolg setzen (Codex: sonst ist ein Fehlschlag "sticky gruen" -- der zweite
# Aufruf kaeme sofort mit rc 0 zurueck, obwohl nie etwas initialisiert wurde).
af_snap_remote_init() {
  [ "$AF_SNAP_REMOTE_INIT" = "0" ] || return 0
  af_snap_remote_init_impl || return 1
  AF_SNAP_REMOTE_INIT=1
  return 0
}

# Frischer Remote-Blick unmittelbar VOR dem Schreiben (Codex: "kein Re-Fetch zwischen Belegtest und
# Schreiben"). Zwischen Beleg-Pruefung und Ablage liegt ein kompletter LaTeX-Bau -- Minuten, in
# denen ein fremder Lauf landen kann.
af_snap_remote_refresh() {
  [ -n "$AF_SNAP_GIT_TOP" ] || return 0
  [ -n "$AF_SNAP_REMOTE_BRANCH" ] && [ "$AF_SNAP_REMOTE_BRANCH" != "NA" ] || return 0
  [ -n "$AF_SNAP_REMOTE_REF" ] || return 0    # Remote-Wache war schon aus -> bleibt aus (literal gemeldet)
  if ! git -C "$AF_SNAP_GIT_TOP" fetch -q "$AF_SNAP_REMOTE" "$AF_SNAP_REMOTE_BRANCH" 2>/dev/null; then
    echo "FEHLER: Re-Fetch vor dem Ablegen fehlgeschlagen -- der Remote-Stand ist unbekannt." >&2
    echo "       FAIL-CLOSED: lieber kein Beleg als ein Beleg auf einem blind gewaehlten Namen." >&2
    return 1
  fi
  AF_SNAP_REMOTE_REF="$(git -C "$AF_SNAP_GIT_TOP" rev-parse FETCH_HEAD 2>/dev/null || true)"
  [ -n "$AF_SNAP_REMOTE_REF" ] || { echo "FEHLER: Re-Fetch gruen, FETCH_HEAD nicht aufloesbar" >&2; return 1; }
  af_snap_remote_liste_bauen || return 1
  return 0
}

# ---- (2c) GEMEINSAMER BELEG-VALIDATOR (Codex NB2-3) ----------------------------------
# EINE Wahrheit fuer "ist das ein Beleg?" -- benutzt von der Nachhol-Wache, der Kollisions-Wache
# und der Schluss-Pruefung des eigenen Schnappschusses. Ein halber Ordner faellt hier IMMER durch.
af_feld() {  # $1 = Datei, $2 = Schluessel -> Wert der ERSTEN passenden Zeile (ganze Zeile verankert)
  sed -n "s/^$2=//p" "$1" 2>/dev/null | head -1
}

af_sha256() {  # fail-loud: leerer/ungueltiger Hash ist ein FEHLER, nie ein Vergleichswert
  local h=""
  h="$(sha256sum < "$1" 2>/dev/null | cut -d' ' -f1)" || return 1
  case "$h" in
    [0-9a-f]*) [ "${#h}" -eq 64 ] || return 1 ;;
    *) return 1 ;;
  esac
  printf '%s' "$h"
  return 0
}

# Feld-Pruefung des QUELLSTAND-Inhalts. $1 = Datei mit dem Inhalt, $2 = erwartete 289-SHA.
# Gibt bei Erfolg "pdf_datei|pdf_sha256" aus.
af_quellstand_pruefen() {
  local q="$1" sha="$2" fehlend="" pdf_datei pdf_sha super_sha lauf_id comp
  # VOLLSTAENDIGE Zeile, literal (Codex: "Treffer als VOLLSTAENDIGE Zeile verankert" -- ein
  # Praefix-Treffer wuerde eine abgeschnittene oder laengere SHA als Beleg durchgehen lassen).
  grep -qxF "thesis_commit_sha=$sha" "$q" || fehlend="$fehlend thesis_commit_sha=$sha"
  pdf_datei="$(af_feld "$q" pdf_datei)"
  pdf_sha="$(af_feld "$q" pdf_sha256)"
  super_sha="$(af_feld "$q" super_commit_sha)"
  lauf_id="$(af_feld "$q" kanal_lauf_id)"
  comp="$(af_feld "$q" compile_export)"
  [ -n "$pdf_datei" ] || fehlend="$fehlend pdf_datei"
  case "$pdf_sha" in
    [0-9a-f]*) [ "${#pdf_sha}" -eq 64 ] || fehlend="$fehlend pdf_sha256(Format)" ;;
    *) fehlend="$fehlend pdf_sha256" ;;
  esac
  # 288-SHA und Lauf-ID sind Pflichtfelder des OWNER-KERNs ("289-SHA + 288-SHA + Lauf-ID").
  # "NA" ist der EINZIGE zugelassene Platzhalter (lokaler Lauf ohne CI-Provenance) -- leer nicht.
  [ -n "$super_sha" ] || fehlend="$fehlend super_commit_sha"
  [ -n "$lauf_id" ]   || fehlend="$fehlend kanal_lauf_id"
  [ "$comp" = "compile-export.txt" ] || fehlend="$fehlend compile_export"
  if [ -n "$fehlend" ]; then
    printf 'FELDER_FEHLEN:%s' "$fehlend"; return 1
  fi
  printf '%s|%s' "$pdf_datei" "$pdf_sha"
  return 0
}

# LOKALER Vollbeleg: Ordner + alle Pflichtstuecke + sha256-Konsistenz.
af_beleg_lokal_gueltig() {   # $1 = Ordner, $2 = erwartete 289-SHA
  local dir="$1" sha="$2" felder pdf_datei pdf_sha ist_sha
  [ -d "$dir" ] || { echo "      Beleg-Validator: '$dir' ist kein Ordner"; return 1; }
  [ -s "$dir/QUELLSTAND.txt" ] || { echo "      Beleg-Validator: '$dir/QUELLSTAND.txt' fehlt/leer"; return 1; }
  [ -s "$dir/compile-export.txt" ] || { echo "      Beleg-Validator: '$dir/compile-export.txt' fehlt/leer"; return 1; }
  if ! felder="$(af_quellstand_pruefen "$dir/QUELLSTAND.txt" "$sha")"; then
    echo "      Beleg-Validator: '$dir' -- $felder"; return 1
  fi
  pdf_datei="${felder%%|*}"; pdf_sha="${felder##*|}"
  [ -s "$dir/$pdf_datei" ] || { echo "      Beleg-Validator: '$dir/$pdf_datei' fehlt/leer"; return 1; }
  if ! ist_sha="$(af_sha256 "$dir/$pdf_datei")"; then
    echo "      Beleg-Validator: sha256 von '$dir/$pdf_datei' nicht berechenbar"; return 1
  fi
  if [ "$ist_sha" != "$pdf_sha" ]; then
    echo "      Beleg-Validator: sha256-Bruch in '$dir' ($ist_sha != $pdf_sha)"; return 1
  fi
  return 0
}

# REMOTE-Vollbeleg: dieselben Pflichtstuecke, aber gegen den Baum des Remote-Standes.
af_beleg_remote_gueltig() {  # $1 = Remote-Pfad der QUELLSTAND.txt, $2 = erwartete 289-SHA
  local qpfad="$1" sha="$2" dir="${1%/QUELLSTAND.txt}" tmp="$AF_TMP/remote_quellstand.txt"
  local felder pdf_datei pdf_sha ist_sha rc=0
  git -C "$AF_SNAP_GIT_TOP" show "$AF_SNAP_REMOTE_REF:$qpfad" > "$tmp" 2>/dev/null || rc=$?
  if [ "$rc" -ne 0 ]; then echo "      Beleg-Validator(remote): '$qpfad' nicht lesbar (rc=$rc)"; return 1; fi
  if ! felder="$(af_quellstand_pruefen "$tmp" "$sha")"; then
    echo "      Beleg-Validator(remote): '$qpfad' -- $felder"; return 1
  fi
  pdf_datei="${felder%%|*}"; pdf_sha="${felder##*|}"
  if ! git -C "$AF_SNAP_GIT_TOP" cat-file -e "$AF_SNAP_REMOTE_REF:$dir/compile-export.txt" 2>/dev/null; then
    echo "      Beleg-Validator(remote): '$dir/compile-export.txt' fehlt im Remote-Stand"; return 1
  fi
  ist_sha="$(git -C "$AF_SNAP_GIT_TOP" cat-file blob "$AF_SNAP_REMOTE_REF:$dir/$pdf_datei" \
               2>/dev/null | sha256sum | cut -d' ' -f1)"
  if [ "$ist_sha" != "$pdf_sha" ]; then
    echo "      Beleg-Validator(remote): sha256-Bruch in '$dir' ($ist_sha != $pdf_sha)"; return 1
  fi
  return 0
}

# Existiert fuer diesen 289-Stand bereits ein GUELTIGER Compile-Beleg -- lokal ODER im Remote-Stand?
# DAS ist die vom Workspace UNABHAENGIGE Wahrheit (ein Marker im Workspace stirbt mit dem Job).
af_snapshot_beleg_vorhanden() {
  local sha="$1" d p
  if [ -d "$AF_SNAPSHOT_ROOT" ]; then
    while IFS= read -r d; do
      [ -n "$d" ] || continue
      if af_beleg_lokal_gueltig "$d" "$sha" >/dev/null 2>&1; then
        echo "   E-18-SNAP-WACHE: gueltiger Beleg LOKAL vorhanden -> $d"
        return 0
      fi
      # Halb-Ordner literal benennen statt schweigend zu ignorieren (er sieht sonst wie ein Beleg aus).
      if grep -qxF "thesis_commit_sha=$sha" "$d/QUELLSTAND.txt" 2>/dev/null; then
        echo "   E-18-SNAP-WACHE: '$d' nennt die SHA, ist aber KEIN gueltiger Beleg:"
        af_beleg_lokal_gueltig "$d" "$sha" || true
      fi
    done < <(find "$AF_SNAPSHOT_ROOT" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort)
  fi
  if [ -n "$AF_SNAP_REMOTE_REF" ] && [ -n "$AF_SNAP_REMOTE_LISTE" ]; then
    while IFS= read -r p; do
      [ -n "$p" ] || continue
      [ "${p##*/}" = "QUELLSTAND.txt" ] || continue
      if af_beleg_remote_gueltig "$p" "$sha" >/dev/null 2>&1; then
        echo "   E-18-SNAP-WACHE: gueltiger Beleg im REMOTE-Stand vorhanden -> $p"
        return 0
      fi
    done < <(af_snap_remote_pfade_unter "$AF_SNAP_REL")
  fi
  return 1
}

# Ist der Kandidat-Ordner im REMOTE-Stand des 288-Repos schon belegt? (RC 0 = belegt)
# Zwei Laeufe derselben Sekunde liegen auf VERSCHIEDENEN Runnern -- ein lokales `[ -e ]` sieht den
# fremden Ordner nie. Seit NB2 traegt der Name zwar Runner-/Job-Kennung und kann praktisch nicht
# mehr kollidieren; die Wache bleibt als GURT (und faengt manuell angelegte Namen).
af_snapshot_remote_belegt() {
  local rel_cand="$1" treffer
  [ -n "$AF_SNAP_REMOTE_LISTE" ] || return 1
  treffer="$(af_snap_remote_pfade_unter "$rel_cand" | head -1)"
  [ -n "$treffer" ]
}

# ---- (2d) RECOVERY-IDENTITAET (Codex NB2-2) ------------------------------------------
# PENDING-Marker: die SHA, die ein Lauf gepusht hat (oder pushen wollte), dauerhaft im 288-Baum.
af_marker_schreiben() {   # $1 = SHA, die gleich gepusht wird
  local sha="$1"
  [ "$AF_COMPILE_SNAPSHOT" = "true" ] || return 0
  case "$sha" in [0-9a-f]*) [ "${#sha}" -eq 40 ] || return 1 ;; *) return 1 ;; esac
  AF_SNAP_MARKER="$AF_SNAPSHOT_ROOT/PENDING-$AF_SNAP_KENNUNG.txt"
  {
    echo "# E-18-SNAP RECOVERY-IDENTITAET (PENDING)"
    echo "# Diese Datei nennt den 289-Stand, den DIESER Lauf gepusht hat. Stirbt der Lauf danach,"
    echo "# weiss ein spaeterer Lauf trotzdem, welchem Stand der Compile-Beleg fehlt -- unabhaengig"
    echo "# davon, wohin der 289-HEAD inzwischen gewandert ist (Codex NB2-2)."
    echo "pending_lauf_kennung=$AF_SNAP_KENNUNG"
    echo "pending_erzeugt_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "pending_thesis_branch=$AF_BRANCH"
    echo "pending_thesis_commit_sha=$sha"
    echo "pending_super_commit_sha=$AF_PROV_SUPER_SHA"
    echo "pending_kanal_lauf_id=$AF_PROV_PIPELINE_ID"
  } > "$AF_SNAP_MARKER" || { echo "FEHLER: PENDING-Marker '$AF_SNAP_MARKER' nicht schreibbar" >&2; return 1; }
  echo "   E-18-SNAP: Recovery-Identitaet abgelegt -> $AF_SNAP_MARKER (pending_thesis_commit_sha=$sha)"
  return 0
}

# Erfuellte Marker werden NICHT geloescht (Messdaten-/Beleg-Doktrin), sondern additiv ergaenzt.
af_marker_erfuellen() {   # $1 = snapshot_id
  [ -n "$AF_SNAP_MARKER" ] && [ -f "$AF_SNAP_MARKER" ] || return 0
  {
    echo "erfuellt_durch=$1"
    echo "erfuellt_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  } >> "$AF_SNAP_MARKER" || return 1
  echo "   E-18-SNAP: Marker als erfuellt vermerkt (erfuellt_durch=$1)"
  return 0
}

# Kandidaten-SHAs aus MARKERN (lokal + Remote-Stand), aelteste zuerst. Erfuellte Marker fallen raus.
af_recover_kandidaten_marker() {
  local f p tmp="$AF_TMP/marker_remote.txt" sha
  if [ -d "$AF_SNAPSHOT_ROOT" ]; then
    while IFS= read -r f; do
      [ -n "$f" ] || continue
      if grep -q '^erfuellt_durch=' "$f" 2>/dev/null; then continue; fi
      sha="$(af_feld "$f" pending_thesis_commit_sha)"
      if [ -n "$sha" ]; then printf '%s\n' "$sha"; fi
    done < <(find "$AF_SNAPSHOT_ROOT" -mindepth 1 -maxdepth 1 -type f -name 'PENDING-*.txt' 2>/dev/null | sort)
  fi
  if [ -n "$AF_SNAP_REMOTE_REF" ] && [ -n "$AF_SNAP_REMOTE_LISTE" ]; then
    while IFS= read -r p; do
      [ -n "$p" ] || continue
      case "${p##*/}" in PENDING-*.txt) ;; *) continue ;; esac
      git -C "$AF_SNAP_GIT_TOP" show "$AF_SNAP_REMOTE_REF:$p" > "$tmp" 2>/dev/null || continue
      if grep -q '^erfuellt_durch=' "$tmp"; then continue; fi
      sha="$(af_feld "$tmp" pending_thesis_commit_sha)"
      if [ -n "$sha" ]; then printf '%s\n' "$sha"; fi
    done < <(af_snap_remote_pfade_unter "$AF_SNAP_REL")
  fi
  return 0
}

# Kandidaten-SHAs aus der BOT-HISTORIE des Ziel-Branches, juengste zuerst. Diese Quelle ueberlebt
# jeden Runner-Tod, weil sie im 289-Repo selbst liegt.
af_recover_kandidaten_historie() {
  git -C "$AF_DEST_REPO" log "$1" --author='anhang-forward-bot' --format='%H' -n "$AF_RECOVER_TIEFE" 2>/dev/null || true
}

# ---- (3) Idempotenz: Commit NUR bei Byte-Delta ---------------------------------------
# FUENFTE TRANSPORT-FALLE, GEHEILT AM 10.08.2026 (Posten ##20) -- die letzte still:
#   (F5) DIE UEBERNAHME WURDE NIE NACHGEZAEHLT. Gestagt wurde das VERZEICHNIS
#        ('git add -- "anhang/$lang/tabellen" 2>/dev/null || true'); ob die eben
#        kopierten .tex dabei wirklich in den Index kamen, hat niemand gefragt.
#        Nahm git sie nicht (.gitignore im Ziel-Repo, index.lock, fehlendes
#        Schreibrecht), blieb 'changed' auf 0 -- und der Kanal sagte "IDEMPOTENT:
#        0 Aenderungen", rc=0. DASSELBE WORT fuer "nichts hat sich geaendert" und
#        "nichts ist angekommen". Am Objekt gemessen (10.08.2026, gewuerfelter
#        Koeder): Ziel-Repo mit 'anhang/**/tabellen/*.tex' in der .gitignore ->
#        "kopiert gesamt: 1 .tex" + "gestagte Aenderungen: 0" -> IDEMPOTENT, rc=0,
#        Commits 1->1, Koeder NICHT im Blob. GEGENPROBE ohne die Ignorier-Regel,
#        sonst identische Fixture: Commit, Koeder im committeten Blob. Der Messwert
#        war weg und der Job gruen -- fail-OPEN, die teuerste Richtung.
#
# WARUM NICHT EINFACH DAS '|| true' FAELLT (so verlangte es Posten ##20 woertlich:
#   "`|| true` beim git add faellt") -- am Objekt gemessen und WIDERLEGT: der CI-Job
#   setzt AF_LANGS="de,en", eine Quelle darf aber legitim nur 'de' tragen. Dann gibt
#   es 'anhang/en/tabellen' im Ziel gar nicht, 'git add' bricht mit "pathspec
#   'anhang/en/tabellen' did not match any files" ab und 'set -e' toetet den ganzen
#   Kanal -- gemessen: rc=128, kein Commit, obwohl die de-Haelfte fertig kopiert
#   dalag. Das '|| true' war also nicht der Defekt, sondern die Kruecke fuer ein
#   falsches Pathspec. Geheilt wird das PATHSPEC: gestagt wird genau das, was DIESER
#   Lauf geschrieben hat -- die Buchfuehrungs-Liste $COPIED_LIST, die es fuer den
#   Rollback ohnehin schon gibt. Damit kann 'git add' an einer nicht bedienten
#   Sprache nicht mehr scheitern, und ein Fehlschlag ist wieder ein echter.
#
# SELBSTCHECK (##20, 2026-08-10):
#   ZUGESICHERT: die Null bekommt ihren Nenner. Es wird IMMER gedruckt
#     'Uebernahme-Nenner: kopiert=N im_index=M nicht_uebernommen=K git_add_fehler=F'.
#     "0 Aenderungen" heisst ab jetzt belegbar "alle N liegen im Index und sind
#     byte-gleich zum Bestand" -- und nicht mehr auch "keine ist angekommen".
#   ZUGESICHERT: K>0 oder F>0 ist fail-loud (exit 1) und nennt die DATEINAMEN.
#   NICHT zugesichert: der Push-/Merge-Retry-Pfad danach. Er bleibt ungedeckt
#     (AF_NO_PUSH=true in allen Faellen), s. Testkritik in der Probe.
echo "-- (3) Idempotenz-Pruefung im Ziel-Repo --"
# SATZFORMAT DER BUCHFUEHRUNGS-LISTE (Merge-Naht 11.08.2026, INHALTLICH aufgeloest):
#   $COPIED_LIST fuehrt seit dem Vorbestands-Rollback DREI Felder je Zeile --
#   'zustand|sicherung|rel' (s. anhang_rollback oben). Die ##20-Uebernahmezaehlung
#   entstand auf einem Stand, an dem die Liste nur den nackten Pfad trug; wer sie
#   unveraendert uebernimmt, uebergibt 'fremd|1.bin|anhang/de/...' als Pathspec an
#   'git add' -- gemessen: "fatal: pathspec ... did not match any files", danach
#   nicht_uebernommen=2 von 2 und fail-loud. Das ist KEIN Textkonflikt gewesen,
#   sondern ein Formatkonflikt: beide Seiten lasen dieselbe Datei verschieden.
#   Gelesen wird darum an BEIDEN Stellen mit demselben Feldtrenner wie im Rollback.
af_add_fehler=0
while IFS='|' read -r _zustand _sicherung rel; do
  [ -n "$rel" ] || continue
  git -C "$AF_DEST_REPO" add -- "$rel" || af_add_fehler=$((af_add_fehler + 1))
done < "$COPIED_LIST"
# DAS ORAKEL IST DER INDEX, NICHT DER RUECKGABEWERT: gefragt wird nicht, ob
# 'git add' zufrieden aussah, sondern ob die Datei danach WIRKLICH drinsteht.
NICHT_UEBERNOMMEN="$AF_TMP/nicht_uebernommen.txt"; : > "$NICHT_UEBERNOMMEN"
nicht_uebernommen=0
while IFS='|' read -r _zustand _sicherung rel; do
  [ -n "$rel" ] || continue
  if ! git -C "$AF_DEST_REPO" ls-files --error-unmatch -- "$rel" >/dev/null 2>&1; then
    nicht_uebernommen=$((nicht_uebernommen + 1))
    printf '%s\n' "$rel" >> "$NICHT_UEBERNOMMEN"
  fi
done < "$COPIED_LIST"
im_index=$((copied - nicht_uebernommen))
_uebernahme="kopiert=$copied im_index=$im_index nicht_uebernommen=$nicht_uebernommen"
echo "   Uebernahme-Nenner: $_uebernahme git_add_fehler=$af_add_fehler"
changed=$(git -C "$AF_DEST_REPO" diff --cached --name-only | awk 'END{print NR+0}')
echo "   gestagte Aenderungen: $changed Datei(en)"
if [ "$changed" -gt 0 ]; then git -C "$AF_DEST_REPO" diff --cached --name-only | sed 's/^/     /'; fi
# EINE Entscheidung ueber BEIDE Zahlen: sie sind zwei Symptome desselben Sachverhalts
# -- die kopierte .tex hat den Index nicht erreicht. Zwei getrennte Abbrueche haetten
# bedeutet, dass der erste den zweiten nie zum Zug kommen laesst; der zweite bliebe
# dann ungedeckt, und ein Mutant auf ihn bliebe gruen.
if [ "$nicht_uebernommen" -gt 0 ] || [ "$af_add_fehler" -gt 0 ]; then
  echo "FEHLER: $nicht_uebernommen von $copied kopierten .tex sind NICHT im Index des" >&2
  echo "        Ziel-Repos ('git add' meldete $af_add_fehler Fehlschlag/Fehlschlaege)." >&2
  if [ -s "$NICHT_UEBERNOMMEN" ]; then sed 's/^/          /' "$NICHT_UEBERNOMMEN" >&2; fi
  echo "        Bekannte Ursachen: .gitignore im Ziel-Repo, index.lock eines" >&2
  echo "        Parallel-Laufs, fehlendes Schreibrecht auf dem Klon." >&2
  echo "        Das ist KEIN Idempotenz-Fall: der Messwert waere still verloren und" >&2
  echo "        der Job trotzdem gruen. Abbruch (fail-loud)." >&2
  exit 1
fi
DEST_HEAD="$(git -C "$AF_DEST_REPO" rev-parse HEAD)"
AF_DEST_ZURUECK="$(git -C "$AF_DEST_REPO" symbolic-ref -q --short HEAD 2>/dev/null || echo "$DEST_HEAD")"
AF_BELEG_SHA="$DEST_HEAD"
if git -C "$AF_DEST_REPO" diff --cached --quiet; then
  # KEIN Byte-Delta. Frueher endete der Kanal hier -- und ein Lauf, der 289 gepusht hat und danach
  # starb, verlor seinen Compile-Beleg damit fuer immer (Codex HOCH-1). Die Frage ist NICHT "gibt es
  # ein Delta?", sondern "gibt es fuer den SCHULDIGEN 289-Stand schon einen gueltigen Beleg?".
  echo "   IDEMPOTENT: 0 Byte-Delta im Anhang (289-HEAD=$DEST_HEAD)"
  # Der ##20-Beleg bleibt WOERTLICH stehen: "0 Aenderungen" ist erst dann eine Aussage,
  # wenn der Nenner darunter steht. Er gilt hier genauso -- E-18-SNAP haengt nur das
  # zweite Kriterium (Compile-Beleg) daneben, es ERSETZT das erste nicht.
  echo "    belegt: alle $copied kopierten .tex liegen im Index und sind byte-gleich."
  if [ "$AF_COMPILE_SNAPSHOT" != "true" ]; then
    echo "=== anhang:forward IDEMPOTENT: 0 Aenderungen, Schnappschuss abgeschaltet -> kein Commit ==="
    exit 0
  fi
  if ! af_snap_remote_init; then
    echo "FEHLER: E-18-SNAP-Wache liess sich nicht initialisieren -> Abbruch (kein stilles Gruen)" >&2
    exit 1
  fi
  # --- Recovery-Identitaet BESTIMMEN, bevor gebaut wird (sonst baut der Lauf den falschen Baum) ---
  AF_RECOVER_SHA=""
  if [ "$AF_RECOVER_MAX" -lt 1 ]; then
    echo "   -- Recovery ABGESCHALTET (AF_RECOVER_MAX=$AF_RECOVER_MAX) -> es zaehlt nur der 289-HEAD --"
  else
  echo "   -- Recovery-Identitaet (Marker im 288-Baum, dann Bot-Historie, dann 289-HEAD) --"
  REF_BRANCH=""
  if git -C "$AF_DEST_REPO" fetch -q origin "$AF_BRANCH" 2>/dev/null; then
    REF_BRANCH="$(git -C "$AF_DEST_REPO" rev-parse FETCH_HEAD 2>/dev/null || true)"
    echo "   289-Ziel-Branch geholt: $AF_BRANCH -> ${REF_BRANCH:-<nicht aufloesbar>}"
  else
    echo "   289-Ziel-Branch NICHT holbar (kein Remote/offline) -> Recovery nur aus lokalen Markern"
  fi
  KAND="$AF_TMP/recover_kandidaten.txt"; : > "$KAND"
  af_recover_kandidaten_marker >> "$KAND"
  if [ -n "$REF_BRANCH" ]; then af_recover_kandidaten_historie "$REF_BRANCH" >> "$KAND"; fi
  gesehen=""
  while IFS= read -r ksha; do
    [ -n "$ksha" ] || continue
    case "$ksha" in [0-9a-f]*) [ "${#ksha}" -eq 40 ] || continue ;; *) continue ;; esac
    case "$gesehen" in *"$ksha"*) continue ;; esac
    gesehen="$gesehen $ksha"
    [ "$ksha" != "$DEST_HEAD" ] || continue          # der HEAD ist der Rueckfall, nicht die Recovery
    if [ -n "$REF_BRANCH" ] && ! git -C "$AF_DEST_REPO" merge-base --is-ancestor "$ksha" "$REF_BRANCH" 2>/dev/null; then
      echo "   Recovery-Kandidat $ksha ist NICHT auf $AF_BRANCH erreichbar -> uebersprungen"
      echo "   (ein Beleg fuer einen nie gelandeten Commit waere eine Luege)"
      continue
    fi
    if af_snapshot_beleg_vorhanden "$ksha" >/dev/null 2>&1; then
      echo "   Recovery-Kandidat $ksha hat bereits einen gueltigen Beleg -> uebersprungen"
      continue
    fi
    AF_RECOVER_SHA="$ksha"
    echo "   RECOVERY-ZIEL: $ksha (Beleg fehlt, Commit ist auf $AF_BRANCH erreichbar)"
    break
  done < "$KAND"
  fi
  if [ -n "$AF_RECOVER_SHA" ]; then
    AF_MODE="recovery"
    AF_BELEG_SHA="$AF_RECOVER_SHA"
    AF_RECOVER_QUELLE="marker-oder-historie"
    echo "   E-18-SNAP RECOVERY: der 289-Klon wird auf $AF_RECOVER_SHA detached, damit der Beleg aus"
    echo "   GENAU DIESEM Baum entsteht (nicht aus dem inzwischen weitergewanderten HEAD)."
    if ! git -C "$AF_DEST_REPO" checkout -q --detach "$AF_RECOVER_SHA" 2>/dev/null; then
      echo "FEHLER: Recovery-Checkout auf $AF_RECOVER_SHA fehlgeschlagen -> Abbruch" >&2; exit 1
    fi
  else
    if af_snapshot_beleg_vorhanden "$DEST_HEAD"; then
      echo "=== anhang:forward IDEMPOTENT: 0 Aenderungen UND gueltiger Compile-Beleg zu $DEST_HEAD -> nichts zu tun ==="
      exit 0
    fi
    echo "   E-18-SNAP NACHHOLUNG: zu 289-HEAD $DEST_HEAD existiert KEIN gueltiger Compile-Beleg (weder"
    echo "   lokal noch im REMOTE-Stand). Typischer Hergang: ein Vorlauf hat 289 gepusht und ist vor dem"
    echo "   288-Writeback gestorben. Es wird JETZT nur der Beleg nachgeholt -- KEIN Commit, KEIN Push."
    AF_MODE="nachholen"
  fi
fi
if [ "$AF_DRY_RUN" = "true" ]; then
  if [ "$AF_MODE" != "vorwaerts" ]; then
    echo "=== anhang:forward DRY-RUN: $AF_MODE waere faellig (0 Delta, Beleg fehlt zu" \
         "$AF_BELEG_SHA), aber KEIN Compile, KEIN Schreiben ==="
    if [ "$AF_MODE" = "recovery" ]; then git -C "$AF_DEST_REPO" checkout -q --force "$AF_DEST_ZURUECK" || true; fi
  else
    echo "=== anhang:forward DRY-RUN: $changed Aenderung(en) gestaged, KEIN Commit, KEIN Push ==="
  fi
  exit 0
fi

# ---- (3b) PDF-GATE: baut die Thesis mit dem NEUEN Anhang noch? ------------------------
# ALLES-ODER-NICHTS: schlaegt der Bau fehl, wird der Arbeitsbaum zurueckgesetzt und der
# Kanal bricht LAUT ab -- lieber gar kein Vorwaerts-Schritt als eine kaputte Thesis-PDF.
echo "-- (3b) PDF-Gate (AF_PDF_GATE=$AF_PDF_GATE) --"
run_pdf_gate() {
  local erzwingen="${1:-nein}"
  local main tex_tool marke ext mains anz
  # EINE Quelle der Auswahl: erst die LISTE aller Top-Level-Hauptdokumente, daraus das erste.
  mains="$(cd "$AF_DEST_REPO" && grep -lE '^[^%]*\\documentclass' -- *.tex 2>/dev/null)"
  anz=0
  if [ -n "$mains" ]; then anz="$(printf '%s\n' "$mains" | wc -l)"; fi
  main="$(printf '%s\n' "$mains" | head -1)"
  # FALL E (Verify 2026-08-13, F1-Kette): bei MEHR als einem Hauptdokument kann DIESES Gate
  # nicht vollstaendig pruefen (es baut nur eines). on => ROT statt Teil-Pruefung als Gruen
  # (II.7); auto => es baut das erste und sagt LAUT, was ungeprueft bleibt. Wer das ausloest,
  # erweitert die Auswahl auf eine LISTE (s. Datei-Kopf, Geltungsbereich (a)).
  if [ "$anz" -gt 1 ]; then
    if [ "$AF_PDF_GATE" = "on" ]; then
      echo "FEHLER: AF_PDF_GATE=on, aber $anz Top-Level-Hauptdokumente ($(printf '%s' "$mains" | tr '\n' ' ')) --" >&2
      echo "       dieses Gate baut nur das ERSTE und liesse die uebrigen UNGEPRUEFT. Erst die" >&2
      echo "       Auswahl auf eine Liste erweitern, dann wieder on fahren (kein Teil-Gruen)." >&2
      return 1
    fi
    echo "   WARNUNG: $anz Hauptdokumente gefunden -- gebaut und geprueft wird NUR '$main',"
    echo "   die uebrigen bleiben UNGEPRUEFT (Geltungsbereich (a), Datei-Kopf)."
  fi
  if command -v latexmk >/dev/null 2>&1; then tex_tool=latexmk
  elif command -v pdflatex >/dev/null 2>&1; then tex_tool=pdflatex
  else tex_tool=""; fi
  if [ -z "$main" ] || [ -z "$tex_tool" ]; then
    if [ "$AF_PDF_GATE" = "on" ]; then
      echo "FEHLER: AF_PDF_GATE=on, aber Haupt-.tex='${main:-<keine>}' / TeX-Werkzeug='${tex_tool:-<keins>}'" >&2
      return 1
    fi
    echo "   UEBERSPRUNGEN: Haupt-.tex='${main:-<keine>}' TeX-Werkzeug='${tex_tool:-<keins>}'"
    echo "   (kein Haken ohne Ausgabe: hier wurde NICHT geprueft, ob die PDF noch baut)"
    return 0
  fi
  local log="$AF_GATE_LOG" rc=0 pdf="$AF_DEST_REPO/${main%.tex}.pdf"
  marke="$AF_TMP/gate_marke"
  # ERZWUNGENE RE-KOMPILATION (Codex NB2-4): ohne sie kann latexmk "Nothing to do" melden und die
  # ALTE PDF bliebe liegen -- die dann mit der NEUEN SHA beschriftet wuerde. Drei Riegel:
  #   (i) alte PDF + Zwischenprodukte weg, (ii) latexmk -gg (volle Neuerzeugung),
  #   (iii) Neuheits-Wache: die PDF MUSS juenger sein als die Marke von JETZT.
  if [ "$erzwingen" = "erzwingen" ]; then
    echo "   ERZWUNGENE Re-Kompilation: alte Bau-Produkte werden entfernt (kein 'Nothing to do')"
    rm -f -- "$pdf"
    for ext in aux fls fdb_latexmk out toc lof lot bbl blg; do
      rm -f -- "$AF_DEST_REPO/${main%.tex}.$ext"
    done
  fi
  : > "$marke"
  echo "   baue $main mit $tex_tool (erzwungen=$erzwingen) ..."
  if [ "$tex_tool" = "latexmk" ]; then
    if [ "$erzwingen" = "erzwingen" ]; then
      ( cd "$AF_DEST_REPO" && latexmk -gg -pdf -interaction=nonstopmode -halt-on-error "$main" ) > "$log" 2>&1 || rc=$?
    else
      ( cd "$AF_DEST_REPO" && latexmk -pdf -interaction=nonstopmode -halt-on-error "$main" ) > "$log" 2>&1 || rc=$?
    fi
  else
    ( cd "$AF_DEST_REPO" && pdflatex -interaction=nonstopmode -halt-on-error "$main" ) > "$log" 2>&1 || rc=$?
  fi
  if [ "$rc" -ne 0 ]; then
    echo "FEHLER: PDF-Gate ROT (rc=$rc) -- der neue Anhang bricht den Thesis-Bau." >&2
    echo "-------- LaTeX-Fehlerzeilen --------" >&2
    grep -nE '^!|^l\.[0-9]+|Fatal error' "$log" | head -12 >&2
    echo "------------------------------------" >&2
    return 1
  fi
  if [ "$erzwingen" = "erzwingen" ]; then
    if [ ! -f "$pdf" ]; then
      echo "FEHLER: erzwungener Bau meldete Erfolg, aber '$pdf' existiert nicht" >&2; return 1
    fi
    if [ ! "$pdf" -nt "$marke" ]; then
      echo "FEHLER: erzwungener Bau hat die PDF NICHT neu erzeugt ('$pdf' ist nicht juenger als der" >&2
      echo "       Bau-Beginn) -- genau der 'Nothing to do'-Fall, der eine ALTE PDF mit einer NEUEN" >&2
      echo "       SHA beschriften wuerde. KEIN Beleg." >&2
      return 1
    fi
    echo "   Neuheits-Wache: '$pdf' ist juenger als der Bau-Beginn -> echte Re-Kompilation"
  fi
  echo "   PDF-Gate GRUEN: $main gebaut"
  # Bau-Produkt fuer E-18-SNAP buchen. Die Auswahl des Hauptdokuments wird BEWUSST nicht ein
  # zweites Mal berechnet ("EINE Quelle statt zwei", s. Datei-Kopf) -- der Schnappschuss erntet
  # exakt das Dokument, das dieses Gate gerade gebaut hat.
  AF_GATE_MAIN="$main"
  AF_GATE_TOOL="$tex_tool"
  AF_GATE_PDF="$pdf"
  return 0
}
# Der PDF-Bau fasst getrackte Dateien AUSSERHALB von anhang/ an (z.B. die eingecheckte
# diplomarbeit.pdf). Die duerfen den Kanal-Commit nicht verunreinigen -> nach dem Gate
# zuruecksetzen. Der Commit selbst stagt ohnehin NUR anhang/<lang>/tabellen.
pdf_gate_aufraeumen() {
  git -C "$AF_DEST_REPO" checkout -q -- ':(exclude)anhang' . 2>/dev/null || true
}

# ---- (3c) E-18-SNAP: Compile-Schnappschuss (OWNER-KERN Ledger frueh-6) ----------------
# WARUM ZWEI PHASEN -- die Reihenfolge ist load-bearing, nicht Stil:
#   Phase 1 (ERNTEN) MUSS VOR pdf_gate_aufraeumen laufen. Das Aufraeumen holt getrackte Dateien
#     ausserhalb von anhang/ per `git checkout` zurueck. Waere die gebaute PDF im Ziel-Repo
#     getrackt, setzte das Aufraeumen sie auf den EINGECHECKTEN Stand zurueck -- der Schnappschuss
#     zeigte dann eine ALTE PDF und wuerde genau die Nachvollziehbarkeit vortaeuschen, die er
#     herstellen soll. Im 289-Stand vom 06.08.2026 ist diplomarbeit.pdf per .gitignore ignoriert
#     (Regel `diplomarbeit*.pdf`), die frische PDF ueberlebt also zufaellig -- auf dieses
#     Zufallsglueck baut der Kanal NICHT.
#   Phase 2 (SCHREIBEN) kann erst NACH dem Commit laufen: vorher existiert die 289-SHA nicht, und
#     ohne sie ist der Compile nicht nachvollziehbar -- sie ist der halbe Zweck des Ordners.
#     Seit Codex HOCH-3 laeuft sie sogar erst NACH dem PUSH: der Push-Retry kann Merge-Commits
#     anhaengen, und dann ist die SHA, die auf dem Branch landet, eine andere als die des lokalen
#     Commits. Geschrieben wird gegen den GELANDETEN HEAD; weicht dessen Baum vom gebauten ab, wird
#     RE-GEERNTET (s. compile_snapshot_refixieren) statt umdeklariert.
#     AUSNAHME AF_NO_PUSH=true: dann gibt es keinen Push, der lokale Commit IST der Endstand.
AF_SNAP_STAGE="$AF_TMP/compile_snapshot"

compile_snapshot_einsammeln() {
  if [ "$AF_COMPILE_SNAPSHOT" != "true" ]; then
    echo "   E-18-SNAP: ABGESCHALTET (AF_COMPILE_SNAPSHOT=$AF_COMPILE_SNAPSHOT) -- kein Schnappschuss"
    return 0
  fi
  if [ -z "$AF_GATE_PDF" ]; then
    echo "   E-18-SNAP: KEIN Schnappschuss -- das PDF-Gate hat nicht gebaut (AF_PDF_GATE=$AF_PDF_GATE)"
    echo "   (kein Haken ohne Ausgabe: ohne Compile gibt es nichts nachzuvollziehen; ein leerer"
    echo "    Ordner waere eine Luege. Die AF_PDF_GATE-Semantik bleibt davon unberuehrt.)"
    return 0
  fi
  if [ ! -f "$AF_GATE_PDF" ]; then
    echo "FEHLER: PDF-Gate meldete GRUEN, aber sein Bau-Produkt '$AF_GATE_PDF' existiert nicht." >&2
    echo "       Das ist KEIN honest-empty-Fall, sondern ein Widerspruch in der Kanal-Logik (z.B." >&2
    echo "       latexmk-Ausgabeverzeichnis umgestellt) -> Abbruch statt leerem Schnappschuss." >&2
    return 1
  fi
  if [ ! -f "$AF_GATE_LOG" ]; then
    echo "FEHLER: Gate-Log '$AF_GATE_LOG' fehlt -- der 'latex compile-export' ist der Kern des" >&2
    echo "       Schnappschusses (OWNER-KERN). Ohne ihn wird KEIN halber Ordner abgelegt." >&2
    return 1
  fi
  # ERREXIT-LUECKE (Codex MITTEL-1): diese Funktion laeuft unter `if ! ...`, dort ist `set -e`
  # ABGESCHALTET. Jeder schreibende Schritt wird darum EINZELN geprueft -- sonst kaeme ein halber
  # Schnappschuss durch (z.B. Platte voll) und der Kanal meldete trotzdem Erfolg.
  # Die Ernte-Ablage wird VORHER GELEERT: sonst koennte eine Datei aus einem frueheren Bau in den
  # neuen Beleg einwandern (Codex: "Stage nicht geleert").
  rm -rf -- "$AF_SNAP_STAGE" \
    || { echo "FEHLER: E-18-SNAP: Ernte-Ablage '$AF_SNAP_STAGE' nicht raeumbar" >&2; return 1; }
  mkdir -p "$AF_SNAP_STAGE" || { echo "FEHLER: E-18-SNAP: Ernte-Ablage '$AF_SNAP_STAGE' nicht anlegbar" >&2; return 1; }
  local pdf_base sha_src sha_dst
  pdf_base="$(basename "$AF_GATE_PDF")"
  cp -- "$AF_GATE_PDF" "$AF_SNAP_STAGE/$pdf_base" \
    || { echo "FEHLER: E-18-SNAP: PDF '$AF_GATE_PDF' liess sich nicht ernten" >&2; return 1; }
  sha_src="$(af_sha256 "$AF_GATE_PDF")" \
    || { echo "FEHLER: E-18-SNAP: sha256 der Quell-PDF fehlgeschlagen" >&2; return 1; }
  sha_dst="$(af_sha256 "$AF_SNAP_STAGE/$pdf_base")" \
    || { echo "FEHLER: E-18-SNAP: sha256 der geernteten PDF fehlgeschlagen" >&2; return 1; }
  # af_sha256 kann nicht mehr leer zurueckkommen (fail-loud) -- der frueher moegliche
  # Doppelfehler-Vergleich ""=="" ist damit ausgeschlossen (Codex MITTEL-1).
  if [ -z "$sha_src" ] || [ -z "$sha_dst" ]; then
    echo "FEHLER: E-18-SNAP: leerer sha256 trotz Erfolgs-RC -- FAIL-CLOSED" >&2; return 1
  fi
  if [ "$sha_src" != "$sha_dst" ]; then
    echo "FEHLER: E-18-SNAP sha256-Mismatch beim Ernten der PDF ($sha_src != $sha_dst)" >&2
    return 1
  fi
  # .txt statt .log ist PFLICHT, nicht Geschmack: die super-.gitignore ignoriert global *.log und
  # hat fuer measurement/ keine Gegenausnahme -> ein compile.log wuerde beim Writeback still
  # weggeworfen (s. Datei-Kopf). Der Inhalt ist unveraendert der volle latexmk/pdflatex-Lauf.
  cp -- "$AF_GATE_LOG" "$AF_SNAP_STAGE/compile-export.txt" \
    || { echo "FEHLER: E-18-SNAP: compile-export '$AF_GATE_LOG' liess sich nicht ernten" >&2; return 1; }
  echo "   E-18-SNAP: geerntet $pdf_base ($(wc -c < "$AF_SNAP_STAGE/$pdf_base") Bytes, sha256=$sha_src)"
  echo "   E-18-SNAP: geerntet compile-export.txt" \
       "($(wc -l < "$AF_SNAP_STAGE/compile-export.txt") Zeilen $AF_GATE_TOOL-Ausgabe)"
  return 0
}

compile_snapshot_schreiben() {
  local thesis_sha="$1"
  [ "$AF_COMPILE_SNAPSHOT" = "true" ] || return 0
  # Phase 1 hat mit Begruendung nichts geerntet (kein Compile) -> hier ist ehrlich nichts zu tun.
  [ -d "$AF_SNAP_STAGE" ] || return 0
  # LEERER/UNGUELTIGER SHA IST FATAL (Codex MITTEL-1): frueher konnte ein fehlgeschlagenes
  # `git rev-parse HEAD` im AF_NO_PUSH-Pfad eine Zeile `thesis_commit_sha=` erzeugen -- und die
  # damalige Wache akzeptierte sie. Ein Beleg ohne Quellstand ist wertlos.
  case "$thesis_sha" in
    [0-9a-f]*) if [ "${#thesis_sha}" -ne 40 ]; then
                 echo "FEHLER: E-18-SNAP: '$thesis_sha' ist keine 40-stellige 289-SHA -> KEIN Beleg" >&2; return 1
               fi ;;
    *) echo "FEHLER: E-18-SNAP: leere/ungueltige 289-SHA ('$thesis_sha') -> KEIN Beleg" >&2; return 1 ;;
  esac
  af_snap_remote_init || return 1
  # Frischer Remote-Blick DIREKT vor der Namenswahl (zwischen Beleg-Test und Schreiben lag ein
  # kompletter LaTeX-Bau).
  af_snap_remote_refresh || return 1
  local ts basis dir tmpdir k cand rel_cand f b n mkerr pdf_name
  ts="$(date -u +%Y%m%d-%H%M%S)"     # "Benennung nach Datum und Uhrzeit" (OWNER-KERN), UTC, FS-sicher
  # (NB2-1) Der Name traegt die LAUF-KENNUNG -> runneruebergreifend eindeutig OHNE Reservierung.
  basis="$AF_SNAPSHOT_ROOT/$ts-$AF_SNAP_KENNUNG"
  mkdir -p "$AF_SNAPSHOT_ROOT" || { echo "FEHLER: E-18-SNAP: '$AF_SNAPSHOT_ROOT' nicht anlegbar" >&2; return 1; }
  if [ ! -w "$AF_SNAPSHOT_ROOT" ]; then
    echo "FEHLER: E-18-SNAP: '$AF_SNAPSHOT_ROOT' ist nicht beschreibbar -> FATAL (keine Kollision)" >&2; return 1
  fi
  # MESSDATEN-DOKTRIN: NUR ADDITIV. Ein bestehender Ordner wird NIE angefasst, nie ueberschrieben,
  # nie geloescht -- bei gleichem Namen waechst ein Kollisions-Suffix -2, -3, ... an.
  # DREI Wachen je Kandidat (Gurt zur eindeutigen Kennung):
  #   lokal ([ -e ]/[ -L ])  ->  REMOTE (Pfadliste)  ->  mkdir des .tmp OHNE -p (atomarer Lock).
  # (NB2-1) Der mkdir-Fehler wird nach ART unterschieden: nur ein bereits existierender Pfad ist
  # eine Kollision. EACCES/ENOSPC/fehlender Parent brechen SOFORT ab -- 99 Retries darauf waeren
  # eine Liveness-Falle mit irrefuehrender Meldung.
  dir=""; tmpdir=""; k=1
  while [ "$k" -le 99 ]; do
    if [ "$k" -eq 1 ]; then cand="$basis"; else cand="$basis-$k"; fi
    rel_cand="$AF_SNAP_REL/$(basename "$cand")"
    if [ -e "$cand" ] || [ -L "$cand" ]; then
      echo "   E-18-SNAP: '$cand' existiert LOKAL -> naechstes Suffix"
      k=$((k + 1)); continue
    fi
    if [ -n "$AF_SNAP_REL" ] && af_snapshot_remote_belegt "$rel_cand"; then
      echo "   E-18-SNAP: '$rel_cand' existiert bereits im REMOTE-Stand" \
           "($AF_SNAP_REMOTE/$AF_SNAP_REMOTE_BRANCH) -> naechstes Suffix"
      k=$((k + 1)); continue
    fi
    # (NB2-5) Gearbeitet wird im VERSTECKTEN .tmp -- der Endname entsteht erst beim atomaren mv.
    tmpdir="$AF_SNAPSHOT_ROOT/.$(basename "$cand").tmp"
    if mkerr="$(mkdir "$tmpdir" 2>&1)"; then
      dir="$cand"
      AF_SNAP_TMP_EIGEN="$AF_SNAP_TMP_EIGEN
$tmpdir"
      break
    fi
    if [ -e "$tmpdir" ] || [ -L "$tmpdir" ]; then
      echo "   E-18-SNAP: '$tmpdir' wurde parallel belegt (mkdir-Lock verloren) -> naechstes Suffix"
      k=$((k + 1)); continue
    fi
    echo "FEHLER: E-18-SNAP: '$tmpdir' liess sich anlegen -- KEINE Kollision, sondern ein echter" >&2
    echo "       Dateisystem-Fehler (Rechte/Platte/fehlender Parent). SOFORTIGER Abbruch statt 99" >&2
    echo "       irrefuehrender Kollisions-Retries:" >&2
    printf '       %s\n' "$mkerr" >&2
    return 1
  done
  if [ -z "$dir" ]; then
    echo "FEHLER: E-18-SNAP: '$basis' und 98 Kollisions-Suffixe sind belegt (lokal/remote/Lock) -> Abbruch" >&2
    echo "       (ueberschreiben ist unter der Messdaten-Doktrin verboten)" >&2
    return 1
  fi
  n=0
  for f in "$AF_SNAP_STAGE"/*; do
    [ -f "$f" ] || continue
    b="$(basename "$f")"
    cp -- "$f" "$tmpdir/$b" \
      || { echo "FEHLER: E-18-SNAP: '$b' liess sich nicht nach '$tmpdir' schreiben" >&2; return 1; }
    local sha_a sha_b
    sha_a="$(af_sha256 "$f")"        || { echo "FEHLER: E-18-SNAP: sha256 von '$f' fehlgeschlagen" >&2; return 1; }
    sha_b="$(af_sha256 "$tmpdir/$b")" \
      || { echo "FEHLER: E-18-SNAP: sha256 von '$tmpdir/$b' fehlgeschlagen" >&2; return 1; }
    if [ -z "$sha_a" ] || [ "$sha_a" != "$sha_b" ]; then
      echo "FEHLER: E-18-SNAP sha256-Mismatch beim Ablegen von '$b' ('$sha_a' != '$sha_b')" >&2; return 1
    fi
    n=$((n + 1))
  done
  pdf_name="$(basename "$AF_GATE_PDF")"
  {
    echo "# E-18-SNAP Compile-Schnappschuss -- QUELLSTAND"
    echo "# OWNER-KERN (Ledger frueh-6): 'so laesst sich ein compile nachvollziehen'."
    echo "# Diese Datei nennt GENAU die Staende, aus denen die danebenliegende PDF entstanden ist:"
    echo "# thesis_commit_sha ist der Quellstand der Diplomarbeit (Projekt 289), super_commit_sha"
    echo "# der Stand des Mess-/Bau-Repos (Projekt 288), der den Kanal-Lauf ausgeloest hat."
    echo "snapshot_id=$(basename "$dir")"
    echo "lauf_kennung=$AF_SNAP_KENNUNG"
    echo "generiert_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "thesis_commit_sha=$thesis_sha"
    echo "thesis_branch=$AF_BRANCH"
    echo "super_commit_sha=$AF_PROV_SUPER_SHA"
    echo "super_commit_ref=$AF_PROV_SUPER_REF"
    echo "kanal_lauf_id=${AF_PROV_PIPELINE_ID}"
    echo "kanal_lauf_url=${AF_PROV_PIPELINE_URL}"
    echo "quelle_kind=$SRC_KIND"
    echo "quelle_ref=$SRC_NOTE"
    echo "haupt_dokument=$AF_GATE_MAIN"
    echo "tex_werkzeug=$AF_GATE_TOOL"
    echo "pdf_datei=$pdf_name"
    echo "pdf_bytes=$(wc -c < "$tmpdir/$pdf_name")"
    echo "pdf_sha256=$(af_sha256 "$tmpdir/$pdf_name")"
    echo "compile_export=compile-export.txt"
    echo "anhang_dateien_uebernommen=$changed"
    # Modus: "vorwaerts" = dieser Lauf hat den 289-Commit erzeugt; "nachholen" = der 289-Stand lag
    # schon auf dem Branch, nur sein Compile-Beleg fehlte; "recovery" = der Beleg wurde fuer einen
    # FRUEHEREN Stand nachgeholt, den ein abgerissener Lauf schuldig geblieben ist.
    # Der Beleg behauptet nie, mehr getan zu haben, als getan wurde.
    echo "modus=$AF_MODE"
    echo "recovery_quelle=${AF_RECOVER_QUELLE:-NA}"
    echo "thesis_commit_aus_diesem_lauf=$([ "$AF_MODE" = "vorwaerts" ] && echo ja || echo nein)"
    # AF_NO_PUSH-Faelle duerfen nicht so aussehen, als sei der Stand gelandet (Codex).
    _gepusht="nein-nicht-noetig"
    if [ "$AF_MODE" = "vorwaerts" ]; then
      if [ "$AF_NO_PUSH" = "true" ]; then _gepusht="nein"; else _gepusht="ja"; fi
    fi
    echo "gepusht=$_gepusht"
  } > "$tmpdir/QUELLSTAND.txt" \
    || { echo "FEHLER: E-18-SNAP: QUELLSTAND.txt in '$tmpdir' nicht schreibbar" >&2; return 1; }
  # VOLLSTAENDIGKEITS-WACHE ueber den GEMEINSAMEN VALIDATOR (Codex NB2-3): dieselbe Funktion, die
  # auch entscheidet, ob ein FREMDER Ordner als Beleg gilt. Ein halb geschriebener Ordner darf NIE
  # als Erfolg durchgehen -- und da hier noch der .tmp-Name steht, entsteht der Endname gar nicht.
  if ! af_beleg_lokal_gueltig "$tmpdir" "$thesis_sha"; then
    echo "FEHLER: E-18-SNAP: unvollstaendiger/ungueltiger Schnappschuss in '$tmpdir' (s.o.)" >&2
    echo "       Ein halber Compile-Beleg ist schlimmer als keiner (er sieht vollstaendig aus)." >&2
    echo "       Der Endname '$dir' entsteht darum GAR NICHT; das .tmp raeumt der trap weg." >&2
    return 1
  fi
  # ATOMARE VEROEFFENTLICHUNG (NB2-5): erst jetzt bekommt der Beleg seinen Endnamen. Bis hierher
  # konnte kein Writeback und kein paralleler Lauf einen Halbstand sehen.
  if [ -e "$dir" ] || [ -L "$dir" ]; then
    echo "FEHLER: E-18-SNAP: '$dir' ist zwischen Reservierung und Veroeffentlichung entstanden ->" >&2
    echo "       KEIN Ueberschreiben (Messdaten-Doktrin). Der naechste Lauf waehlt ein neues Suffix." >&2
    return 1
  fi
  mv -T -- "$tmpdir" "$dir" || { echo "FEHLER: E-18-SNAP: '$tmpdir' -> '$dir' (mv) fehlgeschlagen" >&2; return 1; }
  AF_SNAP_TMP_EIGEN="$(printf '%s\n' "$AF_SNAP_TMP_EIGEN" | grep -vxF "$tmpdir" || true)"
  af_marker_erfuellen "$(basename "$dir")" || true
  echo "   E-18-SNAP: Schnappschuss abgelegt ($n Bau-Datei(en) + QUELLSTAND.txt, modus=$AF_MODE) -> $dir"
  find "$dir" -type f | sort | sed 's/^/     /'
  return 0
}

if [ "$AF_PDF_GATE" != "off" ]; then
  # In den Modi nachholen/recovery ist der Bau der EINZIGE Zweck des Laufs -- er muss frisch sein.
  GATE_ZWANG="nein"
  if [ "$AF_MODE" = "recovery" ]; then GATE_ZWANG="erzwingen"; fi
  if ! run_pdf_gate "$GATE_ZWANG"; then
    anhang_rollback "PDF-Gate rot"
    pdf_gate_aufraeumen
    if [ "$AF_MODE" = "recovery" ]; then
      git -C "$AF_DEST_REPO" checkout -q --force "$AF_DEST_ZURUECK" || true
      echo "=== anhang:forward ABGEBROCHEN: PDF-Gate rot bei der RECOVERY von $AF_BELEG_SHA ===" >&2
      echo "    Der Klon wurde auf den Ausgangsstand zurueckgesetzt; KEIN Beleg, KEIN Commit." >&2
    elif [ "$AF_MODE" = "nachholen" ]; then
      echo "=== anhang:forward ABGEBROCHEN: PDF-Gate rot bei der Beleg-NACHHOLUNG ===" >&2
      echo "    Es gab 0 Anhang-Delta -- der bereits gelandete 289-HEAD $DEST_HEAD baut NICHT." >&2
      echo "    KEIN Commit, KEIN Push, KEIN Schnappschuss (ein Beleg fuer einen kaputten Bau" >&2
      echo "    waere eine Luege). Das ist ein echter Befund am 289-Stand, kein Kanal-Fehler." >&2
    else
      echo "=== anhang:forward ABGEBROCHEN: PDF-Gate rot -> KEIN Commit, KEIN Push ===" >&2
    fi
    exit 1
  fi
  # E-18-SNAP Phase 1: ZWINGEND vor dem Aufraeumen (Begruendung s. Funktions-Kopf oben).
  if ! compile_snapshot_einsammeln; then
    echo "=== anhang:forward ABGEBROCHEN: E-18-SNAP konnte den Compile nicht sichern ===" >&2
    echo "    (KEIN Commit, KEIN Push -- der 289-Klon ist ephemer und wird je Lauf neu geholt)" >&2
    if [ "$AF_MODE" = "recovery" ]; then
      git -C "$AF_DEST_REPO" checkout -q --force "$AF_DEST_ZURUECK" || true
    fi
    exit 1
  fi
  pdf_gate_aufraeumen
else
  echo "   ABGESCHALTET (AF_PDF_GATE=off) -- es wurde NICHT geprueft, ob die PDF noch baut"
  # Ohne Gate gibt es kein Bau-Produkt; die Funktion sagt genau das literal (kein stiller Ausfall).
  if ! compile_snapshot_einsammeln; then
    echo "=== anhang:forward ABGEBROCHEN: E-18-SNAP konnte den Compile nicht sichern ===" >&2
    exit 1
  fi
fi

# ---- (3d) NACHHOLUNG / RECOVERY: 0 Byte-Delta, aber ein Compile-Beleg fehlte ----------
# Hier gibt es NICHTS zu committen und NICHTS zu pushen -- der 289-Stand liegt bereits auf dem
# Branch. Der Schnappschuss wird gegen GENAU DEN Stand fixiert, aus dessen Baum das Gate gebaut hat
# (nachholen: der 289-HEAD; recovery: die detachte Recovery-SHA) -- also nie divergent.
if [ "$AF_MODE" = "nachholen" ] || [ "$AF_MODE" = "recovery" ]; then
  echo "-- (3d) E-18-SNAP $AF_MODE (kein Commit, kein Push) -- Beleg-SHA=$AF_BELEG_SHA"
  SNAP_RC=0
  if [ ! -d "$AF_SNAP_STAGE" ]; then
    echo "=== anhang:forward OK: 0 Byte-Delta; $AF_MODE NICHT moeglich (kein Compile, s.o.) -> nichts abgelegt ==="
  elif ! compile_snapshot_schreiben "$AF_BELEG_SHA"; then
    SNAP_RC=1
  fi
  # Der Klon MUSS zurueck auf seinen Ausgangsstand: der Job-Block liest danach `rev-parse HEAD` als
  # NEW_THESIS_SHA und wuerde den Gitlink sonst RUECKWAERTS auf die Recovery-SHA setzen.
  if [ "$AF_MODE" = "recovery" ]; then
    git -C "$AF_DEST_REPO" checkout -q --force "$AF_DEST_ZURUECK" || true
    IST="$(git -C "$AF_DEST_REPO" rev-parse HEAD)"
    if [ "$IST" != "$DEST_HEAD" ]; then
      echo "FEHLER: der 289-Klon steht nach der Recovery auf $IST statt $DEST_HEAD -- der Writeback" >&2
      echo "       wuerde den Gitlink RUECKWAERTS setzen. Abbruch (kein stilles Gruen)." >&2
      exit 1
    fi
    echo "   RECOVERY: 289-Klon nachweislich zurueck auf $IST (== Ausgangs-HEAD)"
  fi
  if [ "$SNAP_RC" -ne 0 ]; then
    echo "=== anhang:forward ABGEBROCHEN: E-18-SNAP-$AF_MODE fehlgeschlagen ===" >&2
    echo "    (nichts committet, nichts gepusht -- der 289-Stand $DEST_HEAD bleibt unveraendert)" >&2
    exit 1
  fi
  echo "=== anhang:forward OK: KEIN Commit (0 Byte-Delta), Compile-Beleg zu" \
       "$AF_BELEG_SHA nachgeholt (modus=$AF_MODE) ==="
  exit 0
fi

# ---- (4) Commit mit Provenance -------------------------------------------------------
echo "-- (4) Commit --"
git -C "$AF_DEST_REPO" -c user.name="anhang-forward-bot" -c user.email="anhang-forward-bot@ci.local" \
  commit -q -m "anhang(E-18): Mess-Anhang aus $SRC_KIND '$SRC_NOTE' vorwaerts gesetzt ($changed Datei(en))

Automatisch erzeugt vom super-CI-Job anhang:forward (E-18 Vorwaerts-Kanal).
quelle_kind=$SRC_KIND
quelle_ref=$SRC_NOTE
super_commit_sha=$AF_PROV_SUPER_SHA
super_commit_ref=$AF_PROV_SUPER_REF
ci_pipeline_id=$AF_PROV_PIPELINE_ID
ci_pipeline_url=$AF_PROV_PIPELINE_URL
generiert_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "   commit: $(git -C "$AF_DEST_REPO" log --oneline -1)"
# Der Baum, aus dem das Gate gebaut hat. Er ist die Wahrheits-Referenz fuer Phase 2: nur solange
# der GELANDETE HEAD genau diesen Baum traegt, gehoert das Bau-Produkt wirklich zu ihm.
BUILD_TREE="$(git -C "$AF_DEST_REPO" rev-parse 'HEAD^{tree}')"
echo "   gebauter Baum: $BUILD_TREE"

if [ "$AF_NO_PUSH" = "true" ]; then
  # Kein Push => der lokale Commit IST der Endstand; nichts kann noch divergieren.
  echo "-- (4b) E-18-SNAP Compile-Schnappschuss (AF_NO_PUSH=true: lokaler Commit ist der Endstand) --"
  LOKAL_SHA="$(git -C "$AF_DEST_REPO" rev-parse HEAD 2>/dev/null || true)"
  if [ -z "$LOKAL_SHA" ]; then
    echo "FEHLER: HEAD des 289-Klons nicht aufloesbar -> KEIN Beleg mit leerer SHA (Codex MITTEL-1)" >&2
    exit 1
  fi
  if ! compile_snapshot_schreiben "$LOKAL_SHA"; then
    echo "=== anhang:forward ABGEBROCHEN: E-18-SNAP-Schnappschuss fehlgeschlagen ===" >&2
    echo "    (der 289-Commit ist lokal entstanden, aber NICHT gepusht -- nichts ist gelandet)" >&2
    exit 1
  fi
  echo "=== anhang:forward OK (lokal committet; AF_NO_PUSH=true -> kein Push) ==="
  exit 0
fi

# ---- (5) Push mit MERGE-Retry (KEIN rebase, KEIN --force) ----------------------------
# BEWUSST OHNE `-o ci.skip`: die 289-Pipeline (lint + thesis-pdf de/en) IST der
# Post-measure-Rebuild. 289 triggert 288 nicht zurueck -> kein Loop.
#
# WARUM DER SCHNAPPSCHUSS ERST NACH DEM PUSH GESCHRIEBEN WIRD (Codex HOCH-3): jeder Retry haengt
# einen MERGE-Commit an. Was am Ende auf dem Branch steht, ist dann NICHT der Commit, dessen Baum
# das Gate gebaut hat. Ein vorher geschriebener QUELLSTAND behauptete "diese PDF gehoert zu X" --
# und X traegt einen anderen Inhalt als der Branch. Genau das ist die divergente Dokumentation, die
# der Ordner verhindern soll. Also: erst landen, dann belegen -- und wenn der gelandete Baum ein
# anderer ist, ERNEUT ernten statt umdeklarieren.
#
# (NB2-2) VOR JEDEM Push-Versuch wird die RECOVERY-IDENTITAET in den 288-Baum geschrieben: die SHA,
# die gleich gepusht wird. Stirbt der Lauf danach, weiss ein spaeterer Lauf trotzdem, welchem Stand
# der Beleg fehlt -- auch wenn der 289-HEAD inzwischen weitergewandert ist.
echo "-- (5) Push nach $AF_BRANCH (ohne ci.skip: die 289-Pipeline ist der Rebuild) --"
if [ "$AF_COMPILE_SNAPSHOT" = "true" ]; then
  if ! af_snap_remote_init; then
    echo "FEHLER: E-18-SNAP-Wache liess sich vor dem Push nicht initialisieren -> Abbruch" >&2; exit 1
  fi
fi
PUSH_MERGES=0
PUSH_OK=false
PUSH_ATTEMPT=0
for attempt in $(seq 1 "$AF_PUSH_RETRIES"); do
  PUSH_ATTEMPT="$attempt"
  if ! af_marker_schreiben "$(git -C "$AF_DEST_REPO" rev-parse HEAD)"; then
    echo "FEHLER: Recovery-Identitaet liess sich nicht ablegen -> Abbruch VOR dem Push" >&2
    echo "       (ohne sie waere ein Absturz nach dem Push wieder unrekonstruierbar)" >&2
    exit 1
  fi
  if git -C "$AF_DEST_REPO" push origin "HEAD:$AF_BRANCH"; then
    PUSH_OK=true
    break
  fi
  echo "   push abgelehnt (non-ff-Race) -> fetch + MERGE (kein rebase) + retry ($attempt)" >&2
  git -C "$AF_DEST_REPO" fetch origin "$AF_BRANCH"
  if ! git -C "$AF_DEST_REPO" -c user.name="anhang-forward-bot" -c user.email="anhang-forward-bot@ci.local" \
        merge --no-edit -m "Merge origin/$AF_BRANCH in anhang-forward $SRC_NOTE" "origin/$AF_BRANCH"; then
    git -C "$AF_DEST_REPO" merge --abort || true
    echo "FEHLER: unerwarteter Merge-Konflikt (Versuch $attempt) -> echter Bug, Abbruch (kein --force)" >&2
    exit 1
  fi
  PUSH_MERGES=$((PUSH_MERGES + 1))
  sleep $(( (RANDOM % 5) + 2 ))
done
if [ "$PUSH_OK" != "true" ]; then
  echo "FEHLER: Push nach $AF_PUSH_RETRIES Versuchen fehlgeschlagen" >&2
  exit 1
fi
PUSHED_SHA="$(git -C "$AF_DEST_REPO" rev-parse HEAD)"
PUSHED_TREE="$(git -C "$AF_DEST_REPO" rev-parse 'HEAD^{tree}')"
echo "   gepusht (Versuch $PUSH_ATTEMPT): HEAD=$PUSHED_SHA baum=$PUSHED_TREE merges=$PUSH_MERGES"

# ---- (5b) E-18-SNAP Phase 2: Beleg gegen den TATSAECHLICH gepushten HEAD --------------
echo "-- (5b) E-18-SNAP Compile-Schnappschuss (gegen den gelandeten Stand) --"
# Re-Ernte, falls der gelandete Baum nicht der gebaute ist. Nur zwei Ausgaenge sind erlaubt:
# wahrer Beleg oder lauter Abbruch -- niemals ein Beleg mit fremder SHA.
compile_snapshot_refixieren() {
  [ "$AF_COMPILE_SNAPSHOT" = "true" ] || return 0
  [ -d "$AF_SNAP_STAGE" ] || return 0          # nichts geerntet (kein Compile) -> nichts zu richten
  if [ "$PUSHED_TREE" = "$BUILD_TREE" ]; then
    echo "   E-18-SNAP: gelandeter Baum == gebauter Baum ($BUILD_TREE) -> Bau-Produkt gilt unveraendert"
    return 0
  fi
  echo "   E-18-SNAP: der Push lief ueber $PUSH_MERGES Merge-Commit(s); gelandeter Baum $PUSHED_TREE" >&2
  echo "   ist NICHT der gebaute $BUILD_TREE -> RE-ERNTE (nie divergent dokumentieren)" >&2
  if [ "$AF_PDF_GATE" = "off" ]; then
    echo "FEHLER: Re-Ernte unmoeglich (AF_PDF_GATE=off) -- ein Beleg mit fremder SHA waere eine Luege." >&2
    return 1
  fi
  # Der Ernte-Zwischenstand gehoert diesem Lauf allein (fester Name unter $AF_TMP) und wird
  # verworfen, damit keine Datei aus dem ALTEN Bau in den neuen Beleg rutscht.
  rm -rf -- "$AF_SNAP_STAGE" || { echo "FEHLER: Ernte-Ablage '$AF_SNAP_STAGE' nicht raeumbar" >&2; return 1; }
  AF_GATE_PDF=""; AF_GATE_MAIN=""; AF_GATE_TOOL=""
  # (NB2-4) ERZWUNGEN: ohne -gg/Loeschen koennte latexmk "Nothing to do" melden und die ALTE PDF
  # bekaeme die NEUE SHA aufgedruckt. Die Neuheits-Wache in run_pdf_gate belegt die Re-Kompilation.
  if ! run_pdf_gate erzwingen; then
    echo "FEHLER: Re-Ernte: der GEMERGTE Stand $PUSHED_SHA baut nicht (oder wurde nicht neu gebaut)" >&2
    echo "       -> KEIN Schnappschuss." >&2
    return 1
  fi
  if [ -z "$AF_GATE_PDF" ]; then
    echo "FEHLER: Re-Ernte: das PDF-Gate hat diesmal nicht gebaut -> KEIN Schnappschuss (statt eines" >&2
    echo "       Belegs, der die PDF des VORIGEN Baums traegt)." >&2
    return 1
  fi
  compile_snapshot_einsammeln || return 1
  pdf_gate_aufraeumen
  echo "   E-18-SNAP: re-geerntet aus dem gelandeten Baum $PUSHED_TREE"
  return 0
}
# WELCHE RECOVERY-QUELLE HIER WIRKLICH TRAEGT (Restbefund, gemessen am Objekt 11.08.2026):
#   Der Marker-Weg (i) verlangt, dass die Datei PENDING-<kennung>.txt in den 288-BAUM kommt --
#   und das tut ausschliesslich der 288-Writeback des Job-Blocks (Stufe 4b, Einbuchung). Ein
#   'exit 1' HIER toetet mit 'set -euo pipefail' den ganzen Job, BEVOR dieser Writeback laeuft:
#   der Marker liegt dann nur im Runner-Workspace und stirbt mit ihm. Die frueheren Zeilen an
#   dieser Stelle sagten trotzdem "der naechste Lauf holt den Beleg darueber nach" -- eine
#   Zusage auf einen Weg, den genau dieser Ausgang selbst zerstoert. Was hier TRAEGT, ist
#   Quelle (ii): die Bot-Commits in 289 sind die dauerhafte Spur und ueberleben jeden
#   Runner-Tod. Der Text nennt darum ab jetzt (ii) zuerst und (i) nur noch mit seiner Bedingung.
af_recovery_hinweis() {
  echo "    RECOVERY: dauerhaft traegt hier die BOT-HISTORIE in 289 -- der naechste Lauf findet" >&2
  echo "    $PUSHED_SHA als juengsten Bot-Commit ohne gueltigen Beleg und holt ihn nach." >&2
  echo "    Der PENDING-Marker '${AF_SNAP_MARKER:-<keine>}' hilft NUR, wenn ein Lauf den" >&2
  echo "    288-Writeback noch erreicht; DIESER Ausgang erreicht ihn nicht (Job endet hier)." >&2
}
if ! compile_snapshot_refixieren; then
  echo "=== anhang:forward ABGEBROCHEN: 289-Commit IST GEPUSHT ($PUSHED_SHA), aber der Compile-Beleg ===" >&2
  echo "    liess sich nicht wahrheitsgemaess auf diesen Stand fixieren -> KEIN Schnappschuss abgelegt." >&2
  af_recovery_hinweis
  exit 1
fi
if ! compile_snapshot_schreiben "$PUSHED_SHA"; then
  echo "=== anhang:forward ABGEBROCHEN: 289-Commit IST GEPUSHT ($PUSHED_SHA), aber der Compile-Beleg ===" >&2
  echo "    liess sich nicht ablegen -> KEIN Schnappschuss." >&2
  af_recovery_hinweis
  exit 1
fi
echo "=== anhang:forward OK: gepusht (Versuch $PUSH_ATTEMPT) nach $AF_BRANCH ==="
exit 0
