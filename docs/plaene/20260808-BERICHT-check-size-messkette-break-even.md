# BERICHT AN DEN OWNER — 08.08.2026

**Gegenstand:** die vier Auftraege aus deiner Nachricht, die Mess-Kette (3 Stufen / 6 CEBs), die beiden Break-Even-Implementierungen, und der Entwurf fuer `--check-size`.
**Pruefstand:** ce = `origin/development`, super = `wt-super-landung` (Ledger, plaene/, sessions/). Alles unten mit Datei:Zeile belegt oder ausdruecklich als unsicher markiert. Ich habe nichts geaendert.

---

## 1. DIE VIER AUFTRAEGE, DIE SCHON ERTEILT WAREN

### (a) Paper-Research → ein Paper = ein Experiment-XML

**Der Auftrag existiert, und zwar seit drei Monaten, in vier Etappen.** Du hast recht mit „Ich habe dich angewiesen" — hier sind die Stellen:

| Datum | Quelle | Owner verbatim (gekuerzt) |
|---|---|---|
| **13./14.05.** | `super STRUCTURAL_CORRECTION_diplomarbeit.md:102` | *„Ich vermisse in der CacheEngine einen Ordner, in dem alle Suchalgorithmen mit ihrer Gesamtkonfiguration als XML/json persistiert sind, sodass die in der CacheEngine einzeln persistierten Algorithmusbestandteile durch die **Permutationsbeschreibung wiederherstellbar** sind."* |
| **27.05.** | `ce docs/architecture/17_paper_kartografie_r7_6.md:9-13` | *„Alle Achsen, die nicht auch eine erweiterte wissenschaftliche Recherche zu jedem Algorithmus einbezogen haben, muessen diese nachholen. Die Paper muessen gefunden und nach topics und Achsen im paper Ordner katalogisiert werden."* |
| **08.06.** | `ce docs/architecture/32_lastprofil_katalog_und_paper_bias.md:3-6` | *„Jedes Paper waehlt ein Lastprofil, das SEINEN Algorithmus gut dastehen laesst"* → alle Lastprofile ueber alle Achsen |
| **20.07.** | `super Ledger:3212` (U-8-③) | *„jedes Paper ist ein eigener Pruefling, der den Stand der Technik ergaenzt (voll-template-split spaeter in der Cache Engine nach Paper Definitionen und echtem code der nach Achsen vorsortiert ist)"* |

