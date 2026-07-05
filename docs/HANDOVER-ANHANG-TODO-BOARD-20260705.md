# Handover-Anhang: vollständiger TODO-Board-Snapshot (Stand 2026-07-05, Goal gestoppt)
Exakte Wiedergabe der user-sichtbaren Task-Liste der Impl-Agent-Sessions. Autoritative Definitionen der offenen Punkte = Ledger §13.3/§13.9/§13.10; dieses Board ist die Verlaufs-/Statusansicht. Für die 275 Einträge gilt: `[completed]` = erledigt+belegt; `[pending]`/`[in_progress]` = offen, den Hauptsträngen A–G des Handovers zugeordnet; `[E0]–[E4]` = historische Eskalations-/Gate-Marker.

## Offene Punkte (pending / in_progress) — der Arbeitsvorrat der Abteilung
- #10 [pending][E0] V42 + Infrastruktur (niedrige Prio: #648-#653, #613, #619, #621, #622)
- #19 [pending][E2] V41.A1/A2.1: Allokatoren echt linken (jemalloc/tcmalloc/hoard/scalloc) mit Voll-Präzision
- #24 [pending][E0] V41.C1/C2: Cluster-Tasks (BLOCKIERT bis Termin/extern)
- #25 [pending][E4] V41.D1/D2: Diplomarbeit-Text + Bausteine-Matrix-Doku (User schreibt manuell)
- #125 [pending][E2] P6 lazy DLL-Bibliothek: inhalts-abgeleitete per-Tier-Versionierung (Content-Hash-Codegen)
- #149 [in_progress][E0] MP-E: Original-Mission neu planen + EINE Aufgabe pro Session gegen Audit abarbeiten (Meta)
- #152 [pending][E4] L-h: Cache-Misses (Kernmetrik) = 0 — PMC nicht angebunden + fehlen in M3-WIDE
- #156 [pending][E4] M3-Neumessung (HELD bis Linux+PMC) — EIN umfassender Lauf — GESAMT-LAUF (→ Strang G)
- #162 [in_progress][E4] P-MD6: PRT-ART + ≥8 Rang-1-SOTA-Lebewesen + Messreihen A/B/C (→ Strang C/G)
- #163 [pending][E2] P-MD5: SIMD/ISA + Allokator als variierte Achsen + ≥2 Plattformen
- #165 [pending][E4] P-MD2/8/9: Residual quiesziertes Experiment-OS, gated mit #156
- #179 [in_progress][E0] B1: Wartbarkeits-/Lesbarkeits-Sweep ALLER C++-Dateien aller 4 Projekte
- #184 [pending][E4] AP-CE2: Dataset-Loader-Slot — Verdrahtungs-Rest = Voraussetzung für #269 (→ Strang D)
- #185 [pending][E2] io-tpie: TPIE + EM-BFS als I/O-Dispatch-Achsen-Algorithmen
- #186 [in_progress][E0] EPIC P1: 4-Modul-CI/CD-Pipelines + 10-Stufen-Prinzip (→ Strang A)
- #187 [pending][E4] PMC-Auto-Adaption
- #188 [in_progress][E2] ARCHITEKTURFIX T0-Such-Delegation (Rest = S7-Serie + 234-V, → Strang B)
- #189 [pending][E0] Infra-Handoff universelle Runner (→ Strang F)
- #199–#202 [pending][E0] Pipeline P0: k8s-deploy · deploy-staging · smoke-canary · NAS-Writeback/Release/PDF
- #204 [pending][E0] sanitize-Stufe HART + matrix-weit (→ Strang A/#264)
- #205 [pending][E0] thesis chktex/latexmk Hard-Gate (texlive = Infra, → Strang F)
- #207 [pending][E0] prod2-I/O-Fix → pmc:intel reaktivieren (Infra, User-Go)
- #208 [pending][E0] Runner-Upgrade 19.1.1 + auto-cancel safe AN (Infra)
- #209 [pending][E0] MinIO gitlab-runner-cache S3-SecretKey rotieren (Infra)
- #210 [in_progress][E0] Runner idle Long-Poll-Stall (Infra-Wurzel, → Strang F)
- #215 [pending][E2] CoW real für die 320 (WIRKSAMKEITS-SCHLEUSE, → Strang G Vorstufe)
- #216 [pending][E2] seg_ns n>1 für die 320 + stat-Reset nach Load (→ Strang G Vorstufe)
- #217 [in_progress][E2] Array-Gattung-Achse (GEKLÄRT, Umsetzung offen)
- #225 [pending][E1] AUDIT-A5 Grundsatz-Klärung Second-Execution (NUR Diskussion, USER)
- #226 [pending][E4] AUDIT-LIMIT Appendix-Limitierungen (ENDeinfrierung M3-gated)
- #229 [pending][E0] META Top-Down-Audit + DynamicVariableNode/RC XML-only (Strecke)
- #231 [pending][E0] V111→gitlab .1-SNI (Infra macht, dann Verifikation)
- #234 [in_progress] #188-4b-c/D: Node-Shape-Achse + Pool-Store + observe-Hooks (= S7-Serie, → Strang B)
- #236 [pending] AP-2 UMDEFINIERT: PRT-ART-Mess-Echtheit via Stub-Quarantäne (→ Strang C; Definition Ledger §13.10)
- #241 [in_progress] AP-7-Rest: 7b-3 SIMD in isa-Achse + swiss_probe_shape (→ Strang C)
- #244 [in_progress] AP-10: 5 fehlende Akten + Bestands-XML-Erweiterung + Sidecars (→ Strang D)
- #246 [pending] AP-12: Fairness-Harness (setzt AP-2 voraus)
- #248 [pending] AP-14: Achsen-Sensitivität (NACH #215/#156)
- #249 [pending] AP-15-Rest: 15-2 get_allocator + 15-3 DriveableMapContract-CRTP (→ Strang C)
- #251 [pending] CMD-1: compile-time-Mess-Visitor, ABI-neutral (→ Strang C, E-B)
- #252 [pending] CMD-2: ContainerObserver real (EINZIGER ABI-Bump-Kandidat, nur nach #268 + User-Freigabe)
- #256 [pending] MODUL-EXTRAKT in Matrix-Module (NACH #274; nur aus libs/, → Strang E)
- #257 [in_progress] CI-Grün-Rest: lint:format DONE/CI-grün; Rest = mimalloc-Include-Fix + Endstatus (→ Strang A)
- #258 [pending] Pipeline-Nachprüfung: 7963/7965/7974 ausstehend; mimalloc-Befund = erster Fix (→ Strang A)
- #261 [in_progress] S7-Serie: S7-1 DONE; S7-2..10 + 234-V offen (→ Strang B; Definition §13.10)
- #263 [in_progress] AP-15: T1 (17-Dagger-Gate) DONE `c4eb7d7f`; Rest 15-2/15-3 (→ Strang C)
- #264 [pending] #186-CI-Ausbau: CI-2/4/5 + #204 (→ Strang A)
- #265 [pending] Reuse P2: comdare-foundation SIMD/platform vendorn (E-A)
- #266 [pending] Reuse P1 config, dann P3 memory (E-A; config-Owner = comdare-config-all per A2)
- #267 [pending] CMD-1-Umsetzung (E-B)
- #268 [pending] CMD-2-Reserve-Prüfung axis_stats[0][6..7] (KEIN Bump ohne User-Freigabe)
- #269 [pending] AP-10-Datensatz-Registrierung: 8er aus Thesis-tab:datasets ∪ Bestand (Definition §13.10, → Strang D)
- #270 [pending] AP-13-Rest: P/E-Auto + 3-ISA-Matrix (nach #265)
- #271 [pending] perm_runner-CMake-Fix (NUR wenn Datei nicht mehr user-dirty)
- #272 [pending] Infra-Handover-Paket HO-1..HO-12 (inkl. NEU: HO-11 gcc-15.3, HO-12 clang; → Strang F)
- #273 [pending] CI-Toolchain: T1 DEPLOYED (`b919bc8` + super-Rollout + stage-Fix `934b606`); T2 = gcc-15.3-Pin nach toolchain:probe-Ergebnis (→ Strang A)
- #274 [pending] Matrix-Migration OHNE Löschen: buildsystem-Fraktion + comdare-measurement-all (User A1/A5/A6/A7, → Strang E)

