# P30 — Hazard Pointers (Michael 2004)

**Voller Titel:** Hazard Pointers: Safe Memory Reclamation for Lock-Free Objects
**Autor:** Maged M. Michael (IBM T.J. Watson Research Center)
**Venue:** IEEE TPDS 15(6), Juni 2004
**Volltext:** `_text/P30-HazardPointers-Michael2004.txt` (14 Seiten, 73 KB)

## 1. Konzeptionelle Identitaet

**Hazard Pointers** = Memory-Reclamation-Methodik fuer Lock-free dynamische Objekte. **Wait-free**, nutzt nur **single-word reads/writes**, kein Kernel-Support noetig.

> "Hazard pointers, a memory management methodology that allows memory reclamation for arbitrary reuse. It is very efficient [...] suitable for user-level applications [...] without dependence on special kernel or scheduler support. It is wait-free." (P30:S.1/12-15)

**Klasse:** Lock-free Memory-Reclamation-Mechanik (Alternative zu RCU)
**Hauptbeitrag:** Wait-free Garantie + keine Hardware-Sondersupport

## 2. Hauptkonzept

### 2.1 Hazard Pointer pro Thread

> "Associate a number (typically one or two) of single-writer multireader shared pointers, called hazard pointers, with each thread that intends to access lock-free dynamic objects." (P30:S.2/110-113)

| Eigenschaft | Beschreibung |
|---|---|
| Per Thread | 1-2 Hazard Pointers (pro Datenstruktur) |
| Schreiber | NUR der eigene Thread |
| Leser | Alle anderen Threads |
| Inhalt | NULL ODER Pointer zu einem Knoten, den der Thread "schuetzen" will |

### 2.2 Garantie
> "No thread can access a dynamic node at a time when it is possibly removed from the object, unless at least one of the thread's associated hazard pointers has been pointing to that node continuously, from a time when the node was guaranteed to be reachable from the object's roots." (P30:S.2/118-123)

### 2.3 Reclamation-Algorithmus
1. Thread retired einen Knoten: in private Liste
2. Nach R retired-nodes: scan alle Hazard Pointers anderer Threads
3. Knoten ohne match → safe to reclaim
4. Knoten mit match → behalten bis naechster Scan

**Zeitkomplexitaet:** O(R) expected pro Scan, R = H + Ω(H), H = total Hazard Pointers → **konstante Amortisation**.

## 3. Vorteile gegenueber Alternativen

| Methode | Nachteil |
|---|---|
| IBM Tag/Update Counter | Braucht double-width instructions (nicht auf 64-bit verfuegbar) |
| Lock-free Reference Counting | Ineffizient + braucht starke Multi-Address Atomics |
| Aggregate Reference Counters | Blocking — ein Thread-Failure verhindert Reuse |
| **Hazard Pointers** | **Wait-free + nur single-word Atomics** |

## 4. PRT-ART-Bezug

| Hazard-Pointers-Konzept | PRT-ART-Bezug |
|---|---|
| **Wait-free Memory Reclamation** | DIREKT als Alternative zu RCU (P29) fuer PRT-ART Cache-Engine |
| **Single-word Atomics** | wichtig: keine speziellen Hardware-Anforderungen |
| **Per-Thread Hazard Pointers** | konzeptionell: PRT-ART Reader haelt Hazard Pointers auf aktuell genutzte Pages |
| **Konstante Amortisation** | wichtig fuer PRT-ART Performance-Garantien |
| **User-Level (kein Kernel-Support)** | DIREKT: PRT-ART ist User-Level-Library |

## 5. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **Hazard Pointers ↔ RCU (P29)**: zwei Memory-Reclamation-Strategien
- **Hazard Pointers ↔ HOT Epoch-based (P02 Sec.5)**: drei Lock-free Reclamation-Patterns
- **Hazard Pointers Wait-free ↔ ART OLC Optimistic (P08)**: zwei Concurrency-Garantien (wait-free vs optimistic)

## 6. Kernanschluss fuer PRT-ART

Hazard Pointers ist die **alternative Mechanik** zu RCU (P29) fuer PRT-ART Memory-Reclamation:

| Aspekt | RCU | Hazard Pointers |
|---|---|---|
| Garantie | Best-effort (Grace Period) | **Wait-free** |
| Memory-Overhead | Niedrig (Grace-Period-Counter) | Pro Thread 1-2 Pointer |
| Performance-Penalty fuer Reader | Sehr niedrig | Mittel (Hazard Pointer setzen) |
| Geeignet fuer | Read-mostly, Kernel | User-Level, hohe Concurrency |

PRT-ART Cache-Engine kann **beide** als Wahl anbieten:
- **RCU** als Default (einfacher, niedriger Overhead)
- **Hazard Pointers** als Alternative bei kritischen Anforderungen (Wait-free)

Termin 4 Designmuster: "Hazard Pointers/Epoch Reclamation als Alternative/Ergaenzung [zu RCU]" — Michael 2004 ist die direkte Quelle.
