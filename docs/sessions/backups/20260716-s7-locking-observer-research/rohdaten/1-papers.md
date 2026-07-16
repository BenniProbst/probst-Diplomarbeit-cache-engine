# STRANG 1 — Web-Deep-Research: SOTA-Sperrverfahren fuer In-Memory-Index-Strukturen

**Datum:** 2026-07-16
**Auftrag:** USER S-7 — Forschungs-Paper + Code fuer die *Upgradeable-Locking*-Achse (axis_08, Delta-Matrix Dossier 23: "Upgradeable-Locking ohne Organ"). Die Achse muss in der **Suchalgorithmen-Gattung** UND der **Container-Gattung** echt verwendet werden; alle Gattungen ermitteln ihre wichtigen Observer-Messwerte echt (honest-100%).
**Doktrin:** Vendoring `vendor -> faithful -> self-contained` (Paper-Code read-only in `ext/`, Engine in `libs/`); compile-time-only Hot-Path (CRTP + Concepts, kein Runtime-Switch, keine vtable); nur benannte Lehrbuch-Patterns.
**Ziel:** 3–6 Vendoring-Kandidaten (Paper + Code) mit Lizenz-Bewertung.

> Achtung Recherche-Fund (kritisch fuer Vendoring): Zwei der einschlaegigsten Code-Basen (`sfu-dis/optiql`, `wangziqi2016/index-microbench`) tragen **KEINE Lizenz** (GitHub-API `license: null`). Ohne Lizenz = "all rights reserved" = **nicht faithful vendorbar**. Ausweg: den *publizierten Algorithmus* aus dem Paper selbst reimplementieren (erlaubt), Code nur als Referenz lesen — oder Lizenz beim Autor einholen.

---

## 0. Suchmethodik

WebSearch + WebFetch (Juli 2026). Query-Achsen: (a) upgradeable/hierarchische Locks (SIX/intention/update-lock), (b) Optimistic Lock Coupling (Leis), (c) moderne Alternativen (HTM/TSX, EBR, flat combining, MCS/CLH, seqlock, BRAVO). Lizenzen wo moeglich per GitHub-API (`api.github.com/repos/...`) verifiziert, nicht geraten. PDF-Volltexte der Kernpaper waren teils nur binaer abrufbar; Kernaussagen daher aus HTML-Sekundaerquellen (CedarDB-Blog, Semantic Scholar, SFU-Summit, researchr) gegengeprueft.

---

## Teil A — Upgradeable / hierarchische Locks (SIX, intention, update-lock)

### A1. Intention Locks & SIX (Lehrbuch-Grundlage, Gray et al.)
- **Kernidee:** Multi-Granularitaets-Locking (MGL). Bevor ein Lock auf feiner Ebene genommen wird, wird auf groeberer Ebene ein *Intention*-Lock (IS, IX) gesetzt. **SIX** = Shared + Intention-eXclusive: der Halter liest den ganzen Teilbaum shared, plant aber exklusive Aenderung an einzelnen Kindern. Das ist die klassische Wurzel des "upgradeable" Gedankens.
- **B-Tree-Anwendung:** Inserts setzen Write-Intention-Locks entlang des Pfades und *upgraden* sie zu Exclusive erst beim tatsaechlichen Schreiben; beim Split genuegt ein Intent-Lock auf dem Vaterknoten. Write-Locks werden nur waehrend der eigentlichen Speicheraenderung gehalten (kurz), nicht ueber den ganzen Split.
- **Relevanz axis_08:** liefert das Vokabular (IS/IX/SIX/Update) fuer das fehlende Organ; direkt fuer die **Suchbaum-Gattung**.
- **Quellen:** Graefe, "A Survey of B-Tree Locking Techniques" (ACM TODS 2010) — ResearchGate-Eintrag; Wikipedia "Multiple granularity locking"/intent locks.

