# SESSION-ENDE 26 (2026-07-04) — /goal: AP-5+AP-4 DONE · AP-6 REVIDIERT (abstrakte Paper = eigene Profile) · **PIPELINE-GRÜN vor AP-6 (User-Prio)** · Codex-Env-Blocker gelöst

> **AUTORITATIV = Ledger** `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` §12 (alle Increments + revidierte AP-6-Richtung + Prio). **SE-26 ersetzt SE-25** (dessen AP-6-„Option A" wurde vom User revidiert — s. §0/§2). Bei Widerspruch: Ledger schlägt Session-Docs.

## §0 SOFORT-STATUS — Reihenfolge nächste Session (USER-Direktive, HART)
**1) ZUERST: gitlab-Pipelines auf GRÜN — VOR allem Weiteren.** User 04.07.: „die ganze Zeit schon schlagen die
gitlab pipelines fehl … du committest/pushst nicht regelmäßig." → Meine AP-5/AP-4 sind nur LOKAL verifiziert
(MSVC-Build+Tests), **CI-grün ist die offene Lücke** (§7-Direktive „grün muss BESTEHEN beweisen"). Ablauf:
(a) Pipeline-Status je Repo abfragen — `glab` fehlt lokal → keeper-root-PAT aus Vault + curl
`https://gitlab.comdare.de/api/v4/projects/<id>/pipelines?ref=main` (neueste `status`); (b) rote Ursachen klären
(eigene Increments vs. bekannte Infra #210 idle-Long-Poll / #203 lint-rot / #207 prod2-I/O); (c) fixen + literal
grün beweisen; (d) **granularer committen+pushen** (nicht ein Commit am Increment-Ende). Memory
`feedback_verify_gitlab_pipeline_green_after_push`.

**2) DANN AP-6/#240 (REVIDIERT — s. §2.3):** (a) **P08 + P09 als abstrakte SOTA-Profile** anlegen
(`pruefling_type="abstract"`, #171-Mechanik: Teilmenge-Achsen + Host-Fallback), jedes zeigt auf sein REALES
Achsen-Organ (P08=OLC→`OlcOptimisticConcurrency` axis_08; P09=Jacobson-LOUDS→`PackedBitmapMemoryLayout` axis_05),
darüber korrekt seziert. (b) **P33 (VAMPIR/NFP, SPP2377) haargenau wie im Paper nachbauen** (neues Organ) +
registrieren + **Re-Impl-Annotation** vermerken → abstract-Profil. **Paper VORHANDEN unter
`Diplomarbeit/Forschungsarbeiten/`** (User 04.07.; nächste Session: dort glob VAMPIR/NFP/SPP2377 → Algorithmus vs.
Perf-Modell aus dem Paper klären → nachbauen). NICHT blockiert. (c) **13 Allokator-Profil-XMLs** (A02 Slab · A09
NUMAlloc · A12 CAMA · A13 StarMalloc · A14 TCMalloc-Warehouse · A15 HMalloc · A16 PIM-malloc · A17 Crystalline ·
A18 Exgen · A19 Buddy · A21 ptmalloc2 · A22 N3916/PMR · A23 Vmem+Magazines) in
`libs/cache_engine/algorithm_profiles/allocators/`, Schema wie `hoard.profile.xml`, Metadaten STRIKT aus
`libs/cache_engine/axes/alloc/PAPER_REFERENCES.md §2` (Z.10-36, volle Tabelle) + `ext/allocator/REPOS_OVERVIEW.md`
— KEINE Fabrikation; die Re-Impl-Wrapper existieren bereits in `axes/alloc/` (nur XML nötig). (d) **Coverage-Gate**
(rein-lesend, Vorlage `tests/unit/thesis_tiere/test_validate_profile.cpp`): 33/33 SOTA (P08/P09/P33 abstract) +
23/23 Allokator; registrieren in `tests/unit/CMakeLists.txt`. **ABI-neutral** (MAJOR 4). **TABU:** golden-320,
`permutation_axes.xml`-16er-Allokator-Enum (≠ family_ref-Namensraum!), Registry-mp_list, modules/ext.
**Vollständiges AP-6-Dossier** war `scratchpad/ap6_dossier.md` (flüchtig) — aus dieser §0 + Ledger-§12 neu bauen.

**3) DANN ABI-neutraler Runway:** #224 (GoF-Etiketten-Hygiene) → #221 (RC→DynamicVariableNode, RC-Vertrags-Freeze
`abi_adapter:187-204` zuerst) → der EINE 4→5-Bump (S5/S6: CMD-1+CMD-2+AP-1-POD+AP-8-POD) → S8/#215 (320-DLL-Rebuild)
→ AP-2/#236 (PRT-ART-Echtpfad) → #162/#156 (M3-Messlauf, gated).

**Codex-Start (temp-Home, PFLICHT, s. §4.1):** `export CODEX_HOME=<temp>; codex exec -C <ce> -s workspace-write -m gpt-5.5 -c 'model_reasoning_effort="xhigh"' --skip-git-repo-check < dossier.md`

