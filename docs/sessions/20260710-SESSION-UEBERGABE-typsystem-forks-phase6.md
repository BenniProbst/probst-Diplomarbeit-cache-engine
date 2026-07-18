# SESSION-ÜBERGABE 2026-07-10 — Messkurven-Typsystem, Phase-6-Vorbau, Kardinalitäten-Deep-Research & die 7 blockierenden User-Forks

> **Zweck:** Vollständige Übergabe an einen anderen Agenten. Diese Datei ist so geschrieben, dass sie
> **allein** (plus das darin referenzierte Ledger) genügt, um die Arbeit nahtlos fortzusetzen. Sie enthält:
> den **exakten aktuellen Goal-Text**, **alle TODOs**, den **Memory-Stand**, die **aktuellen Ziele**, den
> **CI-/Repo-Stand** und die **konkreten nächsten Schritte**.
>
> **Modell-Hinweis:** Diese Session lief großteils als **Fable 5**, mit einem Wechsel auf **Opus 4.8**
> (`/model`) + **ultracode** (`/effort`) im letzten Drittel (ab der Kardinalitäten-Deep-Research). Kein
> Arbeitsverlust durch den Wechsel (verifiziert: der Deep-Research-Workflow lief trotz Wechsel voll durch).

---

## 0. TL;DR — Stand in fünf Sätzen

1. **Fertig und CI-grün:** die komplette DATEN_GATED-Vorstufe (Phase-6-Vorbau: `IMeasurementSource` +
   `MeasurementAxisRegistry` + E4′-Kurven-Fit-Skeleton) — **ce `c022ce05`**, Pipelines 9327/9331 success.
2. **Fertig:** ein Kardinalitäten-**Deep-Research** (71 Bestand-Befunde) hat das Doc-20-Messkurven-Typsystem
   Ebene für Ebene vermessen — **super `7b3f43e`** (BEFUND-Backup + Rohdaten committet).
3. **Bewusst NICHT committet:** ein erster Bau der compile/dynamic-Typsystem-Wurzel (`axis_binding_registry`)
   wurde adversarial reviewt, als **Doppelquelle** zu `profile_to_tree.hpp is_static` erkannt und **revertiert**
   (Doc 20 §I dokumentiert die bindende Constraint; Artefakte archiviert).
4. **Blockiert:** der weitere Typsystem-Bau hängt an **7 User-Fork-Entscheidungen** (Doc 20 §H) — sie bestimmen
   die `map<>`-Ebenen-Kardinalitäten und sind autoritativ NUR vom User zu treffen (Vorlage mit Empfehlungen unten).
5. **Repo-Stand:** ce `c022ce05` · super `main 821b1d5` → dieses Dossier + Ledger-Nachzug gehen auf **development**.

---

## 1. DER EXAKTE AKTUELLE GOAL-TEXT

### 1.1 Aktiver Stop-Hook-Goal-Text (die stehende Session-Direktive, wörtlich)

> Bitte erledige alle sichtbaren TODOs und den Goal-Text V3 im Ledger. Beachte besonders die Direktiven zur
> Striktheit der Organisationsform der Programmierumgebung, der Modulreferenzierung und der Metaprogrammierung.
> Stelle zu jeder Zeit sicher, dass alle Memories geladen und alle Direktiven klar sind. Beginne zu allererst
> aber mit offenen Plänen und halte stets die Konzeptionelle Grundlage der Durchführung zuerst sauber, bevor du
> mit einer Aufgabe beginnst. Arbeite so tief wie möglich und behandle die sichtbare TODO Liste als stack,
> behebe alle gefundenen Probleme sofort und packe sie als Stack oben auf die sichtbare TODO Liste, bis sie
> behoben sind. Wenn eine Eigenschaft gefordert ist, aber nicht benannt ist, welche Eigenschaften eine Achse
> oder ein Tier-Metapher Konstrukt haben sollte, starte einen deep research dazu, um die erforderlichen
> Eigenschaften im Sinne des Ziels der Diplomarbeit zu ergründen und den Code und die Architektur in den bereits
> gesetzten Grenzen und Design-Pattern-Rahmungen fertigzustellen.

