# BETRIEBS-LENS: Liegengebliebenes (READ-ONLY-Pruefung, 05.08.2026 ~abends)

Pruefzeitpunkt: nach super=603f15f4 / ce dev=60c7c56a (IST-ANKER). ACHTUNG Momentaufnahme:
waehrend der Pruefung lief LIVE die Merge+Push-Landung der w2-codex-fixes-Welle (PID 4145406,
Teil wf_1a78cffa) — ce dev bewegt sich unmittelbar weiter. Alle Aussagen beziehen sich auf den
Snapshot 60c7c56a. KEINE Schreiboperation ausser `git fetch --prune` wurde ausgefuehrt.

---

## 1. 4-KLONE-SYNC-DOKTRIN

Doktrin (feedback_diplomarbeit_4_projects_local_clones_keep_in_sync.md): Die 4 Projekte =
**cache-engine, prt-art, super (probst-diplomarbeit-cache-engine), thesis (20260931-overleaf-diplomarbeit)**.
`Code/external` = QUELLE; Research-Klon spiegelt per fetch+FF NUR wenn sauber; dirty/divergent => STOPP+melden.

Gefundene Klone (Remote-verifiziert gitlab.comdare.local/comdare/research/...):

| Repo | Pfad | HEAD | dev vs origin/dev | main(lokal) vs origin/main | status |
|---|---|---|---|---|---|
| super | /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine | 603f15f4 (development) | 0/0 SYNCHRON | 0/**231 behind** | nur `?? Code/measure_out_d03/` |
| ce (Submodul) | .../Code/external/comdare-cache-engine | 60c7c56a (development) | 0/0 SYNCHRON | 0/**259 behind** | clean |
| prt-art (Submodul) | .../Code/external/comdare-prt-art | c6f07540 (detached = origin-Tip) | lokaler Branch 0/33 behind, HEAD aktuell | 0/33 behind | clean |
| prt-art (Research-Klon) | /home/comdare/Projekte/Research/comdare-prt-art | c6f07540 (development) | 0/0 SYNCHRON | 0/33 behind | clean |
| thesis (Submodul) | .../Code/external/20260931-overleaf-diplomarbeit | ef448e4b (detached) | kein lokaler dev-Branch | **0/78 behind** | clean |
| thesis (Research-Klon) | /home/comdare/Projekte/Research/20260931-overleaf-diplomarbeit | ef448e4b (main) | kein lokaler dev-Branch | **0/78 behind** | clean |

Es existiert KEIN weiterer Standalone-ce-Klon (grep ueber .git/config aller Research-Repos: nur super
traegt die ce-Submodul-URL). `_ce-scratch-split-20260707` ist ein separates GitHub-Scratch-Repo.

### FUND B-1 (KERN): thesis-Klone 78 Commits hinter origin — lokal seit 21.07. nicht gefetcht
- Beide thesis-Klone stehen auf ef448e4 (21.07. 21:05, chktex-Fixe); origin/main+origin/development
  stehen auf 29a1700 (03.08. 15:52, "Kapitel 6 Fazit FF2-Erweiterbarkeit ... DE+EN").
- Mein `git fetch` holte den Range ef448e4..29a1700 ERST JETZT herein => seit ~2 Wochen kein lokaler
  fetch; 78 Commits Thesis-Textarbeit (Overleaf-Strang) sind lokal nirgends gespiegelt.
- Beide Klone sind CLEAN => per Doktrin FF-faehig (READ-ONLY-Lens: NICHT ausgefuehrt — Nacharbeit:
  FF beider Klone auf 29a1700).

### FUND B-2: super pinnt thesis-Gitlink auf 21.07.-Stand (Submodul-Bump offen)
- `git -C super ls-tree HEAD Code/external/`: thesis=ef448e4b (21.07.), waehrend thesis-origin 03.08.
  ist. ce-Gitlink=60c7c56a und prt-art-Gitlink=c6f07540 sind dagegen AKTUELL (== jeweilige origin-Tips).
- D.h. ce-Submodul-Bumps in super: NICHT liegengeblieben (aktuell). thesis-Bump: seit 03.08. offen.
  Moeglicherweise bewusst (Text-Sessions->Thesis-Strang laeuft separat), aber im IST-ANKER nirgends
  als gewollt deklariert => als Nacharbeit pruefen/bumpen.

### FUND B-3 (gering): lokale main-Zeiger in super/ce/prt-art stale
- Remote gilt ueberall main==dev (Gitflow-Ist); nur die LOKALEN main-Branch-Refs hinken: super 231,
  ce 259, prt-art 33 Commits behind. Reine Zeiger-Hygiene, kein Datenverlust; bei Gelegenheit FF.

### OK-Befunde Teil 1
- super dev == origin/dev == 603f15f4 (IST-ANKER bestaetigt). ce dev == origin/dev == 60c7c56a.
- Beide prt-art-Klone synchron zum origin-Tip c6f07540 (03.08., Ledger E-02-Nachzug); prt-art hat
  KEIN ce-Submodul (keine .gitmodules, keine Gitlinks) => dort ist kein Bump faellig.

---

## 2. WORKTREE-HYGIENE (ce)

`git worktree list`: 12 Eintraege (Haupt-Checkout + 11). Je Worktree: HEAD-in-origin/dev
(merge-base --is-ancestor), echte offene Patches (git cherry origin/development HEAD, '+'-Zeilen),
dirty-Status:

| Worktree | HEAD | in dev? | echte Patches | dirty | Verdikt |
|---|---|---|---|---|---|
| /home/comdare/wt-a8s1 | 9c08940b | JA | 0 | 0 | **gelandet, entfernbar** |
| /home/comdare/wt-m3 | 40e8bf27 | JA | 0 | 0 | **gelandet, entfernbar** |
| /home/comdare/wt-w10 | 6fe16117 | JA | 0 | 0 | **gelandet, entfernbar** |
| /home/comdare/wt-w2-A13-M1b | e35e0f36 | nein | **0** (6/6 patch-aequivalent '-') | 0 | Inhalt gelandet, entfernbar |
| /home/comdare/wt-w2-FK-1 | 6019585c | nein | **0** (6/6 '-') | 0 | Inhalt gelandet, entfernbar |
| /home/comdare/wt-w2-FK-2 | a21575c5 | nein | **0** (4/4 '-') | 0 | Inhalt gelandet, entfernbar |
| /home/comdare/wt-w2c-TP1FK1-Fixes | c4d5b354 | nein | **0** (5/5 '-') | 0 | Inhalt gelandet, entfernbar |
| /home/comdare/wt-w2c-Wachen-Fixes | 43d98d5b | nein | **0** (5/5 '-') | 0 | Inhalt gelandet, entfernbar |
| /home/comdare/wt-w2fix | e3fc1b98 | nein | **3** | 0 | LAUFEND (wf_1a78cffa, Landung live) — NICHT anfassen |
| /home/comdare/wt-e24 | ac033634 | nein | **3** | 0 | LAUFEND (wf_1a78cffa w5-w3-kern) — NICHT anfassen |
| scratchpad/ce-audit-7150cc51 | 7150cc51 | JA | 0 | 0 | dient laufendem Sonnet-5-Audit wf_e0b496e0 => behalten bis Audit-Ende |

### FUND B-4 (KERN): L20-Liste der "7 NEIN-Faelle" ist STALE
- 5 der 7 genannten Faelle (wt-w2-A13-M1b, wt-w2c-TP1FK1-Fixes, wt-w2c-Wachen-Fixes, wt-w2-FK-1,
  wt-w2-FK-2) tragen laut `git cherry` NULL echte offene Patches — jeder ihrer Commits ist
  patch-aequivalent in origin/development enthalten (unter anderen SHAs gelandet, vermutlich via
  Wellen-Merges). Die riesigen diff-stats (~500 Dateien) vs dev sind reine Basis-Drift (dev ist weit
  voraus), KEIN offener Inhalt.
- Der 7. Fall **wt-w2-E02-\*** existiert NICHT mehr — weder als Worktree noch als Branch
  (`git branch -a | grep -i e02` leer). Bereits abgeraeumt.
- Echte ungelandete Arbeit liegt AUSSCHLIESSLICH in den zwei laufenden Wellen-Worktrees
  (wt-w2fix: F-B1/F-B2/F-B3; wt-e24: W3-Testate + W5-status, je 3 Patches) — beides per IST-ANKER
  LAUFEND, also nicht liegengeblieben.
- Nacharbeit (nach Landung + Wellen-Ende): 8 Worktrees + zugehoerige Branches entfernen
  (wt-a8s1, wt-m3, wt-w10 + die 5 patch-aequivalenten), `git worktree prune`; L20-Liste fortschreiben.
- Lokale Alt-Branches (a8-s1/a8-s3/a8-s4/e24-*/s5-01a..05q/w1-planer-split/w10-zellwerte u.a.):
  Tips alle in dev => Aufraeum-Kandidaten fuer den Abschluss-Aufraeumpass. `backup/pre-rescrub-2026-07-25`
  traegt 0 echte Patches, ist aber Backup (additiv-Doktrin: NICHT loeschen).

