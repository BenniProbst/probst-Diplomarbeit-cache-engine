########## F1-LENS FABLE — Funde ab 3 (Rest) ##########

--- Fund 3 ---
(b) Die 4 gehobenen Ratio-Fixtures (tests/test_05_diagram_generator_cached_fixtures.cpp): Log-Symmetrie-Test (3x1->3x2, Werte je Spalte identisch) -- EXPECT-Zeilen UNANGETASTET, Zahlen 0.3010/-0.3010/0.0000 identisch, Behauptung verifiziert. Entartung (1x1->2x2, alle 1.0) und Bestandsschutz (2x1->2x2) -- nur Korpus+Kommentar geaendert, Asserts unveraendert. ABER Fixture RatioMatrixTrueZeroNumeratorIsDisplayableButZeroDenominatorIsOmitted (:1483, 2x1->2x2 mit NEUER Spalte 100/50): Erwartungszahlen GEAENDERT: 0-Klasse -2.0000 -> -1.3010, NEU point meta min=-1.3010/max=1.3010, NEU (1,0,0.5000)[-0.3010]. Regelkonform nachgerechnet gegen die Implementierung (div_zero_meta=-(half+1), half=|log10(0.5)|=0.30103, have_ratio_zero -> Domaene +-1.3010; diagram_generator.cpp:417-448) -- die SEMANTIK (0-Klasse eine Dekade unter der halben Breite, symmetrische Domaene) ist dieselbe REGEL, die konkreten Zahlen sind es NICHT. Alle 8 Tests selbst gefahren: ctest rc=0; Stufe05 komplett: 51/51, rc=0.

--- Fund 4 ---
(c) BASH-WACHE am Objekt verifiziert (ci/anhang_forward_core.sh:289-299): EIGENE PROBE 'sh ci/anhang_forward_core.sh' -> rc=1 (literal), ALLE 3 FEHLER-Zeilen auf STDERR, stdout leer; POSIX-rein ([ -z ${BASH_VERSION:-} ], echo >&2, exit 1), steht VOR set -euo pipefail (:301) -- operativ bewiesen, denn dash ERREICHT die Wache (vor dem Fix Tod bei :288 rc=2, Beleg /tmp/f1_fix_lab/wache_rot_sh.log gegengelesen). bash -n rc=0; env -i bash laeuft DURCH die Wache bis 'FEHLER: AF_DEST_REPO fehlt' rc=1. ASCII: LC_ALL=C grep -nP Nicht-ASCII -> rc=1 (0 Treffer, ganze Datei). 120 Spalten: Wachen-Zeilen max. 101; die 3 Ueberlaengen :570/:572/:573 (126/133/127) existieren BYTE-GLEICH an der Basis 3ce69ed2 (:557/:559/:560), nur +13 verschoben -- NICHT von diesem Diff eingefuehrt. Kosmetik: rc-Wechsel 2->1 fuer sh-Fehlaufruf (kein Repo-Aufrufer unterscheidet das); zsh/ksh-Aufrufer bekommen die dash-benannte Meldung (fail-loud bleibt korrekt).

--- Fund 5 ---
(d) MANUAL_RUN.md:279-Nachzug KORREKT: ':1310ff' eingetragen, '(3b) PDF-GATE' steht literal in ci/anhang_forward_core.sh:1310 (selbst gegriffen); es ist der EINZIGE lebende Zeilen-Verweis auf den Kern ausserhalb datierter Ledger-/Sessions-/Plaene-Stellen (repo-weiter grep). CI-Aufrufstellen des Commit-Bodys literal bestaetigt: .gitlab-ci.yml:2454 test -x, :2501 Direktaufruf, Probe ci/tests/anhang_forward_probe.sh:288 'bash $KERN'. Einzige 'sh ci/...'-Fundstelle im Repo ist die Fehlermeldung der Wache selbst.

