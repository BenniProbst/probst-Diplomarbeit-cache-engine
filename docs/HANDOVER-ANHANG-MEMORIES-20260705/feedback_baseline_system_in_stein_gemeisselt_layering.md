---
name: feedback_baseline_system_in_stein_gemeisselt_layering
description: Baseline-System der Module/Produkte ist IN STEIN GEMEISSELT — Baseline referenziert nur niederwertigere Baselines (Regelfall exakt die nächst-kleinere); Produkte referenzieren ausschließlich Produkt-Baselines (formales Erben aus generischen Modules zwingend)
metadata: 
  node_type: memory
  type: feedback
  originSessionId: c6f15797-7fa1-4e66-874f-55631afe1d28
---

**Direktive (User, 2026-07-02):** Die Struktur der Module-Baselines (baseline_0-foundation … baseline_N) ist in Stein gemeißelt und darf NIEMALS gebrochen werden. Sie wiederholt sich systematisch und haargleich in ALLEN Modulen (Modules/comdare-*-all) und Produkten (Products/*) und liefert klare Interfaces.

**Regeln:**
1. Eine Baseline darf ausschließlich Interfaces NIEDERWERTIGERER Baselines referenzieren und linken.
2. Regelfall (soll eingehalten werden): eine Baseline referenziert ausschließlich ihre NÄCHST-KLEINERE Baseline (n → n-1), keine Sprünge.
3. Produkte referenzieren ausschließlich Baselines IN PRODUKTEN — nie direkt generische Modules. Formal ist immer ein Erben vom generischen Modules-Stand in ein projekt-spezifisches Produkt-Modul notwendig (Spezialisierung).
4. Dadurch werden Verstöße und Brüche sofort beim Linken sichtbar — das ist gewollt und Teil des Designs.

**Why:** Das Baseline-System ist das zentrale Ordnungsprinzip des gesamten Firmeninventars (~250 Projekte). Modules = so generisch wie möglich, Produkte = so spezifisch wie nötig auf mindestens einer generischen Modules-Basis. Link-Sichtbarkeit von Verstößen ersetzt aufwendige Architektur-Reviews.

**How to apply:** Bei JEDER Planung, CI-Definition, CMake-Änderung, Codex-Beauftragung und jedem Review für comdare-db/Modules die Schichtungsregeln als harte Invariante prüfen. Neue Abhängigkeiten nur n → n-1; Produkt-Code erbt immer erst ins Produkt-Modul. Verstöße = Blocker, nie Workaround. Siehe [[feedback_infra_cleanest_not_easiest]], [[feedback_codex_implements_from_dossier_claude_corrects]].

**⚠️ Begriffsklärung „Baseline" (2026-07-03): DOPPELT belegt — nicht verwechseln.** (A) **Domänen-/Produkt-Baseline** = DIESE Regel: `comdare-baseline_0..6` (Fachfundament, WAS das Produkt ist), vorhanden in comdare-db + den 15 Modules-Umbrellas. (B) **Build-/Toolchain-Baseline** = `cd-buildsystem-core` 3.4.15 (WIE gebaut wird, ökosystemweit) — sowie das davon getrennte, EIGENE **Layer0-4-Baseline** des Produkts `cd-buildsystem-construct` (Compile-Maschine, autonome C++-Binary-Anpassung). „In Stein gemeißelt" bezieht sich NUR auf (A). Steuerrater A/B haben einen eigenen, separaten Domänen-Baum (teilen (A) NICHT) — Konformität offen (R-ÖKO-1). Details: `Products/comdare-db/docs/architecture/2026-07-03-COMDARE-OEKOSYSTEM-UND-NACHBARSYSTEME.md`, [[project_deferred_steuerrater_buildsystem_***REDACTED***]].
