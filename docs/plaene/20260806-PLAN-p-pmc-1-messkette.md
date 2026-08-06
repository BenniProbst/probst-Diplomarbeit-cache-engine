# PLAN 06.08.2026 -- BAU-PAKET P-PMC-1: die PMC-Pflicht in die dynamische Messkette

> STATUS DIESES DOKUMENTS: **PLANUNG. Kein Bau, kein Edit, kein Commit, kein Push vollzogen.**
> Es beschreibt, was zu tun ist, in welcher Reihenfolge, mit welchem Biss und mit welchen
> Nebenwirkungen -- und es trennt ausdruecklich, was gebaut werden kann, von dem, was der
> Owner zu entscheiden hat.
>
> ERHEBUNGSGRUNDLAGE: `Code/external/comdare-cache-engine` steht auf
> `e7aa124445e5ddab461251bdb43f81e4562b9213` -- exakt dem Stand, den Ledger-Nachtrag
> `nachmittag-10` als gruen gemessen (Pipeline 15025, 19/19 fahrende Jobs, 0 failed) und auf
> `main` fast-forwarded dokumentiert. **Jede Zeilenangabe unten ist an DIESEM Stand selbst
> nachgelesen**, nicht aus Ledger oder Voranalyse uebernommen; wo etwas Bericht ist, steht es
> als Bericht.
>
> VORLAUF (Owner-Anordnung eingehalten): zuerst Ledger `nachmittag-10` Abschnitte E/H und
> `nachmittag-9` Abschnitt D, dann `docs/sessions/20260806-ANKLAGE-kostenklammern-plan-diff.md`
> (KK-1, V-A/V-C/V-E, Arbeitsliste i-1..i-3), dann `docs/plaene/`; erst danach der Code.

---

## 0. WAS DIESES PAKET IST -- IN EINEM ABSATZ

Der vom Planer erzeugte Mess-Batch, der die 131.072-Zellen-Matrix faehrt, konfiguriert `cmake`
**ohne** `-DCOMDARE_ENABLE_PMC=ON`. Ohne dieses Makro liefert die Factory die `NullPmcSource`,
und alle Hardware-Zaehler sind strukturell 0. Der eigens dagegen gebaute Preflight wertet genau
diesen Ausfall als Erfolg und stempelt `pmc=ok`. Der Owner hat das Flag am 16.07. als **PFLICHT**
gesetzt; die Pflicht wurde beim Umbau auf die dynamische Kette nicht mitgezogen, weil sie an
**zwei Job-Namen** hing statt an einer Invariante. P-PMC-1 zieht sie nach, bindet sie an eine
Vollstaendigkeits-Bedingung statt an Zeilennummern, dreht die Wache so, dass "Quelle nicht
gebaut" ein Fehler ist, und klaert, welche Spalten der Anhang danach ehrlich zeigen darf.

**Das Fenster schliesst mit dem Trigger.** Nach dem Start des mehrtaegigen Laufs ist eine Spalte,
die 0 ist, fuer diesen Datensatz endgueltig 0 -- ein Nachziehen kostet den ganzen Lauf.

---

## 1. DIE PLAN-DECKUNG, WOERTLICH

Fuenf Owner-Stellen decken dieses Paket. Alle fuenf sind Zitate, keine Paraphrasen.

**(D1) F9 -- die Pflicht selbst (Owner 16.07., Ledger Z.532 / zitiert in `nachmittag-10` E):**

> "Die Infra hat die Einrichtung schon seit Tagen fertig. NICHT mehr gegated, kann von MIR
> [Agent] installiert werden und **MUSS als PFLICHT fuer die Vollstaendigkeit aller
> perf-Messwerte mit in die Ergebnisse**"

**(D2) I-PMC-1 -- der Vollzug vom 16.07., und genau seine Form ist die Wurzel des Rueckfalls
(Ledger Z.532):**

> "**I-PMC-1 (F9, User-PFLICHT):** `-DCOMDARE_ENABLE_PMC=ON` in **GENAU die 2 Mess-Jobs**
> (`measure:smoke` Z.449 + `measure:golden-320` Z.529) [...] Damit schreibt der naechste echte
> Mess-Lauf `pmc_available=1` + reale `cache_misses_l1` (prod1-Beweis 25.06.: 4.190.096)."

Die Pflicht wurde an zwei **Job-Namen** geheftet. Beide Jobs existieren im super noch
(`.gitlab-ci.yml:677` und `:768`, je mit dem Flag), aber `measure:smoke` ist ausdruecklich
stillgelegt (`:664-669`: "DEPRECATED-Fallback [...] durch die dynamische Kette [...] abgeloest",
laeuft nur mit `COMDARE_STATIC_SMOKE_FALLBACK=="true"`, Default AUS). Die Arbeit wanderte in den
Planer -- die Pflicht nicht.

**(D3) honest-100% (Owner 13.07., Ledger Z.555):**

> "alles echt gemessen und validiert, nur honest-100% akzeptabel" -- in-code-berechenbare Werte
> MUESSEN real implementiert werden (keine Synthese=Phantom, kein Weg-Nullen=honest-0-Aufgeben);
> [...] PMC/HW-Werte real verdrahtet lesen.

**(D4) §66-NACHTRAG-2, PMC-Doktrin je Vendor (Owner 23.07., "KERN=Gesetz", Ledger Z.3499-3501):**

> Je Maschine ihr EIGENER PMC-Pflicht-Beweis: pmc:amd nur auf der AMD-Maschine (Runner-Tag amd),
> pmc:intel nur auf der Intel-Maschine (Tag intel); **BEIDE hart (kein Gate/allow_failure)** --
> "eine Lane darf den gesamten Strang erst abarbeiten, wenn IHR pmc-Job erfolgreich ist".

**(D5) #278 -- die allow_failure-Doktrin (Owner 06.07. "PFLICHT", Ledger Z.1140; Endstand-Buchung
Z.692; verschaerft 17.07., Z.2040):**

> Z.1140: "in einer harten Pipeline darf es kein allow_failure geben -- Advisory ist NUR
> Uebergangszustand mit eingebuchter Fix-Strecke."
> Z.692: "**0 allow_failure im GESAMTEN Matrix-System** (einzige Ausnahme by design: ce
> `is_original:relock`, manual Utility)."
> Z.2040 (17.07.): "die gesamte pipeline IMMER hart gruen sein muss" -- kein allow_failure-Freibrief.

**Die haeufig zitierte Gegenstelle ist ueberholt.** "reale Cache-Misses/PMC bleiben honest-0 bis
#26" stammt aus einem Block "AKTUALISIERT 2026-07-12" -- **vier Tage aelter als D1** -- und traegt
an derselben Stelle einen SUPERSEDED-Vermerk vom 19.07. (`nachmittag-10` E, am Ledger belegt).

