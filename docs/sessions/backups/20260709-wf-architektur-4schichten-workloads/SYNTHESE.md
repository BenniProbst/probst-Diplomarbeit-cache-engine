# Chef-Architekt-Synthese: cache-engine — „Workloads=RUNTIME, Achsen-Algorithmen=COMPILE-TIME"

## EXECUTIVE VERDICT (Kern zuerst)

Der #31-Schritt-2-Bau ist **teils korrekt, teils am Punkt der Anforderung vorbei**:

- **(c) `measurement_category_axis.hpp` (M): KORREKT.** Compile-time-Liste + constexpr-Regime ist die *richtige und vollständige* Modellierung. Unabhängig bestätigt durch die Mess-Kategorie-Kartierung: „**Soll == Ist**".
- **(a) `WorkloadKind += IH/LH`: RICHTUNG KORREKT** (User-Entscheid 2026-07-09), aber **committen erst nach Enum-Verifikation** (Kollisions-/Shift-Risiko + Semantik-Dublette zu bestehenden `Custom_*`).
- **(b) `matrix_cells = mp_product(W,D) = 48` compile-time: NICHT FALSCH, aber am eigentlichen #31-Ziel vorbei.** Es ist golden/ABI-neutral (verletzt das TABU **nicht**), aber es ist ein **totes Parallel-Manifest**, das den **Hybrid nicht verdrahtet** und die **Fehlvorstellung zementiert, W und D seien compile-time-Achsen**.

**Das Missverständnis in einem Satz:** Der Impl-Agent modelliert **W, D, M symmetrisch als compile-time-mp11-Strukturen** und verwechselt damit „compile-time *aufzählbarer Katalog*" mit „compile-time *gefahrene Achse*". **M ist echt compile-time (Spalten-Projektion). W und D sind echt runtime (lauf-multiplizierende Achsen).** Ihre compile-time-Liste ist bestenfalls ein Hybrid-*Katalog* — niemals ihre *primäre Modellierung*. Damit reproduziert der Bau in subtiler Form genau das **„rein compile-time" (Option A), das der User explizit verworfen hat** (LEDGER:369e).

---

## 1. VIER SCHICHTEN und der compile-time/runtime-Split

Vorab die entscheidende Präzisierung aus der Synthese des 4-Schichten-Dossiers (`synth:16-18`): Es sind **nicht vier gleichrangige Hierarchie-Schichten, sondern ein Zwei-Ebenen-System (compile-time ⊥ runtime) plus eine orthogonale dritte Mess-Ebene**. Die compile/runtime-Grenze läuft *quer durch LAYER 1*.

| Layer | Name | Rolle | Regime | Beleg |
|---|---|---|---|---|
| **LAYER 1** | `experiment_tree` | Knoten-Ebene: `is_static`-Flag entscheidet Binär-Identität vs. Mess-Variation | **beides** (der Schalter) | `experiment_tree.hpp:189-195` (Z.192 Schalter) |
| **LAYER 2** | „CacheEngineBuilder" / `builder/` | Die Naht: `run_lazy_static_then_dynamic` zieht compile-time-Typuniversum + runtime-Auswahl zusammen | Naht | `cache_engine_builder_iterator.hpp:603-812`; kein `class CacheEngineBuilder` (`maps[1]:7`) |
| **LAYER 3** | Anatomie (Gattung/Genus/Concept) | Compile-time-Typuniversum + Binär-Identität (golden 320) | **COMPILE-TIME** | `anatomy_base.hpp:40-44,67-73,109-116,133-160`; `source_catalog.hpp:83-113` |
| **LAYER 4** | Workload-/Mess-Achsen | Runtime-Mess-INPUT (W,D) + Mess-OUTPUT-Projektion (M) | **RUNTIME** (+ M=Projektion) | `workload_matrix.hpp`, `measurement_category_axis.hpp`, `measurement_snapshot.hpp:34-66` |

**Compile-time-Seite (Achsen-Algorithmen → eigene Tier-Binary/DLL, binary_id, golden 320):** LAYER 3 + der `is_static=true`-Zweig von LAYER 1 (`StaticAxisNode`).
- `StaticAxisNode`: `contributes_to_signature()==true` → geht in `binary_id` (`experiment_tree.hpp:115-134`, Z.124).
- Je ∏-Kombination genau eine DLL: `binary_count() = ∏` statischer Ebenengrößen, rein arithmetisch, ohne Materialisierung (`experiment_tree.hpp:360-365`); on-demand-Dekodierung `StaticBinaryView::operator[]` (`:266-288`).
- Die golden 320 = `CatalogAxes<4,4,5,4>` = 4·4·5·4 (`source_catalog.hpp:83-113,112-113`), als statische AxisLevels gepusht (`:124-146`).

