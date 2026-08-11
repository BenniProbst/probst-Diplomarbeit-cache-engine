# W0b-RESTPOSTEN -- Workflow-Ergebnis (Stand 2026-08-10)

Gegenstand: 5 Pakete, 5 gebaut, 5 durch die adversarische Verify-Lens gefahren.
NENNER der Verdikte: 5 Pakete geprueft -- 2 STIMMT (P2, P5), 3 STIMMT_TEILWEISE (P1, P3, P4).
NENNER der Verify-Lens: 5 Abnahmen gefahren -- 2 nicht widerlegt (P2, P5), 3 REFUTED (P1, P3, P4).

Diese Datei ist die Uebergabe. Sie ueberlebt das Ende des Lead-Kontexts.
Regel dieser Datei: keine Zahl ohne Nenner, keine Erfolgsmeldung ohne literale Ausgabe.
Alles, was nur behauptet und nicht gemessen wurde, steht ausdruecklich als UNGEPRUEFT in Abschnitt 5.

Paket-Kurzschluessel, wie er unten durchgehalten wird:
  P1 = p1-r2-landen        (D3-7b pruef_only, ce-Haelfte + super-Haelfte)
  P2 = p2-p4-landen / p4   (bau/p4-d2-partitions-koeder, Task #64-Rest, ce)
  P3 = p3-guard-basis      (Diff-Hygiene-Basis auf Literal origin/main, super)
  P4 = p4-lizenz-super     (Lizenz, super-Haelfte, Apache + NOTICE)
  P5 = p5-tote-anker       (#63, zwei Blocker aus dem Dualreview, ce)

--------------------------------------------------------------------------------
## 1 WAS LANDEFAEHIG IST

Landefaehig heisst hier: es existiert ein Commit ODER ein anwendbarer Patch, UND die
Verify-Lens hat ihn NICHT widerlegt, UND die Abnahme liegt als literale Ausgabe vor.
NENNER: 5 Pakete -- 2 landefaehig (P2, P5), 1 landefaehig erst nach Nachbesserung (P3),
2 nicht landefaehig, weil nichts gebaut wurde (P1, P4).

### 1.1 P2 -- Merge 02956fef  (LANDEFAEHIG)

  Repo    ce (comdare-cache-engine)
  Zweig   landung/p4-auf-development
  Commit  02956fef, Eltern e114cabd (= origin/development) + ee0375be
  Ort     /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/.git/modules/
          Code/external/comdare-cache-engine/.claude/worktrees/wf_80fa369e-9f9-2
  Zustand NICHT gepusht (`git branch -r --contains 02956fef` = leer)
  Zuwachs +114 Zeilen in 2 Dateien, Testzahl 41 -> 42

  Literale Abnahme (von der Verify-Lens SELBST gefahren, eigene Marke 9347f984 aus /dev/urandom,
  echte Wache scripts/ci_test_coverage_guard.sh, ohne Test-Harnisch):

      (a) manipuliert (Doppelname, eine Registrierung mit 'pmc'):  Exit 4
          PARTITIONS-RECHNUNG: ohne=2 mit=1 summe=3 inventur=2 differenz=1
      (b) unmanipuliert (heil, 2 ohne / 1 mit):                     Exit 1
          PARTITIONS-RECHNUNG: ohne=2 mit=1 summe=3 inventur=3 differenz=0

  Gegenprobe gegen den Vorzustand e114cabd (Wache mit 1192 Zeilen), gleicher Baum (b):
      Exit 1, 'PARTITIONS-RECHNUNG' = 0 Treffer, alter 'Summe : ... Inventur'-Beleg = 0 Treffer,
      Schlusszeile woertlich: ABDECKUNGS-WACHE: ROT -- Nenner belegt (1 von 1 Bloecken gelaufen)
  -> Der Riss, den P2 schliesst, ist am Objekt reproduziert; die Null ist keine stille Null.

  T-1 (Zeitrichtung, unabhaengig reproduziert, COMDARE_D2_WACHE_PFAD auf die Wache VOR dem Merge):
      Debug rc=1, Release rc=1, je `Running 41 tests`, `[ PASSED ] 39`, `[ FAILED ] 2`
      (PartitionsWiderspruchIstNennerBefundMitBeidenZahlen,
       HeilePartitionSchweigtUndDieRechnungIstBelegt)
      danach unmutiert: Debug rc=0, Release rc=0, je `[ PASSED ] 41 tests`

  Baeume: build/p4-dbg Debug configure rc=0 build rc=0; build/p4-rel Release configure rc=0 build rc=0.
  Ziel test_d2_abdeckungs_wache_nenner (ctest #452, Labels wachen;d2;nenner;selbsttest).
  Diff-Hygiene ueber den Zuwachs (scripts/ci_diff_ascii_width_guard.sh --stdin, rc=0):
      114 Zusatzzeilen geprueft, 0 Nicht-ASCII, 0 ueber 120 Spalten, 0 uebersprungen. GRUEN.
  Commit-Text: 0 Zeilen > 119 Byte, 0 Nicht-ASCII.

### 1.2 P5 -- Commit 52ca18f4  (LANDEFAEHIG)

  Repo    ce (comdare-cache-engine)
  Zweig   bau/p5-tote-anker-heilung, direkt auf 9a15f9cc (= bau/p5-tote-anker, Parent 95cb3039)
  Ort     .../comdare-cache-engine/.claude/worktrees/wf_80fa369e-9f9-5
  Zustand NICHT gepusht (0 Remote-Zweige enthalten ihn)
  Zuwachs 3 Dateien, +260/-42

  Literale Abnahme (Verify-Lens hat die TU SELBST uebersetzt: g++ 15.3 UND clang 22.1, -std=c++23,
  Projekt-Flaggen aus cmake/compiler_flags.cmake, vendored gtest 1.15.2; Mutationen NUR in einer
  byte-identischen /tmp-Kopie, Objekt-Worktree danach `git status` leer, HEAD 52ca18f4):

      dateien gelesen=1949 zeilen gelesen=293478
      zeilenverweise=94 von hoechstens 94 paragraf-marken=2056
      null-zone: 3/3 Dateien GELESEN

  T-1 beide Richtungen, EIGENER gewuerfelter Koeder (Suffix 1251128906 aus /dev/urandom,
  Umbenennung von mess_achsen_naht.hpp):
      NEUE Wache: NULL-ZONEN-DATEI NICHT GESCANNT: libs/cache_engine/profile_facade/mess_achsen_naht.hpp
                  2/3 Dateien GELESEN, 1 nicht gescannt   rc=1 (ctest 8)
      ALTE Wache, DERSELBE Defekt:
                  [NENNER] null-zone: 3/3 Dateien geprueft, 0 Verstoesse   rc=0
  -> Der hohle Nenner ist bewiesen, die Heilung traegt.

  Weitere Mutanten (alle gefangen):
      n = 0 an der Aufrufstelle          -> DerScanSiehtUeberhauptEtwas FAILED, rc=1
      /dev/urandom umgebogen             -> "nicht lesbar -- der Koeder waere eine Konstante", rc=1
      Ratsche bei reinem Zuwachs         -> "95 von hoechstens 94", rot

  Keine bestehende Wache abgeschwaecht: im Diff wurde keine EXPECT/ASSERT entfernt; die einzige
  ersetzte (geprueft == size(kNullZone)) war die Tautologie, ersetzt durch ein strikt staerkeres Paar.
  Produktiv-Aenderung mechanisch geprueft KOMMENTAR-ONLY: +50/-9 und +22/-11, davon 0
  Nicht-Kommentar-Zeilen in BEIDEN Richtungen.
  Hygiene ueber 9a15f9cc..52ca18f4 mit dem repo-eigenen Skript:
      260 Zusatzzeilen ... 0 Nicht-ASCII, 0 ueber 120 Spalten. 0 uebersprungen. GRUEN.
      Eigene Byte-Messung: 260 Zeilen, max 113 Byte, 0 ueber 119, 11 Nicht-ASCII-Zeichen -- alle Paragraf.
  Warnungen: 0 eigene unter g++ UND clang, je -O0 -g3 und -O3.

### 1.3 P3 -- Patch 0001-guard-basis-literal.patch  (LANDEFAEHIG ERST NACH NACHBESSERUNG)

  Der FIX haelt am Objekt; die ABNAHME haelt nicht. Deshalb steht das Paket in Abschnitt 2.
  Der Vollstaendigkeit halber hier, was gemessen GRUEN ist:

  Ort     /home/comdare/p3-guard-basis-literal/0001-guard-basis-literal.patch
          (458 Zeilen, 4 Dateien, 342 Zusatzzeilen; Commit 68fd15a9 im Mess-Klon, NICHT gepusht)
  Basis   super development d8f3cd77 (aus .git/worktrees/wt-super-landung/HEAD)

  T-1 unabhaengig reproduziert (alte Wache, COMDARE_GUARD_BASIS_REF="origin/main" gesetzt,
  origin/main fehlt, eigener Koeder d60351e7ed2f60b95a16c2c9 im Baum):
      Basis-Referenz: origin/development
      BEREICHSBREITE: 0 Commit(s)
      DIFF-HYGIENE-WACHE: GRUEN.    rc=0
  -> Der stille Rueckfall ist echt.

  Vier Arme nachgefahren: A rc=1 (2 Commits, 6 Zeilen, 1 Nicht-ASCII) - B rc=2 (NICHT aufloesbar) -
  C rc=0 (3 Commits, 3 Zeilen, 0 Verstoesse; Nenner nicht leer) - D rc=0, nennt origin/main aus der Kette.
  Zahlen 52/0 bestaetigt: main..HEAD = 53, development..HEAD = 1, abzueglich des neuen Commits
  = 52 und 0 an d8f3cd77; origin/development == d8f3cd77 exakt.
  Endlauf: 53 Commit(s), 62 Datei(en), 7301 Zeilen, 0 Nicht-ASCII, 0 ueber 120. GRUEN.
      7301 - 7007 = 294 = die selbstgeprueften Zeilen. Koharent.
  342 Zusatzzeilen: 0 Nicht-ASCII, 0 ueber 120 Byte, laengste 118.
  `git apply --check` rc=0. tests_registrierung_wache.sh rc=0, 12/12, 2 Job-Bloecke.

--------------------------------------------------------------------------------
## 2 WAS NICHT LANDEN DARF

Ein Verify-Blocker ist bindend. NENNER: 3 Pakete von 5 duerfen in ihrer heutigen Form nicht landen.

### 2.1 P3 -- BLOCKER: Teil (c) der Aenderung ist durch NICHTS gedeckt

  Die Verify-Lens hat NUR den elif-Zweig in scripts/ci_diff_ascii_width_guard.sh zurueckgedreht
  (genannte Basis wieder Kandidat statt Anweisung) und alles gefahren, was morgen faehrt:

      Rueckbau am Fixture:   rc=0, Basis origin/development, GRUEN   (Koeder im Baum)
      C++-Wache (6 Faelle):  rc=0  -- merkt NICHTS
      Registrierungs-Wache:  rc=0  -- merkt NICHTS
      sh -n:                 rc=0  -- merkt NICHTS

  NENNER: 4 Gates gefahren, 4 blind. Die sechs C++-Faelle lesen ausschliesslich den TEXT der
  .gitlab-ci.yml, nicht das Verhalten des Skripts. Damit deckt der neue Test die Teile (a) und (b),
  aber nicht (c) -- also genau die Haertung, die den stillen Rueckfall verhindert.
  BEDINGUNG FUER DIE LANDUNG: eine Wache, die den Rueckbau des elif-Zweigs FAENGT (Verhaltensprobe
  gegen das Skript, nicht Textprobe gegen die YAML), mit gewuerfeltem Koeder in beiden Richtungen.

### 2.2 P1 -- darf nicht landen, weil NICHTS GEBAUT wurde

  GEBAUT: nichts. Kein Commit, kein Merge, kein Gitlink, kein Push. Erzeugt wurden nur Lesewerkzeuge
  ausserhalb jedes Repos (/tmp/p1r2_ce_lsremote_origin.txt, /tmp/p1r2_objwalk.py, /tmp/p1r2_treediff.py,
  /tmp/p1r2_gitlink.py, /tmp/p1r2_dev_prof.hpp).
  Die Begruendung "strukturell unerreichbar" ist von der Verify-Lens WIDERLEGT: sie hat die Abnahme
  mit zwei Kommandos gefahren, sie ist gruen:

      [ OK ]  L2b '(pruef-only)' in der Bilanz-Zeile -> modus=pruef_only (dritter Modus)
      [ OK ]  L2c ohne Modus-Zusatz bleibt modus=voll
      [ OK ]  L2d '(provision-only)' UND '(pruef-only)' in EINER Zeile -> rc=1, kein Marker
      NENNER: 16 Faelle gefahren, 16 gehalten, 0 gerissen.   (Pruefling: /tmp/p1r2adv/ci/lauf_marker.sh)
      NENNER SELBSTBISS: 6 Mutanten gefahren, 6 gefangen.
      ci/tests/mess_ausbeute_bissprobe.sh --selbstbiss: 26 Faelle, 3 von 3 Mutanten gefangen, rc=0.

  Und die selbst zugegebene FALSCH-NULL war ein Werkzeugfehler, kein Repo-Zustand:
      git diff --shortstat development...worktree-wf_bc389245-884-2
       5 files changed, 313 insertions(+), 31 deletions(-)
  +313/-31 ist exakt bestaetigt; kaputt war /tmp/p1r2_treediff.py, nicht das Repo.
  P1 ist also NICHT blockiert -- es ist UNERLEDIGT. Neue Fassung der Aufgabe: Abschnitt 3.1.

### 2.3 P4 -- darf nicht landen, weil NICHTS GEBAUT wurde, und die Begruendung ist falsch

  GEBAUT: nichts. Begruendung im Bericht: "Kein Schreibzugriff, weder im eigenen Worktree noch in
  /home/comdare/wt-super-landung." Die Verify-Lens hat das am Objekt widerlegt (Schreibprobe anlegen
  und loeschen, beide Orte):

      WRITE_OK_own_worktree
      WRITE_OK_super_landung

  Zusaetzlich misst der angefuehrte Beleg den falschen Gegenstand: `git status --porcelain=v1 | wc -l`
  lief im eigenen ce-Worktree /home/comdare/wt-ce-w0a (Zweig w0a/registrierung-sichtbarkeit), nicht im
  super-Repo, um das die Aufgabe geht. Gemessen am richtigen Gegenstand:
      /home/comdare/wt-ce-w0a          -> 0
      /home/comdare/wt-super-landung   -> 1  (untracked: docs/sessions/20260810-KONTEXTUEBERGABE-...md,
                                              fremder Agent -- s. Abschnitt 4.4)
  T-1 war ohne jeden Schreibzugriff fahrbar und wurde nicht gefahren; die Lens hat ihn nachgeholt:
      /home/comdare/wt-super-landung/NOTICE existiert nicht (ls: No such file or directory)
      .gitmodules enthaelt exakt 4 Pfade
      /home/comdare/wt-super-landung/LICENSE = Apache License 2.0
  Neue Fassung der Aufgabe: Abschnitt 3.3.

--------------------------------------------------------------------------------
## 3 GEAENDERTE AUFGABENDEFINITIONEN

Muster D2-G4/D2-G5: die alte Fassung bleibt STEHEN, die neue steht DANEBEN. Nichts wird geloescht.
NENNER: 3 Korrektur-Einschuebe (P1, P3, P4) plus 1 Praezisierung (P2). P5 unveraendert.

### 3.1 EINSCHUB zu P1 (r2 / D3-7b pruef_only)

  ALTE FASSUNG (bleibt stehen, zur Historie):
    "r2 (D3-7b pruef_only) landen. Die super-Haelfte liegt in
     /home/comdare/Desktop/DIPLOMARBEIT-PLAIN-BACKUP/.../wf_bc389245-884-2 und muss von dort
     gerettet werden. Die ce-Haelfte ist 93f5952b."

  NEUE FASSUNG (gemessen, in ZWEI Haelften, mit super-Isolation statt ce-Isolation):

    TEIL 1 -- ce (in einem ce-Worktree ausfuehrbar):
      1. bau/d3-7b-pruef-only-bilanz (93f5952b) in ce development MERGEN, nicht umgekehrt.
         Umfang: 1 Commit, 1 Datei, +12 Zeilen in libs/cache_engine/profile_facade/profile_run_entry.hpp.
         Sauber anwendbar: das Feld pruef_only existiert in der development-Fassung bereits
         (5 Treffer / 1291 Zeilen). Nie rebase, immer merge (Kanon).
      2. Ergebnis-Commit pushen. DIESE NEUE ce-SHA ist der Gitlink-Kandidat -- NICHT 93f5952b.
      3. Gegenprobe nach dem Merge: '(pruef-only)' in profile_run_entry.hpp muss von 0 auf >=1 gehen;
         'provision_only' (18 Treffer) und 'RUN_PROFILE fertig' (1 Treffer) muessen unveraendert bleiben.

    TEIL 2 -- super (in /home/comdare/wt-super-landung, super-Isolation):
      4. refs/heads/worktree-wf_bc389245-884-2 (b6a9fdb5, 2 Commits, 5 Dateien, +313/-31) auf
         development mergen. QUELLE IST DAS LIVE-REPO, nicht das Desktop-PLAIN-BACKUP: dort liegen
         35 Eintraege und KEIN .git, b6a9fdb5 ist dort als Commit nicht vorhanden. Kein Bundle-Weg noetig.
         Die 5 Dateien: .gitlab-ci.yml, ci/lauf_marker.sh, ci/mess_ausbeute_wache.sh,
         ci/tests/lauf_marker_probe.sh, ci/tests/mess_ausbeute_bissprobe.sh.
         Konflikt in .gitlab-ci.yml EINPLANEN: development hat 2430 Zeilen gegen 2419 des Zweigs,
         ist also eigenstaendig weitergelaufen.
      5. Gitlink Code/external/comdare-cache-engine auf die SHA aus Schritt 2 setzen (aktuell e114cabd).
         Vor dem Commit per `git ls-remote` gegenpruefen, dass die Ziel-SHA auf dem ce-Remote liegt --
         das war der urspruengliche Blocker.

    STREICHEN aus der alten Fassung: der Rettungsweg ueber das Desktop-PLAIN-BACKUP. "PLAIN-BACKUP"
    ist woertlich gemeint: reine Dateikopie, null Git-Objekte.

    ABNAHME (bereits gruen vorgefahren, s. 2.2 -- muss nach der Landung erneut laufen):
      git archive b6a9fdb5 | tar -x -C <tmp> && sh ci/tests/lauf_marker_probe.sh
      erwartet: L2b/L2d gruen, "16 Faelle gefahren, 16 gehalten, 0 gerissen", Selbstbiss 6/6.

### 3.2 EINSCHUB zu P3 (Diff-Hygiene-Basis)

  ALTE FASSUNG (bleibt stehen):
    "Die super-Wache haengt an einer GitLab-UI-Einstellung; in ce haelt die Regel durch eine
     GITLAB-UI-EINSTELLUNG. Stelle die Basis auf ein Literal um (eine Zeile). Pruefe, ob origin/main
     die Wache dauerhaft rot macht, und staffle die Umstellung notfalls."

  NEUE FASSUNG:
    "Die super-Diff-Hygiene-Wache misst heute gegen origin/$CI_DEFAULT_BRANCH = origin/development
     (.gitlab-ci.yml:288, Job lint:diff-hygiene) und ist damit auf JEDER development-Pipeline ein
     NO-OP: merge-base(origin/development, HEAD) = HEAD, Ausgabe 'BEREICHSBREITE: 0 Commit(s)',
     '0 Zeilen geprueft', GRUEN. Stelle sie auf die literale Basis origin/main um -- gemessen gruen:
     52 Commit(s), 60 Datei(en), 7007 Zeilen, 0 Nicht-ASCII, 0 ueber 120 Spalten, rc=0.
     Die Umstellung braucht DREI Teile, nicht einen:
       (a) das Literal in .gitlab-ci.yml;
       (b) einen fail-closed-Vorspann, der den Basis-Zweig holt und einen flachen Klon entflacht --
           ohne ihn faellt die Wache still auf origin/development zurueck (gemessen: gleicher Baum,
           gleicher Verstoss, rc=1 ROT mit Ref, rc=0 GRUEN ohne);
       (c) eine Haertung der Wache, damit eine GENANNTE Basis nie durch eine andere ersetzt wird
           (Exit 2 statt Rueckfall); die Kandidaten-Kette bleibt nur fuer den Fall, dass NICHTS
           genannt wurde (manueller Aufruf).
     Dazu Google Tests in Code/tests/unit/, die Literalitaet, Basisname, Vorspann-REIHENFOLGE und
     Einmaligkeit der Zuweisung halten -- UND (neu, bindend) eine VERHALTENS-Probe gegen
     scripts/ci_diff_ascii_width_guard.sh, die den Rueckbau von Teil (c) faengt. Textproben gegen die
     YAML reichen dafuer nachweislich nicht (4 von 4 heutigen Gates sind blind, s. 2.1)."

    STREICHEN aus der alten Fassung, weil am Objekt widerlegt:
      - "In ce haelt die Regel durch eine GITLAB-UI-EINSTELLUNG": im ce-Arbeitsbaum 0 Dateien mit
        COMDARE_GUARD_BASIS_REF, 0 Treffer fuer CI_DEFAULT_BRANCH. ce faehrt sein kumulatives Gate mit
        dem LITERAL _ce_ff_basis="${COMDARE_HYG_FF_BASIS:-main}" und holt den Zweig selbst
        (git fetch --no-tags origin +refs/heads/<basis>:..., plus --unshallow). Im ce ist NICHTS zu tun.
      - "Staffelung, falls origin/main die Wache dauerhaft rot macht": am Objekt widerlegt, rc=0 GRUEN.

    FALLE, die in die neue Fassung gehoert: refs/remotes/origin/HEAD zeigt in BEIDEN Repos lokal auf
    main. Das ist der Klon-Zeit-Cache, NICHT die Server-Einstellung. Wer ihn als Beleg liest,
    "widerlegt" die Aufgabe faelschlich. Rohbeleg im Baum:
    docs/sessions/backups/20260802-e23-suchlauf-belege/e23/ -- 776 Projektzeilen gelesen, 10 Treffer,
    projects_all.ndjson und group_projects.ndjson stimmen ueberein: 286 = 'main', 288 = 'development'.

### 3.3 EINSCHUB zu P4 (Lizenz, super-Haelfte)

  ALTE FASSUNG (bleibt stehen):
    "Lizenz super-Haelfte: LICENSE auf Apache umstellen, NOTICE anlegen, README.md und CMakeLists.txt
     Lizenz-Aussagen nachziehen."

  NEUE FASSUNG (in einem SUPER-Worktree ausfuehren, z. B. `git worktree add` unter
  probst-diplomarbeit-cache-engine, Zweig bau/p6-lizenz-super -- NICHT in einem ce-Worktree):

    STREICHEN, weil kein Gegenstand existiert (jeweils mit Positivprobe gemessen):
      - "LICENSE auf Apache umstellen": steht BEREITS auf Apache-2.0, 201 Zeilen, Zeile 189
        "Copyright 2026 BEP Venture UG (Marke Comdare)". Den Apache-Text NICHT anfassen.
      - "README.md Lizenz-Aussage nachziehen": super hat keine Wurzel-README. Code/README.md (154 Z.)
        nennt license/apache/lizenz 0-mal; Positivprobe 'the' = 2 Treffer in derselben Datei.
      - "CMakeLists.txt Lizenz-Aussage nachziehen": super hat kein Wurzel-CMakeLists.
        Code/CMakeLists.txt (643 Z.) nennt license/apache/spdx 0-mal; Positivprobe 'project' = 3 Treffer.
      Beide Wurzel-Dateien stammen aus der ce-Haelfte, wo sie tatsaechlich an der Wurzel liegen.

    BAUEN -- die einzige echte Luecke (Quelle: 20260807-VORLAGE-lizenzwahl-drei-repos.md:301):
      A) /home/comdare/wt-super-landung/NOTICE anlegen. NOTICE fehlt: 0 Treffer im super-Baum ohne
         Submodule; Gegenprobe derselben find-Zeile findet Code/external/comdare-cache-engine/NOTICE
         (37088 B) -> die Null ist echt. Muster ist die ce-NOTICE (590 Z.): Kopf mit Werksname, Halter,
         Lizenzsatz, darunter der Fremdanteil-Block. Inhalt fuer super:
           - Halter: BEP Venture UG (Marke Comdare); Lizenz des super-EIGENCODE: Apache-2.0.
           - Die 4 Submodule aus .gitmodules NAMENTLICH, jedes mit SEINER Lizenz und Verweis auf
             sein LICENSE/NOTICE: Code/external/comdare-prt-art, Code/external/comdare-cache-engine,
             Code/external/20260931-overleaf-diplomarbeit, thesis/diplomarbeit.
      B) Eine Lizenz-WACHE bauen. Heute existiert KEINE: Dateien mit NOTICE-Bezug in ci/, scripts/,
         Code/ci_wachen/, Makefile, .gitlab-ci.yml = 0; Treffer NOTICE|LICENSE|SPDX|lizenz in
         .gitlab-ci.yml = 0. Der gewuerfelte Koeder ce-koeder-20e2e4a9612b5781 blieb in BEIDEN
         Richtungen unbemerkt (A: erfundener Submodulpfad ergaenzt, Pfade 4 -> 5, Koeder in der Datei
         JA; B: echter Pfad comdare-cache-engine entfernt, Pfade 4 -> 3). Die Wache muss beide
         Richtungen faengen: NOTICE nennt einen Pfad, den .gitmodules nicht kennt -- und .gitmodules
         nennt einen Pfad, den NOTICE nicht kennt.

    KONTEXT, der stehen bleibt (gemessen, nichts zu tun): SPDX-Koepfe unter Code/ = 23 Dateien, ALLE 23
    tragen "// SPDX-License-Identifier: Apache-2.0"; Nenner 181 Dateien in Code/ ohne external
    durchsucht, 158 ohne Kopf, 0 widersprechen dem Owner-Entscheid.
    Makefile, configure.sh, MANUAL_RUN.md, PROJECT_LAYER_MAP.md: 0 Apache-Nennungen
    (Positivprobe 'make' im Makefile = 45 Treffer -> Methode traegt).
    Keine eigene Vendorierung in super: find nach ext/vendor/third_party unter Code/ ohne external = 0.

