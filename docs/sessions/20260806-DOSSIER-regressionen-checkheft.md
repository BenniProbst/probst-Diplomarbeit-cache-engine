# DOSSIER 06.08.2026 -- Regressionen als Checkheft

**Titel:** Was gruen meldete, ohne zu pruefen -- 25 Befunde einer Session, als Checkheft gefuehrt
**Datum der Erhebung:** 06.08.2026, Verifikations-Nachtrag vom Abend desselben Tages
**Art:** Checkheft. Kein Protokoll, kein Bericht, keine Erfolgsmeldung.

---

## 0. KOPF

### 0.1 Zweck

Dieses Dokument ist **ein Checkheft, das noch abgearbeitet werden muss.** Es ist nicht die Zusammenfassung einer Session, sondern ihre **Arbeitsliste**. Jeder Eintrag traegt einen Status, einen Ort (Datei:Zeile), einen Beleg, eine Konsequenz und -- wo offen -- die naechste Handlung. Es ist so geschrieben, dass jemand es in vier Wochen aufschlagen und weiterarbeiten kann, ohne die Session gelesen zu haben.

Jeder Befund unten wurde **am Objekt nachgeprueft**, nicht aus der Session uebernommen. Das war keine Formalie: bei dieser Nachpruefung sind acht Behauptungen **entlastet** worden, zwei liessen sich nicht belegen, vier Zeilenangaben waren verschoben, und vier Befunde waren zwischen Erhebung und Abfassung bereits geheilt. Was sich nicht bestaetigen liess, steht als `[?] UNBELEGT` drin -- nicht weggelassen.

### 0.2 LAGE-KORREKTUR (bindend, ersetzt alle Termin-Einordnungen der Session)

Der Owner hat am Abend des 06.08.2026 klargestellt:

> **Endtermin ist der 15.09.2026, mit woechentlicher Lieferung jeden Freitag.**

Der **08.08. war ein Zwischenziel, kein Abgabetermin.** Jede Formulierung dieser Session der Form "zwei Tage vor der Frist", "vor dem Trigger Do 07.08.", "nicht mehr vor der Abgabe realistisch" oder "nach der Abgabe vertretbar" ist gegen den 08.08. gerechnet und **entsprechend zu relativieren**:

- aus "unrealistisch" wird "nicht in dieser Woche";
- aus "nach der Abgabe" wird "in einem der sechs verbleibenden Freitags-Pakete";
- aus "keine Zeit mehr" wird "fuenf weitere Wochen mit sechs Liefertagen".

**Kein Befund dieses Checkhefts verfaellt dadurch** -- aber die Dringlichkeitsstufen, die aus dem 08.08. abgeleitet wurden, tragen nicht mehr. Die **Rangfolge** bleibt, der **Ausschluss** faellt. Betroffen sind namentlich: SW-3/A-1..A-4 (PMC), H-4-R1, H-6/F-4, H-7-R1, C-3, E-1, F-1 bis F-6.

Die Termin-Klassen dieses Hefts lauten daher: **T1** = vor dem ersten 4096er-Batch - **T2** = vor der Voll-Messung - **T3** = vor dem 15.09.2026 - **T4** = danach.

### 0.3 Stand der Repos (live erhoben bei Abfassung, nicht uebernommen)

| Gegenstand | Ist bei Abfassung | Anmerkung |
|---|---|---|
| super `development` == `origin/development` | `46824fba` | eine Landung **nach** dem Stand der Kapitel (`72eab9ae`) |
| super `origin/main` | `5534c23c` | **10 Commits hinter** `development` -- s. S-3 |
| super Arbeitsbaum | `+f57801d3` fuer `Code/external/comdare-cache-engine` | Gitlink-Bump **nicht committet** -- s. S-1 |
| super untracked | 3 Plandokumente, **2042** Zeilen + `Code/measure_out_d03/` | s. S-4 / Z-5 |
| ce `origin/development` | `f57801d3` | **neuer** als der Kapitel-Stand `47c4ef1d` |
| ce `origin/main` | `47c4ef1d` | 2 Commits zurueck -- s. S-2 |
| ce **lokaler** `main` im Hauptklon | `2b0a9bd8` | **veraltet**, Vorfahr von `47c4ef1d` -- s. N-3 |
| Submodul `thesis/diplomarbeit` | `8e58f691` (Zeiger == Checkout) | sauber |
| Submodul `Code/external/20260931-overleaf-...` | `8e58f691` (Zeiger == Checkout) | sauber -- Divergenz durch `46824fba` geheilt |
| thesis `origin/development` == `origin/main` | `8e58f691` | live per `ls-remote` |
| thesis `github/development` == `github/main` | `8e58f691` | live per `ls-remote` -- s. N-4 |

**Messmethode:** alle exakten Zaehlungen mit `/usr/bin/grep` (GNU grep 3.11) absolut aufgerufen, **nicht** mit dem Wort `grep`. In dieser Umgebung ist `grep` eine Shell-Funktion auf **ugrep** (`type grep` -> `grep is a function`), und genau dieser Unterschied traegt Regel R-1. Alle Zahlen mit Bezugsgroesse.

---

## 1. DIE BILANZ IN ZAHLEN

Gezaehlt aus den Kapiteln, nicht geschaetzt.

### 1.1 Befunde nach Status

| Status | Zahl | Eintraege |
|---|---:|---|
| `[x] ERLEDIGT` | **9** | SW-1, SW-2, SW-4, H-1, H-2, H-3, H-5, Z-4, Z-7 |
| `[~] TEILWEISE` | **7** | SW-6, H-4, H-7, Z-1, Z-3, Z-5, Z-6 |
| `[ ] OFFEN` | **9** | N-1, N-2, N-3, N-4, SW-3, SW-5, H-6, Z-2, Z-8 |
| **Summe Befunde** | **25** | |

Dazu **10 Regeln** (R-1 bis R-10) als Wiedererkennungs-Merkmale der Klasse; sie tragen eigene Status-Zeichen, sind aber keine eigenen Befunde, sondern die Verallgemeinerung der Faelle.

### 1.2 Entlastungen -- ein vollwertiges Ergebnis

Acht Behauptungen wurden am Objekt geprueft und **entlastet**. Sie sind hier sichtbar, damit niemand sie ein zweites Mal jagt:

| # | Behauptung | Befund am Objekt |
|---|---|---|
| E-a | `COMDARE_BESTANDSLOG` "wird nirgends gesetzt", also laeuft T2-A in keinem produktiven Pfad | **Falsch.** Die Variable reist ueber den **emittierten** Weg (`experiment_plan_director.hpp:952-955`), Konsumenten existieren (`02_messung_driver/main.cpp:1119`). Siehe R-4. |
| E-b | Die kaputte grep-Kette gefaehrdet CI-Jobs | **Nein.** Ueber beide Repos **0** Fundstellen ausserhalb von Kommentaren. Schaden war auf die manuelle Agenten-Prozedur begrenzt. Siehe SW-4. |
| E-c | Der ungegatete `test_data_sets.xml`-Slot verfaelscht Messwerte | **Nein.** Kein heutiger Messwert haengt daran (Mess-Strecke laeuft ueber E4/Profil). Schaden = falsches Sicherheitsgefuehl. Siehe SW-6. |
| E-d | Die kompilierten Kapitel ueberversprechen die PMC-Abdeckung | **Nicht belegbar.** `06_fazit.tex:157-162` und `le_limitierung.tex:1` sind korrekt gehedgt. Siehe C-4. |
| E-e | Node-Shape-Varianten werden als gemessen behauptet | **0 Treffer** in allen Kapiteln/Anhaengen; die "Knotenform"-Stellen betreffen `axis_04_node_type`, eine tatsaechlich gemessene Achse. Siehe C-4. |
| E-f | Der super hat dieselbe Test-Abdeckungsluecke wie der ce | **Nein.** 144 super-eigene Tests, alle mit `da_unit`, **Luecke 0** -- gemessen. Die Wache fehlt trotzdem (Praevention). Siehe D-3. |
| E-g | Der LB-Paketschnitt ist "verloren" | **Nur die Buchfuehrung.** Die Kopf-Bausteine LB-0..LB-3 existieren im Code; Beweise reichen bis LB-1. Siehe Z-6. |
| E-h | Das Thesis-Repo ist auf GitHub nicht auf Stand (dual-remote-Verstoss) | **Falsch.** Live `ls-remote github` liefert `8e58f691` fuer `development` **und** `main`. Der Verdacht entstand aus **veralteten lokalen remote-tracking-Refs**. Siehe N-4. |

### 1.3 Was sich nicht belegen liess

| # | Gegenstand | Warum |
|---|---|---|
| `[?]` U-1 | Die Zahlen **667 / 1385** und der ROT-Zustand im b14-super-Bereich (R-2, Fall c) | Branch-Spitze ist weitergewandert, Verstoesse geheilt; heute **677 / 1393**, beide gruen. Die **Struktur** (enger Bereich deckt 49 % des merge-base-Bereichs) ist bestaetigt. |
| `[?]` U-2 | Die Forderung nach **eigenem Include-Root plus INTERFACE-Ziel** fuer den Appendix-Generator (D-4) | In den Session-Dokumenten des 06.08. nicht mit Fundstelle auffindbar (0 Treffer auf "Include-Root"/"INTERFACE-Ziel"). Vor Umsetzung an der Quelle zu rekonstruieren. |

Ausserdem als `[BERICHT]` gekennzeichnet -- aus CI-Trace oder Commit-Text uebernommen, hier **nicht** selbst nachgefahren: die 94 Format-Verstoesse in 13 Dateien; die Testzahlen 404/406/407/411; die PMC-Live-Gegenueberstellung (`available=0` vs. `cache_misses_l1=4191307`); die Kalt/Warm-Statistik 3/3 gegen 20/20 aus Z-7; der gruene CI-Lauf der rescue-Ref (`thesis 14964`).

### 1.4 Offene Handlungsposten

| Termin-Klasse | Zahl | Posten |
|---|---:|---|
| **Sofort** (Lage bei Abfassung) | **4** | S-1 bis S-4 |
| **T1** -- vor dem ersten 4096er-Batch | **7** | A-1, A-3, A-4, B-1, B-2, B-3, D-2(a) |
| **T2** -- vor der Voll-Messung | **5** | A-2, A-5, A-6, C-3, C-4 |
| **T3** -- vor dem 15.09.2026 | **6** | C-1, C-2, D-1, D-3, E-1(Rotation), F-1 |
| **T4** -- danach | **6** | D-2(b)/D-4, F-2, F-3, F-4, F-5, F-6 |
| **Summe** | **28** | |

### 1.5 Die drei Klassen

| Klasse | Kapitel | Befunde | davon offen/teilweise |
|---|---|---:|---:|
| Stille Wachen -- gruen ohne zu pruefen | II | 6 | 3 |
| Heilung neben der Wunde | III | 7 | 3 |
| Zwei Quellen fuer dieselbe Wahrheit | IV | 8 | 6 |
| Methoden-Befunde aus der Nachpruefung | I (N-Teil) | 4 | 4 |

