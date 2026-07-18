# DOSSIER W2/F2 — SkipListShape-Varianten real: bit-treue P-Verallgemeinerung in draw_level + Konformität

Du bist der IMPLEMENTIERUNGS-Agent. Implementiere GENAU diesen Increment im Arbeitsbaum. NICHT committen/pushen/
builden (kein lokaler Compiler; statisch prüfen). Abschlussbericht: Datei-Liste + je Baustein 1-2 Sätze + Risiken.

## 1) Repo/Stand/Kontext
Repo-Wurzel = Arbeitsverzeichnis (comdare-cache-engine, main, HEAD `f31a5c4`, sauber). C++23, GTest 1.15.2.
#234-K hat gelegt: `topics/nodes/axis_skip_list_shape/` (Strategien `SkipListMax16P50|Max8P50|Max32P50|Max16P25`,
je `kMaxLevel/kPNumerator/kPDenominator`); `SkipListNodePoolStore` ist `template <typename Shape = SkipListMax16P50>`
und liest kMaxLevel aus Shape (`axes/lookup/composable/skip_list_node_pool_store.hpp`); Alias
`SkipListOrganShaped<Shape>` (`tier_to_organ_mapping.hpp:63`). Das Traversal-Organ ist bereits voll
`Pool::kMaxLevel`-generisch (`skip_list_traversal_organ.hpp:40/:57/:97` — `std::array<size_t, Pool::kMaxLevel>`).
OFFEN aus 234-K (Kommentar im Store `draw_level()`): die Münzwurf-WAHRSCHEINLICHKEIT ist noch hartkodiert
`(rng_() & 1u) != 0u` (P=1/2) — kPNumerator/kPDenominator werden nicht gelesen. DAS ist der F2-Kern.

## 2) SOLL
### (A) `axes/lookup/composable/skip_list_node_pool_store.hpp` — draw_level bit-treu verallgemeinern
ERSETZE in `draw_level()` die Zeile `while ((rng_() & 1u) != 0u && lvl < kMaxLevel) ++lvl;` durch die
Shape-getriebene Form MIT EXAKT dieser Semantik (Bit-Treue-Kontrakt!):
```cpp
// #234-F2: P = kPNumerator/kPDenominator, kPDenominator MUSS Power-of-2 (maskenbasiert, kein Modulo-Bias).
// Weiter-Wuerfeln solange der Draw in den obersten kPNumerator Restklassen liegt — fuer 1/2 ist
// ((rng_() & 1u) >= 1u) EXAKT das alte ((rng_() & 1u) != 0u): gleicher RNG-Konsum, gleiches Praedikat.
while ((rng_() & (static_cast<std::uint64_t>(Shape::kPDenominator) - 1u)) >=
           static_cast<std::uint64_t>(Shape::kPDenominator - Shape::kPNumerator) &&
       lvl < kMaxLevel)
    ++lvl;
```
+ direkt in der Klasse: `static_assert((Shape::kPDenominator & (Shape::kPDenominator - 1)) == 0,
"#234-F2: kPDenominator muss Power-of-2 sein (maskenbasierte Ziehung)");` und
`static_assert(Shape::kPNumerator >= 1 && Shape::kPNumerator < Shape::kPDenominator);`.
Den `// #234-K: ... definition-only ... F2 wires ...`-Kommentar ERSETZEN (er ist damit eingelöst).
Banner-Kommentar der Datei um einen Satz zur Shape-P-Ziehung ergänzen. SONST NICHTS ändern (allocate_node/
clear/init_head/kNil/Seed 0xC0FFEEu bleiben byte-identisch).

### (B) NEU `tests/unit/test_234_f2_skip_list_shape.cpp` (gtest; Oracle-Muster = test_188_4bb0_...)
1. **BIT-TREUE-BEWEIS Level 0 (wichtigster Test):** lokale Alt-Referenz im Test nachbauen —
   `std::mt19937_64 alt(0xC0FFEEu)` + Alt-Formel `while ((alt() & 1u) != 0u && lvl < 16) ++lvl;` — und gegen
   `SkipListNodePoolStore<>{}.draw_level()` (frische Instanz, gleicher Seed via Konstruktor) über ≥10000
   aufeinanderfolgende Ziehungen VERGLEICHEN: identische Level-Sequenz ⇒ RNG-Konsum + Prädikat unverändert.
2. **P25-Statistik-Anker:** `SkipListNodePoolStore<SkipListMax16P25>` — über ≥100000 draws: Anteil lvl≥2 ≈ 1/4
   (Toleranz ±0.02) und Anteil lvl≥3 ≈ 1/16 (±0.01); außerdem NIE lvl>16.
3. **Max8/Max32-Grenzen:** Max8P50: nie lvl>8; Max32P50: nie lvl>32; je + Konformität (s. 4).
4. **Konformität je Variante:** `SkipListOrganShaped<Shape>` für {Max8P50, Max32P50, Max16P25} paargenau gegen
   `std::map<uint64_t,uint64_t>` (gemischte insert/update/lookup/erase/clear; weite Keys inkl.
   {0,7,65535,65536,1ull<<32,1ull<<40,UINT64_MAX} + ≥5000 random; `for_each_record` exactly-once via seen-Set).
5. **Level-0-Regressions-Anker:** `static_assert(std::is_same_v<SkipListOrgan, SkipListOrganShaped<SkipListMax16P50>>)`
   (zuerst prüfen ob wahr; falls nicht, Laufzeit-Äquivalenz-Test).
6. Deutsche Banner, Task-Tag `#234-F2`.

## 3) Verbote/Constraints (STRIKT)
- NUR die 2 genannten Dateien. NICHT anfassen: CMakeLists (Root+tests — Registrierung macht der Integrator),
  .gitlab-ci.yml, modules/**, ext/**, cmake/**, skip_list_traversal_organ.hpp, composed_skip_list_search.hpp,
  topics/** (Strategie-Header sind fertig), alle anderen Header/Tests.
- Bit-Treue Level 0 ist HARTES Gate: für kPNum=1/kPDen=2 muss die neue Formel Draw-für-Draw das alte Verhalten
  reproduzieren (Test 1 beweist es). KEINE alternative Ziehungslogik (kein Modulo, kein Float, kein Reordering).
- Store-Nutzung immer `SkipListNodePoolStore<...>`/Aliase; Test flag-unabhängig kompilierbar.

## 4) DoD + Bericht
(A)-Diff minimal (nur draw_level + 2 static_asserts + Kommentar); (B) gtest-Suite `Comdare234F2SkipListShape` mit
≥5 TESTs. Bericht: die exakte neue draw_level-Zeile; warum sie für 1/2 bit-identisch ist; Statistik-Toleranzen;
Risiken (falls Konstruktor-Seeding anders liegt als beschrieben — exakt benennen statt raten).
