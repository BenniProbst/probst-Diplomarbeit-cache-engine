#!/bin/sh
# ci/thesis_pdf_export.sh -- exportiert die vier Thesis-Fassungen (de/en x lang/kurz) aus dem super-eigenen
# Thesis-Bau (Job thesis:pdf, Submodul thesis/diplomarbeit) als Folge-Commit nach docs/diplomarbeit/
# (Owner-Orders 389 + 390, 22.09.2026; Order 288/340 A-04 (a): Uebersteuerung per Env-Vertrag).
# REV r1 (Order 371 / Board #279; Codex-Lens r1 + Opus-Erhebung r1 + Bewertung r1, 23.09.2026): F-01 credential-
# freie Push-URL + GIT_ASKPASS-Helfer, F-02 Testhaken in CI verweigert, F-03 Eingabe-Haertung (set -f, vier
# Fassungs-IDs, relative Unterbaeume, Symlink-/Kanonik-Pruefung), F-04 [skip ci] auf jedem gepushten Tip,
# F-05 auswertbare Push-Schleife (max 5, Race-Nachweis statt Fehlertext-Parsing), F-06 UEBERHOLT-Wache
# (Gitlink/CI-Rezept seit CI_COMMIT_SHA bewegt), F-07 Remote-Idempotenz, I-02 Index-Invariante + Commit per
# Pathspec, gepruefte Substitutionen und expliziter Diff-Status. Bissprobe: ci/tests/test_thesis_pdf_export.sh.
# REV r2 (Lens r1, 23.09.2026): L1-01 .git-Komponente im Ziel verboten + Index-Invariante nach jedem git add
# (Pfad im Index UND Blob == Arbeitskopie; git add uebergeht .git-Pfade und assume-unchanged-Eintraege still mit
# rc=0) + Nachzaehlung; L1-02 Kanonik und Arbeitsbaum-Grenze VOR mkdir -p (readlink -m); L1-06 Pfad-Normalisierung
# (fuehrendes './', Schraegstrich am Ende); L1-07 Vertragstext UEBERHOLT praezisiert.
# REV r3 (Lens r2, 23.09.2026): L2-05 Normalisierung faltet auch '//', '/./' und '/.' (git add normalisiert, rev-parse
# ':pfad' nicht = irrefuehrender Abbruch); L2-06 doppelte Fassung laut benannt; L2-08 CI_SERVER_URL nur https://
# (ueberschreibbare vordefinierte Variable: ein http-Ziel truege den Token im Klartext).
# REV r7 (Codex-Lens r6 + Lead-Triage K294, 23.09.2026): C6-13 Schalter nur true|false (Tippfehler = FEHLER statt
# INERT); C6-07 Modus --ci (Aufruf-Literal der YAML): Testhaken bedingungslos verweigert; C6-06 Push-Ziel nur die
# Instanz (CI_SERVER_HOST + URL-Host == Konstante, CI_PROJECT_ID == 288, kein userinfo/Query/Fragment); C6-08
# Quelle kanonisch unter dem Arbeitsbaum (Zwischen-Symlink); C6-05 F-06 auch bei bewegtem Export-Script; C6-04
# nach dem Merge muss jede exportierte Fassung noch das eigene Artefakt sein, sonst UEBERHOLT (kein Mischstand).
# REV r8b (Codex-Lens r7 B + Lead K297, 23.09.2026): S7-01 nach dem Merge zaehlt der volle Tree-Eintrag je Fassung
# (Modus 100644 + Typ blob + Blob); S7-02 vom Remote geloeschte Fassung = UEBERHOLT (rc 0), Werkzeugfehler bleiben
# rot; S7-03 exakte Pathspec-Liste der Zielfassungen fuer Index-Wache, Commit und Remote-Idempotenz (keine fremden
# getrackten Aenderungen unter DIR, gestagt oder ungestagt); S7-04 CI_PROJECT_PATH == kanonischer Projektpfad
# (Konstante, nie ausgegeben) + strikte Form der Push-URL; S7-05 Fehlermeldungen nennen Variablennamen + Grund,
# nie URL-Werte; S7-06 expliziter Leerwert der Schalter/Pfade = FEHLER (fail-closed), Default nur bei ungesetzter
# Variable; S7-08 pipelinefreier PDF-Header-Test, trap auch fuer INT TERM HUP.
# REV r9 (Codex-Lens r8 B + Fable-Lens r8 + Lead K299, 23.09.2026): S8-01 Pathspecs literal (GIT_LITERAL_PATHSPECS=1),
# Index-Wache auf dem GESAMTEN Index ohne Rename-Erkennung (--no-renames --name-status, genau die Fassungs-Liste je
# A/M), F-07 ohne Renames; S8-02 rm -f + cp + chmod 0644, Index-Modus-Wache, Tree-Pruefung des EIGENEN Export-
# Commits vor dem ersten Push (eigener Defekt = FEHLER, nie UEBERHOLT); S8-03 Loesch-Erkennung VOR dem Merge
# (Pipeline-Tree vorhanden + Remote fehlend = UEBERHOLT, Erst-Export zaehlt nicht); S8-04 push.err/fetch.err mit
# Credential-Maske; S8-05 keine Rohwerte in fehler() ausser Pfadwerten DIR/SRC/dst nach der Zeichen-Wache;
# S8-06 Traps VOR mktemp; L8-01 Leerraum/Steuerzeichen in DIR/SRC und Fassungsnamen nur [A-Za-z0-9-].
# REV r10 (Codex-Lens r9 A/B + Fable-Lens r9 + Lead K300/K301, 23.09.2026): S9-01 hash-object --no-filters und
# Index-Blob == Rohhash (Filter-/EOL-Konversion = FEHLER); S9-02 core.fileMode=true fuer add und commit --only;
# S9-03 DIR/SRC nur [A-Za-z0-9._/-], keine '..'-Komponente, kein fuehrendes '/' (git-Pfadquotierung und Glob-/
# Magic-Fehlziele unerreichbar, L9-02/L9-03); S9-04 Index-Abfrage ':0:<pfad>' (Stage explizit); S9-05 Loesch-
# Erkennung per ls-tree je Seite, Werkzeugfehler = FEHLER; S9-06/L9-04 Credential-Maske bis zum letzten '@' vor
# dem Pfad plus scp-Form; S9-07 CI-Werte (SHAs, Branch, Pipeline-ID) VOR jeder Ausgabe geprueft; S9-08 WERK-Pfad
# selbst gebildet und mkdir NACH den Traps (kein Signalfenster); S9-09 fehler() und variable Ausgaben per printf.
# REV r11 (Codex-Lens r10 B + Fable-Lens r10 + Lead K303/K304, 24.09.2026): S10-01 Branchname per git check-ref-
# format, Push/Fetch immer auf die volle Ref refs/heads/<Branch>; S10-02 NA nur bei UNGESETZTER Variable (gesetzt =
# streng geprueft, leer/'NA' = FEHLER); S10-03 mkdir VOR der WERK-Zuweisung (der Trap kennt nur eigene Ordner, nie
# Fremdloeschung); S10-04 TMPDIR-Wache (absolut, nur [A-Za-z0-9._/-]; git ruft GIT_ASKPASS per Shell auf) + chmod
# mit '--'; S10-05 Maske = Zusatzschutz, dritte Regel fuer Diagnoseformen ohne '//'; S10-06 fehler() ohne
# abgeleitete Werte (SRC_K/WERK/TOP/WURZEL/DIR_K/DIR_F nur als Variablenname); S10-07 core.fileMode=true auch am
# ungestagt-Diff; S10-08 hex40 = Vertrag Kleinhex (keine Normalisierung); L10-05 fuehrendes '-' in DIR/SRC = FEHLER.
# REV r12 (Codex-Lens r11 B + Fable-Lens r11 + Lead K305, 24.09.2026): S11-01 Signale WAEHREND der Werkordner-Anlage
# nur vorgemerkt (sig), mkdir-rc dreiwertig (0 = WERK, 1 = FEHLER, Signal-rc = leeren Kandidaten entfernen + exit rc
# = r12-Verhalten, seit r13 abgeloest (S12-01): kein rmdir/rm auf einen unbestaetigten Kandidaten), danach Signal-
# Traps zurueck auf exit und ein vorgemerktes Signal per exit abgearbeitet ('0 Reste' = r12-Messung); S11-02 fuehrendes
# '-' auch NACH der Normalisierung in der gemeinsamen Wache ('./-n' wurde zu '-n' und exportiert).
# REV r13 (Codex-Lens r12 A + B, Fable-Lens r12, Lead K306, 24.09.2026): S12-01 kein rmdir/rm auf einen unbestaetigten
# Kandidaten (nur rc 0 setzt WERK, rc 1 = FEHLER (S9-08), jeder andere rc = FEHLER mit rc-Nennung, Kandidat
# unangetastet); das mkdir-Kind ist gegen HUP/INT/TERM immun (Subshell trap '' + exec), die Elternshell merkt
# weiter vor.
# REV r14 (Codex-Lens r13 B S13-01, Lead K307, 24.09.2026): nur Kommentare berichtigt (rc-1-Zweig nennt keine Nummer;
# das Restfenster des mkdir-Kindes ist nicht nur SIGKILL), keine funktionale Aenderung (A-2 des Fix r13 bleibt).
# REV r15 (Codex-Lens r14 B S14-01..S14-05 + Fable-Lens r14, Lead K308/K310, 24.09.2026): nur Kommentare berichtigt
# (Werkordner-Lage + Trap-Reichweite, Commit-Bedingung Inhalt + Modus + Typ, CI-Verweigerung per Leerheit der Variable,
# r12-Historie als abgeloest gekennzeichnet, Duplikat-Meldung per Position); keine funktionale Aenderung.
# REV r16 (Codex-Lens r15 A C15-01..05, B2 S15-01..S15-05, B1 S15-07 + Fable-Lens r15 L15-01, Lead K312, 24.09.2026):
# nur Kommentare berichtigt (PDF-Praefixtest statt 'ein PDF', lokale und Remote-Gleichheit getrennt, Push-Refspec
# refs/heads/$BRANCH, Fetch + Abstammungspruefung nach jedem abgelehnten Push, Diff-Leerheit auch bei Moduswechsel,
# Zielverzeichnis statt 'erster Seiteneffekt'); keine funktionale Aenderung.
# VERTRAG: laeuft nur nach gruenem thesis:pdf (needs + artifacts) in der Repo-Wurzel mit HEAD == CI_COMMIT_SHA;
# jede Fassung MUSS vorhanden, nicht leer und mit PDF-Header-Praefix %PDF- sein (S7-08-Praefixtest der ersten
# 5 Byte, kein Vollparser; S15-07), sonst rot; Ziel COMDARE_THESIS_PDF_DIR (Default docs/diplomarbeit, relativer
# Unterbaum, kein Symlink), stabile Namen diplomarbeit-<lang>-<umfang>.pdf, ueberschreibend; lokal:
# gleicher Inhalt UND Modus 100644 UND Typ blob der Zielfassungen, gemessen als leerer gestagter Diff
# (diff_gleich --cached vor dem Commit) = kein Commit, kein Push; remote gleich nach Fetch (F-07, diff_gleich HEAD
# FETCH_HEAD) = kein weiterer Merge/Push -- ein bereits erstellter Commit und ein abgelehnter Push-Versuch liegen
# dann vor (S7-01/S8-02/S15-01); Commit und Merge-Commit tragen '[skip ci]',
# Push mit -o ci.skip auf HEAD:refs/heads/$BRANCH (S10-01; Order 340 A-01 (c): eigener Branch);
# COMDARE_WRITEBACK_USER/TOKEN gehen NUR ueber GIT_ASKPASS (nie in URL, argv, .git/config oder Log);
# bei Ablehnung fetch + Pruefung + merge (nie rebase), max 5 Versuche; hat sich der Thesis-Gitlink oder das
# CI-Rezept seit CI_COMMIT_SHA bewegt = UEBERHOLT (rc=0, kein Push alter PDFs; exportiert wird beim naechsten Push,
# der eine Pipeline erzeugt -- ein [skip ci]-Bot-Commit, der den Gitlink bewegt, erzeugt selbst keine);
# bei Konflikt sauberer Abbruch (naechste Pipeline holt nach).
# SCHALTER: COMDARE_THESIS_PDF_EXPORT=false = INERT (nur true|false, r7); COMDARE_THESIS_PDF_FASSUNGEN (Teilmenge);
# COMDARE_THESIS_PDF_SRC (Default thesis/diplomarbeit); COMDARE_THESIS_PDF_REMOTE = TESTHAKEN der Bissprobe:
# nur absoluter Pfad auf ein lokales Bare-Repo; im Modus --ci oder bei nicht leerer CI/GITLAB_CI-Variable laut
# verweigert (C6-07).
# Push-Option ci.no_pipeline (19.1-Doku) statt ci.skip = Owner-Frage Q-2 der Bewertung r1, hier nicht gesetzt.
set -eu
set -f
# S8-01 (r9): set -f stoppt nur das Shell-Globbing; git wertet Pathspecs (Glob-Zeichen, ':'-Magic) weiter aus.
# Alle Pathspecs dieses Scripts sind literal (Verzeichnis-Praefix bleibt).
export GIT_LITERAL_PATHSPECS=1
fehler() { printf '%s\n' "FEHLER: $*"; exit 1; }
ueberholt() { printf '%s\n' "UEBERHOLT: $*"; exit 0; }   # S9-09 (r10): variable Ausgaben nur per printf
TAB=$(printf '\t')
# C6-06 (r7): Instanz-Konstanten -- Host wie die origin-URL des Projekts, Projekt-ID 288 (kein Projektpfad-Literal).
INSTANZ_HOST=gitlab.comdare.local
INSTANZ_PROJEKT_ID=288
# S7-04 (r8b): kanonischer Projektpfad des Projekts 288 (aus der origin-URL des super); NIE ausgeben (Log/Bericht
# maskieren als <super-pfad>). CI_PROJECT_PATH muss ihm gleichen, sonst FEHLER ohne Wertausgabe.
INSTANZ_PROJEKT_PFAD=comdare/research/probst-diplomarbeit-cache-engine
# C6-07 (r7): Modus --ci = Produktionsaufruf aus der YAML (Literal im script:, nicht per Variable ueberschreibbar).
MODUS=""; pos=0
for arg in "$@"; do
  pos=$((pos+1))
  # S8-05 (r9): kein Rohwert in der Meldung (ein Token als Argument stuende sonst im Log), nur Position + Grund.
  case "$arg" in --ci) MODUS=ci ;; *) fehler "Argument $pos unbekannt (erlaubt: --ci; S8-05)" ;; esac
