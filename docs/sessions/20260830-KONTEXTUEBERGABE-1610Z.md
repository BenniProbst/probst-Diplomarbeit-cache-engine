# KONTEXTUEBERGABE 30.08.2026 ~16:10Z -- Session 5a19728e (Lead, Fable 5 max)

Owner ~16:1xZ (verbatim): "Bitte schreibe eine reiche und elaborate Kontextuebergabe, der Kontext endet jetzt."
ERSTER Lesestoff des naechsten Kontexts. Ersetzt NICHT das Kipp-Ritual (ARBEITSWEISE-DICHT 704 Z. + MEMORY.md +
Memories 3 Tage + GOAL-DICHT voll + WELLENPLAN-DICHT W-0/W-H/W-6 + DESIGNPLAN-DICHT D0/D11 + Ledger-Kopf KON133);
es ergaenzt den Objektstand 16:08Z. Vorgaenger-Uebergaben (Historie): 20260829-KONTEXTUEBERGABE-1715Z.md (+2
Nachtraege) + PAUSE-PROTOKOLL-9 (geschlossen, 2 Wiederanlauf-Nachtraege).

## 0. Was JETZT gilt (Kurzfassung fuer den ersten Zug)

1. ZWEI Workflows LEBEN + EIN Poller -- NICHTS davon neu starten, NIE doppelt resumen (X-15: pgrep + Journal-
   Wachstum 2x/20 s VOR jedem Eingriff):
   a) E-10/Stempel-2-Lande-Zug wf_bf22ab45-485 (Task w3v6wb958): Stempel-2-BEWERTER laeuft (Opus-Erhebung +
      Codex-Lens liegen als Results); danach Stempel-2-Landung -> #114-Re-Run-2 -> EIN super-Bump (E-1-gated,
      nicht-fatal) -> Verify/Fix.
   b) Fold-Rest wf_fe1cf67c-94e (Task wkb61kww0): Reduce 16/16 KOMPLETT; Refuter-WELLE 1 laeuft (Batch 1-4
      Runde 1 + Zusatz-Sichter); danach Wellen 2-4, Assembleur, Final-Wache. Ziel:
      ~/backups-workflow/20260824-rueckfragen-synthese2/NEUER-LEDGER-konsolidiert-owner-antworten.md.
   c) Hintergrund-Poller bdl7dzzi9: CI 286/16286 (ce main-FF @ 5e03c2cc) -- 16:08Z running; bei SUCCESS
      Nachmessung 4/4 final + STAND.md-Abschluss (Lead); bei Rot STOPP-Doktrin (Praezedenz 16278 = earlyoom
      prod2 auf coverage-guard, kein Retry ohne belegtes Runner-Race).
   d) Cluster-Watch bjumv7ejf (60-s-Poller WG-Rotations-Beleg) laeuft bewusst weiter.
2. RISS-REGEL (K27, bindend): Der Workflow-Cache ist PRAEFIX-basiert -- Resume NUR mit BYTE-UNVERAENDERTEM
   Script (failed rerunnen automatisch, completed cachen). Script-LOGIK-Patches ohne Prompt-Beruehrung sind
   erlaubt (2x bewiesen: verify-47-Replay + e10-Replay nach Gate-Patch); jeder PROMPT-Patch macht ALLE
   nachfolgenden Calls frisch. Memory reference_workflow_cache_ist_praefix_basiert.
3. R4-ZOMBIE 288 BESTEHT: Pipeline 16275 + Child 16279 dauerhaft 'running' (Grandchild 16280 manual
   measure:amd) -> KEIN super-Push (auch nicht docs) bis Owner-Entscheid E-1. super development traegt LOKAL
   6 reine docs-Commits VOR origin 8be694ef (6abc121a, a99f9728, c448ba4c, 8f6ae0fa, c07783e9 + Commit dieser
   Uebergabe) -- die fahren im ersten Push nach E-1 mit.
