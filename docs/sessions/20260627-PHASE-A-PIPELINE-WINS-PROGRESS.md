# Phase-A Pipeline-Wins — Progress (2026-06-27)

> **Auslöser:** Goal-V (2026-06-27) — Impl-Agent arbeitet offene konsolidierte TODOs ab; Session-Start via ultracode-Survey + Codex-Last-5-Summary; Codex-Review nach größeren Abschnitten; Rückfragen bei schweren Entscheidungen. **Single-Source #186** = `20260625-CICD-PIPELINE-ARCHITEKTUR-4-MODULE-BASIS-PIPELINE-PRINZIP.md`.

## 0. Codex-Compliance-Verdikt (gpt-5.5/xhigh, 2026-06-27) — der eigentliche Kontext
**Frage (User):** Erfülle ich über die letzten 10 Sessions die Hauptanforderung der Pipeline?
**Verdikt: NEIN — nur ~35-40%.** Kern-Erkenntnis = **Scope-Korrektur:** die **4-Modul-Foundation** (harte Gates grün) ist nur eine TEILMENGE; die echte Hauptanforderung (#186) ist breiter:

| Gap | Status | autonom? |
|---|---|---|
| Echte Mess-Pipeline (mehrtägig PMC→NAS-Writeback→PDF, fastest-tier-Binary) | OPEN | ❌ Fenster/Storage |
| 10-Stufen-Rest (integration/chaos/manifest/deploy/staging/canary) | OPEN | teils ❌ infra |
| **Super-Orchestrierung** (child-pipeline trigger fehlte) | **→ DONE (s.u.)** | ✅ |
| prod2/Intel-Recovery + ISA/OS-Matrix | OPEN | ❌ |
| Thesis-Hard-Gate (chktex-fail / latexmk-warning / .blg) | PARTIAL | ✅ teils |
| #179 (lint:format/static → HART) | OPEN | ✅ |

**Contradictions (Codex):** Doc-Claim „Foundation grün 06-26" vs. „06-27 pending" → **aufgelöst: Wave-4 diese Session verifiziert grün** (cache-engine #6999 + prt-art #7000 success; super #7001 lief); **Stale CI-Header** (REV10/REV1 vs. echte REV14/REV12) → Fix offen (kosmetisch).

## 1. Entscheidung (User 2026-06-27)
**„Beides: erst Pipeline-Wins, dann #179."** Phase-A-Reihenfolge: **#3 Super-Orchestrierung → Stale-Header/Contradictions → #5 Thesis-Gate-Semantik**; danach #179. Jeder größere Abschnitt mit Codex-Gegenreview (CI-YAML ausgenommen → Verifikation via realem Pipeline-Lauf).

## 2. #3 Super-Orchestrierung — ✅ IMPLEMENTIERT (super REV13, commit 306a5aa)
**Soll (§5.4):** „Super = Haupt-Pipeline, orchestriert die 3 Modul-Pipelines (`trigger`/`include`)."
**Umsetzung** (`.gitlab-ci.yml`, minimal-invasiv):
- Neue Stage `orchestrate` + 3 Bridge-Jobs `trigger:cache-engine` / `trigger:prt-art` / `trigger:thesis`.
- Je `trigger: { project: comdare/research/<repo>, branch: main, strategy: depend }` (strategy:depend = Super spiegelt Kind-Status → Super ROT, wenn ein Modul rot ist = echtes Gate).
- `needs: ["lint:secrets"]` → erst nach Supers hartem Secrets-Gate triggern.
- Projektpfade aus `.gitmodules` (relative URLs → `comdare/research/{comdare-cache-engine, comdare-prt-art, 20260931-overleaf-diplomarbeit}`).
- **Stale-Header-Fix** super: REV10→REV13.

**Voraussetzung verifiziert (rate nie):** alle 3 Kinder `job_token_scope.inbound_enabled=true` UND **super (288) bereits in der Inbound-Allowlist** aller 3 → `CI_JOB_TOKEN`-Trigger erlaubt, keine Allowlist-Änderung nötig.

**Verifikation (literal):** super-Pipeline **#7002** (sha 306a5aa) erzeugt = YAML valide; `/bridges` zeigt alle **3 Trigger-Jobs `created`**. ⏳ **OFFEN:** Downstream-Auslösen (`downstream_pipeline.id`) bestätigen, sobald `lint:secrets` grün ist (Bridges feuern dann). Danach: laufen die 3 Kind-Pipelines + Super mirrort deren Status?

## 3. Phase-A Rest (offen)
- **Stale-Header cache-engine/prt-art** (REV10→REV14 in Kommentaren) — kosmetisch, beim nächsten Edit dieser Dateien mitnehmen (kein eigener Push für Kommentare).
- **#5 Thesis-Hard-Gate** (§7 + §5.3): `latexmk` DE+EN, **0 Fehler ≤1 bekannte Warning**, `.blg`/Repeated-entry-Check; chktex-fail-Semantik (aktuell `|| true` + nur `COMDARE_TEXLIVE_AVAILABLE`-gegatet). Autonome Teile (Gate-Logik/Log-Parsing) jetzt; TeXLive-Verfügbarkeit = infra-gated.

## 4. Danach: #179 Wartbarkeits-Sweep
Scoping ZUERST mit Codex (Hotspots → wo nachlesen), DANN datei-für-datei mit Codex-gpt-5.5/xhigh-Gegenreview; am Ende lint:format/static → HART + test_v41-Linux-Vollbau.

## 5. Angewandte Direktiven
- Codex-Scoping VOR teuren ultracode-Workflows (Codex sagt WO nachlesen → gezielt; spart Tokens).
- Codex IMMER gpt-5.5/xhigh (per-call-Override).
- Dokumentation nach jeder abgeschlossenen Aufgabe (dieses Doc).
