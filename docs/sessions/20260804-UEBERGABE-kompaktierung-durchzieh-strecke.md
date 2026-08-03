# KONTEXTUEBERGABE 04.08. frueh — Kompaktierung waehrend der DURCHZIEH-STRECKE (reich, bindend)

> **COMPACT-REGEL (Owner-Order, stehend):** Nach JEDEM Compact ZUERST einlesen, in dieser Reihenfolge:
> (1) Memory `feedback_claude_code_arbeitsweise_v2_konsolidiert.md` (Arbeitsweise v2.1 + B.3-Nachtraege 02./03.08.) ·
> (2) DIESES Doc · (3) `docs/sessions/20260803-FAHRPLAN-gesamtkette-wellen-phasen.md` (+ L1-L22-Nachtrag!) ·
> (4) Ledger-NACHTRAEGE 03.08. (ab ~:3653 bis Ende) · (5) `20260802-OWNER-entscheide-...md` (alle Nachtraege) ·
> (6) Lage-Dossier `backups/20260802-kontext-neugruendung-abend-workflows/00-SYNTHESE-lage-dossier.md` (Direktiven/Vertraege).
> Memory-Index MEMORY.md wird ohnehin geladen; Explore-Doktrin gilt: Entscheidung fehlt -> ERST Explore, alles ist entschieden.

## 0. OWNER-MODUS (verbatim persistiert, cb07a717)

„Arbeite ALLE Phasen in einem Zug ab, ohne zu stoppen." — Autonome Durchzieh-Strecke Phasen 0.5-5 inkl.
TRIGGER Do 07.08.; **Messung (Phase 6) bleibt USER-GO-gated** (stehende Doktrin, dort stoppen + GO erbeten).
Ultracode AN (Workflow-Tool je substanzieller Aufgabe, Modelle explizit: Fable=Design/Review/Synthese,
claude-opus-5=Struktur nach Design mit Probe+Fallback 'opus', Codex defekt auf prod1 -> Fable-Ersatz-Lens dokumentieren).

## 1. LINIEN-IST (04.08. frueh; ALLE Invarianten zuletzt verifiziert)

| Repo | dev | main | Zustand |
|---|---|---|---|
| ce (286) | **0b3a0b39** (OD-10-RT-Merge, gepusht beide Remotes) | ab2c60fd | **Pipeline 14372 LAEUFT** (Monitor b7rc1j81g aktiv). Nach GRUEN: main-FF PINNEN `git push origin 0b3a0b39f0b471c88af6d2915d0b3a5e58e3bd65:refs/heads/main` + github |
| super (288) | lokal **a05240c3** = origin+4 (a05240c3 prtart-Gitlink L16, 52aedf2d D-08-Fix, 03641065 FAHRPLAN-L1-L22, cb07a717 Owner-Order) + DIESE Uebergabe | 58b773e9 | Working-Tree: nur ce-Gitlink-ahead (0b3a0b39, Bump nach ce-Gruen) + `?? measure_out_d03` (V6-Default). **Push der Serie = Teil dieser Uebergabe**; danach CI-Gruen pruefen, main-FF nachziehen |
| thesis (289) | 29a1700 == main | 29a1700 | KOMPLETT (Anhaenge+Kapitel) |
| prtart (287) | c6f0754 == main | c6f0754 | KOMPLETT (E-02); super-Gitlink-Bump a05240c3 faehrt mit |
| Cluster | 09ebf1f+ (E-19-Handout L8 GEBRACHT + gitlab-500-Handout) | — | Infra aktiv (K118-Serie); Rueckmeldungen offen: E-19-Checkliste I112:244-273, gitlab-500-Root-Cause |