**Auftragslage fuer dieses Paket (Ledger `nachmittag-10` Abschnitt H, woertlich):**

> "**PMC (Abschnitt E)**: Owner-Entscheid vor Phase 6. Zu entscheiden sind DREI Dinge, nicht eins:
> (1) das Flag in die dynamische Kette **als Invariante**, nicht als Job-Name; (2) die Wache so
> drehen, dass **'Quelle nicht gebaut'** ein Fehler ist und nicht ein Skip; (3) der Anhangs-Umfang
> angesichts I-PMC-2/3 (nur L1D+dTLB)."

P-PMC-1 baut (1) und (2) und legt fuer (3) die Zahlen vor. Abschnitt 3 korrigiert dabei die
Formel "nur L1D+dTLB" -- sie ist zu pessimistisch **und** an einer Stelle zu optimistisch.

---

## 2. DER BEFUND: VIER WACHEN, KEINE BEISST

Alle Angaben in diesem Abschnitt sind von mir am Stand `e7aa1244` selbst gemessen.

### 2.1 Die Emissionsstellen

`libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp` --
`/usr/bin/grep -c COMDARE_ENABLE_PMC` auf der Datei = **0**.
`/usr/bin/grep -n "cmake -B build"` = **4 Emissionen** (dazu 1 Kommentar-Treffer `:219`):

| Zeile | Job | naechste Zeile |
|---|---|---|
| `:841` | `ceb:build` (stage `ceb-build`) | `:843` `cmake --build build --target comdare-messung-driver` |
| `:877` | `ceb:emit` | `:879` dieselbe Treiber-Zeile |
| `:1194` | Tier-**Bau**-Batch (stage `tier-build`, `timeout: 7d`) | `:1196` dieselbe Treiber-Zeile |
| `:1342` | Tier-**Mess**-Batch | `:1344` dieselbe Treiber-Zeile |

Alle vier setzen `-DCOMDARE_V32_ENABLE=ON`, **keine** setzt das PMC-Flag. **Alle vier bauen
unmittelbar danach `comdare-messung-driver`** -- und der Treiber ist die Stelle, an der die
PMC-Quelle entsteht: `make_pmc_source()` wird aus
`builder/experiment_tree/cache_engine_builder_iterator.hpp:2586` und `harness/perm_runner.hpp:130`
gerufen, beide sind Treiber-Code.

`:1194` und `:1342` teilen sich **dasselbe `Code/build`**: `emit_gn_out_persistence_variables`
(`:1091-1100`, gerufen von `:1185` und `:1322`) setzt
`GIT_CLEAN_FLAGS: "-ffdx -e Code/gn_out -e Code/build -e Code/measure_out"` + `GIT_STRATEGY: fetch`;
der Kommentar `:1087-1090` nennt es woertlich "Geteilte Single-Source fuer Build- + Mess-Batch".

### 2.2 Der Schalter

`CMakeLists.txt:67` woertlich:

    option(COMDARE_ENABLE_PMC "Intel PCM Windows cache-miss source (WindowsPcmPmcSource, BSD-3)" OFF)

Default AUS, und die Beschreibung nennt **nur Windows**. Sie gated aber auch Linux: `:69-77`
oeffnet unter `if(COMDARE_ENABLE_PMC)` -> `if(UNIX AND NOT APPLE)` den perf_event_open-Zweig und
setzt `add_compile_definitions(COMDARE_ENABLE_PMC)` -- laut eigenem Kommentar bewusst **GLOBAL**
("header-only Quelle, alle Targets"). Ohne das Flag liefert `pmc_source_factory.hpp:29-38` die
`NullPmcSource`; der Header `linux_perf_pmc_source.hpp` ist zusaetzlich selbst geguardet.
**Auf Linux gibt es ohne das Flag gar keine PMC-Quelle -- der Code kompiliert sich weg.**

### 2.3 Die vier Wachen, je mit dem Grund, warum sie nicht ausloest

| # | Wache | Ort | Warum sie nicht beisst |
|---|---|---|---|
| W1 | `m3v2_pmc_smoke` | `tests/unit/thesis_tiere/m3v2_pmc_smoke.cpp:71` | Verdikt `pmc_seam_ok = delta.available \|\| counters_all_zero` -- **lauter Nullzaehler sind das Erfolgskriterium.** |
| W2 | `linux_perf_pmc_smoke` | `.../linux_perf_pmc_smoke.cpp:58-63` | `if (!delta.available) { ... SMOKE_SKIP ...; return 0; }` -- **Exit 0.** |
| W3 | `allow_failure` | `experiment_plan_director.hpp:1333` | `allow_failure: true` am Mess-Batch -- der Job kann fallen, ohne die Ampel zu faerben. |
| W4 | **#37-PMC-Preflight** (die eigens dagegen gebaute) | `experiment_plan_director.hpp:1352-1364` | Er baut W1+W2 **in genau dem flaglosen Baum** und ruft `ctest --test-dir build -L pmc`; beide bestehen -> `echo "[PMC-TESTAT] ... pmc=ok"`. |

Der Kommentar ueber W4 (`:1352-1360`) benennt die Gefahr exakt und woertlich:

> "ohne Preflight koennte eine Lane eine mehrtaegige Messung mit kaputtem perf_event_open
> durchlaufen und lauter 0-Zaehler produzieren" -- er steht "HART in BEIDEN Profilen, auch smoke".

**Die Wache ist nicht defekt. Sie beantwortet eine andere Frage als die, um die es geht:** ohne
Flag ist die Quelle nicht kaputt, sondern **nicht vorhanden** -- und Nicht-Vorhandensein gilt
korrekt als ehrlicher Skip.

### 2.4 Was die gruene Ampel von Pipeline 15025 belegt und was nicht

`pmc:amd` und `pmc:intel` stehen dort auf `success`. Sie sind hart (kein `allow_failure`) und
bauen **mit** dem Flag (`ce .gitlab-ci.yml:114-131`, `.pmc`-Template: `cmake -B build -G Ninja
-DCOMDARE_BUILD_TESTS=ON -DCOMDARE_ENABLE_PMC=ON`, dann `ce_ctest pmc build`). **Sie belegen, dass
die PMC-Faehigkeit BAUT -- nicht, dass der Mess-Lauf sie EINSCHALTET.** Und weil ihr PASS-Kriterium
dieselben zwei fail-open-Smokes sind, belegen sie auch nicht, dass die Zaehler zugaenglich sind:
eine Maschine mit blockiertem `perf_event_open` meldet sie gruen.

### 2.5 Doku-Drift (klein, aber sie hat die Fehldeutung mitgetragen)

