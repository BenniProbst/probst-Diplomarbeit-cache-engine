Vollständige Extrakte, Band 02 (14 Dateien laut `/home/comdare/.claude/jobs/5a19728e/tmp/band_02`). Methodischer Hinweis vorab: `MEMORY.md` wird während dieser Bearbeitung von anderen aktiven Agenten (main/hygiene-heiler/hygiene-lens2/wie-hast-du) sichtbar verändert — der im System-Reminder zu Gesprächsbeginn eingebettete Index-Stand unterscheidet sich bereits von der Live-Datei (79 Zeilen, Stand 2026-08-10 07:50, md5 d5f0d6fe...). Alle "in-index"-Aussagen unten sind daher Momentaufnahmen von 2026-08-10 08:01 UTC, per `/usr/bin/grep -Fc` gegen die Live-Datei geprüft — keine Aussage über den Index-Stand danach.

---

## 1. project_20260804_pause_s5_wellen_landebereit.md
**THEMA:** Pause-Anker, zwei S5-Wellen landebereit ungelandet
**TYP:** project (modified 2026-08-04T16:20:15.289Z)

**FAKTEN** (Session-Selbstbericht = AGENTEN-BEHAUPTUNG, sofern nicht anders markiert):
- ERST-ANKER bei Wiederaufnahme: `super docs/sessions/20260804-PAUSE-abbruchsicher-s5-wellen-landebereit-vor-anker.md`, dann Arbeitsweise-Memory, Uebergabe 549241e4, Ledger-grep '04.08.2026' abend-2..abend-9.
- Linien (alle gruen, FF gepinnt, beide Remotes): ce dev==main==**28261b5a** (Gate 384; A8-S3 + ccache-Fix a8c2da91 + S5-04-Pilot a801a7e3 + A8-S4 gelandet); super dev==main==**ada8da48** (Ledger bis abend-8; abend-9 = Pause-Nachtrag im Pause-Commit).
- LANDEBEREIT/UNGELANDET bei Wiederaufnahme (R4-seriell, eigener Merge-Doppellauf Pflicht — nicht tree-identisch, S4 dazwischen; N-Erwartung 388): S5-03 (wt-w10, Branch s5-03-placement @**3f391098**) + S5-01d (wt-e24, Branch s5-01d-traversal @**df13450c**). Resume-IDs falls Workflows tot: `wf_776d1c7c-f98` / `wf_fd0921bf-0d0`.
- Reststrecke danach: P-CACHELINE-LITERAL (einziger Kartierungs-Pflichtposten) → W2 (01a→02a→01b) → W3 (02b→01c mit Fable-Design-Vorlauf; NEUE KANTE: "Template-Kopf dreht Registry-XML" = 01d-Befund) → EIN ANKER (beendet Job-Sperre) → Phasen 3-5 → Trigger Do 07.08.; **Messung Phase 6 = USER-GO-STOPP**.
- **OWNER-KERN abend-6 (OWNER-WORT, verbatim im Ledger):** "ALLE Achsen-Eigenschaften NUR ueber die Achsen" — Ausnahme: Genus-Erst-Instanziierung. Kartierung fertig (abend-8): 1 Pflicht + Posten 55-63; Wellen-Reviews ergaenzten (64)-(66).
- .patcfg zu diesem Zeitpunkt geshreddert (PAT muss neu blind extrahiert werden); Job-Sperre aktiv bis Anker.

**STAND:** UEBERHOLT — reiner Zwischen-Anker vom 04.08., durch File 2 (05./06.08.) und alles danach (Index: "Sessions ab 08.08. LESEN, nicht reviewen") ueberholt. Als Historie fuer die Rekonstruktion der S5-Wellen-Kette wertvoll.

**VERWEISE:** `[[feedback_claude_code_arbeitsweise_v2_konsolidiert]]` — aktuell IM Index (in-index=1). Inhaltliche Fortsetzung (kein woertlicher Link, aber gleiche Trigger-Do-07.08.-Zielmarke) zu File 2 dieses Bandes.

---

## 2. project_20260805_pause_01c_komplett_vor_phase_b.md
**THEMA:** Anker vollzogen, Dual-Review-Aera, W1-W5/W3 Wellenkette
**TYP:** project (modified 2026-08-06T04:50:00.000Z, mehrschichtige Datei mit expliziten "Historie:"-Bloecken — Reihenfolge unten beibehalten, aeltestes zuerst innerhalb der Schichten, aber die juengste Schicht steht in der Datei oben)

**FAKTEN**, chronologisch (aeltest zuerst; Session-Selbstbericht, HERKUNFT AGENTEN-BEHAUPTUNG wenn nicht anders markiert):

