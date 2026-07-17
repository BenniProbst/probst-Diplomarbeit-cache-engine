# STRATEGIE — PARALLELE STRÄNGE (Diplomarbeit / Cache Engine)

**Stand:** 2026-07-17 · **Basis:** VOLLES GO (Ledger §20.E, Q2 entschieden §20.B/LED:1916) · **Deadline:** 28.07.2026
**Quellen:** Report 1 (Stack/Roadmap), Report 2 (Folgearbeiten/Gated), Report 3 (Abgabe/Thesis), Report 4 (Kanten/Konflikt-Matrix).
**Zweck:** Die gesamte offene TODO-Liste in disjunkte PARALLELE Stränge + sequentielle KETTEN ordnen, um maximal parallel zu entwickeln, ohne die „1 sequenzielle CE-Code-Lane"-Doktrin zu verletzen.

**Leitmodell (Report 4-(d)):** GENAU EIN CE-Working-Tree ⇒ nur EIN Strang darf CE-Code schreiben (STRANG-BAU, Haupt-Agent, strikt sequenziell). Alles andere ist read-only, fremdes Repo (Thesis), oder reine Doku/Backup-Files ⇒ echt parallel.

---

## (1) STRANG-DEFINITIONEN

### STRANG-BAU — CE-Code, Haupt-Agent, STRIKT SEQUENZIELL (die eine Bau-Lane)
- **Inhalt:** INC-1a → 1b → {1c · 1d · 6.-Achse Erweiterungshardware · 1e · 1f} → 1g → 1h *(Reihenfolge = interne Ketten, s. §2)*; danach **[SYNC-1: INC-2-Bau-Freigabe]**; dann INC-2 (4→5-Bump-Bündel); dann Folge-Baus S4 Serialisierung Q1–Q4 · S3 Planer-Codegen-Bau/I4 · B1 INC-3 golden · B2 INC-4 Sequence/Container/Graph-Dock.
- **Abhängigkeiten:** 1a MUSS zuerst (alle Achsen erben `CebSystemAxis<D>`); 1b vor allen Registrier-Achsen; 1g logisch NACH allen Achsen (kodiert Belegung in `build_version`). INC-2-Bau ⇐ INC-1 fertig. S4 ⇐ INC-1b (`build_system_axis_levels()`) + INC-2 (golden/POD final). S3-Bau/I4 ⇐ INC-2 (Roadmap) + überlappt S4 an `iterator.hpp`. B1/B2 ⇐ INC-2.
- **Berührte Pfade (CE, alle im EINEN Working-Tree):** NEU `topics/axis.hpp`, `measurement/ceb_system_axis.hpp`, Achsen-Header (Scheduling/HardwareIsa/Erweiterungshardware/LoadFramework/Compiler); EDIT `topics/axis_base.hpp`, `measurement/system_axis.hpp`, 22× `axes/**/*StrategyBase.hpp` (Stufe-2 golden-sensibel), `builder/experiment_tree/registry_to_axis_levels.hpp:81/83`, `builder/build_orchestrator/build_orchestrator.hpp:62/175/322/466/479`, `builder/experiment_tree/cache_engine_builder_iterator.hpp` (:777/790 + CSV-Emit), `profile_run_facade.cpp:129-132`, `builder/disk_serializer/*` (leerer Stub → Neuland). INC-2 zusätzlich: `anatomy/**` (ABI-4→5, POD-1416, kV3AxisSchema, GenusBindingTraits, serialize_composition_path, golden).
- **Wer:** Haupt-Agent (selbst implementieren, §feedback_selbst_implementieren). NIE delegiert, NIE zweiter gleichzeitiger CE-Schreiber.
- **Freigabe:** INC-1 = VOLL ENTSPERRT (Q2-GO). INC-2-Bau = **explizites User-Bau-Release je Phase (§20.B)** an SYNC-1. Stufe-2-1a-Gate: golden nicht byte-identisch/ABI-4-Berührung → automatisch nach INC-2 schieben (kein GO nötig, Doktrin-Automatismus).

