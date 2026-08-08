# GESAMT-WELLENPLAN BIS 15.09.2026 — ENDFASSUNG v2

**Architekt-Entscheid, Stand Sa 08.08.2026 abends.** Grundlage: die Endfassung v1 vom 08.08. (803 Zeilen, 369 SOLL-Posten, 211 IST-Prüfungen, 39 Regressionen, 46 Einwände), dazu **35 am Objekt geschärfte Defekt-Posten** (fünf Familien D1–D5, Summe ~76 h, jede Zahl heute gemessen) und **drei unabhängige Wellendesigns** (Frist zuerst / Risiko zuerst / Kette zuerst). Alle mit `LIVE` markierten Zahlen sind am 08.08. erhoben; Erhebungs-Referenz steht jeweils dabei.

**Ersetzt:** `wellenplan_endfassung.md` v1 (die deprecatet wird, nicht gelöscht) und transitiv deren Vorgänger (`20260803-FAHRPLAN-…`, `20260806-PLAN-…`, `20260806-FAHRPLAN-…`, `20260806-REGISTER-…`).

**Synthese-Entscheid, in zwei Sätzen:** Tragende Ordnung ist der Ketten-Entwurf („die Kette misst nur so wahr wie ihr schwächstes Glied"), weil er als einziger den bindenden Owner-KERN vom 08.08. (HYBRID = Gattung `HEURISTIK-ADAPTER`, „ALLES PFLICHT") nicht in die Streichliste schiebt und weil seine Reihenfolge — Waage → Nähte → Statistik-Glied → fehlendes Glied → einmal bauen → einmal messen — exakt die am Objekt gemessenen Abnahme-Abhängigkeiten der 35 Defekt-Posten abbildet. Aufgepfropft werden aus dem Frist-Entwurf die Defizit-Arithmetik, das Abgabefähigkeits-Minimum je Freitag und die Ein-Blech-Regel, aus dem Risiko-Entwurf der Durchstich (ein echter Mini-Messwert bis in den Thesis-Anhang am 14.08.), die Batch-Abend-Doktrin und das Sa-29.08.-Messfenster.

---

## 0. WAS DIESE FASSUNG GEGENÜBER DER VORLAGE ÄNDERT

**(1) Die Defekte rücken von hinten nach vorn.** Die Vorlage führte die Regressionen als Abschnitt 6 mit ~8 gebuchten Wachen-Defekten. Diese Fassung führt **35 Posten in fünf Familien** als Abschnitt 2, weil sie zwischen uns und jeder belastbaren Messung stehen. Neu hinzugekommen (in v1 unverbucht):

| neu | Kern | warum es die Vorlage verschiebt |
|---|---|---|
| **D1a** | `./configure.sh && make` baut **0 von 53** Permutations-DLLs (ninja-Ziele 6329→6749 erst nach 2. Configure) | der gemeldete Test-Zähl-Defekt ist ein **Produkt**-Defekt: `make install` liefert die Kern-Artefaktklasse nicht |
| **D1b/D1c** | CI `test:unit` fährt **429 von 431**; die Abdeckungs-Wache blieb **GRÜN gegen den korrekten 431-Baum** (`guard431.log`, gefahren) | die Vorlagen-Heilung ##06 (STATUS_OUT zählen) heilt das nachweislich **nicht** — die Wache prüft Selektor-, nie Registrierungs-Abdeckung |
| **D2-G1** | **27 gtest-Fälle in JEDEM Baum unsichtbar** seit 79 Tagen (`enable_testing()` bei `CMakeLists.txt:717` NACH `add_subdirectory(libs/cache_engine)` `:674`) — darunter die **Welch-Wachen** der Signifikanz-Aussage | fällt durch jede geplante Heilung hindurch: kein STATUS_OUT-Block existiert dafür |
| **D3-4/D3-5** | der **lebende** CEB-emittierte Mess-Weg hat **kein Ausgabe-Gate** und trägt `allow_failure: true` (`experiment_plan_director.hpp:1394`, 1 von 1 in der Datei); `[MESS-TESTAT]` wird **unbedingt** gedruckt, auch nach `[FEHLER-TESTAT]` | `allow_failure` kam in v1 + allen drei JSON-Beständen **0-mal** vor — größter unverbuchter Einzelbefund; v1 härtete nur den deprecateden statischen Weg |
| **D3-7/D3-8** | drei Treiber-Modi liefern planmäßig exit 0 ohne Messwert und hinterlassen **dieselbe Kopfzeilen-CSV** wie ein kaputter Lauf; `GIT_CLEAN_FLAGS -e Code/measure_out` lässt Altbestand über Pipeline-Grenzen leben | ohne Lauf-Marker und Frische-Kennung ist jedes Inhalts-Gate zu scharf **oder** zu stumpf |
| **D4a–D4f** | Welch (`se<=0` → `valid=true, p=1.0`), MWU (`valid` **vor** dem Guard), Bonferroni (ungetestete Hypothesen im Nenner, `win_rate` verdünnt), `success = !empty`, f15 ohne Tote-Proben-Guard, Break-Even „nicht bestimmbar" == „keiner" (byte-gleich leerer Vektor) | die **Headline-Zahl der Arbeit** kann heute durch nie gemessene Zellen kippen, ohne dass es der Zahl anzusehen ist |
| **D5-2–D5-5** | **fünf** Median-Implementierungen, **drei** Antworten auf {10,20,30,40} (20/25/30); Sieger-Kürung und LaTeX-Tabelle rechnen verschieden; `delete_p99_ns` existiert **0-mal**; HDR = sechstes Verfahren, unverdrahtet, verschluckt 0-ns-Proben | v1 führte den Median als Nebensatz und REV-DATA-12 als „zwei gelöschte Werkzeuge" — **beide leben in super**, letzter Commit 6d837e7d gestern (D5-3) |

**(2) Korrekturen an der Vorlage selbst** (v1 hätte, wörtlich gebaut, viermal die eigene Fehlerklasse erzeugt):

