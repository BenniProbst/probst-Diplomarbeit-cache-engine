# SESSION-ÜBERGABE 32 — Opus-4.8-Goal-V3-Strecke: 234-V-b + Migration 5/6/7 + #29/#27 (2026-07-08)

**Agent:** Diplomarbeits-IMPL-Agent (comdare@prod1, Opus 4.8 / max effort). **Abschluss-Grund:** User „Der Kontext endet jetzt".
**Aktives Goal (Stop-Hook):** „Bitte erledige alle sichtbaren TODOs und den Goal-Text V3 im Ledger. Beachte besonders die Direktiven zur Striktheit der Organisationsform der Programmierumgebung, der Modulreferenzierung und der Metaprogrammierung. Stelle zu jeder Zeit sicher, dass alle Memories geladen und alle Direktiven klar sind."

> **PFLICHT-EINSTIEG NÄCHSTER ZYKLUS:** (1) ALLE Memories laden (76 Dateien, `~/.claude/projects/-home-comdare/memory/`, Backup `~/.claude/memory-backups/20260708/`); insb. NEU `feedback_goal_hook_thorough_read_in_never_guess` (bei JEDEM Hook gründlich einlesen, nie raten). (2) Ledger §12 neueste Einträge (08.07.) + §13.12 Goal-V3. (3) DIESES Dokument. (4) Task-Board = Arbeitsvorrat.

---

## 1. IN-FLIGHT — HIER SOFORT ANKNÜPFEN
- **#27 CI-Verifikation:** ce `9f60216f` (main+development) + super `94695b2` gepusht; CI beim Kontext-Ende IN-FLIGHT. Ausgang prüfen (`/projects/286/pipelines?sha=9f60216f`, `/projects/288/...94695b2`). Lokaler Beweis: ctest 4/4 (test_ap7b3 + test_ap7_swisstable + test_ap7b_swiss_organ + test_s7_10_swiss). Bei rot: Trace lesen (erwartete Warn-Klasse = pre-existing -Wdangling-else in 3 Test-Dateien + abi_adapter -Wshadow, CI-toleriert wie 234-va; echte Fehler wären neu). Grün-Beleg in Ledger nachtragen.
- **#29 CI = GRÜN bewiesen:** super 8926 + ce 8924/8925 = success (ce `8ffc9c0c`).

## 2. DIESE SESSION VOLLZOGEN (alles literal + CI belegt)
- **Template-Saga .lint-static abgeschlossen:** super 8868 + 8872 = success (v3-Template 2352bcf).
- **#274 Migrations-Serie 5/6/7 KOMPLETT (measurement-all-Familie):** **#41** pmc (Projekt 320, CI 8867) · **#42** metrics+HDR-Erweiterung + #42-Standalone-Fix (ctest 280/280, CI 8880/8881) · **#39** workloads (Projekt 321, Untergruppe 432, CI 8886/8887). Alle golden/ABI-neutral, INV-2-konform.
- **#26 234-V-b [KERN]:** Rest-Familien Shaped-Naht BST/Hash/SkipList + binary_id-Shape-Segment + Baum→Emitter-Verdrahtung (pilot_source_map_shaped), default-OFF, golden-neutral. ce fd767073 / super f535e0c, CI super 8899 + ce 8900/8898 grün.
- **#43** Handover-Dokument geschrieben (`docs/sessions/20260708-HANDOVER-foundation-db-buildsystem-owner-*.md`, 6 HO-Punkte) + **HO-B-KORREKTUR** (db-client-* = generische CLIENT-Module, client/server-SOLL, NICHT fehlplatziert — User-Korrektur).
- **#11/#266 aufgelöst:** config NICHT vendorn (0 ce-Konsumenten, evidenzbasiert P3-parallel); P3 memory + P4 metrics geklärt.
- **#44** prt-art-Doppelklon-Sync (ff auf faa4e76).
- **Dirty-Sweep 08.07.:** network-protocols (webdav-Gitlink ent-trackt `4079995`), organization (`588609c`), wrappers (`2bb715a`) — ignore-Fixes committet; deren rote CI = HO-A-Alt-Matrix-Defekt (nicht meine Edits).
- **#29 Schritt 1:** comdare::container Kopf-Framework (`libs/cache_engine/anatomy/container_framework.hpp`), additiv golden/ABI-neutral, ce 8ffc9c0c, CI grün.
- **#27 7b-3 (Option B):** SwissTable SIMD-Gruppen-Match als ISA-static-Methode (group_match_mask je ISA-Strategie + ScalarGroupMatch-Default; Swiss-Organ/ComposedSwissSearch mit compile-time `class I = ScalarGroupMatch`; opt-in SwissTableOrganSimd<Isa> + organ_observe_isa). **golden-neutral:** Default SwissTableOrgan + axis_03a S22-Wrapper (supports_simd=false) UNBERÜHRT; golden_fullpilot_320 UNBERÜHRT. ce 9f60216f / super 94695b2, ctest 4/4 (CI in-flight).
- **Ledger-Backup für Fable-5-Diff:** `~/.claude/memory-backups/20260708/` (LEDGER-snapshot + MANIFEST, additiv).
- **2 Memories verankert:** `feedback_goal_hook_thorough_read_in_never_guess` + client/server-Module-Klarstellung (in umbrella-soll).

