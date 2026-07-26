GEFUNDEN. Die Original-Planung des Stempel-/Versionierungs-Schemas existiert wortgenau — sie ist NICHT neu (26.07.), sondern seit 19./20.07. in Ledger + Architektur-Dossier gemeißelt. Ein einziger Teilaspekt (Komplex-Achse = EIN gemeinsamer Stempel) ist NICHT vor-dokumentiert.

## 1. ORIGINAL-PLANUNG (wortgenau, Quelle+Zeile)

**A) Das X.Y.Z-Schema + "jeder Achsen-Algorithmus einzeln, nur der Planer eigenständig" — die früheste Quelle (19.07. nachts):**
`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:2362` (§43.b, "User-Direktive, verbatim-treu"):
> „Der **Experiment-Planer traegt auch einen string_view-Stempel, aber nur ueber die eigene statische Versionierung** und unter welcher ISA/OS er passt... Die Versionierung und Stempel sind **X.Y.Z mit X.Y die Feature-Version und Z die Revision des Debuggings** — das gilt fuer **jeden Achsen-Algorithmus (alle Typen) einzeln sowie fuer den Experiment-Planer statisch**."

**B) Die exakte "Achsen-Typ → Haupt-Achse → Algorithmus + Version; keine eigene Binary-Version außer Planner"-Doktrin — die autoritative Quelle (20.07.):**
`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:3014-3021` (§58 — "VERSIONIERUNGS-MODELL", 2026-07-20):
- `:3019` **PLANER:** EIN X.Y.Z-Stempel (Selbst-Version).
- `:3020` **CEB:** „**KEINE Gesamt-Versionierung.** Ein **ARRAY** `[Xa.Ya.Za, Xb.Yb.Zb, Xc.Yc.Zc]` — je einkompilierter **Mess-Achse `[a,b,c]`** ein eigenes X.Y.Z **pro Algorithmus a, b, c** (pro Mess-HAUPT-Algorithmus). Nur HAUPT-Achsen im Stempel."
- `:3021` **TIER-BINARY:** „**KEINE Gesamt-Versionierung.** **ZWEI SEPARATE Array-Versionierungen**: eine fuer die **System-Achse**, eine fuer die **Organ-Achse** (je ein Array je Haupt-Algorithmus). Nur HAUPT-Achsen... die **Unter-Achsen = dynamische Laufzeit-Parameter fliessen zur Laufzeit durch die Binary hindurch** und sind NICHT im Binary-Stempel."

Spiegel-Doku (dieselbe Aussage "in eigenen Worten") `docs/architektur/2026-07-20-cache-engine-architektur-in-eigenen-worten.md:65` (§57/§58):
> „der **Planer** trägt *einen* Stempel `X.Y.Z`; der **CEB**-Stempel ist ein **Array je Mess-Haupt-Algorithmus** `[Xa.Ya.Za, ...]` (keine CEB-Gesamt-Version); die **Tier-Binary** trägt **zwei separate Arrays** — je eines für die System-Achse und die Organ-Achse (keine Gesamt-Version). Alle Binary-Stempel tragen **nur Haupt-Achsen**..."

Das deckt Owner-Wort für Wort: „je Achsen-Typ gegliedert → Haupt-Achsen je Typ → Algorithmus je Haupt-Achse + eindeutige Versionsnummer" = die drei Achsen-Typen (Mess/System/Organ), je Typ ein Array pro Haupt-Algorithmus mit X.Y.Z. „Keine eigene Versionsnummer für CEB/Tier, nur Planner" = §58:3019-3021 wörtlich. „Identifiziert sich aus Haupt-Achsen-Rekombinationen" = „Nur HAUPT-Achsen im Stempel".

**C) Der dritte (Merge-)Stempel — §59, ebenfalls 20.07.:**
`...LEDGER.md:3059` (§59): „ein **dritter Tier-Binary-Stempel = die Merge-Kombination** — ZUSAETZLICH zu den zwei §58-Arrays."

**D) Command-Pattern-Freigabe (das Mechanik-Fundament der Komplex-Achse) — dokumentiert:**
`docs/architektur/2026-07-20-cache-engine-architektur-in-eigenen-worten.md:74`: „Die Hardware-Haupt-Achse **verwaltet und gibt frei**. Jede Meta-Meta-Achse erteilt dann — **als eigenständige Instanz nach dem Command-Pattern** — Freigaben..." (= Ledger §54-T5).

**E) EINZIGE Lücke — Komplex-Achse = "EIN gemeinsamer Stempel":** Das command-pattern-Verhalten ist geplant (D), aber die Regel „die Komplex-Achse trägt EINEN gemeinsamen Stempel über ihre gewrappten Haupt-Achsen" steht so NIRGENDS vor dem 26.07. Belegt durch die Erhebung selbst: `docs/sessions/backups/20260726-layer-modell-erhebung-workflow/ergebnisse/00-layer-modell-a728ca2b.md:79`: „Einzige widerspruchsfreie Lesart: Komplex = Verwaltungs-/Command-Hülle im Verhalten, Klammerung bleibt je Achse... **Das steht so nirgends** — Owner-Nachfrage Q-A." Erst am 26.07. in `docs/sessions/20260726-SESSION-layer-modell-antworten-QA-QF-stempel-doktrin.md:20-26` als Owner-Antwort festgeschrieben. Owners Behauptung „das ist schon genau geplant" trifft also für A–D zu (19./20.07.), für den Komplex-Achsen-Einzelstempel NUR das Command-Pattern-Fundament, nicht die Ein-Stempel-Bündelungsregel.