- **##26-Formel** „N == M" ist bei N==0 **grün mit Nenner 0** — korrigiert auf `N >= 1 UND M == N UND datenzeilen_gesamt >= 1` (V-1-Verstoß in der eigenen Abnahmezeile, v1:593 gegen v1:555).
- **##06-Formel** „für jeden der 5 STATUS_OUT ein FOUND" wäre ein **Dauer-Rot**: 2 der 5 Blöcke liegen hinter `if(COMDARE_PRUEFLING_INCLUDE_DIRS)` und werden in jedem CI-Baum **nicht erreicht** (weder FOUND noch SKIPPED). Korrigiert auf Bedingungs-Tabelle: erfüllt ODER Allowlist mit Begründung (D2-G4); zudem sind es **15 bedingte Registrierungen in 8 Klassen**, nicht 5 — STATUS_OUT deckt 20 %.
- **##36-Köder** kann den Zielfall nicht sehen: eine Null-Fenster-Zelle liefert im ungeheillten Gate `reruns=0` — exakt die Zahl, die laut Köder „nicht verdrahtet" bedeutet. Korrigiert auf **zwei degenerierte Zellarten** (Null-Fenster → „unbestimmbar", echte Streuung → Reruns), beide Zahlen getrennt.
- **##04/##05** waren Abnahmezeilen **ohne Bau-Paket** — die Vorlage verifizierte den `make check`-Defekt und heilte ihn nirgends. **V-6 gilt jetzt beidseitig** (Paket ohne Abnahmezeile UND Abnahmezeile ohne Paket = nicht abgenommen); D1/D1a schließen die Lücke.
- **##57**-Köder („Datensatz mit nur einer Binary") beißt aus dem falschen Grund und wäre auch nach einer Heilung grün — der Rückgabetyp kann „nicht bestimmbar" von „bestimmt: keiner" heute gar nicht unterscheiden (D4f); Abnahme auf den Statusraum umgestellt.
- **Einwand-36-Erklärung** („610 Tests = Folge von EXCLUDE_FROM_ALL") wird **nicht festgeschrieben**: super `Code/CMakeLists.txt:278 enable_testing()` steht ebenfalls NACH den `add_subdirectory`-Aufrufen (:211/:243) — dieselbe D2-G1-Konstellation; welche Ursache trägt, entscheidet die Messung in D1g, nicht der Plan.

**(3) HYBRID kehrt ins Fenster zurück.** v1 führte Hybrid-Bau als Streichkaskade Position 2 / W7. Der Owner-KERN 08.08. („Volles GO. Alles Pflicht.", Gattung `HEURISTIK-ADAPTER`, Genus `Function-Interface-Reroute`, 4. Mess-Ebene DAZWISCHEN) verbietet das. Der Widerspruch wird **zerlegt statt glattgerechnet**, entlang des älteren, als bindend markierten Owner-E1-Designs (`hybrid/README.md`: „kein eigener ABI-Schritt", „Erster Meilenstein = F8-Minimal-DoD, genau 1 Standard-Dock", Router = Break-Even-Router, der Messkurven **konsumiert**): **HY-A** (Struktur+Dock+Achse+Parser) in die Freeze-Woche, **HY-B** (Overhead-Messung mit Stub-Heuristik, eigene kleine Teilmatrix) in die Mess-Welle, **HY-C** (Router aus echten Kurven) in die Auswertung. **Preis, offen ausgewiesen:** der W2-S-E-Restbau (##40: T-06…T-14, W-03, W-08, A14, A10) fällt nach W7 (Abschnitt 7).

**(4) Reihenfolge-Umkehrungen:** W0a wächst von 0,5 auf **2,5 Tage** (13 statt 2 Pakete — V-6 erzwingt den ehrlichen Nenner); **D5-1** (Perzentil-Kanon) rückt aus W1 in die W0a-Lokalspur vor, weil er als einziger Posten den Messtermin bewegt; **D2-G4 vor D2** (Textkorrektur vor Wachen-Bau, sonst entsteht ein Dauer-Rot); **D1e vor D1b** (sonst macht die Heilung `test:unit` rot — `ninja -t query comdare_tests`: 424 Test-Inputs, `comdare_f15_compare_cli` fehlt); **D3-7 vor allen D3-Gates** (Modus-Marker zuerst). Neu: der **DURCHSTICH** — F1 (14.08.) liefert nicht mehr „Anschluss an beiden Enden", sondern **einen echten, frisch gemessenen Mini-Messwert als Tabellenzeile im Thesis-Submodul**, durch die komplette Kette CSV → persist → xlsx → `anhang:forward` → PDF.

**(5) Messfenster:** Zielbild **Sa 29.08. 06:00 – Do 03.09.** (5,75 Maschinentage, ETA-Deckel 4,5 Tage + 30 h Marge), Rückschrieb Fr 04.09. = F4; GO-Vorabzusage beim Owner (OV-15). Rückfall Mo 31.08. kostet 1:1 Fenster.

**(6) Zwei neue Betriebsregeln:** die **EIN-BLECH-REGEL** (prod1 ist Runner id=16 UND Arbeitsmaschine: maximal EIN Paket mit Pipeline-grün-Abnahme zur Zeit, der zweite Slot nur für rein lokale Abnahmen; während Bau und Kampagne exakt 1) und das **ABGABEFÄHIGKEITS-MINIMUM** (ab F1 existiert zu jedem Zeitpunkt eine ehrliche kleine Abgabe; jeder Freitag steht allein, auch wenn danach alles abbricht).

**Wellen-Nummern gegenüber v1 verschoben:**

| v1 | v2 | Inhalt v2 |
|---|---|---|
| W-1 | **W-1** | unverändert Landung + jetzt Bauweg-Heilung (D1/D1a/D1d) |
| W0a (0,5 T) | **W0a** (2,5 T) | Waage: D1/D2-Familien + D5-1-Lokalspur |
| W1 (10.–14.08.) | **W0b** (12.–14.08., F1) | Nähte + Durchstich (D3-Familie + Transport ##20–##25) |
| W2 (17.–21.08.) | **W1** (17.–21.08., F2 = Freeze) | Statistik-Glied (D4), Menge, §59-SCHEMA, HY-A, Entwicklung der Bump-Pakete |
| W3 (24.–28.08.) | **W2** (24.–28.08., F3) | EIN Bump-Bündel (Mo) → Anker/Kalibrierung (Di) → Bau (Mi–Do) → GO-Vorlage (Fr) |
| W4 | **W3-MESS** (Sa 29.08.–Fr 04.09., F4) | + HY-B |
| W5 | **W4-AUSWERTUNG** (07.–11.09., F5) | + HY-C |
| W6 | **W5-SICHERUNG** (12.–15.09.) | unverändert |

Die Paketnummern ##01–##62 der v1 bleiben gültig und werden weiterverwendet; D-Posten und HY-Posten kommen als eigene IDs dazu.

---

## 1. WO WIR STEHEN

Alle Zahlen heute (08.08.) erhoben, Messaufbau: ce-Worktree `/home/comdare/wt-ce-fk` auf `b2daf9a6`, `git status --porcelain` vor UND nach allen Messungen leer; Probe-Bäume außerhalb des Repos (`~/.claude/jobs/5a19728e/tmp/pass1-probe`, `pass1-only`; Logs `guard431.log` u. a.).

**Drei Nenner für dieselbe Behauptung „kein Test fehlgeschlagen":** Anwenderweg `make check` = **427**, CI `test:unit` = **429**, wahr = **431** (gemessen: 1 Configure → 427; + `comdare_anatomy_codegen_cli`/`comdare_profile_run_facade` + Reconfigure → 429; + `comdare_adhoc_emitter_cli` + Reconfigure → 431; die vier Namen per `comm -13`: `f15_compare_cli_smoke`, `test_v41_anatomy_adhoc_autobuilt_load`, `test_v41_anatomy_f15_measurement`, `test_v41_anatomy_r5i_configure_codegen`). Auf `origin/development` ist `check: inventar` bereits gelandet (v1-E-1) — aber `make` allein baut auch dort **0 von 53** Permutations-DLLs (kein zweites Configure in `all`), und die zwei `.gitlab-ci.yml`-Prebuild-Listen kennen den Emitter **0-mal** (`grep -c adhoc_emitter` = 0, Arbeitsbaum UND `origin/development`).

**Die Wache über den Zahlen ist literal blind:** `sh scripts/ci_test_coverage_guard.sh` gegen den **korrekten 431-Baum** gefahren → Exit 0, „BILANZ: 431 von 431 … GRÜN" (`guard431.log`). Sie prüft Selektor-Abdeckung (`-LE pmc`, Negativ-Selektor), nie Registrierungs-Abdeckung. Zusätzlich: **27 gtest-Fälle** (`test_commands` 20 + `test_engine_adapters` 7) sind seit dem 21.05. in **jedem** Baum unsichtbar — Binaries gebaut, Discovery gelaufen, keine `CTestTestfile.cmake` unterhalb `libs/` (12 von 1.226 Verzeichnissen tragen eine, keine unter `libs/`); darunter `WelchTTest.*` — das Verfahren, das „signifikant schneller" entscheidet. Ehrlicher Gesamtnenner heute: **428 ctest-Einträge lokal + 27 nie enumerierte Fälle = 455**.

**Der lebende Mess-Weg kann nicht rot werden:** der CEB-emittierte STUFE-3-Mess-Job liest `measure_out` an keiner Zeile zwischen `FAIL=0` (:1447) und `exit $FAIL` (:1528) und trägt das **einzige** `allow_failure: true` der Datei (:1394, Begründung ist Agent-Behauptung ohne Owner-Wort). Das statische Existenz-Gate akzeptiert reproduzierte Kopfzeilen- und 0-Byte-CSVs (rc=0, heute gefahren); `persist:measurements` zählt Dateien statt Zeilen und macht das Phantom unter „Messdaten nie löschen" **permanent**; der `anhang:forward`-Selektor (`*.result.csv`) trifft die Produktions-Ablage (`result.csv`) **nie** — die Muster sind disjunkt, nachgemessen.

**Die Statistik erklärt tote Reihen für gültig:** `welch_t_test.hpp:130-136` (se≤0 → t=0, p=1.0, `valid=true`), `mann_whitney_u_test.hpp:90/:92` (`valid=true` VOR dem Guard), `multi_compare.hpp:75/:83` (p=1.0 in die Bonferroni-Familie; `win_rate`-Nenner enthält Ungetestetes), `result_aggregator.hpp:86` (`success = !empty` — 32 Nullen = success), `drift_detector.hpp:69-72/:122/:128` (median≤0 → drift=0.0 = Minimum → der Rerun-Loop endet **bevorzugt auf der kaputten Gruppe** mit `stable=true`). Perzentile: **2** Definitionen, beide fälschlich „Nearest-Rank" benannt, in 4700/9998 Probefällen verschieden; A's p99 == max für n≤100 trifft 2 von 3 write-Checkpoints der Default-Konfiguration. Median: **5** Implementierungen, **3** Antworten (20/25/30 auf {10,20,30,40}); die Zahl der Sieger-Kürung ist bei geradem n eine andere als die in der LaTeX-Tabelle (`best_binary_selector.cpp:183-188` sagt es selbst: „REV-DATA-12 (offen)").

**Menge und Maschine:** `--check-size` und `<measure_selection>` = 0 Treffer (beide Repos); die einzige Rechnung für die Voll-Matrix: **~143 Tage einthreadig als Untergrenze** (0,1094 s ist doppelt als Untergrenze markiert, Spanne Faktor 69). Bau des Bestands: **128 × 19,4 min ≈ 41,4 h** auf prod1 allein. `getent hosts prod2` → rc 2, während `05_evaluation.tex:78-79` den Zwei-Maschinen-Betrieb im Präsens zusagt. prod1: `/` zu 83 % voll, 43 G frei, Runner id=16 auf derselben Platte, concurrent=2; jede Permutations-TU 523 MB MaxRSS.

**HYBRID:** Owner-KERN 08.08. „ALLES PFLICHT" — Bestand: `git ls-tree origin/development libs/cache_engine/hybrid/` = **genau `README.md`**.

**Fenster:** 27 Werktage + 11 Wochenendtage, **5 Freitage** (14.08. · 21.08. · 28.08. · 04.09. · 11.09.), Abgabe **Di 15.09.** Arbeitsbaum 29 Commits hinter `origin/development` → W-1 landet und erhebt neu.

**In einem Satz:** von der Kette **[PLANER] → [CEB] → [HYBRID] → [TIER]** trägt heute genau ein Glied (der TIER läuft); die Beweis-Maschinerie darüber lügt mit drei verschiedenen Nennern, das Statistik-Glied adelt tote Messreihen, das dritte Glied existiert als README — und die Abgabe verspricht im Präsens drei Dinge, die der Code nicht hält.

---

## 2. DIE FÜNF BLOCKIERENDEN DEFEKTE

Sie stehen zwischen uns und einer belastbaren Messung und gehören deshalb hierher, nicht in einen Regressions-Anhang. Je Familie: Kern, Posten-Tabelle (Aufwand in h, Ziel-Welle, Reihenfolge-Zwang), die tragenden Abnahmen. **Die vollständigen Bauschritte, Abnahmen und Köder je Posten sind Bestandteil dieses Plans** (im geschärften Posten-Bestand geführt, je Posten mit frisch gewürfeltem Köder nach K13); Abschnitt 6 bindet sie in den Verifikationsvertrag ein. Summe **35 Posten, ~76 h ≈ 9,5 Werktage Pflicht-Arbeit** — sie ist die Ehrlichkeit jeder Zahl der Abgabe und fällt als Letztes.

### D1 — Der Bauweg lügt über seinen eigenen Umfang (8 Posten, 19,5 h)

`make check` fährt 427 statt 431 (fehlendes Reconfigure; **zwei** Gate-Familien: `comdare_run_anatomy_codegen_tool` 4× UND die eigenständige 2-Pass-Maschine `comdare_run_adhoc_emitter`). Der Fix ist eine Makefile-Zeile — teuer sind die Geschwister.

| id | Kern (Beleg) | h | Welle | Zwang |
|---|---|---|---|---|
| D1 | Reconfigure in `check`; Zahlen 427/429/431 gemessen, beide Gate-Familien benannt | 3 | W-1 | mit D1a in EINEM Commit |
| D1a | `make` (all) baut **0/53** Permutations-DLLs — Produkt-Problem, `make install` unvollständig; 2-Pass-Bau ist hausübliche Praxis (`base-pipeline.yml:470-477`) | 2,5 | W-1 | nach D1, gleiche Datei |
| D1b | CI-Prebuild kennt `comdare_adhoc_emitter_cli` nicht → 2 von 431 Tests laufen in **keinem** Job (`.gitlab-ci.yml:637`) | 1,5 | W0a | **D1e ZWINGEND vorher** |
| D1c | Abdeckungs-Wache bleibt grün gegen die korrekte Inventur (`guard431.log`) → zweite Achse: Job-Baum-Inventur aus **fremdem** Artefakt, N≠M = rot; fail-closed | 5 | W0a | nach D1b, D1f |
| D1d | Doku-Widerspruch „404 statt 406" (Guard-Kopf) vs. „427 gegen 431" (super-Makefile) — der falsche Kommentar hat den unvollständigen CI-Job **erzeugt**; Zahlen künftig mit Datum+Kommando | 0,5 | W-1 | nach D1-Messung (K13) |
| D1e | `f15_compare_cli_smoke`: Binary nicht in der `comdare_tests`-Baukante (424 Inputs), `PASS_REGULAR_EXPRESSION` hängt den Exit-Code ab (11 Fehlerausgänge unsichtbar), Kommentar beschreibt einen anderen Test, kein TIMEOUT | 2 | W0a | vor D1b |
| D1f | 5 STATUS_OUT-Blöcke, **drei** Zustände (nicht-erreicht/SKIPPED/ERROR/FOUND); `message(WARNING)` bei rc≠0 = stiller ERROR-Pfad → FATAL, aber „nicht gebaut" im super-Sub-Build tolerierbar | 3 | W0a | nach D1 |
| D1g | super: Reconfigure vorhanden, aber strukturell wirkungslos (`EXCLUDE_FROM_ALL`, `Code/CMakeLists.txt:213`); 610/186 = ungemessene Agent-Behauptung → EIN Configure-Paar entscheidet; Nenner 186/610 in die Lauf-Ausgabe | 1,5 | W0a | nach D1 |

**Tragende Abnahme:** frischer Baum, baremetal: `./configure.sh && make && make check` druckt literal `… out of 431`; **vorher 427 protokolliert** (V-4); nach `make` allein: `find generated -name 'comdare_anatomy_perm_*.so' | wc -l` == 53 (heute 0, beide Zahlen). Köder (gewürfelt): `add_test`-Köder `qzoelw42uqoszpy` NUR im R5.G-Zweig + `g4nhmvh652vfr4a` im R5.I-Zweig — vor der Heilung unsichtbar-grün, danach rot mit Namen; beide Rot-Läufe ins Paket.

### D2 — Die Wachen zählen sich selbst (7 Posten, 11 h)

Nenner der Abdeckungs-Wache = eigene Inventur; keine Untergrenze (`:87` prüft nur `> 0`); der Partitions-Beleg druckt `==` statt zu vergleichen; `declared:VAR` fail-open; und eine ganze Testklasse (gtest via `gtest_discover_tests`, einzige Stelle im Repo, von `cmake/gtest_setup.cmake:56-82` selbst als unbrauchbar verworfen) liegt **außerhalb** des `ctest -N`-Wahrheitsbegriffs.

| id | Kern | h | Welle | Zwang |
|---|---|---|---|---|
| D2-G4 | **Textkorrektur der Abnahme ##06 VOR dem Bau**: 15 bedingte Registrierungen in 8 Klassen, davon 2 unerreichbar in jeder CI; Formel „erfüllt ODER Allowlist mit Begründung"; Zähl-Skript als unabhängige Quelle | 1 | W0a | zuerst |
| D2 | Nenner-Untergrenze (`ci_test_inventory_floor.txt`, eigener Commit), Emitter in die covguard-Prebuild-Zeile, Skip-Allowlist, Configure-Log als Artefakt (heute `paths: []`) | 3,5 | W0a | nach D2-G4 |
| D2-G1 | 27 unsichtbare gtest-Fälle → zwei `add_test` nach dem dokumentierten Muster, in `COMDARE_TEST_TARGETS`; Erstlauf ehrlich buchen (`AllFourteenAxesPopulated` bei heute 22/18 Achsen = erwarteter Fund, kein `allow_failure`) | 2 | W0a | parallel möglich |
| D2-G2 | ohne dieses Paket macht D2 die Hauptpipeline rot (Registrierung ohne Bau); TIMEOUT nach gemessener Zeit ×4; Exit-Code via `cmake -P`-Wrapper (Vorbild `registry_roundtrip.cmake`) | 1,5 | W0a | im D2-Bogen |
| D2-G3 | drei Grün-ohne-Vergleich-Wege: Untergrenze, `==`-Druck → echter Vergleich mit Exit, `2>/dev/null` fällt (K11: ctest-Ausgabe in Datei, dann rc), `declared:VAR` → gezählte „ungeprüfte Gates" | 1,5 | W0a | mit D2 |
| D2-G5 | 6 von 428 Tests registrieren sich nur auf AVX-512-Hosts → Host-Klassen-Bericht (3 Zahlen, Host-Kennung), zweistufige Untergrenze | 1 | W0b | nach D2/D2-G4 |
| D2-G6 | Registry-Roundtrip-Gates hängen an Datei-Existenz, Kommentar verspricht die stille Abschaltung als Merkmal → Pflicht-Erwartung + Kommentar korrigieren; **Standard-Bissprobe** der Wache (stash-Köder, billig, rückstellbar) | 0,5 | W0a | Anhang zu D2 |

**Tragende Abnahme:** die Wache druckt DREI unabhängige Zahlen (eigene Inventur N / Job-Baum-Inventur M aus dem Artefakt eines **anderen** Jobs / Gates FOUND G von G_deklariert), N≠M ⇒ Exit≠0; Zahl-Köder „345" im gefälschten Artefakt → rot; Schrumpf-Köder (N per `shuf` gewählte Tests in `if(FALSE)`) → rot mit Zahl; **unmanipulierter Lauf bleibt grün** (Gegenköder gegen Dauer-Rot). `ctest -N` zählt nach D2-G1 **+2** (heute 0 Treffer für `test_commands|test_engine_adapters`).

### D3 — Ein leeres Messfenster ist heute grün (8 Posten, 20 h)

Reproduziert: Kopfzeilen-CSV und 0-Byte-CSV bestehen das golden-320-Gate (rc=0). Die Kopfzeile ist Bauart (`trunc` + unbedingter Header vor dem ersten Pass). Der Autor kannte die richtige Form — einen Tag später, am Wegwerf-Objekt (WIDE-Aggregat), im selben Commit wie der Datei-Zähler des Rückschriebs.

| id | Kern | h | Welle | Zwang |
|---|---|---|---|---|
| D3-7 | **Wurzel zuerst:** Lauf-Marker neben jeder CSV (`modus/measured/resumed/provisioned/csv_ok`, aus denselben Feldern wie der stdout-Bericht); fehlender Marker = rot; auch `prune_only` schreibt einen | 3 | W0b | vor allen D3-Gates |
| D3-1 | `ci/measure_csv_gate.sh`: drei Zahlen (`csv_gesamt/csv_mit_datenzeile/datenzeilen_gesamt`), `awk` statt `wc -l`, N==0 = rot; rot NUR bei `modus=voll` und Z==0 | 3,5 | W0b | nach D3-7 |
| D3-2 | derselbe Helfer an der deprecateden smoke-Stelle (3 Zeilen); danach `grep -c 'test -n "$(find'` == 0 (heute 2) | 0,5 | W0b | nach D3-1 |
| D3-3 | persist zählt **Zeilen** statt Dateien; leeres Fenster = **KEIN Commit** (Beweis am Git-Zustand, nicht am Log); `datenzeilen_gesamt` in PROVENANCE; :1038-Warnung wird echter Abbruch | 2 | W0b | nach D3-1 |
| D3-4 | der **lebende** Mess-Job bekommt das Inhalts-Gate je Batch; `allow_failure` = Owner-Entscheid (OV-16), bis dahin maschinell findbare Klammer-Zeile; Emissionsblock ist byte-fixiert (Unit-Test-Literale) → Handarbeit | 5 | W0b | nach D3-1/D3-7; Owner bis Mi 12.08. |
| D3-5 | `[MESS-TESTAT]` in den else-Zweig (heute C+1 Testate bei C Zellen); Batch-Bilanz `A+B==C`; set-e-Sicherheit erhalten | 1,5 | W0b | im D3-4-Bogen |
| D3-6 | `anhang:forward`-Selektor findet **beide** Ablageformen (Produktions-`result.csv` + Archiv-`*.result.csv`, EIN Muster als Variable an 3 Stellen); NO-OP nur noch mit Nenner (`laufordner_geprueft/mit_material`) | 2,5 | W0b | Owner-Klärung Konvention (OV-17) |
| D3-8 | Frische-Wache gegen die `GIT_CLEAN_FLAGS`-Ausnahme: Lauf-Kennung = `CI_PIPELINE_ID` (+JOB_ID als Zusatz, Retry-fest); `csv_dieser_lauf` getrennt von `csv_gesamt`; Altbestand **gemeldet, nie gelöscht** | 2 | W0b | zuletzt; scharf mit `ergebnis:holen` (W2) |

**Tragende Abnahme:** Fake-Treiber-Doppel am emittierten Job-Rumpf (nur Kopfzeile vs. eine Datenzeile mit gewürfeltem `$K`): heute BEIDE `FAIL=0` — nach Heilung 1 rot / 1 grün, beide Ausgaben literal; persist-Beweis P1/P2 am Git-Zustand (`git status --porcelain measurement/` leer vs. genau eine Datei mit `$K`); Zwei-Lauf-Köder im selben Verzeichnis (Altzelle `$K1` mit Datenzeile, Neuzelle `$K2` leer) → rot mit `csv_dieser_lauf=0` und namentlicher Altbestandsliste — heute meldet das Existenz-Gate hier grün.

### D4 — Tote Messreihen gelten als gültig und nicht-signifikant (7 Posten, 12,5 h)

Die Klasse in einem Satz, fünffach belegt: die Null wird überall als **Divisions**-Gefahr gerettet und nirgends als **Daten**-Aussage behandelt (`drift_detector.hpp:69`, `welch_t_test.hpp:130`, `mann_whitney_u_test.hpp:92`, `multi_compare.hpp:75`, `f15_compare/main.cpp:486`); daneben steht jeweils ein ehrlich gebauter Rand-Guard (fehlende Daten ehrlich, tote Daten gutartig — das Suchmuster für weitere Geschwister). Die Heilungsform liegt im Repo: `mess_konsistenz_gate.hpp` (fail-closed per Default-Wert, benannte Fehlerklassen) — Übertragung, nicht Entwurf.

| id | Kern | h | Welle | Zwang |
|---|---|---|---|---|
| D4 | Drift-Gate: `median<=0 && n>=2` → `unstable=true` + `bestimmbar=false` (bool, kein Enum — Leser `:128` existiert); Rerun-Loop endet nicht mehr auf der kaputten Gruppe als „stabil"; Test `ZeroMedianGuard` wird im SELBEN Commit umgedreht | 2 | W2 | **nur zusammen mit T-15 (##36)** — allein = Scheinvollzug, T-15 allein = Blindheit einbauen |
| D4a | Welch: `degeneriert`-Flag bei se≤0 und bei nicht-finitem p; `valid` bleibt „gerechnet"; Export-Spalte | 1,5 | W1 | vor D4c |
| D4b | MWU: `valid=true` HINTER den Guard; cliff_delta nicht „negligible" über Nichts; Diskrepanz-Warnung nur bei beidseitig nicht-degeneriert | 1 | W1 | mit D4a |
| D4c | Bonferroni-Familie: m = **getestete** Hypothesen; `win_rate = X (Y von Z getestet, D degeneriert)`; Export erweitert | 3 | W1 | nach D4a/D4b |
| D4d | `success` = mindestens eine Probe > 0; `degeneriert` als **eigenes** Feld; **die eine CSV-Spaltenänderung der Woche**, danach Header-Freeze Stufe 2 | 1 | W1 | mit ##08-Freeze-Logik |
| D4e | f15: Tote-Proben-Guard + Summenzeile `A+B+C+D+gemessen==geladen`; Exit-Code für degeneriert; Muster auf die Zahlen-Zeile | 1,5 | W1 | nach ##07 (W0a) |
| D4f | Break-Even-Rückgabetyp mit Statusraum (`bestimmt/kein_schnittpunkt/kurve_ungueltig/kein_ueberlapp/zu_wenig_stuetzstellen`), fail-closed Default — **jetzt, solange 0 Konsumenten** | 2,5 | W1 | nach Break-Even-Definitionslage (OV-6) |
| **Summe inkl. D4** | | 12,5 | | |

**Tragende Abnahme:** Invarianz-Beweis — derselbe Datensatz mit und ohne degenerierte Kandidaten liefert **identische** `adjusted_p` für die echten (heute Faktor 9/7 daneben; ein gewürfelter Kandidat mit p_roh zwischen 0,05/9 und 0,05/7 kippt heute die Signifikanz); Welch-Köder {634×4} vs. {634×6} und der schärfere {746×4} vs. {634×6} (beide konstant, 15 % verschieden, heute „kein Unterschied"); f15-Köder: präparierte Null-DLL **gewinnt heute das Ranking mit p50=0** — nach Heilung ausgewiesen und Exit≠0.

### D5 — Sechs Perzentil-Verfahren, fünf Mediane, ein fehlendes Feld (5 Posten, 13 h)

| id | Kern | h | Welle | Zwang |
|---|---|---|---|---|
| D5-1 | **Perzentil-KANON**: beide Formeln tragen den Namen „Nearest-Rank" zu Unrecht; Lehrbuch-Formel `ceil(q*n)-1`; `nearest_rank_p` (34 unbewachte Stellen) wird **ersatzlos gelöscht** → jede übersehene Stelle bricht compile-time laut; Pin 51→50 mit Klartext-Commit „alle vorher erhobenen p50/p95/p99 ungültig". **Einziger Posten, der den Messtermin bewegt** | 6 | **W0a (Lokalspur)** | vor jedem ernsten Messwert |
| D5-2 | Median-Kanon = q=0.5-Fall; Sieger-Kürung, `csv_to_latex`, `diagram_generator` auf EINE Definition; `:1783/:1784` (Mediane ÜBER Konfigurationen) NICHT fälschlich umbauen; `eta_kalibrierung` begründet entscheiden | 3 | W1 | nach D5-1, nach D5-3 |
| D5-3 | **Vorlage-Korrektur:** REV-DATA-12 zeigt auf **lebende** super-Werkzeuge (`Code/04_csv_to_latex/`, `Code/05_diagram_generator/`, letzter Commit 6d837e7d, 07.08.); Disposition-Anker um 239 Zeilen gedriftet → korrigieren | 0,5 | W1 | vor D5-2 |
| D5-4 | `delete_p99_ns` existiert 0-mal → 9er-Feldliste als EINE Konstante, 5 Serialisierer auf den geteilten Helfer, Schema-Test in beide Richtungen (fehlend UND unerwartet) | 1,5 | W1 | mit D5-1-Flächen |
| D5-5 | HDR-Histogramm = sechstes Verfahren, unverdrahtet, gegen die falsche Referenz (1 %-Toleranz), verschluckt 0-ns-Proben still → entscheiden (entfernen ODER begründet führen), Toleranz aus `significant_figures=3` hergeleitet | 2 | W1 (rutschfähig W2) | nach D5-1 |

**Tragende Abnahme:** Wache druckt `Definitionen: 1` (heute 2); Zufalls-Seed-Test gegen zweitimplementierte Lehrbuch-Referenz (Seed gedruckt); Mutations-Köder (delta ±1 auf gewürfeltem Summanden, nur Testziel neu gebaut) → rc≠0, **vor der Heilung einmal rot gefahren**; Kreuz-Test gerader Länge über Selector/`csv_to_latex`/`diagram_generator` mit Bit-Gleichheit (Achtung: vendorierter ce-Stand in super zeigt auf alten Commit — der Kreuz-Test muss gegen den geheilten Stand prüfen, sonst grün und blind).

---

## 3. DAS WELLENSYSTEM

**Betriebsregeln über allen Wellen:** EIN-BLECH-REGEL (max. ein Pipeline-Abnahme-Paket zur Zeit; zweiter Slot nur lokal; Bau und Kampagne exklusiv). Jede Wellen-Abnahme trägt Nenner, Rot- UND Grün-Lauf mit frisch gewürfeltem Köder (K13); eine Welle ohne beißende Wache gilt als nicht abgenommen (V-6, jetzt beidseitig). Abgabefähigkeits-Minimum: jeder Freitag steht allein.

```
15.09. Di   ABGABE
11.09. Fr   F5  PDF final, Anhang gegen Nenner, P-1 3/3          <- LETZTE LIEFERUNG
04.09. Fr   F4  Kampagne gemessen + Rueckschrieb mit Substanz
28.08. Fr   F3  Bestand gebaut + USER-GO-VORLAGE                  <- danach NULL-Bump
21.08. Fr   F2  Statistik-Kanon + Menge rechenbar + HY-A          <- IDENTITAETS-FREEZE
14.08. Fr   F1  Nenner-Ehrlichkeit + DURCHSTICH (Messwert im Thesis-Submodul)
```

### W-1 — LANDUNG + BAUWEG-WAHRHEIT · Sa 08.08.–So 09.08. (Reserve-Entnahme 2 WE-Tage)

Posten: ##01 (Merge `origin/development`, nie rebase; 29→0, beide Zahlen), ##02 (A9-S4 landen: 6 Commits, 17 Dateien), ##03 (Diff-Neuerhebung, Erhebungs-SHA je Zeile), **D1+D1a+D1d in EINEM Commit-Bogen** (auf dem Landestand neu erhoben: `check: inventar` ist dort vermutlich Verifikation, `make`-allein = 0/53 DLLs bleibt Bau), ##04 (baremetal literal), ##05 (ctest -N vor/nach Reconfigure — jetzt MIT Bau-Paket).
**Parallelität 1** (jede Landung ändert die nächste Erhebung; Grün-Prüfung belegt den einzigen Runner). **Blockiert durch:** nichts.

### W0a — DIE WAAGE · Mo 10.08.–Mi 12.08. mittags (2,5 AT; v1 sagte 0,5 — real 14 Pakete)

Blech-Strang (seriell): **D2-G4 zuerst** (Text), **D1e → D1b** (Reihenfolge zwingend), D1f, D1c (Vollausbau; Floor-Variante nur als benannte Rückfallstufe), D1g (Configure-Paar entscheidet die super-Frage), D2, D2-G2 (im D2-Bogen), D2-G3, D2-G6, ##06 (korrigierte Formel), ##07. Lokalspur: **D2-G1** (27 Fälle sichtbar + Erstlauf), **D5-1** (Perzentil-Kanon — vorgezogen, damit ab Mi 12.08. jede Zahl kanonisch ist).
**Parallelität 2**, festgemacht an: CI-Verdikt-Pakete teilen den EINEN Runner-Strang seriell; gtest-Sichtbarmachung, Textkorrekturen und D5-1 sind rein lokal (Header + 34 Aufrufer + ctest lokal).
**Blockiert durch:** W-1 (alle Zeilennummern gegen Landestand, K10).

### W0b — DIE NÄHTE + DURCHSTICH · Mi 12.08. mittags–Fr 14.08. = **F1**; Nachlauf ##27–##31 bis Di 18.08.

Kern-Kette: **##08 zuerst** (`lazy_csv_header` EINMAL — Spaltenvertrag, Header = Resume-Schlüssel; Schema-Freeze Stufe 1), **D3-7 → D3-1 → D3-2 → D3-3 → D3-4+D3-5 → D3-8**, D2-G5, ##26 (korrigierte Formel). Transport: **##20+D3-6 als EIN Paket** (AF_GENERATOR belegen UND Selektor trifft beide Layouts — einzeln geheilt bleibt der einzige Transport zu), ##21, ##22, ##23 (NAHT, eigener Besitzer), **##25 DURCHSTICH** (frischer Mini-Lauf, 1 Binary, 1 Perm, Minuten). Nachrangig: ##24 (A9-S5a — fällt zuerst bei Riss), F-13. Nachlauf bis Di 18.08.: ##27–##30, ##31 (Wachen-Register: Grundmenge = alle `.sh` beider Repos + verdiktdruckende Jobs **+ ctest-Tests mit `PASS_REGULAR_EXPRESSION`** — neue Klasse aus dem D4-Querbefund; Köder GEFAHREN; Rückfallstufe bei Riss: manuell versioniert + die je D-Posten gefahrenen Köder-Protokolle).
**F1-Lieferung:** kein Glied kann mehr still leer sein, UND ein am Mittwoch frisch gemessener Mini-Messwert liegt am Freitag als Tabellenzeile im Thesis-Submodul (Kette: Lauf-Marker → Inhalts-Gate → persist-Commit → xlsx im Realm-Baum → `anhang:forward` → PDF baut; jede Stufe druckt ihren Nenner).
**Parallelität 2:** Helfer/Unit-Köder lokal; nur die CI-Beweisläufe seriell.
**Blockiert durch:** W0a; Owner-Entscheide OV-16 (allow_failure) und OV-17 (result.csv-Konvention) bis Mi 12.08.

### W1 — STATISTIK-GLIED + MENGE + HY-A · Mo 17.08.–Fr 21.08. = **F2 = IDENTITÄTS-FREEZE**

Statistik: **D4a → D4b → D4c** (Reihenfolge zwingend, D4c ist vorher blind), **D4d** (die EINE Spaltenänderung der Woche, danach Header-Freeze Stufe 2), D4e (nach ##07), D4f (nach OV-6-Lage), D5-3 → D5-2, D5-4, D5-5. Menge: ##10+##10b (`--check-size`, zwei Zahlenreihen + EIN gemessener Punkt bei working_set 8.388.608), ##11 (`<measure_selection>`), ##12, ##13 (G3-Split), ##14 (**Sperrlisten-Wache = Freeze-Gate**, maschinell aus `kAnatomyFingerprintGliedCount = 9`), ##15 (§59-SCHEMA als hartes W3-MESS-Vor-Gate; EMITTER/TEMPLATE bei Slack), ##16+##17 (nach OV-1), ##19, ##09 (nachrangig). **HY-A1–A3** (nach OV-13-Bestätigung + OV-12 + 4.-Ebenen-Entscheid Mi 19.08.): Gattung `HEURISTIK-ADAPTER`/Genus `Function-Interface-Reroute` — `hybrid_dock_contract` + `hybrid_pruef_dock` + factory/array (CT-Interface-Vererbung, `variant` NUR im DockSlot), `hybrid_binary_proxy` + `hybrid_tier_module.cpp` (4 ABI-Pflicht-Symbole) = **F8-Minimal-DoD** (genau 1 Standard-Dock, ctest-bewiesen, Reroute auf 2 plain-Tier-Ziele), `<hybrid_tier>`-Parser + Heuristik-Hybrid-Achse in die Registry (22→23, beide Zahlen) + Fehlerklassen. Abgabe-Vorlauf: ##42, ##43, ##44, ##45. **Entwicklung** (nicht Landung) der W2-Landepakete: ##32, ##33, ##35, ##36 (T-15+D4), ##37, ##38, ##39. **An F2:** OV-4-Deckel-Vorlage MIT beiden `--check-size`-Zahlenreihen beim Owner.
**Sa 22./So 23.08. = benannte Entnahme-Option NUR für HY-A-Fertigstellung.**
**Parallelität 2:** Statistik-Header + HY-A sind rein lokal (CT); Mengen-/CI-Pakete bündeln ihre Beweisläufe seriell.
**Blockiert durch:** W0b (F1); OV-13/OV-12 (Owner); OV-1/OV-6 für ##16/##17/D4f.

### W2 — EIN BUMP, ANKER, BAU · Mo 24.08.–Fr 28.08. = **F3**

**Mo:** das EINE Lande-Ereignis — Bump-Bündel ##32+##33+**##34** (genau EIN Magic-Wechsel 4→5 im Gesamtfenster, **HY-Ebenen-Entscheid eingerechnet** — bei „hybrid-lokal" bleibt HY außerhalb des Stempels; nach dem Bündel-Tag gilt **NULL-Bump-Wache** bis zur Abgabe), ##35 (Resume-Beweis: Abbruch nach 2 Batches, Neustart überspringt), **##36 = T-15 verdrahten MIT D4 als Schritt 1** (nie eines ohne das andere; Rerun-Deckel gesetzt, Rerun-Rate wird im Kalibrierlauf erhoben), ##37, ##38 (klein), ##39, ##41. **Di:** ##46 (Anker + TP1-FINAL, drei Spiegel), ##47 (Kalibrierlauf `GN_TOTAL=64` — **fährt durch alle W0b-Gates**, erster Ernstfall der Messweg-Ehrlichkeit; Menge unabhängig per Teilbaum-Auszählung, Einwand 29), ##48 (§66 G1–G5 + **Platten-Budget: benötigt_GB und frei_GB BEIDE gedruckt VOR dem Trigger** — 43 G frei bei 83 %), ##41b (gefahrene Kaskade Parent/Child/Grandchild mit Job-IDs — und dank D3-4 kann der Grandchild jetzt **rot** werden, sonst ist die Kaskade kein Beleg). **Mi 26.08. 06:00:** ##49 Bau-Trigger (~41,4 h = 128 × 19,4 min; **KIPP-PUNKT**: spätester tolerierbarer Start Fr 28.08. 06:00, danach fällt das W4-Fangnetz — steht dann als Zahl im Protokoll). **Do abends:** Bau fertig, ##50 Zweitlauf (`built_new==0`, `lager_skip==N`, `skip_ohne_testlog==0`). **Fr:** ##51 USER-GO-VORLAGE (EINE Datei: 320er + gedeckelte Teilmatrix via `<measure_selection>` MIT Zahlen, HY-B-Teilmatrix daneben, prod2-Entscheid eingearbeitet) = **F3**. `ergebnis:holen` wird scharf (D3-8 steht seit W0b).
**Parallelität 1** (strikte Kette; während des Bau-Fensters 0 CI-/Agenten-Last auf prod1, Thesis-Text nur via Overleaf-Remote).
**Blockiert durch:** W1 vollständig (Freeze steht, Sperrlisten-Wache grün); OV-2/OV-3 (Null-Bump-Umfang/4. Ebene); W0b-Nachlauf abgenommen (sonst kalibriert ##47 über ungehärteten Gates).

### W3-MESS — DIE KAMPAGNE · Sa 29.08. 06:00–Do 03.09.; Rückschrieb Fr 04.09. = **F4** · USER-GO-STOPP davor

##52 (Vor-Gate §59-SCHEMA + **zwei getrennte GOs**), ##53 (320er zuerst, dann gedeckelte Teilmatrix; **je Batch am Abend entschieden**: Bilanz `A+B==C`, Inhalts-Gate mit Marker, Frische `csv_dieser_lauf>=1` — ein Fehllauf wird am Abend seines Tages sichtbar und via Resume geheilt, nicht am 07.09. entdeckt), **HY-B** (Hybrid-Overhead-Kampagne: Stub-Heuristik am Hybrid-Prüfdock, Reroute-Overhead zu multiplen Tier-Zielen, eigene kleine Teilmatrix — die 4. Mess-Ebene liefert ihre Pflicht-Zahlen), ##54 (Auswertung NUR in Batch-Pausen, §61), ##55 (L3-Asymmetrie prod1-eigen: 2×128 MiB CCD, braucht kein prod2), ##56 (Rückschrieb WRITE-Token/NAS/minio inkl. xlsx; Commit nur bei `datenzeilen_gesamt>=1`, Zahl in PROVENANCE). ETA-Deckel 4,5 Maschinentage + 30 h Marge; **Sa 05./So 06.09. = benannter Resume-Puffer** (Entnahme wird gebucht).
**Parallelität 1** (Messung hält das Blech exklusiv — fremde Last kontaminiert Latenzen, und kontaminierte Daten sind die unheilbare Klasse; menschliche Textspur via Overleaf).
**Blockiert durch:** W2 (F3); **beide GOs bis Sa 29.08. 06:00** (OV-15; jeder Verzugstag frisst 1:1 Fenster).

### W4-AUSWERTUNG — ZAHLEN + TEXT + HY-C · Mo 07.09.–Mi 09.09. Kern; Do 10./Fr 11.09. Fangnetz; Fr 11.09. = **F5**

##57 (Break-Even auf dem D4f-Typ: „kein Break-Even bestimmbar" ≠ „bestimmt: keiner", zwei verschiedene Ausgaben — heute byte-gleich; Umfang gemäß OV-1/OV-6), **HY-C** (`hybrid_router` als Break-Even-CoR aus den HY-B/W3-Kurven + `hybrid_eviction`-Minimalstrategie + EIN belegter Routing-Fall im Text; Köder: nirgends kreuzende Kurven → `kein_schnittpunkt` + Rückfall auf direkten Tier-Aufbau, ungültige Kurve → `kurve_ungueltig`), ##58+##58b (Anhang-Wache: 28 `\InputIfFileExists`-Ziele gegen wirklich gefundene Dateien, beide Zahlen; `\thesisfinal` macht Ersatztext zum LaTeX-Fehler; `|| echo honest-empty` fällt ersatzlos), ##59 (FF0–FF4, Nenner 5, leere Frage = rot), ##60 (Ergebniskapitel C5: Zahlen ins ##44-Gerüst, jede Tabelle mit Lauf-Provenance; DE führt, EN zieht für berührte Kapitel nach), ##61 (Backups sofort), **P-1** (Präsens-Zusagen-Wache: `geprueft 3 / erfuellt-oder-korrigiert 3` — Zwei-Maschinen KORRIGIERT per OV-5, Resume ERFÜLLT per ##35, Konformität ERFÜLLT per perm_runner/OV-8).
**Parallelität 2** (Auswertung und Text dateidisjunkt; keine Bau-Abnahmen mehr auf dem Blech). Fangnetz Do/Fr: Auswertungs-Verzug ODER Teil-Nachmessung via Resume (max. 2 Tage + WE 12./13. als letzte Entnahme).
**Blockiert durch:** W3-MESS (mindestens die 320er-Abgabemessung; HY-C konsumiert die HY-B-Kurven — deshalb stand der Router nie in W1).

### W5-SICHERUNG · Sa 12.09.–Di 15.09. (Abgabe Di)

##62: PDF aus sauberem Checkout (`-halt-on-error`, Warnings ≤ 1, `.blg` alphadin), Anhang **gegen Nenner** belegt, DE/EN der berührten Teile konsistent, Spiegel GitHub/GitLab synchron, Overleaf-Identität, Desktop-Backup, Abgabe-Logistik Di VOR Dienstschluss. **Keine Bau-Eingriffe.**

### W7 — NACH DER ABGABE (Behälter)

§75-Aufräumpass (104 offen) · ##40-Restbau (T-06…T-14, W-03, W-08, A14, A10) · HY-Vollausbau (Heuristik-Familie, Mehrfach-Aufbau, scharfe Eviction, Paper-gekoppelte Heuristikwahl) · `checkpoint_measure` (OV-2b bestätigt) · Record-and-Replay · Paper-Kopplung (OV-14) · prod2-Lane/pmc:intel/P-E-Trennung · D1c-Ausbau falls Floor-Rückfall gezogen wurde · B-Spline (je nach OV-1) · Voll-Messung als Kampagnen-Programm · PV-1 · Doku-Anker-Sanierung.

---

## 4. DIE SEQUENTIELLE AUFGABENKETTE

Für EINE Instanz, ohne Rücksprung lesbar. `[R]` = Reserve-Entnahme. `[lok]` = rein lokale Abnahme (zweiter Slot erlaubt), `[CI]` = Pipeline-Abnahme (Ein-Blech-Regel: seriell).

```
=== W-1  Sa 08.08. - So 09.08.  [R: 2 WE-Tage] ==================================
 01  [CI]  Merge origin/development (29 -> 0, beide Zahlen). Landestand-SHA.
 02  [CI]  A9-S4 landen (6 Commits, 17 Dateien; Pipeline gruen).
 03  [lok] Diff A.1-A.5 NEU erheben, Erhebungs-SHA je Zeile.
 D1+D1a+D1d [CI, EIN Commit]  Reconfigure in check UND all; 427->431; 0->53 DLLs;
     Guard-Kopf '404 statt 406' korrigiert; Koeder-Rotlaeufe protokolliert.
 04  [lok] baremetal './configure.sh && make && make check' literal: 'out of 431'.
 05  [lok] ctest -N vor/nach Reconfigure: 427/431 + Differenz + 4 Namen.

=== W0a  Mo 10.08. - Mi 12.08. mittags ==========================================
 D2-G4 [lok] Abnahmetext ##06 korrigieren (erfuellt ODER Allowlist) VOR jedem Bau.
 D1e  [CI]  f15-CLI: Baukante + cmake-P-Wrapper (Exit zaehlt) + TIMEOUT gemessen.
 D1b  [CI]  Prebuild-Liste + Emitter: test:unit 429 -> 431, Job-ID + Gate-Zeile.
 D1f  [lok] 5 STATUS_OUT / 3 Zustaende; ERROR-Pfad FATAL (super-Kontext SKIPPED ok).
 D2   [CI]  Untergrenze (floor.txt) + covguard-Prebuild + Allowlist + Log-Artefakt.
 D2-G2[CI]  im D2-Bogen (sonst faellt test:unit rot).
 D2-G3[lok] '==' wird Vergleich; 2>/dev/null faellt (K11: Datei statt Pipe);
            declared:VAR zaehlt ungeprueft.
 D2-G6[lok] Registry-Gates Pflicht-Erwartung; Stash-Koeder = Standard-Bissprobe.
 D1c  [CI]  Wache Vollausbau: 3 Zahlen (eigen/Job-Artefakt/Gates), N!=M rot,
            fail-closed; Zahl-Koeder 345 rot. [Rueckfall bei Riss: Floor-Variante]
 D1g  [lok] super-Configure-Paar: 610er-Frage MESSEN (EXCLUDE_FROM_ALL vs.
            enable_testing-Reihenfolge), Ergebnis in den Makefile-Kommentar.
 D2-G1[lok] 27 gtest-Faelle sichtbar (2 add_test statt discover); Erstlauf ehrlich
            gebucht; rote Faelle = Befund, KEIN allow_failure.
 D5-1 [lok] PERZENTIL-KANON: Lehrbuch-Formel; nearest_rank_p GELOESCHT (34 Stellen
            brechen laut); Pin 51->50; Seed-Test + Mutations-Koeder rot gefahren.
 06/07[CI]  Vorlagen-Pakete in korrigierter Form.

=== W0b  Mi 12.08. mittags - Fr 14.08. (F1); Nachlauf bis Di 18.08. =============
 08   [lok] lazy_csv_header EINMAL (B-3). SCHEMA-FREEZE STUFE 1.
 D3-7 [lok] Lauf-Marker neben jeder CSV; fehlt = rot; prune_only schreibt einen.
 D3-1 [lok] ci/measure_csv_gate.sh: 3 Zahlen, awk, N==0 rot, Marker-Auswertung.
 D3-2 [lok] smoke-Stelle auf denselben Helfer (danach grep 'test -n "$(find' == 0).
 D3-3 [CI]  persist: Zeilen statt Dateien; leer = KEIN Commit (Git-Zustand-Beweis).
 D3-4+D3-5 [lok+1 CI-Beleg] lebender Mess-Job: Inhalts-Gate je Batch; Testat-XOR;
            Bilanz A+B==C; allow_failure gemaess OV-16; Byte-Determinismus-Tests
            im selben Commit.
 D3-8 [lok] Frische-Kennung (PIPELINE_ID); Altbestand gemeldet, nie geloescht.
 D2-G5[lok] Host-Klassen-Bericht (6 AVX-Registrierungen, 3 Zahlen immer gedruckt).
 20+D3-6 [CI, EIN Paket] anhang:forward: AF_GENERATOR belegt UND Selektor findet
            BEIDE Layouts; NO-OP nur mit Nenner. P1/P2/P3 gefahren.
 21   [CI]  Realm-Wurzeln /mnt + G-E3 + COMDARE_BESTANDSLOG in beiden CI.
 22   [CI]  persist um *.xlsx; F-15 Schwere-Stufe.
 23   [lok] NAHT: echte Mess-CSV -> xlsx im Realm-Baum; Zeilenzahl je Blatt gegen
            Eingangs-CSV; SKIP-Zweitlauf geschrieben==0/uebersprungen==N.
 25   [CI]  DURCHSTICH: Mini-Lauf (1 Binary, 1 Perm) -> Marker -> Gate -> persist
            -> xlsx -> anhang:forward-Commit im Thesis-Submodul -> PDF baut.  = F1
 24   [lok, nachrangig] A9-S5a gegen 06.06.-Archiv.       F-13 [CI] super-Wache.
 27-31[CI, Nachlauf bis Di 18.08.] Diff-Wache/Allowlist/lint/parity/REGISTER
            (Grundmenge inkl. PASS_REGULAR_EXPRESSION-Tests; Koeder GEFAHREN).

=== W1  Mo 17.08. - Fr 21.08. (F2 = FREEZE) =====================================
 D4a->D4b->D4c [lok] Degenerations-Kette; Invarianz-Beweis 7-vs-9.
 D4d  [lok] success-Schaerfung = EINZIGE Spaltenaenderung der Woche. FREEZE ST. 2.
 D4e  [lok] f15-Summenzeile + Exit; Muster auf Zahlen-Zeile.
 D5-3 [lok] Vorlage-/Dispositions-Korrektur (lebende Werkzeuge, Anker 653-659).
 D5-2 [lok] Median-Kanon ueber ce+super (Kreuz-Test gerade Laenge, Seed gedruckt).
 D5-4 [lok] delete_p99_ns + EIN geteilter Helfer + Schema-Test beidseitig.
 D5-5 [lok] HDR entscheiden (0-ns-Zaehler, Toleranz hergeleitet). [rutschfaehig]
 10+10b [lok+1 Lauf] --check-size: 2 Zahlenreihen + Messpunkt working_set 8388608.
 11   [lok] <measure_selection>: Schema+XSD+Validator+Teilmengen-Garantie.
 12   [lok] configure --enable-X=no; 5 XMLs wohlgeformt (2 generiert).
 13   [CI]  G3 aus dem STATISTICS-Gate (7. Feld mess_gates_glied).
 14   [CI]  Sperrlisten-Wache maschinell (9 Glieder; 10. Glied -> rot). FREEZE-GATE.
 15   [lok] §59-SCHEMA golden-neutral (EMITTER/TEMPLATE nur bei Slack).
 16+17[lok] Break-Even-Kanon + Serialisierung gemaess OV-1.
 D4f  [lok] Break-Even-Statustyp (falls OV-6 Definition steht; sonst Typ-Vorbereitung).
 19   [lok] LaTeX-Auswertungs-Emitter.       09 [lok, nachrangig] amd_l3-Teil.
 HY-A1[lok] Dock-Contract/Pruefdock/Factory/Array (CT, variant nur im DockSlot).
 HY-A2[lok] F8-MINIMAL-DoD: 1 Standard-Dock + Proxy + tier_module, ctest-bewiesen.
 HY-A3[lok] <hybrid_tier>-Parser + Achse in Registry (22->23) + Fehlerklassen.
 32/33/35/36/37/38/39 [lok] ENTWICKLUNG der W2-Landepakete (Landung erst Mo 24.).
 42/43/44/45 [lok] FF-Matrix anlegen, .ps1/.py-Abloesung, C5-Geruest, Thesis-Spur.
 Fr 21.08.: OV-4-VORLAGE mit beiden Zahlenreihen an den Owner. FREEZE.
 [R-Option: Sa 22./So 23. NUR HY-A]

=== W2  Mo 24.08. - Fr 28.08. (F3) — strikt seriell =============================
 Mo:  32+33+34 [CI] BUMP-BUENDEL: genau EIN Magic-Wechsel (HY-Ebene eingerechnet);
      danach NULL-BUMP-WACHE. 35 [CI] Resume-Beweis (Abbruch nach 2 Batches).
      36 [CI] T-15 verdrahtet MIT D4 (2 degenerierte Zellarten, getrennt gezaehlt;
      Rerun-Deckel). 37/38/39/41 [lok/CI klein].
 Di:  46 [lok] Anker 3 Spiegel. 47 [CI] Kalibrierlauf GN_TOTAL=64 DURCH die
      W0b-Gates; Menge unabhaengig ausgezaehlt; Rerun-Rate erhoben.
      48 [lok] §66 G1-G5 5/5 + Platten-Budget (benoetigt/frei BEIDE gedruckt).
      41b [CI] Kaskade Parent/Child/Grandchild, Job-IDs; Grandchild kann ROT.
 Mi 06:00: 49 BAU-TRIGGER (~41,4 h). 0 CI-/Agenten-Last. KIPP-PUNKT-Regel aktiv.
 Do abends: Bau fertig. 50 Zweitlauf (3 Zahlen, skip_ohne_testlog==0).
 Fr:  51 USER-GO-VORLAGE (EINE Datei, Deckel-Zahl, HY-B-Teilmatrix). = F3.
      ergebnis:holen scharf (Frische-Wache steht).

=== W3-MESS  Sa 29.08. 06:00 - Do 03.09.; Fr 04.09. Rueckschrieb (F4) ===========
 52  Vor-Gate §59-SCHEMA + zwei GOs (Datum im Protokoll).
 53  320er -> gedeckelte Teilmatrix. JE BATCH am Abend: A+B==C, Inhalts-Gate mit
     Marker (provision-only bleibt gruen), Frische csv_dieser_lauf>=1.
 HY-B Overhead-Teilmatrix (Stub-Heuristik, Reroute zu multiplen Zielen, n je Zelle,
     degeneriert-Zaehler im Report).
 54  Auswertung NUR in Batch-Pausen.   55  L3-Asymmetrie (prod1-CCDs).
 56  Rueckschrieb Fr 04.09.: WRITE-Token, NAS+minio, xlsx; Commit nur bei
     datenzeilen_gesamt>=1; PROVENANCE traegt die Zahl. = F4.
 [R-Option: Sa 05./So 06.09. Resume-Puffer]

=== W4-AUSWERTUNG  Mo 07.09. - Fr 11.09. (F5) ===================================
 57  Break-Even auf D4f-Statusraum (zwei verschiedene Antworten gedruckt).
 HY-C Router aus HY-B-Kurven + Eviction-Minimal + EIN belegter Routing-Fall.
 58+58b Anhang-Wache 28 Ziele beidseitig; thesisfinal; honest-empty faellt.
 59  FF0-FF4 (5/5, leere Frage rot).   60  C5-Zahlen ins Geruest, Provenance.
 61  Backups sofort.   P-1  Praesens-Wache 3/3. Do/Fr = Fangnetz. Fr = F5.

=== W5  Sa 12.09. - Di 15.09. ===================================================
 62  PDF sauberer Checkout; Anhang gegen Nenner; Spiegel; KEINE Bau-Eingriffe.
     ABGABE Di 15.09.
```

---

## 5. DER KRITISCHE PFAD

`##01 → ##02 → D1+D1a (W-1) → D2-G4 → D1e → D1b → D1f → D1c → D2+D2-G2 → D2-G1 → D5-1 (W0a) → ##08 → D3-7 → D3-1 → D3-3 → D3-4+D3-5 → ##20+D3-6 → ##23 → ##25 DURCHSTICH (F1) → D4a→D4b→D4c → D4d → ##10+##10b → ##11 → ##13 → ##14 → ##15 → HY-A1→A2→A3 (F2/FREEZE) → ##32/##33/##34 Bump-Bündel → ##35 → ##36 (T-15+D4) → ##46 → ##47 → ##48 → ##49 Bau 41,4 h → ##50 → ##51 (F3) → GO×2 → ##53+HY-B → ##56 (F4) → ##57/HY-C → ##58/##58b → ##59 → ##60+P-1 (F5) → ##62.`

**Die Rechnung.** Verfügbar: 27 Werktage + 11 WE-Tage. Der Pfad belegt: 2 WE-Tage (W-1) + 2,5 AT (W0a) + 2,5 AT (W0b) + 5 AT (W1) + 5 AT (W2, davon ~1,7 AT reine Bau-Wartezeit, in der nur Text/lokale Pakete laufen) + 5,75 Maschinentage Kampagne (davon 4 im WE/regulären Lauf ohne Personal-Bindung, Batch-Abnahmen abends) + 1 AT Rückschrieb + 3 AT Auswertung + 2 Fangnetz-Tage + 2 AT Sicherung ≈ **26 von 27 Werktagen**. Rest-Reserve: **1 Werktag + ~7 WE-Tage** (2 entnommen W-1, 2 Option HY-A, 2 Option Resume-Puffer).

**Die Defizit-Arithmetik (Planungsschätzung, als solche gekennzeichnet):** v1 verplante 26/27 WT ohne die Defekt-Familien. Die ~76 h Defekt-Pflicht (≈ 9,5 WT) plus HY-A/B/C im F8-Minimalschnitt (~3–4 AT, **Schätzung ohne Objekt-Basis**, An-10) werden gedeckt durch ~10–11 WT gestrichenes v1-Bauprogramm (##40-Restbau, prod2-Posten, F-07b, ggf. Break-Even-Neubau, ##15-EMITTER/TEMPLATE, Register-Vollautomation als Rückfallstufe). **Saldo ≈ 0 bis −1 WT.**

**Passt er?** **Nur unter vier Bedingungen**, und das ist die wichtigste Aussage dieses Dokuments: (1) der OV-4-Deckel fällt an F2 mit den ##10-Zahlen; (2) es gibt genau EINEN ABI-Bump (Mo 24.08.), danach null; (3) Messfehler werden je Batch am selben Abend sichtbar (W0b-Gates), sodass das Fangnetz einen TEIL-Nachlauf via Resume tragen kann; (4) beide GOs fallen bis Sa 29.08. 06:00. **Fällt eine der vier, reißt der Pfad.** Mit dem vollen v1-Programm PLUS Defekt-Pflicht PLUS HY läge das Ende rechnerisch **5–6 Werktage hinter dem 15.09.** — deshalb sind die Streichungen in Abschnitt 7 keine Kür, sondern die Rechnung. Der Bau-Start Mi 26.08. 06:00 ist der Kipp-Punkt: spätester tolerierbarer Start Fr 28.08. 06:00, dann fällt das W4-Fangnetz ersatzlos und wird als Zahl protokolliert, nicht als Hoffnung.

---

## 6. DER VERIFIKATIONSVERTRAG

Vier Formen von Schein-Grün sind belegt (übersprungener Job, Nenner 0, Köder der nie anschlug, Gate das nie aufging) — plus die in dieser Runde gemessene fünfte: **die Wache, die mit sich selbst einig ist** (`guard431.log`: „431 von 431 GRÜN" über dem eigenen Baum, blind für den Job-Baum). Der Vertrag schließt die Klasse aus.

**Vertragszeilen (V-1 bis V-5 unverändert aus v1; V-6 verschärft; V-7 neu):**

| # | Regel |
|---|---|
| V-1 NENNER | Jede Wache druckt ihre Grundmenge und prüft sie. Nenner 0 = Exit ≠ 0, nie GRÜN. |
| V-2 KÖDER BEIDSEITIG | Zufällig erzeugt (K13), Rot-Lauf VOR der Heilung protokolliert; Gegenköder: unmanipulierter Lauf bleibt grün (eine Wache, die immer rot ist, ist keine Wache). |
| V-3 GATE-VOLLZUG | Job-ID + Log-Zeile eines gefahrenen Laufs. YAML-Absicht zählt nicht. |
| V-4 DIFFERENZ-BELEG | Zwei Zustände, beide Zahlen ausgegeben — auch die vorher. |
| V-5 DUAL-WEG (§61) | CI und baremetal, beide literal. |
| **V-6 PLAN-NENNER, beidseitig** | Abnahme-Nenner = Paketzahl; Paket ohne Abnahmezeile **UND Abnahmezeile ohne Bau-Paket** = Welle nicht abgenommen (v1 verletzte die zweite Richtung bei ##04/##05). |
| **V-7 FREMDER NENNER** *(neu, aus D1c/D2)* | Eine Wache, die zwei Zahlen vergleicht, bezieht mindestens eine aus einer **anderen** Quelle als sich selbst (Job-Artefakt, committete Untergrenze, maschinelle Quell-Auszählung). Selbst-Inventur gegen Selbst-Selektor ist kein Vergleich. |

**Wachen-Register (##31):** Grundmenge = alle ausführbaren Dateien unter `ci/`+`scripts/` beider Repos + alle verdiktdruckenden CI-Jobs **+ alle ctest-Einträge mit `PASS_REGULAR_EXPRESSION`** (Wachen, deren Verdikt ein Textmuster ist — dort ist der Nenner am leichtesten zu fälschen; D4-Querbefund). Nenner nach D3-1: super `scripts/`+`ci/` = **6** `.sh`. Abgleich beidseitig rot; Köder werden vom Job GEFAHREN. Rückfallstufe bei Zeitriss: manuell versioniertes Register + die je D-Posten ohnehin gefahrenen Köder-Protokolle (deklarierte Grenze: neu entstehende Wachen machen dann nichts rot — W7-Posten).

**Je Welle (Nenner + tragende Zeilen; die vollständigen Abnahme-/Köder-Definitionen der D-Posten aus Abschnitt 2 sind Vertragsbestandteil):**

**W-1** (Nenner 6): ##01 `rev-list --count` 29→0, beide Zahlen · ##02 `diff --stat` 17→0 · D1/D1a: `make check` 427→431 literal, `make` allein 0→53 `.so` (6329→6749 ninja-Ziele), Doppel-Köder beider Gate-Familien vorher unsichtbar-grün/nachher rot · D1d: `grep -rn '404 statt 406'` = 0; jede verbleibende Kommentar-Zahl mit Datum+Kommando · ##04/##05 wie v1, jetzt erfüllbar.

**W0a** (Nenner 14): test:unit-Job druckt Job-ID + `out of 431` + `R5.G … ACTIVE (48 auto-gebaute DLLs)` (heute 429, beide Zahlen) · Wache druckt DREI Zahlen aus DREI Quellen (V-7), Zahl-Köder 345 → rot, Schrumpf-Köder N per `shuf` → rot mit N, Gegenköder grün · Bedingungs-Tabelle: `bedingte Registrierungen: 15 / ohne Allowlist-Eintrag: 0` (16. Köder-Bedingung hebt den Zähler maschinell) · D2-G1: `ctest -N` +2, Erstlauf-Ergebnis mit bestanden/gesamt gebucht · D2-G6-Stash-Köder: XML weg → rot mit Namen und `Inventur 426, Untergrenze 428, Differenz -2` · D5-1: `Definitionen: 1`, Pin 51→50, Mutations-Köder rc≠0 mit Seed · D1g: zwei `ctest -N`-Zahlen aus einem gefahrenen super-Configure-Paar, Ursache im Kommentar benannt.

**W0b** (Nenner 17 + 5 Nachlauf): D3-1-Proben P1 (Kopfzeile, `$K` im Pfad der Fehlerzeile) rot / P2 (eine Datenzeile `koeder_$K`) grün mit `datenzeilen_gesamt=1` / P3 (leer) rot mit `csv_gesamt=0` — heute P1/P3 grün, Vorher-Läufe protokolliert · ##26 in korrigierter Formel `N>=1 UND M==N UND Z>=1` · Marker: fehlend = rot, `provision_only` nicht fälschlich rot, gefälschter `modus=voll measured=0` rot · persist-Beweis am Git-Zustand · Testat-XOR: gewürfelte Fehl-Zelle → genau 1 `[FEHLER-TESTAT]`, C−1 `[MESS-TESTAT]`, Bilanz stimmt (heute C+1 Testate) · Frische-Zwei-Lauf-Köder · D3-6: P1 Produktions-Layout heute unsichtbar → danach im WIDE-Aggregat, P3 NO-OP mit `laufordner_geprueft=1 / mit_material=0` · ##23/##23b wie v1 (Zeilenzahl je Blatt gegen Eingangs-CSV; SKIP-Zweitlauf zwei Zahlen) · **##25 DURCHSTICH:** Submodul-Diff zeigt die Tabellenzeile mit dem gewürfelten Mini-Lauf-Token; PDF baut; jede Stufe hat ihren Nenner gedruckt.

**W1** (Nenner 26): D4-Invarianz (identische `adjusted_p` 7-vs-9; benannter Kipp-Kandidat) · `win_rate` nur noch mit Nenner-Klammer · f15-Summenzeile nachgerechnet, Exit≠0 bei degeneriert (rc direkt hinter dem Aufruf, K11) · D4d: Spaltenzahl vorher/nachher, Null-Vektor ≠ success, Gegenprobe (31 Nullen + 1 echter Wert) · ##10 zwei Zahlenreihen + ##10b ein gemessener Punkt bei 8.388.608 · ##11 Deckelung liefert kleinere Zahl; nicht deklarierte Perm = Fehlerklasse · ##13 `nm` auf benannte micro-Symbole, Stempel-Region ausgenommen (v1-##13 bleibt) · ##14 Preimage-Wache: 10. Glied → rot · HY-A: F8-DoD grün in ctest (Zahl vorher/nachher), Reroute-Roundtrip-Köder (gewürfeltes Token durch das Dock zu 2 plain-Zielen und zurück), nicht deklariertes Ziel bricht compile-time laut, Registry 22→23 · Kreuz-Test Median (Bit-Gleichheit, gerade Länge) · Fr 21.08.: OV-4-Vorlage liegt MIT Zahlen beim Owner.

**W2** (Nenner 12): ##34 `git log -p`-Filter aufs ABI-Magic = **genau EIN** Wechsel im Gesamtfenster, **NULL nach Mo 24.08.** (Commit-Zahl als Nenner gedruckt) · ##35 zwei Zahlen (Abbruch nach 2 Batches, Neustart überspringt; heute Start bei 0 = rot) · ##36 **zwei degenerierte Zellarten getrennt**: Null-Fenster → `MESSUNG DEGENERIERT … unbestimmbar` (kein Rerun), echte Streuung → `reruns: n`; `ZeroMedianGuard` im selben Commit umgedreht; Zensus-Zähler Produktion ≥ 1 mit Dateiname · ##47 ETA gegen unabhängige Teilbaum-Auszählung, Abweichung > 50 % = Abbruch; Kalibrierlauf passiert alle W0b-Gates (das IST der U-02-Vollzug) + erhobene Rerun-Rate · ##48 5/5 mit Nenner + `benoetigt_GB`/`frei_GB` beide gedruckt · ##50 drei Zahlen · ##41b drei Job-IDs + ein absichtlicher Zell-Fehlschlag färbt den Grandchild rot · ##51 EINE Datei.

**W3-MESS** (Nenner 7): ##53 `zellen_mit_echtem_messwert/zellen_gesamt` + Häufigkeit JEDES Ersatz-Tokens (Single-Source `measurement_curve_loader.hpp:72`), alle Zahlen im Log UND im Exit-Code; `nicht_gebaut > 0` = Abbruch vor der Auswertung („Zeilenzahl > 0" ist wertlos — der Bau-Fehler-Zweig schreibt formal vollständige CSVs); „echt" = D4d-Definition · Batch-Abende: Bilanz, Gate, Frische — je Batch protokolliert · HY-B: Overhead-Kurve je Zielanzahl mit n je Zelle; eine tote Reihe kann nicht mehr gewinnen (D4e-Nachweis) · ##56 Commit nur bei Substanz, PROVENANCE trägt die Zahl.

**W4/W5** (Nenner 8 + 1): ##57 zwei Läufe, zwei verschiedene Antworten (Status benannt — heute byte-gleich; der v1-Köder „eine Binary" ist als unzureichend vermerkt) · ##58 28 Soll gegen X gefunden, beide Zahlen · ##58b `\thesisfinal` macht Ersatztext zum Fehler, `|| echo honest-empty` gefallen · ##59 5/5 · P-1 `geprueft 3 / erfuellt-oder-korrigiert 3` · HY-C Köder beidseitig (kein Schnittpunkt vs. ungültige Kurve) · ##62 wie v1.

---

## 7. WAS FÄLLT — ausdrücklich, mit Kosten

| Posten | Entscheid | Kosten (ehrlich) |
|---|---|---|
| **##40 W2-S-E-Restbau** (T-06 KF-6/60, T-07 RAM-Spool, T-08 Dual-ccache, T-09, T-10, T-12 Cross-Genus, T-13/T-14 FK-Walk, W-03, W-08, A14, A10) | → W7. **Das ist der Preis des Owner-KERN Hybrid**: Bausteine ohne Konsument tragen keine Messung, ein fehlendes Kettenglied macht sie wertlos | ~10 gebaute Bausteine bleiben eine Abgabe-Periode länger ohne Konsument; Cacheline-/Spool-Achsen fehlen in der Messmatrix = kleinerer belegter Design-Raum; in der Thesis nur als „gebaute Infrastruktur mit deklarierter Grenze" zitierbar |
| **HY-Vollausbau** | nur F8-Minimalschnitt im Fenster (1 Standard-Dock, Stub-Heuristik, Router aus Kurven); Heuristik-Familie, Mehrfach-Aufbau, scharfe Eviction, Paper-gekoppelte Wahl → W7 | das Hybrid-Kapitel belegt Reroute-Overhead + EINEN Routing-Fall, nicht die Familie — aber ehrlich, statt das Pflicht-Glied ganz zu verschieben |
| **prod2/Intel-Lane** (S-05, U-06 pmc:intel, U-07, B-3-Spalte `cpu_core/cpu_atom`, D2-G5-Vollausbau) | Empfehlung OV-5(b): Textkorrektur; nur der 3-Zeilen-Host-Bericht (D2-G5) wird gebaut | drei Präsens-Zusagen der Evaluation werden zurückgenommen statt erfüllt (sichtbarer Schnitt mit Methodikgrenze); Vendor-Vergleich fällt ersatzlos; die Alternative (still mit einer Lane messen, Text behalten) wäre eine Falschaussage |
| **Voll-Messung** (524.288 Binaries, ≥143 Tage einthreadig Untergrenze) | fällt IMMER; genau EINE gedeckelte Kampagne (`<measure_selection>`, ETA ≤ 4,5 Maschinentage, Priorität = die in Kap. 5 zitierten Tabellen) | die Design-Raum-Aussage gilt für die begründete Teilmenge; Deckel + Auswahlregel versioniert und in der Methodik ausgewiesen — ehrlicher als eine still abgebrochene Vollmessung |
| **T-15/D4-Streichung (Frist-Entwurf)** | **abgelehnt** — Widerspruch entschieden: D4 ist ein Defekt (Owner-KERN „DEFEKT = IMMER BEHEBEN"), T-15 ohne D4 baut Blindheit ein, D4 ohne T-15 ist Scheinvollzug (Einwand 25); das Frist-Gift-Argument (Reruns unplanbar) wird durch Rerun-Deckel + im Kalibrierlauf erhobene Rerun-Rate entschärft | 0,5–1 AT mehr in W2; falls die Kalibrier-Rerun-Rate explodiert, wird die Drift-Schwelle VOR dem GO neu vorgelegt statt still gefahren |
| **NULL-Bump (Frist-Entwurf)** | **abgelehnt als Total-Streichung, übernommen als Wache**: EIN Bündel Mo 24.08., danach NULL-Wache | §59-Kette wird ganz statt halb (MERGE-STEMPEL ist im Ledger „OFFEN, kritisch"); Restrisiko: das Bündel selbst muss an einem Tag landen |
| F-07b Diagramm-Emitter | → W7 (Streichkaskade bestätigt) | Anhang trägt Tabellen, keine 2D/3D-Diagramme — Tabellen tragen die Aussage |
| `checkpoint_measure` (OV-2b bestätigt) | → W7 | fünfte Mess-Ebene bleibt spezifiziert; Text MUSS „vier gemessen (inkl. Hybrid-Ebene), fünfte spezifiziert" sagen (P-1-Klasse) |
| Paper-Kopplung (OV-14) | → W7 mit Klartext-Satz in Kap. 5 | die wissenschaftliche Frage „wären fremde Paper-Algorithmen je Achse besser" wird im Fenster nicht gemessen; der Owner-Auftrag („bauen, Rücksprache im Detail") wird als offener Posten mit Konsequenz übergeben, nicht still entsorgt |
| §75-Aufräumpass (104), Record-and-Replay, PV-1 | → W7; ab W0b nur Zuwachs-Stopp | Zähler bleiben hoch und sichtbar (ASCII 1160, Prosa 54, `organ_location` 97) |
| Break-Even-Neubau B=3 | gemäß OV-1; fällt die Definitions-Konsolidierung nicht bis F2, fällt Break-Even **ganz** aus den Ergebnissen | fehlende Leistung, keine Falschaussage (`kapitel/` = 0 Treffer „Break-Even"); D4f-Typ wird trotzdem gebaut |
| D4a-Vorzeichenfrage (p=1.0 vs. 0.0 bei se=0, mean_a≠mean_b) | NICHT im Code entschieden; nur `degeneriert=true` + Ausschluss aus der Familie | eine ehrlich benannte Methodik-Fußnote statt einer still geänderten Zahl |
| ##24 A9-S5a (Archiv-xlsx), ##15-EMITTER/TEMPLATE, D5-5 | nachrangig / rutschfähig — fallen zuerst bei lokalem Riss | kein Rückbeleg über den Alt-Korpus (der Fassung-3-Beweis hängt am frischen ##25 — der ohnehin allein etwas über die September-Kette aussagt) |
| ##31-Vollautomation, D1c-Vollausbau | gebaut; benannte **Rückfallstufen** (manuelles Register / Floor-Variante) nur bei Zeitriss, Entnahme wird gebucht | deklarierte Grenzen im Register, W7-Nacharbeit |
| EN-Nachzug | nur berührte Kapitel (Doktrin: DE führt) | EN zur Abgabe nicht vollsynchron; Bestand war es vorher auch nicht, es wächst nur nicht |
| measure:smoke-Wiederbelebung | fällt (bleibt deprecated; nur der 3-Zeilen-Helfer-Umbau D3-2) | keine — der lebende Weg ist der CEB-emittierte, und genau der wird gehärtet |
| **Streichkaskade bei globalem Zeitriss** (Reihenfolge jetzt festgelegt, nicht im Riss): 1. ##40-Reste/W7-Vorgriffe, 2. F-07b, 3. HY-C-Umfang (Router auf EINEN belegten Fall), 4. Break-Even-Neubau (dann Hermite ratifizieren MIT Methodik-Begründung), 5. ##41-Stufe-2. **NICHT streichbar:** die drei Präsens-Zusagen, HY-A/HY-B (Owner „Alles Pflicht"), D5-1+D4-Trio (sonst sind die Kennzahlen falsch gerechnet), die W0a/W0b-Wachen | | |

---

## 8. WAS BEIM OWNER LIEGT

Regel „ALLES IST GEPLANT": vorgelegt wird nur, was Recherche nicht auflösen konnte — je mit Recherche-Weg. Jede Frage in einem Satz beantwortbar.

| # | Frage (ein Satz) | Empfehlung | Frist |
|---|---|---|---|
| **OV-13 HYBRID** | Bestätigst du die Ketten-Zerlegung HY-A (Struktur/Dock/Achse/Parser, W1) / HY-B (Overhead-Messung mit Stub-Heuristik, W3-MESS) / HY-C (Break-Even-Router, W4) mit F8-Minimal-DoD als Pflichtkern und Vollausbau nach W7 — ja/nein? | **ja** — hält deinen KERN („Alles Pflicht") UND dein E1-Design („Router in der Auswertungsphase", „kein eigener ABI-Schritt") gleichzeitig; bei „nein, v1 gilt" entspannt sich W1 um ~4 Tage und ##40 kehrt zurück | **Mo 10.08.** |
| **OV-3 4. MESS-EBENE** | Wird die Hybrid-Macro-Schicht hybrid-LOKAL gebaut (nur in `hybrid_tier_module` einkompiliert, plain-Tier-Fingerprint unberührt, KEIN Bump) oder als neues Glied im globalen `mess_gates_glied` (7. Bump-Anspruchsteller, ALLE Binaries neu)? | **hybrid-lokal** — dein „dazwischengequetscht" lebt in der Ebenen-Nummerierung des Mess-BERICHTS, nicht im Stempel der plain Tiers | Mi 19.08., VOR ##34 |
| **OV-12 HYSTERESE** | Ist das Flattern des Schalters das SIGNAL für den Umschaltbereich (Bereichs-Erkennung) oder eine zu unterdrückende Störung (Hysterese-Band)? | **Bereichs-Erkennung** — ein Hysterese-Band unterdrückt exakt das Messobjekt der 4. Ebene; bis zum Entscheid wird keine Variante verdrahtet | Mo 17.08. abends |
| **OV-16 allow_failure** | Darf ich `allow_failure: true` vom CEB-emittierten Mess-Job entfernen, sodass ein Mess-Fehler die Pipeline rot färbt? | **ja** — die „Sichtbarkeits-Doktrin" im Code (`experiment_plan_director.hpp:1393`) ist Agent-Behauptung ohne auffindbares Owner-Wort und beruft sich auf eine CSV, die dort niemand liest | Mi 12.08. |
| **OV-17 result.csv** | Ist die Flach-Ablage `<stem>.result.csv` ein GEPLANTER Umbenenn-Schritt (dann bauen wir ihn) oder ein Archiv-Artefakt des handgefahrenen D-03-Erstbelegs (dann erweitere ich das Suchmuster auf beide Formen)? | **Archiv-Artefakt, Muster erweitern** — in ce und super existiert kein Flach-Schritt; ohne dein Wort ist die Heilungsrichtung geraten | Mi 12.08. |
| **OV-5 prod2** | Korrigieren wir `05_evaluation.tex:70-82` auf Ein-Maschinen-Betrieb (prod1/Zen 5) mit ausgewiesener Methodikgrenze — ja/nein? | **ja** — `getent hosts prod2` → rc 2, keine Beschaffung dokumentiert, der Cluster ist für mich read-only; eine mitten im Fenster erscheinende Maschine wäre selbst ein Messrisiko (keine Kalibrierhistorie, AVX-512-Nennerdifferenz D2-G5); der Entscheid JETZT spart pmc:intel/B-3/S-05/U-06/U-07 aus den Wochen 1–2 | jetzt, spätestens Fr 21.08. |
| **OV-4 MESS-DECKEL** | Gilt „Messmenge = größte Teilmenge mit ETA ≤ 4,5 Maschinentagen, Priorität = die in Kap. 5 zitierten Tabellen zuerst, versioniert als `<measure_selection>`, plus HY-B als eigene kleine Teilmatrix daneben" — ja/nein? | **ja** — die einzige Rechnung (≥143 Tage einthreadig, doppelt als Untergrenze markiert) schließt den Vollraum aus; die Deckel-Achse wählst du an der ##51-Vorlage | an F2 (21.08.), MIT beiden Zahlenreihen |
| **OV-1 BREAK-EVEN** | B=3-B-Spline im Fenster neu bauen (dein KERN-Wortlaut) ODER die gebaute monotone Hermite ratifizieren und die Methodenwahl in der Thesis begründen, B-Spline nach der Abgabe? | **Widerspruch der drei Entwürfe, offen vorgelegt:** Risikosicht sagt Hermite (neuer Numerik-Code, der erst in W4 an echten Daten geprüft würde = späte Fehlerklasse), dein KERN sagt B=3 — **dein Satz entscheidet, nicht meine Autonomie**; Zusatzregel in jedem Fall: steht die Definitions-Konsolidierung (drei Modelle) nicht bis F2, fällt Break-Even ganz aus den Ergebnissen (OV-6) | Mo 17.08. |
| **OV-6 BE-DEFINITION** | Fällt Break-Even ganz aus den Ergebnissen, falls die Definitions-Konsolidierung nicht bis 21.08. steht — ja? | **ja** — `kapitel/` hat 0 Treffer „Break-Even": fehlende Leistung, keine Falschaussage; D4f wird als Typ trotzdem gebaut | an F2 |
| **OV-10 CEB-VARIANTEN** | Teilmengen-Lesart (max. 4 erreichbar, Abnahme „4 + belegte Begründung warum nicht 6") — ja? | **ja** — echte 3!-Permutation wäre ein Gate-Modell-Umbau im Identitätsfenster mit Bump-Folge | vor ##32 |
| **OV-8 TREIBER** | Fährt ce `perm_runner` (Konformitäts-Gate scharf, `:196/:289`) den Voll-Lauf — ja? | **ja** — nur so bleibt `05_evaluation.tex:138` ohne Textänderung wahr; der super-Katalog-Treiber erst nach ##39 | vor W2 |
| **OV-14 PAPER-KOPPLUNG** | Bau nach der Abgabe, und der Satz „die Arbeit vergleicht Kompositionen, nicht Paper-Algorithmen je Achse" geht als Methodikgrenze in Kap. 5 — ja? | **ja** — dies IST die von dir geforderte Rücksprache im Detail (LEDGER:11128); stilles Einsortieren wäre der Fehler | Mo 17.08., sonst automatisch W7 |
| **OV-2 checkpoint_measure** | Bleibt es bei „spezifiziert, nicht gebaut" (W7)? | **ja** — ein Fingerprint-Bump ohne Konsument wäre die Klasse „gebaut, kein Konsument" im Identitätsfenster | vor Mo 24.08. |
| **OV-15 GO-TERMIN** | Können beide Mess-GOs (320er + gedeckelte Teilmatrix) bis **Sa 29.08. 06:00** fallen, wenn die GO-VORLAGE Fr 28.08. mit Deckel-Zahl vorliegt — ja? | **ja erbeten** — jeder Verzugstag frisst 1:1 Messfenster; ab Ende-W2-Verzug kippt die Rückwärtsrechnung und W4 entfällt als Auswertungsfenster | Vorab-Zusage an F3 |
| **OV-18 STREICHKASKADE** | Bestätigst du die neue Streich-Reihenfolge (Abschnitt 7, letzter Block) mit einem Satz? | ja erbeten — sie weicht von v1 ab, weil deren Position 2 (Hybrid) durch deinen KERN gefallen ist | Mo 17.08. |

*(OV-9/OV-11 der v1 sind in OV-5/OV-8 aufgegangen; OV-14-alt (RF-5, A5-Value-Filter) bleibt unverändert offen und wird an F2 mitvorgelegt.)*

---

## 9. RISIKEN GEGEN DEN 15.09.

**R-1 — Der lebende Messweg war bis heute unbeobachtbar (höchstes Risiko, jetzt adressiert).** `allow_failure: true` + kein Ausgabe-Gate + Kopfzeilen-CSV als Bauart + persistierte Phantome + blinder anhang-Selektor: der vollständige Phantom-Pfad war offen. Gegenmaßnahme: die D3-Kette (W0b) + der Durchstich (F1) beweisen die Kette am kleinen Objekt, BEVOR das große durch sie muss. **Restrisiko:** die ersten echten Rot-Läufe nach der Härtung sind Funde, keine Rückschläge — sie brauchen Budget (Batch-Abend-Doktrin + Resume + 30 h Marge), und `ergebnis:holen` wird erst mit stehender Frische-Wache scharf.

**R-2 — Menge/Anker (unverändert aus v1, verschärft).** Ohne ##10/##10b/##11 ist die Kampagne geraten; eine Mess-Achsen-Änderung nach Mi 26.08. 06:00 vernichtet 41 h Bau + Fenster. Gegenmaßnahme: Sperrlisten-Wache = Freeze-Gate (##14), EIN Bump-Bündel + NULL-Wache (##34), Kalibrierlauf gegen unabhängige Auszählung (##47). **Kipp-Punkt-Regel:** Bau-Start nach Fr 28.08. 06:00 = W4-Fangnetz fällt, als Zahl protokolliert.

**R-3 — Die drei Präsens-Zusagen (unverändert).** Zwei-Maschinen (`:78-79`), 4096er-Resume (`:139-140`), Konformität (`:138`). Gegenmaßnahme P-1 (Nenner 3): erfüllt bis F4 ODER korrigiert bis F5; ##35 erfüllt die zweite, OV-8 die dritte, OV-5 korrigiert die erste. Still fallenlassen macht die Abgabe unwahr — ein anderer Fehler als fehlende Leistung.

**R-4 — Statistik-Erstläufe können rot sein.** 27 Fälle liefen 79 Tage nicht (`AllFourteenAxesPopulated` bei heute 22/18 Achsen ist der offensichtliche Kandidat); die zwei nie gefahrenen R5.G-Tests können beim ersten echten Lauf rot sein; D5-1 dreht einen grünen Pin (51→50) bewusst um. Alles Funde, kein Grund zur Rücknahme — aber Zeit, die im W0a/W0b-Budget steht; mehr als zwei rote Fälle je Fläche = eigener Posten, nie `allow_failure`.

**R-5 — HY-Überlauf.** HY-A ist eine Planungsschätzung ohne Objekt-Basis (An-10); jeder Überlauftag frisst 1:1 die WE-Option 22./23.08. und danach W2-Fr-Puffer. Gegenmaßnahme: F8-Minimalschnitt ist bindend; HY-C ist Streichkaskade Rang 3 (auf EINEN belegten Fall reduzierbar); der 4.-Ebenen-Entscheid (OV-3) hält HY aus dem Bump heraus.

**R-6 — prod1-Platte/RAM.** `/` zu 83 % voll, 43 G frei, Runner auf derselben Platte, earlyoom; 53 Permutations-TUs à 523 MB MaxRSS (bei `-j6` ~3 GB, `-j16` ~8 GB Spitze). Gegenmaßnahme: BUILD_JOBS-Deckel dokumentiert (D1a), ##48 druckt `benoetigt_GB/frei_GB` VOR dem Trigger, Probe-Bäume nach Gegenlesen löschen, Lastfreiheit im Bau-/Messfenster angeordnet (An-7).

**R-7 — GO-Verzug.** Ohne beide GOs bis Sa 29.08. 06:00 schrumpft das Fenster 1:1; nach An-3 kippt ab Ende-W2-Verzug die gesamte Rückwärtsrechnung. Gegenmaßnahme: OV-15-Vorabzusage, EINE Vorlage (##51) mit allen Entscheiden.

**R-8 — Drift-Gate-Rerun-Rate unbekannt.** T-15+D4 verdrahtet erstmals Reruns in den Messweg. Gegenmaßnahme: Rerun-Deckel im Code, Rate im Kalibrierlauf (##47) erhoben; explodiert sie, wird die Schwelle VOR dem GO neu vorgelegt — nicht still gefahren, nicht still abgeschaltet.

**R-9 — Die Korrektur-Fassungen selbst.** Diese Fassung korrigiert vier v1-Abnahmeformeln; falsch korrigiert wäre die nächste Dauer-Rot- oder Dauer-Grün-Wache. Gegenmaßnahme: jede korrigierte Formel trägt einen Gegenköder (unmanipulierter Lauf grün) UND einen Biss-Beweis (V-2 beidseitig), beide gefahren vor Verlass.

---

## 10. ANNAHMEN (als Annahme benannt)

| # | Annahme | Status |
|---|---|---|
| An-2 | Mess-Dauer je Binary in der Größenordnung des Kalibrierlaufs | ungeprüft bis ##10b/##47; 0,1094 s ist doppelt als Untergrenze markiert, Bezugsgröße 16 Zeilen, Spanne Faktor 69 |
| An-3 | Beide GOs bis Sa 29.08. 06:00 (Rückfall Fr 28.08. als letzte Grenze der Rückwärtsrechnung) | Owner-abhängig (OV-15) |
| An-4 | `bau/a9-s4-mess-report` ist baubar | Zahl verifiziert (6/17/1940+), Bau nicht — deshalb ##02 mit eigener Abnahme |
| An-6 | Doku-Drift nicht abgabekritisch außer A9-Design Abschnitt 1 und der D5-3-Disposition | beide in W0b/W1 adressiert |
| An-7 | prod1 trägt während Bau- und Messfenster keine fremde Last | **angeordnet, nicht garantiert** — Runner auf derselben Platte |
| An-8 | Alder-Lake-Consumer-Silizium hat AVX-512 abgeschaltet (D2-G5-Folge: 424 statt 428 Tests auf prod2) | ungemessen, weil prod2 nicht existiert; wird bei Existenz mit EINEM Kommando erhoben |
| An-9 | super-Zahlen 610/186 | Agent-Behauptung aus dem super-Commit, **nicht nachgemessen** — D1g misst sie; die Erklärung (EXCLUDE_FROM_ALL vs. enable_testing-Reihenfolge) bleibt bis dahin offen |
| An-10 | HY-A-Aufwand ~3–4 AT im F8-Minimalschnitt | Planungsschätzung ohne Objekt-Basis (Bestand = 1 README); WE-Option 22./23.08. ist die Deckung |
| An-11 | `.test`-Template-Befunde gelten für den Live-Stand | erhoben am lokalen Klon `Cluster-ci-templates` (HEAD 5f9e04be, 27.07.), **nicht** am ref=development-Live-Stand |
| An-12 | Die defekt-1/2-CI-Aussagen (429 etc.) halten im echten Job | aus YAML + lokalem Nachbau der Job-Schritte, ohne Job-ID — nach V-3 erst mit den W0a-Läufen vollzogen |
| An-13 | Der Durchstich-Mini-Messwert ist mit D5-1-Kanon erhoben | gesichert durch die Reihenfolge W0a-Lokalspur vor ##25; ohne diese Reihenfolge wäre die erste Thesis-Zahl Ausschuss |

**An-1 bleibt gestrichen** (v1: als R-4/OV-5 hochgestuft).

---

## KURZFASSUNG IN ZEHN ZEILEN

1. **W-1 (WE):** landen, neu erheben, und den Bauweg heilen — `make check` 427→431, `make` 0→53 DLLs; v1 hatte dafür Abnahmezeilen ohne Bau-Paket.
2. **W0a (2,5 T):** die Waage — CI 429→431, die literal blinde Abdeckungs-Wache bekommt fremde Nenner (V-7), 27 unsichtbare gtest-Fälle (inkl. Welch) werden sichtbar, und der Perzentil-Kanon fällt VOR jeder Zahl.
3. **W0b (F1 14.08.):** kein Glied kann mehr still leer sein (Marker → Inhalts-Gate → persist → Frische), der lebende Mess-Job kann rot werden — und der **DURCHSTICH** legt einen echten Mini-Messwert bis in den Thesis-Anhang.
4. **W1 (F2 21.08. = FREEZE):** tote Reihen heißen nie wieder „gültig, nicht signifikant"; Menge wird rechenbar UND deckelbar; §59-SCHEMA; **HY-A** (Owner-KERN: Pflicht) im F8-Minimalschnitt; OV-4-Vorlage mit Zahlen.
5. **W2 (F3 28.08.):** EIN Bump-Bündel am Montag, danach NULL; Anker → Kalibrierlauf durch die neuen Gates → Bau 41,4 h ab Mi 06:00 (Kipp-Punkt) → Zweitlauf → USER-GO-VORLAGE.
6. **W3-MESS (F4 04.09.):** GO-Stopp; 320er → gedeckelte Teilmatrix + **HY-B**; jeder Batch wird am Abend seines Tages entschieden — heilbar via Resume statt unheilbar am 07.09.
7. **W4 (F5 11.09.):** Auswertung mit Nennern, **HY-C**-Router aus echten Kurven, Anhang gegen 28 Soll-Ziele, P-1 3/3. Do/Fr Fangnetz.
8. **W5:** PDF, Spiegel, Abgabe Di 15.09. Keine Bau-Eingriffe.
9. **Der Pfad füllt 26 von 27 Werktagen und passt NUR mit den Streichungen (##40→W7, prod2→Text, Vollmessung→Deckel) und den vier Bedingungen: Deckel an F2, ein Bump, Batch-Abend-Ehrlichkeit, GOs bis Sa 29.08. 06:00.** Ohne die Schnitte endet er 5–6 Werktage hinter der Frist — das ist die wichtigste Zahl dieses Dokuments.
10. **Über allem:** jede Wache mit fremdem Nenner und gefahrenem Köder (rot UND grün); jeder Freitag eine für sich stehende, ehrliche Lieferung; die drei Präsens-Zusagen erfüllt oder korrigiert — still fallenlassen macht die Abgabe unwahr.