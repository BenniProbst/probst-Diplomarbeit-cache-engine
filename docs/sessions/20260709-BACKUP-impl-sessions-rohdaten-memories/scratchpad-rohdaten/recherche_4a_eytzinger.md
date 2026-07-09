# RECHERCHE-AUFTRAG (READ-ONLY, KEINE EDITS): #188-4a — EytzingerSearchAlgo store-traversierbar

Repo: comdare-cache-engine, HEAD `9b52186`. Alle Aussagen MIT file:line belegen. KEINE Code-Änderungen — reiner Untersuchungsbericht.

## Kontext (fix, nicht hinterfragen)
Die 4 Pool-Familien (BTree/SkipList/BST/Hash) sind bereits „store-traversierbar": echte Organ+Store-Trennung
(composed_*_search-Organe + *_node_pool_store/hash_bucket_pool_store + Concepts + tier_to_organ_mapping +
ObservableComposedContainer im abi_adapter; zuletzt Node-Shape-Achsen topics/nodes/axis_* bei HEAD).
Eytzinger gehört heute zur „Default-Flach-Gruppe" (organ_for→void → abi_adapter nutzt search_organ_ +
SortedBinary-Spiegel). **USER-ENTSCHEID OPTION (b), BINDEND:** Die bestehende Mutations-Strategie —
sorted-Basis + lazy `rebuild_eytzinger` via `dirty_`-Flag — BLEIBT. KEIN inkrementelles BFS-Pflegen,
KEIN eigener BFS-Layout-Store. Die Rebuild-Kosten stecken bewusst im ersten Lookup nach Mutation und
werden als Mess-Eigenschaft DOKUMENTIERT, nicht wegoptimiert.

## Fragen (alle beantworten)
1. **IST Eytzinger:** `libs/cache_engine/axes/lookup/axis_03a_search_algo_eytzinger.hpp` (bes. Z.54-57):
   vollständige Datenhaltung (alle Member), dirty_/rebuild_eytzinger-Mechanik, lookup/insert/erase/scan-Pfade,
   Statistik-/Observer-Felder, save_state/restore (Memento). Welche Concepts/Interfaces erfüllt die Klasse heute?
2. **organ_for-Mechanik:** `traversal_for_search_algo.hpp` (bes. Z.15): Wie ist organ_for definiert; welche
   search_algos mappen auf welche Traversal-Organe; was genau löst organ_for→void im weiteren Code aus?
   VOLLSTÄNDIGE Liste der Flach-Gruppe-Mitglieder (organ_for→void) mit Belegen.
3. **abi_adapter Default-Flach-Zweig:** Wie misst der abi_adapter die Flach-Gruppe HEUTE (search_organ_,
   SortedBinary-Spiegel, container_, Key-Ernte)? Exakte file:line der Verzweigung Flach vs. Pool-Familie
   (if-constexpr auf organ_for?). Was haben 4b-b-Flip (container_ hält echten Pool via
   ObservableComposedContainer) und DEG-1 (Key-Ernte-Capability) an diesem Zweig bereits geändert?
4. **ZIEL-Mechanik-Vorschlag im etablierten Muster:** Minimal-saubere Struktur, damit Eytzinger über die EINE
   reale Struktur store-traversierbar gemessen wird (Organ + Store + Concept + tier_to_organ_mapping-Eintrag +
   observe-Anbindung) — unter der Option-(b)-Nebenbedingung (sorted-Vektor = Primärzustand, Eytzinger-Array =
   abgeleiteter Zustand mit lazy rebuild; beides gehört in DENSELBEN Store, kein zweiter Speicher-Apparat).
   Existiert schon ein flacher/sorted Store als Vorlage oder was ist zu bauen? Die 4 Pool-Familien als Vorlage
   KURZ zitieren (je 3-5 Kern-Stellen: Store-Template, Organ, Concept, Mapping-Alias, Registry/CMake/Test/CI).
5. **Konsumenten/Invarianten:** Wo ist Eytzinger registriert (Registry-mp_list; axis_03a-Doppelbaum: topics/ =
   Shim, Registrierung NUR in axes/lookup)? golden-320-Bezug (taucht Eytzinger in den 320 auf?), betroffene
   Tests, observer_classification (aktuell 19/7/0=26 — ändert sich etwas?). Was ist TABU (modules/**, ext/**,
   golden-Snapshots, axis_03a-Registry-STRUKTUR) vs. was darf das Increment anfassen?
6. **Risiken/Subtilitäten:** Memento (tier_save_all/rollback_all) für Eytzinger; tier_clear/reset;
   seg_ns/Key-Ernte-Wechselwirkung; rebuild-im-const-lookup (mutable? thread?); welche weiteren
   Flach-Gruppe-Mitglieder dasselbe Muster später brauchen (Reihenfolge-Empfehlung, NICHT umsetzen).

## Output
Strukturierter Bericht entlang der 6 Fragen, jede Aussage mit file:line; am Ende „OFFENE FRAGEN/UNSICHERHEITEN".