4. Owner-Entscheide offen (je ein Satz): E-1 Zombie 16275/16280 canceln oder Design-Fix (Mess-Jobs
   rules-skip); E-2 prod2-Speicherbremse (VMs pausieren / kOwnerHeavyJIntel 24->16 / earlyoom-Ausnahme) +
   C-02-HEAVY-Signal VOR ##47-Re-Run-3 und ##49; E-3 codex login (Lens lief als AUSFALL/Ersatz -- Journal-
   Result des Codex-Fahrers lesen).

## 1. Owner-Orders dieses Kontexts (chronologisch, Kern)

- 30.08. ~09:2xZ (nach /login): "Die Pause ist vorbei, bitte resume ALLE Agenten und Workflows ... Bitte plane
  zuerst eine Sinnvolle Einteilung und aenderung und Heilung der Workflows, weil es das letzte Mal schief
  ging" + davor "7 Millionen Tokens im Klo runter gespuelt, ich denke wir sollten den reduce besser in 4 Batch
  Phasen bauen. Er lief jetzt nochmal und moeglicherweise decken sie die ersten gesicherten Abschluesse mit dem
  zweiten doppelten Durchlauf des reduce. Bitte heile das und resume dann wieder alle Agenten und workflows."
  -> VOLLZOGEN: K27-Diagnose, fold-rest-3008.js (Wellen), Resumes; Owner-Sorge bestaetigt (reduce-14 trug
  20 Abschnitte = Doppellauf -> bereinigt, Rohkopie .roh-doppellauf-lauf2und3).
- 29.08. (Vor-Kontext, verbucht): "Die 7 regulaeren wurden nicht replayed aus dem journal cache oder sehe ich
  das falsch?" -> Owner sah RICHTIG (K27-Ursache Praefix-Cache).
- "Bitte pruefe den Plattenspeicher von prod1" -> geprueft + geraeumt (Abschn. 5).
- ~15:3xZ (nach /login): "Die Pause ist vorbei, bitte resume ALLE ..." -> vollzogen (Riss 4 geheilt).
- ~16:1xZ: diese Uebergabe.

## 2. Objektstand 16:08Z (gemessen)

- ce 286: origin==github development==main==5e03c2cc (E-10-LANDUNG! Merge bd55942a + 2e9b8697, 9 Commits).
  CI: dev 16281 SUCCESS (26+1manual, 10:38:53Z); main 16286 RUNNING (Push 15:38Z, erwartet ~44 min).
  Worktrees: wt-ce-lande4 @5e03c2cc lande/e10-2908 (Gate-Baum build-k17-gcc-rel 3.7G BLEIBT), wt-ce-e10
  @2e9b8697 (Gate-Baum 3.7G, nach Zug-Terminal raeumbar), wt-ce-stempel2 @bb5b6949 (3.9G, nach Landung
  raeumbar), wt-ce-114rerun.
- super 288: origin==github dev==main==8be694ef; LOKAL dev = 6 docs-Commits voraus (UNGEPUSHT, E-1).
  prt-art 287: dev==main==b539d6ee. Zombie 16275/16279/16280 unveraendert.
- Platte / 26G frei (90 %; lande3-Gate-Baum 3.7G am 30.08. 10:1xZ nach Q3-Audit geraeumt, Beleg
  RAEUMUNG-GATE-BAUM-3010.md; naechste Reserven: e10-/stempel2-Gate-Baeume je 3.7/3.9G NACH Zug-Terminal,
  kleine Worktrees ~1.5G als O-6-Schritt). /tmp/comdare = LEBENDER Runner-Bestand (nie anfassen); fremde
  /tmp-Verzeichnisse 10.08. (~0.5G comdare_q1_*/license-review/tax-review) = nur mit Owner-GO; /var/log
  2.6G = Infra-Meldung.