## 3. OFFENE TASKS (Board = Arbeitsvorrat; alle GO'd außer Infra)
**Meins (User-GO 08.07., je volle Kadenz + CI):**
- **#29 Rest:** (a) tiefe Genus→Typ-Umstrukturierung NUR falls User sie will (ABI/golden-GO nötig — Schritt 1 nimmt sie NICHT vorweg); (b) AP-15 (2) Sequence-Planungsdoc + (3) weitere std-Container-Typen (linked list) als geplante Typen unter comdare::container.
- **#25** Datensatz-Akten (6er-Kanon, ECHTE Prüfsummen; Korpus url/protein/trec-terms lokal vorhanden unter `Forschungsarbeiten/code/P04-CoCo-trie/.../dataset/` + `Code/test_data_xml/`; tpcds-id/xml prüfen).
- **#32** Struktur-Regression (Instanz-Repos + Naming-Sweep redcomponent/bep→Comdare; „BEP Venture UG" in Rechtstexten ERHALTEN; Remote-Ops GO'd).
- **#38** Alt-Matrix-CI fleet-weit auf schlanke Zellen-CI umstellen (metrics-Muster; HO-A, Fleet-Evidenz np/org/wrp/foundation).
- **#20** gcc-15.3-Pin (Code/CI-Teil; gcc-15.3-Installation = Infra-Agent) · **#13** 3-ISA-arm64 (node7) · **#28** P/E-Core-Auto.
- **#31 F7** (Diplomarbeit lesen → Mess-Frameworks×Workloads-Matrix) · **#156/#215/#216-HELD-Kette** (golden-320-Neubau, SCHWERSTER/SENSIBELSTER Strang — golden/ABI/S22-Kern, fresh-context-Voll-Review!) · **#14/#276** (Voll-Plattform-Matrix) AUSDRÜCKLICH ZULETZT.
**NICHT meins (Infra-Agent):** #21 (Runner-Cache) · #23 (K87b) · #36 (prod2 physisch) · #40 (CARP/Token-Rotation).

