# AUDIT RUNDE 2 (RE-VERIFY) — Strang "messfenster" (#13/T-15b + #38b/C-05)

Pruefer: Fable-max-RE-VERIFY Runde 1 (Fix-Verify-Schleife). Datum: 22.08.2026.
Objekt: ce `bau/messfenster` @ `3a746090ae6abb95ae9c1bce498e1cf54d81f1f3` (UNVERAENDERT gegenueber
Audit R1 und Fix R1 — eigene Messung, s.u.). Worktree /home/comdare/wt-ce-messfenster.
Eingang VOLL gelesen: soll-karte.md (205 Z., P-01..P-20) + audit-runde-1.md (415 Z., Funde A-1/A-2)
+ fix-runde-1.md (153 Z., 2/2 BEHOBEN, 0 VERTAGT) + mess-fenster-ergebnis.md NACH Nachtrag (266 Z.,
voll) + fmt-eigenmessung-fixR1.log (24 Z.).
Modus: Hauptklon/Worktree NUR LESEN (git show/grep gegen 3a746090; clang-format nur --dry-run);
kein Bau-Slot gezogen (Begruendung Abschnitt 4); geschrieben NUR diese Datei.

VERDIKT: **SITZT** (0 neue Funde). Beide BEHOBEN-Quittungen halten der eigenstaendigen Nachmessung
stand; der einzige offene Fixweg-Teil ist mit benanntem Traeger an den Lande-Zug uebergeben; der
Branch-Tip ist byte-identisch geblieben (keine Regressionsflaeche); die Restliste gegen die
Soll-Karte traegt ausschliesslich bereits getragene Posten.

--------------------------------------------------------------------------------

## 1. EIGENE MESSUNGEN (Literale; nichts aus den Berichten abgeschrieben)

M-1  `git ls-remote origin refs/heads/bau/messfenster` = `3a746090ae6abb95ae9c1bce498e1cf54d81f1f3`
     (Ref-Sicherung steht; identisch mit Audit-R1- und Fix-R1-Messung).
M-2  Worktree wt-ce-messfenster: `git rev-parse HEAD` = `3a746090ae6abb95ae9c1bce498e1cf54d81f1f3`,
     `git status --porcelain | wc -l` = 0. `git rev-list --count 66de5c09..3a746090` = 1 (genau
     EIN Commit; die Fix-Stufe hat 0 Commits erzeugt — Tip-Hash-Gleichheit beweist Baum-Identitaet).
M-3  Diff-Menge selbst hergeleitet: `git diff --name-only 66de5c09..3a746090` = 20 Dateien,
     davon 19 mit Endung .hpp/.cpp; die eine Nicht-Lint-Datei ist tests/unit/CMakeLists.txt
     (deckt die 19er-Menge des fmt-Logs und der Fix-Quittung A-2 exakt).
M-4  mess-fenster-ergebnis.md: `wc -l` = 266 (Fix-Angabe 245 -> 266 bestaetigt; Einfuegeblock
     Z.193-213 = exakt 21 Zeilen = das Delta). Einfuege-Raender sauber: Z.191-192 = Alt-Text-Ende
     ("KEIN Produktcode-Fix." + Leerzeile), Z.193 Kopf "#### NACHTRAG Fix-Stufe A2.5 R1", Z.213
     letzter [A-2]-Satz, Z.215 = Alt-Abschnitt "### T-11c Wegwerf-Mutationen" unveraendert.
M-5  ASCII-Probe des Einfuegeblocks: `sed -n '193,213p' | grep -n '[^ -~]'` -> rc=1, 0 Treffer
     (Fix-Behauptung bestaetigt).
M-6  Alt-Literale unangetastet: "J-1 6 Werkzeuge rc=0" hat GENAU 2 Vorkommen — Z.186 (vor dem
     Einfuegepunkt, unverschoben) + Z.254 (nach dem Einfuegepunkt, um die 21 Zeilen verschoben).
     Der Fix hat den Alt-Text NICHT umgeschrieben, sondern per Nachtrag erklaert — exakt der vom
     Audit vorgeschriebene Weg ("Berichts-Nachtrag", A-1-Fixweg Komponente 2).
M-7  `grep -c 'clang-format' mess-fenster-ergebnis.md` = 1 (vorher 0; Berichts-Luecke A-2
     geschlossen, genau eine Erwaehnung im [A-2]-Bullet).