**Der eine Satz, der alle 25 verbindet** (Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:4705-4707`):

> "Alle vier sind am selben Tag aufgetreten, alle vier haben dieselbe Gestalt: **eine Messung war fuer sich korrekt und beantwortete die falsche Frage.**"

---

## 2. LESEANLEITUNG

### 2.1 Statuszeichen

| Zeichen | Bedeutung |
|---|---|
| `[ ] OFFEN` | Der Befund steht, die Handlung ist nicht vollzogen. |
| `[x] ERLEDIGT` | Geheilt. Der heilende Commit ist genannt und als Vorfahr des heutigen Zweigkopfs geprueft. |
| `[~] TEILWEISE` | Der Anlassfall ist geheilt, die **Ursache** oder ein Zwilling steht noch. Ein `[~]` ist naeher an `[ ]` als an `[x]`. |
| `[-] ENTLASTET` | Die Behauptung wurde am Objekt geprueft und traegt **nicht**. Kein Handlungsbedarf. Bewusst sichtbar, damit sie nicht wiederkehrt. |
| `[?] UNBELEGT` | Nicht reproduzierbar. Weder bestaetigt noch widerlegt. **Nicht weggelassen.** |

### 2.2 Aufbau eines Eintrags

Jeder Eintrag hat bis zu sieben Felder, in dieser Reihenfolge:

1. **Ort** -- `Datei:Zeile`, repo-relativ, mit Repo-Praefix (`ce/`, `super/`, `thesis/`), wo Verwechslung moeglich ist.
2. **Beleg** -- was gemessen wurde und womit. Zahlen immer mit Bezugsgroesse ("2 Verstoesse in 1448 geprueften Zusatzzeilen", nie "2 Verstoesse").
3. **Wie es unentdeckt bleiben konnte** -- der Mechanismus, nicht der Vorwurf. Dieses Feld ist der eigentliche Wert des Hefts.
4. **Was es gekostet haette / kostet** -- die Konsequenz in Abgabe-Substanz, nicht in CI-Minuten.
5. **Klassenmerkmal** -- woran man die Klasse in einem anderen Zusammenhang wiedererkennt.
6. **Heilung** -- der Commit, wo vorhanden.
7. **Naechste Handlung** + **Termin-Klasse** -- nur bei offenen und teilweisen Eintraegen.

### 2.3 Nummernkreise

| Kreis | Kapitel | Bedeutung |
|---|---|---|
| `R-1` .. `R-10` | I | Regeln (Wiedererkennungs-Merkmale) |
| `N-1` .. `N-4` | I | Neubefunde aus dem Verifikationsdurchgang selbst |
| `SW-1` .. `SW-6` | II | Stille Wachen |
| `H-1` .. `H-7` | III | Heilung neben der Wunde |
| `Z-1` .. `Z-8` | IV | Zwei Quellen fuer dieselbe Wahrheit |
| `S-1` .. `S-4` | V | Sofort-Block (Lage bei Abfassung) |
| `A-`,`B-`,`C-`,`D-`,`E-`,`F-` | V | Offene Handlungsposten nach Sachgebiet |
| `E-a` .. `E-h` | 1.2 | Entlastungen |
| `U-1`, `U-2` | 1.3 | Unbelegte Behauptungen |

Ein Fall, der in zwei Kapiteln vorkommt, steht **einmal** ausfuehrlich (dort, wo sein Mechanismus hingehoert) und wird von der anderen Stelle **verwiesen**. Beispiele: die kaputte grep-Kette steht in SW-4, R-1 verweist; der Submodul-Rueckwaertszeiger steht in Z-3, R-8 verweist; Anhang A steht in Z-8, C-1 fuehrt die Handlung.

### 2.4 Was tun, wenn ein Befund beim Nachpruefen nicht mehr existiert

Das ist der Normalfall in einem bewegten Repo -- vier der 25 Befunde waren zwischen Erhebung und Abfassung dieses Hefts bereits geheilt. Vorgehen, in dieser Reihenfolge:

1. **Nicht streichen.** Ein verschwundener Befund ist ein Ergebnis, kein Nicht-Ereignis.
2. **Ursache bestimmen:** geheilt (dann `[x]` **mit dem heilenden Commit**), gewandert (dann Zeilenangabe korrigieren, Befund unveraendert), oder nie vorhanden gewesen (dann `[-] ENTLASTET` **mit dem Gegenbeleg**).
3. **Bei Zeilendrift:** Zeile korrigieren **und** einen Suchbegriff nachtragen. Zeilenangaben altern -- vier Belege dieses Hefts waren binnen Stunden verschoben (N-2). Ein Beleg ohne Suchbegriff ist ein Beleg mit Verfallsdatum.
4. **Bei "geheilt":** pruefen, ob die **Klasse** geheilt ist oder nur der **Vertreter**. SW-2 ist der Gegenbeweis fuer den manuellen Weg: dieselbe Luecke war am 13.07. schon einmal von Hand geschlossen worden und war binnen drei Wochen zurueck. Nur ein Werkzeug zaehlt als Heilung der Klasse.
5. **Bei nicht reproduzierbar:** `[?] UNBELEGT` mit der Angabe, **warum** (Spitze gewandert, CI-Historie verfallen, Quelle nicht auffindbar). Nicht loeschen.
6. **Ref-Namen immer live aufloesen.** Zwei Befunde dieses Hefts (N-3, N-4) sind ausschliesslich dadurch entstanden, dass eine lokale Ref-Kopie eine Frage ueber den Remote beantwortet hat.

---

# KAPITEL I -- DAS MUSTER: eine Messung war korrekt und beantwortete die falsche Frage

## I.1 Die These

Alle in dieser Session gefundenen Regressionen haben **dieselbe Gestalt**. Keine von ihnen entstand aus einer falschen Messung. Jede einzelne entstand aus einer **korrekten Messung ueber den falschen Gegenstand**.

Das ist die gefaehrlichste Form, weil sie **kein Fehlersignal erzeugt**: eine falsche Messung faellt irgendwann auf; eine korrekte Messung der falschen Frage liefert eine belastbare Zahl, ein gruenes Gate und ein reines Gewissen.

Die zehn Regeln unten sind die Wiedererkennungsmerkmale dieser Klasse. Jede ist an einem Anlassfall entstanden und je einzeln am Objekt nachgeprueft.

---

## I.2 Die zehn Regeln

### R-1 -- Keine Null ohne Nenner

**`[~] TEILWEISE`** -- im ce geheilt, im super offen.

**Anlassfall A (Dateimenge).** Nach dem Format-Nachzug `034e0068` meldete der Bau-Agent "0 Nicht-ASCII, 0 ueber 120" -- gemessen ueber *seinen* Commit. Der Gegenpruefer fuhr dieselbe Wache ueber die Gesamtserie `7969b399..034e0068` und erhielt **9 Verstoesse in 5 anderen Dateien**. Beide Zahlen sind richtig; die Schnittmenge der Dateimengen ist leer. (Ledger `:4813-4826`.)

**Anlassfall B (das Messwerkzeug selbst).** Die von Hand getippte Gate-Kette war auf **beiden** grep-Engines kaputt, ueber zwei verschiedene Wege. Vollstaendig mit Live-Reproduktion in **SW-4**.

**Warum die Messung fuer sich korrekt war:** jede einzelne Stufe tat exakt das, was ihre Manpage zusagt. Der Fehler liegt in der **Komposition** -- und die Komposition hat keinen Exit-Code, den jemand liest.

**Klassenmerkmal:** eine Gate-Meldung, die aus **einer nackten Null** besteht. "ASCII: 0" ist kein Beweis. Belastbar ist erst "1448 Zusatzzeilen geprueft, davon 0 Nicht-ASCII, davon 2 ueber 120 Spalten".

**Heilung (belegt).** `ce/scripts/ci_diff_ascii_width_guard.sh` (15679 B, am Objekt vorhanden) ersetzt die Prozedur durch ein Werkzeug: awk-Zustandsmaschine statt Regex-Vermutung, byteweise ASCII-Erkennung, jede Stufe einzeln per `$?` geprueft, fehlendes Werkzeug = FATAL statt stiller Null. Die Ausgabe traegt den Block `NENNER (nie eine nackte Null):`. Die Regel ist damit **im Werkzeug** verankert, nicht in der Disziplin.

**Naechste Handlung:** `[ ]` Der **super hat keine Kopie dieser Wache** -- `find` ueber den super ausserhalb `Code/external/` liefert **0** Treffer (heute nachgemessen; der super hat ueberhaupt kein `scripts/`-Verzeichnis). Die super-Pakete (graph, b14-super) wurden mit einem Skript aus dem *fremden* Repo geprueft. Wache in den super spiegeln oder zentral ziehen. **T3**, gemeinsam mit D-3.

---

### R-2 -- Der Pruefbereich ist Dateimenge UND Commit-Bereich; der Bereich ist die merge-base

**`[~] TEILWEISE`** -- dreimal aufgetreten, zweimal am Objekt reproduziert, CI-Verdrahtung offen.

**Fall (a) -- falsche DATEIMENGE.** `034e0068` formatierte die drei Dateien seines eigenen Patches; die 9 Verstoesse lagen in fuenf anderen Dateien frueherer Commits (`faa525d7`, `aa46c524`). Ledger-Beleg; lokal nicht nachmessbar, weil die Serie gelandet ist.

**Fall (b) -- falscher COMMIT-BEREICH (ce/B14). Vollstaendig am Objekt reproduziert:**

- `git merge-base c837d830 16a173f2` == `c837d830` -- `c837d830` **ist** die merge-base, `16a173f2` ein Commit *innerhalb* der Branch, fuenf Commits vor der Spitze.
- Enger Bereich `16a173f2..HEAD` (HEAD = `cc20b63d`): **558** Zusatzzeilen im Scope, **0** Verstoesse -> **GRUEN**.
- Korrekte merge-base `c837d830..2a58e2ed` (Stand vor der Heilung): **1448** Zusatzzeilen, **2** Verstoesse -> **ROT**:
  - `libs/cache_engine/anatomy/abi_adapter.hpp:78` (138 Byte)
  - `tests/unit/test_b14_abi_adapter_line_subaxis_paths.cpp:138` (122 Byte)
- Der enge Bereich verbirgt **890 von 1448 Zeilen = 61 %** der Aenderung.
- Geheilt durch `cc20b63d` ("fix(width): zwei >120-Spalten-Zeilen vor B14-Landung gekuerzt"); derselbe Bereich misst heute **1450 / 0 -> GRUEN**.

Die Ledger-Zahlen (558 / 1448 / zwei Verstoesse) sind damit **exakt bestaetigt**.

**Fall (c) -- b14-super. Substanz bestaetigt, Zahlen `[?] UNBELEGT` (U-1).** `git merge-base 3585541b 1ba29b63` == `3585541b`, die Bereichsstruktur stimmt. Gemessen gegen die damalige Spitze `50dc231b`: enger Bereich `1ba29b63..HEAD` = **677** Zeilen (gruen), merge-base `3585541b..HEAD` = **1393** Zeilen (heute ebenfalls gruen). Die genannten **667 / 1385** weichen um 10 bzw. 8 Zeilen ab; der ROT-Zustand ist nicht mehr herstellbar. **Belegt bleibt:** der enge Bereich deckt nur **49 %** des merge-base-Bereichs.

**Warum die Messung fuer sich korrekt war:** `16a173f2..HEAD` ist ein gueltiger Bereich, und ueber ihn *sind* null Verstoesse. Die Zahl luegt nicht -- sie beantwortet die Frage "was habe ich zuletzt angefasst?" statt "was landet?".

**Klassenmerkmal:** ein Referenz-SHA, der **nicht** aus `git merge-base` stammt, sondern aus dem Gedaechtnis ("da hatte ich zuletzt gemessen"). Jeder bequeme SHA ist verdaechtig.

**Naechste Handlung:** `[ ]` Die CI-Verdrahtung ist **noch nicht** merge-base-basiert. `ce/.gitlab-ci.yml:259-268` waehlt `CI_MERGE_REQUEST_DIFF_BASE_SHA`, sonst `CI_COMMIT_BEFORE_SHA`, sonst `HEAD~1`. Ausserhalb von MR-Pipelines ist das **nicht** die merge-base: ein Push mehrerer Commits prueft nur den letzten Push, nicht das Paket. **T3**.

---

### R-3 -- "X liest/braucht niemand" ist eine Vollstaendigkeitsaussage

**`[~] TEILWEISE`** -- Klammer gefallen, geforderte Testwelle offen.

**Anlassfall.** Ein Bau-Agent zog eine Kosten-Klammer ein: der Plan-/Bau-Identitaets-Stempel werde nur noch gebildet, wenn `cfg.batch_plan_datei` belegt ist -- begruendet damit, ein voller Durchlauf ueber 2^17 laufe "fuer eine Zeichenkette, die nachweislich niemand liest". Die Code-Pruefung dazu war korrekt. Der Owner widersprach (Ledger `:5048-5051`, verbatim):

> "Ich erwarte laut Plan eine dummy Strategie fuer den Tests des Lagers um aus simulierten Textdokumenten die Stempel auszulesen und jede Zeile verbatim auszuwerten und dasselbe mit compile Binary stubs fuer das Stempelsystem zu wiederholen ... Das sind die erwarteten Basis Tests fuer das Lagersystem."

Der Leser stand in der **Planung**, nicht im Code. Ein `grep` ueber `libs/` konnte ihn nicht finden.

**Warum die Messung fuer sich korrekt war:** "kein Aufrufer in `libs/`" war wahr. Sie ist nur kein Beleg fuer "niemand liest es", weil `libs/` nicht die Menge aller Leser ist.

**Klassenmerkmal:** jede Begruendung, die ein **Weglassen** mit einer **Abwesenheit** rechtfertigt. Abwesenheit ist nur ueber die vollstaendig benannte Suchmenge belegbar -- Code UND Tests UND Planung.

**Naechste Handlung:** `[ ]` Lager-Basis-Tests bauen (Stufe 1: Textdokument-Strategie, jede Zeile verbatim; Stufe 2: compile Binary Stub mit dem Versionierungs-Interface). Plan liegt in `ce/docs/plaene/20260806-PLAN-lb6-stufe1-oeb-baumform.md`. Fortgefuehrt als **B-1**, **T1**.

---

### R-4 -- Bei generierten Artefakten beweist Abwesenheit im Quell-Repo nichts

**`[-] ENTLASTET`** -- die Behauptung war falsch, der Befund ist erledigt (E-a).

**Anlassfall.** Die Kostenklammer-Jagd behauptete, das Wurzel-Gate sei `COMDARE_BESTANDSLOG` und werde "nirgends gesetzt". Folge waere gewesen, dass die gesamte T2-A-Arbeit in keinem produktiven Pfad laeuft.

**Am Objekt geprueft:**
- Zuweisungen in den **eingecheckten** CI-Dateien: super `.gitlab-ci.yml` = **0**, ce `.gitlab-ci.yml` = **0**. Die Beobachtung stimmt.
- Die Variable reist ueber den **emittierten** Weg: `ce/libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:952-955` -- vier `append_forward_var_literal(vars, "COMDARE_BESTANDSLOG...")`-Aufrufe, die die Werte zur **Emissionszeit literal** in den `variables:`-Block eines Bridge-Jobs einbrennen und per `forward: yaml_variables: true` an die Grandchild-Pipeline reichen. **Zeilenangabe exakt bestaetigt.**
- Konsumenten existieren produktiv: `super/Code/02_messung_driver/main.cpp:1119` (`env_trimmed("COMDARE_BESTANDSLOG") == "true"`), `ce/.../profile_run_entry.hpp:435`.

**Warum die Messung fuer sich korrekt war:** `grep` ueber das Repo ist vollstaendig -- **fuer eingecheckte Dateien**. Die Mess-Jobs stehen aber in keiner eingecheckten Datei; sie entstehen erst durch den Plan-Director.

**Klassenmerkmal:** jede "X wird nirgends gesetzt"-Aussage in einem System mit Code-Generierung. Erste Rueckfrage: **ist das Artefakt eingecheckt oder emittiert?**

---

### R-5 -- Zur Testzahl gehoert der Bau-Zustand, nicht nur der Commit

**`[x] ERLEDIGT`** (aufgeklaert) -- mit einer Praezisierung gegen die Ledger-Fassung.

**Anlassfall.** Die Testzahl sank gegenueber den Worktree-Messungen. Korrekte Zahlen: **409** im Wellen-Baum, **405** im frischen Baum -- Differenz **4**; plus zwei neue B14-Tests = **407**. (Die Fassung "407 statt 409" mischt zwei Groessen; die Anker-Differenz ist 409 -> 405.)

**Am Objekt geprueft:** `ce/tests/unit/CMakeLists.txt:1544` (`if(_r5g_autobuilt_count GREATER 0)`) und `:1565` (`if(TARGET comdare_f15_compare_cli)`) -- beide Zeilenangaben exakt. Innerhalb dieser Bloecke werden `test_v41_anatomy_adhoc_autobuilt_load` und `f15_compare_cli_smoke` registriert.

**Praezisierung:** die Ledger-Fassung nennt zwei Praedikate, der Mechanismus ist **breiter**. Die anderen beiden Tests haengen an weiteren Configure-Bedingungen: `test_v41_anatomy_r5i_configure_codegen` (`:1082`, `if(_r5i_status STREQUAL "FOUND" AND EXISTS ...)`), `test_v41_anatomy_f15_measurement` (`:1188`, `if(_f15_status STREQUAL "FOUND" AND EXISTS ...)`). Vier Tests, **mindestens vier** Bedingungen.

**Warum die Messung fuer sich korrekt war:** `ctest` zaehlt exakt die registrierten Tests. Registriert wird aber, was CMake zur **Configure-Zeit** gesehen hat -- und das haengt an vorgebauten Artefakten, nicht am Commit.

**Klassenmerkmal:** jede gesunkene Testzahl. Sie ist erst dann ein Befund, wenn die **Mengendifferenz in beide Richtungen** geprueft ist.

**Live-Beleg fuer dieselbe Klasse:** `ctest --test-dir build -N` liefert im lokalen ce-Baum **331** Tests, die Pipeline meldet **411**. Der lokale Baum ist teilkonfiguriert. **Lokale Zaehlungen sind keine Pipeline-Aussagen.**

---

### R-6 -- Ein gruenes Gate deckt nur seinen eigenen Gegenstand

**`[~] TEILWEISE`** -- Instanzen geheilt, die strukturelle Luecke offen.

**Anlassfall.** Die Diff-Hygiene-Wache war **dreimal gruen**, ueber die richtige merge-base -- und `lint:format` fand trotzdem **94 Verstoesse in 13 Dateien** `[BERICHT]`. Die Wache prueft ASCII und Spaltenbreite ueber **Diff-Zeilen**; `lint:format` prueft clang-format-Konformitaet ueber **ganze Dateien**. Zwei verschiedene Gegenstaende.

**Am Objekt gegengeprueft:**
- `98952e02` traegt die Botschaft "ueber die 13 Dateien", der Baum sagt **12 Dateien, +86/-89**. Die dreizehnte (`system_version_suffix.hpp`) wurde in `e7aa1244` mitgeheilt (**+12/-3**). Botschaft ungenau, Ergebnis nicht.
- **Unabhaengige Bestaetigung aus dem super:** `b35aea1b` = **8 Dateien, +147/-164**, Commit-Titel woertlich: *"lint:format war nie gegen die Landung gefahren"*. Zwei Repos, kein gemeinsamer Bauweg, dasselbe Loch.

**Warum die Messung fuer sich korrekt war:** die Wache hat exakt gemessen, was sie zusagt. Niemand hatte das Format-Gate je als **eigenen** Gegenstand gefuehrt.

**Klassenmerkmal:** eine Freigabe, die Gates aufzaehlt, die **gelaufen** sind. Die Klasse zeigt sich in der Liste, die fehlt: **welche Gates sind nicht gelaufen?**

**Naechste Handlung:** `[ ]` Kein Werkzeug erzwingt heute die Nennung der nicht-gelaufenen Gates. Solange das Disziplin bleibt, wiederholt sich der Fall. **T3**.

---

### R-7 -- Ein Gate-Umfang ist repo-spezifisch

**`[x] ERLEDIGT`** (gemessen) -- mit offenem Folgeposten.

**Am Objekt exakt reproduziert.** Derselbe Job, zwei Repos:
- ce (`.gitlab-ci.yml:55`, `COMDARE_LINT_PATHS: "libs apps tests adapters benchmark_suite benchmarks"`): am Stand `98952e02` **1731** verfolgte C/C++-Dateien -- **zeichengleich zur Ledger-Zahl**; heute **1733** (+2 aus A1-NB2).
- super (`.gitlab-ci.yml:69-70`, `COMDARE_LINT_PATHS: "Code"` plus `COMDARE_LINT_EXCLUDE_RE: "(^|/)(ext|build|_archive_code_pre_migration|cmake-build-[^/]*|modules|external|thesis)/"`): **59** Dateien.

Verhaeltnis **rund 29:1**. Wer eine Dateiliste oder eine Zahl vom einen Repo ins andere traegt, misst am falschen Umfang.

**Klassenmerkmal:** eine Zahl, die ohne Neuberechnung ueber eine Repo-Grenze wandert.

**Naechste Handlung:** `[ ]` s. R-1 -- der super fuehrt die Diff-Hygiene-Wache gar nicht. **T3**.

---

### R-8 -- Ein Submodul-Zeiger kann RUECKWAERTS zeigen; `M` heisst nicht "neuer"

**`[x] ERLEDIGT`** fuer den Anlassfall. Der Fall vollstaendig in **Z-3**.

**Regel-Zeile, verbatim (Ledger `:4285-4287`):**

> "**Ein Submodul-Zeiger im Working Tree kann RUECKWAERTS zeigen. `M` heisst nicht 'neuer'.** Vor jedem Commit, der einen Gitlink beruehren koennte: Richtung pruefen (`git merge-base --is-ancestor <checkout> <zeiger>`), nicht die Aenderung als Nachzug annehmen."

**Warum die Messung fuer sich korrekt war:** `git status` sagt zutreffend "modifiziert". `M` ist eine Aussage ueber **Ungleichheit**, nicht ueber **Richtung**.

**Klassenmerkmal:** jedes `M` oder `+` auf einem Gitlink. Richtung ist je Submodul zu **messen**, nie fortzuschreiben -- im selben Status zeigte der ce-Zeiger korrekt vorwaerts. **Live bei Abfassung:** `+f57801d3` fuer `Code/external/comdare-cache-engine`, Richtung gemessen: **vorwaerts, 2 Commits** -- aber uncommittet (S-1).

---

### R-9 -- Eine rescue-Ref ist keine Landung

**`[x] ERLEDIGT`** fuer den Anlassfall -- **`[ ] OFFEN`** als Routine. Der Fall vollstaendig in **Z-4**.

**Regel-Zeile, verbatim (Ledger `:4289-4291`):**

> "**Eine rescue-Ref ist KEINE Landung.** Fertige, gepushte, auf BEIDEN Remotes liegende Arbeit kann trotzdem in **keinem Zweig** sein. 'Liegt auf origin' beantwortet die Frage 'ist es gelandet?' nicht -- das tut nur `merge-base --is-ancestor <commit> <zweig>`."

**Verschaerfung `[BERICHT]`:** die rescue-Ref hatte einen **eigenen gruenen CI-Lauf** (`thesis 14964`, `success`). Nicht einmal "gruen getestet" impliziert "gelandet".

**Klassenmerkmal:** jedes Signal, das "fertig" bedeutet, ohne "erreichbar von einem Zweig" zu bedeuten -- gepusht, gesichert, gruen, reviewed.

**Naechste Handlung:** `[ ]` Es liegen **20+ rescue-Refs** auf den Remotes des ce (heute gezaehlt, u. a. `rescue/b14-nb3-ce-16a173f2`, `rescue/a1-nb2-komplett-fdfa68ee`, `rescue/t2a-komplett-3a42bf90`, `rescue/r4-ci-abdeckung-dcb2f08f`) und eine im Thesis-Repo (`rescue/gate8-graph-abbildungen-8970465d`). Routine noetig, die je Ref `merge-base --is-ancestor` gegen `development` **und** `main` faehrt und die nicht-erreichbaren auflistet. **T3**.

---

### R-10 -- Ein Paketschnitt, der nur in einem Session-Dokument steht, existiert fuer die Ausfuehrung nicht

**`[ ] OFFEN`** -- der Fall vollstaendig in **Z-6**, die Handlung in **B-1**.

**Am Objekt exakt bestaetigt (heute nachgezaehlt).** `/usr/bin/grep -c "LB-[0-9]"` in `super/docs/sessions/20260806-REGISTER-todo-konsolidierung-14-tage.md` (474 Zeilen) = **0**. Im Ledger (5840 Zeilen) = **8** -- und diese acht sind **nicht** die Buchung des Paketschnitts, sondern die Buchung seines **Fehlens** (Nachtrag `9f5ff1d2`; Gegenprobe gegen `9f5ff1d2^` liefert **0**).

**Die Ursache ist praeziser als "verloren".** Das Register nennt seine Quellen selbst -- Ledger 23.-31.07., Ledger 01.-06.08., Dossier/Doku-Register, Live-Lesung des Fahrplans. `docs/sessions/*` ist in dieser Aufzaehlung **nicht enthalten**. Eine Erhebung findet nichts in einer Klasse, die sie nicht liest.

**Regel-Zeile, verbatim (Ledger `:4470-4474`):**

> "**Ein Paketschnitt, der nur in einem Session-Dokument steht, existiert fuer die Ausfuehrung nicht.** Jede Kette mit Vor-Trigger-Anspruch gehoert in den Ledger UND in die Checkliste -- ein Session-Doc ist ein BELEG, kein REGISTER. Und jede Konsolidierung, die eine Quellenklasse auslaesst, muss das in ihrer Methodik ausweisen, sonst liest man ihr Schweigen als Abwesenheit."

**Klassenmerkmal:** jede Konsolidierung, die ihre Quellen aufzaehlt. Die Luecke steht nicht in der Liste -- sie ist das, was **nicht** darin steht.

---

## I.3 Neubefunde aus dem Verifikationsdurchgang selbst

Diese vier sind nicht in der Session gefunden worden, sondern **beim Nachpruefen der Session**. Alle vier sind Methoden-Befunde: sie betreffen das Messen, nicht das Gemessene.

### N-1 `[ ] OFFEN` -- Die Wache bindet das Repo an ihren eigenen Ort, nicht an das Arbeitsverzeichnis des Aufrufers

**Ort:** `ce/scripts/ci_diff_ascii_width_guard.sh:141-142`.

**Beleg (selbst gemessen).** Das Skript setzt `_ce_repo_root=$(cd "$(dirname $0)/.." && pwd)` und ruft `git -C "$_ce_repo_root" diff`. Aufgerufen aus `cwd=/home/comdare/wt-b14-ce` (HEAD `cc20b63d`) meldete die Wache `Repo: .../Code/external/comdare-cache-engine` (HEAD `47c4ef1d`) und mass **12578** statt **1450** Zeilen -- ein GRUEN ueber einen **fremden Baum**.

**Was die Wache richtig macht:** sie druckt ihren Bezugsrahmen (`MODUS: git diff selbst ausgefuehrt (Repo: ...)`) -- R-1 korrekt angewandt. Wer die Zeile ueberliest, bekommt exakt die Klasse zurueck, gegen die die Wache gebaut wurde.

**Korrekte Nutzung fuer Worktrees:** `git diff ... | sh .../ci_diff_ascii_width_guard.sh --stdin`.

**Ehrliche Anmerkung:** der Pruefer ist bei dieser Verifikation **selbst** in die Falle gelaufen und hat sie erst durch die Zahlendifferenz bemerkt.

**Naechste Handlung:** Skript soll das Repo aus `git rev-parse --show-toplevel` des **Aufrufer**-cwd bestimmen und den Selbst-Ort nur als Fallback nehmen; oder die `--stdin`-Form in der Paketmeldungs-Prozedur verbindlich machen. **T3**.

### N-2 `[ ] OFFEN` -- Zeilendrift in Belegen

**Beleg (heute dreifach gemessen).** Die LB-Registrierung wurde im Ledger an `ce/tests/unit/CMakeLists.txt:4970` genannt; ein spaeterer Verifikationslauf fand sie an **:4995/:5008**; **heute** stehen sie an **:5003** (LB-0) und **:5019** (LB-1). Drift innerhalb eines Tages: **49 Zeilen**, ueber zwei Landungen. Die Substanz haelt, die Fundstelle nicht.

Zweiter Fall: `ce/tests/unit/thesis_tiere/linux_perf_pmc_smoke.cpp` -- der `SMOKE_SKIP`-Zweig stand als `:58-62` im Befund, liegt heute bei `:61`.

Dritter Fall: die TEST-Makro-Zahlen der LB-Tests wurden als **33** und **23** notiert; `/usr/bin/grep -c "^TEST"` liefert heute **34** und **26**. Ob Drift oder abweichende Zaehlmethode ist nicht entschieden -- **genau das ist der Befund**: eine Zahl ohne genannte Zaehlmethode ist nicht nachpruefbar.

**Klassenmerkmal:** ein Beleg, der ausschliesslich aus `Datei:Zeile` besteht. Zeilenangaben altern.

**Naechste Handlung:** jeder Beleg traegt neben der Zeile einen **Suchbegriff** und, bei Zahlen, die **Zaehlmethode** (`/usr/bin/grep -c "<muster>" <datei>`). **T3**, als Doku-Konvention.

### N-3 `[ ] OFFEN` -- Der lokale ce-`main` ist veraltet

**Beleg.** Im Hauptklon zeigt `main` auf `2b0a9bd8`, `origin/main` auf `47c4ef1d` (live `ls-remote`). Ein lokal gefahrenes `merge-base --is-ancestor X main` -- also **genau das Werkzeug aus R-9** -- antwortet ueber einen veralteten Baum.

**R-9 gilt auch fuer ihr eigenes Pruefmittel:** der Bezugszweig ist vor der Frage zu aktualisieren, sonst ist die richtige Methode auf dem falschen Gegenstand gefahren -- die These dieses Kapitels, angewandt auf sich selbst.

**Naechste Handlung:** Landungs-Pruefungen grundsaetzlich gegen `origin/<zweig>` fahren, nach `git fetch --all --prune`. **T3**, als Prozedur-Regel.

### N-4 `[ ] OFFEN` -- Veraltete remote-tracking-Refs beantworten eine Frage ueber den Remote

**Beleg (selbst erlebt, mit Beinahe-Fehlmeldung).** Bei der Pruefung der Dual-Remote-Doktrin zeigte `git for-each-ref` im Thesis-Submodul:

```
refs/remotes/github/development 29a1700
refs/remotes/github/main        29a1700
refs/remotes/origin/development 8e58f69
```

Der naheliegende Schluss -- "die GitHub-Sicherung ist vier Commits zurueck und enthaelt Gate 8 nicht" -- waere ein **Befund mit Abgabe-Relevanz** gewesen. Die Live-Messung widerlegt ihn:

```
$ git ls-remote github refs/heads/development refs/heads/main
8e58f691...  refs/heads/development
8e58f691...  refs/heads/main
```

**Entlastet (E-h).** Der lokale Cache war schlicht nicht gefetcht.

**Klassenmerkmal:** jede Aussage ueber einen **Remote**, die aus `refs/remotes/*` gelesen wurde. `refs/remotes/*` ist eine **lokale Kopie mit unbekanntem Alter** -- die Frage "was liegt dort?" beantwortet nur `git ls-remote`.

**Naechste Handlung:** Remote-Aussagen ausschliesslich per `ls-remote` belegen; `for-each-ref` nur fuer lokale Fragen. **T3**, als Prozedur-Regel.

---

## I.4 Bilanz des Kapitels

Zehn Regeln, ein Muster. **Sieben** der zehn sind heute an einem **Werkzeug** verankert -- `ci_diff_ascii_width_guard.sh` (15679 B) und `ci_yaml_key_guard.sh` (9378 B); letztere gemessen: **30** Top-Level-Schluessel, **30** verschiedene Namen, gruen. Sie schliesst die Wurzel, ueber die `contract:axis-version-lock` 18 Tage doppelt definiert und damit faktisch AUS war (SW-1).

**Drei** sind reine Disziplin geblieben: R-3 (Vollstaendigkeitsaussagen), R-6 (die Liste der **nicht** gelaufenen Gates) und R-10 (Paketschnitt in Session-Dokumenten). Genau diese drei sind die naechsten Kandidaten fuer eine Automatisierung -- denn die Session hat gezeigt, dass Disziplin gegen diese Fehlerklasse **nicht traegt**: sie erzeugt kein Fehlersignal, sondern eine korrekte Zahl.

---

# KAPITEL II -- DIE STILLEN WACHEN: was gruen meldete, ohne zu pruefen

## II.0 Was diese Klasse ausmacht

Eine **defekte** Wache ist billig: sie faellt rot, jemand repariert sie. Eine **stille** Wache ist teuer, weil sie **Sicherheit produziert, die es nicht gibt**. Sie meldet gruen, ohne gemessen zu haben, und jede spaetere Entscheidung stuetzt sich auf dieses Gruen.

Alle sechs Faelle unten teilen dieselbe Anatomie: eine Zusicherung wurde **einmal** geprueft, dann in eine Konstruktion gegossen, die den Pruefvorgang **nicht wiederholen** kann -- und niemand hat je die Frage gestellt, ob sie noch laeuft.

Zwei Behauptungen der Session haben die Nachpruefung **nicht** bestanden (SW-6) bzw. mussten in ihrer Zahl korrigiert werden (SW-2); beide stehen unten mit korrigiertem Status, nicht gestrichen.

---

### SW-1 -- `contract:axis-version-lock` war 18 Tage lang gar nicht vorhanden

**`[x] ERLEDIGT`** -- geheilt durch `597ecffe` (06.08., 15:54:04 UTC) und `557d8023` (15:58:10 UTC).

**Ort:** `ce/.gitlab-ci.yml:447` (die eine verbliebene Definition), Wegweiser-Kommentar `:628-635`, Schluessel-Wache `:241`.

**Beleg (heute am HEAD nachgezaehlt).** `/usr/bin/grep -c "^contract:axis-version-lock:" .gitlab-ci.yml` -> **1**. Die drei verbliebenen Vorkommen von `COMDARE_AXIS_LOCK_CHECK` (`:436`, `:438`, `:630`) sind ausschliesslich Kommentar-Text, der den Vorgang dokumentiert. Die Doppelvergabe ist getilgt.

**Der Mechanismus, exakt.** Der Schluessel war zweimal vergeben. Die Zeitstempel widerlegen die naheliegende Vermutung, die aeltere Fassung habe gewonnen, weil sie aelter war -- es war genau umgekehrt:

- `7492b2ea`, **19.07. 12:51:55 UTC** -- die INERT-Fassung, `rules: - if: $COMDARE_AXIS_LOCK_CHECK == "true"`, stand am **Dateiende**.
- `76b6ef01`, **19.07. 15:42:56 UTC** -- knapp drei Stunden **spaeter**, bewusst **ohne** `rules` als hartes Dauergate, stand textlich **weiter oben**.

YAML-Mappings verwerfen bei doppeltem Schluessel kommentarlos alles ausser der **letzten** Definition -- letzte nach **Textposition**, nicht nach Commit-Zeit. Die spaetere Verschaerfung verlor also gegen die fruehere Abschwaechung, und zwar **ab ihrem ersten Tag**. Da `COMDARE_AXIS_LOCK_CHECK` nirgends gesetzt ist, lief der Tripwire in **keinem einzigen Lauf**.

**Wie lange.** 19.07. 15:42:56 bis 06.08. 15:54:04 = **18 Kalendertage**. Der Repo-Kommentar rundet auf "drei Wochen"; die exakte Zahl ist 18 Tage.

**Was in dem Fenster durchkam -- am Diff nachgelesen, nicht behauptet.** Zwei semantische Drifts am Heuristik-Header `ce/libs/cache_engine/heuristik/measurement_curve_loader.hpp`, beide **ohne** `AXIS_ALGO_VERSION`-Bump:

- `150b0ede` (26.07. 23:46:52): `na_tokens` von `{"n/a", "failed", "-", ""}` auf `{"n/a", "failed", "gesperrt", "-", ""}`.
- `0fdeccff` (02.08. 15:58:56): weiter auf `{"n/a", "failed", "gesperrt", "nicht_gebaut", "-", ""}`.

Beide Diffs beruehren Zeile 2 des Headers **nicht** -- der Versions-Marker blieb bei `1`, waehrend sich die Verwerf-Semantik des Kurven-Loaders zweimal aenderte. Genau dagegen war das Gate gebaut.

**Was es gekostet haette.** Der Loader entscheidet, welche CSV-Zeilen als Messpunkt zaehlen und welche als Phantom-Punkt verworfen werden. Eine unbemerkte Semantik-Aenderung verschiebt **die Punktmenge jeder Heuristik-Kurve** -- rueckwirkend und unsichtbar, weil kein Digest widerspricht. In einer Arbeit, deren Kernbeitrag Messkurven sind, ist das kein CI-Problem, sondern ein **Ergebnis**-Problem.

**Heilung, belegt.** `597ecffe` fuehrt beide Fassungen zu **einer** zusammen, und zwar auf die **strengere** Wirkung (ohne `rules`); die opt-in-Fassung ist bewusst nicht uebernommen. Gegen die Rueckkehr der Klasse: `ce/scripts/ci_yaml_key_guard.sh` (9378 B, am Objekt vorhanden), aufgerufen als **erster** Schritt in `test:coverage-guard` (`.gitlab-ci.yml:241`) -- billig, vor jedem Bau, und eine Stufe **frueher** als die Abdeckungs-Rechnung, weil ein verschluckter Job eine Pipeline nachrechnen liesse, die es so gar nicht gibt. `557d8023` zieht die durchgelassene Drift nach: `AXIS_ALGO_VERSION: 2` in `measurement_curve_loader.hpp:2` (`break_even.hpp` und `axis_spline.hpp` stehen unveraendert auf `1`) plus Lock-Regen.

**Klassenmerkmal:** eine Wache, deren **Aktivierung** an einer Variablen haengt, die niemand setzt -- und ein Schluesselraum (YAML-Mapping, CMake-Cache, Umgebungsvariable), in dem doppelte Vergabe **stumm** ist.

---

### SW-2 -- Neun Tests in keinem Job. Und es war der zweite Durchgang.

**`[x] ERLEDIGT` an der Wurzel** -- `dcb2f08f` (06.08., 13:46:48 UTC).

**Ort:** `ce/.gitlab-ci.yml:575-582` (der getilgte Ausschluss samt Befund-Kommentar), `scripts/ci_test_coverage_manifest.sh:127-129`, `scripts/ci_test_coverage_guard.sh` (beide am Objekt vorhanden, 9601 B und 12125 B).

**Beleg, mit Bezugsgroesse.** Der Ledger-Eintrag (`:5193`) haelt die Live-Messung fest: **404 registrierte Tests**; `-L` und `-LE` mit demselben Regex bilden eine **exakte Partition** von **363 + 41 = 404**; von den 41 contract/pmc-Tests kommen 32 in irgendeinem `-R` vor, **neun kommen in der gesamten `.gitlab-ci.yml` null Mal vor**. Die neun stehen namentlich im Repo (`.gitlab-ci.yml:580-582`) und existieren alle in `tests/unit/CMakeLists.txt` (je 7-10 Treffer): `test_experiment_kern_seam`, `test_experiment_projection`, `test_merge_plan_directive`, `test_experiment_plan_director`, `test_experiment_dock_payload`, `test_progress_delta`, `test_gn_cell_filter`, `test_org18_persistence_target`, `test_phase_b_effective_search_algo_contrast`. Sie wurden in **jedem** Lauf gebaut -- ihre Assertions liefen **nie**.

**Zahlen-Praezisierung (Korrektur gegen die Session).** Die 404 ist die Zahl eines **Ein-Pass**-Configures. Der Wachen-Kopf haelt fest: *"Ohne den zweiten Pass registriert CMake zwei codegen-abhaengige Tests NICHT (live gemessen 2026-08-06: 404 statt 406)"* -- die Ground Truth ist **406**. Die Partition 363+41 ist korrekt gerechnet, aber gegen den kleineren Wahrheitsbegriff. Die spaeteren Bilanzen 407/407 und 411/411 sind `[BERICHT]`.

**Der Rueckfall -- das ist der eigentliche Befund.** Am **13.07.** hatte ein manueller Audit (`1a111ed6`, "M-CE-25") bereits **21 CI-tote contract/pmc-Tests** in passende Jobs geroutet; die Commit-Nachricht sagt es woertlich: *"M-CE-25: 21 CI-tote contract/pmc-Tests (kein dedizierter Job fuhr sie) in passende Jobs geroutet"*. In drei Wochen waren **neun neue nachgewachsen**. **Ein manueller Fix haelt hier nachweislich nicht** -- "Test anlegen" und "Test in einen Job eintragen" sind zwei getrennte, nur menschlich gekoppelte Schritte.

**Wie es unentdeckt blieb.** Der Ausschluss `-LE contract|pmc` trug seit dem 06.07. eine Zusage im Kommentar: *"der Ausschluss verweist auf die dedizierten Gates"*. Sie war **einmal wahr** -- fuer die fuenf Tests von damals -- und wurde **nie wieder nachgerechnet**. Eine Zusicherung im Kommentar verfaellt lautlos; keine Instanz im Repo hielt die Vereinigung der 14 Job-Selektoren gegen die Gesamtmenge.

**Heilung, am Objekt geprueft.** `dcb2f08f` schneidet die Wurzel: der contract-Ausschluss faellt (`ci_test_coverage_manifest.sh:127-128` fuehrt fuer `test_unit` nur noch `-LE` / `pmc`), alle 14 Job-Auswahlen kommen aus **einer** Datei, und `test:coverage-guard` (`.gitlab-ci.yml:230`) stellt die Inventur **live** her (`ctest -N`, nicht aus einer Liste) und haelt sie gegen die Vereinigung. Der Job kann selbst nicht durchs Raster fallen: *"seine Eingabe ist die Gesamtmenge (ein neuer Test ist ohne Zutun Teil der Pruefung), er hat kein rules-Gate und kein allow_failure"* (`:224`).

**Klassenmerkmal:** eine Vollstaendigkeits-Aussage, die an **Job-Namen** haengt statt an einer **Invariante** -- und eine Liste, die **gepflegt** werden muss, damit eine Zusicherung wahr bleibt.

---

### SW-3 -- Der PMC-Preflight: vier Wachen, und keine beisst

**`[ ] OFFEN` -- Owner-Entscheid, hoechste offene Position dieses Kapitels.** Handlungsteile als A-1 bis A-4 gefuehrt.

**Ort:** `ce/libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:841 / :877 / :1194 / :1342` (Emissionsstellen), `:1333` (`allow_failure`), `:1352-1364` (Preflight); `ce/tests/unit/thesis_tiere/m3v2_pmc_smoke.cpp:71`; `ce/tests/unit/thesis_tiere/linux_perf_pmc_smoke.cpp:61`; `ce/CMakeLists.txt:67` und `:69-77`.

**Der Kern, in einem Satz:** die 131.072er-Matrix laeuft **ohne** Hardware-Zaehler und meldet gruen.

**Wache 1 -- das Flag fehlt an allen vier Emissionsstellen.** `experiment_plan_director.hpp` (2092 Zeilen) emittiert an vier Stellen `cmake -B build -G Ninja -DCOMDARE_V32_ENABLE=ON ...`. `/usr/bin/grep -c "COMDARE_ENABLE_PMC"` auf dieselbe Datei: **0** -- heute nachgemessen, unveraendert. `CMakeLists.txt:67`:

```
option(COMDARE_ENABLE_PMC "Intel PCM Windows cache-miss source (WindowsPcmPmcSource, BSD-3)" OFF)
```

Die Beschreibung sagt "Windows" -- sie gated aber ab `:69` auch den **Linux**-Zweig (`LinuxPerfPmcSource` via `perf_event_open`, `add_compile_definitions(COMDARE_ENABLE_PMC)` bei `:77`), und der Header ist selbst auf `#if defined(COMDARE_ENABLE_PMC) && defined(__linux__)` geguardet. **Ohne das Flag gibt es auf Linux gar keine PMC-Quelle** -- der Code kompiliert sich weg. Die irrefuehrende Option-Beschreibung ist ein eigener Risikofaktor.

**Wache 2 -- das Seam-Verdikt wertet lauter Nullen als bestanden.** `m3v2_pmc_smoke.cpp:71` (heute nachgelesen):

```
bool const pmc_seam_ok       = delta.available || counters_all_zero;
```

Verdikt in `:76`. Bittere Pointe: diese Abschwaechung stammt aus **demselben** Commit, der SW-2 einmal geflickt hatte -- `1a111ed6` (13.07.): *"m3v2_pmc_smoke-Inversion (live-PMC kippte SMOKE_FAIL) -> pmc_seam_ok=available||all-zero"*. Der Fix war sachlich richtig (ein echt gemessener Zaehler darf nicht als Fehler gelten), hat aber den Gegenfall mit freigegeben.

**Wache 3 -- `allow_failure: true` auf dem Mess-Batch.** `experiment_plan_director.hpp:1333` emittiert `s += "  allow_failure: true\n";` (heute nachgemessen: genau ein Treffer in der Datei). Selbst ein rotes Verdikt faerbte die Pipeline nicht.

**Wache 4 -- der eigens dafuer gebaute Preflight, und er beantwortet die falsche Frage.** `:1352-1364` emittiert in **jeden** Mess-Batch: `echo "== [PMC-PREFLIGHT] ..."`, `cmake --build build --target m3v2_pmc_smoke linux_perf_pmc_smoke`, `ctest --test-dir build -L pmc --output-on-failure`, `echo "[PMC-TESTAT] ... pmc=ok"`. Sein Kommentar benennt die Gefahr woertlich: *"ohne Preflight koennte eine Lane eine mehrtaegige Messung mit kaputtem perf_event_open durchlaufen und lauter 0-Zaehler produzieren"*, ausdruecklich *"HART in BEIDEN Profilen, auch smoke"*. Am Objekt, `linux_perf_pmc_smoke.cpp:58-62`:

```
    if (!delta.available) {
        // EHRLICHER Skip: kein Counter-Zugriff (...)
        std::cout << "SMOKE_SKIP (no PMC access - honest available=0)\n";
        return 0;
    }
```

**Exit 0.** Die Wache fragt *"ist perf kaputt?"* -- aber ohne das Flag ist die Quelle **gar nicht gebaut**, also schlicht nicht vorhanden, und Nicht-Vorhandensein gilt korrekt als ehrlicher Skip. **Die Wache ist nicht defekt; sie beantwortet eine andere Frage als die, um die es geht.**

**Die Wurzel, benannt.** Die PMC-Pflicht war an **zwei Job-Namen** geheftet statt an eine Invariante: `-DCOMDARE_ENABLE_PMC=ON` stand in *"GENAU die 2 Mess-Jobs (`measure:smoke` Z.449 + `measure:golden-320` Z.529)"*. Beim Wechsel auf die dynamische Planer-Kette blieb die Pflicht bei den alten Job-Namen zurueck -- **exakt die Fehlerklasse von SW-2**.

**Warum kein Gruen davor schuetzt.** In der gruenen Job-Liste stehen `pmc:amd` und `pmc:intel` auf `success`. Sie belegen, dass die PMC-**Faehigkeit baut** -- nicht, dass der Mess-Lauf sie **einschaltet**. Der ce-Job `.pmc` setzt das Flag korrekt (`.gitlab-ci.yml:119`) und hat kein `allow_failure`; der emittierte Mess-Batch setzt es nicht und hat eins. **Die Doktrin ist dort erfuellt, wo sie nichts kostet, und dort verletzt, wo sie zaehlt.**

**Was es kostet.** Ein mehrtaegiger Voll-Lauf ueber 2^17 mit `pmc_available=0` und sechs Null-Spalten -- gruen gemeldet, in der Thesis als gemessen zitiert, und nur durch einen kompletten Neu-Lauf zu heilen. Owner-Direktive vom 16.07., verbatim aus dem Ledger: *"MUSS als PFLICHT fuer die Vollstaendigkeit aller perf-Messwerte mit in die Ergebnisse"*.

**`[BERICHT]`, nicht selbst nachgefahren:** ohne Flag `SMOKE_SKIP` / `available=0` / alle Zaehler 0; mit Flag `available=1`, `cache_misses_l1=4191307`, `dtlb_misses=1767452`.

**Naechste Handlung** (vor jedem Voll-Lauf; durch die Lage-Korrektur terminierbar auf Liefer-Freitag 1, nicht mehr "nach der Abgabe"): siehe **A-1** bis **A-4**. **T1**.

**Klassenmerkmal:** vier Wachen, keine loest aus -- weil jede eine **andere** Frage stellt als die, die schiefgeht.

---

### SW-4 -- Die Gate-Pipe, die nie mass

**`[x] ERLEDIGT`** (Werkzeug ersetzt Prozedur) - **`[-] ENTLASTET`** fuer den CI-Umfang (E-b).

**Ort:** `ce/scripts/ci_diff_ascii_width_guard.sh` (15679 B) plus Biss-Beweis `ci_diff_ascii_width_guard.bissbeweis.txt`; verdrahtet in `test:coverage-guard`, `.gitlab-ci.yml:260-268`.

**Die kaputte Zeile.** Der ASCII-/Breiten-Selbstcheck vor jeder Paketmeldung war **kein Skript**, sondern eine von Hand eingetippte Kette:

```
git diff -U0 -- "$f" | grep '^+' | grep -v '^\+\+\+' | grep -P '[^\x00-\x7F]'
```

**Live-Reproduktion auf diesem Host, beide Engines** (nicht Bericht):

- **ugrep** (die Shell-Funktion hinter dem blossen Wort `grep`; `type grep` -> `grep is a function`, die `exec -a ugrep "$CLAUDE_CODE_EXECPATH" -G ...` ruft): `ugrep: error: error at position 5 / (?m)^+++ / \___invalid syntax`, Stufen-RC **2**.
- **GNU grep 3.11** (`/usr/bin/grep --version`): kein Fehler, aber `\+` ist in BRE die Erweiterung "ein-oder-mehr", **kein literales Plus**. Ueber die Eingabe `x / + / ++ / +++ / +abc / abc` behaelt `grep -v '^\+\+\+'` genau **`x` und `abc`** -- `+abc`, eine ganz normale Zusatzzeile, fliegt mit raus.
- **Der stille Fehlschlag, literal:** Eingabe zwei Zeilen, davon eine echte Nicht-ASCII-Zusatzzeile. Volle Kette unter ugrep -> RC 1. Volle Kette unter GNU -> RC 1. **Beide "sauber".** Dieselbe Zeile ohne die kaputte Mittelstufe: `+Möwenstraße`, RC 0.

`set -o pipefail` rettet nicht: die letzte Stufe endet bei leerer Eingabe selbst harmlos mit 1, und genau dieser Code gewinnt -- **ununterscheidbar von einem echten Nicht-Befund**.

**Entlastung, mit Bezugsgroesse.** Ueber beide Repos (`.gitlab-ci.yml`, `scripts/`, `cmake/`): **0** Fundstellen dieser Kette ausserhalb der Kommentare der neuen Wache selbst (die 6 Treffer liegen samtlich in `ci_diff_ascii_width_guard.sh:15,20,27,30` und `.gitlab-ci.yml:248,250`, alles erklaerender Text). **Kein CI-Job war betroffen** -- der Schaden war auf die manuelle Agenten-Prozedur begrenzt.

**Ehrlich benannte Restgrenze** (Job-Kommentar `.gitlab-ci.yml:256-259`): die Skript-**Logik** ist bissgetestet (vier praeparierte Faelle), die **CI-Variablen-Verdrahtung** konnte nur syntaktisch bestaetigt werden -- *"der erste echte Lauf ist der Beweis dieser einen Stelle"*.

**Klassenmerkmal:** eine Pipe, deren **mittlere** Stufe scheitern kann, ohne dass der Gesamt-Exit es traegt -- und ein Regex, der auf zwei Engines **zwei verschiedene Sprachen** spricht.

**Folgeposten:** N-1 (die neue Wache bindet das Repo an ihren eigenen Ort) und R-1 (der super hat keine Kopie).

---

### SW-5 -- `active_telemetry_is_silent()` liefert literal `false`

**`[ ] OFFEN`** (bewusst, aber unverbucht als Mess-Posten).

**Ort:** `ce/libs/cache_engine/profile_facade/profile_run_facade.cpp:240` (Definition), einziger Aufrufer `:505` -- beide heute nachgemessen.

**Beleg.** `[[nodiscard]] bool active_telemetry_is_silent() { return false; // Default = Active ... }` -- eine Konstante, kein Profil-Wiring. Dem stehen **11** Thesis-Profile gegenueber, die das Gegenteil deklarieren; die literale Form ist `<telemetry mode="on" silent="true"/>` (**nicht** `<telemetry silent="true">` wie in der Session notiert), u. a. `all_axes_golden.profile.xml:127`, `m3v2_study.profile.xml:132`, `m3_golden_coverage.profile.xml:116`, `cacheline_study.profile.xml:93`.

**Bewertung.** Der Kommentar `:230-239` **deklariert** das offen: Durchreichen haenge `+tel=silent` an das golden-`build_version` und **breche die Byte-Identitaet**; das Wiring sei *"ein bewusst golden-BRECHENDER Folge-Schritt (eigene Absprache)"*. Das ist kein Versehen. Der Befund bleibt trotzdem **offen**, weil die Konsequenz nirgends als Mess-Posten gefuehrt ist: **die XML sagt silent, gemessen wird Active.** Wer die Profile liest, haelt die Deklaration fuer wirksam.

**Naechste Handlung:** entweder das Wiring bauen (mit bewusstem golden-Bruch, Owner-Entscheid) **oder** eine Wache, die den Widerspruch XML-vs-Ist beim Profil-Laden **laut** meldet. Bis dahin: Klarstellung im Ergebnis-Teil. **T2**.

**Klassenmerkmal:** eine Deklaration in einer Konfigurationsdatei, deren Wirkung im Code **hart verdrahtet** gegenteilig ist -- ohne dass irgendetwas den Widerspruch meldet.

---

### SW-6 -- `COMDARE_LEGACY_MESSREIHEN`: die Session-Behauptung faellt an der Repo-Grenze

**`[~] TEILWEISE`** -- der Kern haelt, die **Vollstaendigkeits-Aussage** ist **widerlegt**.

**Behauptung der Session** (`super/docs/plaene/20260806-PLAN-kostenklammer-restposten.md:314-322`): *"Repo-weit (Quellbaum, `build*/` ausgenommen) genau 3 Treffer, alle 3 Kommentare. Kein `#ifdef`, kein `getenv`, keine CMake-`option()` dieses Namens."*

**Was haelt.** In `ce` stimmt es exakt: drei Treffer (`xml_config_parser.hpp:14`, `xml_config_parser.cpp:147`, `test_data_sets.xml:5`), alle Kommentar. Und der Kern des Vorwurfs ist am Objekt bestaetigt: `xml_config_parser.cpp:149` liest `test_data_sets.xml` **unbedingt**, kein Gate davor -- waehrend der Kommentar zwei Zeilen darueber behauptet, die Datei *"existiert nirgends (0x)"*. Sie existiert (1352 B) und traegt **drei** Datensaetze (`ycsb_a`, `ycsb_c_zipfian`, `commoncrawl_urls`).

**Was NICHT haelt.** Das Gate existiert -- im **super**-Repo. `super/Code/02_messung_driver/main.cpp` fuehrt es dreimal **live** aus: `:701` und `:718` je `if (env_trimmed("COMDARE_LEGACY_MESSREIHEN") == "1") {`, `:1372` `if (env_trimmed("COMDARE_LEGACY_MESSREIHEN") != "1") return e4_overall_rc;`. Es gated den V37.C-/V38.C-Legacy-Treiberpfad -- **etwas anderes** als den ce-Parser-Slot, aber es ist **kein Phantom**.

**Genau das ist die Ironie und der Lehrsatz.** Die Session hat den Fehler *"X existiert nirgends"* diagnostiziert und dabei **selbst begangen**: eine Vollstaendigkeits-Aussage, gemessen in genau **einem** der zwei beteiligten Repositories. Der Owner-KERN `feedback_behauptungen_verifizieren_layer_vertraege_halten` adressiert genau das.

**Entlastung (E-c):** **Kein heutiger Messwert haengt daran** -- die Mess-Strecke laeuft ueber den E4-/Profil-Weg, `COMDARE_AUTO_RUN_BUILDER` steht per Default auf OFF. Der Schaden ist **falsches Sicherheitsgefuehl**, nicht ein falscher Wert.

**Naechste Handlung:** die drei ce-Kommentare auf den Ist-Stand bringen -- **nicht** "das Gate gibt es nicht", sondern "das Gate liegt im super und deckt **diesen** Aufruf nicht". Die Falschaussage *"existiert nirgends (0x)"* streichen, die 3 Datensaetze benennen. Zweite Stufe (Owner): gaten oder ehrlich als ungegatet-deprecated ausweisen. **T3**, im Aufraeumpass (F-3).

---

## II.7 Die Wiedererkennungs-Merkmale der Klasse

Wer in vier Wochen einen Verdacht pruefen will, sucht nach diesen fuenf Formen:

1. **Aktivierung an einer ungesetzten Variablen.** Prueffrage: *Wo wird sie gesetzt?* (SW-1)
2. **Zusicherung im Kommentar statt Invariante im Code.** Prueffrage: *Wann wurde sie zuletzt maschinell nachgerechnet?* (SW-2, SW-3)
3. **Pflicht an einem Job-/Datei-Namen statt an einer Vollstaendigkeits-Bedingung.** Prueffrage: *Was passiert beim Umbenennen?* (SW-2, SW-3)
4. **Wache mit falscher Frage.** Prueffrage: *Kann "nicht vorhanden" als "in Ordnung" durchgehen?* (SW-3, SW-4)
5. **Vollstaendigkeits-Aussage mit zu kleinem Suchraum.** Prueffrage: *Ueber welche Repos, welche Dateitypen, welche grep-Engine?* (SW-6, und die 404-vs-406-Praezisierung in SW-2)

**Bilanz des Kapitels:** sechs Faelle -- **drei erledigt** (SW-1, SW-2, SW-4), **zwei offen** (SW-3 als P0 vor jedem Voll-Lauf, SW-5), **einer teilweise** mit widerlegter Vollstaendigkeits-Aussage (SW-6). Die drei erledigten sind allesamt am **06.08.** geheilt worden -- am selben Tag, an dem sie gefunden wurden, und alle drei durch **Werkzeuge**, nicht durch Handgriffe. Das ist der einzige Fix, der bei dieser Klasse nachweislich haelt: **SW-2 ist der Gegenbeweis fuer den manuellen Weg.**

---

# KAPITEL III -- WENN DIE HEILUNG NEBEN DIE WUNDE TRIFFT

## III.0 Was diese Klasse ist -- und warum sie schwerer wiegt als ein offener Defekt

Kapitel II handelte von Defekten, die **niemand sah**. Dieses Kapitel handelt von Defekten, die jemand sah, benannte, heilte -- und bei denen **der geheilte Zustand falsch war oder die Heilung neben die Wunde traf**.

Diese Klasse ist gefaehrlicher als die erste, weil sie ein **Gruen erzeugt**: nach der Heilung steht ein Commit im Log, eine Wache ist gebaut, ein Test ist gruen, und der Posten gilt als erledigt. Der Rueckweg ist damit versperrt -- **niemand sucht ein zweites Mal an einer Stelle, die als geheilt verbucht ist.**

**Sechs der sieben Eintraege dieses Kapitels wurden erst durch Gegenpruefung einer bereits fertigen Heilung gefunden, nicht durch die Erstpruefung.** Das ist der Befund hinter den Befunden.

**FALLE aus der Verifikation:** der **lokale** Branch `main` im ce-Arbeitsklon steht auf `2b0a9bd8` und ist 54 Commits hinter `origin/main`. Wer "ce main" ohne `origin/`-Praefix aufloest, misst gegen einen Stand vom Vortag (N-3). Alle Aussagen unten sind gegen `origin/development` gefahren.

---

### H-1 `[x] ERLEDIGT` -- Der CLU-Konsument: eine korrigierte Messgroesse ohne ihren Verbraucher

**Ort:** `ce/libs/cache_engine/include/cache_engine/measurement/system_axis.hpp:308-360` (`ObserverSnapshotSystemAxis`), Produzentenseite `ce/libs/cache_engine/axes/layout/axis_05_memory_layout_observable.hpp:146-171`.

**Was passierte.** B14-NB3 (`16a173f2`) heilte einen echten Defekt: `cache_lines_touched` zaehlte mit dem Literal 64, obwohl die cacheline-Unterachse 32/64/128/256 zulaesst -- die Achse war in dieser Messgroesse unsichtbar. Nach der Heilung zaehlt der Zaehler **in Linien der Achse**. Damit aenderte sich die **Einheit** einer Zahl, die ueber die Modul-ABI in eine Mess-Zelle wandert.

Der einzige aktive Verbraucher dieser Zahl -- die CLU-Bildung in `system_axis.hpp` -- trug seinen Nenner weiter als hartes Literal 64. **Die Heilung haette damit neue Falschwerte erzeugt, wo vorher nur eine blinde Achse stand.**

**Beleg, unabhaengig nachgerechnet** (n=1024, record_size=48, field_bytes_read = 1024*8 = 8192):

| Belegung | cache_lines | line_bytes | Produkt | Alt-Nenner (Literal 64) | Richtig |
|---|---:|---:|---:|---:|---:|
| B32 | 1536 | 32 | 49152 | 8192*100/98304 = **8 %** | 16 % |
| B64 | 768 | 64 | 49152 | 8192*100/49152 = **16 %** | 16 % |
| B128 | 384 | 128 | 49152 | 8192*100/24576 = **33 %** | 16 % |
| B256 | 192 | 256 | 49152 | 8192*100/12288 = **66 %** | 16 % |

Der physische Fussabdruck ist in allen vier Faellen **identisch** (`cache_lines * line_bytes == 49152`). Vier verschiedene Auslastungen fuer einen unveraenderten Scan.

**Was es gekostet haette.** Eine Prozentzahl, die direkt in die Evaluations-CSV der Arbeit geht, haette bei aktivierter KF-6-NTTP-Belegung einen **Faktor 8** zwischen den Randwerten aufgespannt -- und zwar plausibel aussehend, **monoton mit der Line-Groesse steigend**. Genau die Form, die man als Messergebnis interpretiert statt als Fehler.

**Wie es unentdeckt bleiben konnte.** Die B14-Wache pinnte die vier Zaehlerwerte 1536/768/384/192 als SOLL -- und war damit gruen. Sie zementierte die **neue Einheit**, ohne zu fragen, was der Verbraucher daraus rechnet. **Der Test endete eine Station vor der Zelle.**

**Heilung.** `c1c76c87` ("die CLU-Kette bis zum LETZTEN Verbraucher geschlossen", Vorfahr des heutigen Kopfs, verifiziert). Gewaehlt wurde **Weg (ii)**: die Einheit reist **neben** dem Zaehler, in `axis_stats[5][5]` (`system_axis.hpp:347`, heute nachgelesen). Der Grund steht im Code und ist nicht Bequemlichkeit, sondern Struktur:

> "diese Achse liest einen POD ueber die Modul-ABI-Grenze (eine geladene Tier-.so). Die Line-Groesse ist eine COMPILE-ZEIT-Eigenschaft der DLL; im Host existiert der Layout-Typ nicht einmal. Ein Achsen-Zugriff hier waere entweder ein zweites Literal oder eine Annahme ueber fremden Code."
> -- `system_axis.hpp:338-342`

Der Owner-KERN "Achsen-Eigenschaften NUR ueber die Achsen" endet also **an der Modul-ABI**. Das ist der eigentliche Ertrag dieses Postens: die Schnitt-Regel vom 04.08. hat eine **benannte Grenze** bekommen.

**Wache.** `ce/tests/unit/test_b14_layout_scan_line_subaxis.cpp:325-386`, Block (F): der Test fuehrt den Snapshot durch den **echten** `ObserverSnapshotSystemAxis` und pinnt 16 % in allen vier Faellen (F-3), rechnet den Alt-Nenner verbatim nach und pinnt 8/16/33/66 als das, was er gemeldet haette (F-4), und pinnt fail-closed `n/a` statt einer erfundenen Zahl bei fehlender Einheit (F-5). Zweite Wache: `test_m_contract_system_axis_wurzel.cpp:330-356`.

**Klassenmerkmal:** eine Heilung, die eine **Einheit** aendert. Dann ist die Verbraucherliste die Pflichtaufgabe, nicht die Kuer.

**Naechste Handlung:** keine.

---

### H-2 `[x] ERLEDIGT` -- Der XXE-Riegel, der den falschen Fall fing

**Ort:** `super/Code/tests/xml_canonical_utils.cmake:50-88` (Stderr-Riegel, B14-NB4), `:92-160` (Entity-Sperre, B14-NB5).

**Was passierte.** B14-NB4 baute einen Riegel gegen einen real reproduzierten Befund: `xmllint` meldet einen durch `--nonet` **blockierten** externen Entity-Load ausschliesslich auf stderr und beendet sich mit RC 0. Der Riegel `comdare_xml_assert_clean_stderr` (`:68`) macht daraus fail-closed: bei RC 0 muss stderr leer sein. Sauber gebaut, bewusst ohne Musterliste.

**Er faengt nur nicht den Fall, um den es geht.** `--nonet` verbietet **Netzzugriff, nicht das lokale Dateisystem**. Eine erfolgreich gelesene lokale Datei-Entity erzeugt weder Fehler-RC noch stderr -- es gibt fuer den Riegel **nichts zu fangen**.

**Beleg (Kanarienvogel-Praeparat, im Code als literal gefahrene Gegenprobe dokumentiert, `:99-101`):**

> `Datei : <!DOCTYPE r [<!ENTITY x SYSTEM "file:///pfad/zu/canary.txt">]><r>&x;</r>`
> `Lauf  : xmllint --noout --nonet --noent  ->  RC=0, stdout LEER, stderr LEER (0 Byte)`
> "`xmllint --noent --nonet --xpath 'string(/r)'` liefert den KOMPLETTEN Dateiinhalt zurueck."

**Konsequenz.** Die Wachen lesen `experiment_golden_kern.xml` und `all_axes_golden.profile.xml` -- die **autoritativen Bauanleitungen**. Eine Entity im Golden haette beliebigen Dateiinhalt in jede XPath-Antwort eingemischt, mit gruener Wache und ohne eine einzige Meldung.

**Klassenmerkmal:** eine Heilung, die nach **Spuren** eines unerwuenschten Vorgangs sucht, statt den Vorgang zu **verhindern**. Spurensuche ist genau so vollstaendig wie die Spuren, die das Werkzeug hinterlaesst.

**Heilung.** `cb4b15e9` (super, Vorfahr des heutigen Kopfs, verifiziert), strukturell statt symptomatisch, zwei Teile:

- **(a)** `--noent` faellt an **allen** Aufrufstellen weg. Am Objekt nachgezaehlt: fuenf `xmllint`-Aufrufe in der Datei (`:137, :141, :377, :455, :512`), **kein einziger** traegt noch `--noent`. Das Flag kommt nur noch in Kommentaren vor. Nachfolgepruefung: auch `Code/tests/fixture_schema_subset_check.cmake:183` traegt es nicht mehr, `Code/tests/golden_n_consistency_check.cmake:37` nennt es nur historisch.
- **(b)** DOCTYPE wird **komplett abgelehnt**, FATAL, vor jeder Abfrage (`:392-401`, `:475-480`). Begruendung ist eine **Grammatik-Tatsache**, keine Heuristik: ohne DOCTYPE ist keine `<!ENTITY>`-Deklaration moeglich. Erkannt wird die DOCTYPE-Praesenz **parser-basiert** ueber einen Serialisierungs-Diff (`--dropdtd` gegen normal, `:135-150`) -- ausdruecklich nicht per Text-Muster.

**Ehrlich benannte Grenze (steht im Code, `:127-134`):** diese Wache unterstuetzt ausschliesslich DOCTYPE-freie XML. Heute traegt keine der gewachten Dateien eine DOCTYPE. Wer fachlich eine braucht, muss die Grenze verschieben.

**Naechste Handlung:** keine. Beobachtungsposten fuer den Fall, dass je ein Schema mit DOCTYPE in den gewachten Satz kommt.

---

### H-3 `[x] ERLEDIGT` -- `foreach(RANGE 1 0)`: eine Wache, die sich selbst einbaute

**Ort:** `super/Code/tests/golden_n_consistency_check.cmake:329-350`.

**Was passierte.** Die B6-Wache prueft, dass jeder deklarierte Modus jede Achse freigibt. Sie stand unbedingt als `foreach(_mi RANGE 1 ${_n_modes})`. Bei einem PROFILE **ohne** `<mode>`-Block ist `_n_modes == 0`, und daraus wird `RANGE 1 0`.

**Beleg -- in dieser Umgebung nachgefahren, nicht uebernommen:**

```
$ cmake --version -> cmake version 4.3.4
$ cmake -P /tmp/rangeprobe.cmake   (foreach(_mi RANGE 1 0))
-- Durchlauf mit _mi=1
-- Durchlauf mit _mi=0
-- Durchlaeufe insgesamt: 2
```

**Zwei Durchlaeufe statt null.** Die Schleife fragte dann den nicht existierenden Modus-Knoten `[1]` ab, `active_axes` kam leer zurueck, die Achsen-Referenz war folgerichtig nie `IN_LIST` der leeren Menge -- **FATAL, mit einem leeren Modusnamen in der Meldung** (dieselbe nicht-existente Knoten-Abfrage fuer `@name`).

**Konsequenz.** Die Wache haette einen **korrekten** Bestand fuer kaputt erklaert, und die Fehlermeldung haette den Grund **verschwiegen**. Der reale Verbraucher behandelt "kein Modus" ausdruecklich als "keine Einschraenkung" (`profile_to_tree.hpp`: `is_active(ref) := (kein Modus) ? true : ref in mode.active_axes`) -- die Wache stellte also eine **andere Frage** als der Bau-Pfad.

**Klassenmerkmal:** eine Wache, die einen Defekt **selbst einbaut**, waehrend sie einen anderen heilt -- und deren Grenzfall (leere Menge) durch eine dokumentiert **undefinierte** Werkzeug-Semantik laeuft. Die CMake-Doku nennt `start > stop` fuer `RANGE` ausdruecklich undefiniert; auf dieser Maschine iteriert es **abwaerts**.

**Heilung.** `cb4b15e9`, `golden_n_consistency_check.cmake:349`: `if(_n_modes GREATER 0)` als semantisch richtige **Vorbedingung** -- nicht als Sonderbehandlung eines Fehlerfalls, sondern als Ausdruck von "ohne Modi ist nichts zu pruefen".

**Ausdruecklich nicht entlastend** (steht so im Code, `:346-348`): die reale `all_axes_golden.profile.xml` traegt heute genau ein `<mode>`, der Zweig ist also dormant. **Jedes kuenftige Profil ohne `<mode>`-Block waere betroffen.** Das ist die Owner-Doktrin gegen Kostenklammern in Anwendung -- "heute unerreichbar" entlastet nicht.

**Naechste Handlung:** keine.

---

### H-4 `[~] TEILWEISE` -- Der Kollisions-Eimer `ohne-anker` und die Tuer daneben

`[x]` Kern erledigt - `[ ]` Verfeinerung (R1) offen.

**Ort:** `ce/libs/cache_engine/builder/bestandslog/planer_driven_build.hpp:282-301` (`kPlanOhneAnker`, `plan_bau_digest`), `ce/libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:1181-1283`, `ce/libs/cache_engine/profile_facade/lazy_adhoc_source_gen.hpp:367`.

**Teil (a) -- der Eimer.** Ohne Fingerprint-Provider liefert `plan_identitaet_of` die leere Funktion; `plan_bau_digest` stempelt dann das **Wort** `ohne-anker` statt eines Digests (heute nachgelesen: `planer_driven_build.hpp:297`, `inline constexpr char kPlanOhneAnker[] = "ohne-anker";`) -- fuer **jeden** ankerlosen Bau-Stand dasselbe.

**Beleg (Ledger-Verbatim, Nachtrag nachmittag-6, Befund (a)):**

> "SELBST GEMESSEN (eigene Sonde gegen die HEAD-Header): zwei verschiedene Bau-Staende sind stempel-GLEICH, und der Zaehler-Leser nimmt den fremden an -- `kompiliert=8, plan_resume_faecher=2 von 2`, also der GANZE Plan uebersprungen."

**Warum es still ist -- und das ist der Kern.** Der Zaehler-Resume entfernt ganze **Faecher** aus dem Strom (`SlicePlanner::run`, Schritt 4), also **vor** dem Bau. `dll_is_current` -- der eine Vergleich, der Bau-Identitaet prueft -- wird **nie gefragt**, weil die Faecher gar nicht erst in den Strom gehen. Die Fingerprint-Pruefung wurde nicht ueberstimmt, sie wurde **nie gefragt**. Keine Zeile sagt es an.

**Produktiv erreichbar, nicht theoretisch:** `profile_run_entry.hpp` leert den Provider an drei Stellen -- ohne `COMDARE_BESTANDSLOG`-Opt-in (`:436`), bei unbekannter Tier-Realversion (`:438`, T2-C) und beim `na`-Zellwert (`:1013`, W10-C4) -- waehrend `bestandslog_active` an **keinem** der drei haengt.

**Teil (d) -- die Tuer, die die Heilung offenliess.** Die erste Heilung fragte "gibt es einen Provider?". Der **produktive** Provider liefert fuer nicht materialisierbare Eintraege absichtlich den leeren String:

```
lazy_adhoc_source_gen.hpp:367
    if (macro_args.empty()) return {}; // nicht materialisierbar -> keine DLL -> kein Fingerprint
```

Fuer so ein Atom ist `dll_is_current` per Konstruktion blind (leere Erwartung => nie skip, deckt also nichts). `plan_bau_digest` hashte es trotzdem mit. Sind **alle** Atome so, sind zwei Bau-Staende wieder stempel-gleich -- und der Stempel sieht dabei **gueltig** aus, kein `ohne-anker`. Die frisch gebaute Anker-Wache greift nicht, **weil der Provider gesetzt ist**.

**Die Formulierung, die dieses Kapitel traegt (Ledger-Verbatim):**

> "Wer eine Existenz-Bedingung als Heilung einer Deckungs-Frage baut, heilt die Klasse nicht, sondern nur ihren ersten Vertreter (Fehlerklasse „Wachen pruefen EXISTENZ statt WERTE", hier in Reinform)."

