# OWNER-VORLAGE D-2 (17.08.2026) -- KURVEN-STACK-TRIAS (E-5) + K4 mess/-S-POSITION (GETRENNT)

> **Anlass:** Owner 17.08. auf die 20er-Vorlage, D-2 verbatim: *"Ich brauche hier mehr Verstaendnis
> und Kontext."* (Ledger KON104-01). KON104-02/D-2 hat diese Gegenueberstellung als eigenes Fenster
> zugesagt; KON107-03 fuehrt sie als Frage 2 (E-5) und Frage 3 (K4, GETRENNT). **Bis zum Entscheid
> waehlt kein Aufraeumpass implizit (Par.75-Sperre laeuft).**
>
> **Gegenstand:** die drei **Break-Even-SPLINE-Stacks** -- NICHT die Statistik-Stacks. Perzentil-Kanon,
> Sieger-Semantik, REV-DATA-12 und die HDR-Rolle sind bereits entschieden und stehen unten in
> Abschnitt 8 nur zur Abgrenzung.
>
> **Quellen-Stand:** alle Zahlen am 17.08.2026 am ce-Hauptklon (development) frisch gemessen
> (wc -l / grep, read-only), Nenner steht jeweils dabei; Nichtfunde mit Gegenprobe. Historische
> Zahlen (06.08.) sind als solche markiert. Zeilen-Anker nach V14 ueber den ABSCHNITT ansteuern,
> nie blind ueber die Zeile.

---

## 1. Der Gegenstand in einem Satz

Dieselbe Rueckwaerts-Wahl-Mathematik (Kurve je Kandidat -> Schnittpunkt = Break-Even ->
Fuehrungswechsel) existiert **dreifach parallel** im ce. Ledger-/Plan-Zitat (06.08., PLAN-messkurven
:326): *"Nenner: 1802 Zeilen ueber drei parallele Stacks, 0 Produktions-Konsumenten."* Der
Hybrid-Bauplan (:17) formuliert dieselbe Lage: die Synthese *"existiert dreifach -- 1802 Zeilen ueber
drei parallele Stacks -- und ist getestet."*

Heute nachgemessen: **[1] 642 + [2] 628 + [3] ~306 = ~1576 Zeilen** (Delta zur 1802 vom 06.08.:
die CSV-Zellen-Parser wurden am 08.08. als Duplikat-Aufloesung in den Querschnitt
`include/cache_engine/measurement/csv_cell_reader.hpp` gehoben, break_even.hpp wuchs durch T-9,
und die Haelfte-B-Abgrenzung ist hier enger gefasst -- nur der Skeleton-Block, s. Abschnitt 4).
Der Kernbefund **"0 Produktions-Konsumenten" gilt unveraendert** -- heute je Stack mit frischer
Gegenprobe belegt (Abschnitte 2-4).

---

## 2. Stack [1] -- heuristik/ (axis_spline + break_even + measurement_curve_loader)

**Ort/Umfang (17.08. gemessen):** `libs/cache_engine/heuristik/` --
`axis_spline.hpp` 261 Z. + `break_even.hpp` 197 Z. + `measurement_curve_loader.hpp` 184 Z.
= **642 Z.** Dazu als Richtungs-Quelle (nicht Teil der Trias-Zaehlung):
`axis_optimization_catalog.hpp` 445 Z. (06.08.-Stand der Trias: 636 Z.; break_even wuchs 148->197
durch T-9, der Loader schrumpfte 227->184 durch die csv_cell_reader-Extraktion.)

**Mathematischer Kern:**
- Spline: stueckweise kubisch-Hermite auf **Original-Skala x** (working_set_n, value_size, ...);
  Verfahren = **Compile-Time-Strategy** (Concept `InterpolationStrategy`, kein Runtime-Switch):
  Default **monotone kubische Hermite (Fritsch-Carlson 1980)** mit dokumentierter numerischer
  Begruendung (natuerlicher Spline kann UEBERSCHWINGEN -> SCHEIN-Schnittpunkte -> falsche
  Switch-Thresholds; axis_spline.hpp:15-25); `NaturalCubicStrategy` (C2, Thomas-Algorithmus)
  als benannte Alternative. Ausserhalb der Domaene flach geklemmt.
