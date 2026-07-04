# SESSION-ENDE 24 (2026-07-04) — /goal „Ledger-TODOs bis alles erledigt": 6 verifizierte Increments (#193-A/C/D, CI-2, S2/#217-2a, S3/AP-7a, AP-3) + AP-5 in-flight

> **EINSTIEG NÄCHSTE SESSION (Reihenfolge):** (1) **Single-Source = `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`**
> — §0 GOAL + §3 Spur-S + §5 Spur-P + §11 TODO-Liste + §12 Fortschreibungs-Log (alle 6 Increments dieser Session
> dort DONE-dokumentiert). Schlägt bei Widerspruch alle Session-Docs. (2) DIESES Doc = Session-24-Deltas +
> **7 NEUE Fallstricke** + der bewährte /goal-Zyklus. (3) SE-23 (Vorsession). **/goal steht auf: „lies das Ledger und
> bearbeite solange TODOs in optimaler strategischer Reihenfolge, bis alles erledigt ist; Codex implementiert aus
> SEHR elaboratem Dossier, Claude kontrolliert die Files danach manuell."**

## §0 SOFORT-STATUS (nächster konkreter Schritt)
**AP-5/#239 (Full-Sampled-Modus) — KARTIERUNG IN FLIGHT beim Kontext-Ende.** Zwei read-only-Agenten liefen noch:
Explore + Codex (`scratchpad/ap5_kartierung.txt` = Auftrag). Codex-Report → `scratchpad/ap5_codex_karte.txt`
(GROSS, ~9k Zeilen mit Orchestrator-Rauschen → **grep die Anker, nicht ganz lesen**). Explore-Report kommt per
task-notification ( evtl. über Session-Grenze verloren → dann Kartierung neu starten). **Dossier-Gerüst steht:
`scratchpad/ap5_dossier.md`** (fixe Auflagen gefüllt, §5/§6 = Platzhalter). **NÄCHSTE HANDLUNG:** (a) prüfen ob die
2 AP-5-Kartierungen fertig sind (Output-Dateien existieren) → Mappings abgleichen → Dossier §5/§6 file:line füllen
(keep-Prädikat aus dem **existierenden Permutations-Fingerprint** + Seed, `splitmix64(fp XOR seed) % 1000 == 0`) →
Impl-Codex → manuelle Kontrolle → Compile + Determinismus-Test → Commit/Push. Falls Kartierung verloren: neu starten.