### A2. Update-Lock / Upgradeable-Read-Write-Lock (praktische Umsetzung)
- **Problem:** Standard-RW-Locks koennen einen gehaltenen Read-Lock **nicht** deadlock-frei zu Write upgraden (zwei Reader wollen gleichzeitig upgraden -> Deadlock). Loesung: ein *dritter* Zustand, der **Update/Upgrade-Lock**: shared gegenueber Readern, exklusiv gegenueber anderen Updatern, deadlock-frei zu Write eskalierbar. Downgrade Write->Update ebenfalls.
- **CODE-KANDIDAT (klarste Referenz):** `npgall/concurrent-locks` — `ReentrantReadWriteUpdateLock` (Java). Drei Modi: Read (shared), **Update** (shared-read, exklusiv unter Updatern, upgradeable-to-write), Write (exklusiv, downgradeable-to-update). 100% Test-Coverage, v1.0.0 auf Maven Central.
- **Lizenz:** **Apache-2.0** (per GitHub bestaetigt). Java -> per Direktive `andere Sprachen nur Feature-Quellen`: **Referenz-only, in C++ reimplementieren**. Lizenz sauber = zitier- und nachbaubar.
- **URL:** https://github.com/npgall/concurrent-locks — Datei: `code/src/main/java/com/googlecode/concurentlocks/ReentrantReadWriteUpdateLock.java`

---

## Teil B — Optimistic Lock Coupling (OLC), Leis et al. — teils schon im Code

### B1. "The ART of Practical Synchronization" (OLC + ROWEX)
- **Autoren/Jahr/Venue:** Viktor Leis, Florian Scheibner, Alfons Kemper, Thomas Neumann — **DaMoN 2016** (12th Intl. Workshop on Data Management on New Hardware).
- **Kernidee OLC:** Statt Shared-Locks pro Knoten ein **Versions-/Lock-Wort** je Knoten (im Kern ein *Seqlock*, s. C6). Reader lesen die Version *vor* dem Zugriff, arbeiten optimistisch ohne Sperre, und **validieren** die Version *nach* dem Zugriff; bei Aenderung -> Restart. Writer nehmen exklusive Sperre und *inkrementieren* die Version beim Freigeben (obsolete-Bit fuer geloeschte Knoten). "Lock coupling" = Vater erst freigeben, wenn Kind validiert.
- **ROWEX** (Read-Optimized Write EXclusion): Reader nie blockiert/nie Restart; Writer nutzen atomare Einzeloperationen, sodass Struktur zu jedem Zeitpunkt konsistent lesbar bleibt — komplexer, aber ohne Reader-Retry.
- **CODE-KANDIDAT (sauber lizenziert!):** `flode/ARTSynchronized` — C++14, Verzeichnisse `ART/`, `OptimisticLockCoupling/`, `ROWEX/`, plus `Epoche.cpp/.h` (EBR-Reclamation), `Key.h`, `example.cpp`. Deps: CMake, TBB, jemalloc. **Lizenz: Apache-2.0** (LICENSE-Datei bestaetigt).
- **Relevanz:** **Suchbaum-Gattung DIREKT** (ART/Trie). Fuer die **Container-Gattung** wiederverwendbar: die `OptimisticLock`-Klasse + `Epoche` (EBR) sind gattungsagnostische Primitive.
- **URLs:** Paper https://db.in.tum.de/~leis/papers/artsync.pdf — Code https://github.com/flode/ARTSynchronized

