# DOSSIER #188-4c-i — Dritter Weichen-Branch: Observable-Organ-Hüllen werden container_-authoritativ

**Für: codex exec (workspace-write) im Repo `comdare-cache-engine` (HEAD `ecee6b3`).**
**Increment-Tag:** `#188-4c-i (2026-07-02)`. Teil der #188-4c-Spiegel-Eliminierung (Masterplan
`docs/sessions/20260702-MASTERPLAN-188-4c-spiegel-eliminierung-cmd-visitor.md` im Super-Repo, §2 Zeile 4c-i).
god-header-Regel: dies ist das EINE offene abi_adapter-Increment.

## 1. Problem (verifiziert am HEAD, alle Zeilennummern frisch)

Die Weiche `libs/cache_engine/anatomy/abi_adapter.hpp:1931-1970` kennt heute ZWEI authoritative Wege:
1. **StoreTraversable** (`StoreTraversableSearchAlgo<SearchAlgo>`): container_ = flacher Store + faithful
   Traversal (LinearScan/Interpolation/k-ary/per-K).
2. **pool_family_** (:1945-1946, `organ_for_search_algo_t<SearchAlgo> != void`): container_ =
   `ObservableComposedContainer<organ_for_…>` (9 Pool-Familien + Eytzinger).

Alle anderen führen `search_organ_` (authoritativ) + `container_` (SortedBinary-**Spiegel**) doppelt —
das ist der dokumentierte BUG (`store_traversable_search_algo.hpp:16-22`). Betroffen sind real:
- die **11 Reference-/PaperBinding-Compositions** (`libs/cache_engine/compositions/known_compositions_list.hpp:97-102`,
  static_assert :106 = 11), deren `search_algo` bereits eine **fertige Observable-Organ-Hülle** ist:
  `ObservableComposedContainer<XOrgan>` via Aliase `tier_to_organ_mapping.hpp:99-111`
  (ObservableArtTrieOrgan/HotPatricia/Wormhole/SurfMap/StartTrie/Masstree; art_reference.hpp:65 usw.).
  Für sie ist `organ_for_search_algo_t<ObservableComposedContainer<X>> == void` (Kommentar abi_adapter:1944)
  → sie fallen heute in den Spiegel-Zweig. **Die Hülle IST das Organ — ein Doppel-Wrap wäre falsch; der
  dritte Branch nutzt sie DIREKT als container_t.**
- die markerlosen Flach-Wrapper (Array256/VectorU8U8/VectorU16U16/Array65535, flags default OFF) —
  die bleiben in 4c-i UNVERÄNDERT im Spiegel-Zweig (faithful Organe = 4c-ii, NICHT dieser Auftrag).

## 2. Auftrag (NUR 4c-i — kein 4c-ii/iii/iv, kein Rename, keine CI-Datei)

### 2.1 Erkennungs-Trait „ist bereits Observable-Organ-Hülle"
In `libs/cache_engine/axes/lookup/composable/observable_composed_container.hpp` (direkt bei der Klasse,
Namespace `lookup::composable`; die Klasse hat GENAU EINEN Template-Parameter, :39-40
`template <class Container> class ObservableComposedContainer`):
- Primäre Vorlage `is_observable_organ_hull<T>` = false; partielle Spezialisierung für
  `ObservableComposedContainer<C>` = true. Dazu `inline constexpr bool is_observable_organ_hull_v<T>`
  (Naming-Stil analog `organ_for_search_algo_t`; gerne zusätzlich ein Concept, wenn es dem Stil der
  Datei entspricht — die bestehende Konvention der Datei ABLESEN und übernehmen).
- Doxygen-Kommentar: Zweck (dritter Weichen-Branch #188-4c-i: Referenz-Kompositionen tragen die Hülle
  bereits als search_algo → container_t = SearchAlgo direkt, kein SortedBinary-Spiegel, kein Doppel-Wrap).

### 2.2 abi_adapter.hpp — die Weiche (:1941-1960)
- Neue Konstante nach `pool_family_` (:1945-1946), z. B.
  `static constexpr bool organ_hull_ = lookup::composable::is_observable_organ_hull_v<SearchAlgo>;`
