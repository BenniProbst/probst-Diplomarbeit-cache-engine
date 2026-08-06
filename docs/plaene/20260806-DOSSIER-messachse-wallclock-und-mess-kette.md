# DOSSIER: die Mess-Achse — Wallclock als drittes Glied und die vollständige Mess-Kette

**Datum: 06.08.2026, spätabends. Konsolidierung, kein Neuaufschlag.**

**Erhebungs-Anker** (jede Aussage unten gilt gegen diesen Stand, sofern nicht anders datiert):
ce `development` = `2b5ecd29` · super `HEAD` = `18a0bdf3` · super-Gitlink auf ce = `b241a272` (= ce `main`).
**Warnung:** der ce-Checkout im super-Baum steht auf der Seitenlinie `b-m2-pmc-invariante` (`90bca126`),
**nicht** auf `development` — wer dort misst, misst weder den gelandeten noch den Gitlink-Stand.
Ungelandete Pakete: `b-m1-identitaetsnaht` (Worktree `/home/comdare/wt-m1-naht`, HEAD `4fdedbbf`,
7 Commits, 24 Dateien, +3114/−149) und `b-pmc-l3-honest` (Worktree `/home/comdare/wt-pmc-l3-honest`,
**0 Commits**, nur uncommitteter WIP, 5 Dateien, +136/−13).

