# shellcheck shell=sh
# =============================================================================
# probst-diplomarbeit-cache-engine (SUPER) -- DIFF-HYGIENE-WACHE:
# ASCII + Spaltenbreite                                            (2026-08-06)
# =============================================================================
# BEHAUPTUNG, DIE HIER GEPRUEFT WIRD (die Invariante):
#
#     Jede HINZUGEFUEGTE Zeile in super-eigenem, selbst verfasstem Code ist
#     7-Bit-ASCII (Ausnahme: das Paragraf-Zeichen, per Doktrin erlaubt) und
#     nicht laenger als 120 Byte (ColumnLimit aus der super-eigenen
#     .clang-format).
#
# -----------------------------------------------------------------------------
# WARUM ES DIESE DATEI IM SUPER GIBT (Befund 2026-08-06, selbst nachgemessen)
# -----------------------------------------------------------------------------
# Das super-Repo hatte KEINE eigene Kopie dieser Wache. Nachgemessen mit
#
#     git ls-files | grep -vE '^Code/external/' | grep -iE 'ascii|width|guard|wache'
#
# -- 0 Treffer, die ein Pruefwerkzeug waeren (nur C++-Quellen mit "guard" im
# Namen, LaTeX-Fixtures und archivierte Gate-Logs). Ein Verzeichnis scripts/
# existierte im super ueberhaupt nicht.
#
# Die super-Pakete dieser Session (graph, b14-super) wurden folglich mit dem
# Skript des FREMDEN Repos geprueft:
#     Code/external/comdare-cache-engine/scripts/ci_diff_ascii_width_guard.sh
# Das ist die Vorlage dieser Datei. Ein zweiter, unabhaengiger Beleg fuer die
# Luecke steht seit demselben Tag im super-eigenen Code: der Kommentar in
# Code/tests/CMakeLists.txt verweist woertlich auf
# "(scripts/ci_diff_ascii_width_guard.sh)" -- auf einen Pfad, den es im super
# nicht gab. Der Verweis zeigte ins Leere; diese Datei loest ihn ein.
#
# -----------------------------------------------------------------------------
# WARUM SPIEGELN UND NICHT ZENTRAL AUS DEM ce ZIEHEN
# -----------------------------------------------------------------------------
# Der super bindet das ce als Submodul unter Code/external/comdare-cache-engine
# ein; ein zentraler Bezug waere technisch also moeglich. Er ist hier trotzdem
# falsch, aus drei Gruenden am Objekt:
#
#  (1) TECHNISCH UNMOEGLICH IN GENAU DER STUFE, IN DER DIE WACHE LAUFEN MUSS.
#      Alle Lint-Jobs des super setzen GIT_SUBMODULE_STRATEGY: none (nachgelesen
#      in .gitlab-ci.yml, Jobs lint:secrets/lint:format/lint:static; der Grund
#      steht im Kopf der Datei: "Lint scannt NUR super-eigenen Code"). In der
#      Stufe lint ist Code/external/comdare-cache-engine ein LEERES
#      Verzeichnis. Eine Wache, die von dort startet, faende ihr eigenes Skript
#      nicht -- und der wahrscheinlichste Ausgang eines nicht gefundenen
#      Skripts ist ein uebersprungener Schritt: exakt die stille Null, gegen
#      die diese Wache gebaut ist. Ein zentraler Bezug zwaenge den super, das
#      Submodul in der Lint-Stufe auszuchecken, nur um seinen eigenen Diff zu
#      pruefen.
#
#  (2) DIE QUALITAETSREGEL DES SUPER HINGE AM GITLINK EINES FREMDEN REPOS.
#      Welche Fassung der Wache liefe, entschiede der Submodul-Zeiger -- und
#      der kann nach einem Bump RUECKWAERTS zeigen. Die Hygiene-Regel des super
#      wuerde dann still auf einen aelteren Stand zurueckfallen, ohne dass im
#      super ein einziger Commit dazu existiert. Eine Wache, deren Strenge sich
#      unbemerkt aendern kann, ist keine Wache.
#
#  (3) DER SCOPE IST NICHT DERSELBE -- die Kopie ist kein blinder Klon.
#      Nachgezaehlt ueber die super-eigene Dateiflaeche (git ls-files ohne
#      Code/external, Forschungsarbeiten, docs, thesis, Code/build*):
#      37 .cpp, 22 .hpp, 7 .cmake, 5 .sh. Die ce-Vorlage kennt .sh NICHT. Im
#      super sind Shell-Skripte selbst verfasster Code (ci/anhang_forward_core.sh
#      und diese Datei selbst) und gehoeren in den Scope; sie sind hier
#      ergaenzt. Umgekehrt bleiben .tex und .md bewusst draussen (deutsche
#      Prosa traegt per Sprachdoktrin korrekte Umlaute), und .yml ebenfalls:
#      .gitlab-ci.yml traegt HEUTE schon Geviertstriche in ihren Kommentaren --
#      sie in den Scope zu nehmen hiesse, die Wache am Tag ihrer Einfuehrung
#      rot zu gebaeren.
#
# Der Preis der Spiegelung ist Drift zwischen zwei Kopien. Er ist bezahlbar und
# bewusst bezahlt: die INVARIANTE selbst (ASCII + 120 Spalten) steht ohnehin
# doppelt -- in .clang-format hier und in .clang-format des ce, mit identischem
# ColumnLimit: 120. Die Wache spiegelt damit nur, was die Konfiguration bereits
# spiegelt. Ein Auseinanderlaufen der beiden Skripte ist ausserdem sichtbar
# (zwei Dateien, ein diff), waehrend das Zurueckfallen unter (2) unsichtbar
# waere.
#
# -----------------------------------------------------------------------------
# WARUM DIE PRUEFUNG SO GEBAUT IST (der Kern, nicht die Kosmetik)
# -----------------------------------------------------------------------------
# Das bisherige Verfahren war kein Werkzeug, sondern eine von Hand getippte
# Prozedur:
#
#     git diff -U0 -- "$f" | grep '^+' | grep -v '^\+\+\+' | grep -P '[^\x00-\x7F]'
#
# Sie ist auf BEIDEN grep-Engines kaputt, ueber zwei verschiedene Wege:
#   * Unter ugrep bricht das mittlere Glied `grep -v '^\+\+\+'` mit einem
#     Syntaxfehler ab (Exit 2). Ohne pipefail bestimmt die LETZTE Stufe den
#     Gesamt-Exit -- die sieht leere Eingabe und meldet "kein Treffer"
#     (Exit 1), ununterscheidbar von einem sauberen Befund.
#   * Unter echtem GNU grep gibt es keinen Fehler, aber ein stilleres Problem:
#     `\+` ist in GNU-BRE die Erweiterung "ein-oder-mehr", kein literales Plus.
#     `^\+\+\+` matcht deshalb JEDE Zeile, die mit einem-oder-mehreren '+'
#     beginnt -- die Stufe wirft "+abc", also eine ganz normale Zusatzzeile,
#     faelschlich mit weg.
#   * Selbst pipefail truege hier nicht: die rechte Stufe endet bei leerer
#     Eingabe selbst harmlos mit Exit 1, und genau dieser Code gewinnt.
#
# Diese Wache kann die Falle strukturell nicht wiederholen:
#   * Sie verwendet KEIN grep und KEIN sed in der Kern-Logik. Die gesamte
#     Diff-Verarbeitung laeuft in EINEM awk-Programm mit einem STRUKTURELLEN
#     Zustand (Datei-Kopf vor dem ersten '@@' vs. Hunk-Inhalt danach) statt
#     einer Regex-Vermutung ueber die '+++'-Kopfzeile. Eine hinzugefuegte
#     Zeile, deren TEXT mit '+++' beginnt, wird korrekt als Inhalt erkannt.
#   * Die Nicht-ASCII-Erkennung ist byteweise (LC_ALL=C, 128..255 als
#     vorberechnete Menge), nicht ueber eine Regex-Zeichenklasse.
#   * Statt PIPESTATUS/pipefail (beides keine POSIX-sh-Mittel; dash als
#     /bin/sh kennt keins von beiden) schreibt jede Stufe in eine Datei und
#     wird EINZELN per $? geprueft.
#   * Fehlt ein Werkzeug (awk, git, mktemp) oder liefert git selbst einen
#     Fehler-Exit, ist das FATAL (Exit 2) -- nie eine stille Null.
#
# -----------------------------------------------------------------------------
# WARUM DER BEREICH AUS merge-base KOMMT UND NIE AUS EINEM ZWISCHEN-SHA
# -----------------------------------------------------------------------------
# Ein uebergebener Zwischen-SHA (typisch: CI_COMMIT_BEFORE_SHA, oder ein von
# Hand kopierter "Stand von vorhin") schneidet den Bereich zu eng. In dieser
# Session hat genau das 61 Prozent einer Aenderung verborgen: geprueft wurde
# der letzte Schritt, gemeldet wurde die ganze Aenderung.
#
# Der Modus --seit-basis nimmt deshalb KEINEN Bereich entgegen, sondern
# BESTIMMT ihn: er loest eine BRANCH-Referenz auf, ruft `git merge-base`
# selbst, und diffed merge-base..HEAD. Ein blanker SHA wird aktiv ABGELEHNT
# (Exit 2) -- `git rev-parse --symbolic-full-name` liefert fuer ihn eine leere
# Ausgabe, und nur eine Antwort, die mit refs/ beginnt, wird akzeptiert. Die
# Wache druckt zusaetzlich die BREITE des Bereichs (Anzahl Commits und
# beruehrter Dateien), damit ein zu eng geratener Bereich sichtbar ist statt
# nur wirksam.
#
# -----------------------------------------------------------------------------
# GRENZE, EHRLICH BENANNT (was diese Wache NICHT faengt)
# -----------------------------------------------------------------------------
#   * Sie prueft im Diff-Modus nur den DIFF-BEREICH, nicht den Gesamtbestand.
#     Fuer den Gesamtbestand gibt es --bestand (siehe AUFRUF).
#   * Alt-Zeilen, die nur durch reines Whitespace-Reformatieren zu "+"-Zeilen
#     werden, zaehlt sie mit (kein `git diff -w`); das ist Aufrufer-Sache.
#   * Ausgenommene Dateien (Prosa, YAML, Daten) werden trotzdem GEZAEHLT und
#     namentlich gemeldet, damit "ausserhalb des Scopes" nicht zu einer
#     zweiten stillen Null wird.
#   * Spaltenbreite wird BYTEWEISE gemessen (LC_ALL=C length()), nicht als
#     Unicode-Codepoint-Breite -- fuer den ASCII-Regelbereich dieser Wache ist
#     das identisch; nur eine bereits ASCII-verletzende Zeile koennte dadurch
#     geringfuegig zu lang gezaehlt werden (konservativ, nie zu kurz).
#   * Im Modus --stdin kann sie nicht erkennen, ob eine leere Eingabe "keine
#     Aenderungen" oder einen abgebrochenen Vorschritt bedeutet -- das muss
#     der Aufrufer sicherstellen. In allen anderen Modi fuehrt DIESES Skript
#     git selbst aus und prueft dessen Exit-Code selbst.
#
# -----------------------------------------------------------------------------
# WAS DIE HEUTIGE super-CI OHNE DIESE WACHE ABDECKT (nachgemessen, nicht
# vermutet)
# -----------------------------------------------------------------------------
# Die super-CI faehrt drei Lint-Jobs: lint:secrets (gitleaks), lint:format
# (clang-format --dry-run -Werror) und lint:static (cppcheck). Keiner davon
# prueft ASCII. lint:format deckt die Breite nur TEILWEISE ab, und die Luecke
# ist gemessen (clang-format 22.1.8 gegen die super-eigene .clang-format):
#   * eine 140 Byte lange KOMMENTARZEILE mit Umlauten  -> Exit 0 (durch),
#     weil die super-.clang-format ReflowComments: false setzt;
#   * ein String-Literal mit Umlauten                   -> Exit 0 (durch).
# Dazu kommt der Datei-Scope: lint:format sieht nur
# \.(c|cc|cxx|cpp|h|hh|hxx|hpp)$ -- also weder .cmake noch CMakeLists.txt noch
# .sh. Genau der Kommentar, der oben ins Leere zeigte, steht in einer
# CMakeLists.txt.
#
# -----------------------------------------------------------------------------
# AUFRUF
# -----------------------------------------------------------------------------
#   sh scripts/ci_diff_ascii_width_guard.sh
#       Arbeitsverzeichnis gegen HEAD (die manuelle Vor-Paketmeldung-Pruefung).
#   sh scripts/ci_diff_ascii_width_guard.sh --seit-basis [<branch-ref>]
#       CI-Modus. Bestimmt den Bereich selbst per `git merge-base <ref> HEAD`.
#       Ohne <branch-ref>: $COMDARE_GUARD_BASIS_REF, sonst origin/main, main,
#       origin/development, development -- der erste, der aufloest.
#       Ein blanker SHA statt einer Branch-Referenz ist ein FEHLER (Exit 2).
#   sh scripts/ci_diff_ascii_width_guard.sh --bereich <basis> [<spitze>]
#       DERSELBE kumulative Modus, aber mit BEIDEN Enden vom Aufrufer benannt
#       (2026-08-10, Paket r7-wachen-divergenz). Kein Bare-SHA-Verbot -- wer
#       zwei Enden ausspricht, meint sie; ein SHA-Paar misst sich in einem Jahr
#       noch gleich. Ein Bereich mit NULL Commits ist hier ABBRUCH, nicht GRUEN.
#       Der Name kommt aus der ce-Fassung und ist hier gebaut, damit derselbe
#       Aufruf in beiden Repos dasselbe tut statt in einem abzubrechen.
#   sh scripts/ci_diff_ascii_width_guard.sh --bestand
#       Kein Diff: prueft den GESAMTEN versionierten Bestand im Scope.
#   sh scripts/ci_diff_ascii_width_guard.sh --stdin < fertiger-diff.txt
#       Liest einen bereits erzeugten Unified-Diff von stdin.
#
#   JEDES ANDERE --wort ist ein FEHLER (Exit 2). Das war hier von Anfang an so
#   und ist der einzige Grund, warum die Optionsnamen der ce-Fassung in DIESER
#   nie unbemerkt durchfielen -- s. ci/wachen_paritaet.sh.
#
# EXIT:  0 = sauber (Zusammenfassung mit Nenner wird IMMER gedruckt)
#        1 = mindestens ein Verstoss (Nicht-ASCII und/oder >120 Spalten)
#        2 = Bedienung/Umgebung/undeutbares Hunk-Format -- NIE eine stille 0
#
# KEIN Python (Buildchain-Kanon), POSIX sh + awk, ASCII-only.
# Selbstcheck: diese Datei ist selbst im Scope (.sh) und haelt ihre eigene
# Invariante -- die Wache prueft sich bei jedem Lauf mit.
# =============================================================================