---

## 3. RESCUE-REFS

`git ls-remote origin 'refs/rescue/*'` => **44 Refs**; alle Objekte lokal vorhanden; 40/44 in
origin/development enthalten. Die 4 nicht enthaltenen:

| Ref | SHA | Befund |
|---|---|---|
| refs/rescue/w2c-tp1fk1-fixes | c4d5b354 | patch-aequivalent gelandet (cherry: 0 '+') — harmlos |
| refs/rescue/w2c-wachen-fixes | 43d98d5b | patch-aequivalent gelandet (cherry: 0 '+') — harmlos |
| refs/rescue/w2b-E04-P1 | daf5190e | **2 ECHTE offene Patches** — s. FUND B-5 |
| refs/rescue/e24-c3-wip-pause | 0bac9fbe | **1 ECHTER offener WIP-Patch** — s. FUND B-6 |

### FUND B-5 (KERN, Liegengeblieben-Kandidat Nr. 1): rescue/w2b-E04-P1 traegt 2 ungelandete Patches
- daf5190e (02.08. 16:59): davon NICHT patch-aequivalent in dev:
  - `92ad8357 feat(E04-P1): Emissions-Seite des Slice-Kanals -- offen=, KOPF-Bezugsgroessen, COMDARE_LANE, [CEB-TESTAT], Tee-Filter`
  - `63406ce3 test(E04-P1): Director-Test-Migration -- Tee-Filter abgeleitet + zwei neue Emissions-Anker`