**Was dieses Dossier ist:** die vom Owner verlangte Konsolidierung der heutigen Erzeugnisse. Es
**verweist** auf die Detail-Dokumente, statt sie abzuschreiben. Vier Erhebungen vom 06.08. abends
(„Wallclock auf drei Ebenen", „messachse-drittes-glied", „zwei-dimensionen", „Ist-Stand der
Mess-Kette") sind hier eingearbeitet — Session-Berichte existieren nicht als Register
(`feedback_paketschnitt_nur_im_sessiondoc_existiert_nicht`), **dieses Dossier ist ihr Register.**

**Detail-Dokumente, auf die verwiesen wird** (alle existieren, am 06.08. spätabends geprüft):

| Kürzel | Pfad |
|---|---|
| LEDGER | `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (§47 `:2496-2506`, §64 `:3381 ff.`, abend-4 `:4202-4735`) |
| A8 | ce `docs/architecture/20260803-a8_f2_benchmarking_schnitt_soll_design.md` (492 Z.) |
| DOK-24 | ce `docs/architecture/24_messmodell_korrektur_zwei_dimensionen.md` |
| KANON-F2 | thesis-repo `sessions/20260801-THESIS-FAKTEN-KANON.md` (`:391-394`) |
| KLÄRUNG | `docs/plaene/20260806-KLAERUNG-zweiphasig-dreiphasig-drei-typen.md` |
| PLAN-WARN | `docs/plaene/20260806-PLAN-warnungen-und-ausgabe-bei-messfehlern.md` |
| PLAN-HYBRID | `docs/plaene/20260806-PLAN-hybrid-pmc-numa-core-permutation.md` (dazu `20260806-PLAN-hybrid-architektur-pmc-achsen-zuordnung.md`) |
| PLAN-KETTE | `docs/plaene/20260806-PLAN-messkette-ceb-observabletier.md` |
| PLAN-BREAK | `docs/plaene/20260806-PLAN-break-even-und-drei-benchmark-ebenen.md` und `20260806-PLAN-messkurven-synthese-und-hybrid-binary.md` |
| DIFF | `docs/plaene/20260806-DIFF-thesis-soll-gegen-ledger-und-code.md` — **mit Korrektur K-1, s. §8** |
| TERMIN-6 | `docs/termine/20260508 Termin 7/_extracted_text/20260416 Termin 6__20260416_PRT_ART_Termin6_Scope_Freeze_final.docx.txt` (`:55`), `Begriffsglossar_v4_FINAL.txt` (`:418`), `Domaenenmodell_PRT_ART_v3.txt` (`:207-217`) |

Code-Pfade unten relativ zu ce = `Code/external/comdare-cache-engine/libs/cache_engine`,
Thesis relativ zu `Code/external/20260931-overleaf-diplomarbeit`.

---

## 1. Der Anlass und der Owner-KERN

Owner-KERN vom 06.08. abends, **verbatim**:

> „**Wall Clock time** wird daher auch **fuer jeden Achsenaufruf IN der Tier-Binary**, **fuer
> jeden Funktionsaufruf durch die CEB AUF dem Pruefdock ueber die Tier-Binary**, und ebenfalls
> als **large scope im selben Zug zu den Last-Profilen ueber den Verlauf mehrerer
> Funktionsaufrufe der Tier-Binaries ueber eine gemessene Last-Sequenz**, erhoben. Die
> **Wallclock time ist das dritte Glied**, welches in der **Messachse in die CEB und damit
> DREIPHASIG in die Tier-Binaries eingearbeitet** wird und **lebt per Planung und Definition
> in der Mess-Achse**."

**Was er korrigiert:** die M-1-Wellen-Lesart von heute Abend — „G1 Basis-Zeit (wallclock) =
EIN äußerer steady_clock je Batch, immer an; G2 Observer (macro); G3 Feinkorn (micro)" — war
**zu eng**. Diese Lesart ist nachweislich **wortgleich vom Doxygen-Kommentar der
Tooling-Registry abgelesen** (`measurement_tooling_registry.hpp:28-30`; Gegenprobe:
„Basis-Zeit" hat im gesamten Projekt **genau 1 Treffer**, eben diese Zeile). Sie hat einen
Kommentar an einem **Bau-Schalter** für eine **Ebenen-Definition** gehalten — an der falschen
Dimension abgelesen, nicht falsch abgelesen.

**Der KERN ist außerdem keine Neuerung, sondern reaktiviert Owner-Gesetz F2 vom 01.08.2026**
(KANON-F2 `:391-394`, verbatim: „Die CEB misst ZUSAETZLICH drei Wallclock-Ebenen: (1) Wallclock
der ACHSEN-Interfaces unter jedem Algorithmus …, (2) Wallclock der GATTUNGS-Interfaces …,
(3) Wallclock einer Test-Last aus den Last-Frameworks"), das als Design-Dossier A8 (03.08.,
492 Z.) im ce-Repo verschriftlicht war — und ungelesen blieb.

---

## 2. DIE ZWEI DIMENSIONEN — die Auflösung der Verwechslung

**These bestätigt: es sind zwei orthogonale Dimensionen, keine eine.** Vierfach belegt:

1. **Am Bau:** `profile_facade/profile_run_facade.cpp:273-275` — `perm_mess_defines()` emittiert
   eine **feste** Define-Menge (`-DCOMDARE_MEASUREMENT_ON=1`, `-DCOMDARE_CE_ENABLE_STATISTICS=1`, …);
   die Tooling-Wahl kommt darin **nicht vor**. Kein Timer-Ort im Code ist durch
   `wallclock`/`macro`/`micro` gegatet — die Tooling-Dimension **kann** die Ebenen-Dimension
   heute gar nicht anfassen. Wäre „wallclock" eine Ebene, müsste sie es können.
2. **Am Plan:** A8 `:66` (F2-Gesetz, E1/E2/E3) und A8 `:225-226` — Konsistenz-Invariante
   „**Summe(E1-konstitutiv) ≤ E2 ≤ E3**; jeder Rest EXPLIZIT benannt". DOK-24 `:1/:33` trägt die
   Zwei-Dimensionen-Korrektur bereits seit dem **29.05.2026** im Titel.
3. **An der Thesis (eingebunden):** `kapitel/de/03_messsystem_prtart.tex:1305-1312` — die drei
   Granularitäten (Mikro/Makro/Gesamt) **plus**, verbatim: „Als Gegenprobe zur internen
   Mikro-Messung misst der Apparat **zusätzlich drei *Wallclock-Ebenen***: die Wallclock der
   Achsen-Interfaces …, die Wallclock der Gattungs-Interface-Funktionen und die Wallclock einer
   Test-Last aus den Last-Rahmenwerken." Das Wort „zusätzlich" trägt die Orthogonalität.
   Bestätigt in `04_implementierung.tex:496-502` („Dieser Registry-Schnitt ist
   Implementierungs-*Stand*, nicht Soll … die Registry zieht diesem Modell nach"),
   `05_evaluation.tex:239-241`, `06_fazit.tex:69-72`.
4. **Am Datensatz:** `measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv`
   trägt in **derselben Zeile** 21 `seg_*`-Spalten (Ebene 1, gefüllt 16/16 außer T17),
   18 `op_*`-Spalten (Ebene 2, gefüllt in den 8 Workload-Zeilen) und `total_ns`/`workload=ycsb_a`
   (Ebene 3) — alle aus derselben `steady_clock`-Quelle.

**Die Matrix** (Soll-Zuordnung per A8 `:242-246`: „WallClock = die 3 CEB-Ebenen · Macro =
Gattungs-/Ende-zu-Ende (Observer + E2/E3) · Micro = Achsen-Interface intern"). Sie ist
**keine volle 3×3** — der Plan besetzt asymmetrisch, der Bau noch schiefer:

| Tooling ↓ / Ebene → | **E1: Achsenaufruf** (in der Tier-Binary) | **E2: Gattungs-Funktionsaufruf** (CEB über Tier) | **E3: large scope** (Last-Sequenz) |
|---|---|---|---|
| **wallclock** | GEBAUT mit Vorbehalt: 18 Segment-Timer `seg_ns[18]` (`anatomy/abi_adapter.hpp:1781 ff.`), aber je Achse **aggregiert** und über **synthetischen Nachlauf** — nicht je realem Aufruf (§3) | GEBAUT + LIVE: je Op ein `clock::now()`-Paar (`builder/workload_driver/workload_orchestrator.hpp:65-164`), aber im **Host-Orchestrator, nicht auf dem Dock** (§3) | TEILWEISE: `total_ns` ist eine **Summe** der Op-Zeiten, kein Verlaufs-Zeitraum; kein äußerer Clock (§3) |
| **macro** (Observer) | GEBAUT: `axis_stats[18][8]` je Achse via `tier_observe` | GEBAUT: Observer-Delta je Checkpoint — Checkpoint-Treiber nur im Testpfad | GEBAUT: Observer-POD am Lauf-Ende (`perm_runner.hpp:225`) |
| **micro** (PMC) | **NICHT GEBAUT** (0 PMC-Aufrufe je Achsen-Segment) | **NICHT GEBAUT** (0 je Gattungs-Op) | **EINZIGE gebaute Zelle**: PMC-Delta-Klammer um die ganze Run-Phase (`perm_runner.hpp:196-197/:314-318`; A8 `:130-133`: „PMC ist heute eine Ebene-3-Klammer, KEINE Micro-/Achsen-Messung") |

**Präzise Formulierung, die trägt:** wallclock ist das **einzige Instrument, das alle drei
Ebenen wirklich belegt** — genau deshalb ist der Owner-Satz keine Redundanz zu macro/micro,
sondern die Rolle „Gegenprobe/Gegenmessung von außen" (`03:1309`, `06_fazit:72`).

**Die VIER Dreien, die auseinanderzuhalten sind** (Verwechslungsschutz, vgl. KLÄRUNG):

| # | Drei | Elemente | Anker |
|---|---|---|---|
| 1 | **Bau-Phasen** der Mess-Achse | Planer (RT) → CEB (CT) → Tier (CT) | LEDGER `:4258` |
| 2 | **Tooling-WERTE** (Auffächerungs-Achse) | `wallclock` / `macro` / `micro` | `measurement_tooling_registry.hpp:46-50` |
| 3 | **Erhebungs-EBENEN** (Orte) | Achsenaufruf / Gattungs-Funktionsaufruf / Last-Sequenz | `03_messsystem_prtart.tex:1310-1312`, A8 `:66` |
| 4 | **Collector-Bausteine** (Quellen-Zuordnung, `binary_id="never"`) | `WallClockSystemAxis` / `ObserverSnapshotSystemAxis` / `PmcSystemAxis` | `include/cache_engine/measurement/measurement_axis_registry.xml:25-41` |

Alle vier führen „Wallclock" — in #2 und #4 an **erster** Stelle, in #3 als Größe **auf allen
drei** Elementen. Kein Dokument darf sie künftig unbenannt mischen.

---

## 3. WALLCLOCK auf drei Ebenen

### Ebene 1 — jeder Achsenaufruf IN der Tier-Binary

- **Plan-Soll:** F2-E1 = Wallclock der Achsen-Interfaces unter jedem Algorithmus, Gegenmessung
  zur internen Micro-Messung (KANON-F2; A8 `:214-217`: E1 reist über die bestehenden
  `seg_ns[18]`-Slots, deren Semantik **umgewidmet** wird — „[E1-Lesart = Owner-OK-pflichtig,
  OF-A8-2]"). Der heutige KERN **ist inhaltlich diese E1-Lesart** und könnte OF-A8-2 schließen —
  **Ableitung, kein Beleg** (der Owner hat OF-A8-2 nicht namentlich adressiert).
- **Ist:** `fill_segment_timing_v3` (`anatomy/abi_adapter.hpp:1781-2035`) — **18 Segment-Timer,
  einer je Achse T0..T17** (`observable_tier.hpp:50`: `kV3AxisCount = 18`), plus äußere Hülle
  `seg_run_total_ns` (`:2016/:2021`) und benannter Rest `seg_framework_ns`
  (`measurable_workload.hpp:104-112`). **LIVE** über `tier_observe` (`:2071-2092`), produktiver
  Aufruf `harness/perm_runner.hpp:225`. Am Datensatz gefüllt (CSV 26.07., 16/16 Zeilen).
- **Lücke gegen den Owner-Wortlaut („jeden Achsenaufruf"):** die Timer klammern eine
  **Schleife** (`:1823-1829`, ein Wert je Achse aggregiert über `n_ops`), und zwar über einen
  **synthetischen Nachlauf** derselben Ops (Kopfkommentar `:1776-1780` sagt es selbst) — nicht
  die Achsenaufrufe der real gemessenen Last. Die reale Gattungs-Funktion `tier_lookup`
  (`:1253-1298`) führt **7 Achsen-/Organ-Aufrufe** aus, **0 davon gemessen**; der gesamte
  Bereich `:1128-1780` ist clock-frei (Gegenprobe: 83 chrono-Treffer datei-weit, Sprung von
  `:1098` auf `:1786`).

### Ebene 2 — jeder Funktionsaufruf durch die CEB AUF dem Prüfdock

- **Plan-Soll:** F2-E2 = Wallclock der Gattungs-Interface-Funktionen; A8 `:222-224`: „heutiges
  `op_lat` … wird explizit Ebene 2". Owner-KERN zusätzlich: **AUF dem Prüfdock** (dazu
  Owner-KERN 06.08. „PMC ins Prüfdock", MEMORY).
- **Ist:** `run_workload_profile` (`builder/workload_driver/workload_orchestrator.hpp:65-164`)
  misst **jeden einzelnen Funktionsaufruf** — 6/6 Op-Arten mit eigenem `clock::now()`-Paar,
  Kopfzeile `:41` verbatim: „Roh-Wall-Clock-ns je Op-Kind (GETRENNT, Doku 24 §2.1)". **LIVE**
  über `perm_runner.hpp:316`.
- **Lücke:** das läuft im **Host-Orchestrator**, nicht auf dem Dock. Das Prüfdock
  (`builder/pruef_dock/`, 17 Dateien, 3161 Zeilen) enthält **0 Zeilen Zeitcode** (2
  Wort-Treffer „Wall-Clock" in Kommentar/Prüftext, `mess_interface_testate.hpp:346/:386`);
  `IPruefDock::measure()` hat **0 Produktionsaufrufer** (12 `.measure(`-Treffer, alle in
  `tests/unit/`) — der Produktionspfad umfährt es über `acquire_search_algorithm_drive`
  (`cache_engine_builder_iterator.hpp:2394-2395`) und `run_conformance_gate`. Das Dock ist
  heute Gate + Testat, nicht Messfühler.

### Ebene 3 — large scope über eine gemessene Last-Sequenz

- **Plan-Soll:** F2-E3 = Wallclock einer Test-Last aus den Last-Rahmenwerken; A8 `:223-224`:
  „äussere Klammer um den Profil-Lauf (heutiges `total_ns`-Analog); die PMC-Klammer bleibt hier
  verankert". Owner-KERN: „Verlauf mehrerer Funktionsaufrufe … Last-Profile".
- **Ist:** Lastprofile als Konzept existieren (`MeasurementPlan`,
  `workload_orchestrator.hpp:170-174`; XML-`<workloads>` autoritativ,
  `profile_run_facade.cpp:577-589`).
- **Lücke:** `total_ns` ist eine **Summe** der Op-Zeiten (`workload_orchestrator.hpp:45`,
  `perm_runner.hpp:321-332`), **kein** Verlaufs-Zeitraum; `run_workload_profile` und
  `run_measurement_plan` haben **0 äußere `clock::now()`** (12 Aufrufe, alle 12 innerhalb einer
  Op); `total_ns` steht **nicht in der CSV** (Serializer `:233-261` schreibt nur p50/p95/p99).
  Die Zeit ZWISCHEN den Funktionsaufrufen ist unsichtbar — derselbe Defekt, den Pfad B mit
  `seg_run_total_ns`/`seg_framework_ns` auf Ebene 1 geheilt hat, fehlt hier. **Der fertige
  Verlaufs-Treiber existiert** — `drive_two_phase_tier_trace_abi`
  (`builder/anatomy_commands/tier_observe_trace_abi.hpp:131/:180`: `trace_start` +
  `observe_wall_ns` als Wall-Clock-Korrelations-Achse) — hängt aber am toten Dock-Pfad (nur
  Tests). Die äußere Klammer aus `run_observable_perm` (`perm_runner.hpp:203-216`) gilt nur
  für den Legacy-Fix-Workload, nicht für Lastprofile.

---

## 4. Die Mess-Achse als DREIPHASIGE Kette — für Wallclock konkret

Etablierter Ledger-Gebrauch (LEDGER `:4258`): Mess startet ein Glied früher — **Planer (RT) →
CEB (CT) → Tier (CT)**. Für Wallclock heißt das konkret:

| Phase | Wer | Was für Wallclock reist | Ist-Stand `development` | Ist-Stand M-1 (ungelandet) |
|---|---|---|---|---|
| **1** | **Planer (RT)** | die Tooling-Wahl als **Menge**: `PlanMeasurementCombo{ tooling, …, legend }`, Fan-out über `measurement_combos_of` (leer ⇒ `[all]`); XML `<combo tools="wallclock macro micro"/>` (`m3v2_study.profile.xml:185`) | GEBAUT (`planner/experiment_plan_director.hpp:102-107, :2039-2057`) — aber einziger funktionaler Effekt ist **Lane-Scheduling**, nicht Instrumentierung (`:600-602`: „macro → intel (prod2), wallclock/micro/[all] → amd (prod1)") | unverändert |
| **2** | **CEB (CT)** | die Stempel-Zeile `measurement_tooling=<ids>@X.Y.Z` (`abi/anatomy_version_stamp.hpp:216/:239/:264`) + die Compile-Defines für die Tier-Binary | **BRUCHSTELLE:** `perm_mess_defines()` setzt **hart** 4 Literale (`profile_run_facade.cpp:273-275`), kein Bezug zur Wahl; `kCebFingerprint` renderte das **ANGEBOT** statt der WAHL (Injektivitäts-Verletzung, ein Schlüssel für vier Ausstattungen) | GEHEILT: `live_mess_achsen_defines()` (`:299-302`, D-1 `b9fd81ff`), Fingerprint rendert die WAHL (D-4 `62a5b6f7`, 7 Teilmengen/21 Paare/0 Kollisionen) — **aber mit der in §8 benannten Zuordnungs-Regression** |
| **3** | **Tier (CT→RT)** | die **einkompilierten Zeitnehmer** (Ebene 1: `seg_ns[18]`; Ebene 2 wird CEB-seitig genommen) + die ABI-PODs (`ComdareSegmentLatencyV2`, `WorkloadRunResult`) + die Selbst-Deklaration `measurement_line`/`measurement_entries` (`abi/anatomy_module_abi_v1_decl.hpp:193-194/:221-222`) | Timer GEBAUT; die Deklaration hat **0 produktive Leser** (9+5 Treffer, alle ABI-Decl + Tests; Gegenprobe: `organ_`/`system_`-Zwillinge haben 2 produktive Leser — das Verfahren sieht) | Erster Leser GEBAUT: `mess_konsistenz_gate.hpp` (+359 Z., byte-gleicher Vergleich, 6 fail-closed-Klassen, D-2 `246b2793`) |

Dazu M-1/H (`8f70898a`): H-1 wallclock-Deklarationspflicht (gemessen: Objektänderung ohne
`tier_fp`-Änderung → `dll_is_current` log über eine Mess-Code-Versionsgrenze), H-2
PMC-Ausstattungs-Invariante (`micro ↔ COMDARE_ENABLE_PMC`, fail-loud), H-B `n/a` statt `0` in
13 Observer-Zellen.

**Merksatz bestätigt und präzisiert:** Planer FRAGT (heute: wählt nur die Lane), CEB TRÄGT
(heute: trägt hart, M-1 macht es wahlgetreu), Tier LÄUFT (heute: läuft immer voll
instrumentiert, weil `COMDARE_MEASUREMENT_ON` immer 1 ist).

---

## 5. DIE VOLLSTÄNDIGE MESS-KETTE — alle zwölf KERNe an ihrem Platz

Die Kette von der Instrumentierung bis zur Binary-Wahl, je Glied mit dem Detail-Dokument:

```
 Planer (RT) ──baut──▶ CEB (CT) ──läuft (RT)──▶ baut Tier (CT) ──[Hybrid: 4. Glied]──▶ Tier läuft
     │                    │                          │                                     │
  KERN 1,2,5           KERN 4,5,6,7,8             KERN 2,3,9                          KERN 1,10
     │                    │                          │                                     │
     └──── Messwerte (3 Ebenen × 3 Toolings, §2) ────┴──── Funktions-Synthese ──▶ Schnitt-Kurven
                                                                 │                        │
                                                              KERN 11,12            BREAK EVEN ──▶ Binary-Wahl
```

| KERN | Inhalt (Kurzform) | Platz in der Kette | Detail-Dokument |
|---|---|---|---|
| 1 | Die Schlange: Kopf ist RT, kontrolliert CT des nächsten Glieds | Gesamtstruktur | KLÄRUNG; LEDGER abend-4 §0/§1 |
| 2 | Drei Typen: Mess DREIPHASIG, System/Organ ZWEIPHASIG | Phasen-Regel je Achsen-Art | KLÄRUNG; LEDGER `:4258` |
| 3 | PMC = MENGE je Maschine, P-/E-Core getrennt (Intel effektiv 2 PMC) | Tier-Messfühler | PLAN-HYBRID; `20260806-PLAN-p-pmc-1-messkette.md` |
| 4 | EINE CEB, beide Messfühler, DIESELBE Binary zweimal gepinnt = Permutation, kein zweiter Bau | CEB-Fahrplan | PLAN-HYBRID |
| 5 | Planer FRAGT (Pinning-Fähigkeit RT), CEB TRÄGT (OS-Routinen CT), Tier LÄUFT | Phasen-Zuständigkeit | PLAN-HYBRID; §4 hier |
| 6 | `warn: no pinned locality on hybrid architecture` (wörtlich) | CEB-Laufzeit-Ausgabe | PLAN-WARN |
| 7 | Schwere-Leiter warn / error / fatal | Fehlerklassen-Achse | PLAN-WARN |
| 8 | Stiller Rückfall verboten | Querschnitt | PLAN-WARN; neuer Fall in §6 (thread_pinning) |
| 9 | fehlende Unter-Achse `numa_cpu_pin_process_probe` (strukturgleich `numa_page_probe`) | System-Registry | PLAN-HYBRID |
| 10 | Hybrid-Binary = Schaltungs-Adapter, multiple optimale Binaries je Last-Kanal | 4. Ketten-Glied | ce `libs/cache_engine/hybrid/README.md`; PLAN-BREAK |
| 11 | Auswertungs-Kette: Messwerte → Funktions-Synthese → Schnitt-Kurven → optimale Konfiguration ≙ zu wählende Binary | Auswertung | PLAN-BREAK |
| 12 | BREAK EVEN über Micro / Macro-timed (Checkpoints) / Macro-large-scope (Lastprofil) | Auswertung ← §2-Matrix | PLAN-BREAK; A8 |

**Wallclock als „drittes Glied" — die Einordnung, dreifach am Objekt belegt:** das Wort „Glied"
hat im Bestand die harte Bedeutung Fingerprint-Preimage/Stempel-Zeile, und dort ist die
**Mess-Zeile das dritte Glied [3]** nach Format-Kennung [0], Organ-Zeile [1], System-Zeile [2]:
(a) Preimage-Ordnung `abi/anatomy_fingerprint.hpp:428-431` (`kAnatomyFingerprintGliedCount = 8`,
`:341`; LEDGER `:4722` führt „Glied [3] von 8"), (b) ABI-POD-Reihenfolge
`anatomy_module_abi_v1_decl.hpp:180-192` (Mess-Zeile „APPEND-ONLY ans POD-Ende" als dritte),
(c) Stempel-Zeilen `anatomy_version_stamp.hpp` (organ `:82` → system `:144` → measurement
`:216`). **Wallclock ist der Wert, der in diesem dritten Glied reist.** In der
Tooling-Registry selbst steht WallClock dagegen an **erster** Stelle (Index 0,
`static_assert`-verriegelt `:93`) — die Registry-Ordnung ist NICHT die Glieder-Ordnung und
**darf nicht angefasst werden** (jede Umordnung bricht Stempel und golden-Fingerprints).
**Ehrliche Einschränkung:** die Gleichsetzung „drittes Glied = Glied [3]" ist eine
Rekonstruktion aus drei unabhängigen Objektbefunden, **keine zitierbare Textstelle** (Nenner:
„drittes glied" über plaene/LEDGER/termine = 11 Treffer, keiner zur Mess-Achse; Gegenprobe
`dreiphasig` = 30+ Treffer — die Suche sieht). Alternativ-Lesart s. §8.

**„lebt per Planung und Definition in der Mess-Achse" — belegt:** Owner-Direktive §47
(LEDGER `:2498`, 20.07.: Mess-Tooling als Haupt-Achse, „ob CEB nur wallclock time, geplante
makro-benchmarks oder micro-benchmarks über die observer misst") und Termin 6 Scope-Freeze
16.04. (TERMIN-6 `:55`: „wall time" als Pflichtmetrik neben den PMC-Zählern;
`Begriffsglossar_v4_FINAL.txt:418`: `walltime_ns` als erste Messwert-Spalte des DB-Schemas;
`Domaenenmodell_PRT_ART_v3.txt:207-217`: Mess-Achse als Achse 10 mit Latency/Throughput —
genau die zwei Kategorien der `WallClockSystemAxis`).

---

## 6. DER IST-STAND

### 6.1 Je Ketten-Glied

| Glied | Verdikt | Beleg + Nenner (Stand 06.08. spätabends, ce `2b5ecd29` sofern nicht anders) |
|---|---|---|
| Planer-Freigabe Mess-Combo | **GEBAUT, wirkt nur als Scheduling** | `experiment_plan_director.hpp:102-107/:600-602/:2020-2022` („HEUTE reicht `construct()` `{}` => 1 Voll-Konfig `[all]`") |
| CEB-Einbau der Wahl | **BRUCHSTELLE / in M-1 geheilt, ungelandet** | §4 Phase 2; Zensus `MeasurementTooling::` development = **3 Treffer, alle in der Registry-Tabelle selbst** (Nenner-Gegenprobe: 155 Treffer case-insensitiv) — **0 funktionale Konsumenten** (D-1, LEDGER `:4727`, heute nachgemessen); im M-1-Zweig = 8 |
| Tier: Ebene-1-Timer | **GEBAUT + LIVE, aber aggregiert + synthetisch** | §3 Ebene 1 |
| Tier: Selbst-Deklaration | **GEBAUT, 0 Leser / Leser in M-1** | §4 Phase 3 |
| CEB: Ebene-2-Timer | **GEBAUT + LIVE, nicht auf dem Dock** | §3 Ebene 2 |
| Ebene-3-Verlaufs-Clock | **FEHLT** (Treiber existiert am toten Pfad) | §3 Ebene 3 |
| Prüfdock als Messort | **GEBAUT, produktiv umfahren** | `pruef_dock.hpp:74-79` (Vertrag); 0 Prod-Aufrufer von `measure()`/`measure_genus_sequential` |
| PMC-Menge P-/E-Core (KERN 3) | **FEHLT** | `platform/i_platform_probe.hpp:20` deklariert `cpu_core_atom_perf_separation=false`; `cpuid_platform_probe.hpp:38-39` verbatim: „Topologie/Pinning bleibt bewusst ungesetzt"; `cpu_atom` in `libs/` = **0** (Nenner: `perf_event_open` = 16 Treffer) |
| Pinning-Permutation (KERN 4/5) | **FEHLT** (OS-Routinen CT vorhanden) | `builder/measurement/thread_pinning.hpp:41-66` (Win/Linux getrennt) ✔; kein Doppelstart, `ScopedThreadPin` in `perm_runner.hpp` = 0; Planer-Abfrage fehlt |
| warn-Text (KERN 6) | **NICHT GEFUNDEN** | „no pinned locality" = 0 Treffer; Nenner: 4 Affinitäts-Aufrufe; Gegenprobe: `sched_setaffinity` = 2 Treffer — die Suche sieht |
| Schwere-Leiter (KERN 7) | **FEHLT als Typ** | `measurement/axis_error.hpp`: 8 Enums (Zell-/Domänen-Zustände), `fatal|warn` darauf = 0; einziger Warnkanal `validate_profile.hpp:92` (lokal, stufenlos); 1 FATAL-String-Literal `profile_run_facade.cpp:1027` |
| Stiller Rückfall (KERN 8) | **TEILWEISE + 1 neuer Fall** | `thread_pinning.hpp:61`: `sched_setaffinity`-Fehlschlag → `return;` ohne Log/Status, Aufrufer misst ungepinnt weiter; Heilungen gelandet: `22e17f57` (errno), `2b5ecd29` (Smoke misst echtes Fenster) |
| `numa_cpu_pin_process_probe` (KERN 9) | **FEHLT** | 0 Treffer; Nenner: 11 `sub_axis`-IDs in `system_axis_registry.xml`, keine mit „core"; Gegenprobe: `numa_page_probe` = 67 Treffer (selbst gebaut, aber 0 Produktions-Konsumenten) |
| Hybrid-Stufe (KERN 10) | **RESERVIERT, 0 Code** | ce `libs/cache_engine/hybrid/` = genau 1 README („KEIN CODE … KEIN Build-Anschluss"), 9 Dateien tabelliert, Bau lt. README in der Auswertungsphase |
| Auswertungs-Kette (KERN 11/12) | **BIBLIOTHEK GEBAUT, 0 Treiber** | `heuristik/` (`measurement_curve_loader`, `axis_spline`, `break_even.hpp:43/:74`) + `best_binary_selector` (`HybridBinarySelector :352-370`, `find_break_evens :345`) — CLI ruft **nur** `rank_binaries` (`_main.cpp:100`); Rückführung `selection_filter_chain.hpp:118-121` = „DEFERRED (#156)"; `heuristik/`-Konsumenten: nur Tests. **Einschränkung:** `break_even.hpp:3` schneidet Splines **derselben** Organ-Achse; Kreuz-Achsen- und Genus-Interface-Schnitte (KERN 11 (a)/(b)) haben 0 Code |
| PMC-Pflicht-Invariante | **GELANDET** | `8894d983` (M-2/P-PMC-1): `ceb_pmc_compile_define()` als Single-Source, Wache über beide Builder/vier Kanäle, vom Nenner aus gezählt; überholt PLAN-KETTE I-5 (s. §8) |

### 6.2 Die heute gebauten, ungelandeten Pakete

**`b-m1-identitaetsnaht`** (`4fdedbbf`, 7 Commits, 24 Dateien +3114/−149, Arbeitsbaum sauber;
Korrektur: der Auftragskopf nannte 36 Dateien/+3671 — überholter Zwischenstand):
D-1 Mess-Achse bekommt Wirkung (`mess_achsen_naht.hpp`, +562 Z.) · D-4 Fingerprint rendert die
WAHL + ODR-Wache · D-2 erster Leser der Tier-Deklaration (`mess_konsistenz_gate.hpp`) · H
Stufen-Wache/Deklarationspflicht/PMC-Invariante/`n/a`-Zellen · clang-format-Pass. Laut
Commit-Text Voll-Bau 0 Fehler, **ctest 418/418** [aus Commit-Nachricht, nicht selbst gebaut —
READ-ONLY]. **Trägt die in §8.1 benannte Zuordnungs-Regression — Landeentscheid nötig.**

**`b-pmc-l3-honest`** (0 Commits, WIP 5 Dateien +136/−13): B-5 inhaltlich fertig —
Pro-Zähler-Verfügbarkeits-Flags (`pmc_source.hpp:28-43`), CSV `n/a` statt erfundener 0 für
l2/l3/coherence/energy (`SampleStatus::SourceUnavailable`), Öffnungs- vs. Lese-Semantik
getrennt (`linux_perf_pmc_source.hpp:276-281`), Rücknahme der Falschaussage
„branch_misses real erhoben". **Nicht committet, nicht testbelegt, nicht gelandet.** Die
AMD-Zen5-ENOENT-Verifikation steht nur als WIP-Kommentar — **UNBELEGT** ohne Log im Baum.

---

## 7. WAS FEHLT — nach Dringlichkeit

**A. VOR der Messung (sonst Datenbruch oder falsche Identität):**

| # | Posten | Klasse | Kosten | Beleg |
|---|---|---|---|---|
| A-1 | **M-1-Zuordnungs-Regression entscheiden und beheben, DANN landen** (§8.1): `wallclock → nur G1` nimmt einer `[wallclock]`-Binary die 18 Ebene-1-Timer — gemessen `observable_axes=0` | TIER (Mess-Achse ⇒ CEB+Binaries neu, Owner-KERN 06.08.) | klein (Zuordnungstabelle in `mess_achsen_naht.hpp:77-82`) + Re-Verifikation | §8.1 |
| A-2 | **`b-pmc-l3-honest` committen, testen, landen** — sonst erfindet die Voll-Messung Nullen für l3/energy auf AMD | CEB-ONLY + Schema (`n/a`-Semantik) | klein (WIP fertig, fehlt Commit+Biss-Nachweis) | §6.2 |
| A-3 | **T17 `seg_persistence_target_ns`** — 0 in 16/16 Zeilen der Alt-CSV (A8 B-6, drei `<17`-Schleifen bei `kV3AxisCount==18`); Code-Fix teilweise da (`abi_adapter.hpp:1102-1109`), Nachweis am NEUEN Messlauf fehlt | TIER | klein | Erhebung `zwei-dimensionen` K-1 |
| A-4 | **Ebene-3-Verlaufs-Clock**: äußere Klammer um `run_workload_profile`/`run_measurement_plan` + `total_ns` (und Verlaufs-Zeitraum) in die CSV | TIER + Schema | klein–mittel (Bautyp existiert: `seg_run_total_ns`-Muster) | §3 Ebene 3 |
| A-5 | **Schema-Entscheid Ebene×Wert**: heute `walltime_ns` einspaltig (Termin-Schema); drei Ebenen brauchen drei Spaltengruppen oder eine Ebenen-Dimension — dieselbe Klasse wie B-3 („getrennte Ablage je PMU-Domäne, VOR der Messung, sonst Datenbruch", LEDGER abend-4) | Schema | mittel (Entscheid + Serializer) | Erhebung `messachse-drittes-glied` §10 |
| A-6 | **Stiller-Rückfall-Fix `thread_pinning.hpp:61`** (KERN 8: Fehlschlag ohne Anzeige) + warn-Text KERN 6 wörtlich | CEB-ONLY | klein | §6.1; PLAN-WARN |
| A-7 | **Schwere-Leiter warn/error/fatal als Typ** (KERN 7) — Voraussetzung für A-6 und für ehrliche Messfehler-Ausgabe | CEB-ONLY | mittel | PLAN-WARN |
| A-8 | **PMC-Menge P-/E-Core + `numa_cpu_pin_process_probe` + Pinning-Permutation** (KERNe 3/4/5/9) — Voraussetzung jeder Hybrid-Messung; auf reinen AMD-Hosts nicht blockierend für die erste Voll-Messung | CEB-ONLY (Probe/Registry) + Planer | groß | PLAN-HYBRID |

**B. NACH der Messung / Auswertungsphase:**

| # | Posten | Klasse | Beleg |
|---|---|---|---|
| B-a | Hybrid-Stufe bauen (KERN 10; 9 Dateien lt. README, „Auswertungsphase") | TIER (4. Glied) | `hybrid/README.md` |
| B-b | Break-Even-Treiber anschließen: CLI → `HybridBinarySelector`/`break_even_table`; Rückführung Auswertung→Generierung (DEFERRED #156); Kreuz-Achsen- und Genus-Interface-Schnitte (KERN 11) | Auswertung | §6.1; PLAN-BREAK |
| B-c | Checkpoint-Instrumentierung für Macro-timed im Produktionspfad (LEDGER abend-4 §12, B-8: „nach Abgabe") | TIER | Erhebung `zwei-dimensionen` Teil 5 |
| B-d | Ebenen-Benennung im Code (kein `enum` trägt E1/E2/E3 — A8 B-7 „Ebenen unbenannt") | CEB-ONLY | A8 `:169-171` |
| B-e | Prüfdock als Messort scharf schalten (Ebene 2 „AUF dem Dock", PMC ins Prüfdock) — der fertige Treiber `drive_two_phase_tier_trace_abi` wird dabei produktiv | CEB-ONLY | §3 Ebene 2/3 |

---

## 8. Die Widersprüche und offenen Fragen

### 8.1 Die M-1-Regression (WICHTIGSTER PUNKT — vor der Landung entscheiden)

`mess_achsen_naht.hpp:48-55/:77-82` (ungelandet) ordnet zu: „`wallclock` : braucht G1 …
`micro` : braucht G1+G2+G3" — d.h. eine `[wallclock]`-Binary trägt `MEASUREMENT_ON` **ohne**
`CE_ENABLE_STATISTICS` und **verliert alle 18 Ebene-1-Achsen-Timer**. In der Serie selbst
gemessen (`8f70898a`, H-B): `[all] observable_axes=9` vs. `[wallclock] observable_axes=0`.
**Das widerspricht dem Owner-KERN direkt** (Wallclock auf ALLEN drei Ebenen). M-1 nennt seine
Grenze ehrlich („Ein solches Gate hier zu ERFINDEN hiesse, Semantik zu behaupten, die der Code
nicht traegt", `:85-88`) — aber die Zuordnung wallclock→nur-G1 ist genau so eine Behauptung,
und sie ist jetzt widerlegt. **Empfehlung:** Zuordnung neu schneiden — die drei
Wallclock-Ebenen-Timer gehören in JEDE Tooling-Wahl, die `wallclock` enthält (per A8 `:242`:
„WallClock = die 3 CEB-Ebenen"); die Gates trennen dann Observer-Statistik (macro) und PMC
(micro), nicht die Wallclock-Orte. Owner-Entscheid, dann landen.

### 8.2 Thesis-interner Widerspruch (eine Zeile)

`03_messsystem_prtart.tex:992` („das *Mess-Tooling* spannt die drei Granularitäten des
Benchmarkings auf") setzt (A)≡(B) und widerspricht `03:1309-1312` + `04:499-502` derselben
Arbeit. **Ein-Satz-Fix, vor der Abgabe.** Der Rest der Arbeit ist konsistent.

### 8.3 „drittes Glied" — Lesarten (Owner-Entscheid)

Objektiv belegbar ist nur: Mess-Zeile = Glied [3] des Preimage/Stempels (§5). Alternativ
plausibel: (i) drittes Glied der Kette Planer→CEB→Tier (der Anschluss-Halbsatz „…in die CEB
und damit DREIPHASIG…" spricht dafür), (ii) dritter Messfühler in der Klärungs-Reihenfolge
dieses Abends (PMC → Observer/Dock → Wallclock) — **kein Dokument** dahinter. In **beiden**
Registries (Tooling, Collector) steht Wallclock an **erster** Stelle. **Empfehlung:**
Registry-Ordnung nicht anfassen (§5); die „Drittheit" ans Stempel-Glied [3] binden; die vier
Dreien (§2) als Glossar-Zeile in den LEDGER.

### 8.4 „DREIPHASIG" — zwei Dreien in einem Satz

Etablierter Gebrauch = Bau-Kette (LEDGER `:4258`). Der Owner-Satz nennt unmittelbar davor die
drei **Ebenen**. Lesart hier: *wallclock wird über die dreiphasige Kette eingebaut UND auf
drei Ebenen erhoben* — zwei verschiedene Dreien. Im LEDGER explizit auseinanderhalten, sonst
entsteht dieselbe Konfusion ein zweites Mal.

### 8.5 Registry-Doku-Drift

`measurement_tooling_registry.hpp:30` definiert Micro als PMC — F2-widrig (A8 B-1: „Micro ohne
Traeger"). Die Thesis (`04:496-502`) erklärt den Registry-Schnitt bereits zu
Implementierungs-Stand. Kommentare deprecaten/nachziehen, ids/Token **byte-stabil** lassen
(A8 `:242-246`). Kosmetisch, aber dieselbe Falle wie §1: `static_assert`-Texte sagen
„17-Segment" bei `seg_ns[18]` (`measurable_workload.hpp:118/:120`), Decl `:38` sagt noch
`seg_ns[17]`.

### 8.6 Begriffs-Falle Termine

Die Termin-Dokumente kennen die Größe als **`wall time` / `walltime_ns`**, nie als „Wallclock"
(Nenner: 309 Dateien, `wallclock` = 2 Treffer, beide in zitierten Fremd-Papers; Gegenprobe
`wall` = 18 Dateien mit den drei tragenden Treffern). Wer nach „wallclock" sucht, meldet eine
falsche Null. **Fallen-Meldung fürs Register.**

### 8.7 Welche heutigen Erhebungen durch diesen KERN (und die Nachmessungen) ÜBERHOLT sind

| Überholt | Was falsch/eng war | Gültiger Stand |
|---|---|---|
| **M-1-Wellen-Lesart „G1/G2/G3"** | Tooling-Kommentare als Ebenen-Definition gelesen; „`IMeasurableWorkload` = EIN äußerer steady_clock je Batch" ist am Objekt falsch (`abi_adapter.hpp:641`: „4 statt 1 now()-Paar je Batch") | §2/§3 dieses Dossiers; existierte in keinem Plandokument (Nenner: 0 Treffer „G1/Basis-Zeit/Feinkorn" in `docs/plaene/`), ist aber in laufende Aufträge eingegangen → M-1-Landung nach §8.1 |
| **DIFF `[§63-T-15]`** (`:439-444`, `:566`) | „`seg_*` … ungefüllt" — falscher Anker (Pfad A statt Pfad B) + am Datensatz widerlegt (16/16 gefüllt) + `A_measurements.tex:148-149` falsch gelesen (fehlender Generator-Schritt, nicht fehlende Werte) | Stehen bleibt nur: `seg_persistence_target_ns` = 0/16 (T17, → A-3) |
| **PLAN-KETTE I-5** („PMC-Flag: 0 von 4") | An `b241a272` erhoben, seither geheilt | `8894d983` gelandet: Pflicht-Invariante vom Nenner aus, Biss geführt |
| **D-1-Formulierung** („Glied [3] deklariert eine Ausstattung, die der Bau ignoriert") | Bleibt richtig **für (A)** — darf nicht auf (B) übertragen werden, sonst behauptet man, es werde gar nicht mehrschichtig gemessen (CSV-Beleg §2) | Präzisierung: (A) hat 0 Konsumenten, (B) läuft live |
| **Auftragskopf-Zahlen** (M-1 „36 Dateien +3671"; pmc-l3-honest „Commits") | Zwischenstände | 24 Dateien +3114/−149; 0 Commits, nur WIP |
| **LEDGER abend-4 §11** („In Klaerung.") | Frage, ob Thesis-Granularitäten = Tooling-Werte | Geklärt: NEIN — die Granularitäten sind die Ebenen (B), belegt `01:212-214`, `03:1300-1308`, `05:236-241`; die Thesis-Zusage steht und fällt NICHT mit D-1 |

### 8.8 Wo der Plan schweigt (Owner-Entscheid nötig)

- **OF-A8-2** (E1-Umwidmung der `seg_ns`-Semantik auf „echte Achsenaufrufe der realen Last")
  — der heutige KERN ist inhaltlich diese Lesart, hat sie aber nicht namentlich adressiert.
- Ob die drei Erhebungs-Ebenen **eigene Registry-Bausteine** der Mess-Achse werden (heute
  Code-Orte ohne Achsen-Repräsentation; LEDGER `:4632-4634` B-7/B-8, „nach Abgabe").
- **O-PMC-1** (B4 `allow_failure`) — bewusst nicht in `8894d983` enthalten.
- Ebene 2 „AUF dem Prüfdock": ob der Host-Orchestrator-Messpunkt dorthin **wandert** oder das
  Dock den bestehenden Messpunkt **testiert** (heutiger Vertrag `pruef_dock.hpp:74-79` erlaubt
  beides zu lesen).

---

## 9. Die sechs Freitage

Endtermin **15.09.2026**, wöchentliche Lieferung freitags (Owner-KERN 06.08. abends).
Kalender-Anker nach Frist-Historie (Trigger **Do 07.08.**, Abgabe **Fr 08.08.**) → die sechs
Freitage sind **08.08. · 15.08. · 22.08. · 29.08. · 05.09. · 12.09.** Zuteilung = **Vorschlag**
(Owner-Zuteilung offen); Reihenfolge folgt strikt §7 (erst Datenbruch-Posten, dann Messung,
dann Auswertung):

| Freitag | Lieferung |
|---|---|
| **F1 — 08.08.** (Abgabe-Freitag, bewusst schmal) | Thesis-Ein-Satz-Fix `03:992` (§8.2) **vor Abgabe**; A-2 `b-pmc-l3-honest` committen+landen; Owner-Entscheid zu §8.1 einholen (Vorlage: dieses Dossier) |
| **F2 — 15.08.** | A-1: M-1-Zuordnung korrigieren, Re-Verifikation (Biss: `[wallclock]`-Binary muss `observable_axes>0`/`seg_ns` tragen), **landen**; A-3 T17-Nachweis am frischen Lauf |
| **F3 — 22.08.** | A-4 Ebene-3-Verlaufs-Clock + CSV; A-5 Schema-Entscheid Ebene×Wert dokumentieren und Serializer ziehen; A-6 thread_pinning-Fix + warn-Text |
| **F4 — 29.08.** | A-7 Schwere-Leiter als Typ (PLAN-WARN); A-8 Teil 1: `numa_cpu_pin_process_probe` + Planer-Pinning-Abfrage (KERN 5/9) |
| **F5 — 05.09.** | A-8 Teil 2: PMC-Menge P-/E-Core + Permutations-Doppelstart (KERNe 3/4, PLAN-HYBRID); ObservableTier-Audit (Owner-KERN 06.08.) |
| **F6 — 12.09.** | Voll-Messlauf mit neuem Schema (GOLDEN-UPDATE-Fenster-Regeln beachten); erster Auswertungs-Treiber-Lauf `best_binary_selector` → `break_even_table` (B-b angerissen); Puffer + Übergabe zum 15.09. |

Nach dem 15.09. (Auswertungsphase, per README/LEDGER): B-a Hybrid-Stufe, B-b vollständige
Break-Even-Verdrahtung inkl. Kreuz-Achsen/Genus-Schnitte, B-c Checkpoint-Instrumentierung,
B-d Ebenen-Benennung, B-e Dock als Messort.

---

*Konsolidiert aus den vier Erhebungen vom 06.08. abends und den in der Kopftabelle gelisteten
Dokumenten. Alle „NICHT GEFUNDEN"-Aussagen tragen Nenner und Gegenprobe in den jeweils
zitierten Erhebungs-Abschnitten. Als UNBELEGT markiert bleiben: ctest 418/418 und 409/409 (nur
Commit-Nachrichten), Voll-Bau ~34,4 h ([BERICHT], PLAN-KETTE `:664`), AMD-Zen5-ENOENT
(WIP-Kommentar ohne Log), die Gleichsetzung „drittes Glied" = Stempel-Glied [3]
(Rekonstruktion, §5/§8.3) und die Schließung von OF-A8-2 (Ableitung, §8.8).
READ-ONLY eingehalten bis auf dieses eine, beauftragte Dokument; kein Commit.*