- Board: #133 E-10 gelandet+Folgephasen, #147 Stempel-2 im Zug, #159 Fold-Rest, #160 verify-47 komplett +
  Re-Run-3-Kette, #153 komplett. 15 claude-Prozesse (Lead + Subagenten + fremde Forks 8bfa178a/e8ef0d90 --
  K20, nie anfassen).

## 3. E-10-LANDUNG -- vollzogen und bewiesen (Kern fuer KON135-Entwurf)

3-Fahrer-Kaskade ueber Risse 3+4, nichts doppelt: Merge 5e03c2cc (0 Konflikte, Ancestor-Beweise rc=0, Tree ==
merge-tree-Probe); K17 4/4 KALT SEQUENTIELL je '100% tests passed, 0 tests failed out of 553' (clang-rel 29.08.
17:33Z; clang-dbg/gcc-dbg/gcc-rel 30.08. 09:34-09:50Z, Zelle clang-dbg nach Riss KOMPLETT NEU KALT; R6-JOB-Gate
je 0/0/0; Baeume nach Doppel-Probe geraeumt, gcc-rel bleibt); Floor LIVE per Treppe 553/549/547 (Total==Liste,
comm-Gegenproben exakt, Restore byte-gleich) + T-1-Gate-5 UEBER/UNTER je Exit 1 literal -> Revert -> 553==553;
TABU 832/832 sha 8f56e4e3 vorher==nachher + 833er-Manifest 03987563 (F-6; deklarierte Datei
axis_disk_io_organ_meta_meta.hpp bf39c235); Lock --check '719 Dateien ... deckt 713 von 713'; CRC-Anker 1x
source_catalog.hpp; Warnungen 0 NEU (gcc 0, clang 1 Vorbestand gtest-printers); Gates 6/6 LITERAL ueber
origin/development..HEAD (9 Commits; clang-format 2447/1993/0; gitleaks Selbstbiss rc=1 + Echt 9==9 comm-3
leer); dev-Dual-Push -> CI 16281 SUCCESS; main-FF: Diff-Hygiene kumulativ ueber bd55942a..5e03c2cc GRUEN,
gitleaks main-Bereich 9==9, R4 0 -> Dual-Push 15:38Z, Refs 4/4 == 5e03c2cc -> CI 16286 (REST: Terminal +
Nachmessung, Poller laeuft). Beweisort ~/backups-workflow/20260829-lande-e10-stempel2/e10-landung/ (STAND.md
fortschreibend, k17/, floor-treppe/, gates/, tabu_*, ci-*.json). Nebenbefund: 16278 (main@bd55942a
coverage-guard) = Vorbestand earlyoom, KEIN Blocker; bd55942a-main davor 2x gruen. Lead-Posten L-1..L-10 aus
dem E-10-UEBERGABE-DOSSIER unveraendert offen. Servertakt: GitLab-API ~3-4 min hinter lokaler UTC.

## 4. Workflow-Tafel (Stand 16:08Z; Rueckkehrer IMMER voll aus journal.jsonl lesen)

### a) E-10/Stempel-2-Zug wf_bf22ab45-485 -- Folgephasen LAUFEN
Script ~/.claude/jobs/5a19728e/tmp/lande-e10-stempel2-2908.js (Patches: R6 Job-Ebene, EIN super-Bump NACH
#114 auf finaler Linie, R4-ZOMBIE nicht-fatal, e10-NICHT-FATAL-Gate-Durchlass; Backups .bak-*). Journal 11 Z.:
e10-Result (Cache-Replay, stopp='NICHT-FATAL ... ~95%'), Opus-ERHEBUNG Result (666KB Transkript), Codex-Lens
Result (Login war 'Not logged in' -> erwartet AUSFALL+Ersatz-Deklaration -- Result LESEN), BEWERTER LAEUFT
(aea8937f, seit 15:47Z). Danach: Stempel-2-Landung bb5b6949 in wt-ce-lande4 (Fahrer wartet selbst per
JOB-Listung auf 16286-Ende; Floor RELATIV +2 LIVE, SA-POSITIV-Pin test_stempel2_vertragspaare, K17 4 Zellen,
Gates, Dual-Push, CI 286, main-FF) -> #114-Re-Run-2 (Manifest 833/833, frischer wt-ce-114rerun2, Plan-Kopf-
Delta 18->18+1 ERWARTET) -> super-Bump (Gitlink+XSD-Patch+PZW-9.5 ATOMAR; bei R4-Zombie: Commit lokal + Wachen,
KEIN Push, stopp 'R4-ZOMBIE' nicht-fatal) -> Verify <=3 + Fix. Bei Riss: Resume byte-unveraendert; completed
cachen, failed frisch.

