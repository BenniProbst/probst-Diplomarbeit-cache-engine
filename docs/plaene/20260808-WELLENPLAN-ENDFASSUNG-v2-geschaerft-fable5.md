# GESAMT-WELLENPLAN BIS 15.09.2026 — ENDFASSUNG v2

**Architekt-Entscheid, Stand Sa 08.08.2026 abends.** Grundlage: die Endfassung v1 vom 08.08. (803 Zeilen, 369 SOLL-Posten, 211 IST-Prüfungen, 39 Regressionen, 46 Einwände), dazu **35 am Objekt geschärfte Defekt-Posten** (fünf Familien D1–D5, Summe ~76 h, jede Zahl heute gemessen) und **drei unabhängige Wellendesigns** (Frist zuerst / Risiko zuerst / Kette zuerst). Alle mit `LIVE` markierten Zahlen sind am 08.08. erhoben; Erhebungs-Referenz steht jeweils dabei.

**Ersetzt:** `wellenplan_endfassung.md` v1 (die deprecatet wird, nicht gelöscht) und transitiv deren Vorgänger (`20260803-FAHRPLAN-…`, `20260806-PLAN-…`, `20260806-FAHRPLAN-…`, `20260806-REGISTER-…`).

**Synthese-Entscheid, in zwei Sätzen:** Tragende Ordnung ist der Ketten-Entwurf („die Kette misst nur so wahr wie ihr schwächstes Glied"), weil er als einziger den bindenden Owner-KERN vom 08.08. (HYBRID = Gattung `HEURISTIK-ADAPTER`, „ALLES PFLICHT") nicht in die Streichliste schiebt und weil seine Reihenfolge — Waage → Nähte → Statistik-Glied → fehlendes Glied → einmal bauen → einmal messen — exakt die am Objekt gemessenen Abnahme-Abhängigkeiten der 35 Defekt-Posten abbildet. Aufgepfropft werden aus dem Frist-Entwurf die Defizit-Arithmetik, das Abgabefähigkeits-Minimum je Freitag und die Ein-Blech-Regel, aus dem Risiko-Entwurf der Durchstich (ein echter Mini-Messwert bis in den Thesis-Anhang am 14.08.), die Batch-Abend-Doktrin und das Sa-29.08.-Messfenster.

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21): Juengste Konsolidierung = par.21 (Kontext 13, KON118-Stand). KON119 ist
> als Lande-Bericht des #15-Bruchs reserviert (par.21.1, super-Zug). Owner-Order 18.08.: NIE ausbuchen/verschieben
> -- W7 ist KEIN Endlager mehr (par.21.0); Platzierungen: Wiederaufnahme-Register + par.21.3.

> EINPLANUNGS-MARKER 23.08.2026 (par.24): Juengste Konsolidierung = par.24 (Einplanungs-Nachtrag, Owner-Order
> 23.08. "keine zurueckgestellten/unbearbeiteten Posten, alles der Reihe nach"). KON119-Reservierung blieb gewahrt
> (vollzogen); par.25 ist fuer die OV-16/17-Buchung reserviert (RN-27). Der-Reihe-nach-Ordnung: par.24.1 RN-01..RN-92.

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

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21, Owner: NIE ausbuchen/verschieben): der Preis-Satz oben ist nur
> Historie -- die ##40-Reste sind neu platziert (T-13/T-14 vor W3, T-07/T-08 vor Trigger bzw. W2-Slots, Rest W4);
> Wiederaufnahme-Register + par.21.3.

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

> ⚠️ **FUSSNOTE T-15b (MARKER 13.08.2026, KON59):** die D4-Zeile koppelt an **T-15a** (Drift-`max_reruns`, `ce 4cd1ab91`). Davon VERSCHIEDEN ist **T-15b** = zweite Retry-Klammer um `measure_one_binary`: **je 5** für **Build UND Messung** (nicht 1+5), Erfolg = 3 Wiederholungen je Parameter+Binary, **alle 3 einzeln persistiert** (KON37-06, §17.4). Die „5" sitzt heute FALSCH auf der Drift-Achse; Umzug + 8-Punkte-Ripple = Task #13 (W2, KON26-04/KON28-02). Diese Zeile bleibt stehen.

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

Statistik: **D4a → D4b → D4c** (Reihenfolge zwingend, D4c ist vorher blind), **D4d** (die EINE Spaltenänderung der Woche, danach Header-Freeze Stufe 2), D4e (nach ##07), D4f (nach OV-6-Lage), D5-3 → D5-2, D5-4, D5-5. Menge: ##10+##10b (`--check-size`, zwei Zahlenreihen + EIN gemessener Punkt bei working_set 8.388.608), ##11 (`<measure_selection>`), ##12, ##13 (G3-Split), ##14 (**Sperrlisten-Wache = Freeze-Gate**, maschinell aus `kAnatomyFingerprintGliedCount = 9`), ##15 (§59-SCHEMA als hartes W3-MESS-Vor-Gate; EMITTER/TEMPLATE bei Slack), ##16+##17 (nach OV-1), ##19, ##09 (nachrangig). **HY-A1–A3** (nach OV-13-Bestätigung + OV-12 + 4.-Ebenen-Entscheid Mi 19.08.): Gattung `HEURISTIK-ADAPTER`/Genus `Function-Interface-Reroute` — `hybrid_dock_contract` + `hybrid_pruef_dock` + factory/array (CT-Interface-Vererbung, `variant` NUR im DockSlot), `hybrid_binary_proxy` + `hybrid_tier_module.cpp` (4 ABI-Pflicht-Symbole) = **F8-Minimal-DoD** (genau 1 Standard-Dock, ctest-bewiesen, Reroute auf 2 plain-Tier-Ziele), `<hybrid_tier>`-Parser + Heuristik-Hybrid-Achse in die Registry (22→23, beide Zahlen) *[ÜBERHOLT per E-6/P.20.10: 22 = Phantom-Nenner; real = kGenusBuildSlotCounts 5→6]* + Fehlerklassen. Abgabe-Vorlauf: ##42, ##43, ##44, ##45. **Entwicklung** (nicht Landung) der W2-Landepakete: ##32, ##33, ##35, ##36 (T-15+D4), ##37, ##38, ##39. **An F2:** OV-4-Deckel-Vorlage MIT beiden `--check-size`-Zahlenreihen beim Owner.
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

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21): die [lok]-Klasse der Batch-Pausen traegt die Band-B-Wiederaufnahme --
> die Maschine misst, die Session baut lokal ohne CI-Last (vereinbar mit Parallelitaet 1 / null CI-Last);
> Wiederaufnahme-Register + par.21.3.

### W4-AUSWERTUNG — ZAHLEN + TEXT + HY-C · Mo 07.09.–Mi 09.09. Kern; Do 10./Fr 11.09. Fangnetz; Fr 11.09. = **F5**

##57 (Break-Even auf dem D4f-Typ: „kein Break-Even bestimmbar" ≠ „bestimmt: keiner", zwei verschiedene Ausgaben — heute byte-gleich; Umfang gemäß OV-1/OV-6), **HY-C** (`hybrid_router` als Break-Even-CoR aus den HY-B/W3-Kurven + `hybrid_eviction`-Minimalstrategie + EIN belegter Routing-Fall im Text; Köder: nirgends kreuzende Kurven → `kein_schnittpunkt` + Rückfall auf direkten Tier-Aufbau, ungültige Kurve → `kurve_ungueltig`), ##58+##58b (Anhang-Wache: 28 **[NEUMESSUNG 13.08.2026, Korrektur daneben, kein stilles Ersetzen: real 10 unkommentierte Aufrufe = 10 eindeutige Ziele (roh 12); die 28 ist mit keiner Zaehlweise reproduzierbar, UNBELEGT -- s. Fussnote ##58-NENNER unten]** `\InputIfFileExists`-Ziele gegen wirklich gefundene Dateien, beide Zahlen; `\thesisfinal` macht Ersatztext zum LaTeX-Fehler; `|| echo honest-empty` fällt ersatzlos), ##59 (FF0–FF4, Nenner 5, leere Frage = rot), ##60 (Ergebniskapitel C5: Zahlen ins ##44-Gerüst, jede Tabelle mit Lauf-Provenance; DE führt, EN zieht für berührte Kapitel nach), ##61 (Backups sofort), **P-1** (Präsens-Zusagen-Wache: `geprueft 3 / erfuellt-oder-korrigiert 3` — Zwei-Maschinen KORRIGIERT per OV-5, Resume ERFÜLLT per ##35, Konformität ERFÜLLT per perm_runner/OV-8).
**Parallelität 2** (Auswertung und Text dateidisjunkt; keine Bau-Abnahmen mehr auf dem Blech). Fangnetz Do/Fr: Auswertungs-Verzug ODER Teil-Nachmessung via Resume (max. 2 Tage + WE 12./13. als letzte Entnahme).
**Blockiert durch:** W3-MESS (mindestens die 320er-Abgabemessung; HY-C konsumiert die HY-B-Kurven — deshalb stand der Router nie in W1).

> **FUSSNOTE ##58-NENNER -- NEUMESSUNG 13.08.2026 (A2.5-Fix-Stufe), am echten Klon gemessen, nicht abgeschrieben.**
> Gemessener Baum: `/home/comdare/Projekte/Research/20260931-overleaf-diplomarbeit`, HEAD `29a1700`, Arbeitsbaum
> sauber. Einschraenkung ausdruecklich: in super sind BEIDE Thesis-Submodule
> (`Code/external/20260931-overleaf-diplomarbeit` und `thesis/diplomarbeit`, gitlink `798e9460`) UNINITIALISIERT --
> in super-Worktrees ist die Zahl nicht messbar, gemessen wurde deshalb der echte Klon. Werkzeug: `/usr/bin/grep`
> absolut (das blanke `grep` ist eine ugrep-Funktion). Zaehlweisen, jede benannt:
>
> * (a) Aufrufe gesamt, alle `.tex` DE+EN, Muster `-r --include='*.tex' -o -F '\InputIfFileExists'`, Scope ganzer
>   Klon: **12** (12 Zeilen, kein Mehrfachtreffer je Zeile; alle 12 in `anhang/*/A_measurements.tex`, 6 je Sprache).
> * (b) davon ohne auskommentierte, Muster `-E '^[^%]*\\InputIfFileExists'`: **10** (je Sprache ist genau 1 Treffer
>   eine auskommentierte Erlaeuterungszeile, DE `anhang/de/A_measurements.tex:71`).
> * (c) nur `anhang/`-Baeume (DE+EN): roh **12** / unkommentiert **10** -- identisch mit (a)/(b), ausserhalb von
>   `anhang/` existiert kein Aufruf.
> * (d) nur DE (`anhang/de/`): roh **6** / unkommentiert **5**. Eindeutige Ziel-Dateien (dedupliziertes
>   `{...}`-Argument, DE+EN): **10** = 5 je Sprache (seg_attribution, observer_detail, latency_range, latency_ecdf,
>   exchange_forest).
>
> **Die 28 ist mit KEINER gefahrenen Zaehlweise reproduzierbar**: roh 12, unkommentiert 10, eindeutige Ziele 10,
> nur DE 6/5, bare `IfFileExists` 12, alle Dateien ausser `.git` 12, `\input{` gesamt 55 / unkommentiert 39 / nur
> tabellen-Ziele 40, `\input`+`\InputIfFileExists` unkommentiert in `anhang/` 46, vorhandene Dateien in den
> `tabellen/`-Verzeichnissen 18+18=36. Nach B-1/Designplan Abschnitt 9.1 ist die 28 damit keine veraltete, sondern
> eine UNBELEGTE Zahl. Auch die **13** (KON6-07/3, KON8-11) reproduziert am heutigen Stand nicht: die Klon-Historie
> kennt fuer `.tex` nur 10 (`73947aa`) dann 12 (`8d156a5`, observer_detail DE+EN) bis heute 12. Konsequenz fuer den
> ##58-Bau: die Wache MISST ihr Soll zur Laufzeit selbst (Nenner = Zaehlweise (b), Ziel-Liste = dedupliziertes
> Argument wie in (d)) und vergleicht gegen wirklich gefundene Dateien; eine eingefrorene Konstante (28, 13 oder 10)
> wiederholte denselben Fehler.

### W5-SICHERUNG · Sa 12.09.–Di 15.09. (Abgabe Di)

##62: PDF aus sauberem Checkout (`-halt-on-error`, Warnings ≤ 1, `.blg` alphadin), Anhang **gegen Nenner** belegt, DE/EN der berührten Teile konsistent, Spiegel GitHub/GitLab synchron, Overleaf-Identität, Desktop-Backup, Abgabe-Logistik Di VOR Dienstschluss. **Keine Bau-Eingriffe.**

### W7 — NACH DER ABGABE (Behälter)

§75-Aufräumpass (104 offen) · ##40-Restbau (T-06…T-14, W-03, W-08, A14, A10) · HY-Vollausbau (Heuristik-Familie, Mehrfach-Aufbau, scharfe Eviction, Paper-gekoppelte Heuristikwahl) · `checkpoint_measure` (OV-2b bestätigt) · Record-and-Replay · Paper-Kopplung (OV-14) · prod2-Lane/pmc:intel/P-E-Trennung · D1c-Ausbau falls Floor-Rückfall gezogen wurde · B-Spline (je nach OV-1) · Voll-Messung als Kampagnen-Programm · PV-1 · Doku-Anker-Sanierung.

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21, Owner: NIE ausbuchen/verschieben): W7 ist KEIN Endlager mehr -- jeder
> Behaelter-Posten ohne Owner-Wort hat eine NEUE Platzierung im Wiederaufnahme-Register + par.21.3;
> Owner-entschiedene Posten (prod2, Voll-Messung, Paper-Kopplung; checkpoint_measure laengst zurueck als B4)
> bleiben per Owner-Wort (Register Teil C, par.21.6).

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
 HY-A3[lok] <hybrid_tier>-Parser + Achse in Registry (22->23 UEBERHOLT s. P.20.10) + Fehlerklassen.
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

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21, Owner: NIE ausbuchen/verschieben): die Deckungs-Streichungen F-07b,
> ##40-Restbau, ##15-EMITTER/TEMPLATE und Register-Vollautomation sind wiederaufgenommen -- die Saldo-Rechnung
> oben ist nur Historie, die Arithmetik-Korrektur traegt Task #98; NEUE Platzierung im Wiederaufnahme-Register +
> par.21.3.

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

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21): die Rueckfallstufe bleibt UNGEZOGEN (nur bei Riss); die Folge
> "W7-Posten" ist Historie -- die ##31-Vollform ist W2-W-Posten, jeder Riss-Fall erhaelt eine gezaehlte
> Platzierung im Wiederaufnahme-Register + par.21.3.

**STELLVERTRETER-DURCHGANG 09.08. (V-8 auf den Bestand angewandt) — mit Nenner.** Geprüft wurden **56 Formeln**: die **51** Wellen-Formeln dieses Abschnitts (maschinell an ` · ` getrennt gezählt: W-1 5, W0a 7, W0b 9, W1 11, W2 8, W3-MESS 4, W4/W5 7) und die **5** Blöcke „Tragende Abnahme" aus Abschnitt 2. Ergebnis: **4 gehärtet, 52 halten.** Gehärtet sind ##02, D1d, der W0a-DLL-Zähler und ##56 — jeweils oben im Text, jeweils mit dem Zustand benannt, in dem die Ausgabe erscheint und die Sache trotzdem fehlt. **Zwei weitere Defekte lagen außerhalb dieses Nenners, in der Aufgabenkette (§4), und sind dort geheilt:** die D3-2-Zeile trug die `== 0`-Formel ohne `-F` und ohne Gegenprobe, Posten 21 prüfte Präsenz in der YAML statt des Stores. **Ausdrücklich gehalten haben** die köder-getriebenen Formeln (W0a-Bedingungstabelle mit 19. Registrierung auf beiden Wegen, D2-G6-Stash-Köder, D5-1-Mutations-Köder mit Seed, HY-A-Roundtrip mit gewürfeltem Token) sowie ##34 und ##53 — ##34 druckt seine Commit-Zahl als Nenner **zur selben Zeit** wie die Null, und ##53 benennt seinen eigenen Stellvertreter im Klartext (*„Zeilenzahl > 0 ist wertlos — der Bau-Fehler-Zweig schreibt formal vollständige CSVs"*). Beide sind die Musterform und wurden **nicht** angefasst.

**Je Welle (Nenner + tragende Zeilen; die vollständigen Abnahme-/Köder-Definitionen der D-Posten aus Abschnitt 2 sind Vertragsbestandteil):**

**W-1** (Nenner 6): ##01 `rev-list --count` 29→0, beide Zahlen · **##02 `diff --stat` 17→0 — gehärtet (V-8):** die **0** gilt erst mit einer **Gegenprobe im selben Lauf** (derselbe Aufruf gegen ein bekannt abweichendes Ref-Paar muss > 0 liefern) und mit `rc` **direkt hinter** dem Aufruf (K11); eine leere `diff`-Ausgabe entsteht auch bei vertauschtem Ref-Paar und bei einem Pathspec, der nichts trifft — beides sieht wie „gelandet" aus · D1/D1a: `make check` 427→431 literal, `make` allein 0→53 `.so` (6329→6749 ninja-Ziele), Doppel-Köder beider Gate-Familien vorher unsichtbar-grün/nachher rot · **D1d: `grep -rnF '404 statt 406'` = 0 — gehärtet (V-8):** gültig erst nach **beißendem Köder im selben Lauf** (gewürfelte Zeichenkette an bekannter Stelle, muss gefunden werden) **und mit `--no-ignore`**. Grund, am 09.08. mit frisch gewürfeltem Köder nachgemessen: der Agent-`grep` ist **ugrep 7.5.0** (Shell-Funktion; `/usr/bin/grep` ist GNU grep 3.11) und überspringt via `--ignore-files` still alles, was `.gitignore` deckt — dort stehen u. a. `*.so`, `*.csv`, `*.log`, `build/`. Der Köder lag zweimal aus, **gefunden wurde 1 von 2, und `rc` blieb 0**: diese Null trägt nicht einmal ein Fehlersignal · jede verbleibende Kommentar-Zahl mit Datum+Kommando · ##04/##05 wie v1, jetzt erfüllbar.

**W0a** (Nenner 14): **test:unit-Job druckt Job-ID + `out of 431` + `R5.G … ACTIVE (48 auto-gebaute DLLs)` (heute 429, beide Zahlen) — gehärtet (V-8):** dazu die DLLs **auf der Platte gezählt** im selben Job (`find … -name '*.so' | wc -l` == 48). Die R5.G-Zeile ist eine **CMake-`message()` zur Configure-Zeit** (`tests/unit/CMakeLists.txt:1575`, gedruckt wird die Listenlänge `${_r5g_autobuilt_count}`) — sie fällt, **bevor irgendetwas gebaut ist**, und meldet 48 auch dann, wenn anschließend 0 `.so` entstehen. `out of 431` bleibt tragfähig, weil es ctest selbst über einen gefahrenen Lauf druckt · Wache druckt DREI Zahlen aus DREI Quellen (V-7), Zahl-Köder 345 → rot, Schrumpf-Köder N per `shuf` → rot mit N, Gegenköder grün · Bedingungs-Tabelle (korrigiert D2-G4, s. Fußnote): `bedingte_registrierungen: 18 / bedingungs_klassen: 14 / erfuellt: 12 / allowlist_mit_begruendung: 6 / ohne_allowlist_eintrag: 0 / allowlist_zusicherung_verletzt: 0`, jede Ausgabe mit Host-Kennung; **19. Köder-Registrierung hebt den Zähler maschinell auf 19 und wird namentlich rot — auf BEIDEN Wegen: unter einer neuen Bedingung (`ohne_allowlist_eintrag=1`) wie unter einer bereits allowgelisteten (`soll=4 ist=5`, s. Nachtrag D2-G4/Z)**, Gegenprobe bleibt bei 18 grün · D2-G1: `ctest -N` +2, Erstlauf-Ergebnis mit bestanden/gesamt gebucht · D2-G6-Stash-Köder: XML weg → rot mit Namen und `Inventur 426, Untergrenze 428, Differenz -2` · D5-1: `Definitionen: 1`, Pin 51→50, Mutations-Köder rc≠0 mit Seed · D1g: zwei `ctest -N`-Zahlen aus einem gefahrenen super-Configure-Paar, Ursache im Kommentar benannt.

**W0b** (Nenner 17 + 5 Nachlauf): D3-1-Proben P1 (Kopfzeile, `$K` im Pfad der Fehlerzeile) rot / P2 (eine Datenzeile `koeder_$K`) grün mit `datenzeilen_gesamt=1` / P3 (leer) rot mit `csv_gesamt=0` — heute P1/P3 grün, Vorher-Läufe protokolliert *(Nachtrag 08.08. abends: **gefahren und gelandet** — `ci/tests/mess_ausbeute_bissprobe.sh` mit `--selbstbiss`, im CI als `test:mess-ausbeute-bissprobe` ohne `allow_failure`; die Köder werden je Lauf gewürfelt, nicht abgeschrieben. Offen bleibt allein die Marker-Auswertung aus D3-7.)* · ##26 in korrigierter Formel `N>=1 UND M==N UND Z>=1` · Marker: fehlend = rot, `provision_only` nicht fälschlich rot, gefälschter `modus=voll measured=0` rot · persist-Beweis am Git-Zustand · Testat-XOR: gewürfelte Fehl-Zelle → genau 1 `[FEHLER-TESTAT]`, C−1 `[MESS-TESTAT]`, Bilanz stimmt (heute C+1 Testate) · Frische-Zwei-Lauf-Köder · D3-6: P1 Produktions-Layout heute unsichtbar → danach im WIDE-Aggregat, P3 NO-OP mit `laufordner_geprueft=1 / mit_material=0` · ##23/##23b wie v1 (Zeilenzahl je Blatt gegen Eingangs-CSV; SKIP-Zweitlauf zwei Zahlen) · **##25 DURCHSTICH:** Submodul-Diff zeigt die Tabellenzeile mit dem gewürfelten Mini-Lauf-Token; PDF baut; jede Stufe hat ihren Nenner gedruckt.

**W1** (Nenner 26): D4-Invarianz (identische `adjusted_p` 7-vs-9; benannter Kipp-Kandidat) · `win_rate` nur noch mit Nenner-Klammer · f15-Summenzeile nachgerechnet, Exit≠0 bei degeneriert (rc direkt hinter dem Aufruf, K11) · D4d: Spaltenzahl vorher/nachher, Null-Vektor ≠ success, Gegenprobe (31 Nullen + 1 echter Wert) · ##10 zwei Zahlenreihen + ##10b ein gemessener Punkt bei 8.388.608 · ##11 Deckelung liefert kleinere Zahl; nicht deklarierte Perm = Fehlerklasse · ##13 `nm` auf benannte micro-Symbole, Stempel-Region ausgenommen (v1-##13 bleibt) · ##14 Preimage-Wache: 10. Glied → rot · HY-A: F8-DoD grün in ctest (Zahl vorher/nachher), Reroute-Roundtrip-Köder (gewürfeltes Token durch das Dock zu 2 plain-Zielen und zurück), nicht deklariertes Ziel bricht compile-time laut, Registry 22→23 *[ÜBERHOLT: Abnahme-Ersatz s. P.20.10 — kGenusBuildSlotCounts.size() 5→6 + Paare 4/6, je vorher/nachher]* · Kreuz-Test Median (Bit-Gleichheit, gerade Länge) · Fr 21.08.: OV-4-Vorlage liegt MIT Zahlen beim Owner.

**W2** (Nenner 12): ##34 `git log -p`-Filter aufs ABI-Magic = **genau EIN** Wechsel im Gesamtfenster, **NULL nach Mo 24.08.** (Commit-Zahl als Nenner gedruckt) · ##35 zwei Zahlen (Abbruch nach 2 Batches, Neustart überspringt; heute Start bei 0 = rot) · ##36 **zwei degenerierte Zellarten getrennt**: Null-Fenster → `MESSUNG DEGENERIERT … unbestimmbar` (kein Rerun), echte Streuung → `reruns: n`; `ZeroMedianGuard` im selben Commit umgedreht; Zensus-Zähler Produktion ≥ 1 mit Dateiname · ##47 ETA gegen unabhängige Teilbaum-Auszählung, Abweichung > 50 % = Abbruch; Kalibrierlauf passiert alle W0b-Gates (das IST der U-02-Vollzug) + erhobene Rerun-Rate · ##48 5/5 mit Nenner + `benoetigt_GB`/`frei_GB` beide gedruckt · ##50 drei Zahlen · ##41b drei Job-IDs + ein absichtlicher Zell-Fehlschlag färbt den Grandchild rot · ##51 EINE Datei.

**W3-MESS** (Nenner 7): ##53 `zellen_mit_echtem_messwert/zellen_gesamt` + Häufigkeit JEDES Ersatz-Tokens (Single-Source `measurement_curve_loader.hpp:72`), alle Zahlen im Log UND im Exit-Code; `nicht_gebaut > 0` = Abbruch vor der Auswertung („Zeilenzahl > 0" ist wertlos — der Bau-Fehler-Zweig schreibt formal vollständige CSVs); „echt" = D4d-Definition · Batch-Abende: Bilanz, Gate, Frische — je Batch protokolliert · HY-B: Overhead-Kurve je Zielanzahl mit n je Zelle; eine tote Reihe kann nicht mehr gewinnen (D4e-Nachweis) · **##56 Commit nur bei Substanz, PROVENANCE trägt die Zahl — gehärtet (V-8):** dazu **`object_stat` gegen den minio-Store** nach dem Lauf (Schlüssel trägt das gewürfelte Lauf-Token, `size > 0`), und dasselbe für den NAS-Pfad. Der Git-Stand allein ist die **Ankündigung**, nicht der Gegenstand: genau hier saß LAG-P1 — die aktiv-Zeile fiel, der Schreibweg scheiterte **danach**, die Emission lief ohne Abbruch weiter. Die Bestandslog-Wache sagt das über sich selbst ausdrücklich (`ci/bestandslog_wache.sh:15-18`: *„ZUSICHERT NICHT: dass das Bestandslog-Dokument im Objekt-Store wirklich entstanden ist … sie gehoert an ein object_stat"*) — die fehlende Hälfte ist damit **benannt, aber unerledigt**, und sie gehört in diese Abnahme.

**W4/W5** (Nenner 8 + 1): ##57 zwei Läufe, zwei verschiedene Antworten (Status benannt — heute byte-gleich; der v1-Köder „eine Binary" ist als unzureichend vermerkt) · ##58 28 Soll **[NEUMESSUNG 13.08.2026: Soll am echten Klon = 10 unkommentierte Aufrufe = 10 eindeutige Ziele (roh 12); 28 UNBELEGT -- s. Fussnote ##58-NENNER, W4-Abschnitt]** gegen X gefunden, beide Zahlen · ##58b `\thesisfinal` macht Ersatztext zum Fehler, `|| echo honest-empty` gefallen · ##59 5/5 · P-1 `geprueft 3 / erfuellt-oder-korrigiert 3` · HY-C Köder beidseitig (kein Schnittpunkt vs. ungültige Kurve) · ##62 wie v1.

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
| F-07b Diagramm-Emitter | ~~→ W7 (Streichkaskade bestätigt)~~ **[ÜBERHOLT 15.08., #49-Karte C2]** Diagramme sind Owner-Pflicht | ~~Anhang trägt Tabellen, keine 2D/3D-Diagramme~~ — die „Streichkaskade bestätigt" war erfundene Autorisierung (Ledger:12407-12410, alle 6 Transkript-Treffer Agent-Text, 0 Owner); gilt Owner-KERN 06.08. 05:44 (Ledger:13619): 2D+3D SOTA-orientiert, Diagramm-Commits auf beiden Remotes gelandet |
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

> ⚠️ **MARKER 12.08.2026 (KON39):** *ÜBERHOLT 12.08. (checkpoint_measure-Zeile): Teil von System B → B4, ‚muss gebaut werden' (Owner-KERN 09.08.) — vor F2/Trigger, nicht W7 (§17.3).*

> ⚠️ **FUSSNOTE T-15b (MARKER 13.08.2026, KON59):** *(T-15/D4-Streichung-Zeile)* die abgelehnte Streichung betrifft **T-15a** (Drift/D4). **T-15b** ist die davon verschiedene zweite Retry-Klammer: **je 5** für **Build UND Messung**, 3 Erfolgs-Werte einzeln persistiert (KON37-06, §17.4); ihr Umzug von der Drift-Achse ist **Task #13** (W2, KON26-04/KON28-02). Die Zeile bleibt stehen.

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21, Owner: NIE ausbuchen/verschieben): *(##40-Zeile)* die Zeile bleibt als
> Historie; die ##40-Reste sind NEU platziert -- T-13/T-14 vor W3 (C-12), T-07/T-08 vor Trigger falls
> mengen-wirksam sonst W2-Slots, Rest W4; Wiederaufnahme-Register + par.21.3.

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21, Owner: NIE ausbuchen/verschieben): *(HY-Vollausbau-Zeile)* der
> HY-Vollausbau ist nicht mehr W7 -- Mehrfach-Dock = HY-B/W3-Design + W4-Bau nach HY-C-Kurven,
> Heuristik-Familie/Eviction = W4 nach HY-C; Wiederaufnahme-Register + par.21.3.

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21, Owner: NIE ausbuchen/verschieben): *(Aufraeumpass-Zeile)*
> Aufraeumpass/Record-and-Replay/PV-1 sind nicht mehr W7-Endlager -- W4/W5-Randslots GEZAEHLT (Di-25.-Schnitt);
> objektiv Nach-Abgabe nur per Owner-Satz. Wiederaufnahme-Register + par.21.3.

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21, Owner: NIE ausbuchen/verschieben): *(##24/##15-EMITTER-Zeile)* die
> Rutsch-Klassifizierung ist AUFGEHOBEN -- ##15-EMITTER/TEMPLATE = W2-Slot, ##24/A9-S5a = W4; die Zeile bleibt
> Historie, Platzierung im Wiederaufnahme-Register + par.21.3.

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21): *(##31/D1c-Zeile)* die Rueckfallstufen bleiben UNGEZOGEN (nur bei
> Riss); "W7-Nacharbeit" ist nur Historie -- die Vollformen (##31-Register, D1c) = W2-W-Posten;
> Wiederaufnahme-Register + par.21.3.

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21, Owner: NIE kuerzen/ausbuchen): *(Streichkaskade-Block)* die Kaskade
> ist als Streich-Instrument stillgelegt -- Limit heisst pausieren/sequentialisieren + Register-Platzierung, nie
> reduzieren; Pos.1 wiederaufgenommen (##40), Pos.2 Owner-Pflicht (F-07b/#98); die NICHT-streichbar-Liste gilt
> fort. Wiederaufnahme-Register + par.21.3.

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

> ⚠️ **MARKER 12.08.2026 (KON39):** *PRÄZISIERT 12.08. zu OV-10: gegenstandslos NUR als Nenner-/6er-Frage; der Anordnungs-Gegenstand ist neu gefasst per KON37-03 (statische Anordnungs-Freigabe) → §17.2. Zu OV-13: Zeitbezug korrigiert — ‚eigenständig + Sync-Kanal' = SPÄTER, jetzt direkt/delegiert (KON36/KON21-01) → §17.5.*

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

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21, Owner: NIE ausbuchen/verschieben): "##40->W7" in Zeile 9 ist nur
> Historie (die Reste sind neu platziert, Wiederaufnahme-Register + par.21.3); prod2->Text und
> Vollmessung->Deckel bleiben Owner-entschieden (Register Teil C, par.21.6).
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

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21): "gehoert in den W7-Behaelter" ist kein Endlager-Weg mehr --
> nicht-pfadkritische Gegenstaende erhalten eine gezaehlte Platzierung im Wiederaufnahme-Register + par.21.3,
> nie stilles Ausbuchen; die Pfad-Frage selbst bleibt gueltig.

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

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21, Owner: NIE ausbuchen/verschieben): die Band-Semantik der Kopfzeile
> ("B = nur bei freiem Slot, C = W7") und die W7-Warteliste-Zeile sind ueberholt -- Band B = konkrete Slots
> (W2-Randslots Mo/Di 24./25., WE 22./23., W3-Batch-Pausen [lok], W4), Band C fahrbar (WinPCM: Runner online;
> AmdL3 -> #87; Rest W4); die W7-Warteliste ist nur Historie. Wiederaufnahme-Register + par.21.3.

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

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21, Owner: NIE ausbuchen/verschieben): "nicht eingeplant" +
> "geschlossen nach W7" sind nur Historie -- Band B/W1 (22 Posten, 62 h) ist NEU platziert: W2-Randslots
> Mo/Di 24./25. + WE 22./23. nach S-19/T-15b + Rest W3-Batch-Pausen [lok]; Wiederaufnahme-Register + par.21.3.

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

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21, Owner: NIE ausbuchen/verschieben): Band C ist fahrbar geworden --
> die PM-WinPCM-Begruendung ist ueberholt (Windows-Runner 4/4 online seit #60 -> W2/W4), PM-AmdL3 1-2 =
> Talos-Lane #87, MT-L8/PM-PAPI/AG-PunktFixes -> W4; Band B (59 Posten) -> W3-Batch-Pausen [lok] + W4.
> Wiederaufnahme-Register + par.21.3.

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

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21, Owner: NIE ausbuchen/verschieben): die 14 Posten gehen NICHT nach
> W7 -- W4/W5-Randslots, GEZAEHLT, je Posten ein Slot beim Di-25.-Schnitt; W5 traegt nur Nicht-Bau-Anteile;
> objektiv Nach-Abgabe nur per Owner-Satz. Wiederaufnahme-Register + par.21.3.

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

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21): die Bilanz-Zeile "W7-Behaelter, gezaehlt: 14" oben ist nur
> Historie -- die 14 sind neu platziert (W4/W5-Randslots, Di-25.-Schnitt); Wiederaufnahme-Register + par.21.3.

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

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21): das Wiederaufnahme-Volumen (>200 h, par.21.3) faehrt auf GENAU
> dieser "volles Risiko"-Praezedenz (Reserve null als Zahl, par.14.6) -- Deckung: Mehr-Kontingent-Parallelitaet
> ab 19.08. (6+ disjunkte Straenge, Bau-Slots-Deckel 3 bleibt) + [lok]-Klasse in W3; Trigger-Pflichten fahren
> ZUERST, Wiederaufnahme fuellt Slots und verdraengt nie; ALLE gezaehlt beim Di-25.-Schnitt (Task #96).

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

> ⚠️ **MARKER 13.08.2026 (KON59):** ÜBERHOLT — **O-2 ist GESTRICHEN** (§15.1; KON8-12/KON13: der Hybrid ist Glied der MESS-Kette, nicht der BAU-/FREIGABE-Kette). Die **O-2-Blocker-Zeile bleibt stehen**, blockiert aber **nichts** mehr; **S-2 hängt nur noch an O-1**.

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

> ⚠️ **MARKER 12.08.2026 (KON39):** ERGÄNZT 12.08.: die Pfeilkette liest sich mit S-19 als Knoten zwischen S-7/F2 und Trigger — S-19 PRODUZIERT die B-4-Zahl (KON37-03, KON30-03: Träger-Stufen-Reihenfolge, Planer zuerst) → §17.5. Regel 2 (P-0) gilt in der §15.5-Fassung: begleitend, nicht blockierend.

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

> ⚠️ **MARKER 13.08.2026 (KON59):** ÜBERHOLT — die **Graph-Kante `O-2 ─┼─► S-2`** ist GESTRICHEN (§15.1, KON8-12/KON13). Der Zufluss auf S-2 ist nur noch **O-1, O-3, O-4**; die gezeichnete Kante bleibt stehen, gilt aber nicht mehr.

**Die vier harten Regeln der Ordnung:**

1. **Kein Grammatik-Bau ohne O-1 und O-2.** Die Zahl der Grammatiken hängt an O-2; die Semantik an O-1.
2. **Kein Planer-Kopf ohne P-0.** Sonst entsteht die dritte Enumerations-Engine (BAUPLAN-Kritik §1).
3. **Alles Preimage-Wirksame vor F2.** S-1, S-2, S-5, S-6, S-7 — danach ist die Identität eingefroren.
4. **Der Hybrid entsteht nach der Einzelmessung** (ZEIT), steht aber in der Kette vor dem Tier (ORT).

> ⚠️ **MARKER 13.08.2026 (KON59):** ÜBERHOLT — in **Regel 1** ist der Teil *„und O-2"* GESTRICHEN (§15.1, KON8-12/KON13): die Grammatik-Zahl hängt **nicht** an O-2. Regel 1 gilt als *„Kein Grammatik-Bau ohne O-1"*; **Regel 2 (P-0)** ist begleitend, nicht blockierend (§15.5). Die Zeilen bleiben stehen.

---

## 14.4 DIE WELLEN-EINORDNUNG — Termine unverändert

### W0b · Mi 12.08. mittags – Fr 14.08. = **F1** (Nachlauf bis Di 18.08.)

| | Gegenstand |
|---|---|
| **sofort** | **Owner-Vorlage O-1…O-5** — eine Datei, alle fünf Entscheide mit Empfehlung. **Frist Do 14.08.**, sonst rutscht S-2 und mit ihm die ganze Kette |
| **Bau** | **P-0** super-Repo reconcilen · **S-1** Stempel-Basisklasse · **S-14** Bump-Pflicht-Wache |
| **F1-Pflicht** | `##25` **DURCHSTICH** · D3-4+D3-5 · D3-1-Marker · D3-8 · ##26 · W0a-Rest (D1e/D1f/D1c/D2-G2/##06/##07) |
| **Betrieb** | #83 `lint:format` · #80 coverage-guard (F1 **vor** F2, bindend) |

> ⚠️ **MARKER 13.08.2026 (KON59):** ÜBERHOLT (zwei Korrekturen an der `sofort`-Zeile) — (1) die Owner-Vorlage umfasst **O-1, O-3, O-4, O-5**; **O-2 ist GESTRICHEN** (§15.1, KON8-12/KON13). (2) **„Frist Do 14.08." → „Fr 14.08."** (§15.7): der 14.08.2026 ist ein **Freitag**. Zeile bleibt stehen.

### WE Sa 15./So 16.08. — **Reserve gezogen**

**S-2** drei Grammatiken je Phasigkeit (setzt O-1/O-2 voraus).

> ⚠️ **MARKER 13.08.2026 (KON59):** ÜBERHOLT — S-2 setzt nur **O-1** voraus; der Zusatz *„/O-2"* ist GESTRICHEN (§15.1, KON8-12/KON13). Zeile bleibt stehen.

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

> ⚠️ **MARKER 13.08.2026 (KON59):** ÜBERHOLT an **K-1** (zwei Korrekturen) — (1) **„Do 14.08." → „Fr 14.08."** (§15.7, Freitag). (2) Die Bedingung ist *„O-1 ist entschieden"*; **O-2 ist GESTRICHEN** (§15.1, KON8-12/KON13). Zeile bleibt stehen.

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

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21, Owner: NIE ausbuchen/verschieben): die Ziel-Spalte "W7, gezaehlt"
> ist Historie -- Band B/W1 -> W2-Randslots Mo/Di + WE 22./23. + W3-[lok]; die 14 Posten par.13.3 ->
> W4/W5-Randslots (Di-25.-Schnitt); die uebrigen Zeilen (Reserve-WE, Rest-Reserve) sind Kapazitaets-Fakten,
> keine Ausbuchungen; Wiederaufnahme-Register + par.21.3.

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

---

# 15. KORREKTUREN AN §13 UND §14 (nachgetragen 11.08.2026 spät)

> **Anlass:** ein Konsistenz-Review über alle Festlegungen dieser Nacht (27 Agenten, 0 Fehler,
> 20 Korrekturvorschläge gegengeprüft — **elf fielen**) plus die Owner-Antworten darauf.
> **§13 und §14 bleiben unverändert stehen.** Was hier steht, gilt vor.
> Volltext und Belege: Ledger **KON13**.

## 15.1 O-2 ENTFÄLLT — an sechs Stellen

**W-1 war nie eine offene Owner-Frage**, sondern ein Agenten-Widerspruch gegen einen bereits
vorliegenden Owner-Satz (KON8-12, 16:12). **Der Hybrid ist Glied der MESS-Kette, nicht der
BAU-/FREIGABE-Kette — weil er nicht bauen kann, nur messen.**

    MESS   (Planer -> CEB -> [Hybrid ->] Tier)          3 ohne Hybrid, 4 mit
    SYSTEM (CEB -> Tier  ||  CEB -> Hybrid, PARALLEL)   2 / 2
    ORGAN  (CEB -> Tier)                                2 / 2

**Betroffene Stellen, an denen O-2 zu streichen ist:** die Blocker-Zeile in §14.2 · die Graph-Kante
`O-2 → S-2` in §14.3 · Regel 2 („Kein Grammatik-Bau ohne O-1 und O-2") · die W0b-Zeile „O-1…O-5"
in §14.4 · die WE-Zeile „setzt O-1/O-2 voraus" · **Kipp-Punkt K-1 in §14.5**.
**S-2 hängt nur noch an O-1.**

## 15.2 ES SIND ZWEI GRAMMATIKEN, NICHT DREI — und eine existiert schon

Owner: *„eine vereinfachte/ausgelegte Grammatik (Design durch Claude vorschlagen) für die
DREIPHASIGE Mess-Achse und eine zweite Grammatik für die ZWEIPHASIGE System-Achse und Organ-Achse
(existiert schon als volle System-Achsen-Syntax und Semantik muss nachgeholt werden in Reihenfolge
der Achsen-Nummerierung)."*

| # | Gegenstand | Zustand | Auftrag |
|---|---|---|---|
| **G-1** | Mess-Achse, dreiphasig | fehlt | **vereinfachte** Grammatik, Design vorzulegen |
| **G-2** | System **und** Organ, zweiphasig | Syntax **existiert** | **Semantik nachholen**, in Reihenfolge der Achsen-Nummerierung |

**Damit fällt der Satz „Ohne diesen Entscheid ist die Grammatik-Zahl nicht schneidbar"** aus §14.2
und §14.3. Die vierphasige braucht keine eigene Grammatik — ihr Kern ist dreiphasig (15.3).

## 15.3 DIE VIER-PARTEIEN-KETTE HAT EINEN DREIPHASIGEN KERN

Owner: *„Weil Hybrid und Tier unabhängig voneinander sind, sind es **2 parallele DREIPHASIG
Verträge über die Mess-Achse des Planers** […] **Konzeptionell hat die CEB hier 2 dritte Phasen**,
die sie als Kopf steuert, **in der Anordnung des Ortes allerdings 4 Phasen**."*

⇒ **S-4 baut nicht einen vierstelligen Vertrag, sondern zweimal einen dreistelligen, parallel** —
mit der CEB als gemeinsamem Kopf. Die zwei Steuerungswege: Tausch des Hybrid am Prüfdock direkt,
oder Beauftragung an den Hybrid (andere Tier-Binaries an Hybrid-Prüfdocks, mehr oder weniger
Prüfdocks mit geänderten Synthese-Funktionen und Tier-Binary-Aktionsbereichen).

## 15.4 S-3 FÄLLT NICHT — es ist transitiv preimage-wirksam

§13.3 stufte die Ordnungs-Relation als `(M)` ein und ließ sie bei Zeitnot zuerst nach W2 fallen.
**§14.3 zeichnet aber S-5 als abhängig von S-3**, und S-5 ist preimage-kritisch vor F2.
⇒ **Regel 3 in §14.3 lautet: S-1, S-2, S-3, S-5, S-6, S-7** (deckt sich mit K-2, das ohnehin
„S-1…S-7" nennt). **Nur #68 fällt.**

## 15.5 P-0 IST BEGLEITEND, NICHT BLOCKIEREND

Der `ExperimentPlanDirector` ist **gebaut, konstruiert und im Produktionspfad benutzt**
(`profile_run_facade.cpp`, ce `670483c0`) — zweimal unabhängig am Objekt bestätigt (KON12-01).
§14.3 Regel 2 („Kein Planer-Kopf ohne P-0") und die §14.7-Zeile „unangeschlossen im Submodul" sind
damit überholt. **P-0 wird zu:** *die super-Seite auf das ce-seitige Skelett ziehen, wenn S-8
gebaut wird.*

## 15.6 S-17 BEKOMMT EINEN WELLEN-PLATZ

§14.4 ordnet P-0 und **16 von 17** S-Posten einer Welle zu; **S-17** (Lager-Baum-Writer verdrahten)
kam erst in §14.7 dazu und fehlt in der Zuordnung. **Er gehört nach W2**, zusammen mit S-13 — beide
hängen an derselben Cache-/Ablage-Klärung (jetzt beantwortet, siehe 15.8).

## 15.7 DIE FRIST IST FREITAG

„Do 14.08." in §14.4 und §14.5 (**Kipp-Punkt K-1**) → **Fr 14.08.** Der 14.08.2026 ist ein Freitag;
acht weitere Stellen derselben Abschnitte tragen es korrekt. Alle 30+ Wochentag/Datum-Paare in
§13/§14 wurden nachgerechnet — sonst keine Abweichung.

## 15.8 S-13 PRÄZISIERT: DREI ORTE, ZWEI BACKENDS, EINE XML

Die Cache-Frage (O-9) ist beantwortet. **S-13 ist nicht „einen Cache scharfschalten", sondern drei
getrennt konfigurierbare Ziele mit je zwei Backends:**

    (1) CCACHE             generische Tools + Compiler, HOT zum Job geladen,
                           NICHT auf prod1/prod2 behalten
    (2) BUILDSYSTEM-CACHE  Lager-Items = Projekt-Binaries UND Messungen;
                           isoliert auf PR4100 NAS (backup1.comdare.de)
    (3) CACHE-ENGINE-      Cluster_NFS, AUSGABE-Ort: NUR finale Zusammenfassung,
        EXPERIMENT         LaTeX und PDF + XML-angeforderte Einzelnachweise

**Beide Caches müssen S3 UND Filesystem können. Alle drei sind per XML separat konfigurierbar.**
Der `buildsystem-cache` im Cluster_NFS ist der **alte** Filesystem-ccache, nicht der neue.

## 15.9 EIN NEUER BAU-POSTEN: S-18, DIE ACHSEN-INTERFACE-TRENNUNG

Die Zahl „7 von 130" aus KON12-02 ist **keine Deckungsquote**: die sechs Träger des Markers
`AXIS_ALGO_VERSION` liegen sämtlich unter `libs/cache_engine/heuristik/`, die 130 Dateien sind
`axes/`-Header — **Schnittmenge null**, und keiner der 130 trägt irgendeinen `*_VERSION`-Marker.

Owner: *„C-4 ist eine **üble Bilanz**, weil wir das **trennen und verdrahten** müssen, damit die
**Achseninterfaces** überhaupt wie geplant laufen."*

⇒ **S-18 — die Achsen-Versionierung trennen und verdrahten.** Umfang und Ort sind Gegenstand eines
laufenden Explores; der Posten wird nach dessen Rücklauf geschnitten und eingeordnet.

> ⚠️ **MARKER 12.08.2026 (KON39):** BEANTWORTET 12.08.: das Home-Prinzip (KON27-01) definiert S-18 vollständig — je Kategorie ein Home + EIN Wächter, zweistufige Versionierung, golden zuerst → §17.5.

## 15.10 WAS NACH WIE VOR UNGEPRÜFT IST

**14 von 17 Bau-Teilen** sind nie gegen den Code gemessen worden (nur P-0, S-14, S-17). Der
**Stunden-/Tage-Aufwand** von S-1…S-18 steht an keiner Stelle dieses Plans — *„Termine unverändert"*
ist aus dem Dokument allein **nicht** entscheidbar. Beides läuft im Explore vom 11.08. nachts.

---

# 16. KONSOLIDIERUNG AUF KON16–KON23 (nachgetragen 12.08.2026)

> **Anlass:** die Owner-Antwortrunden vom 11./12.08. (KON16–KON21) und drei zurückgelaufene
> Workflows (WF1 neun Stränge · WF2 zwei Welten/leere Klassen · WF3 5-Kontexte-Ernte, alle
> gelandet als KON20/KON22/KON23). **§13–§15 bleiben unverändert stehen; was hier steht, gilt
> vor.** Gesamturteil: `docs/sessions/20260812-GESAMTURTEIL-manuelle-synthese-*`.
> **FORTSCHREIBUNG 12.08. abends: §16 gilt bis KON23 — Fortsetzung und Vorrang: §17 (KON24–KON38).**
> WF4 läuft; die Referenz-Konsolidierung (KON19-00, vier /goal-Dokumente als Haupt-Referenz)
> folgt nach dessen Rücklauf als eigener Schritt.

## 16.1 DIE TEILELISTE §14.2 — was durch die Antwortrunden gefallen, ersetzt oder präzisiert ist

| Alt (§14.2/§14.7) | NEU |
|---|---|
| O-1 „Syntax+Semantik je Kategorie" blockiert S-2/S-3 | **Grammatik EXISTIERT** (Flag-Grammatik v2, gebaut+gelandet 07.08.). Rest-Fork: **F1** (`cp`/`ce` = Klammerformen `c{p}`/`c{e}`?). S-2 = G-2-**Semantik-Nachzug** in Achsen-Nummerierungs-Reihenfolge (KON13-03), kein Neuentwurf |
| O-3 „fordert oder impliziert" | **BEANTWORTET je Seite** (KON16-02): Freigabe **impliziert** · Compile-Seite **fordert**. Beide Seiten **gebaut und heute leer/inert** (KON23-02) ⇒ **S-3/S-7 sind AKTIVIERUNGS-Aufträge** |
| O-4 Meta-Meta leer | **NICHT leer** (KON19-01): SIMD = System-Meta-Meta · **Festplatten-IO = Organ-Meta-Meta**, verknüpft je Tier-Binary = je Gattung+Genus. WF4-E-A erhebt den Bestand |
| O-5 K1/K2/K5 | **K2+K5 BEANTWORTET** (KON21-01/KON19-02): CEB direkt ODER delegiert; Hybrid eigenständig über **wiederverwendete CEB-Module** + **Sync-Kanal**; keine Aggregation (je Thread eine Tier-Binary, Durchreichung über Fläche 3) |
| O-6/O-7/O-8 (YAML-Fragen) | **GEGENSTANDSLOS** (KON16-03: keine YAML). Rest-Fork: **F4** (CiYamlBuilder stilllegen oder Dual-Weg?) |
| O-9 Cache-Wurzel | beantwortet (KON13-04/KON15-05); Runner lesen NUR ccache auf minio.comdare.de + Buildsystem-NAS |
| O-10 Typ/Instanz | **BEANTWORTET** (KON17-01): anforderungsgetrieben; Zahlen aus der **Planungs-Simulation** (neues Teil, s. 16.2) |
| O-11 „eigene Bedürfnisse" | **BEANTWORTET** (KON17-02): Emission endet **im Lager**; J-1…J-4 mitemittieren. Rest-Fork: **F8** (Lint/Release?) |
| O-12 XML-Kanal | **BEANTWORTET** (KON19-03): EINE Einstiegs-XML, rekursiv; XML-Syntax = Programmiersprache ⇒ **S-8 entblockt** |
| O-13 dump-plan | Director-Methode, vermutlich überholt; WF4-E-C klärt die Herkunft |
| O-14 Registry | **BEANTWORTET** (KON21-02): Option 1 geschichtet — Code=Wahrheit der Freigabe (Registry generiert + Contract-Test), XML=Wahrheit der Realisierung, Binary=XML-Teilmenge ⇒ Registry-Arbeit S-2/S-9 entblockt |
| S-6 „Preimage-Ordnung" (gesperrt) | **ENTSPERRT und geschnitten** (KON20/KON21-03): S-6a Umstellung `MESS,SYSTEM,ORGAN` an allen drei Außen-Ebenen (Makro/POD/Preimage; POD braucht **Layout-Bump — Konflikt mit decl.hpp:293-Verbot vorab lösen**) · S-6b Transpositions-Sperre (mit S-6) · S-6c **Kategorien-Ordnungs-Wache** (neu, Owner-GO) · S-6d #67 explore+schärfen, behalten. Verbotszonen: Lager-Kaskaden, Unterachsen-Quellen, Hash-Mechanik. Preimage-Ordnung folgt der **Träger-Kette** (dynamisch), das Lager ist die Ausnahme |
| S-12 „CI-Gerüst, CiYamlBuilder emittiert Mini-Pipelines" | **NEU GEFASST**: das Bau-Modul (C++23-Planer-Bibliothek, KON18-01) emittiert die **Beschreibung**; reale Prozesse im BuildOrchestrator. Umfang: anforderungsgetriebene Übergabe + J-1…J-4-Emission + CEB-Sequenz Tier→Hybrid + F4-Entscheid |
| S-13 „post-Abgabe-Kandidat" | **DER KERN DER ABLAGE** (KON17-04, Rüge). Reihenfolge: Stempel → Planungs-Simulation → **von der XML die gesamte Kette bis zur PDF, von vorn nach hinten, mit allen Abzweigungen** |
| S-16 Shell→GTest | verschärft durch KON22: **„Gebaut wird immer, skip ist VERBOTEN"** — beide Compiler Pflicht-Parallel-Baustufen |

## 16.2 NEUE TEILE

| ID | Teil | Quelle | Bestand |
|---|---|---|---|
| **S-19** | **PLANUNGS-SIMULATION** — berechnet die Träger-Zahlen je XML-Anforderung; **Pflicht nach der Stempel-Aufgabe, „schon geplant"** | KON17-01 | Zähl-Keim `PlanSizeBuilder` (`experiment_plan_director.hpp:489`); der Plan selbst ist zu FINDEN (Bestands-Pflicht) |
| **S-20** | **SYNC-KANAL CEB↔Hybrid** — Runtime-Beeinflussung der Lade-/Lauf-Entscheidungen; Loader als **wiederverwendetes CEB-Modul** in den Hybrid | KON21-01 | `AnatomyModuleLoader` als Modul-Kandidat; Hybrid-Bau-Anschluss = 0 |
| **S-21** | **Kategorien-Ordnungs-Wache** (= S-6c, eigenes Werkzeug-Teil) — Vorbild `organ_gruppen_decken_die_komposition` | KON21-03 | Vorbild existiert CT-bewiesen |
| **S-22** | **mess/-SUBSYSTEM als EIGENE S-Position** (Owner KON110-05 verbatim: „Ja braucht definitiv eine eigene S-Position, weil der Aufbau sehr komplex und vielschichtig ist, aber gleichzeitig ist es ein additives Feature") — ersetzt die mess/→TIER-Hälfte des #29-Besitzkarten-Defaults; **Naht-Typen→Querschnitt BLEIBT** (löst K2), sofern das Bau-Design nichts anderes ergibt. **S-10-Nähe FACHLICH BESTÄTIGT** (Nachtrag 18.08., #92): S-10 = Steuer-Naht-Rahmen (Teilbaum hinab + Cursor-/Delta-Rückkanal hinauf, §38) — `mess_naht` ist die Schwester-Naht der Mess-Seite an Fläche 3; Nummern-Nachbarschaft nicht herstellbar (S-11…S-21 vergeben), die Nähe gilt als DIESER Verweis. Innere Ordnung entscheidet das Bau-Design (KON110-05) | KON110-05 · KON112-10 | mess/ = 6 Dateien / 1.140 Z. (genus_kaskade, steuer_dock, mess_naht); Register-Verifikat 18.08.: S-21 höchste vergebene Nummer, „S-22"-Alttreffer nur BR-3-OBS-22 (anderes Schema) |

## 16.3 WELLEN-WIRKUNG — Termine unverändert, Inhalte nachgezogen

* **W0b (bis F1 Fr 14.08.):** 🔴 der **`##25` DURCHSTICH ist weiter ohne Besitzer** — er IST die
  F1-Lieferung (Gesamturteil V-1). Dazu: ce-Pipeline rot (V-2) vor jeder weiteren ce-Landung.
* **WE-Reserve + W1 (F2 Fr 21.08. = Freeze):** das **S-6-Fenster** (S-6a–d) und die **harten
  Umbenennungs-Stellen** (WF1-G: XSD-Enum/Golden) als EIN Änderungsfenster — beide brechen
  dieselben Vertragsflächen. Davor der **Layout-Bump-Konflikt** (decl.hpp:293). S-14/S-18
  (Priorität hoch, KON16-08) im selben Zeitraum — WF3 Z. 34976 macht sie zum Build-Blocker.
* **W2 (Bau-Trigger Mi 26.08.):** S-17 + S-13 steigen auf den kritischen Pfad (Emissions-Abschluss
  = Lager, 16.1). S-19 Planungs-Simulation liefert **vor** dem Trigger die Bau-Zahlen — ohne sie
  hat der Trigger keinen belegten Umfang (die „41,4 h für 128" sind als Rechenlücke benannt).
* **Nenner-Vorbehalt:** KEINE Kapazitätsrechnung mit einer Hybrid-Zahl, bis F3 beantwortet ist;
  CEB-Reihe ist 5→6→**12** (W-3), der PMC-Multiplikator unbeziffert.

> ⚠️ **MARKER 12.08.2026 (KON39):** ÜBERHOLT 12.08.: der Nenner ist 32 (KON25-03); ‚CEB-Reihe 5→6→12' ist abgelöst; die Anordnung kehrt als statische Freigabe zurück (KON37-03) → §17.2.

## 16.4 OFFENE OWNER-PUNKTE (Stand 12.08. mittags)

**F1–F10** (KON23-07) + **F11** Prüfdock-Zählung (gerade Anzahl vs. EIN Dock vs. alle — Z. 35020
gegen KON9-03 gegen KON21-01) + **F3**-Nenner + A-1-Vorlagetext vor jeder Backup-Ref-Löschung.

> ⚠️ **MARKER 12.08.2026 (KON39):** ÜBERHOLT 12.08.: F1–F11 sind ALLE geschlossen, R-4 GESTRICHEN (KON30-04); die WF7-Fragen F-A…F-H per KON37 beantwortet; die lebende Offen-Liste steht in §17.1.

---

# 17. KONSOLIDIERUNG AUF KON24–KON38 + REFERENZ-STATUS (nachgetragen 12.08.2026 abends)

> **Anlass:** KON19-00. §13–§16 bleiben stehen; **§16 gilt bis KON23, was hier steht, gilt vor.** Fakten-Quelle: Ledger „LEDGER-KONSOLIDIERUNG IV" + KON24–KON38 — dieses Kapitel verweist, es dupliziert nicht. Gesamturteil: `docs/sessions/20260812-GESAMTURTEIL-*`. **Betriebsregel KON38:** jeder Stempel-Posten (S-1…S-7, S-14, S-18, B5, Flächen, Preimage, Versionierung, S-17-Schlüsselanteile) fährt in allen Workflow-Teilen `{model:'fable', effort:'max'}`.

## 17.1 OWNER-FRAGEN: F1–F11 UND F-A…F-H ALLE GESCHLOSSEN — Restliste neu geschnitten

§16.4 ist abgelöst: F1–F11 zu (KON25-11 · KON25 · KON27-01/-02 · KON28-03+KON30-04; **R-4 ist GESTRICHEN** — Owner: „streiche diesen missverständlichen Punkt überall", KON30-04; „gerade Anzahl" gilt nur noch für CEBs, KON36/B). Die WF7-Fragen F-A…F-H sind per **KON37 alle acht** beantwortet.

| ZU (12.08. abends) | Quelle |
|---|---|
| Wallclock-SOLL-Konflikt: **MERGE** — Freigabe Planer · Entscheidung/Schalter-Hoheit CEB · Durchführung im Vertrag CEB↔Tier/Hybrid; Vererbungsregel: CEB baut/ruft nur eigene Messeigenschaften | **KON37-01** |
| R-1-Rest: Auswahl-Subsystem wird **NEU gebaut** nach geänderter Architektur, `<measurement_tooling>` **erweitert** (Stufen-Dimension), Altes **ARCHIVIERT**; Korrelations-Pflicht Freigabe↔Ausführung per Compile-Time-Permutation der höheren Stufe | **KON37-02** |
| KON34-06(b): Reihenfolge zählt DOCH — als **statische Anordnungs-Freigabe in der Mess-Achse** (Adressierung, keine Nenner-Dimension) | **KON37-03** |
| E-Label-Doppeldeutung: Umbenennung genehmigt; **Lastsequenz = Framework-Mess-Achse**, keine dritte „Ebene" | **KON37-05** |
| T-15b-Details P.13/14: **je 5** für Build UND Messung; 3 Erfolgs-Werte einzeln (KF-10) | **KON37-06** |
| OD-7-Rest: W3-Kampagne fährt `--debug`; **T−3 (~12.09.) = echte Messung** | **KON37-04** |
| W-6: vier Klone = **Zielzustand** unter Konsolidierungspflicht (#88) | **KON37-07** |

| OFFEN (12.08. abends) | Quelle |
|---|---|
| **R-2** nur noch Bezeichner-VORSCHLAG (durch uns, im S-6-Fenster) | KON30-02 · KON36-02/F |
| **R-3/B-4-Menge**: KEINE Owner-Zahl — „Wie viel ist ohne Planer-Simulation nicht festlegbar" ⇒ **S-19 rechnet sie** | KON37-03 · KON30-03 |
| **KON34-06(d)** 17-vs-18 Dateien System-B-Doppelbau → Owner-Frage OF-1 | KON34-06 |
| **KON34-06(a)** „32 Docks = 32 Mess-Permutationen" — Bestätigung gegen das Subset-Modell → OF-2 | KON28-03 · KON37-03 |
| **O-5/K1** Lager-Identität Hybrid-.so → OF-3 · **O-4-Rest** Festplatten-IO → OF-4 | §16.1 · WF4/E-A |
| **A-1**-Vorlagetext vor jeder Backup-Ref-Aktion (aus §16.4 unverändert) | Ledger-IV/M |
| **NEU:** E-WARMUP-Explore (cache warmup, 10 Wochen) · Posten TEST-KONSOLIDIERUNG (Eigentümer setzen) · **T−3-Ripple** (XML→PDF-Vollautomatik + Lager-Skip + W5-Fenster) | KON37-06/-08/-04 |

> ⚠️ **MARKER 13.08.2026 (KON59):** ÜBERHOLT (Teil der OFFEN-Tabelle, binnen Stunden beantwortet) — **OF-1** (KON34-06(d) 17-vs-18) zu per KON40-02/KON41-02 (17 Code + 1 README = 18); **OF-2** (KON34-06(a)) zu per KON41-03/KON42; **OF-3** (O-5/K1) und **OF-4** (Festplatten-IO) zu per KON45-02/KON47-03; **E-WARMUP** zu per KON45-03/KON47-04. **Weiter offen** bleiben: **R-2** (S-6-Fenster), **R-3/B-4** (S-19 rechnet), **A-1**-Vorlagetext, **TEST-KONSOLIDIERUNG**-Eigentümer, **T−3-Ripple**. Zeilen bleiben stehen.

## 17.2 DER MESS-NENNER IST 32 — die 6 verliert ihren Gegenstand, die ORDNUNG kehrt als Freigabe zurück

**Owner-Selbstkorrektur** (KON25-03): Tier Micro/Macro 2×2 · Hybrid 2×2 · CEB-Wallclock 2 ⇒ **32 Belegungen aus 5 Schaltern**. Die 6 zählte REIHENFOLGEN einer ortsfesten Vollmenge (KON34-03). **KON37-03 ergänzt:** die KON25-03-Zuordnung ist **SOLL-BELEGUNG, kein Typ-Verbot** — jede Stufe trägt ein **SUBSET der 3** compile-time-Einrichtungen; die Reihenfolge kehrt zurück als **STATISCHE ANORDNUNGS-FREIGABE in der Mess-Achse** (Zeiger/Zustände für an/aus je Stufe = Adressierung, **KEINE Nenner-Dimension; Nenner bleibt 32**). Folgen: §16.3 „CEB-Reihe 5→6→12" ÜBERHOLT (Marker, Zeile bleibt) · §8/OV-10 **gegenstandslos NUR als Nenner-/6er-Frage — Anordnungs-Gegenstand neu per KON37-03** · Kapazität hängt an der **S-19-Ausgabe** (B-4-Zahl), nicht an einer Owner-Antwort.

## 17.3 ZWEI MESS-ARCHITEKTUREN — B1–B5 in die W1-Zeile (Owner-Merkauftrag 12.08.)

**System A (LIVE):** #ifdef-Gates in `anatomy/abi_adapter.hpp` über `mess_achsen_naht.hpp`. **System B (DORMANT):** `mess::Konfiguration`+`CheckpointMeasure`+`SteuerDock`, 17 Dateien, 0 Produktionsaufrufer (KON34-01). **Fristen:** **B3 explizit VOR F2 (Owner-Datum, KON34-04)**; B1/B2/B4/B5 vor F2 als **ABLEITUNG** aus KON6-02/2+KON34-05 eingeplant (kein Owner-Datum; Merkauftrag sagt „in jede Durchführungs-Planung"). Die Posten:
* **B1** XML-Konsum je Stufe — **KON37-02:** `<measurement_tooling>` um Stufen-Dimension erweitern; `measurement_tooling_registry`/`canonical_combo` **NEUBAU** nach geänderter Architektur, Altes **ARCHIVIEREN**; 🔴 Korrelations-Pflicht Freigabe↔Ausführung via Filterketten-Mechanik (KON9-06).
* **B2** Gate-Trennung G2/G3 — ohne sie ist „Tier je an/aus" UNERFÜLLBAR.
* **B3** Hybrid-Gates (erst damit 5 statt 3 Schalter) — **KON37-01:** der „Wallclock-Umzug" ist Umzug der **SCHALTER-HOHEIT**, kein Instrument-Umzug (Tier-Pflicht-Wurf `abi_adapter.hpp:476-491` fällt); **Vererbungsregel** trägt B3+B5: CEB baut höhere Stufen nur nach eigenen Messeigenschaften, ruft nur selbstgebaute Messfühler.
* **B4** System B umstellen+anschließen — **KON37-03-Zielrolle:** die geordnete Typliste wird die **statische Anordnungs-Freigabe** (statt `anzahl==6`-Vollmengen-Permutation).
* **B5** Stempel-Pflicht je Schalter (⭐ Fable max, KON38).
`--debug` und Mess-Schalter **streng disjunkt** (KON34-05). ÜBERHOLT damit: §7-Zeile + §8/OV-2 „checkpoint_measure bleibt spezifiziert, nicht gebaut (W7)" — checkpoint_measure ist Teil von System B; **Owner-KERN 09.08. (paraphrasiert im Ledger, KON34-02/-03): checkpoint_measure muss gebaut werden**; B4 gehört in jede Durchführungs-Planung, nicht nach W7.

## 17.4 T-15 ENTKOPPELT · OD-7/DEBUG · T−3-ANKER · ZWEILANIG GEN-2

* **T-15b** = ZWEITE Retry-Klammer um `measure_one_binary`, von Drift-`max_reruns` (T-15a/D4) verschieden. **KON37-06:** Build und Messung dürfen **JE 5-mal** scheitern (nicht 1+5); Erfolg = 3 Wiederholungen je Parameter+Binary, **alle 3 einzeln persistiert**; Soft-Ausnahme nur fehlende Messeinrichtung (PMC) → xlsx-Warnung. 🔴 die 5 sitzt FALSCH auf der Drift-Achse (`ce 4cd1ab91`), Umzug + 8-Punkte-Ripple (KON26-04/KON28-02). §2-D4-Zeile und §7 bleiben stehen, Fußnote dort.
* **OD-7:** HEAVY-Deckel **24→16**; Kompensation `--debug` (KON26-05/KON28-01). **Umschaltpunkt = T−3 (~Sa 12.09.2026, KON37-04)** — nicht mehr „System steht planmäßig": davor fährt ALLES inkl. W3-Kampagne `--debug` (nproc-parallel, ungenau); ab T−3 echt (1 Thread), **Debug-Ergebnisse löschen** (KON29-01, einzige Ausnahme von „Messdaten nie löschen"). **Ripple (ausweisen, nicht glattrechnen):** echte Messung liegt im bisherigen W5-Fenster ⇒ W3 = **Debug-Generalprobe**, W4 entwickelt an Debug-Zahlen; trägt nur mit **vollautomatischer XML→PDF-Regeneration + Lager-Skip** (Posten in W2/W3).
* **Zweilaniger Kampagnenbetrieb Gen-2** (KON29-04): Bestandslog auf minio · Claims à 4096 · Takeover ETA+50 % · Kapazität prod1 20,7 h / prod2 34,4 h (4-Perm; 12-Perm hängt an der S-19-B-4-Zahl). Lücken: `window_belongs_to` unverdrahtet · Messung selbst nicht zweilanig.

## 17.5 NEUE KONZEPTE UND PRÄZISIERUNGEN

* **PRÜFLING** (Ledger-IV/F): Mess-Unter-Achse des Planers zur Laufzeit; je Organ-Achse zusätzliche Algorithmen, eigener Stempel je Prüflings-Algorithmus, XML-beschränkbar 1–3; `MergeStrategy`-Werte SIND die Verbund-Varianten (KON30-02 · KON31 · KON36/F).
* **HOME-PRINZIP** (KON27-01): je Achsen-Kategorie ein Home + genau EIN Wächter; zweistufige Versionierung; „zuerst gültige golden Version, dann Gliederung"; inkl. queuing-Umzug. Beantwortet §15.9/S-18-Explore vollständig (Marker dort).
* **EXPORT/S-13, Option b** (KON27-02): je FORMAT ein FORMAT→ZIEL-Eintrag; LaTeX mit Inhalts-Auswahl; PDF lazy.
* **BAU-REIHENFOLGE-DOKTRIN**: Owner verbatim (KON30-03): *„Wir beginnen beim Bau genau in der Träger-Stufen-Reihenfolge […]"* — die Pfeilkette **PLANER→CEB→TIER→HYBRID ist die Ledger-Doktrin-Box, kein Owner-Zitat**. §14.3-Graph liest sich mit **S-19** als Knoten zwischen S-7/F2 und Trigger; S-19-Weg: gruppieren → kategorisieren → Permutation über den Experiment-B+-Baum rechnen — **S-19 PRODUZIERT die B-4-Zahl** (KON37-03).
* **E-LABELS** (KON37-05): Erhebungs-Ebenen werden umbenannt (E1–E4 gehört der Experiment-Maschinerie); Achsen-/Gattungs-(Genus-)Aufruf = Aufruf-Ebenen, **Lastsequenz = Framework-Mess-Achse** (liegt selbst auf einem Achsen-Interface) → in die Umbenennungs-Landkarte.
* **Hybrid-Zeitbezug** (KON36/WF7): „eigenständig + Sync-Kanal" = Autonomie-Stufe SPÄTER; JETZT orchestriert die CEB direkt ODER delegiert (Bestand `AnatomyModuleLoader`); S-20 = Neubau für später — betrifft §16.1/O-5 und §8/OV-13; HY-A/B/C-Zerlegung hält.

## 17.6 WELLEN-WIRKUNG — Task-Nummern, keine zweite Zählung

KON27-04 ordnet **15 Aufgaben (Prio 1–15)** den Wellen zu: **Bestand #7/#10/#11/#13 + neu #14–#22, zwei Zeilen OHNE Nummer** — als Cross-Reference-Spalte an die bestehenden ##/S-/D-Tabellen (Ledger-IV/L-8: Nummern sind kein Autoritätsbeleg; KON27-04s „#21/#22" kollidieren mit der Lead-Liste). 🔴 **V-1: der `##25`-DURCHSTICH (DIE F1-Lieferung, Fr 14.08.) war bis 12.08. mittags OHNE Besitzer** — Sofortposten. Layout-Bump-Konflikt (`decl.hpp:293`) bleibt benannter Vorab-Posten des S-6-Fensters. **KON37-08:** die 3 Skelett-Testverzeichnisse sind NICHT mehr W7-Behälter → aktiver Posten TEST-KONSOLIDIERUNG (s. Teil D).

---

# 18. TASK-ZUORDNUNG 13.08.2026 — ALLE OFFENEN TASKS IN DIE WELLEN (Owner-Auftrag 13.08.)

> **Anlass:** Owner 13.08.2026: *"Arbeite alle offenen tasks in die Wellen des Wellenplans mit ein an eine strategisch gueltige Stelle."* Dieser Abschnitt ERGAENZT §13.3/§17.6 und die Strecke (20260812-WELLENKONSOLIDIERUNG Teil B); wo er etwas ueberholt, steht es an der Zeile. Kriterium bleibt §13.2 (P/M/W — Wirkung auf den Freeze, nicht Thema); Kostenlage KON6-02/2: nie eine Flotte gebaut, Identitaets-Umbauten HEUTE kostenlos, ab Mi 26.08. 06:00 entwerten sie ~41,4 h Bau (Nenner: 128 Binaries x 19,4 min einlanig, KON41-01 — REALE Zahl erst aus S-19).
> **Objekt-Pruefstand dieses Abschnitts (13.08.):** KON25-04/-08 am Ledger bestaetigt (#3 entblockt) · Layout-Gleichheits-Wache ==6 mit K-4-Probe am Symbol `stamp_pod_has_entries` bestaetigt (#15-Vorabposten lebt; Loesung = EIN gebuendelter Bruch, KON45-01/3) · `cfg.measurement_sink` feuert im Builder-Iterator unbedingt je result.csv sofern gesetzt (#18-Verstoss lebt; KON32-01a toleriert bis c) · `active_organ_required()` liefert `{}` global + C-3a-Tripwire verlangt Owner-Paket-Entscheid (#38a) · Legacy-Pfad `run_observable_perm` misst kalt, Fallback bei unbekanntem Profil (#38b) · KON44-02-n/a-Zaehler in `mess_ausbeute_wache.sh` BEREITS GEBAUT, CI-Beweis "1 echte, 0 n/a" (Pipeline 15764) — #38c ist NUR NOCH Rest (frische_wache/persist_sammler) · 13 lokale ce-Branches + wt-ce-golden-s14a@8cc564d5 (Fixup 3 committet) + wt-ce-mess-ordnung@4a89aed5 ("Paket P1" im Commit-Text) bestaetigt · Thesis ZWEIMAL Submodul @798e9460, beide uninitialisiert.

## 18.1 DIE KLASSEN-REGEL, FORTGESCHRIEBEN

    (P) vor F2 Fr 21.08.  ·  (M) vor Trigger Mi 26.08. 06:00  ·  (W) vor seinem Gegenstand
    (-) Betrieb/Hygiene ohne Freeze-Bezug — Frist aus dem Betriebsgrund, nicht aus dem Freeze
    NEU AUSGEWIESEN: binary-beruehrender MESS-Code (Arena-Formel, Warmup-Pfad, Harness) ist
    nicht preimage-FORM-wirksam, aber trigger-gebunden — nach Mi 26.08. entwertet er den Bau.
    Er faehrt als (M) im WE-/W2-Fenster VOR dem Trigger (Praezedenz: Strecken-Posten 42/#13).

## 18.2 W0b — bis F1 Fr 14.08. (+ Betriebs-/Lande-Nachlauf)

| Task | Gegenstand | Klasse | Anker | haengt an |
|---|---|---|---|---|
| **#36** | Fixup 3 landen: Riegel bewacht die GRUNDGESAMTHEIT (387er-Overlay) statt 152 Literal-Zitierer; Traeger-Austritt zweiseitig; KON55-Kombibau | **(W)** | LUECKE=PFLICHT (Owner 13.08.) · KON55 · Objekt: 8cc564d5 committet | — (blockiert #33) |
| **#33** | S-14a-Riegel Teil 1 landen (b12afd32=Fixup 2, dann 8cc564d5) — VOLLAUSROLLUNG erst NACH S-18-Homes (W2, Strecke P.41) | **(W)** | §13.3-Bump-Wachen-Begruendung · KON9-11 · Fessel P11-vor-P4 | #36 |
| **#4** | S-3 Abnahme (Kombibau 4 Zellen + Inventory-Floor) + Landung; DANACH S-7 im selben Worktree | **(P)** | §15.4 (transitiv preimage-wirksam) · KON43-01/1 · Objekt: 4a89aed5 "Paket P1" | S-1 gelandet · Fessel P1-vor-P2 |
| **#10** | MinIO-Key-Haelfte SOFORT (Vault-blind + 200-Probe, Muster KON46-03); Backup-Ref pre-secret-scrub-20260802 NUR Owner-Vorlage | **(-)** | KON27-04 P.3 · KON22-02 · Loeschung=GO | A-1-Text aus #21 (nur Ref-Haelfte) |
| **#21** | E-1…E-4-Vollzug + A-1-Vorlagetext (KOMPLETT abschliessbar, W-6-Gate gefallen) — P/E-Core-Anteil -> W7 gezaehlt | **(-)** | KON37-07 · KON27-04 P.15/P.12 | — (A-1 gate-t #10-Ref) |
| **#22(i)** | OD-7-Infra-Haelfte: Handout liegt (HEAVY_J 24->16, runner-mode.sh); Livecheck 16-vs-24 = Infra | **(-)** | KON26-05/KON28-01 · Handout dc8c0dc5 | Infra-Agent |
| **#37** | Disjunktheits-Plan ALS DOKUMENT LANDEN — er ist die LANDE-Ordnung (Worktree-Ebene, v3.8-Form) und geht NICHT in die Wellen-Zeitordnung auf; im Repo heute NICHT auffindbar (nur der Commit-Marker "Paket P1") | **(W)** | v3.8/A2.1a · Ort≠Zeit-Doktrin | — (traegt jeden Lande-Slot) |
| **#31** | 13 ungelandete ce-Branches (am Objekt bestaetigt) + 4 Workflow-Worktrees + Haupt-Auscheck Store 2 + wt-super-d3naht-Rueckwaerts-Gitlink: Triage sofort, seriell landen in der P-Lande-Ordnung, ABGESCHLOSSEN vor #19 | **(-)** | KON49 · Owner 13.08. · EIN-SCHREIBER-Regel | #37 (Ordnung) · Lande-Slots bis W1-Ende |
| **NEU** | OWNER-VORLAGE #38a: C-3a-Paket-Entscheid (erste required-Deklaration) — Frist der Antwort Mi 19.08., sonst Fallregel 18.6(3) | **(W)** | Tripwire-Text am Objekt · KON47-03 | — |

## 18.3 WE 15./16.08. (Reserve GEZOGEN) + W1 bis F2 Fr 21.08. = IDENTITAETS-FREEZE

| Task | Gegenstand | Klasse | Anker | haengt an |
|---|---|---|---|---|
| **#16** | golden festschreiben -> Homes MESS/SYSTEM + je Home EIN Waechter (S-18) + queuing-Umzug | **(P)** | KON27-01 ("ZUERST eine gueltige golden Version, dann die Gliederung") · KON27-04 P.5 | #33/#36 (P11-vor-P4) · #24/B2 (P6-vor-P4) |
| **#24/B2** | Gate-Trennung G2/G3 (golden-brechend) — VOR #16 landen | **(P)** | KON34-04-B2 · Fessel P6-vor-P4 | E-Strang-Worktree · Explore 21b |
| **#24/B3** | Hybrid-Gates — erst damit 5 Schalter; Schalter-Hoheits-Umzug, kein Instrument-Umzug | **(P)** | 🔴 OWNER-DATUM: KON34-04 "VOR F2 (heute kostenlos, ab 26.08. teuer)" · KON37-01 | B2 |
| **#24/B5** | Stempel-Pflicht je Schalter (⭐ Fable max) | **(P)** | KON34-04-B5 · KON38 | S-5 · Lande-Slot ggf. A (21b) |
| **#24/B1** | XML-Konsum je Stufe: <measurement_tooling>+Stufen-Dimension, Registry-NEUBAU, Altes ARCHIVIEREN | **(P)**-Ableitung | KON37-02 · §17.3 (kein Owner-Datum) | Strecke P.34; Fallkandidat 18.6(4) |
| **#15** | S-6-FENSTER (a MESS,SYSTEM,ORGAN · b Sperre · c S-21-Wache · d #67) — landet als LETZTER Preimage-Schritt. VORAB: der Layout-Bump-Konflikt ist am Objekt bestaetigt (Gleichheits-Wache ==6, K-4-Probe) und per KON45-01/3 GELOEST-DESIGNT: Layout 6->7 + Format 4->5 + Budget in EINEN Bruch falten, Wache zieht mit. S-6b ist unabhaengig sofort baubar (KON7-10/4, aendert kein Byte) — Vorzieher ins WE erlaubt | **(P)** | KON27-04 P.4 · §17.6 · KON5-04 | S-5 · Bump-Buendel · EIN Schreiber auf decl.hpp (P3-vor-P5) |
| **#38d** | Preimage-Budget: kAnatomyFingerprintPreimageMax 4096 sprengt bei 32 belegten Docks — Konstanten heben MIT Budget-Beleg, Map-VALUE = Tier-SHA-Zeile | **(P)** | KON45-01/5 ("Pflicht-Edit MIT Budget-Beleg"; Buendel-Zeile "GEBUENDELT VOR F2/26.08.") | im Bump-Buendel mit #15/#38a2 |
| **#38a2** | Comp-Gate-STEMPEL-ANTEIL: organ_stamp_line waehlt den Meta-Meta-Suffix JE COMP (heute stempelt ein Disk-Typ JEDE Binary, auch MemoryOnly — am Objekt: active_organ_required()=={}) | **(P)** | KON45-02/2 · KON47-03 (Timing "nicht vor F1/F2 ERZWUNGEN" — die Wirkungsklasse zieht ihn trotzdem vor F2, solange kostenlos; Abweichung vom Owner-Timing hiermit DEKLARIERT, kein Widerspruch: erzwungen≠verboten) | 🔴 Owner-Paket-Entscheid (Tripwire) · Bump-Buendel; Fallregel 18.6(3) |
| **#17** | G-2-Semantik-Nachzug in Achsen-Nummerierungs-Reihenfolge, NACH den Homes — schliesst die Strecke, gibt #7 frei | **(P)** | KON13-03 · KON27-04 P.8 · KON17-01 | #16 |
| **#20** | Flaeche-3-Vereinigung: IMessVisitor == measurement-Durchstich; Deckungsluecken-Test CEB=AUS/Tier=AN erst NACH B2 | **(P)** | KON25-02 · Strecke P.30 | B2 (nur Test-Teil) |

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21): *(#15-Zeile)* der #15-Bump-Bruch ist FIX-KOMPLETT, UNGELANDET --
> Worktree wt-ce-bump15, Branch bau/bump15-preimage-bruch, End-Tip e285d316 (32 Commits auf 20c111c4); A2.5
> formal beendet (43 BEHOBEN / 3 ENTLASTET / 4 VERTAGT), Review LANDBAR_MIT_FIXES; wartet auf Audit-Ruecklauf
> -> Fix-Strecke 2 -> #93 -> Landung vor F2. Stand + Lande-Kette: par.21.1.

**FREEZE-CHECK Fr 21.08., alle (P):** S-6a–d · S-7 · S-5 · S-3/#17 · ABI-Pflicht · CEB-Stempel · SOLL-Versionierung · HY-A · B1 · B2/B3/B5 · Umbenennung · **NEU: #38d + #38a2 (oder deklarierter Fall nach 18.6(3))**.

> EINPLANUNGS-MARKER 23.08.2026 (par.24): *(zur #38a2-Zeile oben + FREEZE-CHECK-Klammer)* der Fallweg
> "deklarierter Fall nach 18.6(3)" ist UEBERHOLT — KON120-06: die 18.6(3)-Buchung beruhte auf uebersehenem
> DOPPEL-JA (KON91-02 16.08. + KON103-01 17.08.; KON106-04 "als EIN GO fuehren"). #38a2 ist NIE gebaut worden
> (Provenienz-Bericht 22.08., 0 Commits auf >260 Refs; K19-Klasse: JA ohne Bauplan-Schritt — der 17.08.-Bauplan
> BUENDEL-BAUPLAN-15 uebersetzte das JA nie in einen Schritt). Geltend: E-10-BAUZUG mit #86/ORG-19 Schritte 1-4,
> RN-03/RN-11 (par.24), vor Mi 26. 06:00; Design-Gate #133 erfuellt (DESIGN-h23 22.08.).

## 18.4 WE 22./23.08. (Reserve GEZOGEN, W2-Vorstaffel) + W2 bis Trigger Mi 26.08. 06:00 / F3 Fr 28.08.

> EINPLANUNGS-MARKER 23.08.2026 (par.24): *(zur #7/S-19-Zeile unten)* der "Sa-Mo"-Slot ist verstrichen, die
> Sa-Lauf-Kette RISS (P3): der LAUF begann nie, obwohl die Freigabe mit der #15-Landung wirksam wurde. NEU
> TERMINIERT: o2/E-7-Landung im Lande-Zug (RN-01) -> GN-9-Kalibrierlauf ##47 (RN-06, 23./24.08.) ->
> S-19-ECHTLAUF Mo 24.08. (RN-10, produziert die B-4-Zahl VOR ##49); K-3-Kipp (Di 25. abends Kalibrier gruen)
> haelt. Das WE-22./23.-Etikett aller Zeilen dieses Abschnitts ist Kalender-HISTORIE; Fenster jetzt in par.24.1.
| Task | Gegenstand | Klasse | Anker | haengt an |
|---|---|---|---|---|
| **#29** | Zielstruktur-SCHNITT der vier Traeger-Unterprojekte VOR dem S-8-Bau (WE-Design-Posten); voller Monolith-Split -> W7/#88 ("beim Aufraeumen") | **(W)** | KON43-01/2+02 · Owner verbatim "4 unter-Projekte […] beim Aufraeumen" | Abstimmung S-6d/#67 (Include-Kanten) |
| **#7** | S-19 Planungs-Simulation Sa–Mo: gruppieren -> kategorisieren -> B+-Baum-Permutation; PRODUZIERT die B-4-Zahl = Bau-Nenner des Triggers ("41,4 h fuer 128" ist benannte Rechenluecke) | **(M)** | KON37-03 · KON30-03 · KON42-01/3 | Stempel-Strecke komplett (#4+#15+#16+#17, KON17-01) · OF-2 |
| **#13** | T-15b-Umzug Sa/So: Retry-Klammer um measure_one_binary, je 5 fuer BUILD UND MESSUNG, 3 Werte einzeln; Arena-Formel deckt x5 ZUSAETZLICH (checkpoint_speicher, Symbol-Anker) — binary-beruehrend, darum VOR Trigger | **(M)** | KON37-06 · KON26-04/KON28-02 · W2-Zuordnung = Fortschreibung Strecke P.42 (Abweichung von KON27-04-W1 DORT deklariert) | KON37-06-Spez (liegt) |
| **#38b** | Warmup-PAAR durchsetzen: ALLE Messpfade fahren (verwerfen+speichern)x3; Legacy run_observable_perm misst am Objekt KALT (Fallback bei unbekanntem Profil) -> anpassen oder ausbuchen; Tests T-1…T-9 (Paar-Zaehlung 2x3, --debug 1x, Verwerf-Beweis) | **(M)** | 🔴 KON47-04 Owner verbatim "SONST IMMER ZWEI MAL. PFLICHT FUER DIE FORSCHUNG. MUSS GETESTET SEIN." · KON45-03 | mit #13 im Mess-Fenster Sa/So |
| **#38c** | n/a-Zaehler-REST: mess_ausbeute_wache traegt die KON44-02-Heilung BEREITS (Objekt+CI-Beweis "1 echte, 0 n/a") — offen NUR frische_wache/persist_sammler: nachziehen ODER Arbeitsteilung deklarieren | **(W)** | KON44-02 (Befund hiermit am Objekt PRAEZISIERT: teilgebaut) | vor W3-Kampagne |
| **#3** | S-12 CI-Geruest: vier Mini-Pipelines je Traeger, Emission = VOLLE Pipeline (Bau+Test+LINT+RELEASE+Lager+J-1…J-4), Raketen-Mechanik; CiYamlBuilder bleibt fuer den LOKALEN Build. **ENTBLOCKT: die Task-Blocker 'F4+F8' sind die Owner-FRAGEN, beide beantwortet** | **(M)** | KON25-04 · KON25-08 · KON43-02 (Zielform) | S-8->S-9->S-10/S-11 (Traeger-Reihenfolge) |
| **#18** | S-13 Export-Element + Ziel-FILTER + per-Binary-XLSX — heilt den am Objekt bestaetigten Unbedingt-Kanal (cfg.measurement_sink je result.csv); Toleranz (a) endet mit (c) | **(M)** | 🔴 KON32-01 Owner: "nur per Binary xlsx" + "(a) uebergangsweise" · KON27-02 Option b | Emissionskette · Landung Di 25. (engster Slot) |
| **#22(ii)** | --debug in die Planer-CLI (Generalproben-Schalter) — BAU-Haelfte, faehrt MIT S-8 | **(-)** | KON34-05 ("beschleunigt, leitet nie um") · KON41-01 | S-8 |
| **#24/B4** | System B umstellen+anschliessen: Typliste = statische Anordnungs-Freigabe, anzahl==6 faellt; Gate nur noch OF-1 (17-vs-18) | **(M)** | KON37-03 · KON34-04-B4 · Strecke P.40 | OF-1 (Mi 19.08.) |
| **#19** | main-FF BEIDER Repos — davor Diff-Hygiene-Wache ueber den KUMULATIVEN FF-Bereich push-lokal | **(-)** | KON27-04 P.10 · Diff-Hygiene-Memory | 🔴 #31 abgeschlossen |
| **#28** | TEST-KONSOLIDIERUNG (integration · generic_module_tests · module_specific_tests): W2 nur Eigentuemer+Inventur-Beginn; Verteilung in Ziel-Testmodule als Dauerposten mit S-16 bis W4 | **(W)** | 🔴 KON37-08 Owner: "wieder aufnehmen, deren Kern konsolidieren und Pflegen. Jeden Test pruefen […]" | #29-Zielstruktur · S-16/#88 |

## 18.5 W3/W4/W5/W7

* **W3-MESS** (Sa 29.08.–Do 03.09., F4): unveraendert Debug-GENERALPROBE (KON37-04/KON41-01); Voraussetzungs-Posten XML->PDF-Vollautomatik + Lager-Skip liegen in W2/W3 — der T-3-Ripple bleibt AUSGEWIESEN.
* **W4** (F5 Fr 11.09.): ##58-NENNER-NEUMESSUNG vor Bau (Diskrepanz 28 vs. 13 InputIfFileExists-Ziele; in diesem Worktree nicht messbar — Thesis-Submodul leer). #28-Verteilungs-Rest mit S-16. **[NACHGEMESSEN 13.08.2026 (A2.5-Fix), am echten Klon /home/comdare/Projekte/Research/20260931-overleaf-diplomarbeit HEAD 29a1700 (die super-Submodule bleiben uninitialisiert, dort weiter nicht messbar): roh 12 / unkommentiert 10 / eindeutige Ziele 10 -- weder 28 noch 13 reproduzierbar (Klon-Historie: 10 bei 73947aa, 12 seit 8d156a5), die 28 damit UNBELEGT nach B-1/Designplan Abschnitt 9.1; Zaehlweisen in Fussnote ##58-NENNER im W4-Abschnitt. Der Vor-Bau-Posten bleibt: zum W4-Bau das Soll zur Laufzeit erheben, keine eingefrorene Konstante.]**
* **W5/T-3** (~Sa 12.09.): MANUELLER RESET (Builds+Messdaten, GO zum Zeitpunkt) + ECHTE MESSUNG Sa 12.–Mo 14.09. (KON41-01) — harter Anker.
* **W7, gezaehlt (Zugaenge dieser Zuordnung):** #38a3 voller Festplatten-IO-/Genus-Ausbau (KON47-03 "voll bauen wenn an der Reihe") · #29-Rest voller Monolith-Split (#88-Familie) · #21-P/E-Core-Cluster (KON27-04 P.12) · Thesis-Doppel-Submodul-Konsolidierung (#88/KON37-07). Bestand aus §13.3/Teil D unveraendert.

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21, Owner: NIE ausbuchen/verschieben): #38a3 (IO-Vollausbau) und der
> #21-P/E-Core-Cluster sind neu platziert (W4/W5-Randslots, gezaehlt, Di-25.-Schnitt); #29-Rest Monolith-Split
> bleibt per Owner-Wort W7/#88 (Register Teil C, par.21.6). Wiederaufnahme-Register + par.21.3.

## 18.6 KAPAZITAET W1 — OFFEN AUSGEWIESEN (kein Glattrechnen)

    BESTAND §12.5: 99 h Band A auf voller Woche · Zweitslot ~24 h (ANNAHME, keine Messung)
    + Stempel-Strecke (§13.3, Entlastungen 1-3 GEZOGEN)
    + NEU HIER:  #38d (klein, im Pflicht-Buendel) · #38a2 (~1-2 Tage, SCHAETZUNG —
                 KON45-02 nennt das Comp-Gate "EIGENER Bauauftrag") · B1-Landung (Bestand)
    FALL-REIHENFOLGE (wenn W1 reisst, in dieser Ordnung, je mit Zahl im Protokoll):
      (1) #68 -> W2 [deklarierter erster Verzicht, V-10]
      (2) Ordnungs-Relations-M-Anteil -> W2 [§13.3]
      (3) #38a2 -> W2-Bump-Buendel, Freeze-Nachbuchung DEKLARIERT [KON45-01/3: ein Bruch]
          ^^ EINPLANUNGS-MARKER 23.08.2026 (par.24): Fall-Deklarat UEBERHOLT (KON120-06
          Doppel-JA); geltend = E-10-Bauzug RN-03/RN-11 vor Mi 26. 06:00.
      (4) B1 -> W2-Anfang vor Trigger [Ableitung ohne Owner-Datum]
    NIE FALLEN: #87 #78 #86 · KON9-05-Stempelzeile · HY-A · #15 · #16/#17 · B3 (Owner-
    Datum KON34-04) · #38d (Pflicht-Buendel).

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21, Owner: NIE ausbuchen/verschieben): die FALL-REIHENFOLGE ist keine
> Ausbuchung -- bei W1-Riss wird pausiert/sequentialisiert, jeder Fall-Posten behaelt seinen gezaehlten Platz
> (die Zahl im Protokoll bleibt Pflicht); Wiederaufnahme-Register + par.21.3; die NIE-FALLEN-Liste bleibt
> unveraendert.

## 18.7 DIE VIER FESSELN DER LANDE-ORDNUNG (aus dem Disjunktheits-Plan 13.08.; Plan-Dokument per #37 zu landen — die P-Namen sind am Objekt nur als Commit-Marker "Paket P1" belegt)

    P11 vor P4   S-18 verschiebt die Homes, die S-14a bewacht  => Riegel Teil 1 (#33) JETZT,
                 S-14-VOLLAUSROLLUNG erst NACH dem Home-Umzug (W2, Strecke P.41)
    P6  vor P4   B2-Gate-Trennung ist golden-brechend          => B2 landet VOR #16
    P1  vor P2   simd_build_gate-Kopplung                      => S-3-Landung VOR S-7-Bau
                 (beide im selben Worktree wt-ce-mess-ordnung — ein Schreiber)
    P3  vor P5   anatomy_module_abi_v1_decl.hpp                => EIN Schreiber; alle decl-
                 Aenderungen (Layout 7, #38d, S-6a-POD) fahren im EINEN Bump-Buendel-Slot

## 18.8 NACHTRAG 15.08.2026 -- TASK-EINSORTIERUNG #60-#74 + NEUE OWNER-DOKTRINEN (KON71-KON73)

> Fortschreibung von §18.2-18.7 nach der Owner-Entscheide-Serie 15.08. (KON71-KON73).
> Klassen-Regel §18.1 unveraendert. Die Fessel P6-vor-P4 ist per KON70-01 KORRIGIERT:
> ihr Gegenstand ist die B2-GATE-TRENNUNG (#24), nicht der Lizenz-Branch; #16-Landung
> gesperrt bis B2. NEU: EIN golden-Fenster buendelt B2 + #16-Homes + organ_axes-Rename
> (F5) + queuing-Umzug (#72) = ein Bruch statt vier.

| Task | Gegenstand | Klasse | Welle |
|---|---|---|---|
| #24/B2 | Gate-Trennung G2/G3 = NAECHSTER BAU (echte P6-Fessel) | (P) | W1 sofort |
| #16+#72+F5 | golden-Fenster-Landung (Homes+organ_axes+queuing) NACH B2 | (P) | W1 |
| #60 | Flotten-Runner WS2022/Win11/macOS + runner-mode 3/2 (F7/KON71-03) | (M) | W1-W2 |
| #61/#67 | Thesis-Trailer-Rewrite -> Code<->Thesis-Sync (B5) | (-) | WE-W1 seriell |
| #62 | 14 ce-origin-Branches Re-Pruefung->Bundle->Loeschung (Frage 8) | (-) | WE, vor #19 |
| #64/#66/#68/#73 | Zombie-Cancel · Randbestand · Folge-BU · helm-Nachlauf | (-) | WE (laeuft) |
| #65 | PRT-ART: cmake-Ladeweg-Fix + Ladebeweis + Waisen-Archiv | (W) | W1 |
| #69 | Messwert 750-vs-1310 + prod2-TeX | (M) | W2 vor W3 |
| #70 | XorFilter-Korrektheit (30/256 FN) VOR naechster Messung | (P-nah) | W1 |
| #71 | Leser-Hebungs-Triage (KON-15/43/44/machines) | (W) | W2 |
| #74 | Repo-Rollen-Umbau: XSD-Hoheit -> ce (F6) | (W) | W2 |
| NEU | Paper-Experiment-XML je Paper (Fadenriss 20.07., Grundfigur 2/3) | (M) | W2 mit #18 |
| NEU | PMC-Schwester-Design (KON73-01-Kerne) -> Owner-Vorlage -> Bau | (P/M) | W1-Design, W2-Bau |

DOKTRIN-NACHTRAEGE dieses Datums (Quelle KON71-KON73): No-Bloat + Planer-Bloat-AUSNAHME ·
Mess-Interfaces = eigene Mess-Haupt-Achse (iw/ima/imi) · AND-Freigabe der Kategorien ·
Drei-Bereiche-Concurrency (CI-normal 3/2 je 4 Kerne · CI-heavy Deckel 16 · ce-Build
floor((T-4)/4)x4, --debug-Messung Tx1) · OS-Realm-Lager-Pooling · Repo-Rollen (ce=Framework,
super=Einstieg) · Mess-Permutation DYNAMISCH >32, NUR S-19 (Meilenstein).

---

# 19. DRIFT-KONSOLIDIERUNG 16.08.2026 (KON94-KON97)

> **Anlass:** Owner 16.08.2026 („konsolidiere die offenen Posten in die 4 /goal Referenzdokumente
> … Drift im /goal-Plan regelmaessig ausgleichen"). Quellen: Ledger KON94 (Full-Join FJ-1..FJ-10
> + Arena E1-E11 + 6-GB-Schichtung) · KON95 (O1/O2/O3) · KON96 (Gegenlese-Karte KON1-59 vs.
> KON60-93, 73 Posten Koerbe A-D) · KON97 (Rest-Karten r1-r5 = Ur-Ledger Z.16627-30077 +
> Explore-Karten E1-E4). §13-§18 bleiben stehen; **was hier steht, gilt vor.** Klassen-Regel
> §13.2/§18.1 unveraendert (P/M/W = Wirkung auf den Freeze). Nichts wird gestrichen; Ueberholtes
> aus den Karten ist NICHT uebernommen (Ueberholt-Listen: KON96 + r1-r5/B-Abschnitte).

## 19.1 KORB A → DAS #15-BUMP-BUENDEL (14 Posten, VOR F2 Fr 21.08.)

#15 fuehrt per §18 bereits: Layout 6→7 + Format 4→5 + Budget in EINEM Bruch. Die Gegenlese
(KON96/Korb A) macht daraus das VOLLSTAENDIGE Buendel — jeder Posten einzeln abzunehmen:

    A-01  10. Stempel-Glied fuer ALLE Binaries (Hybrid-Map-Zeile, Tier traegt ""), GliedCount
          9->10 — im SELBEN Bruch wie Format 4->5 + Layout 6->7 (KON45-01 + KON5-04)
    A-02  Preimage-Budget-Bruch: 32 Docks > 4,5 KB sprengen kAnatomyFingerprintPreimageMax=4096
          (anatomy_fingerprint.hpp:68) — Konstante MIT Budget-Beleg heben (KON45-01(5)/KON58-11d)
    A-03  Synthese-Key-Grammatik existiert nicht; Map-VALUE = Tier-SHA statt Voll-Stempel;
          RT-Cache am Dock, Invariante RT ⊆ CT (KON45-01(6) + KON47-02) -> #15/HY-A2
    A-04  VOR dem Bruch entscheiden: Preimage-Glied-FOLGE (fest 9, :601) und AxisKind-Enum-
          Ordnung im SELBEN Bruch? Sonst steht der teuerste Bruch erneut an (KON5-04(3)/KON5-05)
    A-05  work_mode: Debug verlaesst das Enum (Ordinal 0), Build tritt ein, kWorkModeCount=4,
          neue Registry-Zeile; Kette build->measure->compare->release, Besitzer Planer (Z13694)
    A-06  Stufe/Phase-Umbenennung ist preimage-/ABI-wirksam => selbe F2-Frist wie S-6 (KON16-09)
    A-07  E-1-Heuristik-Rekursion: Tiefe + Stufen-IDs als Stempel-Felder (Owner, Z15504) -> #38a2
    A-08  prod2-Umbenennung ("Ja umbenennen"): Registry-Generator spiegelt den Namen (Z15650);
          VORHER prod2-Identitaet messen (lscpu: Alder Lake vs. 14900KS-Etikett, r1 C4)
    A-09  FullJoin (Pruefling-MergeStrategy, golden-byte-wirksam) beim S-6-Bau UMBENENNEN —
          Kollision mit KON91-"FULL JOIN" (KON30-02)
    A-10  S-6-Schnitt KOMPLETT (Umstellung · Transpositions-Sperre · Ordnungs-Wache · #67) +
          VERBOTSZONEN (Lager-Kaskaden, kOrganGruppen*, kSystemAxisOrder, kCompositionAxisNames,
          Hash-Mechanik, Messwert-2-Tupel) = INHALT von #15 (KON21-03/20-02/5-04)
    A-11  5. ABI-Symbol (Stempel) am Loader heute OPTIONAL (nullptr) — SOLL: Pflicht (KON7-01)
    A-12  B3 = Umzug der SCHALTER-HOHEIT zur CEB (abi_adapter.hpp:476-491 faellt), kein
          physischer Umzug; Vererbungsregel KON37-01 -> #24-B3 (vor F2, Owner-Datum)
    A-13  EISERNE REGEL bis zum Fenster: nichts unter axes/ topics/ heuristik/ anfassen —
          Overlay-Glied [7] hasht Quelltext (KON58-05); Arbeitsregel ALLER Straenge
    A-14  KORREKTUR: "jeder Algorithmus bekommt eine neue Versionszeile" hat NULL Ledger-Treffer;
          KON9-05 verlangt nur Stempel-UNTERSTUETZUNG — keine 123 Literal-Bumps (KON58-05)

Zusatz aus r2-r5, DEMSELBEN Fenster zugeordnet (Kurzliste, Details in den Karten): kCebFingerprint
rendert ANGEBOT statt Wahl (r3 A1) · COMDARE_MEASUREMENT_ON ABI-wirksam ohne Preimage-Glied (r3
A3) · O-2 Preimage-Glieder cxx/opt/build_type + bvset fehlen = OWNER-FRAGE Option A/B (r2 A61) ·
VS-A..VS-F STOPP-Gates offen, E-B bricht golden-CRC und fehlt im EINEN golden-Fenster (r4 A-07,
r5 A34) · Versionierungs-Interface + CT-Namensfunktion (Owner-KERN, Vorlaeufer 22.07.; Blocker:
reale Achsen-Typen ohne name(), r3 A6/A7) · run_methodology-Enum-Ordnung = Byte-Ereignis,
Owner-Frage G-5/C-7 (r1 A13, r4 C-7) · all_axes_golden.profile.xml nicht wohlgeformt, Flag-
Ausnahme entfernen (r3 A12) · F5-Owner-Halbsatz: XML-Syntax/Semantik + Planer-Interpreter (r3
A15) · telemetry-silent-Wiring golden-gebunden (r4 A-01) · stale Kommentar
bestandslog_document.hpp:22-26 faellt (r1 A28).

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21): Verdachtsfall seg1-44 -- nur der S-6a-Anker-Teil der
> golden-Nachposten (E-B-CRC / K1-avx512-Filter / telemetry-silent) ist im #15-Bruch; die Linie dieses
> Abschnitts ("E-B faehrt AUSDRUECKLICH im #15-golden-Ereignis") ist die juengere => Kandidat: VOR die Landung
> in den Bruch; die SPANNUNG zur Kontext-13-Uebergabe ("E-B/A-11 = golden-gebundener FOLGEZUG, V-03R-Budget
> frei") ist ausgewiesen, ENTLASTET-bestaetigt in A2.5-R2; Aufloesung durch Audit-Synthese + ggf. Owner-Satz
> VOR der Landung (par.21.5).

PRAEZISIERUNG 17.08.2026 (VL-5-Buchung, KON99/KON100; Belege BUENDEL-BAUPLAN-15.md Abs.8 +
Zehn-Wochen-Explore wf_e129dbb8): Die vorstehende Zusatzliste traegt KARTEN-Staende, die am
HEAD ueberholt sind — (1) VS-A..VS-F sind ALLE SECHS seit 07.08. abend-23 ENTSCHIEDEN
(Ledger :27970-27979; E-B = Variante (i), Owner-SETZUNG "Wir brechen golden-CRC!"); offen ist
nur die AUSFUEHRUNG A/B/C/D; E-B faehrt AUSDRUECKLICH im #15-golden-Ereignis (gruppe7-Pflicht,
C7-Warnung: sonst zweiter golden-Bruch nach F2). (2) r3 A1 (kCebFingerprint) + r3 A3
(COMDARE_MEASUREMENT_ON) sind GEHEILT 06.-07.08. (62a5b6f7 / 2e1f9c1d). (3) O-2 ist AM OBJEKT
GEHEILT (Glied [5] traegt cxx/opt/build_type, Glied [6] = bvset) — die Option-A/B-Frage ist
GEGENSTANDSLOS. (4) all_axes_golden '--' + Flag (r3 A12) ist beidseitig ERLEDIGT seit 08.08.
(ce 90a31961, super 2983e9ba). (5) Versionierungs-Interface: KON7-01/KON7-08 (11.08.) legen
ABI-Aussenflaeche UND CRTP-Basisform-Pflicht fest — V-07-Frage entschieden, Rest = autonomer
Erbinnen-Bau. (6) G-5/run_methodology bleibt echte Owner-Frage (V-12 der Rest-Vorlage
20260817-OWNER-VORAB-15-restfragen.md, dort auch die uebrigen 11 Rest-Fragen).

## 19.2 KORB B → DAS Di-25.08.-BUENDEL (#18 S-13 + Arena + #57 Lager + Naehte; 20 Posten)

    B-01  Naht-Schablone Planer<->CEB: 3 Nachrichtenklassen hinauf; NIE Mess-Rohdaten zum
          Planer (KON50-01/-02) -> S-8/S-10/#20
    B-02  Steuer-Naht spricht GEFILTERTES XML; Flaeche 3: Signal aus / Messwert-Stream ein,
          Format SPARSE BINARY (KON51-01) -> #20
    B-03  Arenen je Tier/Hybrid bei Anforderung; Flush nur an Hol-Punkten; Stummschaltung;
          OOB = GENAU das Fertig-Signal; ram_warn 6GB / ram_oob AUS, XML-einstellbar
          (KON51/52) -> S-13-XSD + S-10 (W1-Aufloesung s. 19.6)
    B-04  Inter-Experiment-Fenster = bidirektionale Sync-Barriere; --auto/manuell/VERNEINEN;
          kill-OOB; halb sauberer Stopp schreibt NICHTS Unvollstaendiges (KON53/54) -> S-8+S-10
    B-05  MeasureStorage: acht Owner-Festlegungen + ZWEI Arenen (Mess append / Stack LIFO),
          getrennte Cachelines, ALLOKATIONS-VERBOT in der Aggregation (Z15143-15283) -> E1-E11
    B-06  Ursache-Kette: variadische Mess-Template-Variablen NICHT durch Gattung+Genus
          durchgereicht => keine Arena-Init, kein flush() je Arena, keine Dock-Signale —
          Metaprogrammier-Luecke (Z14855-14921) -> E1-E11-Design
    B-07  Bestands-Fallen: ThreadArena/InMemoryMeasurementBuffer = Anti-Vorlagen;
          LIFOStackBuffer = Queuing-Achse; csv_to_latex -> measure_to_latex = MIGRATION mit
          Konsumenten (Z15248-15271) -> #18 + #74
    B-08  Lagerbaum: ZWEI NEUE WURZELEBENEN Gattung->Genus->Binary|Messung->REST fuer ALLE
          Gattungen/Genera; kostet Pfad-Grammatik + Tests + Wachen (Z15517/K1) -> #57
    B-09  Bestandslog NICHT scharf: mess_bestandslog_active=false; Restliste main.cpp
          ~:1112-1114/:1349-1351 + COMDARE_BESTANDSLOG_MESS_DOC_KEY in die Planer-Forward-Liste
          (Z16487/LAG-P2) -> #57
    B-10  Hybrid: Tier-Bau/-Laden IMMER durch die CEB delegiert; Standard-compare->release VOR
          dem Hybrid-Dock; Loader stufen-neutral (Z15482/OV-13 + K2) -> #57(3)/HY-A
    B-11  measure-drop-Kanal ZWEIFACH heilen: Ziel-Filter UND per-Binary-xlsx (KON32-01) -> S-13
    B-12  Export-Element Option b + vier ct-gesicherte Rueckschrieb-Methoden; PDF ausserhalb
          (KON27-02 + KON23-03) -> S-13-XSD
    B-13  Drei-Ziele-Struktur je XML separat; Runner LESEN nur ccache minio.comdare.de +
          Buildsystem-NAS ("mein letztes Wort") (KON13-04/15-05) -> S-13 + KON67-Abgleich
    B-14  SECHS STEUERDOCKS Planer<->CEB; zwei Rechtsakte (FREIGABE System / DURCHSETZUNG
          Organ); Release nur GESAMMELT vor/nach der Gesamt-Messung (Z14784-14853) -> S-8/S-10
    B-15  Default-Doktrin (constexpr-Defaults, XML ueberschreibt) · Hybrid ZWEIWEGIG
          XML-steuerbar · <hybrid>-Schalter · Hybrid-Meta-Meta = FAMILIE (KON42+Z13999)
          -> S-8/S-13/HY-A3
    B-16  Zielform-Pflicht AB SOFORT: S-8/S-9 in die Vier-Unterprojekt-Form; #29a
          Planer-Unterprojekt = erster Monolith-Schnitt (KON43 + KON47-01) -> W2-Struktur
    B-17  Emissions-Doktrin fuer S-12: KEINE YAML, zentrales C++23-Bau-Modul, Rakete
          rueckwaerts, Abschluss = LAGER-Fund, CEB-Bauten sequentiell (KON16/17/18/25) -> #3
    B-18  vierte Mess-Ebene = SPALTE der Macro-Stufe (Tier-Stempel je Funktionsaufruf);
          Overhead = Differenz (Z15553/K5) -> Mess-Design + S-19-Input
    B-19  B1 "direkt neu, das alte archivieren"; <measurement_tooling> + Stufen-Dimension;
          Korrelations-Pflicht; Anordnungs-Freigabe je Stufe Subset {W,Ma,Mi} (KON37-02/-03)
          -> #24-B1/B4-Design
    B-20  System B (17 Dateien, dormant) traegt die Ordnungs-Maschinerie; B4 = 9 Kern + 8
          Ripple = "Steuerung -> Compile" (KON34-01/04 + KON40-02) -> #24-B4

## 19.3 KORB C → TRIGGER-/W3-VORPOSTEN (Mi 26.08. 06:00 / Kampagne Sa 29.08.; 15 Posten)

    C-01  VOLLBAU-GATE (KON22) als Vorlage VOR dem Trigger — der Kopf kennt den Trigger,
          nicht das Gate
    C-02  HEAVY ist SIGNAL-GATED: das Signal fuer das 26.08.-Fenster muss GESENDET werden
          (KON58-03) -> Betriebs-Task Infra
    C-03  OV-4-Deckel = f(T-3): einlanig 41,4h@24W -> ~45,6h@16W; KEIN amd-16W-Trace;
          Deckel-Rechnung mit S-19-Zahlen VOR GO-Vorlage ##51 + Pflicht-Nachkalibrierung
          (KON41-01 + KON58-03) -> #7-Ausgang
    C-04  T-15 x KF-10 = 9 Messungen je Zelle: MESS-Phase verdreifacht sich -> --check-size +
          S-19-Rechnung (Z15403) -> #7
    C-05  Warmup-PAAR-Pflicht: run_observable_perm misst KALT (perm_runner.hpp:207,213) —
          anpassen oder ausbuchen + Tests (KON47-04) -> vor Kampagne; Testseite Designplan §12
    C-06  5/5-Retry-Klammer: Build UND Messung je 5x; 3 Wiederholungen einzeln persistiert
          (KON37-06) -> #13 T-15b
    C-07  T-15-Luecken: Granularitaet "ganzen Lauf neu starten" UNDEFINIERT; "bis zu 5
          Wiederholungen" zweideutig; T-15 kein CI-Gate (Z15411-15455) -> #13
    C-08  Die 5 sitzt FALSCH auf der Drift-Achse (ce 4cd1ab91): Umzug + 8-Punkte-Ripple;
          Arena-Formel muss x5 ZUSAETZLICH decken (KON26-04) -> #13 (+ 19.6/W1)
    C-09  DRIFT-GATE OHNE DEBUG-AUSNAHME (RunMethodology = 0 Treffer): sonst bei der
          --debug-Generalprobe ab 29.08. JEDE Zelle rot; Debug-Zahlen NIE ins Lager
          (AdmissionStatus existiert) (Z13762-13898) -> Paket mit T-15/D4 VOR W3
    C-10  ZWEILANIGKEIT: resource_group hart amd/prod1; §61-Revision (ceb-measure-<host>) nie
          umgesetzt; Intel-Gegenstueck fehlt; window_belongs_to unverdrahtet; gegen ce 0c80aa78
          nachmessen (KON29-04, r4 C-1) -> Bau-Posten VOR W3
    C-11  HART/SOFT: Achsen failen IMMER hart; NUR fehlende Messeinrichtung (PMC) soft =
          Warnung in die xlsx, Binary WIRD gebaut (KON28-02) -> T-15b/#13
    C-12  Fehlerklassen PFLICHT fuer alle Achsen->Unterachsen->Algorithmen; Stand 0/18 bzw.
          0/121 (Owner 17.07., Z14455) -> T-13/T-14 vor W3
    C-13  Skip-Oekonomie: selektiver Rebuild am 27.07. geloescht (ce 813c3232);
          System-Aenderung erzwingt Vollflotten-Neubau; W12-B + bvset-Richtungs-ctest (A⊂B)
          (KON6-03 + KON2-09/2-13) -> vor der Kampagne wiedergewinnen
    C-14  Bestandslog-SKIP-Risiko: je binary_id EIN Eintrag bei 320 bit-identischen IDs —
          SKIP kann falsch begruendet sein (KON3-06) -> Wache vor Kampagne
    C-15  MinIO Ebene B: gueltiger Beweis = CI-SMOKE mit Beweiszeile + Gegenkoeder HART-ROT im
          Ein-Blech-Fenster; Falle COMDARE_RUN_MEASURE erzeugt measure:golden-320 (timeout 10d)
          (KON58-04/#10 + KON56-01) -> Betriebs-Task vor Kampagne

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21): C-12/T-13/T-14 (Fehlerklassen) bleiben PFLICHT VOR W3 -- die
> Rutsch-/W7-Vermerke anderswo sind Historie (par.21.3); C-13/C-14 tragen jetzt den Board-Task #97 (vor
> Kampagne Sa 29.08.; der Traeger war vorher NUR T-NEU-11 im Rest-Register); T-07/T-08 VOR dem Trigger
> Mi 26.08. falls mengen-wirksam, sonst W2-Slots (par.21.4 + Wiederaufnahme-Register).

## 19.4 KORB D → W2-TRIAGE (lebend ohne Frist-Anker; 24 Posten, neben #71)

    D-01  S-3-Abnahme: gebaut (ce 4a89aed5), KON55-Kombibau NIE gefahren; Aktivierungs-Beweis
          "gebaut UND inert" je Seite mit ZWEI Zahlen (KON58-08 + NE-10) -> W1-Rest; Test:
          Designplan §12/T-12e
    D-02  S-7-Bauplan + Fesseln P11->P4 · P6->P4 · P1->P2 · P3->P5 + Lande-Ordnung 1-9; sechs
          von elf Wellen-Posten ohne Kopf-Nachfolger (KON58-05/-10) -> W1/W2-Abgleich
    D-03  Riegel-Betrieb: 122 Traeger = Bump ODER Regen-Commit; --check Exit 3; LANDE-AUFLAGE
          nach JEDEM Merge --check+--write+git diff (KON58-01/-07/-13) -> Lande-Doktrin
    D-04  C-4-Wache modular splitten (deckt 6, >=152 ungedeckt); Home-SEMANTIK: EIN Waechter je
          Home, ZWEIstufige Versionierung, "golden zuerst" (KON17-03/KON2-19 + KON27-01) -> F5
    D-05  Compiler = kuenftige 5. SYSTEM-ACHSE gcc|clang, Unterachsen opt/flags/commands
          (KON55-01 + KON56-03; Ofast-Default s. 19.6/Widersprueche) -> S-9/S-11 + W7
    D-06  vier CacheEngine-Modi als PHASEN (State-Pattern, 0 Code-Treffer) zu BAUEN; compare
          vergleicht heute nichts (KON29-01/-03, r5 A28) -> W2/W3-Design
    D-07  Hybrid = Transmitter/Multiplexer, Glied der MESS-Kette; Autonomie zweistufig, S-20
          spaeter (KON19-02/13-01 + KON21-01/36) -> HY-Design-Register
    D-08  15-Stationen-Kette: Plan-/Memory-Nachzug (8-Stationen-Memory korrigieren) (Z14663)
          ^^ EINPLANUNGS-MARKER 23.08.2026 (par.24): LABEL-KOLLISION — dieses Wellenplan-D-08
          (Doku-Nachzug, lebt in RN-27) ist NICHT das KON120-D-08 (Emitter-Entscheid
          "Steuerung->Compile", DESIGN-h23 Teil B, RN-04/RN-58); Sprachregel: "Wellenplan-D-08"
          vs "KON120-D-08" (analog L5-Begriffsdreiteilung).
    D-09  Pruefling = drittes Konzept, XML-beschraenkbar 1..3, ERWEITERT den Permutationssatz
          (KON30-02/KON31) -> S-19-Input + prt-art-Rolle
    D-10  Auswahl-Subsystem (17 Dateien): Fortfuehrungs-Entscheid FEHLT; K4/K5 ohne Eigentuemer
          (KON29-06/R-1 + KON20-04) -> Explore, dann ggf. Owner-Vorlage
    D-11  #19-Vorbedingungen: zwei Diff-Hygiene-Fassungen (super schwaecher, druckt GRUEN) +
          13 ungelandete ce-Branches + BRANCH-PFLICHT (KON5-06 + KON49-03/-04) -> vor #19
    D-12  PUBLIC-GANG-Buendel: Betreuer-PDFs, NOTICE-vs-LICENSE, 5. Schalter kopiert GPL-3
          wh.c UNGEGATET, "BEP" fuer die Person VERBOTEN (KON22/K + KON2-24/25) -> Release-CL
    D-13  ADR-Grundgesetz-Register (25 Entscheidungen, 04.05.) in den Ledger; §63-T T-08/T-19
          (KON-40 + KON-42) -> W4-Thesis-Fundament
    D-14  aufgehobene Streichliste = NEUN lebende Bau-Posten (CEB-27/43/12/34/18/20,
          33-Paper-Generator, Toolchain-Permutation, CEB-19) (Z16345) -> W5-W7-Zuordnung
    D-15  blockierende 09.08.-Entscheide ohne Kopf-Spur: D-5 Bau-vs-Mess-Menge (per r3 B5 als
          BAU-Posten aufgeloest: XML muss trennen, sonst Regression) · CEB-38 · CEB-Identitaet
          A/B · variant-Fehlerklassen-Ausnahme (per E2 Fund 10: Scope-Historie belegt,
          Hybrid-Dock-Ausnahme lebt — r5 A38) (Z16388) -> Explore-Rest, dann Owner
    D-16  Konformitaets-Register: 256 Aussagen, 17% ERFUELLT, +1564h — keine Nachmessung seit
          09.08.; KON82 misst ANDEREN Gegenstand (Z15887/Z16291) -> W4-Realitaetsanker
    D-17  Verifikationsvertrag V-1..V-8 lebt (Kopf-"V1-V10" = Namenskollision); OV-Nummern kein
          Autoritaetsbeleg (Z14501 + Z14434) -> Register-/Vokabelpflege (+ r4 A-08, r5 A59)
    D-18  Wachen-Sammelposten W2: Inventar-Nenner · drei allow_failure gegen Doktrin · libs/
          ohne -Wall · || echo an 3 appendix-Stellen · AF_CORPUS_ROOT tot · ZWEI PARSES ·
          D2-UB + kHashes · Registrierungs-Wache · measure_selection 0 · delete_p99_ns fehlt ·
          docs/termine · n/a-Gate · 289-Writeback (KON59-02/NE-16/-20 + Karte-5) -> #71-Nachbar
    D-19  Infra-Reste: COMDARE_NFS_DROP_TOKEN fehlt (Ebene C inert) · CE_SUBMODULE_TOKEN fehlt ·
          Registration-Token-Reset = Owner-Entscheid · "776" = Trefferzahl (KON58-04) -> Handout
    D-20  Prozess-Register: v3.6 Opus ERHEBT / Fable BEWERTET · v3.7 MAX DREI Vollbauten ·
          v3.8 Wellen-Form · Codex klein + zweiter Lens · ARBEITSWEISE an ZWEI Orten ·
          Ledger-Nachtrag an die LANDUNG · CMakeLists-Hotspot ans DATEIENDE · thematische
          Testnamen · vier /goal-Dokumente = Referenz-Hierarchie (KON58-09/-12 + KON39/38)
    D-21  Owner-ABGABE-PFLICHT: Syntax UND Semantik je Achsen-Kategorie ueber c hinaus;
          G-2-Semantik in Nummerierungs-Reihenfolge; MIN = zwei Filter (KON9-09 + KON13-03)
          -> W4-Pflicht + nach F5
    D-22  Karte-4-Spitzengruppe je eigener W2-Pruefposten: KON-46 Retry 5/2/1 · KON-11/12
          Drift-Wortlaut+n=1 · KON-36 fuenf rote Dauer-Tests · KON2-19 Lock-Gate 1/18 ·
          KON2-20 Stempel-Benennung · MT-L3 Orakel 0/29 · 34x "BLOCKIEREND" nie gebucht
    D-23  offen ohne Anker: -Wstringop-overflow (Pragma-Fix VERWORFEN) · 28-vs-13
          InputIfFileExists (vor F5-Anhang-Gate) · Thesis-Doppel-Submodul = per r5 A54 SOLL
          (Vertrag CI/lokal; .gitmodules-"TOT"-Kommentar richtigstellen, CI-Luecke r4 D-20
          bleibt) · KON12-03/S-17-Einsortier-Pfad am Objekt neu messen (KON58-13/-11) -> Triage
    D-24  Bleib-Notizen gegen Fehl-Abriss: PlanTextBuilder + plan dump + visibility:
          tier-binaries produktionskritisch · System-Achse sitzt IN der CEB · drei
          Versionierungs-IST-Luecken (Planer ohne SHA · CEB-System leer · Genus 5 Literale)
          (KON26-03/27-05 + KON8-04 + KON2-06/17) -> Design-Register + W2-Bau

## 19.5 FJ-1..FJ-10 + E1-E11 — BENANNTE BAU-POSTEN DES S-13-BUENDELS (#18, Di 25.08.)

Das S-13-Buendel (#18) fuehrt ab sofort ZWEI benannte Posten-Reihen (Volltext: Ledger KON92/94):

- **FJ-1..FJ-10 (Full-Join, KON91/KON94):** ab ma-Ebene ALLE Parameter inkl. PMC = FULL JOIN der
  mi-Achsen-Erfolgs-Parameter; Wurzel per XML `artifacts` ODER `binaries+measurement` (default
  getrennt) -> Gattung+Genus-Baum -> Lagerbaum je Genus-Tier-Binary (KON91-P1). Spaltenmenge
  E(A) = kV3AxisSchema + seg_* (KON95-O2) MIT Bezugsgroesse: `seg_*_ns` gegen
  `seg_run_total_ns`, NIE gegen `total_ns` (r1 A-7). Leerwerte nach KON95-O1 (markierter
  Leerwert; gebaute honest-empty-Praezedenz r4 B-06). Namens-Hygiene: `FullJoin`
  (MergeStrategy) ist ein ANDERES Objekt und wird per 19.1/A-09 umbenannt.
- **E1-E11 (Arena-Kette, KON92/KON94):** E1-E10 = S-13-Kernstueck (E6 Drain-Schleife =
  measurement_sink-Heilung); **E11 = Arena-Kapazitaet** (6 GB FEST/STATISCH, Planer-Reservierung
  zu Experiment-Beginn aenderbar, KON93-C6; 10-Wochen-Explore fuehrt x5 und 2-vs-18 als
  Pruefpunkte mit, s. 19.6/W1). ZUSATZ-AUFLAGEN aus r5 (checkpoint_measure C-1..C-17, 08.08.,
  KON94 kennt sie nicht): (i) Hot-Path = EIN statischer Deskriptor-Verweis, nie die
  ausgeschriebene Achsen-Kette; kein Alloc/IO im Hot-Path (C-4) · (ii) Ueberlauf = BEFUND:
  weiterlaufen, zaehlen, beim Auslesen melden — nie blockieren, nie still verwerfen (C-6) ·
  (iii) virtuelle Thread-Slots, Obergrenze = Thread-Unterachse (CT-bekannt, statischer Puffer);
  mehr Threads als Slots = LAUTER Fehlerfall (C-14/15/17) · (iv) thread-lokale Puffer sind eine
  RICHTIGKEITS-Frage (C-10). Testseite: Designplan §12/T-12c+T-12d.

## 19.6 DIE 18 WIDERSPRUECHE — 12 MARKER-AUFTRAEGE + 5 EXPLORE-AUFLOESUNGEN + 1 AUSTRAGUNG

Volltext + Auflösungs-Empfehlungen: KON96/Gegenlese-Karte Abschnitt 2. Hier die Arbeitsliste
(Marker = docs-only-Zug, EIN Commit; Explore = vor dem jeweiligen Bau):

MARKER (jüngeres Owner-Wort gewinnt, Marker AM ORT, Zeile bleibt):
    W1  Arena/6GB: KON93 gilt fuer die GROESSE; Warn-/OOB-KOMMANDO-Semantik bleibt eigenes
        Objekt; x5- und 2-vs-18-Pruefpunkte in den laufenden Explore
    W2  Mess-Nenner: KON71 gewinnt; 32/6->12/4! sind S-19-Eingangshypothesen; "24 oder 48" =
        S-19-Ausgang
    W3  Mess-Ebenen: drei Ebenen, vierte = SPALTE der Macro-Stufe, PMC = Meta-Meta; ACHTUNG
        r5 C4: der "gegenstandslos"-Marker darf NICHT an :28858 (fuenf ORTE, andere Zaehlung)
    W4  Lastsequenz = EIGENE Mess-Achse (KON64/65); UEBERHOLT-Marker an KON37-05
    W5  3/2/2-GESETZ lebt; die MENGE "final drei" ist ueberholt (Compiler-Achse, Meta-Metas)
    W6  HW-Erkennung: KON64/65-F2 gewinnt; bindend-Klausel an KON-03 nachziehen
    W7  Parallel-Deckel: BEIDE gelten (CI-Concurrency vs. lokale Vollbauten); Vorbehalts-Marker
        an KON73 ("unbeschadet v3.7")
    W10 --debug-Ende: T-3 gewinnt; Marker AM ORT (KON28-01 + Kapitel E)
    W11 Change Date: 10.08.2031 FINAL; Segment-Marker (lizenzwirksam)
    W12 Dock-32: Deckel-DEFAULT willkuerlich; XML-Pflichtangabe bei Hybrid-Anforderung bleibt;
        K5-Text per V7 nachziehen
    W15 Repo-Rollen: F6 gewinnt; im #74-Design ausweisen, dass Auswertung aus super wandert —
        kein stiller Umzug (+ E1-Hauptfund: Matrix/Baseline-Taxonomie VOR #74 zitieren)
    W16 checkpoint_measure-Name: kein Sachwiderspruch; KORREKTUR r5 C1: Owner-Wort bereits
        08.08. (C-1..C-17), KON60(iii) = BESTAETIGUNG; "Erfindung"-Befund austragen

EXPLORE (erst am Objekt, Owner nur bei Rest-Diskrepanz):
    W8  KEINE-YAML vs. S-12: Design-Explore der Naht; ACHTUNG r2 C-3: Par.42/40.b meinen die
        TRAEGERKETTE — haelt die Werkstatt-CI-Lesart nicht, Owner-Vorlage mit beiden Wortlauten
    W9  Lager-Inhalt: per r5 A18 AUFGELOEST (Release = Rekonstruktion, Binaries nicht
        aufbewahren) — Explore nur noch als Beleg-Zug am lager_baum_writer, dann Marker
    W13 CEB-Erreichbarkeit 4-vs-6: nach B2-Gate-Trennung am Objekt messen; r5 A14/C6: heute
        max 2 herstellbar, G3-aus-STATISTICS-Gate ist die Vorbedingung
    W14 T17 vs. ORG-19: Explore ob persistence_target daneben besteht; koppelt an K17-Pinning
        und die gedruckte 2^17 (r4 C-6/D-19)
    W17 Backup-Ref: Identitaet pre-secret-scrub-Ref <-> V9 verifizieren; r3 W-r3-6 liefert
        SHA 5ba3d03f + "github war schon 06.08. leer"

AUSTRAGUNG:
    W18 merge-Zeile: Owner-Verbot steht; LEDGER:8941 (§59-MERGE-STEMPEL) AUSTRAGEN, bevor
        jemand den verbotenen Bestand baut — Trigger-Risiko 26.08.

ECHTE OWNER-FRAGEN (kein Explore loest sie; gebuendelt vorlegen): (a) KON3-03 XML-Wache
unbeobachtbare Zweighälften · (b) E-5 kanonischer Kurven-Stack + K4 (GETRENNT) · (c)
Registration-Token-Reset — PLUS aus r1-r5: O-2 Preimage-Glieder (A/B) · VS-A..VS-F ·
AVX-512-in-golden + no_extension-Cross-SKIP (r1 A-12) · PMC-Gueltigkeit/Anhangs-Umfang
(r3 W-r3-2/W-r3-4) · Selektor-Richtungen MAX/MIN (r4 C-5) · ETA-Merge last_update_utc (r5 A48)
· F-01 Talos zuruecknehmen (r3 D1) · Token-Rotation 286/288/289 (r3 C11, SOFORT).

## 19.7 UR-LEDGER-RUECKKEHRER (aus r1-r5 + E1-E4; NUR im Massstab wirklich Ungedecktes)

| # | Posten (Kurzform, Beleg in der Karte) | Quelle | Kl. | Welle |
|---|---|---|---|---|
| R-01 | Planer-Split: ZWINGEND eigene Binary VOR Abgabe (R-G1; Schnitt-Spez liegt) | r2 A40 | P | W1/W2-KOPF |
| R-02 | Lager-Basis-Tests: Dummy-Text-Strategie + leerer Binary-Stub (Owner-KERN) | r3 B1 | M | W2/#57 |
| R-03 | Inventar-Batch-Cache: Host-Belegung fehlt (Ebene 1 inert) + Plan-Ablage 156x | r3 B2/B3/B9 | M | W2/#57 |
| R-04 | LB-4/LB-5/LB-6>1 NICHT gebaut ("Voll-Bau-Trigger IST der Baum-Vollausbau") | r3 B4 | P | vor 26.08. |
| R-05 | XML-Trennung BAU-/MESS-Menge (Owner: "sonst regression"; Schnitt liegt) | r3 B5 | M | W2/S-13-XSD |
| R-06 | WritebackMethod::Xlsx + XSD-Enum-Wache; A9-Bauliste am Objekt nachmessen | r5 A43/A45 | M | W2/#18 |
| R-07 | Bestandslog-SOLL (verteiltes System, 4096/ETA/Takeover/Locks) als Design | r2 A8, E2 F1 | M | W2/#57 |
| R-08 | Batch-Job-Prinzip O(Maschinen): Emissions-Umbau ohne Vollzugsbeleg | r2 A9/C-1 | M | W2->W3 |
| R-09 | G3 aus dem STATISTICS-Gate loesen (6 CEBs; heute max 2; --check-size-Basis) | r5 A14/A24 | M | W2 |
| R-10 | Registry=ANGEBOT/.pom-Resolver + 3 Registries + Generator je Registry | r2 A1-A3 | M | W2-Design |
| R-11 | Resolver fuer target_isa-RT-Unterachsen + core_class-Provenienz (Ω-1..Ω-3) | r4 C-02/C-03 | M | vor W3/#53 |
| R-12 | E-07-Gate: Kriterien 0 Treffer im Code; Position B10 trigger-blockierend | r3 C4 | P | vor 26.08. |
| R-13 | Zwei unwahre Messgroessen (bytes_in_use_peak; CLU-64) vor dem ersten Batch | r3 C5 | P | vor 26.08. |
| R-14 | Chaos-/Drift-Gate ohne Produktions-Aufrufer; CI-Job existiert nicht | r3 C8 | M | vor W3/#13 |
| R-15 | L3-Asymmetrie prod1 (96/32 MB) + Pinning-Pflicht; ungepinnt nicht reprod. | r4 C-01/C-08 | M | W3-Vorb. |
| R-16 | 21-Images-Entscheid (7 OS x 3) — Marker an alle 7/8/18-Stellen | r4 C-05 | W | W2-Marker |
| R-17 | Tag-Mismatch baremetal/bare-metal sperrt Runner id6-9 aus | r1 A46 | M | vor W3 |
| R-18 | adhoc_emitter ohne CI-Job; R5.G-Tests fehlen der Inventur | r1 A34 | M | W2 |
| R-19 | GN-9 Feasibility-Gate ohne Fahrplan-Slot; 4096-static_assert-Schranke | r4 C-04, B-08 | M | #7-Ausgang |
| R-20 | HDR verdrahten (Thesis-Praesens; 1 Include) + p95-Export + 4 Zusagen | r1 A21/A22 | M | vor W4 |
| R-21 | Break-Even: ZWEI Implementierungen + B-Spline/String/3x je node-Tiefe | E3 F1, r5 A15/16 | M | W4-Vorb. |
| R-22 | Record-and-Replay als Mess-Vertrag der 3 Ebenen (Traeger der Elimination) | r5 A17 | M | W2-Design |
| R-23 | Klebe-Zeit der Gattungs-Interfaces = separater Messpunkt (Auswerte-Regel) | r5 A19 | M | W4/#18 |
| R-24 | Sheet-/Profil-Blattfamilien: Blattzahl-Formel + Hyperlinks + Checkpoint-Sp. | r5 A21/A22/A2 | M | W2/#18 |
| R-25 | UltiHash/Produktions-Release-Konzept (H5 + Owner 25.06.; 3x unverfolgt) | E4 F1 | W | Owner+W4 |
| R-26 | BAUSTEINE_BEWERTUNG.md + Habich-Sign-Off je SOTA-Quelle | E4 F2 | W | Owner+W4 |
| R-27 | Nachtrag-1-Register (KON-01..-66) komplett gegen KON60-96 gegenlesen; 6 | E4 §2 | W | W2-Triage |
|      | bestaetigte Luecken: KON-26/-27/-31/-33/-39/-56 (u.a. "sauberste Strategie |  |  |  |
|      | gilt fuer ALLEN Code", nicht nur Infra) |  |  |  |
| R-28 | Bauweg-Doktrin: configure.sh/make/make install/make check im Wurzelordner | r5 A53 | M | W2/#74 |
| R-29 | tier150_measurements.csv ARCHIVIEREN (danach rm-build-Memory nachziehen) | r5 A55 | W | W2 |
| R-30 | Schicht-Verstoss anatomy->builder (Owner-GO "Fenster ist jetzt") | r5 A56 | M | W1/W2 |
| R-31 | LaTeX-Anlage + Textbausteine IN die Abgabe (hebt Betreuer-Auflage, abgest.) | r5 A78 | M | W4 |
| R-32 | Lizenz-Feinheiten: Sperrvermerk+Uni-Ausnahme, privates Copyright, KI-Verbot; | E2 F6, r5 | W | Release-CL |
|      | liburing fehlt in Lizenzdateien; 3 Allokator-Lizenz-Abweichungen | A75, r4 D-01 |  |  |
| R-33 | samba-Vault-Wert kompromittiert -> Rotationsliste (Kopf kennt nur V8) | r5 A74 | W | Infra |
| R-34 | Cross-Plattform-Infra (Win/macOS/7-Linux-Container) + Debug-only-Plattformen: | E2 F2, r4 | W | Explore |
|      | existiert sie noch / bewusst descoped? (sonst still verlorene Anforderung) | C-06 |  |  |
| R-35 | S-7 Locking/Observer-Strang (Owner-PFLICHT deep research; Plan liegt) | r1 A16 | M | W2-Strang |
| R-36 | H1-H7-Fork-Entscheide (H4: std::map-Interfaces variadisch => XSD) + FF0 | r1 A17/A45 | M | W2/#18+W4 |
| R-37 | §75-Kandidatenliste 133/104 offen + §55-RECONCILE 26 offen (Anker migriert) | r5 A57/A58 | W | W7 + Triage |
| R-38 | ETA-Merge verwirft still; last_update_utc-Ein-Feld-Schnitt (Owner offen) | r5 A48/A50 | M | W2/#57 |

**Abgrenzung (nicht doppelt buchen):** Paper-Experiment-XML je Paper steht bereits in §18.8
(Zeile "NEU … W2 mit #18") — Praezisierung dort: Owner-GO 08.08. ("Ja unter sorgfaeltiger Design
Planung bitte bauen") + Ist-Befund 0 Experiment-XML, profile_ref nie dereferenziert (r5 A26,
E3 F2). PMC-Schwester-Design ebenfalls bereits §18.8.

---

# 20. NACHHOLARBEIT + LIEGENGEBLIEBENES DER KONTEXTE 10-11 (17.08.2026 nachts, KON107-KON113)

> Konsolidiert ALLE offenen Zugaenge dieses und des letzten Kontexts fuer GOAL v8.
> Volltexte: Ledger KON107-KON113 + docs/sessions/backups/20260817-folge-bu-kontext11/
> (Verlust-Audit-P20-Text, Gesamtkonsolidierungs-Teile 2+3, Audit hy-a/vl3, Owner-Verbatims).
> Bei Widerspruch: Owner-Wort schlaegt alles, Neueres schlaegt Aelteres.

## 20.1 GELANDET+GEPUSHT (Stand dieses Nachtrags)
> MARKER 17.08. spaetnachts (Sweep B-3): KOMPLETT = die LANDUNG des Gebauten; die
> W1-ABNAHMEFORMEL (:952, HY-A-Zeile) steht am Objekt 0/4 -> Luecke traegt P.20.2,
> Abnahme vor F2. CI-Nachtrag: 15971 auf 6cdcf1c9 war ROT (Format/ASCII/Lock);
> Heilung a43ea18f+965b121a gepusht -> Gitlink-Ziel in P.20.4 = der GRUENE Stand,
> nie 6cdcf1c9.
Welle 1 KOMPLETT: ce development 04ac26fa -> 6cdcf1c9 (31 Commits, origin+github):
hy-a a4366cb8 | vl12 cd011e60 | vl3 7bf66ddd | k2 7a5ed464 (4x --no-ff) + f45e995b
(TSan-Grenze+Terminierung) + 316c488f (add_dependencies-Kante, T-1 rot->gruen) +
c3478a9c (Floor-Anker 500/496/494) + 6cdcf1c9 (VL-3-ROT-2: unbelegte Byte-Gleichheits-
Zusicherung abgeschwaecht). Kombibau 4/4 Zellen je "100% tests passed out of 499";
Floor PRUEFLING-Form 500/496/494 live + Restore-Beweis + Wache rc=0 (MASSGEBLICHE Form;
499 = pruefling-los). ce-CI-Ergebnis ausstehend -> danach super-Zug.

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21): "Welle 1 KOMPLETT" galt NUR der Landung der 4 Straenge
> (hy-a/vl12/vl3/k2) -- #17/g2 ist UNGELANDET: 1528f6fd ist NICHT Ancestor von ce/development 20c111c4
> (merge-base-Beweis 18.08. ~15:15); #17 schliesst die Stempel-Strecke und gibt #7/S-19 frei (KON17-01)
> => Lande-/Fertigstellungs-Pflicht VOR F2 (par.21.2).

## 20.2 !! VOR F2 (Fr 21.08.) — NEU ERKANNT/UNGEDECKT
- HY-A2 + HY-A3-ACHSE NIE GEBAUT (Audit hy-a-bau): proxy/tier_module (4 ABI-Symbole) +
  test_hy_f8_reroute + Registry-"22->23" fehlen; W1-ABNAHMEFORMEL :952 NICHT erfuellt;
  E-1 IST ENTSCHIEDEN (HeuristikAdapter=3/FunctionInterfaceReroute=5, KON39) -> Bau
  haengt am #15-decl-SLOT, nicht an Owner; E-6 ("welche Registry=22") = 12W-Explore,
  dann ggf. Owner. TRAEGER: neuer Posten im #15-Bump-Buendel-Zug (KORREKTUR Sweep B-4: #15-decl-Slot,
  NICHT Task #89 -- #89 ist P-H Paper->Prueflinge).
- #15-BUMP-BUENDEL selbst (Layout 6->7 + Format 4->5 + 10. Glied + #38a2/#38d +
  PMC-Spalten + bestandslog v5 + HY-A2-Map-Zeile) — Design-Karte liegt (W1-Workflow),
  Bau = letzter Preimage-Schritt vor F2.
- VL-3-PFLICHT-FIXES (Audit vl3-bau, A2.5): (a) clang-WARNUNGS-Review (gcc->clang
  zweimal; 4-Zellen-GRUEN liegt, WARNUNGS-Durchgang fehlt), (b) --debug x plan
  dump|ci|cmake-Tests (Exit-6-Zweige), (c) Windows-_pclose statischer Blick.
  ROT-2 (main.cpp-Zusicherung) BEHOBEN 6cdcf1c9.
- G-2-REST: g2-Strang landereif @ 1528f6fd (Welle 2); Rest-Kategorien lt. Bericht.

## 20.3 WELLE 2 (nach ce-CI-gruen seriell landen, A2.1a)
g2 1528f6fd -> xorf b8d6edab (golden-Ereignis: Filter-Zelle + algo_version
1.0.0.c->1.1.0.c) -> f3v dac3d91a -> a11 ec048560 (+ super-Patch BU
20260817-w1-strang-artefakte/a11_super_patch.diff). Harmonisierungs-Flaechen je
Bericht (tests/unit/CMakeLists.txt-Dateiende bei g2; f3v disjunkt). Danach Worktree-
Abbau NUR gelandeter Baeume (Owner-Auflage: erst gruen+gemergt).

> WIEDERAUFNAHME-MARKER 18.08.2026 (par.21): g2 war das ERSTE Glied dieser Lande-Liste; die KON116-Landung
> nannte nur xorf+f3v+a11 -- g2 bleibt UNGELANDET (Beweis am P.20.1-Marker) und ist VOR F2 zu
> landen/fertigzustellen (par.21.2).

## 20.4 SUPER-ZUG (nach ce-CI-gruen)
k2-6-Schritt-Rezept (tests/CMakeLists.txt:348 -DFIXTURE + Gitlink ATOMAR;
fixture_schema_subset_check.cmake:98-103 FATAL; Mutationsprobe ROT statt SKIPPED;
Kopf-Nachzuege; SCHEMA.md:48; Plan/Ledger-Vollzug) + Gitlink-Bump 6cdcf1c9 + PZW.

## 20.5 NEUE BAU-/DESIGN-POSTEN aus KON110-112 (Traeger Task #88 + Teil-2/3-Skizze)
P-A Kanal-/Arena-Designplan (checkpoint_measure-Kanal-Baum, PROFILER, Klammer-Default,
Spannung C-1-vs-Default NICHT glattrechnen) | P-B Parameter-Filter-Registry + neuer
Deep-Research | P-C kleine Hybride (Docks=Optimal-Bereiche<=32) | P-D Hybrid-ML-
Profile (XML-init, Lookahead ma x w) | P-E Lager-Typ 3 (Funktions-Synthese) + Typ 4
(XML-Loesungs-Cache) = Bestandslog-FACTORY-Erweiterung -> #57/#18 | P-F Flaeche-3-
Zweiform (Steuer- vs Mess-Naht; #20 = intra-Naht) | P-G mess/ EIGENE S-Position
(Register-Nachtrag + Design) | P-H 33 Paper->Prueflinge + Begriffs-Alias-Registry
(CT, kein Uebersetzer) + Markierungs-/Ranking-Ausgabe -> #44/W2 | P-I Selector-Merge
in Komponente 3 (std-only-Spiegelung FAELLT; super liest Lager) | P-J CEB-
Auswertungs-Beschleunigung (std::variant-Ausnahme-Zone, HW-Detection, SIMD-
Reservierung, Planer-Notification) | P-K SIMD-/Erweiterungs-Deep-Research.

## 20.6 VERLUST-AUDIT-POSTEN (P20-Text, BU verlust-audit/)
T-NEU-1 s13-Kurz-Verify-Verdikt nachbuchen (Gate KON100-02; s13-F3 bis dahin nicht
landereif) | T-NEU-2 KON49-Schnitte vs #41/#30 Abgleich | T-NEU-3 wf_e13d73bf
identifizieren | T-NEU-4 Journal-BU Kontext 10ff | T-NEU-13 wip/luecken-stufe2 vs
#40 | T-UPD-3 R3-D37B-Zeile stale "offen" -> GELANDET (9b3a1bcd+75505b9d) |
p2/p3-Worktree-Reste beim #37-Vollzug einspielen/verwerfen.

> EINPLANUNGS-MARKER 23.08.2026 (par.24): *(zur T-NEU-13/#40-Zeile)* Board-#40 traegt inzwischen 38 NE-Posten/
> 20 Auftraege seit W0b (P6); Triage + T-UPD-2-Kollisions-Entscheid = RN-29 (Di 25.), Vollzug T-13/T-14 =
> RN-44 (vor W3). NUMMERNKREIS-WARNUNG: Board-#40 != v1-Paket ##40 (par.7/21.3) — getrennt fuehren (24.3.3).

## 20.7 OFFEN BEIM OWNER (Stand Kontextende)
(1) Kenntnisnahme b-Strich Talos: Core-PMC-Zuschnitt + v1.13.x-Upgrade (NICHT v1.14,
sandboxd-GA 27.08.!) ins A-1-Fenster? (2) Infra-Fenster-TERMIN (WE 22./23. ueberbucht:
S-19 + T-15b + I-PMC + A-1 + evtl. Talos; Slot-Vorschlag liegt). (3) E-5-Chat-Reste:
Owner wollte Zusammenhaenge der 3 Komponenten weiter klaeren ("Ich beantworte gleich
weiter" — RF-Runde ist beantwortet, Unifikations-Design-Vorlage folgt aus Teil 2).
HANDLUNGEN: V8-GitHub-PAT | node6/node5/id56/id18.

## 20.8 NACHTRAG (17.08. spaetnachts): NEUGRUENDUNG VOLLZOGEN + TASK-ANLAGE + REST-REGISTER

- NEUGRUENDUNG (Owner-Auftrag): alle 4 /goal-Referenzdokumente VOLL eingelesen (GOAL 816 Z. |
  Wellenplan lebende Abschnitte 16.3-20 + Struktur | Designplan 0-12 inkl. T-11a-c/T-12a-e |
  ARBEITSWEISE v4.4 1265 Z.) + die 7 tragenden Owner-Verbatims der letzten beiden Kontexte
  aus dem Session-Log wieder eingekippt (BU: tmp/owner_verbatims_k11.txt -> Uebergabe-Doku)
  + die letzten 5 Workflow-Rueckkehrer VOLLSTAENDIG gelesen (wf_b5b4ac36 Lande-Steward |
  wf_fab57002 Gesamtkonsolidierung=KON112-Quelle | wf_e06c7f73 Verlust-Audit=P20-Quelle |
  wf_7f847de1 Tieflese F1-F6 | wf_17600b5a KON106-Entwurf mit NP-01..NP-50 + M-01..M-36).
- TASK-ANLAGE VOLLZOGEN (KON112 Teil 3 -> Board): #89 P-H Paper->Prueflinge (Ledger-#44-Bau)
  | #90 P-A Kanalwerk-Designplan | #91 Unifikations-Designplan M0-M14 (Par.75-Sperre faellt
  erst MIT diesem Design) | #92 P-G mess/-S-Position (>=S-22 verifizieren). UPDATES: #88
  (Zuschnitt geschaerft: behaelt P-B+P-K; Typ-3/4->#57(7)-(9); P-C/P-D->#91/M9) | #20
  (Zweiform bindend; Rest=Deckungs-Test) | #86 (+ORG-19-Genus-Kanal-Auflage) | #15 (+HY-A2
  am decl-Slot + NP-19/NP-23 + B-2-Vermerk) | #57 (+(7)(8)(9)) | #18 (+M12-Sammelzug +
  T-NEU-1-Gate) | #71 (+Thread-Frage T vs T-4 + T-NEU-8-Split) | #81 (Landung+Push verbucht).
- REST-REGISTER (Traeger benannt, KEIN Posten verloren): T-NEU-5 S-14-VOLLAUSROLLUNG (W2,
  Strecke P.41, Vorbedingung S-18-Homes erfuellt) | T-NEU-6 S-8/S-9/S-10/S-11-TRAEGERBAU als
  eigener W2-KOPF-Posten (deckt B-01/B-04/B-14/B-16 + R-01) | T-NEU-9 C-01 VOLLBAU-GATE-
  Vorlage VOR Trigger Mi 26.08. 06:00 | T-NEU-10 C-02 HEAVY-Signal-Sende-Akt (26.08.-Fenster,
  #60-Umfeld) | T-NEU-11 C-13 Skip-Oekonomie + C-14 Bestandslog-SKIP-Wache (vor Kampagne
  Sa 29.08.) | T-NEU-12 ERLEDIGT (Cluster ee2f933: 20 helm-Skripte + ci-templates-Gitlink)
  | T-UPD-1 #38c-Rest neu fassen (Objekt=super/ci) | T-UPD-2 #40-Wellen-Kollision T-13/T-14
  aufloesen (W7 vs vor-W3/C-12) | T-UPD-5 MEMORY-Korrektur 8->15 Stationen (Doku-Zug) |
  NP-01..NP-50-Posten-Register + UEBERHOLT-Marker M-01..M-36 (KON106) = naechster docs-Zug;
  M-Marker-Setzung buendelbar mit KON111-11-Liste (KON112).
- AUFRAEUM-LISTE C (Verlust-Audit, Vollzugs-Doktrinen je remove beachten): golden-rettung |
  p6-Worktree | /tmp-Audit-Checkout | 8 ce-Lokalbranches (cherry +0) | super b-checkheft |
  wt-thesis-lizenz. NICHT anfassen (Liste D): W1-Worktrees bis CI-gruen | a11/f3v/g2/xorf
  (aktiv) | p2/p3 (erst #37-Abgleich) | wf_e22d25ef (BU-Entscheid) | wip/luecken-stufe2
  (T-NEU-13) | backup/rescue-Refs (V9) | Cluster (erledigt).
- OWNER-NEUZUGANG aus dem Kontextende: NP-46 (E-1-Anschlussfrage Text-Aufnahme woertlich)
  + NP-48 (UltiHash<->ComdareDB vierte Entitaet?) — in die naechste Vorlagen-Runde
  (A2.3a-geprueft); dazu 20.7-Punkte (Talos b-Strich, Infra-Fenster-Termin, E-5-Chat-Rest).

## 20.9 SOLL-IST-SWEEP KONTEXT 11 (17.08. spaetnachts, wf_1a1db763; Volltext BU
## folge-bu-kontext12-rueckkehrer/sweep-soll-ist-synthese.json) -- IST/SOLL VERBUCHT

- BAU-BUCHUNGS-FEHLER-REGISTER B-1..B-7 (Kern: Strang-lokale Bilanzen als Landungs-
  Beleg; Lande-Gate-Kette Format/Hygiene/Lock lief vor dem Push nicht -- CI-Rot 15971
  war die Quittung; Kombibau-Logs existieren jedoch: 4x "100% ... out of 499" in BU
  kombibau-logs-steward/). B-1 KRITISCH: super-Fixture-Wache skippt seit W1-Landung
  STILL (FIXTURE-Pfad existiert nach ce-Rename nicht mehr; SYNC-SKIP :56-62 laesst
  genau diese Datei gruen durch) -> super-Zug P.20.4 ist damit DRINGLICH, FATAL statt
  Skip. B-2 behoben (Marker P.20.1). B-3/B-4 = Marker gesetzt. B-5: main.cpp:515
  zweite unbelegte Byte-Gleichheits-Zusicherung -> W2-1. B-6/B-7 AUFGELOEST: N-Liste
  komplett geborgen (Transkript Z65903) -- N1=W2-clang, N5=--debug x dump|ci|cmake,
  N6=Bytevergleich (alle getragen W2-1/W2-2), N3 AUSGEBUCHT (Allowlist fuehrt nur
  Ausserhalb-Bauweg; Tests liegen im Bauweg), N7 BEHOBEN 316c488f, N8 erledigt;
  #80-Status: FIX-Runde IST gelandet (b334a657^2), Rest=HY-A2/A3+M-1/M-2.
- FEHLENDE POSTEN M-1..M-6 EINGEBUCHT: M-1 F-9-Sentinel NAMENTLICH ins #15/HY-A2-
  Paket (hybrid_dock_array.hpp:206-219 "A2.5-FUND F-9, NICHT BEHOBEN"; tragender Weg
  = attach-Definition in gemeinsamem drittem Header) | M-2 TSAN-AUSBAU (fence-Naht
  messbar machen; heute nur Grenz-Doku test_rcu_concurrency:96-105) ins #15/HY-A2-
  Umfeld -- war der einzige Posten ohne Besitzer | M-3 stdout-Bytevergleich als
  MESSUNG + main.cpp:515 -> W2-1 (mit N5 buendeln) | M-4 = B-6 (aufgeloest) |
  M-5 R-OPTION: Sa 22./So 23. traegt KEINE HY-A-Reserve -- faellt HY-A2 aus dem
  #15-Zug vor F2, ist das WE die letzte Flaeche (Slotliste P.20.7 hiermit ergaenzt) |
  M-6 owner-vorlagen-Redundanz-Triage (Ultracode-Funde 7-9/20) klein vor der
  naechsten Owner-Praesentation.
- OBJEKT-PRAEZISIERUNGEN in den #15-Text: HY-A2-Enums EXISTIEREN (anatomy_base.hpp:89
  HeuristikAdapter=3, :141 Reroute-Genus) -- es fehlt allein der ABI-decl-SLOT;
  HY-A3: KEINE Registry steht auf 22 (AllStrategies=22 TYPEN, Aggregat=26,
  cache_engine_axis_registry=18, system_axis_registry=3) -> E-6-Explore benennt
  ZUERST die Ziel-Registry.
- T-NEU-1 NACHGEBUCHT (S-3): s13-F3-Kurz-Verify GEBORGEN (wf_0e1f240b) = 
  TRAEGT_MIT_FIXES -- 5/5 Runde-2-Fixes vollstaendig, Rest 2 KANN-Kosmetika
  ("LANDBAR, keine weitere Lens-Runde noetig"; Basis ce 04ac26fa, 1652 Z.);
  Gate KON100-02 ERFUELLT, die 2 Ein-Zeilen-Edits als Auflage in den Di-25-Zug.
  Vorstufen-Verify wf_100fa0b3 (2 MUSS: Arena-Ueberlauf-Semantik OWNER>PLAN +
  FJ-Posten-Luecken) ist durch F3+diesen Kurz-Verify konsumiert.

## 20.10 E-6-VERDIKT (18.08. frueh, wf_a706de82: 5 Arme + 8 Tieflesen + Synthese, KON118):
## DIE 22 DER HY-A3-FORMEL WAR EIN PHANTOM-NENNER

- HERKUNFT: Formel "(22->23, beide Zahlen)" entstand in EINEM Commit (super ffa4b836,
  08.08. 16:37, Wellenplan v2) an 3 Stellen (:697/:857/:952) OHNE Objekt-Basis --
  Zahl-Quelle = v1-Pauschale "22 Achsen" (v1:52), die v1:526 selbst als Drift fuehrt;
  tiefere Wurzel = toter Kommentar ce axis_reflect.hpp:4 (02.06.). Kein lebender
  Zaehler stand am 08.08. oder steht heute auf 22 (Zensus: organ 18 · system 3 ·
  mess 3/.hpp 16 · prt-art 5 · axes26=26 · kCatalogAxisCount=19 · AxisLibraryRegistry
  34/15). Einzige lebende 22 = AllStrategies der Organ-Achse 03a (22 Such-Strategie-
  TYPEN) -- als Ziel VERWORFEN (Kategorienfehler: Hybrid ist per K1/E-1 Gattung+Genus,
  keine 23. Such-Strategie; 03a bleibt 22).
- VOLLZOGEN IST DIE REGISTRIERUNG LAENGST (HY-A1, 09.08.): Gattungen 3->4
  (anatomy_base.hpp:89 HeuristikAdapter=3) + Genera 5->6 (:169 FunctionInterfaceReroute
  =5), Einzelquelle heuristik_adapter_klassifikation.hpp:79-86 (4/6, 256er-Wache) --
  am Objekt stichprobenverifiziert 18.08.
- OFFENER REST (der reale HY-A3-Registry-Anteil im #15/HY-A2-Slot):
  genus_build_admission.hpp:65 kGenusBuildSlotCounts std::array 5->6 (6. Eintrag =
  CT-Slot-Zahl des Reroute-Genus aus der HY-A2-Bindung, RT<=CT) + static_assert :171
  ==5 -> ==6; Wachen-Nachzug test_e24_c4_genus_pruef_docks.cpp:363 (handgefuehrte
  kAllGenera{5}-Kopie auf Einzelquelle umstellen); Dock-Registry bleibt designfest 5
  (Reroute-Genus NICHT ABI-sichtbar).
- ABNAHME-ERSATZ fuer die :952-Formel "Registry 22->23": ctest druckt vorher/nachher
  kGenusBuildSlotCounts.size() 5->6 UND die Einzelquellen-Paare 4 Gattungen / 6 Genera
  ("beide Zahlen" = beide Ebenen, je vorher/nachher).
- MARKER: Die Stellen :697/:857/:952 gelten in ihrer 22->23-Haelfte als UEBERHOLT durch
  DIESEN Abschnitt (Text bleibt stehen, Doku-Doktrin). Nebenfunde: ":121/:1026
  AllFourteenAxesPopulated bei heute 22/18 Achsen" traegt dieselbe Phantom-22 (real 34
  Zweige/15 Hauptachsen) -- bei R-4 korrigieren; stale "21 AllStrategies"-Kommentar
  test_v41_topic_traversal.cpp:1278 bei naechster 03a-Beruehrung.

---

# 21. KONSOLIDIERUNG KONTEXT 13 (nachgetragen 18.08.2026 spaet) --
# NIE AUSBUCHEN/VERSCHIEBEN + #15-FIX-STAND + WIEDERAUFNAHME

> par.13-par.20 bleiben stehen; was hier steht, gilt vor. Quellen: Regressionen-Register
> (docs/sessions/20260818-SESSION-REGRESSIONEN-bump15-codex-audit-review.md) + Wiederaufnahme-Register
> (docs/sessions/20260818-SESSION-WIEDERAUFNAHME-REGISTER-nie-ausbuchen-alle-features.md) + Uebergabe Kontext 13
> (docs/sessions/20260818-SESSION-UEBERGABE-kontext13-bump15-bruch-fertig-audit-laeuft.md); bei Widerspruch:
> Owner-Wort schlaegt alles, Neueres schlaegt Aelteres.

## 21.0 BETRIEBSREGEL (Owner 18.08.): NIE AUSBUCHEN/VERSCHIEBEN + BELEG-TAFEL + PROZESS-ERTRAEGE

**Betriebsregel (Owner 18.08., verbatim-Kern):** "Es wird NIE etwas ausgebucht oder verschoben" +
"NIE kuerzen, gesamte Kette voll, ALLE Features; morgen mit mehr Kontingent multiple Strecken parallel".
Konsequenzen: (1) jeder vertagte/verschobene Posten erhaelt einen Platz VOR der Abgabe; (2) W7 ist KEIN
Endlager mehr -- nur noch Nach-Abgabe-Kuer fuer ausdrueckliche Owner-Entscheide (Tafel par.21.6);
(3) Limit = pausieren/sequentialisieren, NIE reduzieren; (4) "deklariert" schuetzt nicht mehr vor
Wiederaufnahme -- alte Marker bleiben als Historie stehen, die neue Platzierung steht daneben;
(5) die Feinplatzierung beim Di-25.-Schnitt nimmt JEDEN Posten namentlich auf (Task #96).
Memory-Anker: feedback_nie_kuerzen_gesamte_kette_voll_alle_features.

**Beleg-Tafel der 8 entdeckten + geheilten stillen Kuerzungen (Fork gab-es-denn):**

    (1) Selektiver Rebuild geloescht (ce 813c3232, 27.07.) -> C-13 gebucht; Traeger jetzt Task #97 (par.21.4)
    (2) checkpoint_measure -> W7 trotz Owner-KERN -> zurueck als B4/System B (#24/W2)
    (3) F-07b-Diagramme -> W7 mit ERFUNDENER Autorisierung -> UEBERHOLT-Marker ff64fe0e steht;
        Bau-Traeger jetzt Task #98 (par.21.4)
    (4) "W1 KOMPLETT" galt nur den Straengen, HY-A2/A3 ungebaut -> im #15-Bruch nachgebaut (e285d316)
    (5) #17/g2 ungelandet -> W1-V1/#93 (par.21.2)
    (6) 06_evaluation_methodology still nicht eingebunden -> #67 (8/8 abgedeckt, DEPRECATED-Kopf)
    (7) Audit-slice(0,14) + stille Limit-Filterung -> Voll-Umbau + Vollzaehligkeits-Gates
    (8) Synthese-Dedup-Verlust -> per Verify-Rekursion R2 gefangen
    Dazu 2 Prozess-Faelle + Abgrenzungsliste "deklariert" -- Details traegt das Regressionen-Register.

**Prozess-Ertrag Codex/Plan-B:** bwrap DAUERHAFT defekt (7 Tode, nicht-deterministisch, "bwrap: loopback:
Failed RTM_NEWADDR"; Root-Cause-Kandidat Linux 6.17 User-Namespace -- Infra-Notiz). Plan-B-Rezept =
codex exec CLI mit Diff-VOLLTEXT im Prompt (einziger dateizugriffs-freier Weg) -- damit die ersten 4/4
erfolgreichen Codex-Lenses (gpt-5.6-sol, reasoning ultra, Lauf-Header belegt); Ersatz-Lens-Klausel:
je Anlass eine frische Defekt-Probe. Memory-Anker:
reference_codex_lens_klein_schneiden_und_immer_zweiten_lens_parallel.

**Prozess-Ertrag sequentieller Audit-Umbau + Vollzaehligkeits-Gates:** Audit wf_794b904b und Review
wf_13b562e7 laufen als sequentielle Resumes (wg7df0h36 / w5swesjti) statt Neustarts; das Script traegt
jetzt ein 11/11-Quellen-Gate, keinen slice-Deckel, und unverifizierte IDs bleiben im Ergebnis; der
Synthese-Dedup-Verlust (C-F3) wurde durch die Verify-Rekursion R2 gefangen; Resume-Bilanz 5c: kein
weiterer nicht-doppelter failed Workflow. Nebenbefund: Orchestrator-Bug Template-Literal-Interpolation
(Heredoc-K11) -- der Verify rekonstruierte aus journal.jsonl (journal.jsonl = Wahrheit).

## 21.1 #15-FIX-STAND (FIX-KOMPLETT, UNGELANDET) + LANDE-KETTE + super-ZUG/KON119 + FOLGEZUEGE

**#15-Bump-Bruch FIX-KOMPLETT, UNGELANDET.** Worktree wt-ce-bump15, Branch bau/bump15-preimage-bruch,
End-Tip e285d316 (32 Commits auf ce/development 20c111c4). A2.5-Rekursion formal beendet: 43 BEHOBEN /
3 ENTLASTET / 4 VERTAGT ueber 2 Fix-Strecken (wf_a1b55606 + wf_b943361e), Verify R2 = NULL_NEUE_FUNDE.
Review-Gesamt-Verdikt LANDBAR_MIT_FIXES (11/11 Agenten, 30er-Fix-Liste abgearbeitet). Abnahme am
End-Tip neu gemessen: gcc-release 503/503 + clang-release 503/503 (Fix-21-Pflicht erfuellt, stale
EXCLUDE_FROM_ALL-Binary per Relink geheilt) + gcc-debug 499/499 (Differenz 4 per comm erklaert);
golden-Diff 67dafa46..e285d316 = 0 Byte, TABU-CRC 0x56F1B721C72DC10E unbewegt, Diff-Hygiene gruen,
gitleaks-Koeder biss. Wartet NUR noch auf: Audit-Ruecklauf -> Fix-Strecke 2 -> W1-Audit #93 -> Landung
(Kette: par.21.5). FRIST: Landung vor F2 (Fr 21.08.). Marker am #15-Task-Eintrag (par.18.3) gesetzt.

**Lande-Kette ce (Rezept Kontext-13-Uebergabe Abschnitt 4), Schritte 1-4, FRIST vor F2:**

    (1) .review-tmp/ loeschen; ggf. clang-Zelle wiederholen (Slot-Protokoll, Deckel 3)
    (2) git checkout development && git merge --no-ff bau/bump15-preimage-bruch
        (EIN Merge, 32 Commits als Historie)
    (3) WELLEN-ENDE-GATES am ENDSTAND (KON116): Lock-Regen --check -> Drift erwartet -> --write-Regen
        als eigener Commit mit Begruendung je Traeger. Endstand der Drift-Probe LITERAL PROTOKOLLIERT:
        Exit 1 mit 4 versionslosen Traegern '(- -> -)' (anatomy_base, observable_tier, pruefling_merge,
        target_isa_complex_axis) -- diese erhalten ihre Erst-Version (inhaltliche Entscheidung,
        bump15-d-Hinweis). LS2-34-Audit-Verdikt deckungsgleich: der Regen ist Schritt 3 der
        Lande-Kette, KEIN Vorab-Worktree-Fix. Dazu: kumulative Hygiene --bereich e114cabd HEAD |
        clang-format-CI-Formel | gitleaks glpat-Koeder (Laenge 26, Assert) + Echt ueber git log -p |
        Floor-Check
    (4) EIN Push (origin+github) -> EINE CI -> Ergebnis direkt per API messen; dazu die
        B-10-Anker-Faelligkeit beim Landen pruefen

**super-Zug ATOMAR als EIN Lande-Ereignis (Schritt 5) -> KON119; FRIST vor F2, direkt nach der
ce-Landung.** XSD-Patch super_xsd_golden_verbund.patch (113 Zeilen: XSD-Dreier-Enum Verbund1/2/3
Z.253-255 + Prosa :39/:333-335 fulljoin->union + Kommentar :241-244 + experiment_golden_kern.xml
7 Stellen + experiment_golden.xml 6 Stellen; per-Achse-@merge ist xs:string, Wertpruefung allein
validate_profile.hpp:665; die Subset-Wache koppelt Fixture+XSD => MUSS ein Lande-Ereignis MIT Gitlink
sein) + Gitlink -> Merge-SHA + PZW-Anker LIVE neu messen (Nenner steigt um neue Test-.cpp:
test_hy_f8_reroute + test_q2_identitaets_riegel + ggf. weitere -- ZAEHLEN, nicht raten) + KON119 =
Lande-Bericht MIT Namensnennung bump15-a/b/c/d + TABU-CRC literal + Audit-/Review-Verdikte +
seg1-04-super-Haelfte (6 stale E-6-Stellen im Hybrid-Bauplan, per A2.5-R2 dem KON119-super-Zug
zugewiesen) + Koeder + Dual-Push + CI-gruen. KON119-Marker im Wellenplan-Kopf gesetzt.

**Bauplan-Folgezuege NACH der Landung (BUENDEL-BAUPLAN-15.md = juengste Quelle, K15):**
B-7-Stempel-Haelfte (E-B Emitter-Name + Stempel-Pflicht in Makros -- golden-Ereignis; das
V-03R-Budget deckt es und ist UNVERBRAUCHT) | B-10-Anker (frozen kFrozenFingerprintV1, test_d4:194,
e24-Leer-Digest-Pins, w10-Hex-Pins -- "NOCH NICHT setzen" galt fuer den Bau, beim Landen die
Faelligkeit pruefen) | B-8 (RT-Dock-Haelfte A-12) | N-1..N-6 | VL-5/VL-6-Doku | KORB-A-12 (B3
Schalter-Hoheit, Owner-Datum noetig -> par.21.2). Golden-Teile als golden-Ereignis im F2-Umfeld.

## 21.2 W1-LUECKEN: g2 UNGELANDET (KRITISCH) + B3 OHNE BAU-SPUR (ERNST) + W1-AUDIT #93

**W1-V1 KRITISCH: #17/g2-Strang UNGELANDET.** Commit 1528f6fd ('feat(measurement): #17 G-2-Semantik --
Redundanz-Wache der Flag-Menge als B12-Term (e)') ist NICHT Ancestor von ce/development 20c111c4
(merge-base-Beweis 18.08. ~15:15). P.20.1 "Welle 1 KOMPLETT" galt nur der Landung der 4 Straenge
(hy-a/vl12/vl3/k2); P.20.3 fuehrte g2 als ERSTES Glied der Welle-2-Lande-Liste, die KON116-Landung
nannte aber nur xorf+f3v+a11. #17 schliesst die Stempel-Strecke und gibt #7/S-19 frei (KON17-01)
=> Lande-/Fertigstellungs-PFLICHT VOR F2 (Fr 21.08.). Marker an P.20.1 + P.20.3 gesetzt.

**W1-V2 ERNST: B3 Schalter-Hoheits-Umzug OHNE Bau-Spur.** Owner-Datum "VOR F2" (KON34-04; KON37-01:
der Tier-Pflicht-Wurf abi_adapter.hpp:476-491 faellt); im Bruch-Worktree KEINE B3-Aenderung an
abi_adapter.hpp (Treffer dort sind B14-Altbestand). Praezise Bau-Stands-Messung + Frist-Einordnung =
W1-Audit Gruppe D (#93). FRIST: Owner-Datum vor F2.

**W1-Vollstaendigkeits-Audit Task #93** (Owner-Zweifel 18.08.: "W1 offiziell abgeschlossen -- stimmt
das vollstaendig?"): 8 sequentielle Pruefgruppen (Straenge+VL-3-Fixes | Stempel-Strecke
S-1..S-7/S-6a-d | HY-A | B-Schalter | #17/g2 | Statistik/Menge D4/D5/##10-19 |
Designplan-par.4-W1-Testlast | Freeze-Check-Liste par.18.3) + Synthese mit Frist-Dreiteilung
(offen-vor-F2 / gebaut-ungelandet / W2-deklariert / gestrichen-deklariert / unklar). Script
workflows/scripts/w1-vollstaendigkeit-wf.js; Start NACH Review-/Audit-Ruecklauf (Limit-Doktrin);
das Ergebnis wird Abschnitt 9 des Regressionen-Registers und traegt danach einen Nachtrag HIER.

> EINPLANUNGS-MARKER 23.08.2026 (par.24): der hier VERSPROCHENE Nachtrag ist par.24.3.2 — W1-Vollaudit-
> Restmenge Stand 21.08. (VOLLLISTE): 156 OFFEN-mit-Traeger + 22 VERTAGT + 34 GESTRICHEN-neu-bewerten +
> 74 offene Regressionen + 20 Status-Konflikte + 15 traegerlos (jetzt ALLE mit Traeger); Abgleich-Strang
> RN-17 (#128), Endstand-Gate RN-70. Die W1-V2-Zeile "B3 OHNE Bau-Spur" ist Snapshot-HISTORIE (23.2/
> KON119-02: B3 GEBAUT_UNGELANDET -> mit #15 GELANDET).

## 21.3 WIEDERAUFNAHME-PLATZIERUNGEN (Register Teil B): JEDER VERTAGTE POSTEN MIT NEUEM PLATZ

> EINPLANUNGS-MARKER 23.08.2026 (par.24): die Slot-Anker dieses Abschnitts ("WE 22./23." und "Mo/Di 24./25."
> nach S-19/T-15b) sind kalendarisch verstrichen bzw. durch den P3-Riss obsolet; die Baender 22+37+5+14
> bleiben VOLLZAEHLIG gezaehlt und erhalten NEUE Slots im #96-Feinplatzierungs-Schnitt Di 25. (RN-26;
> Zwischenslots RN-16/RN-54/RN-66). Nichts ausgebucht.

**Band B/W1 (22 Posten, 62 h; der D-2-Marker "geschlossen gestrichen" ist Historie):**
AG-Concepts11/IsComposition/Noexcept, XL-L3/L5, ST-RankingTie/DriftBestwahl, PK-Folgeposten,
AS-Katalog/ORG18/Aritaet/NameClean, LG-Kollision/NoThrow/CommitAtom/Zeilenlimit,
PM-m3v2Spalten/Outcome/CTZweig/OffZwilling, MT-L9, PE-JobBindung/Startgate. NEUE Platzierung =
W2-Randslots Mo/Di 24./25. (parallel zu S-12/S-13 als disjunkte Test-Straenge,
Mehr-Kontingent-Parallelitaet) + WE 22./23. nach S-19/T-15b-Kern + Rest W3-Batch-Pausen [lok]
(par.3-W3 erlaubt lokale Arbeit ausdruecklich). Der D-2-Marker bleibt als Historie stehen, die neue
Platzierung steht daneben (Designplan Abschnitt 8 + Abschnitt 10 markiert).
FRIST: WE 22./23. + Mo/Di 24./25.; Feinplatzierung Di 25.08.

**Band-B-Rest (37 weitere der 59 Posten, ~104,5 h):** W3-Batch-Pausen [lok] (5,75 Maschinentage
Kampagne = die Maschine misst, die Session baut lokal ohne CI-Last -- VEREINBAR mit "null CI-Last",
[lok]-Klasse ohne Pipeline) + W4 Mo-Mi + W4-Fangnetz Do/Fr. Marker an par.3-W3 gesetzt.

**Band C (5 Posten, 13 h) -- Begruendungen TEILS UEBERHOLT:** PM-WinPCM: Windows-Runner seit #60
ONLINE (4/4) => W2/W4 fahrbar (die alte Begruendung "kein Windows-Runner im Fristpfad" ist UEBERHOLT
AM OBJEKT) | PM-AmdL3 1-2: CAP_PERFMON = Talos-Lane #87 (Infra-gebunden, sobald v1.13.x) | MT-L8 +
PM-PAPI + AG-PunktFixes => W4. FRIST: W2/W4; AmdL3 Talos-abhaengig (#87).

**##40-Restbau (T-06 KF-6/60, T-07 RAM-Spool, T-08 Dual-ccache, T-09, T-10, T-12 Cross-Genus,
T-13/T-14 FK-Walk, W-03, W-08, A14, A10; ~10-11 WT-Anteil):** T-13/T-14 (Fehlerklassen!) =
C-12-PFLICHT VOR W3 (par.19.3 fuehrt sie schon; vor Sa 29.08.) | Cacheline-/Spool-Achsen T-07/T-08
VOR dem Trigger Mi 26.08. falls mengen-wirksam, sonst W2-Slots | Rest W4. Marker an par.19.3 gesetzt.

**HY-Vollausbau (Heuristik-Familie, Mehrfach-Dock>1, scharfe Eviction):** Mehrfach-Dock =
HY-B/W3-Design -- der MaxDocks==1-static_assert aus der A2.5 (A-F2) ist der EHRLICHE Minimal-Pin,
KEIN Verzicht; slotbezogene Basiszeiger + explizite Routing-Regel = HY-B/W3-Design, dann W4-Bau nach
den HY-C-Kurven | Heuristik-Familie/Eviction W4 nach HY-C.

**14 W7-Posten par.13.3 (#29-Rest #30 #32 #34 #42 #44 #48 #50 #63 #64 #69 #71 #72 #26) + P/E-Core
(#21) + IO-Vollausbau (#38a3) + par.75-Pass + Record-and-Replay + PV-1:** NEUE Platzierung =
W4/W5-Randslots, GEZAEHLT -- je Posten beim W2-Planungs-Schnitt (Di 25.) ein konkreter Slot; W5
traegt nur Nicht-Bau-Anteile (Doku/Registrierung); was OBJEKTIV nach der Abgabe liegen MUSS, braucht
einen Owner-Satz (Kategorie C, par.21.6) -- sonst faellt NICHTS. Marker an par.13.3 gesetzt.

**##15-EMITTER/TEMPLATE + ##24/A9-S5a ("rutschfaehig", klein):** die Rutsch-Klassifizierung ist
AUFGEHOBEN -> ##15-EMITTER/TEMPLATE = W2-Slot, ##24/A9-S5a = W4. Marker an den Rutsch-Vermerken
(par.7) gesetzt.

**Register-Vollautomation ##31 + D1c-Vollausbau (Rueckfallstufen):** die Rueckfallstufen bleiben
UNGEZOGEN (nur bei Riss); die Vollformen werden W2-W-Posten. FRIST: W2.

**Kapazitaets-Ehrlichkeit (Zahl, KEINE Streichung):** Wiederaufnahme-Volumen grob 62 h (B/W1) +
~104,5 h (B-Rest) + 13 h (C) + ##40-Reste + W7-Liste = >200 h zusaetzlich auf 19 Kalendertage bis
T-3. Deckung per Owner-Entscheid: (1) "volles Risiko" (par.14-Praezedenz: Reserve null als Zahl,
kein Veto), (2) Mehr-Kontingent-Parallelitaet ab 19.08. (6+ disjunkte Straenge; Bau-Slots-Deckel 3
bleibt), (3) die [lok]-Klasse traegt W3 mit. Engpass EHRLICH: W2 traegt die Trigger-Pflichten ZUERST
(S-19-Zahl, S-13-Buendel, VOLLBAU-GATE); Wiederaufnahme-Posten fuellen Slots, verdraengen NIE
Trigger-Pflichten; Reihenfolge je Slot beim Di-25.-Schnitt, ALLE gezaehlt. Marker an par.14 gesetzt.
FRIST: Di 25.08. (Schnitt); Vollzug + Feinplatzierung = Task #96 (par.21.4).

## 21.4 NEUE TASKS #94-#98 + B-5f-TRAEGER-LUECKE

**Task #94 (NEU, aus A2.5 VERTAGT), W2:** C-F4 -- der Abi7-Freeze ist verwechselbar mit dem lebenden
Minor (decl.hpp ~:780/:784, beide oeffentlich, typgleich, aktuell wertgleich 2 -- ein Konsument kann
den Freeze-Wert ziehen, unsichtbar bis zum naechsten Live-Bump). Kapselung als unteilbares
Abi7-Tupel bzw. technische Begrenzung auf Freeze-/Ablehnungstests. (decl.hpp:797-Rest: par.21.6,
mit dieser Flaeche koppelbar.)

**Task #95 (NEU, seg1-40 VERTAGT), vor F2:** V-08R nur zur NAME-Haelfte im Bruch --
planner_version.hpp:78-84 fingerprint_sha() weiter bewusst leer (kFingerprintShaBewusstLeer=true).
V-08R ist seit KON101 BUENDEL-SOLL (B-6-Rest), aber die Owner-Form SHA-256/64-Hex kollidiert
GEMESSEN mit dem 128-Hex-S-1-Vertrag stempel_basis.hpp:378-387 -- eigener Bau noetig; der
Frist-/Form-Entscheid ist F2-Vorlagen-Punkt 5 (par.21.6).

**Task #96 (NEU), Di 25.08.:** Wiederaufnahme-Register-Vollzug + Feinplatzierung (Stunden je Slot)
NACH Audit- und #93-Ruecklauf; die W2-Feinplatzierung (Di-25.-Schnitt) nimmt JEDEN Posten des
Registers namentlich auf; die Posten-ZUORDNUNG des Registers ist bereits vollstaendig (par.21.3).

**Task #97 (NEU), vor Kampagne Sa 29.08.:** C-13+C-14 Selektiver-Rebuild-Wiederherstellung (stille
Kuerzung ce 813c3232 vom 27.07.; C-13 war in par.19.3 gebucht, aber der Traeger war NUR T-NEU-11 im
Rest-Register, kein Board-Task) -- VOR der Kampagne. Marker an par.19.3 gesetzt.

**Task #98 (NEU), Bau W4:** F-07b-Diagramm-Bau in W4 mit ##60 (Owner-KERN 06.08.: 2D+3D SOTA; die
W7-Verschiebung trug eine ERFUNDENE Autorisierung, der UEBERHOLT-Marker ff64fe0e steht) +
ZUSATZFUND: die par.5-Defizit-Arithmetik zaehlt F-07b NOCH als Deckungs-Streichung -- die Rechnung
ist um diesen Posten zu korrigieren (docs-Zug; Korrektur-Marker an par.5 gesetzt).

**B-5f-Bau-Posten: TASK-TRAEGER FEHLT (ausgewiesener Befund dieser Extraktion).**
Tooling-Ordnungs-Validierung (wallclock/macro/micro) an ALLEN DREI Stellen per KON106-02/NP-18 --
V-13 ist per KON101 BEANTWORTET (A2.5-R2-Praezisierung zu seg1-43: "deklariert-ungedeckt";
ceb_tooling_list wirft heute nur bei unbekannter id/Deckel/leer; owner-vorlagen-Gegenprobe: kein
stale Vorlagen-Punkt). B-5f hing an KEINEM Board-Task (#93-#98 decken es nicht, das
Wiederaufnahme-Register nennt es nicht) -- Traeger ANGELEGT: Task #99 (18.08., diese
Konsolidierung), hier gefuehrt, kein stiller Bau. Kein Owner-Datum -- beim Di-25.-Schnitt
slotten (W2).

## 21.5 VERDACHTSFAELLE (Aufloesung via Audit/#93) + LANDE-VORBEDINGUNGS-KETTE

**Verdachtsfall golden-Nachposten E-B-CRC / K1-avx512-Filter / telemetry-silent (seg1-44):** nur der
S-6a-Anker-Teil ist im Bruch; der Task-#15-Text sagt "3 golden-Nachposten im Bruch", die
Kontext-13-Uebergabe deklariert "E-B/A-11 = golden-gebundener FOLGEZUG (V-03R-Budget frei)" --
SPANNUNG AUSGEWIESEN, ENTLASTET-bestaetigt in A2.5-R2; die juengere 19.1-Linie: E-B faehrt IM
#15-golden-Ereignis => Kandidat: VOR die Landung in den Bruch. Aufloesung durch Audit-Synthese +
ggf. Owner-Satz (par.21.6 Punkt 6), VOR der Landung. Marker an par.19.1 gesetzt.

**Verdachtsfall V-06 Lesart A:** Stempel-Pflicht GEWEITET (comdare_anatomy_version_lines PFLICHT +
Emitter-Integration) vs. 2 Symbole; per R2-Commit 7bc997a2 als LESART A festgeschrieben, aber
golden-gebunden -> Folgezug (B-7-Haelfte, V-03R-Budget frei). Aufloesung laeuft (Voll-Audit + #93).

**Verdachtsfall B1 (W1-Ende):** Aufloesung durch #93; das Ergebnis fliesst ins
Wiederaufnahme-Register Teil D und in die par.21.2-Frist-Dreiteilung.

**Verdachtsfall A1-Durchzug 9-vs-18 (LS2-33):** simd_organ_requirement 9x kRequiredNone gegen
Registry 18; die Kette ist verdrahtet, der Durchzug fehlt; in A2.5-R2 VERTAGT -> #44-Rest
(git-log-Beweis: der Bruch beruehrt die Flaeche nicht); bekannter W1-Posten, Aufloesung Voll-Audit +
#93 (W1-Rest, Einordnung via #93).

**Verdachtsfall 23 Band-A-Testposten aus Designplan par.4-W1:** den Ist-Stand misst #93 Gruppe G;
das Ergebnis fliesst in die Frist-Dreiteilung.

**Laufende Audits als Lande-Vorbedingung (Kette aus par.21.1):** Voll-Audit wf_794b904b (688
Zusagen, sequentieller Resume, Vollzaehligkeits-Gates; erwartet ~47 Verif-Pakete + 3 Kontext-Lenses
+ Synthese mit Lande-Freigabe-Urteil -> Regressionen-Register Abschnitt 6; die 36 Fruehverdikte
werden gegen die Vollmenge abgeglichen) -> danach Fix-Strecke 2 (A2.5 ueber die Audit-Funde,
dreiwertige Quittung, Rekursion bis 0 neue Funde) -> W1-Audit #93 -> Landung. Die Review-Haelfte ist
ZURUECK und abgearbeitet (LANDBAR_MIT_FIXES). FRIST: vor Landung/F2.

## 21.6 OWNER-ZEILEN-TAFEL (Kategorie C) + OFFENE RESTE + F2-VORLAGEN-FENSTER

**Owner-Zeilen-Tafel (bleiben per Owner-Wort; Revision NUR per Owner-Satz, transparent gelistet,
NICHT eigenmaechtig gekippt):**

    OV-4    Vollmessung -> Deckel (Owner-Wort: Deckel-Doktrin + S-19 rechnet; F2-Vorlage "ja"
            empfohlen+angenommen). Neubewertungs-Fakt NUR MELDUNG: physikalisch >=143 Tage
            einthreadig -- der Deckel ist Mess-AUSWAHL, keine Feature-Kuerzung.
    OV-5(b) prod2-Lane -> Textkorrektur (Owner "ja" 09.08.; damalige Begruendung "prod2 existiert
            nicht", rc 2). UEBERHOLT AM OBJEKT: prod2 ist seit #60 online (id=17, Gen-2-Kapazitaet
            34,4 h gerechnet); soll die pmc:intel-/P-E-Lane zurueckkommen, genuegt EIN Owner-Satz,
            der Bau-Platz W2/W3 existiert. Transparent gemeldet, nicht gekippt.
    OV-14   Paper-Kopplung -> nach Abgabe (Owner-Wort 17.08.-Runde + LEDGER:11128 Ruecksprache);
            bleibt, ausser der Owner dreht.
    W7/#88  Monolith-Split (Owner-B3 woertlich "beim Aufraeumen"); bleibt -- einer der
            ausdruecklich Owner-entschiedenen W7-Posten (vereinbar mit par.21.0: W7 nur per
            Owner-Entscheid).
    Resttafel (Vollzaehligkeit): OV-2 checkpoint_measure (KON34 "muss gebaut werden") ist BEREITS
            ZURUECK als B4/System B (#24/W2) | KON29-01 Debug-Ergebnisse-Loeschung bleibt die
            einzige Messdaten-Ausnahme (kein Feature).

**Offene Reste (benannt, KEINE Lande-Blocker):**
- clang-debug-Zelle ROT -- PIE/HDR-Link (libcomdare_hdr_histogram_wrapper.a R_X86_64_32S),
  vorbestehend/neu-sichtbar (HDR+libs/common in 0 Bruch-Commits beruehrt); in der A2.5-Abnahme
  deklariert nicht gefahren; die Synthese-Entlastung "vorbestehend" liegt vor. Eigener Posten,
  Behebung als W2-Slot (kein Lande-Blocker).
- clang-format-22-Anomalie 122-vs-120 -- der lokale Formatter alignt Makro-Escapes auf 122, der
  Datei-Standard ist 120; manuell normiert; CI-lint:format faellt das Urteil (Praezedenz: der
  set-Kopf verletzt den lokalen dry-run AUCH und ist CI-gruen). Beobachten am Lande-CI-Lauf.
- decl.hpp:797 stale Referenz -- benannter Doku-/Kommentar-Nachzug im Abi7-Umfeld; mit der
  Task-#94-Flaeche koppelbar (par.21.4).
- C-3a (#38a1): EINZIGE offene Owner-FRAGE dieses Standes, FRIST Mi 19.08.; laeuft im
  F2-Owner-Vorlagen-Fenster als Punkt 4 mit.

**F2-Owner-Vorlagen-Fenster (Ein-Satz-Vorlagen, aus Task-#15-Metadata owner_vorlagen_fenster, nach
der Landung; Verweis par.21.1 Schritt 5/6). FRIST: mit der Landung, vor F2 (Fr 21.08.):**

    (1) AxisKind-Ordnung im Bruch mitdrehen? (seg1-37; KON5-04: AxisKind war immer Owner-VORLAGE,
        nie festgelegt; ohne GO kostet die spaetere Drehung einen weiteren Preimage-Bruch)
    (2) E-6-Satz: "22->23 war Phantom-Nenner, Rest = kGenusBuildSlotCounts 5->6 ist gebaut --
        Einspruch?" (KON118)
    (3) KON60-04-Spannung S-6 (stale, blockiert nicht)
    (4) C-3a-Frist (Mi 19.08.)
    (5) V-08R-Form-/Frist-Entscheid (#95: Owner-Form 64-Hex vs. 128-Hex-S-1-Vertrag)
    (6) ggf. golden-Nachposten-Satz (seg1-44) und Owner-Saetze fuer objektiv-nach-Abgabe-Posten
        (Kategorie C der W7-Liste, par.21.3)


# 22. KONSOLIDIERUNG KONTEXT 15 (nachgetragen 19.08.2026 abends) --
# LIEGENGEBLIEBENE + SPAETER FAELLIGE POSTEN (Owner-Order: nichts darf verloren gehen)

> par.13-par.21 bleiben stehen; was hier steht, gilt vor. Owner-Order 19.08. (verbatim-Kern): "Ich
> sehe hier viele Aufgaben, die zu einem spaeteren Zeitpunkt relevant werden und noch gebaut werden
> muessen - diese duerfen nicht verloren gehen." Quelle: Liegengebliebenen-Sweep K14+K15
> (wf_d42115cb) ueber das K15-Transkript; Traeger-Abgleich gegen DREI Quellen komplett:
> (1) Task-Board 103 Tasks (Dump taskboard_kompakt_k15.txt + Live-Board; #102 F6-golden-Zug Frist
> Do 20.08. und #103 TSan-Vollausbau EXISTIEREN bereits, #100/#101 completed), (2) Wellenplan
> par.18.1-21.6 komplett (Z.2195-3156), (3) Regressionen-Register 12.4 (Z.1094-1116) + Abschnitt
> 13/13.8 (Z.1117-1213) + Wiederaufnahme-Register G-Tafel (Z.76-109, 23/23 L-Posten mit Traeger,
> "#96 prueft diese Tafel MIT"). Objekt-Gegenproben: TaskGet #15/#17, G-Tafel, Memory
> reference_lokale_vollbau Z.70-78 (Z.75-Fix bereits korrekt am Objekt), s13-Design Z.1382-1390
> (Defekt BESTAETIGT), apps/-CMakeLists (Target-Namen literal).
> GEGENZAEHLUNG: 195 rohe Kandidaten (Nr. 195 'ccache 1837 Hits' trunciert, per Register 13.8 A16
> identifiziert) -> 120 deduplizierte Posten = 96 GETRAGEN (davon ~12 bereits ERLEDIGT am Objekt)
> / 19 TEIL-GETRAGEN (22.2) / 5 UNGETRAGEN (22.1). NIE-KUERZEN angewandt: bei Zweifel
> TEIL-GETRAGEN. Bei Widerspruch: Owner-Wort schlaegt alles, Neueres schlaegt Aelteres.

## 22.0 KERN-ERTRAEGE K15 (5 Zeilen)

    (1) FIX-STRECKE 2 KOMPLETT: Verify NULL_NEUE_FUNDE; Abnahme/R2 @ 8cd32a0d, End-Tip 79171599
        (Delta +3 tools-Format-Dateien +1 Kommentarzeile ausserhalb der CI-Pruefmenge, 13.8 A13);
        Commit-Tafel e285d316..79171599 = 20 Commits, Eingangsmenge 15/15 GEDECKT (13.8).
    (2) g2-HARMONISIERUNG + KOMBISTAND-ABNAHME @ b02b7523 (#17-Lande-Zug laeuft; Vorstufe
        g2-ENDSTAND cb856212, Rest-Kategorien leere Menge, 4/4 Zellen @ 9aa9b9df -- 13.6).
    (3) clang-debug-Zelle GEHEILT: der par.21.6-Offene-Rest "PIE/HDR-Link" ist ZU -- Wurzel war
        Zellen-MISCHBAU (CMAKE_C_COMPILER=/usr/bin/cc -> gcc-15.3 ohne PIE-Default bei
        CXX=clang++, prod1-Maschinen-Falle; 13.8 A10); Rest-Haelfte PIC-Hausnorm = W2-Mini
        (22.2 T-4).
    (4) VERTAGT-DAUERREGEL (Owner 19.08.): vertagt ist NUR Zwischenzustand -- landen, dann
        Vertagte durchziehen, NACHLANDEN; nie ueber Landungen tragen. Memory-Anker:
        feedback_vertagt_ist_nur_zwischenzustand_vor_landung_durchziehen.
    (5) BU-ORDNER GELANDET @ 9052a56b (Redaktion wf_279c39c0 FREIGEGEBEN 18/18 SAUBER,
        CI SUCCESS -- 13.6); Folge-BU-Nachzug des NEUEN Schnappschusses = 22.2 T-17.

## 22.1 UNGETRAGENE POSTEN (5) -- HIERMIT VERANKERT (je Faelligkeit + neuer Traeger)

**U-1 ROT: s13-design-J-1-REZEPTFIX (Faelligkeit: vor Di 25.08., VOR dem S-13-Buendel-Bau #18;
Traeger NEU: ROT-Auflage am Task #18 + Ein-Zeiler-Fix im naechsten docs-Zug + Ledger:4501).**
docs/plaene/20260817-DESIGN-s13-buendel-di25.md:1384-1385 traegt praefixlose Target-Namen
'adhoc_emitter_cli' / 'anatomy_codegen_cli' -- die realen Targets heissen comdare_adhoc_emitter_cli
(apps/adhoc_emitter) und comdare_anatomy_codegen_cli (apps/anatomy_codegen_tool); am Objekt 19.08.
per add_executable-Zeilen NEU verifiziert. Woertliches Fahren des Di-25-Buendels kostet
ninja-unknown-target + die 'Not Run'-Klasse; dem Block fehlt zudem die J-4-Stufe
'--target comdare_tests' (Memory-JOIN-CHECKLISTE J-1..J-4). Dazu Ledger:4501-Mikro-Korrektur
(KON61-13-Apps-Zensus) im selben Zug. 0 Treffer in Board / par.18-21 / Register 12.4+13; die im
Sweep behauptete Verankerung an Task #17 ist per TaskGet WIDERLEGT (#17-Beschreibung traegt sie
NICHT); der s13-design-Agent lebt nur fluechtig als Session-Agent. 22.4-Zeile Z-1 zaehlt gegen.

**U-2 PLATTEN-RAEUMUNG prod1, ROOT-SEITIG (Faelligkeit: Owner-gebunden -- root noetig; VOR den
Vollbau-Wellen WE 22./23., die S-19 + T-15b + I-PMC tragen; Traeger NEU: Owner-Betriebs-Punkt im
Infra-Fenster Do 20.08. abends + Di-25-Betriebszeile in #96 = 22.4 Z-14).** /tmp/comdare e2e-b-ci
~8G + comdare-gcc-build-65450/-192499 ~1.5G gehoeren USER gitlab-runner (eigenes rm scheiterte
literal 'Permission denied', Transkript Z70795) + ~1.24G geloescht-offene Dateien an 4
Alt-claude-Binaries (Freigabe nur per Prozess-Neustart; PIDs 210282/875273/2178939/2760805).
Platte pendelte in K15 zwischen 100% belegt (1.4M frei) und 12-18G frei (Z70786/Z71350); 13.6
verbucht nur das ENOSPC-EREIGNIS, nicht die Raeum-Handlung; 0 Treffer in allen drei
Traeger-Quellen. Memory-Anker: volle Platte toetet auch Hooks.

**U-3 T-3-OWNER-MELDUNG axis_cross_product (Faelligkeit: F2-Vorlagen-Fenster, mit der Landung vor
Fr 21.08.; Traeger NEU: Kenntnisnahme-Zeile im F2-Vorlagen-Dokument neben P2-P7, Muster der
OV-5b/OV-4-Meldungszeilen -> 22.3).** Bewusste, nie gemeldete Namens-Abweichung axis_cross_product
statt verbund_union (0 Konsumenten; Ein-Zeilen-Nachzug, falls der Owner verbund_union will). Der
FAKT steht im Regressionen-Register Abschnitt 11 (Z.488); die MELDUNGS-Handlung steht in KEINER
Owner-Liste (weder Board-Zeile 'OFFEN BEIM OWNER' noch par.21.6-Fenster P1-P7 noch 13.3).

**U-4 K16-STOPP-BAUSTEIN -> SESSION-VORLAGE B.0 (Faelligkeit: W2-docs-Zug nach den Landungen;
Traeger NEU: benannter Punkt der 12.4-Docs-/Memory-Zug-Liste, buendelbar mit den
K15-Memory-Neuzugaengen 22.2 T-14).** Audit-H4-OFFEN-Teil (Transkript Z70284): der
K16-Stopp-Baustein (Schreiberwechsel-Protokoll) fehlt in der Session-Vorlage B.0; 0 Treffer in
Board, par.18-21 und Register 12.4+13 (weder 'Stopp-Baustein' noch 'Session-Vorlage'/'B.0').

**U-5 WERKZEUG-WUNSCH JOURNAL-AGENT-LABELS (Faelligkeit: nach Abgabe / W7, unverbindlich;
Traeger NEU: 22.5 C-1, Kategorie C -- nur per Owner-Satz).** Das Workflow-Journal traegt keine
Agent-Labels (nur v2:-Step-Key-Hashes; meta.json nur agentType/spawnDepth) -- Label-Feld fuer
kuenftige Forensik (nachverify-r4, forensik.journal.luecken[3] = Transkript-Kandidat 194).
Objektiv-nach-Abgabe-Klasse; in keiner der drei Quellen.

## 22.2 TEIL-GETRAGENE POSTEN (19) -- JE MIT DEM FEHLENDEN STUECK + NACHZUG

**T-1 KON119-MASCHINENLESBARKEITS-AUFLAGE (KON119/A11):** A2.5-Bilanz aus den maschinenlesbaren
Quittungslisten zitieren (fixstrecke1-ergebnis-wiq9ihup1.json + a25-runde2-ergebnis.json), nie aus
Prosa-Summen. GETRAGEN: der KON119-Zug selbst (par.21.1 Schritt 5 + 13.8 A4). FEHLT: die
Maschinenlesbarkeits-Auflage nennt keine der drei Quellen -- Verlustrisiko beim KON119-Schreiben.
NACHZUG: in die L4-/KON119-Checkliste (Task-#15-Lande-Notiz), zusammen mit F4-/F-A-/T-A (13.8 A4).

**T-2 S-17/B5-TRAEGER FUER CEB-LAGER-REGISTRY-HASH-MAP (KON64):** haengt am C-3a/F4-Entscheid
(P4). GETRAGEN: der F4/18.6(3)-Fallweg (#38a2 + 13.8 A4). FEHLT: die Traeger-BENENNUNG des
KON64-Postens steht nirgends. NACHZUG: beim P4-Ruecklauf bzw. Di-25.-Schnitt in #24/B5 oder #57
einbuchen; im Freeze-Check als deklarierten Rest fuehren (22.4 Z-13).

**T-3 NP-24-BAUPUNKT (lazy_csv_header-Folgehaelfte nach NP-23):** GETRAGEN: NP-23 GEBAUT mit Zahl
7 (13.8 A8; Voll-CSV 25->32 Spalten, Commit 78cc75e6). FEHLT: NP-24 ist nur 'benannt' -- kein
Board-Task, kein Slot. NACHZUG: W2-Task/Slot beim Di-25.-Schnitt anlegen (#96 namentlich,
22.4 Z-3).

**T-4 13.8-KLEINPOSTEN-TRIO A9/A10/A11:** (a) F7-Generator-out_path
system_axis_registry_gen/main.cpp:625 ('kleiner W2-Posten/Falle') + (b) PIC-Hausnorm
comdare_hdr_histogram_wrapper POSITION_INDEPENDENT_CODE ON ('W2-Mini-Posten', ersetzt den alten
clang-debug-Altbestands-Slot) + (c) optionale T-2-Haertung 2 static_asserts
anatomy_fingerprint.hpp:1207 ('W2-klein'). GETRAGEN: in 13.8 mit Platz benannt. FEHLT: das
#96-Mandat (par.21.4) deckt formal nur das WIEDERAUFNAHME-Register -- kein Board-/Di-25-Anker fuer
diese drei Regressionen-Register-Posten. NACHZUG: Di-25-Sammelzeile (22.4 Z-4); 13.7-K16 prueft
gegen.

**T-5 F8-super-STELLE Konformitaetsregister teil2:**
20260809-KONFORMITAETS-REGISTER-teil2-stationen-5-bis-8.md, S7-HY-A-PAKETE '(22->23)' + 'HY-A3
toter Kommentar' -- UEBERHOLT-Marker per KON118 faellig. GETRAGEN: die ce-Haelfte der
F8-Nachzuege ist in Fix-Strecke 2 behoben (15/15-Deckung). FEHLT: die super-Stelle lebt nur als
WF-Quittung VERTAGT 'Platz: Docs-Zug' -- die 12.4-Docs-Zug-Liste nennt sie nicht. NACHZUG: an
#85/super-Docs-Zug anhaengen (Muster der ce-Nachzuege 9378e463); L4-Umfeld oder W2-docs-Slot
(22.4 Z-12).

**T-6 prt-art-ROUNDTRIP-SHA-PIN (K7b-3):** build:registry-roundtrip nicht-deterministisch gegen
ungepinnten ce-Geschwister-Checkout (.gitlab-ci.yml:115). GETRAGEN: 12.4 wies die Task-ANLAGE der
Fix-Strecke 2 zu. FEHLT: die 15er-Eingangs-/Verify-Liste des WF trug prt-art NICHT und kein
Board-Task entstand (#100/#101 decken nur tools-3/M-5) -- die Anweisung ist DURCHGERUTSCHT.
NACHZUG: 13.7-Vollzaehligkeits-Gegenprobe dokumentieren + W2-Board-Task SOFORT anlegen,
spaetestens Di 25. (#96; 22.4 Z-2).

**T-7 X-12/V-02R-LAUFZEIT-BEFUELLUNG:** je Pruefdock-Tier-Binary EIGENER SHA-256 beim attach (Map
landet K-1-leer; B-8/A-12-Haelfte). GETRAGEN: die Messung (12.4 -> #93 Gruppe C). FEHLT: der
Folge-BAU-Task existiert nicht -- wartet deklariert auf den P4/P5-Owner-Entscheid. NACHZUG:
Task-Anlage beim Di-25.-Schnitt mit Vermerk 'nach P4/P5' (22.4 Z-5); die Hash-Laengen-Spannung
laeuft bereits als P5.

**T-8 HYBRID-STEMPEL-EXPORT ENDE-ZU-ENDE (HY-B-Folgezug):** Stempel-ABI-Symbol im
COMDARE_DEFINE_HYBRID_MODULE (heute 6 Symbole OHNE Stempel) + Emitter fuer
COMDARE_HYBRID_KOMPOSIT_GLIED mit echten anatomy_name_hex + stempel_binden je Dock +
rt_ct_invariante. GETRAGEN: die P5-Vorlage (Board-Owner-Zeile + par.21.4/#95). FEHLT:
par.21.3-HY-B deckt nur Mehrfach-Dock/Heuristik/Eviction -- der Stempel-Export-BAU hat keinen
Task. NACHZUG: eigener HY-B/W3-Task beim Di-25.-Schnitt (nach P5-Antwort + A-11-Pflicht aus #102;
22.4 Z-6).

**T-9 FB20-K-1 IM #24/B4-UMFELD:** beide Break-Even-Implementierungen ZUSAMMENFUEHREN,
Bereichs-Erkennung statt Hysterese (Owner-Wort); die Datenquellen-Luecke (CSV ohne
Checkpoint-Spalte) GETRENNT vorlegen. GETRAGEN: B4/System B voll (#24 + par.21.6 OV-2 + par.21.0
Beleg-Tafel (2)). FEHLT: Zusammenfuehrungs-Auflage und CSV-Spalten-Luecke stehen nicht namentlich
in den drei Quellen. NACHZUG: #24-B4-Text beim Di-25.-Schnitt nachschaerfen (22.4 Z-7); CSV-Luecke
als Vorlage-Punkt in die naechste Owner-Runde (22.3).

**T-10 g2-NEBENBEFUNDE FUER WARNUNGS-RUNDE 2:** gcc-Release-Warnung
axis_03a_search_algo_interpolation.hpp:256 (TU test_v41_topic_traversal) + clang-22-Warnung
vendored googletest gtest-printers.h:524 + 12 Non-ASCII-Altbestand axis_variant_version_table.hpp.
GETRAGEN: Wstringop-Verbleib (12.4 -> #93-A [K10-12]). FEHLT: die drei g2-Nebenbefunde nennt keine
Quelle. NACHZUG: namentlich in #93-A/W2-2 aufnehmen (Hausregel 2x gcc->clang; 22.4 Z-8).

**T-11 seg4-15 S-16-REGRESSIONS-MESSPUNKT:** ci/tests 13->14 Shell-Skripte
(guard_basis_bissprobe.sh, 8656 Zeilen); der Eindeutigkeits-Riegel ist weiter NUR Shell
(KON37-08). GETRAGEN: S-16/Test-Konsolidierung als Dauerposten (#28). FEHLT: der konkrete
Regressions-Befund ist nirgends verbucht. NACHZUG: als Messpunkt/Startzahl in den #28-W2-Slot
schreiben (Inventur-Beginn; 22.4 Z-9).

**T-12 D5-5 HDR-VERDRAHTUNG ALS BAU VOR DER KAMPAGNE (NP-43):** HDR-Header heute 0
Produktions-Konsumenten; Altzahlen-Markierung = Owner-Pflicht 17.08. GETRAGEN: die MESSUNG
(par.21.2 #93-Gruppe Statistik/Menge D4/D5/##10-19 + Frist-Dreiteilung). FEHLT: ein BAU-Traeger
mit Kampagnen-Frist (vor Sa 29.08.) existiert nicht -- kein Task, kein Korb-C-Punkt. NACHZUG: nach
#93-F-Ruecklauf beim Di-25.-Schnitt mit Frist vor 29.08. slotten (22.4 Z-10); den
L7-Thesis-Altzahlen-Posten (G-Tafel) daneben ausweisen.

**T-13 REGISTER-3b-HINWEIS-BUENDEL:** seg3-kon28-01 Ledger-Marker 'prod1=24 Worker' (par.69.6,
real 16 Kerne/32 Threads; runner-mode.sh-Haelfte bereits ERFUELLT) + SHA-Zuordnungs-Detail
9f8e2be8-vs-3ba0f7b3 (3 von 4 stimmen; seg3-kon8-11 in 13.1 entlastet) + super build:clang
Kill-Switch when:never/docs-only (D-2-Kandidat). GETRAGEN: nur Register Abschnitt 3b (Z.166-169)
mit 'W2-Triage'-Vermerk. FEHLT: ausserhalb der Traeger-Abschnitte 12.4+13; kein Task-/Di-25-Slot,
nicht in der 12.4-Docs-Zug-Liste. NACHZUG: die 3b-Zeile beim Di-25/#96 in den Docs-Zug
uebernehmen (Ledger-Marker + D-2-Entscheid; 22.4 Z-11).

**T-14 DOCS-/MEMORY-ZUG K15-NEUZUGAENGE:** gitlab.comdare.local-Host-Regel (.de =
404/JSONDecodeError-Falle) + Rot-Lauf-Logs-IMMER-persistieren-Pflicht + Transkript-Z45-signature-
Artefakt als bekannt vermerken (NICHT reparieren) + F5-Edit-Wortlaut-Gegenprobe (Objekt Z.70-78
sieht korrekt aus, nur die formale Gegenprobe ist offen) + Queue-Verfall-Lehre (nur via
13.6-Verweis auf Uebergabe Abschnitt 10). GETRAGEN: der Memory-/Fallen-Zug selbst (12.4 + 13.8
A16-A18, inkl. ccache-1837/tail-Fallen). FEHLT: diese K15-Neuzugaenge stehen dort nicht
namentlich. NACHZUG: beim Memory-Zug aus Uebergabe Abschnitt 10 + 13.6 ziehen und namentlich
abhaken (T-5/T-6-Zug); U-4 buendeln.

**T-15 PRE-PUSH-GATE-DOKTRIN-REST:** Memory-Eintrag zum Script (K3/H6 'Werkzeug schlaegt
Disziplin') + Regel 'Komplex-Fix-Stufe auch bei kleinen Wellen namentlich besetzen' (GOAL-IV.2).
GETRAGEN: die Mechanisierung ist GEBAUT (scripts/pre_push_lande_gates.sh seit G6; Lauf-Pflicht am
neuen Tip = 13.8 A13; Gate 4/6 blockt mechanisch). FEHLT: die Memory-/Doktrin-Haelfte nennt keine
Quelle namentlich. NACHZUG: in den Memory-Zug (Fallen-Register) + ARBEITSWEISE-/GOAL-Nachtrag beim
Docs-Zug.

**T-16 E3-FOLGEN + H2-AUFLAGE:** Beweisorte der Landungs-Doku auf gesicherte G6-/tmp-Logs
umschreiben ODER frische Vollaeufe je Baum; Abdeckungs-Wache kuenftig COMDARE_WACHE_STRIKT=1 +
Exit ins gesicherte Log. GETRAGEN: ctest --no-tests=error als Fallen-Klasse (12.2c ->
12.4-Memory-Zug). FEHLT: Beweisort-Umschrieb und WACHE_STRIKT-Doktrin stehen in keiner der drei
Quellen (H3 ja, H2 nein). NACHZUG: in die L1-Lande-Checkliste (Beweisorte) + Memory-Zug
(WACHE_STRIKT-Doktrin).

**T-17 FIX-STRECKE-2-RUECKKEHR: BU-NACHZUG DES NEUEN SCHNAPPSCHUSSES:** Output+Journal aus
~/backups-workflow/20260819-fixstrecke2-logs/ nach docs/sessions/backups/20260819-kontext14-
workflows/ mit NEUER Redaktions-Pruefung (K13-Regel: die Freigabe 18/18 deckt nur den ALTEN
Schnappschuss). GETRAGEN: Quittungs-Vollzaehligkeits-Check + Rekursions-Runde (13.7 K16-PFLICHT,
Resume wf_46805ad8). FEHLT: die BU-Nachzug-+Neu-Redaktions-Haelfte traegt nur die Uebergabe
8.2/11(4) -- keine der drei Quellen. NACHZUG: mit dem naechsten Folge-BU-Zug fahren (JB-2-Spiegel,
12.4-Docs-Zug) und dort als Zeile ergaenzen.

**T-18 SWEEP-ERGEBNIS LANDEN (DIESER NACHTRAG):** par.22 committen (Standard-Push-Sequenz) +
vorgeschlagene Tasks anlegen (22.4 = namentliche Di-25-Liste fuer #96; 22.5 = Nach-Abgabe nur per
Owner-Satz). GETRAGEN: bisher NUR durch den laufenden wf_d42115cb + Owner-Order 19.08. FEHLT: in
Wellenplan (endete bei par.21.6), Board und Register war bis zu diesem Commit NICHTS persistiert
-- stirbt der WF, war der Bericht der einzige Traeger. NACHZUG: dieser Abschnitt vollzieht die
Persistierung; die Task-Anlagen/-Updates laut 22.4 sind der zweite Teil (Anlage-Liste liegt der
Lead-Session vor).

**T-19 L21/F-9-SENTINEL + M-2-TSan-FENCE-NAHT: EINZELBELEG:** F-9-Sentinel
(hybrid_dock_array.hpp:206-219) + M-2-fence-Naht brauchen den expliziten Einzel-BEHOBEN/VERTAGT-
Beleg der Fix-Strecke 2. GETRAGEN: Eingangs-Deckung 15/15 bestaetigt (13.8 Commit-Tafel) + G-Tafel
L21 (Triage-Erstposten) + M-2 via #103. FEHLT: weder 13.8 noch 12.4 nennen F-9 im ERGEBNIS
namentlich -- ohne Einzelbeleg droht die dritte stille Weiterreichung (A6-Warnung: nicht
glattrechnen). NACHZUG: im 13.7-K16-Check gegen fixr1_endquittung_fixstrecke2_vollstaendig.md
konkret nachschlagen; falls VERTAGT: HY-B-Task beim Di-25. anlegen (22.4 Z-15).

## 22.3 OWNER-FENSTER-STAND (P1-P7 + L-A..L-D + Einzelposten; Stand 19.08. abends)

> EINPLANUNGS-MARKER 23.08.2026 (par.24): Stand 19.08. TEIL-UEBERHOLT — (a) die P4/C-3a-Zeile ("Frist Mi
> 19.08. verpasst -> F2-Fenster, 18.6(3)-Fallweg") ist durch KON120-06 ersetzt (Doppel-JA galt; E-10-Bauzug
> RN-03); (b) OV-1-Fork ist durch KON120-02 D-04-VOLLES-GO ersetzt; (c) alle weiter offenen Fenster-Posten
> fahren gesammelt im Owner-Vorlagen-Stau RN-05 (EINE Nachricht, F-01..F-19 + G-1-Rest + Altposten).

**F2-Vorlagenfenster P1-P7 (Ein-Satz-Vorlagen MIT der Landung, vor Fr 21.08.; par.21.6 +
Board-Owner-Zeile; F-F/13.2: P2/P3 AM ORIGINAL bauen):**

    P1  AxisKind-Ordnung im Bruch mitdrehen? (seg1-37; KON5-04: immer Owner-VORLAGE)
    P2  E-6-Satz: "22->23 war Phantom-Nenner, kGenusBuildSlotCounts 5->6 ist gebaut --
        Einspruch?" (KON118)
    P3  KON60-04-Spannung S-6 (stale, blockiert nicht)
    P4  C-3a-Frist (Mi 19.08.) -- 18.6(3)-Fallweg DEKLARIERT (#38a2; KON119-Pflicht T-A
        Ledger-Buchung, 13.8 A4); EINZIGE offene Owner-FRAGE; S-17/B5-Traeger-Benennung
        haengt daran (22.2 T-2)
    P5  V-08R-Form 64-Hex vs 128-Hex-S-1-Vertrag (#95 gebaut @ 0f0742aa, L3-Auflage 13.5);
        V-02R-Bau (22.2 T-7) und HY-B-Stempel-Export (22.2 T-8) warten auf die Antwort
    P6  golden-Nachposten-Satz seg1-44 + Owner-Saetze fuer objektiv-nach-Abgabe (Kategorie C)
    P7  NP-02 (axis_category_of = Andockpunkt, 13.8 A19)
    NEU in dieses Fenster (aus diesem Sweep): T-3-Kenntnisnahme-Zeile
        axis_cross_product/verbund_union (22.1 U-3; Muster OV-5b/OV-4) | CSV-Checkpoint-
        Spalten-Luecke GETRENNT vorlegen (22.2 T-9)

**Liegengebliebene Owner-Posten L-A..L-D (Register 13.3; Volltext Uebergabe Abschnitt 9):**

    L-A OF-4-PAT-Kette A1->A2->A3 (completed-#54: id=54-Abloesung per Owner-Ein-Satz ->
        ROTATE_TOKEN @ 290 -> Schedule active=true)
    L-B V8 GitHub-PAT-Rotation (Credential-Store-Fund, #61)
    L-C V9 rescue-Ref w3-thesis-c (95 Alt-Trailer) -- an den E12-Owner-Entscheid gekoppelt
    L-D node6 Remote-Login / id56-Herkunft / id18-Duplikat (#60)

**Einzelposten (Board-Owner-Zeile + 13.4):** C-3a (= P4) | Infra-Termin/Wartungsfenster (#84:
Meldung LIEGT, Owner traegt sie an Infra; dazu INF-03 allow_runner_registration_token weiter True
+ INF-05 Rotationsliste ohne samba, beide Infra-Fenster) | E12+V9-Thesis (L-C-Kopplung) | Z-21
Mirrors owner-gated (13.4) | NEU: Betriebs-Punkt PLATTEN-RAEUMUNG prod1 (22.1 U-2, root noetig;
ins Infra-Fenster Do 20.08. abends packen).

## 22.4 DI-25.-SCHNITT-ZUGAENGE (namentliche Liste fuer #96; JEDE Zeile wird abgehakt)

> EINPLANUNGS-MARKER 23.08.2026 (par.24): diese Z-Liste wird durch par.24.3.1 FORTGESCHRIEBEN — die 94
> Soll-Ist-Posten (wellenplan-soll-ist.md Tafeln 3-7) treten als namentliche Erweiterung dem #96-Schnitt
> bei (RN-26); dazu die 24.3.2-Zugaenge (15 Ex-Traegerlose, 34er-Neubewertung). JEDE Zeile wird abgehakt —
> Abhak-Instanz #96 + EINPLANUNGS-REGISTER.

Bereits gebucht beim Schnitt (Bestand, zaehlt weiter): die 12.4-Zugaenge (B-8/X-13 |
VL-6b/X-15+[K6-6] | S-8-Methodik-Override/[K12-2] | Peer-Session-Triage/X-14 |
L20-golden-Ref-Ausbuchung/X-1 | Nested-Worktree-Triage/X-11) + G-Tafel MIT (L1-L23; L19 zaehlt
#3/S-12 + #19/main-FF ZWINGEND) + F-C-Gegenzaehlung (B-8 + VL-5/VL-6-Doku namentlich).
NEU AUS DIESEM SWEEP (Z-1..Z-15):

    Z-1  s13-J-1-Rezeptfix als ROT-Vorbedingung VOR #18 (22.1 U-1; der Fix selbst laeuft FRUEHER
         im docs-Zug -- Di-25 prueft nur, dass er drin ist)
    Z-2  prt-art-Roundtrip-SHA-Pin-Task (22.2 T-6; Anlage SOFORT, Di-25 = Kontrolle)
    Z-3  NP-24-Slot (22.2 T-3)
    Z-4  W2-Miniposten-Trio 13.8 A9/A10/A11 als Sammelzeile (22.2 T-4)
    Z-5  V-02R-Bau-Task mit Vermerk "nach P4/P5" (22.2 T-7)
    Z-6  HY-B-Stempel-Export-Task W3, "nach P5 + A-11/#102" (22.2 T-8)
    Z-7  #24/B4-Text-Nachschaerfung FB20-K-1 (22.2 T-9)
    Z-8  g2-Nebenbefunde namentlich in #93-A/W2-2 (22.2 T-10)
    Z-9  seg4-15-Messpunkt als #28-Inventur-Startzahl (22.2 T-11)
    Z-10 D5-5-HDR-Verdrahtungs-BAU, Frist vor Sa 29.08. (22.2 T-12; nach #93-F-Ruecklauf)
    Z-11 Register-3b-HINWEIS-Buendel in den Docs-Zug (22.2 T-13; Ledger-Marker prod1=24 +
         D-2-Entscheid)
    Z-12 F8-super-Stelle an #85/super-Docs-Zug (22.2 T-5)
    Z-13 S-17/B5-Traeger-Benennung KON64 nach P4-Ruecklauf (22.2 T-2)
    Z-14 Betriebszeile Platten-Raeumung prod1 (22.1 U-2; root/Owner)
    Z-15 L21/F-9-Sentinel + M-2-Einzelbeleg-Nachschlag; falls VERTAGT -> HY-B-Task (22.2 T-19)

## 22.5 NACH-ABGABE-KANDIDATEN NUR MIT OWNER-SATZ (Kategorie C)

    C-1 Workflow-Journal-AGENT-LABELS: journal.jsonl traegt keine Agent-Labels (nur v2:-Step-Key-
        Hashes; meta.json nur agentType/spawnDepth) -- Label-Feld fuer kuenftige Forensik
        (Orchestrator-/Workflow-Tooling; 22.1 U-5, nachverify-r4). W7/unverbindlich; Aktivierung
        NUR per Owner-Satz (vereinbar mit par.21.0: W7 nur per Owner-Entscheid).

Bestandstafel UNVERAENDERT: par.21.6 (OV-4 | OV-5b | OV-14 | W7/#88) + par.21.3-Kategorie-C-Regel.
Dieser Sweep fuegt KEINEN weiteren Nach-Abgabe-Posten hinzu -- alle uebrigen 119 der 120 Posten
haben einen Vor-Abgabe-Platz.

**VOLLZUG DIESES NACHTRAGS (= 22.2 T-18, erster Teil hiermit):** par.22 committen
(Standard-Push-Sequenz, docs-Zug) + Task-Anlagen/-Updates laut 22.4; #96 zaehlt 22.4 namentlich
gegen; die 13.7-K16-Pflicht prueft WF-Quittungen kuenftig AUCH gegen diesen Abschnitt. Stirbt ein
Traeger-WF, ist par.22 der persistente Traeger -- kein Bericht-only-Zustand mehr.

---

# 23. KONSOLIDIERUNG K15-SCHLUSS (19.08.2026 spaet) -- #93-BEFUNDLAGE AM OBJEKT,
# LANDE-STAND, DIE OFFENE F2-LISTE (Owner-Order: offene Liste + alle vergessenen
# Aufgaben des gesamten Kontextes in den Wellenplan)

> par.22 bleibt stehen (Traeger-Abgleich 195->120); DIESER Abschnitt traegt die JUENGEREN
> Objekt-Befunde des #93-W1-Audits (7/8 Gruppen komplett gelesen; Gruppe F + Synthese im
> Resume wf_ca507b8f) + den Lande-Stand nach der #17/g2-Landung. Bei Widerspruch: dieser
> Abschnitt vor par.22 vor par.21. Quellen: w93-teilstand-widkey76e.json (B.3-gesichert),
> g2-formatfix-landung-endergebnis-wx001l49o.json, Register 13/13.8.

## 23.0 STAND-ANKER (19.08. ~20:05)

> EINPLANUNGS-MARKER 23.08.2026 (par.24): dieser Stand-Anker ist HISTORIE — #15 ist GELANDET (Kette
> 196a621a->66de5c09, CI 16042-16052; KON119), die 10 ce-Lande-Merges des W2-Zugs sind durch (dev
> 1f0424a2 -> db66714a, CI 16097 SUCCESS), #7/S-19-Freigabe ist WIRKSAM (P3-Neuterminierung s. Marker
> 18.4 + RN-06/RN-10). Lebender Stand: par.24.0.

    GELANDET:   #17/g2 = dev ba33b9ac (Merge von 6af6a415, dual gepusht; Baum-CI 16029
                SUCCESS 27 Jobs; dev-CI 16031 running mit 0 roten Jobs, Poller laeuft;
                W1-V1-Buchung folgt mit Terminal-SUCCESS). Stempel-Strecke damit bis auf
                #15-Landung geschlossen; #7/S-19-Freigabe wird mit #15-Landung wirksam.
    FIX-KOMPLETT UNGELANDET: #15-Bruch @ 79171599 (= Abnahme-Endtip 8cd32a0d + #100/#101);
                Fix-Strecke 2 NULL_NEUE_FUNDE; VOLL-ABNAHME 4 Zellen @ 79171599 LAEUFT
                (Owner-Eskalation 19.08.: 'VOLLSTAENDIGE Abnahme, auch wenn sie die
                deadline reisst' -- Memory-Dauerregel, Kurznachweise nie wieder Default).
    PARALLEL:   g2-Rest-Zellen-Vollabnahme am formatierten Tip laeuft (T-11b buchstaeblich
                am Tip; dev-CI liefert die CI-4-Zellen zusaetzlich).

## 23.1 DIE OFFENE F2-LISTE (aus #93 B-H am Objekt; je Posten: BAUEN bis Fr / FALL
## DEKLARIEREN mit Zahl / OWNER-FENSTER — NIE-KUERZEN: jeder Posten behaelt den Platz)

> EINPLANUNGS-MARKER 23.08.2026 (par.24): "bis Fr (21.08.)" ist verstrichen; der Freeze-Check wurde per
> #108 vollzogen. Jeder F2-1..F2-8-Posten traegt seinen NEUEN Termin in par.24.1: F2-1/B1 -> RN-13-Umfeld/
> #24 (W2-Anfang vor Trigger) · F2-2/F2-3 -> mit #15-Nachlande GELANDET (c2da9d1a; Einzelbeleg-Kontrolle
> RN-17) · F2-4/B5 -> #24-B5-Vorposten (RN-13/RN-25-Umfeld, KON64-Anteil nach Doppel-JA klar) · F2-5-Rest
> -> RN-31 (LG-XlsxAlt/LG-SkipCallback + 6+2-Posten) · F2-6 -> RN-31 · F2-7 -> RN-31-Deklaration ·
> F2-8/N-1+N-2 -> mit Nachlande GELANDET (Kontrolle RN-17).

    F2-1  B1 XML-Konsum je Stufe (Registry-NEUBAU <measurement_tooling> + Stufen-Dimension):
          NICHT GEBAUT (Objekt: Registry ohne Stufen-Dimension, XSD:88 ohne, 0 Commits
          beide Baeume). Freeze-Check-Element (P). Fallweg 18.6(4) EXISTIERT (B1 -> W2-
          Anfang vor Trigger) aber NICHT deklariert. ENTSCHEID: Registry-Neubau bis Fr ist
          unrealistisch neben den Landungen -> 18.6(4)-FALL JETZT DEKLARIEREN (Zahl im
          Protokoll; Freeze-Check bucht) + W2-Anfang-Slot VOR Trigger Mi 26. [Traeger #24]
    F2-2  CEB-STEMPEL system_zeile-Fuellung (KON8-03): bewusst leer in dev UND Bruch,
          Bauplan-B-6 sah Fuellung vor, KEINE Fall-Deklaration. Freeze-Check-Element.
          ENTSCEID: in den #15-NACHLANDESCHRITT aufnehmen (klein, KON8-03-Bauauftrag ist
          praezise) ODER 18.6-Fall deklarieren. [#15-Lande-Notiz + Freeze-Check]
    F2-3  S-5-ERBINNEN-REST: Tier-/HybridStempel-Erbinnen nach P4/P5-Muster = 0 Treffer in
          beiden Baeumen (Komposita-Traeger liegen im Bruch); B-8b/B5 haengen daran.
          ENTSCHEID: mit F2-2 buendeln (ein kleiner Stempel-Nachlande-Zug nach der
          #15-Landung, VOR Freeze-Check) ODER Fall deklarieren. [B-6-Rest]
    F2-4  B5 Stempel-Pflicht je Schalter: haengt an F2-3 + B5-VORPOSTEN aus B3-Spez-
          Abweichung (wallclock@Version als CEB-Glied, Zwillings-Wache); (P) ohne
          Owner-Datum. Kein Fall deklariert. -> Fall-Deklaration mit F2-3-Kopplung; der
          KON64-B5-Anteil haengt an P4. [#24/B5]
    F2-5  ACHT BAND-A-TESTPOSTEN Designplan par.4-W1 ungebaut (Objekt-Messung je 0 Treffer):
          PK-KlemmJson n-Spalten · HY-Ebene4a Label+Datensatz (4.-Ebenen-Entscheid war fuer
          Mi 19. terminiert!) · LG-HostBinder 3 Felder · LG-SkipCallback==0 (WOERTLICHES
          F2-Abnahmekriterium!) · LG-E2Exlsx Facade · LG-XlsxAlt nie vernichten (NIE-fallen-
          Klasse!) · PM-Naht perm_runner->CSV · XL-L4 n/a-Konkurrenz. Dazu 2 UNKLAR:
          LG-LoadWache beide-Genera-Beleg + LG-Idempotenz 2x3-Matrix.
          ENTSCHEID: die 2 NIE-fallen-nahen (LG-XlsxAlt + LG-SkipCallback) bis Fr BAUEN
          (klein, Test-only); die uebrigen 6+2 als deklarierten 18.6-Fall in die
          W2-Randslots (Zahl: 8 Posten ~33h) -- Feinplatzierung Di 25. [#96 zaehlt gegen]
    F2-6  UMBENENNUNGS-REST: E-Label (KON37-05) + Flag-f-Kollision FPGA/AVX-512 = 0
          Objekt-Treffer, nicht im Bauplan -> platzieren (W2-Slot) oder deklarieren.
    F2-7  SOLL-VERSIONIERUNGS-REST: Genus-CT-Komposition ungebaut (algo_semver.hpp:290-298)
          + Planer-SHA owner-gated P5 (#95 gebaut @ 0f0742aa, Form-Frage offen) ->
          Teilstueck-Deklaration im Freeze-Check; P5 im Vorlagen-Fenster.
    F2-8  N-1 (S-6c Zwei-Welten-Wache) + N-2 (S-6d-Rest, real 23 Familien-Dateien statt
          '142') = deklarierte Nachlaeufe NACH der #15-Landung, VOR Freeze-Check faellig
          (Bauplan par.6). [#15-Nachlandeschritt]

## 23.2 FREEZE-CHECK-DEKLARATIONS-TAFEL (Fr 21.08. — damit NICHTS als Falsch-Rot faellt)

    DEKLARIERT-W2 (Quelle je Posten gemessen): A8/A12 clang-Warnungs-Review (P.20.9+F-D;
    Quellen-Differenz W2-1 vs W2-2/#3 MITFUEHREN) · A9/A11/A13 --debug-Matrix+N5 (M-5-
    Buendel W2-1) · #38a2/P4 = 18.6(3) DEKLARIERT (KON119-T-A-Buchung PFLICHT) · D-2-Band-B
    22 Posten (par.21.3-Platzierung) · B4/OF-1 (W2-Tabelle) · S-2/G-1 (benannte Leerstelle,
    Owner-Fragen 9/12 offen — NICHT Freeze-pflichtig) · Wstringop (Di-25-Feinplatzierung).
    ENTLASTET AM OBJEKT: A10 Windows-_pclose (statischer Blick 19.08.: _pclose liefert auf
    Windows direkt den Exit-Code -> l.rc=status KORREKT; POSIX-Zweig sauber; P.20.2(c)-
    Pflicht vollzogen, KEIN Fix noetig). GEBAUT_UNGELANDET (landet mit #15): S-6a-d ·
    HY-A2/A3 + P.20.10-Abnahmeformel (fahrbar dokumentiert, 4/6/5/1/32-Pins in 3 Logs) ·
    B3 (Spez-Abweichung deklariert) · #38d (Budget 8192 GERECHNET, Summe 6057) ·
    ABI-Pflicht 6 Symbole (V-06 Lesart A; Emitter-Haelfte = golden-Folgezug #102) ·
    A-06/A-08/A-09-Umbenennungen. ERFUELLT: S-1 S-3 S-7 B2 HY-A1 SOLL-Vers.-Kern
    MT-L3 PK-Kanon/Kreuz/DeleteP99 ST-Trio(5) HY-Reroute LG-WritebackXlsx XL-L2.

> EINPLANUNGS-MARKER 23.08.2026 (par.24): *(zur Zeile "#38a2/P4 = 18.6(3) DEKLARIERT")* dieses Deklarat
> ist UEBERHOLT (KON120-06: Doppel-JA uebersehen; KON119-T-A-Buchung redaktionell korrigiert). #38a2
> faehrt als E-10-BAUZUG (mit #86-Schritten 1-4) VOR Mi 26. 06:00 — RN-03/RN-11; die GEBAUT_UNGELANDET-
> Posten dieser Tafel sind mit #15 GELANDET (KON119).

## 23.3 LANDE-NACHLAEUFE (aus dem g2-Lande-Verify R1-R6 + Verify-Bestand)

    L-N1  CI-TERMINAL: 16029 SUCCESS (bewiesen 20:04); 16031 running 0 rot -> Poller
          b1uvq3cwn; nach SUCCESS: W1-V1-Buchung (Task #17 completed + Ledger) +
          clang:debug-N literal + coverage-guard-Quittung. [R1/R3/R6]
    L-N2  wt-ce-g2-Loeschung NUR nach Doktrin (gruen+gemergt+Submodul-Branch-Check),
          eigener Schritt NACH L-N1; build-g2 ENTFAELLT als Lande-Referenz erst danach.
    L-N3  Platte VOR dem naechsten grossen Vollbau raeumen (97%/8.6G zum Verify-Zeitpunkt;
          Voll-Abnahmen raeumen je Zelle selbst); root-Anteil = par.22-Owner-Punkt. [R4]
    L-N4  Sequentialitaets-Befund (Push waehrend 16029 running; Runner-Queue
          sequentialisierte faktisch) -> Ledger-Notiz im KON119-Umfeld. [R5]
    L-N5  bump15-Lande-Vorbehalte UNVERAENDERT: T-B Lock-Erst-Versionen (Lande-Schritt 3)
          + T-C 4 XML-Wohlform-Vorbestandsfehler + pre_push_lande_gates am 79171599
          (laeuft in der Voll-Abnahme mit) + F-A-Komplex-Fix-Deklaration + KON119-Pflichten
          (13.8 A4: T-A C-3a-Buchung, A2.5-Bilanz maschinenlesbar, B3-Spez-Vermerk,
          Sequentialitaet, Vertagten-Bilanz).

## 23.4 VERGESSENS-SCHUTZ-BILANZ K15 (was dieser Kontext an Traegern erzeugt hat)

    Register 13/13.8 (0962be43/e320beb4) · Uebergabe 0-11 (98520201) · par.22 (6104e897) ·
    DIESER par.23 · Tasks NEU #102(F6, Do 20.!) #103(TSan) #104(prt-art-Pin) #105(Sammel)
    · ROT-Auflage in #18 (s13:1384) · Memory NEU: Vertagt-Zwischenzustand + Vollstaendig-
    keits-Verschaerfung + comdare_gen_golden_fullpilot-Fix · completed #100/#101.
    K16-EINLESE-PFLICHT: Register VOLL (inkl. 13) + Uebergabe 0-11 + par.21-23 + #93-
    Synthese (nach Resume) + die 4 /goal-Dokumente (Kippen-Ritual, Sonnet-5-max-Analyse).

## 23.5 K16-NEUGRUENDUNGS-ANALYSE (19.08. spaet, wf_a1d3fafe: 8 Sonnet-max-Transkript-Leser
## K11-K15 + Traeger-Abgleich + Fable-max-Synthese; Owner-Order 19.08. vollzogen)

> Quittungen: 8/8 Fenster LUECKENLOS (8249/8249 Zeilen, Z.63511-71759, je N/N; 390 Owner-
> Texte ueber die DREI Extraktions-Pfade), Abgleich 137 Posten gegen T1-T6, 0 Ausfaelle.
> B.3: ~/backups-workflow/20260819-neugruendung-k16/ (Endergebnis + Journal + 8 Fenster-
> Berichte + abgleich-k16.md + neugruendungs-karte-k16.md). Verortung: Kette K1-K11
> BESTAETIGT, 13/13 Stichproben-Gegenlesungen trafen.

**23.5.1 ECHTE LUECKEN — HIERMIT GETRAGEN (12 geprueft, 2 nach Objekt-Gegenpruefung
korrigiert):**
    L10 (DRINGENDST, Vorposten am K6/L4-Zug): seg4-58 snmalloc -Werror=pedantic blockt
        comdare_tests im super-Vollbau (37 Not Run, Eichlinie blind) — beheben ODER
        deklarieren VOR dem super-Lande-Vollbau; sonst #96/Di-25.
    L7  Talos-Kernel-Fixes namentlich: perf_event_paranoid 3->0/1 + nmi_watchdog 1->0 —
        in Task #87 ergaenzt + Agenda-Punkt Infra-Fenster Do 20.08. abends (mit U-2).
    L1+L4 KON106 (a290dbaa) + KON109 (892e33aa) ohne CI-SUCCESS-Beleg — EIN API-Probe-Zug
        im KON119-Umfeld (K6) bzw. K11-Docs-Zug.
    L2  KOEDER_RC=124 der 4. RCU-Endabnahme (Z64387) unerklaert (124=timeout-Signatur) —
        K11-Fallen-/Memory-Zug (RC-Semantik je Koeder-Wrapper). Kein Lande-Blocker.
    L3  PRAEZISIERT AM OBJEKT (19.08.): der stale i9-14900KS/raptor-Kommentar
        machine_simd_signature.hpp:91 ist im BRUCH BEREITS GEHEILT (NP-11-KORREKTUR
        765ee421, landet mit K3); dev 33 RaptorLake-Treffer/7 Dateien -> nach K3-Landung
        bleiben GENAU 2 Kommentar-Treffer experiment_plan_director.hpp:752 = Mini-Posten
        Di-25-Sammelzeile (22.4-Z-4-Muster).
    L5  ENTLASTET AM ORIGINAL: s13-Kurz-Verify-Verdikt LIEGT (par.20.9 T-NEU-1 Z.2836-2840:
        wf_0e1f240b TRAEGT_MIT_FIXES, Gate KON100-02 ERFUELLT; der Abgleich las par.20
        nicht). Lebender Rest: die 2 Ein-Zeilen-KANN-Edits als Di-25-Auflage — an Task #18
        als zweite Auflagen-Zeile angehaengt.
    L6  wf_e13d73bf (namenloser W0a-Agent 10.08., T-NEU-3) — Drei-Pfade-Extraktor-Kleinlauf
        im K11-Docs-Zug, Ergebnis als Register-Fussnote. Niedrig.
    L8  Hybrid-Parser fail-closed OHNE fehlerklasse=-Traeger (K12-Teammate-Audit) — an
        T-13/T-14-Fehlerklassen-Posten angedockt (par.21.3 ##40-Restbau, C-12-PFLICHT vor
        Sa 29.08.); #96 zaehlt gegen.
    L9  'N8' nirgends definiert (nur K12-Abschlusstabelle 'N8 erledigt'; N-Posten enden
        bei N-7) — K11-Docs-Zug: Gegenstand im K12-Rohtranskript nachschlagen, Fussnote.
    L11 Owner-Rueckfrage Kipp-Kartierer-Konstruktion — explizite Antwort-Zeile im
        F2-Vorlagen-Fenster (K8; Antwort: Kippen macht der Lead SELBST, Agenten liefern
        nur Karte/Abgleich — seit K15 so vollzogen).
    L12 HERABGESTUFT nach Gegenlesen: #93-Erstlauf-Verdacht (0872967d) materiell
        entschaerft (finale Synthese lief als Resume NACH ba33b9ac; 9.4 frisch gemessen);
        Ein-Satz-Fussnote im KON119-Zug (Erstlauf-Teilbefund S-2/G-1 war gegen 0872967d).

**23.5.2 ABWEICHUNGS-KLARSTELLUNGEN (A1-A8, Kurzform; Volltext B.3):** A1 Zitierpraezision
par.22.3/23.3 = WELLENPLAN (nicht Uebergabe) · A2 taskboard_kompakt_k15.txt endet bei #101
— fuer #102-#105 NIE den Snapshot zitieren, Live-Board/par.23.4 · A3 EINLESE-REGEL: Register
Abschnitt 9 VOR Uebergabe-Abschnitt 2 (dort '16031 RUNNING' bereits ueberholt) · A4 clang-
debug-ROT GEHEILT (Mischbau-Wurzel; Rest = PIC-Hausnorm T-4) · A5 HY-A2/A3 + g2 in aelteren
Fenstern als offen gefuehrt = Historie, Abgleich korrekt · A6 ZWEI Zaehlbasen (688/85-roh-89
vs. 107 offene) — bei Zitat Basis mitnennen · A7 #102 faehrt VOR K3, Lock-Regen bleibt
Lande-Schritt 3 · A8 Task-Board ist im Landefenster kein Fortschritts-Signal (0 Status-
wechsel an 99 Alt-Tasks trotz massiver Arbeit) — Fortschritt lebt in Register-/Uebergabe-
Commits.

**23.5.3 VL12-UNTERSUCHUNG + VL-FAMILIEN-VOLLZAEHLIGKEIT (Owner-Zweifel 19.08. 'vl12 ist
nicht stale' — BESTAETIGT; wf_d9d83069, B.3: 20260819-w93-endstand/vl12-untersuchung-*.json):**
    BEFUND: wt-ce-vl12 = bau/vl12-s6b-pod-vorstufe @ cd011e60, 5 Commits = Bauplan-Schritte
    VL-1 (S-6b-Transpositions-Sperre: OrganZeile/SystemZeile/MessZeile benannte Traeger,
    CT-Negativ-Probe) + VL-2 (laute POD-Vorstufe: designierte Initialisierer + Feldzahl-
    Wache; K9-5-Zaehl-Sonde AnyFeld/FeldSonde) — die VORLEISTUNG, auf der B-5 des #15-Bruchs
    aufsetzt. NIE substanz-stale: KOMPLETT GELANDET (Merge be724cb5, Ancestor von ba33b9ac,
    Kombibau 4x499 + CI), porcelain 0, stash 0, alle 6 Lens-Funde eingeloest (F4-IWYU-Vollzug
    im bump15 decl.hpp:24/:342); 'stale' traf NUR build-vl12 (693M, Belegpruefung 0 getrackt/
    0 csv-xlsx = als Build raeumbar). VL-FAMILIE 8/8 GETRAGEN: VL-1/2 gelandet+bump15-Fort-
    schreibung · VL-3 gelandet+#101 · VL-4 Owner-beantwortet (V-09R), Code=765ee421 landet
    mit #15 · VL-5(a)-(e) VOLLZOGEN (KON100-04; Di-25-Gegenzaehlung steht) · VL-6a-Rest=N-2/
    F2-8 (#15-Nachlandeschritt, VOR Freeze-Check!) · VL-6b=Di-25-Liste · VL-6c bestaetigt+
    bump15 (f4e88786/4cb16334). KEIN neuer Task noetig — einziger docs-Kleinposten: F4b-
    Formabweichung als 'am Objekt getilgt' vermerken (HIERMIT vollzogen). Worktree nach
    Doktrin AUFRAEUMBAR (alle Bedingungen gemessen; kein Remote-Branch mehr, Submodul
    uninitialisiert) — Abbau bleibt im Aufraeum-Block nach den Landungen.

---

# 24. EINPLANUNGS-NACHTRAG 23.08.2026 — ALLE OFFENEN PUNKTE DER REIHE NACH

Anlass: Owner-Order 23.08. verbatim: "es darf keine Posten geben, die zurueckgestellt
oder nicht bearbeitet werden. Alles muss gruendlich der Reihe nach abgearbeitet werden"
+ "alle 4 /goal Referenzdokumente einliest und gegen die eben neu erkannten fehlenden
Punkte den Wellenplan updated und alle offenen Punkte korrekt einplant."

Quellen (alle VOLL gelesen, Einlese-Protokoll B.3-N3 im Register): 4 Referenz-Leser-
Tafeln L-GOAL/L-WELLENPLAN/L-DESIGNPLAN/L-ARBEITSWEISE (~/backups-workflow/20260823-
wellenplan-update/) ueber GOAL-v8 816/816 Z. + diesen Wellenplan 3627/3627 Z. +
Designplan 714/714 Z. + ARBEITSWEISE 1264/1264 Z. · wellenplan-soll-ist.md 292/292 Z.
(P4, ~/backups-workflow/20260822-lande-zug/) · VOLLLISTE-features-aufgaben-k1-heute.md
448/448 Z. (P5, docs/sessions/backups/20260821-vollaudit-welle1-stand/) · SESSION
20260822-beide-leser-vollliste 279/279 Z. · DESIGN 20260822-h23-d08-91-86 509/509 Z.
· PROVENIENZ-BERICHT E-10 182/182 Z. (~/backups-workflow/20260822-e10-provenienz/).

GELTUNG: par.13-par.23 bleiben stehen; was hier steht, gilt vor. Bei Widerspruch:
Owner-Wort schlaegt alles, Neueres schlaegt Aelteres (18.1-Klassenregel, 21.0
NIE-AUSBUCHEN und #96-Mandat gelten unveraendert). NUMMERN-DEKLARATION: der in
par.22.4/H-14 als "par.24-Nachtrag" angekuendigte WORTFERTIGE OV-16/17-Buchungs-
Entwurf (d10-liegengebliebenes.md Abschn. 5, Lande-Zug) faehrt als **par.25** im
Di-25-docs-Zug — Nummer 24 ist hiermit durch den Einplanungs-Nachtrag belegt (V12:
vergebene Nummer -> naechste freie; keine Inhalts-Kollision, beide Gegenstaende leben).

Register-Spiegel mit Vollzaehligkeits-Gegenzaehlung:
~/backups-workflow/20260823-wellenplan-update/EINPLANUNGS-REGISTER.md

## 24.0 STAND-ANKER 23.08. (aus Berichten; je Zeile Quelle — V1: vor Verwendung messen)

    ce dev             = 1f0424a2 (f729b93a + W2-Lande-Merge 5ddda4e5, 10 ce-Merges
                         s19/messfenster/s8kopf/s13schema/pmcpaket/vollzug91/ph89/
                         trigfix/skip97/kampvor) -> 23.08. db66714a (CI-/Lint-Heilung);
                         Quelle: DESIGN-h23 N-H2. CI 16097 SUCCESS (Pause-Commit 38428099).
    Lande-Zug #131     = PAUSIERT 23.08. 13:40 (Owner-Anhalte-Order) mit Resume-Rezepten;
                         offen: super-/prt-art-/Gitlink-Phasen + KON122 + #19 main-FF.
    Owner-Pause        = Owner-Order 09:33/13:40; Wiederanlauf gemaess Resume-Rezepten
                         (Commit 38428099); VERTAGT bleibt Zwischenzustand (Order 19.08.).
    F2-Freeze-Check    = vollzogen per #108 (vorlagen-fenster 3e9ec644/8aae5cd2);
                         Deklarations-Tafel 23.2 gilt mit den par.24-Korrekturen (P1).

## 24.1 DER-REIHE-NACH-GESAMTORDNUNG (RN-01..RN-92; Owner-Order: nichts zurueckgestellt)

Form je Zeile: RN-Nr | Posten/Kennungen | Traeger | Abhaengigkeit. Fenster-Etiketten
sind SPAETESTE Fristen (Owner 20.08.); Abarbeitung sequentiell in dieser Reihenfolge,
Parallelitaet nur wo owner-geordert (Lande-Zug, E-10-Bauzug "SOFORT", laufende Agenten).
Betriebs-Kollisionen: s. 24.5.

### FENSTER A — 23.08.-REST (nach Owner-Wiederanlauf; Lande-Bahn hat Vorrang)

    RN-01  Lande-Zug #131 RESUME + Rest-Phasen: super-Ziele s13schema-super 1e92b77e
           (H-6-Kopplung an ce-s13) · cidual 223ab518 · vorlagenfenster-Fix a6fa04da ·
           w1luecken-super 8edc34a0 · kampvor-super 025e0c42; prt-art: VOR Phase 3
           fetchen (Submodul stale), pinduo 25bbf2e, w1luecken-prtart 3710ac4c; o2/E-7-
           Landung VOR GN-9 (KON120-01-Auflage); Gitlink-Bump ATOMAR + PZW-Nachzug
           (Designplan 9.5-Anker wandern) + KON122 (E-6-Zeilen 1-6 FINAL, #112-Einspeise,
           T8b/T8c/T10b/T12b, B-01..B-20-Auswahl) + Remote-Divergenz-Triage origin 27 vs
           github 25 (P9, Phase-5-Auflage) + #19 main-FF beider Repos (Rest: F-13).
           Traeger #131/Lead. Auflagen T9/G8/H5/H-7/K17-Endstand-Kombibau/G2-V93/T12
           unveraendert. | Abh.: Landebahn exklusiv, nichts ueberholt.

> W2-ABSCHLUSS-MARKER 24.08.2026 (par.27): *(zur RN-01-Zeile oben)* die Klammer "T8b/T8c/
> T10b/T12b" ist STALE -- das sind Erst-Gate-Numerierungen (22.08.), von der S1/S2-Synthese-
> Zweitfassung (23.08., nach Compact-Riss neu erstellt) laengst zu L-08b/L-08c/L-09/T12b
> um-organisiert; die Zeile bleibt stehen (Ledger-Anker vor Nummer, V12), der KON122-Vollzug
> fuehrt beim Schreiben die AKTUELLEN L-/T-Anker (par.27.1.I/J unten in diesem Dokument, KEIN
> Neuschnitt). Ebenso praezisiert: "o2/E-7-Landung" ist TEILWEISE vollzogen (Lead-Rescue-
> Merge lokal b3dc3e93, NICHT gepusht, K17+Gates+gitleaks ausstehend) und "Gitlink-Bump ATOMAR"
> traegt zusaetzlich den NP-34-Patch (60fa5504) im selben Commit-Zug. Volltext + Abnahme-
> Kriterien je Sub-Ziel: par.27.1.G (CR-1..CR-12).

    RN-02  Diesen par.24-Nachtrag landen (Branch bau/wellenplan-offene-punkte; Lead
           landet sequentiell HINTER dem Zug; Ledger-Spiegelzeile via ledger_nachtrag.sh).
    RN-03  P1-BAUZUG STARTEN: E-10/#38a2 + #86/ORG-19 Schritte 1-4 in EINEM Zug
           (7-Schritte-Rezept b1-c3a Teil 6 + L1-U1-Form 18+1; Schritt 1 = XSD-/Registry-
           Grammatik-Slot [heilt das W5-Versaeumnis KON107-02/F5], Schritt 2 = erste
           required-Deklaration, Schritt 3 = Tripwire-Ersatz aggregate_required_for_axes,
           Schritt 4 = organ_stamp_line JE COMP [MemoryOnly verliert Disk-Suffix],
           Schritte 5-7 = Tests rot-zuerst + K17-Kombibau + Landung; Minor-Regel +
           Byte-Neutralitaets-Gegenprobe Nicht-IO). Design-Gate #133 ERFUELLT durch
           DESIGN-h23 (22.08., Teil A E-10 + Teil C). Eigener bau/-Branch; Landung
           hinter dem Zug, SPAETESTENS vor Mi 26. 06:00. KEINE Owner-Frage (Doppel-JA
           KON91-02+KON103-01, KON120-06). Traeger #120-B1 + #86 + #133. | Abh.: RN-01
           nur fuer die LANDUNG, Bau parallel frei (owner-geordert SOFORT).
    RN-04  P2-ENTSCHEID: D-08-Emitter-Weiche A/B, Default A — Owner-Vorlage liegt
           (p4-Strang); Entscheid-Zeile vor Mi 26. 06:00, 0 Bau-h; bei Ausbleiben gilt
           der deklarierte Default A (Vorlage-Text). Traeger #91/E-8/p4. | Abh.: keine.
    RN-05  OWNER-VORLAGEN-STAU als EINE Nachricht (H2-09-Minimalantwort): F-01, F-02/R7
           (Enum-Ordnung, VOR Mi 26 — Stempel-Bytes!), F-03..F-08, F-09 (S-19-Schema,
           vor Di-25-Schema-Schnitt), F-10 (Root-GO, ueberfaellig), F-11..F-15, F-16
           (Thesis 3/90), F-17, F-18 (D-08-ABI), F-19 (#91-E-Punkte), G-1-Rest (F-G1-8
           PMC dreiphasig, F-G1-9 Lastsequenz), PMC-Deckel L1D+dTLB (GOAL G-12, vor W3),
           SKIP-Kennungs-Frage prod1/prod2 (GOAL G-37), OV-17/O2-Nachreichung, PA-3/O3,
           OV-5b-Rueckhol-Satz (prod2 online), E12/L-C-Thesis-Trailer-Entscheid a/b
           (owner-gated; V9-Technik via RN-36), O-1-Bezeichnungssystem (ARBEITSWEISE T3),
           F2-Fenster-Reste 22.3 (P1..P7, OV-1 [D-04-GO ersetzt Fork], OV-4, OV-6,
           HY-Ebene4a, OF-1, NP-46/NP-48, K-16/P5-Hash-Form). Traeger Lead/p11. |
           Abh.: nach Lande-Bilanz (R-Tafel-V2 liegt).
    RN-06  P3-GLIED 2: GN-9-Kalibrierlauf ##47 in O2-Zielform (nach o2-Landung;
           variant-audit-a1-Ergebnis einarbeiten; R-19/4096-static_assert-Schranke).
           K-3-Kipp haelt: Di 25. abends Kalibrier gruen DURCH neue Kette. Traeger
           ##47/#7-Umfeld. | Abh.: RN-01 (o2), RN-05/F-09 fuer Schema-Zusaetze.
    RN-07  H-6-Kleinsthandgriffe: (a) Monitore bcqxqdilc/bc9dtvlef Stopp-Verifikation,
           (d) build-l4/-untracked im super pruefen/raeumen. Traeger Lead-klein.
    RN-08  AB-10 prt-art-Klon-Dreh (nach Lande-Phase 3). Traeger docs-klein.
    RN-09  W2-Wellen-Ende-Vollaudit-BU (H-16, Dauerregel 21.08.; nimmt AB-09
           fixstrecke2-BU mit). Traeger Lead/BU-Zug.

### FENSTER B — Mo 24.08.

    RN-10  P3-GLIED 3: S-19-ECHTLAUF #7 (Kampagnen-XMLs, GN-9-Werte, ggf.
           --fremde-lane=intel) + C-03-OV-4-Deckel-Rechnung VOR ##51 + C-04
           9-Messungen-Faktor + O1-O4-F2-Zeilen; PRODUZIERT die B-4-Zahl = Bau-Nenner
           des Triggers (ersetzt die benannte Rechenluecke "41,4 h fuer 128").
           Traeger #7. | Abh.: RN-06; #15/#17 gelandet (erfuellt).
    RN-11  P1-LANDUNG: E-10/#86-Zug landet (RN-03-Fortsetzung; K17-Kombibau,
           Byte-Gegenprobe, atomar T-8). SPAETESTENS vor Mi 26. 06:00. | Abh.: RN-01.
    RN-12  W2-Mo-Slots: ##32+##33-Reste (Bump-Buendel-Nachzuege; ##34-Wache = S-14a
           GELANDET, Restpruefung) + NULL-Bump-Wache-Vollzugsreste OV-2/OV-3 + ##35
           Resume-Beweis + ##36 T-15+D4-Verdrahtung + ##37/##38/##39/##41.
           Traeger W2-Mo. | Abh.: RN-01 (Landebahn frei fuer Kleinlandungen).
    RN-13  #22 OD-7: H-13-Pruefposten am gemergten s8kopf (traegt der Traegerbau die
           --debug-CLI-Haelfte?) + K12-2-Methodik-Override-Entscheid + S-8/S-9/S-10/
           S-11-Traegerbau-Start (T-NEU-6, W2-KOPF; deckt B-01/B-04/B-14/B-16 + R-01)
           + #29a-Zielstruktur-Schnitt VOR S-8 + W8-Explore KEINE-YAML-Naht vor S-12.
           Traeger #22/T-NEU-6/#29a. | Abh.: RN-01.
    RN-14  P9: Thesis-GitLab-main-Rueckstand (26 Commits hinter GitHub) heilen —
           V3-FF-Faelligkeit feststellen, dann FF-SHA-Muster (VOLLE SHA); Fetch-Quelle
           GITHUB; mit #121-Vorab-Hashes. Traeger Thesis-Zug/#121-Metadata. | Abh.: keine.
    RN-15  P9: #65 prt-art-Nachstufe + V1-DISKREPANZ #65-vs-#29 am Objekt messen
           (V6.5: Bau-Zustand + Mengendifferenz beide Richtungen). Traeger #65.
    RN-16  Band-B/W1-Mo-Randslots: 2-3 leichte Posten aus dem 22er-Band [lok]
           (Vorgriff; Feinplatzierung RN-26). Traeger #96-Vorgriff.
    RN-17  #128-SOLL-IST-ABGLEICH STARTEN (H-28; Input: Audit-Soll-Karten + Endstand-CI
           + dieses par.24) + H-29-Strang: 74 offene Regressionen (VOLLLISTE 5.1
           R1-R74) + 20 Status-Konflikte (Sektion 3 K-1..K-20) + #40-Abgleich als EIN
           Abgleich-Strang; dazu #129-D-04-Design-Fortfuehrung + #53-Design (PMC-
           Schwester zuerst; nach F-G1-8/9). Traeger #128/#129/#53. | Abh.: RN-01-Ende.

### FENSTER C — Di 25.08. (SCHNITT #96 + engster Bau-Slot; K-3-Kipp abends)

    RN-18  U-1 J-1-REZEPTFIX (ROT-Auflage; 7er-J-1-Liste LITERAL + reales Target
           comdare_profile_run_facade) VOR #18. Traeger #18-Vorlauf.
    RN-19  #18/S-13-BUENDEL (Di-25-Kern): Export-Element + Ziel-FILTER + per-Binary-
           XLSX (KON32-01/R33) + FJ-1..FJ-10 + E1-E11 (+r5-Auflagen; O8-RAM-Schwelle
           im E1-E11-Design zuordnen) + L5-2-KANN-Edits + ##11/<measure_selection> +
           R-05-XML-Trennung BAU/MESS (Branch-Kandidat bau/measure-selection-xsd nach
           RN-30-Inventur) + Paper-Experiment-XML je Paper (SEG5-32/R71-W2-Anteil) +
           #89/ph89-Anschluss + I-8-Felder-Schema (H-27: kanal_tag/zustands_dimension/
           machine_id + E-2 (iv)/(v)) + K6-6/R29-WritebackMethod-Objektluecken (4.
           Enum-Wert xlsx + Enum-Wache, GOAL G-41/#18-Posten) + R27/X-15-fail-loud +
           E-1/E-2-Schema-Landung (H-23 Teil A) + S-13-Testseite (Designplan D-4-
           Auflage: S-Strecke bekommt Testposten im Paket, T-11b/T-11c je Zug).
           Traeger #18/#48/#57-Verbund. | Abh.: RN-18.
    RN-20  #57 LAGER-VOLLAUSBAU (1)-(6) + S-17-LagerBaumWriter VERDRAHTEN (K-6-
           Konsens: gebaut+unverdrahtet) + R-38/O15-ETA-Merge/avg_size_bytes + R-03/
           R52-Host-Belegung + B-08/B-09 + R32-Bestandslog-scharf. Traeger #57.
    RN-21  #48 XML-PUBLIKATIONS-SEKTION (4 Klassen; deckt seg3-kon13-04/-27-02).
           Traeger #48. | Abh.: RN-19 (ein Verbund).
    RN-22  #3/S-12 VIER MINI-PIPELINES (Emission, B-17, KEINE YAML) + #106 CI-DUAL-
           Raenge 3-10 + ce-clang-Stage-Luecken-Fix (#106-Metadata) + M-6/R18-clang-
           Warnungs-Review + R74/J-1..J-4-Emissionsliste. Traeger #3/#106. | Abh.: W8-
           Explore (RN-13).
    RN-23  P9: FULL-JOIN-ENDPROBE 6-10 (T-12d-Rest) als #18-Abnahme-Teil — FJ-6..FJ-10
           am gebauten Stand beweisen (19 Organ-Segmente, seg_framework_ns ==
           seg_run_total_ns, markierter Leerwert, kein Spalten-Drop). Traeger #18-
           Abnahme. | Abh.: RN-19.
    RN-24  #105: NP-24 + Miniposten-Trio A9/A10/A11 + X-12/V-02R + D5-5-HDR-
           VERDRAHTUNG (P9-Branch bau/d55-hdr nach RN-30-Inventur; R-20/R62; FRIST
           vor Sa 29.) + p95-Export. Traeger #105.
    RN-25  #99 B-5f Tooling-Validierung (3 Stellen, V-13/KON101) + #94 Abi7-Kapselung
           (C-F4 + decl.hpp:797/R12) + #124 B-8 Gate-Define-Emission + hat()-Paar
           (X-13/A-12). Traeger #99/#94/#124.
    RN-26  #96-FEINPLATZIERUNGS-SCHNITT (Pflichtinstanz; nimmt JEDEN Posten): Baender
           22 (Band B/W1, 62h) + 37 (B-Rest, ~104,5h) + 5 (Band C, 13h) + 14
           (par.13.3) mit NEUEN Slot-Daten (alte WE-22./23.-Anker obsolet, s. Marker
           21.3) · Z-1..Z-15 · P4-94er-SOLL-IST-LISTE als namentliche 22.4-Erweiterung
           (s. 24.3.1) · Paragraph-75-104er-Kandidaten + RECONCILE-Reste (V6/R65,
           gezaehlte Randslots) · X-1-golden-Ref-Ausbuchung (B6, D12-Muster) · X-14
           Peer-Sessions-Ernte · O13/ext-A05-Dublette in Paragraph-75-Liste · R-28/
           X-11-Nested-dirty-17 · #104-Rest/O5-build:standalone-Pin (W2-Mini analog
           #104). Traeger #96. | Abh.: RN-17-Erkenntnisse fliessen ein.
    RN-27  Di-25-DOCS-/MEMORY-/LEDGER-ZUG (EIN Zug, H-14 + H-35 + P8; lens-frei):
           AB-03 (Z-6/Z-7/Z-9-Board-Texte; #123 existiert, #24/#28-Zusaetze) · AB-04
           12-W-MARKER-TAFEL 0/12 (W11 zuerst; setzt auch GOAL-UE-1/UE-2-Marker Z.229/
           232 + ARBEITSWEISE-T4-1-Kandidat [dort owner-gated als REGEL-KANDIDAT]) ·
           AB-07 (B.0-Ort + K16-Baustein) · par.25 = OV-16/OV-17-BUCHUNG (WORTFERTIGER
           d10-Entwurf; Nummern-Deklaration s. Kopf) + B-17-D-10-Ursachen-Antwort in
           die Owner-Meldung ("seit 09.08. GEBAUT, nur Buchung fehlte") ·
           anhang_forward_core.sh:250-Kleinstfix · X-3/X-3b-17:45-Zusaetze · k21-Reste
           (6c/X-17-Publikation 111 Verdikte ungekuerzt; K-5-Eichlinie als W2/L4-
           Pruefposten nach RN-31) · H-36 K21/K22-Vermerk · 14 B-KLEINPOSTEN (Session
           Teil 2: KON122-Zeilen B-03/B-04/B-10/B-14/B-18; Memory-Ergaenzungen B-02/
           B-05/B-06/B-08/B-12/B-13/B-16; Board-Text B-20; B-11-O2/O3-Marker mit o2-
           Landung; B-15-par.24-Traeger = HIERMIT dieses par.24 + Bau nach R4) ·
           O9-'G13'-Klaerung · O10-Roh-Transkript-Nachlese (2 GOs) · O11-K-5-Dateien-
           Deklaration · O12-README-allocators-1-Zeiler · O14-Roadmap-17_E4 deprecaten/
           nachziehen · E-38/E-39-Zusatzfunde-Sichtung (6k-Sweep UNGEPRUEFT-Klasse,
           H-30-Teilposten; VERIFY-Nachtrag 23.08.) · K-10-prod1-24er-Marker Paragraph-69.6 · D-08-LABEL-KOLLISIONS-
           Vermerk (s. Marker 19.4) · L6-Prosa-Nachlande-Posten (9 Fundstellen, N-H1)
           · L7-GesamtStempel-Verbuchung · L5-Sprachregel (3 Emitter-Begriffe, M13) ·
           1.4.f-Docs-Block komplett (13 Fallen-Klassen, K7b-5, JB-2/3/4, K9-3,
           T-14..T-16-Haelften, D-08-8->15-Korrektur, T-UPD-5-NP/M-Zug, A-16..A-19,
           L1/L2/L4/L6/L9-Belege, 6c, prod1-24, seg7-45, H5, seg1-04/F8, SEG5-36) ·
           GOAL-REFERENZ-STAND-23.08.-Block + Marker (L-GOAL Tafel 4: UE-1..UE-9) ·
           Designplan-par.13-Nachtrag + Marker (L-DESIGNPLAN F) · ARBEITSWEISE-B.3-
           NACHTRAG + REGEL-KANDIDATEN 12-17 owner-gated (T4-3 K19-Regel, T4-6 CI-
           Dual, T4-8 NIE-KUERZEN, T4-9 Vollaudit-BU, T4-10 Zeithorizont, T4-1 12-W).
           Traeger #85 + Lead-Ledger (Lead-only-Hotspots beachtet). | Abh.: RN-01.
    RN-28  #71 Triage-Sammel (+D-18/R49-Wachen-Nachbar: 3 allow_failure GEGEN Doktrin
           inkl. super:1841 ergebnis:holen [GOAL G-59], libs/ ohne -Wall, n/a-Gate,
           289-Writeback) + #74 Repo-Rollen-Umbau (15 CE-Kandidaten; R-28-Bauweg;
           B-07/SEG5-16/R70 csv_to_latex->measure_to_latex) + P9: #69 750-vs-1310 +
           prod2-TeX-Probe (vor W3) + #28-TEST-KONSOLIDIERUNG-Beginn (Startzahl 14
           Skripte/Z-9; O7-smoke_19_1; D-3-Shell-Bissproben-Migration; 279 TUs ohne
           -Wall = H-21c). Traeger #71/#74/#69/#28.
    RN-29  #103 TSan-VOLLAUSBAU [lokal, build-tsan-NEUBAU; M-2-Fence-Naht] + P6:
           #40-NE-TRIAGE (38 NE-Posten/20 Auftraege sichten; NE-01-Zahlenkorrektur
           bindend; T-UPD-2-Kollision T-13/T-14 W7-vs-vor-W3 AUFLOESEN — Entscheid
           faellt HIER, Vollzug RN-44) + B7/T-NEU-13 wip/luecken-stufe2-vs-#40-
           Abgleich. Traeger #103/#40. | Abh.: RN-17 (Abgleich-Strang liefert zu).
    RN-30  P9: 5 TRAEGER-KANDIDATEN-BRANCHES-INVENTUR (je Branch: Explore-vor-Merge-
           Pflicht, Ueberholt-Status messen, KON49-02-Verfahren): bau/d55-hdr ->
           RN-24 · bau/lagp1-object-stat -> RN-47/##21-H2 · rettung/bau/d3-7b-pruef-
           only-bilanz -> RN-31 · bau/measure-selection-xsd -> RN-19 · b-graph-2d3d
           (super) -> RN-60/#98. Dazu bau/ci-stage-topologie (D1b-Rest) und
           bau/stempel-nachlande-f2 (vermutlich gelandet, pruefen). Traeger Inventur/
           #96. | Abh.: vor den jeweiligen Ziel-RN.
    RN-31  W0b/W1-KLEINRESTE (Di-Rest + W2-Randslots; aus 13.1/23.1/Soll-Ist Tafel 4):
           D3-7b pruef_only (+D3-1-Marker-Haelfte, B-1-Rest) · D3-3b Leerzeilen (3
           Dateien EIN Commit) · ##20-B-Restbau (COPIED_LIST; Runner-git >=2.25) ·
           ##13 G3-Split (R-09) · F2-6 E-Label-Rest + Flag-f-Kollision · S-14-
           VOLLAUSROLLUNG (T-NEU-5) · ##31-Vollform + D1c-Vollausbau · D1e/D1f/D2-G2/
           ##06-CI-Haelfte/##07-Statuserhebung (13.1-OFFEN-Klasse; Soll-Ist fuehrt G —
           je Posten Objekt-Blick, Konflikt im #128-Strang) · D2-G6-Status · ##08-Rest
           · ##15-EMITTER/TEMPLATE-Haelfte · ##16/##17-Break-Even-D-04-Neuform-
           Anschluss (OV-1-Fork ersetzt durch D-04-VOLLES-GO; R69-B-Spline-
           Konsolidierung) · LG-XlsxAlt + LG-SkipCallback (F2-5-Klasse) + 6+2-Band-A-
           Deklarationsposten (~33h W2-Randslots) · D-5-xlsx-Profil-Nenner-Wache ·
           T-12e-S-3-Kombibau-Nachweis · D-6-PMC-Vertragsfolge-Test (mit RN-35) ·
           G-55/D2-Rest (18 bedingte Registrierungen, F1->F2-Reihenfolge) · R45/R46/
           R50/R51/R61/R63/R72/R73-W2-Zeilen · K-5-Eichlinien-Posten (W2/L4).
           Traeger #96-Zuweisung je Zeile. | Abh.: RN-26.

### FENSTER D — vor Mi 26. 06:00 (TRIGGER-VORBEDINGUNGEN)

    RN-32  C-01 VOLLBAU-GATE-VORLAGE (T-NEU-9/R34; KON22: Lagerhaltung fertig UND
           Stempel fertig UND Algorithmen versioniert UND Messung einbaubar — als
           Owner-VORLAGE vor dem Trigger; GOAL G-09). Traeger T-NEU-9. | Abh.: RN-19/
           RN-20-Stand fliesst ein.
    RN-33  C-02 HEAVY-SIGNAL fuer das 26.08.-Fenster SENDEN (T-NEU-10; KON58-03;
           GOAL G-48). Traeger Infra/#60-Umfeld.
    RN-34  R-04 LB-4/5/6-Baum-Vollausbau (P-Klasse: "Trigger IST Baum-Vollausbau") +
           R-13/R57 zwei unwahre Messgroessen (bytes_in_use_peak-Momentanwert,
           CLU-64-Literal) + R-12/R56-Restvorbehalt: E07-Q1-Re-Run (<1h, Rezept Par.9)
           auf der FINAL eingefrorenen Trigger-Linie (#131-Endstand-Anhang).
           Traeger (P)-Klasse/#114-Anhang.
    RN-35  #83 PMC fail-loud + #82 I-PMC-2/3-Reste nach pmcpaket-Landung messen
           (seg1-45 5-Flags/R13, seg1-67/R14, P-1/P-2-Reste/R15; VERTAGT-Posten T6/
           T8b aus r2 DURCHZIEHEN — Owner 19.08.). Traeger #83/#82. | Abh.: RN-01.
    RN-36  INFRA-FENSTER VOR Mi 26.: #84 Rotation (Projekt-Token 286/288/289 SOFORT-
           Klasse [GOAL G-12] + O1-GitHub-PAT [SECURITY, in #84-Zug aufgenommen] +
           R-64-samba-Vault + INF-03/05 + L-A-PAT-Kette/V8/V9-rescue-Ref + W17-Backup-
           Ref-Identitaet [V9-gekoppelt, Register D.7]) + #132-envoy-
           CrashLoop (Optionen a/b) + H-05/U-2-root-Platten-Raeumung (nach F-10-GO;
           E-12-Platten-Zahlen vorher NEU messen) + L-D node6/id56/id18 + L7-Talos-
           Kernel + #87-Talos-Lane-Voraussetzung (v1.13.x; danach AmdL3/##09-Rest).
           Traeger #84/#87/#132/Owner-Handgriff. | Abh.: RN-05/F-01+F-10.
    RN-37  #91-VERBUCHUNG (completed-Buchung + Identitaets-Entscheide E-1..E-10 als
           Ledger-Zeilen) + E-6-EMITTER-AUDIT-GREP (Klammer-Form-Kanon, #120-D-07-GO,
           klein, read-only + Schreiber-Fixe mit Minor) + E-9/AB-02-KONTROLLE (W18/
           LEDGER:8941-Austragung per 38fd6270 — verifizieren, sonst nachholen; GOAL-
           Trigger-Risiko) + L7-Verbuchung. Traeger #91/#120/Lead-Ledger.
    RN-38  ##49 BAU-TRIGGER Mi 26. 06:00 AUSLOESEN (Bau-Nenner = B-4-Zahl aus RN-10;
           Batch max 4096; KIPP-Regel K-4: spaetester Start Fr 28. 06:00).
           Traeger K-4/Lead. | Abh.: RN-11, RN-19-22, RN-32-37.

### FENSTER E — Mi 26. bis Fr 28.08. (BAU-FENSTER EXKLUSIV; F3 = Fr 28.)

    RN-39  ##50 Zweitlauf (Do 27.) + Bau-Betreuung; waehrend des Baus NULL CI-/
           Agenten-Last auf prod1 (VII.2; kontaminierte Daten = unheilbare Klasse);
           K-5-Kipp: Do 27. abends Bau durch. Traeger Lead.
    RN-40  ##51 USER-GO-VORLAGE = F3 (Fr 28.); W2-Band-A-8-Testposten (MT-L1/L2/L6/L7,
           PM-m3v2Zero/RAPL/Scaled/NichtGelesen-Seam = Kampagnen-Wahrheit) bis F3
           gelandet als Teil der GO-Vorlage (Slots Mo/Di/Fr). Traeger ##51/W2-Band-A.
    RN-41  Bau-freie [lokal/0-CI] Design-/Doku-Posten im Bau-Fenster: #49-
           Staffelungs-Design (nach F-06/V7-Antwort) · L4-Strategy-Flaechen-Feinschliff
           (Bau mit/nach B4) · S-22-Design (#92-Folge) · D-24-Bleib-Notizen · R-36/
           H1-H7-Fork-Vorbereitung · D-10-Auswahl-Subsystem-Explore · R-30-Schicht-
           Verstoss (Owner-GO "Fenster ist jetzt") · R-34-descoped-Frage-Explore ·
           R-35-S-7-Locking-Deep-Research · R-29-tier150-Archivierung [lok] · R-16-
           21-Images-Marker · R-55/R-08-Beleg · D-46-Modi-Design (R46). Traeger je Zeile.
    RN-42  F-2-FREITAGS-LIEFERUNG Fr 28. (abgabefaehiger Stand; ARBEITSWEISE F-2;
           GOAL G-16). Traeger Lead.

### FENSTER F — vor Sa 29.08. 06:00 (KAMPAGNEN-VORBEDINGUNGEN)

    RN-43  #125/C-09 DRIFT-GATE-DEBUG-AUSNAHME (H-12: seit messfenster-Merge FAHRBAR;
           T-12a: RunMethodology-Abschaltung, sonst am 29.08. JEDE Zelle rot; Debug-
           Zahlen NIE ins Messwertlager, AdmissionStatus) + C-08/R38-Restkontrolle
           ("5" auf Drift-Achse; messfenster traegt T-15b — nachmessen) + C-07/R37-
           Granularitaet. Traeger #125/#13-Folge. | Abh.: RN-01.
    RN-44  C-12 = T-13/T-14 FEHLERKLASSEN (PFLICHT vor W3; 0/18 Achsen, 0/121
           Algorithmen; L8-Hybrid-Parser-Fehlerklassen andocken; T-UPD-2-Entscheid aus
           RN-29 vollziehen; T-07/T-08 vor Trigger falls mengen-wirksam — sonst hier).
           Traeger ##40-Rest/C-12. | Abh.: RN-29.
    RN-45  #97 C-13-SKIP-OEKONOMIE + C-14-BESTANDSLOG-SKIP-WACHE (R42/R43; 320
           bit-identische IDs) + #97-REST Ausweis-Host-Verdrahtung. Traeger #97.
    RN-46  #127 DAUERROTE Achse-06/CRC (H-26; 3 Tests + fixture-Klasse; KON119-06) +
           K-5-Auswahl-Blindheit-Eichlinie (aus RN-31). Traeger #127.
    RN-47  P9: C-10-ZWEILANIGKEIT am HEUTIGEN Generator-Stand nachmessen (GOAL G-50;
           Intel-resource_group, Paragraph-61-Revision/R40) + INTEL-RAW-KREUZPROBE
           (pmc:intel; prod2 online seit #60; OV-5b-Satz via RN-05) + R60/R-17-Tag-
           Mismatch baremetal (Runner id6-9) + R59/R-15-L3-Pinning-Pflicht + R58/
           R-14-Chaos-/Drift-Gate-Aufrufer + ##21-HAELFTE-2 object_stat gegen Store
           (lagp1-Branch nach RN-30; ##56-W3-Abnahme vorbereitet). Traeger C-10/#82-
           Folge/##21. | Abh.: RN-30, RN-35.
    RN-48  C-15 MinIO-Ebene-B-CI-SMOKE-Beweis + COMDARE_RUN_MEASURE-Falle (R44) +
           N-10/A12-NAS-Creds (T3). Traeger Betrieb/#10-Folge.
    RN-49  ##52 VOR-GATE + BEIDE OV-15-GOs (bis Sa 29. 06:00) + T-12b/C-05-Warmup-
           Paar-Legacy-Beweis (run_observable_perm ODER Ausbuchungs-Beweis; R36/R67-
           Rest nach messfenster-Landung nachmessen) + Deckel-/Nenner-Kontrolle aus
           RN-10. Traeger ##52/OV-15.
    RN-50  FRIST-KONTROLLE Sa-29-Klasse: HDR-VERDRAHTUNG gelandet (RN-24; R62)? ·
           #38c-n/a-Zaehler-Rest (kampvor-super gelandet)? · #127 gruen? · C-12 durch?
           — je NEIN: sofort eskalieren, nicht rutschen. Traeger Lead-Gate.

### FENSTER G — W3 Sa 29.08.-F4 Fr 04.09. (KAMPAGNE EXKLUSIV; Batch-Pausen [lok])

    RN-51  ##53 KAMPAGNE je Batch-Abend (Debug-GENERALPROBE-Charakter bis T-3;
           T-15b-Retry 5/5, 3 Werte einzeln; Drift-Gate scharf; xlsx=Ausgabe).
           Traeger ##53. | Abh.: RN-38-40, RN-43-50.
    RN-52  HY-B/S-15 (Hybrid erzeugen/einschieben nach Einzelmessung) + #123 HY-B-
           STEMPEL-EXPORT (Z-6; nach P5-Hash-Form-Antwort [RN-05] + A-11/#102-Linie).
           Traeger S-15/#123.
    RN-53  ##54 Overhead-Teilmatrix + ##55 L3-Asym (+T12b-CCD-Semantik) + ##56
           RUECKSCHRIEB (+object_stat-Haelfte = ##21-H2-Abnahme aus RN-47).
           Traeger ##54-##56.
    RN-54  BAND-[lok]-BATCH-PAUSEN: Band-B-Rest-Anteile (37er) + 22er-Restposten OHNE
           Landung (nur lokale Staende; Landung nach W3). Traeger #96-Slots aus RN-26.
    RN-55  S-20-SYNC-KANAL-Design (Owner: Autonomie-Stufe SPAETER; Design-only) +
           R-55/R-08-O(Maschinen)-Vollzugsbeleg W2->W3. Traeger S-20-Design.
    RN-56  W3-TEXTARBEIT ueber Overleaf-Remote (VII.2-konform): #130-Vorzieh-Anteile
           + #121-Absatz-Pipeline-Start (nach Owner-3/90 + F-16), DE fuehrt.
           Traeger #121/#130.

### FENSTER H — W4 Mo 07.-Fr 11.09. (F5 = Fr 11.09.)

    RN-57  ##57 BREAK-EVEN (D4f-Statusraum, D-04-Form aus #129-Design; OV-6-Antwort
           aus RN-05; R69-B-Spline-vs-Hermite-Konsolidierung vollzogen). Traeger
           ##57/#129.
    RN-58  P2-BAU: HY-C-Router + L2 HYBRID-MODUL-EMITTER (8-12h; M9-Fenster;
           render_hybrid_module_source als Strategy-Schwester, Status-13-Gegenprobe
           rot-zuerst) + L4-FLAECHEN-BAU (4-6h, falls nicht schon mit B4 in W2-E;
           Selbstkompilation 3/4 -> 4/4, 6er-Nenner faellt byte-neutral) + L3-START
           (W4-Anteil je Kampagnen-Scope-Antwort; C2-Vertrags-Testpaare sobald L4-
           Vertrag steht). Summe P2-Nach-Trigger-Bau 26-40h — Rest W7 (RN-75).
           Traeger #24/B4-Folge + HY-C. | Abh.: RN-04-Entscheid, RN-51-Messdaten.
    RN-59  ##58/##58b ANHANG-WACHE (Soll ZUR LAUFZEIT messen; "28" UNBELEGT, real
           10/12) + ##59 FF0-FF4-Abgabe-Gates. Traeger ##58/##59.
    RN-60  ##60 C5-Zahlen + #98 F-07b 2D+3D-DIAGRAMME (Owner-KERN; b-graph-2d3d-
           Branch nach RN-30; SOTA-Form) + ##19 LaTeX-/Ranking-Emitter + R-31-LaTeX-
           Anlage in Abgabe. Traeger ##60/#98/##19.
    RN-61  ##61 Backups + P-1 PRAESENS-WACHE 3/3 (Thesis-Zusagen gegen Bau-Stand).
           Traeger ##61/P-1.
    RN-62  P7: #130 = 16 UNGETRAGENE THESIS-AUFTRAEGE (Feinverteilung nach F-16;
           K19-GEGENZAEHLUNG: jeder Auftrag -> Traeger + Wellen-Platz, gegen JA-Liste
           gegengezaehlt) + #121-Pipeline-Vollzug + #77-Audit-Einarbeitung + #19
           (Thesis-Textpflichten) + #66-Lizenz (W5-##62-Zulauf) + C.4-E-1-THESIS-
           TEXTZUG (Drei-Projekte-Abgrenzung, Selbst-Optimierungs-Satz, UltiHash-
           Prinzip; 18+1-Formel) + GOAL-G-23-Nachzug-Kontrolle (Praesens-Zusagen).
           Traeger #130/#121/#77. | Abh.: RN-56, F-16.
    RN-63  #88-MECHANIK-ANTEILE: Parameter-Filter-Registry RF-B + Lager-Typ 3+4-
           MECHANIK (Schluessel-Schema kam Di 25 mit RN-19) + Hybrid-ML-Design +
           kleine Hybride P-B..P-E-Details. Traeger #88. (Monolith-Split-Anteil = W7,
           Owner-Wort, RN-74.)
    RN-64  D-13 ADR-Register + D-16 KONFORMITAETS-REGISTER-NACHMESSUNG (R48; W4-
           Realitaetsanker; seit 09.08. ungemessen) + D-21 Syntax+Semantik-
           ABGABEPFLICHT. Traeger D-13/D-16/D-21.
    RN-65  ##24/A9-S5a Archiv-xlsx (Rutsch aufgehoben) + ##42-##45-REST (FF-Matrix,
           .ps1/.py-Abloesung, C5-Geruest, Thesis-Spur; 13.1 ohne Einzelquittung — je
           Objekt-Blick im RN-17-Strang). Traeger ##24/##42-##45.
    RN-66  BAND-RESTMENGEN W4: Band-B-Rest-W4-Anteile + Band C (MT-L8, PM-PAPI,
           AG-PunktFixes; WinPCM W2/W4 [Runner online]; AmdL3 -> #87-Lane) + 14-Alt-
           Posten-W4-Anteile + R17/K10-12-Wstringop (W4/W5-Randslot) + R-21..R-26/
           R-29/R-34-Reste + HY-Ebene4(b)/HY-Kurvenlage/HY-Ausgaenge/HY-HonestEmpty
           (W4-Band-A, 34h) + MT-L10/L11/L12/AG-GenusCount (W4-Band-B). Traeger #96-
           Slots. | Abh.: RN-26-Feinplatzierung.
    RN-67  VERTAGT-DESIGN-DURCHZUG: V7 HY-Mehrfach-Dock (HY-B-Design W3 -> W4-Bau
           nach HY-C) + V8 Heuristik-Familie/scharfe Eviction + V9 Record-and-Replay-
           BAU (R-22-Design war W2) + V10 PV-1 + Doku-Anker-Sanierung (W4/W5-
           Randslots). Traeger je Zeile (aus VOLLLISTE 1.5).
    RN-68  E-4-VOLLZUG-VORBEREITUNG: 4. Mess-Ebene ma-hy nach R5-Antwort (HY-C-/W4-
           Fenster; Wert-3-Vergabe, Kanalwerk-/Legenden-Erweiterung; Reserve kam vor
           Trigger). Traeger #90-Folge/HY-C. | Abh.: RN-05/R5=F-05.
    RN-69  Kap.5-ERGEBNISTEIL (daten-gated) + A9-S3/S4/S5. Traeger W4-Text/##60.
    RN-70  W4-SCHLUSS-GATE: F5-Stand Fr 11.09. (PDF-faehig, Anhang gegen Nenner,
           P-1 3/3); RN-17-#128-Abgleich-ENDSTAND (74 Regressionen + 20 Konflikte +
           34-GESTRICHEN-Neubewertung + 15-Traegerlos-Kontrolle: Differenzmengen
           LEER, sonst namentlich in par.26-Nachtrag). Traeger Lead-Gate/#128.

### FENSTER I — W5 Sa 12.-Di 15.09.

    RN-71  T-3 MANUELLER RESET + ECHTE MESSUNG (~Sa 12.-Mo 14.09., KON41-01; Ende
           der --debug-Aera; T-3-Ripple XML->PDF-Vollautomatik + Lager-Skip muss aus
           W2/W3 stehen). Traeger T-3.
    RN-72  ##62 W5-SICHERUNG: PDF sauberer Checkout, Spiegel, ABGABE Di 15.09.;
           KEINE Test-Eingriffe, NUR Nachweise (Koeder-Protokolle, Nenner-Zeilen) in
           die Abgabe-Doku; W5-Nicht-Bau-Anteile der 14er-Liste. Traeger ##62.
    RN-73  SCHLUSS-KRITERIUM-KONTROLLE (GOAL G-62): jede ausgewiesene Zahl von
           aelterer Messung gedeckt; jede sichernde Regel in einem WERKZEUG.
           Traeger Lead.

### FENSTER J — W7 / NACH ABGABE (NUR owner-entschiedene Kategorie C; KEIN Endlager)

    RN-74  OV-14 Paper-Kopplung (+R71-Rest) · #88-MONOLITH-SPLIT (P-B/P-K; Owner-B3
           "beim Aufraeumen") · C-1-Journal-Labels (NUR per Owner-Satz) · V13
           Migration A1/A5/A7 · V14 G5/#274 · V15 Tools-Lagerhaltung (#32) · V16
           #276 3-ISA-Teilmatrix (ausdruecklich ALLERLETZTE Aufgabe) · V17 Vortrag
           (D-15). Traeger par.21.6-Tafel.
    RN-75  #38a3 IO-VOLLAUSBAU (store()/load()-Genus-Vollzug, KON47-03; Kanalwerk-
           Registrierungs-BAU-Rest aus C.2-Schritt-5/6) + L3-CONTAINER-VIER-W7-Anteil
           (je Scope-Antwort) + T19-Katalog-Folgefrage (NICHT jetzt erfinden, C.3).
           Traeger #38a3/#86-Folge.
    RN-76  V19 g2-Funde 2-4 (L2-Optionen A/B) · V20 XML-Rueckfrage-Kandidaten K1-K4
           (nach Abgabe buendeln) · V21 Posten-60/Klein-Hybride-Details · V22-
           Kontrolle (bewusst-nie-Liste bleibt deklariert; Wiederaufnahme nur per
           Entscheid). Traeger VOLLLISTE-1.5-Zeilen.

### ERGAENZUNGS-STAFFEL RN-77..RN-84 (gleicher Stand 23.08.; aus der Gegenzaehlung
### der Quell-Tafeln — je Zeile mit eigenem Fenster-Etikett)

    RN-77  [Mo 24.-Di 25., je freiem Bauslot] #120-B-BLOCK-Bau-Starts (H-24, zweimal
           verfallene Zusage — jetzt terminiert): B3-Rest · B4-checkpoint-Anschluss
           (SOLL cc04be1, Abschaltungsstufen 1+2; OF-1-Gate; #24/B4-Kern 9+8; L4-
           Andock-Flaeche faehrt MIT B4) · B5-VOLLNACHZUG + B5-VORPOSTEN (Zwillings-
           Wache CEB==Tier-Zeile; KON64-Anteil nach Doppel-JA klar) · B1/F2-1-
           Registry-NEUBAU <measurement_tooling> (W2-Anfang VOR Trigger, #24) ·
           D-02-Rename · D-03 · D-11-K2. Landungen HINTER dem S1+S2-Zug, sequentiell.
           Traeger #120/#24. | Abh.: RN-01; identitaetswirksame Anteile vor Mi 26.
    RN-78  [nach #15/B5-golden-GO, vor Trigger] golden-FOLGEZUG: B-7-Stempel-Haelfte/
           E-B/A-11-Emitter-Haelfte + B-10-Anker-Faelligkeit + Kampagnen-Bump
           (telemetry-silent; V-03R-Budget UNVERBRAUCHT; par.21.1-Folgezuege B-7/
           B-10/B-8/VL-5/VL-6-Doku/KORB-A-12). Traeger #120/B5-golden. | Abh.: RN-77.
    RN-79  [Di 25.] ##46 Anker-3-Spiegel + ##48 Paragraph-66-Platten-Budget + ##41b
           Kaskade (W2-Di-Slots aus par.3/par.7). Traeger W2-Di/#96.
    RN-80  [W2-Slot, vor Trigger-Naehe] S-2/G-1-GRAMMATIK-BAU (D-05-PFLICHT,
           KON120-02; G-1-Tabelle KOMPLETT entschieden [H-19], nur 2 Owner-
           Bestaetigungen via RN-05; danach G-1-Ruecklauf in die W2-Tabelle).
           Traeger #53-Umfeld/S-2. | Abh.: RN-05 (F-G1-8/9).
    RN-81  [vor W3] R-11 Resolver target_isa-RT/core_class (OD-11-RT-K) — mit den
           RN-47-Proben fahren. Traeger 1.4.e-Zeile.
    RN-82  [Di 25./W2] v32-PLANER-SKELETT-Vorbereitung (S20-Supersede: Wiederver-
           wendung als offizielles Planer-Skelett, Fork A/PL-0; H-20-Zeile) +
           v32-Enumeratoren-Kleinposten (H-21d). Traeger H-20/#96.
    RN-83  [W2/W3-Voraussetzung, spaetestens vor T-3] T-3-RIPPLE-BAU: XML->PDF-
           VOLLAUTOMATIK + LAGER-SKIP (17.4/18.5-Ausweis; ohne sie kein RN-71).
           Traeger #18/#57-Folge. | Abh.: RN-19/RN-20.
    RN-84  [Di 25.] H-20-STAFFEL-3-RESTLISTE namentlich in den #96-Schnitt: Trigger-
           Akten E-4/E-5/E-6 · YAML-Zug-Reste E-14/E-15/E-10-Akte · MinIO-Smoke
           (->RN-48) · NP-02-Zeile (->RN-05) · #104-Rest/O5 (->RN-26) · 6c-
           Publikation (->RN-27) · Band-B-Slots (->RN-26). Traeger #96/H-20.

### ERGAENZUNGS-STAFFEL 2 RN-85..RN-92 (23.08.; aus der Register-Gegenzaehlung
### EINPLANUNGS-REGISTER — 8 Quell-Posten, die in RN-01..RN-84 keinen NAMENTLICHEN
### Platz trugen; Differenzmenge damit LEER)

    RN-85  [vor Mi 26. 06:00] #90 P-A KANALWERK-/ARENA-DESIGNPLAN abschliessen
           (checkpoint_measure-Kanal-Baum; C-13/C-17-Detailfragen; O8-RAM-Schwellen-
           Zuordnung faehrt in RN-19; VOLLLISTE 1.4.a/1.4.d vor-Trigger-Klasse).
           Traeger #90/#53-Umfeld. | Abh.: RN-04 (D-08-Weiche); speist RN-68.
    RN-86  [vor Sa 29.] H3-FLAKE-KLAERUNG (VOLLLISTE 1.4.e): Mess-/Testwelt-Flake
           vor der Kampagne dreiwertig klaeren (BEHOBEN/ENTLASTET/Traeger).
           Traeger 1.4.e-Zeile/#127-Umfeld. | Abh.: RN-46.
    RN-87  [W2, vor Trigger] K-1 LAGER-IDENTITAET HYBRID-.so (O-5-Rest, OF-3-
           Kopplung; VOLLLISTE 1.4.g): Ablage-Identitaet der Hybrid-Kompilate im
           Lager mit dem RN-19/RN-20-Schema-Zug pruefen; Entscheid-Bedarf via RN-05.
           Traeger K-1/#57-Umfeld.
    RN-88  [W2] O-13 DUMP-PLAN-HERKUNFT (WF4-E-C; VOLLLISTE 1.4.g) klaeren; Befund
           im RN-27-docs-Zug buchen. Traeger O-13.
    RN-89  [W2, nach B2 am Objekt] W13-EXPLORE CEB 4-vs-6 (VOLLLISTE 1.4.g;
           KON37-03-Umfeld) am Objekt fahren. Traeger W13.
    RN-90  [W2] N-8 HW-ERKENNUNG P4-P6 (T2-Klasse; VOLLLISTE 1.4.g). Traeger N-8.
    RN-91  [W2, beim D-01-Folgezug] H-33 D-01-FABLE-TIEF-NACHLESE (Lead SELBST;
           Opus-breit liegt: 4. Ebene ABI-fest, Major 9; R5=F-05-Bestaetigung via
           RN-05). Traeger Lead/D-01. | Abh.: RN-05.
    RN-92  [Di 25., Freeze-Deklarations-Kontrolle] F2-7-REST GENUS-CT-KOMPOSITION
           namentlich (VOLLLISTE 1.4.c): Teilstueck-Deklaration im Freeze-Check
           kontrollieren, Rest-Bauanteil in die RN-31-Randslots. Traeger F2-7/#96.

## 24.2 P1-P10 — KURZVERZEICHNIS DER EINPLANUNG (Detail in den RN-Zeilen)

    P1  E-10/#38a2-Bauzug + #86-ORG-19-Schritte-1-4 + W5-Grammatik-Slot -> RN-03/
        RN-11 (+RN-37-Buchung); Design-Gate #133 ERFUELLT (DESIGN-h23); Frist Mi 26.
        06:00. Das 18.6(3)-Deklarat (18.3/18.6/23.2) ist UEBERHOLT — Marker am Ort.
    P2  D-08-Entscheid A/B Default A -> RN-04; Nach-Trigger-Bau L2/L3/L4 (26-40h)
        -> RN-58 (W4) + RN-75 (W7-Anteil); L5 -> RN-01/RN-27; L6 -> RN-27 (9 Fund-
        stellen); L7 -> RN-37. Label-Kollision Wellenplan-D-08 vs KON120-D-08:
        Marker an 19.4.
    P3  S-19-Sa-Kette GERISSEN -> neu terminiert: o2-Landung RN-01 -> GN-9 RN-06
        (23./24.08.) -> S-19-ECHTLAUF RN-10 (Mo 24.) -> B-4-Zahl vor ##49 (RN-38);
        K-3-Kipp Di 25. abends haelt. Kette per V6.10 in Ledger UND Checkliste
        eintragen (RN-02-Ledger-Spiegel).
    P4  94 offene Soll-Ist-Posten -> 24.3.1 (namentliche #96-Erweiterung, RN-26;
        NZL-G-23 via RN-01).
    P5  W1-Vollaudit-Restmenge 156/22/34/74/20/15 -> 24.3.2 (Traeger #128/#96 +
        benannte Einzel-Traeger; Abgleich-Strang RN-17, Endstand-Gate RN-70).
    P6  #40 = 38 NE-Posten/20 Auftraege -> RN-29 (Triage + T-UPD-2-Entscheid) +
        RN-44 (Vollzug T-13/T-14) + Rest-Slots W4 via #96. 24.3.3.
    P7  #130 = 16 Thesis-Auftraege -> RN-62 (+RN-56-Vorzieh); K19-Gegenzaehlung
        Pflicht. 24.3.4.
    P8  docs-/Prozess-Reste -> RN-27 (EIN Di-25-docs-Zug; AB-09 in RN-09; AB-10 in
        RN-08; H-13 in RN-13); par.25 = OV-16/17-Buchung (Nummern-Deklaration Kopf).
    P9  Ungeprueftes -> FJ-Endprobe RN-23 · Intel-Kreuzprobe RN-47 · #69 RN-28 ·
        #65/#29 RN-15 · Remote-Divergenz RN-01 · Thesis-main RN-14 · 5 Branches
        RN-30 (Explore-vor-Merge je Branch).
    P10 Frist-freie Board-Posten -> #49 RN-41 · #53 RN-17 · #71/#74 RN-28 · #85
        RN-27 · #87 RN-36 · #88 RN-63/RN-74 · #94 RN-25 · #98 RN-60 · #103 RN-29 ·
        #112 RN-01 (KON122) · #123 RN-52 · #129 RN-17/RN-57 · #132 RN-36; Baender
        22+37+5+14 -> RN-26-Feinplatzierung + RN-16/RN-54/RN-66-Slots. O-1-
        Bezeichnungssystem -> RN-05 (Owner-Vorlage). "Frist-frei" heisst seit
        20./23.08.: sofort in der Reihe, nie spaeter.

## 24.3 MASSEN-BLOECKE — NAMENTLICH REFERENZIERTE UNTERLISTEN (kein Posten ohne Platz)

    24.3.1  P4: 94 NOCH-ZU-LANDEN-Posten. QUELLE: ~/backups-workflow/20260822-lande-
            zug/wellenplan-soll-ist.md (Tafeln 3-7; 23 NZL-G + 68 NZL-F + 3 Kategorie
            C). FENSTER/TRAEGER: NZL-G-23 -> RN-01 (Lande-Zug, sequentiell); Tafel-4-
            50 -> je Zeile das dort benannte Fenster (Di-25 -> RN-19..RN-31; vor
            Trigger -> RN-32..RN-37; vor Sa 29 -> RN-43..RN-50; W2-Slots -> RN-12/
            RN-13/RN-31); Tafel-5-6 (Wiederaufnahme-Sammel) -> RN-26; Tafel-6-12
            (W3/W4/W5) -> RN-51..RN-72 je Etikett als SPAETESTE Frist; Tafel-7-3
            (Kategorie C, Owner-Wort) -> RN-74. Abhak-Instanz: #96 (Di 25.) +
            EINPLANUNGS-REGISTER Abschnitt B.
    24.3.2  P5: W1-VOLLAUDIT-RESTMENGE. QUELLE: docs/sessions/backups/20260821-
            vollaudit-welle1-stand/VOLLLISTE-features-aufgaben-k1-heute.md.
            156 OFFEN-mit-Traeger (Sektion 1.4: 42 Board-Tasks + 16 F2-Fenster ->
            RN-05 + 11 Freeze-Reste -> RN-19/RN-31/RN-92 + 13 vor-Trigger ->
            RN-32..RN-37/RN-85 + 14 vor-Kampagne -> RN-43..RN-49/RN-86 + 22
            Docs-Zug -> RN-27 + 38 weitere getragene -> je Traeger-Zeile in
            RN-13..RN-75 + RN-87..RN-91); 22 VERTAGT-mit-Traeger
            (Sektion 1.5: V1-V6-Container -> RN-26; V7-V10 -> RN-67; V11-V18 ->
            RN-74 [owner-entschieden]; V19-V21 -> RN-76; V22 deklariert); 34
            GESTRICHEN/UEBERHOLT (Sektion 1.6) -> V10-NEUBEWERTUNGS-PRUEFPOSTEN im
            RN-27-docs-Zug (je Zeile: Beleg noch tragfaehig? sonst Wiederaufnahme
            via #96); 74 REGRESSIONEN (Sektion 5.1 R1-R74) -> Abgleich-Strang RN-17,
            Fenster-Pflichten in RN-19/RN-32/RN-34/RN-35/RN-43..RN-47/RN-57/RN-64;
            +1 Dauer-Fallen-Sammel (15 Klassen) -> Fallen-Register (Dauer); 20
            STATUS-KONFLIKTE (Sektion 3 K-1..K-20) -> RN-17 (K-3 loest RN-03 am
            Objekt; K-16 -> RN-05/P5-Form; K-10 -> RN-27-Marker); 15 TRAEGERLOS
            (Sektion 2) -> JEDER hat jetzt einen Traeger: O1->RN-36 · O2->RN-05 ·
            O3->RN-05 · O4->entlastet (Board lebt, H-30) · O5->RN-26 · O6->RN-27
            (NP-Zug) · O7->RN-28 (#28) · O8->RN-19 (E1-E11-Design) · O9->RN-27 ·
            O10->RN-27 · O11->RN-27 · O12->RN-27 · O13->RN-26 · O14->RN-27 ·
            O15->RN-20 (#57-Design). Endstand-Gate: RN-70.
    24.3.3  P6: #40-NE-REGISTER (38 NE-Posten/20 Auftraege seit W0b). QUELLE: Board-
            Task #40 (+VOLLLISTE 1.4.a-Zeile #40). FENSTER: Triage RN-29 (Di 25.),
            T-UPD-2-Entscheid RN-29 -> Vollzug RN-44 (vor W3), Rest-Slots W4 via
            RN-26/#96. TRAEGER: #40. NUMMERNKREIS-WARNUNG: Board-#40 != v1-Paket
            ##40 (par.7/21.3) — beide leben, getrennt fuehren.
    24.3.4  P7: #130-THESIS-AUFTRAEGE (16 ungetragene aus 26 Kommentar-Commits,
            KOMMENTAR-EXTRAKT.md 740 Z.). FENSTER: W4-Textwelle RN-62, Vorzieh
            RN-56 (Overleaf-Remote, W3-konform); Feinverteilung nach F-16 (RN-05).
            TRAEGER: #130 (+#121/#77). K19-GEGENZAEHLUNG Pflicht: 16/16 -> Traeger-
            zeile, Differenz LEER.
    24.3.5  P10-BAENDER (Wiederaufnahme par.21.3, NIE ausbuchen): 22 (Band B/W1,
            62h) + 37 (B-Rest, ~104,5h) + 5 (Band C, 13h) + 14 (par.13.3-Liste).
            QUELLE: par.21.3 + Wiederaufnahme-Register 0f569c8b + Designplan Tafel
            B. FENSTER: NEU-SLOTTING durch RN-26 (alte WE-22./23.-Anker obsolet):
            22er -> Mo/Di-Randslots (RN-16/RN-31) + W3-[lok] (RN-54); 37er -> W3-
            [lok] (RN-54) + W4 (RN-66); 5er -> WinPCM W2/W4, AmdL3 #87 (RN-36-
            Voraussetzung), MT-L8/PM-PAPI/AG-PunktFixes W4 (RN-66); 14er -> W4/W5-
            Randslots (RN-66/RN-72). TRAEGER: #96.
    24.3.6  GOAL-EIGENE OFFENE POSTEN (13, L-GOAL-Kondensat): G-09->RN-32 · G-12->
            RN-36+RN-05 · G-23->RN-62 · G-37->RN-05+RN-47 · G-41->RN-19 · G-43->
            RN-43 · G-44->RN-43 · G-48->RN-33 · G-50->RN-47 · G-55/D2->RN-31 ·
            G-56/D5-Rest->RN-17-Kontrolle (Soll-Ist fuehrt G) · G-57/D3-4->RN-17-
            Kontrolle (gelandet a558e87c) · G-59->RN-28.
    24.3.7  DESIGNPLAN-OFFENE KLASSEN: T-12a->RN-43 · T-12b->RN-49 · T-12c-geltende-
            Fassung (harter Abbruch) in RN-19-Arena-Tests · T-12d->RN-23 · T-12e->
            RN-31 · D-3->RN-28 · D-4-Testseiten-Pflicht->RN-19/RN-20-Auflage ·
            D-5->RN-31 · D-6->RN-35 · B-1-Rest/D3-1-Marker-Haelfte->RN-31 · PZW-
            Nachzug->RN-01-Auflage · 117er-Summen-Sperre bleibt (neue Posten
            GEZAEHLT daneben, nie eingerechnet).

## 24.4 UEBERHOLT-MARKER 23.08. — VERZEICHNIS

    IM WELLENPLAN AM ORT GESETZT (je "EINPLANUNGS-MARKER 23.08.2026 (par.24)"):
    Kopf Z.9-11 (juengste Konsolidierung = par.24) · 18.3/#38a2-Zeile + 18.6(3)-
    Fallzeile + 23.2-Deklarations-Tafel (P1: Doppel-JA, Bauzug statt Fallweg) ·
    18.4/#7-Zeile (P3-Riss + Neuterminierung) · 19.4/D-08 (P2-Label-Kollision) ·
    20.6/T-NEU-13 (P6-Nummernkreise) · 21.2 (P5: der versprochene Nachtrag = 24.3.2)
    · 21.3-Kopf (Slot-Daten verstrichen -> RN-26) · 22.3-Kopf (Fenster-Stand
    ueberholt; C-3a-Frist-Zeile durch KON120-06 ersetzt) · 22.4-Kopf (Z-Liste durch
    24.3.1 fortgeschrieben) · 23.0 (Stand-Anker HISTORIE; 24.0 gilt) · 23.1-Kopf
    ("bis Fr"-Entscheide verstrichen -> je Posten neuer Termin in 24.1).
    WEITERE WELLENPLAN-INTERNE KANDIDATEN (Marker-Setzung im RN-27-docs-Zug, hier
    benannt): par.13.3-#87 (Stufigkeits-Ordnung) vs Board-#87 (Talos-Lane) =
    Nummernkreis-Kollision ausweisen (L-WELLENPLAN E-8) · par.8-OV-16/17-Zeilen:
    Buchungs-Vermerk nach par.25 (E-9) · par.20.7(2) "WE 22./23. ueberbucht":
    verstrichen, Posten via RN-06/RN-10/RN-16/RN-35 neu geslottet (E-11) · par.9-R-6/
    22.1-U-2/23.3-L-N3 Platten-Zahlen: lebende Werte, vor jedem Vollbau NEU messen
    (E-12, s. 24.5(4)).
    VORSCHLAEGE FUER DIE ANDEREN DREI REFERENZDOKUMENTE (Einbau via RN-27, additiv
    + datiert, Marker AM ORT): GOAL UE-1..UE-9 (L-GOAL Tafel 3; Andockung Tafel 4)
    · Designplan-Kandidaten 1-9 (L-DESIGNPLAN Tafel E; par.13-Nachtrag nach Muster
    par.9-12) · ARBEITSWEISE T4-1..T4-10 (L-ARBEITSWEISE; NUR als B.3-NACHTRAG +
    REGEL-KANDIDATEN, Teil A/V owner-gated, Pflege-Regel 1).

## 24.5 BETRIEBS-KOLLISIONS-AUFLOESUNG (damit der Plan keinen Regelbruch einplant)

    (1) EIN-BLECH/EXKLUSIVITAET (GOAL VII.2): W2-Bau-Fenster Mi-Do und W3-Kampagne
        tragen NULL CI-/Agenten-Last auf prod1. Alle RN-Zeilen der Fenster E/G sind
        entweder Bau-/Kampagnen-Betrieb selbst, [lok]-Posten ohne Landung, reine
        Doku/Design (0 CI) oder Overleaf-Textarbeit. Landungen sammeln sich vor Mi
        26. 06:00 bzw. nach F4.
    (2) SEQUENTIELL LANDEN (O-6/O-8, K26-Aufraeum-Modus): genau EINE Landebahn;
        Reihenfolge RN-01 -> RN-02 -> RN-11 -> Di-25-Zuege einzeln (RN-19..RN-31)
        -> RN-38. Kein gleichzeitiges Mergen; Worktree-Loeschung nur nach rekursiver
        Nested-Pruefung.
    (3) PARALLELITAET nur owner-geordert: Lande-Zug (laeuft), E-10-Bauzug (Owner
        "SOFORT"/Doppel-JA), laufende benannte Agenten. Alles Uebrige sequentiell
        in RN-Reihenfolge.
    (4) 3-VOLLBAU-DECKEL prod1 (A2.1(a2)) + df-Gate <5G (A2.1(a)) rahmen jeden
        Bau-Slot; E-12-Platten-Zahlen vor Vollbauten NEU messen.
    (5) TECHNISCHE DECKEL bleiben (Owner 20.08.): Zeithorizonte uebergehen heisst
        sofort ARBEITEN, nicht Deckel brechen.

## 24.6 VOLLZAEHLIGKEITS-GEGENZAEHLUNG

    P1-P10: 10/10 in RN-Zeilen (24.2). RN-Plaetze: 92 (RN-01..RN-76 + Ergaenzungs-
    Staffel RN-77..RN-84 aus der Quell-Tafel-Gegenzaehlung + Ergaenzungs-Staffel 2
    RN-85..RN-92 aus der Register-Gegenzaehlung). Massen-Bloecke: 7 Unterlisten
    (24.3.1-24.3.7), jede mit Quell-Datei + Fenster + Traeger; innere Zaehler:
    94 (23+68+3) · 156+22+34+74(+1 Sammel)+20+15 · 38/20 · 16 · 22+37+5+14 · 13
    GOAL-Posten · Designplan-Klassen. Leser-Tafel-Posten: L-GOAL 62 (G-01..G-62,
    13 offene einzeln getragen via 24.3.6, Rest AKTIV-Doktrin/Historie) ·
    L-WELLENPLAN ~340 benannte IDs (ueber RN-01..RN-76 + 24.3-Container) ·
    L-DESIGNPLAN 175 Eintraege (117er-Katalog via Baender/24.3.5 + Zusatzklassen
    24.3.7) · L-ARBEITSWEISE 59 Posten (52 je-Vorgang-Pflichten = stehende Doktrin,
    kein Wellen-Platz noetig; O-1..O-5-Status via RN-05/RN-27). Zeilengenaue
    Gegenzaehlung (jeder Quell-Posten -> RN-Zeile; Differenzmenge LEER):
    ~/backups-workflow/20260823-wellenplan-update/EINPLANUNGS-REGISTER.md.
    Naechste freie Nachtrags-Nummer: par.25 (reserviert fuer OV-16/17-Buchung,
    RN-27); par.26 = RN-70-Endstand-Nachtrag falls Differenzmengen nicht leer.

---

# 27. W2-ABSCHLUSS-PFLICHTTAFEL (Nachtrag 24.08.2026 -- Owner-Order 23.08.2026 spaet)

> NUMMERN-DEKLARATION (V12: Gegenstand vor Nummer, naechste FREIE Nummer): par.24.6 (Zeile
> oben, unveraendert) deklariert selbst "Naechste freie Nachtrags-Nummer: par.25 (reserviert
> fuer OV-16/17-Buchung, RN-27); par.26 = RN-70-Endstand-Nachtrag falls Differenzmengen nicht
> leer" -- am Objekt nachgelesen: par.25 traegt bereits reale Reservierungs-Zeilen (Kopf Z.15;
> par.18.3/#38a2-Umfeld Z.2248; par.19.6/RN-27-Umfeld Z.3714-3715/3869; par.22.4-Kopf Z.4195;
> par.24.4 Z.4282; par.24.6 Z.4326 -- alle sechs Stellen zeigen auf denselben Gegenstand
> OV-16/17-Buchung, RN-27); par.26 traegt ebenso zwei reale Reservierungs-Zeilen (par.21.2
> Z.4082; par.24.6 Z.4327) fuer den bedingten RN-70-Endstand-Nachtrag. BEIDE Nummern sind
> damit belegt, nicht nur vorgemerkt. Die naechste FREIE Nummer ist somit **par.27** --
> hiermit gewaehlt und deklariert. par.13-par.24 bleiben unveraendert stehen; was hier steht,
> gilt vor. Bei Widerspruch: Owner-Wort schlaegt alles, Neueres schlaegt Aelteres (18.1-
> Klassenregel, 21.0-NIE-AUSBUCHEN und das #96-Mandat gelten unveraendert weiter).

> QUELLEN dieses Nachtrags (B.3-EINLESE-PROTOKOLL, Datei * Zeilen gelesen/gesamt *
> Kernbefund -- VOLLSTAENDIGE Liste im Beweisort ~/backups-workflow/20260824-w2-abschluss-
> design/ARBEITSSTAND.md): die 4 /goal-Referenzdokumente VOLL (GOAL-v8-Dossier 816/815,
> dieser Wellenplan 4327/4327, Designplan 714/714, ARBEITSWEISE-GESAMT-DOKTRIN 1264/1264) +
> die 2 Rekonstruktions-/Nachverbuchungs-Sessions VOLL (328/328 + 226/226) + die 8
> Schicht-3-Fundstellen VOLL (SYNTHESE-S1-AUDIT 361/361 Zweitfassung, SYNTHESE-S2-AUDIT
> 280/280, GEGENLESE-GATE 297/297, sechs Board-JSONs #89/#131/#135/#136/#137/#138,
> NACHHOL-KARTE 322/322 + GATE 90/90, wyln30o5c-resume2-result-KOPIE.json 108551 B
> python3-strukturiert [sollist+plan_ziele+ergebnisse[Z01..Z27]+endstand=null], ZUG-BILANZ.md
> Abschn. 4+7-9 gezielt [58+300 Z.], EINPLANUNGS-REGISTER 365/365 + VERIFY-BERICHT 111/111).

## 27.0 PFLICHT-DEKLARATION (Owner-Wortlaut, verbatim-Kern, 23.08.2026 spaet)

> "Design bitte mit ultracode aus Rekonstruktion und nachverbuchung mithilfe eines fable 5
> max lesers, der zuerst alle 4 /goal Referenzdokumente kippt und dann den Wellenplan und
> Design nach dem Stand updated und ALLE (auch kleine) Regressionen und Nacharbeiten im
> Wellenplan als Pflicht fuer den Abschluss von Welle 2 verbucht. Das Ziel ist es Welle 1
> und Welle 2 zusammen perfekt abgeschlossen und OHNE JEGLICHE maximal saubere Regression
> an Welle 3 zu uebergeben."

**Was das fuer diesen Nachtrag heisst, drei Saetze:** (1) JEDER offene Posten aus Schicht 3
(F1-F8) -- unabhaengig von seiner urspruenglichen Frist-Etikettierung ("W2", "nach Trigger")
-- wird hiermit als W2-ABSCHLUSS-PFLICHT eingestuft, nicht als Kuer; "nach Trigger" bleibt
als TERMIN gueltig (der Trigger-Output wird gebraucht), aendert aber NICHT den PFLICHT-
Status. (2) Ein Posten OHNE jeden Traeger (weder RN-Zeile noch Board-#) ist hiermit ZUM
ERSTEN MAL getragen -- Traeger = diese par.27-Zeile, bis ein spezifischerer Traeger
(Board-Task, RN-Feinplatzierung) ihn uebernimmt. (3) NICHTS wird zurueckgestellt oder
verschoben: jeder Posten dieser Tafel behaelt seinen Platz bis er BEHOBEN, ENTLASTET (mit
Messung) oder mit einem benannten, aktuellen Owner-Entscheid als "objektiv nach W2" markiert
ist (Kategorie-C-Doktrin par.21.0/21.6 -- W7/Nach-Abgabe bleibt NUR per Owner-Wort moeglich,
niemals per Lead-Ableitung).

## 27.1 DIE DELTA-TAFEL -- QUELLEN-KLASSEN A-J

### 27.1.A REGISTER-VERWEIS: BEREITS RN-GETRAGENE W2-RELEVANTE POSTEN (KEINE DOPPLUNG)

Die 74 R-Posten + 20 K-Status-Konflikte + 15 Traegerlos + 22 Vertagt + 34 Gestrichen/
Ueberholt des EINPLANUNGS-REGISTERs (F8, ~/backups-workflow/20260823-wellenplan-update/
EINPLANUNGS-REGISTER.md) sind ALLE bereits auf RN-01..RN-92 gemappt (Differenzmenge LEER,
VERIFY-BERICHT TRAEGT_MIT_FIXES). Sie werden HIER NICHT neu erhoben. **W2-relevant sind
per Definition alle Posten der FENSTER A-F** (RN-01..RN-50, Zeitraum 23.08.-Rest bis vor
Sa 29.08. 06:00 Kampagnen-Start) -- danach beginnt W3 (FENSTER G), und ein dort noch
offener Posten waere exakt die Regression, die der Owner-Wortlaut oben verbietet. **HIERMIT
DEKLARIERT:** saemtliche RN-01..RN-50-Zeilen dieses Wellenplans sind W2-ABSCHLUSS-PFLICHT
(nicht optional); die urspruengliche Fenster-Zuordnung (A-F) bleibt die Frist, die
PFLICHT-Einstufung wird additiv ergaenzt. Fenster G-J (RN-51..RN-92, Kampagne/W4/W5/W7)
bleiben regulaerer Folge-Wellen-Inhalt, KEINE W2-Regression -- sie werden von dieser
Pflichttafel nicht erfasst, es sei denn ein Fenster-A-F-Posten haengt explizit an ihnen
(dann traegt die Fenster-A-F-Zeile den Verweis, nicht umgekehrt).

### 27.1.B ph89-RESTFUNDE (Board #89, ZUG-Metadata w2_audit_restfunde_23_08; Quelle F4/F2 T11)

| # | Posten | Quelle | Traeger | Frist | Abnahme |
|---|---|---|---|---|---|
| ph89-1 | FUND-1 MILD: Kanon-RICHTUNGS-Gegenlauf `kBegriffsAliasRegistry` vs. M13-Registry (4/7 Gruppen node4/w/ma/mi kanonisch statt SPARSE_NODE4_ART/wallclock/macro/micro; Test Z.87 pinnt Gegenrichtung); Fix-Weg wortfertig: Registry 7->8 Zeilen drehen + `begriffe_disjunkt` + Asserts + CT-Kreuz-Wache, ODER M13-Absorption vorziehen | Board #89 Metadata; F2/T11-2 | M13-Absorptions-/Staffel-3-Zug, VORGEZOGEN vor erste produktive Konsumierung von kBegriffsAliasRegistry (auch Designplan par.13.2) | vor W2-Ende (praeventiv, bevor ein Konsument entsteht) | Registry-Richtung EINMAL fixiert + CT-Kreuz-Wache gruen + 0 Widersprueche gegen M13-Kanon |
| ph89-2 | FUND-2 KLEIN: TDD-Label-Tippfehler T-2->T-3 im Testkopf Z.8 | Board #89; F2/T11-1(Doku) | naechster Datei-Anfasser der Testdatei (S13-04ff/Staffel-3) | Di-25 oder W2-Rest | grep -n "T-2" auf dem Testkopf = 0 Treffer nach Fix |
| ph89-3 | FUND-3 KLEIN: Tippfehler 'daueber'->'darueber' in test_experiment_parser.cpp | Board #89; F2/T11-1(Doku) | dito, gleicher Commit wie ph89-2 | Di-25 oder W2-Rest | grep -n "daueber" = 0 Treffer nach Fix |

Zusatz (bereits RN-getragen, hier nur PFLICHT-Praezisierung): ph89-Ledger-ENTWURF
(p-h-89-ergebnis.md Z.236-241) + Bericht-Nenner-Korrektur 6->7 geaenderte C++-Dateien +
7 Schema-Bedarfe TEIL 6 (Nr.1 an super-Phase, Nr.2-6 an S13-04ff/Staffel-3) -> RN-19/RN-27,
unveraendert; K17-Endstand-Kombibau-Anteil -> RN-01/RN-05(L-05), unveraendert.

### 27.1.C GG2-1-NACHZUG (GEGENLESE-GATE-Korrektur, Quelle F1/F3)

| # | Posten | Quelle | Traeger | Frist | Abnahme |
|---|---|---|---|---|---|
| GG2-1 | Zaehlfehler S1-Quellen-Deckung "53/53" -> **52 Dateien** (messfenster 8 statt 9, s13schema 12 statt 11) -- bereits IM DOKUMENT SYNTHESE-S1-AUDIT.md additiv korrigiert ([KORR-GG2]-Marker + Abschnitt 6); Substanz/Tafel-Urteile unberuehrt | F1 Abschn.6; F3 A.3 | KON122-Ledger-Zug (RN-27) -- Vermerk "S1-Quellen-Deckung 53->52, Zaehlfehler, Substanz unberuehrt" nachziehen, damit die alte "53" nicht in den Ledger wandert | Di-25/RN-27-Zug | Ledger-Zeile traegt "52", kein Widerspruch mehr zur Synthese-Datei |

### 27.1.D VENDOR-O3-REICHWEITEN-OWNER-ENTSCHEID (Board #136 Metadata owner_vorlage_zusatz_o2)

| # | Posten | Quelle | Traeger | Frist | Abnahme |
|---|---|---|---|---|---|
| VO3-1 | NEUFUND o2-umbau 23.08.: `CMAKE_CXX_FLAGS_RELEASE`-Default "-O3 -DNDEBUG" laesst Vendor/FetchContent+Direktblock-Test-TUs effektiv -O3 bauen (**351/643 Treffer, messwirksam** -- Fingerprint-/Vergleichbarkeits-Folge, flagprobe-auswertung.log in ~/backups-workflow/20260822-o2-umbau/). Optionen: (a) Vendor bleibt -O3 (deklarierte SYSTEM-Isolation, kein stiller Dreh) (b) global -O2 (Fingerprint-Neuberechnung noetig) | Board #136 Metadata; ZUG-Session 9c/9d | **OWNER-VORLAGE** -- Zusatzpunkt zur naechsten Owner-Vorlagen-Runde (par.24.1 RN-05, Owner-Vorlagen-Stau); Design-Konsequenz -> Designplan par.13.2 | vor Mi 26. 06:00 (identitaetswirksam: aendert ggf. JEDE Vendor-Binary-SHA) | Owner-Satz (a) oder (b) liegt vor + Beleg-Zeile im F2-Vorlagen-Fenster |

### 27.1.E #135-WORKAROUND-KONFORMITAETS-REGISTER (Board #135, GELOEST!=KONFORM, Owner-Dauerregel 23.08.)

Owner-Dauerregel (Board #135, verbatim-Kern): "Jeder Workaround der CI-16095-
Heilungskette + Lande-Merges wird konform nach Designplan/Wellenplan/GOAL v8 + einschlaegigen
KON-Entscheiden gegengeprueft und BIS ZUM URTEIL als Struktur-Regression gefuehrt." Urteil je
Posten dreiwertig: KONFORM (schliessen+Beleg) / REGRESSION (Heilposten+Frist) / OWNER-
ENTSCHEID (Vorlage). **CI-16101-SUCCESS ist Loesungs-, NIE Konformitaets-Beweis** (GOAL V0:
eine Messung war fuer sich korrekt und beantwortete die falsche Frage). Sieben Posten, KEINER
bisher verdiktet:

| # | Workaround | Gegen-Pruefpflicht | Traeger | Frist |
|---|---|---|---|---|
| W135-1 | vl3-Maskierung Form a/b (b6698eaf) -- maskiert PMU-Prozess-Varianz im Bytegleich-Test statt sie zu beseitigen | gegen Bytegleich-Vertrag pruefen (Designplan T-1/T-4) | Board #135 -> RN-01/RN-27 (KON122-Zug, mit #128) | mit #128, nach S1+S2-Landung, VOR main-FF |
| W135-2 | vl3-Maskierung Form c (b247a339, Define-Flaeche) | dito, plus Doppelboden-Koexistenz-Semantik (7b) pruefen | dito | dito |
| W135-3 | PMC-Stoergroessen-Riegel `COMDARE_PMC_PROBE_AUS` (1f51eb3d) + Riegel-AUSWEIS/NUR-TEST-Deklaration (3841d717) | gegen KON106-PMC-fail-loud-Doktrin + I-PMC-2-Owner-Ausnahme; KON122-L18 "Doppelboden GILT" ist EINGANG, nicht Ersatz der Pruefung | dito | dito |
| W135-4 | B06-Test-Harmonisierung 96a69ba3 (Alt-Kontrakt "CSV entsteht immer" -> OhneUndeklarierteCsv) | gegen KON32-01-SOLL (vermutlich KONFORM, Beleg fehlt noch) | dito | dito |
| W135-5 | TemplateWithUnknownRef tolerant->R-4-hart (ph89, deklariert) | gegen R-4-Owner-Literal pruefen | dito | dito |
| W135-6 | stringop-overflow-Duldung (gcc-15-STL, test_v41, stabil ueber 3 Baeume) | Duldungs-Workaround; Heilpfad = Warnungs-Review-Doppelpass (s. L-06 unten) | dito | dito |
| W135-7 | NSDMI-Fixmuster db66714a (Kandidat KONFORM -- echtes f729b93a-Muster) | Beleg fuehren (voraussichtlich schnellster Abschluss der sieben) | dito | dito |

Zusatz (Prozess-Workaround, kein Objekt-Eingriff, EIGENE Zeile): Z10-Stale-Cache-Prompt-
Patch (bedingter WIEDERANLAUF-Absatz) -- deklarieren als Prozess-Massnahme, kein
Konformitaets-Objekt; keine weitere Pruefpflicht.

### 27.1.F Z11-RAEUMFENSTER-RESTPOSTEN (Board #131 Metadata z11_raeumstand_rekonstruktion_2408)

Z11 selbst ist KOMPLETT VOLLZOGEN (8/8 Strang-Worktrees geloescht, Beweise in
~/backups-workflow/20260822-lande-zug/Z11/) -- die folgenden FUENF Restposten sind KEIN
Wiederholungs-Bedarf, sondern eigene, noch offene Nachfolge-Schritte derselben Raeum-Klasse:

| # | Posten | Traeger | Frist | Abnahme |
|---|---|---|---|---|
| Z11R-1 | 8 bau/*-Branches (bau/s8kopf..bau/kampvor) lokal+origin STEHEN -- Loeschung NUR mit Lead-GO je Branch (Beleg liegt: 8/8 ancestor-rc=0 + CI 16101 SUCCESS) | RN-01/Lead | W2-Ende (nach main-FF) | je Branch Lead-GO-Vermerk + `git branch -d`/`push --delete` rc=0 |
| Z11R-2 | wt-ce-s19 (a1b348ae) + wt-ce-messfenster (3a746090) -- NICHT in der urspruenglichen 8er-Liste, gleiche Raeum-Klasse (beide Tips ancestor-bewiesen) | RN-01/Lead (gleiche Doktrin wie Z11) | W2-Ende | rekursive Nested-Pruefung + `worktree remove` rc=0, Gegenprobe `rev-parse <branch>` weiter trifft |
| Z11R-3 | 4 K17-Endstand-Baeume (build-l1 3.8G/l1-clang/build-dbg 8.1G/dbg-clang) + ccache STEHEN ABSICHTLICH (Beweis-/Wiederanlauf-Wert) | W2-Wellen-Ende-Vollaudit-BU (RN-09) | mindestens bis W2-Vollaudit-BU | BU vollzogen -> Doppel-Bedingung (git ls-files==0 UND find *.csv/*.xlsx==0) -> Raeumung |
| Z11R-4 | wt-ce-lande @ 53c5524e -- Loeschung erst nach Z27 (Zug-Ende, O-6-rekursiv) | RN-01 (Z27) | Zug-Ende | O-6-rekursive Pruefung + `worktree remove` rc=0 |
| Z11R-5 | super-Hauptklon build-l4/ 3.4G (untracked, CMAKE_HOME_DIRECTORY=super/Code -- KEIN Cache der 8 ce-Straenge) | Lead/super-Phase | W2-Ende | Doppel-Bedingung + Raeumung nach super-Gitlink-Bump-Landung |

### 27.1.G CREDITS-RISS: LANDE-ZUG Z12-Z27 (Board #131, alle "agent null" -- NIE gefahren)

Z01-Z11 sind GELANDET+BEWIESEN (ce-Teil des W2-Lande-Zugs, ZUG-BILANZ 8g/9c: TERMINAL,
CI 16101 SUCCESS, 5/5 Full-Join-Endprobe, 544-Nenner literal auf allen 4 Zellen). **Z12-Z27
liefen 24.08. NIE** (agent-Tod durch Credit-Erschoepfung, sollist "offen: 94"). RN-01 traegt
diese Phasen bereits GENERISCH; hier die PFLICHT-Praezisierung je Sub-Ziel mit explizitem
Abnahme-Kriterium (bereits-RN-getragen, KEINE Doppelplatzierung, nur Praezisierung):

| # | Sub-Ziel (Z-Nr.) | Stand 24.08. | Traeger | Abnahme |
|---|---|---|---|---|
| CR-1 | Z12 o2/E-7-Landung | **TEILWEISE GERETTET**: Lead-Rescue-Merge lokal fertig @ **b3dc3e93** (o2-KONTO-Block harmonisiert, Floor 545/541/539 LIVE gemessen, ctest -N "545"); **NICHT gepusht** -- K17-Endstand-Kombibau 4 Zellen + Gates 6/6 + gitleaks stehen aus | RN-01 (Z12) | K17 4/4 Zellen literal 545 + Gates 6/6 + gitleaks + Dual-Push + CI gruen |
| CR-2 | Z13-Z17 super-Phase-Merges (s13schema-super 1e92b77e, cidual 223ab518, vorlagenfenster-Fix a6fa04da, w1luecken-super 8edc34a0, kampvor-super 025e0c42) | UNGELANDET, super dev bei cb38cc9f weitergewandert (docs-only) | RN-01 (Fenster A/B) | 5/5 Merges sequentiell (O-6/O-8), je Gate-Kette, super-CI gruen nach Gitlink-Bump |
| CR-3 | Z18 NP-34-Patch (pmcpaket A-1) | Patch liegt (sha256 60fa5504, 73 Z.), Match-Probe vor Anwendung erneut noetig (super bewegt sich seit 657003bb) | RN-01 (Z12/A-1, PFLICHT AKUT vor Mi 26. per L-01) | Patch angewendet IM SELBEN Commit wie Gitlink-Bump, RAW964=4+RAW1443=4 |
| CR-4 | Z19 Gitlink-Bump ATOMAR + PZW-Nachzug | Gitlink COMMITTED steht noch auf 66de5c09, Arbeitsbaum bereits 3841d717 (normal vor Bump) | RN-01 | Bump-Commit + `sh ci/plan_zahlen_wache.sh` "5 von 5 Ankern decken sich" |
| CR-5 | Z20 KON122-Ledger-Vollzug | L1-L21-Entwurfsblock liegt (KON122-ENTWURFSBLOCK.md, 20:10Z) + L20(a)-Buchungshinweis + LEAD-POINTER-NACHTRAG; **die par.24-RN-01-Referenz "T8b/T8c/T10b/T12b" ist STALE** -- diese Nummern sind Erst-Gate-Numerierung (22.08.), die Zweitfassung (F1/F2) traegt sie heute als L-08b/L-08c/L-09/T12b um-organisiert | RN-01/RN-27 (Lead-only, ledger_nachtrag.sh) | Ledger-Absatz mit AKTUELLEN L-/T-Ankern (nicht den alten T8b/T8c) + KON-Nummer naechste freie |
| CR-6 | Z21 Docs-Pflichtblock (T2/AB-02 SCHON_ENTHALTEN + T3-T13 + GG2/G4/T8b/T8c-Nachfolger) | siehe CR-5 -- dieselbe Nummern-Korrektur gilt hier | RN-01/RN-27 | wie CR-5 |
| CR-7 | Z22 prt-art Phase 3 | pinduo 25bbf2e ZUERST (T9-ERNST-Lande-Bedingung, s. 27.1.I), danach B14 3710ac4c; Hauptklon-Submodul-Store STALE d11781fa (Remote-dev = 777fff7e) -- VOR Phase 3 fetchen | RN-01 | fetch + pinduo-Merge (T9-Auflagen erfuellt) + B14-Merge + echte Branch-CI 6/6 Jobs |
| CR-8 | Z23 #122 SITZT-KLEIN | offen | RN-01/RN-27 | Board-#122-Text-Vollzug |
| CR-9 | Z24 #19 main-FF beider Repos | Rest-Bedingung F-13 (Codex-14-Klassen-Scope) beim Owner (RN-05) | RN-01 (Z24) | F-13-Antwort + main-FF beider Repos vollzogen (V3-Kriterium: "Paket abgeschlossen"-Erkennungszeichen) |
| CR-10 | Z25 W2-Wellen-Ende-Vollaudit-BU | MUSS den Fremd-Ordner `20260821-w1l-landung/cifix2-vl3debug/` (r3/r4/K13/Gates/endstand-pruefer/) MITNEHMEN + V91-A1-Mutationsprotokoll + AB-09/fixstrecke2 + CI-Terminalbelege 16095/16097/16101 | RN-09 | BU additiv gespiegelt, alle 4 Bestandteile literal genannt in der BU-Quittung |
| CR-11 | Z26 Remote-Divergenz-Triage origin 27 vs github 25 | offen (Phase-5-Auflage, P9) | RN-01 (P9) | Divergenz aufgeloest oder mit Beleg entlastet |
| CR-12 | Z27 wt-ce-lande-Loeschung | s. Z11R-4 oben | RN-01 (Z27) | dito Z11R-4 |

### 27.1.H NACHHOL-KARTE N-01..N-48 (Board #136, Opus-6K-Sweep 23.08., TRAEGT_MIT_FIXES 8/8 CONFIRMED)

Quelle: ~/backups-workflow/20260822-opus-6k-sweep/NACHHOL-KARTE.md (322 Z.) + GATE.md (90 Z.).
**Diese 48 Posten sind der par.24-Einplaner-Lauf NICHT bekannt gewesen** (Board-#136-Metadata
wellenplan_landung, woertlich: "der Einplaner-Lauf kannte N-33 nicht"; RN-27's "E-38/E-39-
Zusatzfunde-Sichtung" ist nur die GENERISCHE Ankuendigung, nicht der Vollzug) -- hiermit die
NAMENTLICHE Nachtragung, dichte Form wie im Register selbst (Muster D.10):

N-01(ERRATA-VOLLLISTE 44 Errata additiv in Beweis-Schnappschuss+VERMERK.md, Regel "A3 nie
ohne Z1")->RN-27(P8,docs-Sammel) * N-02(F2-VORLAGEN-FENSTER-ENTWURF 481Z. unversioniert
landen)->RN-27(P8) * N-03(W2-DRIFT-KORREKTUR-DESIGNS 898Z., 0 Traeger-Verweis)->RN-27
(Vermerk in wf_c745729a/#120/#96, war N-33(a)) * N-04(13-Punkte-Selbstbeantwortung, nur 6/13
dem Owner genannt)->RN-27(KON122 5.9,N-08) * N-05(3 W1L-ENTWURF-Zeilen B01/X-11+B03/NE-10-
522er+B13/T-16)->RN-27(KON122-PHASE-5,NAMENTLICH) * N-06(verify-93 3 Ledger-ENTWUERFE C-9-
Bilanz+N5N6-Rest+V93-A1-Verweis)->RN-27(KON122) * N-07(F-A-KON119-Halbsatz+K7b-5-Echo)->
RN-27(KON122) * N-08(10 Nachbuchungs-ENTWUERFE rueckfragen-verbuchung 5.1-5.10, WORTFERTIG,
inkl. 4 Ledger-Nulltreffer)->RN-27(KON122,COPY-FERTIG) * N-09(5 UEBERHOLT-/Erledigt-
Vermerke K-01..K-07)->RN-27(mit N-05..N-08 buendeln) * N-10(3 Quittungs-Nachtraege L9/a11+
X-5-rcu+JB-3-hy-a)->RN-27(H-14) * N-11(F6-Frage "warum doppelt" in K25 beantwortet+#134-
Vollerhebung verbuchen)->RN-27(KON122,1 Absatz; +GATE-NACHTRAG-Kleinst-Zeile F3-Ruege
Z.78226) * N-12(**.stale-Rettung Erfolgspfad**)->**#137** (BEREITS Board-Task, s. 27.1.J) *
N-13(279 tests/unit-TUs ohne -Wall, Test-Welt-Warn-Zug)->NEU(par.27, RN-26/#96-Slot noch
anzulegen) * N-14(V-F3 da_unit-Nenner je Baum 406/406@8edc34a0)->RN-01(an w1luecken-super-
Merge heften) * N-15(name()-Matrix 28->32 ENTSPERRT durch KON120-06(4), Bau-Zeile fehlt)->
RN-26(Di-25-Schnitt,Umfeld #105/V-02R) * N-16(**C1 CT-Bedingungs-Bauliste B1-B8**)->**#138**
(BEREITS Board-Task, s. 27.1.J) * N-17(D-01 Stufe-3 Fable-tief nie gefahren, blockedBy R5)->
RN-91(H-33/D-01-Nachlese) * N-18(D-04 2x georderte Web-Recherche nie gefahren, Vorbedingung
#129)->NEU(par.27, Vorspann-Zeile in #129-Metadata anzulegen) * N-19(C2-Folge-Bau nach R2-
Antwort)->NEU(par.27, Vormerk-Zeile #96, aktiviert durch R2) * N-20(K12-2-Faelligkeit seit
s8kopf-Landung ERHEBBAR, kein Traeger)->RN-13(#22/--debug-CLI-Pruefposten) * N-21(**GN-9-
EINGANGS-KORREKTUR**: --bau-sekunden-je-dll=1282.5 ist 16W-Altwert, ~190x-1500x neben der
letzten realen Messung -- Auflage: GN-9-Lauf reicht IMMER frische Messwerte, NIE 1282.5)->
RN-06(#7-Umfeld,GN-9-Lauf) * N-22(a19-Abnahme-Auflage 5 Delta-Posten D-1..D-5+P-1..P-3 ins
Register eintragen)->RN-26(#96-Registerzug) * N-23(OG-26/OG-28 im W2-ABFOLGE-DESIGN "Traeger
unklar", a19-Praezisierung nicht eingetragen)->RN-27(docs-Zug,H-14/p8) * N-24(Di-25-
NAMENTLICHE Aufnahmen: N-8-HW-Erkennung P4-P6 + K-1-Lager-Identitaet Hybrid-.so, bis heute
nicht belegt in par.22.4)->RN-26(#96-Feinplatzierung,2 Zeilen; K-1 zusaetzlich RN-87) * N-25
(19 Board-Tasks ohne expliziten Unterlisten-Anker, nie gegengeprueft)->RN-26(#96-Pruefzeile)
* N-26(3 Teil-Luecken innerhalb der 22 VERTAGTEN: V5 T-07/T-08 ohne Else-Traeger, V9 Bau-
Haelfte ohne Task, V19 g2-Funde-2-4-Optionen)->RN-26(3 namentliche Zeilen) * N-27(X-17/6c-
Publikation 111 Verdikte ungekuerzt+23-Schritte-Matrix, Register hat kein "6c")->RN-27(Register-
Abschnitt 6c beim Di-25/#128-Umfeld) * N-28(A3-Revision v2: V22->1.6,S34->1.5,Errata-Z1-
Anhang,4 Zaehlfehler ausweisen)->RN-17(#128-Abgleich) * N-29(9-vs-18-Durchzug
simd_organ_requirement, Gate-ERFUELLT vs. Durchzugs-Sachfrage trennen)->RN-17(#128,eigener
Posten) * N-30(X-1 golden-Rest-Refs 3 Branches Bundle+SHA256+Owner-GO + X-11 Nested-Worktree
wf_e22d25ef dirty=17)->RN-26(#96 Di-25, Remote-Loeschung NUR mit Owner-GO) * N-31(S16-
Nullanker "##08-B lazy Header -- NIE BAUEN" ohne Fundstelle/Owner-Votum)->RN-27(docs-Zug
#85-Umfeld) * N-32(T-6-Koeder-Reichweiten-Lehre fehlt im Fallen-Memory)->RN-27(1 Satz in
reference_fallen_register_werkzeuge_und_ci.md) * N-33(WELLENPLAN-Ruecklaeufe (a)-(e) --
**(a) par.24-Nachtrag VOLLZOGEN mit diesem Lauf**, (b) par.18.6(3)/par.23.2 vs KON120-06
bereits korrigiert [par.24-Marker], (c) Z.718 CCD-Korrektur weiterhin offen, (d) O2-Standard-
Owner-Entscheid weiterhin PLAN-LOS [s. Designplan par.13.2], (e) KON60-04-stale weiterhin
auszutragen)->(a) ERLEDIGT DURCH DIESEN NACHTRAG; (c)(d)(e)->RN-27/Designplan-par.13 * N-34
(2 Abweichungs-AUSWEISE: Lande-Reihenfolge-Umstellung W1L->S1->S2 + s13-"beide-Branches-im-
SELBEN-Ereignis"-Bindung gebrochen, nirgends ausgewiesen)->RN-27(KON122,2 Saetze) * N-35
(#131-Phase-2-Text traegt kampvor-super nicht -- **INZWISCHEN VOLLZOGEN** lt. GATE-NACHTRAG,
Board-Drift 131.json mtime 20:37)->ERLEDIGT (Board-Text traegt es bereits) * N-36(V-08/Z-01-
Reste: axis_cross_product-Kenntnisnahme-Vollzugsvermerk + Z-01-Bestaetigung in keine F-Liste)
->RN-27(H-14,mit N-08(5)) * N-37(Quelltext behauptet GESCHLOSSENE Owner-Frage: iterator.hpp:
2957 traegt weiterhin "F8 OFFENE OWNER-FRAGE"; Aequivalenzklassen-Klammer fehlt)->RN-19(S-13-
Bau, Di-25, Datei wird dort ohnehin angefasst) * N-38(ext/A05-jemalloc 3 getrackte MSVC-tlog-
Dubletten zu ext/allocator/A05, fehlt in par.75-Liste)->RN-27(par.75-Liste, `git rm --cached`
NUR nach Beleg-Pruefung) * N-39(RAM-Schwelle des Auswerte-Kontexts ohne Traeger-Spalte)->RN-19
(E1-E11-Arena-/Kanalwerk-Design, explizit spezifizieren) * N-40(NP-04 golden-Fenster-
Kapazitaet nur im Sammel T-UPD-5, keine eigene Zeile)->RN-27(docs-Zug,1 Zeile) * N-41(s7-
Marker smoke_19_1 vermutlich nie gefahren -- s3cmd-ls-Lebendprobe genuegt)->RN-28(#28-Zeile
ODER Betriebszeile) * N-42(P13-Etikett "max. 4 Docks" in 3 Tagesdokumenten nicht ausgetragen,
SECHS ist doppelt owner-gesetzt)->RN-05(Owner-Vorlagen-Vorbereitung,VOR naechster Vorlage) *
N-43(**Project-Access-Token id=99 rotiert SELBST 01.09. 04:03Z**, sonst toter lokaler Store
mitten in der Kampagnenwoche)->RN-36(#84-Infra-Fenster,Betriebszeile SOFORT) * N-44(V-14-
root-Drei-Punkte-Handgriff ist STALE, echte Masse /tmp+/home 80G, root 16-19G/94% vor
Bauwellen)->RN-36/RN-05(F-10,korrigierte Sachlage VOR erneuter Vorlage) * N-45(alter claude-
--resume-Prozess + Monitore bcqxqdilc/bc9dtvlef nie explizit gestoppt-verifiziert)->RN-07
(H-6-Kleinsthandgriffe) * N-46(**B-17: D-10-URSACHEN-Antwort dem Owner NIE gegeben** -- OV-
16/17 waren seit 09.08. GEBAUT, vergessen war nur die Buchung)->RN-27(1 Absatz naechste
Owner-Meldung) * N-47(D-11(b)-Wiedervorlage: 5 Alt-Teilfragen unter Halb-Antwort verbucht,
nie beantwortet -- PA-3,"G13",2 unbenannte Owner-GOs,K-5-Dateien,ETA-avg_size_bytes)->RN-05
(eigene Wiedervorlage-Zeile) * N-48(**R-TAFEL V3 vorlegen** -- Owner-Ruege 85609 "immer noch
nicht alle offenen Rueckfragen verbucht" ist erst damit beantwortet: +R9/+R10,R7-Ratifikation,
Austragungen,korrigierte Etiketten)->RN-05(SOFORT).

**GEGENPROBE (aus GATE.md Sektion 1, selbst nachgezaehlt):** 48 = A:4+B:7+C:10+D:21+E:3+F:3;
Fristklassen 7(vor-Mi-26: N-16-Entscheid,N-21,N-42,N-44,N-46,N-47,N-48) + 11(Di-25: N-03,N-12,
N-15,N-22,N-24,N-25,N-26,N-27,N-30,N-37,N-39) + 26(W2) + 4(nach-Trigger: N-17,N-18,N-19,N-43)
= 48/48. Deckt sich mit obiger Liste (N-12/N-16 sind zwischenzeitlich zu Board-#137/#138
graduiert, zaehlen aber weiter als N-Posten mit).

### 27.1.I S1-LANDE-TIPS L-01..L-20 (SYNTHESE-S1-AUDIT.md Zweitfassung, F1)

**Der par.24-Einplaner kannte nur die Erstfassungs-Numerierung** (RN-01 zitiert "T8b/T8c/
T10b/T12b" -- Erst-Gate-Stand 22.08., s. CR-5/CR-6 oben); die Zweitfassung (23.08., NACH
Compact-Riss neu erstellt) hat ALLE Tips zu L-01..L-20 reorganisiert. Hiermit NAMENTLICH:

L-01(**PFLICHT AKUT**, pmcpaket-NP34-Patch IM SELBEN Commit wie Gitlink-Bump, s. CR-3) *
L-02(VF-Harmonisierung: Lead-Fassung 8ed8b268 fuehrt, Fix-Branch-Block-Tausch D-11/D-12
uebernehmen, KEIN einfacher Merge) * L-03(s13schema-super H-6-Kopplung 1e92b77e, s. CR-2) *
L-04(cidual super 223ab518 landen, s. CR-2) * L-05(**K17-ENDSTAND-KOMBIBAU** am gemergten
ce-Endstand, EINMAL, mit voller Treppe + 7er-J-1-Werkzeugliste literal, deckt zugleich s19-
FUND-2/s8kopf-S8A-01/messfenster-A-1-Komponente-1/s13schema-Treppen-Befund) * L-06(**W2-2
WARNUNGS-REVIEW ZWEIMAL** gcc dann clang am gemergten Endstand; OFFEN-Umfang = Delta
c2da9d1a->66de5c09; deckt die stringop-overflow-Duldung W135-6) * L-07(s19-FUND-1: Hinweis-
Zeile Hybrid-Mehrfach-Aufbau in planner_simulation.hpp, KEIN Blocker) * L-08(a-j: **SAMMEL-
LEDGER-ZUG** -- Kontrollblock-Verdikte, pmcpaket-A-2 7-static_asserts+Board-#82-Korrektur,
verify93-V93-L2-3-Bloecke, vorlagenfenster-ZWOELF-Deltas, ablock-3-Ledger-Haelften, cidual-
F-CD-1/2, s13schema-S13A-F2-Satz, s19-ENTWURF-1/2, messfenster-Register-S5-06, Nummern-
Vorsicht) * L-09(verify93 V93-L1, **VOLLZOGEN mit der Zweitfassung selbst** -- keine weitere
Handlung) * L-10(ablock AB-03: 3 Board-Text-Ergaenzungen HY-B-Stempel-Export+#24-FB20-K-1+
#28-seg4-15) * L-11(ablock AB-04: 12 W-Marker docs-only-Commit, W11 Lizenz zuerst) * L-12
(ablock AB-07: K16-Stopp-Baustein, Traeger-Ort B.0 erst festlegen) * L-13(s8kopf-Nachtraege:
S8A-02-Zeilen-Anker-Korrektur + F-18/S-2-Doppel-Lesarten-Vorlage + K12-2 s. N-20) * L-14(D-12-
Dock-Zahl-Nachzug SECHS + vorlagenfenster-L-3 D-04-Praemissen-Ergaenzung) * L-15(ablock AB-09:
**fixstrecke2-BU 237 Dateien + 8 JB-2-Logs additiv spiegeln**, NEUE gitleaks-Redaktion mit
--config PFLICHT, s. CR-10) * L-16(ablock AB-10: prt-art-Standalone-Klon auf development
drehen, s. CR-7) * L-17(**C-09/T-12a Drift-Gate-Debug-Ausnahme VOR W3**, direkter Anschluss
nach messfenster-Rueckkehr) * L-18(SPERREN: AB-02/05/06 bereits per 38fd6270 vollzogen, NICHT
doppelt einbauen; FINDINGS#13 pinduo-Fassung fuehrend) * L-19(Worktree-/Branch-Lebenszyklus-
Doktrin, deckungsgleich A3-Doktrin) * L-20(getragen ausserhalb: W1-FATAL-Flip, S13-04+X-1..
X-9=Staffel-3, GN-9/O4-Owner s. N-21/VO3, F-71..F-77/F-123/R7=Owner, T-9-Folgewelle,
Uncore-Rechte=Infra, Intel-RAW s. CR-7, #106=Task#106, bau/*-Triage=#19-Umfeld, P5/OG-6=
owner-gated).

### 27.1.J S2-LANDE-TIPS T9..T17 (SYNTHESE-S2-AUDIT.md, F2) + EINZELPOSTEN

T9(**PFLICHT ERNST, LANDE-BEDINGUNG prt-art**: lizenz_audit.hpp `ist_uebersprungenes_
verzeichnis` um exakten Namen 'ce-pin' + Begruendung ergaenzen, K13-Gegenprobe beidseitig,
voller ctest im CI-aequivalenten Layout, Klon-Umzug ABLEHNEN -- s. CR-7) * T9b(**PFLICHT
prt-art**: Landung NUR mit echter Branch-CI, Pin-Log-Beweis aller 6 Jobs + FINDINGS#11-
Allowlist-Beleg literal) * T10(pinduo FINDINGS#13-Doppelbuchung aufloesen, ERLEDIGT-DURCH-
OBJEKT verrechnen) * T10b(pinduo audit-A-1 Zahlen-Hygiene: "58+/5- (Summe 63)") * T10c
(pinduo F-86 registry-roundtrip-Pin-Bump 196a621a->66de5c09, NUR mit XML-Byte-Stabilitaets-
Beleg) * T11(ph89-Restpaket 8 Posten, s. 27.1.B + M13-Absorption + K17 + s13-Bedarfsliste +
Board-#112 + K-3-REST + nach-Trigger-Posten + T-9-Codex-Pass) * T11b(vollzug91-Restpaket 3:
V91-A1-Mutationsprotokoll-Beweisort->W2-Vollaudit-BU, V91-A2-**7er-J-1-Quer-Auflage** [deckt
sich mit L-05/T17], KON-Buchung #91-completed) * T11c(kanalwerk 3: A-KW-1-Wortlaut-
Praezisierung drift_faktor->sicherheitsfaktor, A-KW-2-Ein-Wort-Fix kontext9->kontext8,
Vollzaehligkeits-Warnung BEIDE KLEINs nehmen) * T12(trigfix-Restpaket 5: **#114-B10-
BEWEISLAUF TRIGGER-BLOCKIEREND Frist Mi 26.08. 06:00** [s. 27.1.J E07-Q1 unten], KLEIN-1/2/3-
Haertungen, F-101-Karten-Hygiene) * T13(skip97-Restpaket 2, Strang gelandet: F-106-Folge-Zug
+ Board-#97-Tip-Feld zweistufig nachziehen) * T14(kampvor-Restpaket 5: K-1/T12b-CCD-
Verdopplungs-Semantik-Doku [s. N-33(c)], F-112/F-114-W3-Vorstaffel, F-113-Karten-Hygiene,
P-26/F-C-ci.skip-Nachprobe) * T15(e11-Restpaket 4 KLEIN: E11-A1..A4-Anker-Praezisierungen +
F6-Notiz-Landung 6fe69057) * T16(a19: 0 offene Funde, L1-L6-Uebergabe -- L4 wichtigster:
D-04 owner-beantwortet, KON121-Praezisierung nachziehen) * T17(**Quer-Auflagen**: J-1=7er-
Werkzeugliste literal fuer JEDEN Endstand-Lauf, K17-Vollkombibau EINMAL am Endstand,
Ledger-Referenzen als Zitat+Abschnittsname nicht Zeilennummer, "ein gruenes Gate deckt nur
seinen Gegenstand").

**Einzelposten mit eigenem Board-Traeger (bereits existierend, hier PFLICHT-bestaetigt):**

| # | Posten | Board-# | Frist | Abnahme |
|---|---|---|---|---|
| EP-1 | N-12/.stale-Rettung auf dem Erfolgspfad (`cache_engine_builder_iterator.hpp:3177` ios::trunc ohne .stale-Rettung; Bauform: :2690-Muster fs::rename spiegeln) | **#137** | Di-25-Schnitt, Bau VOR Kampagne Sa 29. (teuerster Messdaten-Posten) | Erfolgspfad rettet vor trunc nach .stale, Test/Koeder gefahren |
| EP-2 | N-16/C1 CT-Bedingungs-Gates B1-B8, Umfang-Entscheid vor/nach Trigger (identitaetswirksam, faellt MIT #91/D-08) | **#138** | Entscheid vor Mi 26. 06:00; Bau je nach Entscheid | Entscheid dokumentiert + (falls vor Trigger) Bau vollzogen |
| EP-3 | #114 E07-Q1-Default-A-Re-Run (<1h, Rezept b10-beweislauf/BEWEIS.md Par.9) auf der FINAL eingefrorenen Trigger-Linie | RN-34 (bereits registerseitig getragen) | VOR Mi 26.08. 06:00 | Re-Run gefahren, Ergebnis im #131-Endstand-Anhang |

## 27.2 VOLLZAEHLIGKEITS-GEGENZAEHLUNG

    Quellen-Klassen A-J: A (Register-Verweis, 165 bereits-RN-Posten, keine Doppelung) +
    B (ph89, 3) + C (GG2-1, 1) + D (Vendor-O3, 1) + E (#135-Workaround, 7+1) + F (Z11-
    Restposten, 5) + G (Credits-Riss Z12-Z27, 12 Sub-Ziele) + H (NACHHOL-KARTE, 48) + I
    (S1-Tips L-01..L-20, 20) + J (S2-Tips T9..T17 mit Unterpunkten, 14 Traeger-Zeilen +
    3 Einzelposten). NEU in dieser Tafel (nicht vorher RN- oder Board-getragen): N-13,
    N-18, N-19 (3 Stueck, s. 27.1.H) -- diese DREI sind AB SOFORT ueber diese par.27-Zeile
    getragen, bis ein spezifischerer Traeger (Board-Task-Anlage) sie uebernimmt. ALLE
    anderen Posten dieser Tafel referenzieren einen BESTEHENDEN Traeger (RN-x oder
    Board-#) -- Doppelplatzierung damit vermieden (Owner-Auflage "Querverweise statt
    Doppelung"). Kein Posten dieser Tafel ist traegerlos.

## 27.3 W2-ABSCHLUSS-GATE

!! **Welle 2 gilt ERST als abgeschlossen, wenn diese Tafel (27.1.A-J) LEER ist ODER jeder
verbleibende Rest ein DOKUMENTIERTER, AKTUELLER Owner-Entscheid ist** (Kategorie-C-Doktrin,
par.21.0/21.6 -- niemals eine Lead-Ableitung). Die Pruefung selbst ist eine
Differenzmengen-Beweis-Pflicht, kein stilles Verschieben:

1. **Vor der W2-Freitags-Lieferung (RN-42, Fr 28.08.)**: die Tafel wird gegen den dann
   lebenden Objekt-/Board-Stand GEGENGEZAEHLT (Muster VERIFY-BERICHT.md/GATE.md dieses
   Nachtrags) -- jeder BEHOBEN-Posten faellt mit Beleg heraus (nie stillschweigend, V6.10),
   jeder verbleibende Rest bekommt entweder einen frischen Termin INNERHALB W2/vor Sa 29.
   ODER einen ausdruecklichen Owner-Satz fuer "objektiv nach W2".
2. **Kein Rest ohne Grund.** "War frueher schon offen" ist KEIN Grund -- die NIE-KUERZEN-
   Doktrin (par.21.0) verlangt einen NEUEN, benannten Grund je Rest-Zeile (Wellen-Platz +
   Traeger + Frist), sonst gilt der Posten als unbearbeitet.
3. **Das Gate prueft ZWEI Mengen, nie eine:** die Menge der urspruenglich 48+20+... Funde
   dieser Tafel UND die Menge der tatsaechlich am Objekt behobenen/entlasteten -- beide
   werden genannt (V-8-Doktrin, ein gruenes Gate deckt nur seinen Gegenstand).
4. **Die #135-Konformitaets-Verdikte (27.1.E) sind ein EIGENER Teil des Gates:** ein
   CI-gruener Endstand allein genuegt NICHT -- jeder der sieben Workarounds braucht sein
   KONFORM/REGRESSION/OWNER-ENTSCHEID-Urteil, sonst ist "geloest" nicht dasselbe wie
   "konform" (Owner-Dauerregel 23.08., Board #135).
5. **Traeger dieses Gates:** Lead, spaetestens im #128-Soll-Ist-Abgleich (RN-17/RN-70,
   W4-Schluss-Gate) -- aber die Erst-Pruefung findet HIER statt, am Ende von W2, nicht
   erst am Ende von W4 (sonst waere die Regression laengst nach W3 durchgereicht, exakt
   das, was der Owner-Wortlaut oben ausschliesst).

Querverweis: Designplan `docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-wellen.md`
par.13 traegt diesen Gate als Vertrags-Punkt der Testseite (T-13-Klasse, Workaround-
Konformitaets-Pruefpflicht) -- s. dort.

## 27.4 FABLE-MAX-ABNAHME DES par.27-NACHTRAGS (24.08.2026) -- ADDITIVE KORREKTUREN + ERGAENZUNGEN

ANLASS (Lead-Order 24.08. ~08:00Z, Cache-Invalidierung): der Erst-Lauf dieses Nachtrags
(Commits fc804971 par.27 / 6400f6dc Designplan-par.13 / 0c6ee745 Marker) fiel durch einen
automatischen Credits-Fallback auf ein NIEDRIGERES Modell -- ordnungswidrig gegen die
Owner-Order "Design IMMER mit Fable 5 max" (Memory-Anker
feedback_stempel_strecke_immer_fable5_max_alle_workflow_teile / A1-Matrix Design-Zeile).
Die Hinterlassenschaft bleibt ADDITIV stehen (Doku wird deprecatet, nie geloescht); dieser
Abschnitt ist die Fable-5-max-ABNAHME am Objekt: Fehlendes ergaenzt, Falsches mit
UEBERHOLT-Vermerk + korrekter Zeile DANEBEN, Richtiges unveraendert.

PRUEFUMFANG (Nenner, selbst gemessen 24.08.):
  * Eigene VOLL-Einlesung ZUERST, unabhaengig vom Erst-Lauf-Protokoll (Owner-Ausnahme:
    die 4 /goal-Referenzdokumente VOLL): GOAL-v8 816/815 * dieser Wellenplan 4690/4690
    (inkl. par.27 selbst) * Designplan 829/829 (Worktree-Fassung) * ARBEITSWEISE-GESAMT-
    DOKTRIN 1264/1264. Schicht 2: 328/328 + 226/226. Schicht 3: 361/361 * 280/280 *
    297/297 * 6 Board-JSONs * 322/322 + 90/90 * Result-JSON 108551 B python3-strukturiert
    * ZUG-BILANZ Abschn. 4 + 7-9 (58+300 Z.) * 365/365 + 111/111.
  * Zeilenpruefung der drei Erst-Lauf-Commits am Objekt: 478/478 Insertionen geprueft
    (352 + 106 + 20), 0 Deletionen -> Additivitaet HAELT.
  * ERGEBNIS: 6 inhaltliche Korrekturen (K-A..K-F) + 1 Form-Korrektur + 10 Ergaenzungen
    (E-01..E-10). Alle uebrigen Zeilen des Erst-Laufs TRAGEN am Objekt unveraendert --
    insbesondere die Quellen-Klassen 27.1.B (ph89), 27.1.C (GG2-1), 27.1.D (Vendor-O3),
    27.1.E (#135, sieben Posten), 27.1.F (Z11R-1..5) und 27.1.H (48 N-Posten,
    Fristklassen 7/11/26/4) sind am Objekt EXAKT bestaetigt.

### 27.4.0 FORM-KORREKTUR (eigene Arbeit dieses Workflows, kein Bestands-Eingriff)

par.27.3-Kopfzeile trug EIN Non-ASCII-Zeichen (U+1F534) -- Verstoss gegen die ASCII-only-
Auflage DIESES Workflows. Geheilt: Zeichen durch "!!" ersetzt, Satz sonst byte-gleich.
Gegenprobe: Non-ASCII-Zeilen ab Z.4340 = 0 (vorher 1); der Bestand des Dokuments fuehrt
1375 Non-ASCII-Zeilen als HISTORIE -- die sind NICHT Gegenstand dieser Auflage und bleiben
unberuehrt.

### 27.4.1 KORREKTUREN (je: UEBERHOLT-Vermerk auf die Erst-Lauf-Zeile + korrekte Fassung daneben)

**K-A [Nummern-Deklaration, 27.4-Kopfblock oben in diesem Paragraphen]** -- die WAHL par.27
TRAEGT unveraendert (par.25 UND par.26 sind belegt), zwei ihrer BELEGSTELLEN sind es nicht:
  * UEBERHOLT: "par.18.3/#38a2-Umfeld Z.2248" als par.25-Stelle. Am Objekt traegt Z.2248
    den EINPLANUNGS-MARKER zu KON120-06 OHNE par.25-Bezug (grep "par\.25" trifft dort nicht).
  * GILT: par.25 hat SECHS reale Fundstellen (Kopf-Marker "par.25 ist fuer die OV-16/17-
    Buchung reserviert (RN-27)" * par.24-Kopf-Nummerndeklaration "faehrt als **par.25** im
    Di-25-docs-Zug" * RN-27-Zeile "par.25 = OV-16/OV-17-BUCHUNG" * par.22.4-Kopf-Marker *
    par.24.4 "Buchungs-Vermerk nach par.25 (E-9)" * par.24.6 "Naechste freie Nachtrags-
    Nummer: par.25"). Zeilennummern bewusst NICHT zitiert (V14: sie sind allein durch den
    0c6ee745-Marker um +11 gedriftet) -- die WORTLAUT-Anker oben sind die Belege.
  * UEBERHOLT: "par.26 traegt ... zwei reale Reservierungs-Zeilen (par.21.2 Z.4082 ...)".
    Am Objekt liegt diese Stelle in **par.24.1/RN-70** ("sonst namentlich in par.26-
    Nachtrag"), NICHT in par.21.2; der par.21.2-Marker verweist auf par.24.3.2.
  * GILT: par.26 hat ZWEI reale Stellen -- RN-70 (W4-Schluss-Gate) und par.24.6
    ("par.26 = RN-70-Endstand-Nachtrag falls Differenzmengen nicht leer"). Beide Nummern
    bleiben belegt; par.27 ist die naechste freie Nummer (V12: Gegenstand vor Nummer).

**K-B [27.1.H, N-33-Zeile]** -- UEBERHOLT: "(a) par.24-Nachtrag VOLLZOGEN mit diesem Lauf"
bzw. "(a) ERLEDIGT DURCH DIESEN NACHTRAG".
  GILT: N-33(a) ist durch den **par.24-EINPLANUNGS-NACHTRAG vom 23.08.** erledigt --
  geschrieben vom Einplaner-Lauf wf_c745729a (Commit-Kette 99a16a38 -> 577bc1b2 ->
  b0eafbb6 -> fdfb5d9d, Beleg: EINPLANUNGS-REGISTER-Kopf "OBJEKT ... Commits:
  99a16a38 (par.24-Nachtrag RN-01..RN-76 ...)"). par.27 vollzieht N-33(a) NICHT; er setzt
  darauf auf. (Die NACHHOL-KARTE mass zu ihrem Stand 20:15 korrekt "par.24 = 0 Treffer" --
  der Nachtrag entstand DANACH.) N-33(b) bleibt bereits-korrigiert, N-33(c)/(d)/(e)
  bleiben offen wie im Erst-Lauf gefuehrt.

**K-C [27.2, Zaehlwerk-Satz "NEU in dieser Tafel"]** -- UEBERHOLT: "N-13, N-18, N-19
(3 Stueck) ... nicht vorher RN- oder Board-getragen".
  GILT: alle drei stehen NAMENTLICH im Board-**#136**-Text, Abschnitt (7) ("N-13
  (Test-Welt-Warn-Zug 279 TUs ohne -Wall), ... N-18 (#129-Vorspann: 2x georderte
  WEB-RECHERCHE nie gefahren), N-19 (C2-Folge-Bau gated R2)"). Sie sind damit
  SAMMEL-getragen; was fehlt, ist der SPEZIFISCHE Traeger (eigener Board-Task bzw.
  RN-Feinplatzierung) -- den vergibt par.27 hiermit (E-08 unten). Die Aussage "kein
  Posten dieser Tafel ist traegerlos" wird dadurch STAERKER, nicht schwaecher; korrigiert
  wird allein ihr Nenner.

**K-D [27.1.J, T12-Zeile "#114-B10-BEWEISLAUF ... [s. 27.1.J E07-Q1 unten]" + EP-3]** --
UEBERHOLT: der Querverweis, der beide Laeufe als EINEN Gegenstand liest.
  GILT: es sind **ZWEI** Laeufe desselben #114-Komplexes, beide mit Frist Mi 26.08. 06:00:
  (i) **B10-BEWEISLAUF** (S2-Tip T12-1): B5.b-Emitter, Mini-Profil <= 8 Binaries,
      XML-Differenz-Laeufe je Achsen-Familie, emittiert die ECHTEN E07_*-Zeilen -- "erst
      damit kann das Gate GO werden"; eigener Traeger/Agent (p12-b10-beweislauf);
  (ii) **E07-Q1-DEFAULT-A-RE-RUN** (Board-#131-Metadata e07_q1_rerun + ZUG-BILANZ
      Abschn. 4 "#114-VORBEHALT danach"): <1h, Rezept b10-beweislauf/BEWEIS.md Par.9, auf
      der FINAL eingefrorenen Trigger-Linie; der Vorlauf dieses Laufs "bewies trigfix
      0f900dcf (Basis 66de5c09)" -- er ist also eine WIEDERHOLUNG auf neuer Linie.
  ABNAHME: ob EIN Lauf beide Zwecke erfuellt, ist AM OBJEKT (BEWEIS.md Par.9) zu
  entscheiden und zu protokollieren -- nicht anzunehmen. Traeger unveraendert: RN-34 +
  #114/#131-Endstand-Anhang.

**K-E [27.1.G-Kopf, CR-Tafel]** -- PRAEZISIERT (kein Sachfehler, aber Nenner-Pflicht):
  Die Zuordnung der Z-NUMMERN Z13..Z27 zu ihren Gegenstaenden ist im Result NICHT belegt:
  dort tragen Z12-Z27 nur die Kennung ("FEHLER | Z13" usw.), und die workflowProgress-
  promptPreviews sind auf je 401 Zeichen gekuerzt und enthalten KEINEN Zieltext (selbst
  nachgemessen 24.08.). BELEGT ist allein **Z12 = o2/E-7** (Agent a745560ba5c2f0c3b,
  lastToolSummary "cd /home/comdare/wt-ce-o2std && git show f82dfaeb --stat").
  Die GEGENSTAENDE der CR-2..CR-12 sind ihrerseits vollstaendig belegt (Board-#131-
  Phasenliste + sollist.offene_posten_kurz 14 Zeilen + ZUG-BILANZ Abschn. 4/9d) -- nur die
  NUMMERNZUORDNUNG ist eine Ableitung. V12 gilt: Gegenstand vor Nummer; beim Zug-Resume
  ist die Nummerierung am Script zu verifizieren, nicht aus par.27 zu uebernehmen.

**K-F [27.2, Klasse J]** -- PRAEZISIERT: "J (S2-Tips T9..T17 mit Unterpunkten, 14 Traeger-
  Zeilen + 3 Einzelposten)" nennt den Traeger-Zaehler ohne den Posten-Nenner.
  GILT: die S2-Restmenge ist **38 Posten** (ph89 8 + pinduo 8 + kanalwerk 3 + vollzug91 3
  + trigfix 5 + skip97 2 + kampvor 5 + e11 4 + a19 0), getragen ueber 14 T-Zeilen --
  Zaehlwerk unabhaengig bestaetigt durch GEGENLESE-GATE Teil I A.1 ("S2 38 Rest-Posten
  (8+8+3+3+5+2+5+4+0) gegen T9..T17 -- 0 traegerlos").

### 27.4.2 ERGAENZUNGEN -- W2-ABSCHLUSS-PFLICHT (Posten ohne Platz im Erst-Lauf)

| # | Posten | Quelle | Traeger | Frist | Abnahme-Kriterium |
|---|---|---|---|---|---|
| E-01 | **T9b-CAVE SPANNUNG-5**: ob die bestehende Allowlist-Eintragung (287->ce) die FUENF neu gepinnten prt-art-Jobs automatisch deckt, ist in KEINER Quelle bestaetigt; greift sie nicht, ist die Allowlist-Einrichtung ein ZUSAETZLICHER Schritt VOR der Branch-CI | F2/T9b (soll-karte SPANNUNG 5) | RN-01 (prt-Phase, CR-7) | vor der prt-art-Branch-CI | Allowlist-Deckung am Objekt gemessen (deckt/deckt nicht) + literaler Beleg; bei "deckt nicht": Einrichtung VOR der CI vollzogen |
| E-02 | **L-01-Zusatz F-40-Umhaengung**: die F-40-Fehl-Platzierung an BEIDEN Stellen der alten STAFFEL1-SYNTHESE.md ("Phase 4 -- Nachlanden" + "Folgepakete") auf die super-Lande-Phase umhaengen -- gehoert in denselben Zug wie der NP-34-Patch | F1/L-01 (zweiter Halbsatz) | RN-01 (CR-3, mit dem Gitlink-Commit-Zug) | vor Mi 26. 06:00 | beide Stellen tragen den super-Lande-Phase-Vermerk; Gegenprobe: 0 Rest-Treffer der alten Platzierung |
| E-03 | **PmcProbeLebtOhneRiegel-MERKPOSTEN** ins Fallen-Register: die EINZIGE Stelle des Lande-Zugs, die im CI wieder von der Runner-PMU abhaengt -- kippt ein kuenftiger CI-Lauf genau dort, ist das ein **BEFUND, kein Testfehler** (Entschaerfungs-Nachtrag: `probe_gefahren=true` vor allen vier Rueckgabepfaden, damit strukturell lage-/PMU-unabhaengig) | ZUG-BILANZ 7c-Warnung + 9d-Merkposten (TEIL2 (d) 3) | RN-27 (Fallen-/Memory-Zug, Lead-only) -- am Objekt 0 Treffer im Wellenplan | Di-25-docs-Zug | Fallen-Register traegt den Satz; Gegenprobe grep im Memory-Register > 0 |
| E-04 | **prt-art `bau/prtart-ladeweg-w0a` DIVERGIERT** origin 7c0c9975 vs. github a782c56e (Alt-Bestand, kein Zug-Gegenstand) -- ZWEITE Remote-Divergenz neben der ce-Divergenz (origin 27 vs. github 25, CR-11) | ZUG-BILANZ 9a (prt-art-Zeile) | RN-01 (Phase-5-Auflage, neben CR-11) | W2-Ende | Divergenz aufgeloest ODER mit Beleg als Alt-Bestand entlastet (beide Mengen genannt) |
| E-05 | **Board-#134** (Spiegel der gerissenen Straenge + Workflow-Vollerhebung 698 Laeufe; Heilungs-Workflow GATED auf "alle laufenden Workflows terminal") traegt KEINE RN-Zeile -- das EINPLANUNGS-REGISTER schliesst neue Tasks ausdruecklich aus seinem Nenner aus (Vermerk V-4) | Register V-4 + NACHHOL-KARTE Pfad-Plan | RN-26 (#96-Feinplatzierung) + par.27 bis dahin | Di-25-Schnitt | #134 traegt eine namentliche RN-/Slot-Zeile; Gate-Bedingung "alle WF terminal" gemessen |
| E-06 | **N-03-VOLLZUG (hiermit)**: W2-DRIFT-KORREKTUR-DESIGNS.md (898 Z., 8 Voll- + 7 Kurz-Designs + Zug-Ordnung, `~/backups-workflow/20260821-ultracode-explore/`) ist hiermit NAMENTLICH im Wellenplan verankert und PFLICHT-INPUT der Di-25-/W2-Zuege -- Risiko sonst: die Designs werden neu erarbeitet statt gehoben | NACHHOL-KARTE N-03 (Traeger-Vorschlag "EINE Zeile im Wellenplan-par.24-Nachtrag") | par.27 (diese Zeile) + Verweis in #120/#96-Metadata | Di-25 | RN-19/RN-26/RN-31-Zuege zitieren die Designs vor Neubau; Gegenprobe: Wellenplan-grep "W2-DRIFT" > 0 (heute erfuellt) |
| E-07 | **K17-Endstand-Falle EXCLUDE_FROM_ALL**: die drei `*_registry_gen` (axis/measurement_axis/system_axis) sind EXCLUDE_FROM_ALL -- **nur die explizite J-1-Zeile deckt sie, ein "all"-Gruen beweist sie NICHT**; dazu das reale Facade-Target `comdare_profile_run_facade` (Alias "comdare_facade" existiert NICHT, ninja-RC=1, dreifach unabhaengig belegt) | F1/L-05 + F2/T11b-2/T17-1 | RN-18 (J-1-Rezeptfix) + RN-01 (K17-Endstand-Kombibau) | vor jedem Endstand-Lauf | J-1-Zeile mit den SIEBEN Werkzeugen LITERAL im Protokoll + Facade ueber das reale Target; Gegenprobe: kein "all"-Gruen als Ersatz-Beleg zitiert |
| E-08 | **Spezifische Traeger fuer N-13 / N-18 / N-19** (bisher nur Sammel-Traeger #136(7), s. K-C): N-13 Test-Welt-Warn-Zug (279 tests/unit-TUs ohne `-Wall`, 2 Stufen gcc->clang nach Warnungs-Review-Doktrin) * N-18 D-04-WEB-RECHERCHE (zweimal geordert, nie gefahren -- Vorbedingung des #129-Designs) * N-19 C2-Folge-Bau (Testnamen-Union + `realm_axis_version_stamp.hpp`, aktiviert durch R2) | NACHHOL-KARTE N-13/N-18/N-19 + Board-#136(7) | RN-26 (#96) legt je einen Board-Task/Slot an; N-18 zusaetzlich als Vorspann-Zeile in #129-Metadata | Di-25 (Anlage); Bau je Fristklasse (N-13 W2, N-18/N-19 nach Trigger) | drei namentliche Traeger existieren; #136(7) verweist auf sie statt sie zu ersetzen |
| E-09 | **trigfix-KLEIN-1 ist GELANDET, nicht offen**: die `ersetze()`-npos-Haertung (`pos = (nl == std::string::npos) ? proto.size() : nl + 1;`) sitzt am Endstand -- Verursacher **a84f1119** (Audit-r1-Fix IM Lande-Zug, ZUG-BILANZ 8a-Tafel, Zeile 1 der vier attribuierten Deltas). Die S2-Synthese fuehrt sie noch als offen, weil sie den Lande-Zug-Fix nicht kannte. OFFEN bleiben allein **KLEIN-2** (`setze()` end()-Guard, e07_gate_kriterien.hpp) und **KLEIN-3** (Testname/Variable "Unguelig" -> "Ungueltig") | ZUG-BILANZ 8a gegen F2/T12-2 | RN-31 / T-9-Codex-Pass (KLEIN-2/-3); KLEIN-1 = ERLEDIGT-DURCH-OBJEKT | KLEIN-2/-3: W2-Rest bzw. T-9-Folgewelle | KLEIN-1 mit Commit-Beleg als erledigt verbucht (nie erneut gebaut); KLEIN-2/-3 je eigener Ein-Zeilen-Fix + Gegenprobe |
| E-10 | **FLOOR-GATE-UMSTELLUNG mit der o2-Landung**: der Endstand-Beweis fuehrt "Floor-Anker 544/540/538 bleibt gueltig" und Gate [5/6] als "544 == 544"; der Lead-Rescue-Merge **b3dc3e93** hebt ihn per +1-Regel (`test_o2_standard_opt_default`) auf **545/541/539** (LIVE `ctest -N` "Total Tests: 545"). Beim Push dieses Merges MUSS `scripts/ci_test_inventory_floor.txt` mitgezogen und die Gate-Erwartung auf 545 umgestellt werden -- sonst faellt Gate [5/6] falsch-rot bzw. deckt den falschen Nenner | ZUG-BILANZ 9b vs. Session-Nachverbuchung 9b (o2-Merge) | RN-01 (CR-1, im selben Zug wie K17 4/4 + Gates 6/6) | vor dem Dual-Push von b3dc3e93 | Gate [5/6] literal "545 == 545"; alle vier K17-Zellen literal 545; Floor-Restore byte-gleich |

### 27.4.3 GEGENZAEHLUNG DIESER ABNAHME (beide Mengen genannt, V-8)

    GEPRUEFT:      478/478 Insertionen der drei Erst-Lauf-Commits (352 par.27 + 106
                   Designplan-par.13 + 20 Marker), 0 Deletionen.
    KORRIGIERT:    6 inhaltlich (K-A Belegstellen der Nummern-Deklaration * K-B
                   N-33(a)-Zuschreibung * K-C Nenner der "NEU"-Aussage * K-D
                   B10-Beweislauf vs. E07-Q1-Re-Run * K-E Z-Nummern-Belegbarkeit *
                   K-F J-Klassen-Nenner) + 1 formal (ASCII).
    ERGAENZT:      10 Posten (E-01..E-10), alle mit Gegenstand/Quelle/Traeger/Frist/
                   Abnahme; davon 3 am Objekt zuvor OHNE jeden Wellenplan-Treffer
                   (E-03 PmcProbe, E-04 prtart-ladeweg, E-05 #134) und 1 hiermit
                   VOLLZOGEN (E-06/N-03).
    UNVERAENDERT:  alle uebrigen Zeilen des Erst-Laufs -- 27.1.A (Fenster-A-F-Deklaration),
                   27.1.B (ph89-1/-2/-3), 27.1.C (GG2-1), 27.1.D (VO3-1), 27.1.E (W135-1..7
                   + Prozess-Zeile), 27.1.F (Z11R-1..5), 27.1.G (CR-1..CR-12 in der Sache),
                   27.1.H (N-01..N-48 inkl. Fristklassen 7/11/26/4), 27.1.I (L-01..L-20),
                   27.1.J (T9..T17 + EP-1/EP-2/EP-3), 27.2, 27.3 (Gate).
    OFFEN GEBLIEBEN (nicht einplanbar, mit Grund): s. Ergebnis-Rueckgabe dieses Laufs --
                   die Z13..Z27-Nummernzuordnung bleibt bis zum Zug-Resume eine Ableitung
                   (K-E), und die Frage "ein Lauf oder zwei" bei #114 (K-D) ist ein
                   OBJEKT-Entscheid des Traegers, kein Planungs-Entscheid.

**Damit gilt das par.27-Design als von Fable 5 max abgenommen** -- die Erst-Lauf-Substanz
traegt, die sechs Korrekturen stehen additiv daneben, die zehn Ergaenzungen sind eingeplant.
Das W2-ABSCHLUSS-GATE (27.3) gilt unveraendert und erfasst 27.4.2 mit.

## 27.5 FABLE-MAX-ABNAHME FAHRT 3 + DRITT-ABGLEICH-NACHTRAG (24.08.2026, 11:3x-12:1x UTC)

ANLASS (Lead-Order 24.08. ~08:25Z, zweite Cache-Invalidierung): Die Abnahme-Fahrt, die
par.27.4 und Designplan-par.13.4 schrieb (Commits 302e4d7e + f79d4192), fiel um 07:59:57Z
STUMM auf Opus 5 (Consent-Prompt-Mechanik in Background-Sessions) -- ihre ABNAHME-Vermerke
sind damit provenienz-tainted und galten NICHT als Fable-Vollzug. Diese dritte Fahrt lief
nach gespeicherter Fable-Consent-Wahl; ALLE Legacy-Zeilen (478 des Sonnet-Erst-Laufs + 223
der Fahrt 2 = 701) wurden am Objekt neu geprueft, ALLE Quellen selbst voll gekippt
(B.3-Protokoll: ~/backups-workflow/20260824-w2-abschluss-design/ARBEITSSTAND.md, Abschnitte
"FAHRT 3"). Die Fahrt-2-Texte bleiben additiv stehen; dieser Abschnitt uebernimmt sie, wo
sie tragen, und schreibt den Stand fort, wo die Quellen seither GEWACHSEN sind.

### 27.5.1 ZEILENPRUEFUNGS-URTEIL (701/701 am Objekt)

**ALLE 6 Korrekturen K-A..K-F und alle 10 Ergaenzungen E-01..E-10 der Fahrt 2 sind am
Objekt BESTAETIGT** (je eigener Beleg dieser Fahrt): K-A per grep (par.25 = SECHS
Wortlaut-Stellen, Z.2248 traegt den KON120-06-Marker OHNE par.25-Bezug; par.26 = ZWEI
Stellen RN-70 + par.24.6) * K-B per Register-Kopf ("Commits: 99a16a38 (par.24-Nachtrag
RN-01..RN-76 ...)" = Einplaner-Lauf) * K-C per Board-#136 Abschnitt (7) (N-13/N-18/N-19
namentlich) * K-D per #131-Metadata e07_q1_rerun + T12-1 + ZUG-BILANZ Abschn. 4 (ZWEI
Laeufe) * K-E per python3-Strukturlektuere des Result-JSON (Z13-Z27 ohne Zieltext) * K-F
per GEGENLESE-GATE A.1 (S2 = 38 Rest-Posten) * E-01..E-10 je an F1/F2/ZUG-BILANZ/Register/
Board nachgewiesen; ASCII ab Z.4340 = 0 nachgemessen. ZUSATZ-BELEG zu E-09: auch der
Z07-ZIELTEXT des Lande-Zug-Results fuehrt die npos-Haertung woertlich ("inkl. der im
Auftrag benannten ersetze()-npos-Haertung (KLEIN-1)") -- E-09 gilt damit AUCH gegen den
juengeren S2-DRITT-ABGLEICH, der KLEIN-1 in seiner trigfix-Zaehlung weiterhin als offen
fuehrt (dort nicht nachgezogen); real offen bei trigfix: KLEIN-2, KLEIN-3, KLEIN-4/F-147.
**0 Fehler in den Fahrt-2-Urteilen gefunden; die Substanz von 27.4 gilt hiermit als von
Fable 5 max geprueft und uebernommen.**

### 27.5.2 DELTA-TAFEL FAHRT 3 -- STATUS-FORTSCHREIBUNGEN AUS DEN GEWACHSENEN QUELLEN

Die beiden Synthese-Dateien sind seit der Task-Formulierung GEWACHSEN und keiner Vorfahrt
bekannt gewesen: SYNTHESE-S1-AUDIT.md 361 -> **654** Zeilen (Abschnitt 7 "DRITT-ABGLEICH
24.08.", Z.364-655) und SYNTHESE-S2-AUDIT.md 280 -> **1009** Zeilen (DRITT-ABGLEICH
D-0..D-6, Z.283-1009). Beide VOLL gelesen; dazu eigene Live-Messungen 24.08. 11:3x UTC.
Jede Zeile: Posten * Quelle * Traeger * Frist * Abnahme. STATUSWECHSEL ersetzen keine
Erst-Lauf-Zeilen (die bleiben als Momentaufnahme), sie schreiben sie fort:

**F3-01 [STATUSWECHSEL CR-1/E-10: Z12/o2-Landung ist VOLLZOGEN bis auf CI-Beleg].**
Eigene Messung 11:3x: ce development lokal == origin == **github** == 943c70ee (Kette
f82dfaeb -> b3dc3e93 -> 943c70ee axis-lock-Regen) -- der Dual-Push ist BEIDSEITIG erfolgt.
K17 4/4 Zellen je LITERAL "100% tests passed, 0 tests failed out of 545" (Z12-Logs
07:27-07:43Z), Gates 6/6 GRUEN inkl. [5/6] "545 == 545 exakt" -- **die E-10-/D-11-Floor-
Umstellung ist damit AM OBJEKT VOLLZOGEN** (F1-Abschn. 7.3). OFFEN aus CR-1 nur noch:
(a) CI-Terminal-Beleg fuer 943c70ee (s. F3-06), (b) test_rcu-Beobachtung unter
Parallel-Last (Nachbar-Befund, kein Ausfall in Z12). Traeger RN-01 unveraendert.
**F3-02 [STATUSWECHSEL L-05: K17-ENDSTAND-KOMBIBAU IST VOLLZOGEN -- ZWEIMAL].** 544er-Serie
@5ddda4e5/3841d717 + 545er-Serie @b3dc3e93/943c70ee, je 4/4 Zellen literal, J-1 mit den
SIEBEN Werkzeugen literal, Facade ueber das reale Target (F1-7.3). Damit EINGELOEST:
s19-FUND-2, s8kopf-S8A-01, messfenster-A-1-Komponente-1 (die 7er-J-1-Auflagen der 27.1.I-
L-05-Zeile). OFFEN aus L-05: test_rcu (s. F3-01b) + Diff-Hygiene push-lokal ueber den
FF-Bereich VOR dem main-FF. **L-06 (Warnungs-Review ZWEIMAL) bleibt UNVERAENDERT OFFEN**
-- kein neues Artefakt am Objekt (einziges bleibt 20260820-nachhol-kombibau/
warnungs-review.md, bis c2da9d1a).
**F3-03 [K17-/BUMP-BEZUGSPUNKT WANDERT -- KORR-D7/H-19].** Ein K17-Testat deckt nur seinen
Stand: Bezugspunkt ist der dev-Tip AM ZUGTAG (24.08. frueh: 943c70ee), NICHT mehr
5ddda4e5/3841d717. Der super-Gitlink-Bump-Zug (CR-4/L-01) misst sein Ziel AM ZUGTAG frisch
und wiederholt die np34-Patch-Match-Probe, wenn super sich bewegt (Probe 24.08. erneut
RC=0 @ super 80121632; super ist seither docs-only auf 5260a704 weitergewandert, Gitlink
COMMITTED weiterhin 66de5c09 -- eigene Messung 11:3x). Traeger RN-01 (CR-3/CR-4).
**F3-04 [F-124/H-20 Endstand-Nenner-Harmonisierung].** Lebender Floor = 545/541/539
(scripts/ci_test_inventory_floor.txt @943c70ee); die in S1-Berichten/Board/Ledger-
Entwuerfen stehenden 511/512/513/520/524/544 werden EINMAL im KON122-/Docs-Zug
harmonisiert, nie je Dokument einzeln. Traeger RN-01/RN-27 (Ledger-Zug). Abnahme:
Ledger-Zeile E-3 (F1-7.7) uebernommen.
**F3-05 [F-125 Tafel-Nullen-Falle].** "Restfunde 0" (konvergenz-blockierende Funde) und
"Rest-Posten 0" sind ZWEI Zaehlwerke -- die Skript-Tafel-Null laesst sonst 24 getragene
S1-Posten (darunter fristgebundene L-01) aus dem Blick fallen. PFLICHT: Nullen nur mit dem
Zusatz "konvergenz-blockierende Funde" zitieren; das 27.3-Gate prueft IMMER die
Rest-Posten-Menge. Traeger: dieses Gate + RN-27 (Ledger-Merksatz).
**F3-06 [F-126 CI-Terminal-Beleg fuer 943c70ee, UNGEPRUEFT-Klasse].** Juengster belegter
Terminal-Lauf ist 16101 @ 3841d717; fuer 943c70ee liegt in den Beweisorten KEIN
Terminal-Beleg (API braucht Token, fuer die Synthese-Laeufe TABU -- ausdruecklich
UNGEPRUEFT, fail-closed). Traeger: Lande-Zug/Lead (Push->gruen-Doktrin) VOR dem main-FF.
Abnahme: Pipeline-Terminal-Status als gesicherte Kopie.
**F3-07 [H-21 Anker-Drift durch den o2-Merge].** Der o2-Zug beruehrt genau die Flaechen
kuenftiger S1-Kleinst-Fixe (profile_run_entry.hpp, experiment_run_entry.hpp,
experiment_plan_director.hpp + Testdatei). L-07 (s19-Hinweiszeile) und L-13a
(main.cpp-Anker) werden gegen den HEUTIGEN Stand gesetzt, Zeilenanker vor dem Edit neu
gemessen. Traeger unveraendert (L-07/L-13).
**F3-08 [F-143 MILD: herrenloser Voll-Fix-Edit im wt-ce-ph89 -- LIVE 11:3x bestaetigt].**
Der credits-tote Erst-Fixer wg4nfrsb1 hinterliess am 23.08. 21:05-21:07 (NACH der
Z11-Loeschung des alten Strang-Worktrees 20:53Z -- neu angelegter Baum) einen
uncommitteten Voll-Fix (3 M-Zeilen: paper_pruefling_registry.hpp,
test_ph89_paper_prueflinge.cpp, thesis_tiere/test_experiment_parser.cpp; 68+/40-;
sha256(git diff) == gesicherter Patch 193 Z. in 20260821-w2-audit-fixverify/ph89/).
Inhalt = kompletter fix_weg zu ph89-1/-2/-3 (27.1.B). PFLICHT: der #139-/Traeger-Zug
SICHTET den Patch VOR dem Bau (Uebernahme als Vorarbeit ODER bewusster Frischbau); NACH
Zug-Gruen wt-ce-ph89 saeubern (EIN Schreiber); Board-#89-Metadata fortschreiben
(Lead-only). Abnahme: Sichtungs-Vermerk + porcelain 0 nach Zug-Ende.
**F3-09 [F-144 MILD, SOFORT-KLASSE S-0: Phantom-Bau-Slot slot1-ph89fix.d -- LIVE 11:3x
bestaetigt].** wer.txt literal "ph89fix-runde1 2026-08-23T21:05:30+00:00 wt-ce-ph89",
Halter credits-tot, > 14 h keine Bau-Aktivitaet; am Deckel 3 ist faktisch nur EIN Slot
frei. PFLICHT VOR jedem weiteren Bau: Todes-Beweis gegenpruefen, `rm -rf .../slot1-
ph89fix.d` durch EINEN bestimmten Akteur (Lead oder #139-Fix-Agent VOR seinem ersten
Bau-Zyklus), Raeumung einzeilig verbuchen. NIE parallel zu einer eigenen Slot-Claim-
Operation (K20-Doktrin: diese Fahrt hat NICHT geraeumt).
**F3-10 [F-145 KLEIN: K11-Beweis-Hygiene ph89-Treppen-Log].** ph89/bau-treppe-gcc-
release.log quittiert wegen Pipe-RC "RC_FACADE=0" trotz ninja-Fehler und "RC_CTEST=0"
trotz "No tests were found!!!" -- das gruene 511/511 stammt aus den beiden separaten
ctest-Logs. PFLICHT: (a) Log nicht editieren (Beweisort), (b) als 511/511-Beleg NUR die
ctest-Logs zitieren, (c) jede kuenftige Treppen-Protokollvorlage nutzt
rc=${PIPESTATUS[0]} + expliziten Build-Pfad. Traeger: RN-18 (J-1-Rezeptfix) + T17-1.
**F3-11 [F-146 STATUSWECHSEL: pinduo-T9 IST VOLLZOGEN -- SPERRE gegen Doppelausfuehrung].**
prt-art bau/pinduo @ 25bbf2e (22.08. 12:59, lizenz_audit.hpp 7+/2-, origin gesichert)
erfuellt ALLE VIER T9-SPEC-Teile (exakter Name 'ce-pin' + Begruendung; K13 beidseitig aus
gesicherter Kopie ROT 1/9 mit 343 Fremdtreffern -> GRUEN 9/9; voller ctest 224/224 im
CI-Layout -- damit auch pinduo-A3 erfuellt, Board-#122-Posten schliessbar; .gitlab-ci.yml
unberuehrt = Klon-Umzug abgelehnt). **Die 27.1.J-T9-Zeile und CR-7 sind entsprechend
fortgeschrieben: T9(a)-(d) NICHT erneut ausfuehren.** Verbleibende prt-art-Auflagen =
W1L-1..W1L-9 (S2-Dritt-Abgleich D-3.3): W1L-1 echte Branch-CI (Pin-Log 6/6 Jobs +
Allowlist-Beleg; E-01-CAVE fail-closed) * W1L-2 Rezept #107 (pinduo ZUERST, B14-Konflikt
zugunsten D-10a, einziger B14-Mehrwert Bau-Proben-Notiz) * W1L-3 Klon-Umzug ablehnen *
W1L-4 prt-art-Kombibau (224er deckte nur gcc-Release-lokal -- beide Mengen nennen) *
W1L-5 Stat "58+/5- (Summe 63)" * W1L-6 FINDINGS#13 ERLEDIGT-DURCH-OBJEKT (f1fc5d8) *
W1L-7 F-86-Bump NUR mit XML-Byte-Beleg (Range GEWACHSEN: 41+ Commits, wird teurer) *
W1L-8 YAML-Scope-Buchung (E-14/E-15, faktisch unbedingt, formale Buchung fehlt) *
W1L-9 Standalone-Klon nach #113 + Submodul-Store-Fetch (stale d11781fa).
**F3-12 [F-147 KLEIN: trigfix-KLEIN-4 -- T12 waechst 5 -> 6].** Alt-Treiber-Export
emittiert nie-befuelltes bytes_in_use_peak undeklariert (experiment_driver.cpp:489 rec{}
-> result_aggregator export_csv; offizielle Kampagnen-CSV traegt ehrlich "n/a"). KEIN
Lande-Blocker; fix_weg = EINE Deklarations-Kommentarzeile nach f15-:614-Muster im
T-9-/Karten-Pass. Traeger: T-9-Folgewelle (RN-31-Umfeld) + F-101-Karten-Konsolidierung.
**F3-13 [F-148/F-149 KLEIN: skip97-Anker-Korrekturen -- KORR-D4].** Karten-Doku:
skip97-Bloecke liegen LITERAL am Dateiende (Z.8172-8213 von 8213, kein "vorletzter
Block"). Register-Anker des observe-Duos sind durch die Landung verschoben: iterator
**:2354** / **:3269**, Produktions-Binder **:2382** (statt :2303/:3186/:2331) -- die
F-106-Registerzeile (T13-1) wird mit den NEUEN Ankern oder zeilenfrei geschrieben, die
alten NICHT mehr uebernommen. Traeger: Lead-Doku/#97 + F-106-Folge-Zug.
**F3-14 [F-150 SPERRE + F-151 NEU: e11].** Die 27.1.J-T15-Klammer "+ F6-Notiz-Landung
6fe69057" ist UEBERHOLT: die F6-Notiz liegt GETRACKT IM CE (6fe69057 + 8cd32a0d sind
bewiesene Ahnen von ce/origin/development) -- der Lead-Auftrag "im super heben" ist
GEGENSTANDSLOS und darf NICHT ausgefuehrt werden (Phantom-/Doppel-Arbeit). Was von T15-2
bleibt: der V0-Gegenlese-Schritt (Existenz am dann gueltigen ce-HEAD pruefen). NEU
**E11-B1** (F-151, KLEIN): der explizite (a)/(b)/(c)-Owner-Klassen-Abgleich fehlt in der
Design-Prosa -- DREI Zeilen ergaenzen ((a) HW-Fehlen -> P3, (b) Compile-Fehler -> P1/P2,
(c) Runtime-Algo -> P4). e11 bleibt bei 4 KLEIN: A1/A3/A4 + B1. Traeger: V0-Gegenlese des
golden-Zugs bzw. T7-Docs (S-2f).
**F3-15 [VERSCHAERFUNG: golden-Zug E-11 ist NICHT GESTARTET bei Doppelfrist].** Kein
Branch, kein Worktree, alle 4 geplanten Neubauten fehlen am HEAD (eigene Gegenprobe des
e11-Audits); Fristen "VOR W3" + "vor Sa 29.08." bei bisher datumsloser
Staffel-3-Platzierung. PFLICHT: Terminierung in denselben Zug wie #114 (S-4). Traeger:
RN-77/RN-78-Umfeld + Board-Traeger-Anlage (F2-D-5 Board-Entwuerfe).
**F3-16 [F-152/F-153/F-154 kampvor].** Beweisordner-Luecke fuer die super-Haelfte durch
das Audit selbst GEHEILT (5 Logs persistiert -- stehende Auflage: Proben-Ausgaben im
SELBEN Zug als Datei sichern, nie als Zitat). Lint-Formel je Datei fuehren (sh-Datei ->
sh -n, bash-Datei -> bash -n; ci/persist_sammler.sh reisst BESTANDS-bedingt an sh -n,
kein Regress). Der super-Merge bau/kampvor @ 025e0c42 ist ein EIGENER, terminierter
Lande-Schritt (E-9-Frist vor Sa 29.08.) -- in CR-2 bereits getragen, hiermit mit
Frist-Vermerk bestaetigt (die S2-SYNTHESE-Fassung 20:17 hatte ihn in keiner OFFEN-Liste;
F-154).
**F3-17 [F-155 MILD, Lead: F2-VORLAGEN-FENSTER-Nachzug weiterhin offen].** Das Fenster-
Dokument (mtime 22.08. 06:44:23 unveraendert) wuerde dem Owner die am 21.08. 20:40
owner-beantwortete D-04-Frage erneut als offenen Entscheid vorlegen. PFLICHT VOR der
naechsten Owner-Vorlage (RN-05, koppelt an N-42/N-44/N-48): D-04-Block in die
ENTSCHIEDEN-Tabelle, nur die ERSATZ-ZEILE uebernehmen, F-122 per D04EXPL-Verweis
ersetzen. Traeger: Lead (a19-L4/FOLGE-2).
**F3-18 [KON122-BANK-ERWEITERUNG].** Zusaetzlich zum L1-L21-Entwurfsblock (CR-5) liegen
jetzt WORTFERTIG: KON122-A (ph89-Zweitkette inkl. F-140..F-145 + Label-Cave), KON122-B
(T9-Vollzug), KON122-C (F-145..F-155-Sammel), KON122-D (Endstand-Bezug 943c70ee +
Gitlink-Lage) im S2-DRITT-ABGLEICH D-5 sowie E-1..E-7 (S1-DRITT-ABGLEICH 7.7; E-2/E-3 =
K17-Quittung + Floor-Zeile). Der RN-01/RN-27-Ledger-Zug nimmt BEIDE Baenke zusaetzlich
zur L1-L21-Quelle; Ledger-Kopf am 24.08. ~08:00 weiterhin KON121, naechste freie Nummer
KON122 (F2-D-3.1, datierte Messung).
**F3-19 [27.1.B-NENNER-FORTSCHREIBUNG: ph89-Strang = FIXES_NOETIG mit FUENF offenen
Funden].** Die Erst-Lauf-Tafel 27.1.B (ph89-1..3) bleibt korrekt, ist aber seit der neuen
ph89-Audit-Kette (audit r1 23.08. 20:57 -> fix r1 VERTAGT -> r2 -> r3, alle 24.08.) um
F-143 (F3-08) und F-144 (F3-09) zu ergaenzen; F-145 (F3-10) ist der sechste, strang-
zugehoerige Beweis-Hygiene-Posten. LABEL-CAVE bleibt: das ph89-interne "FUND-1" bezeichnet
in der ERSTFASSUNG den KLEIN "6 vs 7 C++-Dateien" (weiterhin offen, T11-1), in der
Fassung 23.08. den MILD F-140/ph89-1 -- nie gleichsetzen. Rot-Protokoll-Literal: 11
static-assert-Fehler (nicht 12).
**F3-20 [ZWEI S2-ZAEHLWERKE, beide datiert fuehren].** K-F-Nenner "38 Rest-Posten"
(Fassung 20:17, Rest-Posten-Zaehlung inkl. getragener) UND Dritt-Abgleich-Nenner "22
offene Fund-IDs" (24.08., nach Statuswechseln F-146/F-150 und Neufunden F-147/F-149/
F-151) sind ZWEI Zaehlwerke zweier Zeitpunkte -- beim Zitieren Basis + Datum mitnennen
(dieselbe Klasse wie F3-05).

### 27.5.3 GEGENZAEHLUNG + ABNAHME-VERMERK FAHRT 3 (beide Mengen genannt, V-8)

    GEPRUEFT:      701/701 Legacy-Zeilen (478 Erst-Lauf: 352 par.27 + 106 Designplan-
                   par.13 + 20 Marker; 223 Fahrt 2: 147/1 par.27.4-ASCII + 76 par.13.4)
                   -- am Objekt, gegen die VOLLE Quellen-Lage inkl. der gewachsenen
                   Fassungen (F1 654/654, F2 1009/1009), die keiner Vorfahrt vorlag.
    BESTAETIGT:    16/16 Fahrt-2-Urteile (K-A..K-F, E-01..E-10) + Form-Korrektur +
                   alle 7 Designplan-13.4.1-Urteile + D-11/D-12. 0 Fehler gefunden.
    FORTGESCHRIEBEN: 20 Posten (F3-01..F3-20) -- davon 5 STATUSWECHSEL (F3-01 o2-
                   Landung vollzogen bis auf CI-Beleg, F3-02 L-05 vollzogen, F3-11
                   T9 vollzogen + Sperre, F3-14 F6-Notiz-Sperre, F3-16 Beweisordner
                   geheilt), 9 NEUE Posten (F3-06 CI-Beleg, F3-08 liegender Edit,
                   F3-09 Phantom-Slot SOFORT, F3-10 K11-Log, F3-12 KLEIN-4, F3-13
                   Anker, F3-14 E11-B1, F3-15 golden-Zug-Terminierung, F3-17 F2-
                   Fenster-Nachzug), 6 PRAEZISIERUNGEN (F3-03/04/05/07/18/19/20).
    LIVE GEMESSEN (11:3x UTC, eigene Messungen dieser Fahrt): ce dev lokal == origin ==
                   github == 943c70ee * super dev 5260a704 (docs-only), Gitlink
                   COMMITTED 66de5c09 * wt-ce-ph89 EXISTIERT mit exakt 3 M-Zeilen *
                   slot1-ph89fix.d EXISTIERT (wer.txt 21:05:30) * bau/w2-abschluss-
                   fixes existiert NICHT.
    NICHT GEDECKT: CI-/Pipeline-Status (kein Token, F3-06 fail-closed offen) * die
                   Inhalte des laufenden #139-Zugs * Lead-only-Schreibvollzuege
                   (Ledger/Board/Memory -- Entwuerfe sind Auftraege, keine Beweise) *
                   Z13..Z27-Nummernzuordnung (bleibt Ableitung bis Zug-Resume, K-E).

**FABLE-MAX-ABNAHME-VERMERK (Fahrt 3, 24.08.2026):** Geprueft 701/701 Zeilen; Korrekturen
dieser Fahrt: 0 an den Vorfahrten-Urteilen (16/16 + 7/7 bestaetigt), 20 Status-
Fortschreibungen F3-01..F3-20 (namentlich oben, je mit Quelle/Traeger/Frist/Abnahme).
**Damit gilt das par.27-Design als von Fable 5 max GEBAUT UND ABGENOMMEN** -- Erst-Lauf-
Substanz + Fahrt-2-Korrekturen tragen, die Fahrt-3-Tafel schreibt den Objektstand 24.08.
11:3x fort. Das W2-ABSCHLUSS-GATE (27.3) gilt unveraendert und erfasst 27.4.2 UND 27.5.2
mit; Designplan-Schwester: par.13.5.