**Heilung.** `71b5586a` ("der Plan-Stempel zertifiziert nur noch, was dll_is_current wirklich sehen kann", Vorfahr des heutigen Kopfs). **Ein Gate, nicht zwei** (`cache_engine_builder_iterator.hpp:1246-1283`): `PlanAnkerBefund` traegt beide Ausfallgruende (`provider_fehlt`, `form_verstoesse`), `plan_anker_befund` prueft jeden Wert in der **Digest-Schleife** gegen `detail::fp_is_hex_128` (`:1276`) -- der **einen** Form-Wahrheit des Hauses, keine zweite Formwache. Ist eine Plan-Ablage benannt, aber ein Ausfallgrund gegeben, wird kein Plan und kein Zaehler geschrieben und keiner gelesen.

**Nebenertrag, verifiziert:** die Injektivitaets-Zusage im Kopf von `plan_bau_digest` ("der Trenner liegt ausserhalb des Hex-Alphabets") war bis dahin **behauptet und nirgends geprueft**. Mit `fp_is_hex_128` stimmt sie erstmals am Objekt -- ein 128-Hex-Wert kann den `\n`-Trenner nicht enthalten.

**Bewusst NICHT gefallen und richtig so:** die Bedingung `!cfg.bestand_fingerprint_fn` bleibt (`:1200`). `FingerprintFn` ist ein `std::function`; ein leeres ist ansprechbar, aber nicht aufrufbar -- ohne die Bedingung wuerde der erste Index `std::bad_function_call` **mitten im Bau, aus einer Buchhaltungs-Naht heraus** werfen. Der Code benennt das an Ort und Stelle (`:1184-1196`).

