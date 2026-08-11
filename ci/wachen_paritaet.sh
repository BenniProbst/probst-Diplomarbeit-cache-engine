#!/bin/sh
# shellcheck shell=sh
# =============================================================================
# WACHEN-PARITAET -- die Diff-Hygiene-Wache liegt in ZWEI Fassungen und darf
# nicht unbemerkt auseinanderlaufen.                               (2026-08-10)
# =============================================================================
# DER BEFUND, GEGEN DEN DIESE DATEI GEBAUT IST (am Objekt gemessen, super
# 7144f4f6, ce-Gitlink e114cabd):
#
#     super  scripts/ci_diff_ascii_width_guard.sh   558 Zeilen  sha1 0014fe29
#     ce     scripts/ci_diff_ascii_width_guard.sh   779 Zeilen  sha1 6d98605a
#
# Dieselbe Datei, derselbe Zweck, zwei Fassungen -- der Abschrift-Fall. Die
# Abschrift selbst ist NICHT der Defekt: der Kopf der super-Fassung begruendet
# sie an drei Stellen, und zwei der drei Gruende sind heute noch messbar wahr
# (lint:diff-hygiene faehrt GIT_SUBMODULE_STRATEGY: none -- dort ist
# Code/external/comdare-cache-engine ein LEERES Verzeichnis; und der Scope der
# beiden Repos ist nicht derselbe). Der Defekt ist die UNGEPRUEFTE Abschrift.
#
# WAS DIE UNGEPRUEFTE ABSCHRIFT AM 10.08.2026 SCHON KOSTETE (gemessen, nicht
# vermutet -- Kommandos stehen unten unter NACHRECHNEN):
#
#   (1) DERSELBE --stdin-DIFF, VERSCHIEDENE VERDIKTE. --stdin ist der einzige
#       Pfad, den beide Fassungen kennen, und er bricht bei Uneinigkeit NICHT
#       ab -- er antwortet einfach verschieden. Fuenf Proben mit gewuerfeltem
#       Koeder, drei davon abweichend:
#           x.c   mit Nicht-ASCII   super rc=0 GRUEN   ce rc=1 ROT
#           x.py  mit Nicht-ASCII   super rc=0 GRUEN   ce rc=1 ROT
#           t.tex mit Nicht-ASCII   super rc=0 GRUEN   ce rc=1 ROT
#           x.cpp mit Nicht-ASCII   super rc=1 ROT     ce rc=1 ROT   (gleich)
#           quotierte .md           super rc=0 GRUEN   ce rc=0 GRUEN (gleich)
#       Bei .tex ist die Abweichung GEWOLLT (deutsche Prosa traegt Umlaute,
#       s. Kopf der super-Fassung). Bei .c und .py ist sie ein DEFEKT: die
#       super-Fassung fuehrt eine Endungs-WHITELIST und nennt alles, was nicht
#       darauf steht, im Nenner "ausserhalb des Scopes (Prosa/YAML/Daten)" --
#       fuer eine .c-Datei ist dieses Etikett schlicht falsch. Die ce-Fassung
#       hat genau diese Richtung am 10.08.2026 umgedreht (Whitelist ->
#       Blacklist); die super-Fassung hat den Umbau nie bekommen.
#
#   (2) DIE UNBEKANNTE OPTION FAELLT IN DER ce-FASSUNG DURCH. Die super-Fassung
#       hat einen --*-Zweig und weist alles Unbekannte namentlich ab. Die
#       ce-Fassung hat keinen und reicht jedes --wort an `git diff` weiter.
#       Solange git das Wort nicht kennt, sieht das nach "bricht sauber ab" aus
#       -- das ist Glueck, keine Konstruktion, und das Glueck endet bei jedem
#       Wort, das git KENNT. Gemessen:
#           ce   --name-only  -> rc=0  "DIFF-HYGIENE-WACHE: GRUEN."  Nenner 0
#           ce   --cached     -> rc=0  "DIFF-HYGIENE-WACHE: GRUEN."  Nenner 0
#           super --name-only -> rc=2  "ABBRUCH -- Unbekannte Option"
#       Eine Wache, die GRUEN druckt, ohne hingesehen zu haben, ist die stille
#       Null in Person -- und zwar in dem Werkzeug, das gegen stille Nullen
#       gebaut wurde.
#
# WARUM DIESE WACHE MISST STATT ZU LESEN (die Bauentscheidung, begruendet):
# Ein Parser ueber Shell-Quelltext koennte die Optionsliste "ablesen". Er waere
# der naechste stille Nuller: die beiden Fassungen parsen ihre Argumente heute
# schon verschieden (case/esac gegen if/elif), und wer morgen auf getopts
# umbaut, bekaeme von einem Regex-Parser ZWEI leere Listen -- und zwei leere
# Listen sind gleich. Die Wache RUFT deshalb beide Fassungen auf und stuft
# ihre ANTWORT ein. Eine leere Kandidatenliste kann dabei nicht entstehen: sie
# steht fest im Skript, und ihre Laenge wird im Nenner gedruckt.
#
# DER GEWUERFELTE KANDIDAT IST TEIL DER MESSUNG, NICHT DEKORATION: bei jedem
# Lauf kommt eine Option `--<8 hex>` aus /dev/urandom dazu. Sie ist per
# Konstruktion in KEINER Fassung gebaut und MUSS in beiden als UNBEKANNT
# eingestuft werden. Damit beweist die Wache in jedem Lauf, dass ihr
# Einstufer ueberhaupt zwischen "erkannt" und "unbekannt" unterscheiden kann
# -- eine Wache, die alles als "erkannt" einstuft, waere sonst gruen.
#
# KEIN grep IN DER KERNLOGIK: eingestuft wird mit awk und index(), nie mit
# einer Regex ueber Diff-Zeichen. Die bekannte Falle um '^\+\+\+' (unter ugrep
# Syntaxabbruch, unter GNU-BRE frisst \+ als "ein-oder-mehr" ganze Zusatz-
# zeilen -- beide Wege enden in einer stillen 0) kann hier nicht auftreten.
#
# FAIL-CLOSED AN JEDER KANTE:
#   * Fehlt eine der beiden Fassungen, ist das ABBRUCH (Exit 2), nie "dann
#     halt nur die eine". In der CI heisst das: der Job braucht die Submodule.
#     Deshalb laeuft diese Wache in verify:submodules und NICHT in
#     lint:diff-hygiene (dort ist das ce-Verzeichnis leer, s.o.).
#   * Stuft der Einstufer eine Antwort nicht ein, ist das ABBRUCH, nicht
#     "gleich".
#   * Der gewuerfelte Kandidat MUSS in beiden UNBEKANNT sein. Ist er es nicht,
#     ist das ABBRUCH -- dann misst der Einstufer nicht, was er zu messen
#     behauptet.
#
# GEPRUEFT WIRD -- und was NICHT (beide Mengen gehoeren in dieselbe Ausgabe,
# ein gruenes Gate deckt nur seinen Gegenstand):
#   GEPRUEFT   Teil A  die OPTIONS-OBERFLAECHE beider Fassungen, Option fuer
#                      Option, plus der Vertrag ueber die unbekannte Option.
#              Teil B  das VERDIKT auf dem gemeinsamen --stdin-Pfad, je
#                      Dateiart, mit gewuerfeltem Koeder.
#   NICHT      die Gleichheit der Kopftexte, der Nenner-Formulierungen und der
#              Exit-Codes jenseits von 0/1/2. Der Default-Modus (Aufruf ohne
#              Argumente) ist ebenfalls NICHT gedeckt: die ce-Fassung bezieht
#              dort untracked Dateien ein und bricht bei Nenner 0 ab, die
#              super-Fassung tut beides nicht. Das ist ein offener Posten und
#              steht hier, damit er nicht still bleibt.
#
# NACHRECHNEN (die Kommandos, nicht die Zahlen -- Zahlen verjaehren):
#   sh ci/wachen_paritaet.sh
#   sh ci/wachen_paritaet.sh --zeige-proben     # Proben behalten statt loeschen
#
# EXIT:  0 = Paritaet haelt (Nenner wird IMMER gedruckt)
#        1 = Divergenz (der rote Biss)
#        2 = Aufruf/Umgebung/undeutbare Antwort -- NIE eine stille 0
#
# KEIN Python (Buildchain-Kanon), POSIX sh + awk, ASCII-only, <= 119 Byte/Zeile.
# Selbstcheck: diese Datei ist selbst im Scope der Diff-Hygiene-Wache (.sh).
# =============================================================================

