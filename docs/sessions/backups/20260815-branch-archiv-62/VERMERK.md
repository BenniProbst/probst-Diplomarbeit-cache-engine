# BRANCH-ARCHIV #62 -- 15 ce-origin-Branches (Task #62, Frage-8-GO mit Re-Pruefungs-Auflage)

Datum: 2026-08-15 (serieller Slot #62)
Repo: comdare-cache-engine (ce), gemessen gegen origin/development = 8fe66469af9decdc39ddd50baeff34b9b23bb635
origin = https://gitlab.comdare.local/comdare/research/comdare-cache-engine.git (GitLab Projekt 286)
github = https://github.com/BenniProbst/comdare-cache-engine.git (Dual-Remote, gemessen)
GO: Owner Frage-8 woertlich "GO, Loeschung sofern nochmal geprueft wurde" -- die Re-Pruefung je
Branch steht unten. Verfahren nach dem bewaehrten D12-Muster (20260815-branch-archiv-d12, #50).

## Erhebung (frisch, 15.08.)

git ls-remote --heads origin: 38 Heads gesamt. Lebend (23/38): development, main,
bau/b2-gate-trennung (e966ee81), bau/golden-homes (0eea2a0a), 19x rescue/*;
backup/pre-*: 0 vorhanden. Kandidaten: 15/38 (Tabelle unten; eine aeltere Zaehlung sagte ~14,
gemessen sind es 15). GitHub-Seite gemessen: 21 Heads (development, main, 19x rescue/*),
0 der 15 Kandidaten vorhanden -- auf GitHub ist nichts zu loeschen.

Lebend-Sonderbefund: bau/golden-s14a-riegel (8cc564d5) und bau/ci-dual-emission (731b5655)
standen auf der Lebend-Liste, existieren auf origin aber NICHT (schon VOR #62, frische
Erhebung); beide Tips sind in development enthalten (git merge-base --is-ancestor rc=0 je) --
bereits gelandet, Remote-Branch schon frueher entfernt. Kein Verlust, nichts angefasst.

## Form der Bundles

- 4 Nicht-Ancestor-Kandidaten (w0a/d2-floor, w2-A13-M1b, w2-FK-1, wip/preserve-dirty-20260722):
  duenne Bundles in D12-Form -- genau die Commits, die development (8fe66469) NICHT enthaelt
  (`git bundle create <f> ^8fe66469 refs/remotes/origin/<branch>`).
- 11 Ancestor-Kandidaten (alle bau/*): die D12-Form waere hier leer, git verweigert das
  (probiert, literal: "fatal: Refusing to create empty bundle.", rc=128). Stattdessen
  Tip-Bundle (`git bundle create <f> ^refs/remotes/origin/<b>^@ refs/remotes/origin/<b>`):
  genau der Tip-Commit, prerequisites = seine Eltern. Das sichert die Ref-Name->Tip-Zuordnung
  verlustfrei; die Commit-Historie selbst traegt development ohnehin (Ancestor-Beleg je Zeile).
- Prerequisites gesamt: 15 Eintraege, 11 unique, 11/11 Vorfahren von development (rc=0 je) --
  Wiederherstellung gelingt aus jedem Klon, der development traegt:
  `git fetch <bundle> 'refs/remotes/origin/*:refs/heads/restored/*'`
- Integritaet: `git bundle verify` rc=0 (15/15); SHA256SUMS in diesem Verzeichnis,
  `sha256sum -c` rc=0 (15x OK).
- Restore-Drill (beide Bundle-Formen, literal): Klon in tmp; fetch aus ce-w0a-d2-floor.bundle
  -> restored/w0a/d2-floor = 7f3901fb958465d0cebe608d73031c8fd79cd144 (SOLL identisch, rc=0);
  fetch aus ce-bau-b5-pmc-status-token.bundle -> restored/bau/b5-pmc-status-token =
  2f6f263a28c240eb0f78adb96397db12c9a42988 (SOLL identisch, rc=0). tmp danach geloescht.

## Urteile (D12-Schema: ENTHALTEN / NICHT-ENTHALTEN+WIEDERVERWENDBAR / NICHT-ENTHALTEN+UEBERHOLT)

| Branch | Tip | Urteil | Beleg | Wiederverwendung |
|---|---|---|---|---|
| bau/b5-pmc-status-token | 2f6f263a | ENTHALTEN | is-ancestor rc=0, cherry 0 offen | n/a, voll in dev |
| bau/d3-7b-pruef-only-bilanz | 93f5952b | ENTHALTEN | is-ancestor rc=0, cherry 0 offen | n/a, voll in dev |
| bau/hy0-abi-etikett-anker-wache | f1a43053 | ENTHALTEN | is-ancestor rc=0, cherry 0 offen | n/a, voll in dev |
| bau/m3a-branch-misses-ehrlichkeit | aa06f900 | ENTHALTEN | is-ancestor rc=0, cherry 0 offen | n/a, voll in dev |
| bau/p1-taxonomie-klasse-i | 3ea5e520 | ENTHALTEN | is-ancestor rc=0, cherry 0 offen | n/a, voll in dev |
| bau/p4-d2-partitions-koeder | ee0375be | ENTHALTEN | is-ancestor rc=0, cherry 0 offen | n/a, voll in dev |
| bau/p5-tote-anker | 9a15f9cc | ENTHALTEN | is-ancestor rc=0, cherry 0 offen | n/a, voll in dev |
| bau/p6-lizenz-umsetzung | f6d13dfb | ENTHALTEN | is-ancestor rc=0, cherry 0 offen | n/a, voll in dev |
| bau/prtart-waisen-archiv | 00d3910a | ENTHALTEN | is-ancestor rc=0 (Landung in 8fe66469) | n/a, voll in dev |
| bau/traeger-skeleton | be2d9e4e | ENTHALTEN | is-ancestor rc=0, cherry 0 offen | n/a, voll in dev |
| bau/xml-wohlgeformtheit | 90a31961 | ENTHALTEN | is-ancestor rc=0, cherry 0 offen | n/a, voll in dev |
| w2-A13-M1b | e35e0f36 | ENTHALTEN (patch-aeq. 6/6) | cherry 6x "-", Mapping unten | n/a, voll in dev |
| w2-FK-1 | 6019585c | ENTHALTEN (patch-aeq. 6/6) | cherry 6x "-", Mapping unten | n/a, voll in dev |
| w0a/d2-floor | 7f3901fb | NICHT-ENTHALTEN+UEBERHOLT | cherry 3x "+", Herleitung unten | Patch-Vorlage im Bundle |
| wip/preserve-dirty-20260722 | b5c4c8ce | NICHT-ENTHALTEN+UEBERHOLT | cherry 1x "+", s.u. | Gitlink-Commit im Bundle |

Ancestor-Beleg der 11 bau/*-Zeilen: `git merge-base --is-ancestor origin/<b> 8fe66469` rc=0 und
merge-base == Tip (11/11); `git cherry 8fe66469 origin/<b>` = 0 offene Patches (0/0 je).

### w2-A13-M1b -- patch-id-Mapping (Branch-Commit -> development-Commit, 6/6)

- a74992c6 -> 95fc814c (OWNER-Q3-FLAG-GRAMMATIK AlgoSemVer-Parser/Renderer)
- 93434ff8 -> 8acdb34e (dreistellige Sentinel-Form "v0.0.0")
- 95451745 -> b86b9d30 (CT-Wachen der Flag-Grammatik + ENFORCE-Naht)
- 9d3a9788 -> 23085ab1 (Hardware-Flag Bits 1-2 im reserved-Feld)
- e90f4a7b -> 18724cb3 (W12-Querschnitt auf Owner-Q3-Grammatik)
- e35e0f36 -> d12cca0e (AxisVersionEntry-Feldkommentar dreistellig)

### w2-FK-1 -- patch-id-Mapping (Branch-Commit -> development-Commit, 6/6)

- 06164aad -> 8893fdc7 (BuildCellStatus drittes Zell-Vokabular 'nicht_gebaut')
- 32f93ac6 -> e3030b8b (sample_status_label D2-LOG-Etiketten)
- 8a45ac32 -> 30d4d8ed (Ersatz-Zell-Naht CSV-Renderer + build_status)
- 5a483bbf -> de576f83 (Rest-Naehte D1/D2 Marker-Zeile)
- 8c5a9fa2 -> 0fdeccff (curve_loader-Verwerf-Liste 'nicht_gebaut')
- 6019585c -> 1231bc06 (Guard nicht_gebaut-Marker + SourceUnavailable)

### w0a/d2-floor -- wodurch ueberholt (1 Satz + Belege)

Ueberholt durch die parallel gelandete dev-Zwillingslinie derselben drei Dateien: der Branch
traegt 3 Commits vom 09.08. 23:35-23:41 UTC (2418b7ba "Untergrenze 488 vorgerechnet",
816bee99 "Wache vergleicht wieder", 7f3901fb "sieben Google Tests"), development fuhr ab
3e6fa9d5 (09.08. 23:31 UTC, "die committete Untergrenze -- 488, hergeleitet statt gesetzt")
eine eigene Linie und entwickelte scripts/ci_test_coverage_guard.sh,
scripts/ci_test_inventory_floor.txt und tests/unit/test_d2_abdeckungs_wache_nenner.cpp in
11 Commits weiter (u.a. 3353171e F1a-F1c, 092ab7e9 #39 Floor-Nachzug-Wache, 0fbcb049
Anker-Sprache, 04f76b65 K13-Koeder-Fix); diff Branch->dev ueber genau diese drei Dateien:
+2293/-419 -- development ist weit voraus, der Branch-Stand blieb Vorstufe.

### wip/preserve-dirty-20260722 -- wodurch ueberholt (1 Satz + Belege)

Einziger Inhalt ist der Submodul-Zeiger ext/queuing/Q01-concurrentqueue
d655418b -> 683b9e31 (22.07., "giga-scrub P0-sync dirty-state preserve"); development fuehrt
seit dem Fork-Punkt 7b6618aa unveraendert d655418b (ls-tree identisch, mb == dev), der
Juli-Zeiger wurde nie uebernommen. Hinweis: das Zeiger-Ziel 683b9e31 existiert im lokalen
Q01-Store nicht (cat-file rc=128); fuer eine Wiederverwendung muesste es aus dem
Q01-Upstream beschafft werden -- das Bundle traegt den Gitlink-Commit selbst.

## Branch -> Tip (voll, Stand der Erhebung 15.08.)

```
2f6f263a28c240eb0f78adb96397db12c9a42988  bau/b5-pmc-status-token
93f5952bf5965f298fea98a0067870404d899003  bau/d3-7b-pruef-only-bilanz
f1a4305303ccb24edaf76d4358e27fc5bec41da9  bau/hy0-abi-etikett-anker-wache
aa06f90049b0c1f5f4f08924690dc071ab26492f  bau/m3a-branch-misses-ehrlichkeit
3ea5e5203efa5b8aabed8eae92968f2787838cdf  bau/p1-taxonomie-klasse-i
ee0375beab6c7d504252dcade07966258c369fbc  bau/p4-d2-partitions-koeder
9a15f9cc52cf6b725606c5ba6498af1bf0393689  bau/p5-tote-anker
f6d13dfbdae7f2fab08fe9cc59a5049885434ba3  bau/p6-lizenz-umsetzung
00d3910ad9406d50508538a8a52dd56af8005b43  bau/prtart-waisen-archiv
be2d9e4e236a947d983d5e717055e5d4a4005b33  bau/traeger-skeleton
90a3196180e709fd0725a9061bbf6bcc0f9d9ed2  bau/xml-wohlgeformtheit
7f3901fb958465d0cebe608d73031c8fd79cd144  w0a/d2-floor
e35e0f36ffa3426b52321bd54289eb186cc56b19  w2-A13-M1b
6019585c43573867af80c1c47388c3b6dc82f7df  w2-FK-1
b5c4c8cedc4ebd1d3a97258d49b464d29321333d  wip/preserve-dirty-20260722
```

## Konsequenz

Alle 15 Kandidaten sind re-geprueft und archiviert (Bundle + SHA256SUMS + dieser Vermerk).
Remote-Loeschung origin je Branch einzeln erst NACH gruener super-CI dieses Archiv-Branches
(Frage-8-GO). GitHub traegt keinen der 15 Kandidaten (gemessen, s.o.) -- dort keine Loeschung.
Die lokalen ce-Branches/Worktrees bleiben unberuehrt. Der Merge dieses super-Branches nach
development ist Sache des Lead (Landung), nicht Teil von #62.