**`[ ] OFFEN -- H-4-R1: Formwache verfeinern.** Heute ist die Wache **plan-global inert**: ein einziges Atom ohne pruefbare Identitaet legt die ganze Ablage still. Richtig waere, das Atom aus dem Plan zu **nehmen**, statt den Plan zu verwerfen. Fail-closed plan-global ist die richtige **erste** Form, nicht die endgueltige.

> **Aufloesung einer Doppelbuchung:** dieser Posten wurde in der Session zusaetzlich als "Formwache pro Atom" gefuehrt und dort mangels Fundstelle als UNBELEGT eingestuft. Er ist **hier belegt** -- Quelle ist die Heilung `71b5586a` selbst. Die UNBELEGT-Einstufung ist damit **aufgehoben**; der Posten laeuft als **F-5** und ist echt.

**Naechste Handlung:** Atom-granulare Formwache. Durch die Lage-Korrektur **einplanbar ab Liefer-Freitag 14.08.**, nicht mehr "nach der Abgabe". **T4** (niedrige Prioritaet, aber terminiert).

---

### H-5 `[x] ERLEDIGT` -- Der Barrieren-Kurzschluss, und der Pruefer, der die falsche Frage stellte

**Ort:** `ce/libs/cache_engine/builder/artifact_transport/async_push_pump.hpp:90-110`.

**Was passierte.** `drain()` trug `if (closed_) return;` mit der Begruendung "nach `close()` ist der Drain ohnehin vollzogen" und einem **Kontrakt an den Aufrufer** ("laeuft aus demselben Thread wie `close()`"). Beides hielt nicht: `close()` setzt `closed_` unter dem Lock, gibt ihn frei und haengt dann im `join()`, waehrend der Worker die Restqueue abarbeitet. Ein `drain()` in genau diesem Fenster nahm die Abkuerzung, obwohl `queue_` und `in_flight_` belegt sein konnten -- danach las `push_vollzug()` ein `failed_count()`, das nichts wusste, und der Bau-Zaehler schrieb ein Fenster fort, **dessen Pushes noch liefen**.

**Beleg (gemessen):** ALT kehrte `drain()` mit `pushed_count() == 0` zurueck, wo die Zusage 1 ist.

**Der eigentliche Befund ist der Pruefer.** Ledger-Verbatim, Befund (c):

> "**EHRLICHE SELBSTKORREKTUR:** meine TSAN-Sonde des Erst-Reviews hatte genau diesen Fall nachgestellt und als [OK] gebucht -- ich hatte gefragt „haengt drain()?" (nein) statt „haelt die Barriere?" (nein). Der Befund kam von Codex; ich hatte ihn in der Hand und nicht gesehen."

Das ist dieselbe Gestalt wie die vier Regel-Zeilen der Pruefbereichs-Familie desselben Tages: *eine Messung war fuer sich korrekt und beantwortete die falsche Frage.* Die Sonde war valide, der Aufbau reproduzierte das Fenster -- nur die **Zusage, gegen die gemessen wurde**, war die falsche.

**Heilung.** `71b5586a`, ersatzloses Streichen der Abkuerzung. `drain()` steht heute als (`:107-110`, heute nachgelesen):

```cpp
    void drain() {
        std::unique_lock<std::mutex> lk(mtx_);
        drain_cv_.wait(lk, [this] { return queue_.empty() && !in_flight_; });
    }
