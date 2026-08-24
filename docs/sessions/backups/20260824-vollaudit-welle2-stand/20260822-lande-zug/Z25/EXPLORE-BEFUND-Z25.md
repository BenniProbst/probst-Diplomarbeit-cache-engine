# Z25 EXPLORE-BEFUND (24.08.2026, vor dem Eingriff) — W2-Wellen-Ende-VOLLAUDIT-BACKUP

## STRUKTURELL

- super-Hauptklon /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine:
  development @ 14bf6658 (Z24-Ledger), status --porcelain = 0 Zeilen (clean, Gitlink-Bump
  Z23 vollzogen). origin/development = a23e6cda -> genau 1 unpushed Commit (Z24).
  Push-Bereich nach Z25-Commit = a23e6cda..HEAD = 2 Commits, 0 Merges.
- Ziel-Pfad docs/sessions/backups/20260824-vollaudit-welle2-stand/ EXISTIERT NICHT ->
  rein ADDITIVE Anlage, keine Merge-/Konflikt-Flaeche (kein git merge noetig; docs-Commit).
- .gitignore:52 `*.log` (LaTeX-Artefakt-Block *.aux/*.toc/...) wuerde die Log-Kopien
  schlucken. PRAEZEDENZ GEMESSEN: git ls-files "*.log" = 98 bereits getrackte .log unter
  docs/sessions/backups/ (u.a. 20260806-b14-nb2/gates/*.log) -> `git add -f` auf den
  EXPLIZITEN neuen BU-Ordner ist der etablierte Weg (keine .gitignore-Aenderung noetig).
- Keine .git-Nester, keine Symlinks in den Quell-Ordnern (find-Probe leer).
- df -h /: 20G frei (>5G-Gate; kein Bau in Z25, nur Kopie ~41M + Commit).

## DESIGN

- Owner-Dauerregel 21.08. (verbatim-Kern im W1-VERMERK): Rohdaten + Ergebnisse des
  Vollaudits je Wellen-Ende als Beweis in docs/sessions/backups/ sichern. Muster =
  docs/sessions/backups/20260821-vollaudit-welle1-stand/ @ 86f4fc1e (82 Dateien, 16M,
  VERMERK.md + Journal + "Folge-Schnappschuesse je Welle: gleiche Form unter
  docs/sessions/backups/<datum>-vollaudit-welle<N>-stand/").
- L-15 [PFLICHT, Wellen-Ende] (SYNTHESE-S1-AUDIT.md:227, KON122 bestaetigt): AB-09
  fixstrecke2-BU "237 Dateien (20260819-fixstrecke2-logs/) + 8 JB-2-Logs (hy-a/) ADDITIV
  nach docs/sessions/backups/ spiegeln, mit NEUER gitleaks-Redaktion (stdin-Modus MIT
  --config PFLICHT; Koeder aus einer Regel der wirksamen Config MUSS beissen, glpat-+20
  gilt, AWS beisst nicht; Bilanz JE Datei; Koeder-Literale in Commit-Texten MASKIEREN)".
  LIVE-Zaehlung 24.08.: 20260819-fixstrecke2-logs = 236 top-level + 5 in
  c3_mischbau_beweis/ = 241 Dateien (L-15 nannte 237 am Stand 19.08.; Ordner ist additiv
  gewachsen; ALLES wird gespiegelt, nichts gekuerzt). hy-a = exakt 8 Logs
  (20260817-welle-vorlauf-protokolle/hy-a/).
- KON122-MERKPOSTEN (Z24-Nachtrag, "Naechste Zuege"): "L-15/AB-09 fixstrecke2-BU +
  V91-A1-Kopie + W2-VOLLAUDIT-BU je Wellen-Ende (Z25; MERKPOSTEN: FREMD-Ordner
  20260821-w1l-landung/cifix2-vl3debug/ MITNEHMEN)" -> cifix2-vl3debug: 34 Dateien, 4.1M.
- V91-A1-BEWEISORT-ZEILE (KON122): "T-11c-Mutationsprotokoll M1-M4 = vollzug-91-ergebnis.md
  Abschn. 7 (deklarierter Beweisort); Kopie in den W2-Wellen-Ende-Vollaudit-BU (Z25)".
  Quelle gefunden: /home/comdare/backups-workflow/20260820-w2-sofortstaffel/
  vollzug-91-ergebnis.md (287 Z.; Z.229 = "## 7. VERIFY-QUITTUNGEN (literal, 21.08.)").
  Z05/BEFUND-INDEX bestaetigt: "V91-A1 -> Z25-Vollaudit-BU".
- Hauptquellen LIVE gemessen: 20260821-w2-audit-fixverify = 147 Dateien / 4.4M
  (19 Strang-Ordner a19..vorlagenfenster + SYNTHESE-S1/S2 inkl. ERSTFASSUNG/VORHER-
  Fassungen + GEGENLESE-GATE.md + ERSTLAUF-ENDBERICHT + 2 result-KOPIEn);
  20260822-lande-zug = 473 Dateien / 22M (Z01-Z24-Beweise inkl. Kombibau-/Gate-/CI-Logs,
  Inventur-Rohlogs roh-*.txt, inventur.md, ZUG-BILANZ.md, RISS-ENOSPC-Vermerk,
  ENDSTAND-PRUEFUNG-r2, untracked-sicherung/, LEAD-POINTER, wellenplan-soll-ist.md).
- Journal ("journal.jsonl = Wahrheit"; W1-Form workflow-journal-<wf>.jsonl): 21 Journale
  des W2-Fensters = 5x 21.08. NACH W1-BU-Schnitt 07:08Z (wf_2cbc2ee0, wf_b954e62e,
  wf_95033571, wf_29b3b9e5, wf_cc1edd79) + 16x 22.-24.08. (wf_c267c180, wf_6d754bf7,
  wf_214ff767, wf_94813666, wf_fdb84b2f, wf_aaef0e71, wf_b6ce88a4, wf_bc7303ab,
  wf_23486ee9, wf_f3f75b60, wf_c745729a, wf_bce0efd4, wf_98cabd77, wf_c37fb077,
  wf_08c04723, wf_b546634b=laufender Lande-Zug, Kopie = Schnappschuss zum Kopier-
  zeitpunkt). wf_2c6cd0b8 (W1-Audit) liegt bereits im W1-BU — nicht dupliziert.
- NICHT enthalten (Doktrin, wie W1 + .gitignore-Vermerk 20260712): Session-/Agenten-
  Transkripte agent-*.jsonl (Live-Tokens, nie committen). Board-Dump = Lead-only.

## HISTORISCH

- quelle_tip = Owner-Order 21.08. (Dauerregel, Memory feedback_nach_jeder_welle_
  vollaudit_backup_im_session_ordner) — kein juengerer Widerruf; Muster 86f4fc1e ist
  das einzige und juengste Vollaudit-BU (W1). Juengste KON = KON122 (14bf6658, 24.08.)
  BESTAETIGT Z25 ausdruecklich und ERWEITERT um den cifix2-vl3debug-MERKPOSTEN.
  Kein Ueberholt-Marker. Die 18/18-Freigabe vom 19.08. deckt NUR den Alt-Schnappschuss
  (L-15-Wortlaut) -> NEUE gitleaks-Redaktion ist Pflicht und wird gefahren.
- Redaktions-Vorpruefung (24.08.): grep -rEl "glpat-[A-Za-z0-9_-]{20}" ueber ALLE
  Quell-Ordner + alle 21 Journale = 0 Treffer (rc=1). Nur Kurz-/Prosa-Erwaehnungen
  "glpat-" ohne 20er-Tail (beissen nicht; Praezedenz: W1-BU enthaelt solche committed,
  Echt-Scan war rc=0). super-.gitleaks.toml traegt die Koeder-Prosa-Allowlist
  ("Koeder...glpat-..." in derselben Zeile) fuer Commit-Texte.

## PLAN (danach Vollzug)

1. Ziel-Ordner docs/sessions/backups/20260824-vollaudit-welle2-stand/ anlegen; Quellen
   per cp -a spiegeln (Unterordner = Quell-Identitaet); V91-A1-Kopie + journals/;
   VERMERK.md in W1-Form.
2. gitleaks-Redaktion NEU: Koeder glpat-+20 (Laenge 26 asserted) via stdin+--config MUSS
   rc=1 beissen; danach Bilanz JE DATEI ueber alle kopierten Dateien (stdin+--config),
   Soll: 0 Leaks je Datei; Logs nach Z25/.
3. git add -f NUR auf den neuen Ordner; Zaehl-Abgleich find==index; Commit in W1-Form
   (koeder-freie Prosa) + Trailer.
4. sh scripts/vor_push_alle_wachen.sh (Inventar, Basis origin/development); gitleaks
   Echt-Scan --log-opts a23e6cda..HEAD (Soll rc=0, "2 commits scanned" == rev-list
   --count --no-merges); R4-Pipelines-Lage 286/287/288; Push origin+github;
   1 Push = 1 Pipeline auf 288, Monitor bis TERMINAL (Nenner /jobs UNION /bridges).
5. Beweise SOFORT nach ~/backups-workflow/20260822-lande-zug/Z25/.
