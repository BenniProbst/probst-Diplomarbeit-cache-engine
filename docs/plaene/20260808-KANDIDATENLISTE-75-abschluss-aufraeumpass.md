# §75 — ZENTRALE KANDIDATENLISTE DES ABSCHLUSS-AUFRÄUMPASSES (Stand 08.08.2026)

> **Diese Datei ist ab sofort die EINE Kandidatenliste für §75.** Alle bisherigen Fundorte bleiben
> stehen (Doku-nie-löschen-Doktrin) und tragen einen Zeiger hierher. Wer den Aufräumpass fährt, liest
> **diese** Datei — nicht mehr eine der Teilquellen.
>
> **§75 ist GEGATET.** Owner-Bedingung (Ledger `:3599`, 27.07.): *„nach der Bearbeitung aller
> bekannten Aufgaben"*. Diese Liste ist ein **Vorrats-Register**, kein Ausführungs-Auftrag. Nichts
> hier darf ohne den Gate-Vollzug angefasst werden.
>
> **Doktrin je Fund (Ledger `:3599`):** eigenes Paket · ultracode VOR+NACH · Aufrufer-Grep=0 als
> Beleg · Tests nachziehen · granulare Commits. **CODE fällt, DOKU nicht.**

---

## 0. Warum es diese Datei gibt — und was sich beim Zusammenführen herausgestellt hat

Die §75-RECONCILIATION vom 08.08. (Ledger `:11577`, super `c0aaa3bf`) hat festgestellt, dass die
Kandidaten an *„mindestens vier Orten"* verstreut liegen und eine zentrale Liste fehlt. Beim
Zusammenführen sind daraus **vierzehn Quellen** geworden. Drei Befunde, die vorher niemand beisammen
hatte:

**BEFUND A — die Kette (1)–(92) ist über VIER Dokumente zerrissen, und der Ledger hat die Lücke nie
geschlossen.** Der Ledger führt Posten `(19)`–`(24)` und `(30)`–`(92)`. Die Posten **`(1)`–`(18)`
stehen ausschließlich** in `docs/sessions/20260802-KATALOG-offene-strecke-gesamtplan.md:98`, die
Posten **`(25)`–`(29)` ausschließlich** in `docs/sessions/20260803-FAHRPLAN-gesamtkette-wellen-phasen.md:68`.
Wer nur den Ledger liest, sieht 74 von 92 Posten — und wundert sich über die Nummernlücke am Anfang.
Das Register vom 06.08. (`20260806-REGISTER-todo-konsolidierung-14-tage.md:416`) hatte genau das
schon diagnostiziert, ohne dass es je in die Single-Source zurückgeschrieben wurde.

**BEFUND B — es laufen DREI kollidierende Nummernkreise nebeneinander.**

| Kreis | Reichweite | Wo geführt | Kollisionsgefahr |
|---|---|---|---|
| **(N)** Ledger-Kette | (1)–(92) | Ledger + 2 Session-Docs | die eigentliche Kette |
| **33–38** G8-Liste | 33–38 | ce `20260804-e24_g8_negativliste…md` §6 | **identische Zahlen, identische Inhalte** wie Ledger `(33)`–`(38)` — dieselben Posten, doppelt geführt |
| **AP-01…AP-13** | 13 Posten | super `20260806-PLAN-f3-f5-r4-aufraeumpass.md` | eigene Nummern **mit** Alt-Nummer-Zuordnung; sauber gebaut |
| **„Kandidat Nr. 1–10"** | 10 Posten | super `20260806-REGISTER-…md:379/393/445` | dritte Zählung derselben Menge |

Zusätzlich existiert ein **Namensdoppel bei „Posten 62"**: Ledger `:3911` führt `(62)` = KF-6
Cacheline-NTTP-Codegen; Ledger `:6503` nennt in einem anderen Zusammenhang ebenfalls einen
„Posten 62" (ungeschützter stiller Fallback in `axis_04_…:99`). Das sind **zwei verschiedene Dinge**.

