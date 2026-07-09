# DOSSIER #221 — RC „Null-Object" schließen: prefetch_distance als LAUFZEIT-RC-Knopf am REALEN Store-Prefetch (ABI-4, golden-neutral, Meta-Lehre-#3-sauber)

> **Für Codex** (`--sandbox workspace-write`, gpt-5.5, xhigh). EIN Agent, KEINE Sub-Agenten. Repo-Wurzel = `--cd`
> (comdare-cache-engine). **NICHT committen, KEINE git-Operationen.** Bei Unerfüllbarkeit (§4-Pre-Check scheitert): STOPP + §7.
> Basis = fresh-context-Kartierung (Explore a1499b48) + Claude-Eigenverifikation (Pfade unten alle belegt).

## 1. Auftrag (der EINE ehrliche contained Slice der #229-Strecke)
Der Audit-Befund **A3/K1** (`docs/sessions/20260613-A3-audit-soll-abgleich.md:14`): „RC = **write-only Null-Object**: `applied_rc_`
nie gelesen, KF-5-§7-Organ-API nie gebaut → ×18-Dynamik degeneriert zu ×3." USER-Entscheid = **Vollendung** (Zweig a: RC
messbar wirksam machen). **Dieser Slice** schließt den Defekt für **GENAU EINE Achse (prefetch)**: die Laufzeit-RC
`applied_rc_.prefetch_distance` wird in das **bereits existierende reale Store-Prefetch** (Pfad B / tier_observe) als
**Laufzeit-Distanz** eingespeist, sodass zwei RC-Distanzen auf DERSELBEN geladenen `prefetch=Distance`-Binary einen
**messbar verschiedenen realen T7-Observer-Wert** erzeugen. Die anderen 4 RC-Achsen (concurrency/allocator/traversal/
value_handle) bleiben **#229-Folge** (im Kommentar so vermerken).

## 2. VERIFIZIERTER Ist-Zustand (nutze GENAU diese Belege)
- **Der „Null-Object":** `libs/cache_engine/anatomy/abi_adapter.hpp` — `tier_apply_resource_control` (:203-220) klammert an
  Caps + **schreibt in `applied_rc_`** (:214-218, Member-Decl :1940). **`applied_rc_` wird NIRGENDS gelesen** (grep-belegt) →
  RC verpufft. `tier_query_resource_caps` (:193-202) liefert echte Caps (prefetch_distance-Cap = 64).
- **Mess-Pfad der RC-Schleife = Pfad B:** `builder/experiment_tree/runtime_variable_loop.hpp:89` ruft `tier_apply_resource_control`,
  danach misst `builder/experiment_tree/runtime_measure_visitor.hpp:47` via **`tier.tier_observe(&pod)`** (echter Store, NICHT
  das synthetische `do_batch`). ⇒ Der Einspeise-Effekt MUSS im tier_observe-getriebenen realen Prefetch sichtbar werden.
- **Reales Prefetch + T7 existieren bereits (Pfad B):** `abi_adapter.hpp:1027-1045` — `if constexpr(ObservableAxis<pf_organ_>)`
  liest `pf_organ_.statistics()` in `s.axis_stats[7]`: `r[5]=real_prefetches_issued`, `r[6]=last_prefetch_distance`,
  `r[0]=trigger_count` (Schema `observable_tier.hpp:77-79`). Der reale `_mm_prefetch` sitzt im Organ
  `libs/cache_engine/axes/prefetch_axis/axis_07_prefetch_real_descent.hpp` (family_id 1 DistanceEstimator = `_mm_prefetch` auf
  Slot `i+distance`; `prefetches_issued`/`last_prefetch_distance` real gezählt) — die **Distanz kommt heute vom compile-time-Organ**.
