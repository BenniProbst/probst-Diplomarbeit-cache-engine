# Anleitung: Messwerte für die Diplomarbeit erzeugen (Sicht „Mess-Anhang erstellen")

**Zweck:** Schritt-für-Schritt, wie aus der `comdare-cache-engine` **echte Messwerte** für den Diplomarbeit-Mess-Anhang
entstehen — von der Kommandozeile, selbst ausführbar. Diese Anleitung ist die Thesis-seitige Klammer um die technische
Kurzanleitung im Repo: `Code/external/comdare-cache-engine/README.md` → Abschnitt „Messwerte erzeugen (Kommandozeile)".

---

## 1. Das Modell in einem Absatz

Die Diplomarbeit zerlegt jeden Suchalgorithmus in **Achsen = Organe** (Doku 14). Ein **„Tier"** ist EIN kompiliertes
Binary = eine Komposition fester Achsen-Wahl (17 SearchAlgorithm-Anatomie-Achsen + 3 Build-Achsen). Gemessen wird je
Tier über die echte DLL-Grenze: `n` Inserts + `n` Lookups → ein Observer-Snapshot (`result_ingest`-Zeile). Der
**Mess-Anhang** entsteht, indem man systematisch Tiere variiert (eine Achse ändern, alle anderen fixieren = isolierter
Achsen-Vergleich, F15) und ihre Snapshots gegenüberstellt.

> **Kanonische Bestandteile (Literatur-validiert, s. `Code/external/comdare-cache-engine/docs/architecture/30_audit_achsen_delegation_pflichtachsen.md`):**
> Jeder Suchalgorithmus hat einen nicht-degenerierbaren Pflicht-Kern — **Such-Strategie · Schlüssel→Position-Mapping ·
> Knoten-/Speicher-Organisation · Wert-Handling** (Knuth TAOCP Vol. 3; GiST, Hellerstein et al. VLDB 1995; ART, Leis
> et al. ICDE 2013; Graefe 2011). Die übrigen Achsen (Layout/Allokator/Prefetch/Concurrency/Serialisierung/IO/SIMD/
> Telemetrie/Filter/Migration) sind Pflicht-Dimensionen mit erlaubtem Trivial-Default — aber **kein Organ darf sie
> per Eigenspeicher umgehen** (s. §5 Architektur-Stand).

---

## 2. Voraussetzung (einmalig)

Im cache-engine-Repo (`Code/external/comdare-cache-engine`):
```powershell
cmake --preset msvc-release
cmake --build build/msvc-release --target perm_runner --config Release
```
Damit existieren `build/msvc-release/generated/` (Achsen-Flags) und `perm_runner.exe` (der Mess-Treiber je Tier).

---

## 3. Messwerte erzeugen

```powershell
# A) Mehrere Tiere bauen + messen → CSV
pwsh tests/unit/thesis_tiere/build_and_measure_thesis_tiere.ps1
#    Ergebnis: build/thesis_tiere/thesis_measurements.csv

# B) Ein einzelnes Tier messen
build/msvc-release/apps/perm_runner/Release/perm_runner.exe build/thesis_tiere/thesis_sa_btree.dll thesis_sa_btree 2000
```
Die 13 Observer-Felder je Zeile (`result_ingest.hpp`):
`search_lookup; hit; miss; insert; erase; peak_occupancy | bytes_alloc; bytes_in_use; alloc_cnt; dealloc_cnt; fail | observable_axes; tier_fill_level`.

**Wiederholungen (KF-10):** Default 3, **separat** auswerten (nie interpolieren). Die 13 Felder sind STRUKTUR-Zähler
(deterministisch) → bei identischer Komposition + `n_ops` identisch; Streuung betrifft nur Wall-Clock (→ §6 Cluster/PMC).

---

## 4. Vom CSV zum Mess-Anhang

1. **Achse isolieren:** alle Tiere eines Vergleichs unterscheiden sich in GENAU einer Achse (z.B. `thesis_sa_*` variieren
   nur axis_03a). Der gemessene Unterschied ist dieser Achse zurechenbar.
2. **Tabelle bilden:** Organ × `n_ops` × {gemessene Felder}. Vorlage:
   `Code/external/comdare-cache-engine/docs/sessions/20260603-l-meas-thesis-searchalgo-tiere.md`.
3. **Ehrlichkeit:** Keine Zeit-/Durchsatz-Spalte aus diesen Läufen (die Felder sind keine Zeitmessung — s. §6).
   Befunde nur so weit interpretieren, wie die Architektur es trägt (s. §5).

---

## 5. Architektur-Stand (WICHTIG vor Verwendung als Kernmesswert)

**Stand 2026-06-03 (Audit Doc 30):** Die aktuellen `axis_03a`-Such-Organe (Array256, BST, …) sind noch **Monolithen mit
Eigenspeicher** und delegieren NICHT an die Speicher-Achsen (node_type/layout/allocator). Folge: Variation von axis_04/05
ist derzeit wirkungslos; die Tiere durchlaufen NICHT uniform alle Organ-Interfaces. Ein darauf gestützter Befund misst
die *interne Struktur des Monolithen*, nicht ein zerlegtes Achsen-System.

**Korrekter, delegierender Aufbau ist belegt + ausführbar** (vertikaler Beweis-Schnitt):
```powershell
pwsh tests/unit/thesis_tiere/build_node_delegation_proof.ps1
# zeigt: gleiche Semantik (slot_count/hits identisch), aber chunk_count = ceil(n/node_capacity) je Node verschieden
#        -> node_type ist in einem DELEGIERENDEN Such-Organ runtime-wirksam
```
**Vor der Verwendung als Diplomarbeit-Kernmesswert** ist der Fix-Plan (Doc 30 §4) umzusetzen: alle Such-Organe als
delegierende Traversal-Organe + Adapter auf EINEN Store + bounded Node-Store + V2-Mess-POD. Zielbild (User-Entscheidung):
jedes Tier nutzt uniform alle Achsen (inkl. queuing → 22 pro Tier).

---

## 6. Grenzen + Cluster (GATE-MAXIMAL)

- **Lokal nicht messbar:** Per-Achsen-Timing/Hardware-Counter (PMC). Braucht privilegierten CPU-Counter-Zugriff → ZIH.
- **Cluster-Skalierung:** dieselben Tiere bauen+messen auf ZIH (Apptainer + SLURM-Array + `perm_runner` + Webhook →
  `result_ingest`). Das Zeilenformat ist MSVC↔gcc identisch → lokale + Cluster-Zahlen fließen in DENSELBEN Mess-Anhang.
  Die ZIH-Ausführung ist **absprachepflichtig** (Nutzungsbedingungen) und an den Infrastruktur-Agenten delegiert
  (Wunsch-Katalog „CE-D1…D5" in der Cluster-K78).