- Auch NICHT in den laufenden Wellen enthalten (cherry vs e3fc1b98: 2 offen; vs ac033634: 2 offen).
- Im IST-ANKER taucht E04-P1 nirgends als laufend/geplant/bewusst-verschoben auf => pruefen, ob
  Inhalt superseded (durch W1/W2-Planer-Split?) oder nachzuziehen ist. Bis zur Klaerung: Ref stehen
  lassen (Backups additiv).

### FUND B-6 (Pruef-Kandidat): rescue/e24-c3-wip-pause traegt 1 ungelandeten WIP
- 0bac9fbe (04.08. 05:47): `WIP(e24-c3-e/5): Cross-Genus-Einbau UNVOLLENDET -- PAUSE-Abbruch 04.08.,
  NICHT reviewt, NICHT gebaut` — nicht in dev, nicht Vorfahr der laufenden w5-w3-kern (ac033634),
  und dort auch nicht patch-aequivalent (cherry: 1 offen).
- Plausibel gedeckt durch "W3-Vollausbau BEWUSST NACH ABGABE" (IST-ANKER), aber der rescue-Ref ist
  in keiner Nach-Abgabe-Liste explizit referenziert => beim Posten-Register/W3-Vollausbau-Eintrag
  als Quelle vermerken, sonst geht der WIP-Stand verloren.

---

## 4. UNTRACKED/TEMP

- super `git status --porcelain`: EINZIG `?? Code/measure_out_d03/` = Owner-Default, OK. Sonst NICHTS.
- ce, beide prt-art-Klone, beide thesis-Klone: vollstaendig clean (0 dirty-Zeilen).
- Scratchpad-Worktree `/tmp/.../scratchpad/ce-audit-7150cc51` (detached 7150cc51, in dev, clean):
  gehoert zum LAUFENDEN Sonnet-5-Audit wf_e0b496e0 => noch noetig. Nach Audit-Ende: Verzeichnis faellt
  mit dem Session-Scratchpad weg, dann im ce-Repo `git worktree prune` noetig (sonst Leichen-Eintrag).

---

## 5. MEMORY-STAND

### FUND B-7: MEMORY-Index + Lage-Anker-Memory sind STALE gegenueber 60c7c56a/603f15f4
- MEMORY.md-Headline (LAGE-ANKER "~13:00: ce=18fbb950 Gate 404 ... super=432a130c ... W1-Welle laeuft")
  = ZWEI Stufen hinter dem Ist (es folgten Gate 405 ce=60c7c56a und super bis 603f15f4).
- project_20260805_pause_01c_komplett_vor_phase_b.md, Kopfstand "~14:30 UTC": ce=60c7c56a KORREKT,
  aber (a) super=**69dd9fb7** — real ist super dev==main==**603f15f4** (Ledger abend-1, 16:57 UTC,
  Systemabsturz-Wiederaufnahme + Sonnet-5-Audit-Auftrag); (b) laufende Welle dort als
  **wf_7953bc4d** benannt — real laufen **wf_1a78cffa** (Dual-Review w2fix+w5w3) und
  **wf_e0b496e0** (Sonnet-5-Audit); (c) Systemabsturz + Owner-Auftrag Sonnet-5-Audit fehlen komplett.
