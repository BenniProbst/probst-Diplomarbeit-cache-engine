---
name: project_mess_ergebnis_rueckschreibung_pipeline_persistiert
description: "Erweiterung des §0-Diplomarbeit-Ziels (NICHT neu): die Pipeline soll beim Lauf über die cache-engine die Auswertungsdokumente (LaTeX-PDF + Messwerte-CSV, alle Overleaf-Auswertungsformate) erzeugen UND am Laufende automatisch nach development zurückschreiben (commit+push) in measurement/<datiert>/ — sonst gehen die Ergebnisse verloren; später zusätzlich parallel nach backup1-NFS"
metadata:
  type: project
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**Direktive (User 2026-07-11) — ausdrücklich eine ERWEITERUNG des bestehenden §0-Ziels, NICHT ein neuer
Zielauftrag.** Der Mess→PDF-Fluss ist erst vollständig, wenn die **Diplomarbeit-Pipeline** beim Durchlauf ÜBER
die comdare-cache-engine:
1. die **Auswertungsdokumente erzeugt** — LaTeX-PDF + Messwerte-CSV = ALLE in der Overleaf/Thesis-Messwerte-
   Sektion definierten Auswertungsformate (die LaTeX-Diplomarbeit generiert in dieser Sektion automatisch alle
   Formate), UND
2. sie am **ENDE des Pipelinelaufs AUTOMATISCH nach `development` zurückschreibt** (commit + push) — sonst gehen
   die Messergebnisse zum Schluss einfach verloren.

**Ablage:** je Lauf/Commit ein NEUER **datierter Unterordner** `measurement/<YYYYMMDD-HHMMSS>/` im Diplomarbeit-
Root (Diplomarbeit-Repo = super `probst-diplomarbeit-cache-engine`). So liegt neben dem fertigen PDF ein
**versionierter Messwertebaum je Commit**. User-Wunsch-Format war „YYYYMMTT-HH:SS" — `:` ist FS-unsicher auf der
Windows-/msvc-Build-Matrix → filesystem-sichere Variante `YYYYMMDD-HHMMSS` festlegen (offen G-a). User ist sich
der git-Datenakkumulation bewusst — bewusst die einfachste Variante zuerst.

**Phase 2 (später, additiv):** dieselben datierten Ordner ZUSÄTZLICH **PARALLEL** nach
`backup1.comdare.de/Cluster_NFS/cache-engine-experiment` schreiben (beides parallel = doppelte Absicherung).

**MECHANIK GEBAUT + SCHARF (2026-07-11, super `0d86098`):**
- **G-b Write-Credential GELÖST:** Project-Access-Token id=54 write_repository-only (Details + Rotation:
  [[reference_measurement_writeback_token_288_secure]]). Loop-Schutz dreifach (`[skip ci]`+`ci.skip`+`_bot_`-rule).
- **G-c NAS-Vorbehalt AUFGELÖST** (User „Ja das backup genügt. GO"): dev-Bundle + dual-remote + bewiesene
  Additivität = akzeptiertes Backup. Phase-2-NAS bleibt späterer additiver Schritt.
- **Aktivierungs-Modell = PER-PIPELINE, nicht global:** `COMDARE_PERSIST_MEASUREMENTS=true` wird NUR beim
  Mess-Trigger zusammen mit `COMDARE_RUN_MEASURE=true` übergeben (NICHT als global-always-on Projekt-Var — die
  erzeugte je dev-Pipeline einen `measurement/<ts>/`-Commit = Rauschen). So persistiert NUR ein echter Mess-Lauf;
  der Normal-Gesamtlauf (Messung AUS) bleibt commit-frei. Token bleibt protected → Boundary hält.
- **G-d Mess-Job `measure:golden-320`** (stage `measure`, INERT via `rules COMDARE_RUN_MEASURE=="true"`): fährt
  `comdare-messung-driver experiment_config measure_out` (golden-320) auf PMC-Node prod1 (Runner id=16, tags
  `[prod,baremetal,amd]`); `timeout 10 d` < Projekt-`build_timeout` 14 d (von 1 h angehoben). `persist:measurements`
  sammelt `Code/measure_out` additiv (needs optional) → Mess-CSVs am Lauf-Ende nach development.

**Trigger-Rezept (Messlauf anstoßen):** POST pipeline auf `development` mit Vars `COMDARE_RUN_MEASURE=true` +
`COMDARE_PERSIST_MEASUREMENTS=true`. Normal-Gesamtlauf = OHNE diese Vars (measure+persist inert).

**2 KRITISCHE Bugs beim End-to-End-Durchtesten gefunden+gefixt (super `57f774f`, NIE re-brechen):**
1. **`.gitignore *.csv` droppte die Mess-CSVs still** — `git add -- measurement/` hätte nur PDF/Manifest committet,
   die `measurement/<ts>/…/*.csv` (das Ergebnis) verschwunden. Fix = Negation **`!measurement/**/*.csv`** in
   `.gitignore` (empirisch mit `git add` verifiziert; `check-ignore -v` lügt bei Negationen — immer echt-testen).
2. **`measure_out` enthält ~320 DLL-Binaries** → Fix = Mess-Job-Artefakt-Glob `Code/measure_out/**/*.csv` +
   persist kopiert selektiv NUR `*.csv` (nie `cp -r` das ganze measure_out).
**Lehre:** das reale Durchtesten der Pipeline (User-Direktive „echtes Verhalten durchtesten + Plausibilität") fing
beide ab — sonst wäre der mehrtägige Lauf in einem stillen CSV-Drop geendet. Voll-Validierung (5 Stufen bis PDF):
Backup `docs/sessions/backups/20260711-pipeline-e2e-validation-real-data/`.

**Verankert:** Ledger §0-DoD-6 + §11-G (G-a..G-d) + §12-Log (2026-07-11); sichtbare Task-Liste #22. Baut auf
REV-17-Submodul-Fetch-Fix. Bezug: [[feedback_ci_gesamtlauf_ist_messung_abgeschaltet_pdf_kompiliert]] (Gesamtlauf =
Messung AUS; Rückschreibung persistiert den Mess-Output), [[feedback_thesis_nur_user_ideen_persistieren]].