```

Haengerfreiheit ist per **Konstruktion** belegt und nicht per Kontrakt erbeten: der Worker kehrt nur bei leerer Queue zurueck und setzt `in_flight_` vor jeder naechsten Runde zurueck -- nach seinem Ende ist das Praedikat wahr, das `wait()` faellt sofort durch. **Damit traegt die Klasse ihre Zusage selbst, statt sie als Bitte an den Aufrufer zu formulieren.**

**Wache.** `ce/tests/unit/test_tp1_planer_filter_iterator.cpp:1360-1405`, Fall (11h2): deterministisches Fenster ueber Handshake-Reihenfolge (Push haengt an einem Flag, Schliesser aus eigenem Thread), plus Gegenprobe, dass `drain()` nach vollzogenem `close()` nicht haengt. Die Probe kann nie falsch rot werden -- die Neu-Zusage gilt in beiden Verschraenkungen.

**Restrisiko-Einordnung:** heute unerreichbar (ein Treiber-Thread, `close()` danach sequenziell). Mitgenommen wurde die Heilung trotzdem -- ausschlaggebend war die Doktrin: `if (closed_) return;` **ist** eine Klammer der verbotenen Begruendungsform.

**Naechste Handlung:** keine.

---

### H-6 `[ ] OFFEN` -- `PlanFach::offen`: erhoben, persistiert, verworfen

**Ort:** `ce/libs/cache_engine/builder/bestandslog/batch_planner.hpp:163` (Feld), `:217-233` (`plan_resume_faecher`), `:246` (einziger Leser). Handlung gefuehrt als **F-4**.

**Beleg, heute am Objekt nachgezaehlt:**

- `batch_planner.hpp:163`: `std::uint64_t offen = 0; ///< davon beim Planen fehlend (Momentaufnahme, kein Anspruch)`.
- Das Wort `offen` kommt im Rumpf von `plan_resume_faecher` (Zeilen 217-233) **0 Mal** vor -- die Schleife liest ausschliesslich `f.count`.
- `/usr/bin/grep -rn "\.offen" libs apps` (ohne `offene_fremde`) liefert **genau einen** Treffer: `batch_planner.hpp:246`, `render_batch_plan` schreibt die Zahl ins Dokument.

Die Zahl wird je Fenster ueber **dieselbe** `PresenceFn` erhoben wie der Bau-Filter, ins Dokument geschrieben -- und fuer die **einzige Entscheidung, die sie treffen koennte, verworfen**.

**Gemessene Wirkung (Ledger, Befund (b)):** `plan_resume_faecher(f={{0,4,offen=4},{4,4,0}}, 8) = 2 von 2` -- ein fuehrendes Fach, dessen Binaries der **frische** Scan gerade als abwesend gemeldet hat, wird uebersprungen.

**Die Selbstwiderlegung im Kommentar.** Ueber `plan_resume_faecher` steht die Begruendung, warum **teilweise** gedeckte Faecher stehen bleiben: "eine uebersprungene, aber nie gebaute Binary waere ein Loch in der Matrix". **Genau diesen Schaden erlaubt die Funktion in der staerkeren Form** -- fuer ein **vollstaendig** vom Zaehler gedecktes Fach, dessen Binaries nachweislich fehlen. Zugleich ist es das Gegenteil des Owner-Modells (der Inventar-Blick ist die Autoritaet, der Plan nur die Beschleunigung).

**Warum bewusst nicht gebaut.** Bei ungebundener `PresenceFn` setzt `filter_window_for_build` (`planer_driven_build.hpp:137-139`) `zu_bauen = window` -- alles gilt als fehlend. Eine naive `offen > 0`-Abschneidung schnitte das Praefix dann **immer** auf 0 und braeche zwei richtige Zusagen. Der saubere Weg ist ein `present_`-Gate; die Begruendung ist dieselbe wie bei der Formwache: *eine Wache, die auf fehlende Praesenz-Information reagiert, verwechselt "nicht gefragt" mit "nicht da".*

**Abgrenzung, die stehen bleiben muss:** H-4 und H-6 ersetzen einander **nicht**. `offen > 0` faengt "die Binary liegt gerade nicht", die Formwache faengt "fuer dieses Atom gibt es gar keine pruefbare Identitaet". Ein Atom ohne Fingerprint kann im Lager liegen und `offen == 0` haben -- dann greift **nur** die Formwache.

**Offener Owner-Entscheid (Autoritaets-Frage):** *der Plan-Zaehler ist eine HISTORISCHE Aussage, der Praesenz-Scan eine GEGENWAERTIGE -- wo beide vorliegen, muss die gegenwaertige gewinnen.*

**Naechste Handlung:** `present_`-Gate bauen, zusammen mit der Host-Belegung der Plan-Ablage. Im Ledger auf "nach der Abgabe" datiert -- **durch die Lage-Korrektur ab dem Liefer-Freitag 14.08. einplanbar**, nicht mehr vertagt. **T4**.

---

### H-7 `[~] TEILWEISE` -- Der Fassaden-Test, der den Defekt pinnte

`[x]` Kern erledigt - `[ ]` Mechanik-Beleg (R1) offen.

**Ort:** `ce/tests/unit/test_t2a_f4_facade_plan_durchreichung.cpp`.

**Was passierte.** Der Test belegt die Kette `RunProfileArgs::batch_plan_datei -> make_cfg -> LazyRunConfig::batch_plan_datei` -- eine echte Luecke, denn kein Host baut eine `LazyRunConfig` selbst. Er war gruen und pinnte "Plan und Zaehler liegen da".

**Er hielt nur, weil `COMDARE_BESTANDSLOG` nicht gesetzt war.** Ohne Opt-in gab es gar keinen Fingerprint-Provider, der Stempel trug `ohne-anker`, und die Ablage entstand trotzdem. **Der gruene Stand zementierte exakt die Ordnung, die H-4 als Defekt benennt** (Test-Kommentar `:196-219`).

**Klassenmerkmal:** ein gruener Test, dessen Zusage von einer **nicht gesetzten** Umgebungsvariablen abhaengt -- eine stillschweigend ausgenutzte Vorbedingung. Vgl. die stehende Fehlerklasse "gruene Tests zementieren alte Ordnung".

**Heilung -- nachgefuehrt statt geloescht** (`71b5586a`, `034e0068`):

- `::setenv("COMDARE_BESTANDSLOG", "true", 1)` steht jetzt **literal** im Test (`:188`), mit der Abhaengigkeit im Klartext darueber.
- Die zweite Haelfte derselben Vorbedingung ist als **eigene, benannte Zusage** eingezogen statt als stille Annahme: `check_true("(0) Vorbedingung: die Tier-Realversion ist erhebbar ...", tier_realversion_ist_bekannt())`.
- Die Zusagen (1) und (3) lauten jetzt anders: da die eine Binary dieses Profils nicht materialisierbar ist (`lazy_adhoc_source_gen.hpp:367`), bleibt die Ablage **fail-closed inert**. Der Durchreichungs-Beleg haengt nicht mehr daran, dass irgendeine Datei erscheint, sondern daran, dass die Ansage **den uebergebenen Pfad woertlich nennt** -- keine andere Stelle des Laufs kennt diese Zeichenkette. **Die Zusage ist damit erst scharf.**

**`[ ] OFFEN -- H-7-R1:** die **Mechanik** der Ablage (Plan + Zaehler + Praefix-Resume) ist im Fassaden-Pfad damit **nicht** belegt, sondern nur auf Iterator-Ebene (`test_tp1_planer_filter_iterator`, Faelle (11a)-(11c2), (11l-b)/(11l-f)). Ehrlich benannt im Test-Kopf, aber es bleibt eine **Deckungsluecke**: der produktive Weg zeigt die Mechanik nirgends.

**Naechste Handlung:** ein Fassaden-Profil mit materialisierbarer Binary (alle 17 Kompositions-Achsen in der Enabled-Tabelle), dann Zusage (3) wieder als **Wirkung** fahren. Einplanbar. **T3**.

---

## III.8 Woran man diese Klasse wiedererkennt -- die Pruefliste

Fuenf Merkmale, jedes aus einem Eintrag oben abgeleitet:

1. **Eine Heilung aendert eine EINHEIT, eine SEMANTIK oder eine ORDNUNG.** Dann ist die Verbraucherliste die Pflichtaufgabe, nicht die Kuer. Frage: *Wer rechnet mit dieser Zahl weiter, und rechnet er noch richtig?* (H-1)
2. **Eine Heilung sucht SPUREN statt den Vorgang zu verhindern.** Spurensuche ist genau so vollstaendig wie die Spuren. Frage: *Gibt es einen Fall, der erfolgreich und still verlaeuft?* (H-2)
3. **Eine Heilung baut eine Wache und trifft dabei den Grenzfall der leeren Menge.** Frage: *Was tut sie bei null Elementen -- und ist das Verhalten des Werkzeugs dort ueberhaupt definiert?* (H-3)
4. **Eine Heilung prueft EXISTENZ, wo die Frage DECKUNG lautet.** Sie heilt dann nur den **ersten Vertreter** der Klasse. Frage: *Prueft die Wache, dass etwas da ist, oder dass es taugt?* (H-4, H-6)
5. **Ein gruener Test haengt an einer nicht gesetzten Vorbedingung.** Er pinnt dann nicht die Zusage, sondern den Defekt. Frage: *Welche Umgebungsvariable, welche Datei, welcher Vorbau macht diesen Test gruen -- und was passiert, wenn sie da ist?* (H-7)

**Sechstes, uebergreifendes Merkmal, und es betrifft den Pruefer selbst:** eine Sonde, die den richtigen Aufbau nachstellt und trotzdem `[OK]` bucht, weil sie gegen die **falsche Zusage** misst (H-5). Gegen dieses Merkmal hilft nur, die Zusage **vor** dem Bau der Sonde aufzuschreiben.

**Bilanz des Kapitels:** sieben Faelle -- **vier erledigt** (H-1, H-2, H-3, H-5), **zwei teilweise** (H-4, H-7, je mit einem benannten R1), **einer offen** (H-6). Sechs der sieben wurden durch Gegenpruefung einer **fertigen** Heilung gefunden.

---

# KAPITEL IV -- ZWEI QUELLEN FUER DIESELBE WAHRHEIT

## IV.0 Die Klasse

Die beiden vorangegangenen Klassen beschreiben Dinge, die **kaputt** waren. Diese hier beschreibt etwas Schlimmeres: Dinge, die **richtig** waren -- an der **falschen Stelle**.

Ein Artefakt existiert zweimal (zwei Submodul-Zeiger, zwei Branches, zwei Register, zwei Dateien mit demselben Anspruch), gepflegt wird das eine, **gelesen wird das andere**. Kein Werkzeug schlaegt an, weil formal nichts fehlt und nichts falsch ist. Die CI bleibt gruen, der Test bleibt gruen, die PDF kompiliert. Nur der Inhalt ist ein anderer als der, den jemand hergestellt hat.

Fuer eine Lieferung ist das die teuerste Klasse, weil ihr Schaden **genau am Liefertag** sichtbar wird und nicht vorher: **man liefert das gebaute Artefakt, nicht das gepflegte.**

Mit der Lage-Korrektur bedeutet das: kein Posten unten ist ein Notfall, aber **jeder ist ein Freitags-Kandidat**, weil jeder woechentlich neu zuschlagen kann. Drei der acht sind zwischen Erhebung und Abfassung **erneut** aufgetreten oder **erneut** geheilt worden -- das ist die Signatur dieser Klasse.

---

### Z-1 `[~] TEILWEISE` -- Das Thesis-Repo ist zweimal eingebunden; gebaut wird eines

Divergenz zweimal geheilt, **Ursache steht**. Handlung als **D-1**.

**Ort.** `super/.gitmodules` -- zwei Eintraege, **dieselbe URL** (heute vollstaendig nachgelesen):

```
[submodule "thesis/diplomarbeit"]
	path = thesis/diplomarbeit
	url = ../20260931-overleaf-diplomarbeit.git
	branch = development
	update = merge
[submodule "Code/external/20260931-overleaf-diplomarbeit"]
	path = Code/external/20260931-overleaf-diplomarbeit
	url = ../20260931-overleaf-diplomarbeit.git
```

Der zweite Eintrag hat **weder** `branch` **noch** `update`.

**Beleg, am Objekt nachgezaehlt.** Die CI beruehrt ausschliesslich den ersten Pfad: `super/.gitlab-ci.yml:548` (`thesis:pdf:`), `:560` (`- cd thesis/diplomarbeit`), `:565` (Artefakt `thesis/diplomarbeit/*.pdf`), `:1102` (der Anhang-Rueckschrieb liest `git ls-tree HEAD thesis/diplomarbeit`). Gegenprobe: `/usr/bin/grep -c "Code/external/20260931" .gitlab-ci.yml` = **0**. **Der zweite Zeiger ist fuer die Pipeline unsichtbar.**

**Der Schaden.** Die Gate-8-Landung (Anhang A, 23 Graph-Abbildungen DE+EN) erreichte nur den **zweiten** Zeiger. Der gebaute Zeiger stand auf `29a1700d`, der gepflegte auf `8970465d` -- Distanz 1 Commit, `2 Dateien, +199/-2`. Geheilt durch `85b74237` und `72eab9ae`; die Commit-Botschaft sagt es selbst: *"fix(submodule): thesis/diplomarbeit auf 8970465d nachgezogen -- die CI baute die ALTE Fassung"*.

**Und dann wieder.** Zum Zeitpunkt der Kapitel-Erhebung standen die beiden Zeiger **schon wieder** auseinander -- diesmal in die andere Richtung (`thesis/diplomarbeit` = `8970465d`, `Code/external/...` = ` M 8e58f691`). Geheilt durch `46824fba`, Titel: *"fix(submodule): BEIDE Thesis-Zeiger auf 8e58f69 -- vier Abgabe-Verbesserungen nachgezogen"*.

**Live bei Abfassung -- sauber:**

```
 8e58f691... Code/external/20260931-overleaf-diplomarbeit
 8e58f691... thesis/diplomarbeit
```

**Zwei Divergenzen an einem Tag, zwei Heilungen an einem Tag. Die Heilung hat den Auseinanderlauf beseitigt, nicht seine Moeglichkeit.**

**Wie es unentdeckt bleiben konnte.** Es gibt **keine Wache**, die zwei Gitlinks auf dieselbe URL gegeneinander prueft. Beide Zustaende sind fuer git legal. Die Pipeline war gruen, die PDF baute (DE 202 / EN 192 Seiten) -- sie baute nur die **falsche**.

**Was es gekostet haette.** Die Liefer-PDF ohne Anhang A. Nicht "fehlerhaft", sondern **stumm unvollstaendig**: 23 Abbildungen weniger, ohne eine einzige LaTeX-Warnung.

**Klassenmerkmal.** Zwei Pfade, eine Quelle, und nur einer steht im Bau-Rezept.

**Naechste Handlung (D-1).** (1) Entscheiden, ob `Code/external/20260931-overleaf-diplomarbeit` ueberhaupt gebraucht wird. Wenn nein: entfernen (`git rm`, `.gitmodules`-Eintrag streichen) -- die **saubere** Loesung, weil sie die Ursache streicht statt sie zu bewachen. (2) Wenn ja (Owner-Entscheid): Wache in `verify:submodules`, die zwei Gitlinks derselben URL auf Gleichheit prueft und bei Ungleichheit **rot** faellt. **T3**.

---

### Z-2 `[ ] OFFEN` -- Der Trigger auf `branch: main`: eine Zeitbombe mit Zufallszuendung

**Der akute Fall ist bei Abfassung LIVE.** Handlung als **D-2** und **S-3**.

**Ort.** `super/.gitlab-ci.yml:255`, `:273`, `:291` -- drei `trigger:`-Bloecke (`trigger:cache-engine`, `trigger:prt-art`, `trigger:thesis`), alle drei mit `branch: main`, alle drei mit `strategy: depend` (heute nachgezaehlt: genau drei Treffer auf `branch: main`). Gearbeitet und gelandet wird auf `development` -- `.gitmodules` sagt fuer beide gepflegten Submodule `branch = development`.

**Beleg -- zwei Exitcodes, nicht zwei Meinungen.** Die Schluessel-Wache `ce/scripts/ci_yaml_key_guard.sh` lief gegen beide ce-YAML-Staende: gegen `ce origin/main c837d830` **EXIT=1** (`DOPPELT: 'contract:axis-version-lock'`), gegen `ce origin/development b5e0e4e7` **EXIT=0**. Der Satz, mit dem die Erhebung das zusammenfasst (`super/docs/plaene/20260806-PLAN-testoffensive-und-gruene-pipeline.md:50`, woertlich):

> "**Ein gruener Lauf von heute frueh war also ein gruener Lauf ueber Code, den niemand mehr faehrt.**"

Die Wache selbst benennt, warum das kein rotes Signal erzeugt (`ci_yaml_key_guard.sh:16-18`, woertlich):

> "GitLab meldet KEINEN Fehler. Der Lint bleibt gruen, die Pipeline bleibt gruen. Es sieht exakt so aus wie ein gesunder Zustand."

**Wirkungs-Beleg.** super-Lauf 15026 (Gitlink zeigte bereits auf `e7aa1244`) triggerte ce-Pipeline 15027 mit `ref=main`, `sha=c837d830` -- also den **vorherigen** Stand. Die als "hart gedeckt" deklarierte Landung prueft einen **anderen Commit** als den, den der super einbindet.

**Live nachgemessen bei Abfassung -- der Befund ist heute Abend in BEIDEN Repos akut:**

```
super origin/development  46824fba
super origin/main         5534c23c      (10 Commits zurueck)
super origin/main : thesis/diplomarbeit                 = 29a1700d   (VOR Gate 8)
super origin/main : Code/external/20260931-overleaf-... = 29a1700d
super origin/main : Code/external/comdare-cache-engine  = e7aa1244   (nicht 47c4ef1d, nicht f57801d3)

ce    origin/development  f57801d3
ce    origin/main         47c4ef1d      (2 Commits zurueck)
```

Ein Pipeline-Lauf auf `super/main` -- und `main` ist per Doktrin die **Autoritaets-Linie** -- baut heute Abend also **weiterhin die Gate-8-lose Thesis** und triggert ce auf einem alten Gitlink. Der Befund aus Z-1 ist auf `main` **nicht geheilt**, nur auf `development`. Und der ce-Arm, der heute frueh durch einen `main`-Nachzug harmlos wurde, ist durch die naechste Landung **wieder auseinandergelaufen** -- die Heilung war ein Nachzug, keine Abschaffung der Kopplung.

**Wie es unentdeckt bleiben konnte.** Die Kopplung ist an genau **drei YAML-Zeilen** geschrieben, wird aber nie geprueft: der Downstream-Lauf ist gruen, das Ergebnis wird als Deckung des Upstream-Stands gelesen. Solange `main` regelmaessig per FF nachgezogen wird, ist die Wirkung Null; sobald ein FF ausfaellt, prueft die Pipeline **stillschweigend etwas anderes**.

**Was es kostet.** Eine als "hart gedeckt" gemeldete Landung, deren Deckung ein anderer Code war. Bei einer Freitags-Lieferung: **eine PDF ohne Anhang A, ausgeliefert mit gruener Pipeline als Beleg.**

**Klassenmerkmal.** Ein **Ref-Name**, der im Bau-Rezept fest steht, waehrend der Arbeitsfluss einen anderen benutzt. Suchmuster: jede feste `branch:`-, `ref:`-, `--branch`-Angabe in CI-Dateien. Allgemeiner: **eine Deckung, die auf einem Zweignamen statt auf dem eingebundenen SHA beruht, ist nur so lange wahr, wie beide zufaellig gleich sind.**

**Naechste Handlung, Rangfolge:** (1) **sofort, mechanisch:** super `main` per FF auf `46824fba`, ce `main` per FF auf `f57801d3` -- siehe **S-2**/**S-3**. (2) **strukturell (Owner-Entscheid):** entweder `branch: $CI_COMMIT_REF_NAME` (Downstream faehrt denselben Zweig wie Upstream) -- der kleinste richtige Eingriff -- oder den Gitlink-SHA forwarden und die Kind-Pipeline per API auf **diesem SHA** starten (sauber, teurer). (3) **Prozess:** die `main`-FF-Pflicht gilt fuer **beide** Repos; heute wurde sie zweimal in einem Repo vollzogen und im anderen vergessen. **T1** fuer (a), **T4** fuer (b).

---

### Z-3 `[~] TEILWEISE` -- Der Submodul-Zeiger, der rueckwaerts zeigte

`[x]` Einzelfall geheilt (`85b74237`/`72eab9ae`) - `[ ]` Wache offen.

**Ort/Beleg.** `super/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:4293-4302` (Regel-Zeile 8 auf `:4285`). Im super-Status stand ein unscheinbares ` M Code/external/20260931-overleaf-diplomarbeit`. Gemessen: ausgecheckt `ef448e4b` (21.07., seit dem 26.07. elf Tage unbewegt), committeter Zeiger `29a1700d` (03.08.). `merge-base --is-ancestor` sagt: der **Checkout** ist Vorfahr des Zeigers, Distanz **78 Commits**. **Das `M` war kein Fortschritt, sondern ein Rueckstand.**

Ein `git add .` oder `git commit -a` haette den Zeiger auf den 21.07. **zurueckgedreht** -- lautlos, denn im Diff steht nur eine Zeile mit einem Hash. Verloren waeren gewesen: Kapitel 6 (Fazit/FF2), Kapitel 5 (Auswertung, Mess-Schema-Modi), Kapitel 3 (`sec:stamp-model`) -- Abgabe-Substanz.

Der Ledger vermerkt die Ursache der Entwarnung praezise: *"Dass nichts passiert ist, liegt allein daran, dass jeder Commit dieser Strecke einen expliziten Pathspec trug."*

**Regel-Zeile 8 verbatim:** siehe **R-8**.

**Klassenmerkmal.** Jedes ` M` oder `+` auf einem Gitlink. Die Richtung ist **je Submodul** zu messen, nie fortzuschreiben -- im selben Status zeigte der ce-Zeiger korrekt vorwaerts.

**Live bei Abfassung:** `+f57801d3` fuer `Code/external/comdare-cache-engine`. Richtung **gemessen**, nicht angenommen: `merge-base --is-ancestor 47c4ef1d f57801d3` = wahr, Distanz **2** -- also **vorwaerts**. Harmlos, aber **uncommittet** (S-1).

**Naechste Handlung.** Die Regel ist gebucht, aber **nicht durchgesetzt**. Ein `pre-commit`-Hook (oder ein Schritt in `verify:submodules`), der fuer jeden veraenderten Gitlink die Richtung misst und bei Rueckwaerts-Bewegung abbricht, ist der billigste Dauer-Schutz. **T3**, gemeinsam mit D-1.

---

### Z-4 `[x] ERLEDIGT` -- Gate 8 als rescue-Ref: gesichert, CI-geprueft, in keinem Zweig

**Beleg (Ledger `:4304-4316`).** `rescue/gate8-graph-abbildungen-8970465d` lag auf **beiden** Remotes (`refs/remotes/origin/...` und `refs/remotes/github/...`, beide `8970465d`) und war **in keinem Zweig**. Der Commit aendert **2 Dateien, +199/-2** (`anhang/de/A_measurements.tex`, `anhang/en/A_measurements.tex`, "die 23 Abbildungen des Graph-Umbaus eingebunden") -- das ist der TEXT-Teil genau des Graph-Pakets, dessen CODE-Teil (`b35aea1b`) bereits gelandet war.