done
# C6-13 (r7): nur true|false; jeder andere Wert (Tippfehler) endet laut statt als gruener INERT-Job.
# S7-06 (r8b): expliziter Leerwert ist KEIN Default (fail-closed): nur ungesetzt = true.
SW="${COMDARE_THESIS_PDF_EXPORT-true}"
case "$SW" in
  true) ;;
  false) echo "INERT: COMDARE_THESIS_PDF_EXPORT=false, kein Export"; exit 0 ;;
  *) fehler "COMDARE_THESIS_PDF_EXPORT: Wert nicht in {true,false} (C6-13/S8-05)" ;;
esac
DIR="${COMDARE_THESIS_PDF_DIR-docs/diplomarbeit}"
SRC="${COMDARE_THESIS_PDF_SRC-thesis/diplomarbeit}"
FASSUNGEN="${COMDARE_THESIS_PDF_FASSUNGEN-de-lang en-lang de-kurz en-kurz}"
[ -n "$DIR" ] || fehler "COMDARE_THESIS_PDF_DIR ist gesetzt, aber leer (S7-06: kein stiller Default)"
[ -n "$SRC" ] || fehler "COMDARE_THESIS_PDF_SRC ist gesetzt, aber leer (S7-06: kein stiller Default)"
[ -n "$FASSUNGEN" ] || fehler "COMDARE_THESIS_PDF_FASSUNGEN ist gesetzt, aber leer (S7-06: kein stiller Default)"
# L8-01 (r9, Klasse S7-06): Leerraum oder Steuerzeichen in DIR/SRC = FEHLER (sonst Export an ein Fehlziel wie ' ').
# Erst danach duerfen Meldungen die Pfadwerte DIR/SRC nennen (S8-05).
case "$DIR$SRC" in
  *[[:space:]]*|*[[:cntrl:]]*) fehler "COMDARE_THESIS_PDF_DIR/SRC enthaelt Leerraum oder Steuerzeichen (S7-06/L8-01)" ;;
