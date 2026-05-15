# P08 — ART of Practical Synchronization (OLC + ROWEX)

**Voller Titel:** The ART of Practical Synchronization
**Autoren:** Viktor Leis, Florian Scheibner, Alfons Kemper, Thomas Neumann (TUM)
**Venue:** DaMoN 2016
**Volltext:** `_text/P08-ARTSync-Leis2016.txt` (8 Seiten, 41 KB)

## 1. Konzeptionelle Identitaet

Praesentiert **zwei Synchronisationsprotokolle** fuer ART (und allgemein):
1. **Optimistic Lock Coupling (OLC)** — einfach, restartfaehig
2. **Read-Optimized Write EXclusion (ROWEX)** — komplexer, Reads blockieren NIE und restarten NIE

> "Optimistic Lock Coupling and ROWEX are much easier to use than lock-free synchronization but offer similar scalability without special hardware support." (P08:S.1/41-43)

**Klasse:** Synchronisations-Pattern (kein neuer Algorithmus selbst)
**Sweet Spot:** Zwischen "fine-grained locking" (skaliert nicht) und "lock-free" (zu komplex)

## 2. Optimistic Lock Coupling (OLC)

### 2.1 Konzept (P08:Sec.3)

> "Optimistic Lock Coupling is similar to 'normal' lock coupling, but offers dramatically better scalability. Instead of preventing concurrent modifications of nodes (as locks do), the basic idea is to optimistically assume that there will be no concurrent modification. Modifications are detected after the fact using version counters, and the operation is restarted if necessary." (P08:S.2/177-184)

### 2.2 Optimistic Lock Layout (P08:S.2/Appendix A)

64-bit Version Field pro Node:
- Bit 0: **obsolete-Flag**
- Bit 1: **locked-Flag**
- Bit 2-63: **Update-Counter**

```c
uint64_t readLockOrRestart(Node node):
  version = awaitNodeUnlocked(node)  // spinlock fuer locked-Bit
  if isObsolete(version): restart()
  return version

void readUnlockOrRestart(Node node, uint64_t version):
  if version != node.version.load(): restart()

void writeLockOrRestart(Node node):
  do
    version = readLockOrRestart(node)
  while !upgradeToWriteLockOrRestart(node, version)
  // CAS auf locked-Bit

void writeUnlock(Node node):
  node.version.fetch_add(2)  // reset locked, overflow into version
```

### 2.3 OLC-Bedingungen (P08:Sec.3.2)

- **Keine infinite loops** (in ART nicht moeglich)
- **Keine invalid pointers** dereferenzieren — extra checkOrRestart nach jedem Pointer-Read

## 3. ROWEX (Read-Optimized Write EXclusion)

### 3.1 Konzept (P08:Sec.4)

> "Reads are non-blocking and always succeed. [...] Writers must ensure that reads are always consistent by using atomic operations." (P08:S.3/331-345)

### 3.2 ROWEX fuer ART (P08:Sec.4.2)

**Aenderungen am Datenstruktur-Code (NICHT nur Locks):**
1. Alle Felder, die concurrent gelesen werden = `std::atomic<T>`
2. Node4/Node16 (linear nodes): **Keys NICHT mehr sortiert** — append at end
3. Node48/Node256: keine zusaetzlichen Aenderungen
4. **level-Feld** pro Node (haelt Hoehe inkl. Prefix) — fuer atomar-konsistente Path Compression

### 3.3 Node Replacement (P08:S.4/Sec.4.2 Liste)

1. Node + Parent locken
2. Neuen Node erzeugen + Eintraege kopieren
3. Parent-Pointer atomar austauschen
4. Alten Node als obsolete markieren + unlocken

### 3.4 Path Compression (P08:Fig.4/S.4)

Atomares Layout:
- prefix + length zusammen in einem 8-byte Wort (atomar updatebar)
- level-Feld erlaubt Reader, intermediate States zu erkennen

