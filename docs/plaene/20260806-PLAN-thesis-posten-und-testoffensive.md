# PLAN 06.08.2026 -- THESIS-POSTEN VOR DER ABGABE + PRIORISIERTE TESTOFFENSIVE

**Zweck.** Zwei Straenge, die vor Fr 08.08. zusammenlaufen: (A) was am ABGABE-DOKUMENT
noch zu tun oder zu entscheiden ist, mit **O-4 entscheidungsreif** aufbereitet und den
**Abgabe-Risiken** je mit Datei:Zeile -- (B) der **priorisierte Testplan mit Bissen**.
Am Ende steht Teil C: die ehrliche Frist-Aussage.

**Status: PLANUNGS-DOKUMENT. Nichts hierin ist gebaut, nichts committet.**
Diese Erhebung war read-only: keine Edits ausser dieser Datei, kein Commit, kein Worktree
beruehrt.

---

## 0. OBJEKTSTAND DIESER ERHEBUNG (jede Zahl selbst am Objekt erhoben)

    super  development  f874c9eb   (Beginn der Erhebung)
    ce     Submodul-Pin e7aa1244   (Zeiger == Checkout)
    thesis Submodul-Pin 8970465d   (Zeiger == Checkout, kein Drift)
    prt-art Submodul-Pin c6f07540

Letzter Ledger-Nachtrag: **nachmittag-10** (LEDGER:4202 ff.). Sieben gruene Pipeline-Laeufe
ueber beide Repos und beide Zweige, `main`-FF in beiden vollzogen, Thesis Gate 8 gelandet
(LEDGER:4243-4247, :4327-4335).

### 0.1 NACHTRAG WAEHREND DER ERHEBUNG -- der Stand ist unter mir weitergelaufen

Zwischen Beginn und Abschluss dieser Erhebung hat eine **parallele Linie** gearbeitet.
Am Objekt gemessen, nicht vermutet:

    super  development  f874c9eb  ->  72eab9ae   (4 Commits)
    ce     Submodul-Pin e7aa1244  ->  47c4ef1d   (A1-NB2 gelandet)
    thesis Submodul-Pin 8970465d  ==  8970465d   (unveraendert, Zeiger == Checkout,
                                                  Distanz 0 in BEIDE Richtungen geprueft)

- `b00638f2` + `c911c2fb`: acht Plan-/Analysedokumente des 06.08. versioniert.
- `b00638f2` woertlich: *"ce-Gitlink auf 47c4ef1d -- A1-NB2 Wurf-Vertrag + 2.
  Versions-Bump, ce-Pipeline 15043 gruen (test:unit 409, **Abdeckungswache 411/411**)"*.
  **Damit ist die 407/407 aus B.0 ueberholt: der Nenner steht jetzt bei 411.**
- `72eab9ae`: *"thesis/diplomarbeit auf 8970465d nachgezogen -- die CI baute die ALTE
  Fassung"* -- betrifft das **zweite** Thesis-Submodul (`thesis/diplomarbeit`), nicht
  `Code/external/20260931-overleaf-diplomarbeit`.
- **Im Thesis-Submodul liegen 16 uncommittete Dateien** (`git status --porcelain` im
  Submodul), **+74 Zeilen, 0 Loeschungen** -- reine Kopf-Kommentare. Das ist die laufende
  Bearbeitung von **R-T5** durch die Parallel-Linie; siehe die Korrektur dort.

**Alle Befunde dieses Plans wurden am Stand `f874c9eb` / thesis `8970465d` erhoben.**
`8970465d` ist unveraendert, die Thesis-Befunde (Teil A) stehen damit unberuehrt. Die
ce-seitigen Test-Befunde (Teil B) sind gegen `e7aa1244` erhoben; `47c4ef1d` betrifft A1
(Allokator), keine der in B.1 genannten Stellen -- **aber das ist eine Ableitung aus der
Commit-Botschaft, keine Nachmessung.** Wer T-1/T-2 baut, misst zuerst gegen `47c4ef1d`.

**Methodik-Ausweis (Regel 6 auf mich selbst angewandt).** Alles unten Behauptete ist am
Objekt gelesen, nicht aus Zuarbeit uebernommen -- ausser wo ausdruecklich `[BERICHT]` steht.
Ein zweites Lens (Codex, Thread `019fd87c`) hat drei Kernbehauptungen unabhaengig
gegengeprueft; wo es meine Lesart korrigiert oder geschaerft hat, steht das mit `[CODEX]`.
**Codex hat KEIN `git` ausgefuehrt.**

---

# TEIL A -- DIE THESIS-POSTEN VOR DER ABGABE

## A.0 Was am Abgabe-Dokument HEUTE steht

**Die Thesis baut, hart belegt** (nicht selbst nachgefahren, aus dem CI-Trace des
Gate-8-Laufs, LEDGER:4516-4523): `diplomarbeit-de.pdf` **202 Seiten / 919275 Bytes**,
`diplomarbeit-en.pdf` **192 Seiten / 885362 Bytes**, je
`LaTeX-Warnings=0 (erlaubt <=1)` und `BibTeX .blg Warnings/Repeated=0`.

**Aktiv kompiliert werden genau 6 Kapitel + 6 Anhaenge** (`diplomarbeit.tex:280-295`):
`01_einleitung`, `02_suchbaeume_grundlagen`, `03_messsystem_prtart`, `04_implementierung`,
`05_evaluation`, `06_fazit`; Anhaenge A-F. Das ist wichtig fuer alles Folgende: der Baum
enthaelt **14 `.tex`-Kapiteldateien je Sprache, von denen nur 6 im PDF landen** (selbst
gezaehlt: `ls kapitel/de/*.tex` = 14 Dateien).

**Anhaenge B und E sind KEINE Stubs mehr.** Der alte Ledger-Vermerk (LEDGER:267,
"nur 4-Zeilen-Stubs") ist ueberholt: `anhang/de/B_code_structure.tex` = **257 Zeilen**,
`anhang/de/E_architecture_decisions.tex` = **151 Zeilen**, EN entsprechend 256/153. B traegt
eine echte, datierte Verzeichnis-Erhebung (`B_code_structure.tex:1-12`, Stichtag 2.8.2026,
drei benannte Commits). **Damit ist der Abgabe-Blocker "leere Anhaenge B/E" erledigt** --
das gehoert in den Ledger, weil V-02 ihn noch als offen fuehrt (LEDGER:5147).

---

## A.1 O-4 -- ANHANG-A-REICHWEITE: OWNER-ENTSCHEID, ENTSCHEIDUNGSREIF

### A.1.1 Die Frage, so wie sie gestellt wurde

Quelle des Postens, woertlich, **LEDGER:5149** (Nachtrag mittag-19):

> "12 weitere Posten gehoeren nach der Abgabe (V-04 Auswertungs-Writer M-8/M-9/M-15 --
> ACHTUNG: **Anhang A DE+EN haengt daran**, falls er in die Abgabe soll, rutscht V-04 hoch
> = OWNER-ENTSCHEID; ..."

