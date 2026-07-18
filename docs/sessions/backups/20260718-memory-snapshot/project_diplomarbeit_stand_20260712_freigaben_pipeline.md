---
name: project_diplomarbeit_stand_20260712_freigaben_pipeline
description: "Stand 2026-07-12: User-Freigaben-Session (§11-I im Ledger = Quelle) — GO 1/3/4-F-C vollzogen, Smoke-Profil läuft, Sequenz-Rest F-B→Forks→GO 2 FINAL; golden-320-Messlauf #9916 läuft als Proof-of-Concept unter Fremdlast; CI-interaktive Diplomarbeit END-TO-END geschlossen. NACHZIEH 2026-07-16 (Audit F51): die GESAMTE GO-1-5-Sequenz ist KOMPLETT vollzogen (Ledger Z.124 + §12 07-12 Zyklen III+IV)"
metadata:
  type: project
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**Freigaben-Quelle: super-Ledger §11-I (wörtlich verankert).** Kurzfassung Stand 2026-07-12:

**VOLLZOGEN:**
- **GO 1** — Overleaf-Anhang verdrahtet (thesis `73947aa`, `\InputIfFileExists`, PDF-verifiziert) →
  CI-interaktive Diplomarbeit END-TO-END: XML→measure→Anhang-Regen (16 .tex via `08_appendix_generator`)→
  persist→PDF. Task #24 completed.
- **GO 4 F-C** (ce `a08a60ca`): Cacheline-B32 additiv + FF2-Unterachse `node_width {1,2,4,8,16}` (real
  konsumiert, Native-neutral). **F-B folgt** (User: „zusätzlich, als dokumentierter Permutations-Knopf").
- **GO 3** (ce `def62b0a`): ISA-Deklarations-Wahrheit (Kohärenz-Guard, objdump-belegt) + Scan-Kern-
  Reinheits-Guard (Mess-Kerne bewusst skalar — Zugriffsmuster IST das Signal). Task #5 completed.
- **#25 komplett** (format_tex.py→09_tex_formatter; codegen.cmake→cpp-Backend byte-identisch, opt-in).
- Infra-Handover geschrieben (V80-Filterpod write-only + prod1-concurrency 2→3): super
  `docs/sessions/20260712-INFRA-HANDOVER-nas-writeback-filterpod-und-runner-concurrency.md` — User überreicht.

**SEQUENZ KOMPLETT VOLLZOGEN (2026-07-12, Ledger §12 Zyklen I–IV):** Smoke-Profil ✅ (Multi-Sweep-Fix +
`m3_smoke_coverage` 93 Binaries + `measure:smoke`-Kette „erst Smoke, dann Voll") → F-B ✅ (alloc_hw,
honest-0 beseitigt) → GO-5-Forks ✅ (datasets-Schema, Dataset-Single-Source, fairness-Attribut, H2-Score
tool-berechnet 12+21-n/a) → Aufräum ✅ (ALLE 10 Profile validieren Exit 0; cap-0=kein-Cap) → **GO 2 FINAL ✅**
(cpp-Codegen-Backend = DEFAULT, Single-Pass-Fallback CI-neutral, byte-identisch + perm-DLL linkt real) →
mimalloc-GRENZE ✅ (perms-ON-Tree erstmals volle Suite 216/216). Endstand ce `e5946cdb`, super `0c34342`,
thesis `73947aa`. **Verbleibend NUR:** Messlauf-Strecke (daten-wartend) · Infra-Handover (beim User) ·
dossier-entschieden-gated (V32-Tilgung, Fork 4/#274, P/E-Core-HW, NUMA-Effekt-Multi-Socket, H2-Korrelation).

**Messlauf:** #9916 (`measure:golden-320` auf prod1/id=16) läuft mehrtägig = bewusster **Proof-of-Concept
unter Fremdlast** (User: Maschine wird parallel gebraucht, Geduld vorhanden; echte Kampagne später
lastisoliert). persist schreibt am Ende CSVs+Anhang-.tex nach `measurement/<ts>/`. CI-Drosselung akzeptiert.
DATA-gated darauf: #11/#17. Bezug: [[project_mess_ergebnis_rueckschreibung_pipeline_persistiert]],
[[reference_measurement_writeback_token_288_secure]], [[feedback_immer_schwerer_offizieller_weg_keine_behelfswege]].