set -u
export LC_ALL=C

WP_SUPER_REL="scripts/ci_diff_ascii_width_guard.sh"
WP_CE_REL="Code/external/comdare-cache-engine/scripts/ci_diff_ascii_width_guard.sh"

# DIE KANDIDATENLISTE. Sie ist die VEREINIGUNG aller Optionen, die je eine der
# beiden Fassungen trug -- nicht der Durchschnitt. Wer eine Option in einer
# Fassung streicht, faellt damit rot auf, statt die Liste zu verkleinern.
WP_KANDIDATEN="--stdin --bereich --seit-basis --bestand"

wp_abbruch() {
    echo ""
    echo "WACHEN-PARITAET: ABBRUCH -- $1" >&2
    exit 2
}

command -v awk  >/dev/null 2>&1 || wp_abbruch "awk ist nicht im PATH."
command -v git  >/dev/null 2>&1 || wp_abbruch "git ist nicht im PATH."
command -v mktemp >/dev/null 2>&1 || wp_abbruch "mktemp ist nicht im PATH."
command -v od   >/dev/null 2>&1 || wp_abbruch "od ist nicht im PATH (Koeder-Wuerfel)."

_wp_zeige_proben=0
case "${1:-}" in
    "") : ;;
    --zeige-proben) _wp_zeige_proben=1; shift ;;
    *) wp_abbruch "Unbekannte Option '$1'. Erlaubt: --zeige-proben." ;;
esac

_wp_script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd) \
    || wp_abbruch "Skript-Verzeichnis nicht aufloesbar."
_wp_root=$(CDPATH= cd -- "$_wp_script_dir/.." && pwd) \
    || wp_abbruch "Repo-Wurzel nicht aufloesbar."

_wp_super="${_wp_root}/${WP_SUPER_REL}"
_wp_ce="${_wp_root}/${WP_CE_REL}"

# FEHLT EINE FASSUNG, IST DAS ABBRUCH. Kein "dann halt nur die eine": eine
# Paritaets-Wache mit einem Gegenstand ist keine Paritaets-Wache.
[ -f "$_wp_super" ] || wp_abbruch "$(
    echo "super-Fassung nicht gefunden: ${WP_SUPER_REL}"
    echo "Ohne beide Fassungen gibt es keine Paritaet zu pruefen -- KEINE stille Null."
)"
[ -f "$_wp_ce" ] || wp_abbruch "$(
    echo "ce-Fassung nicht gefunden: ${WP_CE_REL}"
    echo "In der CI ist die haeufigste Ursache GIT_SUBMODULE_STRATEGY: none -- dieser"
    echo "Job braucht die Submodule. Ein leeres Submodul-Verzeichnis ist ABBRUCH,"
    echo "nicht Paritaet. KEINE stille Null."
)"

