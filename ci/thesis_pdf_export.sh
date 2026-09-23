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
# SCHALTER: COMDARE_THESIS_PDF_EXPORT=false = INERT; COMDARE_THESIS_PDF_FASSUNGEN (Teilmenge der vier IDs);
# COMDARE_THESIS_PDF_SRC (Default thesis/diplomarbeit); COMDARE_THESIS_PDF_REMOTE = TESTHAKEN der Bissprobe:
# nur absoluter Pfad auf ein lokales Bare-Repo, in CI (CI/GITLAB_CI gesetzt) laut verweigert.
# Push-Option ci.no_pipeline (19.1-Doku) statt ci.skip = Owner-Frage Q-2 der Bewertung r1, hier nicht gesetzt.
set -eu
set -f
fehler() { echo "FEHLER: $*"; exit 1; }
SW="${COMDARE_THESIS_PDF_EXPORT:-true}"
if [ "$SW" != "true" ]; then echo "INERT: COMDARE_THESIS_PDF_EXPORT=$SW, kein Export"; exit 0; fi
DIR="${COMDARE_THESIS_PDF_DIR:-docs/diplomarbeit}"
SRC="${COMDARE_THESIS_PDF_SRC:-thesis/diplomarbeit}"
FASSUNGEN="${COMDARE_THESIS_PDF_FASSUNGEN:-de-lang en-lang de-kurz en-kurz}"
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
  [ -z "${CI:-}" ] && [ -z "${GITLAB_CI:-}" ] \
    || fehler "COMDARE_THESIS_PDF_REMOTE ist ein Testhaken und wird in CI verweigert (CI/GITLAB_CI gesetzt)"
  case "$COMDARE_THESIS_PDF_REMOTE" in
    /*) ;;
    *) fehler "Testhaken nur als absoluter lokaler Pfad, nicht '$COMDARE_THESIS_PDF_REMOTE'" ;;
  esac
  [ "$(git -C "$COMDARE_THESIS_PDF_REMOTE" rev-parse --is-bare-repository 2>/dev/null)" = "true" ] \
    || fehler "COMDARE_THESIS_PDF_REMOTE '$COMDARE_THESIS_PDF_REMOTE' ist kein lokales Bare-Repo (Testhaken)"
  echo "TESTHAKEN AKTIV: Push-Ziel ist ein lokales Bare-Repo, NICHT das Projekt-Remote"
  REMOTE="$COMDARE_THESIS_PDF_REMOTE"
else
  : "${COMDARE_WRITEBACK_USER:?thesis_pdf_export: COMDARE_WRITEBACK_USER fehlt (CI-Variable 288, protected)}"
  : "${COMDARE_WRITEBACK_TOKEN:?thesis_pdf_export: COMDARE_WRITEBACK_TOKEN fehlt (CI-Variable 288, protected)}"
  : "${CI_SERVER_URL:?thesis_pdf_export: CI_SERVER_URL fehlt (Protokoll+Host+Port des Servers)}"
  : "${CI_PROJECT_PATH:?thesis_pdf_export: CI_PROJECT_PATH fehlt}"
  REMOTE="${CI_SERVER_URL%/}/${CI_PROJECT_PATH}.git"
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
norm_pfad() { _p="$1"
  while :; do case "$_p" in ./*) _p="${_p#./}" ;; */) _p="${_p%/}" ;; *) break ;; esac; done
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
[ "$DIR_K" != "$SRC_K" ] || fehler "Ziel und Quelle identisch ($DIR)"
case "$DIR_K/" in
  "$WURZEL/"*) ;;
  *) fehler "$DIR liegt ausserhalb des Arbeitsbaums ($DIR_K)" ;;
esac
mkdir -p -- "$DIR" || fehler "mkdir -p $DIR"
DIR_F=$(readlink -f -- "$DIR") || fehler "readlink -f $DIR"
[ "$DIR_F" = "$DIR_K" ] || fehler "$DIR: Kanonik nach mkdir ($DIR_F) weicht von der Vorpruefung ($DIR_K) ab"

n=0
for f in $FASSUNGEN; do
  case "$f" in
    de-lang|en-lang|de-kurz|en-kurz) ;;
    *) fehler "unbekannte Fassung '$f' (erlaubt: de-lang en-lang de-kurz en-kurz)" ;;
  esac
  src="$SRC/diplomarbeit-$f.pdf"; dst="$DIR/diplomarbeit-$f.pdf"
  [ ! -L "$src" ] || fehler "$src ist ein Symlink (Quelldatei verboten)"
  [ -s "$src" ] || fehler "Fassung $src fehlt oder ist leer (Artefakt des thesis:pdf-Jobs)"
  head -c 5 "$src" | grep -q '^%PDF-' || fehler "$src ist kein PDF (Header)"
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

# I-02: nur Pfade unter $DIR/ duerfen im Index stehen; der Commit nimmt zusaetzlich nur den Pathspec $DIR.
git diff --cached --name-only > "$WERK/index.txt" || fehler "git diff --cached --name-only"
fremd=$(awk -v d="$DIR/" 'index($0, d) != 1 { n++ } END { print n + 0 }' "$WERK/index.txt") \
  || fehler "Index-Pruefung (awk)"
[ "$fremd" -eq 0 ] || fehler "$fremd fremde Pfad(e) im Index (erlaubt ist nur $DIR/)"

if diff_gleich --cached -- "$DIR"; then
  echo "UNVERAENDERT: $n Fassungen byte-gleich zum Bestand in $DIR, kein Commit"; exit 0
fi
$GITP -c user.name="super-pdf-bot" -c user.email="super-pdf-bot@ci.comdare.local" commit -q --only \
  -m "docs(diplomarbeit): $n Thesis-Fassungen aus Pipeline $PIPE_ID" \
  -m "Quelle super $KURZ ($PIPE_SHA), Submodul thesis/diplomarbeit (Order 389/390, 22.09.2026) [skip ci]" \
  -- "$DIR" || fehler "git commit"
NEU=$(git rev-parse --short HEAD) || fehler "git rev-parse HEAD"
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
  if ! diff_gleich "$PIPE_SHA" FETCH_HEAD -- thesis/diplomarbeit .gitlab-ci.yml; then
    echo "UEBERHOLT: Thesis-Gitlink oder CI-Rezept seit $KURZ bewegt ($FERN); kein Push alter PDFs"
    exit 0
  fi
  if diff_gleich HEAD FETCH_HEAD -- "$DIR"; then  # F-07 Remote-Idempotenz
    echo "UNVERAENDERT (remote): $BRANCH ($FERN) traegt die $n Fassungen bereits byte-gleich, kein Merge/Push"
    exit 0
  fi
  $GITP -c user.name="super-pdf-bot" -c user.email="super-pdf-bot@ci.comdare.local" merge -q --no-edit \
    -m "Merge $BRANCH in thesis-pdf-export $PIPE_ID [skip ci]" FETCH_HEAD \
    || { git merge --abort 2>/dev/null || true; fehler "Merge mit $FERN kollidiert, naechste Pipeline holt nach"; }
  echo "Merge mit $BRANCH-Tip $FERN [skip ci], erneuter Push"
  if [ "$versuch" -lt 5 ]; then sleep $((versuch * 2)); fi
done
fehler "Push nach 5 Versuchen abgelehnt ($BRANCH bewegt sich zu schnell?)"
