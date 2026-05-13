# V8 — Implementations-Anker REV 7.6 (2026-05-14, 09:00)

**Sitzungs-ID:** V8 (achtes Implementations-Pendel nach REV 7.6 S1-S6)
**Anlass:** User-Vervollstaendigung von `STRUCTURAL_CORRECTION_diplomarbeit.md`
+ `24_architektur_skizze_REV7_2026_05_13.md` + `HABICH_TERMIN7_ZUSAMMENFASSUNG_2026_05_13.md`
am 2026-05-13 spaet/2026-05-14 frueh, mit 8 kritischen Klaerungs-Kommentaren.
**Modus:** Vollautonom KIV-konform (User-Direktive *"fahre mit hoechster
Praezision mit diesem Wissen vollautonom fort, bis alle Anforderungen
erfuellt sind"*).

---

## §0 Master-Plan: 8 User-Direktiven → 17 Tasks (V8.1-V8.17)

| User-Direktive (aus Diff) | Repo | Task-IDs |
|---|---|---|
| 1. CacheEngine: algorithm_profiles/ Ordner mit XML/JSON-Persistenz fehlt | cache-engine | V8.3, V8.6 |
| 2. PRT-ART Ordner FALSCH in cache-engine — gehoert in prt-art | cache-engine + prt-art | V8.2, V8.10 |
| 3. Bausteine = compile-time std::variants, full join pro Ebene | cache-engine | V8.8 |
| 4. ResultAggregator in abstrakter ExecutionEngine (Experiment-Modus) | cache-engine | V8.5 |
| 5. COMDARE_EXPERIMENT_MODE als CMake compile flag, default OFF | cache-engine | V8.4 |
| 6. CacheEngineBuilder = Compile-Time-Stack-Binary (vor Experimente) | cache-engine | V8.7 |
| 7. CacheEngine vererbt 8 Schichten an PRT-ART (strikte Erweiterung) | prt-art | V8.9 |
| 8. Submodule parallel + Diplomarbeit verraet prt-art den cache-engine-Pfad | Diplomarbeit | V8.12 |

Zusatz-Direktiven:
- **Habich-Termin:** Messreihe immer vollstaendig (defined+full-Mode) — V8.13
- **Diagramm:** CacheEngineBuilder-Komponente fehlt — V8.14
- **Hot-Compilation, Source-Bibliotheken** — V8.7+V8.9 implizit
- **Q1-Antwort:** cache-engine → prt-art → diplomarbeit Reihenfolge

---

## §1 Bestandsaufnahme (vor Implementation)

### §1.1 cache-engine

```
cache_engine/
├── builder/
│   ├── main.cpp                       (REV 7.6 Q4 Wrapper)
│   ├── experiment_driver/             (REV 7.6 Library)
│   ├── xml_config_parser/             (parsed bisher 4 XMLs)
│   ├── codegen/                       (CMake/sh/bat NO-PYTHON)
│   ├── permutation_loop/              (Enumeration)
│   ├── module_loader/                 (LoadLibrary/dlopen)
│   ├── experiment_runner/             (run_workload)
│   └── example_configs/               (4 XMLs als Beispiel)
├── include/cache_engine/abi/
│   ├── configuration_permutation.hpp  (DA)
│   ├── execution_engine.hpp           (DA)
│   ├── module_abi_v1.hpp              (DA)
│   ├── module_loader.hpp              (DA)
│   ├── processing_strategy.hpp        (DA)
│   ├── resolve_baustein.hpp           (DA — Compile-time-Fallback Concept)
│   ├── search_algorithm_type_collection.hpp (DA — Variadic Magic)
│   ├── search_engine.hpp              (DA)
│   └── type_collection_traits.hpp     (DA)
└── prt_art/
    └── legacy_reimpl/                 (FALSCH PLATZIERT, Migration zu prt-art)
        ├── P11-CSS-tree/
        ├── P12-CSB-tree/
        ├── ... (14 Subordner)
        └── P27-Zhang-ASPLOS-Hierarchical/
```

### §1.2 prt-art

```
prt_art/
├── allocator/                          (4+2 Pools)
├── concurrency/                        (OLC + reserved blocks)
├── memory_layout/                      (MultiLevel, ByteP, CacheLineAligned)
├── nodes/                              (BPlus, Redirect)
├── pages/
├── prefetch/                           (Distance, PathOriented, Redirect)
├── traversal/
├── value_handles/                      (Inline, External, ChainRef, CostModel)
├── legacy_reimpl/                      (LEER, hier wuerde Inhalt aus
│                                        cache-engine prt_art/legacy_reimpl/
│                                        landen — siehe V8.2)
└── include/prt_art/identity/
    ├── prt_art_identity.hpp
    ├── prt_art_search_engine.hpp       (REV 7.1 Hybride API, OFFEN: erbt nicht von ABI)
    └── status.hpp
```

### §1.3 Diplomarbeit/Code/

```
Code/
├── messung_driver/                     (REV 7.6, OFFEN: kein EXPERIMENT_MODE)
├── binary_to_csv/
├── csv_to_latex/
├── diagram_generator/
├── latex_to_pdf/
├── experiment_config/{a,b,c}.xml       (OFFEN: kein defined/full mode)
├── tests/unit/test_messung_driver.cpp  (REV 7.6 S4)
└── external/
    ├── comdare-cache-engine/          (Submodule, b88eab1)
    └── comdare-prt-art/                (Submodule, 0d3baeb)
```

---

## §2 Implementations-Reihenfolge (User-Direktive Q1-Antwort)

Die Reihenfolge ist STRIKT: cache-engine → prt-art → diplomarbeit.

### Phase A: cache-engine Kern-Strukturkorrekturen (V8.3-V8.8)
1. **V8.4** COMDARE_EXPERIMENT_MODE CMake flag (Foundation fuer V8.5)
2. **V8.5** ResultAggregator in ExecutionEngine (abhaengig von V8.4)
3. **V8.3** algorithm_profiles/ Ordner anlegen
4. **V8.6** defined/full mode in xml_config_parser
5. **V8.8** algorithm_baustein als compile-time std::variant
6. **V8.7** CacheEngineBuilder zwei-stufig
7. **V8.2** prt_art/legacy_reimpl/ Migrations-Plan (NUR Plan, nicht Loeschung)

### Phase B: prt-art Verdrahtung (V8.9-V8.11)
8. **V8.9** PrtArtSearchEngine erbt von cache-engine search_engine ABI
9. **V8.10** prt-art-eigenes algorithm_profiles/
10. **V8.11** TestDataSetAccumulationEngine im Constructor

### Phase C: Diplomarbeit-Anpassungen (V8.12-V8.14)
11. **V8.12** messung_driver setzt EXPERIMENT_MODE=ON
12. **V8.13** XML-Configs Messreihe A defined/full
13. **V8.14** CacheEngineBuilder-Komponente in Diagrammen

### Phase D: Verifikation + Push (V8.15-V8.17)
14. **V8.15** Tests aktualisieren + ctest gruen (alle 3 Repos)
15. **V8.16** Final commits + pushes + Submodule-Pin-Bumps
16. **V8.17** Final V8-Session-Doku

---

## §3 Designentscheidungen (autonom getroffen, fuer Audit dokumentiert)

### §3.1 EXPERIMENT_MODE (V8.4) — Default OFF, propagiert via Vererbung

```cmake
# cache-engine/CMakeLists.txt
option(COMDARE_EXPERIMENT_MODE "Aktiviert ResultAggregator + Mess-Hooks" OFF)
if(COMDARE_EXPERIMENT_MODE)
    add_compile_definitions(COMDARE_EXPERIMENT_MODE_ON=1)
endif()
```

PRT-ART und Diplomarbeit erben das Flag transitive. Diplomarbeit's
messung_driver setzt es explizit ON beim Konfigurieren des
ExperimentDriver-Sub-Builds.

### §3.2 algorithm_profiles/ Layout (V8.3)

```
cache_engine/algorithm_profiles/
├── README.md            (Erlaeutert Profil-Format)
├── _schema.xsd          (XML-Schema-Validierung)
├── sota/
│   ├── art.profile.xml          (P01)
│   ├── hot.profile.xml          (P02)
│   ├── masstree.profile.xml     (P03)
│   ├── coco_trie.profile.xml    (P04)
│   ├── start.profile.xml        (P05)
│   ├── b2tree.profile.xml       (P06)
│   ├── wormhole.profile.xml     (P07)
│   ├── surf.profile.xml         (P10)
│   ├── css_tree.profile.xml     (P11)
│   ├── csb_tree.profile.xml     (P12)
│   └── ...
└── permutation_axes.xml          (Definiert die 11 Achsen + Wertebereiche)
```

Pro Profil ein vollstaendiger Konfig-Satz (alle 11 Achsen + Allokator
+ Concurrency). Permutation kann durch *defined-mode*-Filter den
relevanten SOTA-Stack aktivieren.

### §3.3 std::variant Pattern (V8.8)

```cpp
namespace comdare::cache_engine::baustein {

// Pro Achse ein std::variant der angebotenen Konkretisierungen
using PageVariant = std::variant<
    PrtArtRedirectPage,        // PRT-ART-Variante (nur bei vorhandenem Pruefling)
    DenseByteArt256Page,       // ART
    HotMultiBytePage,          // HOT
    MasstreeINode,             // Masstree
    /*...*/>;

// Full join: kompiliert alle 2-Tupel von (Pruefling-Variant, SOTA-Variant)
template <typename PrueflingV, typename SotaV>
struct full_join_pair { /*...*/ };

}  // namespace comdare::cache_engine::baustein
```

Jeder Algorithmus-Baustein wird als variant ueber alle Konkretisierungen
deklariert. Der CacheEngineBuilder generiert `O(N×M)`-Kombinationen
(Pruefling × SOTA) als Compile-time-Permutationen.

### §3.4 ResultAggregator-Verdrahtung (V8.5)

```cpp
// cache_engine/include/cache_engine/abi/execution_engine.hpp
template <typename ProcessingStrategy>
class execution_engine : public cache_engine::CacheEngine {
public:
    #ifdef COMDARE_EXPERIMENT_MODE_ON
        // Nur im Experiment-Modus: ResultAggregator als Member
        comdare::experiment::ResultAggregator& aggregator() noexcept { return agg_; }
    #endif
private:
    #ifdef COMDARE_EXPERIMENT_MODE_ON
        comdare::experiment::ResultAggregator agg_;
    #endif
};
```

Im Production-Modus (default OFF): kein Member, kein Mess-Overhead.
Im Experiment-Modus (messung_driver-Aufruf): Aggregator ist fester
Bestandteil der Result-Binary.

### §3.5 prt_art/legacy_reimpl/ Migration (V8.2)

**KEINE** sofortige Loeschung in cache-engine — stattdessen:
1. Doku im cache-engine-Repo: "DEPRECATED, migrating to prt-art"
2. In prt-art-Repo: `prt_art/legacy_reimpl/` mit gleicher Struktur anlegen
3. Skelette uebernehmen (READMEs sind oft schon dokumentiert)
4. cache-engine-CMakeLists schaltet legacy_reimpl auf NICHT-Build per default
5. Eine Folge-Phase loescht den falschen Inhalt aus cache-engine

Begruendung der gestaffelten Migration: vermeidet Build-Brueche fuer
heutige Konsumenten.

### §3.6 Defined vs Full Mode (V8.6 + V8.13)

```xml
<!-- experiment_config/config_a_prt_art_vs_sota.xml -->
<comdare>
  <messreihe id="A_PRT_ART_vs_SOTA">
    <mode>defined</mode>
    <!-- defined-mode: nur diese SOTA-Profile -->
    <sota_profiles>
      <profile>art</profile>
      <profile>hot</profile>
      <profile>masstree</profile>
      <profile>start</profile>
      <profile>wormhole</profile>
      <profile>b2tree</profile>
      <profile>surf</profile>
      <profile>coco_trie</profile>
    </sota_profiles>
  </messreihe>

  <messreihe id="A_PRT_ART_vs_SOTA_full">
    <mode>full</mode>
    <!-- full-mode: alle Rekombinationen aus den 11 Achsen -->
  </messreihe>
</comdare>
```

Habich-Direktive: **immer vollstaendig** — Default sollte `full` sein,
`defined` ist nur die Vorab-Verifikations-Auswahl.

---

## §4 Risiken + Gegenmassnahmen

| Risiko | Gegenmassnahme |
|---|---|
| EXPERIMENT_MODE-Default-OFF bricht heutige Tests | Test-Suite mit `-DCOMDARE_EXPERIMENT_MODE=ON` builden |
| std::variant-Bausteine erhoehen Compile-Time exponentiell | Pro Achse maximal 16 Konkretisierungen, std::variant-Limit beachten |
| ABI-Inheritance prt-art → cache-engine bricht heutige API | abwaertskompatible Default-Implementierungen in search_engine.hpp |
| algorithm_profiles XML-Schema-Drift | XSD-Validierung im xml_config_parser |
| legacy_reimpl-Migration ohne Loeschung = doppelte Pflege | DEPRECATED-Marker + KEIN-Build-Default + Folge-Loeschungs-Phase nach Verifikation |

---

## §5 Cross-Repo-Abhaengigkeiten

```
V8.4 (cache-engine flag) ────────┐
V8.5 (cache-engine aggregator) ──┤
V8.3 (cache-engine profiles) ────┤───> V8.16 (Push)
V8.6 (cache-engine defined/full) ┤
V8.7 (cache-engine builder)  ────┤
V8.8 (cache-engine variants) ────┤
V8.2 (cache-engine migration plan) ┘
                  |
                  v
V8.9 (prt-art ABI inherit) ──────┐
V8.10 (prt-art profiles) ────────┤───> V8.16 (Push prt-art)
V8.11 (prt-art TestDataSet) ─────┘
                  |
                  v
V8.12 (Diplomarbeit EXPERIMENT_MODE) ┐
V8.13 (Diplomarbeit defined/full) ───┤───> V8.16 (Push Diplomarbeit + Pin-Bumps)
V8.14 (Diplomarbeit Diagramme) ──────┘
                  |
                  v
V8.15 (ctest gruen alle 3 Repos)
                  |
                  v
V8.17 (final session doc)
```

---

## §6 Naechste Schritte (sofort nach dieser Doku)

1. Schreibe Schwester-Sessions in cache-engine + prt-art docs/sessions/
2. Beginne V8.4 (CMake flag) als kleinster Foundation-Schritt
3. Iteriere durch V8.5-V8.8, jeweils mit ctest-Verifikation
4. Beginne V8.9-V8.11 nachdem cache-engine stabil ist
5. Diplomarbeit-Phase V8.12-V8.14 zuletzt
6. Final commit/push + Pin-Bumps + Final-Session-Doku

---

## §7 Verifikations-Akzeptanzkriterien (V8 abgeschlossen wenn:)

- [ ] cache-engine baut mit `-DCOMDARE_EXPERIMENT_MODE=OFF` (default) und
      `-DCOMDARE_EXPERIMENT_MODE=ON`, beide ctest gruen
- [ ] cache-engine `algorithm_profiles/sota/` hat mindestens 8 Profile
- [ ] cache-engine xml_config_parser unterstuetzt `<mode>defined</mode>` +
      `<mode>full</mode>`
- [ ] cache-engine prt_art/legacy_reimpl/ ist DEPRECATED (CMakeLists
      schaltet es default ab + README erklaert Migration)
- [ ] prt-art `PrtArtSearchEngine` erbt von `comdare::search_engine`
      (Compile-Test verifiziert das)
- [ ] prt-art `algorithm_profiles/prtart_pruefling.profile.xml` existiert
- [ ] prt-art ctest gruen
- [ ] Diplomarbeit `messung_driver` setzt EXPERIMENT_MODE explizit
- [ ] Diplomarbeit `experiment_config/config_a_*.xml` hat beide Modi
- [ ] Diplomarbeit Diagramme zeigen CacheEngineBuilder explizit
- [ ] Alle 3 Repos gepusht + Submodule-Pins gebumpt
- [ ] Diese V8-Session-Doku + Schwester-Sessions in jedem Repo

---

## §8 Querverweise

- `STRUCTURAL_CORRECTION_diplomarbeit.md` (8 User-Kommentare am 2026-05-13/14)
- `20260508 Termin 7/Phase5_UML_Detail/24_architektur_skizze_REV7_2026_05_13.md`
- `20260508 Termin 7/HABICH_TERMIN7_ZUSAMMENFASSUNG_2026_05_13.md`
- cache-engine: `docs/sessions/20260514-0900-v8-cache-engine-strukturkorrekturen.md`
- prt-art: `docs/sessions/20260514-0900-v8-prt-art-abi-inheritance.md`
- Memory: `feedback_session_at_95_percent_context.md` (Pflicht-Direktive
  bei 95% Kontext immer Session-Doku schreiben)
