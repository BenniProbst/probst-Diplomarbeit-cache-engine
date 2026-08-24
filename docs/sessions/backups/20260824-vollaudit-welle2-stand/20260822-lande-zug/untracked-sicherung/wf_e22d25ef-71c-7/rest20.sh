#!/usr/bin/env bash
# =====================================================================================
# MESSUNG des ##20-RESTPOSTENS am GELANDETEN Kern (ci/anhang_forward_core.sh).
# Gegenstand: der geschluckte `git add ... 2>/dev/null || true` (:417) und das
# daran haengende Urteil "IDEMPOTENT: 0 Aenderungen -> kein Commit" (:423).
#
# Drei Laeufe, jeder mit gewuerfeltem Koeder (K13, /dev/urandom):
#   E1  Ziel-Repo ignoriert die .tex  -> kopiert>0, gestagt=0  -> was sagt der Kanal?
#   E2  GEGENPROBE, identisch ohne .gitignore -> Commit mit Koeder im Blob?
#   E3  MUTANT: `|| true` entfernt, Sprache 'en' fehlt im Ziel -> stirbt der Kanal?
#
# ASCII-only. Kein Schreiben ausserhalb der Werkbank. Alles unter /tmp.
# =====================================================================================
set -u
KERN="/home/comdare/wt-super-landung/ci/anhang_forward_core.sh"
WERK="$(mktemp -d)"
trap 'rm -rf "$WERK"' EXIT

wuerfel() { head -c 8 /dev/urandom | od -An -tx1 | tr -d ' \n'; }

# --- Sandbox: Artefaktquelle (Zweig 1a) + Ziel-Repo ----------------------------------
bau_sandbox() {   # $1 = Fallname, $2 = Koeder, $3 = "mit_gitignore"|"ohne", $4 = "de en"|"de"
  local s="$WERK/$1"
  mkdir -p "$s/arbeit/artefakte"
  local L
  for L in $4; do
    mkdir -p "$s/arbeit/artefakte/$L/tabellen"
    printf '%% koeder=%s lang=%s\n' "$2" "$L" > "$s/arbeit/artefakte/$L/tabellen/A_messwerte.tex"
  done
  git init --quiet "$s/ziel"
  git -C "$s/ziel" config user.name  "mess-bot"
  git -C "$s/ziel" config user.email "mess-bot@test.local"
  git -C "$s/ziel" config commit.gpgsign false
  printf 'Sandbox\n' > "$s/ziel/LIESMICH.txt"
  if [ "$3" = "mit_gitignore" ]; then
    printf 'anhang/**/tabellen/*.tex\n' > "$s/ziel/.gitignore"
    git -C "$s/ziel" add -- .gitignore
  fi
  # 'en' existiert im Ziel-Repo NICHT als tabellen-Ordner -- so steht es heute in 289.
  mkdir -p "$s/ziel/anhang/de/tabellen"
  printf '%% bestand\n' > "$s/ziel/anhang/de/tabellen/BESTAND.tex"
  git -C "$s/ziel" add -- LIESMICH.txt
  git -C "$s/ziel" add -f -- anhang/de/tabellen/BESTAND.tex
  git -C "$s/ziel" commit --quiet -m "Ausgangs-Commit"
  echo "$s"
}

fahre() {   # $1 = sandbox-pfad, $2 = kern-pfad, $3 = langs
  local s="$1" k="$2" langs="$3"
  set +e
  AF_DEST_REPO="$s/ziel" \
  AF_WORK_ROOT="$s/arbeit" \
  AF_ARTIFACT_ROOTS="artefakte" \
  AF_CORPUS_ROOT="korpus_gibt_es_nicht" \
  AF_LANGS="$langs" \
  AF_GENERATOR="" \
  AF_NO_PUSH=true \
  AF_PDF_GATE=off \
  AF_TMP="$s/tmp" \
  bash "$k" > "$s/out.txt" 2> "$s/err.txt"
  RC=$?
  set -e
}

bilanz() {  # $1 = sandbox, $2 = koeder, $3 = etikett
  local s="$1" k="$2" e="$3" n_commits n_getrackt treffer
  n_commits=$(git -C "$s/ziel" rev-list --count HEAD)
  n_getrackt=$(git -C "$s/ziel" ls-files -- anhang | awk 'END{print NR+0}')
  treffer=$(git -C "$s/ziel" grep -c -F "$k" HEAD -- anhang 2>/dev/null | awk 'END{print NR+0}')
  echo "  RC (ohne Pipe)          = $RC"
  echo "  Commits im Ziel         = $n_commits   (Ausgangswert 1)"
  echo "  getrackt unter anhang/  = $n_getrackt"
  echo "  Koeder $k im HEAD-Blob  = $treffer Datei(en)"
  echo "  -- die entscheidenden Ausgabezeilen --"
  /usr/bin/grep -E "kopiert gesamt|gestagte Aenderungen|IDEMPOTENT|NO-OP|COMMIT|FEHLER" "$s/out.txt" | sed 's/^/    /'
  if [ -s "$s/err.txt" ]; then echo "  -- stderr --"; sed 's/^/    /' "$s/err.txt" | head -6; fi
}

echo "====================================================================="
echo "MESSORT: $KERN"
echo "  Zeilen: $(awk 'END{print NR}' "$KERN")   Werkbank: $WERK"
echo "====================================================================="

# ---------------- E1: Ziel ignoriert die .tex --------------------------------
K1=$(wuerfel)
S1=$(bau_sandbox e1 "$K1" mit_gitignore "de")
echo
echo "-- E1  Ziel-Repo ignoriert anhang/**/tabellen/*.tex ; Koeder=$K1 --"
fahre "$S1" "$KERN" "de"
bilanz "$S1" "$K1" E1

# ---------------- E2: Gegenprobe, ohne .gitignore ----------------------------
K2=$(wuerfel)
S2=$(bau_sandbox e2 "$K2" ohne "de")
echo
echo "-- E2  GEGENPROBE: identisch, aber ohne .gitignore ; Koeder=$K2 --"
fahre "$S2" "$KERN" "de"
bilanz "$S2" "$K2" E2

# ---------------- E3: Mutant ohne `|| true`, Sprache en fehlt ---------------
MUT="$WERK/kern_ohne_true.sh"
sed 's#git -C "$AF_DEST_REPO" add -- "anhang/$lang/tabellen" 2>/dev/null || true#git -C "$AF_DEST_REPO" add -- "anhang/$lang/tabellen"#' "$KERN" > "$MUT"
chmod +x "$MUT"
GEAENDERT=$(diff "$KERN" "$MUT" | /usr/bin/grep -c '^<')
echo
echo "-- E3  MUTANT: '|| true' entfernt (zurueckgedreht: $GEAENDERT Quellzeile(n), erwartet 1)"
K3=$(wuerfel)
S3=$(bau_sandbox e3 "$K3" ohne "de")
echo "   Quelle traegt NUR 'de'; AF_LANGS='de,en' wie im CI-Job ; Koeder=$K3"
fahre "$S3" "$MUT" "de,en"
bilanz "$S3" "$K3" E3

echo
echo "-- E3b GEGENPROBE: derselbe Fall gegen den GELANDETEN Kern --"
K4=$(wuerfel)
S4=$(bau_sandbox e3b "$K4" ohne "de")
fahre "$S4" "$KERN" "de,en"
bilanz "$S4" "$K4" E3b
echo
echo "====================================================================="