### B2. "Optimistic Lock Coupling: A Scalable and Efficient General-Purpose Synchronization Method"
- **Venue:** IEEE Data Engineering Bulletin, March 2019 (Vertiefung/Verallgemeinerung von B1). Zeigt OLC als *general-purpose* Methode (B-Trees, BSTs, Trie-Varianten), nicht nur ART.
- **Kernbotschaft:** OLC ist "remarkably simple", verlangt wenige Aenderungen an der Datenstruktur, Lese-Overhead nahe unsynchronisiert. Genau darum als **Baseline** und als eine Achsen-Auspraegung geeignet.
- **URL:** http://sites.computer.org/debull/A19mar/p73.pdf
- **Kanonischer Header-Referenzcode:** `wangziqi2016/index-microbench/BTreeOLC` (C++, single-dir BTreeOLC; ausserdem ARTOLC, BwTree, Masstree, Skiplists). **ACHTUNG Lizenz: `null` (KEINE Lizenz)** — nur als Algorithmus-Referenz lesen, nicht verbatim vendorn. URL: https://github.com/wangziqi2016/index-microbench

### B3. Erklaerung/Validierung (Sekundaerquelle)
- CedarDB "To B or not to B: B-Trees with Optimistic Lock Coupling" — praezise Beschreibung des Versions-Worts, Read-Validate-Retry, "increment version instead of unlocking". Begruendet warum OLC bei B-Trees fast gratis ist (Root wird extrem selten geschrieben: Fanout 1361 -> Root-Write nur alle ~1.85M Inserts). URL: https://cedardb.com/blog/optimistic_btrees/

---

## Teil C — Moderne Alternativen

### C1. OptiQL — robustes optimistisches Queue-Lock (WICHTIGSTER Achsen-Treffer)
- **Autoren/Jahr/Venue:** Ge Shi, Ziyi Yan, Tianzheng Wang — **PACMMOD Vol. 1, No. 3, Sept. 2023** (praesentiert SIGMOD 2024). **DOI: 10.1145/3617336**.
- **Problem:** Reine OLC/optimistische Locks **kollabieren unter hoher Contention** — viele Threads auf wenige Locks -> exzessive Cacheline-Invalidierung, unbegrenzte Retries, Performance-Einbruch.
- **Kernidee:** Erweitert das faire, kompakte **MCS-Queue-Lock** um *optimistische Reads*. Reader lesen weiter lockfrei/validierend (volle Lesegeschwindigkeit), aber unter Contention reihen sich Writer/Upgrader fair in die MCS-Queue ein -> keine Cacheline-Thrashing-Katastrophe. Behaelt **8-Byte-Lockgroesse** und Fairness. Getestet an memory-optimierten **B+-Trees UND ART** (40-Core Dual-Socket).
- **Warum axis_08-Kern:** OptiQL ist genau ein *upgradeable, queue-basiertes Reader-Writer-Optimistic-Lock* — vereint (a) upgradeable + (b) optimistic + robuste Contention. Direkt fuer **beide Gattungen** (Suchbaum via OLC, Container via generisches RW-Lock).
- **CODE-KANDIDAT:** `sfu-dis/optiql` — C++ (84%), CMake; enthaelt OptiQL + Baseline-Locks (u.a. MCS) + B+-Tree + ART als OLC-Use-Cases. **ACHTUNG Lizenz: `null` (KEINE Lizenz, GitHub-API bestaetigt)** -> **nicht verbatim vendorbar**. Weg: Algorithmus aus dem PACMMOD-Paper faithful reimplementieren, oder Lizenz bei SFU-DIS anfragen.
- **URLs:** Paper https://www.cs.sfu.ca/~tzwang/optiql.pdf — Thesis/Abstract https://summit.sfu.ca/item/36274 — Code https://github.com/sfu-dis/optiql — DOI https://dl.acm.org/doi/10.1145/3617336

