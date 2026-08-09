# KONTEXTÜBERGABE — Nacht 2 zum 09./10.08.2026

> **Vorgängerin:** `20260809-KONTEXTUEBERGABE-nacht-architektur-kerne-und-messkette.md`.
> Sie wird **nicht ersetzt**, sondern fortgesetzt. Wer nur eine liest, liest diese —
> aber die sieben Architektur-KERNe der Vorgängerin gelten unverändert weiter.

---

## ⚠️ DAS GOAL WURDE IN DER LETZTEN MINUTE DIESES KONTEXTS NEU GESETZT

Owner, unmittelbar vor Kontextende, wörtlich (gekürzt auf das Bindende):

> „Bitte lies `docs/sessions/20260808-GOAL-V8-KONSOLIDIERTE-LESEFASSUNG-verbatim.md` **vollständig**
> und kippe das dort referenzierte **Goal v8 Dossier** und die **Claude Code Arbeitsweise v3** in
> deinen Kontext und **arbeite das Goal nach Arbeitsweise vollständig ab**. Du bist fertig, wenn du
> … **alle Wellen und Arbeitsaufgaben** darin erledigt hast und die Arbeit zuletzt anschließend
> einem **codex + Fable xhigh code review mit ultracode** standhält. Du bist **CTO und Manager** der
> Arbeit und **implementierst wenn möglich nichts selbst**, aber **delegierst an bis zu 10 weitere
> Arbeitsstränge und Workflows** … Bitte gib dem Workflow und Agenten **immer eine detaillierte und
> möglichst reiche Beschreibung** für den Auftrag mit. Du **orchestrierst also nur den Ablauf**.
> Bau möglichst **Opus 5 max effort**, **nachsetzen mit Fable 5 xhigh**, wenn unbefriedigend.
> Bei jedem Thema der Verarbeitungskette, an dem du nicht weiterkommst: **Sonnet 5 max effort
> „very thorough" Explore über die letzten 9 Wochen** an session-log/Planung/sessions/memory/code/
> alles. **Fahre auch immer einen Explore, wenn du sonst raten müsstest — rate NIE.**
> Du bist erst fertig, wenn die **Realität dem Design des Goal v8** und allen Owner-Beschreibungen
> des Session-Logs und den Planungs-/Design-Dokumenten vom **Abend des 08.08.2026** sowie der
> **letzten 10 Wochen Historie** entspricht — Konflikte werden mit **„NEU GEWINNT GEGEN ALT"**
> aufgelöst."