set -u
export LC_ALL=C

CE_SPALTEN_MAX=120

ce_abbruch() {
    echo ""
    echo "DIFF-HYGIENE-WACHE: ABBRUCH -- $1" >&2
    exit 2
}

command -v awk >/dev/null 2>&1 || ce_abbruch "awk ist nicht im PATH."
command -v mktemp >/dev/null 2>&1 || ce_abbruch "mktemp ist nicht im PATH."
command -v git >/dev/null 2>&1 || ce_abbruch "git ist nicht im PATH."

_ce_modus="arbeitsbaum"
_ce_basis_auto=1
case "${1:-}" in
    --stdin)      _ce_modus="stdin";      shift ;;
    --seit-basis) _ce_modus="seit-basis"; shift ;;
    # --bereich IST DERSELBE MODUS mit frei gewaehlten Enden (Paket
    # r7-wachen-divergenz, 10.08.2026). Der Name kommt aus der ce-Fassung, wo er
    # der einzige kumulative Modus ist. Bis heute brach er hier ab
    # ("Unbekannte Option '--bereich'") -- sauber, aber eben ein Abbruch: wer
    # zwischen den Repos wechselte, scheiterte am WORT, nicht an der Sache.
    # Der Unterschied zu --seit-basis ist genau einer: --seit-basis bestimmt die
    # Basis selbst und verbietet einen blanken SHA, --bereich nimmt beide Enden
    # ausdruecklich entgegen und erlaubt SHAs (ein beidseitig gepinnter Bereich
    # misst sich in einem Jahr noch gleich).
    --bereich)    _ce_modus="seit-basis"; _ce_basis_auto=0; shift ;;
    --bestand)    _ce_modus="bestand";    shift ;;
    --)           : ;;
    --*)          ce_abbruch "Unbekannte Option '$1'. Erlaubt: --bereich, --bestand, --seit-basis, --stdin." ;;
