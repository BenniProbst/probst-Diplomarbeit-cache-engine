## Kartierung: Mess-/Kategorie-Subsystem (Achse M) der cache-engine

BASE = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine`

### Kernbefund
Die compile-time-Kategorie-Achse M, die die Aufgabe skizziert, **existiert bereits fertig** als `BASE/libs/cache_engine/include/cache_engine/measurement/measurement_category_axis.hpp` (Artefakt „#31-Schritt-2/A2 / F7"). Sie ist genau als Liste + Regime-Klassifikator gebaut (nicht als mp_product) und beantwortet alle vier Fragen direkt im Header-Kommentar.

---

### 1. Wie werden Mess-Kategorien heute erfasst — ein Snapshot-POD oder je Kategorie ein Lauf?
**ALLE Spalten eines Laufs entstehen gleichzeitig in EINEM Snapshot-POD.** Kein Lauf-je-Kategorie.
- `ComdareMeasurementSnapshotV1` = der eine autoritative Mess-POD, 16+6 Spalten in einer Struktur: `measurement_snapshot.hpp:34-66` (Meta 3 / Perf 1 / 6 HW-Counter / Allocator 4 / 6 Observer-Spalten + `pmc_available`).
- Befüllt in einem Rutsch von `measurement_from_workload_result(...)` `measurement_snapshot.hpp:96` (Observer-Variante) bzw. `:119` (PMC-Overload, setzt zusätzlich die 6 HW-Counter).
- Serializer-Kommentar `measurement_snapshot.hpp:138`: „**Eine Zeile je (Komposition×Lastprofil)**" — die Zeilen-Granularität ist Komposition×Workload, NICHT Kategorie.
- Gegenprobe: KEIN Mess-Lauf iteriert `MeasurementCategory` — grep über `host_measure_loop.hpp`/`node_value_measurement.hpp`/`perm_runner.hpp` = leer; `MeasurementCategory` taucht im gesamten Repo nur in 4 Dateien auf (die 4 measurement-Header selbst, kein Builder/Loop).
- (Randnotiz: `measurement_record.hpp:11-21` skizziert ein 32-Byte-Long-Format `MeasurementRecord` MIT per-Zeile `category`-Feld — das wäre „je Kategorie eine Zeile", ist aber der Persistenz-Entwurf T7, nicht der aktive POD-Pfad.)

### 2. Gibt es schon eine Zweiteilung observer(zeit)/counter(pmc)?
**Ja, auf drei Ebenen** — die im Datenpfad AKTIVE ist die `pmc_available`/Factory-Schiene:
- POD-Flag: `pmc_available` gated die 6 HW-Counter — `measurement_snapshot.hpp:50` (0 = nicht real gemessen, ehrlich); Setzlogik `measurement_snapshot.hpp:104` (Null→0) vs. `:123-131` (reale Quelle→1).
- Quellen-Abstraktion: `PmcCounters::available` `pmc_source.hpp:27`, `IPmcSource::available()` `pmc_source.hpp:36`, `NullPmcSource` → `false` `pmc_source.hpp:46`.
- Factory (Strategy+Simple-Factory): `make_pmc_source()` `pmc_source_factory.hpp:29` — wählt reale PMC-Quelle (Win-PCM / Linux-perf) vs. `NullPmcSource`, kompilierzeit über `COMDARE_ENABLE_PMC`.
- **Compile-time-Klassifikation** (die eigentliche Kategorie-Zweiteilung, sogar Dreiteilung): `MeasurementRegime{Observer,Counter,Derived}` `measurement_category_axis.hpp:58-62`; `category_regime(c)` `measurement_category_axis.hpp:66`; `category_needs_pmc(c) == (Regime != Observer)` `measurement_category_axis.hpp:96`. Partition 7/7/2 (Observer/Counter/Derived), belegt via static_assert `:111-122` und Test `test_31b_measurement_category_axis.cpp:29-73`.

### 3. Ist M eine Lauf-multiplizierende Achse (mp_product-Faktor) oder eine Spalten-Projektion?
**Spalten-Projektion — multipliziert KEINE Läufe.** Explizit so entworfen und dokumentiert:
- `measurement_category_axis.hpp:7-11` wörtlich: „**M projiziert Spalten, multipliziert KEINE Läufe** … M ist daher eine compile-time-LISTE …, NICHT ein mp_product-Faktor der Lauf-Matrix (ein Kreuzprodukt mit M würde die Läufe fälschlich ×16 blähen). … |Läufe| = W·D, |Spalten je Lauf| = |M-Teilmenge|."
- Beleg im Typ: M ist `mp::mp_list<…>` `measurement_category_axis.hpp:37-53` und wird in KEIN `mp_product` gezogen.
- Kontrast — die ECHTEN Lauf-multiplizierenden Achsen nutzen `mp_product`:
  - W×D-Mess-Matrix: `matrix_cells = mp::mp_product<mp::mp_list, workload_profile_list, dataset_list>` `workload_matrix.hpp:128` (8 Workloads × 6 Datensätze = 48 Zellen, `:94`/`:131`).
  - Kompositions-Permutationen: `AllPermutations = mp::mp_product<PermTuple, StaticAxisVariants...>` `permutation_engine.hpp:112`, `count()` `:115`.
  - Diese Zahl geht auch in den Baum: `binary_count()` = ∏ statischer Ebenen `experiment_tree.hpp:360`. M ist orthogonal dazu und geht NICHT ein.

### 4. Wie SOLLTE eine compile-time-Kategorie-Achse M aussehen — und wie ist der Ist?
**Soll == Ist**: Die korrekte Form (Liste + Regime-Klassifikator, NICHT mp_product) ist bereits realisiert:
- `measurement_category_list` = mp11-Liste der 16 `MeasurementCategory` (REUSE des Bestands-Enums `measurement_category.hpp:9-26`, kein Enum-Shift) `measurement_category_axis.hpp:37-53`; `measurement_category_count` `:55`.
- constexpr-Regime-Klassifikator `category_regime()` `:66` + PMC-Gate `category_needs_pmc()` `:96`, rein compile-time (kein Runtime-Switch/vtable — passt zu den Direktiven `feedback_no_runtime_switch`/`feedback_compile_time_only_no_runtime`).
- Self-proving static_asserts `:111-122`; generisch iterierbar via `mp::mp_for_each` (Test `test_31b_measurement_category_axis.cpp:19-27`).

---

### Wichtige Lücke / Ehrlichkeits-Hinweis (Ist-Zustand)
Die Achse M und ihr Regime-Klassifikator sind **derzeit NICHT in den Datenpfad verdrahtet** — sie sind ein self-proving Compile-Time-Artefakt mit genau EINEM Konsumenten, dem Unit-Test:
- Einzige Einbindung von `measurement_category_axis.hpp`: `tests/unit/test_31b_measurement_category_axis.cpp` + dessen `CMakeLists.txt` (grep sonst leer).
- Der Snapshot-Builder `measurement_snapshot.hpp` inkludiert `measurement_category_axis.hpp` NICHT und referenziert weder `MeasurementCategory` noch `category_regime` (Includes `:20-28`) — er emittiert die 16+6 Spalten **bedingungslos**. Die im Datenpfad wirksame Observer/Counter-Trennung ist also allein die `pmc_available`/`IPmcSource`-Schiene (Frage 2), NICHT der Kategorie-Regime-Klassifikator.
- D.h.: M existiert als „selektierbare Kollektor-/Spalten-Menge" nur konzeptionell; ein Selektor, der anhand `category_regime`/`category_needs_pmc` tatsächlich Spalten/Kollektoren ein-/ausblendet, ist noch nicht angebunden.

Zusatz-Kontext (nicht Teil des aktiven POD-Pfads):
- `Measure<Cat,Detail>` `measure.hpp:23-62` ist ein separater, älterer per-Kategorie-Hook-Mechanismus (Primary-Template + 2 Beispiel-Spezialisierungen CLU×ART_NODE256, LATENCY_MEAN; `HasMeasurement`-Concept) — ebenfalls nicht in den Snapshot-Pfad verdrahtet.
- Numerik-Falle: die „16" im POD (16 Pipeline-Spalten) und die 16 `MeasurementCategory` sind beide 16, aber NICHT dieselben 16 — POD = physisches Schema, MeasurementCategory = semantische Metrik-Taxonomie.
- `axis_observer_classification.hpp:26-79` ist eine ANDERE Zweiteilung (Observer-Natur der 26 **Struktur**-Achsen: SearchAlgorithmObserver/DefinitionOnly/ContainerObserver, 19/7/0), nicht die der Mess-Kategorien.