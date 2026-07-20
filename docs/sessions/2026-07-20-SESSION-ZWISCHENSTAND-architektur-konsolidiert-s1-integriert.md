# SESSION-ZWISCHENSTAND 2026-07-20 — Architektur konsolidiert (§54–§58), Plan v3.2, S1+S0.5 integriert

> Reiche Zwischenstandsdoku über den GESAMTEN Kontext, Verlauf, Ziele, TODOs und offene Arbeit. **Sauberer Stand erreicht:** die Architektur-Terminologie ist maßgeblich korrigiert und konsolidiert, der Legenden-Vertrag ist im Code korrekt, und der erste Bau-/Mess-Kette-Substrat-Stapel (S1 + S0.5) ist granular committet und lokal grün. Geschrieben aus dem Session-Kontext (Fable, Architekt/Manager).

---

## 0. Git-Endstand (alle clean, beide Remotes ref-gleich)

- **super** `1d07e46` (development) — Ledger bis §58, Arch-Doku, Plan v2/v3.2, A1-CI-Forward-Fix, ce-Submodul-Bump.
- **ce** (`Code/external/comdare-cache-engine`) `c96a4da1` (development) — S1 A1–A5 + S0.5 T6/T2, 5 granulare Pakete.
- Remotes: origin=gitlab.comdare.local, github=Spiegel. IMMER erst `git fetch+merge` (nie rebase).
- **Offen (laufend):** CI (ce 286 / super 288) hart-grün noch zu verifizieren; Schichten-Audit (User-Anmerkung) läuft.

## 1. Übergeordnetes Ziel (§0-GOAL-V6)

Diplomarbeit top-down zu honest-100% vollenden: reale, CI-verifizierte FF0–FF4-Messwerte, DE+EN-Thesis-PDF grün, `#193` hand-bedienbar. **Deadline 28.07.2026 = ZWISCHEN-Abgabe** (320er-Messdatensatz + Hybrid-Binary + Thesis-PDF); Zwischen-Meilenstein 24.07. (alles baut, messbar CI+lokal); new-golden-Voll-Messung ab 01.08. Grundsatz (User, diese Session bekräftigt): **voll planen, nichts auslassen, wichtige Stränge priorisieren, so weit kommen wie möglich** — die 28.07. ist nur ein Zwischenstand.

## 2. Die maßgebliche Architektur (§54–§58, User-bestätigt)

Diese Session hat die Architektur-Terminologie und das Stempel-/Caching-Modell autoritativ geklärt. **Bei Terminologie-Konflikt mit Alt-Text gilt §54–§58, nicht der Alt-Wortlaut.** Die reiche Gesamtsicht in eigenen Worten liegt in `docs/architektur/2026-07-20-cache-engine-architektur-in-eigenen-worten.md`.

**§54-T1–T7 (Terminologie):**
- **T1:** „Gattung" = das **Tier-Binary-INTERFACE** (die Hülle), NIE eine Achse. Es gibt KEINE „Achsen-Gattungen" — Achsen sind nach **TYP** organisiert: {Organ, System, Mess}. (Code: `AxisKind = {organ, system_measurement, system_config}`, kein `genus`-Enumerator.)
- **T2:** `measurement_categories` + Rückschrieb-Methoden = **Mess-Tooling-UNTER-Achsen im Planer** (delegiert), manifestieren sich als CSV-Spalten — NICHT „reine CSV-Spalten".
- **T3:** Einkompilierter Achsen-Satz einer Tier-Binary = **freigegebene System-Achsen ∪ 17 Organ-Achsen, gestempelt**; `binary_id` = 17-Organ-Kern.
- **T4:** Permutations-Baum je **Achsen-TYP** (nicht je Gattung).
- **T5/T7:** **Meta-Meta-Achsen** — die statische Hardware-Haupt-Achse verwaltet + gibt frei ein Achsen-Array; jede Meta-Meta-Achse erteilt per **Command-Pattern** Freigaben an Organ-Achsen; **zweischichtige Kern-Permutation** (Schicht 1 = Existenz an/aus jeder Meta-Meta-Achse, Schicht 2 = deren Werte); Achsen-Zahl wächst dynamisch je Maschine.
- **T6:** Legenden-Kette — `ceb:build:[a,b,c]` (Mess baut CEB) / **`tier:build:[d,e,f][g,h,i]` (System × Organ)** / `measure:[a,b,c][d,e,f][g,h,i]` (Mess × System × Organ). **KORRIGIERT** (war die Wurzel-Regression, s. §56).

