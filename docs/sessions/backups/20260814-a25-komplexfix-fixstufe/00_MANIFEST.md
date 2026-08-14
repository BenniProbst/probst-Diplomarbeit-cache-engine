# A2.5-FIX-STUFE KOMPLEX-FIX (14.08.2026) -- ROHDATEN-MANIFEST

Phase: A2.5-Fix des Komplex-Fix-Pakets (Verify-Urteil TRAEGT_MIT_FIXES, 4 Funde F1-F4
+ 3 Deckungs-Kennzeichnungen). Einziger Schreiber beider Worktrees; kein Push.
Worktrees: super /home/comdare/wt-super-landung (Basis 8b41ef37), ce darin
Code/external/comdare-cache-engine (2a3b1eb0, in dieser Stufe UNBERUEHRT, porcelain 0).

## COMMITS DIESER STUFE (alle super, development)
- 853cea9a  fix(KF-A2.5/F1): F6-Maskierungs-Beweis neu geschnitten -- Literale statt
            rc==0 des Gegenstuecks (ci/tests/frische_wache_probe.sh, +23/-7)
- 1bb39761  fix(KF-A2.5/F3): BU-SOFORT nachgeholt -- regressions-gesamtbild additiv
            (166 Dateien, dritter S3.4-Gegenstand)
- 5d008448  docs(ledger): KON61-NACHTRAG A -- F1/F3 gebucht, F2 michael_lockfree-
            Lizenz-Detail (#74-Resthaelfte), F4 Zahlen-Vermerk (476 statt 477)
- (danach)  BU-Commit dieses Verzeichnisses (SHA im Commit selbst)

## DATEIEN
- f1_t1_rot_vorher.log                 T-1 ROT ZUERST: frischer Probe-Lauf am IST vor dem
                                       Fix; rc=1, 'PROBE ROT: 1 von 14 Faellen gerissen.',
                                       '[ROT ]  F6', RISS-Zeile der alten rc==0-Forderung.
- f1_gegenprobe_gruen_selbstbiss.log   Nach dem Fix: rc=0, 'PROBE GRUEN: 14 von 14
                                       Faellen gehalten.', '--selbstbiss' 4/4 Mutanten
                                       gefangen (M2-Maskierungs-Mutant weiter via F6).
- f1_k13_biss_beidseitig.log           K13-Beleg der drei neuen Literal-Checks: echte
                                       Ausgabe haelt (grep rc 0/1/0), drei Koeder-Ausgaben
                                       reissen jeden Check (grep rc 1/0/1).
- koeder_scan.log                      F3-Kette: gitleaks ueber /tmp-Kopie MIT
                                       glpat-Koeder -> rc=1, 'leaks found: 1'.
- bu_scan.log                          F3-Kette: ohne Koeder -> rc=0, 'no leaks found',
                                       'scanned ~10440823 bytes (10.44 MB)'.
- kon61_nachtrag_a_entwurf.md          Der via scripts/ledger_nachtrag.sh eingefuegte
                                       Block (58 Zeilen; Ledger 27661 -> 27719).
- diff_hygiene_lauf1_nach_ledger.log   scripts/ci_diff_ascii_width_guard.sh --bereich
                                       origin/development HEAD nach dem Ledger-Commit:
                                       rc=0, 'DIFF-HYGIENE-WACHE: GRUEN.'
- (Lauf 2 der Diff-Hygiene nach dem BU-Commit: Ergebnis im Stufen-Return; ein Log kann
  seinen eigenen Commit nicht enthalten.)

## DECKUNGS-GRENZEN (Verify-Kennzeichnungen, hier unveraendert)
Task-Text-Haelften nur via Lead/TaskGet; #38/#81-Pipeline-Messung = Stufe-3-Nachlauf;
Meta-Gate-VOLLAUF + C1/C2 = Stufe-3-Auflage am sauberen Baum nach Gitlink-Bump.
