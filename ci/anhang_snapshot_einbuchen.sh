#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  E-18-SNAP -- EINBUCHUNG DES COMPILE-SCHNAPPSCHUSSES IN DAS SUPER-REPO (288)
#  ci/anhang_snapshot_einbuchen.sh                              (2026-08-11)
# =============================================================================
#
# DER BEFUND, DER DIESE DATEI ERZWUNGEN HAT (Dual-Review E-18-SNAP, Blocker 1):
#   Das Paket E-18-SNAP legte den Compile-Schnappschuss unter
#   $CI_PROJECT_DIR/measurement/thesis_compiles/<TS>-<kennung>/ ab -- und der Job
#   anhang:forward stagte diesen Pfad NICHT. Der Kern druckte "Schnappschuss
#   abgelegt", der Job wurde gruen, der Ordner starb mit dem Runner. WIRKSAMKEIT
#   NULL: ein Feature, das nichts hinterlaesst, ist nicht gebaut, sondern nur
#   geschrieben. Der Owner-KERN verlangt aber genau das Hinterlassen ("so laesst
#   sich ein compile nachvollziehen").
#
# WARUM DAS EINBUCHEN EINE DATEI IST UND KEIN YAML-BLOCK:
#   Dieselbe Begruendung, die ci/persist_sammler.sh aus dem persist-Job gehoben
#   hat, gilt hier woertlich: Logik in einem YAML-Block ist NICHT probefaehig,
#   und genau hier entscheidet die ANWESENHEIT von Dateien ueber den dauerhaften
#   Rueckschrieb. Der Vorgaenger-Entwurf trug diese Logik als YAML-Text in einem
#   Patch mit sich -- unpruefbar, und beim ersten Rebase nicht mehr anwendbar.
#   Der Beweis laeuft jetzt in ci/tests/anhang_snapshot_einbuchen_probe.sh an
#   einem echten git-Sandkasten und misst den COMMIT, nicht das Protokoll.
#
# WAS SIE ZUSICHERT (jede Zusage hat unten ihren Fall in der Probe):
#   Z1  Ein Beleg wird nur eingebucht, wenn er VOLLSTAENDIG ist: mindestens eine
#       nicht leere *.pdf + nicht leere compile-export.txt + QUELLSTAND.txt mit
#       der VOLLSTAENDIGEN Zeile 'thesis_commit_sha=<40-hex>'. Ein halber Ordner
#       bricht LAUT ab und es wird NICHTS gestagt -- im Repo saehe er
#       vollstaendig aus und belegte einen Compile, den es so nie gab.
#   Z2  DAS ORAKEL IST DER INDEX, NICHT DER RUECKGABEWERT VON 'git add'.
#       Nach dem Stagen wird jede Datei auf Platte gegen den Index nachgezaehlt.
#       Fehlt eine, ist das fail-loud -- nicht "0 Aenderungen". Das ist die
#       fuenfte Transportfalle (##20) auf diesen Pfad uebertragen: eine
#       .gitignore-Regel im super-Repo (heute schon: '*.log' ohne Gegenausnahme
#       fuer measurement/) macht 'git add' zu einer stillen Nulloperation, und
#       der Job bliebe gruen OHNE Beleg. V-8: DIESER Zustand laesst die Ausgabe
#       "Schnappschuss abgelegt" erscheinen, obwohl die Sache fehlt.
#   Z3  Halbstaende werden NIE eingebucht. Der Kern baut jeden Schnappschuss in
#       ".<name>.tmp" und zieht ihn erst nach bestandener Pruefung atomar auf
#       den Endnamen. Ueberlebt ein .tmp-Rest einen SIGKILL, gehoert er keinem
#       lebenden Lauf mehr: er wird gemeldet und entfernt, nie gestagt.
#   Z4  NICHTS WIRD GELOESCHT ausser eben diesen eigenen .tmp-Halbstaenden.
#       Kein 'git rm', kein 'git clean', kein --force, kein Anfassen bereits
#       eingebuchter Belege (Messdaten-Doktrin: additiv, nie ueberschreiben).
#   Z5  Kein Haken ohne Ausgabe: jede Stufe druckt ihren Nenner (V-1).
#
# WAS SIE AUSDRUECKLICH NICHT TUT (Grenze, damit niemand mehr hineinliest):
#   * Sie committet nicht und pusht nicht. Das tut der Job-Block, weil dort auch
#     die Credentials und der Gitlink-Bump liegen -- und weil beides in EINEN
#     Commit gehoert: der Gitlink sagt, WELCHER 289-Stand gilt, der Schnappschuss
#     belegt, WIE dessen PDF entstanden ist.
#   * Sie erzeugt keinen Schnappschuss. Das tut ci/anhang_forward_core.sh.
#   * Sie prueft die PDF nicht inhaltlich. Vollstaendigkeit ist Anwesenheit plus
#     Nicht-Leere plus die verankerte SHA-Zeile.
#
# AUFRUF:
#   sh ci/anhang_snapshot_einbuchen.sh ausstehend <snap_dir>
#       -> druckt auf STDOUT NUR die Zahl der ausstehenden Pfade (fuer den
#          Frueh-Abbruch des Jobs), das Protokoll auf STDERR. rc 0.
#   sh ci/anhang_snapshot_einbuchen.sh stagen <snap_dir>
#       -> Halbstaende raeumen, Vollstaendigkeit pruefen, stagen, Index-Orakel.
#          rc 0 = alles, was auf Platte liegt, liegt im Index (auch bei 0).
#          rc 1 = fail-loud (unvollstaendiger Beleg ODER Uebernahme-Luecke).
#
# <snap_dir> ist REPO-RELATIV und muss im Arbeitsbaum liegen; der Aufruf
# erfolgt aus der Wurzel des 288-Arbeitsbaums. Denselben Vertrag setzt der Kern
# ueber AF_SNAP_ROOT_STRICT durch -- zwei unabhaengige Instanzen derselben Regel,
# weil diese hier die LETZTE Wache vor dem Repo ist.
#
# ENV (nur fuer die Probe; im CI-Betrieb steht alles auf Default):
#   COMDARE_SNAP_GIT   git-Aufruf (Default: git)
#
# POSIX-sh (die CI ruft 'sh', das ist hier dash), ASCII-only, kein Python.
# Selbstcheck: die Zusagen Z1-Z3 sind je ein Fall der Probe MIT gewuerfeltem
# Koeder, und Z2 hat seine Gegenprobe (dieselbe Fixture ohne die Ignorier-Regel)
# -- ohne sie waere "immer rot" von "richtig rot" nicht zu unterscheiden.
# =============================================================================

