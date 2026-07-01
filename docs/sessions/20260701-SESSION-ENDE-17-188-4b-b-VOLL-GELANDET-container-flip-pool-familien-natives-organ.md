# SESSION-ENDE-17 (KONTEXT-ENDE) — #188-4b-b VOLL GELANDET: der container_-Flip (9 Pool-Familien messen ihr natives u64-Organ, Mess-Pfad-Defekt behoben)

> **Datum:** 2026-07-01 · **Agent:** Impl-Agent (cache-engine, autonomes /goal) · **Vorgänger:** SESSION-ENDE-16 (`4d2a533`, dort per-K-Detail + 4b-Design-Basis + die 5 Präzisierungen).
> **Diese SE-17 = der FINALE Stand bei Kontext-Ende.** Sie dokumentiert: (a) die Thesis-Konsolidierung des 4b-Plans (Workflow + Codex korrigierten die Design-Rahmung), (b) die VOLL gelandete 4b-b-Strecke (4 Increments, der container_-Flip), (c) die zu behebenden DEGENERATIONEN, (d) TODOs/Fallstricke/Direktiven für die enorm komplexe 4b-c/D-Strecke.
> **⚠️ ALLERWICHTIGSTE 4 Dinge nächste Session:** (1) **Memory `reference_188_4b_pool_family_store_traversable_design` ZUERST lesen** (voller Design + alle Abschnitte WORKFLOW-KONSOLIDIERUNG + PHASE-0 + FREIGABE-GATE-R1/R2 + 4b-b-DONE). (2) **Die 4b-b-Strecke ist NOCH NICHT pipeline-compiliert** (nur Codex + static_asserts) → **erster Schritt = Pipeline/Harness-Compile-Verifikation** BEVOR auf 4b-b aufgebaut wird (s. §4/§10). (3) **Eine dokumentierte DEGENERATION** (Pool-seg_ns Key-Ernte → {0}) markiert in §4 — mit-beheben in 4b-c/D. (4) **NIE die zwei Gattungen verschmelzen; die Storage-Achsen der Pools sind aktuell honest-0 (by design), NICHT vergessen sie in 4b-c/D real zu machen.**

---

