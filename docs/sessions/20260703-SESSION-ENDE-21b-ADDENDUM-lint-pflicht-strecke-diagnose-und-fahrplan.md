# SESSION-ENDE 21b (ADDENDUM zu SE-21, 2026-07-03 ~00:00–01:00) — lint-Pflicht-Strecke: Diagnose komplett, Fix 1/3 gelandet

> **EINSTIEG:** (1) SE-21 (`20260703-SESSION-ENDE-21-188-4c-KOMPLETT-…md`) = 4c-Abschluss + 7 Fallstricke.
> (2) DIESES Addendum = der NEUE User-Auftrag danach. (3) Memory
> `feedback_command_pattern_achsen_mess_visitor_container_in_sa` — der ⚡-Block (Kopf) trägt Diagnose,
> Umschalt-Rezept und alle IDs; der 🏁-Block den 4c-Endstand. Tasks: #203 in_progress (lint), #250/#211 DONE.

## §0 SOFORT-STATUS bei Kontext-Ende (laufende Dinge!)
- **Verify-Job 192563** (Projekt 286, lint:static auf FRISCHER Pipeline 7474, testet ci-templates-Fix
  `968b333`): lief bei Kontext-Ende. ERSTE HANDLUNG nächste Session: Status+Trace prüfen.
  GRÜN = cppcheck-Bug fix bestätigt (dann echte static-Findings zählen — evtl. 0 dank inline-suppr);
  ROT = exe-relative cfg-Suche griff nicht → Fallback: `-DFILESDIR="$CITOOLS/bin"` beim cppcheck-CMake
  ODER `--check-config`-Diagnose (ci-templates@development, Klon im Scratchpad ist FLÜCHTIG — neu klonen).
- Restliche 7474-Jobs = drittes Duplikat auf 3ee71c6 → nach dem lint:static-Ergebnis canceln (Muster 7435/7470).
- Die ScheduleWakeup-Kette dieser Session ENDET mit dem Kontext — nichts läuft unbeaufsichtigt weiter außer
  den GitLab-Jobs selbst.

## §1 USER-AUFTRAG (2026-07-03, bindend): „Auf allen 4 Projekten alle lint als Pflichtdurchläufe"
IST-Erhebung ABGESCHLOSSEN (Methode: die manual-Jobs per API `play` auf bestehenden Pipelines = ehrlicher
Probelauf VOR dem Scharfschalten — dieses Muster beibehalten!):
| Projekt | Job | Probelauf | Ursache |
|---|---|---|---|
| cache-engine | lint:static | ROT | **[GEFIXT]** cppcheck-std.cfg-Template-Bug → ci-templates `968b333` |
| cache-engine | lint:format | ROT | **685+ ECHTE Verstöße** (Trace evtl. GEKAPPT — realer Umfang ggf. größer; 1371 C++-Dateien) |
| super | lint:static | ROT | derselbe Template-Bug (Fix deckt es) |
| super | lint:format | ROT | Bootstrap exit 3: `COMDARE_LLVM_SHA256_PIN` NIE BEFÜLLT (Integritätsgate) |
| prt-art | beide | UNGETESTET | play auf prt-art-Pipeline (z. B. 7463) nachholen |
| thesis | lint:latex (chktex) | LIEF NIE | texlive fehlt auf Runnern = INFRA-GATE #205 (thesis/diplomarbeit/.gitlab-ci.yml:37-49) |
Nebenbefund GEKLÄRT: „letzte Gesamtpipeline gescheitert" (super 7460) war TRANSIENT — analyse:thesis-data
= g++-16-ICE (csv_to_latex.cpp:1069), Retry 192494 SUCCESS; zweiter Rotpunkt war Downstream-Duplikat.

## §2 FAHRPLAN bis zur Umschaltung (Reihenfolge bindend — NIE bei rotem Ist scharfschalten!)
1. Verify 192563 auswerten (§0).
2. **LLVM-SHA256-Pin**: offiziellen SHA256 des LLVM-22.1.8-clang-format-Assets von der offiziellen
   Release-Quelle (Web-Recherche!) holen → als `COMDARE_LLVM_SHA256_PIN` (Template-Default in
   base-pipeline.yml ODER Gruppen-/Projekt-CI-Variable) → super-format-Probelauf neu (play auf FRISCHER
   Pipeline — s. Fallstrick F2!) → zeigt dann die ECHTEN super-Format-Verstöße (36 Dateien, klein).
