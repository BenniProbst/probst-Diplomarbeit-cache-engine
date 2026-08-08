#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  HOST-KLASSEN-BERICHT  --  wie viele ctest-Registrierungen dieses Bauwegs
#  haengen an der ISA der Maschine, auf der gerade gebaut wird?  (D2-G5)
#  GOAL v8 Teil VII/VIII, TDD-Vertrag T-2/T-3/T-4/T-5.  2026-08-08
# =============================================================================
#
# DER BEFUND, GEGEN DEN ER GEBAUT IST (am Objekt gemessen, 08.08.2026):
#
# 1. Der Wellenplan (docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-...:113) sagt
#    "6 von 428 Tests registrieren sich nur auf AVX-512-Hosts". Nachgezaehlt am
#    Objekt sind das ZWEI verschiedene Zahlen fuer ZWEI verschiedene Host-Klassen:
#      * SECHS ctest-Registrierungen haengen ueberhaupt an einer Host-ISA,
#      * davon VIER an AVX-512F, die restlichen ZWEI nur an AVX2.
#    Eine Maschine mit AVX2 ohne AVX-512 (prod2/Raptor Lake, AVX-512 fused off)
#    verliert also 4 Registrierungen, eine ganz ohne AVX 6. "6 nur auf
#    AVX-512-Hosts" ist als Satz falsch -- die 6 ist die Summe ueber die ganze
#    Leiter, nicht die AVX-512-Stufe. Genau deshalb ist die Untergrenze
#    ZWEISTUFIG und nicht eine Zahl.
#
# 2. Die einzige Stelle im super-Baum, die bisher eine Test-Gesamtzahl NANNTE,
#    war ein Makefile-Kommentar ("610 registrierte Tests ... davon 186 mit Label
#    da_unit"). Zwei Zahlen ohne Nenner, ohne Host-Klasse, ohne Quelle und ohne
#    irgendetwas, das sie morgen noch richtig haelt. Auf einer Maschine ohne
#    AVX-512 waeren es andere Zahlen, und nichts haette es gesagt.
#
# WAS ER TUT. Er zaehlt die ctest-REGISTRIERUNGEN im CMake-Quelltext des
# gesamten Bauwegs (super + eingebundene Submodule) und ordnet jede einer
# Host-Klasse zu. Der Nenner wird bei jedem Lauf NEU AUSGERECHNET; es gibt in
# diesem Skript keine Konstante fuer eine Test- oder Registrierungszahl.
#
# DIE DREI ZAHLEN -- immer gedruckt, auch im Gutfall (T-2: Aussage, nicht
# Anwesenheit; ohne Nenner ist jede von ihnen ein Stellvertreter):
#   1  registrierungen_gesamt        der NENNER: alle Registrierungen des Bauwegs
#   2  isa_gattiert_gesamt           davon host-ISA-abhaengig, je Stufe getrennt
#   3  untergrenze_registrierungen   was auf DIESER Host-Klasse uebrig bleibt
#
# DIE KLASSEN-LEITER (zweistufig):
#   avx512f  >  avx2  >  basis
#   Eine Registrierung hinter COMDARE_HOST_RUNS_AVX512F verlangt Stufe avx512f,
#   eine hinter COMDARE_HOST_RUNS_AVX2 Stufe avx2. Ein Block if(A AND B) verlangt
#   die HOECHSTE der genannten Stufen.
#
# WARUM DER QUELLTEXT UND NICHT ctest -N: `ctest -N` zaehlt EINTRAEGE eines
# GEBAUTEN Baums und beantwortet die Frage "was fehlt auf dieser Maschine"
# grundsaetzlich nicht -- was nie registriert wurde, fehlt dort lautlos. Die
# Grundgesamtheit muss aus einer ANDEREN Quelle kommen als aus dem Ergebnis
# (T-3). Diese andere Quelle ist der Quelltext. Wer den gebauten Baum dagegen
# halten will, gibt --ctest-liste an: dann wird je NAME verglichen (T-4).
#
# EINHEIT, ausdruecklich benannt: gezaehlt werden REGISTRIERUNGS-AUFRUFE, nicht
# gtest-Faelle. Ein gtest_discover_tests(X) ist EINE Registrierung, die nach dem
# Bau in N ctest-Eintraege expandiert. Die ctest-Gesamtzahl ist deshalb KEIN
# gueltiger Vergleichswert -- verglichen wird je NAME. (Gleiche Zaehlweise wie
# die Schwester-Wache ce scripts/ci_test_sichtbarkeit_wache.sh.)
#
# AUFRUF:  sh scripts/ci_host_klassen_bericht.sh [OPTIONEN]
#   --wurzel PFAD        Baum, der gezaehlt wird (Vorgabe: dieses Repo)
#   --klasse KLASSE      Host-Klasse VORGEBEN statt messen (avx512f|avx2|basis).
#                        Fuer den Selbsttest und um die Untergrenze einer
#                        FREMDEN Maschine vorauszurechnen. Die Ausgabe sagt
#                        dann quelle=vorgabe statt quelle=/proc/cpuinfo.
#   --ctest-liste DATEI  Ausgabe von `ctest -N` eines gebauten Baums als
#                        GEGENEINGANG: jede namentlich aufloesbare ISA-Registrierung
#                        muss darin genau dann stehen, wenn die Klasse sie traegt.
#
# EXIT:  0 = Bericht erstellt, kein Widerspruch
#        1 = BEFUND (unbekanntes ISA-Gatter, negiertes ISA-Gatter, oder der
#            Gegeneingang widerspricht der Klassen-Leiter)
#        2 = konnte nicht zaehlen (fail-closed, ausdruecklich KEIN Gruen)
#
# POSIX-sh, ASCII-only, kein Python (Hausdoktrin).
# =============================================================================

