# VOLL-INVENTUR ungelandeter Strecken — W2-Lande-Zug (Phase 2)

Erhoben: 22.08.2026 ~14:20 UTC, Fable-max-Inventur-Agent (read-only, KEIN Merge/Bau/Push).
Methode: fetch --prune origin+github NUR in den Hauptklonen (6x origin + 4x github, alle RC=0);
je Store ALLE refs/heads + refs/remotes gegen origin/development (merge-base --is-ancestor,
bei Nicht-Ancestor git cherry fuer Patch-Aequivalenz); je Worktree status --porcelain +
untracked + nested gits; Stash je Store. Rohlogs in diesem Ordner:
roh-ce-refs.txt, roh-super-refs.txt, roh-prt-thesis-refs.txt, roh-worktree-sweep.txt,
roh-nachklaerung.txt. Untracked-/Dirty-Sicherung additiv unter untracked-sicherung/.

## 0. STORE-KARTE (Hauptklone mit ECHTEN Remotes)

| Store | Pfad | Stand nach fetch |
|---|---|---|
| super | ~/Projekte/Research/probst-diplomarbeit-cache-engine | dev lokal e6c90277 = origin/dev 93542880 + 1 UNGEPUSHTER Ledger-Commit (KON120-02-Nachtrag A4/OS-Matrix, 21 Z.) |
| ce (Submodul-Hauptklon) | super/.git/modules/Code/external/comdare-cache-engine | dev lokal == origin == f729b93a |
| prt-art Standalone | ~/Projekte/Research/comdare-prt-art | origin/dev 777fff7e; Klon steht auf MAIN 01e8b7dd (AB-10-Posten: auf development drehen) |
| prt-art Submodul-Store | super/.git/modules/Code/external/comdare-prt-art | dev lokal d11781fa = 4 HINTER origin 777fff7e (super-Gitlink zeigt d11781fa; Bump = Lande-Zug Phase 3/4) |
| thesis Standalone | ~/Projekte/Research/20260931-overleaf-diplomarbeit | dev lokal == origin == c169fd22; github/main 246eff90 DIVERGENT (13/26) |
| thesis Substore (thesis/diplomarbeit) | super/.git/modules/thesis/diplomarbeit | detached c169fd22 (== Gitlink); lokale Heads = Vor-Rewrite-Linie |
| thesis Substore (Code/external/...) | super/.git/modules/Code/external/20260931-overleaf-diplomarbeit | detached c169fd22; lokale Heads = Vor-Rewrite-Linie |

Worktrees je Store (via git worktree list + rev-parse --git-common-dir verifiziert):
ce = 28x /home/comdare/wt-ce-* + 4 interne (.claude/worktrees: wf_5834b706-7b5-15/16/19,
wf_e22d25ef-71c-7) + 1 prunable /tmp-Scratch (7150cc51, ENTHALTEN in dev);
super = 5x /home/comdare/wt-super-*; prt-art Standalone = wt-prt-pinduo;
thesis Standalone = wt-thesis-lizenz. Nested gits NUR in wt-super-w1luecken
(ce detached 66de5c09, prt-art detached d11781fa — beide clean, nested-Heads enthalten);
die uebrigen wt-super-* haben KEINE initialisierten Submodule. ce traegt Vendor-Submodul
ext/queuing/Q01-concurrentqueue (Pin d655418, clean, kein Inventur-Gegenstand).
Stash-Listen: ALLE Stores leer (ce, super, prt x2, thesis x3, nested).

## 1. KANDIDATEN-TAFEL — EINSTUFUNG LANDEN (19)

Reihenfolge ce-Phase-1 = bindende Workflow-Vorgabe; je Merge vorher 3-Achsen-Explore
(STRUKTURELL/DESIGN/HISTORISCH) + Harmonisierungs-Flaechen (tests/unit/CMakeLists.txt-Ende).

