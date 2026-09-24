#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  BISSPROBE fuer den THESIS-PDF-EXPORT   (ci/thesis_pdf_export.sh)
#  -- ein Writeback-Script ohne versionierte Probe beweist seinen Vertrag
#     nur in der Commit-Botschaft.                               (2026-09-23)
# =============================================================================
#
# DER BEFUND, GEGEN DEN SIE GEBAUT IST (Order 371 / Board #279, Dual-Review
# d74abd47: Codex-Lens r1 + Opus-Erhebung r1 + Bewertung r1, F-08/E-4-13):
# Das Export-Script wurde mit "Biss-Test lokal 6/6" eingebucht, die Probe lag
# nicht im Baum. Die Bewertung fand am unveraenderten Script sieben Klassen,
# die nur eine Probe mit eigenem Wegwerf-Remote sichtbar macht: Token in argv
# (F-01), Testhaken in CI aktiv (F-02), stiller Schreibvorgang durch einen
# getrackten Symlink (F-03), Merge-Tip ohne [skip ci] (F-04), verschluckte
# Push-Fehler (F-05), alte PDFs auf bewegtem Gitlink (F-06) und doppelte
# Export-Commits bei byte-gleichem Remote-Bestand (F-07).
#
# WIE SIE PRUEFT: je Fall ein frisches Wegwerf-Bare-Repo (receive.advertise-
# PushOptions=true) als lokales Remote + ein Klon, detached auf dem Pipeline-
# Stand (wie GIT_STRATEGY fetch), vier Fake-PDFs; das Script laeuft in einer
# LEEREN Umgebung (env -i) mit explizit gesetzten CI_*-Werten und dem
# Testhaken COMDARE_THESIS_PDF_REMOTE=<bare>. Es beruehrt NIE ein Netz: das
# einzige Nicht-Datei-Ziel ist 127.0.0.1:9 (geschlossener Port, P-09/P-10).
# Der Testhaken ist im Script in CI verweigert; die Probe entfernt CI/GITLAB_CI
# deshalb bewusst aus der Umgebung (env -i) -- P-10 misst die Verweigerung.
#
# FAELLE (Soll literal, Nenner je Fall am Bare gemessen):
#   P-01 Erstexport: PUSH OK, 1 Commit, 4 PDFs im Tip, [skip ci] in der Botschaft
#   P-02 Retry gleiche Bytes von altem Stand: UNVERAENDERT (remote), Tip bleibt (F-07)
#   P-03 Branch bewegt ohne Gitlink, neue Bytes: Merge-Tip MIT [skip ci], PDFs neu (F-04/F-05)
#   P-04 Branch bewegt MIT Gitlink (a) / CI-Rezept (b): UEBERHOLT rc=0, kein Merge (F-06)
#   P-05 getrackter Symlink als Zieldatei: FEHLER rc=1, Datei ausserhalb unberuehrt (F-03)
#   P-06 FASSUNGEN='*': FEHLER unbekannte Fassung (set -f, F-03)
#   P-07 Fassung 'foo': FEHLER unbekannte Fassung (F-03)
#   P-08 COMDARE_THESIS_PDF_EXPORT=false: INERT rc=0, 0 Commits
#   P-09 Fake-Credentials gegen 127.0.0.1:9 mit GIT_TRACE: Token in 0 Zeilen (F-01)
#   P-10 Testhaken unter CI=true / als URL / auf Nicht-Bare: FEHLER rc=1 (F-02)
#   P-11 Bare ohne advertisePushOptions: git-Fehlertext sichtbar + kein Race-Zweig (F-05)
#   P-12 fehlende Fassung / Nicht-PDF: FEHLER rc=1 (Vertrag)
#   P-13 DIR absolut / mit .. / kanonisch gleich SRC: FEHLER rc=1 (F-03)
#   P-14 HEAD != CI_COMMIT_SHA: FEHLER rc=1 (Provenienz PDF = Pipeline-Commit)
#   P-15 fremder Pfad im Index: FEHLER rc=1, nichts gepusht (I-02)
#   r2 (Lens r1, 23.09.2026):
#   P-09b Askpass-Helfer des Scripts liefert per git credential fill (netzfrei); ohne Helfer laut (L1-05)
#   P-16 DIR mit .git-Komponente (.git/x, docs/.git/x, .git): FEHLER rc=1, 0 PDFs unter .git/ (L1-01, MUSS)
#   P-17 eigene Registrierung in .gitlab-ci.yml + kein allow_failure im eigenen Job, Koeder zuerst (T-7, L1-14)
#   P-18 getrackter Zwischen-Symlink docs/ext -> ../../aussen, DIR=docs/ext/pdf: FEHLER, aussen/ bleibt leer (L1-02)
#   P-19 assume-unchanged-Eintrag: git add stagt still nichts -> FEHLER, kein veraltetes PDF gepusht (L1-01)
#   P-20 DIR 'docs/diplomarbeit/' und './docs/diplomarbeit': normalisiert, PUSH OK (L1-06)
#   P-21 Zielordner selbst als getrackter Symlink nach aussen: FEHLER rc=1, nichts ausserhalb (L1-11)
#   P-22 Overrides der Probe (COMDARE_SKRIPT/COMDARE_CI_YML) unter CI=true: rc=2 verweigert (Klasse F-02)
#   r3 (Lens r2, 23.09.2026):
#   P-23 YAML-Block EPOCH-288 (thesis:pdf): SOURCE_DATE_EPOCH = Quellstand (Elter reiner Writebacks, auch
#        hinter einem --no-ff-Merge), F-10 Gitlink == Modul-HEAD sonst FEHLER (L2-01, MUSS)
#   P-24 YAML-Block DRIFT-WACHE-288-289 dreiwertig: byte-gleich / DRIFT rot / veraltet ohne Byte-Urteil /
#        fehlt gezaehlt (L1-04 + L2-01)
#   P-25 DIR 'docs//diplomarbeit', 'docs/./diplomarbeit', 'docs/diplomarbeit/.': normalisiert, PUSH OK (L2-05)
#   P-26 FASSUNGEN='de-lang de-lang': FEHLER 'doppelt', Bare unveraendert (L2-06)
#   P-27 CI_SERVER_URL=http://...: FEHLER 'nicht https://', kein Transport-Aufruf, Token in 0 Zeilen (L2-08)
#   P-23/P-24 lesen die ECHTE .gitlab-ci.yml (wie P-17): ohne die r3-Marker-Bloecke sind sie rot -- gewollt.
#   r4 (Lens r3, 23.09.2026):
#   P-23 (e) shallow-Klon des Wegwerf-Moduls (--depth 1) am Stand Y1: FEHLER 'gekappt' rc=1 statt stillem Rueckfall
#        auf %ct(HEAD) (L3-01, ADV-14, MUSS); (f) zwei reine Writebacks hintereinander: Epoch X1, 2 Stufen (ADV-10)
#   P-24 (e) 289-Kopie mit fremdem PTEX.Fullbanner bei gleichem Epoch: 'Toolchain abweichend', rc=0, 0 byte-gleich
#        (L3-02, MUSS); (f) fremde CreationDate-Form (kein D:<14 Ziffern>Z): veraltet/abweichend, rc=0 (I-4, ADV-12);
#        (g) pdftex fehlt auf dem PATH: FEHLER 'pdftex fehlt' rc=1 (Toolchain-Nachweis fail-closed, L3-02)
#   r5 (Lens r4, 23.09.2026):
#   P-23 (g) Merge MG mit p1 = Quelle S1, p2 = Writeback Y1 (Diff p1..MG nur die 4 PDFs): Epoch %ct(MG), 0 Stufen
#        (Ein-Elter-Regel, L4-01, MUSS); Writeback-Kind YG von MG: Epoch %ct(MG), 1 Stufe; (g2) derselbe Merge
#        MIT '[skip ci]' = nur die Ein-Elter-Regel haelt (m15); (h) Ein-Elter-PDF-Commit
#        OHNE '[skip ci]' (von Hand): Epoch %ct(H), 0 Stufen (UND-Bedingung); (i) acht Writebacks: Epoch X1 +
#        '8 Stufe(n)', neun Writebacks: FEHLER 'Eltern-Walk-Deckel' rc=1 (L4-04); (j) CI_PROJECT_DIR leer: FEHLER
#        'CI_PROJECT_DIR leer' rc=1 (L4-08)
#   P-24 (h) eingebettetes /PTEX.InfoDict einer Figur (fremdes CreationDate + Fullbanner) VOR dem Dokument-Dict:
#        (h1) Bytes gleich = '4 byte-gleich geprueft' (LETZTER Treffer, L4-02, MUSS); (h2) Figur-Banner gleich,
#        Dokument-Banner verschieden = 'Toolchain abweichend' rc=0; (i) sha256sum scheitert: FEHLER 'sha256sum' rc=1
#        (L4-07)
#   r6 (Codex-Lens r4, 23.09.2026):
#   P-17 (b) tags-Zeile 'tags: [prod, baremetal, amd]' an thesis:pdf UND thesis:pdf-export (C4-11, Host-Pinnung)
#   P-23 (k) Elter-Objekt X1 aus dem Objektspeicher eines Wegwerf-Klons entfernt (nicht shallow): FEHLER 'Elternliste
#        nicht lesbar' rc=1 (C4-12); Wurzel X1 bleibt gruen (a)
#   P-24 (k1) 289-Kopie mit Figur-InfoDict = CreationDate + Fullbanner je 2x: 'Kennung nicht lesbar/eindeutig',
#        rc=0, kein Byte-Urteil (C4-04; ersetzt (h1)/(h2) 'letzter Treffer'); (k2) 289-Kopie ohne Fullbanner: dito
#        (C4-03); (k3) eigener 288-Bau mit Figur-InfoDict: FEHLER 'Bau unlesbar' rc=1; (k4) 288-Bau ohne Fullbanner:
#        FEHLER rc=1; (k5) 288-Bau ohne CreationDate: FEHLER rc=1; (l) kpathsea-Suffix: 289-Banner bis '(TeX Live
#        2026)' gleich, kpathsea-Teil anders -> 'Toolchain abweichend' rc=0 (C4-05; am r5-Muster 'FEHLER: DRIFT');
#        (l2) escaped Klammern '\(TeX Live 2024\)' in beiden Kennungen gleich -> byte-gleich (Auftrags-Fixture);
#        (m) 289-Blob aus dem Objektspeicher entfernt (Pfad gelistet): FEHLER 'Blob nicht lesbar' rc=1 (C4-06);
#        (n1) pdftex --version ohne Ausgabe bei rc=0: FEHLER 'ohne Ausgabe' rc=1; (n2) pdftex rc=3: FEHLER rc=1
#        (C4-10); (o) Bau-Schleife der YAML mit Wegwerf-latexmk, das ohne -g eine vorhandene Zieldatei als
#        up-to-date liegen laesst: alle vier PDFs tragen 'neubau' (C4-09, rm -f + latexmk -g); (s) Block
#        SCHALTER-346: vier verschiedene Fassungen rc=0, de-kurz byte-gleich zu de-lang -> FEHLER 'wirkungslos'
#        rc=1 (C4-08 b); (p) Block F09-GATE-346 (nur mit Koppelpatch, sonst LAUT entfallen): Konsumstelle nur im
#        TeX-Kommentar -> FEHLER rc=1, echte Konsumstelle -> rc=0 (C4-08 a)
#   r7 (Lens r6 L6-01 + Codex-Lens r6 / Lead-Triage K294, 23.09.2026):
#   P-04c Branch bewegt MIT ci/thesis_pdf_export.sh: UEBERHOLT rc=0, kein Merge alter PDFs (C6-05)
#   P-09 (neu) fremder Server-Host 127.0.0.1: FEHLER 'nicht die Instanz' VOR jedem Transport, 0 remote-https-
#        Zeilen, Token in 0 Zeilen (C6-06); P-09c userinfo / Query in CI_SERVER_URL, fremde CI_PROJECT_ID: FEHLER
#   P-17 (c) Export-Job: Aufruf-Literal 'sh ci/thesis_pdf_export.sh --ci' (C6-07), KEINE needs-Zeile und
#        dependencies thesis:pdf (C6-09, Stufenbarriere), Koeder zuerst
#   P-24 (c1) 288-Bau mit CreationDate != SOURCE_DATE_EPOCH ohne 289-Kopie: FEHLER rc=1 (C6-01; am r6-Block rc=0);
#        (q) kein documentclass: FEHLER-Zeile erreichbar, rc=1 (C6-12); (s1) vier verschiedene Fassungen, kurz <
#        lang: rc=0 'Umfang de nachgewiesen' + 'Umfang en nachgewiesen' + '6 Paare'; (s2) de-kurz roh gleich:
#        FEHLER 'wirkungslos (de)'; (s3a) de-kurz = de-lang bis auf die /ID-Zeile, Seiten gleich: FEHLER rc=1
#        (L6-01, MUSS; am r6-Gate 'paarweise verschieden' rc=0); (s3b) dito fuer en: ZUSTAND-Zeile + rc=0 (#270);
#        (s5) de Hash verschieden, Seiten kurz >= lang: FEHLER rc=1; (s5b) en Hash verschieden, Seiten gleich:
#        FEHLER 'inkonsistent' rc=1; (s6) en-lang = de-lang bis auf /ID: FEHLER 'Sprach-Schalter wirkungslos'
#        (m28); (p) F09-GATE: nur Definitionen (\providecommand) = FEHLER, Definition +
#        Konsum (\ifx) = rc=0 (C6-02 a)
#   P-28 disjunkter Fremdstand: Mensch bewegt en-kurz am Remote, Job exportiert alle vier (nur de-lang neu): nach
#        dem Merge UEBERHOLT rc=0, Bare-Tip = Mensch-Commit, kein Mischstand gepusht (C6-04)
#   P-29 Quelle ueber getrackten Zwischen-Symlink thesis/ext -> ../../aussen: FEHLER rc=1, kein Push (C6-08)
#   P-30 COMDARE_THESIS_PDF_EXPORT=fasle: FEHLER 'unbekannt' rc=1; =false bleibt INERT rc=0 (C6-13)
#   P-31 --ci + Testhaken: FEHLER 'im Modus --ci verweigert' rc=1; --ci --foo: FEHLER 'unbekanntes Argument' (C6-07)
#   P-32 Remote setzt en-kurz auf Modus 100755 bei gleichem Blob: UEBERHOLT rc=0, kein Push (S7-01, r8b)
#   P-33 Remote ersetzt en-kurz durch Symlink: UEBERHOLT 'blob/120000' rc=0, kein Push (S7-01, r8b)
#   P-34 Remote loescht en-kurz: UEBERHOLT 'geloescht' rc=0 (kein FEHLER), kein Push (S7-02, r8b)
#   P-35 fremde getrackte README unter DIR lokal geaendert: FEHLER rc=1, nichts committet (S7-03 a, r8b)
#   P-36 Remote: gleiche PDF-Bytes + README unter DIR: UNVERAENDERT (remote), kein Merge/Push (S7-03 b, r8b)
#   P-37 CI_PROJECT_PATH fremd / mit Query bei ID 288: FEHLER vor jedem Transport, Wert nie im Log (S7-04, r8b)
#   P-38 URL mit userinfo+Kennwort / http / fremder Host: FEHLER ohne URL-Wert im Log (S7-05, r8b)
#   P-39 EXPORT/DIR/SRC/FASSUNGEN explizit leer: FEHLER, kein stiller Default (S7-06, r8b)
#   P-40 unlesbare PDF-Quelle: FEHLER nennt den head-Fehler, pipelinefrei (S7-08, r8b)
#   P-41 SIGTERM waehrend des Laufs: rc=143 und Hilfsverzeichnis geraeumt (S7-08 trap, r8b)
#   P-42 DIR mit literalem Stern + geloeschte Fremd-PDF darunter (Rename-Blob): r8b Glob-add + Push, r9 FEHLER (S8-01 a)
#   P-43 gestagte Fremd-Loeschung mit Blob der Ziel-PDF (Rename): r8b Index-Wache passiert, r9 FEHLER (S8-01 b)
#   P-44 Ziel 100755 im Arbeitsbaum / Quelle 0755 + Fake-chmod: Remote 100644 bzw. FEHLER Index-Wache (S8-02)
#   P-45 Remote loescht geaenderte Fassung: UEBERHOLT vor dem Merge; Erst-Export + fremder Commit: Merge + Push (S8-03)
#   P-46 Push abgelehnt (pre-receive): Log ohne Koeder/x-access-token/userinfo-URL; Credential-Maske (S8-04 Messung)
#   P-47 Koeder als Schalter / Fassung / Argument: FEHLER ohne den Rohwert im Log (S8-05)
#   P-48 EXIT-Trap-Zeile vor der mktemp-Zeile; fehler()-Pfad vor mktemp ohne 'unbound variable', 0 Reste (S8-06)
#   P-49 F09-GATE-346: mehrzeilige Makrodefinition = FEHLER statt falschem Konsum-Gruen (C8-06, Koppelpatch)
#   r10 (Codex-Lens r9 A/B + Fable-Lens r9, Lead K300/K301, 23.09.2026):
#   P-50 DIR/SRC mit Umlaut / '"' / '\' / ':' / ':(glob)' / '?' / '[ab]': FEHLER 'unzulaessige Zeichen' VOR jeder
#        git-Wache, kein Verzeichnis, kein Push (S9-03; deckt L9-02/L9-03)
#   P-51 Koeder als CI_COMMIT_SHA / CI_COMMIT_SHORT_SHA / CI_COMMIT_BRANCH: FEHLER ohne den Rohwert im Log (S9-07)
#   P-52 Textwache fehler() = printf, kein echo mit Variablen; DIR mit literalem '\n': genau 1 Meldungszeile (S9-09)
#   P-53 .gitattributes '*.pdf text' + CRLF-Artefakt: FEHLER 'Filter-/EOL-Konversion' vor dem Commit (S9-01)
#   P-54 core.fileMode=false + Remote-Eintrag 100755: Lauf gruen, Index/Remote 100644 (S9-02, L9-06)
#   P-55 push.err mit 'https://u:pa@ss@host/x' + 'git@host:g/r.git': '<cred>@host/x' + '<cred>@<host>:' (S9-06, L9-04)
#   P-56 git-Shim laesst 'ls-tree FETCH_HEAD' / 'cat-file -e FETCH_HEAD:' mit rc 128 scheitern: FEHLER statt
#        UEBERHOLT (S9-05)
#   P-57 Textwache Harnisch-Kopf: SELBSTBISS-Zahl == Script- + YAML-Mutanten (L9-01)
#   P-58 F09-GATE-346 kommentar-bewusst/zeilenuebergreifend: 3 Codex-Gegenfaelle = FEHLER, legitime Formen gruen,
#        Definition + Konsum = 'Konsum 1' (C9-01/C9-02, Koppelpatch; r8-Gegenfall = P-49)
#   P-59 Textwache ':0:$dst' genau 1x im Script, alte Form 0x (S9-04)
#   r11 (Codex-Lens r10 A/B + Fable-Lens r10, Lead K303/K304, 24.09.2026):
#   P-60 CI_COMMIT_BRANCH 'refs/heads/x' landet auf refs/heads/refs/heads/x (Branch x unbewegt); 'HEAD' / 'x.lock'
#        / 'x/' = FEHLER 'kein gueltiger Branchname' (S10-01, L10-07)
#   P-61 CI_COMMIT_SHORT_SHA / CI_PIPELINE_ID ungesetzt = 'NA' im Commit-Text; gesetzt leer oder 'NA' = FEHLER (S10-02)
#   P-62 mkdir-Shim: Kollision mit fremdem Ordner (mit Inhalt) + SIGTERM -> fremder Ordner unveraendert (S10-03)
#   P-63 TMPDIR mit Leerzeichen / ';' / relativ = FEHLER ohne Rohwert; chmod 0700 -- am Askpass-Helfer (S10-04)
#   P-64 Textwache fehler() ohne $SRC_K/$WERK/$TOP/$WURZEL/$DIR_K/$DIR_F; Symlink-Quelle ausserhalb: aufgeloester
#        Pfad nie im Log (S10-06)
#   P-65 core.fileMode=false + fremde getrackte Datei unter DIR chmod +x = FEHLER 'ungestagt', kein Push (S10-07)
#   P-66 DIR '-n' / SRC '-x' = FEHLER "fuehrendes '-'", kein Verzeichnis, kein Push (L10-05)
#   P-67 push.err mit 'https:u:pw@host/y' (ohne '//'): '<scheme>:<cred>@host/y', Kennwort nie im Log (S10-05, L10-06)
#   P-68 F09-GATE-346 Backslash-Paritaet: 'A\\% \thesisumfang' zaehlt NICHT, 'A\% ..' und 'A\\\% ..' zaehlen (C10-01)
#   P-69 F09-GATE-346 \gdef/\xdef/\DeclareRobustCommand/\NewDocumentCommand/\newrobustcmd: nur Definition = FEHLER,
#        Definition + Konsum = gruen (C10-02, L10-01)
#   P-70 F09-GATE-346 '\newcommand{\thesisumfangX}{x}' + Konsum \thesisumfang: Definitionen 1, Konsum 1 (C10-04)
#   P-71 F09-GATE-346 nach FEHLER 0 Reste f09.* unter TMPDIR, Gegenprobe gruen ebenso (C10-06, L10-03)
#   P-72 F09-GATE-346-Skalar unter bash OHNE -e/pipefail: FEHLER-Modul rc != 0 + 'FEHLER: F09', kein Weiterlauf
#        hinter der Klammer; gruenes Modul rc 0 (C10-06b, r11b)
#   r12 (Codex-Lens r11 A/B + Fable-Lens r11, Lead K305, 24.09.2026):
#   P-73 DIR './-n' / './-' und SRC './-n' = FEHLER "fuehrendes '-'" NACH der Normalisierung, kein Verzeichnis (S11-02)
#   P-74 mkdir-Shim: (a) echtes mkdir + SIGTERM an die Shell, (b) mkdir-Kind endet 143 nach der Anlage: je rc 143
#        und 0 Reste unter TMPDIR (S11-01; r11 liess den eigenen leeren Ordner liegen)
#   P-75 F09-GATE-346 Leerraum / Tab / Kommentar+Zeilenwechsel VOR dem Stern: nur Definition = FEHLER, Definition +
#        Konsum = gruen (C11-01)
#   P-76 Textwache F09-Blockkommentar: 'Vorkommen ausserhalb erkannter Definitionsziele' 1x, altes Literal 0x (C11-02)
#   P-77 SIGTERM an die F09-Subshell (git-Shim 'ls-tree'): rc 143, 0 Reste f09.*, Fang-Zeile im Log, Subshell lebt
#        bis zum Ende des Vordergrund-Kindes (Trap vorgemerkt, Marker 'lebt'), kein 'Terminated' (C11-04)
#   P-78 mkdir-Kind immun gegen HUP/INT/TERM (Subshell trap '' + exec): Shim signalisiert sich selbst, ueberlebt,
#        legt an, endet 0 = regulaerer Lauf gruen (S12-01 ii); P-74 (b)/(c): Fremd-/Werkzeug-rc = FEHLER mit
#        rc-Nennung, Kandidat unangetastet (S12-01 i/iii)
#   P-79 F09-GATE-346 Definitionsformen \expandafter (1x/2x), \futurelet, \global\expandafter\let\expandafter:
#        nur Definition = FEHLER, Definition + Konsum = gruen (C12-01)
#   P-80 F09-GATE-346 zwei adjazente Definitionen (\futurelet + \def; \def + \def) = 2/2/0 = FEHLER (C13-01)
#   P-81 F09-GATE-346 adjazente Vorkommen zaehlen je einzeln: 0/2/2, 1/2/1, 1/2/1, 1/3/2 = gruen (C13-01)
#   P-82 F09-GATE-346 Fremdname \thesisumfangX in beiden Stufen ausgeschlossen (0/0/0; 1/2/1) (C13-01)
#   P-83 F09-GATE-346 grep -o rc 2 = FEHLER 'grep Definitions-Token', kein Weiterlauf (C13-01 rc-Klassen)
#   P-84 F09-GATE-346 chardef-Familie / P-85 plain-Allokatoren / P-86 LaTeX-Definierer = Definition (C13-02)
#   P-87 Textwache Script-Kommentare rc-1-Zweig + Restfenster des mkdir-Kindes + REV-r14 (S13-01)
#   r15 (Codex-Lens r14 A/B + Fable-Lens r14 + Owner-Order 455 O-15 (b), Lead K308/K310, 24.09.2026):
#   P-24 (j) 289-Kopie mit anderem Font-Stand (Length1/2/3) bei gleichem Epoch + Fullbanner: 'Font-Stand abweichend
#        (O-15b)' rc=0, kein Byte-Urteil; (k) 288-Bau ohne Length1: FEHLER 'keine eingebetteten Font-Programme' rc=1;
#        (l) 289-Kopie ohne Length1: 'Font-Stand nicht lesbar' rc=0, kein Byte-Urteil (Order 455 / O-15 (b))
#   P-88 F09-GATE-346 laengere Fremd-Definition \thesisumfangXthesisumfang: 0/1/1 gruen bzw. 0/0/0 FEHLER (C14-01)
#   P-89 F09-GATE-346 '@' als Namenszeichen: makeatletter-Form 0/0/0, '\thesisumfang@foo' 1/1/0, Normalfall 1/2/1
#        (C14-02, fail-closed)
#   P-90 F09-GATE-346 Werkdatei 'ges' unschreibbar: FEHLER 'Werkdatei ges nicht schreibbar', kein altes Ergebnis
#        zaehlt (C14-03)
#   P-91 F09-GATE-346 '\font\thesisumfang=cmr10' = Definition + Textwache RESTRISIKO-Kommentar zweigeteilt (C14-04)
#   P-92 Textwache Script-Kommentare S14-01..S14-05 + REV-r15 + YAML-Kommentar L14-03 (Kernel-Allokatoren)
#   P-93 F09-GATE-346 Umlaut direkt am Namen unter LC_ALL=en_US.UTF-8: Vorkommen 2, Konsum 1 (L14-01, LC_ALL=C)
#   P-94 F09-GATE-346 Kernel-/fontspec-Definierer newfontfamily / protected@edef = Definition (L14-04)
#   r16 (Codex-Lens r15 A C15-01..05 + B2 S15-01..05 + B1 S15-07, Fable-Lens r15 L15-01, Lead K312, 24.09.2026):
#   P-24 (r) 289-Kopie mit fremdem Fullbanner UND 288-Bau ohne Length1: 'Toolchain abweichend' VOR dem 288-Font-
#        FEHLER (O-15 (b): Zustand der Kopie -> Font-Stand 288 -> 289 -> Byte-Urteil; rc bleibt 1; C15-02)
#   P-95 DRIFT-WACHE mit Backslash im TMPDIR-Pfad: byte-gleich bleibt gruen (kein falsches DRIFT), Font-Kennung
#        16 Hex (Hash per stdin + Validierung, C15-01)
#   P-96 F09-GATE-346 ':' und '_' als Namenszeichen: ExplSyntax-Form 0/0/0 FEHLER, '\thesisumfang_x' 1/1/0 FEHLER,
#        Normalfall 1/2/1 (C15-04 hochgestuft, fail-closed)
#   P-97 Textwache Script-Kommentare S15-01..S15-05 + S15-07 + REV-r16 + YAML-Kommentare C15-03 + L15-01 (Koppel)
#        und C15-05 (Haupt); die YAML-Textwache L14-03 wanderte aus P-92 hierher (C15-03-Wortlaut)
#   P-98 Textwache r17: Script-Kommentare S16-01..S16-03 + REV-r17 + YAML-Kommentare C16-01/C16-02 (Koppel, F09)
#        und C16-03 (Haupt, DRIFT); nur Kommentare, keine Zaehl-Logik, keine Mutante (Codex-Lens r16 A/B, Fable-
#        Lens r16 L16-01/L16-02, Lead K313/K314)
#
# SELBSTBISS (--selbstbiss): 123 Wegwerf-Mutanten -- Script: M1 Marker
# [skip ci] aus der Merge-Botschaft, M2 Symlink-Pruefung der Zieldatei,
# M3 Remote-Idempotenz-Zweig, M4 .git-Muster, M5 Inhalts-Invariante nach
# git add, M6 Arbeitsbaum-Grenze vor mkdir, M10 https-Pflicht, M11 Duplikat-
# Pruefung, M12 '//'-Faltung; YAML: M7 Eltern-Walk (Quellstand), M8 Epoch-
# Weiche (dreiwertig), M9 Byte-Urteil, M13 shallow-Pruefung (r4), M14
# Fullbanner-Vergleich (r4), M15 Ein-Elter-Regel (r5), M16 Kardinalitaet
# der Kennung (r6, ersetzt 'letzter Treffer'), M17 Walk-Deckel (r5), M18
# sha256sum-FEHLER (r5), M19 CI_PROJECT_DIR-Gate (r5), M20 '[skip ci]'-
# Bedingung (r5), M21 Elternliste-FEHLER (r6), M22 288-Kardinalitaet (r6),
# M23 289-Kardinalitaet (r6), M24 cat-file-FEHLER (r6), M25 pdftex-Nichtleere
# (r6), M26 Fullbanner-Muster r5 (r6), M27 rm -f + latexmk -g (r6), M28
# SCHALTER-346 (r6), M29 Host-Pinnung tags (r6), M30 F09-GATE Kommentar-
# Filter (r6, nur mit Koppelpatch); r7: M31 /ID-Zeile nicht ausgeblendet, M32
# ZUSTAND-Zeile entfernt, M33 Seitenzahl-Regel entfernt (L6-01), M34 288-Epoch-
# Selbstnachweis entfernt (C6-01), M35 F09 Definitions-Filter (C6-02 a, nur mit
# Koppelpatch), M41 needs statt Stufenbarriere (C6-09), M42 main= ohne '||'
# (C6-12); Script r7: M36 Blob-Nachpruefung nach Merge (C6-04), M37 F-06 ohne
# Script-Pfad (C6-05), M38 Instanz-Host-Pruefung (C6-06), M39 --ci-Verweigerung
# (C6-07), M40 SRC unter WURZEL (C6-08), M43 Schalter true|false (C6-13). Sie
# MUESSEN P-03 / P-05 / P-02 / P-16 / P-19 / P-18 / P-27 / P-26 / P-25 / P-28 /
# P-04c / P-09 / P-31 / P-29 / P-30 / P-23 / P-24 / P-24 / P-23 / P-24 / P-23 /
# P-24 / P-23 / P-24 / P-23 / P-23 / P-23 / P-24 / P-24 / P-24 / P-24 / P-24 /
# P-24 / P-24 / P-17 / P-24 / P-24 / P-24 / P-24 / P-24 / P-24 / P-17 / P-24 rot
# machen -- sonst beweist die Probe nichts und endet mit rc=2. Fehlen die
# YAML-Marker (Lead-Patch noch nicht gelandet), entfallen M7-M9/M13-M35/M41/M42/
# M44-M51 LAUT; P-23/P-24 sind dann rot. M30 + M35 + M48-M50 entfallen LAUT, solange
# der Koppelpatch (Block F09-GATE-346) nicht gelandet ist; M32 + M33 + M45 + M46
# entfallen LAUT ohne den Block UMFANG-346 (Koppelpatch r8, L7-01).
# r8 (Lens r7 L7-01/L7-02/L7-03, Codex r7 C7-01..C7-07): M44 /ID-Kardinalitaet nicht
# geprueft (P-24 s7/s8), M45 kanonisches EN-Literal abgewandelt (P-24 s3b), M46 '6
# Paare' auch im Zustand-Zweig (P-24 s3b), M47 shallow-case '*)' still (P-23 c2),
# M48/M49/M50 F09 Praefix-Konsum / newcommand* / def-Leerraum (P-24 p4/p5/p6), M51
# beide rev-parse-Substitutionen leer + Leer-Guard weg (P-23 Gitlink). biss(): ein
# ohne Mutation roter Basisfall = [NICHT BEWERTBAR], nicht in MUT_N (L7-03).
# r10 (Codex r9 S9-01..09, Fable r9 L9-01/L9-04, Codex r9 C9-01/02): M71 S9-03-Wache, M72 S9-07-Wache, M73
# fehler() per echo, M74 --no-filters, M75 core.fileMode, M76 scp-Maske, M77 Maske '[^/@]' zurueck, M78 cat-file-
# Form, M79 ':$dst' zurueck, M80 Kopfzahl 51 (Textwache am Harnisch); M62 = Doppelmutante (Export + S9-03-Klasse),
# M53/M66/M68 auf die r10-Zeilen nachgezogen; YAML: M30 Kommentar-Strip, M35 Zeilen-Join, M70 '\{?' (F09 r10),
# M49/M50 auf die r10-Definitions-ERE ('|let)\*?', beide Leerraum-Klassen) nachgezogen.
# r11 (Codex r10 S10-01..07, Fable r10 L10-05, Codex r10 C10-01/02/04/06): M81 Push-Form 'HEAD:$BRANCH', M82 ohne
# check-ref-format, M83 ':-NA'-Semantik, M84 WERK-Zuweisung VOR mkdir, M85 ohne TMPDIR-Wache/'--', M86 $SRC_K in
# fehler(), M87 ungestagt-Diff ohne core.fileMode, M88 ohne '-*'-Zweig, M89 ohne scheme-Maske; M68 neu = mkdir -p
# (Kollision toleriert); YAML: M90 Strip ohne Paritaet, M91 alte ERE, M92 Definitionsziel ohne Grenze, M93 ohne
# EXIT-Trap im F09-Block; M48/M49 auf die r11-Zeilen nachgezogen; r11b: M94 Subshell-rc-Fang hinter der Klammer.
# r12 (Codex r11 S11-01/S11-02, C11-01/C11-02, Lead-Hebung C11-04): M95 '-*' nach der Normalisierung entfernt, M96
# alte Signal-Traps (exit statt vormerken) waehrend der Anlage, M97 rmdir-Zweig entfernt; YAML: M98 ERE-Suffix ohne
# fuehrenden Leerraum, M99 alter Blockkommentar, M100 ohne HUP/INT/TERM-Traps in der Subshell; M68/M84 auf die
# r12-Anlagezeile und M49 auf die r12-ERE-Zeile nachgezogen, P-48/P-62 nachgezogen.
# r13 (Codex r12 S12-01/C12-01, Lead K306, A-7): M97 neu = Loesch-Zweig (rmdir) im '*'-Zweig zurueck, M101
# Immunitaets-Trap des mkdir-Kindes entfernt, M102 '*'-Zweig setzt WERK; YAML: M103 expandafter-Erweiterung der
# Definitions-ERE entfernt, M104 futurelet aus der let-Familie entfernt; M68/M84 auf die r13-Anlagezeile (Subshell)
# und M49/M98 auf die r13-ERE-Zeile nachgezogen (literal per awk, ersetze_literal), P-48 nachgezogen; ok()/rot()
# per printf (A-7).
# r14 (Codex r13 C13-01/C13-02 + Lead K307): YAML: M105 Stufe 1 der Definitionen zurueck auf die verbrauchende
# Wortgrenze, M106 dito Vorkommen, M107 Stufe-2-Filter ohne Endanker (Fremdname zaehlt), M108 Pipe statt zwei
# Stufen (rc 2 verschluckt), M109 chardef-Familie weg, M110 plain-Allokatoren weg, M111 DeclareTextCommand/
# DeclareMathOperator/CommandCopy weg, M112 DeclarePairedDelimiter weg; M48/M92 auf die Stufe-2-Zeilen, M104 auf
# 'futurelet' der Primitiv-Liste, M91 auf die r14-Formenliste nachgezogen (literal per ersetze_literal).
# r15 (Codex r14 C14-01..04, Fable r14 L14-01/L14-04, Order 455 O-15 (b), Lead K308/K310): YAML: M113 Stufe-2-Filter
# der Definitionen ohne Backslash (r14-Form, Fremd-Definition verschluckt Konsum), M114 Token-Klasse ohne '@', M115
# Truncation der Werkdateien entfernt (alter Inhalt bleibt), M116 'font' aus der Primitiv-Liste, M117 Font-Stand-
# Vergleich entfernt, M118 fn-0-Wache am 288-Bau entfernt, M119 LC_ALL=C an beiden Stufe-1-Extraktionen entfernt,
# M120 Kernel-/fontspec-Definierer aus der ERE; M92/M105/M106/M108 auf die r15-Zeilen nachgezogen; alle P-24-Fakes
# tragen Length1/2/3 (Font-Stand, 3 Zeilen je Fassung); m119 entfaellt LAUT ohne Locale en_US.utf8.
# r16 (Codex r15 C15-01/C15-02/C15-04, Lead K312): YAML: M121 Font-Stand-Hash mit Dateiname + ohne 16-Hex-Validierung
# + Byte-Urteil mit Dateiname (r15-Form; GNU sha256sum escapt '\' im TMPDIR-Pfad), M122 Font-Stand des 288-Baus VOR
# dem Fullbanner-Vergleich (r15-Reihenfolge), M123 Token-Klasse ohne ':_' (r15-Form); M105/M106/M108/M114 auf die
# r16-Klasse '[A-Za-z@:_]*' nachgezogen; P-92 traegt nur noch den Script-Teil, die YAML-Textwachen liegen in P-97.
# r17 (Codex r16 C16-01..03 + S16-01..03, Fable r16 L16-01/L16-02, Lead K313/K314): nur Textwache P-98 (6 Kommentar-
# Fixes, 0 Code), 0 neue Mutanten -- die Kommentar-Literale sind keine Beiss-Gegenstaende.
#
# AUFRUF:
#   sh ci/tests/test_thesis_pdf_export.sh               # alle Faelle
#   sh ci/tests/test_thesis_pdf_export.sh --selbstbiss  # Faelle + Mutationsbeweis
#
# ENV:
#   COMDARE_SKRIPT   Pfad zum zu pruefenden Script (Default: ../thesis_pdf_export.sh
#                    relativ zu dieser Datei). Fuer die Rot-Messung am alten Stand.
#   TMPDIR           Wurzel der Wegwerf-Repos (Default /tmp); Pfad ohne Leerzeichen.
#   bash             Runner-Shell (docs.gitlab.com/runner/shells) fuer P-23/P-24: die YAML-Bloecke laufen
#                    dort wie im Job (bash -e -o pipefail); fehlt bash, sind P-23/P-24 rot.
#   COMDARE_CI_YML   .gitlab-ci.yml fuer P-17 (Default: ../../.gitlab-ci.yml relativ zu
#                    dieser Datei). Fuer die Gruen-Messung an einer gepatchten Kopie.
#   COMDARE_SKRIPT und COMDARE_CI_YML sind in CI (CI/GITLAB_CI gesetzt) VERWEIGERT
#   (rc=2): ein Variablen-Setzer koennte die Probe sonst still auf ein fremdes
#   Script oder eine fremde YAML lenken -- dieselbe Klasse wie F-02 (P-22 misst es).
#
# lauf() haengt LAUF_ARGS (z. B. --ci, P-31) an den Script-Aufruf; Default leer.
# EXIT: 0 = alle Faelle gruen (und, mit --selbstbiss, alle Mutanten rot)
#       1 = mindestens ein Fall rot (literale Ausgabe im Protokoll)
#       2 = die Probe konnte nicht pruefen (Script fehlt, Wegwerf-Repo nicht
#           baubar, Mutante biss nicht) -- ausdruecklich KEIN Gruen.
#
# TESTKRITIK, was diese Probe NICHT deckt:
#   - GitLab-Serverseite (Push-Option ci.skip wirkt, _bot_-Regel, protected
#     Variablen) -- das sind KONFIG-Posten K-1..K-8 der Bewertung, hier nur
#     das Client-Verhalten gegen ein git-Bare-Repo.
#   - Netz-/TLS-/Rechte-Fehler des echten Remotes; P-09/P-11 zeigen nur, dass
#     solche Fehler LAUT und ohne Credential im Log enden.
#   - Byte-Gleichheit ECHTER PDFs zur Thesis-Seite (I-06/L1-04): P-23/P-24 fahren
#     die YAML-Bloecke mit Fake-PDFs (CreationDate = Epoch) -- die Toolchain-
#     Gleichheit 288/289 zeigt erst der scharfe Lauf am Kurz-Stand (O-6).
#     P-24 stellt dem Block einen Wegwerf-pdftex (Versionszeile) voran: die
#     Nachweiszeile ist geprueft, die ECHTE pdftex-Installation des Runners
#     ist Konfig-Posten (thesis:pdf prueft latexmk/pdflatex selbst).
#   - P-17 liest die ECHTE .gitlab-ci.yml: solange der Job test:thesis-pdf-export-
#     probe dort fehlt (YAML = Lead-only), ist P-17 rot -- gewollt (T-7).
#
# POSIX-sh (die CI ruft `sh`, das ist hier dash), ASCII-only, kein bash-ismus;
# GNU-Werkzeuge wie im Script selbst (readlink -f, mktemp, head -c).
# =============================================================================
set -u

HIER=$(cd "$(dirname "$0")" && pwd -P) || { echo "ABBRUCH: eigener Pfad nicht bestimmbar"; exit 2; }
if [ -n "${CI:-}${GITLAB_CI:-}" ] && [ -n "${COMDARE_SKRIPT:-}${COMDARE_CI_YML:-}" ]; then
    echo "ABBRUCH: COMDARE_SKRIPT/COMDARE_CI_YML sind Overrides der Probe und werden in CI verweigert (CI/GITLAB_CI)"
    exit 2
fi
SKRIPT="${COMDARE_SKRIPT:-$HIER/../thesis_pdf_export.sh}"
SKRIPT=$(readlink -f "$SKRIPT") || { echo "ABBRUCH: readlink -f auf das Script fehlgeschlagen"; exit 2; }
[ -f "$SKRIPT" ] || { echo "ABBRUCH: Script '$SKRIPT' fehlt"; exit 2; }
CI_YML="${COMDARE_CI_YML:-$HIER/../../.gitlab-ci.yml}"
CI_YML=$(readlink -f "$CI_YML") || { echo "ABBRUCH: readlink -f auf die .gitlab-ci.yml fehlgeschlagen"; exit 2; }
[ -f "$CI_YML" ] || { echo "ABBRUCH: .gitlab-ci.yml '$CI_YML' fehlt"; exit 2; }
SELBST="$HIER/$(basename "$0")"
SELBSTBISS=0
for a in "$@"; do
    case "$a" in
        --selbstbiss) SELBSTBISS=1 ;;
        *) echo "ABBRUCH: unbekanntes Argument '$a'"; exit 2 ;;
    esac
done
command -v git >/dev/null 2>&1 || { echo "ABBRUCH: git fehlt"; exit 2; }

T=$(mktemp -d "${TMPDIR:-/tmp}/tpe_probe.XXXXXX") || { echo "ABBRUCH: mktemp -d fehlgeschlagen"; exit 2; }
trap 'rm -rf "$T"' EXIT INT TERM
case "$T" in *' '*) echo "ABBRUCH: TMPDIR '$T' enthaelt Leerzeichen"; exit 2 ;; esac

# Hermetische git-Umgebung fuer die EIGENEN Aufrufe der Probe (das Script bekommt
# seine Umgebung explizit per env -i in lauf()).
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
export GIT_AUTHOR_NAME=probe GIT_AUTHOR_EMAIL=probe@ci.comdare.local
export GIT_COMMITTER_NAME=probe GIT_COMMITTER_EMAIL=probe@ci.comdare.local

GITLINK_A=1111111111111111111111111111111111111111
GITLINK_B=2222222222222222222222222222222222222222
KOEDER=PROBE-TOKEN-NIE-ECHT-0815
MUT_N_SKRIPT=57; MUT_N_YAML=66   # r16 (L9-01): Kopfkommentar == Summe (P-57)
LOCALE_EN=$(locale -a 2>/dev/null | grep -c -i 'en_US.utf8')   # r15 (L14-01): Vorbedingung P-93 / m119
GRUEN_N=0; ROT_N=0; ROT_LISTE=""; FEHL=0; LAUF_N=0; LAUF_ARGS=""
BARE=""; BASE=""

echo "============================================================================="
echo " BISSPROBE thesis_pdf_export -- Script: $SKRIPT"
echo " Wegwerf-Wurzel: $T"
echo " YAML (P-17):    $CI_YML"
echo "============================================================================="

ok()  { printf '%s\n' "    [OK]  $*"; }   # r13 (A-7): printf statt echo (dash-echo deutete '\t' in Meldungen)
rot() { printf '%s\n' "    [ROT] $*"; FEHL=$((FEHL+1)); }
erw_rc() { if [ "$1" -eq "$2" ]; then ok "rc=$1 (erwartet $2)"; else rot "rc=$1 (erwartet $2)"; fi; }
erw_rc_ne0() { if [ "$1" -ne 0 ]; then ok "rc=$1 (erwartet != 0)"; else rot "rc=$1 (erwartet != 0)"; fi; }   # r13
erw_text() {
    if grep -qF -- "$2" "$1"; then ok "Ausgabe enthaelt '$2'"; else rot "Ausgabe enthaelt NICHT '$2'"; fi
}
erw_kein_text() {
    if grep -qF -- "$2" "$1"; then rot "Ausgabe enthaelt '$2' (verboten)"; else ok "Ausgabe frei von '$2'"; fi
}
erw_gleich() { if [ "$1" = "$2" ]; then ok "$3: $1"; else rot "$3: '$1' (erwartet '$2')"; fi; }
zeige() { sed 's/^/      > /' "$1"; }
ersetze_literal() { # r13: $1 = Datei, $2 = alter Text, $3 = neuer Text (beide LITERAL via ENVIRON, keine Escapes);
    # ersetzt je Zeile das erste Vorkommen -> stdout (Mutanten an ERE-Zeilen, deren sed-Escapes unlesbar waeren)
    ALT="$2" NEU="$3" awk 'BEGIN { a = ENVIRON["ALT"]; b = ENVIRON["NEU"] }
        { i = index($0, a); if (i > 0) $0 = substr($0, 1, i - 1) b substr($0, i + length(a)); print }' "$1"
}

# Wegwerf-Remote: Seed-Repo (README, .gitlab-ci.yml, Gitlink thesis/diplomarbeit)
# -> Bare mit advertisePushOptions. Setzt BARE und BASE.
baue_seed() {
    d="$1"; mkdir -p "$d" || return 2
    git init -q "$d/seed" || return 2
    git -C "$d/seed" symbolic-ref HEAD refs/heads/development || return 2
    echo "seed" > "$d/seed/README.md"
    printf 'stages: [x]\n' > "$d/seed/.gitlab-ci.yml"
    git -C "$d/seed" add README.md .gitlab-ci.yml || return 2
    git -C "$d/seed" update-index --add --cacheinfo "160000,$GITLINK_A,thesis/diplomarbeit" || return 2
    git -C "$d/seed" commit -q -m "seed (Gitlink-Platzhalter)" || return 2
    BASE=$(git -C "$d/seed" rev-parse HEAD) || return 2
    git init -q --bare "$d/bare.git" || return 2
    git -C "$d/bare.git" symbolic-ref HEAD refs/heads/development || return 2
    git -C "$d/bare.git" config receive.advertisePushOptions true || return 2
    git -C "$d/seed" push -q "$d/bare.git" development || return 2
    BARE="$d/bare.git"
}
tip() { git -C "$BARE" rev-parse refs/heads/development; }
# Klon detached auf einem Pipeline-Stand (wie GIT_STRATEGY fetch im Runner).
klone() {
    git clone -q "$BARE" "$1" || return 2
    git -C "$1" checkout -q --detach "$2" || return 2
    mkdir -p "$1/thesis/diplomarbeit" || return 2
}
lege_pdfs() { # $1 = Klon, $2 = Versionsmarke, [$3 = Liste]
    for f in ${3:-de-lang en-lang de-kurz en-kurz}; do
        printf '%%PDF-1.4\n%% fassung %s %s\n%%%%EOF\n' "$f" "$2" > "$1/thesis/diplomarbeit/diplomarbeit-$f.pdf"
    done
}
mensch() { # $1 = Klonpfad, $2 = Text: menschlicher Commit auf development, gepusht
    git clone -q "$BARE" "$1" || return 2
    echo "$2" >> "$1/README.md"
    git -C "$1" commit -q -am "mensch $2" || return 2
    git -C "$1" push -q "$BARE" development || return 2
}
gitlink_bewegen() { # $1 = Klonpfad: Gitlink thesis/diplomarbeit auf GITLINK_B, gepusht
    git clone -q "$BARE" "$1" || return 2
    git -C "$1" update-index --add --cacheinfo "160000,$GITLINK_B,thesis/diplomarbeit" || return 2
    git -C "$1" commit -q -m "thesis: Gitlink bewegt" || return 2
    git -C "$1" push -q "$BARE" development || return 2
}
script_bewegen() { # $1 = Klonpfad: ci/thesis_pdf_export.sh im Remote angelegt, gepusht (C6-05, r7)
    git clone -q "$BARE" "$1" || return 2
    mkdir -p "$1/ci" && echo "# export-script bewegt" >> "$1/ci/thesis_pdf_export.sh" || return 2
    git -C "$1" add ci/thesis_pdf_export.sh && git -C "$1" commit -q -m "ci: Export-Script bewegt" || return 2
    git -C "$1" push -q "$BARE" development || return 2
}
mensch_pdf() { # $1 = Klonpfad, $2 = Fassung, $3 = Marke: menschlicher Commit auf EINE exportierte Fassung, gepusht
    git clone -q "$BARE" "$1" || return 2
    printf '%%PDF-1.4\n%% fassung %s %s\n%%%%EOF\n' "$2" "$3" > "$1/docs/diplomarbeit/diplomarbeit-$2.pdf" || return 2
    git -C "$1" commit -q -am "mensch $2 $3" || return 2
    git -C "$1" push -q "$BARE" development || return 2
}
rezept_bewegen() { # $1 = Klonpfad: .gitlab-ci.yml geaendert, gepusht
    git clone -q "$BARE" "$1" || return 2
    echo "# rezept bewegt" >> "$1/.gitlab-ci.yml"
    git -C "$1" commit -q -am "ci: Rezept bewegt" || return 2
    git -C "$1" push -q "$BARE" development || return 2
}
# Das Script in LEERER Umgebung fahren: $1 Klon, $2 Script, $3 Logdatei, $4 Pipeline-SHA,
# danach beliebige K=V-Paare. CI/GITLAB_CI sind damit bewusst NICHT gesetzt (s. Kopf).
# Jeder Lauf bekommt einen EIGENEN Commit-Zeitstempel: zwei Export-Commits mit gleichem Baum,
# Elter und Text in derselben Sekunde waeren SHA-gleich, und git meldete den zweiten Push als
# "up-to-date" -- P-02 saehe den Remote-Idempotenz-Zweig dann nie (Befund beim ersten Lauf).
lauf() {
    _k="$1"; _s="$2"; _l="$3"; _p="$4"; shift 4
    _kurz=$(git -C "$_k" rev-parse --short "$_p") || return 2
    LAUF_N=$((LAUF_N+1)); _datum="$((1758600000 + LAUF_N)) +0000"
    ( cd "$_k" && env -i PATH="$PATH" HOME="$HOME" TMPDIR="$T" GIT_CONFIG_GLOBAL=/dev/null \
        GIT_CONFIG_NOSYSTEM=1 GIT_COMMITTER_DATE="$_datum" GIT_AUTHOR_DATE="$_datum" \
        CI_COMMIT_BRANCH=development CI_COMMIT_SHA="$_p" CI_COMMIT_SHORT_SHA="$_kurz" \
        CI_PIPELINE_ID=4711 "$@" sh "$_s" $LAUF_ARGS ) > "$_l" 2>&1
}

# --------------------------------------------------------------------------- Faelle
fall_P01() {
    s="$1"; d="$T/P01"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 0; erw_text "$d/out" "TESTHAKEN AKTIV"; erw_text "$d/out" "PUSH OK (ci.skip)"
    t=$(tip); anz=$(git -C "$BARE" rev-list --count "$BASE..$t"); erw_gleich "$anz" 1 "neue Commits im Bare"
    n=$(git -C "$BARE" ls-tree --name-only "$t" docs/diplomarbeit/ | grep -c 'diplomarbeit-.*\.pdf$')
    erw_gleich "$n" 4 "PDF-Dateien im Bare-Tip"
    m=$(git -C "$BARE" log -1 --format=%B "$t" | grep -c 'skip ci'); erw_gleich "$m" 1 "[skip ci] im Export-Commit"
}
fall_P02() {
    s="$1"; d="$T/P02"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/workA" "$BASE" || { rot "Klon A nicht baubar"; return; }; lege_pdfs "$d/workA" v1
    lauf "$d/workA" "$s" "$d/outA" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" \
        || { rot "Vorlauf-Export (v1) fehlgeschlagen"; zeige "$d/outA"; return; }
    t1=$(tip); klone "$d/workB" "$BASE" || { rot "Klon B nicht baubar"; return; }; lege_pdfs "$d/workB" v1
    lauf "$d/workB" "$s" "$d/out" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 0; erw_text "$d/out" "UNVERAENDERT (remote)"
    t2=$(tip); erw_gleich "$t2" "$t1" "Bare-Tip unveraendert (kein Merge, kein Push)"
}
# Vorlauf fuer P-03/P-04: Export v1 -> Mensch-Commit H1 (Pipeline-Stand) -> Klon B mit v2-PDFs.
vorlauf_bewegt() {
    s="$1"; d="$2"; baue_seed "$d" || return 2
    klone "$d/workA" "$BASE" || return 2; lege_pdfs "$d/workA" v1
    lauf "$d/workA" "$s" "$d/outA" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" || return 2
    mensch "$d/h1" "h1" || return 2
    H1=$(tip)
    klone "$d/workB" "$H1" || return 2; lege_pdfs "$d/workB" v2
}
fall_P03() {
    s="$1"; d="$T/P03"; vorlauf_bewegt "$s" "$d" || { rot "Vorlauf (Export v1 + Mensch h1) fehlgeschlagen"; return; }
    mensch "$d/h2" "h2" || { rot "Mensch-Commit h2 fehlgeschlagen"; return; }; H2=$(tip)
    lauf "$d/workB" "$s" "$d/out" "$H1" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 0; erw_text "$d/out" "Push abgelehnt (Versuch 1)"; erw_text "$d/out" "PUSH OK (ci.skip)"
    t=$(tip); p=$(git -C "$BARE" rev-list --parents -n 1 "$t" | wc -w)
    erw_gleich "$p" 3 "Tip ist Merge-Commit (2 Eltern)"
    m=$(git -C "$BARE" log -1 --format=%B "$t" | grep -c 'skip ci')
    erw_gleich "$m" 1 "[skip ci] in der Merge-Botschaft"
    v=$(git -C "$BARE" show "$t:docs/diplomarbeit/diplomarbeit-de-lang.pdf" | grep -c ' v2$')
    erw_gleich "$v" 1 "PDF v2 im Tip"
    if git -C "$BARE" merge-base --is-ancestor "$H2" "$t"; then
        ok "Mensch-Commit h2 im Tip enthalten"
    else
        rot "Mensch-Commit h2 nicht im Tip"
    fi
}
fall_P04a() {
    s="$1"; d="$T/P04a"; vorlauf_bewegt "$s" "$d" || { rot "Vorlauf fehlgeschlagen"; return; }
    gitlink_bewegen "$d/h2" || { rot "Gitlink-Commit fehlgeschlagen"; return; }; H2=$(tip)
    lauf "$d/workB" "$s" "$d/out" "$H1" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 0; erw_text "$d/out" "UEBERHOLT"; erw_kein_text "$d/out" "PUSH OK"
    t=$(tip); erw_gleich "$t" "$H2" "Bare-Tip unveraendert (kein Merge alter PDFs auf neuen Gitlink)"
}
fall_P04b() {
    s="$1"; d="$T/P04b"; vorlauf_bewegt "$s" "$d" || { rot "Vorlauf fehlgeschlagen"; return; }
    rezept_bewegen "$d/h2" || { rot "Rezept-Commit fehlgeschlagen"; return; }; H2=$(tip)
    lauf "$d/workB" "$s" "$d/out" "$H1" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 0; erw_text "$d/out" "UEBERHOLT"; erw_kein_text "$d/out" "PUSH OK"
    t=$(tip); erw_gleich "$t" "$H2" "Bare-Tip unveraendert (kein Merge alter PDFs auf neues Rezept)"
}
fall_P04c() { # C6-05 (r7): Branch bewegt MIT dem Export-Script -> UEBERHOLT rc=0 (F-06 deckt das Rezept-Script)
    s="$1"; d="$T/P04c"; vorlauf_bewegt "$s" "$d" || { rot "Vorlauf fehlgeschlagen"; return; }
    script_bewegen "$d/h2" || { rot "Script-Commit fehlgeschlagen"; return; }; H2=$(tip)
    lauf "$d/workB" "$s" "$d/out" "$H1" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 0; erw_text "$d/out" "UEBERHOLT"; erw_kein_text "$d/out" "PUSH OK"
    t=$(tip); erw_gleich "$t" "$H2" "Bare-Tip unveraendert (kein Merge alter PDFs auf bewegtes Export-Script)"
}
fall_P05() {
    s="$1"; d="$T/P05"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    git clone -q "$BARE" "$d/prep" || { rot "Klon prep nicht baubar"; return; }
    mkdir -p "$d/prep/docs/diplomarbeit"
    ln -s ../../../aussen.txt "$d/prep/docs/diplomarbeit/diplomarbeit-de-lang.pdf"
    git -C "$d/prep" add docs/diplomarbeit && git -C "$d/prep" commit -q -m "symlink als zieldatei" \
        && git -C "$d/prep" push -q "$BARE" development || { rot "Symlink-Commit fehlgeschlagen"; return; }
    S=$(tip); echo "AUSSEN" > "$d/aussen.txt"
    klone "$d/work" "$S" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out" "$S" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 1; erw_text "$d/out" "Symlink (Zieldatei verboten)"
    inhalt=$(cat "$d/aussen.txt"); erw_gleich "$inhalt" "AUSSEN" "Datei ausserhalb des Ziels unveraendert"
    t=$(tip); erw_gleich "$t" "$S" "Bare-Tip unveraendert"
}
fall_P06() {
    s="$1"; d="$T/P06"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_FASSUNGEN='*'; rc=$?
    zeige "$d/out"; erw_rc "$rc" 1; erw_text "$d/out" "COMDARE_THESIS_PDF_FASSUNGEN: Eintrag 1: unzulaessiges Zeichen"
}
fall_P07() {
    s="$1"; d="$T/P07"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_FASSUNGEN='de-lang foo'
    rc=$?; zeige "$d/out"; erw_rc "$rc" 1; erw_text "$d/out" "COMDARE_THESIS_PDF_FASSUNGEN: Eintrag 2 unbekannt"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P08() {
    s="$1"; d="$T/P08"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_EXPORT=false; rc=$?
    zeige "$d/out"; erw_rc "$rc" 0; erw_text "$d/out" "INERT"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert (0 Commits)"
}
fall_P09() { # C6-06 (r7): fremder Server-Host -> FEHLER VOR jedem Transport; Token in 0 Zeilen (F-01 bleibt)
    s="$1"; d="$T/P09"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out" "$BASE" CI_SERVER_URL=https://127.0.0.1:9 CI_SERVER_HOST=127.0.0.1 \
        CI_PROJECT_ID=288 CI_PROJECT_PATH=gruppe/projekt COMDARE_WRITEBACK_USER=ciuser \
        COMDARE_WRITEBACK_TOKEN="$KOEDER" GIT_TRACE=1; rc=$?
    # Das Protokoll wird NICHT gezeigt (Trace waere lang); die Zaehlung ist der Beleg. Am r6-Script lief der
    # Transport an 127.0.0.1:9 (remote-https im Trace); r7 reisst VOR dem Transport an der Instanz-Pruefung.
    erw_rc "$rc" 1; erw_text "$d/out" "nicht die Instanz"
    erw_kein_text "$d/out" "remote-https"   # C6-06: kein Transport-Aufruf an das fremde Ziel
    erw_kein_text "$d/out" "$KOEDER"        # F-01: Token in 0 Zeilen (argv/Fehlertext)
    erw_kein_text "$d/out" "ciuser:"        # F-01: kein user:pass in einer URL
    zl=$(grep -c 'remote-https' "$d/out"); echo "      Trace-Zeilen mit remote-https: $zl"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P09c() { # C6-06 (r7): userinfo / Query in CI_SERVER_URL und fremde CI_PROJECT_ID -> FEHLER vor dem Transport
    s="$1"; d="$T/P09c"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out1" "$BASE" CI_SERVER_URL=https://ciuser@127.0.0.1:9 CI_SERVER_HOST=127.0.0.1 \
        CI_PROJECT_ID=288 CI_PROJECT_PATH=gruppe/projekt COMDARE_WRITEBACK_USER=ciuser \
        COMDARE_WRITEBACK_TOKEN="$KOEDER"; rc=$?; zeige "$d/out1"
    erw_rc "$rc" 1; erw_text "$d/out1" "userinfo, Query oder Fragment"; erw_kein_text "$d/out1" "$KOEDER"
    lauf "$d/work" "$s" "$d/out2" "$BASE" CI_SERVER_URL='https://127.0.0.1:9/?x=1' CI_SERVER_HOST=127.0.0.1 \
        CI_PROJECT_ID=288 CI_PROJECT_PATH=gruppe/projekt COMDARE_WRITEBACK_USER=ciuser \
        COMDARE_WRITEBACK_TOKEN="$KOEDER"; rc=$?; zeige "$d/out2"
    erw_rc "$rc" 1; erw_text "$d/out2" "userinfo, Query oder Fragment"
    lauf "$d/work" "$s" "$d/out3" "$BASE" CI_SERVER_URL=https://127.0.0.1:9 CI_SERVER_HOST=127.0.0.1 \
        CI_PROJECT_ID=289 CI_PROJECT_PATH=gruppe/projekt COMDARE_WRITEBACK_USER=ciuser \
        COMDARE_WRITEBACK_TOKEN="$KOEDER"; rc=$?; zeige "$d/out3"
    erw_rc "$rc" 1; erw_text "$d/out3" "nicht das Projekt 288"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P10() {
    s="$1"; d="$T/P10"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out1" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" CI=true GITLAB_CI=true; rc=$?
    zeige "$d/out1"; erw_rc "$rc" 1; erw_text "$d/out1" "in CI verweigert"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert (Override unter CI wirkungslos)"
    lauf "$d/work" "$s" "$d/out2" "$BASE" COMDARE_THESIS_PDF_REMOTE=https://127.0.0.1:9/x.git; rc=$?
    zeige "$d/out2"; erw_rc "$rc" 1; erw_text "$d/out2" "absoluter lokaler Pfad"
    lauf "$d/work" "$s" "$d/out3" "$BASE" COMDARE_THESIS_PDF_REMOTE="$d/work"; rc=$?
    zeige "$d/out3"; erw_rc "$rc" 1; erw_text "$d/out3" "kein lokales Bare-Repo"
}
fall_P11() {
    s="$1"; d="$T/P11"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    git -C "$BARE" config receive.advertisePushOptions false
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 1; erw_text "$d/out" "push options"; erw_text "$d/out" "kein non-ff-Race"
    erw_kein_text "$d/out" "weitergelaufen?"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P12() {
    s="$1"; d="$T/P12"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    rm -f "$d/work/thesis/diplomarbeit/diplomarbeit-de-kurz.pdf"
    lauf "$d/work" "$s" "$d/out1" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out1"
    erw_rc "$rc" 1; erw_text "$d/out1" "fehlt oder ist leer"
    lege_pdfs "$d/work" v1; echo "hallo" > "$d/work/thesis/diplomarbeit/diplomarbeit-en-kurz.pdf"
    lauf "$d/work" "$s" "$d/out2" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out2"
    erw_rc "$rc" 1; erw_text "$d/out2" "kein PDF (Header)"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P13() {
    s="$1"; d="$T/P13"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out1" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_DIR="$T/aussen"; rc=$?
    zeige "$d/out1"; erw_rc "$rc" 1; erw_text "$d/out1" "relativer Pfad ohne '..'"
    lauf "$d/work" "$s" "$d/out2" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_DIR="docs/../../x"; rc=$?
    zeige "$d/out2"; erw_rc "$rc" 1; erw_text "$d/out2" "relativer Pfad ohne '..'"
    lauf "$d/work" "$s" "$d/out3" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" \
        COMDARE_THESIS_PDF_DIR="thesis/diplomarbeit/"
    rc=$?; zeige "$d/out3"; erw_rc "$rc" 1; erw_text "$d/out3" "Ziel und Quelle identisch"
    [ -e "$T/aussen" ] && rot "Verzeichnis ausserhalb des Baums wurde angelegt" || ok "nichts ausserhalb angelegt"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P14() {
    s="$1"; d="$T/P14"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    mensch "$d/h1" "h1" || { rot "Mensch-Commit fehlgeschlagen"; return; }; H1=$(tip)
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out" "$H1" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 1; erw_text "$d/out" "CI_COMMIT_SHA"
    t=$(tip); erw_gleich "$t" "$H1" "Bare-Tip unveraendert (kein Export von fremdem Stand)"
}
fall_P15() {
    s="$1"; d="$T/P15"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    echo "fremd" > "$d/work/fremd.txt"; git -C "$d/work" add fremd.txt
    lauf "$d/work" "$s" "$d/out" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 1; erw_text "$d/out" "fremde Pfad(e) im Index"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert (fremder Pfad nie gepusht)"
}

# --------------------------------------------------------------------------- Faelle r2 (Lens r1)
fall_P09b() { # L1-05: der Askpass-Helfer des Scripts liefert per git credential fill (netzfrei, host=example.invalid)
    s="$1"; d="$T/P09b"; mkdir -p "$d"
    sed -n "/<<'ASK'\$/,/^ASK\$/p" "$s" | sed '1d;$d' > "$d/askpass.sh"
    z=$(awk 'END{print NR}' "$d/askpass.sh"); echo "      Helfer-Zeilen aus dem Script: $z"
    if [ "$z" -lt 5 ]; then
        rot "Askpass-Helfer im Script nicht gefunden ($z Zeilen zwischen <<'ASK' und ASK)"; return
    fi
    chmod 0700 "$d/askpass.sh"
    printf 'protocol=https\nhost=example.invalid\n\n' | env -i PATH="$PATH" HOME="$HOME" GIT_CONFIG_GLOBAL=/dev/null \
        GIT_CONFIG_NOSYSTEM=1 GIT_TERMINAL_PROMPT=0 COMDARE_WRITEBACK_USER=botuser COMDARE_WRITEBACK_TOKEN="$KOEDER" \
        GIT_ASKPASS="$d/askpass.sh" git -c credential.helper= credential fill > "$d/out" 2>&1; rc=$?
    erw_rc "$rc" 0; erw_text "$d/out" "username=botuser"; erw_text "$d/out" "password=$KOEDER"
    printf 'protocol=https\nhost=example.invalid\n\n' | env -i PATH="$PATH" HOME="$HOME" GIT_CONFIG_GLOBAL=/dev/null \
        GIT_CONFIG_NOSYSTEM=1 GIT_TERMINAL_PROMPT=0 git -c credential.helper= credential fill > "$d/out2" 2>&1; rc=$?
    erw_rc "$rc" 128; erw_text "$d/out2" "terminal prompts disabled"   # Gegenprobe: ohne Helfer laut, nie still
}
fall_P16() { # L1-01: .git-Komponente im Ziel -> FEHLER, nichts unter .git/ geschrieben, Bare unveraendert
    s="$1"; d="$T/P16"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    [ -d "$d/work/.git" ] || { rot "Klon hat kein .git-Verzeichnis (Nenner)"; return; }
    for ziel in .git/x docs/.git/x .git; do
        lauf "$d/work" "$s" "$d/out" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_DIR="$ziel"; rc=$?
        zeige "$d/out"; erw_rc "$rc" 1; erw_text "$d/out" "traegt eine .git-Komponente"
    done
    n=$(find "$d/work/.git" -name 'diplomarbeit-*.pdf' | wc -l); erw_gleich "$n" 0 "PDFs unter .git/ geschrieben"
    if [ -e "$d/work/docs/.git" ]; then rot "docs/.git wurde angelegt"; else ok "docs/.git nicht angelegt"; fi
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
AUFRUF='sh ci/tests/test_thesis_pdf_export.sh'
JOB='test:thesis-pdf-export-probe'
zaehle_aufrufe() { grep -c -F -- "$AUFRUF" "$1" || true; }
zaehle_jobkopf() { grep -c -- "^$JOB:" "$1" || true; }
# Der Job-Block endet an der ersten nicht eingerueckten, nicht leeren Zeile (Vorlage K9: sonst zaehlt der
# Kommentarblock des NAECHSTEN Jobs mit).
zaehle_allow() {
    awk -v job="$JOB:" 'substr($0, 1, length(job)) == job { in_job = 1; next }
        in_job && /^[^ ]/ && NF > 0 { in_job = 0 }
        in_job && /allow_failure/ { n++ }
        END { print n + 0 }' "$1"
}
zaehle_tags() { # $1 = YAML, $2 = Job: tags-Zeile(n) im Block des Jobs ohne Kommentar (r6, C4-11)
    awk -v job="$2:" 'substr($0, 1, length(job)) == job { in_job = 1; next }
        in_job && /^[^ ]/ && NF > 0 { in_job = 0 }
        in_job && /^  tags:/ { sub(/ *#.*$/, ""); sub(/^  tags: */, ""); print }' "$1"
}
TAGS_SOLL='[prod, baremetal, amd]'
zaehle_zeile() { # $1 = YAML, $2 = Job, $3 = Zeilen-Regex: Treffer im Block des Jobs (r7, C6-07/C6-09)
    awk -v job="$2:" -v re="$3" 'substr($0, 1, length(job)) == job { in_job = 1; next }
        in_job && /^[^ ]/ && NF > 0 { in_job = 0 }
        in_job && $0 ~ re { n++ }
        END { print n + 0 }' "$1"
}
EXPORT_JOB='thesis:pdf-export'
fall_P17() { # T-7 (L1-14, Vorlage K9): eigene Registrierung + kein allow_failure im eigenen Job-Block, Koeder zuerst
    d="$T/P17"; mkdir -p "$d"
    {
        printf 'x:\n  script:\n    - echo x\n\n'
        printf 'thesis:pdf:\n  tags: [baremetal]   # koeder\n  script: [echo t]\n\n'
        printf '%s:\n  needs: [{job: "thesis:pdf"}]\n  script:\n    - sh ci/thesis_pdf_export.sh\n\n' "$EXPORT_JOB"
        printf '%s:\n  stage: test\n  allow_failure: true\n  script:\n    - %s --selbstbiss\n\n' "$JOB" "$AUFRUF"
        printf '# allow_failure in Prosa\ny:\n  script: [echo y]\n'
    } > "$d/koeder.yml"
    k_a=$(zaehle_aufrufe "$d/koeder.yml"); k_j=$(zaehle_jobkopf "$d/koeder.yml"); k_f=$(zaehle_allow "$d/koeder.yml")
    k_t=$(zaehle_tags "$d/koeder.yml" thesis:pdf)
    k_n=$(zaehle_zeile "$d/koeder.yml" "$EXPORT_JOB" '^  needs:')
    k_d=$(zaehle_zeile "$d/koeder.yml" "$EXPORT_JOB" '^  dependencies:')
    k_c=$(zaehle_zeile "$d/koeder.yml" "$EXPORT_JOB" 'sh ci/thesis_pdf_export\.sh --ci')
    if [ "$k_n/$k_d/$k_c" = 1/0/0 ]; then ok "Koeder beisst: Export-Block needs/dependencies/--ci $k_n/$k_d/$k_c"; else
        rot "Koeder beisst NICHT: Export-Block needs/dependencies/--ci $k_n/$k_d/$k_c statt 1/0/0"; return
    fi
    if [ "$k_t" = '[baremetal]' ]; then ok "Koeder beisst: tags-Zeile thesis:pdf gelesen als '$k_t'"; else
        rot "Koeder beisst NICHT: tags-Zeile thesis:pdf '$k_t' statt '[baremetal]' -- die Zaehlung taugt nicht"; return
    fi
    if [ "$k_a" = 1 ] && [ "$k_j" = 1 ] && [ "$k_f" = 1 ]; then
        ok "Koeder beisst: Aufruf $k_a, Job-Kopf $k_j, allow_failure im Block $k_f (je 1 erwartet)"
    else
        rot "Koeder beisst NICHT ($k_a/$k_j/$k_f statt 1/1/1) -- die Zaehlung taugt nicht, keine Null gilt"; return
    fi
    nz=$(awk 'END{print NR}' "$CI_YML"); echo "      Nenner: $nz Zeilen in $CI_YML"
    a=$(zaehle_aufrufe "$CI_YML"); j=$(zaehle_jobkopf "$CI_YML"); f=$(zaehle_allow "$CI_YML")
    if [ "$a" -ge 1 ]; then ok "Probe wird gerufen ($a Aufruf(e) '$AUFRUF')"
    else rot "Probe wird nicht gerufen (0 Aufrufe '$AUFRUF') -- ein nie gelaufener Test ist keiner"; fi
    if [ "$j" -eq 1 ]; then ok "Job-Block $JOB vorhanden (1 Kopfzeile)"
    else rot "Job-Block $JOB: $j Kopfzeile(n), erwartet 1"; fi
    if [ "$f" -eq 0 ]; then ok "kein allow_failure im Job $JOB"
    else rot "Job $JOB traegt allow_failure ($f Zeile(n)) -- die naechste stille Null"; fi
    # (b) C4-11 (r6, Lead-Wahl): Host-Pinnung beider Thesis-Jobs -- das Byte-Urteil 288/289 setzt EINE Toolchain
    # voraus; der Probe-Job selbst bleibt [baremetal] (er baut nichts).
    for job_ in thesis:pdf thesis:pdf-export; do
        t_=$(zaehle_tags "$CI_YML" "$job_"); n_=$(printf '%s\n' "$t_" | grep -c .)
        erw_gleich "$n_" 1 "genau eine tags-Zeile im Block $job_"
        erw_gleich "$t_" "$TAGS_SOLL" "tags-Zeile $job_ (Host-Pinnung, C4-11)"
    done
    # (c) C6-07 + C6-09 (r7): der Export-Job ruft das Script mit dem Literal --ci (Produktionsmodus) und traegt
    # KEINE needs-Zeile (Stufenbarriere: erst nach allen Pflicht-Jobs der vorherigen Stufen, auch dieser Probe);
    # das Artefakt kommt per dependencies.
    e_n=$(zaehle_zeile "$CI_YML" "$EXPORT_JOB" '^  needs:')
    e_d=$(zaehle_zeile "$CI_YML" "$EXPORT_JOB" '^  dependencies: [[]"thesis:pdf"[]]')
    e_c=$(zaehle_zeile "$CI_YML" "$EXPORT_JOB" 'sh ci/thesis_pdf_export\.sh --ci')
    erw_gleich "$e_n" 0 "needs-Zeilen im Block $EXPORT_JOB (Stufenbarriere, C6-09)"
    erw_gleich "$e_d" 1 "dependencies-Zeile thesis:pdf im Block $EXPORT_JOB (C6-09)"
    erw_gleich "$e_c" 1 "Aufruf-Literal 'sh ci/thesis_pdf_export.sh --ci' im Block $EXPORT_JOB (C6-07)"
}
fall_P18() { # L1-02: getrackter Zwischen-Symlink docs/ext -> ../../aussen; DIR=docs/ext/pdf -> FEHLER, aussen/ leer
    s="$1"; d="$T/P18"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    git clone -q "$BARE" "$d/prep" || { rot "Klon prep nicht baubar"; return; }
    mkdir -p "$d/prep/docs" "$d/aussen"; ln -s ../../aussen "$d/prep/docs/ext"
    git -C "$d/prep" add docs/ext && git -C "$d/prep" commit -q -m "zwischen-symlink" \
        && git -C "$d/prep" push -q "$BARE" development || { rot "Symlink-Commit fehlgeschlagen"; return; }
    S=$(tip); klone "$d/work" "$S" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    [ -L "$d/work/docs/ext" ] || { rot "Zwischen-Symlink im Klon fehlt (Nenner)"; return; }
    lauf "$d/work" "$s" "$d/out" "$S" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_DIR="docs/ext/pdf"; rc=$?
    zeige "$d/out"; erw_rc "$rc" 1; erw_text "$d/out" "ausserhalb des Arbeitsbaums"
    [ -d "$d/aussen" ] || { rot "Nenner: aussen/ fehlt (L2-04)"; return; }
    anz=$(ls -A "$d/aussen" | wc -l); erw_gleich "$anz" 0 "Eintraege ausserhalb des Baums angelegt (aussen/)"
    t=$(tip); erw_gleich "$t" "$S" "Bare-Tip unveraendert"
}
fall_P19() { # L1-01 (2. Schicht): assume-unchanged-Eintrag -> git add stagt still nichts -> FEHLER, kein Push
    s="$1"; d="$T/P19"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/workA" "$BASE" || { rot "Klon A nicht baubar"; return; }; lege_pdfs "$d/workA" v1
    lauf "$d/workA" "$s" "$d/outA" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" \
        || { rot "Vorlauf-Export (v1) fehlgeschlagen"; zeige "$d/outA"; return; }
    S=$(tip); klone "$d/workB" "$S" || { rot "Klon B nicht baubar"; return; }; lege_pdfs "$d/workB" v2
    git -C "$d/workB" update-index --assume-unchanged docs/diplomarbeit/diplomarbeit-de-lang.pdf \
        || { rot "assume-unchanged nicht setzbar"; return; }
    lauf "$d/workB" "$s" "$d/out" "$S" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 1; erw_text "$d/out" "nicht den Inhalt der Arbeitskopie"; erw_kein_text "$d/out" "PUSH OK"
    t=$(tip); erw_gleich "$t" "$S" "Bare-Tip unveraendert (kein Export mit veraltetem PDF)"
}
fall_P20() { # L1-06: DIR mit Schraegstrich am Ende / mit './' -> normalisiert, Export laeuft (statt 'fremde Pfade')
    s="$1"; d="$T/P20"
    for var in "docs/diplomarbeit/" "./docs/diplomarbeit"; do
        sub="$d/$(printf '%s' "$var" | tr '/.' '__')"
        baue_seed "$sub" || { rot "Wegwerf-Remote nicht baubar"; return; }
        klone "$sub/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$sub/work" v1
        lauf "$sub/work" "$s" "$sub/out" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_DIR="$var"; rc=$?
        zeige "$sub/out"; erw_rc "$rc" 0; erw_text "$sub/out" "PUSH OK (ci.skip)"
        erw_kein_text "$sub/out" "fremde Pfad"
        t=$(tip); n=$(git -C "$BARE" ls-tree --name-only "$t" docs/diplomarbeit/ | grep -c 'diplomarbeit-.*\.pdf$')
        erw_gleich "$n" 4 "PDF-Dateien unter docs/diplomarbeit/ im Bare-Tip (DIR='$var')"
    done
}
fall_P21() { # L1-11: Zielordner selbst als getrackter Symlink nach aussen -> FEHLER, nichts ausserhalb geschrieben
    s="$1"; d="$T/P21"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    git clone -q "$BARE" "$d/prep" || { rot "Klon prep nicht baubar"; return; }
    mkdir -p "$d/prep/docs" "$d/aussen"; ln -s ../../aussen "$d/prep/docs/diplomarbeit"
    git -C "$d/prep" add docs/diplomarbeit && git -C "$d/prep" commit -q -m "zielordner als symlink" \
        && git -C "$d/prep" push -q "$BARE" development || { rot "Symlink-Commit fehlgeschlagen"; return; }
    S=$(tip); klone "$d/work" "$S" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    [ -L "$d/work/docs/diplomarbeit" ] || { rot "Symlink im Klon fehlt (Nenner)"; return; }
    lauf "$d/work" "$s" "$d/out" "$S" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 1; erw_text "$d/out" "Symlink (Zielordner verboten)"
    [ -d "$d/aussen" ] || { rot "Nenner: aussen/ fehlt (L2-04)"; return; }
    anz=$(ls -A "$d/aussen" | wc -l); erw_gleich "$anz" 0 "Dateien ausserhalb des Baums (aussen/)"
    t=$(tip); erw_gleich "$t" "$S" "Bare-Tip unveraendert"
}
fall_P22() { # Override-Verweigerung der PROBE in CI (Klasse F-02): COMDARE_SKRIPT / COMDARE_CI_YML unter CI -> rc=2
    s="$1"; d="$T/P22"; mkdir -p "$d"
    ( cd "$d" && env -i PATH="$PATH" HOME="$HOME" TMPDIR="$T" CI=true COMDARE_SKRIPT="$s" sh "$SELBST" ) \
        > "$d/out1" 2>&1; rc=$?
    zeige "$d/out1"; erw_rc "$rc" 2; erw_text "$d/out1" "in CI verweigert"
    ( cd "$d" && env -i PATH="$PATH" HOME="$HOME" TMPDIR="$T" GITLAB_CI=true COMDARE_CI_YML="$CI_YML" sh "$SELBST" ) \
        > "$d/out2" 2>&1; rc=$?
    erw_rc "$rc" 2; erw_text "$d/out2" "in CI verweigert"
    # L2-03 (r3): der innere Lauf muss VOR mktemp enden (Kopfzeile "Wegwerf-Wurzel:" darf nicht stehen) -- ein
    # durchgelaufener Harnisch raeumt seine Wurzel selbst, eine Null-Zaehlung unterschied das nicht.
    erw_kein_text "$d/out1" "Wegwerf-Wurzel:"; erw_kein_text "$d/out2" "Wegwerf-Wurzel:"
}

# --------------------------------------------------------------------------- Faelle r3 (Lens r2)
# P-23/P-24: die Bloecke EPOCH-288 und DRIFT-WACHE-288-289 des Jobs thesis:pdf werden zwischen ihren Markern aus der
# YAML extrahiert (6 Leerzeichen Block-Skalar-Einzug abgestreift) und mit der Runner-Shell (bash -e -o pipefail)
# gegen ein Wegwerf-Modul samt Wegwerf-super gefahren; ein "Bau" ist hier eine Fake-PDF mit CreationDate = Epoch,
# genau wie pdfTeX unter FORCE_SOURCE_DATE=1 die Zeit aus SOURCE_DATE_EPOCH nimmt.
extrahiere_block() { # $1 = YAML, $2 = Marker-Name, $3 = Zieldatei; Ausgabe: Zeilenzahl
    awk -v a="# >>> $2" -v e="# <<< $2" '
        index($0, a) == 7 { drin = 1 }
        drin { print substr($0, 7) }
        index($0, e) == 7 { drin = 0 }' "$1" > "$3"
    awk 'END{print NR}' "$3"
}
extrahiere_bauschleife() { # $1 = YAML, $2 = Zieldatei: die latexmk-Schleife hinter dem EPOCH-Block; Ausgabe: Zeilen
    { echo 'main=diplomarbeit.tex'
      awk 'index($0, "# <<< EPOCH-288") == 7 { nach = 1; next }
           nach && substr($0, 7) == "for L in de en; do for U in lang kurz; do" { drin = 1 }
           drin { print substr($0, 7) }
           drin && substr($0, 7) == "done; done" { exit }' "$1"; } > "$2"
    awk 'END{print NR}' "$2"
}
epoch_zeit() { date -u -d "@$1" +%Y%m%d%H%M%S; }
# r6: jede Fake-PDF traegt eine pdfTeX-Kennung (PTEX.Fullbanner) -- der r6-Block fordert sie am eigenen Bau GENAU
# einmal (C4-03/C4-04); die Standard-Kennung entspricht der Form von pdfTeX 1.40.29 mit unescaped '(TeX Live 2026)'.
BANNER_STD='This is pdfTeX, Version 3.141592653-2.6-1.40.29 (TeX Live 2026) kpathsea version 6.4.1'
FONT_STD=$(printf '/Length1 1830\n/Length2 11383\n/Length3 0')   # r15 (O-15b): Font-Stand-Zeilen der Fake-PDFs
FONT_ALT=$(printf '/Length1 1831\n/Length2 11384\n/Length3 0')   # r15 (O-15b): anderer Font-Stand (P-24 (j))
lege_pdf_epoch() { # $1 = Verzeichnis, $2 = Epoch, $3 = Marke, [$4 = Kennung; leer = keine Kennungszeile]
    if [ $# -ge 4 ]; then _kn="$4"; else _kn="$BANNER_STD"; fi
    if [ -n "${LEGE_FONT+x}" ]; then _ft="$LEGE_FONT"; else _ft="$FONT_STD"; fi   # r15 (O-15b): leer = ohne Font-Stand
    for f in de-lang en-lang de-kurz en-kurz; do
        printf '%%PDF-1.4\n%% fassung %s %s\n/CreationDate (D:%sZ)\n%%%%EOF\n' "$f" "$3" "$(epoch_zeit "$2")" \
            > "$1/diplomarbeit-$f.pdf"
        [ -z "$_kn" ] || printf '/PTEX.Fullbanner (%s)\n' "$_kn" >> "$1/diplomarbeit-$f.pdf"
        [ -z "$_ft" ] || printf '%s\n' "$_ft" >> "$1/diplomarbeit-$f.pdf"   # r15 (O-15b): Length1/2/3
        printf '/ID [<%s> <%s>]\n' "$f" "$f" >> "$1/diplomarbeit-$f.pdf"   # r7: Trailer-ID je jobname (L6-01)
    done
}
modul_commit() { # $1 = Epoch, $2 = Botschaft
    GIT_COMMITTER_DATE="$1 +0000" GIT_AUTHOR_DATE="$1 +0000" git -C "$MODUL" commit -q -m "$2"
}
# Wegwerf-Modul (Thesis) im Wegwerf-super: X1 (Quelle, T1) -> Y1 (reiner Writeback, PDFs mit CreationDate T1)
#   -> Zweig b: B1 (Quelle, T3); M = --no-ff-Merge von b auf Y1 (T4; fuer Nicht-PDF-Pfade TREESAME zu B1)
#   -> Y2 (reiner Writeback auf M, PDFs mit CreationDate T4) -> Z1 (Quelle nach dem Writeback, T6).
# Die Thesis-CI baut am Commit X mit %ct(X); der Writeback ist Kind Y. Setzt MODUL, SUPERW, X1 Y1 Y2 Z1, T1 T4 T6.
baue_modul() { # $1 = Wurzelverzeichnis
    SUPERW="$1/super"; MODUL="$SUPERW/thesis/diplomarbeit"; T1=1758600100; T4=1758600400; T6=1758600600
    mkdir -p "$MODUL" || return 2
    git init -q "$MODUL" && git -C "$MODUL" symbolic-ref HEAD refs/heads/development || return 2
    printf '%s\n' '\documentclass{article}' > "$MODUL/diplomarbeit.tex"
    git -C "$MODUL" add diplomarbeit.tex && modul_commit "$T1" "X1 quelle" || return 2
    X1=$(git -C "$MODUL" rev-parse HEAD) || return 2
    lege_pdf_epoch "$MODUL" "$T1" writeback1; git -C "$MODUL" add -- diplomarbeit-*.pdf || return 2
    modul_commit 1758600200 "Y1 writeback [skip ci]" || return 2; Y1=$(git -C "$MODUL" rev-parse HEAD) || return 2
    git -C "$MODUL" checkout -q -b b "$X1" || return 2
    printf 'b\n' >> "$MODUL/diplomarbeit.tex"; git -C "$MODUL" add diplomarbeit.tex || return 2
    modul_commit 1758600300 "B1 quelle auf b" || return 2
    git -C "$MODUL" checkout -q development || return 2
    GIT_COMMITTER_DATE="$T4 +0000" GIT_AUTHOR_DATE="$T4 +0000" git -C "$MODUL" merge -q --no-ff --no-edit \
        -m "M merge b" b || return 2
    lege_pdf_epoch "$MODUL" "$T4" writeback2; git -C "$MODUL" add -- diplomarbeit-*.pdf || return 2
    modul_commit 1758600500 "Y2 writeback [skip ci]" || return 2; Y2=$(git -C "$MODUL" rev-parse HEAD) || return 2
    printf 'z\n' >> "$MODUL/diplomarbeit.tex"; git -C "$MODUL" add diplomarbeit.tex || return 2
    modul_commit "$T6" "Z1 quelle nach writeback" || return 2; Z1=$(git -C "$MODUL" rev-parse HEAD) || return 2
    git init -q "$SUPERW" && git -C "$SUPERW" symbolic-ref HEAD refs/heads/development || return 2
    echo "super" > "$SUPERW/README.md"; git -C "$SUPERW" add README.md || return 2
}
super_gitlink() { # $1 = SHA: Gitlink thesis/diplomarbeit im Wegwerf-super auf $1 setzen und committen
    git -C "$SUPERW" update-index --add --cacheinfo "160000,$1,thesis/diplomarbeit" || return 2
    GIT_COMMITTER_DATE="1758600900 +0000" GIT_AUTHOR_DATE="1758600900 +0000" git -C "$SUPERW" commit -q \
        --allow-empty -m "gitlink $1" || return 2
}
fahre_block() { # $1 = Scriptdatei, $2 = Logdatei, danach K=V-Paare; cwd = Modul, CI_PROJECT_DIR = Wegwerf-super
    _bs="$1"; _bl="$2"; shift 2
    ( cd "$MODUL" && env -i PATH="$PATH" HOME="$HOME" TMPDIR="$T" GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1 \
        CI_PROJECT_DIR="$SUPERW" "$@" bash -e -o pipefail "$_bs" ) > "$_bl" 2>&1
}
stand() { # $1 = SHA: Modul detached auf $1 (Fake-Bau der Vorrunde zurueckgesetzt), Gitlink des Wegwerf-super auf $1
    git -C "$MODUL" checkout -q -- . && git -C "$MODUL" clean -qf -- . \
        && git -C "$MODUL" checkout -q --detach "$1" && super_gitlink "$1"
}
fall_P23() { # L2-01 (r3): SOURCE_DATE_EPOCH = Quellstand; F-10 Gitlink == HEAD -- YAML-Block EPOCH-288
    d="$T/P23"; mkdir -p "$d"
    z=$(extrahiere_block "$CI_YML" EPOCH-288 "$d/epoch.sh"); echo "      Block EPOCH-288 aus der YAML: $z Zeilen"
    if [ "$z" -lt 5 ]; then
        rot "Block EPOCH-288 fehlt in $CI_YML ($z Zeilen zwischen den Markern) -- keine Quellstand-Formel"; return
    fi
    command -v bash >/dev/null 2>&1 || { rot "bash (Runner-Shell) fehlt -- Block nicht fahrbar"; return; }
    baue_modul "$d" || { rot "Wegwerf-Modul nicht baubar"; return; }
    for f in "Y1:$Y1:$T1:reiner Writeback auf X1" "X1:$X1:$T1:Quelle ohne Writeback" \
             "Y2:$Y2:$T4:Writeback auf --no-ff-Merge M (TREESAME-Ecke)" "Z1:$Z1:$T6:Quelle nach dem Writeback"; do
        nm=${f%%:*}; r=${f#*:}; sha=${r%%:*}; r=${r#*:}; soll=${r%%:*}; text=${r#*:}
        stand "$sha" || { rot "Stand $nm nicht herstellbar"; return; }
        fahre_block "$d/epoch.sh" "$d/out_$nm"; rc=$?; zeige "$d/out_$nm"
        erw_rc "$rc" 0
        e=$(grep -o 'SOURCE_DATE_EPOCH=[0-9]*' "$d/out_$nm" | head -1 | cut -d= -f2)
        erw_gleich "$e" "$soll" "Epoch am Stand $nm ($text)"
    done
    git -C "$MODUL" checkout -q --detach "$Y1" && super_gitlink "$X1" || { rot "Gitlink-Stand X1"; return; }
    fahre_block "$d/epoch.sh" "$d/out_gitlink"; rc=$?; zeige "$d/out_gitlink"
    erw_rc "$rc" 1; erw_text "$d/out_gitlink" "weicht vom super-Gitlink"   # F-10: Modul Y1, Gitlink X1
    # (e) L3-01 (r4): shallow-Klon des Moduls am Stand Y1 (--depth 1 ueber file://, der Elter von Y1 fehlt) -- die
    # Wache muss LAUT reissen ('gekappt', rc=1) statt still auf %ct(Y1)=1758600200 zurueckzufallen (ADV-14).
    git -C "$MODUL" branch -f y1 "$Y1" || { rot "Zweig y1 nicht setzbar"; return; }
    git clone -q --depth 1 -b y1 "file://$MODUL" "$d/shallow" 2>/dev/null \
        || { rot "shallow-Klon nicht baubar"; return; }
    sh_=$(git -C "$d/shallow" rev-parse --is-shallow-repository); erw_gleich "$sh_" true "Nenner: Klon ist shallow"
    h_=$(git -C "$d/shallow" rev-parse HEAD); erw_gleich "$h_" "$Y1" "Nenner: shallow-HEAD == Y1"
    stand "$Y1" || { rot "Stand Y1 (e)"; return; }
    MODUL_VOLL="$MODUL"; MODUL="$d/shallow"
    fahre_block "$d/epoch.sh" "$d/out_shallow"; rc=$?; MODUL="$MODUL_VOLL"; zeige "$d/out_shallow"
    erw_rc "$rc" 1; erw_text "$d/out_shallow" "gekappt"; erw_kein_text "$d/out_shallow" "SOURCE_DATE_EPOCH="
    # (f) ADV-10 (Lens r3 L3-10/L3-11): zwei reine Writebacks hintereinander (Y1b auf Y1) -- Quellstand X1, 2 Stufen
    git -C "$MODUL" checkout -q -B w2 "$Y1" || { rot "Zweig w2 nicht setzbar"; return; }
    lege_pdf_epoch "$MODUL" 1758600200 writeback1b
    git -C "$MODUL" add -- diplomarbeit-*.pdf && modul_commit 1758600250 "Y1b writeback auf Y1 [skip ci]" \
        || { rot "Commit Y1b"; return; }
    Y1B=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse Y1b"; return; }
    stand "$Y1B" || { rot "Stand Y1b"; return; }
    fahre_block "$d/epoch.sh" "$d/out_Y1b"; rc=$?; zeige "$d/out_Y1b"
    erw_rc "$rc" 0
    e=$(grep -o 'SOURCE_DATE_EPOCH=[0-9]*' "$d/out_Y1b" | head -1 | cut -d= -f2)
    erw_gleich "$e" "$T1" "Epoch am Stand Y1b (zweiter reiner Writeback auf Y1)"
    erw_text "$d/out_Y1b" "2 Writeback-Stufe(n) uebersprungen"
    # (g) L4-01 (r5, ADV-15): Merge MG mit erstem Elter = Quelle S1 (Zweig feat ab X1) und zweitem Elter = Writeback
    # Y1; Diff S1..MG = nur die vier PDFs. Die Thesis-CI baut MG mit %ct(MG): Ein-Elter-Regel -> Quellstand = MG,
    # 0 Stufen (am r4-Block: Quellstand S1 = falscher Epoch bei rc=0). Writeback-Kind YG von MG: Quellstand MG.
    stand "$X1" && git -C "$MODUL" checkout -q -B feat "$X1" || { rot "Zweig feat nicht setzbar"; return; }
    printf 'feat\n' >> "$MODUL/diplomarbeit.tex"
    git -C "$MODUL" add diplomarbeit.tex && modul_commit 1758600310 "S1 quelle auf feat" || { rot "Commit S1"; return; }
    S1=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse S1"; return; }
    GIT_COMMITTER_DATE="1758600410 +0000" GIT_AUTHOR_DATE="1758600410 +0000" git -C "$MODUL" merge -q --no-ff \
        --no-edit -m "MG development (Writeback Y1) in feat" "$Y1" || { rot "Merge MG"; return; }
    MG=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse MG"; return; }
    p_=$(git -C "$MODUL" rev-list --parents -n 1 "$MG" | wc -w); erw_gleich "$p_" 3 "Nenner: MG hat 2 Eltern"
    r_=$(git -C "$MODUL" diff --name-only "$S1" "$MG" | grep -vc 'diplomarbeit-.*\.pdf$')
    erw_gleich "$r_" 0 "Nenner: Pfade im Diff S1..MG ausserhalb der 4 PDFs"
    stand "$MG" || { rot "Stand MG"; return; }
    fahre_block "$d/epoch.sh" "$d/out_MG"; rc=$?; zeige "$d/out_MG"
    erw_rc "$rc" 0
    e=$(grep -o 'SOURCE_DATE_EPOCH=[0-9]*' "$d/out_MG" | head -1 | cut -d= -f2)
    erw_gleich "$e" 1758600410 "Epoch am Stand MG (Merge p1 = Quelle S1, p2 = Writeback Y1)"
    erw_text "$d/out_MG" "0 Writeback-Stufe(n) uebersprungen"
    lege_pdf_epoch "$MODUL" 1758600410 writebackG
    git -C "$MODUL" add -- diplomarbeit-*.pdf && modul_commit 1758600510 "YG writeback auf MG [skip ci]" \
        || { rot "Commit YG"; return; }
    YG=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse YG"; return; }
    stand "$YG" || { rot "Stand YG"; return; }
    fahre_block "$d/epoch.sh" "$d/out_YG"; rc=$?; zeige "$d/out_YG"
    erw_rc "$rc" 0
    e=$(grep -o 'SOURCE_DATE_EPOCH=[0-9]*' "$d/out_YG" | head -1 | cut -d= -f2)
    erw_gleich "$e" 1758600410 "Epoch am Stand YG (Writeback-Kind des Merges MG)"
    erw_text "$d/out_YG" "1 Writeback-Stufe(n) uebersprungen"
    # (g2) derselbe Merge MIT '[skip ci]' in der Botschaft: die Marker-Bedingung greift nicht mehr, NUR die
    # Ein-Elter-Regel haelt den Merge als Quellstand (Mutante m15 muss genau hier reissen).
    git -C "$MODUL" checkout -q -B feat2 "$S1" || { rot "Zweig feat2 nicht setzbar"; return; }
    GIT_COMMITTER_DATE="1758600420 +0000" GIT_AUTHOR_DATE="1758600420 +0000" git -C "$MODUL" merge -q --no-ff \
        --no-edit -m "MG2 development (Writeback Y1) in feat2 [skip ci]" "$Y1" || { rot "Merge MG2"; return; }
    MG2=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse MG2"; return; }
    stand "$MG2" || { rot "Stand MG2"; return; }
    fahre_block "$d/epoch.sh" "$d/out_MG2"; rc=$?; zeige "$d/out_MG2"
    erw_rc "$rc" 0
    e=$(grep -o 'SOURCE_DATE_EPOCH=[0-9]*' "$d/out_MG2" | head -1 | cut -d= -f2)
    erw_gleich "$e" 1758600420 "Epoch am Stand MG2 (Merge mit skip-ci-Marker, zwei Eltern)"
    erw_text "$d/out_MG2" "0 Writeback-Stufe(n) uebersprungen"
    # (h) L4-01 (r5, Lead-Wahl UND-Bedingung): Ein-Elter-PDF-Commit OHNE '[skip ci]' (von Hand) = KEIN Writeback,
    # die Thesis-CI baut ihn -> Quellstand = HP1 (am r4-Block: uebersprungen, Quellstand X1 = falscher Epoch).
    stand "$X1" && git -C "$MODUL" checkout -q -B hpdf "$X1" || { rot "Zweig hpdf nicht setzbar"; return; }
    lege_pdf_epoch "$MODUL" "$T1" vonhand
    git -C "$MODUL" add -- diplomarbeit-*.pdf && modul_commit 1758600320 "HP1 PDFs von Hand, ohne Marker" \
        || { rot "Commit HP1"; return; }
    HP1=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse HP1"; return; }
    stand "$HP1" || { rot "Stand HP1"; return; }
    fahre_block "$d/epoch.sh" "$d/out_HP1"; rc=$?; zeige "$d/out_HP1"
    erw_rc "$rc" 0
    e=$(grep -o 'SOURCE_DATE_EPOCH=[0-9]*' "$d/out_HP1" | head -1 | cut -d= -f2)
    erw_gleich "$e" 1758600320 "Epoch am Stand HP1 (PDF-Commit von Hand ohne skip-ci-Marker)"
    erw_text "$d/out_HP1" "0 Writeback-Stufe(n) uebersprungen"
    # (i) L4-04 (r5, ADV-17): acht reine Writebacks W1..W8 auf X1 = Quellstand X1 mit '8 Stufe(n)' (Deckel exakt
    # erreicht, erlaubt); der neunte W9 = Deckel ueberschritten -> FEHLER rc=1 (am r4-Block: still %ct(W1), rc=0).
    stand "$X1" && git -C "$MODUL" checkout -q -B w9 "$X1" || { rot "Zweig w9 nicht setzbar"; return; }
    i_=1
    while [ "$i_" -le 9 ]; do
        lege_pdf_epoch "$MODUL" $((1758600100 + i_ * 10)) "wb$i_"
        git -C "$MODUL" add -- diplomarbeit-*.pdf \
            && modul_commit $((1758600200 + i_ * 10)) "W$i_ writeback [skip ci]" || { rot "Commit W$i_"; return; }
        if [ "$i_" -eq 8 ]; then
            W8=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse W8"; return; }
            stand "$W8" || { rot "Stand W8"; return; }
            fahre_block "$d/epoch.sh" "$d/out_W8"; rc=$?; zeige "$d/out_W8"
            erw_rc "$rc" 0
            e=$(grep -o 'SOURCE_DATE_EPOCH=[0-9]*' "$d/out_W8" | head -1 | cut -d= -f2)
            erw_gleich "$e" "$T1" "Epoch am Stand W8 (acht Writebacks = Deckel exakt erreicht)"
            erw_text "$d/out_W8" "8 Writeback-Stufe(n) uebersprungen"
            git -C "$MODUL" checkout -q w9 || { rot "zurueck auf w9"; return; }
        fi
        i_=$((i_ + 1))
    done
    W9=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse W9"; return; }
    stand "$W9" || { rot "Stand W9"; return; }
    fahre_block "$d/epoch.sh" "$d/out_W9"; rc=$?; zeige "$d/out_W9"
    erw_rc "$rc" 1; erw_text "$d/out_W9" "FEHLER: Eltern-Walk-Deckel"; erw_kein_text "$d/out_W9" "SOURCE_DATE_EPOCH="
    # (j) L4-08 (r5, ADV-26): CI_PROJECT_DIR leer -> FEHLER vor dem Gitlink-Vergleich (am r4-Block: git -C '' = cwd,
    # irrefuehrender Text 'weicht vom super-Gitlink').
    stand "$Y1" || { rot "Stand Y1 (j)"; return; }
    fahre_block "$d/epoch.sh" "$d/out_cpd" CI_PROJECT_DIR=; rc=$?; zeige "$d/out_cpd"
    erw_rc "$rc" 1; erw_text "$d/out_cpd" "CI_PROJECT_DIR leer"
    # (k) C4-12 (r6): Wegwerf-Klon (lokaler Pfad, --no-hardlinks: lose Objekte) am Stand Y1, dann das Elter-Objekt X1
    # aus dem Objektspeicher entfernt (nicht shallow). Die Elternliste ist nicht lesbar -> FEHLER rc=1 mit Grund. Am
    # r5-Block gelingt 'rev-parse -q --verify Y1^' trotzdem (rc=0, Probe S3), erst 'git diff' reisst mit fremdem Text.
    stand "$Y1" || { rot "Stand Y1 (k)"; return; }
    git clone -q --no-hardlinks -b y1 "$MODUL" "$d/elter" 2>/dev/null || { rot "Klon elter nicht baubar"; return; }
    o_="$d/elter/.git/objects/$(printf '%.2s' "$X1")/${X1#??}"
    [ -f "$o_" ] || { rot "Nenner: Elter-Objekt X1 liegt nicht lose im Klon ($o_)"; return; }
    rm -f "$o_"; sh_=$(git -C "$d/elter" rev-parse --is-shallow-repository)
    erw_gleich "$sh_" false "Nenner: Klon elter nicht shallow"
    h_=$(git -C "$d/elter" rev-parse HEAD); erw_gleich "$h_" "$Y1" "Nenner: Klon-HEAD == Y1"
    MODUL_VOLL="$MODUL"; MODUL="$d/elter"
    fahre_block "$d/epoch.sh" "$d/out_elter"; rc=$?; MODUL="$MODUL_VOLL"; zeige "$d/out_elter"
    erw_rc "$rc" 1; erw_text "$d/out_elter" "Elternliste nicht lesbar"
    erw_kein_text "$d/out_elter" "SOURCE_DATE_EPOCH="
    # (c2) C7-03 (r8): git-Wrapper liefert fuer --is-shallow-repository den Wert 'weird' -- am Wurzel-Stand X1 (kein
    # Elter) muss der Block LAUT reissen (am r7-Block: 'weird' != true = wie false, rc=0 mit Epoch T1).
    mkdir -p "$d/gitw" || { rot "Wegwerf-gitw nicht anlegbar"; return; }
    printf '#!/bin/sh\ncase " $* " in *" --is-shallow-repository "*) echo weird; exit 0 ;; esac\nexec %s "$@"\n' \
        "$(command -v git)" > "$d/gitw/git"; chmod 0755 "$d/gitw/git"
    stand "$X1" || { rot "Stand X1 (c2)"; return; }
    fahre_block "$d/epoch.sh" "$d/out_c2" PATH="$d/gitw:$PATH"; rc=$?; zeige "$d/out_c2"
    erw_rc "$rc" 1; erw_text "$d/out_c2" "unerwarteter Wert --is-shallow-repository"
    erw_kein_text "$d/out_c2" "SOURCE_DATE_EPOCH="
}
p24_werkzeuge() { # r16: Wegwerf-pdftex, Wegwerf-latexmk + bau.sh der DRIFT-Laeufe (P-24, P-95); $1 = Fallordner
    d="$1"
    # r4 (L3-02): Wegwerf-pdftex fuer die Nachweiszeile des Blocks (die ECHTE Installation ist Konfig-Posten)
    mkdir -p "$d/bin" || { rot "Wegwerf-bin nicht anlegbar"; return 1; }
    printf '#!/bin/sh\necho "pdfTeX 3.141592653-2.6-1.40.29 (TeX Live 2026) [Wegwerf-pdftex der Probe]"\n' \
        > "$d/bin/pdftex"; chmod 0755 "$d/bin/pdftex"
    # r6 (C4-09): Wegwerf-latexmk fuer die Bau-Schleife der YAML (Fall (o)) -- ohne -g gilt eine vorhandene
    # Zieldatei als up-to-date (nichts geschrieben), sonst Neubau mit Marke 'neubau'.
    cat > "$d/bin/latexmk" <<'LMK'
#!/bin/sh
jn=; g=0
for a in "$@"; do case "$a" in -jobname=*) jn=${a#-jobname=} ;; -g) g=1 ;; esac; done
[ -n "$jn" ] || { echo "Wegwerf-latexmk: kein -jobname" >&2; exit 2; }
if [ "$g" -eq 0 ] && [ -s "$jn.pdf" ]; then echo "Wegwerf-latexmk: $jn.pdf up-to-date, nichts gebaut"; exit 0; fi
printf '%%PDF-1.4\n%% fassung %s neubau\n/CreationDate (D:%sZ)\n%%%%EOF\n' "$jn" \
  "$(date -u -d "@${SOURCE_DATE_EPOCH:-0}" +%Y%m%d%H%M%S)" > "$jn.pdf"
LMK
    chmod 0755 "$d/bin/latexmk"
    P24_PATH="$d/bin:$PATH"
    cat > "$d/bau.sh" <<'BAU'
# BAU_BANNER: unset = Standard-Kennung (wie lege_pdf_epoch), gesetzt-leer = keine Kennung (Fall k4)
BAU_BANNER="${BAU_BANNER-This is pdfTeX, Version 3.141592653-2.6-1.40.29 (TeX Live 2026) kpathsea version 6.4.1}"
BAU_FONT="${BAU_FONT-$(printf '/Length1 1830\n/Length2 11383\n/Length3 0')}"   # r15 (O-15b): leer = ohne (Fall k)
for f in de-lang en-lang de-kurz en-kurz; do
  printf '%%PDF-1.4\n%% fassung %s %s\n' "$f" "$BAU_MARKE" > "diplomarbeit-$f.pdf"
  [ -n "${BAU_NOCD:-}" ] || printf '/CreationDate (D:%sZ)\n' \
    "$(date -u -d "@${BAU_CD_EPOCH:-$SOURCE_DATE_EPOCH}" +%Y%m%d%H%M%S)" >> "diplomarbeit-$f.pdf"
  printf '%%%%EOF\n' >> "diplomarbeit-$f.pdf"
  [ -z "$BAU_BANNER" ] || printf '/PTEX.Fullbanner (%s)\n' "$BAU_BANNER" >> "diplomarbeit-$f.pdf"
  [ -z "$BAU_FONT" ] || printf '%s\n' "$BAU_FONT" >> "diplomarbeit-$f.pdf"
done
[ -z "${BAU_DRIFT:-}" ] || printf '%% drift\n' >> "diplomarbeit-de-lang.pdf"
[ -z "${BAU_GLEICH:-}" ] || cp diplomarbeit-de-lang.pdf diplomarbeit-de-kurz.pdf
[ -z "${BAU_EN_GLEICH:-}" ] || cp diplomarbeit-en-lang.pdf diplomarbeit-en-kurz.pdf
[ -z "${BAU_SPRACHE_GLEICH:-}" ] || cp diplomarbeit-de-lang.pdf diplomarbeit-en-lang.pdf
# r7 (L6-01): Trailer-ID je jobname (wie pdfTeX) + Seitenzahl-Zeile des pdfTeX-Logs je Fassung
for f in de-lang en-lang de-kurz en-kurz; do
  case "${BAU_ID_N:-1}" in 0) ;;
  2) printf '/ID [<%s> <%s>]\n/ID [<%s> <%s>]\n' "$f" "$f" "$f" "$f" >> "diplomarbeit-$f.pdf" ;;
  *) printf '/ID [<%s> <%s>]\n' "$f" "$f" >> "diplomarbeit-$f.pdf" ;; esac   # r8 (C7-01): 0/1/2 ID-Zeilen
  case "$f" in de-lang) n=${BAU_S_DE_LANG:-100} ;; de-kurz) n=${BAU_S_DE_KURZ:-60} ;;
                en-lang) n=${BAU_S_EN_LANG:-100} ;; *) n=${BAU_S_EN_KURZ:-60} ;; esac
  if [ "$n" -eq 1 ]; then pg=page; else pg=pages; fi   # r8 (C7-07): pdfTeX schreibt '1 page,'
  printf 'Output written on diplomarbeit-%s.pdf (%s %s, 4711 bytes).\n' "$f" "$n" "$pg" > "diplomarbeit-$f.log"
done
BAU
}
fall_P24() { # L1-04/L2-01 (r3): Drift-Wache dreiwertig -- Bloecke EPOCH-288 + Fake-Bau + DRIFT-WACHE-288-289
    d="$T/P24"; mkdir -p "$d"
    ze=$(extrahiere_block "$CI_YML" EPOCH-288 "$d/epoch.sh")
    zd=$(extrahiere_block "$CI_YML" DRIFT-WACHE-288-289 "$d/drift.sh")
    echo "      Bloecke aus der YAML: EPOCH-288 $ze Zeilen, DRIFT-WACHE-288-289 $zd Zeilen"
    if [ "$ze" -lt 5 ] || [ "$zd" -lt 5 ]; then
        rot "Block EPOCH-288/DRIFT-WACHE-288-289 fehlt in $CI_YML ($ze/$zd Zeilen) -- keine dreiwertige Wache"; return
    fi
    command -v bash >/dev/null 2>&1 || { rot "bash (Runner-Shell) fehlt -- Block nicht fahrbar"; return; }
    baue_modul "$d" || { rot "Wegwerf-Modul nicht baubar"; return; }
    p24_werkzeuge "$d" || { rot "Wegwerf-Werkzeuge nicht anlegbar"; return; }
    cat "$d/epoch.sh" "$d/bau.sh" "$d/drift.sh" > "$d/lauf.sh"
    stand "$Y1" || { rot "Stand Y1"; return; }                          # (a) gleicher Quellstand, gleiche Bytes
    fahre_block "$d/lauf.sh" "$d/out_a" PATH="$P24_PATH" BAU_MARKE=writeback1; rc=$?; zeige "$d/out_a"
    erw_rc "$rc" 0; erw_text "$d/out_a" "4 byte-gleich geprueft"; erw_text "$d/out_a" "0 veraltet/abweichend"
    erw_kein_text "$d/out_a" "FEHLER: DRIFT"
    stand "$Y1" || { rot "Stand Y1"; return; }                          # (b) gleicher Epoch, andere Bytes = ROT
    fahre_block "$d/lauf.sh" "$d/out_b" PATH="$P24_PATH" BAU_MARKE=writeback1 BAU_DRIFT=1; rc=$?; zeige "$d/out_b"
    erw_rc "$rc" 1; erw_text "$d/out_b" "FEHLER: DRIFT 288/289 bei diplomarbeit-de-lang.pdf"
    stand "$Z1" || { rot "Stand Z1"; return; }                          # (c) Quelle bewegt: veraltet, kein Urteil
    fahre_block "$d/lauf.sh" "$d/out_c" PATH="$P24_PATH" BAU_MARKE=neu; rc=$?; zeige "$d/out_c"
    erw_rc "$rc" 0; erw_text "$d/out_c" "4 veraltet/abweichend"; erw_text "$d/out_c" "kein Byte-Urteil"
    erw_kein_text "$d/out_c" "FEHLER: DRIFT"; erw_text "$d/out_c" "0 byte-gleich geprueft"
    stand "$X1" || { rot "Stand X1"; return; }                          # (d) keine 289-Kopie: gezaehlt
    fahre_block "$d/lauf.sh" "$d/out_d" PATH="$P24_PATH" BAU_MARKE=neu; rc=$?; zeige "$d/out_d"
    erw_rc "$rc" 0; erw_text "$d/out_d" "0 von 4 Fassungen am Gitlink vorhanden"; erw_text "$d/out_d" "4 fehlen"
    # (e) L3-02 (r4): 289-Kopie mit FREMDEM PTEX.Fullbanner bei gleichem Epoch (Stand Y1f = reiner Writeback auf X1,
    # von einer anderen Toolchain gebaut) -- Zustand (3) 'Toolchain abweichend', rc=0, KEIN Byte-Urteil (am r3-Block
    # war das 'FEHLER: DRIFT' rc=1 = Rot je nach Scheduling im Pool prod1 + prod2).
    B289='This is pdfTeX, Version 3.141592653-2.6-1.40.28 (TeX Live 2025) kpathsea version 6.4.0'
    B288='This is pdfTeX, Version 3.141592653-2.6-1.40.29 (TeX Live 2026) kpathsea version 6.4.1'
    stand "$X1" && git -C "$MODUL" checkout -q -B f "$X1" || { rot "Zweig f nicht setzbar"; return; }
    lege_pdf_epoch "$MODUL" "$T1" writeback1 "$B289"
    git -C "$MODUL" add -- diplomarbeit-*.pdf && modul_commit 1758600250 "Y1f writeback fremde Toolchain [skip ci]" \
        || { rot "Commit Y1f"; return; }
    Y1F=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse Y1f"; return; }
    stand "$Y1F" || { rot "Stand Y1f"; return; }
    fahre_block "$d/lauf.sh" "$d/out_e" PATH="$P24_PATH" BAU_MARKE=writeback1 BAU_BANNER="$B288"; rc=$?
    zeige "$d/out_e"
    erw_rc "$rc" 0; erw_text "$d/out_e" "Toolchain abweichend"; erw_text "$d/out_e" "0 byte-gleich geprueft"
    erw_text "$d/out_e" "4 veraltet/abweichend"; erw_kein_text "$d/out_e" "FEHLER: DRIFT"
    erw_text "$d/out_e" "TeX Live 2025"; erw_text "$d/out_e" "TeX Live 2026"   # beide Kennungen stehen im Log
    # (f) I-4 (Fix r3) / ADV-12 (Lens r3 L3-10): 289-Kopie mit fremder CreationDate-Form (kein D:<14 Ziffern>Z) --
    # Zustand (3) 'veraltet/abweichend' mit Rohwert, rc=0, kein Byte-Urteil (Regressionswache, an r3 und r4 gruen).
    cd_="D:20260101120000+01'00'"
    stand "$X1" && git -C "$MODUL" checkout -q -B x "$X1" || { rot "Zweig x nicht setzbar"; return; }
    for f in de-lang en-lang de-kurz en-kurz; do
        printf '%%PDF-1.4\n%% fassung %s fremd\n/CreationDate (%s)\n%%%%EOF\n' "$f" "$cd_" \
            > "$MODUL/diplomarbeit-$f.pdf"
    done
    git -C "$MODUL" add -- diplomarbeit-*.pdf && modul_commit 1758600260 "Y1x writeback fremde CreationDate [skip ci]" \
        || { rot "Commit Y1x"; return; }
    Y1X=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse Y1x"; return; }
    stand "$Y1X" || { rot "Stand Y1x"; return; }
    fahre_block "$d/lauf.sh" "$d/out_f" PATH="$P24_PATH" BAU_MARKE=neu; rc=$?; zeige "$d/out_f"
    erw_rc "$rc" 0; erw_text "$d/out_f" "4 veraltet/abweichend"; erw_text "$d/out_f" "kein Byte-Urteil"
    erw_kein_text "$d/out_f" "FEHLER"; erw_text "$d/out_f" "Kennung nicht lesbar/eindeutig (CreationDate 0-mal"
    # (g) L3-02 (r4): pdftex fehlt auf dem PATH -- die Nachweiszeile ist fail-closed (FEHLER, rc=1); Wegwerf-PATH
    # nur mit den Werkzeugen der Bloecke (bash git date grep sed sha256sum cut mktemp rm head tr), ohne pdftex.
    mkdir -p "$d/nobin" || { rot "Wegwerf-nobin nicht anlegbar"; return; }
    for w in bash git date grep sed sha256sum cut mktemp rm head tr wc; do
        ln -s "$(command -v "$w")" "$d/nobin/$w" || { rot "Werkzeug $w nicht verlinkbar"; return; }
    done
    stand "$Y1" || { rot "Stand Y1 (g)"; return; }
    fahre_block "$d/lauf.sh" "$d/out_g" PATH="$d/nobin" BAU_MARKE=writeback1; rc=$?; zeige "$d/out_g"
    erw_rc "$rc" 1; erw_text "$d/out_g" "pdftex fehlt"; erw_kein_text "$d/out_g" "byte-gleich"
    # (h) L4-02 (r5) -> r6 (Codex-Lens r4 C4-04): eingebettetes /PTEX.InfoDict einer Figur (fremdes CreationDate +
    # fremder Fullbanner) VOR dem Info-Dict des Dokuments = jede Kennung 2x. r6 fordert Kardinalitaet GENAU EINS:
    # (k3) im EIGENEN 288-Bau (lauf_fig) = FEHLER 'Bau unlesbar' rc=1; (k1) nur in der 289-Kopie (Stand Y1g, 288-Bau
    # sauber) = Zustand (3) 'Kennung nicht lesbar/eindeutig', rc=0, kein Byte-Urteil (am r5-Block: letzter Treffer,
    # byte-gleich bei rc=0).
    FIG='This is pdfTeX, Version 3.141592653-2.6-1.40.20 (TeX Live 2019) kpathsea version 6.3.1'
    cat > "$d/bau_fig.sh" <<'BAU'
for f in de-lang en-lang de-kurz en-kurz; do
  printf '%%PDF-1.4\n/PTEX.InfoDict << /CreationDate (D:20200101000000Z) /PTEX.Fullbanner (%s) >>\n' "$BAU_FIG" \
    > "diplomarbeit-$f.pdf"
  printf '%% fassung %s %s\n/CreationDate (D:%sZ)\n/PTEX.Fullbanner (%s)\n%%%%EOF\n' "$f" "$BAU_MARKE" \
    "$(date -u -d "@$SOURCE_DATE_EPOCH" +%Y%m%d%H%M%S)" "$BAU_BANNER" >> "diplomarbeit-$f.pdf"
  printf '/Length1 1830\n/Length2 11383\n/Length3 0\n' >> "diplomarbeit-$f.pdf"   # r15 (O-15b)
  printf '/ID [<%s> <%s>]\n' "$f" "$f" >> "diplomarbeit-$f.pdf"
done
BAU
    cat "$d/epoch.sh" "$d/bau_fig.sh" "$d/drift.sh" > "$d/lauf_fig.sh"
    stand "$X1" && git -C "$MODUL" checkout -q -B fig "$X1" || { rot "Zweig fig nicht setzbar"; return; }
    for f in de-lang en-lang de-kurz en-kurz; do
        printf '%%PDF-1.4\n/PTEX.InfoDict << /CreationDate (D:20200101000000Z) /PTEX.Fullbanner (%s) >>\n' "$FIG" \
            > "$MODUL/diplomarbeit-$f.pdf"
        printf '%% fassung %s writeback1\n/CreationDate (D:%sZ)\n/PTEX.Fullbanner (%s)\n%%%%EOF\n' "$f" \
            "$(epoch_zeit "$T1")" "$B289" >> "$MODUL/diplomarbeit-$f.pdf"
        printf '/Length1 1830\n/Length2 11383\n/Length3 0\n' >> "$MODUL/diplomarbeit-$f.pdf"   # r15 (O-15b)
    done
    git -C "$MODUL" add -- diplomarbeit-*.pdf && modul_commit 1758600270 "Y1g writeback mit Figur-Dict [skip ci]" \
        || { rot "Commit Y1g"; return; }
    Y1G=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse Y1g"; return; }
    n_=$(git -C "$MODUL" show "$Y1G:diplomarbeit-de-lang.pdf" | grep -a -c 'CreationDate (D:')
    erw_gleich "$n_" 2 "Nenner: CreationDate-Eintraege in der 289-Kopie (Figur zuerst, Dokument zuletzt)"
    stand "$Y1G" || { rot "Stand Y1g"; return; }                                  # (k3) 288-Bau mit Figur-Dict
    fahre_block "$d/lauf_fig.sh" "$d/out_k3" PATH="$P24_PATH" BAU_MARKE=writeback1 BAU_FIG="$FIG" BAU_BANNER="$B289"
    rc=$?; zeige "$d/out_k3"
    erw_rc "$rc" 1; erw_text "$d/out_k3" "FEHLER: CreationDate im 288-Bau"; erw_text "$d/out_k3" "2-mal statt 1x"
    erw_kein_text "$d/out_k3" "byte-gleich zur 289-Kopie"
    stand "$Y1G" || { rot "Stand Y1g (k1)"; return; }                             # (k1) nur 289-Kopie doppelt
    fahre_block "$d/lauf.sh" "$d/out_k1" PATH="$P24_PATH" BAU_MARKE=writeback1; rc=$?; zeige "$d/out_k1"
    erw_rc "$rc" 0; erw_text "$d/out_k1" "Kennung nicht lesbar/eindeutig (CreationDate 2-mal"
    erw_text "$d/out_k1" "PTEX.Fullbanner 2-mal"; erw_text "$d/out_k1" "4 veraltet/abweichend"
    erw_text "$d/out_k1" "0 byte-gleich geprueft"; erw_kein_text "$d/out_k1" "FEHLER"
    # (i) L4-07 (r5, ADV-24): sha256sum scheitert im Byte-Urteil -> FEHLER-Zeile + rc=1 (am r4-Block: set -e ohne
    # FEHLER-Zeile). Wegwerf-sha256sum vor dem PATH.
    mkdir -p "$d/badbin" || { rot "Wegwerf-badbin nicht anlegbar"; return; }
    printf '#!/bin/sh\necho "sha256sum: Wegwerf-Stub scheitert" >&2; exit 1\n' > "$d/badbin/sha256sum"
    chmod 0755 "$d/badbin/sha256sum"
    stand "$Y1" || { rot "Stand Y1 (i)"; return; }
    fahre_block "$d/lauf.sh" "$d/out_i" PATH="$d/badbin:$P24_PATH" BAU_MARKE=writeback1; rc=$?; zeige "$d/out_i"
    erw_rc "$rc" 1; erw_text "$d/out_i" "FEHLER: sha256sum"; erw_kein_text "$d/out_i" "byte-gleich"
    # (k2) C4-03 (r6): 289-Kopie OHNE Fullbanner bei gleichem Epoch -> Zustand (3) 'nicht lesbar/eindeutig', rc=0
    stand "$X1" && git -C "$MODUL" checkout -q -B nofb "$X1" || { rot "Zweig nofb nicht setzbar"; return; }
    lege_pdf_epoch "$MODUL" "$T1" writeback1 ""
    git -C "$MODUL" add -- diplomarbeit-*.pdf && modul_commit 1758600280 "Y1n writeback ohne Kennung [skip ci]" \
        || { rot "Commit Y1n"; return; }
    Y1N=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse Y1n"; return; }
    stand "$Y1N" || { rot "Stand Y1n"; return; }
    fahre_block "$d/lauf.sh" "$d/out_k2" PATH="$P24_PATH" BAU_MARKE=writeback1; rc=$?; zeige "$d/out_k2"
    erw_rc "$rc" 0; erw_text "$d/out_k2" "PTEX.Fullbanner 0-mal), kein Byte-Urteil"
    erw_text "$d/out_k2" "4 veraltet/abweichend"; erw_kein_text "$d/out_k2" "FEHLER"
    # (k4)/(k5) C4-03/C4-04 (r6): der EIGENE 288-Bau ohne Fullbanner bzw. ohne CreationDate = FEHLER rc=1
    stand "$Y1" || { rot "Stand Y1 (k4)"; return; }
    fahre_block "$d/lauf.sh" "$d/out_k4" PATH="$P24_PATH" BAU_MARKE=writeback1 BAU_BANNER=; rc=$?; zeige "$d/out_k4"
    erw_rc "$rc" 1; erw_text "$d/out_k4" "FEHLER: PTEX.Fullbanner im 288-Bau"; erw_text "$d/out_k4" "0-mal statt 1x"
    stand "$Y1" || { rot "Stand Y1 (k5)"; return; }
    fahre_block "$d/lauf.sh" "$d/out_k5" PATH="$P24_PATH" BAU_MARKE=writeback1 BAU_NOCD=1; rc=$?; zeige "$d/out_k5"
    erw_rc "$rc" 1; erw_text "$d/out_k5" "FEHLER: CreationDate im 288-Bau"; erw_text "$d/out_k5" "0-mal statt 1x"
    # (l) C4-05 (r6): 289-Kennung bis '(TeX Live 2026)' gleich, nur der kpathsea-Teil weicht ab -> 'Toolchain
    # abweichend' rc=0 (am r5-Muster '[^)]*' endet die Kennung an der ersten ')': gleich -> Byte-Urteil -> FEHLER DRIFT)
    B289K='This is pdfTeX, Version 3.141592653-2.6-1.40.29 (TeX Live 2026) kpathsea version 6.4.0'
    stand "$X1" && git -C "$MODUL" checkout -q -B kp "$X1" || { rot "Zweig kp nicht setzbar"; return; }
    lege_pdf_epoch "$MODUL" "$T1" writeback1 "$B289K"
    git -C "$MODUL" add -- diplomarbeit-*.pdf && modul_commit 1758600282 "Y1k writeback kpathsea [skip ci]" \
        || { rot "Commit Y1k"; return; }
    Y1K=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse Y1k"; return; }
    stand "$Y1K" || { rot "Stand Y1k"; return; }
    fahre_block "$d/lauf.sh" "$d/out_l" PATH="$P24_PATH" BAU_MARKE=writeback1; rc=$?; zeige "$d/out_l"
    erw_rc "$rc" 0; erw_text "$d/out_l" "Toolchain abweichend"; erw_text "$d/out_l" "kpathsea version 6.4.0"
    erw_text "$d/out_l" "kpathsea version 6.4.1"; erw_kein_text "$d/out_l" "FEHLER"
    # (l2) Auftrags-Fixture: escaped Klammern '\(TeX Live 2024\)' in BEIDEN Kennungen -> byte-gleich, rc=0
    BESC='This is pdfTeX, Version 3.141592653-2.6-1.40.29 \(TeX Live 2024\) kpathsea version 6.4.0'
    stand "$X1" && git -C "$MODUL" checkout -q -B esc "$X1" || { rot "Zweig esc nicht setzbar"; return; }
    lege_pdf_epoch "$MODUL" "$T1" writeback1 "$BESC"
    git -C "$MODUL" add -- diplomarbeit-*.pdf && modul_commit 1758600284 "Y1e writeback escaped [skip ci]" \
        || { rot "Commit Y1e"; return; }
    Y1E=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse Y1e"; return; }
    stand "$Y1E" || { rot "Stand Y1e"; return; }
    fahre_block "$d/lauf.sh" "$d/out_l2" PATH="$P24_PATH" BAU_MARKE=writeback1 BAU_BANNER="$BESC"; rc=$?
    zeige "$d/out_l2"
    erw_rc "$rc" 0; erw_text "$d/out_l2" "4 byte-gleich geprueft"; erw_kein_text "$d/out_l2" "FEHLER"
    # (m) C4-06 (r6): Blob der 289-Kopie de-lang aus dem Objektspeicher entfernt (Pfad im Tree gelistet) -> FEHLER
    # 'Blob nicht lesbar' rc=1 (am r5-Block: 'cat-file -e || continue' = 'fehlt', 3 byte-gleich, rc=0).
    stand "$Y1" || { rot "Stand Y1 (m)"; return; }
    bl_=$(git -C "$MODUL" rev-parse "$Y1:diplomarbeit-de-lang.pdf") || { rot "Blob-SHA de-lang"; return; }
    ob_="$MODUL/.git/objects/$(printf '%.2s' "$bl_")/${bl_#??}"
    [ -f "$ob_" ] || { rot "Nenner: Blob de-lang liegt nicht lose ($ob_)"; return; }
    cp "$ob_" "$d/blob.sav" && rm -f "$ob_" || { rot "Blob nicht sicherbar"; return; }
    fahre_block "$d/lauf.sh" "$d/out_m" PATH="$P24_PATH" BAU_MARKE=writeback1; rc=$?; zeige "$d/out_m"
    cp "$d/blob.sav" "$ob_" || { rot "Blob nicht wiederherstellbar"; return; }
    erw_rc "$rc" 1; erw_text "$d/out_m" "Blob nicht lesbar"; erw_kein_text "$d/out_m" "byte-gleich zur 289-Kopie"
    # (n1)/(n2) C4-10 (r6): pdftex --version ohne Ausgabe (rc=0) bzw. mit rc=3 -> FEHLER rc=1 (am r5-Block: leere
    # Nachweiszeile bei rc=0 = Erfolg).
    mkdir -p "$d/binleer" "$d/binrot" || { rot "Wegwerf-bin (n) nicht anlegbar"; return; }
    printf '#!/bin/sh\nexit 0\n' > "$d/binleer/pdftex"; chmod 0755 "$d/binleer/pdftex"
    printf '#!/bin/sh\necho "pdfTeX kaputt"; exit 3\n' > "$d/binrot/pdftex"; chmod 0755 "$d/binrot/pdftex"
    stand "$Y1" || { rot "Stand Y1 (n1)"; return; }
    fahre_block "$d/lauf.sh" "$d/out_n1" PATH="$d/binleer:$P24_PATH" BAU_MARKE=writeback1; rc=$?; zeige "$d/out_n1"
    erw_rc "$rc" 1; erw_text "$d/out_n1" "ohne Ausgabe"; erw_kein_text "$d/out_n1" "byte-gleich"
    stand "$Y1" || { rot "Stand Y1 (n2)"; return; }
    fahre_block "$d/lauf.sh" "$d/out_n2" PATH="$d/binrot:$P24_PATH" BAU_MARKE=writeback1; rc=$?; zeige "$d/out_n2"
    erw_rc "$rc" 1; erw_text "$d/out_n2" "FEHLER: pdftex --version"; erw_kein_text "$d/out_n2" "byte-gleich"
    # (o) C4-09 (r6): die Bau-Schleife der YAML (for L/U ... done; done nach dem EPOCH-Block) mit dem Wegwerf-latexmk
    # am Stand Y1 (289-PDFs liegen ausgecheckt): rm -f + latexmk -g erzwingen den Neubau -> 4x 'neubau' (am r5-Stand
    # laesst der Stub die alten Dateien als up-to-date liegen: 0x 'neubau').
    zb=$(extrahiere_bauschleife "$CI_YML" "$d/bau_yaml.sh")
    if [ "$zb" -lt 3 ]; then rot "Bau-Schleife (for L in de en ... done; done) fehlt in $CI_YML ($zb Zeilen)"; else
        stand "$Y1" || { rot "Stand Y1 (o)"; return; }
        fahre_block "$d/bau_yaml.sh" "$d/out_o" PATH="$P24_PATH" SOURCE_DATE_EPOCH="$T1"; rc=$?; zeige "$d/out_o"
        erw_rc "$rc" 0
        nb_=$(cat "$MODUL"/diplomarbeit-*.pdf | grep -a -c ' neubau$')
        erw_gleich "$nb_" 4 "vier Fassungen neu gebaut trotz ausgecheckter 289-Kopien (rm -f + latexmk -g, C4-09)"
    fi
    # (s) C4-08 b (r6) / r8 L7-01: Block SCHALTER-346 (Hauptpatch: Sprach-Schalter, /ID-Kardinalitaet, Seitenzahl) +
    # Block UMFANG-346 (Koppelpatch r8: Umfang-Regeln de/en). Ohne UMFANG-346 entfallen die Umfang-Unterfaelle LAUT.
    zs=$(extrahiere_block "$CI_YML" SCHALTER-346 "$d/schalter.sh")
    zu=$(extrahiere_block "$CI_YML" UMFANG-346 "$d/umfang.sh")
    if [ "$zs" -lt 3 ]; then rot "Block SCHALTER-346 fehlt in $CI_YML ($zs Zeilen) -- kein Schalter-Nachweis"; else
        cat "$d/epoch.sh" "$d/bau.sh" "$d/schalter.sh" > "$d/lauf_s.sh"
        cat "$d/epoch.sh" "$d/bau.sh" "$d/schalter.sh" "$d/umfang.sh" > "$d/lauf_su.sh"
        # (s0) L7-01 (r8): d32cc492-Fake -- de-kurz == de-lang und en-kurz == en-lang (ID-frei, Seiten gleich): der
        # Hauptpatch-Block ALLEIN muss GRUEN bleiben (am r7-Block: FEHLER 'wirkungslos (de)' rc=1 = Gitlink-Kopplung).
        stand "$Y1" || { rot "Stand Y1 (s0)"; return; }
        fahre_block "$d/lauf_s.sh" "$d/out_s0" PATH="$P24_PATH" BAU_MARKE=writeback1 BAU_GLEICH=1 BAU_EN_GLEICH=1 \
            BAU_S_DE_KURZ=100 BAU_S_EN_KURZ=100; rc=$?; zeige "$d/out_s0"
        erw_rc "$rc" 0; erw_text "$d/out_s0" "Sprach-Schalter nachgewiesen (4 Paare"; erw_kein_text "$d/out_s0" "FEHLER"
        erw_kein_text "$d/out_s0" "Umfang de nachgewiesen"
        # (s6) Sprachpaar: en-lang = de-lang bis auf die /ID-Zeile -> FEHLER 'Sprach-Schalter wirkungslos' (m28, m31)
        stand "$Y1" || { rot "Stand Y1 (s6)"; return; }
        fahre_block "$d/lauf_s.sh" "$d/out_s6" PATH="$P24_PATH" BAU_MARKE=writeback1 BAU_SPRACHE_GLEICH=1; rc=$?
        zeige "$d/out_s6"
        erw_rc "$rc" 1; erw_text "$d/out_s6" "Sprach-Schalter wirkungslos: de_lang:en_lang"
        erw_kein_text "$d/out_s6" "6 Paare"
        # (s7)/(s8) C7-01 (r8): Fake-PDFs mit 0 bzw. 2 '/ID ['-Zeilen -> FEHLER '/ID-Zeilen n != 1' rc=1 (am r7-Block:
        # ungefiltert bzw. mehrdeutig gehasht, rc=0)
        stand "$Y1" || { rot "Stand Y1 (s7)"; return; }
        fahre_block "$d/lauf_s.sh" "$d/out_s7" PATH="$P24_PATH" BAU_MARKE=writeback1 BAU_ID_N=0; rc=$?
        zeige "$d/out_s7"
        erw_rc "$rc" 1; erw_text "$d/out_s7" "FEHLER: /ID-Zeilen 0 != 1 in diplomarbeit-de-lang.pdf"
        erw_kein_text "$d/out_s7" "Sprach-Schalter nachgewiesen"
        stand "$Y1" || { rot "Stand Y1 (s8)"; return; }
        fahre_block "$d/lauf_s.sh" "$d/out_s8" PATH="$P24_PATH" BAU_MARKE=writeback1 BAU_ID_N=2; rc=$?
        zeige "$d/out_s8"
        erw_rc "$rc" 1; erw_text "$d/out_s8" "FEHLER: /ID-Zeilen 2 != 1 in diplomarbeit-de-lang.pdf"
        # (s9) C7-07 (r8): einseitige Fassung -- das pdfTeX-Log schreibt '(1 page,' (Singular): Seitenzahl 1 gelesen,
        # rc=0 (am r7-Block: ERE 'pages' trifft nicht -> FEHLER '0-mal statt 1x')
        stand "$Y1" || { rot "Stand Y1 (s9)"; return; }
        fahre_block "$d/lauf_s.sh" "$d/out_s9" PATH="$P24_PATH" BAU_MARKE=writeback1 BAU_S_EN_KURZ=1; rc=$?
        zeige "$d/out_s9"
        erw_rc "$rc" 0; erw_kein_text "$d/out_s9" "FEHLER"
        n9=$(grep -c -E 'diplomarbeit-en-kurz\.pdf .* Seiten 1$' "$d/out_s9")
        erw_gleich "$n9" 1 "Seitenzahl 1 aus '(1 page,' gelesen (C7-07)"
        if [ "$zu" -lt 3 ]; then
            echo "      [ENTFAELLT] (s1)(s2)(s3a)(s3b)(s5)(s5b) Block UMFANG-346 fehlt (Koppelpatch r8 nicht gelandet)"
        else
        stand "$Y1" || { rot "Stand Y1 (s1)"; return; }
        fahre_block "$d/lauf_su.sh" "$d/out_s1" PATH="$P24_PATH" BAU_MARKE=writeback1; rc=$?; zeige "$d/out_s1"
        erw_rc "$rc" 0; erw_text "$d/out_s1" "Umfang de nachgewiesen"; erw_text "$d/out_s1" "Umfang en nachgewiesen"
        erw_text "$d/out_s1" "6 Paare ID-frei verschieden"; erw_kein_text "$d/out_s1" "FEHLER"
        stand "$Y1" || { rot "Stand Y1 (s2)"; return; }
        fahre_block "$d/lauf_su.sh" "$d/out_s2" PATH="$P24_PATH" BAU_MARKE=writeback1 BAU_GLEICH=1; rc=$?
        zeige "$d/out_s2"
        erw_rc "$rc" 1; erw_text "$d/out_s2" "Umfang-Schalter wirkungslos (de)"; erw_kein_text "$d/out_s2" "6 Paare"
        # (s3a) L6-01 (r7, MUSS): de-kurz = de-lang bis auf die jobname-abhaengige /ID-Zeile, Seiten gleich -> das
        # r6-Gate (rohe sha256) sagt 'paarweise verschieden' rc=0; r7 ID-frei: FEHLER 'wirkungslos (de)'.
        stand "$Y1" || { rot "Stand Y1 (s3a)"; return; }
        fahre_block "$d/lauf_su.sh" "$d/out_s3a" PATH="$P24_PATH" BAU_MARKE=writeback1 BAU_GLEICH=1 \
            BAU_S_DE_KURZ=100; rc=$?; zeige "$d/out_s3a"
        erw_rc "$rc" 1; erw_text "$d/out_s3a" "Umfang-Schalter wirkungslos (de): ID-freier Hash lang == kurz"
        erw_kein_text "$d/out_s3a" "paarweise verschieden"
        n_id=$(grep -c '^/ID \[' "$MODUL/diplomarbeit-de-kurz.pdf"); erw_gleich "$n_id" 1 "Nenner: /ID-Zeile in de-kurz"
        if cmp -s "$MODUL/diplomarbeit-de-lang.pdf" "$MODUL/diplomarbeit-de-kurz.pdf"; then
            rot "Nenner: de-lang und de-kurz sind roh byte-gleich (die /ID-Zeile fehlt)"
        else ok "Nenner: de-lang und de-kurz roh byte-verschieden (nur /ID), ID-frei gleich"; fi
        # (s3b) EN-Paar gleich (EN-kurz = EN-lang, #270) -> kanonisches Literal als EIGENE Zeile (byte-genau, C7-02a),
        # Diagnose danach, '5 von 6 Paaren' statt '6 Paare' (L7-02 = C7-02b), rc=0, de bleibt nachgewiesen
        stand "$Y1" || { rot "Stand Y1 (s3b)"; return; }
        fahre_block "$d/lauf_su.sh" "$d/out_s3b" PATH="$P24_PATH" BAU_MARKE=writeback1 BAU_EN_GLEICH=1 \
            BAU_S_EN_KURZ=100; rc=$?; zeige "$d/out_s3b"
        erw_rc "$rc" 0; erw_text "$d/out_s3b" "Umfang de nachgewiesen"; erw_kein_text "$d/out_s3b" "FEHLER"
        nl=$(grep -c -x -F 'UMFANG en NICHT NACHGEWIESEN (EN-kurz ausstehend, Board #270)' "$d/out_s3b")
        erw_gleich "$nl" 1 "kanonisches Literal als eigene Zeile (byte-genau, C7-02a)"
        erw_text "$d/out_s3b" "5 von 6 Paaren ID-frei verschieden, EN-Paar gleich (Zustand)"
        erw_kein_text "$d/out_s3b" "6 Paare ID-frei verschieden"
        # (s5) de: Hash verschieden, aber Seiten kurz >= lang -> FEHLER; (s5b) en: Hash verschieden, Seiten gleich
        # -> FEHLER 'inkonsistent' (kein stilles Gruen ausserhalb der zwei erlaubten Kombinationen)
        stand "$Y1" || { rot "Stand Y1 (s5)"; return; }
        fahre_block "$d/lauf_su.sh" "$d/out_s5" PATH="$P24_PATH" BAU_MARKE=writeback1 BAU_S_DE_KURZ=100; rc=$?
        zeige "$d/out_s5"
        erw_rc "$rc" 1; erw_text "$d/out_s5" "Umfang-Schalter wirkungslos (de): Seiten kurz 100 >= lang 100"
        stand "$Y1" || { rot "Stand Y1 (s5b)"; return; }
        fahre_block "$d/lauf_su.sh" "$d/out_s5b" PATH="$P24_PATH" BAU_MARKE=writeback1 BAU_S_EN_KURZ=100; rc=$?
        zeige "$d/out_s5b"
        erw_rc "$rc" 1; erw_text "$d/out_s5b" "Umfang-Schalter en inkonsistent"
        erw_kein_text "$d/out_s5b" "UMFANG en NICHT"
        fi
    fi
    # (c1) C6-01 (r7): 288-Bau traegt eine CreationDate != SOURCE_DATE_EPOCH, keine 289-Kopie (Stand X1) -> am
    # r6-Block '0 von 4 vorhanden' rc=0 (Epoch nie gegen den eigenen Bau geprueft); r7: FEHLER rc=1.
    stand "$X1" || { rot "Stand X1 (c1)"; return; }
    fahre_block "$d/lauf.sh" "$d/out_c1" PATH="$P24_PATH" BAU_MARKE=neu BAU_CD_EPOCH=1758600999; rc=$?
    zeige "$d/out_c1"
    erw_rc "$rc" 1; erw_text "$d/out_c1" "CreationDate 1758600999 != SOURCE_DATE_EPOCH"
    erw_kein_text "$d/out_c1" "0 von 4 Fassungen am Gitlink vorhanden"
    # (q) C6-12 (r7): die main=-Zeile + FEHLER-Zeile der YAML in einem Verzeichnis ohne documentclass -- unter
    # bash -e -o pipefail muss die FEHLER-Zeile erreichbar sein (am r6-Stand: stiller rc=1 der leeren Pipe).
    mkdir -p "$d/q" || { rot "Wegwerf-q nicht anlegbar"; return; }
    printf '%s\n' '\\usepackage{x}' > "$d/q/x.tex"
    awk 'index($0, "main=$(grep -lE") > 0 { print substr($0, 7); getline; print substr($0, 7) }' "$CI_YML" > "$d/q.sh"
    zq=$(awk 'END{print NR}' "$d/q.sh")
    if [ "$zq" -ne 2 ]; then rot "main=-Zeile der YAML nicht extrahierbar ($zq Zeilen)"; else
        ( cd "$d/q" && env -i PATH="$PATH" HOME="$HOME" bash -e -o pipefail "$d/q.sh" ) > "$d/out_q" 2>&1; rc=$?
        zeige "$d/out_q"; erw_rc "$rc" 1; erw_text "$d/out_q" "FEHLER: kein documentclass"
    fi
    # (p) C4-08 a (r6): Block F09-GATE-346 (Koppelpatch, nur mit dem Gitlink-Bump gelandet): Konsumstelle NUR im
    # TeX-Kommentar = FEHLER rc=1; echte Konsumstelle = rc=0. Ohne den Block entfaellt der Unterfall LAUT.
    zf=$(extrahiere_block "$CI_YML" F09-GATE-346 "$d/f09.sh")
    if [ "$zf" -lt 3 ]; then echo "      [ENTFAELLT] (p) Block F09-GATE-346 fehlt (Koppelpatch nicht gelandet)"; else
        stand "$X1" && git -C "$MODUL" checkout -q -B f09k "$X1" || { rot "Zweig f09k nicht setzbar"; return; }
        printf '%s\n' '\documentclass{article}' '% \thesislang \thesisumfang im Kommentar' > "$MODUL/diplomarbeit.tex"
        git -C "$MODUL" add diplomarbeit.tex && modul_commit 1758600286 "F09k Konsumstelle nur im Kommentar" \
            || { rot "Commit F09k"; return; }
        F09K=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse F09k"; return; }
        stand "$F09K" || { rot "Stand F09k"; return; }
        fahre_block "$d/f09.sh" "$d/out_p1"; rc=$?; zeige "$d/out_p1"
        erw_rc "$rc" 1; erw_text "$d/out_p1" "kein Konsum von"
        git -C "$MODUL" checkout -q -B f09e "$X1" || { rot "Zweig f09e nicht setzbar"; return; }
        printf '%s\n' '\documentclass{article}' '\providecommand{\thesislang}{de}' \
            '\providecommand{\thesisumfang}{lang}' '\ifx\thesislang\undefined\fi' '\ifx\thesisumfang\undefined\fi' \
            > "$MODUL/diplomarbeit.tex"
        git -C "$MODUL" add diplomarbeit.tex && modul_commit 1758600288 "F09e Definition plus Konsum" \
            || { rot "Commit F09e"; return; }
        F09E=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse F09e"; return; }
        stand "$F09E" || { rot "Stand F09e"; return; }
        fahre_block "$d/f09.sh" "$d/out_p2"; rc=$?; zeige "$d/out_p2"
        erw_rc "$rc" 0; erw_kein_text "$d/out_p2" "FEHLER"
        # (p3) C6-02 a (r7): NUR Definitionen (\providecommand), kein Konsum -> FEHLER (am r6-Gate zaehlte die
        # Definitionszeile als Konsum: rc=0 = Placebo-Klasse, Triage 35 C6-02)
        git -C "$MODUL" checkout -q -B f09d "$X1" || { rot "Zweig f09d nicht setzbar"; return; }
        printf '%s\n' '\documentclass{article}' '\providecommand{\thesislang}{de}' \
            '\providecommand{\thesisumfang}{lang}' > "$MODUL/diplomarbeit.tex"
        git -C "$MODUL" add diplomarbeit.tex && modul_commit 1758600290 "F09d nur Definitionen" \
            || { rot "Commit F09d"; return; }
        F09D=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse F09d"; return; }
        stand "$F09D" || { rot "Stand F09d"; return; }
        fahre_block "$d/f09.sh" "$d/out_p3"; rc=$?; zeige "$d/out_p3"
        erw_rc "$rc" 1; erw_text "$d/out_p3" "kein Konsum von"
        # (p4)/(p5)/(p6) C7-05 (r8): Praefix-Konsum '\thesislangAlt' (Control-Word-Grenze), '\newcommand*{...}' und
        # '\def \thesislang' als reine Definitionen -> je FEHLER rc=1 (am r7-Gate gezaehlt = rc=0)
        for pv in "p4:\\thesislangAlt \\thesisumfangAlt" \
                  "p5:\\newcommand*{\\thesislang}{de} \\newcommand*{\\thesisumfang}{lang}" \
                  "p6:\\def \\thesislang{de} \\def \\thesisumfang{lang}"; do
            nm=${pv%%:*}; zeile=${pv#*:}
            git -C "$MODUL" checkout -q -B "f09$nm" "$X1" || { rot "Zweig f09$nm nicht setzbar"; return; }
            printf '%s\n' '\documentclass{article}' '\providecommand{\thesislang}{de}' \
                '\providecommand{\thesisumfang}{lang}' "$zeile" > "$MODUL/diplomarbeit.tex"
            git -C "$MODUL" add diplomarbeit.tex && modul_commit 1758600292 "F09$nm $nm" \
                || { rot "Commit F09$nm"; return; }
            stand "$(git -C "$MODUL" rev-parse HEAD)" || { rot "Stand F09$nm"; return; }
            fahre_block "$d/f09.sh" "$d/out_$nm"; rc=$?; zeige "$d/out_$nm"
            erw_rc "$rc" 1; erw_text "$d/out_$nm" "kein Konsum von"
        done
    fi
    # (j)/(k)/(l) O-15 (b) (Owner-Order 455, r15): Font-Stand-Kennung aus '/Length1 N' (+ Length2/3) der Fake-PDFs
    # (Nenner: jede Fake-PDF traegt 3 Length-Zeilen, FONT_STD). (j) 289-Kopie mit anderem Font-Stand bei gleichem Epoch
    # und gleicher Fullbanner-Kennung -> Zustand (3) 'Font-Stand abweichend (O-15b)' rc=0, kein Byte-Urteil (am r14-
    # Block: Byte-Urteil -> FEHLER DRIFT rc=1); (k) eigener 288-Bau ohne Length1 -> FEHLER 'keine eingebetteten Font-
    # Programme' rc=1; (l) 289-Kopie ohne Length1 -> Zustand (3) 'Font-Stand nicht lesbar' rc=0, kein Byte-Urteil.
    stand "$X1" && git -C "$MODUL" checkout -q -B fnt "$X1" || { rot "Zweig fnt nicht setzbar"; return; }
    LEGE_FONT="$FONT_ALT"; lege_pdf_epoch "$MODUL" "$T1" writeback1; unset LEGE_FONT
    git -C "$MODUL" add -- diplomarbeit-*.pdf && modul_commit 1758600284 "Y1t writeback anderer Font-Stand [skip ci]" \
        || { rot "Commit Y1t"; return; }
    Y1T=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse Y1t"; return; }
    n_=$(git -C "$MODUL" show "$Y1T:diplomarbeit-de-lang.pdf" | grep -a -c '/Length[123] ')
    erw_gleich "$n_" 3 "Nenner: Length-Zeilen in der 289-Kopie (j)"
    stand "$Y1T" || { rot "Stand Y1t"; return; }
    fahre_block "$d/lauf.sh" "$d/out_j" PATH="$P24_PATH" BAU_MARKE=writeback1; rc=$?; zeige "$d/out_j"
    erw_rc "$rc" 0; erw_text "$d/out_j" "Font-Stand abweichend"; erw_text "$d/out_j" "O-15b"
    erw_text "$d/out_j" "4 veraltet/abweichend"; erw_text "$d/out_j" "0 byte-gleich geprueft"
    erw_kein_text "$d/out_j" "FEHLER"
    stand "$Y1" || { rot "Stand Y1 (k)"; return; }                             # (k) 288-Bau ohne Length1
    fahre_block "$d/lauf.sh" "$d/out_k" PATH="$P24_PATH" BAU_MARKE=writeback1 BAU_FONT=; rc=$?; zeige "$d/out_k"
    erw_rc "$rc" 1; erw_text "$d/out_k" "FEHLER: keine eingebetteten Font-Programme im 288-Bau"
    erw_kein_text "$d/out_k" "byte-gleich zur 289-Kopie"
    stand "$X1" && git -C "$MODUL" checkout -q -B nofnt "$X1" || { rot "Zweig nofnt nicht setzbar"; return; }
    LEGE_FONT=; lege_pdf_epoch "$MODUL" "$T1" writeback1; unset LEGE_FONT
    git -C "$MODUL" add -- diplomarbeit-*.pdf && modul_commit 1758600286 "Y1u writeback ohne Font-Stand [skip ci]" \
        || { rot "Commit Y1u"; return; }
    Y1U=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse Y1u"; return; }
    n_=$(git -C "$MODUL" show "$Y1U:diplomarbeit-de-lang.pdf" | grep -a -c '/Length[123] ')
    erw_gleich "$n_" 0 "Nenner: Length-Zeilen in der 289-Kopie (l)"
    stand "$Y1U" || { rot "Stand Y1u"; return; }
    fahre_block "$d/lauf.sh" "$d/out_l" PATH="$P24_PATH" BAU_MARKE=writeback1; rc=$?; zeige "$d/out_l"
    erw_rc "$rc" 0; erw_text "$d/out_l" "Font-Stand nicht lesbar"; erw_text "$d/out_l" "4 veraltet/abweichend"
    erw_text "$d/out_l" "0 byte-gleich geprueft"; erw_kein_text "$d/out_l" "FEHLER"
    # (r) C15-02 (r16): 289-Kopie mit fremdem Fullbanner (Stand Y1f) UND 288-Bau ohne Length1 -> die Zustandszeile
    # 'Toolchain abweichend' steht VOR dem 288-Font-FEHLER (O-15 (b): Fullbanner-Vergleich -> Font-Stand 288 -> 289);
    # rc bleibt 1 (Selbstpruefung fail-closed, auch ohne vergleichbare Kopie). Am r15-Block: FEHLER zuerst, keine
    # Zustandszeile (die 288-Messung stand vor dem Fullbanner-Vergleich).
    stand "$Y1F" || { rot "Stand Y1f (r)"; return; }
    fahre_block "$d/lauf.sh" "$d/out_r" PATH="$P24_PATH" BAU_MARKE=writeback1 BAU_BANNER="$B288" BAU_FONT=; rc=$?
    zeige "$d/out_r"; erw_rc "$rc" 1; erw_text "$d/out_r" "Toolchain abweichend"
    erw_text "$d/out_r" "FEHLER: keine eingebetteten Font-Programme im 288-Bau"
    zt=$(grep -n -m1 -F 'Toolchain abweichend' "$d/out_r" | cut -d: -f1)
    zf=$(grep -n -m1 -F 'Font-Programme im 288-Bau' "$d/out_r" | cut -d: -f1)
    if [ -n "$zt" ] && [ -n "$zf" ] && [ "$zt" -lt "$zf" ]; then
        ok "Reihenfolge: Toolchain-Zeile $zt vor 288-Font-FEHLER $zf (C15-02)"
    else
        rot "Reihenfolge: Toolchain-Zeile '$zt' nicht vor 288-Font-FEHLER '$zf' (C15-02)"
    fi
}
fall_P25() { # L2-05: '//', '/./' und '/.' im Ziel werden gefaltet -> PUSH OK statt 'kein Stage-0-Eintrag'
    s="$1"; d="$T/P25"
    for var in "docs//diplomarbeit" "docs/./diplomarbeit" "docs/diplomarbeit/."; do
        sub="$d/$(printf '%s' "$var" | tr '/.' '__')"
        baue_seed "$sub" || { rot "Wegwerf-Remote nicht baubar"; return; }
        klone "$sub/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$sub/work" v1
        lauf "$sub/work" "$s" "$sub/out" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_DIR="$var"; rc=$?
        zeige "$sub/out"; erw_rc "$rc" 0; erw_text "$sub/out" "PUSH OK (ci.skip)"
        erw_kein_text "$sub/out" "kein Stage-0-Eintrag"
        t=$(tip); n=$(git -C "$BARE" ls-tree --name-only "$t" docs/diplomarbeit/ | grep -c 'diplomarbeit-.*\.pdf$')
        erw_gleich "$n" 4 "PDF-Dateien unter docs/diplomarbeit/ im Bare-Tip (DIR='$var')"
    done
}
fall_P26() { # L2-06: doppelte Fassung wird beim Namen genannt, nichts gepusht
    s="$1"; d="$T/P26"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" \
        COMDARE_THESIS_PDF_FASSUNGEN='de-lang de-lang'
    rc=$?; zeige "$d/out"; erw_rc "$rc" 1; erw_text "$d/out" "Eintrag 2 doppelt in COMDARE_THESIS_PDF_FASSUNGEN"
    erw_kein_text "$d/out" "Zieldateien stehen im Index"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P27() { # L2-08: CI_SERVER_URL ohne https:// -> FEHLER vor jedem Transport, Token in 0 Zeilen
    s="$1"; d="$T/P27"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out" "$BASE" CI_SERVER_URL=http://127.0.0.1:9 CI_PROJECT_PATH=gruppe/projekt \
        COMDARE_WRITEBACK_USER=ciuser COMDARE_WRITEBACK_TOKEN="$KOEDER" GIT_TRACE=1; rc=$?
    erw_rc "$rc" 1; erw_text "$d/out" "ist nicht https://"
    erw_kein_text "$d/out" "remote-http"   # kein Transport-Aufruf (weder http noch https)
    erw_kein_text "$d/out" "$KOEDER"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P28() { # C6-04 (r7): disjunkter Fremdstand -- Mensch bewegt en-kurz, Job exportiert alle vier (nur de-lang neu)
    s="$1"; d="$T/P28"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/workA" "$BASE" || { rot "Klon A nicht baubar"; return; }; lege_pdfs "$d/workA" v1
    lauf "$d/workA" "$s" "$d/outA" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" \
        || { rot "Vorlauf-Export (v1) fehlgeschlagen"; zeige "$d/outA"; return; }
    S=$(tip); klone "$d/workB" "$S" || { rot "Klon B nicht baubar"; return; }
    lege_pdfs "$d/workB" v1; lege_pdfs "$d/workB" v2 de-lang
    mensch_pdf "$d/h" en-kurz HUMAN || { rot "Mensch-Commit en-kurz fehlgeschlagen"; return; }; H=$(tip)
    lauf "$d/workB" "$s" "$d/out" "$S" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 0; erw_text "$d/out" "UEBERHOLT: Fassung docs/diplomarbeit/diplomarbeit-en-kurz.pdf"
    erw_kein_text "$d/out" "PUSH OK"
    t=$(tip); erw_gleich "$t" "$H" "Bare-Tip = Mensch-Commit (kein Mischstand gepusht)"
    v=$(git -C "$BARE" show "$t:docs/diplomarbeit/diplomarbeit-en-kurz.pdf" | grep -c ' HUMAN$')
    erw_gleich "$v" 1 "en-kurz am Remote bleibt der Mensch-Stand"
}
fall_P29() { # C6-08 (r7): Quelle ueber getrackten Zwischen-Symlink thesis/ext -> ../../aussen -> FEHLER, kein Push
    s="$1"; d="$T/P29"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    git clone -q "$BARE" "$d/prep" || { rot "Klon prep nicht baubar"; return; }
    mkdir -p "$d/prep/thesis" "$d/aussen/pdf"; ln -s ../../aussen "$d/prep/thesis/ext"
    git -C "$d/prep" add thesis/ext && git -C "$d/prep" commit -q -m "zwischen-symlink quelle" \
        && git -C "$d/prep" push -q "$BARE" development || { rot "Symlink-Commit fehlgeschlagen"; return; }
    S=$(tip); klone "$d/work" "$S" || { rot "Klon nicht baubar"; return; }
    [ -L "$d/work/thesis/ext" ] || { rot "Zwischen-Symlink im Klon fehlt (Nenner)"; return; }
    for f in de-lang en-lang de-kurz en-kurz; do
        printf '%%PDF-1.4\n%% aussen %s\n%%%%EOF\n' "$f" > "$d/aussen/pdf/diplomarbeit-$f.pdf"
    done
    lauf "$d/work" "$s" "$d/out" "$S" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_SRC="thesis/ext/pdf"
    rc=$?; zeige "$d/out"; erw_rc "$rc" 1; erw_text "$d/out" "(Quelle) liegt ausserhalb des Arbeitsbaums"
    erw_kein_text "$d/out" "PUSH OK"; t=$(tip); erw_gleich "$t" "$S" "Bare-Tip unveraendert"
}
fall_P30() { # C6-13 (r7): Tippfehler im Schalter = FEHLER statt gruener INERT-Job; false bleibt INERT
    s="$1"; d="$T/P30"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out1" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_EXPORT=fasle; rc=$?
    zeige "$d/out1"; erw_rc "$rc" 1; erw_text "$d/out1" "Wert nicht in {true,false}"
    erw_kein_text "$d/out1" "INERT"
    lauf "$d/work" "$s" "$d/out2" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_EXPORT=false; rc=$?
    zeige "$d/out2"; erw_rc "$rc" 0; erw_text "$d/out2" "INERT"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert (0 Commits)"
}
fall_P31() { # C6-07 (r7): --ci verweigert den Testhaken bedingungslos; fremdes Argument = FEHLER
    s="$1"; d="$T/P31"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    LAUF_ARGS=--ci
    lauf "$d/work" "$s" "$d/out1" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; LAUF_ARGS=""
    zeige "$d/out1"; erw_rc "$rc" 1; erw_text "$d/out1" "im Modus --ci verweigert"; erw_kein_text "$d/out1" "PUSH OK"
    LAUF_ARGS="--ci --foo"
    lauf "$d/work" "$s" "$d/out2" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; LAUF_ARGS=""
    zeige "$d/out2"; erw_rc "$rc" 1; erw_text "$d/out2" "Argument 2 unbekannt"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}

# --------------------------------------------------------------------------- r8b (Codex-Lens r7 B: S7-01..S7-08)
vorlauf_v1() { # $1 = Fallverzeichnis, $2 = Script: Erstexport v1 aus workA; danach S = Tip; rc 2 bei Fehlschlag
    baue_seed "$1" || { rot "Wegwerf-Remote nicht baubar"; return 2; }
    klone "$1/workA" "$BASE" || { rot "Klon A nicht baubar"; return 2; }; lege_pdfs "$1/workA" v1
    lauf "$1/workA" "$2" "$1/outA" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" \
        || { rot "Vorlauf-Export (v1) fehlgeschlagen"; zeige "$1/outA"; return 2; }
    S=$(tip)
}
fremd_eintrag() { # $1 = Klonpfad, $2 = modus|symlink|loeschen: en-kurz am Remote als fremder Tree-Eintrag, gepusht
    git clone -q "$BARE" "$1" || return 2
    _f=docs/diplomarbeit/diplomarbeit-en-kurz.pdf
    case "$2" in
        modus) git -C "$1" update-index --chmod=+x "$_f" || return 2 ;;
        symlink) rm -f "$1/$_f" && ln -s diplomarbeit-en-lang.pdf "$1/$_f" && git -C "$1" add -- "$_f" || return 2 ;;
        loeschen) git -C "$1" rm -q -- "$_f" || return 2 ;;
        *) return 2 ;;
    esac
    git -C "$1" commit -q -m "fremd $2 en-kurz" || return 2
    git -C "$1" push -q "$BARE" development || return 2
}
readme_unter_dir() { # $1 = Klonpfad, $2 = Text: getrackte Fremddatei docs/diplomarbeit/README.md am Remote, gepusht
    git clone -q "$BARE" "$1" || return 2
    mkdir -p "$1/docs/diplomarbeit" && echo "$2" >> "$1/docs/diplomarbeit/README.md" || return 2
    git -C "$1" add -- docs/diplomarbeit/README.md && git -C "$1" commit -q -m "readme unter DIR: $2" || return 2
    git -C "$1" push -q "$BARE" development || return 2
}
netzsperre() { # $1 = Datei: git-Konfiguration, die JEDE http(s)-URL auf einen toten lokalen Pfad umbiegt (kein Netz)
    printf '[url "/dev/null/netzsperre/"]\n\tinsteadOf = https://\n' > "$1"
    printf '[url "/dev/null/netzsperre/"]\n\tinsteadOf = http://\n' >> "$1"
}
fall_P32() { # S7-01 (r8b): Remote setzt en-kurz auf Modus 100755 bei gleichem Blob -> UEBERHOLT, kein Push
    s="$1"; d="$T/P32"; vorlauf_v1 "$d" "$s" || return
    klone "$d/workB" "$S" || { rot "Klon B nicht baubar"; return; }
    lege_pdfs "$d/workB" v1; lege_pdfs "$d/workB" v2 de-lang
    fremd_eintrag "$d/h" modus || { rot "Fremd-Eintrag (Modus) fehlgeschlagen"; return; }; H=$(tip)
    m=$(git -C "$BARE" ls-tree "$H" -- docs/diplomarbeit/diplomarbeit-en-kurz.pdf | cut -d' ' -f1)
    erw_gleich "$m" 100755 "Vorbedingung: Modus am Remote"
    lauf "$d/workB" "$s" "$d/out" "$S" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 0; erw_text "$d/out" "am Remote als blob/100755 statt blob/100644"; erw_text "$d/out" "S7-01"
    erw_kein_text "$d/out" "PUSH OK"
    t=$(tip); erw_gleich "$t" "$H" "Bare-Tip = Fremd-Commit (kein Mischstand gepusht)"
}
fall_P33() { # S7-01 (r8b): Remote ersetzt en-kurz durch einen Symlink -> UEBERHOLT als Typwechsel, kein Push
    s="$1"; d="$T/P33"; vorlauf_v1 "$d" "$s" || return
    klone "$d/workB" "$S" || { rot "Klon B nicht baubar"; return; }
    lege_pdfs "$d/workB" v1; lege_pdfs "$d/workB" v2 de-lang
    fremd_eintrag "$d/h" symlink || { rot "Fremd-Eintrag (Symlink) fehlgeschlagen"; return; }; H=$(tip)
    m=$(git -C "$BARE" ls-tree "$H" -- docs/diplomarbeit/diplomarbeit-en-kurz.pdf | cut -d' ' -f1)
    erw_gleich "$m" 120000 "Vorbedingung: Modus am Remote"
    lauf "$d/workB" "$s" "$d/out" "$S" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 0; erw_text "$d/out" "am Remote als blob/120000 statt blob/100644"; erw_text "$d/out" "S7-01"
    erw_kein_text "$d/out" "PUSH OK"
    t=$(tip); erw_gleich "$t" "$H" "Bare-Tip = Fremd-Commit (kein Mischstand gepusht)"
}
fall_P34() { # S7-02 (r8b): Remote loescht en-kurz, lokal unveraendert -> UEBERHOLT rc=0 mit Pfad + FERN, kein FEHLER
    s="$1"; d="$T/P34"; vorlauf_v1 "$d" "$s" || return
    klone "$d/workB" "$S" || { rot "Klon B nicht baubar"; return; }
    lege_pdfs "$d/workB" v1; lege_pdfs "$d/workB" v2 de-lang
    fremd_eintrag "$d/h" loeschen || { rot "Fremd-Eintrag (Loeschung) fehlgeschlagen"; return; }; H=$(tip)
    m=$(git -C "$BARE" ls-tree "$H" -- docs/diplomarbeit/diplomarbeit-en-kurz.pdf | wc -l)
    erw_gleich "$m" 0 "Vorbedingung: en-kurz am Remote geloescht"
    lauf "$d/workB" "$s" "$d/out" "$S" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 0
    erw_text "$d/out" "UEBERHOLT: Fassung docs/diplomarbeit/diplomarbeit-en-kurz.pdf am Remote geloescht"
    erw_text "$d/out" "S7-02"; erw_kein_text "$d/out" "FEHLER"; erw_kein_text "$d/out" "PUSH OK"
    t=$(tip); erw_gleich "$t" "$H" "Bare-Tip = Fremd-Commit"
}
fall_P35() { # S7-03 (r8b) (a): fremde getrackte Datei unter DIR lokal geaendert -> FEHLER, nichts committet/gepusht
    s="$1"; d="$T/P35"; vorlauf_v1 "$d" "$s" || return
    readme_unter_dir "$d/h" notiz || { rot "README unter DIR nicht anlegbar"; return; }; S2=$(tip)
    klone "$d/workB" "$S2" || { rot "Klon B nicht baubar"; return; }
    lege_pdfs "$d/workB" v1; lege_pdfs "$d/workB" v2 de-lang
    echo "lokal geaendert" >> "$d/workB/docs/diplomarbeit/README.md"
    lauf "$d/workB" "$s" "$d/out" "$S2" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 1; erw_text "$d/out" "ausserhalb der Fassungs-Liste"; erw_text "$d/out" "S7-03"
    erw_kein_text "$d/out" "PUSH OK"
    t=$(tip); erw_gleich "$t" "$S2" "Bare-Tip unveraendert"
    v=$(git -C "$BARE" show "$t:docs/diplomarbeit/README.md" | grep -c 'lokal geaendert')
    erw_gleich "$v" 0 "README am Remote ohne die lokale Aenderung"
}
fall_P36() { # S7-03 (r8b) (b): Remote traegt dieselben PDF-Bytes + README unter DIR -> UNVERAENDERT (remote), kein Push
    s="$1"; d="$T/P36"; vorlauf_v1 "$d" "$s" || return
    readme_unter_dir "$d/h" notiz || { rot "README unter DIR nicht anlegbar"; return; }; S2=$(tip)
    klone "$d/workB" "$BASE" || { rot "Klon B nicht baubar"; return; }; lege_pdfs "$d/workB" v1
    lauf "$d/workB" "$s" "$d/out" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 0; erw_text "$d/out" "UNVERAENDERT (remote)"; erw_kein_text "$d/out" "PUSH OK"
    t=$(tip); erw_gleich "$t" "$S2" "Bare-Tip unveraendert (kein Merge-Commit)"
}
fall_P37() { # S7-04 (r8b): CI_PROJECT_PATH fremd bzw. mit Query bei ID 288 -> FEHLER vor jedem Transport, ohne Wert
    s="$1"; d="$T/P37"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    netzsperre "$d/sperre"   # Gurt: kaeme das Script bis zum Push, traefe es einen toten lokalen Pfad, nie das Netz
    _i=0
    for v in gruppe/projekt 'gruppe/projekt?x=1'; do
        _i=$((_i+1))
        lauf "$d/work" "$s" "$d/out$_i" "$BASE" GIT_CONFIG_GLOBAL="$d/sperre" GIT_TRACE=1 \
            CI_SERVER_URL=https://gitlab.comdare.local CI_SERVER_HOST=gitlab.comdare.local CI_PROJECT_ID=288 \
            CI_PROJECT_PATH="$v" COMDARE_WRITEBACK_USER=ciuser COMDARE_WRITEBACK_TOKEN="$KOEDER"; rc=$?
        zeige "$d/out$_i"; erw_rc "$rc" 1; erw_text "$d/out$_i" "kanonischer Projektpfad (S7-04)"
        erw_kein_text "$d/out$_i" "gruppe/projekt"; erw_kein_text "$d/out$_i" "$KOEDER"
        erw_kein_text "$d/out$_i" "PUSH OK"
    done
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P38() { # S7-05 (r8b): drei Verweigerungspfade drucken den URL-Wert nicht (userinfo+Kennwort, http, fremder Host)
    s="$1"; d="$T/P38"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    netzsperre "$d/sperre"; KW=geheim-kw-4711
    lauf "$d/work" "$s" "$d/out1" "$BASE" GIT_CONFIG_GLOBAL="$d/sperre" CI_SERVER_URL="https://ciuser:$KW@127.0.0.1:9" \
        CI_SERVER_HOST=127.0.0.1 CI_PROJECT_ID=288 CI_PROJECT_PATH=gruppe/projekt COMDARE_WRITEBACK_USER=ciuser \
        COMDARE_WRITEBACK_TOKEN="$KOEDER"; rc=$?; zeige "$d/out1"
    erw_rc "$rc" 1; erw_text "$d/out1" "traegt userinfo, Query oder Fragment"
    erw_kein_text "$d/out1" "$KW"; erw_kein_text "$d/out1" "ciuser:"; erw_kein_text "$d/out1" "$KOEDER"
    lauf "$d/work" "$s" "$d/out2" "$BASE" GIT_CONFIG_GLOBAL="$d/sperre" CI_SERVER_URL=http://127.0.0.1:9 \
        CI_SERVER_HOST=127.0.0.1 CI_PROJECT_ID=288 CI_PROJECT_PATH=gruppe/projekt COMDARE_WRITEBACK_USER=ciuser \
        COMDARE_WRITEBACK_TOKEN="$KOEDER"; rc=$?; zeige "$d/out2"
    erw_rc "$rc" 1; erw_text "$d/out2" "ist nicht https://"; erw_kein_text "$d/out2" "127.0.0.1:9"
    lauf "$d/work" "$s" "$d/out3" "$BASE" GIT_CONFIG_GLOBAL="$d/sperre" CI_SERVER_URL=https://127.0.0.1:9 \
        CI_SERVER_HOST=gitlab.comdare.local CI_PROJECT_ID=288 CI_PROJECT_PATH=gruppe/projekt \
        COMDARE_WRITEBACK_USER=ciuser COMDARE_WRITEBACK_TOKEN="$KOEDER"; rc=$?; zeige "$d/out3"
    erw_rc "$rc" 1; erw_text "$d/out3" "zeigt nicht auf die Instanz"; erw_kein_text "$d/out3" "127.0.0.1:9"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P39() { # S7-06 (r8b): expliziter Leerwert der Schalter/Pfade ist kein Default -> FEHLER, nichts gepusht
    s="$1"; d="$T/P39"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out1" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_EXPORT=; rc=$?
    zeige "$d/out1"; erw_rc "$rc" 1; erw_text "$d/out1" "Wert nicht in {true,false}"; erw_kein_text "$d/out1" "PUSH OK"
    for v in DIR SRC FASSUNGEN; do
        lauf "$d/work" "$s" "$d/out_$v" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" "COMDARE_THESIS_PDF_$v="; rc=$?
        zeige "$d/out_$v"; erw_rc "$rc" 1; erw_text "$d/out_$v" "COMDARE_THESIS_PDF_$v ist gesetzt, aber leer"
        erw_kein_text "$d/out_$v" "PUSH OK"
    done
    # L8-01 (r9): Leerraum-Werte sind nicht leer, aber Fehlziele -> FEHLER; Fassungsnamen nur [A-Za-z0-9-]
    _i=0
    for kv in "COMDARE_THESIS_PDF_DIR= " "COMDARE_THESIS_PDF_DIR=  x" "COMDARE_THESIS_PDF_SRC= x"; do
        _i=$((_i+1))
        lauf "$d/work" "$s" "$d/out_l$_i" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" "$kv"; rc=$?; zeige "$d/out_l$_i"
        erw_rc "$rc" 1; erw_text "$d/out_l$_i" "Leerraum oder Steuerzeichen"; erw_kein_text "$d/out_l$_i" "PUSH OK"
    done
    lauf "$d/work" "$s" "$d/out_l4" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" "COMDARE_THESIS_PDF_FASSUNGEN=de lang"
    rc=$?; zeige "$d/out_l4"; erw_rc "$rc" 1; erw_text "$d/out_l4" "Eintrag 1 unbekannt"
    erw_kein_text "$d/out_l4" "PUSH OK"
    lauf "$d/work" "$s" "$d/out_l5" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" "COMDARE_THESIS_PDF_FASSUNGEN=de-lang;x"
    rc=$?; zeige "$d/out_l5"; erw_rc "$rc" 1; erw_text "$d/out_l5" "unzulaessiges Zeichen"
    erw_kein_text "$d/out_l5" "PUSH OK"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P40() { # S7-08 (r8b): Header-Test pipelinefrei -- unlesbare Quelle nennt den head-Fehler, nicht 'kein PDF'
    s="$1"; d="$T/P40"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    f="$d/work/thesis/diplomarbeit/diplomarbeit-en-kurz.pdf"; chmod 000 "$f"
    if [ -r "$f" ]; then rot "Vorbedingung: Quelle trotz chmod 000 lesbar (root?)"; chmod 644 "$f"; return; fi
    lauf "$d/work" "$s" "$d/out" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; chmod 644 "$f"; zeige "$d/out"
    erw_rc "$rc" 1; erw_text "$d/out" "head -c 5"; erw_text "$d/out" "S7-08"; erw_kein_text "$d/out" "PUSH OK"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P41() { # S7-08 (r8b): SIGTERM im Lauf -> rc=143 + Hilfsverzeichnis geraeumt (trap TERM -> exit -> EXIT-Trap)
    s="$1"; d="$T/P41"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    mkdir -p "$d/fake" "$d/tmpw"; echt=$(command -v git)
    { echo '#!/bin/sh'; echo "case \" \$* \" in *\" add \"*) : > '$d/marke'; sleep 3 ;; esac"
      echo "exec '$echt' \"\$@\""; } > "$d/fake/git"; chmod 755 "$d/fake/git"
    k=$(git -C "$d/work" rev-parse --short "$BASE")
    ( cd "$d/work" && exec env -i PATH="$d/fake:$PATH" HOME="$HOME" TMPDIR="$d/tmpw" GIT_CONFIG_GLOBAL=/dev/null \
        GIT_CONFIG_NOSYSTEM=1 CI_COMMIT_BRANCH=development CI_COMMIT_SHA="$BASE" CI_COMMIT_SHORT_SHA="$k" \
        CI_PIPELINE_ID=4711 COMDARE_THESIS_PDF_REMOTE="$BARE" sh "$s" ) > "$d/out" 2>&1 &
    pid=$!; i=0
    while [ ! -e "$d/marke" ] && [ "$i" -lt 100 ]; do sleep 0.1; i=$((i+1)); done
    if [ ! -e "$d/marke" ]; then
        rot "Vorbedingung: Fake-git wurde nicht erreicht"; kill "$pid" 2>/dev/null; wait "$pid"; return
    fi
    kill -TERM "$pid"; wait "$pid"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 143
    rest=$(ls -A "$d/tmpw" | wc -l); erw_gleich "$rest" 0 "Hilfsverzeichnisse unter TMPDIR nach SIGTERM"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}

# ------------------------------------------------ r9 (Codex-Lens r8 B S8-01..06, Fable L8-01, Codex A C8-06)
pdf_bytes() { printf '%%PDF-1.4\n%% fassung %s %s\n%%%%EOF\n' "$1" "$2"; } # dieselben Bytes wie lege_pdfs
fremd_pdf() { # $1 = Klonpfad, $2 = Pfad im Repo, $3 = Fassung, $4 = Marke: getrackte Fremd-PDF am Remote, gepusht
    git clone -q "$BARE" "$1" || return 2
    mkdir -p "$1/$(dirname "$2")" && pdf_bytes "$3" "$4" > "$1/$2" || return 2
    git -C "$1" add -- "$2" && git -C "$1" commit -q -m "fremd-pdf $2" || return 2
    git -C "$1" push -q "$BARE" development || return 2
}
fall_P42() { # S8-01 (a): DIR 'docs/*' + geloeschte Fremd-PDF (Rename-Blob); r10: S9-03 verwirft '*' VOR jeder git-Wache
    s="$1"; d="$T/P42"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    fremd_pdf "$d/h" 'docs/*/alt/diplomarbeit-de-lang.pdf' de-lang v1 || { rot "Fremd-PDF nicht anlegbar"; return; }
    S=$(tip); klone "$d/work" "$S" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    rm -f "$d/work/docs/*/alt/diplomarbeit-de-lang.pdf"
    lauf "$d/work" "$s" "$d/out" "$S" COMDARE_THESIS_PDF_REMOTE="$BARE" 'COMDARE_THESIS_PDF_DIR=docs/*' \
        COMDARE_THESIS_PDF_FASSUNGEN=de-lang; rc=$?; zeige "$d/out"
    erw_rc "$rc" 1; erw_text "$d/out" "unzulaessige Zeichen (S9-03)"
    erw_kein_text "$d/out" "PUSH OK"; t=$(tip); erw_gleich "$t" "$S" "Bare-Tip unveraendert"
    v=$(git -C "$BARE" ls-tree -r --name-only "$t" | grep -c -F 'docs/*/alt/diplomarbeit-de-lang.pdf')
    erw_gleich "$v" 1 "Fremd-PDF am Remote erhalten (Loeschung nicht mitgepusht)"
}
fall_P43() { # S8-01 (b): gestagte Fremd-Loeschung mit identischem Blob wie die neue Ziel-PDF (Rename-Konstellation)
    s="$1"; d="$T/P43"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    fremd_pdf "$d/h" docs/other/diplomarbeit-de-lang.pdf de-lang v1 || { rot "Fremd-PDF nicht anlegbar"; return; }
    S=$(tip); klone "$d/work" "$S" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    git -C "$d/work" rm -q -- docs/other/diplomarbeit-de-lang.pdf || { rot "git rm der Fremd-PDF"; return; }
    lauf "$d/work" "$s" "$d/out" "$S" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_FASSUNGEN=de-lang; rc=$?
    zeige "$d/out"; erw_rc "$rc" 1; erw_text "$d/out" "fremde Pfad(e) im Index"; erw_kein_text "$d/out" "PUSH OK"
    t=$(tip); erw_gleich "$t" "$S" "Bare-Tip unveraendert"
}
fall_P44() { # S8-02: (a) Ziel 100755 im Arbeitsbaum = Push mit 100644; (c) Quelle 0755 + Fake-chmod = FEHLER
    s="$1"; d="$T/P44"; vorlauf_v1 "$d" "$s" || return
    fremd_eintrag "$d/h" modus || { rot "Fremd-Eintrag (Modus) fehlgeschlagen"; return; }; H=$(tip)
    klone "$d/workB" "$H" || { rot "Klon B nicht baubar"; return; }; lege_pdfs "$d/workB" v2
    [ -x "$d/workB/docs/diplomarbeit/diplomarbeit-en-kurz.pdf" ] \
        || { rot "Vorbedingung: Ziel im Arbeitsbaum nicht 0755"; return; }
    lauf "$d/workB" "$s" "$d/out_a" "$H" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out_a"
    erw_rc "$rc" 0; erw_text "$d/out_a" "PUSH OK"; t=$(tip)
    m=$(git -C "$BARE" ls-tree "$t" -- docs/diplomarbeit/diplomarbeit-en-kurz.pdf | cut -d' ' -f1)
    erw_gleich "$m" 100644 "Modus von en-kurz am Remote nach dem Export (a)"
    # (c) Fake-chmod (no-op) + Quelle mit x-Bit: chmod wirkungslos -> Index-Modus-Wache/Tree-Pruefung = FEHLER
    klone "$d/workC" "$t" || { rot "Klon C nicht baubar"; return; }; lege_pdfs "$d/workC" v3
    chmod 0755 "$d/workC/thesis/diplomarbeit/diplomarbeit-de-lang.pdf"
    mkdir -p "$d/fake"; printf '#!/bin/sh\nexit 0\n' > "$d/fake/chmod"; chmod 0755 "$d/fake/chmod"
    lauf "$d/workC" "$s" "$d/out_c" "$t" PATH="$d/fake:$PATH" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out_c"
    erw_rc "$rc" 1; erw_text "$d/out_c" "S8-02"; erw_kein_text "$d/out_c" "PUSH OK"
    t2=$(tip); erw_gleich "$t2" "$t" "Bare-Tip unveraendert (c)"
}
fall_P45() { # S8-03: (a) Remote loescht eine geaenderte Fassung = UEBERHOLT vor dem Merge; (b) Erst-Export normal
    s="$1"; d="$T/P45"; vorlauf_v1 "$d" "$s" || return
    klone "$d/workB" "$S" || { rot "Klon B nicht baubar"; return; }; lege_pdfs "$d/workB" v2
    fremd_eintrag "$d/h" loeschen || { rot "Fremd-Eintrag (Loeschung) fehlgeschlagen"; return; }; H=$(tip)
    lauf "$d/workB" "$s" "$d/out_a" "$S" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out_a"
    erw_rc "$rc" 0; erw_text "$d/out_a" "am Remote geloescht"; erw_text "$d/out_a" "S8-03"
    erw_kein_text "$d/out_a" "kollidiert"; erw_kein_text "$d/out_a" "PUSH OK"
    t=$(tip); erw_gleich "$t" "$H" "Bare-Tip = Fremd-Commit (a)"
    # (b) erste Exportierung (Pipeline-Tree ohne PDFs) + fremder Remote-Commit -> Merge + Push normal
    d2="$T/P45b"; baue_seed "$d2" || { rot "Wegwerf-Remote (b) nicht baubar"; return; }
    klone "$d2/work" "$BASE" || { rot "Klon (b) nicht baubar"; return; }; lege_pdfs "$d2/work" v1
    mensch "$d2/h" fremd || { rot "Mensch-Commit (b) fehlgeschlagen"; return; }
    lauf "$d2/work" "$s" "$d2/out" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d2/out"
    erw_rc "$rc" 0; erw_text "$d2/out" "PUSH OK (ci.skip) auf development (Versuch 2)"
    erw_kein_text "$d2/out" "UEBERHOLT"
    t=$(tip); n=$(git -C "$BARE" ls-tree --name-only "$t" docs/diplomarbeit/ | grep -c 'diplomarbeit-.*\.pdf$')
    erw_gleich "$n" 4 "PDF-Dateien im Bare-Tip (b)"
}
fall_P46() { # S8-04 (ENTLASTET mit Messung): Push vom pre-receive-Hook abgelehnt, Log ohne Koeder/userinfo
    s="$1"; d="$T/P46"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    printf '#!/bin/sh\necho "reject"\nexit 1\n' > "$BARE/hooks/pre-receive"; chmod 0755 "$BARE/hooks/pre-receive"
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_WRITEBACK_USER=ciuser \
        COMDARE_WRITEBACK_TOKEN="$KOEDER" GIT_TRACE=1; rc=$?; zeige "$d/out"
    erw_rc "$rc" 1; erw_text "$d/out" "Push abgelehnt"; erw_text "$d/out" "kein non-ff-Race"
    erw_kein_text "$d/out" "$KOEDER"; erw_kein_text "$d/out" "x-access-token"
    u=$(grep -c -E '//[^/ ]*@' "$d/out"); erw_gleich "$u" 0 "URL-Formen mit userinfo im Log"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
    # Credential-Maske des Scripts (push.err/fetch.err) am Muster geprobt, ohne den Koeder auszugeben
    m=$(grep -c "s#//\[^/\]\*@#//<cred>@#g" "$s")
    erw_gleich "$m" 2 "Masken-Ausdruecke im Script (push.err + fetch.err)"
    ms=$(grep -c "s#\[^ /:@\]\*@\[^ /:@\]\*:#<cred>@<host>:#g" "$s")
    erw_gleich "$ms" 2 "scp-Masken-Ausdruecke im Script (push.err + fetch.err, L9-04)"
    g=$(printf 'https://ciuser:%s@host/x\n' "$KOEDER" | sed -e 's#//[^/]*@#//<cred>@#g' \
        -e 's#[^ /:@]*@[^ /:@]*:#<cred>@<host>:#g')
    case "$g" in *"$KOEDER"*) rot "Maske laesst den Koeder durch" ;; *'//<cred>@host/x'*) ok "Maske ersetzt userinfo" ;;
        *) rot "Maske liefert unerwartete Form" ;; esac
}
fall_P47() { # S8-05: Koeder als Schalter, als Fassung und als Argument -> FEHLER, der Rohwert steht nicht im Log
    s="$1"; d="$T/P47"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out1" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_EXPORT="$KOEDER"; rc=$?
    zeige "$d/out1"; erw_rc "$rc" 1; erw_text "$d/out1" "Wert nicht in {true,false}"; erw_kein_text "$d/out1" "$KOEDER"
    lauf "$d/work" "$s" "$d/out2" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_FASSUNGEN="$KOEDER"
    rc=$?
    zeige "$d/out2"; erw_rc "$rc" 1; erw_text "$d/out2" "Eintrag 1"; erw_kein_text "$d/out2" "$KOEDER"
    LAUF_ARGS="$KOEDER"
    lauf "$d/work" "$s" "$d/out3" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; LAUF_ARGS=""
    zeige "$d/out3"; erw_rc "$rc" 1; erw_text "$d/out3" "Argument 1 unbekannt"; erw_kein_text "$d/out3" "$KOEDER"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P48() { # S8-06/S10-03: (a) Trap VOR mkdir VOR WERK-Zuweisung (Zeilen); (b) fehler() vor mkdir: rc 1, 0 Reste
    s="$1"; d="$T/P48"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    zt=$(grep -n "^trap 'if \[ -n" "$s" | head -1 | cut -d: -f1)
    l48="rc=0; ( trap '' HUP INT TERM; exec mkdir -m 0700 -- \"\$kand\" ) || rc=\$?"   # S9-08 ohne -p; r13: immun
    zm=$(grep -n -x -F -- "$l48" "$s" | head -1 | cut -d: -f1)
    zw=$(grep -n '^  0) WERK=\$kand ;;$' "$s" | head -1 | cut -d: -f1)   # S10-03/S11-01: Zuweisung NACH der Anlage
    if [ -n "$zt" ] && [ -n "$zm" ] && [ -n "$zw" ] && [ "$zt" -lt "$zm" ] && [ "$zm" -lt "$zw" ]; then
        ok "EXIT-Trap Z.$zt vor mkdir Z.$zm vor WERK-Zuweisung Z.$zw (S8-06/S10-03)"
    else rot "Trap '$zt' / mkdir '$zm' / WERK-Zuweisung '$zw' nicht in der Reihenfolge Trap, mkdir, Zuweisung"; fi
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    mkdir -p "$d/tmpw"; k=$(git -C "$d/work" rev-parse --short "$BASE")
    ( cd "$d/work" && env -i PATH="$PATH" HOME="$HOME" TMPDIR="$d/tmpw" GIT_CONFIG_GLOBAL=/dev/null \
        GIT_CONFIG_NOSYSTEM=1 CI_COMMIT_BRANCH=development CI_COMMIT_SHA="$BASE" CI_COMMIT_SHORT_SHA="$k" \
        CI_PIPELINE_ID=4711 \
        COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_DIR= sh "$s" ) > "$d/out" 2>&1; rc=$?; zeige "$d/out"
    erw_rc "$rc" 1; erw_text "$d/out" "gesetzt, aber leer"; erw_kein_text "$d/out" "unbound variable"
    rest=$(ls -A "$d/tmpw" | wc -l); erw_gleich "$rest" 0 "Hilfsverzeichnisse unter TMPDIR nach fehler() vor mktemp"
}
fall_P49() { # C8-06: mehrzeilige Makrodefinition im F09-GATE-346 = FEHLER (r8: falsches Konsum-Gruen); Gegenprobe gruen
    d="$T/P49"; mkdir -p "$d"
    zf=$(extrahiere_block "$CI_YML" F09-GATE-346 "$d/f09.sh")
    if [ "$zf" -lt 3 ]; then
        echo "      [ENTFAELLT] Block F09-GATE-346 fehlt in $CI_YML ($zf Zeilen) -- C8-06 nur mit Koppelpatch pruefbar"
        return
    fi
    command -v bash >/dev/null 2>&1 || { rot "bash (Runner-Shell) fehlt -- Block nicht fahrbar"; return; }
    baue_modul "$d" || { rot "Wegwerf-Modul nicht baubar"; return; }
    git -C "$MODUL" checkout -q -B f09m "$X1" || { rot "Zweig f09m nicht setzbar"; return; }
    printf '%s\n' '\documentclass{article}' '\providecommand{\thesislang}{de}' '\providecommand' \
        '{\thesisumfang}{lang}' '\ifx\thesislang\undefined\fi' > "$MODUL/diplomarbeit.tex"
    git -C "$MODUL" add diplomarbeit.tex && modul_commit 1758600294 "F09m mehrzeilige Definition" \
        || { rot "Commit F09m"; return; }
    F09M=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse F09m"; return; }
    stand "$F09M" || { rot "Stand F09m"; return; }
    fahre_block "$d/f09.sh" "$d/out_m"; rc=$?; zeige "$d/out_m"
    erw_rc "$rc" 1; erw_text "$d/out_m" 'kein Konsum von \thesisumfang'   # r10: Konsum = gesamt - Definitionen
    git -C "$MODUL" checkout -q -B f09g "$X1" || { rot "Zweig f09g nicht setzbar"; return; }
    printf '%s\n' '\documentclass{article}' '\providecommand{\thesislang}{de}' \
        '\providecommand{\thesisumfang}{lang}' '\ifx\thesislang\undefined\fi' '\ifx\thesisumfang\undefined\fi' \
        > "$MODUL/diplomarbeit.tex"
    git -C "$MODUL" add diplomarbeit.tex && modul_commit 1758600296 "F09g einzeilig plus Konsum" \
        || { rot "Commit F09g"; return; }
    F09G=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse F09g"; return; }
    stand "$F09G" || { rot "Stand F09g"; return; }
    fahre_block "$d/f09.sh" "$d/out_g"; rc=$?; zeige "$d/out_g"
    erw_rc "$rc" 0; erw_kein_text "$d/out_g" "FEHLER"
}

# ------------------------------------------------ r10 (Codex-Lens r9 A/B, Fable-Lens r9, Lead K300/K301)
fall_P50() { # S9-03 (deckt L9-02/L9-03/L9-08): DIR/SRC ausserhalb [A-Za-z0-9._/-] -> FEHLER VOR jeder git-Wache
    s="$1"; d="$T/P50"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    uml=$(printf 'docs/dipl\303\266marbeit'); _i=0
    for v in "$uml" 'docs/x"y' 'docs/x\y' 'docs/x:y' ':(glob)docs/x' ':docs/y' 'docs/?' 'docs/[ab]'; do
        _i=$((_i+1)); klone "$d/work$_i" "$BASE" || { rot "Klon $_i nicht baubar"; return; }; lege_pdfs "$d/work$_i" v1
        lauf "$d/work$_i" "$s" "$d/out$_i" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" "COMDARE_THESIS_PDF_DIR=$v"; rc=$?
        zeige "$d/out$_i"; erw_rc "$rc" 1; erw_text "$d/out$_i" "unzulaessige Zeichen (S9-03)"
        erw_kein_text "$d/out$_i" "PUSH OK"; erw_kein_text "$d/out$_i" "Zieldateien stehen im Index"
        fremd=$(ls -A "$d/work$_i" | grep -v -x -e .git -e README.md -e .gitlab-ci.yml -e thesis | wc -l)
        erw_gleich "$fremd" 0 "angelegte Eintraege im Klon $_i ausserhalb des Seeds (kein Fehlziel)"
    done
    klone "$d/work9" "$BASE" || { rot "Klon 9 nicht baubar"; return; }; lege_pdfs "$d/work9" v1
    lauf "$d/work9" "$s" "$d/out9" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" 'COMDARE_THESIS_PDF_SRC=thesis/x"y'; rc=$?
    zeige "$d/out9"; erw_rc "$rc" 1; erw_text "$d/out9" "unzulaessige Zeichen (S9-03)"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P51() { # S9-07: Koeder als CI_COMMIT_SHA / CI_COMMIT_SHORT_SHA / CI_COMMIT_BRANCH -> FEHLER, Rohwert nie im Log
    s="$1"; d="$T/P51"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    _i=0
    for kv in "CI_COMMIT_SHA=$KOEDER" "CI_COMMIT_SHORT_SHA=$KOEDER" "CI_COMMIT_BRANCH=x:$KOEDER"; do
        _i=$((_i+1)); klone "$d/work$_i" "$BASE" || { rot "Klon $_i nicht baubar"; return; }; lege_pdfs "$d/work$_i" v1
        lauf "$d/work$_i" "$s" "$d/out$_i" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" "$kv"; rc=$?; zeige "$d/out$_i"
        erw_rc "$rc" 1; erw_text "$d/out$_i" "${kv%%=*}:"; erw_text "$d/out$_i" "(S9-07)"
        erw_kein_text "$d/out$_i" "$KOEDER"; erw_kein_text "$d/out$_i" "PUSH OK"
    done
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P52() { # S9-09: fehler() per printf, kein echo mit Variablen; DIR mit literalem Backslash-n -> genau 1 Zeile
    s="$1"; d="$T/P52"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    n1=$(grep -c 'echo "FEHLER' "$s"); erw_gleich "$n1" 0 "Zeilen 'echo \"FEHLER' im Script"
    n2=$(grep -c -E '^[^#]*echo "[^"]*\$' "$s"); erw_gleich "$n2" 0 "echo-Zeilen mit Variablen im Script"
    n3=$(grep -c -F "fehler() { printf '%s\\n' \"FEHLER: \$*\"; exit 1; }" "$s")
    erw_gleich "$n3" 1 "fehler() per printf"
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" 'COMDARE_THESIS_PDF_DIR=docs/x\ny'; rc=$?
    zeige "$d/out"; erw_rc "$rc" 1; erw_text "$d/out" "unzulaessige Zeichen (S9-03)"
    z=$(awk 'END{print NR}' "$d/out"); erw_gleich "$z" 1 "Ausgabezeilen (genau eine FEHLER-Zeile, kein Backslash-n)"
}
gitattr_pdf_text() { # $1 = Klonpfad: .gitattributes '*.pdf text' am Remote, gepusht (S9-01-Fall)
    git clone -q "$BARE" "$1" || return 2
    printf '*.pdf text\n' > "$1/.gitattributes"
    git -C "$1" add -- .gitattributes && git -C "$1" commit -q -m "gitattributes pdf text" || return 2
    git -C "$1" push -q "$BARE" development || return 2
}
fall_P53() { # S9-01: '*.pdf text' + CRLF-Artefakt -> FEHLER 'Filter-/EOL-Konversion' VOR dem Commit (r9: PUSH OK)
    s="$1"; d="$T/P53"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    gitattr_pdf_text "$d/h" || { rot ".gitattributes nicht anlegbar"; return; }; S=$(tip)
    klone "$d/work" "$S" || { rot "Klon nicht baubar"; return; }
    for f in de-lang en-lang de-kurz en-kurz; do
        printf '%%PDF-1.4\r\n%% fassung %s crlf\r\n%%%%EOF\r\n' "$f" > "$d/work/thesis/diplomarbeit/diplomarbeit-$f.pdf"
    done
    a=$(git -C "$d/work" check-attr text -- docs/diplomarbeit/diplomarbeit-de-lang.pdf | grep -c 'text: set')
    erw_gleich "$a" 1 "Vorbedingung: Attribut text gesetzt fuer die Zieldatei"
    lauf "$d/work" "$s" "$d/out" "$S" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 1; erw_text "$d/out" "Filter-/EOL-Konversion am Artefakt"; erw_text "$d/out" "S9-01"
    erw_kein_text "$d/out" "PUSH OK"
    t=$(tip); erw_gleich "$t" "$S" "Bare-Tip unveraendert (kein konvertiertes Artefakt)"
}
fall_P54() { # S9-02 (L9-06): core.fileMode=false + Remote-Eintrag 100755 -> r10 gruen mit 100644 (r9 Dauer-FEHLER)
    s="$1"; d="$T/P54"; vorlauf_v1 "$d" "$s" || return
    fremd_eintrag "$d/h" modus || { rot "Fremd-Eintrag (Modus) fehlgeschlagen"; return; }; H=$(tip)
    klone "$d/workB" "$H" || { rot "Klon B nicht baubar"; return; }; lege_pdfs "$d/workB" v2
    git -C "$d/workB" config core.fileMode false || { rot "core.fileMode nicht setzbar"; return; }
    fm=$(git -C "$d/workB" config --get core.fileMode); erw_gleich "$fm" false "Vorbedingung: core.fileMode im Klon"
    lauf "$d/workB" "$s" "$d/out" "$H" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 0; erw_text "$d/out" "PUSH OK"; erw_kein_text "$d/out" "statt 100644 im Index"
    t=$(tip); m=$(git -C "$BARE" ls-tree "$t" -- docs/diplomarbeit/diplomarbeit-en-kurz.pdf | cut -d' ' -f1)
    erw_gleich "$m" 100644 "Modus von en-kurz am Remote nach dem Export (core.fileMode=false)"
}
fall_P55() { # S9-06/L9-04: von der Gegenseite echote URL-Formen werden bis zum letzten '@' und in scp-Form maskiert
    s="$1"; d="$T/P55"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    { echo '#!/bin/sh'; echo 'echo "reject https://u:pa@ss@host/x" >&2'; echo 'echo "reject git@host:g/r.git" >&2'
      echo 'exit 1'; } > "$BARE/hooks/pre-receive"; chmod 0755 "$BARE/hooks/pre-receive"
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 1; erw_text "$d/out" "Push abgelehnt"; erw_text "$d/out" "//<cred>@host/x"
    erw_text "$d/out" "<cred>@<host>:g/r.git"; erw_kein_text "$d/out" "pa@ss"; erw_kein_text "$d/out" "ss@"
    erw_kein_text "$d/out" "git@"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P56() { # S9-05: git-Shim laesst ls-tree FETCH_HEAD / cat-file -e FETCH_HEAD: mit rc 128 scheitern -> FEHLER
    s="$1"; d="$T/P56"; vorlauf_v1 "$d" "$s" || return
    klone "$d/workB" "$S" || { rot "Klon B nicht baubar"; return; }; lege_pdfs "$d/workB" v2
    mensch "$d/h" fremd || { rot "Mensch-Commit fehlgeschlagen"; return; }; H=$(tip)
    mkdir -p "$d/shim"; echt=$(command -v git)
    { echo '#!/bin/sh'
      echo 'case "$1 $2" in "ls-tree FETCH_HEAD") echo "fatal: shim ls-tree FETCH_HEAD" >&2; exit 128 ;; esac'
      echo 'case "$1 $2 $3" in "cat-file -e FETCH_HEAD:"*) echo "fatal: shim cat-file FETCH_HEAD" >&2; exit 128 ;; esac'
      echo "exec '$echt' \"\$@\""; } > "$d/shim/git"; chmod 0755 "$d/shim/git"
    lauf "$d/workB" "$s" "$d/out" "$S" PATH="$d/shim:$PATH" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 1; erw_text "$d/out" "FEHLER: git ls-tree FETCH_HEAD"; erw_text "$d/out" "S9-05"
    erw_kein_text "$d/out" "UEBERHOLT"; erw_kein_text "$d/out" "PUSH OK"
    t=$(tip); erw_gleich "$t" "$H" "Bare-Tip = Mensch-Commit (kein Push)"
}
fall_P57() { # L9-01: Kopfkommentar 'SELBSTBISS (--selbstbiss): N Wegwerf-Mutanten' == Script- + YAML-Mutanten
    h="$SELBST"; case "$1" in */m80.sh) h="$1" ;; esac
    k=$(grep -o 'SELBSTBISS (--selbstbiss): [0-9]* Wegwerf-Mutanten' "$h" | head -1 | grep -o '[0-9]*')
    soll=$((MUT_N_SKRIPT + MUT_N_YAML))
    erw_gleich "$k" "$soll" "Kopfkommentar-Mutantenzahl (Script $MUT_N_SKRIPT + YAML $MUT_N_YAML)"
}
fall_P58() { # C9-01/C9-02: F09-GATE-346 kommentar-bewusst + zeilenuebergreifend (Koppelpatch, sonst LAUT entfallen)
    d="$T/P58"; mkdir -p "$d"
    zf=$(extrahiere_block "$CI_YML" F09-GATE-346 "$d/f09.sh")
    if [ "$zf" -lt 3 ]; then
        echo "      [ENTFAELLT] Block F09-GATE-346 fehlt ($zf Zeilen) -- C9-01/C9-02 nur mit Koppelpatch pruefbar"
        return
    fi
    command -v bash >/dev/null 2>&1 || { rot "bash (Runner-Shell) fehlt -- Block nicht fahrbar"; return; }
    baue_modul "$d" || { rot "Wegwerf-Modul nicht baubar"; return; }
    f58() { # $1 = Zweig, $2 = erwarteter rc, $3 = erwarteter Text, danach die Zeilen der diplomarbeit.tex
        _zw="$1"; _rc="$2"; _tx="$3"; shift 3
        git -C "$MODUL" checkout -q -B "$_zw" "$X1" || { rot "Zweig $_zw nicht setzbar"; return; }
        printf '%s\n' "$@" > "$MODUL/diplomarbeit.tex"
        git -C "$MODUL" add diplomarbeit.tex && modul_commit 1758600298 "F58 $_zw" || { rot "Commit $_zw"; return; }
        stand "$(git -C "$MODUL" rev-parse HEAD)" || { rot "Stand $_zw"; return; }
        fahre_block "$d/f09.sh" "$d/out_$_zw"; rc=$?; zeige "$d/out_$_zw"
        erw_rc "$rc" "$_rc"; erw_text "$d/out_$_zw" "$_tx"
    }
    DC='\documentclass{article}'; DL='\providecommand{\thesislang}{de}'; DU='\providecommand{\thesisumfang}{lang}'
    KL='\ifx\thesislang\undefined\fi'; KU='\ifx\thesisumfang\undefined\fi'; KO='kein Konsum von \thesisumfang'
    # (a) drei Codex-Gegenfaelle je OHNE Konsum von \thesisumfang -> FEHLER (thesislang definiert + konsumiert)
    f58 a1 1 "$KO" "$DC" "$DL" "$KL" '\providecommand{%' '\thesisumfang}{lang}'
    f58 a2 1 "$KO" "$DC" "$DL" "$KL" '\def % Kommentar' '\thesisumfang{lang}'
    f58 a3 1 "$KO" "$DC" "$DL" "$KL" '\let % Kommentar' '\thesisumfang=\relax'
    # (b) r8-Gegenfall '\providecommand' NEWLINE '{\thesisumfang}{lang}' = P-49 (a); (c) legitime Formen bleiben gruen
    f58 c1 0 'Konsum 1' "$DC" "$DL" "$DU" "$KU" '\textbf' '{\thesislang}'
    f58 c2 0 'Konsum 1' "$DC" "$DL" "$DU" '% Beispiel: \providecommand' "$KL" "$KU"
    f58 c3 0 'Konsum 1' "$DC" "$DL" "$DU" '\newcommand' '{\foo}{bar}' "$KL" "$KU"
    f58 c4 0 'Konsum 1' "$DC" "$DL" "$DU" '\newcommand*' '{\foo}{x}' '\textbf' '  {\thesislang}' "$KU"
    # (d) Definition + echter Konsum in derselben Datei: Konsum = gesamt - 1, je Makro eine Nachweiszeile
    f58 d1 0 'F09-GATE-346: \thesisumfang Definitionen 1, Vorkommen 2, Konsum 1' "$DC" "$DL" "$DU" "$KL" "$KU"
    erw_text "$d/out_d1" 'F09-GATE-346: \thesislang Definitionen 1, Vorkommen 2, Konsum 1'
    for z in a1 a2 a3 c1 c2 c3 c4; do erw_kein_text "$d/out_$z" 'kein Konsum von \thesislang'; done
}
fall_P59() { # S9-04: Index-Abfrage mit expliziter Stage ':0:' genau einmal im Script, alte Form nie (Textwache)
    s="$1"; n=$(grep -c -F 'git rev-parse --verify -q ":0:$dst"' "$s")
    erw_gleich "$n" 1 "Zeilen mit ':0:\$dst' im Script"
    n0=$(grep -c -F 'git rev-parse --verify -q ":$dst"' "$s"); erw_gleich "$n0" 0 "Zeilen mit der alten Form ':\$dst'"
}

# ------------------------------------------------ r11 (Codex-Lens r10 A/B, Fable-Lens r10, Lead K303/K304)
fall_P60() { # S10-01 (L10-07): Branch 'refs/heads/x' = volle Ref refs/heads/refs/heads/x; 'HEAD'/'x.lock'/'x/' = FEHLER
    s="$1"; d="$T/P60"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    git -C "$BARE" update-ref refs/heads/refs/heads/x "$BASE" && git -C "$BARE" update-ref refs/heads/x "$BASE" \
        || { rot "Zweige refs/heads/x und x am Bare nicht setzbar"; return; }
    klone "$d/work1" "$BASE" || { rot "Klon 1 nicht baubar"; return; }; lege_pdfs "$d/work1" v1
    lauf "$d/work1" "$s" "$d/out1" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" CI_COMMIT_BRANCH=refs/heads/x; rc=$?
    zeige "$d/out1"; erw_rc "$rc" 0; erw_text "$d/out1" "PUSH OK"
    zx=$(git -C "$BARE" rev-parse refs/heads/refs/heads/x); n=$(git -C "$BARE" rev-list --count "$BASE..$zx")
    erw_gleich "$n" 1 "neue Commits auf refs/heads/refs/heads/x (Push-Ziel = volle Ref)"
    bx=$(git -C "$BARE" rev-parse refs/heads/x); erw_gleich "$bx" "$BASE" "Branch x unbewegt (kein Fehlziel)"
    _i=1
    for b in HEAD x.lock x/; do
        _i=$((_i+1)); klone "$d/work$_i" "$BASE" || { rot "Klon $_i nicht baubar"; return; }; lege_pdfs "$d/work$_i" v1
        lauf "$d/work$_i" "$s" "$d/out$_i" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" "CI_COMMIT_BRANCH=$b"; rc=$?
        zeige "$d/out$_i"; erw_rc "$rc" 1; erw_text "$d/out$_i" "kein gueltiger Branchname (S10-01)"
        erw_kein_text "$d/out$_i" "PUSH OK"
    done
    t=$(tip); erw_gleich "$t" "$BASE" "development unbewegt"
}
fall_P61() { # S10-02: NA nur bei UNGESETZTER SHORT_SHA/PIPELINE_ID; gesetzt leer oder 'NA' = FEHLER (S9-07-Wache)
    s="$1"; d="$T/P61"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work1" "$BASE" || { rot "Klon 1 nicht baubar"; return; }; lege_pdfs "$d/work1" v1
    ( cd "$d/work1" && env -i PATH="$PATH" HOME="$HOME" TMPDIR="$T" GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1 \
        CI_COMMIT_BRANCH=development CI_COMMIT_SHA="$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" sh "$s" ) > "$d/out1" 2>&1
    rc=$?; zeige "$d/out1"; erw_rc "$rc" 0; erw_text "$d/out1" "PUSH OK"
    t=$(tip); m=$(git -C "$BARE" log -1 --format=%B "$t" | grep -c 'aus Pipeline NA')
    erw_gleich "$m" 1 "'Pipeline NA' im Commit-Text (ungesetzt)"
    m=$(git -C "$BARE" log -1 --format=%B "$t" | grep -c 'Quelle super NA (')
    erw_gleich "$m" 1 "'super NA' im Commit-Text (ungesetzt)"
    _i=1
    for kv in CI_COMMIT_SHORT_SHA= CI_COMMIT_SHORT_SHA=NA CI_PIPELINE_ID= CI_PIPELINE_ID=NA; do
        _i=$((_i+1)); klone "$d/work$_i" "$BASE" || { rot "Klon $_i nicht baubar"; return; }; lege_pdfs "$d/work$_i" v1
        lauf "$d/work$_i" "$s" "$d/out$_i" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" "$kv"; rc=$?; zeige "$d/out$_i"
        erw_rc "$rc" 1; erw_text "$d/out$_i" "${kv%%=*}:"; erw_text "$d/out$_i" "(S9-07)"
        erw_kein_text "$d/out$_i" "PUSH OK"
    done
    t2=$(tip); erw_gleich "$t2" "$t" "Bare-Tip unveraendert seit dem Lauf ohne SHORT_SHA/PIPELINE_ID"
}
fall_P62() { # S10-03: Kollision (Pfad existiert fremd, mit Inhalt) + SIGTERM bei der Anlage: nichts Fremdes geraeumt
    s="$1"; d="$T/P62"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    mkdir -p "$d/shim" "$d/tmpw"; echt=$(command -v mkdir)
    { echo '#!/bin/sh'
      echo 'case "$1 $2 $3" in "-m 0700 --") ;; *) exec '"'$echt'"' "$@" ;; esac'
      echo "'$echt' -p -- \"\$4\" && printf 'fremd\\n' > \"\$4/fremd.txt\" && printf '%s\\n' \"\$4\" > '$d/kand.txt'"
      echo 'kill -TERM $PPID; exit 1'; } > "$d/shim/mkdir"; chmod 0755 "$d/shim/mkdir"
    lauf "$d/work" "$s" "$d/out" "$BASE" PATH="$d/shim:$PATH" TMPDIR="$d/tmpw" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?
    zeige "$d/out"; erw_rc "$rc" 1   # r12 (S11-01): Signal nur vorgemerkt, die Kollision endet als FEHLER rc 1
    [ -s "$d/kand.txt" ] || { rot "Vorbedingung: mkdir-Shim nicht erreicht"; return; }
    kand=$(cat "$d/kand.txt")
    if [ -d "$kand" ]; then ok "fremder Ordner besteht nach dem Signal"; else rot "fremder Ordner wurde geraeumt"; fi
    inh=$(cat "$kand/fremd.txt" 2>/dev/null); erw_gleich "$inh" fremd "Inhalt des fremden Ordners unveraendert"
    erw_kein_text "$d/out" "PUSH OK"; t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P63() { # S10-04: TMPDIR mit Leerzeichen / ';' / relativ = FEHLER ohne Rohwert VOR der Anlage; chmod 0700 --
    s="$1"; d="$T/P63"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    n=$(grep -c -F 'chmod 0700 -- "$WERK/askpass.sh"' "$s"); erw_gleich "$n" 1 "chmod 0700 -- am Askpass-Helfer"
    mkdir -p "$d/a b" "$d/x;y" || { rot "Sonder-TMPDIRs nicht anlegbar"; return; }
    f63() { # $1 = Nr, $2 = TMPDIR-Wert, $3 = erwarteter Text, $4 = Fragment des Rohwerts (darf nicht im Log stehen)
        klone "$d/work$1" "$BASE" || { rot "Klon $1 nicht baubar"; return; }; lege_pdfs "$d/work$1" v1
        lauf "$d/work$1" "$s" "$d/out$1" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" "TMPDIR=$2"; rc=$?; zeige "$d/out$1"
        erw_rc "$rc" 1; erw_text "$d/out$1" "$3"; erw_kein_text "$d/out$1" "$4"; erw_kein_text "$d/out$1" "PUSH OK"
    }
    f63 1 "$d/a b" "TMPDIR: unzulaessige Zeichen (S10-04)" "a b"
    f63 2 "$d/x;y" "TMPDIR: unzulaessige Zeichen (S10-04)" "x;y"
    f63 3 "rel/x" "TMPDIR: kein absoluter Pfad (S10-04)" "rel/x"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P64() { # S10-06: fehler() ohne abgeleitete Werte (Textwache); Symlink-Quelle ausserhalb: Zielpfad nie im Log
    s="$1"; d="$T/P64"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    n=$(grep -c -E 'fehler .*\$(SRC_K|WERK|TOP|WURZEL|DIR_K|DIR_F)' "$s")
    erw_gleich "$n" 0 "fehler()-Zeilen mit \$SRC_K/\$WERK/\$TOP/\$WURZEL/\$DIR_K/\$DIR_F im Script"
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    mkdir -p "$d/AUSSEN-S10-06-MARKE" && ln -s "$d/AUSSEN-S10-06-MARKE" "$d/work/thesis/aussen" \
        || { rot "Symlink-Quelle nicht anlegbar"; return; }
    lauf "$d/work" "$s" "$d/out" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_SRC=thesis/aussen; rc=$?
    zeige "$d/out"; erw_rc "$rc" 1; erw_text "$d/out" "liegt ausserhalb des Arbeitsbaums (SRC_K, C6-08)"
    erw_kein_text "$d/out" "AUSSEN-S10-06-MARKE"; t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P65() { # S10-07: core.fileMode=false + fremde getrackte Datei unter DIR chmod +x (ungestagt) = FEHLER, kein Push
    s="$1"; d="$T/P65"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    readme_unter_dir "$d/h" fremd || { rot "Fremddatei am Remote nicht anlegbar"; return; }; H=$(tip)
    klone "$d/work" "$H" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    git -C "$d/work" config core.fileMode false || { rot "core.fileMode nicht setzbar"; return; }
    chmod +x "$d/work/docs/diplomarbeit/README.md" || { rot "chmod +x fehlgeschlagen"; return; }
    lauf "$d/work" "$s" "$d/out" "$H" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 1; erw_text "$d/out" "(ungestagt, S7-03)"; erw_kein_text "$d/out" "PUSH OK"
    t=$(tip); erw_gleich "$t" "$H" "Bare-Tip unveraendert"
}
fall_P66() { # L10-05: DIR '-n' / SRC '-x' = FEHLER "fuehrendes '-'" VOR jeder git-Wache, kein Verzeichnis, kein Push
    s="$1"; d="$T/P66"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work1" "$BASE" || { rot "Klon 1 nicht baubar"; return; }; lege_pdfs "$d/work1" v1
    lauf "$d/work1" "$s" "$d/out1" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_DIR=-n; rc=$?
    zeige "$d/out1"; erw_rc "$rc" 1; erw_text "$d/out1" "COMDARE_THESIS_PDF_DIR: fuehrendes '-' (L10-05)"
    erw_kein_text "$d/out1" "PUSH OK"
    if [ -e "$d/work1/-n" ]; then rot "Verzeichnis '-n' im Klon angelegt"; else ok "kein Verzeichnis '-n' angelegt"; fi
    klone "$d/work2" "$BASE" || { rot "Klon 2 nicht baubar"; return; }; lege_pdfs "$d/work2" v1
    lauf "$d/work2" "$s" "$d/out2" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_SRC=-x; rc=$?
    zeige "$d/out2"; erw_rc "$rc" 1; erw_text "$d/out2" "COMDARE_THESIS_PDF_SRC: fuehrendes '-' (L10-05)"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P67() { # S10-05 (L10-06): Diagnoseform ohne '//' (scheme:user:kennwort@host/pfad) maskiert, Kennwort nie im Log
    s="$1"; d="$T/P67"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    m=$(grep -c -F "s#[A-Za-z][A-Za-z0-9+.-]*:[^/ @]*@#<scheme>:<cred>@#g" "$s")
    erw_gleich "$m" 2 "scheme-Masken-Ausdruecke im Script (push.err + fetch.err)"
    { echo '#!/bin/sh'; echo 'echo "reject https:u:pw0ohne2slash@host/y" >&2'; echo 'exit 1'; } \
        > "$BARE/hooks/pre-receive"
    chmod 0755 "$BARE/hooks/pre-receive"
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 1; erw_text "$d/out" "Push abgelehnt"; erw_text "$d/out" "<scheme>:<cred>@host/y"
    erw_kein_text "$d/out" "pw0ohne2slash"; t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
f09_vorbereitung() { # $1 = Fallverzeichnis: Block F09-GATE-346 extrahieren + Wegwerf-Modul; rc 1 = entfallen/rot
    mkdir -p "$1"; zf=$(extrahiere_block "$CI_YML" F09-GATE-346 "$1/f09.sh")
    if [ "$zf" -lt 3 ]; then
        echo "      [ENTFAELLT] Block F09-GATE-346 fehlt ($zf Zeilen) -- nur mit Koppelpatch pruefbar"; return 1
    fi
    command -v bash >/dev/null 2>&1 || { rot "bash (Runner-Shell) fehlt -- Block nicht fahrbar"; return 1; }
    baue_modul "$1" || { rot "Wegwerf-Modul nicht baubar"; return 1; }
}
f09_fall() { # $1 = Fallverzeichnis, $2 = Zweig, $3 = erwarteter rc, $4 = erwarteter Text, danach die tex-Zeilen
    _fd="$1"; _zw="$2"; _rc="$3"; _tx="$4"; shift 4
    git -C "$MODUL" checkout -q -B "$_zw" "$X1" || { rot "Zweig $_zw nicht setzbar"; return; }
    printf '%s\n' "$@" > "$MODUL/diplomarbeit.tex"
    git -C "$MODUL" add diplomarbeit.tex && modul_commit 1758600298 "F11 $_zw" || { rot "Commit $_zw"; return; }
    stand "$(git -C "$MODUL" rev-parse HEAD)" || { rot "Stand $_zw"; return; }
    fahre_block "$_fd/f09.sh" "$_fd/out_$_zw"; rc=$?; zeige "$_fd/out_$_zw"
    erw_rc "$rc" "$_rc"; erw_text "$_fd/out_$_zw" "$_tx"
}
F11_DC='\documentclass{article}'; F11_DL='\providecommand{\thesislang}{de}'; F11_KL='\ifx\thesislang\undefined\fi'
F11_DU='\providecommand{\thesisumfang}{lang}'; F11_KU='\ifx\thesisumfang\undefined\fi'
F11_KO='kein Konsum von \thesisumfang'; F11_K1='F09-GATE-346: \thesisumfang Definitionen 1, Vorkommen 2, Konsum 1'
fall_P68() { # C10-01 (L10-02): Backslash-Paritaet: '\\%' = Kommentar (zaehlt NICHT), '\%' und '\\\%' = escaptes Prozent
    d="$T/P68"; f09_vorbereitung "$d" || return
    f09_fall "$d" p1 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" "$F11_DU" 'A\\% \thesisumfang'
    erw_text "$d/out_p1" 'Definitionen 1, Vorkommen 1'
    f09_fall "$d" p2 0 "$F11_K1" "$F11_DC" "$F11_DL" "$F11_KL" "$F11_DU" 'A\% \thesisumfang'
    f09_fall "$d" p3 0 "$F11_K1" "$F11_DC" "$F11_DL" "$F11_KL" "$F11_DU" 'A\\\% \thesisumfang'
}
fall_P69() { # C10-02 (L10-01): weitere Definitionsformen: nur Definition = FEHLER, Definition + Konsum = gruen
    d="$T/P69"; f09_vorbereitung "$d" || return; _i=0
    for df in '\gdef\thesisumfang{lang}' '\xdef\thesisumfang{lang}' '\DeclareRobustCommand{\thesisumfang}{lang}' \
              '\NewDocumentCommand{\thesisumfang}{}{lang}' '\newrobustcmd{\thesisumfang}{lang}'; do
        _i=$((_i+1))
        f09_fall "$d" "n$_i" 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" "$df"
        f09_fall "$d" "k$_i" 0 "$F11_K1" "$F11_DC" "$F11_DL" "$F11_KL" "$df" "$F11_KU"
    done
}
fall_P70() { # C10-04: Control-Word-Grenze am Definitionsziel: \thesisumfangX ist KEINE Definition von \thesisumfang
    d="$T/P70"; f09_vorbereitung "$d" || return
    f09_fall "$d" x1 0 "$F11_K1" "$F11_DC" "$F11_DL" "$F11_KL" "$F11_DU" '\newcommand{\thesisumfangX}{x}' "$F11_KU"
    erw_kein_text "$d/out_x1" "FEHLER"
}
fall_P71() { # C10-06 (L10-03): Werkordner f09.* nach FEHLER (und nach Erfolg) 0 Reste unter TMPDIR
    d="$T/P71"; f09_vorbereitung "$d" || return; mkdir -p "$d/tmpf"
    for z in r1:1 r2:0; do
        _zw="${z%%:*}"; _rc="${z#*:}"
        git -C "$MODUL" checkout -q -B "$_zw" "$X1" || { rot "Zweig $_zw nicht setzbar"; return; }
        if [ "$_rc" -eq 1 ]; then printf '%s\n' "$F11_DC" "$F11_DL" "$F11_KL" "$F11_DU" > "$MODUL/diplomarbeit.tex"
        else printf '%s\n' "$F11_DC" "$F11_DL" "$F11_KL" "$F11_DU" "$F11_KU" > "$MODUL/diplomarbeit.tex"; fi
        git -C "$MODUL" add diplomarbeit.tex && modul_commit 1758600298 "F11 $_zw" || { rot "Commit $_zw"; return; }
        stand "$(git -C "$MODUL" rev-parse HEAD)" || { rot "Stand $_zw"; return; }
        fahre_block "$d/f09.sh" "$d/out_$_zw" TMPDIR="$d/tmpf"; rc=$?; zeige "$d/out_$_zw"; erw_rc "$rc" "$_rc"
        rest=$(ls -A "$d/tmpf" | wc -l); erw_gleich "$rest" 0 "Reste unter TMPDIR nach dem Lauf $_zw (rc $_rc)"
    done
    erw_text "$d/out_r1" "$F11_KO"; erw_kein_text "$d/out_r2" "FEHLER"
}

fahre_block_ohne_e() { # wie fahre_block, aber bash OHNE -e und OHNE pipefail (P-72: der Block faengt den rc selbst)
    _bs="$1"; _bl="$2"; shift 2
    ( cd "$MODUL" && env -i PATH="$PATH" HOME="$HOME" TMPDIR="$T" GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1 \
        CI_PROJECT_DIR="$SUPERW" "$@" bash "$_bs" ) > "$_bl" 2>&1
}
fall_P72() { # C10-06b (r11b): F09-Skalar unter bash ohne -e/pipefail; FEHLER-Modul rc != 0, kein Weiterlauf; gruen rc 0
    d="$T/P72"; f09_vorbereitung "$d" || return
    { cat "$d/f09.sh"; echo 'echo "NACH-F09: Job laeuft hinter der Klammer weiter"'; } > "$d/f09b.sh"
    f72() { # $1 = Zweig, danach die tex-Zeilen
        _zw="$1"; shift
        git -C "$MODUL" checkout -q -B "$_zw" "$X1" || { rot "Zweig $_zw nicht setzbar"; return 1; }
        printf '%s\n' "$@" > "$MODUL/diplomarbeit.tex"
        git -C "$MODUL" add diplomarbeit.tex && modul_commit 1758600298 "F11b $_zw" || { rot "Commit $_zw"; return 1; }
        stand "$(git -C "$MODUL" rev-parse HEAD)" || { rot "Stand $_zw"; return 1; }
        fahre_block_ohne_e "$d/f09b.sh" "$d/out_$_zw"; rc=$?; zeige "$d/out_$_zw"
    }
    f72 s1 "$F11_DC" "$F11_DL" "$F11_KL" "$F11_DU" || return
    if [ "$rc" -ne 0 ]; then ok "rc=$rc (erwartet != 0)"; else rot "rc=0 (erwartet != 0): Subshell-rc ungefangen"; fi
    erw_text "$d/out_s1" "FEHLER: F09"; erw_kein_text "$d/out_s1" "NACH-F09"
    f72 s2 "$F11_DC" "$F11_DL" "$F11_KL" "$F11_DU" "$F11_KU" || return
    erw_rc "$rc" 0; erw_kein_text "$d/out_s2" "FEHLER"; erw_text "$d/out_s2" "NACH-F09"
}

# ------------------------------------------------ r12 (Codex-Lens r11 A/B, Fable-Lens r11, Lead K305)
fall_P73() { # S11-02: fuehrendes '-' NACH der Normalisierung: DIR './-n', './-' und SRC './-n' = FEHLER (L10-05)
    s="$1"; d="$T/P73"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    _i=0
    for kv in 'COMDARE_THESIS_PDF_DIR=./-n' 'COMDARE_THESIS_PDF_DIR=./-' 'COMDARE_THESIS_PDF_SRC=./-n'; do
        _i=$((_i+1)); klone "$d/work$_i" "$BASE" || { rot "Klon $_i nicht baubar"; return; }; lege_pdfs "$d/work$_i" v1
        lauf "$d/work$_i" "$s" "$d/out$_i" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" "$kv"; rc=$?; zeige "$d/out$_i"
        erw_rc "$rc" 1; erw_text "$d/out$_i" "fuehrendes '-'"; erw_text "$d/out$_i" "L10-05"
        erw_kein_text "$d/out$_i" "PUSH OK"
        fremd=$(ls -A "$d/work$_i" | grep -v -x -e .git -e README.md -e .gitlab-ci.yml -e thesis | wc -l)
        erw_gleich "$fremd" 0 "angelegte Eintraege im Klon $_i ausserhalb des Seeds"
    done
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P74() { # S11-01/S12-01: Signal/Fremd-rc waehrend der Anlage: (a) TERM an die Shell nach echtem mkdir = rc 143,
    # 0 Reste; (b) Shim legt den Kandidaten als FREMDEN leeren Ordner an (mkdir -p) und endet 143 = rc != 0, FEHLER
    # mit rc-Nennung, Ordner BESTEHT (Rest 1 = korrekt: kein rmdir/rm ohne Eigentumsnachweis); (c) Shim endet 2 ohne
    # Anlage = rc != 0, FEHLER mit rc-Nennung, 0 Reste (kein stiller Exit)
    s="$1"; d="$T/P74"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }; echt=$(command -v mkdir)
    f74() { # $1 = Variante a|b|c
        mkdir -p "$d/shim$1" "$d/tmpw$1"; klone "$d/work$1" "$BASE" || { rot "Klon $1 nicht baubar"; return 1; }
        lege_pdfs "$d/work$1" v1
        { printf '%s\n' '#!/bin/sh' 'case "$1 $2 $3" in "-m 0700 --") ;; *) exec '"'$echt'"' "$@" ;; esac'
          case "$1" in
            a) printf '%s\n' "'$echt' -m 0700 -- \"\$4\" || exit \$?" 'kill -TERM $PPID; exit 0' ;;
            b) printf '%s\n' "'$echt' -p -- \"\$4\" || exit \$?" 'exit 143' ;;
            c) printf '%s\n' 'exit 2' ;;
          esac; } > "$d/shim$1/mkdir"
        chmod 0755 "$d/shim$1/mkdir"
        lauf "$d/work$1" "$s" "$d/out$1" "$BASE" PATH="$d/shim$1:$PATH" TMPDIR="$d/tmpw$1" \
            COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?; zeige "$d/out$1"; erw_kein_text "$d/out$1" "PUSH OK"
        rest=$(ls -A "$d/tmpw$1" | wc -l)
        case "$1" in
          a) erw_rc "$rc" 143; erw_gleich "$rest" 0 "Reste unter TMPDIR nach dem Signal (a)" ;;
          b) erw_rc_ne0 "$rc"; erw_text "$d/out$1" "FEHLER: Hilfsordner anlegen: mkdir rc 143,"
             erw_gleich "$rest" 1 "fremder leerer Kandidat BESTEHT nach Kind-rc 143 (b, S12-01: kein rmdir)" ;;
          c) erw_rc_ne0 "$rc"; erw_text "$d/out$1" "FEHLER: Hilfsordner anlegen: mkdir rc 2,"
             erw_gleich "$rest" 0 "Reste unter TMPDIR nach Kind-rc 2 ohne Anlage (c)" ;;
        esac
    }
    f74 a; f74 b; f74 c; t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P75() { # C11-01: Leerraum / Tab / Kommentar+Zeilenwechsel VOR dem Stern: nur Definition = FEHLER, + Konsum gruen
    d="$T/P75"; f09_vorbereitung "$d" || return; tb=$(printf '\t')
    DS=' *{\thesisumfang}{lang}'; DT="${tb}*{\\thesisumfang}{lang}"
    f09_fall "$d" a1 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" "\\providecommand$DS"
    f09_fall "$d" a2 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" "\\providecommand$DT"
    f09_fall "$d" a3 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" '\providecommand%' '*{\thesisumfang}{lang}'
    f09_fall "$d" k1 0 "$F11_K1" "$F11_DC" "$F11_DL" "$F11_KL" "\\providecommand$DS" "$F11_KU"
    f09_fall "$d" k2 0 "$F11_K1" "$F11_DC" "$F11_DL" "$F11_KL" "\\providecommand$DT" "$F11_KU"
    f09_fall "$d" k3 0 "$F11_K1" "$F11_DC" "$F11_DL" "$F11_KL" '\providecommand%' '*{\thesisumfang}{lang}' "$F11_KU"
    for z in a1 a2 a3; do erw_text "$d/out_$z" 'Definitionen 1, Vorkommen 1'; done
}
fall_P76() { # C11-02: Textwache F09-Blockkommentar: neues Literal 1x, altes Literal 0x, Konsum-Formel unveraendert
    d="$T/P76"; mkdir -p "$d"; zf=$(extrahiere_block "$CI_YML" F09-GATE-346 "$d/f09.sh")
    if [ "$zf" -lt 3 ]; then
        echo "      [ENTFAELLT] Block F09-GATE-346 fehlt ($zf Zeilen) -- nur mit Koppelpatch pruefbar"; return
    fi
    l76='Vorkommen ausserhalb erkannter Definitionsziele > 0 (Definition per -usepretex, kein Definitionsgebot)'
    n=$(grep -c -F "$l76" "$d/f09.sh"); erw_gleich "$n" 1 "neues Kommentar-Literal (C11-02) im F09-Block"
    n0=$(grep -c -F 'Makro definiert UND ausserhalb der Definition referenziert' "$d/f09.sh")
    erw_gleich "$n0" 0 "altes Kommentar-Literal im F09-Block"
    n1=$(grep -c -F 'n_kons=$((n_ges - n_def))' "$d/f09.sh"); erw_gleich "$n1" 1 "Konsum-Formel unveraendert"
}
fall_P77() { # C11-04: SIGTERM an die F09-Subshell (git-Shim 'ls-tree' sendet kill -TERM $PPID): rc 143, 0 Reste f09.*
    # Subshell lebt bis zum Ende des Vordergrund-Kindes (Trap vorgemerkt: Marker 'lebt'), kein 'Terminated' der
    # Runner-Shell (kein Signal-Tod). Ohne Traps (m100) raeumt bash 5.2 den Werkordner selbst (EXIT-Trap laeuft im
    # Signal-Handler), stirbt aber sofort: Marker 'tot' (oder fehlt) + 'Terminated' -- so beisst die Mutante.
    d="$T/P77"; f09_vorbereitung "$d" || return; mkdir -p "$d/shim" "$d/tmpf"; echt=$(command -v git)
    { echo '#!/bin/sh'; echo 'case "$1" in ls-tree) kill -TERM $PPID; sleep 1'
      echo '    if kill -0 $PPID 2>/dev/null; then echo lebt > "$P77_MARK"; else echo tot > "$P77_MARK"; fi ;; esac'
      echo "exec '$echt' \"\$@\""; } > "$d/shim/git"; chmod 0755 "$d/shim/git"
    git -C "$MODUL" checkout -q -B t1 "$X1" || { rot "Zweig t1 nicht setzbar"; return; }
    printf '%s\n' "$F11_DC" "$F11_DL" "$F11_KL" "$F11_DU" "$F11_KU" > "$MODUL/diplomarbeit.tex"
    git -C "$MODUL" add diplomarbeit.tex && modul_commit 1758600298 "F12 t1" || { rot "Commit t1"; return; }
    stand "$(git -C "$MODUL" rev-parse HEAD)" || { rot "Stand t1"; return; }
    fahre_block "$d/f09.sh" "$d/out_t1" PATH="$d/shim:$PATH" TMPDIR="$d/tmpf" P77_MARK="$d/mark"; rc=$?
    zeige "$d/out_t1"; erw_rc "$rc" 143; erw_text "$d/out_t1" "FEHLER: F09-GATE-346 abgebrochen"
    erw_kein_text "$d/out_t1" "Terminated"
    mk=$(cat "$d/mark" 2>/dev/null || echo fehlt)
    erw_gleich "$mk" lebt "Subshell lebt bis zum Ende des Vordergrund-Kindes (Signal-Trap vorgemerkt, C11-04)"
    rest=$(ls -A "$d/tmpf" | wc -l); erw_gleich "$rest" 0 "Reste f09.* unter TMPDIR nach SIGTERM an die Subshell"
}

fall_P78() { # S12-01 (ii): das mkdir-Kind ist gegen HUP/INT/TERM immun (Subshell mit trap '' + exec mkdir, das
    # Ignorieren vererbt sich ueber exec): der Shim sendet sich selbst TERM/INT/HUP, ueberlebt, legt an und endet 0
    # -> regulaerer Lauf gruen (rc 0, PUSH OK, 0 Reste); ohne Immunitaet (m101) stirbt das Kind = FEHLER rc 1
    s="$1"; d="$T/P78"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }; echt=$(command -v mkdir)
    mkdir -p "$d/shim" "$d/tmpw"; klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }
    lege_pdfs "$d/work" v1
    { printf '%s\n' '#!/bin/sh' 'case "$1 $2 $3" in "-m 0700 --") ;; *) exec '"'$echt'"' "$@" ;; esac'
      printf '%s\n' 'kill -TERM $$; kill -INT $$; kill -HUP $$'
      printf '%s\n' "'$echt' -m 0700 -- \"\$4\"; rc=\$?; echo \"shim-lebt rc=\$rc\" >> '$d/shim.log'; exit \$rc"
    } > "$d/shim/mkdir"; chmod 0755 "$d/shim/mkdir"
    lauf "$d/work" "$s" "$d/out" "$BASE" PATH="$d/shim:$PATH" TMPDIR="$d/tmpw" COMDARE_THESIS_PDF_REMOTE="$BARE"; rc=$?
    zeige "$d/out"; erw_rc "$rc" 0; erw_text "$d/out" "PUSH OK"; erw_kein_text "$d/out" "FEHLER"
    mk=$(cat "$d/shim.log" 2>/dev/null || echo fehlt)
    erw_gleich "$mk" "shim-lebt rc=0" "mkdir-Kind ueberlebt TERM/INT/HUP an sich selbst (S12-01 ii, Immunitaet)"
    rest=$(ls -A "$d/tmpw" | wc -l); erw_gleich "$rest" 0 "Reste unter TMPDIR nach dem regulaeren Lauf"
}
fall_P79() { # C12-01: Definitionsformen mit \expandafter zwischen Kommando und Ziel (1x, 2x), \futurelet und
    # \global\expandafter\let\expandafter: nur Definition = FEHLER 'kein Konsum' (Definitionen 1, Vorkommen 1),
    # Definition + Konsum = gruen; Praefixe VOR dem Kommando sind unschaedlich (grep -o beginnt am Kommando)
    d="$T/P79"; f09_vorbereitung "$d" || return
    E1='\def\expandafter\thesisumfang{lang}'; E2='\expandafter\def\expandafter\thesisumfang{lang}'
    FL='\futurelet\thesisumfang\relax\relax'; GL='\global\expandafter\let\expandafter\thesisumfang\relax'
    f09_fall "$d" a1 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" "$E1"
    erw_text "$d/out_a1" 'Definitionen 1, Vorkommen 1'
    f09_fall "$d" a2 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" "$E2"
    erw_text "$d/out_a2" 'Definitionen 1, Vorkommen 1'
    f09_fall "$d" a3 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" "$FL"
    erw_text "$d/out_a3" 'Definitionen 1, Vorkommen 1'
    f09_fall "$d" a4 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" "$GL"
    erw_text "$d/out_a4" 'Definitionen 1, Vorkommen 1'
    f09_fall "$d" k1 0 "$F11_K1" "$F11_DC" "$F11_DL" "$F11_KL" "$E1" "$F11_KU"
    f09_fall "$d" k2 0 "$F11_K1" "$F11_DC" "$F11_DL" "$F11_KL" "$E2" "$F11_KU"
    f09_fall "$d" k3 0 "$F11_K1" "$F11_DC" "$F11_DL" "$F11_KL" "$FL" "$F11_KU"
    f09_fall "$d" k4 0 "$F11_K1" "$F11_DC" "$F11_DL" "$F11_KL" "$GL" "$F11_KU"
}

F13_A='\futurelet\thesisumfang\def\thesisumfang{lang}'; F13_B='\def\thesisumfang{x}\def\thesisumfang{y}'
F13_C='\let\thesisumfang\relax\thesisumfang'; F13_G='\thesisumfang\thesisumfang'
F13_I='\futurelet\thesisumfang\thesisumfang'
F13_J='\ifx\thesisumfang\undefined\def\thesisumfang{lang}\fi \thesisumfang'; F13_E='\newcommand*{\thesisumfangX}{x}'
F13_L0='F09-GATE-346: \thesisumfang Definitionen 0, Vorkommen 0, Konsum 0'
F13_L2='F09-GATE-346: \thesisumfang Definitionen 2, Vorkommen 2, Konsum 0'
F13_L02='F09-GATE-346: \thesisumfang Definitionen 0, Vorkommen 2, Konsum 2'
F13_L13='F09-GATE-346: \thesisumfang Definitionen 1, Vorkommen 3, Konsum 2'
fall_P80() { # C13-01 (a)/(b): zwei adjazente Definitionen = 2/2/0 = FEHLER (r13: 1/2/1 = fail-open, die verbrauchende
    # Wortgrenze schluckte den Backslash der Folge-Definition; r14 zaehlt zweistufig per Token-Extraktion)
    d="$T/P80"; f09_vorbereitung "$d" || return
    f09_fall "$d" a 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" "$F13_A"; erw_text "$d/out_a" "$F13_L2"
    f09_fall "$d" b 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" "$F13_B"; erw_text "$d/out_b" "$F13_L2"
}
fall_P81() { # C13-01 (g)/(i)/(c)/(j): adjazente Vorkommen zaehlen je einzeln (r13: (g) 0/1/1, (i) 1/1/0 = falsch)
    d="$T/P81"; f09_vorbereitung "$d" || return
    f09_fall "$d" g 0 "$F13_L02" "$F11_DC" "$F11_DL" "$F11_KL" "$F13_G"
    f09_fall "$d" i 0 "$F11_K1" "$F11_DC" "$F11_DL" "$F11_KL" "$F13_I"
    f09_fall "$d" c 0 "$F11_K1" "$F11_DC" "$F11_DL" "$F11_KL" "$F13_C"
    f09_fall "$d" j 0 "$F13_L13" "$F11_DC" "$F11_DL" "$F11_KL" "$F13_J"
}
fall_P82() { # C13-01 (e): Fremdname \thesisumfangX bleibt in BEIDEN Stufen ausgeschlossen (0/0/0; mit echter Definition
    # + Konsum 1/2/1 unveraendert)
    d="$T/P82"; f09_vorbereitung "$d" || return
    f09_fall "$d" e 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" "$F13_E"; erw_text "$d/out_e" "$F13_L0"
    f09_fall "$d" e2 0 "$F11_K1" "$F11_DC" "$F11_DL" "$F11_KL" "$F11_DU" "$F13_E" \
        "$F11_KU"
}
fall_P83() { # C13-01 rc-Klassen der Stufen: grep -o endet mit rc 2 (Werkzeugfehler) = FEHLER 'grep Definitions-
    # Token', kein Weiterlauf (eine Pipe statt zweier Stufen verschluckte den rc 2 hinter dem rc-1-Filter, pipefail)
    d="$T/P83"; f09_vorbereitung "$d" || return; mkdir -p "$d/shim"; echt=$(command -v grep)
    { printf '%s\n' '#!/bin/sh' 'case "$1" in -o) exit 2 ;; esac' "exec '$echt' \"\$@\""; } > "$d/shim/grep"
    chmod 0755 "$d/shim/grep"
    git -C "$MODUL" checkout -q -B t83 "$X1" || { rot "Zweig t83 nicht setzbar"; return; }
    printf '%s\n' "$F11_DC" "$F11_DL" "$F11_KL" "$F11_DU" "$F11_KU" > "$MODUL/diplomarbeit.tex"
    git -C "$MODUL" add diplomarbeit.tex && modul_commit 1758600298 "F13 t83" || { rot "Commit t83"; return; }
    stand "$(git -C "$MODUL" rev-parse HEAD)" || { rot "Stand t83"; return; }
    fahre_block "$d/f09.sh" "$d/out" PATH="$d/shim:$PATH"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 1; erw_text "$d/out" "FEHLER: grep Definitions-Token"
    erw_text "$d/out" "FEHLER: F09-GATE-346 abgebrochen"
    erw_kein_text "$d/out" 'F09-GATE-346: \thesislang Definitionen'
}
fall_P84() { # C13-02 TeX-Primitive (chardef-Familie): '\chardef\thesisumfang=0' / '\countdef' = Definition (1/1/0 =
    # FEHLER; r13: 0/1/1 fail-open), mit Konsum 1/2/1
    d="$T/P84"; f09_vorbereitung "$d" || return
    f09_fall "$d" a 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" '\chardef\thesisumfang=0'
    erw_text "$d/out_a" 'Definitionen 1, Vorkommen 1'
    f09_fall "$d" b 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" '\countdef\thesisumfang=10'
    erw_text "$d/out_b" 'Definitionen 1, Vorkommen 1'
    f09_fall "$d" k 0 "$F11_K1" "$F11_DC" "$F11_DL" "$F11_KL" '\chardef\thesisumfang=0' "$F11_KU"
}
fall_P85() { # C13-02 plain-Allokatoren: '\newcount\thesisumfang' / '\newsavebox{\thesisumfang}' = Definition
    d="$T/P85"; f09_vorbereitung "$d" || return
    f09_fall "$d" a 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" '\newcount\thesisumfang'
    erw_text "$d/out_a" 'Definitionen 1, Vorkommen 1'
    f09_fall "$d" b 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" '\newsavebox{\thesisumfang}'
    erw_text "$d/out_b" 'Definitionen 1, Vorkommen 1'
    f09_fall "$d" k 0 "$F11_K1" "$F11_DC" "$F11_DL" "$F11_KL" '\newcount\thesisumfang' "$F11_KU"
}
fall_P86() { # C13-02 LaTeX-Definierer: DeclareTextCommand(Default), DeclareMathOperator*, NewCommandCopy,
    # DeclarePairedDelimiter = Definition (je 1/1/0 = FEHLER; r13: 0/1/1 fail-open), mit Konsum 1/2/1
    d="$T/P86"; f09_vorbereitung "$d" || return
    f09_fall "$d" a 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" '\DeclareTextCommand{\thesisumfang}{T1}{x}'
    erw_text "$d/out_a" 'Definitionen 1, Vorkommen 1'
    f09_fall "$d" b 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" '\DeclareMathOperator*{\thesisumfang}{lang}'
    erw_text "$d/out_b" 'Definitionen 1, Vorkommen 1'
    f09_fall "$d" c 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" '\NewCommandCopy\thesisumfang\foo'
    erw_text "$d/out_c" 'Definitionen 1, Vorkommen 1'
    f09_fall "$d" p 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" '\DeclarePairedDelimiter\thesisumfang{\lbrace}{\rbrace}'
    erw_text "$d/out_p" 'Definitionen 1, Vorkommen 1'
    f09_fall "$d" k 0 "$F11_K1" "$F11_DC" "$F11_DL" "$F11_KL" '\DeclareTextCommandDefault{\thesisumfang}{x}' "$F11_KU"
}
fall_P87() { # S13-01: Textwache auf die berichtigten Script-Kommentare (rc-1-Zweig ohne Nummer; Restfenster des
    # mkdir-Kindes nicht nur SIGKILL) + REV-r14-Kopf; alte absolute SIGKILL-Aussage 0x
    s="$1"
    n=$(grep -c -F 'rc 1 = FEHLER (S9-08), jeder andere rc = FEHLER mit rc-Nennung' "$s")
    erw_gleich "$n" 1 "Kommentar 'rc 1 = FEHLER (S9-08), jeder andere rc = FEHLER mit rc-Nennung' (S13-01)"
    n=$(grep -c -F 'ein Abbruch ohne Erfolgsstatus (SIGKILL, andere Signale, Werkzeugfehler' "$s")
    erw_gleich "$n" 1 "Kommentar 'ein Abbruch ohne Erfolgsstatus (SIGKILL, andere Signale, Werkzeugfehler' (S13-01)"
    n=$(grep -c -F 'der Kandidat wird nie angefasst (S13-01)' "$s")
    erw_gleich "$n" 1 "Kommentar 'der Kandidat wird nie angefasst (S13-01)'"
    n=$(grep -c -F 'nur SIGKILL (nicht behandelbar) kann ein leeres Rest-Verzeichnis hinterlassen' "$s")
    erw_gleich "$n" 0 "alte Zusage 'nur SIGKILL (nicht behandelbar) kann ein leeres Rest-Verzeichnis hinterlassen'"
    n=$(grep -c '^# REV r14 ' "$s"); erw_gleich "$n" 1 "REV-r14-Kopf"
}

F14_X='\def\thesisumfangXthesisumfang{x}'; F14_M1='\makeatletter\def\thesisumfang@foo{x}\thesisumfang@foo\makeatother'
F14_M2='\def\thesisumfang{x}\thesisumfang@foo'; F14_M3='\def\thesisumfang{x}\thesisumfang'
F14_L11='F09-GATE-346: \thesisumfang Definitionen 1, Vorkommen 1, Konsum 0'
F14_L011='F09-GATE-346: \thesisumfang Definitionen 0, Vorkommen 1, Konsum 1'
fall_P88() { # C14-01: (a) laengere Fremd-Definition \thesisumfangXthesisumfang + Konsum = 0/1/1 gruen (r14: 1/1/0 =
    # falsches Rot, Stufe 2 prueft nur das Namensende); (b) Fremd-Definition allein = 0/0/0 FEHLER (r14: 1/0/-1)
    d="$T/P88"; f09_vorbereitung "$d" || return
    f09_fall "$d" a 0 "$F14_L011" "$F11_DC" "$F11_DL" "$F11_KL" "$F14_X" '\thesisumfang'
    f09_fall "$d" b 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" "$F14_X"; erw_text "$d/out_b" "$F13_L0"
}
fall_P89() { # C14-02: '@' als Namenszeichen (fail-closed): (a) makeatletter-Form 0/0/0 FEHLER (r14: 1/2/1 fail-open);
    # (b) '\def\thesisumfang{x}\thesisumfang@foo' 1/1/0 FEHLER (auch ausserhalb makeatletter); (c) Normalfall 1/2/1
    d="$T/P89"; f09_vorbereitung "$d" || return
    f09_fall "$d" a 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" "$F14_M1"; erw_text "$d/out_a" "$F13_L0"
    f09_fall "$d" b 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" "$F14_M2"; erw_text "$d/out_b" "$F14_L11"
    f09_fall "$d" c 0 "$F11_K1" "$F11_DC" "$F11_DL" "$F11_KL" "$F14_M3"
}
fall_P90() { # C14-03: Werkdatei 'ges' im Werkordner vorab unschreibbar (444) MIT altem Inhalt (3 Zeilen), per
    # mktemp-Shim im PATH des Blocklaufs -> r15: FEHLER 'Werkdatei ges nicht schreibbar' rc=1 (r14 unter bash:
    # Umleitung rc 1 = 'kein Treffer', der alte Inhalt zaehlte = gruen, fail-open); (k) Fixture ohne Shim = kein Konsum
    d="$T/P90"; f09_vorbereitung "$d" || return; mkdir -p "$d/shim"; echt=$(command -v mktemp)
    { printf '%s\n' '#!/bin/sh' "w=\$('$echt' \"\$@\") || exit \$?"; cat <<'SHIM'; } > "$d/shim/mktemp"
case "$*" in *-d*) printf '%s\n' '\thesisumfang' '\thesisumfang' '\thesisumfang' > "$w/ges"; chmod 444 "$w/ges" ;; esac
printf '%s\n' "$w"
SHIM
    chmod 0755 "$d/shim/mktemp"
    git -C "$MODUL" checkout -q -B t90 "$X1" || { rot "Zweig t90 nicht setzbar"; return; }
    printf '%s\n' "$F11_DC" "$F11_DL" "$F11_KL" "$F11_DU" > "$MODUL/diplomarbeit.tex"
    git -C "$MODUL" add diplomarbeit.tex && modul_commit 1758600298 "F14 t90" || { rot "Commit t90"; return; }
    stand "$(git -C "$MODUL" rev-parse HEAD)" || { rot "Stand t90"; return; }
    fahre_block "$d/f09.sh" "$d/out" PATH="$d/shim:$PATH"; rc=$?; zeige "$d/out"
    erw_rc "$rc" 1; erw_text "$d/out" "FEHLER: Werkdatei ges nicht schreibbar"
    erw_text "$d/out" "FEHLER: F09-GATE-346 abgebrochen"; erw_kein_text "$d/out" "Vorkommen 3"
    f09_fall "$d" k 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" "$F11_DU"; erw_text "$d/out_k" "$F14_L11"
}
fall_P91() { # C14-04: '\font\thesisumfang=cmr10' = Definition (1/1/0 FEHLER; r14: 0/1/1 = Konsum, fail-open) + Konsum-
    # Gegenprobe 1/2/1; Textwache RESTRISIKO-Kommentar zweigeteilt + 'font' + Optionalitaetszeichen (neu 1x, alt 0x)
    d="$T/P91"; f09_vorbereitung "$d" || return
    f09_fall "$d" a 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" '\font\thesisumfang=cmr10'; erw_text "$d/out_a" "$F14_L11"
    f09_fall "$d" k 0 "$F11_K1" "$F11_DC" "$F11_DL" "$F11_KL" '\font\thesisumfang=cmr10' "$F11_KU"
    n=$(grep -c -F 'enthalten kein literales \thesisumfang = 0/0/0 = FEHLER = fail-closed' "$CI_YML")
    erw_gleich "$n" 1 "YAML 'enthalten kein literales \thesisumfang = 0/0/0 = FEHLER = fail-closed' (C14-04 i)"
    n=$(grep -c -F '(\newcommandx, \DeclareTextSymbol) = 0/1/1 =' "$CI_YML")
    erw_gleich "$n" 1 "YAML-Kommentar '(\newcommandx, \DeclareTextSymbol) = 0/1/1 =' (C14-04 ii)"
    n=$(grep -c -F 'zaehlen als KONSUM = fail-open' "$CI_YML")
    erw_gleich "$n" 0 "alte Fassung 'zaehlen als KONSUM = fail-open'"
    n=$(grep -c -F 'toksdef, font;' "$CI_YML"); erw_gleich "$n" 1 "YAML-Kommentar 'toksdef, font;' (C14-04 iii)"
    n=$(grep -c -F 'DeclareTextCommand(Default)?,' "$CI_YML")
    erw_gleich "$n" 1 "YAML-Kommentar 'DeclareTextCommand(Default)?,'"
    n=$(grep -c -F '(Expandable)?DocumentCommand, (New|Renew|Declare)CommandCopy' "$CI_YML")
    erw_gleich "$n" 1 "YAML-Kommentar '(Expandable)?DocumentCommand, (New|Renew|Declare)CommandCopy'"
    n=$(grep -c -F 'DeclarePairedDelimiter(X|XPP)?;' "$CI_YML")
    erw_gleich "$n" 1 "YAML-Kommentar 'DeclarePairedDelimiter(X|XPP)?;'"
}
fall_P92() { # S14-01..S14-05 + REV-r15 (Codex-Lens r14 B, Lead-Hebung): Textwache auf die berichtigten Script-
    # Kommentare (neue Literale 1x, alte 0x) + L14-03 (YAML-Kommentar Kernel-Allokatoren; nur mit F09-Block, sonst LAUT
    # entfallen)
    s="$1"
    n=$(grep -c -F 'seit r13 abgeloest (S12-01)' "$s")
    erw_gleich "$n" 1 "Kommentar 'seit r13 abgeloest (S12-01)' (S14-01)"
    n=$(grep -c -F "'0 Reste' = r12-Messung" "$s"); erw_gleich "$n" 1 "Kommentar ''0 Reste' = r12-Messung' (S14-01)"
    n=$(grep -c -F 'abgearbeitet (0 Reste)' "$s"); erw_gleich "$n" 0 "alte Fassung 'abgearbeitet (0 Reste)' (S14-01)"
    n=$(grep -c -F 'unter TMPDIR bzw. /tmp' "$s"); erw_gleich "$n" 1 "Kommentar 'unter TMPDIR bzw. /tmp' (S14-02)"
    n=$(grep -c -F 'bestaetigten Werkordner, nicht bei SIGKILL (S14-02)' "$s")
    erw_gleich "$n" 1 "Kommentar 'bestaetigten Werkordner, nicht bei SIGKILL (S14-02)'"
    n=$(grep -c -F 'Arbeitsbaums und verschwinden mit dem Script' "$s")
    erw_gleich "$n" 0 "alte Fassung 'Arbeitsbaums und verschwinden mit dem Script' (S14-02)"
    n=$(grep -c -F 'gleicher Inhalt UND Modus 100644 UND Typ blob der Zielfassungen' "$s")
    erw_gleich "$n" 1 "Kommentar 'gleicher Inhalt UND Modus 100644 UND Typ blob der Zielfassungen' (S14-03)"
    n=$(grep -c -F 'byte-gleich zum lokalen Bestand ODER zum Remote-Tip' "$s")
    erw_gleich "$n" 0 "alte Fassung 'byte-gleich zum lokalen Bestand ODER zum Remote-Tip' (S14-03)"
    n=$(grep -c -F 'im Modus --ci oder bei nicht leerer CI/GITLAB_CI-Variable laut' "$s")
    erw_gleich "$n" 1 "Kommentar 'im Modus --ci oder bei nicht leerer CI/GITLAB_CI-Variable laut' (S14-04)"
    n=$(grep -c -F 'in CI (CI/GITLAB_CI gesetzt) laut verweigert' "$s")
    erw_gleich "$n" 0 "alte Fassung 'in CI (CI/GITLAB_CI gesetzt) laut verweigert' (S14-04)"
    n=$(grep -c -F 'Position des doppelten Eintrags nennen' "$s")
    erw_gleich "$n" 1 "Kommentar 'Position des doppelten Eintrags nennen' (S14-05)"
    n=$(grep -c -F 'laut beim Namen nennen' "$s"); erw_gleich "$n" 0 "alte Fassung 'laut beim Namen nennen' (S14-05)"
    n=$(grep -c '^# REV r15 ' "$s"); erw_gleich "$n" 1 "REV-r15-Kopf"
    # r16: die YAML-Textwache L14-03 (Allokatoren) liegt jetzt in P-97 mit dem C15-03-Wortlaut
}
fall_P93() { # L14-01: Konsum NUR als '\thesisumfang' + a-Umlaut (UTF-8 C3 A4) direkt am Namen, Blocklauf unter
    # LC_ALL=en_US.UTF-8: GNU grep zaehlte a-Umlaut in [A-Za-z] (Vorkommen 1 = falsches Rot); r15 pinnt LC_ALL=C je
    # Stufe -> Vorkommen 2, Konsum 1, rc=0. Vorbedingung: Locale en_US.utf8 installiert (sonst GEMESSEN ohne Urteil).
    d="$T/P93"; f09_vorbereitung "$d" || return
    um=$(printf '\303\244'); git -C "$MODUL" checkout -q -B t93 "$X1" || { rot "Zweig t93 nicht setzbar"; return; }
    printf '%s\n' "$F11_DC" "$F11_DL" "$F11_KL" "$F11_DU" "\\thesisumfang$um" > "$MODUL/diplomarbeit.tex"
    git -C "$MODUL" add diplomarbeit.tex && modul_commit 1758600298 "F14 t93" || { rot "Commit t93"; return; }
    stand "$(git -C "$MODUL" rev-parse HEAD)" || { rot "Stand t93"; return; }
    echo "      Nenner: locale -a | grep -c -i en_US.utf8 = $LOCALE_EN"
    fahre_block "$d/f09.sh" "$d/out" LC_ALL=en_US.UTF-8; rc=$?; zeige "$d/out"
    if [ "$LOCALE_EN" -lt 1 ]; then
        echo "      [GEMESSEN] Locale en_US.utf8 fehlt -- rc=$rc ohne Urteil (L14-01)"; return
    fi
    erw_rc "$rc" 0; erw_text "$d/out" "$F11_K1"
    fahre_block "$d/f09.sh" "$d/out_c" LC_ALL=C; rc=$?; zeige "$d/out_c"; erw_rc "$rc" 0; erw_text "$d/out_c" "$F11_K1"
}
fall_P94() { # L14-04: Kernel-/fontspec-Definierer '\newfontfamily\thesisumfang{Latin Modern Roman}' und
    # '\protected@edef\thesisumfang{x}' = Definition (je 1/1/0 FEHLER; r14: 0/1/1 fail-open); Konsum-Gegenprobe 1/2/1
    d="$T/P94"; f09_vorbereitung "$d" || return
    f09_fall "$d" a 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" '\newfontfamily\thesisumfang{Latin Modern Roman}'
    erw_text "$d/out_a" "$F14_L11"
    f09_fall "$d" b 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" '\protected@edef\thesisumfang{x}'
    erw_text "$d/out_b" "$F14_L11"
    f09_fall "$d" c 0 "$F11_K1" "$F11_DC" "$F11_DL" "$F11_KL" '\newfontfamily\thesisumfang{x}' '\thesisumfang'
}

fall_P95() { # C15-01 (r16): Backslash im TMPDIR-Pfad -- GNU sha256sum escapt Dateinamen mit '\' ('\' + Hash); r15
    # hashte Werkdatei und 289-Kopie MIT Dateiname: Font-Kennung = Backslash + 15 Hex, Byte-Urteil s288 != s289 =
    # falsches 'FEHLER: DRIFT'. r16 hasht per stdin und validiert 16 Hex. (a) byte-gleich unter TMPDIR 'tmp_a\b' =
    # rc 0, 4 byte-gleich; (b) anderer Font-Stand = 'Font-Stand abweichend (<16 Hex> vs <16 Hex>, O-15b)' je Fassung.
    d="$T/P95"; mkdir -p "$d"
    ze=$(extrahiere_block "$CI_YML" EPOCH-288 "$d/epoch.sh")
    zd=$(extrahiere_block "$CI_YML" DRIFT-WACHE-288-289 "$d/drift.sh")
    if [ "$ze" -lt 5 ] || [ "$zd" -lt 5 ]; then
        echo "      [ENTFAELLT] Block EPOCH-288/DRIFT-WACHE-288-289 fehlt ($ze/$zd Zeilen) -- P-24 meldet das Fehlen"
        return
    fi
    command -v bash >/dev/null 2>&1 || { rot "bash (Runner-Shell) fehlt -- Block nicht fahrbar"; return; }
    baue_modul "$d" || { rot "Wegwerf-Modul nicht baubar"; return; }
    p24_werkzeuge "$d" || { rot "Wegwerf-Werkzeuge nicht anlegbar"; return; }
    cat "$d/epoch.sh" "$d/bau.sh" "$d/drift.sh" > "$d/lauf.sh"
    bs="$d/tmp_a\\b"
    if ! mkdir -p "$bs" 2>/dev/null; then
        echo "      [GEMESSEN] Dateisystem traegt keinen Backslash im Namen -- P-95 ohne Urteil"; return
    fi
    echo "      Nenner: Backslash im TMPDIR-Pfad = $(printf '%s' "$bs" | grep -c '\\')"
    stand "$Y1" || { rot "Stand Y1 (P-95)"; return; }                   # (a) byte-gleich, TMPDIR mit Backslash
    fahre_block "$d/lauf.sh" "$d/out_a" PATH="$d/bin:$PATH" BAU_MARKE=writeback1 TMPDIR="$bs"; rc=$?; zeige "$d/out_a"
    erw_rc "$rc" 0; erw_text "$d/out_a" "4 byte-gleich geprueft"; erw_kein_text "$d/out_a" "FEHLER: DRIFT"
    erw_kein_text "$d/out_a" "Font-Stand-Kennung unlesbar"
    # (b) anderer Font-Stand
    git -C "$MODUL" checkout -q -B fnt95 "$X1" || { rot "Zweig fnt95 nicht setzbar"; return; }
    LEGE_FONT="$FONT_ALT"; lege_pdf_epoch "$MODUL" "$T1" writeback1; unset LEGE_FONT
    git -C "$MODUL" add -- diplomarbeit-*.pdf \
        && modul_commit 1758600284 "Y1t95 writeback anderer Font-Stand [skip ci]" \
        || { rot "Commit Y1t95"; return; }
    stand "$(git -C "$MODUL" rev-parse HEAD)" || { rot "Stand Y1t95"; return; }
    fahre_block "$d/lauf.sh" "$d/out_b" PATH="$d/bin:$PATH" BAU_MARKE=writeback1 TMPDIR="$bs"; rc=$?; zeige "$d/out_b"
    erw_rc "$rc" 0; erw_text "$d/out_b" "Font-Stand abweichend"; erw_kein_text "$d/out_b" "FEHLER"
    n=$(grep -c -E 'Font-Stand abweichend \([0-9a-f]{16} vs [0-9a-f]{16}, O-15b\)' "$d/out_b")
    erw_gleich "$n" 4 "Kennungen je 16 Hex in 'Font-Stand abweichend (... vs ..., O-15b)' (C15-01)"
    rm -rf "$bs"
}
F16_E='\ExplSyntaxOn\def\thesisumfang:foo{x}\thesisumfang:foo\ExplSyntaxOff'
F16_U='\def\thesisumfang{x}\thesisumfang_x'
fall_P96() { # C15-04 (r16, hochgestuft; Klasse C14-02): unter \ExplSyntaxOn sind ':' und '_' Buchstaben -- r15 zaehlte
    # '\def\thesisumfang:foo{x}\thesisumfang:foo' als 1/2/1 (fremdes Control-Word = Definition + Konsum, fail-open);
    # r16: Token-Klasse [A-Za-z@:_] -> (a) 0/0/0 FEHLER, (b) '\def\thesisumfang{x}\thesisumfang_x' 1/1/0 FEHLER,
    # (c) Normalfall 1/2/1 gruen
    d="$T/P96"; f09_vorbereitung "$d" || return
    f09_fall "$d" a 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" "$F16_E"; erw_text "$d/out_a" "$F13_L0"
    f09_fall "$d" b 1 "$F11_KO" "$F11_DC" "$F11_DL" "$F11_KL" "$F16_U"; erw_text "$d/out_b" "$F14_L11"
    f09_fall "$d" c 0 "$F11_K1" "$F11_DC" "$F11_DL" "$F11_KL" "$F14_M3"
}
fall_P97() { # S15-01..S15-05 + S15-07 + REV-r16 (Codex-Lens r15 B2/B1, Lead K312): Textwache auf die berichtigten
    # Script-Kommentare (neue Literale 1x, alte 0x) + YAML-Kommentare C15-03 + L15-01 (nur mit F09-Block, sonst LAUT
    # entfallen) und C15-05 (nur mit DRIFT-Block, sonst LAUT entfallen)
    s="$1"
    n=$(grep -c -F 'mit PDF-Header-Praefix %PDF- sein' "$s")
    erw_gleich "$n" 1 "Kommentar 'mit PDF-Header-Praefix %PDF- sein' (S15-07)"
    n=$(grep -c -F 'nicht leer und ein PDF sein' "$s")
    erw_gleich "$n" 0 "alte Fassung 'nicht leer und ein PDF sein' (S15-07)"
    n=$(grep -c -F 'diff_gleich --cached vor dem Commit) = kein Commit, kein Push' "$s")
    erw_gleich "$n" 1 "Kommentar 'diff_gleich --cached vor dem Commit) = kein Commit, kein Push' (S15-01)"
    n=$(grep -c -F 'kein weiterer Merge/Push' "$s"); erw_gleich "$n" 1 "Kommentar 'kein weiterer Merge/Push' (S15-01)"
    n=$(grep -c -F 'Remote-Tip) = kein Commit / kein Push' "$s")
    erw_gleich "$n" 0 "alte Fassung 'Remote-Tip) = kein Commit / kein Push' (S15-01)"
    n=$(grep -c -F 'Push mit -o ci.skip auf HEAD:refs/heads/$BRANCH (S10-01' "$s")
    erw_gleich "$n" 1 "Kommentar 'Push mit -o ci.skip auf HEAD:refs/heads/\$BRANCH (S10-01' (S15-03)"
    n=$(grep -c -F 'HEAD:$CI_COMMIT_BRANCH' "$s"); erw_gleich "$n" 0 "alte Fassung 'HEAD:\$CI_COMMIT_BRANCH' (S15-03)"
    n=$(grep -c -F 'jeder abgelehnte Push fuehrt zu Fetch + Abstammungspruefung' "$s")
    erw_gleich "$n" 1 "Kommentar 'jeder abgelehnte Push fuehrt zu Fetch + Abstammungspruefung' (S15-04)"
    n=$(grep -c -F 'nur ein nachgewiesenes non-ff-Race' "$s")
    erw_gleich "$n" 0 "alte Fassung 'nur ein nachgewiesenes non-ff-Race' (S15-04)"
    n=$(grep -c -F 'VOR dem Anlegen des Zielverzeichnisses' "$s")
    erw_gleich "$n" 1 "Kommentar 'VOR dem Anlegen des Zielverzeichnisses' (S15-05)"
    n=$(grep -c -F 'VOR dem ersten Seiteneffekt' "$s")
    erw_gleich "$n" 0 "alte Fassung 'VOR dem ersten Seiteneffekt' (S15-05)"
    n=$(grep -c -F 'bei gleichem Inhalt, Modus 100644 und Typ blob ist der gestagte Diff leer' "$s")
    erw_gleich "$n" 1 "Kommentar 'bei gleichem Inhalt, Modus 100644 und Typ blob ist der gestagte Diff leer' (S15-02)"
    n=$(grep -c -F 'bei byte-gleichem Bestand ist der gestagte Diff leer' "$s")
    erw_gleich "$n" 0 "alte Fassung 'bei byte-gleichem Bestand ist der gestagte Diff leer' (S15-02)"
    n=$(grep -c '^# REV r16 ' "$s"); erw_gleich "$n" 1 "REV-r16-Kopf"
    zf=$(extrahiere_block "$CI_YML" F09-GATE-346 "$T/P97.f09")
    if [ "$zf" -lt 3 ]; then
        echo "      [ENTFAELLT] YAML-Textwache C15-03/L15-01: F09-GATE-346 fehlt ($zf Zeilen) -- nur mit Koppelpatch"
    else
        n=$(grep -c -F 'die uebrigen plain-TeX-Allokator-Makros' "$CI_YML")
        erw_gleich "$n" 1 "YAML-Kommentar 'die uebrigen plain-TeX-Allokator-Makros' (C15-03)"
        n=$(grep -c -F 'plain-TeX-Primitive (L14-03)' "$CI_YML")
        erw_gleich "$n" 0 "alte Fassung 'plain-TeX-Primitive (L14-03)' (C15-03)"
        n=$(grep -c -F 'plain-Allokatoren newcount' "$CI_YML")
        erw_gleich "$n" 0 "alte Fassung 'plain-Allokatoren newcount' (L14-03)"
        l15='bash-only (read -r -d): unter dash laeuft die Dateischleife leer = 0/0/0 = FEHLER, fail-closed (L15-01)'
        n=$(grep -c -F "$l15" "$CI_YML")
        erw_gleich "$n" 1 "YAML-Kommentar 'bash-only (read -r -d): ... fail-closed (L15-01)'"
    fi
    zd=$(extrahiere_block "$CI_YML" DRIFT-WACHE-288-289 "$T/P97.drift")
    if [ "$zd" -lt 5 ]; then
        echo "      [ENTFAELLT] YAML-Textwache C15-05: DRIFT-WACHE-288-289 fehlt ($zd Zeilen) -- nur mit Hauptpatch"
    else
        n=$(grep -c -F 'andere Laengen = anderer Font-Stand; gleiche Laengen' "$CI_YML")
        erw_gleich "$n" 1 "YAML-Kommentar 'andere Laengen = anderer Font-Stand; gleiche Laengen' (C15-05)"
        n=$(grep -c -F 'gleiche Kennung zum Byte-Urteil, nie zu gleich (L15-03, C15-05)' "$CI_YML")
        erw_gleich "$n" 1 "YAML-Kommentar 'gleiche Kennung zum Byte-Urteil, nie zu gleich (L15-03, C15-05)'"
        n=$(grep -c -F 'anderer Font-Stand (Fontpaket-Version) = andere' "$CI_YML")
        erw_gleich "$n" 0 "alte Fassung 'anderer Font-Stand (Fontpaket-Version) = andere' (C15-05)"
    fi
}
fall_P98() { # S16-01..S16-03 + REV-r17 (Codex-Lens r16 B) + C16-01/C16-02 (Koppel F09) + C16-03 (Haupt DRIFT), Lead
    # K313/K314: Textwache auf die r17-Kommentare (neue Literale genau 1x, alte 0x); YAML-Teile nur mit Block, sonst
    # LAUT entfallen; keine Zaehl-Logik, keine Mutante (Kommentar-Fixes sind keine Beiss-Gegenstaende)
    s="$1"
    n=$(grep -c -F 'Vorwachen F-06/F-07/S8-03/S9-05 -> Merge (nie rebase' "$s")
    erw_gleich "$n" 1 "Kommentar 'Vorwachen F-06/F-07/S8-03/S9-05 -> Merge (nie rebase' (S16-01)"
    n=$(grep -c -F 'Tree-Wachen S7-01/S7-02/C6-04 am Merge-Ergebnis' "$s")
    erw_gleich "$n" 1 "Kommentar 'Tree-Wachen S7-01/S7-02/C6-04 am Merge-Ergebnis' (S16-01)"
    n=$(grep -c -F 'bestandenen Folgewachen (F-06, F-07, S8-03/S9-05, S7-01/S7-02/C6-04; S15-04)' "$s")
    erw_gleich "$n" 0 "alte Fassung 'bestandenen Folgewachen (... C6-04; S15-04)' (S16-01)"
    n=$(grep -c -F 'fetch + Abstammungspruefung + Vorwachen + merge (nie rebase) + Tree-Wachen' "$s")
    erw_gleich "$n" 1 "Kommentar 'fetch + Abstammungspruefung + Vorwachen + merge (nie rebase) + Tree-Wachen' (S16-01)"
    n=$(grep -c -F 'fetch + Pruefung + merge (nie rebase), max 5 Versuche' "$s")
    erw_gleich "$n" 0 "alte Fassung 'fetch + Pruefung + merge (nie rebase), max 5 Versuche' (S16-01)"
    n=$(grep -c -F 'Diff-Leerheit setzt gleichen Modus' "$s")
    erw_gleich "$n" 1 "Kommentar 'Diff-Leerheit setzt gleichen Modus' (S16-02)"
    n=$(grep -c -F 'Diff-Leerheit auch bei Moduswechsel' "$s")
    erw_gleich "$n" 0 "alte Fassung 'Diff-Leerheit auch bei Moduswechsel' (S16-02)"
    n=$(grep -c -F 'darf nur A/M-Eintraege aus der Fassungs-Liste enthalten' "$s")
    erw_gleich "$n" 1 "Kommentar 'darf nur A/M-Eintraege aus der Fassungs-Liste enthalten' (S16-03)"
    n=$(grep -c -F 'unveraenderte Fassungen erscheinen darin nicht' "$s")
    erw_gleich "$n" 1 "Kommentar 'unveraenderte Fassungen erscheinen darin nicht' (S16-03)"
    n=$(grep -c -F 'der GESAMTE Index darf GENAU die Fassungs-Liste tragen' "$s")
    erw_gleich "$n" 0 "alte Fassung 'der GESAMTE Index darf GENAU die Fassungs-Liste tragen' (S16-03)"
    n=$(grep -c '^# REV r17 ' "$s"); erw_gleich "$n" 1 "REV-r17-Kopf"
    zf=$(extrahiere_block "$CI_YML" F09-GATE-346 "$T/P98.f09")
    if [ "$zf" -lt 3 ]; then
        echo "      [ENTFAELLT] YAML-Textwache C16-01/C16-02: F09-GATE-346 fehlt ($zf Zeilen) -- nur mit Koppelpatch"
    else
        n=$(grep -c -F 'deshalb bleibt F09 Text-Vorprobe und UMFANG-346 der semantische' "$CI_YML")
        erw_gleich "$n" 1 "YAML-Kommentar 'deshalb bleibt F09 Text-Vorprobe und UMFANG-346 der semantische' (C16-01)"
        n=$(grep -c -F 'zaehlt als Vorkommen (Scheinkonsum' "$CI_YML")
        erw_gleich "$n" 1 "YAML-Kommentar 'zaehlt als Vorkommen (Scheinkonsum' (C16-01)"
        n=$(grep -c -F 'sind NICHT modelliert = fail-closed (der Zeilenrest faellt weg' "$CI_YML")
        erw_gleich "$n" 0 "alte Fassung 'sind NICHT modelliert = fail-closed (der Zeilenrest faellt weg' (C16-01)"
        n=$(grep -c -F '(iii, r17) beliebige Catcode-Aenderungen sind NICHT modelliert' "$CI_YML")
        erw_gleich "$n" 1 "YAML-Kommentar '(iii, r17) beliebige Catcode-Aenderungen sind NICHT modelliert' (C16-02)"
        n=$(grep -c -F 'ersetzt keinen TeX-Tokenizer' "$CI_YML")
        erw_gleich "$n" 1 "YAML-Kommentar 'ersetzt keinen TeX-Tokenizer' (C16-02)"
        n=$(grep -c -F 'RESTRISIKO dreigeteilt (C14-04 + C16-02)' "$CI_YML")
        erw_gleich "$n" 1 "YAML-Kommentar 'RESTRISIKO dreigeteilt (C14-04 + C16-02)' (C16-02)"
        n=$(grep -c -F 'r17 (Codex-Lens r16 C16-01 SOLL + C16-02 hochgestuft' "$CI_YML")
        erw_gleich "$n" 1 "YAML-Absatz 'r17 (Codex-Lens r16 C16-01 SOLL + C16-02 hochgestuft' (F09)"
    fi
    zd=$(extrahiere_block "$CI_YML" DRIFT-WACHE-288-289 "$T/P98.drift")
    if [ "$zd" -lt 5 ]; then
        echo "      [ENTFAELLT] YAML-Textwache C16-03: DRIFT-WACHE-288-289 fehlt ($zd Zeilen) -- nur mit Hauptpatch"
    else
        n=$(grep -c -F 'FontFile3 (CFF/OpenType), Type3 und PK-Fonts tragen KEIN Length1/2/3' "$CI_YML")
        erw_gleich "$n" 1 "YAML-Kommentar 'FontFile3 (CFF/OpenType), Type3 und PK-Fonts ... KEIN Length1/2/3' (C16-03)"
        n=$(grep -c -F 'die fn-0-Zweige greifen vorher (L16-02)' "$CI_YML")
        erw_gleich "$n" 1 "YAML-Kommentar 'die fn-0-Zweige greifen vorher (L16-02)' (C16-03)"
        n=$(grep -c -F 'Kennung aus der PDF selbst: eingebettete Font-Programme tragen' "$CI_YML")
        erw_gleich "$n" 0 "alte Fassung 'Kennung aus der PDF selbst: eingebettete Font-Programme tragen' (C16-03)"
        n=$(grep -c -F 'r17 (Codex-Lens r16 C16-03 hochgestuft' "$CI_YML")
        erw_gleich "$n" 1 "YAML-Absatz 'r17 (Codex-Lens r16 C16-03 hochgestuft' (DRIFT)"
    fi
}

fall() { # $1 = Kennung, $2 = Funktion, $3 = Script
    FEHL=0; echo ""; echo "== $1 =="
    "$2" "$3"
    eval "BASIS_$(printf '%s' "$1" | tr -d -)=\$FEHL" # r8 (L7-03): Basis-FEHL je Fall fuer biss()
    if [ "$FEHL" -eq 0 ]; then
        echo "  $1: GRUEN"; GRUEN_N=$((GRUEN_N+1))
    else
        echo "  $1: ROT ($FEHL Erwartung(en) gerissen)"; ROT_N=$((ROT_N+1)); ROT_LISTE="$ROT_LISTE $1"
    fi
}

fall P-01 fall_P01 "$SKRIPT"
fall P-02 fall_P02 "$SKRIPT"
fall P-03 fall_P03 "$SKRIPT"
fall P-04a fall_P04a "$SKRIPT"
fall P-04b fall_P04b "$SKRIPT"
fall P-04c fall_P04c "$SKRIPT"
fall P-05 fall_P05 "$SKRIPT"
fall P-06 fall_P06 "$SKRIPT"
fall P-07 fall_P07 "$SKRIPT"
fall P-08 fall_P08 "$SKRIPT"
fall P-09 fall_P09 "$SKRIPT"
fall P-09c fall_P09c "$SKRIPT"
fall P-10 fall_P10 "$SKRIPT"
fall P-11 fall_P11 "$SKRIPT"
fall P-12 fall_P12 "$SKRIPT"
fall P-13 fall_P13 "$SKRIPT"
fall P-14 fall_P14 "$SKRIPT"
fall P-15 fall_P15 "$SKRIPT"
fall P-09b fall_P09b "$SKRIPT"
fall P-16 fall_P16 "$SKRIPT"
fall P-17 fall_P17 "$SKRIPT"
fall P-18 fall_P18 "$SKRIPT"
fall P-19 fall_P19 "$SKRIPT"
fall P-20 fall_P20 "$SKRIPT"
fall P-21 fall_P21 "$SKRIPT"
fall P-22 fall_P22 "$SKRIPT"
fall P-23 fall_P23 "$SKRIPT"
fall P-24 fall_P24 "$SKRIPT"
fall P-25 fall_P25 "$SKRIPT"
fall P-26 fall_P26 "$SKRIPT"
fall P-27 fall_P27 "$SKRIPT"
fall P-28 fall_P28 "$SKRIPT"
fall P-29 fall_P29 "$SKRIPT"
fall P-30 fall_P30 "$SKRIPT"
fall P-31 fall_P31 "$SKRIPT"
fall P-32 fall_P32 "$SKRIPT"
fall P-33 fall_P33 "$SKRIPT"
fall P-34 fall_P34 "$SKRIPT"
fall P-35 fall_P35 "$SKRIPT"
fall P-36 fall_P36 "$SKRIPT"
fall P-37 fall_P37 "$SKRIPT"
fall P-38 fall_P38 "$SKRIPT"
fall P-39 fall_P39 "$SKRIPT"
fall P-40 fall_P40 "$SKRIPT"
fall P-41 fall_P41 "$SKRIPT"
fall P-42 fall_P42 "$SKRIPT"
fall P-43 fall_P43 "$SKRIPT"
fall P-44 fall_P44 "$SKRIPT"
fall P-45 fall_P45 "$SKRIPT"
fall P-46 fall_P46 "$SKRIPT"
fall P-47 fall_P47 "$SKRIPT"
fall P-48 fall_P48 "$SKRIPT"
fall P-49 fall_P49 "$SKRIPT"
fall P-50 fall_P50 "$SKRIPT"
fall P-51 fall_P51 "$SKRIPT"
fall P-52 fall_P52 "$SKRIPT"
fall P-53 fall_P53 "$SKRIPT"
fall P-54 fall_P54 "$SKRIPT"
fall P-55 fall_P55 "$SKRIPT"
fall P-56 fall_P56 "$SKRIPT"
fall P-57 fall_P57 "$SKRIPT"
fall P-58 fall_P58 "$SKRIPT"
fall P-59 fall_P59 "$SKRIPT"
fall P-60 fall_P60 "$SKRIPT"
fall P-61 fall_P61 "$SKRIPT"
fall P-62 fall_P62 "$SKRIPT"
fall P-63 fall_P63 "$SKRIPT"
fall P-64 fall_P64 "$SKRIPT"
fall P-65 fall_P65 "$SKRIPT"
fall P-66 fall_P66 "$SKRIPT"
fall P-67 fall_P67 "$SKRIPT"
fall P-68 fall_P68 "$SKRIPT"
fall P-69 fall_P69 "$SKRIPT"
fall P-70 fall_P70 "$SKRIPT"
fall P-71 fall_P71 "$SKRIPT"
fall P-72 fall_P72 "$SKRIPT"
fall P-73 fall_P73 "$SKRIPT"
fall P-74 fall_P74 "$SKRIPT"
fall P-75 fall_P75 "$SKRIPT"
fall P-76 fall_P76 "$SKRIPT"
fall P-77 fall_P77 "$SKRIPT"
fall P-78 fall_P78 "$SKRIPT"
fall P-79 fall_P79 "$SKRIPT"
fall P-80 fall_P80 "$SKRIPT"
fall P-81 fall_P81 "$SKRIPT"
fall P-82 fall_P82 "$SKRIPT"
fall P-83 fall_P83 "$SKRIPT"
fall P-84 fall_P84 "$SKRIPT"
fall P-85 fall_P85 "$SKRIPT"
fall P-86 fall_P86 "$SKRIPT"
fall P-87 fall_P87 "$SKRIPT"
fall P-88 fall_P88 "$SKRIPT"
fall P-89 fall_P89 "$SKRIPT"
fall P-90 fall_P90 "$SKRIPT"
fall P-91 fall_P91 "$SKRIPT"
fall P-92 fall_P92 "$SKRIPT"
fall P-93 fall_P93 "$SKRIPT"
fall P-94 fall_P94 "$SKRIPT"
fall P-95 fall_P95 "$SKRIPT"
fall P-96 fall_P96 "$SKRIPT"
fall P-97 fall_P97 "$SKRIPT"
fall P-98 fall_P98 "$SKRIPT"
N_FAELLE=$((GRUEN_N + ROT_N))

# --------------------------------------------------------------------------- Selbstbiss
BISS_RC=0; MUT_N=0; ENTF_N=0
if [ "$SELBSTBISS" -eq 1 ]; then
    echo ""; echo "== SELBSTBISS: Mutanten muessen ROT werden =="
    MUT="$T/mutanten"; mkdir -p "$MUT"
    # M1: Marker [skip ci] aus der Merge-Botschaft -> P-03 muss reissen (F-04)
    sed 's/ \[skip ci\]" FETCH_HEAD/" FETCH_HEAD/' "$SKRIPT" > "$MUT/m1.sh"
    # M2: Symlink-Pruefung der Zieldatei entfernt -> P-05 muss reissen (F-03)
    sed '/Symlink (Zieldatei verboten)/d' "$SKRIPT" > "$MUT/m2.sh"
    # M3: Remote-Idempotenz-Zweig entfernt -> P-02 muss reissen (F-07)
    sed '/# F-07 Remote-Idempotenz/,/^  fi$/d' "$SKRIPT" > "$MUT/m3.sh"
    # M4: .git-Muster aus dem case entfernt -> P-16 muss reissen (L1-01, 1. Schicht)
    sed '/traegt eine .git-Komponente/d' "$SKRIPT" > "$MUT/m4.sh"
    # M5: Inhalts-Invariante nach git add entfernt -> P-19 muss reissen (L1-01, 2. Schicht)
    sed '/nicht den Inhalt der Arbeitskopie/d' "$SKRIPT" > "$MUT/m5.sh"
    # M6: Arbeitsbaum-Grenze vor mkdir entfernt -> P-18 muss reissen (L1-02)
    sed '/liegt ausserhalb des Arbeitsbaums/d' "$SKRIPT" > "$MUT/m6.sh"
    # M10: https-Pflicht entfernt -> P-27 muss reissen (L2-08)
    sed '/ist nicht https:\/\//d' "$SKRIPT" > "$MUT/m10.sh"
    # M11: Duplikat-Pruefung entfernt -> P-26 muss reissen (L2-06)
    sed '/doppelt in COMDARE_THESIS_PDF_FASSUNGEN/d' "$SKRIPT" > "$MUT/m11.sh"
    # M12: '//'-Faltung entfernt -> P-25 muss reissen (L2-05)
    sed '/_p%%\/\/\*/d' "$SKRIPT" > "$MUT/m12.sh"
    # M36 (r7): Blob-Nachpruefung nach dem Merge entfernt (Mischstand pushbar) -> P-28 muss reissen (C6-04)
    sed '/am Remote fremd bewegt/d' "$SKRIPT" > "$MUT/m36.sh"
    # M37 (r7): F-06 ohne den Script-Pfad -> P-04c muss reissen (C6-05)
    sed 's/ ci\/thesis_pdf_export.sh; then/; then/' "$SKRIPT" > "$MUT/m37.sh"
    # M38 (r7): Instanz-Host-Pruefungen entfernt (Transport an fremden Host) -> P-09 muss reissen (C6-06)
    sed '/ist nicht die Instanz/d; /zeigt nicht auf die Instanz/d' "$SKRIPT" > "$MUT/m38.sh"
    # M39 (r7): --ci-Verweigerung des Testhakens entfernt -> P-31 muss reissen (C6-07)
    sed 's/\[ "\$MODUS" != ci \] \\$/true \\/' "$SKRIPT" > "$MUT/m39.sh"
    # M40 (r7): Arbeitsbaum-Grenze der Quelle entfernt -> P-29 muss reissen (C6-08)
    sed '/(Quelle) liegt ausserhalb des Arbeitsbaums/d' "$SKRIPT" > "$MUT/m40.sh"
    # M43 (r7): jeder Fremdwert wieder INERT -> P-30 muss reissen (C6-13)
    sed 's/\*) fehler "COMDARE_THESIS_PDF_EXPORT: Wert.*/*) echo "INERT: Schalter"; exit 0 ;;/' \
        "$SKRIPT" > "$MUT/m43.sh"
    # M52 (r8b): Rueckbau auf den Blob-Vergleich (Modus/Typ unbeachtet) -> P-32 muss reissen (S7-01)
    sed -e 's/^    \[ "\$ma" = "100644" \] && \[ "\$ta" = "blob" \] \\$/    true \\/' \
        -e 's/^    \[ "\$a" = "\$b" \] || ueberholt/    [ "${a##* }" = "${b##* }" ] || ueberholt/' \
        "$SKRIPT" > "$MUT/m52.sh"
    # M53 (r8b): geloeschte Fassung wieder FEHLER statt UEBERHOLT -> P-34 muss reissen (S7-02)
    # M53 (r9, neu definiert): Loesch-Erkennung VOR dem Merge entfernt -> P-45 (a) muss reissen (S8-03)
    sed '/# S8-03\/S9-05: Loesch-Erkennung VOR dem Merge$/,/done < "\$WERK\/dst.txt"   # S8-03$/d' \
        "$SKRIPT" > "$MUT/m53.sh"
    # M54 (r8b): Wache gegen ungestagte Fremdaenderungen unter DIR entfernt -> P-35 muss reissen (S7-03 a)
    sed '/ausserhalb der Fassungs-Liste (ungestagt, S7-03)/d' "$SKRIPT" > "$MUT/m54.sh"
    # M55 (r8b): beide Projektpfad-Gleichheitspruefungen entfernt -> P-37 muss reissen (S7-04)
    sed '/kanonischer Projektpfad (S7-04)/d' "$SKRIPT" > "$MUT/m55.sh"
    # M56 (r8b): Remote-Idempotenz wieder auf dem Verzeichnis -> P-36 muss reissen (S7-03 b)
    sed 's/HEAD FETCH_HEAD -- "\$@"; then/HEAD FETCH_HEAD -- "$DIR"; then/' "$SKRIPT" > "$MUT/m56.sh"
    # M57 (r8b): URL-Wert wieder in der userinfo-Meldung -> P-38 muss reissen (S7-05)
    sed 's/CI_SERVER_URL traegt userinfo/CI_SERVER_URL '"'"'$CI_SERVER_URL'"'"' traegt userinfo/' \
        "$SKRIPT" > "$MUT/m57.sh"
    # M58 (r8b): Leerwert des Schalters wieder Default true -> P-39 muss reissen (S7-06)
    sed 's/^SW="\${COMDARE_THESIS_PDF_EXPORT-true}"/SW="${COMDARE_THESIS_PDF_EXPORT:-true}"/' "$SKRIPT" > "$MUT/m58.sh"
    # M59 (r8b): Leerwert-Wache fuer DIR entfernt -> P-39 muss reissen (S7-06)
    sed '/COMDARE_THESIS_PDF_DIR ist gesetzt, aber leer/d' "$SKRIPT" > "$MUT/m59.sh"
    # M60 (r8b): Header-Vergleich entfernt -> P-12 muss reissen (S7-08)
    sed 's/^  \[ "\$hdr" = "%PDF-" \] || /  : || /' "$SKRIPT" > "$MUT/m60.sh"
    # M61 (r8b): TERM-Trap entfernt -> P-41 muss reissen (S7-08)
    sed 's/; trap .exit 143. TERM//' "$SKRIPT" > "$MUT/m61.sh"
    # M62 (r9; r10 Doppelmutante): GIT_LITERAL_PATHSPECS-Export UND S9-03-Zeichenklasse entfernt (Glob-add) -> P-42
    sed -e '/^export GIT_LITERAL_PATHSPECS=1/d' -e '/unzulaessige Zeichen (S9-03)/d' "$SKRIPT" > "$MUT/m62.sh"
    # M63 (r9): Rename-Erkennung toleriert (ohne --no-renames, Status R akzeptiert, nur Zielpfad) -> P-43 (S8-01 b)
    sed -e 's/ --no-renames --name-status / --name-status /' -e 's/A|M) ;;/A|M|R*) ;;/' \
        -e 's/pf="\${zeile#\*\$TAB}"/pf="${zeile##*$TAB}"/' "$SKRIPT" > "$MUT/m63.sh"
    # M64 (r9): Rueckbau auf 'cp -f' (kein rm -f, kein chmod) -> P-44 (a) muss reissen (S8-02)
    sed -e '/^  rm -f -- "\$dst" || fehler/d' -e '/^  chmod 0644 -- "\$dst" || fehler/d' \
        -e 's/^  cp -- "\$src" "\$dst"/  cp -f -- "$src" "$dst"/' "$SKRIPT" > "$MUT/m64.sh"
    # M65 (r9): Index-Modus-Wache + Tree-Pruefung des eigenen Commits entfernt -> P-44 (c) muss reissen (S8-02)
    sed -e '/statt 100644 im Index (S8-02)/d' -e '/blob der Quelle (S8-02)/d' "$SKRIPT" > "$MUT/m65.sh"
    # M66 (r9): Loesch-Erkennung vor dem Merge UND UEBERHOLT nach dem Merge entfernt -> P-34 muss reissen (S7-02)
    sed -e '/# S8-03\/S9-05: Loesch-Erkennung VOR dem Merge$/,/done < "\$WERK\/dst.txt"   # S8-03$/d' \
        -e 's/\[ -n "\$a" \] || ueberholt "Fassung \$dst am Remote geloescht/[ -n "$a" ] || fehler "m66 geloescht/' \
        "$SKRIPT" > "$MUT/m66.sh"
    # M67 (r9): Rohwert des Schalters wieder in der Meldung -> P-47 muss reissen (S8-05)
    sed "s/EXPORT: Wert nicht in {true,false}/EXPORT='\$SW' nicht in {true,false}/" \
        "$SKRIPT" > "$MUT/m67.sh"
    # M68 (r9; r11 neu definiert): mkdir -p (Kollision mit bestehendem Pfad toleriert) -> P-48 (a) muss reissen (S9-08)
    ersetze_literal "$SKRIPT" 'exec mkdir -m 0700 --' 'exec mkdir -p -m 0700 --' > "$MUT/m68.sh"   # r13: Anlagezeile
    # M69 (r9): Leerraum-/Steuerzeichen-Wache entfernt -> P-39 muss reissen (L8-01)
    sed '/enthaelt Leerraum oder Steuerzeichen (S7-06\/L8-01)/d' "$SKRIPT" > "$MUT/m69.sh"
    # M71 (r10): S9-03-Zeichen-/Formwache entfernt -> P-50 muss reissen
    sed '/(S9-03)/d' "$SKRIPT" > "$MUT/m71.sh"
    # M72 (r10): S9-07-CI-Wertwache entfernt -> P-51 muss reissen
    sed '/(S9-07)/d' "$SKRIPT" > "$MUT/m72.sh"
    # M73 (r10): fehler() wieder per echo -> P-52 (Textwache) muss reissen (S9-09)
    sed "s/^fehler() { printf '%s\\\\n' \"FEHLER: \$\*\"; exit 1; }/fehler() { echo \"FEHLER: \$*\"; exit 1; }/" \
        "$SKRIPT" > "$MUT/m73.sh"
    # M74 (r10): --no-filters entfernt (gefilterte Hashes) -> P-53 muss reissen (S9-01)
    sed 's/ --no-filters//g' "$SKRIPT" > "$MUT/m74.sh"
    # M75 (r10): core.fileMode=true entfernt -> P-54 muss reissen (S9-02)
    sed 's/ -c core.fileMode=true//g' "$SKRIPT" > "$MUT/m75.sh"
    # M76 (r10): scp-Maske entfernt -> P-55 muss reissen (L9-04)
    sed "s/ -e 's#\[^ \/:@\]\*@\[^ \/:@\]\*:#<cred>@<host>:#g'//" "$SKRIPT" > "$MUT/m76.sh"
    # M77 (r10): Maske zurueck auf r9 '[^/@]' (Kennwort-Rest hinter dem letzten '@' sichtbar) -> P-55 (S9-06)
    sed "s|s#//\[^/\]\*@#//<cred>@#g|s#//[^/@]*@#//<cred>@#g|g" "$SKRIPT" > "$MUT/m77.sh"
    # M78 (r10): Werkzeugfehler der Remote-Seite gilt wieder als 'geloescht' (r9-Semantik der cat-file-Form) -> P-56
    sed 's/ || fehler "git ls-tree FETCH_HEAD -- \$dst (S9-05)"/ || r=/' "$SKRIPT" > "$MUT/m78.sh"
    # M79 (r10): Index-Abfrage zurueck auf ':$dst' -> P-59 (Textwache) muss reissen (S9-04)
    sed 's/rev-parse --verify -q ":0:\$dst"/rev-parse --verify -q ":$dst"/' "$SKRIPT" > "$MUT/m79.sh"
    # M80 (r10, L9-01): Kopfkommentar-Mutantenzahl zurueck auf 51 -> P-57 (Textwache am Harnisch) muss reissen
    sed 's/SELBSTBISS (--selbstbiss): [0-9]* Wegwerf-Mutanten/SELBSTBISS (--selbstbiss): 51 Wegwerf-Mutanten/' \
        "$SELBST" > "$MUT/m80.sh"
    # M81 (r11): Push-Ziel zurueck auf 'HEAD:$BRANCH' (Kurzname statt voller Ref) -> P-60 muss reissen (S10-01)
    sed 's/"HEAD:refs\/heads\/\$BRANCH"/"HEAD:$BRANCH"/' "$SKRIPT" > "$MUT/m81.sh"
    # M82 (r11): Branchnamen-Pruefung (check-ref-format) entfernt -> P-60 muss reissen (S10-01)
    sed '/^git check-ref-format --branch "\$BRANCH"/,/kein gueltiger Branchname (S10-01)/d' "$SKRIPT" > "$MUT/m82.sh"
    # M83 (r11): ':-NA'-Semantik zurueck (leer und 'NA' = ungesetzt) -> P-61 muss reissen (S10-02)
    sed -e 's/^if \[ "\${CI_COMMIT_SHORT_SHA+x}" = x \]; then$/if [ "${CI_COMMIT_SHORT_SHA:-NA}" != NA ]; then/' \
        -e 's/^if \[ "\${CI_PIPELINE_ID+x}" = x \]; then$/if [ "${CI_PIPELINE_ID:-NA}" != NA ]; then/' \
        "$SKRIPT" > "$MUT/m83.sh"
    # M84 (r11): WERK-Zuweisung VOR mkdir (der Trap kennt den fremden Pfad) -> P-62 muss reissen (S10-03)
    ersetze_literal "$SKRIPT" "rc=0; ( trap ''" "WERK=\$kand; rc=0; ( trap ''" > "$MUT/m84.sh"   # r13: WERK VOR Anlage
    # M85 (r11): TMPDIR-Wache entfernt und chmod ohne '--' -> P-63 muss reissen (S10-04)
    sed -e '/(S10-04)/d' -e 's/^  chmod 0700 -- "\$WERK\/askpass.sh".*/  chmod 0700 "$WERK\/askpass.sh"/' \
        "$SKRIPT" > "$MUT/m85.sh"
    # M86 (r11): aufgeloester Quellpfad wieder in der C6-08-Meldung -> P-64 muss reissen (S10-06)
    sed 's/liegt ausserhalb des Arbeitsbaums (SRC_K, C6-08)/liegt ausserhalb des Arbeitsbaums ($SRC_K, C6-08)/' \
        "$SKRIPT" > "$MUT/m86.sh"
    # M87 (r11): ungestagt-Diff ohne core.fileMode=true -> P-65 muss reissen (S10-07)
    sed 's/^ungestagt=\$(git -c core.fileMode=true diff/ungestagt=$(git diff/' "$SKRIPT" > "$MUT/m87.sh"
    # M88 (r11): '-*'-Zweig fuer DIR/SRC entfernt -> P-66 muss reissen (L10-05)
    sed '/(L10-05)/d' "$SKRIPT" > "$MUT/m88.sh"
    # M89 (r11): scheme-Maske (Formen ohne '//') entfernt -> P-67 muss reissen (S10-05)
    sed "s/ -e 's#\[A-Za-z\]\[A-Za-z0-9+.-\]\*:\[^\/ @\]\*@#<scheme>:<cred>@#g'//" "$SKRIPT" > "$MUT/m89.sh"
    # M95 (r12): '-*' aus der Wache nach der Normalisierung entfernt -> P-73 muss reissen (S11-02)
    sed '/L10-05\/S11-02)/d' "$SKRIPT" > "$MUT/m95.sh"
    # M96 (r12): alte Signal-Traps (exit statt vormerken) waehrend der Anlage -> P-74 (a) muss reissen (S11-01)
    l96a="trap 'sig=129' HUP; trap 'sig=130' INT; trap 'sig=143' TERM"
    l96b="trap 'exit 129' HUP; trap 'exit 130' INT; trap 'exit 143' TERM"
    sed "s/^$l96a\$/$l96b/" "$SKRIPT" > "$MUT/m96.sh"
    # M97 (r13, S12-01 i): Loesch-Zweig (rmdir) im '*'-Zweig zurueck -> P-74 (b) muss reissen (Fremdes entfernt)
    l97a='  *) fehler "Hilfsordner anlegen: mkdir rc'
    l97b='  *) rmdir -- "$kand" 2>/dev/null || :; fehler "Hilfsordner anlegen: mkdir rc'
    ersetze_literal "$SKRIPT" "$l97a" "$l97b" > "$MUT/m97.sh"
    # M101 (r13, S12-01 ii): Immunitaets-Trap des mkdir-Kindes entfernt -> P-78 muss reissen (Kind stirbt am Signal)
    ersetze_literal "$SKRIPT" "( trap '' HUP INT TERM; exec mkdir" '( exec mkdir' > "$MUT/m101.sh"
    # M102 (r13, S12-01 i): '*'-Zweig setzt WERK (fremder Kandidat wuerde eigener) -> P-74 (b) muss reissen
    l102a='  *) fehler "Hilfsordner anlegen: mkdir rc $rc, Anlage unbestaetigt, Kandidat unangetastet (S12-01)" ;;'
    ersetze_literal "$SKRIPT" "$l102a" '  *) WERK=$kand ;;' > "$MUT/m102.sh"
    MUT_N=$MUT_N_SKRIPT; ENTF_N=0; NB_N=0
    for m in m1 m2 m3 m4 m5 m6 m10 m11 m12 m36 m37 m38 m39 m40 m43 m52 m53 m54 m55 m56 m57 m58 m59 m60 m61 \
             m62 m63 m64 m65 m66 m67 m68 m69 m71 m72 m73 m74 m75 m76 m77 m78 m79 \
             m81 m82 m83 m84 m85 m86 m87 m88 m89 m95 m96 m97 m101 m102; do
        if cmp -s "$SKRIPT" "$MUT/$m.sh"; then
            echo "  [ABBRUCH] Mutante $m ist byte-gleich zum Script -- das Muster greift nicht"; BISS_RC=2
        fi
    done
    basis_von() { eval "printf '%s' \"\${BASIS_$(printf '%s' "$1" | tr -d -):-0}\""; } # r8 (L7-03)
    nicht_bewertbar() { # $1 = Mutante, $2 = Kennung, $3 = Basis-FEHL: roter Basisfall, Mutante nicht gezaehlt
        echo "  [NICHT BEWERTBAR] Fall $2 ohne Mutation rot ($3 Erwartung(en)) -- Mutante $1 nicht bewertbar"
        MUT_N=$((MUT_N-1)); NB_N=$((NB_N+1))
    }
    biss() { # $1 = Mutante, $2 = Fallfunktion, $3 = Kennung; r8 (L7-03): 'beisst' nur bei r > Basis-FEHL
        basis=$(basis_von "$3"); if [ "$basis" -gt 0 ]; then nicht_bewertbar "$1" "$3" "$basis"; return 0; fi
        T_ALT="$T"; T="$T/biss_$1"; mkdir -p "$T"
        ( FEHL=0; "$2" "$MUT/$1.sh" > "$T/protokoll.txt" 2>&1; exit "$FEHL" ); r=$?
        T="$T_ALT"
        if [ "$r" -gt "$basis" ]; then
            echo "  [OK]  Mutante $1 macht $3 ROT ($r gerissene Erwartung(en)) -- die Probe beisst"
        else
            echo "  [ABBRUCH] Mutante $1 laesst $3 GRUEN -- die Probe beweist nichts"; BISS_RC=2
        fi
    }
    [ "$BISS_RC" -eq 0 ] && biss m1 fall_P03 P-03
    [ "$BISS_RC" -eq 0 ] && biss m2 fall_P05 P-05
    [ "$BISS_RC" -eq 0 ] && biss m3 fall_P02 P-02
    [ "$BISS_RC" -eq 0 ] && biss m4 fall_P16 P-16
    [ "$BISS_RC" -eq 0 ] && biss m5 fall_P19 P-19
    [ "$BISS_RC" -eq 0 ] && biss m6 fall_P18 P-18
    [ "$BISS_RC" -eq 0 ] && biss m10 fall_P27 P-27
    [ "$BISS_RC" -eq 0 ] && biss m11 fall_P26 P-26
    [ "$BISS_RC" -eq 0 ] && biss m12 fall_P25 P-25
    [ "$BISS_RC" -eq 0 ] && biss m36 fall_P28 P-28
    [ "$BISS_RC" -eq 0 ] && biss m37 fall_P04c P-04c
    [ "$BISS_RC" -eq 0 ] && biss m38 fall_P09 P-09
    [ "$BISS_RC" -eq 0 ] && biss m39 fall_P31 P-31
    [ "$BISS_RC" -eq 0 ] && biss m40 fall_P29 P-29
    [ "$BISS_RC" -eq 0 ] && biss m43 fall_P30 P-30
    [ "$BISS_RC" -eq 0 ] && biss m52 fall_P32 P-32
    [ "$BISS_RC" -eq 0 ] && biss m53 fall_P45 P-45
    [ "$BISS_RC" -eq 0 ] && biss m54 fall_P35 P-35
    [ "$BISS_RC" -eq 0 ] && biss m55 fall_P37 P-37
    [ "$BISS_RC" -eq 0 ] && biss m56 fall_P36 P-36
    [ "$BISS_RC" -eq 0 ] && biss m57 fall_P38 P-38
    [ "$BISS_RC" -eq 0 ] && biss m58 fall_P39 P-39
    [ "$BISS_RC" -eq 0 ] && biss m59 fall_P39 P-39
    [ "$BISS_RC" -eq 0 ] && biss m60 fall_P12 P-12
    [ "$BISS_RC" -eq 0 ] && biss m61 fall_P41 P-41
    [ "$BISS_RC" -eq 0 ] && biss m62 fall_P42 P-42
    [ "$BISS_RC" -eq 0 ] && biss m63 fall_P43 P-43
    [ "$BISS_RC" -eq 0 ] && biss m64 fall_P44 P-44
    [ "$BISS_RC" -eq 0 ] && biss m65 fall_P44 P-44
    [ "$BISS_RC" -eq 0 ] && biss m66 fall_P34 P-34
    [ "$BISS_RC" -eq 0 ] && biss m67 fall_P47 P-47
    [ "$BISS_RC" -eq 0 ] && biss m68 fall_P48 P-48
    [ "$BISS_RC" -eq 0 ] && biss m69 fall_P39 P-39
    if cmp -s "$SELBST" "$MUT/m80.sh"; then echo "  [ABBRUCH] Mutante m80 ist byte-gleich zum Harnisch"; BISS_RC=2; fi
    [ "$BISS_RC" -eq 0 ] && biss m71 fall_P50 P-50
    [ "$BISS_RC" -eq 0 ] && biss m72 fall_P51 P-51
    [ "$BISS_RC" -eq 0 ] && biss m73 fall_P52 P-52
    [ "$BISS_RC" -eq 0 ] && biss m74 fall_P53 P-53
    [ "$BISS_RC" -eq 0 ] && biss m75 fall_P54 P-54
    [ "$BISS_RC" -eq 0 ] && biss m76 fall_P55 P-55
    [ "$BISS_RC" -eq 0 ] && biss m77 fall_P55 P-55
    [ "$BISS_RC" -eq 0 ] && biss m78 fall_P56 P-56
    [ "$BISS_RC" -eq 0 ] && biss m79 fall_P59 P-59
    [ "$BISS_RC" -eq 0 ] && biss m80 fall_P57 P-57
    [ "$BISS_RC" -eq 0 ] && biss m81 fall_P60 P-60
    [ "$BISS_RC" -eq 0 ] && biss m82 fall_P60 P-60
    [ "$BISS_RC" -eq 0 ] && biss m83 fall_P61 P-61
    [ "$BISS_RC" -eq 0 ] && biss m84 fall_P62 P-62
    [ "$BISS_RC" -eq 0 ] && biss m85 fall_P63 P-63
    [ "$BISS_RC" -eq 0 ] && biss m86 fall_P64 P-64
    [ "$BISS_RC" -eq 0 ] && biss m87 fall_P65 P-65
    [ "$BISS_RC" -eq 0 ] && biss m88 fall_P66 P-66
    [ "$BISS_RC" -eq 0 ] && biss m89 fall_P67 P-67
    [ "$BISS_RC" -eq 0 ] && biss m95 fall_P73 P-73
    [ "$BISS_RC" -eq 0 ] && biss m96 fall_P74 P-74
    [ "$BISS_RC" -eq 0 ] && biss m97 fall_P74 P-74
    [ "$BISS_RC" -eq 0 ] && biss m101 fall_P78 P-78
    [ "$BISS_RC" -eq 0 ] && biss m102 fall_P74 P-74
    # YAML-Mutanten (r3): nur wenn die Marker-Bloecke in der YAML stehen; sonst LAUT entfallen (P-23/P-24 rot)
    zm=$(extrahiere_block "$CI_YML" EPOCH-288 "$MUT/marker.txt")
    if [ "$zm" -lt 5 ]; then
        ENTF_N=$MUT_N_YAML
        echo "  [ENTFAELLT] Mutanten m7/m8/m9/m13-m35/m41/m42/m44-m51/m70/m90-m94/m98-m100/m103-m120 (YAML):" \
             "EPOCH-288 fehlt ($zm Zeilen)"
    else
        # M7: Eltern-Walk stillgelegt (Epoch = %ct HEAD wie r2) -> P-23 muss reissen (L2-01)
        sed 's/QUELLE="\$QUELLE^"; stufe=\$((stufe+1))/break/' "$CI_YML" > "$MUT/m7.yml"
        # M8: Epoch-Weiche entfernt (Byte-Vergleich auch bei veralteter Kopie) -> P-24 (c) muss reissen
        sed 's/if \[ "\$e289" = "\$SOURCE_DATE_EPOCH" \]; then/if true; then/' "$CI_YML" > "$MUT/m8.yml"
        # M9: Byte-Urteil entfernt -> P-24 (b) muss reissen (L1-04)
        sed '/test -n "\$s288" && test "\$s288" = "\$s289"/,/andere Bytes (L1-04\/L2-01)"; exit 1; }/d' \
            "$CI_YML" > "$MUT/m9.yml"
        # M13 (r4, r8 case-Form C7-03): shallow-Zweig 'true)' still (gekappte Historie faellt auf %ct HEAD) -> P-23 (e)
        sed 's/^\( *\)true) echo "FEHLER: Submodul-Historie gekappt.*/\1true) : ;;/' "$CI_YML" > "$MUT/m13.yml"
        # M14 (r4): Fullbanner-Vergleich entfernt (Byte-Urteil trotz fremder Toolchain) -> P-24 (e) muss reissen
        sed 's/if \[ "\$b288" != "\$b289" \]; then/if false; then/' "$CI_YML" > "$MUT/m14.yml"
        # M15 (r5): Ein-Elter-Regel entfernt (Merge mit PDF-nur-Diff gilt als Writeback) -> P-23 (g) muss reissen
        sed 's/\&\& ! git rev-parse -q --verify "\$QUELLE^2" >\/dev\/null; then/; then/' "$CI_YML" > "$MUT/m15.yml"
        # M16 (r6, ersetzt 'letzter Treffer'): Trefferzahl immer 1 (Kardinalitaet nicht gemessen) -> P-24 (k1)/(k3)
        sed 's/kn=\$(printf/kn=1; kx=$(printf/' "$CI_YML" > "$MUT/m16.yml"
        # M17 (r5): Walk-Deckel-FEHLER entfernt (stiller Weiterlauf) -> P-23 (i) muss reissen (L4-04)
        sed 's/if \[ "\$stufe" -ge 8 \]; then/if false; then/' "$CI_YML" > "$MUT/m17.yml"
        # M18 (r5): sha256sum-FEHLER-Zweig entfernt (set -e ohne Marke) -> P-24 (i) muss reissen (L4-07)
        sed 's/ || { echo "FEHLER: sha256sum [^}]*}//' "$CI_YML" > "$MUT/m18.yml"
        # M19 (r5): CI_PROJECT_DIR-Gate entfernt -> P-23 (j) muss reissen (L4-08)
        sed '/CI_PROJECT_DIR leer (L4-08)/d' "$CI_YML" > "$MUT/m19.yml"
        # M20 (r5): '[skip ci]'-Bedingung entfernt (PDF-Commit von Hand gilt als Writeback) -> P-23 (h) muss reissen
        sed 's/\[ "\$bot" = ja \]/true/' "$CI_YML" > "$MUT/m20.yml"
        # M21 (r6): Elternlisten-FEHLER entfernt (unlesbare Elternliste = Wurzel) -> P-23 (k) muss reissen (C4-12)
        sed 's/|| { echo "FEHLER: git rev-list --parents [^}]*}/|| eltern=/' "$CI_YML" > "$MUT/m21.yml"
        # M22 (r6): Kardinalitaet am eigenen 288-Bau nicht gefordert -> P-24 (k3)/(k4)/(k5) muss reissen (C4-03/04)
        sed 's/; test "\$kn" -eq 1 \\$/; true \\/' "$CI_YML" > "$MUT/m22.yml"
        # M23 (r6): Zustand (3) bei unlesbarer/uneindeutiger 289-Kennung entfernt -> P-24 (k2) muss reissen (C4-03)
        sed 's/if \[ "\$n289c" -ne 1 \] || \[ "\$n289b" -ne 1 \]; then/if false; then/' "$CI_YML" > "$MUT/m23.yml"
        # M24 (r6): unlesbarer Blob gilt wieder als 'fehlt' (cat-file -e || continue) -> P-24 (m) muss reissen (C4-06)
        sed 's/|| { echo "FEHLER: git cat-file -e [^}]*}/|| continue/' "$CI_YML" > "$MUT/m24.yml"
        # M25 (r6): Nichtleere der pdftex-Nachweiszeile nicht geprueft -> P-24 (n1) muss reissen (C4-10)
        sed 's/test -n "\$pdftex_v" ||/true ||/' "$CI_YML" > "$MUT/m25.yml"
        # M26 (r6): Fullbanner-Muster zurueck auf r5 ('[^)]*', endet an der ersten ')') -> P-24 (l) muss reissen (C4-05)
        sed 's/^\( *\)fb_ere=.*/\1fb_ere='\''PTEX.Fullbanner [(][^)]*[)]'\''/' "$CI_YML" > "$MUT/m26.yml"
        # M27 (r6): rm -f der Zieldatei UND latexmk -g entfernt -> P-24 (o) muss reissen (C4-09)
        sed -e '/rm -f "diplomarbeit-\$L-\$U.pdf"/d' -e 's/latexmk -g -pdf/latexmk -pdf/' "$CI_YML" > "$MUT/m27.yml"
        # M28 (r6, r7 Sprachpaare): Ungleichheits-Pruefung der Sprachpaare entfernt -> P-24 (s6) muss reissen
        sed 's/test -n "\$a" [&][&] test -n "\$b" [&][&] test "\$a" != "\$b"/true/' "$CI_YML" > "$MUT/m28.yml"
        # M29 (r6): Host-Pinnung beider Thesis-Jobs zurueck auf [baremetal] -> P-17 (b) muss reissen (C4-11)
        sed 's/^  tags: \[prod, baremetal, amd\]/  tags: [baremetal]/' "$CI_YML" > "$MUT/m29.yml"
        # M30 (r6): Kommentar-Filter des F09-GATE entfernt (sed p statt s/%.*$//) -> P-24 (p) muss reissen (C4-08 a);
        # entfaellt LAUT, solange der Koppelpatch (Block F09-GATE-346) nicht gelandet ist
        sed 's/^\( *\)f09_strip() { sed .*/\1f09_strip() { cat; }/' "$CI_YML" > "$MUT/m30.yml"   # r10: Strip = cat
        # M31 (r7): /ID-Zeile NICHT ausgeblendet (roher Hash wie r6) -> P-24 (s3a) muss reissen (L6-01)
        sed 's#grep -a -v .\^/ID \\\[. #cat #' "$CI_YML" > "$MUT/m31.yml"
        # M32 (r7, r8 C7-02a): kanonische Literal-Zeile des EN-Zustands entfernt -> P-24 (s3b) muss reissen (Koppel)
        sed 's/^\( *\)echo "UMFANG en NICHT NACHGEWIESEN (EN-kurz ausstehend, Board #270)"$/\1:/' "$CI_YML" \
            > "$MUT/m32.yml"
        # M33 (r7): Seitenzahl-Regel de entfernt -> P-24 (s5) muss reissen (L6-01)
        sed 's/test "\$n_de_kurz" -lt "\$n_de_lang" \\$/true \\/' "$CI_YML" > "$MUT/m33.yml"
        # M34 (r7): 288-Epoch-Selbstnachweis entfernt -> P-24 (c1) muss reissen (C6-01)
        sed 's/test "\$e288" = "\$SOURCE_DATE_EPOCH" \\$/true \\/' "$CI_YML" > "$MUT/m34.yml"
        # M35 (r7): Definitions-Filter des F09-GATE entfernt (sed p) -> P-24 (p3) muss reissen (C6-02 a; nur
        # mit Koppelpatch)
        sed 's/^\( *\)f09_join() { tr .*/\1f09_join() { cat; }/' "$CI_YML" > "$MUT/m35.yml"   # r10: Join = cat
        # M41 (r7): needs statt Stufenbarriere am Export-Job -> P-17 (c) muss reissen (C6-09)
        sed 's/^  dependencies: \["thesis:pdf"\]/  needs: [{job: "thesis:pdf", artifacts: true}]/' \
            "$CI_YML" > "$MUT/m41.yml"
        # M42 (r7): main= ohne '|| main=' (leere Pipe reisst still unter -e -o pipefail) -> P-24 (q) muss reissen
        sed 's/| head -1) || main=; echo/| head -1); echo/' "$CI_YML" > "$MUT/m42.yml"
        # M44 (r8): /ID-Kardinalitaet nicht geprueft (0 oder 2 ID-Zeilen gehasht) -> P-24 (s7)/(s8) reissen (C7-01)
        sed 's/^\( *\)test "\$n_id" -eq 1 || {.*/\1true/' "$CI_YML" > "$MUT/m44.yml"
        # M45 (r8): kanonisches EN-Literal abgewandelt (Punkt angehaengt) -> P-24 (s3b) muss reissen (C7-02a; Koppel)
        l45='UMFANG en NICHT NACHGEWIESEN (EN-kurz ausstehend, Board #270)'
        sed "s/^\( *\)echo \"$l45\"\$/\1echo \"$l45.\"/" "$CI_YML" > "$MUT/m45.yml"
        # M46 (r8): '6 Paare ID-frei verschieden' auch im Zustand-Zweig -> P-24 (s3b) muss reissen (L7-02; Koppel)
        l46='UMFANG-346: 5 von 6 Paaren ID-frei verschieden, EN-Paar gleich (Zustand)'
        sed "s/^\( *\)echo \"$l46\"\$/\1echo \"UMFANG-346: 6 Paare ID-frei verschieden\"/" "$CI_YML" > "$MUT/m46.yml"
        # M47 (r8): shallow-case '*)' still (unerwarteter Wert wie false) -> P-23 (c2) muss reissen (C7-03)
        sed 's/^\( *\)\*) echo "FEHLER: unerwarteter Wert --is-shallow-repository.*/\1*) : ;;/' \
            "$CI_YML" > "$MUT/m47.yml"
        # M48 (r8): Konsum ohne Control-Word-Grenze (\thesislangAlt zaehlt) -> P-24 (p4) muss reissen (C7-05; Koppel)
        ersetze_literal "$CI_YML" '"^\\\\${makro}\$" "$f09w/tokg"' '"^\\\\${makro}" "$f09w/tokg"' > "$MUT/m48.yml"
        # M49 (r8): Definitionsfilter ohne '\*?' (\newcommand* zaehlt als Konsum) -> P-24 (p5) reissen (C7-05; Koppel)
        # r12: '\*?' steht hinter dem fuehrenden Leerraum der 3. f09_def-Zeile
        ersetze_literal "$CI_YML" '\*?[[:space:]]*\{?' '[[:space:]]*\{?' > "$MUT/m49.yml"   # r13: literal (ERE-Zeile)
        # M50 (r8): def/let-Filter ohne Leerraum (\def \thesislang zaehlt) -> P-24 (p6) muss reissen (C7-05; Koppel)
        sed '/^ *f09_def=/s/\[\[:space:\]\]\*//g' "$CI_YML" > "$MUT/m50.yml"   # r10: beide Leerraum-Klassen der ERE
        # M51 (r8): beide rev-parse-Substitutionen leer + Leer-Guard entfernt (test "" = "") -> P-23 (Gitlink) reisst
        sed -e 's/h_sub=$(git rev-parse HEAD)/h_sub=/' \
            -e 's/h_git=$(git -C "$CI_PROJECT_DIR" rev-parse HEAD:thesis\/diplomarbeit)/h_git=/' \
            -e '/test -n "$h_sub" && test -n "$h_git"/d' "$CI_YML" > "$MUT/m51.yml"
        # M70 (r9, C8-06): Mehrzeilen-Filter des F09-GATE-346 nimmt Treffer nicht mehr ernst -> P-49 muss reissen
        sed 's/\*\\{?\[\[/*[[/' "$CI_YML" > "$MUT/m70.yml"   # r10: '\{?' aus der Definitions-ERE entfernt
        # M90 (r11, C10-01): Kommentar-Strip zurueck auf die r10-Form ohne Backslash-Paritaet -> P-68 muss reissen
        sed 's|^\( *\)f09_strip() { sed -E .*|\1f09_strip() { sed -e '"'"'s/\\(^\\\|[^\\\\]\\)%.*$/\\1/'"'"'; }|' \
            "$CI_YML" > "$MUT/m90.yml"
        # M91 (r11, C10-02): Definitions-ERE zurueck auf die r10-Formenliste -> P-69 muss reissen
        ersetze_literal "$CI_YML" '|gdef|xdef' '' > "$MUT/m91.yml"   # r14: gdef/xdef aus der Primitiv-Liste
        # M92 (r11, C10-04): Definitionsziel ohne Control-Word-Grenze -> P-70 muss reissen
        ersetze_literal "$CI_YML" '"\\\\${makro}\$" "$f09w/tokd"' '"\\\\${makro}" "$f09w/tokd"' > "$MUT/m92.yml"   # r15
        # M93 (r11, C10-06): EXIT-Trap des F09-Blocks entfernt (Werkordner bleibt bei FEHLER) -> P-71 muss reissen
        sed '/^ *trap '"'"'rm -rf -- "\$f09w"'"'"' EXIT$/d' "$CI_YML" > "$MUT/m93.yml"
        # M94 (r11b, C10-06b): Subshell-rc-Fang hinter der Klammer entfernt (Job liefe ohne Messung weiter) -> P-72
        sed 's/^\( *\)) || { .*F09-GATE-346 abgebrochen.*$/\1)/' "$CI_YML" > "$MUT/m94.yml"   # r12: Fang mit rc=$?
        # M98 (r12, C11-01): ERE-Suffix ohne fuehrenden Leerraum vor dem Stern -> P-75 muss reissen
        ersetze_literal "$CI_YML" ')*[[:space:]]*\*?' ')*\*?' > "$MUT/m98.yml"   # r13: literal (ERE-Zeile)
        # M99 (r12, C11-02): alter Blockkommentar ('definiert UND ... referenziert') -> P-76 (Textwache) muss reissen
        l99='Vorkommen ausserhalb erkannter Definitionsziele > 0 (Definition per -usepretex, kein Definitionsgebot)'
        sed "s/$l99/Makro definiert UND ausserhalb der Definition referenziert/" "$CI_YML" > "$MUT/m99.yml"
        # M100 (r12, C11-04): HUP/INT/TERM-Traps der F09-Subshell entfernt -> P-77 muss reissen (die Subshell
        # stirbt sofort am Signal: Marker 'tot' + 'Terminated'; bash 5.2 raeumt per EXIT-Trap im Signal-Handler)
        l100="trap 'exit 129' HUP; trap 'exit 130' INT; trap 'exit 143' TERM"
        sed "/^ *$l100\$/d" "$CI_YML" > "$MUT/m100.yml"
        # M103 (r13, C12-01): expandafter-Erweiterung der Definitions-ERE entfernt -> P-79 muss reissen
        ersetze_literal "$CI_YML" '([[:space:]]*\\expandafter)*' '' > "$MUT/m103.yml"
        # M104 (r13, C12-01): futurelet aus der let-Familie entfernt -> P-79 (futurelet) muss reissen
        ersetze_literal "$CI_YML" '|futurelet' '' > "$MUT/m104.yml"   # r14: Primitiv-Liste
        # M105 (r14, C13-01): Stufe 1 der Definitionen zurueck auf die verbrauchende Wortgrenze -> P-80 (a) muss reissen
        ersetze_literal "$CI_YML" '${makro}[A-Za-z@:_]*" "$f09w/eins" > "$f09w/tokd"' \
            '${makro}([^A-Za-z@:_]|\$)" "$f09w/eins" > "$f09w/tokd"' \
            > "$MUT/m105.yml"
        # M106 (r14, C13-01): Stufe 1 der Vorkommen zurueck auf die verbrauchende Wortgrenze -> P-81 (g) muss reissen
        ersetze_literal "$CI_YML" '\\\\${makro}[A-Za-z@:_]*" "$f09w/eins" > "$f09w/tokg"' \
            '\\\\${makro}([^A-Za-z@:_]|\$)" "$f09w/eins" > "$f09w/tokg"' \
            > "$MUT/m106.yml"
        # M107 (r14, C13-01): beide Stufe-2-Filter ohne Endanker (Fremdname zaehlt) -> P-82 (e) muss reissen
        ersetze_literal "$CI_YML" '${makro}\$" "$f09w/tok' '${makro}" "$f09w/tok' > "$MUT/m107.yml"
        # M108 (r14, C13-01): Pipe statt zwei Stufen (rc 2 der Stufe 1 verschluckt) -> P-83 muss reissen
        ersetze_literal "$CI_YML" '[A-Za-z@:_]*" "$f09w/eins" > "$f09w/tokd"' \
            '[A-Za-z@:_]*" "$f09w/eins" | LC_ALL=C grep -E "\\\\${makro}\$" > "$f09w/def"' > "$MUT/m108.tmp"
        ersetze_literal "$MUT/m108.tmp" \
            'LC_ALL=C grep -E "\\\\${makro}\$" "$f09w/tokd" > "$f09w/def" && dr=0 || dr=$?' \
            'dr=0' \
            > "$MUT/m108.yml"
        # M109 (r14, C13-02): chardef-Familie weg -> P-84 muss reissen
        ersetze_literal "$CI_YML" '|chardef|mathchardef|countdef|dimendef|skipdef|muskipdef|toksdef' '' \
            > "$MUT/m109.yml"
        # M110 (r14, C13-02): plain-Allokatoren weg -> P-85 muss reissen
        l110='|newcount|newdimen|newskip|newmuskip|newbox|newtoks|newread|newwrite|newlength|newsavebox'
        ersetze_literal "$CI_YML" "$l110" '' > "$MUT/m110.yml"
        # M111 (r14, C13-02): DeclareTextCommand / DeclareMathOperator / CommandCopy weg -> P-86 muss reissen
        l111='|DeclareTextCommand(Default)?|DeclareMathOperator|(New|Renew|Declare)CommandCopy'
        ersetze_literal "$CI_YML" "$l111" '' > "$MUT/m111.yml"
        # M112 (r14, C13-02): DeclarePairedDelimiter weg -> P-86 (p) muss reissen
        ersetze_literal "$CI_YML" '|DeclarePairedDelimiter(X|XPP)?' '' > "$MUT/m112.yml"
        # M113 (r15, C14-01): Stufe-2-Filter der Definitionen ohne Backslash (r14-Form) -> P-88 (a) muss reissen
        ersetze_literal "$CI_YML" '"\\\\${makro}\$" "$f09w/tokd"' '"${makro}\$" "$f09w/tokd"' > "$MUT/m113.yml"
        # M114 (r15, C14-02): Token-Klasse ohne '@' (beide Stufe-1-Extraktionen) -> P-89 (a) muss reissen
        ersetze_literal "$CI_YML" '[A-Za-z@:_]*' '[A-Za-z:_]*' > "$MUT/m114.yml"   # r16: Klasse mit ':_'
        # M115 (r15, C14-03): Truncation der Werkdateien vor den vier Stufen entfernt -> P-90 muss reissen
        sed '/^ *: > "\$f09w\/[a-z]*" || { echo "FEHLER: Werkdatei /d' "$CI_YML" > "$MUT/m115.yml"
        # M116 (r15, C14-04): 'font' aus der Primitiv-Liste -> P-91 (a) muss reissen
        ersetze_literal "$CI_YML" '|futurelet|font' '|futurelet' > "$MUT/m116.yml"
        # M117 (r15, O-15b): Font-Stand-Vergleich entfernt -> P-24 (j) muss reissen
        ersetze_literal "$CI_YML" 'elif [ "$f288" != "$f289" ]; then' 'elif false; then' > "$MUT/m117.yml"
        # M118 (r15, O-15b): fn-0-Wache am eigenen 288-Bau entfernt -> P-24 (k) muss reissen
        ersetze_literal "$CI_YML" 'lies_fontstand "$pdf" 288-Bau; test "$fn" -gt 0 \' \
            'lies_fontstand "$pdf" 288-Bau; true \' > "$MUT/m118.yml"
        # M119 (r15, L14-01): LC_ALL=C an beiden Stufe-1-Extraktionen entfernt -> P-93 muss reissen
        ersetze_literal "$CI_YML" 'LC_ALL=C grep -o -E "${f09_def}' 'grep -o -E "${f09_def}' > "$MUT/m119.tmp"
        ersetze_literal "$MUT/m119.tmp" 'LC_ALL=C grep -o -E "\\\\${makro}' 'grep -o -E "\\\\${makro}' > "$MUT/m119.yml"
        # M120 (r15, L14-04): Kernel-/fontspec-Definierer aus der ERE -> P-94 (a) muss reissen
        ersetze_literal "$CI_YML" '|newfontfamily|DeclareMathSymbol|protected@edef|protected@xdef' '' > "$MUT/m120.yml"
        # M121 (r16, C15-01): Font-Stand-Hash mit Dateiname (r15-Form; sha256sum escapt '\' im TMPDIR-Pfad), 16-Hex-
        # Validierung entfernt, Byte-Urteil mit Dateiname -> P-95 (a)/(b) muss reissen
        ersetze_literal "$CI_YML" 'fs=$(sha256sum < "$k289.fs")' 'fs=$(sha256sum "$k289.fs")' > "$MUT/m121.tmp"
        ersetze_literal "$MUT/m121.tmp" 'test "${#fs}" -eq 16 \' 'true \' > "$MUT/m121.tmp2"
        ersetze_literal "$MUT/m121.tmp2" 's289=$(sha256sum < "$k289" | cut' 's289=$(sha256sum "$k289" | cut' \
            > "$MUT/m121.yml"
        # M122 (r16, C15-02): Font-Stand des 288-Baus wieder VOR dem Fullbanner-Vergleich (r15-Reihenfolge) -> P-24 (r)
        ersetze_literal "$CI_YML" 'b288=$kw' 'b288=$kw; lies_fontstand "$pdf" 288-Bau; test "$fn" -gt 0 || exit 1' \
            > "$MUT/m122.yml"
        # M123 (r16, C15-04): Token-Klasse ohne ':_' (r15-Form, beide Stufe-1-Extraktionen) -> P-96 (a) muss reissen
        ersetze_literal "$CI_YML" '[A-Za-z@:_]*' '[A-Za-z@]*' > "$MUT/m123.yml"
        MUT_N=$((MUT_N+MUT_N_YAML))
        M30=m30; M35=m35; M48=m48; M49=m49; M50=m50; M32=m32; M33=m33; M45=m45; M46=m46; M70=m70
        M90=m90; M91=m91; M92=m92; M93=m93; M94=m94; M98=m98; M99=m99; M100=m100; M103=m103; M104=m104
        M105=m105; M106=m106; M107=m107; M108=m108; M109=m109; M110=m110; M111=m111; M112=m112
        M113=m113; M114=m114; M115=m115; M116=m116; M117=m117; M118=m118; M119=m119; M120=m120
        M121=m121; M122=m122; M123=m123
        if grep -q '# >>> F09-GATE-346' "$CI_YML"; then :; else
            MUT_N=$((MUT_N-31)); ENTF_N=$((ENTF_N+31)); M30=; M35=; M48=; M49=; M50=; M70=; M90=; M91=; M92=; M93=
            M94=; M98=; M99=; M100=; M103=; M104=; M105=; M106=; M107=; M108=; M109=; M110=; M111=; M112=
            M113=; M114=; M115=; M116=; M119=; M120=; M123=
            echo "  [ENTFAELLT] Mutanten m30 + m35 + m48-m50 + m70 + m90-m94 + m98-m100 + m103-m116 + m119/m120/m123" \
                 "(F09-GATE-346):" \
                 "Koppelpatch nicht in der YAML ($CI_YML)"
        fi
        if [ -n "$M119" ] && [ "$LOCALE_EN" -lt 1 ]; then
            MUT_N=$((MUT_N-1)); ENTF_N=$((ENTF_N+1)); M119=
            echo "  [ENTFAELLT] Mutante m119 (L14-01): Locale en_US.utf8 fehlt (locale -a: $LOCALE_EN)"
        fi
        if grep -q '# >>> UMFANG-346' "$CI_YML"; then :; else
            MUT_N=$((MUT_N-4)); ENTF_N=$((ENTF_N+4)); M32=; M33=; M45=; M46=
            echo "  [ENTFAELLT] Mutanten m32 + m33 + m45 + m46 (UMFANG-346): Koppelpatch r8 nicht in der YAML ($CI_YML)"
        fi
        for m in m7 m8 m9 m13 m14 m15 m16 m17 m18 m19 m20 m21 m22 m23 m24 m25 m26 m27 m28 m29 $M30 \
                 m31 $M32 $M33 m34 $M35 m41 m42 m44 $M45 $M46 m47 $M48 $M49 $M50 m51 $M70 $M90 $M91 $M92 $M93 \
                 $M94 $M98 $M99 $M100 $M103 $M104 \
                 $M105 $M106 $M107 $M108 $M109 $M110 $M111 $M112 \
                 $M113 $M114 $M115 $M116 $M117 $M118 $M119 $M120; do
            if cmp -s "$CI_YML" "$MUT/$m.yml"; then
                echo "  [ABBRUCH] Mutante $m ist byte-gleich zur YAML -- das Muster greift nicht"; BISS_RC=2
            fi
        done
        biss_yml() { # $1 = Mutante (YAML), $2 = Fallfunktion, $3 = Kennung; r8 (L7-03) wie biss()
            basis=$(basis_von "$3"); if [ "$basis" -gt 0 ]; then nicht_bewertbar "$1" "$3" "$basis"; return 0; fi
            T_ALT="$T"; T="$T/biss_$1"; mkdir -p "$T"
            ( FEHL=0; CI_YML="$MUT/$1.yml"; "$2" "$SKRIPT" > "$T/protokoll.txt" 2>&1; exit "$FEHL" ); r=$?
            T="$T_ALT"
            if [ "$r" -gt "$basis" ]; then
                echo "  [OK]  Mutante $1 (YAML) macht $3 ROT ($r gerissene Erwartung(en)) -- die Probe beisst"
            else
                echo "  [ABBRUCH] Mutante $1 (YAML) laesst $3 GRUEN -- die Probe beweist nichts"; BISS_RC=2
            fi
        }
        [ "$BISS_RC" -eq 0 ] && biss_yml m7 fall_P23 P-23
        [ "$BISS_RC" -eq 0 ] && biss_yml m8 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && biss_yml m9 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && biss_yml m13 fall_P23 P-23
        [ "$BISS_RC" -eq 0 ] && biss_yml m14 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && biss_yml m15 fall_P23 P-23
        [ "$BISS_RC" -eq 0 ] && biss_yml m16 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && biss_yml m17 fall_P23 P-23
        [ "$BISS_RC" -eq 0 ] && biss_yml m18 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && biss_yml m19 fall_P23 P-23
        [ "$BISS_RC" -eq 0 ] && biss_yml m20 fall_P23 P-23
        [ "$BISS_RC" -eq 0 ] && biss_yml m21 fall_P23 P-23
        [ "$BISS_RC" -eq 0 ] && biss_yml m22 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && biss_yml m23 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && biss_yml m24 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && biss_yml m25 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && biss_yml m26 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && biss_yml m27 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && biss_yml m28 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && biss_yml m29 fall_P17 P-17
        [ "$BISS_RC" -eq 0 ] && [ -n "$M30" ] && biss_yml m30 fall_P58 P-58
        [ "$BISS_RC" -eq 0 ] && biss_yml m31 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && [ -n "$M32" ] && biss_yml m32 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && [ -n "$M33" ] && biss_yml m33 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && biss_yml m34 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && [ -n "$M35" ] && biss_yml m35 fall_P58 P-58
        [ "$BISS_RC" -eq 0 ] && biss_yml m41 fall_P17 P-17
        [ "$BISS_RC" -eq 0 ] && biss_yml m42 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && biss_yml m44 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && [ -n "$M45" ] && biss_yml m45 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && [ -n "$M46" ] && biss_yml m46 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && biss_yml m47 fall_P23 P-23
        [ "$BISS_RC" -eq 0 ] && [ -n "$M48" ] && biss_yml m48 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && [ -n "$M49" ] && biss_yml m49 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && [ -n "$M50" ] && biss_yml m50 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && biss_yml m51 fall_P23 P-23
        [ "$BISS_RC" -eq 0 ] && [ -n "$M70" ] && biss_yml m70 fall_P49 P-49
        [ "$BISS_RC" -eq 0 ] && [ -n "$M90" ] && biss_yml m90 fall_P68 P-68
        [ "$BISS_RC" -eq 0 ] && [ -n "$M91" ] && biss_yml m91 fall_P69 P-69
        [ "$BISS_RC" -eq 0 ] && [ -n "$M92" ] && biss_yml m92 fall_P70 P-70
        [ "$BISS_RC" -eq 0 ] && [ -n "$M93" ] && biss_yml m93 fall_P71 P-71
        [ "$BISS_RC" -eq 0 ] && [ -n "$M94" ] && biss_yml m94 fall_P72 P-72
        [ "$BISS_RC" -eq 0 ] && [ -n "$M98" ] && biss_yml m98 fall_P75 P-75
        [ "$BISS_RC" -eq 0 ] && [ -n "$M99" ] && biss_yml m99 fall_P76 P-76
        [ "$BISS_RC" -eq 0 ] && [ -n "$M100" ] && biss_yml m100 fall_P77 P-77
        [ "$BISS_RC" -eq 0 ] && [ -n "$M103" ] && biss_yml m103 fall_P79 P-79
        [ "$BISS_RC" -eq 0 ] && [ -n "$M104" ] && biss_yml m104 fall_P79 P-79
        [ "$BISS_RC" -eq 0 ] && [ -n "$M105" ] && biss_yml m105 fall_P80 P-80
        [ "$BISS_RC" -eq 0 ] && [ -n "$M106" ] && biss_yml m106 fall_P81 P-81
        [ "$BISS_RC" -eq 0 ] && [ -n "$M107" ] && biss_yml m107 fall_P82 P-82
        [ "$BISS_RC" -eq 0 ] && [ -n "$M108" ] && biss_yml m108 fall_P83 P-83
        [ "$BISS_RC" -eq 0 ] && [ -n "$M109" ] && biss_yml m109 fall_P84 P-84
        [ "$BISS_RC" -eq 0 ] && [ -n "$M110" ] && biss_yml m110 fall_P85 P-85
        [ "$BISS_RC" -eq 0 ] && [ -n "$M111" ] && biss_yml m111 fall_P86 P-86
        [ "$BISS_RC" -eq 0 ] && [ -n "$M112" ] && biss_yml m112 fall_P86 P-86
        [ "$BISS_RC" -eq 0 ] && [ -n "$M113" ] && biss_yml m113 fall_P88 P-88
        [ "$BISS_RC" -eq 0 ] && [ -n "$M114" ] && biss_yml m114 fall_P89 P-89
        [ "$BISS_RC" -eq 0 ] && [ -n "$M115" ] && biss_yml m115 fall_P90 P-90
        [ "$BISS_RC" -eq 0 ] && [ -n "$M116" ] && biss_yml m116 fall_P91 P-91
        [ "$BISS_RC" -eq 0 ] && [ -n "$M117" ] && biss_yml m117 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && [ -n "$M118" ] && biss_yml m118 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && [ -n "$M119" ] && biss_yml m119 fall_P93 P-93
        [ "$BISS_RC" -eq 0 ] && [ -n "$M120" ] && biss_yml m120 fall_P94 P-94
        [ "$BISS_RC" -eq 0 ] && [ -n "$M121" ] && biss_yml m121 fall_P95 P-95
        [ "$BISS_RC" -eq 0 ] && [ -n "$M122" ] && biss_yml m122 fall_P24 P-24
        [ "$BISS_RC" -eq 0 ] && [ -n "$M123" ] && biss_yml m123 fall_P96 P-96
    fi
fi

echo ""
echo "============================================================================="
echo "BILANZ: $GRUEN_N von $N_FAELLE Faellen gruen, $ROT_N rot${ROT_LISTE:+ (}$ROT_LISTE${ROT_LISTE:+ )}"
if [ "$SELBSTBISS" -eq 1 ]; then
    if [ "$BISS_RC" -eq 0 ]; then
        echo "        Selbstbiss: $MUT_N von $MUT_N Mutanten rot, $ENTF_N entfallen (YAML ohne Marker)," \
             "$NB_N nicht bewertbar (Basisfall rot)"
    else
        echo "        Selbstbiss: NICHT bewiesen"
    fi
fi
if [ "$BISS_RC" -ne 0 ]; then echo "PROBE thesis_pdf_export: KEIN URTEIL (rc=2)"; exit 2; fi
if [ "$ROT_N" -eq 0 ]; then echo "PROBE thesis_pdf_export: GRUEN"; exit 0; fi
echo "PROBE thesis_pdf_export: ROT"; exit 1