_wp_tmp="$(mktemp -d "${TMPDIR:-/tmp}/wachen_paritaet.XXXXXX")" \
    || wp_abbruch "mktemp -d fehlgeschlagen."
wp_aufraeumen() {
    if [ "$_wp_zeige_proben" -eq 1 ]; then
        echo ""
        echo "PROBEN BEHALTEN (--zeige-proben): ${_wp_tmp}"
    else
        rm -rf "$_wp_tmp"
    fi
}
trap wp_aufraeumen EXIT INT TERM HUP

# GEWUERFELTER KOEDER (K13): NIE abgeschrieben, bei jedem Lauf neu aus
# /dev/urandom. Er traegt zwei Aufgaben -- er ist der Kandidat, den keine
# Fassung kennen darf, UND der Inhalt der Proben-Zeilen in Teil B, damit kein
# Fall ueber einen fest eingetragenen Beispielwert gruen werden kann.
_wp_koeder="$(head -c 8 /dev/urandom | od -An -tx1 | tr -d ' \n')"
[ -n "$_wp_koeder" ] || wp_abbruch "Koeder-Wuerfel lieferte nichts -- ohne Koeder kein Beweis."
case "$_wp_koeder" in
    *[!0-9a-f]*) wp_abbruch "Koeder '${_wp_koeder}' ist nicht hexadezimal -- undeutbar." ;;
esac

echo "============================================================================="
echo " WACHEN-PARITAET: Diff-Hygiene-Wache in super gegen die im ce"
echo " ci/wachen_paritaet.sh -- Repo: ${_wp_root}"
echo "============================================================================="
echo ""
echo "GEGENSTAND (beide Fassungen, mit ihrer Groesse -- nie eine nackte Zahl):"
_wp_z_super=$(awk 'END { print NR }' "$_wp_super")
_wp_z_ce=$(awk 'END { print NR }' "$_wp_ce")
printf '  super  %-58s %5s Zeilen\n' "$WP_SUPER_REL" "$_wp_z_super"
printf '  ce     %-58s %5s Zeilen\n' "$WP_CE_REL" "$_wp_z_ce"
echo "  Koeder dieses Laufs (gewuerfelt, nicht abgeschrieben): ${_wp_koeder}"

# ---------------------------------------------------------------------------
# WEGWERF-REPO. Beide Fassungen werden in EINEM identischen Wegwerf-Baum
# befragt, damit kein Unterschied aus dem Inhalt des jeweiligen Repos stammen
# kann. Die Fassungen loesen ihre Repo-Wurzel ueber dirname($0)/.. auf -- sie
# muessen deshalb unter <baum>/scripts/ liegen. Der echte Arbeitsbaum wird
# dabei NICHT angefasst.
# ---------------------------------------------------------------------------
wp_baum_bauen() {
    _b="$1"
    _f="$2"
    mkdir -p "${_b}/scripts" || return 1
    cp "$_f" "${_b}/scripts/ci_diff_ascii_width_guard.sh" || return 1
    printf 'int a = 1;\n' > "${_b}/vorhanden.cpp" || return 1
    git -C "$_b" init -q -b main >/dev/null 2>&1 || return 1
    git -C "$_b" -c user.email=p@example.invalid -c user.name=P add -A >/dev/null 2>&1 || return 1
    git -C "$_b" -c user.email=p@example.invalid -c user.name=P \
        commit -q -m "basis" >/dev/null 2>&1 || return 1
    return 0
}

wp_baum_bauen "${_wp_tmp}/super" "$_wp_super" \
    || wp_abbruch "Wegwerf-Baum fuer die super-Fassung nicht baubar."
wp_baum_bauen "${_wp_tmp}/ce" "$_wp_ce" \
    || wp_abbruch "Wegwerf-Baum fuer die ce-Fassung nicht baubar."