### 3.4 PRAEZISIERUNG zu P2 (kein Widerspruch, aber zwei Fallen)

  ALTE FASSUNG (bleibt stehen):
    "bau/p4-d2-partitions-koeder (ee0375be) auf development landen; der Test heisst
     HeilePartitionIstKeinBefund."

  PRAEZISIERT:
    1. "auf development" heisst origin/development (e114cabd), NICHT den lokalen Ref development
       (c9d17963). Gemessen: `git rev-list --count development..origin/development` = 163,
       `git rev-list --count development..ee0375be` = 162,
       `git merge-base development ee0375be` = c9d17963 (= development selbst).
       Ein Merge gegen den lokalen Ref waere ein FAST-FORWARD ueber 162 Commits gewesen und haette die
       ganze Sammellandung mitgenommen statt eines Tests. origin/development enthaelt die
       Sammellandung 95cb3039 bereits. DER LOKALE ce-development-REF MUSS VOR JEDER WEITEREN LANDUNG
       NACHGEZOGEN WERDEN -- dieselbe Falle liegt fuer P1, P3, P5 und p6 bereit.
    2. Der Testname HeilePartitionIstKeinBefund ist der d2-floor-Name der SCHWAECHEREN Fassung
       (EXPECT_NE/EXPECT_FALSE-Form, die P2 im Commit ausdruecklich als "gruenes Gate ohne Gegenstand"
       verwirft). P2 baut bewusst HeilePartitionSchweigtUndDieRechnungIstBelegt. Wer nach dem alten
       Namen sucht, findet ihn nach der Landung nicht und haelt das Paket faelschlich fuer offen.
       Belegkette: w0a/d2-floor (7f3901fb) hat 15 TEST-Makros; `comm -23` gegen origin/development
       ergibt GENAU 5 fehlende Namen, 4 davon sind dort umbenannt und staerker vorhanden, der 5.
       fehlt wirklich -- den baut P2.