set -eu

GIT="${COMDARE_SNAP_GIT:-git}"

usage() {
    echo "Aufruf: sh $0 {ausstehend|stagen} <snap_dir>" >&2
    exit 2
}

[ "$#" -eq 2 ] || usage
UNTERKOMMANDO="$1"
SNAP_DIR="$2"

case "$SNAP_DIR" in
    "" | /* | *..*)
        echo "FEHLER: <snap_dir>='$SNAP_DIR' muss repo-relativ und ohne '..' sein" >&2
        exit 2 ;;
esac

# --- Pfad-Vertrag: keine Leerzeichen. -----------------------------------------
# Die Namen kommen aus dem Kern und sind dort durch eine Namens-Wache gefiltert.
# Traegt trotzdem ein Pfad Leerraum, waere die zeilenweise Buchfuehrung unten
# still falsch -- also lieber hier laut abbrechen als spaeter leise danebenzaehlen.
snap_pfad_vertrag() {   # $1 = Pfad
    case "$1" in
        *[!\ ]*\ * | *\ *)
            echo "FEHLER: Pfad mit Leerraum ist im Schnappschuss-Baum nicht zugelassen: '$1'" >&2
            return 1 ;;
    esac
    return 0
}

# --- Die ausstehenden Pfade (Grundgesamtheit fuer JEDE Zahl unten) ------------
# 'git status --porcelain -uall' listet auch NEUE, noch unversionierte Dateien
# einzeln auf -- genau die sind der Normalfall eines frischen Schnappschusses.
snap_ausstehende_pfade() {
    [ -d "$SNAP_DIR" ] || return 0
    "$GIT" status --porcelain -uall -- "$SNAP_DIR" | cut -c4-
}

snap_belegordner() {    # alle Endnamen-Ordner (Punkt-Praefixe sind KEINE Endnamen)
    [ -d "$SNAP_DIR" ] || return 0
    for _d in "$SNAP_DIR"/*/; do
        [ -d "$_d" ] || continue
        printf '%s\n' "${_d%/}"
    done
}

