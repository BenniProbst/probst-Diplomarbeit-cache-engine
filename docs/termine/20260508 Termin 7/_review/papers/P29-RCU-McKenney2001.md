# P29 — Read-Copy Update (McKenney et al. OLS 2001)

**Voller Titel:** Read-Copy Update
**Autoren:** Paul E. McKenney, Jonathan Appavoo, Andi Kleen, Orran Krieger, Rusty Russell, Dipankar Sarma, Maneesh Soni (IBM Linux Technology Center + U Toronto + SuSE Labs + IBM Watson + RustCorp)
**Venue:** Ottawa Linux Symposium 2001
**Volltext:** `_text/P29-RCU-McKenney2001.txt` (22 Seiten, 71 KB)

## 1. Konzeptionelle Identitaet

**Read-Copy Update (RCU)** ist eine Synchronisations-Mechanik, die Updates in 2 Phasen splittet:
1. **Update durchfuehren** — neue Operationen sehen neuen State, alte Operationen bleiben auf altem State
2. **Update completen** — erst nach Ende aller alten Operationen ("Grace Period")

> "[Splitting updates into two phases:] 1) carrying out enough of each update for new operations to see the new state, while still allowing existing operations to proceed on the old state, then: 2) completing the update after all active operations have completed." (P29:S.1/40-46)

**Klasse:** Lock-free Synchronization fuer read-mostly Daten
**Ziel:** Reduktion von Lock-Overhead in Kernel/Hot Code Paths

## 2. Hauptkonzepte

### 2.1 Grace Period
> "Grace period extends until after the end of all operations that started before the beginning of the grace period. Therefore, any operation that sees the module still loaded is guaranteed to be able to use it." (P29:S.2/168-172)

### 2.2 Quiescent State
> "When every CPU (or task, in preemptive environments) has passed through a 'quiescent state', the grace period may end. A 'quiescent state' is a point in the code at which it is guaranteed that all previous operations have completed." (P29:S.2/176-181)

Beispiele in Linux Kernel:
- Context Switch (non-preemptive)
- Idle Loop
- User Mode Execution

### 2.3 Schluessel-Idee
> "Common-case code can then proceed without disabling interrupts or acquiring any locks to protect against the update code, which simplifies locking protocols, improves uniprocessor performance, and increases scalability." (P29:S.1/45-49)

## 3. Anwendungen (P29:Sec.1)

- Read-mostly Datenstrukturen (Routing Tables)
- Existence Locks vermeiden (Module Loading/Unloading)
- Linked-List-Updates
- Hash-Table-Resize

## 4. PRT-ART-Bezug

| RCU-Konzept | PRT-ART-Bezug |
|---|---|
| **Grace Period Mechanik** | **DIREKT als PRT-ART Memory-Reclamation** nach Cache-Engine Online-Relocation |
| **Reader keine Locks** | **DIREKT** wie Masstree (P03), HOT (P02), ART OLC (P08) |
| **Update in 2 Phasen** | direkt nutzbar fuer PRT-ART Page-Reorganisation |
| **Quiescent State Detection** | Standard-Mechanik (in Linux Kernel implementiert) |
| **Lock-free common case** | Skalierbarkeit fuer PRT-ART Multi-Reader |

## 5. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **RCU Grace Period ↔ Hazard Pointers (P30)**: zwei Memory-Reclamation-Strategien
- **RCU ↔ Masstree OCC (P03) ↔ ART OLC (P08) ↔ HOT ROWEX (P02)**: vier verwandte Lock-free/Optimistic-Sync-Techniken
- **RCU "Update in 2 Phasen" ↔ HOT 5-Schritt-Sync-Protocol (P02)**: gleiche Philosophie

## 6. Kernanschluss fuer PRT-ART

RCU ist die **klassische Memory-Reclamation-Mechanik** fuer Lock-free Datenstrukturen. PRT-ART Cache-Engine **muss** RCU (oder Hazard Pointers, P30) nutzen, wenn:
1. **Online-Relocation** alte Pages obsolete macht
2. Concurrent **Reader** weiter auf alten Pages aktiv sind
3. Memory **erst freigegeben** werden darf, nachdem **alle Reader fertig**

PRT-ART **uebernimmt RCU direkt** als Default-Memory-Reclamation:
- Cache-Engine markiert alte Page nach Relocation als obsolete
- Wartet auf Grace Period (alle Reader fertig)
- Gibt Memory frei

Das ist konsistent mit:
- HOT (P02 Sec.5): "Epoch-based memory reclamation"
- ART of Practical Sync (P08): obsolete Marker + Epoch-based Reclamation
- Masstree (P03 Sec.4.6.1): "RCU-like garbage collection"

→ Termin 4 Designmuster: "Memory Reclamation: RCU + Hazard Pointers" als Concurrency-Bausteine.