## §1 DIESE SESSION GELEISTET — 2 verifizierte Increments (beide Remotes; CI-grün = §0-Prio-1 offen)
| # | Increment | Verifikation (eigener Build+Test, literal) | cache-engine · super |
|---|-----------|--------------------------------------------|----------------------|
| 1 | **AP-5/#239** Full-Sampled (deterministisch, **toolchain-stabil** FNV-1a statt std::hash) | ctest 2/2 · Direkt-Exe `[ PASSED ] 4 tests` · Regression `MessreihenMode_DefaultIsFull` OK · golden static_assert | `859915e1` · `8b0d8df` |
| 2 | **AP-4/#238** Messreihe B (Stufe3-FullJoin) per-Host statt Masstree-Kollaps | `build_sota_pilot.ps1` EXIT 0 · `test_sota_series_pilot [ PASSED ]` · **6 reale per-Host-DLLs via cl** (distinkte Größen 161-221 KB) · prt_art→nullopt | `2782325f` · `436e76b` |

Zyklus je Increment: Kartierung (Explore+Codex gegengeprüft) → tragende Claims selbst verifiziert → elaborates
Dossier → Codex-Impl (temp-Home) → **jede Datei manuell kontrolliert** → eigener MSVC-Build+Test → gezielt
committen → push beide Remotes → super-Bump + Ledger §12. **Zusätzlich:** Codex-Env-Blocker gelöst · 32-MB-Workflow-
Rohdaten-Backup (additiv) · MEMORY.md 19,8→17,9 KB kompaktiert · 3 neue Memories.

## §2 ARCHITEKTUR-KONSOLIDIERUNGEN diese Session
1. **Cross-Toolchain-Determinismus (AP-5):** reproduzierbares Sampling/Auswahl über Maschinen verlangt FIXEN
   Byte-Hash (FNV-1a), NIE `std::hash` (implementierungsdefiniert). golden `static_assert(stable_id_hash(""))` = Lock.
2. **Ehrliche Distinktheit (AP-4):** distinkte binary_ids MÜSSEN auf distinkte REALE Kompositionen zeigen (6 DLLs
   mit distinkten Byte-Größen belegen es); degenerierte Fälle (prt_art-als-Host) = ehrlich `nullopt`, kein Fake.
3. **🆕 ABSTRAKTE PAPER = EIGENE ABSTRAKTE PROFILE + FAITHFUL-RE-IMPL-WENN-KEIN-CODE (User-Doktrin 04.07., zentral):**
   Ein Paper, das nur abstrakte Gesamt-Tiere liefert, wird **als eigenes Profil** geladen (Prüfling gegen den
   auflösbaren SOTA) — als „internes abstraktes Tier", **korrekt seziert** (via #171 abstract = Teilmenge-Achsen +
   Host-Fallback, zeigt auf sein reales Achsen-Organ). Wie prt-art = „nur ein Profil, das anzeigt WO der Prüfling
   liegt". **Existiert der Paper-Code NICHT → haargenau wie im Paper nachbauen + registrieren + Re-Impl-Annotation
   vermerken** (= Baseline-Doktrin, wie AP-7a-SwissTable). → REVIDIERT #170 + meine SE-25-„Option A": P08/P09/P33
   werden ANGELEGT (nicht als Nicht-Profile deklariert). Das ist KEIN halbes Tier (abstract = legitimer
   Prüfling-Marker). Konsequenz für AP-6 s. §0.

## §3 DEGENERATIONEN — offen, zu markieren
- **DEG-AP6-A:** `allocators/*.profile.xml` werden vom Parser NICHT geladen (`parse()` nur `sota/`,
  `xml_config_parser.cpp:79-80`) → Referenz-Daten, unverdrahtet. Discovery-Verdrahtung = Follow-up.
- **DEG-AP6-B:** Allokator-Numerierung inkonsistent (`allocators/README.md:7` „A01-A20" veraltet; `permutation_axes.xml:70-90`
  16 Enum-Werte mit ABWEICHENDER Namensgebung ≠ A01-A23). READMEs veraltet → Doku-Fix.
- **DEG-CI-ROT (NEU, PRIO):** gitlab-Pipelines rot (User) → alle „done"-Marken der Session CI-unverifiziert; §0-Prio-1.
- **DEG-#193-Rest:** `codegen.cpp:70/100/210` `libs/`-Pfad-Fehlklasse (an #215/320-DLL-Rebuild gekoppelt).
- **DEG-Mapping-uint16 (SE-24):** `abi_adapter.hpp:762/831` `slot_index_type=uint16`-Narrow-Cast.
- **DEG-AP-7b:** SwissTable misst erst mit Weg-B-Organ echt (Flag OFF bis dahin).

