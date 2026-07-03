# DIPLOMARBEIT — ZIELE- & OFFENE-PUNKTE-LEDGER (Single-Source)

> **Stand:** 2026-07-03 · **Validitäts-Urteil:** `PLAN_VALID_WITH_CORRECTIONS` (ultracode-Workflow `wf_eb6a7880-699`,
> 4 adversariale Validierungen + Synthese; Rohdaten `scratchpad/wf_synthese_final.json`).
> **Vorrang-Regel:** Bei Widerspruch schlägt DIESER Ledger die Session-Docs. Quellen: MASTER-EXECUTION-PLAN
> (`docs/sessions/20260703-MASTER-EXECUTION-PLAN-…`), SE-22 §3/§4/§5 (Kartierungen), Masterplan-cmd-visitor
> (`…20260702-MASTERPLAN-188-4c-…`), TODO-Konsolidierung 06-27, FF-Katalog `thesis/…/kapitel/01_einleitung.tex`.
> **Legende:** **Spur S** = strenge serielle god-header/ABI-Kette (max. 1 offener abi_adapter/Mess-POD-Increment,
> je Increment Pipeline-belegt). **Spur P** = dateidisjunkte Parallel-Wellen (Worktrees). **gated** = SCHEDULING-
> Sperre (nicht Priorität). **E0-E4** = reine Architektur-Audit-Dimension, NICHT Terminierung. Direktiven: Verify
> NUR Pipeline; keine Erfolgsmarke ohne literale Ausgabe; Push zu BEIDEN Remotes je Increment; #188 nie halb committen.

---

## §0 GOAL / MISSION (autoritativ — Referenz für `/goal`)