## 2. CODE-IST (wie versioniert heute)

Der Ist-Code implementiert **A/B/C bereits** — mit einer Ausnahme (per-Achse-Array vs. per-Variante):

- **Planner:** eigene Gesamt-Version vorhanden. `...profile_facade/planner/planner_version.hpp:22`: `kPlannerVersion = "1.0.0"`, Stempel `"planner@X.Y.Z isa=<isa> os=<os>"` (Zeile 42) — deckt §43.b/§58 exakt.
- **CEB:** KEINE Gesamt-Version, Mess-Array wie geplant. `builder/ceb_version_stamp.hpp:2-4`: „Die CEB... hat **KEINE Gesamt-Version** (der Planer schon)... das Mess-Array `[Xa.Ya.Za, Xb.Yb.Zb, Xc.Yc.Zc]` je Tooling". Deckt §58:3020.
- **Tier-Binary:** vier separate Stempel-Zeilen, keine Gesamt-Version:
  - Organ: `include/cache_engine/abi/anatomy_version_stamp.hpp:42-61` (`organ_stamp_line`, 17 Achsen, je `name()+algo_version`).
  - System: ebd. `:64-80` (`system_stamp_line`, 5 System-Achsen, Marker „code").
  - Measurement: ebd. `:83-104` (`measurement_stamp_line`).
  - **Dritter/Merge-Stempel:** ebd. `:164-199` (`merge_stamp_line`, §59-K6a) — implementiert.
- **Per-Achse-Versionierung — der zentrale Ist-Punkt:** `builder/experiment_tree/axis_variant_version_table.hpp:45-49` — Tabelle `{axis, variant, version}`; jede der 17 Organ-Achsen liefert `W::algo_version` (Zeile 43-59). Compile-Time-Durchsetzung: `:63-66` static_assert erzwingt parsbare `algo_version` je Variante (unparsbar → Sentinel `{0,0,0}` → Bruch mit Typ-Namen).
- **algo_version-Granularität ist per-VARIANTE, nicht per-Haupt-Achse:** `axis_variant_version_table.hpp:44-49` — `version` hängt an `W::name()` (der gewählten Variante, z.B. `search_algo=bst@v1`), nicht an der Haupt-Achse als Ganzes. Das ist feinkörniger als Owners „ein gewählter Algorithmus je Haupt-Achse mit dessen Versionsnummer" formuliert — deckt sich aber, weil je Binary genau EINE Variante je Haupt-Achse einkompiliert ist.
- **System-Achsen-Version ist per-Achse (nicht per-Variante):** `include/cache_engine/abi/system_axis_code_versions.hpp:32-38` — 5 Einträge `{achse, "v1.0.0"}`, Marker „code", je Achse einzeln bump-bar. Hier IST es genau „eine Version je Haupt-Achse" wie Owner sagt (System-Achsen tragen keine algo_version, Organ- vs. System-Provenienz strikt getrennt: `axis_variant_version_table.hpp:16-20`).

## 3. DELTA Plan vs. Ist

| Aspekt | Plan (§43.b/§58/§59) | Ist-Code | Status |
|---|---|---|---|
| Planner-Eigenversion X.Y.Z | ja | `planner_version.hpp:22` = "1.0.0" | ✅ deckungsgleich |
| CEB keine Gesamt-Version, Mess-Array | ja | `ceb_version_stamp.hpp:2-4` | ✅ deckungsgleich |
| Tier: 2 Arrays (System/Organ), keine Gesamt | ja | organ_/system_stamp_line | ⚠️ als je EINE Version-**Line** (nicht als per-Haupt-Algo-**Array**) — §58-Folge-TODO offen: `LEDGER.md:3031` „[§58-STEMPEL] von Einzel-Zeilen auf Array-Form (OFFEN, hoch)" |
| Dritter Merge-Stempel | §59 | `anatomy_version_stamp.hpp:164` | ✅ implementiert (K6a) |
| „Nur Haupt-Achsen im Stempel; Unter-Achsen laufen durch" | ja | `anatomy_version_stamp.hpp:89-90` Invariante belegt | ✅ deckungsgleich |
| **Komplex-Achse = EIN gemeinsamer Stempel (Command-Pattern-Klammer)** | **NICHT vor 26.07. geplant** (nur Command-Freigabe war da) | **existiert NICHT im Code** — kein `complex_axis`/rekursiver Wrapper-Stempel | ❌ neue Doktrin 26.07., Bau offen (Q-F: „solche Achsen gibt es noch nicht") |

**Kernbefund für Owner:** Das Stempel-Schema ist für Planner/CEB/Tier/Merge **wortgenau vorgeplant** (Ledger §43.b vom 19.07. + §58/§59 vom 20.07., Spiegel ARCH20:65/74) und im Code weitgehend umgesetzt — offen bleibt nur die Umstellung der Tier-Version-**Lines** auf die geplante **Array-Form** (§58-STEMPEL-TODO, `LEDGER.md:3031`). Der Komplex-Achsen-Teil („EIN gemeinsamer Stempel über rekursiv gewrappte Haupt-Achsen") ist die **einzige nicht vor-dokumentierte Zusage** — das Command-Pattern-Fundament existiert (ARCH20:74), die Ein-Stempel-Bündelungsregel wurde erst am 26.07. gesetzt (`20260726-SESSION-...-stempel-doktrin.md:20-26`) und ist im Code noch nicht vorhanden.