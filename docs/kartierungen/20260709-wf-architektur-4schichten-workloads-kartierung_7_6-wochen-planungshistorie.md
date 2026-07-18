I now have complete coverage across the ledger, sessions, and both architecture docs. Here is the reconstructed planning history.

---

# Anforderungs-Evolution: „Workloads (runtime) + Achsen-Algorithmen (compile-time)" & #31 (F7)

**Zeitfenster & Quellen.** Der §12-Chronik-Teil des Ledgers beginnt 2026-07-03 (Ledger selbst am 03.07. erstellt); die Vorgeschichte liegt in `docs/sessions/` (ab 2026-05-14 / V8). Die *autoritative* compile-time/runtime-Definition steht in den ce-Architektur-Docs 24 (29./30.05.) und 26 (02.06.). Alle Pfade unten absolut ab `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/`.

Kürzel: **LEDGER** = `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`; **Doc15** = `docs/architektur/15_F7_mess_frameworks_workloads_2d_matrix_plan.md`; **Doc37** = `Code/external/comdare-cache-engine/docs/architecture/37_ap15_container_typen_sequence_plan.md`; **Doc26/Doc24** = `Code/external/comdare-cache-engine/docs/architecture/{26_permutations_bplus_baum_und_inverse_signatur,24_messmodell_korrektur_zwei_dimensionen}.md`.

---

## 1. Evolution des compile-time/runtime-Splits (chronologisch, mit Beleg-Zeilen)

**(a) 2026-05-22 — Compiler wird die 15. Achse (compile-time in die Binary gebacken).** `docs/sessions/20260522-5300-V35-sprint-pipeline-restructure-compiler-axis.md:64-97`: Compiler-Family/Opt-Level/LTO/PGO/Target-Arch als Achse 15 (28→33 Achsen-Einträge). Damit ist erstmals eine *reine Build-Eigenschaft* als Achse modelliert — der Keim der „alles Baubare = Achse = compile-time"-Linie.

**(b) 2026-05-29/30 — das „HYBRID-Mess-Modell" (User-Klarstellung), Pfad A vs. B.** Doc24:300-334 (`§8`, „**Es ist ein Hybrid-Modell**", User 2026-05-30): Pfad A = isolierte Achsen-Algorithmen messen sich in der DLL selbst (`IMeasurableWorkload::run_workload`), Pfad B = Composite-Lebewesen wird vom Host getrieben + dessen Observer über die ABI gelesen. **Wichtige Abgrenzung:** dieser „Hybrid" ist NICHT der spätere #31-Hybrid — hier geht es um zwei *Mess-Pfade*, nicht um compile-time/runtime der Workload-Achse. (Der Ledger vermischt beide bei :296 leicht.)

**(c) 2026-06-02 — die harte Definition: die Knotenart IST der compile-time/runtime-Schnitt.** Das ist der Kern-Beleg. Doc26:158-162:
> „**Die Knotenart IST die compile-time/runtime-Unterscheidung** (kein separates Flag): `StaticAxisNode` = compile-time → lädt eine Binary; `DynamicVariableNode` = Laufzeit-FOR-SCHLEIFE auf der geladenen Binary über die Variablen-Schnittstelle. Compile-time-variierende Eigenschaften … sind daher **StaticAxisNodes** (sie erzeugen Binaries); nur echt laufzeit-einstellbare Größen (**thread_count, hw_prefetcher**) sind `DynamicVariableNodes`."

Und die Ausführungssemantik (User 2026-06-02), Doc26:66-73:
> „STATISCHE Knoten = je distinkter Static-Pfad lädt EINE NEUE Lebewesen-Binary (compile-time-Identität …). DYNAMISCHE Knoten = eine FOR-SCHLEIFE auf EINER bereits geladenen Binary … über die Variablen-Schnittstelle (`Algorithm_Resource_Control`, KF-4) … erzeugt KEINE neue Binary. → Blatt = EIN Mess-Lauf (Binary × Laufzeit-Einstellung)."

Das Goal V6 vom selben Tag zementiert die Skalierungs-Trennung `static_filter()/dynamic_filter()`: statische Binaries werden (auf dem Cluster) gebaut, je Binary werden ALLE dynamischen Rekombinationen ausgeführt (`docs/sessions/20260602 goal-v6-permutations-baum.txt:9`).