--------------------------------------------------------------------------------
## 4 KOLLISIONEN UND LANDE-REIHENFOLGE

NENNER der beruehrten Dateien: 14 Dateien ueber 5 Pakete, davon 1 mehrfach beruehrt.

  Paket  Repo   Dateien
  P1-ce  ce     libs/cache_engine/profile_facade/profile_run_entry.hpp
  P1-sup super  .gitlab-ci.yml, ci/lauf_marker.sh, ci/mess_ausbeute_wache.sh,
                ci/tests/lauf_marker_probe.sh, ci/tests/mess_ausbeute_bissprobe.sh
  P2     ce     2 Dateien (Wache + Test des d2-Abdeckungs-Nenners), +114 Zeilen
  P3     super  .gitlab-ci.yml, scripts/ci_diff_ascii_width_guard.sh,
                Code/tests/unit/test_ci_wache_guard_basis.cpp, Code/tests/CMakeLists.txt
  P4     super  NOTICE (neu) -- plus die noch zu bauende Lizenz-Wache
  P5     ce     abi/anatomy_version_stamp.hpp, profile_facade/mess_achsen_naht.hpp,
                tests/unit/test_anker_marke_statt_ledgerzeile.cpp

### 4.1 ECHTE KOLLISION: .gitlab-ci.yml (super) -- P1-sup gegen P3

  Beide fassen .gitlab-ci.yml an. P1-sup bringt einen Zweig mit, dessen Fassung 2419 Zeilen hat,
  waehrend development bereits bei 2430 steht -- der Konflikt ist ANGEKUENDIGT, nicht vermutet.
  P3 aendert dieselbe Datei an Zeile 288 (COMDARE_GUARD_BASIS_REF) und fuegt davor einen Vorspann ein.
  REIHENFOLGE: P1-sup ZUERST (Konflikt aufloesen, groesserer und aelterer Diff), P3 DANACH auf das
  Ergebnis. Umgekehrt wuerde der P3-Vorspann in die Konfliktaufloesung geraten und stillschweigend
  verloren gehen -- und genau sein Fehlen ist am Objekt als stiller Rueckfall gemessen (2.1/3.2).
  Nach der Aufloesung ist der P3-Endlauf (53 Commit(s), 62 Datei(en), 7301 Zeilen) NEU zu fahren;
  die Zahl 7301 gilt fuer d8f3cd77 + P3 allein, nicht fuer d8f3cd77 + P1-sup + P3.