- Break-Even: d(x) = f(x) - g(x) auf der Domaenen-Ueberlappung, Gitter = Vereinigung beider
  Knotenmengen, `sign_tol` + deterministische Bisektion (100 Iterationen), exakte Knoten-Treffer
  ohne Doppelzaehlung; je Schnittpunkt links/rechts-Besser-Etikett.
- **T-9-Richtungs-Kanon (einzig hier):** "besser" ist NICHT pauschal "kleiner", sondern
  richtungs-parametriert aus `axis_optimization_catalog.hpp` (Minimize/Maximize als
  Non-Type-Template-Parameter, `if constexpr`, kein Laufzeit-Zweig); fuer die Pareto-Achsen
  T5/T6/T18 verweigert die Katalog-Abkuerzung COMPILE-TIME den Dienst (static_assert,
  break_even.hpp:187-195). Hintergrund break_even.hpp:20-27: fuer 15 der 19 Achsen-Zeilen des
  Katalogs traegt mindestens eine Zielgroesse MAX-Richtung -- die alte Pauschale meldete dort die
  SCHLECHTERE Kurve als besser.
- Loader: beide reale CSV-Dialekte (WIDE Semikolon via lazy_csv_header; SNAPSHOT Komma),
  Gruppen-Schluessel (achse, variante, workload), HONEST-EMPTY, und die **volle
  D1-Token-Verwerfliste** `{"n/a","failed","gesperrt","nicht_gebaut","-",""}` mit gezaehlten
  skipped_rows (nie Phantom-Punkte).

**Konsumenten (Gegenprobe 17.08.):** **0 Produktions-Konsumenten.**
`grep -rn '#include.*heuristik/'` ueber libs/apps/tools/benchmarks/modules/adapters ohne tests/
= **0 Treffer**; die vier `hybrid/heuristik_adapter_*.hpp` inkludieren nur `anatomy/anatomy_base.hpp`
und einander (einzeln gemessen) -- der Namens-Anklang ist KEINE Code-Kante.
Test-Konsumenten: 3 (s.u.) plus die Lock-Wache als Fixture.

**Testdeckung:** `test_heuristik_spline_break_even.cpp` (429 Z., **18 gtest-TESTs**, darunter der
T-9-Regressionstest, der gegen den Alt-Stand faellt) + `test_fk1_nicht_gebaut_marker.cpp` (312 Z.)
+ `test_rf2_admission_marker_inert.cpp` (230 Z.) fuer das Loader-Token-Verhalten.
**Wachen-Deckung (einzig hier):** alle 6 heuristik-Header stehen im
`tools/axis_version_lock/axis_version.lock` (:193-208) unter dem AXIS_ALGO_VERSION-Tripwire
(CI-Job contract:axis-version-lock); die Bump-Historie (break_even v1->v2, loader v1->v2) belegt,
dass die Wache gelebt wird.

**Kanon-Bilanz:**
- PRO: einziger Stack mit Richtungs-Kanon (T-9), einziger mit Lock-Wache, einziger
  Par.75-schutzgelistet (LEDGER:3602-Familie; Kandidatenliste-75 S-1 :92 "speisen den
  Break-Even-Router HY-B2"), einziger plan-gedeckt (soll_design:194 = HY-B2 zeigt hierauf;
  HY-C-T-1 `test_hy_router_konsum` verlangt Typ-Identitaet `heuristik::AxisSpline`/`BreakEvenPoint`),
  CT-Strategy statt Runtime-Enum, D1-Token-Vollschutz, Original-Skala (kein log2-Zwang, x=0 erlaubt).
- CONTRA: kein Regressions-Fit (das a*log2(x)+b-Modell mit residual_rms existiert NUR in [2]);
  Gruppen-Schluessel fest dreidimensional; wie alle drei: heute ohne Produktions-Konsument.

---

## 3. Stack [2] -- builder/curve_fit + builder/decision_lambda_trees

**Ort/Umfang (17.08. gemessen):** `libs/cache_engine/builder/curve_fit/curve_fit.hpp` 499 Z. +
`builder/decision_lambda_trees/decision_lambda_trees.hpp` 129 Z. = **628 Z.** (06.08.: 537+129=666;
Schrumpfung durch dieselbe csv_cell_reader-Extraktion.)