# ---------------------------------------------------------------------------
# DER EINSTUFER. Er liest die AUSGABE eines Probelaufs und gibt genau eines
# von drei Woertern zurueck. awk mit index() -- keine Regex ueber Diff-Zeichen.
#
#   ERKANNT        die Fassung KENNT das Wort: sie nennt es in ihrer eigenen
#                  MODUS-Zeile oder sie bricht mit einer eigenen, das Wort
#                  nennenden Meldung ueber dessen ARGUMENTE ab ("--bereich
#                  braucht eine BASIS"). Beides beweist einen eigenen Zweig.
#   UNBEKANNT      die Fassung weist sie namentlich ab ("Unbekannte Option").
#   DURCHGEREICHT  weder noch: die Option landet in der ARGUMENTE-Zeile, also
#                  ungelesen bei git. Das ist die gefaehrliche Klasse -- sie
#                  sieht bei einem Wort, das git nicht kennt, wie ein sauberer
#                  Abbruch aus und wird bei einem Wort, das git kennt, gruen.
#   VERSCHLUCKT    die Fassung nennt das Wort NIRGENDS: kein Modus, keine
#                  Abweisung, nicht einmal in den git-Argumenten. Sie hat es
#                  stillschweigend gefressen und etwas anderes gemessen als der
#                  Aufrufer verlangt hat.
#
# VERSCHLUCKT WAR BIS 10.08.2026 EIN ABBRUCH ("nicht einstufbar") UND IST JETZT
# EIN RISS -- der Unterschied ist am eigenen Koeder aufgeschlagen: eine nur in
# EINE Fassung eingebaute Option, die dort still geschluckt wird, liess diese
# Wache mit Exit 2 abbrechen, statt mit Exit 1 zu beissen. Sie hatte die
# Divergenz in Teil A0 bereits GEFUNDEN und meldete sie dann nicht als Befund,
# sondern als Werkzeugfehler. Das ist keine Einstufungsfrage: eine Fassung, die
# ein Wort verschluckt, ist beobachtbar kaputt, und beobachtbar kaputt gehoert
# in den roten Zweig. Abbruch bleibt genau ein Fall: die Fassung hat auf den
# Probelauf UEBERHAUPT NICHTS gesagt -- dann lief sie nicht, und dann misst
# diese Wache nichts.
#
# DIE REIHENFOLGE IST TEIL DER AUSSAGE: "Unbekannte Option '--bereich'" nennt
# das Wort ebenfalls, ist aber eine ABWEISUNG und keine Kenntnis. Die
# Abweisung gewinnt deshalb vor der Kenntnis, und die Kenntnis vor dem
# Durchreichen. Waere es umgekehrt, stufte die Wache jede saubere Abweisung
# als "erkannt" ein -- und der gewuerfelte Kandidat unten koennte sie nicht
# mehr widerlegen.
#
# Jede andere Antwort ist UNDEUTBAR und damit ABBRUCH -- ein Einstufer, der
# raet, ist die naechste stille Null.
# ---------------------------------------------------------------------------
wp_einstufen() {
    awk -v opt="$1" '
        index($0, "Unbekannte Option") > 0 { unb = 1 }
        index($0, "nicht gebaut") > 0 && index($0, opt) > 0 { ung = 1 }
        index($0, "MODUS:") == 1 && index($0, opt) > 0 { erk = 1 }
        index($0, "DIFF-HYGIENE-WACHE: ABBRUCH") > 0 && index($0, opt) > 0 { erk_ab = 1 }
        index($0, "ARGUMENTE:") == 1 && index($0, opt) > 0 { dur = 1 }
        END {
            if (NR == 0) { print "STUMM"; exit }
            if (unb) { print "UNBEKANNT"; exit }
            if (ung) { print "ERK-UNGEBAUT"; exit }
            if (erk || erk_ab) { print "ERKANNT"; exit }
            if (dur) { print "DURCHGEREICHT"; exit }
            print "VERSCHLUCKT"
        }
    ' "$2"
}

# ERK-UNGEBAUT IST EINE EIGENE STUFE, KEIN SYNONYM FUER ERKANNT. Der Vertrag,
# den diese Wache durchsetzt, lautet "KEIN Wort faellt ungelesen durch" -- nicht
# "jede Fassung kann alles". Eine Fassung darf einen Modus nicht haben; sie darf
# ihn nur nicht VERSCHWEIGEN. ERK-UNGEBAUT gilt deshalb als vertragstreu (kein
# Riss), wird aber als eigenes Wort gedruckt UND unten im Nenner als offener
# Posten wiederholt -- sonst waere die Fassungs-Luecke unter einem gemeinsamen
# "ERKANNT" verschwunden, und genau dieses Verschwinden ist der Gegenstand
# dieses Pakets.
wp_vertragstreu() {
    case "$1" in
        ERKANNT|ERK-UNGEBAUT) return 0 ;;
        *) return 1 ;;
    esac
}

wp_probelauf() {
    # $1 = Baum, $2 = Option, $3 = Ausgabedatei
    ( cd "$1" && sh scripts/ci_diff_ascii_width_guard.sh "$2" ) \
        > "$3" 2>&1 < /dev/null
    return 0
}

# ---------------------------------------------------------------------------
# TEIL A0 -- DIE SELBST ERKLAERTE LISTE.
#
# Beide Fassungen nennen in ihrer Abweisungs-Meldung, welche Optionen sie
# erlauben ("Erlaubt: --bereich, --bestand, ..."). Diese Liste wird hier nicht
# aus dem Quelltext GELESEN, sondern der Fassung ABGEFRAGT -- mit der
# gewuerfelten Option, die sie zwingt, sich zu erklaeren.
#
# WARUM DAS DIE FESTE KANDIDATENLISTE NICHT ERSETZT, SONDERN ERGAENZT: eine
# feste Liste kann eine NEU hinzugekommene Option nicht kennen. Wer morgen
# --foo nur in EINE Fassung baut, wuerde von Teil A allein nicht gefunden. Die
# erklaerten Listen werden deshalb (a) gegeneinander verglichen UND (b) in die
# Kandidatenliste von Teil A hineingemischt -- eine neu erklaerte Option wird
# damit sofort in BEIDEN Fassungen befragt.
# RESTRISIKO, ehrlich benannt: eine Option, die eine Fassung BAUT, aber in ihrer
# eigenen Erlaubt-Zeile VERSCHWEIGT, faellt durch beide Netze. Dann luegt
# allerdings die Fassung ueber sich selbst -- ein eigener Defekt, kein
# Divergenz-Defekt, und er steht unten unter NICHT GEPRUEFT.
# ---------------------------------------------------------------------------
wp_erklaerte_liste() {
    awk '
        {
            p = index($0, "Erlaubt:")
            if (p == 0) next
            rest = substr($0, p + 8)
            q = index(rest, ".")
            if (q > 0) rest = substr(rest, 1, q - 1)
            gsub(/,/, " ", rest)
            n = split(rest, t, " ")
            for (i = 1; i <= n; i++) if (substr(t[i], 1, 2) == "--") print t[i]
        }
    ' "$1" | sort -u
}