- `container_t` (:1950-1954) von 2-Wege auf 3-Wege erweitern — **LAZY-Mechanik beibehalten**
  (std::type_identity je Zweig, nicht-gewählte Zweige nur BENENNEN; Kommentar :1947-1949 erklärt warum):
  pool_family_ → ObservableComposedContainer<organ_for_…> (wie heute) · sonst organ_hull_ → **SearchAlgo
  direkt** · sonst → flat_container_t. (Verschachteltes std::conditional_t; Reihenfolge pool zuerst ist
  korrekt, die Mengen sind disjunkt — Hüllen haben organ_for==void, :1944.)
- `container_is_authoritative_` (:1959-1960) um `|| organ_hull_` erweitern.
- Damit folgen AUTOMATISCH (NICHT anfassen, nur im Bericht bestätigen): insert :753, lookup :837,
  erase :888, clear/reset :904/:932/:937 (requires-gated, search_organ_ bleibt leer), T0-Observer-Quelle
  :1011, T0-Segment-Timing do_batch :1341, `tier_search_routes_through_store()` :1777 (→ true für die 11),
  honest-0 der Speicher-Achsen T4/T5/T6 via `container_is_store_backed_` :1970 (Hülle hat kein
  `store_type` → requires false → prefetch :808/:865 + tier_scan + allocator-Stellen schalten selbst),
  Memento/CoW (saved_container_-Typen :2043/:2047/:2053 folgen container_t; cow_capable_ :2086-2089
  unverändert — die Hülle wird heute schon als search-Hälfte gesichert, es tauschen nur die Rollen;
  saved_search_-Hälfte bleibt BEWUSST bis 4c-iii).