--- Fund 6 ---
(e) Commit-Body-Verschweigungen: (i) 915038ca verschweigt den Zahlenwechsel in Fixture RatioMatrixTrueZeroNumerator... (siehe Fund b) -- der Satz 'die Log-Symmetrie-Zahlen sind identisch' ist eng gelesen wahr (gilt fuer den Log-Symmetrie-Test), verdeckt aber, dass EIN gehobenes Fixture andere Erwartungszahlen + 2 neue Asserts bekam; (ii) Singular 'Der Messwert selbst ist im Korpus vorhanden' im degenerate_size_note des Nicht-Ratio-Aufrufers (diagram_generator.cpp:1066-1075) auch fuer 1xN/Nx1 mit N>1 gemessenen Werten (meine 1x3-Probe zeigt den Singular bei 3 Messwerten; Ratio-Pfad :1108-1123 sagt korrekt Plural, Default :155-160 'value(s)') -- kosmetisch; (iii) kein Hinweis, dass der Gegenkoeder-Bestand >2x2 nur indirekt (Ratio 3x2) gedeckt ist. POSITIV gegengeprueft, KEINE Verschweigung: Stufe05=51 gruen (eigener Lauf), T-1-Rot-Log existiert mit exakt den 3 benannten Tests (543/544/545), Regen-Nenner exakt 4 von 64 (regen_diff.txt/regen_liste.txt), surf-1x1-Zusage 'braucht keine Wache' ist objektbelegt, weil die 64er-Regeneration die lc_surface3d_*-Dateien aus der ECHTEN 1x1-Smoke-CSV enthielt und das PDF-Gate gruen war; Worktree sauber (git status nur Branch-Zeile).

--- Fund 7 ---
NICHT GEPRUEFT (Grenze dieses Lens): make check 403 Release+Debug nicht selbst wiederholt (nur Stufe05-51 + 8er-Subset), latexmk-PDF-Gate und Thesis-Klon-Regeneration nicht selbst gefahren (Beleg-Logs /tmp/f1_bau/, /tmp/f1_fix_lab/ stichprobenhaft gegengelesen), Byte-Parity der 60 unveraenderten .tex nicht selbst nachgerechnet.

########## F1-LENS FIX-STUFE ##########

[ENTLASTET] Fund 1: Landungsklassen-Pflicht (2 Lenses Code+Script)
BELEG: Prozessfeststellung ohne Defekt; Arbeitsdateien am Objekt geprueft: /tmp/f1_diff_full.patch (31854 B), /tmp/f1_diff_lensA_code.patch (29986 B), /tmp/f1_diff_lensB_script.patch (1868 B) existieren.

[ENTLASTET] Fund 2: Lens A a1 -- Wache deckt 1x1/1xN/Nx1 in beiden Modi, kein Umgehungspfad
BELEG: Mutant-Probe M1 belegt diagram_generator.cpp:330 als einzigen Entscheidungspunkt: unter 'nx != 2' faellt GENAU Surface2x3StaysRealFigure (52/53, /tmp/f1_fix2_mutant1_2x3.log), alle uebrigen gruen; regulaer ctest -L da_unit 405/405 Release UND Debug.

[ENTLASTET] Fund 3: Lens A a2/a3 -- Wachen-Position korrekt, kein NxM-Regressionsrisiko
BELEG: Stufe05 53/53 + da_unit 405/405 in Release UND Debug; echte NxM jetzt zusaetzlich direkt testfixiert (Surface2x3StaysRealFigure: mesh/cols=3, Eckwerte (0,1,100.0000)[2.0000] und (2,0,600.0000)[2.7782] verbatim).

[BEHOBEN] Fund 4: Lens A HINWEIS -- Kombination 'echte 0 + alle positiven Verhaeltnisse exakt 1.0' nicht mehr in EINEM Test
BELEG: Neuer Test RatioMatrixTrueZeroOnAllOnesWidensAxisThenPlacesZeroClassBelow (ff9a517b): 2x2-Korpus, 0-Klasse -2.0000, Domaene +-2 = exakt die Zahlen des alten 2x1-Korpus. T-1/Koeder: Mutant M2 (div_zero_meta aus UNGEWEITETER Breite) -> NUR dieser Test rot (52/53, /tmp/f1_fix2_mutant2_zeroclass.log), P2-t2/P2-t5 im Mutantenlauf gruen = beweisbar blind; Revert -> 53/53 Release+Debug rc=0.