echo ""
echo "-----------------------------------------------------------------------------"
echo "TEIL A0 -- die von den Fassungen SELBST erklaerte Optionsliste"
echo "-----------------------------------------------------------------------------"
wp_probelauf "${_wp_tmp}/super" "--${_wp_koeder}" "${_wp_tmp}/a0_super.out"
wp_probelauf "${_wp_tmp}/ce" "--${_wp_koeder}" "${_wp_tmp}/a0_ce.out"
wp_erklaerte_liste "${_wp_tmp}/a0_super.out" > "${_wp_tmp}/a0_super.liste"
wp_erklaerte_liste "${_wp_tmp}/a0_ce.out" > "${_wp_tmp}/a0_ce.liste"
_wp_n_s=$(awk 'END { print NR }' "${_wp_tmp}/a0_super.liste")
_wp_n_c=$(awk 'END { print NR }' "${_wp_tmp}/a0_ce.liste")
# EINE LEERE ERKLAERTE LISTE IST ABBRUCH, NICHT GLEICHHEIT. Zwei leere Listen
# waeren sonst identisch -- die stille Null, gegen die diese Wache gebaut ist.
[ "$_wp_n_s" -gt 0 ] || wp_abbruch "$(
    echo "Die super-Fassung hat auf eine unbekannte Option KEINE Erlaubt-Liste genannt."
    echo "Zwei leere Listen waeren gleich -- das waere die stille Null. ABBRUCH."
)"
[ "$_wp_n_c" -gt 0 ] || wp_abbruch "$(
    echo "Die ce-Fassung hat auf eine unbekannte Option KEINE Erlaubt-Liste genannt."
    echo "Zwei leere Listen waeren gleich -- das waere die stille Null. ABBRUCH."
)"
printf '  super erklaert %s Option(en): %s\n' "$_wp_n_s" \
    "$(tr '\n' ' ' < "${_wp_tmp}/a0_super.liste")"
printf '  ce    erklaert %s Option(en): %s\n' "$_wp_n_c" \
    "$(tr '\n' ' ' < "${_wp_tmp}/a0_ce.liste")"
_wp_a0_riss=0
comm -3 "${_wp_tmp}/a0_super.liste" "${_wp_tmp}/a0_ce.liste" > "${_wp_tmp}/a0_diff"
if [ -s "${_wp_tmp}/a0_diff" ]; then
    _wp_a0_riss=$(awk 'END { print NR }' "${_wp_tmp}/a0_diff")
    echo "  RISS: die erklaerten Listen sind NICHT gleich. Nur in einer Fassung:"
    awk '{ gsub(/^[ \t]+/, ""); print "    - " $0 }' "${_wp_tmp}/a0_diff"
else
    echo "  gleich (${_wp_n_s} von ${_wp_n_s} Optionen beidseitig erklaert)"
fi

echo ""
echo "-----------------------------------------------------------------------------"
echo "TEIL A -- OPTIONS-OBERFLAECHE (jede Option in BEIDEN Fassungen befragt)"
echo "-----------------------------------------------------------------------------"
printf '  %-14s %-14s %-14s %s\n' "OPTION" "super" "ce" "URTEIL"

_wp_a_gesamt=0
_wp_a_riss=0
_wp_offen=""
_wp_liste="${_wp_tmp}/kandidaten.txt"
_wp_roh="${_wp_tmp}/kandidaten_roh.txt"
: > "$_wp_roh"
for _k in $WP_KANDIDATEN; do
    echo "$_k" >> "$_wp_roh"
done
# Die SELBST ERKLAERTEN Optionen beider Fassungen kommen dazu -- so wird eine
# neu gebaute und erklaerte Option sofort in BEIDEN befragt.
cat "${_wp_tmp}/a0_super.liste" "${_wp_tmp}/a0_ce.liste" >> "$_wp_roh"
sort -u "$_wp_roh" > "$_wp_liste"
echo "--${_wp_koeder}" >> "$_wp_liste"

