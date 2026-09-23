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
# VERTRAG: laeuft nur nach gruenem thesis:pdf (needs + artifacts) in der Repo-Wurzel mit HEAD == CI_COMMIT_SHA;
# jede Fassung MUSS vorhanden, nicht leer und ein PDF sein (sonst rot); Ziel COMDARE_THESIS_PDF_DIR (Default
# docs/diplomarbeit, relativer Unterbaum, kein Symlink), stabile Namen diplomarbeit-<lang>-<umfang>.pdf,
# ueberschreibend; byte-gleich zum lokalen Bestand ODER zum Remote-Tip = kein Commit / kein Push; Commit und
# Merge-Commit tragen '[skip ci]', Push mit -o ci.skip auf HEAD:$CI_COMMIT_BRANCH (Order 340 A-01 (c): eigener
# Branch); COMDARE_WRITEBACK_USER/TOKEN gehen NUR ueber GIT_ASKPASS (nie in URL, argv, .git/config oder Log);
# bei Ablehnung fetch + Pruefung + merge (nie rebase), max 5 Versuche; hat sich der Thesis-Gitlink oder das
# CI-Rezept seit CI_COMMIT_SHA bewegt = UEBERHOLT (rc=0, kein Push alter PDFs; exportiert wird beim naechsten Push,
# der eine Pipeline erzeugt -- ein [skip ci]-Bot-Commit, der den Gitlink bewegt, erzeugt selbst keine);
# bei Konflikt sauberer Abbruch (naechste Pipeline holt nach).
# SCHALTER: COMDARE_THESIS_PDF_EXPORT=false = INERT (nur true|false, r7); COMDARE_THESIS_PDF_FASSUNGEN (Teilmenge);
# COMDARE_THESIS_PDF_SRC (Default thesis/diplomarbeit); COMDARE_THESIS_PDF_REMOTE = TESTHAKEN der Bissprobe:
# nur absoluter Pfad auf ein lokales Bare-Repo, in CI (CI/GITLAB_CI gesetzt) laut verweigert.
# Push-Option ci.no_pipeline (19.1-Doku) statt ci.skip = Owner-Frage Q-2 der Bewertung r1, hier nicht gesetzt.
set -eu
set -f
fehler() { echo "FEHLER: $*"; exit 1; }
# C6-06 (r7): Instanz-Konstanten -- Host wie die origin-URL des Projekts, Projekt-ID 288 (kein Projektpfad-Literal).
INSTANZ_HOST=gitlab.comdare.local
INSTANZ_PROJEKT_ID=288
# S7-04 (r8b): kanonischer Projektpfad des Projekts 288 (aus der origin-URL des super); NIE ausgeben (Log/Bericht
# maskieren als <super-pfad>). CI_PROJECT_PATH muss ihm gleichen, sonst FEHLER ohne Wertausgabe.
INSTANZ_PROJEKT_PFAD=comdare/research/probst-diplomarbeit-cache-engine
# C6-07 (r7): Modus --ci = Produktionsaufruf aus der YAML (Literal im script:, nicht per Variable ueberschreibbar).
MODUS=""
for arg in "$@"; do
  case "$arg" in --ci) MODUS=ci ;; *) fehler "unbekanntes Argument '$arg' (erlaubt: --ci)" ;; esac
done
# C6-13 (r7): nur true|false; jeder andere Wert (Tippfehler) endet laut statt als gruener INERT-Job.
# S7-06 (r8b): expliziter Leerwert ist KEIN Default (fail-closed): nur ungesetzt = true.
SW="${COMDARE_THESIS_PDF_EXPORT-true}"
case "$SW" in
  true) ;;
  false) echo "INERT: COMDARE_THESIS_PDF_EXPORT=false, kein Export"; exit 0 ;;
  *) fehler "COMDARE_THESIS_PDF_EXPORT='$SW' unbekannt (erlaubt: true|false; C6-13)" ;;
