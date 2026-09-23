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
#
# SELBSTBISS (--selbstbiss): zwanzig Wegwerf-Mutanten -- Script: M1 Marker
# [skip ci] aus der Merge-Botschaft, M2 Symlink-Pruefung der Zieldatei,
# M3 Remote-Idempotenz-Zweig, M4 .git-Muster, M5 Inhalts-Invariante nach
# git add, M6 Arbeitsbaum-Grenze vor mkdir, M10 https-Pflicht, M11 Duplikat-
# Pruefung, M12 '//'-Faltung; YAML: M7 Eltern-Walk (Quellstand), M8 Epoch-
# Weiche (dreiwertig), M9 Byte-Urteil, M13 shallow-Pruefung (r4), M14
# Fullbanner-Vergleich (r4), M15 Ein-Elter-Regel (r5), M16 letzter Treffer
# (r5), M17 Walk-Deckel (r5), M18 sha256sum-FEHLER (r5), M19 CI_PROJECT_DIR-
# Gate (r5), M20 '[skip ci]'-Bedingung (r5). Sie MUESSEN P-03 / P-05 / P-02 /
# P-16 / P-19 / P-18 / P-27 / P-26 / P-25 / P-23 / P-24 / P-24 / P-23 / P-24 /
# P-23 / P-24 / P-23 / P-24 / P-23 / P-23 rot machen -- sonst beweist die Probe
# nichts und endet mit rc=2. Fehlen die YAML-Marker (Lead-Patch noch nicht
# gelandet), entfallen M7-M9/M13-M20 LAUT; P-23/P-24 sind dann rot.
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
GRUEN_N=0; ROT_N=0; ROT_LISTE=""; FEHL=0; LAUF_N=0
BARE=""; BASE=""

echo "============================================================================="
echo " BISSPROBE thesis_pdf_export -- Script: $SKRIPT"
echo " Wegwerf-Wurzel: $T"
echo " YAML (P-17):    $CI_YML"
echo "============================================================================="