*Schicht 1 — Stand 05.08. ~06:55 UTC (aelteste):*
- ERST-Anker: `super docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` Nachtrag nacht-6.
- Linien: ce dev==main==**24e07219** (Gate 403; 01c-3 98eea2e7 + Q-Welle b09ebb8a + PHASE B GELANDET 24e07219 [EffectiveSearchAlgo an 3 Treiber-Stellen, 22/22-Traversal-Symmetrie, Pipeline 14633] — "der GESAMTE A8-S5-Bau-Komplex ist FERTIG").
- **OWNER-WORT (mittag-12, verbatim):** "nach allen Workflows zum Hauptstrang, zuerst Implementierungskorrekturen, dann nach Plan wie gehabt."
- Rest-Strecke kanonisch: P1 ANKER (Eich-Welle wf_f65db4d4, A2-SHA512-Gate F7-Form) → P2 W-Wellen (W1 Planer-Split F1-HART + W2-Minimal -D-Define + W5-Kern status-Rueck-Leser + W3-Kern Pruefdock-Testate; **ALLE 7 Owner-Entscheide liegen** vor, Ledger mittag-6) → P3 Phasen 3-5 → Trigger Do 07.08. (nur mit gruener W1/W2-Emission) → Phase 6 = USER-GO-STOPP.
- **STUFEN-DOKTRIN OWNER-ABGENOMMEN** (mittag-9/-10/-11): Mess = 3-stufig dehnbar (Planer-RT → CEB-CT [inkl. Pruefdock-Konfig] → [Hybrid-CT] → Tier-CT); System = 2-stufig dehnbar (CEB-RT → [Hybrid-CT gibt sich+Tiers Config mit] → Tier-CT); Organ = 2-stufig hybrid-unberuehrt (Hybrid=Factory-Facade-Adapter, organ-frei).
- Owner-KERNe: NIE RATEN, sauberster Weg nach Plan; Interims IMMER mit Nach-Abgabe-TODO; vor Rueckfragen IMMER Explore ueber Plan-Korpus (>1200 beantwortete Fragen).
- super dev==main==**ba56b8df** (~11:55; UML-Atlas 05b REV 4, NEUE Artefakt-URL 61359d31... — alte geloescht; L4-Konnektivitaet 0 lose Knoten).
- **KETTE-AUDIT vormittag-4** (Owner-Anstoss): 2 neue Owner-KERNE (Planer=ZWINGEND eigene Binary mit Shell-CLI; CEB==CacheEngineBuilder woertlich). Verdikte: G1 REGRESSION · G3 Kernsatz-Verstoss · G4 bewusst-deferred (Payload S5-P4-DEPRECATED) · G2/G5 teil-konform. **6er-Regressions-Register + 7 OFFENE OWNER-RUECKFRAGEN**, KEINE Impl-Aenderung ohne GO. Backup: `backups/20260805-planer-ceb-kette-audit/`.
- **ABSCHNITTS-TRUTH-CHECK S5 (A2-Pflicht, wf_94ca9f27) — WIDERLEGT:** Familie 05 nur 2/4 — **queuing_q1/q2 haben KEINEN axes/-Ordner, leben nur in topics/queuing/** (13-14/18 Q1-Header mit Organ-Zustand am Default-Allokator; Q1=T15 mandatorisch, live via abi_adapter :1010/:1086/:1165). Substanz haelt sonst (golden/XML/Wire byte-neutral ueber 65a61fcf..98eea2e7). Posten 83-86 im Ledger.
- Fallen NEU: Nachweis-greps muessen topics/-Doppelwurzeln erfassen (axes/-grep blind fuer queuing) · System-Header-Falsches-Gruen · cf22 nur echtes Binary · 3 Marker-Typen vor Commit · CRTP-Weiterleiter ohne eigenen Member = stille Rekursion · **super-Projekt-ID=288, ce=286** (Pipelines-API nur VOLL-SHA).

*Schicht 2 — Stand 05.08. ~13:00 UTC:*
- **ANKER KOMPLETT S0-S8**: A2-SHA512-Eichung F7 gelandet (ce dev==main==**18fbb950**, Gate 404, Pipeline 14659; dll_is_current = EIN fail-closed-Vergleich) + TP1-FINAL-Inventur (9/9 Gates, TP1_ANKER_OK).
- DAUER-AUFLAGE aller W-Wellen: Fingerprint-Neutralitaet (Frozen-Vektor 0fe275bd/golden-CRC/abi-Diff-0), Verstoss => STOP+O-2.
- P2 laeuft: W1-Welle wf_d38fa034 (Planer-Split, wt-e24 ab 18fbb950).
- Atlas komplett bis REV 5 (super **432a130c**).

*Schicht 3 — Stand 05.08. ~14:30 UTC — "die Planer-Rolle ist eine EIGENE BINARY; R-G1 GESCHLOSSEN":*
- ce dev==main==**60c7c56a** (Gate 405; comdare-experiment-planner als eigene App, ZWEI MODULE ueber Fassaden-lib; -D COMDARE_MEASUREMENT_COMBO_CT mit CT-Vorrang, [all] byte-identisch; **FALLE: neue -D-Makros NIE in String-Literal-Adjazenz** — CI-Rot 14673 lint:static).
- super dev==main==**69dd9fb7** (Merge 409757b0).
- LAEUFT: W5-Kern+W3-Kern-Welle wf_7953bc4d.

*Schicht 4 — Stand 05.08. ~17:20 UTC — "DUAL-REVIEW-AERA (A3)":*
- Linien: ce dev==main==**b4110cd0** (Gate 405; W1/W2 + cppcheck-Hotfix + w2-codex-fixes); super dev==main==**c9eedace**.
- A3-DUAL-REVIEW-PFLICHT etabliert (Codex+Fable Pflicht; Codex LEBT, bwrap intermittierend → INLINE-Diff-Rezept). W1/W2: 3 Befunde gefixt+gelandet; A2-Eichung: 6 Befunde (C1/C4/C5/C6 real); **O-2 OWNER-GATE offen**: Preimage-Neuanker C1+C6 vor Trigger vs. Interim; W5/W3: 9 Befunde, Nachbesserungs-Welle wf_a870c885 laeuft.
- PARALLEL-SESSION AKTIV (Systemabsturz-Neustart, glaubt stale 'Sonnet-Uebernahme'): WORKTREE-BESITZ-REGISTER bindend (wt-e24 + wt-super-w1 + Haupt-Trees = diese Session). Owner-Entscheid zur Session-Fuehrung zu diesem Zeitpunkt OFFEN.

*Schicht 5 (juengste) — NACHTRAG 06.08. ~07:00, PAUSE:*
- **W5/W3 IST GELANDET** — ce dev==main==**7969b399** (Gate 408; 3-Zyklen-Dual-Konvergenz, **Codex final KEINE BEFUNDE**).
- super dev==main==**644605b5** (Sammel-Backup aller 26 Workflows).
- wt-e24/wt-w2fix/wt-super-w1 FREI; haengender super-main-FF geheilt; B-Linie fuehrt die Reststrecke.
- **NEUER ERST-ANKER 06.08. ~06:40** (PAUSE Netzwechsel): `super docs/sessions/20260806-PAUSE-abbruchsicher-netzwechsel-vormittag.md` (Merge 1b7ca1e3). NB-2-Welle abrissgefaehrdet: wt-b2 dirty ueber 77095354. Schwelle 21:00 (E-3). gcc 15.3/16-KERN.

**STAND:** UEBERHOLT (juengste Schicht 4 Tage alt; per Index "Sessions ab 08.08. LESEN, nicht reviewen" durch alles Folgende ersetzt). Die Datei selbst modelliert Ueberholung explizit ueber "Historie:"-Bloecke — gutes Beispiel fuer korrekte Selbst-Kennzeichnung.

**VERWEISE:** `[[feedback_claude_code_arbeitsweise_v2_konsolidiert]]` (in-index=1). `[[feedback_atlas_immer_korpus_gegenpruefung]]` — **Datei existiert, in-index=0** (Cluster-Fund: existierende, unverlinkte Datei). Direkte Kontinuitaet zu File 1 dieses Bandes (gleicher Trigger-Do-07.08-Bogen).

---

## 3. project_bep_abt_session_stand_20260705.md
**THEMA:** Setup-Session #2, Strang A/#258 Fixes
**TYP:** project (originSessionId 34effcef-618b-4cb2-bd80-87d2a502062e)

**FAKTEN:**
- Setup-Session #2 komplett (AGENTEN-BEHAUPTUNG): 3 Plugins installiert · 60 Memories uebernommen · GitHub-Remotes `github` angelegt, ls-remote deckungsgleich: super **81f0975** / ce **c4eb7d7f** / prt-art **7997a0b** · clang-format **22.1.8** in `~/tools/clang-format-22.1.8` (dpkg-deb-Extrakt, kein sudo) · 2 fehlende encryption-Module geklont (Manifest-URLs hatten Subgruppe `comdare-encryption/` vergessen) · Codex-MCP auf gpt-5.5+xhigh.
- Strang A/#258, ce Working Tree 4 UNCOMMITTED Dateien: (1) `cmake/is_original_codegen.cmake` + `CMakeLists.txt` — Codex hatte 4 Listen-Targets in 5 redundante Bloecke dupliziert, vom Agenten strukturell zurueckkorrigiert; **MESSUNG:** isolierter 5-Target-Build generiert `paper_a04_mimalloc_is_original.hpp`, test_216h2 kompiliert durch. (2) cppcheck-FP-Suppressions in 2 Dateien (`test_188_4bbV_pool_adapter_flip_compile.cpp`, `test_s7_1_bst_pool_allocator_deg.cpp`) — lint:static-Rot war False-Positive (anonyme Namespaces = interne Bindung, cppcheck-CTU ignoriert das bei Templates nicht).
- OFFENER REST #258: `tests/unit/test_v41_anatomy_module_abi.cpp:34` — `namespace abi = ::comdare::cache_engine::abi;` kollidiert unter g++-16 mit `namespace abi = __cxxabiv1;` aus `<cxxabi.h>` (gtest zieht es auf GCC; MSVC hat kein cxxabi.h). Fix geplant: Alias → `ce_abi`, 11 Verwendungen Z. 60–95. Gleiche-Muster-Verdacht: `test_v41_anatomy_codegen.cpp`, `anatomy_module_loader.cpp`, `test_engine_adapters.cpp`.
- **MESSUNG (super-Pipeline 8007 Job 212458, toolchain:probe=success, Runner prod-baremetal-prod1):** gcc-16.0.1-trunk (default) + gcc-13.3.0 vorhanden; **KEIN gcc-15/14**. Entscheid: Pin NICHT deployen ("Default bleibt bis dahin Trunk-16"); HO-11 = gcc-15.3 ins Infra-Paket (#272/Strang F). clang++-22.1.8 vorhanden → build:clang auf prod1 lauffaehig.
- Pipeline-Lage: ce 7965/7963/7958 (c4eb7d7f) failed = NUR contract:conformance + lint:static; 7930 (c9a7e44e) failed gleiche Klasse; lint:format gruen seit #257. prt-art 7966 GRUEN auf HEAD.
- Diskrepanz gemeldet: **OWNER-WORT** — User sagte "Diplomarbeit liegt jetzt unter Projekte/Research/Diplomarbeit" — Pfad existiert NICHT, Projekt liegt unter `Research/probst-diplomarbeit-cache-engine`.

**NACHTRAG 2026-07-06 frueh:** #258-Fix-Paket gelandet (ce-Kette d51ef9a0→b9cc4fdb, super bis 48a85c6) · S7-2 BTree (**883a4ff1**, alloc_cnt=3) · S7-3 SkipList (**dd704d67**, alloc_cnt=21) · S7-4 Hash (**b9cc4fdb**, alloc_cnt=2) · #271 perm_runner-Fix (**19d7f701**, Exit 1→0) · #272 HO-1..HO-12-Paket (super **197729d**). Kumulative Beweis-Pipeline **8022** pending im Runner-Stau.

**NACHTRAG 3:** 234-V GEPARKT (Architektur-Fork, 2 offene User-Fragen). AP-15-2 DONE (ce **81d0b6bb**: IAllocatorProxyTier + ComdareAllocatorProxyV1; **MESSUNG:** literal 7/7 + `family=4 bytes=512 allocs=5`).

**NACHTRAG 4 (#263 komplett):** AP-15-3 DONE (ce **4cc8c75e**: DriveableMapContract<Derived>-CRTP). Session-Bilanz: 19 verifizierte Increments.

**NACHTRAG 5 (#264 im Kern DONE):** 264-a/a2 (ce **ce1af878+8669210d**): comdare_tests-Registry, Suite baut ERSTMALS 788/788; **MESSUNG:** ehrlicher ctest-Vollauf 126/184. 264-b (ce **3895a3a5**): test:unit-Probelauf **mit `allow_failure`** + sanitize 1→5 Targets + neu sanitize:tsan — Datum **exakt 2026-07-06**. 264-c/c2 (prt-art **8cb32fe**): 3 fehlende Header + echter LeafOnlyCounter-Data-Race gefixt (shared_mutex double-checked) — **211/211 PASS + repeat:20**.

**STAND:** UEBERHOLT (35 Tage alt; alle genannten Stroenge/Tasks liegen weit vor dem heutigen GOAL-v8-Stand).

**Hinweis (kein WIDERSPRUCH, aber Datumsnähe beachtenswert):** Der Index fuehrt eine Dauerregel "[allow_failure VERBOTEN seit 0607]" — diese Datei zeigt einen `allow_failure`-Einsatz **am 2026-07-06 selbst** (test:unit-Probelauf). Passt zeitlich exakt auf den im Index genannten Stichtag; koennte der dokumentierte Ausloeser der spaeteren Verbots-Regel sein — aus diesem Band nicht abschliessend zu klaeren, da die Verbotsregel-Datei selbst nicht im Band liegt.

**VERWEISE:** `[[reference_prod1_comdare_env_setup]]` (in-index=1, per Ursprungs-Index bereits bekannt).

---

## 4. project_diplomarbeit_stand_20260706_comdare_prod1.md
**THEMA:** Migration comdare@prod1, inkonsistenter Nacht-Stand
**TYP:** project

**FAKTEN:**
- Umgebung (seit 2026-07-05 abends): Arbeit laeuft als **comdare@prod1** (vorher root@prod1; root-Claude-State migriert nach `/home/comdare/.claude`, root-Sessions liegen unter `~/.claude/projects/-root/`). Repos: super = `~/Projekte/Research/probst-diplomarbeit-cache-engine` (ce/prt-art als Submodule unter `Code/external/`), Cluster-Docs = `~/Projekte/Cluster/docs`. GitLab-PAT unter `~/keys/gitlab-pat`.
- Letzter Arbeitsstand (Nacht-Session 06.07., 01:05–02:46 UTC): S7-Serie KOMPLETT (alle 10 Pool-Familien echte T6-DEG), 234-V GEPARKT, AP-15-2/15-3 DONE, #264 264-a/a2/b/c DONE, prt-art Race-Fix 211/211. Endstand: super **3d23d7a**, ce **3895a3a5**, prt-art **8cb32fe**.
- **OWNER-WORT (2026-07-06), sinngemaess mit direkter Kritik:** Die Session hinterliess einen **inkonsistenten Stand**, die GitLab-Pipeline laeuft nicht mehr durch, und Codex-Arbeit wurde **entgegen Anweisung nicht Zeile fuer Zeile gegengeprueft**. → Vor Weiterarbeit: Ist-Verifikation, Pipeline-Endstand via GitLab-API dokumentieren, deterministische Fehler FIXEN statt re-triggern, nicht-reviewte Nacht-Commits (S7-5..10, AP-15-2/3, 264-a/b/c) nachtraeglich Zeile fuer Zeile reviewen.
- **Goal-Text-Fundorte** (User fragte danach, exakte Pfade):
  1. Der vom User selbst gesetzte `/goal`-Wortlaut (05.07. 23:00, pfad-korrigiert): `~/.claude/history.jsonl` Zeile 23 + Session `~/.claude/projects/-home-comdare-Projekte/34effcef-*.jsonl` (Zeilen 633/643).
  2. **GOAL-TEXT V2** = Ledger §13.4 (`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` Z.247–254), korrigiert durch §13.9/§13.10/§13.11.
  3. Fertige GOAL-VORLAGE: `docs/HANDOVER-BEP-ABTEILUNG-20260705.md` §2 Z.26.

**GOAL-Versions-Lineage (aus diesem und Band-Datei 6 rekonstruierbar):** V2 (dieser File, 05./06.07.) → V5 (per File 6 als SUPERSEDED bezeichnet) → V6 AKTIV (File 6, 17.07., LEDGER:75-118, super bf8a7ca) → ... → **V8** (heute laut Index-⭐ZIEL aktiv). Reihenfolge/Zwischenschritte V3/V4/V7 sind in diesem Band NICHT belegt.

**STAND:** UEBERHOLT (34 Tage alt; GOAL ist laengst bei V8).

**VERWEISE:** `[[feedback_codex_outputs_always_full_manual_review]]` — **Datei existiert, in-index=0** (Cluster-Fund).

---

## 5. project_diplomarbeit_stand_20260712_freigaben_pipeline.md
**THEMA:** Freigaben-Session GO 1-5, golden-320-Messlauf
**TYP:** project

**FAKTEN** (Quelle laut Datei: super-Ledger §11-I, woertlich verankert):
- GO 1 — Overleaf-Anhang verdrahtet (thesis **73947aa**, `\InputIfFileExists`, PDF-verifiziert) → CI-interaktive Diplomarbeit END-TO-END: XML→measure→Anhang-Regen (16 .tex via `08_appendix_generator`)→persist→PDF. Task #24 completed.
- GO 4 F-C (ce **a08a60ca**): Cacheline-B32 additiv + FF2-Unterachse `node_width {1,2,4,8,16}`. **OWNER-WORT:** "zusaetzlich, als dokumentierter Permutations-Knopf" (F-B).
- GO 3 (ce **def62b0a**): ISA-Deklarations-Wahrheit (Kohaerenz-Guard, **MESSUNG:** objdump-belegt) + Scan-Kern-Reinheits-Guard.
- #25 komplett (format_tex.py→09_tex_formatter; codegen.cmake→cpp-Backend byte-identisch, opt-in).
- **Infra-Handover geschrieben: `super docs/sessions/20260712-INFRA-HANDOVER-nas-writeback-filterpod-und-runner-concurrency.md` — V80-Filterpod write-only + prod1-concurrency 2→3. User ueberreicht.**
- SEQUENZ KOMPLETT VOLLZOGEN (Ledger §12 Zyklen I–IV): Smoke-Profil ✅ (`m3_smoke_coverage` **93 Binaries**) → F-B ✅ (alloc_hw, honest-0 beseitigt) → GO-5-Forks ✅ (H2-Score tool-berechnet **12+21-n/a**) → Aufraeum ✅ (**alle 10 Profile validieren Exit 0**) → GO 2 FINAL ✅ (cpp-Codegen-Backend = DEFAULT, byte-identisch) → mimalloc-GRENZE ✅ (perms-ON-Tree **erstmals volle Suite 216/216**). Endstand ce **e5946cdb**, super **0c34342**, thesis **73947aa**.
- Messlauf: **#9916** (`measure:golden-320` auf prod1/id=16) laeuft mehrtaegig, bewusster **Proof-of-Concept unter Fremdlast** (**OWNER-WORT**: Maschine wird parallel gebraucht, Geduld vorhanden; echte Kampagne spaeter lastisoliert).
- Verbleibend zu diesem Stand: Messlauf-Strecke · Infra-Handover beim User · dossier-entschieden-gated (V32-Tilgung, Fork 4/#274, P/E-Core-HW, NUMA-Effekt-Multi-Socket, H2-Korrelation).
- NACHZIEH-Vermerk in der description (2026-07-16, Audit F51): die GESAMTE GO-1-5-Sequenz ist KOMPLETT vollzogen (Ledger Z.124 + §12 07-12 Zyklen III+IV).

**WIDERSPRUCH-relevanter Fund (Runner-Concurrency-Lineage):** Diese Datei belegt einen Zwischenwert in der Concurrency-Historie: **"prod1-concurrency 2→3"** am 2026-07-12 als Teil eines an den User ueberreichten Infra-Handovers. Das deckt sich mit der im Auftrag genannten Kette "Wellenplan sagt 2, Wahrheit ist 4" — hier liegt der dokumentierte **Zwischenschritt 3** (12.07.), zwischen dem alten "2" (Wellenplan, unbekanntes Ursprungsdatum) und der heute (10.08.) andernorts gefundenen "4". Reihenfolge, soweit aus diesem Band rekonstruierbar: **2 (Wellenplan, Datum unbekannt) → 3 (12.07.2026, dieser Fund) → [Luecke] → 4 (heute gefunden, Quelle ausserhalb dieses Bandes)**. HERKUNFT: AGENTEN-BEHAUPTUNG (Session-Zusammenfassung eines an den User uebergebenen Dokuments) — der Primaerbeleg waere `super docs/sessions/20260712-INFRA-HANDOVER-nas-writeback-filterpod-und-runner-concurrency.md` selbst.

**STAND:** UEBERHOLT (Status-Snapshot vom 12.07., golden-320-Lauf #9916 laengst abgeschlossen oder ersetzt; Concurrency-Wert seither mind. einmal weiter veraendert).

**VERWEISE:** `[[project_mess_ergebnis_rueckschreibung_pipeline_persistiert]]` (in-index=1) · `[[reference_measurement_writeback_token_288_secure]]` (in-index=1 — moegliche Ueberschneidung mit "super-Projekt-ID=288" aus File 2 dieses Bandes, aus diesem Band nicht zweifelsfrei zu klaeren, ob dieselbe "288") · `[[feedback_immer_schwerer_offizieller_weg_keine_behelfswege]]` (in-index=1).

---

## 6. project_diplomarbeit_stand_20260717_volles_go_bau_roadmap.md
**THEMA:** Volles GO erteilt, Bau-Roadmap INC-0 bis INC-2
**TYP:** project

**FAKTEN:**
- **OWNER-WORT (2026-07-17, Kontext-Ende, verbatim):** "GO fuer Q1-Q5, volles GO fuer DLL-Load Option B, VOLLES GO sonst. Warte auf alle Workflows, bevor du baust." — Damit sind ALLE offenen Architektur-Entscheide getroffen (Q1-Q5-Mapping, DLL-Load=Option B, H-6..H-10, Planer-Codegen-Forks PF1-4, Set-Ebene-1-Promotion, Telemetrie/Scheduling-System-Achsen, golden-Umbau, Serialisierung Q1-Q4).
- Gelandet: F6-Nachzieh (ce **871f6d2e**, super **8488d1d**; `ctsha.hpp` ehrlich NICHT deprecated=LEBT) + §18/§19-Konsolidierung ins Ledger (super **53cbecf**).
- Bau-Roadmap: **INC-0** (deadline-kritisch) — DLL-Load Option B: `link_libs`-Kanal in `make_gpp_compile_fn` (`build_orchestrator.hpp:466-489`) + Fassaden-Bake `$<TARGET_FILE:comdare::vendor_mimalloc>`; ABI-4-kompat; entsperrt echte Messwerte (measured>0). **INC-1** — CEB-System-Achsen-Schichtung (4 System-Achsen als Schicht ueber den **19 Organ-Achsen**; heute flach). **INC-2** — der EINE koordinierte **4→5-ABI-Bump** am Experiment-Planer-Dock (Design `F12III-DESIGN-VORLAGE.md`) — TABU-GO, EIN reservierter Major-Bump.
- **Deadline zu diesem Stand: 28.07.2026 (CI UND standalone messfaehig).**
- AKTUALISIERUNG spaeter am 17.07.: Bau-Ablauf praezisiert — jede Aufgabe erst per ultracode-Planungssession vorbereitet, Bau-Phase danach EXPLIZIT freigegeben. INC-0-Bauplan: `docs/sessions/backups/20260717-inc0-bauplan/BAUPLAN-INC0-DLL-LOAD-B.md`. **§0-GOAL-V6 AKTIV** (LEDGER:75-118, super **bf8a7ca**; **V5 SUPERSEDED**). TABU praezisiert V6.5 (hart vs. GO-Fenster nur Bau-INC-2). /goal-Steuertext = V6.9.

**Wichtiger Nebenbefund zur Organ-Achsen-Zahl:** Diese Datei (17.07.2026) nennt explizit **"19 Organ-Achsen"**. Der aktuelle Index fuehrt dagegen bindend: **"18 ORGAN-ACHSEN, nicht 19"** (`reference_organ_achsen_sind_achtzehn_nicht_neunzehn.md`). Das ist die dokumentierte Korrektur-Reihenfolge: **19 (Stand 17.07., dieser Fund) → 18 (heute geltend, Korrektur-Datum aus diesem Band nicht belegt)** — beide Werte sollten im Konsolidierungsdokument nebeneinander stehen, mit dieser Datei als Beleg fuer den frueheren "19"-Stand.

**STAND:** UEBERHOLT (GOAL V6 durch V8 ersetzt; Deadline 28.07. durch spaetere Termine ersetzt, siehe File 8 und Index "bis 15.09.").

**VERWEISE:** `[[feedback_recursive_dock_planer_ceb_tier_abi_stable_so]]` — **Datei existiert, in-index=0** (Cluster-Fund). `[[feedback_open_decision_first_reread_ledger_and_plandocs]]` (in-index=1). **`[[project_diplomarbeit_stand_20260712_freigaben_pipeline]]` = File 5 dieses Bandes — echter Intra-Band-Cluster** (explizite "Verwandt"-Verlinkung).

---

## 7. project_e18_snapshot_ordner_und_graph_darstellung_kerne.md
**THEMA:** E18-Snapshot-Ordner, 2D/3D-Graphen statt Heatmap
**TYP:** project (modified 2026-08-06T05:51:28.598Z)

**FAKTEN:**
- Zwei Owner-KERNe vom 06.08.2026 (Quelle laut Datei: `super backups/20260806-owner-entscheide-e1-e5/`, Ledger frueh-6):
  1. **E18-SNAP (E-1-KERN). OWNER-WORT, verbatim:** "in Zukunft soll die Diplomarbeit einerseits fertig auf den branch gepusht werden, aber andererseits wird sie zusaetzlich in einen Ordner an der Wurzel der Messwerte kopiert, samt latex compile-export (Benennung nach Datum und Uhrzeit). so laesst sich ein compile nachvollziehen." — Ziel-Branch **289 = development** (E-1a). Arbeits-Annahme (Praezisierung war zu diesem Datum noch offen angefragt): `super measurement/thesis_compiles/JJJJMMTT-HHMMSS/` mit PDF + Compile-Log + Quellstand-SHA je Kanal-Lauf.
  2. **Graph-Darstellung (E-2-KERN). OWNER-WORT, verbatim:** "eine Heatmap ist vielleicht nicht die geeignete Form, wie machen das die anderen Paper? Orientiere dich daran und verwende 2D und 3D Graphen." — Reihenfolge: honest-empty-Paket zuerst (B-5-Lebend-Check VOR Trigger, E-2a), Voll-Korpus-Check spaeter (E-2b).
- E-4-DAUER-DOKTRIN, **OWNER-WORT:** "Bitte notiere shortcuts als offene REgression und TODO" — jeder Shortcut wird als OFFENE REGRESSION + TODO im Ledger notiert; P2-P8-Schema-Fenster VOR Messbeginn; xlsx = Erst-Auswerteformat.
- E-5: Posten 92 vor Abgabe. W5/W3-Schwelle: 21:00 Berlin 06.08.

**STAND:** Owner-KERN selbst GILT (kein Hinweis auf Widerruf im Band); Umsetzungsstand (Praezisierung E18-Pfad, Graph-Umbau) zu diesem Zeitpunkt UNKLAR/offen — "Praezisierung angefragt" war der letzte Stand in dieser Datei, kein Beleg fuer spaetere Klaerung in diesem Band.

**VERWEISE:** `[[project_lager_baeume_xlsx_doktrin]]` — **Datei existiert, in-index=0** (Cluster-Fund, mehrfach in diesem Band referenziert, siehe auch File 10/13). `[[feedback_wiederanlauf_doktrin_nach_session_abriss]]` (in-index=1).

---

## 8. project_frist_montag_2707_zeitbudget_bau_messen.md
**THEMA:** Frist 27.07., Zeitbudget Bauen und Messen
**TYP:** project (modified 2026-07-23T12:33:46.061Z)

**FAKTEN:**
- **OWNER-WORT (2026-07-22 abends, KERN=Gesetz, verbatim):** "bitte arbeite so gruendlich, wie moeglich, die Frist ist bis montag, aber bis dahin muessen wir wohl noch 2 Tage bauen und 2 Tage messen und testen."
- Bedeutung: Gesamtfrist = **Montag 27.07.2026** (ersetzt die **24.07.-Zwischen-Frist aus §41** als hartes Einzeldatum).
- Zeitbudget rueckwaerts: ~2 Tage Voll-BAU (2^17) + ~2 Tage MESSEN+TESTEN (320er + Abnahme) ⇒ Voll-Bau-Start SPAETESTENS **Donnerstag 24.07.**
- Fahrplan: Mi-Nacht S1-S4 + Verifikation → Do Voll-Bau-Start (beide Maschinen, ccache/K7b wirksam) → Do+Fr Bau → Sa+So 320er-Messlauf + Tests + M-4 + PDF → Mo Abgabe.
- **Why (OWNER-WORT sinngemaess belegt):** User korrigierte die Formulierung "Frist hat Vorrang vor Batch-Perfektion" mit "Nein" — Gruendlichkeit ist die Direktive.
- **PRAEZISIERUNG (23.07.), OWNER-WORT, verbatim:** "Keine Umwege, aber NACHEINANDER DURCHZIEHEN" — waehrend einer Kette entdeckte Pflicht-Restpunkte werden IN der Kette abgeschlossen, nicht als Folgepaket geparkt.
- **EINORDNUNG (User 23.07. mittags), OWNER-WORT, verbatim:** "es ist ja noch nicht die End-Abgabe wo alle Aufgaben in der aktuellen Gruendlichkeit erledigt sein muessen" — Montag 27.07. ist eine **ZWISCHEN-Abgabe**, nicht die End-Abgabe.
- **LAGER-GATE (§66) ERZWUNGEN, OWNER-WORT, verbatim:** "das Risiko des Scheiterns ohne Wiederaufnahme ist zu gross" — Lagerhaltungs-Punkte vorziehen und moeglichst parallelisiert entwickeln.

**Deadline-Lineage (aus Band rekonstruierbar):** §41-Zwischenfrist **24.07.** (Datum der §41-Festlegung unbekannt, aus diesem Band nicht belegt) → **27.07. Montag** (diese Datei, festgelegt 22.07., als ZWISCHEN-Abgabe eingeordnet 23.07.) → File 6 (17.07., zeitlich VOR dieser Praezisierung!) nennt separat **28.07.2026** als Deadline — die beiden Zahlen 27.07 und 28.07 sind aus diesem Band NICHT eindeutig als dieselbe Frist zu identifizieren, moeglicherweise verschiedene Bezugspunkte (Bau-Nachweis-Frist vs. Gesamtfrist) → heute (Index, GOAL v8): **bis 15.09.2026**.

**STAND:** UEBERHOLT (Frist 27.07. war ausdruecklich nur Zwischen-Abgabe; aktuelle Frist laut Index 15.09.2026).

**VERWEISE:** `[[feedback_new_golden_all_axes_xml_gt320]]` (in-index=1) · `[[project_62_planer_universal_cache_log_claim_compare]]` — **Datei existiert, in-index=0** (Cluster-Fund) · `[[feedback_mess_tooling_default_vereint_eine_ceb]]` (in-index=1).

---

## 9. project_handout_ap1_15_code_nachzug_audit_20260702.md
**THEMA:** 15 Arbeitspakete, Code zieht Thesis nach
**TYP:** project

**FAKTEN:**
- Quelle (autoritativ): `thesis/diplomarbeit/sessions/2026-07-02-handout-implementierungsagent-audit-code-todos.md` + Audit `2026-07-02-audit-thesis-vs-code.md` (ultracode, **151 Claims: 99 OK / 50 divergent**).
- **OWNER-WORT (Grundsatz):** "Thesis beschreibt den faktischen Sollstand — Code zieht nach."
- Tasks: AP-1→#235 … AP-15→#249. P0 = AP-1..7 (#235-#241) blocken #156 (M3-Lauf). **AP-1 (#235, POD branch_misses+throughput = ABI-Bruch)** und **AP-7 (#241, SwissTable-S22 aendert T0-Registry)** blocken zusaetzlich **#215** (FREEZE/320-Neubau). AP-12 (#246) blockedBy AP-2 (#236). AP-14 (#248) blockedBy #215+#156. Neue **W4.5** zwischen W4 und W5.
- **User-Entscheidungsmatrix (BINDEND, 2026-07-02):**
  - P1 CSV: BEIDES — 16-Spalten-Basis bleibt UND `branch_misses` + `throughput_ops_per_sec` kommen dazu (Cycles ist schon Spalte 6).
  - P2 Profile: ALLES als XML definierbar → **33/33 SOTA** (fehlend P08 ARTSync/P09 LOUDS/P33 VAMPIR) + **23/23 Allokator**.
  - P3 Hash: SwissTable + Knuth-OA = zwei getrennte permutierte T0-Bausteine (**S14 + neu S22**). **T0-Zaehlung→22** (vorher 21 — Text-Agent passt "21er-Nennungen" NACH Landung an). **Korrektur-Reihenfolge: 21 (alt, in Thesis-Text) → 22 (neu, nach S22-Ergaenzung, 02.07.2026).**
  - P4-P7: Code hatte recht → Text angepasst, kein Code-Handlungsbedarf.
- Fallstricke: AP-11 widerspricht #136-completed (Audit zaehlt 8 lp_* statt 14) → Verzeichnis/Naming vor Arbeit klaeren. AP-8 vendort HdrHistogram_c unter ext/ (neuer Unterordner ok, bestehende ext/** tabu). Legacy `measurement_writer.hpp` NICHT erweitern.

**STAND:** WAHRSCHEINLICH UEBERHOLT — 34 Tage alt; nachfolgende Dateien dieses und anderer Baender (AP-15-2/15-3 DONE laut File 3, S7-Serie DONE) deuten auf Erledigung grosser Teile hin, aber in diesem Band nicht vollstaendig fuer alle 15 APs verifiziert.

**VERWEISE:** `[[reference_188_4b_pool_family_store_traversable_design]]` — **DEAD LINK, Datei existiert nicht** (Verifiziert: kein File). `[[feedback_messdaten_nie_loeschen_abi_darf_brechen]]` (in-index=1). `[[feedback_tasks_list_is_user_visible_todo_keep_current]]` (in-index=1).

---

## 10. project_lager_basis_tests_dummy_strategien_stempel.md
**THEMA:** Lager-Basistests, zwei Dummy-Stempel-Strategien
**TYP:** project (modified 2026-08-06T15:41:42.362Z)

**FAKTEN:**
- Owner 06.08.2026, drei aufeinander aufbauende Nachrichten, **OWNER-WORT, verbatim:**
  1. "Wie die Stempel Test-Zeichenkette fuer die Pruefung des lager-Aufbaus mithilfe von Dummy-Textdokumenten wurde nicht gelesen??"
  2. "Das war eine Testwelle mit google tests, um die Struktur des Lagers zu pruefen und die Stempel mit Textdateien zu simulieren anstatt eines factory patterns fuer das Erkennen von Stempeln aus Binaries und Messwerttabellen (xlsx Legenden sheet wie geplant)"
  3. "Ich erwarte laut Plan eine dummy Strategie fuer den Tests des Lagers um aus simulierten Textdokumenten die Stempel auszulesen und jede Zeile verbatim auszuwerten und dasselbe mit compile Binary stubs fuer das Stempelsystem zu wiederholen (Binary compile der eigentlich nur das statische Stempel interface der Versionierung enthaelt als leere Tier-Binary). Das sind die erwarteten Basis Tests fuer das Lagersystem."
- **DAS SOLL-BILD (bindend):** Produktiv-Ziel = eine **FACTORY** erkennt Stempel aus zwei Quellklassen: (a) gebaute **Tier-Binaries**, (b) **Messwerttabellen** (xlsx, im LEGENDEN-/Info-Sheet).
  - Stufe 1 — Textdokument-Strategie: simulierte Textdokumente, Stempel **AUSGELESEN**, **JEDE ZEILE VERBATIM** ausgewertet.
  - Stufe 2 — Binary-Stub-Strategie: echt kompilierte, sonst LEERE Tier-Binary, die nur das statische Stempel-Interface der Versionierung traegt — prueft das Stempelsystem am realen ABI-Traeger ohne Achsen-Rumpf.
  - Status zu diesem Datum: "Ich erwarte laut Plan" — also GEPLANT, ob gebaut war am Objekt zu belegen, nicht anzunehmen.
- Why: einzige heutige LESER der Stempel-/Identitaets-Zeichenkette — eine Bau-Behauptung, diese werde "von niemandem gelesen", ist damit widerlegt.
- How to apply: (1) Binary-Stub-Stufe haengt am gesonderten Versionierungs-Interface (F7 Option b). (2) Kosten-Klammern (z.B. "nur wenn `batch_plan_datei` belegt") duerfen diese Tests NICHT abschalten. (3) Fehlerklasse: "niemand liest/braucht X"-Behauptungen verlangen Code UND Tests UND Planung.

**STAND:** Owner-KERN GILT als bindende Vorgabe (Datum 06.08., 4 Tage alt, keine Widerrufsspur in diesem Band). Umsetzungsstand aus diesem Band selbst UNKLAR (nur als "Erwartung laut Plan" dokumentiert, nicht als Bau-Bestaetigung).

**VERWEISE:** `[[project_lager_baeume_xlsx_doktrin]]` — **Datei existiert, in-index=0** (Cluster-Fund, dritte Erwaehnung in diesem Band). `[[feedback_versionierungs_interface_stempel_ct_namensfunktion]]` — **Datei existiert, in-index=0** (Cluster-Fund). `[[behauptungen-verifizieren-layer-vertraege-halten]]` — Schreibweise mit Bindestrichen statt Unterstrichen; als Datei mit Bindestrichen existiert sie NICHT, die Unterstrich-Variante `feedback_behauptungen_verifizieren_layer_vertraege_halten.md` existiert und ist in-index=1 — moeglicher Tippfehler/Schreibweisen-Bruch im Quelldokument selbst, dokumentiert als Fund.

---

## 11. project_struktur_regression_geteilte_klone_statt_instanz_repos.md
**THEMA:** Struktur-Regression geteilte Klone, Alt-Naming
**TYP:** project

**FAKTEN:**
- **OWNER-WORT (2026-07-07, sinngemaess mit Zitatkern):** Zur Zeit der Entwicklung der lokalen Matrix-"Klone" gab es nur Opus 4.1, und es war **nie die Absicht, Klone zu erzeugen** — jedes Projekt muss bestehende Module mit **eigenen separaten Repo-Instanzmodulen** anbieten. "Das Vorgefundene ist eine Struktur-Regression."
- Belege (read-only erhoben):
  - `comdare-config-module` existiert als **ZWEI** GitLab-Projekte in zwei Familien-Gruppen: `comdare/modules/comdare-foundation/comdare-config-module` **id 156** UND `comdare/modules/comdare-config/comdare-config-module` **id 155**.
  - Gruppen-vs-Ordner-DIFF (`docs/sessions/20260707-gitlab-gruppen-vs-ordner-DIFF.md`) dokumentiert **268/294 Abweichungen**.
  - Altfall: `Modules/comdare-cacheengine-all` bettet DASSELBE Research-Remote ein statt einer eigenen Modul-Instanz.
  - Einzige GEWOLLTE Ausnahme: prt-art (super-Submodul + Research-Arbeitskopie) — Arbeitskopien EINES Forschungsrepos, KEINE Regression.
- **NAMING-REGRESSION (User-Ergaenzung 07.07., gleiche Kategorie):** Die Woerter **"redcomponent"** und **"bep"** sind Struktur-Regression. **Marke = Comdare** (alle Produkt-/Modul-/Namespace-/Repo-Namen); **Firma = "BEP Venture UG"** (NUR juristische Entitaet, in LICENSE-/EULA-/Rechtstexten korrekt zu erhalten). Beispiele Regression: `include/redcomponent/...` in 4 behaltenen foundation-master-Branches (Historie: Rename-Welle "redcomponent-* → comdare-*" P3.1/S2683 lief bereits, Reste existieren); tote `BEPBuildSystem`-cmakePackage-Referenz; "BEP-EULA" als Produktlabel.
- How to apply: (1) keine neuen geteilten Einbettungen/Klone. (2) Aufloesung ist **#274-Migrationsarbeitspaket**, NICHT Teil der Branch-Konsolidierung. (3) Remote-Anlagen/Transfers nur mit User-GO je Schritt.

**STAND:** Naming-Doktrin-Teil ("Marke=Comdare, Firma=BEP Venture UG") GILT weiterhin, deckungsgleich mit aktuellem Index-Eintrag "EIGENTUM" (Thesis=BEP privat, CacheEngine=BEP Venture UG/Comdare) — dieser File liefert die **Begruendung/Historie** dazu. Klon-Regressions-Aufloesung (#274) selbst: Status aus diesem Band UNKLAR.

**VERWEISE:** `[[feedback_standardprozess_research_zu_product_matrix_3d]]` — **Datei existiert, in-index=0** (Cluster-Fund). `[[project_cache_engine_research_vs_cacheengine_all_split_todo]]` — **Datei existiert, in-index=0** (Cluster-Fund, obwohl explizit im urspruenglich vorgelegten Index-Schnappschuss als "[286=Forschung]" erinnert — im Live-Abgleich jetzt nicht mehr gefunden, siehe methodischer Hinweis oben). `[[feedback_diplomarbeit_4_projects_local_clones_keep_in_sync]]` (in-index=1). `[[feedback_consult_analysis_backups_via_ultracode_before_decisions]]` (in-index=1). `[[feedback_remote_deletion_requires_explicit_user_authorization]]` (in-index=1).

---

## 12. project_thesis_19_26_22_deferred_until_cluster.md
**THEMA:** TODOs #19/#22/#26 cluster-gated, PMC-Aufhebung
**TYP:** project (modified 2026-08-09T13:52:20.713Z — **sehr frisch**, 1 Tag alt zum Stand "heute"=10.08.; Frontmatter-`name:` lautet `project-thesis-19-26-22-deferred-until-cluster` mit Bindestrichen, der tatsaechliche Dateiname nutzt Unterstriche — Diskrepanz Frontmatter/Dateiname selbst ein kleiner Fund)

**FAKTEN:**
- **User-Entscheidung 2026-06-01** (autonomer TODO-Sweep, `/goal` "uebrige TODOs abarbeiten"):
- **#19** (jemalloc/tcmalloc/hoard/scalloc echt linken) + **#26** (reale PMC-Hardware-Counter): lokal physisch NICHT abschliessbar. **MESSUNG (literal verifiziert):** kein vcpkg/WSL-gcc/nativer gcc/autoconf fuer #19; **kein Intel-PCM/MSR-Device fuer #26.** Bleiben per Compile-Flag abgeschaltet (`USE=ENABLE&&HAVE`, HAVE=OFF → Stubs; PMC = `NullPmcSource`). Beschaffungs-Specs GELIEFERT 2026-06-01 (Workflow `wtgq51wnz`): `docs/sessions/20260601-19-vendor-allokatoren-beschaffungs-spec.md` + `docs/sessions/20260601-26-pmc-counter-beschaffungs-spec.md` (reale **6 POD-Felder** → IntelPcm/LinuxPerf/PAPI/likwid-Drop-ins). Mechanik real bewiesen an mimalloc/snmalloc/dlmalloc.
- **#22** (6 cache-engine-Submodule-Repos: `comdare-{cache-engine-core,search-engine,measurement,isa-dispatch,build-tools,test-system}`): **KERN-BEFUELLUNG DONE 2026-06-01** — 6 Repos mit **120 Header** + Scope-README + INTERFACE-CMakeLists befuellt+gepusht, Parent-Pointer gebumpt (CE **ce32e84**/DA **129b597**). Non-destruktiv: Monolith libs/ unveraendert, modules/ NICHT im Build-Graph → **MESSUNG: Build gruen, Smoke 5/5.** Verbleibt: echte Konsumptions-Migration (gated auf GitLab-/DependencyManager-Reife).
- Cluster-Kontext (User 2026-06-01): Cluster-dev laeuft; Cluster-prod fast bereit; GitLab-Server laeuft; ZIH-externe-Ressourcen bald bereit — #19/#26/#22 sollten dann wieder aufgenommen werden.
- Diese Session abgeschlossen: #49-E/F (YCSB Scan/RMW via IScannableTier), #4 (masstree is_original 4/4), #9 (axis_04 Node{N}Layout→NodeType).