## Erledigte Punkte (completed) — Kurzform, Belege in Ledger §12 + Commits
#1–#9 (axis_filter/PAPER_REFERENCES/R7.2–R8/Cross-Constraints) · #11–#18 (V41.F/E-Serie: prt-art-Migration, Namespace-Restrukturierung, Concepts, Facades, STATIC/SHARED, Achsen-Iteration) · #20–#23 (SIMD/Layout-Achse, YCSB echt, Submodule-Repos, Build-Stabilität) · #26–#48 (CEB-CLI/ABI/dlopen, Goldstandard, Achsen-Anlagen, Umstufung A/B, OriginalXxx-Sektion, V5-I6–I10 memento/Zwei-Phasen/Orchestrator/E2E) · #49–#66 (YCSB-Treue, Mess-POD V1, KF-1–KF-16: XML-DOM, Schema, Cache-Line, RC, B+-Baum, SLURM/ZIH, Inverse Auswertung, Teilbaum-Iterator) · #67–#77 (BR-1–BR-4 Registry→Baum→Komposition→Anatomie, OBS-22, provision_all, GATE-4, Gattungs-Bindungen, ceb_generator) · #78–#96 (Goal-V6 B/C, V42-Sprint, Genus-Docks/DLL-Roundtrip, Allokator-Gap, E2E-Messung, Adapter-Neudefinition, queuing q1/q2, Terminologie-Migration, Doku-Sweeps, Treiber+Pilot ≥150) · #97–#119 (Wall-Clock/Segment-Timer/Reset/Wiederholung/CSV; Phase A+B Observer-Vollausbau T1–T18; Defekte 1+2; Verifikation) · #121–#124, #126–#148, #150–#151, #153–#155, #157–#161, #164, #166–#178, #180–#183, #190–#198, #203, #206, #211–#214, #218–#224, #227–#228, #230, #232–#233, #235, #237–#240, #242–#243, #245, #250, #253–#255, #259–#260, #262, #275 (Details: Ledger §12-Chronik; jüngste Session: S7-1 `ec1ffb34`, AP-7b `a4e7c59f`+`c9a7e44e`, AP-15-1 `c4eb7d7f`, #273-T1 `b919bc8`, W1–W5 `wf_f6200eba`).