| # | Repo | Branch/Worktree | Tip | in dev? | dirty? | Begruendung |
|---|---|---|---|---|---|---|
| L0 | ce | lande/w2-s1s2 (wt-ce-lande) | 61d5d139 | nein (Zug-Traeger) | clean | Lande-Zweig, Merges 1/10 s19 + 2/10 messfenster GEFAHREN (Ancestor-Beweis); NUR LOKAL, keine origin-Ref — Push am Zug-Ende (Gates 6/6 + gitleaks) |
| L1 | ce | bau/s19 | a1b348ae | nein (+1) | wt clean | BEREITS im Zug (Merge 881d1a15); G1: FUND-1/FUND-2 OFFEN mit Traeger (Hinweis-Zeile + 7er-J-1-Liste im Protokoll) |
| L2 | ce | bau/messfenster | 3a746090 | nein (+1) | wt clean | BEREITS im Zug (Merge 61d5d139); H-5 18->120-Nachzug + F-14 als Lande-Pflichten |
| L3 | ce | bau/s8kopf | 41ee8780 | nein (+1) | wt clean | Merge 3/10; S8A-01 (7er-J-1-Liste literal) + S8A-02 (Anker :714-719) als KLEIN-Traeger (G6) |
| L4 | ce | bau/s13schema | c76d3116 | nein (+2) | wt clean | Merge 4/10; r2-Fix enthalten (ASCII-Wache); LANDE-KOPPLUNG mit super-s13 (H-6) |
| L5 | ce | bau/pmcpaket | 1d38263b | nein (+1) | wt clean | Merge 5/10; T6 NP-34-Patch im super-Abschnitt, T8b 7-static_asserts-Ledgerzeilen (Lead) |
| L6 | ce | bau/vollzug91 | 6713156b | nein (+1) | wt clean | Merge 6/10; V91-A1 Beweis-BU in Phase-5-Vollaudit, V91-A2 via G8-Quer-Auflage |
| L7 | ce | bau/ph89 | 2809e4d4 | nein (+1) | wt clean | Merge 7/10; 42 Dateien; 7 Schema-Bedarfe an s13-Zug; Ledger-ENTWURF im Ergebnis |
| L8 | ce | bau/trigfix | 0f900dcf | nein (+1) | wt clean | Merge 8/10; 0/0/3 KLEIN -> T-9-Folgewelle; E07-Pruefer fuer #114 |
| L9 | ce | bau/skip97 | 1c9f58a5 | nein (+2) | wt clean | Merge 9/10; Tip 1c9f58a5, NICHT 100c32d2 (T11); Task-#97-Text nachziehen |
| L10 | ce | bau/kampvor | 1e1bc199 | nein (+1) | wt clean | Merge 10/10; P-25 = Lande-Vorbedingung, P-26 ci.skip-Nachpruefung per API (T12) |
| L11 | ce | bau/o2-standard (wt-ce-o2std) | fa48a551 | nein (+1) | DIRTY: profile_run_entry.hpp 19-Z.-FORMAT-Delta unkommittet (Diff gesichert) | E-7 im Zug (#117/#131); O3-Waehlbarkeit erhalten; VOR Merge dirty-Datei committen ODER verwerfen (Schreiber o2-umbau/Lead) |
| L12 | super | bau/s13schema (wt-super-s13schema) | 1e92b77e | nein (+1) | clean | Phase 2 ZUERST — KOPPLUNG mit ce-s13 (H-6); origin-gesichert |
| L13 | super | bau/cidual (wt-super-cidual) | 223ab518 | nein (+1) | clean | Phase 2; R1+R2 CI-Dual (Kill-Switch weg, changes:-Drosseln weg); beweis-diff liegt |
| L14 | super | fix/vorlagenfenster-r1 (wt-super-vorlagenfix) | a6fa04da | nein (+1) | clean | T1 [PFLICHT]: HARMONISIERUNG mit Lead-Fassung 8ed8b268 (NUR dieser traegt die 4 Zaehler-Stellen, G5); D-11/D-12-Block-Tausch uebernehmen |
| L15 | super | bau/w1luecken-super (wt-super-w1luecken) | 8edc34a0 | nein (+1) | clean; nested ce 66de5c09 + prt d11781fa detached/clean | #113-Rest (B11 skip_anker-Bissprobe + B14-xmllint); nested-Tips enthalten |
| L16 | super | bau/kampvor (wt-super-kampvor) | 025e0c42 | nein (+1) | clean | Phase 4 kampvor(super); T12b CCD-Verdopplungs-Semantik im F-108-docs-Zug |
| L17 | prt-art | bau/pinduo (wt-prt-pinduo) | 25bbf2e2 | nein (+3) | clean | Phase 3 ZUERST; T9-Fixup VOLLZOGEN (ce-pin-Skip + K13 beidseitig + 224/224); Rezept #107; origin-gesichert |
| L18 | prt-art | bau/w1luecken-prtart | 3710ac4c | nein (+1) | kein wt | B14 NACH pinduo, Konflikt zugunsten D-10a (H-18: ce-Pin bleibt 66de5c09); origin-gesichert |

## 2. EINSTUFUNG ENTSCHEID-NOETIG (2)

| # | Repo | Ref | Tip | Befund |
|---|---|---|---|---|
| E1 | thesis | github/main (Owner-Overleaf-Linie) | 246eff90 | 26 Commits NICHT in origin/development, beidseitig divergent (origin/dev 13 voraus) = die c2d21fa..246eff9-Kommentar-Serie aus #121. Traeger = C3-THESIS-GROSSZUG (#121, wartet auf Owner-Restkommentare 3/90); Einholung als MERGE STATT VERDRAENGUNG (Muster #67). KEIN W2-Lande-Zug-Gegenstand. |
| E2 | super | b-ci-rueckschrieb-beide-zeiger | 87d70adf | NUR-lokaler Arbeitsstand-Commit aus #66 (cherry +1 echt). Branch-Name = der OFFENE .gitmodules-Posten (anhang:forward soll BEIDE Thesis-Zeiger bumpen statt Drift zu erzeugen). Lead entscheidet: als Posten-Traeger weiterfuehren ODER nach Sichtung ins Archiv-Verfahren (#66-Bundle deckt ihn NICHT — 87d70adf ist juenger als das Bundle). |

## 3. EINSTUFUNG ARCHIVIEREN — nicht enthalten, aber auditiert/patch-aequivalent (kein Lande-Gegenstand)

| # | Repo | Ref | Tip | Beleg |
|---|---|---|---|---|
| A1 | ce | b-m2-pmc-invariante | 90bca126 | cherry +0/-1 patch-aequiv (D12: 8894d983 in dev); D12-Bundle 0ffc63a2; lokale Ref = Restposten |
| A2 | ce | b-m3v2-pmc-window | 81651f6e | cherry +0/-1 patch-aequiv (D12: 2b5ecd29); wie A1 |
| A3 | ce | b-pmc-errno-diag | 3f0d989d | cherry +0/-1 patch-aequiv (D12: 22e17f57); wie A1 |
| A4 | ce | bau/p2-warnstufe-aufteilen (+ interner wt wf_5834b706-7b5-15) | 237d0952 | D12-Urteil: NICHT-ENTHALTEN + WIEDERVERWENDBAR; Bundle in bau/branch-archiv-d12 @ 0ffc63a2; origin GELOESCHT. Lokale Ref + Worktree = Restposten (Raeumung Lead, Bundle-Deckung liegt) |
| A5 | ce | bau/p3-ci-clang-pflicht (+ interner wt wf_5834b706-7b5-16) | 708cf156 | D12-Urteil: NICHT-ENTHALTEN + TEIL-UEBERHOLT durch CI-DUAL (#106/S-12/#3); Bundle wie A4 |
| A6 | ce | w0a/d2-floor | 7f3901fb | #62-Urteil: UEBERHOLT (dev-Zwillingslinie), Bundle bau/branch-archiv-62 @ 2a33b86f; zusaetzlich X-11-Sicherung als origin/worktree-wf_e22d25ef-71c-7 |
| A7 | ce | worktree-wf_e22d25ef-71c-7 (lokal + origin-Ref; interner wt mit 17 untracked) | 7f3901fb | B01/X-11: BU 19 Eintraege + origin-Ref; 7/7 D2-Tests in dev gedeckt, KEIN einzubauender Rest; 17 untracked HEUTE zusaetzlich additiv gesichert (untracked-sicherung/) |
| A8 | ce | w2-A13-M1b | e35e0f36 | cherry +0/-6 patch-aequiv (Alt-W2-Aera Juli) |
| A9 | ce | w2-FK-1 | 6019585c | cherry +0/-6 patch-aequiv |
| A10 | ce | w2-FK-2 | a21575c5 | cherry +0/-4 patch-aequiv |
| A11 | ce | w2c-TP1FK1-Fixes | c4d5b354 | cherry +0/-5 patch-aequiv |
| A12 | ce | w2c-wachen-fixes | 43d98d5b | cherry +0/-5 patch-aequiv |
| A13 | ce | backup/pre-rescrub-2026-07-25 | bbd5915a | Rewrite-Sicherung Juli, cherry +0 (rein patch-aequiv); BEHALTEN (BU-additiv-Doktrin), nie ohne Owner loeschen |
| A14 | super | b-checkheft-nachtrag | 74c1e780 | #66: ENTHALTEN (cherry); Bundle 20260815-randbestand-audit @ 4e473a5a |
| A15 | super | landung/gitlink-aebc4f2c-OBSOLET | e4c1488d | #66: UEBERHOLT (dev-Gitlink 0817c7bf); Bundle wie A14 |
| A16 | super | wip/luecken-stufe2-pause-1308 | 6b89fce5 | #66: Kern blob-identisch 2x in dev, Rest UNGEPRUEFT-WIP; Bundle wie A14 |
| A17 | super | backup/pre-diplom-adopt-2026-07-22-development | eec84b0e | Adopt-Rewrite-Sicherung (Vor-Identitaets-Historie, cherry +1059); BEHALTEN |
| A18 | super | backup/pre-diplom-adopt-2026-07-22-main | 332c54af | wie A17 (+1050); BEHALTEN |
| A19 | super | backup/pre-identity-adopt-2026-07-26 | 557b8b38 | wie A17 (+1057); BEHALTEN |
| A20 | super | rescue/thesis-gitlink-paritaet-20260810 (origin+github+stale gh-scrub-Ns) | 18a0bdf3 | bewusste rescue-Sicherung; #66: patch-aequiv/SHA-identisch gedeckt; BEHALTEN |
| A21 | prt-art | w2-E02-Ledger | 3798a7f6 | cherry +0/-1 patch-aequiv (Alt-W2-Aera) |
| A22 | thesis | Substore-Heads BAU: development eaf7fe87, main 95db7793, b-thesis-o4-nachzug 863170f0, w2-E02-Ledger 0e39e1da, backup/pre-rescrub ef448e4b | s.o. | ALLE cherry +0 = reine VOR-REWRITE-Linie (Trailer-Rewrite #61); Substore-Checkout detached c169fd22 == Gitlink; STEHEN LASSEN (im Zweifel nicht anfassen) |
| A23 | thesis | Substore-Heads EXTERN: b-thesis-ehrlichkeit-anhang 19e15920, main ef448e4b (+ stale github-Remote-Refs 8e58f691/66674788/8970465d im Substore) | s.o. | wie A22; die stale github-Refs des Substores sind Vor-Rewrite-Remote-Tracking (echtes github traegt overleaf-2026-06-22-1726 + rescue/gate8 NUR noch post-rewrite-enthalten) |

## 4. ENTHALTENE STRECKEN MIT STEHENDEM WORKTREE (Raeumung = Lead-Schritt nach Doktrin, KEIN Lande-Gegenstand)

Alle Tips Ancestor von ce origin/development f729b93a; Worktrees clean sofern nicht vermerkt:
wt-ce-a11 (ec048560) · wt-ce-bump15 (af0f251a) · wt-ce-f3v (dac3d91a) · wt-ce-g2 (6af6a415) ·
wt-ce-golden-rettung (fbe898be) · wt-ce-hy-a (a4366cb8) · wt-ce-k2 (7a5ed464; 1 untracked
_wiederanlauf.sh GESICHERT) · wt-ce-l10 (14a7d0c4) · wt-ce-l1fix (b791d3e2) · wt-ce-nachlande
(e9d035f6) · wt-ce-v08r (eab9476b) · wt-ce-varwache (e0126fad) · wt-ce-vl12 (cd011e60) ·
wt-ce-vl3 (7bf66ddd) · wt-ce-w1luecken (3149c8a2) · wt-ce-xorf (b8d6edab) · intern
wf_5834b706-7b5-19 = bau/p6-lizenz-umsetzung (f6d13dfb) · /tmp-Scratch detached 7150cc51
(prunable, enthalten). wt-thesis-lizenz (c169fd22 == origin/dev, clean) ebenso.
CAVE Doktrin: Loeschung erst nach rekursiver Pruefung + gruen/gemergt; nested-Worktrees
sterben mit; ein Teil traegt getrackte Mess-CSV-Klassen im Build-Verzeichnis.

## 5. BEFUNDE OHNE EIGENEN KANDIDATEN-STATUS

1. super development LOKAL 1 Commit vor origin (e6c90277, Ledger-NACHTRAG KON120-02/A4)
   — faehrt mit dem naechsten super-Lande-Push mit; R4 beachten.
2. prt-art-Submodul-Store dev d11781fa = 4 hinter origin/dev 777fff7e (#104-Landung);
   super-Gitlink zeigt d11781fa — Gitlink-Bump + Substore-Nachzug im Zug (Phase 3/4).
3. prt-art-Standalone-Klon steht auf main statt development = AB-10/T5-Posten (Lead).
4. lande/w2-s1s2 hat KEINE origin-Ref — bei laengerer Zugdauer Ref-Sicherung mit
   push -o ci.skip erwaegen (R4: 1 Push = 1 Pipeline nur fuer echte Lande-Pushes).
5. super-Hauptklon: Gitlink ce dirty (f729b93a vs. Aufzeichnung; normal vor Bump) +
   untracked build-l4/ (Build-Rest der L4-Landung; Loeschung nur nach Doppel-Bedingung).
6. thesis origin/rescue-w3c wurde REMOTE geloescht (Prune heute vollzogen) — V9-Umfeld;
   github traegt weiterhin rescue/gate8-graph-abbildungen (enthalten).
7. wt-ce-o2std-Dirty-Diff = reines clang-format-Alignment (19 Z.), gesichert unter
   untracked-sicherung/wt-ce-o2std/ — vor E-7-Merge klaeren (Schreiberschafts-Frage!).
8. Kein Stash in irgendeinem Store; keine weiteren nested gits ausser den in Abschnitt 0
   genannten; gh-scrub-Refs im super sind stale Namespace-Reste eines entfernten Remotes.

## 6. ZAEHLWERKE + SELBSTCHECK

Stores geprueft: 7 (mit echten Remotes) + 2 nested (frozen-origin, NUR objektseitig geprueft).
Worktrees geprueft: 35 wt-* + 4 interne ce + 1 /tmp-prunable + 7 Hauptklon-Checkouts = 47 Baeume.
refs/heads gescannt: ce 170, super 71, prt-standalone 8, prt-substore 3, thesis-standalone 4,
thesis-substores 5+2 = 263 Heads; remote-Refs aller Stores gegen origin/development gehalten.
NICHT in dev enthalten: ce 25, super 13, prt-art 2(+2 origin-Zwillinge), thesis 1 (github/main)
+ 7 Substore-Vor-Rewrite-Heads. Einstufungen: 19 LANDEN, 2 ENTSCHEID-NOETIG,
23 ARCHIVIEREN-Zeilen (A22/A23 buendeln 7 Substore-Heads), 18+1 enthaltene Worktree-Restposten.
Jede Zeile traegt Tip + Ancestor-/cherry-Messung aus den Rohlogs dieses Ordners; keine
Zahl ohne Nenner; nichts geloescht, nichts gemergt, nichts gepusht, nichts gebaut.
