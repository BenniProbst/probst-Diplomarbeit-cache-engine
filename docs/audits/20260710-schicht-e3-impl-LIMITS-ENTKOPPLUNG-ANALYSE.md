# LIMITS-ENTKOPPLUNG-ANALYSE - Schicht E3 Paket C

## 0. Scope

Dieses Dokument ist nur Analyse und Design-Skizze. Fuer die Limits-Entkopplung werden in diesem Increment
`tests/unit/thesis_tiere/source_catalog.hpp`, `apps/adhoc_emitter/main.cpp`, Profile, Golden-Dateien und
Produktiv-Build-Code nicht geaendert.

## 1. Konsum-Kanten

### CatalogAxes / FullSourceCatalog

- `tests/unit/thesis_tiere/source_catalog.hpp:83-111`: `CatalogAxes<KSearch,KNode,KLayout,KPrefetch>` definiert die
  19 Slot-Listen `L00` bis `L18` und instanziiert daraus `PermutationEngine`. Die vier Parameter oeffnen nur
  `search_algo`, `node_type`, `memory_layout` und `prefetch`; die restlichen 15 Slots sind per `mp_take_c<...,1>`
  gepinnt.
- `tests/unit/thesis_tiere/source_catalog.hpp:113`: `FullSourceCatalog = CatalogAxes<4,4,5,4>` ist der Basis-320-Raum.
- `tests/unit/thesis_tiere/source_catalog.hpp:116`: `SmallSourceCatalog = CatalogAxes<1,2,2,1>` ist die kleine
  Materialisierungs-Domaene fuer den lazy E2E-Treibertest.
- `tests/unit/thesis_tiere/source_catalog.hpp:124-146`: `catalog_static_levels<Catalog>()` spiegelt die Slot-Listen in
  19 statische `AxisLevel`-Eintraege. Diese Reihenfolge ist die Golden-Konvention fuer `StaticBinaryView`.
- `tests/unit/thesis_tiere/source_catalog.hpp:154-156`: `make_catalog_source_gen<Catalog>()` baut aus dem
  Catalog-Engine-Typ die `binary_id -> Modulquelle`-Map.
- `tests/unit/thesis_tiere/source_catalog.hpp:164-179`: `catalog_levels<Catalog>()` haengt nur fuer Tests dynamische
  Runtime-Dimensionen an; die statische Binary-ID bleibt `catalog_static_levels`.
- `tests/unit/thesis_tiere/source_catalog.hpp:203-350`: die Axis-Sweep- und per-K-Kataloge benutzen dieselbe
  19-Slot-Konvention, variieren aber jeweils eine kleine Zusatz-Domaene neben dem Basis-320-Raum.
- `tests/unit/thesis_tiere/profile_run_entry.hpp:127-160`: `run_profile` baut den Basisbaum aus dem Profil,
  injiziert dynamische Workload-Dims und verbindet `make_catalog_source_gen<FullSourceCatalog>()` mit Sweep- und
  SOTA-Quellen.
- `tests/unit/thesis_tiere/profile_run_entry.hpp:249-310`: vertiefte Achsen-Sweeps benutzen eigene Sweep-Levels und
  dieselbe unionierte SourceGenFn.
- `tests/unit/thesis_tiere/gen_golden_fullpilot.cpp:15,36-54`: der eingefrorene Golden-320-Text wurde aus
  `catalog_static_levels<FullSourceCatalog>() -> StaticBinaryView` erzeugt.
- `tests/unit/thesis_tiere/test_profile_roundtrip.cpp:46-55,94-145`: der Profilpfad wird gegen die eingefrorene
  Golden-Liste verglichen; das Gate ist positionssensitiv.
- `tests/unit/thesis_tiere/test_run_profile_union.cpp:110-130`: prueft, dass Basis-320-IDs ueber
  `make_catalog_source_gen<FullSourceCatalog>()` Quelle liefern und disjunkt zu SOTA-IDs bleiben.
- `tests/unit/test_lazy_static_dynamic_driver.cpp:91-115`: nutzt `SmallSourceCatalog`, `catalog_levels` und
  `make_catalog_source_gen` fuer einen realen kleinen DLL-Treiberlauf.

### PilotEngine im Adhoc-Emitter

- `apps/adhoc_emitter/main.cpp:139-140`: `PilotEngine` ist separat hartkodiert als
  `SearchAlgorithmPermutationEngine<C0..C18>`.
- `apps/adhoc_emitter/main.cpp:219`: der Default-CLI-Modus emittiert `PilotEngine` (`kuratiert-3achsen`).
- `apps/adhoc_emitter/main.cpp:143-188`: `--full-coverage` nutzt eine andere Sample-Engine und ist keine
  `CatalogAxes`-Kante.

