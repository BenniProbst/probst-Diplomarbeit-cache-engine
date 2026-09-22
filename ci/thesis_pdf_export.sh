#!/bin/sh
# ci/thesis_pdf_export.sh -- exportiert die vier Thesis-Fassungen (de/en x lang/kurz) aus dem super-eigenen
# Thesis-Bau (Job thesis:pdf, Submodul thesis/diplomarbeit) als Folge-Commit nach docs/diplomarbeit/
# (Owner-Orders 389 + 390, 22.09.2026; Order 288/340 A-04 (a): Uebersteuerung per Env-Vertrag).
# VERTRAG: laeuft nur nach gruenem thesis:pdf (needs + artifacts); jede Fassung MUSS vorhanden, nicht leer und
# ein PDF sein (sonst rot); Ziel COMDARE_THESIS_PDF_DIR (Default docs/diplomarbeit), stabile Namen
# diplomarbeit-<lang>-<umfang>.pdf, ueberschreibend; byte-gleich = kein Commit; Commit '[skip ci]' + Push mit
# -o ci.skip auf HEAD:$CI_COMMIT_BRANCH (Order 340 A-01 (c): eigener Branch) mit COMDARE_WRITEBACK_USER/TOKEN;
# bei Ablehnung fetch + merge (nie rebase), bei Konflikt sauberer Abbruch (naechste Pipeline holt nach).
# SCHALTER: COMDARE_THESIS_PDF_EXPORT=false = INERT; COMDARE_THESIS_PDF_FASSUNGEN (Default alle vier);
# COMDARE_THESIS_PDF_SRC (Default thesis/diplomarbeit); COMDARE_THESIS_PDF_REMOTE = Push-URL-Ersatz (Testhaken).
set -eu
SW="${COMDARE_THESIS_PDF_EXPORT:-true}"
if [ "$SW" != "true" ]; then echo "INERT: COMDARE_THESIS_PDF_EXPORT=$SW -> kein Export"; exit 0; fi
DIR="${COMDARE_THESIS_PDF_DIR:-docs/diplomarbeit}"
SRC="${COMDARE_THESIS_PDF_SRC:-thesis/diplomarbeit}"
FASSUNGEN="${COMDARE_THESIS_PDF_FASSUNGEN:-de-lang en-lang de-kurz en-kurz}"
BRANCH="${CI_COMMIT_BRANCH:?thesis_pdf_export: nur in Branch-Pipelines (CI_COMMIT_BRANCH fehlt)}"
if [ -z "${COMDARE_THESIS_PDF_REMOTE:-}" ]; then
  : "${COMDARE_WRITEBACK_USER:?thesis_pdf_export: COMDARE_WRITEBACK_USER fehlt (CI-Variable 288, protected)}"
  : "${COMDARE_WRITEBACK_TOKEN:?thesis_pdf_export: COMDARE_WRITEBACK_TOKEN fehlt (CI-Variable 288, protected)}"
  REMOTE="https://${COMDARE_WRITEBACK_USER}:${COMDARE_WRITEBACK_TOKEN}@${CI_SERVER_HOST}"
  REMOTE="${REMOTE}/${CI_PROJECT_PATH}.git"
else
  REMOTE="$COMDARE_THESIS_PDF_REMOTE"
fi
[ "$DIR" != "$SRC" ] || { echo "FEHLER: Ziel und Quelle identisch ($DIR)"; exit 1; }
mkdir -p "$DIR"; n=0
for f in $FASSUNGEN; do
  src="$SRC/diplomarbeit-$f.pdf"; dst="$DIR/diplomarbeit-$f.pdf"
  [ -s "$src" ] || { echo "FEHLER: Fassung $src fehlt oder ist leer (Artefakt des thesis:pdf-Jobs)"; exit 1; }
  head -c 5 "$src" | grep -q '^%PDF-' || { echo "FEHLER: $src ist kein PDF (Header)"; exit 1; }
  cp -f "$src" "$dst"; git add -- "$dst"; n=$((n+1))
  echo "Fassung $f: $(wc -c < "$src") B -> $dst"
done
[ "$n" -gt 0 ] || { echo "FEHLER: keine Fassung in COMDARE_THESIS_PDF_FASSUNGEN"; exit 1; }
if git diff --cached --quiet -- "$DIR"; then
  echo "UNVERAENDERT: $n Fassungen byte-gleich zum Bestand in $DIR, kein Commit"; exit 0
fi
git -c user.name="super-pdf-bot" -c user.email="super-pdf-bot@ci.comdare.local" commit -q \
  -m "docs(diplomarbeit): $n Thesis-Fassungen aus Pipeline ${CI_PIPELINE_ID:-NA}" \
  -m "Quelle super ${CI_COMMIT_SHORT_SHA:-NA}, Submodul thesis/diplomarbeit (Order 389/390, 22.09.2026) [skip ci]"
echo "Commit $(git rev-parse --short HEAD) auf $BRANCH"
export GIT_TERMINAL_PROMPT=0
if git push -q -o ci.skip "$REMOTE" "HEAD:$BRANCH" 2>/dev/null; then echo "PUSH OK (ci.skip) -> $BRANCH"; exit 0; fi
echo "Push abgelehnt (Branch weitergelaufen?) -> fetch + merge (nie rebase), zweiter Versuch"
git fetch -q "$REMOTE" "$BRANCH"
git -c user.name="super-pdf-bot" -c user.email="super-pdf-bot@ci.comdare.local" merge -q --no-edit FETCH_HEAD \
  || { git merge --abort 2>/dev/null || true; echo "FEHLER: Merge kollidiert -> naechste Pipeline holt nach"; exit 1; }
git push -q -o ci.skip "$REMOTE" "HEAD:$BRANCH" && echo "PUSH OK nach Merge (ci.skip) -> $BRANCH" \
  || { echo "FEHLER: Push erneut abgelehnt"; exit 1; }