## §0 HEADs / Status
- **cache-engine** `main` = **`cd25b9b`** (#188-4b-b1b, der Flip). Arbeitsbaum sauber.
- **super (Diplomarbeit)** `main` = **`c5bc581`** (Submodul→cd25b9b + SE-17 wird ergänzt). thesis/diplomarbeit UNBERÜHRT.
- **cluster** unverändert.
- **beide Remotes** (origin=GitHub + gitlab) auf allen o.g. SHAs synchron.
- **Verifikations-Stand:** Codex-verifiziert (mehrere adversarische Runden), static_asserts, Weit-Key-Test — **ABER KEIN Pipeline-Compile** (kein lokaler Compiler; #210/#230-Harness-Gap). Keine „grün"-Behauptung ohne literale Ausgabe.

---

## §1 Was diese Session geschah (chronologisch)
1. **ultracode-Workflow `woyz8s9us`** (aus SE-16) eingeholt (lief noch; Task-ID `woyz8s9us`, NICHT die `wf_`-Anzeige-ID) → **thesis-fundierte Konsolidierung des 4b-Plans** (8 Agenten, 1,33 M tok, Codex-verifiziert; 1 Reader `thesis:mess` errte StructuredOutput-Cap, via Codex+Plan-Abgleich gedeckt). Raw = `docs/sessions/20260701-WORKFLOW-woyz8s9us-…RAW.md`.
2. **Architektur-Korrektur** (§2): der Workflow fand die Ur-Rahmung (Präz. 4/5: „Container-Achse"/cross-Gattung) **thesis-widrig** → korrigiert zu **intra-Gattungs-Speicher-Organ**.
3. **Freigabe-Gate R1** (User): intra-Gattung angenommen · PMC=separates 4c · Nicht-Trie=per-Familie **Node-Shape-Achse** · SOTA-Adapter+Konformitäts-Gatter Pflicht · Graph out-of-scope.
4. **PHASE-0-Recherche** (Explore+Codex-Paar): der Code dokumentiert die SOLL-Richtung SELBST (`store_traversable_search_algo.hpp:16-22`); **Zwei-Populationen-Befund** (u16-Monolith-AdHoc vs u64-Organ-Reference).
5. **Freigabe-Gate R2** (User, Design-GO): per-Familie eigene Shape-Achse · Hash VOLL open-addressing↔chaining · Gerüst+wenige Levels Default-OFF · JETZT starten.
6. **4b-b implementiert** (User „ziehe die gesamte Aufgabe bis zum Ende durch"): 4 Increments (§3), alle Codex-reviewed, beide Remotes. Codex fing dabei **3 echte Bugs** (behoben): seg-T0-lookup-Routing, tier_clear-Statistik-Reset, SurfPaperBinding-Inkonsistenz.

---

## §2 ARCHITEKTUR-KONSOLIDIERUNG — die Thesis-Korrektur (das Herz; ersetzt SE-16-Präz. 4/5 im MECHANISMUS, NICHT im Ziel)

**Der reale Defekt (bestätigt):** bei den 9 Weg-B-Pool-Familien war `container_` ein flacher **SortedBinary-Spiegel** über `LayoutAwareChunkedStore`, `search_organ_` = das echte Pool-Organ → die SOTA-Bäume maßen einen **Neben-Apparat** (Storage-Achsen T4/T5/T6 am Spiegel statt an der nativen Struktur; T0-Metrik am u16-Monolith-Wrapper mit Truncation).

**6 KORREKTUREN (thesis-widrig, Codex-belegt — raus aus dem Ur-Plan):**
1. **KEINE „Container-Achse"** im SearchAlgorithm-Achsen-Satz. Container ist eine **Ebene-1-Gattung** (Geschwister unter `IAnatomyBase`, `anatomy_base.hpp:32,67`), keine Achse T0-T18. Das Storage-Substrat ist ein **Speicher-Organ INNERHALB der SearchAlgorithm-Gattung**.
2. **KEINE cross-Gattungs-Delegation.** Thesis kennt nur intra-organische Delegation; Code schließt Cross-Genus explizit aus (`adapter_abi_adapter.hpp:27`).
3. **„search_algo NIE flach" nur für die Config-Dimension wahr** (Permutations-Baum). Die Laufzeit-Struktur ist NICHT inhärent hierarchisch (T0-Default `Array256` flach). Belastbar: Pool-Familien nicht uniform auf EINEN flachen Spiegel pressbar.
4. **„plain std::vector verstößt formal gegen Thesis-Kern" → FALSCH.** Kein Thesis-Verstoß, sondern ein **Code-Validitätsdefekt** (T5/T6 greifen nicht nativ auf dem Messpfad). Einziges FORMALES Gatter = std::map-Konformitäts-Vertrag.
5. **„Permutations-B+-Baum" → „Permutations-Baum"** (Code `ExperimentTree` = Präfixbaum, NICHT textbook-B+). GoF-Hygiene #224.
6. **Uniformes `PoolStore<N,L,A>` → per Familie** (node_type/T4 ist trie-spezifisch; SwissTable-Präzedenz).

**KORRIGIERTE ZIELFORMEL (im Code umgesetzt):** *SearchAlgorithm bleibt eigene Gattung. Die T0-Suche der Pool-Familien läuft INTRA-Gattung über ihr **natives Speicher-Organ**, das die (per-Familie gültigen) Storage-Achsen konsumiert. `container_` ist kein Spiegel mehr; `search_organ_` entfällt als autoritative Quelle.* Dein ZIEL (native Stores, kein Neben-Apparat) ist ERREICHT — nur der Mechanismus/das Framing wurden thesis-sauber.

**ZWEI-POPULATIONEN-BEFUND (kritisch für das Verständnis):**
- **Generierte Permutations-Pool-Binaries (die ~320):** `Composition::search_algo` = **roher u16/u8-Wrapper** (`BinarySearchTreeSearchAlgo` u16 / `OriginalArtSearchAlgo` u8) → `organ_for_search_algo_t<S>` non-void → **DER FLIP trifft SIE.**
- **11 Reference/PaperBinding-Compositions:** `search_algo` = **u64-Organ-Hülle** (`Observable*Organ`) → `organ_for_search_algo_t == void` → `pool_family_==false` → **AUTOMATISCH unberührt.** (Ausnahme war `surf_paper_binding` — nutzte rohen Wrapper; diese Session an das #42-Muster angeglichen.)

---

## §3 Was gebaut wurde — die 4b-b-Strecke (4 Increments, file:line)

**4b-a `e564b66` — der Trait (Fundament):** `axes/lookup/composable/organ_for_search_algo.hpp` (NEU). Spiegel von `traversal_for_search_algo<S>`: mappt jede der 9 Pool-Familien-Wrapper → ihr natives `Composed*Search`-Organ (roh; primär `void`). 9 Mapping- + 6 „3-Wege-Split"-static_asserts. Registry-Include in `axis_03a_search_algo_registry.hpp`. **Die 9 registrierten Familien = {ART, HOT, START, Wormhole, SuRF, SkipList, Hash, BST, BTree}** — NICHT Masstree (deferred, kein Wrapper in AllStrategies).

**4b-b0 `3abc1e3` — Organ-Konformität (Prerequisite):** `tests/unit/test_188_4bb0_pool_organ_wide_key_conformance.cpp` (gtest, Haupt-Suite, voller Organ-Include-Stack wie `test_v41_topic_traversal`). Belegt: die 9 Organe (`ObservableComposedContainer<organ_for_search_algo_t<Wrapper>>`) verhalten sich wie `std::map<u64,u64>` über [0, UINT64_MAX] inkl. ≥2^16 (u64-korrekt; Truncation-Probe key 0 vs 65536 distinkt; static_assert key_type==u64). **Nötig weil** der Prod-Konformitäts-Gate truncation-BLIND ist (nur Keys < 2^16) + die 9 Organe von KEINER Reference verhaltens-getestet werden. Codex read-verified alle 9 = u64+update-korrekt.

**4b-b1a `962a5eb` — store-Guards (verhaltens-neutrales Fundament):** in `anatomy/abi_adapter.hpp`: `static constexpr bool container_is_store_backed_ = requires { typename container_t::store_type; };` (Sammel-Proxy — alle store-APIs existieren gdw. store_type existiert). Damit gegatet: prefetch-descent (insert/lookup), tier_scan/scan_range, allocator-stats (fill_observer_v3 + 2. observe-Pfad, **genestet** wg. store_type-Referenz in der Bedingung). → bei nicht-store-backed container_ (Pool) honest-0 statt hard error. HEUTE verhaltens-neutral (flacher container_t erfüllt store_type). Codex SHIP-WITH-NITS.

**4b-b1b `cd25b9b` — DER FLIP:**
- `flat_container_t` (der bisherige flache Typ) + `static constexpr bool pool_family_ = !is_same_v<organ_for_search_algo_t<SearchAlgo>, void>` + `container_t = typename std::conditional_t<pool_family_, std::type_identity<ObservableComposedContainer<organ_for_search_algo_t<SearchAlgo>>>, std::type_identity<flat_container_t>>::type` (**LAZY** via `type_identity` — vermeidet `ObservableComposedContainer<void>` für Nicht-Pools, das `void::key_type` ill-formed wäre) + `container_is_authoritative_ = StoreTraversableSearchAlgo<SearchAlgo> || pool_family_`.
- **Routing auf `container_is_authoritative_`:** tier_insert (:753-Zweig), tier_lookup (:837), tier_erase (:888), T0-Observer (`fill_observer_v3`, :1010), T0-Segment-Timing (`fill_segment_timing_v3/do_batch`, :1326), `tier_search_routes_through_store()`.
- **tier_clear:** NEU `if constexpr (requires { container_.reset(); }) container_.reset();` (Pool-T0-Statistik je Messung nullen — `ObservableComposedContainer::clear()` leert nur Daten, nicht `stats_`; idempotent für store-traversierbar).
- `search_organ_` bleibt Member (leer für Pools; Memento/CoW unberührt — Codex-bestätigt).
- Includes: `organ_for_search_algo.hpp` + `observable_composed_container.hpp`.
- `compositions/surf_paper_binding_reference.hpp`: `search_algo` von rohem `OriginalSurfSearchAlgo` → `composable::ObservableSurfMapOrgan` + `paper_source = OriginalSurfSearchAlgo` (#42-Muster, wie ART/HOT/START/Wormhole).
- **Codex 3 Runden** (2 FIX behoben + 1 Blocker: SurfPaperBinding) → SHIP-WITH-NITS. **super `c5bc581`.**

**BIT-IDENTISCH geblieben:** store-traversierbare (LinearScan/Interpolation/k-ary), Default-Flach (Array256/Vector*/Eytzinger), alle 11 References. Kein M3-Pin-Effekt.

---

## §4 ⚠️ DEGENERATIONEN / LIMITs (MARKIERT — in 4b-c/D zu beheben)

**⚠️ DEG-1 (Pool-Segment-Timer-Key-Ernte → {0}):** In `fill_segment_timing_v3` (`abi_adapter.hpp:~1302`) erntet der Key-Satz `keys[]` für die per-op-Segment-Timings aus `container_.save_state()` (nur store-traversierbar) bzw. `search_organ_.save_state()` (MementoAxis). Für **Pool-Familien** ist `search_organ_` nach dem Flip **LEER** (nicht mehr beschrieben) und `ObservableComposedContainer` hat **KEIN `save_state`/Key-Iteration** → `keys={0}, nk=1` → die per-op-`seg_ns[T0..]` fragen n_ops-mal Key 0 (Miss) = **degenerierte Segment-Timing-Messung für Pools.** 
   - **KEIN** Compile-/Crash-/Datenkorrektheitsfehler. **KEIN** Observer-T0-Fehler (der OBSERVER-T0 aus `container_.statistics()`, `fill_observer_v3`, trägt die REALEN Op-Zähler + ist korrekt; er läuft VOR dem Segment-Timer im selben Snapshot).
   - **FIX (4b-c/D):** `save_state()`/`for_each_record()` an `ObservableComposedContainer` ergänzen (delegiert an das Organ, falls MementoAxis) → Key-Ernte aus `container_` auch für Pools → echte per-op-Segment-Timings. LIMIT #226-Stil im Appendix vermerken bis dahin.

**⚠️ DEG-2 (Storage-Achsen T4/T5/T6 der Pools = honest-0, BY DESIGN in B):** Nach dem Flip trägt `container_` (natives Organ) **kein** `store_observe_node_type/layout/allocator` → die 4b-b1a-Guards schalten sie auf **honest-0** für die 9 Pool-Familien. Das ist der **gewollte B→D-Zwischenzustand** (nicht ein Bug), aber es MUSS in 4b-c/D real gemacht werden (per-Familie Node-Shape-Achse + `<shape,L,A>`-Pool-Store + observe-Hooks), sonst bleiben node/layout/allocator der SOTA-Bäume unvermessen. **NICHT als „fertig" markieren, bevor 4b-c/D die Storage-Achsen real macht.**

**Hinweis:** Die per-op-Achsen T1/T2/T3… für Pools hängen an `keys[]` (DEG-1) → sie degenerieren mit. DEG-1-Fix behebt beide.

---

## §5 TODOs / PLAN nächste Session (4b-c/D — User-approved R2)

**PHASE V (VOR allem Weiteren): Pipeline-Compile-Verifikation der 4b-b-Strecke.** Alles ist Codex-verifiziert, aber NICHT compiliert. Erster Schritt: die 4b-b-Strecke (cache-engine `cd25b9b`) real bauen — entweder (a) den grünen contract-Stage-Pfad nutzen + einen 4b-b-berührenden compile-Job triggern, oder (b) den thesis_tiere-Harness / Haupt-gtest-Suite lokal/CI compilieren (test_188_4bb0 + eine Pool-Composition). **Erst grüner Compile, dann 4b-c/D bauen** (sonst baut man auf unverifiziertem Fundament). Siehe §10-Rückfrage.

**PHASE 4b-c/D (per-Familie, GROSS — je Familie eigener Commit + Codex + beide Remotes):**
- **DEG-1-Fix zuerst** (Key-Ernte-Capability zu ObservableComposedContainer) — entsperrt echte per-op-Segment-Timings für ALLE Pools auf einmal.
- **Per-Familie Node-Shape-Achse + nativer Store `<shape,L,A>` + `organ_observe_*`-Hooks:** Reihenfolge **BTree → SkipList → BST → Hash** (sauberste zuerst, Hash tiefste zuletzt). Level-Kandidaten (aus dem Code destilliert, Memory-Abschnitt B6): BTree kT∈{2,3,4,8,16}/alignas/child-idx (Split/Merge liest `Pool::kMaxKeys`); SkipList max_level{8,16,32}/RNG-p/Level-Array; BST Zeiger-Packing{u16/u32/size_t}/Balance{none/RB/AVL}; **Hash VOLL open-addressing↔chaining** (Store + `hash_probe_traversal_organ.hpp:48-49`-Load-Factor gemeinsam) + slot-packing/tombstone. Tries (ART/HOT/START/Wormhole/SuRF) nutzen bestehendes **T4/T5/T6**.
- **Achse-hinzufügen 5-Schritt** (Vorlage axis_04/axis_03a): Header+Strategy+Concept → Registry (`AllStrategies`/`mp_filter`) → `*_flags.hpp.in` → CMake `option()`+`foreach USE_`+`configure_file` → Test. Default-OFF opt-in (per-K-Präzedenz `CMakeLists.txt:256-259`) → Binaries beschränkt.
- **Je Umbau:** std::map-Konformitäts-Gatter grün, dünnen SOTA-Adapter `COMDARE_HAVE_<X>` erhalten, EIN Lebewesen je Permutation, kein Cross-Genus.

**DANACH:** #188-4a-**Eytzinger** (BFS-Layout-Mutations-Strategie, User-Entscheid) → **#215** (320-DLL-Neubau, Wirksamkeits-Schleuse) → **#156/#162** (M3-Messung). **PMC = separates 4c** (COMDARE_ENABLE_PMC OFF/NullPmcSource; die eigentliche cache-aware-Kern-Lücke der Thesis — 02:596-599).

---

## §6 FALLSTRICKE (kritisch, wegen der enormen Komplexität)
1. **NIE die zwei Gattungen verschmelzen** (SearchAlgorithm ≠ Container). Der Fix ist intra-Gattung (Speicher-Organ), KEINE „Container-Achse" (thesis-widrig, Cross-Genus im Code verriegelt).
2. **ZWEI Populationen:** der Flip trifft NUR die generierten Wrapper-search_algo-Binaries (`organ_for_search_algo_t != void`); References (Organ-Hülle als search_algo) sind automatisch `pool_family_==false`. **Ein neues PaperBinding mit rohem Wrapper würde umgeroutet** — an das #42-Muster (Organ-Hülle + paper_source) angleichen (wie SuRF).
3. **LAZY container_t-conditional (type_identity):** NIE `conditional_t<pool, ObservableComposedContainer<organ>, flat>` direkt — für Nicht-Pools wäre `ObservableComposedContainer<void>` ill-formed. Immer via `type_identity<…>::type`.
4. **store-abhängige Mess-Stellen:** `container_is_store_backed_` gatet sie (prefetch/scan_range/allocator/store_observe). Bei 4b-c/D, wenn der Pool-Store store_observe_* bekommt, muss `container_is_store_backed_` ggf. neu gedacht werden (dann trägt auch der Pool-container_ Storage-APIs). **Nicht blind die Guards entfernen** — erst prüfen, welche APIs der neue Pool-Store trägt.
5. **DEG-1 (Key-Ernte):** der Segment-Timer degeneriert für Pools auf {0} bis die Key-Ernte-Capability da ist. **NICHT als vollständige Messung markieren.**
6. **CI #210-blockiert + KEIN lokaler Compiler** → per Increment: Codex + static_asserts + „später testen"; KEINE „grün"-Behauptung ohne literale Ausgabe. Der Haupt-gtest-Suite-CI-Status ist unklar (#230-Harness-Gap) → 4b-b0 läuft dort, nicht in der contract-Stage.
7. **golden-320 / m3v2-Profil:** First-4-EnabledStrategies + Profil-search-Liste NICHT brechen. Der Flip ändert die T0-QUELLE der Pools (Wrapper→Organ), aber NICHT die EnabledStrategies-Liste.
8. **`search_organ_` bleibt Member** (leer für Pools) — NICHT entfernen (Memento saved_search_m_/saved_search_, tier_clear, CoW hängen dran; für Pools harmlos, für Default-Flach nötig).
9. **super:** nur cache-engine-Submodul + eigene docs/sessions stagen, NIE thesis/diplomarbeit-Submodul; push fetch+**merge** (kein Rebase) bei non-ff. CRLF-Warnungen = harmlose Zeilenende-Normalisierung.

---

## §7 DIREKTIVEN (stehend + diese Session — bei enormer Komplexität ZWINGEND)
- **„bei JEDEM Explore-Agent parallel einen mcp-Codex mit EXAKT derselben Aufgabe"** — hat diese Session mehrfach Fehler abgefangen (2-Populationen-Befund, 4b-b-Blocker). Memory `feedback_pair_explore_with_codex_same_investigation`.
- **Codex-Review vor „done"** (`mcp__codex__codex`, sandbox read-only, approval never, `model_reasoning_effort:xhigh`, model weglassen) — hat in 4b-b1b **3 echte Mess-Bugs** gefangen (seg-T0-Routing, tier_clear-reset, SurfPaperBinding). NUR Code-Repos (cache-engine/prt-art/super/thesis), NIE Cluster/keys. Token maskieren.
- **„nie die einfachste, IMMER die sauberste UND wartbarste Strategie"** (User) — z.B. `container_is_store_backed_`-Sammel-Proxy statt 12 verstreute requires; per-Familie Node-Shape-Achse statt T4-Nichtbelegung.
- **„#188 nie halb committen, je Increment eigener sauberer Commit + frischer Kontext"** — v.a. der delikate abi_adapter-Kern. Diese Session hat 4b-b bewusst in 4 Increments zerlegt + je committet.
- **Verstehe-es-erst / nie-raten:** Annahmen verifizieren, Ledger/Memory ZUERST lesen, bei schweren Entscheidungen User fragen (diese Session: 2 Freigabe-Gates eingeholt).
- commit cache-engine + super MIT `Co-Authored-By: Claude Opus 4.8 (1M context)`; Thesis-TEXT OHNE. NUR MERGE kein REBASE. Push BEIDE Remotes (origin + gitlab). modules/* + ext/ NIE anfassen; kanonisch `libs/cache_engine`.
- **verify ONLY on pipeline** (kein lokaler g++/clang++/cl; nur cmake). Keine Erfolgsmarke ohne literale Ausgabe.

---

## §8 ZUGANG / Git / HEADs
- Repos (je 2 Remotes, `main`, NUR MERGE): cache-engine (gitlab=comdare/research/comdare-cache-engine, origin=GitHub BenniProbst) + super (probst-diplomarbeit-cache-engine).
- **HEADs: cache-engine `cd25b9b`, super `c5bc581`** (Submodul→cd25b9b; thesis unberührt).
- prod1 `ssh -i ~/.ssh/cluster root@10.0.10.211` (bash) · opn-1 `root@10.0.10.11` (csh). cache-engine Projekt-ID 286. CA `keys/gitlab-ca-ROOTCA-20260621.crt` · curl `--cacert <CA> --ssl-no-revoke`.
- **Memories (diese Session aktualisiert):** `reference_188_4b_pool_family_store_traversable_design` (VOLLER 4b-Design + WORKFLOW-KONSOLIDIERUNG + PHASE-0 + FREIGABE-R1/R2 + **4b-b-DONE**). Raw-Workflow = `docs/sessions/20260701-WORKFLOW-woyz8s9us-…RAW.md`.

---

## §9 START-HIER (nächste Session, nach Kompaktierung)
1. **Memory `reference_188_4b_pool_family_store_traversable_design` lesen** (kompletter Stand + DEG-1/DEG-2 + 4b-c/D-Plan).
2. **PHASE V:** die 4b-b-Strecke (`cd25b9b`) pipeline/harness-**compilieren** (grüner Compile-Beleg) BEVOR 4b-c/D. (s. §5, §10-Rückfrage.)
3. **DEG-1-Fix** (Key-Ernte-Capability zu ObservableComposedContainer) — kleiner, entsperrt echte Pool-Segment-Timings.
4. **4b-c/D per-Familie** Node-Shape-Achse (BTree→SkipList→BST→Hash) + `<shape,L,A>`-Pool-Store + observe-Hooks → echte Storage-Achsen. Je Familie Codex + Konformitäts-Gatter + beide Remotes.
5. **DANACH:** 4a-Eytzinger → #215 (320-DLL) → #156/#162 (Messung). PMC=4c separat.

---

## §10 RÜCKFRAGEN — offen (für die erste Instanz nächste Session)
1. **Verifikations-Reihenfolge:** Erst die 4b-b-Strecke real pipeline/harness-**compilieren** (grüner Beleg) BEVOR 4b-c/D — oder direkt 4b-c/D und am Ende alles zusammen compilieren? (Empfehlung: erst compilieren — kein Aufbau auf unverifiziertem Fundament.)
2. **DEG-1-Timing:** Key-Ernte-Capability (ObservableComposedContainer.save_state/for_each_record) als EIGENER früher Increment (behebt alle Pool-seg_ns auf einmal), oder gebündelt in die erste Node-Shape-Familie (BTree)?
3. **Node-Shape-Achsen-Granularität:** 4 separate Achsen (BtreeOrder/SkipListShape/BstShape/HashProbeShape) — bestätigt (R2)? Oder beim Bauen doch EINE `node_shape`-Achse mit familien-getaggten Levels erwägen, falls der Registry-/Flags-Overhead von 4 Achsen zu groß wird?

### ⟹ BEANTWORTET (User 2026-07-01, Kontext-Ende) — VERBINDLICHE REIHENFOLGE nächste Session
1. **Verifikation → ERST 4b-b real compilieren, DANN 4b-c/D.** Die 4b-b-Strecke (`cd25b9b`) zuerst über Pipeline/Harness bauen (grüner, LITERALER Compile-Beleg) — kein Aufbau auf nur-Codex-verifiziertem Fundament. Das ist **PHASE V, der allererste Schritt** (nach Memory-Lesen). Fängt einen etwaigen `type_identity`-Metaprogramm-/Routing-Fehler früh.
2. **DEG-1 → eigener FRÜHER Increment ZUERST** (vor den Node-Shape-Familien): Key-Ernte-Capability (`save_state()`/`for_each_record()` an `ObservableComposedContainer`, delegiert ans Organ falls MementoAxis) → behebt die per-op-`seg_ns`-Degeneration für ALLE 9 Pool-Familien auf einmal, sauber isoliert.
3. (Q3 Node-Shape-Granularität: R2 = per-Familie 4 Achsen bleibt; EINE getaggte Achse nur als Notfall-Option, falls der 4-Achsen-Overhead beim Bauen real zu groß wird — Impl-Entscheid, kein neuer User-Gate.)

⟹ **START-HIER-REIHENFOLGE (final):** Memory lesen → **PHASE V (4b-b compilieren, grün belegen)** → **DEG-1-Fix (Key-Ernte-Capability, eigener Increment)** → **4b-c/D per-Familie Node-Shape-Achse (BTree→SkipList→BST→Hash)** → 4a-Eytzinger → #215 → #156/#162. PMC=4c separat.