**WIDERSPRUCH — GROSSER FUND, PMC-Verfuegbarkeit gedreht:**
- **ALT (2026-06-01, MESSUNG damals):** "kein Intel-PCM/MSR-Device fuer #26" → PMC-Integration lokal NICHT moeglich, per Compile-Flag als `NullPmcSource` deaktiviert, auf Cluster-Verfuegbarkeit vertagt.
- **NEU (Nachtrag, explizit datiert 09.08.2026 in dieser Datei, Bezug auf Owner-Wort 06.08.2026):** **OWNER-WORT, verbatim:** "es ist ja PMC vorhanden, also MUSS es auch mit eingebaut und gemessen werden." — "Die Blockade dieses Eintrags ist aufgehoben." Der alte Sperr-Zustand gilt explizit **nicht mehr**: "Der Eintrag bleibt als Historie stehen, ist aber nicht mehr geltend."
- Das deckt sich unmittelbar mit dem im Auftrag genannten "offenen Owner-Entscheid mit Frist" zur PMC-Mikroarchitektur-Trennung — diese Datei liefert die **Vorgeschichte** (warum PMC ueberhaupt als "nicht vorhanden" galt) und den **Umkehrpunkt** (06./09.08.2026), nicht aber Details zu "Mikroarchitektur-Trennung" oder einer konkreten Frist selbst — die duerften in einer anderen, noch unentdeckten Datei liegen.
- Toter Verweis explizit in der Datei selbst benannt: **`[[project-active-goal-directive]]` zeigte ins Leere — die Datei existiert nicht** (vom Autor der Datei selbst am 09.08. so festgehalten).