### b) Fold-Rest wf_fe1cf67c-94e -- Reduce 16/16 KOMPLETT, Refuter-Welle 1 laeuft
Script ~/.claude/jobs/5a19728e/tmp/fold-rest-3008.js (datei-basiert; NIE editieren). Reduce: 7 aus
reduce_results/ (Lauf 3) + b03/05/06/08 (Welle 1) + b09/11/12/15 (Welle 2) + b16 (30.08. 15:49Z) = 16/16;
reduce2/ 16 md + reduce_results/ 16 json. Refuter-Welle 1 (b01-b04 r1) + Zusatz-Sichter AKTIV (16:05-16:08Z);
danach Wellen [5-8], [9-12], [13-16], je <=3 Runden Refute->Fix; dann Assembleur (157-Summe-Gate) ->
Final-Wache <=3 + Fix. Ausfall = STOPP-Return mit Bilanz -> Resume faehrt nur Tote nach. Eingaenge:
finale2/{reduce_eingang,reduce_results,zusatz_eingang.json,batch_tafel.json}; Not-Abgaben .riss2/.riss3 TABU.
Nach Terminal: NEUER-LEDGER + GEGENLESE-GATE voll lesen, Rest-Fragen-Vorlage mit A2.3a-NEIN-Probe je Frage
gegen owner-kerne, KON134-09/10.

### c) verify-47 wf_401a0ff3-a98 -- TERMINAL + VOLL VERBUCHT (Board #160)
2 Runden: R1 TRAEGT_MIT_FIXES (6 Funde) -> Fixes; R2 TRAEGT_MIT_FIXES (F-7 df-Zeitetiketten BEHOBEN, F-8
Planer-s19_kampagne-Zeile VERTAGT mit Kenntnisnahme). amd-Ernte TRAEGT (0.521 s/DLL 'Fenster-0:64 @16W ccache'
n=128, Obergrenze 302.9 h; 457198 B n=500; 239.7 GB; Ebene-B +1616; gn_out 4/4). intel kontaminiert (earlyoom
frisch 09:52Z reproduziert). WICHTIG F-3: R-8 Drift-Gate-Rerun-Rate des MESSWEGS = ##49-GO-VORBEDINGUNG (braucht
Messlauf/Re-Run-3). F-6 (PMC_VENDOR=amd beide Grandchilds) + F-8 = Lead-Posten naechste ce-Welle.

## 5. Kontext-Chronik 30.08. (fuer KON135-Entwurf)

09:2xZ Ritual VOLL (Nachtrag 1 der 1715Z-Uebergabe) -> K27-Diagnose (Praefix-Cache; Owner-Befund bestaetigt;
Memory reference_workflow_cache_ist_praefix_basiert; ~2,3M Doppellauf) -> Heilung: Eingangs-Extraktion aus dem
wf_c37fb077-Journal (juengste Results je Rolle), reduce-14-Schnitt, .riss3-Umbenennung, fold-rest-3008.js
(Wellen a <=4 nach Owner-Order), 3 stale Bauslot-Claims -> geraeumt-3009/ -> Starts 09:32Z. Riss 4 (Session-
Limit ~10:25/10:40Z, resets 14:10Z): Fold 8/9 Wellen-Reduce fertig (nur b16 tot -- Wellen-Struktur hielt),
E-10-Fahrer 2 starb NACH dev-CI-16281-SUCCESS-Log. 10:1xZ Platten-Pruefung (Owner-Order): 14G -> 16G
(lande3-Gate-Baum geraeumt nach Q3-Audit 0/0/0/0). 15:3xZ Resumes (Owner): Fold b16 frisch + 8 Cache-Replays;
E-10-Fahrer 3 verifizierte alles, fuhr main-Dual-Push 15:38Z, gab NICHT-FATAL-stopp (16286 lief) -> Gate-
Logik-Patch (KEIN Prompt) -> Resume 15:41Z: e10 aus Cache, Review-Stufe gestartet; 16286-Poller bdl7dzzi9.