- Zudem veraltet die ce-Zeile in Minuten weiter (Live-Landung w2fix lief waehrend der Pruefung).
- Nacharbeit: Memory-Nachtrag NACH Landung der Dual-Review-Welle (dann mit neuen SHAs in einem Zug).

---

## 6. ARTEFAKT-KONSISTENZ (docs/architektur/05b)

### FUND B-8: Kopf-Link des Begleitdocs zeigt auf die GELOESCHTE Artefakt-URL
- Datei: /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/architektur/05b_uml_klassenatlas_20260805.md
- Zeile 5 ("Gerenderte Fassung ...") verlinkt **https://claude.ai/code/artifact/61235adf-e3f9-4000-9e55-4bf4d85ee630**
  — genau die URL, die der REV-4-Vermerk (Zeile 49) selbst fuer GELOESCHT erklaert
  ("existiert nicht mehr ... REV 4 ist unter NEUER URL publiziert: .../61359d31-8f7d-41b3-b5d6-8ff8a3fbe459").
- Zaehlung im md: alte URL 61235adf = 2x (Kopf + REV-4-Erwaehnung), neue URL 61359d31 = 1x (nur REV-4).
  Der REV-5-Vermerk nennt keine URL (kein erneuter Wechsel) => aktuell gueltig ist 61359d31, der
  Kopf-Link ist ein toter Link. Im HTML selbst kommt keine der URLs vor (kanonische Kopie, ok).
- Nacharbeit (1-Zeilen-Fix, super-Commit): Kopf-Link auf 61359d31-8f7d-41b3-b5d6-8ff8a3fbe459 drehen.
- Hinweis MEMORY: "Atlas REV 5 komplett ... neue Artefakt-URL (alte geloescht)" stimmt inhaltlich;
  nur das Begleitdoc hinkt.

---

## 7. SHELLS/MONITORE/CRONS

- `pgrep -af 'ctest|ninja|cmake'` (ohne Selbstmatch): KEINE Bau-/Testprozesse. Der einzige Treffer
  war PID 4145406 — die LIVE laufende Merge+Push-Shell der w2-codex-fixes-Landung (Merge nach
  development + Tree-Identitaets-Check + cf22 + gitleaks + push origin/github). Teil der laufenden
  Welle wf_1a78cffa => KEIN Fund, aber: dev-Snapshot 60c7c56a war zum Prüfzeitpunkt im Begriff,
  sich auf den Merge-Commit weiterzubewegen.
- Codex-Zubehoer: 3x `codex mcp-server` (gpt-5.6-sol/ultra) + 1x codex-code-mode-host — gehoeren zu
  den laufenden Wellen (Dual-Review mit Codex). Kein Leichen-Verdacht; nach Wellen-Ende pruefen, ob
  sie sich beenden.
- `crontab -l`: EIN Eintrag — `*/15 * * * * .../DIPLOMARBEIT-PLAIN-BACKUP/refresh-backup.sh` =
  bekannter Owner-gedeckter 15-min-Desktop-Backup (reference_desktop_plain_backup_diplomarbeit). OK.
- 6 QEMU-VMs (opn-1, talos-prod1, win11, samba-ad-p1, win2022, cd-timebroker-p1) = Cluster-Infra,
  Normalbetrieb, kein Fund.

---

## NACHARBEITS-LISTE (priorisiert, alles NACH Wellen-Landung, nichts davon blockiert den Trigger Do 07.08.)

1. **B-5**: rescue/w2b-E04-P1 klaeren (superseded vs nachziehen) — einziger echter Inhalts-Kandidat.
2. **B-1**: thesis-Klone (beide) FF auf 29a1700; **B-2**: thesis-Gitlink-Bump in super pruefen.
3. **B-8**: 05b-Kopf-Link auf neue Artefakt-URL drehen (1 Zeile).
4. **B-7**: Memory-Nachtrag (SHAs + Wellen-IDs) nach Landung.
5. **B-4**: 8 Worktrees + Alt-Branches abraeumen, L20-Liste fortschreiben; **B-6**: WIP-Ref im
   W3-Nach-Abgabe-Posten referenzieren; **B-3**: lokale main-Zeiger FF; danach `git worktree prune`
   (Audit-Scratchpad-Worktree erst nach wf_e0b496e0-Ende).