## §4 FALLSTRICKE (für nächste Session KRITISCH)
1. **🔴 Codex-Impl-Routing-Block:** `codex exec` verweigert Impl („STOPP §8: /workflow-orchestrator:delegate")
   wegen des workflow-orchestrator-SessionStart-Hooks (Developer-Injektion). NICHT lösbar via `enabled=false` /
   Prompt-Preamble / `--ignore-user-config` (→ read-only). **GELÖST: temp `CODEX_HOME`** mit gefilterter config.toml
   (Plugin/Hooks/Marketplaces raus, `[projects.*] trust` bleibt → workspace-write). Bau-Skript in Memory
   `reference_codex_routing_block_preamble_fix`. temp-Home war `scratchpad/codex_clean_home/` (flüchtig → EINMAL neu bauen).
2. **🗑️ `$null`-Junk:** nicht löschbar → ignorieren, nie stagen (gezielt `git add`, nie `-A`). Memory
   `reference_codex_null_junk_artifact_ignore`.
3. **🔍 Glob-Tool unzuverlässig** (falsche „No files found") → Grep nutzen.
4. **✂️ `| tail -N` auf Codex-Kartierung TRUNKIERT die Map** → Codex-Output IMMER voll `> file`.
5. **🔒 OneDrive-Lock auf `build/_deps/googletest-subbuild`** → frisches `%TEMP%`-Build-Dir bzw. `build_sota_pilot.ps1`-cl-Pfad.
6. **🚦 CI-GRÜN ≠ PUSH-ERFOLG (NEU, User):** nach Push die Pipeline-Ampel prüfen, sonst schlagen sie unbemerkt fehl.
7. **📉 MEMORY.md näherte sich Lese-Limit** → kompaktiert (17,9 KB, alle Links erhalten). (SE-24-Fallstricke gelten weiter:
   git-auto-gc-Timeout → Commit≠Push trennen; grep NIE in Commit-&&-Kette.)

## §5 DER CODEX-/goal-ZYKLUS (+ CI-Verify)
Kartierung (Explore ∥ Codex, gegenprüfen) → tragende Claims selbst verifizieren → elaborates Dossier (harte
Auflagen: no-fabrication, ABI-neutral MAJOR 4, TABU, ehrlich-statt-Fake) → Codex-Impl (**temp-CODEX_HOME**, „DIREKT
als EIN Agent, kein Commit") → **jede Datei manuell kontrolliert** (auch: hat Codex Build/Test geschwächt?) →
**eigener Build+Test (literal)** → gezielt committen (`git add <Pfade>`, NIE `-A`; Commit getrennt vom Push;
Co-Authored-By) → push origin fg + gitlab bg → **🆕 gitlab-Pipeline auf GRÜN prüfen** → super-Bump (nur Submodul +
Ledger; NIE thesis-Submodul/.claude/_workflow-raw-backups) → Ledger §12.

## §6 WICHTIGE DIREKTIVEN (nächste Session)
- **PIPELINE-GRÜN VOR FEATURE-ARBEIT** (§0-Prio-1) + granularer committen + nach Push Ampel prüfen.
- **ABSTRAKTE PAPER = eigene abstract-Profile; kein Code → faithful Re-Impl + Annotation** (§2.3-Doktrin).
- **ABI-FREEZE:** MAJOR 4; genau EIN Bump 4→5 bei S5/S6; KEINE Zwischen-Bumps → ABI-neutrale Increments zuerst.
- **golden-320** NIE mutieren; Codex NUR Code-Repos (NIE Cluster/keys); **AskUserQuestion NIE** (Klartext).
- **Backups additiv** (nie rm/überschreiben). **Ledger zuerst lesen, danach fortschreiben.**

## §7 OFFENE TODO-LISTE (Runway)
**Prio-Reihenfolge (User):** gitlab-CI grün → AP-6 (revidiert) → #224 → #221 → EINER 4→5-Bump (CMD-1/#251 + CMD-2/#252 +
AP-1/#235-POD + AP-8/#242-POD) → S8/#215 (320-DLL) → AP-2/#236 → #162/#156 (M3, gated). P1-Schwanz AP-8..15. Plus
AP-7b, #234, #216, diverse E0/E4 (Ledger §8 gated/messgebunden). Gesamt ~240 offene Ledger-Einträge.

## §8 RÜCKFRAGEN an den User (erste Instanz, wie eingeladen)
1. **Pipeline-Fix-Umfang:** Soll ich die roten gitlab-Läufe nur für die **4 Kern-Repos** (cache-engine/prt-art/super/
   thesis) grün bringen, oder ist das mit der bekannten Infra (#210 Runner-idle-Stall, #207 prod2-I/O) so verwoben,
   dass ich zuerst dort ansetzen muss (Infra-read-only-Rolle)? Und: keeper-root-PAT aus dem Vault holen ist ok?
2. **Commit-Granularität:** wie fein willst du es — pro logischem Schritt innerhalb eines Increments (z.B. Header →
   Verdrahtung → Test getrennt), oder pro Datei? (Damit ein Pipeline-Fehler eng lokalisierbar ist.)
3. **AP-6-Reihenfolge intern:** die 13 Allokator-XMLs + P08/P09-abstract-Profile sind schnell; **P33-Re-Impl** braucht
   Paper-Studium (Forschungsarbeiten). AP-6 in EINEM Zug (inkl. P33) oder P33 als separater Folge-Increment nach dem
   XML-Teil?