esac

_ce_script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd) \
    || ce_abbruch "Skript-Verzeichnis nicht aufloesbar."
_ce_repo_root=$(CDPATH= cd -- "$_ce_script_dir/.." && pwd) \
    || ce_abbruch "Repo-Wurzel nicht aufloesbar."

_ce_diff_datei="$(mktemp "${TMPDIR:-/tmp}/super_diff_guard.XXXXXX")" \
    || ce_abbruch "mktemp fuer die Diff-Datei fehlgeschlagen."
_ce_awk_out="$(mktemp "${TMPDIR:-/tmp}/super_diff_guard_out.XXXXXX")" \
    || ce_abbruch "mktemp fuer die Ausgabedatei fehlgeschlagen."
_ce_dateiliste="$(mktemp "${TMPDIR:-/tmp}/super_diff_guard_files.XXXXXX")" \
    || ce_abbruch "mktemp fuer die Dateiliste fehlgeschlagen."
ce_aufraeumen() {
    rm -f "$_ce_diff_datei" "${_ce_diff_datei}.err" \
          "$_ce_awk_out" "${_ce_awk_out}.meta" "${_ce_awk_out}.skipped" \
          "$_ce_dateiliste"
}
trap ce_aufraeumen EXIT INT TERM HUP

echo "============================================================================="
echo " DIFF-HYGIENE-WACHE super: ASCII + Spaltenbreite (max ${CE_SPALTEN_MAX} Byte)"
echo " scripts/ci_diff_ascii_width_guard.sh -- Repo: ${_ce_repo_root}"
echo "============================================================================="