ok()  { echo "    [OK]  $*"; }
rot() { echo "    [ROT] $*"; FEHL=$((FEHL+1)); }
erw_rc() { if [ "$1" -eq "$2" ]; then ok "rc=$1 (erwartet $2)"; else rot "rc=$1 (erwartet $2)"; fi; }
erw_text() {
    if grep -qF -- "$2" "$1"; then ok "Ausgabe enthaelt '$2'"; else rot "Ausgabe enthaelt NICHT '$2'"; fi
}
erw_kein_text() {
    if grep -qF -- "$2" "$1"; then rot "Ausgabe enthaelt '$2' (verboten)"; else ok "Ausgabe frei von '$2'"; fi
}
erw_gleich() { if [ "$1" = "$2" ]; then ok "$3: $1"; else rot "$3: '$1' (erwartet '$2')"; fi; }
zeige() { sed 's/^/      > /' "$1"; }

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
        CI_PIPELINE_ID=4711 "$@" sh "$_s" ) > "$_l" 2>&1
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
    zeige "$d/out"; erw_rc "$rc" 1; erw_text "$d/out" "unbekannte Fassung '*'"
}
fall_P07() {
    s="$1"; d="$T/P07"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_FASSUNGEN='de-lang foo'
    rc=$?; zeige "$d/out"; erw_rc "$rc" 1; erw_text "$d/out" "unbekannte Fassung 'foo'"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert"
}
fall_P08() {
    s="$1"; d="$T/P08"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out" "$BASE" COMDARE_THESIS_PDF_REMOTE="$BARE" COMDARE_THESIS_PDF_EXPORT=false; rc=$?
    zeige "$d/out"; erw_rc "$rc" 0; erw_text "$d/out" "INERT"
    t=$(tip); erw_gleich "$t" "$BASE" "Bare-Tip unveraendert (0 Commits)"
}
fall_P09() {
    s="$1"; d="$T/P09"; baue_seed "$d" || { rot "Wegwerf-Remote nicht baubar"; return; }
    klone "$d/work" "$BASE" || { rot "Klon nicht baubar"; return; }; lege_pdfs "$d/work" v1
    lauf "$d/work" "$s" "$d/out" "$BASE" CI_SERVER_URL=https://127.0.0.1:9 CI_PROJECT_PATH=gruppe/projekt \
        COMDARE_WRITEBACK_USER=ciuser COMDARE_WRITEBACK_TOKEN="$KOEDER" GIT_TRACE=1; rc=$?
    # Das Protokoll wird NICHT gezeigt (Trace ist lang); die Zaehlung ist der Beleg.
    erw_rc "$rc" 1
    erw_text "$d/out" "remote-https"        # Nenner: der Transport-Aufruf steht im Trace
    erw_text "$d/out" "127.0.0.1:9"         # Nenner: das Ziel steht im Trace
    erw_kein_text "$d/out" "$KOEDER"        # F-01: Token in 0 Zeilen (argv/Fehlertext)
    erw_kein_text "$d/out" "ciuser:"        # F-01: kein user:pass in einer URL
    erw_text "$d/out" "kein Race"           # F-05: Netzfehler endet laut, ohne Merge-Zweig
    zl=$(grep -c 'remote-https' "$d/out"); echo "      Trace-Zeilen mit remote-https: $zl"
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
fall_P17() { # T-7 (L1-14, Vorlage K9): eigene Registrierung + kein allow_failure im eigenen Job-Block, Koeder zuerst
    d="$T/P17"; mkdir -p "$d"
    {
        printf 'x:\n  script:\n    - echo x\n\n'
        printf '%s:\n  stage: test\n  allow_failure: true\n  script:\n    - %s --selbstbiss\n\n' "$JOB" "$AUFRUF"
        printf '# allow_failure in Prosa\ny:\n  script: [echo y]\n'
    } > "$d/koeder.yml"
    k_a=$(zaehle_aufrufe "$d/koeder.yml"); k_j=$(zaehle_jobkopf "$d/koeder.yml"); k_f=$(zaehle_allow "$d/koeder.yml")
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
epoch_zeit() { date -u -d "@$1" +%Y%m%d%H%M%S; }
lege_pdf_epoch() { # $1 = Verzeichnis, $2 = Epoch, $3 = Marke
    for f in de-lang en-lang de-kurz en-kurz; do
        printf '%%PDF-1.4\n%% fassung %s %s\n/CreationDate (D:%sZ)\n%%%%EOF\n' "$f" "$3" "$(epoch_zeit "$2")" \
            > "$1/diplomarbeit-$f.pdf"
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
    # r4 (L3-02): Wegwerf-pdftex fuer die Nachweiszeile des Blocks (die ECHTE Installation ist Konfig-Posten)
    mkdir -p "$d/bin" || { rot "Wegwerf-bin nicht anlegbar"; return; }
    printf '#!/bin/sh\necho "pdfTeX 3.141592653-2.6-1.40.29 (TeX Live 2026) [Wegwerf-pdftex der Probe]"\n' \
        > "$d/bin/pdftex"; chmod 0755 "$d/bin/pdftex"
    P24_PATH="$d/bin:$PATH"
    cat > "$d/bau.sh" <<'BAU'
for f in de-lang en-lang de-kurz en-kurz; do
  printf '%%PDF-1.4\n%% fassung %s %s\n/CreationDate (D:%sZ)\n%%%%EOF\n' "$f" "$BAU_MARKE" \
    "$(date -u -d "@$SOURCE_DATE_EPOCH" +%Y%m%d%H%M%S)" > "diplomarbeit-$f.pdf"
  [ -z "${BAU_BANNER:-}" ] || printf '/PTEX.Fullbanner (%s)\n' "$BAU_BANNER" >> "diplomarbeit-$f.pdf"
done
[ -z "${BAU_DRIFT:-}" ] || printf '%% drift\n' >> "diplomarbeit-de-lang.pdf"
BAU
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
    lege_pdf_epoch "$MODUL" "$T1" writeback1
    for f in de-lang en-lang de-kurz en-kurz; do
        printf '/PTEX.Fullbanner (%s)\n' "$B289" >> "$MODUL/diplomarbeit-$f.pdf"
    done
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
    erw_kein_text "$d/out_f" "FEHLER"; erw_text "$d/out_f" "CreationDate '' = Epoch ''"
    # (g) L3-02 (r4): pdftex fehlt auf dem PATH -- die Nachweiszeile ist fail-closed (FEHLER, rc=1); Wegwerf-PATH
    # nur mit den Werkzeugen der Bloecke (bash git date grep sed sha256sum cut mktemp rm head tr), ohne pdftex.
    mkdir -p "$d/nobin" || { rot "Wegwerf-nobin nicht anlegbar"; return; }
    for w in bash git date grep sed sha256sum cut mktemp rm head tr; do
        ln -s "$(command -v "$w")" "$d/nobin/$w" || { rot "Werkzeug $w nicht verlinkbar"; return; }
    done
    stand "$Y1" || { rot "Stand Y1 (g)"; return; }
    fahre_block "$d/lauf.sh" "$d/out_g" PATH="$d/nobin" BAU_MARKE=writeback1; rc=$?; zeige "$d/out_g"
    erw_rc "$rc" 1; erw_text "$d/out_g" "pdftex fehlt"; erw_kein_text "$d/out_g" "byte-gleich"
    # (h) L4-02 (r5, ADV-28): eingebettetes /PTEX.InfoDict einer Figur (fremdes CreationDate + fremder Fullbanner)
    # steht VOR dem Info-Dict des Dokuments; der LETZTE Treffer zaehlt. (h1) Bytes gleich -> byte-gleich (am r4-Block:
    # -m1 nimmt das Figur-Datum, 4x 'veraltet', kein Byte-Urteil bei rc=0); (h2) Figur-Banner gleich, Dokument-Banner
    # verschieden -> 'Toolchain abweichend' rc=0 (am r4-Block: erster Treffer gleich, Byte-Urteil 'FEHLER: DRIFT').
    FIG='This is pdfTeX, Version 3.141592653-2.6-1.40.20 (TeX Live 2019) kpathsea version 6.3.1'
    cat > "$d/bau_fig.sh" <<'BAU'
for f in de-lang en-lang de-kurz en-kurz; do
  printf '%%PDF-1.4\n/PTEX.InfoDict << /CreationDate (D:20200101000000Z) /PTEX.Fullbanner (%s) >>\n' "$BAU_FIG" \
    > "diplomarbeit-$f.pdf"
  printf '%% fassung %s %s\n/CreationDate (D:%sZ)\n/PTEX.Fullbanner (%s)\n%%%%EOF\n' "$f" "$BAU_MARKE" \
    "$(date -u -d "@$SOURCE_DATE_EPOCH" +%Y%m%d%H%M%S)" "$BAU_BANNER" >> "diplomarbeit-$f.pdf"
done
BAU
    cat "$d/epoch.sh" "$d/bau_fig.sh" "$d/drift.sh" > "$d/lauf_fig.sh"
    stand "$X1" && git -C "$MODUL" checkout -q -B fig "$X1" || { rot "Zweig fig nicht setzbar"; return; }
    for f in de-lang en-lang de-kurz en-kurz; do
        printf '%%PDF-1.4\n/PTEX.InfoDict << /CreationDate (D:20200101000000Z) /PTEX.Fullbanner (%s) >>\n' "$FIG" \
            > "$MODUL/diplomarbeit-$f.pdf"
        printf '%% fassung %s writeback1\n/CreationDate (D:%sZ)\n/PTEX.Fullbanner (%s)\n%%%%EOF\n' "$f" \
            "$(epoch_zeit "$T1")" "$B289" >> "$MODUL/diplomarbeit-$f.pdf"
    done
    git -C "$MODUL" add -- diplomarbeit-*.pdf && modul_commit 1758600270 "Y1g writeback mit Figur-Dict [skip ci]" \
        || { rot "Commit Y1g"; return; }
    Y1G=$(git -C "$MODUL" rev-parse HEAD) || { rot "rev-parse Y1g"; return; }
    n_=$(git -C "$MODUL" show "$Y1G:diplomarbeit-de-lang.pdf" | grep -a -c 'CreationDate (D:')
    erw_gleich "$n_" 2 "Nenner: CreationDate-Eintraege in der 289-Kopie (Figur zuerst, Dokument zuletzt)"
    stand "$Y1G" || { rot "Stand Y1g"; return; }
    fahre_block "$d/lauf_fig.sh" "$d/out_h1" PATH="$P24_PATH" BAU_MARKE=writeback1 BAU_FIG="$FIG" BAU_BANNER="$B289"
    rc=$?; zeige "$d/out_h1"
    erw_rc "$rc" 0; erw_text "$d/out_h1" "4 byte-gleich geprueft"; erw_text "$d/out_h1" "0 veraltet/abweichend"
    erw_kein_text "$d/out_h1" "FEHLER"
    stand "$Y1G" || { rot "Stand Y1g (h2)"; return; }
    fahre_block "$d/lauf_fig.sh" "$d/out_h2" PATH="$P24_PATH" BAU_MARKE=writeback1 BAU_FIG="$FIG" BAU_BANNER="$B288"
    rc=$?; zeige "$d/out_h2"
    erw_rc "$rc" 0; erw_text "$d/out_h2" "Toolchain abweichend"; erw_text "$d/out_h2" "0 byte-gleich geprueft"
    erw_kein_text "$d/out_h2" "FEHLER: DRIFT"
    erw_text "$d/out_h2" "TeX Live 2025"; erw_text "$d/out_h2" "TeX Live 2026"   # beide Dokument-Kennungen im Log
    # (i) L4-07 (r5, ADV-24): sha256sum scheitert im Byte-Urteil -> FEHLER-Zeile + rc=1 (am r4-Block: set -e ohne
    # FEHLER-Zeile). Wegwerf-sha256sum vor dem PATH.
    mkdir -p "$d/badbin" || { rot "Wegwerf-badbin nicht anlegbar"; return; }
    printf '#!/bin/sh\necho "sha256sum: Wegwerf-Stub scheitert" >&2; exit 1\n' > "$d/badbin/sha256sum"
    chmod 0755 "$d/badbin/sha256sum"
    stand "$Y1" || { rot "Stand Y1 (i)"; return; }
    fahre_block "$d/lauf.sh" "$d/out_i" PATH="$d/badbin:$P24_PATH" BAU_MARKE=writeback1; rc=$?; zeige "$d/out_i"
    erw_rc "$rc" 1; erw_text "$d/out_i" "FEHLER: sha256sum"; erw_kein_text "$d/out_i" "byte-gleich"
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
    rc=$?; zeige "$d/out"; erw_rc "$rc" 1; erw_text "$d/out" "Fassung 'de-lang' doppelt"
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

fall() { # $1 = Kennung, $2 = Funktion, $3 = Script
    FEHL=0; echo ""; echo "== $1 =="
    "$2" "$3"
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
fall P-05 fall_P05 "$SKRIPT"
fall P-06 fall_P06 "$SKRIPT"
fall P-07 fall_P07 "$SKRIPT"
fall P-08 fall_P08 "$SKRIPT"
fall P-09 fall_P09 "$SKRIPT"
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
    MUT_N=9; ENTF_N=0
    for m in m1 m2 m3 m4 m5 m6 m10 m11 m12; do
        if cmp -s "$SKRIPT" "$MUT/$m.sh"; then
            echo "  [ABBRUCH] Mutante $m ist byte-gleich zum Script -- das Muster greift nicht"; BISS_RC=2
        fi
    done
    biss() { # $1 = Mutante, $2 = Fallfunktion, $3 = Kennung
        T_ALT="$T"; T="$T/biss_$1"; mkdir -p "$T"
        ( FEHL=0; "$2" "$MUT/$1.sh" > "$T/protokoll.txt" 2>&1; exit "$FEHL" ); r=$?
        T="$T_ALT"
        if [ "$r" -gt 0 ]; then
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
    # YAML-Mutanten (r3): nur wenn die Marker-Bloecke in der YAML stehen; sonst LAUT entfallen (P-23/P-24 rot)
    zm=$(extrahiere_block "$CI_YML" EPOCH-288 "$MUT/marker.txt")
    if [ "$zm" -lt 5 ]; then
        ENTF_N=11; echo "  [ENTFAELLT] Mutanten m7/m8/m9/m13-m20 (YAML): Block EPOCH-288 fehlt in der YAML ($zm Zeilen)"
    else
        # M7: Eltern-Walk stillgelegt (Epoch = %ct HEAD wie r2) -> P-23 muss reissen (L2-01)
        sed 's/QUELLE="\$QUELLE^"; stufe=\$((stufe+1))/break/' "$CI_YML" > "$MUT/m7.yml"
        # M8: Epoch-Weiche entfernt (Byte-Vergleich auch bei veralteter Kopie) -> P-24 (c) muss reissen
        sed 's/if \[ -n "\$e289" \] && \[ "\$e289" = "\$SOURCE_DATE_EPOCH" \]; then/if true; then/' \
            "$CI_YML" > "$MUT/m8.yml"
        # M9: Byte-Urteil entfernt -> P-24 (b) muss reissen (L1-04)
        sed '/test -n "\$s288" && test "\$s288" = "\$s289"/,/andere Bytes (L1-04\/L2-01)"; exit 1; }/d' \
            "$CI_YML" > "$MUT/m9.yml"
        # M13 (r4): shallow-Pruefung entfernt (gekappte Historie faellt still auf %ct HEAD) -> P-23 (e) muss reissen
        sed 's/if \[ "\$shallow" = true \]; then/if false; then/' "$CI_YML" > "$MUT/m13.yml"
        # M14 (r4): Fullbanner-Vergleich entfernt (Byte-Urteil trotz fremder Toolchain) -> P-24 (e) muss reissen
        sed 's/if \[ "\$b288" != "\$b289" \]; then/if false; then/' "$CI_YML" > "$MUT/m14.yml"
        # M15 (r5): Ein-Elter-Regel entfernt (Merge mit PDF-nur-Diff gilt als Writeback) -> P-23 (g) muss reissen
        sed 's/\&\& ! git rev-parse -q --verify "\$QUELLE^2" >\/dev\/null; then/; then/' "$CI_YML" > "$MUT/m15.yml"
        # M16 (r5): letzter Treffer -> erster Treffer (eingebettetes Info-Dict gewinnt) -> P-24 (h) muss reissen
        sed 's/| tail -n1/| head -n1/' "$CI_YML" > "$MUT/m16.yml"
        # M17 (r5): Walk-Deckel-FEHLER entfernt (stiller Weiterlauf) -> P-23 (i) muss reissen (L4-04)
        sed 's/if \[ "\$stufe" -ge 8 \]; then/if false; then/' "$CI_YML" > "$MUT/m17.yml"
        # M18 (r5): sha256sum-FEHLER-Zweig entfernt (set -e ohne Marke) -> P-24 (i) muss reissen (L4-07)
        sed 's/ || { echo "FEHLER: sha256sum [^}]*}//' "$CI_YML" > "$MUT/m18.yml"
        # M19 (r5): CI_PROJECT_DIR-Gate entfernt -> P-23 (j) muss reissen (L4-08)
        sed '/CI_PROJECT_DIR leer (L4-08)/d' "$CI_YML" > "$MUT/m19.yml"
        # M20 (r5): '[skip ci]'-Bedingung entfernt (PDF-Commit von Hand gilt als Writeback) -> P-23 (h) muss reissen
        sed 's/\[ "\$bot" = ja \]/true/' "$CI_YML" > "$MUT/m20.yml"
        MUT_N=$((MUT_N+11))
        for m in m7 m8 m9 m13 m14 m15 m16 m17 m18 m19 m20; do
            if cmp -s "$CI_YML" "$MUT/$m.yml"; then
                echo "  [ABBRUCH] Mutante $m ist byte-gleich zur YAML -- das Muster greift nicht"; BISS_RC=2
            fi
        done
        biss_yml() { # $1 = Mutante (YAML), $2 = Fallfunktion, $3 = Kennung
            T_ALT="$T"; T="$T/biss_$1"; mkdir -p "$T"
            ( FEHL=0; CI_YML="$MUT/$1.yml"; "$2" "$SKRIPT" > "$T/protokoll.txt" 2>&1; exit "$FEHL" ); r=$?
            T="$T_ALT"
            if [ "$r" -gt 0 ]; then
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
    fi
fi

echo ""
echo "============================================================================="
echo "BILANZ: $GRUEN_N von $N_FAELLE Faellen gruen, $ROT_N rot${ROT_LISTE:+ (}$ROT_LISTE${ROT_LISTE:+ )}"
if [ "$SELBSTBISS" -eq 1 ]; then
    if [ "$BISS_RC" -eq 0 ]; then
        echo "        Selbstbiss: $MUT_N von $MUT_N Mutanten rot${ENTF_N:+, }$ENTF_N entfallen (YAML ohne Marker)"
    else
        echo "        Selbstbiss: NICHT bewiesen"
    fi
fi
if [ "$BISS_RC" -ne 0 ]; then echo "PROBE thesis_pdf_export: KEIN URTEIL (rc=2)"; exit 2; fi
if [ "$ROT_N" -eq 0 ]; then echo "PROBE thesis_pdf_export: GRUEN"; exit 0; fi
echo "PROBE thesis_pdf_export: ROT"; exit 1