## 6. Reihenfolge nach den Terminals (nichts kuerzen)

(1) 16286-Terminal (Poller) -> Nachmessung ce 4/4 == 5e03c2cc final + STAND.md-Abschluss; bei Rot STOPP-Befund.
(2) E-10-Zug-Rueckkehrer VOLL lesen (Bewertung/Landung/114/Bump/Verify) + verbuchen; Stempel-2-Lande-SHA wird
    die FINALE ce-Linie; wt-ce-e10-/stempel2-Gate-Baeume danach raeumbar (Q3-Audit-Form).
(3) Fold-Terminal -> NEUER-LEDGER + Final-Wache voll lesen -> Rest-Fragen-Owner-Vorlage (A2.3a je Frage) ->
    KON134-09/10-Entwurf ergaenzen.
(4) Owner E-1 -> super-Push-Fenster: 6 docs-Commits + KON134/135-Einspielung via scripts/ledger_nachtrag.sh +
    super-Bump (falls der Zug ihn lokal vorbereitet hat: nur noch pushen + CI 288 + main-FF) + #157-docs-Zug.
(5) #160-Kette: Explore -> Fix -> E-2/C-02 -> ##47-Re-Run-3 BEIDE Lanes (erhebt auch R-8/F-3) -> Alt-Token-39-
    Widerruf. (6) X3-Scheduling-Bau S0-S12 (F-X3-1=A, 4-5 Bau-Tage). (7) ##48/C-01/HEAVY -> ##49 (T-Entscheid:
    Trigger -> Funktionsnachweis -> Split -> Rest-Wellen); realistisch fruehestens Mo 31.08./Di 01.09. NACH
    E-2-Heilung + Re-Run-3 -- Meldung, keine Kuerzung. (8) Offene Dauer-Posten: #152 Token-Rotation (ruhiges
    Fenster), #154, #155, #157, #121/#130, #142/#143-Reste, #7/#18/#57-Buendel, W-Register.

## 7. Sicherheit (verbatim gueltig)

