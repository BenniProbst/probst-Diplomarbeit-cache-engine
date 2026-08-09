#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  ABNAHME ##06 -- BEDINGUNGS-TABELLE der bedingten ctest-Registrierungen
#  (Posten D2-G4 des Wellenplans v2. TDD-Vertrag T-2/T-3/T-5. 2026-08-09)
# =============================================================================
#
# SELBSTCHECK -- was dieses Skript ZUSICHERT:
#   * Es zaehlt aus dem CMake-QUELLTEXT, wie viele ctest-Registrierungen hinter
#     mindestens einer if()-Bedingung stehen, und wie viele verschiedene
#     Bedingungs-Ausdruecke das sind. Beide Zahlen werden bei jedem Lauf NEU
#     ausgerechnet; es gibt hier keine Konstante fuer eine Registrierungszahl.
#   * Es prueft die Formel ##06: jede bedingte Registrierung ist entweder
#     ERFUELLT (ihr Testname steht in der ctest-Liste eines gebauten Baums)
#     ODER sie steht mit BEGRUENDUNG in der Allowlist. Alles andere ist rot.
#   * Es prueft die ZUSICHERUNG jedes Allowlist-Eintrags: wie viele
#     Registrierungs-STELLEN er deckt (Feld stellen=N). Weicht die gemessene
#     Stellenzahl ab -- nach oben ODER nach unten --, ist das rot.
#   * Es prueft, ob eine Vorlage (Plandokument) dieselben Zahlen nennt wie das
#     Objekt -- gegen genau die Drift, die den Posten D2-G4 ausgeloest hat.
#
# WAS ES NICHT ZUSICHERT -- ausdruecklich, nicht zugedeckt:
#   * Es sagt NICHTS darueber, ob ein Test etwas Sinnvolles prueft. Es zaehlt
#     Registrierungen, keine Aussagen.
#   * Es wertet die Bedingungen NICHT aus. Ob if(FOO) heute wahr ist, entscheidet
#     der Gegeneingang (--ctest-liste), nicht dieses Skript.
#   * Ohne --ctest-liste gibt es KEIN "erfuellt". Dann ist jede bedingte
#     Registrierung allowlist-pflichtig; das Skript sagt das und rechnet nicht
#     stillschweigend anders.
#   * Es zaehlt Registrierungs-STELLEN, nicht gtest-Faelle. Ein Rumpf in einer
#     Hausfunktion ist EINE Stelle, auch wenn die Funktion dreimal gerufen wird.
#     Die Aufloesung der Aufrufstellen leistet scripts/ci_host_klassen_bericht.sh
#     -- dieses Skript ruft es fuer die HOST-KENNUNG auf und erfindet sie nicht neu.
#
# ---------------------------------------------------------------------------
# DER BEFUND, GEGEN DEN ES GEBAUT IST (am Objekt gemessen, 09.08.2026):
#
# Die Vorlage ##06 verlangte "fuer jeden der 5 STATUS_OUT-Bloecke ein FOUND im
# Configure-Log". Drei Dinge daran tragen nicht:
#
#  1. ZWEI der fuenf Bloecke (_pa_status, _fj_status) liegen hinter
#     if(COMDARE_PRUEFLING_INCLUDE_DIRS) -- einer Variablen, die in ce UND super
#     an KEINER Stelle gesetzt wird (COMDARE_CE_PRUEFLINGE ist ein leerer Cache-
#     Eintrag). Sie erreichen in keinem CI-Baum je ein FOUND. "Jeder Block braucht
#     ein FOUND" waere ein Dauer-Rot.
#  2. Diese zwei Bloecke registrieren UEBERHAUPT KEINEN Test. Sie bauen DLL-
#     Targets. Die Vorlage verwechselte Codegen-Bloecke mit Registrierungen.
#  3. STATUS_OUT deckt nur einen kleinen Teil der bedingten Registrierungen ab.
#     Am Objekt: 18 bedingte Registrierungen unter 14 verschiedenen Bedingungen,
#     davon 3 hinter einem STATUS_OUT-Zustand. Der Rest haengt an Host-ISA,
#     Compiler-Flags, TARGET-Existenz, Datei-Existenz, Messmodus und Pruefling.
#
# Die korrigierte Formel lautet deshalb: ERFUELLT ODER ALLOWLIST MIT BEGRUENDUNG.
# Eine Bedingung, die auf DIESER Maschine unmoeglich ist, darf die Abnahme nicht
# scheitern lassen -- aber sie muss NAMENTLICH MIT BEGRUENDUNG dastehen. Eine
# stille Ausnahme waere wieder ein blindes Gruen.
#
# ---------------------------------------------------------------------------
# NACHSATZ 09.08.2026 -- WARUM DIE ALLOWLIST STELLEN ZAEHLEN MUSS, NICHT NUR
# BEDINGUNGEN NENNEN. (Kritikstufe zu D2-G4; am Objekt mit gewuerfeltem Koeder
# nachgestellt, BEVOR diese Pruefung entstand.)
#
# SELBSTCHECK DIESER AENDERUNG -- was der Abschnitt 6b ZUSICHERT:
#   Je Allowlist-Eintrag stimmt die dort zugesicherte Stellenzahl (stellen=N)
#   mit der im CMake-Quelltext gemessenen Stellenzahl ueberein. Abweichung in
#   BEIDE Richtungen ist ein BEFUND, mit beiden Zahlen und den Stellen namentlich.
# WAS ER NICHT ZUSICHERT:
#   Nichts ueber den PROSA-Text der Begruendung. Steht dort "Deckt 4", waehrend
#   stellen=7 zugesichert ist, faellt das keinem Zaehler auf -- maschinell
#   gebunden ist die ZAHL, nicht der Satz daneben. Und nichts darueber, ob die
#   zugesicherte Zahl SACHLICH richtig gewaehlt war; das entscheidet der Mensch
#   beim Eintragen. Die Wache haelt nur fest, dass sie ab dann stimmen MUSS.
#
# DER BEFUND. Die erste Fassung deckte BEDINGUNGEN. Eine NEUE bedingte
# Registrierung unter einer bereits allowgelisteten Bedingung rutschte damit
# still gruen durch: Koeder (gewuerfelt) 'add_test(NAME test_schleich_<zufall>)'
# hinter if(COMDARE_PRT_ART_LEGACY_AVAILABLE) angehaengt -> EXIT 0,
# allowlist_mit_begruendung stieg 6 -> 7 ohne jedes Signal, obwohl der
# Allowlist-Eintrag woertlich "Deckt 4 Registrierungen" zusichert. Das ist exakt
# die Fehlerklasse "stille Ausnahme", gegen die diese Wache gebaut ist -- sie
# hatte sie in der eigenen Allowlist. Der Wellenplan verlangt fuer W0a woertlich
# "19. Koeder-Registrierung ... wird NAMENTLICH ROT"; fuer diesen Weg hielt die
# gebaute Wache ihre eigene Zusicherung nicht.
#
# DER RESTWEG, DEN --gegen-vorlage NICHT SCHLOSS. Der Marker-Abgleich fing den
# Fall zwar (18 != 19), aber ein im selben Change mitgezogener Marker-Bump
# 18 -> 19 brachte ihn wieder zur Deckung und legalisierte die Schleich-
# Registrierung. Die Zusicherung haengt deshalb NICHT am Marker: sie steht in
# der Allowlist und wird gegen den Quelltext geprueft, Marker hin oder her.
#
# WARUM DIESE PRUEFUNG OHNE BAUVERZEICHNIS AUSKOMMT (und deshalb --nur-zusicherung
# im super-CI heute schon fahrbar ist): die Stellenzahl je Bedingung kommt allein
# aus dem CMake-Quelltext. Sie braucht keinen IST-Nenner, keinen Compiler und
# kein ctest. Der IST-Nenner fehlt der super-CI noch (Posten D2) -- die volle
# Formel bleibt bis dahin baremetal; dieser Teil aber nicht.
#
# WARUM ZWEI VERSCHIEDENE WEGE (T-3 NENNER FREMD):
#   SOLL-Nenner: der CMake-QUELLTEXT. Was dort hinter einem if() steht, ist die
#                Grundmenge. Sie existiert auch dann, wenn nie gebaut wurde.
#   IST-Nenner:  die ctest-Liste eines GEBAUTEN Baums (--ctest-liste, Ausgabe von
#                `ctest -N`). Sie entsteht aus einem Configure-Lauf auf einer
#                bestimmten Maschine.
#   Die beiden Wege teilen kein Werkzeug und keine Datei. Genau deshalb kann der
#   Vergleich etwas finden. Eine Wache, deren Nenner aus derselben Inventur
#   stammt wie ihr Zaehler, kann eine fehlende Registrierung grundsaetzlich nicht
#   bemerken -- das war der Ausloeser von D2.
#
# WARUM DIE HOST-KENNUNG PFLICHT IST (Richtigstellung 09.08.2026):
#   Es gibt zwei bare-metal-Runner (prod1/AMD MIT AVX-512, prod2/Intel OHNE), und
#   die grosse Mehrheit der Jobs floatet zwischen ihnen -- das ist so GEWOLLT;
#   die Maschinen stimmen sich ueber das Lager ab. Die Folgerung ist deshalb
#   NICHT "Jobs pinnen", sondern: eine Zahl ohne Host-Kennung ist eine Zahl ohne
#   Gegenstand. Jede Ausgabe hier traegt die Host-Zeile von
#   ci_host_klassen_bericht.sh.
#   KEINE FESTE PAARUNG AN DIESER STELLE (Nachsatz 09.08. abends): hier stand
#   "44 von 48"; dieselbe Fussnote D2-G4, aus der die Zahl stammt, hatte sie
#   schon auf eine andere Paarung richtiggestellt, und dieser Nachsatz fuegt
#   selbst einen Job hinzu (test:abnahme06-zusicherung). Eine Zahl, die in drei
#   Dateien steht und in einer gepflegt wird, ist in den anderen zweien falsch.
#   Gepflegt wird sie in Fussnote D2-G4 des Wellenplans v2.
#
# AUFRUF:  sh scripts/ci_abnahme06_bedingungs_tabelle.sh [OPTIONEN]
#   --quelle DATEI       CMake-Datei, die gezaehlt wird. Mehrfach angebbar.
#                        Vorgabe: <wurzel>/Code/external/comdare-cache-engine/
#                        tests/unit/CMakeLists.txt
#   --allowlist DATEI    Bedingung<TAB>stellen=N<TAB>Begruendung, eine je Zeile.
#                        '#' = Kommentar. Fehlt eines der drei Felder oder ist
#                        Feld 2 kein stellen=<Zahl>, ist die Zeile keine
#                        Allowlist-Zeile (fail-closed, BEFUND).
#                        Vorgabe: <wurzel>/ci/abnahme06_bedingungs_allowlist.txt
#   --ctest-liste DATEI  Ausgabe von `ctest -N` eines gebauten Baums (IST-Nenner).
#                        Ohne sie ist jede bedingte Registrierung allowlist-pflichtig.
#   --gegen-vorlage DATEI  Plandokument, das die Zahlen nennen MUSS. Verlangt eine
#                        Markerzeile  ABNAHME06-ZAHLEN bedingte_registrierungen=N
#                        bedingungs_klassen=K  und vergleicht sie gegen die Messung.
#   --nur-zusicherung    NUR die Allowlist-Zusicherung pruefen (Abschnitt 6b), die
#                        Formel ##06 NICHT auswerten. Braucht kein Bauverzeichnis
#                        und keinen IST-Nenner -- der Modus, in dem die Wache im
#                        super-CI heute schon fahrbar ist. Mit --ctest-liste
#                        zusammen ist er ein Widerspruch und bricht ab.
#   --ohne-host          Host-Kennung weglassen (nur fuer den Selbsttest).
#
# EXIT:  0 = Formel ##06 erfuellt, Vorlage (falls geprueft) deckt sich mit dem Objekt
#        1 = BEFUND (Registrierung ohne Allowlist-Eintrag, oder Vorlage driftet)
#        2 = konnte nicht zaehlen (fail-closed, ausdruecklich KEIN Gruen)
#
# POSIX-sh, ASCII-only, kein Python (Hausdoktrin).
# =============================================================================

