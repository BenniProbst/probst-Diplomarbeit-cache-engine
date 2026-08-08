# GESAMT-WELLENPLAN BIS 15.09.2026 — ENDFASSUNG

**Architekt-Entscheid, Stand 08.08.2026 (Samstag).** Grundlage: 369 SOLL-Posten, 211 IST-Pruefungen, 39 Regressionen, 46 Skeptiker-Einwaende (20 tragend). Alle mit `LIVE` markierten Zahlen sind heute erhoben; die Erhebungs-Referenz steht jeweils dabei.

**Ersetzt:** `20260803-FAHRPLAN-gesamtkette-wellen-phasen.md`, `20260806-PLAN-wellenplan-vollbild-und-parallelisierung.md`, `20260806-FAHRPLAN-parallel-sequenz-optimiert.md`, `20260806-REGISTER-todo-konsolidierung-14-tage.md`. Die ersetzten Dokumente werden **deprecatet, nicht geloescht**; ihre Nummernkreise leben als Herkunftsvermerk in Abschnitt 3 weiter.

---

## 0. VORBEMERKUNG: EIN BEFUND, DER DEN GANZEN ENTWURF VERSCHIEBT

Der Entwurf hat seinen kompletten Diff (A.1–A.5) ueber dem **Arbeitsbaum** `/home/comdare/wt-ce-fk` erhoben. Heute nachgemessen:

```
git -C /home/comdare/wt-ce-fk rev-parse --abbrev-ref HEAD  -> bau/doktrin-aufraeumung
git -C /home/comdare/wt-ce-fk rev-parse --short HEAD        -> b2daf9a6
git merge-base --is-ancestor HEAD origin/development        -> rc 0  (HEAD IST Vorfahr)
git rev-list --count HEAD..origin/development               -> 29
```

Der Arbeitsbaum ist **29 Commits hinter `origin/development`** und strikter Vorfahr. Jeder `LIVE: 0 Treffer` des Entwurfs ist damit ein Nullbefund ueber zu kleinem Nenner — **Fall 1 des Tages in Reinform**, begangen von dem Dokument, das ihn verhindern soll. K10 verbietet den Agenten auf ungepruefte Checkouts ausdruecklich.

**Zugleich sind zwei Einwaende, die daraus gebaut wurden, am Objekt falsch** — sie haben gegen die **lokale** `development`-Referenz gemessen, die selbst veraltet ist:

```
git rev-parse --short development         -> ba069e38
git rev-parse --short origin/development  -> 5e163331
git rev-list --count development..origin/development -> 80
```

| Behauptung im Einwand | Gemessen gegen `origin/development` | Verdikt |
|---|---|---|
| „`development:Makefile` existiert nicht" | `git cat-file -e origin/development:Makefile` -> **EXISTS** | **widerlegt** |
| „A9-S4 = 82 Commits, 386 Dateien, 95.770 Einfuegungen" | `git rev-list --count origin/development..bau/a9-s4-mess-report` -> **6**; `git diff --stat origin/development...bau/a9-s4-mess-report` -> **17 Dateien, 1940+/103-** | **widerlegt** — An-4 des Entwurfs war korrekt |
| „KEINER der neun heutigen ce-Commits ist auf development" | alle 13 heutigen ce-Commits: `merge-base --is-ancestor <sha> origin/development` -> **rc 0** | **widerlegt** |

**Und ein dritter Befund faellt dabei ab, der den Entwurf entlastet:** W0.1 (`make check` ohne Reconfigure) ist auf `origin/development` **bereits geheilt**:

```
git show origin/development:Makefile | sed -n '91p;124,126p'
91:  check: inventar
124:  inventar: all
125:  	$(CMAKE) -S "$(SRCDIR)" -B "$(BUILDDIR)"
126:  	$(CMAKE) --build "$(BUILDDIR)" $(BUILD_PAR) --target comdare_tests
```

**Konsequenz, bindend:** vor W1 steht eine eigene Welle **W-1**, die landet und **neu erhebt**. Kein Paket dieses Plans wird gegen den Arbeitsbaum-Stand gebaut.

---

## 1. WO WIR STEHEN

Die Kette **[PLANER] fragt -> [CEB] traegt -> [HYBRID] adaptiert -> [TIER] laeuft** ist an ihren Enden offen, nicht in der Mitte. Gebaut sind 121 Algorithmen, 18 Unterachsen, 22 Achsen, ein xlsx-Writer (634 Zeilen mit eigener TU), ein Lager-Baum-Writer mit zwei disjunkten Realm-Wurzeln, ein Bestandslog mit Lock/Reservierung/Takeover/ETA und ein Batchplaner auf 4096er-Korn. **Wirkungslos sind sie fast alle:** `ErgebnisMappenFactory` hat 3 Treffer im Header und 6 in zwei Testdateien, sonst nichts; `make_binaries_baum_writer`/`make_messdaten_baum_writer` haben keinen Produktions-Aufrufer; `COMDARE_BESTANDSLOG` ist in **beiden** `.gitlab-ci.yml` null Mal gesetzt; `run_with_drift_gate` und `assess_drift` kommen ausschliesslich in `drift_detector.hpp` selbst und in `test_chaos_drift_gate.cpp` vor (LIVE, Arbeitsbaum, ausserhalb `/build/`). Die groesste Zustandsklasse dieses Projekts ist nicht „fehlt", sondern **„gebaut, kein Konsument"** — 14 Posten.

Dagegen steht das Fenster: **38 Kalendertage, 27 Werktage, 5 Freitage** (14.08. · 21.08. · 28.08. · 04.09. · **11.09.**), Abgabe Di 15.09. — alles LIVE per `python3`-Auszaehlung. Der letzte Liefer-Freitag liegt **vier Kalendertage vor der Frist**. Die Mess-Menge ist bis heute nicht rechenbar (`--check-size` existiert nicht), das Ausdrucksmittel fuer eine Deckelung ebenfalls nicht (`measure_selection|measurement_selection` = **0 Treffer in beiden Repos**, `*.hpp/*.cpp/*.xml/*.xsd`), und die zweite Mess-Maschine existiert nicht (`getent hosts prod2` -> rc 2, `hostname` -> `prod1`), waehrend die Thesis den Zwei-Maschinen-Betrieb im **Praesens** zusagt (`kapitel/de/05_evaluation.tex:78-79`). Es sind heute 39 Regressionen gefuehrt, und die Aufraeum-Zaehler **wachsen** (ASCII 1132→1160, Prosa 29→54, `organ_location` 79→97).

**In einem Satz:** die Maschine ist gebaut, aber nicht verdrahtet; die Menge, die durch sie laufen soll, ist unbekannt; und die Abgabe verspricht im Praesens drei Dinge, die der Code heute nicht haelt.

---

## 2. DER DIFF

Sechs Zustandsklassen. **Alle Zeilen tragen den Vermerk, wogegen sie erhoben sind.** Zeilen mit `[AB]` sind gegen den Arbeitsbaum `b2daf9a6` erhoben und **in W-1 neu zu erheben**; Zeilen mit `[OD]` sind heute gegen `origin/development` `5e163331` nachgemessen.

### 2.1 FEHLT GANZ — abgabekritisch

