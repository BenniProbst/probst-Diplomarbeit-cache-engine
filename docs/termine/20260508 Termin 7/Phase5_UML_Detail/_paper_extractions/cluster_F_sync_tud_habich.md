# Cluster F — Sync + TUD-Habich

Tieflektuere von 6 Forschungspapern fuer Cache-Strategien und Algorithmus-Strategien-Verallgemeinerung. Architekturbezug:
- **Saeule A:** IPage / IRootPage / IFanout / INode / ISearchPage / ICachePage / ICacheStrategy (Visitor)
- **Saeule B:** ICacheLevel / ICacheLine / ICacheTopology / ICacheResidency / ICpuCore / ICoreLayout / ICoreToThreadMap / IPinningPolicy / IHardwareExtension / IIsaFeatureSet / IInterconnect / IBusTopology / IMemoryBandwidthModel / ILivePlatformModel / ILiveCpuModel / IScheduler / IHeuristic
- **ConcurrencyManager:** 8 Disziplinen (Page, Node, Array, DataStructure, Path, MemoryRead, MemoryWrite, MemoryReadWrite, SimdThread, SimdFlow) + 3 Mechaniken (OLC, ROWEX, RCU)

---

## P08 ART of Practical Synchronization (Leis/Scheibner/Kemper/Neumann 2016, DaMoN'16)

### 1. CACHE-STRATEGIEN
- **Cache-Line-Centric Lock-Awareness (§3, §5.1):** Traditionelles Lock-Coupling wird auf modernen Multi-Core-CPUs explizit als cache-feindlich identifiziert: jedes `readLock(node)` schreibt in die Lock-Variable und invalidiert dadurch die Cacheline auf allen anderen Cores ("Threads fight for exclusive ownership of the cache line holding the lock"). Root-Knoten und Knoten nahe der Wurzel werden so zu Contention-Points. Messdaten (§5.1) zeigen: Lock-Coupling skaliert von 211→2787 Zyklen (Faktor 6.6x) und L1-Misses 5.2→9.0 beim Uebergang 1→20 Threads.
- **Optimistic Read = Lese ohne Schreiben (§3.1):** Reader fuehren nur Loads auf der Lock/Version-Variable durch (`readLockOrRestart` ist read-only auf den Lock-Bits) → keine Cacheline-Invalidations bei reinen Lesern. Direkte Konsequenz: skaliert dramatisch besser bei read-mostly Workloads.
- **Single 64-Bit Atomic Word fuer Lock+Version+Obsolete-Flag (Appendix A):** Lock-Bit, Obsolete-Bit, Version-Counter alles in einem 64-Bit-Wort im Node-Header — minimiert Cacheline-Footprint und nutzt EINE atomare Operation.
- **Path Compression als Cache-Strategie (§2):** Reduziert Tree-Hoehe → weniger Cacheline-Loads pro Lookup. Header speichert Prefix von Key-Bytes, was indirekt Cache-Effizienz fuer lange Keys (Strings) erhoeht.
- **Adaptive Node Types (§2):** Node4/Node16/Node48/Node256 — adaptive Knotenstruktur reduziert Speicher-Footprint und damit Working-Set in Caches; CPU-Statistiken (§5.1) zeigen 3.6x weniger L3-Misses fuer ART vs. Masstree.
- **Epoch-based Memory Reclamation (§3.2, §4.2):** Knoten werden nach Loeschen NICHT sofort freigegeben — verhindert dass Reader mit dangling pointers in fremde Cachelines greifen.

### 2. ALGORITHMUS-STRATEGIEN
- **Optimistic Lock Coupling (OLC, §3) — 5-Schritt-Lookup-Protokoll (Figure 3, lines 2-20):**
  1. `version = readLockOrRestart(node)` — wartet bis Lock frei, liest Version, ABER schreibt NICHT in den Lock.
  2. Falls `parent != null`: `readUnlockOrRestart(parent, versionParent)` — Validierung dass Parent unveraendert ist.
  3. Pruefung `prefixMatches(node, key, level)` und Validierung mit `readUnlockOrRestart(node, version)`.
  4. `nextNode = node.findChild(key[level])` gefolgt von `checkOrRestart(node, version)` — KRITISCH (line 11): Pointer-Validierung BEVOR dereferenziert wird, sonst Crash bei invaliden Pointern.
  5. Rekursion zur naechsten Ebene mit aktueller Version als `versionParent`.
  - **Bei Konflikt:** komplette Operation wird vom Root neu gestartet (`restart()`). Limit fuer Restarts existiert; nach Limit Fallback auf Write-Locks (Forward-Progress).
  
- **OLC Insert (Appendix B, lines 1-34):** Initial wie Lookup ohne Write-Locks. Bei Modifikation: `upgradeToWriteLockOrRestart(parent, parentVersion)` zuerst, dann `upgradeToWriteLockOrRestart(node, version, parent)`. Drei Faelle:
  - Prefix-Mismatch → `insertSplitPrefix` (parent + node beide locked).
  - Knoten voll → `insertAndGrow` + `writeUnlockObsolete(node)` + `writeUnlock(parent)`.
  - Sonst → nur node locked, `node.insert(key, value)`, `writeUnlock(node)`.

- **ROWEX (Read-Optimized Write EXclusion, §4) — 4-Schritt-Node-Replacement-Protokoll (§4.2):**
  1. Lock node UND parent.
  2. Neuen Node-Typ allozieren und alle Eintraege aus altem Node kopieren.
  3. Pointer im Parent vom alten auf neuen Node mit ATOMARER Store aendern.
  4. Alten Node unlock + als obsolete markieren; Parent unlock.
  - **Reader-Garantie:** Reader sehen ENTWEDER alten ODER neuen Node (atomarer Pointer-Swap), niemals inkonsistenten Zwischenzustand.
  - **Schluesselinvariante (§4.2):** Jeder Key hat deterministische physische Lokation (kein Rebalancing in ART) — fundamental fuer ROWEX-Tauglichkeit.

- **ROWEX Local Mutations (§4.2):**
  - Felder die concurrent gelesen werden koennen MUESSEN atomar (`std::atomic`) sein: Key-Bytes (Node4/16), Child-Indizes (Node48), Child-Pointer (alle).
  - Linear-Nodes (Node4/16): Sortierte Reihenfolge AUFGEGEBEN, neue Keys werden am Ende angehaengt → Lookups muessen ALLE Keys pruefen (SIMD-beschleunigt). Deletions setzen Pointer auf null; Slots werden bei Node-Replacement lazy reclaimed.

- **ROWEX Path Compression (§4.2, Figure 4):**
  - Problem: Neuen Node installieren UND Prefix kuerzen sind 2 separate atomare Schritte → Reader kann Zwischenzustand sehen.
  - Loesung: Jeder Node erhaelt `level`-Feld (Hoehe inkl. Prefix), das nach Erstellung NIE geaendert wird. Reader detektiert via level-Feld, dass Prefix uebersprungen werden muss.
  - Prefix + Length in EINEM 8-Byte-Wert (atomarer Store). Reduziert max. Prefix-Laenge von 9 auf 4 Bytes.

- **ConcurrencyDiscipline-Bezug:**
  - **Page-Discipline:** OLC + ROWEX operieren auf Knoten-Ebene (= ART-Pages).
  - **Node-Discipline:** Node-Replacement (4-Schritt-Protokoll) ist node-local.
  - **Path-Discipline:** Lock-Coupling traversiert Pfade von Root zu Leaf — typische Path-Concurrency.
  - **MemoryRead/MemoryWrite-Discipline:** ROWEX trennt klar Reader (no writes) und Writer (write locks) — definiert die Asymmetrie.

- **Mechaniken-Bezug:**
  - **OLC = identisch zur OLC-Mechanik im ConcurrencyManager.**
  - **ROWEX = identisch zur ROWEX-Mechanik im ConcurrencyManager.**

### 3. SONDERMERKMALE
- **Forward-Progress-Garantie:** OLC garantiert nicht wait-free, aber Restarts sind limitiert (Fallback auf pessimistische Write-Locks).
- **Debug-Modus:** Optimistische Primitives koennen auf `pthread_rwlock` gemappt werden → Helgrind und andere Thread-Analysetools funktionieren.
- **Writer-Code-Komplexitaet (§5.4):** ROWEX braucht 200 LOC fuer Insert vs. 148 fuer OLC vs. 95 ohne Sync — ROWEX ist deutlich aufwendiger im Writer.
- **HTM-Vergleich:** HTM-Variante (20 Restarts + Global Elided Lock Fallback) leidet unter Memory-Allocator-Contention bei Inserts/Removes.
- **Single-Threaded Overhead OLC vs. unsynchronized:** ~65% (zusaetzliche Instructions); bei 20 Threads schrumpft Overhead auf ~10%.

