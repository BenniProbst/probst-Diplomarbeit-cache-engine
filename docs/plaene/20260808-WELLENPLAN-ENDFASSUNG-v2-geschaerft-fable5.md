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
- **##06-Formel** „für jeden der 5 STATUS_OUT ein FOUND" wäre ein **Dauer-Rot**: 2 der 5 Blöcke (`_pa_status`, `_fj_status`) liegen hinter `if(COMDARE_PRUEFLING_INCLUDE_DIRS)` und werden in jedem CI-Baum **nicht erreicht** (weder FOUND noch SKIPPED) — **und sie registrieren überhaupt keinen Test**, sie bauen DLL-Targets. Korrigiert auf Bedingungs-Tabelle: erfüllt ODER Allowlist mit Begründung (D2-G4). Zur Menge: ~~15 bedingte Registrierungen in 8 Klassen~~ — **am Objekt sind es 18 bedingte Registrierungen unter 14 verschiedenen Bedingungs-Ausdrücken**; STATUS_OUT deckt davon **4 von 18** (22 %), nicht 20 %. **Warum die 15 falsch war** (09.08. mechanisch reproduziert): sie stammt aus einer Zählweise, die den Testnamen auf der `add_test(`-Zeile erwartet — die **drei** Registry-Roundtrip-Gates (`test_axis_registry_roundtrip`, `test_system_axis_registry_roundtrip`, `test_measurement_axis_registry_roundtrip`, ce `tests/unit/CMakeLists.txt:5009/5039/5054`) schreiben `NAME` auf die Folgezeile und waren für sie unsichtbar. 18 − 3 = 15. Blind war sie also ausgerechnet für die drei Registrierungen, deren stille Abschaltung Posten **D2-G6** als Defekt führt. Die 8 „Klassen" bleiben als *semantische* Gruppierung gültig (Prüfling · Codegen-Status · Codegen-Menge · TARGET-Existenz · Plattform · Compiler-Flag · Host-ISA · Messmodus), sind aber **nicht** die Zahl der Bedingungs-Ausdrücke. Alle Zahlen gemessen mit `scripts/ci_abnahme06_bedingungs_tabelle.sh`, identisch über **drei** ce-Stände (`wt-ce-xml 404ff6cf`, `wt-ce-fk`, vendoriertes ce `a1d0c201`).
- **##36-Köder** kann den Zielfall nicht sehen: eine Null-Fenster-Zelle liefert im ungeheillten Gate `reruns=0` — exakt die Zahl, die laut Köder „nicht verdrahtet" bedeutet. Korrigiert auf **zwei degenerierte Zellarten** (Null-Fenster → „unbestimmbar", echte Streuung → Reruns), beide Zahlen getrennt.
- **##04/##05** waren Abnahmezeilen **ohne Bau-Paket** — die Vorlage verifizierte den `make check`-Defekt und heilte ihn nirgends. **V-6 gilt jetzt beidseitig** (Paket ohne Abnahmezeile UND Abnahmezeile ohne Paket = nicht abgenommen); D1/D1a schließen die Lücke.
- **##57**-Köder („Datensatz mit nur einer Binary") beißt aus dem falschen Grund und wäre auch nach einer Heilung grün — der Rückgabetyp kann „nicht bestimmbar" von „bestimmt: keiner" heute gar nicht unterscheiden (D4f); Abnahme auf den Statusraum umgestellt.
- **##20-Vorschrift** ~~„`AF_GENERATOR` belegen, `|| true` beim `git add` fällt"~~ → **„`AF_GENERATOR` belegen (erledigt); das `git add` nennt statt Verzeichnissen die Buchführungsliste `$COPIED_LIST` dieses Laufes, `2>/dev/null` UND `|| true` fallen dabei beide, Ausgabe `im Index: N von M kopierten Datei(en)`, `N != M` = Abbruch"** — **RICHTIGSTELLUNG 10.08.2026 am Objekt, s. Fußnote ##20-B**. Wörtlich gebaut hätte v1 hier den Kanal rot gemacht (DE-only gegen ein Ziel ohne `anhang/en`: rc **128**); die Begründung des Kern-Explores („rc=128 bei *jedem* DE-only-Lauf", „stand *jahrelang* so") ist ihrerseits zu stark bzw. falsch — 289 trägt **18 von 18** je Sprache, und die Zeile ist vom **06.08.2026**. Der echte Defekt liegt daneben und ist reproduziert: bei jedem `git add`-Fehlschlag aus anderem Grund (gemessen: stale `index.lock`) meldet der Kanal `IDEMPOTENT: 0 Aenderungen`, **Exit 0**, und **0 von 2** Messwert-Dateien landen.
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