**Heute/gestern GELANDET:** Welle 2d · **A13 KOMPLETT M1-M4** (Neuanker: Layout v6, injektives Preimage
[Separator+fingerprint_format-Erstglied+Werteset-Glied+Overlay-Slot leer], ENFORCE=1 SCHARF, Contract 7.1,
prod 285/285, lokal 331) · **OD-10-RT** (0b3a0b39, LANDEBEREIT-Review, 4 Commits, 332 Tests lokal — CI laeuft) ·
Thesis-Anhaenge (18/3/11/3+MM) + Kapitel-Stempel · Design-Dossiers A8/E24/A9 (ce docs/architecture) + E07
(super) · E-02-Ledger prtart+thesis · Gegenlese (15 Deltas) · 11 Entscheide Explore-verifiziert · PhasenCheck
L1-L22 verarbeitet (03641065).

## 2. LAUFENDE ARBEIT (bei Wiederaufnahme ZUERST verarbeiten)

1. **Monitor b7rc1j81g:** ce-Pipeline 14372 (0b3a0b39). Bei GRUEN: main-FF (SHA oben pinnen!) -> super
   ce-Gitlink-Bump + OD-10-Lande-Ledger-Text (Muster: M3/M4-Nachtraege am Ledger-Ende) -> super-Push -> Wache.
   Bei ROT: Jobs+Trace diagnostizieren (Praezedenz: lint:static-cppcheck-FP -> Suppression; lint:format -> cf22 ueber ALLE Paket-Dateien).
2. **wf_eb0cf566 phase1-lager-rest-welle** (LAEUFT; Journal subagents/workflows/wf_eb0cf566-757/journal.jsonl):
   Design (Fable: Scheiben-Bauplan S0-S5 nach ${SP}/lager-welle/bauplan.md) -> Bau S0S1 (F3-Testschuld-Test +
   L9-B2-Kontraktpruefung super-main.cpp:1239, Patch-VORSCHLAG nur als Datei) -> Bau S2-S5 (lager_pfad_grammatik.hpp
   [L5: EIN Owner diese Welle], Baum-Writer 2 Realm-Wurzeln [L3: KEIN Hybrid-Segment], complete-heuristik.log+
   SHA512-Overlay+Truncate-ZM [Abnahmen 1-6], G-E3 Mess-Genus-Writer, G-E6 Versions-Tag, G-E7 Dual-ccache,
   Takeover-Aufrufer, N8-B, TP1-Arbeits-Inventur-Deklaration) -> Fable-Lande-Review. Branch lager-rest in
   /home/comdare/wt-m3. VERARBEITUNG: Backup sichern -> Verdikt -> Landung in Voll-Kadenz (rescue-Refs beide
   Remotes -> merge --no-ff -> Tree-Identitaets-Check -> gitleaks super-Mount -> Push -> CI-Wache VOLL-SHA ->
   main-FF PINNEN -> super-Gitlink+Ledger). Bei NACHBESSERN: fokussierte Welle (Muster wf_605c83c3 K-6).
3. Danach Phasen-Kette (FAHRPLAN + L-Nachtrag): **W10** (System-Zellwerte in system_stamp_line) ->
   **E-24-FENSTER-BAUPLAN als ultracode-Planungssession (L4!) dann E-24-Fenster** (Major 7->8, EIN S12-Fenster,
   A8-Scheiben S1/S3/S4/S5 VORHER — L6: A8-S1 mit T17-Messwert-Verlust-Fix hat VORRANG, Laufzeit-Beleg literal
   VOR dem Fix; M0 organ_concept.hpp sofort parallelisierbar) -> **A2-Eichung ZULETZT** (mit leerem Overlay-Glied,
   L14-Deklaration) + TP1-FINAL-Inventur -> Phase 3-Parallelspuren (A9 nach LB-Schnitt-Kern [L5], OS-U4+U5+Z-04,
   FK-3/4, A10+prod2-SPD, A7-Rest+Z-05/06/08, A11 [+STRUKT-R-Quittung L22, Z-12-Benennung], A12, Thesis C1-Rest/C4/C6/C7) ->
   Phase 4 (Beweise 1-5 [B5 nach E07-Dossier:89-125, <1h-Re-Run], 12-Perm+FS1, ETA/Kalibrier) ->
   **Phase 5 TRIGGER-SEQUENZ mit dem VOLLEN 7-Auflagen-Satz (L1, LEDGER:98 woertlich!) + J-0..J-5-Hygiene (L2) +
   D-10-Eichung (L11)** -> Phase 6 STOPP am USER-GO (E.0 zuerst!).