Verschaerfend `[BERICHT]`: die Ref hatte einen **eigenen gruenen CI-Lauf** (`thesis 14964`, 12:39, `success`). Der Ledger zieht daraus: *"Nicht einmal 'gruen getestet' impliziert 'gelandet'."*

**Regel-Zeile 9 verbatim:** siehe **R-9**.

**Geheilt, live geprueft:** `8970465d` ist heute auf `origin/main` **und** `origin/development` des Thesis-Repos.

**Der Neufall der Kapitel-Erhebung -- inzwischen ebenfalls geheilt.** Zum Erhebungszeitpunkt stand der Arbeitsbaum `Code/external/20260931-overleaf-diplomarbeit` auf Branch `b-thesis-ehrlichkeit-anhang` mit HEAD `8e58f691` ("die vier Gruppen-Ersatztexte benennen jetzt, WAS fehlt (DE+EN)"), vier Commits ueber `8970465d`, und `git for-each-ref --contains 8e58f691` lieferte **genau eine** Ref: `refs/heads/b-thesis-ehrlichkeit-anhang`, auf **keinem** Remote. Das war die naechste Stufe derselben Klasse -- Gate 8 war wenigstens doppelt gesichert, diese vier Commits **gar nicht**.

**Live bei Abfassung, per `ls-remote` (nicht aus dem lokalen Cache -- s. N-4):**

```
$ git ls-remote origin refs/heads/development refs/heads/main
8e58f691...  refs/heads/development
8e58f691...  refs/heads/main
$ git ls-remote github refs/heads/development refs/heads/main
8e58f691...  refs/heads/development
8e58f691...  refs/heads/main
```

**Gelandet auf beiden Zweigen beider Remotes.** Der Neufall ist geschlossen; der super-Gitlink ist mit `46824fba` nachgezogen.

**Klassenmerkmal.** Jedes Signal, das "fertig" bedeutet, ohne "erreichbar von einem Zweig" zu bedeuten -- gepusht, gesichert, gruen, reviewed.

**Naechste Handlung:** keine fuer den Fall. Die **Routine** (alle rescue-Refs gegen `development`/`main` pruefen) bleibt offen und laeuft unter R-9. **T3**.

---

### Z-5 `[~] TEILWEISE` -- Plandokumente unversioniert; die Klasse ist am selben Tag dreimal zurueckgekehrt

**Beleg, am Objekt korrigiert.** Die Session meldete "4090 Zeilen"; das ist die **erste** Rettung, nicht die Gesamtsumme:

- `b300c1e6` ("sechs Plan-/Analysedokumente des 06.08. versioniert"): 6 Dateien, **+4090** Zeilen (u. a. `20260806-PLAN-wellenplan-vollbild-und-parallelisierung.md` 1226 Zeilen, `...-versionierungs-interface-stempel.md` 815).
- `c911c2fb` ("zwei weitere Analysedokumente"): 2 Dateien, **+1541** Zeilen.
- **Summe der acht: 5631 Zeilen.** Die Zahl 4090 ist nicht falsch, aber sie unterschaetzt die Exposition um **27 Prozent**.

**Live gemessen bei Abfassung (`git status --porcelain`, super HEAD `46824fba`):**

```
?? Code/measure_out_d03/
?? docs/plaene/20260806-PLAN-katalogposten-p2p8-und-trigger-reste.md   729 Zeilen
?? docs/plaene/20260806-PLAN-kostenklammer-restposten.md               599 Zeilen
?? docs/plaene/20260806-PLAN-thesis-posten-und-testoffensive.md        714 Zeilen
                                                          Summe:      2042 Zeilen
```

**2042 Zeilen Planungsarbeit stehen in diesem Moment ungesichert im Arbeitsbaum** -- 729 mehr als bei der Kapitel-Erhebung (dort waren es zwei Dateien, 1313 Zeilen). Ein `git clean -fdx` -- der Standardgriff nach einem verkorksten Bau -- vernichtet sie **rueckstandsfrei**.

Zwei dieser drei Dateien werden in **diesem Dossier zitiert** (SW-6 zitiert `20260806-PLAN-kostenklammer-restposten.md:314-322`, Z-2 zitiert `...-testoffensive-und-gruene-pipeline.md:50`). **Ein Dossier, dessen Belege auf untracked Dateien zeigen, ist so haltbar wie der naechste `clean`.**

**Wie es unentdeckt bleiben konnte.** Untracked-Dateien erzeugen **kein Signal**: kein Diff, keine Warnung, kein Lint. Sie fallen nur auf, wenn jemand `git status` liest **und** die Zeilen `??` ernst nimmt.

**Klassenmerkmal.** Jede Analyse-/Planarbeit, die als Datei im Repo-Baum abgelegt, aber nicht im selben Zug committet wird.

**Naechste Handlung.** (a) **Sofort** die drei Dateien versionieren -- siehe **S-4**. (b) Dauerhaft: keine Planarbeit ohne Commit im selben Arbeitsschritt; die Regel gehoert an dieselbe Stelle wie die Backup-SOFORT-Doktrin. **T1**.

---

### Z-6 `[~] TEILWEISE` -- Der LB-Paketschnitt: die Arbeit war gebaut, die Buchfuehrung fehlte

Ledger nachgetragen, **14-Tage-Register weiterhin leer**. Handlung als **B-1**.

**Beleg (Ledger `:4425-4447`, Nachtrag `9f5ff1d2` vom 06.08.).** Der F9/LB-Paketschnitt LB-0..LB-6 (Owner-Entscheid 01.08., LB-6 mit **Vor-Trigger-Rang**) stand ausschliesslich in einem Session-Dokument: `super/docs/sessions/20260801-KONSOLIDIERT-gesamtarchitektur-lager-batch-eta-sha512.md:76` (LB-6) und `20260801-FAHRPLAN-vollbau4-beweise-g6-trigger.md:200-201` (OE-B, Owner-verbatim).

**Live nachgezaehlt (`/usr/bin/grep -c`, absolute Pfade):**

| Muster | Ledger (5840 Zeilen) | Register 06.08. (474 Zeilen) |
|---|---:|---:|
| `LB-[0-9]` | **8** | **0** |
| `OE-B` | **3** | **0** |

Die 8 Ledger-Treffer sind **nicht** die Buchung des Paketschnitts, sondern die Buchung seines **Fehlens** -- Gegenprobe gegen `9f5ff1d2^` liefert fuer beide Muster **0**. Vor dem Nachmittag des 06.08. existierte die Kette **in keinem Register**.

**Verschaerfend, und der Ledger sagt es selbst.** Der Fall liegt **innerhalb** des 14-Tage-Fensters (01.08. > 23.07.), dessen Zusage lautete, es trage alles Aktive. Die Ursache ist praeziser als "verloren": das Register nennt seine Quellen selbst -- Ledger 23.-31.07., Ledger 01.-06.08., Dossier/Doku-Register, Live-Lesung des Fahrplans. **`docs/sessions/*` ist in dieser Aufzaehlung nicht enthalten.** Gefehlt hat nicht das **Fenster**, sondern die **Quellenklasse**.

**Regel-Zeile 10 verbatim:** siehe **R-10**.

**Was es gekostet hat (nicht: haette).** Die Owner-Frage *"wurde nicht gelesen??"* konnte niemand beantworten -- nicht weil die Arbeit fehlte, sondern weil sie **nirgends verbucht** war.

**Entwarnung mit Praezisierung (E-g), heute nachgemessen:** gebaut sind alle Kopf-Bausteine in `ce/libs/cache_engine/builder/bestandslog/` -- `lager_pfad_grammatik.hpp` (LB-0), `knoten_heuristik_log.hpp` (LB-1), `lager_baum_writer.hpp` (LB-2/LB-3). **Bewiesen** ist es nur bis LB-1: `tests/unit/` enthaelt genau zwei LB-Tests (`test_lb0_lager_pfad_grammatik.cpp`, `test_lb1_knoten_heuristik_log.cpp`) mit **34** bzw. **26** `^TEST`-Makros (`/usr/bin/grep -c`); ein `test_lb2` oder `test_lb3` existiert **nicht**. Registrierung heute an `tests/unit/CMakeLists.txt:5003` und `:5019` -- die dritte gemessene Zeilenposition dieses Belegs an einem Tag (N-2).

**Naechste Handlung.** (a) LB-0..LB-6 in das 14-Tage-Register eintragen -- 0 Treffer sind noch immer 0. (b) Die Methodik jeder kuenftigen Konsolidierung muss ihre **Quellenklassen auflisten**, damit Schweigen nicht als Abwesenheit gelesen wird. (c) LB-6 Stufe 1 bauen (klein, golden-neutral). **T1**.

---

### Z-7 `[x] ERLEDIGT` -- Der Bau-Graph: eine fehlende Kante, vier korrekte Nachbarn

**Zwischen Erhebung und Abfassung geheilt.** Seit dem 02.08. woertlich im Ledger; die Heilung kam am Abend des 06.08.

**Ort.** `ce/tests/unit/CMakeLists.txt`, Registrierung `comdare_add_test(test_experiment_plan_director ...)`. Die Registrierung rief `comdare_attach_generated_catalog` **nicht**.

**Beleg -- die Kette, jede Stufe am Objekt.**

1. `cmake/catalog_codegen.cmake:36-46` erzeugt `${PROJECT_BINARY_DIR}/generated/generated_source_catalog.hpp` ueber das Ziel `comdare_limits_generated_source_catalog`.
2. `cmake/catalog_codegen.cmake:48-60`: `comdare_attach_generated_catalog(target)` = `add_dependencies(...)` **plus** die beiden Include-Pfade. Das ist die **einzige** Stelle, die die Reihenfolge herstellt.
3. `libs/cache_engine/profile_facade/profile_run_entry.hpp:29` inkludiert `"generated_source_catalog.hpp"`.
4. `libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:42` sagt es selbst, woertlich: *"Katalog-/Umbrella-schwer (zieht ueber profile_run_entry.hpp den generierten Basis-Katalog + sota_catalog)"*; `:46` inkludiert `profile_run_entry.hpp`.
5. `tests/unit/thesis_tiere/test_experiment_plan_director.cpp:23` inkludiert `planner/experiment_plan_director.hpp`.

Der Test haengt also am generierten Header -- **ohne jede Kante darauf**. Vier andere Konsumenten setzten sie korrekt (`test_t2a_f4_facade_plan_durchreichung`, `test_limits_entkopplung_vorstufe`, `test_lazy_adhoc_source_gen`, `test_w2_combo_ct_stamp`), dazu `libs/cache_engine/profile_facade/CMakeLists.txt:120`.

**Warum es ein Rennen ist und kein lauter Bruch.** Der Include-**Pfad** erreicht den Baum unabhaengig von der Kante: `libs/cache_engine/profile_facade/CMakeLists.txt:100-110` haengt `${PROJECT_BINARY_DIR}/generated` **PUBLIC** an drei Ziele. Der Header ist damit **auffindbar, aber nicht geordnet**. Existiert die Datei aus einem frueheren Lauf, kompiliert alles; existiert sie noch nicht, entscheidet die Scheduler-Reihenfolge.

**Ledger-Buchung vom 02.08. abends (`:3641`, woertlich):**

> "der erste 'ninja all' bricht an generated_source_catalog.hpp (fehlende Order-Dependency von test_experiment_plan_director auf comdare_limits_generated_source_catalog)"

**Was daraus wurde -- und das war der eigentliche Befund.** Statt der Kante wurde ein **Verfahren** gebucht: *"Pflicht-Reihenfolge fuer hartes Gruen: configure -> target comdare_limits_generated_source_catalog -> ninja all -> configure (2. Pass) -> ninja all -> die 3 EXCLUDE_FROM_ALL-Ziele -> ctest."* Dieselbe Handanweisung stand in mindestens vier weiteren Dokumenten (`20260801-FAHRPLAN...:37` "J-3"; `20260726-AUFTRAG-lane-a-...:236`; `20260803-DOSSIER-e24-fenster-bauplan.md:208`; `20260803-DOSSIER-w10-...:392`). **Ein Ein-Zeilen-Fix wurde vier Tage lang als mehrstufiges Ritual dokumentiert.** Das ist die zweite Quelle: **die richtige Reihenfolge lebte in der Doku statt im Graphen.**

**Was es kostete.** Jeder frische Bau-Baum -- also jeder CI-Runner mit kaltem Cache, jeder neue Klon, jeder Wechsel des Build-Verzeichnisses -- schlug fehl. Nicht reproduzierbar, deshalb nicht als Fehler, sondern als "Infrastruktur-Zicke" wahrgenommen. `[BERICHT]`: kalt 3/3 Fehlschlaege (100 %), warm 20/20 gruen.

**Vorgeschichte, die die Klasse als Wiederholungstaeter ausweist.** Ledger `:1124` (Juli): *"#257 [K1][P0] CI-Gruen-Fix-Paket: ... add_dependencies-Codegen-Fix contract:conformance (Muster 14eed391)"* -- **exakt dieselbe Klasse, an anderer Stelle, damals behoben.**

**Heilung, live verifiziert.** ce `678a4487` -- *"fix(build-graph): fehlende comdare_attach_generated_catalog-Kante fuer test_experiment_plan_director"* --, gemergt als `f57801d3` (*"Merge b-buildgraph-kanten: die fehlende Codegen-Ordnungskante"*), heute auf `ce origin/development`. Am Objekt nachgelesen:

```
tests/unit/CMakeLists.txt:3468:comdare_attach_generated_catalog(test_experiment_plan_director)
```

Die Datei traegt jetzt **7** `comdare_attach_generated_catalog`-Aufrufe (vorher 6).

**Klassenmerkmal.** Ein Ziel, das einen generierten Header inkludiert, aber **nicht auf sein Codegen-Ziel zeigt**. Allgemeiner: **eine Reihenfolge, die in der Doku steht statt im Graphen.** Gegenprobe: fuer jeden generierten Header alle Konsumenten auflisten und mit der Menge der `attach`-Aufrufe schneiden.

**Restposten (nicht Teil dieses Befunds, aber seine Folge):** (a) die Gegenprobe fuer **alle** Konsumenten von `generated_source_catalog.hpp` und der Achsen-Codegen-Header steht aus; (b) die dokumentierte Pflicht-Reihenfolge muss um den jetzt **obsoleten** Schritt J-3 gekuerzt werden -- **sonst bleibt die zweite Quelle bestehen, obwohl die erste geheilt ist.** (c) Der super-Gitlink auf `f57801d3` ist **nicht committet** (S-1). **T2** fuer (a)/(b).

---

### Z-8 `[ ] OFFEN` -- Anhang A: 29 Eintraege, 0 Dateien, 17 davon voellig stumm

**Der reinste Fall der Klasse.** Handlung als **C-1**.

**Ort.** `thesis/anhang/de/A_measurements.tex` und `anhang/en/A_measurements.tex`, spiegelbildlich.

**Live gemessen am heutigen Submodul-Stand `8e58f691` (`/usr/bin/grep -c`):**

| Groesse | DE | EN |
|---|---:|---:|
| `\InputIfFileExists`-Eintraege | **29** | **29** |
| davon mit leerem Else-Zweig (`{}{}`) -- absolut stumm | **17** | **17** |
| davon mit Ersatztext | **12** | **12** |
| davon existierende Zieldateien | **0** | **0** |

**Korrektur gegen die Session:** dort standen 28 / 17 / 11 -- gemessen am aelteren Stand `8970465d`. Der Commit `8e58f691` ("die vier Gruppen-Ersatztexte benennen jetzt, WAS fehlt") hat **einen Eintrag mit Ersatztext hinzugefuegt und den Text der vorhandenen praezisiert -- er hat keinen einzigen der 17 stummen aufgehoben.** Die Zahl der stummen Eintraege ist **unveraendert 17 je Sprache**.

Vorhanden sind im Verzeichnis `anhang/de/tabellen/` 18 Dateien, aber es sind die **2D**-Varianten (`lc_surface_ns_per_op.tex`); die eingebundenen **3D**-Varianten (`lc_surface3d_...`) entstehen erst aus einem Messlauf ueber den Anhang-Vorwaerts-Kanal.

**Warum das genau diese Klasse ist.** `\InputIfFileExists` ist ein bewusster Kompromiss -- der Dateikopf sagt es selbst (`:71`): *"kompiliert auch VOR dem ersten Messlauf sauber."* Der Preis ist, dass die `.tex`-Quelle **behauptet**, eine Abbildung stehe dort, und das Dateisystem **widerspricht** -- ohne dass jemand den Widerspruch hoert. Die PDF baut gruen mit DE 202 / EN 192 Seiten, `.blg`-Gate 0, LaTeX-Warnings 0.

Die Botschaft des Gate-8-Commits benennt die **Spiegelseite** desselben Problems woertlich: *"ohne \InputIfFileExists-Eintrag fehlt die Abbildung TROTZ vorhandener .tex (DE+EN)"* -- **beide Richtungen sind still.**

**Umgekehrte Falle, ein Fall:** `axis_inventory.tex` wird erzeugt (`super/Code/08_appendix_generator/appendix_generator.cpp:423`), ist aber im gesamten Thesis-Baum **0-mal** referenziert.

**Was es kostet.** Bei einer Freitags-Lieferung: bis zu **29 fehlende Abbildungen** in einem Anhang, der sie namentlich ankuendigt; **17 davon ohne jeden Hinweis im Text**.

**Klassenmerkmal.** Ein **Fallback, der Abwesenheit in Stille uebersetzt**. Prueffrage: *erzeugt der Nicht-Vorhanden-Fall irgendein Zeichen -- im PDF, im Log, im Exitcode?*

**Naechste Handlung (C-1).** (a) Die 17 stummen Eintraege auf einen sichtbaren Ersatztext heben, im Stil der 12 vorhandenen. (b) Ein **Zaehl-Gate** im `thesis:pdf`-Job: Zahl der `\InputIfFileExists`-Eintraege gegen Zahl der existierenden Ziele, Differenz als Log-Zeile mit Schwellwert. (c) `axis_inventory` einbinden oder abschalten. (d) Owner-Entscheid ueber die Anhang-A-Reichweite vor dem ersten Voll-Messlauf (C-3). **T3**.

---

## IV.9 Wiedererkennungs-Merkmale der Klasse -- die Kurzliste

1. **Zwei Pfade auf dieselbe Quelle** -- und nur einer steht im Bau-Rezept. (Z-1)
2. **Ein fest verdrahteter Ref-Name** in einer CI-Datei, waehrend die Arbeit anderswo landet. (Z-2)
3. **Ein `M`, ein `+`, ein `??` oder eine `rescue/`-Ref**, das/die als Fortschritt gelesen wird, ohne die Richtung bzw. die Zweig-Zugehoerigkeit zu **messen**. (Z-3, Z-4, Z-5)
4. **Ein Register, das seine Quellenklassen nicht auflistet** -- sein Schweigen wird als Abwesenheit gelesen. (Z-6)
5. **Eine Reihenfolge, die in der Doku steht statt im Graphen.** (Z-7)
6. **Ein Fallback, der Abwesenheit in Stille uebersetzt.** (Z-8)

**Der gemeinsame Nenner aller sechs:** **Gruen ist keine Aussage ueber den Pruefbereich.** Jede Wache dieses Projekts beantwortet die Frage *"war das, was lief, in Ordnung?"* -- **keine** beantwortet *"lief das, was gemeint war?"*.

**Bilanz des Kapitels:** acht Faelle -- **zwei erledigt** (Z-4, Z-7), **vier teilweise** (Z-1, Z-3, Z-5, Z-6), **zwei offen** (Z-2, Z-8). Drei Faelle sind zwischen Erhebung und Abfassung erneut aufgetreten (Z-1, Z-2, Z-5) -- bei zwei davon war die Heilung ein **Nachzug**, keine Abschaffung der Ursache. Das ist die praktische Definition von `[~] TEILWEISE`.

---

# KAPITEL V -- DAS CHECKHEFT: was noch abzuarbeiten ist

## V.0 Sofort-Block: die Lage bei Abfassung

Vier Posten, die **beim Schreiben dieses Dossiers** live gemessen wurden. Sie sind keine neuen Erkenntnisse, sondern die aktuellen Auspraegungen bereits benannter Klassen -- und genau deshalb stehen sie vorn: **sie zeigen, dass die Klassen aktiv sind.**

### S-1 `[ ] OFFEN` -- Der super-Gitlink auf `f57801d3` ist nicht committet

**Beleg:** `git submodule status` liefert `+f57801d3e77d9a9d75dd84078d4d200e9ffcdfd8 Code/external/comdare-cache-engine`. Committeter Zeiger: `47c4ef1d`. Richtung **gemessen** (nicht angenommen, R-8): `merge-base --is-ancestor 47c4ef1d f57801d3` = wahr, Distanz **2** -- also vorwaerts, harmlos.

**Was drinsteckt:** die Heilung von **Z-7** (`678a4487`, die fehlende Codegen-Ordnungskante). Solange der Bump nicht committet ist, baut jeder super-Lauf **ohne** diese Kante.

**Naechste Handlung:** Gitlink-Bump committen und pushen. **Sofort.**

### S-2 `[ ] OFFEN` -- ce `origin/main` liegt wieder hinter `origin/development`

**Beleg (live `ls-remote`):** `origin/development` = `f57801d3`, `origin/main` = `47c4ef1d`, Distanz **2 Commits**.

**Warum das zaehlt:** die super-Bridge triggert ce fest auf `branch: main` (Z-2). Ein super-Lauf prueft heute Abend den ce-Stand **ohne** die Z-7-Heilung -- unabhaengig davon, welchen Gitlink der super einbindet.

**Naechste Handlung:** ce `main` per FF auf `f57801d3`. **Sofort.**

### S-3 `[ ] OFFEN` -- super `origin/main` liegt 10 Commits zurueck und baut die Gate-8-lose Thesis

**Beleg (live):** `origin/development` = `46824fba`, `origin/main` = `5534c23c`, Distanz **10**. Die Gitlinks auf `main`: `thesis/diplomarbeit` = `29a1700d` (**vor Gate 8**), `Code/external/20260931-overleaf-...` = `29a1700d`, `Code/external/comdare-cache-engine` = `e7aa1244`.

**Was es kostet:** ein Lauf auf der Autoritaets-Linie baut die **Thesis ohne Anhang-A-Abbildungen** und triggert ce auf einem drei Landungen alten Gitlink -- mit gruener Pipeline als Beleg. Siehe Z-1 und Z-2.

**Naechste Handlung:** super `main` per FF auf `46824fba`. **Sofort.** Die `main`-FF-Pflicht gilt fuer **beide** Repos -- heute wurde sie zweimal in einem vollzogen und im anderen vergessen.