### 4. PLATTFORM-MODELLIERUNG-BEZUG (Saeule B)
- **ICacheLine direkt adressiert:** Lock-Coupling-Pathologie ist eine Cache-Line-Bouncing-Pathologie — ART OLC/ROWEX optimiert genau diesen Aspekt.
- **ICpuCore/ICoreLayout:** Test-Plattform Haswell EP Intel Xeon E5-2687W v3 (10 Cores, 20 Hyper-Threads, 25 MB L3); 24-Core Broadwell EP wird als Treiber genannt.
- **IInterconnect/IBusTopology:** Paper merkt explizit an: "The slowdown would be even larger on multi-socket systems, since such systems do not have a shared cache for inter-thread communication." → klare Multi-Socket-NUMA-Implikation.
- **IHardwareExtension/IIsaFeatureSet:** SIMD-Instruktionen werden in ROWEX fuer Linear-Node-Lookups verwendet (Node4/16). HTM ist eigene Plattform-Capability.
- **IPinningPolicy:** Implizit durch Thread-Anzahl-Skalierungsexperimente (1-20 Threads).

### 5. VERALLGEMEINERUNGS-VORSCHLAEGE
- **OLC und ROWEX sind die exakten Vorbilder fuer die ConcurrencyManager-Mechaniken** — Paper liefert Pseudocode, Korrektheits-Argumente und Performance-Daten.
- **5-Schritt-Lookup-Protokoll als Template** fuer alle Page-orientierten Datenstrukturen (B-Tree, Trie, Hash) im Page-Strategy-Visitor.
- **Verallgemeinerung auf B-Trees:** Paper notiert explizit "The technique is also quite general and can be applied to other data structures (e.g., B-trees)" → ConcurrencyDiscipline::Page muss B-Tree-faehig sein.
- **Visitor-Pattern Bezug:** Optimistic Lock = `BaseEngineStrategy`-Visitor (lightweight); ROWEX = `CacheEngineStrategy`-Visitor (komplexer, schreiber-zentriert).
- **Epoch-Based-Reclamation als 4. Mechanik?** Paper macht klar: OLC und ROWEX BENOETIGEN beide eine deferred reclamation (epoch-based). Das spricht dafuer, EBR als orthogonalen Mechanik-Baustein neben OLC/ROWEX/RCU im ConcurrencyManager zu fuehren.
- **`level`-Feld als generelle Loesung fuer "Reader sieht Zwischenzustand":** Idee: persistente, unveraenderliche Metadaten + atomare State-Felder.

### 6. LUECKEN
- **OLC und ROWEX nicht kombinierbar im selben Tree** in dieser Arbeit — ist orthogonale Wahl pro Datenstruktur.
- **Skalierung NUR bis 20 Threads** evaluiert; keine Aussagen zu 100+ Cores oder Multi-Socket-Verhalten.
- **Range-Scans bei ROWEX nicht behandelt** — Paper notiert dass sortierte Reihenfolge im Linear-Node aufgegeben wird, was Range-Scans erschweren wuerde (OFFEN).
- **Recovery-Verhalten** bei Crash mitten in 4-Schritt-Replacement-Protokoll nicht thematisiert (keine Persistenz).
- **Verhalten unter Hochkontentions-Inserts (multi-writer):** §5.2 testet nur 1 Lookup-Thread + 1 Update-Thread.

---

## P29 RCU McKenney/Appavoo/Kleen/Krieger/Russell/Sarma/Soni (2001)

### 1. CACHE-STRATEGIEN
- **Reader-Side keine Writes (§2.2 Read-Copy Search Figure 8):** RCU `search()` enthaelt "absolutely no locks or atomic instructions" — Reader fuehren keine Schreiboperationen auf gemeinsamen Speicher durch → KEIN Cacheline-Bouncing fuer Reader.
- **Cacheline-Bouncing-Vermeidung (§2.5, Figure 15):** Memory-Latency-Ratios fuer Sequent-Computer (1996+ NUMA) zeigen, dass remote-memory-Zugriffe immer mehr CPU-Instruktionen kosten. Cacheline-Bouncing wird explizit als Hauptmotivation fuer RCU genannt: "The trend is consistently upwards towards higher memory-latency ratios, thanks to Moore's law."
- **Lock-Acquisition = remote-memory-latency-bound:** Paper formuliert explizit: "Improvements in the speed of lock acquisition will therefore be limited by the slow improvements in remote memory latency, rather than the much faster improvements in CPU core speed."
- **Stale-Data-Toleranz als Cache-Strategie:** Da Reader OHNE Locks lesen, koennen sie veraltete Daten sehen — wird in vielen Faellen toleriert (Routing-Tabellen) und ist gerade die Quelle der Cache-Effizienz.
- **Per-CPU-Tracking von Quiescent States (§3, §6.1):** DYNIX/ptx 2.1 trackt Quiescent States per-CPU → minimaler Cross-CPU-Verkehr fuer Grace-Period-Detection.

### 2. ALGORITHMUS-STRATEGIEN
- **Read-Copy-Update Kernidee (Abstract, §1):** Updates werden in 2 Phasen gesplittet:
  1. Phase 1: Genug Update durchfuehren, dass NEUE Operationen den neuen State sehen, BESTEHENDE Operationen aber noch alten State weiternutzen koennen.
  2. Phase 2: Update VOLLSTAENDIG abschliessen, NACHDEM alle aktiven (Pre-Existing-)Operationen abgeschlossen sind.
  
- **Grace Period (§2, Figure 2):** "Grace period extends until after the end of all operations that started before the beginning of the grace period." Garantie: Jede Operation die VOR dem Beginn der Grace Period gestartet ist, ist bei Ende der Grace Period beendet. Operationen die NACH Beginn der Grace Period starten, sehen den neuen State.

- **Quiescent State (§2, §6):** "Point in the code at which it is guaranteed that all previous operations have completed." Implementierungen unterscheiden sich:
  - **DYNIX/ptx 2.1 (1993)** + Russell's `wait_for_rcu()` patch: Context-Switch ist Quiescent State (non-preemptiv).
  - **DYNIX/ptx 4.0 (1994)** + Sarma's RCU patch: Context-Switch, Idle-Loop, User-Mode-Execution, System-Call-Entry, Trap-from-User-Mode, CPU-Offline.
  - **Russell second `wait_for_rcu()`**: Voluntary Context Switch (preemptiv, aber nicht in Read-Side-CS).
  - **Tornado/K42 Generation Facility**: Per-CPU-Counter, beginning/end of operations.

- **6 Flavors-Hinweise im Paper:** Das urspruengliche Paper benennt nicht explizit "6 Flavors" (mainline/bulletproof/qsbr/mb/membarrier/signal — diese terminologie kam SPAETER, ~2007+ via Userspace-RCU). DAS PAPER beschreibt 4 historische Flavor-Familien: DYNIX/ptx 2.1, DYNIX/ptx 4.0, Russell's voluntary-context-switch, Tornado/K42 Generation. **OFFEN:** Spaetere RCU-Flavors (qsbr, mb, membarrier, signal aus URCU-Library) sind NICHT in diesem Paper, sondern Folgeliteratur.

- **Two-Phase Update / Deferred Free (§4.2, Figure 19/20):**
  - `wait_for_rcu()`-Primitive (Figure 18): wechselt durch alle CPUs (FIFO scheduling), force-Schedule auf jede CPU → garantiert, dass alle Pre-Existing-Operationen abgeschlossen sind.
  - `kfree_rcu()` (Figure 20): allokiert `struct rcu_head` vorab via `kmalloc_rcu()`, ruft `sync_and_destroy()` als tasklet — Memory-Pressure-Loesung.
  - `call_rcu()` + `free_pending_rcus()` (Figure 19): Callback-Liste, asynchrone Verarbeitung.

- **List Deletion Animated (§2.4, Figure 11-14):** Updater haelt `list_lock`, unlinks Element B, releases lock. Reader auf Element B sehen STALE DATA. NACH Grace Period (alle Pre-Existing-Reader beendet) ist es safe, B in die Freelist zurueckzugeben.

- **ConcurrencyDiscipline-Bezug:**
  - **MemoryRead-Discipline:** Reader-Path ist explizit lock-frei und atomic-frei → reine Memory-Reads.
  - **MemoryWrite-Discipline:** Writer haelt `list_lock` (oder `spin_lock`), Modifikation ist atomar gemacht durch Pointer-Update.
  - **DataStructure-Discipline:** RCU ist auf list-modifications (linked list, file-descriptor table) angewendet.
  - **Path-Discipline:** Bei Module-Unloading und Hotplug-CPU traversieren Reader Pfade (Modul-Verweise, FD-Tabellen).