**Übergeordnetes Ziel.** Die Diplomarbeit implementierungsseitig **top-down vollenden**, sodass die fünf
Forschungsfragen **FF0–FF4** (§1) mit **realen, CI-verifizierten Messwerten** beantwortet werden — nicht mit
Stubs, Schein-Grün oder Phantomspalten. Die cache-engine-Permutations-Architektur (SearchAlgorithm-Achsen,
ABI-Adapter, Mess-Pfad) wird bis zur wissenschaftlich belastbaren M3-Gesamtmessung fertiggestellt, die
Thesis-PDF-Kette bleibt grün, und die Lösung ist am Ende **manuell bedienbar** (#193).

**Definition of Done (Abbruch-Kriterium der Mission).**
1. **Spur-S-ABI-Kette (§3) grün abgeschlossen** (S1✅ … S9), jeder Increment Pipeline-belegt, unter striktem
   **ABI-Freeze (§4): nach 3→4 genau EIN weiterer Bump 4→5**, der EINE 320-DLL-Neubau bei #215.
2. **Alle 8 Blocker (§2) geräumt** (B2/B7 ✅) — insbesondere Decoy-Pfad-Sperre (B5), Single-Owner-Disjunktheit
   (B6), 2-Pass-CI-Pflicht (B3), AP-2-Hart-Gate (B8).
3. **Alle vier Projekte bauen UND führen ihre volle Test-Suite in der CI aus** (§7): grün = „Tests bestehen",
   nicht nur „kompiliert" — cache-engine ~170, prt-art 12 (nach `array_256.hpp`-Fix), super 11, thesis PDF-Gate.
4. **FF3-Mess-Kette echt:** AP-2-Echtpfad (90ns-Stub raus) → #162 (≥8 Rang-1-SOTA-Lebewesen) → M3-Gesamtlauf
   (#156) mit realen Cache-Misses/PMC → Thesis-Anhang mit belastbaren Werten.
5. **#193 erfüllt:** Lösung von Hand start- und reproduzierbar (EXPERIMENT_MODE, MANUAL_RUN.md, finaler Hand-Lauf).

**Arbeitsdoktrin (aus den Validierungs-Erkenntnissen).**
- **Zwei Spuren, nebenläufig:** Spur S strikt seriell im god-header/Mess-POD-Sperrbereich; Spur P nur über
  **belegt-dateidisjunkte** Worktrees mit **Single-Owner** je geteilter Fläche (`platform/`→AP-3,
  `execution_result.hpp`, `permutation_axes.xml` erst im seriellen Integrations-Commit).
- **ABI-Sparsamkeit ist Gesetz:** kein Increment nimmt einen ABI-/POD-Bruch, der bündelbar ist; der nächste
  und LETZTE Bump vor #215 ist 4→5. Vertrags-Freezes (RC-apply vor #221) verhindern Nacharbeit.
- **Kein Schein-Fortschritt:** vor jedem Fan-out Pfade gegen **aktives development** re-verifizieren, Decoy-/
  Spiegel-Bäume gesperrt; CI beweist Korrektheit durch **ausgeführte** Tests (2-Pass erzwungen); Verify NUR
  Pipeline; keine Erfolgsmarke ohne literale Tool-Ausgabe.
- **Sauberster, nie einfachster Weg:** Manager-Modus (Codex aus Dossier, Claude korrigiert + adversarischer
  Review), god-header max. 1 offen, `modules/**`/`ext/**`/golden/Registry-mp_list TABU, Push beide Remotes je
  Increment, `#188` nie halb committen. Bei NEUER echter Architektur-Entscheidung anhalten.

**Aktuelle Front (nächste konkrete Schritte).** **Phase 0** (Sequenz §sequencing: 0a Push ✅ · 0b Pfad-Re-Verify
gegen development · 0c Spiegel-Sperre · 0d `.test`-Expansion je Projekt verifizieren · 0e ABI-Freeze deklariert)
→ dann **S2 #217** (serielle Kette) NEBENLÄUFIG zu **P-0 #193** (manuelle Bedienbarkeit, TOP-PRIO). Fortschritt
wird in §12 datiert fortgeschrieben; dieser Ledger ist die Single-Source und schlägt bei Widerspruch alle
Session-Docs.

---

## §1 FORSCHUNGSFRAGEN FF0–FF4 ⟷ TASKS (Abgabe-Blocker)
Die Thesis stellt **FÜNF** Fragen (nicht drei) — je FF die besitzenden Tasks + was die Abgabe blockiert:
| FF | Inhalt | Besitzende Tasks | Abgabe-Blocker |
|----|--------|------------------|----------------|
| **FF0** | Multi-Plattform-Generalität (x86 AMD+Intel/ARM/RISC-V; „Sapphire Rapids"-Owner) | #163 (SIMD/ISA ≥2 Plattf.), #189 (Runner-Matrix), AP-13/#247 (3-ISA) | **OWNER FEHLT explizit** — heute nur implizit über gated #163/#189 |
| **FF1** | Cache-Line-/Layout-Hebel messbar | #164 (WS-Sweep>LLC, done), #167 (5 Layouts, done), #160 (CLU-Fix, done) | reale Messung #156 |
| **FF2** | Permutations-Architektur trägt (Achsen komponierbar, zero-cost) | #188-Strang (S1-S9), #250 (done), #217, CMD-1/2 | Spur S grün |
| **FF3** | SOTA-Konkurrenzfähigkeit (PRT-ART + Rang-1-Lebewesen) | **AP-2/#236 (HART, blockt #162/#156)**, #162, #178 | AP-2-Echtpfad + M3-Lauf |
| **FF4** | Reproduzierbarkeit/Provenance | AP-9/#243 (Provenance), #139 (Resume, done), quality_flag #165 | AP-1/AP-9 + Mess-Manifest |

## §2 BLOCKER — MUSS ZUERST KLÄREN (8, aus Validierung; Owner + Exit-Kriterium)
| # | Blocker | Status | Exit-Kriterium |
|---|---------|--------|----------------|
| **B1** | #193 (manuelle Bedienbarkeit, TOP-PRIO, in_progress) fehlt VOLLSTÄNDIG im Plan; Widerspruch #193=TOP-PRIO vs [E0]-ZULETZT | **offen** | Als Welle **P-0** aufnehmen (§5); Taxonomie-Widerspruch in §10 auflösen |
| **B2** | `.test`-Vorlage fehlte in ci-templates | ✅ **ERLEDIGT** (`5e46040@development`) | Expansion je Projekt verifizieren (§7-CI-1) |
| **B3** | 2-Pass-Codegen ist PFLICHT, nicht optional (sonst Schein-Grün: R5.I/F15/F.5 still SKIPPED) | **offen** | cache-engine-Job erzwingt configure→build codegen-cli→RE-configure→build tests→ctest (§7-CI-3) |
| **B4** | KEIN ABI-Bump-Budget → mehrere ungeplante Bumps + 320-Rebuilds | **offen** | **ABI-Freeze §4**: nach 3→4 GENAU EIN weiterer Bump 4→5 (CMD-1+CMD-2+AP-1+AP-8-POD), Zwischen-Bumps bis #215 verboten |
| **B5** | algorithm_profiles-Kurzpfade zeigen auf LEEREN Decoy-Spiegel (`cache_engine/` vs `libs/cache_engine/`); P-Pfade nur gegen STALE Mai-Klon geprüft | **offen** | Phase-0b: alle P-Pfade gegen aktives development re-verifizieren, auf reale `libs/`-Präfixe, Decoy sperren |
| **B6** | P-A NICHT disjunkt: AP-3∥AP-13 teilen `platform/`-Header; AP-2∥AP-8 teilen `execution_result.hpp` | **offen** | Single-Owner: `platform/`→AP-3 (AP-13 danach rebasen); `execution_result.hpp`=Single-Owner; AP-8-POD→S6 |
| **B7** | #216-H2 (ABI 3→4) muss VOR Spur-P-Fan-out gepusht sein; stale Plan-Docs | ✅ **ERLEDIGT** (`919db6c`+`20e24ff` origin+gitlab) | Plan-Docs-Staleness (§9) fortlaufend pflegen |
| **B8** | AP-2/#236 ist mess-validitäts-KRITISCH (FF3, „sonst Lauf wertlos"), blockt #162/#156 | **offen** | AP-2 als HARTES Gate an den Kopf von Spur P (§5), markiert „blockt #162/#156" |

## §3 SPUR S — SERIELLE GOD-HEADER/ABI-KETTE (S1..S9; je Increment Pipeline-belegt, max. 1 offen)
| S | Task | ABI | Scope / Regel | Status |
|---|------|-----|---------------|--------|
| **S1** | #216-H2 (`tier_reset_statistics()` daten-erhaltend nach Load) | **3→4 (committet)** | observable_tier + abi_adapter + perm_runner + ABI-Header + test_216h2 | ✅ **DONE** (`20e24ff`), Pipeline verifiziert contract:conformance +test_216h2 +test_v41_anatomy_module_abi |
| **S2** | #217-2a Container-Kapazitäts-Constraint (Array=Container, KEINE neue Gattung) | neutral | GENERISCHE min/max Größe/Füllmenge/Key-Bereich als Container-Concept-Eigenschaft (verallgemeinert `max_fanout`); Guard gegen stille uint16-Trunkierung = ehrliche Limitierung; Registry/Traversal + stale-Kommentar-Wahrheit. **2b** (Container-als-node_type-Fanout-Rekursion) → #188/#234-Stufe | in Arbeit |
| **S3** | AP-7/#241 SwissTable S22 | neutral | teilt axis_03a-Registry mit #217 → **STRIKT nach #217** | offen |
| **S4** | #221 RC/DynamicVariableNode | neutral | **ZUERST IResourceControllableTier/RC-apply (abi_adapter:187-204) VERTRAGS-EINFRIEREN** (sonst CMD-1-Nacharbeit) | in_progress |
| **S5** | CMD-1/#251 (Limitations-Interface + Mess-Basis von IExecutionEngine abspalten, IAnatomyBase re-rooten) | **START Bump 4→5** | HIER beginnt der EINZIGE weitere Bump; CMD-1-Re-Root EINGEFALTET, KEIN separater Bump | offen (HOCH) |
| **S6** | CMD-2/#252 + AP-1/#235 (branch_misses+throughput-POD) + AP-8/#242-POD (p50/95/99) | **schließt 4→5** | ALLE POD/vtable-Änderungen hier; **AP-1 VOR AP-8-POD** (Schema zuerst) | offen (HOCH) |
| **S7** | #234 (#188-4b-c/D: Node-Shape-Achse + nativer Pool-Store + observe-Hooks) | neutral | schließt honest-0-DEG | in_progress |
| **S8** | #215 CoW real für die 320 = **DER EINE 320-DLL-Neubau** (Wirksamkeits-Schleuse) | konsumiert 4→5 | konsumiert alle akkumulierten ABI/POD-Änderungen | offen |
| **S9** | #224 GoF-Etiketten-Hygiene **ZULETZT** | neutral (Umbenennen) | Querschnitt abi_adapter:1871+Mess-POD+Achsen; nach ALLEN Struktur-/Namensschritten | offen |

## §4 ABI-BUMP-BUDGET / FREEZE-REGISTER (B4-Auflösung)
- **Aktueller Major: 4** (3→4 committet mit #216-H2, `20e24ff`). Magic `.A4.` = `0x434F4D444141342E`. *(Anmerkung: #216-H2-Bump war laut Validierung vermeidbar (host-Delta-Muster) — SUNK, bleibt; keine Rückabwicklung.)*
- **Erlaubter nächster Bump: GENAU EIN 4→5** bei **S5/S6** — bündelt CMD-1-Interface-Re-Root + CMD-2 + AP-1-POD + AP-8-POD-Surface.
- **VERBOTEN:** jeder Zwischen-Bump zwischen S1 und dem einzigen 320-Neubau (**S8/#215**). CMD-1 ist KEIN separater 3. Bruch — explizit in den 4→5 einfalten.
- **Vertrags-Freezes:** `IResourceControllableTier`/RC-apply (abi_adapter:187-204) VOR #221 einfrieren; `execution_result.hpp` Single-Owner.
- **320-Rebuild:** genau EINMAL, bei S8/#215. **DEG:** duplizierte ABI-Konstante `best_binary_selector.hpp` (kAbiMajor/kAbiMagic) — DRY-Auflösung in #179/S9-Nähe.

## §5 SPUR P — DATEIDISJUNKTE WELLEN (mit Single-Owner-Korrekturen)
- **P-0 (SOFORT, VOR Spur-S-Politur) — #193 [TOP-PRIO]:** EXPERIMENT_MODE-Preset-Entscheid, ExperimentDriver-SOTA-Profil-Pfad-Fix, USAGE/CLI-Korrektur, `MANUAL_RUN.md` finalisieren (lokal gate-frei); nur finaler Hand-Lauf braucht Runner-Fenster.
- **HARTES GATE (Kopf Spur P):** **AP-2/#236** (echter PRT-ART-Pfad, 90ns-Stub raus) — markiert „**blockt #162/#156**" (FF3). Prüfen ob AP-2 den Track-S-Mess-Pfad nutzt; falls ja → nach AP-1 serialisieren / aus P-A raus.
- **Welle P-A (Code, dateidisjunkt):** AP-3/#237 (**Single-Owner `platform/`**; AP-13/#247 danach rebasen, NICHT gleiche Welle) · AP-8-Vendoring (`ext/`+hdr_histogram_wrapper, **POD-Surface→S6**) · übrige echt-disjunkte Tasks. `execution_result.hpp` = Single-Owner (AP-2/AP-8 dürfen NICHT ko-editieren).
- **Welle P-B (Daten/Profile):** AP-6/#240 (33 SOTA+23 Allokator-XML) ∥ AP-10/#244 (Datensatz-Akten) · **AP-11/#245 erst nach bestätigter `load_profiles/lp_*.xml`-Existenz** am aktiven development.
- **SERIELLER Integrations-Commit NACH der Welle (EIN Schritt):** top-level `CMakeLists.txt:122`(ext/) + `libs/cache_engine/CMakeLists.txt:6`(subsystems/) + `ext/CMakeLists.txt` + 3-ISA-Matrix(AP-13) + HdrHistogram-Vendoring(AP-8) + `permutation_axes.xml`(AP-6/AP-7).

## §6 MESS-/FF-GATE-KETTE
**AP-2/#236 → #162 → #156/M3.** Alle messgebundenen Tasks mit korrektem Gate-Grund:
- **#156 M3-Gesamtlauf** — Gate-Grund KORRIGIERT: **NICHT** „HELD bis Linux+PMC" (PMC ist auf prod1 vorhanden), sondern **mehrtägiges User-Zeitfenster + MinIO-500-Artefakt-Fix + grüne Pipeline + prod2-I/O-Fenster (#207)**.
- #152 Cache-Misses · #163 SIMD/ISA-2-Plattf. · #162 PRT-ART-SOTA-Reihen · #187 PMC-Auto-Adaption · #165-Residual (quiesced-OS system_disturbed-Provenienz) — alle messgebunden → §8.

## §7 CI-TEST-HÄRTUNG (Inkremente; „grün" muss BESTEHEN beweisen — User 2026-07-03)
| CI | Inhalt | Status |
|----|--------|--------|
| **CI-1** | `.test`-Vorlage nach development (COMDARE_TEST_*_DIR/FLAGS/TARGET + 2-Pass-Prebuild + ctest --output-junit + g++-13/Retry) | ✅ `5e46040`; Expansion je Projekt verifizieren |
| **CI-2** | cache-engine **Sammel-Target `comdare_tests` via GLOBAL-Property-Registry** (nicht handgepflegte DEPENDS; fängt post-Pass-2 r5i/f15) + Hermetik-Fixes → dann Test-Stage aktiv | offen |
| **CI-3** | cache-engine-Job **MUSS 2-Pass** (configure→build codegen-cli→RE-configure→build tests→ctest); F.5/full-join entscheiden (COMDARE_CE_PRUEFLINGE=prt-art ODER out-of-scope). Klarstellung: nur R5.I/F15(+gated F.5) sind 2-Pass, R5.G Single-Pass | offen |
| **CI-4** | prt-art: **`array_256.hpp` erst REAL implementieren** (kompiliert+besteht) + alle 12 lokal → dann build:standalone auf Sammel-Target/all + ctest über alle 12 (+sanitize) | offen |
| **CI-5** | -j/RAM-Politik je Runner-Tag (prod2 -j2 < prod-amd; Schwer-Job ~113 test_v41_* auf prod-amd; Split-Option) BEVOR Hard-Gate. super braucht KEIN Sammel-Target (EXCLUDE_FROM_ALL) | super-`test:unit` `b37d702` (Probelauf offen) |
| **CI-6** | Jede neue Test-Stage zuerst allow_failure/when:manual (Probelauf); Hard-Gate erst nach erstem grünen Beweis, je Projekt dokumentiert | laufend |

## §8 AUSSERHALB-GO / DEFERRED (gated — vollständig, mit Entsperr-Bedingung)
- **Infra-Handoff (Rollen: read-only-verify):** #189 (universelle Runner ISA×OS×{bm/docker/k8s}+KVM+macOS+ZIH+Secret) · #199 k8s-deploy · #200 deploy-staging · #201 smoke-canary · #202 NAS-Writeback/Release/PDF · #204 sanitize-hart · #205 thesis-chktex-Gate (texlive-Infra) · #207 prod2-I/O→pmc:intel · #208 Runner-Upgrade · #209 MinIO-Key-Rotation · #210 idle-Long-Poll · #231 V111-SNI.
- **User-gated:** #225 (Second-Execution-Grundsatz, NUR Diskussion) · #25 (Diplomarbeit-Text, User schreibt) · #24 (Cluster-Tasks extern).
- **Messgebunden:** #156/#152/#163/#162/#187/#165 (§6) · #226 (Appendix-Limitierungen, M3-Endeinfrierung).
- **Explizit-deferred:** #125 (lazy-DLL Content-Hash) · #10 (V42-Infra+Nicht-SA-Gattungs-Docks) · #149 MP-E/#229 (Top-Down-Audit-Meta).

## §9 PROZESS / GOVERNANCE (Invarianten)
Push zu BEIDEN Remotes je Increment (prt-art: main UND development synchron). Keine Erfolgsmarke ohne literale Tool-Ausgabe.
Codex-Review-vor-done + Explore-mit-Codex-paaren. **Decoy-Pfad-Invariante:** immer gegen AKTIVES development re-verifizieren,
Spiegel-Bäume (`cache_engine/` vs `libs/cache_engine/`, `measurement/` vs `libs/common/measurement/`) sperren, NIE `modules/**`/`ext/**`/golden/Registry-mp_list.
**Worktree-Lektion:** persistent `/c/Users/benja/comdare-wt/<task>`, Codex committet im Branch, NIE `git worktree remove --force` auf uncommitted, NIE `git add -A` (→ .claude/-Leck). Plan-Doc-Staleness aktiv pflegen.

## §10 TAXONOMIE-VERSÖHNUNG (E0-E4 ⟷ Spur S/P/gated ⟷ P0-P2)
**E0-E4 = Architektur-Audit-Dimension** (NICHT Termin). **Spur S/P/gated = Scheduling.** **P0-P2 = Handout-06-27-Prio.**
Widerspruch **#193 = TOP-PRIO (User 06-27) vs. Task-Feld [E0]-ZULETZT**: AUFGELÖST → #193 ist Welle **P-0 (zuerst)**; das [E0] ist die Audit-Ebene, nicht die Reihenfolge. Vollständigkeit per dieser Tabelle prüfbar statt Handabgleich.

## §11 VOLLSTÄNDIGE OFFENE TODO-LISTE (top-down, user-sichtbar)
**A #188-Architektur (Spur S):** #216-H2✅ · #217 · AP-7/#241 · #221 · CMD-1/#251 · CMD-2/#252+AP-1/#235+AP-8/#242 · #234 · #215 · #224.
**B Mess-Gate P0 (Spur P):** **AP-2/#236 (HART)** · AP-3/#237 · AP-4/#238 · AP-5/#239 · AP-6/#240 · AP-7/#241.
**C P1 Mess-Qualität:** AP-8/#242 · AP-9/#243 · AP-10/#244 · AP-11/#245 · AP-12/#246 · AP-13/#247 · AP-14/#248 · AP-15/#249.
**D CI-Test-Härtung:** CI-1✅ · CI-2..CI-6 (§7).
**E User-Prio:** #193 (P-0: B✅ A✅ · offen C-Demo-Preset/D-MANUAL_RUN) · #179 (Wartbarkeits-Sweep, XL) · #186 (EPIC CI, laufend).
**F Deferred/gated:** §8-Liste.
**Fehlende TODOs aus Validierung (23, eingeordnet):** M1→#193(§5) · M2→#179(§11-E) · M3→#10(§8) · M4→#19-Allokatoren-echt-linken · M5→#125(§8) · M6→#149/#229(§8) · M7→#187/#165(§8) · M8→#184/#185 als CODE-Aufgaben (nicht Text-Agent) · M9→FF0-Owner(§1) · M10→ABI-Freeze(§4) · M11→RC-Vertrags-Freeze(§3-S4) · M12→#216-Push✅ · M13→AP-8⟵AP-1(§5) · M14→Spiegel-Sperre(§9) · M15→Integrations-Commit(§5) · M16→P-Pfad-Re-Verify(§5) · M17→AP-2-Track-S-Prüfung(§5) · M18→.test-Merge✅ · M19→comdare_tests-Registry(§7-CI-2) · M20→F.5-Entscheid(§7-CI-3) · M21→Hermetik-Audit(§7) · M22→prt-art-alle-12(§7-CI-4) · M23→-j/RAM-Politik(§7-CI-5).

## §12 FORTSCHREIBUNGS-LOG
- **2026-07-03:** Ledger erstellt aus ultracode-Validierung (`wf_eb6a7880-699`, PLAN_VALID_WITH_CORRECTIONS). S1/#216-H2 DONE (`20e24ff`, ABI 3→4). CI-1 `.test`-Vorlage `5e46040`. super-`test:unit` `b37d702` (Probelauf offen). B2/B7/M12/M18 erledigt. Nächster Schritt: Phase-0-Vorbedingungen (§ Sequenz 0a-0e) → dann S2 #217 ∥ P-0 #193.
- **2026-07-03 (§0-Goal + Phase-0-Start):** §0 GOAL/MISSION als `/goal`-Referenz ergänzt (`b15904f`). super-Submodul-Bump cache-engine→`20e24ff` (`a26f52d`, B7/0a vollständig ✅). **Phase 0b/0c ✅:** alle Spur-P-Pfade am aktiven Repo (`20e24ff`) real verifiziert (AP-2 EE-Adapter+execute_engine_command+execution_result · AP-3 platform/i_platform_probe+platform_probe/cpuid_probe · AP-13 c02_pinning_engine+platform/core_layout · AP-11 8 lp_-XMLs) — die B5-Decoy-Warnung galt dem stale Mai-Klon, NICHT dem Ist. **B6-Naht bestätigt:** AP-3∥AP-13 teilen `platform/core_layout.hpp` → Single-Owner AP-3. `measurement/`-Top-Level = leerer untrackter Ordner (kein Repo-Decoy, harmlos). **S2/#217 gestartet:** Ist-Kartierung läuft (Explore a238429d) — Array-Gattung (Array256/Array65535/Vector*, native Key-Breite, KEIN uint16→uint64) — Ablauf Kartierung→Dossier→Codex→Review→Merge→Pipeline.
- **2026-07-03 (#217-Kartierung ausgewertet — ⚠️ SEQUENZ-KORREKTUR):** Explore-Kartierung belegt: **#217 ist NICHT der kleine S2-Increment** (SE-22-§3-Fehleinschätzung). K9-Kern = stille uint16→uint64-**Trunkierung** im `container_algorithm_t`-Pfad (`abi_adapter.hpp:1826-1851`, `LayoutAwareChunkedStore::key_type=uint64` hartkodiert `axis_04_node_type_chunked_store.hpp:49`) + stale „uint64-Organ-Invariante"-Kommentare (`direct_address_traversal_organ.hpp:44-49`, `composable_search.hpp:6-16`). ABI-neutral BESTÄTIGT (container_algorithm_ interner Member, extern-C-Naht uint64-only, POD unberührt). **#217 zerfällt: (2a)** ABI-neutraler Trunkierungs-/Wahrheits-Fix (Registry/Traversal-Mapping + Bereichs-Guard + Kommentar-Korrektur) = machbar als S2; **(2b)** voller native-Breite-Container-Gattung + rekursive node_type-Fanout-Einhängung = **#188/#234-entangelt, USER-Entscheid, große Stufe** (KEIN isolierter S2). **ENTSCHEIDUNG offen (User):** S2 = nur (2a) jetzt, (2b) mit #188/#234/CMD-1 planen [empfohlen] — vs. #217 ganz in die #188-Stufe. Bis Klärung: S2 pausiert, Ablauf unverändert (kein halber Increment).
- **2026-07-03 (#217-ENTSCHEIDUNG User):** „Array ist ein **spezieller Container statischer Größe**, aber ein Container und **KEINE neue Gattung** → wie empfohlen (2a jetzt, 2b mit #188)." **Design-Vorgabe (bevorzugt):** GENERISCHE Lösung — die Container-Achse drückt aus, dass **manche Container minimale/maximale Größen bzw. Füllmengen** haben (Kapazitäts-Constraint als Container-Concept-Eigenschaft, verallgemeinert `max_fanout` von array256:56/array65535:74), statt Array-Sonderfall. Damit wird der K9-Trunkierungs-Befund an der Wurzel gelöst: Key außerhalb der deklarierten Kapazität (z.B. >65535 auf Array65535) = **ehrliche Limitierung** (Guard/Meldung), NICHT stille uint16-Trunkierung. S2/#217-2a in Umsetzung: Codex im Worktree, ABI-neutral (container_algorithm_ interner Member, extern-C-uint64-Naht + POD unberührt).
- **2026-07-03 (P-0/#193-B DONE — echter Increment):** 16 tracked `.ps1` (15 via `$repo`-Muster + analyze_f15_holm.ps1 build/tests-Pfade) von Maschinen-Hartkodierung `C:\Users\benja\…` entkoppelt → Repo-Root via `(Resolve-Path (Join-Path $PSScriptRoot '..[/..]')).Path`. **FINAL: 0 tracked .ps1 mit Hartkodierung** (literaler grep-Beleg). cache-engine `243edc1` + super-Submodul-Bump `ddfd525` (origin gepusht, gitlab bg). Schwerster #193-Blocker (Maschinen-Bindung) gelöst; Skripte jetzt maschinen-portabel. **Offen #193:** Dossier A (SOTA-Profil-Pfad `experiment_driver.cpp:80/351`), C (Demo-Preset), D (MANUAL_RUN.md + `--help`).
- **2026-07-03 (P-0/#193-A DONE — echter Increment):** SOTA-Profil-Verzeichnis-Auflösung in `experiment_driver.cpp` gefixt. Der Inline-Fallback zeigte auf `comdare_root/"cache_engine"/algorithm_profiles/sota` (Vor-libs/-Move-Layout; V41.F.6 verschob es nach `libs/cache_engine/…`) und war CWD-abhängig (`comdare_root = current_path()`). Neuer Helper `resolve_sota_profiles_dir(config_dir, comdare_root)` (anon. Namespace) probiert je Anker 3 Layout-Varianten (`libs/cache_engine` · `cache_engine` · direkt) + Aufwärts-Repo-Root-Discovery bis `root_path()` (Endlos-Loop-Guard) → CWD-unabhängig, gegen comdare_root-Semantik robust; löst zugleich die **duplizierte-Fallback-DEG** an beiden Call-Sites (Phase 2 `:80` + fp_to_workload `:351`). Primärpfad `config_dir/algorithm_profiles/sota` bleibt via Variante 3 ZUERST getroffen → keine Regression. **Verifiziert:** MSVC C++23 Debug-Build `comdare_builder_experiment_driver` grün (**EXIT 0**, `experiment_driver.cpp` neu kompiliert+gelinkt) + Codex-Review **VERDICT SHIP**. cache-engine `a0b514c` (origin+gitlab gepusht). **Klarstellung:** `xml_config_parser.cpp:78-80` ist KEIN Bug (input-relativ zu `root_dir`=config_dir, korrekt — SE-23-Zeilenverweis war approximativ). **NEUE DEG geloggt (getrennter Follow-up, an #215 gekoppelt):** `codegen.cpp:70/100/210` haben dieselbe Fehlklasse (`comdare_root/"cache_engine"/…` ohne `libs/` → Modul-Include-Pfad + **stiller Skelett-Template-Fallback** statt SOTA-Body-Template) — echte Verifikation erst bei Modul-Neugenerierung+320-DLL-Build (#215-Kontext), daher NICHT in #193-A gebündelt. **CI-LÜCKE (→ §7-CI-2):** KEIN CI-Gate baut `comdare_builder_experiment_driver`/`test_experiment_driver_v13` → #193-A ist pipeline-unverifiziert (nur lokal-MSVC); ein experiment_driver-Compile-Gate gehört in CI-2. **Offen #193:** C (Demo-Preset), D (MANUAL_RUN.md + `--help`).