Der Satz vom 13.05. **ist** dein Satz vom 08.08. („die compile time stellt aus dem gesplitteten Entwurfsmuster die original binary des Paper-Experimentes wieder her"), nur in der Sprache vom Mai. Die ce-Doku fuehrt ihn selbst als Anlass: `libs/cache_engine/algorithm_profiles/README.md:3-8`.

**Was daraus wurde — mehr als ich zuletzt behauptet habe:**
- **33 SOTA-Profile** `algorithm_profiles/sota/*.profile.xml`, `paper_ref="P01"`..`"P33"`, lueckenlos, jede Nummer genau einmal (nachgezaehlt). 30 seit 14.05., die letzten 3 (P08/P09/P33, `pruefling_type="abstract"`) seit 04.07.
- **23 Allokator-Profile** (A01–A23) mit Abdeckungs-Gate `test_profile_coverage`.
- **21 Lastprofile**, davon 5 paper-spezifisch (`coco_p04_neg{0,25,50,75,100}.xml`, `paper_ref="P04"`).
- **21 × `PAPER_REFERENCES.md`** (je Achse), Doku 17 (Kartografie 33 Paper), Doku 18 (Web-Recherche ueber ~110 Wrapper), Doku 32 (Lastprofil-Katalog).
- **Vendorter Original-Code:** 17 `ext/**/paper_*`-Baeume, 12 `ext/traversal/P01..P30`, 22 Adapter mit `paper_id()`.

**Was NICHT wurde — der letzte Schritt, genau deiner:**
1. **Es gibt kein einziges Experiment-XML je Paper.** Die sota-Akten tragen die Wurzel `comdare_algorithm_profile` — ein anderes Schema als `comdare_experiment` (Planer-Eingang) und `comdare_thesis_profile` (Messpfad). Suche nach `comdare_experiment` liefert in ce **genau 2** Dateien (`tests/unit/thesis_tiere/experiment_golden.xml`, `experiment_golden_kern.xml`), in super 7 (2 kanonisch, 2 Submodul-Spiegel, 3 deprecated). *Gegenprobe bestanden — das Muster greift, die Null je Paper ist real.*
2. **Der Zeiger vom Profil auf die Paper-Akte wird geparst und nie dereferenziert.** `<tier ... profile_ref="../sota/art.profile.xml">` wandert in `ThesisTier::profile_ref` (`xml_config_parser.cpp:284`) — und wird an **keiner** Stelle im ce-Code gelesen. Der Baum-Adapter nimmt nur `t.id` (`profile_to_tree.hpp:49`), der Validator nur `t.id`. *Gegenprobe: `base_tiers` findet 8 Fundstellen mit echten `t.id`-Konsumenten — die Null bei `profile_ref` ist kein grep-Artefakt.*
3. **Und die tier-Ebene wird im produktiven Lauf abgezogen:** `drop_tier_level` (`profile_runner.hpp:117`). Die 7 `base_tiers` erzeugen keine Binaries.
4. **Zwei Vokabulare ohne Naht:** die Paper-Akte sagt `SPARSE_NODE4_ART` (`abi/baustein_variants.hpp:99-103`), die Kompositions-Registry sagt `node4`. Keine Abbildung im Code.

**Reifegrad:** Stufe 1 (Recherche je Paper) fertig · Stufe 2 (Achsen-Konfiguration je Paper als XML) fertig, 33/33 · **Stufe 3 (diese XML als lauffaehiges Experiment) nicht gebaut — und seit 20.07. als „post-v3" geparkt** (`Ledger:3185`, `[§59-TEMPLATE] ... (OFFEN, mittel — post-v3.)`). Genau dort ist der Faden gerissen: du hattest GO gesagt, der Ledger hat vertagt.

### (b) Groesseren Satz bauen, nur einen Teil messen

**Der Auftrag ist datiert und woertlich da.** `Ledger:2411-2416`, **19.07.2026** (§41, GN-11-Entscheid) — das ist genau „vor einigen Wochen":

> *„Wir **bauen alles new golden** und **messen alles mit der 320er**. Wir **messen new golden ab dem 01.08.** Bis Freitag muessen wir nur nachweisen, dass wir **alles bauen** und **das Meiste CI und lokal messen** koennen."*

Bestaetigt am **06.08. abends** (`Ledger:5037-5038`, verbatim):
> *„nur weil sie kompiliert werden sollten, heisst es nicht dass sie auch gemessen werden muessen, das muss die XML **getrennt fuer build und Messung** definieren koennen sonst regression."*

**Stand des Baus:** Der XML-Kanal, der Bau-Menge von Mess-Menge trennt, **existiert nicht.** Die XML sagt es selbst (`super Code/test_data_xml/experiment_golden_kern.xml:270`): *„Diese XML deklariert also die BAU-Menge, der Planer die MESS-Menge."* Laufzeitseitig gibt es nur `provision_only` + `golden_range_start/count` (`profile_run_entry.hpp:209-213`) — ein Fenster, keine Deklaration. Der Posten steht als N-6/T2 im Ledger (`:5054-5056`), ungebaut.

**Ein offener Widerspruch, den ich nicht selbst aufloesen darf:** am **07.08.** hast du entschieden (`Ledger:7342`): *„Wir bauen **nur die 320er** die wir auch tatsaechlich messen und stellen die golden XML darauf um."* Das sagt Bau-Menge == Mess-Menge. Deine Nachricht vom 08.08. sagt das Gegenteil. → **Entscheid D-5** unten.

### (c) Full join je Achse ueber alle Paper

**Der Begriff existiert im Code — aber fuer eine andere Sache.** `Stufe3_FullJoin` ist einer von drei Pruefling-Merge-Modi (`pruefling_merge.hpp`; Schema `thesis_profiles/SCHEMA.md:32`): er beschreibt den Join **CacheEngine ∪ PRT-ART-Pruefling**, nicht den Join **ueber Paper**. Im golden-Profil steht er als `<sota_series id="B" lebewesen="…" merge="Stufe3_FullJoin"/>` fuer 7 Lebewesen (`all_axes_golden.profile.xml:102-108`).

**Der Full Join, den du meinst — „je Achse ueber alle Achsen, zusammengelegt ueber alle betrachteten Paper" — ist NICHT gebaut.** Er ist aber im Ledger bereits als deine Kern-Idee gebucht (Nachtrag 08.08., `Ledger:10935ff`) und du hast ihn im selben Zug praezisiert: *„sequentiell JEDE Achse einzeln durch-permutieren, ob nicht die Algorithmen der Anderen Paper in dieser Achse besser gewesen waeren"*. Das ist die Geschwister-Vergleichs-Ordnung im Experiment-B+-Baum. Sie ist die eigentliche **Mengen-Reduktion**: nicht das Achsenraum-Produkt, sondern je Achse ein Sweep bei identischem Nachfolge-Pfad.

Der Code hat dafuer bereits eine Form, aber ohne Paper-Bezug: `source_catalog.hpp:322-323` — *„Je vertiefte Achse ein Sweep-Katalog: identisch zur Baseline, ABER genau EINE vertiefte Achsen-Slot-Liste = die VOLLE Enabled-Liste."* Das ist mechanisch genau dein Geschwister-Vergleich; ihm fehlt nur, dass die Baseline aus einer **Paper-XML** kommt.

### (d) `--check-size` „wie geplant"

**Hier muss ich ehrlich sein: einen frueheren Auftrag dafuer gibt es nicht.** Nullbefund, 5 Muster ueber `super docs/` und `Code/`: `check-size` (1 Datei = der Ledger-Nachtrag von heute), `check_size` (4, alle heute), `checksize` (7, alle heute), `vorraussichtlich` (1, dein Zitat), `voraussichtlich` (25, alle in anderer Sache). **Gegenprobe:** `emit-tier-ci` → 109 Dateien. Das Verfahren findet also, wenn es etwas gibt.

**Meine Lesart deines „wie geplant":** es bezieht sich nicht auf einen frueheren `--check-size`-Auftrag, sondern auf *„aus einer XML Datei **wie geplant**"* — also auf die geplante XML-Form. Wenn du etwas anderes meintest, sag es; dann habe ich eine Stelle uebersehen.

**Was aus dem Bestand wiederverwendbar ist (das ist der Grund, warum das ein kleines Paket ist):**
- `PlanSizeBuilder` (`experiment_plan_director.hpp:417`) — ein Builder, der *„NICHTS emittiert, sondern nur die Groesse des Plans zaehlt"*, am **selben** deterministischen Walk wie `plan dump/ci/cmake`. Einziger heutiger Aufrufer: das Startgate (`profile_run_facade.cpp:1061`), und das fragt nur „leer ja/nein".
- **Die eine echte Luecke im Zaehlwerk:** `PlanHeader::profile_value_count` ist laut Kopf-Kommentar (`:165-166`) *„die **Summe** ihrer `<value>`-Eintraege"*. Aus einer Summe folgt keine Permutationszahl. Es fehlt genau ein Produkt je Achse.
- `projiziere_kampagne` / `kampagnen_zeile` (`eta_kalibrierung.hpp:297` / `:350`) — die Kampagnen-Projektion (Wandzeit, Rechenzeit, Bytes) ist **fertig und hat bis heute keinen Aufrufer**.

---

## 2. DIE MESS-KETTE, WIE DU SIE MEINST — UND WAS DAVON STEHT

### Die drei Stufen, in meinen Worten

**Stufe 1 — Micro, am Achsen-Algorithmus.** Zwei Checkpoints umklammern **eine** Achsen-Ausfuehrung. Der erste bindet die *angewendeten Achsen-Parameter* an einen Wallclock-**Zeitpunkt** VOR dem Algorithmus, der zweite an einen Zeitpunkt DANACH. Das Messobjekt ist nicht „wie lange dauert Achse T im Mittel", sondern **ein Paar (Parameterzustand, Zeitpunkt)** — daraus wird spaeter die Kurve ueber die Zeit.

**Stufe 2 — Macro, am Gattung+Genus-Interface.** Dieselbe Klammer, aber um **einen Interface-Funktionsaufruf** — und mit **Akkumulation ALLER in diesem Aufruf verwendeten Achsen-Parameter**. Das Messobjekt ist eine Interface-Funktion mit ihrem vollstaendigen Achsen-Fussabdruck.

**Stufe 3 — Combined Load, am Tier-Binary-Interface.** Gesamt-Akkumulation ueber **gemischte Zugriffsmuster**: die CEB faehrt einen Gesamt-Last-Test gegen eine Tier-Binary ueber **multiple** Macro-Benchmarks. Das Messobjekt ist ein Lastprofil, nicht ein Aufruf.

Die drei sind **gestaffelt**: Stufe 2 aggregiert Stufe-1-Klammern, Stufe 3 aggregiert Stufe-2-Klammern.

### Die 6 CEBs — die Differenzmessung

Jede der 3 Messeinrichtungen kostet selbst Latenz. Wer nur mit allen dreien misst, misst immer Messwert + Messapparat. Deshalb wird **dieselbe Kette** in mehreren CEB-Bauten gefahren, in denen einzelne Messgeraete **ein- bzw. ausgebaut** sind; die Differenz der Gesamtzeiten zweier Bauten, die sich nur in einem Geraet unterscheiden, **ist** der Latenzbeitrag dieses Geraets. Deine Zahl: 3! = 6 CEBs.

### Ist-Stand — Schicht fuer Schicht

| Deine Stufe | Was im Code am naechsten liegt | Verdikt |
|---|---|---|
| Stufe 1 (Micro, Checkpoint-Paar je Achse) | **G3 FEINKORN** = `fill_segment_timing_v3`, die 18 `seg_ns`-Timer (`abi_adapter.hpp:1784-2057`) | **misst etwas anderes.** Das ist ein **separater, nachgelagerter Ersatzlauf** *innerhalb* von `tier_observe()`: Warmup + `batches × n_ops` **synthetische** Ops je Achse. Er beantwortet „wie lange dauert eine kuenstliche Op dieser Achse auf der gefuellten Struktur", nicht „wie lange lief Achse T waehrend des gemessenen Laufs". `seg_ns` sind **aufsummierte Dauern, keine Zeitpunkte** |
| Stufe 2 (Macro, Gattung+Genus-Eintritt, Achsen-Akkumulation) | `GenusObserverAggregate<G,N>` traegt `axis_stats[N][8]` **und** `seg_ns[N]` | **ungebaut, und ehrlich als ungebaut markiert.** Alle vier Einsammler schreiben `seg_ns` hart auf `-1`: `set_tier_v2.hpp:136`, `sequence_tier_v2.hpp:125`, `adapter_tier_v2.hpp:118`, `view_tier_v2.hpp:96` (`for (…) out.seg_ns[t] = -1;`). Kein 0-Phantom — aber auch keine Zeit. Und die Akkumulation haengt an einem `observe`-Aufruf, nicht am Funktions-Eintritt |
| Stufe 3 (Combined Load) | **G1 BASIS-ZEIT** = `run_workload`, ein aeusserer `steady_clock` je Batch (`abi_adapter.hpp:589ff`) | **eine Batch-Gesamtzeit, kein Lastprofil-Aggregat ueber multiple Macro-Benchmarks** |

**Drei harte Zusatzbefunde:**

1. **„Checkpoint" bedeutet im Code etwas anderes.** Er existiert — als **Fuellstands**-Checkpoint (10/100/1000 Elemente, `genus_tier_observe_trace_abi.hpp:61/:97/:140`). Dort werden Achsen-Parameter tatsaechlich mitgeschrieben (ein voller Observer-POD je Checkpoint) — aber dieser Treiber haengt **nicht** im Produktionspfad: Aufrufer sind nur `apps/f15_compare/main.cpp:245` und `pruef_dock/search_algorithm_dock.hpp`. Der Produktionspfad zieht **genau ein** `tier_observe` am Lauf-Ende und schreibt **eine** CSV-Zeile je Binary — ohne Checkpoint-Spalte, ohne Zeitstempel-Spalte.
2. **Es gibt keine Wallclock.** Du sagst zweimal „wallclock time Zeitpunkt". Der gesamte Mess-Pfad nutzt `std::chrono::steady_clock` (monoton, **kein** Wandkalender). `system_clock` kommt in `libs/` + `apps/` **genau zweimal** vor, beide **ausserhalb** der Messung: `bestandslog_lock.hpp:78` und `in_memory_measurement_buffer.hpp:71`. Ein absoluter Zeitpunkt wird nirgends persistiert. Fuer eine Kurve **ueber die Zeit** mit einem Basispunkt bei 0 ist das der entscheidende Mangel.
3. **Parameter und Zeit stammen aus verschiedenen Fenstern.** `tier_observe` liest die Achsen-Zaehler VOR dem Segment-Lauf, misst dann `seg_ns`, liest T17 DANACH (`abi_adapter.hpp:2071-2095`). Das ist kein Checkpoint-Paar — das sind zwei Fenster in einem POD.

### **Die Messfehler-Herausrechnung: nirgends gebaut, nirgends geplant — und heute nicht baubar**

Das ist der schwerste Befund des Berichts.

**(i) Die Auffaecherungs-Maschinerie ist da und scharf:** `measurement_combos_of`, `ceb_combo_compile_define`, `--measurement-combo`, je Combo eine `ceb:build:[…]`-Strecke. Sie kann CEB-Varianten erzeugen.

**(ii) Aber nichts erzeugt die 6er-Menge.** Die Combos kommen ausschliesslich aus `<measurement_tooling><combo tools="…"/>`. Das golden-Profil deklariert **genau eine** Combo und nennt die frueheren drei Ein-Tool-Combos ausdruecklich einen Fehler (`all_axes_golden.profile.xml:220-226`): *„EINE Vollmengen-Combo {wallclock,macro,micro} = EINE vereinte CEB (Default…). Die frueheren 3 separaten Ein-Tool-Combos (3 CEB-Lanen) waren die F-3-Regression."*

**(iii) Schlimmer: es gibt heute nur ZWEI unterscheidbare Kompilat-Zustaende.** Die Naht schreibt ihre eigene Grenze hin (`profile_facade/mess_achsen_naht.hpp`, Ueberschrift woertlich **„EHRLICHE GRENZE DIESER SCHEIBE — macro UND micro SIND HEUTE NICHT TRENNBAR"**):
- G1 (Basis-Zeit) haengt an `COMDARE_MEASUREMENT_ON`
- **G2 (Observer) und G3 (Feinkorn) teilen sich EIN Gate** (`COMDARE_CE_ENABLE_STATISTICS`)
- *„Es gibt im gesamten anatomy/-Baum kein drittes Makro, ueber das man die Segment-Timer ohne die Observer-Zaehler (oder umgekehrt) entfernen koennte."*

Folge: `{macro}` und `{micro}` erzeugen **denselben Gate-Zustand**; sie unterscheiden sich nur im Deklarations-Define (das ist bewusst so gebaut, fuer Injektivitaet des Stempels, und ausdruecklich als „keine gebaute Trennung" markiert). **Und wallclock ist nicht ausbaubar**, weil G1 von jedem Tooling gezogen wird. → **Von deinen 6 CEBs sind heute maximal 2 herstellbar.**

**(iv) Die Differenz-Arithmetik existiert nirgends.** Nullbefund, 3 Muster ueber `libs/` + `apps/`: `ohne Messeinrichtung|ohne Messgeraet|uninstrumented|nulllauf|leerlauf_mess` → **0**; `ausgebaut` → 1 Datei, beide Treffer **Kommentar** in `meta_meta_identity.hpp` ueber GPU-Subsumption, unbeteiligt; `instrument.*overhead` → 4 Dateien, alle davon **innerhalb EINES Binaries** (`seg_framework_ns = seg_run_total_ns − Σseg_ns`, `experiment_tree.hpp:80`). **Gegenprobe:** `measurement_combo` → 27 Dateien. Die Suche greift.

Das Naechste, was existiert, ist `telemetry_mode.hpp:34` — *„Differenz zweier Snapshots (after − before) = das Diff-Mess-Ergebnis. NIE Mittelung — reine Subtraktion."* Das ist die Differenz zweier Zaehlerstaende **im selben Lauf**, nicht die Differenz zweier verschieden instrumentierter Bauten.

**Zusammengefasst: von deiner Mess-Kette steht heute die Bau-Mechanik fuer CEB-Varianten, aber weder die Checkpoint-Semantik, noch die Wallclock, noch die Stufe-2-Zeit, noch die Trennbarkeit der Messgeraete, noch die Differenzbildung.**

---

## 3. DIE BEIDEN BREAK-EVEN-IMPLEMENTIERUNGEN

Vorweg zwei Praezisierungen zum Bestand:

- **Es sind streng genommen drei Code-Orte**, nicht zwei: `heuristik/` (Engine), `builder/curve_fit/` (E4'-Vorbau) und `builder/best_binary_selector/` (self-contained Werkzeug). `curve_fit` und `best_binary_selector` gehoeren zusammen (der Selektor soll laut eigenem Kommentar in S7 vom `curve_fit`-Spline gespeist werden) — deshalb ist die Zwei-Teilung sachlich richtig, aber der `curve_fit`-Spline traegt bereits eine **Kopie** der Fritsch-Carlson-Mathematik aus `heuristik/` (`curve_fit.hpp:277`, *„hier als eigene builder-Kopie portiert"*). Die Doppelung ist also schon heute dreifach.
- **Du hast die Wahlfrage bereits beantwortet** (Nachtrag 08.08., `Ledger:10979`): *„Wir brauchen nur eine konsolidierte Implementierung, bitte fuehre beide zusammen und nach meiner Beschreibung zum Ziel."* Ich gebe deshalb keine Empfehlung zwischen A und B, sondern die Analyse plus die Delta-Liste zum Ziel.

### Gegenueberstellung

| | **A — `heuristik::`** (`axis_spline.hpp` + `break_even.hpp`) | **B — `best_binary::` / `builder::curve_fit`** |
|---|---|---|
| Dateien | `libs/cache_engine/heuristik/axis_spline.hpp` (261 Z.), `break_even.hpp` (197 Z.) | `builder/curve_fit/curve_fit.hpp` (537 Z.), `builder/best_binary_selector/*` |
| Herkunft | Paket W3-C, §32-F8 „Break-Even-Mathematik" | E4'-Vorbau 10.07. + Hybrid-Selektor-Skelett 20.07. |
| **Modell** | **monotone kubische Hermite (Fritsch-Carlson 1980)** als Default, `NaturalCubicStrategy` (C2, Thomas-Loeser) als Alternative — Wahl per **Compile-Time-Strategy + Concept** | `curve_fit`: **beides** (`Interp::NaturalCubic` / `MonotoneHermite`) + `fit_log_linear` (y = a·log2 x + b). `best_binary`: **stueckweise linear** ueber synthetischen Stuetzstellen |
| **Abszisse** | roher Parameter x (z.B. `working_set_n`) | **log2(working_set_bytes)** (`curve_fit`); reelle Last-Koordinate (`best_binary`) |
| Ordinate | `ns_per_op` / `total_cycles` | `ns_per_op` / modellierte Kosten |
| **Schnittpunkt-Verfahren** | Gitter = **Vereinigung beider Knoten** + Bisektion (100 Iter.), Toleranzband `sign_tol` | **festes Raster (256 Samples)** + Bisektion (60 Iter.), Toleranzband |
| **„Besser"-Richtung** | **aus dem Katalog**, compile-time (`OptimizationDirection`, `axis_optimization_catalog.hpp`); Pareto-Achsen (T5/T6/T18) verweigern per `static_assert` die Abkuerzung | **pauschal „kleiner = besser"** (`SelectionObjective::cost_of` = Identitaet) |
| Ausgabe | `BreakEvenPoint{x, y, links_besser, rechts_besser}` | `BreakEvenPoint{x, cost, winner_below, winner_above}` bzw. `SplineIntersection{x_bytes, x_log2, y}` |
| Honest-Empty | ja (`build()` → `nullopt` bei <2 Knoten) | ja (`FitStatus::NoData/InsufficientPoints/InvalidData`, `!valid()`) |
| **Datenquelle** | `heuristik/measurement_curve_loader.hpp` — **liest reale CSV** beider Dialekte (WIDE `;` und Snapshot `,`), robust gegen `n/a`/`failed`/`gesperrt` | `curve_fit` liest CSV dialekt-parametrisiert; `best_binary` ist **rein synthetisch** (self-contained, C++17-std-only, „KEINE Engine-Kopplung") |
| **Produktions-Aufrufer** | **KEINE.** `break_even.hpp` wird ausser von sich selbst nur von `tests/unit/test_heuristik_spline_break_even.cpp:19` inkludiert | `spline_intersections` wird von `decision_lambda_trees.hpp:102` gerufen (dessen einziger Konsument wiederum ein Test ist); `find_break_evens`/`break_even_table` nur aus `test_hybrid_spline_selector_scaffold.cpp` |
| Versionierung | `AXIS_ALGO_VERSION: 2` (T-9, 07.08.: Richtung aus dem Katalog statt pauschal — vorher fuer 15 von 19 Achsen-Zeilen **falsch herum**) | keine Algo-Version |

**Beide sind Skelette ohne Produktionslauf.** Beide sind aber sauber gebaut: honest-empty durchgezogen, Verfahrenswahl numerisch begruendet (Fritsch-Carlson gegen Overshoot, damit keine **Schein-Schnittpunkte** entstehen), Toleranzbaender statt `== 0.0`.

### Was zu deiner Beschreibung fehlt

| Deine Forderung | Ist | Delta |
|---|---|---|
| **„moeglichst scharfe Spline B=3"** = kubischer **B-Spline** | **nirgends.** Nullbefund ueber den ganzen ce-Baum, 6 Muster: `b-spline`, `bspline`, `b_spline`, `de boor`, `deboor`, `knotenvektor`, `knot_vector` → **0 Treffer**. Gegenprobe: `spline` → 9 Dateien in `libs/`. In `super docs/` erscheint „B-Spline" **nur** im Ledger-Nachtrag von heute, also in deinem eigenen Zitat | Beide vorhandenen Verfahren sind **interpolierende Hermite-/natuerliche Splines**, kein B-Spline-Basis-Modell mit Kontrollpunkten. Fachlich ist das ein anderer Ansatz: der B-Spline **approximiert** (und ist dadurch glatt und kompakt in wenigen Koeffizienten darstellbar), der Hermite **geht durch jeden Messpunkt**. Neubau, nicht Umbau |
| **String-Serialisierung + Parser** („als String gespeichert und wieder geparst und interpretiert") | **nirgends.** Nullbefund ueber `heuristik/`, `curve_fit/`, `best_binary_selector/`, 8 Muster (`spline.*serial`, `serial.*spline`, `to_string.*spline`, `parse_spline`, `spline_string`, `formel`, …) → **0**. Beide Modelle leben ausschliesslich als C++-Objekt im RAM | Komplett neu: eine Textgrammatik fuer die Funktion + Emitter + Parser + Roundtrip-Gate. **Das ist genau die Faehigkeit, die dein B-4-Satz braucht** (Break-Even lebt im RAM der CEB, wird auf Anforderung in LaTeX/PDF/xlsx gegossen) — ohne serialisierbare Funktion gibt es nichts zu giessen ausser Punkten |
| **Abszisse = Zeit** („um die gemessenen Werte **ueber die Zeit** auszudruecken", Stuetzstellen = „Zeitpunkt-Parameter-Checkpoints") | **beide Implementierungen haben x = Last/Working-Set**, nicht Zeit. `heuristik`: `x_col = "working_set_n"`. `curve_fit`: `x = log2(working_set_bytes)`. `best_binary`: „Last-Koordinate" | **Das ist der schaerfste Unterschied.** Deine Kurve laeuft ueber die **Zeitachse eines Laufs** (aus den Checkpoints), die vorhandenen Kurven ueber die **Lastachse ueber Laeufe hinweg**. Beide werden gebraucht (dein zweiter Satz vom 08.08. — *„bei welcher Last-Art und groesse die Memory Achse optimal laeuft"* — ist die Lastachse), aber sie sind nicht dasselbe Objekt → **Entscheid D-6** |
| **„Der erste Parameter-Messwert bildet im Ausgangszustand bei 0 die Basis"** | **nirgends.** Keine Normierung auf einen Nullpunkt in `axis_spline.hpp` oder `curve_fit.hpp`; ausserhalb der Domaene wird flach auf den **Randwert** geklemmt (A) bzw. mit Rand-Steigung extrapoliert (B) | Neu: eine definierte Verankerung f(0) = erster Messwert, plus die Frage, ob die Kurve **absolut** oder **relativ zur Basis** (Delta) ausgedrueckt wird |
| **Alle Messwerte + Checkpoints als Stuetzstellen** | die Stuetzstellen kommen heute aus **CSV-Endzeilen je Binary** — und die CSV traegt keine Checkpoint-Spalte und keinen Zeitstempel (siehe §2) | Die Datenquelle fuer deine Kurve **existiert noch nicht**. Das ist die eigentliche Reihenfolge-Abhaengigkeit: erst Checkpoints + Wallclock, dann B-Spline |

**Fazit dieses Abschnitts, ohne Empfehlung:** die Konsolidierung ist nicht „A gewinnt gegen B". Von A ueberlebt die **Richtungs-Semantik aus dem Katalog** und der **reale CSV-Lader**; von B ueberlebt das **Kandidaten-/Selektor-Interface** und der modell-agnostische Finder. Das **Modell selbst** (B-Spline B=3), die **Serialisierung**, die **Basis bei 0** und die **Zeitachse** sind in beiden nicht vorhanden.

---

## 4. `--check-size`: DER EMPFOHLENE ENTWURF

Ich habe drei Entwuerfe pruefen lassen; alle drei fielen an derselben Stelle durch, und der Befund ist wichtiger als die Entwuerfe:

> **Planer und CEB linken dieselbe Bibliothek** (`comdare::profile_run_facade`). Alles, was ein Entwurf „auf der CEB" rechnen lassen wollte — CPU-Threads, Cache-Line, freier Platz, SIMD-Freigabe — sieht der Planer-Prozess auf derselben Maschine **selbst**. Eine Prozessgrenze, ueber die nur solche Werte reisen, ist eine **leere Naht**: sie simuliert deine Forderung, statt sie zu erfuellen.

Der Entwurf unten loest das, indem er die CEB nach dem fragt, was **nur sie** wissen kann.

### 4.0 Der tragende Gedanke

**Was der Planer allein kann:** die **Groesse** — sie folgt rein aus der XML (Freigaben) und aus dem deterministischen Director-Walk.
**Was nur die CEB kann:** die **Dauer** — denn die Zeit je Messpunkt **haengt an der Instrumentierung**, und die Instrumentierung ist **in die CEB einkompiliert**. Eine `[all]`-CEB misst langsamer als eine `[wallclock]`-CEB; genau das ist der Messfehler, den du herausrechnen willst. **Nur die CEB-Variante selbst kann ihre eigene Zeit je Messpunkt erheben.**

Damit wird deine Anweisung „die Berechnung findet ebenfalls auf der CEB statt" substantiell und nicht zeremoniell: der Planer rechnet die **Menge**, die CEB(s) liefern die **Rate**, und weil es 6 CEB-Varianten gibt, liefert die Befragung nebenbei die **erste Messung des Mess-Overheads** — dieselbe Differenz, die deine Mess-Kette braucht.

### 4.1 Aufruf

```
cache_engine --check-size "FILE"
```

**Alles Weitere steht in der XML, nichts auf der CLI.** [SETZUNG] — begruendet aus deinem F3-Ruling (`Ledger:2033`: *„per PLAN ist ALLES in XML konfigurierbar"*) und B-4 (*„XML bestimmt Verhalten"*). Eine Flagge, eine Datei. Kein `--no-build`, kein `--build-dir`, kein `--kalibriere`: das sind Verhaltensschalter und gehoeren in einen XML-Block:

```xml
<check_size>
  <ceb build_if_missing="true" dir=".check-size-ceb"/>
  <kalibrierung modus="bestandslog|mini_batch|keine" batch="24"/>
  <ziel_dateisystem pfad="…"/>
</check_size>
```

**Binary:** [SETZUNG] die Flagge haengt an `comdare-experiment-planner` — du schreibst „baue in den Planer eine Ausfuehrungsflag an **dessen** CLI". `cache_engine` ist dein Kurzname; eine Binary dieses Namens gibt es nicht (die zweite heisst `comdare-messung-driver` = die CEB). → ob umbenannt werden soll: **Entscheid D-1**.

### 4.2 Ausgabe

`stdout` = Daten (key=value, deterministisch), `stderr` = Diagnose. **Jede ungedeckte Zahl steht als `n/a` — nie als 0, nie als Konstante.** Unvollstaendige Projektion traegt `>=` (uebernommen aus `eta_kalibrierung.hpp`).

```
# comdare-check-size v1
profil=<pfad> wurzel=comdare_thesis_profile|comdare_experiment|comdare_paper_experiment
maschine=<cpu_fabrication>/<ram_pair>  hw_threads=<n>  line_bytes=<n>  frei_bytes=<n>

-- GROESSE (permutativ, NUR aus den in der XML freigegebenen Werten) --
achse <name>=<k>                  # je deklarierter Achse eine Zeile, Dokument-Reihenfolge
organ_produkt=<prod k_i | ueberlauf>
system_perms=<|opt x simd|>       mess_kombis=<n>   ceb_typen=<n>
bau_binaries=<organ_produkt * system_perms * mess_kombis>
mess_selektion=xml|fenster|fehlt
mess_binaries=<n>  faecher=<n>  mess_punkte=<mess_binaries * faecher>
nachbau_noetig=<n>                # Messung angefragt, Bau-Material nicht freigegeben -> WARNUNG, wird gebaut

-- CEB-BEFRAGUNG (je CEB-Variante eine Zeile) --
ceb combo=[wallclock,macro,micro] zustand=vorhanden|gebaut|fehlt contract=8.1
    s_je_messpunkt=<x|n/a>  s_je_bau=<x|n/a>  quelle=bestandslog|mini_batch
ceb combo=[wallclock]        …
mess_overhead_je_stufe: micro=<x|n/a> macro=<x|n/a> combined=<x|n/a>   # Differenz der Zeilen

-- DAUER --
bau_wandzeit_s=<x|>=x|n/a>    worker=<lane_build_parallelism=24>
mess_wandzeit_s=<x|>=x|n/a>
gesamt_wandzeit_s=<x|>=x|n/a>   kalender_fertig=<ISO-Datum|n/a>

-- PLATZ --
avg_binary_bytes=<x|n/a>  bau_bytes=<x|n/a>  reicht=ja|nein|unbekannt
```

**Exit-Codes** (die bestehende Planer-Tabelle bleibt, nur ergaenzt): `0` Bericht vollstaendig **und** gedeckt · `1` Usage · `2` Konfig-Fehler · **`3` Bericht steht, ist aber KEINE FREIGABE** (irgendeine Kernzahl `n/a`, `ueberlauf`, `reicht=nein` oder `mess_selektion=fehlt`) · `5` unbekannte Profil-Wurzel · `6` Bestandslog-Gate · **`8` CEB fehlt und war nicht baubar`. `4` und `7` bleiben belegt.

> Der Unterschied zu allen Vor-Entwuerfen: **`mess_selektion=fehlt` und `deckung=nein` fuehren zu rc 3, nicht zu rc 0.** Ein Groessen-Werkzeug, das eine ungedeckte Zahl gruen meldet, ist schlimmer als keines.

### 4.3 CEB-Befragung

**Vertrag:** kein neuer erfunden. `profile_facade/planner/experiment_dock_payload.hpp` **ist** der deklarierte §38-Dock-Vertrag (Payload hinab `ExperimentSubtreePayload` + R5-XML-Emitter/Parser mit Byte-Roundtrip-Test; Payload hinauf `ProgressDelta`). Er traegt heute einen `[DEPRECATED — S5-P4 Ruling]`-Block, weil er *„von keiner Live-Call-Site konsumiert"* wird. **`--check-size` ist diese erste Live-Call-Site.** Ergaenzt wird ein TEIL 3 (`CebSizeAnswer`) im **selben** Header, **selben** XML-Dialekt, **selben** Roundtrip-Gate.

**Transport heute:** Textemission (der bewusst gewaehlte Stand, `Ledger:4028`), also
```
comdare-messung-driver ceb probe-size <profil> [--subtree=<datei>]  ->  <ceb_size_answer …/> auf stdout
```
— **derselbe** Kanal, ueber den der Planer die CEB schon heute ruft (`experiment_plan_director.hpp:479`, `"${COMDARE_PLAN_DRIVER}" tier cmake …`). Bei §60-R1/#35 wechselt spaeter nur der Transport auf `.so`/dlopen; PODs, Serialisierung, Tests bleiben.

**Was die CEB antwortet — nur Exklusives:**
1. ihre **Kompilat-Identitaet** (`COMDARE_MEASUREMENT_COMBO_CT`, `-march`, `ceb_contract_version`, `ceb_key_sha512`);
2. ihre **Zeit je Messpunkt**, entweder aus dem Bestandslog oder aus einem Mini-Batch von `n_threads` Messungen — **unter ihrer eigenen Instrumentierung gemessen**;
3. die **Hardware-Erhebung** aus `measurement/hardware_probe_factory.hpp` (RAM-Frequenz via SPD/DMI, NUMA-/Page-Topologie, Kern-Klassen + PMU). Diese Factory hat heute **null Produktiv-Konsumenten** — nur 4 Unit-Tests. `--check-size` waere ihr erster.

> **Wichtige Korrektur zu einem Vor-Entwurf:** `hardware_probe_factory.hpp` liefert **kein** `cacheline_bytes` und **keine** Thread-Zahl. Der reale Laufzeit-Kanal fuer die Line-Groesse ist `platform_probe/cpuid_probe.hpp:174` (`((leaf1.ebx>>8)&0xFF)*8`, Nullfall `:175`) + `platform_probe/sysfs_cache_probe.hpp:74` (`coherency_line_size`), zusammengefuehrt in `cpuid_platform_probe.hpp:48-49`. Wer den falschen Header nimmt, baut das Freigabe-Kriterium ins Leere.

**Wenn die CEB fehlt:** Aufloesung `<check_size><ceb dir=…>` > `COMDARE_PLAN_DRIVER` > PATH. Kein Treffer und `build_if_missing="true"` → Bau ueber **denselben** Weg, den die Plan-Emission ohnehin vorschreibt (`-DCOMDARE_V32_ENABLE=ON`, `ceb_pmc_compile_define()`, `ceb_combo_compile_define(<legende>)`, Target `comdare-messung-driver`), damit kein zweiter Bau-Kanal entsteht. **Achtung, echte Huerde:** `messung_driver` ist ein **super**-Target — in `ce` gibt es kein `add_executable` dafuer (7 Treffer in ce-CMakeLists, **alle Kommentar**). Der vorsorgliche Bau verlaesst also das ce-Repo. Im ce-Standalone-Bau ist er strukturell unmoeglich → dort rc 8 mit klarer Meldung.

### 4.4 Rechnung

**A) GROESSE** — eine echte, kleine Luecke:
- `PlanHeader` bekommt zusaetzlich `profile_axis_cardinalities` (je Achse ihre Wertzahl, Dokument-Reihenfolge). Gefuellt an der einen Stelle, an der der Kopf heute entsteht (`experiment_plan_director.hpp:2113`). **Byte-neutral** — kein bestehender Builder rendert das Feld, die Emission aendert sich nicht.
- Neuer `PlanVolumeBuilder` neben `PlanSizeBuilder`, gleiches Muster, **derselbe** Walk (`construct_plan_into`, `profile_run_facade.cpp:985`): bildet das **gepruefte** Produkt der Kardinalitaeten. Ueberlauf → Ausgabe `ueberlauf`, **nie** eine gewickelte Zahl.
- `bau_binaries = organ_produkt × system_perms × mess_kombis`. Die 16 `<measurement_categories>` gehen **nicht** ein — sie sind CSV-Spalten (§54-T2), kein CEB-Faecher. Sie mitzumultiplizieren waere genau der Faktor-16-Fehler, der pauschales Rechnen ausmacht.
- `mess_binaries`: solange der XML-Kanal fehlt (§1b) → `mess_selektion=fehlt` und rc 3.

**B) DAUER** — kein neues Modell, ein fehlender Aufrufer:
`projiziere_kampagne(posten, binaries_je_perm, zellen_soll)` + `kampagnen_zeile()` (`eta_kalibrierung.hpp:297/:350`) existieren fertig und ohne Aufrufer. `--check-size` ist er. Modell (im Header ausgeschrieben): je Maschine **Summe** der Perm-Zeiten, ueber Maschinen **Maximum**. Zwei Faelle sind schon geloest und werden uebernommen: Belastbarkeits-Schwelle = `n_threads` Messpunkte; fehlt eine Zelle → `vollstaendig=false` und das Ergebnis liest sich als `>= x`, nie als Punktwert.
**Ein Fehler, der in einem Vor-Entwurf steckte und hier vermieden ist:** `KampagnenPosten` traegt `maschine` als **Gruppierungsschluessel**. Ein POD ohne dieses Feld kompiliert nicht und wuerde, wenn man es hineinreparierte, still falsch gruppieren. Der Posten muss die Maschine tragen.

**C) PLATZ** — `bau_bytes` gegen `std::filesystem::space` des Zielverzeichnisses. `reicht=nein` → rc 3. Das ist nicht Schmuck: **prod1 ist der GitLab-Runner**; ein volles `/` legt die CI lahm.

**D) HARDWARE-EINGANG — vier Stellen mit Wirkung:** (1) Line-Groesse entscheidet die **HW-Freigabe der Mess-Menge** (`experiment_golden_kern.xml:264-270`); `PlanPerm::host_supports_simd` ist heute eine reine Annotation, die **nichts** filtert — `--check-size` ist ihr erster Konsument, ohne den Plan-Text zu veraendern. (2) Threads → Bau-Wandzeit; gerechnet wird mit `lane_build_parallelism` (24, empirisch begruendet), **nicht** mit `nproc`, weil die emittierten Jobs mit 24 laufen; die Differenz bekommt eine eigene Zeile. (3) Die erkannte Plattform-Zelle bestimmt, **welche** CEB gebaut wuerde. (4) Freier Platz → Platz-Urteil.

### 4.5 Bau-Schritte mit Abnahmekriterium

| # | Schritt | Ort | **Abnahme (literal, kein Haken ohne Ausgabe)** |
|---|---|---|---|
| S1 | `profile_axis_cardinalities` in `PlanHeader` | ce `experiment_plan_director.hpp` | `plan ci`/`plan cmake` liefern **byte-identische** Emission vor/nach (diff leer) |
| S2 | `PlanVolumeBuilder` (gepruefte Multiplikation) | ce, neben `PlanSizeBuilder` | neuer Test: Produkt == `catalog_axis_product<golden_320_catalog>() == 320`; Ueberlauf-Fall liefert `ueberlauf` **und** rc 3 |
| S3 | `<check_size>`-Block im XML-Parser | ce `xml_config_parser` | Roundtrip-Test; fehlender Block = Defaults, kein Fehler |
| S4 | `CebSizeAnswer` als TEIL 3 des Dock-Vertrags | ce `experiment_dock_payload.hpp` | `emit(parse(emit(a))) == emit(a)`, angehaengt an `test_experiment_dock_payload.cpp` |
| S5 | `ceb probe-size` an der CEB + `probe_ceb_size()` | super `Code/02_messung_driver/main.cpp` + ce Header | Aufruf auf prod1 gibt gueltiges `<ceb_size_answer>` mit **echten** Line-Bytes und Thread-Zahl (Gegenprobe gegen `lscpu`) |
| S6 | CEB-Aufloesung + vorsorglicher Bau | ce/super | fehlende CEB → gebaut, Zustand `gebaut`; `build_if_missing="false"` → `fehlt` + rc 8 |
| S7 | `check_size_facade` verdrahtet `PlanVolumeBuilder` + `projiziere_kampagne` | ce `profile_run_facade` | `kampagnen_zeile()` erscheint **verbatim** im Bericht |
| S8 | `--check-size` am Planer-Host | ce `apps/experiment_planner/main.cpp` | `cache_engine --check-size all_axes_golden.profile.xml` liefert Bericht; zwei Laeufe **byte-gleich** |
| S9 | Ehrlichkeits-Gates | ce tests | ohne Kalibrier-Posten stehen `n/a` **und** rc 3; nie 0, nie Konstante |
| S10 | **Overhead-Zeile** (2 CEB-Varianten, sobald mehr baubar: 6) | ce/super | zwei Varianten liefern **unterschiedliche** `s_je_messpunkt`; die Differenz erscheint als `mess_overhead_je_stufe` |

**S10 ist der Punkt, an dem `--check-size` und deine Mess-Kette dasselbe Werkzeug werden.** Solange nur 2 der 6 CEB-Varianten baubar sind (§2), liefert die Zeile genau eine Differenz und markiert die uebrigen als `n/a`.

---

## 5. WAS DU ENTSCHEIDEN MUSST

Alles Ableitbare habe ich entschieden und mit **[SETZUNG]** markiert (siehe §4: CLI-Form, XML-Steuerung, Binary = Planer, Exit-Semantik, keine Zahl ohne Deckung). Offen bleibt:

**D-1 — Name der Binary.** Du schreibst `cache_engine`. Real: `comdare-experiment-planner` (Planer) und `comdare-messung-driver` (CEB); dazu gibt es ein drittes, verwirrend benanntes `comdare-cache-engine-builder` (Alt-Wrapper, von keinem CI-Job gebaut). Soll die Planer-Binary auf `cache_engine` umbenannt werden (Byte-Ereignis: Selbst-Stempel, CI-Jobnamen, Install-Naht), oder bleibt der Name und `cache_engine` ist nur deine Kurzform? **Meine Neigung:** Name lassen, sonst wackeln Stempel und Pipelines kurz vor der Messung.

**D-2 — Die 6 CEBs sind ein eigenes Bau-Paket. Freigabe?** Damit sie ueberhaupt entstehen koennen, muessen zwei Dinge gebaut werden, die heute fehlen: (a) **G3 aus dem `CE_ENABLE_STATISTICS`-Gate herausloesen** in ein eigenes Makro (beruehrt `abi_adapter.hpp` im Hot-Path und die A8-S4-Praeprozessor-Wache, die genau zwei Gate-Makros kennt); (b) **Combos ohne `wallclock` zulassen** (heute harter Wurf, weil G1 von jedem Tooling gezogen wird). Ohne (a)+(b) sind maximal 2 der 6 herstellbar.

**D-3 — Welche 6? Die Arithmetik geht mir nicht auf, und ich will nicht raten.** Bei 3 Messgeraeten, die je ein- oder ausgebaut sein koennen, gibt es **2³ = 8** Bauten. Das von dir beschriebene Verfahren („ein Lauf ueber die Gesamtzeit **ohne eine** der 3 Messeinrichtungen") braucht den Voll-Bau + 3 Leave-one-out = **4**; mit dem instrumentierungsfreien Referenzlauf **5** — das ist die Zahl, die du korrigiert hast. **6** ist `3!` (Permutationen einer **Reihenfolge**) und zugleich `2³ − 2` (alle Bauten ausser leer und voll). Welche der beiden Mengen meinst du — und falls `3!`: was permutiert dort, die Reihenfolge des Ausbaus oder die Staffelung der Stufen? Von dieser Antwort haengt direkt die Bau-Menge ab, die `--check-size` ausweist.

**D-4 — Paper-XML: welche Wurzel, welcher Deckungsgrad?** Du hast das Bauen bereits freigegeben (*„Ja unter sorgfaeltiger Design Planung bitte bauen, Ruecksprache mit mir im Detail"*). Die Detail-Fragen, ohne die ich nicht anfangen kann: (1) Traegt eine Paper-XML die Wurzel `comdare_experiment`, `comdare_thesis_profile`, oder eine neue dritte? (2) **Pinnt ein Paper ALLE Achsen** (dann ist ein Paper genau 1 Binary und der Vergleich entsteht erst durch den Achsen-Sweep), **oder nur die Achsen, die das Paper wirklich spezifiziert** (dann ist ein Paper ein Teilbaum und der Rest kommt aus dem Full Join)? Die zweite Lesart passt zu deinem Satz *„Jede Achse hat weiterhin mehrere Algorithmen"* — aber sie aendert die Mengenrechnung um Groessenordnungen.

**D-5 — D-3 vom 07.08. gegen den 08.08.** *„Wir bauen nur die 320er die wir auch tatsaechlich messen"* (07.08.) gegen *„einen groesseren Satz an binaries bauen, aber nur einen Teil davon durchmessen"* (08.08.). Ich lese den 08.08. als den neueren und damit geltenden Stand — bitte bestaetigen, denn davon haengt ab, ob der XML-Kanal Bau/Messung ueberhaupt gebraucht wird.

**D-6 — Break-Even: welche Abszisse?** Deine Beschreibung („ueber die Zeit", Stuetzstellen = Zeitpunkt-Checkpoints, Basis bei 0) beschreibt eine Kurve ueber die **Zeitachse eines Laufs**. Dein zweiter Satz vom selben Tag („bei welcher Last-Art und groesse die Memory Achse optimal laeuft") beschreibt eine Kurve ueber die **Lastachse ueber Laeufe hinweg**. Ich vermute: **beides**, gestaffelt — erst je Lauf eine Zeitkurve, dann aus deren Kennwerten je Binary eine Lastkurve, und der Break-Even ist der Schnittpunkt der **Lastkurven**. Bitte bestaetigen oder korrigieren; die konsolidierte Implementierung sieht in beiden Faellen anders aus.

**D-7 — B-Spline: interpolierend oder approximierend?** Ein kubischer B-Spline mit Kontrollpunkten geht im Allgemeinen **nicht** durch die Messpunkte (das macht ihn glatt und kompakt serialisierbar). „Moeglichst scharf" kann heissen „geht durch jeden Messpunkt" (dann interpolierender B-Spline, Knoten = Messzeitpunkte) oder „glatt und knapp, Abweichung erlaubt". Fuer eine wissenschaftliche Auswertung ist das ein methodischer Unterschied, der in die Thesis muss.

---

## 6. WAS ICH NICHT KLAEREN KONNTE

1. **Das prt-art-Repo liegt hier nicht als Worktree.** Ob dort ein eigenes Template-Profil/eine Achsen-Registry fuer den Pruefling gefuehrt wird, konnte ich nicht pruefen. In ce zeigt der Pruefling auf das ART-Paper-Profil (`all_axes_golden.profile.xml:24`, `<tier id="prt_art" profile_ref="../sota/art.profile.xml" paper_ref="PRT"/>`) — er hat dort **keine eigene** Akte. Dein Satz „den Nachweis des PRT-ART Prueflings und dessen Einsetzung in die Achsen" trifft genau diesen Punkt.
2. **Ob `experiment_driver.cpp` (Auto-Pickup der sota-Profile, REV 7.6) noch am offiziellen Messpfad haengt.** Der Ledger fuehrt den offiziellen Lauf ueber `parse_thesis_profile`/m3v2. Ich habe die Aufrufkette bis zum CLI nicht zu Ende verfolgt — unsicher.
3. **Die `run`-Haelfte der CEB** (`super Code/02_messung_driver/main.cpp` ab ca. Z. 560 bis 1467). Ich habe nur den CLI-Dispatcher gelesen. Ob dort schon Hardware-Werte erhoben oder Zeitbudgets gefuehrt werden, ist ungeprueft — das aendert ggf. den Umfang von S5.
4. **Ob im Lager/Bestandslog schon Laufzeit-Daten je **Messung** (nicht je Bau) liegen.** Protokolliert ist nachweislich die **Bau**-Rate (Ledger:2459, „~73 DLLs/min je Zelle"); eine Mess-Rate habe ich mit 3 Mustern nicht gefunden. Falls sie doch irgendwo liegt, waere die Dauer-Haelfte von `--check-size` sofort belastbar statt `n/a`.
5. **Zahlen habe ich bewusst keine nachgerechnet.** Keine Bau-Menge, keine Bauzeit, kein Platzbedarf. Du hast das pauschale Nachrechnen untersagt und stattdessen `--check-size` beauftragt; die erste Zahl, die ich dir wieder nenne, soll aus dem Programm kommen.
6. **Die Owner-Roh-Transkripte unter `super docs/sessions/backups/`** habe ich fuer den Break-Even-Strang **nicht** durchsucht; meine Belege dort stammen aus Code, Ledger und `plaene/`. Es kann aeltere Woertlichkeit von dir geben, die praeziser ist als das, was ich zitiere.