**(d) 2026-07-01 — konsolidiert im Ledger (W1).** LEDGER:482-484: „die compile/runtime-Trennung ist die Knotenart selbst … **Der Runtime-Kanal ist strukturell auf die 5 `ComdareResourceControlV1`-Felder begrenzt** … runtime variierbar ist nur das Pool-**BUDGET** (`pool_budget_bytes`), nie die Pool-**STRUKTUR** … **Node-Shape/Allokator/Layout permutieren als COMPILE-TIME-Baum-Ebenen**." Ferner LEDGER:465 (C1): Antwort auf die Threading-Frage = „der **B+-Experiment-Baum mit compile-time- UND runtime-Permutations-Features**".

**(e) 2026-07-04 — Workload/Lastprofil explizit als runtime/„dynamische Achse".** LEDGER:169 (AP-11): „`WorkloadConfig` unberührt (**Lastprofile = dynamische Achse 2**)". D.h. Workload/Lastprofil sitzt strukturell auf der DynamicVariableNode-Seite und geht NICHT in `binary_id`/`permutation_axes` ein.

**(f) 2026-07-07 — F6-Achsen-Doktrin macht „Achsen = compile-time" bindend.** LEDGER:298 (F6-Antwort): Achsen sind „**je Achsen-Thema als Modul-Framework mit METAPROGRAMMIERUNGS-Interface** … damit zur **compile-time unter heuristisch optimaler Auswahl** die besten Algorithmen in eine Tier-Binary kompiliert werden". Parallel LEDGER:296: Konstruktions-Achsen (19 T0–T18 + 3 Build) = compile-time-Komposition je Permutation; System-Messachsen liegen **orthogonal** darüber; `COMDARE_MEASUREMENT_MODE` = Compile-Schalter; „2 Experiment-Achsen Build-Profil × Lastenprofil".

**Fazit Q1:** Es gibt keinen einzelnen Satz „Workloads=runtime, Achsen=compile-time" wortwörtlich — die Regel ist über zwei Invarianten kodiert: **(i)** Achsen-Algorithmen (SearchAlgorithm, Allokator, Layout, Node-Shape, Compiler) = StaticAxisNode = compile-time = Teil der Binary-Identität (golden_320); **(ii)** Workload/Lastprofil + die 5 RC-Felder (thread_count, hw_prefetcher, pool_budget …) = DynamicVariableNode = runtime-For-Schleife auf EINER geladenen Binary. Belege: Doc26:158-162 + Doc26:66-73 + LEDGER:169/:296/:482-484.

---

## 2. Was für #31 (F7 2D-Matrix W × M/Datasets) beschlossen wurde — der Hybrid

**Auftrag (2026-07-07, F7).** LEDGER:298: „die gesamte Matrix aller **Mess-Frameworks × Workloads** muss noch als Module mit **feingliedriger Baseline-2D-Matrix-Struktur** abstrahiert werden."