[ENTLASTET] Fund 5: Lens B Gesamturteil (11 Befunde, alle HINWEIS)
BELEG: Kein tragender Mangel bestaetigt; Einzelposten abgeschlossen in Quittungen zu Fund 6 (i-iii), 7, 13a-c, 14 -- ein Teilfix in 8e9a31d2, Rest mit Messung entlastet.

[ENTLASTET] Fund 6(i): exportiertes BASH_VERSION koennte den Guard taeuschen
BELEG: Eigene Messung: bash -c 'export -p' enthaelt BASH_VERSION nicht (grep 0 Treffer, /tmp/f1_fix2_bash_exports.txt); Fehlermodus des Theoriefalls waere exakt der Vor-Fix-Zustand (rc=2 an set -o pipefail), kein neues Risiko.

[ENTLASTET] Fund 6(ii): /bin/sh=bash-im-POSIX-Modus wird korrekt durchgelassen
BELEG: Auf prod1 ist /bin/sh dash (readlink -f /bin/sh -> /usr/bin/dash), der Fall hat lokal keinen Traeger; Lens-Beleg (bash behaelt pipefail/Arrays/[[ ]] im POSIX-Modus) steht unwidersprochen; env -i bash laeuft durch die Wache bis 'FEHLER: AF_DEST_REPO fehlt' rc=1.

[ENTLASTET] Fund 6(iii): Dot-Sourcing aus Nicht-Bash beendet die aufrufende Shell
BELEG: Repo-grep: kein '.'/'source'-Aufrufer von anhang_forward_core.sh (0 Treffer, rc=1); Script ist als Programm dokumentiert, fail-loud bleibt der dokumentierte Vertrag.

[ENTLASTET] Fund 7: Lens B b3 -- kein CI-Aufrufweg bricht, +13 Zeilen, MANUAL_RUN nachgefuehrt
BELEG: Nach dem Fix erneut gemessen: wc -l ci/anhang_forward_core.sh = 1842 (konstant), '(3b) PDF-GATE' literal auf :1310, Shebang-Direktstart unberuehrt (env -i bash Durchlauf rc=1 erst am AF_DEST_REPO-Fehler).

[ENTLASTET] Fund 8: Pruefgrenze beider Lenses (bwrap-Blockade, Inline-Diff)
BELEG: Transparente Grenzfeststellung ohne Defekt; die dateiabhaengigen Kernaussagen wurden in dieser Fix-Stufe erneut am Objekt bestaetigt (Reads :140/:259-343/:417-448/:473-586; Mutant-Laeufe an :330 und :432/:436).

[ENTLASTET] Fund 9: Rahmen der Lens-Stufe eingehalten
BELEG: Auch in der Fix-Stufe eingehalten: Schreiben nur im Worktree (+ /tmp-Beleglogs wie in der Lens-Stufe), KEIN Push, /usr/bin/grep absolut; eine dash-rc-Messung hinter einer tail-Pipe wurde als K11-Fehler erkannt und sofort ohne Pipe wiederholt (dash rc=1).

[ENTLASTET] Fund 10: kein Falsch-Ausloeser der Wache; ragged-Matrix-Theoriefall
BELEG: Die CLI-Proben der Lens (2x3/3x2 echte Figur, 1x3 Platzhalter) sind jetzt dauerhaft testfixiert (Surface2x3StaysRealFigure gruen in 53/53 beider Konfigs); ragged hat keinen Repo-Erzeuger und war vor dem Fix gleichermassen latex-fatal -- keine echte Figur verlierbar.

[BEHOBEN] Fund 11: Gegenkoeder-Luecke Spalten>2 im Nicht-Ratio-Pfad (2x3)
BELEG: Test Surface2x3StaysRealFigure ergaenzt (ff9a517b). Koeder beisst: Mutant 'nx != 2' -> GENAU dieser Test rot, 52/53 (/tmp/f1_fix2_mutant1_2x3.log); Revert -> Stufe05 53/53 Release UND Debug rc=0 (/tmp/f1_fix2_gate_final_release.log, _debug.log).