Als offener Posten gefuehrt in **LEDGER:5042** ("O-4 Anhang-A-Reichweite (Owner)") und im
juengsten Fahrplan **`docs/sessions/20260806-FAHRPLAN-hauptstrang-landung.md:512**
("O-D -- O-4 Anhang-A-Reichweite", unter Abschnitt 5 "Braucht einen OWNER-ENTSCHEID").

**Der juengste Ledger-Nachtrag (nachmittag-10, LEDGER:4202-4542) nennt O-4 nicht.** Es gibt
also keinen Beleg fuer eine Aufloesung -- der Posten ist zum Stand der letzten Ledger-Zeile
unentschieden.

**NAMENSKOLLISION, damit sie niemanden in die Irre fuehrt:** In
`Code/external/comdare-cache-engine/.gitlab-ci.yml:426` steht ein anderes "O-4"
(`contract:axis-version-lock (GN-8/O-4 ...)`) und in **LEDGER:3576** noch ein drittes
(O-4 Maschinen-Identifikation). Gemeint ist hier **ausschliesslich** die
Anhang-A-Reichweite.

### A.1.2 Der Ist-Stand, mit Zahlen (selbst gezaehlt, beide Sprachen)

`anhang/de/A_measurements.tex` = 237 Zeilen, `anhang/en/A_measurements.tex` = 233 Zeilen.
Je Sprache bindet der Anhang **44 Fragmente** ein. Aufteilung identisch in DE und EN:

| Einbindungsart | Anzahl | Datei existiert | Datei fehlt |
|---|---|---|---|
| `\input{...}` (hart, ohne Fallback) | 16 | **16** | 0 |
| `\InputIfFileExists{...}` (weich, mit Platzhalter-Text) | 28 | 0 | **28** |
| **Summe** | **44** | **16** | **28** |

**Die 16 vorhandenen tragen echte Daten** -- keine leeren Geruester (Bytes selbst gemessen):

    v5_pipeline_demo_table.tex        19 Z /   692 B      cartesian_smoke43_table.tex    56 Z /  2818 B
    v5_pipeline_demo_diagram.tex       7 Z /   280 B      cartesian_smoke43_diagram.tex   7 Z /   282 B
    bias_matrix_table.tex             20 Z /  1856 B      le_limitierung.tex             36 Z /  4549 B
    lc_surface_ns_per_op.tex         116 Z /  4010 B      lc_surface_op_insert_p50_ns    116 Z /  3834 B
    lc_surface_op_lookup_p50_ns      116 Z /  3840 B      lc_surface_op_erase_p50_ns     116 Z /  3470 B
    lc_surface_op_scan_p50_ns        108 Z /  3172 B      lc_surface_op_rmw_p50_ns       116 Z /  3480 B
    ld_exchange_search_algo.tex       58 Z /  4892 B      ld_exchange_node_type.tex      59 Z /  7116 B
    ld_exchange_memory_layout.tex     83 Z / 17855 B      ld_exchange_prefetch.tex       59 Z /  6673 B

**Die 28 fehlenden zerfallen in zwei Gruppen:**

- **23 Abbildungen des Graph-Umbaus (Gate 8, heute eingebunden):** `lc_surface3d_*` (6),
  `lc_surface_ratio_*` (6), `lc_normbar_*` (6), `ld_sweep_*` (3), `latency_tradeoff`,
  `exchange_forest_vs_reference`.
- **5 aeltere, seit #24 vorgesehene Darstellungen:** `seg_attribution`, `observer_detail`,
  `latency_range`, `latency_ecdf`, `exchange_forest`.

Alle 28 sind ueber `\InputIfFileExists{...}{}{...Platzhaltertext...}` gegatet: **sie
erscheinen nicht im PDF und die Kompilation bricht nicht.** Das ist der Grund, warum die
Thesis heute gruen baut, obwohl 64 Prozent der deklarierten Fragmente fehlen.

**Die ehrliche Limitierungs-Tabelle steht bereits und ist gut**
(`anhang/de/tabellen/le_limitierung.tex`, 15 nummerierte Vorbehalte). Zeile 1 nennt die
Kernmetrik-Luecke woertlich: *"Cache-Misses (Kernmetrik): L1/L2/L3 + dTLB + Coherence +
Energy = 0 / nicht erhoben"*; Zeile 2 nennt *"15 gepinnte Achsen = 0
Austauschbarkeits-Belege ... Nur 4 Achsen variieren (search_algo, node_type, memory_layout,
prefetch)"*. **Das ist der Massstab, an dem O-4 zu messen ist: Anhang A ist heute schon
ehrlich -- er ist nur klein.**

### A.1.3 Die zwei Wege und was jeder kostet

**WEG 1 -- Anhang A bleibt so, wie er ist (16/44, Smoke-Reihe + ehrliche Limitierung).**

- *Kosten:* NULL. Keine Landung, kein Bau, kein Messlauf.
- *Konsequenz fuer V-04:* V-04 (Auswertungs-Writer M-8/M-9/M-15) bleibt **nach** der Abgabe,
  wie in LEDGER:5149 vorgesehen. Der kritische Pfad zum Trigger
  (FAHRPLAN:377-391) bleibt unberuehrt.
- *Was die Arbeit dann zeigt:* eine reale, aber kleine Messreihe (43 Permutationen, 4 von
  19 Achsen variiert) plus ein **vollstaendig gebautes Auswerte- und Darstellungsgeruest**,
  dessen 28 leere Plaetze im PDF unsichtbar bleiben.
- *Das Risiko:* keines am PDF. Das Risiko liegt im **Text**, nicht im Anhang -- siehe A.2.
- *Der Preis:* die Kern-These der Arbeit (Achsen-Bibliothek als Beitrag) wird durch 4
  variierte Achsen belegt, nicht durch 18.

**WEG 2 -- Anhang A wird mit echten Daten gefuellt (44/44).**

- *Kosten:* V-04 rutscht VOR die Abgabe **und** haengt an einem erfolgreichen Voll-Messlauf,
  der wiederum an O-A haengt (Bau-Matrix) und an O-E (Phase-6-GO). Das ist eine Kette von
  drei Owner-Entscheiden plus einem mehrstuendigen bis mehrtaegigen Lauf.
- *Konsequenz:* der kritische Pfad zum Trigger (FAHRPLAN:377-391, sieben Posten) muss
  vollstaendig durch, DANN der Lauf, DANN die Writer, DANN die Einbindung, DANN ein
  PDF-Gate. Bei Abgabe Fr 08.08. und Trigger-Ziel Do 07.08. ist das ein Ein-Versuch-Pfad
  ohne Puffer.
- *Der harte Blocker davor:* die Laufzeit der Bau-Matrix ist **nicht gemessen** und die drei
  vorliegenden Zahlen widersprechen einander um Faktor 4 bis 16 (siehe A.2, Risiko **R-T1**).
  Solange diese Zahl nicht steht, ist Weg 2 nicht planbar, sondern eine Wette.

**WEG 2b -- Teilfuellung (nur die 5 alten #24-Darstellungen, die 23 Gate-8-Abbildungen
bleiben leer).** Technisch moeglich, aber unehrlich: der Anhang wuerde dann zwei
Datenstaende mischen, ohne dass der Leser die Naht sieht. **Nicht empfohlen** -- er
verletzt genau die Doktrin, der `le_limitierung.tex` seine Existenz verdankt.

### A.1.4 EMPFEHLUNG (Lead)

**WEG 1 -- Anhang A bleibt bei 16/44, mit EINER textlichen Auflage.**

Begruendung, in dieser Reihenfolge:

1. **Weg 2 ist nicht terminierbar, solange R-T1 offen ist.** Eine Entscheidung fuer Weg 2
   waere eine Entscheidung ueber eine Laufzeit, die niemand kennt -- genau die Klasse, die
   der Fahrplan selbst als unzulaessig markiert (FAHRPLAN:424-425: *"Der Unterschied
   zwischen 'geht' und 'geht nicht' haengt an einer Zahl, die niemand gemessen hat."*).
2. **Weg 1 ist bereits ehrlich.** `le_limitierung.tex` benennt jede Luecke einzeln; die
   Kapitel 5 und 6 nennen den Zustand als Zustand (siehe A.2, "was kein Risiko ist"). Der
   Anhang luegt nicht -- er ist klein.
3. **Der billigste echte Gewinn liegt nicht im Anhang, sondern im Text.** Die drei Risiken
   R-T1/R-T2/R-T3 in A.2 kosten zusammen unter einer Stunde und beseitigen genau das, was
   O-4 eigentlich meint: dass der Text mehr verspricht, als der Anhang einloest.

**Die Auflage (Pflichtteil der Empfehlung, ohne sie ist Weg 1 nicht sauber):** wenn Anhang A
bei 16/44 bleibt, muss **eine 16. Zeile in `le_limitierung.tex`** stehen, die den
Deklarations-Ist benennt: *"Von den 44 im Anhang deklarierten Darstellungen sind 16 mit
realen Messwerten belegt; 28 bleiben leer und sind im PDF ausgeblendet -- ihre Datenbasis
ist der ausstehende Voll-Messlauf."* Damit ist die Luecke **im Dokument** dokumentiert und
nicht nur im Ledger. Aufwand: eine Tabellenzeile DE + EN.

**Was der Owner entscheiden muss, in einem Satz:**
*Soll Anhang A mit 16 von 44 belegten Darstellungen plus expliziter Luecken-Zeile in die
Abgabe (V-04 bleibt danach), oder soll V-04 vor die Abgabe gezogen werden -- wissend, dass
das an O-A, O-E und einer ungemessenen Bau-Laufzeit haengt?*

---

## A.2 DIE ABGABE-RISIKEN: WO DER TEXT MEHR VERSPRICHT ALS DIE MESSUNG LIEFERT

Sechs Befunde, nach Schwere sortiert. Alle Zeilen selbst nachgelesen. Pfade relativ zu
`Code/external/20260931-overleaf-diplomarbeit/` bzw. zum super-Wurzelverzeichnis.

---

### R-T1 [SCHWER] Drei Quellen nennen drei verschiedene Bau-Mengen -- und die Kappung, auf die sich der Fahrplan stuetzt, wird nicht gelesen

**Das ist der schwerste Befund dieser Erhebung. Er trifft nicht nur den Text, sondern
O-A selbst.**

**Was der Thesis-TEXT sagt** -- `kapitel/de/05_evaluation.tex:94-101`, woertlich:

> "Je System-Permutation ... werden die $2^{17} = 131072$ Organ-Permutationen des
> kanonischen Vermessungs-Katalogs gebaut ... im Stand dieser Arbeit deklariert es vier
> (zwei Optimierungsstufen mal zwei SIMD-Stufen)"

Ausgerechnet: **4 x 131072 = 524288 Tier-Binaries.** Der Faktor `line_size` kommt im Text
nicht vor.

**Was die XML sagt** -- `Code/test_data_xml/experiment_golden_kern.xml:285`, woertlich:

> "line_size 4  x  system 4  x  N 131072  =  2097152 Tier-Binaries."

**Was der FAHRPLAN rechnet** -- `docs/sessions/20260806-FAHRPLAN-hauptstrang-landung.md:412-422`:
er nimmt **131072** als Gesamtzahl, teilt durch 24 Worker und kommt auf 7,6 h bis 45,5 h.

**Drei Zahlen: 131072 / 524288 / 2097152. Faktor 16 zwischen der kleinsten und der
groessten. Keine davon ist gemessen.**

**Und jetzt der Teil, der die Kappung betrifft** (`[CODEX]`, von mir am Objekt
nachverifiziert):

- Die XML behauptet in ihrem eigenen Kommentar
  (`experiment_golden_kern.xml:157-158`), `<run_options cap="131072"/>` beziffere
  *"dasselbe N als harte max_binaries-Obergrenze (xml_config_parser.hpp:193)"*.
- **Die Wurzel dieser Datei ist `<comdare_experiment ...>`**
  (`experiment_golden_kern.xml:77`).
- **`run_options` wird ausschliesslich im ANDEREN Dialekt gelesen:**
  `xml_config_parser.cpp:424-432` liegt innerhalb von `parse_thesis_profile`
  (beginnt `:266`); `parse_experiment_profile` beginnt `:443-444`, prueft
  `root->tag != "comdare_experiment"` und enthaelt zwischen `:443` und `:580`
  **keinen einzigen Treffer** auf `run_options` oder `cap` (selbst gegrept, Ergebnis leer).
- **Folge: `cap="131072"` in dieser Datei ist dekorativ. Der Parser ignoriert das
  Attribut still.**
- Die einzige andere Quelle fuer `max_binaries` ist die Env `COMDARE_E4_CAP`
  (`Code/02_messung_driver/main.cpp:1226` und `:1287`) -- **nirgends im Repo gesetzt**
  (exhaustiv gegrept). Und ihre Semantik ist eine andere:
  `profile_run_facade.hpp:172` sagt woertlich *"0 => alle Paesse; sonst Cap auf die Zahl
  der SOTA-Paesse (Smoke)"* -- also ein Cap auf SOTA-Paesse, **nicht** auf die
  Tier-Binary-Matrix.

**Was die Menge WIRKLICH pinnt** (selbst gefunden, und es ist die Entwarnung):
`.gitlab-ci.yml:79` im super setzt `COMDARE_GN_TOTAL: "131072"` und reicht sie an die
Child-Pipelines weiter (`:1213`, `:1236`). Der Code-Default ohne diese Variable ist
**16** (`experiment_plan_director.hpp:1207-1208`, `:1367`:
`"${COMDARE_GN_TOTAL:-16}"`, Kommentar woertlich *"Default 16 = sicherer Serie-Test;
Voll-Bau: COMDARE_GN_TOTAL=131072"*).

**Die entscheidende, ungeklaerte Stelle:** `COMDARE_GN_TOTAL` ist ein Fenster **je
System-Permutation**, nicht global. Woertlich, `experiment_plan_director.hpp:989-990`:
*"iteriert INTERN alle der Lane zugeteilten System-Perms; **je Perm** laeuft er das
`[0,COMDARE_GN_TOTAL)`-Fenster in kGnBatchSlice-Scheiben"* (deckungsgleich `:1152-1153`).
**Damit ist die Fahrplan-Rechnung "131072 gesamt" mit hoher Wahrscheinlichkeit zu klein --
um mindestens den Faktor der System-Perms.** Ob der `line_size`-Faktor 4 zusaetzlich
multipliziert (=> 2097152) oder ob das Fenster ihn abschneidet (=> 524288, und drei Viertel
des line_size-Raums werden still nie gebaut), **ist aus keiner der gelesenen Quellen
entscheidbar.**

**KONSEQUENZ, doppelt:**

1. **Fuer den Text:** `05_evaluation.tex:94-101` nennt eine Soll-Menge, die die
   Trigger-Input-Basis widerspricht. Es steht `524288` gegen `2097152` in der XML, die der
   Fahrplan selbst als *"die Trigger-Input-Basis (Owner-KERN A7)"* fuehrt (FAHRPLAN:386).
   Eine Diplomarbeit, deren Soll-Umfang um Faktor 4 vom Apparat abweicht, ist an genau der
   Stelle angreifbar, die sie als Kernbeitrag fuehrt.
2. **Fuer O-A:** die Owner-Entscheidung ueber die Bau-Matrix wird derzeit auf Basis einer
   Zahl vorbereitet (131072), die nicht die Gesamtzahl ist. **Der Fahrplan verlangt eine
   Kalibrier-Stichprobe fuer die ZEIT (FAHRPLAN:427-430) -- er braucht zuerst eine fuer die
   MENGE.**

**FIX (zwei Schritte, der erste ist ein Test, siehe Teil B, T-0):**
(a) Den Planer trocken emittieren lassen und die tatsaechlich adressierten Binaries
**zaehlen**, statt sie aus Kommentaren zu addieren.
(b) `05_evaluation.tex:94-101` DE+EN auf die gezaehlte Zahl setzen -- oder, falls O-A eine
reduzierte Teilmenge waehlt, den Satz um genau diese Deklaration erweitern.
**Aufwand: (a) Minuten bis eine Stunde, (b) zwei Absaetze.**

---

### R-T2 [MITTEL-SCHWER] Das PMC-Regime verspricht mehr Kategorien, als die Quelle oeffnen kann -- und die Ledger-Gegenaussage ist ihrerseits falsch

**Der Text**, `kapitel/de/05_evaluation.tex:86-91`, woertlich:

> "ein *root-Linux mit vollem Hardware-Zaehler-Zugriff* (\texttt{perf}/MSR) macht hingegen
> die zaehlerbasierten Mess-Kategorien (Cache-, dTLB- und **Branch-Misses, IPC/CPI** ...)
> ... ueberhaupt erst zugaenglich ... die PMC-Kategorien werden nur unter dem privilegierten
> Regime erhoben"

**Der Apparat**, `Code/external/comdare-cache-engine/libs/cache_engine/builder/linux_perf_pmc_source.hpp`
(vollstaendig gelesen; von `[CODEX]` unabhaengig bestaetigt):

| Feld | Zeile | Ist bei aktivem `COMDARE_ENABLE_PMC` auf Linux |
|---|---|---|
| `cache_misses_l1` | `:202-203`, Zuweisung `:254-257` | **real** (`PERF_COUNT_HW_CACHE_L1D`) |
| `cache_misses_l3` | `:204-205`, Zuweisung `:262-266` | **real, aber aus `PERF_COUNT_HW_CACHE_LL`** |
| `dtlb_misses` | `:206-207`, Zuweisung `:271-274` | **real** (`PERF_COUNT_HW_CACHE_DTLB`) |
| `energy_micro_joules` | RAPL `:152-167`, Delta `:279-293` | **best-effort**, 0 ohne Zone/Leserecht |
| `cache_misses_l2` | `:208`, Kommentar `:194` | **strukturell 0** -- kein Counter geoeffnet |
| `coherence_invalidations` | `:208`, Kommentar `:195` | **strukturell 0** -- kein Counter geoeffnet |
| `branch_misses` | keine Zuweisung im ganzen Header | **strukturell 0** -- wird nie befuellt |

**ZWEI FOLGEN, und die zweite ist eine Korrektur an unserem eigenen Ledger:**

1. **Der Text ueberverspricht bei `branch_misses` und IPC/CPI.** `05_evaluation.tex:87-88`
   nennt Branch-Misses und IPC/CPI als Kategorien, die das privilegierte Regime
   *"ueberhaupt erst zugaenglich"* macht. Der Linux-Pfad oeffnet dafuer **keinen Counter**
   -- auch der optionale PAPI-Zweig befuellt nur L1/L3/dTLB (`:349-351`). Unter root ist
   `branch_misses` genauso 0 wie ohne. **Das ist eine Zusage, die kein Regime einloest.**
2. **KORREKTUR AN LEDGER:4403-4406.** Dort steht woertlich: *"auch mit Flag bleiben L3, L2,
   coherence und energy auf 0 ... Der Anhang kann also selbst im besten Fall nur L1D + dTLB
   zeigen"*. **Das ist am Code WIDERLEGT** (`[CODEX]` bestaetigt, ich habe es nachgelesen):
   `cache_misses_l3` wird sehr wohl befuellt, aus dem LL-Counter; `energy_micro_joules`
   wird best-effort aus RAPL befuellt. **Strukturell 0 bleiben L2, coherence und branch --
   drei Felder, nicht vier.** Der Anhang koennte im besten Fall **L1D + LL + dTLB
   + (unter root) Energie** zeigen, also vier von sieben Spalten. Das ist ein besseres
   Bild als der Ledger glaubt und muss vor O-A korrigiert sein, weil O-A auf der
   Ledger-Zahl aufbaut (LEDGER:4540: *"der Anhangs-Umfang angesichts I-PMC-2/3 (nur
   L1D+dTLB)"*).

**FIX:** `05_evaluation.tex:86-91` DE+EN -- Branch-Misses und IPC/CPI aus der Aufzaehlung
der "zugaenglich gemachten" Kategorien herausnehmen oder ausdruecklich als *geplante
Schema-Erweiterung, nicht erhoben* kennzeichnen (die Formulierung dafuer existiert bereits
in `06_fazit.tex:157-159` und ist dort korrekt). **Aufwand: ein Satz DE + EN.**

---

### R-T3 [MITTEL] Die Spalte heisst `l3`, der Counter misst `last level`

`linux_perf_pmc_source.hpp:192` benennt es selbst ehrlich im Kommentar:
*"cache_misses_l3 <- PERF_COUNT_HW_CACHE_LL / OP_READ / RESULT_MISS (Last-Level; ehrlich
LL)"*, und `:263` sagt, dass LL CPU-abhaengig L2 **oder** L3 sein kann (`[CODEX]`).

`kapitel/de/05_evaluation.tex:179` listet die CSV-Spalten als
*"L1-/L2-/L3-Cache-Misses"* -- ohne diesen Vorbehalt. Auf einer dreistufigen Cache-Hierarchie
ist LL = L3 und alles stimmt; auf einer Maschine mit anderer Hierarchie waere die Spalte
falsch beschriftet. Da die Zielmaschinen (prod1 Zen 5, prod2 Alder Lake, LEDGER:3662) beide
drei Stufen haben, ist das **kein Datenfehler, sondern eine Praezisionsluecke im Text**.

**FIX:** eine Fussnote oder eine 16. Zeile in `le_limitierung.tex`:
*"Die Spalte cache_misses_l3 wird aus dem generischen Last-Level-Counter befuellt; auf den
Zielplattformen ist LL = L3."* **Aufwand: eine Zeile.** Kann mit der O-4-Auflage aus A.1.4
zusammengelegt werden.

---

### R-T4 [MITTEL, kein Textfehler, aber ein Messfehler-Risiko] Die PMC-Wache beantwortet eine andere Frage

Vollstaendig im Ledger belegt (LEDGER:4357-4392) und von mir am Objekt nachgeprueft:

- Der Preflight wird in jeden Mess-Batch emittiert:
  `experiment_plan_director.hpp:1361-1364` (`cmake --build ... m3v2_pmc_smoke
  linux_perf_pmc_smoke`, dann `ctest --test-dir build -L pmc`). Sein Kommentar `:1352-1360`
  benennt die Gefahr woertlich: *"ohne Preflight koennte eine Lane eine mehrtaegige Messung
  mit kaputtem perf_event_open durchlaufen und lauter 0-Zaehler produzieren"*.
- `tests/unit/thesis_tiere/linux_perf_pmc_smoke.cpp:58-63` gibt bei fehlendem Zugriff
  `SMOKE_SKIP` und **`return 0`** zurueck.
- **`COMDARE_ENABLE_PMC` kommt in `experiment_plan_director.hpp` exakt 0 mal vor**
  (selbst gezaehlt: `grep -c` = 0). Ohne das Flag ist die Quelle nicht gebaut, der Skip
  greift korrekt, und der Preflight ist gruen.

**PRAEZISIERUNG gegenueber der bisherigen Buchung:** der Smoke-Test hat sehr wohl einen
Biss -- ab `:66` prueft er *"available==1 => mindestens ein echter Counter MUSS befuellt
sein"*. Der Defekt ist eng: **er trifft nur den Fall "Quelle gar nicht gebaut".** Das ist
kein Grund zur Entwarnung (genau dieser Fall ist der wahrscheinliche), aber die Wache ist
nicht global blind.

**Fuer die ABGABE ist das nur dann ein Textrisiko, wenn gemessen wird.** Bleibt es bei
Weg 1 (A.1.4), traegt `le_limitierung.tex` Zeile 1 den Zustand bereits korrekt. Wird
gemessen, muss T-3 (Teil B) vorher stehen. **Reihenfolge beachten: der Test darf erst
gebaut werden, wenn O-A entschieden ist** -- sonst baut man ein rotes Gate in eine
Pipeline, die gruen werden soll.

---

### R-T5 [NIEDRIG, aber eine Landmine] Acht tote Kapiteldateien je Sprache tragen die widerlegte Neunzehner-Zaehlung

**Die gute Nachricht zuerst, denn sie korrigiert V-03** (LEDGER:5147, das dort
*"7 belegte Textstellen im ABGABE-Dokument"* meldet): **in den sechs aktiv kompilierten
Kapiteln ist die Neunzehner-Zaehlung sauber gehedgt.** Selbst gegrept:

- `kapitel/de/04_implementierung.tex:138`: *"Die Neunzehner-Zaehlung frueherer Fassungen
  dieses Kapitels (T0--T18, Zwischenstand Juli 2026) ist durch ..."*
- `kapitel/de/03_messsystem_prtart.tex:105,147`: gleiche Konstruktion, T0--T17 als Kanon,
  T0--T18 ausdruecklich als ueberholte Vorfassung benannt.
- `kapitel/en/04_implementierung.tex:134,169`: EN deckungsgleich.

**Die Landmine:** die 19 Treffer auf `neunzehn`/`nineteen` liegen **ausschliesslich in
Dateien, die `diplomarbeit.tex` NICHT einbindet** -- `01_introduction.tex:107,111,133,169`,
`02_fundamentals.tex:270,410,431`, `03_state_of_the_art.tex:146,159,609`,
`04_concept_architecture.tex:6,127,210,221,224,236,277`, `05_implementation.tex:38,74`,
`08_conclusion.tex:13`. Diese acht Dateien je Sprache sind Vorfassungen, die im Baum liegen
geblieben sind.

**Kein Abgabe-Risiko am PDF.** Aber: wer eine dieser Dateien versehentlich einbindet oder
wer den Repo-Baum als Beleg vorlegt, hat die widerlegte Zaehlung wieder im Raum.

**FIX -- KORREKTUR, die Parallel-Linie ist schneller und ihr Weg ist besser.**
Mein urspruenglicher Vorschlag war, die acht Vorfassungen je Sprache nach
`kapitel/<lang>/superseded/` zu verschieben. **Das ziehe ich zurueck.** Waehrend dieser
Erhebung hat die Parallel-Linie (Abschnitt 0.1) genau diesen Posten bearbeitet, und zwar
**additiv statt bewegend** -- 16 Dateien, **+74 Zeilen, 0 Loeschungen**, je ein
Kopf-Kommentar. Woertlich aus `kapitel/de/01_introduction.tex` (uncommitteter Stand):

> "% NICHT eingebunden (Stand 06.08.2026): diese Datei ist in diplomarbeit.tex nicht
> referenziert.
> % Vor einer Reaktivierung gegen den aktuellen Stand der eingebundenen Kapitel abgleichen.
> % ACHTUNG, veralteter Achsen-Stand: dieser Text fuehrt noch die Neunzehner-Zaehlung
> (4 Fundstellen); der aktive Text fuehrt achtzehn Organ-Achsen (T0--T17)."

**Das ist die richtige Loesung und meine war die schlechtere:** kein Dateiname aendert
sich, kein `\include`-Pfad kann brechen, das PDF-Gate kann nicht rot werden -- und die
Warnung steht dort, wo sie jemand liest, naemlich in der Datei selbst. **R-T5 gilt damit
als in Arbeit, nicht als offen.** Das Verschieben nach `superseded/` bleibt ein
Aufraeumpass-Kandidat NACH der Abgabe, ist aber nicht mehr dringend.

---

### R-T6 [NIEDRIG] `axis_inventory.tex` wird geschrieben und nirgends eingebunden

Bereits im Fahrplan als Aufraeumpass-Kandidat Nr. 9 gefuehrt (FAHRPLAN:524-525). Kein
Abgabe-Risiko, gehoert auf die Klammer-Liste nach der Abgabe.

---

### A.2.x WAS AUSDRUECKLICH KEIN RISIKO IST (Ehrlichkeit in beide Richtungen)

Gegen den PMC-Vorwurf und den Ueberversprechens-Vorwurf geprueft und **sauber befunden**:

- `kapitel/de/06_fazit.tex:157-162` -- benennt die PMC-Abschaltung, die Null-Spalten der
  Smoke-Reihe **und** dass Branch-Misses/IPC *"derzeit nicht erfasst"* werden. Vorbildlich.
- `kapitel/de/05_evaluation.tex:170-174` -- nennt die Smoke-Reihe als Smoke-Reihe und
  verweist ausdruecklich auf ihre Limitierungen; die Pflicht-Messreihen stehen als
  *"stehen aus"*.
- `kapitel/de/06_fazit.tex:155-156` -- *"ersetzt die Pflicht-Messreihen aber nicht"*.
- `kapitel/de/05_evaluation.tex:178-182` -- beschreibt das CSV-**Schema**, keine Ergebnisse.
- `anhang/de/tabellen/le_limitierung.tex` -- 15 nummerierte Vorbehalte, kein Beschoenigen.
- **Node-Shape-Varianten:** 0 Treffer auf
  `node.?shape|shape.?variant|Knotenform|width_in_lines` in allen `kapitel/` und `anhang/`
  beider Sprachen. Die im Testoffensive-Plan als tot markierte Shaped-Emission
  (`docs/plaene/20260806-PLAN-testoffensive-und-gruene-pipeline.md:335`) hat **keinen
  Reflex im Abgabe-Text**. Kein Risiko.
- **Anhaenge B und E:** gefuellt, siehe A.0. Der alte Blocker-Vermerk ist ueberholt.
- **`.blg`/Literatur:** Gate ist Teil des harten CI-Zwangs
  (`.gitlab-ci.yml:66-90` im Thesis-Repo) und lief zuletzt mit
  `BibTeX .blg Warnings/Repeated=0` (LEDGER:4520).

---

# TEIL B -- DER PRIORISIERTE TESTPLAN MIT BISSEN

**Massstab (Owner):** ein gruener Lauf muss ETWAS BEWEISEN. Ein Test ohne Biss ist ein
gruener Job, der von einem inerten Job nicht unterscheidbar ist.

## B.0 Was die heutigen Landungen bereits erledigt haben -- KEINE weitere Arbeit

Alle vier am Objekt nachgeprueft:

| Posten | Beleg |
|---|---|
| Duplicate-Key-Wache | `contract:axis-version-lock` steht in `ce/.gitlab-ci.yml` **einmal** als aktive Definition (`:447`); `:241` und `:629` sind Kommentar-Grabsteine der entfernten Zweitfassung. `scripts/ci_yaml_key_guard.sh` existiert (9378 B). |
| CTest-Routing-/Waisen-Wache | `scripts/ci_test_coverage_guard.sh` existiert (12125 B), faehrt in CI; Nenner **407/407** in Pipeline 15025 (LEDGER:4553-4556) -- **inzwischen 411/411 in Pipeline 15043** (super `b00638f2`, Abschnitt 0.1). Beide Zahlen `[BERICHT]` aus Commit-/CI-Text, nicht selbst nachgefahren. |
| ASCII-/Breiten-Wache | Bissbeweis-Datei liegt real: `ce/scripts/ci_diff_ascii_width_guard.bissbeweis.txt` (9967 B). |
| Reaktivierter Versions-Tripwire | Der Job faehrt wieder. **Aber er beisst nicht nachweislich** -- das ist T-2. |

**Korrektur an einer Zuarbeit:** die Job-Definition liegt in
`Code/external/comdare-cache-engine/.gitlab-ci.yml`, **nicht** in `ci/gitlab-ci.yml`.

---

## B.1 VOR DEM TRIGGER -- vier Tests, die etwas beweisen

### T-0 [NEU, HOECHSTE PRIORITAET] Die Bau-Mengen-Invariante: zaehlen statt addieren

**Warum zuerst:** T-0 loest R-T1 und ist die fehlende Eingabe fuer O-A. Ohne ihn wird eine
Owner-Entscheidung ueber eine Zahl getroffen, die drei Quellen unterschiedlich angeben
(131072 / 524288 / 2097152).

**Fehlerklasse:** eine Konfigurationsgroesse, die dekorativ ist und still ignoriert wird
(`cap="131072"` in einem Dialekt, der sie nicht liest --
`xml_config_parser.cpp:443-580` ohne `run_options`-Zweig).

**BISS, zwei Haelften:**
- **(a) Mengen-Biss.** Den Planer trocken emittieren lassen
  (`experiment_plan_director`) und die adressierten Binary-Identitaeten **zaehlen**.
  Erwartung: die gezaehlte Zahl == der Wert, den die Thesis nennt. Weicht sie ab, ist
  entweder der Text oder die XML falsch -- und der Test sagt welcher.
- **(b) Dekorations-Biss.** Eine `comdare_experiment`-XML mit
  `<run_options cap="7"/>` parsen. **Heute wird das Attribut still geschluckt.** Der Test
  muss erzwingen, dass entweder der Wert wirkt ODER der Parser das unbekannte
  Steuer-Attribut **laut ablehnt** (fail-closed). Ein still ignoriertes Steuer-Attribut in
  der Trigger-Input-Basis ist genau die Klasse "eine Zusage, die eine andere Frage
  beantwortet".

**Aufwand:** (a) 1-2 h, (b) 1 h. **Gate:** blockiert O-A.
**Nebenprodukt:** liefert zugleich die vom Fahrplan geforderte Kalibrier-Stichprobe
(FAHRPLAN:427-430) -- Menge und Zeit in einem Lauf.

---

### T-1 [HOCH] XXE-/Entity-Sperre: der Bissbeweis fehlt

**Am Objekt festgestellt:** die Sperre **ist gebaut und verdrahtet** --
`Code/tests/xml_canonical_utils.cmake:135` (`comdare_xml_has_doctype`), aufgerufen an
`:394` (in `comdare_xml_open`) und `:473`; konsumiert von
`golden_n_consistency_check.cmake` und `fixture_schema_subset_check.cmake`. Die Erkennung
ist parser-basiert (`:121-124`, Vergleich normale Serialisierung gegen `--dropdtd`), nicht
textmusterbasiert. **Das ist saubere Arbeit.**

**Was fehlt:** **es existiert im ganzen Baum keine einzige XML mit `<!DOCTYPE`**
(selbst gegrept ueber `Code/**/*.xml` ohne `build/`: 0 Treffer). Die `FATAL_ERROR`-Kante
wird also nie genommen. Die Wache sagt ihr eigenes Vorbehaltsurteil sogar selbst
(`:130`: *"KEINE der gewachten Dateien eine DOCTYPE"*).

**BISS:** eine Test-Fixture
`<!DOCTYPE r [<!ENTITY x SYSTEM "file:///tmp/canary.txt">]><r>&x;</r>` muss
`comdare_xml_has_doctype` auf TRUE bringen und den Lauf **FATAL** abbrechen; Gegenprobe:
dieselbe Datei ohne `DOCTYPE` muss gruen durchlaufen, und der Canary-Inhalt darf in keinem
Ausgabeartefakt auftauchen.

**Aufwand: 1-2 h.** Ohne ihn ist ein gruener Lauf mit wirksamer und ohne wirksame Sperre
identisch gruen.

---

### T-2 [HOCH] Mutationsprobe `contract:axis-version-lock`

**Am Objekt:** `grep -rliE 'axis.?version.?lock|AXIS_ALGO_VERSION'` ueber
`Code/tests/` und `ce/tests/` liefert **0 Dateien**. Das Werkzeug existiert
(`ce/tools/axis_version_lock/axis_version_lock.cpp` + `axis_version.lock`), der Job faehrt
(`ce/.gitlab-ci.yml:447`) -- **aber kein Test beweist, dass er beisst.**

Der Ursprungsschaden ist dokumentiert: der Tripwire war *"drei Wochen doppelt definiert und
damit faktisch AUS"* (LEDGER:4553-4554) und liess in dieser Zeit zwei reale Semantikdrifts
durch.

**BISS:** ein Byte in einem der drei gewachten Heuristik-Header
(`axis_spline.hpp`, `break_even.hpp`, `measurement_curve_loader.hpp`, benannt in
FAHRPLAN:455-457) ohne `AXIS_ALGO_VERSION`-Bump aendern -> der Lock **muss** rot melden;
mit Bump -> gruen. Als CTest-Fall, nicht als Handprobe.

**Aufwand: 1-3 h.** Er macht den reaktivierten Job erst zu einem Beweis.

---

### T-3 [MITTEL, GEGATET auf O-A] PMC-Flag-Vertrag

**Am Objekt:** `COMDARE_ENABLE_PMC` kommt in
`ce/libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp`
**0 mal** vor. Der Preflight kann daher nicht pruefen, ob das Flag in der emittierten Kette
steht -- er prueft nur, ob eine (moeglicherweise gar nicht gebaute) Quelle Zugriff hat
(R-T4).

**BISS:** ein Test ueber die emittierte Batch-Zeichenkette, der fordert, dass
`-DCOMDARE_ENABLE_PMC=ON` **als Invariante** in jedem Mess-Batch steht; entfernt man das
Flag aus der Emission, muss der Test rot werden. Zweiter Biss: der Preflight muss
"Quelle nicht gebaut" als **Fehler** werten, nicht als Skip
(`linux_perf_pmc_smoke.cpp:58-63`).

**GATE:** **nicht bauen, bevor O-A entschieden ist.** Die Owner-Entscheidung
(LEDGER:4537-4540) umfasst ausdruecklich drei Dinge -- Flag als Invariante, Wache umdrehen,
Anhangs-Umfang. Ein rotes Gate vor der Entscheidung blockiert eine Pipeline, die gruen
werden soll. **Aufwand: ca. 1 h nach dem Entscheid.**

**Mit der O-A-Vorlage mitgeben:** die Korrektur aus R-T2. Der Anhangs-Umfang ist
**L1D + LL + dTLB + best-effort-Energie**, nicht "nur L1D + dTLB", wie LEDGER:4540 sagt.

---

## B.2 NACH DEM TRIGGER / NACH DER ABGABE -- kein Vor-Abgabe-Gewicht

- **T-4** Fingerprint-Kreuzprobe -- reale Fehlerklasse, aber im Zeitfenster
  "wahrscheinlich, nicht sicher".
- **T-5** `bestandslog_active`-Fingerprint-Bindung -- gegatet auf O-C (faehrt der Trigger
  mit `COMDARE_BESTANDSLOG`?).
- **T-6** LB-2/LB-3 eigene Beweiswelle. **Achtung, Rangfrage:** LEDGER:4473-4478 stuft
  Stufe 1 der Lager-Basis-Tests ausdruecklich als **Vor-Trigger-PFLICHT** ein (LB-6), nicht
  als "kann" -- die Bausteine sind gebaut, Beweise reichen aber nur bis LB-1
  (`test_lb0` 33 TEST-Makros, `test_lb1` 23; `test_lb2`/`test_lb3` existieren nicht,
  LEDGER:4454-4465). **Das ist ein Owner-/Lead-Konflikt mit dem Fahrplan und gehoert
  benannt, nicht still einsortiert.**
- **T-7 ff.** libabigail-ABI-Baseline, echter XLSX-Roundtrip, 1,57-Mio-Kardinalitaet,
  Property-/Fuzz-Tests, Lager-Crashmatrix, Planer->CEB->Tier-Wertidentitaet, vollstaendige
  Stempelgrammatik, 18-Achsen-Manifest. Alle sprengen das Zeitfenster; an keinem haengt ein
  Messergebnis vor Freitag.

---

## B.3 BESTANDSTESTS, DIE NICHTS BEWEISEN -- streichen, nicht pflegen

Zwei selbst gelesen und **bestaetigt**:

- `Code/tests/**/test_config_durability.cpp:105-122`
  (`ConfigDurability.XmlReaderNeverCrashesOnGarbage`): akzeptiert `nullopt` ODER einen
  `Node` gleichermassen und endet in `SUCCEED()`. Beweist "kein Absturz", keine Semantik.
- `ce/tests/**/test_r2_suffix_wachen.cpp:77-78`: vergleicht
  `compose_system_version_suffix(p)` mit sich selbst -- ein Determinismus-Check derselben
  Belegung, keine Aussage gegen falsche Segment-Reihenfolge. Spaetere Pruefungen derselben
  Datei sind schaerfer; kein Beweiszuwachs.

Weitere Kandidaten (`test_g2_variant_sidecar.cpp:275-280`,
`test_f3_lager_key_provider_iterator.cpp:208-305`,
`test_e24_c10_g6_identitaets_bilanz.cpp:171-191`, `test_clu_per_layout.cpp:108-110`,
`test_phase6_vorbau.cpp:41-52`) stammen aus einer Codex-Lektuere unter
Sandbox-Netzwerk-Einschraenkung und sind vom Vorbericht selbst als *"nicht Zeile fuer Zeile
gegengelesen"* markiert. **Vor jedem Eingriff gegen den Ist-Stand nachlesen.**

---

# TEIL C -- EHRLICHKEIT ZUR FRIST FR 08.08.

**Was noch reinpasst (Summe unter 3 h Arbeit, alles textseitig oder klein):**

| # | Posten | Aufwand | Warum es passt |
|---|---|---|---|
| 1 | R-T2-Fix: Branch-Misses/IPC aus `05_evaluation.tex:86-91` DE+EN | ein Satz x 2 | reine Textkorrektur, PDF-Gate faengt Fehler sofort |
| 2 | O-4-Auflage + R-T3: zwei Zeilen in `le_limitierung.tex` DE+EN | 30 min | additiv, in einer bestehenden `longtable` |
| 3 | T-0(a) Mengen-Zaehlung | 1-2 h | liefert die Eingabe fuer O-A, ohne die O-A nicht entscheidbar ist |
| 4 | Ledger-Korrektur zu R-T2 (PMC-Abdeckung ist besser als gebucht) | 15 min | verhindert, dass O-A auf einer falschen Zahl entschieden wird |
| 5 | T-1 XXE-Bissbeweis | 1-2 h | additiv, beruehrt keine Produktivdatei |

**Was nicht mehr reinpasst -- und das ist die unangenehme Haelfte:**

- **Anhang A auf 44/44 (Weg 2 aus A.1.3).** Kette: O-A -> O-E -> Voll-Messlauf
  -> V-04-Writer -> Einbindung -> PDF-Gate. Der Messlauf allein hat eine
  **ungemessene** Laufzeit, deren drei kursierende Schaetzungen um Faktor 16 auseinander
  liegen (R-T1). Ein Ein-Versuch-Pfad ohne Puffer zwei Tage vor der Frist ist keine
  Planung, sondern eine Wette.
- **R-T1-Fix (b), also die Textkorrektur der Bau-Menge, ist von T-0(a) abhaengig.** Passt
  nur, wenn T-0(a) am Donnerstag frueh laeuft. Laeuft er Donnerstag abend, bleibt keine
  Reaktionszeit.
- **R-T5 (acht tote Kapiteldateien verschieben).** Technisch 15 Minuten. **Trotzdem NICHT
  vor der Abgabe** -- 16 Dateibewegungen im Abgabe-Repo zwei Tage vor der Frist sind ein
  unnoetiges Risiko fuer ein Problem, das im PDF gar nicht sichtbar ist.
- **T-2 und T-3.** T-2 ist wertvoll und passt zeitlich (1-3 h), konkurriert aber mit
  T-0/T-1 um dieselben Stunden. T-3 ist ohne O-A gar nicht baubar.
- **Die 12 Vor-Trigger-Posten des kritischen Pfads** (FAHRPLAN:377-391) sind nicht Teil
  dieses Plans und binden den groesseren Teil der verbleibenden Zeit.

**Die ehrliche Gesamtaussage.** Der Fahrplan sagt: *"Der Trigger-Termin Do 07.08. ist mit
dem Bau-Block noch haltbar. Die MESSUNG dahinter ist es nach heutiger Deklaration nicht"*
(FAHRPLAN:402-403). **Diese Erhebung verschaerft das:** die Deklaration selbst ist
uneinheitlich (R-T1), und die Kappung, auf die sich die Machbarkeitsrechnung stuetzt, wird
vom Parser dieser Datei gar nicht gelesen. **Solange T-0(a) nicht gelaufen ist, ist jede
Aussage ueber die Machbarkeit der Messung unbelegt -- in beide Richtungen.**

Daraus folgt die Reihenfolge, die ich empfehle:
**T-0(a) zuerst, dann O-A entscheiden, dann O-4 entscheiden.** O-4 auf Weg 1 (A.1.4) ist
von dieser Kette unabhaengig und kann jederzeit fallen -- das ist sein Hauptvorteil.

---

## QUELLENVERZEICHNIS

**Ledger** `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`: `:267` (alter B/E-Stub-Vermerk,
ueberholt) - `:4202-4542` (nachmittag-10) - `:4357-4406` (PMC, Abschnitt E) - `:4403-4406`
(die von R-T2 widerlegte Aussage) - `:4454-4478` (LB-Paketschnitt) - `:4535-4542`
(Abschnitt H, offen) - `:4553-4556` (Tripwire/407) - `:5042` (O-4 offen) - `:5147-5150`
(V-01..V-08, mittag-19) - `:5149` (O-4-Quelle).

**Plaene/Sessions:** `docs/sessions/20260806-FAHRPLAN-hauptstrang-landung.md:375-391,
400-435, 494-529, 512` - `docs/plaene/20260806-PLAN-testoffensive-und-gruene-pipeline.md:335`.

**Thesis** (`Code/external/20260931-overleaf-diplomarbeit/` @ `8970465d`):
`diplomarbeit.tex:280-295` - `kapitel/de/05_evaluation.tex:86-91, 94-101, 170-182` -
`kapitel/de/06_fazit.tex:155-162` - `kapitel/de/04_implementierung.tex:138, 173` -
`kapitel/de/03_messsystem_prtart.tex:105, 147` - `anhang/{de,en}/A_measurements.tex` -
`anhang/de/tabellen/le_limitierung.tex` - `anhang/de/B_code_structure.tex:1-12` -
`.gitlab-ci.yml:66-90`.

**Apparat:** `Code/test_data_xml/experiment_golden_kern.xml:77, 157-158, 237-246, 272-290` -
`Code/02_messung_driver/main.cpp:1226, 1287` - `.gitlab-ci.yml:79, 1213, 1236` (super) -
`ce/libs/common/serialization/xml_config_parser/xml_config_parser.cpp:266, 424-432, 443-580`
- `ce/libs/cache_engine/profile_facade/profile_run_facade.hpp:172` -
`ce/libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:600, 940,
989-990, 1152-1153, 1207-1208, 1352-1368` -
`ce/libs/cache_engine/builder/linux_perf_pmc_source.hpp:152-167, 191-208, 254-297, 349-351` -
`ce/tests/unit/thesis_tiere/linux_perf_pmc_smoke.cpp:58-66` -
`Code/tests/xml_canonical_utils.cmake:121-135, 394, 473` -
`ce/.gitlab-ci.yml:241, 426, 447, 629` -
`ce/scripts/{ci_yaml_key_guard.sh, ci_test_coverage_guard.sh,
ci_diff_ascii_width_guard.bissbeweis.txt}` - `ce/tools/axis_version_lock/`.

**Zweites Lens:** Codex-Thread `019fd87c-3751-7963-afd5-66df5059a1df` -- bestaetigte die
Bau-Mengen-Divergenz, widerlegte die Ledger-PMC-Aussage und fand die inerte Cap-Semantik.
Alle drei Punkte wurden von mir am Objekt nachverifiziert, bevor sie hier stehen.

<!-- Selbstcheck: ASCII-only ausser Zitaten aus dem Bestand; keine Edits ausser dieser
     Datei; kein git-Kommando durch Codex; jede Zahl mit Bezugsgroesse und Datei:Zeile;
     nicht committet. -->
