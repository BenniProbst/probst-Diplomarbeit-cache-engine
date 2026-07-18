# DOSSIER #188-4c-iv — ContainerAlgorithm-Rename (E3-USER-Entscheid) + Include-Sweep

**Für: codex exec (workspace-write) im Repo `comdare-cache-engine` (HEAD `9268992`).**
**Increment-Tag:** `#188-4c-iv (2026-07-02)`. Finale der 4c-Strecke. USER-Entscheid E3 (2026-07-02,
Masterplan §5): Benennungs-Schema **`ContainerAlgorithm` analog `SearchAlgorithm`** — das Substrat ist der
Container-ALGORITHMUS-Anteil INNERHALB des Such-Algorithmus (deckt sich mit CMD-2: Container = erheblicher
Zugriffs-Anteil der SA). Die alte Namens-Kollision mit der Container-GATTUNG war die Verständnis-Falle (#224).

## 1. Auftrag — Rename-Sweep in `libs/cache_engine/anatomy/abi_adapter.hpp` (Kern; + kleine Folge-Stellen)
Konsistentes Schema (ALLE Vorkommen; grep-verifizieren):
- Member `container_` → `container_algorithm_` · `container_tier1_` → `container_algorithm_tier1_`
- Typen: `container_t` → `container_algorithm_t` · `flat_container_t` → `flat_container_algorithm_t` ·
  `container_traversal_t` → `container_algorithm_traversal_t`
- Prädikat `container_is_store_backed_` → `container_algorithm_is_store_backed_`
- Memento: `saved_container_`/`saved_container_m_`/`saved_container_stats_`/`saved_tier1_` →
  `saved_container_algorithm_*` bzw. `saved_container_algorithm_tier1_` (Konsistenz)
- `tier_search_routes_through_store()` bleibt (ABI-/Diagnose-Name, Tests asserten ihn — NICHT umbenennen).
- **PFLICHT-Kommentar am Member `container_algorithm_`** (E3-Wortlaut sinngemäß): „Der Container-ALGORITHMUS-
  Anteil innerhalb des Such-Algorithmus (Speicher-Substrat der T0-Suche). NICHT zu verwechseln mit der
  Container-GATTUNG (AnatomyGattung::Container mit den Tier-Unterklassen Set/Sequence/Adapter/View) — diese
  Verwechslung war die historische #224-Falle; CMD-2 (#252) schlüsselt den Container-Anteil messbar auf."
## 2. Reichweite prüfen (grep repo-weit, NUR echte Nutzer der Adapter-Symbole mitziehen):
- Externe Nutzer von `container_t`/`container_`-ADAPTER-Symbolen: vermutlich KEINE (private) — verifizieren.
  Lokale gleichnamige Variablen/Member ANDERER Klassen (z. B. `container_` in Hüllen/Organen/Set-Anatomie,
  `anatomy_execution_context.hpp`-Eigenpaar) NICHT anfassen — nur der SearchAlgorithmAbiAdapter renamed.
  ⚠️ `anatomy_execution_context.hpp:~115-120` (Builder-Pilot, EIGENES search_organ_/container_-Paar): NICHT
  umbenennen; stattdessen dort einen 2-Zeilen-Kommentar ergänzen „Builder-Pilot-Eigenpaar — bewusst NICHT im
  4c-iv-Rename; Konsolidierung mit CMD-1 (#251)".
- Tests, die Adapter-interne Namen via Kommentar erwähnen: Kommentare dürfen (nur wo berührt) präzisiert
  werden; KEINE Test-Logik ändern.
## 3. Include-/NIT-Sweep (Review b122dfqcm, im selben Zug):
- abi_adapter: prüfe ob `axis_04_node_type_composed_store.hpp`/`axis_04_node_type_chunked_store.hpp` (~:62)
  und `<algorithm>` (~:92) noch gebraucht werden (echte Symbol-Suche!) → ungenutzte entfernen; traversal_t-
  Kommentar ~:1695 auf die exakte 3-Wege-Wahrheit präzisieren.
## 4. TABU: modules/** · ext/** · golden · Registry-mp_list · tests/unit/CMakeLists.txt · .gitlab-ci.yml ·
KEINE Verhaltensänderung (reiner Rename + Kommentar + tote Includes). Kein git. Keine $null. EOF 1×LF.
## 5. Bericht: (a) Rename-Tabelle alt→neu mit Trefferzahlen; (b) externe-Nutzer-Befund; (c) Include-Sweep-
Ergebnis (welche entfernt, welche doch gebraucht + warum); (d) Bestätigung Verhaltens-Neutralität + Tabus.