> "On x86, 16 byte values can also be accessed atomically, which would also allow storing 12 byte prefixes." (P08:S.4/Footnote 3)

## 4. Performance (P08:Fig.5/S.5)

### Single-Thread-Overhead

| Variant | Cycles/Lookup | Instructions/Lookup |
|---|---|---|
| no sync | 211 | 123 |
| lock coupling | 418 | 242 |
| **OLC** | 348 | **187** |
| **ROWEX** | 375 | 248 |
| HTM | 347 | 132 |

### 20-Threads-Skalierung
- **lock coupling**: kollabiert (2787 cycles, 6.6× Slowdown!)
- **OLC**: 418 cycles (10% Overhead)
- **ROWEX**: 427 cycles (10% Overhead)
- **Masstree** (zum Vergleich): 1231 cycles, 4.8× mehr Instructions als ART OLC!

## 5. Code-Komplexitaet (P08:Sec.5.4)

| Variant | lookup LOC | insert LOC | remove LOC |
|---|---|---|---|
| no synchronization | 29 | 95 | 87 |
| HTM | 30 | 96 | 88 |
| lock coupling | 41 | 136 | 139 |
| **OLC** | 44 | 148 | 143 |
| **ROWEX** | 34 | 200 | 156 |

→ OLC ~50% mehr LOC als no-sync; ROWEX **doppelt so viel insert-LOC**.

## 6. PRT-ART-Bezug (HIGHLY IMPORTANT)

| OLC/ROWEX-Konzept | PRT-ART-Bezug |
|---|---|
| **OLC** | **DIREKTE Wahl** fuer PRT-ART (einfach, scalability) |
| **ROWEX** | Alternative falls Reader nie restartfaehig sein duerfen |
| **64-bit Version Field** | DIREKT uebernehmbar in PRT-ART Page-Header |
| **obsolete-Flag** | DIREKT uebernehmbar (fuer Online-Relocation in Cache-Engine!) |
| **Epoch-based Memory Reclamation** | wie HOT/Masstree (vgl. P29 RCU) |
| **CAS auf locked-Bit** | Standard-Pattern, direkt uebernahmebar |

**Wichtiger Punkt fuer Cache-Engine:**
ROWEX braucht **atomare Pointer + level-Feld** — das ist genau die Mechanik, die die PRT-ART **Cache-Engine fuer Online-Relocation** braucht. Ohne diese kann Online-Reorganisation nicht safe gemacht werden.

## 7. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **OLC ↔ HOT ROWEX (P02 Sec.5) ↔ Masstree OCC (P03 Sec.4.6)**: drei verwandte Versionsbasierte Sync-Strategien
- **OLC obsolete-Flag ↔ HOT obsolete marker ↔ B²-Tree validation check (P06 Sec.3.6)**: drei Sicherheitsprinzipien fuer Concurrent Read+Write
- **ROWEX atomic fields ↔ Masstree permutation field (P03)**: atomar-aktualisierbare Layouts
- **OLC + Epoch reclamation ↔ RCU (P29) ↔ Hazard Pointers (P30)**: Memory-Reclamation-Familie

## 8. Kernanschluss fuer PRT-ART

OLC ist die **erste Wahl fuer PRT-ART Concurrency**:
- Einfach zu implementieren
- Versionsbasiertes Erkennen von Online-Relocation der Cache-Engine
- Reader sehen immer konsistente Snapshots oder restarten

ROWEX ist die **bessere Wahl, wenn die Cache-Engine Online-Relocation macht**, weil dann viele Reader gleichzeitig aktiv sind und Restarts teuer sind. Die obsolete-Marker-Mechanik (P08:S.4/396-401) ist genau das, was PRT-ART braucht, um die alten Pages nach Reorganisation zu invalidieren.

**Empfehlung fuer PRT-ART (basierend auf P08):** OLC als Default, ROWEX als optionaler "concurrent-relocation"-Modus der Cache-Engine.