while IFS= read -r _wp_opt; do
    [ -n "$_wp_opt" ] || continue
    _wp_a_gesamt=$(( _wp_a_gesamt + 1 ))
    _wp_o_s="${_wp_tmp}/a_super_${_wp_a_gesamt}.out"
    _wp_o_c="${_wp_tmp}/a_ce_${_wp_a_gesamt}.out"
    wp_probelauf "${_wp_tmp}/super" "$_wp_opt" "$_wp_o_s"
    wp_probelauf "${_wp_tmp}/ce" "$_wp_opt" "$_wp_o_c"
    _wp_k_s=$(wp_einstufen "$_wp_opt" "$_wp_o_s")
    _wp_k_c=$(wp_einstufen "$_wp_opt" "$_wp_o_c")
    # STUMM ist der EINZIGE Abbruchgrund: die Fassung hat auf den Probelauf gar
    # nichts gesagt, also lief sie nicht -- dann misst diese Wache nichts, und
    # "gleich stumm" waere die stille Null. VERSCHLUCKT dagegen ist ein Befund
    # und faellt unten in den roten Zweig.
    [ "$_wp_k_s" = "STUMM" ] && wp_abbruch "$(
        echo "Die super-Fassung hat auf '${_wp_opt}' UEBERHAUPT NICHTS ausgegeben."
        echo "Ausgabe: ${_wp_o_s} (mit --zeige-proben bleibt sie liegen)."
        echo "Sie ist damit nicht gelaufen -- hier ist nichts gemessen. ABBRUCH."
    )"
    [ "$_wp_k_c" = "STUMM" ] && wp_abbruch "$(
        echo "Die ce-Fassung hat auf '${_wp_opt}' UEBERHAUPT NICHTS ausgegeben."
        echo "Ausgabe: ${_wp_o_c} (mit --zeige-proben bleibt sie liegen)."
        echo "Sie ist damit nicht gelaufen -- hier ist nichts gemessen. ABBRUCH."
    )"
    if [ "$_wp_opt" = "--${_wp_koeder}" ]; then
        # DER GEWUERFELTE KANDIDAT. Er ist der Selbstbeweis des Einstufers und
        # zugleich der Vertrag ueber die unbekannte Option: eine Fassung, die
        # ihn nicht namentlich abweist, reicht ihn ungelesen an git weiter.
        if [ "$_wp_k_s" != "UNBEKANNT" ] || [ "$_wp_k_c" != "UNBEKANNT" ]; then
            _wp_a_riss=$(( _wp_a_riss + 1 ))
            printf '  %-14s %-14s %-14s %s\n' "(gewuerfelt)" "$_wp_k_s" "$_wp_k_c" \
                "RISS: unbekannte Option nicht in BEIDEN abgewiesen"
        else
            printf '  %-14s %-14s %-14s %s\n' "(gewuerfelt)" "$_wp_k_s" "$_wp_k_c" \
                "ok (Einstufer beweist sich selbst)"
        fi
        continue
    fi
    if wp_vertragstreu "$_wp_k_s" && wp_vertragstreu "$_wp_k_c"; then
        if [ "$_wp_k_s" = "$_wp_k_c" ]; then
            printf '  %-14s %-14s %-14s %s\n' "$_wp_opt" "$_wp_k_s" "$_wp_k_c" "gleich"
        else
            _wp_offen="${_wp_offen}${_wp_opt} "
            printf '  %-14s %-14s %-14s %s\n' "$_wp_opt" "$_wp_k_s" "$_wp_k_c" \
                "vertragstreu, aber OFFENER POSTEN (s. Nenner)"
        fi
    else
        _wp_a_riss=$(( _wp_a_riss + 1 ))
        printf '  %-14s %-14s %-14s %s\n' "$_wp_opt" "$_wp_k_s" "$_wp_k_c" \
            "RISS: mindestens eine Fassung liest das Wort nicht"
    fi
done < "$_wp_liste"

echo "  ---"
echo "  ${_wp_a_riss} von ${_wp_a_gesamt} befragten Optionen weichen ab"
echo "  (${_wp_a_gesamt} = ${WP_KANDIDATEN} + 1 gewuerfelte)."

# ---------------------------------------------------------------------------
# TEIL B -- VERDIKT-PARITAET auf dem gemeinsamen --stdin-Pfad.
#
# --stdin ist der einzige Pfad, den beide Fassungen kennen, und der einzige,
# der bei Uneinigkeit NICHT abbricht, sondern verschieden ANTWORTET. Genau
# deshalb ist er der gefaehrlichste: ein Bericht kann "GRUEN" zitieren, ohne
# zu sagen, welche Fassung das gesagt hat.
#
# Je Dateiart eine Probe mit demselben gewuerfelten Koeder und demselben
# Nicht-ASCII-Zeichen. Erwartet wird GLEICHHEIT der Exit-Codes, ausser bei den
# Arten auf der Ausnahmeliste unten -- und die traegt ihren GRUND, nicht bloss
# ihren Namen.
# ---------------------------------------------------------------------------
echo ""
echo "-----------------------------------------------------------------------------"
echo "TEIL B -- VERDIKT auf dem gemeinsamen --stdin-Pfad (gewuerfelter Koeder)"
echo "-----------------------------------------------------------------------------"
printf '  %-10s %-10s %-10s %s\n' "ART" "super" "ce" "URTEIL"