## 4. KADENZ-MUSTER (bewährt diese Session)
(1) **Gründlicher Read-in ZUERST** (jeder Goal-Hook, neue Direktive) — Memories+Ledger+Ist-Struktur LIVE verifizieren, nie aus stale Task-Notiz ableiten. (2) Doppel-Kartierung Explore+Codex bei tragenden Behauptungen (konvergent). (3) Elaboriertes Codex-Dossier (Scratchpad). (4) Codex-Erstimplementierung (danger-full-access, cwd=Ziel, gpt-5.5/xhigh). (5) **VOLL-REVIEW Zeile für Zeile:** normalisierte Diffs, git-diff-TABU-Check (golden/ABI/anatomy_base/permutation unberührt), Metaprogrammierungs-Linse (if constexpr/Concepts, kein runtime-switch), **unautorisierte Codex-Scope-Creep REVERTEN** (Muster diese Session: abi_adapter/axis_08/Bestandstest-Warn-Fixes = pre-existing/CI-toleriert, NICHT Task-Scope). (6) clang-format 22.1.8==0 (`~/tools/clang-format-22.1.8`), Mojibake grep 'Ã|â€'==0. (7) EIGENER Build 0 Fehler + ctest literal. (8) Commit (NIE git add -A; nur Task-Dateien), Push BEIDE Remotes (ce main+development ff, super-Bump), CI grün. (9) Ledger §12 + Board additiv.

## 5. TRAGENDE DIREKTIVEN (diese Session geschärft)
- **NEU (User 08.07.):** Bei JEDEM Goal-Hook gründlich einlesen, NIE raten, IMMER verifizieren (`feedback_goal_hook_thorough_read_in_never_guess`). Bewährte sich bei #11 (kein Vorrats-Vendoring) + #27 (stale Prämisse: Swiss war skalar) + #29 (Container schon gebaut) + HO-B (db-client korrekt platziert).
- **Echter Architektur-Fork → GEPARKT + Doppel-Kartierung + Empfehlung, NICHT raten** (Eskalations-Regel). #27/#29 zuerst geparkt, dann per User-GO golden-neutral umgesetzt.
- **golden/ABI-Tabu:** golden_fullpilot_320 / permutation_axes / AllStrategies+First-4 / EnabledStrategies / POD 1416 / Oracle / ABI-MAJOR-4 nur mit expliziter User-GO. Additive golden-neutrale Increments bevorzugt (Default-Pfad bit-identisch, Neues opt-in/default-OFF).
- **Codex-Kadenz:** Erstimplementierung Codex, Korrekturen MANUELL; Codex-Scope-Creep (Warn-Fixes in Fremd-Dateien) IMMER reverten; Voll-Review Pflicht.
- **Metaprogrammierung compile-time zwingend;** Modul-Referenzierung Baseline n→n-1; Organisationsform Umbrella-SOLL (Ordnerstruktur=SOLL). Scope UNVERÄNDERT: Infra=Infra-Agent, ich=Impl (4 Repos + Migration).

## 6. ZUGÄNGE / ENDSTÄNDE (literal)
- **super** `94695b2` (main; +Übergabe-Commit) · **ce** `9f60216f` (main+development) · **prt-art** faa4e76 · **thesis** unverändert (Text-Agent-Zone, nur lesen).
- measurement-all: metrics(76)+HDR · pmc(320) · workloads(321) — alle live+CI-grün.
- GitLab-API: `git credential fill` (useHttpPath), ROOTCA `~/Projekte/Cluster/keys/gitlab-ca-ROOTCA-20260621.crt` (nie -k), Token nie echoen. Codex-MCP funktioniert (danger-full-access, bwrap-Workaround). clang-format `~/tools/clang-format-22.1.8`.
- IDs: super=288, ce=286, prt-art=287, thesis=289, ci-templates=269; pmc=320, workloads=321(Grp 432), metrics=76.

## 7. NÄCHSTER ZYKLUS STARTET MIT
§1 (#27-CI-Ausgang prüfen + Ledger-Grün-Nachtrag) → dann nächster GO'd Increment nach §3-Reihenfolge (Empfehlung: #25 Datensatz-Akten ODER #38 Alt-CI-Fix als tragfähige non-golden-Stränge; die golden-sensible HELD-Kette #156/#215/#216 NUR mit frischem Kontext + Voll-Review). Goal-Text V3 (§13.12) + Tabus bindend; bei jedem Hook zuerst gründlich einlesen.