**Runtime-Seite (Workloads → for-Schleife über EINER Binary, keine neue Binary):** LAYER 4 + der `is_static=false`-Zweig von LAYER 1 (`DynamicVariableNode` → `RuntimeVariableLoop`).
- `DynamicVariableNode`: `contributes_to_signature()==false`, `is_runtime_loop()==true` (`experiment_tree.hpp:136-155`, Z.146/148) → ändert `binary_id` **nicht**.
- Virtuelle geschachtelte for-Schleife auf der geladenen Binary, **kein Neu-Bauen** (`runtime_variable_loop.hpp:73-107`).

**M ist der Sonderfall:** LAYER 4, aber **weder** compile-time-Identität **noch** runtime-Schleife — reine **Output-Spalten-Projektion** aus dem einen POD `ComdareMeasurementSnapshotV1` (`measurement_snapshot.hpp:34-66`), dessen `pmc_available` (`:50`) Counter- von Observer-Spalten trennt.

---

## 2. B+-Experiment-Baum: static (compile-time) vs. dynamic (runtime)

**Der Schalter** ist das eine Feld `AxisLevel.is_static` (Default `true`, `experiment_tree.hpp:189-195`, Z.192). `build()` splittet danach:
- `static_filter()` → `static_levels_` = Binär-Identität (`:342-347`)
- `dynamic_filter()` → `DynamicDim` = virtuelle for-Schleifen (`:349-354`)

**Wo die Achsen-Algorithmen sitzen (static/compile-time):** `search_algo·node_type·memory_layout·prefetch`(-Strategie) = golden 320, `is_static=true` via `push_static_axis` (`source_catalog.hpp:83-113,124-146`); 15 weitere Slots gepinnt. → in `binary_id`.

**Wo die Workloads sitzen (dynamic/runtime):** `AxisLevel{"workload", …, is_static=false, "workload_id", "workload"}` (`profile_run_entry.hpp:132-134`). Ebenso `concurrency.thread_count`, `prefetch.hw_prefetcher`, `repetition.repetition_index`. → **nicht** in `binary_id`.

**Realer Lauf** (`cache_engine_builder_iterator.hpp:609ff`): (1) statisch kompilieren je selektiertem Blatt genau EINE DLL (`:613-639`); (2) laden + `dynamic_cast` auf `IObservableTier`/`IResourceControllableTier` (`:685-702`); (3) `RuntimeVariableLoop.run(*ctrl, dyn_dims, …)` — kartesisch über die dyn. Dimensionen auf der GELADENEN Binary (`:773-775`), **kein Neu-Bauen/Neu-Laden**.

**Die „Einstellbarkeit" (CacheEngineBuilder):** drei runtime-Scharniere über dem compile-time-Typuniversum —
- **BuildSelection** = *welche* statischen Binaries gebaut werden (`select_full/one_wise/explicit/pinned`, gekappt auf `cfg.max_binaries`, `coverage_selection.hpp:25-71`) — wählt Punkte, multipliziert nichts.
- **Emitter** = Typ→Source je Komposition (`adhoc_emitter.hpp:94-108`).
- **Binary-Generierung** = compile→DLL je statischem Pfad.
- Naht-Zitat (`maps[1]:65-66`): „Compile-time fixiert das **Typ-Universum**; Runtime wählt **welche Punkte** gebaut/gemessen werden und **wie**."

---

## 3. WORKLOADS = RUNTIME — was das architektonisch heißt

„Framework von Workloads als runtime" heißt konkret **Drop-in-Wertemenge einer dynamischen Achse ohne Rekompilation**:

1. **Charakteristik im XML, zur Laufzeit geparst:** Op-Mix/Seed/Verteilung/neg%/scan aus `load_profiles/*.xml` → `parse_load_profile` (`load_profile_parser.hpp:74-118`) → `WorkloadConfig`.
2. **Verzeichnis = Wertemenge:** `discover_load_profiles(COMDARE_LOAD_PROFILE_DIR)` scannt zur Laufzeit (`load_profile_parser.hpp:122-133`). **Eine XML-Datei mehr = ein Achsenwert mehr, OHNE Neukompilierung** — das ist der Kern von „runtime", ermöglicht durch `is_static=false`.
3. **Injektion + Treibung:** dynamische AxisLevel (`profile_run_entry.hpp:132-134`), zur Laufzeit gegen die Registry aufgelöst (`run_workload_perm`, `perm_runner.hpp:204-229`), Fallback `profile_by_name` (`workload_profiles.hpp:23-35`); `WorkloadGenerator`(xorshift64), gleiche Config+Seed ⇒ bit-identisch über **alle** Binaries (`perm_runner.hpp:267`).