**Mathematischer Kern:**
- Abszisse fest **log2(x)** (Cache-Hierarchie-Modell; x=0 ist InvalidData);
  `fit_log_linear` = kleinste Quadrate y=a*log2(x)+b mit residual_rms -- **der einzige
  Regressions-Fit der ganzen Trias**.
- Splines: natuerlicher kubischer Spline (m2-basiert, Thomas) UND eine **eigene
  Fritsch-Carlson-KOPIE** (curve_fit.hpp:276-311, woertlich *"hier als eigene builder-Kopie
  portiert"*). Das Verfahren ist ein **Runtime-Enum-Feld** (`AxisSpline::Interp`, eval_log2
  verzweigt zur Laufzeit) -- im Kontrast zur CT-Strategy von [1]. Extrapolation LINEAR mit
  Rand-Steigung.
- `spline_intersections`: Raster (256 Samples) + Bisektion + y_tol-Band; liefert NUR
  Schnittpunkte, **richtungs-blind** (kein links/rechts-Besser).
- `DecisionLambdaTree` (decision_lambda_trees.hpp): CurveCandidate -> Fit (Default
  fit_monotone_cubic_spline, compile-time durchgereichtes Callable) -> `decide()` = Kandidat mit
  minimalem Modellwert (**hart "kleiner=besser"**, T-9 NICHT nachgezogen) + `thresholds()` ueber
  paarweise Schnittpunkte.
- CSV: `parse_wide_csv_column` liest EINE Spalte je Aufruf (kein Gruppen-Loader); nicht-numerische
  Zellen werden gezaehlt uebersprungen (streng-numerisch via csv_cell_reader), aber ohne
  deklarierte D1-Token-Liste.

**Konsumenten (Gegenprobe 17.08.):** **0 Produktions-Konsumenten.**
`#include`-Kanten auf curve_fit.hpp: genau decision_lambda_trees.hpp:19 + 2 Tests;
auf decision_lambda_trees.hpp: genau 1 Test. Das CMake-INTERFACE-Target
`comdare_decision_lambda_trees` (der **einzige CMake-angebundene Baustein der ganzen Familie**)
wird von genau EINEM Ziel gelinkt: `test_hybrid_spline_selector_scaffold`
(tests/unit/CMakeLists.txt:4687) -- Gegenprobe ueber alle CMakeLists: keine weitere Verlinkung.

