# P28-Kuehn-DAMON — Status

**Paper:** Towards Data-Based Cache Optimization (Kuehn 2023)
**Status:** INSTITUTION_INTERN
**Verzeichnis:** `Forschungsarbeiten/code/P28-Kuehn-DAMON/`

## Klon-/Implementierungs-Hinweis

- **Status:** Code existiert vermutlich, ist aber INSTITUTION-INTERN
- **Institution:** TU Dortmund DBIS (Teubner)
- **Original-Compiler:** GCC 9+
- **Strategie:** Email-Anfrage an Autoren

### Email-Anfrage-Strategie
1. Vorformulierte Email mit Diplomarbeit-Kontext erstellen
2. Habich (Hauptbetreuer) konsultieren
3. Email an Autoren senden
4. Bei positivem Feedback: Code in `Forschungsarbeiten/code/P28-Kuehn-DAMON/` ablegen
5. Lizenz-Klaerung VOR Integration in comdare-cache-engine

### Falls Code nicht erhaeltlich
Re-Implementation in `prt_art/legacy_reimpl/P28-Kuehn-DAMON/` (siehe LEGACY_REIMPL-
Strategie). Bei TUD-internen Quellen (P31/P32/P33): Direkter Habich-Kontakt
KRITISCH, da diese Forschung in DIREKTER Habich-Linie steht.

---

## L.1 Update 2026-05-18 (Kuehn-Antwort 2026-05-08)

**Email-Verlauf:** `../../E-Mail Kuehn – benjamin-elias.probst@mailbox.tu-dresden.de.pdf`

**Kuehn-Antwort 2026-05-08 10:35:47 (Roland Kuehn, TU Dortmund DBIS):**

> "Ich denke, dass wir euch den Code grundsaetzlich zukommen lassen koennen. Ich muss allerdings dazu sagen, dass es sich dabei eher um experimentellen Evaluationscode als um ein sauber gekapseltes Framework handelt. Ich muesste daher zumindest noch einmal den Code durchgehen und alles ein wenig aufraeumen und dokumentieren ;)"

**Code-Stand 2026-05-18:** noch nicht angekommen, aber zugesagt. User-Direktive 2026-05-18: keine weiteren Mails erwartet.

### L.1.b Update 2026-05-21 — CODE ANGEKOMMEN

**Roland Kuehn Mail 2026-05-21:** Repo unter
`https://git.cs.tu-dortmund.de/roland.kuehn/bplustree_reordering.git` freigegeben.

> "Ich habe den Code jetzt nur grob aufraeumen koennen, da ich momentan noch mit ein paar anderen Dingen beschaeftigt bin. Bevor du jetzt aber noch laenger warten musst, findest du das Repository hier: [URL]. Gib mir bitte kurz Bescheid, sobald du das Repository geklont hast, da ich es danach gerne wieder auf privat stellen wuerde."

**Klon erfolgreich 2026-05-21 22:11** in `bplustree_reordering/` (260 KB, 4 Commits, Branch: `Master`).

| Feld | Wert |
|---|---|
| Klon-Pfad | `Forschungsarbeiten/code/P28-Kuehn-DAMON/bplustree_reordering/` |
| HEAD | `deb6b32 Small fix` |
| Branch | `Master` |
| Letzter Commit | Small fix (deb6b32) -> Updated Readme (59fb031, 657c1ef) -> First commit (c44c76f) |
| Groesse | 260 KB |

**Inhalt (10 source-Files):**

```
CMakeLists.txt
README.md (10.5 KB, ausfuehrliche Doku)
include/
  benchmark_helper.hpp
  benchmark_setup.hpp
  btree_olc.hpp           (Hauptklasse: BTreeOLC mit Reordering)
  cmdparser.hpp           (3rd-party: Florian Rappl)
  index.hpp
  zipf_distribution.hpp   (3rd-party: Lucas Lersch)
scripts/
  plot_experiments.py
  run_experiments.sh
src/
  main.cpp
```