- **Mechaniken-Bezug:** **RCU = direkte Vorlage fuer comdare-rcu (Task #104).**

### 3. SONDERMERKMALE
- **Anwendungsszenarien (§5):**
  - **Scalable FD Management (§5.1, Figure 21-23):** ersetzt rwlock auf `file_lock` durch spinlock; >30% Throughput-Gewinn auf 4-CPU PIII Xeon 700MHz.
  - **Hotplug CPU Support (§5.2, Figure 24):** `cpu_down()`-Funktion nutzt RCU statt Locking auf Online-Processors-Array.
  - **Module Unloading (§5.3, Figure 25-28):** vermeidet destruktive Race zwischen Modulnutzung und Modul-Unload.

- **Voraussetzungen (§3):**
  - **"Read intensive":** Update-Fraktion `f` muss << 1/N (N = Anzahl CPUs) sein. Mit 8 CPUs: `f < 0.125` ideal; in Spezialfaellen sogar f=10^-10 sinnvoll.
  - **Stale-Data-Toleranz:** Update-Modifikation muss mit lock-free Access kompatibel sein (linked-list insert/delete/replace = OK; reorder-in-place = NICHT OK, kann unendliche Loop verursachen).
  - **Memory-Tracking:** Modester Speicher fuer "memory waiting to be freed" muss verfuegbar sein.

- **Limitierungen:**
  - Funktioniert NICHT in pre-emptiblen Kerneln ohne Preemption-Suppression in Read-Side CS.
  - Kann NICHT aus Interrupt-Handler aufgerufen werden (aber `schedule_task()` indirekt).
  - Kann NICHT mit Spinlock-held oder Interrupts-disabled aufgerufen werden.
  - Relativ langsam (Wait-Schritt fuer alle CPUs).

### 4. PLATTFORM-MODELLIERUNG-BEZUG (Saeule B)
- **ICacheLevel/ICacheLine:** Cacheline-Bouncing ist Hauptmotivation; per-CPU-Tracking minimiert L2/L3-Coherence-Traffic.
- **ICpuCore/ICoreLayout:** Per-CPU-Quiescent-State-Tracking direkt mappable auf ICoreLayout.
- **IScheduler:** `wait_for_rcu()` (Figure 18) nutzt SCHED_FIFO-Policy + cpus_allowed-Mask, um sich auf jede CPU zu schedulen → direkt IScheduler-relevant.
- **IPinningPolicy:** wait_for_rcu manipuliert `cpus_allowed` (line 24, Figure 18) — zentrale Pinning-Operation.
- **IInterconnect:** NUMA-Hardware (1996+) wird explizit als Treiber genannt; remote-vs-local-Memory-Latency-Ratio motiviert RCU.
- **IIsaFeatureSet:** `RC_MEMSYNC()` (Figure 22) wird explizit fuer schwach konsistente CPUs benoetigt — Memory-Barrier-Modellierung.
- **ILivePlatformModel:** Hotplug-CPU-Support zeigt Bezug zu dynamischen Plattform-Modellen.

### 5. VERALLGEMEINERUNGS-VORSCHLAEGE
- **comdare-rcu (Task #104) Implementierungs-Roadmap:** Dieses Paper ist die historische Foundation; moderne Implementierung sollte URCU-Familie (qsbr, mb, membarrier, signal) als IRcuFlavor-Strategien modellieren.
- **Quiescent-State-Detection als IHeuristic:** Verschiedene Strategien (per-CPU-Counter, voluntary-context-switch, generation-facility) als pluggable Heuristik unter Saeule B.
- **`call_rcu()`/`kfree_rcu()` als comdare::rcu::Callback:** asynchrone Reclamation als Standard-Pattern.
- **Stale-Data-Toleranz-Marker im Page-Header:** Idee aus Paper "stale data has been flagged so that it may be easily ignored" → koennte als Page-Flag in IPage modelliert werden.

### 6. LUECKEN
- **6-Flavor-Klassifikation (qsbr/mb/membarrier/signal) NICHT im Paper** — kommen aus spaeterer Userspace-RCU-Literatur (Desnoyers et al. 2012). **OFFEN:** Sekundaerquellen erforderlich.
- **Performance-Daten:** Nur 1 Benchmark (Chat, 4-CPU PIII Xeon 700MHz, 1MB L2, 1GB RAM) — sehr veraltet, keine Aussagen zu modernen NUMA-Systemen.
- **Hierarchical RCU / Tree-RCU-Optimierung** (spaeter von McKenney 2008+) NICHT im Paper.
- **Kompatibilitaet mit transactional memory** nicht behandelt (Paper ist 2001).
- **Verhalten unter SEHR hoher Update-Rate** (f > 0.9) wird als "special cases" abgetan — keine quantitative Analyse.

---

## P30 Hazard Pointers Michael (2004, IEEE TPDS Vol.15 No.6)

### 1. CACHE-STRATEGIEN
- **Per-Thread Hazard Pointer Records (§3.1, Fig.1 HPRecType):** Jeder Thread besitzt EIGENE Hazard-Pointer (HP[K]) — kein Cross-Thread-Schreiben auf den gemeinsamen Daten. Hazard-Pointer sind single-writer/multi-reader.
- **Read-Only Search ohne Writes auf Shared Vars (§5):** "Lock-free objects with hazard pointers do not write to any shared locations other than hazard pointers, during read-only Search operation as well as traversal, thus minimizing cache coherence traffic." (Footnote 2 explizit: "a write by a processor to a location that is cached in its cache with a read-only permission results in invalidating all cached copies".)
- **Aggregate Per-List Reference Counting vermieden:** Vergleich mit Lock-Free-Reference-Counting: "the situation is even worse, the reference counter of each traversed node needs to be incremented and then decremented, even during read-only transactions." → Hazard-Pointer haben explizit BESSERES Cache-Verhalten als RefCount.
- **Cache-Line-Padding (§5):** "Data structures of all implementations were aligned to cache line boundaries and padded where appropriate to eliminate false sharing." → False-Sharing-Vermeidung als Cache-Strategie.

### 2. ALGORITHMUS-STRATEGIEN
- **Hazard Pointers Kernidee (§3):** Jeder Thread haelt eine kleine Anzahl K (typischerweise 1-2) single-writer/multi-reader Hazard-Pointer. Ein HP zeigt entweder NULL oder auf einen Knoten, den der Thread spaeter ohne weitere Validierung dereferenzieren wird. Solange ein retired Node von KEINEM HP gehalten wird, ist Reclamation safe.

- **Wait-Free-Garantie (§3):** "It is wait-free, i.e., progress is guaranteed for active threads individually, not just collectively" — STAERKER als lock-free. Konstanter erwarteter amortisierter Time-Cost pro retired Node.

- **5-Schritt-Application-Protokoll (§4, Outline):**
  1. Identifiziere "hazardous references" im Algorithmus.
  2. Pro hazardous reference, finde Punkt der Erstellung und letzten Zugriff.
  3. Vergleiche Perioden — Maximum gleichzeitiger hazardous refs = max. HP-Anzahl pro Thread.
  4. Schreibe Adresse des Referenz-Targets in einen Hazard-Pointer.
  5. Validiere dass Node noch SAFE ist; wenn nicht, branch/back-off/retry.

- **RetireNode (Fig.2):** Wird vom entfernenden Thread aufgerufen, fuegt Node in private `rlist` ein, inkrementiert `rcount`. Bei `rcount >= R` (R = Threshold) → `Scan(HeadHPRec)`.

- **Scan-Routine (§3.1, Fig.3) — 2 Stages:**
  - **Stage 1:** Scanne HP-List, sammle alle Non-NULL-HP-Werte in lokale `plist` (typischerweise als Hashtable implementiert).
  - **Stage 2:** Fuer jeden Node in `rlist`: Pruefe gegen `plist`. Bei Match → behalte in `rlist`. Sonst → `PrepareForReuse(node)` (z.B. `free()`).
  - Komplexitaet O(R) erwartet, O(R log p) worst-case mit balancierter Suchstruktur.

- **HelpScan-Erweiterung (§3.2, Fig.4):** Nach `Scan`: `HelpScan` ueberprueft INAKTIVE HP-Records (`Active = false`), uebernimmt deren `rlist`-Eintraege. Garantiert dass jeder eligible Node IRGENDWANN frei wird, auch bei Thread-Failures.

- **AllocateHPRec / RetireHPRec (§3.2):** Threads koennen dynamisch erstellt/zerstoert werden; HP-Records werden via TAS auf `Active`-Flag wiederverwendet.

- **ABA-Loesung als Side-Effect (§2.3, §3.3):** "Hazard pointers offer a lock-free solution for the ABA problem using only practical single-word instructions." Garantie: Wenn HP kontinuierlich auf einen Node zeigt, kann dieser nicht reclaimed werden → A→B→A ABA verhindert ohne Tags/Counters.

- **Anwendungs-Beispiele (§4):**
  - **FIFO-Queue Michael/Scott (§4.1, Fig.5-7):** 1-2 HPs pro Thread; Enqueue 1 HP fuer `t`, Dequeue 2 HPs fuer `h` und `next`.
  - **LIFO-Stack IBM-Freelist (§4.2, Fig.8):** 1 HP fuer `t` in Pop; Push braucht keine HPs (Node owned).
  - **List-Based Sets / Hash-Tables (§4.3, Fig.9):** 2 HPs (`hp0`, `hp1`) fuer aktuelle Position + Predecessor.
  - **Single-Writer Multi-Reader Doubly-Linked List (§4.4, Fig.10):** Ersetzt Aggregate-Reference-Counting; nur 2 HPs pro Reader-Thread.

- **ConcurrencyDiscipline-Bezug:**
  - **Node-Discipline:** HPs operieren auf einzelnen Nodes (per-Node-Hazard-Status).
  - **MemoryRead-Discipline:** Read-Side ist write-frei auf shared vars (nur eigene HP).
  - **DataStructure-Discipline:** Anwendung auf Queue, Stack, List, Hash, Doubly-Linked-List (umfangreichste Liste im Cluster).
  - **Path-Discipline:** List/Hash-Traversal mit 2 HPs (curr + prev).

- **Mechaniken-Bezug:** **HP ist 4. Mechanik-Kandidat neben OLC/ROWEX/RCU** — orthogonal zur ConcurrencyManager-Triplet.

### 3. SONDERMERKMALE
- **Wait-Freedom (§3, §6.2):** Staerker als RCU (blocking auf Grace Period) und lock-free CAS-Schemata.
- **Single-Word Reads/Writes:** Kein DCAS, kein LL/SC mit nesting — funktioniert auf 64-Bit-Architekturen ohne 128-Bit-Atomics.
- **Upper Bound auf retired-but-not-yet-reclaimed Nodes:** NR ≤ N·K + N·H/Ω(H)·R = O(N·K + N·H + N·R). Praktisch konstant pro Thread.
- **Memory kann ans OS zurueckgegeben werden** (im Gegensatz zu IBM-Tag-Method, die Knoten permanent typed haelt).
- **Performance-Daten (§5, Fig.11-14):** IBM RS/6000 mit 4x 375 MHz POWER3-II. 100 RW-Locks vs lock-free w/ haz ptrs vs lock-free w/ tags vs lock-free w/ ref count. Hash-Table 4/8/12/16 Threads: 251%, 496%, 792%, 905% besser als Lock-Based.

### 4. PLATTFORM-MODELLIERUNG-BEZUG (Saeule B)
- **ICacheLine:** False-Sharing-Padding ist explizit cache-line-aware.
- **ICpuCore:** Per-CPU-/per-Thread-HP-Records direkt korrespondierend.
- **IIsaFeatureSet:** Single-word CAS oder restricted LL/SC erforderlich. CAS ueber `do {if (LL(addr)≠exp) return false;} until(SC(addr,new); return true;)` (§2.2) — 64-Bit-Architektur OHNE 128-Bit-Atomics (POWER3, Alpha, MIPS, PowerPC) wird explizit unterstuetzt.
- **IInterconnect/IBusTopology:** Cache-Coherence-Traffic-Minimierung ist Hauptargument.
- **IScheduler:** Anders als RCU benoetigt HP keinen Scheduler-Support → Userspace-tauglich!
- **IHardwareExtension:** ABA-Prevention-Tags (IBM 1983, RC 23089) brauchen DCAS = Hardware-Extension; HP nicht.

### 5. VERALLGEMEINERUNGS-VORSCHLAEGE
- **HazardPointer als 4. ConcurrencyManager-Mechanik (neben OLC, ROWEX, RCU):** Wait-free, Userspace-tauglich, kein Scheduler-Support → fuellt Luecke gegenueber RCU.
- **HP als IMemoryReclamation-Strategie:** Orthogonal zu Lock-Free-Algorithmus selbst — ANY lock-free Algorithmus kann mit HP retrofitted werden.
- **Per-Thread-State im IPinningPolicy/ICoreToThreadMap:** HP-Records pro Thread sind natuerlich an ICoreToThreadMap mappable.
- **PrepareForReuse als Hook:** Pluggable Reclamation-Hook (free, in private freelist queue, return to OS).
- **HelpScan als Failure-Tolerance-Strategie:** Garantiert Forward-Progress trotz Thread-Failures — wichtig fuer Resilienz im Cluster-Kontext.
- **Gegenueberstellungs-Tabelle Mechaniken:**
  - OLC: Restart-bei-Konflikt, Optimistic, schwaecher als wait-free.
  - ROWEX: Reader-fast, Writer-Lock, datenstruktur-spezifisch.
  - RCU: Grace-Period, scheduler-abhaengig, Read-mostly optimal.
  - HP: Wait-free, single-word-CAS, jeder lock-free Algo kompatibel.

### 6. LUECKEN
- **Amortisierte Performance-Garantie nur, wenn R = H + Ω(H)** — bei sehr vielen Threads kann R-Threshold hoch werden.
- **K (HP-Anzahl pro Thread)** muss algorithmus-spezifisch ermittelt werden — paper gibt 1-2 als typisch an, aber komplexere Datenstrukturen (z.B. Trees) brauchen mehr (OFFEN: ART haette wieviele HPs?).
- **Performance-Vergleich mit RCU FEHLT** im Paper — beide wurden zur gleichen Zeit entwickelt, kein direkter Benchmark.
- **Hardware sehr alt** (POWER3-II 375 MHz, 2004) — keine modernen NUMA-Daten.
- **Compiler-Automation:** Paper notiert "while applying these steps is easy for algorithm designers, these steps are not readily applicable automatically (e.g., by a compiler)" — manuelle Anwendung erforderlich (OFFEN fuer comdare-Codegen).

---

## P31 Ungethuem TUD (2017) "Overview on Hardware Optimizations for Database Engines" (BTW 2017, LNI)

### 1. CACHE-STRATEGIEN
- **Scratchpad Memory pro PE (§2.1):** "PEs are not able to access the global memory directly, instead a data locality approach is exploited using scratchpad local memory." → expliziter Local-Memory-Konstrukt statt Cache-Hierarchy. Vergleichbar mit Cell-BE-Modell.
- **Burst Mode (§2.3):** SDRAM Burst-Length 4 oder 8; "burst length should be selected such that an entire cache line can be transferred in one burst." Fuer 64-Bit-Bus + 64B L2-Cacheline → Burst=8.
- **Data Prefetcher (§2.2):** Operiert NEBEN dem Prozessor, "preloads data from an external memory into the local memories. This way it alleviates the memory access bottleneck."
- **Local Data Memory 0 + 1 (§2.2, Fig.4):** ZWEI lokale Datenspeicher mit ZWEI Load-Store-Units → simultaner Zugriff auf zwei Streams. Vergleichbar mit Dual-Port-Caches.
- **iDMA Push-Down (§4):** "Filter values, format results, all in one hardware accelerator" am Memory-Controller → Reduktion des Daten-Transfers vom Memory zum PE; nur Ergebnis wird transferiert.

### 2. ALGORITHMUS-STRATEGIEN
- **Hardware/Software-Co-Design Survey (§1):** Drei Layer:
  1. Processing Elements (Cores, ISA-Extensions, FPGAs).
  2. Main Memory (Memory Controller, DMA, NVRAM).
  3. Network (NUMA, RDMA, InfiniBand, OmniPath, QPI).

- **Tomahawk Architecture (§2):**
  - **Control-Plane:** App-Core + Global Memory + Cache + DMA Controller.
  - **Data-Plane:** N PEs, jedes mit Scratchpad Memory + DMA.
  - **Core Manager (CM):** Task-Scheduling, PE-Allocation, Datentransfers, Frequency-Scaling.
  - Aktuell 4. Revision; manufactured Tomahawk DBA mit 4 PEs (Tensilica LX5 RISC, 80 RISC-Instructions).

- **PE-Extensions fuer Database Primitives (§3):** Iststruktur einer database operation:
  1. **Initial Load:** Load 128 bits per Load-Store-Unit von Memory.
  2. **Load:** Reorder/Move zu second internal state (z.B. 128-bit aligned).
  3. **Pre-Processing:** Values fuer Operation berechnen.
  4. **Operation:** Actual Computation.
  5. **Post-Processing:** Info fuer Store sammeln.
  6. **Prepare Store:** Shuffling.
  7. **Store:** Write back zu local memory.

- **Manufactured ISA Extensions (§3.3, Fig.6):**
  - **BitiX Processor:** WAH, PLWAH, COMPAX (Bitmap Compression).
  - **HASHI Processor:** Hash+Lookup, Hash+Insert, Hash Keys, Hash Sampling, CityHash32 (Hashing).
  - **Titan3D Processor:** Hash Sampling, Merge Sort, Intersection, Union, Difference, Sort-Merge-Join, Sort-Merge-Aggregation (SUM).
  - **Tomahawk DBA:** WAH (BitMap), Hash Sampling, CityHash32, Merge Sort, Intersection, Union, Difference.

- **Bitmap Compression (§3.3):**
  - **WAH (Word-Aligned Hybrid):** RLE (Run-Length-Encoding); Word-Encoding mit 1-Bit-Marker (literal vs. fill).
  - **PLWAH (Position List WAH).**
  - **COMPAX.**
  - **Compressed AND-Operation (§3.3, Fig.7):** Code: `resetInst(); WUR_opID(0); ldXstream(); ldYstream(); WAHinst(); WAHinst(); WAHinst(); WAHinst(); while(WAHinst());` — 4 Loads + 4 WAHinst pro 128-Bit-Line.

- **Intelligent DMA Controller (iDMA, §4):** Push-down von Logic zum Memory Controller fuer:
  - Linked List (Pointer-Chasing).
  - Hash Tables mit Overflow Chains.
  - Linked Arrays.
  - Binary Tree.
  - **iDMA Submodules (Fig.11):** Configurator, AGU (Address Generation Unit), DataFetcher, Crawler (mit ModeSwitch, DataShifter, PointerVerification, ValueVerification, NextStepSwitch).
  - **Performance-Gain (§4, Fig.12a):** iDMA pointer-chaser ueber Linked List + Binary Tree (840x 32-bit Objects) **outperforms** Software-on-PE um Faktor **10x in Cycles**.

- **ConcurrencyDiscipline-Bezug:**
  - **Page-Discipline:** Bitmap-Compression operiert auf Bit-Pages.
  - **Array-Discipline:** Linked Arrays explizit als iDMA-supported Datenstruktur.
  - **DataStructure-Discipline:** Hash Tables, Trees, Linked Lists.
  - **Path-Discipline:** Pointer-Chasing in Linked List/Binary Tree ist Path-Traversal.
  - **SimdThread/SimdFlow-Discipline:** SSE wird referenziert; aber Tomahawk hat keine eigene SIMD-ISA (RISC-Basis).
  - **MemoryRead-Discipline:** Burst-Mode + iDMA optimiert Reads.

- **Mechaniken-Bezug:** Keine direkten Sync-Mechaniken. Aber: hardware-offloaded Operations sind FUNDAMENTAL atomar aus Sicht des PE.

### 3. SONDERMERKMALE
- **Energie-Effizienz:** LX5 zieht <0.15W vs. Intel i7-6500U 7.5-25W; ISA-Extensions liefern 2-Magnitude Speedup (100x).
- **100x-1000x Speedup fuer Hashing** mit ISA-Extensions vs. C-Implementation auf LX5; Hashing hat hoechstes Optimierungspotenzial.
- **Compressed Bitmap Speedup:** WAH 2x (memory-bound); Compax 5x+ (compute-bound); Software-Vergleich auf i7.
- **Dark Silicon (§1):** Motivation aus Esmaeilzadeh 2011 (ISCA) — chip area immer mehr unpowered → spezialisierte Circuits sinnvoll.
- **Tradeoffs (§3.1):** Universality vs. Technical Feasibility; balance mit Critical Path (Frequency-Begrenzung).
- **Commercial Reference (§5):** Oracle Software in Silicon (SPARC M7); Database Acceleration Engines.

### 4. PLATTFORM-MODELLIERUNG-BEZUG (Saeule B) — DAS HERZSTUECK FUER COMDARE
**Dieses Paper ist DER Saeule-B-Goldstandard fuer Hardware-Optimization-Concepts!** Praktisch alle aufgezaehlten Hardware-Optimierungen sind direkt als Concepts modellierbar:

- **IHardwareExtension Concepts (direkt aus §3.3):**
  - `WAHExtension`, `PLWAHExtension`, `COMPAXExtension` (Bitmap-Compression).
  - `HashExtension` (Hash+Lookup, Hash+Insert, CityHash32, Hash Sampling).
  - `MergeSortExtension`, `IntersectionExtension`, `UnionExtension`, `DifferenceExtension`, `SortMergeJoinExtension`, `SortMergeAggregationExtension`.
- **IIsaFeatureSet Concepts:**
  - `RiscBaseISA` (Tensilica LX5: 80 base instructions).
  - `SSEExtension` (Intel x86, 144 SSE instructions).
  - `AVXExtension`.
  - `SGXExtension` (Software Guard Extensions, security).
  - `THUMBExtension` (ARM).
  - `NEONExtension` (ARM SIMD).
- **ICacheTopology / ICacheLevel:**
  - Local Instruction Memory + Local Data Memory 0 + Local Data Memory 1 (Fig.4).
  - Scratchpad Memory pro PE (statt Coherent Cache).
- **IInterconnect / IBusTopology:**
  - NoC (Network-on-Chip) zwischen PEs.
  - Core Manager als zentraler Scheduling-Knoten.
  - InfiniBand, OmniPath, QPI (§1).
- **IMemoryBandwidthModel:**
  - **DDR2 Timing-Constraints (Tab.1):** tRCD=15ns, tRP=15ns, tCL=15ns, tRAS=40ns.
  - Bank/Row/Column-Index-Modell (§2.3).
  - Burst Length 4/8 (§2.3).
- **IScheduler:**
  - Core Manager fuer Task-Scheduling, PE-Allocation, Datentransfers, Frequency-Scaling.
- **IHeuristic:**
  - "Critical Path"-Heuristik (Frequency-Tradeoff).
  - "Universality vs. Technical Feasibility"-Heuristik.
- **ICpuCore:**
  - Tensilica LX5 (RISC, 32-bit, 80 instructions, 4 pipeline stages).
  - Intel i7-6500U (Vergleich).
  - Tomahawk PEs (4 Stk in DBA-Revision).
- **iDMA-Konzept:** Eigenes Concept `IIntelligentDMA` mit Submodulen Configurator/AGU/DataFetcher/Crawler.
- **ICoreLayout:** App-Core (fat, control-plane) + N PEs (slim, data-plane).
- **ILiveCpuModel:** Frequency-Scaling am CM zur Power-Optimization.

### 5. VERALLGEMEINERUNGS-VORSCHLAEGE
- **MASSIVES Mapping-Potenzial:** Praktisch ALLE in P31 erwaehnten Hardware-Optimierungen koennen als IHardwareExtension/IIsaFeatureSet-Concepts in Saeule B modelliert werden. Das ist die ground truth fuer ein TUD-Habich-aligned Concept-Vokabular.
- **Database-Operation 7-Schritt-Pipeline (§3.2)** als Template fuer ICachePage/ISearchPage Operation-Lifecycle: Initial Load → Load → Pre-Processing → Operation → Post-Processing → Prepare Store → Store. Mappt 1:1 auf eine pluggable Operation-Pipeline pro Page.
- **iDMA als IComputeOffload-Concept:** "Push-Down logic to Memory Controller" — verallgemeinerbar als Strategie "wo wird die Operation ausgefuehrt?" (PE vs. iDMA vs. App-Core vs. FPGA).
- **Tomahawk Submodules als Reference-Implementation** fuer einen comdare-Database-Accelerator-PE.
- **Bitmap-Compression-Algorithmen (WAH/PLWAH/COMPAX)** als Algorithmus-Strategien-Visitor.
- **ConcurrencyManager fehlt komplett in P31** — hier liegt Komplementaritaet: P08/P29/P30 liefern Sync, P31 liefert Hardware-Awareness.

### 6. LUECKEN
- **Tomahawk-spezifisch:** Viele Aussagen sind an die TUD-Tomahawk-Architektur gebunden — Generalisierung auf x86/ARM/RISC-V erfordert Abstraktion.
- **Sehr alte Hardware-Vergleiche** (Intel i7-6500U; DDR2 SDRAM 400 MHz!) — moderne DDR5/HBM/CXL nicht behandelt (das schliesst P32/P33 nach).
- **Keine Concurrency-Aspekte:** PEs sind explizit isoliert (Scratchpad), keine Cache-Coherence, keine Atomics → das ist GUT fuer Saeule B aber ARM fuer Saeule A.
- **iDMA aktuell nur Point-Queries:** Range-Queries OFFEN (Section 6: "we also want to support range queries").
- **Compiler-Automation der ISA-Extensions:** Welche Extensions auf welchem PE ist OFFEN (Section 6: open research questions).
- **Network-Dimension nur kurz erwaehnt** (§1): RDMA, InfiniBand, OmniPath sind Pointers, keine Modellierung im Paper.

---

## P32 To-Stride Schmidt/Kuehn/Krause/Teubner/Lehner/Habich TUD (2025, DIMES'25)

### 1. CACHE-STRATEGIEN
- **Strided Access Pattern (§2):** Hauptbefund: "Strided access pattern with a well-chosen stride size clearly outperforms the sequential access pattern. Even a SIMD-accelerated sequential access is considerably slower than the best-performing scalar strided access." → Cache-Strategie wird auf den Kopf gestellt!
- **Partition-based Interpretation (§2):** Daten-Array wird logisch in `n/s` Partitionen geteilt; jede Partition = `s` consecutive Elements; im i-ten Pass wird i-tes Element jeder Partition verarbeitet → multi-stream-prefetcher kann besser arbeiten.
- **DTLB/STLB als Limitierung (§3, Observation 1):** Sapphire Rapids hat DTLB 96 + STLB 2048 Entries; Cascade Lake DTLB 64 + STLB 1536. **Performance-Sprung exakt wenn Partition-Count < TLB-Capacity.** Mit Huge Pages (2 MiB / 1 GiB) verschwindet die Limitierung.
- **L2 Hardware Prefetcher Multi-Stream-Tracking (§3, Observation 2):** Sapphire Rapids trackt bis zu **72 concurrent streams**, Cascade Lake bis zu **32**. Solange Partition-Count < dieses Limit ist, profitiert strided Pattern dramatisch.
- **L1-Prefetcher hat MARGINALEN Effekt** (Fig.3); L2-Prefetcher ist kritisch.
- **Cache-Associativity-Pathologien (§3, Observation 3):** Bei Partition-Counts mit vielen geteilten low-bits (z.B. Multiples of 8/16/24) → Cache-Set-Thrashing, da alle Partitions dieselben Sets mappen.
- **Padding (576 Byte) zwischen Partitions (Fig.4):** Mitigiert Cache-Set-Thrashing bei strided Access.
- **Stride-Strategie outperformed SIMD:** scalar strided 24 GiB/s vs. simd-sequential 19.8 GiB/s (Sapphire Rapids).

### 2. ALGORITHMUS-STRATEGIEN
- **AggSum Variants (§2, Listing 1):**
  - **sequential:** Standard-Loop ueber alle Elemente.
  - **simd-sequential:** AVX-512 Vektorisierung (one SIMD instruction per cache line).
  - **strided:** 2 nested loops, outer ueber stride-positions, inner ueber Elemente mit stride.
  - **strided-unrolled:** Wie strided, aber inner loop manuell unrolled.

- **4 Hauptbeobachtungen (§3):**
  - **Observation 0:** Bei sehr grossen Partition-Counts (>4096), throughput sehr niedrig, steigt smoothly bei >2^24 (mehrere Partitionen pro Cache-Line).
  - **Observation 1:** Im Partition-Count-Range 1024-4096 erster throughput-Anstieg (TLB-Effekt).
  - **Observation 2:** Im Partition-Count-Range <64 zweiter Anstieg, der simd-sequential UEBERSCHREITET (Hardware-Prefetcher).
  - **Observation 3:** Downward-Outlier bei Partition-Counts 8/16/24/... (Cache-Associativity).

- **Macro-Analysis Findings (§4.1):**
  - Optimal Partition-Count fuer Sapphire Rapids: 30-42.
  - Stride-Size soll NICHT power-of-2 (128 MiB) oder multiple-of-power-of-2 (127 MiB) sein.
  - 127.32 MiB Stride mit 42 Partitions liefert 24 GiB/s.

- **Memory-Hierarchy-Tests (§4.2):**
  - **Local DRAM:** strided-unrolled 27.97 GiB/s vs. simd-sequential 19.79 GiB/s vs. sequential 11.97 GiB/s.
  - **Remote DRAM:** strided-unrolled 24.07 GiB/s vs. simd-sequential 11.88 GiB/s — strided KOMPENSIERT remote-latency!
  - **Local HBM:** strided-unrolled 27.84 GiB/s vs. simd-sequential 18.79 GiB/s.
  - **Remote HBM:** ANOMALIE — strided NUR 9.52 GiB/s vs. simd-sequential 10.02 GiB/s; Grund unbekannt (OFFEN).

- **Multi-Threaded (§4.3):** "With a strided access pattern, fewer threads are needed to fully utilize the available bandwidth, saving energy or freeing resources for other (computational) tasks."

- **ConcurrencyDiscipline-Bezug:**
  - **MemoryRead-Discipline:** Direkt — Read-Patterns (sequential vs. strided).
  - **Array-Discipline:** Operiert auf Arrays (1 GiB uint64_t).
  - **SimdFlow-Discipline:** simd-sequential vs. scalar strided ist genau ein Tradeoff hier.
  - **Path-Discipline:** Indirekt — bei multi-partition Access entstehen N parallele Pfade.

- **Mechaniken-Bezug:** Keine direkten Sync-Mechaniken (Single-Threaded Hauptanalyse).

### 3. SONDERMERKMALE
- **Test-Hardware (Tab.1):**
  - **Cascade Lake:** Xeon Gold 6240R, DDR4-192GB, L1D 32KiB, L2 1MiB, L3 35.75MiB, DTLB 64, STLB 1536.
  - **Sapphire Rapids:** Xeon Gold 9468, DDR5-256GB + HBM-64GB, L1D 48KiB, L2 2MiB, L3 105MiB, DTLB 96, STLB 2048.
- **Compiler-Setting:** g++ 14.3.0, `-O3 -march=native -mavx512f -fno-tree-vectorize` (autovectorize OFF).
- **Aligned Allocation:** `aligned_alloc`; 4 KiB pages und 2 MiB transparent huge pages.
- **Hardware-Prefetcher kann (de-)aktiviert werden** zur Analyse — wichtig fuer Saeule B Modellierung.
- **Recommendation:** Disalign partition starting addresses bei column-major tables und struct-of-array constructs zur Cache-Set-Thrashing-Vermeidung.

### 4. PLATTFORM-MODELLIERUNG-BEZUG (Saeule B) — KRITISCH FUER LIVE-MODELLE
- **ICacheLevel/ICacheLine:** Konkrete Werte L1D/L2/L3 fuer beide Generationen; Cache-Line=64 Bytes auf x86.
- **ICacheTopology:** Way-Associativity (8-way L1, 16-way L2, 11-15-way L3) entscheidend fuer Observation 3.
- **ICacheResidency:** Welche Daten gerade in welchem Level sind — strided pattern aendert das Bild.
- **IIsaFeatureSet:** AVX-512 explizit; aber strided scalar OUTPERFORMS AVX-512 simd-sequential.
- **IInterconnect/IBusTopology:** NUMA local vs. remote; CXL referenziert (§1).
- **IMemoryBandwidthModel:** Memory-, bank-, rank-level parallelism explizit in Conclusion (§6, Refs [6, 13, 22]) als "additional factors" fuer Stride-Optimierung — OFFENE Modellierungs-Forschung.
- **IHeuristic:** Optimal-Partition-Count und Optimal-Stride-Size sind (noch nicht formal abgeleitete) Heuristiken — explizit als open issue in §6.
- **IPinningPolicy:** numactl zur Pinning auf NUMA-Node 0; explizite Multi-Socket-Test.
- **ILivePlatformModel:** **DTLB/STLB-Capacity, Prefetcher-Stream-Limit, Cache-Associativity sind LIVE-modelliert werden muessen**, da sie konkret Performance-Decisions treiben. ←← ZENTRALER BEITRAG zu Saeule B.
- **ILiveCpuModel:** Cascade Lake vs. Sapphire Rapids zeigen, dass **PER-GENERATION-Modell** noetig ist (TLB+Prefetcher+Cache differieren stark).

### 5. VERALLGEMEINERUNGS-VORSCHLAEGE
- **Stride-Strategie als ICacheStrategy-Visitor:** `BaseEngineStrategy` (sequential) vs. `CacheEngineStrategy` (strided mit Live-Tuning ueber TLB/Prefetcher/Associativity).
- **"Strided > SIMD" als Re-Denken der Algorithmus-Strategien:** Bei AVX-512-faehigen Plattformen ist scalar strided (mit gut gewaehltem Partition-Count) der bessere Default als simd-sequential.
- **Live-Probing der TLB/Prefetcher-Limits:** ILivePlatformModel kann zur Laufzeit DTLB/STLB-Capacity und Prefetcher-Stream-Count messen → optimale Partition-Count ableiten.
- **Padding-Strategie (576 Bytes)** als ICachePage-Layout-Hint → cache-set-disalignment automatisch.
- **Heterogeneous Memory (DRAM/HBM/Remote):** Stride-Patterns hide latency UNTERSCHIEDLICH gut — pro Memory-Typ optimale Strategie.
- **VAMPIR-Bezug (P33):** Genau die NFP (non-functional properties) memory-pipeline-decisions, die VAMPIR adressiert.

### 6. LUECKEN
- **Keine Formalisierung optimaler Stride-Size** — explizit "we are not yet able to provide a formalization for determining an optimal stride size and partition count" (§6).
- **Memory-/Bank-/Rank-Level-Parallelism** (Refs [6, 13, 22]) noch zu integrieren.
- **Remote HBM Anomalie** (10 GiB/s vs. 23 GiB/s remote DRAM) ungeklaert.
- **Nur Aggregation-Sum (AggSum) getestet:** Komplexere Operationen (Joins, Sorts) wuerden anderes Verhalten zeigen — Verweis auf Blom et al. (3) nur kurz.
- **Nur uint64_t** (uint32_t aehnlich); keine float/double/struct-Tests publiziert.
- **Sapphire Rapids ist neueste, aber nicht Granite Rapids/Sierra Forest** — Generationen-Trend OFFEN.
- **Compiler-Auto-Stride OFFEN:** Manuelles Strided-Coding noetig; keine Auto-Vectorize-Strategie fuer strided.

---

## P33 VAMPIR Poster Berthold/Schmidt/Habich/Lehner/Schirmeier (2023, SPP2377 Kickoff)

### 1. CACHE-STRATEGIEN
- **NFP-Modellierung (Non-Functional Memory Properties):** Heterogene Memory-Properties (latency, throughput, transience/persistence, reliability, wearout, random accessibility, cache coherence) werden EXPLIZIT virtualisiert.
- **Memory Decorators + Memory Management:** Erweiterungen fuer Allokationen mit NFP-Kontext.
- **V-malloc:** Virtuelle Allokation, die unter der Haube DRAM/NVRAM/HBM/... auswaehlt.
- **Cache-Discipline implizit:** Heterogeneous Memory-Hierarchy-Awareness als Cache-Strategie.
- **Memory Optimization Potential:** Pipeline-Reihenfolgen mit unterschiedlicher Cardinality erfordern unterschiedliche Memory-Allocation-Strategien.

### 2. ALGORITHMUS-STRATEGIEN
- **Phase 1: Single-Query Pipeline Scheduling.**
  - **DB:** Effiziente Algorithmen fuer "heterogeneous memory pipeline orderings" considering NFPs.
  - **OS:** Abstractions for heterogeneous memories; virtualization + compensation, transparent migration/replacement.
- **Phase 2: Multi-Query Pipeline Scheduling.**
  - Global schedule + compensation plan.
  - Negotiation at query compile time.
- **Pipeline-Dependency-Graph:** P4 → P3 → P2; P1 separat → DAG-Scheduling.
- **Pipeline Execution Orders (a) vs (b):** unterschiedliche Memory-Size-in-Cardinality vs. Time-as-Execution-Cost — Tradeoff zwischen Memory und Compute.
- **Workpackages:**
  - **WP1:** Design Space Exploration.
  - **WP2:** Compensation.
  - **WP3:** Multidimensional Virtualization.
  - **WP4:** Understanding Data Pipelines (DB).
  - **WP5:** Deep Memory Allocation Scheme (OS).
  - **WP6:** Negotiation and Integration.

- **Non-Functional Memory API:** Schnittstelle zwischen Pipeline-Layer und Memory-Layer.
- **Micro-Engine Managers + Memory Decorators + Micro-Allocators (Hardware-Conscious Access):** Drei-Schichten-Modell.

- **ConcurrencyDiscipline-Bezug:**
  - **DataStructure-Discipline:** Pipelines = Operationen auf strukturierten Daten.
  - **MemoryRead/MemoryWrite/MemoryReadWrite-Discipline:** Disjoint NFP-Anforderungen pro Operation.
  - **SimdFlow-Discipline:** Pipeline-Stages koennen SIMD-Backed sein.
  - **Path-Discipline:** Pipeline-Dependency-Graph IST ein Path-Modell.

- **Mechaniken-Bezug:** Keine expliziten OLC/ROWEX/RCU. Aber: Multi-Query-Negotiation impliziert Sync-Mechanik fuer Compile-Time-Negotiation.

### 3. SONDERMERKMALE
- **Forschungsprojekt SPP2377 Kickoff:** Roadmap-Poster, keine Ergebnisse.
- **System Under Test:**
  - Xeon Phi 7250.
  - NUMA-Nodes.
  - Heterogeneous Memory: DRAM + HBM (MCDRAM in Phi).
  - 36 Tiles, 2D Mesh Interconnect.
  - 4x DMI, 2x16+1x4 PCIe Gen3.
- **PI-Konstellation:** Wolfgang Lehner (DB), Horst Schirmeier (OS), Dirk Habich (DB).
- **RAs:** Andre Berthold, Lennart Schmidt — beide auch Co-Autoren in P32.
- **DFG-Foerderung:** Grant 502444078 (VAMPIR), 502384507 (Memory Diplomat).

### 4. PLATTFORM-MODELLIERUNG-BEZUG (Saeule B) — REINSTES SAEULE-B-PAPER
- **ICacheLevel/ICacheLine/ICacheTopology/ICacheResidency:** Heterogene Memory wird WIE Cache modelliert (DRAM/HBM/NVRAM/...).
- **IInterconnect/IBusTopology:** Xeon Phi 36-Tile 2D-Mesh, EDC, MCDRAM-Anbindung.
- **IMemoryBandwidthModel:** EXPLIZIT NFP-modelliert (latency, throughput).
- **ILivePlatformModel:** Virtualization-Layer ist genau ein ILivePlatformModel — abstrahiert ueber NVRAM/DRAM/HBM.
- **IHeuristic:** Pipeline-Scheduler braucht Heuristiken fuer Memory-Allocation-Entscheidungen.
- **IScheduler:** Multi-Query-Scheduler mit Compile-Time-Negotiation.
- **IMemoryResidency:** Explizit als "Compensation" und "transparent migration/replacement".
- **Phase 2 Multi-Query:** Globale Schedule-Optimierung ueber alle aktiven Queries — orthogonal zur Per-Query-Optimierung in P32.

### 5. VERALLGEMEINERUNGS-VORSCHLAEGE
- **VAMPIR's V-malloc als IMemoryAllocator-Strategie:** Heterogene Memory-Auswahl pro Allokation.
- **Memory Decorator Pattern fuer NFP-Kontext:** Allokationen tragen ihren NFP-Kontext mit.
- **Pipeline-Scheduler als IPipelineScheduler-Concept** fuer Saeule A (Operation-Pipelines) MIT Saeule-B-Memory-Awareness.
- **Compensation-Mechanik:** Transparent migration/replacement von Allokationen wenn NFP-Anforderung sich aendert (vergleichbar mit Move-Semantics + Cache-Hot-Reload).
- **Negotiation API:** Compile-Time-Mechanik fuer Multi-Query-Optimierung — koennte als ICompileNegotiator in BuildSystem verallgemeinert werden.
- **SPP2377 Bezug zu P32:** P32 ist DIE konkrete Demonstration der NFP-Effekte, die VAMPIR zur Optimierung nutzen will. Direkter Forschungs-Faden.

### 6. LUECKEN
- **Poster, keine technische Tiefe** — viele Architekturkomponenten sind nur Boxen ohne Detail.
- **Phase-1-Ergebnisse erst spaeter** (Berthold 2024, Schmidt 2025 in P32 referenziert).
- **NVRAM-Konzepte nicht detailliert.**
- **Compensation-Mechanik nicht spezifiziert.**
- **Negotiation-Protokoll OFFEN.**
- **Konkrete API von V-malloc nicht definiert.**
- **Performance-Daten fehlen.**
- **Multi-Query-Phase 2 vermutlich nicht abgeschlossen** (Stand 2023 Kickoff).

---

## QUERVERWEISE / SYNTHESE

### Welche Synchronisations-Mechaniken sind orthogonal zu welchen ConcurrencyDisziplinen?

Matrix (X = optimal anwendbar, M = mit Aufwand, - = nicht anwendbar):

| Mechanik           | Page | Node | Array | DataStructure | Path | MemRead | MemWrite | MemRW | SimdThread | SimdFlow |
|--------------------|------|------|-------|---------------|------|---------|----------|-------|------------|----------|
| **OLC** (P08)      | X    | X    | M     | X             | X    | X       | X        | X     | -          | -        |
| **ROWEX** (P08)    | X    | X    | M     | X (deterministic)| X | X (fast)| X (slow) | M     | -          | -        |
| **RCU** (P29)      | X    | M    | -     | X (read-mostly)| X (read)| X (no writes!)| -  | -     | -          | -        |
| **HazardPointers** (P30)| X | X    | -     | X             | X    | X       | M        | M     | -          | -        |
| **Stride-Pattern** (P32)| - | -    | X     | -             | -    | X       | -        | -     | M (wechselt zu scalar)| X (Tradeoff) |
| **EpochReclamation** | X  | X    | -     | X             | X    | X       | X        | X     | -          | -        |

**Schluesselbeobachtungen:**
- **OLC + ROWEX + RCU + HP** sind alle 4 fuer **Page/Node/DataStructure/Path** anwendbar — orthogonale Mechaniken-Familie.
- **RCU** ist EINZIGE die explizit "no writes by readers" garantiert (Cache-fundamental optimal fuer read-mostly).
- **HP** ist EINZIGE wait-free → garantierter Forward-Progress unter Thread-Failures.
- **OLC** ist EINZIGE bei der Reader RESTART koennen — Tradeoff zwischen Programmierbarkeit und Worst-Case-Latency.
- **ROWEX** ist EINZIGE bei der Reader NIEMALS blocken/restarten und Daten-Struktur-spezifische Atomizitaet noetig ist.
- **Stride-Pattern (P32)** ist KEINE Sync-Mechanik, sondern eine MemRead/Array-Strategie — orthogonal zu allen Sync-Mechaniken.
- **Epoch-Based-Reclamation** ist Voraussetzung fuer OLC/ROWEX (P08 erwaehnt explizit) — sollte als 4. orthogonale Mechanik gefuehrt werden.

### Welche TUD-Habich-spezifischen Konzepte koennen als IHeuristic / IBusTopology-Beitraege verallgemeinert werden?

**P31 (Ungethuem) — Hardware-Concept-Inventar fuer Saeule B:**
- **IHardwareExtension Concepts:** WAH/PLWAH/COMPAX (Bitmap-Compression), Hash+Lookup/Insert, CityHash32, Hash Sampling, Merge Sort, Intersection, Union, Difference, Sort-Merge-Join, Sort-Merge-Aggregation. → DIREKT modellierbar als IHardwareExtension-Hierarchie.
- **IIsaFeatureSet Concepts:** RISC-Base (Tensilica LX5 80 Inst.), SSE/SSE4 (144 Inst.), AVX/AVX-512, SGX, THUMB, NEON. → IIsaFeatureSet als Concept-Tree.
- **IBusTopology Concepts:** Network-on-Chip (NoC), QPI, InfiniBand, OmniPath, NUMAlink5, AXI/AHB. → IBusTopology als Concept-Tree.
- **IMemoryBandwidthModel Concepts:** SDRAM Timing-Constraints (tRCD, tRP, tCL, tRAS), Bank/Row/Column-Index-Modell, Burst Length 4/8.
- **iDMA als IComputeOffload-Concept:** Push-Down von Operationen zum Memory-Controller — verallgemeinerbar als Strategie "Wo wird Operation ausgefuehrt?".
- **Critical-Path-Heuristik:** Frequency-Tradeoff fuer ISA-Extension-Komplexitaet.

**P32 (Schmidt) — Live-Plattform-Modell-Beitraege fuer Saeule B:**
- **DTLB/STLB-Capacity-Heuristik:** Optimal-Partition-Count = TLB-Capacity. → IHeuristic fuer Allocator + Loop-Tiling.
- **Hardware-Prefetcher-Stream-Limit-Heuristik:** Cascade Lake 32, Sapphire Rapids 72 → optimale Anzahl gleichzeitiger Memory-Streams.
- **Cache-Associativity-Disalignment-Heuristik:** 576-Byte-Padding zwischen Partitions vermeidet Cache-Set-Thrashing. → IPaddingStrategy.
- **"Strided > SIMD" Heuristik:** Bei AVX-512-faehiger Plattform mit grossem TLB+Prefetcher → strided scalar default. → IAccessPatternStrategy.
- **NUMA-Memory-Latency-Hiding-Heuristik:** Strided pattern hides remote latency >> sequential — Heuristik pro IInterconnect.

**P33 (VAMPIR) — Architektur-Framework-Beitraege fuer Saeule B:**
- **NFP-Decorator-Pattern:** Allokationen tragen NFP-Kontext — verallgemeinerbar als IMemoryDecorator.
- **V-malloc:** Heterogene Memory-Allocator-Strategie. → IHeterogeneousAllocator.
- **Compensation/Migration:** Transparente Daten-Migration zwischen Memory-Ebenen. → IMigrationPolicy unter ILivePlatformModel.
- **Pipeline-Scheduler-Negotiation:** Compile-Time-Negotiation fuer Multi-Query-Optimierung. → ICompileTimeNegotiator.

### Wie verhalten sich Hardware-Optimierungen (P31) zur Cache-Engine-Plattform-Modellierung?

**P31 ist die TIEFSTE Quelle fuer Saeule-B-Concept-Inventar im gesamten Cluster F.** Die Tomahawk-Architektur ist ein konkreter Hardware-Prototyp mit:
1. **Heterogeneous Multiprocessor SoC** mit App-Core (control-plane) + N PEs (data-plane).
2. **Scratchpad Memory** statt Cache-Coherent-Memory pro PE → orthogonale Memory-Architektur.
3. **iDMA als Compute-Offload** zum Memory-Controller.
4. **ISA-Extensions** als pluggable Concepts pro PE.
5. **Core Manager** als zentraler Scheduler.

Mapping zur Cache-Engine-Plattform-Modellierung:

| P31 Konzept                | Saeule-B-Concept                          |
|----------------------------|--------------------------------------------|
| App-Core (control)         | ICpuCore (full)                           |
| PE (slim)                  | ICpuCore (slim)                           |
| Scratchpad Memory          | ICacheLevel (no-coherency variant)        |
| Local Data Memory 0+1      | ICacheLine (dual-port)                    |
| Data Prefetcher (next to PE)| IPrefetcher                              |
| iDMA                       | IComputeOffload + IIntelligentDMA          |
| Core Manager               | IScheduler + IPinningPolicy               |
| NoC                        | IInterconnect                             |
| ISA-Extension (WAH/Hash/MergeSort)| IHardwareExtension                 |
| Tensilica LX5 RISC base    | IIsaFeatureSet (RISC base)                |
| Frequency-Scaling am CM    | ILiveCpuModel (DVFS)                      |
| SDRAM Timing (tRCD/tRP/tCL/tRAS)| IMemoryBandwidthModel               |

**Komplementaritaet zwischen Papern:**
- **P31 (TUD 2017):** Statisches Plattform-Modell — manufactured chip, fixed ISA-Extensions.
- **P32 (TUD 2025):** Dynamisches Performance-Modell — runtime-detected TLB/Prefetcher/Associativity-Limits.
- **P33 (TUD 2023):** Virtualisierungs-Framework — ueber heterogene Memory-Ebenen.
- **P08 (TUM 2016):** Synchronisation-Mechaniken (OLC, ROWEX) auf TOP der Plattform.
- **P29 (IBM 2001):** RCU als Synchronisations-Mechanik mit IScheduler-Integration.
- **P30 (IBM 2004):** HazardPointers als wait-free Synchronisations-Mechanik OHNE Scheduler-Support.

### Strategische Konsequenzen fuer comdare-Architektur

1. **ConcurrencyManager 4. Mechanik aufnehmen:** **HazardPointers** zusaetzlich zu OLC/ROWEX/RCU. Optional **EpochBasedReclamation** als 5. Mechanik (von P08 implizit erforderlich).
2. **Saeule B Concept-Inventar aus P31 ableiten:** Kompletter Hardware-Optimization-Concept-Tree (Bitmap-Compression, Hashing, Sort-Merge etc.) als IHardwareExtension.
3. **ILivePlatformModel aus P32 instanziieren:** Runtime-Probing von TLB/Prefetcher/Associativity zur Heuristik-Generierung.
4. **VAMPIR-Pattern (P33) als Architektur-Vorlage:** NFP-Decorator + V-malloc + Compensation + Multi-Query-Negotiation.
5. **ISearchPagesStrategy mit P32-Stride-Heuristik:** scalar-strided wird neuer Default fuer AggSum-aehnliche Operationen, simd-sequential wird "Fallback".
6. **TUD-Habich-Forschungs-Anschluss:** P31/P32/P33 sind alle TUD-Habich-Gruppe → comdare's Saeule B kann als operationalisierte Variante des VAMPIR-Frameworks positioniert werden.
7. **Dresden Database Research Group + TU Dresden Operating Systems Group** als externe Referenz-Ankerpunkte fuer Diplomarbeit.

---

## Status-Zusammenfassung

| Paper | Cache-Strat | Algo-Strat | Sondermerkmale | Saeule-B | Verallg. | Luecken |
|-------|-------------|------------|----------------|----------|----------|---------|
| P08 ART OLC/ROWEX | + + + | + + + (5-Schritt OLC, 4-Schritt ROWEX) | + + (Forward-Progress, Debug-Mode, HTM-Vergleich) | + + (Cache, Multi-Socket impliziert) | + + + (Direkte Vorlage Mechaniken) | Multi-Socket, Recovery, Range-Scans |
| P29 RCU McKenney | + + + (no writes by readers) | + + (Grace Period, Quiescent State, 4 historische Flavors) | + + (FD/Hotplug/Module) | + + (per-CPU, Scheduler) | + + + (comdare-rcu) | 6-Flavors-Klassifikation, Tree-RCU, alte HW |
| P30 Hazard Pointers | + + + (no writes by readers, padding) | + + + (wait-free, 5-Schritt-Application, ABA-Solution) | + + + (Wait-Free, Single-Word) | + + (Per-Thread-State, Userspace) | + + + (4. Mechanik HP) | K-Bestimmung, RCU-Vergleich, alte HW |
| P31 Ungethuem TUD | + + (Scratchpad, Burst, iDMA) | + (HW/SW-Co-Design Survey, ISA-Extensions, iDMA) | + + (DBA, Energie-Effizienz, 100x-1000x Hashing) | + + + + + (DAS Saeule-B-Inventar) | + + + + (Concept-Tree, iDMA-Pattern) | Tomahawk-spezifisch, alte HW, no Concurrency |
| P32 To-Stride TUD | + + + + (Strided>SIMD, TLB, Prefetcher, Associativity) | + + + (4 Observations, Macro-Analysis, NUMA, HBM) | + + + (Sapphire vs Cascade Lake) | + + + + + (Live-Modell-Treiber) | + + + + (Live-Probing, IAccessPattern) | Formalisierung, Bank-Parallelism, HBM-Anomalie |
| P33 VAMPIR Poster | + + (NFP) | + + (Pipeline-Scheduling, V-malloc, Compensation) | + (Poster, kein Detail) | + + + + (Reines Saeule-B-Framework) | + + + (NFP-Decorator, IPipelineScheduler) | Poster, keine Performance, Negotiation OFFEN |

**Gesamt-Bewertung:** Cluster F ist exzellent ausbalanciert: P08/P29/P30 liefern die Sync-Mechaniken (Saeule A operationalisiert ConcurrencyManager), P31/P32/P33 liefern das Hardware-Konzept-Inventar und Live-Plattform-Modell (Saeule B). Die TUD-Habich-Gruppe (P31/P32/P33) bildet einen kohaerenten Forschungs-Faden, der direkt auf die comdare-Saeule-B-Modellierung uebertragbar ist.