**STAND:** #19/#26-Kernaussage ("PMC lokal nicht vorhanden") **explizit UEBERHOLT seit 06.08./dokumentiert 09.08.2026** — heute gilt das Gegenteil (PMC vorhanden, Einbau + Messung ist Pflicht). #22-Stand (Kern-Befuellung DONE, Folgephase offen) aus diesem Band nicht weiter verifizierbar, vermutlich noch GILT als offener Punkt.

**VERWEISE:** `[[reference_goal_v8_und_tdd_vertrag]]` (in-index=1 — **der aktuelle ⭐-ZIEL-Eintrag des Index selbst**, direkte Verbindung dieser Datei zum lebenden GOAL-Dokument). `[[project-active-goal-directive]]` — **DEAD LINK, Datei existiert nicht** (von der Quelldatei selbst als tot erkannt, s.o.).

---

## 13. reference_alt_mess_csv_archiv_struktur_modernisierung.md
**THEMA:** Alte Mess-CSV strukturell veraltet, Archiv
**TYP:** reference

**FAKTEN:**
- **OWNER-WORT (26.07., verbatim):** "Durch die Umbrueche sind die alten Mess-csv hoechstens etwas fuer das Archiv, aber wir modernisieren die Struktur nach Plan."
- Alt-Mess-CSV (Beispiel: `tier150_measurements.csv`, **5760 Zeilen**, **17-Segment-binary_ids**, **160 Felder**) sind durch **binary_id 17→18** + **ABI 6→7** + **POD 1272→1344** + xlsx-Umstellung STRUKTURELL veraltet → Archiv-Wert, kein aktiver Mess-Bestand.
- ABER Messdaten-Doktrin gilt weiter: Dateien byte-UNVERAENDERT (nie loeschen/aendern). Zugriff nur ueber versionierten Reader: akzeptiert **160 UND 169 Felder**; normalisiert 17-Segment-Alt-ids beim LESEN durch Anhaengen von `/persistence_target=persistence_memory_only` (inhaltlich korrekt: jede Alt-Messung WAR memory_only). Byte-Hash-Wache auf der Datei.
- Neue Struktur (Ordner-Kaskaden je Achsen-Typ + xlsx-Default) ist der Weg vorwaerts; **Voll-Messung ab 01.08.** erzeugt frische Daten in neuer Struktur. Alt-CSV bleiben als Archiv daneben liegen.
- Konsequenz fuer Prof. Habich: **die ERSTEN frischen Mess-CSV der neuen Struktur (aufs NAS) sind der Beweis**; Alt-CSV sind nicht vorzuzeigen.