**Features laut README:**
- BTreeOLC (Optimistic Lock Coupling) basierend auf `wangziqi2016/index-microbench`
- Native B+ tree Layout
- Hot-path Relayouting
- Hot-path Relayouting mit Sort der restlichen Nodes by access frequency
- Global node sorting by access frequency (no hotpath extraction)
- Binary + linear search innerhalb Nodes
- Classic + Zipf workloads
- NUMA-aware thread placement
- Access-Validation + Access-Dump-Generation
- Unified CSV Output
- Multi-threaded Benchmarking

**Dependencies:** C++17, CMake>=3.14, pthreads, libnuma-dev, `perf-cpp` (fetched at configure-time), python3+matplotlib.

**Lizenz-Hinweis:** Repo enthaelt "adapted research code based on existing academic/open-source implementations" - Lizenz-Klaerung VOR Integration in comdare-cache-engine erforderlich (siehe README §3).

### USER-AKTION SOFORT

**Roland antworten:** "Repo geklont, du kannst es jetzt wieder auf privat stellen. Danke!"

### Folge-Tasks (V34+)

1. Lizenz-Klaerung pro 3rd-party Komponente (BTreeOLC + CmdParser + cpp_random_distributions)
2. Adapter-Skelett: `Code/external/comdare-cache-engine/adapters/P28-DaMoN-LeafCounter/` mit ext/-Verweis auf bplustree_reordering
3. Cache-Line-Ping-Pong Validierung gegen unser Achse 11 TELEMETRY-Modell
4. PRT-ART eigene Leaf-Only-Counter Implementation (Achse 11.X1) zum Vergleich

### Kuehn-Erkenntnisse zu Telemetry-Strategie (Achse 11 PRT-ART)

Kuehn hat im Mail-Verlauf 4 Varianten der Telemetry-Sammlung beschrieben:

| Strategie | Beschreibung | Status bei Kuehn |
|---|---|---|
| **Leaf-Only-Counter** | Counter NUR in Blatt-Knoten | **Hauptvariante 2024+** |
| **Sampling** | jeder n-te Zugriff im Blatt-Knoten | erweiterte Variante |
| **Offline-Recompute** | bottom-up Aufsummierung vor Reordering | Standard-Verfahren |
| **Inner-Node-Counter** | Counter in ALLEN Knoten (auch inneren) | **ANTI-PATTERN** (Ping-Pong) |

**Cache-Line-Ping-Pong-Problem (Kuehn verbatim):**

> "Insbesondere auf die Knoten in den oberen Ebenen des Baums wird sehr haeufig zugegriffen, sodass diese typischerweise im Caches mehrerer Kerne liegen. Zusaetzliche Schreibzugriffe fuehren dann durch die Cache-Kohaerenzmechanismen schnell zu starkem Cacheline-Ping-Pong zwischen den Kernen, was die Performance entsprechend beeintraechtigt."

Diese 4 Strategien sind in der konsolidierten Bausteine-Matrix als Achse 11 Sub-Strategien 11.X1-X4 verankert: `../../../docs/bausteine/07_bausteine_matrix_N_erweitert.md` §4.

### Plattform-Info vom User mitgeteilt (an Kuehn 2026-05-08)

- K8s Cluster auf Talos OS
- Ryzen 9 9950X3D + i9 14900KS
- 64GB RAM bei 5600 MIT DDR5, Latenz 36 Zyklen

### Pending Folge-Tasks

1. Wenn Code ankommt: hier in `Forschungsarbeiten/code/P28-Kuehn-DAMON/` ablegen
2. Adapter-Skelett anlegen: `Code/external/comdare-cache-engine/adapters/P28-DaMoN-LeafCounter/`
3. Re-Impl in `comdare-prt-art/legacy_reimpl/P28-Kuehn-DAMON/` (sobald Code da)
4. PRT-ART-eigene Variante der Leaf-Only-Counter-Telemetrie (Achse 11.X1)

