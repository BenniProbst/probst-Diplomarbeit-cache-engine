# SYNTHESE — max-Effort code-review Phase 2 (#221 RC-Dynamik), 2026-07-09

> Workflow `wf_7413f821-5d9` (38 Agenten). Scope = ce `1f9c2eef` + super `2a8c36c` (seither REVERTIERT: ce `290e306c`/super `07362a4`, main wieder sauber-grün). Rohdaten: `rohdaten/ERGEBNIS-wf_7413f821.json` (82 KB) + `journal.jsonl`. 34 verifiziert → 29 kept / 5 refuted → 15 distinkte Defekte. **Re-Implementierungs-Spec für #221.**

## Kernbotschaft
Die RC-Wiring-**Architektur** (`if constexpr(requires{organ_.set_runtime_X(…)})`) ist ok — aber die **RC-Effekt-Semantik war in Dossier 17 unterspezifiziert**, Codex hat sie erfunden, und mehrere sind messtechnisch falsch oder fragwürdig. Mein Zeile-für-Zeile-Review + Codex' eigene ctest 5/5 übersahen alles, weil die Tests nur den Happy-Path (frischer Tier, in-process POD) prüften — die Bugs manifestieren erst zur #156-Mess-Laufzeit (Edge-Cases: budget<live-set, reused Tier, Rollback, CSV-Output). **Anti-Phantom-Ziel selbst verfehlt** (Finding 5: batch_size erreicht die CSV nie).

## TEIL A — KLAR-BUGS (bei Neuimpl. zwingend fixen, unabhängig von Semantik)
| # | Datei:Zeile | Verdikt | Bug → Fix |
|---|---|---|---|
| A1 | `axis_04_..._layout_aware_store.hpp:467/203` | CONFIRMED | budget-gegatetes `append_slot` bricht `rebuild_`-Invariante (append-always) → `erase`/`migrate` verwirft gültige Keys = **Datenverlust**. Fix: Budget NUR beim `insert` gaten (vor dem Flatten), NIE in `rebuild_`/`append_slot`. |
| A2 | `observable_composed_container.hpp:68` + `abi_adapter.hpp:840` | CONFIRMED | `insert()`→false bei Budget-Reject, aber `tier_insert` ignoriert Return → treibt alle Observer/Aux-Organe (Bloom/value-handle/Patricia/…) für NICHT-gespeicherte Records → **Über-Zählung + unbegrenztes Aux-Wachstum**. Fix: Return prüfen, bei Reject Observer/Aux überspringen. |
| A3 | `observable_composed_container.hpp:184` | CONFIRMED | `if (visited>=batch_size) return;` returnt nur aus dem for_each_record-Lambda, nicht der Schleife → **jeder Lookup Full-Scan** (batch_size-Signal flach für container-Familie). Fix: Schleife beenden. |
| A4 | `observable_composed_search.hpp:144` + container:157 | CONFIRMED | `restore_statistics()` (O(1)-Rollback #133) nullt die batch-probe-Counter statt sie zu erhalten → Unter-Report nach Rollback. Fix: Counter im Rollback erhalten. |
| A5 | `abi_adapter.hpp:1047/1050` | CONFIRMED | batch_size→`axis_stats[0][6/7]`, aber `kV3AxisSchema[0]` = `nullptr` an 6/7 → CSV-Emitter droppt nullptr-Spalten → **batch_size-Evidenz erreicht die #156-Ausgabe NIE** (Test grün nur via in-process POD). Fix: in eine benannte Schema-Spalte routen (gültiger Slot). |
| A6 | `abi_adapter.hpp:228` (+ alle set_runtime_*) | CONFIRMED | 0-als-Sentinel: `if (X!=0) member_=X` → auf **wiederverwendetem Tier kein Reset auf Default** (Punkt B mit thread_count=0 behält 8 aus Punkt A) → konfundierte Reihen. Fix: pro Mess-Punkt echtes Reset (Wert inkl. 0 anwenden, oder explizites reset). |
| A7 | `axis_04_..._store.hpp:248/236` | CONFIRMED | `allocator_statistics().failure_count` faltet Budget-**Policy**-Rejections in das echte Allocator-OOM-Signal (T6 „fail") + `clear()` resettet `runtime_pool_budget_rejections_` nicht → monotone Akkumulation. Fix: separater Rejection-Counter, Reset in `clear()`. |
| A8 | `observable_composed_container.hpp:180` | CONFIRMED | batch-probe hinter `if constexpr(requires{for_each_record})` → **stiller No-Op für flache Container** ohne for_each_record (Phantom-Zero wieder da). Fix: Probe unbedingt treiben (wie search-Wrapper via slot_count/key_at). |
| A9 | `observable_composed_search.hpp:292` · `axis_14_..._observable.hpp:192` | PLAUSIBLE | 2 latente Div-by-Zero: `k % static_cast<key_type>(n)` (narrow key #217-2b) + `span>=3?span-3:1` (span==3→mod 0). Fix: Guards härten. |

## TEIL B — METHODIK-FRAGEN (Thesis-Semantik = User-Entscheidung, vor Neuimpl. klären)
Die RC-Effekte müssen ein **ehrliches, vergleichbares Mess-Signal** sein, kein dekoratives Busy-Work. Dossier 17 „nimmt echt Effekt" spezifiziert das WAS nicht. Offene Punkte:
- **M1 pool_budget-Reichweite:** nur an `LayoutAwareChunkedStore` (flat-store) verdrahtet; die Pool-Familien-Organe (btree/hash/swiss/eytzinger/masstree/wormhole/surf) haben keinen Setter → `if constexpr` false → **Phantom bleibt für alle pool-backed der 320**. Frage: soll pool_budget ALLE Organ-Familien treffen (dann Setter je Familie), oder ist flat-store-only der gewollte Scope (dann Phantom-Marker nötig)?
- **M2 thread_count-Modell:** als N sequenzielle acquire/release-Paare in EINEM Thread modelliert → T8 zeigt „3 Threads, 0 Contention" (physikalisch unmöglich). Frage: soll thread_count echte Nebenläufigkeit/Contention messen, oder ist ein Wiederholungs-Zähler akzeptabel (dann anders benennen/interpretieren)?
- **M3 value_handle-inline_threshold:** der RC-Pfad unterdrückt version-tag/chain-depth-Accounting (`effective_has_version_tag_` false bei threshold≠0) → Phantom-Zero in T11 für versionierte/verkettete Strategien. Frage: soll der RC-Override mit dem Strategie-Accounting koexistieren statt es zu ersetzen?
- **M4 (übergreifend):** was ist der INTENDIERTE Laufzeit-Effekt je RC-Achse, damit die #156-DEG ein valides, achsen-attribuierbares Signal ist? → das ist die eigentliche Spezifikations-Lücke.

## Empfehlung
A1-A9 sind eindeutige Fixes. B1-B4 brauchen die User-Methodik-Entscheidung (Thesis). Neuimpl. via Codex ERST nach geklärter RC-Effekt-Semantik + mit Edge-Case-Tests (budget<live-set, reused-Tier-Reset, Rollback-Erhalt, CSV-Named-Column-Sichtbarkeit) — nicht nur Happy-Path.
