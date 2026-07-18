# SESSION-ÜBERGABE 2026-07-09 — E4-XML-Roadmap: Phase 0/0.5 vollzogen, Phase 1+2 revertiert, Mess-Methodik neu gerahmt

> Sehr lange Session (comdare@prod1, Opus 4.8 max). main aller Repos **sauber-grün**. Belastbarer Stand = git + Dossier 16/17 + Backups + Memory. Diese Übergabe ist die Landkarte.

## 1. WAS VOLLZOGEN IST (committet + CI-grün)
- **Phase 0 — E0-E4-Nomenklatur-Konsolidierung** (super `b4d7d3d`, CI 9149): §10.1-Kanon (E0-E4 rehabilitiert; **vierfache** E-Disambiguierung E0-E4 / DD-A..DD-E [ex E-A..E-E] / §13.9-Gate-E1-E3 / E2-Sidecar; S↔E-Kreuz-Map); Schichten-Modell §9; 15_F7 §0; Dossier 16 Teil I. + Ledger §12 + Dossier I.4 (super `6b1240f`).
- **Phase 0.5 — G2-Revert** (ce `8c73ef7c` / super `f01bdaa`, CI grün): tote compile-time-Insel `workload_matrix.hpp` (#31-Fehlbau) forward-revertiert.
- **Dossier 17** `docs/architektur/17_E4_XML_VOLLVISION_ROADMAP.md` (super `e000793`, GENEHMIGT): die autoritative E4-XML-Roadmap. **Zentraler Befund: die #229-Maschinerie (XML→19-Achsen-Limits→Tier-Binary-Kompilierung→run_profile) ist zu ~80% gebaut, aber im `tests/unit/thesis_tiere/`-Harness eingesperrt.** Roadmap = Andocken + Entkoppeln, nicht Neubau. Phasen 1-8 in Teil D.

## 2. WAS VERSUCHT + REVERTIERT WURDE (Fix-Specs in Backups)
- **Phase 1 (#230) — run_profile-Fassade** (ce 698977fe/super 5b5dc9c → REVERTIERT ce `fc6f2e45`/super `fac49e66`): GoF-Facade `profile_facade` architektonisch korrekt, aber super-CI rot. **2 Fixes für Neuaufbau** (Backup `docs/sessions/backups/20260709-code-review-phase1-230/` + Task-Desc): (A1) `profile_facade/CMakeLists` muss die ~15 vendored Adapter-Targets linken (`comdare::adapter::{a01_hoard,a03_michael_lockfree,a04_mimalloc,a05_jemalloc,a06_tcmalloc,a07_snmalloc,a08_scalloc,a10_rpmalloc,a11_lrmalloc,p07_wormhole,p10_surf,p20_btreesareback,p25_mahling,p29_rcu,p30_hazardpointers}` = `m3v2_pmc_smoke` spiegeln, `tests/unit/CMakeLists.txt:277-301`) + in `COMDARE_FACADE_PERM_INCLUDES`, sonst `mimalloc.h`-Fehler im super-Sub-Build; (A2) code-review-Findings B1-B5/C1-C2 (Wrapper zu dünn: 0-Profile-Abort, platform_override, min_free_gb, cap-Validierung, SOTA-Opt-out, try/catch-Fallback). Andock: `profile_run_entry.hpp:104`, `main.cpp:485/513-521`.
- **Phase 2 (#221) — RC-Dynamik** (ce 1f9c2eef/super 2a8c36c → REVERTIERT ce `290e306c`/super `07362a4`): Codex verdrahtete die 4 restlichen RC-Achsen an Organe; CI-grün, aber max-Effort-code-review (38 Agenten) fand **8 CONFIRMED Mess-Bugs** (Datenverlust budget/rebuild_, batch_size→nullptr-CSV = Anti-Phantom-Ziel verfehlt, 0-Latch reused-Tier, Über-Zählung, Allocator-Kontamination). Vollständige Fix-/Methodik-Spec: **`docs/audits/20260709-code-review-phase2-221-SYNTHESE.md`** (A1-A9 Klar-Bugs + M1-M4 Methodik-Fragen).

## 3. METHODIK-NEURAHMUNG (User 09.07., die eigentliche Wende — Memory-verankert)
Der #221-Fehler war, RC-**Effekte zu erfinden**. Zwei bindende Direktiven:
- **[[feedback_axes_optimization_semantics_deep_research_observer_strategy]]**: jede der ~19 Achsen hat eine **Optimierungs-Eigenschaft (Min ODER Max einer messbaren Größe)**, per **deep research + Thesis** je Achse zu ermitteln (was messbar/relevant, echter Laufzeit-Knopf vs. honest-0). Ziel: **mehrdimensionale statische Heuristik-Kurven** → optimale Konfig je Last/Füllstand/Beschaffenheit = echte Optimierung. Wirkungsweise je Achse als **Observer-Strategy-Pattern**.
- **[[feedback_system_axes_measurement_own_abstract_root_blood]]**: **zwei distinkte Achsen-Systeme** — (a) Tier-Binary-/Organ-Achsen (~19, permutierbar, Gattungen, das Gemessene) vs. (b) **System-Achsen des Mess-Systems** mit **eigener abstrakter Klassen-Wurzel**, immer präsent bei Messung, NICHT Gattungen, nicht austauschbar = **„Blut"** (die Mess-Instrumente/-Kategorien selbst). Formalisiert Dossier 17 B.3 / den fehlenden `IMeasurementSource`/`SystemAxis`-Root. Nie vermischen. Strikt **E4→E0 interface-orientierte Layer**.

## 4. FORWARD-PLAN (der Einstieg für die nächste Session)
1. **DEEP RESEARCH LÄUFT** — Agent `ae532ffae13dabdba` (background, gestartet Sessionende) recherchiert je Achse Min/Max-Optimierungs-Größe + Messbarkeit + Laufzeit-Knopf-vs-honest-0 + Last/Füllstand-Abhängigkeit → zitierter Befund nach `docs/audits/20260709-axes-optimization-deep-research-BEFUND.md`. **ZUERST prüfen ob dieser Befund existiert** (Agent evtl. noch nicht fertig / Ergebnis nachlesen).
2. **Achsen-Semantik festlegen** aus dem Befund: welche Achsen echten Laufzeit-Effekt haben (ehrliches #221), welche honest-0.
3. **System-Achsen (Blut) entwerfen**: gemeinsame abstrakte Wurzel (`SystemAxis`/`IMeasurementSource`), immer präsent, orthogonal zu Organ-Achsen (E0-Querschnitt).
4. **#221 neu** (Codex-Erstimpl. aus geforschtem Spec + Klar-Bug-Fixes A1-A9 + Edge-Case-Tests statt Happy-Path) → adversarialer code-review → CI. Danach **Phase 1 (#230) neu** mit den 2 bekannten Fixes.
5. Dann Dossier-17-Roadmap Phase 3-8 (#188 → Limits-Entkopplung → #31/F7 Framework×Workload-Bib → Mess-System → #223 → #215/#156).

## 5. TOOLING-LEHREN (kritisch)
- **Codex-MCP funktioniert** via `sandbox: "danger-full-access"` (umgeht den bwrap-loopback-Blocker, prod1 AppArmor-userns-Restriktion) + `approval-policy: never` + strikter Repo-Guardrail im Prompt. Default-Modell `gpt-5.5` + `model_reasoning_effort xhigh` steht schon in `~/.codex/config.toml` (kein Override nötig). Arbeitsteilung: **Codex = Erstimpl. aus elaboriertem Spec + allen Referenzen; Claude = Zeile-für-Zeile-Review + Korrektur**. [[reference_codex_mcp_prod1_bwrap_shell_broken]]
- **clang-format-22.1.8 lokal** via `~/tools/cf22/usr/bin/clang-format-22` (aus CI-citool-`.deb` extrahiert). VOR jedem C++-Commit `clang-format-22 -i` + `--dry-run --Werror`. [[reference_ce_facade_super_subbuild_verify_and_clang_format_prod1_gap]]
- **super-Sub-Build verifizieren**, nicht nur Standalone-ce (Standalone versteckt fehlende vendored Adapter-Includes → CI-rot).
- **Adversarialer max-Effort-code-review ist PFLICHT** vor „fertig": fand bei BEIDEN Phasen reale Bugs, die mein Review + die lokalen Tests übersahen (Bugs manifestieren erst zur Mess-Laufzeit / im super-Sub-Build).
- Task-Store wird bei `/goal`-/`/model`-Wechseln geleert → nicht darauf verlassen; git + Dossiers + Memory sind die Wahrheit.

## 6. STANDING-DIREKTIVEN (unverändert in Kraft)
danger-full-access-Codex NUR im Diplomarbeit-Repo (nie ~/Projekte/Cluster/keys); golden_fullpilot_320 / permutation_axes.xml / ABI-MAJOR / POD-sizeof / GenusBindingTraits TABU ohne GO; thesis-Submodul read-only; nie `git add -A`; beide Remotes (origin=gitlab, github); Co-Authored-By: Claude Opus 4.8; CI strikt grün vor nächster Aufgabe; alle Analyse-/Review-Rohdaten additiv ins Backup; AskUserQuestion NIE.