# ARTEN, DIE VERSCHIEDEN AUSFALLEN DUERFEN -- mit Grund, nicht bloss mit Namen.
# Wer eine Art hier eintraegt, traegt die Begruendung in DIESE Zeile, und zwar
# eine GEMESSENE. Eine Ausnahme ohne Grund ist die naechste stille Null.
#
# WARUM .c UND .py HIER STEHEN UND NICHT REPARIERT WURDEN (10.08.2026, am Objekt
# gemessen -- die Zahlen tragen ihr Kommando, damit sie nachrechenbar bleiben):
#     git ls-files | (Endung .c/.py/.tcc, oberste Verzeichnisebene zaehlen)
#         198 Dateien gesamt, davon 190 unter Forschungsarbeiten/, 8 unter docs/,
#         0 unter Code/. Gegenprobe (darf nicht null sein): 324 .cpp.
# Die naheliegende "Reparatur" waere gewesen, der super-Fassung die Blacklist der
# ce-Fassung zu geben (sie prueft alles ausser *.md und Vendor-Baeumen). Sie ist
# hier MESSBAR falsch, aus zwei Gruenden:
#   (1) Sie zoege 190 Quelldateien FREMDER Forschungsarbeiten in den Scope --
#       genau die Klasse, fuer die die ce-Fassung ihre Vendor-Ausnahme hat.
#   (2) Der super-Bestand ist gemischt, der ce-Bestand nicht: 61 .jpg, 49 .pdf,
#       34 .docx, 11 .pptx sind getrackt. Eine Blacklist liesse --bestand diese
#       Dateien byteweise als Text lesen.
# Der super-Scope ist also nicht die alte, vergessene Fassung des ce-Scopes,
# sondern eine andere Antwort auf einen anderen Bestand. WAS BLEIBT: kaeme je
# super-EIGENER .c-/.py-Code unter Code/ hinzu, waere diese Ausnahme falsch --
# deshalb steht die Zahl 0 oben mit ihrem Kommando dabei und nicht bloss das
# Wort "keine".
wp_ausnahme_grund() {
    case "$1" in
        tex) echo "deutsche Thesis-Prosa; im super bewusst ausserhalb des Scopes" ;;
        yml) echo "die super-.gitlab-ci.yml traegt heute schon Geviertstriche" ;;
        md)  echo "Doku-Prosa, Sprachdoktrin -- in BEIDEN Fassungen ausgenommen" ;;
        c)   echo "im super 0 unter Code/, 190 unter Forschungsarbeiten/ (10.08.2026)" ;;
        py)  echo "im super 0 unter Code/, 8 unter docs/ (10.08.2026)" ;;
        *)   echo "" ;;
    esac
}

wp_probe_bauen() {
    # $1 = Dateiname, $2 = Zielpfad
    printf 'diff --git a/%s b/%s\n--- /dev/null\n+++ b/%s\n@@ -0,0 +1 @@\n' \
        "$1" "$1" "$1" > "$2"
    printf '+KOEDER %s Caf\303\251\n' "$_wp_koeder" >> "$2"
}

_wp_b_gesamt=0
_wp_b_riss=0
_wp_arten="${_wp_tmp}/arten.txt"
{
    echo "cpp x.cpp"
    echo "c x.c"
    echo "py x.py"
    echo "sh x.sh"
    echo "cmake x.cmake"
    echo "txt CMakeLists.txt"
    echo "tex t.tex"
    echo "yml c.yml"
    echo "md d.md"
} > "$_wp_arten"

while read -r _wp_art _wp_datei; do
    [ -n "$_wp_art" ] || continue
    _wp_b_gesamt=$(( _wp_b_gesamt + 1 ))
    _wp_pd="${_wp_tmp}/b_${_wp_art}.diff"
    wp_probe_bauen "$_wp_datei" "$_wp_pd"
    sh "$_wp_super" --stdin < "$_wp_pd" > "${_wp_tmp}/b_${_wp_art}.super.out" 2>&1
    _wp_rc_s=$?
    ( cd "${_wp_tmp}/ce" && sh scripts/ci_diff_ascii_width_guard.sh --stdin ) \
        < "$_wp_pd" > "${_wp_tmp}/b_${_wp_art}.ce.out" 2>&1
    _wp_rc_c=$?
    [ "$_wp_rc_s" -le 1 ] || wp_abbruch "super-Fassung brach bei Art '${_wp_art}' ab (rc=${_wp_rc_s})."
    [ "$_wp_rc_c" -le 1 ] || wp_abbruch "ce-Fassung brach bei Art '${_wp_art}' ab (rc=${_wp_rc_c})."
    _wp_grund="$(wp_ausnahme_grund "$_wp_art")"
    if [ "$_wp_rc_s" -eq "$_wp_rc_c" ]; then
        if [ -n "$_wp_grund" ]; then
            printf '  %-10s rc=%-7s rc=%-7s gleich (Ausnahme eingetragen, greift hier nicht)\n' \
                "$_wp_art" "$_wp_rc_s" "$_wp_rc_c"
        else
            printf '  %-10s rc=%-7s rc=%-7s gleich\n' "$_wp_art" "$_wp_rc_s" "$_wp_rc_c"
        fi
    elif [ -n "$_wp_grund" ]; then
        printf '  %-10s rc=%-7s rc=%-7s geduldet: %s\n' \
            "$_wp_art" "$_wp_rc_s" "$_wp_rc_c" "$_wp_grund"
    else
        _wp_b_riss=$(( _wp_b_riss + 1 ))
        printf '  %-10s rc=%-7s rc=%-7s RISS (keine Ausnahme eingetragen)\n' \
            "$_wp_art" "$_wp_rc_s" "$_wp_rc_c"
    fi
done < "$_wp_arten"

echo "  ---"
echo "  ${_wp_b_riss} von ${_wp_b_gesamt} Dateiarten weichen OHNE eingetragenen Grund ab."