esac
# S9-03 (r10, Codex-Lens r9 B; deckt L9-02/L9-03/L9-08): DIR/SRC nur [A-Za-z0-9._/-] -- '"', '\', Nicht-ASCII
# erreichten sonst die git-Pfadquotierung (falsches Rot), Glob-/Magic-Zeichen ein literales Fehlziel; keine
# '..'-Komponente, kein fuehrendes '/'; Meldungen ohne Rohwert, VOR jeder git-Wache und jeder Pfadausgabe.
case "$DIR$SRC" in *[!A-Za-z0-9._/-]*) fehler "COMDARE_THESIS_PDF_DIR/SRC: unzulaessige Zeichen (S9-03)" ;; esac
# L10-05 (r11, Fable-Lens r10): fuehrendes '-' = FEHLER (zweite Schicht neben dem '--' aller Aufrufe; ein Wert '-n'
# wurde sonst als Verzeichnis '-n' exportiert).
case "$DIR" in -*) fehler "COMDARE_THESIS_PDF_DIR: fuehrendes '-' (L10-05)" ;; esac
case "$SRC" in -*) fehler "COMDARE_THESIS_PDF_SRC: fuehrendes '-' (L10-05)" ;; esac
for p in "$DIR" "$SRC"; do
  case "$p" in
    /*|..|../*|*/..|*/../*) fehler "COMDARE_THESIS_PDF_DIR/SRC: relativer Pfad ohne '..' verlangt (S9-03)" ;;
  esac
done
BRANCH="${CI_COMMIT_BRANCH:?thesis_pdf_export: nur in Branch-Pipelines (CI_COMMIT_BRANCH fehlt)}"
PIPE_SHA="${CI_COMMIT_SHA:?thesis_pdf_export: CI_COMMIT_SHA fehlt (Pipeline-Stand fuer die Stale-Pruefung)}"
# S9-07 (r10, Codex-Lens r9 B): CI-Werte VOR jeder Ausgabe pruefen -- ein Token in CI_COMMIT_SHA/SHORT_SHA/BRANCH
# stuende sonst im Verweigerungspfad ('HEAD != CI_COMMIT_SHA') oder in Commit-/Push-Meldungen im Log; Meldung ohne
# Rohwert. Die Defaults NA (SHORT_SHA/PIPELINE_ID) gelten NUR bei ungesetzter Variable (ADV-r9-10).
# S10-02 (r11, Codex-Lens r10 B): Setzstatus per ${VAR+x} -- ein GESETZTER Wert wird streng geprueft, leer oder 'NA'
# = FEHLER (Variablen-Setzer-Klasse F-02; ':-NA' machte Leerwerte still zu NA und liess ein gesetztes 'NA' passieren).
# S10-08 (r11): Vertrag = Kleinhex (git-Form); Grossschreibung = Fremdwert = FEHLER, keine Normalisierung (HEAD_SHA
# und PIPE_SHA werden textuell verglichen).
hex40() { case "$1" in ''|*[!0-9a-f]*) return 1 ;; esac; [ ${#1} -eq 40 ]; }
hex40 "$PIPE_SHA" || fehler "CI_COMMIT_SHA: keine 40-stellige Hex-SHA (S9-07)"
if [ "${CI_COMMIT_SHORT_SHA+x}" = x ]; then
  KURZ=$CI_COMMIT_SHORT_SHA
  case "$KURZ" in ''|*[!0-9a-f]*) fehler "CI_COMMIT_SHORT_SHA: unzulaessige Zeichen (S9-07)" ;; esac
  [ ${#KURZ} -ge 7 ] && [ ${#KURZ} -le 40 ] || fehler "CI_COMMIT_SHORT_SHA: Laenge nicht 7..40 (S9-07)"
else
  KURZ=NA
fi
case "$BRANCH" in ''|-*|*..*|*[!A-Za-z0-9._/-]*) fehler "CI_COMMIT_BRANCH: unzulaessige Zeichen (S9-07)" ;; esac
# S10-01 (r11, Codex-Lens r10 B; L10-07): vollstaendige Branchnamen-Pruefung (HEAD, x.lock, x/, '..', '@{' = FEHLER);
# Push und Fetch adressieren unten IMMER die volle Ref refs/heads/$BRANCH -- ein Branch 'refs/heads/x' (legal, liegt
# unter refs/heads/refs/heads/x) landete sonst auf Branch x.
git check-ref-format --branch "$BRANCH" >/dev/null 2>&1 \
  || fehler "CI_COMMIT_BRANCH: kein gueltiger Branchname (S10-01)"
if [ "${CI_PIPELINE_ID+x}" = x ]; then
  PIPE_ID=$CI_PIPELINE_ID
  case "$PIPE_ID" in ''|*[!0-9]*) fehler "CI_PIPELINE_ID: keine Zahl (S9-07)" ;; esac
else
  PIPE_ID=NA
fi
export GIT_TERMINAL_PROMPT=0
GITP="git -c credential.helper="
# Hilfsdateien (Askpass-Helfer, Index-Liste, Push-Meldung) liegen in EINEM 0700-Wegwerfordner unter TMPDIR bzw. /tmp
# (absolut + Zeichenwache S10-04; ein TMPDIR im Arbeitsbaum wird nicht verhindert); der EXIT-Trap entfernt den
# bestaetigten Werkordner, nicht bei SIGKILL (S14-02).
# S8-06 (r9): Traps VOR der Anlage (kein Signalfenster zwischen Anlage und Cleanup-Installation); der EXIT-Trap raeumt
# nur, wenn WERK bereits gesetzt ist. S7-08 (r8b): Signale muenden in exit, damit der EXIT-Trap laeuft.
# S10-04 (r11, Codex-Lens r10 B): TMPDIR-Wache VOR der Anlage -- git ruft GIT_ASKPASS per Shell auf; Leerraum oder
# Metazeichen im Helfer-Pfad zerlegen den Aufruf (legitimer Export erst bei der Authentifizierung rot, Metazeichen =
# Kommando-Injektion aus TMPDIR). Nur absolute Pfade aus [A-Za-z0-9._/-]; Meldung ohne Rohwert.
T="${TMPDIR:-/tmp}"
case "$T" in /*) ;; *) fehler "TMPDIR: kein absoluter Pfad (S10-04)" ;; esac
case "$T" in *[!A-Za-z0-9._/-]*) fehler "TMPDIR: unzulaessige Zeichen (S10-04)" ;; esac
WERK=''
trap 'if [ -n "${WERK:-}" ]; then rm -rf -- "$WERK"; fi' EXIT
# S11-01 (r12, Codex-Lens r11 B): Signale WAEHREND der Anlage nur VORMERKEN -- ein Signal zwischen mkdir und der
# WERK-Zuweisung liess sonst den eigenen leeren 0700-Ordner liegen (der EXIT-Trap kannte ihn noch nicht). Nach der
# Anlage werden die Traps auf exit zurueckgestellt und ein vorgemerktes Signal per exit abgearbeitet (EXIT raeumt WERK).
sig=''
trap 'sig=129' HUP; trap 'sig=130' INT; trap 'sig=143' TERM
# S9-08 (r10, Codex-Lens r9 B): mktemp liesse ein Signalfenster zwischen mkdir und Pfadausgabe (Ordner ohne WERK-
# Zuweisung). Der Pfad wird selbst gebildet (od-Fehler = FEHLER), mkdir ohne -p (Existenz = FEHLER).
# S10-03 (r11, Codex-Lens r10 B): mkdir VOR der WERK-Zuweisung -- WERK bezeichnet nur einen nachweislich EIGENEN
# Ordner (bei Kollision mit einem fremden Pfad plus Signal raeumte der EXIT-Trap sonst Fremdes). S11-01 (r12) /
# S12-01 (r13, Codex-Lens r12 B): der mkdir-rc wird dreiwertig ausgewertet -- 0 = eigener Ordner (WERK), 1 =
# Kollision/Fehler (FEHLER, nichts Fremdes angefasst), jeder andere rc (Signal-, Werkzeug-rc 2/126/127) = Anlage
# UNBESTAETIGT: FEHLER mit rc-Nennung, der Kandidat bleibt unangetastet (kein rmdir/rm ohne Eigentumsnachweis --
# ein fremdes leeres Verzeichnis unter dem Kandidatennamen wuerde sonst entfernt). Das mkdir-Kind ignoriert
# HUP/INT/TERM (Subshell mit trap '' + exec; das Ignorieren vererbt sich ueber exec, die Elternshell merkt weiter
# vor). HUP/INT/TERM werden im Kind ignoriert; ein Abbruch ohne Erfolgsstatus (SIGKILL, andere Signale, Werkzeugfehler
# nach der Anlage) kann einen leeren EIGENEN Rest hinterlassen -- der Kandidat wird nie angefasst (S13-01).
zufall=$(od -An -N8 -tx1 /dev/urandom) || fehler "od /dev/urandom (S9-08)"
zufall=$(printf '%s' "$zufall" | tr -d ' \n') || fehler "tr (S9-08)"
[ ${#zufall} -eq 16 ] || fehler "Zufallsname unvollstaendig (S9-08)"
kand="${TMPDIR:-/tmp}/thesis_pdf_export.$$.$zufall"
rc=0; ( trap '' HUP INT TERM; exec mkdir -m 0700 -- "$kand" ) || rc=$?
case $rc in
  0) WERK=$kand ;;
  1) fehler "Hilfsordner anlegen (S9-08)" ;;
  *) fehler "Hilfsordner anlegen: mkdir rc $rc, Anlage unbestaetigt, Kandidat unangetastet (S12-01)" ;;
esac
trap 'exit 129' HUP; trap 'exit 130' INT; trap 'exit 143' TERM
[ -z "$sig" ] || exit "$sig"

# Explizite Statusauswertung (0 = gleich / Vorfahr, 1 = verschieden / kein Vorfahr, sonst Abbruch): set -e
# unterscheidet 1 nicht von einem Werkzeugfehler.
diff_gleich() { set +e; git diff --quiet "$@"; _rc=$?; set -e
    case "$_rc" in 0|1) return "$_rc" ;; *) fehler "git diff --quiet $* (rc=$_rc)" ;; esac; }
ist_vorfahr() { set +e; git merge-base --is-ancestor "$1" "$2"; _rc=$?; set -e
    case "$_rc" in 0|1) return "$_rc" ;; *) fehler "git merge-base --is-ancestor $1 $2 (rc=$_rc)" ;; esac; }

# Ort und Stand: Repo-Wurzel, HEAD == Pipeline-Commit (Provenienz "PDF = CI_COMMIT_SHA").
WURZEL=$(pwd -P) || fehler "pwd -P"
TOP=$(git rev-parse --show-toplevel) || fehler "kein git-Arbeitsbaum"
[ "$TOP" = "$WURZEL" ] || fehler "muss in der Repo-Wurzel laufen (TOP != WURZEL, S10-06)"
HEAD_SHA=$(git rev-parse --verify HEAD) || fehler "HEAD nicht bestimmbar"
hex40 "$HEAD_SHA" || fehler "HEAD: keine 40-stellige Hex-SHA (S9-07)"
[ "$HEAD_SHA" = "$PIPE_SHA" ] || fehler "HEAD $HEAD_SHA != CI_COMMIT_SHA $PIPE_SHA (Export nur vom Pipeline-Stand)"

# Push-Ziel. F-02: der Testhaken ist in CI verweigert (ein Variablen-Setzer koennte den Job sonst still auf ein
# fremdes Ziel umlenken = gruener Job ohne Projekt-Update) und ausserhalb CI nur ein lokales Bare-Repo.
# F-01: das echte Ziel ist credential-frei; Nutzer/Token liefert ein 0700-Askpass-Helfer aus der Umgebung.
if [ -n "${COMDARE_THESIS_PDF_REMOTE:-}" ]; then
  [ "$MODUS" != ci ] \
    || fehler "COMDARE_THESIS_PDF_REMOTE ist ein Testhaken und wird im Modus --ci verweigert (C6-07)"
  [ -z "${CI:-}" ] && [ -z "${GITLAB_CI:-}" ] \
    || fehler "COMDARE_THESIS_PDF_REMOTE ist ein Testhaken und wird in CI verweigert (CI/GITLAB_CI gesetzt)"
  case "$COMDARE_THESIS_PDF_REMOTE" in
    /*) ;;
    *) fehler "COMDARE_THESIS_PDF_REMOTE: Testhaken nur als absoluter lokaler Pfad (Wert nicht ausgegeben)" ;;
  esac
  [ "$(git -C "$COMDARE_THESIS_PDF_REMOTE" rev-parse --is-bare-repository 2>/dev/null)" = "true" ] \
    || fehler "COMDARE_THESIS_PDF_REMOTE ist kein lokales Bare-Repo (Testhaken; Wert nicht ausgegeben)"
  echo "TESTHAKEN AKTIV: Push-Ziel ist ein lokales Bare-Repo, NICHT das Projekt-Remote"
  REMOTE="$COMDARE_THESIS_PDF_REMOTE"
else
  : "${COMDARE_WRITEBACK_USER:?thesis_pdf_export: COMDARE_WRITEBACK_USER fehlt (CI-Variable 288, protected)}"
  : "${COMDARE_WRITEBACK_TOKEN:?thesis_pdf_export: COMDARE_WRITEBACK_TOKEN fehlt (CI-Variable 288, protected)}"
  : "${CI_SERVER_URL:?thesis_pdf_export: CI_SERVER_URL fehlt (Protokoll+Host+Port des Servers)}"
  # L2-08 (r3): CI_SERVER_URL ist durch Pipeline-/Projekt-Variablen ueberschreibbar (docs.gitlab.com/ci/variables);
  # der Askpass-Helfer liefert den Token an JEDES Ziel, also nur ueber TLS.
  case "$CI_SERVER_URL" in
    # S7-05 (r8b): Verweigerungspfade nennen NIE den URL-Wert (ein userinfo-Token landete sonst im Job-Log).
    *[@?#]*) fehler "CI_SERVER_URL traegt userinfo, Query oder Fragment (C6-06/S7-05)" ;;
    https://*) ;;
    *) fehler "CI_SERVER_URL ist nicht https:// (Token liefe im Klartext, L2-08/S7-05)" ;;
  esac
  # C6-06 (r7): Tiefenschutz -- der Askpass-Helfer liefert den Token an das Ziel; das Ziel muss die Instanz sein.
  : "${CI_SERVER_HOST:?thesis_pdf_export: CI_SERVER_HOST fehlt}"
  : "${CI_PROJECT_ID:?thesis_pdf_export: CI_PROJECT_ID fehlt}"
  [ "$CI_PROJECT_ID" = "$INSTANZ_PROJEKT_ID" ] \
    || fehler "CI_PROJECT_ID ist nicht das Projekt $INSTANZ_PROJEKT_ID (C6-06)"
  [ "$CI_SERVER_HOST" = "$INSTANZ_HOST" ] \
    || fehler "CI_SERVER_HOST ist nicht die Instanz $INSTANZ_HOST (C6-06)"
  url_host="${CI_SERVER_URL#https://}"; url_host="${url_host%%/*}"; url_host="${url_host%%:*}"
  [ "$url_host" = "$INSTANZ_HOST" ] \
    || fehler "CI_SERVER_URL zeigt nicht auf die Instanz $INSTANZ_HOST (C6-06/S7-05)"
  : "${CI_PROJECT_PATH:?thesis_pdf_export: CI_PROJECT_PATH fehlt}"
  # S7-04 (r8b): die ID allein bindet das Ziel nicht -- der Pfad muss der kanonische Pfad des Projekts 288 sein.
  [ "$CI_PROJECT_PATH" = "$INSTANZ_PROJEKT_PFAD" ] || fehler "CI_PROJECT_PATH != kanonischer Projektpfad (S7-04)"
  REMOTE="${CI_SERVER_URL%/}/${CI_PROJECT_PATH}.git"
  # S7-04 (r8b): strikte Form der fertigen Push-URL https://<Instanz>[:Port]/<pfad>.git, Pfad nur [A-Za-z0-9._/-]
  # (kein @ ? #), pipelinefrei; bei Abweichung FEHLER ohne Wertausgabe.
  url_rest="${REMOTE#https://$INSTANZ_HOST}"
  case "$url_rest" in
    /*) url_pfad="${url_rest#/}" ;;
    :*) url_port="${url_rest%%/*}"; url_port="${url_port#:}"
        case "$url_port" in ''|*[!0-9]*) fehler "Push-URL: Port nicht numerisch (S7-04)" ;; esac
        case "$url_rest" in */*) url_pfad="${url_rest#*/}" ;; *) fehler "Push-URL ohne Pfad (S7-04)" ;; esac ;;
    *) fehler "Push-URL zeigt nicht auf https://$INSTANZ_HOST (S7-04)" ;;
  esac
  case "$url_pfad" in *.git) url_pfad="${url_pfad%.git}" ;; *) fehler "Push-URL endet nicht auf .git (S7-04)" ;; esac
  case "$url_pfad" in ''|*[!A-Za-z0-9._/-]*) fehler "Push-URL: Pfad mit unzulaessigen Zeichen (S7-04)" ;; esac
  [ "$url_pfad" = "$INSTANZ_PROJEKT_PFAD" ] || fehler "Push-URL: Pfad != kanonischer Projektpfad (S7-04)"
  cat > "$WERK/askpass.sh" <<'ASK'
