# SESSION-ÜBERGABE 33 — Opus-4.8-Goal-V3: #25 + #29-Rest + #31 F7 + #45 + Struktur-/CI-Befunde (2026-07-08)

**Agent:** Diplomarbeits-IMPL-Agent (comdare@prod1, Opus 4.8 / max effort).
**Aktives Goal (Stop-Hook):** „Bitte erledige alle sichtbaren TODOs und den Goal-Text V3 im Ledger. Beachte besonders die Direktiven zur Striktheit der Organisationsform, Modulreferenzierung und Metaprogrammierung. Stelle sicher, dass alle Memories geladen und alle Direktiven klar sind."
**Abschluss-Grund:** STOP-BEDINGUNG erreicht — alle verbleibenden TODOs sind user-/infra-/owner-/golden-gated.

> **PFLICHT-EINSTIEG NÄCHSTER ZYKLUS:** (1) ALLE Memories laden (`~/.claude/projects/-home-comdare/memory/`, 78 Dateien; NEU `feedback_all_projects_dual_remote_github_gitlab`, `feedback_goal_hook_thorough_read_in_never_guess`). (2) Ledger §12 neueste (08.07.) + §13.12 Goal-V3 WÖRTLICH. (3) Dieses Dokument. (4) Task-Board (#1–#46) = Arbeitsvorrat. IMMER: bei jedem Goal-Hook gründlich einlesen, nie raten, Ist-Struktur LIVE verifizieren.

---

## 1. IN-FLIGHT — HIER ANKNÜPFEN
- **#45-Umbrella-CI:** ce **grün bewiesen** (8978 push-main + 8979 push-dev + 8981 downstream-nach-Retry = success, 029a3e71). super **8980** (ef6f17b) rot NUR wegen transientem **prt-art-Downstream 8982** (g++-16-ICE-Segfault auf Cold-Cache — prt-art von #45 NICHT berührt); 8982-Retry + super-8980-Recalc via Monitor in-flight. Ausgang prüfen (`/projects/288/pipelines/8980`, `/projects/287/pipelines/8982`); bei erneutem ICE = Runner-Instabilitäts-Episode (Infra), Code bleibt bewiesen.

## 2. DIESE SESSION VOLLZOGEN (alles CI-grün/literal belegt)
- **#27-CI grün nachgetragen** (8934/8935/8936/8940 = success).
- **#25** 6er-Kanon-Datensatz-Akten: 4 echte Akten (url/protein/tpcds-id/trec-terms, FNV-1a-64 via offizieller compute_dataset_akte gegen committete CoCo-trie-`_no_suffixes_small`-Dateien; Cross-Check words.txt) + xml/sosd honest-0; test_25 (CoCo=kein Submodul→CI-vorhanden); DATASETS_SCHEMA stale-Termin-7-Nachzug. cppcheck-Fix (uninitMemberVarNoCtor). **CI grün: ce 8954/8955 + super 8956.** (ce 0225396d)
- **#29-Rest** AP-15-Planungsdoc (`ce docs/architecture/37_ap15_container_typen_sequence_plan.md`): (2) Sequence=Genus unter Container (vector-äquiv. real via ISequenceTier), (3) Fork Option A (Ebene-3-Realisierung, empfohlen) vs B; **CI grün super 8970 + ce 8968.** (ce ddcc8b9a)
- **#31 F7** 2D-Matrix-Planungsdoc (`super docs/architektur/15_F7_mess_frameworks_workloads_2d_matrix_plan.md`): Achse M (Mess-Kategorien) × Achse W (YCSB-A/C/E × 6er-Dataset); Fork A (F6-compile-time-Parametrisierung, empfohlen) vs B vs C. super 8318a56.
- **#45** SOSD-Binär-Loader `sosd_uint64` (LE 8-Byte-Count + N×uint64 LE, portabel byteweise) + test_45 (Round-Trip/seed-invariant/Rejection, synthetische Blobs) + in sosd-XML verdrahtet. **ce grün 8978/8979/8981.** (ce 029a3e71)
- **#38 als Owner-Domäne verifiziert:** Alt-Matrix-CI (1175-Zeilen-.gitlab-ci) in ~250 INNEREN Baseline-Zellen von db/buildsystem/foundation/Firmen-Modulen — MEINE Zellen (measurement-all/Diplomarbeit/cacheengine) alle schlank. Kein Impl-Umstellungs-Anteil (Handover-Doku #43 = mein Teil).
- **#32-Klärung:** ce-Namespace research/286 doku-konform (KEIN Transfer, Split deferred #12); 6 modules/comdare-cacheengine/-Zellen = Archiv-Tombstone; **Alt-Naming-Sweep: 'redcomponent'=0× in ce/prt-art-Live-Code** (nur historische Ledger-/Archiv-Branch-Nennungen; 'BEP Venture UG' korrekt als Rechtstext erhalten) → in Diplomarbeit-Domäne KEIN Rename-Ziel.
- **Struktur (User-Hinweise 08.07.):** external-Modul-Original-Sync (Modules-cacheengine-all/ce ff `655c0314→…029a3e71`, dual-remote) + prt-art-Research-Klon dual-remote (github ergänzt). **Fleet-Audit:** ~50 Repos nur gitlab → #46.
- **Task-Konsolidierung:** #45/#46 neu ins Board; Memory `feedback_all_projects_dual_remote_github_gitlab` + MEMORY.md-Index.

## 3. OFFENE TASKS — ALLE GATED (Board = Arbeitsvorrat)
**User-Entscheidung (Forks, GEPARKT+Empfehlung liegen vor — NICHT ohne GO realisieren, Eskalationsregel):**
- **#29-Realisierung:** Option A (backing_structure-Achse unter Sequence-Genus, Ebene-3) vs B (eigener Genus) — ACHTUNG golden/ABI-sensibel (Sequence-Achsen-Satz), User-Gate + ABI-GO. Doc 37.
- **#31-Realisierung:** Option A (F6-compile-time-Parametrisierung workloads/metrics/pmc; golden-orthogonal, additiv) vs B vs C. Doc 15. **Am wenigsten sensibel — bester Kandidat bei GO.**
- **#28** P/E-Core-Auto: verriegelte Plattform-Tests → User-Sichtung.
**Infra-Freigabe nötig:** #13 (node7-arm64-Freeze) · #20 (gcc-15.3-Installation; +neu: g++-13 UND g++-16 ICE-Segfaulten auf Cold-Cache-Builds = Runner-Instabilität, s. §4).
**Repo-Anlage-GO (je Repo):** #46 Fleet-github-Sweep (~50 Repos, github-Repos anlegen = TABU ohne GO).
**Owner-/Firmen-Domäne:** #32-Rest (Naming nur in Firmen-Repos, Rechtstext-Erhalt) · #38 (Alt-Matrix-Umstellung).
**golden-sensibel + fresh-context + User-GO:** #156/#215/#216-HELD-Kette (golden-320-Neubau, SCHWERSTER Strang).
**Ausdrücklich zuletzt:** #14/#276. **Nicht meins (Infra-Agent):** #21/#23/#36/#40. **Montag/Historie:** #44-Rest.

## 4. NEUER CI-BEFUND (für Infra/buildsystem-Owner)
**g++-ICE-Runner-Instabilität:** In dieser Session ICE-ten SOWOHL g++-13 (ce-Downstream 8981, allocator/system_error/type_traits) ALS AUCH g++-16 (prt-art-Downstream 8982, unicode.h/gtest) mit `internal compiler error: Segmentation fault`, jeweils gekoppelt an „Failed to extract cache" (Cold-Build). Push-Pipelines desselben Commits (8978/8979) + andere Downstreams (8970/8318a56) waren grün → **transient/Last-korreliert (Runner-Speicherdruck?), Runner-Pool-Lotterie**, NICHT Code. Konsistent mit Ledger-„LAST-korrelierten Episoden". Empfehlung: Runner-Health/Memory beim Montags-Audit (K87b) prüfen; ggf. Compiler-Pin g++-16 + `GET_SOURCES/RESTORE_CACHE_ATTEMPTS` (schon fleet-weit gesetzt) greifen bei TLS, nicht bei ICE.

## 5. KADENZ + DIREKTIVEN (unverändert bindend)
Ist-Verifikation → fresh-context-Kartierung (Explore, doppelt bei tragenden Behauptungen) → Dossier → Codex NUR Erstimplementierung (danger-full-access; Fehler/Konfig MANUELL) → VOLL-REVIEW Zeile für Zeile → Mojibake 0 → clang-format 22.1.8==0 → doppelt-literale Verifikation (eigener Build + ctest) → granularer Commit (NIE git add -A) → Push BEIDE Remotes je Repo → STRIKT GRÜN je große Aufgabe → Ledger §12 + Board additiv. **TABUS:** golden_fullpilot_320/permutation_axes/AllStrategies/EnabledStrategies/POD-1416/Oracle/ABI-4 nur mit User-GO · Messdaten/Doku nie löschen · Remote nie löschen/anlegen ohne je-Repo-GO · Cluster read-only · buildsystem.xml hands-off · Metaprogrammierung compile-time zwingend · thesis nur lesen · AskUserQuestion NIE.

## 6. ZUGÄNGE / ENDSTÄNDE (literal)
- **super** `ef6f17b` (main; #45-Bump+Ledger) · **ce** `029a3e71` (main+development) · **prt-art** unverändert (nur Downstream-Retry) · **thesis** unverändert (Text-Agent-Zone).
- **Modules-cacheengine-all/ce** ff-synchron `029a3e71` (dual-remote). **prt-art-Research-Klon** dual-remote.
- GitLab-API: `git credential fill` (useHttpPath), ROOTCA `~/Projekte/Cluster/keys/gitlab-ca-ROOTCA-20260621.crt` (nie -k), Token nie echoen. clang-format `~/tools/clang-format-22.1.8`. IDs: super=288, ce=286, prt-art=287, thesis=289; measurement=76, pmc=320, workloads=321.

## 7. NÄCHSTER ZYKLUS STARTET MIT
§1 (#45-Umbrella-Grün-Ausgang prüfen + Ledger-Nachtrag). Dann User-Entscheidung abwarten/umsetzen: **Empfehlung #31 Option A** (golden-orthogonal, additiv, F6-konform — der wertvollste nicht-gated Increment sobald der User A/B/C bestätigt) ODER ein anderes freigegebenes Gate. HELD-Kette #156/#215/#216 NUR mit frischem Kontext + Voll-Review + explizitem User-GO.