**Testdeckung:** `test_phase6_vorbau.cpp` (142 Z., fit_log_linear-Honest-Doktrin) +
`test_hybrid_spline_selector_scaffold.cpp` (249 Z., Spline/Schnittpunkte/Baum, ausdruecklich
**synthetische** Kurven, #156-DATA-gated); beide main()-Style mit add_test.
**Keine Lock-Wache** (axis_version.lock: 0 curve_fit-/builder-Eintraege, Gegenprobe grep).

**Kanon-Bilanz:**
- PRO: einziges Regressions-Werkzeug (fit_log_linear + residual_rms); log2-Modell passend zur
  Cache-Hierarchie-Interpretation; direkter End-zu-End-Pfad Kurve->Baum->Entscheid; Anbindung an
  das Registry-Vokabular (mm::MeasurementCategory); einziger CMake-Anker der Familie.
- CONTRA: Fritsch-Carlson als deklarierte KOPIE von [1] (Abschrift-statt-Aufruf-Muster);
  Besser-Semantik hart Minimize (fuer MAX-Zielgroessen falsch herum -- genau der Fehler, den T-9
  in [1] beseitigt hat); Runtime-Enum statt CT-Strategy (CT-Doktrin-Spannung); keine Lock-Wache;
  kein Par.75-Schutz (Kandidatenliste (42): curve_fit/ steht als Duenn-Verzeichnis OFFEN in der
  Aufraeum-Triage); log2-only (x=0 verboten); kein Gruppen-Loader.

---

## 4. Stack [3] -- best_binary_selector, Haelfte B (Skeleton-Block)

**Ort/Umfang (17.08. gemessen):** `libs/cache_engine/builder/best_binary_selector/` --
Deklaration best_binary_selector.hpp:360-470 (Skeleton-Kopf :360-382, `CurveSample`/
`PiecewiseCurve` :384-408, `BreakEvenPoint` :419, **`find_break_evens` :443**,
**`break_even_table` :458**) + Implementierung best_binary_selector.cpp:560-754
(PiecewiseCurve :560-623, find_break_evens :625-668, select :670-688, break_even_table :690-752).
Zusammen **~306 Z.** (06.08.-Schaetzung "~500" nahm den Block breiter). Die vom Auftrag genannte
Spanne ":443-458" ist exakt der Deklarations-Kern der Haelfte B.

**Mathematischer Kern:**
- `PiecewiseCurve`: **stueckweise LINEAR** ueber synthetischen Stuetzstellen (kein Spline; die
  Kommentare :371-376 deklarieren selbst: in S7 speist der engine-seitige Spline dieselbe
  eval()-Kontur, der Finder ist modell-agnostisch, der Tausch ein Drop-in).
- `find_break_evens`: Raster (256) + Bisektion, aber Vorzeichenwechsel mit **exaktem d==0.0**
  (kein Toleranzband -- Gleitkomma-blind, im Kontrast zu y_tol in [1] und [2]);
  winner_below/above hart "kleiner=besser".
- `break_even_table`: **n-aerer Leader-Wechsel-Scan ueber die GANZE Kandidatenmenge**
  (leader_at je Rasterpunkt, Bisektion am Wechsel) -- die einzige Stelle der Trias, die
  Fuehrungswechsel nicht nur paarweise bestimmt. `SelectionObjective` als austauschbare
  Kosten-Strategy (Default Identitaet).
- Self-contained-Doktrin: NUR C++17-Standardbibliothek, keine Engine-Kopplung;
  decision_lambda_trees.hpp:10-11 deklariert die Duplikation woertlich: der Selector traegt
  *"eine std-only Spiegelung derselben Rueckwaerts-Wahl"*.

**Konsumenten (Gegenprobe 17.08.):** **0 Produktions-Konsumenten -- sogar das eigene CLI ruft
Haelfte B nicht:** best_binary_selector_main.cpp hat literal **0 Treffer** fuer `find_break_evens`
und 0 fuer `HybridBinarySelector` (das Tool `comdare_best_binary_selector` faehrt nur Haelfte A =
Parse/Rank/Ship). Einziger Konsument der Haelfte B ist `test_hybrid_spline_selector_scaffold.cpp`.

**Testdeckung:** Haelfte B nur ueber den Scaffold-Test (synthetisch);
`test_best_binary_selector_parse_rank.cpp` (311 Z.) deckt Haelfte A + ABI-Spiegel-Paritaet
(kAbiMajor/kAbiMagic), nicht die Break-Even-Mathematik. Keine Lock-Wache; Kandidatenliste-75
X-33 (:329): `best_binary::BreakEvenPoint` ist self-declared SKELETON und **ungeschuetzt** --
ausdruecklich im Kontrast zum Par.75-geschuetzten `heuristik::BreakEvenPoint`.

**Kanon-Bilanz:**
- PRO: n-aerer Leader-Scan (fehlt [1] und [2]); Objective-Strategy; sitzt im selben Modul wie der
  reale Versand-Pfad (Haelfte A: RankedBinary/ShippedArtifact mit REV-DATA-05/-06-Haertung).
- CONTRA: linear statt Spline (Modell-Platzhalter laut eigener Doku); d==0.0 exakt statt
  Toleranzband; hart Minimize; synthetische Stuetzstellen; selbst-deklarierte Spiegelung;
  ungeschuetzt; nicht einmal vom eigenen CLI konsumiert.

---

## 5. Die drei Stacks nebeneinander (Kurzform)

| Kriterium | [1] heuristik/ | [2] curve_fit + dlt | [3] Selector Haelfte B |
|---|---|---|---|
| Zeilen heute (06.08.) | 642 (636) | 628 (666) | ~306 (~500) |
| Kurvenmodell | kubisch, CT-Strategy, Original-x | kubisch, Runtime-Enum, log2(x) | stueckweise linear |
| Monotonie-Schutz | Fritsch-Carlson ORIGINAL + Begruendung | Fritsch-Carlson KOPIE | keiner |
| Besser-Richtung | **Katalog (T-9): MIN/MAX je Zielgroesse** | hart MIN | hart MIN |
| Schnitt-Toleranz | y_tol + sign_tol | y_tol-Band | d==0.0 exakt |
| Mehr-als-2-Kandidaten | nein (paarweise) | paarweise Schwellen | **n-aerer Leader-Scan** |
| CSV-Zugang | Gruppen-Loader, 2 Dialekte, D1-Tokens | 1 Spalte je Aufruf | keiner (synthetisch) |
| Exklusiv-Substanz | Richtungs-Kanon, Loader | **fit_log_linear (Regression)** | Leader-Scan |
| Produktions-Konsumenten | 0 (Gegenprobe) | 0 (Gegenprobe) | 0 (auch CLI: 0/0) |
| Tests | 18 TESTs + 2 Token-Tests | 2 (synthetisch) | 1 (synthetisch) |
| Lock-Wache | **ja (6 Header)** | nein | nein |
| Par.75 | **geschuetzt (S-1)** | offen (42) | ungeschuetzt (X-33) |
| Plan-Deckung | soll_design:194 (HY-B2) + HY-C-T-1 | -- | S7-Adapter-Vermerk |

---

## 6. FRAGE (a) = E-5: Welcher Stack ist kanonisch?

**STAND:** Alle drei rechnen dieselbe Rueckwaerts-Wahl; 0 Produktions-Konsumenten (dreifache
frische Gegenprobe); nur [1] ist plan- und schutzgedeckt (soll_design:194; LEDGER:3602-Familie;
Kandidatenliste S-1), nur [1] traegt den T-9-Richtungs-Kanon und die Lock-Wache; der einzige
CMake-Anker der Familie sitzt auf [2]; die einzige n-aere Fuehrungswechsel-Logik sitzt in [3];
das einzige Regressions-Werkzeug (fit_log_linear) sitzt in [2]. Der Hybrid-Bauplan HY-C setzt als
Tag-1-ROT-Test die Typ-Identitaet auf [1] (`test_hy_router_konsum`) und nennt den heutigen Bruch
"[3] konsumiert [2] nicht" als einzig ungedeckte Stelle. Ohne Entscheid entscheidet der
Par.75-Aufraeumpass implizit ([1] geschuetzt, [2]/[3] nicht) -- *"der teuerste Ausgang"* (E-5).

**EMPFEHLUNG:** **[1] heuristik/ als kanonischen Break-Even-Spline-Stack setzen.** Konkret:
1. [2] wird KONSUMENT, nicht geloescht: `DecisionLambdaTree` bleibt (samt CMake-Anker), sein
   Kurven-Traeger wird `heuristik::AxisSpline` (Adapter); die builder-Kopie von Fritsch-Carlson
   und der eigene Schnittpunkt-Finder werden deprecatet (Abschrift-statt-Aufruf aufloesen).
   `fit_log_linear` bleibt als eigenstaendiges Regressions-Werkzeug erhalten (Exklusiv-Substanz,
   kein Break-Even-Duplikat).
2. [3] Haelfte B wird nach dem HY-C-/Orchestrator-Bau auf ihre selbst-dokumentierte Bestimmung
   zurueckgebaut: die eval()-Kontur wird vom Engine-Spline gespeist (S7-Adapter am Engine-Rand);
   der n-aere Leader-Scan wird dabei auf [1]-Konsum portiert, NICHT weggeworfen. Haelfte A
   (Parse/Rank/Ship) bleibt unberuehrt -- ihr Umbau ist der getrennte D2c-Bau-Rest (Abschnitt 8).
3. Der T-9-Richtungs-Kanon gilt fuer ALLE kuenftigen Break-Even-Konsumenten; die harten
   Minimize-Annahmen in [2]/[3] duerfen nicht in den Router wandern.
4. Vollzug als W2-Posten im Umfeld des Staffelungs-Designs; bis dahin haelt die Par.75-Sperre.

**WENN OFFEN:** Der Par.75-Pass waehlt implizit und unsichtbar; HY-C baut auf ungewaehltem Stack
(sein T-1 bleibt der einzige, ungedeckte Anker gegen den dokumentierten Bruch); jeder weitere
Bau-Tag vergroessert einen der drei Staende und verteuert die Zusammenfuehrung.

**GEGENLESE EMPFEHLUNG gegen STAND (4 Proben):**
1. Plan-/Schutz-Deckung zeigt ausschliesslich auf [1] -- die Empfehlung folgt dem Stand, kein
   Widerspruch gefunden.
2. Einziger Stand-Punkt, der scheinbar GEGEN [1] spricht: der einzige CMake-angebundene
   Entscheidungsbaum sitzt auf [2] (S-2). Die Empfehlung loest das auf, statt es zu verlieren:
   [2] bleibt als Konsument bestehen, der CMake-Anker wird Anschlusspunkt.
3. Exklusiv-Substanz der Nicht-Kanon-Staende ist benannt und wird erhalten (fit_log_linear,
   Leader-Scan, log2-Sicht als Adapter-Option) -- kein stiller Verlust.
4. Richtungs-Probe: T-9 ist am Objekt NUR in [1] vollzogen. Jede Empfehlung fuer [2] oder [3]
   muesste den Richtungs-Kanon dort ein drittes Mal bauen -- das waere die Verdreifachung, die
   diese Frage beenden soll.

**Kenntnisnahme (keine neue Frage):** Die Traeger-Zuordnung von heuristik/ (Zielstruktur #29
Par.6.2: Default HYBRID Stufe 4; Planer-Mitnutzung der Break-Even-Bereichskarte KON7-05 offen)
ist ORTHOGONAL zu E-5 -- ein JA zu [1] aendert keine Traeger-Kante; wird die Bereichskarte
Planer-seitig konsumiert, ist die im #29 vorgesehene Hebung des Heuristik-Anteils in den
Querschnitt der vorgezeichnete Weg.

---

## 7. FRAGE (b) = K4: Bekommt mess/ eine eigene S-Position? (GETRENNT beantworten)

**STAND:** Die #29-Besitzkarte (docs/plaene/20260813-DESIGN-zielstruktur-vier-traeger-unterprojekte.md,
Zeile 65, V14: Abschnitt 2a) ordnet zu: `mess/` (6 Dateien / 1.140 Z.: genus_kaskade, steuer_dock,
mess_naht) -> **TIER (Stufe 3)** als Tier-Laufzeit-Messkaskade (Flaeche 3); die geteilten
Naht-TYPEN -> Querschnitt. Par.6.3 verbatim: *"mess/-Schnitt: Default Kaskade->TIER, geteilte
Naht-Typen->Querschnitt (loest K2); Zeitpunkt der Typ-Hebung: mit #18/S-13 oder erst #88."*
Der Par.6-Kopf stellt klar: *"Default-Vorschlag steht, Bau laeuft; **Owner kann drehen**."*
Hintergrund K2 = der einzige Zyklus an der Grenze: builder<->mess, 3 Kanten
(checkpoint_measure.hpp:48 -> mess/konfiguration.hpp; konfiguration.hpp:58 -> mess_arena.hpp;
mess_naht.hpp:40 -> checkpoint_measure.hpp) -- egal wie mess/ zugeordnet wird, EINE Haelfte ist im
Zielbild verboten, nur die Typ-Hebung loest beide. K4 wurde als Frage nie gestellt (D-2(b) der
20er-Vorlage); KON107-03 Frage 3: *"#29-Default bestaetigen (Kaskade=Tier, Naht-Typen->Querschnitt)
ODER eigene S-Position?"*