set -eu

QUELLEN=""
ALLOWLIST=""
CTEST_LISTE=""
VORLAGE=""
MIT_HOST=1
NUR_ZUS=0

while [ $# -gt 0 ]; do
    case "$1" in
        --quelle)         QUELLEN="$QUELLEN${QUELLEN:+
}${2:-}"; shift 2 ;;
        --allowlist)      ALLOWLIST="${2:-}"; shift 2 ;;
        --ctest-liste)    CTEST_LISTE="${2:-}"; shift 2 ;;
        --gegen-vorlage)  VORLAGE="${2:-}"; shift 2 ;;
        --nur-zusicherung) NUR_ZUS=1; shift ;;
        --ohne-host)      MIT_HOST=0; shift ;;
        # Kein fester Zeilenbereich: der Kopf waechst, und ein hartes '2,110p'
        # haette --help still abgeschnitten. Gedruckt wird bis zur ersten
        # Nicht-Kommentarzeile.
        --help|-h)        awk 'NR>1 { if ($0 !~ /^#/) exit; print }' "$0"; exit 0 ;;
        *) echo "ABBRUCH: unbekannte Option '$1'. --help zeigt den Aufruf." >&2; exit 2 ;;
    esac
done

# Ein IST-Nenner, der nicht ausgewertet wird, waere eine Zahl ohne Gegenstand.
# Lieber laut abbrechen als stillschweigend ignorieren.
if [ "$NUR_ZUS" -eq 1 ] && [ -n "$CTEST_LISTE" ]; then
    echo "ABBRUCH: --nur-zusicherung wertet die Formel ##06 nicht aus." >&2
    echo "         --ctest-liste waere dabei ohne Gegenstand -- eines von beiden." >&2
    exit 2
