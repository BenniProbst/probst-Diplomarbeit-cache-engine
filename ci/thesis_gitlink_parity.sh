#!/bin/sh
# shellcheck shell=sh
# =============================================================================
# THESIS-GITLINK-PARITAET -- die beiden Einbindungen DESSELBEN Thesis-Repos
# muessen auf DENSELBEN Commit zeigen.                            (2026-08-06)
# =============================================================================
# ABGELOEST am 2026-08-09 durch Code/ci_wachen (C++ + CMake).
#   Nachfolger-Bibliothek: Code/ci_wachen/src/gitlink_parity.cpp
#   Nachfolger-Binary:     ci_thesis_gitlink_wache (OUTPUT_NAME ci-thesis-gitlink-wache)
#   Nachfolger-Test:       Code/tests/unit/test_ci_wache_gitlink_parity.cpp
#
# GRUND (Owner-KERN 09.08.): "SKRIPTE SAGEN GAR NICHTS." Hier ist der Schaden
# besonders greifbar: "ein Gitlink fehlt" und "die Zeiger divergieren" liefern
# BEIDE rc=1. Ein Mutant ohne den fail-closed-Zweig fiel deshalb eine Handvoll
# Zeilen spaeter im Divergenz-Zweig, und nur EIN einziger Eingang (beide fehlen)
# konnte ihn toeten. Im Nachfolger sind es zwei WERTE (ParityRissArt::GitlinkFehlt
# vs. ::Divergenz) -- die Kollision ist nicht besser getestet, sie ist nicht mehr
# formulierbar. Der CI-Exit-Vertrag 0/1/2 ist unveraendert.
#
# DIESE DATEI BLEIBT IM BAUM (Bestand und Doku werden nie geloescht, nur abgeloest).
# Ob sie weiterhin in verify:submodules und anhang:forward laeuft, entscheidet der
# Lead nach der Abnahme.
# =============================================================================
# DER BEFUND, GEGEN DEN DIESE DATEI GEBAUT IST (selbst nachgemessen, super
# 7780c6af):
#
#   .gitmodules bindet ../20260931-overleaf-diplomarbeit.git ZWEIMAL ein:
#       thesis/diplomarbeit                          (Z. 45-50, LEBEND)
#       Code/external/20260931-overleaf-diplomarbeit (Z. 51-56, TOT)
#
#   In .gitlab-ci.yml kommt der erste Pfad 10 Mal vor (Z. 102 181 337 361 612
#   617 953 1067 1154 1163), der zweite NULL Mal (gemessen:
#   grep -c "Code/external/20260931" .gitlab-ci.yml -> 0). Der
#   Rueckschrieb-Job anhang:forward bumpte bis zu diesem Paket nur den ersten
#   Zeiger (Z. 1163, git update-index). FOLGE: sobald der Kanal scharf ist,
#   ERZEUGT die CI die Divergenz bei jedem Rueckschrieb selbst und still --
#   gefangen haette sie erst die nachgelagerte git-submodule-status-Wache in
#   verify:submodules, also NACHDEM sie entstanden ist.
#
# DIESE DATEI IST DIE STRUKTUR ZUR MOMENTAUFNAHME. Sie wird an ZWEI Stellen
# gerufen, damit dieselbe Behauptung nur EINMAL formuliert ist:
#   * verify:submodules  -- Praevention (Quelle head): faellt der Commit rot,
#                           bevor irgendetwas darauf baut.
#   * anhang:forward     -- Nachbedingung (Quelle index, mit --erwartet):
#                           beweist NACH dem update-index, dass wirklich BEIDE
#                           Gitlinks auf dem neuen 289-Commit stehen.
#
# FAIL-CLOSED IST DER KERN, NICHT DIE KOSMETIK:
#   Ein FEHLENDER Pfad ist ein FEHLER, kein Freifahrtschein. Waere er einer,
#   koennte jede Umbenennung/Entfernung eines der beiden Gitlinks die Wache
#   still entwaffnen -- genau die Klasse "stille Null", gegen die hier gebaut
#   wird. Es gibt deshalb KEIN `|| true` und KEINEN Zweig, der bei leerem
#   Ergebnis mit 0 endet.
#
# KEIN grep IN DER KERNLOGIK: die Auswertung laeuft ueber `git ls-tree` bzw.
# `git ls-files --stage` + awk-Feldzugriff. Die bekannte ugrep/GNU-BRE-Falle um
# '^\+\+\+' (stille 0 auf beiden Engines) kann hier strukturell nicht
# auftreten. git-Fehler sind fatal (Exit 2), nie eine stille 0.
#
# EXIT-CODES:
#   0  beide Gitlinks vorhanden und gleich (und, mit --erwartet, gleich dem SHA)
#   1  Divergenz ODER fehlender Gitlink-Pfad  (= der rote Biss)
#   2  Aufruf-/Werkzeugfehler (git fehlt, kein Repo, unbekannte Option)
#
# NICHT-ZIEL: diese Datei ENTFERNT die Doppelung nicht. Ob die tote Einbindung
# entfallen darf, ist Owner-Entscheid (Loeschung = GO). Bis dahin wird sie
# gleichgehalten, nicht geloescht.
#
# Selbstcheck: diese Datei ist selbst im Scope der Diff-Hygiene-Wache
# (scripts/ci_diff_ascii_width_guard.sh kennt .sh) -- 7-Bit-ASCII, <= 120 Byte
# je Zeile.
# =============================================================================