**§56 (Legenden-Vertrag korrigiert):** Die Mess-Achse `[a,b,c]` baut NUR die CEB und delegiert; sie gehört NICHT in die Tier-Build-Legende (die CEB *ist* `[a,b,c]`). Der frühere Fehlform `tier:build:[a,b,c][d,e,f]:chunk<k>` war in §54-T6, §55, v3.1 und im Code (`plan_legend.hpp:109`) — alles korrigiert, Code-Fix committet.

**§57 (Stempel-Schichtung + Chunk-Semantik + Compile/Runtime-Grenze):**
- **CEB-Realm:** Mess-Achse fest einkompiliert (bis auf Planer-Unter-Achsen-Variablen); System + Organ noch *runtime*. Die CEB baut zu *ihrer* Laufzeit die *compile-time* Tier-Binaries.
- **Tier-Realm:** System-Achse UND Organ-Achse beide fest einkompiliert (getrennte Dimensionen).
- **Chunk (zweistufig):** CEB-chunk = System-Freigabe-*Erlaubnis* + Organ-*tobecompiled*; Tier-chunk = System-Freigabe-*Durchführung* + Organ (kompiliert). Der `:chunk<k>` bündelt das kombinierte System-Freigabe-Durchführung × Organ-Volumen.

**§58 (Versionierungs-Modell + Caching-Replay + Async-MinIO):**
- **Planer** = *ein* Stempel `X.Y.Z`. **CEB** = Array je Mess-Haupt-Algo `[Xa.Ya.Za,…]` (KEIN Gesamt). **Tier-Binary** = ZWEI separate Arrays (System + Organ, KEIN Gesamt); nur Haupt-Achsen gestempelt (Unter = dynamisch-Laufzeit, ungestempelt). **Mess-CSV** = voll-permutativer Stempel (alle Haupt + Unter als Kurzform-Legende mit Versionierung, Benennung + Spalten → eindeutige Zuordnung).
- **Caching-Replay:** Planer-Mess-Anforderung → suchen (per voll-permutativem CSV-Stempel) → Replay ODER fehlende materialisieren (Erweiterung Lazy-Materialisierung + erweitertes Caching, Caching-Phase).
- **Async `minio.comdare.de`:** Planer-Binary + CEB + Tier + CSV; git-Push + Mess-Rückschrieb-Sink bleiben synchron (§53-W11).

**Schichten-Vertrag (User-Anmerkung, diese Session):** Der Planer emittiert CEB, das CEB emittiert ALLE Tier-Binaries; jede Schicht verifiziert/steuert nur die nächste, strikt durch die Verträge getrennt — „das war schon immer so". (Wird gerade per Schichten-Audit literal am Code verifiziert.)

## 3. Verlauf dieser Session (Narrative)