fi

# Die Wurzel wird aus dem git-Arbeitsbaum genommen, NICHT aus $0. Ein aus dem
# Skriptpfad abgeleiteter Baum ist die Falle, die ci_diff_ascii_width_guard.sh
# schon einmal den falschen Baum messen liess.
WURZEL=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "ABBRUCH: kein git-Arbeitsbaum -- die Wurzel ist nicht bestimmbar." >&2
    exit 2
}

[ -n "$QUELLEN" ] || QUELLEN="$WURZEL/Code/external/comdare-cache-engine/tests/unit/CMakeLists.txt"
[ -n "$ALLOWLIST" ] || ALLOWLIST="$WURZEL/ci/abnahme06_bedingungs_allowlist.txt"

TMP=$(mktemp -d) || exit 2
trap 'rm -rf "$TMP"' EXIT INT TERM

BEFUND=0

echo "============================================================================="
echo " ABNAHME ##06 -- BEDINGUNGS-TABELLE  (scripts/ci_abnahme06_bedingungs_tabelle.sh)"
echo "============================================================================="

# =============================================================================
#  1. HOST-KENNUNG -- delegiert, nicht neu erfunden
# =============================================================================
# Der Host-Klassen-Bericht (Posten D2-G5) ist die gebaute Quelle fuer die
# Host-Kennung. Ihn hier nachzubauen hiesse, zwei Wahrheiten ueber dieselbe
# Maschine zu haben. Gedruckt wird nur seine HOST-KENNUNG-Zeile.
if [ "$MIT_HOST" -eq 1 ]; then
    if [ -r "$WURZEL/scripts/ci_host_klassen_bericht.sh" ]; then
        # K11: erst in eine Datei, dann rc -- nach einer Pipe misst $? das letzte Glied.
        sh "$WURZEL/scripts/ci_host_klassen_bericht.sh" > "$TMP/hkb.txt" 2>&1 || true
        if grep -q '^HOST-KENNUNG' "$TMP/hkb.txt" 2>/dev/null; then
            sed -n '/^HOST-KENNUNG/,+1p' "$TMP/hkb.txt"
        else
            echo "ABBRUCH: ci_host_klassen_bericht.sh lieferte keine HOST-KENNUNG." >&2
            echo "         Eine Zahl ohne Host-Kennung ist eine Zahl ohne Gegenstand." >&2
            exit 2
        fi
    else
        echo "ABBRUCH: scripts/ci_host_klassen_bericht.sh fehlt -- keine Host-Kennung." >&2
        exit 2
    fi