set -eu

WURZEL=""
KLASSE_VORGABE=""
CTEST_LISTE=""

while [ $# -gt 0 ]; do
    case "$1" in
        --wurzel)       WURZEL="${2:-}"; shift 2 ;;
        --klasse)       KLASSE_VORGABE="${2:-}"; shift 2 ;;
        --ctest-liste)  CTEST_LISTE="${2:-}"; shift 2 ;;
        --help|-h)      sed -n '2,80p' "$0"; exit 0 ;;
        *) echo "ABBRUCH: unbekannte Option '$1'. --help zeigt den Aufruf." >&2; exit 2 ;;
    esac
done

if [ -z "$WURZEL" ]; then
    WURZEL=$(git rev-parse --show-toplevel 2>/dev/null) || {
        echo "ABBRUCH: kein git-Arbeitsbaum -- die Wurzel ist nicht bestimmbar." >&2
        echo "         (Sie aus \$0 abzuleiten waere die Falle, die bei" >&2
        echo "          ci_diff_ascii_width_guard.sh schon einmal den falschen Baum mass.)" >&2
        exit 2
    }
fi
[ -d "$WURZEL" ] || { echo "ABBRUCH: '$WURZEL' ist kein Verzeichnis." >&2; exit 2; }
WURZEL=$(cd "$WURZEL" && pwd -P) || exit 2
git -C "$WURZEL" rev-parse --git-dir >/dev/null 2>&1 || {
    echo "ABBRUCH: '$WURZEL' ist kein git-Baum -- die Dateiliste waere geraten." >&2; exit 2; }

TMP=$(mktemp -d) || exit 2
trap 'rm -rf "$TMP"' EXIT INT TERM

BEFUND=0

# =============================================================================
#  1. HOST-KENNUNG
# =============================================================================
# Quelle: /proc/cpuinfo. Sie ist die Liste, die der KERNEL aus CPUID gebildet
# hat -- unabhaengig vom Compiler, der im Bau die check_cxx_source_runs-Probe
# faehrt. Genau diese Unabhaengigkeit prueft der Selbsttest (Fall O1) gegen eine
# selbst uebersetzte __builtin_cpu_supports-Probe.
KLASSE_QUELLE="/proc/cpuinfo"
if [ -n "$KLASSE_VORGABE" ]; then
    case "$KLASSE_VORGABE" in
        avx512f|avx2|basis) HOST_KLASSE="$KLASSE_VORGABE"; KLASSE_QUELLE="vorgabe" ;;
        *) echo "ABBRUCH: --klasse '$KLASSE_VORGABE' unbekannt (avx512f|avx2|basis)." >&2; exit 2 ;;
    esac
elif [ -r /proc/cpuinfo ]; then
    # -F: die Muster tragen keine Regex-Absicht, und ugrep (das /usr/bin/grep
    # dieser Maschine ist) hat mit -P schon still 0 geliefert.
    if grep -qF ' avx512f ' /proc/cpuinfo 2>/dev/null; then HOST_KLASSE=avx512f
    elif grep -qF ' avx2 ' /proc/cpuinfo 2>/dev/null; then HOST_KLASSE=avx2
    else HOST_KLASSE=basis
    fi
