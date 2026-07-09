# ADVERSARISCHER REVIEW (READ-ONLY): #188-4a 4a-Eytzinger-Organ — uncommitteter Diff gegen HEAD 9b52186

Prüfe `git diff` + `git status` (untracked: 4 neue Header unter libs/cache_engine/axes/lookup/composable/
eytzinger_* + composed_eytzinger_search.hpp + tests/unit/test_188_4a_eytzinger_organ.cpp). Versuche aktiv,
den Increment zu WIDERLEGEN (Korrektheit, Konsistenz, versteckte Verhaltensänderungen für ANDERE Algos).

## Kontext (fix — NICHT als Befund melden)
1. USER-ENTSCHEID Option (b): sorted-Basis + lazy rebuild via dirty_ ist GEWOLLT; Rebuild-Kosten im ersten
   Lookup nach Mutation = dokumentierte Mess-Eigenschaft. KEINE Optimierungs-Vorschläge dagegen.
2. Integrations-Weg organ_for (10. Familie) statt StoreTraversable-Marker = Integrator-Entscheid (beide
   Recherchen konvergent); abi_adapter-Weichen bleiben strukturell unverändert (nur Kommentar-Fixes).
3. ARBEITSTEILUNG: CMake-Registrierung (tests/unit/CMakeLists.txt) + CI (contract:pool_flip in .gitlab-ci.yml)
   hat der INTEGRATOR bereits gemacht — beides ist im Diff enthalten. NICHT als fehlend melden.
4. Der u16-Wrapper EytzingerSearchAlgo bleibt absichtlich unverändert (Registry-Tier + Referenz);
   golden-320-IDs bleiben textuell identisch (name()+Achsenpfad); die GEMESSENEN Werte der 80
   eytzinger-Tiere ändern sich absichtlich (T0 jetzt aus dem echten Organ) — gewollter Zweck.
5. tier_scan bleibt für organ-backed Familien honest-0 (Status quo der 9 Pool-Familien) — kein 4a-Scope.

## Prüffragen (adversarisch)
A. Branch-free-Kern in eytzinger_traversal_organ.hpp lookup_in: BIT-IDENTISCH zur Wrapper-Vorlage
   axis_03a_search_algo_eytzinger.hpp:107-118 (Schleife, countr_one-Shift, idx-Grenzen)? Rechne 2-3
   konkrete Beispiele durch (n=1 hit/miss, n=3 kleinster/größter, miss zwischen zwei Keys).
B. In-order-Fill in eytzinger_layout_store.hpp rebuild_if_dirty/fill_eytzinger: identisch zur Vorlage
   Z.186-202? dirty-Invalidierung in ALLEN Mutations-APIs (auch set_value_at/append_slot/clear)?
C. Verändert der Diff das Verhalten IRGENDEINES anderen Algos? (organ_for-Spezialisierung nur Eytzinger;
   abi_adapter nur Kommentare — verifiziere per Diff, dass KEINE Code-Zeile dort geändert ist!)
D. ObservableComposedContainer-Vertrag: erfüllt ComposedEytzingerSearch alles (insert void / lookup const
   optional / erase bool / clear noexcept / occupied_count const noexcept / key_type u64 / default-ctor /
   for_each_record)? Memento: Adapter-Copy-Pfade kompilieren mit dem neuen container_t?
E. Registry/golden: mp_list-Struktur/Reihenfolge WIRKLICH unangetastet? static_assert
   !StoreTraversableSearchAlgo<EytzingerSearchAlgo> weiter wahr? Disjunktheits-Asserts konsistent?
F. Include-Zyklen: organ_for_search_algo.hpp -> tier_to_organ_mapping.hpp -> composed_eytzinger_search.hpp ->
   eytzinger_layout_pool_concept/store/organ — Zyklus-frei? Kompiliert der neue Test-Include-Satz
   (<axes/lookup/...>-Pfade) mit dem 4bb0-Include-Satz der CMake-Registrierung?
G. Test-Qualität: prüfen T1-T8 das Behauptete wirklich (bes. T3 update-invalidiert, T4 kein Rebuild-Trigger,
   T7 Statistik-Zählung gegen observable_composed_container.hpp:47-79)? Konstanten statt Literale?
H. CI: contract:pool_flip baut jetzt 2 Targets + ctest -R '^test_188_4' — matcht GENAU die 2 gewollten Tests
   (keine unbeabsichtigten weiteren test_188_4*-Namen im Baum)?

## Output
Verdikt SHIP / FIX (nur bei echten Defekten) / BLOCKER, je Befund mit file:line + konkretem Beleg.
Keine Code-Änderungen. Kein CMake-/CI-fehlt-Befund (siehe Arbeitsteilung).