## §1 DIESE SESSION GELEISTET — 6 verifizierte Increments (alle beide Remotes, alle test-belegt)
| # | Increment | Verifikation (literal) | cache-engine · super |
|---|-----------|------------------------|----------------------|
| 1 | **#193-A** SOTA-Profil-Resolver (`experiment_driver.cpp`, CWD-unabh. + `libs/`-korrekt) | MSVC EXIT 0 + Codex SHIP | `a0b514c` · `c603c47` |
| 2 | **#193-C/D** `-h/--help` + `MANUAL_RUN.md` + Demo-Preset | Build 0 · `--help` 0 · `--enumerate-only` „OK" 0 · Codex SHIP | `d4641a3` · `4ac3441` |
| 3 | **CI-2** `contract:experiment_driver`-Gate (schließt #193-A-CI-Lücke + /fork) | `test_experiment_driver_v13` PASSED · YAML OK | `1b27608` · `839b0de` |
| 4 | **S2/#217-2a** generische Container-Kapazitäts-Constraint (ABI-neutral) | manuelle Kontrolle · **3/3 Tests** · MAJOR 4 · Codex SHIP | `d28108f6` · `c7c843e` |
| 5 | **S3/AP-7a** SwissTable S22 (faithful, golden-neutral OFF-Reg) | manuelle Kontrolle · **2/2 Tests** · First-4 byte-identisch | `75071224` · `bb4ad13` |
| 6 | **AP-3/#237** IPlatformProbe CPUID + HardwareFilter/Phase-1 (ABI-neutral) | manuelle Kontrolle · **1/1 + 3/3 Tests** · Host-Smoke real | `dd1079ff` · `7d6fd4d` |

**#193 (TOP-PRIO) KERN abgeschlossen** (A/B/C/D) → User-Self-Test entsperrt. Jeder Increment: Kartierung
(Explore+Codex, gegengeprüft) → elaborates Dossier → Codex-Impl → **jede Datei manuell kontrolliert** (kein Surrogat)
→ eigene Compile+Test-Verifikation → Commit+Push+Super-Bump+Ledger §12.

## §2 ARCHITEKTURKONSOLIDIERUNGEN / ENTSCHEIDUNGEN (diese Session, bindend)
- **#217-2a KORREKTUR (verifiziert am Quellcode):** KEINE aktive `uint16→uint64`-Trunkierung mehr — `search_organ_`-
  Pfad via #188-4c-iii entfernt, `tier_insert`→`container_algorithm_` uint64-sauber. Reale Unehrlichkeit = `max_fanout`
  wird NIRGENDS erzwungen. → **generische `CapacityConstraint`/`CapacityKind{Advisory,Static}`** (`capacity_constraint.hpp`),
  Guard NUR für Static (Array256/65535), zero-cost für Advisory. **Abgrenzung:** verallgemeinert `max_fanout`, NICHT
  node-`max_capacity()` (orthogonal). **#217-2b** (native Wrapper-Breite + `same_as<uint64>`-Lockerung) deferred (#188/#234).
- **AP-7a golden-Neutralität VERIFIZIERT (registry.hpp:73-83):** neuer Baustein permutierbar = zwingend End-Append an
  `AllStrategies` in `axis_03a_search_algo_registry.hpp` — ABER golden-neutral bei **End-Append + Default-OFF-Flag**
  (`EnabledStrategies=mp_filter<is_enabled>` filtert OFF raus → `mp_take_c<…,4>` byte-identisch), **exakt S18–S21-per-K-
  Präzedenz**. „Registry-TABU" = die POPULATION (First-4/aktivierte), NICHT die additive Trägerliste. **AP-7a/AP-7b-Split:**
  7a = faithful Wrapper + Konformität + OFF-Reg („registriert, baut nichts"); **7b = Weg-B `SwissTableOrgan` +
  `organ_for_search_algo`-Eintrag für den ECHTEN Mess-Pfad** (sonst SortedBinary-Fallback = unehrlich; Flag bleibt OFF bis 7b).
- **AP-3 Muster:** IPlatformProbe = host-seitig (ABI-neutral). Brücke `CpuidPlatformProbe : IPlatformProbe`
  (`cpuid_platform_probe.hpp`) mappt `probe_cpuid()`→`PlatformPropertySet`; **`measured_metrics`-Map = der feature.*-Kanal**
  (Brücke füllt sse42/neon/sve2, `auto_permutator` liest sie). **AP-13-Grenze:** `platform/core_layout.hpp` = AP-13, NUR
  includieren; Topologie/Pinning-Felder (`has_hybrid_cores`/`cpu_core_atom_perf_separation`/`preferred_pinning_policy`)
  bewusst ungesetzt (test-erzwungen).

## §3 ZU MARKIERENDE DEGENERATIONEN (offen)
- **codegen.cpp:70/100/210** — dieselbe `libs/`-fehlt-Fehlklasse wie #193-A (Include-Pfad + stiller Skelett-Template-
  Fallback statt SOTA-Body-Template). Echte Verifikation erst bei Modul-Neugenerierung → **an #215/320-DLL-Neubau gekoppelt.**
- **best_binary_selector.hpp** dupliziert ABI-Konstanten (`kAbiMajor`/`kAbiMagic`) aus `anatomy_module_abi_v1_decl.hpp`
  (DRY-Verletzung, bei jedem ABI-Bump doppelt) → Auflösung #179/S9-Nähe.
- **AP-7b** (SwissTable Weg-B-Organ) — bis dahin misst S22 im Mess-Pfad NICHT echt (Flag OFF hält es sicher). **Mess-Blocker
  für SwissTable-Reihen.**
- **AP-7a-Nits** (nicht-blockierend): `swisstable.hpp` `operator==` size-basiert (semantisch schwach); `density_percent`
  hardcodet 65536 (wie S14). Bei Gelegenheit glätten.
- **Mapping-Observer-Narrow-Cast** `slot_index_type=uint16` (`abi_adapter.hpp:762/831`, `#217-2a`-geflaggt) — Observer-
  Seitenpfad, separater Follow-up.
- **CI-Lücke** (teilweise via CI-2 geschlossen): experiment_driver jetzt CI-gebaut; ABER die meisten neuen Tests
  (test_217_2a/test_ap7_swisstable/test_cpuid_probe/test_commands) laufen in KEINEM CI-Gate → CI-2 (Sammel-Target) offen.
- Masstree keys={0}, Hüllen-honest-0 (#234), cow_capable_-Kipp (#215) — unverändert offen (SE-22 §6).

## §4 NEUE FALLSTRICKE (Session 24 — bindend, kosteten diese Session Zeit)
- **F-H git Auto-`gc` bricht/verzögert Push:** der #217-2a-super-Commit lief 2 min in Timeout, weil git „Auto packing the
  repository in background" während commit+push auslöste. → Commit von Push **trennen**; Push großzügiger Timeout (300s);
  nach Timeout `git log`/`rev-parse` prüfen (Commit kann durch sein, nur Push offen).
- **F-I `grep -v` in `&&`-Kette VOR Commit = Kette bricht:** der AP-7a-Commit wurde ÜBERSPRUNGEN, weil ein
  `git status --short | grep -vE '…'` NICHTS fand → **grep exit 1** → `&&`-Kette stoppte vor `git commit`. **NIE grep in die
  Commit-`&&`-Kette** setzen; Staged-Kontrolle separat oder mit `;`. (Staging war ok, nur Commit fehlte → separat committen.)
- **F-J Codex/OneDrive-Junk-Artefakte:** `__write_probe.tmp` (AP-7a) + `$null` (AP-3) = 0-Byte-Dateien aus fehlgeschlagenen
  apply_patch-Writes / PowerShell-Redirects; OneDrive blockt Delete WÄHREND des Codex-Laufs. → nach JEDEM Codex-Impl
  `git status` auf `?? *.tmp`/`?? $null` prüfen + `rm -f '$null'` (single-quote!) VOR dem Stagen. (Gezieltes Stagen schützt
  vor Commit, aber Junk entfernen.)
- **F-K neuer ctest-Target nicht auto-registriert:** `test_commands` matchte `ctest -R '^test_commands$'` NICHT (unter
  anderem ctest-Namen / anderes test-dir). → wenn ctest den Test nicht findet, die `.exe` direkt laufen
  (`build/…/Release/test_commands.exe --gtest_filter=…`).
- **F-L Codex-Plugin-Flag leakt:** `plugins."workflow-orchestrator@barkain-plugins".enabled=false` unterdrückt den
  Orchestrator NICHT vollständig (Kartierungs-Codex spawnte Sub-Agenten + Timeout-Rauschen, lieferte aber). → im Prompt
  explizit „**Arbeite DIREKT als EIN Agent — KEINE Sub-Agenten/collab-Route**". Bei workspace-write-Impl klappte das sauber.
- **F-M Flag-Test-Reconfigure zurückstellen:** AP-7a-Verifikation brauchte `-DENABLE_SWISSTABLE=ON`-Reconfigure; DANACH
  `-D…=OFF` zurück (sonst läuft die nächste lokale Verifikation im Nicht-golden-Zustand). Gilt für jedes opt-in-Flag.
- **F-N (bekräftigt) gitlab-Push F7-slow:** origin immer foreground, gitlab isoliert `run_in_background:true`, NIE im selben
  Call wie grep/API. (Diese Session durchgängig sauber.)

## §5 DER BEWÄHRTE /goal-ZYKLUS (pro Increment — genau so weiterführen)
1. **Kartierung** parallel: Explore-Agent (bg) + Codex read-only (bg), EXAKT dieselbe 7-8-Punkte-Aufgabe (Gegenprüfung,
   Direktive). 2. **Load-bearing Behauptungen SELBST verifizieren** (1-3 gezielte Reads am Quellcode — z.B. golden-Neutralität
   an `registry.hpp`, Organ-Mechanik). 3. **Elaborates Dossier** (Gerüst-Vorlage: §1 Auftrag, §2 Substanz, §3 Scope IN/OUT,
   §4 HARTE Auflagen [ABI-neutral MAJOR 4, TABU, faithful-kein-Surrogat, Concept, Stil], §5 Kartierung file:line, §6 Soll
   konkret, §7 Verifikation, §8 Report). 4. **Impl-Codex** im Haupt-Tree: `codex exec "IMPLEMENTIERUNGS-AUFTRAG … arbeite
   DIREKT, keine Sub-Agenten, keine git-Ops … =DOSSIER= $(cat …)" --sandbox workspace-write -c 'model_reasoning_effort="xhigh"'
   -c 'plugins."workflow-orchestrator@barkain-plugins".enabled=false'` (bg). 5. **Manuelle File-Kontrolle** JEDER Datei
   (`git diff` + neue Dateien lesen): faithful/kein-Surrogat? Concept erfüllt? ABI-neutral (keine abi/extern-C/POD/modules)?
   TABU/golden gewahrt? Test verstärkt statt geschwächt? Junk entfernt? 6. **Eigene Compile + Tests** (MSVC-Release, literal
   PASS). 7. **Commit gezielt** (`git add <exakte Pfade>`, NIE `git add -A`) + Push origin foreground + gitlab bg. 8. **Super-
   Bump** (`git add Code/external/comdare-cache-engine docs/…-LEDGER.md`, NIE thesis-Submodul/.claude) + **Ledger §12 DONE-Eintrag**.

## §6 DIREKTIVEN (unverändert + Session-24-Bekräftigung)
**ABI-FREEZE:** MAJOR **4**, GENAU EIN weiterer Bump 4→5 bei **S5/S6** (CMD-1+CMD-2+AP-1-POD+AP-8-POD), konsumiert vom
EINEN 320-DLL-Neubau **S8/#215**. **KEIN Zwischen-Bump.** → **ALLE ABI-neutralen Increments ZUERST** (deshalb die Reihenfolge
#217-2a/AP-7a/AP-3/AP-5…). **golden-320:** NIE die EnabledStrategies/First-4/mp_list-POPULATION mutieren; additiv End-Append +
OFF-Flag ist sanktioniert. **TABU:** `modules/**`, `ext/**`, golden-/Registry-`mp_list`, AP-13-Dateien (`core_layout.hpp`/
Pinning). **Regelmäßig commit+push beide Remotes je Increment.** Codex NUR Code-Repos (cache-engine/prt-art/super/thesis),
NIE Cluster/keys. Verify NUR Pipeline/eigener Build, keine Erfolgsmarke ohne literale Ausgabe. NIE `git add -A`. `.py`-Scratch
→ `.txt`. Windows-python braucht `C:/`-Pfade. AskUserQuestion NIE (Klartext). Bei NEUER echter Architektur-Entscheidung anhalten.

## §7 OFFENE TODO-LISTE → VOLL im Ledger §11/§3/§5
**Spur S (seriell):** S1✅ · S2/#217-2a✅ · **S3/AP-7a✅** (AP-7b offen) · S4 #221 (RC — erst Vertrags-Freeze) · **S5 CMD-1
(START Bump 4→5)** · S6 CMD-2+AP-1+AP-8 (schließt 4→5) · S7 #234 · S8 #215 (320-DLL-Neubau) · S9 #224.
**Mess-Gate P0 (Spur P, ABI-neutral, dateidisjunkt — NÄCHSTE KANDIDATEN):** **AP-5/#239 (in-flight)** · AP-4/#238 (Stufe-3-
Full-Join/Reihe B) · AP-6/#240 (33 SOTA+23 Allok-XML) · **AP-2/#236 (HARTES GATE, blockt #162/#156 — prüfen ob AP-1-POD-
abhängig)**. **P1:** AP-8/9/10/11/12/13/14/15. **gated/extern:** #156/#152/#162/#163/#165/#187 (Mess) · #189/#199-210 (Infra) ·
#215/#216 · #229/#221 (RC-Strecke). **AP-3-Follow:** Linux-sysfs L1/L2/L3, ARM/NEON/SVE-Vollprobe.