> ⚠️ **KORREKTUR-EINSCHUB 10.08.2026 — der letzte Halbsatz ist ÜBERHOLT; er bleibt stehen, weil
> der Bestand an Irrtümern selbst ein Datum ist.**
> Die Muster sind **nicht mehr disjunkt**. Am Objekt heute, eine Definition und drei Verwendungen:
> `ci/anhang_forward_core.sh:202` → `AF_RESULT_NAMEN="${AF_RESULT_NAMEN:-result.csv *.result.csv}"`
> — **beide** Formen. Gelandet mit `6d2e3dce` (09.08., „zwei Transportfallen im Anhang-Kanal, plus
> eine dritte"), in `origin/development`; der Kopf der Datei führt den alten Zustand als geheilte
> Falle F1 (`:41-45`) namentlich. Der Rest des Absatzes (`allow_failure`, Existenz-Gate,
> `persist:measurements`) ist an anderer Stelle bereits korrigiert. **Damit ist D3-6 erledigt** —
> Belege und Restposten in der Fußnote **F1-KERN** unten.

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
| D1b | ~~CI-Prebuild kennt `comdare_adhoc_emitter_cli` nicht → 2 von 431 Tests laufen in **keinem** Job (`.gitlab-ci.yml:637`)~~ → **STREICHEN, nicht bauen** (F1-Kern-Explore 10.08., s. Fußnote F1-KERN) | ~~1,5~~ **0** | — | **entfällt** |
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
| D2-G4 | **Textkorrektur der Abnahme ##06 VOR dem Bau**: ~~15 bedingte Registrierungen in 8 Klassen~~ → **18 bedingte Registrierungen unter 14 Bedingungs-Ausdrücken** (am Objekt 09.08. nachgezählt, s. Fußnote D2-G4); 2 der 5 STATUS_OUT-Blöcke in jeder CI unerreichbar **und ohne jede Test-Registrierung**; Formel „erfüllt ODER Allowlist mit Begründung"; Zähl-Skript als unabhängige Quelle | 1 | W0a | **ERLEDIGT 09.08.** (super `scripts/ci_abnahme06_bedingungs_tabelle.sh` + `ci/abnahme06_bedingungs_allowlist.txt` + korrigierte Formel in §6) |
| D2 | Nenner-Untergrenze (`ci_test_inventory_floor.txt`, eigener Commit), Emitter in die covguard-Prebuild-Zeile, Skip-Allowlist, Configure-Log als Artefakt (heute `paths: []`) | 3,5 | W0a | nach D2-G4 |
| D2-G1 | ~~27~~ **30** unsichtbare gtest-Fälle → zwei `add_test` nach dem dokumentierten Muster, in `COMDARE_TEST_TARGETS`; Erstlauf ehrlich buchen (`AllFourteenAxesPopulated` bei heute 22/18 Achsen = erwarteter Fund, kein `allow_failure`) | ~~2~~ **0** | — | **ERLEDIGT 10.08. mit `ce ca6d8af1`** (s. Fußnote F1-KERN) |
| D2-G2 | ohne dieses Paket macht D2 die Hauptpipeline rot (Registrierung ohne Bau); TIMEOUT nach gemessener Zeit ×4; Exit-Code via `cmake -P`-Wrapper (Vorbild `registry_roundtrip.cmake`) | 1,5 | W0a | im D2-Bogen |
| D2-G3 | drei Grün-ohne-Vergleich-Wege: Untergrenze, `==`-Druck → echter Vergleich mit Exit, `2>/dev/null` fällt (K11: ctest-Ausgabe in Datei, dann rc), `declared:VAR` → gezählte „ungeprüfte Gates" | 1,5 | W0a | mit D2 |
| D2-G5 | ~~6 von 428 Tests registrieren sich nur auf AVX-512-Hosts~~ → Host-Klassen-Bericht (3 Zahlen, Host-Kennung), zweistufige Untergrenze — **RICHTIGSTELLUNG 08.08. am Objekt, s. Fußnote D2-G5** | 1 | W0b | **GEBAUT** (super `scripts/ci_host_klassen_bericht.sh` + Selbsttest + Job `test:host-klassen-bericht`) |
| D2-G6 | Registry-Roundtrip-Gates hängen an Datei-Existenz, Kommentar verspricht die stille Abschaltung als Merkmal → Pflicht-Erwartung + Kommentar korrigieren; **Standard-Bissprobe** der Wache (stash-Köder, billig, rückstellbar) | 0,5 | W0a | Anhang zu D2 |

**Tragende Abnahme:** die Wache druckt DREI unabhängige Zahlen (eigene Inventur N / Job-Baum-Inventur M aus dem Artefakt eines **anderen** Jobs / Gates FOUND G von G_deklariert), N≠M ⇒ Exit≠0; Zahl-Köder „345" im gefälschten Artefakt → rot; Schrumpf-Köder (N per `shuf` gewählte Tests in `if(FALSE)`) → rot mit Zahl; **unmanipulierter Lauf bleibt grün** (Gegenköder gegen Dauer-Rot). `ctest -N` zählt nach D2-G1 **+2** (heute 0 Treffer für `test_commands|test_engine_adapters`).

> **FUSSNOTE D2-G4 — DIE KORRIGIERTE ABNAHME ##06. Textstand 09.08.2026, jede Zahl am Objekt
> gemessen, keine abgeschrieben. Diese Fassung ist die geltende; die Fassung der Endfassung v1
> (`20260808-WELLENPLAN-ENDFASSUNG-369-soll-211-ist.md:578`) ist damit ÜBERHOLT, bleibt aber
> stehen — der Bestand an Fehlern ist selbst ein Datum.**
>
> **Was die alte Formel zusicherte.** v1:578 verlangte: `sh scripts/ci_test_coverage_guard.sh` druckt
> „`STATUS_OUT-Bloecke in der Quelle: 5` · `FOUND im Configure-Log: 5` · Vergleich"; Köder: einen der
> fünf Blöcke scheitern lassen → `SKIPPED` → rot; einen sechsten einfügen → Zähler auf 6.
>
> **Warum sie nicht trägt — drei Gründe, jeder allein hinreichend.**
> 1. **Dauer-Rot.** Zwei der fünf Blöcke (`_pa_status` ce `tests/unit/CMakeLists.txt:1118`,
>    `_fj_status` `:1150`) liegen hinter `if(COMDARE_PRUEFLING_INCLUDE_DIRS)` (`:1109`). Diese
>    Variable wird über `COMDARE_CE_PRUEFLINGE` gesetzt (ce `CMakeLists.txt:723`), und
>    `COMDARE_CE_PRUEFLINGE` ist in **ce und super zusammen an keiner Stelle** gesetzt — leerer
>    Cache-Eintrag (`build-xml/CMakeCache.txt:881 COMDARE_CE_PRUEFLINGE:STRING=`). Beide Blöcke
>    erreichen in keinem CI-Baum je ein FOUND. „Jeder Block braucht ein FOUND" wäre ein Job, der nie
>    grün werden **kann** — und ein Job, der immer rot ist, ist so wertlos wie einer, der immer grün ist.
> 2. **Falscher Gegenstand.** Genau diese zwei Blöcke registrieren **keinen einzigen Test**; sie bauen
>    DLL-Targets. Die alte Formel maß Codegen-Blöcke und nannte das Test-Abdeckung.
> 3. **Zu kleiner Ausschnitt.** STATUS_OUT deckt **4 von 18** bedingten Registrierungen (22 %). Die
>    übrigen 14 hängen an Host-ISA, Compiler-Flags, TARGET-Existenz, Datei-Existenz, Messmodus und
>    Prüfling — für die alte Formel unsichtbar.
>
> **DIE GELTENDE FORMEL ##06 — „erfüllt ODER Allowlist mit Begründung".**
> Jede bedingte ctest-Registrierung des Bauwegs ist **entweder** ERFÜLLT (ihr Testname steht in der
> `ctest -N`-Liste des gebauten Baums) **oder** sie steht **namentlich mit Begründung** in
> `ci/abnahme06_bedingungs_allowlist.txt`. `ohne_allowlist_eintrag > 0` ⇒ Exit ≠ 0. Eine leere
> Begründung ist kein Eintrag (fail-closed). Eine stille Ausnahme wäre wieder ein blindes Grün.
>
> **DIE ZWEI NENNER SIND ZWEI WEGE (T-3 NENNER FREMD) — ausdrücklich, weil daran alles hängt.**
> *SOLL-Nenner:* der **CMake-Quelltext**. `scripts/ci_abnahme06_bedingungs_tabelle.sh` verfolgt die
> `if/elseif/else/endif`-Klammerung und zählt jede `add_test(`/`comdare_add_test(`-Stelle mit
> Tiefe > 0. Diese Menge existiert auch dann, wenn nie gebaut wurde.
> *IST-Nenner:* die **`ctest -N`-Liste eines gebauten Baums** (`--ctest-liste`). Sie entsteht aus
> einem Configure-Lauf auf einer bestimmten Maschine.
> Die beiden Wege teilen **kein Werkzeug und keine Datei**. Genau deshalb kann der Vergleich etwas
> finden. Die alte Wache bezog beide Zahlen aus ihrer eigenen Inventur und konnte eine fehlende
> Registrierung deshalb grundsätzlich nicht bemerken — das ist der Auslöser des ganzen D2-Bogens.
>
> **HOST-KENNUNG IST TEIL DER FORMEL (Richtigstellung 09.08.2026).** Es gibt zwei bare-metal-Runner
> — prod1/AMD **mit** AVX-512, prod2/Intel **ohne** — und **47 von 53 tag-tragenden Jobs floaten zwischen ihnen (korrigiert 09.08. spaet, 44/48 war falsch);
> das ist so gewollt**, die Maschinen stimmen sich über das **Lager** ab, wer welches Batch
> verarbeitet. Die Folgerung ist deshalb **nicht** „Jobs pinnen", sondern: **eine Zahl ohne
> Host-Kennung ist eine Zahl ohne Gegenstand.** „457 sichtbar" ohne „auf prod2" sagt nichts. ##06
> druckt die Host-Zeile deshalb nicht selbst, sondern **delegiert an den bereits gebauten**
> `scripts/ci_host_klassen_bericht.sh` (Posten D2-G5) und bricht ab, wenn dieser keine
> `HOST-KENNUNG` liefert. Zwei Wahrheiten über dieselbe Maschine wären eine zu viel.
>
> **DIE ZAHLEN, gemessen 09.08.2026 auf prod1/`avx512f` gegen ce `404ff6cf`, IST-Nenner
> `build-xml/ctest -N` (461 Einträge):**
> `bedingte_registrierungen=18` · `bedingungs_klassen=14` · `erfuellt=12` ·
> `allowlist_mit_begruendung=6` · `ohne_allowlist_eintrag=0` · `name_nicht_statisch=2`.
> Dieselben 18/14 über **drei** ce-Stände (`wt-ce-xml 404ff6cf`, `wt-ce-fk`, vendoriertes ce
> `a1d0c201`) — der Befund hängt nicht an einem Commit.
> Allowgelistet sind genau zwei Bedingungen: `COMDARE_PRT_ART_LEGACY_AVAILABLE` (4 Stellen; das
> Gatter ist reine Datei-Existenz `prt_art/include/prt_art/prt_art.hpp`, und `prt_art/` existiert in
> keinem der drei Bäume; das super-Submodul `Code/external/comdare-prt-art` ist **nicht
> ausgecheckt**) und `do_run` (2 Stellen in Hausfunktionen, deren Testname aus `${_tgt}`
> entsteht — strukturell nicht namentlich auflösbar; **aufgelöst wird er von
> `ci_host_klassen_bericht.sh`**, dort `isa_gattiert_gesamt=6`, davon 4 an AVX-512F und 2 an AVX2).
>
> **KÖDER, GEFAHREN (K13, gewürfelt — nicht aus dieser Datei abgeschrieben).** Eine zufällig
> erzeugte bedingte Registrierung `test_koeder_q3ymn2vox2qwsca` unter `COMDARE_KOEDER_dfdfutimc3d3xgq`,
> mit `NAME` **auf der Folgezeile** (genau die Form, die die alte Zählweise übersah), in eine
> Arbeitskopie angehängt: Zähler **18 → 19**, `ohne_allowlist_eintrag=1`, Exit 1, Stelle namentlich
> gedruckt. **Gegenprobe:** dieselbe Kopie unmanipuliert → 18, `ohne_allowlist_eintrag=0`, Exit 0.
> Beide Läufe gehören zum Beleg; ein Köder, der immer beißt, ist so wertlos wie einer, der nie beißt.
>
> **DIE VORLAGE IST JETZT SELBST PRÜFBAR.** `--gegen-vorlage` liest die Markerzeile unten und
> vergleicht sie gegen die Messung. Driftet der Plan gegen das Objekt, wird der Lauf rot — statt
> dass ein korrekt gebautes Paket gegen eine falsche Zusicherung geprüft wird und grün wird.
> Fehlt die Markerzeile ganz, ist das ebenfalls rot (fail-closed).
>
> **WAS D2-G4 NICHT LIEFERT — und was D2 deshalb mitbringen MUSS (beim Bauen gefunden, nicht
> vermutet).** ##06 hat in der **super-CI heute keinen IST-Nenner**: `grep -n 'ctest -N'` über
> `super/.gitlab-ci.yml` = **0 Treffer**; der einzige Job, der eine Live-Inventur herstellt, ist
> `test:coverage-guard` auf der **ce**-Seite (`ce/.gitlab-ci.yml:281`), und dessen Ausgabe wird
> nicht als Artefakt veröffentlicht. Ohne `--ctest-liste` ist jede der 18 Registrierungen
> allowlist-pflichtig, d. h. ein CI-Job wäre entweder rot oder müsste alles allowlisten — beides
> wertlos. **D2 muss daher die `ctest -N`-Liste als Job-Artefakt veröffentlichen** (es hat ohnehin
> „Configure-Log als Artefakt, heute `paths: []`" im Auftrag); erst dann bekommt ##06 seinen
> CI-Job. Bis dahin ist ##06 **baremetal belegt** (§61-Dual-Weg, Hälfte 1 erfüllt, Hälfte 2 offen —
> ausdrücklich, nicht durch Weglassen). Ein Job, der ohne IST-Nenner grün wird, wäre genau der
> Defekt, gegen den D2 gebaut wird.
>
> **NACHTRAG D2-G4/Z — 09.08.2026 abends: DIE ALLOWLIST DECKTE BEDINGUNGEN, NICHT STELLEN.**
> Die obige Fassung der Formel trägt weiter, ihre **Umsetzung** hatte ein Loch, und zwar genau das,
> gegen das sie gebaut ist. Am Objekt mit gewürfeltem Köder nachgestellt: eine **neue** bedingte
> Registrierung unter einer **bereits allowgelisteten** Bedingung rutschte still grün durch.
> `if(COMDARE_PRT_ART_LEGACY_AVAILABLE) add_test(NAME test_schleich_kqwg3p3clrgxrky …)` an eine
> Arbeitskopie angehängt → **EXIT 0**, `allowlist_mit_begruendung` stieg lautlos **6 → 7**, obwohl der
> Allowlist-Eintrag wörtlich *„Deckt 4 Registrierungen"* zusichert. Wer eine Registrierung unter eine
> bestehende Ausnahme hängt, hat sie nicht begründet — er hat sie **versteckt**. Die W0a-Abnahme
> unten verlangt „**namentlich rot**"; für diesen Weg hielt die gebaute Wache das nicht.
>
> **Was daraus folgt (gebaut, nicht vorgeschlagen).** Die Allowlist trägt jetzt je Eintrag eine
> **Zusicherung** `stellen=N` als zweites TAB-Feld (`COMDARE_PRT_ART_LEGACY_AVAILABLE stellen=4`,
> `do_run stellen=2`). Die Wache misst die Stellenzahl je Bedingung aus dem CMake-Quelltext und hält
> sie dagegen: **`allowlist_zusicherung_verletzt > 0` ⇒ Exit ≠ 0**, mit **beiden** Zahlen und den
> Stellen namentlich. Abweichung in **beide** Richtungen ist ein Befund — `ist > soll` ist die
> Schleich-Registrierung, `ist < soll` eine tote Ausnahme, deren Begründungstext ab dann falsch ist.
> Das **alte Zweifeld-Format bricht laut** (fail-closed), nicht leise weiter.
>
> **Der Restweg ist mit geschlossen.** Ein im selben Change mitgezogener Marker-Bump `18 → 19` bringt
> `--gegen-vorlage` wieder zur Deckung — am Objekt gefahren: „`Vorlage sagt: 19 · Objekt sagt: 19 ·
> Deckung: ja.`" — und der Lauf bleibt trotzdem **rot**, weil die Zusicherung in der Allowlist steht
> und **nicht** im Marker. Deshalb wandert `stellen=N` ausdrücklich **nicht** in die Markerzeile:
> eine Zahl, die im selben Dokument steht wie die Behauptung, kann sie nicht prüfen.
>
> **§61-Dual-Weg, Hälfte 2 — für diesen Teil ab heute erfüllt.** Die Zusicherung braucht **kein**
> Bauverzeichnis (die Stellenzahl kommt allein aus dem Quelltext), also ist sie ohne IST-Nenner
> CI-fahrbar: neuer Job **`test:abnahme06-zusicherung`** (`.gitlab-ci.yml`, kein `allow_failure`,
> kein `.code-rules`) fährt `scripts/ci_abnahme06_bedingungs_tabelle.selbsttest.sh` und danach
> `--nur-zusicherung --gegen-vorlage <diese Datei>`. Die **volle** Formel ##06 bleibt bis Posten D2
> baremetal — der Modus druckt deshalb `ZAHL 3 NICHT AUSGEWERTET` statt einer 0, denn eine 0 wäre
> eine Behauptung über Ungemessenes.
>
> **Köder, gefahren (K13, je Lauf frisch gewürfelt).** `test_schleich_kqwg3p3clrgxrky` unter
> `COMDARE_PRT_ART_LEGACY_AVAILABLE` → **vor** dem Bau EXIT 0 (6→7, kein Signal), **nach** dem Bau
> EXIT 1, `soll=4 ist=5`, Stelle namentlich. Zweitköder `test_zweitkoeder_z45suqh3wytu6ki` unter
> `do_run` → EXIT 1, `soll=2 ist=3`. **Gegenprobe:** dieselbe Quelle unmanipuliert → EXIT 0,
> `allowlist_zusicherung_verletzt=0`, `6 von 6` zugesicherten Stellen gedeckt.
> Selbsttest (Fixture mit von Hand abgezähltem Inventar, T-3): **11 von 11 Fällen grün**, davor
> **8 von 11 rot** — der Rot-Lauf ging dem Bau voraus (T-1).
>
> **NACHZUG 10.08.2026 — DIE VIER PRT-ART-REGISTRIERUNGEN SIND ENTFALLEN, DIE ZAHLEN ZIEHEN NACH.**
> Der Gitlink-Bump auf `ce e114cabd` (super `0e11e1f8`) hat es ausgelöst, und **beide Wachen haben
> gefangen**, was sonst still falsch geworden wäre — super-Pipeline **15615**, Jobs **373214** und
> **373217**.
>
> | Zahl | alt (09.08., Stand `1880f296`) | neu (10.08., Stand `e114cabd`) |
> |---|---|---|
> | `bedingte_registrierungen` | 18 | **14** |
> | `bedingungs_klassen` | 14 | **13** |
> | Allowlist `stellen_soll` | 6 | **2** |
>
> **Die Differenz ist exakt die Allowlist-Position `COMDARE_PRT_ART_LEGACY_AVAILABLE`** (18 − 4 = 14).
> Am Objekt gemessen: die Bedingung kommt in `ce tests/unit/CMakeLists.txt` nur noch **zweimal** vor
> — `:87` auskommentiert, `:148` im Erklärungstext. **Beide sind Kommentare.** Der Code begründet den
> Wegfall selbst (`:148`): *„ein Gatter, das per Konstruktion nie TRUE werden konnte"*; die drei
> Quelldateien liegen weiter im Baum, ihre Disposition ist **Ledger PA-3 (Owner)**.
>
> Der Allowlist-Eintrag ist damit **aufgehoben** — nicht gelöscht, sondern in
> `ci/abnahme06_bedingungs_allowlist.txt` auskommentiert mit voller Begründung. Es war die
> `ist < soll`-Richtung (`soll=4 ist=0`), also *„eine tote Ausnahme, deren Begründungstext ab dann
> falsch ist"* — genau der Fall, für den der Nachtrag D2-G4/Z die Zusicherung gebaut hat.
> **Zum ersten Mal hat die `ist<soll`-Hälfte gebissen**; bisher war nur die Schleichweg-Richtung belegt.

> <!-- ABNAHME06-ZAHLEN bedingte_registrierungen=14 bedingungs_klassen=13 quelle=ce/tests/unit/CMakeLists.txt erhoben=2026-08-10 host=prod1/avx512f -->

> **FUSSNOTE D2-G5 — RICHTIGSTELLUNG 08.08.2026, am Objekt gemessen, nicht abgeschrieben.**
> Die Planzeile „6 von 428 Tests registrieren sich nur auf AVX-512-Hosts" ist als Satz **falsch**,
> und zwar nicht um eine Ziffer, sondern um eine **Ebene**: sie nennt eine Leiter mit einer Zahl.
> Nachgezählt mit `sh scripts/ci_host_klassen_bericht.sh` (super, prod1/Zen 5 = Klasse `avx512f`):
>
> * **6** ctest-Registrierungen des Bauwegs hängen überhaupt an einer Host-ISA,
> * davon **4** an `COMDARE_HOST_RUNS_AVX512F` — `test_buildvariant_dll_real` und
>   `test_ap5_simd_extension_coherence` (ce `tests/unit/CMakeLists.txt:3782/3796`, Block
>   `if(AVX2 AND AVX512F)`) plus die beiden `_avx512`-Varianten aus
>   `comdare_add_simd_dispatch_test` / `comdare_add_simd_add_u64_test` (`:4822/:4854`),
> * die restlichen **2** hängen nur an `COMDARE_HOST_RUNS_AVX2` (`:4809/:4851`).
>
> Also: **prod2** (Raptor Lake, AVX-512 hardware-fused-off) verliert **4**, eine Maschine ganz ohne
> AVX **6**. Beide Zahlen des Plans waren real — die **6** aus dieser Zeile und die **−4** aus An-8
> —, sie gehören nur zu **verschiedenen Sprossen**. Genau deshalb ist die Untergrenze zweistufig.
> Dieselbe Messung ergab 6/4/2 über **drei verschiedene ce-Stände** (`a1d0c201`, `4dd5a1bc` sowie
> den Arbeitsbaum von `wt-ce-xml`) — der Befund hängt nicht an einem Commit.
>
> **Die „428" ist hier NICHT bestätigt und wird nicht übernommen.** Sie ist eine ctest-Eintragszahl
> aus einem gebauten Baum; dieses Paket hat keinen gebaut. Der Bericht zählt in einer anderen
> Einheit (Registrierungs-**Aufrufe** im Quelltext, `gtest_discover_tests` = 1) und misst im
> super-Baum `registrierungen_gesamt=148`. Die beiden Zahlen sind **nicht** ineinander umrechenbar;
> wer sie gleichsetzt, wiederholt den Fehler, den die Fußnote korrigiert.
>
> **NACHTRAG 09.08.2026 — DAS GEGENORAKEL IST GEFAHREN: CMake selbst bestätigt die Leiter.**
> Der Landungsbericht `3b13bf4a` nannte als tragendes Loch, dass 6/4/2 eine Quelltext-Scan-Aussage
> sei und keine von CMake bestätigte. Geschlossen mit `scripts/ci_host_klassen_gegenorakel.sh`
> (+ Selbsttest, 9 Fälle, Köder in beide Richtungen, gewürfelt; der Job `test:host-klassen-bericht`
> fährt beides): derselbe ce-Baum, **gitlink `25fe4fbf`**, DREIMAL konfiguriert — die Host-Antworten
> als `-D`-Preset, denn `check_cxx_source_runs` lässt vordefinierte Variablen stehen —, dann die
> `ctest -N`-Namenslisten gedifft:
>
> * avx512f→avx2: es verschwinden **exakt 4** — `test_buildvariant_dll_real`,
>   `test_ap5_simd_extension_coherence`, `test_simd_field_sum_dispatch_avx512`,
>   `test_simd_add_u64_carry_avx512`. Die zwei zusammengesetzten Namen, die der Scan nur als
>   Kardinalität behaupten konnte, sind damit erstmals **namentlich** belegt.
> * avx2→basis: **exakt 2** — `test_simd_field_sum_dispatch_avx2`, `test_simd_add_u64_carry_avx2`.
> * Beide **Gegenrichtungen leer** (nichts erscheint bei Wegfall einer Fähigkeit).
> * ctest-Einträge je Klasse: **429 / 425 / 423** (Zustand: ce `25fe4fbf`, configure-only, prod1;
>   durch die Presets ist der Lauf **maschinenunabhängig**).
>
> Die ECHTEN Listen hingen zusätzlich am `--ctest-liste`-Gegeneingang des Berichts: je Klasse
> passend dreimal rc 0, und EINMAL absichtlich gekreuzt (Klasse basis gegen die avx512f-Liste)
> rc 1 mit 2 Widersprüchen — die Gegenprobe beißt. Die synthetische Liste des 08.08. ist damit
> durch echte `ctest -N`-Ausgabe ersetzt. **Zur absoluten Zahl:** am deklarierten Stand sind die
> Eintragszahlen je Klasse jetzt GEMESSEN (429/425/423); `gtest_discover_tests`-Platzhalter
> entstehen dort 0. Die „428" bleibt unbestätigte Historie eines anderen Standes. Eine
> prod2-Maschine ist für DIESE Messung nicht mehr Voraussetzung — die Preset-Technik ersetzt sie;
> unabhängig davon hat die ce-Sichtbarkeits-Wache (ce `404ff6cf`, 09.08.) die avx512f-Sprosse auch
> **zweimaschinig** belegt: 461 Einträge lokal/prod1 gegen 457 im CI-Baum eines Runners ohne
> AVX-512, Differenz exakt die vier Gatter-Einträge.

> **FUSSNOTE F1-KERN — DIE SIEBEN KERN-EXPLORES VOM 10.08.2026. Kein einziges „STIMMT".
> Jede Zahl unten am Objekt gemessen; wo ich sie selbst nachgeprüft habe, steht es dabei.**
>
> **Anlass, Owner verbatim 10.08.:** *„Jede Verarbeitung braucht vorne einen Explore, ob überhaupt
> der **Kern** ihrer Aufgabe stimmt, sonst müssen wir die **Definition der Aufgabe** korrigieren."*
> Daraufhin bekam jedes Paket der F1-Kette eine Pflicht-Stufe 0 mit vier zulässigen Urteilen
> (`STIMMT` · `STIMMT_TEILWEISE` · `STIMMT_NICHT` · `SCHON_ERLEDIGT`), als Pflichtfeld im Schema.
> Gefahren als Workflow `wf_e22d25ef-71c`, 11 Agenten, 0 Fehler.
>
> **DAS ERGEBNIS, das die Regel rechtfertigt:**
>
> | Urteil | Anzahl | Pakete |
> |---|---|---|
> | **SCHON_ERLEDIGT** | 5 | D1b · D2-G1 · D3-7 · D3-3 · ##23 |
> | **STIMMT_TEILWEISE** | 2 | ##08 · ##20+D3-6 |
> | **STIMMT** | **0** | — |
>
> **Fünf von sieben Paketen wären neu gebaut worden, obwohl sie fertig sind.** Ein Neubau hätte
> jeweils eine **zweite Wahrheit** neben der bestehenden erzeugt und deren gefahrene Köder entwertet.
>
> ---
>
> **D1b — STREICHEN, nicht bauen. Der Gegenstand existiert nicht mehr.**
> Die Messung des Plans stimmt, die Schlussfolgerung nicht. `grep -c -F "adhoc_emitter" .gitlab-ci.yml`
> = **0** — bestätigt, Gegenprobe im selben Lauf `comdare_tests` = **10**, die Null trägt.
> Aber: **es gibt keine Prebuild-Liste mehr, in die man ihn eintragen könnte.**
> *Von mir selbst nachgemessen:* aktive Zeile `^\s*COMDARE_TEST_PREBUILD_TARGET` = **0**;
> Gegenprobe mit einer aktiven Variablen derselben Familie `^\s*COMDARE_TEST_CMAKE_BUILD_DIR` = **1**.
> Beide Vorkommen der Prebuild-Variablen stehen in **Kommentaren**. Die verlangte Maßnahme würde die
> am 08.08. bewusst zurückgebaute Fehlerklasse (Handliste neben dem Bauweg) wieder einführen.
> **Restposten, vom CI-File selbst benannt** (`ce/.gitlab-ci.yml:934-938`, Kommentar „OFFEN (eigenes
> Paket)"): `test:unit` veröffentlicht seit D1c seine Inventur als `build/Testing/ctest_unit_inventar.txt`
> — **der Verbraucher fehlt**. `test:coverage-guard` liegt in Stage `contract`, `test:unit` in Stage
> `test`; `needs` darf nicht vorwärts zeigen (17 needs-Kanten, 0 vorwärts). Das ist ein
> **Stage-Topologie-Posten**, kein Prebuild-Posten.
>
> **D2-G1 — ERLEDIGT mit `ce ca6d8af1`, und die Ledger-Fassung war gefährlich falsch.**
> Beide Zeilennummern des Plans sind überholt: `enable_testing()` liegt heute bei `CMakeLists.txt:695`
> **vor** dem ersten `add_subdirectory` (`:701`); `:674` ist heute eine Kommentarzeile, die den alten
> Zustand beschreibt. Die **27** ist heute **30** — *von mir aus dem Git-Index nachgezählt:*
> `test_commands.cpp` = **23**, `test_engine_adapters.cpp` = **7**. Die drei Zusätze kamen am 09.08.
> mit `cc9c233e`/`905bd1aa` und sind Welch-Fälle; die Signifikanz-Wachen sind vollständig da.
> **Es waren ZWEI unabhängige Defekte**, nicht einer: (a) die `enable_testing()`-Reihenfolge, (b) ein
> davon unabhängiger `gtest_discover_tests`-Defekt, den der Wurzelfix **erst sichtbar gemacht** hat.
> Geschlossen wurde (b) am 10.08. mit `ca6d8af1` („die zwei gtest-Binaries unter `libs/` nach dem
> Repo-Muster registrieren") — *von mir geprüft: existiert und ist Vorfahr von `origin/development`.*
> **Die Ledger-Zeile 2626** sagt *„zwei gegenstandslos — D2-G1 durch den W-1-Wurzelfix geheilt"*.
> Das verharmlost die Klasse und ist als Satz falsch; korrigiert im Ledger-Nachtrag vom 10.08.
>
> **##08 — STIMMT_TEILWEISE. Zerfällt in drei Teile, einer davon darf NIE gebaut werden.**
> (A) **erledigt:** Schema-Freeze Stufe 1 + B-3 sind gebaut, datiert und bewacht
> (`schema_freeze.hpp`, Kopf „2026-08-09", `kWideSchemaFreezeStufe1` = 189 Spalten;
> `test_b3_schema_freeze_stufe1.cpp`, `test_mt_l3_wide_schema_orakel.cpp`; Ledger:4079 `03f897dd`).
> (B) **NIE bauen:** die „lazy Header-Emission" auf `a.out_csv`. **Der Auftrag hat den Namen
> missverstanden** — `lazy` ist das Präfix der lazy-*Lauf*-Familie (`run_lazy_static_then_dynamic`,
> `LazyRunConfig`, `LazyMeasuredRow`, `lazy_try_resume_binary`), **kein Emissionsverhalten**. Und im
> Plan heißt der Posten „`lazy_csv_header` **EINMAL** (B-3)" = *eine Definition* (Abschrift-Beseitigung),
> nicht „einmal geschrieben". Gebaut würde sie `ci/mess_ausbeute_wache.sh:186-190` modus-blind rot
> machen und das `N_LEER`-Signal löschen. Nenner: 3531 durchsuchte C/C++-Dateien, **1** Definition
> (`cache_engine_builder_iterator.hpp:504`).
>
> **D3-7 — ERLEDIGT, `028684ac` (09.08.), in development.** `ci/lauf_marker.sh` (371 Z.),
> `ci/tests/lauf_marker_probe.sh`, `ci/frische_wache.sh`; verdrahtet in `.gitlab-ci.yml:1665-1667`
> und `:1840-1842`. Der Modus kommt aus der **Treiber-Bilanzzeile**, nicht vom Aufrufer.
> **Restposten „D3-7b: der dritte Modus fehlt"**, dreiseitig — `pruef_only` erscheint nicht in der
> Bilanzzeile (`ce profile_run_entry.hpp:1268`), also kann der Marker ihn nicht führen.
>
> **D3-3 — ERLEDIGT, `4e0b7e0d` (08.08.).** Die Logik liegt nicht mehr im YAML, sondern in
> `ci/persist_sammler.sh` (332 Z.): `:305` `if [ "$DATENZEILEN_GESAMT" -eq 0 ]; then gate_verweigern; fi`,
> Zählung in `bilanz_zaehlen :131-155` per `awk` (statt `wc`, ausdrücklich begründet `:26-33`).
> **Restposten „D3-3b: eine LEERZEILE ist kein Messwert"** — `NR-1` zählt Leerzeilen mit; die Heilung
> muss **drei Dateien in EINEM Commit** treffen, weil sie sich gegenseitig Wortgleichheit zusichern.
>
> **##20+D3-6 — STIMMT_TEILWEISE. Der Selektor ist geheilt, die Vorschrift ist falsch.**
> (A) **erledigt:** D3-6 und ##20s erste Hälfte (`AF_GENERATOR` belegt) — s. Korrektur-Einschub in §1.
> Selbstbiss gefahren am unveränderten Stand: *„NENNER: 11 Fälle gefahren, 11 gehalten, 0 gerissen"*,
> *„SELBSTBISS-NENNER: 6 von 6 Mutanten haben die Probe rot gemacht."*
> (B) **die Vorschrift selbst ist zu korrigieren:** ##20 sagt „`|| true` beim `git add` fällt". Das ist
> am Objekt **falsch** — es gibt `rc=128` bei **jedem DE-only-Lauf**, und genau deshalb stand die Zeile
> jahrelang so. Ein blindes Entfernen macht den Kanal rot.
> *(Nachtrag 10.08. abends, Paket ##20-B: diese drei Zeilen bleiben wörtlich stehen — sie sind die
> Fassung, gegen die gemessen wurde. **Die Richtung hält, zwei ihrer drei Begründungen nicht**, und der
> Code ist nicht unschuldig: er ist anders defekt, als ##20 behauptet. Vollständig am Objekt
> nachgemessen, s. **FUSSNOTE ##20-B** unmittelbar nach dieser Fußnote.)*
>
> **##23 — ERLEDIGT, und der Auftrag vermischte zwei Nahtstellen.**
> Es gibt **zwei**: (A) `ergebnis_mappe_naht.hpp` — die Mappe **im Lauf**, Richtung **xlsx → csv**
> (das ist die Owner-Doktrin, und der Posten-Titel „CSV → xlsx" beschreibt sie falsch herum);
> (B) `tools/mess_report/` — ein CLI, das eine **bestehende** Mess-CSV liest. Alle vier Teile des
> Postens sind gebaut; die Abnahme wurde gegen das **echte 320er-Archiv** gefahren.
> **Restposten R1, Blocker für jede echte Kampagne:** die acht vendorierten `thesis_profiles` sind
> **xlsx-blind** (`mit_xlsx=1 ohne_xlsx=8` über Nenner 9). *Teilweise erledigt:* der Gitlink wurde am
> 10.08. auf `e114cabd` gehoben (`super 0e11e1f8`); ob das den geforderten Stand `>= 4a26b6a3`
> einschließt, ist beim Bau von R1 **neu auszuzählen**, nicht anzunehmen.
>
> ---
>
> **WAS DARAUS FÜR DEN PLAN FOLGT.** Von den sieben geprüften Posten bleiben **null** als
> ursprünglich beschriebenes Bau-Paket. Was bleibt, sind **fünf neu geschnittene Restposten**
> (Stage-Topologie · D3-7b · D3-3b · ##20-B · ##23-R1) und **eine Ledger-Korrektur**. Die
> ursprünglichen Aufwände (D1b 1,5 h · D2-G1 2 h) fallen; die Restposten sind **nicht** vermessen und
> dürfen nicht stillschweigend als gleich teuer geführt werden.
> *(Nachtrag 10.08. abends: **einer von den fünfen ist es jetzt** — ##20-B ist am Objekt durchgemessen
> und als Doku-Paket geschlossen; was von ihm als BAU übrig bleibt, ist die eine ersetzte Zeile aus der
> Fußnote ##20-B, offen nur noch an der git-Version des Runners. Die anderen vier bleiben unvermessen.)*
>
> **Und die allgemeine Lehre, die über F1 hinausgeht:** derselbe Kern-Explore lief im
> Hauptstrang-Workflow **nicht** vorgeschaltet, sondern erst beim Bauen — dort war in **fünf von fünf**
> Fällen der Bauauftrag am Objekt falsch, weil er aus Plänen und Ledger-Zitaten gebaut war, die selbst
> veraltet sind. **Der Plan ist keine Quelle über den Code. Er ist eine Behauptung über ihn.**

> **FUSSNOTE ##20-B — DIE VORSCHRIFT, AM OBJEKT NACHGEMESSEN. 10.08.2026 abends.
> Die alte Fassung oben bleibt stehen; die korrigierte steht hier daneben (Muster D2-G4/D2-G5).**
>
> **MESSORT, selbst gemessen statt abgeschrieben.** super `probst-diplomarbeit-cache-engine`,
> Worktree `.claude/worktrees/wf_bc389245-884-4`, **HEAD `7144f4f6`** (`git rev-parse HEAD`);
> `6d2e3dce` ist Vorfahr (`git merge-base --is-ancestor` → rc **0**). Gegenstand ist **eine Zeile**:
> `ci/anhang_forward_core.sh:417` `git -C "$AF_DEST_REPO" add -- "anhang/$lang/tabellen" 2>/dev/null || true`.
> `git version 2.43.0`. **Jedes rc unten ohne Pipe gemessen** (K11). Alle Fixtures unter `mktemp -d`,
> kein Projekt-Repo berührt, **kein CI-YAML angefasst** — dies ist ein Doku-Paket plus eine Messung.
>
> **(A) bestätigt, nichts zu tun:** `:202` `AF_RESULT_NAMEN="${AF_RESULT_NAMEN:-result.csv *.result.csv}"`
> trägt beide Namensformen.
>
> **DIE DREI BEHAUPTUNGEN VON (B), EINZELN GEMESSEN — eine hält, zwei nicht:**
>
> | Behauptung | Urteil | Beleg, literal |
> |---|---|---|
> | „Ein blindes Entfernen macht den Kanal rot" | **HÄLT** | DE-only gegen ein Ziel **ohne** `anhang/en/tabellen`: unverändert rc=**0** (Commit landet), mit gestrichenem `\|\| true` rc=**128**, `fatal: pathspec 'anhang/en/tabellen' did not match any files` |
> | „`rc=128` bei **jedem** DE-only-Lauf" | **ZU STARK** | rc=128 **nur**, wenn das ZIEL den Pfad weder im Baum noch im Index trägt. Gegen ein Ziel **mit** `anhang/en`-Bestand: rc=**0**, auch mit gestrichenem `\|\| true` |
> | „genau deshalb stand die Zeile **jahrelang** so" | **FALSCH** | die Zeile kam mit dem **ersten** Commit der Datei überhaupt: `347684cb`, **2026-08-06** — vier Tage. `git log -S` auf `.gitlab-ci.yml` findet **keinen** Vorläufer |
>
> **WARUM DIE ZWEITE BEHAUPTUNG DEN POSTEN VERSCHIEBT.** `git add -- <pfad>` ist nur dann `rc=128`,
> wenn die Pathspec **nichts** trifft. **3 von 3 Zuständen gemessen:** Pfad fehlt ganz → **128**;
> Verzeichnis existiert und ist leer → **0**; Verzeichnis mit Datei → **0**. Und das reale Ziel trägt
> den Pfad: im 289-Baum am gepinnten Gitlink `798e9460` liegen `anhang/de/tabellen` = **18** und
> `anhang/en/tabellen` = **18** getrackte Dateien (Gegenprobe `kapitel/de` = **14**, also keine
> Werkzeug-Null). **Der `|| true` ist heute im CI-Pfad also gar nicht tragend** — er ist ein latenter
> Schutz für einen Fall, den die Pipeline in ihrer heutigen Konfiguration nicht erreicht. Er wird
> tragend in dem Moment, in dem `AF_LANGS` eine Sprache bekommt, die 289 noch nicht führt.
>
> **UND JETZT DER TEIL, DEN ##20 RICHTIG GEROCHEN UND FALSCH BENANNT HAT.** Die v1-Fassung führte den
> Defekt als *„`git add … 2>/dev/null || true` + ‚IDEMPOTENT: 0 Aenderungen' + Exit 0"*
> (`…-369-soll-211-ist.md:509` und `:641`). **Das ist am Objekt WAHR und reproduziert** — nur hat es
> mit der Sprachauswahl nichts zu tun. Gemessen an einem Ziel, das **beide** Sprachen getrackt trägt
> (wie 289), mit einer **stale `.git/index.lock`** — dem klassischen Runner-Rest eines abgebrochenen
> Vorlaufs:
>
> ```
>    [de] kopiert: 1 .tex -> anhang/de/tabellen/
>    [en] kopiert: 1 .tex -> anhang/en/tabellen/
>    kopiert gesamt: 2 .tex
> -- (3) Idempotenz-Pruefung im Ziel-Repo --
>    gestagte Aenderungen: 0 Datei(en)
> === anhang:forward IDEMPOTENT: 0 Aenderungen -> kein Commit ===
> ```
>
> **rc=0. Commits vorher 2, nachher 2. Im Zielbaum gelandet: 0 von 2 kopierten Messwert-Dateien.
> stderr LEER** — das `2>/dev/null` hat den `fatal: Unable to create … index.lock` verschluckt, das
> `|| true` das rc. Der Lauf ist von einem ehrlichen „nichts zu tun" **nicht zu unterscheiden**; das
> ist exakt die Fehlerklasse, gegen die derselbe Kanal in seinem eigenen Kopf vier Fallen dokumentiert
> („Alle vier endeten mit rc=0 und einer Ausgabe, die wie ein ehrliches ‚nichts zu tun' aussah").
> **Gegenprobe im selben Lauf:** ohne `index.lock` rc=0, Commits 2→3, **2 von 2** Dateien gelandet —
> die Null oben ist also keine Werkzeug-Null.
>
> **ZWEITER, UNABHÄNGIGER BEFUND derselben Zeile (nicht von ##20 genannt).** `git add -- <verzeichnis>`
> nimmt **fremde** unversionierte Dateien im selben Verzeichnis mit. Gemessen: eine `fremd_entwurf.tex`,
> die dieser Lauf nie geschrieben hat, liegt in `anhang/de/tabellen/` → `gestagte Aenderungen: 3` statt
> 2, und die Datei steht danach **im committeten Baum** (1 Treffer, Nenner 5 Dateien unter `anhang/`).
> **Präzise eingeordnet, damit daraus keine neue Falschaussage wird:** die Kopfzusage der Datei
> (`:26-33`) betrifft den **Rollback**-Pfad — „löscht niemals fremde unversionierte Dateien" — und die
> hält. Was **nirgends** zugesichert ist und **nicht** gilt: dass der *Commit* nur die Dateien dieses
> Laufes enthält.
>
> **DIE KORRIGIERTE VORSCHRIFT — die alte bleibt oben stehen, diese tritt daneben:**
>
> ~~„`AF_GENERATOR` belegen, `|| true` beim `git add` fällt."~~ →
> **„`AF_GENERATOR` belegen (erledigt). Das `git add` nennt keine Verzeichnisse mehr, sondern die
> Buchführungsliste `$COPIED_LIST` dieses Laufes. `2>/dev/null` und `|| true` fallen dabei BEIDE —
> nicht als Streichung, sondern weil der Fall, den sie abfingen, dann nicht mehr entstehen kann.
> Dazu ein Nenner in der Ausgabe: `im Index: N von M kopierten Datei(en)`, und `N != M` ist Abbruch."**
>
> **DER VORSCHLAG IM WORTLAUT — GEMESSEN, ABER AUSDRÜCKLICH NICHT GEBAUT** (Auftrag ##20-B: „falls es
> eine saubere Lösung gibt, die das `|| true` ersetzt statt streicht — vorschlagen, nicht bauen"):
>
> ```sh
> git -C "$AF_DEST_REPO" add --pathspec-from-file="$COPIED_LIST" --
> im_index=0
> while IFS= read -r _p; do
>   [ -n "$_p" ] || continue
>   if git -C "$AF_DEST_REPO" ls-files --error-unmatch -- "$_p" >/dev/null 2>&1; then
>     im_index=$((im_index + 1))
>   fi
> done < "$COPIED_LIST"
> echo "   im Index: $im_index von $copied kopierten Datei(en)"
> if [ "$im_index" -ne "$copied" ]; then
>   echo "FEHLER: $((copied - im_index)) von $copied kopierten Dateien stehen NICHT im Index." >&2
>   exit 1
> fi
> ```
>
> **Warum das die Ursache trifft und nicht die Wache abschwächt:** `$COPIED_LIST` existiert bereits
> (`:388`, gebaut für den Rollback) und enthält **genau** die Pfade, die dieser Lauf geschrieben hat.
> Wer nur diese Pfade nennt, kann die Pathspec-Null gar nicht mehr erzeugen — die Sprache ohne Quelle
> steht schlicht nicht in der Liste. Damit braucht es kein `|| true`, und jeder verbleibende
> Fehlschlag ist ein echter, den `set -euo pipefail` trägt. Der Leerlauf-Fall ist vorher schon
> abgefangen (`:409-412`, `copied -eq 0` → NO-OP, Exit 0), die Liste ist hier also nie leer.
>
> **DER VORSCHLAG, GEFAHREN — 5 von 5 Fällen, rc je ohne Pipe:**
>
> | Fall | Lage | rc | gelandet |
> |---|---|---|---|
> | V1 | DE-only gegen Ziel **ohne** `anhang/en` (der Fall, der ##20 rot macht) | **0** | 1 von 1 |
> | V2 | DE-only gegen Ziel **mit** `en`-Bestand (wie 289) | **0** | 1 von 1 |
> | V3 | beide Sprachen, Normalfall | **0** | 2 von 2 |
> | V4 | derselbe Lauf ein zweites Mal → `IDEMPOTENT: 0 Aenderungen`, kein Leer-Commit | **0** | 2 (unverändert) |
> | V5 | **KÖDER** stale `index.lock` — heute still grün | **128** | 0, mit dem echten `fatal` auf stderr |
>
> **Beide Richtungen (K13):** der Köder beißt (V5 rot), die unmanipulierten Läufe bleiben grün (V1–V4).
> Zusätzlich fällt der Fremd-Datei-Befund weg: `gestagte Aenderungen: 2` statt 3, `fremd_entwurf.tex`
> **0** Treffer im committeten Baum.
>
> **WAS AM VORSCHLAG NOCH NICHT GEMESSEN IST — und vor dem Bau zu messen wäre:**
> `--pathspec-from-file` verlangt **git ≥ 2.25**. Hier lokal `2.43.0`; **die git-Version auf dem
> baremetal-Runner ist NICHT geprüft** und darf nicht angenommen werden. Fällt sie zu alt aus, ist die
> Rückfallform `git add -- $(cat …)` **nicht** zulässig (Wortaufspaltung); dann `xargs -0` mit
> NUL-getrennter Liste — und `$COPIED_LIST` müsste `printf '%s\0'` schreiben.
>
> **SO IST JEDE ZAHL OBEN REPRODUZIERBAR** (kein Repo nötig, alles unter `mktemp -d`; die Läufe oben
> sind mit genau dieser Lage gefahren):
>
> ```sh
> # Ziel-Repo:  git init --bare fern.git; git clone file://…/fern.git ziel; ein Ausgangs-Commit.
> #   Variante "ohne en"  : nichts weiter anlegen.
> #   Variante "wie 289"  : anhang/{de,en}/tabellen/bestand.tex anlegen, add, commit.
> # Quelle:     arbeit/artefakte/de/tabellen/A_messwerte.tex   (DE-only)
> #             + …/en/tabellen/A_messwerte.tex                (beide Sprachen)
> # Koeder:     : > ziel/.git/index.lock                       (der stille Fall)
> AF_DEST_REPO=…/ziel AF_WORK_ROOT=…/arbeit AF_LANGS="de,en" AF_ARTIFACT_ROOTS="artefakte" \
> AF_CORPUS_ROOT="korpus_gibt_es_nicht" AF_NO_PUSH=true AF_PDF_GATE=off \
>   bash ci/anhang_forward_core.sh > out 2> err        # rc DANACH ohne Pipe lesen (K11)
> ```
>
> Die „Vorschrift angewandt"-Läufe liefen gegen eine **Wegwerf-Kopie** des Kerns, in der genau eine
> Zeile ersetzt war (Diff-Nenner: **2** geänderte Zeilen, 1 raus / 1 rein). **`ci/anhang_forward_core.sh`
> selbst wurde in diesem Paket nicht angefasst** — `git diff` über `ci/` ist leer.
>
> **WAS DIESES PAKET NICHT GEPRÜFT HAT** (V-8: beide Mengen nennen): den `anhang:forward`-Job im
> Lauf (er ist inert-by-default hinter `COMDARE_ANHANG_FORWARD`), den Push-/Merge-Retry-Zweig, das
> PDF-Gate (in allen Läufen `AF_PDF_GATE=off`), und den Korpus-Zweig (alle Läufe über den
> Artefakt-Zweig). Geprüft wurde **ausschließlich** Block (3), die Idempotenz-Prüfung, `:416-418`.
>
> **NACHZUZIEHEN, NICHT VON MIR** (Ledger ist Single-Writer): der Ledger führt unter **KON4-06**
> (`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:221-223`) dieselbe zu starke Fassung
> („rc=128 bei JEDEM DE-only-Lauf"). Sie ist nach dieser Messung um die Ziel-Bedingung zu ergänzen
> und die „jahrelang"-Begründung zu streichen.

### D3 — Ein leeres Messfenster ist heute grün (8 Posten, 20 h)

Reproduziert: Kopfzeilen-CSV und 0-Byte-CSV bestehen das golden-320-Gate (rc=0). Die Kopfzeile ist Bauart (`trunc` + unbedingter Header vor dem ersten Pass). Der Autor kannte die richtige Form — einen Tag später, am Wegwerf-Objekt (WIDE-Aggregat), im selben Commit wie der Datei-Zähler des Rückschriebs.

| id | Kern | h | Welle | Zwang |
|---|---|---|---|---|
| D3-7 | **Wurzel zuerst:** Lauf-Marker neben jeder CSV (`modus/measured/resumed/provisioned/csv_ok`, aus denselben Feldern wie der stdout-Bericht); fehlender Marker = rot; auch `prune_only` schreibt einen | 3 | W0b | vor allen D3-Gates |
| D3-1 | `ci/measure_csv_gate.sh`: drei Zahlen (`csv_gesamt/csv_mit_datenzeile/datenzeilen_gesamt`), `awk` statt `wc -l`, N==0 = rot; rot NUR bei `modus=voll` und Z==0 | 3,5 | W0b | nach D3-7 |
| ↳ **Nachtrag 08.08. abends — KERN GEFALLEN, MARKER-HÄLFTE OFFEN** | Gebaut als **`ci/mess_ausbeute_wache.sh`**, Commit **`7444d8c0`** — die im Plan genannte Datei `ci/measure_csv_gate.sh` hat **nie existiert**; wer nach dem Namen suchte, meldete „NICHT GEFUNDEN" über eine Sache, die es gab. Erfüllt: drei Zahlen (Z. 110–112), `awk 'END{print NR}'` statt `wc -l` (Z. 95), 0 CSV = rot (Z. 84–88), `exit 2` statt Grün ohne Prüfung. **Nicht erfüllt:** „rot NUR bei `modus=voll` und Z==0" — `modus=voll`/`provision_only` kommen in `ci/`, `scripts/`, `.gitlab-ci.yml` **0-mal** vor; die Hälfte hängt an **D3-7** und bleibt in W0b stehen. | ~0,5 Rest | W0b | D3-7 |
| D3-2 | **ERLEDIGT** (`7444d8c0`, bestätigt 09.08. am Objekt: `grep -cF 'test -n "$(find'` = **0**, Gegenprobe `find` = 22 Treffer ⇒ das Werkzeug sucht). Die Angabe „heute 2" war **veraltet** und widersprach dem eigenen Nachtrag weiter unten in diesem Plan. **Lehre, die teurer ist als der Posten:** eine Abnahme der Form `== 0` ist **ohne Gegenprobe wertlos** — die Null unterscheidet nicht zwischen „Muster ist weg" und „Werkzeug sucht nicht". Literal belegt an einem Bestandsobjekt mit **2 echten** Vorkommen: `grep -cF` → 2, `grep -c` **ohne** `-F` → **stille 0 mit rc=1** (ugrep 7.5.0, `$(` im Muster). Die Abnahme ist jetzt als Fall F10 in `ci/tests/mess_ausbeute_bissprobe.sh` dauerhaft bewacht — mit **gewürfeltem** Köder je Lauf. | 0,5 | W0b | **erledigt** |
| ↳ **Nachtrag 08.08. abends — GEFALLEN, vollständig; und das Kriterium war selbst defekt** | Beide Stationen rufen den Helfer aus: `.gitlab-ci.yml:931` (`measure:smoke`) und `:1023` (`measure:golden-320`), je mit `test -x`-Vorspann. Altmuster: **0** von **1495** Zeilen. **Aber das oben notierte Abnahmekriterium konnte nicht fehlschlagen:** `grep -c` **ohne `-F`** liefert auf diesem Muster (`$(`) eine **stille Null**, unabhängig vom Inhalt — literal gemessen auf einer Datei mit 5 echten Vorkommen: `grep -c` → 0 (rc=1), `grep -cF` → 5 (rc=0). **Gültige Form: `grep -cF`, und die Null gilt erst nach beißendem Köder** (`ci/tests/mess_ausbeute_bissprobe.sh`, Fall F10, tut das). | 0 | erledigt | — |
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
| D5-1 | **Perzentil-KANON**: beide Formeln tragen den Namen „Nearest-Rank" zu Unrecht; Lehrbuch-Formel `ceil(q*n)-1`; `nearest_rank_p` (**38** unbewachte Stellen — *Zahl korrigiert 09.08. am Objekt: 39 Vorkommen an `c98b4b95~1` minus 1 Definition; die Plan-Zahl 34 ist mit keiner von fünf Zählweisen reproduzierbar*) wird **ersatzlos gelöscht** → jede übersehene Stelle bricht compile-time laut; **DREI** Pins mit Klartext-Commit „alle vorher erhobenen p50/p95/p99 ungültig" — *korrigiert 09.08.: p50 51→50 UND p99 100→99 an denselben zwei Teststellen, plus p95 96→95 neu ergänzt (p95 wird in Mess-CSV und Trace-JSON emittiert und wäre ungepinnt geblieben)*. **Einziger Posten, der den Messtermin bewegt** | 6 | **W0a (Lokalspur)** | vor jedem ernsten Messwert |
| D5-2 | Median-Kanon = q=0.5-Fall; Sieger-Kürung, `csv_to_latex`, `diagram_generator` auf EINE Definition; `:1783/:1784` (Mediane ÜBER Konfigurationen) NICHT fälschlich umbauen; `eta_kalibrierung` begründet entscheiden | 3 | W1 | nach D5-1, nach D5-3 |
| D5-3 | **Vorlage-Korrektur:** REV-DATA-12 zeigt auf **lebende** super-Werkzeuge (`Code/04_csv_to_latex/`, `Code/05_diagram_generator/`, letzter Commit 6d837e7d, 07.08.); Disposition-Anker um 239 Zeilen gedriftet → korrigieren | 0,5 | W1 | **ERLEDIGT 09.08.** — Drift **am Objekt bestätigt** (`diagram_generator.cpp` `nearest_rank_median` 414 → **653**, Differenz **+239**; Schwester-Anker `csv_to_latex.cpp:48` **unverändert richtig**). Anker auf **Symbol-Form** umgestellt statt nur nachgezogen; `ci/anker_wache.sh` hält sie (Rot-Lauf mit 414 protokolliert, Grün-Lauf mit 653, Köder beidseitig). Nachtrag in `docs/audits/20260716-wp5-rev-mining-DISPOSITION.md`. |
| D5-4 | `delete_p99_ns` existiert 0-mal → 9er-Feldliste als EINE Konstante, 5 Serialisierer auf den geteilten Helfer, Schema-Test in beide Richtungen (fehlend UND unerwartet) | 1,5 | W1 | mit D5-1-Flächen |
| D5-5 | **ENTSCHIEDEN 09.08. — die Option „entfernen" ist RANGWIDRIG und gestrichen.** Die **Thesis** sagt HDR im Präsens zu, dreifach im gepinnten Stand `798e946`: Aufgabenstellung `de.tex:130` („Perzentile über HDR-Histogramme statt Mittelung"), `03_messsystem_prtart.tex:552` („das HdrHistogram **erhebt** die Latenz-Perzentile (p50/p95/p99)") und `05_evaluation.tex:129` („jede Konfiguration wird … mit über HDR-Histogramme bestimmten Perzentilen vermessen"). Dazu Owner-Primärquelle Termin 3 (09.04., nie widerrufen): *„Perzentile werden nicht gemittelt. **Je Lauf werden HDR-Histogramme persistiert.**"* **Begründung korrigiert 09.08. (Owner): die Rangfolge lautet OWNER > PLAN > THESIS**, mein „die Thesis schlägt den Plan" ist zurückgezogen. Das Ergebnis steht aus zwei stärkeren Gründen: **(1) es schließt sich nicht aus** — HDR ist eine **Erhebungsstruktur** (Buckets, ohne alle Rohwerte zu halten), der Perzentil-Kanon eine **Index-Formel auf sortierten Rohwerten**; zwei Schichten, kein Gegensatz, und **beides zu führen ist gründlicher** (Owner: *„wo mehr Gründlichkeit erreicht werden kann, ein merge zweiter Eigenschaften"*). **(2) Es gab nie einen Plan-Entscheid** — dieser Posten ließ die Frage offen; ein offener Posten kann nichts schlagen. Würde HDR dennoch gestrichen, wären die drei Thesis-Stellen **nachzuziehen** — ausdrücklich erlaubt. **Neuer Auftrag: HDR verdrahten** (heute **0 Produktions-Konsumenten**, selbst gegrept: `latency_hdr_histogram.hpp` wird ausschließlich von `tests/unit/test_ap8_hdr_histogram.cpp` inkludiert) **+ Je-Lauf-Persistenz + 0-ns-Zähler + Toleranz aus `significant_figures=3`**. **Aufwand 2 h → offen, neu zu schätzen.** **Nicht mehr rutschfähig.** | **?** | W1 | nach D5-1 |

**Tragende Abnahme:** Wache druckt `Definitionen: 1` (heute 2); Zufalls-Seed-Test gegen zweitimplementierte Lehrbuch-Referenz (Seed gedruckt); Mutations-Köder (delta ±1 auf gewürfeltem Summanden, nur Testziel neu gebaut) → rc≠0, **vor der Heilung einmal rot gefahren**; Kreuz-Test gerader Länge über Selector/`csv_to_latex`/`diagram_generator` mit Bit-Gleichheit (Achtung: vendorierter ce-Stand in super zeigt auf alten Commit — der Kreuz-Test muss gegen den geheilten Stand prüfen, sonst grün und blind).

> **FUSSNOTE D5-1/D5-3 — DER VENDORING-STAND, am 09.08.2026 gemessen (Nebenbefund aus D5-3; das
> Nachziehen ist NICHT Teil von D5-3, die Feststellung schon — Strang 9 hängt daran).**
> Die Warnung „vendorierter ce-Stand zeigt auf alten Commit" trifft zu, aber **an einer anderen
> Stelle als vermutet**. Drei Zahlen, drei Zustände:
>
> | Was | SHA | Datum | Abstand zu ce-HEAD |
> |---|---|---|---|
> | **gitlink** in super HEAD (`2a787872`; unverändert auch an `7f0f6cb0`), also der *deklarierte* Stand | `25fe4fbfc7751a2aa94a71bd11f89409437c74a7` | 08.08. | **12** Commits |
> | **Arbeitsbaum** des Submoduls `Code/external/comdare-cache-engine`, also was hier *wirklich liegt* | `a1d0c2015abc0a7b6bba79e58448ff31e74bc145` | 07.08. | **97** Commits |
> | **ce `development`** (`wt-ce-xml`), der geheilte Stand | `404ff6cfc7fe7ee2cd6a7e8628424e8c754095b3` | 09.08. | — |
>
> Nicht der gitlink ist das Problem, sondern der **Arbeitsbaum**: er steht **85 Commits VOR** dem
> eigenen gitlink, also **rückwärts** (`git merge-base --is-ancestor a1d0c201 25fe4fb` → rc 0, die
> Gegenrichtung rc 1). `git status` in super zeigt das nur als
> `modified: Code/external/comdare-cache-engine (new commits)` — die harmloseste Zeile, die git für
> diesen Zustand hat. **Am Objekt belegt:** `sh ci/plan_zahlen_wache.sh` bricht heute mit **Exit 2**
> ab, wörtlich *„der ce-Baum am Gitlink-SHA 25fe4fbf… ist nirgends lesbar"* — der Objektspeicher des
> Submoduls kennt den eigenen gitlink-Commit **nicht einmal**. Mit
> `COMDARE_CE_QUELLE=/home/comdare/wt-ce-xml` läuft dieselbe Wache **Exit 0, 5 von 5 Ankern**.
> **Folge für D5-1/D5-2:** ein Kreuz-Test, der in super gegen `Code/external/comdare-cache-engine`
> baut, prüft heute einen **97 Commits alten** ce — er wäre grün und blind, exakt wie oben
> befürchtet. Vor dem Kreuz-Test muss der Submodul-Arbeitsbaum auf den geheilten Stand gezogen
> werden; **das ist ein eigenes Paket (Strang 9)**, kein Nebenschritt.

---

## 3. DAS WELLENSYSTEM

**Betriebsregeln über allen Wellen:** EIN-BLECH-REGEL (max. ein Pipeline-Abnahme-Paket zur Zeit; zweiter Slot nur lokal; Bau und Kampagne exklusiv). **RICHTIGSTELLUNG 09.08., zweifach — erst die Begründung, dann meine Deutung.** Gemessen und gültig: es gibt ZWEI bare-metal-Runner (id=16 prod1/AMD mit AVX-512, id=17 prod2/Intel ohne), **47 von 53 tag-tragenden Jobs beider Repos tragen nur `tags: [baremetal]`** *(Stand `super af82a611`/`ce 59cc9428`; die Zahl wandert mit jedem neuen Job — 44/48 falsch, 45/51 bei `f2ea8fcd` 06:58, 47/53 heute Mittag. **Eine Zahl über eine lebende Datei gilt nur mit Commit-Anker.**)*, und Pipeline 15412 hat am `== Host ==`-Block bewiesen, dass `test:coverage-guard` auf prod2 lief (`Linux prod2`, `GenuineIntel`, i9-12900K) und deshalb vier AVX-512-gegatete Tests als unsichtbar meldete. Beide Mess-Jobs sind echt gepinnt (`tags: [prod, baremetal, amd]`, Jobs `measure:smoke` und `measure:golden-320` — **Symbol-Anker statt Zeilennummer: die alten Anker :923/:1015 sind binnen Stunden auf :1097/:1194 gedriftet**). **Was daraus NICHT folgt** — mein Satz „die zweite Maschine ist kein zweiter Slot, sondern eine zweite Fehlerquelle" ist **zurückgezogen**. Der Owner, wörtlich: *„das war so geplant, dass über das Lager die Maschinen abstimmen, wer welches Batch verarbeitet und es können auch erstmal alle Maschinen alle Jobs aufnehmen"*, und als Kettenglied benannt: *„Hardware-Job-Pool über Maschinenfähigkeiten (gleiche CI für alle Maschinen, custom Filterung der Compiles je Hardware-Freigabe)"*. **Das Floaten ist der Entwurf.** Die Abstimmung läuft über das Lager und über die Hardware-Freigabe je Compile, nicht über GitLab-Tags; ich hatte „kein Tag-Pin" als „keine Koordination" gelesen und damit eine Schicht beurteilt, die die Frage nicht beantwortet. Was als echte Aufgabe bleibt, ist kleiner und schärfer: **jede Wache, die ihren Nenner aus der Hardware zieht, muss die Maschine mit ausweisen** (»457 sichtbar« ohne »auf prod2« ist eine Zahl ohne Gegenstand). Volltext und Fehlerklasse im Ledger unter „RICHTIGSTELLUNG 09.08.2026 — der Befund hält, meine Deutung nicht". Jede Wellen-Abnahme trägt Nenner, Rot- UND Grün-Lauf mit frisch gewürfeltem Köder (K13); eine Welle ohne beißende Wache gilt als nicht abgenommen (V-6, jetzt beidseitig). Abgabefähigkeits-Minimum: jeder Freitag steht allein.

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

Kern-Kette: **##08 zuerst** (`lazy_csv_header` EINMAL — Spaltenvertrag, Header = Resume-Schlüssel; Schema-Freeze Stufe 1), **D3-7 → D3-1 → D3-2 → D3-3 → D3-4+D3-5 → D3-8**, D2-G5, ##26 (korrigierte Formel). *(Nachtrag 08.08. abends: **D3-1-Kern und D3-2 sind bereits gelandet** — `ci/mess_ausbeute_wache.sh`, `7444d8c0`, beide Stationen. Die Kette beginnt damit real bei D3-7, dessen Marker die noch offene D3-1-Hälfte freischaltet; Belege in der D3-Tabelle oben.)* Transport: **##20+D3-6 als EIN Paket** (AF_GENERATOR belegen UND Selektor trifft beide Layouts — einzeln geheilt bleibt der einzige Transport zu), ##21, ##22, ##23 (NAHT, eigener Besitzer), **##25 DURCHSTICH** (frischer Mini-Lauf, 1 Binary, 1 Perm, Minuten). Nachrangig: ##24 (A9-S5a — fällt zuerst bei Riss), F-13. Nachlauf bis Di 18.08.: ##27–##30, ##31 (Wachen-Register: Grundmenge = alle `.sh` beider Repos + verdiktdruckende Jobs **+ ctest-Tests mit `PASS_REGULAR_EXPRESSION`** — neue Klasse aus dem D4-Querbefund; Köder GEFAHREN; Rückfallstufe bei Riss: manuell versioniert + die je D-Posten gefahrenen Köder-Protokolle).
**F1-Lieferung:** kein Glied kann mehr still leer sein, UND ein am Mittwoch frisch gemessener Mini-Messwert liegt am Freitag als Tabellenzeile im Thesis-Submodul (Kette: Lauf-Marker → Inhalts-Gate → persist-Commit → xlsx im Realm-Baum → `anhang:forward` → PDF baut; jede Stufe druckt ihren Nenner).
**Parallelität 2:** Helfer/Unit-Köder lokal; nur die CI-Beweisläufe seriell.
**Blockiert durch:** W0a; Owner-Entscheide OV-16 (allow_failure) und OV-17 (result.csv-Konvention) bis Mi 12.08.

### W1 — STATISTIK-GLIED + MENGE + HY-A · Mo 17.08.–Fr 21.08. = **F2 = IDENTITÄTS-FREEZE**

Statistik: **D4a → D4b → D4c** (Reihenfolge zwingend, D4c ist vorher blind), **D4d** (die EINE Spaltenänderung der Woche, danach Header-Freeze Stufe 2), D4e (nach ##07), D4f (nach OV-6-Lage), D5-3 → D5-2, D5-4, D5-5. Menge: ##10+##10b (`--check-size`, zwei Zahlenreihen + EIN gemessener Punkt bei working_set 8.388.608), ##11 (`<measure_selection>`), ##12, ##13 (G3-Split), ##14 (**Sperrlisten-Wache = Freeze-Gate**, maschinell aus `kAnatomyFingerprintGliedCount = 9`), ##15 (§59-SCHEMA als hartes W3-MESS-Vor-Gate; EMITTER/TEMPLATE bei Slack), ##16+##17 (nach OV-1), ##19, ##09 (nachrangig). **HY-A1–A3** (nach OV-13-Bestätigung + OV-12 + 4.-Ebenen-Entscheid Mi 19.08.): Gattung `HEURISTIK-ADAPTER`/Genus `Function-Interface-Reroute` — `hybrid_dock_contract` + `hybrid_pruef_dock` + factory/array (CT-Interface-Vererbung, `variant` NUR im DockSlot), `hybrid_binary_proxy` + `hybrid_tier_module.cpp` (4 ABI-Pflicht-Symbole) = **F8-Minimal-DoD** (genau 1 Standard-Dock, ctest-bewiesen, Reroute auf 2 plain-Tier-Ziele), `<hybrid_tier>`-Parser + Heuristik-Hybrid-Achse in die Registry (22→23, beide Zahlen) + Fehlerklassen. Abgabe-Vorlauf: ##42, ##43, ##44, ##45. **Entwicklung** (nicht Landung) der W2-Landepakete: ##32, ##33, ##35, ##36 (T-15+D4), ##37, ##38, ##39. **An F2:** OV-4-Deckel-Vorlage MIT beiden `--check-size`-Zahlenreihen beim Owner.
**Sa 22./So 23.08. = benannte Entnahme-Option NUR für HY-A-Fertigstellung.**
**Parallelität 2:** Statistik-Header + HY-A sind rein lokal (CT); Mengen-/CI-Pakete bündeln ihre Beweisläufe seriell.
**Blockiert durch:** W0b (F1); OV-13/OV-12 (Owner); OV-1/OV-6 für ##16/##17/D4f.

### W2 — EIN BUMP, ANKER, BAU · Mo 24.08.–Fr 28.08. = **F3**

**Mo:** das EINE Lande-Ereignis — Bump-Bündel ##32+##33+**##34** (~~genau EIN Magic-Wechsel 4→5 im Gesamtfenster~~ — **KORRIGIERT 09.08.2026, zwei Gründe:** die Angabe „4→5" ist ein **unbereinigter Textrest** aus einer Fassung, in der Major noch bei 4 stand (INC-2b hat am 17.07. auf 5 gebumpt, war zur Niederschrift also schon Geschichte); die Parallelstellen §4:535 und §6:616 tragen sie zu Recht **nicht**. **Und der Wechsel ist bereits gefallen:** `d4c0b49c` (NAHT-1, Major **8→9**) am 09.08. Der ##34-Filter selbst gefahren, mit Nenner — 159 Commits im Fenster [08.08., 10.08.], davon 2 an der Magic-Definitionsdatei, davon **1** echte Wertänderung. **Das Budget ist verbraucht, der Schaden heute null** (es ist noch nichts Großes gebaut). Folge: die **NULL-BUMP-Regel gilt ab sofort**, nicht erst ab dem 24.08. — wer zwischen heute und dem Bau-Trigger am 26.08. 06:00 bumpt, bricht den Freeze und entwertet 41,4 h Bau. Die Wache dazu existiert noch nicht und ist damit ein **vorgezogener** W2-Posten, **HY-Ebenen-Entscheid eingerechnet** — bei „hybrid-lokal" bleibt HY außerhalb des Stempels; nach dem Bündel-Tag gilt **NULL-Bump-Wache** bis zur Abgabe), ##35 (Resume-Beweis: Abbruch nach 2 Batches, Neustart überspringt), **##36 = T-15 verdrahten MIT D4 als Schritt 1** (nie eines ohne das andere; Rerun-Deckel gesetzt, Rerun-Rate wird im Kalibrierlauf erhoben), ##37, ##38 (klein), ##39, ##41. **Di:** ##46 (Anker + TP1-FINAL, drei Spiegel), ##47 (Kalibrierlauf `GN_TOTAL=64` — **fährt durch alle W0b-Gates**, erster Ernstfall der Messweg-Ehrlichkeit; Menge unabhängig per Teilbaum-Auszählung, Einwand 29), ##48 (§66 G1–G5 + **Platten-Budget: benötigt_GB und frei_GB BEIDE gedruckt VOR dem Trigger** — 43 G frei bei 83 %), ##41b (gefahrene Kaskade Parent/Child/Grandchild mit Job-IDs — und dank D3-4 kann der Grandchild jetzt **rot** werden, sonst ist die Kaskade kein Beleg). **Mi 26.08. 06:00:** ##49 Bau-Trigger (~41,4 h = 128 × 19,4 min; **KIPP-PUNKT**: spätester tolerierbarer Start Fr 28.08. 06:00, danach fällt das W4-Fangnetz — steht dann als Zahl im Protokoll). **Do abends:** Bau fertig, ##50 Zweitlauf (`built_new==0`, `lager_skip==N`, `skip_ohne_testlog==0`). **Fr:** ##51 USER-GO-VORLAGE (EINE Datei: 320er + gedeckelte Teilmatrix via `<measure_selection>` MIT Zahlen, HY-B-Teilmatrix daneben, prod2-Entscheid eingearbeitet) = **F3**. `ergebnis:holen` wird scharf (D3-8 steht seit W0b).
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
 D2-G4 [lok] ERLEDIGT 09.08.: Abnahmetext ##06 korrigiert (erfuellt ODER Allowlist
            mit Begruendung), 18/14 statt 15/8, Zaehl-Skript + Allowlist gelandet.
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
 D3-2 [lok] ERLEDIGT (7444d8c0): smoke-Stelle auf denselben Helfer. Die hier zuvor
            notierte Formel  grep 'test -n "$(find' == 0  war SELBST defekt: ohne
            -F liefert ugrep auf diesem Muster eine stille 0 (rc=1), unabhaengig
            vom Inhalt. Gueltig ist grep -cF == 0 NACH beissendem Koeder und MIT
            Nenner -- gefahren 09.08. als Fall F10 in
            ci/tests/mess_ausbeute_bissprobe.sh: 0 Vorkommen von 1858 Zeilen,
            Koeder 4 gewuerfelt / 4 gefunden, 12 von 12 Faellen gehalten.
 D3-3 [CI]  persist: Zeilen statt Dateien; leer = KEIN Commit (Git-Zustand-Beweis).
 D3-4+D3-5 [lok+1 CI-Beleg] lebender Mess-Job: Inhalts-Gate je Batch; Testat-XOR;
            Bilanz A+B==C; allow_failure gemaess OV-16; Byte-Determinismus-Tests
            im selben Commit.
 D3-8 [lok] Frische-Kennung (PIPELINE_ID); Altbestand gemeldet, nie geloescht.
 D2-G5[lok] Host-Klassen-Bericht GEBAUT: 6 ISA-Registrierungen, davon 4 an AVX-512
            und 2 an AVX2 (Richtigstellung 08.08., s. Fussnote D2-G5). 3 Zahlen immer.
            NACHSATZ 09.08.: GEGENORAKEL GEFAHREN -- CMake bestaetigt 4/2 namentlich
            (Triple-Configure ce 25fe4fbf, Eintraege 429/425/423, s. Fussnoten-Nachtrag).
 20+D3-6 [CI, EIN Paket] anhang:forward: AF_GENERATOR belegt UND Selektor findet
            BEIDE Layouts; NO-OP nur mit Nenner. P1/P2/P3 gefahren.
            NACHSATZ 10.08. (##20-B, s. Fussnote): die Zeile "|| true beim git add
            faellt" NICHT so bauen -- DE-only gegen ein Ziel ohne anhang/en ist
            damit rc=128 (gemessen, ohne Pipe). Ersetzen statt streichen:
            git add --pathspec-from-file="$COPIED_LIST" -- , dazu die Zeile
            "im Index: N von M kopierten Datei(en)" und Abbruch bei N != M.
            Der echte Defekt ist ein anderer: faellt git add aus anderem Grund
            (gemessen: stale index.lock), meldet der Kanal "IDEMPOTENT: 0
            Aenderungen", Exit 0, und 0 von 2 Messwerten landen. Offen vor Bau:
            git-Version auf dem baremetal-Runner (--pathspec-from-file ab 2.25).
 21   [CI]  Realm-Wurzeln /mnt + G-E3 + COMDARE_BESTANDSLOG in beiden CI.
            ACHTUNG V-3/V-8: "steht in beiden CI" ist Praesenz in der YAML, also
            reine Ankuendigung. Abnahme sind die aktiv-Zeile (Feldgleichheit, via
            ci/bestandslog_wache.sh) UND ein object_stat am Store. Nur die erste
            Haelfte ist mit LAG-P1 gelandet; die zweite ist offen.
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
 D5-3 [lok] ERLEDIGT 09.08.: Dispositions-Korrektur (lebende Werkzeuge, Anker
            414 -> 653-659 = +239, jetzt Symbol-Anker + ci/anker_wache.sh).
 D5-2 [lok] Median-Kanon ueber ce+super (Kreuz-Test gerade Laenge, Seed gedruckt).
 D5-4 [lok] delete_p99_ns + EIN geteilter Helfer + Schema-Test beidseitig.
 D5-5 [lok] HDR VERDRAHTEN + Je-Lauf-Persistenz (0-ns-Zaehler, Toleranz hergeleitet). [NICHT rutschfaehig -- Thesis-Zusage, s. Posten-Tabelle]
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

`##01 → ##02 → D1+D1a (W-1) → D2-G4 → D1e → ~~D1b~~ → D1f → D1c → D2+D2-G2 → ~~D2-G1~~ → D5-1 (W0a) → ~~##08~~ → ~~D3-7~~ → D3-1 → ~~D3-3~~ → D3-4+D3-5 → ~~##20~~+~~D3-6~~ → ~~##23~~ → ##25 DURCHSTICH (F1) → D4a→D4b→D4c → D4d → ##10+##10b → ##11 → ##13 → ##14 → ##15 → HY-A1→A2→A3 (F2/FREEZE) → ##32/##33/##34 Bump-Bündel → ##35 → ##36 (T-15+D4) → ##46 → ##47 → ##48 → ##49 Bau 41,4 h → ##50 → ##51 (F3) → GO×2 → ##53+HY-B → ##56 (F4) → ##57/HY-C → ##58/##58b → ##59 → ##60+P-1 (F5) → ##62.`

> ⚠️ **KORREKTUR-EINSCHUB 10.08.2026 zur Kette oben.** Die durchgestrichenen Glieder sind durch die
> F1-Kern-Explores erledigt oder gestrichen (Fußnote **F1-KERN**). **Die Kette bis `##25 DURCHSTICH`
> ist damit leer** — der Durchstich hängt nicht mehr an ihnen. Er hängt an einem Riss, den erst der
> gefahrene Mini-Lauf zeigte: `measurement_line` ist **len=0**, weil der Perm-Pfad den
> 2-arg-Zweig von `COMDARE_ANATOMY_VERSION_STAMP` trifft. **Und die Reihenfolge ist verkehrt** —
> Owner 10.08.: *„system sollte immer vorn stehen und organ hinten. Das entspricht der Anordnung der
> Stufen."* Zwei Änderungen, nicht eine; wer nur den leeren Stempel heilt, zementiert die
> Stufen-Ordnung falsch. Das ist der **einzige** verbleibende Blocker vor F1.

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
| **V-8 GEGENSTAND STATT ANKÜNDIGUNG** *(neu 09.08.; hebt §11.4-Prüffrage 2 in den operativen Vertrag)* | Zu **jeder** Formel gehört die Antwort auf: **„Was wäre der Zustand, in dem diese Ausgabe erscheint und die Sache trotzdem nicht existiert?"** Gibt es ihn, prüft die Formel am **Gegenstand** (Datei auf der Platte, Objekt im Store, Symbol im Binary), nie an der **Ankündigung** (Log-Zeile, YAML-Eintrag, `message()` zur Configure-Zeit). Zwei am Objekt gemessene Belege: **LAG-P1** — die Zeile `[bestandslog] aktiv: doc_key=…` fiel, der Schreibweg scheiterte **danach** (`fehlerklasse=reservierung_nicht_gespeichert`), und die Emission lief **ohne Abbruch** weiter; wer nur die aktiv-Zeile prüft, hält ein **leeres Lager für scharf**. **D3-2** — eine Null gilt erst nach einer **Gegenprobe im selben Lauf**. **V-4 genügt dafür ausdrücklich nicht:** seine zwei Zahlen werden zu **zwei verschiedenen Zeitpunkten** erhoben und belegen deshalb nichts darüber, ob das Werkzeug im Moment der Null überhaupt noch sucht. |

**Wachen-Register (##31):** Grundmenge = alle ausführbaren Dateien unter `ci/`+`scripts/` beider Repos + alle verdiktdruckenden CI-Jobs **+ alle ctest-Einträge mit `PASS_REGULAR_EXPRESSION`** (Wachen, deren Verdikt ein Textmuster ist — dort ist der Nenner am leichtesten zu fälschen; D4-Querbefund). Nenner nach D3-1: super `scripts/`+`ci/` = **6** `.sh`. Abgleich beidseitig rot; Köder werden vom Job GEFAHREN. Rückfallstufe bei Zeitriss: manuell versioniertes Register + die je D-Posten ohnehin gefahrenen Köder-Protokolle (deklarierte Grenze: neu entstehende Wachen machen dann nichts rot — W7-Posten).

**STELLVERTRETER-DURCHGANG 09.08. (V-8 auf den Bestand angewandt) — mit Nenner.** Geprüft wurden **56 Formeln**: die **51** Wellen-Formeln dieses Abschnitts (maschinell an ` · ` getrennt gezählt: W-1 5, W0a 7, W0b 9, W1 11, W2 8, W3-MESS 4, W4/W5 7) und die **5** Blöcke „Tragende Abnahme" aus Abschnitt 2. Ergebnis: **4 gehärtet, 52 halten.** Gehärtet sind ##02, D1d, der W0a-DLL-Zähler und ##56 — jeweils oben im Text, jeweils mit dem Zustand benannt, in dem die Ausgabe erscheint und die Sache trotzdem fehlt. **Zwei weitere Defekte lagen außerhalb dieses Nenners, in der Aufgabenkette (§4), und sind dort geheilt:** die D3-2-Zeile trug die `== 0`-Formel ohne `-F` und ohne Gegenprobe, Posten 21 prüfte Präsenz in der YAML statt des Stores. **Ausdrücklich gehalten haben** die köder-getriebenen Formeln (W0a-Bedingungstabelle mit 19. Registrierung auf beiden Wegen, D2-G6-Stash-Köder, D5-1-Mutations-Köder mit Seed, HY-A-Roundtrip mit gewürfeltem Token) sowie ##34 und ##53 — ##34 druckt seine Commit-Zahl als Nenner **zur selben Zeit** wie die Null, und ##53 benennt seinen eigenen Stellvertreter im Klartext (*„Zeilenzahl > 0 ist wertlos — der Bau-Fehler-Zweig schreibt formal vollständige CSVs"*). Beide sind die Musterform und wurden **nicht** angefasst.

**Je Welle (Nenner + tragende Zeilen; die vollständigen Abnahme-/Köder-Definitionen der D-Posten aus Abschnitt 2 sind Vertragsbestandteil):**

**W-1** (Nenner 6): ##01 `rev-list --count` 29→0, beide Zahlen · **##02 `diff --stat` 17→0 — gehärtet (V-8):** die **0** gilt erst mit einer **Gegenprobe im selben Lauf** (derselbe Aufruf gegen ein bekannt abweichendes Ref-Paar muss > 0 liefern) und mit `rc` **direkt hinter** dem Aufruf (K11); eine leere `diff`-Ausgabe entsteht auch bei vertauschtem Ref-Paar und bei einem Pathspec, der nichts trifft — beides sieht wie „gelandet" aus · D1/D1a: `make check` 427→431 literal, `make` allein 0→53 `.so` (6329→6749 ninja-Ziele), Doppel-Köder beider Gate-Familien vorher unsichtbar-grün/nachher rot · **D1d: `grep -rnF '404 statt 406'` = 0 — gehärtet (V-8):** gültig erst nach **beißendem Köder im selben Lauf** (gewürfelte Zeichenkette an bekannter Stelle, muss gefunden werden) **und mit `--no-ignore`**. Grund, am 09.08. mit frisch gewürfeltem Köder nachgemessen: der Agent-`grep` ist **ugrep 7.5.0** (Shell-Funktion; `/usr/bin/grep` ist GNU grep 3.11) und überspringt via `--ignore-files` still alles, was `.gitignore` deckt — dort stehen u. a. `*.so`, `*.csv`, `*.log`, `build/`. Der Köder lag zweimal aus, **gefunden wurde 1 von 2, und `rc` blieb 0**: diese Null trägt nicht einmal ein Fehlersignal · jede verbleibende Kommentar-Zahl mit Datum+Kommando · ##04/##05 wie v1, jetzt erfüllbar.

**W0a** (Nenner 14): **test:unit-Job druckt Job-ID + `out of 431` + `R5.G … ACTIVE (48 auto-gebaute DLLs)` (heute 429, beide Zahlen) — gehärtet (V-8):** dazu die DLLs **auf der Platte gezählt** im selben Job (`find … -name '*.so' | wc -l` == 48). Die R5.G-Zeile ist eine **CMake-`message()` zur Configure-Zeit** (`tests/unit/CMakeLists.txt:1575`, gedruckt wird die Listenlänge `${_r5g_autobuilt_count}`) — sie fällt, **bevor irgendetwas gebaut ist**, und meldet 48 auch dann, wenn anschließend 0 `.so` entstehen. `out of 431` bleibt tragfähig, weil es ctest selbst über einen gefahrenen Lauf druckt · Wache druckt DREI Zahlen aus DREI Quellen (V-7), Zahl-Köder 345 → rot, Schrumpf-Köder N per `shuf` → rot mit N, Gegenköder grün · Bedingungs-Tabelle (korrigiert D2-G4, s. Fußnote): `bedingte_registrierungen: 18 / bedingungs_klassen: 14 / erfuellt: 12 / allowlist_mit_begruendung: 6 / ohne_allowlist_eintrag: 0 / allowlist_zusicherung_verletzt: 0`, jede Ausgabe mit Host-Kennung; **19. Köder-Registrierung hebt den Zähler maschinell auf 19 und wird namentlich rot — auf BEIDEN Wegen: unter einer neuen Bedingung (`ohne_allowlist_eintrag=1`) wie unter einer bereits allowgelisteten (`soll=4 ist=5`, s. Nachtrag D2-G4/Z)**, Gegenprobe bleibt bei 18 grün · D2-G1: `ctest -N` +2, Erstlauf-Ergebnis mit bestanden/gesamt gebucht · D2-G6-Stash-Köder: XML weg → rot mit Namen und `Inventur 426, Untergrenze 428, Differenz -2` · D5-1: `Definitionen: 1`, Pin 51→50, Mutations-Köder rc≠0 mit Seed · D1g: zwei `ctest -N`-Zahlen aus einem gefahrenen super-Configure-Paar, Ursache im Kommentar benannt.

**W0b** (Nenner 17 + 5 Nachlauf): D3-1-Proben P1 (Kopfzeile, `$K` im Pfad der Fehlerzeile) rot / P2 (eine Datenzeile `koeder_$K`) grün mit `datenzeilen_gesamt=1` / P3 (leer) rot mit `csv_gesamt=0` — heute P1/P3 grün, Vorher-Läufe protokolliert *(Nachtrag 08.08. abends: **gefahren und gelandet** — `ci/tests/mess_ausbeute_bissprobe.sh` mit `--selbstbiss`, im CI als `test:mess-ausbeute-bissprobe` ohne `allow_failure`; die Köder werden je Lauf gewürfelt, nicht abgeschrieben. Offen bleibt allein die Marker-Auswertung aus D3-7.)* · ##26 in korrigierter Formel `N>=1 UND M==N UND Z>=1` · Marker: fehlend = rot, `provision_only` nicht fälschlich rot, gefälschter `modus=voll measured=0` rot · persist-Beweis am Git-Zustand · Testat-XOR: gewürfelte Fehl-Zelle → genau 1 `[FEHLER-TESTAT]`, C−1 `[MESS-TESTAT]`, Bilanz stimmt (heute C+1 Testate) · Frische-Zwei-Lauf-Köder · D3-6: P1 Produktions-Layout heute unsichtbar → danach im WIDE-Aggregat, P3 NO-OP mit `laufordner_geprueft=1 / mit_material=0` · ##23/##23b wie v1 (Zeilenzahl je Blatt gegen Eingangs-CSV; SKIP-Zweitlauf zwei Zahlen) · **##25 DURCHSTICH:** Submodul-Diff zeigt die Tabellenzeile mit dem gewürfelten Mini-Lauf-Token; PDF baut; jede Stufe hat ihren Nenner gedruckt.

**W1** (Nenner 26): D4-Invarianz (identische `adjusted_p` 7-vs-9; benannter Kipp-Kandidat) · `win_rate` nur noch mit Nenner-Klammer · f15-Summenzeile nachgerechnet, Exit≠0 bei degeneriert (rc direkt hinter dem Aufruf, K11) · D4d: Spaltenzahl vorher/nachher, Null-Vektor ≠ success, Gegenprobe (31 Nullen + 1 echter Wert) · ##10 zwei Zahlenreihen + ##10b ein gemessener Punkt bei 8.388.608 · ##11 Deckelung liefert kleinere Zahl; nicht deklarierte Perm = Fehlerklasse · ##13 `nm` auf benannte micro-Symbole, Stempel-Region ausgenommen (v1-##13 bleibt) · ##14 Preimage-Wache: 10. Glied → rot · HY-A: F8-DoD grün in ctest (Zahl vorher/nachher), Reroute-Roundtrip-Köder (gewürfeltes Token durch das Dock zu 2 plain-Zielen und zurück), nicht deklariertes Ziel bricht compile-time laut, Registry 22→23 · Kreuz-Test Median (Bit-Gleichheit, gerade Länge) · Fr 21.08.: OV-4-Vorlage liegt MIT Zahlen beim Owner.

**W2** (Nenner 12): ##34 `git log -p`-Filter aufs ABI-Magic = **genau EIN** Wechsel im Gesamtfenster, **NULL nach Mo 24.08.** (Commit-Zahl als Nenner gedruckt) · ##35 zwei Zahlen (Abbruch nach 2 Batches, Neustart überspringt; heute Start bei 0 = rot) · ##36 **zwei degenerierte Zellarten getrennt**: Null-Fenster → `MESSUNG DEGENERIERT … unbestimmbar` (kein Rerun), echte Streuung → `reruns: n`; `ZeroMedianGuard` im selben Commit umgedreht; Zensus-Zähler Produktion ≥ 1 mit Dateiname · ##47 ETA gegen unabhängige Teilbaum-Auszählung, Abweichung > 50 % = Abbruch; Kalibrierlauf passiert alle W0b-Gates (das IST der U-02-Vollzug) + erhobene Rerun-Rate · ##48 5/5 mit Nenner + `benoetigt_GB`/`frei_GB` beide gedruckt · ##50 drei Zahlen · ##41b drei Job-IDs + ein absichtlicher Zell-Fehlschlag färbt den Grandchild rot · ##51 EINE Datei.

**W3-MESS** (Nenner 7): ##53 `zellen_mit_echtem_messwert/zellen_gesamt` + Häufigkeit JEDES Ersatz-Tokens (Single-Source `measurement_curve_loader.hpp:72`), alle Zahlen im Log UND im Exit-Code; `nicht_gebaut > 0` = Abbruch vor der Auswertung („Zeilenzahl > 0" ist wertlos — der Bau-Fehler-Zweig schreibt formal vollständige CSVs); „echt" = D4d-Definition · Batch-Abende: Bilanz, Gate, Frische — je Batch protokolliert · HY-B: Overhead-Kurve je Zielanzahl mit n je Zelle; eine tote Reihe kann nicht mehr gewinnen (D4e-Nachweis) · **##56 Commit nur bei Substanz, PROVENANCE trägt die Zahl — gehärtet (V-8):** dazu **`object_stat` gegen den minio-Store** nach dem Lauf (Schlüssel trägt das gewürfelte Lauf-Token, `size > 0`), und dasselbe für den NAS-Pfad. Der Git-Stand allein ist die **Ankündigung**, nicht der Gegenstand: genau hier saß LAG-P1 — die aktiv-Zeile fiel, der Schreibweg scheiterte **danach**, die Emission lief ohne Abbruch weiter. Die Bestandslog-Wache sagt das über sich selbst ausdrücklich (`ci/bestandslog_wache.sh:15-18`: *„ZUSICHERT NICHT: dass das Bestandslog-Dokument im Objekt-Store wirklich entstanden ist … sie gehoert an ein object_stat"*) — die fehlende Hälfte ist damit **benannt, aber unerledigt**, und sie gehört in diese Abnahme.

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
| ##24 A9-S5a (Archiv-xlsx), ##15-EMITTER/TEMPLATE | nachrangig / rutschfähig — fallen zuerst bei lokalem Riss (**D5-5 am 09.08. hier entfernt: Thesis-Zusage, nicht rutschfähig**) | kein Rückbeleg über den Alt-Korpus (der Fassung-3-Beweis hängt am frischen ##25 — der ohnehin allein etwas über die September-Kette aussagt) |
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
| An-8 | Consumer-Silizium mit abgeschaltetem AVX-512 verliert **4** ISA-gattierte Registrierungen (D2-G5, am Objekt gezählt 08.08.). ~~424 statt 428 Tests auf prod2~~ — die **Differenz −4** ist bestätigt, die **absoluten** Zahlen 424/428 sind es NICHT (s. Fußnote D2-G5: andere Einheit, kein gebauter Baum) | Differenz: **gemessen** über `scripts/ci_host_klassen_bericht.sh`, drei ce-Stände, gleiches Ergebnis. Absolute ctest-Zahl je Host: ~~ungemessen, weil prod2 nicht existiert~~ **Nachtrag 09.08.: je KLASSE jetzt gemessen, ohne prod2** — `ci_host_klassen_gegenorakel.sh` (Host-Antworten als `-D`-Preset, maschinenunabhängig): am Stand `25fe4fbf` **429/425/423** Einträge (avx512f/avx2/basis), configure-only, s. Fußnoten-Nachtrag D2-G5 |
| An-9 | ~~super-Zahlen 610/186~~ | **GEMESSEN 10.08.2026, und BEIDE Erklärungen sind widerlegt.** D1g hat ein Configure-TRIPEL gefahren (ce-Pin `2eb310ae`, cmake 4.3.4, Ninja 1.13.1, reiner Default, kein Bau): *as-is* → `Total Tests: 488`, `-L da_unit: 10` · *`enable_testing()` vor das ce-`add_subdirectory` gezogen* → **488 / 10** · *`EXCLUDE_FROM_ALL` an BEIDEN Stellen entfernt* → **488 / 10**. **Sechs Zahlen, kein Unterschied.** Der Grund steht in ce selbst: **ce ruft sein eigenes `enable_testing()` vor seinem eigenen ersten `add_subdirectory`** — ein Kind, das das tut, ist gegen Reihenfolge UND `EXCLUDE_FROM_ALL` des Elternscopes immun. **Woran die Zahl wirklich hängt: an dem, was GEBAUT wird.** `gtest_discover_tests` legt für ein ungebautes Ziel den Platzhalter `<ziel>_NOT_BUILT` an — hier **20 der 488** Einträge —, und ein Platzhalter trägt **keine Labels**, fällt also aus `ctest -L da_unit` heraus. Dieselbe Klasse wie der 2-Pass-Befund (488 ohne / 492 mit): **zur Testzahl gehört der BAU-ZUSTAND, nicht nur der Commit** (V6.5). Die alten Zahlen 610/186 sind damit **nicht reproduzierbar** und werden nicht übernommen. Keine Zeile Bau-Logik geändert. Gelandet als super `41b20a16`. |
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
---

# 11. KONSOLIDIERUNG DER ERKENNTNIS-SESSION (nachgetragen 08.08.2026 abends)

> Quelle: `docs/sessions/20260808-SESSION-ERKENNTNISSE-widerlegte-befunde-und-learnings.md`
> (50/50 Agenten, 0 Fehler; 381 Befunde und 316 Learnings aus 8 Quellbereichen, davon **40
> adversarisch geprüft**: 27 hielten, **13 fielen selbst**).
> Dieser Abschnitt ändert die Abschnitte 3 und 6 dieses Plans — er steht nicht daneben.

## 11.1 Die eine Zahl, die den Verifikationsvertrag ändert

**32,5 % der Widerrufe hielten der Nachprüfung nicht stand.** Rund jeder dritte. Und „bestätigt"
hieß nur, dass der *Schluss* trägt: in **9 von 9** vollständig protokollierten Bestätigungen ergab
die Prüfung Schärfungsbedarf, in **mindestens 4 von 9** enthielt der Widerruf selbst eine am Objekt
**falsche** Einzelaussage. Sogar die **Fehlerklassen-Etiketten** mussten in 4 von 9 Fällen ersetzt
werden.

**Konsequenz für den Plan:** eine Korrektur ist kein Endzustand. Der Verifikationsvertrag (§6) gilt
ab sofort **auch für Widerrufe, Richtigstellungen und Klassifikationen** — nicht nur für Befunde.
Es gibt in dieser Arbeitsweise keine Aussagenebene, die von der Beweislast ausgenommen wäre.

## 11.2 Der Stellvertreter — die gemeinsame Mechanik aller Klassen

Alle vier Klassen sind derselbe Griff: **etwas Benachbartes, Billigeres wird für den Gegenstand
genommen.** Der Nullbefund des eigenen Musters für den Gegenstand · der Gesamtstatus für die
Jobliste · der belegte Kern für seine unbelegte Reichweite · das Dokument für den Ist-Zustand ·
die plausible für die gemessene Ursache. Fünfzehn Belege nach demselben Schnittmuster.

**Warum es nicht auffällt** — und das ist der Satz, der die Abnahmen ändert:

> Ein **falsches** Messgerät fällt irgendwann auf. Ein **richtiges** Messgerät am **falschen
> Gegenstand** nie — es gibt nichts, was klappern könnte.

Die Messung ist korrekt, die Zahl belastbar, das Gate grün, das Gewissen rein. Diese Fehlerklasse
**erzeugt kein Fehlersignal**.

## 11.3 Die härteste Konsequenz: Disziplin trägt hier strukturell nicht

Am Objekt gemessen: von zehn Verschärfungen hielten **7 von 10** — und es sind genau die, die **in
ein Werkzeug gebrannt** wurden. Die **drei rein disziplinären** (R-3, R-6, R-10) sind exakt die, die
zurückkamen. Die einzige durchgängig gehaltene Verschärfung (cf22-Selbstcheck, **6 von 6**) steht
**in einem Skript, nicht im Kopf**.

Und dreimal hielt eine Regel nur scheinbar: die gitleaks-Deckung hielt **zufällig** (27 von 37
Pushes ohne Lauf, unbemerkt), die Ein-Schreiber-Regel hielt, weil fremde Agenten 21 Stunden **still
waren**. **Zufall, Disziplin und Maschine sehen im Rückblick identisch grün aus.** Unterscheidbar
sind sie nur an einer Frage: *was erzwingt das Halten?*

> **NEUE ABNAHME-REGEL FÜR JEDE WELLE (ändert §6):** Zu jeder Wellen-Abnahme gehört die Antwort auf
> „**was erzwingt das Halten?**". Zulässig sind genau zwei Antworten: **ein Werkzeug** (Skript,
> Wache, `static_assert`, CI-Job) oder **eine ausdrücklich als ungedeckt benannte Stelle**.
> *„Wir achten darauf"* ist keine Antwort und gilt als **nicht abgenommen**.

## 11.4 Die fünf Prüffragen vor jedem Paket

Sie ersetzen keine Wache — sie stehen **vor** dem Bau, weil sie billig sind und die Klasse ohne
Fehlersignal nur so früh gefangen wird.

1. **Der Nenner.** Über welcher Grundgesamtheit rechne ich, und steht sie in der **Ausgabe**?
   Alle Klassen lassen sich auf einen fehlenden Nenner zurückführen: die Menge, die mein Muster
   überhaupt finden **kann** · die Jobs, die wirklich **liefen** · die Commits, die wirklich
   **gescannt** wurden · die Fälle, über die der Fakt etwas **sagt** · der **Zeitpunkt**, zu dem die
   Aussage galt. Der wirksame Fix ist überall derselbe: **den Nenner in die Ausgabe des Werkzeugs
   zwingen.**
2. **Der Gegenstand.** Misst mein Beleg *die Sache* — oder etwas Benachbartes, das billiger zu
   messen war? (Diff statt Funktion · Gesamtstatus statt Jobliste · `rc=0` statt „0 commits
   scanned" · Worktree statt Klon · `$?` statt `PIPESTATUS`.)
3. **Die Zeitrichtung.** Lief die Messung **vor** dem Satz? **6 von 6** Selbstwiderlegungen kamen,
   *nachdem* die falsche Aussage schon beim Owner war; wo die Messung vorher lief, fing sie
   **4 von 4** (V11). Und die Umkehrung: eine Messung, die *lange vorher* in einem Kommentar
   dokumentiert wurde, ist **keine** Bestätigung — genau daran ist D1 heute als Fehlbefund entstanden.
4. **Die Deckung.** Was erzwingt, dass diese Regel morgen noch hält — Werkzeug, Disziplin oder
   Zufall? Nur die erste Antwort zählt.
5. **Der Widerruf.** Wenn ich gerade etwas korrigiere: **prüfe ich die neue Aussage genauso hart wie
   die alte?** In 13 von 40 Fällen war die Antwort nein, und in allen vier auswertbaren Fällen war
   es die **Fassung**, nicht der Kern — *Korrektur-Momentum ersetzt die Prüfung der neuen Aussage.*

## 11.5 Die Schleife, die den Plan selbst gefährdet

Das Material misst eine Rückkopplung: **Breite → Takt → Stellvertreter → Aussage vor Messung →
Korrekturschleife → weniger Zeit → mehr Breite.** Belegt an 9 Workflows mit 114 Agenten, von denen
**1 von 9 auf dem fristkritischen Pfad** lag.

Und: *„die zuerst fallende Stufe ist das **Gedächtnis**, weil sie vorne kostet und hinten nichts
Sichtbares liefert, während ein Explore-Agent wie Fortschritt aussieht."*

> **KONSEQUENZ FÜR DIE WELLEN:** Ein Workflow ist ab jetzt **kein Fortschritt**, solange sein
> Ergebnis nicht in einem Bau-Paket auf dem kritischen Pfad gelandet ist. Vor jeder Fan-out-Runde
> steht die Frage: *liegt das, was ich gerade breit untersuche, auf dem Weg zum 15.09.?* Wenn nein,
> gehört es in den W7-Behälter.

## 11.6 Ein Datum, kein Urteil — wo Fehler entstehen

Die Lead-Prämissen waren häufiger falsch als die Arbeit der Agenten (5× bzw. 8× in zwei
Zählfenstern). **Kein Agent widerlegte je den Owner am Objekt.** Der Owner formulierte keine einzige
Werkzeug-Falle, aber die tragenden Architektur-KERNe — und korrigierte sich zweimal selbst.

Das Muster ist strukturell: **Fehler entstehen dort, wo aggregiert wird, nicht dort, wo Objekte
angefasst werden.** Wer am Objekt arbeitet, irrt in der Sache selten; wer Breite verwaltet,
produziert Stellvertreter — weil Aggregation genau die Operation ist, **die Nenner verschluckt.**

Daraus folgt für die sequentielle Kette (§4): je Paket gilt **Objekt vor Aggregat**. Zuerst die
Datei, die Zeile, der Lauf — dann die Zusammenfassung. Nie umgekehrt.

---

# 12. DIE TEST-KRITIK, EINGEARBEITET (nachgetragen 08.08.2026 nachts)

> Quelle: `docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-wellen.md`
> (10 Teilgebiete, je Codex-Kritik + Objektgegenlesung + Fable-xhigh-Meta-Review; 21/21 Agenten).
> **Dieser Abschnitt ändert §3 (Wellensystem), §4 (sequentielle Kette) und §6
> (Verifikationsvertrag) — er steht nicht daneben.**

## 12.1 Was die Kritik über sich selbst ergab

**157 Behauptungen** aus zwei Kritikstufen durch die Meta-Objektprüfung:
**117 bestätigt oder geschärft** (386 h) · **40 fielen am Objekt** (ein Viertel) ·
**62 Funde hatte erst die Meta-Stufe** — weder Codex noch die erste Stufe.

> **Einstufige Kritik verliert am Objekt ein Viertel ihrer Behauptungen und übersieht zusätzlich
> einen Bestand von mehr als der Hälfte ihres Fundvolumens (62 gegen 117).**

**13 der 40 Gefallenen waren Fehler der ersten Schärfungsstufe selbst** — Testentwürfe, die am
*gesunden* Objekt rot oder am *kranken* grün gewesen wären (`P99IstNichtDasMaximum` unerfüllbar,
falsches Winsor-Orakel bei geradem n, eine Tautologie-Schleife, zwei falsche Ganzheits-Nenner).
**Ein Testentwurf ist eine Behauptung wie jede andere.** Dieselbe Klasse misst §11.1 an Widerrufen
(32,5 % hielten nicht) — zwei unabhängige Läufe, dasselbe Ergebnis.

## 12.2 Der TDD-Vertrag T-1…T-9 — bindend ab sofort

Er **ergänzt V-1…V-7 aus §6 um die Testseite**. Jede Wellen-Abnahme prüft ihn mit.

| | Regel |
|---|---|
| **T-1** | **ROT ZUERST** — der Test ist am ersten Tag rot ODER sein Biss ist per protokollierter Wegwerf-Mutation bewiesen. Beides fehlt = kein Test. Ebenso unzulässig: ein Test, der am gesunden Objekt nie grün werden kann (Daueralarm). |
| **T-2** | **AUSSAGE, NICHT ANWESENHEIT** — `find()`, Existenz, Exit 0, „wirft nicht" sind keine Zusicherungen. Wert, Position, Menge, Klasse. |
| **T-3** | **NENNER, FREMD** — jeder Test nennt seine Grundgesamtheit und bezieht sie aus einer **anderen Quelle als dem Prüfling**; `ASSERT` auf die Zahl **vor** der Schleife. |
| **T-4** | **GEGENEINGANG** — zu jeder Zusicherung ein Eingang, bei dem sie **nicht** gilt. Ein Randfall-Test, der nur Absturzfreiheit prüft, ist keiner. |
| **T-5** | **ORAKEL UNABHÄNGIG** — Sollwerte im Test gerechnet oder als einmalig erhobene, dann eingefrorene Literale. Nie aus der geprüften Funktion, **nie aus Kritik-Material abgeschrieben**. |
| **T-6** | **SCHWESTERPFLICHT** — jeder Fix und jeder Test sucht im selben Zug die Schwesterstelle (beide Writer, beide Genera, beide Backends, beide Engines). Ein erheblicher Teil der 62 Meta-Funde entstand genau so. |
| **T-7** | **REGISTRIERUNG IST TEIL DES TESTS** — ein Test existiert erst, wenn er in `ctest -N` erscheint und sein Binary im Bauweg hängt. Belegstand: 4 unregistrierte Dateien, 27 unsichtbare Fälle, F15-`if`-Block. |
| **T-8** | **ATOMARE LANDUNG** — Tag-1-Rot lebt im Feature-Branch; auf `development` landen Test + Minimalbau **atomar**. Rot-Lauf vor und Grün-Lauf nach der Heilung sind Paketbestandteil. |
| **T-9** | **TESTKRITIK** — die neuen Tests jeder Welle gehen in der **Folgewelle** durch einen Codex-Pass + Objektprüfung. Dreimal war der Test der Defekt; das wiederholt sich, wenn nur Produktionscode kritisiert wird. |

## 12.3 Die sieben Testklassen (117 Posten)

| Klasse | n | Muster |
|---|---|---|
| `keine-negativprobe` | 29 | Zusicherung ohne Eingang, bei dem sie fällt — der Mutant überlebt, weil nur die gesunde Seite betreten wird |
| `anwesenheit-statt-bedingung` | 25 | geprüft wird, dass etwas **da** ist, nicht dass es **gilt** |
| `kein-nenner` | 23 | Zahl ohne Grundgesamtheit; Teilprüfung tritt als Ganzheit auf |
| `unerreichbarer-block` | 16 | Test existiert und läuft nie — **billigste Klasse pro Stunde** |
| `test-zementiert-defekt` | 10 | Test schreibt falsches Verhalten als Soll fest oder bezieht sein Orakel aus dem Prüfling |
| zwei weitere | 12 | — |
| Einzelfälle | 2 | nach Hausregel keine Klasse |

## 12.4 Die Testlast je Welle — als Bestandteil der Wellen-Abnahme

Bänder: **A** = landet im Fenster · **B** = nur bei freiem Slot · **C** = W7.

| Welle | Band A | Band B | Eingangs-Gate / tragender Posten |
|---|---|---|---|
| **W-1** | 1 Posten, **3 h** | — | **ST-CTestWache zuerst** — `enable_testing()`-Wurzelfix + Nach-Build-Wache Soll (Quelltext-Scan) gegen Ist (`ctest -N`). **Ohne sie sind alle neuen Welch-Tests unsichtbar.** |
| **W0a** | 3 Posten, **9 h** | 1, 5 h | MT-L4 (vier Registrierungen) · AS-Bewaffnung · HY-Label-Gate. Dazu wird die **rote Statistik-Suite geschrieben** (Landung mit D4 in W1) — rein lokal. |
| **W0b** | 15 Posten, **40 h** | 9, 21,5 h | Die Testseite von D3-4/D3-5 im D3-Bogen. **F1-Testlieferung: kein Zähler lügt mehr über seine eigene Menge.** |
| **W1** | 23 Posten, **99 h** | 22, 62 h | **ENGPASS DES GESAMTEN PLANS.** Hart: **MT-L3-Schema-Orakel VOR D4d** — sonst entsteht die neue Spalte am Orakel vorbei. **HY-Reroute-Vertrag zuerst**, er *definiert* HY-A. **[Nachtrag 08.08.: die im TDD-Plan genannte Kennzahl „47 von 47 Stellen" ist am Objekt nicht reproduzierbar (sechs Zählweisen, keine ergibt 47). Belastbar: **29 Aufruf-Stellen in 17 Übersetzungseinheiten** an ce `25fe4fbf`; der Zähler, den MT-L3 bewegen muss, ist die Zahl eingefrorener Orakel und steht bei **0**. TDD-Plan §9.1, bewacht durch `ci/plan_zahlen_wache.sh`.]** |
| **W2** | 8 Posten, **21 h** | 23, 67 h | Nur Mo/Di/Fr tragen Slots (Bau-Fenster Mi–Do exklusiv). Band A = **Kampagnen-Wahrheit**, Landung bis F3 als Teil der GO-Vorlage. |
| **W3-MESS** | **0 h neue Testarbeit** | — | Die W0b/W2-Gates **sind** die Batch-Abend-Instrumente. Band B höchstens in Batch-Pausen, ohne Landung. |
| **W4** | 3 Posten + HY-Ebene4b, **34 h** | 4, 11 h | HY-Kurvenlage/Ausgaenge/HonestEmpty **mit** HY-C — der Router konsumiert die HY-B-Kurven, deshalb nie früher. |
| **W5** | — | — | Keine Test-Eingriffe; nur Nachweise (Köder-Protokolle, Nenner-Zeilen) in die Abgabe-Doku. |
| **W7** | Band C, 5 Posten, 13 h | + alles ungelandete B | **Als gezählte Warteliste** (Start: 59 Posten, 166,5 h) — nicht als stilles Vergessen. |

**Drei Einfüge-Regeln gegenüber den Wellen-Etiketten des Kritik-Materials:**
1. Die **Landung** eines Begleit-Tests folgt der **Bauwelle seines Gegenstands** (D4→W1, D3→W0b,
   D5-4→W1). Tests entstehen früher, landen atomar (T-8).
2. **W3-MESS ist blechexklusiv** — alles, was das Material „W3-MESS" nennt, landet **bis F3**.
3. **HY-A liegt in W1**, die Hybrid-Verträge rücken von W4 **vor** den Bau. Das ist der reine
   TDD-Fall: null Zeilen Bestand, **der Test ist die Spezifikation.**

## 12.5 Der Kapazitätskonflikt — offen ausgewiesen

**Bedarf:** 117 Posten, 386 h. **Band A = 53 Posten, 206 h.**

Davon sind **~131,5 h die Testseite bereits geplanter Bauten** und wandern in deren Paketbudgets
(HY-Verträge 58 h → HY-A/C · Lager/xlsx 39 h → Task-63-Strang · Statistik 12 h → D4 · Perzentil
17 h → D5 · Planer 6,5 h → D3). Davon sind **~30 h in den D-Posten-Abnahmen bereits eingepreist**
(Überschneidungen: ST-Trio↔D4a–c · PK-DeleteP99↔D5-4 · ST-CTestWache↔D2-G1 · PE-Testate↔D3-4/D3-5).

**Eigenständige neue Wachen in Band A: ~75 h.**

**Kapazität** (Annahme, keine Messung — zweiter `[lok]`-Slot der Ein-Blech-Regel): W-1 ~6 · W0a ~8 ·
W0b ~18 · W1 ~24 · W2 ~10 · W3 ~4 · W4 ~24 · zwei Reserve-WE ~24 = **~118 h**.

> **Die ~75 h eigenständiges Band A passen hinein. Die verbleibenden ~100 h Paket-Testseite erhöhen
> aber die erste Spur, die §3 bereits mit 26 von 27 Werktagen füllt.** Das ist keine Randnotiz,
> sondern die schärfste Aussage dieses Abschnitts: **W1 trägt 99 h Band A auf einer Woche, die
> schon voll ist.** Reißt W1, reißt der Freeze — und mit ihm die gesamte Kette dahinter.
>
> **Konsequenz für die Fahrweise:** In W1 gilt Band B als **nicht eingeplant** (nicht „nachrangig").
> Wird der Freeze eng, fallen zuerst die W1-Band-B-Posten (62 h) geschlossen nach W7 — **mit Zahl im
> Protokoll**, nicht durch Weglassen.

## 12.6 Codex als stehender Kritiker — Einsatzregeln aus dem Befund

**Stark, belegt:** Breite über zehn Teilgebiete · Klassenbildung · Schwesterstellen in bekannten
Dateien. Drei Codex-Kerne, die die erste Schärfungsstufe fallen ließ, holte die Meta-Stufe zurück —
**alle drei halten.**

**Schwach, belegt:** (a) er arbeitete auf **Vorfahr-SHA `85847715`** gegen HEAD `7bcf353b` — sein
gesamter Drift-Abschnitt war durch die D4-Heilung überholt · (b) Zeilenanker auf Nachbargegenstände
(3 belegte Fälle in einer Datei) · (c) Ganzheits-Behauptungen an Teilmengen gemessen (nur-ce-Greps)
· (d) Köder, die nicht beißen.

**Und zur Ehrlichkeit:** die erste Schärfungsstufe war **nicht besser** — 13 eigene Entwurfsfehler
unter den 40 Gefallenen.

**Einsatzregeln:**
1. Codex **nur auf frisch gepinntem SHA**, **beide Repos**, `tests/` **gesamt**.
2. Sein Output ist **Kartierung, nie Zitat** — jede tragende Referenz selbst lesen. **Keine
   Codex-Zeile und keine Codex-Zahl wandert ungeprüft in einen Test.**
3. **Meta-Stufe ist Pflicht.** Einstufig fällt ein Viertel; die Meta-Stufe fand zusätzlich 62.
4. **Je Welle ein Codex-Pass über die neu gebauten Tests der Vorwelle** (T-9) — dort war die
   Ausbeute am höchsten.
5. **Nicht einsetzen für:** Aufwandsschätzung, Wellen-Zuordnung, Owner-Entscheide. Dreimal lagen
   seine Prioritäten quer zur Frist- und Blech-Realität.

## 12.7 Was ausdrücklich NICHT getestet wird

**Band C (5 Posten, 13 h, W7):** MT-L8 (stillgelegter Legacy-Pfad; MT-L6 deckt die Sach-Aussage am
Host) · PM-PAPI (toter Zweitpfad) · PM-WinPCM (kein Windows-Runner im Fristpfad — der Windows-Zweig
bleibt **vertragslos**) · PM-AmdL3 Teile 1–2 (braucht CAP_PERFMON-Lane; **Teil 0, die
Kommentar-Richtigstellung, 0,2 h, sofort** — ein dokumentierter Widerspruch ist ein Defekt) ·
AG-PunktFixes. Dazu PM-NichtGelesen-**HW** (prod2 gestrichen) — die Klebrigkeits-Heilung bleibt
hardwareseitig unbewiesen, **der Seam-Test trägt allein**.

**Band B (59 Posten, 166,5 h)** geht ungelandet **mit Zählern** nach W7. Kosten je Block, ehrlich:
AG-Pakete (33 h) — Concept-Trennschärfe bleibt Konvention, ein gelockertes `requires` fällt erst als
**leere CSV-Spalte** auf · XL-Härtung (31 h) — Vendor-Randfälle unbelegt, der Kern ist Band A ·
AS-Block (17 h) — Registry-Drift wird nur von den W0a-Roundtrips gefangen, **nicht semantisch** ·
PK-Folgeposten (19 h) — der Kanon gilt, Produzenten-Grenzen bleiben ungepinnt.

**Bewusst nie getestet:** Holm/Bonferroni bei malformten p-Werten · `v32_orchestrator`-Stub ·
alpha=1-Konstruktion · HDR-Histogramm (nur falls D5-5 „führen" entscheidet).

---

# 13. AUFGABENSTAND-KONSOLIDIERUNG (nachgetragen 11.08.2026 nachts)

> **Zweck (Owner-Auftrag 11.08.):** *„konsolidiere unseren Aufgabenstand dort hinein in die korrekt
> passenden Wellen, sodass wir trotz Korrekturen nicht durcheinander kommen."*
>
> **Dieser Abschnitt ordnet ZU, er entscheidet nicht neu.** Wo er einen Abschnitt oben überholt,
> steht es dabei; die alten Fassungen bleiben als Historie stehen (Doku wird deprecatet).
> Quellen: Ledger **KON6…KON10** (Kopf) · die 91 Task-Posten · die Wellen-Tabellen §3/§4 oben.

---

## 13.0 DIE LAGE IN DREI SÄTZEN

**Die Architektur ist vollständig.** Der Owner am 11.08.: *„Es ist jetzt WIRKLICH jedes Detail
geplant und die komplexe Architektur angelegt, wir müssen ihr »nur« noch Herr werden."* Der
Selbstkompilations-Entwurf (KON10) liegt seit dem **19.07.** vor, die Stempel-Architektur ist im
Dialog dieser Nacht Satz für Satz abgenommen (KON7/KON8/KON9).

**Was sich gegenüber diesem Plandokument geändert hat, ist nicht der Bau, sondern sein
ANGELPUNKT.** Der Stempel trägt **fünf Rollen** — Identität · **Cache-Schlüssel** ·
**Lager-Schlüssel** · Skip-Marke · Einordnung (KON9-11). Er entscheidet damit, **was überhaupt neu
gebaut wird**. Das macht ihn zur Voraussetzung von W2, nicht zu dessen Beiwerk.

**Und es gibt einen harten Blocker, den dieses Dokument selbst nicht kennt:** der Bauplan vom
19.07. weist in seiner eigenen adversarialen Kritik eine **Phase 0** aus (super-Repo reconcilen),
ohne die jeder Bau am Planer-Kopf eine **dritte** Enumerations-Engine erzeugt.

---

## 13.1 WO WIR HEUTE STEHEN (Di 11.08.2026, nachts)

    W-1   Sa 08. - So 09.08.        ABGESCHLOSSEN
    W0a   Mo 10. - Mi 12.08. mittag LAEUFT -- endet in wenigen Stunden
    W0b   Mi 12. mittag - Fr 14.08. = F1        <- in 3 Tagen
    W1    Mo 17. - Fr 21.08.        = F2 FREEZE <- in 10 Tagen
    W2    Mo 24. - Fr 28.08.        = F3 · Bau-Trigger Mi 26.08. 06:00

**W0a-Rest, korrigiert** (aus der Planabgrenzung 11.08., §1.3a): **D1e · D1f · D1c · D2-G2 ·
##06-CI-Hälfte · ##07**. Erledigt und aus der Restliste zu streichen: D2 · D2-G1 · D2-G3 · D2-G4 ·
D2-G5 · D5-1 · **D1g** (An-9, `super 41b20a16`). D2-G6-Status **nicht erhoben**.

**W0b-Rest:** D3-1-Marker-Hälfte (hängt an D3-7b) · **D3-4+D3-5** (OV-16 ist entschieden, der Bau
fehlt) · D3-8 · ##08-Rest · ##20-B-Restbau · ##21-zweite-Hälfte (`object_stat`) · ##23-R1 ·
##26 · **##25 DURCHSTICH — kein Paket, kein Besitzer** · ##27–##31 (Nachlauf bis Di 18.08.).

---

## 13.2 DAS ZUORDNUNGS-KRITERIUM — drei Wirkungsklassen statt einer

Die Wellen-Zuordnung folgt **nicht** dem Thema, sondern der **Wirkung auf den Freeze**. Drei
Klassen, drei verschiedene Fristen:

    (P) PREIMAGE-WIRKSAM   aendert die SHA JEDER Binary
                           -> MUSS vor F2 (Fr 21.08.), sonst bricht der Identitaets-Freeze
    (M) MENGEN-WIRKSAM     aendert, WELCHE Binaries entstehen (nicht ihre Identitaet)
                           -> MUSS vor dem BAU-TRIGGER (Mi 26.08. 06:00), nicht zwingend vor F2
    (W) WERKZEUG           faengt eine Fehlerklasse, aendert selbst nichts
                           -> MUSS vor dem Gegenstand da sein, den es bewacht

**Warum die Trennung zählt:** ohne sie wandert alles Stempel-Nahe pauschal vor F2 und sprengt eine
Woche, die §12.5 bereits als *„ENGPASS DES GESAMTEN PLANS"* führt (99 h Band A). Mit ihr ist nur
das Preimage-Wirksame terminlich hart.

**Und die Kostenlage ist heute günstig, aber nicht lange:** es wurde **nie eine Flotte gebaut**
(Owner 11.08.) — Identitäts-Umbauten kosten **heute null** invalidierte Binaries. Ab Mi 26.08.
06:00 entwertet dieselbe Änderung **41,4 h Bau**.

---

## 13.3 DIE ZUORDNUNG

### W0b — bis F1 (Fr 14.08.). Unverändert: „Nenner-Ehrlichkeit + DURCHSTICH"

| Posten | Gegenstand | Klasse | Anmerkung |
|---|---|---|---|
| **#21** | **`##25` DURCHSTICH** | — | **die F1-Lieferung selbst.** Ohne Besitzer bis Mi mittag ist F1 nur halb (GOAL :494) |
| — | D3-4+D3-5, D3-1-Marker, D3-8 | — | W0b-Kern, OV-16 entschieden |
| — | W0a-Rest (D1e/D1f/D1c/D2-G2/##06/##07) | — | zieht in den W0b-Vorlauf |
| **#90** | **Bump-Pflicht-Wache**, Teil 1: der Riegel | **(W)** | **VORGEZOGEN.** Begründung unten |
| **#83** | `lint:format` ohne lokale Deckung | (W) | dreimal in Folge Format-Nachzug — blockiert jede Landung |
| **#80** | `coverage-guard` deterministisch rot | (W) | F1-vor-F2-Reihenfolge ist bindend (Dual-Review) |

**🔴 Warum die Bump-Wache nach W0b vorgezogen wird und nicht nach W2 gehört:** der Stempel ist der
**Cache-Schlüssel** (KON9-11). Eine Implementierungsänderung **ohne `X.Y.Z`-Bump** heißt: das Binary
wird **nicht neu gebaut**, der Lauf ist **schneller und falsch**, und der Cache-Treffer sieht aus
wie Erfolg. **Jeder Bau ab jetzt** — auch der Kalibrierlauf `##47` — läuft ohne diese Wache blind.
Sie ist damit ein W0b-Werkzeug, kein W2-Feinschliff.

### W1 — bis F2 (Fr 21.08.) = IDENTITÄTS-FREEZE. **Hier liegt die Stempel-Strecke.**

| Posten | Gegenstand | Klasse | warum vor F2 |
|---|---|---|---|
| **#87** | Funktions-Variablen in Stufigkeits-Ordnung | **(P)** | ändert die Argument-Reihenfolge des Preimage |
| **#78** | Stempel-Reihenfolge System-vor-Organ | **(P)** | ändert die Zeilen-Ordnung im Preimage |
| **#86** | **Stempel-Mechanik** — die drei Fläche-2-Schichten | **(P)** | erzeugt den Stempel überhaupt |
| — | **KON9-05** Achsen-Algo-Hardware-Stempel `X.Y.Z` in voller System-Syntax | **(P)** | jeder Algorithmus bekommt eine neue Versionszeile |
| — | **KON9-04** drei Grammatiken je Phasigkeit | **(P)** | bestimmt die Schreibweise jeder Zeile |
| — | **KON9-05** die Ordnungs-Relation (`⊆`) als `constexpr` | (M) | entscheidet Teilmengen, nicht Identität |
| **#67** | Benennung: vier Familien, 142 Include-Kanten | **(P)** | Umbenennung berührt 29 Include-Wanderungen |
| **#68** | selektiver Rebuild / Additivität | (M) | muss **vor** dem Bau stehen, sonst baut man ohne sie |
| — | **HY-A1…A3** (Plan §3 W1, unverändert) | **(P)** | Hybrid ist Genus mit Fläche 2 (KON9-02) |
| — | D4a–D4f, D5-2/4/5, ##10–##19 (Plan §3 W1) | — | unverändert aus der Plan-Fassung |

**Die Kollision, offen ausgewiesen (nicht glattgerechnet):** §12.5 führt W1 bereits mit **99 h
Band A** als Engpass. Die Stempel-Strecke kommt **zusätzlich**. Drei Entlastungen sind im Plan
schon vorgesehen und werden hiermit **gezogen**:

1. **Band B in W1 fällt geschlossen** (62 h, §12.5 sieht das ausdrücklich vor: *„gilt als nicht
   eingeplant"*) — mit Zahl im Protokoll, nicht durch Weglassen.
2. **Die Reserve-WE 15./16.08. und 22./23.08.** werden gezogen — 22./23. war ohnehin für HY-A
   reserviert (§3 W1).
3. **Der Designplan-Bestand ist kleiner als gedacht:** von den fünf F1-Kern-Explores waren **5 von
   7 Paketen SCHON ERLEDIGT** (Fußnote F1-KERN); die Stempel-Strecke erbt drei von vier
   Selbstkompilations-Bausteinen bereits gebaut (KON10-05).

**Reißt W1 trotzdem, fällt zuerst:** die Ordnungs-Relation (M) und #68 (M) nach W2 — sie sind
mengen-, nicht preimage-wirksam. **Nie fallen darf:** #87, #78, #86, KON9-05-Stempelzeile, HY-A.

### W2 — bis F3 (Fr 28.08.), Bau-Trigger Mi 26.08. 06:00

| Posten | Gegenstand | Klasse |
|---|---|---|
| **#90** | CI-Gerüst: vier **Mini-Pipelines** je Träger (D17: fünf Stufen) | (M) |
| — | Der Buildsystem-Cache scharf: prod-MinIO für die generierten Folge-Stufen (D18/§31-A4) | (M) |
| — | ##32–##51 (Plan §3 W2, unverändert): Bump-Bündel, Anker, Kalibrierlauf, Bau, GO-Vorlage | — |
| **#82** | überlebender Mutant `bvset_ist_teilmenge` | (W) |

### W3-MESS / W4 / W5 — unverändert aus der Plan-Fassung

Keine Zuordnungsänderung. **#19** (Thesis-Textpflichten) läuft in W4 mit ##60; **#66** (Lizenz,
prt-art/overleaf-Rest) gehört zu W5-##62.

### W7 — Behälter, gezählt

**#29** wide_aggregat-Dedup · **#30** zwei Parses · **#32** LAG-Z1/EXCLUDE_FROM_ALL · **#34** zwei
Owner-Fragen aus T-15 · **#42** blinde Wache · **#44** `-Werror` global · **#48** Gate-Lücke ·
**#50** Mutations-Recherche · **#63** tote Ledger-Anker · **#64** d2floor-Tests · **#69** W12-B ·
**#71** `-Wstringop-overflow` · **#72** 2-Pass-Falle · **#26** Abnahme-Entwürfe härten.

**Vierzehn Posten.** Sie gehen **mit Zähler** nach W7, nicht durch Weglassen.

---

## 13.4 DIE DREI POSTEN, DIE IN KEINE WELLE PASSEN

### (a) #91 PHASE 0 — Blocker vor der Selbstkompilations-Strecke

Der Bauplan vom 19.07. weist in seiner **eigenen** adversarialen Kritik aus: die Analyse endete am
ce-Submodul; im super-Repo liegt mit `Code/02_messung_driver/v32_messreihe_antrieb.hpp:214` eine
**zweite** `run_experiment_profile`-Funktion, selbst betitelt *„der OFFIZIELLE Einstieg"*. Ein
neuer `ExperimentPlanDirector` daneben wäre die **dritte** Enumerations-Engine.

**Zuordnung: vor jeden Bau am Planer-Kopf, also vor der Filterkette (KON9-06).** Der Umfang ist
klein (kartieren + Owner-Entscheid), die Wirkung groß. **Nicht terminiert, weil die
Selbstkompilations-Strecke selbst noch keinen Wellen-Platz hat** — siehe (c).

### (b) #88 KONSOLIDIERUNGS-ARCHITEKTUR — vom Owner terminiert

Owner-Reihenfolge 11.08.: *„Bitte jetzt die Stempel zuende Planen und chatten, direkt damit danach
die Konsolidierung wie geplant"* und *„debugge die Pipeline direkt nach der Stempel Planung und
VOR der Konsolidierung."*

    1. Stempel zuende planen + chatten   <- LAEUFT (KON9/KON10 gelandet)
    2. Pipeline debuggen                 <- NAECHSTES
    3. Konsolidierung (#88)

**Das ist eine Owner-Reihenfolge, keine Wellen-Zuordnung** — sie läuft quer zu W0b/W1 und hat
Vorrang vor deren interner Ordnung.

### (c) 🔴 DIE SELBSTKOMPILATIONS-STRECKE HAT KEINEN WELLEN-PLATZ

**Das ist der ehrlichste Befund dieser Konsolidierung.** KON10 belegt: der Entwurf ist vollständig
(D1/D5/D17/D18/§38), drei von vier Bausteinen existieren am Objekt — aber der Wellenplan kennt die
Strecke **nicht**. Der Planer-Kopf ist im Entwurf selbst als *„größtes Loch (PL-1)"* geführt.

    Was der Wellenplan heute plant   :  Statistik, Menge, HY-A, Bump, Bau, Kampagne
    Was die Kette dafuer BRAUCHT     :  Planer -> CEB -> Tier, jede Stufe kompiliert die naechste
    Was davon im Fenster gebaut wird :  NICHTS -- W2 baut mit dem HEUTIGEN Bauweg

**Die Auflösung ist keine Terminfrage, sondern eine Scope-Frage, und sie gehört dem Owner:**

| Variante | Was sie bedeutet |
|---|---|
| **(A) Stempel ja, Selbstkompilation nach W7** | die fünf Rollen werden gebaut, der Bauweg bleibt der heutige. W2 baut wie geplant. **Der Stempel wird korrekt, die Kette bleibt provisorisch.** |
| **(B) Beides vor F2** | verlangt Phase 0 + Planer-Kopf + CEB-Generierung in 10 Tagen, zusätzlich zu 99 h Band A. **Nach der Rechnung in §5 reißt der Pfad.** |
| **(C) Selbstkompilation ersetzt Teile von W2** | der Bau-Trigger fährt über die neue Kette statt über den heutigen Bauweg. **Höchstes Risiko: der Bau ist der kritische Pfad.** |

**Empfehlung: (A).** Begründung — der Stempel ist **preimage-wirksam** und damit an F2 gebunden;
die Selbstkompilation ist **Bauweg**, und der heutige Bauweg **funktioniert** (128 × 19,4 min ≈
41,4 h, gemessen). Ein Bauweg-Umbau auf dem kritischen Pfad ist genau die Klasse, die §7 als
Streichkaskade führt. **Das ist ein Vorschlag, kein Entscheid — er gehört an F1 (Fr 14.08.) mit
Zahlen vorgelegt.**

---

## 13.5 WAS DIESE KONSOLIDIERUNG AN DIESEM DOKUMENT ÜBERHOLT

1. **§1 „HYBRID: Bestand = genau `README.md`"** — **überholt.** Am 11.08. gemessen:
   `libs/cache_engine/hybrid/` trägt **vier Header, 943 Zeilen** (`heuristik_adapter_gate` 189 ·
   `klassifikation` 256 · `strategy` 246 · `synthese_matrix` 252). HY-A ist teilweise gebaut;
   `AnatomyGenus` hat seit HY-A1 **sechs** Werte statt fünf.
2. **§5 Korrektur-Einschub „die Kette bis `##25` ist leer / einziger verbleibender Blocker"** —
   **präzisiert.** Der Satz gilt für die **gestrichenen** Kettenglieder, nicht für die
   W0b-Postenliste; die Meta-Gegenlesung vom 11.08. (§3.4) hat den Selbstwiderspruch benannt.
   `##25` hat weiterhin **keinen Besitzer**.
3. **Die Zeilennummern dieses Dokuments und des Ledgers driften.** Der Ledger ist an einem Abend
   von 20.354 auf **20.973** Zeilen gewachsen (Nachträge stehen **oben**). **Jeder Ledger-Anker in
   diesem Plan gilt nur mit Commit-Anker; sonst per Symbol suchen.**
4. **Der Stempel-Designplan mit 15 Paketen (ST-00…ST-14) existiert nicht mehr** — 0 Treffer über
   180 Workflow-Outputs, 0 über `docs/`. Erhalten sind Paketnamen und vier Nachbesserungs-Befunde.
   **Neuschnitt gegen den heutigen Stand**, nicht Nachbesserung.

---

## 13.6 DIE BILANZ IN ZAHLEN

    91 Task-Posten gesamt · 56 erledigt · 35 offen
       davon (P) preimage-wirksam, vor F2 zwingend :   6
             (M) mengen-wirksam,  vor 26.08.       :   4
             (W) Werkzeug                          :   5
             regulaerer Wellen-Inhalt              :   6
             W7-Behaelter, gezaehlt                :  14

    Owner-Entscheide, die den Bau blockieren       :   2
       - Syntax + Semantik je Achsen-Kategorie ueber 'c' hinaus  (Abgabe-PFLICHT)
       - Meta-Meta-Achsen von System und Organ     (ausdruecklich "zu recherchieren")

    Scope-Entscheid, an F1 vorzulegen              :   1
       - Variante (A) / (B) / (C) zur Selbstkompilations-Strecke (13.4c)

**Der kritische Pfad bleibt unverändert der aus §5** — er bekommt durch diese Konsolidierung
**einen** neuen Vorläufer: die **Bump-Pflicht-Wache** in W0b, weil ohne sie jeder folgende Bau
(einschließlich `##47` Kalibrierlauf) auf einem blinden Cache fährt.

---

# 14. DIE TRÄGER-BAUKETTE — VOLLAUSBAU IN REIHENFOLGE (Owner-Entscheid 11.08.2026 nachts)

> **Owner verbatim:** *„Grundsätzlich stimme ich deinen Vorschlägen nicht zu, ich möchte **volles
> Risiko** fahren, die **komplette Träger-Baukette exakt wie beschrieben** umsetzen und **exakt im
> Plan mit den Wellen** weiter machen. Dazu gehört der **Aufbau MIT ALLEN TEILEN IN REIHENFOLGE**.
> Bitte gliedere also alles (Richtung **Variante B**) ein, sodass wir **direkt ins Zielbild** fahren
> und nicht über Umwege."*
>
> **Damit sind die Varianten (A), (A+) und (C) aus §13.4c gestrichen.** Sie bleiben dort als
> Historie lesbar. Es gilt **(B)**: Stempel **und** Selbstkompilation im Fenster, Wellen und
> Termine unverändert. Dieser Abschnitt ist die **Ausführungsordnung** dazu — er diskutiert nicht,
> er gliedert.

---

## 14.1 DAS ZIELBILD, GEGEN DAS GEBAUT WIRD

    ORT   (Traeger-Ordnung, Vertragskomplex)
          PLANER ──▶ CEB ──▶ HYBRID ──▶ TIER
          MESS       SYSTEM            ORGAN
          jede Stufe KOMPILIERT die naechste; nichts wird zur Laufzeit umgeschaltet   (D1/D5)

    ZEIT  (Erzeugung)
          Planer bauen ──▶ CEB je Messsystem GENERIEREN+kompilieren ──▶ Tier bauen
          ──▶ EINZELMESSUNG ──▶ Hybrid erzeugen ──▶ einschieben ──▶ Hybrid-Messung

    NUTZLAST
          hinab   serialisierter unterer Teilbaum als RANGES je Achse       (§38)
          hinauf  sparser Cursor-/Delta-Fortschrittskanal, Mixed-Radix-konform

    IDENTITAET
          Der Stempel traegt FUENF Rollen: Identitaet · Cache-Schluessel · Lager-Schluessel
          · Skip-Marke · Einordnung. Ohne ihn geht nichts.                  (KON9-11)

---

## 14.2 DIE VOLLSTÄNDIGE TEILELISTE — nichts darf fehlen

**Owner-Entscheide, blockierend** (kein Bau, aber jeder Bau dahinter wartet):

| ID | Gegenstand | blockiert |
|---|---|---|
| **O-1** | **Syntax + Semantik je Achsen-Kategorie** über `c` hinaus — *„Pflicht und Basis für die Abgabe"* | S-2, S-3 |
| **O-2** | **W-1:** wirkt der Hybrid-Einschub auf **Organ** oder nicht? KON7-03 sagt *„Organ bleibt hybrid-unberührt"*, die Grammatik-Zuordnung setzt *„System/Organ MIT Hybrid"*. **Ohne diesen Entscheid ist die Grammatik-Zahl nicht schneidbar.** | S-2 |
| **O-3** | **Voraussetzungs-Semantik:** *„fordert das Flag die Voraussetzung, oder impliziert es sie?"* — der Code stellt die Frage selbst (`algo_semver.hpp:1527-1528`) und beantwortet sie nicht | S-3 |
| **O-4** | **Meta-Meta-Achsen von System und Organ** — vom Owner als *„zu recherchieren"* markiert; am Objekt: Organ-Liste leer, System genau eine Familie (SIMD) | S-3 |
| **O-5** | **K1** Lager-Identität der Hybrid-`.so` · **K2** Loader-Schichten-Zuordnung · **K5** Snapshot-Aggregations-Semantik | S-10 |

**Bau-Teile, in Abhängigkeitsordnung:**

| ID | Teil | Quelle | Vorbild im Repo |
|---|---|---|---|
| **P-0** | **super-Repo reconcilen** — `v32_messreihe_antrieb.hpp` kartieren, wiederverwenden oder deprecaten | BAUPLAN-Kritik §1 | — |
| **S-1** | **Gemeinsame Stempel-Basisklasse**, je Achsen-Typ geerbt (heute fünf lose Strukturen, vier Namensschemata) | KON7-08 | — |
| **S-2** | **Drei Grammatiken je Phasigkeit** (zwei-/drei-/vierphasig) + vierte Klammer-Gruppe der Testat-Grammatik | KON9-04 | `algo_semver.hpp` R1–R8 |
| **S-3** | **Ordnungs-Relation** über Flag-Mengen (`⊆`) als `constexpr` + **Voraussetzungs-Wache** (Andockstelle steht seit 07.08. bei `:73`) | KON9-05 | `bvset_teilmenge.hpp` (187 Z.) |
| **S-4** | **Filter-Concepts**: Filter A (Hardware, monoton) · Filter B (Mess, zweischneidig) · je Phasigkeit ein Vertrag, `mp11` | KON9-06 | **`ram_probe_chain.hpp:161/:483`** — concept-CoR existiert |
| **S-5** | **Stempel-Factory** (compile time) je Achsen-Kategorie + **Composite** je Träger (Planer 2 · CEB 3 · Tier 4 · Hybrid 4 + Karte) | KON7/KON8 | — |
| **S-6** | **Preimage-Ordnung**: #87 Variablen in Stufigkeits-Ordnung · #78 System-vor-Organ · #67 Benennung (4 Familien, 142 Include-Kanten) | KON9-01 | — |
| **S-7** | **Achsen-Algo-Hardware-Stempel** `X.Y.Z` in voller System-Achsen-Syntax **und Semantik** | KON9-05 | — |
| **S-8** | **Planer-Kopf**: Interpreter · **ein** Director · `IPlanBuilder` · `CMakeGraphBuilder` · `CiYamlBuilder` · Template-Method · CoR-Einhängung · `IExperimentDock`+Registry · App-Target · `cmake/experiment_plan.cmake` (2-Pass) | BAUPLAN Phase 1 | **`catalog_codegen.cmake:52-60`** |
| **S-9** | **CEB-Generierung**: `CebSystemAxisDrive` · `acquire_ceb_system_axis_drive` · **harte Kompilation je Messsystem** · `SystemAxis::collect()` als CSV-Quelle · `.so`-ABI-Grenze (4 Symbole, Magic/Major-Gate, Loader, `host_compatible_with`) | BAUPLAN Phase 2, §30.3 | `search_algorithm_dock.hpp:63-86` |
| **S-10** | **Teilbaum-Serialisierung** hinab (Ranges) + **Cursor-/Delta-Rückkanal** hinauf | §38 | — |
| **S-11** | **`ceb:build` von Environment-Variable auf harte Kompilation** umstellen — Kernsatz-Verstoß, *„durch KEINEN Deferred-Posten gedeckt"* | Audit 05.08. | — |
| **S-12** | **CI-Gerüst**: fünf Stufen, **Mini-Pipeline je Träger**, emittiert vom `CiYamlBuilder` | D17 | — |
| **S-13** | **Buildsystem-Cache scharf**: CI-Cache = nur Planer · prod-MinIO = alle generierten Folge-Stufen + Sidecars | D18/§31-A4 | — |
| **S-14** | **Bump-Pflicht-Wache** — Änderung ohne `X.Y.Z`-Bump ⇒ kein Neubau ⇒ schneller **und** falsch | KON9-11 | — |
| **S-15** | **Hybrid**: Genus mit Fläche 2 · drei Anteile · Bereichskarte · Andocken nur an passende Genus-Interfaces | KON9-02/03 | 943 Z. bestehen |
| **S-16** | **`ci/tests/*.sh` → Google Tests** — heute **14 Dateien / 8.528 Zeilen**, wachsend | KON6-05, #89 | — |

**Sechzehn Bau-Teile, fünf Owner-Entscheide, ein Reconcile.**

---

## 14.3 DIE ZWINGENDE REIHENFOLGE

```
        O-1 ─┐
        O-2 ─┼──────────────────────────────► S-2 ──┐
        O-3 ─┤                                       ├──► S-3 ──┐
        O-4 ─┘                        S-1 ───────────┘          │
                                                                 ├──► S-4 ──┐
                                                                 │          │
                                      S-5 ◄───── S-1,S-2,S-3 ────┘          │
                                       │                                     │
                                       ├──► S-6 ──► S-7 ──► ══ F2 FREEZE ══  │
                                       │                                     │
        P-0 ─────────────────────────────────────────────────────► S-8 ◄────┘
                                                                    │
                                                       S-9 ◄────────┤
                                                        │           │
                                              S-10 ◄────┤    S-11 ◄─┘
                                                        │
                                            S-12 ◄──────┴──► S-13 ──► S-14
                                              │
                                    ══ BAU-TRIGGER Mi 26.08. 06:00 ══
                                              │
                              Tier-Bau ──► EINZELMESSUNG ──► S-15 (Hybrid)
                                                                │
                                              O-5 ──────────────┘
```

**Die vier harten Regeln der Ordnung:**

1. **Kein Grammatik-Bau ohne O-1 und O-2.** Die Zahl der Grammatiken hängt an O-2; die Semantik an O-1.
2. **Kein Planer-Kopf ohne P-0.** Sonst entsteht die dritte Enumerations-Engine (BAUPLAN-Kritik §1).
3. **Alles Preimage-Wirksame vor F2.** S-1, S-2, S-5, S-6, S-7 — danach ist die Identität eingefroren.
4. **Der Hybrid entsteht nach der Einzelmessung** (ZEIT), steht aber in der Kette vor dem Tier (ORT).

---

## 14.4 DIE WELLEN-EINORDNUNG — Termine unverändert

### W0b · Mi 12.08. mittags – Fr 14.08. = **F1** (Nachlauf bis Di 18.08.)

| | Gegenstand |
|---|---|
| **sofort** | **Owner-Vorlage O-1…O-5** — eine Datei, alle fünf Entscheide mit Empfehlung. **Frist Do 14.08.**, sonst rutscht S-2 und mit ihm die ganze Kette |
| **Bau** | **P-0** super-Repo reconcilen · **S-1** Stempel-Basisklasse · **S-14** Bump-Pflicht-Wache |
| **F1-Pflicht** | `##25` **DURCHSTICH** · D3-4+D3-5 · D3-1-Marker · D3-8 · ##26 · W0a-Rest (D1e/D1f/D1c/D2-G2/##06/##07) |
| **Betrieb** | #83 `lint:format` · #80 coverage-guard (F1 **vor** F2, bindend) |

### WE Sa 15./So 16.08. — **Reserve gezogen**

**S-2** drei Grammatiken je Phasigkeit (setzt O-1/O-2 voraus).

### W1 · Mo 17.08. – Fr 21.08. = **F2 = IDENTITÄTS-FREEZE**

| | Gegenstand |
|---|---|
| **Stempel** | **S-3** Ordnungs-Relation + Voraussetzungs-Wache · **S-5** Stempel-Factory + Composite je Träger · **S-6** Preimage-Ordnung (#87/#78/#67) · **S-7** Achsen-Algo-Hardware-Stempel |
| **Kette** | **S-4** Filter-Concepts (`mp11`) — Bauform aus `ram_probe_chain.hpp` ziehen |
| **Plan** | D4a–D4f · D5-2/4/5 · ##10–##19 · **HY-A1…A3** (Hybrid-Struktur, Fläche 2) |
| **F2** | **Freeze.** Ab hier ändert keine Zeile mehr das Preimage |

**Band B fällt in W1 geschlossen** (62 h, §12.5 sieht das vor) — mit Zahl im Protokoll.

### WE Sa 22./So 23.08. — **Reserve gezogen**

**S-8 Teil 1**: Interpreter + Director + `IPlanBuilder` + `--dump-plan` + Contract-Test.

### W2 · Mo 24.08. – Fr 28.08. = **F3** · Bau-Trigger Mi 26.08. 06:00

| Tag | Gegenstand |
|---|---|
| **Mo** | **S-8 Teil 2**: `CMakeGraphBuilder` + `CiYamlBuilder` + `experiment_plan.cmake` · Bump-Bündel ##32/##33/##34 |
| **Di** | **S-9** CEB-Generierung · **S-10** Teilbaum + Rückkanal · **S-11** `ceb:build` hart · **S-12** CI-Gerüst · **S-13** Cache scharf · ##46 Anker · **##47 Kalibrierlauf — der erste Ernstfall der neuen Kette** · ##48 Platten-Budget |
| **Mi 06:00** | **BAU-TRIGGER über die neue Kette.** ~41,4 h |
| **Do** | Bau läuft · ##50 Zweitlauf |
| **Fr** | ##51 USER-GO-VORLAGE = **F3** |

### W3-MESS · Sa 29.08. – Do 03.09. · Rückschrieb Fr 04.09. = **F4**

Kampagne wie geplant · nach der Einzelmessung: **S-15 Hybrid erzeugen und einschieben** = HY-B.

### W4 · Mo 07.09. – Fr 11.09. = **F5** · W5 · Sa 12. – Di 15.09.

Unverändert: HY-C · Auswertung · Anhang · P-1 · PDF · Abgabe.
**S-16** (`ci/tests` → Google Tests) läuft als Dauerposten mit, wo Slots frei werden.

---

## 14.5 DIE KIPP-PUNKTE — damit man sie erkennt, wenn sie kommen

Diese Liste ist **kein Einwand**, sondern ein Instrument. Jeder Punkt ist ein Datum mit einer
Bedingung; wird sie gerissen, ist die Folge bekannt und muss nicht neu erwogen werden.

| # | Datum | Bedingung | Folge, wenn gerissen |
|---|---|---|---|
| **K-1** | **Do 14.08.** | O-1 und O-2 sind entschieden | S-2 rutscht ins WE; jeder Tag Verzug schiebt F2 um denselben Tag |
| **K-2** | **Fr 21.08.** | S-1…S-7 stehen und sind grün | der Freeze hält nicht; jede spätere Stempel-Änderung entwertet den Bau |
| **K-3** | **Di 25.08. abends** | `##47` Kalibrierlauf läuft **durch die neue Kette** grün | der Bau-Trigger fährt auf ungeprüftem Weg |
| **K-4** | **Mi 26.08. 06:00** | Bau-Trigger startet | spätester tolerierbarer Start ist **Fr 28.08. 06:00**; danach fällt das W4-Fangnetz ersatzlos |
| **K-5** | **Do 27.08. abends** | Bau ist durch | ohne Bau keine Kampagne, ohne Kampagne kein F4 und kein Ergebniskapitel |

**Die Rückfallstufe, falls K-3 oder K-4 reißt** — sie wird hier benannt, damit sie im Riss nicht
erfunden werden muss: **der heutige Bauweg ist bis zum Bau-Trigger nicht zu entfernen.** `S-11`
stellt `ceb:build` um, aber die Vorgänger-Fassung bleibt bis F3 im Baum. Reißt die neue Kette am
Kalibrierlauf, fährt der Bau-Trigger über den alten Weg — **das kostet das Zielbild, nicht die
Abgabe.**

---

## 14.6 WAS DIESE ENTSCHEIDUNG VERDRÄNGT — ausdrücklich, mit Zahl

| Was fällt | Umfang | Wohin |
|---|---|---|
| **Band B in W1** | 62 h, 22 Posten | W7, gezählt |
| **Die 14 W7-Posten aus §13.3** | #29 #30 #32 #34 #42 #44 #48 #50 #63 #64 #69 #71 #72 #26 | W7, gezählt |
| **Beide Reserve-Wochenenden** | 15./16.08. und 22./23.08. | verbraucht — es gibt danach keinen Puffer mehr |
| **Der W0b-Nachlauf ##27–##31** | Frist war Di 18.08. | rutscht hinter S-2 |
| **Die 1 Werktag Rest-Reserve aus §5** | — | verbraucht |

**Nach dieser Gliederung ist die Reserve null.** Das ist die Bedeutung von *„volles Risiko"* — sie
ist hier als Zahl ausgewiesen, nicht als Warnung.

---

## 14.7 NACHTRAG AUS DEM CI-EXPLORE (11.08. nachts, 36 Agenten, 0 Fehler)

Der CI-Explore kam **nach** der Abfassung von 14.1–14.6 zurück. Er ändert vier Teile — zwei nach
unten, zwei nach oben. **Die Teileliste in 14.2 gilt weiter; die folgenden Korrekturen treten
daneben.**

### 🟢 ZWEI TEILE SIND BILLIGER ALS ANGENOMMEN

**S-8 (Planer-Kopf): der `ExperimentPlanDirector` EXISTIERT BEREITS.**
`ce libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp` — **unangeschlossen** im
Submodul. Der Director muss also nicht entworfen, sondern **verdrahtet** werden. Das war die
teuerste Position der ganzen Kette.

**S-14 (Bump-Pflicht-Wache): die Wache EXISTIERT BEREITS.**
`ce tools/axis_version_lock/axis_version_lock.cpp:172-185` + `axis_version.lock`, verdrahtet in
`ce/.gitlab-ci.yml:768-786`. **Sie deckt heute 6 von 136 bump-pflichtigen Dateien — 0 davon unter
`axes/`** (alle Zahlen im Explore selbst nachgemessen). S-14 ist damit ein **Ausroll-Auftrag**, kein
Neubau: `AXIS_ALGO_VERSION`-Marker in die 130 `axes/`-Header, Lock-Datei füllen — oder die Wache
generisch über alle `algo_version`-Träger fahren.

### 🔴 ZWEI TEILE SIND HÄRTER ALS ANGENOMMEN

**B-2 — DAS GITLAB-NESTING-BUDGET IST AUSGESCHÖPFT. Das ist ein technischer Blocker für S-12.**
`super/.gitlab-ci.yml:2686-2688` nennt die Grenze selbst: *„parent→child→grandchild = GitLab-
Nesting-Tiefe 2"*. **Drei der vier Träger belegen bereits die drei Ebenen** (Haupt/Planer-Delegation
→ STUFE-1 CEB → STUFE-2 Tier). **Für den Hybrid ist keine vierte Ebene mehr da.**

    Auflösungen, keine davon kostenlos:
      (i)   den Hybrid auf eine BESTEHENDE Ebene legen (neben Tier, nicht darunter)
      (ii)  die Emission FLACH ziehen -- eine Ebene weniger, dafuer breitere Job-Matrix
      (iii) Owner-Entscheid ueber eine andere Verschachtelung

*Die Ausschöpfung ist gemessen; die Folge für den Hybrid ist eine Ableitung des Explores, kein
Quellensatz.*

**B-4 — DIE WURZEL DES BUILDSYSTEM-CACHES HAT KEIN ZIEL IM CODE.**
`comdare-buildsystem` = **0 Treffer** in `ce/libs` + `ce/apps` (selbst gemessen). Dazu ein
ungelöster Widerspruch im Ledger (`:18698-18699`, 07.08.): **MinIO-Bucket gegen NAS-Ordner.** Die
Env-Variablen aus dem TWO-CACHE-STORAGE-Bauplan (18.07.) wurden **nie angelegt**.

⇒ **Ohne B-4 hat der genus-lose Planer überhaupt kein Ablageziel.** S-13 setzt einen Owner-Entscheid
voraus, den 14.2 noch nicht kannte.

**B-5 — `LagerBaumWriter` IST GEBAUT UND WIRD NIRGENDS GERUFEN.**
Vorkommen in `ce/libs` + `ce/apps`: **genau 1 Datei — seine eigene.** `::kaskade(`-Aufrufe von
außen: **0**. Für den genus-losen Planer fehlt der Spec-Typ (`lager_baum_writer.hpp:320-331`,
`LagerWurzelPaar() = delete`) — das ist **owner-konform**, kein Defekt, setzt aber B-4 voraus.

⇒ **Neues Teil S-17: den Lager-Baum-Writer verdrahten** (Bau-Orchestrator + Planer-Kopf). Ohne ihn
hat auch die **Messdaten-Kaskade** keinen Einsortier-Pfad.

### DIE OWNER-VORLAGE WÄCHST AUF ELF PUNKTE

Zu O-1…O-5 treten sechs CI-Fragen, bei denen der Explore ausdrücklich **keine Quelle** fand:

| ID | Frage | blockiert |
|---|---|---|
| **O-6** | Ist „Mini-Pipeline" eine **GitLab-Child-Pipeline** oder eine **Job-Gruppe innerhalb einer Stufe**? *„innerhalb der Haupt-Pipeline"* schließt eine eigenständige Downstream-Pipeline eher aus, entscheidet aber nicht zwischen den beiden verbleibenden Bauarten | S-12 |
| **O-7** | Sollen die vier Mini-Pipelines **statisch eingecheckt** oder **vom Planer emittiert** sein? Die heutige Architektur emittiert | S-12 |
| **O-8** | **Wo sitzt der Hybrid**, wenn das Nesting-Budget ausgeschöpft ist? (B-2, drei Auflösungen oben) | S-12, S-15 |
| **O-9** | **NAS-Ordner oder MinIO-Bucket** als Wurzel des Buildsystem-Caches? (B-4, Ledger-Widerspruch seit 07.08.) | S-13, S-17 |
| **O-10** | Gilt die Mini-Pipeline je Träger-**TYP** (4 Stück) oder je Träger-**INSTANZ** (n Tier-Binaries)? *„je Träger-Stufe"* deutet auf Typ | S-12 |
| **O-11** | Was heißt **„eigene Bedürfnisse"** konkret — Runner-Tags, Toolchain, Sanitizer-Profil, Test-Suite? | S-12 |

### EIN NICHTFUND, DER FESTGEHALTEN GEHÖRT

Der Owner verwies am 11.08. auf eine **frühere eigene Aussage** zur Mini-Pipeline-Pflicht. Der
Explore hat sie **nicht gefunden** — Nichtfund **mit Gegenprobe** über 19 `.jsonl`-Dateien, den
Ledger, `docs/plaene`, `docs/sessions` und das Memory-Verzeichnis. **Die einzige wörtliche Fassung
ist der Satz vom 11.08. selbst.**

*Das widerlegt das Owner-Gedächtnis nicht — es heißt, dass es keinen zweiten Beleg zum Abgleichen
gibt.* Der Satz vom 11.08. ist damit die **maßgebliche und einzige** Quelle für S1…S7.

### DAS IST-BILD, DAS S-12 ZU SCHLIESSEN HAT

    super  2768 Zeilen · 45 Jobs · 11 Stufen · 1 statischer Bau-Job (build:clang)
    ce     1056 Zeilen · 25 Jobs ·  6 Stufen · 2 statische Bau-Jobs
    Keine Stufe und kein Job heisst  ceb · tier · hybrid · release
    4 trigger-Kanten in super: 3 an Submodul-Repos, 1 an die Planer-Delegation
    -> 0 von 4 triggern einen TRAEGER als Bau-Gegenstand
    Hybrid: 0 Treffer in BEIDEN CI-Dateien und 0 im YAML-erzeugenden C++

**Sieben Owner-Zusagen (S1…S7), 0 von 4 Trägern erfüllt.** Das ist der Umfang von S-12.

---

## 14.8 DIE ERSTE HANDLUNG

**Die Owner-Vorlage O-1…O-5.** Sie ist der einzige Posten, der **heute** fertig werden kann und
**fünf** Bau-Teile freischaltet. Ohne sie steht die Kette ab S-2 still, und S-2 ist der zweite
Baustein von sechzehn.

Sie wird als **eine** Datei vorgelegt, je Entscheid: Frage in einem Satz · Recherche-Weg ·
Empfehlung · was er freischaltet · Frist.