#!/bin/sh
case "$1" in
  Username*) printf '%s\n' "$COMDARE_WRITEBACK_USER" ;;
  Password*) printf '%s\n' "$COMDARE_WRITEBACK_TOKEN" ;;
  *) exit 1 ;;
esac
ASK
  chmod 0700 -- "$WERK/askpass.sh"   # S10-04 (r11): Trenner
  export COMDARE_WRITEBACK_USER COMDARE_WRITEBACK_TOKEN
  export GIT_ASKPASS="$WERK/askpass.sh"
fi

# F-03: Eingabe-Haertung. Ziel und Quelle sind relative Unterbaeume ohne '..' und ohne .git-Komponente, das Ziel
# kein Symlink, beide nach Aufloesung verschieden und das Ziel innerhalb des Arbeitsbaums; jede Zieldatei ist
# kein Symlink.
# L1-06 (r2): fuehrendes './' und Schraegstriche am Ende abstreifen, damit der Praefix-Vergleich mit der
# git-normalisierten Index-Ausgabe (I-02) nicht an der Schreibweise reisst ('docs/diplomarbeit/' = 'docs/diplomarbeit').
# L2-05 (r3): auch '//', '/./' und ein '/.' am Ende falten -- git add normalisiert sie, rev-parse ':pfad' nicht.
norm_pfad() { _p="$1"
  while :; do
    case "$_p" in
      ./*) _p="${_p#./}" ;;
      */) _p="${_p%/}" ;;
      */.) _p="${_p%/.}" ;;
      *//*) _p="${_p%%//*}/${_p#*//}" ;;
      */./*) _p="${_p%%/./*}/${_p#*/./}" ;;
      *) break ;;
    esac
  done
  printf '%s\n' "$_p"; }
