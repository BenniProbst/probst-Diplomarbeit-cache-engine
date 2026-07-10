# SYNTHESE — Schicht-E1-Review (adversarial), 2026-07-10

> Workflow `wf_3017934d-c81` (23 Agenten: 3 Finder + 20 Verifier, 2 Verifier durch Fable-Safeguard-Fehlalarm ausgefallen; 1,17M Tokens). Scope = uncommitted Schicht-E1-Diff (Codex-Erstimpl. der 4 ehrlichen RC-Konsum-Pfade + A1-A9-Fixes) nach meinem Voll-Review. Rohdaten: `rohdaten-review/` (Ergebnis + Journal + Skript). **5 CONFIRMED (2:0) + 1 UNVERIFIED (Safeguard-Ausfall, minor) + Refutals (static-Sharing = beabsichtigt; try_lock-spurious = POSIX-refutiert). Alle CONFIRMED vor dem Commit manuell gefixt.**

## CONFIRMED → gefixt
| # | Fund | Schwere | Fix |
|---|---|---|---|
| C1 | **T1-batch_size multiplizierte die Mess-Arbeit quadratisch** (batch_count=ceil(n_ops/B), aber do_batch fuhr weiter n_ops Ops JE Batch ⇒ ~n_ops²/B; batch_size=1 hätte die mehrtägige #156-Pipeline auf Wochen gestreckt) UND die „MIN Cache-Misses"-Semantik existierte nicht (jeder Batch besuchte alle Keys) | **critical** | **Fenster-Semantik:** `batches` bleibt FIX 8 (P-MD3-Coverage + Alt-Kommensurabilität); `batch_size` steuert die Ops JE Batch, Fenster-Basis rotiert (`t1_base = b·ops`, `keys[(t1_base+i)%nk]`) — kleines Working-Set je Batch = ECHTE Cache-Wirkung; Arbeit sinkt (8·B) statt zu explodieren; RC=0 byte-gleich Alt (max(keys,256)×8); r[6] weist die EFFEKTIVE Fenster-Größe aus |
| C2 | **OLC von Read-Validate auf Schreibbit-CAS-Spinlock umgebaut**: Differenzierung zu LockFree kollabiert (instruktionsgleich), Familien-Inkonsistenz zu OlcReservedBlocks, Fake-Validierung (Snapshot-Bit konstant true), alte T8-Reihen inkommensurabel (W3) | major | **OLC vollständig auf HEAD zurückgesetzt** (Read-Validate-Bahn; kein try_acquire ⇒ Observable zählt für OLC nie Lock-Contention = EHRLICH: die optimistische Bahn kennt keine Lock-Wartezeit, ihr Konkurrenz-Kanal ist validation_fail) |
| C3 | **ReaderWriter verlor die Reader-Bahn** (lock_shared→exklusiv): Strategie-Differenzierung zu Blocking eliminiert, W3-Bruch; Spec wäre mit try_lock_shared erfüllbar gewesen | major | `try_lock_shared()/lock_shared()/unlock_shared()` — Reader-Charakteristik erhalten; Contention zählt nur bei echter Writer-Konkurrenz |
| C4 | **A2-Gate verwechselte Duplicate-Upsert mit Budget-Reject** (`is_new=false` in beiden Fällen): alle Pfad-B-Kopplungen für Update-Ops übersprungen (YCSB-A/F-Kollaps, vh-Backing stale bei realem Update) | major | explizites Signal `last_insert_was_budget_reject()` an der Hülle; Adapter skippt NUR beim echten Reject, Upsert treibt die Kopplungen wie vor #221 |
| C5 | (identisch C1 aus zweiter Dimension — dedupliziert) | major | in C1 |
| U1 | `segment_key_count_for_timing_`-Zweige redundant (beide liefern occupied_count) — Verifier durch API-Safeguard ausgefallen (0:0) | minor/UNVERIFIED | belassen (funktional korrekt, kosmetisch); im Folge-Increment vereinfachbar |

## REFUTED (nicht gefixt, dokumentiert)
- static-Primitive prozessweit geteilt: beabsichtigter Fix des thread_local-„3-Threads-0-Contention"-Problems (SYNTHESE-M2), test-gedeckt.
- `try_lock`-spurious-failure: formal erlaubt, auf der Linux/glibc-Zielmatrix (pthread_mutex_trylock) praktisch ausgeschlossen.

## Verifikations-Endstand (eigene Läufe, literal)
clang-format-22==0 · Mojibake==0 · offizieller build/ (g++-16): **11/11 Passed** (e1-Contract [6 Fälle inkl. Reject-Invarianten, Contention N>1/N==1, CSV-Header-Spalten, Reused-Tier-Reset], seg_coverage [P-MD3-Invariante mit dynamischem Fenster], E2/E3/E4/M-Contracts, cmd1_a, 3 Guards) · build-cmd1b: **f15_measurement 29/29** · golden/m3v2/permutation_axes byte-unberührt · RC=0-Pfad byte-verhaltens-gleich (Kommensurabilität der Alt-Reihen).
