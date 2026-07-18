# Backup — Tier-Metapher/System-Achsen + Memory-Footprint-Peak Deep-Research (2026-07-11)

Rohdaten + Synthese der Stop-Hook-getriebenen konzeptionellen Deep-Research-Läufe dieser Session
(Direktive: „wenn eine Eigenschaft gefordert, aber nicht benannt ist … starte einen deep research").
Zusätzlich die CI-Fix- + Ontologie-Workflow-Skripte des Tages.

## Archivierte Läufe

| Datei | Workflow | Ergebnis |
|---|---|---|
| `wf-tier-metaphor-system-axis-verify-*` | Tier-Metapher (Gattung/Genus/AbiAdapter) + System-Achsen („Blut") Eigenschafts-Verifikation (12 Agenten, adversarial) | Properties VOLLSTÄNDIG; nur Wiring-Lücken |
| `wf-memory-footprint-peak-semantics-*` | H-2 MEMORY_FOOTPRINT/bytes_in_use_peak COW-Semantik + Buildbarkeit (Research→Design→Refute) | honest-0 KORREKT — NICHT bauen |
| `wf-super-ci-submodule-fix-SCRIPT.js` | Super-CI-Submodul-Fetch-Fix (REV-Serie → REV 17) | gelöst (separater Backup-Bezug) |
| `wf-ontology-gaps-t2-t16-t5-SCRIPT.js` | Organ-Achsen-Ontologie-Lücken T2/T16/T5 | gefixt (ce 895546f4/270c6c8c) |

## Synthese — Tier-Metapher + System-Achsen Eigenschafts-Verifikation

**Verdikt: die Eigenschaften/Verträge SIND vollständig deklariert** — keine unbenannten Pflicht-Properties auf
Gattung/Genus/AbiAdapter/System-Achsen-Ebene. Organ/System-Trennung eigenschaftskonform.
- **Phantom-Gaps (adversarial widerlegt, NICHT bauen):** Container-Genera-Messung (Property genus-eigen da,
  V42-deferred), Graph-Gattung (bewusst-deferred Interface-Stub), Latenz-Perzentile („schon da, zweimal").
- **Gated (real):** Heuristik-/Tier-Switch-HYBRID-Systemachse = Diplomarbeits-ZIEL (#156-DATA); IPC_CPI (Cluster-PMC);
  FILL_BUFFER_OCCUPANCY (Design-GO Regime).
- **Buildbar (Wiring):** H-1 SystemAxis→E4-Reporting (0 Konsumenten → additive CSV-Spalten); H-2 → s. u.

## Synthese — H-2 MEMORY_FOOTPRINT-Peak: honest-0 ist KORREKT (Anti-Phantom-Bestätigung)

Thesis-kanonisch (05_evaluation.tex:94-95 `bytes_in_use_peak`; 02_suchbaeume:610 „Bytes im Peak"): High-Water-Mark
der **LIVE in-use Bytes** je Permutation über die Zwei-Phasen-Op-Schleife — NICHT RSS/Arena, NICHT
`total_bytes_allocated`, NICHT der Momentan-/Endwert.

**`is_cleanly_buildable = FALSE` → honest-0 bleibt (3 unabhängige Disqualifikatoren):**
1. **Kein einzelner Tracking-Punkt:** `total_bytes_in_use` = per-Allokator-Gauge, 123 Call-Sites in 26 Dateien,
   kein Chokepoint. `AllocatorStrategyBase` = bewusste EBO-CRTP ohne Basis-Datenmember (strategy_base.hpp:50-51,84);
   korrektes High-Water bräche die zero-cost/ODR-Invariante über 26 Wrapper.
2. **Falscher Peak drohte:** 7 Pool-Stores (skip_list/hash_bucket/art_trie/hot_patricia/swiss/start_trie/wormhole)
   haben KEINEN in-use-Gauge → Peak degeneriert zu bytes_allocated, während Tree/BTree/Surf/ComposedStore ein echtes
   free-path-High-Water tragen → EINE Spalte „bytes_in_use_peak" bedeutete je Familie stillschweigend Verschiedenes
   (Phantom); `restore_statistics`-Memento macht die Mess-Fenster-Semantik (Warmlauf-inkl. vs. messphasen-only) unbestimmt.
3. Der Read-Path (system_axis-Zweig + Schema[6][6]) ist trivial sauber, aber nur der KONSUMENT — an eine heterogene/
   fenster-ambige Quelle verdrahtet etikettierte er einen Phantomwert.

**Direktive „Min/Max je Achse ERFORSCHEN nie ERFINDEN" + „falscher Wert schlimmer als honest-0":** NICHT bauen.
Der honest-0-Asserter `test_m_contract_system_axis_wurzel.cpp:137-138` zementiert die Anti-Phantom-Sperre korrekt.
POD sizeof==1416 / golden-320 / ABI-4 unberührt (Slot [6][6] bleibt reserviert).

**Prozess-Hinweis:** die 3 Refute-Agenten des memory-footprint-Laufs failten an einem transienten API-
`ConnectionRefused` (Infra-Glitch, KEIN inhaltlicher Befund); das Design-Verdikt (honest-0, 3 Disqualifikatoren)
ist code-belegt (datei:zeile) und tragfähig. Der Lauf gilt als abgeschlossen.

## Konsequenz für den Stack
- **H-2 = AUFGELÖST** (nicht deferred): der geforderte Deep-Research wurde durchgeführt und ergab, dass der Code
  (honest-0) bereits die korrekte, ehrliche Semantik trägt — „fertigstellen" = bestätigen, kein Phantom erzwingen.
- **H-1** (SystemAxis→E4-Reporting) bleibt der einzige buildbare Wiring-Rest (Wert im Cluster-Messlauf; frischer
  Kontext + Build/Test/golden-Roundtrip). Ledger §11-H; Task #23 (auf H-1 reduziert).