snap_ordner_ausstehend() {   # nur die Ordner mit ausstehender Aenderung
    snap_belegordner | while IFS= read -r _o; do
        [ -n "$_o" ] || continue
        if [ -n "$("$GIT" status --porcelain -uall -- "$_o")" ]; then printf '%s\n' "$_o"; fi
    done
}

# --- Z5: der Nenner, IMMER gedruckt ------------------------------------------
snap_nenner() {         # schreibt nach STDERR (STDOUT gehoert der Zahl)
    _n_ordner=$(snap_belegordner | awk 'END{print NR+0}')
    _n_offen=$(snap_ordner_ausstehend | awk 'END{print NR+0}')
    _n_pfade=$(snap_ausstehende_pfade | awk 'END{print NR+0}')
    echo "   E-18-SNAP Einbuch-Nenner: wurzel='$SNAP_DIR' vorhanden=$([ -d "$SNAP_DIR" ] && echo ja || echo nein)" >&2
    echo "   E-18-SNAP Einbuch-Nenner: belegordner=$_n_ordner davon_ausstehend=$_n_offen" >&2
    echo "   E-18-SNAP Einbuch-Nenner: ausstehende_pfade=$_n_pfade" >&2
}

# =============================================================================
#  ausstehend -- die Zahl fuer den Frueh-Abbruch des Jobs
# =============================================================================
if [ "$UNTERKOMMANDO" = "ausstehend" ]; then
    snap_nenner
    snap_ausstehende_pfade | awk 'END{print NR+0}'
    exit 0
fi

[ "$UNTERKOMMANDO" = "stagen" ] || usage

echo "-- E-18-SNAP: Einbuchung in das super-Repo --"
snap_nenner

# =============================================================================
#  Z3 -- abgebrochene Halbstaende ('.<name>.tmp') raeumen, NIE stagen
# =============================================================================
# Sie tragen ein Punkt-Praefix, also sieht die Belegordner-Schleife sie nicht --
# 'git add -- "$SNAP_DIR"' saehe sie sehr wohl. Sie gehoeren keinem lebenden Lauf
# mehr (der trap des Kerns raeumt die eigenen ab); es ist kein Messdatum und kein
# Beleg, sondern ein abgebrochener Schreibvorgang.
n_rest=0
if [ -d "$SNAP_DIR" ]; then
    for rest in "$SNAP_DIR"/.*.tmp; do
        [ -d "$rest" ] || continue
        echo "WARNUNG: abgebrochener Schnappschuss-Halbstand -> wird NICHT gestagt: $rest" >&2
        find "$rest" -maxdepth 1 -type f | sed 's/^/  /' >&2
        rm -rf -- "$rest"
        n_rest=$((n_rest + 1))
    done
fi
echo "   Halbstaende (.tmp) entfernt: $n_rest"

# =============================================================================
#  Z1 -- VOLLSTAENDIGKEITS-WACHE ueber jeden AUSSTEHENDEN Belegordner
# =============================================================================
# Geprueft wird NUR, was ausstehend ist. Bereits eingebuchte Belege bleiben
# unangetastet (Z4/Messdaten-Doktrin) -- und ein alter Beleg, dessen Regelwerk
# sich seither geaendert hat, darf keinen neuen Lauf rot machen.
n_geprueft=0
n_unvollstaendig=0
snap_ordner_ausstehend > /tmp/.af_snap_offen.$$ 2>/dev/null || : > /tmp/.af_snap_offen.$$
while IFS= read -r snap; do
    [ -n "$snap" ] || continue
    snap_pfad_vertrag "$snap" || exit 1
    n_geprueft=$((n_geprueft + 1))
    fehlt=""
    if [ "$(find "$snap" -maxdepth 1 -type f -name '*.pdf' -size +0c | awk 'END{print NR+0}')" -lt 1 ]; then
        fehlt="$fehlt <haupt>.pdf(nicht-leer)"
    fi
    [ -s "$snap/compile-export.txt" ] || fehlt="$fehlt compile-export.txt"
    if [ ! -s "$snap/QUELLSTAND.txt" ]; then
        fehlt="$fehlt QUELLSTAND.txt"
    elif ! grep -q -E '^thesis_commit_sha=[0-9a-f]{40}$' "$snap/QUELLSTAND.txt"; then
        fehlt="$fehlt thesis_commit_sha=<40-hex>"
    fi
    if [ -n "$fehlt" ]; then
        n_unvollstaendig=$((n_unvollstaendig + 1))
        echo "FEHLER: unvollstaendiger Compile-Schnappschuss '$snap' -- es fehlt:$fehlt" >&2
        find "$snap" -maxdepth 1 -type f | sed 's/^/    /' >&2
    fi
