# KONTEXTÜBERGABE — Nacht 3 zum 10.08.2026

> **Vorgängerin:** `20260809-KONTEXTUEBERGABE-nacht-2-goal-set-permutationen-und-die-no-skript-doktrin.md`.
> Sie wird **nicht ersetzt**. Wer nur eine liest, liest diese — aber das GOAL SET und die
> fünf Owner-KERNe der Vorgängerin gelten unverändert.

---

## 0. DAS ERSTE, WAS DU TUST

**Die vier bindenden Dokumente WIRKLICH kippen** — vollständig mit `Read`, nicht greppen,
nicht anlesen. Owner-Direktive vom 09.08. spät:

> „arbeite im Sinne der gesetzten Regeln und Konventionen des Goals v8 (die du bitte **ALLE
> WIRKLICH in den Kontext kippst** und **IMMER nach Kompaktierung neu hineinkippst** →
> merke dir das) maximal parallel weiter. **Rate NIE.**"

Vollzogen in dieser Nacht, mit Nenner — dieselbe Deckung wird von dir erwartet:

    docs/sessions/20260808-GOAL-V8-KONSOLIDIERTE-LESEFASSUNG-verbatim.md      241 / 241
    docs/ARBEITSWEISE-GESAMT-DOKTRIN.md                          (v3.1)      557 / 557
    docs/plaene/20260808-GOAL-V8-DOSSIER-...md                                659 / 659
    docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md        971 / 971  (4 Portionen)
    docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-wellen.md          289 / 289
    ------------------------------------------------------------------------------------
                                                                           2.717 Zeilen

Der Wellenplan braucht vier `Read`-Aufrufe (Zeilen-Fenster ~200), sonst reißt das Token-Limit.

Danach: `MEMORY.md` (der Index) und der **Ledger-Kopf** — Nachträge stehen **oben**.

---

## 1. WO DER PLAN STEHT

**W-1 ist abgeschlossen, am Objekt belegt.** Der ST-CTestWache-Wurzelfix steht:
`enable_testing()` in ce `CMakeLists.txt:695`, **vor** `add_subdirectory(libs/cache_engine)`.
Das ist die Ursache, die **30 gtest-Fälle 79 Tage lang unsichtbar** gemacht hat — darunter
`WelchTTest.*`, das Verfahren, das „signifikant schneller" entscheidet.

**W0a ist gelaufen** (Wellenplan-Fenster: Mo 10.–Mi 12.08.). Vier Bau-Stränge, je mit
Pflicht-Explore davor:

| Strang | Worktree | Stand |
|---|---|---|
| D2-G1 + D1f + MT-L4 + AS-Bewaffnung | `wt-ce-w0a` | arbeitete zuletzt, 0 Commits |
| D1b + D1e | `wt-ce-d4` | 1 Commit — „Bauweg-Wache: die zweite Hälfte von T-7 hatte kein Werkzeug" |
| D2 + D2-G3 + D2-G6 | `wt-ce-fk` | **6 Commits**, HEAD `6efd09aa`, inkl. `COMDARE_WACHE_STRIKT` |
| D1g (super) | `wt-super-warn` | 1 Commit — „610/186 gemessen statt behauptet, **sechs stumme Testfälle** gefunden" |
| D2 (Zweitfassung) | `wt-ce-d2floor` | 3 Commits, HEAD `7f3901fb` |

**Keiner davon ist gelandet.** Das ist der erste Handgriff.

**D2-G1 ist erledigt** — der Wurzelfix hat es geheilt. Gemessen: 30 Fälle entdeckt, 30 in
`ctest -N`. Die Plan-Zahl 27 ist auf **30** zu korrigieren (`test_commands.cpp` hat 23 statt
20 `TEST(`-Makros, `test_engine_adapters.cpp` 7).

---

## 2. WAS GELANDET IST

    ce    7c3d2934 → aebc4f2c → 1880f296     28 Commits, main zweimal per FF nachgezogen
    super b74bbe26 → d8808fb9 → e4b34b74     zwei Ledger-Nachträge, 246 Zeilen Befunde

**Zwei Commits warten** in `wt-super-landung` auf `development`:

    a5aef13d  docs(plan): ##34 -- der Magic-Wechsel ist GEFALLEN, "4->5" war ein Textrest
    ac0c6a1b  chore(vendoring): Gitlink ce 2eb310ae -> 1880f296 + PZW-Anker

Beide sind fertig, gitleaks-geprüft, PZW-Wache 5/5 grün. Sie warten auf **zwei Tore**:
R4 (super-Pipeline 15503 lief noch) und ce/main-Pipeline 15505.