**Dürfen Workloads ein compile-time `mp_product`-Faktor der BINARY-Matrix sein? → NEIN.** Belege:
- `messarchitektur_v5_design.md:100`: „**Lastenprofil hat absichtlich KEINE neuen CMake-Flags** — es ist host-seitig zur Laufzeit (**Runtime-Matrix-Achse**)."
- `messarchitektur_v5_drei_profile.md:11-14`: BUILD-PROFIL = compile-time (Binaries) ⊥ LASTENPROFIL = Runtime host-seitig (`WorkloadConfig`/`WorkloadGenerator`).
- `28_vollstaendigkeits-kartographie.md:117`: dynamisch = for-Schleife auf EINER Binary, **KEINE neue Binary**; dyn. Kartesik wird NICHT aufgefächert.
- `34_KONSOLIDIERTER…:217`: golden 320 = Static-Pfad/`binary_id`; Lastprofil = dynamische Achse 2.
- LEDGER:371: `permutation_axes.xml` **TABU** — würde die 320 golden multiplizieren.

**Wichtige Nuance (Hybrid, Doc 15/F7):** Der Workload-**Katalog** *darf* ein compile-time-Parameter des Workload-**MODULS** sein (F6-Metaprogrammierungs-Interface, `15:34,38,48,59`) — das ist eine **separate, explizit als orthogonal deklarierte** Struktur-Ebene und **NICHT** ein Faktor der Binary-/golden-320-Matrix. Also: Workload als Faktor der **Binary-Matrix** = NEIN; Workload als compile-time-**Katalog einer runtime-Achse** = JA (Hybrid).

---

## 4. Achse W / D / M — korrekte Modellierung