**EMPFEHLUNG:** **#29-Default bestaetigen: Kaskade -> TIER, Naht-Typen -> Querschnitt; KEINE eigene
S-Position.** Begruendung: (i) das Owner-Wort 12.08. (KON43) setzt VIER Traeger-Unterprojekte
*"in der Reihenfolge und nicht anders"* -- eine eigene mess/-S-Position waere ein fuenftes Glied
gegen dieses Wort; (ii) mess/ ist Laufzeit-Substanz des Tier-Laufs (Flaeche 3), kein eigener
Traeger; (iii) den realen Schmerz (K2-Zyklus) beseitigt die Typ-Hebung in den Querschnitt, nicht
eine neue Stufe. Zeitpunkt der Typ-Hebung: **mit #18/S-13 (W2, Di 25.08.)**, nicht erst #88 --
weil #13 (T-15b) und #18 ohnehin an der measure_storage-Naht bauen und der #29 beiden Tasks die
Auflage "Knoten nicht verdicken" (R2) mitgegeben hat.

**WENN OFFEN:** Der K2-Zyklus bleibt stehen, #18/S-13/#13 bauen in W2 an einer ungeklaerten Naht,
und jede Grenz-Wache der Traeger-Struktur muss die mess/-Kanten als Sonderfall ausnehmen.