### 1.2 Goal-Text V3 im Ledger (§13.12, AKTIV)

Der **autoritative** Goal-Text V3 steht im Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` **§13.12**
(konsolidiert 06.07., ersetzt V2 §13.4). Er ist eine **Meta-Direktive zum Abarbeiten**, kein zu schreibendes
Artefakt (frühere Klarstellung Ledger-Zeile 414). Kern-Blöcke (Volltext im Ledger §13.12, hier verdichtet):

- **KONTEXT-PFLICHT + VORRANG-REGEL:** Ledger ist Single-Source; die NEUESTE Aussage gewinnt; USER-Aussagen
  schlagen abgeleitete Doku; §9-Standing-Direktiven + jüngste §12-Einträge schlagen §0–§11. Ist-Stand vor jedem
  Edit gegen git status/log ALLER Repos + beide Remotes verifizieren.
- **ARBEITSREIHENFOLGE (1)–(7):** laut Ledger-Beleg (Zeile 393) für frühere Sessions DONE; die aktuelle Strecke
  (Schicht-Sequenz E4→E1, GO-Increments) ist das laufende Abarbeiten.
- **ENTSCHEIDUNGS-DEFAULTS DD-A..DD-E** (ex E-A..E-E, umbenannt zur Kollisionsvermeidung mit E0-E4): bereits
  entschieden — DD-A Reuse-Vendoring P2→P1→P3, DD-B CMD-1 neutral compile-time, DD-C RC-Rest via #229 deferred,
  DD-D 8er-Liste = Thesis-`tab:datasets` ∪ Bestandsakten, DD-E entfällt (#271 DONE).
- **KADENZ je Increment (11+2 Schritte):** Ist-Verifikation → fresh-context-Kartierung (Doppel-Kartierung
  Explore+Codex) → elaboriertes Dossier (keine compile-time→runtime-Degradation) → Implementierung → VOLL-REVIEW
  Zeile-für-Zeile + Metaprogrammierungs-Linse → Mojibake==0 → clang-format 22.1.8==0 → **doppelt literale**
  Verifikation (Implementierer-Beleg UND eigener g++-16-Lauf im offiziellen build/) → granularer Commit (NIE
  `git add -A`) → Push BEIDE Remotes → Pipeline STRIKT GRÜN vor der nächsten Hauptaufgabe → Ledger §12 additiv.
- **HARTE TABUS:** ABI-MAJOR==4 kein Bump ohne User-GO · golden_fullpilot_320 / permutation_axes.xml / POD
  sizeof==1416 / conformance-Oracle unantastbar (Erweiterungen nur golden-neutrale END-Appends Default-OFF) ·
  keine Attrappen (honest-0) · Messdaten/Doku nie löschen (additiv) · Remote-Repos/Branches nie löschen/anlegen
  ohne je-Repo-GO · Cluster/Runner strikt READ-ONLY (GitLab-API nur mit ROOTCA, nie `-k`) · §9-Metaprog-/
  Interface-Doktrin (nach außen nur pre-compiled Binary-Interfaces; intern Template-Metaprog zwingend) ·
  **AskUserQuestion NIE** (crasht Session — stattdessen GEPARKT-Eintrag mit Empfehlung / Klartext-Fork).
- **ESKALATION:** echter Architektur-Fork → GEPARKT + Doppel-Kartierung + Empfehlung, nie raten · Codex ohne
  sicheres Ergebnis → ultracode-Workflow · Unklarheit über Soll-Architektur → ZUERST Diplomarbeit-Text +
  Architektur-Doku nachlesen, erst bei nachweislich fehlender Doku-Stelle → GEPARKT + Doku-Increment.
- **STOP-BEDINGUNG:** wenn nur noch user-/extern-gated/HELD-Punkte übrig → Handover schreiben, Working-Tree
  sauber, committen+pushen, sauber stoppen (keine Leerlauf-Iterationen). **← genau dieser Zustand ist erreicht.**
- **GOAL-V3-ERGÄNZUNG (07.07.):** die #274/#256-Matrix-Migration ist gleichrangiger Goal-Bestandteil (Voll-Pfad-
  Referenzen in §13.12 gelistet). *Hinweis: diese Session hat NICHT an der Matrix-Migration gearbeitet — sie
  ist eine eigene, weitgehend user-/GO-gated Strecke und im Ledger dokumentiert.*

### 1.3 Ergänzende User-Direktiven DIESER Session (10.07., als Memory persistiert)

- **Selbst implementieren ab sofort** (Codex-first abgelöst): Erstimplementierung macht Claude selbst; bei
  Major-Verstößen sofort selbst nachimplementieren. (Memory `feedback_selbst_implementieren_ab_20260710_codex_abgeloest`.)
- **Goal scheint erledigt → ultracode-Verifikations-Workflow** (nicht bei offensichtlich unfertigem Goal).
  (Memory `feedback_goal_scheint_erledigt_ultracode_verifikation`.)
- **Heuristik-Messkurven-Typsystem + CoR-Filterkette + Monolith-first** — die große Architektur-Vision (s. §5,
  Doc 20). (Memory `feedback_heuristik_messkurven_typsystem_chain_of_responsibility`.)
- **Monolith-first:** cache-engine als Monolith fertigstellen; Zergliederung in die comdare-Matrix
  (cache-engine-all mit den maximal metaprogrammierbaren/generischen Bestandteilen) = eigener späterer Schritt.

---

## 2. REPO- & CI-STAND (literal)

| Repo | Branch | SHA | Zustand |
|---|---|---|---|
| ce (`comdare-cache-engine`) | main | **`c022ce05`** | sauber; Pipelines **9327+9331 success** (Phase-6-Vorbau) |
| super (`probst-diplomarbeit-cache-engine`) | main | **`821b1d5`** | sauber (bis auf 1 neue Backup-Datei, geht in diesen Handover-Commit) |
| super | development | `51b9898` (Vorfahr von main) | wird per ff auf main + Handover gehoben (Doktrin development≥main) |

**Diese Session committete (chronologisch, alle beide Remotes):**
- ce `fb67caa0` + super `5affddb` — GO-1 Limits-Entkopplung **Vorstufe** (Gates 1-3). *[Vor-Kontext dieser Übergabe: Teil der abgeschlossenen Schicht-/GO-Strecke.]*
- ce `fd8167f4` + super `b2d2737`/`d1168dd` — GO-1b Limits-Entkopplung **Produktivumschaltung** (Gates 4-6).
- ce `90653f02` + super `32b4de2`/`d1168dd` — NON_GATED-2 **Parser-/Gating-Konsolidierung** (Phase 7).
- ce `c022ce05` + super `d952c7e` — DATEN_GATED **Phase-6-Vorbau** (IMeasurementSource + Registry + Kurven-Skeleton).
- super `db06a96` — Doc 20 (Heuristik-Messkurven-Typsystem, User-Vision 10.07.).
- super `7b3f43e` — Doc 20 §G/§H (Kardinalitäten-Deep-Research, 71 Befunde) + BEFUND-Backup.
- super `821b1d5` — Doc 20 §I (axis_binding-Registry reviewt+verworfen, Doppelquellen-Constraint) + Archiv.

**Offen zu bestätigen:** super-Pipeline **9359** (`821b1d5`, docs-only) lief beim Pausen-Zeitpunkt noch — beim
Fortsetzen auf grün prüfen. **GitLab-API zeigte zuletzt HTTP 500** (transient Infra) — bei Push/Poll ggf. retry.

---

## 3. ALLE TODOs (Stack, Stand 10.07.)

### 3.1 Sichtbare Task-Liste (Board)

| # | Status | Inhalt |
|---|---|---|
| **#1** | ✅ completed | DATEN_GATED-Vorbauten: Mess-System-Phase-6-Registry + E4′-Kurven-Fit-Skeleton (ce `c022ce05`, CI grün) |
| **#2** | 🔒 in_progress, **fork-blockiert** | E4′ + Arbeitsmodus-/Hybrid-Strecke — Fundament fertig (Deep-Research + Doc 20 §G/§H/§I), Bau hängt an den **7 User-Forks (§4)** + gated #156/#215 |
| **#3** | ⏸ pending, geparkt | EXTERN_GATED-Forks — je eigenes User-GO nötig (s. §3.3) |

### 3.2 BACKLOG-Klassifikation (aus `docs/plaene/20260710-plan-code-diff-BACKLOG.md`)

- **NON_GATED (baubar, diese Session ABGEARBEITET):**
  1. Limits-Entkopplung (#229-Kern) — Vorstufe ✅ + Produktivumschaltung ✅.
  2. Parser-/Gating-Konsolidierung (Phase 7) — ✅.
- **DATEN_GATED (Code-Vorbau teils möglich, Abnahme daten-gated):**
  - Mess-System-Phase-6-Rest — **Vorbau ✅** (IMeasurementSource + Registry + Kurven-Skeleton, ce `c022ce05`);
    **Runner-/Prüf-Dock-Verdrahtung** (E1) + `<measurement_categories>`-XML + **PMC-Vollpfad #215** bleiben gated.
  - E4′-Kurven-Fit — **Skeleton ✅** (honest-empty); realer **Fit datengetrieben (gated #156/#162)**.
  - #215 → #156/#162 — Code-Seite done; fehlen DLL-Bestand + CSVs mit neuen Headern (Cluster-Fenster, mehrtägig, NIE aktiv pollen).
- **EXTERN_GATED (echte Forks, je eigenes User-GO — GO-Freigabe deckt sie NICHT):**
  - W/D/K-XML-Strecke (R1/R2) · **Dataset-Wahrheitsquelle** (`test_data_sets.xml` existiert 0× — stiller Parser-
    Slot; seit Phase 7 diagnostiziert, R2-Entscheid offen) · V32-Altlast-Fork · Framework×Workload-Bib (Schritt 13,
    6-vs-48) · P/E-Core-Domänen (**zusätzlich HARDWARE-GATED:** i9-14900KS/prod2 RMA bis ~September 2026) ·
    Fairness-Modus · H2-Score.

### 3.3 Goal-V3-Katalog-Reste (§13.12-Arbeitsreihenfolge, Stand Ledger)

Alle non-gated Katalog-Items außerhalb der Schicht-Sequenz sind laut Ledger (Zeile 414, item-belegt) DONE oder
gated. Verbleibend gated/geparkt: #266 (config-Owner) · #269/#244-Rest (6-vs-48-User-Gate) · #270b-arm64
(node7-Freeze) · AP-2/#236 (W4, vor #156) · 234-V/7b-3/#270a/264-d/#272/#273-T2 · HELD #215/#156/#162/#216 ·
**#276 = ausdrücklich LETZTE Aufgabe** (3-ISA-Teilmatrix als CI-Pflicht). Plus die **#274/#256-Matrix-Migration**
(Goal-V3-Ergänzung, eigene Strecke, GO liegt vor, in dieser Session nicht bearbeitet).

---

## 4. DER BLOCKER — die 7 User-Fork-Entscheidungen (Doc 20 §H)

Diese bestimmen die `map<>`-Ebenen-Kardinalitäten des Messkurven-Typsystems und sind laut Bestand NICHT
entschieden. **AskUserQuestion ist tabu** (crasht) — dem User als Klartext vorlegen, `entscheide nichts selbst`.
Grundlage: Deep-Research-BEFUND `docs/audits/20260710-kardinalitaeten-deep-research-BEFUND-KARDINALITAETEN.md`.

| # | Fork | Optionen (Bestand) | Empfehlung (Bestand-gestützt, NICHT entschieden) |
|---|---|---|---|
| 1 | `map<workload-type>`-Kanon | 6+3 Custom / 6+2 IH-LH / F7 A/C/E×6 (#31-Schritt-2) | 14 Kanon-LP LP01–LP14, YCSB A–F als Teilmenge |
| 2 | „Beschaffenheit" (Key/Value-Verteilung, ≥5 Facetten) | eigene `map<>`-Ebene vs. in workload-type kodiert | eigene Ebene (orthogonale Facetten) — ändert wörtlichen Typ, User-GO |
| 3 | `map<workload-size>`-Semantik | absolute N-Liste {2¹⁴…2²³} vs. maschinenrelative Cache-Regimes | absolut als Schlüssel, Cache-Regime als abgeleitetes Attribut |
| 4 | `map<operation_type>`-Kanon | Runner-6 (mit clear) vs. XSD-6 (mit Update/Range-Delete) | auf Runner-6 vereinheitlichen; clear = Phase; Update→rmw, Range-Delete→erase |
| 5 | `map<workload-framework>` | {YCSB, LP} (2) vs. 13-Framework-Registry | 13-Kanon-Registry als Vokabular, heute nur YCSB befüllt |
| 6 | Tuple-Blatt | wörtlich `tuple<property,time>` vs. Front-Menge + Objective-Tag | Blatt auf `tuple<property,time,objective_tag>` + Pareto-Front-Set — User-GO |
| 7 | Sonderstatus-Trio T2/T1/T10 | Slots entfernen vs. taggen | ALLE 19 Slots intakt lassen (T10-Entfernung bräche `kV3AxisCount=19`-ABI!), stattdessen Klassifikations-Tags |

---

## 5. AKTUELLE ZIELE (die große Architektur-Vision, Doc 20)

Volltext: `docs/architektur/20_HEURISTIK_MESSKURVEN_TYPSYSTEM_UND_FILTERKETTE.md`. Kern (User-Vision 10.07.):

- **B — Messkurven-Typsystem:** je Tier-Binary-Gesamtpermutation eine Wall-Clock-Messkurve über
  `tree<axis compile/dynamic, map<workload-framework, map<workload-type, map<workload-size, map<operation_type,
  map<axis_observer_type, tuple<observer_special_compare_property_type, time>>>>>>>` — multidimensionale
  Custom-Mess-DB; Kardinalität strategisch in **Klassen/Hierarchien** einteilen (KK-1/KK-2/KK-3, s. §G/§I).
- **C — Filterkette = Chain of Responsibility (GoF), STRIKT im CacheEngineBuilder** für die Kontrolle der
  Tier-Binary-**Generierung** (Auswertung → Filter → nächste Bau-Permutationen). Bestand: 0 Code-Treffer.
- **D — Messfehler-Erkennung:** 3-Varianten-Observer-Einbau (alle+Hybrid / nur Heuristik-Tier / keiner=Wall-Clock)
  + **komplementärer 4. Schritt** (untergebene Heuristik-Tiere ohne Observer/Benchmarks neu, Wall-Clock-Vergleich
  gegen alle bekannten Permutationen UND Paper-Algorithmen; **Paper-Vergleich geht vor**).
- **§I — BINDENDE CONSTRAINT (Review-Lehre):** die `tree<axis compile/dynamic>`-Wurzel ist **NICHT greenfield** —
  die 14/5-Klassifikation existiert bereits autoritativ in `builder/experiment_tree/profile_to_tree.hpp:68-87`
  (`is_static`, „EINZIGE Quelle dieser Dimensionen" seit Doppelquellen-Konsolidierung 18.06.). Eine compile-time-
  Registry ist erst gerechtfertigt mit **echtem Konsumenten + Producer-Konsistenz-Contract gegen build_axis_levels**
  (ODER `profile_to_tree` wird der Konsument = golden-sensitiv, eigener Increment). **NICHT erneut als
  konsumentenlose Zweitkopie bauen** — das war der Fehler, den der Review wf_0f5a1d9c abfing.

**Reihenfolge:** 7 Forks entscheiden → `map<>`-Ebenen bauen (KK-2 profil-gebunden) → CoR im CEB (KK-1/KK-3
Filter-Glieder, zero-cost/compile-time im Hot-Path) → 3-Varianten-Bau + Schritt 4 (Hybrid-Strecke) → realer
Kurven-Fit (gated #156). Alle 4 CEB-Phasen (Mess→Auswertung→Arbeits→Hybrid) sind in E4 automatisch zu dokumentieren.

---

## 6. WAS DIESE SESSION GENAU TAT (mit Review-Belegen)

1. **GO-1 Limits-Entkopplung Vorstufe** (ce `fb67caa0`): catalog_codegen_tool (XML→generierter Katalog-Header)
   + Golden-Gates 1-3. Review wf_fce92d2c: 2 CONFIRMED (Ordnungs-Normalisierung major, cacheline-Verwurf) →
   gefixt, Resume-Lauf 0 CONFIRMED. ctest 9/9.
2. **GO-1b Produktivumschaltung** (ce `fd8167f4`): Konsumenten auf generierten Katalog (build-time); zentrales
   `cmake/catalog_codegen.cmake`. Review wf_1009d16f: 5 CONFIRMED (PS1-Codegen-Mitbau major, ext-Includes-Lehre)
   → gefixt. ctest 197/197. **#229-Kern damit KOMPLETT.**
3. **NON_GATED-2 Parser-/Gating-Konsolidierung** (ce `90653f02`): 3 Reader → 1 (KF-1-DOM), stille-{}-Falle
   diagnostiziert, `COMDARE_EXPERIMENT_MODE` real verdrahtet (wert-basierter Guard + configure-FATAL_ERROR).
   Review wf_8508f98c: **10/10 CONFIRMED** alle gefixt (masstree-Entity-Korrektur bewusst eingefroren). ctest 198/198.
4. **DATEN_GATED Phase-6-Vorbau** (ce `c022ce05`): `IMeasurementSource` (vendor-neutral, eigenes MeasuredDelta) +
   `MeasurementAxisRegistry` (16 Kategorien, Enum-Drift-Gate) + `curve_fit.hpp` (honest-empty, InvalidData statt
   Ok+NaN). Review wf_c99a2132: 14/15 CONFIRMED (1 critical x==0-NaN) alle gefixt. ctest 199/199.
5. **Kardinalitäten-Deep-Research** (super `7b3f43e`): 4 Quellen-Agenten → 71 Bestand-Befunde → Kardinalität je
   Typsystem-Ebene + KK-Klassen + 7 Forks (Doc 20 §G/§H). BEFUND-Backup + Rohdaten committet.
6. **axis_binding_registry** gebaut → Review wf_0f5a1d9c (3 CONFIRMED: toter cross-layer-Include, Cap-Drift,
   **Doppelt-Wahrheit** zu profile_to_tree) → **selbst verifiziert + REVERTIERT** (Doc 20 §I, ce zurück 199 ctest).
   Der Review verhinderte einen Doppelquellen-Regress VOR dem Commit.

**Backups (alle unter `docs/sessions/backups/`, committet):** `20260710-limits-entkopplung-impl/`,
`20260710-limits-umschaltung-impl/`, `20260710-parser-gating-impl/`, `20260710-phase6-vorbau-impl/`,
`20260710-kardinalitaeten-deep-research/`, `20260710-axis-binding-registry-VERWORFEN/` — je Dossier +
SYNTHESE-REVIEW + `rohdaten-review/` (Journal + Workflow-Skript + Ergebnis).

---

## 7. MEMORY-STAND

- **Index `MEMORY.md`:** 103 Einträge, Integrität verifiziert (**103 Links ↔ 103 Dateien, keine toten Links,
  keine nicht-indexierten Dateien**). Pfad: `/home/comdare/.claude/projects/-home-comdare/memory/`.
- **Diese Session neu geschrieben (3):** `feedback_selbst_implementieren_ab_20260710_codex_abgeloest`,
  `feedback_goal_scheint_erledigt_ultracode_verifikation`, `feedback_heuristik_messkurven_typsystem_chain_of_responsibility`.
- **Für den Nachfolger besonders relevante Direktiven-Memories:**
  `feedback_no_quick_fixes` · `feedback_baseline_system_in_stein_gemeisselt_layering` ·
  `feedback_all_projects_dual_remote_github_gitlab` (origin=gitlab / github=github; je-Repo-GO für Anlage) ·
  `feedback_gitflow_branch_doktrin_main_authoritaet_development_voraus` (**main=Autorität, development≥main**) ·
  `feedback_never_use_askuserquestion_crashes_session` · `feedback_codex_implements_from_dossier_claude_corrects`
  (historisch, durch Selbst-Impl-Direktive 10.07. abgelöst) · `feedback_verify_gitlab_pipeline_green_after_push` ·
  `feedback_no_success_marks_without_literal_output` · `reference_gitlab_pat_format_dots_regex` ·
  `reference_thesis_axis_t_ids_vs_dir_numbers` (**T0-T18 ≠ interne axis_NN-Codes** — wichtig für Achsen-Arbeit) ·
  `reference_ci_runner_ice_cold_cache_instability` (Cold-Cache-g++-ICE = Infra, max 1× retry).

---

## 8. KONKRETE NÄCHSTE SCHRITTE für den übernehmenden Agenten

1. **Ist-Verifikation (Kadenz-Schritt 1):** `git -C <ce> log --oneline -1` (erwartet `c022ce05`), `git -C <super>
   log/status` beide Remotes; Pipeline **9359 grün** bestätigen (GitLab-API ggf. 500 → retry mit ROOTCA-Cert).
2. **Dem User die 7 Forks (§4) als Klartext vorlegen** und seine Entscheidungen einholen (kein AskUserQuestion).
   Ohne diese kein sinnvoller Typsystem-Bau — jeder konsumentenlose Skeleton wäre der von wf_0f5a1d9c gefangene Fehler.
3. **Nach den Fork-Antworten:** Typsystem Ebene für Ebene bauen — **aber die tree-Wurzel gemäß Doc 20 §I** (kein
   greenfield; Konsument + Producer-Konsistenz-Contract gegen `profile_to_tree.hpp is_static`). Volle Kadenz je
   Ebene: Dossier → Selbst-Impl → adversarialer Review-Workflow + Rohdaten-Backup → doppelt-literal g++-16 →
   granulare Commits beide Remotes → CI strikt grün.
4. **Datengetriebene Punkte NICHT vorziehen** (realer Kurven-Fit, PMC-Vollpfad) — Cluster-Fenster #156/#215,
   mehrtägig, **NIE aktiv pollen**.
5. **Prod2/P-E-Core-Strecke bleibt hardware-gated** bis ~September 2026 (i9-14900KS RMA, Ledger-Eintrag `2efdbb8`).

---

## 9. OFFENE PUNKTE / RISIKEN (ehrlich)

- **Pipeline 9359** (super `821b1d5`, docs-only) noch nicht als grün bestätigt (lief beim Pausen-Zeitpunkt).
- **GitLab-API HTTP 500** zuletzt (transient Infra) — Push/Poll ggf. wiederholen.
- **Die #274/#256-Matrix-Migration** (Goal-V3-Ergänzung) wurde diese Session nicht angefasst — eigene, teils
  GO-gated Strecke (§13.12-Referenzen); der Nachfolger sollte prüfen, ob der User sie parallel vorantreiben will.
- **`test_data_sets.xml` existiert 0×** (stiller Parser-Slot, seit Phase 7 diagnostiziert) — Teil der
  EXTERN_GATED-Dataset-Wahrheitsquelle (R2-Entscheid offen).
