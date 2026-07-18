# BEFUND — Pareto-Objectives je Achse für T6 / T18 / T5 (Deep Research, 2026-07-09)

> **Zweck:** Der M0-Befund (`docs/audits/20260709-axes-optimization-deep-research-BEFUND.md`,
> §4 „Ehrliche Rest-Unsicherheiten") hat festgestellt, dass **T6 (allocator)**, **T18 (queuing_q2/Flush)**
> und **T5 (memory_layout/NUMA)** **kein Einzelextremum** haben, sondern **Pareto-Punkte** — die
> Optimierung ist multi-objektiv. Diese Datei bestimmt je Achse (a) die Pareto-Dimensionen, (b) die
> **Thesis-belegte** Verankerung (datei:zeile), (c) die **peer-reviewed-Literatur**, (d) die
> **empfohlene Default-Objective** samt Begründung und (e) die Konsequenz für die E4′-Endauswertung,
> die auf dem bestehenden GoF-Strategy-Selektor `cacheline_policy_selector.hpp` aufbaut.
>
> **Ehrlichkeits-Markierung durchgängig:** `[THESIS]` = im Diplomarbeit-Text/Code belegt · `[LIT]` =
> peer-reviewed Literatur · `[EMPF]` = Empfehlung dieses Befunds (Schlussfolgerung, nicht direkt belegt).
>
> **Autoritative lokale Quellen (verifiziert gegen den Klon-Stand):**
> `thesis/diplomarbeit/kapitel/de/{02_suchbaeume_grundlagen,03_messsystem_prtart,04_concept_architecture,04_implementierung,06_evaluation_methodology}.tex`
> · ce `Code/external/comdare-cache-engine/libs/cache_engine/builder/cacheline_policy/cacheline_policy_selector.hpp`.

---

## 0. Die Pareto-Klammer — warum „ein Extremum" hier falsch wäre

### 0.1 Die Diplomarbeit hat ihr eigenes 3-dimensionales Trade-off-Modell `[THESIS]`

Die Thesis operationalisiert das Messen **explizit als 3-Komponenten-Trade-off**, nicht als Einzelgröße
(`02_suchbaeume_grundlagen.tex:594-601`):

> „Was diese Mess-Muster konkret erheben, sind **drei gegenläufige Komponenten** — *Latenz*, *Durchsatz*
> und *Speicherverbrauch* —, gegen die sich **jede Achsen-Permutation als Trade-off-Profil** aufspannen
> lässt: dieselbe Permutation … erscheint hier als **Punkt im Inneren des Trade-off-Dreiecks**."

Die Abbildung `fig:measurement-triangle` (`02_suchbaeume_grundlagen.tex:602-622`) zeichnet das Dreieck
mit den Ecken **Latenz (p50/p99)** · **Durchsatz (ops/s)** · **Speicher (Bytes im Peak)** und markiert eine
vierte, noch nicht erhobene Komponente (cache-bewusste HW-PMC-Ebene). **Das ist die Thesis-eigene
Pareto-Formulierung** — eine Achse „optimiert" nie eine Größe absolut, sondern verschiebt den Punkt
im Dreieck. Genau das begründet, warum T6/T18/T5 eine **explizite Objective** brauchen.

### 0.2 Die kanonische peer-reviewed Klammer: die RUM-Konjektur `[LIT]`

Das Trade-off-Dreieck der Thesis ist die projektspezifische Operationalisierung dessen, was die
Datenbank-Community als **RUM-Konjektur** kennt: Athanassoulis, Kester, Maas, Stoica, Idreos, Ailamaki,
Callaghan, *Designing Access Methods: The RUM Conjecture*, **EDBT 2016**. Kernaussage: Zugriffsmethoden
balancieren **R**ead-Kosten, **U**pdate-Kosten und **M**emory-Overhead; **wer zwei davon optimiert,
verschlechtert zwangsläufig das dritte** — es gibt keinen Punkt, der alle drei zugleich minimiert. Das
Paper zieht daraus explizit den Schluss, dass zukünftige Systeme **RUM-aware / adaptiv** sein müssen (den
Betriebspunkt je Last wählen). Das ist die literaturseitige Legitimation für „kein Einzelextremum, sondern
eine per-Last gewählte Objective".

> **Abbildung Thesis-Dreieck ↔ RUM (kognat, nicht 1:1):** Latenz ≈ R (Lese-/Lookup-Kosten) · Durchsatz ≈
> Kehrwert von U (Update-Durchsatz) · Speicher ≈ M. Die Thesis-Achse *Durchsatz* umfasst Lese- **und**
> Schreibpfad, RUMs *U* nur den Schreibpfad — beide sind 3-Wege-Trade-offs derselben Familie, aber nicht
> deckungsgleich. Ich führe beide Rahmen, weil das Dreieck die Mess-Achsen der Endauswertung liefert und
> RUM die peer-reviewed Begründung „keine Einzelgröße".

### 0.3 Der Strategy-Hook existiert bereits im Code `[THESIS]`

`cacheline_policy_selector.hpp` kapselt das Auswahl-Kriterium bereits als **austauschbares GoF-Strategy-
Template** und benennt im Header **drei** Objectives, von denen erst zwei implementiert sind
(`cacheline_policy_selector.hpp:29-30`):

> „das Auswahl-Kriterium (**PolicyObjective: scan-/latenz-/durchsatz-optimierend**) ist als austauschbares
> Template-Policy gekapselt; die Cap-Klammerung bleibt invariant."

Implementiert: `ScanOptimizing` (Default, `:141-178`) und `LatencyOptimizing` (`:180-193`). **`durchsatz-
optimierend` ist im Header bereits vorgesehen, aber noch nicht als Strategy-Typ gebaut** — das ist genau
der Ausbaupunkt, den T6 braucht (§1.4). Die Endauswertung (Deliverable-4-Heuristik) ist damit
architektonisch schon dafür ausgelegt, die Objective explizit zu machen; sie muss nur um die fehlenden
Objective-Strategien und die per-Objective-Kurvenscharen erweitert werden (§4).

### 0.4 Die Endauswertung nennt die Zielgröße bereits variabel `[THESIS]`

Die Evaluationsmethodik beschreibt die (noch nicht implementierte) Heuristik-Extraktion und legt die
Zielgröße **explizit als wählbar** fest (`06_evaluation_methodology.tex:161-164`):

> „Zielgröße ist die je Lastmuster gemessene Bestleistung (**etwa Durchsatz oder Tail-Latenz**)."

Das ist die Thesis-eigene Bestätigung, dass die Auswertung **objective-parametrisiert** sein soll —
Durchsatz **oder** Tail-Latenz sind zwei verschiedene Betriebspunkte, nicht ein einzelnes Optimum. Ebenso
`04_concept_architecture.tex:364-375` (ML-Klassifikator liefert „beste Achsen-Komposition je Last- und
Datentyp-Profil"; **noch nicht implementiert**).

---

## 1. T6 — allocator (Allokation + Reklamation, 7 Sub-Familien) — **RC⚠ `pool_budget_bytes`**

### 1.1 Pareto-Dimensionen
Der Allokator ist selbst ein Mini-RUM-Problem. Drei gegenläufige, real messbare Größen (M0 §T6, Mess-Kat.
THR/LAT(p99)/MEM):

1. **Alloc-Durchsatz / Multicore-Skalierung** (ops/s über Threads) — Ecke *Durchsatz*.
2. **Speicher-Fußabdruck / Fragmentierung** (steady-state RSS) — Ecke *Speicher*.
3. **Tail-Alloc-Latenz** (p99, Stalls durch Purge/Reklamation) — Ecke *Latenz*.
   (Sub-Achse Reklamation: MIN Reklamations-Stall ⟂ MAX Sicherheit; NUMA-/Thread-Lokalität als 7. Sub-Achse.)

Kein Allokator dominiert alle drei — z. B. erkauft **eager purging** (mimalloc) niedrigen RSS durch mehr
Page-Faults/mögliche Tail-Latenz; **jemalloc** priorisiert Langläufer-Fragmentierungsresistenz über
Spitzendurchsatz. Das ist ein klassischer Pareto-Trade-off.

### 1.2 Thesis-Verankerung `[THESIS]`
- **T6 ist die dichtest besetzte Achse, in 7 Sub-Achsen zerlegt** — u. a. Free-List-Topologie,
  **Thread-Lokalität/NUMA-Affinität**, Allokationsstrategie, Reklamation (Epoch/RCU/Hazard/QSBR)
  (`03_messsystem_prtart.tex:154-159`).
- **`expected_workload`-Tabelle koppelt Allokator-Wahl an die Last** (`03_messsystem_prtart.tex:172-186`,
  Tab. `tab:allocator-profiles`): `mimalloc/snmalloc/scalloc/hoard → YCSB_A` (insert/update-heavy),
  `jemalloc/michael_lockfree/lrmalloc → YCSB_B` (read-heavy-mixed), `tcmalloc/rpmalloc/dlmalloc → YCSB_C`
  (read-only). Das ist die code-nahe Aussage, dass **je nach Last ein anderer Allokator „gewinnt"** — also
  ein per-Last gewählter Pareto-Punkt, kein globales Optimum.
- **RC-Feld `pool_budget_bytes`** ist der einzige legitime Laufzeit-Kanal (Cap 1 GiB, Setter fehlt =
  #221-Phantom; M0 §0.2). Die vorhandene Heuristik setzt es **linear im Working-Set** (`ws × Record-Größe`,
  `cacheline_policy_selector.hpp:166-167`) — das ist eine **durchsatz-/kapazitätsorientierte** Kurve
  (mehr Arena = weniger Nachforderungen), **nicht** fußabdruck-minimierend.
- Prüfling-Baustein: **4+1+2-Pool-Allokator** (`04_implementierung.tex:45-46,71`), Apparat-Default-Fallback
  `Std. Std-Malloc` (`04_implementierung.tex:175`).

### 1.3 Literatur `[LIT]`
- **RUM-Konjektur** (EDBT 2016) — R/U/M-Trade-off, hier: Alloc-Durchsatz vs. RSS vs. Tail.
- **Leijen, Zorn, de Moura, *Mimalloc: Free List Sharding in Action*, APLAS 2019** (Springer LNCS 11893;
  MSR-TR-2019-18). Free-List-Sharding erhöht **gleichzeitig** Durchsatz *und* Lokalität und senkt
  Fragmentierung; **eager page purging** gibt leere Pages früh ans OS zurück → **niedriger RSS in
  Langläufern**, aber als bewusster Trade-off gegen mögliche Re-Fault-Kosten. Belegt Durchsatzführung ggü.
  tcmalloc/jemalloc (7 %/14 % auf redis).
- **Berger, McKinley, Blumofe, Wilson, *Hoard: A Scalable Memory Allocator for Multithreaded
  Applications*, ASPLOS 2000** — beweist **beschränkten „blowup"** (Fragmentierung) *bei* Skalierbarkeit;
  der kanonische Beleg, dass Skalierung und Fragmentierung ein Trade-off-Paar sind.
- **Evans, *jemalloc*** (BSD-2) — fragmentierungs-/Langläufer-orientiert; **Google TCMalloc** —
  durchsatz-/thread-cache-orientiert. Vergleichsbasis: scalloc (arXiv 1503.09006) und mimalloc-bench.
- **McKenney, *RCU* (2001) / Michael, *Hazard Pointers*, IEEE TPDS 2004** — Reklamations-Sub-Achse
  (Stall vs. Sicherheit).

### 1.4 Empfohlene Default-Objective: **`ThroughputOptimizing` (Alloc-Durchsatz / Multicore-Skalierung)** `[EMPF]`
**Begründung:** (a) Der Allokator ist im Cache-Engine-Kontext **auf dem Schreib-/Insert-/RMW-Pfad**
kritisch (YCSB-A, LP12) — das ist genau der Bereich, in dem die `expected_workload`-Tabelle die
skalierenden Allokatoren (mimalloc/snmalloc/scalloc/hoard) auf `YCSB_A` routet `[THESIS]`. (b) Der einzige
Laufzeit-Knopf `pool_budget_bytes` und seine bestehende Heuristik (linear im WS) sind bereits
**durchsatz-/kapazitätsorientiert** `[THESIS]`. (c) Der Header des Selektors sieht `durchsatz-optimierend`
schon vor `[THESIS]` — der Default-Objective-Ausbau schließt genau diese Lücke.
**Zweite und dritte Pareto-Endpunkte** (als eigene Objectives auszuweisen): **`FootprintOptimizing`**
(steady-state RSS minimieren — jemalloc/Langläufer, engeres `pool_budget`) und **`TailLatencyOptimizing`**
(p99 minimieren — Purge-/Reklamations-Stalls vermeiden). Für Read-only-Lasten (YCSB-C) ist der Allokator
weitgehend last-neutral → dort kollabieren die Objectives (Allokator kaum gestresst).

---

## 2. T18 — queuing_q2 / Flush-Policy (FS1–FS4) — **CT+asp (Threshold), honest-0 auf RC**

### 2.1 Pareto-Dimensionen
Die klarste Pareto-Achse der drei — der M0-Befund schreibt sie bereits als **XOR** (`⊻`):
`MIN Write-Amplification / MAX Batching (lazy)` **⊻** `MIN Staleness / Tail-Latenz (eager)`. Drei
gegenläufige Größen (Mess-Kat. THR/LAT/MEM):

1. **Write-Amplification / Write-Durchsatz** — lazy / high-watermark: seltenere, größere Flushes →
   weniger Schreibverstärkung, höherer Ingest-Durchsatz — Ecke *Durchsatz*.
2. **Staleness / Read-after-Write-Latenz (Tail)** — eager / low-watermark: früher Flush → frischere Reads,
   niedrigere Latenz — Ecke *Latenz*.
3. **Puffer-Speicher (Fill)** — Watermark-Schwelle bestimmt Peak-Puffer — Ecke *Speicher*.

Die Watermark-Schwelle (`threshold_pct {50/65/75/85/95}`, M0 §T18) ist der **stufenlose Regler entlang der
Pareto-Front**; `AdaptiveLsmFlush` (EWMA) lernt den Betriebspunkt zur Laufzeit.

### 2.2 Thesis-Verankerung `[THESIS]`
- **Varianten + Default:** „Eager, Lazy, Watermark, Timed, Adaptiv-LSM", **`Std. Lazy`**
  (`04_implementierung.tex:187`; ebenso `03_messsystem_prtart.tex:86` / `04_concept_architecture.tex:106`:
  „Eager/Lazy, Watermark (LSM), Timed … **adaptive EWMA-Flush-Policy (eigen)**"). **Der Thesis-Default ist
  Lazy** — d. h. die Diplomarbeit setzt den Default-Betriebspunkt bewusst auf das
  **write-amplification-/durchsatz-optimierende** Ende der Pareto-Front.
- **Last-Abhängigkeit** (M0 §T18(4), aus Thesis-Workload-Routing `06_evaluation_methodology.tex:75-77`):
  lazy/high-watermark gewinnt write-heavy (YCSB-A, `HOT_PATH`); eager/low-watermark gewinnt
  Read-after-Write-Freshness + niedrige Latenz (mixed).
- **Parameter-Art:** `threshold_pct`/`window_ms` sind **compile-time-Aspekte** (honest-0 auf RC), Kandidat
  für künftigen Laufzeit-Knopf (M0 §0.2/§3.2). Die Objective steuert hier also die **Binary-Auswahl**
  (welche FS-Permutation gewinnt), nicht ein RC-Feld.

### 2.3 Literatur `[LIT]`
- **O'Neil, Cheng, Gawlick, O'Neil, *The Log-Structured Merge-Tree (LSM-Tree)*, Acta Informatica 1996** —
  Ursprung des Flush/Merge-Write-Amplification-Trade-offs.
- **Dayan, Athanassoulis, Idreos, *Monkey: Optimal Navigable Key-Value Store*, SIGMOD 2017** — zeigt, dass
  LSM-Stores **Update- gegen Lookup-Kosten (und Memory)** eintauschen, und **navigiert den Design-Raum
  holistisch** (co-tuned merge-policy, size-ratio, buffer-size, Bloom-FPR). Das peer-reviewed Fundament
  dafür, dass die Flush-/Merge-Wahl ein **navigierbarer Pareto-Punkt** ist, kein Einzeloptimum.
- **Dayan, Idreos, *Dostoevsky: Better Space-Time Trade-Offs for LSM-Tree Based Key-Value Stores*, SIGMOD
  2018** — führt **Lazy Leveling** ein: entfernt Merge-Arbeit von allen Ebenen außer der größten →
  **deutlich bessere Write-Kosten bei ähnlicher Point-Lookup-/Range-/Space-Kost**. Das ist der **exakte,
  benannte Beleg** für den Thesis-Default `Lazy = write-optimiert`: „lazy" ist nicht Bequemlichkeit,
  sondern der wissenschaftlich benannte write-optimierende Pareto-Punkt.
- **RUM-Konjektur** (EDBT 2016) — R/U/M direkt: Lookup (R) vs. Update/Flush (U) vs. Puffer-/Space (M).
- Adaptive-EWMA-Flush ist ein **Thesis-Eigenbeitrag** (`[THESIS]`, `04_concept_architecture.tex:106`);
  RocksDB/Kafka-Vorbilder sind **nicht** peer-reviewed → Monkey/Dostoevsky sind die zitierfähige Basis.

### 2.4 Empfohlene Default-Objective: **`WriteAmplificationOptimizing` (lazy / high-watermark)** `[EMPF]`
**Begründung:** Der Thesis-Default ist explizit `Std. Lazy` `[THESIS]`, und *Dostoevsky* liefert den
peer-reviewed Namen und Beweis, dass Lazy der write-optimierende Punkt bei nahezu unveränderter
Lookup-/Space-Kost ist `[LIT]`. Der **zweite Pareto-Endpunkt als eigene Objective**:
**`StalenessOptimizing` / `LatencyOptimizing`** (eager / low-watermark) für Read-after-Write-Freshness und
Tail-Latenz. **`AdaptiveObjective`** (EWMA) bildet den lernenden Mittelpunkt für wechselnde Lasten. Die
Endauswertung darf **nicht** ein einzelnes Flush-Extremum behaupten, sondern muss beide Endpunkte als
getrennte Kurvenscharen ausweisen (write-heavy → Lazy-Kurve; freshness-/mixed → Eager-Kurve).

---

## 3. T5 — memory_layout / NUMA (5 RepresentationKind) — **CT, honest-0 auf RC (NUMA doku-only)**

### 3.1 Pareto-Dimensionen
Zwei verschränkte Pareto-Ebenen:

**(a) Layout-Repräsentation** (AoS-aligned / SoA / AoSoA / CSS·CSB⁺ / LOUDS-bitgepackt):
1. **Cache-Line-Auslastung / Scan-&-SIMD-Durchsatz** (CSB⁺ eliminiert Kind-Pointer → höherer Fanout/CL;
   SoA/AoSoA für sequenziellen SIMD-Scan) — Ecke *Durchsatz/CLU*.
2. **Speicher-Fußabdruck** (LOUDS/succinct bit-gepackt, ~10 bit/Knoten) — Ecke *Speicher*.
3. **Point-Lookup-Latenz** (AoS-aligned: ein Knoten = eine Cache-Line, kein Gather) — Ecke *Latenz*.

**(b) NUMA-Platzierung** (Sub-Dimension, in der Thesis als „NUMA-konformes Read-Pinning"):
- **Lokale Latenz** (first-touch / Read-Pinning: Daten auf dem zugreifenden Node) **⟂**
  **Aggregat-Bandbreite** (Interleaving über Nodes: verteilt Traffic, vermeidet Kanal-Kongestion).

### 3.2 Thesis-Verankerung `[THESIS]`
- **Varianten + Default:** „AoS, Cache-Line-aligned, SoA, Bitmap (LOUDS), AoSoA", **`Std. Cache-Line`**
  (`04_implementierung.tex:174`; Repräsentations-Aufzählung `04_concept_architecture.tex:93` /
  `03_messsystem_prtart.tex:73`: „AoS-aligned, SoA, LOUDS-bitgepackt, CSS/CSB⁺, AoSoA … **vier
  Layout-Dimensionen permutierbar**"). **Der Thesis-Default ist Cache-Line-aligned** = der
  **CLU-/scan-durchsatz-orientierte** Betriebspunkt.
- **NUMA-Default = Read-Pinning (Lokalität/Latenz), NICHT Interleaving:** Die OS-Primitiven listen
  „**NUMA-konformes Read-Pinning**" (`04_implementierung.tex:33`; ebenso `04_concept_architecture.tex:218`:
  „NUMA-konformes Read-Pin"). Das ist die code-nahe Aussage, dass der Thesis-Default für die NUMA-Ebene der
  **latenz-/lokalitäts-optimierende** Endpunkt (first-touch) ist.
- **Parameter-Art:** Layout-Wahl ist **compile-time** (honest-0 auf RC); die dokumentierte IMC-NUMA-Runtime-
  Heuristik (Channel-Interleave, `ce docs/architecture/16_axis_05_imc_runtime_heuristik.md`) ist **doku-only,
  nicht gebaut** (M0 §T5(3)/§3.2). Die Objective steuert hier die **Binary-Auswahl** (welche
  RepresentationKind gewinnt); die NUMA-Interleave-Objective wäre ein **künftiger** Laufzeit-Knopf.
- **Hypothese H1** (`06_evaluation_methodology.tex:53-55`): dichte Page-Typen gewinnen unter Zipf (YCSB-A),
  bereichsoptimierte unter Range-Scan (YCSB-E) — genau die last-abhängige Layout-Pareto-Verschiebung.

### 3.3 Literatur `[LIT]`
- **Rao, Ross, *Making B⁺-Trees Cache Conscious in Main Memory (CSB⁺)*, SIGMOD 2000** & *CSS-Tree*, VLDB
  1999 — CSB⁺ speichert Kinder kontiguierlich, hält nur den ersten Kind-Pointer → **hohe Cache-Line-
  Auslastung**; explizit als **Trade-off gegen Update-Kosten** formuliert („cache conscious *without
  increasing update cost too much*"). Der kanonische Beleg für CLU ⟂ Update.
- **Zhang et al., *SuRF/FST*, SIGMOD 2018** (LOUDS-DS, ~10 bit/Knoten) & **Jacobson, *LOUDS*, FOCS 1989** —
  der **Speicher-minimierende** Endpunkt (succinct) gegen Zugriffsgeschwindigkeit.
- **NUMA (first-touch vs. interleave):** **Gaud, Lepers, Funston, Dashti, Fedorova et al., *Challenges of
  Memory Management on Modern NUMA Systems*, Communications of the ACM 58(12)/ACM Queue 2015** (peer-
  reviewed) — belegt: **kein Policy ist universell best**; first-touch minimiert *Lokalität/Latenz*, kann
  aber **Kanal-Kongestion** erzeugen; **Interleaving** balanciert Bandbreite und kann trotz schlechterer
  Lokalität schneller sein („better locality does not necessarily improve performance"). Exakter Beleg für
  die NUMA-Sub-Pareto Latenz ⟂ Bandbreite.
- Ungethüm et al., *Hardware-Conscious DB Survey*, 2017 (Thesis-Ref P31, `03:155` zitiert für NUMA-Affinität).

### 3.4 Empfohlene Default-Objectives `[EMPF]`
- **Layout-Ebene: `CacheLineUtilizationOptimizing`** (≈ `ScanOptimizing` im Selektor) als Default —
  deckt sich mit Thesis-Default `Cache-Line-aligned` `[THESIS]` und dem CLU-Kernziel der Arbeit
  („cache-bewusstes Verhalten", M0 §0/§T5). Weitere Pareto-Objectives: **`FootprintOptimizing`** (LOUDS,
  speicherbeschränkt/static-read-only) und **`PointLatencyOptimizing`** (AoS-aligned, Point-Lookup-lastig).
- **NUMA-Sub-Ebene: `LocalityLatencyOptimizing` (Read-Pinning / first-touch)** als Default — deckt sich mit
  Thesis-„NUMA-konformes Read-Pinning" `[THESIS]`; peer-reviewed als Latenz-Endpunkt belegt `[LIT]`. Zweiter
  Endpunkt: **`BandwidthOptimizing` (Interleaving)** für scan-/bandbreiten-gebundene Lasten auf
  Multi-Socket. **Wichtige Ehrlichkeits-Marke:** Diese NUMA-Objective ist **heute honest-0** (doku-only,
  ungebaut) — sie ist eine **Roadmap-Objective**, kein aktuell messbarer Knopf.

---

## 4. Konsequenz für die E4′-Endauswertung (auf `cacheline_policy_selector` aufbauend)

### 4.1 Das Muster ist schon da — es fehlt die Objective-Familie und die per-Objective-Ausgabe
Der Selektor ist bereits ein **GoF-Strategy über `PolicyObjective`** (`cacheline_policy_selector.hpp:136-201`),
mit `ScanOptimizing`/`LatencyOptimizing` und dem im Header vorgesehenen, aber ungebauten
`durchsatz-optimierend` (`:29-30`). Die Endauswertung muss **nicht neu erfunden**, sondern **erweitert**
werden:

1. **Objective als expliziter Parameter der Auswertung** `[EMPF, gestützt auf 06:161-164 THESIS]`.
   Die ML-/Rangbildungs-Auswertung (`06_evaluation_methodology.tex:151-180`,
   `04_concept_architecture.tex:364-375`) wählt die Zielgröße bereits variabel („Durchsatz **oder**
   Tail-Latenz"). E4′ soll diese Objective **je Achse** als Strategy-Typ führen, statt eine einzelne
   Extremal-Größe zu behaupten:
   - T6: `ThroughputOptimizing` (Default) · `FootprintOptimizing` · `TailLatencyOptimizing`.
   - T18: `WriteAmplificationOptimizing` (Default, lazy) · `StalenessOptimizing` (eager) · `AdaptiveObjective`.
   - T5: Layout `CacheLineUtilizationOptimizing` (Default) · `FootprintOptimizing` · `PointLatencyOptimizing`;
     NUMA `LocalityLatencyOptimizing` (Default, honest-0/Roadmap) · `BandwidthOptimizing`.

2. **Getrennte Kurven-Scharen je Objective, nicht eine gemittelte Kurve** `[EMPF]`. Für die **RC-Achse T6**
   ist das eine **RC-Feld-Kurve** (`pool_budget_bytes` je Objective anders parametrisiert: throughput →
   linear-großzügig wie heute `:166-167`; footprint → eng geklammert). Für die **compile-time-Achsen T18/T5**
   ist es eine **Binary-Auswahl-Kurve** (welche FS-/RepresentationKind-Permutation je Lastprofil gewinnt) —
   die vorgesehene ML-Klassifikation nach Persist (`06:158-172`), aber **je Objective getrennt** trainiert/
   ausgewertet.

3. **Pareto-Front-Ausgabe statt Einzelsieger** `[EMPF]`. Weil T6/T18/T5 keinen dominierenden Punkt haben,
   soll die Endauswertung je (Last × Füllstand × Beschaffenheit) die **Menge der nicht-dominierten
   Konfigurationen** (Pareto-Front im Latenz/Durchsatz/Speicher-Dreieck aus `02:594-621`) ausgeben, und die
   Default-Objective markiert nur, **welcher Front-Punkt** ohne weitere Nutzervorgabe ausgeliefert wird. Das
   ist die ehrliche Form der „Heuristik-Kurve" für multi-objektive Achsen und vermeidet die vom M0-Befund
   (§4) gewarnte „falsche Einzel-Extremal-Behauptung".

### 4.2 Minimal-invasiver Umsetzungsvorschlag `[EMPF]`
- **Neue Objective-Strategy-Typen** analog `ScanOptimizing`/`LatencyOptimizing` (`:141-193`) für die
  T6-RC-Kurve: `ThroughputOptimizing` (Default) und `FootprintOptimizing` — beide liefern nur `desired`,
  die Cap-Klammerung (`apply_to`/`clamp`, `:221-226`) bleibt invariant. `durchsatz-optimierend` ist im
  Header schon annonciert (`:29-30`), also erwartungskonform.
- **Objective-Tag am Auswertungs-Output**: jede persistierte Bestkonfig (das „XML-Lastprofil",
  `06:174-178`) trägt die **Objective**, unter der sie gewonnen hat → nachvollziehbar, welcher Pareto-Punkt
  gemeint ist. Symmetrisch zum bestehenden `<expected_workload>`-Filter (`06:145`).
- **Für die compile-time-Achsen (T18/T5)**: die Objective ist Eingang der ML-Klassifikation (Zielgröße =
  objective-spezifisch: write-amp/staleness bei T18, CLU/footprint/point-lat bei T5), Ausgang sind
  **getrennte Empfehlungstabellen je Objective** — nicht ein globales „bestes Layout/Flush".
- **Honest-0 respektieren** (Direktive `feedback_compile_time_only_no_runtime`): die T5-NUMA-Interleave-
  Objective und die T18-Threshold-Objective bleiben **Auswertungs-/Binary-Auswahl-Objectives**, solange
  kein RC-Setter existiert — kein erfundener Laufzeit-Wert.

---

## 5. Ehrlichkeits-Bilanz (was ist womit belegt)

| Aussage | Status | Beleg |
|---|---|---|
| Messen ist ein 3-Komponenten-Trade-off (Latenz/Durchsatz/Speicher), jede Permutation = Punkt im Dreieck | `[THESIS]` | `02_suchbaeume_grundlagen.tex:594-622` |
| Zielgröße der Auswertung ist wählbar („Durchsatz **oder** Tail-Latenz") | `[THESIS]` | `06_evaluation_methodology.tex:161-164` |
| GoF-Strategy `PolicyObjective` existiert; `durchsatz-optimierend` vorgesehen aber ungebaut | `[THESIS]` | `cacheline_policy_selector.hpp:29-30,136-201` |
| T6: Allokator-Wahl je Last (mimalloc→A, jemalloc→B, tcmalloc→C) | `[THESIS]` | `03_messsystem_prtart.tex:172-186` |
| T18-Default = Lazy; T5-Default = Cache-Line-aligned; T5-NUMA-Default = Read-Pinning | `[THESIS]` | `04_implementierung.tex:187,174,33` |
| „Wer zwei von R/U/M optimiert, verschlechtert das dritte" (keine Einzelgröße) | `[LIT]` | RUM-Konjektur, EDBT 2016 |
| Lazy Leveling = write-optimierter Pareto-Punkt bei ~gleicher Lookup-/Space-Kost | `[LIT]` | Dostoevsky, SIGMOD 2018 |
| LSM-Design ist navigierbar (Update⟂Lookup⟂Memory holistisch co-tuned) | `[LIT]` | Monkey, SIGMOD 2017 |
| Allokator: Skalierung ⟂ Fragmentierung ⟂ Tail (eager purge = RSS↓/Fault-Risiko) | `[LIT]` | mimalloc APLAS 2019; Hoard ASPLOS 2000 |
| CSB⁺: hohe CLU ⟂ Update-Kosten; LOUDS = Space-Endpunkt | `[LIT]` | Rao/Ross SIGMOD 2000; SuRF SIGMOD 2018 |
| NUMA: first-touch (Latenz) ⟂ Interleave (Bandbreite/Kongestion), kein universeller Sieger | `[LIT]` | Gaud et al., CACM/ACM Queue 2015 |
| Konkrete Default-Objective je Achse (Throughput/WriteAmp/CLU+Locality) | `[EMPF]` | Schlussfolgerung aus THESIS-Defaults + LIT |
| E4′ = Objective-Parameter + getrennte Kurvenscharen + Pareto-Front-Ausgabe | `[EMPF]` | Bau-Vorschlag auf Selektor + 06:151-180 |
| T5-NUMA-Interleave-Objective ist heute honest-0 (doku-only, ungebaut) | `[THESIS]` | M0 §T5(3); `ce .../16_axis_05_imc_runtime_heuristik.md` (doku-only) |

---

## Quellen (Web, abgerufen 2026-07-09)

- Athanassoulis, Kester, Maas, Stoica, Idreos, Ailamaki, Callaghan, *Designing Access Methods: The RUM
  Conjecture*, EDBT 2016 — <https://stratos.seas.harvard.edu/publications/designing-access-methods-rum-conjecture>
  · PDF <https://users.cs.utah.edu/~pandey/courses/cs6530/fall22/papers/indexdesign/rum.pdf>
- Dayan, Athanassoulis, Idreos, *Monkey: Optimal Navigable Key-Value Store*, SIGMOD 2017 —
  <https://nivdayan.github.io/monkeykeyvaluestore.pdf> · <http://daslab.seas.harvard.edu/monkey/>
- Dayan, Idreos, *Dostoevsky: Better Space-Time Trade-Offs for LSM-Tree Based Key-Value Stores*, SIGMOD 2018 —
  <https://nivdayan.github.io/dostoevsky.pdf>
- Leijen, Zorn, de Moura, *Mimalloc: Free List Sharding in Action*, APLAS 2019 (MSR-TR-2019-18) —
  <https://www.microsoft.com/en-us/research/uploads/prod/2019/06/mimalloc-tr-v1.pdf>
- Berger, McKinley, Blumofe, Wilson, *Hoard: A Scalable Memory Allocator for Multithreaded Applications*,
  ASPLOS 2000.
- Rao, Ross, *Making B⁺-Trees Cache Conscious in Main Memory (CSB⁺)*, SIGMOD 2000 —
  <https://cadmo.ethz.ch/education/lectures/FS17/SDBS/RaoRoss-sigmod00.pdf>
- Zhang et al., *SuRF: Practical Range Query Filtering with Fast Succinct Tries*, SIGMOD 2018 —
  <https://www.pdl.cmu.edu/PDL-FTP/Storage/surf_sigmod18.pdf>
- Gaud, Lepers, Funston, Dashti, Fedorova et al., *Challenges of Memory Management on Modern NUMA Systems*,
  Communications of the ACM / ACM Queue 2015 — <https://queue.acm.org/detail.cfm?id=2852078>
- O'Neil, Cheng, Gawlick, O'Neil, *The Log-Structured Merge-Tree (LSM-Tree)*, Acta Informatica 1996.

*Erstellt 2026-07-09. Nur additiv unter `docs/sessions/backups/20260709-pareto-objectives-t6-t18-t5/`,
nicht committet (per Auftrag). Alle datei:zeile-Belege gegen den lokalen Klon-Stand verifiziert; Web-Belege
peer-reviewed bevorzugt und am Abrufdatum geprüft.*