### C2. Hardware Transactional Memory / Intel TSX
- **Autoren/Jahr/Venue:** Viktor Leis, Alfons Kemper, Thomas Neumann — "Exploiting Hardware Transactional Memory in Main-Memory Databases", **ICDE 2014**.
- **Kernidee:** Jeder Index-Zugriff in eine HW-Transaktion (`XBEGIN/XEND`, Lock-Elision) gewickelt; HW haelt Read/Write-Sets + Conflict-Detection automatisch. Besser als fine-grained Latches, solange Zugriffe disjunkt sind.
- **Grenzen (ehrlich):** Best-effort (kein Commit-Garantie -> Software-Fallback zwingend); Konflikte auf **Cacheline-Granularitaet** (false conflicts A/B in einer Line); TSX teils per Microcode deaktiviert. -> als Achsen-Auspraegung nur mit Fallback-Pfad und Abort-Rate-Observer.
- **Fertige Elision-Primitive:** `ck_elide` in Concurrency Kit (s. C5).
- **URLs:** https://db.in.tum.de/~leis/papers/HTM.pdf — Wikipedia TSX https://en.wikipedia.org/wiki/Transactional_Synchronization_Extensions

### C3. Epoch-Based Reclamation (EBR) / QSBR
- **Kernidee:** Loest das Speicher-Freigabe-Problem unter optimistischem/lockfreiem Zugriff: retirte Knoten kommen in "limbo bags" je Epoche; Freigabe erst wenn alle Threads die Epoche verlassen haben. Extrem niedriger Overhead; Schwaeche: ein haengender Thread blockiert Reclamation. **Jede** optimistische Achsen-Auspraegung (OLC/OptiQL/HTM) braucht so ein Reclamation-Organ -> gattungsuebergreifend.
- **CODE-KANDIDAT (sauber):** `rmind/libqsbr` — C, EBR + QSBR, self-contained, minimal. **Lizenz: BSD-2-Clause** (API-bestaetigt). Alternativ `ck_epoch` (Concurrency Kit) und `Epoche.h` (ARTSynchronized, Apache-2.0).
- **URLs:** https://github.com/rmind/libqsbr — Grundlage: Fraser, "Practical Lock-Freedom" (2004).

### C4. Flat Combining
- **Autoren/Jahr/Venue:** Danny Hendler, Itai Incze, Nir Shavit, Moran Tzafrir — **SPAA 2010**, "Flat Combining and the Synchronization-Parallelism Tradeoff".
- **Kernidee:** Grob-Lock-Paradigma: ein "Combiner"-Thread haelt den globalen Lock und fuehrt die Requests aller anderen (Publication-List thread-lokaler Records) gebuendelt aus. Bei bestimmten Contention-Leveln schneller als fine-grained. Ideal fuer **Container-Gattung** (Queue/Stack/PriorityQueue), weniger fuer Suchbaum.
- **CODE:** `mit-carbon/Flat-Combining` — C/C++, `data_structures/`, `framework/`, Tests. **Lizenz: NICHT ausgewiesen (RISIKO)** -> nur Paper-Referenz, nicht vendorn ohne Klaerung. Alternative mit klarer Lizenz: `libcds` (`cds::algo::flat_combining`, BSD-2-Clause).
- **URLs:** Paper https://people.csail.mit.edu/shanir/publications/Flat%20Combining%20SPAA%2010.pdf — Code http://github.com/mit-carbon/Flat-Combining — libcds https://libcds.sourceforge.net/doc/cds-api/namespacecds_1_1algo_1_1flat__combining.html

### C5. MCS / CLH Queue-Locks (+ NUMA-Cohort)
- **Grundlage:** Mellor-Crummey & Scott (MCS, 1991) — Thread spinnt auf *eigenem* Knoten (lokal, NUMA/interconnect-schonend); Craig / Landin & Hagersten (CLH) — Queue tail->head, besserer Fast-Path. Cohort-MCS / HCLH = zwei-Ebenen fuer NUMA. Fundament von OptiQL (C1) und generisches Container-Lock.
- **Quellen:** Scott et al. "Scalable Queue-Based Spin Locks with Timeout" (PPoPP 2001) https://www.cs.rochester.edu/u/scott/papers/2001_PPoPP_Timeout.pdf ; Chabbi/Fagan/Mellor-Crummey "High Performance Locks for Multi-level NUMA Systems" (PPoPP 2015) https://dl.acm.org/doi/pdf/10.1145/2688500.2688503