glhdr.curlrc = Secret, nie ausgeben; Keys/Token/PAT/Vault nie im Klartext (nur Laenge/Hash/Ort); Vault nie
greppen (blind); backup/-Branches nie pushen; Remote-Loeschungen/Cancels nur mit Owner-GO; GitHub-Purge-Scope
NUR 0891fcf43cbf + Blob 71670a3d; codex ac_-Code nie persistieren; Messdaten nie loeschen; Transkripte nie
committen (wf_78955b71/agent-a11b87990b7092c3e.jsonl traegt prod2-Runner-Tokens -> #152); gitlab-runner list
NIE; config.toml nie ausgeben; Cluster _infra/ci-templates tabu; nie rebase, kein add -A, kein Force-Push;
Koeder-Literale maskieren; K20 fremde Sessions nie killen.

## 8. Beweisorte / Scripts

~/backups-workflow/20260829-lande-e10-stempel2/ (e10-landung/ komplett; stempel2-review/ waechst) *
20260827-lande-reif/{47-kalibrier,verify-47,mainff-rest,lande-pruefung}/ * 20260824-rueckfragen-synthese2/
finale2/ (Eingaenge + reduce2 + refute2 + Not-Abgaben .riss2/.riss3) * 20260829-PAUSE-9/PAUSE-PROTOKOLL-9.md
(geschlossen, 2 Nachtraege) * Scripts ~/.claude/jobs/5a19728e/tmp/{fold-rest-3008.js, lande-e10-stempel2-
2908.js, verify-47-ernte-2908.js} + je .bak-* * Journale <session>/subagents/workflows/wf_{bf22ab45-485,
fe1cf67c-94e,401a0ff3-a98,c37fb077-ef7,d27fc8f0-b43}/journal.jsonl (append-only = Wahrheit).

Selbstcheck: ASCII 0 nicht-ASCII, Zeilen <= 120, alle Zahlen aus Messungen 16:08Z oder mit Zeitstempel.

## NACHTRAG 16:23Z (vor Kontext-Ende): CI 16286 TERMINAL SUCCESS

CI 286/16286 (ce main @ 5e03c2cc) = SUCCESS 16:21:51Z (27 Jobs = 26 success + 1 manual is_original:relock,
0 Bridges; Poller bdl7dzzi9 exit 0; Kopie ci-16286-final.json). Nachmessung FINAL 4/4: origin+github x
development+main == 5e03c2cc. E-10-PHASE 1 DAMIT RESTLOS KOMPLETT (Kette V3 voll belegt); STAND.md
abgeschlossen. Der laufende Stempel-2-Lande-Fahrer findet die 286-Jobliste jetzt frei (sein Vorflug-Gate).
Uebrig aus Abschn. 0.1c: nichts -- Punkt (c) ist erledigt; es LEBEN nur noch die zwei Workflows (a) + (b).

## NACHTRAG 2 (~21:15Z, vor Compact): STEMPEL-2-LANDUNG + CI-ROT-HEILUNG + RISS 5 -- LEBENDER STAND

### N2.0 Was JETZT gilt (ersetzt Abschn. 0 fuer den naechsten Kontext)

1. ce origin==github: development==ffb512a6 (Stempel-2-Merge, Pipeline 16287 ROT s.u.), main==5e03c2cc (GRUEN,
   unberuehrt). Lokal in /home/comdare/wt-ce-lande4: HEAD dd0f56d3 = ffb512a6 + cppcheck-Fix-Commit, UNGEPUSHT.
2. FIX-ZUG wf_e1751971-949 (Script ~/.claude/jobs/5a19728e/tmp/fix-stempel2-3008.js, vom Lead VOLL gelesen
   120 Z./32880 B, TRAEGT; Gate-Patch: Fortsetzer-Gate TURN-ENDE-durchlaessig): Run TERMINAL nach 2 Agenten
   (Fahrer + Fortsetzer, je Turn-Ende bei laufendem K17 -- 3x belegtes Muster 'Agent stirbt am Warten').
   K17 @ dd0f56d3 lief DETACHED (nohup, alle4fix.sh): Stand 21:10Z 3/4 Zellen GRUEN je LITERAL
   '100% tests passed, 0 tests failed out of 555', Zelle 4 gcc-rel lief; Terminal-Marker ALLE4_RC= in
   fix-landung/k17/alle4fix.out; Lead-Watcher bt5t0eksh wartet darauf.
3. REST = LEAD-VOLLZUG nach Rezept (a)-(g) in BO/fix-landung/STAND.md (BO ab hier =
   ~/backups-workflow/20260829-lande-e10-stempel2; alle Skripte liegen bereit): (b) review_fix.sh Warnungen 2x 0 NEU ->
   (c) floor/treppe_fix.sh build-k17-gcc-rel fix (555/551/549 unveraendert) -> (d) tabu_nachher_fix.sh +
   Lock Einzeltarget-Bau (cmake --build build-k17-gcc-rel --target comdare_axis_version_lock; --check
   719/713) + SA-Pin #554/#555 aus k17-Logs -> (e) gates/gates.sh fix-dd0f56d3 (6/6) + gitleaks_fix.sh
   (NENNER 1==1) -> (f) r4_check_fix.sh -> Dual-Push dd0f56d3...:refs/heads/development origin+github,
   ls-remote 2/2, EINE Pipeline -> ci_poller_fix.sh -> N-O27-Jobliste namentlich (lint:static,
   test:coverage-guard, test:unit(+debug), build:clang, test:unit:clang(+debug)) + FUND-QUITTUNG additiv ->
   (g) main-FF: Diff-Hygiene kumulativ origin/main..HEAD (6 Commits: 360fe107 7c945f11 70bc2228 bb5b6949
   ffb512a6 dd0f56d3, LIVE bestaetigt) + gitleaks 6==6 + R4 + Push VOLLE SHA + CI main terminal +
   Nachmessung 4/4. DANACH: Workflow({scriptPath: fix-stempel2-3008.js, resumeFromRunId: 'wf_e1751971-949'})
   -> Fahrer+Fortsetzer replayen aus Cache, Zug laeuft in #114-Re-Run-2 -> super-Bump (R4-ZOMBIE E-1
   nicht-fatal, Commit lokal) -> Verify <=3 + Fix.