- `linux_perf_pmc_smoke.cpp:4` sagt: "Linux-conditional registriert (`if(UNIX AND NOT APPLE)` **+
  COMDARE_ENABLE_PMC**)". Die tatsaechliche Registrierung `tests/unit/CMakeLists.txt:3553` ist
  **nur** `if(UNIX AND NOT APPLE)` -- ohne PMC-Bedingung. Der Test existiert auf jeder Linux-Lane,
  flaglos oder nicht. (Das ist **richtig so** -- sonst braeche der Preflight am fehlenden Target;
  falsch ist nur der Kommentar.)
- `CMakeLists.txt:67` -- s. 2.2.
- `linux_perf_pmc_source.hpp:5` nennt im Kopf "best-effort L2/coherence"; `:194-195` und `:208`
  sagen dagegen ausdruecklich, beide bleiben 0 ("KEIN portabler generischer Counter -> bewusst
  NICHT geoeffnet"). Der Kopf ist die aeltere, zu optimistische Fassung.

---

## 3. WAS DER ANHANG MIT DEM FIX EHRLICH ZEIGEN KANN -- SPALTEN-BILANZ

`PmcCounters` (`include/cache_engine/measurement/pmc_source.hpp:20-27`) fuehrt **7 Zaehlfelder +
`available`**. Zeilenbelege aus `builder/linux_perf_pmc_source.hpp`:

| Feld | ohne Flag | mit Flag auf Linux | Beleg |
|---|---|---|---|
| `cache_misses_l1` | 0 | **REAL** (`PERF_COUNT_HW_CACHE_L1D`/OP_READ/RESULT_MISS) | `:202-203`, Doku `:191` |
| `cache_misses_l3` | 0 | **REAL als Last-Level** (`PERF_COUNT_HW_CACHE_LL`) | `:204-205`, Doku `:192` |
| `dtlb_misses` | 0 | **REAL** (`PERF_COUNT_HW_CACHE_DTLB`) | `:206-207`, Doku `:193` |
| `energy_micro_joules` | 0 | **BEST-EFFORT** (RAPL sysfs `/sys/class/powercap/intel-rapl:0/energy_uj`, Delta, Wraparound behandelt) | `:152-157`, `:279-288` |
| `cache_misses_l2` | 0 | **0** -- bewusst nicht geoeffnet | `:194`, `:208` |
| `coherence_invalidations` | 0 | **0** -- bewusst nicht geoeffnet | `:195`, `:208` |
| `branch_misses` | 0 | **0** -- s. 3.1 | eigene Zaehlung, s.u. |
| `available` | false | true bei Zugriff | `pmc_source_factory.hpp:29-38` |

**Damit ist die Ledger-Formel "nur L1D + dTLB" (nachmittag-10 E) an zwei Stellen zu korrigieren:**
`cache_misses_l3` ist mit Flag **real** (Last-Level; auf prod1/prod2 als Client-Desktop-CPUs ohne
L4 ist "Last-Level == L3" sachlich zutreffend -- das ist eine Hardware-Aussage, die ich nicht am
Objekt gemessen habe: **UNBELEGT**, aber pruefbar mit einem `lscpu`-Einzeiler im pmc-Job), und
`energy_micro_joules` ist best-effort real. Umgekehrt ist die Formel bei `branch_misses` zu
optimistisch -- s. 3.1.

### 3.1 NEUER BEFUND (weder im Ledger noch in der ANKLAGE): `pmc_branch_misses` ist eine Zusage ohne Deckung

`/usr/bin/grep -rn "branch_misses" --include=*.hpp --include=*.cpp` (ohne `build`-Baeume) =
**18 Treffer**. Aufgeschluesselt:

- **5 Felddefinitionen mit Default 0** (`pmc_source.hpp:24`, `measure.hpp:17`,
  `platform_snapshot.hpp:18`, `measurement_snapshot.hpp:77`, plus die Kopie),
- **1 Kopie** (`measurement_snapshot.hpp:145`: `m.branch_misses = pmc.branch_misses`),
- **2 Leser** (`i_measurement_source.hpp:175`, `system_axis.hpp:413` -- die System-Achse
  `MeasurementCategory::BRANCH_MISS` sampelt genau dieses Feld),
- **CSV-Header + Zelle** (`cache_engine_builder_iterator.hpp:504` bzw. `:777`),
- **der Rest sind TESTS**, die den Wert selbst setzen (`test_m_contract_system_axis_wurzel.cpp:165`
  = 17, `test_v5_measurement_snapshot.cpp:122` = 17, `test_a8s3_csv_klasse_c.cpp:89` = 4711).

**Keine einzige PMC-Quelle weist `branch_misses` jemals zu.** `LinuxPerfPmcSource` oeffnet drei
Counter (`:202-207`) -- `PERF_COUNT_HW_BRANCH_MISSES` ist nicht darunter; `WindowsPcmPmcSource`
nennt das Feld nicht einmal in seiner eigenen Feldaufzaehlung (`:5`).

Trotzdem steht seit 04.08. (A8-S3 / KLASSE C) die Spalte `pmc_branch_misses` im CSV-Header, mit
dieser Begruendung, `cache_engine_builder_iterator.hpp:499` woertlich:

> "(C1) pmc_branch_misses (Katalog P11, Befund B8): PmcCounters ERHEBT branch_misses real
> (pmc_source.hpp), der 7er-pmc-Block emittierte es als einziges Feld NICHT -- ein 'geschrieben,
> aber stumm'-Fall wie die T7-Schema-Luecke."

**Die Praemisse ist am Objekt falsch: erhoben wird es nirgends.** Und der Test, der die Spalte
absichert (`test_a8s3_csv_klasse_c.cpp`), setzt den Wert **selbst** auf 4711 -- er beweist den
Transport, nicht die Erhebung; sein eigener Kopfkommentar (`:6`) wiederholt die falsche Praemisse.
Das ist dieselbe Familie wie KK-1, eine Ebene tiefer: **eine Zusage, die eine andere Frage
beantwortet als die gestellte.** Konsequenz fuer den Anhang: entweder B6 bauen (Abschnitt 4) oder
die Spalte ausdruecklich als honest-0 fuehren -- beides muss **vor** dem Lauf passieren.

---

## 4. DIE BAU-SCHRITTE, IN AUSFUEHRBARER REIHENFOLGE

Jeder Schritt nennt seinen **Biss** = den Test, der **ohne** den Fix rot ist. Ohne Biss kein
Schritt (Kadenz-Doktrin).

### B0 -- Vorbedingung: Kollisionslage am Director pruefen (kein Code)

`experiment_plan_director.hpp` ist eine bekannte Kollisionsflaeche. Ledger Z.4115 vermerkt fuer den
A2-Fix-Plan F1/F3/F4/F5 woertlich: er "startet SEQUENTIELL erst nach der w2-codex-fixes-Landung
(**Datei-Ueberlappung am director**)". Vor dem ersten Edit: offene Wellen auf diese Datei pruefen
und die Reihenfolge mit der Lead-Linie klaeren. **Aufwand: Minuten. Auslassen = Merge-Konflikt in
der teuersten Datei am Tag vor dem Trigger.**

### B1 -- Das Flag an **alle vier** Emissionsstellen

**Datei:** `libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:841, 877, 1194, 1342`
**Aenderung:** `-DCOMDARE_ENABLE_PMC=ON` in jede der vier `cmake -B build`-Emissionen, je mit
einem Kommentar, der D1 + Ledger-Beleg nennt. **Vorlage existiert:** super
`.gitlab-ci.yml:673-676` und `:764-767` tragen genau diesen Begruendungstext bereits ("I-PMC-1 (F9,
User 2026-07-16 'PFLICHT fuer Vollstaendigkeit aller perf-Messwerte') [...] Ohne das Flag schrieb
der offizielle Mess-Lauf pmc_available=0/honest-0 trotz fertiger Infra.") -- **denselben Wortlaut
verwenden**, damit die Begruendung eine Single-Source bleibt und nicht in zwei Fassungen driftet.

**Warum alle vier und nicht nur `:1342`:**
1. `:1194` und `:1342` teilen `Code/build` (2.1). Ein einseitiges Flag laesst den jeweils anderen
   Job dasselbe Verzeichnis **zurueck**konfigurieren -- der Neubau faellt dann bei **jedem**
   Job-Wechsel an statt einmalig (Abschnitt 5.1).
2. Alle vier bauen `comdare-messung-driver`, also den Traeger der PMC-Quelle.
3. Die Invariante (B2) ist nur dann eine Invariante, wenn sie keine Ausnahme kennt, die nicht
   begruendet ist.

**Biss:** B2.

### B2 -- Der Test, der die INVARIANTE pinnt (nicht die Zahl vier)

**Datei:** `tests/unit/thesis_tiere/test_experiment_plan_director.cpp` (2322 Zeilen).
**Vorhandenes Muster:** `count_occurrences`-Helfer `:398`; `TEST(CiYamlBuilder,
EmitsPerComboCebJobsWithTwoStages)` `:686` liest `yb.text()` und prueft Marker.

**Wurzel-Bezug, und deshalb diese Form:** die Pflicht ging verloren, weil sie an **zwei Job-Namen**
hing. Ein Test, der "4" hart verdrahtet, wiederholt denselben Fehler eine Ebene hoeher. Die
richtige Invariante ist eine **Paar-Bedingung**:

> Zu **jeder** emittierten `cmake -B build`-Zeile, deren Folgezeile
> `cmake --build build --target comdare-messung-driver` ist, gehoert `-DCOMDARE_ENABLE_PMC=ON`.

Das ist heute 4/4, faengt eine kuenftige **fuenfte** Emissionsstelle automatisch, **und** bleibt
richtig, falls je eine nicht-messende Konfiguration emittiert wird -- dieser Fall ist im Haus
bereits vorgesehen: super `.gitlab-ci.yml:333` haelt einen Auswertungs-Job ausdruecklich
flaglos ("Auswertungswerkzeuge ohne Messung und bleibt bewusst ohne COMDARE_ENABLE_PMC").

Skizze (ASCII-Kommentare, Selbstcheck-Zeile beim Bau ergaenzen):

```cpp
// P-PMC-1 / F9-Invariante: nicht die ANZAHL der Emissionsstellen pinnen (die Pflicht ging genau
// deshalb verloren, weil sie an zwei Job-NAMEN hing), sondern die Vollstaendigkeits-Bedingung:
// wer den Mess-Treiber baut, hat vorher mit PMC konfiguriert.
TEST(CiYamlBuilder, JedeTreiberKonfigurationTraegtDasPmcFlag) {
    auto const tp = parse_thesis(COMDARE_PLANNER_THESIS_ALL_AXES);
    ASSERT_TRUE(tp.has_value());
    planner::ExperimentPlanDirector const director;
    planner::CiYamlBuilder                yb;
    director.construct(*tp, yb);

    auto const lines = split_lines(yb.text());     // lokaler Helfer, Muster count_occurrences:398
    std::size_t geprueft = 0;
    for (std::size_t i = 0; i + 1 < lines.size(); ++i) {
        if (lines[i].find("cmake -B build") == std::string::npos) continue;
        if (lines[i + 1].find("--target comdare-messung-driver") == std::string::npos) continue;
        ++geprueft;
        EXPECT_NE(lines[i].find("-DCOMDARE_ENABLE_PMC=ON"), std::string::npos)
            << "Mess-Treiber-Bau ohne PMC-Flag (F9-PFLICHT 16.07.): " << lines[i];
    }
    EXPECT_GT(geprueft, 0u) << "Wache leer gelaufen: kein Treiber-Bau in der YAML gefunden";
}
```

Denselben Test gegen `parse_experiment(COMDARE_EXPERIMENT_GOLDEN)` wiederholen -- der
Experiment-Kanal hat eine eigene Schrittzahl (`:684`: 76 Schritte = 4 Perms x 19 Passes) und ist im
Haus schon einmal als "F1 fehlt im Experiment-Zwilling" aufgefallen (Ledger `mittag-11`).

Die `EXPECT_GT(geprueft, 0u)`-Zeile ist kein Ornament: sie faengt den Fall, dass ein kuenftiger
Umbau die Emission umbenennt und die Wache leer, aber gruen durchlaeuft -- Regel 6 in Testform.

**Biss-Nachweis:** denselben Test gegen den Stand **vor** B1 fahren. Erwartung: rot, mit vier
namentlich ausgewiesenen Verstoss-Zeilen im Thesis-Kanal.

### B3 -- Die Wache fail-closed drehen: "Quelle nicht gebaut" ist ein Fehler

**Dateien:** `tests/unit/thesis_tiere/linux_perf_pmc_smoke.cpp:58-63` und
`tests/unit/thesis_tiere/m3v2_pmc_smoke.cpp:71`.

**Was NICHT passieren darf:** den Inversions-Fix vom 13.07. zuruecknehmen. `m3v2_pmc_smoke.cpp:60-66`
begruendet ihn und er ist richtig -- ein **live**-PMC (`available=1`) darf nicht SMOKE_FAIL kippen,
denn genau das ist der Erfolgsfall. Falsch war, ihn zum **allgemeinen** Verdikt zu machen.

**Was stattdessen:** ein compile-time-Anker, der die Erwartung an den Bau bindet, in **beiden**
Smokes:

```cpp
// P-PMC-1: die Erwartung folgt dem BAU, nicht der Laufzeit. Ist die Quelle einkompiliert, ist
// "kein Zugriff" ein FEHLER (mehrtaegige Messung mit 0-Zaehlern); ist sie es nicht, bleibt der
// ehrliche Skip erhalten (test:unit baut ohne das Flag).
#if defined(COMDARE_ENABLE_PMC) && defined(__linux__)
constexpr bool kPmcExpected = true;
#else
constexpr bool kPmcExpected = false;
#endif
```

- `linux_perf_pmc_smoke.cpp`: der `SMOKE_SKIP`-Zweig bleibt fuer `!kPmcExpected`; bei
  `kPmcExpected && !delta.available` -> `SMOKE_FAIL` + `return 1`.
- `m3v2_pmc_smoke.cpp:71`: `pmc_seam_ok = delta.available || (!kPmcExpected && counters_all_zero)`.

**Wirkung an drei Stellen gleichzeitig** -- und das ist der Grund, warum dieser eine Schritt die
ganze Klasse schliesst:
1. der #37-Preflight (`director:1362-1364`) beisst endlich auf einer Lane mit blockiertem
   `perf_event_open`;
2. `pmc:amd` / `pmc:intel` (ce `.gitlab-ci.yml:113-133`) werden von einer **Bau**-Aussage zu einer
   **Zugriffs**-Aussage -- sie bauen bereits mit dem Flag;
3. `test:unit` bleibt unberuehrt: es baut ohne das Flag (`kPmcExpected == false`) und schliesst das
   Label `pmc` ohnehin per `-LE pmc` aus.

**Biss:** (a) Preflight-Bau **ohne** Flag -> `ctest -L pmc` muss ROT sein; (b) mit Flag auf einer
echten Lane gruen. Beides literal zeigen (Abschnitt 7).

**Ehrliche Warnung:** B3 macht den Messbeginn von der Rechtelage der Runner abhaengig. Der Ledger
belegt fuer prod2 einen root-Shell-Executor mit `perf_event_paranoid=1` und fuer prod1 einen
Live-Beweis vom 25.06. (`cache_misses_l1=4190096`) -- **das ist Ledger-Bericht, von mir heute
nicht nachgemessen.** Deshalb: B3 landen und die zwei pmc-Jobs **einmal gruen zeigen, bevor der
Trigger faellt**. Sie fahren in jeder ce-Pipeline und kosten laut Job-Kommentar (`.gitlab-ci.yml:117`)
im Normallauf < 3 min bei 15 min Timeout.

### B4 -- `allow_failure: true` am Mess-Batch (Bau trivial, haengt an O-PMC-1)

**Datei:** `experiment_plan_director.hpp:1333`. Die Zeile entfernen.
**Sichtbarkeit geht nicht verloren:** die Sichtbarkeits-Doktrin (V6.4) ist eine **Zell**-Doktrin --
"Algo-Fehler -> CSV-Zelle 'failed' + Log". Das bleibt unberuehrt. D4 und D5 sprechen ueber den
**Job**.
**Biss:** dieselbe YAML-Text-Wache wie B2 -- der emittierte Mess-Batch-Job traegt kein
`allow_failure: true`.
**Nicht ohne Owner-Entscheid landen** (O-PMC-1).

### B5 -- Doku-Drift und die falsche Spalten-Zusage

(a) `linux_perf_pmc_smoke.cpp:4` auf die tatsaechliche Registrierung korrigieren (nur
`if(UNIX AND NOT APPLE)`; `tests/unit/CMakeLists.txt:3553`).
(b) `CMakeLists.txt:67` -- Optionsbeschreibung um den Linux-Zweig erweitern; sie laedt heute dazu
ein, das Flag auf Linux fuer entbehrlich zu halten.
(c) `linux_perf_pmc_source.hpp:5` ("best-effort L2/coherence") an `:194-195` angleichen.
(d) **`cache_engine_builder_iterator.hpp:499` und `test_a8s3_csv_klasse_c.cpp:6`:** entweder B6
bauen oder die Zusage "PmcCounters ERHEBT branch_misses real" zuruecknehmen. Ein Kommentar, der
eine strukturell leere Spalte fuer real erklaert, ist die Phantom-Klasse.
**Biss:** (a)-(c) sind reine Kommentare -- kein Biss moeglich, dafuer im Diff sichtbar. (d) haengt
an O-PMC-3.

### B6 -- `branch_misses` verdrahten (klein; Fenster schliesst mit dem Trigger)

**Datei:** `libs/cache_engine/builder/linux_perf_pmc_source.hpp` (Muster `:202-207`).
`PERF_COUNT_HW_BRANCH_MISSES` ist ein generisches `PERF_TYPE_HARDWARE`-Ereignis derselben billigen,
portablen Klasse wie die drei bereits geoeffneten -- **kein RAW-Event, kein Zen-5-Sonderweg**,
also ausdruecklich nicht der gegatete I-PMC-3-Fall. Ein vierter Counter, dasselbe open/read/close-
Muster, dieselbe Multiplexing-Skalierung.
**Biss:** `linux_perf_pmc_smoke` um `branch_misses` in die `any_counter`-Bedingung aufnehmen und
auf einer Lane mit Zugriff `branch_misses != 0` literal zeigen.
**Haengt an O-PMC-3.** Nach dem Trigger ist die Spalte fuer diesen Datensatz endgueltig 0.

### 4.1 Landereihenfolge und Kopplung

| Welle | Inhalt | Kopplung |
|---|---|---|
| **W-1** | B1 + B2 + B5(a)(b)(c) | B1 ohne B2 ist eine Setzung ohne Wache. **`:1194` und `:1342` muessen GEMEINSAM landen** (2.1/5.1). |
| **W-2** | B3 | Direkt nach W-1, eigene Welle (zwei Testdateien, eigener Biss). **B3 vor B1 waere falsch herum:** die Wache blockierte dann den Lauf, bevor der Fix ihn ermoeglicht. |
| **W-3** | B4 | Nur nach O-PMC-1. |
| **W-4** | B6 + B5(d) | Nur nach O-PMC-3. |
| **W-5** | **super-Submodul-Bump** | **Ohne ihn ist die gesamte Landung wirkungslos** -- das super konsumiert den ce ueber den Gitlink. ANKLAGE i-1 sagt das woertlich: "Nach der Landung: super-Submodul-Bump noetig, sonst wirkungslos." |

---

## 5. NEBENWIRKUNGEN

### 5.1 Das Neubau-Fenster

`add_compile_definitions(COMDARE_ENABLE_PMC)` sitzt in `CMakeLists.txt:77` als
Directory-Scope-Property **vor** den `add_subdirectory`-Aufrufen der cache-engine. Jedes Target in
diesem Teilbaum bekommt damit eine zusaetzliche Compilerflagge, und Ninja stuft es als dirty ein --
**unabhaengig davon, ob die Uebersetzungseinheit das Makro ueberhaupt referenziert.** Das ist am
Objekt (Zeile 77 samt Kommentar "GLOBAL definieren [...] alle Targets") belegt; die Folge ist
strukturell zu erwarten.

**Groessenordnung -- BERICHT, nicht von mir nachgefahren:** die Voranalyse hat in `/tmp` (ausserhalb
jedes Repos, kein geteiltes Build-Verzeichnis beruehrt) `Code/CMakeLists.txt` mit der emittierten
Zeile konfiguriert und `messung_driver` gebaut: **76,7 s ohne Flag, 77,0 s nach Reconfigure mit
Flag, 13 CXX-Compiles, davon 12 erneut uebersetzt, 32 Kerne.** Ich habe diesen Lauf **nicht**
wiederholt -- **UNBELEGT durch eigene Messung**, als Bericht gefuehrt.

**Was daraus folgt, unabhaengig von der genauen Zahl:** der Neubau trifft den schlanken Host-Treiber,
**nicht** die Matrix. Und er faellt **einmal** an, **wenn `:1194` und `:1342` gemeinsam landen**;
landet nur eine der beiden, reconfiguriert der jeweils andere Job dasselbe geteilte `Code/build`
zurueck und der Neubau wiederholt sich bei **jedem** Job-Wechsel auf demselben Runner -- ueber einen
7-Tage-Batch die eigentliche Kostenfalle.

### 5.2 ccache

Die emittierten Kind-Pipelines tragen ccache: `emit_child_ccache_config` (`director:620-633`) setzt
`key: "ccache-$CI_PROJECT_NAME"` + `paths: [".ccache"]`, der Shell-Export `:667-668` setzt
`CCACHE_DIR="${CI_PROJECT_DIR}/.ccache"`. Ein zusaetzliches `-D` geht in den ccache-Hash der
betroffenen Uebersetzungseinheiten ein -> **der erste Bau nach der Landung ist fuer diese TUs ein
kalter Miss, danach warm.** Einmalig je Cache-Key, nicht je Job. **Die genaue Miss-Zahl ist
UNBELEGT** (nicht gemessen); die Richtung folgt aus der ccache-Semantik.

### 5.3 golden-Neutralitaet -- drei unabhaengige Pruefungen, alle von mir gefahren

1. **Tier-Binaries:** `/usr/bin/grep -c COMDARE_ENABLE_PMC
   libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp` = **0**. Die Tier-`.so`
   entstehen nicht ueber CMake-Targets, sondern ueber einen eigenen `g++`-Subprozess des Treibers
   (`:875` "POSIX-CompileFn: realer g++-Subprozess, baut perm_<id>.cpp -> perm_<id>.so (SHARED)").
   **Das Flag erreicht diesen Pfad nicht -- die 131.072 Tier-Binaries bleiben byte-gleich.**
2. **golden-Fixtures:** `/usr/bin/grep -rl pmc_available Code/test_data_xml` = **0 Dateien**. Im
   ce-Testbaum tragen genau **3** Dateien den String (`m3v2_pmc_smoke.cpp`,
   `test_v5_measurement_snapshot.cpp`, `test_harness_compile.cpp`) -- alle drei konstruieren ihre
   Quelle explizit (`NullPmcSource` bzw. Mock), keine geht ueber die Factory. **Kein
   golden-Vergleich haengt am Flag.**
3. **Stempel / Fingerprint / binary_id:** repo-weit tragen (ohne `build`-Baeume) **11 Dateien** den
   String `COMDARE_ENABLE_PMC`: 5 unter `libs/` (`pmc_source_factory`, `linux_perf_pmc_source`,
   `windows_pcm_pmc_source`, `perm_runner`, `cache_engine_builder_iterator`), 3 unter `tests/`, dazu
   `apps/f15_compare/main.cpp`, `.gitlab-ci.yml`, `CMakeLists.txt`. **Keine Stempel-, Fingerprint-
   oder Versions-Datei ist darunter.** Vorbehalt: ich habe ueber die Dateiliste geprueft, nicht jeden
   Stempel-Emitter gelesen -- fuer eine Aussage "kein Stempel aendert sich" ist das hinreichend
   (der String kaeme sonst dort vor), fuer "kein Stempel-Emitter liest die Werte indirekt" nicht.

**Was sich sehr wohl aendert:** die **gemessenen Werte** springen von strukturell 0 auf real. Das
ist Datum, nicht golden -- und es ist der ganze Zweck des Pakets. Alte CSV-Bestaende bleiben
lesbar (die Spalten existieren bereits, sie waren nur 0).

### 5.4 Was B3 zusaetzlich scharf schaltet

Mit B1 baut der Mess-Batch die beiden Preflight-Targets erstmals **mit** echter Quelle. B3 macht
daraus einen Blocker. Beides zusammen heisst: **eine Lane ohne perf-Zugriff startet den Messlauf
nicht mehr.** Das ist genau D4 ("eine Lane darf den gesamten Strang erst abarbeiten, wenn IHR
pmc-Job erfolgreich ist") -- und es ist ein neues Ausfallrisiko am Tag des Triggers. Die Gegenprobe
ist billig (Abschnitt 7, Punkt 6) und muss vorher laufen.

---

## 6. DIE OWNER-ENTSCHEIDE -- GETRENNT VOM BAU

Diese drei entscheidet **nicht** die Bau-Linie. Je Entscheid: Lage, beide Wege mit Folge, Empfehlung.

### O-PMC-1 -- `allow_failure: true` am Mess-Batch (`director:1333`)

**Lage.** D5 (#278, Owner-PFLICHT) verlangt "0 allow_failure im GESAMTEN Matrix-System, einzige
Ausnahme by design: `is_original:relock`, manual Utility"; die CI-Direktive vom 17.07. verschaerft
das. D4 sagt fuer die PMC-Strecke ausdruecklich "BEIDE hart (kein Gate/allow_failure)". Der Code
begruendet die Zeile mit der Sichtbarkeits-Doktrin (`:1332`) -- die ist aber eine **Zell**-Doktrin
(CSV `failed` + Log), keine **Job**-Doktrin. **Gegenprobe im Ledger:** `/usr/bin/grep -n
allow_failure` ueber den Ledger = **20 Treffer**; keiner betrifft den emittierten Mess-Batch, keiner
autorisiert diese Zeile. Die einzige Stelle, die sie ueberhaupt erwaehnt, ist die Kritik daran
(ANKLAGE V-C). Die naechstliegende Gegenregel ist CI-6 (Z.351: neue Test-Stage zuerst advisory,
Hard-Gate nach erstem gruenem Beweis) -- sie passt nicht: der Mess-Batch ist keine neue Test-Stage,
und #278 verlangt fuer jedes verbleibende `allow_failure` eine **eingebuchte Fix-Strecke**, die es
hier nicht gibt.

**Weg A -- entfernen (B4).** Folge: ein PMC-, Bau- oder Storage-Ausfall faerbt die Pipeline rot.
Die Zell-Sichtbarkeit (CSV `failed` + Log + `[FEHLER-TESTAT]`) bleibt unberuehrt.
**Weg B -- belassen.** Folge: ein mehrtaegiger Lauf kann komplett scheitern, und die Ampel bleibt
gruen. Das ist woertlich der von KK-1 benannte Zustand: "ein mehrtaegiger Messlauf kann ohne PMC
laufen, sein Preflight meldet `pmc=ok`, und selbst wenn er abbricht, bleibt alles gruen."

**EMPFEHLUNG: Weg A**, gebuendelt mit W-1/W-2. Sie ist eine Zeile und jederzeit reversibel; der
verlorene Messlauf ist es nicht.

### O-PMC-2 -- Haertegrad: wird "Quelle nicht gebaut" ein Fehler? (= B3)

**Lage.** Heute ist die gruene PMC-Ampel eine Aussage ueber den **Compile**, nicht ueber den
**Hardware-Zugriff** (2.4). Dass es auf dem Comdare-Cluster heute trotzdem funktioniert, ist eine
Aussage ueber die Infra-Konfiguration (root-Shell-Executor prod2, `perf_event_paranoid=1`,
prod1-Live-Beweis 25.06.) -- **nicht** eine Eigenschaft der CI. §66-N2-Praezisierung sieht
ausdruecklich Fremd-Cluster mit anderer Lane-Menge vor; dort traegt die Konfiguration nicht.

**Weg A -- fail-closed (B3).** Folge: kuenftige Infra-Aenderungen (strengeres
`perf_event_paranoid`, Nicht-root-Executor, verschifftes Fremd-Cluster) fallen sofort rot auf,
statt still auf honest-0 zu degradieren. Preis: der Trigger kann am Stichtag blockieren, wenn eine
Lane keinen Zugriff hat -- das ist gewollt (D4), aber es ist ein reales Risiko und braucht den
Vorab-Beweis aus Abschnitt 7 Punkt 6.
**Weg B -- belassen.** Folge: die Wache bleibt, was sie ist -- ein Testat ueber ihre eigene
Abwesenheit.

**EMPFEHLUNG: Weg A.** Sie kostet zwei Testdateien und schliesst den Preflight **und** die beiden
harten ce-Jobs in einem Schritt. Und sie ist die einzige der drei Entscheidungen, die den in der
ANKLAGE als i-2 gefuehrten Punkt vollstaendig erledigt, ohne den 13.07.-Inversionsfix anzutasten.

### O-PMC-3 -- Anhangs-Umfang, und die eine Spalte, die JETZT oder NIE geht

**Lage:** Abschnitt 3. Drei Teilfragen:

**(a) Wird der Anhang mit 3 harten + 1 best-effort Spalte gefahren?** (`cache_misses_l1`,
`cache_misses_l3` als Last-Level, `dtlb_misses`; `energy_micro_joules` best-effort.)
**EMPFEHLUNG: ja** -- und `cache_misses_l2` / `coherence_invalidations` ausdruecklich als honest-0
mit Verweis auf I-PMC-2/I-PMC-3(#187) ausweisen, nicht stillschweigend als "gemessen" fuehren. Das
ist genau, was D3 verlangt: nicht weg-nullen **und** nicht als gemessen ausgeben. I-PMC-3
(L2 + coherence via Zen-5-RAW) ist bis Fr 08.08. nicht serioes machbar.

**(b) `branch_misses`: jetzt verdrahten (B6) oder als honest-0 fuehren?**
**EMPFEHLUNG: verdrahten.** Begruendung: derselbe billige generische Counter-Typ wie die drei
laufenden, kein RAW-Event; die Spalte steht bereits im CSV-Header **mit der ausgeschriebenen
Zusage, sie werde real erhoben** (3.1). Entweder die Zusage einloesen oder sie zuruecknehmen --
und beides geht nur **vor** dem Lauf. Bei Weg "honest-0" ist B5(d) **Pflicht**, nicht Kosmetik:
sonst behauptet der Quelltext im Anhangspfad etwas, das die Daten widerlegen.

**(c) Energie (RAPL).** Der Pfad ist `/sys/class/powercap/intel-rapl:0/energy_uj`, root-abhaengig
(`linux_perf_pmc_source.hpp:153-154`: "Seit Linux 5.10 oft 0400 (root-only)"). **Ob diese Zone auf
der AMD-Lane existiert und lesbar ist, ist von mir NICHT belegt -- UNBELEGT.**
**EMPFEHLUNG:** vor dem Trigger einmal auf beiden Lanes probieren (ein `cat`-Einzeiler im
pmc-Job-Trace, kostet Sekunden) und die Spalte danach **entweder** als real **oder** als honest-0
fuehren. Eine best-effort-Spalte ohne Probe ist im Anhang nicht vertretbar.

---

## 7. ABNAHME-KADENZ -- WAS LITERAL ZU ZEIGEN IST

Keine Erfolgsmarke ohne literale Werkzeugausgabe. In dieser Reihenfolge:

1. **Ausgangsstand:** `git -C <ce> rev-parse HEAD` (Voll-SHA) + `git -C <ce> status --porcelain`
   sowie der Diff-Umfang je Welle (Dateien, +/-).
2. **Biss VORHER (B2):** der neue Test gegen den Stand **ohne** B1 -- rote gtest-Ausgabe **mit den
   vier namentlich ausgewiesenen Verstoss-Zeilen**. Ein Biss, den niemand rot gesehen hat, ist kein
   Biss.
3. **Biss VORHER (B3):** Konfiguration **ohne** Flag in einem Wegwerf-Verzeichnis, dann
   `ctest --test-dir <dir> -L pmc --output-on-failure` -- **muss ROT sein**.
4. **Biss NACHHER:** `ctest --test-dir build -R test_experiment_plan_director --output-on-failure`
   -- literal `100% tests passed`.
5. **Voll-Suite, ZWEI serielle Laeufe:** literal `... tests passed, 0 tests failed out of N` (die
   Zahl `N` mitfuehren; `nachmittag-9` nennt fuer diesen Stand 407/407).
6. **Zugriffs-Beweis auf einer echten Lane** (nicht lokal, nicht in einer VM): aus dem Job-Trace von
   `pmc:amd` **und** `pmc:intel` je literal `pmc_available=1` und ein `cache_misses_l1=<Zahl>`,
   dazu die Job-IDs. **Das ist der Punkt, der ueber den Trigger entscheidet.**
7. **Die emittierte YAML im Volltext:** die vier `cmake -B build`-Zeilen mit Flag, aus der
   Builder-Ausgabe, nicht aus dem Quelltext zitiert.
8. **Hygiene:** `clang-format` (exakt die CI-Version) dry-run == 0 ueber **ganze Dateien**, nicht
   nur ueber Diff-Zeilen (Regel 7 / die beiden `lint:format`-Vorfaelle vom 06.08.);
   Mojibake-`grep` == 0; ASCII-Selbstcheck-Zeile.
9. **gitleaks** mit der Repo-`.gitleaks.toml` **und** ueber den Push-Inhalt (`<remote>..HEAD`),
   nicht nur ueber den Baum.
10. **Nach der Landung:** super-Submodul-Bump, `verify:submodules` gruen, und **eine** Pipeline je
    Repo mit Job-Bilanz aus der API (`/jobs` **und** `/bridges` -- `/jobs` zeigt keine Bridges).
11. **Buchfuehrung (Regel-Zeile 10):** Ledger-Nachtrag **und** Eintrag in die
    VOR-TRIGGER-CHECKLISTE. Ein Paketschnitt, der nur in einem Plan- oder Session-Dokument steht,
    existiert fuer die Ausfuehrung nicht -- genau daran ist der F9/LB-Paketschnitt gescheitert
    (`nachmittag-10` F).

---

## 8. EHRLICH ZUR FRIST: WAS VOR DEM GO, WAS DANACH

Rahmen: **Abgabe Fr 08.08., Trigger Do 07.08., Phase 6 = ausdruecklicher Owner-GO-Stopp**
(`docs/sessions/20260806-FAHRPLAN-hauptstrang-landung.md:514`; `docs/plaene/20260806-FAHRPLAN-parallel-sequenz-optimiert.md:9,15`).

### VOR dem GO -- zwingend

| Posten | Warum es nicht warten kann |
|---|---|
| **B1 + B2** (W-1) | Ohne sie misst die 131.072-Zellen-Matrix ohne Hardware-Zaehler. Fuer **diesen** Datensatz ist das unwiederbringlich. |
| **B3** (W-2) | Ohne sie meldet die Wache weiterhin `pmc=ok`; ein Ausfall faellt erst nach Tagen auf -- also nach der Abgabe. |
| **O-PMC-1** entscheiden (+ ggf. B4) | Betrifft, ob ein Abbruch ueberhaupt sichtbar wird. |
| **O-PMC-3** entscheiden (+ ggf. B6) | Bestimmt, **welche Spalten es geben wird**. Nach dem Start ist eine 0-Spalte endgueltig 0. |
| **W-5 super-Submodul-Bump + gruene Pipeline** | Ohne ihn ist die gesamte Landung wirkungslos. |
| **Zugriffs-Beweis auf beiden Lanes** (Kadenz 6) + **RAPL-Probe** (O-PMC-3c) | Kostet Minuten, entscheidet ueber die Ehrlichkeit von zwei Spalten und ueber das Risiko, das B3 einfuehrt. |

**Gemeinsame Begruendung, in einem Satz:** jeder dieser Posten bestimmt, **was** gemessen wird --
und das Messfenster ist einmalig.

### NACH dem GO vertretbar

- **B5(a)(b)(c)** -- reine Kommentar- und Beschreibungskorrekturen, keine Verhaltensaenderung.
  **Ausnahme: B5(d)** gehoert vor den Anhang, weil es eine Zusage ueber **Daten** ist.
- **I-PMC-2-Restfeinheiten** (L3-Mapping-Detail) und **I-PMC-3/#187** (L2 + coherence via
  Zen-5-RAW). Bis Fr 08.08. nicht serioes; im Anhang als honest-0 mit Verweis ausweisen.
- Die in der ANKLAGE als i-2-Variante genannte Verfeinerung "Preflight prueft die **Ausgabe**
  `pmc_available=1` statt den Exit-Code" -- **B3 loest dasselbe billiger und an der richtigen
  Stelle** (im Verdikt, nicht im Shell-Rahmen). Falls B3 wider Erwarten nicht traegt, ist sie der
  Rueckfallweg.
- `present_`-Gate, Formwachen-Verfeinerung und die uebrigen Nach-Abgabe-Posten aus
  `nachmittag-10` H.

### Was dieses Paket ausdruecklich NICHT enthaelt

KK-2 / i-5 (`COMDARE_BESTANDSLOG` als Opt-in) und i-6 sind eine **andere** Klammer mit eigenem
Owner-Entscheid und eigener Kollisionslage (T2-A/L1, gleiche Datei-Region). Die ANKLAGE-Arbeitsliste
ordnet sie ausdruecklich **nach** i-1..i-4 ein, "weil ein scharfes Skip-Gate ohne PMC-Fix nur
schneller falsch misst". P-PMC-1 ist die Vorbedingung, nicht der Ersatz.

---

## 9. WAS ICH NICHT BELEGEN KANN (ausdruecklich ausgewiesen)

1. **Die Neubau-Zahlen (76,7 s / 77,0 s / 13 Compiles / 12 erneut)** sind ein Bericht der
   Voranalyse aus einem `/tmp`-Bau. Ich habe ihn nicht wiederholt. Die **Richtung** (Vollneubau des
   Treiber-Compile-Graphen) folgt aus `CMakeLists.txt:77` und ist belegt; die **Groesse** ist es nicht.
2. **Die ccache-Miss-Zahl** nach dem Flag-Wechsel ist nicht gemessen.
3. **Die Runner-Rechtelage heute** (perf-Zugriff auf prod1/prod2, RAPL-Lesbarkeit, ob die
   `intel-rapl:0`-Zone auf der AMD-Lane existiert) stammt aus Ledger-Eintraegen vom 08.07. bzw.
   25.06. -- nicht heute nachgemessen. Kadenz-Punkt 6 und O-PMC-3(c) schliessen genau diese Luecke.
4. **"Last-Level == L3" auf prod1/prod2** ist eine Hardware-Aussage, die ich nicht am Objekt
   erhoben habe. Pruefbar mit einem `lscpu`-Einzeiler im pmc-Job.
5. **Stempel-Neutralitaet** ist ueber die Dateiliste geprueft (kein Stempel-Emitter enthaelt den
   String), nicht durch Lesen jedes Emitters.
6. **Das Ledger-Schweigen zu `allow_failure` am Mess-Batch** ist ein Schweigen: 20 Treffer, keiner
   einschlaegig. Ein Schweigen ist kein Beweis der Abwesenheit einer Owner-Aussage -- deshalb ist
   O-PMC-1 ein **Entscheid** und keine Bau-Anweisung.

---

*Selbstcheck: ASCII-only ausserhalb der Zitate; alle Datei:Zeile-Angaben am Stand `e7aa1244`
nachgelesen; jede Zahl mit Bezugsgroesse; Bericht und eigene Messung getrennt ausgewiesen;
kein Edit, kein Commit, kein Push vollzogen.*