### 4.2 KEINE Datei-Kollision, aber eine SHA-Kollision: der Gitlink

  P1-ce, P2 und P5 landen alle in ce und erzeugen jeweils eine neue ce-SHA. Der super-Gitlink
  Code/external/comdare-cache-engine (aktuell e114cabd) darf NICHT dreimal gesetzt werden.
  REIHENFOLGE: erst ALLE ce-Landungen (P2, P5, P1-ce) mergen und pushen, DANN den Gitlink EINMAL auf
  die finale ce-SHA setzen, und vor dem Commit per `git ls-remote` gegenpruefen, dass diese SHA auf
  dem ce-Remote liegt. Das war der urspruengliche Blocker von P1.

### 4.3 ce-intern: keine Ueberschneidung

  P1-ce beruehrt profile_run_entry.hpp, P5 beruehrt mess_achsen_naht.hpp -- gleiches Verzeichnis
  (libs/cache_engine/profile_facade/), verschiedene Dateien. P2 beruehrt keine der beiden.
  P5 sitzt auf 9a15f9cc (Parent 95cb3039), also VOR der heutigen origin/development-Spitze e114cabd;
  P2 ist bereits gegen e114cabd gemergt. Empfohlene ce-Reihenfolge: P2 (schon gegen e114cabd),
  dann P5, dann P1-ce -- jeweils gegen origin/development, nie gegen den stalen lokalen Ref (3.4).