**Planung (2026-07-08, Doc15).** Die zwei Achsen: **Achse M** = Mess-Kategorien (Cache/dTLB/Branch-Miss, IPC/CPI, Latenz/Durchsatz/Energie; zeit-/observer-basiert vs. zählerbasiert-PMC), **Achse W** = Workloads (YCSB-A/C/E × 6er-Dataset-Kanon; „**Workload als dynamische Achse**", Doc15:26). Struktur-Fork Doc15:30-38: **Option A** (2. Dimension als compile-time-Parametrisierung IN den Zellen, F6-Metaprogrammierung, keine Zell-Explosion — EMPFOHLEN) vs. B (je Profil/Kategorie ein Modul → Explosion) vs. C (getrennte Familien-Achse).

**Der Hybrid-Beschluss (User, 2026-07-08).** LEDGER:369(e) — die tragende Entscheidung, wörtlich:
> „**#31-Fork-AUFLÖSUNG (User 08.07.):** die runtime Workload-Profile werden ein **HYBRID aus compile-time** (Matrix-/Experiment-Baum-Struktur, `experiment_tree`/`permutation_axes`) **+ runtime** (`WorkloadConfig`/Seed/Ops) — **NICHT rein compile-time (Option A verworfen)**, passend zum Experiment-Baum."

**Was genau compile-time / was runtime ist (aus der Umsetzung Schritt-1/1b):**
- **compile-time = die Matrix-STRUKTUR (Enumeration/Dispatch), nicht die Binary-Multiplikation.** LEDGER:373-374: `ycsb_profile_list` (YCSB A–F, mp11) = compile-time-Achse W; `CanonicalDataset` (6er-Kanon) = Achse D; `matrix_cells = mp_product(ycsb_profile_list, dataset_list)` = **6×6 = 36 Zellen**, `matrix_cell_count==36` self-proving (Doc15:44/§4). Also compile-time-*iterierbar*, damit die Metaprogrammierungs-Striktheit auch die Workload-Achse erfasst.
- **runtime = die tatsächliche Ausführung je geladener Binary.** `ycsb_token`/`config_for` = Hybrid-Brücke zum **runtime** `profile_by_name` (bit-identisch delegiert); `WorkloadConfig`/Seed/Ops bleiben runtime (LEDGER:374; :367 belegt `workload_profiles.hpp::profile_by_name` als RUNTIME-String-Tokens `if(tok=="A")`).
- **golden/ABI-Grenze (die eigentliche Pointe des Hybrids):** Workload ist **orthogonal** zu golden_320/permutation_axes/ABI — „Mess-INPUT = **DynamicVariableNode-Seite** des experiment_tree, KEINE Binary-Identitäts-Achse; `permutation_axes.xml` bleibt TABU — würde die 320 golden multiplizieren" (LEDGER:371). D.h. die 36 Zellen erzeugen KEINE neuen Tier-Binaries; sie sind eine compile-time-strukturierte Menge von runtime-Mess-Inputs *auf* den bestehenden 320.

**Frontier/Präzisierung (2026-07-09, noch offen).** Das neueste Artefakt `docs/sessions/backups/20260709-wf-4layer-experiment-tree/workflow-script.js` fasst den Rest-Plan und — wichtig — eine **frische User-Entscheidung** zu den bisher offenen #31-Extras zusammen (Zeilen 32/55): #31-Rest = **„Workload-Extras (WorkloadKind Custom-Ops + `profile_by_name` IH/LH — User-Entscheid: WorkloadKind-Basis + IH/LH ergänzen) UND Kategorie-Achse M (16 `MeasurementCategory`) als compile-time-Achsen der 2D-Mess-Matrix, HYBRID mit runtime … golden/ABI-neutral (Workload/Messung = Mess-INPUT, orthogonal zur 320-Permutation)"**. Das zugehörige Dossier ist aber noch NICHT synthetisiert (`docs/sessions/20260709-WORKFLOW-4layer-experiment-tree-DOSSIER.md:7` „(kein synth)"; „Verarbeitung für #31/#29 folgt später (User)").

---

## 3. Verworfener rein-compile-time-Ansatz — ZWEI distinkte Verwerfungen (nicht verwechseln)

**(a) Konzept „Option A = rein compile-time" — vom User verworfen.** Doc15 empfahl ursprünglich Option A als *reine* compile-time-Parametrisierung. Am 2026-07-08 verwarf der User genau das „rein compile-time" zugunsten des Hybrids: LEDGER:369(e) „**NICHT rein compile-time (Option A verworfen)**". Begründung: passt nicht zum Experiment-Baum, in dem der Workload strukturell die runtime-(Dynamic-)Seite ist.

**(b) Implementierung `WorkloadProfile`-Enum — gebaut, grün, dann revertiert.** LEDGER:371 (2026-07-08): Erster Schritt-1-Versuch = additives `workload_matrix.hpp` mit **compile-time `WorkloadProfile`-Enum (A-F/IH/LH)** + Brücke `config_for`→`profile_by_name`, **ctest 4/4 grün** (ce `bde1252e`). **REVERTIERT** (ce `7c8692bd`, super `43aa364`). **Verwerfungsgrund ist NICHT „compile-time ist falsch"**, sondern:
1. **Enum-Duplikat / Reuse-Verstoß:** es existiert BEREITS `enum class WorkloadKind` (`builder/commands/workload.hpp:18-28`: YCSB_A..F + Custom_HotKey/RangeDelete/BulkInsert) → `WorkloadProfile` wäre ein **DRITTER konkurrierender Workload-Enum** (Verstoß gegen Reuse/Matrix-Reuse-Schärfung).
2. **Unentschiedener Design-Fork:** welche der 3 Workload-Mengen kanonisch ist (WorkloadKind A-F+Custom-Ops vs. `profile_by_name` A-F+IH/LH vs. F7-Plan A/C/E×6-Datasets) war „im Ledger NIRGENDS entschieden" → nicht raten (Eskalationsregel).

**Wichtige Nuance:** Die korrigierte Fassung (LEDGER:373, ce `88738285`) ist **weiterhin compile-time** — sie ersetzt nur den neuen Enum durch **Reuse von `WorkloadKind`** als compile-time-Achse (`ycsb_profile_list`). Also: nicht „compile-time → runtime degradiert", sondern „eigener Enum → Bestands-Enum wiederverwendet". Der Schlüssel war die Erkenntnis, dass YCSB A–F in allen 3 Mengen IDENTISCH sind → Schritt-1 auf A–F ist mit jeder kanonischen-Menge-Wahl konfliktfrei (kein User-Gate nötig; das Gate galt nur den Extras).

---

## 4. Offene Punkte / Gates für #31 und den Workload-Achsen-Split

**#31 — erledigt:** Planungs-Doc15 (super `8318a56`); Schritt-1 A–F-Achse via WorkloadKind-Reuse (ce `88738285`); Schritt-1b Dataset-Achse D + 36-Zellen-Kreuzprodukt (ce `4d8aedce`, super `434bfe0`). Alle golden/ABI-neutral, ctest/clang-format/Mojibake belegt.

**#31 — offen (Gates):**
1. **#31-Schritt-2 „Extras-Vereinheitlichung"** (LEDGER:373-374): die Nicht-A–F-Profile — WorkloadKind `Custom_HotKey/RangeDelete/BulkInsert` vs. `profile_by_name` `IH/LH` vs. F7-Dataset-Kreuz. War „echter Design-Fork = User-Gate". **Teil-aufgelöst am 2026-07-09** (User-Entscheid „WorkloadKind-Basis + IH/LH ergänzen", `workflow-script.js:32/55`), aber **Dossier + Umsetzung noch nicht erstellt** (`…DOSSIER.md:7` „kein synth").
2. **Kategorie-Achse M (16 `MeasurementCategory`)** als compile-time-Achse der 2D-Matrix — geplant analog `matrix_cells`, noch nicht implementiert (`workflow-script.js:55`, Doc15:45 „Regime-Gate privilegiert vs. immutable").
3. **`baseline_3-analysis`-Stufe** (F14) noch nur vorgesehen/leer (Doc15:46/§5).
4. **Produktiver Konsum GATED auf Migrationsplan-Schritt 13** — „Diplomarbeit konsumiert `measurement-all` statt ce-Kopie … dann läuft die 2D-Matrix produktiv gegen die Tier-Binaries" (Doc15:55/§5.4).
5. **Struktur-Realisierung (Modul-Ebene) Option A/B/C** bleibt formal User-Wahl bei Realisierung (Doc15:38; UEBERGABE-33 empfahl Option A als „am wenigsten sensibel, bester Kandidat", `docs/sessions/20260708-SESSION-UEBERGABE-33-…md:28/48`) — die *Code*-Achsen sind bereits als Option-A-Kopf-Interface `workload_matrix.hpp` realisiert; die *Modul-Zellen-Aufteilung* (`measurement-all`) ist es noch nicht.

**Workload-Achsen-Split — invariant/TABU (Gates die NIE verletzt werden dürfen):** Workload geht NICHT in `permutation_axes.xml`/`binary_id`/golden_320 (LEDGER:371); Metaprogrammierung compile-time zwingend, kein Runtime-Switch (Doc15:59); die 36 Zellen sind Mess-INPUT auf bestehenden Binaries, keine Binary-Multiplikation.

**Angrenzend #29 (Workload-Zelle & Container-Typen):** `comdare-workloads`-Zellen-Schnitt kartiert, aber **A↔B-Welten-Konsolidierung** (zwei parallele Generator-Modelle `workload_driver` vs. `test_infra/workload_generator`) ist als GEPARKT-Owner-Entscheid ausgewiesen (`docs/kartierungen/20260707-SCHRITT7-KARTIERUNG-comdare-workloads-schnitt.md:17-21/41`). #29-Container-Typen-Realisierung (Doc37: Option A `backing_structure`-Achse vs. B eigener Genus) bleibt ABI/golden-User-Gate (LEDGER:351/:367).

---

**Kern-Belegdateien (absolut):**
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (Zeilen 169, 296, 298, 353, 367, 369, 371, 373, 374, 465, 482-484)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/architektur/15_F7_mess_frameworks_workloads_2d_matrix_plan.md` (26, 30-38, 44-46, 55-59)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/docs/architecture/26_permutations_bplus_baum_und_inverse_signatur.md` (66-73, 158-162)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/docs/architecture/24_messmodell_korrektur_zwei_dimensionen.md` (§8, 300-334)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/docs/architecture/37_ap15_container_typen_sequence_plan.md` (25-46)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260602 goal-v6-permutations-baum.txt` (9); `…/20260522-5300-V35-…md` (64-97); `…/20260707-SCHRITT7-KARTIERUNG-comdare-workloads-schnitt.md`; `…/backups/20260709-wf-4layer-experiment-tree/workflow-script.js` (15, 17, 32, 53, 55) + `…/20260709-WORKFLOW-4layer-experiment-tree-DOSSIER.md` (noch unsynthetisiert)