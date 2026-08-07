# F12(iii) — ABI-GRENZEN-DESIGN-VORLAGE (koordinierter Anatomy-Major 4→5)

> ---
>
> ## ⚠️ STAND 2026-08-07: DER BRUCH, DEN DIESE VORLAGE PLANT, IST VOLLZOGEN -- UND DREIMAL UEBERHOLT
>
> **Diese Vorlage ist ein Bauplan im Futur. Der Bau hat stattgefunden.** Der Titel-Bruch „Major 4→5"
> wurde noch **am Tag der Erstellung** (2026-07-17, Bau-INC-2b, TABU-GO) vollzogen; seither ist
> dreimal weiter gebumpt worden. Wer die Vorlage heute als offene Auflage liest, plant einen Bruch,
> der vier Majors zurueckliegt. **Die Vorlage bleibt als Design-Begruendung wertvoll -- als Zustands-
> beschreibung nicht.** Belege gegen ce `ba069e38` (identisch in `ab0b352e`).
>
> **Warum hier ein Vermerk noetig ist, an vergleichbaren Stellen aber nicht.** Ein Dokument, das
> einen alten ABI-Stand **als den damaligen** nennt, ist gesund und braucht keinen Vermerk. Diese
> Vorlage tut an zwei Stellen etwas anderes:
> - `:11-12` schreibt woertlich **„Verifiziert (Ist): `COMDARE_ANATOMY_ABI_MAJOR 4`"**. Das Wort
>   **„(Ist)"** gibt den Wert als *heute geltenden Zustand* aus, nicht als Zeitschnitt.
> - `:8-9` formuliert ein **offenes Gate**: „sie wird erst mit koordiniertem **4→5-GO** vollzogen."
>   Ein Gate im Futur liest sich als ausstehende Auflage, die es nicht mehr ist.
>
> Die reinen Delta-Angaben dieses Dokuments (der geplante Umbau 4→5 als solcher, die Marker-Tabellen
> unter ABI-5) bleiben davon unberuehrt und sind **nicht** zu korrigieren: sie sind der historische
> Wert des Dossiers.
>
> ### Der ABI-Verlauf
>
> | Bruch | Anlass | Beleg (`abi/anatomy_module_abi_v1_decl.hpp`) |
> |---|---|---|
> | **4 → 5** | Bau-INC-2b, 2026-07-17, TABU-GO -- **genau das Buendel dieser Vorlage** (F12iii + F1b + F2 + #37) | `:46` |
> | 5 → 6 | Bau-INC-2d, 2026-07-18, isa-Herausloesung | `:52` |
> | 6 → 7 | STRUKT-R ORG-18, 2026-07-26, `persistence_target` als 18. Organ-Achse | `:57` |
> | 7 → 8 | E-24 C8, 2026-08-04, Ebene-1-Gattung wird ABI-Flaeche | `:65` |
>
> Ist heute: **MAJOR 8**, MINOR 0, Magic `.A8.` (`:89`, `:90`, `:92`).
>
> ### Die Anker im Einzelnen
>
> | Zeile | steht in der Vorlage | Ist-Stand 07.08. | Beleg (ce) |
> |---|---|---|---|
> | `:8-9` | „ABI-Major 4→5 … sind TABU … wird erst mit koordiniertem **4→5-GO vollzogen**" | GO erteilt, Bump vollzogen (17.07.) | `anatomy_module_abi_v1_decl.hpp:46` |
> | `:11-12` | „Verifiziert (Ist): `COMDARE_ANATOMY_ABI_MAJOR 4`, Magic `.A4.`; Diagnose-Format = 5" | MAJOR **8**, Magic **`.A8.`**, Diagnose-Version **8** | `:89`, `:92`; `anatomy/observable_tier.hpp:174` |
> | `:86-88` | „Neue Marker: `COMDARE_ANATOMY_ABI_MAJOR 5`, Magic `.A5.`" | uebersprungen; ausserdem steht das `#define` heute auf `:89`, nicht `:43` | `:89` |
> | `:111` | „`ComdareTierObserverSnapshot` (POD, **`sizeof==1416`**)" | **1344** (`static_assert`) | `observable_tier.hpp:168` |
> | `:128` | „`FullSourceCatalog = CatalogAxes<4,4,5,4>`" | `FullSourceCatalog` = **2^17 = 131072**; die 320er-Semantik heisst heute `golden_320_catalog` | `profile_facade/source_catalog.hpp:139`, `:144` |
> | `:129-130` | „**19 Kompositions-Achsen L00..L18** … die uebrigen **15** Slots gepinnt" | **18 Achsen L00..L17**; im 320er-Katalog **14** gepinnt | `source_catalog.hpp:95-118`, `:144` |
> | `:140-142` | „`kCompositionAxisNames` hart auf **19**; Set **15** / Sequence **11**" | **18**; Set **13** / Sequence **9** | `builder/experiment_tree/axis_path_serialization.hpp:40`; `genus_binding_traits.hpp:102`, `:132` |
> | `:171` | „`SearchAlgorithmAnatomy` … **19**" | **18** | `anatomy/composition_factory.hpp:104` |
> | `:131-132` | „Jeder der 320 Pfade traegt fix `isa=isa_amd64` und `telemetry=…`" | **Beide Segmente sind aus der binary_id verschwunden** (telemetry ab ABI-5, isa ab ABI-6). Die Fixture besteht fort, plus die Historien-Freezes `_abi4/_abi5/_abi6.txt` | `axis_path_serialization.hpp:27-31`; `tests/unit/thesis_tiere/` |
>
> ### Die eigene KORREKTUR-Box `:65-70` ist selbst ueberholt -- und trifft die dokumentierte Falle
>
> Sie erklaert den „massgeblichen Stand" zu `axis_stats[18][8]`, `kV3AxisCount == 18`,
> `sizeof 1416 → 1344`. **Die Zahlen stimmen zufaellig, der Achsen-Satz nicht:** der heutige
> 18er-Satz enthaelt `persistence_target`, **nicht** mehr `isa`. Zudem ist
> `kTierObserverSnapshotVersionUnified` heute **8**, nicht 6. Der Code warnt genau davor:
> `observable_tier.hpp:166-167` -- *„1344 gab es schon einmal (INC-2c, 18 Achsen INKLUSIVE isa);
> die Unterscheidung leistet ausschliesslich der Major."* (`T10 = value_handle` stimmt.)
>
> ### Vollzugs-Marken der Increment-Liste
>
> - `:195-197` **INC-0** DLL-Load-Fix Option B -- **VOLLZOGEN.** `link_libs`-Parameter
>   (`builder/build_orchestrator/build_orchestrator.hpp:880`, `:911`) und Fassaden-Bake
>   (`profile_facade/CMakeLists.txt:198-211`).
> - `:207-212` **INC-2** (der koordinierte 4→5-Bruch) -- **VOLLZOGEN** als Bau-INC-2b, 17.07.
> - `:26`, `:83`, `:173` **F2** Set-ABI (`ISetTier` + POD + `SetDock`) -- **GEBAUT**, dazu
>   `ISetTierV2` und `ISetAlgebraTier` (ABI-8): `anatomy/set_tier.hpp`, `set_tier_v2.hpp`,
>   `set_tier_algebra.hpp`; `builder/pruef_dock/set_dock.hpp`.
> - `:25` **F1b** Set-Ebene-1-Promotion -- **anders vollzogen**: Set blieb Genus unter Container,
>   bekam aber native Komposition, Anatomie, Observer und eigene ABI. Der Header erklaert die
>   Ebene-1-Promotion ausdruecklich fuer **gegenstandslos** (`anatomy/anatomy_base.hpp:94-98`).
> - `:218` **INC-4** -- Sequence/Adapter/View/Set-Docks gebaut (E-24 C4). **Graph bleibt offen**
>   („Stub, noch kein Genus implementiert, Q5 nach Abgabe", `anatomy_base.hpp:57`).
> - `:203-204` `-march`/`-mavx`-Luecke -- **GEHEILT** (`opt_flag`, `build_orchestrator.hpp:881`).
> - `:156`, `:216` „neue eingefrorene Fixtures **je Gattung** (`golden_abi5_map_/_set_/_sequence_`)"
>   -- **so nicht gebaut.** Die Messdaten-Erhaltung lief ueber Major-nummerierte Freezes
>   (`golden_fullpilot_320_binary_ids_abi4/5/6.txt`); fuer ABI-7 und ABI-8 entfiel der Freeze
>   bewusst, weil sich die binary_id nicht bewegte.
>
> **Weiterhin offen (Vorlage hat recht):** `:112`, `:205` das AVX10-Versionsfeld in
> `BuildVariantDefinitionV1` -- null Treffer fuer `avx10` in `include/cache_engine/abi/`.
>
> ---

Stand 2026-07-17. Basis = USER-KONSTRUKTIONS-MODELL 2026-07-17 (autoritativ).
Schwester-Dokument: `KONSTRUKTIONSLOGIK.md` (definiert Achsen/Gattungen/Prüf-Dock/DLL-Load).
Diese Vorlage ist die **Design-Grundlage** für den einen koordinierten ABI-Bruch; sie entscheidet
nicht neu, sondern legt die Naht, die Grenzen und den messdaten-erhaltenden Umbau fest.

**TABU-Hinweis:** ABI-Major 4→5 und die Golden-Byte-Ordnung sind TABU. Diese Vorlage BESCHREIBT den
Umbau; sie wird erst mit **koordiniertem 4→5-GO** vollzogen. Doku/Messdaten nie löschen.

Verifiziert (Ist): `COMDARE_ANATOMY_ABI_MAJOR 4` (`include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp:43`),
Magic `.A4.`; Diagnose-Format `observable_tier.hpp:155` = 5.

---

## 1. Warum EIN gemeinsamer 4→5-Bruch (nicht vier kleine)

Vier Struktur-Verschiebungen brechen ALLE dieselbe ABI-Grenze (Modul-Symbole + POD-Layouts +
Gattungs-Diskriminator + binary_id-Konvention). Sie einzeln zu machen hieße, die TABU-Grenze viermal
zu berühren und viermal Golden neu zu materialisieren. Doktrin `feedback_e_schichten_separat...`
verlangt je Schicht 1 Review/Backup — aber der ABI-Major-Bruch ist EINE Schicht. Darum werden am
Experiment-Planer-Dock **gemeinsam** vollzogen:

- **F12(iii)** — Telemetrie als CEB-System-Achse (raus aus der binary_id-Komposition).
- **F1b** — Set-Ebene-1-Promotion (`Set` als eigenes `AnatomyGattung`, nicht Genus unter Container).
- **F2** — Set-ABI (gattungs-eigenes Antriebs-Sub-Interface `ISetTier` + POD + Dock).
- **#37** — Scheduling als compile-time CEB-System-Achse (ersetzt die verwaiste Runtime-vtable).

Gemeinsamer Träger: der **Experiment-Planer-Dock** (siehe `KONSTRUKTIONSLOGIK.md` §7), die Naht
`run_experiment_profile` → `run_lazy_static_then_dynamic`
(`profile_facade/experiment_run_entry.hpp:225-251`).

---

## 2. Telemetrie als System-Achse in der CEB (F12iii)

### Ist (Delta)
Telemetrie ist heute **doppelt vergeben**:
1. **Organ-Slot T10** — `using telemetry = T10` (`anatomy/composition_factory.hpp:62`),
   `kCompositionAxisNames[10]`, permutiert die `binary_id` (`axis_path_serialization.hpp:30-34`).
   Auch Set/Sequence/View führen telemetry als per-Tier-Slot (`genus_binding_traits.hpp:100,125,148`).
2. **Mess-System-Achse** — `ObserverSnapshotSystemAxis`/`PmcSystemAxis`
   (`include/cache_engine/measurement/system_axis.hpp:192-332`), golden-neutral, immer präsent bei
   Messung (`system_axes_always_present()==true`, Z.145).
3. **Builder-seitig** `TelemetryConfig{Active/Silent}` (`telemetry_mode.hpp:18-25`, Silent-Diff-Messung
   Z.47) — schon konzeptionell eine CEB-System-Einstellung des Mess-WIE, aber nicht als Achse modelliert.

### Soll (F12iii)
Telemetrie wird zur **CEB-System-Achse** gehoben und aus der binary_id-permutierenden Organ-Komposition
**herausgelöst**:
- `TelemetryConfig` (Active/Silent) ist bereits die richtige Semantik → als System-Achsen-Belegung
  je Bau/Lauf gesetzt.
- Die Mess-System-Achsen-Wurzel `measurement::SystemAxis` (golden-neutral, immer präsent) ist die
  natürliche gemeinsame Wurzel; F12iii vereinheitlicht die konstruktive Telemetrie-Achse MIT dieser
  Mess-Wurzel (Organ vs System nie mischen — Direktive
  `system_axes_measurement_own_abstract_root_blood`).
- T10 verlässt `kCompositionAxisNames`; die Telemetrie-Wahl wird **versioniert NEBEN dem Binary**
  dokumentiert (H-10), nicht als binary_id-Segment.

### ABI-Konsequenz
Der Snapshot-POD `ComdareTierObserverSnapshot` behält `axis_stats[19][8]`; entfällt T10 aus der
Komposition, ändert sich die Achsen-Anzahl der SearchAlgorithm-Anatomie und damit `kV3AxisSchema`
(`observable_tier.hpp:66-104`) und `sizeof==1416` (Z.128). → **POD-Layout-Bruch = ABI-Major-Bruch.**

> **KORREKTUR (2026-07-17, real vollzogen in Bau-INC-2c — design-is-source):** Dieser Absatz war
> selbst-widersprüchlich („behält `[19][8]`" vs. „POD-Layout-Bruch" im selben Satz). Real umgesetzt
> und der **maßgebliche** Stand ist: der Snapshot-POD trägt jetzt **`axis_stats[18][8]` + `seg_ns[18]`**
> (telemetry-Zeile entfernt, T10 = value_handle), `kV3AxisCount == 18`, `kTierObserverSnapshotVersionUnified == 6`,
> **`sizeof` 1416 → 1344** (Δ −72). Der POD-Layout-Bruch ist damit die Achsen-**Reduktion**, nicht die Beibehaltung.
> Die telemetry-Wahl (Active/Silent) wandert in die CEB-System-Achsen-Schicht (H-10-Sidecar), NICHT in die binary_id.

---

## 3. Der koordinierte 4→5-Bump am Experiment-Planer-Dock

Der Anatomy-Major reitet an der Naht Planer→CEB-Messsystem (`KONSTRUKTIONSLOGIK.md` §7). Beim Bump
gemeinsam:

| Teil | ABI-Änderung | Grenze/POD |
|---|---|---|
| **F12iii** | T10 raus aus Komposition → neue Achsen-Zahl, neues `kV3AxisSchema`, neuer Snapshot-`sizeof` | `observable_tier.hpp` (Snapshot-POD, Schema) |
| **F1b** | `Set` als eigenes `AnatomyGattung` (Ebene-1) → `gattung_of()` faltet Set NICHT mehr → Container | `anatomy_base.hpp:40-44, 100-109` |
| **F2** | gattungs-eigenes `ISetTier` (Antrieb) + Set-POD + `SetDock` in `PruefDockRegistry` | neues Sub-Interface analog `observable_tier.hpp`; `pruef_dock_registry.hpp` |
| **#37** | Scheduling als compile-time CEB-System-Achse; die verwaiste vtable `ISchedulingStrategy` deprecaten | `include/cache_engine/concepts/scheduling_strategy.hpp:37-46` |

Neue Marker: `COMDARE_ANATOMY_ABI_MAJOR 5`, Magic `.A5.`
(`anatomy_module_abi_v1_decl.hpp:43-47`). Loader-Gate `host_compatible_with` (Major identisch,
Minor≤) verwirft alle ABI-4-DLLs — sauber, kein `dynamic_cast`-Degrade-Wildwuchs.

**#37 im Detail:** `ISchedulingStrategy` (`scheduling_strategy.hpp:37-46`) ist heute eine
RUNTIME-VTABLE-Achse, **nirgends konsumiert** (repo-weiter grep: nur Definitionsdatei) und — anders
als die deprecateten Schwestern `numa_affinity.hpp`/`locking_mode.hpp`/`hardware_strategy.hpp`
(alle „DEPRECATED 2026-07-16 V32.EE.5") — **ohne Deprecated-Marker**. Beim 4→5-Bump wird sie durch
eine **compile-time CEB-System-Achse** (kein vtable, CRTP+Concept) ersetzt; die alte vtable-Version
wird deprecatet (nicht gelöscht). Damit ist zugleich die Doktrin `no_runtime_switch`/`compile_time_only`
wiederhergestellt.

---

## 4. Wo die ABI-Grenzen sitzen (Grenz-Landkarte)

Prinzip (aus `KONSTRUKTIONSLOGIK.md` §4): der **Prüf-Dock ist KEINE ABI-Grenze**
(`pruef_dock.hpp:10-14`, lebt im Builder-Binary). Die ABI-Grenze ist immer:
**gattungs-eigenes Antriebs-Sub-Interface (vtable-stabil) + flacher POD (memcpy-fähig).**

| Grenze | Was kreuzt sie | Datei |
|---|---|---|
| **Modul-Symbol-Grenze** | 4 Pflicht-Symbole `comdare_anatomy_abi_version/_magic/comdare_create_anatomy/comdare_destroy_anatomy` + Magic + Major | `anatomy_module_abi_v1_decl.hpp:73-91`; Loader `anatomy_module_loader.cpp:114-152` |
| **Antriebs-Grenze (Befehl)** | `IDriveableTier` (immer) → `IObservableTier`/`IScannableTier`/`ISetTier` (Messung-AN), gattungs-getypt | `idriveable_tier.hpp:28-46`, `observable_tier.hpp:173-186`, `scannable_tier.hpp:35-41` |
| **Settings-Grenze** | `ComdareResourceControlV1` (POD, 6× uint64) via `IResourceControllableTier` (immer) | `resource_controllable_tier.hpp:34-68` |
| **Ergebnis-Grenze (Rückkanal)** | `ComdareTierObserverSnapshot` (POD, `sizeof==1416`, memcpy) + `ComdareSegmentLatencyV1` | `observable_tier.hpp:128-151`, `measurable_workload.hpp:51-70` |
| **Metadaten-Grenze (H-10)** | `BuildVariantDefinitionV1` (+ neu: AVX10-Feld), Sidecar NEBEN dem Binary | `include/cache_engine/abi/build_variant_inspection.hpp`, `build_variant_definition.hpp:22-24` |

Was NICHT ABI-Grenze ist und daher frei umgebaut werden darf: `IPruefDock`, `AnatomyPermutationDriver`,
`BuildOrchestrator`, `registry_to_axis_levels`, die gesamte CRTP+Concept-Kompositionslogik.

**Beim 4→5 verschieben sich die Grenzen so:**
- Ergebnis-Grenze: neues Snapshot-Layout (T10 raus, Set-Achsen-Satz).
- Antriebs-Grenze: `ISetTier` als neues gattungs-eigenes Sub-Interface (F2).
- Metadaten-Grenze: Telemetrie- + Scheduling- + ISA-Belegung wandern in das per-Binary-Sidecar
  (H-10), statt in die binary_id.

---

## 5. Golden ZERLEGT + UMGEBAUT — messdaten-erhaltend

### Was `golden_fullpilot_320` heute EXAKT ist
`FullSourceCatalog = CatalogAxes<4,4,5,4>` (verifiziert `profile_facade/source_catalog.hpp:113`):
19 Kompositions-Achsen L00..L18, variiert nur 4 — L00 search_algo(4) · L04 node_type(4) ·
L05 memory_layout(5) · L07 prefetch(4) = **320**; die übrigen 15 Slots `mp_take_c<…,1>` gepinnt.
Jeder der 320 Pfade trägt fix `isa=isa_amd64` und `telemetry=telemetry_leaf_only_counter`
(Fixture `tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt`, 320 IDs, eingefroren).
Alle 320 in EINER Gattung (Genus SearchAlgorithm). Gate: `test_profile_roundtrip.cpp` beweist literal
positions-identische Reproduktion aus `m3v2_study.profile.xml` (Diff leer, Z.133-165); DynamicDims
ändern die binary_id nicht (Z.176-186). Golden heute TABU/byte-unberührt.

### Was der Umbau bricht (drei orthogonale Verschiebungen)
1. **CEB-System-Achsen-Schicht:** `isa`(L12) und `telemetry`(L10) verlassen den binary_id-Pfad →
   jeder der 320 Pfade verliert ≥2 Segmente → **golden-Bruch**.
2. **Gattung-Ebene-1-Promotion (F1b):** `kCompositionAxisNames` ist hart auf 19 verdrahtet; ein
   promotetes Set/Sequence braucht eigene Achsen-Namen-Liste (Set 15 / Sequence 11 —
   `genus_binding_traits.hpp`) + einen **Gattung-Diskriminator im binary_id** → golden zerfällt in
   per-Gattung-Kataloge.
3. **ABI-Major 4→5:** Magic/Versionsfeld ändern sich; golden wird unter ABI-5 neu materialisiert.

### Regenerierungs-Plan (Messdaten nie löschen — `raw_data_backups_additive`)
1. **Einfrieren-additiv:** `golden_fullpilot_320_binary_ids.txt` + alle zugehörigen Mess-CSV/PDF
   (measurement/…) bleiben als `…_abi4`-Historie **unangetastet** (Regressions-Referenz für
   `test_profile_roundtrip`).
2. **Konventions-Erweiterung statt Ersatz:** `serialize_composition_path`/`kCompositionAxisNames`
   erweitern um (i) Herausnahme der System-Segmente (isa/telemetry/scheduling), (ii) optionales
   Gattung-Segment, (iii) das bereits vorhandene default-OFF `with_shape_segment`
   (`axis_path_serialization.hpp:87-94`) — unveränderte Pfade bleiben byte-identisch, wo möglich.
3. **Neu-Materialisierung EINMALIG** via den vorhandenen Generator (`gen_golden_fullpilot.cpp`, in
   `test_profile_roundtrip.cpp:10` referenziert) unter der neuen Achsen-Struktur → neue eingefrorene
   Fixtures je Gattung (`golden_abi5_map_… / _set_… / _sequence_…`), committet.
4. **Gate umhängen:** roundtrip-Test gegen die neuen Golden; alte als historische Referenz behalten
   (never-delete). Der 4→5-Bump nur mit koordiniertem GO (TABU).

---

## 6. Kopf-Frameworks je Ebene-1-Gattung (map / container / set / graph)

Modell: „je ein Kopf-Framework aus gemeinsamen Gattungs-Concepts". Ist: nur die SearchAlgorithm-
Gattung hat heute ein vollständiges Framework (19-Achsen-Anatomie + `SearchAlgorithmDock`); die
übrigen sind angelegt, aber ungebunden (`pruef_dock_registry.hpp:4-5`: „Set/Sequence/Adapter/View
kommen mit V42").

| Ebene-1-Gattung (Modell) | Kopf-Framework | Achsen-Satz (Ist) | Antriebs-ABI | Dock | Zustand |
|---|---|---|---|---|---|
| **map** = SearchAlgorithm-Hülle (K→V) | `SearchAlgorithmAnatomy` (`anatomy/search_algorithm_anatomy.hpp:31`) | 19 (kCompositionAxisNames) | `IObservableTier` | `SearchAlgorithmDock` | **fertig** |
| **(sequential) container** = Sequence (V indexed) | Sequence-Framework (Genus, `genus_binding_traits.hpp`) | 11 | (TBD, analog) | (TBD) | angelegt, ungebunden |
| **set** = Set (K only) | Set-Framework → **Ebene-1-Promotion (F1b)** | 15 | **`ISetTier` (F2, neu)** | **`SetDock` (neu)** | **4→5-Ziel** |
| **graph** = Graph | Graph-Framework | TBD | (TBD) | (TBD) | Interface-Slot vorhanden, Unterklassen TBD |

**View = read-only aus sequential container:** als non-owning Genus gebunden
(`genus_binding_traits.hpp:135-152`, Achsen-Satz 7), Zoologie „Pflanze" (`anatomy_base.hpp:66`).
Bleibt **unter** der Container-Gattung (kein eigenes Ebene-1), erbt das Sequence-Kopf-Framework
lesend. Konform zum Modell „View = nur lesen aus einem sequential container".

**Gemeinsame Gattungs-Concepts (Kopf-Framework-Wurzel):** die Cross-Axis-Wurzel `topics::AxisBase`
+ `AnatomyConcept` (`anatomy_base.hpp:120-127`) sind der gemeinsame Vertrag; je Gattung ein eigener
Achsen-Satz (`GenusBindingTraits`) + ein gattungs-eigenes Antriebs-Sub-Interface. Doktrin: jede
Gattung compile-time-monomorphisiert, kein vtable im Hot-Path; die vtable existiert nur an der
Modul-ABI-Grenze (`IAnatomyBase` + Sub-Interfaces), 1× je Modul kalt via `dynamic_cast` gezogen.

---

## 7. Increment-Schnitt (Reihenfolge der Umsetzung, je Schicht testbar)

Doktrin `feedback_e_schichten_separat_fertigstellen_top_down` (je Schicht Interface + testbar,
1 Review/Backup) + `feedback_diplomarbeit_impl_agent_cluster_readonly_no_infra`.

**INC-0 (VOR dem ABI-Bruch, ABI-4-kompatibel, kein GO nötig):**
- DLL-Load-Fix Option B (`KONSTRUKTIONSLOGIK.md` §9): Link-Input-Kanal in `BuildJob`/`make_gpp_compile_fn`
  + Fassaden-Bake der Archiv-Pfade. Rein additiv, macht den Laufzeit-Pfad string-gleich zum
  funktionierenden CMake-Pfad. **Sofort, autonom, verify-first.**
- F6-Nachzieh-Aktionen (deprecaten, nie löschen — siehe Rückgabe an Haupt-Agent).

**INC-1 (Schicht-Vorbereitung, ABI-4-kompatibel):**
- System-Achsen-Reflektion abspalten: `build_system_axis_levels()` aus der flachen 26er-Liste
  (`registry_to_axis_levels.hpp:81`) mit eigener abstrakter Wurzel (Organ vs System nie mischen).
- H-7-Compiler-Kopplung: `-march`/`-mavx…` in `make_gpp_compile_fn` (`build_orchestrator.hpp:466`)
  aus der System-Achsen-Belegung.
- H-10 per-Binary-Sidecar: `BuildVariantDefinitionV1` um AVX10-Feld, ins per-Binary-Verzeichnis.

**INC-2 (der koordinierte ABI-4→5-Bruch — braucht koordiniertes GO, EIN Backup/Review):**
- Experiment-Planer-Dock benennen + einziehen (Naht `experiment_run_entry.hpp:225-251`),
  `IPruefDock`-Vertrag scharf stellen (heute umgangen, `cache_engine_builder_iterator.hpp:750-756`).
- F12iii (Telemetrie raus aus Komposition) + F1b (Set Ebene-1) + F2 (`ISetTier`+`SetDock`) +
  #37 (Scheduling compile-time System-Achse, alte vtable deprecaten) gemeinsam.
- Major 4→5, Magic `.A5.`, Loader verwirft ABI-4-DLLs.

**INC-3 (Golden-Neu-Materialisierung, messdaten-erhaltend, §5):**
- alte Fixtures/Messdaten additiv als `…_abi4` einfrieren.
- neu materialisieren je Gattung (`golden_abi5_map_/_set_/_sequence_`), Gate umhängen.

**INC-4 (restliche Gattungs-Frameworks):** Sequence-/Container-/Graph-Dock + Antriebs-ABI (V42-Fahrplan).

Jeder Increment endet mit CI-grün + messfähig; nur punktuelle Refactorings, kein Parallelstruktur-Bau
(`feedback_vor_aufgaben_erst_projektstruktur_analyse`).