### S-4 `[ ] OFFEN` -- 2042 Zeilen Planungsarbeit unversioniert

**Beleg (live, `git status --porcelain`):** drei untracked Plandokumente (`...katalogposten-p2p8-und-trigger-reste.md` 729, `...kostenklammer-restposten.md` 599, `...thesis-posten-und-testoffensive.md` 714) plus `Code/measure_out_d03/`.

**Verschaerfung:** zwei davon werden in **diesem Dossier als Beleg zitiert** (SW-6, Z-2).

**Naechste Handlung:** versionieren. **Sofort.** Siehe Z-5.

---

## V.A MESS-KETTE (Owner-KERNe vom 06.08. abends)

### A-1 `[ ] OFFEN` -- PMC gehoert ueber die Mess-Achse in die CEB und ins Pruefdock, nicht ueber ein Compile-Flag

**Ort:** `ce/libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:841, 877, 1194, 1342` - `ce/CMakeLists.txt:67, 69-77`. Fall-Analyse: **SW-3**.

**Beleg (heute nachgezaehlt):** alle vier `cmake -B build`-Emissionen des Planers tragen `-DCOMDARE_V32_ENABLE=ON` plus Build-Typ; `COMDARE_ENABLE_PMC` kommt in der Datei **0-mal** vor. `CMakeLists.txt:67` setzt die Option auf `OFF`; ihre Beschreibung nennt ausschliesslich Windows/Intel-PCM, sie gated aber ab `:69` auch den Linux-Pfad und definiert das Makro bei `:77` **global**. **Die 131.072er-Matrix wuerde ohne Hardware-Zaehler messen.**

**Wie es unentdeckt bleiben konnte:** die PMC-Pflicht war am 16.07. an **zwei Job-Namen** geheftet ("in GENAU die 2 Mess-Jobs"), nicht an eine Invariante. Beim Wechsel auf die dynamisch emittierte Kette blieb sie auf den abgeloesten Jobs zurueck. Dieselbe Klasse wie SW-2.

**Kosten:** eine mehrtaegige Voll-Messung mit durchgaengig 0-Zaehlern -- und damit ein Anhang, dessen Hardware-Spalten nichts aussagen.

**Klassenmerkmal:** eine Pflicht, die an **Namen** statt an **Eigenschaften** haengt, ueberlebt keinen Umbau des Erzeugungswegs.

**Naechste Handlung.** Owner-KERN 06.08., verbatim: *"PMC MUSS eingebaut und gemessen werden und zwar in die CEB fuer deren Pruefdock ... NIE abkuerzen, immer mit deep research fixen."* Also **nicht** eine Flag-Zeile in der Emission, sondern: die **Mess-Achse gibt frei**, was messbar ist; die **CEB kompiliert es ein** nach Planer-Freigabe; das **Pruefdock testiert** es. Deep-Research-Workflow. **T1 -- blockiert den Messbeginn.**

### A-2 `[ ] OFFEN` -- L2/L3/Kohaerenz nachruesten

**Beleg `[BERICHT]`:** live gegenuebergestellt -- ohne Flag `available=0`, alle Zaehler 0; mit Flag `available=1`, `cache_misses_l1=4191307`, `dtlb_misses=1767452`. **Nur L1D und dTLB liefern real**; L2/L3/Kohaerenz/Energie bleiben wegen I-PMC-2/3 (Zen-5-RAW-Events) auf 0.

**Naechste Handlung.** Owner-KERN, verbatim: *"gehoert in die Messachse und wird durch die CEB einkompiliert nach Planer Freigabe ... direkt nachruesten nach Plan. **PFLICHT und KERN der ANLAGE.**"* Die fruehere Empfehlung zur Zurueckhaltung ist damit ausdruecklich **verworfen**.

**Abhaengigkeit:** haengt an A-1 (gleicher Weg). **T2.**

### A-3 `[ ] OFFEN` -- `allow_failure` am Mess-Batch deckt mehr als Mess-Zell-Fehler

**Ort:** `experiment_plan_director.hpp:1333` (heute nachgemessen: genau ein Treffer), Wirkbereich `:1342-1344` (CMake-Configure + Build), `:1349-1350` (fehlender Driver), `:1352-1364` (PMC-Preflight).

**Beleg:** der Schalter steht am **Job**, der Kommentar darueber (`:1332`) begruendet ihn mit der **Zell**-Doktrin ("Mess-Fehler => CSV 'failed' + Log"). Gegenprobe, die es entscheidet: die ce-eigenen `pmc:amd`/`pmc:intel` (`ce/.gitlab-ci.yml:147`, `:153`, Template `.pmc` ab `:113`, Flag bei `:119`) halten die Doktrin 66-N2 ("BEIDE hart, kein Gate/allow_failure") **korrekt** ein. **Die Doktrin ist dort erfuellt, wo sie nichts kostet, und am Mess-Batch verletzt, wo sie zaehlt.**

**Zweiter Defekt am selben Ort:** der eigens gebaute #37-Preflight nennt in seinem Kommentar woertlich die Gefahr *"mehrtaegige Messung mit kaputtem perf_event_open ... lauter 0-Zaehler"* -- und beisst nicht: `pmc_seam_ok = delta.available || counters_all_zero` (`m3v2_pmc_smoke.cpp:71`), Nicht-Existenz der Quelle gilt als ehrlicher Skip mit **Exit 0** (`linux_perf_pmc_smoke.cpp:61`).

**Naechste Handlung:** `allow_failure` entfernen oder auf die Zell-Ebene zurueckfuehren; Preflight auf `pmc_available=1` verengen -- **der Inversionsfix vom 13.07. darf NICHT zurueckgenommen werden**, stattdessen ein zweiter Modus. Beide **zusammen** landen: A-1 allein liesse die Wache blind, der Preflight allein blockierte den Lauf. **T1.**

### A-4 `[ ] OFFEN` -- Fortpflanzung: Mess-Achsen-Aenderung => CEB + alle Binaries neu

**Beleg heute:** das Flag `COMDARE_ENABLE_PMC` geht in **keinen** Stempel, keine `binary_id`, keinen Fingerprint ein (Co-Occurrence-Suche: 0 Treffer); es waehlt nur die host-seitige Messquelle. Neubau daher ~77 s je Lane fuer den Treiber-Graphen, **nicht** die Matrix (Tier-`.so` entstehen ueber einen eigenen g++-Aufruf).

**Konsequenz:** **diese guenstige Bilanz gilt nur, solange PMC ein Compile-Flag ist.** Sobald es ueber die Mess-Achse kommt (A-1), wird es Teil der Bau-Identitaet -- und der Owner-KERN greift: Mess-Achsen-Aenderung erzwingt CEB-Neubau **und alle Binaries neu**, 3-phasig bzw. 2-phasig.

**Naechste Handlung:** die Fortpflanzungs-Regel im Planer explizit machen, **bevor** A-1 landet; sonst misst man mit halb erneuerten Binaries. **T1** (gemeinsam mit A-1).

### A-5 `[ ] OFFEN` -- ObservableTier-Vertrag: Orchestrierung laut Owner falsch implementiert

**Ort:** `ce/libs/cache_engine/anatomy/abi_adapter.hpp:393` - `ce/CMakeLists.txt:135, 141` - Vertrag: `ce/libs/cache_engine/anatomy/observable_tier.hpp` - Testate: `ce/libs/cache_engine/builder/pruef_dock/mess_interface_testate.hpp` (beide am Objekt vorhanden).

**Beleg am Objekt (heute nachgelesen):** `abi_adapter.hpp:393` lautet `#if COMDARE_MEASUREMENT_ON` und entscheidet, ob der ABI-Adapter `IObservableTier`, `IMeasurableWorkload`, `-V2` und `-V3` ueberhaupt erbt. Das Makro kommt aus `CMakeLists.txt:135` (`option(COMDARE_MEASUREMENT_MODE ... ON)`) ueber `:141 add_compile_definitions(COMDARE_MEASUREMENT_ON=1)`.

**Was gemessen werden kann, entscheidet heute eine CMake-Option, nicht die Mess-Achse.** Genau das ist der beanstandete Punkt; er ist **dieselbe Wurzel wie A-1, eine Ebene tiefer**.

**Owner-Entscheid:** der Vertrag ist **KERN-Achse des Planers und wird nicht gestrichen** -- zu korrigieren ist die **Orchestrierung**, nicht das Interface.

**Naechste Handlung:** Deep Research auf den Pfad Mess-Achse -> Planer-Freigabe -> CEB-Einkompilierung -> Pruefdock-Testat; `mess_interface_testate.hpp` (W3-KERN 05.08., Owner-GO R3) ist der bereits gebaute Landeplatz. **T2.**

### A-6 `[ ] OFFEN` -- XML muss Bau und Messung getrennt definieren ("sonst regression")

**Ort:** `super/Code/test_data_xml/experiment_golden_kern.xml:246`.

**Beleg (heute nachgelesen):**

```
  <run_options cap="131072" build_version="golden_kern"/>
```

**Ein** Element traegt die Mess-Obergrenze **und** die Bau-Identitaet. Die 18 Achsen tragen ihre `allowed_variants` (Z. 217 ff., Produkt 2^17), die Tooling-Kombination steht separat bei Z. 416 (`<combo tools="wallclock macro micro"/>`).

**Konsequenz:** solange eine Mess-Groesse und eine Bau-Groesse im **selben Attribut-Satz** stehen, kann eine Mess-Aenderung eine Bau-Identitaet **mitverschieben**, ohne dass es jemand als Neubau liest.

**Naechste Handlung:** Bau-Block und Mess-Block als **getrennte XSD-Vokabeln** fuehren; additiv, wie G5 es bereits vorexerziert hat (`run_options`/`organ_subaxes` je `minOccurs="0"`). **T2.**

---

## V.B VOR-TRIGGER

### B-1 `[~] TEILWEISE` -- LB-6 Stufe 1: Zeilen-Ruecklesung, mehrzeiliger Stempel, echte FS-Konkurrenz

**Ort:** `ce/tests/unit/test_lb0_lager_pfad_grammatik.cpp` (**34** `^TEST`-Makros) - `test_lb1_knoten_heuristik_log.cpp` (**26**) - Registrierung `ce/tests/unit/CMakeLists.txt:5003` und `:5019`.

**Zeilenkorrektur (dritte Messung an einem Tag):** Ledger nannte `:4970`, die Kapitel-Erhebung fand `:4995/:5008`, heute stehen sie an **`:5003`/`:5019`**. Zeile verschoben, Befund unveraendert. Siehe N-2.

**Beleg der Luecke:** **kein** `test_lb2`, **kein** `test_lb3` -- die Beweise reichen namentlich nur bis LB-1. Plan-Deckung dagegen belegt: `super/docs/sessions/20260801-FAHRPLAN-vollbau4-beweise-g6-trigger.md:200-201` (OE-B: *"Dummy-Lager im temp-Verzeichnis, Binaries als TEXTDATEIEN mit Stempel-String, Test als GOOGLE-TEST"*).

**Buchfuehrungs-Luecke, die dazugehoert:** `LB-[0-9]` = **0** im 474-Zeilen-Register vom 06.08.; `OE-B` = **0**. Ursache ist nicht das Zeitfenster, sondern die ausgelassene Quellenklasse `docs/sessions/*`. Siehe Z-6, R-10.

**Naechste Handlung:** Stufe 1 bauen (Zeilen-Ruecklesung aus echten Dateien, mehrzeiliger Stempel, echte FS-Konkurrenz) -- klein, golden-neutral, keine Produktivdatei; parallel den LB-Schnitt in **Ledger und Register** nachtragen. **T1.**

### B-2 `[ ] OFFEN` -- B10-Pruefdurchlauf, mit Anker auf Fingerprint-Mismatch

**Ort/Beleg:** `ce/libs/cache_engine/builder/build_variant_sidecar.hpp`, Kommentarblock: *"COMDARE_VARIANT_GATE ist damit funktional obsolet (F7-(b)), und die B10-Variant-Gate-E2E-Probe ist wieder beweisfaehig: sie ankert auf Fingerprint-Mismatch."* Abgeloest durch Glied [6] = `bvset` im Format-3-Preimage (`anatomy_fingerprint.hpp`).

**Auflage:** **`COMDARE_VARIANT_GATE=true` NICHT einschalten.** Das Einschalten stellte einen abgeloesten String-Vergleich neben den Fingerprint und kann Scheinneubauten erzeugen -- **es waere eine Regression, kein Test.**

**Umfang:** kein Code, ein Pruefdurchlauf (V7.4 4+1-Beweise + G6/J-0..J-5 auf geeichtem Stand). **T1.**

### B-3 `[ ] OFFEN` -- Beweis 1 und Beweis 4

**Ort:** `super/docs/sessions/20260801-KONSOLIDIERT-gesamtarchitektur-lager-batch-eta-sha512.md:76` und `:89`.

**Beleg:** Beweis 1 ist ausdruecklich **kein** Minimalkriterium mehr: OE-A (01.08.) verlangt die *"lueckenlose BATCH-WIEDERAUFNAHME-Konstruktion (2 Layer, versions-scharfer per-Binary-Nachbau)"* als **Pflicht**. `20260801-FAHRPLAN...:194` haelt fest: *"Beweis 1 wird NICHT als Ersatz-Minimalkriterium gefahren."* Beweis 4 = *"Bestandslog-E2E gegen echtes minio + Takeover-Zweig"*.

**Abhaengigkeit:** Beweis 4 braucht **echtes minio** -- das ist Infrastruktur, nicht Code, und der Impl-Strang hat am Cluster nur Lesezugriff. **Ohne Infra-Termin ist der Posten nicht schliessbar.** **T1** (Beweis 1) / **T2** (Beweis 4, infra-gebunden).

---

## V.C ABGABE / LIEFERUNG

### C-1 `[ ] OFFEN` -- 29 Anhang-Eintraege ohne Datei, 17 davon voellig stumm

Fall-Analyse: **Z-8**. Live gemessen: DE **29 / 17 stumm / 12 mit Ersatztext / 0 Ziele existent**, EN identisch.

**Naechste Handlung:** (a) die 17 stummen bekommen sichtbaren Ersatztext im Stil der 12 vorhandenen; (b) Zaehl-Gate im `thesis:pdf`-Job (Eintraege gegen existierende Ziele); (c) `axis_inventory` einbinden oder abschalten; (d) Bau in **beiden** Sprachen verifizieren. **T3.**

### C-2 `[ ] OFFEN` -- 8 nicht eingebundene Alt-Kapitel, 7 davon unmarkiert

**Beleg (heute nachgezaehlt):** `thesis/kapitel/de/` enthaelt **14** `.tex`-Dateien; `diplomarbeit.tex:280-285` bindet **6** ein (`\include{kapitel/\thesislang/01_einleitung}` bis `06_fazit`). **8 sind nicht eingebunden**; von diesen traegt genau **eine** (`06_evaluation_methodology.tex`) einen Vermerk -- **7 sind unmarkiert**.

*Anmerkung zur Zaehlmethode (N-2):* der Suchbegriff ist `\include{kapitel/\thesislang/`, **nicht** `input{kapitel/de` -- ein `grep` auf die naheliegende Form liefert 0 Treffer und haette den Befund faelschlich entlastet.

**Inhalt:** die nicht eingebundenen sprechen von "neunzehn" Achsen (Treffer je Datei: 4/3/3/8/2/0/1), waehrend das eingebundene `04_implementierung.tex` **7-mal korrekt "achtzehn"** sagt.

**Konsequenz:** niedrig fuer das PDF, hoch fuer jeden, der die Quellen liest und den falschen Stand fuer aktuell haelt.

**Naechste Handlung:** Kopfvermerk je Datei. **T3.**

### C-3 `[ ] OFFEN` -- Anhang A soll in die Lieferung (Owner-Entscheid steht aus)

**Stand:** Anhang A ist gefuellt und baut gruen. Offen ist die **Reichweite**: kommen die Auswertungs-Writer M-8/M-9/M-15 noch mit hinein? Ohne neue Messdaten haben sie nichts auszuwerten.

**Termin-Korrektur:** mit dem 15.09. als Endtermin ist die urspruengliche Empfehlung "nach der Abgabe" **nicht mehr zwingend** -- die Frage ist **neu zu stellen**. **T2** (bestimmt die Reihenfolge der Mess-Auswertung).

### C-4 `[ ] OFFEN` -- Praezisionsluecke zu den Zaehlern

**Ort:** `thesis/kapitel/de/05_evaluation.tex:84-92`.

**Beleg:** der Text sagt, das privilegierte Regime mache *"die zaehlerbasierten Mess-Kategorien (Cache-, dTLB- und Branch-Misses, IPC/CPI ...) ... ueberhaupt erst zugaenglich"* -- **ohne** zu differenzieren, dass auch dort **nur L1D und dTLB real liefern** (A-2). Nirgends steht "alle sieben liefern real"; die Formulierung **suggeriert Vollstaendigkeit**.

**Kosten, wenn nichts geschieht:** eine kuenftige Tabelle zeigt L1D+dTLB real und den Rest faelschlich als "gemessene Nullen" statt "nicht implementiert" -- **eine Aussage ueber Hardware, die nicht gemacht wurde**.

**Zwei Entlastungen, damit sie nicht zurueckkehren:**
- `[-]` **E-d:** eine PMC-Ueberversprechung in den **kompilierten** Kapiteln ist **nicht** belegbar -- `06_fazit.tex:157-162` und `le_limitierung.tex:1` sind korrekt gehedgt.
- `[-]` **E-e:** **Node-Shape-Varianten** -- 0 Treffer in allen Kapiteln und Anhaengen; die "Knotenform"-Stellen in `D_building_block_matrix.tex:183, 212-214` betreffen `axis_04_node_type`, eine andere, tatsaechlich gemessene Achse.

**Naechste Handlung:** **Limitierung praezisieren statt Anhang kuerzen** (~30 min DE+EN). **T2**, vor der ersten Zaehler-Tabelle.

---

## V.D STRUKTUR

### D-1 `[~] TEILWEISE` -- Doppel-Einbindung der Thesis

Divergenz zweimal geheilt (`72eab9ae`, `46824fba`), **Struktur offen**. Fall-Analyse: **Z-1**.

**Ort:** `super/.gitmodules` -- zwei Submodule auf dieselbe URL `../20260931-overleaf-diplomarbeit.git`; nur `thesis/diplomarbeit` traegt `branch`/`update`.

**Offen:** die zweite Einbindung selbst. Solange zwei Zeiger auf dasselbe Repo existieren, kann die Divergenz **jederzeit wiederkehren** -- und `thesis:pdf` (`super/.gitlab-ci.yml:548`) baut nur einen von beiden.

**Naechste Handlung:** eine Einbindung entfernen **oder** eine Wache, die Ungleichheit der beiden Gitlinks **rot** meldet. Zusammen mit der Richtungs-Wache aus Z-3. **T3.**

### D-2 `[ ] OFFEN` -- Trigger-Kopplung an `main`