---

## 8. BEREITS ENTSCHIEDEN -- NICHT Teil dieser Frage

Zur Abgrenzung, damit die Trias-Frage nicht wieder mit den Statistik-Fragen vermengt wird:

- **Perzentil-Kanon (D2a): ENTSCHIEDEN + GEBAUT + LIVE seit 09.08.** -- latency_stats.hpp:26-34
  traegt den Selbstcheck "EINZIGE Umrechnung" (c98b4b95, seither unangefasst);
  percentile_canon.hpp delegiert. Kein Teil von E-5.
- **Sieger-Semantik (D2c): ENTSCHIEDEN** (dreifach konvergent 05./06./09.08.): Sieger JE
  EINGANGSLAST, mehrere gleichzeitig. Der scheinbare "Fork" ist BAU-RUECKSTAND
  (best_binary_selector/rank_binaries noch nicht auf je-Last-Sieger + Front-Ausgabe umgebaut),
  keine offene Design-Frage.
- **REV-DATA-12 = Bau-Rest:** der Selector haelt eine wertgleiche EIGENE Perzentil-Formel
  (Abschrift-statt-Aufruf) -- wird im D2c-Umbau miterledigt, beruehrt die Spline-Frage nicht.
- **HDR-Rolle:** Kanon-Zweistimmigkeit steht (Hauptkapitel HDR, Anhang nearest-rank); der
  HDR-Header hat 0 Produktions-Konsumenten; Owner D-6 (17.08.): Altzahlen MARKIEREN +
  Neu-Erhebung mit der Kampagne PFLICHT; die HDR-Verdrahtung (Wellenplan-D5-5) muss VOR der
  Kampagne stehen (NP-43). Alles D-6-Strecke, nicht E-5.