3. **Format-Pass (#179-Teil, GROSS)**: clang-format über cache-engine (685+, 1371 Dateien) + super (36) +
   prt-art. Modalität: EIN mechanischer Format-Commit je Repo (kein Zeilen-Review; golden/ext/modules/
   _archive AUSSCHLIESSEN — dieselben -i-Excludes wie der Job!). Werkzeug: clang-format FEHLT lokal →
   entweder winget LLVM installieren (Version an COMDARE_LLVM_VER angleichen!) oder als CI-Fix-Job.
   Codex-tauglich mit engem Dossier.
4. prt-art-Probeläufe (beide lint) → ggf. dieselben Fixes.
5. **UMSCHALTUNG** (erst nach 4× grünem Beweis): super/.gitlab-ci.yml:47-62 + cache-engine:46-57 +
   prt-art:39-54 — je `allow_failure: true` RAUS + `rules: - when: manual` RAUS (Template-Default greift).
   Für lint:static ggf. Kommentar „advisory bis #179" im Template :123 mitziehen.
6. **thesis**: lint:latex bleibt bis texlive-Installation Infra-gated → INFRA-HANDOVER-Doc schreiben
   (Rollen-Direktive: ich mache KEINE Runner-Installationen; pve1-debian braucht texlive/chktex/latexmk,
   #205). Danach dort allow_failure raus + COMDARE_TEXLIVE_AVAILABLE-Rule auf Pflicht.

## §3 Zu markierende DEGENERATIONEN (unverändert offen, nicht diese Nacht entstanden)
- Masstree-Referenz erntet keys={0} (kein for_each_record-Walk) — nachziehen bei #234.
- Hüllen-Kompositionen: T4/T5/T6/T7/T13-T16 honest-0 bis observe-Hooks (#234/4b-c) — BEWUSSTE Konvention.
- cow_capable_-Kipp Richtung true durch 4c-iii (gewollt; #215-320-Neubau macht es real wirksam).
- abi_adapter-Include-NITs sind seit 4c-iv ausgeräumt; Builder-Pilot-Eigenpaar (anatomy_execution_context)
  wartet auf CMD-1-Konsolidierung (#251).

## §4 NEUE FALLSTRICKE dieser Nacht-Runde (zusätzlich zu SE-21 §2!)
- **F1 g++-16-ICE-HÄUFUNG**: heute 3× (node_shape, analyse:thesis-data, ggf. 7462-Duplikat) — IMMER erst
  Job-Retry via API vor jeder Code-Diagnose; bei Häufung Infra-Ticket erwägen (gcc-Version am Runner).
- **F2 Job-RETRY zieht KEIN neues CI-Template** — die Config wird bei Pipeline-CREATE eingefroren.
  Template-Fixes NUR über FRISCHE Pipeline (POST /pipeline?ref=main) + play testen.
- **F3 play-Probelauf-Muster**: manual-Jobs per API playen = risikofreier Gate-Test vor Scharfschaltung.
- **F4 GitLab-Traces werden GEKAPPT** — „685 Verstöße" ist eine UNTERGRENZE; Umfang lokal/im Fix-Job zählen.
- **F5 Bootstrap-Integritätsgates**: Template verlangt SHA-Pins (COMDARE_LLVM_SHA256_PIN) — bei neuen Tools
  Pin SOFORT mit einführen, sonst schlägt der Job auf un-gecachten Runnern fehl (Cache-Zufall!).
- **F6 CITOOLS-Cache je Runner-Workspace**: Tool-Bugs zeigen sich nur auf un-gecachten Workspaces
  (cache-engine-format lief, super-format nicht — GLEICHER Job, anderer Cache-Stand).
- **F7 gitlab.comdare.de-Pushes hängen nachts >2min** — origin zuerst, gitlab als Hintergrund-Task.

## §5 DIREKTIVEN-Erinnerung (unverändert bindend)
Manager-Modus (Codex implementiert aus Dossier, Claude korrigiert selbst; Plugin-Override-Flag!); verify NUR
Pipeline + Literal-Belege; ci-templates = comdare/cluster/ci-templates@development (Code-CI, von MIR direkt
editierbar — KEIN Codex dort nötig, aber auch kein Cluster-Infra-Tabu); modules/ext/golden/Registry tabu;
je Increment Commit+super-Bump; $null-Artefakte prüfen; AskUserQuestion NIE.

## §6 NACH der lint-Strecke (Reihenfolge aus SE-21 §3)
#216-H2-Rest (Mini) → CMD-1 (#251) + CMD-2 (#252) → #215-Schleuse → W4.5 (AP-1..7). User-Gates: #207 (M3
manuell), #225, texlive-Infra (#205), Runner-Upgrade (#208).