| Achse | Natur | KORREKTE Modellierung | Beleg |
|---|---|---|---|
| **W (Workload)** | **RUNTIME**, lauf-multiplizierend (\|Läufe\| ∋ W) | Dynamische `AxisLevel` `is_static=false` (`discover_load_profiles`/XML). Compile-time `WorkloadKind`/`config_for` = **Hybrid-Katalog-Begleiter**, NICHT die Achse | `drei_profile.md:13`; `design.md:79,100`; `profile_run_entry.hpp:132-134` |
| **D (Dataset)** | **RUNTIME**, lauf-multiplizierend (Teil „Testdaten-Range" des Lastenprofils) | Dynamische `AxisLevel` `is_static=false`, analog zur Workload-Achse. **Heute existiert dafür KEINE dynamische AxisLevel** (Lücke A-G2). `CanonicalDataset` = Katalog, nicht die Achse | `drei_profile.md:13`; 4-Schichten `synth:32-35` |
| **M (Mess-Kategorie)** | **COMPILE-TIME**, Spalten-Projektion, **kein** Lauf-Multiplikator | Compile-time-**Liste** + constexpr-Regime-Klassifikator, **NIE** ein `mp_product`-Faktor der Lauf-Matrix | `measurement_category_axis.hpp:7-11,58-62,66,96` |

**Die Asymmetrie ist der Punkt (Doc 15/F7):** M ist compile-time **korrekt, WEIL M keine Lauf-Achse ist** (sie projiziert Spalten des einen Snapshots; ein Kreuzprodukt mit M würde die Läufe fälschlich ×16 blähen — `measurement_category_axis.hpp:7-11`). W/D müssen runtime sein, **WEIL sie Lauf-Achsen sind** (Drop-in ohne Rebuild). Zusätzlich ist der Mess-**MODUS** ein compile-time-cmake-Schalter (`COMDARE_MEASUREMENT_MODE`, `drei_profile.md:14`) — auch das ist eine Projektion, kein Lauf-Multiplikator.

---

## 5. KRITISCHE BEWERTUNG DES #31-BAUS

### 5a. Ist compile-time für W und D korrekt — oder Widerspruch?

**Differenziert, aber schonungslos:**

Die compile-time-`mp11`-STRUKTUR ist **nicht per se** der Widerspruch — sie ist als **compile-time-Hälfte des Hybrid** sanktioniert (User LEDGER:369e; Header-Selbstauskunft `workload_matrix.hpp:126-127` „runtime instanziiert je Mess-Lauf (Hybrid)"; golden/ABI-neutral, orthogonal `:25-26`; „wie eine DynamicVariableNode-Wertmenge … KEINE Binary-Identitäts-Achse" `:10-11`). Sie fließt **nicht** in `binary_id` — das **TABU ist gewahrt**.

**ABER:** Die compile-time-`workload_matrix` ist **NICHT die Modellierung von W und D als Experiment-Achsen**. Als Experiment-Achsen sind W und D **runtime** (`is_static=false`, `discover_load_profiles`/XML). Der Beweis, dass hier zwei getrennte Welten liegen, ist die Ist-Kartierung des Workload-Subsystems: **einziger Consumer** von `workload_matrix.hpp` ist `test_31_workload_matrix.cpp:7`; der **produktive Mess-Pfad läuft komplett über Runtime-Strings** — „**Der compile-time-`WorkloadKind`/`matrix_cells`-Pfad wird an keiner Stelle berührt**". Die `config_for`-Brücke (`workload_matrix.hpp:86-90`) wird produktiv **nie gerufen**. Der „Hybrid" ist also **nur deklariert, nicht realisiert**.

**Damit die klare Adjudikation:**
- **Compile-time WIRD zum Widerspruch, sobald der Katalog als operative/autoritative Achse verstanden wird** — denn eine compile-time-eingefrorene W/D-Menge (8 feste `WorkloadKind`, 6 feste `CanonicalDataset`) bricht die **Drop-in-ohne-Rebuild-Eigenschaft**: ein neuer Workload verlangte dann Editieren von `workload.hpp` + Rekompilieren. Das steht **frontal gegen** `messarchitektur_v5_design.md:100` und die runtime-`discover_load_profiles`-Realität.
- **W** muss primär runtime bleiben (existiert bereits: `is_static=false`); der compile-time-Katalog ist zulässiger Begleiter.
- **D** ist der schlimmere Fall: D hat **NUR** die compile-time-Liste (`dataset_list`, aus Schritt-1b) und **KEINE** runtime-AxisLevel — das ist das **Inverse der Anforderung**.

### 5b. Ist M korrekt als compile-time-Liste? — JA, eindeutig.

`measurement_category_axis.hpp:7-11` deklariert wörtlich: „M projiziert Spalten, multipliziert KEINE Läufe … M ist daher eine compile-time-LISTE …, NICHT ein `mp_product`-Faktor". M ist `mp_list` (`:37-53`) und wird in **KEIN** `mp_product` gezogen; Regime-Klassifikator `category_regime`/`category_needs_pmc` ist constexpr (`:66,96`) — kein Runtime-Switch/vtable (deckt `feedback_no_runtime_switch`/`feedback_compile_time_only_no_runtime`). Die Mess-Kategorie-Kartierung bestätigt: „**Soll == Ist**". **Diesen Teil hat der Impl-Agent exakt richtig gemacht** (insbesondere: M korrekt **nicht** in `matrix_cells` aufgenommen).

### 5c. WO GENAU liegt das Missverständnis?

Der Impl-Agent behandelt **W, D, M symmetrisch als „compile-time-`mp11`-Strukturen"**. Diese Symmetrie ist der Fehler:
1. **Verwechslung „compile-time-aufzählbar" ↔ „compile-time-gefahren".** Alle drei können compile-time *aufzählbar* sein (Metaprogrammierungs-Striktheit). Aber compile-time *modelliert/gefahren* dürfen nur **M** (Projektion) und die **Anatomie-Achsen** (golden 320) sein — **nicht** W/D als Lauf-Achsen.
2. **Wiedergeburt des verworfenen „rein compile-time" (Option A).** Durch Wachsen des compile-time-W×D-Manifests bei gleichzeitig **unverdrahtetem** Runtime-Kanal reproduziert der Bau genau das, was der User am 2026-07-08 verwarf (LEDGER:369e „NICHT rein compile-time"). Der Hybrid verlangt **beide Hälften verdrahtet** (Katalog ⟷ Runtime-Treiber via `config_for`), nicht ein Manifest parallel zum Runtime-Pfad.
3. **D ganz ohne Runtime-Rückgrat.** D existiert nur als compile-time-Liste; die dynamische AxisLevel fehlt komplett (`synth:32-35`, Lücke A-G2).

### 5d. Was wäre die KORREKTE Umsetzung? (siehe Q6)

---