Fall-Analyse: **Z-2**; akuter Fall: **S-2**/**S-3**.

**Ort:** `super/.gitlab-ci.yml:255`, `:273`, `:291` -- drei Bridges, alle `branch: main`, alle `strategy: depend`.

**Naechste Handlung:** **Weg (a)** Bridge auf `$CI_COMMIT_REF_NAME` bzw. `development` -- kleinster Eingriff, **T1**. **Weg (b)** Gitlink-SHA forwarden und die Kind-Pipeline per API auf diesem SHA starten -- sauber, teurer, **T4**.

### D-3 `[ ] OFFEN` -- super ohne Abdeckungs-Invariante (Luecke gemessen 0, Praevention fehlt)

**Beleg (heute nachgemessen):** im super existiert **kein** `scripts/`-Verzeichnis, folglich kein `ci_test_coverage_*` und keine Diff-Hygiene-Wache; im ce existieren `ci_test_coverage_manifest.sh` (9601 B) und `ci_test_coverage_guard.sh` (12125 B). Der super hat genau **einen** testfahrenden Job (`test:unit`, `.gitlab-ci.yml:236`, `COMDARE_TEST_CTEST_ARGS: "-L da_unit"`), die Vereinigung ist trivial und heute vollstaendig: **144 super-eigene Tests, alle mit `da_unit`, Luecke 0** (E-f).

**Warum der Posten trotzdem offen ist:** im ce ist genau diese Luecke **zweimal nachgewachsen** -- 21 Tests am 13.07. (M-CE-25), erneut 9 am 06.08. **Nichts haelt die super-Null von selbst.**

**Naechste Handlung:** Manifest + Wache spiegeln, mit dem einen entscheidenden Unterschied: die Wache muss ce- und prt-art-Submodul-Tests **aus dem Nenner nehmen** (sonst meldet sie 313 falsch-ungedeckte). Gemeinsam mit der Diff-Hygiene-Wache aus R-1/R-7. **T3.**

### D-4 `[~] TEILWEISE / [?] teilweise UNBELEGT` -- Struktur-Haertung des Appendix-Generators

**Ort:** `super/Code/08_appendix_generator/CMakeLists.txt:6, 10, 15` -- `comdare_da_add_library(... MODULE M08)`, `target_include_directories(... PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})`, Alias `comdare::appendix_generator`.

**Verifiziert:** das Modul ist eingebunden (`Code/CMakeLists.txt:309`), das Graph-Paket ist gelandet (`b-graph-2d3d` ist Vorfahr von `development`, Kopf `31af5a92`).

**`[?] UNBELEGT (U-2):** die Forderung nach einem **eigenen Include-Root plus INTERFACE-Ziel**, damit ein vergessenes `target_link_libraries` einen **deterministischen Compile-Fehler** statt einer Race erzeugt, liess sich in den Session-Dokumenten nicht mit Fundstelle belegen (`grep` auf "Include-Root"/"INTERFACE-Ziel" in `docs/sessions/20260806-*`: 0 Treffer). **Als UNBELEGT gefuehrt, nicht als erledigt.**

**Sachlicher Zusammenhang:** die Forderung adressiert genau die Klasse, die in **Z-7** real zugeschlagen hat (Include-Pfad ohne Ordnungskante). Sie ist damit inhaltlich plausibel, aber ohne Quelle.

**Naechste Handlung:** die Forderung an ihrer Quelle (Vierfach-Review) rekonstruieren, dann entscheiden. **T4.**

---

## V.E SICHERHEIT

### E-1 `[ ] OFFEN` -- `refs/backup/pre-secret-scrub-20260802` mit 776 Runner-Token auf gitlab origin

**Owner-Entscheid liegt vor.**

**Beleg, live nachgeprueft:** `git ls-remote origin 'refs/backup/*'` im super liefert **heute noch**:

```
5ba3d03fdd5d612d747e18f9b5b4f2d0fdb89f80	refs/backup/pre-secret-scrub-20260802
```

Der Ref enthaelt `44820451` (per `merge-base --is-ancestor` nachgewiesen). In den beiden Dateien `docs/sessions/backups/20260802-e23-suchlauf-belege/e23/group_projects.ndjson` (**386**) und `projects_all.ndjson` (**390**) stehen **zusammen 776** Vorkommen von `runners_token` mit realen Werten der Form `GR1348941...`. Lokal zeigen `refs/backup/pre-secret-scrub-20260802` **und** `refs/original/refs/heads/development` (filter-branch-Artefakt) auf **dasselbe Objekt**.

**Wie es unentdeckt bleiben konnte:** der Scrub-Commit vom 02.08. traegt den Titel *"token-frei, Verify 0"*. **Die Verifikation lief gegen den Zweig, nicht gegen alle Refs.** Gefunden hat es die Verifikationsauflage **nach** einem Push -- ohne sie waere es weiter unbemerkt geblieben.

**Klassenmerkmal:** ein Scrub-Verify, das nur den **Arbeitszweig** scannt, sagt nichts ueber **Backup-Refs** -- und Backup-Refs werden mitgepusht. Exakt die Form von R-3: eine Vollstaendigkeitsaussage ueber eine zu kleine Menge.

**Einordnung:** internes GitLab, Repo privat -- **kein oeffentliches Leck**, aber seit 02.08. fuer jeden mit Lesezugriff abrufbar.

**Owner-Entscheid (bindend):** **stehen lassen; nach der Lieferphase in ein rechtebeschraenktes Bundle ueberfuehren, dann die Remote-Ref loeschen.** Nichts wurde angetastet -- Remote-Loeschung braucht ausdrueckliches GO.

**Unabhaengig davon zu entscheiden:** **Rotation** der Runner-Registration-Token entwertet die Werte, egal ob der Ref bleibt.

**Naechste Handlung:** Rotation **T3**; Bundle + Ref-Loeschung **T4**.

---

## V.F FOLGEPOSTEN (durch die Lage-Korrektur terminiert, nicht mehr "nach der Abgabe")

### F-1 `[ ] OFFEN` -- F3 / Weg a: Fixture nachziehen, mit der R1-Haertung im selben Commit

**Stand:** Vorbedingung erfuellt (`super/Code/tests/fixture_schema_subset_check.cmake` existiert in `development`); der Rename ist **nicht** vollzogen -- die ce-Fixture heisst weiter `tests/unit/thesis_tiere/experiment_golden_kern.xml`. GO liegt vor (Ledger Z. 5220: *"F3: Bitte sauber die fixture nachziehen"*).

**Bindende Auflage, am Objekt geprueft:** `fixture_schema_subset_check.cmake:98-101` deutet einen fehlenden `FIXTURE`-Pfad als *"Nachbar-Checkout fehlt"* und meldet **still SKIPPED**. Die Nachbarpruefungen fuer `SCHEMA` (`:92`) und `MASTER` (`:96`) sind dagegen **FATAL**. **Nach dem Rename waere die einzige Wache des Neu-Paares lautlos abgeschaltet.** Die Gegenmassnahme -- Verzeichnis existiert, Datei fehlt => FATAL -- ist **nicht** vorhanden.

**Sie muss im selben Commit wie der Rename kommen.** Andernfalls ist es ein Lehrbuchfall der Klasse aus Kapitel III: eine Heilung, die eine stille Wache erzeugt. **T3.**

### F-2 `[~] TEILWEISE` -- F5 S6/S7

Der additive Teil S0-S5 ist gebaut, nachgewiesen in `super/Code/test_data_xml/experiment_golden_kern.xml` (Z. 217 Pin geheilt, Z. 246 `run_options cap="131072"`, Z. 416 eine Kombo). Offen: **S6** (semantischer `line_size`-Konsum, Owner-Entscheid E-4) und **S7** (Aufraeumen). **T4.**

### F-3 `[ ] OFFEN` -- Aufraeumpass (Owner-KERN)

Kandidatenliste **erweitern** um:
- `COMDARE_VARIANT_GATE` -- funktional obsolet per F7-(b), **nicht vor dem Aufraeumpass entfernen** (B-2 braucht den Zustand).
- Die drei irrefuehrenden `COMDARE_LEGACY_MESSREIHEN`-Kommentare im ce (SW-6).
- Die Formel **"byte-neutral / golden-neutral"**, wo sie als **Begruendung fuer Nicht-Verdrahtung** dient (Spitzenreiter `cache_engine_builder_iterator.hpp` 23x, `profile_run_facade.cpp` 21x, `build_orchestrator.hpp` 18x) -- in **zwei Klassen trennen**: Regressionsschranke (bleibt) vs. Grund, eine Faehigkeit nicht anzuschliessen (Kandidat).
- Die dokumentierte Pflicht-Reihenfolge J-3, jetzt obsolet durch Z-7.

**T4.**

### F-4 `[ ] OFFEN` -- `offen>0`-Praefixschnitt mit `present_`-Gate

Fall-Analyse: **H-6**. `ce/libs/cache_engine/builder/bestandslog/batch_planner.hpp:163` -- das Feld wird gefuehrt, aber an **keine Entscheidung** angeschlossen. Verlangt: mindestens eine Wache, die widerspruechliche Faecher (`offen>0` bei vollstaendig gedecktem Praefix) meldet. Praesenz-Praedikat liegt bereit (`batch_planner.hpp:58`, `planer_driven_build.hpp:452`). **T4.**

### F-5 `[ ] OFFEN` -- Formwache pro Atom

Fall-Analyse: **H-4-R1**.

> **Statuskorrektur gegenueber der Session:** dieser Posten war als `[?] UNBELEGT` gefuehrt, weil der Begriff "Formwache pro Atom" in den Session-Dokumenten nicht auffindbar war. Er ist **belegt** -- die Quelle ist die Heilung `71b5586a` selbst, die die Wache **plan-global** baut und die atom-granulare Form ausdruecklich als offene Verfeinerung benennt. **`[?]` aufgehoben, Posten echt.**

**Inhalt:** ein Atom ohne pruefbare Identitaet soll aus dem Plan **genommen** werden, statt den ganzen Plan zu verwerfen. **T4.**

### F-6 `[ ] OFFEN` -- Observer-Push ueber die Modulgrenze

**Stand am Objekt.** Der heutige Weg ist ein **Pull**: `ce/libs/cache_engine/anatomy/observable_tier.hpp` beschreibt `tier_observe(ComdareTierObserverSnapshot*)` mit flachem POD, abgefragt per `dynamic_cast` (*"1x kalt je Modul, nie im Hot-Loop"*). Ein **Push**-Kanal ueber dieselbe Grenze ist **nicht gebaut**.

**Warum es zusammenhaengt.** Solange nur gepullt wird, kann eine Tier-`.so` nichts **melden** -- sie kann nur **beantworten, was gefragt wird**. Das ist strukturell dieselbe Beschraenkung, die H-1 an der CLU-Kette sichtbar gemacht hat: der Host weiss ueber die Modul-ABI nur, was der POD traegt. Jede neue Messgroesse braucht heute eine Erweiterung des PODs plus eine Anpassung aller Leser.

**Abhaengigkeit:** beruehrt die ABI-Stabilitaet der Tier-Module und damit die Bau-Identitaet -- **nicht vor A-1/A-5 zu entscheiden**, weil die Mess-Achsen-Orchestrierung den Rahmen setzt.

**Naechste Handlung:** Entwurf erst nach A-5 (ObservableTier-Orchestrierung). **T4.**

---

## V.G Zusammenfassung des Checkhefts

| Block | Posten | Termin-Klassen |
|---|---|---|
| **Sofort** | S-1 Gitlink committen - S-2 ce main FF - S-3 super main FF - S-4 3 Plandocs versionieren | jetzt |
| **T1** (vor dem ersten 4096er-Batch) | A-1 PMC ueber die Mess-Achse - A-3 `allow_failure`/Preflight - A-4 Fortpflanzungsregel - B-1 LB-6 Stufe 1 + Buchung - B-2 B10-Pruefdurchlauf - B-3 Beweis 1 - D-2(a) Bridge auf development | 7 |
| **T2** (vor der Voll-Messung) | A-2 L2/L3/Kohaerenz - A-5 ObservableTier-Orchestrierung - A-6 XML Bau/Messung trennen - C-3 Anhang-A-Reichweite - C-4 Zaehler-Limitierung praezisieren | 5 |
| **T3** (vor dem 15.09.) | C-1 17 stumme Anhang-Eintraege + Zaehl-Gate - C-2 7 Kapitel-Kopfvermerke - D-1 Doppel-Einbindung - D-3 super-Abdeckungswache + Diff-Hygiene-Wache - E-1 Token-Rotation - F-1 F3-Rename mit R1-Haertung | 6 |
| **T4** (danach) | D-2(b) SHA-Forwarding - D-4 Appendix-Generator-Haertung - F-2 F5 S6/S7 - F-3 Aufraeumpass - F-4 `present_`-Gate - F-5 Formwache pro Atom - F-6 Observer-Push | 6 |

**Prozess-Posten ohne eigene Nummer, aber verbindlich:** N-1 (Wache repo-bindend), N-2 (Belege brauchen Suchbegriff + Zaehlmethode), N-3 (Landungsfragen gegen `origin/*`), N-4 (Remote-Fragen nur per `ls-remote`), R-6 (die Liste der **nicht** gelaufenen Gates), R-9 (rescue-Ref-Routine), R-10 (Quellenklassen jeder Konsolidierung auflisten).

---

# KAPITEL VI -- WAS DIESE SESSION STRUKTURELL GEZEIGT HAT

Dies ist keine Zusammenfassung und kein Fazit im ueblichen Sinn. Es ist die **Diagnose**: warum ein System dieser Groesse genau diese drei Fehlerklassen erzeugt, warum keine von ihnen ein Fehlersignal produziert, und was sie kuenftig verhindert.

## VI.1 Die drei Klassen sind eine Klasse in drei Stadien

Es sieht aus wie drei verschiedene Probleme. Es ist eins, dreimal fortgeschritten.

**Stadium 1 -- die stille Wache (Kapitel II).** Eine Zusicherung wird **einmal** geprueft und dann in eine Konstruktion gegossen, die den Pruefvorgang nicht wiederholen kann: ein Kommentar (`"der Ausschluss verweist auf die dedizierten Gates"`), ein Job-Name (`"in GENAU die 2 Mess-Jobs"`), eine Variable, die niemand setzt (`COMDARE_AXIS_LOCK_CHECK`). Ab dem Moment ihrer Erstarrung ist die Zusicherung eine **historische Aussage**, die als **gegenwaertige** gelesen wird. Sie verfaellt lautlos, weil eine erstarrte Zusicherung kein Verfallsdatum traegt.

**Stadium 2 -- die Heilung neben der Wunde (Kapitel III).** Jemand findet das Problem, benennt es und heilt es. Und weil eine Heilung ein **Gruen** erzeugt -- einen Commit, eine Wache, einen Test --, wird die Stelle als geschlossen verbucht. **Niemand sucht ein zweites Mal an einer Stelle, die als geheilt gilt.** Die Heilung ist damit gefaehrlicher als der Defekt: sie verlegt den Rueckweg. Sechs der sieben Faelle des Kapitels III wurden nur gefunden, weil jemand eine **fertige** Heilung gegengeprueft hat.

**Stadium 3 -- zwei Quellen fuer dieselbe Wahrheit (Kapitel IV).** Hier ist gar nichts kaputt. Zwei Submodul-Zeiger auf dieselbe URL, zwei Zweige, zwei Register, eine `.tex`-Zeile und eine fehlende Datei -- **jeder Einzelzustand ist legal**. Der Fehler entsteht erst aus der **Differenz**, und Differenzen haben keinen Exitcode. Das ist die teuerste Stufe, weil ihr Schaden **genau am Liefertag** sichtbar wird: man liefert das gebaute Artefakt, nicht das gepflegte.

Der gemeinsame Kern aller drei, und der Satz, der dieses Dossier traegt:

> **Eine Messung war fuer sich korrekt und beantwortete die falsche Frage.**

Eine *falsche* Messung faellt irgendwann auf. Eine *korrekte* Messung der *falschen Frage* liefert eine belastbare Zahl, ein gruenes Gate und ein reines Gewissen. Sie erzeugt **kein Fehlersignal** -- sie erzeugt das Gegenteil davon.

## VI.2 Warum das in einem System dieser Groesse entsteht

Vier strukturelle Ursachen, jede an mehreren Faellen dieses Hefts belegt:

**(1) Der Pruefbereich ist nicht mehr trivial.** In einem kleinen Repo sind "was ich geaendert habe", "was landet" und "was gebaut wird" dasselbe. Hier sind es drei verschiedene Mengen -- Dateimenge, Commit-Bereich, Bau-Zustand --, und jede kann fuer sich vollstaendig gemessen werden. R-1, R-2 und R-5 sind drei Gesichter desselben Problems: **jede Zahl braucht ihren Nenner, und der Nenner ist nicht mehr offensichtlich.**

**(2) Ein Teil des Systems ist generiert, nicht geschrieben.** Der Plan-Director emittiert CI-Jobs, die in keiner eingecheckten Datei stehen. Ein `grep` ueber das Repo ist damit **vollstaendig fuer eingecheckte Dateien** und **unvollstaendig fuer das System**. R-4 ist die entlastete Version dieses Fehlers, A-1 die noch offene: eine Pflicht, die an Job-Namen haengt, ueberlebt den Wechsel auf einen generierten Erzeugungsweg nicht.

**(3) Die Artefakte existieren mehrfach, weil das System mehrfach eingebunden ist.** Vier Klone, zwei Remotes, zwei Submodul-Zeiger auf dieselbe URL, `main` und `development` in beiden Repos. Jede dieser Doppelungen hat einen guten Grund. Zusammen erzeugen sie einen Raum, in dem **"richtig" und "an der richtigen Stelle" auseinanderfallen koennen**, ohne dass ein Werkzeug es merkt.

**(4) Fail-open ist fast immer die bequemere Voreinstellung.** `\InputIfFileExists` mit leerem Else-Zweig, `SMOKE_SKIP` mit Exit 0, `SKIPPED` bei fehlendem Nachbar-Checkout, eine grep-Pipe ohne `pipefail`, ein `allow_failure: true`. Jede dieser Entscheidungen war **einzeln** vernuenftig -- sie hielt eine Pipeline gruen, waehrend etwas anderes gebaut wurde. Aber **fail-open uebersetzt Abwesenheit in Stille**, und Stille ist von Erfolg nicht unterscheidbar.

## VI.3 Der ehrlichste Teil: mehrere Befunde entstanden aus der Widerlegung der eigenen frueheren Aussage

Das ist kein Nebensatz, sondern die belastbarste Erkenntnis dieser Session. **Die produktivste Pruefmethode des Tages war nicht das Suchen nach neuen Fehlern, sondern das Nachpruefen der eigenen fertigen Arbeit.** Vier belegte Faelle:

**(a) Eine Sonde, die die falsche Frage stellte.** Die TSAN-Sonde des Erst-Reviews hatte das Barrieren-Fenster (H-5) korrekt nachgestellt -- und `[OK]` gebucht. Gefragt worden war *"haengt `drain()`?"* (nein). Die richtige Frage war *"haelt die Barriere?"* (nein). Ledger-Verbatim: *"Der Befund kam von Codex; ich hatte ihn in der Hand und nicht gesehen."* Der Aufbau war valide, das Ergebnis war korrekt, die **Zusage, gegen die gemessen wurde**, war die falsche.

**(b) Eine Empfehlung an einer ungemessenen Zahl.** Die Session hatte die PMC-Nachruestung (A-2) mit Verweis auf Aufwand und Restzeit zur Zurueckhaltung empfohlen -- gerechnet gegen den 08.08. Der Owner hat beides korrigiert: den Termin (15.09., woechentliche Lieferung) **und** die Sache (*"PFLICHT und KERN der ANLAGE"*). Die Empfehlung war nicht falsch gerechnet; sie war **gegen die falsche Bezugsgroesse** gerechnet -- exakt das Muster dieses Dossiers, angewandt auf eine Terminplanung.

**(c) Drei falsche Commit-Zuordnungen.** Heilungen wurden Commits zugeschrieben, die sie nicht enthielten; die Nachpruefung per `merge-base --is-ancestor` und `git show` hat sie korrigiert. Verwandt: die Botschaft von `98952e02` nennt "13 Dateien", der Baum sagt 12 (die dreizehnte kam in `e7aa1244`). **Eine Commit-Botschaft ist eine Behauptung, kein Beleg.**

**(d) Ein Schluss aus einem abgebrochenen Werkzeuglauf.** Die kaputte Gate-Kette (SW-4) meldete "0 Verstoesse", weil ihre **mittlere** Stufe mit RC 2 abbrach und die letzte Stufe leere Eingabe sah. Der Abbruch war nicht sichtbar; die Null war es. **Ein abgebrochener Lauf und ein negativer Befund sehen identisch aus, wenn niemand den Exitcode jeder Stufe liest.**

**(e) Und in diesem Verifikationsdurchgang noch zweimal.** N-1: der Pruefer ist selbst in die Repo-Bindungs-Falle der neuen Wache gelaufen und hat es erst an der Zahlendifferenz (12578 statt 1450) gemerkt. N-4: aus veralteten lokalen remote-tracking-Refs waere beinahe ein Befund mit Abgabe-Relevanz geworden ("die GitHub-Sicherung enthaelt Gate 8 nicht") -- ein `ls-remote` hat ihn entlastet.

**Die Verallgemeinerung:** in dieser Fehlerklasse ist der Pruefer **nicht ausgenommen**. Eine Verifikation ist selbst eine Messung und kann selbst die falsche Frage beantworten. Der einzige Schutz, der sich bewaehrt hat, ist **die Zusage vor der Sonde aufzuschreiben** -- erst formulieren, was bewiesen werden soll, dann messen. Wer erst misst und dann interpretiert, findet immer eine Frage, auf die seine Zahl die Antwort ist.

## VI.4 Was diese Klasse kuenftig verhindert

Aus 25 Befunden lassen sich vier Massnahmen ableiten, die **nicht** Disziplin sind. Disziplin traegt gegen diese Klasse nachweislich nicht: SW-2 war schon einmal von Hand geheilt (13.07., 21 Tests) und war binnen drei Wochen zurueck (9 Tests).

**(1) Jede Zahl mit Nenner, erzwungen vom Werkzeug.** Die neue Diff-Hygiene-Wache druckt einen Block `NENNER (nie eine nackte Null):` und ihren Bezugsrahmen. Das ist der Unterschied zwischen "ASCII: 0" und "1448 Zusatzzeilen geprueft, davon 0 Nicht-ASCII, davon 2 ueber 120 Spalten". **Eine nackte Null ist kein Ergebnis.**

**(2) Invariante statt Liste.** `test:coverage-guard` stellt seine Inventur **live** her (`ctest -N`) statt aus einer gepflegten Liste, hat kein `rules`-Gate und kein `allow_failure` -- ein neuer Test ist **ohne Zutun** Teil der Pruefung. Das ist der strukturelle Gegenentwurf zu jeder Zusicherung, die gepflegt werden muss, um wahr zu bleiben. Uebertragbar auf: die Gitlink-Gleichheit (D-1), die rescue-Ref-Erreichbarkeit (R-9), das Verhaeltnis `\InputIfFileExists`-Eintraege zu existierenden Dateien (C-1).

**(3) Fail-closed als Voreinstellung, mit ausdruecklich benannter Grenze.** Die DOCTYPE-Sperre (H-2) lehnt **komplett** ab und schreibt ihre Grenze in den Code: *"diese Wache unterstuetzt ausschliesslich DOCTYPE-freie XML"*. So sieht eine Wache aus, die weiss, was sie nicht kann. Gegenbeispiele in diesem Heft: `SMOKE_SKIP` mit Exit 0 (A-3), `SKIPPED` bei fehlendem Nachbar (F-1), leerer Else-Zweig (C-1).

**(4) Die Frage nach dem, was NICHT gelaufen ist.** Von den zehn Regeln sind sieben heute an einem Werkzeug verankert. Die drei verbliebenen -- R-3 (Vollstaendigkeitsaussagen), R-6 (welche Gates sind **nicht** gelaufen), R-10 (Quellenklassen einer Konsolidierung) -- teilen eine Eigenschaft: **sie fragen nach einer Abwesenheit.** Genau dafuer gibt es heute kein Werkzeug, und genau dort haben drei der teuersten Befunde dieses Hefts gelegen (SW-2, SW-3, Z-6). Das ist der naechste Automatisierungs-Kandidat.

## VI.5 Der Satz, den man sich merken muss

> **Gruen ist keine Aussage ueber den Pruefbereich.**
> Jede Wache dieses Projekts beantwortet die Frage *"war das, was lief, in Ordnung?"*
> Keine beantwortet *"lief das, was gemeint war?"*

Solange die zweite Frage kein Werkzeug hat, ist sie die Aufgabe des Lesers dieses Hefts.

---

## ANHANG -- Verifikations-Nachtrag

Alle Messungen dieses Dossiers wurden am 06.08.2026 abends gegen die folgenden Staende erhoben. Sie werden hier festgehalten, damit jede Zahl reproduzierbar bleibt (N-2).

| Gegenstand | Stand |
|---|---|
| super `origin/development` (== lokaler `development`, == HEAD) | `46824fba` |
| super `origin/main` | `5534c23c` (10 zurueck) |
| ce `origin/development` | `f57801d3` |
| ce `origin/main` | `47c4ef1d` (2 zurueck) |
| ce lokaler `main` im Hauptklon | `2b0a9bd8` (veraltet) |
| thesis `origin/development` == `origin/main` == `github/development` == `github/main` | `8e58f691` |
| super Gitlink `thesis/diplomarbeit` | `8e58f691` (Zeiger == Checkout) |
| super Gitlink `Code/external/20260931-overleaf-diplomarbeit` | `8e58f691` (Zeiger == Checkout) |
| super Gitlink `Code/external/comdare-cache-engine` | committet `47c4ef1d`, Checkout `+f57801d3` |
| super Gitlink `Code/external/comdare-prt-art` | `c6f07540` |
| cmake | 4.3.4 |
| GNU grep | 3.11 (`/usr/bin/grep`) |
| `grep` als blosses Wort | Shell-Funktion auf **ugrep** |

**Kapitel-Stand vs. Abfassungs-Stand.** Die Kapitel I-V wurden gegen super `72eab9ae` / ce `47c4ef1d` erhoben. Zwischen Erhebung und Abfassung sind drei Landungen erfolgt (super `46824fba`; ce `678a4487` + Merge `f57801d3`), die **zwei Befunde geheilt** (Z-1 erneut, Z-7) und **einen verschlechtert** (Z-5: von 2 auf 3 untracked Plandokumente, von 1313 auf 2042 Zeilen) haben. Alle betroffenen Eintraege sind entsprechend nachgefuehrt und tragen die Live-Messung.

**Nicht committet.** Dieses Dokument wurde geschrieben, nicht eingecheckt -- die Ablage erfolgt durch den Lead.