else
    echo "ABBRUCH: /proc/cpuinfo nicht lesbar und keine --klasse gegeben." >&2
    echo "         Eine geratene Host-Klasse waere schlimmer als keine." >&2
    exit 2
fi

case "$HOST_KLASSE" in
    avx512f) HOST_RANG=2 ;;
    avx2)    HOST_RANG=1 ;;
    *)       HOST_RANG=0 ;;
esac

CPU_MODELL=$(sed -n 's/^model name[[:space:]]*:[[:space:]]*//p' /proc/cpuinfo 2>/dev/null | head -1)
[ -n "$CPU_MODELL" ] || CPU_MODELL="unbekannt"

echo "============================================================================="
echo " HOST-KLASSEN-BERICHT   (scripts/ci_host_klassen_bericht.sh)"
echo "============================================================================="
echo "HOST-KENNUNG   maschine=$(uname -n) arch=$(uname -m) host_klasse=$HOST_KLASSE quelle=$KLASSE_QUELLE"
echo "               cpu='$CPU_MODELL'"

# =============================================================================
#  2. BAUM-KENNUNG  --  welcher Stand wurde gezaehlt
# =============================================================================
# Ohne diese Zeilen waere jede Zahl unten eine Zahl ohne Zustand. Ein Submodul,
# dessen Arbeitsbaum NICHT auf dem gitlink steht, ist genau der Fall, in dem
# eine richtige Messung am falschen Gegenstand entsteht.
SUPER_SHA=$(git -C "$WURZEL" rev-parse --short HEAD 2>/dev/null || echo "kein-commit")
echo "BAUM-KENNUNG   wurzel=$SUPER_SHA"

: > "$TMP/dateien.txt"
: > "$TMP/submodule.txt"

# CMake-Dateien der Wurzel. ext/ ist ueberall ausgeschlossen -- dort liegt
# vendorierter Fremdcode (googletest, snmalloc, mimalloc ...), dessen add_test
# nicht Teil dieses Bauwegs ist. Der Ausschluss steht HIER und nicht in einer
# Allowlist, weil er eine Eigenschaft des Verzeichnisses ist.
git -C "$WURZEL" ls-files -z '*CMakeLists.txt' '*.cmake' 2>/dev/null \
    | tr '\0' '\n' | grep -v '^ext/' \
    | awk -v w="$WURZEL" 'NF{print w "/" $0}' >> "$TMP/dateien.txt" || true

# Submodule aus .gitmodules -- KEINE handgepflegte Liste, sonst driftet sie.
if [ -f "$WURZEL/.gitmodules" ]; then
    git -C "$WURZEL" config --file "$WURZEL/.gitmodules" --get-regexp '^submodule\..*\.path$' 2>/dev/null \
        | awk '{print $2}' | awk 1 >> "$TMP/submodule.txt" || true
fi

while IFS= read -r _sp; do
    [ -n "$_sp" ] || continue
    _sd="$WURZEL/$_sp"
    # NICHT nur `rev-parse --git-dir`: bei einem LEEREN Submodul-Verzeichnis
    # laeuft git nach oben und antwortet fuer das ELTERN-Repo. Der Bericht
    # haette dann den super-SHA als Submodul-Stand gedruckt (erster Lauf am
    # 08.08. tat genau das) -- eine richtige Messung am falschen Gegenstand.
    _top=$(git -C "$_sd" rev-parse --show-toplevel 2>/dev/null || echo "")
    if [ "$_top" != "$_sd" ]; then
        echo "               submodul=$_sp stand=NICHT-AUSGECHECKT (nicht mitgezaehlt)"
        continue
    fi
    _ist=$(git -C "$_sd" rev-parse --short HEAD 2>/dev/null || echo "?")
    _soll=$(git -C "$WURZEL" ls-tree HEAD -- "$_sp" 2>/dev/null | awk '{print substr($3,1,7)}')
    [ -n "$_soll" ] || _soll="?"
    if [ "$_ist" = "$_soll" ]; then
        echo "               submodul=$_sp stand=$_ist (== gitlink)"
    else
        echo "               submodul=$_sp stand=$_ist ABWEICHUNG gitlink=$_soll"
        echo "               ^ gezaehlt wird der ARBEITSBAUM, nicht der deklarierte Stand."
    fi
    # ext/ traegt vendorierten Fremdcode (googletest, snmalloc, mimalloc ...).
    # Dessen add_test-Aufrufe sind nicht Teil unseres Bauwegs. Der Ausschluss ist
    # ein SCHNITT mit Begruendung, kein Zudecken -- gleiche Linie wie die
    # Schwester-Wache im ce-Repo.
    git -C "$_sd" ls-files -z '*CMakeLists.txt' '*.cmake' 2>/dev/null \
        | tr '\0' '\n' | grep -v '^ext/' \
        | awk -v w="$_sd" 'NF{print w "/" $0}' >> "$TMP/dateien.txt" || true
