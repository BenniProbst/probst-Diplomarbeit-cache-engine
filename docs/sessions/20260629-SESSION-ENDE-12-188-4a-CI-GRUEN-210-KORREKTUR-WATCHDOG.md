# SESSION-ENDE 12 — #188-4a CI-GRÜN · #210-Selbstkorrektur (Watchdog) · C3-Plan

> **Datum:** 2026-06-29 · **Agent:** Implementierungs-Agent (Diplomarbeit cache-engine, autonomes /goal)
> **Vorgänger:** `20260628-SESSION-ENDE-11-…-188PLAN.md` + Dossier `…/comdare-cache-engine/docs/sessions/20260628-KONTEXT-DOSSIER-…-A2welle.md` (§18 E4/E3-Gate, §19 #188-4a-C-Plan)
> **HEADs am Ende:** cache-engine **`7fdb179`** · super **`83ec52e`** (beide Remotes, Arbeitsbaum PRISTINE/clean). Diese Übergabe wird als super-Commit ergänzt.

---

## 0. TL;DR (das Wichtigste zuerst)

1. **#188-4a (KAryTraversal-Organ) + 4a-C (C1/C2/C6, K-bewusst) sind CI-GRÜN VERIFIZIERT** (literal): `contract:conformance` auf Pipeline 7131 (aa8b174) + 7133 (7fdb179) → `k_ary K=2/4/8/16 alle passed()==true, cases=4249/4249, first_fail=0, ALLE OK, Job succeeded`. **Erste echt CI-compile+run-verifizierte K-Variation** (Meta-Lehre #3: K real UND std::map-konform).
2. **#210 ist NICHT geheilt** — und ich habe in dieser Session einen **Fehler gemacht + selbst korrigiert**: Ich deutete den EOF-Watchdog als Fehlalarm + schaltete ihn ab → CI brach (Pipeline 7135 hing 23 min). **Echte Wurzel (verifiziert): der prod1-Runner-Poll-Loop VERSTUMMT nach Minuten komplett.** Der Watchdog-Periodic-Restart ist die **funktionierende Mitigation** — wieder aktiviert. Timer MUSS an bleiben. Details §3.
3. **C3 (iterable-ABI-Kanal) wurde GEERDET, aber NICHT committet** (unvollständig → reverted, pristine). Execution-ready Plan + Verbatim-Code in §5.
4. **NEUE kritische Architektur-Erkenntnis:** `abi_adapter` wird in KEINEM CI-Contract-Job kompiliert → C3c/C4/C5 sind **harness-gated** (#162/#230), NICHT Linux-CI. Verifikations-Landkarte §4.

---

## 1. Session-Bogen (chronologisch, was geschah)

1. Voll-Kontext geladen (Dossier §18/§19 + Vorgänger-Übergaben).
2. **E4/E3-Completeness-Gate** (Workflow + Codex + eigener Spot-Check) → DONE bestätigt (war schon §18 persistiert). Differenz reduzierte sich auf #221 (E1, bereits getrackt).
3. **#188-4a-C C1/C2/C6** (K-bewusste KAryTraversal): committet `7fdb179`, Codex-SHIP, **CI-grün 7133**.
4. **#210 „Pipeline klemmt"** (User-Info) → User gab Freigabe, selbst zu heilen + Wunsch „funktioniert auch ohne Watchdog".
5. **#210-Fehlanalyse + Korrektur** (§3) — der Kern-Lernpunkt dieser Session.
6. **C3 begonnen** (Interface + Forwarder + Test-Verdrahtung), Test-Edit schlug fehl (falscher Anchor) → **reverted auf pristine 7fdb179** (#188 nie halb committen).
7. Diese Übergabe.

---

## 2. CI-GRÜN verifiziert (literal — der harte Beleg)

| Pipeline | SHA | Commit | `contract:conformance` literal |
|---|---|---|---|
| 7131 | aa8b174 | #188-4a KAryTraversal-Organ + #223-Erweiterung | `k_ary (KAryTraversal/RawSlotStore): passed()==true · cases=4249/4249 first_fail=0 · ALLE OK · Job succeeded` |
| 7133 | 7fdb179 | #188-4a-C C1/C2/C6 (K-bewusst) | `k_ary K=2 ✓ K=4 ✓ K=8 ✓ K=16 ✓` — alle `passed()==true, first_fail=0, cases=4249/4249` · `ALLE OK · Job succeeded` |

**Was das beweist:** Das neue `KAryTraversal`-Organ ist über den realen Pilot-Store (`ComposedSearch<KAryTraversal, RawSlotStore>`) std::map-konform für JEDES K∈{2,4,8,16}. Damit ist die k-ary-Such-Achse **store-traversierbar (Weg-A-fähig)** + die K-Variation real ohne Phantom. Das ist genau die Mess-Echtheit, die #188 herstellen soll (T0-Such-Delegation über DENSELBEN Store statt search_organ_-Spiegel).

**Code-Stand `7fdb179` (committet, CI-grün):**
- `libs/cache_engine/axes/lookup/composable/k_ary_traversal_organ.hpp` — KAryTraversal (insert/erase/scan delegieren an SortedBinary; nur `lookup_in(Store, k, arity=4)` ist k-Wege-Partition, bit-identisch zu KArySearchAlgo::lookup; clamp K>=2). `static_assert` TraversalOrgan + ScannableTraversalOrgan + **ConfigurableTraversalOrgan**.
- `libs/cache_engine/axes/lookup/composable/composable_search.hpp` — `ConfigurableTraversalOrgan`-Concept + `ComposedSearch::set_iterable_aspect(unsigned)`/`iterable_aspect()` + lookup nutzt `if constexpr (ConfigurableTraversalOrgan<…>) { if (iterable_aspect_ != 0) return …lookup_in(store_, k, iterable_aspect_); }`.
- `traversal_for_search_algo.hpp` — `KArySearchAlgo → KAryTraversal`-Mapping.
- `tests/unit/test_conformance_gate.cpp` — `KAryComposedTier` (Ctor `KAryComposedTier(unsigned arity)`) + Testblock (5) Default-K + (6) Per-K-Schleife {2,4,8,16}.
- **Marker `axis_03a_store_traversable` ist AUS** (k-ary bleibt Weg-B in den 320 DLLs); Aktivierung = C5. `axis_03a_search_algo_registry.hpp:90-91` `static_assert(!StoreTraversableSearchAlgo<KArySearchAlgo>)` würde bei Flip brechen → C5 dreht es auf positiv.

---

## 3. ⚠️ #210 — SELBSTKORREKTUR (kritischer Lernpunkt dieser Session)

### Was ich falsch machte
Ich beobachtete: Runner pollt sauber `status=204` alle 3s (kein EOF), und die Watchdog-7-Tage-Historie = **247× „stiller Stall" vs 1× „EOF-Sturm"**. Schluss: der „stiller-Stall"-Trigger sei ein **Fehlalarm** (idlender Runner pollt 204, das wird bei info-Level nicht geloggt → sieht aus wie Stall). Ich **disable'te den Timer + schrieb Skript-v3 (Trigger-2 raus)**. Ich markierte #210 „geheilt".

### Warum das FALSCH war (verifiziert)
Die frische Pipeline 7135 (als „watchdog-frei"-Beweis getriggert) **hing 23 min auf `pending`** (lint:secrets runner=None). Direktprüfung: Runner-**Uptime 23 min ohne Restart**, `journalctl --since "5 min ago"` = **0 Polls** (kein „Checking for jobs", kein 204, kein EOF — komplett STILL), GitLab meldet ihn aber „online".

⟹ **Echte Wurzel: der gitlab-runner stellt das Polling nach einigen Minuten KOMPLETT ein.** Kein EOF im Log → das Long-Poll-Socket hängt vermutlich STILL tot (Middlebox/conntrack droppt die lang gehaltene Verbindung ohne RST/FIN; der Runner wartet ewig auf dem toten Socket statt neu zu pollen). Der „stiller-Stall"-Trigger detektiert das KORREKT; der Restart **revived** den Runner. Die 247 Restarts waren NÖTIG — deshalb wurden Pipelines historisch „eventually" (langsam, über Watchdog-Zyklen) grün.

### Die Korrektur (am selben Tag, verifiziert)
`cp` Skript aus `*.bak.<ts>` (v2 MIT „stiller Stall"-Trigger) → `systemctl enable --now gitlab-runner-eof-watchdog.timer` → Runner neu gestartet. **7135 lief sofort an: lint:secrets = success (runner=16), Pipeline `running`.** Mitigation wiederhergestellt.

### Der Lernpunkt (für die nächste Session zwingend)
**NIE eine laufende Mitigation abschalten, ohne den Ausfall OHNE sie zuerst zu verifizieren.** Das „247:1"-Verhältnis sah nach Fehlalarm aus, war aber „der Patient braucht alle 10 min eine Wiederbelebung". Memory korrigiert: alte Notiz `reference_gitlab_runner_210_watchdog_false_positive.md` GELÖSCHT → neue `reference_gitlab_runner_210_silent_poll_stall.md`.

### #210-Ist-Stand + echte Wurzel-Kandidaten (offen, MIT User — OPNsense=kritisch)
- **Ist:** Watchdog v2 wieder `enabled`+`active`; CI funktioniert (langsam, über ~10-min-Zyklen). Runner-Admin: `ssh -i ~/.ssh/cluster root@10.0.10.211` (prod1=bash).
- **Wurzel-Fix-Kandidaten (erst DIAGNOSTIZIEREN — tcpdump prod1 + opn-1 — welche Schicht droppt, DANN fixen):**
  1. HAProxy `timeout tunnel 1h` für be-gitlab (opn-1, `/usr/local/etc/haproxy.conf`, mode tcp → 10.0.40.220:443) — lang gehaltene Long-Poll-Verbindung sauber halten. **OPNsense kritisch: nur via config.xml/os-haproxy + graceful reload (reboot-safe), NIE hand-edit als Quelle.**
  2. TCP-Keepalive runner↔gitlab (tote Sockets schnell erkennen → Retry statt Hang).
  3. conntrack/Firewall-Idle-Timeout auf dem prod1→gitlab-Pfad (FGT/OPN) prüfen/erhöhen.
  4. gitlab-runner 19.1.0→19.1.1 (#208 — evtl. bekannter Long-Poll-Bug).
  5. runner-`config.toml` request-/poll-Timeouts explizit setzen.
- Solange ungefixt: **Watchdog-Timer NICHT anfassen.** Erst der echte Fix erfüllt den User-Wunsch „ohne Watchdog".

---

## 4. 🔑 Architektur-Konsolidierung: CI-Verifikations-Landkarte (KRITISCH für #188)

**Welche Targets die CI wirklich kompiliert** (cache-engine `.gitlab-ci.yml` REV 10, `[baremetal]`, Linux-g++):
- `contract:conformance` → baut **`test_conformance_gate`** (plain main, reine lib-Header: composable_search.hpp + k_ary_traversal_organ.hpp + idriveable_tier.hpp + conformance_gate.hpp). ← **HIER landet C1/C2/C6 + jede lib-Header-Achsen-Arbeit, die test_conformance_gate inkludiert.**
- `contract` → `test_abi_interface` (NUR ABI-PODs: type_collection_traits/module_abi_v1/fingerprint/processing_strategy). **Inkludiert `abi_adapter.hpp` NICHT.**
- `contract:durability` → `test_config_durability`; `chaos:drift` → `test_chaos_drift_gate`; `sanitize:asan-ubsan`; `pmc:amd` → `linux_perf_pmc_smoke`.

**FOLGE (Kern-Erkenntnis):** `abi_adapter.hpp` + `observable_composed_search.hpp` + der ganze Anatomie-/Builder-Stack werden in **KEINEM** CI-Contract-Job kompiliert. Sie kompilieren nur im **thesis_tiere-Harness (Windows/cl, #162-gated)** + im schwereren `test_v41_anatomy_module_abi` (Linux, aber NICHT im Contract-Smoke wegen mimalloc-include-Bug + Gewicht). ⟹ **#230 (Harness-CI-Gap):** alles, was abi_adapter/Builder berührt, ist **Codex-verifiziert + harness-gated**, NICHT Linux-CI-compile-verifiziert.

**Praxis-Regel für #188-Folgeschritte:** Was sich in **lib-Headern** über `test_conformance_gate` (oder einen neuen standalone-Test) abbilden lässt → CI-grün machbar. Was `abi_adapter`/Builder berührt → Codex + harness (#162). Das bestimmt die C3-Aufteilung (§5).

---

## 5. #188-4a-C — Ist-Stand + execution-ready C3–C5-Plan

**Architektur-Entscheid (User, fix):** K (iterable_aspect ∈ {2,4,8,16}) ist eine **dynamische Subachse** = ein **SEPARATER iterable-Kanal**, GETRENNT vom Resource-Control-Kanal (`IResourceControllableTier`/`ComdareResourceControlV1`, das ist #221). State wohnt im **Container** (ComposedSearch), Organ bleibt **stateless** (reine Funktion von (Store, K)).

**Vorbild (exakt spiegeln):** `libs/cache_engine/anatomy/resource_controllable_tier.hpp` — standalone Sub-Interface, IMMER kompiliert (NICHT COMDARE_MEASUREMENT_ON-gegated), Host fragt via `dynamic_cast`, alt-DLL→nullptr→graceful (additiv, kein ABI-Bruch). `abi_adapter.hpp:144-145` erbt `IResourceControllableTier`; `:212-225` `tier_apply_resource_control` (clamp→applied_rc_); Dock `search_algorithm_dock.hpp:44` macht `dynamic_cast<IObservableTier*>`.

### C3 = der iterable-ABI-Kanal. Aufteilung nach Verifikations-Landkarte (§4):

**C3-Kern (CI-VERIFIZIERBAR über test_conformance_gate) — diesen Block ZUERST, committen, CI-grün:**
- **C3b — NEU `libs/cache_engine/anatomy/iterable_aspect_tier.hpp`** (Verbatim, war geerdet+reverted):
```cpp
#pragma once
// #188-4a-C — IIterableAspectTier: ABI-stabiler SEPARATER iterable-Aspekt-Kanal (k-ary K etc.), getrennt von
// IResourceControllableTier. Mirror von resource_controllable_tier.hpp: standalone, IMMER kompiliert, dynamic_cast,
// alt-DLL→nullptr→graceful (additiv). NIE bestehende Interfaces in-place ändern (SEH-0xc0000005-Lektion).
#include <cstdint>
namespace comdare::cache_engine::anatomy {
inline constexpr std::uint64_t kIterableAxisSearchAlgo = 0;   // 0 = search_algo (T0); erweiterbar
inline constexpr std::uint32_t kIterableAspectVersion  = 1;
class IIterableAspectTier {
public:
    virtual ~IIterableAspectTier() = default;
    // value (z.B. K) für die iterable-Achse axis_id setzen; true = real angenommen. noexcept.
    virtual bool tier_apply_iterable_aspect(std::uint64_t axis_id, std::uint64_t value) noexcept = 0;
};
}  // namespace
```
- **C3a — `observable_composed_search.hpp`** (Forwarder nach occupied_count(), Z.72; lookup delegiert ohnehin K-bewusst an search_):
```cpp
    void set_iterable_aspect(unsigned value)        noexcept { search_.set_iterable_aspect(value); }
    [[nodiscard]] unsigned iterable_aspect()  const noexcept { return search_.iterable_aspect(); }
```
- **C3e — `test_conformance_gate.cpp`**: `#include <anatomy/iterable_aspect_tier.hpp>`; eine Hülle `KAryIterableTier final : public anat::IDriveableTier, public anat::IIterableAspectTier` (5 IDriveable-Methoden über `ComposedSearch<KAryTraversal,RawSlotStore> s_` + `tier_apply_iterable_aspect(axis_id,value){ if(axis_id==kIterableAxisSearchAlgo){ s_.set_iterable_aspect((unsigned)value); return true;} return false; }`); Testblock (7): für K∈{2,4,8,16}: `anat::IDriveableTier* base=&t; auto* ich=dynamic_cast<anat::IIterableAspectTier*>(base);` (RTTI-Cross-Cast wie der Host) → `ich->tier_apply_iterable_aspect(0,K)` → `run_conformance_gate(t)` MUSS passed(). **Beweist Interface+Cross-Cast+Container-Forwarding end-to-end auf Linux-CI.**
  - ⚠️ **Anchor-Falle (mein Fehler diese Session):** der Edit „Hülle einfügen" muss auf TEXT anchoren, der WIRKLICH existiert (KAryComposedTier endet mit `cmp::ComposedSearch<…> s_;\n};\n\n}  // namespace`), NICHT auf die neue Methode. Sicherer: zwischen `};` (Ende KAryComposedTier) und `}  // namespace` einfügen.

**C3-Integration (HARNESS-GATED, #162 — Codex + harness, NICHT Linux-CI):**
- **C3c — `abi_adapter.hpp`:** `public IIterableAspectTier` in die Vererbungsliste (neben IResourceControllableTier, IMMER — nicht measurement-gated); `bool tier_apply_iterable_aspect(axis_id,value) noexcept override { if(axis_id==anat::kIterableAxisSearchAlgo){ container_.set_iterable_aspect((unsigned)value); return true; } return false; }`. `container_` = ObservableComposedSearch (hat nach C3a set_iterable_aspect).
- **C3d — Host-Cast:** im Builder/Dock `dynamic_cast<IIterableAspectTier*>` (1× kalt, wie obs3/rollback). Gehört zu C4 (der Loop nutzt ihn).

### C4 (HARNESS-GATED) — iterable-Laufzeit-Loop im Builder
- Analog `runtime_variable_loop.hpp` (RuntimeVariableLoop, der RC-Kanal über `tier_apply_resource_control`) ein **`IterableAspectLoop`**: iteriert die iterable_values einer Achse (aus Profil/XML, NICHT Runtime-Query) über die GELADENE Binary via `tier_apply_iterable_aspect`, ruft je Wert die Mess-Callback. = dynamische Subachse im Permutations-B+-Baum.
- `profile_to_tree`: K (k_ary.arity {2,4,8,16}) als EIGENE DynamicDim emittieren.

### C5 (HARNESS-GATED) — Weg-A-Aktivierung für k-ary
- Marker `axis_03a_store_traversable=true` (axis_03a_search_algo_k_ary.hpp) + `axis_03a_search_algo_registry.hpp:90-91` static_assert von `!StoreTraversableSearchAlgo` auf **positiv** drehen + `traversal_for_search_algo` route k_ary→KAryTraversal (schon da) + stale Kommentare. ⟹ container_ führt k-ary über DENSELBEN Store (Weg-A) statt search_organ_-Spiegel (Weg-B). Greift erst bei #215 (320-DLL-Neubau).

**Disziplin:** je Inkrement frischer Kontext, Codex vor „done", nie #188 halb committen, push beide Remotes.

---

## 6. ALLE offenen TODOs (nach Experiment-Ebene; Tasks-Liste = autoritativ, hier gruppiert)

**Ebenen-Schema (2 orthogonale Achsen):** A1-A3 ANATOMIE (Gattung/Unterklasse/Organe) ⟂ E1-E4 EXPERIMENT-Pipeline (E4 XML-Def+Auswertung · E3 Permutations-B+-Baum/Gattung · E2 Tier-Binaries/StaticAxisNode · E1 RC-Laufzeit/DynamicVariableNode · E0 Querschnitt/Schluss).

### E2 (Tier-Binaries — die #188-WURZEL-Strecke, höchste inhaltliche Prio)
- **#188** ARCHITEKTURFIX T0-Such-Delegation. **4a-Organ + 4a-C(C1/C2/C6) CI-grün DONE.** Offen: C3-Kern (CI) → C3c/C4/C5 (harness) → **4b** (Pool-Familie store-traversierbar) → **4c** (`search_organ_` ENTFERNEN, alle Familien über container_) → #215 (320-DLL-Neubau) → #156/#162.
- **#215** CoW real für 320 aktivieren (cowfix-v1 320-DLL-Neubau) — Wirksamkeits-Schleuse.
- **#216** seg_ns n>1 für 320 (CoW-Key-Ernte) + stat_*-Reset NACH Load.
- **#211** container_ → LinearScan/Append (O(n)-flatten/rebuild je Mess-Op raus).
- **#217** Array-Gattung-Achse (Container-Metaprog-Rekursion, KEIN uint16→uint64).
- **#19** Allokatoren echt linken (jemalloc/tcmalloc/hoard/scalloc) Voll-Präzision.
- **#163** SIMD/ISA + Allokator als variierte Achsen + ≥2 Plattformen.
- **#125** P6 lazy DLL-Bibliothek: inhalts-abgeleitete per-Tier-Versionierung.
- **#185** TPIE + EM-BFS als I/O-Dispatch-Achsen. **#224** GoF-Etiketten-Hygiene.

### E1 (RC-Laufzeit / DynamicVariableNode)
- **#221** RC Null-Object → DynamicVariableNode VOLLENDEN (User: Vollendung). = der RC-Kanal (parallel zum iterable-Kanal C3; gleiches Muster, separate Kanäle). Nach #188.
- **#225** Grundsatz-Klärung Second-Execution vs Zwei-Phasen-Pflicht (NUR Diskussion, USER).

### E4 (XML-Def + Auswertung)
- **#156** M3-Neumessung (HELD bis Linux+PMC) — EIN Gesamt-Lauf. **#162** PRT-ART + ≥8 Rang-1-SOTA + Reihen A/B/C (GROSS, in_progress).
- **#152** Cache-Misses=0 (PMC anbinden). **#187** PMC-Auto-Adaption. **#165** quality_flag/winsorisiert/Perzentil (code-complete; Rest=quiesziertes OS, #156-gated).
- **#184** Dataset-Loader Nicht-YCSB. **#230** thesis_tiere-Harness in CI compile-gaten (schließt §4-Lücke!).

### E0 (Querschnitt/Infra/Schluss — niedrige inhaltl. Prio, aber #210/#193 akut)
- **#210** (s. §3 — Watchdog-Mitigation aktiv, echte Wurzel offen). **#193** Lösung manuell bedienbar (TOP-PRIO User). **#186** CI/CD-EPIC (Stufen 5/6/7 grün; #199-#205 offen: k8s-deploy/staging/canary/NAS-Writeback/lint-hart/sanitize-hart/thesis-latex).
- **#208** Runner-Upgrade 19.1.1 (relevant für #210!). **#207** prod2-I/O→pmc:intel. **#209** MinIO-S3-SecretKey rotieren. **#228** git sslverify=false→ROOTCA. **#189** Infra-Handoff universelle Runner. **#179** Wartbarkeits-Sweep (GROSS). **#149/#229** Meta-Strecke.
- **MEMORY.md-Kompaktierung** (Hook-geflaggt 20.4 KB / Limit 24.4 KB): bewusst-sorgfältiger eigener Pass (Pointer-Verlust-Risiko), NICHT hastig.

---

## 7. Fallstricke (diese Session + stehend)

- **#210-Watchdog: NICHT abschalten** (s. §3). Der Runner verstummt real; der Timer ist die Mitigation.
- **§4 CI-Verifikations-Landkarte:** abi_adapter/Builder sind NICHT Linux-CI-kompiliert. Keine „CI-grün"-Behauptung für abi_adapter-Code ohne harness/#162 oder einen neuen standalone-lib-Test.
- **opn-1 = csh** (`root@10.0.10.11`): POSIX-Skripte als `ssh … sh -s <<'EOF' … EOF` pipen; `2>/dev/null`/`2>&1` brechen direkt in csh („Ambiguous output redirect"). prod1 (`10.0.10.211`) = bash (normal).
- **GitLab-PAT:** lebenden ermitteln (`grep -oE 'glpat-[A-Za-z0-9._-]{20,}' Vault` → /user==200; Format MIT Punkten). curl: `--cacert <ROOTCA> --ssl-no-revoke` (NIE --insecure). Projekt-ID 286.
- **Edit-Anchor-Falle:** old_string MUSS literal existieren (mein C3e-Fehler: ich anchorte auf die noch-nicht-existierende Methode). Bei „einfügen" auf vorhandenen Rand anchoren.
- **#188 nie halb committen** · je Inkrement frischer Kontext · Codex (`mcp__codex__codex`) vor „done", NUR Code-Repos (cache-engine/prt-art/super/thesis), NIE Cluster/keys. · NUR MERGE kein REBASE · push beide Remotes (origin=GitHub + gitlab) · super: nur cache-engine-Submodul + eigene Dateien stagen, NIE thesis-Submodul. · Verifikation NUR auf Pipeline (kein lokaler Compiler). · Keine Erfolgsmarke ohne literale Tool-Ausgabe.

---

## 8. Offene Entscheidungen für die nächste Session (Rückfragen — s. Chat)

1. **#210-Priorität:** echte Wurzel jetzt diagnostizieren+fixen (tcpdump + HAProxy timeout tunnel / runner-Upgrade #208 — MIT User, OPNsense kritisch) ODER mit Watchdog-Mitigation weiterleben + zurück zu #188-C3?
2. **#188-C3-Sequenz:** C3-Kern (CI-verifizierbar: Interface+Forwarder+Test) als eigenen Commit ZUERST, dann C3c/C4/C5 harness-gated — ODER ganz C3-C5 als ein harness-gated Block?
3. **#230 vorziehen?** thesis_tiere-Harness in CI compile-gaten würde C3c/C4/C5 + alle künftige abi_adapter-Arbeit CI-verifizierbar machen (schließt §4-Lücke dauerhaft) — lohnt der Vorzug vor C3c?

**Antworten (vom User, 2026-06-29):**
- **(1) → „#188-C3 weiter".** Nächste Session: Watchdog-Mitigation behalten (CI läuft, #210-Wurzel NICHT-Notfall), den **iterable-Kanal C3-Kern** bauen (IIterableAspectTier-Interface + ObservableComposedSearch-Forwarder + test_conformance_gate-Block, Verbatim-Code §5) → CI-verifizierbar (`contract:conformance`) → committen/pushen → DANN C3c/C4/C5 (abi_adapter-Adoption + IterableAspectLoop/profile_to_tree + Marker/Registry-Flip) harness-gated (#162) mit Codex.
- **(2) impliziert:** C3-Kern (CI-verifizierbar) ZUERST als eigener Commit, Rest harness — wie empfohlen.
- **(3) impliziert:** #230 (Harness-in-CI) NICHT vorgezogen; #210-Wurzel-Fix später (mit User, OPNsense kritisch). Watchdog-Timer bis dahin AN lassen.
- **START-HIER nächste Session:** §5 „C3-Kern" — Verbatim-Code ist reproduzierbar (pristine 7fdb179). Achte auf die Edit-Anchor-Falle (§7).