set -eu

TGP_LEBEND="thesis/diplomarbeit"
TGP_TOT="Code/external/20260931-overleaf-diplomarbeit"

_tgp_quelle="head"
_tgp_erwartet=""

_tgp_usage() {
    echo "Aufruf: ci/thesis_gitlink_parity.sh [--quelle head|index] [--erwartet <sha40>]" >&2
    echo "  --quelle head   (Vorgabe) liest die Gitlinks aus dem HEAD-Tree" >&2
    echo "  --quelle index  liest die Gitlinks aus dem Staging-Index (nach update-index)" >&2
    echo "  --erwartet SHA  verlangt zusaetzlich, dass beide auf genau SHA stehen" >&2
}

while [ $# -gt 0 ]; do
    case "$1" in
        --quelle)
            [ $# -ge 2 ] || { echo "FEHLER: --quelle ohne Wert" >&2; exit 2; }
            _tgp_quelle="$2"; shift 2 ;;
        --erwartet)
            [ $# -ge 2 ] || { echo "FEHLER: --erwartet ohne Wert" >&2; exit 2; }
            _tgp_erwartet="$2"; shift 2 ;;
        -h|--hilfe|--help)
            _tgp_usage; exit 0 ;;
        *)
            echo "FEHLER: unbekannte Option '$1'" >&2; _tgp_usage; exit 2 ;;
    esac
done

case "$_tgp_quelle" in
    head|index) : ;;
    *) echo "FEHLER: --quelle muss 'head' oder 'index' sein, war '$_tgp_quelle'" >&2; exit 2 ;;
esac

command -v git >/dev/null 2>&1 || { echo "FEHLER: git nicht gefunden" >&2; exit 2; }
command -v awk >/dev/null 2>&1 || { echo "FEHLER: awk nicht gefunden" >&2; exit 2; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "FEHLER: kein git-Repository" >&2; exit 2; }

# Einen Gitlink lesen. Leere Ausgabe = Pfad nicht vorhanden ODER kein Gitlink
# (Modus != 160000) -- beides behandelt der Aufrufer als FEHLER (fail-closed).
# git-Fehler-Exits sind hier fatal: `set -e` greift, weil kein `|| true` steht.
_tgp_lies() {
    _tgp_pfad="$1"
    if [ "$_tgp_quelle" = "head" ]; then
        # ls-tree: <mode> <type> <object>\t<path>
        git ls-tree HEAD -- "$_tgp_pfad" \
            | awk '$1 == "160000" && $2 == "commit" { print $3 }'
    else
        # ls-files --stage: <mode> <object> <stage>\t<path>
        git ls-files --stage -- "$_tgp_pfad" \
            | awk '$1 == "160000" { print $2 }'
    fi
}

_tgp_a="$(_tgp_lies "$TGP_LEBEND")"
_tgp_b="$(_tgp_lies "$TGP_TOT")"

_tgp_fehlt=0
if [ -z "$_tgp_a" ]; then
    echo "FEHLER (Thesis-Doppelbindung): Gitlink FEHLT in Quelle '$_tgp_quelle': $TGP_LEBEND" >&2
    _tgp_fehlt=1
fi
if [ -z "$_tgp_b" ]; then
    echo "FEHLER (Thesis-Doppelbindung): Gitlink FEHLT in Quelle '$_tgp_quelle': $TGP_TOT" >&2
    _tgp_fehlt=1
fi
if [ "$_tgp_fehlt" -ne 0 ]; then
    echo "  fail-closed: ein fehlender Gitlink-Pfad ist ein FEHLER, kein Freifahrtschein." >&2
    echo "  Beide Einbindungen stehen in .gitmodules (thesis/diplomarbeit + Code/external/...)." >&2
    exit 1
fi

if [ "$_tgp_a" != "$_tgp_b" ]; then
    echo "FEHLER (Thesis-Doppelbindung): die beiden Gitlinks DESSELBEN Repos divergieren:" >&2
    echo "  $TGP_LEBEND = $_tgp_a" >&2
    echo "  $TGP_TOT = $_tgp_b" >&2
    echo "  -> beide Zeiger IMMER GEMEINSAM setzen (Begruendung im .gitmodules-Kopf)." >&2
    exit 1
fi

if [ -n "$_tgp_erwartet" ] && [ "$_tgp_a" != "$_tgp_erwartet" ]; then
    echo "FEHLER (Thesis-Doppelbindung): beide Gitlinks stehen auf $_tgp_a," >&2
    echo "  erwartet war aber $_tgp_erwartet (Quelle '$_tgp_quelle')." >&2
    exit 1
fi

echo "Thesis-Gitlink-Paritaet OK (Quelle '$_tgp_quelle'): beide Zeiger auf $_tgp_a"
exit 0