# ---------------------------------------------------------------------------
# TEIL C -- GLEICHER NAME, GLEICHES VERHALTEN AM LEEREN BEREICH.
#
# BEFUND, DER DIESEN TEIL ERZWINGT (10.08.2026, beim Bau dieses Pakets selbst
# aufgeschlagen): Teil A prueft, ob eine Fassung ein Wort KENNT -- nicht, ob
# beide dasselbe darunter verstehen. Genau dort lag nach der ersten Runde noch
# eine Divergenz: --seit-basis brach in der einen Fassung bei einem LEEREN
# Bereich ab und lief in der anderen mit Exit 0 durch. Dieselbe Option, zwei
# Antworten, kein Abbruch -- also wieder ein Verdikt, das ohne seine Fassung
# nichts aussagt.
#
# DER LEERE BEREICH IST DAFUER DER SCHAERFSTE EINGANG, weil beide zulaessigen
# Antworten vertretbar sind: --seit-basis laeuft in der super-CI unbedingt, auch
# auf der Basis selbst, wo 0 Commits regulaer sind; --bereich ist eine
# ausdrueckliche Frage nach einem Urteil, und ueber einen leeren Stand gibt es
# keines. Vertretbar sind beide -- aber nicht je Fassung eine andere.
#
# GEMESSEN WIRD AM WEGWERF-REPO GEGEN SICH SELBST (HEAD gegen HEAD): dort ist
# der Bereich mit Sicherheit leer, ohne dass ein Ref geholt werden muesste.
# ---------------------------------------------------------------------------
echo ""
echo "-----------------------------------------------------------------------------"
echo "TEIL C -- gleicher Name, gleiches Verhalten am LEEREN Bereich"
echo "-----------------------------------------------------------------------------"
printf '  %-24s %-10s %-10s %s\n' "AUFRUF" "super" "ce" "URTEIL"

_wp_c_gesamt=0
_wp_c_riss=0

wp_leerlauf() {
    # $1 = Baum, $2..$4 = Argumente (leere werden weggelassen)
    _lb="$1"
    shift
    ( cd "$_lb" && sh scripts/ci_diff_ascii_width_guard.sh "$@" ) \
        > /dev/null 2>&1 < /dev/null
    echo $?
}

wp_teil_c() {
    _wp_c_gesamt=$(( _wp_c_gesamt + 1 ))
    _cs=$(wp_leerlauf "${_wp_tmp}/super" "$@")
    _cc=$(wp_leerlauf "${_wp_tmp}/ce" "$@")
    if [ "$_cs" = "$_cc" ]; then
        printf '  %-24s rc=%-7s rc=%-7s gleich\n' "$*" "$_cs" "$_cc"
    else
        _wp_c_riss=$(( _wp_c_riss + 1 ))
        printf '  %-24s rc=%-7s rc=%-7s RISS (gleicher Name, andere Antwort)\n' \
            "$*" "$_cs" "$_cc"
    fi
}

wp_teil_c --bereich HEAD HEAD
wp_teil_c --seit-basis main
wp_teil_c --bereich main main

echo "  ---"
echo "  ${_wp_c_riss} von ${_wp_c_gesamt} Aufrufen antworten je Fassung verschieden."

# ---------------------------------------------------------------------------
# VERDIKT
# ---------------------------------------------------------------------------
_wp_riss=$(( _wp_a0_riss + _wp_a_riss + _wp_b_riss + _wp_c_riss ))
_wp_gesamt=$(( 1 + _wp_a_gesamt + _wp_b_gesamt + _wp_c_gesamt ))

echo ""
echo "-----------------------------------------------------------------------------"
echo "NENNER (nie eine nackte Null):"
echo "  ${_wp_gesamt} Vergleiche gefahren, davon ${_wp_riss} mit Riss."
echo "    Teil A0 1 Listenvergleich (${_wp_n_s} gegen ${_wp_n_c} erklaerte), ${_wp_a0_riss} Riss(e)."
echo "    Teil A  ${_wp_a_gesamt} Optionen (inkl. 1 gewuerfelte), ${_wp_a_riss} Riss(e)."
echo "    Teil B  ${_wp_b_gesamt} Dateiarten auf --stdin, ${_wp_b_riss} Riss(e)."
echo "    Teil C  ${_wp_c_gesamt} Aufrufe am leeren Bereich, ${_wp_c_riss} Riss(e)."
echo "  GEPRUEFT: Options-Oberflaeche, --stdin-Verdikt je Dateiart und das"
echo "  Verhalten gleichnamiger Optionen am leeren Bereich."
echo "  NICHT GEPRUEFT (ausdruecklich, damit es nicht still bleibt): der"
echo "  Default-Modus ohne Argumente (die ce-Fassung bezieht untracked Dateien"
echo "  ein und bricht bei Nenner 0 ab, die super-Fassung tut beides nicht),"
echo "  die Kopftexte und der Wortlaut der Nenner-Zeilen, und eine Option, die"
echo "  eine Fassung BAUT, in ihrer eigenen Erlaubt-Zeile aber VERSCHWEIGT --"
echo "  dann luegt die Fassung ueber sich selbst und keines der beiden Netze"
echo "  hier greift."
if [ -n "$_wp_offen" ]; then
    echo "  OFFENE POSTEN (vertragstreu, aber NICHT gleich -- eine Fassung liest das"
    echo "  Wort und antwortet 'nicht gebaut'):"
    echo "    ${_wp_offen}"
    echo "  Das ist kein Riss: der Vertrag lautet 'kein Wort faellt ungelesen durch',"
    echo "  nicht 'jede Fassung kann alles'. Es steht hier, damit die Luecke bei"
    echo "  jedem Lauf gedruckt wird statt unter einem gemeinsamen ERKANNT zu"
    echo "  verschwinden."
fi
echo "-----------------------------------------------------------------------------"

echo ""
if [ "$_wp_riss" -eq 0 ]; then
    echo "WACHEN-PARITAET: GRUEN.  ${_wp_gesamt} Vergleiche, 0 Riss."
    exit 0
else
    echo "WACHEN-PARITAET: ROT.  ${_wp_riss} von ${_wp_gesamt} Vergleichen mit Riss."
    exit 1
fi