### STRANG-PLAN — INC-2-Planung + W3-Auflösung, read-only, VOLL PARALLEL
- **Inhalt:** (i) W3-Strukturfrage klärungsreif als Klartext-Fork aufbereiten (golden-Neu-Materialisierung als eigenes INC-3 **vs.** in 4→5 gefaltet — divergierende Quellen F12III §7/S18:102 vs. Ledger §19.E-4/LED:1884); (ii) ultracode-Planungssession INC-2 über die §6-Muss-Lektüre (F12III komplett + KONSTRUKTIONSLOGIK §3/§4/§7 + LEDGER-SECTION-18 + §19.E-4/§19.F + e18-Ebene1 + planer-codegen) → INC-2-Bauplan-Dossier; (iii) W4 Set-Genus-Scope schneiden (Ist vs. NEU SetDock+Set-ABI-V2-POD); (iv) ABI-Grenz-Landkarte 4→5 (TABU-T1–T8); (v) Naht-Punkte aus INC-1 überführen; (vi) **ADDENDUM-Fold**: Bauplan §3 kennt nur 1a..1g — 1h (Compiler Q3) + 6.-Achse (Erweiterungshardware) aus §20.B-Delta nachtragen; (vii) S3-Planer-Codegen-Design-Verfeinerung (read-only).
- **Abhängigkeiten:** W3-Fork ⇐ nichts (einziger echter INC-2-Blocker, sofort startbar). Planungssession ⇐ nichts. Muss VOR SYNC-1 fertig sein, damit INC-2-Bau nicht wartet.
- **Berührte Pfade:** NUR read-only über CE + EIGENE Dossier-Files unter `docs/sessions/backups/<datum>-inc2-.../`. KEIN Code-Write.
- **Wer:** Hintergrund-Workflow / ultracode (delegierbar, read-only). Bis ~3–4 gleichzeitige RO-Workflows unbedenklich.
- **Freigabe:** frei zu starten. Erzeugt EINEN echten User-Bedarf: **W3-Ruling** (kein Doktrin-Automatismus) — so früh wie möglich einholen (§5).