**STAND:** Doktrin-Kern (Messdaten nie loeschen, Alt-CSV=Archiv) GILT durchgehend, deckungsgleich mit Index "Messdaten bleiben"/"BU=Rohdaten". Ob "Voll-Messung ab 01.08." wie geplant stattfand, ist aus diesem Band NICHT verifizierbar (14 Tage alt zum Zeitpunkt der Erhebung, aber Aussage betrifft ein Datum in der Zukunft der Datei selbst).

**VERWEISE:** `[[project_lager_baeume_xlsx_doktrin]]` — **Datei existiert, in-index=0** (Cluster-Fund, vierte Erwaehnung in diesem Band — dies ist die am haeufigsten referenzierte, aktuell unverlinkte Datei im gesamten Band).

---

## 14. reference_buildsystem_scripts_posix_no_grep_p.md
**THEMA:** grep -P Portabilitaets-Falle im Buildsystem
**TYP:** reference (originSessionId c6f15797-7fa1-4e66-874f-55631afe1d28)

**FAKTEN:**
- **MESSUNG/verifiziert (2026-07-03):** Bash-Parser des `cd-buildsystem` (z.B. `dependency-manager/scripts/dependency_resolver.sh`) parsen XML mit `grep -oP "<tag>\K[^<]+"` und `grep -ozP "(?s)<block>.*?</block>"`. `-P` (PCRE), `\K` und `(?s)` sind **GNU-grep-only** und brauchen UTF-8/unibyte-Locale.
- Auf **msys (Windows-Git-Bash)** wirft es `grep: -P supports only unibyte and UTF-8 locales`; **Alpine/busybox** und **macOS/BSD grep** kennen `-P` gar nicht → jeweils **leerer Extract**, und `2>/dev/null` verschluckt den Fehler → Folgefehler "empty node name" + falsche "Circular dependency". Auf Linux-CI (GNU-grep, UTF-8) laeuft es.
- Portabler Ersatz (angewandt in `dependency_resolver.sh`, **commit 6964ee7**):
  - Element-Text: `printf '%s\n' "$xml" | grep -o "<${el}>[^<]*" | head -1 | sed "s|^<${el}>||"`
  - Attribut: `... | grep -o "${a}=\"[^\"]*\"" | head -1 | sed "s|^${a}=\"||; s|\"\$||"`
  - Multi-Line-Block: awk-Helper `_comdare_xml_block` mit `index($0,"<t>"){f=1} f{print} index($0,"</t>"){exit}` (POSIX, kein Regex).
  - Plus `.gitattributes` `*.sh/*.cmake text eol=lf`.