### C5b. Concurrency Kit (ck) — BEST self-contained Primitiv-Quelle fuer Container-Gattung
- **Inhalt:** `ck_spinlock` (inkl. MCS, CLH, NUMA-CLH), `ck_rwlock` (write-biased, scalable read-side), `ck_sequence` (**Seqlock**), `ck_epoch` (**EBR**), Hazard Pointers (`ck_hp`), `ck_elide` (**HTM Lock-Elision**), diverse Barrieren. C99+, self-contained, portabel.
- **Lizenz (verifiziert per LICENSE-Datei):** **BSD-2-Clause** (Core, Samy Al Bahra / AppNexus). Ausnahmen: `ck_hp.c` = **Apache-2.0** (IBM); `ck_pr_rtm` = Intel-BSD-style. -> selektiv vendorn (Core BSD-2 unproblematisch; Apache-Teil nur mitnehmen wenn gewuenscht). GitHub-Lizenz-Detektor meldet "NOASSERTION" nur wegen der Mischung, nicht wegen Fehlens.
- **Relevanz:** **Container-Gattung DIREKT** — liefert MCS/CLH/rwlock/seqlock/epoch/elide als fertige, messbare Achsen-Auspraegungen; fuer Suchbaum liefert es Seqlock (= OLC-Kern) + EBR.
- **URLs:** https://github.com/concurrencykit/ck — LICENSE https://raw.githubusercontent.com/concurrencykit/ck/master/LICENSE — `include/spinlock/mcs.h`

### C6. Seqlock (Sequence Lock)
- **Kernidee:** Writer inkrementiert Zaehler vor+nach dem Schreiben (odd = write in progress); Reader liest Zaehler vor+nach, retryt bis gerade+unveraendert. Non-blocking optimistic read, Writer-bevorzugt. **Das ist exakt der theoretische Kern des OLC-Versionsworts (B1).** Kernel-API `read_seqbegin_or_lock` zeigt eleganten Optimistic->Pessimistic-Fallback.
- **Quellen:** Linux Kernel Doc https://docs.kernel.org/locking/seqlock.html ; Wikipedia https://en.wikipedia.org/wiki/Seqlock ; fertige Impl: `ck_sequence` (BSD-2, s. C5b).

### C7. BRAVO — Biased Reader-Writer Locks
- **Autoren/Jahr/Venue:** Dave Dice, Alex Kogan (Oracle Labs) — **USENIX ATC 2019**.
- **Kernidee:** Transformation, die *jedes* bestehende RW-Lock um 2 Integer erweitert; Reader machen sich via Hash(Thread-ID, Lock-Adresse) in einer "visible readers table" sichtbar -> keine Cacheline-Contention auf dem zentralen Reader-Counter bei read-heavy Workloads, quasi-null Overhead. Ergaenzend/orthogonal zu OptiQL; als Achsen-Variante fuer read-dominierte Container interessant.
- **URLs:** https://www.usenix.org/system/files/atc19-dice.pdf — arXiv https://arxiv.org/abs/1810.01553

### C8. Rust-Referenzen (OLC B+-Tree, LeanStore/Umbra-Linie) — Feature-Quellen
- `surrealdb/ferntree` — Rust, **Apache-2.0** — OLC B+-Tree mit **drei Zugriffsmodi Optimistic / Shared / Exclusive** (== upgradeable Drei-Modus-Semantik axis_08!), EBR, Range-Queries, Split/Merge. Status: beta. URL: https://github.com/surrealdb/ferntree
- `NeowayLabs/bplustree` — Rust, **Apache-2.0 + MIT** — OLC B+-Tree "based on LeanStore with adaptations from Umbra". URL: https://github.com/NeowayLabs/bplustree
- Rust -> per Direktive **Feature-Quellen**: algorithmische Referenz + saubere Lizenz, in C++ nachbauen.