DIR=$(norm_pfad "$DIR") || fehler "Normalisierung DIR"
SRC=$(norm_pfad "$SRC") || fehler "Normalisierung SRC"
for p in "$DIR" "$SRC"; do
  case "$p" in
    # S11-02 (r12, Codex-Lens r11 B): fuehrendes '-' auch NACH der Normalisierung ('./-n' wurde zu '-n', L10-05).
    -*) fehler "'$p' beginnt nach der Normalisierung mit '-' (fuehrendes '-', L10-05/S11-02)" ;;
    ''|.|/*|..|../*|*/../*|*/..) fehler "'$p' muss ein relativer Pfad ohne '..' sein" ;;
    # L1-01 (r2): git add uebergeht Pfade mit einer .git-Komponente STILL (rc=0, nichts gestagt) -- ein solches
    # Ziel endete als gruener Job ohne Export.
    .git|.git/*|*/.git|*/.git/*) fehler "'$p' traegt eine .git-Komponente (git add uebergeht solche Pfade still)" ;;
  esac
done
[ ! -L "$DIR" ] || fehler "$DIR ist ein Symlink (Zielordner verboten)"
[ -d "$SRC" ] || fehler "Quelle $SRC fehlt (Artefakt des thesis:pdf-Jobs)"
# L1-02 (r2): Kanonik und Arbeitsbaum-Grenze VOR dem Anlegen des Zielverzeichnisses (Werkordner und Askpass-Datei
# entstehen frueher; S15-05). readlink -m loest auch noch fehlende Glieder auf; ein getrackter Zwischen-Symlink
# (docs/ext -> ../../aussen) darf nicht einmal ein leeres Verzeichnis ausserhalb des Baums anlegen. readlink -f nach
# mkdir bleibt als zweite Schicht.
DIR_K=$(readlink -m -- "$DIR") || fehler "readlink -m $DIR"
SRC_K=$(readlink -f -- "$SRC") || fehler "readlink -f $SRC"
# C6-08 (r7): Symmetrie zu DIR_K -- die Quelle darf nicht ueber einen Zwischen-Symlink aus dem Baum zeigen.
case "$SRC_K/" in
  "$WURZEL/"*) ;;
  # S10-06 (r11): aufgeloeste Pfade (SRC_K/DIR_K/DIR_F), TOP/WURZEL und WERK nie in Meldungen (S8-05-Vertrag).
  *) fehler "$SRC (Quelle) liegt ausserhalb des Arbeitsbaums (SRC_K, C6-08)" ;;
esac
[ "$DIR_K" != "$SRC_K" ] || fehler "Ziel und Quelle identisch ($DIR)"
case "$DIR_K/" in
  "$WURZEL/"*) ;;
  *) fehler "$DIR liegt ausserhalb des Arbeitsbaums (DIR_K, L1-02)" ;;
esac
mkdir -p -- "$DIR" || fehler "mkdir -p $DIR"
DIR_F=$(readlink -f -- "$DIR") || fehler "readlink -f $DIR"
[ "$DIR_F" = "$DIR_K" ] || fehler "$DIR: Kanonik nach mkdir (DIR_F) weicht von der Vorpruefung (DIR_K) ab"

n=0; gesehen=' '; pos=0
for f in $FASSUNGEN; do
  pos=$((pos+1))
  # L8-01/S8-05 (r9): Fassungsname nur [A-Za-z0-9-]; Meldungen nennen Position + Grund, nie den Rohwert.
  case "$f" in
    *[!A-Za-z0-9-]*) fehler "COMDARE_THESIS_PDF_FASSUNGEN: Eintrag $pos: unzulaessiges Zeichen (L8-01)" ;;
  esac
  case "$f" in
    de-lang|en-lang|de-kurz|en-kurz) ;;
    *) fehler "COMDARE_THESIS_PDF_FASSUNGEN: Eintrag $pos unbekannt (erlaubt: de-lang en-lang de-kurz en-kurz)" ;;
  esac
  # L2-06 (r3): ein Duplikat endete als 'nur 1 von 2 Zieldateien im Index' -- Position des doppelten Eintrags nennen
  # (S14-05; die Meldung nennt 'Eintrag $pos', nie den Fassungswert, S8-05).
  case "$gesehen" in *" $f "*) fehler "Eintrag $pos doppelt in COMDARE_THESIS_PDF_FASSUNGEN (S8-05)" ;; esac
  gesehen="$gesehen$f "
  src="$SRC/diplomarbeit-$f.pdf"; dst="$DIR/diplomarbeit-$f.pdf"
  [ ! -L "$src" ] || fehler "$src ist ein Symlink (Quelldatei verboten)"
  [ -s "$src" ] || fehler "Fassung $src fehlt oder ist leer (Artefakt des thesis:pdf-Jobs)"
  hdr=$(head -c 5 -- "$src") || fehler "head -c 5 $src (S7-08)"   # pipelinefrei (S7-08, r8b)
  [ "$hdr" = "%PDF-" ] || fehler "$src ist kein PDF (Header)"
  [ ! -L "$dst" ] || fehler "$dst ist ein Symlink (Zieldatei verboten)"
  groesse=$(wc -c < "$src") || fehler "wc -c $src"
  # S8-02 (r9): Altdatei weg (kein Modus-Erbe, kein Schreiben durch einen Link), Kopie mit festem Modus 0644.
  rm -f -- "$dst" || fehler "rm -f $dst"
  cp -- "$src" "$dst" || fehler "cp $src $dst"
  chmod 0644 -- "$dst" || fehler "chmod 0644 $dst"
  # S9-02 (r10, Codex-Lens r9 B): core.fileMode=true erzwingen -- unter fileMode=false behielte git add den alten
  # Indexmodus (100755 vom Remote) und die Modus-Wache endete auf Dauer rot (L9-06).
  git -c core.fileMode=true add -- "$dst" || fehler "git add $dst"
  # L1-01 (r2): git add endet fuer .git-Pfade und assume-unchanged-Eintraege still mit rc=0, ohne zu stagen. Der
  # Index muss danach den Pfad UND genau den Inhalt der Arbeitskopie tragen (git diff --quiet traut assume-unchanged).
  git ls-files --error-unmatch -- "$dst" >/dev/null 2>&1 \
    || fehler "$dst steht nach git add nicht im Index (git add hat den Pfad still uebergangen)"
  blob=$(git hash-object -- "$dst") || fehler "git hash-object $dst"
  # S9-04 (r10): Stage explizit (':0:'); ':<pfad>' waere bei einem Pfad mit ':' Stage-Syntax. Nach S9-03 ist ':'
  # ausgeschlossen, die eindeutige Form bleibt Pflicht.
  idx=$(git rev-parse --verify -q ":0:$dst") || fehler "git rev-parse :0:$dst (kein Stage-0-Eintrag)"
  [ "$idx" = "$blob" ] || fehler "Index traegt fuer $dst nicht den Inhalt der Arbeitskopie ($idx != $blob)"
  # S9-01 (r10, Codex-Lens r9 B): der Index-Blob muss der ROHHASH der Datei sein (--no-filters); greift ein Clean-/
  # EOL-Filter (z. B. '*.pdf text'), weichen die gespeicherten Bytes vom Artefakt ab = FEHLER (Objekt: *.pdf binary).
  roh=$(git hash-object --no-filters -- "$dst") || fehler "git hash-object --no-filters $dst"
  [ "$idx" = "$roh" ] || fehler "Filter-/EOL-Konversion am Artefakt $dst (S9-01)"
  modus=$(git ls-files -s -- "$dst") || fehler "git ls-files -s $dst"; modus="${modus%% *}"
  [ "$modus" = "100644" ] || fehler "$dst steht mit Modus $modus statt 100644 im Index (S8-02)"
  printf '%s\n' "$dst" >> "$WERK/dst.txt" || fehler "Zielliste WERK/dst.txt"
  n=$((n+1))
  printf '%s\n' "Fassung $f: $groesse B nach $dst"
done
[ "$n" -gt 0 ] || fehler "keine Fassung in COMDARE_THESIS_PDF_FASSUNGEN"
# L1-01 (r2): Nachzaehlung nach der Schleife -- alle n Zieldateien stehen im Index unter $DIR/ (nicht ueber
# diff --cached: bei gleichem Inhalt, Modus 100644 und Typ blob ist der gestagte Diff leer, und UNVERAENDERT unten ist
# der richtige Ausgang; ein Moduswechsel (HEAD 100755 -> chmod 0644 + add) ergibt einen Diff und einen Commit; S15-02).
git ls-files -- "$DIR" > "$WERK/ls.txt" || fehler "git ls-files $DIR"
gestagt=$(grep -cxF -f "$WERK/dst.txt" "$WERK/ls.txt" || true)
[ "$gestagt" -eq "$n" ] || fehler "nur $gestagt von $n Zieldateien stehen im Index unter $DIR/"

# I-02 / S7-03 (r8b) / S8-01 (r9): der GESAMTE Index darf GENAU die Fassungs-Liste tragen, je Status A oder M,
# ohne Rename-Erkennung (eine als Rename erkannte Fremd-Loeschung verschwaende sonst aus --name-only); der Commit,
# der lokale Byte-Vergleich und die Remote-Idempotenz arbeiten auf derselben exakten, literalen Pathspec-Liste.
git diff --cached --no-renames --name-status > "$WERK/index.txt" || fehler "git diff --cached --name-status"
fremd=0
while IFS= read -r zeile; do
  st="${zeile%%$TAB*}"; pf="${zeile#*$TAB}"
  case "$st" in A|M) ;; *) fremd=$((fremd+1)); continue ;; esac
  grep -q -x -F -- "$pf" "$WERK/dst.txt" || fremd=$((fremd+1))
done < "$WERK/index.txt"
[ "$fremd" -eq 0 ] || fehler "$fremd fremde Pfad(e) im Index (erlaubt ist nur die Fassungs-Liste, S7-03/S8-01)"
# S10-07 (r11, Codex-Lens r10 B): core.fileMode=true auch hier -- unter fileMode=false bliebe ein reiner Modus-Wechsel
# einer fremden getrackten Datei unter DIR unsichtbar (S7-03-Ausschluss unvollstaendig).
ungestagt=$(git -c core.fileMode=true diff --name-only -- "$DIR") || fehler "git diff --name-only $DIR"
[ -z "$ungestagt" ] || fehler "getrackte Aenderung(en) unter $DIR ausserhalb der Fassungs-Liste (ungestagt, S7-03)"
set --
while IFS= read -r p; do set -- "$@" "$p"; done < "$WERK/dst.txt"
[ "$#" -eq "$n" ] || fehler "Fassungs-Liste $# != $n"

if diff_gleich --no-renames --cached -- "$@"; then
  printf '%s\n' "UNVERAENDERT: $n Fassungen byte-gleich zum Bestand in $DIR, kein Commit"; exit 0
fi
$GITP -c core.fileMode=true -c user.name="super-pdf-bot" \
  -c user.email="super-pdf-bot@ci.comdare.local" commit -q --only \
  -m "docs(diplomarbeit): $n Thesis-Fassungen aus Pipeline $PIPE_ID" \
  -m "Quelle super $KURZ ($PIPE_SHA), Submodul thesis/diplomarbeit (Order 389/390, 22.09.2026) [skip ci]" \
  -- "$@" || fehler "git commit"
NEU=$(git rev-parse --short HEAD) || fehler "git rev-parse HEAD"
NEU_VOLL=$(git rev-parse --verify HEAD) || fehler "git rev-parse --verify HEAD"
printf '%s\n' "Commit $NEU auf $BRANCH (Basis Pipeline-Commit $KURZ)"
# S8-02 (r9): der EIGENE Export-Commit wird VOR dem ersten Push geprueft (100644 blob, Inhalt = Quelle je Fassung);
# eine Abweichung ist ein eigener Defekt = FEHLER, nie UEBERHOLT.
for f in $FASSUNGEN; do
  src="$SRC/diplomarbeit-$f.pdf"; dst="$DIR/diplomarbeit-$f.pdf"
  e=$(git ls-tree "$NEU_VOLL" -- "$dst") || fehler "git ls-tree $NEU -- $dst"
  q=$(git hash-object --no-filters -- "$src") || fehler "git hash-object --no-filters $src"   # S9-01 (r10)
  [ "${e%%$TAB*}" = "100644 blob $q" ] || fehler "Export-Commit $NEU: $dst nicht 100644 blob der Quelle (S8-02)"
done

# F-05 Push-Schleife: jeder Fehler ist sichtbar; jeder abgelehnte Push fuehrt zu Fetch + Abstammungspruefung
# (FETCH_HEAD Vorfahr von HEAD = kein Race = FEHLER); Merge und erneuter Push nur bei passender Abstammung und
# bestandenen Folgewachen (F-06, F-07, S8-03/S9-05, S7-01/S7-02/C6-04; S15-04); F-04 Merge-Botschaft mit Marker.
versuch=0
while [ "$versuch" -lt 5 ]; do
  versuch=$((versuch+1))
  if $GITP push -q -o ci.skip "$REMOTE" "HEAD:refs/heads/$BRANCH" 2>"$WERK/push.err"; then   # S10-01: volle Ref
    printf '%s\n' "PUSH OK (ci.skip) auf $BRANCH (Versuch $versuch)"; exit 0
  fi
  # S8-04 (r9, Haertung): git-Diagnostik nur mit Credential-Maske ausgeben (userinfo in URLs -> <cred>).
  printf '%s\n' "Push abgelehnt (Versuch $versuch), git meldet:"
  # S9-06/L9-04 (r10): Maske bis zum letzten '@' vor dem Pfad (deckt '@' im Kennwort) plus scp-Form user@host:pfad.
  # S10-05 (r11, Codex-Lens r10 B; L10-06): Maske = Zusatzschutz (REMOTE ohne userinfo, F-01/S7-04), kein Vertrag
  # ueber fremde Diagnoseformen; dritte Regel fuer Formen ohne '//' (scheme:user:kennwort@host/pfad).
  sed -e 's#//[^/]*@#//<cred>@#g' -e 's#[^ /:@]*@[^ /:@]*:#<cred>@<host>:#g' \
    -e 's#[A-Za-z][A-Za-z0-9+.-]*:[^/ @]*@#<scheme>:<cred>@#g' -e 's/^/  | /' "$WERK/push.err"
  $GITP fetch -q "$REMOTE" "refs/heads/$BRANCH" 2>"$WERK/fetch.err" || { echo "fetch meldet:"   # S10-01
    sed -e 's#//[^/]*@#//<cred>@#g' -e 's#[^ /:@]*@[^ /:@]*:#<cred>@<host>:#g' \
      -e 's#[A-Za-z][A-Za-z0-9+.-]*:[^/ @]*@#<scheme>:<cred>@#g' -e 's/^/  | /' "$WERK/fetch.err"
    fehler "fetch $BRANCH fehlgeschlagen (Recht/Netz), kein Race"; }
  FERN=$(git rev-parse --short FETCH_HEAD) || fehler "git rev-parse FETCH_HEAD"
  if ist_vorfahr FETCH_HEAD HEAD; then
    fehler "Remote-Tip $FERN unbewegt, der Push-Fehler ist kein non-ff-Race (Recht/Hook/Push-Option?)"
  fi
  ist_vorfahr "$PIPE_SHA" FETCH_HEAD \
    || fehler "$BRANCH ($FERN) enthaelt den Pipeline-Commit $KURZ nicht (Rewrite/Force-Push?)"
  if ! diff_gleich "$PIPE_SHA" FETCH_HEAD -- thesis/diplomarbeit .gitlab-ci.yml ci/thesis_pdf_export.sh; then
    printf '%s\n' "UEBERHOLT: Thesis-Gitlink oder CI-Rezept seit $KURZ bewegt ($FERN); kein Push alter PDFs"
    exit 0
  fi
  if diff_gleich --no-renames HEAD FETCH_HEAD -- "$@"; then  # F-07 Remote-Idempotenz, Fassungs-Liste (S7-03/S8-01)
    printf '%s\n' "UNVERAENDERT (remote): $BRANCH ($FERN) traegt die $n Fassungen bereits byte-gleich, kein Merge/Push"
    exit 0
  fi
  # S8-03 (r9): eine Fassung, die im Pipeline-Tree lag und am Remote fehlt, wurde dort geloescht -> UEBERHOLT (rc 0)
  # VOR dem Merge (sonst endete ein modify/delete-Konflikt rot); eine erstmals exportierte Fassung (im Pipeline-
  # Tree nicht vorhanden) ist keine Loeschung, Merge + Push laufen normal; ein Konflikt danach bleibt FEHLER.
  # S9-05 (r10, Codex-Lens r9 B): je Seite ls-tree mit eigenem Fehlerzweig -- ein Werkzeugfehler (cat-file rc != 0)
  # galt in r9 als 'am Remote geloescht' (UEBERHOLT rc 0); leer = Pfad fehlt, jeder Werkzeugfehler = FEHLER.
  while IFS= read -r dst; do   # S8-03/S9-05: Loesch-Erkennung VOR dem Merge
    e=$(git ls-tree "$PIPE_SHA" -- "$dst") || fehler "git ls-tree PIPE_SHA -- $dst (S9-05)"
    r=$(git ls-tree FETCH_HEAD -- "$dst") || fehler "git ls-tree FETCH_HEAD -- $dst (S9-05)"
    if [ -n "$e" ] && [ -z "$r" ]; then
      printf '%s\n' "UEBERHOLT: Fassung $dst am Remote geloescht ($FERN), kein Merge/Push (S7-02/S8-03)"; exit 0
    fi
  done < "$WERK/dst.txt"   # S8-03
  $GITP -c user.name="super-pdf-bot" -c user.email="super-pdf-bot@ci.comdare.local" merge -q --no-edit \
    -m "Merge $BRANCH in thesis-pdf-export $PIPE_ID [skip ci]" FETCH_HEAD \
    || { git merge --abort 2>/dev/null || true; fehler "Merge mit $FERN kollidiert, naechste Pipeline holt nach"; }
  # C6-04 (r7): nach dem Merge muss jede exportierte Fassung noch das eigene Artefakt tragen; sonst hat ein fremder
  # Commit eine Fassung bewegt und der Push waere ein Mischstand -> UEBERHOLT (rc=0), naechste Pipeline exportiert.
  # S7-01/S7-02 (r8b): voller Tree-Eintrag (Modus Typ Blob) statt Blob-ID; fehlender Pfad = UEBERHOLT (rc 0), nur
  # Werkzeugfehler (ls-tree rc != 0) bleiben rot; fremder Symlink/Modus mit gleichem Blob = UEBERHOLT.
  while IFS= read -r dst; do
    a=$(git ls-tree HEAD -- "$dst") || fehler "git ls-tree HEAD -- $dst (nach Merge)"
    b=$(git ls-tree "$NEU_VOLL" -- "$dst") || fehler "git ls-tree $NEU -- $dst (eigener Export-Commit)"
    [ -n "$b" ] || fehler "Fassung $dst fehlt im eigenen Export-Commit $NEU"
    [ -n "$a" ] || ueberholt "Fassung $dst am Remote geloescht ($FERN), kein Push (S7-02)"
    ma="${a%% *}"; ta="${a#* }"; ta="${ta%% *}"
    [ "$ma" = "100644" ] && [ "$ta" = "blob" ] \
      || ueberholt "Fassung $dst am Remote als $ta/$ma statt blob/100644 ($FERN), kein Push (S7-01)"
    [ "$a" = "$b" ] || ueberholt "Fassung $dst am Remote fremd bewegt ($FERN), kein Push (C6-04)"
  done < "$WERK/dst.txt"
  printf '%s\n' "Merge mit $BRANCH-Tip $FERN [skip ci], erneuter Push"
  if [ "$versuch" -lt 5 ]; then sleep $((versuch * 2)); fi
done
fehler "Push nach 5 Versuchen abgelehnt ($BRANCH bewegt sich zu schnell?)"