---

## 9. Beleg-Anker (Auswahl, V14: ueber Abschnitt ansteuern)

- Trias-Zitat + Stack-Tabelle 06.08.: docs/plaene/20260806-PLAN-messkurven-synthese-und-hybrid-binary.md:326-345, S-2 :429, F-2 :736
- Hybrid-Bauplan: docs/plaene/20260809-HYBRID-bauplan-und-entscheidungsvorlage.md:17 (Trias), HY-C + E-5 (Abschnitte IV/VII)
- Owner-Verbatim D-2 + Konsequenz: Ledger KON104-01/KON104-02; finale Fragenliste: KON107-03 (Fragen 2+3)
- Stack [1]: ce libs/cache_engine/heuristik/{axis_spline,break_even,measurement_curve_loader}.hpp; Katalog axis_optimization_catalog.hpp; Lock tools/axis_version_lock/axis_version.lock:193-208
- Stack [2]: ce libs/cache_engine/builder/curve_fit/curve_fit.hpp (:276-311 Kopie-Deklaration); builder/decision_lambda_trees/decision_lambda_trees.hpp (:10-11, :19); Target-Konsum tests/unit/CMakeLists.txt:4687
- Stack [3]: ce libs/cache_engine/builder/best_binary_selector/best_binary_selector.hpp:360-470 (:443/:458) + .cpp:560-754; CLI-Nichtkonsum main.cpp 0/0; X-33 docs/plaene/20260808-KANDIDATENLISTE-75-abschluss-aufraeumpass.md:329, S-1 :92
- K4: docs/plaene/20260813-DESIGN-zielstruktur-vier-traeger-unterprojekte.md:65 (Besitzkarte mess/), :175-183 (Par.6-Kopf + 6.3), K2-Kanten Abschnitt 3c; Ledger-Kopf :57 ("Owner kann drehen", Par.6.3)
- Abgrenzungen: Ledger KON105-02-Umfeld (D2a/D2c/REV-DATA-12/E-4), KON106-05 (D-6/HDR)