---

## Teil D — Vendoring-Kandidaten-Matrix (Lizenz-Bewertung, Doktrin `vendor -> faithful -> self-contained`)

| # | Paper / Quelle | Code | Sprache | Lizenz | Gattung | Vendoring-Verdikt |
|---|---|---|---|---|---|---|
| K1 | Leis DaMoN'16 (OLC+ROWEX) | `flode/ARTSynchronized` | C++14 | **Apache-2.0** (verifiz.) | Suchbaum direkt; Container via OptimisticLock+Epoche | **VENDOR-OK** — sauber, C++, `ext/` read-only. Primaerkandidat Suchbaum. |
| K2 | ck-Primitive (MCS/CLH/rwlock/seqlock/epoch/elide) | `concurrencykit/ck` | C99 | **BSD-2** (Core; ck_hp=Apache-2.0) | Container direkt; Suchbaum via seqlock/EBR | **VENDOR-OK** — selektiv (Core BSD-2). Primaerkandidat Container-Primitive. |
| K3 | Fraser 2004 / EBR | `rmind/libqsbr` | C | **BSD-2** (verifiz.) | beide (Reclamation-Organ) | **VENDOR-OK** — klein, self-contained. Reclamation fuer alle optimistischen Achsen. |
| K4 | **OptiQL** (PACMMOD 2023 / SIGMOD'24) | `sfu-dis/optiql` | C++ | **KEINE (null!)** | beide (B+Tree+ART) — Achsen-Kern | **FAITHFUL-REIMPL** — Code NICHT vendorbar; Algorithmus aus Paper nachbauen ODER Lizenz einholen. |
| K5 | Update-Lock (SIX/Update-State) | `npgall/concurrent-locks` | Java | **Apache-2.0** (verifiz.) | Suchbaum+Container | **FEATURE-QUELLE** — sauberste Upgrade-State-Machine-Referenz; in C++ reimplementieren. |
| K6 | OLC B+Tree (LeanStore/Umbra) | `surrealdb/ferntree`, `NeowayLabs/bplustree` | Rust | **Apache-2.0** (+MIT) | Suchbaum (3-Modus == upgradeable) | **FEATURE-QUELLE** — algorithm. Referenz Drei-Modus-Lock; in C++ reimplementieren. |
| K7 | Flat Combining (SPAA'10) | `mit-carbon/Flat-Combining` | C/C++ | **UNKLAR (Risiko)** | Container | **NUR PAPER** — Lizenz fehlt; falls gewuenscht `libcds` (BSD-2) als Ersatz. |
| K8 | OLC Bull.'19 (kanon. BTreeOLC) | `wangziqi2016/index-microbench` | C++ | **KEINE (null!)** | beide | **NUR REFERENZ** — nicht vendorbar; Algorithmus lesen, ARTSynchronized (K1) bevorzugen. |

**Empfohlene 3–6 fuer die Achse:** K1 (ARTSynchronized, Apache) + K2 (ck, BSD) + K3 (libqsbr, BSD) als **vendorbare** Basis; K4 (OptiQL) als **faithful reimplementierte** Kern-Auspraegung (der eigentliche "upgradeable + robust"-Treffer); K5 (concurrent-locks) + K6 (ferntree) als **Feature-Quellen** fuer die Upgrade/Drei-Modus-State-Machine.

---

## Teil E — Beide Gattungen + Observer-Messwerte (honest-100%)

**Compile-time-Verankerung (Doktrin):** Jede Lock-Strategie = Policy-Typ, per CRTP-Basis + Concept-Guard statisch dispatcht (keine vtable, kein Runtime-Switch). Achsen-Auspraegungen z.B.: `LockCouplingPessimistic`, `OptimisticLockCoupling`, `ROWEX`, `OptiQLPolicy`, `HtmElisionPolicy`, `McsRwPolicy`, `SeqlockPolicy`, `FlatCombiningPolicy`.

**Suchalgorithmen-Gattung** (B-Tree / Trie / ART) — echte Observer:
- OLC-Restart-Count / Read-Version-Validation-Failures (Retry-Rate)
- Exclusive-Upgrade-Count (Read/Update -> Write Eskalationen)
- Lock-Coupling-Tiefe, Root-Contention-Rate
- Throughput ops/s, Latenz p50/p99, HTM-Abort- + Fallback-Rate (falls TSX)

**Container-Gattung** (Queue/Stack/Map/Set) — echte Observer:
- Lock-Modus-Verteilung Optimistic/Shared/Update/Exclusive
- Writer-Serialisierungszeit, MCS-Queue-Laenge (Contention-Proxy)
- Cacheline-Invalidierungen (perf-Counter), NUMA-Remote-Access-Rate
- Flat-Combining: Combiner-Batch-Groesse; EBR: Reclamation-Lag (Epochen)

Beide Gattungen teilen das **Reclamation-Organ** (K3/EBR) und das **Versions-/Seqlock-Primitiv** (K1/K2) — dadurch wird die Achse in beiden Gattungen echt (nicht als Phantom) verwendet und gemessen.

---

## Teil F — Quellen (URLs)

**Paper**
- OLC+ROWEX (DaMoN'16): https://db.in.tum.de/~leis/papers/artsync.pdf
- OLC general-purpose (Data Eng. Bull. 2019): http://sites.computer.org/debull/A19mar/p73.pdf
- OptiQL (PACMMOD 2023): https://www.cs.sfu.ca/~tzwang/optiql.pdf | https://dl.acm.org/doi/10.1145/3617336 | https://summit.sfu.ca/item/36274
- HTM Main-Memory DBs (ICDE'14): https://db.in.tum.de/~leis/papers/HTM.pdf
- Flat Combining (SPAA'10): https://people.csail.mit.edu/shanir/publications/Flat%20Combining%20SPAA%2010.pdf
- Queue-Locks/Timeout (PPoPP'01): https://www.cs.rochester.edu/u/scott/papers/2001_PPoPP_Timeout.pdf
- NUMA-Locks (PPoPP'15): https://dl.acm.org/doi/pdf/10.1145/2688500.2688503
- BRAVO (USENIX ATC'19): https://www.usenix.org/system/files/atc19-dice.pdf | https://arxiv.org/abs/1810.01553
- Graefe, B-Tree Locking Survey (TODS'10): https://www.researchgate.net/publication/220225547_A_Survey_of_B-Tree_Locking_Techniques
- Seqlock (Kernel Doc): https://docs.kernel.org/locking/seqlock.html | https://en.wikipedia.org/wiki/Seqlock
- CedarDB OLC-Erklaerung: https://cedardb.com/blog/optimistic_btrees/

**Code (Lizenz-Status)**
- flode/ARTSynchronized — Apache-2.0: https://github.com/flode/ARTSynchronized
- concurrencykit/ck — BSD-2 (ck_hp Apache-2.0): https://github.com/concurrencykit/ck
- rmind/libqsbr — BSD-2: https://github.com/rmind/libqsbr
- sfu-dis/optiql — KEINE Lizenz: https://github.com/sfu-dis/optiql
- wangziqi2016/index-microbench — KEINE Lizenz: https://github.com/wangziqi2016/index-microbench
- npgall/concurrent-locks — Apache-2.0: https://github.com/npgall/concurrent-locks
- surrealdb/ferntree — Apache-2.0: https://github.com/surrealdb/ferntree
- NeowayLabs/bplustree — Apache-2.0 + MIT: https://github.com/NeowayLabs/bplustree
- mit-carbon/Flat-Combining — Lizenz unklar: https://github.com/mit-carbon/Flat-Combining
- libcds (flat_combining Alternative) — BSD-2: https://libcds.sourceforge.net/