4. FOLD wf_fe1cf67c-94e LEBT (Task wh5l1lje3): Fix-r2 b01/b03/b04 + Refuter-Wellen 2-4 -> Assembleur ->
   Final-Wache. NIE doppelt resumen; bei Riss byte-unveraendert (K27).
5. super development LOKAL jetzt 9 docs-Commits vor origin 8be694ef (+ d21ccbd0 16286-Nachtrag + dieser);
   Push weiter E-1-gated. Owner offen: E-1 (Zombie 16275/16280), E-2 (prod2-Speicher + C-02), E-3
   (codex login -- Lens fiel 15:43:32Z erneut mit frischer Probe aus).

### N2.1 Chronik 16:2x-21:15Z (Kern, chronologisch)

- 16:2x-16:31Z Kipp-Ritual VOLL (DICHT-Form: ARBEITSWEISE 704/704, GOAL 506/506, Wellenplan W-0+W-H+W-6,
  Designplan D0+D11, Ledger-Kopf KON133, diese Uebergabe 171/171, Memories 3 Tage 21/21 = 1512 Z.).
- RISS 5 (Session-Limit, Reset 20:30Z) traf genau 4 Agenten: Fold fix:b01/b03/b04:r2 + Stempel-2-Lande-
  Fahrer (beim Start). Wellen-/Kaskaden-Struktur hielt; STOPP-Returns planmaessig.
- Rueckkehrer VOLL verbucht (X-19): Stempel-2-REVIEW komplett -- Codex-Lens AUSFALL ('Not logged in'
  rc=1 15:43:32Z, Binary ok 0.146.0, CODEX-AUSFALL-PROBE-20260830.md; Ersatz-Lens A2.6 = Opus+Fable),
  Opus-ERHEBUNG 39 Befunde O-01..O-39 (11/11 Dateien, Diff 2190+3, TABU 0/832, Weiche-A 9/9 0-Diff),
  Fable-BEWERTUNG urteil=TRAEGT 0 MUSS / 14 SOLL / 25 ENTLASTET (O-32/O-33 = Lande-Handgriffe; 11
  SOLL-Posten in stempel2-landung/FUND-QUITTUNG.md). FOLD: Reduce 16/16 + Refuter-WELLE 1 komplett
  (B2 FERTIG NULL_NEUE_FUNDE, 3 R1-Funde BEHOBEN-nachgemessen; B1 4 Funde / B3 2 / B4 4, alle MILD/
  KLEIN, KEIN Urteils-Kipp); Zusatz-Sichter 234 -> 168 entlastet / 58 NACHTRAEGE / 8 verworfen
  (zusatz2/ZUSATZ-NACHTRAEGE.md).