# ---------------------------------------------------------------------------
# Eingabe je Modus beschaffen. Jede git-Stufe wird EINZELN per $? geprueft.
# ---------------------------------------------------------------------------
_ce_awk_modus="diff"

case "$_ce_modus" in
stdin)
    echo ""
    echo "MODUS: --stdin (fertiger Diff; der Aufrufer traegt die Verantwortung"
    echo "fuer den Exit-Code seiner EIGENEN vorgelagerten Stufe)."
    cat > "$_ce_diff_datei"
    _ce_rc=$?
    [ "$_ce_rc" -eq 0 ] || ce_abbruch "Lesen von stdin fehlgeschlagen (rc=${_ce_rc})."
    ;;

arbeitsbaum)
    echo ""
    echo "MODUS: Arbeitsbaum gegen HEAD (git diff -U0 HEAD $*)"
    git -C "$_ce_repo_root" diff -U0 --no-color --no-ext-diff HEAD "$@" \
        > "$_ce_diff_datei" 2>"${_ce_diff_datei}.err"
    _ce_rc=$?
    if [ "$_ce_rc" -ne 0 ]; then
        echo "" >&2; echo "git diff stderr:" >&2; cat "${_ce_diff_datei}.err" >&2
        ce_abbruch "git diff selbst ist fehlgeschlagen (rc=${_ce_rc}) -- KEINE stille Null."
    fi
    ;;