esac
DIR="${COMDARE_THESIS_PDF_DIR-docs/diplomarbeit}"
SRC="${COMDARE_THESIS_PDF_SRC-thesis/diplomarbeit}"
FASSUNGEN="${COMDARE_THESIS_PDF_FASSUNGEN-de-lang en-lang de-kurz en-kurz}"
[ -n "$DIR" ] || fehler "COMDARE_THESIS_PDF_DIR ist gesetzt, aber leer (S7-06: kein stiller Default)"
[ -n "$SRC" ] || fehler "COMDARE_THESIS_PDF_SRC ist gesetzt, aber leer (S7-06: kein stiller Default)"
[ -n "$FASSUNGEN" ] || fehler "COMDARE_THESIS_PDF_FASSUNGEN ist gesetzt, aber leer (S7-06: kein stiller Default)"
BRANCH="${CI_COMMIT_BRANCH:?thesis_pdf_export: nur in Branch-Pipelines (CI_COMMIT_BRANCH fehlt)}"
PIPE_SHA="${CI_COMMIT_SHA:?thesis_pdf_export: CI_COMMIT_SHA fehlt (Pipeline-Stand fuer die Stale-Pruefung)}"
KURZ="${CI_COMMIT_SHORT_SHA:-NA}"
PIPE_ID="${CI_PIPELINE_ID:-NA}"
export GIT_TERMINAL_PROMPT=0
GITP="git -c credential.helper="
# Hilfsdateien (Askpass-Helfer, Index-Liste, Push-Meldung) liegen in EINEM 0700-Wegwerfordner ausserhalb des
# Arbeitsbaums und verschwinden mit dem Script.
WERK=$(mktemp -d "${TMPDIR:-/tmp}/thesis_pdf_export.XXXXXX") || fehler "mktemp -d fuer Hilfsdateien"
trap 'rm -rf "$WERK"' EXIT
# S7-08 (r8b): Signale muenden in exit, damit der EXIT-Trap das Hilfsverzeichnis auch dann raeumt.
trap 'exit 129' HUP; trap 'exit 130' INT; trap 'exit 143' TERM

# Explizite Statusauswertung (0 = gleich / Vorfahr, 1 = verschieden / kein Vorfahr, sonst Abbruch): set -e
# unterscheidet 1 nicht von einem Werkzeugfehler.
diff_gleich() { set +e; git diff --quiet "$@"; _rc=$?; set -e
    case "$_rc" in 0|1) return "$_rc" ;; *) fehler "git diff --quiet $* (rc=$_rc)" ;; esac; }
ist_vorfahr() { set +e; git merge-base --is-ancestor "$1" "$2"; _rc=$?; set -e
    case "$_rc" in 0|1) return "$_rc" ;; *) fehler "git merge-base --is-ancestor $1 $2 (rc=$_rc)" ;; esac; }