### STRANG-THESIS — LaTeX/Anhänge, SEPARATES Repo, VOLL PARALLEL
- **Inhalt:** Anhang B (Code-Struktur, 125 Pfade) + Anhang E (12 ADRs) DE+EN NEU ausschreiben (Stubs, §12-„DONE" ist stale/über-behauptet — Inhalt erreichte Working-Tree nie); F11 Ist-Stand (Datasets 6+2 kanonisch, 48er verworfen) an ALLEN Stellen; thesis-lint (chktex W13/W12/W1/W31… → 0, dann `lint:latex allow_failure` raus); DE≡EN-Symmetrie (EN-Titelblatt „apl. Prof. Dr.-Ing. Dirk Habich"); F10-**Gerüst/Wiring** (honest-empty-tolerant, data-unabhängig baubar).
- **Abhängigkeiten:** Anhang B/E + F11 + lint ⇐ NICHTS (reine Textarbeit, ab sofort). F10-VERDRAHTEN (gefüllte Lieferung) ⇐ S4-CSV-Format eingefroren + echter Messlauf (SYNC-2) + Credential/GO. Anhang A REALE WERTE ⇐ Messlauf (SYNC-2).
- **Berührte Pfade:** NUR `thesis/diplomarbeit/` (Overleaf-Submodul, eigenes Repo) — `anhang/{de,en}/`, mehrere `.tex`. NULL CE/SUPER-Code-Overlap. NIE ins Impl-Repo (§feedback_text_agent_sessions).
- **Wer:** delegierter Text-Agent, Sessions ins Thesis-Repo.
- **Freigabe:** Autoring + lokaler latexmk-Build = frei/jetzt. **Outward-facing Overleaf-Push = je-Repo-User-GO** (wie #24-Anhang A). Sperrvermerk-Wortlaut + Danksagung = User beizusteuern (nicht Agent).

### STRANG-DOKU — Ledger-Hygiene, SINGLE-WRITER, interleaved
- **Inhalt:** Ledger in-place pflegen (V6-Doktrin); STRANG-PLAN-Dossiers einfalten; §12-Stale-Marken korrigieren (AP-B4/B5 „DONE" über-behauptet); F12i-§12-Reloz (LED:921 → §12); Tasks-Liste (user-sichtbare TODO) aktuell halten; offene Entscheidungen für den Morgen sammeln.
- **Abhängigkeiten:** ⇐ alles (protokolliert Stand), schreibt aber unabhängig.
- **Berührte Pfade:** SUPER `docs/…LEDGER.md` (in-place) + `docs/sessions/backups/`. Physisch getrennt von CE-Code + Thesis.
- **Wer:** Haupt-Agent zwischen Increments (Single-Writer). **NIE zweiter gleichzeitiger Ledger-Schreiber** (einziger STRANG-PLAN↔STRANG-DOKU-Berührungspunkt).
- **Freigabe:** frei.

### STRANG-INFRA — CI-Nachzug, GEPARKT, Trigger = User-Meldung
- **Inhalt:** Alle Pipelines (SUPER+CE+prt-art+thesis) gesammelt grün bestätigen (dual baremetal+CI). Aktuell GEPARKT: CI-Jobs laufen bis auf Weiteres NICHT an; gültig ist lokal-first je Increment (ce `build-conf` UND super-Sub-Build `build-i2` literal grün + granulare Commits + beide Remotes). KEIN CI-Grün-Gate je Increment.
- **Abhängigkeiten:** nach allen Bau-INCs. Wird von STRANG-BAU S3 `--emit-ci` **generiert** → strukturelles Hand-CI subsumiert/obsolet; nur minimale keep-green-Edits jetzt.
- **Berührte Pfade:** SUPER `.gitlab-ci.yml`, CE `.gitlab-ci.yml`. **Nur Haupt-Agent, koordiniert mit STRANG-BAU S3** (geteilte Datei, §3).
- **Wer:** Infra-Agent (Cluster read-only, Infra=Handover) + Haupt-Agent für Repo-CI-Files.
- **Freigabe:** Infra-gated + prozess-geparkt. **Trigger = User meldet CI-Rückkehr (§20.B).** Kein GO einzuholen — auf User-Signal warten.

### STRANG-MESS — echter Messlauf + Rückschrieb + F10-Füllung, GATED nach INC-2
- **Inhalt:** Mehrtägiger golden-320-Voll-Messlauf (C6, opt-in CI-Job `measure:golden-320`, prod1 PMC-Node, `timeout 10d`, INERT via `COMDARE_RUN_MEASURE==true`) → reale FF0–FF4-Werte; Rückschrieb `measurement/<ts>/` (C7, Maschinerie gebaut, Token id=54/Projekt 288 write_repository-only, INERT); F10-VERDRAHTEN (Overleaf-Überschreib-Commit); danach F10/Anhang-A-Füllung, #193 finaler Hand-Lauf, FF4-Manifest, C1 I-PMC-2.
- **Abhängigkeiten:** entsperrt durch INC-0 (DONE, measured>0). Voll-repräsentativer Lauf über NEUE Gattungs-/golden-Struktur **⇐ INC-2** (SYNC-2). **MUSS VOR 28.07. starten.**
- **Berührte Pfade:** SUPER `.gitlab-ci.yml` (measure/persist-Stage), `Code/measure_out` → `measurement/<ts>/`; Rückschrieb Overleaf-Submodul (STRANG-THESIS-Kopplung).
- **Wer:** Haupt-Agent triggert CI-Job; Lauf autonom (nie pollen, §feedback_prod_ci_measurement_multiday). Cluster-Verfügbarkeit = Infra (prod1 online, prod2 Intel-Bein hardware-blockiert).
- **Freigabe:** Mess-GO liegt teils vor (C7 „Ja das backup genügt. GO"); **explizite Start-Freigabe für den großen Lauf an SYNC-2** (vor 28.07.). Overleaf-Push = User-GO. Loop-Schutz `[skip ci]`.

### (optional) STRANG-RESEARCH — read-only, EHRLICH OFFEN / Infra-gated
- **Inhalt:** C10 S-7-Locking/Observer-Deep-Research (OptiQL-faithful + ARTSynchronized-Vendoring; PLAN.md liegt) + C1 I-PMC-2 (L3-Mapping/branch_misses) / I-PMC-3 (#187 Zen-5-RAW).
- **Wer:** delegierter RO-Workflow (Sub-Lane von STRANG-PLAN). **Freigabe:** C10 = **EHRLICH OFFEN** (Tooling/Safety-Block, NICHT durch VOLLES GO entsperrt); I-PMC-2 frei; I-PMC-3 Infra/Daten-gated. Kollidiert mit nichts (eigenes Backup-File).

---

## (2) SEQUENZ + SYNC-PUNKTE (Zeitachse)

```
HEUTE ─────────────────────────────────────────────────────────────────────► 28.07 (Deadline)

STRANG-BAU  [1a]→[1b]→{1c·1d·6.Achse·1e·1f}→[1g]→[1h] ══SYNC-1══ [INC-2] ══SYNC-2══ [S4→S3/I4→B1→B2]
            (läuft, Haupt-Agent, EIN Working-Tree, strikt sequenziell)      ▲                    ▲
                                                                            │                    │
STRANG-PLAN [W3-Fork]→[ultracode INC-2-Session]→[INC-2-Bauplan-Dossier]─────┘ (muss VOR SYNC-1   │
            (RO, parallel ab heute)                                            fertig sein!)     │
                                                                                                 │
STRANG-THESIS [Anh B/E DE+EN · F11 · lint · F10-Gerüst]──────────────────────────────────────────┤ (F10-Füllen
            (separates Repo, parallel ab heute)                                                  │  + Anh A ⇐ SYNC-2)
                                                                                                 │
STRANG-DOKU [Ledger-Hygiene interleaved, Single-Writer, zwischen Increments]                     │
                                                                                                 │
STRANG-MESS  ......................................... (gated) ..................................[GOLDEN-320-LAUF]═SYNC-3═►
                                                                                    (Start VOR 28.07!)
STRANG-INFRA [GEPARKT — Trigger: User meldet CI zurück] ────────────────────────────────────────────── ═SYNC-3═► [Batch-Nachzug]
```

**Interne STRANG-BAU-Ketten (Report 1-(a)):**
- KETTE-1 (streng): `1a` (Dach+Wurzel) → `1b` (Registrier-/Split-Punkt) → Achsen-Increments → `1g` (kodiert alle Belegungen in `build_version`).
- Konflikt-Cluster serialisieren INNERHALB der Achsen-Phase: 1c/1d/1f/6.-Achse teilen `build_system_axis_levels()`; 6.-Achse/1g/1h teilen `build_orchestrator.hpp:62`. `1e` (Mess-Seite) ist der am besten isolierte Increment (berührt `registry_to_axis_levels.hpp` NICHT), aber gleicher Working-Tree ⇒ trotzdem sequenziell in der Lane.
- `1h`-`-fno-gnu-unique`-Compiler-Gate ist Voraussetzung für die clang-Leg des „5 %"-Vergleichs (6.-Achse-Messung).

**Synchronisationspunkte:**
- **SYNC-0 (früh, heute anstoßen):** STRANG-PLAN legt W3-Fork + FF0-Owner-Sachentscheid als Klartext vor → **User-Ruling**. Blockiert INC-2-Planungs-Abschluss, NICHT INC-1-Bau.
- **SYNC-1 = INC-1 letzter Increment (1g/1h) fertig → INC-2-Bau-Freigabe einholen.** Bedingung: STRANG-PLAN-Dossier liegt bereits vor (W3 geruled) ⇒ **kein Warten**. Checkpoint: super-Sub-Build `build-i2` + golden==320 + ABI-4 kein Major-Bump + cf22==0 + Mojibake==0 + beide Remotes ref-gleich.
- **SYNC-2 = INC-2 fertig → STRANG-MESS golden-320-Lauf startet (vor 28.07.) + F10-VERDRAHTEN + Anhang-A-Füllung + B1 INC-3 golden + B2 INC-4 Dock.** S4-CSV-Format ist hier eingefroren ⇒ F10 wird verdrahtbar.
- **SYNC-3 = User meldet CI zurück → STRANG-INFRA Batch-Nachzug** (alle Pipelines gesammelt grün, dual-verifiziert).

**Deadline-Kritik:** F12i Standalone-Parität (C5) + Start des golden-320-Laufs (C6) sind 28.07.-kritisch. SYNC-2 muss mit genug Vorlauf für den mehrtägigen Lauf fallen ⇒ INC-2-Bau darf nicht spät rutschen ⇒ STRANG-PLAN-Vorarbeit hat Priorität, damit SYNC-1 nicht wartet.

---

## (3) KONFLIKT-REGELN (aus Report 4 Konflikt-Matrix)

**R0 — EIN CE-Schreiber:** Nur STRANG-BAU (Haupt-Agent) schreibt je CE-Code-Datei. STRANG-PLAN/RESEARCH lesen CE nur. NIE zwei CE-Code-Stränge gleichzeitig — EIN Working-Tree, git-Tree-Kontention selbst bei disjunkten Dateien. Worktree-Isolation bringt hier nichts (nicht datei-disjunkt + semantisch geordnet).

**R1 — Harte Same-Region-Kollisionen (nie gleichzeitig, alle in STRANG-BAU ⇒ per Sequenz gelöst):**
1. `cache_engine_builder_iterator.hpp` — S3-I4 (:777/790 failed-Zelle/Debug-Mess) ∩ S4 (CSV-Emit-Region). S3-I4 und S4 NIE parallel.
2. `registry_to_axis_levels.hpp:81/83` — 1b (Abspaltung) ∩ 1c/1d/1f/6.-Achse (Registrierung) ∩ S4 (liest Abspaltung). Registrier-Edits serialisieren; 1b zuerst.
3. `build_orchestrator.hpp:62` `build_version` — geteilt von 6.-Achse ∩ 1g ∩ 1h. Serialisieren; 1g etabliert den Mechanismus.
4. `measurement/system_axis.hpp` — 1a (Basis-Zeile) ∩ 1e (Telemetrie-Verankerung).

**R2 — .gitlab-ci.yml:** STRANG-INFRA (S7) ∩ STRANG-BAU S3 `--emit-ci`. Der Planer GENERIERT die Child-Pipeline ⇒ kein struktureller Hand-CI jetzt; STRANG-INFRA nur minimale keep-green-Edits, koordiniert mit S3.

**R3 — Ledger Single-Writer:** Nur STRANG-DOKU schreibt `docs/…LEDGER.md`. STRANG-PLAN schreibt eigene backups-Files (STRANG-DOKU faltet ein). NIE zwei gleichzeitige Ledger-Schreiber.

**R4 — Repo-Trennung:** STRANG-THESIS NUR in `thesis/diplomarbeit/`, NIE Impl-Repo. STRANG-PLAN/RESEARCH NUR in `docs/sessions/backups/`. Physisch kollisionsfrei zu CE-Code.

**R5 — Merge-Doktrin (§feedback_nie_rebase_immer_merge):** Bei Divergenz IMMER merge, NIE rebase. Vor Push fetch+merge. Dual-Remote (origin=gitlab, github=github); Anlage/Änderungen batch zu BEIDEN Remotes je-Repo. Overleaf pusht selbst auf GitHub-origin → mergen. GitFlow: immer auf `development`, `main` stets Vorfahr, back-merge nie rebase.

**Erlaubte Gleichzeitigkeit:** STRANG-BAU(1) + STRANG-PLAN(≈3 RO) + STRANG-THESIS(1) + STRANG-DOKU(interleaved). Null CE-Code-Datei-Kollision, weil nur STRANG-BAU CE-Code schreibt.

---

## (4) SOFORT-STARTBARE PARALLEL-AKTIONEN (heute) — 3 Stränge JETZT

| # | Strang | Erster konkreter Schritt (heute) | Kollidiert mit? |
|---|--------|----------------------------------|-----------------|
| 1 | **STRANG-BAU** (läuft bereits) | INC-1a fortsetzen: NEU `topics/axis.hpp` (`Axis<Derived>`+`AxisConcept`, empty base) + `measurement/ceb_system_axis.hpp` (`CebSystemAxis<D>`); Stufe-2-Gate prüfen (golden==320 byte-identisch? sonst 22× `…StrategyBase`-Umhängung nach INC-2 schieben). Danach 1b. | Niemand (einziger CE-Schreiber) |
| 2 | **STRANG-PLAN** (jetzt parallel) | (a) W3-Fork + FF0-Owner-Sachentscheid als **Klartext-Fork** für User formulieren (SYNC-0); (b) ultracode-Planungssession INC-2 über §6-Muss-Lektüre starten → INC-2-Bauplan-Dossier in `docs/sessions/backups/20260717-inc2-planung/`. RO. | Niemand (RO + eigenes File) |
| 3 | **STRANG-THESIS** (jetzt parallel) | Delegierter Text-Agent im Thesis-Repo: Anhang B (Repo-Struktur read-only kartieren, 125 Pfade) + Anhang E (12 ADRs) DE+EN ausschreiben; lokal DE/EN latexmk verifizieren (Baseline DE 154 S / EN 146 S). Push = später User-GO. | Niemand (separates Repo) |

*(STRANG-DOKU läuft interleaved durch den Haupt-Agenten; STRANG-RESEARCH optional als 4. RO-Workflow, wenn Kapazität — kollisionsfrei.)*

**Nicht heute:** STRANG-MESS (gated ⇐ SYNC-2), STRANG-INFRA (geparkt ⇐ SYNC-3), STRANG-BAU-INC-2/S4/S3/B1/B2 (⇐ SYNC-1/INC-2).

---

## (5) FREIGABE-BEDARFE (User-GOs, so früh wie möglich BATCHED)

**BATCH-EARLY (heute vorlegen — ein Klartext-Block, NIE AskUserQuestion):**
1. **W3-Ruling** — golden-Neu-Materialisierung als eigenes Bau-INC-3 **vs.** in den 4→5-Bump gefaltet. Divergierende autoritative Quellen (F12III §7/S18:102 vs. Ledger §19.E-4/LED:1884). **Einziger echter INC-2-Blocker**, kein Doktrin-Automatismus. → blockiert INC-2-Planungs-Abschluss, nicht INC-1.
2. **FF0-Owner-Sachentscheid** — Multi-Plattform/„Sapphire-Rapids"-Owner heute nur implizit; DoD-relevant (G8).
3. **Overleaf-Push-GO vorab-klären** — je-Repo-GO für Anhang B/E-Push (outward-facing), einzuholen sobald B/E-Drafts stehen. Pre-announce jetzt.

**AN SYNC-1 (INC-1 fertig):**
4. **INC-2-Bau-Release (§20.B)** — explizite phasen-weise Bau-Freigabe VOR dem 4→5-Bau. STRANG-PLAN-Dossier liegt dann bereits vor.

**AN SYNC-2 (INC-2 fertig, vor 28.07.):**
5. **golden-320-Lauf-Start-Freigabe** (`COMDARE_RUN_MEASURE=true`) — Mess-GO liegt teils (C7), Start des großen Laufs explizit bestätigen; Overleaf-Rückschrieb-Push-GO (F10/Anhang A).

**AN SYNC-3 / laufend:**
6. **STRANG-INFRA** — KEIN GO einzuholen; **Trigger = User meldet CI-Rückkehr**. Bis dahin geparkt.

**Nicht durch VOLLES GO entsperrt (ehrlich offen, kein Bau-Gate):** C10 S-7 (Tooling/Safety-Block). C11 G5/#274 bewusst ans Projektende terminiert.

**Über allem:** prozessuales explizites User-Bau-Release je Phase (§20.B) + ultracode-Planungssession-Pflicht vor jeder Bau-Aufgabe.