**Warum beide Tore:** super's `trigger:cache-engine` fährt `branch: main`, **nicht** den
Gitlink (`.gitlab-ci.yml:1002-1005`). Ein Bump vor grünem main erbt dessen Rot.

---

## 3. VIER IRRTÜMER VON MIR — sie sind der eigentliche Ertrag der Nacht

**(a) „490 Tests" traf keinen realen Bau-Zustand.** Ich gab sie vier Strängen als Sollstand
mit. Am Objekt: **488** ohne 2-Pass, **492** mit, **490** ist die `-LE pmc`-Teilmenge
(`test:unit`). Drei Mengen, drei Zahlen. V6.5 wörtlich: *zur Testzahl gehört der
BAU-ZUSTAND, nicht nur der Commit.*

**(b) „Der main-FF ist der Heiler für super" war eine falsche Vorhersage.** Er heilte
`pmc:intel` und legte `test:coverage-guard` frei. Netto ein Defekt weniger, super blieb rot.
Ein Task-Titel, der eine **Wirkung behauptet**, gehört nach dem Vollzug so hart geprüft wie
jede Messung.

**(c) Die OV-Bilanz zählte Zeichenketten statt Gegenstände.** `grep -c "OV-6"` = 0 → „nie
erwähnt, also offen". Der Ledger hält bei `:898` fest, warum das nicht trägt: **der Owner
nummeriert nicht, er beschreibt.** Die belastbare Bilanz steht dort schon — von 18
Streichungen sind **4 owner-verifiziert, 6 nur behauptet**.

**(d) Mein `SendMessage` erzeugte einen zweiten Schreiber.** Die Quittung lautete
*„had no active task; **resumed from transcript in the background**"* — ich habe sie gelesen
und nicht als Warnung erkannt. Folge: zwei Instanzen schrieben in `wt-ce-fk`, dieselbe Datei.
Der Strang fand es über eine **Byte-Zeitreihe** und **zwei Bezeichner-Handschriften**, stellte
das Schreiben ein und fragte. Auflösung: ausweichen statt stoppen — beide Fassungen leben,
beide kamen unabhängig auf die Untergrenze **488**.

---

## 4. DIE WACHE, DIE ZWEI LÜCKEN HAT

`scripts/ci_diff_ascii_width_guard.sh` — die Wache, mit der ich in dieser Nacht ein
58-Verstöße-Paket abgenommen habe.