seit-basis)
    _ce_spitze="HEAD"
    _ce_modus_wort="--seit-basis"
    if [ "$_ce_basis_auto" -eq 0 ]; then
        # --bereich: BEIDE Enden kommen vom Aufrufer. Die Basis ist Pflicht, die
        # Spitze hat HEAD als Vorgabe -- gleiche Form wie in der ce-Fassung,
        # damit derselbe Aufruf in beiden Repos dasselbe tut.
        _ce_modus_wort="--bereich"
        [ "$#" -ge 1 ] || ce_abbruch "--bereich braucht eine BASIS (z.B. 'origin/main'), \
optional eine SPITZE (Default HEAD). Aufruf: --bereich <basis> [<spitze>]"
        _ce_basis="$1"
        shift
        if [ "$#" -ge 1 ]; then
            _ce_spitze="$1"
            shift
        fi
    else
        _ce_basis="${1:-}"
        if [ -n "$_ce_basis" ]; then
            shift
        else
            for _ce_kand in "${COMDARE_GUARD_BASIS_REF:-}" origin/main main origin/development development; do
                [ -n "$_ce_kand" ] || continue
                if git -C "$_ce_repo_root" rev-parse --verify --quiet "${_ce_kand}^{commit}" >/dev/null 2>&1; then
                    _ce_basis="$_ce_kand"
                    break
                fi
            done
        fi
    fi
    [ -n "$_ce_basis" ] || ce_abbruch "$(
        echo "Keine Basis-Referenz aufloesbar. Probiert wurden:"
        echo "  \$COMDARE_GUARD_BASIS_REF, origin/main, main, origin/development, development."
        echo "In der CI ist die haeufigste Ursache ein flacher Klon -- GIT_DEPTH: 0 setzen."
        echo "KEINE stille Null."
    )"

    # BARE-SHA-VERBOT: nur eine echte Referenz wird akzeptiert. Fuer einen
    # blanken SHA liefert --symbolic-full-name eine LEERE Ausgabe (rc=0!),
    # deshalb wird auf refs/ geprueft und nicht auf den Exit-Code.
    # NUR FUER --seit-basis: dort bestimmt die Wache den Bereich selbst, und ein
    # untergeschobener Zwischen-SHA waere genau der Fehler, gegen den der Modus
    # gebaut ist. Bei --bereich hat der Aufrufer BEIDE Enden ausgesprochen; ein
    # SHA-Paar ist dort der dokumentierte, beidseitig gepinnte Aufrufweg.
    _ce_sym=$(git -C "$_ce_repo_root" rev-parse --symbolic-full-name "$_ce_basis" 2>/dev/null)
    if [ "$_ce_basis_auto" -eq 1 ]; then
        case "$_ce_sym" in
            refs/*) : ;;
            *) ce_abbruch "$(
                   echo "Basis '${_ce_basis}' ist keine Branch-Referenz, sondern ein Zwischen-SHA."
                   echo "Der Bereich MUSS aus git merge-base gegen eine Branch-Referenz kommen:"
                   echo "ein zu eng geschnittener Bereich hat in dieser Session 61 Prozent einer"
                   echo "Aenderung verborgen. Wer zwei Enden bewusst pinnen will: --bereich."
               )" ;;
        esac
    fi

    _ce_spitze_sha=$(git -C "$_ce_repo_root" rev-parse --verify --quiet "${_ce_spitze}^{commit}") \
        || ce_abbruch "SPITZE '${_ce_spitze}' ist in diesem Repo nicht aufloesbar (nicht geholt, \
flacher Klon oder Tippfehler). Fail-closed: das ist ABBRUCH, keine stille Null."

    _ce_mb=$(git -C "$_ce_repo_root" merge-base "$_ce_basis" "$_ce_spitze_sha" 2>/dev/null)
    _ce_rc=$?
    [ "$_ce_rc" -eq 0 ] && [ -n "$_ce_mb" ] || ce_abbruch "$(
        echo "git merge-base ${_ce_basis} ${_ce_spitze} fehlgeschlagen (rc=${_ce_rc})."
        echo "Bei flachem Klon GIT_DEPTH: 0 setzen. KEINE stille Null."
    )"

    _ce_ncommits=$(git -C "$_ce_repo_root" rev-list --count "${_ce_mb}..${_ce_spitze_sha}" 2>/dev/null) \
        || ce_abbruch "git rev-list --count fehlgeschlagen."

    echo ""
    if [ "$_ce_basis_auto" -eq 1 ]; then
        echo "MODUS: --seit-basis (Bereich SELBST bestimmt, nie uebergeben)"
    else
        echo "MODUS: --bereich (KUMULATIV -- beide Enden vom Aufrufer benannt)"
    fi
    echo "  Basis-Referenz : ${_ce_basis}  (${_ce_sym})"
    echo "  merge-base     : ${_ce_mb}"
    echo "  SPITZE         : ${_ce_spitze} = ${_ce_spitze_sha}"
    echo "  BEREICHSBREITE : ${_ce_ncommits} Commit(s) in merge-base..SPITZE"
    if [ "$_ce_ncommits" -eq 0 ]; then
        if [ "$_ce_basis_auto" -eq 0 ]; then
            # NULL COMMITS IST BEI --bereich ABBRUCH, NICHT GRUEN -- gleiche
            # Asymmetrie wie in der ce-Fassung: hier hat der Aufrufer nach einem
            # URTEIL ueber einen Stand gefragt, und ueber einen leeren Stand gibt
            # es keines. Bei --seit-basis bleibt es ein HINWEIS: dieser Modus
            # laeuft unbedingt in der CI, auch auf der Basis selbst, wo 0 der
            # regulaere Fall ist.
            ce_abbruch "0 Commit(s) zwischen Abzweigung und SPITZE -- es wurde NICHTS geprueft, \
also ist nichts bestanden. Sind BASIS und SPITZE derselbe Stand, gibt es nichts zu uebertragen \
und dieser Aufruf ist ueberfluessig, nicht gruen."
        fi
        echo "  HINWEIS: SPITZE ist Vorfahr der Basis -- kein eigener Beitrag im Bereich."
        echo "  ACHTUNG: der Nenner unten ist dann 0. Ein GRUEN darauf ist KEIN Urteil"
        echo "  ueber den Baum, sondern nur ueber einen leeren Bereich."
    fi

    git -C "$_ce_repo_root" diff -U0 --no-color --no-ext-diff "${_ce_mb}" "${_ce_spitze_sha}" -- "$@" \
        > "$_ce_diff_datei" 2>"${_ce_diff_datei}.err"
    _ce_rc=$?
    if [ "$_ce_rc" -ne 0 ]; then
        echo "" >&2; echo "git diff stderr:" >&2; cat "${_ce_diff_datei}.err" >&2
        ce_abbruch "git diff selbst ist fehlgeschlagen (rc=${_ce_rc}) -- KEINE stille Null."
    fi

    _ce_nfiles=$(git -C "$_ce_repo_root" diff --name-only "${_ce_mb}" "${_ce_spitze_sha}" -- "$@" \
        2>/dev/null | wc -l)
    echo "  BERUEHRTE DAT. : ${_ce_nfiles} Datei(en) im Bereich"
    ;;

bestand)
    _ce_awk_modus="bestand"
    echo ""
    echo "MODUS: --bestand (GESAMTER versionierter Bestand, kein Diff)"
    git -C "$_ce_repo_root" ls-files -- "$@" > "$_ce_dateiliste" 2>"${_ce_diff_datei}.err"
    _ce_rc=$?
    if [ "$_ce_rc" -ne 0 ]; then
        echo "" >&2; echo "git ls-files stderr:" >&2; cat "${_ce_diff_datei}.err" >&2
        ce_abbruch "git ls-files fehlgeschlagen (rc=${_ce_rc}) -- KEINE stille Null."
    fi
    [ -s "$_ce_dateiliste" ] || ce_abbruch \
        "git ls-files hat KEINE Datei geliefert. Eine leere Bestandsliste ist hier ein Fehler, keine gruene Null."
    ;;
esac

# ---------------------------------------------------------------------------
# EIN awk-Programm fuer beide Modi: gemeinsame Scope- und ASCII-Logik, damit
# Diff-Pruefung und Bestands-Pruefung nie auseinanderlaufen koennen.
# ---------------------------------------------------------------------------
_ce_awk_prog='
    BEGIN {
        curfile = "(unbekannt)"
        in_hunk = 0
        newline_no = 0
        total_added = 0; total_scoped = 0; total_skipped = 0
        ascii_viol = 0; width_viol = 0
        skipped_files_n = 0
        fatal = 0
        for (n = 128; n <= 255; n++) { is_high[sprintf("%c", n)] = 1 }
        # Paragraf-Zeichen als UTF-8 (0xC2 0xA7) -- die eine erlaubte Ausnahme.
        para = sprintf("%c%c", 194, 167)
    }
    function is_scoped(fname,    base, i, last_dot, ext) {
        base = fname
        i = length(base)
        while (i > 0 && substr(base, i, 1) != "/") i--
        base = substr(base, i + 1)
        if (base == "CMakeLists.txt") return 1
        last_dot = 0
        for (i = 1; i <= length(base); i++) if (substr(base, i, 1) == ".") last_dot = i
        if (last_dot == 0) return 0
        ext = substr(base, last_dot)
        if (ext == ".cpp" || ext == ".hpp" || ext == ".h"   || ext == ".hh"  || \
            ext == ".cc"  || ext == ".cxx" || ext == ".tpp" || ext == ".ipp" || \
            ext == ".inl" || ext == ".cmake" || ext == ".sh") return 1
        return 0
    }
    function strip_para(s,    i, out, two) {
        out = ""; i = 1
        while (i <= length(s)) {
            two = substr(s, i, 2)
            if (two == para) { i += 2 } else { out = out substr(s, i, 1); i += 1 }
        }
        return out
    }
    function note_skip(f) {
        if (!(f in skipped_files)) { skipped_files[f] = 1; skipped_files_n++ }
    }
    function pruefe(fname, lineno, content,    checked, i, viol) {
        checked = strip_para(content)
        viol = 0
        for (i = 1; i <= length(checked); i++) {
            if (substr(checked, i, 1) in is_high) { viol = 1; break }
        }
        if (viol) { ascii_viol++; printf "  NICHT-ASCII   %s:%d\n", fname, lineno }
        if (length(content) > SPALTEN_MAX) {
            width_viol++
            printf "  >%d-SPALTEN  %s:%d (%d Byte)\n", SPALTEN_MAX, fname, lineno, length(content)
        }
    }

    # ---- Modus bestand ------------------------------------------------------
    # Die Eingabe ist die DATEILISTE (ein Pfad je Zeile); awk oeffnet jede Datei
    # SELBST per getline. Bewusst kein xargs: xargs haette die Liste bei
    # ARG_MAX in MEHRERE awk-Laeufe zerlegt, von denen jeder die
    # Zusammenfassungsdatei neu geschrieben haette -- die Endzahl waere dann
    # still nur der letzte Teil gewesen. Genau die Klasse Fehler, gegen die
    # diese Wache gebaut ist. Ein Prozess, eine Zaehlung.
    MODUS == "bestand" {
        rel = $0
        if (rel == "") next
        path = ROOT "/" rel
        lnr = 0
        while ((rc = (getline line < path)) > 0) {
            lnr++
            sub(/\r$/, "", line)
            total_added++
            if (is_scoped(rel)) { total_scoped++; pruefe(rel, lnr, line) }
            else { total_skipped++; note_skip(rel) }
        }
        close(path)
        if (rc < 0) {
            print "FATAL: Datei nicht lesbar: " path > "/dev/stderr"
            fatal = 1; exit
        }
        next
    }

    # ---- Modus diff: Zustandsmaschine statt Regex-Vermutung ueber "+++" ----
    {
        line = $0
        sub(/\r$/, "", line)

        if (substr(line, 1, 10) == "diff --git") { in_hunk = 0; curfile = "(unbekannt)"; next }

        if (in_hunk == 0) {
            if (substr(line, 1, 4) == "+++ ") {
                f = substr(line, 5)
                if (substr(f, 1, 2) == "b/") f = substr(f, 3)
                tabpos = index(f, "\t")
                if (tabpos > 0) f = substr(f, 1, tabpos - 1)
                if (f != "/dev/null") curfile = f
                next
            }
            if (substr(line, 1, 2) == "@@") {
                n = split(line, parts, " ")
                if (n < 3 || substr(parts[3], 1, 1) != "+") {
                    print "FATAL: Hunk-Kopf ohne erkennbares +Start-Feld: " line > "/dev/stderr"
                    fatal = 1; exit
                }
                nf = substr(parts[3], 2)
                cpos = index(nf, ",")
                newline_no = (cpos > 0 ? substr(nf, 1, cpos - 1) : nf) + 0
                in_hunk = 1
                next
            }
            next
        }

        if (substr(line, 1, 2) == "@@") {
            n = split(line, parts, " ")
            if (n < 3 || substr(parts[3], 1, 1) != "+") {
                print "FATAL: Hunk-Kopf ohne erkennbares +Start-Feld: " line > "/dev/stderr"
                fatal = 1; exit
            }
            nf = substr(parts[3], 2)
            cpos = index(nf, ",")
            newline_no = (cpos > 0 ? substr(nf, 1, cpos - 1) : nf) + 0
            next
        }

        prefix = substr(line, 1, 1)
        if (prefix == "+") {
            total_added++
            content = substr(line, 2)
            if (is_scoped(curfile)) { total_scoped++; pruefe(curfile, newline_no, content) }
            else { total_skipped++; note_skip(curfile) }
            newline_no++
            next
        }
        if (prefix == " ") { newline_no++; next }
        next
    }

    END {
        if (fatal) { exit 2 }
        printf "SUMMARY_ADDED=%d\n",   total_added   > META
        printf "SUMMARY_SCOPED=%d\n",  total_scoped  > META
        printf "SUMMARY_SKIPPED=%d\n", total_skipped > META
        printf "SUMMARY_ASCII=%d\n",   ascii_viol    > META
        printf "SUMMARY_WIDTH=%d\n",   width_viol    > META
        for (f in skipped_files) print f > SKIPPED
    }
'

if [ "$_ce_awk_modus" = "bestand" ]; then
    awk -v MODUS="bestand" -v SPALTEN_MAX="$CE_SPALTEN_MAX" -v ROOT="$_ce_repo_root" \
        -v META="${_ce_awk_out}.meta" -v SKIPPED="${_ce_awk_out}.skipped" \
        "$_ce_awk_prog" "$_ce_dateiliste" > "$_ce_awk_out"
    _ce_awk_rc=$?
else
    awk -v MODUS="diff" -v SPALTEN_MAX="$CE_SPALTEN_MAX" -v ROOT="$_ce_repo_root" \
        -v META="${_ce_awk_out}.meta" -v SKIPPED="${_ce_awk_out}.skipped" \
        "$_ce_awk_prog" "$_ce_diff_datei" > "$_ce_awk_out"
    _ce_awk_rc=$?
fi

if [ "$_ce_awk_rc" -ne 0 ]; then
    cat "$_ce_awk_out" 2>/dev/null
    ce_abbruch "awk-Verarbeitung fehlgeschlagen (rc=${_ce_awk_rc}) -- s. FATAL-Zeile oben."
fi

[ -f "${_ce_awk_out}.meta" ] \
    || ce_abbruch "awk hat keine Zusammenfassung geschrieben -- interner Fehler, keine stille Null."

echo ""
echo "VERSTOESSE (falls vorhanden):"
if [ -s "$_ce_awk_out" ]; then
    cat "$_ce_awk_out"
else
    echo "  (keine)"
fi

_ce_added=0; _ce_scoped=0; _ce_skipped=0; _ce_ascii=0; _ce_width=0
while IFS='=' read -r _ce_k _ce_v; do
    case "$_ce_k" in
        SUMMARY_ADDED)   _ce_added=$_ce_v ;;
        SUMMARY_SCOPED)  _ce_scoped=$_ce_v ;;
        SUMMARY_SKIPPED) _ce_skipped=$_ce_v ;;
        SUMMARY_ASCII)   _ce_ascii=$_ce_v ;;
        SUMMARY_WIDTH)   _ce_width=$_ce_v ;;
    esac
done < "${_ce_awk_out}.meta"

echo ""
echo "-----------------------------------------------------------------------------"
echo "NENNER (nie eine nackte Null):"
echo "  ${_ce_scoped} Zeilen in super-eigenem Code geprueft, davon ${_ce_ascii} Nicht-ASCII,"
echo "  davon ${_ce_width} ueber ${CE_SPALTEN_MAX} Spalten."
echo "  ${_ce_added} Zeilen insgesamt betrachtet; ${_ce_skipped} davon ausserhalb des Scopes"
echo "  (Prosa/YAML/Daten) uebersprungen."
if [ -f "${_ce_awk_out}.skipped" ] && [ -s "${_ce_awk_out}.skipped" ]; then
    _ce_nskip=$(wc -l < "${_ce_awk_out}.skipped")
    echo "  ${_ce_nskip} uebersprungene Datei(en), namentlich (keine zweite stille Null):"
    while IFS= read -r _ce_sf; do
        [ -n "$_ce_sf" ] && echo "    - ${_ce_sf}"
    done < "${_ce_awk_out}.skipped"
fi
echo "-----------------------------------------------------------------------------"

echo ""
if [ "$_ce_ascii" -eq 0 ] && [ "$_ce_width" -eq 0 ]; then
    echo "DIFF-HYGIENE-WACHE: GRUEN."
    exit 0
else
    echo "DIFF-HYGIENE-WACHE: ROT."
    exit 1
fi
