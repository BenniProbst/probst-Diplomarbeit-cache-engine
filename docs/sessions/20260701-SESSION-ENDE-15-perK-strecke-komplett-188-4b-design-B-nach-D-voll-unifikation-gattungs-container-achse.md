# SESSION-ENDE-15 — #188 per-K-Strecke KOMPLETT (Inc 1/2/2b) · #188-4b Design ENTSCHIEDEN (B→D + Voll-Unifikation) mit 5 User-Präzisierungen · Gattungs-Recherche-zuerst

> **Datum:** 2026-07-01 · **Agent:** Impl-Agent (cache-engine, autonomes /goal) · **Vorgänger:** SESSION-ENDE-14.
> **Diese Session:** die gesamte **per-K-Strecke** (#188 Increment 1 + 2 + 2b) sauber implementiert + Codex-geprüft + auf beide Remotes committet; dann **#188-4b** (Pool-Familie store-traversierbar) via Explore+Codex-Paar recherchiert, User-entschieden (**B→D**) und über **5 User-Präzisierungen** zur „vollständigsten + saubersten Variante" geschärft. Implementierung von 4b = FRISCHER Kontext (User-Entscheid bei 81%: gründlich planen → kompaktieren → frisch fortfahren).
> **⚠️ WICHTIGSTE Direktive dieser Session:** „**nie die einfachste, immer die sauberste UND wartbarste Strategie**" (User, generalisiert auf ALLEN Code). Und: „bei JEDEM Explore-Agent parallel einen mcp-Codex mit exakt derselben Aufgabe" (Codex sieht mehr).

---

## §0 HEADs + Orientierung
- **cache-engine** `main` = **`19d4f05`** (#188 per-K Inc 2b). Arbeitsbaum sauber.
- **super (Diplomarbeit)** `main` = **`772523b`** (Submodul→19d4f05; thesis/diplomarbeit UNBERÜHRT). Diese SE-15 wird ein weiterer super-Commit.
- **cluster** = unverändert diese Session (Infra-Domäne; #210/V111 nicht berührt — Infra-Agent-Domäne).
- **Primär-Anker 4b** = Memory `reference_188_4b_pool_family_store_traversable_design` (VOLLSTÄNDIG: Pool-Inventar mit file:lines, Weg-B-Split, 4 Optionen, alle 5 Präzisierungen). Diese SE-15 fasst zusammen + plant.

---

## §1 Session-Arc (chronologisch)
1. **Kontext geladen** (SE-14-Übergabe, k_ary-Header, Concepts). Start = #188 per-K Increment 1 (aus SE-14 §9).
2. **per-K Inc 1** (`d321fe9`): Template `KArySearchAlgoT<unsigned K>` + Aliase K2/K4/K8/K16 (compile-time K, distinkte name(), Marker, !IterableAspect) + partielle Spezialisierung `traversal_for_search_algo<KArySearchAlgoT<K>>→KAryTraversal<K>` + self-proving static_asserts. Legacy `KArySearchAlgo` unangetastet. Codex SHIP-WITH-NITS. **Test-Korrektur verifiziert:** die geplante test_conformance_gate-Extension war NICHT machbar (standalone-Gate-Target hat NUR libs/cache_engine[/include]-Include, NICHT build/generated → Wrapper-Include hätte den grünen contract:conformance-Job #223 gebrochen) → Inc-1-Test = static_asserts in den Headern.
3. **per-K Inc 2** (`7c1f444`): 4 Aliase in `AllStrategies` REGISTRIERT (ans ENDE → golden-320-First-4 unberührt), je EIGENER Enable-Flag (`COMDARE_AXIS_03A_ENABLE_K_ARY_K{2,4,8,16}`, Default OFF wie OriginalXxx-Präzedenz) → nicht-disruptiv (EnabledStrategies wächst NICHT). Nur 2 AllStrategies-Count-Tests: permutation_engine kSearch 17→21, topic_traversal SimdSubset 6u→10u (DenseSubset bleibt 2). +4 K3_CHECK (cow_capable) + CMake-Status. Codex SHIP-WITH-NITS, alle NITs adressiert.
4. **ZWEI-BAUM-BEFUND** (Explore+Codex, Memory `reference_two_axis03a_trees_topics_shim_over_lookup`): `topics/traversal/axis_03a_search_algo` = 6-Zeilen-`using namespace lookup`-Shim über den KANONISCHEN `axes/lookup`-Baum (SELBE AllStrategies). Registrierung nur in lookup; modules-Mirror vestigial. → Inc-1-Edits (lookup) waren bereits korrekt/vollständig.
5. **per-K Inc 2b** (`19d4f05`): dedizierter `KaryPerKCatalog` (source_catalog.hpp, explizites `L00=mp_list<per-K>` → bypassed EnabledStrategies; search_algo ist KEINE vertiefte Achse) + `kary_perk_source_map/levels` + Verifikation (test_axis_sweep_pilot.cpp Sektion E: 4 reale per-K-Kompositionen + realer cl-Bau). Additiv, golden-320 unberührt. Codex SHIP-WITH-NITS.
6. **#188-4b Design-Recherche** (Explore-Agent `ad910e99` + Codex-Paar, KONVERGENT): Pool-Familie store-traversierbar. 4 Optionen (A/B/C/D). User-Entscheid **B→D**.
7. **5 User-Präzisierungen** (schärfen zur Voll-Unifikation — s. §3).

---

## §2 Commits/Deltas (SHAs)
| Repo | SHA | Inhalt | Codex |
|---|---|---|---|
| cache-engine | `d321fe9` | #188 per-K Inc 1 (Template + Aliase + Mapping + static_asserts) | SHIP-WITH-NITS |
| cache-engine | `7c1f444` | #188 per-K Inc 2 (Registrierung + per-K-Flags OFF + 2 Count-Fixes) | SHIP-WITH-NITS |
| cache-engine | `19d4f05` | #188 per-K Inc 2b (KaryPerKCatalog + Verifikation) | SHIP-WITH-NITS |
| super | `6fbf9f9`, `772523b` | Submodul-Bumps (Inc 2, Inc 2b) | — |
| Memory | neu/aktualisiert | `feedback_pair_explore_with_codex_same_investigation` (neu), `reference_two_axis03a_trees_topics_shim_over_lookup` (neu), `reference_188_4b_pool_family_store_traversable_design` (neu, 5 Präzisierungen), `feedback_infra_cleanest_not_easiest` (generalisiert) + MEMORY.md-Pointer | — |

Alle cache-engine + super-Commits WITH `Co-Authored-By: Claude Opus 4.8 (1M context)`, `[skip ci]` (harness-gated #162 + CI #210-blockiert), beide Remotes (origin=GitHub + gitlab).

---

## §3 #188-4b — DER ENTSCHIEDENE DESIGN (B→D + Voll-Unifikation) — DAS KERNSTÜCK

**Aufgabe:** die 9 Pool-Familien (SOTA-Bäume ART/HOT/Wormhole/START/Masstree + BST/BTree/SkipList/Hash) store-traversierbar machen (heute Weg-B). **Vollständige file:line-Evidenz in Memory `reference_188_4b_pool_family_store_traversable_design` — bei Session-Start ZUERST lesen.**

**Der Defekt (abi_adapter.hpp):** für Weg-B (Pool) ist `container_` ein **SortedBinary-Spiegel über dem flachen `LayoutAwareChunkedStore`** (misst NUR die Storage-Achsen), `search_organ_` = der echte Pool (beantwortet Lookups + T0). Records doppelt gespeichert. ⟹ bei SOTA-Bäumen messen node/layout/allocator einen **Neben-Apparat**, nicht den echten Baum (Mess-Validitäts-Defekt). Jeder `*NodePoolStore` ist heute ein plain `std::vector`-Monolith mit **Default-Allocator**, NICHT `<N,L,A>`-parametrisiert.

**Die 5 USER-PRÄZISIERUNGEN (2026-07-01) — schärfen zur „vollständigsten + saubersten Variante":**
1. **Voll-Unifikation:** die Original-Wrapper (BinarySearchTreeSearchAlgo etc.) werden FASSADEN über ihrer `Composed*Search`-Organ⊕Pool-Komposition → die Zwei-Repräsentations-Spaltung (Monolith vs Organ) wird GANZ aufgelöst.
2. **Anatomie = Permutations-B+-Baum-bestimmt:** die Komposition je Binary kommt aus dem Permutations-KNOTEN (compile-time, BR-2/BR-4/CompositionFromPermTuple). Das „Laden hinter dem Achsen-Interface" IST die Permutation.
3. **search_algo war NIE flach:** die Dimension ist INHÄRENT hierarchisch (Knoten-Graph); „flach" war die FEHLFRAMUNG. ⟹ Option A (alles flachpressen) endgültig VERWORFEN. SOLL = jede search_algo lädt ihre NATIVE Anatomie (Array=flach, Tree/Trie/Hash=hierarchisch).
4. **Gattungs-Grenze:** SearchAlgorithm-Gattung ≠ Container-Gattung — zwei Initial-Interfaces, je eigener Achsen-Satz. Die Vereinigung darf NICHT verschmelzen: die SearchAlgorithm-Gattung DELEGIERT über die Container-Gattung, wird sie nicht.
5. **DIE AUFLÖSUNG (Thesis-Kern!):** die SearchAlgorithm-Gattung hat Achsen, die Container BENÖTIGEN → diese Achsen RUFEN die Container-Gattung AUF, über eine **CONTAINER-ACHSE INNERHALB des SearchAlgorithm-Achsen-Satzes**. Ein plain `std::vector` (= die heutigen *NodePoolStore!) VERSTÖSST FORMAL gegen den Thesis-Kern (Kontrolle über cache-aware alignment). Der so zusammengestellte Container der Container-Gattung ist GEZWUNGEN, ALLE Achseneinstellungen des Experiments zu befolgen (via Permutation komponiert).

**⟹ KONKRETES SOLL für 4b/4c:** jeder Pool-Node-Pool (heute plain std::vector/default-alloc) wird zu einem **Container-Gattungs-Container, invoked via eine Container-Achse im SearchAlgorithm-Achsen-Satz**, `<N,L,A>`-parametrisiert → obey node/layout/allocator/cache-alignment. Gattungs-Grenze gewahrt (SearchAlgorithm→Container-Achse→Container-Gattung); Defekt behoben (kein plain std::vector); Thesis-Kern (cache-aware alignment DURCHGÄNGIG) erfüllt. Das ist die exakte, saubere Form von **Option D**.

**Verworfen:** A (Byte-Arena/flachpressen — misframed die hierarchische Dimension), C (Spiegel dauerhaft — SOTA-Bäume nie real gemessen). **B** = de-scoped Zwischenschritt (search_organ_ raus via `ObservableComposedContainer`, Storage-Achsen noch Spiegel/honest-0); **ZIEL = D** (native `<N,L,A>`-Pool-Container via Container-Achse) + Wrapper-Fassaden.

---

## §4 NÄCHSTE SESSION — PLAN (nach Kompaktierung, frisch)

**PHASE 0 — Gattungs-Architektur-Recherche (ZUERST, Explore+Codex-PAAR, read-only):** bevor irgendwas gebaut wird, die Gattungs-Architektur mappen:
- Initial-Interface der SearchAlgorithm-Gattung vs der Container-Gattung (wo definiert, welche Concepts).
- Welche der ~19/21 bekannten Achsen gehören zu WELCHER Gattung; welche sind GETEILT.
- **Existiert die „Container-Achse" im SearchAlgorithm-Achsen-Satz schon** (welche Achse ist sie — node_type? eine dedizierte container-Achse?), oder ist sie NEU anzulegen?
- Der Cross-Gattungs-Delegations-Mechanismus (wie ruft eine Achse eine andere Gattung auf — vgl. Task #182 „verteilte Interfaces", `feedback` cross-achsen-delegation).
- `tier_to_organ_mapping.hpp` neu lokalisieren (Glob `**/composable/tier_to_organ_mapping.hpp` fand NICHTS → evtl. topics-Baum-Pfad; die Composed*Search-Organ-Typen kanonisch in `axes/lookup/composable/composed_*_search.hpp`).
- Refs: Gattungs-Modell = Tasks #75 (Container-Gattung), #76 (Set/Sequence/View), #87 (Adapter-Gattung), #90 (AnatomyGenus→3-Ebenen), #80/#81 (per-Gattung Docks/PermutationEngines).

**PHASE 1 — 4b-Design finalisieren** (auf Basis der Gattungs-Karte): die exakte Container-Achsen-Delegation + `PoolStore<N,L,A>`-Form + Wrapper-Fassaden-Form festlegen; Codex-review des Designs; ggf. User-Rückfrage bei offenen Gattungs-Details.

**PHASE 2 — Implementierung (inkrementell, je Increment eigener sauberer Commit + Codex, beide Remotes):**
- Inc 4b-a: `organ_for_search_algo<S>`-Trait (Pool-Analogon zu traversal_for_search_algo; Fundament) — additiv, self-proving static_asserts.
- Inc 4b-b: Container-Achse im SearchAlgorithm-Achsen-Satz verdrahten (die Delegation SearchAlgorithm→Container-Gattung) + `PoolStore<N,L,A>` (Container-Gattungs-Container, obey node/layout/allocator) — je Familie ODER als generisches Substrat.
- Inc 4b-c: abi_adapter `container_` = 3-Wege (flach für Array, nativer Container-Gattungs-Pool für Tree/Trie/Hash); `search_organ_` ENTFÄLLT; lookup/insert/erase/T0/scan/memento über container_.
- Inc 4b-d: Wrapper-Fassaden (Original-Algo lädt Composed*Search-Organ hinter dem Interface) — je Familie.
- **je Familie testen** (test_axis_sweep_pilot-Muster + Konformitäts-Gate). Harness-gated (#162), NICHT CI-verifizierbar → Codex + „später testen".
- Danach: **4a-Eytzinger** (separater User-Entscheid: BFS-Layout-Mutations-Strategie) → **#215** (320-DLL-Neubau).

---

## §5 FALLSTRICKE (kritisch)
1. **NIE die zwei Gattungen verschmelzen** (Präzisierung 4/5) — SearchAlgorithm delegiert über Container via Container-Achse; kein „container_ IST der search_algo"-Kurzschluss.
2. **KEIN plain std::vector** in den neuen Pool-Stores (Präzisierung 5, Thesis-Kern) — immer `<N,L,A>`-parametrisiert (cache-aware alignment).
3. **search_algo ist NIE flach** — Option A (Byte-Arena) ist verworfen; native hierarchische Stores.
4. **Zwei-Bäume:** Registrierung/Änderung nur im kanonischen `axes/lookup`-Baum; topics = Shim (nie anfassen); modules = vestigial.
5. **CI #210-blockiert + kein lokaler Compiler** → alle Increments = Codex + static_asserts + „später testen"; KEINE „grün"-Behauptung ohne literale Ausgabe. Harness (thesis_tiere) = MSVC, nicht CI.
6. **golden-320 NICHT brechen** (golden_fullpilot_320_binary_ids.txt + test_profile_roundtrip): First-4-EnabledStrategies + m3v2-Profil-search-Liste unverändert lassen.
7. **nie halb committen, je Increment eigener sauberer Commit + frischer Kontext** (v.a. der abi_adapter-Kern).
8. **super:** nur cache-engine-Submodul + eigene Dateien stagen, NIE thesis/diplomarbeit-Submodul; push mit fetch+**merge** (kein Rebase) bei non-ff.

---

## §6 DIREKTIVEN (stehend + diese Session)
- **NEU:** „nie die einfachste, IMMER die sauberste UND wartbarste Strategie" (User, ALLE Entscheidungen — Memory `feedback_infra_cleanest_not_easiest` generalisiert).
- **NEU:** „bei JEDEM Explore-Agent parallel einen mcp-Codex mit EXAKT derselben Aufgabe" (Codex sieht mehr; gegenprüfen — Memory `feedback_pair_explore_with_codex_same_investigation`).
- **Codex-MCP-Review** (`mcp__codex__codex`, sandbox read-only, approval never, `model_reasoning_effort:xhigh`, model weglassen) vor „done", NUR Code-Repos (cache-engine/prt-art/super/thesis), NIE Cluster/keys. Token maskieren.
- commit cache-engine + super MIT Co-Authored-By; Thesis-TEXT OHNE. NUR MERGE kein REBASE. Push BEIDE Remotes. modules/* + ext/ NIE anfassen; kanonisch `libs/cache_engine`.
- Verifikation NUR auf Pipeline (kein lokaler Compiler). Annahmen verifizieren, nie raten, Ledger/Memory zuerst lesen.

---

## §7 ZUGANG / Git / HEADs
- Repos: cache-engine (gitlab=comdare/research/comdare-cache-engine, origin=GitHub BenniProbst) + super (probst-diplomarbeit-cache-engine), je 2 Remotes, `main`, NUR MERGE.
- HEADs: cache-engine **`19d4f05`**, super **`772523b`** (Submodul→19d4f05).
- prod1 `ssh -i ~/.ssh/cluster root@10.0.10.211` (bash) · opn-1 `root@10.0.10.11` (csh). cache-engine Projekt-ID 286. CA `keys/gitlab-ca-ROOTCA-20260621.crt`.

---

## §8 START-HIER (nächste Session, nach Kompaktierung)
1. **Memory `reference_188_4b_pool_family_store_traversable_design` ZUERST lesen** (voller 4b-Design + alle 5 Präzisierungen + file:lines).
2. **PHASE 0: Gattungs-Architektur-Recherche** (Explore+Codex-Paar, §4) — Initial-Interfaces + Achsen-Sätze je Gattung + Container-Achse (existiert sie?) + Cross-Gattungs-Delegation.
3. **PHASE 1: 4b-Design finalisieren** (Codex-review, ggf. User-Rückfrage).
4. **PHASE 2: inkrementell implementieren** (4b-a Trait → 4b-b Container-Achse+PoolStore<N,L,A> → 4b-c abi_adapter → 4b-d Wrapper-Fassaden, je Familie; Codex + beide Remotes je Increment).
5. per-K-Strecke (Inc 1/2/2b) = DONE — echt-verifiziert erst beim M3-Mess-Lauf (#156) mit `-DCOMDARE_AXIS_03A_ENABLE_K_ARY_K{2,4,8,16}=ON` + cmake-Reconfigure.