M-8  Rekonstruktions-QUELLEN der Sechser-Liste selbst gelesen (alle drei wortgleich dieselben
     sechs Namen): s19-simulation-ergebnis.md Z.229-231 ("J-1-Treppe (comdare_adhoc_emitter_cli
     comdare_anatomy_codegen_cli comdare_catalog_codegen_cli comdare_axis_registry_gen
     comdare_measurement_axis_registry_gen comdare_system_axis_registry_gen; Auftrags-Liste)
     RC=0") + skip-oekonomie-97-ergebnis.md Z.104-106 + traegerbau-s8-ergebnis.md Z.131-133
     (dort zusaetzlich der Struktur-Beleg "alle *_registry_gen am Objekt = genau diese 3").
     Das rekonstruierte fehlende siebte Werkzeug (comdare_overlay_source_hash_gen, KEIN
     *_registry_gen) folgt schluessig; der Nachtrag deklariert die Rekonstruktion als solche.
M-9  Bau-Graph-Behauptungen am Objekt (git show @ 3a746090, alle eigenstaendig):
     - tools/overlay_source_hash_gen/CMakeLists.txt:44 `add_executable(comdare_overlay_source_hash_gen
       main.cpp)` OHNE EXCLUDE_FROM_ALL; Kopf Z.3 woertlich "NICHT EXCLUDE_FROM_ALL (anders als
       die Registry-Generatoren)".
     - cmake/overlay_source_hash.cmake:37 `add_custom_target(comdare_overlay_source_hash ALL` +
       :38 `COMMAND $<TARGET_FILE:comdare_overlay_source_hash_gen>` + :45
       `add_dependencies(comdare_overlay_source_hash comdare_overlay_source_hash_gen)`.
       BEFUND UEBER DIE FIX-BELEGE HINAUS: das Custom-Target ist selbst ALL-gebunden — der
       `--target all`-Schritt baut das siebte Werkzeug damit DOPPELT zwingend (add_executable
       ohne EXCLUDE_FROM_ALL UND ALL-Custom-Target mit harter add_dependencies-Kante). Die
       Schadens-Eingrenzung der Fix-Stufe ist also eher noch zu vorsichtig formuliert.
     - Die drei registry_gen tragen EXCLUDE_FROM_ALL exakt an den genannten Zeilen:
       tools/axis_registry_gen/CMakeLists.txt:27, tools/measurement_axis_registry_gen/
       CMakeLists.txt:10, tools/system_axis_registry_gen/CMakeLists.txt:10.
     - Alle SIEBEN Doktrin-Werkzeuge haben am Tip eine eigene add_executable-Definition
       (git grep, 7 Treffer, Pfade identisch mit der Fix-Quittung Nr. 2).