done < /tmp/.af_snap_offen.$$
rm -f /tmp/.af_snap_offen.$$
echo "   Vollstaendigkeits-Wache: $n_geprueft ausstehende(r) Belegordner geprueft, $n_unvollstaendig unvollstaendig"
if [ "$n_unvollstaendig" -gt 0 ]; then
    echo "FEHLER: $n_unvollstaendig von $n_geprueft ausstehenden Belegordner(n) unvollstaendig." >&2
    echo "        NICHTS wird gestagt -- ein halber Beleg im Repo waere schlimmer als keiner:" >&2
    echo "        er saehe vollstaendig aus und belegte einen Compile, den es so nie gab." >&2
    exit 1
fi

# =============================================================================
#  Stagen + Z2 -- DAS ORAKEL IST DER INDEX
# =============================================================================
add_fehler=0
if [ -d "$SNAP_DIR" ]; then
    "$GIT" add -- "$SNAP_DIR" || add_fehler=1
else
    echo "   Schnappschuss-Wurzel '$SNAP_DIR' existiert nicht -> nichts zu stagen"
fi

auf_platte=0
im_index=0
nicht_uebernommen=0
FEHLLISTE="/tmp/.af_snap_fehlt.$$"; : > "$FEHLLISTE"
if [ -d "$SNAP_DIR" ]; then
    find "$SNAP_DIR" -type f -print > "/tmp/.af_snap_platte.$$"
    while IFS= read -r f; do
        [ -n "$f" ] || continue
        snap_pfad_vertrag "$f" || { rm -f "/tmp/.af_snap_platte.$$" "$FEHLLISTE"; exit 1; }
        auf_platte=$((auf_platte + 1))
        if "$GIT" ls-files --cached --error-unmatch -- "$f" >/dev/null 2>&1; then
            im_index=$((im_index + 1))
        else
            nicht_uebernommen=$((nicht_uebernommen + 1))
            printf '%s\n' "$f" >> "$FEHLLISTE"
        fi
    done < "/tmp/.af_snap_platte.$$"
    rm -f "/tmp/.af_snap_platte.$$"
fi
echo "   E-18-SNAP Uebernahme-Nenner: auf_platte=$auf_platte im_index=$im_index" \
     "nicht_uebernommen=$nicht_uebernommen git_add_fehler=$add_fehler"

if [ "$nicht_uebernommen" -gt 0 ] || [ "$add_fehler" -gt 0 ]; then
    echo "FEHLER: $nicht_uebernommen von $auf_platte Schnappschuss-Datei(en) sind NICHT im Index" >&2
    echo "        ('git add' meldete Fehlschlag=$add_fehler)." >&2
    sed 's/^/          /' "$FEHLLISTE" >&2
    echo "        Bekannte Ursache: eine .gitignore-Regel des super-Repos. Sie ist hier kein" >&2
    echo "        Randfall -- '*.log' steht dort ohne Gegenausnahme fuer measurement/, und" >&2
    echo "        genau deshalb heisst der latex-compile-export compile-export.txt." >&2
    echo "        Das ist KEIN 'nichts zu tun': der Beleg waere still verloren und der Job" >&2
    echo "        trotzdem gruen. Abbruch (fail-loud)." >&2
    rm -f "$FEHLLISTE"
    exit 1
fi
rm -f "$FEHLLISTE"

gestagt=$("$GIT" diff --cached --name-only -- "$SNAP_DIR" | awk 'END{print NR+0}')
echo "   gestagte Schnappschuss-Datei(en): $gestagt"
if [ "$gestagt" -gt 0 ]; then "$GIT" diff --cached --name-only -- "$SNAP_DIR" | sed 's/^/     /'; fi
echo "=== E-18-SNAP eingebucht: $gestagt Datei(en) gestagt, $im_index von $auf_platte im Index ==="
exit 0