- 20:33Z beide Resumes byte-unveraendert (X-15 2x-Probe, Pseudo-Grep 0/26, Fortschreib-Duplikat-Check:
  Ziel-Dateien der Toten unberuehrt).
- STEMPEL-2-LANDUNG (Fahrer-Kaskade ueber Riss 5, nichts doppelt): Merge ffb512a6 (--no-ff bb5b6949 auf
  5e03c2cc; O-32 CMakeLists BEIDE Bloecke sequentiell +54/-0, O-33 Floor RELATIV +2 = 555/551/549 LIVE
  per Treppe + T-1 UEBER/UNTER), K17 4/4 KALT je '555/555' (SA-Pin #554/#555), TABU 832+833 sha
  vorher==nachher, Lock 719/713, Gates 6/6, gitleaks 5==5, Dual-Push dev -> CI 286/16287 FAILED
  17:35:00Z: Job 386485 lint:static (cppcheck 2.21.0, allow_failure=false) = 6x [uninitMemberVarNoCtor]
  (apps/modul_emitter/main.cpp:121 ManifestZeile::gestempelt + tests/unit/test_stempel2_vertragspaare.cpp
  :40/41/43/44/45 Fixture-Member; deterministisch, Klasse CODE; cppcheck = weder Pre-Push-Gate noch
  Compiler-Warnflaeche, Codex-Lens war aus -> exakt die ungedeckte Luecke, die CI fing als Zweitlens);
  22 success + 3 clang-Folge-skips; STOPP doktringemaess, KEIN main-FF, kein eigenmaechtiger Fix.
- FIX-ZUG (Lead-GO, Defekt-Doktrin): T-1 ROT literal (lint:static-Formel aus ci-templates
  base-pipeline.yml; lokales cppcheck 2.21.0 == CI, KEIN Versions-Delta; rc=2 mit GENAU den 6
  CI-Literalen, 0 weitere) -> Fix-Commit dd0f56d3 (6 NSDMI nach Bestandsidiom: '= false'/'= nullptr'/
  '= 0'; +7/-7; Aggregat-Braced-Init-Verwendungen mit vollen Feldlisten bleiben gueltig) -> T-1 GRUEN
  rc=0 + clang-format-22 --dry-run -Werror rc=0 -> TABU-VORHER identisch -> K17 detached.
- Beweisorte (je unter BO/): fix-landung/ (STAND.md + t1-rot/-gruen + fix-diff.patch + k17/ + Skripte) +
  stempel2-landung/ (voll) + stempel2-review/ (Erhebung/Bewertung/Codex-Probe).

### N2.2 Lehren dieses Fensters (fuer den naechsten Kontext)

- 'Agent stirbt am Warten' ist STRUKTURELL (3x heute: E-10-Fahrer-3 an 16286, Fix-Fahrer + Fortsetzer an
  K17): lange Waits (CI ~45 min, K17 ~22 min) gehoeren in DETACHED-Prozesse + Lead-Watcher; Workflow-
  Agenten fahren die kurzen, dichten Phasen. NICHT-FATAL-stopp + Lead-Uebernahme = bewaehrtes Muster.
- K27-Praxis bestaetigt: Resume byte-unveraendert cachte 22+4 Results exakt; Logik-Patches (Gates,
  neue Calls NACH dem Praefix) brechen nichts; die 2 Assemblier-Fehler des neuen Scripts (ende()-
  Falscheinschub via index() statt rindex; konst-Block trug REGELN schon) wurden VOR dem Start gefangen
  -- Owner-Order 'Script voll lesen' als Pflichtschritt nach jedem Script-Bau uebernehmen.
- cppcheck-Luecke als Posten: lint:static ist in keinem lokalen Gate -- Kandidat Gate 7 oder
  Pre-Push-Zusatzlauf (Lead-Posten, mit O-12/O-29-Familie buendeln).

Selbstcheck N2: ASCII 0 nicht-ASCII, Zeilen <= 120, Zahlen aus Messungen 21:10Z oder mit Zeitstempel.
