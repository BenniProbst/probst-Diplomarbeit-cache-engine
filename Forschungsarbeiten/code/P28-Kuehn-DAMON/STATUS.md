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