| # | Feature | Beleg | Welle |
|---|---|---|---|
| F-01 | `--check-size` (Experimentgroesse/Dauer, Rechnung auf der CEB) | `[OD]` `git grep -c 'check.size\|check_size' origin/development -- '*.hpp' '*.cpp'` -> ein Treffer, und der in `ext/traversal/P01-ART/unodb/test/` (Fremdcode). Planer-Dispatch kennt 7 Verben | W1-D |
| F-01b | **`<measure_selection>`: Mess-Menge getrennt von Bau-Menge ausdruecken** | `[OD]+[AB]` 0 Treffer in beiden Repos ueber `*.hpp/*.cpp/*.xml/*.xsd` | W1-D |
| F-02 | `checkpoint_measure` + 6 Bausteine | `[OD]` `git grep -l checkpoint_measure origin/development` -> **2 Treffer, beide Kommentare** (`ergebnis_mappe.hpp:157,158,182`; `test_a9s3_mess_ebene_blattsorte.cpp:237`). Null Implementierung | OV-2 / W7 |
| F-03 | Hybrid-Stufe B-10 | `[OD]` `git ls-tree origin/development libs/cache_engine/hybrid/` -> **genau `README.md`** | W7 (OV-3) |
| F-04 | Break-Even als String serialisierbar | `[AB]` 0 Treffer `spline.*serial`; `AxisSpline` ohne `to_string`/`from_string` | W1-A |
| F-05 | Break-Even DREIMAL querschneidend (Micro/Macro/combined je Knotentiefe) | `[AB]` 0 Treffer `combined` in heuristik/curve_fit/decision_trees | **datenabhaengig, W5** |
| F-06 | `comdare_mess_report` CLI | `[OD]` existiert auf `bau/a9-s4-mess-report` (6 Commits, 17 Dateien) — **nicht** auf `origin/development` | **W-1** |
| F-07 | LaTeX-Anlage als AUSWERTUNG (Tabellen+Ranking) | `[AB]` `tools/latex_anhang/main.cpp` emittiert 2 Rohdaten-Tabellen | W1-A |
| F-07b | **Diagramm-Emitter** (2D/3D statt Heatmap, SOTA-Visualisierung) | SOLL-Posten; F-07 deckt nur Tabellen | W2-F |
| F-08 | compare-Stufe D2 | `[AB]` `RunMethodology::Compare` 5 Treffer, alle Registry | **W2** (nicht W5) |
| F-09 | B-3 getrennte Ablage je PMU-Domaene | `[AB]` 0 Spalte `pmu_domain\|core_class` im CSV-Kopf | W1-E |
| F-10 | **B-2 Pinning-Konsument im Mess-Loop** | `[AB]` `perm_runner.hpp` 0 Treffer `pin`; LEDGER:4740 stuft ein: **CEB-ONLY, vor der Voll-Messung** | **W2-E (vor Freeze)** |
| F-11 | Record-and-Replay als Mess-Vertrag | `[AB]` 0 Treffer | W7 |
| F-12 | `E07_*`-Gate-Zeilen (Stufe 2) | `[AB]` 0 Treffer ausserhalb `docs/` | W2-D |
| F-13 | super-Abdeckungs-Wache | `[AB]` `super/scripts/` = 3 Skripte, keines deckt Tests ab | W0b |
| F-14 | xlsx-SKIP bei gueltigem Bestand | `[OD]` auf `bau/a9-s4-mess-report` als `skip_manifest.hpp` (91 Z.) vorhanden | **W-1** |
| F-15 | Lager-Inkonsistenz = FATAL (Schwere-Stufe) | `[AB]` 0 Schwere-Stufe an den Lager-Fehlerklassen | W1-B |
| F-16 | **Mess-Resume auf 4096er-Korn** | GESAMTDOSSIER:2589: „der MESS-Batch faehrt das VOLLE Fenster in EINEM Treiber-Aufruf je Perm ... kein Wiederaufnahme-Korn; jeder Abbruch verloere Wochen" | **W2-C** |
| F-17 | **§59-Kette**: SCHEMA · EMITTER · MERGE-STEMPEL · STORAGE · TEMPLATE | LEDGER:3285-3289, alle **„OFFEN, kritisch/hoch"**; MERGE-STEMPEL = **dritter Tier-Binary-Stempel, POD 56→72, layout 2→3** | **W1-F / W2-B** |
| F-18 | **`.ps1`/`.py`-Abloesung auf dem Lieferpfad** | LIVE thesis: `build.ps1`, `build_all.ps1`, `generate_measurement_appendix.ps1`, `generate_wide_appendix.ps1`, `tools/format_tex.py` | **W2-F** |
| F-19 | **FF0–FF4-Abnahmematrix** (welche Zahl beantwortet welche Frage) | LEDGER:128/:238/:345 („FF0–FF4 mit realen, CI-verifizierten Messwerten beantwortet", DoD 1–7) — kommt im Entwurf nirgends vor | **W2-F, Abnahme W5** |

### 2.2 NUR SPEZIFIZIERT (Design vollstaendig, 0 Bau)

| # | Feature | Beleg | Welle |
|---|---|---|---|
| S-01 | G3 aus dem STATISTICS-Gate loesen | `[AB]` Zensus `anatomy/`: genau 2 Mess-Gates (`COMDARE_CE_ENABLE_STATISTICS` 39x, `COMDARE_MEASUREMENT_ON` 36x) | W1-C |
| S-02 | `checkpoint_measure`-Design | `docs/architecture/20260808-checkpoint_measure_soll_design.md` (`cc028e1d`) | OV-2 |
| S-03 | A17 Hybrid-Design | Dossier vollstaendig, Code 0 | W7 |
| S-04 | L3-Asymmetrie-Messung | Erkennung gebaut; prod1 bestaetigt 128 MiB in 2 Instanzen; golden-XML deklariert `core_class` nicht | W1-E + W4-C |
| S-05 | EINE CEB traegt beide Messfuehler (P/E getrennt) | ABI-Vorbedingung CT-erzwungen; Durchfuehrung 0 — **und die Hybrid-CPU fehlt physisch** | OV-9 |

### 2.3 TEILWEISE — gebaut, aber OHNE KONSUMENT (die groesste Klasse, 14 Posten)

| # | Baustein | Konsumenten-Befund | Welle |
|---|---|---|---|
| T-01 | xlsx-Writer (`ErgebnisMappe`) | `[AB]` `ErgebnisMappenFactory` = 3 Header + 6 Test. **NULL Produktion** | W-1 + W1-B |
| T-02 | Lager-Baum-Writer (2 Realm-Wurzeln, CT-Policy) | `make_*_baum_writer` nur Definition + Tests | W1-B |
| T-03 | G-E3 Messwert-Bestand | `[AB]` 0 Treffer `mess_bestand` in super `Code/` | W1-B |
| T-04 | Bestandslog gesamt | `COMDARE_BESTANDSLOG` in **beiden** CI = 0 Setzer | W1-B |
| T-05 | Mess-Combo-Fan-out | `experiment_golden_kern.xml:415-417` = **genau EINE** `<combo tools="wallclock macro micro"/>` | W1-D + W2-A |
| T-06 | KF-6 Cacheline (60 Konfigurationen) | alle Strategie-Basen tragen `CacheLineConfig{}` -> 1 von 60 | W2-E |
| T-07 | RAM-Spool 256 MB + Writer-Thread | 0 Konsumenten | W2-E |
| T-08 | G-E7 Dual-ccache `LagerZiel` | 0 Konsumenten, kein Test | W2-E |
| T-09 | LB-1 Knoten-Heuristik-Log | 0 Produktions-Aufrufer | W2-E |
| T-10 | `simd_build_gate` | `static_assert(!any_organ_declares_required())` — global inert | W2-E |
| T-11 | `kNoPinnedLocalityWarning` | 3 Treffer, nie ausgegeben — **gehoert mit F-10 (B-4 „mit B-2")** | **W2-E** |
| T-12 | Cross-Genus-Organe (4 gebaut) | 0 Treffer in `cache_engine_axis_registry.xml` | W2-E |
| T-13 | Fehlerklassen FK-3/FK-5 | Vollstaendigkeit ist **Handliste** (20/18); `CompoundSystemAxis` 0 Traits | W2-E |
| T-14 | Fehlerklassen Unterachsen/Algorithmen | 0 von 18 / 0 von 121 | W2-E |
| T-15 | **`drift_detector`** | `run_with_drift_gate`+`assess_drift` = nur Header + `test_chaos_drift_gate.cpp`. **Es laesst nichts durch — es laeuft nicht** | **W2-C, nicht W0** |
| T-16 | **A5-ETA-Kalibrierung** | `projiziere_kampagne`/`BatchPlanner`: nur `test_a5_eta_kalibrierung.cpp` | **W2-C** |

### 2.4 GEBAUT ABER UNVERIFIZIERT — jetzt mit Zielwelle (Einwand 4)

Der Entwurf benannte diese Klasse als eine der zwei teuren und plante fuenf von acht Posten in **keiner** Welle ein. Behoben: jede Zeile bekommt einen Vollzugs-Beleg (Job-ID + Log-Zeile) nach V-3.

| # | Feature | Was fehlt | **Zielwelle** |
|---|---|---|---|
| U-01 | Dynamische Planer-CI (CiYamlBuilder → Child → Grandchild) | nur der Emitter getestet, nie eine gefahrene Kaskade | **W2-D** |
| U-02 | `measure:golden-320` | per Doktrin nie gefahren | **W3-B** (Kalibrierlauf ist der Vollzug) |
| U-03 | **`anhang:forward`** (E-18 Vorwaertskanal) | `AF_GENERATOR` Default LEER; `git add ... 2>/dev/null \|\| true`, danach „IDEMPOTENT: 0 Aenderungen", Exit 0 | **W1-A** — einziger Transport Messwerte → Thesis-Submodul |
| U-04 | `persist:measurements` | sammelt nur `*.csv`/`*.tex`; `grep -c xlsx .gitlab-ci.yml` = 0 | W1-B |
| U-05 | A9-S3 xlsx-Tests + Fassung-3-Blattform | `[AB]` nicht registriert — `[OD]` auf `origin/development` als `test_a9s3_mess_ebene_blattsorte.cpp` (263 Z.) vorhanden | **W-1 neu erheben** |
| U-06 | `pmc:intel` | kein generischer PMU-Typ auf Raptor Lake | W1-E |
| U-07 | Tier-Binary-Caching cluster-weit | opt-in, kein Zwei-Maschinen-Beweis — **und es gibt keine zweite Maschine** | **OV-9** |
| U-08 | `build:clang` | `[OD]` `274e4ed2` **ist** auf `origin/development` | **W-1 neu erheben** |

### 2.5 WIDERSPROCHEN — der Code tut das Gegenteil der Zusage

| # | Zusage | Ist | Welle |
|---|---|---|---|
| W-01 | Break-Even = kubischer B-Spline B=3 | `[AB]` 0 Treffer `b-spline\|bspline\|de.boor\|knot_vector`; gebaut: monotone Hermite + natuerlich kubisch | OV-1 → W1-A |
| W-02 | Break-Even-Implementierungen zusammenfuehren | `[AB]` **2** `BreakEvenPoint`-Typen + 3 Kurven-Modelle | W1-A |
| W-03 | `build_axis_levels`/`build_profile_basis_levels` fallen weg | beide lebend (23+7 Fundstellen) | W2-E |
| W-04 | **SECHS** CEB-Varianten (3!) | 4 baubare Identitaeten, 2 byte-gleich — **und das Gate-Modell gibt nie 6 her**, s. OV-10 | OV-10 → W2-A |
| W-05 | Mess-Exklusivitaet je Maschine (§61) | super `.gitlab-ci.yml:753/:840` haelt die **globale** Gruppe | OV-5 → W2 |
| W-06 | EINE Perzentil-Methode | 2 Verfahren gleichen Namens; Formel 1 Rang zu hoch ⇒ p99 == max fuer n ≤ 100 | W1-A |
| W-07 | Konformitaets-Gate blockiert | **pfadabhaengig**: ce `perm_runner.hpp:196,:289` gaten scharf; super `v32_katalog_driver.hpp:128/:152/:154` schreibt nur, **0 Leser** | W2-E + OV-11 |
| W-08 | OP-1..OP-6 messen verschieden | `operator()(size_t, WorkloadKind /*kind*/, uint64_t)` — Parameter unbenannt | W2-E |
| W-09 | `--enable-X=no` schaltet aus | erzeugt `-DX=NO=ON` ⇒ CMake liest `NO=ON` ⇒ **wahr** | W1-D |
| W-10 | XML-Bestand ist wohlgeformt | 5 committete XMLs brechen jeden normkonformen Parser, **2 davon GENERIERT** | W1-D |
| W-11 | `make check` faehrt die Suite | `[AB]` ce `Makefile:83-86` ohne Reconfigure — **`[OD]` auf `origin/development` bereits geheilt** (`check: inventar`, `inventar: all` mit `$(CMAKE) -S -B`) | **erledigt, W-1 verifiziert** |
| **W-12** | **Thesis: Zwei-Maschinen-Betrieb, zwei Vendor-Lanes, P/E-Core getrennt** (`05_evaluation.tex:78-79`, Praesens) | `getent hosts prod2` -> rc 2. Eine Lane. Der 9950X3D hat keine E-Cores; die Hybrid-CPU (i9-12900K) fehlt | **OV-9, Entscheid vor W3** |
| **W-13** | **Thesis: „Bau- wie Mess-Laeufe ... 4096 Binaries am Stueck ... gleichverteilte Zuteilung ueber die Maschinen ... inventarisierter Wiederaufnahme"** (`:139-140`, Praesens) | drei Zusagen, die die Mess-Seite nicht haelt: kein 4096er-Korn, eine Maschine, kein Resume | **W2-C oder Textkorrektur** |
| **W-14** | **Thesis: „vor jeder Messung steht die Konformitaetspruefung am Pruef-Dock"** (`:138`, Praesens) | wahr fuer `perm_runner`, unwahr fuer den Katalog-Treiber | **W2-E + OV-11** |

### 2.6 ENTLASTUNGEN — was der Entwurf zu duester sah

| # | Befund | Beleg |
|---|---|---|
| E-1 | `make check` ohne Reconfigure | auf `origin/development` **geheilt** (s.o.). W0.1 entfaellt in der Entwurfsform |
| E-2 | „A9-S4 = 386 Dateien" | **6 Commits, 17 Dateien, 1940+/103-** gegen `origin/development` |
| E-3 | „heutige Commits nicht gelandet" | **alle 13** sind auf `origin/development` |
| E-4 | Thesis-Anhaenge B/E leer | heute gefuellt (257/157 Zeilen) — kein offener Posten |
| E-5 | OV-7 „fuenfte Mess-Ebene unauffindbar" | **im Ledger beantwortet**: LEDGER:11098 „DIE FUENF MESS-EBENEN -- endlich vollstaendig", :11104 Owner woertlich „Also 5." Der Entwurf hat eine Explore-Luecke als Owner-Frage ausgegeben — Verstoss gegen „ALLES IST GEPLANT" |
| E-6 | Hybrid als Abgabe-Risiko | `05_evaluation.tex:153-154` formuliert ihn bereits im **Futur** — keine Falschaussage, nur fehlende Leistung |

---

## 3. DAS RECYCLING

**Grundsatz:** uebernommen wird alles, was traegt. Entsorgt wird nichts per Behauptung — **jede Alt-Einheit bekommt eine Zielwelle oder einen Beleg fuer den Wegfall** (Einwand 12).

| Alte Einheit | Status | Entscheid |
|---|---|---|
| **Phase 1** Laufend + Lager | Bausteine da (T-01…T-09), Konsumenten fehlen | → **W1-B**, Inhalt unveraendert, Auftrag neu: *Konsument statt Baustein* |
| **Phase 2** Stempel-/ABI-Abschluss | weitgehend erledigt. Offen: **der Anker** (A2-SHA512-Gate, TP1-FINAL) | Anker → **W3-A** |
| **Phase 3** Parallel-Spuren | Sammelbecken ohne eigene Semantik | faellt als *Phase* weg; Pakete nach Abhaengigkeit in W1/W2 |
| **Phase 4** Beweise + Permutationen | vollstaendig offen | → **W2-D**, unveraendert |
| **Phase 5** Trigger-Sequenz | nie begonnen; Sequenz sachlich richtig | → **W3-B, WOERTLICH**. Nur die Zahl aendert sich (D-3) |
| **Phase 6** Messung | USER-GO-STOPP | → **W4**, Gate-Natur unveraendert |
| **Phase 6.5** Nach-Abgabe-Behaelter | nie beruehrt | → **W7** |
| **Phase 7** §75-Aufraeumpass (133 Kandidaten, 104 offen) | gegatet | → **W7, NACH der Abgabe** (Begruendung Abschnitt 8, R-3) |
| **Phase 0.5** Hygiene-Block | Dauerlast | → **Dauerspur**, nie kritischer Pfad |
| **W7-A** (Bare-Metal-Vorlauf) | „aufgegangen" — **ohne Nachweis** | → **W-1**: der Landestand wird baremetal ohne CI gebaut, literal protokolliert. Das ist der Vollzug, nicht die Behauptung |
| **W7-B** (CMakeGraphBuilder SCHARF, §40.c = §0-DoD5) | **DoD-Posten** — kann nicht „aufgehen" | → **Abnahme-Bedingung von V-5**: je Welle ein baremetal-Bau ohne GitLab-CI, literal. Nicht entsorgt |
| **W8** (Flag-Signatur-Modell §40.a) | Flaeche des Flag-Grammatik-v2-Umbaus, **laeuft heute noch** (mmx-Deklaration offen, LEDGER:8347ff) | → **Fingerprint-Sperrliste (W1-G)**, nicht entsorgt |
| **W9** (Konformitaets-Sammelwelle) | = die heutige Wachen-Klasse | → **W0a/W0b** |
| **Wellenplan-Vollbild 06.08.** („max-parallel") | am Objekt widerlegt, 0/3 Stimmen | **nicht uebernommen** |
| **GESAMTBILD 08.08.** (Welle 0/A/B/C/D/E/F) | jung, kritischer Pfad sauber erkannt | **strukturell uebernommen**. Welle A rueckt vor (W1-A). **Teil D-5 (Hysterese-Band) wird NICHT stillschweigend uebernommen** — s. OV-12 |
| **§66 „LAGER+STEMPEL = GATE FUER VOLL-BUILD"** (LEDGER:3573, G1–G5) | im Entwurf **nicht vorhanden** | → **W3-C Vorposten**, Checkliste mit ausgegebenem Nenner |
| **§59-Kette** (5 TODOs, LEDGER:3285-3289) | im Entwurf **nicht vorhanden** | → **W1-F** (SCHEMA/EMITTER/TEMPLATE) + **W2-B** (MERGE-STEMPEL/STORAGE) |
| **Paper-Kopplung** (LEDGER:11117-11128) | im Entwurf nach W7 geschoben | → **OV-13**, nicht implizit durch Einsortierung |

**Nummernkreise:** acht kollidierende Kreise werden auf **einen** gefuehrt: `W-1 … W7`. Alle Altnummern bleiben oben als Herkunftsvermerk (Doku nie loeschen, nur deprecaten).

---

## 4. DAS NEUE WELLENSYSTEM

**Grundsatz:** innerhalb einer Welle laufen Spuren gleichzeitig — **aber nur, wo die Dateien wirklich disjunkt sind** (Einwand 20 hat gezeigt, dass der Entwurf das behauptete, wo es nicht galt). Es gibt **fuenf** echte Sequenzialisierungen, nicht drei (Einwand 45). Jede ist unten begruendet.

### ZEITBUDGET UND RESERVE (Einwand 40)

```
verfuegbar : 27 Werktage  +  11 Wochenendtage (09.08.-15.09.)
verplant   : 26 Werktage  ->  Auslastung 96,3 %
RESERVE    :  1 Werktag  +  11 Wochenendtage = BENANNTES Ausfallbudget
```

Der Entwurf verplante 27 von 27 Werktagen (100,0 %) und wies kein Puffer-Budget aus. Korrigiert. **Entnahme-Stand wird je Welle gefuehrt** (Abschnitt 5). W-1 entnimmt bereits: **Sa 08.08. + So 09.08.** (2 Wochenendtage). W5 wird auf **3 Arbeitstage** ausgelegt, Do/Fr sind Fangnetz fuer W4-Verzug.

```
15.09. Di   ABGABE
11.09. Fr   L5  Thesis fertig, Anhang inhaltlich belegt, PDF baut   <- LETZTE LIEFERUNG
09.09. Mi   L5-Kern (Auswertung + Text stehen; Do/Fr = Fangnetz)
04.09. Fr   L4  Messung abgeschlossen, Auswertung laeuft
28.08. Fr   L3  Bau abgeschlossen, USER-GO-VORLAGE                  <- IDENTITAETS-FREEZE
21.08. Fr   L2  alle fingerprint-/stempelberuehrenden Pakete gelandet
14.08. Fr   L1  Auswertungskette hat an BEIDEN Enden Anschluss
10.08. Mo   L0  Landestand erhoben, Wachen sagen die Wahrheit
```

---

### W-1 — INTEGRATIONS-LANDUNG UND NEUERHEBUNG · Sa 08.08. – So 09.08. (Reserve-Entnahme 2 Tage)

**SEQUENZIALISIERUNG 1 VON 5.** Der gesamte Diff dieses Plans ist ueber einem Baum erhoben, der 29 Commits hinter `origin/development` liegt. Ohne diese Welle baut jede spaetere Welle gegen eine Bestandsaufnahme, die schon beim Schreiben falsch war. Kosten: ein Wochenende, das ohnehin nicht in den 27 Werktagen steckt. Nutzen: die Gueltigkeit des gesamten Abschnitts 2.

| Paket | Inhalt |
|---|---|
| W-1.1 | Arbeitsbaum auf `origin/development` bringen (**merge, nie rebase**), Landestand-SHA festschreiben |
| W-1.2 | **A9-S4 landen**: `bau/a9-s4-mess-report` → `development`. Gemessen: 6 Commits, 17 Dateien, 1940+/103-, davon `tools/mess_report/{main.cpp, mess_report_render.hpp, realm_scan.hpp, skip_manifest.hpp, dynamic_axis_filter.hpp}` + 4 Testdateien. **Damit fallen F-06 und F-14 aus dem Diff** |
| W-1.3 | **A.1–A.5 NEU ERHEBEN** gegen den Landestand. In JEDE Zeile die Erhebungs-SHA schreiben, nicht nur ins Vorwort |
| W-1.4 | **W7-A-Vollzug**: baremetal `configure.sh && make && make check` ohne GitLab-CI, literal protokolliert |
| W-1.5 | W-11 verifizieren: `check: inventar` traegt tatsaechlich das Reconfigure (nachgemessen, Gegenprobe erforderlich) |

**Abhaengigkeit nach aussen:** keine.
**Abnahme (Nenner = 5 Pakete, jedes mit eigener Zeile in Abschnitt 7).**

---

### W0a — WACHEN-WAHRHEIT, HARTER TEIL · Mo 10.08. vormittags (0,5 Tage)

**SEQUENZIALISIERUNG 2 VON 5.** Nur der Teil, der W1-**Abnahmen** gatet, steht vor W1 (Einwand 22). Jede W1-Abnahme zitiert `ctest` oder die Abdeckungs-Wache; luegen die, sind alle W1-Vollzuege erfunden.

| Spur | Paket | Datei |
|---|---|---|
| W0a.1 | **Abdeckungs-Wache: Nenner ausserhalb der eigenen Inventur verankern.** Nicht ein Werkzeug nachtragen, sondern: die Menge der `STATUS_OUT`-gegatteten Bloecke aus der CMake-QUELLE erheben (**LIVE fuenf**: `tests/unit/CMakeLists.txt:1070 _r5i_status`, `:1118 _pa_status`, `:1150 _fj_status`, `:1177 _f15_status`, `:1545 _r5g_ae_status`, an **zwei** Werkzeugen) und fuer jeden ein `FOUND` im Configure-Log verlangen. **Jede `SKIPPED`-Zeile im Configure-Log ist rot** — heute sieht kein Job hin (`grep SKIPPED` ueber ce CI/scripts/Makefile = 0 Treffer) | ce `scripts/ci_test_coverage_guard.sh`, `.gitlab-ci.yml` |
| W0a.2 | **`f15_compare_cli_smoke` — alle DREI Risse**: (1) `PASS_REGULAR_EXPRESSION` ignoriert den Exit-Code; (2) das Muster prueft `Ranking .schnellste`, der Kommentar nennt `win_rate` — nach der Heilung prueft der Test weiter etwas anderes als angekuendigt; (3) rohes `add_test` **ohne** `set_property(GLOBAL APPEND PROPERTY COMDARE_TEST_TARGETS ...)` — genau die Unterlassung, die im selben File als „#278 ... 52x Not Run" beschrieben ist. Die manifest-basierte Wache kann ihn sonst nicht sehen | ce `tests/unit/CMakeLists.txt` |
| W0a.3 | `make check`-Reconfigure **verifizieren statt bauen** (auf `origin/development` vorhanden). **Der super-Weg taugt NICHT als Vorbild**: `Code/CMakeLists.txt:213/245` zieht ce und prt-art mit `EXCLUDE_FROM_ALL` ein — die „610 registrierte Tests vor wie nach dem Reconfigure" ist Folge des Ausschlusses, keine Messung (Einwand 36) | ce `Makefile`, Beleg-Kommentar super |

**Warum W0.1 nicht mehr in der Entwurfsform vorkommt:** die Heilung ist gelandet. Was bleibt, ist die Gegenprobe.

---

### W1 — DIE OFFENEN ENDEN · Mo 10.08. nachm. – **Fr 14.08. (L1)** · 8 Spuren

**Zweck:** die Auswertungskette bekommt an **beiden** Enden Anschluss; die Bau-Menge wird rechenbar **und ausdrueckbar**; das Mess-Gate wird trennbar.

**WAS BEWUSST PARALLEL LAEUFT — und der Widerspruch dazu, offen benannt (Einwand 18):**
Spur A (Auswertung) laeuft gleichzeitig mit B/D (Mess-Pfad). **Der Ledger sagt an dieser Stelle das Gegenteil:** LEDGER:4750-4752 — *„Die Reihenfolge ist nicht Geschmack, sondern Abhaengigkeit: B-10 braucht B-9 braucht B-7/B-8 braucht die Messung braucht B-3/B-5"*, und B-9 (Funktions-Synthese + Break-Even-Rechnung) steht dort mit *„offen | nach Abgabe"*. **Aufloesung:** die Ledger-Zeile gilt fuer die **FORM** der Kurve, nicht fuer den **CODE**. W1-A baut ausschliesslich Datenunabhaengiges: ein Kurvenmodul, eine Serialisierung, ein Ranking-Emitter, ein Transport. Die dreifache Querschnitts-Form (F-05) ist **datenabhaengig** und steht ausdruecklich in W5. Damit ist der Hebel echt und der Ledger nicht ueberfahren.

**REIHENFOLGE INNERHALB DER WELLE (Einwand 20 — die Spuren sind NICHT dateidisjunkt):**
Drei Spuren treffen `libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp` (3.035 Zeilen): S-E in `lazy_csv_header():470` und `format_csv_row():623`; S-B in `mess_pfad_synchron_push:1200` und am `measurement_sink`-Feuerpunkt `:2865-2871`; S-A am Header-Vergleich `:1146` (`expected_header = lazy_csv_header()`), der zugleich der **Resume-Schluessel** ist.
**Bindend:** `S-E aendert lazy_csv_header ZUERST und EINMALIG (Mo/Di). S-A und S-B bauen ab Mi gegen den neuen Header.` Keine zweite Spaltenaenderung in dieser Welle.

| Spur | Pakete | Deckt |
|---|---|---|
| **S-A AUSWERTUNG** | A9-S5 Erstbeleg (**zweiteilig**, s.u.) · **Break-Even-KANON**: 3 Kurven-Modelle → 1 Modul, 2 `BreakEvenPoint`-Typen → 1 · Serialisierung als String · LaTeX-Anlage: Auswertungs-Emitter (Break-Even, beste je Last, beste 5) · **U-03 `anhang:forward` scharf** (`AF_GENERATOR` belegen, das geschluckte `git add ... 2>/dev/null \|\| true` faellt) | F-04 F-07 W-01 W-02 U-03 |
| **S-B LAGER-KONSUMENTEN** | G-E3 Host-Binder · Realm-Wurzeln auf `/mnt/comdare-buildsystem` · `COMDARE_BESTANDSLOG` in der CI **setzen** · `persist:measurements` um `*.xlsx` · F-15 Schwere-Stufe | T-01…T-04 F-15 U-04 |
| **S-C MESS-EBENEN** | **G3 aus dem STATISTICS-Gate loesen** (7. Feld im `mess_gates_glied`, A8-S4-Wache erweitern) · Pfad-A-Timer unter das neue Gate · ENTSCHEID: Ebenen-Flags == CEB-Gates, EIN Mechanismus | S-01 |
| **S-D BAU-MENGE** | **`--check-size` bauen** · **`<measure_selection>` bauen** (Schema + XSD + Validator + Teilmengen-Garantie) · `configure.sh --enable-X=no` (W-09) · 5 nicht wohlgeformte XMLs, **2 davon generiert** (W-10) | F-01 F-01b W-09 W-10 |
| **S-E PMC/HARDWARE** | L3-PMU-Typ dynamisch (amd_l3 Typ 17, RAW aus `format/`) · `cpu_core`/`cpu_atom` im Oeffner · **B-3 PMU-Domaenen-Spalte (ZUERST, s. Reihenfolge)** · `cache_misses_l2`/`coherence` oeffnen | F-09 U-06 |
| **S-F §59-VORLAUF** | §59-SCHEMA (K1 Structs+Parser, K2 XSD, K3 validate, K4 Director, K6 Auto-Phasen — **golden-neutral**) · §59-EMITTER (K5, additiv, ce-only byte-gleich) · §59-TEMPLATE | F-17 (Teil 1) |
| **S-G SPERRLISTE** | **Fingerprint-Preimage maschinell auszaehlen**, nicht schreiben. Nenner steht im Code: `anatomy_fingerprint.hpp:416 kAnatomyFingerprintGliedCount = 9` mit benannten Indizes (System 2, Toolchain 5, Bvset 6, Overlay 7, MessGates 8). Jedes Glied bekommt eine Welle **oder** den Vermerk „bewusst offen" | R-2 |
| **S-H NAHT (eigener Besitzer)** | Das gemeinsame Ergebnis von S-A und S-B: **eine echte Mess-CSV → xlsx im Realm-Baum**. Eigenes Paket mit eigenem Termin, weil es keine der beiden Spuren allein erzeugen kann (Einwand 33) | T-01+T-02 |

**A9-S5 ist zweiteilig (Einwand 16).** Der Archiv-Bestand kann die Fassung-3-Blattform nicht belegen: `docs/archiv/messdaten/20260606-fullpilot-320/tier150_measurements.csv` hat 5.761 Zeilen und **134 Spalten**, davon **0** mit Praefix `op_`. Die Funktions-Spalten `op_<art>_{n,p50_ns,p99_ns}` fehlen vollstaendig, ebenso `workload`, `two_phase_valid`, `series`, `pruefling_type`, `quality_flag`. Fassung 3 ist aber „Sheets je FUNKTION bzw. je ACHSE" — gegen dieses Archiv ist |F| = 0.
- **W1-A5a** gegen das 06.06.-Archiv: INFO-Blatt + |A| Achsen-Blaetter, header-getrieben, fehlende Spalten als `n/a`. Geht heute.
- **W1-A5b** gegen einen **frischen Mini-Lauf** mit heutigem `lazy_csv_header`: ein Binary, eine Perm, Minuten statt Tagen. Kein Mess-Pfad-Ergebnis, blockiert die Parallelitaet nicht — aber ohne diesen Schritt ist A9-S5 **kein** Erstbeleg der Fassung 3.

**Abhaengigkeit nach aussen:** W-1, W0a.

---

### W0b — WACHEN-WAHRHEIT, MESS-TEIL · Spur INNERHALB W1, Abnahme vor W3

Diese vier gaten die **Messung**, nicht den Bau — sie muessen nicht vor L1 stehen (Einwand 22, gewinnt einen Tag fuer L1).

| Spur | Paket |
|---|---|
| W0b.1 | measure-Gate: **ueber ALLE gefundenen CSVs iterieren**, nicht nur `head -1`. Zwei Zahlen (Dateien gesamt / Dateien mit >= 2 Zeilen), Differenz != 0 = rot. Zeilen per `awk 'END{print NR}'`, **nicht `wc -l`** — eine Datei ohne Schluss-Umbruch faellt sonst faelschlich rot (Einwand 34) |
| W0b.2 | Diff-Wache `--seit-basis`: `ncommits==0` = ABBRUCH. **Zusaetzlich `.sh` in den Scope**: `scripts/ci_diff_ascii_width_guard.sh:218-231 is_scoped()` kennt `CMakeLists.txt`, `.cpp/.hpp/.h/.hh/.cc/.cxx/.tpp/.ipp/.inl/.cmake` — **kein `.sh`**. Die Wachen selbst sind heute unbewacht |
| W0b.3 | `changes`-Allowlist um `ci/**` und `scripts/**`; ce GNU-Bauweg unter CI-Wache; `COMDARE_LINT_PATHS` zeigt ins Leere + `tools/` fehlt |
| W0b.4 | **`scripts/lint_flags_includes.sh`**: endet bei leerer Tabelle mit `WARN` + Exit 0 (= „gruen mit Nenner 0"), und LIVE ist sein einziger Aufrufer `.github/workflows/ci.yml` — in der ce-`.gitlab-ci.yml` **null Mal**. In die massgebliche GitLab-Strecke ziehen, sonst bewacht es nichts |
| W0b.5 | **`ci/thesis_gitlink_parity.sh`**: sichert im Kopf zu, git-Fehler-Exits seien fatal, waehrend der git-Aufruf **links einer Pipe ohne `pipefail`** steht — Hausfalle K11 |
| W0b.6 | **WACHEN-REGISTER** (E.0, Abschnitt 7) — **Nenner unabhaengig, Koeder gefahren** |
| W0b.7 | F-13 super-Abdeckungs-Wache |

**`drift_detector` ist hier NICHT mehr enthalten** (Einwand 25). Die Einstufung „das einzige Drift-Gate laesst die kaputte Messung durch" ist sachlich falsch: LIVE kommen `DriftVerdict`, `assess_drift` und `run_with_drift_gate` **ausschliesslich** in `builder/commands/drift_detector.hpp` und `tests/unit/test_chaos_drift_gate.cpp` vor. Es laesst nichts durch — **es laeuft nicht.** Ein neuer Enum-Wert `unbestimmbar` ohne Leser waere exakt die Klasse T-11/W-07, die dieser Plan bekaempft. Der Posten wandert als **T-15 nach W2-C**: *verdrahten*, nicht *erweitern*.

---

### W2 — IDENTITAET, STEMPEL UND BEWEIS · Mo 17.08. – **Fr 21.08. (L2)** · 7 Spuren

**SEQUENZIALISIERUNG 3 VON 5.** S-A (CEB-Varianten) kann nicht vor W1-S-C laufen. Am Objekt: heute existieren **2** unterscheidbare Gate-Zustaende, weil `macro` und `micro` an EINEM Makro haengen. Ohne G3 sind `[wallclock,macro]` und `[wallclock,micro]` byte-gleiche Kompilate mit verschiedenen Fingerprints — ein kontrolliertes Experiment, dessen unabhaengige Variable nachweislich nichts tut. Das ist Physik der Uebersetzungseinheit, keine Gewohnheit.

**DAS BUMP-BUENDEL (Einwaende 8 und 21) — neue, bindende Auflage:**
LEDGER:135 und :408: *„ABI-Freeze (§4): nach 3→4 **genau EIN** weiterer Bump 4→5"*, gefuehrt als offenes Risiko **B4**. Im Fenster laufen **mindestens fuenf** Anspruchsteller darauf zu:

```
1. G3-Gate-Split          (mess_achsen_naht.hpp: "beruehrt abi_adapter.hpp im Hot-Path")
2. §59-MERGE-STEMPEL      (POD 56 -> 72, layout 2 -> 3; LEDGER:3287)
3. RF-7 Stempel-Klammerung (Komplex-Achse = EIN Feld, je Achsen-Typ EINE Array-Zeile)
4. IDriveableTier-Split    (SOLL: "ABI-Major-Bump Pflicht")
5. checkpoint_measure      (nur falls OV-2 (a); neues Mess-Ebenen-CMake-Flag)
6. A16 E-24-Gate-Verankerung (SOLL: "letzter ABI-Schritt")
```

**Bindend:** der Bump 4→5 wird **genau einmal** gezogen, gebuendelt. Abnahme: **genau ein Magic-Wechsel im Diff des gesamten Fensters.** Jeder einzelne Bump kostet einen kompletten Binary-Neubau, den das Fenster nach W3 nicht hergibt.

| Spur | Pakete |
|---|---|
| **S-A CEB-VARIANTEN** | CEB-Varianten scharf (braucht W1-S-C) · golden-XML `<measurement_tooling>` von 1 auf N Combos. **Zusammengelegt mit der alten S-C** — beide arbeiten an derselben XML-Sektion und sind nicht disjunkt (Einwand 16): die eine multipliziert die Mess-Menge, die andere friert sie ein |
| **S-B STEMPEL/§59** | §59-MERGE-STEMPEL (K7a) · §59-STORAGE (K7b/K8) · RF-7 Stempel-Klammerung · **das Bump-Buendel ziehen** |
| **S-C MESS-VERTRAG** | **F-16 Mess-Resume auf 4096er-Korn** (Bau-Korn ist da, Mess-Seite nicht) · **T-15 `drift_detector` VERDRAHTEN** (`run_with_drift_gate` in `perm_runner`/`parallel_measure_pool`) · **T-16 `projiziere_kampagne` verdrahten** · Mess-Menge fixieren, Profil-Fenster, 12 Perms |
| **S-D BEWEISE** | Beweise 1–4 · **E-07-Gate Stufe 2** (10 `E07_*`-Zeilen) · **U-01 dynamische Planer-CI: eine gefahrene Kaskade mit Job-ID** |
| **S-E RESTBAU** | **F-10 B-2 Pinning-Konsument + T-11 B-4 Warntext** (LEDGER:4740 stuft B-2 als **CEB-ONLY, vor der Voll-Messung** ein — also **vor** dem Freeze, nicht in W4) · **F-08 COMPARE/D2** (aus W5 vorgezogen, weil modusberuehrend — Einwand 46) · A14/OS-U4 · A10 P4-P6 · KF-6 NTTP · Cross-Genus in die Registry · FK-3/FK-5 Handlisten → Walk · T-06…T-14 · **W-07 Katalog-Treiber an das scharfe `perm_runner`-Gate angleichen** · W-03 · W-08 |
| **S-F ABGABE-VORLAUF** | **F-19 FF0–FF4-Abnahmematrix anlegen** · **F-07b Diagramm-Emitter** · **F-18 `.ps1`/`.py`-Abloesung + Verdrahtung `measure → 08_appendix_generator → anhang/tabellen → PDF`** · **DE-Ergebniskapitel als Geruest mit fixen Platzhaltern** (damit W5 Zahlen einsetzt statt Prosa erfindet) |
| **S-G THESIS (Dauerspur)** | DE fuehrt, EN zieht nach |

**Was NICHT sequentialisiert wird:** S-D laeuft parallel zu S-A/S-B — Beweis 1–4 pruefen Resume, Prune, Variant-Gate und Bestandslog, alles Flaechen aus W1.

---

### W3 — ANKER, TRIGGER UND BAU · Mo 24.08. – **Fr 28.08. (L3)**

**SEQUENZIALISIERUNG 4 VON 5 (zwischen den Wellen):** D-0 darf erst laufen, wenn kein identitaetsberuehrendes Paket mehr aussteht. Eine Mess-Achsen-Aenderung baut CEB **und alle** Binaries neu (LEDGER:4330-4339). Ein Bump nach dem Bau vernichtet den Bestand und das Fenster.

**SEQUENZIALISIERUNG 5 VON 5 (INNERHALB W3) — der Entwurf hat sie als Parallelitaet verkauft (Einwand 45):**
S-A → S-B → S-C ist eine **strikte Kette**: der Anker muss stehen, bevor Phase 5 gegen ihn kalibriert; Phase 5 endet mit dem **Bau-Trigger**, und genau der startet S-C. S-C ist das letzte Glied, nicht eine Parallelspur. Dazu die Laufzeit: prod1 allein baut mit **19,4 min je 4096er-Scheibe x 128 Scheiben ≈ 41,4 h**.

```
Mo 24.08.          S-A  D-0 Anker + TP1-FINAL
Di 25.08.          S-B  Phase 5 bis Bau-Trigger
Mi 26.08. 06:00    S-C  Bau-Start  (~41 h)
Do 27.08. abends   S-C  Bau fertig
Fr 28.08.          S-D  USER-GO-VORLAGE + Puffer
WAEHREND DES BAU-FENSTERS: keine CI-Last, keine Agenten-Last auf prod1.
```

| Spur | Pakete |
|---|---|
| S-A | D-0 Anker-Setzung + TP1-FINAL (9 Gates + E2E-`.rsp`-Beweis), `kFrozenFingerprintV1` in drei Spiegeln synchron |
| S-B | **Phase 5 woertlich**: J-Kette (N = lebendes ctest-Gate, live erheben) → heavy-Signal → Kalibrierlauf `GN_TOTAL=64` → ETA → Trigger. **Der Kalibrierlauf IST der Vollzugs-Beleg fuer U-02** |
| S-C | **§66-Vorposten G1–G5 als Checkliste mit ausgegebenem Nenner** (B/C/D-Landung, Stempel-Finalisierung, Bestandslog-Kern, Push-Aktivierung, Pruning lokal→0; LEDGER:3573) · **Test-Skip-Gesetz**: Skip nur bei vorhandenem gruenem Test-Log **neben** der Binary; fehlendes Log = Neubau · dann Durchlauf 1 (Wurzel `binaries`, lazy, 4096er) |
| S-D | **USER-GO-VORLAGE Phase 6** — EINE Vorlage, nicht sieben |
| S-E | parallel weiter: Auswertungs-Reste, Thesis, Hygiene — **aber nicht auf prod1 waehrend des Bau-Fensters** |

---

### W4 — MESSUNG · Mo 31.08. – **Fr 04.09. (L4)** · **USER-GO-STOPP**

**Der Plan bereitet vor. Er geht nicht darueber hinweg.**

Hartes Vor-Gate: **§59-SCHEMA (aus W1-F) muss stehen** — nicht „E.0", das war im Entwurf ein Name mit falschem Zeiger (Einwand 1). Danach **zwei** getrennte GOs: (1) 320er-Abgabemessung, (2) Voll-Messung.

| Spur | Pakete |
|---|---|
| S-A | Messung (nur nach GO), Durchlauf 2 (Wurzel `measurements`, lazy), **mit 4096er-Resume aus W2-C** |
| S-B | Auswertung ab dem ersten Batch — die Kette steht seit W1 |
| S-C | L3-Asymmetrie getrennt je Domaene (Vorbedingung F-10 ist in **W2-E** gelandet, nicht mehr offen) |
| S-D | Rueckschrieb: WRITE-Token, NAS + minio, inkl. xlsx |

---

### W5 — AUSWERTUNG UND ABGABE-TEXT · Mo 07.09. – Mi 09.09. (Kern) · **Do/Fr = Fangnetz** · **Fr 11.09. L5**

Break-Even-Kurven ueber alle drei Ebenen (**F-05, hier erst datenverfuegbar**) · LaTeX-Anlage inhaltlich belegt in der Abgabe · **FF0–FF4-Matrix ausfuellen** · Thesis-Ergebniskapitel C5 (Zahlen in das W2-Geruest) · DE/EN-Nachzug · Backups.
**COMPARE/D2 ist NICHT hier** — es wurde nach W2-E vorgezogen (modusberuehrend, `measure ⊂ compare ⊂ release`).
**Abhaengigkeit:** Messdaten aus W4.

### W6 — ABGABE-SICHERUNG · Mo 14.09. – Di 15.09.
PDF baut, **Anhang gegen Nenner belegt** (nicht „drin"), Backups, Spiegel. **Keine Bau-Eingriffe.**

### W7 — NACH DER ABGABE (Behaelter)
§75-Aufraeumpass (133 Kandidaten, 104 offen) · Phase 6.5 · **Hybrid-Bau (F-03)** · `checkpoint_measure`-Bau (falls OV-2 (b)) · Record-and-Replay (F-11) · Paper-Research-Vollausbau (falls OV-13 (b)) · PV-1 `.so`-ABI · Doku-Anker-Sanierung.

---

## 5. DIE SEQUENTIELLE AUFGABENKETTE

Ohne Ruecksprung lesbar. `[R]` = Reserve-Entnahme. `##` = Paketnummer.

```
=== W-1  Sa 08.08. - So 09.08.  [R: 2 Wochenendtage, Rest 1 WT + 9 WE-Tage] =====
 01  Arbeitsbaum auf origin/development mergen (NIE rebase). Landestand-SHA fixieren.
 02  A9-S4 landen: bau/a9-s4-mess-report -> development (6 Commits, 17 Dateien).
 03  A.1-A.5 gegen den Landestand NEU erheben. Erhebungs-SHA in JEDE Zeile.
 04  Baremetal-Bau ohne GitLab-CI, literal protokolliert (W7-B-Vollzug, V-5).
 05  make-check-Reconfigure gegenpruefen (auf origin/development bereits vorhanden).

=== W0a Mo 10.08. vormittags ====================================================
 06  Abdeckungs-Wache: Nenner aus der CMake-QUELLE (5 STATUS_OUT-Bloecke),
     jede SKIPPED-Zeile im Configure-Log = rot.
 07  f15_compare_cli_smoke: Exit-Code + richtiges Muster + COMDARE_TEST_TARGETS.

=== W1  Mo 10.08. nachm. - Fr 14.08. (L1) =======================================
 08  [S-E, ZUERST] lazy_csv_header EINMALIG aendern: PMU-Domaenen-Spalte (B-3).
 09  [S-E] L3-PMU-Typ dynamisch; cpu_core/cpu_atom; cache_misses_l2/coherence.
 10  [S-D] --check-size bauen. Ausgabe: Zahl je working_set-Stufe UND je
     Combo-Fanout (Ist-XML mit 1 Combo, Ziel-XML mit N Combos).
 11  [S-D] <measure_selection> bauen: Schema + XSD + Validator + Teilmengen-Garantie.
 12  [S-D] configure.sh --enable-X=no; 5 nicht wohlgeformte XMLs (2 generiert).
 13  [S-C] G3 aus dem STATISTICS-Gate loesen; 7. Feld im mess_gates_glied.
 14  [S-G] Fingerprint-Sperrliste MASCHINELL: kAnatomyFingerprintGliedCount = 9.
 15  [S-F] §59-SCHEMA + §59-EMITTER + §59-TEMPLATE (golden-neutral).
 16  [S-A] Break-Even-KANON: 3 Kurvenmodelle -> 1; 2 BreakEvenPoint-Typen -> 1.
 17  [S-A] Break-Even-Serialisierung als String (parsbar).
 18  [S-A] Perzentil: EINE Methode, Rang-Formel korrigieren (p99 != max bei n<=100).
 19  [S-A] LaTeX-Anlage: Auswertungs-Emitter (Break-Even, beste je Last, beste 5).
 20  [S-A] anhang:forward scharf: AF_GENERATOR belegen, `|| true` beim git add faellt.
 21  [S-B] Realm-Wurzeln + G-E3 Host-Binder + COMDARE_BESTANDSLOG in beiden CI setzen.
 22  [S-B] persist:measurements um *.xlsx; F-15 Schwere-Stufe an den Lagerklassen.
 23  [S-H] NAHT (eigener Besitzer): echte Mess-CSV -> xlsx im Realm-Baum.
 24  [S-A] A9-S5a gegen das 06.06.-Archiv (INFO + |A| Achsenblaetter, op_-Spalten n/a).
 25  [S-A] A9-S5b gegen einen FRISCHEN Mini-Lauf (1 Binary, 1 Perm) -> Funktionsblaetter.
 26  [W0b, Spur] measure-Gate ueber ALLE CSVs (awk NR, zwei Zahlen).
 27  [W0b] Diff-Wache: ncommits==0 = ABBRUCH; .sh in den Scope.
 28  [W0b] changes-Allowlist ci/** + scripts/**; GNU-Bauweg unter CI-Wache.
 29  [W0b] lint_flags_includes.sh in die GitLab-Strecke; Nenner 0 = rot.
 30  [W0b] thesis_gitlink_parity.sh: pipefail (K11).
 31  [W0b] WACHEN-REGISTER: Nenner unabhaengig, Koeder GEFAHREN.

=== W2  Mo 17.08. - Fr 21.08. (L2)  IDENTITAETS-FENSTER =========================
 32  [S-A] CEB-Varianten scharf (braucht 13). golden-XML von 1 auf N Combos.
     ZUSAMMENGELEGT mit der Mengen-Fixierung - dieselbe XML-Sektion.
 33  [S-B] §59-MERGE-STEMPEL (POD 56->72, layout 2->3) + §59-STORAGE + RF-7.
 34  [S-B] BUMP-BUENDEL ZIEHEN: genau EIN Magic-Wechsel 4->5 im gesamten Fenster.
 35  [S-C] Mess-Resume auf 4096er-Korn (F-16).
 36  [S-C] drift_detector VERDRAHTEN (T-15) + projiziere_kampagne verdrahten (T-16).
 37  [S-E] F-10 B-2 Pinning-Konsument + T-11 B-4 Warntext (CEB-ONLY, vor Freeze).
 38  [S-E] COMPARE/D2 (F-08) - aus W5 vorgezogen.
 39  [S-E] W-07: Katalog-Treiber an das scharfe perm_runner-Gate angleichen.
 40  [S-E] T-06..T-14, W-03, W-08, A14/OS-U4, A10 P4-P6, FK-Walk statt Handliste.
 41  [S-D] Beweise 1-4 + E07-Gate Stufe 2 + U-01 gefahrene CI-Kaskade (Job-ID).
 42  [S-F] FF0-FF4-Abnahmematrix anlegen; Diagramm-Emitter (F-07b).
 43  [S-F] .ps1/.py-Abloesung + Verdrahtung measure -> 08_appendix_generator -> PDF.
 44  [S-F] DE-Ergebniskapitel als Geruest mit fixen Platzhaltern.
 45  [S-G] Thesis DE fuehrt, EN zieht nach.

=== W3  Mo 24.08. - Fr 28.08. (L3)  STRIKT SERIELL ==============================
 46  Mo: D-0 Anker + TP1-FINAL, drei Spiegel byte-identisch.
 47  Di: Phase 5 woertlich: J-Kette -> heavy -> Kalibrierlauf GN_TOTAL=64 -> ETA.
 48  Di: §66-Vorposten G1-G5 als Checkliste MIT ausgegebenem Nenner.
 49  Mi 06:00: Bau-Trigger. Durchlauf 1, ~41 h. KEINE andere Last auf prod1.
 50  Do abends: Bau fertig. Zweitlauf-Gegenprobe.
 51  Fr: USER-GO-VORLAGE Phase 6 (EINE Vorlage). Puffer.

=== W4  Mo 31.08. - Fr 04.09. (L4)  USER-GO-STOPP ===============================
 52  Vor-Gate: §59-SCHEMA steht. Zwei getrennte GOs (320er / Voll).
 53  Messung, Durchlauf 2, mit 4096er-Resume.
 54  Auswertung ab dem ersten Batch.
 55  L3-Asymmetrie je Domaene.
 56  Rueckschrieb: WRITE-Token, NAS + minio, inkl. xlsx.

=== W5  Mo 07.09. - Mi 09.09. (Kern), Do/Fr FANGNETZ, Fr 11.09. L5 ==============
 57  Break-Even dreifach querschneidend (F-05) - erst hier datenverfuegbar.
 58  LaTeX-Anlage inhaltlich belegt (Nenner, nicht "drin").
 59  FF0-FF4-Matrix ausfuellen: leer beantwortete Frage = rot.
 60  Ergebniskapitel C5: Zahlen in das W2-Geruest. DE fuehrt, EN zieht nach.
 61  Backups (sofort bei Fertigstellung).

=== W6  Mo 14.09. - Di 15.09. ===================================================
 62  PDF baut; Anhang gegen Nenner belegt; Spiegel; keine Bau-Eingriffe.

=== W7  nach der Abgabe =========================================================
 63  §75 (104 offen) · Hybrid · checkpoint_measure (falls OV-2 b) · Record-and-Replay
     · Paper-Vollausbau (falls OV-13 b) · PV-1 · Doku-Anker-Sanierung.
```

---

## 6. REGRESSIONS-PAKETE

**Verteilungsregel (bindend):** ein Defekt wird in der Welle geheilt, in der die Flaeche ohnehin angefasst wird — nie in einer eigenen Aufraeum-Welle. Begruendung: die Liste waechst schneller als sie schrumpft (ASCII 1132→1160, Prosa 29→54, `organ_location` 79→97, heute gemessen). „Spaeter aufraeumen" ist eine Schuld mit Zinsen.

### W0a — blockierend fuer W1-Abnahmen (2)

| ## | Defekt | Klasse | Warum hier |
|---|---|---|---|
| 06 | Abdeckungs-Wache: Nenner ist die **eigene** Inventur; 5 `STATUS_OUT`-Bloecke, keiner beobachtet; `SKIPPED` liest niemand | blockiert-abgabe | Eine Wache, deren Nenner ihre eigene Inventur ist, kann einen fehlenden Nenner grundsaetzlich nicht bemerken |
| 07 | `f15_compare_cli_smoke`: Exit-Code ignoriert **+** falsches Muster **+** nicht in `COMDARE_TEST_TARGETS` | blockiert-abgabe | W0 macht sonst die Wache ehrlich und laesst denselben Test fuer sie unsichtbar |

### W0b — blockierend fuer die Messung, Abnahme vor W3 (6)

| ## | Defekt | Klasse |
|---|---|---|
| 26 | measure-Gate akzeptiert leeres Fenster; Ersatz `head -1` haette Nenner 1 | blockiert-messung |
| 27 | Diff-Wache GRUEN mit Nenner 0 (5. Fall); `.sh` nicht im Scope (`is_scoped():218-231`) | wichtig, strukturell |
| 28 | `changes`-Allowlist ohne `ci/**`+`scripts/**`; GNU-Bauweg unbewacht | wichtig |
| 29 | `lint_flags_includes.sh`: WARN + Exit 0 bei leerer Tabelle; nur in `.github`, nicht in GitLab | wichtig — **im Entwurf nicht enthalten** |
| 30 | `thesis_gitlink_parity.sh`: git links einer Pipe ohne `pipefail` (K11) | wichtig — **im Entwurf nicht enthalten** |
| 31 | kein Meta-Gate ueber den Wachen | strukturell |

### W1 — auf den Flaechen, die W1 ohnehin anfasst

| Spur | Defekte |
|---|---|
| S-A | Perzentil-Formel 1 Rang zu hoch (p99 == max fuer n ≤ 100) · zwei Verfahren gleichen Namens · `parse_u64_cell` nicht streng (Phantom-Punkt bei x≈1,8e19 zieht den Spline) · REV-DATA-12 zeigt auf zwei geloeschte Werkzeuge · **A9-Design Abschnitt 1 invertiert** (A9-S4 baut GEGEN dieses Dokument) · **`anhang:forward`: `git add ... 2>/dev/null \|\| true` + „IDEMPOTENT: 0 Aenderungen" + Exit 0** |
| S-B | `file_size` ohne `ec`-Pruefung (2^64 in ETA und Lager-Eintrag) · xlsx INFO-Blatt Zahlenzelle statt Text (`10.0` → `10`) · `WritebackMethod`-Kommentar ohne `xlsx` |
| S-C | `COMDARE_LINT_PATHS` ins Leere + `tools/` fehlt · cppcheck-Ignore als Handliste |
| S-D | 5 nicht wohlgeformte XMLs, **2 generiert** · `--enable-X=no` schaltet EIN · `distclean`-Wache greift nicht |
| S-E | `cache_misses_l2`/`coherence` nie geoeffnet |
| quer | `Partitions-Beleg` vergleicht nicht, er druckt `==` · Abdeckungs-Wache `declared:VAR` fail-open |

### W2 — am Mess-Vertrag

`conformance_passed` 0 Leser im super-Katalog-Treiber (`v32_katalog_driver.hpp:128/:152/:154`) — **pfadabhaengig**, ce ist scharf (`perm_runner.hpp:196,:289`) · WorkloadKind-Phantom-Etiketten · Workloads/Datasets hartkodiert (2000/2000/42) · `sota_series merge` ungeprueft · `metadata.mode` stiller Rueckfall auf `Defined` · `<output>`-Pfad gegen CWD · `<lebewesen>`/`phase.engine` steuern nichts · `ledger_nachtrag.sh`-Gegenprobe blind fuer den einen Fehler · **`drift_detector` unverdrahtet (T-15)** · **`projiziere_kampagne`/`BatchPlanner` unverdrahtet (T-16)** · **`appendix_generator` fail-open**: `"$APP" ... || echo "honest-empty ... kein Fehler"` — das `|| echo` faellt ersatzlos.

### W3 — vor dem Trigger

Mess-Exklusivitaet: **zwei Doktrin-Staende koexistieren** (global `super .gitlab-ci.yml:753/:840` vs. je Maschine §61). Muss **vor** dem Bau entschieden sein (OV-5), sonst serialisiert die globale Gruppe die Flotte — soweit es eine gibt (s. OV-9).

### Dauerspur (nie kritischer Pfad)

13 Doku-Drift-Befunde: Anker-Drift 60/125 in `docs/architecture` (48 %) · ce/super `README` · beide `INDEX.md` · beide `PROJECT_LAYER_MAP` · Achsenzahl 22 vs. 18 in 5 Dokumenten · §75-Kandidatenliste mit verfallenen Ledger-Zeilen.
**Aber:** die **Anker-Wache** (Bezeichner statt Zeile) wird in W0b.6 mitgebaut — sonst waechst der Rueckstand, waehrend wir ihn abtragen.

---

## 7. VERIFIKATIONSVERTRAG

Vier Formen von Schein-Gruen sind belegt: uebersprungener Job, Nenner 0, Koeder der nie anschlug, Gate das nie aufging. Der Vertrag schliesst **die Klasse** aus.

### 7.0 WACHEN-REGISTER — Nenner unabhaengig, Koeder gefahren (##31)

Der Entwurf hat das Register ueber **Zitate** definiert („jede Wache, die in irgendeiner Abnahme zitiert wird") und die Koeder-Belege als **Textfelder** gefuehrt. Beides erbt den Defekt, gegen den es gebaut wird (Einwand 26): eine nicht eingetragene Wache macht den Job nicht rot, sondern nur kleiner; und ein abgeschriebener Koeder-Beleg sieht im Register aus wie ein echter — woertlich „der blinde Koeder und die blinde Wache sehen identisch aus". Korrigiert:

**(a) Nenner ausserhalb des Registers.** Grundmenge = alle ausfuehrbaren Dateien unter `ci/` und `scripts/` **beider** Repos plus alle CI-Jobs, die ein Verdikt drucken. Groessenordnung heute: ce `scripts/` = 8 `.sh`, super `scripts/`+`ci/` = 5 `.sh`, 28 (ce) + 30 (super) Top-Level-CI-Schluessel. **Abgleich in BEIDEN Richtungen rot:** unregistrierte Wache = rot, verwaiste Registerzeile = rot.

**(b) Der Koeder wird GEFAHREN, nicht dokumentiert.** Der Register-Job erzeugt je Wache eine **zufaellig erzeugte** Verletzung (K13: nie aus einer Doku abgeschrieben), ruft die Wache und erwartet `rc != 0`. Erst der gefahrene Rot-Lauf fuellt `koeder_rot` — nicht der Autor.

| Feld | Bedeutung | Fehlt es → |
|---|---|---|
| `nenner_ausdruck` | wie die Wache ihre Grundmenge zaehlt | Job rot |
| `abbruch_bei_null` | Datei:Zeile des Exit != 0 bei leerer Menge | Job rot |
| `koeder_rot` | **vom Job erzeugt**, nicht eingetragen | Job rot |
| `koeder_gruen` | **vom Job erzeugt** | Job rot |
| `gate_vollzug` | Job-ID + Log-Zeile eines wirklich gefahrenen Laufs | Job rot |

### 7.1 Sechs Vertragszeilen, gueltig fuer JEDE Welle

| # | Regel |
|---|---|
| **V-1 NENNER** | Jede Wache druckt ihre Grundmenge **und prueft sie**. Nenner 0 = Exit != 0, nie GRUEN. |
| **V-2 KOEDER BEIDSEITIG** | Zufaellig erzeugt (K13), Rot-Lauf **vor** der Heilung protokolliert (V11). |
| **V-3 GATE-VOLLZUG** | Ein `rules`-Gate gilt erst als erfuellt, wenn ein Job mit Job-ID und Log-Zeile lief. YAML-Absicht zaehlt nicht. |
| **V-4 DIFFERENZ-BELEG** | Die Wache muss zwei Zustaende unterscheiden. Beide Zahlen ausgeben, nicht nur die gruene. |
| **V-5 DUAL-WEG (§61)** | Jede Funktion CI **und** baremetal belegt, beide literal. **Das ist zugleich der W7-B-Vollzug.** |
| **V-6 PLAN-NENNER** *(neu, Einwand 31)* | **Der Abnahme-Nenner einer Welle ist die Anzahl ihrer Pakete.** Jedes Paket braucht eine eigene Zeile unten. Eine Welle mit einem Paket ohne Abnahmezeile gilt als **nicht abgenommen**. Der Entwurf listete fuer W0 neun Defekte und gab fuenf Abnahmezeilen — eine Welle, deren Abnahme weniger Pakete zaehlt als sie hat, ist per Konstruktion eine Wache mit zu kleinem Nenner. |

### 7.2 Konkret je Welle

**W-1** (Nenner 5)

| ## | Befehl | Erwartete Ausgabe | Koeder |
|---|---|---|---|
| 01 | `git -C ce rev-list --count HEAD..origin/development` | `0` | vor dem Merge muss dieselbe Zeile `29` liefern — **beide Zahlen ins Protokoll** |
| 02 | `git -C ce diff --stat origin/development...bau/a9-s4-mess-report` nach dem Merge | `0 files changed` | vorher: `17 files changed, 1940 insertions(+), 103 deletions(-)` |
| 03 | Diff-Neuerhebung | je Zeile eine Erhebungs-SHA; **Liste der Zeilen, die sich geaendert haben** | eine Zeile absichtlich gegen `b2daf9a6` erheben → Wache muss die SHA-Differenz melden |
| 04 | `./configure.sh && make && make check` ohne CI, baremetal | ctest-Zahl literal | CI-Umgebungsvariablen setzen → Bau muss trotzdem ohne CI laufen |
| 05 | `ctest -N` vor/nach Reconfigure | zwei Zahlen + Differenz | Test registrieren, der **nur** nach dem 2. Configure existiert |

**W0a** (Nenner 2)

| ## | Befehl | Erwartete Ausgabe | Koeder |
|---|---|---|---|
| 06 | `sh scripts/ci_test_coverage_guard.sh` | `STATUS_OUT-Bloecke in der Quelle: 5` · `FOUND im Configure-Log: 5` · Vergleich | einen der fuenf Bloecke kuenstlich scheitern lassen → `SKIPPED` im Log → **rot**. Zusaetzlich: einen sechsten Block einfuegen → Zaehler muss auf 6 gehen |
| 07 | `ctest -N \| grep f15_compare_cli_smoke` **und** Abdeckungs-Wache | Test in der Inventur **und** einem Job zugeordnet — **beide Zahlen** | CLI mit `exit 1` bei korrekter Ausgabe → Test muss rot werden (heute gruen) |

**W1** (Nenner 24 Pakete; hier die tragenden)

| ## | Befehl | Erwartete Ausgabe | Koeder |
|---|---|---|---|
| 10 | `comdare-experiment-planner --check-size Code/test_data_xml/experiment_golden_kern.xml` | **zwei Zahlenreihen**: je `working_set`-Stufe eine Zahl, und je Combo-Fanout eine (Ist-XML N=1, Ziel-XML N=3). **Nicht „eine Zahl"** — die naechste Welle vervielfacht sie planmaessig (Einwand 16) | XML mit einer Achse weniger → **kleinere** Zahl. XML mit leerem `<axes_default_lookup>` → **Fehlerklasse**, nicht 0 |
| 10b | ein echter Lauf bei `working_set 8.388.608` | eine gemessene Zeit je Binary bei der **groessten** Stufe | ohne diesen Punkt bleibt die W4-Kiste geraten: 0,1094 s ist laut eigener Quelle eine **Untergrenze** aus 16 Datenzeilen mit Spanne 6,5–448,4 ms (Faktor 69) |
| 11 | `comdare-experiment-planner --validate <xml mit measure_selection>` | Deckelung liefert **kleinere** `--check-size`-Zahl als dieselbe XML ohne | Mess-Eintrag auf eine **nicht deklarierte** Permutation → **Fehlerklasse**, nicht Warnung |
| 13 | `nm` auf zwei Kompilate `[wallclock]` vs. `[wallclock,micro]` | **benannte Symbole der micro-Instrumentierung** vorhanden/abwesend | **Der Byte-/Hash-Vergleich ist hier WERTLOS** (Einwand 28): `COMDARE_ANATOMY_VERSION_STAMP_M` (`anatomy_module_abi_v1.hpp:162-204`) bettet `kFP` ein, und `MessGatesGlied` entsteht **rein praeprozessoral** aus den Gate-Makros. Sobald G3 ein viertes Segment einbringt, unterscheiden sich zwei Kompilate im Hex — **auch wenn G3 keine einzige Zeile gatet**. Ein reiner Groessenvergleich ist umgekehrt tautologisch unerfuellt. **Stempel-Region (`kFP`/`kL`) aus dem Vergleich ausnehmen, im Test als Kommentar begruenden** |
| 14 | Sperrlisten-Wache | `Preimage-Glieder: 9` (aus `anatomy_fingerprint.hpp:416`), je Glied eine Welle oder „bewusst offen" | Preimage auf 10 erweitern → Wache **rot**, nicht still groesser |
| 23 | `comdare_mess_report render <mess.csv> <ziel>` | **Zeilenzahl je Blatt gegen die Zeilenzahl der Eingangs-CSV**, Summe beider Seiten | **Nicht `unzip -l` allein** (Einwand 32): die Blattzahl `1+|F|+|A|` stammt aus derselben Quelle wie der Schreiber, und `unzip -l` sieht Worksheet-Parts, nicht Inhalt — ein Writer mit der richtigen Anzahl **leerer** Blaetter bestuende. Koeder: Ziel nicht schreibbar → Fehlerklasse, nicht stiller Skip |
| 23b | SKIP-Pfad, zweiter Lauf | **zwei Zahlen**: `geschrieben` / `uebersprungen`. Erstlauf: `geschrieben >= 1`. Zweitlauf: `uebersprungen == N` **und** `geschrieben == 0` | ohne diese Trennung erfuellt eine **alte** Datei aus einem frueheren Lauf die Bedingung „xlsx entsteht" — Owner-KERN 3 verlangt aber bei neuer Binary-Version einen neuen Datensatz **neben** dem alten |
| 20 | `anhang:forward` Lauf | Job-ID + geaenderte Dateien | leeres `AF_GENERATOR` → **rot**, nicht „IDEMPOTENT: 0 Aenderungen / Exit 0" |
| 26 | measure-Gate lokal | `CSVs gesamt: N` · `CSVs mit >= 2 Zeilen: M` · `N == M` | eine von N Dateien auf Kopfzeile reduzieren → rot. **`awk 'END{print NR}'`, nicht `wc -l`** |
| 31 | Register-Job | `gefundene Wachen: N` · `registrierte: N` · **je Wache ein gefahrener Rot-Lauf** | eine Wache aus dem Register loeschen → rot; eine Registerzeile ohne Datei → rot |

**W2** (Nenner 14 Pakete; hier die tragenden)

| ## | Befehl | Erwartete Ausgabe | Koeder |
|---|---|---|---|
| 32 | Combo-Bau | **`4` paarweise verschiedene Kompilate + belegte Begruendung, warum nicht 6** — s. OV-10 | heute liefert das Verfahren **2** → Test heute ROT |
| 34 | `git log -p` ueber das gesamte Fenster, Filter auf das ABI-Magic | **genau EIN** Magic-Wechsel 4→5 | zwei Bumps im Fenster → rot. Das ist die Wache gegen Risiko B4 |
| 35 | Mess-Lauf nach 2 Batches hart abbrechen, neu starten | `measured_new` ueberspringt die gemessenen Zellen — **zwei Zahlen** | ohne Resume startet der Lauf bei 0 → rot |
| 36 | Lauf mit kuenstlich degenerierter Zelle | **`reruns: n`, `abgebrochene Zellen: m`** — echte Wirkung | Wenn `run_with_drift_gate` weiter nur im Test vorkommt: **Paket nicht abgenommen** |
| 41 | `E07_*` | **zehn** Zeilen **mit Nenner**; Negativproben N1–N3 muessen anschlagen | Bypass-Suche, Stale-Artefakt, Fenster-Teilmenge |
| 41b | CI-Kaskade | **Job-IDs** von Parent/Child/Grandchild | inert-by-default: ohne gefahrene Kaskade gilt U-01 als offen |
| 39 | Katalog-Treiber mit `conformance_passed == false` | Lauf bricht ab | heute laeuft er durch (0 Leser) → Test heute ROT |

**W3** (Nenner 6 Pakete — der Entwurf deckte nur drei)

| ## | Befehl | Erwartete Ausgabe | Koeder |
|---|---|---|---|
| 46 | Anker in drei Spiegeln | byte-identisch | einen Spiegel um ein Byte drehen → ROT |
| 47 | Kalibrierlauf | ETA gegen `--check-size`, Abweichung > 50 % = **Abbruch** | **ACHTUNG, die Zaehler sind NICHT unabhaengig** (Einwand 29): `eta_kalibrierung.hpp:294-296 projiziere_kampagne(posten, binaries_je_perm, zellen_soll)` — der Kommentar sagt woertlich „Beide kommen vom Aufrufer — dieser Header raet keine Kampagnen-Groesse". Kalibriert wird nur die **Zeit je Binary**; die **Stueckzahl** ist derselbe Wert, den `--check-size` liefert. **Der zweite Zaehler muss die MENGE unabhaengig erheben**: begrenzter Probelauf auf einem Teilbaum, Auszaehlung der real entstandenen Blaetter/Verzeichnisse im Lager-Baum, hochgerechnet gegen die Ankuendigung |
| 48 | §66-Checkliste | `G1..G5: 5/5` mit ausgegebenem Nenner | ein Gate ausbauen → `4/5` → rot |
| 50 | Zweitlauf | **drei Zahlen**: `built_new == 0`, `lager_skip == N`, **`skip_ohne_testlog == 0`** | ein uebersprungenes, nie getestetes Binary sieht im Bestandslog sonst aus wie ein gruen getestetes (Test-Skip-Gesetz) |
| 51 | USER-GO-VORLAGE | eine Datei, alle Entscheide, ein Termin | zwei Vorlagen → rot |

**W4** (Nenner 5)

| ## | Befehl | Erwartete Ausgabe | Koeder |
|---|---|---|---|
| 53 | Mess-Lauf | **`zellen_mit_echtem_messwert / zellen_gesamt`** plus **Haeufigkeit jedes Ersatz-Tokens** (`n/a`, `failed`, `gesperrt`, `nicht_gebaut`, `-`, `""` — Single-Source `measurement_curve_loader.hpp:72`), alle Zahlen gedruckt **und im Exit-Code**. Schwelle vorab: **`nicht_gebaut > 0` = Abbruch vor der Auswertung** | **„Zeilenzahl > 0 je Zelle" ist WERTLOS** (Einwand 24): der Bau-Fehler-Zweig in `cache_engine_builder_iterator.hpp:2421` schreibt die `nicht_gebaut`-Marker-Zeile **als neue result.csv** und zusaetzlich in die globale CSV. Eine Kampagne, in der **keine einzige Binary** gebaut werden konnte, haette in jeder Zelle > 0 Zeilen, korrekte Spaltenzahl und exakt die angekuendigte Zellzahl — und bestuende die Entwurfs-Abnahme vollstaendig |

**W5/W6** (Nenner 5 + 1)

| ## | Befehl | Erwartete Ausgabe | Koeder |
|---|---|---|---|
| 58 | Anhang-Wache | **Soll-Liste der `\InputIfFileExists`-Ziele (28) gegen die im Lauf WIRKLICH gefundenen Dateien** — beide Zahlen, Differenz != 0 = rot | **„Anhang drin" ist heute tautologisch wahr** (Einwand 23): `anhang/de/A_measurements.tex` bindet jede Tabelle als `\InputIfFileExists{...}{}{Ersatztext}` (28 Eintraege, Kommentar Z.73 „kompiliert auch VOR dem ersten Messlauf sauber"), und das §7-Hard-Gate `thesis/.gitlab-ci.yml:80-83` prueft `-halt-on-error`, Warnings <= 1 und `.blg` — **keines zaehlt Tabellen**. Ein PDF ohne eine einzige Messtabelle baut gruen |
| 58b | `\thesisfinal`-Schalter | unter `\thesisfinal` ist der Ersatztext-Zweig ein **LaTeX-Fehler**, kein Absatz | dann traegt das bestehende `-halt-on-error` die Aussage. **Und das `\|\| echo "honest-empty ... kein Fehler"` hinter dem `appendix-generator` faellt ersatzlos** |
| 59 | FF0–FF4-Matrix | je Frage: Zelle + Zahl. **Leer beantwortete Frage = rot**, Nenner 5 | eine Frage ohne Zelle → rot |
| 57 | Anlage bei duenner Datenlage | „kein Break-Even bestimmbar", **keine erfundene Kurve** | Datensatz mit nur einer Binary |
| P-1 | **Praesens-Zusagen-Wache** (s. Abschnitt 8, R-3) | `geprueft: 3 / erfuellt-oder-korrigiert: 3` | eine Zusage weder erfuellt noch korrigiert → rot. Nenner 3, Abbruch bei 0 |

---

## 8. RISIKEN GEGEN DEN 15.09.

### R-1 — Die Ausgabe-Kette ist an beiden Enden offen (hoechstes Risiko)

**Befund.** Ziel der Arbeit: „aus Wuenschen in der XML nach ein paar Tagen automatisch Messwerte **und Auswertung**". Heute: `ErgebnisMappenFactory` = 3 Header + 6 Test, **0 Produktion**; `make_*_baum_writer` **0 Produktion**; `mess_bestand` **0 Treffer** in super `Code/`; Break-Even ohne Serialisierung; LaTeX-Anlage emittiert Rohdaten statt Auswertung; `anhang:forward` — der **einzige** Transport Messwerte → Thesis-Submodul — hat `AF_GENERATOR` per Default leer und schluckt sein `git add` (`2>/dev/null || true`, danach „IDEMPOTENT: 0 Aenderungen", Exit 0). Es koennte am 04.09. eine vollstaendige Messung vorliegen und **kein Weg**, sie in die Abgabe zu bringen.

**Gegenmassnahme.** Die gesamte Kette **einschliesslich des Transports** (U-03) wird in W1 vorgezogen und laeuft parallel zur Messvorbereitung. Verifiziert **zweiteilig**: A9-S5a gegen das Archiv (das die `op_`-Spalten nicht hat — 0 von 134 Spalten mit diesem Praefix), A9-S5b gegen einen frischen Mini-Lauf von Minuten. Die Naht S-A/S-B ist ein **eigenes Paket mit eigenem Besitzer** (W1-S-H), nicht eine Nebenbedingung zweier Spuren. **Fallback OV-8** gilt jetzt **symmetrisch** fuer S-A und S-B — der Entwurf deckte nur S-A.

### R-2 — Die Mess-Menge ist weder rechenbar noch ausdrueckbar, und der Anker kann kippen

**Befund, in drei Teilen.**
1. `--check-size` fehlt. Die einzige vorliegende Rechnung ergibt fuer 524.288 Binaries **~143 Tage einthreadig** — Faktor ~4 gegen das Restfenster, und das ist eine **Untergrenze**: 0,1094 s wurde bei `working_set_n = 4096` gemessen, der golden-Sweep geht bis 8.388.608 (**Faktor 2048** in der Datenmenge), und `total_ns` enthaelt weder Aufbau noch Zwei-Phasen-Warmup noch Rollback. Bezugsgroesse: **16 Datenzeilen** aus einem Korpus, Spanne 6,5–448,4 ms.
2. **Die Deckelung hat kein Ausdrucksmittel.** `measure_selection|measurement_selection` = **0 Treffer in beiden Repos**. Drei Auswege sind verschlossen: mehr Threads (`05_evaluation.tex:133-134` bindet „genau EINEN Mess-Thread" im Praesens), zweite Lane (existiert nicht, s. R-4), guenstigere Messung (Untergrenze). Der einzige heute existierende Weg — eine separate XML — verwirft die projekteigene Analyse als **Prinzipverstoss** (GESAMTDOSSIER:2591-2594: „eine unabhaengige zweite Menge koennte auf nie gebaute Binaries zeigen"). **Deshalb ist OV-4 im Entwurf falsch klassifiziert:** es ist kein Entscheid, es ist ein **Bau-Paket** (Planer + Schema + XSD + Validator + Teilmengen-Garantie), das den Fingerprint beruehrt und **vor** dem W3-Freeze landen muss.
3. Eine Mess-Achsen-Aenderung baut CEB **und alle** Binaries neu. Ein Bump nach dem 28.08. vernichtet das Fenster.

**Gegenmassnahme.**
1. `--check-size` **und** `<measure_selection>` sind **ein** Paket in W1-S-D. Die Zahl ohne das Ausdrucksmittel ist wertlos.
2. `--check-size` gibt **zwei Zahlenreihen** aus (je `working_set`-Stufe, je Combo-Fanout), plus einen kalibrierten Messpunkt bei der groessten Stufe. Erst dann ist die W4-Kiste rechenbar statt zugewiesen.
3. **Die Sperrliste wird ABGELEITET, nicht geschrieben.** Der Nenner steht im Code: `anatomy_fingerprint.hpp:416 kAnatomyFingerprintGliedCount = 9` mit benannten Indizes. Eine Wache leitet die beteiligten Header/Symbole daraus ab und vergleicht mit den beruehrten Pfaden. **Waechst das Preimage auf 10, wird sie rot statt still groesser.** Erst diese Wache gibt den Freeze frei. Handverfasste Sperrlisten haetten sechs Posten verschluckt: RF-8 telemetry (LEDGER:3682 — heute nur Organ-Achse T11, eine neue **Haupt**-Achse multipliziert die Menge), RF-2, RF-7, §70.9 C-3a, die bindende Achsen-Sortierung (LEDGER:11106-11113: „Voraussetzung dafuer, dass ueberhaupt isoliert gemessen werden kann"), Flag-Grammatik-v2 (**laeuft heute noch**).
4. **Bump-Buendel:** genau ein Magic-Wechsel 4→5 im gesamten Fenster, als Abnahme belegt (##34).
5. **Deckelungs-Vorlage OV-4** mit der Zahl auf dem Tisch — **nach** der Combo-Entscheidung, nicht davor.

### R-3 — Die Abgabe sagt im Praesens drei Dinge zu, die der Code nicht haelt

**Befund.** Der Entwurf optimiert „die Kette laeuft durch" und prueft nie „die Arbeit sagt die Wahrheit". LIVE in `kapitel/de/05_evaluation.tex`:

| Zeile | Zusage (Praesens) | Ist |
|---|---|---|
| `:78-79` | „Der produktive Mess-Betrieb selbst ist ein **Zwei-Maschinen-Betrieb** — eine AMD-Maschine (Ryzen 9 9950X3D) neben einer Intel-Maschine (Core i9-12900K, Alder Lake)"; dazu „zwei getrennte Hersteller-Lanes, hart gegatet", „eine stille Teil-Messung nur eines Herstellers gibt es nicht"; `:76` „auf Hybrid-CPUs werden P- und E-Cores getrennt vermessen" | `getent hosts prod2` -> **rc 2**. Eine Lane. Der 9950X3D hat **keine** E-Cores; die Hybrid-CPU fehlt |
| `:139-140` | „Bau- wie **Mess**-Laeufe werden je Maschine in Meilenstein-Batches von je 4096 Binaries am Stueck abgearbeitet, mit gleichverteilter Zuteilung ueber die Maschinen und **inventarisierter Wiederaufnahme** nach Unterbrechung" | drei Zusagen, die die Mess-Seite nicht haelt: kein 4096er-Korn, eine Maschine, **kein Resume** |
| `:138` | „vor jeder Messung steht die Konformitaetspruefung am Pruef-Dock" | **pfadabhaengig** wahr: ce `perm_runner.hpp:196,:289` gaten scharf, super `v32_katalog_driver.hpp` schreibt nur |

Dazu die wachsende Aufraeum-Liste (ASCII 1132→1160, Prosa 29→54, `organ_location` 79→97) und der Behelfsweg auf dem Lieferpfad: `build.ps1`, `build_all.ps1`, `generate_measurement_appendix.ps1`, `generate_wide_appendix.ps1`, `tools/format_tex.py` — waehrend `anhang/de/A_measurements.tex:4` die `.ps1` als Erzeuger der Tabellen nennt. „Kein Python in der Buildchain, keine Behelfswege."

**Gegenmassnahme.**
1. **SPERRLISTE DER PRAESENS-ZUSAGEN, Nenner 3.** Jede ist **entweder bis L4 erfuellt oder bis L5 im Text korrigiert**. Eine Wache prueft den Abgabe-Text gegen die Liste; Nenner 3, Abbruch bei 0 (##P-1). Still fallenlassen macht die Abgabe unwahr — das ist ein anderer Fehler als eine fehlende Leistung.
2. **STREICH-KASKADE, in dieser Reihenfolge** (was zuerst faellt, wenn die Zeit global reisst):
   ```
   1. checkpoint_measure     Owner-KERN sagt selbst "SPEZIFIZIERT, NICHT GEBAUT"
   2. Hybrid-Bau             05_evaluation.tex:153-154 formuliert ihn im FUTUR
   3. COMPARE/D2             kein Text-Bezug
   4. Break-Even-Neubau B=3  dann Hermite ratifizieren UND die Methodenwahl begruenden
   5. F-07b Diagramm-Emitter Tabellen tragen die Aussage, Diagramme schmuecken
   NICHT STREICHBAR: die drei Praesens-Zusagen oben.
   ```
   Streichbar heisst hier: **fehlende Leistung, keine Falschaussage** — `kapitel/` hat LIVE **0 Treffer** fuer „Break-Even" und **0** fuer „B-Spline".
3. **§75 faellt NACH der Abgabe** (W7). Aufraeumen vor der Messung kann eine entfernte Flaeche erst im Voll-Lauf sichtbar machen — dem teuersten Zeitpunkt. Und die Liste ist bis zum 15.09. nicht abtragbar. Ab W0b wird nur der **Zuwachs** verhindert.
4. **F-18** (`.ps1`/`.py`-Abloesung) landet in **W2**, nicht W5 — in W5 ist keine Bau-Kapazitaet mehr.

### R-4 — prod2 existiert nicht (aus An-1 hochgestuft)

**Befund.** `hostname` -> `prod1`, `getent hosts prod2` -> rc 2. Es gibt genau eine Lane. Der Bau **passt** trotzdem: 128 Scheiben x 19,4 min ≈ 41,4 h auf prod1 allein, das faellt in W3. **Der Bruch ist nicht die Zeit, sondern der Text** (R-3) — und dass die P/E-Core-Trennung (S-05, U-06, Teil von F-09) an nicht vorhandener Hardware haengt. **Erschwerend:** prod1 traegt den GitLab-Runner auf derselben Platte; ein voller `/` legt die CI lahm.

**Gegenmassnahme.** **OV-9** (Abschnitt 10), Entscheid **vor W3**, weil D-3 die Bau-Menge an die Maschinenzahl bindet. Kein dritter Weg: entweder prod2 bis L2, oder Textkorrektur mit ausgewiesener Methodikgrenze.

---

## 9. EINGEARBEITETE EINWAENDE

### 9.1 Widerlegt — mit Beleg

| Einwand | Behauptung | Widerlegung |
|---|---|---|
| 13 | „`development:Makefile` existiert nicht; W0.1 patcht ein Ziel, das ein ungemergter Branch schon umgeschrieben hat" | `git cat-file -e origin/development:Makefile` -> **EXISTS**. Die Behauptung stammt aus der **lokalen** `development`-Referenz `ba069e38`, die **80 Commits** hinter `origin/development` `5e163331` liegt. **Aber der Kern trifft anders zu:** W0.1 ist auf `origin/development` **bereits geheilt** (`check: inventar` / `inventar: all` mit `$(CMAKE) -S -B`, Zeilen 91/124-126). W0.1 faellt in der Entwurfsform weg und wird zur Gegenprobe (##05). |
| 14 | „82 Commits, 386 Dateien, 95.770 Einfuegungen; KEINER der neun heutigen ce-Commits ist auf development" | Gegen `origin/development`: **6 Commits, 17 Dateien, 1940+/103-**. Alle **13** heutigen ce-Commits sind Vorfahren von `origin/development` (`merge-base --is-ancestor` rc 0 fuer jeden). **An-4 des Entwurfs war korrekt.** Uebernommen wurde nur die richtige Konsequenz: die Landung wird ein **eigenes, vorgezogenes Paket** (W-1). |
| 6 (OV-7) | „fuenfte Mess-Ebene: Owner-Wort noetig" | LEDGER:11098 „DIE FUENF MESS-EBENEN -- endlich vollstaendig", :11104 Owner woertlich „Also 5." **OV-7 gestrichen** — es war eine Explore-Luecke, ausgegeben als Owner-Frage. Verstoss gegen „ALLES IST GEPLANT". Der Platz geht an OV-12/13/14. |

### 9.2 Eingearbeitet — tragende Einwaende

| # | Einwand | Was daraus wurde |
|---|---|---|
| 1 | §59-Kette in keiner Welle; W4 verweist auf „E.0", das etwas anderes regelt | **F-17.** §59-SCHEMA/EMITTER/TEMPLATE → **W1-S-F**; MERGE-STEMPEL/STORAGE → **W2-S-B** (stempelberuehrend, POD 56→72). W4-Vor-Gate zeigt jetzt auf §59-SCHEMA statt auf einen falschen Abschnitt. |
| 2 | Sperrliste mit unvollstaendigem Nenner; sechs identitaetsberuehrende Posten fehlen | **W1-S-G:** Sperrliste **abgeleitet** aus `kAnatomyFingerprintGliedCount = 9`, nicht geschrieben. RF-8, RF-2, RF-7, §70.9 C-3a, Achsen-Sortierung, Flag-Grammatik-v2 fallen automatisch hinein. Wache wird rot, wenn das Preimage waechst. |
| 3 | Paper-Kopplung ohne Welle; die wissenschaftliche Frage wird implizit nach W7 entsorgt | **OV-13** mit der Konsequenz im Klartext. Nicht implizit durch Einsortierung. |
| 4 | A.4 (U-01…U-08) in keiner Welle; V-3 verlangt genau diese Arbeit | Jede U-Zeile hat jetzt eine **Zielwelle** (2.4). U-03 nach W1-S-A (einziger Transport), U-01 nach W2-S-D, U-02 als Kalibrierlauf-Vollzug in W3-S-B. Der geschluckte `git add`-Fehler steht in derselben Zeile. |
| 5 | FF0–FF4/DoD fehlen; Diagramme fehlen; `.ps1`/`.py` auf dem Lieferpfad | **F-19** (Matrix, W2-S-F anlegen, W5 ausfuellen, Nenner 5), **F-07b** (Diagramm-Emitter), **F-18** (Abloesung + Verdrahtung) — alle in **W2**, wo Bau-Kapazitaet ist. Anhaenge B/E als **erledigt** vermerkt (E-4). |
| 7 | Hysterese vs. Flatter-Bereich: zwei einander ausschliessende Zusagen | **OV-12.** Bis zum Entscheid wird keine der beiden Varianten verdrahtet. GESAMTBILD D-5 wird **nicht** stillschweigend uebernommen. |
| 8 / 21 | ABI-Bump-Budget kommt nicht vor; mehrere Anspruchsteller | **Bump-Buendel** in W2-S-B, sechs Anspruchsteller aufgezaehlt, Abnahme ##34: **genau ein Magic-Wechsel im Fenster**. OV-2 um die Frage erweitert, wofuer der Bump ausgegeben wird. |
| 9 | §66 G1–G5 und das Test-Skip-Gesetz fehlen | **W3-S-C Vorposten** ##48 mit ausgegebenem Nenner; Abnahme ##50 auf **drei** Zahlen erweitert, darunter `skip_ohne_testlog == 0`. |
| 10 | `lint_flags_includes.sh` und `thesis_gitlink_parity.sh` fehlen; Register waere blind | **W0b.4/W0b.5.** Register-Nenner aus dem **Inventar** (alle `ci/`+`scripts/` `.sh` beider Repos + verdiktdruckende Jobs), Abgleich **beidseitig** rot. |
| 11 | `f15_compare_cli_smoke` hat drei Risse, der Plan heilt einen | **##07** deckt alle drei; Abnahme verlangt Sichtbarkeit in `ctest -N` **und** Zuordnung durch die Abdeckungs-Wache. |
| 15 | „Sechs CEBs" ist mit G3 arithmetisch unerreichbar | Am Objekt bestaetigt: `mess_achsen_naht.hpp:74-77` — „wallclock: braucht G1 · macro: braucht G1+G2 · micro: braucht G1+G2+G3". Eine **Kette**, keine unabhaengige Menge ⇒ maximal **4** Teilmengen. **OV-10.** W2-Abnahme auf „vier + belegte Begruendung" gesetzt, nicht auf eine Zahl, die das Gate-Modell nicht hergibt. |
| 16 | `--check-size` rechnet vor der eigenen Multiplikation; W2-S-A und W2-S-C sind nicht disjunkt; A9-S5 gegen das Archiv traegt nicht | Drei Aenderungen: `--check-size` gibt **je Combo-Fanout und je working_set-Stufe** aus; W2-S-A und W2-S-C **zusammengelegt**; A9-S5 **zweiteilig** (a: Archiv, b: frischer Mini-Lauf). |
| 17 | F-10 (B-2 Pinning) als Vorbedingung genannt, in keiner Welle | **W2-S-E**, zusammen mit T-11/B-4 („mit B-2", LEDGER:4740 stuft **CEB-ONLY, vor der Voll-Messung** ein) — also **vor** dem Freeze. W4-S-C ohne Fussnote. |
| 18 | LEDGER:4750-4752 sagt die Gegen-Reihenfolge; B-9 steht „nach Abgabe" | **Widerspruch benannt und aufgeloest** (W1-Vorbemerkung): W1-A baut den **Code** (datenunabhaengig), F-05 ist **datenabhaengig** und steht in W5. |
| 19 | `checkpoint_measure` haette im Fenster keinen Konsumenten (B-8 = „nach Abgabe") | **OV-2 umformuliert**: Option (a) nur zulaessig, **wenn B-8 im selben Paket mitgebaut wird**. Sonst waere es ein Fingerprint-Bump ohne Wirkung — exakt Klasse 2.3. |
| 20 | W1-Spuren sind nicht dateidisjunkt (`cache_engine_builder_iterator.hpp`) | **Reihenfolge INNERHALB W1 bindend**: S-E aendert `lazy_csv_header` zuerst und einmalig, S-A/S-B bauen danach. |
| 22 | W0 gatet nur teilweise; die Haelfte gatet die Messung | **W0a** (0,5 Tage, hart vor W1) / **W0b** (Spur in W1, Abnahme vor W3). L1 gewinnt einen Tag. |
| 23 | W5/W6-Gate strukturell blind gegen den Inhalt; `appendix_generator` fail-open | **##58/##58b**: Soll-Liste der 28 `\InputIfFileExists`-Ziele gegen gefundene Dateien, beide Zahlen; `\thesisfinal`-Schalter macht den Ersatztext zum LaTeX-Fehler; `|| echo "... kein Fehler"` **faellt ersatzlos**. |
| 24 | W4-Abnahme bei vollstaendig gescheitertem Bau erfuellt | **##53** ueber den **Mess-Nenner** und die Ersatz-Token (`measurement_curve_loader.hpp:72` als Single-Source), `nicht_gebaut > 0` = Abbruch. |
| 25 | `drift_detector` ist nirgends verdrahtet; W0.4 reproduziert die eigene Fehlklasse | Aus W0 **entfernt**, als **T-15 nach W2-S-C**: *verdrahten*, nicht *erweitern*. Abnahme an echten `reruns`/`abgebrochene Zellen`. |
| 26 | Register erbt den Defekt: Nenner aus sich selbst, Koeder als Textfeld | **7.0 neu**: Nenner aus dem Inventar, beidseitiger Abgleich, **Koeder vom Job GEFAHREN** (zufaellig erzeugte Verletzung, `rc != 0` erwartet). |
| 27 | W2-Abnahme 3 ist ein Vollstaendigkeitsurteil ueber eine Handliste | Sperrliste **abgeleitet** (s. Einwand 2), Wache gibt den Freeze frei — nicht ein Satz. |
| 28 | „Groessen-/Symboldifferenz" ist in beide Richtungen tautologisch | **##13**: `nm`-Diff auf **benannte** micro-Symbole; **Stempel-Region (`kFP`/`kL`) ausdruecklich ausgenommen**, im Test als Kommentar begruendet. Der Byte-/Hash-Vergleich ist als wertlos vermerkt. |
| 29 | ETA und `--check-size` sind nicht unabhaengig | **##47**: zweiter Zaehler erhebt die **Menge** unabhaengig (Teilbaum-Probelauf, Auszaehlung realer Blaetter). Zusaetzlich: **W3 nur freigeben, wenn `projiziere_kampagne` einen Produktions-Aufrufer hat** (T-16 in W2-S-C). |
| 30 | W0.2-Koeder prueft die Summe, nicht den Nenner; fuenf `STATUS_OUT`-Bloecke | **##06**: Menge aus der CMake-**Quelle**, `FOUND` je Block im Configure-Log verlangt, **jede `SKIPPED`-Zeile rot**. Zaehler muss auf 6 gehen, wenn ein sechster Block entsteht. |
| 31 | Wellen-Abnahme zaehlt weniger Pakete als die Welle hat | **V-6 PLAN-NENNER**: Abnahme-Nenner = Paketzahl; Paket ohne Abnahmezeile ⇒ Welle **nicht abgenommen**. |
| 32 | xlsx-Abnahme kollidiert mit F-14; Blattzahl ist selbstbezueglich | **##23/##23b**: Zeilenzahl je Blatt gegen die Eingangs-CSV (unabhaengiger Nenner); SKIP druckt `geschrieben`/`uebersprungen`, Erst- und Zweitlauf mit verschiedener Erwartung (= Differenz-Beleg nach V-4). |
| 33 | W1-Abnahme 2 ist eine undeklarierte vierte Kopplung | **W1-S-H Naht-Paket** mit eigenem Besitzer und Termin. OV-8 **symmetrisch** fuer S-A und S-B. |
| 35 | Alle „LIVE: 0 Treffer" ueber veraltetem Checkout | **W-1** als eigene Welle. Erhebungs-SHA in jede Diff-Zeile. Klassenvermerke `[AB]`/`[OD]` in Abschnitt 2. |
| 40 | 100,0 % Auslastung, kein Puffer-Budget | Reserve **benannt**: 1 Werktag + 11 Wochenendtage, Entnahme-Stand je Welle. W5 auf **3 Arbeitstage**, Do/Fr Fangnetz. |
| 41 | Deckelung hat kein Ausdrucksmittel; OV-4 ist kein Entscheid, sondern ein Bau-Paket | **F-01b `<measure_selection>`** in W1-S-D, zusammen mit `--check-size`. Abnahme ##11 mit Teilmengen-Validator und Koeder. |
| 42 | An-1 ist am Objekt falsch; Thesis sagt Zwei-Maschinen-Betrieb im Praesens zu | **R-4** als eigenes Risiko, **OV-9** als Entscheid vor W3. An-1 aus den Annahmen gestrichen. |
| 43 | W4 hat kein Wiederaufnahme-Korn; Thesis sagt es im Praesens zu | **F-16** in **W2-S-C** (nicht W4). Abnahme ##35 mit hartem Abbruch nach 2 Batches. Falls nicht gebaut: `05_evaluation.tex:139-142` **korrekturpflichtig** (R-3, Sperrliste). |
| 44 | 0,1094 s ist von der eigenen Quelle doppelt als Untergrenze markiert | **##10b**: Zahl **je working_set-Stufe** plus ein kalibrierter Messpunkt bei 8.388.608. Ohne die zweite Zahl ist die 5-Tage-Zuweisung fuer W4 selbst geraten. |
| 45 | W3 ist eine serielle Kette, als Parallelitaet dargestellt; „drei Sequenzialisierungen" ist zu niedrig | W3 mit **Stundenraster** (Mo Anker, Di Phase 5, Mi 06:00 Bau, ~41 h, Fr Puffer), keine CI-/Agenten-Last auf prod1 waehrend des Bau-Fensters. Zahl auf **fuenf** korrigiert. |
| 46 | W5 buendelt einen Bau (D2) mit dem Abgabe-Text | **F-08 nach W2-S-E vorgezogen** (modusberuehrend). W5 nur Auswertung + Text. **DE-Ergebniskapitel als Geruest in W2-S-F**, damit W5 Zahlen einsetzt statt Prosa erfindet. |
| 47 | Keine Streich-Reihenfolge; Praesens-Zusagen nicht von fehlender Leistung getrennt | **R-3**: Streich-Kaskade (5 Stufen) **plus** Sperrliste der 3 Praesens-Zusagen mit eigener Wache (##P-1, Nenner 3). |

### 9.3 Eingearbeitet — wichtige und Randnotizen

| # | Was daraus wurde |
|---|---|
| 12 | W7-A → W-1.4 (baremetal-Vollzug); **W7-B → Abnahme-Bedingung von V-5**, nicht entsorgt; W8 → Fingerprint-Sperrliste. Jede Alt-Einheit hat in Abschnitt 3 eine Zielwelle oder einen Wegfall-Beleg. |
| 34 | **##26**: ueber **alle** CSVs iterieren, zwei Zahlen, `awk 'END{print NR}'` statt `wc -l`. |
| 36 | **##05 / W0a.3**: super taugt **nicht** als Vorbild (`Code/CMakeLists.txt:213/245` mit `EXCLUDE_FROM_ALL`); die „610 Tests" ist Folge des Ausschlusses. Vermerkt. |
| 48 | W-07 praeziser gefasst: **„Katalog-Treiber an das bereits scharfe `perm_runner`-Gate angleichen"**; **OV-11** haelt fest, welcher Treiber den Voll-Lauf faehrt — davon haengt ab, ob `05_evaluation.tex:138` unveraendert stehen darf. |

---

## 10. WAS BEIM OWNER LIEGT

**Regel „ALLES IST GEPLANT":** eine nicht auflösbare Frage ist zunaechst **meine** Explore-Luecke. Vorgelegt wird nur bei (a) nicht billig ruecknehmbarem Schaden oder (b) teurem Umbau — **je mit dem Recherche-Weg, der sie nicht aufloesen konnte**. OV-7 des Entwurfs ist genau daran gescheitert und wurde gestrichen.

| # | Frage | Optionen | Empfehlung | Recherche-Weg, der es nicht aufloeste |
|---|---|---|---|---|
| **OV-1** | Break-Even-Kurve | (a) **B=3 B-Spline** wie im Owner-KERN, Neubau; (b) monotone Hermite ratifizieren (gebaut, gegen Overshoot begruendet) | **(a)** — Owner-KERN ist Gesetz. Hermite bleibt als zweite Kurve fuer die Methodendiskussion; beide Kanone aus **einem** Modul | Korpus-Suche `b-spline\|bspline\|de.boor\|knot_vector` = 0 Treffer. Der Owner-KERN nennt B=3, der Code baut Hermite. **Kein Dokument loest den Widerspruch auf** — es ist ein Konflikt zweier Owner-Aussagen, nicht eine Wissensluecke |
| **OV-2** | `checkpoint_measure` | (a) in W2 bauen — **nur mit B-8 (Macro-timed-Konsument) im selben Paket** und **innerhalb** des Bump-Buendels; (b) spezifiziert lassen, W7 | **(b)**, falls B-8 nicht mitgebaut wird | Owner-KERN 1 sagt woertlich „SPEZIFIZIERT, NICHT GEBAUT"; die Postenliste sagt „BAUEN"; LEDGER:4747 ordnet B-8 als „nach Abgabe" ein. **Drei Quellen, drei Richtungen** — keine ist juenger als die andere. Nachrangig: der Bump waere sonst wirkungslos (Klasse 2.3) |
| **OV-4** | Mess-Menge gegen das Fenster: **welche Achse wird gedeckelt** | — | Entscheid **an der W1-Abnahme, mit beiden Zahlenreihen** und **nach** der Combo-Entscheidung (OV-10) | Die Zahl existiert heute nicht (`--check-size` = 0 Treffer) und das Ausdrucksmittel auch nicht (`measure_selection` = 0 in beiden Repos). Erst beides gebaut, dann entscheidbar |
| **OV-5** | Mess-Exklusivitaet | global (super CI `.gitlab-ci.yml:753/:840`) vs. je Maschine (§61) | **je Maschine** — §61 ist juenger, Multi-Maschinen-Pflicht ist Owner-KERN. **Ein Stand muss weg, vor W3** | Zwei Doktrin-Staende koexistieren im Repo; keiner ist als aufgehoben markiert. **Praktisch nachrangig, solange OV-9 nicht entschieden ist** — mit einer Lane serialisiert ohnehin alles |
| **OV-6** | PMC-Anhangs-Umfang | volle Tabelle vs. nur belegbare Zaehler | nach W1-S-E entscheiden | Haengt an Messungen, die noch nicht liefen. **Und an OV-9**: ohne Hybrid-CPU sind `cpu_core`/`cpu_atom` nicht belegbar |
| **OV-8** | CSV-Notlinie, falls die Naht (W1-S-H) rutscht | nur als **benannte Regression + TODO**, nie still. **Symmetrisch fuer S-A und S-B** | — | „CSV wird NIE verwendet" gilt fuer die **Ausgabe**. Ob eine dokumentierte Notlinie darunter faellt, sagt keine Quelle |
| **OV-9** | **prod2 / Zwei-Maschinen-Betrieb** *(neu, aus An-1 hochgestuft)* | (a) prod2 bis **Fr 21.08. (L2)** herstellen — Text bleibt, Zwei-Lane-Gatung erfuellbar; (b) `05_evaluation.tex:70-82` auf Ein-Maschinen-Betrieb zurueckziehen, fehlende Vendor-Lane als **Methodikgrenze** ausweisen | kein dritter Weg. Entscheid **vor W3**, weil D-3 die Bau-Menge an die Maschinenzahl bindet | `getent hosts prod2` -> rc 2; `hostname` -> prod1. Kein Plan-, Session- oder Ledger-Dokument beschreibt eine Beschaffung. **Der Cluster ist fuer mich read-only** — ich kann prod2 nicht herstellen. Betrifft auch S-05, U-06, U-07 |
| **OV-10** | **„Sechs CEB-Varianten": Permutation oder Teilmenge?** *(neu)* | (a) **Teilmenge** — dann sind mit der Gate-Kette maximal **4** erreichbar, und die W2-Abnahme lautet „vier + Begruendung"; (b) **Permutation** (3! = 6, Reihenfolge des Ein-/Ausbaus) — dann muss zusaetzlich die Kette G1←G2←G3 aufgebrochen werden (macro ohne G1, micro ohne G2) | **(a)** — (b) ist ein Umbau am Gate-Modell **im Identitaets-Fenster**, mit Bump-Folge | `mess_achsen_naht.hpp:74-77` legt die Kette fest; das SOLL nennt „3-Fakultaet-PERMUTATION der Messgeraete". **Das SOLL beschreibt Reihenfolge, das Gate-Modell liefert Teilmengen** — die Definitionsluecke ist in keinem Dokument aufgeloest, wird aber am L2-Freitag zur harten binaeren Abnahme |
| **OV-11** | **Welcher Treiber faehrt den Voll-Lauf?** *(neu)* | (a) ce `perm_runner` (Konformitaets-Gate **scharf**: `:196`, `:289`); (b) super `v32_katalog_driver` (Gate **0 Leser**) | **(a)**, oder (b) erst **nach** der Angleichung in W2-S-E | Davon haengt ab, ob `05_evaluation.tex:138` („vor jeder Messung steht die Konformitaetspruefung") ohne Aenderung stehen darf. **Keine Quelle legt den Treiber fest** |
| **OV-12** | **Hysterese-Band vs. Flatter-Bereich** *(neu, ersetzt OV-7)* | (a) **Bereichs-Erkennung** — das Flattern des Schalters IST das Signal fuer den Hybrid-Umschaltbereich, keine Instabilitaet; (b) **Hysterese-Band** als Pflicht-Eigenschaft der Schaltlogik (GESAMTBILD D-5) | Bis zum Entscheid **keine** der beiden verdrahten | Ein Hysterese-Band unterdrueckt exakt das Flattern, das das Signal sein soll ⇒ **verschiedene Umschaltbereiche, verschiedene Hybrid-Zahlen in der Thesis**. Der Ledger zeigt: Frage 11 wurde nie beantwortet („bitte mehr Kontext, ich verstehe dich nicht"). SOLL und LUECKEN-Liste sagen woertlich Gegensaetzliches |
| **OV-13** | **Paper-Kopplung** *(neu, ersetzt OV-7)* | (a) eigene W2-Spur (Design + XML-Template-Referenz, Bau W2/W3, Auswertung W5); (b) nach W7 — **mit der Konsequenz im Klartext: „die Arbeit vergleicht dann Kompositionen, nicht Paper-Algorithmen je Achse"** | Der Entscheid darf **nicht implizit** durch Einsortierung nach W7 fallen | LEDGER:11117-11124 gibt den Owner woertlich: „ob nicht die Algorithmen der Anderen Paper in dieser Achse besser gewesen waeren", und das Ledger selbst nennt das „die wissenschaftliche Frage der Arbeit in einem Satz". LEDGER:11128, Owner auf „Paper-Kopplung bauen?": **„Ja unter sorgfaeltiger Design Planung bitte bauen, Ruecksprache mit mir im Detail."** Die Ruecksprache hat nie stattgefunden. Betrifft auch PV-4 und die „Regel der abstrakt-leeren Achse" |
| **OV-14** | **RF-5 (V36.B-Codegen-CMake) und A5-Value-Filter** *(neu, ersetzt OV-7)* | RF-5: LEDGER:3682/§70.5 — „Owner fordert mehr Kontext, erneut gestellt". A5-Value-Filter: LEDGER:7269 — vier Optionen ausdruecklich **„UNBEWERTET fuer den Owner-Entscheid"** | beide sind **echte** offene Entscheide, im Entwurf nicht gefuehrt | Der Ledger markiert beide selbst als offen und beim Owner liegend. Es gibt nichts nachzuschlagen — die Antwort existiert nicht |

---

## ANNAHMEN (als Annahme benannt)

| # | Annahme | Warum ungeprueft |
|---|---|---|
| An-2 | Die Mess-Dauer je Binary liegt in der Groessenordnung des Kalibrierlaufs | Ohne `--check-size` **und** ohne einen Messpunkt bei `working_set 8.388.608` ist jede Zahl geraten. 0,1094 s ist von der eigenen Quelle doppelt als **Untergrenze** markiert; Bezugsgroesse 16 Zeilen, Spanne Faktor 69. Genau deshalb sind F-01 und ##10b die haertesten W1-Posten |
| An-3 | Die zwei Mess-GOs fallen bis spaetestens **Fr 28.08.** | Danach kippt die Rueckwaerts-Rechnung; W5 entfaellt als Auswertungsfenster |
| An-4 | `bau/a9-s4-mess-report` ist baubar | 6 Commits, 17 Dateien, 1940+/103- gegen `origin/development` — **Zahl heute verifiziert**, Bau nicht. Deshalb ist W-1.2 ein eigenes Paket mit eigener Abnahme (ctest-Zahl + gruene Pipeline auf `development`) |
| An-6 | Die 13 Doku-Drift-Befunde sind nicht abgabekritisch | **Ausnahme: A9-Design Abschnitt 1** (invertierter Befund) ist es, weil A9-S4 dagegen gebaut wird — deshalb in W1-S-A |
| An-7 | prod1 traegt waehrend des ~41-h-Bau-Fensters keine andere Last | Der GitLab-Runner laeuft auf **dieser** Platte; `/` ist LIVE zu 80 % voll, 35 von 60 GB RAM belegt. Ein voller `/` legt die CI lahm. In W3 ist Lastfreiheit **angeordnet**, nicht garantiert |

**An-1 ist gestrichen** — sie war am Objekt falsch und ist als **R-4** und **OV-9** hochgestuft.

---

## KURZFASSUNG IN NEUN ZEILEN

1. **W-1 (Wochenende):** landen und **neu erheben** — der Diff des Entwurfs steht ueber einem Baum 29 Commits hinter `origin/development`.
2. **W0a (0,5 Tage):** nur die zwei Wachen, die W1-Abnahmen gaten. Der Rest wandert als Spur in W1.
3. **W1 (L1 14.08.):** `--check-size` **und** `<measure_selection>`, G3-Trennung, §59-Vorlauf, Lager-Konsumenten, Auswertungskette **inklusive Transport**. `lazy_csv_header` aendert **eine** Spur, **einmal**.
4. **W2 (L2 21.08.):** alles Identitaets- und Stempelberuehrende — mit **genau EINEM** ABI-Bump 4→5 im ganzen Fenster. Mess-Resume, Pinning-Konsument, D2, FF0–FF4, `.ps1`-Abloesung.
5. **W3 (L3 28.08.):** **strikt seriell** — Mo Anker, Di Phase 5 + §66-G1–G5, Mi 06:00 Bau (~41 h), Fr Vorlage. Keine andere Last auf prod1.
6. **W4 (L4 04.09.):** Messung nach GO, mit Resume; Abnahme ueber den **Mess-Nenner**, nicht ueber Zeilenzahlen.
7. **W5 (Kern Mo–Mi, L5 11.09.):** Auswertung, Anlage **gegen Nenner**, FF0–FF4 ausfuellen. Do/Fr sind Fangnetz.
8. **W7:** §75, Hybrid, Paper-Vollausbau — nach der Abgabe, mit Begruendung.
9. **Ueber allem:** die drei **Praesens-Zusagen** der Thesis sind bis L4 erfuellt **oder** bis L5 korrigiert. Nenner 3, eigene Wache. Still fallenlassen macht die Abgabe unwahr.

**Fuenf Sequenzialisierungen**, nicht drei: W-1 (Landestand) · W0a→W1 (Abnahme-Ehrlichkeit) · W1→W2 (G3 vor den CEB-Varianten) · W2→W3 (Identitaets-Freeze vor dem Bau) · W3-intern (Anker → Trigger → Bau). Alles andere laeuft gleichzeitig — aber nur, wo die Dateien es hergeben.