**Lücke 1 (#48): sie misst push-lokal, nie kumulativ.** Gleicher Baum, zwei Urteile:
1 Zusatzzeile grün auf development, **18.577 rot** auf main. Der main-FF ist das erste
kumulative Gate. Der Wellenplan führt den Bestand bereits als W7-Zähler („ASCII 1160"),
mit *„ab W0b nur Zuwachs-Stopp"* — die Wache ist also **richtig konstruiert**, nur ihre
Reichweite ist schmaler als ihr grünes Verdikt suggeriert.

**Lücke 2 (#51): sie prüft Shell-Dateien nicht.** `is_scoped()` ist eine **Whitelist**
(`.cpp/.hpp/.h/.hh/.cc/.cxx/.tpp/.ipp/.inl/.cmake` + Basename `CMakeLists.txt`). `.sh` fehlt.
Mit eigenem Köder belegt — eine `scripts/probe.sh` mit `ä` und einer 130-Zeichen-Zeile:
`rc=0`, **GRUEN**, „2 davon außerhalb des Scopes".

**Und sie war nicht nur potenziell blind, sondern real:** ein Strang hat seine eigene
Bilanz-Zeile von 159 auf 121 gekürzt, dann auf **122** umformuliert und nicht nachgemessen.
Sein Satz dazu: *„Der Selbstcheck lief vor der Änderung, nicht danach — K11 in anderer
Kleidung. Durch alle Tore kam es, weil die Hygiene-Wache `.sh` nicht prüft: ihr GRUEN über
meinen Bereich war kein Urteil über die Datei, die ich geändert habe."*

**Was sie rettet:** sie **nennt die Übersprungenen namentlich**, ausdrücklich damit
„außerhalb des Scopes" nicht zu einer zweiten stillen Null wird. Es ist ein **irreführendes
Etikett über echtem Scope**, kein verschwiegener Befund — der genauere Satz stammt vom
D2-Strang, nicht von mir.

---

## 5. DAS OWNER-WORT, DAS EINEN MEINER TASKS ZUM REGELVERSTOSS MACHTE

Verifiziert am Rohtranskript: **Zeile 25562, `type=user`, `promptSource=typed`,
`2026-08-09T14:34:47.202Z`**, 19 Rohtreffer:

> „Ich sehe einen Haufen shells statt vernünftiger google tests, was soll das? Es wäre
> sauberer im cmake-Debug Modus standard google Tests zu fahren und diese in Release zu
> wiederholen aufgrund von compile regressionen. **Skripte sagen gar nichts.** Bitte
> recherchiere **Mutations-Sicheres Testen**. Die Waisen müssen fertig gebaut werden, also
> die C++ Implementierung dazu."

Dazu 13:31 desselben Tages: *„es war ja auch nur C++ und cmake erlaubt, es gibt ja keine
skripte."*

**Mein Posten #27 verlangte weitere Shell-Proben** — das Gegenteil. Umgeschrieben.
**Belastend:** `frische_wache_probe.sh` und `lauf_marker_probe.sh` wurden **18:55, vier
Stunden nach dem Owner-Wort**, als Shell-Proben gelandet.

**Der C++-Weg existiert schon:** `Code/ci_wachen/` (Modul + Testwerkbank + drei Google
Tests), `Code/tests/CMakeLists.txt:112` trägt die Überschrift wörtlich. **Aber Stufe 1 von 2:**
die *Proben* sind C++, die *Wachen selbst* noch Shell, und `.gitlab-ci.yml:307` ruft weiterhin
`sh scripts/ci_xml_wellformed_guard.sh`. Die C++-Binaries sind gebaut, installiert — und
werden nicht gerufen. **Dieser Ist-Stand steht in keinem Plandokument.**

`Mutations-Sicheres Testen` ist als #50 angelegt und war bisher nirgends geführt.

---

## 6. WEITERE BEFUNDE, KURZ

- **Magic-Budget verbraucht** (#46): genau EIN Wechsel im Fenster, `d4c0b49c` am 09.08.
  Nenner: 159 Commits, 2 an der Definitionsdatei, 1 echte Wertänderung. Schaden heute null.
  **Die NULL-BUMP-Regel gilt ab sofort**, nicht erst ab 24.08. Die Wache dazu fehlt noch.
- **-Wall/-Werror gemessen** (#44): 214 von 574 Kanten, `-Werror` **0 von 575**. Von 471
  `tests/`-TUs tragen nur 208 das Flag — Ursache ist eine **zweite Testklasse** (standalone
  `main()` ohne gtest). Kosten: 114 TUs per `-fsyntax-only`, zwei Compiler — **SPEICHER-Klasse
  leer**, ~20-26 Warnungen. Empfehlung (b): auf die zweite Testklasse ausdehnen, kein `-Werror`.
- **Die ~11 Transkripte enthalten nichts** — 7 sind 226-Byte-Stubs. Für keine der sechs
  behaupteten Streichungen gibt es einen Owner-Beleg. Methodisch: **über 90 % der Rohtreffer
  waren Tool-Result-Echos**; erst `origin.kind=="human"` trennt Owner-Wort von Agenten-Text.
- **`g++-15` existiert auf prod1 nicht** — das blanke `g++` *ist* GCC 15.3.0.
- **`ci_host_klassen_gegenorakel.sh` gibt es nur in super** — die Zahl 423 ist in ce nicht
  nachmessbar. Eine importierte Zahl ist kein fremder Nenner, sondern ein Stellvertreter.
- **Ein Explore lieferte einen reinen Platzhalter** (`thema:"Test"`, alles `"test"`). Das
  Schema erzwingt Struktur, nicht Substanz. Nur die zweite Stufe hat es gefangen.

---

## 7. DER ERSTE HANDGRIFF

1. **Die zwei wartenden super-Commits pushen**, sobald R4 frei und ce/main grün ist.
2. **Die W0a-Stränge landen** — vier Worktrees, je zwei Lenses (Code-Klasse).
   Bei den zwei D2-Fassungen: vergleichen, die reichere nehmen oder die besseren Teile beider.
3. **D2-G6 einbauen** — die Patch-Vorlage liegt im Bericht des D2-Strangs, mit **beiden**
   Zeilenständen (5379/5407/5422 am Objekt gegen 5218/5225/5240 im Explore, ~180 Zeilen Drift).
   Sie gehört in `tests/unit/CMakeLists.txt`, also zum Strang, der diese Datei hält.
4. **Die zwei YAML-Einschübe** (Emitter-Zeile + Artefakt-Pfade) und
   `COMDARE_WACHE_STRIKT: "1"` — alle drei in `.gitlab-ci.yml`, Lead-only-Hotspot.
5. **W0b beginnen.** Der Vorlauf-Explore ist gelaufen: D3-7 ist **gebaut und gelandet**
   (`028684ac`, Vorfahre von origin/development) — mein Befund „offen" war falsch.

**Nicht vergessen:** die Landungen der W0a-Stränge sind der Grund, warum diese Nacht
stattgefunden hat. Was im Worktree liegt, überlebt kein Aufräumen.