## §8 RÜCKFRAGEN (User erlaubt — als erste Instanz)
1. **Tempo/Parallelität:** Diese Session lief seriell-vorsichtig (ein Increment nach dem anderen, je voll verifiziert). Die
   ABI-neutralen M3-Gate-Bausteine (AP-4/AP-5/AP-6/AP-9-15) sind **dateidisjunkt** und könnten als **mehrere parallele Codex-
   Läufe** (bis 16) gleichzeitig laufen — schneller, aber mehr gleichzeitige manuelle Kontrolle. Soll die nächste Session
   voll-parallel starten, oder weiter seriell-vorsichtig (höhere Kontroll-Tiefe je Increment)?
2. **AP-2-Hard-Gate vs. ABI-neutrale Breite:** AP-2/#236 (PRT-ART-Echtpfad) ist das HARTE Gate, das #162/#156 (FF3-Messung)
   blockt — aber evtl. AP-1-POD-abhängig (= Teil des EINEN 4→5-Bumps). Soll ich AP-2 als nächstes priorisieren (Kartierung
   klärt die AP-1-Abhängigkeit), oder erst ALLE übrigen ABI-neutralen Bausteine räumen und dann den EINEN Bump (S5/S6) + AP-2 bündeln?
3. **AP-7b jetzt oder gebündelt:** SwissTable misst erst mit dem Weg-B-Organ (AP-7b) echt. Soll AP-7b zeitnah nachgezogen
   werden (S22 wird dann messbar-scharf), oder mit #234 (Node-Shape/Pool-Organ-Stufe) gebündelt, weil beide dieselbe
   organ_for_search_algo-Maschinerie berühren?

**Ohne Gegenwort** setze ich AP-5 fort (Kartierung abgleichen → Dossier → Codex → Kontrolle → Test → Commit), dann seriell
weiter durch die ABI-neutralen M3-Gate-Bausteine, bis der EINE Bump (S5/S6) ansteht. Du kannst jetzt kompaktieren.