### 2.3 Key-Ernte-Kaskade (:1304-1327) — die EINE Stelle, die NICHT automatisch folgt
Heute: Zweig 2 (:1309-1316) ist auf `pool_family_ && requires container_.for_each_record` gegated;
Zweige 3+4 (:1317-1327) lesen aus `search_organ_`. Nach dem Flip ist search_organ_ für die 11 LEER →
Zweige 3+4 ernteten NICHTS → **neue keys={0}-Degeneration für alle 11** (seg_ns der per-op-Achsen
entwertet). FIX: Zweig-2-Bedingung von `pool_family_` auf `container_is_authoritative_` verallgemeinern
(deckt Pools+Eytzinger wie bisher — pool ⊂ authoritative, verhaltensidentisch — UND jetzt die
Referenz-Hüllen; Zweig 1 StoreTraversable bleibt DAVOR unverändert; Zweige 3+4 bleiben für
nicht-authoritative Flach-Wrapper). Kommentar :1311-1314 + :1322-1325 anpassen: die 10/11-Deckung
(Masstree-Organ ohne for_each_record-Walk degeneriert weiter BEWUSST auf {0}, nachziehen bei #234)
gilt jetzt über den container_-Zweig statt über search_organ_.

### 2.4 Einzige erlaubte Test-Änderung: der 4c-0-Baseline-Flip
`tests/unit/test_188_4c0_known_compositions_conformance.cpp:155-161`
(Testfall `SearchRoutingBaselineStillUsesMirrorBefore1884c`): `EXPECT_FALSE(routes_through_store)` →
`EXPECT_TRUE(routes_through_store)`; Testfall-Namen auf die neue Wahrheit umbenennen (z. B.
`SearchRoutingIsStoreAuthoritativeSince1884ci`) + Datei-Kopf-/Testfall-Kommentar nachziehen (der
Kommentar kündigt den Flip als „einzige erlaubte Test-Änderung" an — jetzt einlösen).
**KEINE weiteren Test-Dateien ändern.** (`test_m8_storetrav_segment.cpp:69-70` prüft ==true für
LinearScan — bleibt wahr, NICHT anfassen. Sollte deine Analyse weitere Tests finden, die auf das ALTE
Routing der Referenzen asserten: im Bericht MELDEN, nicht fixen.)

### 2.5 Kommentar-Wahrheits-Fixes im abi_adapter (Pflicht, klein)
Nach dem Flip werden diese Kommentare falsch/unvollständig — präzise nachziehen:
- :1944 („Die 11 Reference-Compositions tragen die u64-Huelle bereits als search_algo -> … -> hier
  flach") → jetzt: dritter Branch nutzt die Hülle direkt.
- :1955-1958 (container_is_authoritative_-Aufzählung) + :1773-1776 (routes_through_store-Aufzählung):
  um die Hüllen-Gruppe ergänzen; „nur die markerlose Default-Flachgruppe bleibt search_organ_" wird
  jetzt WAHR — so formulieren.
- Weg-B-Kommentare an den Op-Verzweigungen :746-752, :835, :887 („Weg-B (Trie/Pool)…"): Weg-B ist
  nach 4c-i NUR noch die markerlose Flachgruppe — Formulierungen entsprechend schärfen.
- :1749-1752 (§3.3-Ausnahme (1)): Präzisieren, dass seit 4c-i wirklich NUR noch die Flachgruppe den
  search_organ_-Monolith liest.

## 3. Verhaltens-Matrix (SOLL nach 4c-i — im Bericht je Gruppe bestätigen)

| Gruppe | container_t | authoritativ | routes | Ernte | T4/T5/T6 |
|---|---|---|---|---|---|
| StoreTraversable (LinearScan/Interp/k-ary/per-K) | flat (Store+faithful Traversal) | true (wie heute) | true | Zweig 1 save_state (unverändert) | real (store-backed) |
| organ-backed (9 Pools + Eytzinger) | ObservableComposedContainer<organ_for> | true (wie heute) | true | Zweig 2 for_each_record (Bedingung verallgemeinert, verhaltensgleich) | honest-0 (wie heute) |
| **NEU: Organ-Hüllen (11 Referenzen + weitere mit gleichem search_algo-Typ)** | **SearchAlgo direkt** | **true (NEU)** | **true (NEU, Test-Flip)** | **Zweig 2 for_each_record (10/11; Masstree bewusst {0})** | **honest-0 (automatisch via store_backed=false)** |
| markerlose Flach-Wrapper (default OFF) | flat | false | false | Zweige 3/4 | real |

WICHTIG: `prt_art_reference.hpp:61` + `prt_art_merge_reference.hpp:78` tragen denselben
search_algo-Typ (ObservableArtTrieOrgan bzw. delegiert) → sie flippen MIT. Das ist GEWOLLT
(Spiegel-Eliminierung überall, wo die Hülle das Tier ist). Im Bericht ALLE mitgeflippten
Kompositionen listen (grep nach den Observable*Organ-Aliasen in compositions/).

## 4. TABU / Leitplanken
- `modules/**` + `ext/**` NIE anfassen. Golden-320-Dateien + Registry-mp_list (Struktur/Reihenfolge) tabu.
- `tests/unit/CMakeLists.txt` + `.gitlab-ci.yml` NICHT anfassen (Integrator zieht die 2 dortigen
  Baseline-Kommentare nach; es braucht KEIN neues Target — der bestehende contract:conformance-Job
  beweist den Flip).
- Golden-320-Verhalten MUSS byte-identisch bleiben: Gruppen 1+2 der Matrix dürfen sich NICHT ändern
  (Zweig-2-Verallgemeinerung ist für Pools verhaltensgleich, weil pool_family_ ⊂ authoritative — im
  Bericht explizit argumentieren).
- Kein git. Keine $null-/~NNNNN-Artefakte. EOF: genau EIN Newline am Dateiende, keine Trailing-Spaces.
- C++23, Boost.MP11-Stil der Umgebung; Kommentar-Dichte/Idiom der Datei übernehmen (deutsch, mit
  Increment-Tags wie die Nachbar-Kommentare).

## 5. Bericht (am Ende ausgeben)
(a) Diff-Zusammenfassung je Datei mit Zeilen; (b) Bestätigung der Automatik-Stellen aus §2.2 (je Stelle
1 Satz warum sie ohne Edit korrekt bleibt); (c) Liste ALLER Kompositionen, die durch den dritten Branch
authoritativ werden (11 + prt_art-…); (d) Argument Golden-320-Neutralität; (e) Risiken/Unsicherheiten;
(f) ggf. gefundene weitere Tests, die auf altes Routing asserten (nur melden).