else
    echo "HOST-KENNUNG   --ohne-host gesetzt (nur Selbsttest; KEINE Abnahme-Ausgabe)"
fi

# =============================================================================
#  2. QUELLEN-KENNUNG -- welcher Stand wurde gezaehlt
# =============================================================================
: > "$TMP/quellen.txt"
printf '%s\n' "$QUELLEN" | while IFS= read -r _q; do
    [ -n "$_q" ] || continue
    printf '%s\n' "$_q"
done > "$TMP/quellen.txt"

N_QUELLEN=$(awk 'END{print NR+0}' "$TMP/quellen.txt")
[ "$N_QUELLEN" -gt 0 ] || { echo "ABBRUCH: keine Quelle angegeben." >&2; exit 2; }

while IFS= read -r _q; do
    [ -n "$_q" ] || continue
    [ -r "$_q" ] || { echo "ABBRUCH: Quelle '$_q' nicht lesbar." >&2; exit 2; }
    _repo=$(git -C "$(dirname "$_q")" rev-parse --short HEAD 2>/dev/null || echo "kein-commit")
    _zeilen=$(awk 'END{print NR+0}' "$_q")
    echo "QUELLE         $_q"
    echo "               stand=$_repo zeilen=$_zeilen"
done < "$TMP/quellen.txt"