### 4.4 Fremder Schreiber im super-Worktree

  /home/comdare/wt-super-landung hat 1 untracked Eintrag von einem anderen Agenten
  (docs/sessions/20260810-KONTEXTUEBERGABE-nacht-6-...md). Kanon: EIN SCHREIBER JE WORKTREE, weil
  `git commit` die GANZE Staging-Area nimmt. Wer dort P1-sup/P3/P4 landet, muss vorher pruefen, dass
  kein fremder Agent gleichzeitig schreibt, und darf nur die eigenen Pfade stagen.

--------------------------------------------------------------------------------
## 5 WAS UNGEDECKT BLEIBT

Ausdruecklich benannt, nicht durch Weglassen. Zu jedem Punkt: was GEPRUEFT ist und was NICHT.

  U-1  P2: GEPRUEFT sind test_d2_abdeckungs_wache_nenner in Debug UND Release plus die Diff-Hygiene
       ueber die 114 Zusatzzeilen. NICHT GEPRUEFT sind der Vollbau nach J-1..J-4, das Ziel
       comdare_tests, der ctest-Gesamtlauf, lint:format und lint:static. Der Merge beruehrt ausser
       den 2 Dateien nichts -- das ist eine Aussage ueber den Diff, nicht ueber den Baum.

  U-2  P3: Teil (c) der Aenderung (Skript-Haertung) ist durch 0 von 4 heutigen Gates gedeckt.
       Ein Rueckbau bleibt unbemerkt: rc=0 in allen vier. Bindender Blocker, s. 2.1.

  U-3  P4: es existiert HEUTE keine Lizenz-Wache -- die Frage "wurde eine bestehende Wache
       abgeschwaecht?" ist mangels Gegenstand mit nein zu beantworten, nicht mit "geprueft".
       Beide Koeder-Richtungen (Pfade 4->5 und 4->3) bleiben unbemerkt. NOTICE ist nicht gebaut.

  U-4  P1: nichts gebaut, also auch nichts abgenommen ausser dem, was die Verify-Lens selbst gefahren
       hat (16/16 Faelle, 6/6 Selbstbiss, 26 Faelle mit 3/3 Mutanten). NICHT GEPRUEFT: der Merge
       selbst, die Konfliktaufloesung in .gitlab-ci.yml (2430 gegen 2419), der Gitlink-Wechsel,
       und ob nach dem ce-Merge '(pruef-only)' in profile_run_entry.hpp wirklich von 0 auf >=1 geht.

  U-5  P5: das Ergebnis von `git merge-tree --write-tree` gegen origin/development (e114ca...) liegt
       im Verify-Bericht ABGESCHNITTEN vor. Die Konfliktfreiheit des P5-Merges gegen die heutige
       development-Spitze gilt damit als UNGEPRUEFT und ist vor der Landung neu zu messen.
       GEPRUEFT sind Uebersetzung (g++ und clang, -O0/-O3, 0 eigene Warnungen), T-1 in beiden
       Richtungen, 3 weitere Mutanten und die Hygiene ueber 9a15f9cc..52ca18f4.

  U-6  P5, dritter Befund aus dem Bau, der im Verify-Auszug abgeschnitten ist: der p5-Commit hatte
       "am Objekt wohnt der Satz heute bei Zeile 10409" geschrieben -- eine Gegenwarts-Zeilennummer,
       die im Heilungs-Commit 52ca18f4 entfernt und durch die Marke ersetzt wurde. Ob es WEITERE
       Gegenwarts-Zeilennummern derselben Bauart im Baum gibt, ist NICHT erhoben.

  U-7  Der p5-Bau erzeugte beim Heilen eines toten Ankers zunaechst einen NEUEN toten Querverweis
       (entfernte Marke METADATEN-BLOCKER, auf die 2 Dateien namentlich zeigen). 52ca18f4 heilt das
       an der Ursache. Die zugehoerige Wache ist fuer diese Klasse aber STRUKTURELL BLIND -- sie
       prueft Anker, nicht Ueberschriften-Marken. Diese Luecke bleibt offen.

  U-8  Der lokale ce-Ref development ist 163 Commits hinter origin/development. Ob er inzwischen
       nachgezogen wurde, ist NICHT gemessen. Vor jeder Landung neu pruefen (3.4).

  U-9  Keines der 3 gebauten Artefakte (02956fef, 52ca18f4, 68fd15a9 / Patch) ist gepusht.
       Es gibt damit heute 0 von 5 Paketen auf einem Remote. Ein Kontext-Ende ohne Push verliert
       nichts (die Worktrees liegen auf Platte), aber es macht auch nichts sichtbar.

  U-10 Fuer P1, P3, P4 sind die Owner-relevanten Entscheide unberuehrt: Lizenz je Repo
       (super = Apache) ist am Objekt bereits erfuellt; die Frage, was fuer die Submodul-Zeilen der
       NOTICE als Lizenz einzutragen ist, ist NICHT gegen die Vorlage
       20260807-VORLAGE-lizenzwahl-drei-repos.md gegengelesen worden -- nur deren Zeile 301 als
       Quelle der Luecke.

--------------------------------------------------------------------------------
ENDE. 5 Pakete, 5 gebaut, 5 verifiziert. 2 landefaehig (P2, P5), 1 nach Nachbesserung (P3),
2 unerledigt (P1, P4). 10 benannte Deckungsluecken (U-1..U-10). 1 echte Datei-Kollision (4.1),
1 SHA-Kollision (4.2), 1 fremder Schreiber (4.4).
