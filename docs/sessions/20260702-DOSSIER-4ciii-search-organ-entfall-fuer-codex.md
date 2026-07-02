# DOSSIER #188-4c-iii — search_organ_-VOLLENTFALL im abi_adapter (der Spiegel stirbt physisch)

**Für: codex exec (workspace-write) im Repo `comdare-cache-engine` (HEAD `e6c3a93`).**
**Increment-Tag:** `#188-4c-iii (2026-07-02)`. Masterplan §2 Zeile 4c-iii. **EIN Increment, EIN Schnitt —
NIE halb umsetzen:** entweder alle Stellen konsistent oder Abbruch mit Bericht. god-header-Regel: dies ist
das EINE offene abi_adapter-Increment; NUR `libs/cache_engine/anatomy/abi_adapter.hpp` ändern (+ Bericht).

## 1. Lage (verifiziert)
Seit 4c-i (Hüllen) + 4c-ii (Flach-Wrapper StoreTraversable) ist `container_is_authoritative_` für JEDE
baubare Komposition true: StoreTraversable (LinearScan/Interpolation/k-ary/per-K + seit 4c-ii Array256/
Array65535/VectorU8U8/VectorU16U16) ∪ pool_family_ (9+Eytzinger) ∪ organ_hull_ (Referenz-Hüllen) ist
erschöpfend. Alle else-Zweige über `search_organ_` sind toter Code; das Member + seine Memento-Hälfte sind
der letzte physische Rest des Befund-2-Spiegels (`store_traversable_search_algo.hpp:16-22`: „search_organ_
ENTFÄLLT").

## 2. Auftrag — Entfernungs-Liste (Anker = Masterplan §2/4c-iii; Zeilennummern seit 4c-i leicht
verschoben → per grep `search_organ_|saved_search_|container_is_authoritative_` ALLE Stellen selbst
verifizieren und im Bericht mit aktuellen Zeilen listen):
1. **Member** `SearchAlgo search_organ_{};` (~:1976) entfernen. `SearchAlgo`-using bleibt (Weiche/Traits
   brauchen den Typ weiter).
2. **Ops-Verzweigungen auflösen:** tier_insert (~:753), tier_lookup (~:837), tier_erase (~:888) — das
   `if constexpr (container_is_authoritative_)` entfällt, es bleibt NUR der container_-Zweig (Kommentare
   auf die neue Wahrheit: EIN Speicher, konstitutiv).
3. **tier_clear:** `search_organ_.clear();` (~:904) + der requires-gated `search_organ_.reset()` (~:932)
   entfallen; container_-Zeilen bleiben.
4. **T0-Observer** (~:1011): Lambda auflösen — immer `container_.statistics()`.
5. **Key-Ernte-Kaskade** (~:1304-1327): Zweige 3+4 (MementoAxis<SearchAlgo>-save_state +
   search_organ_.for_each_record) ENTFERNEN — nur Zweig 1 (StoreTraversable via save_state) + Zweig 2
   (for_each_record über container_) bleiben; Bedingungs-Kommentare anpassen (Masstree-{0}-Fallback bleibt
   als leerer Default dokumentiert).
6. **do_batch-T0** (~:1341): else-Zweig weg; `using K = typename SearchAlgo::key_type;` wird dadurch
   ungenutzt → entfernen (prüfen, ob K anderswo lebt).
7. **routes_through_store** (~:1777): `return true;` mit Kommentar (konstant seit 4c-iii; Diagnose-API
   bleibt ABI-stabil erhalten). Der 4c-0-/4cii-Test-EXPECT_TRUE bleibt unverändert erfüllt.
8. **Weiche:** `container_is_authoritative_` entfernen und ALLE Nutzungen auflösen (bevorzugt; falls eine
   Nutzung außerhalb des Adapters existiert → melden statt raten). `pool_family_`/`organ_hull_`/
   `container_traversal_t`/`flat_container_t`/`container_t` BLEIBEN (die 3-Wege-Typwahl ist weiter nötig).
9. **Memento/CoW:** `saved_search_m_`, `saved_search_`, `saved_search_stats_` + alle search-Hälften in
   tier_save_all (~:1656-1678: statistics-Snapshot, emplace/save_state-Fallback), tier_rollback_all
   (~:1707/:1716-1719: restore), cow_materialize_copy_ (~:2108: emplace) entfernen. `cow_capable_`
   (~:2086-2089): SearchAlgo-Terme entfallen → Formel nur noch über container_t. ⚠️ SEMANTIK-DELTA
   AUSWEISEN: Für store-traversierbare/Pool-Kompositionen entfällt die künstliche Kopplung an das tote
   Organ → cow_capable_/tier_rollback_is_exact() können für MEHR Kompositionen true werden (gewollt —
   das tote Organ darf keine Fähigkeit mehr limitieren). tier_rollback_is_exact (~:1783): search_ok-Term
   entfällt.
10. **Kommentar-Sweep:** alle „Weg-B"/„markerlose Default-Flachgruppe"/„search_organ_"-Reste im
    abi_adapter auf die neue Wahrheit (EIN Speicher überall; historische Increment-Tags stehen lassen).

## 3. TABU / Leitplanken
- NUR abi_adapter.hpp. **`anatomy_execution_context.hpp` (~:115-120) hat ein EIGENES search_organ_/
  container_-Paar (Builder-Pilot) — NICHT anfassen** (fällt erst mit 4c-iv-Kontext).
- KEINE Test-Datei, KEIN CMake, KEIN CI ändern. Erwartung: alle Tests bleiben grün (sie asserten
  routes==true bzw. Verhalten, nicht die Member-Existenz). Findest du Tests, die search_organ_/
  saved_search_/tier_memento_is_copy_on_write()-Werte DIREKT asserten und durch das Semantik-Delta
  kippen könnten (Kandidaten: test_cow_memento, test_cow_capable_wrappers, test_abi_interface):
  im Bericht MELDEN mit Datei:Zeile + erwartetem Kipp-Verhalten, NICHT fixen.
- modules/** · ext/** · golden · Registry-mp_list tabu. Kein git. Keine $null-Artefakte. EOF 1×LF.
- Verhaltens-Identität für ALLE Kompositionen außer dem ausgewiesenen cow_capable_-Delta (das
  Conformance-Gate 4c-0/4c-ii ist das Netz).

## 4. Bericht
(a) Jede entfernte Stelle mit aktueller Zeile (die 14 Masterplan-Anker abhaken + evtl. Zusatzfunde);
(b) cow_capable_/rb_exact-Delta je Kompositions-Gruppe (vorher/nachher-Formel); (c) Kipp-Kandidaten-Tests;
(d) Bestätigung Tabu + dass grep search_organ_/saved_search_ im abi_adapter 0 Treffer liefert (außer ggf.
historischen Kommentar-Erwähnungen mit „entfiel in 4c-iii"-Markierung); (e) Risiken.