**Der Auftrag ist entgegengenommen, aber NICHT begonnen** — der Owner hat den Kontext unmittelbar
danach beendet („schreibe eine reiche Kontextübergabe, der Kontext endet jetzt … dann Pause").
**Das ist der erste Handgriff der nächsten Session, Teil IX.**

Ergänzung desselben Auftrags, ausdrücklich: die Kurzform der Kette
(`XML→Planer→CEB→bauen→messen→auswerten→release+Hybrid→veröffentlichen`) ist **überholt** — es gilt
die Langform mit dem symmetrischen single-/hybrid-Zweig (KERN vom 09.08., Vorgänger-Übergabe).

---

## I. NEUGRÜNDUNG IN FÜNF SCHRITTEN

1. **`MEMORY.md`** lesen — der Index ist auf 19,0 KB verdichtet, **219 Links, 0 tote**. Er lag bei
   19,9 KB und lief auf das 24,4-KB-Leselimit zu; weiter zu kürzen hieße Links streichen, also
   Gedächtnis aufgeben. Wenn er wieder wächst: Hooks kürzen, **nie Links**.
2. **Die vier bindenden Dokumente VOLLSTÄNDIG kippen**, nicht anlesen. Der Wellenplan (970 Zeilen,
   123 KB) sprengt ein einzelnes `Read` — **drei Portionen à ~215 Zeilen**, sonst bricht das
   Token-Limit. Dazu die Lesefassung (241 Zeilen) als Einstieg.
3. **Ledger oben UND unten.** Oben stehen die Nachträge dieser Nacht (16.263 Zeilen). Unten, ab
   ~14.200, die Architektur-KERNe vom 08.08.: 3 Stufen/6 CEBs · 5 Mess-Ebenen · Experiment-B+-Baum
   als Vergleichsordnung · ein Paper = ein Experiment-XML · B-Spline B=3 · das Flattern als
   Hybrid-Signal · `checkpoint_measure`-Bauform C-1…C-14.
4. **`docs/sessions/2026080*` rückwärts**, mindestens die zwei Übergaben und die Erkenntnis-Session.
5. **Erst dann handeln.** Der Gedächtnis-Befund ist Pflicht VOR jedem Agentenstart und wird vom
   Lead erhoben, nicht vom Agenten (V2.1-Korrektur).

---

## II. DIE OWNER-KERNE DIESER NACHT — fünf, alle im Ledger, alle im Memory

### 1. Die Permutationen: 4 Mess-Ebenen im Hybrid ⇒ 4! neben den 6 CEBs

> „durch **4 Messebenen mit der Hybrid-Struktur** auch **4 fakultät** auch **3 fakultät CEB
> Systeme** … einmal gegen **mit Messfühler hybrid** und einmal **ohne** … es gibt also **4 fakultät
> Rekombinationen gegen die 6 CEBs** und den **Einbau von Messfühlern in die Hybrid-Tier-Binary**."

    SINGLE   3 Ebenen -> 3! =  6 CEB-Systeme
    HYBRID   4 Ebenen -> 4! = 24 Rekombinationen, gefahren GEGEN die 6
    dazu:    Messfühler IN der Hybrid-Tier-Binary — einmal MIT, einmal OHNE

Beide Zahlen gelten **nebeneinander**. Der Grund ist unverändert der vom 08.08.: **der Messfühler
ist ein Verbraucher**, die Differenz „mit/ohne" IST der Messfehler. Neu ist der Ort.

**OFFEN, nicht geraten:** ob die 24 die Fühler-Achse **enthalten** oder mit 2 **multiplizieren**
(= 48). Der Wortlaut nennt beides in einem Satz. Bei 41,4 h für 128 Binaries ist das kein Detail.

### 2. `work_mode` = build → measure → compare → release, und **debug ist ein FLAG**

Zuerst als „5 Begriffe, ein Enum" verstanden — **vom Owner korrigiert**:

> „Debug ist eher **als Flag entkoppelt**, als dass es **als State gleichrangig einsortiert** wird,
> denn es beeinflusst zwar die **Ausprägung** der States, aber **nicht ihr Verhalten der Reihenfolge
> oder Abhängigkeiten**. Es ist also ein **CLI-Flag auf der Planer-Shell**."

    STATE = hat Reihenfolge und Abhängigkeiten     FLAG = ändert die AUSPRÄGUNG, nicht die Stellung

    work_mode:  build -> measure -> compare -> release      VIER States, kumulativ
    --debug:    CLI-Flag der Planer-Shell, orthogonal, für Anwender GESPERRT

**Wozu debug da ist** (Owner-Schärfung): nicht-regelkonformes Messen in **JEDER Factory**, mit
**maximaler** Thread-Zahl, um in CI-Geschwindigkeit **hunderttausende bereits gebaute Binaries**
darauf zu prüfen, ob sie korrekte xlsx erzeugen und ablegen — *„egal wie genau die Messwerte sind"*.

    measure prüft die ZAHL   ·   debug prüft die KETTE

**Der Besitzer ist der PLANER** („diese 4 Modi sind Teil des Planers, denn er orchestriert den
CEB-Bau und deren Verwaltung"). Im Builder-Muster ist der **Director** die Instanz, die die
Reihenfolge bestimmt. Die Mess-Achse **trägt** den Automaten (binary_id-neutral), **besitzen** tut
ihn der Planer. Und er wird **einmal** gebaut — single und multi-hybrid sind symmetrisch.

**Am Objekt gefunden:** `RunMethodology` führt heute `{Debug, Measure, Release, Compare}`,
`kRunMethodologyCount = 4` — **`Build` fehlt** (`grep -c "Build," = 0`). Die Debug-Semantik ist
dagegen exakt die beschriebene und gebaut (`experiment_plan_director.hpp:2098`
„Debug={Debug,misst,parallel}"). **Die Jitter-Kopplung fehlt:**
`grep -c RunMethodology drift_detector.hpp` → **0**. Sie gehört ins SELBE Paket wie T-15+D4 (W2,
##36) — wer T-15 ohne die Ausnahme verdrahtet, macht jeden Debug-Lauf rot.

**Die Sperrform existiert bereits:** `AdmissionStatus {Zugelassen, Gesperrt}` in `axis_error.hpp`,
fail-closed („Unbekannt → gesperrt"), Prüfort `validate_profile.hpp` gegen die constexpr-Registry.

### 3. Die Hybrid-Meta-Meta-Achse gehört in die MESS-ZEILE — als FAMILIE

Die Mess-Achsen-Registry führt drei Achsen (`measurement_category` · `collector` ·
`load_framework`), alle `binary_id="never"`, alle `stage="ct"`. `MeasurementMetaMetaAxis` existiert
und hat **genau einen** Vertreter. **Die Einordnung war schon entschieden** — Owner-E2 vom 02.08.,
zitiert in `topics/organ_meta_meta_axis.hpp:4-7`: *„Da eine Meta-Meta-Achse immer zu den Mess-,
System- oder Organ-Achsen gehört, wird sie dynamisch ans Ende der Kette in den bestehenden Zeilen
angehängt."*

**Weil es multiple Reroute-Systeme geben kann, ist es eine FAMILIE** — je Genus eine Achse, nicht
eine einzelne `hybrid`. Alle stempeln in dieselbe Mess-Zeile; die Stempelzeile kann das bereits
(K7b-2 trägt eine MENGE).

**Die Spannung `binary_id="never"` gegen „einkompiliert" löst sich an zwei Binary-Sorten:**
`binary_id` identifiziert das **TIER**-Binary; die 6 bzw. 24 Varianten sind **CEB**-Binaries. Wer
beides gleichsetzt, kommt auf einen ABI-Bump, der nicht anfällt.

### 4. Die NO-SKRIPT-DOKTRIN gilt — Shell ist NIRGENDS ein Ersatz

> „Die **no-skript Doktrin und alles in C++ steht immer noch**. Den Anhang forwarden mit Shell ist
> **kein Ersatz für die C++-Implementierung — NIRGENDS**, das ist auch geplant."

**Der Bestand, erstmals mit Nenner:**

    super  38 Skripte · 16.246 Zeilen        ce  16 Skripte · 4.159 Zeilen
    ------------------------------------------------------------------------
    54 Skripte · 20.405 Zeilen Shell        (Memory führte "42 Skripte" — die Zahl wächst)

**Die Planung existiert** (Ledger `:4019`, #24 vom 12.07.): *„Increment 1 (**C++23
`08_appendix_generator`**, ersetzt den `.ps1`-Behelfsweg) … CI-grün/verifiziert; offen:
Inc-2-Pipeline-Verdrahtung, #25 (`format_tex.py`/`codegen.sh` → C++23)"*, dazu `:4163`
*„**CODE-Behelfswege löschen** — ausdrückliche Ausnahme zur nie-löschen-Regel."*

**Am Objekt bestätigt:** `Code/08_appendix_generator` existiert — 4 C++-Dateien, **1539 Zeilen**,
eigene CMakeLists, die CI baut ihn (8 Fundstellen). **Und `ci/anhang_forward_core.sh` ist mit 1665
Zeilen größer als der Generator, den es aufruft.** Was es tut — Transport, Commit, Recovery,
Kollisions-Lock — ist genau das, was der **Planer als Director** tut.

### 5. Der Wellenplan steht (aus der Vorgänger-Übergabe, weiter gültig)

Nur die **Streichliste** ist aufgehoben („wir streichen nichts"). Wellen, Reihenfolge-Zwänge,
Verifikations- und TDD-Vertrag, Abnahme-Regel, kritischer Pfad: **stehen**.

---

## III. WAS GELANDET IST

    ce     7c3d2934 → 9a4c4be0 → 2385e6ec → 2eb310ae → aebc4f2c     (15+2+3+1 = 21 Commits)
    super  24e00f54 → 545e9e70 → 85dc85e8 → 310ea9d3                ( 6+1+1    =  8 Commits)
    super  main      755dea35 → 85dc85e8                             ← der ERSTE main-FF des Tages

**ce trägt jetzt:** die drei Verify-bestätigten Pakete (w0a-Bauweg D1e→D1b→D1f→D1c · D4-Statistik-
Kette D4a→D4e · D5-5 HDR-Verdrahtung), die block_id-Klassenheilung (38 von 62 Aggregaten), den
`Boost::mp11`-Fix, sechs cf22-Dateien, 19 ABI-Pins, zwei uninitialisierte Member und den
axis_version-Lock-Regen.

**super trägt:** sechs Ledger-Nachträge mit den KERNen dieser Nacht, zwei Gitlink-Bumps mit
PZW-Ankern im selben Commit.

**Der main-FF war nicht überfällig, sondern regelkonform verspätet:** V3 verlangt den FF auf den
BELEGT grünen Stand, und den gab es erst mit super-Pipeline 15489 — **32 von 32 Jobs success, 0
skipped, 0 manual**. Die Jobliste wurde geprüft, nicht der Gesamtstatus; danach die
Ancestry-Gegenprobe.

---

## IV. DIE CI-KETTE DES ABENDS — und die eine Diagnose, die alles zusammenzog

    15482 (7c3d2934)   7 von 24 rot   ← Ausgangslage, seit 5 Pipelines rot
    15485 (9a4c4be0)   8 von 24       ← lint:format NEU: MEINE Regression
    15488 (2385e6ec)   6 von 24       ← mp11 + cf22 geheilt, keine neue
    15495 (2eb310ae)   1 von 24       ← 19 ABI-Pins + lint:static
    15498 (aebc4f2c)   0 von 24 rot, LÄUFT NOCH (test:unit, coverage-guard, build:clang offen)

**Die „fünf Wurzeln" aus Task #45 waren im Kern ZWEI.** Vier der fünf roten Jobs gingen auf **einen
ABI-Bump** zurück: `d4c0b49c` („feat(naht1)!", Major 8→9, Magic …382E→…392E) zog seine
Schwesterstellen in drei Klassen nicht mit — 19 `EXPECT_EQ(…ABI_MAJOR, 8)`, drei Doku-Anker auf
`:112` (das Magic steht auf 113), eine Identitäts-Bilanz-Kette, die bei 8.1 endete.

**Was mich darauf brachte, war kein Trace, sondern ein Testname**, der in allen drei roten Familien
auftauchte: `NeutralityGuardsStayIntact`. 20 Dateien tragen ihn, 19 waren rot — die zwanzigste
trägt die ABI-Zeile gar nicht und war als einzige grün. **Das war die Gegenprobe.**

**Der Bilanz-Test schreibt die Lehre aus dem VORIGEN Bump selbst auf:** *„Diese Fundstelle war beim
Bump übersehen worden — gefangen vom ctest-Doppellauf, nicht vom Decl-Header."* Genau das ist wieder
passiert. **Die Lehre stand im Code und hielt nicht, weil sie ein Kommentar war und kein Werkzeug.**

Lokal am Ende: **„100% tests passed, 0 tests failed out of 490"**, echtes `rc=0`.

---

## V. MEINE ARBEITSFEHLER — vier, alle dieselbe Wurzel (jetzt K14–K16 im Memory)

> **Die Messung lief korrekt und konnte nur nichts bewirken.** Nicht „vergessen zu prüfen" —
> geprüft und **wirkungslos**. Das ist die gefährlichere Variante, weil sie sich wie Sorgfalt anfühlt.

**K14 — der Exit-Code hinter `;` oder `|`.** Der Hintergrund-Merge-Test meldete `exit code 0`. Mein
Kommando: `sh script.sh; echo "rc=$?"` — das nachgestellte `echo` **wird** der Exit-Code. Wahr war
`rc=2`, **21 von 490 Tests rot**. Ohne die literale Log-Prüfung wäre auf einen als grün gemeldeten,
tatsächlich roten Stand gepusht worden. Dieselbe Figur nochmal hinter `| tail`.
→ **rc IMMER direkt nach dem Aufruf in eine Variable.** Und: eine Harness-Erfolgsmeldung ist eine
Behauptung wie jede andere.

**K15 — der Gate-Umfang ist nicht der Änderungs-Umfang.** cf22 lief über die **12 Dateien, die ICH
angefasst hatte**; der Landungsbereich hatte **25**, sechs davon aus fremden Paketen unformatiert.
Folge: `lint:format` wurde die **einzige** Regression der Sammellandung.
→ **`git diff --name-only <basis>..HEAD`**, nie die eigenen Dateien. Der Nenner hätte es sofort
entschieden: 12 von 25.

**K16 — Prüfung und Handlung im SELBEN Kommando.** Die R4-Prüfung stand mit dem `git push` in einem
Bash-Aufruf. Antwort: `15486 running` — und der Push lief trotzdem. Folge: **zwei Pipelines parallel
auf demselben Ref**. Abbrechen ist verboten.
→ **Ein Gate, das die Handlung nicht verhindern KANN, ist kein Gate, sondern Zierde.**

**K17 (neu, hier nachgetragen) — der Monitor, der still hängt.** Mein erster Pipeline-Monitor suchte
mit `per_page=1` nach der Ziel-SHA; die war zum Startzeitpunkt noch nicht die neueste, `select`
lieferte leer, die Schleife fragte nie etwas ab und **meldete nichts**. Der Owner musste ihn melden.
→ **Monitore fail-closed bauen:** leere Abfrage ⇒ Meldung, nicht Stille. Feste ID statt Suche.

**Und ein fünfter, der keine Wurzel teilt:** ich habe eine **korrekte** Messung verworfen, weil der
Owner widersprach. `git cherry` sagte, zehn Branches seien inhaltlich gelandet; ein Dateivergleich
zeigte einen Unterschied, ich knickte ein — und wäre losgezogen, zehn längst gelandete Branches
erneut zu mergen. Der Unterschied kam daher, dass `development` die Datei **seither** weiterentwickelt
hat. **Prüfung 5: die neue Aussage so hart prüfen wie die alte** — auch wenn die Korrektur von oben kommt.

---

## VI. DER WORKTREE- UND BRANCH-BESTAND (gemessen, nicht geschätzt)

**14 Worktrees, alle `dirty=0`, alle mit gelandetem HEAD.** `wt-landcheck` ist kein Git-Baum.

**Aber:** 15 lokale Branches waren nicht in `development`. Per Subject-Deckung geprüft:

    ce     8 Branches, 32 von 32 Commits inhaltlich GELANDET   (Karteileichen)
    super  2 Branches,  2 von  2                    GELANDET
    super  b-e18-snap:  0 von 3                     ► ECHT OFFEN
    4× backup/*  — Sicherungen, keine Landungskandidaten (+1386…+1958)

**Die zehn zeigen `+N`, weil ihre Commit-OBJEKTE fehlen — ihr INHALT liegt unter anderer SHA drin.**
Musterfall `b-m3v2-pmc-window`: derselbe Fix als `2b5ecd29`, identische Nachricht.

---

## VII. E-18-SNAP — gemergt, NICHT gepusht, und warum

`landung/e18-snap` in `wt-super-landung` (**dc2ac470**, 4 Commits, sauber). Der Merge ist
**inhaltlich heil**: konfliktfrei, 532+1133 = 1665 Zeilen (beide Seiten drin), und die drei Wachen
des Kanals sind grün **mit gefahrenem Selbstbiss** — `anhang_forward_probe` **6 von 6**,
`durchstich_bissprobe` **4 von 4**, `tests_registrierung_wache` **12 von 12**.

**Zwei unabhängige Gründe gegen die Landung, jeder allein hinreichend:**

1. `lint:diff-hygiene` **rot** (rc=1): 61 Zeilen über 120 Spalten im geprüften Scope von 2179,
   **16 neu durch das Paket**. **Keine davon ist ein Kommentar**; 18 von 19 im Kern sind
   `echo`/`printf` — deren Ausgabe ist der Prüfgegenstand der Proben, ein Umbruch bricht sie.
2. **Der No-Skript-KERN.** +1133 Zeilen Shell-Orchestrierung sind ein Schritt in die falsche
   Richtung, unabhängig davon, wie gut sie bewacht sind.

**Die Substanz ist nicht verloren, sie ist das Pflichtenheft der C++-Fassung:** eindeutige Namen,
Recovery-Identität, Beleg-Validator, erzwungene Re-Kompilation, transaktionales Schreiben,
Kollisions-Lock — sechs Eigenschaften, in Shell erarbeitet und mit beißenden Mutanten bewacht.

**Owner-Entscheid offen:** landet es als Zwischenstand (dann 61 Zeilen heilen) oder wartet es auf
die Planer-Fassung?

---

## VIII. OFFENE OWNER-VORLAGEN (Tasks #44 · #45 · #46)

| # | Gegenstand | Kern |
|---|---|---|
| **#46** | **Magic-Wechsel-Konflikt** | NAHT-1 hat am 09.08. Major **und** Magic gebumpt. Der Wellenplan reserviert *„genau EIN Magic-Wechsel im Gesamtfenster"* für Mo 24.08. Ist das Kontingent verbraucht, oder meint „4→5" eine andere Größe als 8→9? **Eine NULL-Bump-Wache existiert nicht** (0 Treffer) — der Bump war durch nichts gesperrt. |
| **#44** | **-Wall fehlt auf 358 von 569 TUs** | Belegt durch die block_id-Klasse: 38 Vorkommen im Baum, **2 gemeldet** — die anderen 36 lagen in TUs ohne Warnstufe. Stufenplan vorgeschlagen, `-Werror` zuletzt. |
| **#43** | clang-Runde 2 | `build:clang` war in 15447 **skipped**; vor der Runde ist zu klären, unter welcher Bedingung er fährt. |

**Dazu unverändert:** 24 oder 24×2=48 · die Trägerachse der Permutations-Unterachse (Kandidat
`MeasurementTooling {WallClock,Macro,Micro}`, count=3 — **3 Ebenen ⇒ 3! = 6 fällt damit zusammen**) ·
die konkrete Entwickler-Bedingung für `--debug`.

**Und ein Bau-Posten, der aus Nr. 4 folgt:** es gibt **keine Wache, die bei einem ABI-Bump alle Pins
einsammelt**. Vorschlag: lebenden Major/Magic aus `anatomy_module_abi_v1_decl.hpp` lesen und jede
literal pinnende Stelle dagegenhalten — Tests, Doku-Anker, Bilanz-Ketten, Nenner in der Ausgabe.
Dieselbe Erhebung deckt ab dem 24.08. die NULL-Bump-Regel, nur mit anderer Schwelle.

---

## IX. DER ERSTE HANGRIFF

**1. Das GOAL SET beginnen** (Teil ganz oben). Reihenfolge nach Arbeitsweise:
   Gedächtnis (diese Übergabe + MEMORY) → die vier Dokumente kippen → **SOLL-IST-Erhebung je Welle**
   als erster Workflow (Explore, Sonnet 5 max, „very thorough") → dann Design → dann Bau.
   **Nicht mit dem Bau anfangen** — der Stand je Welle ist heute nur teilweise erhoben:

       W-1   Landung + Bauweg-Wahrheit    heute weitgehend vollzogen
       W0a   D1e/D1b/D1f/D1c GELANDET (84672350) · D2-G1, D2, D2-G2/G3/G6, ##06/##07 OFFEN
             D5-1 Perzentil-Kanon: Commit-Suche mehrdeutig — GEGENPRÜFEN, nicht annehmen
       W0b   D3-7/D3-1/D3-8 gelandet (028684ac) · DURCHSTICH ##25 = F1 am 14.08. OFFEN
       W1    HY-A, D4-Rest, Menge — der 99-h-Engpass, unangetastet

**2. Die ce-Pipeline 15498 zu Ende sehen.** Beim Kontextende: **0 von 24 rot**, aber `test:unit`,
   `test:coverage-guard` und `build:clang` liefen noch. **Wird sie grün, ist ce zum ersten Mal seit
   sechs Läufen sauber — dann ist dort der main-FF fällig** (V3: auf den gepinnten SHA, volle SHA,
   nie über HEAD; Jobliste prüfen, nicht Gesamtstatus).

**3. Danach: Gitlink-Bump in super auf `aebc4f2c`** samt PZW-Anker im SELBEN Commit — sonst ist der
   Zwischenstand rot. Die drei Mengen-Anker standen bei den letzten vier Zügen still (33/19/1,
   Nenner 479); **trotzdem neu erheben, nicht übernehmen.**

**4. E-18-SNAP entscheiden** (Teil VII) — Owner-Vorlage, kein Lead-Entscheid.

---

## X. DER SATZ, DER ÜBER ALLEM STEHT

Aus der Vorgänger-Übergabe, heute Nacht viermal bestätigt:

> **Die teuersten Fehler waren nicht falsche Messungen — es waren richtige Messungen an der
> falschen Sache.**

Heute kommt eine Schärfung dazu, aus K14–K17:

> **Und die zweitteuersten sind richtige Messungen an der richtigen Sache, die zu spät kommen,
> zu eng greifen oder die Handlung nicht stoppen können.**
>
> V11 sagt: die Messung muss älter sein als der Satz. Eine Ebene tiefer gilt: **sie muss auch früher
> sein als die Handlung — und sie muss sie verhindern können.** Ein Gate, das nur meldet, ist Zierde.

**Rate nie.** Jeder Nichtfund braucht eine Gegenprobe, jede Autorität ein Zitat, jede Zahl einen
Nenner in der Ausgabe. Und wenn eine Korrektur von oben kommt: **sie ist eine Behauptung wie jede
andere** — heute wäre ich sonst losgezogen, zehn längst gelandete Branches erneut zu mergen.

---

## 11. NACHTRAG kurz vor Kontextende: warum super/development rot ist -- und warum der Gitlink-Bump es NICHT heilt

Beim Landen dieser Uebergabe wurde R4 geprueft und dabei ein Rot gefunden, das die
Reihenfolge fuer morgen umdreht. Der Befund ist vollstaendig gemessen, nichts davon geraten.

### Der Widerspruch, der ihn ausgeloest hat

super-Pipeline **15496** auf `310ea9d3` hat Status **failed** -- aber:

```
eigene Jobs:  32 success, 0 failed
```

Zweiunddreissig von zweiunddreissig gruen, und die Pipeline trotzdem rot. Aufloesung: die
Jobliste unter `/pipelines/<id>/jobs` **enthaelt keine Bridges**. Die Rot-Quelle war ein
Trigger-Job, den diese Abfrage schlicht nicht zeigt:

```
BRIDGE: trigger:cache-engine = failed / child 15497 : failed
```

**Methodenlehre daraus:** die Jobmenge einer Pipeline mit Trigger-Jobs ist
`/jobs` **UNION** `/bridges`. Wer nur `/jobs` zaehlt, misst an einer Pipeline mit
downstream-Kindern strukturell zu wenig -- und sieht ein sauberes 32/32, waehrend die
Pipeline rot ist.

**Gegenprobe zum main-FF von gestern:** der Anker `85dc85e8` (Pipeline 15489) wurde
nachtraeglich auf seine Bridge geprueft -- `trigger:cache-engine = success / child 15490 :
success`. Der main-FF war also **gedeckt**. Die Deckung hielt, aber die Methode war
schwaecher als ihr Ergebnis: sie haette dasselbe Urteil auch bei roter Bridge gefaellt.

### Die eigentliche Kette

Das rote Kind 15497 lief auf ce `8fcf0c0e`. Der Gitlink in super/development zeigt aber auf
`2eb310ae`. Zwei verschiedene SHAs -- also faehrt der Trigger **nicht** den vendorten Stand.
Nachgelesen in `.gitlab-ci.yml:1002-1005`:

```yaml
  trigger:
    project: comdare/research/comdare-cache-engine
    branch: main                 # <-- HIER
    strategy: depend
```

Gegenprobe: `ce/main == 8fcf0c0e` -- **exakt** der SHA des Kindes. Kette geschlossen.

| Ref | SHA | Abstand zur ce-Spitze |
|---|---|---|
| ce/development (Spitze) | `aebc4f2c` | 0 |
| Gitlink in super | `2eb310ae` | 1 |
| **ce/main** = was der Trigger faehrt | `8fcf0c0e` | **86** |

Der einzige rote Job im Kind war **`pmc:intel [build]`**. Und derselbe Job in derselben
Rolle, nur auf der Spitze:

| Pipeline | ce-SHA | `pmc:intel` |
|---|---|---|
| 15497 | `8fcf0c0e` (= main) | **failed** |
| 15498 | `aebc4f2c` (= development) | **success** |

Der Fix liegt also in den 86 Commits, die main noch fehlen.

### Was daraus fuer morgen folgt -- die Reihenfolge dreht sich

Bisher stand in der Liste "Gitlink-Bump in super auf `aebc4f2c`". Das ist **nicht** das
Heilmittel: das changes-Gate (`Code/external/comdare-cache-engine`) sorgt zwar dafuer, dass
ein Gitlink-Bump den Trigger ueberhaupt feuern laesst -- gefahren wird danach trotzdem
`branch: main`. Ein Bump ohne main-FF erzeugt also nur dasselbe Rot noch einmal.

Die richtige Ordnung:

1. **ce 15498 zu Ende sehen.** Stand bei Kontextende: 21 success, 2 running
   (`test:unit`, `test:coverage-guard`), 1 manual (`is_original:relock`) -- **0 rot**.
2. **ce main-FF auf `aebc4f2c`** -- reiner Fast-Forward ist verifiziert
   (`merge-base --is-ancestor origin/main origin/development` = ja, 86 Commits).
   Als `push origin <VOLLER-SHA>:refs/heads/main`, nie als `rev-parse HEAD`.
3. **Danach** Gitlink-Bump in super samt PZW-Anker im selben Commit. Jetzt faehrt der
   Trigger einen Stand, in dem `pmc:intel` gruen ist -- super wird von selbst gruen.

Punkt 2 vor Punkt 3. Umgekehrt ist es ein Leerlauf mit rotem Ergebnis.

### Noch offen an diesem Faden

`is_original:relock` steht auf **manual** -- ein Handschalter im Contract-Stage. Ob er fuer
"gruen" gezogen werden muss oder bewusst offen bleibt, ist nicht gemessen und darf morgen
nicht geraten werden. Erst nachschlagen, wofuer er da ist, dann entscheiden.