- **Host-RC fertig (nicht anfassen):** `builder/algorithm_resource_control.hpp` (clamp/apply_to), `builder/cacheline_policy/
  cacheline_policy_selector.hpp` (#174, drückt RC bis an die Tier-Grenze), `anatomy/resource_controllable_tier.hpp`
  (`ComdareResourceControlV1`-POD + Interface). **DynamicVariableNode** (`builder/experiment_tree/experiment_tree.hpp:138-155`)
  ist fertig, `contributes_to_signature()==false` (:146) ⇒ golden-320-neutral. **NICHT** am DynamicVariableNode „vollenden".

## 3. Soll (der Slice)
(a) **Prefetch-Organ (axis_07 DistanceEstimator) bekommt einen LAUFZEIT-Distanz-Knopf** — z.B. ein optionales `runtime_distance`-
   Member/Setter `set_runtime_distance(std::uint32_t)`, das die Descent-Prefetch-Distanz zur Laufzeit überschreibt.
   **DEFAULT = die bisherige compile-time-Distanz** (wenn kein RC gesetzt) ⇒ statische golden-320-Binaries VERHALTEN SICH
   UNVERÄNDERT. NUR None/Distance/… wie bisher; **KEINE Änderung der compile-time-Organ-SELEKTION** (kein neuer Enum, keine
   Registry/mp_list-Änderung).
(b) **Adapter propagiert die RC:** in `tier_apply_resource_control` (abi_adapter.hpp:203-220) nach dem Schreiben von
   `applied_rc_` zusätzlich `pf_organ_.set_runtime_distance(applied_rc_.prefetch_distance)` aufrufen (nur wenn das Organ die
   Fähigkeit hat — `if constexpr`/`requires`, sonst No-op; die 3 Nicht-Distance-Prefetch-Organe bleiben unberührt/neutral).
   `applied_rc_` bleibt zusätzlich geschrieben (Rückwärtskompat). KEINE neue vtable-Methode, KEIN neues POD-Feld.
(c) Ergebnis: `tier_observe` liest via `pf_organ_.statistics()` `last_prefetch_distance`/`real_prefetches_issued` → **zwei
   verschiedene RC-`prefetch_distance`-Settings ⇒ verschiedener `axis_stats[7][6]` (und ggf. [5])** auf derselben Binary.

## 4. PRE-CHECK (PFLICHT, Codex zuerst — bei Scheitern STOPP + §7)
Lies `axis_07_prefetch_real_descent.hpp` (+ `axis_07_prefetch_distance_estimator.hpp` / `axis_07_prefetch_observable.hpp`):
ist die Descent-Prefetch-**Distanz** ein Laufzeit-Member (dann Setter trivial) ODER ein `constexpr`/Template-Parameter?
- Wenn Laufzeit-Member/leicht überschreibbar → umsetzen wie §3.
- Wenn `constexpr`/nicht ohne Organ-SELEKTIONS-Änderung überschreibbar → **STOPP** (das wäre die #229-Vollstrecke, nicht dieser
  Slice) + melde die genaue Stelle. NICHT synthetisch ausweichen.

## 5. HARTE Auflagen (Verstoß = Abbruch)
1. **Meta-Lehre #3 (Apparat-Reinheit) — KRITISCH:** KEIN synthetisches Prefetch in `do_batch`/`run_workload` (Pfad A, `lbuf`).
   Der Effekt MUSS über das REALE Store-Prefetch (Pfad B, tier_observe) laufen. (Der User hat einen synthetischen Prefetch-
   Puffer bereits einmal gestoppt — NICHT wiederholen.)
2. **ABI-NEUTRAL (MAJOR bleibt 4):** nur host-seitige Organ-/Adapter-Member. NICHT anfassen: `COMDARE_ANATOMY_ABI_MAJOR`
   (`abi/anatomy_module_abi_v1_decl.hpp:43`), der Observer-POD `ComdareTierObserverSnapshot` (`observable_tier.hpp:127-133`,
   sizeof==1416, byte-stabil), `ComdareResourceControlV1`-POD, extern-C, vtable-Layout von IObservableTier/IResourceControllableTier.
3. **GOLDEN-320-NEUTRAL:** Default-Distanz = compile-time ⇒ statische Binaries unverändert. NICHT anfassen: `permutation_axes.xml`,
   die prefetch-Registry/mp_list (compile-time-Selektion), `golden_fullpilot_320_binary_ids.txt`, `gen_golden_fullpilot.cpp`,
   `kCompositionAxisNames`(19), AdHocComposition-Arität. (DynamicVariableNode ist ohnehin nicht signatur-relevant.)
4. **Ehrliche Zähler:** `last_prefetch_distance`/`real_prefetches_issued` müssen die REAL abgesetzten `_mm_prefetch` widerspiegeln
   (kein erfundener Wert). Kommentar: „RC-prefetch_distance = Laufzeit-Distanz-Override am realen Store-Prefetch; #229-Folge = die 4 übrigen RC-Achsen + KF-5-§7-Voll-API."
5. Kein `git`.

## 6. Verifikation (PFLICHT — Codex, literal)
- Neuer/erweiterter Test (Vorlage `tests/unit/test_kf4_resource_control.cpp` bzw. `test_d13_runtime_measure.cpp:86-104`,
  In-Process, kein DLL-Bau nötig): baue ein Tier mit `prefetch=DistanceEstimator`, `tier_apply_resource_control` mit
  `prefetch_distance=D1`, Workload+`tier_observe` → merke `axis_stats[7][6]`; dann `prefetch_distance=D2` (≠D1) → `tier_observe`
  → ASSERT `axis_stats[7][6]` (bzw. [5]) **verschieden** (deterministisch, count/distanz-basiert, KEIN Timing-Assert). Plus:
  ohne RC = Default-Distanz (Regression). Registrierung in `tests/unit/CMakeLists.txt` (`comdare_add_test`).
- Baue+laufe den Test lokal → literal `[ PASSED ]`. Beweise golden-Neutralität: kein Eintrag in `permutation_axes.xml`/
  Registry-mp_list geändert; `COMDARE_ANATOMY_ABI_MAJOR` unverändert (4).
- `git status --short` zeigt NUR: das Prefetch-Organ (axis_07), `abi_adapter.hpp`, der neue Test, `tests/unit/CMakeLists.txt`.

## 7. Ausgabe an Claude
(a) Diff Organ + Adapter (Setter + Propagation) + Test; (b) Pre-Check-Ergebnis (war die Distanz laufzeit-setzbar? falls STOPP:
genaue Stelle); (c) Bestätigung: KEIN Pfad-A-Synthetik-Prefetch, ABI-4, golden-neutral (Default=compile-time), kein POD/vtable/
extern-C-Change; (d) literales PASSED (zwei RC-Distanzen ⇒ verschiedener T7); (e) explizit: die 4 übrigen RC-Achsen + KF-5-Voll-API bleiben #229.