[ENTLASTET] Fund 12: die 4 gehobenen Ratio-Fixtures (Zahlenwechsel regelkonform)
BELEG: Alle Fixtures in 53/53 beider Konfigurationen erneut gefahren (rc=0); der Erwartungszahlen-Wechsel des TrueZero-Fixtures ist jetzt im Commit-Body von ff9a517b aktenkundig (Nachtrag, siehe Fund 15-i).

[BEHOBEN] Fund 13a: Kosmetik -- zsh/ksh-Aufrufer bekamen die dash-benannte Meldung
BELEG: 8e9a31d2: Zeile 296 nennt das Erkennungskriterium ('Der Aufruf lief NICHT unter bash (BASH_VERSION leer -- z.B. sh/dash/zsh/ksh)') statt einer geratenen Shell. Proben rc OHNE Pipe: sh rc=1, dash rc=1, busybox sh rc=1 (alle 3 FEHLER-Zeilen auf stderr, stdout 0 Bytes); bash -n rc=0; Ein-Zeilen-Ersatz, neue Zeile 98 Spalten, ASCII-Wache ganze Datei 0 Treffer.

[ENTLASTET] Fund 13b: drei Ueberlaengen :570/:572/:573 (126/133/127)
BELEG: Byte-gleich an Basis 3ce69ed2 (Lens-Beleg :557/:559/:560, nur +13 verschoben); nach dem Fix per awk erneut gemessen: unveraendert die einzigen Zeilen >120 der Datei -- nicht von diesem Paket eingefuehrt.

[ENTLASTET] Fund 13c: rc-Wechsel 2->1 fuer sh-Fehlaufruf
BELEG: Dokumentierter Exit-Vertrag des Kerns ('EXIT: ... 1 = fail-loud', Kopfzeile :286); kein Repo-Aufrufer unterscheidet rc=2 von rc=1 (Repo-grep: einzige sh-Fundstelle war die Wachen-Meldung selbst).

[ENTLASTET] Fund 14: MANUAL_RUN.md:279-Nachzug ':1310ff' korrekt
BELEG: Nach 8e9a31d2 erneut gemessen: /usr/bin/grep -n '(3b) PDF-GATE' -> ci/anhang_forward_core.sh:1310; Zeilenzahl 1842 konstant -- der Verweis bleibt exakt.

[BEHOBEN] Fund 15(i): Commit-Body 915038ca verschweigt den Fixture-Zahlenwechsel
BELEG: Nachtrag literal im Body von ff9a517b (0-Klasse -2.0000 -> -1.3010, NEU point meta min/max +-1.3010, NEU (1,0,0.5000)[-0.3010], regelkonform zur unveraenderten Implementierung); bewusst KEIN Rewrite der uebergebenen Historie (nie rebase/amend).

[BEHOBEN] Fund 15(ii): Pauschal-Singular 'Der Messwert selbst ist' auch bei N>1 Messwerten (1xN/Nx1)
BELEG: ff9a517b: Vermerk zaehlt darstellbare Zellen mit exakt der Writer-Logik (heatmap_mask_matches + cell_displayable), Singular nur bei genau einem Messwert, de+en. T-1: neue Plural-Assertions ROT am Alt-Code (52/53; literal 'file_contains(out_row, "The measured values themselves are") Actual: false', /tmp/f1_fix2_rot_numerus.log), nach Fix GRUEN 53/53 Release+Debug rc=0.

[BEHOBEN] Fund 15(iii): Gegenkoeder-Bestand >2x2 nur indirekt gedeckt (Body-Luecke)
BELEG: Direkter 2x3-Bestandskoeder Surface2x3StaysRealFigure (siehe Fund 11) + explizite Benennung im Body von ff9a517b.