M-10 EIGENE clang-format-Gegenprobe (dritter unabhaengiger Lauf, NUR --dry-run, Worktree
     unberuehrt): `~/.local/bin/clang-format-22 --dry-run -Werror` (Version literal "Ubuntu
     clang-format version 22.1.8 (++20260613092238+e80beda6e255-1~exp1~20260613092253.78)")
     ueber die 19 Lint-Dateien aus M-3 im Worktree @ Tip:
     **"REVERIFY-BILANZ: 0 von 19 Dateien mit Abweichung (OK=19)"** — deckungsgleich mit
     Audit-Nachmessung (0/19) UND Fix-Eigenmessung (0/19); drei unabhaengige Laeufe, ein Objekt.
M-11 fmt-eigenmessung-fixR1.log gelesen (24 Z.): Kopf traegt Objekt-Hash + porcelain 0 +
     Werkzeug-Version, 19 "OK <pfad>"-Zeilen (Pfad-Menge == M-3-Herleitung), Schlusszeile
     "BILANZ: 0 von 19 Dateien mit Abweichung". Persistenter Beweis liegt.
M-12 Objekt-Anker der Kern-Mechanik am Tip (Stichproben, binden diese Runde ans Objekt):
     harness/mess_retry_klammer.hpp:56 `max_versuche = 5` · harness/drift_gated_cell.hpp:133
     `max_reruns = 3` · builder/build_orchestrator/build_orchestrator.hpp:113
     `bau_max_versuche = 5` · tests/unit/CMakeLists.txt-DATEIENDE = t15b-Block (add_test +
     COMDARE_TEST_TARGETS-Property + LABELS "t15b;c05;retry;warmup-paar;messfenster;standalone;
     koeder", kein 'pmc'-Substring).

--------------------------------------------------------------------------------

## 2. QUITTUNGS-PRUEFUNG (je Fund, dreiwertig)

### A-1 (MILD) "J-1 6 statt 7 Werkzeuge, Liste unbenannt" — Quittung BEHOBEN: **BESTAETIGT**
- Der dieser Stufe zugewiesene Fixweg-Teil (Komponente 2, Berichts-Nachtrag) ist vollzogen und
  traegt mehr als gefordert: Nachtrag [A-1] Z.194-208 benennt BEIDE Mengen (die sechs gefahrenen
  Namen als deklarierte Rekonstruktion + das fehlende siebte) UND liefert den Bau-Graph-Beweis,
  dass das siebte Werkzeug vom ohnehin gefahrenen `--target all` gebaut wurde (M-9: eigene
  Messung bestaetigt jede einzelne CMake-Behauptung; das ALL-Custom-Target macht die Deckung
  sogar doppelt). Rekonstruktions-Quellen von mir selbst gelesen und wortgleich befunden (M-8).
- Additivitaet + ASCII + Alt-Literal-Erhalt selbst gemessen (M-4/M-5/M-6).
- Fixweg-Komponente 1 (frischer SIEBENER-J-1-Lauf) ist NICHT Teil dieser Quittung und wurde
  ehrlich als getragen deklariert — Traeger-Pruefung in Abschnitt 3.

### A-2 (KLEIN) "clang-format-Lauf nicht ausgewiesen" — Quittung BEHOBEN: **BESTAETIGT**
- Berichts-Nachtrag [A-2] Z.209-213 vorhanden; grep-Zaehlung 0 -> 1 (M-7).
- Persistentes Beweis-Log liegt und ist in sich konsistent (M-11); Datei-Menge deckt sich mit
  meiner eigenen Diff-Herleitung (M-3).
- Eigene DRITTE Messung am Objekt: 0/19 Abweichungen (M-10) — Substanz und Beleg stehen.

--------------------------------------------------------------------------------

## 3. VERTAGT-/TRAEGER-PRUEFUNG

- Die Fix-Stufe meldet 0 VERTAGT — bestaetigt: beide Fund-IDs sind quittiert und nachgemessen.
- Der einzige bewusst NICHT in dieser Stufe erledigte Fixweg-Teil (A-1 Komponente 1: doktrinaler
  7er-J-1-Lauf mit literaler Liste) hat einen BENANNTEN, EXISTIERENDEN Traeger:
  Lande-Zug-Kombibau am gemergten Endstand (K17/T-11b; Audit R1 §4 "T-11b/K17 ... dort Fund
  A-1-Fixweg mit abdecken"; STAFFEL1-SYNTHESE Phase 3/4). Der Fix-Bericht §3 uebergibt dazu
  einen woertlichen Protokoll-ENTWURF inkl. des sachlich richtigen Warnhinweises, dass die drei
  *_registry_gen EXCLUDE_FROM_ALL sind und NUR die explizite J-1-Zeile sie deckt (von mir am
  Objekt bestaetigt, M-9) — ein "all"-Gruen allein beweist sie nicht. Traeger-Platz: ERFUELLT.
- Ebenso getragen (unveraendert aus Audit R1 §4, kein neuer Handlungsbedarf dieser Runde):
  F-10/H-5 (S-19 18->120 beim s19-Merge) · F-13 (Register S5-06, super/Lead, Entwurf liegt) ·
  F-14 (Non-ASCII-Altzeilen-Sichtung, Rohdatum liegt im Audit R1 P-17) · F-12 (S5-05) ·
  H-1..H-4 (Harmonisierung, messfenster = Schritt 1) · C-09 (Anschluss-Auftrag) ·
  Ledger-ENTWUERFE (KON120-Zug) · S-13-Kopplungs-Rohdatum (18,75 GiB @ 120 vs. 6GB-fest).

--------------------------------------------------------------------------------

## 4. REGRESSIONS-PRUEFUNG (Stichprobe Nachbar/Format)

- Der Branch-Tip ist byte-identisch geblieben: gleicher Commit-Hash 3a746090 lokal UND origin
  (M-1/M-2), 0 neue Commits, Worktree porcelain 0. Die Fix-Stufe schrieb ausschliesslich unter
  /home/comdare/backups-workflow/ (Nachtrag additiv, M-4/M-6; zwei neue Dateien fix-runde-1.md +
  fmt-Log). Eine Code-/Test-/golden-Regression ist damit strukturell ausgeschlossen — derselbe
  Commit-Hash deckt denselben Baum, den Audit R1 Punkt-fuer-Punkt statisch verifiziert hat.
- Objekt-Stichproben am Tip trotzdem gefahren und gruen (M-12: Retry-5 / Drift-3 / Bau-5 /
  T-7-Dateiende-Block) plus Format-Vollprobe 0/19 (M-10).
- KEIN Bau-Slot gezogen — BEIDE Mengen: Diese Runde deckt die Fix-Quittungen, die statischen
  Objekt-Anker und den Format-Stand am unveraenderten Tip; NICHT gedeckt (Traeger: Lande-Zug
  K17/H-7, dort ohnehin Pflicht) bleibt der frische 7er-Treppen-/ctest-/4-Zellen-Lauf am
  GEMERGTEN Endstand. Ein Vollbau am byte-identischen Tip haette keinen neuen Gegenstand und
  wuerde einen der 3 geteilten Slots des laufenden W1L-Kombibaus binden (dieselbe Abwaegung
  trafen Audit R1 Z.9-11 und Fix R1 §2).

--------------------------------------------------------------------------------

## 5. RESTLISTE GEGEN DIE SOLL-KARTE (P-01..P-20)

Audit R1 hat alle 20 Punkte dreiwertig als ERFUELLT (bzw. auftragsgemaess ENTWURF/Deklaration)
geprueft; die beiden einzigen Funde betrafen Beweis/Berichterstattung und sind jetzt BEHOBEN
(Abschnitt 2). Meine Stichproben decken die Kern-Anker P-01/P-03/P-12 zusaetzlich am Objekt
(M-12), P-18 vollstaendig (M-10) und P-19 erneut (M-1/M-2). Es verbleibt KEIN Soll-Karten-Punkt
ohne Erfuellung oder benannten Traeger; die deklarierten NICHT-GEFORDERT-Posten der Soll-Karte
(C-09, E1-E10, T-12c/d/e, --debug-CLI, Freeze-P-Vermerk, Register-Eintragung, S-19-Nachzug,
T-11b-Kombibau) bleiben korrekt ausserhalb dieses Strangs. Keine neuen IDs zu vergeben.

## 6. RANDNOTIZEN (keine Funde)

- Audit R1 zitierte das zweite Alt-Literal als Z.232 (alte Zaehlung); rechnerisch aus der
  266er-Fassung waere es Z.233 gewesen (254 - 21). Eine Zeile Zitier-Toleranz ohne jede
  Substanzwirkung — beide Literale existieren und sind eindeutig adressierbar (M-6).
- Eine persistierte Kopie der 245-Zeilen-Altfassung existiert nicht (backups-workflow und
  super-Historie geprueft, 0 Treffer) — die Additivitaet ist stattdessen ueber die exakte
  Zeilen-Arithmetik (245 + 21 = 266), die sauberen Einfuege-Raender und den Wortgleich-Erhalt
  aller von Soll-Karte/Audit zitierten Alt-Passagen belegt (M-4/M-6). Kuenftige Fix-Stufen
  koennten vor Nachtraegen eine Altfassungs-Kopie in den Strang-Ordner legen — Empfehlung an
  die Synthese, kein Fund (der vereinbarte Traeger der Staffel sind die Berichts-Literale).

## 7. SELBSTCHECK

Alle 3 Eingaenge + der nachgetragene Strang-Bericht + das fmt-Log VOLL gelesen; 12 eigene
Messungen (M-1..M-12) mit Literalen, keine Audit-/Fix-Zahl ungeprueft uebernommen (Sechser-Liste,
CMake-Kanten, Format-Bilanz, Diff-Menge, ASCII, Zeilenzahlen je eigenstaendig reproduziert).
Geschrieben NUR diese Datei; Worktree/Hauptklon/Ledger/Board/Memory/Vault/TABU-Zonen unberuehrt;
clang-format ausschliesslich --dry-run; kein Bau-Slot gezogen (Abschnitt 4, beide Mengen benannt);
/tmp-Hilfsdatei /tmp/reverify-mf-difffiles.txt (wegwerfbar). VERDIKT: SITZT.

--------------------------------------------------------------------------------

## 8. WIEDERANLAUF-RE-VERIFY (23.08.2026 — FUENFTE unabhaengige Messreihe, Schema-Ablieferung)

ANLASS: Der Orchestrator startete die RE-VERIFY-Stufe erneut — das Schema-Ergebnis der
22.08.-Session (Abschnitte 1-7 oben) hat ihn nie erreicht (Klasse "stummer Workflow-Tod";
dieselbe Klasse traf zuvor die Fix-Stufe, s. fix-runde-1.md §5 vom 23.08.). NEUER EINGANG seit
den Abschnitten 1-7: fix-runde-1.md traegt jetzt den additiven §5-Wiederanlauf-Nachtrag
(Messreihe W-1..W-7, 23.08.) und das additive Log fmt-eigenmessung-fixR1-wiederanlauf23.log
(23.08. 13:56, 0/19). Wiederanlauf-Doktrin: NICHTS abgeschrieben — alle folgenden Literale sind
Messungen DIESER Session (R-Serie), unabhaengig von M-Serie (22.08.-Audit-R2), Fix-R1-Belegen
und W-Serie (23.08.-Fix-Wiederanlauf).

R-1  Worktree-Lage: `git worktree list` fuehrt /home/comdare/wt-ce-messfenster @ 3a746090
     [bau/messfenster]; `git ls-remote origin refs/heads/bau/messfenster` =
     `3a746090ae6abb95ae9c1bce498e1cf54d81f1f3` — Ref-Sicherung steht unveraendert.
R-2  Worktree: `git rev-parse HEAD` = `3a746090ae6abb95ae9c1bce498e1cf54d81f1f3`,
     porcelain-Zeilen 0, `git rev-list --count 66de5c09..3a746090` = 1. Autor/Committer UND
     Trailer-Zeile 34 des Commit-Texts: "Claude Fable 5 <noreply@anthropic.com>". Der Tip ist
     byte-identisch mit dem Stand aller vier frueheren Messreihen — auch der Fix-WIEDERANLAUF
     (23.08.) hat 0 Commits erzeugt.
R-3  Diff-Menge selbst hergeleitet: 20 Dateien, 19 .hpp/.cpp, Nicht-Lint-Rest exakt
     tests/unit/CMakeLists.txt (deckt M-3/W-6).
R-4  mess-fenster-ergebnis.md: wc -l = 266; mtime 2026-08-22 06:35 UTC — der Fix-Wiederanlauf
     hat den Strang-Bericht NICHT erneut beschrieben (deckt dessen Selbstauskunft "Geschrieben
     ... NUR §5 + Wiederanlauf-Log"); Einfuege-Raender erneut gesichtet (Z.191-192 Alt-Ende
     "KEIN Produktcode-Fix." + Leerzeile; Z.193 NACHTRAG-Kopf; Z.215 Alt-Abschnitt
     "### T-11c Wegwerf-Mutationen" unveraendert).
R-5  ASCII-Probe Z.193-213: `grep -n '[^ -~]'` rc=1, 0 Treffer.
R-6  Alt-Literal "J-1 6 Werkzeuge rc=0" GENAU 2x: Z.186 + Z.254 (grep -n); `grep -c
     'clang-format'` = 1. Beide Fix-Behauptungen halten.
R-7  A-1-Bau-Graph komplett selbst nachgemessen (git grep/show @ 3a746090): alle SIEBEN
     Doktrin-Werkzeuge mit eigener add_executable-Definition (apps/adhoc_emitter:7 ·
     apps/anatomy_codegen_tool:3 · apps/catalog_codegen_tool:3 · tools/axis_registry_gen:27
     EXCLUDE_FROM_ALL · tools/measurement_axis_registry_gen:10 EXCLUDE_FROM_ALL ·
     tools/system_axis_registry_gen:10 EXCLUDE_FROM_ALL · tools/overlay_source_hash_gen:44
     OHNE EXCLUDE_FROM_ALL, Kopf Z.3 woertlich "NICHT EXCLUDE_FROM_ALL (anders als die
     Registry-Generatoren)"); cmake/overlay_source_hash.cmake:37 `add_custom_target(
     comdare_overlay_source_hash ALL` + :38 `COMMAND $<TARGET_FILE:comdare_overlay_source_
     hash_gen>` + :45 `add_dependencies(...)` — die "doppelt zwingende" all-Deckung des
     siebten Werkzeugs (M-9/W-4) bestaetigt.
R-8  Kern-Anker am Tip: mess_retry_klammer.hpp:56 `max_versuche = 5` · drift_gated_cell.hpp:133
     `max_reruns = 3` · build_orchestrator.hpp:113 `bau_max_versuche = 5` · tests/unit/
     CMakeLists.txt-DATEIENDE = t15b-Block (add_test + COMDARE_TEST_TARGETS-Property + LABELS
     "t15b;c05;retry;warmup-paar;messfenster;standalone;koeder").
R-9  Rekonstruktions-Quellen der Sechser-Liste erneut selbst gelesen — alle drei wortgleich
     dieselben sechs Namen (mit adhoc_emitter_cli, OHNE overlay_source_hash_gen):
     s19-simulation-ergebnis.md:229-231 · skip-oekonomie-97-ergebnis.md:104-106 ·
     traegerbau-s8-ergebnis.md:131-133 (inkl. "alle *_registry_gen am Objekt = genau diese 3;
     ninja -t targets").
R-10 EIGENER clang-format-22-Lauf (FUENFTER unabhaengiger; nur --dry-run -Werror, Worktree
     unberuehrt, Version "Ubuntu clang-format version 22.1.8 (++20260613092238+e80beda6e255-
     1~exp1~20260613092253.78)") ueber die 19 Dateien aus R-3:
     **"REVERIFY-WIEDERANLAUF-BILANZ: 0 von 19 Dateien mit Abweichung"**; Log ADDITIV
     persistiert: fmt-eigenmessung-reverify-wiederanlauf23.log (die Logs vom 22.08. und vom
     Fix-Wiederanlauf 23.08. unangetastet, mtimes 06:34/13:56).
R-11 TRAEGER-REALITAET (neu gegenueber Abschnitt 3 — der Lande-Zug LAEUFT inzwischen):
     `git merge-base --is-ancestor 3a746090 53c5524e` = JA; Lande-Zweig lande/w2-s1s2
     (wt-ce-lande) traegt `61d5d139 merge(messfenster): W2-Lande-Zug 2/10 -- ... bau/messfenster
     @ 3a746090; Audit r2 SITZT, 0 neue Funde` UND am juengeren Ende `53c5524e fix(lande/w2-s19):
     H-5/F-10-Nachzug 18->120er-Basis VOLLZOGEN` + `ed79090c fix(lande/w2-hygiene): F-14-Sichtung
     VOLLZOGEN + 6 Breiten-Heilungen`. Damit sind ZWEI der in Abschnitt 3 getragenen Posten
     (F-10/H-5, F-14) am Traeger bereits vollzogen (Betreff-Literale; die Lande-Strecke fuehrt
     ihre eigene Beweis-/Audit-Kette) und die Lande-Reihenfolge messfenster VOR s19 ist
     eingehalten (2/10 vor dem s19-Nachzug am Tip). A-1-Fixweg-Komponente 1 (7er-J-1 +
     4-Zellen-Kombibau am gemergten Endstand) bleibt beim Lande-Zug-K17-Gate — ENTWURF
     fix-runde-1.md §3 liegt dort vor, inkl. EXCLUDE_FROM_ALL-Warnhinweis.
R-12 fix-runde-1.md = 201 Zeilen (wc -l; §5-Nachtrag additiv unter den von mir am 22.08.
     gelesenen §1-§4, deren zitierte Passagen unveraendert stehen); Worktree-build/ existiert
     nicht (planmaessig entfernt, deckt die Slot-Abwaegung).
R-13 Kein Bau-Slot gezogen (Sichtung: 2 der 3 Slots belegt durch Fremd-Straenge). BEIDE Mengen
     unveraendert wie Abschnitt 4: gedeckt = Fix-Quittungen + statische Objekt-Anker +
     Format-Stand am byte-identischen Tip; NICHT gedeckt = frischer 7er-Treppen-/ctest-/
     4-Zellen-Lauf — dessen Traeger (Lande-Zug K17/H-7) ist per R-11 real und aktiv.

ERGEBNIS DER FUENFTEN MESSREIHE: Beide BEHOBEN-Quittungen (A-1, A-2) halten; 0 VERTAGT
(bestaetigt); der einzige offene Fixweg-Teil traegt einen benannten UND nachweislich aktiven
Traeger; Tip byte-identisch — keine Regressionsflaeche; Restliste gegen die Soll-Karte
unveraendert vollstaendig getragen (Abschnitt 5 gilt fort, R-11 verbessert die Lage: zwei
Lande-Zug-Posten bereits vollzogen). KEINE neuen Funde, keine neuen IDs.

Geschrieben in dieser Session NUR: dieser Abschnitt 8 (additiv) + das R-10-Log; Worktree/
Hauptklon/Ledger/Board/Memory/Vault/TABU-Zonen unberuehrt; /tmp-Hilfsdatei
/tmp/reverify2-mf-difffiles.txt (wegwerfbar).

VERDIKT (bestaetigt): **SITZT**.

--------------------------------------------------------------------------------

## 9. WIEDERANLAUF-RE-VERIFY 2 (23.08.2026 abends -- SECHSTE unabhaengige Messreihe, Schema-Ablieferung)

ANLASS: Der Orchestrator startete die RE-VERIFY-Stufe ERNEUT -- auch das Schema-Ergebnis des
ersten Wiederanlaufs (Abschnitt 8, R-Serie, 23.08. 14:03) hat ihn nie erreicht (dritter Fall der
Klasse "stummer Workflow-Tod" in dieser Schleife, nach Fix-R1-22.08. und RE-VERIFY-22.08.).
Wiederanlauf-Doktrin: NICHTS abgeschrieben -- alle folgenden Literale sind Messungen DIESER
Session (S-Serie), unabhaengig von M- (22.08.), W- (Fix-Wiederanlauf 23.08.) und R-Serie
(RE-VERIFY-Wiederanlauf 23.08. mittags).

S-1  `git worktree list`: /home/comdare/wt-ce-messfenster @ 3a746090 [bau/messfenster];
     `git ls-remote origin refs/heads/bau/messfenster` =
     `3a746090ae6abb95ae9c1bce498e1cf54d81f1f3` -- Ref-Sicherung steht unveraendert.
S-2  Worktree: `git rev-parse HEAD` = `3a746090ae6abb95ae9c1bce498e1cf54d81f1f3`; porcelain-
     Zeilen 0; `git rev-list --count 66de5c09..3a746090` = 1; Diff-Menge selbst hergeleitet:
     20 Dateien, 19 .hpp/.cpp, Nicht-Lint-Rest exakt tests/unit/CMakeLists.txt. Tip byte-
     identisch mit allen fuenf frueheren Messreihen -- KEINE neuen Commits durch irgendeine
     Wiederanlauf-Stufe.
S-3  Commit: Autor UND Committer "Claude Fable 5 <noreply@anthropic.com>"; Trailer-Zeile 34
     "Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>". Strang-Bericht: wc -l = 266;
     Alt-Literal "J-1 6 Werkzeuge rc=0" GENAU 2x (Z.186 + Z.254, grep -n); `grep -c
     'clang-format'` = 1; ASCII-Probe Z.193-213 `grep -n '[^ -~]'` rc=1 (0 Treffer).
S-4  Nachtrag-Raender selbst gesichtet (Read Z.189-216): Z.191-192 Alt-Ende ("KEIN
     Produktcode-Fix." + Leerzeile), Z.193 Kopf "#### NACHTRAG Fix-Stufe A2.5 R1", [A-1]
     Z.194-208 (Sechser-Liste als deklarierte REKONSTRUKTION + siebtes Werkzeug + all-Deckung +
     Lande-Zug-Verweis), [A-2] Z.209-213 (0/19-Eigenmessung + Log-Pfad + Lande-Zug-Mitfuehrung),
     Z.215 Alt-Abschnitt "### T-11c Wegwerf-Mutationen" unveraendert.
S-5  Bau-Graph komplett selbst nachgemessen (git grep/show @ 3a746090): alle SIEBEN Doktrin-
     Werkzeuge mit eigener add_executable-Definition -- apps/adhoc_emitter/CMakeLists.txt:7 ·
     apps/anatomy_codegen_tool/CMakeLists.txt:3 · apps/catalog_codegen_tool/CMakeLists.txt:3 ·
     tools/axis_registry_gen/CMakeLists.txt:27 (EXCLUDE_FROM_ALL) ·
     tools/measurement_axis_registry_gen/CMakeLists.txt:10 (EXCLUDE_FROM_ALL) ·
     tools/system_axis_registry_gen/CMakeLists.txt:10 (EXCLUDE_FROM_ALL) ·
     tools/overlay_source_hash_gen/CMakeLists.txt:44 (OHNE EXCLUDE_FROM_ALL; Kommentar-Kopf
     woertlich "NICHT EXCLUDE_FROM_ALL (anders als die Registry-Generatoren)");
     cmake/overlay_source_hash.cmake: `add_custom_target(comdare_overlay_source_hash ALL` +
     `COMMAND $<TARGET_FILE:comdare_overlay_source_hash_gen>` + `add_dependencies(...)` --
     die "doppelt zwingende" all-Deckung des siebten Werkzeugs (M-9/W-4/R-7) haelt.
S-6  Kern-Anker am Tip (git show, Zeile literal): mess_retry_klammer.hpp:56
     `std::uint32_t max_versuche = 5;` · drift_gated_cell.hpp:133 `std::uint32_t max_reruns
     = 3;` · build_orchestrator.hpp:113 `std::uint32_t bau_max_versuche = 5;` ·
     tests/unit/CMakeLists.txt-DATEIENDE (tail -14) = t15b-Block (add_test + COMDARE_TEST_
     TARGETS-Property + LABELS "t15b;c05;retry;warmup-paar;messfenster;standalone;koeder",
     kein 'pmc'-Substring).
S-7  Rekonstruktions-Quellen erneut selbst gelesen -- alle drei wortgleich DIESELBE Sechser-
     Liste (mit adhoc_emitter_cli, OHNE overlay_source_hash_gen): s19-simulation-ergebnis.md:
     229-231 ("Auftrags-Liste") · skip-oekonomie-97-ergebnis.md:104-106 ·
     traegerbau-s8-ergebnis.md:131-133 ("alle *_registry_gen am Objekt = genau diese 3").
S-8  EIGENER clang-format-22-Lauf (SECHSTER unabhaengiger; nur --dry-run -Werror, Worktree
     unberuehrt; Version "Ubuntu clang-format version 22.1.8 (++20260613092238+e80beda6e255-
     1~exp1~20260613092253.78)") ueber die 19 Dateien aus S-2:
     "REVERIFY-WIEDERANLAUF-2-BILANZ: 0 von 19 Dateien mit Abweichung"; Log ADDITIV
     persistiert: fmt-eigenmessung-reverify2-wiederanlauf23.log (die drei aelteren Logs
     unangetastet).
S-9  TRAEGER-REALITAET (deckt und aktualisiert R-11): `git merge-base --is-ancestor 3a746090
     53c5524e` = JA; Lande-Zweig lande/w2-s1s2 @ 53c5524e (lokaler Branch-Tip == wt-ce-lande-
     HEAD, seit R-11 unveraendert); Historie traegt ALLE ZEHN Merges (2/10 messfenster ...
     10/10 kampvor) PLUS `ed79090c fix(lande/w2-hygiene): F-14-Sichtung VOLLZOGEN` PLUS
     `53c5524e fix(lande/w2-s19): H-5/F-10-Nachzug 18->120er-Basis VOLLZOGEN` -- zwei der in
     Abschnitt 3 getragenen Posten am Traeger vollzogen (Betreff-Literale; die Lande-Strecke
     fuehrt ihre eigene Beweis-Kette). Lande-Reihenfolge messfenster VOR s19 eingehalten.
S-10 messfenster-Merge selbst bestaetigt: `61d5d139 merge(messfenster): W2-Lande-Zug 2/10 --
     T-15b Mess-Retry-Klammer + Warmup-Paar (bau/messfenster @ 3a746090; Audit r2 SITZT,
     0 neue Funde)` (Position 13 der Lande-Historie ab 53c5524e). A-1-Fixweg-Komponente 1
     (7er-J-1 + 4-Zellen-Kombibau am gemergten Endstand) bleibt beim Lande-Zug-K17-Gate --
     Traeger real und aktiv, ENTWURF fix-runde-1.md par.3 liegt dort vor.

ERGEBNIS DER SECHSTEN MESSREIHE: Beide BEHOBEN-Quittungen (A-1, A-2) halten erneut; 0 VERTAGT
(bestaetigt); der einzige offene Fixweg-Teil traegt einen benannten UND nachweislich aktiven
Traeger (S-9/S-10); Tip byte-identisch ueber alle sechs Messreihen -- keine Regressionsflaeche;
Restliste gegen die Soll-Karte unveraendert vollstaendig getragen (Abschnitt 5 gilt fort).
KEINE neuen Funde, keine neuen IDs.

Geschrieben in dieser Session NUR: dieser Abschnitt 9 (additiv) + das S-8-Log; Worktree/
Hauptklon/Ledger/Board/Memory/Vault/TABU-Zonen unberuehrt; clang-format ausschliesslich
--dry-run; kein Bau-Slot gezogen (byte-identischer Tip = kein neuer Bau-Gegenstand; Traeger des
frischen 7er-/4-Zellen-Laufs per S-9 real); /tmp-Hilfsdatei /tmp/reverify3-mf-difffiles.txt
(wegwerfbar).

VERDIKT (zweitbestaetigt): **SITZT**.