Andere `PilotEngine`-Treffer in Unit-Tests sind lokale Test-Engines und nicht die `apps/adhoc_emitter`-Kante.

## 2. Entkopplungs-Richtung

Die Limits sind compile-time-gebunden: ein XML-Wert muss vor dem C++-Compile in einen konkreten Wrapper-Typ in der
passenden Slot-Liste aufgeloest werden. Ein Runtime-Switch wuerde die Typbildung nur verstecken und waere nicht mit
der bestehenden `PermutationEngine`-/`AdHocComposition`-Architektur vereinbar.

Der passende Schnitt ist deshalb ein Pre-Build-Codegen-Schritt:

1. Codegen-Tool liest `ThesisProfile.permute_axes` aus dem Profil und die kanonische 19-Achsen-Reihenfolge aus der
   bestehenden Achsen-Single-Source.
2. Fuer jede Achse werden Profilwerte deterministisch auf Wrapper-Typen gemappt, z. B. ueber `W::name()`/Registry.
   Unbekannte, doppelte oder fuer den Slot unzulaessige Werte sind harte Fehler.
3. Das Tool schreibt in das Build-Verzeichnis einen generierten Katalog-Header mit `L00` bis `L18` als `mp_list` in
   exakt kanonischer Slot-Reihenfolge.
4. `GeneratedFullSourceCatalog::Engine`, `generated_catalog_static_levels()` und
   `generated_make_catalog_source_gen()` liefern dieselben Oberflaechen wie heute `FullSourceCatalog`,
   `catalog_static_levels` und `make_catalog_source_gen`.
5. CMake haengt die generierte Datei vor dem Bau der Harness-/Emitter-Ziele ein. Das ist analog zum bestehenden
   Zwei-Pass-Gedanken des `adhoc_emitter`: erst Typ-/Quellenraum erzeugen, danach die eigentlichen Module bauen.

Default-Anforderung: Fuer `m3v2_study.profile.xml` muss der Generator bytegleich den heutigen Basisraum erzeugen:
`search_algo=4`, `node_type=4`, `memory_layout=5`, `prefetch=4`, alle anderen Slots gepinnt. Die daraus resultierende
`StaticBinaryView`-Liste muss positionsidentisch zur committeten `golden_fullpilot_320_binary_ids.txt` bleiben.

## 3. Risiken

- Reihenfolgedrift: XML-Reihenfolge, Registry-Reihenfolge und `kCompositionAxisNames` duerfen nicht gegeneinander
  sortiert oder normalisiert werden.
- Namensmapping: Profilwerte muessen eindeutig auf Wrapper-Typen zeigen; Aliasnamen oder deaktivierte Varianten
  koennen sonst falsche Typen erzeugen.
- Golden-Zirkularitaet: Die Golden-Datei darf nicht aus dem neu generierten Pfad neu geschrieben werden, sonst
  verliert das Gate seinen Wert.
- Compile-Explosion: Freigeschaltete Achsen koennen den Typraum stark vergroessern. Das Design braucht harte
  Limits/Diagnosen vor der Generierung.
- Split-Brain: `source_catalog` und `apps/adhoc_emitter` duerfen nach der Entkopplung nicht zwei divergierende
  Katalog-Definitionen tragen.
- Build-Hygiene: generierte Header muessen im Build-Verzeichnis liegen, sauber als Abhaengigkeit modelliert sein und
  nicht in `super/Code/**` oder Golden-Artefakte zurueckschreiben.

## 4. Golden-Gate-Plan

1. Nicht-invasive Vorstufe: Generator erzeugt den Header nur in `build/`, kein Produktivkonsum. Ein Test vergleicht
   die generierten `catalog_static_levels` gegen die heutige `FullSourceCatalog`-Liste.
2. Golden-Default-Gate: `StaticBinaryView(generated_default_levels)` muss exakt 320 IDs liefern und jede Position
   muss mit `golden_fullpilot_320_binary_ids.txt` uebereinstimmen.
3. SourceGen-Gate: Fuer alle 320 Golden-IDs liefert die generierte SourceGenFn nicht-leere Modulquelle; fuer eine
   bewusst unbekannte ID bleibt die Quelle leer.
4. Profil-Gate: `test_profile_roundtrip` bleibt gruen; dynamische Levels duerfen die statische Zaehlung nicht
   beeinflussen.
5. Union-/Sweep-Gate: `test_run_profile_union` und die vertieften Sweep-Pfade bleiben disjunkt und liefern weiterhin
   reale Quellen.
6. Erst danach Produktivumschaltung: `FullSourceCatalog` wird durch den generierten Default-Katalog ersetzt oder als
   Fallback behalten. Die Umschaltung ist build-time, nicht runtime.