[BEHOBEN] Fund 16a: 403er-Kombigate von der Lens nicht wiederholt
BELEG: Offizieller Weg nachgefahren (ctest -L da_unit, identisch .gitlab-ci.yml:290): Release 405/405 rc=0 UND Debug 405/405 rc=0 (403 Bestand + 2 neue Tests; /tmp/f1_fix2_dagate_release.log, _debug.log).

[VERTAGT] Fund 16b: latexmk-PDF-Gate + Thesis-Klon-Regeneration nicht selbst gefahren
BELEG: Grund: das PDF-Gate ist das ALLES-ODER-NICHTS-Gate des anhang-Kerns im CI-Lauf (MANUAL_RUN.md:277-279, Kern :1310ff) und die Bau-Stufe hat es fuer exakt diesen Diff mit Logs belegt; ein lokaler latexmk-Lauf gehoert nicht zum Fix-Stufen-Gate. Platz: anhang:forward-Job des naechsten CI-Laufs der Welle (Landung) + neue_funde-Posten dieses Reports.

[ENTLASTET] Fund 16c: Byte-Parity der 60 unveraenderten .tex nicht nachgerechnet
BELEG: Eigene Messung: cmp ueber alle 64 Pfade aus /tmp/f1_bau/regen_liste.txt gegen /tmp/f1_art vs /tmp/f1_regen -> identisch=60 verschieden=4 fehlend=0; die 4 Differenzen sind exakt die 4 Dateien aus regen_diff.txt (lc_surface_ns_per_op + lc_surface_op_lookup_p50_ns, de+en).

neue_commit_shas: ['ff9a517bf74ce6668466ea023727f3acb663f51e', '8e9a31d234419e12315de5d2c00f193cad02eca9']
neuer Fund: N1 (VERTAGT, ce-Territorium): test_axis_registry_roundtrip ROT mit BYTE-DRIFT -- die committete ce-Registry-XML (Code/external/comdare-cache-engine/libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml) entspricht nicht der Reflektion des aktuellen ce-Codes (u.a. memory_layout_packed_bitmap neu). Ausserhalb des F1-Diffs (3 Dateien, nichts unter external/) und ausserhalb des offiziellen da_unit-Gates (Labels contract/registry/roundtrip). Nach 2-Pass-Werkzeugbau (comdare_*_registry_gen) wurden system- und measurement-Roundtrip gruen, der Achsen-Roundtrip bleibt Daten-Drift des ce-Submodulstands. Behebung = Generator-Lauf + XML-Commit IM ce-Repo; Platz: ce-Branch-Triage (Task #31).
neuer Fund: N2 (dokumentiert + testfixiert, Bestand seit P2): in der Konstellation 'alle positiven Verhaeltnisse exakt 1.0 + echte 0' faellt der 0-Klassen-Colorbar-Tick -2.0000 mit dem Dekaden-Tick -2 zusammen (Label '$0$' neben '$10^{-2}$'); schon der alte 2x1-Korpus an der Basis emittierte exakt diese Liste. Im neuen Test RatioMatrixTrueZeroOnAllOnesWidensAxisThenPlacesZeroClassBelow bewusst festgeschrieben und im Kommentar vermerkt -- ausser der 0 liegt dort kein Datum; moeglicher spaeterer Kosmetik-Posten (Tick-Dedupe), kein F1-Gegenstand.
neuer Fund: N3 (Gate-Beobachtung, J-1-Muster bestaetigt): blankes 'ctest' im build-test-Baum zaehlt 886 Tests mit 474 Not-Run (ce-Testregistrierungen ohne gebaute Binaries) und ist als Vollgruen-Gate ungeeignet; das offizielle Gate ist 'ctest -L da_unit' (.gitlab-ci.yml:290) bzw. make check. Die Roundtrip-Werkzeuge existieren erst nach explizitem 2-Pass-Bau (cmake --build --target comdare_axis_registry_gen ...).
neuer Fund: N4 (Arbeitsbeleg K11, transparent): die erste dash-Nachprobe mass rc hinter einer tail-Pipe (ergab faelschlich 0); ohne Pipe wiederholt -> dash rc=1. Bestaetigt die Rahmen-Regel 'rc ohne Pipe' als real beissende Falle.