- **STAND 2026-07-03: 5 Module portabel** (dependency-manager 3 Dateien, core interface.sh+lib/local_root.sh, compiler-manager, package-manager — je `bash -n` OK, 0 grep-P, beide Remotes). Nebenbefund: `'name="\K'`-Doppelescape war latent auch auf Linux kaputt.
- **GROSSER REST, zu diesem Datum offen:** `build-utilities`-Referenz-Parser `scripts/xml_parser.sh` (~60 Stellen) + `xml_load.sh` (~30 Stellen) = **~90 variantenreiche Stellen** → eigene systematische Welle noetig. Plus 2 Multi-Block-Fallbacks (resolver:915, downloader:681). Test-Gate Resolver: `tests/run_dijkstra_smoke.sh` (gruen).
- **META-LEKTION:** Read-only-Discovery-Agenten hatten den Smoke-Test als "lauffaehig" bezeichnet, **ihn aber NIE ausgefuehrt** — er war rot. Tests/Behauptungen ueber Lauffaehigkeit immer durch tatsaechliches Ausfuehren verifizieren.

**Direkter Bezug zu heutigen Werkzeug-Fallen:** Diese Datei (03.07.2026) beschreibt exakt dieselbe Fehlerklasse, die der aktuelle Auftragstext selbst als Warnung fuehrt ("/usr/bin/grep ABSOLUT aufrufen — das blanke grep ist ugrep und bricht bei -P ... mit STILLER NULL ab"). Der Index fuehrt inzwischen `reference_ugrep_ascii_gate_stille_null` als eigenstaendige, VERLINKTE Referenz zur "stillen Null" bei ugrep — diese Datei (14, unverlinkt) ist die **historische Vorlaeufer-Diagnose derselben Fehlerklasse** an einer anderen Stelle des Buildsystems (Bash-Skripte statt Bash-Tool-Aufruf). Empfehlenswerte Verlinkung im Konsolidierungsdokument als Vorgeschichte/Beleg.

