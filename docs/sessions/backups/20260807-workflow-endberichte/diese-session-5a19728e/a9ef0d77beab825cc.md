# a9ef0d77beab825cc (tx=637KB tools=55)

## Ergebnis der PMC-Pruefung (READ-ONLY, ce `e7aa1244` / super Arbeitsbaum, keine Edits)

---

## 1. WAS DIE PLANUNG SAGT — PMC ist Kernsubstanz, nicht Beiwerk

**Die staerkste Stelle, woertlich (Owner, 16.07., Entscheidungsrunde F1-F12, Ledger Z. 533):**

> **F9 ENTSPERRT:** „Die Infra hat die Einrichtung schon seit Tagen fertig. NICHT mehr gegated, kann von MIR [Agent] installiert werden und **MUSS als PFLICHT fuer die Vollstaendigkeit aller perf-Messwerte mit in die Ergebnisse**"

**Die Umsetzung dazu (Ledger Z. 532, I-PMC-1):**

> „**I-PMC-1 (F9, User-PFLICHT):** `-DCOMDARE_ENABLE_PMC=ON` in GENAU die 2 Mess-Jobs (`measure:smoke` Z.449 + `measure:golden-320` Z.529; der analyse-Job bleibt bewusst ohne — Erklaer-Kommentar) … Damit schreibt der naechste echte Mess-Lauf `pmc_available=1` + reale `cache_misses_l1` (prod1-Beweis 25.06.: 4.190.096)."