# =============================================================================
#  3. ZAEHLUNG -- scope-treu ueber if/elseif/else/endif
# =============================================================================
# Eine Regex auf 'add_test(NAME' reicht NICHT. Genau daran ist die Vorlagen-Zahl
# gescheitert: die drei Registry-Roundtrip-Gates schreiben den NAME auf die
# FOLGEZEILE und waren fuer eine solche Regex unsichtbar -- ausgerechnet die drei,
# deren stille Abschaltung Posten D2-G6 als Defekt fuehrt. Deshalb wird hier die
# Klammer-Struktur verfolgt und nicht nach einem Namen gesucht.
: > "$TMP/reg.txt"
while IFS= read -r _q; do
    [ -n "$_q" ] || continue
    awk -v datei="$_q" '
        # Erst puffern, dann auswerten. Der Puffer ist noetig, weil add_test( den
        # NAME auf einer FOLGEZEILE tragen darf -- genau die Form, die eine
        # einzeilige Regex uebersieht (s. Kopf: daher kam die falsche 15).
        { L[NR] = $0 }
        END {
            depth = 0
            for (n = 1; n <= NR; n++) {
                code = L[n]
                sub(/#.*$/, "", code)
                low = tolower(code)

                if (low ~ /^[ \t]*if[ \t]*\(/) {
                    cond = code
                    sub(/^[ \t]*[Ii][Ff][ \t]*\(/, "", cond)
                    sub(/\)[ \t]*$/, "", cond)
                    depth++
                    stack[depth] = cond
                    continue
                }
                if (low ~ /^[ \t]*elseif[ \t]*\(/) {
                    cond = code
                    sub(/^[ \t]*[Ee][Ll][Ss][Ee][Ii][Ff][ \t]*\(/, "", cond)
                    sub(/\)[ \t]*$/, "", cond)
                    if (depth > 0) stack[depth] = cond
                    continue
                }
                if (low ~ /^[ \t]*else[ \t]*\(/)  { if (depth > 0) stack[depth] = "NOT(" stack[depth] ")"; continue }
                if (low ~ /^[ \t]*endif[ \t]*\(/) { if (depth > 0) { delete stack[depth]; depth-- } continue }

                if (code !~ /comdare_add_test[ \t]*\(/ && code !~ /^[ \t]*add_test[ \t]*\(/) continue
                if (depth == 0) continue

                # Testname, wenn er statisch dasteht. Sonst leer -- ein geratener
                # Name waere ein erfundener Widerspruch.
                name = ""
                if (code ~ /comdare_add_test[ \t]*\(/) {
                    name = code
                    sub(/^.*comdare_add_test[ \t]*\(/, "", name)
                    sub(/[ \t)].*$/, "", name)
                } else if (code ~ /add_test[ \t]*\([ \t]*NAME[ \t]+/) {
                    name = code
                    sub(/^.*add_test[ \t]*\([ \t]*NAME[ \t]+/, "", name)
                    sub(/[ \t)].*$/, "", name)
                } else {
                    # NAME auf einer Folgezeile: hoechstens 4 Zeilen weit, und nur
                    # bis zur ersten schliessenden Klammer. Weiter zu suchen hiesse,
                    # den Namen eines anderen Aufrufs einzusammeln.
                    for (m = n + 1; m <= n + 4 && m <= NR; m++) {
                        nx = L[m]
                        sub(/#.*$/, "", nx)
                        if (nx ~ /^[ \t]*NAME[ \t]+/) {
                            name = nx
                            sub(/^[ \t]*NAME[ \t]+/, "", name)
                            sub(/[ \t)].*$/, "", name)
                            break
                        }
                        if (nx ~ /\)[ \t]*$/) break
                    }
                }
                if (name ~ /\$\{/) name = ""
                ctx = ""
                for (i = 1; i <= depth; i++) ctx = ctx (ctx == "" ? "" : " && ") stack[i]
                printf "%s\t%d\t%s\t%s\n", datei, n, (name == "" ? "-" : name), ctx
            }
            if (depth != 0) printf "%s\t0\tUNBALANCED\tdepth=%d\n", datei, depth
        }
    ' "$_q" >> "$TMP/reg.txt"
done < "$TMP/quellen.txt"

if grep -q '	UNBALANCED	' "$TMP/reg.txt" 2>/dev/null; then
    echo "ABBRUCH: if/endif nicht ausgeglichen -- die Zaehlung waere geraten." >&2
    grep '	UNBALANCED	' "$TMP/reg.txt" >&2
    exit 2
fi

N_BEDINGT=$(awk 'END{print NR+0}' "$TMP/reg.txt")
[ "$N_BEDINGT" -gt 0 ] || {
    echo "ABBRUCH: 0 bedingte Registrierungen gefunden -- das kann nicht stimmen." >&2
    echo "         Nenner 0 ist nie GRUEN (V-1)." >&2
    exit 2
}

# Bedingungs-Klassen = verschiedene Ausdruecke, ueber alle Stellen hinweg.
awk -F'\t' '{n=split($4, teile, / && /); for (i=1;i<=n;i++) print teile[i]}' "$TMP/reg.txt" \
    | sed 's/^ *//;s/ *$//' | grep -v '^$' | sort -u > "$TMP/klassen.txt"
N_KLASSEN=$(awk 'END{print NR+0}' "$TMP/klassen.txt")

N_NAMENLOS=$(awk -F'\t' '$3 == "-"' "$TMP/reg.txt" | awk 'END{print NR+0}')

# =============================================================================
#  4. IST-NENNER -- aus einem GEBAUTEN Baum, anderer Weg als der SOLL-Nenner
# =============================================================================
: > "$TMP/ist_namen.txt"
IST_QUELLE="keine"
if [ -n "$CTEST_LISTE" ]; then
    [ -r "$CTEST_LISTE" ] || { echo "ABBRUCH: --ctest-liste '$CTEST_LISTE' nicht lesbar." >&2; exit 2; }
    # `ctest -N` druckt "  Test  #12: name". Nur der Name interessiert.
    sed -n 's/^[[:space:]]*Test[[:space:]]*#[0-9]*:[[:space:]]*//p' "$CTEST_LISTE" > "$TMP/ist_namen.txt"
    N_IST=$(awk 'END{print NR+0}' "$TMP/ist_namen.txt")
    [ "$N_IST" -gt 0 ] || {
        echo "ABBRUCH: --ctest-liste enthaelt 0 Testnamen -- fail-closed." >&2; exit 2; }
    IST_QUELLE="$CTEST_LISTE ($N_IST Eintraege)"
fi

# =============================================================================
#  5. ALLOWLIST
# =============================================================================
: > "$TMP/allow.txt"
if [ -r "$ALLOWLIST" ]; then
    grep -v '^[[:space:]]*#' "$ALLOWLIST" | grep -v '^[[:space:]]*$' > "$TMP/allow.txt" || true
fi
N_ALLOW_ZEILEN=$(awk 'END{print NR+0}' "$TMP/allow.txt")

# Eine Allowlist-Zeile OHNE Begruendung ist keine Allowlist-Zeile. Fail-closed.
# Seit dem Nachsatz 09.08. gilt dasselbe fuer die fehlende ZUSICHERUNG: ohne
# stellen=N deckt der Eintrag eine BEDINGUNG statt STELLEN, und genau darueber
# ist die Schleich-Registrierung hereingekommen. Das ALTE Zweifeld-Format bricht
# hier absichtlich LAUT -- ein leises Weitergelten waere bequem, nicht richtig.
awk -F'\t' '
    NF < 3                     { print FNR": nur "NF" Feld(er) statt 3: "$0; next }
    $2 !~ /^stellen=[0-9]+$/   { print FNR": Feld 2 ist kein stellen=<Zahl>: ["$2"] fuer "$1; next }
    $3 ~ /^[ \t]*$/            { print FNR": leere Begruendung fuer "$1 }
' "$TMP/allow.txt" > "$TMP/allow_defekt.txt" || :
if [ -s "$TMP/allow_defekt.txt" ]; then
    echo "BEFUND: Allowlist-Zeilen ohne Begruendung oder ohne Zusicherung stellen=N --"
    echo "        eine stille Ausnahme ist wieder ein blindes Gruen:"
    sed 's/^/        /' "$TMP/allow_defekt.txt"
    BEFUND=1
fi

# =============================================================================
#  6. FORMEL ##06 -- erfuellt ODER Allowlist mit Begruendung
# =============================================================================
: > "$TMP/erfuellt.txt"
: > "$TMP/allowgedeckt.txt"
: > "$TMP/offen.txt"

# --nur-zusicherung wertet die Formel NICHT aus: sie braucht einen IST-Nenner,
# den die super-CI heute nicht herstellt (Posten D2). Die Zaehler bleiben dann
# ausdruecklich leer und werden als "nicht ausgewertet" gedruckt, NICHT als 0 --
# eine 0 waere hier eine Behauptung ueber etwas, das gar nicht gemessen wurde.
if [ "$NUR_ZUS" -eq 0 ]; then
while IFS='	' read -r _datei _zeile _name _cond; do
    [ -n "$_datei" ] || continue
    _kurz=$(basename "$_datei")
    if [ "$_name" != "-" ] && [ -s "$TMP/ist_namen.txt" ] \
       && grep -qxF "$_name" "$TMP/ist_namen.txt" 2>/dev/null; then
        printf '%s:%s\t%s\t%s\n' "$_kurz" "$_zeile" "$_name" "$_cond" >> "$TMP/erfuellt.txt"
        continue
    fi
    # Allowlist-Treffer: JEDE Teilbedingung der Stelle muss gedeckt sein.
    _ungedeckt=""
    _rest="$_cond"
    while [ -n "$_rest" ]; do
        case "$_rest" in
            *" && "*) _teil=${_rest%%" && "*}; _rest=${_rest#*" && "} ;;
            *)        _teil="$_rest"; _rest="" ;;
        esac
        _teil=$(printf '%s' "$_teil" | sed 's/^ *//;s/ *$//')
        [ -n "$_teil" ] || continue
        if ! awk -F'\t' -v t="$_teil" '$1 == t {gefunden=1} END{exit gefunden?0:1}' "$TMP/allow.txt"; then
            _ungedeckt="$_ungedeckt${_ungedeckt:+ && }$_teil"
        fi
    done
    if [ -z "$_ungedeckt" ]; then
        printf '%s:%s\t%s\t%s\n' "$_kurz" "$_zeile" "$_name" "$_cond" >> "$TMP/allowgedeckt.txt"
    else
        printf '%s:%s\t%s\t%s\n' "$_kurz" "$_zeile" "$_name" "$_ungedeckt" >> "$TMP/offen.txt"
    fi
done < "$TMP/reg.txt"
fi

N_ERFUELLT=$(awk 'END{print NR+0}' "$TMP/erfuellt.txt")
N_ALLOW=$(awk 'END{print NR+0}' "$TMP/allowgedeckt.txt")
N_OFFEN=$(awk 'END{print NR+0}' "$TMP/offen.txt")

# =============================================================================
#  6b. ZUSICHERUNGS-ABGLEICH -- die Allowlist deckt STELLEN, nicht BEDINGUNGEN
# =============================================================================
# Der Kern des Nachsatzes 09.08. (Begruendung im Kopf). Gemessen wird je
# Allowlist-Eintrag, an WIE VIELEN Registrierungs-STELLEN seine Bedingung im
# Quelltext steht -- und das gegen die Zusicherung stellen=N gehalten.
#
# ZWEI QUELLEN, ZWEI HAENDE (T-3): das SOLL steht in ci/..._allowlist.txt und
# wird von einem Menschen eingetragen; das IST kommt aus dem CMake-Quelltext und
# wird bei jedem Lauf neu gezaehlt. Keine der beiden Zahlen ist aus der anderen
# abgeleitet -- deshalb kann der Vergleich ueberhaupt etwas finden.
#
# BEIDE RICHTUNGEN sind ein BEFUND, nicht nur "zu viele":
#   ist > soll  -- eine Registrierung ist unter eine bestehende Ausnahme
#                  geschoben worden. Das ist der Befund, der hier hereinkam.
#   ist < soll  -- die Ausnahme verspricht mehr, als es gibt. Ihre Begruendung
#                  ("Deckt N Registrierungen") ist ab dann falsch; eine tote
#                  Ausnahme ist eine Zusicherung ohne Gegenstand.
N_ZUS_VERLETZT=0
ZUS_SOLL=0
ZUS_IST=0
: > "$TMP/zus.txt"

while IFS='	' read -r _acond _astellen _agrund; do
    [ -n "$_acond" ] || continue
    case "$_astellen" in
        stellen=*) _soll=${_astellen#stellen=} ;;
        *)         _soll="" ;;
    esac
    # Formatfehler sind in Abschnitt 5 schon namentlich gemeldet und haben
    # BEFUND gesetzt; hier nicht ein zweites Mal, sonst rauscht die Ausgabe zu.
    case "$_soll" in
        ''|*[!0-9]*) continue ;;
    esac
    _ist=$(awk -F'\t' -v k="$_acond" '
        { n = split($4, t, / && /)
          for (i = 1; i <= n; i++) {
              g = t[i]; sub(/^ */, "", g); sub(/ *$/, "", g)
              if (g == k) c++
          } }
        END { print c+0 }' "$TMP/reg.txt")
    ZUS_SOLL=$((ZUS_SOLL + _soll))
    ZUS_IST=$((ZUS_IST + _ist))
    if [ "$_ist" -ne "$_soll" ]; then
        printf '%s\t%s\t%s\n' "$_acond" "$_soll" "$_ist" >> "$TMP/zus.txt"
        N_ZUS_VERLETZT=$((N_ZUS_VERLETZT + 1))
    fi
done < "$TMP/allow.txt"

echo "-----------------------------------------------------------------------------"
echo "ZAHL 1  bedingte_registrierungen=$N_BEDINGT"
echo "        (SOLL-NENNER, aus dem CMake-Quelltext: $N_QUELLEN Datei(en), scope-treu"
echo "         ueber if/elseif/else/endif. Einheit: Registrierungs-STELLEN.)"
echo "ZAHL 2  bedingungs_klassen=$N_KLASSEN"
echo "        (verschiedene if()-Ausdruecke ueber alle Stellen hinweg.)"
if [ "$NUR_ZUS" -eq 1 ]; then
    echo "ZAHL 3  NICHT AUSGEWERTET (--nur-zusicherung)"
    echo "        (Die Formel ##06 braucht einen IST-Nenner. Statt einer 0, die eine"
    echo "         Behauptung ueber Ungemessenes waere, steht hier nichts.)"
else
    echo "ZAHL 3  erfuellt=$N_ERFUELLT  allowlist_mit_begruendung=$N_ALLOW  ohne_allowlist_eintrag=$N_OFFEN"
    echo "        (IST-NENNER: $IST_QUELLE -- anderer Weg als ZAHL 1, T-3.)"
fi
echo "ZAHL 5  allowlist_zusicherung_verletzt=$N_ZUS_VERLETZT" \
     "allowlist_stellen_soll=$ZUS_SOLL allowlist_stellen_ist=$ZUS_IST"
echo "        (Je Allowlist-Eintrag: zugesicherte Stellenzahl gegen die im"
echo "         Quelltext gemessene. Braucht KEIN Bauverzeichnis -- deshalb ist"
echo "         --nur-zusicherung im super-CI schon heute fahrbar.)"
echo "ZAHL 4  name_nicht_statisch=$N_NAMENLOS"
echo "        (Registrierung mit Namen aus einer CMake-Variablen: die STELLE ist"
echo "         gezaehlt, der NAME statisch nicht bestimmbar. Sie kann nie 'erfuellt'"
echo "         werden und ist damit immer allowlist-pflichtig -- ausdruecklich so,"
echo "         ein geratener Name waere ein erfundener Widerspruch.)"
echo "        allowlist_zeilen=$N_ALLOW_ZEILEN"

if [ "$N_OFFEN" -gt 0 ]; then
    echo "-----------------------------------------------------------------------------"
    echo "BEFUND: $N_OFFEN von $N_BEDINGT bedingten Registrierungen sind weder erfuellt"
    echo "        noch mit Begruendung allowgelistet:"
    while IFS='	' read -r _ort _name _cond; do
        printf '        %-46s %-40s %s\n' "$_ort" "$_name" "$_cond"
    done < "$TMP/offen.txt"
    BEFUND=1
fi

if [ "$N_ZUS_VERLETZT" -gt 0 ]; then
    echo "-----------------------------------------------------------------------------"
    echo "BEFUND: $N_ZUS_VERLETZT Allowlist-Eintrag/-Eintraege halten ihre Zusicherung nicht."
    echo "        Eine Ausnahme deckt STELLEN, nicht eine Bedingung. Wer eine neue"
    echo "        Registrierung unter eine bestehende Ausnahme haengt, hat sie NICHT"
    echo "        begruendet -- er hat sie nur versteckt."
    while IFS='	' read -r _zc _zs _zi; do
        printf '        %-46s soll=%s ist=%s\n' "$_zc" "$_zs" "$_zi"
        # Namentlich, sonst bleibt der Befund eine Zahl ohne Gegenstand: alle
        # Stellen unter dieser Bedingung, damit die neue darunter auffindbar ist.
        awk -F'\t' -v k="$_zc" '
            { n = split($4, t, / && /)
              for (i = 1; i <= n; i++) {
                  g = t[i]; sub(/^ */, "", g); sub(/ *$/, "", g)
                  if (g == k) {
                      d = $1; sub(/^.*\//, "", d)
                      printf "            %s:%s  %s\n", d, $2, $3
                  }
              } }' "$TMP/reg.txt"
    done < "$TMP/zus.txt"
    BEFUND=1
fi

echo "-----------------------------------------------------------------------------"
echo "BEDINGUNGS-KLASSEN, namentlich (je Klasse: Stellen-IST, Deckung, Zusicherung):"
while IFS= read -r _k; do
    [ -n "$_k" ] || continue
    _n=$(awk -F'\t' -v k="$_k" '
        { n = split($4, t, / && /)
          for (i = 1; i <= n; i++) {
              g = t[i]; sub(/^ */, "", g); sub(/ *$/, "", g)
              if (g == k) c++
          } }
        END { print c+0 }' "$TMP/reg.txt")
    # Die Zusicherung steht NEBEN der Ist-Zahl, nicht statt ihrer: wer die
    # Tabelle liest, soll beide sehen und selbst nachrechnen koennen.
    _s=$(awk -F'\t' -v t="$_k" '$1 == t { print $2; exit }' "$TMP/allow.txt")
    if [ -n "$_s" ]; then
        _d="allowlist"
    else
        _d="keine-allowlist"
        _s="-"
    fi
    printf '        %-3s %-15s %-12s %s\n' "$_n" "$_d" "$_s" "$_k"
done < "$TMP/klassen.txt"

# =============================================================================
#  7. VORLAGEN-ABGLEICH -- treibt die Textkorrektur D2-G4
# =============================================================================
# Ohne diesen Abschnitt bleibt jede Plan-Zahl eine Behauptung, die nur beim
# Schreiben einmal stimmte. Der Marker macht sie pruefbar.
if [ -n "$VORLAGE" ]; then
    echo "-----------------------------------------------------------------------------"
    [ -r "$VORLAGE" ] || { echo "ABBRUCH: --gegen-vorlage '$VORLAGE' nicht lesbar." >&2; exit 2; }
    echo "VORLAGEN-ABGLEICH  $VORLAGE"
    if ! grep -q 'ABNAHME06-ZAHLEN' "$VORLAGE" 2>/dev/null; then
        echo "BEFUND: die Vorlage nennt KEINE Markerzeile 'ABNAHME06-ZAHLEN'."
        echo "        Eine Abnahme, deren Zahlen nirgends nachpruefbar stehen, ist keine"
        echo "        Abnahme. Erwartet wird eine Zeile der Form:"
        echo "        ABNAHME06-ZAHLEN bedingte_registrierungen=$N_BEDINGT bedingungs_klassen=$N_KLASSEN"
        BEFUND=1
    else
        _vr=$(sed -n 's/.*ABNAHME06-ZAHLEN[^=]*bedingte_registrierungen=\([0-9][0-9]*\).*/\1/p' "$VORLAGE" | head -1)
        _vk=$(sed -n 's/.*ABNAHME06-ZAHLEN.*bedingungs_klassen=\([0-9][0-9]*\).*/\1/p' "$VORLAGE" | head -1)
        [ -n "$_vr" ] || _vr="fehlt"
        [ -n "$_vk" ] || _vk="fehlt"
        echo "        Vorlage sagt: bedingte_registrierungen=$_vr bedingungs_klassen=$_vk"
        echo "        Objekt sagt:  bedingte_registrierungen=$N_BEDINGT bedingungs_klassen=$N_KLASSEN"
        if [ "$_vr" != "$N_BEDINGT" ] || [ "$_vk" != "$N_KLASSEN" ]; then
            echo "BEFUND: die Vorlage driftet gegen das Objekt. Das ist genau die Klasse,"
            echo "        gegen die D2-G4 gebaut ist: ein korrekt gebautes Paket wuerde"
            echo "        gegen die falsche Zusicherung geprueft und wuerde gruen."
            BEFUND=1
        else
            echo "        Deckung: ja."
        fi
    fi
fi

echo "============================================================================="
if [ "$BEFUND" -ne 0 ]; then
    echo "ERGEBNIS: BEFUND -- s. oben. Kein Gruen."
elif [ "$NUR_ZUS" -eq 1 ]; then
    # Ausdruecklich KEIN "Formel ##06 erfuellt": geprueft ist hier nur die
    # Zusicherung. Wer diesen Lauf als ##06-Abnahme zitiert, zitiert falsch.
    echo "ERGEBNIS: Zusicherung gehalten. $ZUS_IST von $ZUS_SOLL zugesicherten Stellen"
    echo "          gedeckt, $N_ALLOW_ZEILEN Allowlist-Zeile(n), $N_BEDINGT bedingte"
    echo "          Registrierungen in $N_KLASSEN Klassen. Die FORMEL ##06 ist damit"
    echo "          NICHT abgenommen -- dafuer fehlt der IST-Nenner (Posten D2)."
else
    echo "ERGEBNIS: Formel ##06 erfuellt.  $N_ERFUELLT erfuellt + $N_ALLOW allowgelistet"
    echo "          = $N_BEDINGT von $N_BEDINGT bedingten Registrierungen, $N_KLASSEN Klassen."
    echo "          Zusicherung gehalten: $ZUS_IST von $ZUS_SOLL zugesicherten Stellen."
fi
echo "============================================================================="
exit "$BEFUND"