## 3. TASK-STACK (Store wurde MEHRFACH geleert — dieser Block ist die Wahrheit; nach Compact neu anlegen)

[S1] Durchzieh-Strecke aktiv: OD-10-CI -> Landung abschliessen -> Lager-Welle verarbeiten -> W10 -> E-24 -> A2 -> P3/P4 -> Trigger Do 07.08.
[S2] wf_eb0cf566 Lager-Rest (LAEUFT) — F3(S0)+L9(S1)+LB-Schnitt(S2/S3)+G-E3/E6/E7(S4)+Takeover/N8(S5); Verarbeitung nach Meldung
[S2] OD-10-Landungs-Rest: 14372-Terminal -> main-FF 0b3a0b39 -> super-Gitlink+Ledger-Text
[S2] super-Push-Serie + main-FF-Nachzug (nach dieser Uebergabe gepusht; CI pruefen, dann FF pinnen)
[S3] Phase 0.5 Hygiene-Block (L20: Memory-2-Dateien-Nachtrag, Kopf-Klauseln, 14 gelandete Worktrees aufraeumen, Scratchpad-Sweep) — nebenher, nie kritischer Pfad
[S3] Phase 6.5 Nach-Abgabe-Behaelter (L21) + f2/f3-GOs + Overlay-Fenster + #327 — NACH Abgabe
[S3] Merkposten: Codex-Zweitlens Z-02/Z-03 sobald Codex-Umgebung; Overleaf-Klon-Sync nach C6 (L17); D-07-K5-Zahl nach A4; Infra-Rueckmeldungen E-19+gitlab-500

## 4. FALLEN-KANON (diese Session real erlebt — NICHT wiederholen)

PAT: Blind-Extraktion, RUECKWAERTS bis HTTP 200 (zuletzt Position 7=letzte), shred nach Gebrauch ·
Pipelines-API ?sha= nur VOLL-SHA (Kurzform=stumm leer!) · git IMMER mit -C (CWD-Falle 2x heute: Owner-Docs
im ce, Backup-Pfad) · main-FF NUR mit gepinntem Voll-SHA, nie rev-parse HEAD · merge kennt KEIN --no-rebase
(nur pull) · cf22 ueber ALLE Paket-Dateien inkl. tests/ (nicht nur Trace-Treffer) · worker-super-Commits
brauchen Manager-Format-Abnahme VOR Push · thesis-Merges: Branch VORHER pruefen (main-Unfall 03.08., geheilt)
· thesis-Commits BEP OHNE Trailer; prtart/ce/super MIT · gitleaks: Hauptrepo mounten, Submodul via Pfad,
"N commits scanned" pruefen · Idle-Meldung ohne Bericht: Bericht am Objekt aus Agent-Transkript holen
(laengster Assistant-Text), dann stoppen · Neustart nur nach positivem Todes-Beweis (mtime+Journal) ·
Monitore nie stumm (Diagnose-Zeile nach 3 Leer-Antworten) · ENFORCE=1: jede NEUE ce-Version vX.Y.Zc ·
Ein-Schreiber je Worktree; wt-m3 traegt aktuell Branch lager-rest (Welle) — NICHT parallel anfassen.

## 5. OFFENE OWNER-PUNKTE (alle nicht-blockierend, Defaults laufen)

f2 Tombstone-GOs + f3 comdare-analysis-GO+Name (nach Abgabe) · 3 Overlay-Festlegungen (spaeteres Fenster;
Slot layout-bruch-frei vorbereitet) · OF-A8-2-NUR-KENNTNIS (E1-Lesart via Pauschal-GO gedeckt) · #327 nach
Messfenster · V6 measure_out_d03 behalten-untracked · Messung Phase 6 = USER-GO.