# Ort und Stand: Repo-Wurzel, HEAD == Pipeline-Commit (Provenienz "PDF = CI_COMMIT_SHA").
WURZEL=$(pwd -P) || fehler "pwd -P"
TOP=$(git rev-parse --show-toplevel) || fehler "kein git-Arbeitsbaum"
[ "$TOP" = "$WURZEL" ] || fehler "muss in der Repo-Wurzel laufen ($TOP != $WURZEL)"
HEAD_SHA=$(git rev-parse --verify HEAD) || fehler "HEAD nicht bestimmbar"
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
  chmod 0700 "$WERK/askpass.sh"
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
    ''|.|/*|..|../*|*/../*|*/..) fehler "'$p' muss ein relativer Pfad ohne '..' sein" ;;
    # L1-01 (r2): git add uebergeht Pfade mit einer .git-Komponente STILL (rc=0, nichts gestagt) -- ein solches
    # Ziel endete als gruener Job ohne Export.
    .git|.git/*|*/.git|*/.git/*) fehler "'$p' traegt eine .git-Komponente (git add uebergeht solche Pfade still)" ;;
  esac
done
[ ! -L "$DIR" ] || fehler "$DIR ist ein Symlink (Zielordner verboten)"
[ -d "$SRC" ] || fehler "Quelle $SRC fehlt (Artefakt des thesis:pdf-Jobs)"
# L1-02 (r2): Kanonik und Arbeitsbaum-Grenze VOR dem ersten Seiteneffekt. readlink -m loest auch noch fehlende
# Glieder auf; ein getrackter Zwischen-Symlink (docs/ext -> ../../aussen) darf nicht einmal ein leeres Verzeichnis
# ausserhalb des Baums anlegen. readlink -f nach mkdir bleibt als zweite Schicht.
DIR_K=$(readlink -m -- "$DIR") || fehler "readlink -m $DIR"
SRC_K=$(readlink -f -- "$SRC") || fehler "readlink -f $SRC"
# C6-08 (r7): Symmetrie zu DIR_K -- die Quelle darf nicht ueber einen Zwischen-Symlink aus dem Baum zeigen.
case "$SRC_K/" in
  "$WURZEL/"*) ;;
  *) fehler "$SRC (Quelle) liegt ausserhalb des Arbeitsbaums ($SRC_K, C6-08)" ;;
esac
[ "$DIR_K" != "$SRC_K" ] || fehler "Ziel und Quelle identisch ($DIR)"
case "$DIR_K/" in
  "$WURZEL/"*) ;;
  *) fehler "$DIR liegt ausserhalb des Arbeitsbaums ($DIR_K)" ;;
esac
mkdir -p -- "$DIR" || fehler "mkdir -p $DIR"
DIR_F=$(readlink -f -- "$DIR") || fehler "readlink -f $DIR"
[ "$DIR_F" = "$DIR_K" ] || fehler "$DIR: Kanonik nach mkdir ($DIR_F) weicht von der Vorpruefung ($DIR_K) ab"

n=0; gesehen=' '
for f in $FASSUNGEN; do
  case "$f" in
    de-lang|en-lang|de-kurz|en-kurz) ;;
    *) fehler "unbekannte Fassung '$f' (erlaubt: de-lang en-lang de-kurz en-kurz)" ;;
  esac
  # L2-06 (r3): ein Duplikat endete als 'nur 1 von 2 Zieldateien im Index' -- laut beim Namen nennen.
  case "$gesehen" in *" $f "*) fehler "Fassung '$f' doppelt in COMDARE_THESIS_PDF_FASSUNGEN" ;; esac
  gesehen="$gesehen$f "
  src="$SRC/diplomarbeit-$f.pdf"; dst="$DIR/diplomarbeit-$f.pdf"
  [ ! -L "$src" ] || fehler "$src ist ein Symlink (Quelldatei verboten)"
  [ -s "$src" ] || fehler "Fassung $src fehlt oder ist leer (Artefakt des thesis:pdf-Jobs)"
  hdr=$(head -c 5 -- "$src") || fehler "head -c 5 $src (S7-08)"   # pipelinefrei (S7-08, r8b)
  [ "$hdr" = "%PDF-" ] || fehler "$src ist kein PDF (Header)"
  [ ! -L "$dst" ] || fehler "$dst ist ein Symlink (Zieldatei verboten)"
  groesse=$(wc -c < "$src") || fehler "wc -c $src"
  cp -f "$src" "$dst" || fehler "cp $src $dst"
  git add -- "$dst" || fehler "git add $dst"
  # L1-01 (r2): git add endet fuer .git-Pfade und assume-unchanged-Eintraege still mit rc=0, ohne zu stagen. Der
  # Index muss danach den Pfad UND genau den Inhalt der Arbeitskopie tragen (git diff --quiet traut assume-unchanged).
  git ls-files --error-unmatch -- "$dst" >/dev/null 2>&1 \
    || fehler "$dst steht nach git add nicht im Index (git add hat den Pfad still uebergangen)"
  blob=$(git hash-object -- "$dst") || fehler "git hash-object $dst"
  idx=$(git rev-parse --verify -q ":$dst") || fehler "git rev-parse :$dst (kein Stage-0-Eintrag)"
  [ "$idx" = "$blob" ] || fehler "Index traegt fuer $dst nicht den Inhalt der Arbeitskopie ($idx != $blob)"
  printf '%s\n' "$dst" >> "$WERK/dst.txt" || fehler "Zielliste $WERK/dst.txt"
  n=$((n+1))
  echo "Fassung $f: $groesse B nach $dst"
done
[ "$n" -gt 0 ] || fehler "keine Fassung in COMDARE_THESIS_PDF_FASSUNGEN"
# L1-01 (r2): Nachzaehlung nach der Schleife -- alle n Zieldateien stehen im Index unter $DIR/ (nicht ueber
# diff --cached: bei byte-gleichem Bestand ist der gestagte Diff leer, und UNVERAENDERT unten ist der richtige Ausgang).
git ls-files -- "$DIR" > "$WERK/ls.txt" || fehler "git ls-files $DIR"
gestagt=$(grep -cxF -f "$WERK/dst.txt" "$WERK/ls.txt" || true)
[ "$gestagt" -eq "$n" ] || fehler "nur $gestagt von $n Zieldateien stehen im Index unter $DIR/"

# I-02 / S7-03 (r8b): der Index darf GENAU die Fassungs-Liste tragen (nicht nur "unter $DIR/"); der Commit, der
# lokale Byte-Vergleich und die Remote-Idempotenz arbeiten auf derselben exakten Pathspec-Liste (literal, set -f).
git diff --cached --name-only > "$WERK/index.txt" || fehler "git diff --cached --name-only"
fremd=$(grep -c -v -x -F -f "$WERK/dst.txt" "$WERK/index.txt") && fr=0 || fr=$?
case "$fr" in 0|1) ;; *) fehler "Index-Pruefung (grep rc=$fr)" ;; esac
[ "$fremd" -eq 0 ] || fehler "$fremd fremde Pfad(e) im Index (erlaubt ist nur die Fassungs-Liste, S7-03)"
ungestagt=$(git diff --name-only -- "$DIR") || fehler "git diff --name-only $DIR"
[ -z "$ungestagt" ] || fehler "getrackte Aenderung(en) unter $DIR ausserhalb der Fassungs-Liste (ungestagt, S7-03)"
set --
while IFS= read -r p; do set -- "$@" "$p"; done < "$WERK/dst.txt"
[ "$#" -eq "$n" ] || fehler "Fassungs-Liste $# != $n"

if diff_gleich --cached -- "$@"; then
  echo "UNVERAENDERT: $n Fassungen byte-gleich zum Bestand in $DIR, kein Commit"; exit 0
fi
$GITP -c user.name="super-pdf-bot" -c user.email="super-pdf-bot@ci.comdare.local" commit -q --only \
  -m "docs(diplomarbeit): $n Thesis-Fassungen aus Pipeline $PIPE_ID" \
  -m "Quelle super $KURZ ($PIPE_SHA), Submodul thesis/diplomarbeit (Order 389/390, 22.09.2026) [skip ci]" \
  -- "$@" || fehler "git commit"
NEU=$(git rev-parse --short HEAD) || fehler "git rev-parse HEAD"
NEU_VOLL=$(git rev-parse --verify HEAD) || fehler "git rev-parse --verify HEAD"
echo "Commit $NEU auf $BRANCH (Basis Pipeline-Commit $KURZ)"

# F-05 Push-Schleife: jeder Fehler ist sichtbar; nur ein nachgewiesenes non-ff-Race (Remote-Tip bewegt) fuehrt
# zu fetch + Pruefung + merge; F-06 UEBERHOLT-Wache; F-07 Remote-Idempotenz; F-04 Merge-Botschaft mit Marker.
versuch=0
while [ "$versuch" -lt 5 ]; do
  versuch=$((versuch+1))
  if $GITP push -q -o ci.skip "$REMOTE" "HEAD:$BRANCH" 2>"$WERK/push.err"; then
    echo "PUSH OK (ci.skip) auf $BRANCH (Versuch $versuch)"; exit 0
  fi
  echo "Push abgelehnt (Versuch $versuch), git meldet:"; sed 's/^/  | /' "$WERK/push.err"
  $GITP fetch -q "$REMOTE" "$BRANCH" || fehler "fetch $BRANCH fehlgeschlagen (Recht/Netz), kein Race"
  FERN=$(git rev-parse --short FETCH_HEAD) || fehler "git rev-parse FETCH_HEAD"
  if ist_vorfahr FETCH_HEAD HEAD; then
    fehler "Remote-Tip $FERN unbewegt, der Push-Fehler ist kein non-ff-Race (Recht/Hook/Push-Option?)"
  fi
  ist_vorfahr "$PIPE_SHA" FETCH_HEAD \
    || fehler "$BRANCH ($FERN) enthaelt den Pipeline-Commit $KURZ nicht (Rewrite/Force-Push?)"
  if ! diff_gleich "$PIPE_SHA" FETCH_HEAD -- thesis/diplomarbeit .gitlab-ci.yml ci/thesis_pdf_export.sh; then
    echo "UEBERHOLT: Thesis-Gitlink oder CI-Rezept seit $KURZ bewegt ($FERN); kein Push alter PDFs"
    exit 0
  fi
  if diff_gleich HEAD FETCH_HEAD -- "$@"; then  # F-07 Remote-Idempotenz auf der exakten Fassungs-Liste (S7-03)
    echo "UNVERAENDERT (remote): $BRANCH ($FERN) traegt die $n Fassungen bereits byte-gleich, kein Merge/Push"
    exit 0
  fi
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
    if [ -z "$a" ]; then echo "UEBERHOLT: Fassung $dst am Remote geloescht ($FERN), kein Push (S7-02)"; exit 0; fi
    ma="${a%% *}"; ta="${a#* }"; ta="${ta%% *}"
    [ "$ma" = "100644" ] && [ "$ta" = "blob" ] \
      || { echo "UEBERHOLT: Fassung $dst am Remote als $ta/$ma statt blob/100644 ($FERN), kein Push (S7-01)"; exit 0; }
    [ "$a" = "$b" ] || { echo "UEBERHOLT: Fassung $dst am Remote fremd bewegt ($FERN), kein Push (C6-04)"; exit 0; }
  done < "$WERK/dst.txt"
  echo "Merge mit $BRANCH-Tip $FERN [skip ci], erneuter Push"
  if [ "$versuch" -lt 5 ]; then sleep $((versuch * 2)); fi
done
fehler "Push nach 5 Versuchen abgelehnt ($BRANCH bewegt sich zu schnell?)"