**STAND:** Kern-Erkenntnis (grep -P bricht still auf Nicht-GNU-grep) GILT als technisches Dauerwissen. Status des "GROSSEN RESTs" (~90 Stellen in xml_parser.sh/xml_load.sh) aus diesem Band UNKLAR, ob seither abgearbeitet.

**VERWEISE:** `[[feedback_no_success_marks_without_literal_output]]` (in-index=1). `[[feedback_verify_ist_state_before_gross_tasks]]` — **DEAD LINK, Datei existiert nicht.** `[[project_comdare_db_maintenance_standard_and_buildsystem_escalation]]` — **DEAD LINK, Datei existiert nicht.**

---

## Bearbeitungs-Nenner

**14 von 14** Dateien aus `/home/comdare/.claude/jobs/5a19728e/tmp/band_02` vollstaendig gelesen und extrahiert (Zeilen 1–14 der Bandliste; Zeile 15 war leer/nicht vorhanden).

**Groesster Cluster-Fund dieses Bandes:** `project_lager_baeume_xlsx_doktrin.md` — existiert, ist im Live-Index (Stand 2026-08-10 08:01 UTC) **nicht verlinkt**, wird aber von **vier** Dateien dieses Bandes (7, 10, 13 sowie indirekt weitere) als zentrale Referenz fuer die xlsx-Lager-Doktrin gebraucht. Hoechste Prioritaet fuer Rueckverlinkung.

**Zwei belegte WIDERSPRUCH-Funde gegen aktuell kursierende Annahmen:**
1. **Runner-Concurrency-Lineage** (File 5, 12.07.2026): dokumentierter Zwischenwert "prod1-concurrency 2→3" — ergaenzt die im Auftrag genannte Kette 2 (Wellenplan, stale) → 4 (heutige Wahrheit) um einen bisher unbekannten Zwischenschritt 3.
2. **PMC-Verfuegbarkeit gedreht** (File 12, Nachtrag 09.08. zu Owner-Wort 06.08.): die 2026-06-01-Basisannahme "kein Intel-PCM/MSR-Device, PMC lokal nicht verfuegbar" ist seit 06.08.2026 explizit per Owner-Wort aufgehoben ("es ist ja PMC vorhanden, also MUSS es auch mit eingebaut und gemessen werden") — direkte Vorgeschichte zum im Auftrag genannten "offenen Owner-Entscheid" zur PMC-Frage.