1. **B1–B15-Rückfragen** aus dem Vorkontext beantwortet + 8 ultracode-Analyse-Workflows ausgewertet → **§51/§52** (ISA-Fork-A, Meta-Meta-Achsen, NUMA/page_type, INC-0-erledigt, 9dim-7/7, §38-Struktur/Rest, Migration-GO, F-SPREAD).
2. **§55** — neuer konsolidierter Gesamtblock v2 aller offenen Ziele (architektur-korrigiert, gegen alle §0–§54; löst §48 additiv ab). Manuelle Dedup-Verifikation (Wochen-alte Redundanz korrekt in Erledigt-Zeilen; #266/#262 zurück auf offen).
3. **Architektur-Klärungen (§54-T1–T7, §56, §57, §58)** in mehreren Runden mit dem User präzisiert; das Architektur-Dokument in eigenen Worten geschrieben und komplett überarbeitet.
4. **Legenden-Regression** entdeckt und ausgerottet: `tier:build:[a,b,c][d,e,f]` war die Wurzel in §54-T6 → propagiert in §55/v3.1/Code. Regressions-Check-Workflow → Wurzel + alle Fundstellen korrigiert; **v3.1 gelöscht** (git-Historie erhalten), **v3.2** sauber neu erstellt.
5. **§58-Versionierungsmodell** konsolidiert.
6. **S1 + S0.5 gebaut + integriert** (s. Abschnitt 4).
7. **„Verworfene Referenzen"** als Erinnerung für spätere Wiederverwendung gesammelt (`docs/plaene/20260720-verworfene-referenzen-erinnerung-fuer-wiederverwendung.md`, A1–A22 + Gruppen B/C/D) — Wiederverwendungs-Prüfung SEPARAT nach dem Gesamtplan, gemeinsam per Rückfragen.

## 4. Was gebaut + committet ist (ce c96a4da1)

- **S1/A1 P-TOTAL** — `COMDARE_GN_TOTAL` vererbungssicher forwarden (explizite `forward:variables`-Allowlist an planer:delegate + emittiertem ceb:trigger; kein blindes `pipeline_variables`). Behebt den 11621-„grün-aber-16"-Bug → 2^17. golden-neutral.
- **S1/A2 P-OBS** — telemetry/isa-Observer-Reklass (17/9/0), golden-neutral.
- **S1/A4 P-KONFORM** — Organ-only-binary_id-Guard (`profile_to_tree.hpp`): nur die 17 Organ-Achsen bilden binary_id-Ebenen; build-i2 stale-tree geklärt; Prosa-Drifts.
- **S1/A5 P-HYBRID** — Spline/Break-Even/Selektor-Gerüst (synthetisch) + K-5-Paritäts-Gate (best_binary_selector kAbiMajor Host-6, war schon 19.07. gefixt).
- **S1/A3 P-W12A3** — `kMeasurementAxisVersionLine` POD-Feld (AnatomyVersionLines 40→56, layout 1→2, append-only), Version-Line-ABI-Gate (User-GO, CRC-neutral).
- **S0.5/T6** — `tier_build_job` → `tier:build:[d,e,f][g,h,i]:chunk<k>` (Mess-combo raus, Aufrufe + needs-Kante nachgezogen, §57-Chunk-Semantik in Kommentaren). `grep tier:build:[a,b,c]`==0.
- **S0.5/T2** — Mess-Tooling-Fan-out-KERN (`measurement_tooling_registry.hpp` {WallClock/Macro/Micro}=HAUPT; `measurement_combos_of` fächert über Tooling). **LIVE-Default `[all]` gehalten, N>1 gated.**

Lokal grün: 5 Key-Tests 100% (golden-roundtrip==320, Planer/T6/T2, Hybrid, W12-Stempel, reflect<17>), 252-Sammellauf (A4), cf22 auf allen, Mojibake 0.

## 5. Der Plan (v3.2)

`docs/plaene/20260720-SESSION-PLAN-V3.2-audit-legende-korrigiert.md` (ersetzt gelöschtes v3.1) = exakte v2-Kopie + PLAN-V3.2-Block:
- **A. Terminologie-Korrekturen** (§54-konform).
- **S0-Audit** (korrigiert): T1/T3/T4 SAUBER, T5/T7 LÜCKE (S10-Bauziel), **T2 + T6 RESIDUE** (beide code-seitig; T6 jetzt erledigt).
- **S0.5** — T6+T2-Fix als erster Mess-Kette-Schritt vor S1 (erledigt für T6 + T2-Kern).
- **Kette:** S1 (P-TOTAL) → S2 (das EINE ABI/golden-Fenster) → S3 (Resolver) → S4 (Mess-Tooling-Schema) → S5 (Vollzug) → S6 (320er-Lauf, USER-GO) → S7 (Hybrid + M4 + PDF) → S8 (PDF-Abgabe). Parallel dahinter: **S10** ISA-Fork-A/Meta-Meta · **S11** NUMA/page_type · **S12** Gattungs-Vervollständigung (letzter ABI-Schritt) · **S13–S23** vergessene Stränge.

## 6. Offene Arbeit / TODOs (priorisiert)

**Sofort auf dem 28.07.-Pfad (Mess-Kette / Bau-Kette):**
- **T2-N>1-Scharfschaltung:** Sequenz **D1** (`<measurement_tooling>`-XML-Schema + validate) → **D2** (ThesisProfile/ExperimentProfile-Feld + Parser) → **D4** (per-CEB-`ceb:emit` je Mess-Konfig — verdrahtet die schon geltende Vertrags-Schichten-Trennung; sonst tier:build-Namens-Kollision) → dann **golden-Topologie-GO** (N>1 verdreifacht die gated Topologie). §56.
- **S2** — Voll-Build 2^17 + new-golden VOLL-Konfig im EINEN ABI/golden-Regen-Fenster (USER-GO-Gate). §33/§55.
- **S3–S5** — Registry-Resolver, Mess-Tooling-Schema (B9 Thesis-Profile voll), scharfer Mess-Vollzug (`emit_measure_job`).
- **§58-Folge-TODOs (Caching-Phase/W12):** §58-STEMPEL (Array-Umbau kOrgan/kSystem/kMeasurementAxisVersionLine → Array-Form) · §58-CSV-STEMPEL (voll-permutative CSV-Benennung+Spalten) · §58-REPLAY (Planer-Caching-Replay) · §58-MINIO (async Planer+CEB+Tier+CSV).

**Architektur-Erweiterungs-Stränge (parallel, größtenteils BAND-C nach Abgabe):**
- **S10** ISA-Fork-A additiv + Meta-Meta/Hardware-Manager-Array (mp11, Command-Pattern, 2-Schicht-Existenz-Permutation) + Stempel-Fold; Alt-Ausbau = Pflicht-Schluss.
- **S11** 7. NUMA/Locking-System-Achse (dynamisch, unter ISA) + page_type-Anerkennung.
- **S12** Gattungs-Vervollständigung (Set/Sequence/Adapter/View auf SearchAlgorithm-Tiefe, OrganConcept) — LETZTER ABI-Schritt, 2-Stufen-ABI-Fenster.

**Mess/Auswertung/Hybrid/Thesis:** 320er-Abgabe-Messlauf (USER-GO), M-4-Auswertung, Reihe-C-2-Views, Hybrid-Break-Even (Option 1 limitiert + Option 3 Dock-Array), Mess→PDF-Rückschrieb, Anhänge A/B/E + FF0-Owner.

**Storage/Infra:** Ebene-B dev-MinIO V90 / Ebene-C prod-NFS V91 (#56-gated), inkr. Cache (B7), PAT-Rotation #327, #276 3-ISA (allerletzte).

**Post-Abgabe/geparkt:** new-golden-Voll-Messung (§33, mehrtägig, NIE pollen), F-SPREAD/INC-G7, Migration A1/A5/A7 (B15, je-Repo-GO), S-7-Deep-Research, „verworfene Referenzen"-Wiederverwendungs-Durchsicht.

Die **vollständige, gepflegte TODO-Single-Source ist Ledger §55** (8 Stränge) + §56/§57/§58 (neue Modelle/Folge-TODOs).

## 7. Direkt offene Punkte (diese Session, warten)

1. **CI hart-grün** (ce 286 + super 288, prod1+prod2) nach dem Push verifizieren (kein ✓ ohne literale Pipeline-Ausgabe; Cold-ICE 1× Retry).
2. **Schichten-Audit** — literaler Nachweis, dass Planer/CEB/Tier separat gebaut werden und ihre Verantwortlichkeiten strikt durch die Verträge trennen (User-Anmerkung). Läuft.

## 8. Guardrails / Direktiven (bindend)

- Impl → Opus-Agenten; Fable = Architekt/Manager. Je TODO erst Ledger (§55) + themenrelevante Plandocs (ultracode), nie raten.
- Kadenz je Increment: cf22 (`~/tools/cf22/usr/bin/clang-format-22`) + ctest + Mojibake-grep (Doppel-UTF8-Muster; die ~13 Treffer im Ledger sind gewollte Muster-Zitate) + super-Sub-Build + granulare Commits (nie `git add -A`) + Dual-Push (origin=gitlab, github) + CI hart-grün ce+super/prod1+prod2.
- USER-GO-Gates: Bau-Release je Phase; ABI/golden-Regen-Fenster (nur EINES, S2); 320er `when:manual`; golden-Topologie-GO vor T2-N>1. §15.10-G: ABI/golden-Berührung HART GESPERRT ohne GO.
- NIE rebase (fetch+merge); NIE AskUserQuestion (crasht, Klartext); kein Python in Buildchain; ASCII-Code-Kommentare; Doku/Messdaten nie löschen (nur DEPRECATED; v3.1-Löschung war explizit user-autorisiert, git-Historie erhalten); Remote-Löschung nur je-Repo-GO.
- golden N=2^17=131072, CRC64 `0xF1C1F26A1232073B`, binary_id = Organ-only.
- Infra-Autonomie (§39): Vault-Schlüssel (PAT via `grep -oE 'glpat-…'`, NIE printen), CA-Cert, prod2=admin-management@10.0.10.212. Session-Transkripte enthalten Live-Tokens → nie committen.

## 9. Schlüssel-Pfade

- **Ledger (TODO-Single-Source + Modelle):** `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` — §55 (Gesamtblock), §54/§56/§57/§58 (Architektur/Legende/Stempel/Versionierung), §51/§52 (B-Entscheide).
- **Architektur in eigenen Worten:** `docs/architektur/2026-07-20-cache-engine-architektur-in-eigenen-worten.md`.
- **Aktueller Plan:** `docs/plaene/20260720-SESSION-PLAN-V3.2-audit-legende-korrigiert.md` (v3.1 gelöscht; v2 = `…-V2-voll-erweitert-alle-straenge.md`).
- **Erinnerung (spätere Wiederverwendung):** `docs/plaene/20260720-verworfene-referenzen-erinnerung-fuer-wiederverwendung.md`.
- **Code-Kern:** `ce libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp` + `plan_legend.hpp` + `measurement/measurement_tooling_registry.hpp` (NEU) + `abi/anatomy_version_stamp.hpp`.