**Weitere Plan-Belege (alle Ledger, super `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`):**
- §0 DoD-4, Z. 37: „**FF3-Mess-Kette echt:** … → M3-Gesamtlauf (#156) **mit realen Cache-Misses/PMC** → Thesis-Anhang mit belastbaren Werten."
- §6, Z. 340: „#156 M3-Gesamtlauf — Gate-Grund KORRIGIERT: **NICHT** ‚HELD bis Linux+PMC' (**PMC ist auf prod1 vorhanden**)". Die Verfuegbarkeit ist also ausdruecklich **keine** Entschuldigung mehr.
- §66-NACHTRAG-2 (Owner 23.07., **KERN=Gesetz**), Z. 3499-3503: „Je Maschine ihr EIGENER PMC-Pflicht-Beweis … BEIDE hart (kein Gate/allow_failure) — **‚eine Lane darf den gesamten Strang erst abarbeiten, wenn IHR pmc-Job erfolgreich ist'**."
- §66-N2-Vermerk Stand 03.08., Z. 3506: der **per-Lane-PMC-Preflight in den EMITTIERTEN Mess-Batch-Jobs** wurde als Task #37 gebaut, G4a „damit ERFUELLT".
- Offene Tasks: #152 „Cache-Misses explizit", #34 honest-100%-Audit, I-PMC-2/-3 (Z. 341, 1470, 2917).

**Die einzige Gegen-Stelle ist ueberholt:** Z. 67-68 („Reale Cache-Misses/PMC bleiben **honest-0 bis #26**") ist der Stand **12.07.** — vier Tage vor F9. **Juengste Fassung gilt: PMC ist Pflicht-Bestandteil der Ergebnisse.** Damit ist die Schwere hoch: ein Voll-Lauf ohne Hardware-Zaehler erfuellt DoD-4 nicht.

---

## 2. DER BEFUND, TEIL FUER TEIL

| Teil | Verdikt | Beleg |
|---|---|---|
| 4 Emissionsstellen :841/:877/:1194/:1342 ohne `-DCOMDARE_ENABLE_PMC` | **BESTAETIGT** | `/usr/bin/grep -n "cmake -B"` auf der Datei: 5 Treffer, davon 1 Kommentar (:219) und **4 echte Emissionen** — alle exakt `cmake -B build -G Ninja -DCOMDARE_V32_ENABLE=ON …` |
| `grep -c COMDARE_ENABLE_PMC` = 0 | **BESTAETIGT** | literal `0` bei 2092 Zeilen Datei. Repo-weit nennen 19 Dateien das Makro — der Director ist keine davon. |
| `CMakeLists.txt:67` Default OFF | **BESTAETIGT** | `option(COMDARE_ENABLE_PMC "Intel PCM Windows cache-miss source (WindowsPcmPmcSource, BSD-3)" OFF)` |
| Beschreibung nennt nur Windows, gated aber Linux | **BESTAETIGT** | `CMakeLists.txt:69-77`: `if(COMDARE_ENABLE_PMC)` → `if(UNIX AND NOT APPLE)` → `add_compile_definitions(COMDARE_ENABLE_PMC)`; `pmc_source_factory.hpp:21` inkludiert `linux_perf_pmc_source.hpp` nur unter `#if defined(COMDARE_ENABLE_PMC) && defined(__linux__)`; sonst `NullPmcSource`. |
| `m3v2_pmc_smoke.cpp:71` — Nullzaehler = bestanden | **BESTAETIGT, aber die Einordnung KORRIGIERT** | Zeile literal: `bool const pmc_seam_ok = delta.available \|\| counters_all_zero;`. **Aber:** der Kommentar :64-70 zeigt, dass genau diese Fassung ein bewusster Fix ist (M-CE-25/Muster-F, 13.07.): vorher war `honest_null` hart gefordert, was ein **live** PMC rot kippte. Der Test ist die **Naht-Wache** (Spalten existieren, Null ist ehrlich), er war nie als „PMC ist an"-Wache gedacht. Fail-closed machen: ja — aber als **bewusster Zweck-Wechsel**, nicht als Fehlerbehebung. |
| `:1333 allow_failure: true` auf dem Voll-Mess-Batch | **BESTAETIGT** | `:1333` literal `s += "  allow_failure: true\n";`, direkt ueber dem `script:` des Mess-Batch. Kommentar :1332 begruendet es mit der Sichtbarkeits-Doktrin (`CSV 'failed'` statt still). **Kollidiert mit #278** (Ledger Z. 1140, Owner-PFLICHT: „in einer harten Pipeline darf es kein allow_failure geben"). |
| Es ist der reale 131072-Pfad | **BESTAETIGT** | `super .gitlab-ci.yml:79` `COMDARE_GN_TOTAL: "131072"` → `planer:delegate-trigger` forward-Allowlist (:1207-1208) → Grandchild; Director `:1206-1208` `TOTAL="${COMDARE_GN_TOTAL:-16}"`, `:1367` `export COMDARE_GOLDEN_N_RANGE="0:${COMDARE_GN_TOTAL:-16}"`. `planer:delegate` traegt die Regel `- if: '$COMDARE_BUILD_GOLDEN_N == "true"'  # NEUER STANDARD-Pfad (loest die statische Matrix ab)` (:1170). |
| `measure:smoke` DEPRECATED | **BESTAETIGT** (Zeilendrift) | Der DEPRECATED-Block steht `:664-668`, nicht 665-669; Inhalt: „dieser STATISCHE Smoke-Job ist durch die dynamische Kette (planer:delegate -> ceb -> tier) abgeloest". |
| `measure:golden-320` traegt das Flag, ist aber der kleine Job | **BESTAETIGT** | `:768` traegt `-DCOMDARE_ENABLE_PMC=ON`. Er ist auf **eine** Lane festgenagelt (`tags: [prod, baremetal, amd]`) — kann die Vendor-PMC-Doktrin (amd **und** intel) also gar nicht erfuellen, und §33 des Ledgers hat golden-320 als Systembeweis bereits verworfen. |
| `pmc:amd`/`pmc:intel` = Faehigkeit, nicht Einschaltung | **BESTAETIGT** | `ce .gitlab-ci.yml:119` (Template `.pmc`): `cmake -B build -G Ninja -DCOMDARE_BUILD_TESTS=ON -DCOMDARE_ENABLE_PMC=ON`; `:132` `ce_ctest pmc build`. Eigener Build-Baum, kein Messlauf. Kein `allow_failure` — die Jobs sind hart, aber sie beweisen nur den Bau. |

**Nichts an dem Befund ist uebertrieben. Eine Sache ist zu entlasten:** `libs/cache_engine/src/permutations/permutation_build_command.hpp` emittiert ebenfalls `cmake -B … -DCOMDARE_AXIS_…`, hat aber **null Aufrufer** in `libs/`+`apps/` (nur Tests) — keine lebende Emissionsstelle. Und `super:334` (`analyse`) ist **absichtlich** ohne Flag, mit Erklaer-Kommentar :332-333 — ebenfalls entlastet.

---

## 3. DREI BEFUNDE, DIE NIEMAND GENANNT HAT — davon einer schwerer als der gemeldete

### (A) Der #37-PMC-PREFLIGHT IST GEBAUT — UND WIRD VON DERSELBEN LUECKE UNSCHAEDLICH GEMACHT

Der Mess-Batch emittiert bei `experiment_plan_director.hpp:1361-1364` genau den Preflight, den der Plan (§66-N2/G4a/#37) verlangt:

```
1362:  cmake --build build --target m3v2_pmc_smoke linux_perf_pmc_smoke
1363:  ctest --test-dir build -L pmc --output-on-failure
```

Der Kommentar daneben (:1352-1359) nennt woertlich den Zweck: *„ohne Preflight koennte eine Lane eine mehrtaegige Messung mit kaputtem `perf_event_open` durchlaufen und **lauter 0-Zaehler produzieren**"*. Ein eigener Test haelt ihn hart (`test_experiment_plan_director.cpp:1481-1538`, u. a. „der Preflight darf nicht weich gemacht werden (§66-N2: beide hart)").

**Er beisst trotzdem nicht.** `ctest -L pmc` faehrt exakt 2 der 407 Tests. Beide bestehen ohne das Flag:

- `m3v2_pmc_smoke`: `delta.available=false` + alle Zaehler 0 → `counters_all_zero` → `pmc_seam_ok` → `SMOKE_OK`.
- `linux_perf_pmc_smoke`: **literal auf dieser Maschine nachgemessen** (g++-15, identische Defines wie `tests/unit/CMakeLists.txt:3566`, Quelle unveraendert):

```
OHNE -DCOMDARE_ENABLE_PMC:            MIT -DCOMDARE_ENABLE_PMC:
pmc_source.name = null-pmc (P4/HW-gated)   pmc_source.name = linux-perf-pmc
delta.available = 0                        delta.available = 1
delta.cache_misses_l1 = 0                  delta.cache_misses_l1 = 4191307
delta.dtlb_misses = 0                      delta.dtlb_misses     = 1767452
SMOKE_SKIP (no PMC access - honest available=0)   SMOKE_OK (live PMC, >=1 counter populated)
EXIT=0                                     EXIT=0
```

**Das ist die eigentliche Verschaerfung:** die Wache, die genau diesen Schaden verhindern sollte, wird von derselben fehlenden Zeile blind gemacht — sie prueft „ist perf kaputt?", waehrend die Quelle gar nicht erst existiert, und die Nicht-Existenz gilt als „ehrlicher Skip, Exit 0". Der `[PMC-TESTAT] … pmc=ok`-Marker wird dabei **gedruckt**. Es sind also **vier** Wachen, die nicht ausloesen, nicht drei — und die vierte ist die dafuer gebaute.

**Nebenbefund:** der Kommentarkopf von `tests/unit/thesis_tiere/linux_perf_pmc_smoke.cpp:4` behauptet „Linux-conditional registriert (`if(UNIX AND NOT APPLE)` **+ COMDARE_ENABLE_PMC**)". Der Ist-Stand `tests/unit/CMakeLists.txt:3553` hat **nur** `if(UNIX AND NOT APPLE)`. Die Doku im Code ist gedriftet — und genau diese Drift ist der Grund, warum das Target ohne Flag ueberhaupt existiert und gruen laeuft.

### (B) DIE WURZEL IST DIE JOB-NAMEN-BINDUNG VON I-PMC-1, NICHT DIE OPTION-BESCHREIBUNG

Der Ledger sagt es selbst: das Flag ging „in **GENAU die 2 Mess-Jobs**" — `measure:smoke` und `measure:golden-320`. Zu diesem Zeitpunkt (16.07.) **waren** das der Mess-Pfad. Als die dynamische Kette die statische Matrix abloeste, blieb das Flag auf den abgeloesten Jobs zurueck. Die Pflicht war an **zwei Job-Namen** geheftet statt an eine **Invariante** („jeder Job, der misst, traegt PMC"). Das ist dieselbe Fehlerklasse wie R4 (Test-Abdeckung an einer Namensliste statt an der Klasse) und wie Regel-Zeile (6). Die irrefuehrende Option-Beschreibung ist ein **Verstaerker**, nicht die Wurzel — sie erklaert, warum niemand beim Lesen stutzig wurde.

**Zahlen mit Bezug:** super `.gitlab-ci.yml` hat 7 `cmake -B build…`-Stellen; **2** tragen das Flag (:677 deprecated, :768 einlanig), **5** nicht (davon :334 begruendet ohne, :365/:415 sind DA-Test-Baeume, :1071 Hilfsbau, :1176 `planer:delegate` baut nur den Planer). Im ce-Director: **0 von 4**.

### (C) DIE BEIDEN BATCHES TEILEN `Code/build` — EIN EINSEITIGES FLAG ERZWINGT VOLL-NEUBAU

`emit_gn_out_persistence_variables` (:1091-1099) setzt in **beiden** Batches `GIT_CLEAN_FLAGS: "-ffdx -e Code/gn_out -e Code/build -e Code/measure_out"`, und beide haengen an derselben `resource_group: ceb-measure-<host>`. `Code/build` ueberlebt also den Checkout-Clean und wird zwischen Bau- und Mess-Batch **wiederverwendet**. `COMDARE_ENABLE_PMC` ist ein `add_compile_definitions` mit globaler Reichweite: wuerde man es nur bei `:1342` setzen, kippte die CMake-Cache-Variable bei jedem Job-Wechsel hin und her → vollstaendiger Re-Compile des cmake-Baums in jedem Batch, auf einem 7-Tage-Job. **Das Flag muss an :1194 UND :1342 gleichzeitig.**

Entwarnung dazu: die **Tier-DLLs** werden nicht per CMake gebaut, sondern per `make_gpp_compile_fn` direkt (Director-Kommentar :209: „Die TIER-DLL-Compile-Flags (`make_gpp_compile_fn`) bleiben UNANGETASTET"). `COMDARE_ENABLE_PMC` geht in **keine** `binary_id` und in **keinen** Stempel ein — es waehlt nur die host-seitige Messquelle. **Golden-neutral.**

---

## 4. WAS DER LAUF OHNE DAS FLAG TATSAECHLICH MISST

**Keine Spalte faellt weg — die Werte sind ehrliche Nullen mit gesetztem Ehrlichkeits-Flag.**

Kette: `perm_runner.hpp:34/206/214/314/317` → `make_pmc_source()` (`pmc_source_factory.hpp:29`) → ohne Flag `NullPmcSource` → `r.pmc = PmcCounters{}` → `cache_engine_builder_iterator.hpp:2586` (`[]{ return make_pmc_source(); }` im WIDE-Mess-Pfad) → `lazy_csv_header()` :481-482 emittiert unveraendert `pmc_cache_misses_l1;…;pmc_available` → `measurements.csv` → super `persist:measurements` → `measurement/<ts>/`.

Der Rueckschrieb enthaelt also 7 Spalten mit `0;0;0;0;0;0;0` und `pmc_available=0`. **Fuer den Thesis-Anhang heisst das: die Cache-Miss-Auswertung existiert als leere Spalte** — nicht als Luecke, die beim Lesen auffaellt.

**Gegenprobe am einzigen echten Rueckschrieb** (`measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv`, 170 Spalten, 16 Zeilen):

```
pmc_available:        1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
pmc_cache_misses_l1:  756895968 44168554 752740382 ... 557797094 43630643
pmc_dtlb_misses:      2225379 70 5405 150 ... 38471 109
pmc_cache_misses_l2/l3/coherence/energy: durchgehend 0
```

Dieser Lauf hatte PMC **an** — aber er ist laut Commit `057ee3e5` **„Manager-gefahren nach GN-11-bare-metal-Rezept"**, also von Hand, nicht ueber die emittierte Kette. Er belegt: die Faehigkeit traegt auf prod1. Er belegt **nicht**, dass die CI-Kette sie einschaltet. (Und `MANUAL_RUN.md` nennt `COMDARE_ENABLE_PMC` an **keiner** seiner 7 cmake-Zeilen — der dokumentierte Handweg traegt es ebenfalls nicht.)

**Zusatz-Befund fuer den Anhang:** selbst mit `available=1` bleiben `pmc_cache_misses_l3` (LL), `l2`, `coherence` und `energy` 0. `linux_perf_pmc_source.hpp:194-196` erklaert l2/coherence als bewusst nicht geoeffnet; **l3/LL wird geoeffnet (:204-205), liefert auf beiden gemessenen Maschinen aber 0** — das ist I-PMC-2 (Ledger Z. 2917, „L3-Mapping+branch_misses", offen). Wer „Cache-Misses" im Anhang zeigen will, hat auch mit Flag **nur L1D + dTLB**.

---

## 5. DIE BAU-ANWEISUNG (ohne Rueckfrage ausfuehrbar)

**Paket P-PMC-1 — 5 Eingriffe, golden-neutral, binary_id-neutral.**

**(1) Die Ursache: Option-Beschreibung ehrlich machen** — `ce/CMakeLists.txt:67`
```
option(COMDARE_ENABLE_PMC "Reale HW-Performance-Counter: Linux perf_event_open (LinuxPerfPmcSource) UND Windows Intel PCM (WindowsPcmPmcSource, BSD-3). OFF => NullPmcSource, alle pmc_*-Spalten ehrlich 0." OFF)
```
Default bleibt OFF (Fremd-Verschiffbarkeit, Container ohne perf). Der Kommentarkopf :60 ist mitzuziehen („V5-#26 / Task #153 — Intel-PCM Windows-…" nennt Linux nicht).

**(2) Das Flag in die Emission** — `experiment_plan_director.hpp:1194` **und** `:1342`, beide Batches, identisches Literal (sie teilen `Code/build`, s. Befund C):
```cpp
s += "    - cmake -B build -G Ninja -DCOMDARE_V32_ENABLE=ON -DCOMDARE_ENABLE_PMC=ON -DCMAKE_BUILD_TYPE=" + ...
```
`:841`/`:877` (ceb:build / ceb:emit) bauen nur den Treiber zur YAML-Emission und messen nicht — dort ist das Flag **nicht** noetig; wer „eine Wahrheit" will, setzt es mit, Kosten sind ein Treiber-Neubau.

**(3) Der Test, der es belegt** — `tests/unit/thesis_tiere/test_experiment_plan_director.cpp`, neuer Fall neben `G4aStorageActivationPmcPreflightAndPruneAreEmittedInCorrectOrder` (:1481):
```cpp
// jede emittierte Mess-/Bau-Batch-Konfiguration traegt PMC
EXPECT_EQ(count_occurrences(yaml, "-DCOMDARE_ENABLE_PMC=ON"), build_batches + measure_batches);
EXPECT_EQ(yaml.find("-DCOMDARE_V32_ENABLE=ON -DCMAKE_BUILD_TYPE"), std::string::npos)
    << "keine Mess-Emission ohne PMC-Flag";
```
Heute gibt es **keinen** Test, der eine der 4 Configure-Zeilen prueft: `git grep -n "COMDARE_V32_ENABLE" -- tests/` = **0 Treffer**. Der Biss ist damit echt: Flag aus einer der beiden Stellen entfernen → der `EXPECT_EQ` faellt auf `n-1` → rot.

**(4) `pmc_seam_ok` fail-closed** — `tests/unit/thesis_tiere/m3v2_pmc_smoke.cpp:71`. Der heutige Ausdruck ist ein bewusster Fix (Kommentar :64-70) und darf nicht blind invertiert werden; die fail-closed-Fassung muss den live-Fall weiter bestehen lassen und zusaetzlich einen **Build-Erwartungswert** fuehren:
```cpp
#if defined(COMDARE_ENABLE_PMC) && defined(__linux__)
    constexpr bool kPmcExpected = true;   // Build sagt: reale Quelle ist einkompiliert
#else
    constexpr bool kPmcExpected = false;
#endif
    // fail-closed: mit einkompilierter Quelle ist available=0 ein FEHLER, nicht ein Skip
    bool const pmc_seam_ok = kPmcExpected ? delta.available
                                          : (delta.available || counters_all_zero);
```
Analog `linux_perf_pmc_smoke.cpp:63-68`: der `SMOKE_SKIP`-Zweig muss unter `kPmcExpected` zu `SMOKE_FAIL` + `return 1` werden (der Skip bleibt richtig fuer Container/paranoid-Builds **ohne** Flag). Damit wird der Preflight :1363 zur echten Wache — mit Flag am Configure ist ein toter `perf_event_open` auf einer Lane sofort rot.
**Biss:** `cmake -B x -DCOMDARE_ENABLE_PMC=ON` in einem Container ohne perf-Rechte → `SMOKE_FAIL`, Exit 1 (heute: `SMOKE_SKIP`, Exit 0).
**Achtung:** `ce .gitlab-ci.yml:119` baut `.pmc` **mit** dem Flag — die Jobs `pmc:amd`/`pmc:intel` werden nach diesem Umbau **hart** von realem Counter-Zugriff abhaengig. Das ist genau die §66-N2-Doktrin, aber es macht die beiden Jobs infrastruktur-empfindlich (`perf_event_paranoid`).

**(5) Doku-Drift schliessen** — `tests/unit/thesis_tiere/linux_perf_pmc_smoke.cpp:4` behauptet eine `COMDARE_ENABLE_PMC`-Registrierungsbedingung, die `tests/unit/CMakeLists.txt:3553` nicht hat. Entweder Kommentar korrigieren **oder** (sauberer, konsistent mit (4)) das Target weiterhin unbedingt registrieren und den Kommentar an den Ist anpassen — **nicht** die Registrierung gaten, sonst verschwindet der Preflight-Beleg wieder aus dem OFF-Build.

**Verifikations-Kadenz** (nach Owner-Doktrin, je literal): `comdare_experiment_planner plan ci …` → `grep -c "COMDARE_ENABLE_PMC=ON"` im emittierten YAML == Zahl der Batches · Configure-Beweis `COMDARE_ENABLE_PMC: Linux — LinuxPerfPmcSource (perf_event_open, keine Vendor-Lib)` · `ctest -L pmc` 2/2 gruen mit `available=1` · Mutations-Gegenprobe je (3) und (4).

---

## 6. WAS EINEN OWNER-ENTSCHEID BRAUCHT (nicht Bau)

1. **`allow_failure: true` auf dem Voll-Mess-Batch (`:1333`).** Zwei Owner-Doktrinen stehen gegeneinander: „Mess-Fehler → CSV `failed` + Log, Pipeline bleibt gruen" (Sichtbarkeits-Doktrin) gegen **#278 PFLICHT** „in einer harten Pipeline darf es kein `allow_failure` geben". Solange es steht, ist auch ein rot gewordener PMC-Preflight fuer die Pipeline unsichtbar. **Vorschlag zur Entscheidung:** Preflight-Abbruch und Mess-Fehler trennen — Preflight in einen eigenen, harten Job/Stufe vor dem Batch, Messfehler bleiben weich.
2. **Fenster fuer den Neubau.** Punkt (2) aendert die Configure-Kommandozeile → ccache-Key-Wechsel → einmaliger Voll-Recompile des cmake-Baums auf beiden Lanes. Vor der 131072er-Matrix billig, mittendrin teuer. **Wann?**
3. **Haerte-Grad von `pmc:amd`/`pmc:intel` nach (4).** Fail-closed macht die zwei Jobs von `perf_event_paranoid` auf prod1/prod2 abhaengig. §66-N2 sagt „deklarierte-aber-tote Maschine blockiert ehrlich" — das ist dann woertlich so. Bestaetigen?
4. **L3/LL bleibt 0 (I-PMC-2).** Auch mit Flag liefert der Lauf nur L1D + dTLB. Der Anhang kann „Cache-Misses" also nur auf L1D-Ebene zeigen. **Vor der Abgabe:** L3 nachziehen, oder im Anhang explizit als L1D/dTLB deklarieren?
5. **Nachfuehrung der Alt-Jobs.** `measure:smoke` ist DEPRECATED, `measure:golden-320` ist einlanig und laut §33 kein Systembeweis — beide tragen das Flag noch. Mitziehen als Historie, oder im Abschluss-Aufraeumpass (§75) entfernen?

**Gesamtverdikt:** Der Sperrposten traegt und ist um eine Stufe schwerer als gemeldet — die eigens gebaute #37-Wache faellt in dieselbe Luecke. Es ist kein Bau-Fehler an einer Stelle, sondern eine **Pflicht, die an Job-Namen statt an eine Invariante geheftet war** und beim Pfad-Wechsel zurueckblieb. Der Fix ist klein, golden-neutral und in einem Paket machbar; die drei echten Entscheidungen liegen bei `allow_failure`, dem Neubau-Fenster und der L3-Ehrlichkeit.
