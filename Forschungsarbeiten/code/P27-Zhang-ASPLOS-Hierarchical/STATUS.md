# P27-Zhang-ASPLOS-Hierarchical — Status

**Paper:** T. Zhang et al. (2025). Hierarchical Prefetching. ASPLOS 2025
**Status:** PARTIAL CODE RECEIVED + LEGACY_REIMPL fuer Runtime
**Verzeichnis:** `Forschungsarbeiten/code/P27-Zhang-ASPLOS-Hierarchical/`

## Code-Eingang (2026-05-14, via E-Mail-Folge-up)

Nach P27 Bounce-Follow-up Mail an Youhui Zhang + Boris Grot wurde das
Paket `hp-soft.zip` (1981 Bytes) per Mail-Antwort uebermittelt. Inhalt
liegt jetzt unter `hp-soft/`:

- `hp_soft.py` (3751 Bytes): Build-Time Call-Graph-Analyse Python-Skript
- `readme.txt` (436 Bytes): Beschreibung von Input/Output/Threshold

**Sammelsurium-Charakter:** Mehr als dieses kleine Build-Time-Tool wird
es vom Autor nicht geben. Die eigentliche Runtime-Prefetching-Logik
muss aus dem Paper re-implementiert werden.

## Was hp_soft.py macht

Input:
- `program.dmp` (= `objdump -d <binary>` Output)
- `program.table` (= `objdump -t <binary>` Output)
- `threshold` (Default: 240'000 Bytes Subtree-Footprint)

Algorithmus:
1. Symboltabelle parsen (Adresse, Groesse, Funktionsname)
2. Call-Graph aus objdump-Disassembly extrahieren (callq-Instruktionen)
3. Pro Funktion: rekursive DFS-Berechnung der Subtree-Groesse
   (Anzahl Funktionen + Summe der Code-Footprints)
4. Filtern: Funktionen mit `subtree_footprint >= threshold`
5. Output: Liste der Funktionen, deren call/return Instruktionen
   als "potential entry points of Bundles" markiert werden

Das ist die Build-Time Vorverarbeitung, die offline laeuft (vor
dem eigentlichen Programmlauf). Die Bundles (= zusammen-gepre-
fetchte Code-Bloecke) werden bei Programmlauf vom Hardware-
Prefetcher (oder einer Software-Implementation) geladen, sobald
ein der markierten Entry-Points erreicht wird.

## Re-Implementation-Plan (Phase 4.B / Phase 5)

1. ✅ hp_soft.py einsortiert (Build-Time-Tool ist da)
2. **[TODO]** C++23-Port von hp_soft.py als `tools/p27_bundle_finder/`
   - C++23 Reader fuer objdump-Output
   - Identische DFS-Logik
   - CMake-Integration
3. **[TODO]** Runtime-Prefetching-Logik aus Paper re-implementieren in
   `prt_art/legacy_reimpl/P27-Zhang-ASPLOS-Hierarchical/`
4. **[TODO]** Adapter zu Bausteine-Concept-Interface in
   `cache-engine/adapters/P27-*/p27_*_adapter.hpp`

## Zitation + Provenance

- Paper-Zitation: T. Zhang et al. (2025). "Hierarchical Prefetching".
  ASPLOS 2025. — Pflicht in NOTICE + thesis
- Tool-Provenance: hp-soft.zip per E-Mail von Autoren erhalten
  2026-05-14 — Sammelsurium-Charakter, mehr ist nicht zu erwarten

## Lizenz

`hp-soft.zip` enthielt KEINE LICENSE-Datei. Per Architekt-Direktive
2026-05-08 + User-Direktive 2026-05-14: Wir untersuchen Software-
Bestandteile fuer Permutations-Achsen, daher entsteht ein neues Werk;
Adapter mit Original-Compiler. Bei Repos ohne Lizenz reicht
formal-rechtlich die korrekte Autoren-Zitation.

## Wichtig (Habich-Direktive)

Die C++23-Re-Implementation der Runtime-Logik (Schritt 3 oben) ist KEIN
"Originalcode" im Sinne der Habich-Direktive. Sie ist eine **PRT-ART-
eigene Implementation** des im Paper beschriebenen Algorithmus.
Im Bausteine-Module-Identifier wird sie als
`legacy_reimpl_p27-zhang-asplos-hierarchical` markiert.

Das Build-Time-Tool `hp_soft.py` (Schritt 2) ist hingegen eine
direkte Portierung — bleibt unter `tools/p27_bundle_finder/` mit
expliziter Zitation, unabhaengig vom Adapter-Mechanismus.

---

## L.3 Update 2026-05-18 (Verbindung zur N-Phase Achsen-Erweiterung)

**Kontext:** Mit der Bausteine-Matrix-Erweiterung auf 14 Achsen (N-Phase 2026-05-18, siehe `../../../docs/bausteine/07_bausteine_matrix_N_erweitert.md`) ergibt sich fuer P27 hp-soft eine spezifische Achsen-Zuordnung:

| Achse | P27 hp-soft Auspraegung | Sub-Strategie |
|---|---|---|
| 7 PREFETCH | Hierarchical-Bundle | 6 Bausteine-Familie (Hauptachse, V31.K6 implementiert in `comdare-prt-art/prt_art/include/prt_art/prefetch/`) |
| 12.1 SIMD-Family | scalar / AVX2-optional | (Bundle-Selektion ist scalar) |
| 12.2 Cache-Level-Targeting | **L1+L2+L3-aware** (hierarchical) | NEU klar via Achse 12 |
| 12.4 Prefetch-Hardware | PREFETCH + PREFETCHNTA | NEU klar via Achse 12 |
| 13.4 Co-Routine-Strategy | interleave (mit Hardware-Prefetch) | NEU klar via Achse 13 |

### Status der drei TODO-Schritte aus §"Re-Implementation-Plan"

1. ✅ hp_soft.py einsortiert — DONE (Forschungsarbeiten/code/P27-...-Hierarchical/hp-soft/)
2. ✅ C++23-Port von hp_soft.py — DONE (V31.K5, `comdare-prt-art/tools/p27_bundle_finder/`)
3. ✅ Runtime-Prefetching-Logik re-implementiert — DONE (V31.K6, `comdare-prt-art/prt_art/include/prt_art/prefetch/hierarchical_bundle_prefetcher.hpp`)
4. **[TODO]** Adapter-Code in `cache-engine/adapters/P27-hp-soft/p27_hp_soft_adapter.hpp` als Bausteine-Familie-Wrapper fuer Achse 7 PREFETCH (Re-Use durch andere Algorithmen ueber `if COMDARE_HAVE_P27_BUNDLE` Schalter).

### User-Memory-Direktive (Zhang)

User-Hinweis (verankert in `~/.claude/.../memory/reference_p27_zhang_no_more_input.md`): "Herr Zhang ist ein sehr stolzer und zynischer Mensch. Mehr als dieses Sammelsurium aus Hinweisen werden wir nicht bekommen." Damit ist P27 vollstaendig — keine weiteren Mails an Autoren.

Email-Verlauf 2026-05-08 bis 2026-05-13: `../../../E-Mail Zhang – benjamin-elias.probst@mailbox.tu-dresden.de.pdf`