## 6. KORREKTUR-EMPFEHLUNG — konkreter Bau-Plan für #31

### BEHALTEN
1. **`measurement_category_axis.hpp` (M) — unverändert.** Compile-time-Liste + constexpr-Regime ist korrekt (Soll==Ist). *Zusatz-TODO (nicht revert-relevant):* M ist noch **unverdrahtet** — der Snapshot-Builder inkludiert die Achse nicht (`measurement_snapshot.hpp:20-28` emittiert 16+6 Spalten bedingungslos). Ein Spalten-Selektor via `category_regime`/`category_needs_pmc` in `measurement_snapshot.hpp` ist die noch offene Anbindung.
2. **`WorkloadKind += IH/LH` (a)** — Richtung per User-Entscheid korrekt (`workflow-script.js:32/55`), **REUSE** statt drittem Enum (Konsistenz mit dem Revert-Grund des ersten Versuchs, ce `7c8692bd`→`88738285`). **GATE vor Commit:** verifizieren gegen `builder/commands/workload.hpp:18` — (i) keine **Wert-Kollision** von `InsertHeavy=6`/`LookupHeavy=7` mit bestehenden `Custom_HotKey/RangeDelete/BulkInsert`; (ii) **Append-only, kein Enum-Shift** (Golden-ABI-Bruch); (iii) klären, ob `Custom_BulkInsert` vs. `InsertHeavy` eine **Semantik-Dublette** ist.
3. **`workload_matrix.hpp`/`matrix_cells` (b)** — behalten **als reines compile-time-Selbstbeweis-MANIFEST/Katalog** (golden/ABI-neutral). `mp_product(W,D)=48` ist als **Lauf-ZÄHLUNG** (\|Läufe\|=W·D) legitim — im Gegensatz zu M, das korrekt draußen bleibt. Explizit dokumentieren: nur Katalog, **nie** Lauf-Treiber, **nie** in `binary_id`.

### FIXEN / ERGÄNZEN (das eigentliche #31-Ziel)
4. **Hybrid verdrahten** (der Sinn von #31): `config_for` (`workload_matrix.hpp:86-90`) in den Produktiv-Pfad einhängen (`perm_runner.hpp:204-229` / `cache_engine_builder_iterator.hpp:81-84,730-735`), sodass compile-time-`WorkloadKind` bit-identisch zu `profile_by_name` auf `WorkloadConfig` auflöst. Erst dann sind Katalog und Runtime-Treiber **ein** System statt zwei Parallelwelten.
5. **D als RUNTIME-Achse modellieren:** dynamische AxisLevel `AxisLevel{"dataset", dataset_values, is_static=false, "dataset_id", "dataset"}` analog `profile_run_entry.hpp:132-134`, getrieben von einem `discover_datasets`-Registry-Scan analog `discover_load_profiles` (`load_profile_parser.hpp:122-133`). Schließt Lücke A-G2. `CanonicalDataset` wird der **Katalog dahinter**, nicht die Achse.
6. **W-Runtime-Achse autoritativ halten:** `discover_load_profiles`/XML + `is_static=false` bleiben operativ (Drop-in ohne Rebuild). Versöhnung: XML-Discovery = operative Obermenge (20 Profile), compile-time-`WorkloadKind` = typisierte kanonische Teilmenge (8) via `config_for`; unbekannte/neue Profile lösen weiter runtime über Registry/`profile_by_name` auf.

### NIEMALS (TABU)
7. W/D/`matrix_cells` **nie** in `permutation_axes.xml`/`binary_id`/golden_320 (LEDGER:371; `28:117`). Die 48 Zellen erzeugen **keine** neuen Tier-Binaries — sie sind compile-time-strukturierte Menge von **runtime-Mess-Inputs** auf den bestehenden 320.
8. M **nie** als `mp_product`-Faktor der Lauf-Matrix (ist korrekt so — beibehalten).

**Fazit:** Der #31-Schritt-2-Bau ist **golden/ABI-sicher und in der Richtung User-konform**, aber er **wächst das compile-time-Manifest, statt den Hybrid zu verdrahten**, und **verfestigt die Fehlvorstellung, W/D seien compile-time-Achsen**. Korrekt ist: **M compile-time behalten; W/D primär als runtime-`AxisLevel(is_static=false)` fahren (D-Achse neu anlegen); die compile-time-Kataloge via `config_for` an den Runtime-Pfad anbinden** — dann ist der compile-time-Katalog mit „Workloads=runtime" vereinbar (echter Hybrid), statt eine tote Parallelstruktur zu sein.