done < "$TMP/submodule.txt"

N_DATEIEN=$(awk 'END{print NR+0}' "$TMP/dateien.txt")
[ "$N_DATEIEN" -gt 0 ] || {
    echo "ABBRUCH: 0 CMake-Dateien gefunden -- das kann nicht stimmen." >&2; exit 2; }

# =============================================================================
#  3. DURCHGANG 1 -- welche Hausfunktion registriert wie viele Tests?
# =============================================================================
# Eine Registrierung im RUMPF einer Funktion passiert nicht dort, sondern an
# jeder Aufrufstelle. Ohne diesen Durchgang zaehlte der Bericht die Definition
# einmal und die (in der ce dreistelligen) Aufrufe gar nicht.
#
# Ausgabe je Funktion:  <name> <registrierungen> <namenstreu 0|1>
# NAMENSTREU=1 heisst: der Rumpf macht GENAU EIN add_test, und dessen NAME ist
# der ERSTE PARAMETER der Funktion. Nur dann ist das erste Argument einer
# Aufrufstelle wirklich der Testname. Bei comdare_add_simd_dispatch_test ist es
# das NICHT -- dort ist das erste Argument ein Suffix, aus dem der Name erst
# zusammengesetzt wird. Wer diesen Unterschied nicht macht, vergleicht spaeter
# im Gegeneingang "_avx512" gegen eine Testnamensliste und meldet einen
# Widerspruch, den es nicht gibt. (Erster Lauf am 08.08. tat genau das.)
# shellcheck disable=SC2016
awk '
    FNR == 1 { infunc = 0 }
    /^[ \t]*#/ { next }
    /^[ \t]*(function|macro)[ \t]*\(/ {
        if (infunc == 0) {
            kopf = $0
            sub(/^[ \t]*(function|macro)[ \t]*\(/, "", kopf)
            sub(/\).*$/, "", kopf)
            gsub(/"/, "", kopf)
            nfeld = split(kopf, kf, /[ \t]+/)
            fname = kf[1]; param1 = (nfeld >= 2 ? kf[2] : "")
            cnt = 0; treu = 0; addcnt = 0; infunc = 1
        }
        next
    }
    /^[ \t]*(endfunction|endmacro)[ \t]*\(/ {
        if (infunc == 1 && cnt > 0)
            print fname " " cnt " " ((cnt == 1 && addcnt == 1 && treu == 1) ? 1 : 0)
        infunc = 0; next
    }
    infunc == 1 && /^[ \t]*gtest_discover_tests[ \t]*\(/ { cnt++; next }
    infunc == 1 && /^[ \t]*add_test[ \t]*\(/ {
        cnt++; addcnt++
        rumpf = $0
        # add_test(NAME ...) darf mehrzeilig sein -- die naechsten Zeilen
        # mitlesen, bis NAME gefunden oder die Klammer zu ist.
        while (rumpf !~ /NAME[ \t]/ && rumpf !~ /\)[ \t]*$/ && (getline nz) > 0) rumpf = rumpf " " nz
        if (param1 != "" && match(rumpf, /NAME[ \t]+\$\{[A-Za-z0-9_]+\}/)) {
            nm = substr(rumpf, RSTART, RLENGTH)
            sub(/^NAME[ \t]+\$\{/, "", nm); sub(/\}$/, "", nm)
            if (nm == param1) treu = 1
        }
        next
    }
' $(cat "$TMP/dateien.txt") > "$TMP/hausfunktionen.txt" || {
    echo "ABBRUCH: Durchgang 1 (Hausfunktionen) gescheitert." >&2; exit 2; }

N_HAUSFUNKTIONEN=$(awk 'END{print NR+0}' "$TMP/hausfunktionen.txt")

# =============================================================================
#  4. DURCHGANG 2 -- jede Registrierungsstelle mit ihrer ISA-Bedingung
# =============================================================================
# Ausgabeformat je Stelle (eine Zeile):
#   RANG <n> GEWICHT <n> NEG <0|1> NAME <name|?> ORT <datei>:<zeile> ISA <liste>
# RANG = hoechste geforderte Stufe (0 basis, 1 avx2, 2 avx512f, -1 unbekannt).
# shellcheck disable=SC2016
awk -v hausdatei="$TMP/hausfunktionen.txt" '
    BEGIN {
        while ((getline z < hausdatei) > 0) {
            split(z, hf, " ")
            if (hf[1] != "") { haus[hf[1]] = hf[2] + 0; treu[hf[1]] = hf[3] + 0 }
        }
        close(hausdatei)
        rang["COMDARE_HOST_RUNS_AVX512F"] = 2
        rang["COMDARE_HOST_RUNS_AVX2"]    = 1
    }
    function klammern(s,   i, c, o) {
        o = 0
        for (i = 1; i <= length(s); i++) {
            c = substr(s, i, 1)
            if (c == "(") o++
            else if (c == ")") o--
        }
        return o
    }
    # Sammelt einen (moeglicherweise mehrzeiligen) Aufruf ein, bis die Klammern
    # ausgeglichen sind. Das ist die Stelle, an der eine reine ZEILEN-Regex
    # blind waere -- add_test(\n NAME x \n COMMAND y) hat heute real drei Tests
    # aus einem SOLL verschwinden lassen.
    function volltext(erste,   t, o, z) {
        t = erste; o = klammern(erste)
        while (o > 0 && (getline z) > 0) {
            if (z ~ /^[ \t]*#/) continue
            t = t " " z; o += klammern(z)
        }
        return t
    }
    function isa_aus(text,   rest, n, feld, aus) {
        aus = ""; rest = text
        while (match(rest, /COMDARE_HOST_RUNS_[A-Z0-9_]+/)) {
            feld = substr(rest, RSTART, RLENGTH)
            if (index(" " aus " ", " " feld " ") == 0) aus = (aus == "" ? feld : aus " " feld)
            rest = substr(rest, RSTART + RLENGTH)
        }
        return aus
    }
    # Liefert den Testnamen NUR dann, wenn er 1:1 einem ctest-Eintrag entspricht.
    # In allen anderen Faellen "?" -- ein geratener Name waere im Gegeneingang
    # ein erfundener Widerspruch.
    #   add_test  -> NAME-Argument, 1:1
    #   gtest     -> "?": gtest_discover_tests expandiert in VIELE ctest-Namen
    #                (suite.fall), der Zielname ist keiner davon
    #   haus:X    -> erstes Argument, aber nur wenn X namenstreu ist
    function name_aus(text, art,   t) {
        t = text
        if (art == "add_test") {
            if (match(t, /NAME[ \t]+[^ \t)]+/)) {
                t = substr(t, RSTART + 5, RLENGTH - 5)
                sub(/^[ \t]+/, "", t)
                return t
            }
            return "?"
        }
        if (art == "gtest") return "?"
        if (treu[substr(art, 6)] != 1) return "?"
        sub(/^[ \t]*[A-Za-z0-9_]+[ \t]*\(/, "", t)
        sub(/^[ \t]*/, "", t)
        sub(/[ \t)].*$/, "", t)
        gsub(/"/, "", t)
        return (t == "" ? "?" : t)
    }
    FNR == 1 { tiefe = 0; infunc = 0; datei = FILENAME }
    /^[ \t]*#/ { next }
    /^[ \t]*(function|macro)[ \t]*\(/ { if (infunc == 0) infunc = 1; next }
    /^[ \t]*(endfunction|endmacro)[ \t]*\(/ { infunc = 0; next }
    infunc == 1 { next }
    /^[ \t]*if[ \t]*\(/ {
        t = volltext($0)
        tiefe++
        bed[tiefe] = isa_aus(t); negiert[tiefe] = 0
        next
    }
    /^[ \t]*elseif[ \t]*\(/ {
        t = volltext($0)
        if (tiefe > 0) { bed[tiefe] = isa_aus(t); negiert[tiefe] = 0 }
        next
    }
    /^[ \t]*else[ \t]*\(/ {
        if (tiefe > 0 && bed[tiefe] != "") negiert[tiefe] = 1
        next
    }
    /^[ \t]*endif[ \t]*\(/ { if (tiefe > 0) { bed[tiefe] = ""; negiert[tiefe] = 0; tiefe-- } next }
    {
        art = ""
        if ($0 ~ /^[ \t]*add_test[ \t]*\(/)                  art = "add_test"
        else if ($0 ~ /^[ \t]*gtest_discover_tests[ \t]*\(/) art = "gtest"
        else {
            k = $0
            sub(/^[ \t]*/, "", k); sub(/[ \t]*\(.*$/, "", k)
            if (k != "" && (k in haus)) art = "haus:" k
        }
        if (art == "") next

        zeilennr = FNR
        t = volltext($0)

        gewicht = 1
        if (art ~ /^haus:/) { fn = substr(art, 6); gewicht = haus[fn] }

        # ISA-Bedingungen: aus allen umschliessenden if-Ebenen UND aus den
        # Argumenten des Aufrufs selbst (die Hausfunktionen der ce nehmen das
        # Host-Ergebnis als PARAMETER -- eine reine if-Betrachtung waere blind).
        isa = ""; neg = 0
        for (i = 1; i <= tiefe; i++) {
            if (bed[i] == "") continue
            if (negiert[i] == 1) { neg = 1; continue }
            n = split(bed[i], f, " ")
            for (j = 1; j <= n; j++)
                if (index(" " isa " ", " " f[j] " ") == 0) isa = (isa == "" ? f[j] : isa " " f[j])
        }
        if (art ~ /^haus:/) {
            arg = isa_aus(t)
            if (arg != "") {
                n = split(arg, f, " ")
                for (j = 1; j <= n; j++)
                    if (index(" " isa " ", " " f[j] " ") == 0) isa = (isa == "" ? f[j] : isa " " f[j])
            }
        }

        r = 0
        if (isa != "") {
            n = split(isa, f, " ")
            for (j = 1; j <= n; j++) {
                rr = (f[j] in rang) ? rang[f[j]] : -1
                if (rr == -1) { r = -1; break }
                if (rr > r) r = rr
            }
        }
        nm = name_aus(t, art)
        if (nm == "?" && art ~ /^haus:/) nm = "?" substr(art, 6) "()"
        printf "RANG %d GEWICHT %d NEG %d NAME %s ORT %s:%d ISA %s\n",
               r, gewicht, neg, nm, datei, zeilennr, (isa == "" ? "-" : isa)
    }
' $(cat "$TMP/dateien.txt") > "$TMP/stellen.txt" || {
    echo "ABBRUCH: Durchgang 2 (Registrierungsstellen) gescheitert." >&2; exit 2; }

# =============================================================================
#  5. DIE DREI ZAHLEN
# =============================================================================
awk -v hostrang="$HOST_RANG" '
    { r = $2 + 0; g = $4 + 0; neg = $6 + 0; nm = $8 }
    { gesamt += g }
    r > 0  { isa += g }
    r == 2 { a512 += g }
    r == 1 { a2 += g }
    r == -1 { unbek += g }
    r > hostrang || r == -1 { abwesend += g }
    neg == 1 { negiert += g }
    nm ~ /\$\{/ { variabel += g }
    nm ~ /^\?/  { nichteins += g }
    END {
        printf "gesamt=%d isa=%d a512=%d a2=%d unbek=%d abwesend=%d negiert=%d variabel=%d nichteins=%d stellen=%d\n",
               gesamt+0, isa+0, a512+0, a2+0, unbek+0, abwesend+0, negiert+0, variabel+0, nichteins+0, NR
    }
' "$TMP/stellen.txt" > "$TMP/zahlen.txt"

# shellcheck disable=SC2046
eval $(sed 's/\([a-z0-9]*\)=/Z_\1=/g' "$TMP/zahlen.txt")

# FAIL-CLOSED: null Registrierungen sind in diesem Baum unmoeglich. Wer hier
# eine 0 durchlaesst und trotzdem "kein Widerspruch" druckt, hat die stille Null
# gebaut, gegen die der ganze Bericht steht.
[ "$Z_gesamt" -gt 0 ] || {
    echo "ABBRUCH: 0 Registrierungen in $N_DATEIEN CMake-Dateien gefunden -- das kann nicht" >&2
    echo "         stimmen. Eine Null ohne Ursache ist kein Ergebnis." >&2
    exit 2
}

Z_untergrenze=$((Z_gesamt - Z_abwesend))

echo "-----------------------------------------------------------------------------"
echo "ZAHL 1  registrierungen_gesamt=$Z_gesamt"
echo "        (NENNER, aus dem CMake-Quelltext: $N_DATEIEN Dateien, $Z_stellen Registrierungsstellen,"
echo "         $N_HAUSFUNKTIONEN registrierende Hausfunktionen aufgeloest. Einheit: Registrierungen,"
echo "         NICHT gtest-Faelle.)"
echo "ZAHL 2  isa_gattiert_gesamt=$Z_isa  isa_gattiert_avx512f=$Z_a512  isa_gattiert_avx2=$Z_a2"
echo "        (Leiter-Stufen, disjunkt: avx512f = verlangt AVX-512F, avx2 = verlangt hoechstens AVX2.)"
echo "ZAHL 3  untergrenze_registrierungen=$Z_untergrenze  abwesend_diese_klasse=$Z_abwesend"
echo "        (fuer host_klasse=$HOST_KLASSE; = ZAHL 1 minus was diese Klasse nicht traegt.)"
echo "-----------------------------------------------------------------------------"
echo "ZWEISTUFIGE UNTERGRENZE ueber die ganze Leiter -- derselbe Baum, drei Klassen:"
echo "        klasse=avx512f  untergrenze=$Z_gesamt   abwesend=0"
echo "        klasse=avx2     untergrenze=$((Z_gesamt - Z_a512))   abwesend=$Z_a512"
echo "        klasse=basis    untergrenze=$((Z_gesamt - Z_a512 - Z_a2))   abwesend=$((Z_a512 + Z_a2))"
echo "-----------------------------------------------------------------------------"
echo "GRENZEN DIESER ZAEHLUNG -- benannt, nicht zugedeckt:"
echo "        namen_variabel=$Z_variabel  (Registrierung mit Namen aus einer CMake-Variablen, typisch"
echo "        foreach ueber eine Ziel-Liste: die STELLE ist gezaehlt, der NAME statisch nicht bestimmbar."
echo "        Wer ihn aufloesen will, braucht cmake --trace, keine schaerfere Regex.)"
echo "        namen_nicht_1zu1=$Z_nichteins  (gtest_discover_tests-Stellen und Hausfunktionen, deren"
echo "        Testname NICHT ihr erstes Argument ist: eine Registrierung, aber KEIN gleichnamiger"
echo "        ctest-Eintrag. Beide Gruppen zaehlen im Nenner mit und sind vom --ctest-liste-"
echo "        Gegeneingang ausgenommen -- ein geratener Name waere ein erfundener Widerspruch.)"
echo "        Nicht-Host-Optionen (COMDARE_BUILD_TESTS, COMDARE_V32_ENABLE, Compiler-Flag-Gatter"
echo "        COMDARE_CXX_HAS_*) werden NICHT ausgewertet: der Nenner ist der Bauweg im Quelltext,"
echo "        nicht eine konkrete Konfiguration. Fuer die KLASSEN-DIFFERENZ ist das ohne Wirkung,"
echo "        weil ein Options-Gatter auf allen Host-Klassen gleich wirkt."

# -- ISA-Stellen namentlich, immer (das ist die Rechenschaft, nicht die Zahl) --
if [ "$Z_isa" -gt 0 ] || [ "$Z_unbek" -gt 0 ]; then
    echo "-----------------------------------------------------------------------------"
    echo "ISA-GATTIERTE REGISTRIERUNGEN, namentlich:"
    awk -v w="$WURZEL/" '
        $2 + 0 != 0 {
            r = $2 + 0
            stufe = (r == 2 ? "avx512f" : (r == 1 ? "avx2" : "UNBEKANNT"))
            ort = $10; sub(w, "", ort)
            printf "        %-9s %-44s %s   [%s]\n", stufe, $8, ort, substr($0, index($0, " ISA ") + 5)
        }
    ' "$TMP/stellen.txt" | sort
fi

# =============================================================================
#  6. BEFUNDE
# =============================================================================
if [ "$Z_unbek" -gt 0 ]; then
    echo "-----------------------------------------------------------------------------"
    echo "BEFUND: $Z_unbek Registrierung(en) haengen an einem ISA-Gatter, das die Klassen-Leiter"
    echo "        dieses Berichts NICHT kennt. Jede Untergrenze oben waere fuer diese Stellen"
    echo "        geraten. Die Leiter gehoert erweitert -- nicht das Gatter entfernt:"
    awk '$2 + 0 == -1 {
        printf "        %s   %s\n", $10, substr($0, index($0, " ISA ") + 5)
    }' "$TMP/stellen.txt" | sort -u
    BEFUND=1
fi

if [ "$Z_negiert" -gt 0 ]; then
    echo "-----------------------------------------------------------------------------"
    echo "BEFUND: $Z_negiert Registrierung(en) stehen im else-Zweig eines ISA-Gatters, existieren"
    echo "        also GENAU DANN, wenn die Faehigkeit FEHLT. Die Leiter oben ist monoton und"
    echo "        bildet das nicht ab; die Untergrenze waere fuer diese Stellen falsch."
    awk '$6 + 0 == 1 { printf "        %s\n", $10 }' "$TMP/stellen.txt" | sort -u
    BEFUND=1
fi

# =============================================================================
#  7. GEGENEINGANG (optional): der GEBAUTE Baum gegen die Leiter
# =============================================================================
# T-4. Bis hierhin ist alles aus dem Quelltext -- eine in sich geschlossene
# Rechnung. Erst hier kommt eine zweite, unabhaengige Quelle dazu: die Liste,
# die ctest im wirklich konfigurierten Baum ausgibt.
if [ -n "$CTEST_LISTE" ]; then
    echo "-----------------------------------------------------------------------------"
    if [ ! -r "$CTEST_LISTE" ]; then
        echo "ABBRUCH: --ctest-liste '$CTEST_LISTE' nicht lesbar." >&2
        exit 2
    fi
    # `ctest -N` druckt "  Test #12: name"; nur diese Zeilen sind Namen.
    sed -n 's/^[[:space:]]*Test[[:space:]]*#[0-9]*:[[:space:]]*//p' "$CTEST_LISTE" | awk 1 > "$TMP/ist_namen.txt"
    N_IST=$(awk 'END{print NR+0}' "$TMP/ist_namen.txt")
    if [ "$N_IST" -eq 0 ]; then
        echo "ABBRUCH: --ctest-liste enthaelt 0 Testnamen -- eine leere Gegenprobe ist keine."
        exit 2
    fi
    echo "GEGENEINGANG   ctest_eintraege_ist=$N_IST  quelle=$CTEST_LISTE"
    _wider=0
    while read -r _r _rw _g _gw _n _nw _nm _nmw _o _ow _i _iw; do
        : "$_r$_g$_n$_o$_i$_gw$_nw$_iw"
        _rang="$_rw"; _name="$_nmw"; _ort="$_ow"
        [ "$_rang" != "0" ] || continue
        # Nur namentlich 1:1 pruefbare Registrierungen. Alles andere waere ein
        # erfundener Widerspruch (s. name_aus() im Durchgang 2).
        case "$_name" in *'${'*|'?'*) continue ;; esac
        if grep -qxF "$_name" "$TMP/ist_namen.txt"; then _da=ja; else _da=nein; fi
        if [ "$_rang" -le "$HOST_RANG" ] 2>/dev/null; then _soll=ja; else _soll=nein; fi
        if [ "$_da" != "$_soll" ]; then
            echo "        WIDERSPRUCH $_name  im_bau=$_da  laut_leiter=$_soll  ($_ort)"
            _wider=$((_wider + 1))
        fi
    done < "$TMP/stellen.txt"
    if [ "$_wider" -gt 0 ]; then
        echo "BEFUND: $_wider ISA-Registrierung(en) widersprechen der Klassen-Leiter im gebauten Baum."
        BEFUND=1
    else
        echo "        kein Widerspruch: jede namentlich pruefbare ISA-Registrierung steht genau dann"
        echo "        im gebauten Baum, wenn host_klasse=$HOST_KLASSE sie traegt."
    fi
fi

echo "============================================================================="
if [ "$BEFUND" -eq 0 ]; then
    echo "ERGEBNIS: Bericht erstellt, kein Widerspruch.  host_klasse=$HOST_KLASSE"
    echo "          untergrenze_registrierungen=$Z_untergrenze von registrierungen_gesamt=$Z_gesamt"
else
    echo "ERGEBNIS: BEFUND -- siehe oben. Die Untergrenze ist fuer die genannten Stellen nicht"
    echo "          ausrechenbar, solange der Befund steht."
fi
echo "============================================================================="

exit "$BEFUND"