**BEFUND C — die Zeilen-Anker der Kette sind großflächig gewandert.** Stichprobe an fünf Ankern:
`director:281` → Text steht heute bei `:392`; `director:868-871` → zeigt heute auf einen
unverwandten Block; `director:1107/:1255` → beide unverwandt; `PRUNE-TESTAT :1325` → heute `:1511`;
`iterator:1790-1791` → heute `:2809-2819`. **Konsequenz für den Aufräumpass: kein Zeilen-Anker
dieser Liste darf ungeprüft benutzt werden — immer über den Bezeichner suchen, nie über die Zeile.**
(Das ist dieselbe Regel, die `abi_adapter.hpp:37-38` bereits selbst notiert: *„Zeilen-Anker sind
approximativ".*)

### Erhebungsstand und Werkzeug

- **Basis:** super `origin/development` = `ea30605a`, ce `origin/development` = `4487a9c1`.
- **Werkzeug:** ausschließlich `/usr/bin/grep` (GNU grep 3.11). `grep` ohne Pfad ist auf prod1 eine
  Shell-Funktion auf `ugrep` und liefert bei Umlauten **stille Nulltreffer**.
- **Bau-Ordner-Ausschluss:** immer `/build/` mit **beiden** Schrägstrichen — `/build` allein frisst
  `/builder/`, und `/builder/` ist tragender Quellcode.
- **Prüftiefe:** jeder Posten mit einem benennbaren Objekt (Datei/Symbol) wurde am Objekt geprüft.
  Posten ohne Objekt (Design-Entscheide, Prosa-Zusagen) sind als solche markiert — sie werden
  **nicht** stillschweigend gestrichen.

### Quellen-Schlüssel

| Kürzel | Quelle |
|---|---|
| Q1 | super Ledger `:3601` — Kandidaten-Startliste (27.07., Owner-KERN) |
| Q2 | super Ledger `:3602` — **NICHT-Kandidaten / Schutzklausel** (HY-D2, 02.08.) |
| Q3 | super Ledger `:3710`ff. — NACHTRAG 03.08., Posten (19)–(22) |
| Q4 | super Ledger Einzelvermerke `:3640` `:3659` `:3675` `:3688` `:3721` `:3722` `:6503` `:6926` `:8159` `:8961` |
| Q5 | super Ledger Kettenfortschreibungen `:3735` `:3781` `:3790` `:3798` `:3825` `:3861` `:3868` `:3904` `:3911` `:3918` `:3926` `:3938` `:3946` `:3959` `:3961` `:3969` `:3989` `:3999` `:4044` `:4091` `:4154` `:4179` |
| Q6 | super `docs/sessions/20260802-KATALOG-offene-strecke-gesamtplan.md:98` — **Posten (1)–(18)** |
| Q7 | super `docs/sessions/20260803-FAHRPLAN-gesamtkette-wellen-phasen.md:68` — **Posten (25)–(29)** |
| Q8 | ce `docs/architecture/20260804-e24_g8_negativliste_gesperrte_abi_flaechen.md` Abschnitt 6 — 33–38 |
| Q9 | ce Kopf-Kommentare einzelner Header/Skripte (Selbst-Deklaration) |
| Q10 | super Code-Kommentare (`Code/02_messung_driver/main.cpp`, `Code/CMakeLists.txt`) |
| Q11 | super `docs/sessions/20260806-REGISTER-todo-konsolidierung-14-tage.md:379/:393/:445` |
| Q12 | super `docs/plaene/20260806-PLAN-f3-f5-r4-aufraeumpass.md` — AP-01…AP-13 |
| Q13 | ce `docs/architecture/` (Hybrid-Soll-Design, A8-F2, A8-S4, A9-xlsx-F3) |
| Q14 | super `docs/plaene/20260808-GESAMTBILD-vergessene-arbeit-und-neuer-wellenplan.md` |

---

## 1. GESPERRT — die NICHT-Kandidaten (Schutzklausel Q2, Ledger `:3602`, HY-D2 02.08.)

**Diese drei Flächen dürfen im Aufräumpass weder entfernt noch umbenannt werden.** Die
Hybrid-Tier-Stufe (Bau in der Auswertungsphase) setzt unmittelbar auf ihnen auf. Sie stehen hier
**ausdrücklich mit**, damit sie beim nächsten Durchgang nicht weggeräumt werden.

| Nr. | Gesperrte Fläche | Fundort | Ist-Zustand am Objekt | Grund der Sperre |
|---|---|---|---|---|
| **S-1** | Heuristik-Trio: `axis_spline.hpp`, `break_even.hpp`, `measurement_curve_loader.hpp` | ce `libs/cache_engine/heuristik/` | alle drei vorhanden | speisen den Break-Even-Router HY-B2 |
| **S-2** | Vertrag `IPruefDock::measure` samt Konformitäts-Gate-Klausel | ce `builder/pruef_dock/pruef_dock.hpp:78` | vorhanden | die Hybrid-Binary hängt als normales Tier-Modul daran |
| **S-3** | Loader-Fläche `AnatomyModuleHandle` + `AnatomyModuleLoader::load/load_all/platform_suffix` **inkl. destroy-vor-dlclose-Ordnung** | ce `builder/anatomy_module_loader/anatomy_module_loader.hpp:76/:152/:156/:159`, Ordnung `:70-75` | vorhanden | Hybrid-Stufe **und** offener Schichten-Entscheid **K2** (stufen-neutrale Lib vs. bewusstes Linken der Builder-Loader-Lib) — **entscheid-gebunden, nicht aufräum-frei** |

Zwei weitere Flächen tragen ein eigenes, unabhängiges Lösch-Verbot in ihrem Kopf-Kommentar und
gehören ebenfalls **nicht** in den Pass:

| Nr. | Fläche | Fundort | Selbst-Auflage |
|---|---|---|---|
| **S-4** | `copy_results_to_nas.sh` | ce `scripts/copy_results_to_nas.sh:2-12` | *„DEPRECATED … **NICHT LOESCHEN**, nur als Referenz erhalten"* |
| **S-5** | `goal-v6-luecken-ledger.md` | ce `docs/ledger-sections/goal-v6-luecken-ledger.md:1-5` | *„SUPERSEDED … **Niemals löschen** — nur Banner/Nachträge"* (Doku-Doktrin, ohnehin außerhalb §75) |

---

## 2. Die Startliste Q1 (Ledger `:3601`) — Ist-Stand am 08.08. nachgeprüft

Die Reconciliation vom 08.08. hat diese sieben Posten bereits am Objekt geprüft. Ich habe die Prüfung
gegen `ce 4487a9c1` / `super ea30605a` **wiederholt**; alle Ergebnisse bestätigt.

| Posten | Ist-Zustand | Beleg (Befehl → Ergebnis) | Status |
|---|---|---|---|
| `cmake/permutations.cmake` | existiert in **keinem** der beiden Repos | `git -C <ce> ls-files \| /usr/bin/grep -c permutations.cmake` → **0**; dito super → **0** | **BEREITS ENTFERNT** in ce `813c3232` (27.07.) |
| `COMDARE_apply_simd_flags` | nur noch als Kommentar-Spur | `/usr/bin/grep -rn COMDARE_apply_simd_flags` → 2 Treffer, beide Prosa (`cmake/isa_features.cmake:111` nennt selbst *„hatte 0 Aufrufer"*) | **BEREITS ENTFERNT** in `813c3232` |
| V36.B-Kanal-Dateien | Werkzeug-Trio weg; Alt-Kanal-Spuren in Kommentaren | `profile_run_facade.hpp:247`, `experiment_plan_director.hpp:410` nennen `generated/permutations_manifest.txt` weiter | **TEIL-ENTFERNT** in `813c3232`; Kommentar-Reste offen |
| `permutations_runtime_check.hpp` | **unverändert da und aktiv inkludiert** | Datei vorhanden; `main.cpp:43` `#include "permutations_runtime_check.hpp"`; `CMakeLists.txt:152` erklärt den Verbleib | **OFFEN** |
| `_IDS`-Alias | **unverändert da**, 3× definiert, selbst als DEPRECATED beschriftet | `ce tests/unit/CMakeLists.txt:3330, :3358, :3386` | **OFFEN** |
| `COMDARE_LEGACY_MESSREIHEN` | **unverändert da**, zwei data-gated Zweige | `super main.cpp:701, :718` (+ `:986`, `:1370-1372`) | **OFFEN**, gated auf V-5c (golden-320-Subsumtions-Bestätigung) |
| „historisierte Auflagen-Hinweise" | **kein Objekt** — nie auf Datei/Zeile heruntergebrochen | — | **UNBELEGT** (s. Abschnitt 6) |

**Dazu, nicht in Q1, aber derselbe Vorgang:** die CLI-Alt-Flags `--emit-tier-ci` / `--emit-tier-cmake`
verweisen an drei Stellen **selbst auf §75** (`super main.cpp:359, :432, :537-538`) und sind
funktional unverändert — siehe Posten **(4)**.

---

## 3. Die durchnummerierte Kette (1)–(92)

**Nummern werden NIE neu vergeben** (Auflage Ledger `:3868`: *„nie neu nummerieren"*). Lücken in der
Nummernfolge bleiben stehen.

Legende Status: **OFFEN** · **ERLEDIGT** (am Objekt belegt, mit Commit) · **UNBELEGT** (Gegenstand
nicht auffindbar/nicht heruntergebrochen) · **NACH ABGABE** (bewusst ausgelagert) · **DESIGN**
(Entscheid, kein mechanisch prüfbares Objekt).

### 3.1 Posten (1)–(18) — Herkunft Q6 (nur im KATALOG-Session-Doc, **nicht** im Ledger)

| Nr. | Kandidat | Fundort am Ist | Ist-Zustand / Beleg | Status |
|---|---|---|---|---|
| (1) | `LazyRunResult::built_new`/`built_skip` ohne Leser | ce `cache_engine_builder_iterator.hpp:986` u.a. | `/usr/bin/grep -rn built_skip` → **20 Treffer**, darunter reale Leser; Ledger `:3659` erklärt den Posten selbst für entschärft (E-04-P1-Fallback-Bilanz konsumiert beide) | **ERLEDIGT** (entschärft, Ledger `:3659`) |
| (2) | Stale „17-Achsen-ids" im Director | Anker `:281` **gewandert** → heute `experiment_plan_director.hpp:392` | Text steht dort weiter (*„Die ~520 Zeichen langen 17-Achsen-ids…"*); die lebende Quelle führt **18** Faktoren (`source_catalog.hpp:144`, B14-NB `d8073913`) | **OFFEN** |
| (3) | „17-Organ-Kartesik"-Kommentare | ce `all_axes_golden.profile.xml:183` + `cacheline_study.profile.xml:142` | beide Zeilen-Anker **stimmen exakt**; Text unverändert | **OFFEN** |
| (4) | `--emit-tier-ci`-Alias (bewusst bis Emissions-Migration, §77-P8) | super `main.cpp:373-374` (`kDeprecatedAliases`), `:518/:520`, `:536-538`; ce-Emission `profile_run_facade.cpp:1116/:1129` | Alias-Tabelle aktiv, Laufzeit-Warnung aktiv; ce emittiert auf Subkommando-Form; Guard-Test `test_experiment_plan_director.cpp:484-488` bricht bewusst, sobald §75 die Aliase entfernt | **OFFEN** (bewusst) |
| (5) | `test_a9b` unregistriert | Anker `CMakeLists:3510` **gewandert** | `/usr/bin/grep -c test_a9b tests/unit/CMakeLists.txt` → **1**, und das ist ein Kommentar (`:4314`), **keine** Registrierung. Datei vorhanden | **OFFEN** (Teil der 7 Waisen-TUs, s. `(22b)`) |
| (6) | Marker-Doktrin W-2/W-3: write-only `_gn_chunk_markers`, toter YAML-Verweis `async_push_pump.hpp:63-64` | ce `artifact_transport/artifact_cache.hpp:206/:489/:508/:510/:593/:609` | `_gn_chunk_markers` **16 Treffer**, alle in `artifact_cache.hpp`; Anker `async_push_pump.hpp:63-64` **gewandert** (dort steht heute `close()`) | **OFFEN**, Anker nachzuziehen |
| (7a) | `comdare_is_original_macro.hpp` — *„ECHT-TOT"* (Selbstaussage `:3`) | ce `libs/cache_engine/src/sha256/comdare_is_original_macro.hpp` | `/usr/bin/grep -rn "#include.*comdare_is_original_macro" --include=*.hpp --include=*.cpp` → **0 Konsumenten** | **OFFEN — sauberster Erst-Kandidat** |
| (7b) | DEPRECATED-Block in `plan_legend.hpp` | ce `profile_facade/planner/plan_legend.hpp:124`ff. | Datei **aktiv** (3 `#include`-Konsumenten); der DEPRECATED-Block betrifft nur die per-chunk-Jobnamen | **OFFEN (Teilentfernung)** — Datei bleibt |
| (7c) | DEPRECATED `ExperimentSubtreePayload` | ce `planner/experiment_dock_payload.hpp:58`ff. | Datei **aktiv** (`test_experiment_dock_payload.cpp:10` inkludiert); Band-C-DEFERRED (Task #19) | **OFFEN (Teilentfernung)** — Datei bleibt |
| (8) | F8-Alt-Form | ce `builder/bestandslog/planer_block_value.hpp:20-26` | Anker **passt noch**: dort steht der Block *„EXPLIZITE id (E2) … Director-Pfad: owner_uuid + „/" + seq (die **gepinnte Alt-Form**, unveraendert)"* | **OFFEN** |
| (9) | `COMDARE_VARIANT_GATE` + 3 Sidecars (durch Fingerprint-Gate obsolet) | ce `experiment_plan_director.hpp:1012`, `profile_run_entry.hpp:467/:493`, Tests `:741/:849/:861` | **10 Treffer**; drei Stellen (`toolchain_stamp_naht.hpp:406`, `build_variant_sidecar.hpp:16/:29`, `anatomy_fingerprint.hpp:333`) erklären die Var **selbst für funktional obsolet** | **OFFEN** — identisch mit **AP-11** (Q12) und mit dem Restposten Ledger `:8961` |
| (10) | Zeilen-Referenz-Drift | Anker `director.hpp:868-871` + `batch_planner.hpp:14/:35` | **Anker gewandert** (`:868-871` zeigt heute auf einen `private:`-Block); `batch_planner.hpp` liegt heute unter `builder/bestandslog/` | **OFFEN**, Fundstellen neu zu erheben |
| (11) | Copy-Paste Lane-Budget | Anker `director:1107/:1255` | **beide Anker gewandert** (zeigen auf `perms_.push_back` bzw. eine Build-Type-Konkatenation) | **OFFEN**, Fundstellen neu zu erheben |
| (12) | `COMDARE_GN_RANGE` ohne Konsument | ce `experiment_plan_director.hpp:821/:828/:1087`, Test `:1349` | **4 Treffer**; alle drei Produzenten-Stellen emittieren den Namen in YAML, kein lesender Konsument im ce-Baum | **OFFEN** |
| (13) | PRUNE-TESTAT-Drift | Anker `:1325` **gewandert** → heute `experiment_plan_director.hpp:1511` | Text vorhanden | **OFFEN** |
| (14) | Doku-Drift | ce `bestandslog/fingerprint_key_source.hpp:37-40` | Anker **passt**: dort steht ausdrücklich *„[ALT-WORTLAUT, HISTORIK bis #13 …] NACHGEFUEHRT 2026-08-05"* | **ERLEDIGT** (nachgeführt 05.08.), Historik-Text bleibt bewusst |
| (15) | `declared`-Attribut-Abbau | ce `include/cache_engine/measurement/system_axis_registry.xml:19-25` | Attribut **aktiv in Gebrauch** (`declared="false"/"true"` + `declaration_source`) | **OFFEN** (Design-Frage, kein toter Code) |
| (16) | P-C4/G-C6 Doku-Paket | — | `/usr/bin/grep -rn "P-C4\|G-C6"` über ce → **0 Treffer** | **UNBELEGT** (s. Abschnitt 6) |
| (17) | `COMDARE_LEGACY_MESSREIHEN` (nach V-5c) | super `main.cpp:701/:718/:986/:1370-1372` | **207 Treffer** repo-weit, zwei aktive data-gated Zweige | **OFFEN**, gated auf V-5c |
| (18) | Alt-ISA-Doppelbestand | ce `axes/simd/axis_09_isa_*` **und** `topics/hardware/axis_09_isa/` | **beide Bäume existieren**: `axes/simd/` 9 Header + `concepts/`, `topics/hardware/axis_09_isa/` **9 getrackte Dateien**; DEPRECATED-Marker fehlt weiterhin an beiden | **OFFEN** — Teilmenge der großen Doppelwurzel-Frage `(43)` |

### 3.2 Posten (19)–(24) — Herkunft Q3/Q5 (Ledger)

| Nr. | Kandidat | Fundort am Ist | Ist-Zustand / Beleg | Status |
|---|---|---|---|---|
| (19) | Stales Haupt-Build-Verzeichnis `ce build/` mit 17-Achsen-Codegen | Arbeitskopie `…/Code/external/comdare-cache-engine/build/` | `build/generated/generated_source_catalog.hpp` **mtime 26.07. 12:50** — unverändert stale. **Getrackte Dateien: auf `development` jetzt 0** (`git ls-files build/` → 0); im Haupt-Checkout hängt noch `build/thesis_tiere/tier150_measurements.csv` | **TEIL-ERLEDIGT** (CSV ins Archiv, ce `eb96b76a`); **stales Verzeichnis auf Platte weiter offen**. ⚠️ **HARTE VORSICHT vor jedem `rm`:** Memory-Anker `reference_ce_build_dir_has_tracked_measurement_csv`; Messdaten nie löschen |
| (20) | Stamp-Write ohne `flush()`/`good()`-Check | Anker `:1790-1791` **gewandert** → heute `cache_engine_builder_iterator.hpp:2809-2819` | **Wache ist gebaut**: `sf.flush(); sf.close(); oc.mess_front_faehig = sf.good();` mit begründendem Kommentar | **ERLEDIGT** in ce `3a88eb88` (T2-A/F4-NB2, Befund 2) |
| (21) | Mess-Pfad-Testlücke `stamp_bleibt` | Anker `:1812` **gewandert** → heute `:2840-2842` (Mess-Pfad) neben `:2447-2449` (Bau-Pfad) | Zweig vorhanden; ein gezielter Negativtest für den **Mess**-Zweig ist nicht auffindbar | **OFFEN** (Folgeschuld FS1; verwandt: Rest-Risiko Fundstelle B, ex-`:1802-1805`) |
| (22) | Bestands-ASCII-Sweep (GA-08) | ce-weit | `git ls-files '*.hpp' '*.cpp' '*.txt' '*.cmake' \| while read f; do LC_ALL=C /usr/bin/grep -qP '[^\x00-\x7F]' "$f" && echo "$f"; done \| wc -l` → **1160** (Ledger nannte 1132 → **gewachsen**) | **OFFEN**, Umfang nach oben korrigiert |
| (22b) | *(unnummeriert, Ledger `:3722`, GA-09)* 7 Waisen-TUs | ce `tests/unit/` | alle 7 Dateien vorhanden, **je 0 Registrierungen**: `br4_emit`, `br4_load`, `kf16_e2e_real_build`, `test_a9b_active_deklaration_inert`, `test_c3b_kanal_merge_beleg`, `test_d4b_container_dll`, `test_rf2_admission_marker_inert`. `tests/unit/CMakeLists.txt:2530` benennt sie selbst als Aufräumpass-Kandidaten | **OFFEN**; F-WAISEN-Entscheid (registrieren vs. entfernen, je TU) ist **Owner-Vorlage** |
| (23) | „(void)-ohne-try" an der Takeover-Aufrufstelle | Anker `iterator:1162` **gewandert** → heute `:1960-1967` (*„…ohne try/catch. `takeover_expired_reservations` wirft nach heutigem Stand nicht…"*) | Zusage „wird nachgezogen" weiterhin offen | **OFFEN** |
| (24) | `FreeRamFn`/`system_ram`-Fundstelle (TP1-Zweit-Truth-Check) | ce `build_orchestrator.hpp:193`, `profile_run_entry.hpp:546`, `experiment_run_entry.hpp:206` | Symbol **aktiv in Gebrauch** (injizierbarer Vertrag) | **OFFEN** (Befund-Natur im Ledger nicht ausformuliert — s. Abschnitt 6) |

### 3.3 Posten (25)–(29) — Herkunft Q7 (nur im FAHRPLAN-Session-Doc, **nicht** im Ledger)

| Nr. | Kandidat | Ist-Zustand / Beleg | Status |
|---|---|---|---|
| (25) | Achsen-Zahl-Banner in Nachschlagewerken („17" statt 18) | belegt u.a. in ce `docs/architecture/20260803-a8_f2_benchmarking_schnitt_soll_design.md:43/:162/:169`, `20260803-e24_container_gattungs_abi_dossier.md:47/:101`; im Code `node_value_measurement.hpp:72`, `iterator:28/:375` | **OFFEN** — deckungsgleich mit A8-S6 (17 stale Kommentarstellen, **AP-05**) |
| (26) | Alt-CRC `0xF1C1F26A1232073B` in ce-Kommentaren | `/usr/bin/grep -rn 0xF1C1F26A` → **6 Treffer**: `merge_plan.hpp:15`, `source_catalog.hpp:183/:187`, `sota_catalog.hpp:183`, `adhoc_emitter.hpp:104`, `anatomy_fingerprint.hpp:16`. Ledger nannte 6 → **Zahl stimmt** | **OFFEN** |
| (27) | `axis_hierarchy_summary.cmake` topics-GLOB | Datei vorhanden; GLOB aktiv (`:24` `file(GLOB _topic_dirs …)`) | **OFFEN** |
| (28) | „drei Modi"-Doku ×7, nach COMPARE | `/usr/bin/grep -rn "drei Modi"` über ce → **1 Treffer**, und der ist ein Session-Doc von Mai (`20260531-…:235`), also nicht die gemeinte Menge | **UNBELEGT** — die 7 Stellen sind mit diesem Muster nicht reproduzierbar (s. Abschnitt 6) |
| (29) | FS4/TOCTOU-Ecke | Anker `iterator:1610-1611` **gewandert**; `/usr/bin/grep -n TOCTOU` über den Iterator → **0 Treffer** | **UNBELEGT** am Bezeichner; Ledger `:3721` beschreibt den Fall inhaltlich (INFO-Rang: „stat scheitert, open gelingt") |

### 3.4 Posten (30)–(38) — Herkunft Q5, Nummern 33–38 zusätzlich Q8

| Nr. | Kandidat | Ist-Zustand / Beleg | Status |
|---|---|---|---|
| (30) | `test_s5_artifact_cache_bounded` festes Tempdir + `remove_all` | am Objekt **geheilt**: `tests/unit/test_s5_artifact_cache_bounded.cpp:19` inkludiert `comdare_test_tmp.hpp`, `:42` nutzt `user_tmp_dir()` | **ERLEDIGT** in ce `b8fd9fd2` — Rest-Flake-Frage siehe `(69)` |
| (31) | Presence-/Registrierungs-Weg-Asymmetrie (`make_fingerprint_key_fn` trimmt, `lager_contains` nimmt roh) | beide Symbole aktiv: `fingerprint_key_source.hpp:77`, `builder_registration.hpp:612/:619/:622` | **OFFEN** |
| (32) | `kAdapterCompositionSlotCount == 13` vs. live `slot_count == 11` | **16 Treffer**; Konstante steht unverändert bei 13 (`adapter_anatomy.hpp:200`); `test_e24_c6_…:107` **pinnt** den Wert per `static_assert` | **OFFEN** — **Dublette von (37)** |
| (33) | `SetDock`/`SetPruefDock`-Doppel-Schicht je Dock-Datei | am Objekt: `set_dock.hpp:55` `class SetDock` **und** `:100` `class SetPruefDock final : public IPruefDock` — Doppel-Schicht besteht | **OFFEN** (Q5 **und** Q8, doppelt geführt) |
| (34) | Nummerierungs-Drift in CMake-Kommentaren (a/5 vs. a/2) | nicht am Objekt lokalisierbar ohne die Original-Fundstelle | **UNBELEGT** (s. Abschnitt 6) |
| (35) | SA-Dock ohne `dock_version()`-Member | `adapter_dock.hpp:102` hat `static constexpr dock_version()`; `pruef_dock_version.hpp:32/:66-74` erklärt ein **virtuelles** `dock_version()` ausdrücklich für eine unerwünschte Vertrags-Erweiterung und stellt `pruef_dock_version_for(genus)` als gattungs-generischen Ersatz bereit | **ERLEDIGT (durch Design-Entscheid)** — Asymmetrie ist begründet und dokumentiert, kein Aufräum-Rest |
| (36) | P11-A-Rest: K1-Prosa „SearchAlgorithm-Gattung" | `/usr/bin/grep -rn "SearchAlgorithm-Gattung"` über ce → **54 Treffer** (Ledger/Q8 nannten 29 → **gewachsen**). Auflage: Datei-Liste **immer** aus dem grep ableiten, nie handpflegen | **OFFEN**, Umfang nach oben korrigiert |
| (37) | `kAdapterCompositionSlotCount == 13` frozen legacy (bestätigt) | s. (32) | **OFFEN** — **Dublette von (32)** |
| (38) | `genus_module_*.cpp` ohne anonymen Namespace | 7 Dateien am Objekt: `genus_module_{adapter,alt_major7,major7_neue_magic,sequence,set,set_defekt,view}.cpp` | **OFFEN** (Konsistenz-Kandidat, kein Lint-Verstoß) |
| — | **Q8-Zusatz ohne Ledger-Nummer:** die vier `perm_*`-Prüflings-Module aus C10 (`perm_set_defekt_d13`, `perm_alt_major7`, `perm_major7_neue_magic`) sind **absichtlich defekt/veraltet** | — | **GESPERRT im Sinne von „nicht reparieren"** — beim Aufräumen weder heilen noch entfernen |

### 3.5 Posten (39)–(53) — Herkunft Q5 (Ledger `:3868`, Voll-Belege im Dossier §4.3)

| Nr. | Kandidat | Ist-Zustand / Beleg | Status |
|---|---|---|---|
| (39) | `abi->builder`-Altkante = V32-Insel/totes Blatt | ce `include/cache_engine/abi/cache_engine_execution_engine_adapter.hpp` **existiert**; Konsumenten: 1 Test-TU (`builder/commands/tests/test_engine_adapters.cpp:6`) + 2 Kommentar-Referenzen (`i_command.hpp:3`, `execute_engine_command.hpp:3`) — **deckt sich exakt mit der Ledger-Angabe** | **OFFEN**; Kur = Entfernung **mit frischem 0-Konsumenten-Beweis am Dann-Ist** |
| (40) | `topics`→`anatomy`-Policy-Bausteine (`view_registries`, `view_policies`, `axis_growth_registry`, `axis_growth_policies`, `axis_command_base`) | alle vorhanden (`axis_command_base` 2 Dateien) | **OFFEN** — Ziel-Ort offen, **G8-gesperrt** bis nach der Abgabe |
| (41) | `anatomy/organ_location.hpp` mit vielen Aufwärts-Konsumenten | Datei vorhanden; `/usr/bin/grep -rn 'organ_location.hpp' --include=*.hpp --include=*.cpp \| grep -c '#include'` → **97** (Ledger nannte 79 → **gewachsen**) | **OFFEN** (ggf. mit (43) bündeln) |
| (42) | `builder/`-Dünn-/Stub-Verzeichnisse + Einordnung `builder/measurement/thread_pinning.hpp` | **16 Verzeichnisse unter `builder/` mit ≤2 Dateien**, darunter `measurement/`, `curve_fit/`, `latex_renderer/`, `permutation_engine/`, `telemetry_spool/` | **OFFEN** |
| (43) | `axes/`-vs-`topics/`-Doppel-Wurzel EINER Schicht | `comm -12 <(find axes -name '*.hpp' -printf '%f\n'\|sort -u) <(find topics -name '*.hpp' -printf '%f\n'\|sort -u) \| wc -l` → **280 gleichnamige Header** (Ledger nannte „11 Doppel-Namen" auf Verzeichnis-Ebene) | **NACH ABGABE**, eigenes Fenster; binary-berührend via Codegen-`header_include` |
| (44) | Terminologie-Sweep-Erweiterung neben (36) | Ledger nennt 176 `<Genus>-Gattung`-Treffer + 18 „fünf/5 Gattungen"; Auflage: grep-Kommandos **literal** aus dem Dossier, Datei-Liste **immer** aus grep | **OFFEN**, Zahlen bei Ausführung neu zu erheben |
| (45) | Stale Zahlen-Kommentare | `observable_tier.hpp:15` (`axis_stats[17][8]` + `seg_ns[17]`) und `:17` (*„aktuell Major 6"*) **stehen unverändert**; `anatomy_base.hpp:224` (*„Pflicht 17 fuer Mammal"*) ebenfalls | **OFFEN** (= **AP-06**, dort als „teilweise erledigt" geführt: golden_kern-Drift zu, `anatomy_version_stamp` offen) |
| (46) | G8-§1.2-Dateitabelle fortschreiben (4× `*_tier_v2.hpp`, `set_tier_algebra.hpp`, `measurable_workload.hpp`) | die vier `*_tier_v2.hpp` existieren (`adapter/sequence/set/view`) | **OFFEN** — Doku-only; **Entscheid steht:** Lead-Doku-Nachzug im nächsten ce-Fenster nach der A8-S3-Landung |
| (47) | SA-V2-Matrix-Asymmetrie kommentieren | die vier `*_tier_v2.hpp` vorhanden; V3-Schema besetzt die Zelle bewusst, nirgends dokumentiert | **OFFEN** (Doku-only) |
| (48) | e24-Label-Nachzug an `test_e24_*`-Tests | `ls tests/unit/test_e24_* \| wc -l` → **37 Dateien**; `grep -c test_e24_ tests/unit/CMakeLists.txt` → **42 Registrier-Zeilen**. Die Ledger-Angabe „18/37" ist die Label-Quote, am Objekt nicht direkt reproduzierbar | **OFFEN**, Quote bei Ausführung neu zu erheben |
| (49) | Testnamen ohne `test_`-Präfix | `ls tests/unit/*.cpp \| /usr/bin/grep -vc "/test_"` → **18 Dateien** (Ledger nannte 3). Darunter fallen allerdings die 5 `genus_buildvariant_*`, 7 `genus_module_*` und `auto_emitted_perm_module.cpp`, die **absichtlich** Modul- und keine Test-TUs sind | **OFFEN**, Menge zu präzisieren (echte Test-TUs ohne Präfix: `br4_emit`, `br4_load`, `kf16_e2e_real_build` → deckungsgleich mit (22b)) |
| (50) | super-Seite: `messreihe_v32_parser.hpp` + Test entfernen **nach** V-5c-Bestätigung | Datei vorhanden (`super Code/02_messung_driver/messreihe_v32_parser.hpp`); trägt 3× `[[deprecated("superseded by parse_experiment_profile / comdare_experiment — INC-D")]]` (`:221/:265/:277`) | **OFFEN**, gated auf V-5c |
| (51) | ce `docs/INDEX.md` + `architecture/INDEX.md` fortschreiben | `docs/INDEX.md` vorhanden; letzte Änderung = **Initial commit** `3d14ed36` → seither nie fortgeschrieben | **OFFEN** (Doku-only) |
| (52) | ce `docs/architektur/` (dt.) nach `docs/architecture/` überführen | `ls -d docs/architektur` → **existiert nicht** | **ERLEDIGT** (Verzeichnis aufgelöst) |
| (53) | Kompositions-Platzierungs-Asymmetrie (`AdapterComposition` eingebettet vs. eigene Dateien) | `adapter_anatomy.hpp` vorhanden; Include-Pfad-Vorsicht `genus_binding_traits.hpp:16` | **OFFEN** — **G8-berührt** |

### 3.6 Posten (54)–(63) — Herkunft Q5 (Ledger `:3904` / `:3911`)

| Nr. | Kandidat | Ist-Zustand / Beleg | Status |
|---|---|---|---|
| (54) | 4 stale Zeilen-Anker im `abi_adapter`-Kopf | `abi_adapter.hpp:37-52` trägt die Datei-Navigation und **sagt selbst**: *„bei Anker-Drift den jeweiligen `// ───`-Banner greppen — Zeilen-Anker sind approximativ"* | **OFFEN**; **AP-Plan führte ihn als „nicht geprüft/UNBELEGT"** — hiermit **belegt** |
| (55) | toter `xmmintrin`-Include + irreführender Kommentar | Anker `:111-112` **leicht gewandert** → `abi_adapter.hpp:115` `#include <xmmintrin.h>`. **Der Befund ist am Ist NICHT mehr haltbar:** die Datei enthält reale `_mm_prefetch`-Aufrufe im T7-Prefetch-Segment (u.a. `:1005`, `:1542`) | **WIDERLEGT AM IST** — Posten sollte nach Owner-/Lead-Blick gestrichen oder umgewidmet werden (s. Abschnitt 6) |
| (56) | HOT-Patricia-Organ konsumiert PC-Achsen-Primitiv statt bit-identischem Eigenbau | `hot_patricia_traversal_organ.hpp` in **2 Bäumen** vorhanden (axes/ + topics/) | **OFFEN** |
| (57) | `descent_slot_for_`-Duplikat durch `SortedBinaryTraversal::lower_bound_index` ersetzen | **12 Treffer**, Kern in `abi_adapter.hpp:1217/:1221/:1284/:1289` | **OFFEN** (W1-Teil A, statischer Drop-in) |
| (58) | Descent-Slot-Bestimmung ans konfigurierte Traversal-Organ delegieren | Anker `abi_adapter:2192-2206` | **OFFEN — SEMANTISCH** (W1-Teil B, Mess-gegated) |
| (59) | Slot-Storage-Doppel-Abbildung auflösen (`NodeTypeSlotStore` designiert, 0 Live-Konsumenten) | **25 Treffer** für `NodeTypeSlotStore` | **OFFEN — SEMANTISCH** |
| (60) | R5.B `SortedArrayKeySet`-Interim durch echte `search_algo`-Wrapper ersetzen | `set_default_organ.hpp:18` `struct SortedArrayKeySet` **steht unverändert**, Interim selbst-deklariert; **41 Treffer** repo-weit | **OFFEN — SEMANTISCH** |
| (61) | Layout-Offset-Rechner der 5 Repräsentationen in die layout-Achse heben | Anker `store:398-427` | **OFFEN — SEMANTISCH** (W2-Bündel) |
| (62) | KF-6 Cacheline-NTTP-Codegen-Verdrahtung | — | **OFFEN — VORZIEH-KANDIDAT**, falls `cacheline_study` vor der Abgabe gemessen wird. ⚠️ **Nicht verwechseln** mit dem „Posten 62" aus Ledger `:6503` (stiller Fallback `axis_04_…:99`) |
| (63) | Q2-Treiberkapazität 1024 als benannter Parameter statt 3× Wiederholungs-Literal | am Objekt nicht ohne die Original-Fundstellen isolierbar (`1024` ist repo-weit zu häufig) | **OFFEN**, Fundstellen bei Ausführung aus dem Katalog-Vermerk zu holen |

### 3.7 Posten (64)–(76) — Herkunft Q5 (Ledger `:3918` / `:3926` / `:3938` / `:3946`)

**Wichtig: die A1-Scheibe hat vier dieser Posten bereits erledigt** (ce `0b5ed557`,
*„fix(axis_06/axis_04): EIN Wurf-Vertrag ueber die Allokator-/Store-Stellen (A1-Scheibe, Posten
71/72/73/74)"*, mit neuem Test `test_a1_wurf_vertrag_allokator_store.cpp`, 544 Zeilen, registriert).

| Nr. | Kandidat | Ist-Zustand / Beleg | Status |
|---|---|---|---|
| (64) | nullptr-OOM-Durchreichung `StdAllocatorAdapter`→`std::vector` | `axes/alloc/axis_06_allocator_strategy_base.hpp:26-28` beschreibt heute den **gebauten** Wurf-Vertrag (*„den OOM-nullptr jetzt nach `std::bad_alloc` … und laesst bei bytes == 0 keinen nullptr mehr durch"*) | **ERLEDIGT** in ce `0b5ed557` |
| (65) | `iterable_aspect`-Concept-Kommentar stale | Symbol lebt in `src/permutations/permutation_engine.hpp:173/:183/:191` | **OFFEN** (Kommentar-only) |
| (66) | Perf-Sanity-Feld-Index-Literale namens-ableiten | — | **OFFEN** (Härtung, muster-konform) |
| (67) | HashLookup-Fibonacci-Hash = Achsen-Ausbau (neue mapping-Hash-Variante) | Anker `hash_lookup:105/:304-305` | **NACH ABGABE — SEMANTISCH**, Owner-Vorlage |
| (68) | T6-Einsammel-Frage (`traversal_`/`mapping_`/`slot_allocator_statistics()` fließen in keine CSV-Spalte) | — | **OFFEN — DESIGN** (A8-Mess-Schnitt; Doppelzählungs-Regel nötig) |
| (69) | per-UID-Tempdir `comdare_test_tmp.hpp` kollidiert bei parallelen Worktree-ctests | Header existiert und wird von `(30)` bereits genutzt; die Kollision zwischen **Worktrees** bleibt (Suffix je Worktree oder Staffelung) | **OFFEN — BETRIEB**, bis dahin Wellen-Gates seriell |
| (70) | stale `bad_alloc`-Kommentare nach axis_06-Umstellung | `btree_node_pool_store.hpp` / `hash_bucket_pool_store.hpp` unter den erwarteten Pfaden **nicht gefunden** (Verzeichnisse umbenannt: `axes/alloc/`, `axes/node/`) | **OFFEN**, Fundstellen neu zu erheben |
| (71) | `PmrResourceAdapter` reicht Strategie-nullptr ungeprüft durch | `axis_06_allocator_strategy_base.hpp:26-28` + `:254` dokumentieren den neuen Vertrag; `allocate_or_throw` neu | **ERLEDIGT** in ce `0b5ed557` |
| (72) | `StdAllocatorAdapter::allocate` ohne `n*sizeof`-Überlauf-Wache | am Objekt gebaut: `:139` `#include <limits> // A1-Posten 72`, `:380` `if (n > max/sizeof(T)) throw std::bad_array_new_length{};` | **ERLEDIGT** in ce `0b5ed557` |
| (73) | `node_width_config.hpp:54` Default-Literal 64 | am Objekt gebaut: `:19` `#include "cacheline_line_bytes.hpp"`, `:64` `node_width_bytes(std::size_t line_bytes = kDefaultLineBytes)` | **ERLEDIGT** in ce `0b5ed557` (= **AP-04**) |
| (74) | OOM-Roh-Route `layout_aware append_slot` + Kopier-Ctor-Leck-Nuance | am Objekt gebaut: `axis_04_node_type_layout_aware_store.hpp:75` (*„konsumiert seit Posten 74 `A::allocate_or_throw`"*), `:350` Aufruf, `:744-745` Leck-Nuance dokumentiert | **ERLEDIGT** in ce `0b5ed557` |
| (75) | 01a-Gate-Schwächen ((5c)-Prüfung vakuös durch `restore_statistics`; Kohärenz-Wache nur `>0`) | — | **OFFEN** (Härtungs-Kandidat, bei O4-Extraktion schärfen) |
| (76) | transiente Streu-/Umbau-Puffer der node-Stores (14 Stellen, Klasse D) | — | **OFFEN — DESIGN**, Input für die T6-Einsammel-Naht |

### 3.8 Posten (77)–(92) — Herkunft Q5 (Ledger `:3959`–`:4179`)

| Nr. | Kandidat | Ist-Zustand / Beleg | Status |
|---|---|---|---|
| (77) | `kReal16`-Suffix kollabiert auf kurzen Keys auf `kNone`-Verhalten | `surf_suffix_bits.hpp` in 2 Bäumen vorhanden; Doku-Pin gelandet (ce `442c960b`) | **OFFEN — MESS-INTERPRETATION**, vor Messbeginn entscheiden. Doku-Auflage erfüllt |
| (78) | XorFilter erzeugt **echte** FALSE NEGATIVES (30/256) | `axis_filter_xor.hpp` in 2 Bäumen (`axes/filter_axis/`, `topics/filter/axis_filter/`); Doku-Auflage gelandet (ce `442c960b`) | **OFFEN — INHALTLICH**; Owner-Auflage: FN-Einschränkung bei **jeder** XorFilter-Messwert-Verwendung ausweisen, **auch** in Thesis/Messbild |
| (79) | `mutable walk_stack_` in `ComposedTree`/`BTreeSearch` verengt Re-Entranz-Zusicherung | **12 Treffer** | **OFFEN** (Konsistenz-Kandidat, am Ist ungenutzt) |
| (80) | `-O3`/MimallocAllocator-`jmp .`-Befund an `AxisBoundBuffer` **unverifiziert** | `axis_bound_scratch.hpp` vorhanden (Anker `:56-64`) | **OFFEN — PFLICHT-VORLAUF** der 01c-Pilot-Scheibe („VOLLZOGEN-ODER-STOPP") |
| (81) | D1-Wrapper-Fassade: einfacherer Schnitt (direkte Template-Köpfe + einmalige XML-Regenerations-Runde) | — | **NACH ABGABE** (Konsolidierungs-Fenster, Owner-Rückfrage dann fällig) |
| (82) | `original_surf` ohne `if constexpr (enabled)` um den insert-Rumpf | Datei in 2 Bäumen vorhanden (Anker `:181-189`) | **OFFEN**, sofern nicht bei der Landung mitgeheilt |
| (83) | Familien-Gate-Universen an `kOrganGruppen`-Quelle koppeln | — | **OFFEN — GENERALISIERT**: alle Nachweis-greps müssen Doppelwurzeln erfassen (hängt an (43)) |
| (84) | Observer-Copy-Semantik der migrierten 03a-Organe deklarieren | — | **NACH ABGABE — Deklarations-Kandidat** (messwirksam inert, `OBSERVER_PUSH` Default OFF) |
| (85) | h81-Wachen-Härtung (Member-Pointer wird durch legitimen Overload-Satz ambig) | — | **NACH ABGABE** (niedrig, kein In-Tree-Fall) |
| (86) | Kosmetik: Commit `27ef28ea` nennt „wormhole-Muster", textuell exakt ist hot/start-Muster | — | **OFFEN** (= **AP-03**, dort umgewidmet) |
| (87) | `organ_hull_`-Kompositionen bleiben Level-2 (`ObservableComposedContainer` ohne `rebind_allocator`) | Symbol aktiv (`abi_adapter.hpp:76/:2367`, `topics/axis_command_base.hpp:26`) | **NACH ABGABE** |
| (88) | `anatomy_execution_context.hpp:50-63` zweiter Trait-Konsument einarmig | Datei vorhanden | **OFFEN** |
| (89) | MESSTECHNIK-KENNTNIS: fremde T6-Wahl materialisiert ab jetzt den Rebound-Leaf statt der Fassade | — | **KENNTNIS, kein Aufräum-Objekt** — beim ersten Vergleich gegen Alt-Mess-CSV einpreisen |
| (90) | Hybrid-Design-Doc um GoF-Einordnung + CT-Weitergabe-Pflicht beider Achsen-Arten ergänzen | ce `docs/architecture/20260802-hybrid_tier_stufe_soll_design.md` | **OFFEN** (Doku-only, bei Bau in der Auswertungsphase) |
| (91) | Regel-Katalog „wann hat ein UML-Element Nachholbedarf" verfeinern | Erst-Entwurf in Atlas REV 5 (`docs/architecture/05b_uml_klassenatlas_20260805.*`, Regel R5) | **OFFEN** (Owner-Vermerk) |
| (92) | R-G2 Registry-Kanon-Divergenz (`validate`=2er vs. `plan`=3er) mitgenommen statt vereinheitlicht | — | **OFFEN — bewusste Abweichung**, Owner-Einspruch möglich |

---

## 4. Kandidaten OHNE Ketten-Nummer

Diese sind in der Kette nie registriert worden. Sie bekommen hier **keine** neue Ledger-Nummer
(Doktrin „nie neu nummerieren"); sie tragen ein `X-`-Präfix, das ausdrücklich **kein** Ketten-Glied ist.

### 4.1 ce-Header/Skripte, die sich SELBST als tot deklarieren (Q9)

| Nr. | Objekt | Fundort | Konsumenten am Ist (Befehl → Zahl) | Status |
|---|---|---|---|---|
| X-01 | `comdare_is_original_macro.hpp` — *„ECHT-TOT"* | ce `libs/cache_engine/src/sha256/…:3-13` | `#include`-Konsumenten → **0** | **OFFEN** (= Posten (7a)) |
| X-02 | `concepts/locking_mode.hpp` | ce `include/cache_engine/concepts/locking_mode.hpp:3-4` | `#include`-Konsumenten → **0**; `ILockingMode` → 3 Treffer, alle in der Datei selbst | **OFFEN** |
| X-03 | `concepts/numa_affinity.hpp` | ce `…/numa_affinity.hpp:3-4` | `#include`-Konsumenten → **0**; `INumaAffinity` → 3, alle in der Datei | **OFFEN** |
| X-04 | `concepts/scheduling_strategy.hpp` | ce `…/scheduling_strategy.hpp:1-20` | ⚠️ **Die Selbstaussage „0 Konsumenten" ist am Ist NICHT MEHR WAHR:** `#include`-Konsumenten → **2** (`measurement/scheduling_system_axis.hpp:19` und `tests/unit/test_striktheit_axis_dach_guard.cpp:12`), und `test_striktheit_axis_dach_guard.cpp:81` **pinnt** `ISchedulingStrategy` per `static_assert(std::is_polymorphic_v<…>)` | **OFFEN — Entfernung ist NICHT frei**: sie bricht die Dach-Guard-Wache |
| X-05 | `concepts/hardware_strategy.hpp` | ce `…/hardware_strategy.hpp:3-4` + 5 Enum-Marker | ⚠️ **ebenfalls nicht frei:** `#include`-Konsument → **1** (`numa_affinity.hpp:23`, wegen des `NumaStrategy`-Enums). `IHardwareStrategy` selbst → 4 Treffer, alle in der Datei | **OFFEN — Reihenfolge: erst Enum umhängen, dann Header** |
| X-06 | `measurement/extension_hardware_system_axis.hpp` | ce `…:4-14` | `#include`-Konsumenten → **2** (`measurement/axis_error_traits.hpp:85`, Dach-Guard-Test `:15`) | **OFFEN — niedrige Priorität** (Nachfolger `simd_sub_axis.hpp` ist benannt) |
| X-07 | `slurm_launcher.hpp` (ZIH-/SLURM-/sbatch-Pfad) | ce `builder/experiment_tree/slurm_launcher.hpp:2` | `#include`-Konsumenten → **1** (`tests/unit/test_kf12_kf13_slurm_prepare.cpp:6`) | **OFFEN** — Entfernung zieht den Test mit |
| X-08 | `deploy/comdare-ce.def` (Apptainer, ZIH-Pfad) | ce `deploy/comdare-ce.def:1` | Datei getrackt | **OFFEN** |
| X-09 | `deploy/build_sif.sh` (ZIH-/Apptainer-/sbatch) | ce `deploy/build_sif.sh:2` | Datei getrackt | **OFFEN** |
| X-10 | `apps/adhoc_emitter/main.cpp` — SUPERSEDED (V41.P2/P3) | ce `apps/adhoc_emitter/main.cpp:13-22` | **aktiv gebaut**: Ziel `comdare_adhoc_emitter_cli` (`CMakeLists.txt:1561`), Configure-Time-Aufruf über `cmake/adhoc_emitter.cmake` | **OFFEN — Entfernung berührt den Bauweg**, nicht frei |
| X-11 | `builder/example_configs/test_data_sets.xml` — historische Dataset-Doppelquelle | ce `…:3-5` | getrackt; super `main.cpp:201` nennt den Slot ausdrücklich *„existiert nirgends"* | **OFFEN** |
| X-12 | `.gitmodules.template.obsolete` | ce Repo-Wurzel | getrackt; `cmake/check_submodules.cmake:6-8` erklärt das Muster für obsolet | **OFFEN** |
| X-13 | `tests/unit/thesis_tiere/README.md` + `docs/ERWEITERUNGS-LEITFADEN.md` Teil A — DEPRECATED-Kopf-Banner (PowerShell-Harness) | ce `README.md:3`, `ERWEITERUNGS-LEITFADEN.md:19` | Doku | **DOKU — fällt NICHT unter §75** (Doku-nie-löschen); nur der Banner bleibt |

### 4.2 ce-Buildsystem und Bibliotheks-Reste

| Nr. | Objekt | Fundort | Ist-Zustand / Beleg | Status |
|---|---|---|---|---|
| X-14 | Build-Option `COMDARE_BUILD_LEGACY_REIMPL` — `[REMOVED]`, *„hat aber keinen Code mehr"* | ce `CMakeLists.txt:482` (Option) + `:738` (Status-Zeile `[DEPRECATED]`) | 4 Treffer, kein wirkender Code dahinter; bewusst „für Cluster-Kompatibilität" erhalten | **OFFEN** — Entfernung mit Infra abstimmen |
| X-15 | Zweiter CSV-Kopf `result_csv_header()` neben `lazy_csv_header` | ce `builder/commands/result_aggregator.hpp:92`, Aufrufer `:112` | **1 Aufrufer**, beide in derselben Datei | **OFFEN** — Herkunft Q13 (`20260803-a9_xlsx_writer_f3_soll_design.md:536-537`, dort ausdrücklich als „LED-75-Kandidat") |
| X-16 | Pfad A der Benchmarking-Naht deprecaten (`run_workload`/`_segmented`/`_segmented_v2` + `drive_segment_latencies`) | ce `abi_adapter.hpp` (Navigation `:232`), Herkunft Q13 `20260803-a8_f2_benchmarking_schnitt_soll_design.md:326-327` | Pfad A aktiv | **OFFEN** — *„DEPRECATEN … Entfernung erst am Ende, Doku bleibt"* |
| X-17 | Legacy `KArySearchAlgo` (Runtime-Arität, name `k_ary`) | ce `axes/lookup/axis_03a_search_algo_k_ary.hpp:449-458/:833-856` | selbst als *„retiring in Inc 2"* deklariert — **eigener Mechanismus, nicht §75** | **OFFEN — eigene Bahn** (Increment 2, Registry-Umschaltung); hier nur registriert, damit er nicht doppelt gefahren wird |
| X-18 | 79 von 220 CMake-Zielen tot (35 namentlich + 44 schleifengeneriert) | ce `tests/unit/CMakeLists.txt`; Herkunft Q4 Ledger `:8159-8162` | Ledger sagt selbst: *„**nicht** in der Sec.-75-Kandidatenliste"* — die namentliche Liste existiert **nur im Endbericht des Workflows** | **OFFEN — Namensliste zu bergen** (s. Abschnitt 6) |

### 4.3 super-Seite (Q10 / Q11 / Q12 / Q14)

| Nr. | Objekt | Fundort | Ist-Zustand / Beleg | Status |
|---|---|---|---|---|
| X-19 | `cmake/write_perm_all_manifest.cmake` — **Aufrufer = 0**, selbst als §75-Kandidat vermerkt | super `Code/CMakeLists.txt:264-265` | Skript getrackt; `/usr/bin/grep -rn write_perm_all_manifest` über super (ohne `external/`) → **2 Treffer, beide Kommentar** | **OFFEN — sauberer Kandidat** |
| X-20 | V32-Alt-Antrieb: `v32_orchestrator.hpp` (`[[deprecated]]` `:47/:50/:91`), `messreihe_report_exporter.hpp:2`, `v32_katalog_driver.hpp:2`, `messreihe_v32_validator.hpp:15` | super `Code/02_messung_driver/` | alle vier getrackt, alle mit Selbst-Deklaration („DEPRECATED-BY-DESIGN, Fork A, 2026-07-16") | **OFFEN** |
| X-21 | `messreihe_v32_parser.hpp` (3× `[[deprecated]]`) | super `Code/02_messung_driver/messreihe_v32_parser.hpp:221/:265/:277` | getrackt | **OFFEN**, gated auf V-5c — **identisch mit Posten (50)** |
| X-22 | `Code/experiment_config/deprecated/` — 3 tote Alt-Configs, *„0 Konsumenten belegt (grep)"* | super `config_a_prt_art_vs_sota.xml:2`, `config_b_cache_engine_perms.xml:2`, `config_c_merge_alt_neu.xml:2` | 3 getrackte Dateien, bereits in ein `deprecated/`-Verzeichnis verschoben | **OFFEN** |
| X-23 | `test_data_xml/messreihe_v32_schema_example.xml` + `.xsd` — Legacy-Fixture | super `…:2` je | getrackt; Kopf sagt *„BEHALTEN (Doku-nie-loeschen, INC-D), aber KEIN Ziel-Traeger"* | **GESPERRT im Sinne von „behalten"** |
| X-24 | `Code/tests/CMakeLists.txt:161-162` — `experiment_golden.xml` inhaltlich deprecated, **treibt aber real den Antriebs-Test** | super | aktiv | **OFFEN — Entfernung nicht frei** |
| X-25 | `MANUAL_RUN.md:25` — Weg A ruft `build_and_measure_150_tiere.ps1` | super `Code/MANUAL_RUN.md` | Doku | **DOKU** — Banner bleibt |
| X-26 | **AP-01 „leere 3D-caption"** (`write_surface3d` `data.title` nie gesetzt) | super `Code/05_diagram_generator/diagram_generator.cpp` (~`:1305-1307`) | **am Objekt geheilt**: `data.title = surface3d_title(metric, de);` mit Kommentar *„P1a: … vorher blieb `data.title` leer -> leere `\caption{}`"* | **ERLEDIGT** in super `7969a02c` — Ledger `:6926` und Register Q11 führen ihn noch als offen |
| X-27 | **AP-02** 1×N-/N×1-Matrix-Bestandsfehler | Q11/Q12 | nicht am Objekt nachgeprüft | **OFFEN** (Q12 führt ihn als „offen, belegt, ausführbar") |
| X-28 | **AP-07** M1–M3 der Teil-2-Review | Q11/Q12 | Q12 selbst: *„NICHT AUSFUEHRBAR (Gegenstand unbekannt)"*, als Platzhalter **mit UNBELEGT-Marke** stehen zu lassen | **UNBELEGT — nicht streichen** |
| X-29 | **AP-08** honest-0-Musterfortsetzung | Q11/Q12 | Q12 empfiehlt **Umwidmung**: stehende Auflage statt Kandidat | **UMWIDMEN, aus der Kandidatenmenge heraus** |
| X-30 | **AP-09** `axis_inventory.tex` wird geschrieben, aber von keiner `.tex` eingebunden | super `Code/08_appendix_generator/appendix_generator.cpp:423` | Q11 `:393-394` | **OFFEN** — braucht einen kleinen Owner-/Lead-Entscheid (welcher Anhang-Abschnitt) |
| X-31 | **AP-10** referenzlose `using SearchAlgo`-Aliase | ce `abi_adapter.hpp:440/:545` (Anker laut Q12 **nachweislich gewandert**) | Q11 `:445` | **OFFEN**, Anker neu zu erheben |
| X-32 | **AP-12** zwei DEPRECATED-Mess-Jobs `measure:smoke` / `measure:golden-320` | super `.gitlab-ci.yml:665-669` | Q12 `:873-874` meldet einen **Widerspruch**: der DEPRECATED-Kommentar behauptet eine `COMDARE_STATIC_SMOKE_FALLBACK`-Bedingung, die im Job fehlt — entweder ist der Job nicht deprecated oder der Kommentar ist falsch | **OFFEN — gesperrt/vorbedingt** (nach PMC-Invariante) |
| X-33 | `best_binary::BreakEvenPoint` — self-declared **SKELETON**, ungeschützt (im Kontrast zum §75-geschützten `heuristik::BreakEvenPoint`) | Herkunft Q14 `:157/:392-393` | nicht am Objekt nachgeprüft | **OFFEN** — Empfehlung Q14: SKELETON-Vermerk streichen |
| X-34 | A8-S6: 17 stale Kommentarstellen — **aus Phase 3 in den §75-Pass verschoben** | Herkunft Q14 `:43`; deckungsgleich mit Posten (25) und **AP-05** | s. (25) | **OFFEN** |

---

## 5. Bilanz

| Klasse | Anzahl | Posten |
|---|---|---|
| **Kandidaten insgesamt geführt** | **126** | 92 Ketten-Posten + 34 ohne Ketten-Nummer (X-01…X-34) |
| davon **OFFEN** | **99** | s. Tabellen |
| davon **BEREITS ERLEDIGT/ENTFERNT** (mit Commit belegt) | **14** | (1), (14), (20), (30), (35), (52), (64), (71), (72), (73), (74), X-26 + Startliste `cmake/permutations.cmake` und `COMDARE_apply_simd_flags` |
| davon **GESPERRT** (Schutzklausel + Selbst-Lösch-Verbote + „nicht reparieren") | **8** | S-1…S-5, Q8-`perm_*`-Trio, X-23, X-13 (Doku) |
| davon **UNBELEGT** (Gegenstand nicht auffindbar/nie heruntergebrochen) | **6** | Q1-„historisierte Auflagen-Hinweise", (16), (28), (29), (34), X-28 |
| davon **WIDERLEGT am Ist** | **1** | (55) toter `xmmintrin`-Include |
| **NACH ABGABE** ausgelagert (Teilmenge von OFFEN) | **7** | (43), (67), (81), (84), (85), (87), X-17 |

**Die drei saubersten Erst-Kandidaten** (Objekt existiert, 0 Konsumenten am Ist belegt, kein Test hängt dran):

1. **X-01 / (7a)** `comdare_is_original_macro.hpp` — 0 `#include`-Konsumenten.
2. **X-19** `super cmake/write_perm_all_manifest.cmake` — 0 Aufrufer, vom Bauskript selbst so vermerkt.
3. **X-02 / X-03** `concepts/locking_mode.hpp` + `concepts/numa_affinity.hpp` — je 0 `#include`-Konsumenten
   (⚠️ **aber**: `numa_affinity.hpp` inkludiert `hardware_strategy.hpp` — Reihenfolge beachten, s. X-05).

---

## 6. Was ich NICHT feststellen konnte

Ehrlich abgegrenzt — diese Posten sind **nicht** erledigt, sondern **nicht prüfbar**:

1. **Q1 „historisierte Auflagen-Hinweise"** — seit dem 27.07. nie auf Datei/Zeile heruntergebrochen.
   Ohne Gegenstand kann weder Existenz noch Aufruferzahl bestimmt werden. **Braucht eine Erhebung,
   bevor der Pass startet.**
2. **(16) „P-C4/G-C6 Doku-Paket"** — `/usr/bin/grep -rn "P-C4\|G-C6"` über ce liefert **0 Treffer**.
   Die Kürzel leben offenbar nur in einem Session-Doc, das ich nicht identifizieren konnte.
3. **(28) „drei Modi"-Doku ×7** — das wörtliche Muster liefert im ce-Baum genau **1** Treffer, und der
   ist ein Mai-Session-Doc. Die gemeinten 7 Stellen benutzen eine andere Formulierung.
4. **(29) FS4/TOCTOU** — `TOCTOU` kommt im Iterator **nicht** als Bezeichner vor; der Anker
   `:1610-1611` ist gewandert. Der Fall ist inhaltlich in Ledger `:3721` beschrieben (INFO-Rang),
   aber nicht am Code lokalisierbar.
5. **(34) Nummerierungs-Drift CMake-Kommentare „a/5 vs. a/2"** — ohne die Original-Fundstelle nicht
   auffindbar.
6. **X-18 die namentliche Liste der 79 toten CMake-Ziele** — der Ledger sagt `:8161` ausdrücklich,
   sie existiere **nur im Endbericht des Workflows**. Ich habe den Endbericht nicht lokalisiert. Der
   Posten ist damit als Zahl bekannt, aber nicht als Menge.
7. **(55) ist am Ist widerlegt, nicht erledigt.** Der Befund „toter `xmmintrin`-Include, 0 echte
   `_mm_`-Aufrufe" trifft auf `abi_adapter.hpp` heute nicht zu — die Datei ruft `_mm_prefetch` real
   auf (u.a. `:1005`, `:1542`). Entweder war der Befund von Anfang an falsch, oder die Prefetch-Achse
   ist seither dazugekommen. **Ich habe ihn nicht gestrichen** — Streichen eines Owner-registrierten
   Postens ist keine Agenten-Entscheidung.
8. **Nicht am Objekt nachgeprüft** (nur aus der Quelle übernommen): X-27 (AP-02 1×N-Matrix), X-33
   (`best_binary::BreakEvenPoint`), sowie die reinen Design-/Semantik-Posten (58), (59), (61), (68),
   (76), (81), (84), (85), (89), (92) — die haben kein mechanisch prüfbares „existiert noch?".

---

## 7. Auflagen für den Aufräumpass, wenn er einmal läuft

1. **Kein Zeilen-Anker dieser Liste ist verlässlich** (Befund C). Immer über den Bezeichner suchen.
2. **Je Fund frischer 0-Konsumenten-Beweis am Dann-Ist** — nicht der hier notierte. Die Zahlen dieser
   Liste sind vom 08.08. und altern.
3. **Fünf Posten sind NICHT frei entfernbar**, obwohl sie sich selbst für tot erklären: X-04, X-05,
   X-07, X-10, X-24. An jedem hängt ein Test oder ein Bauweg. Reihenfolge zuerst klären.
4. **Nummern nie neu vergeben.** Erledigte Posten bekommen „ERLEDIGT in `<commit>`", keine Streichung.
5. **Wer einen Kandidaten unter anderem Namen mitentfernt, zieht diese Liste im selben Commit nach.**
   Das ist die Lehre aus `813c3232` (Ledger `:11624`): ein gegatetes Paket darf nicht nebenbei zur
   Hälfte ausgeführt werden — und wenn es doch geschieht, muss die Liste mitziehen.
6. **`ce build/` niemals blind löschen** — Memory-Anker `reference_ce_build_dir_has_tracked_measurement_csv`,
   Doktrin „Messdaten nie löschen".

---

**ENDE.** Diese Datei wird fortgeschrieben, nicht ersetzt.
