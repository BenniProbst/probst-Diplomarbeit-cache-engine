#!/bin/sh
# =============================================================================
# probst-diplomarbeit (Umbrella/super) -- configure.sh (GNU-Bauweg, 08.08.2026)
# =============================================================================
# WOZU. Der Owner: "Das einzige auf linux offizielle Verfahren ist ja
# configure.sh/make/make install oder make check ... diese 3 muessen im
# Wurzelordner liegen ... cache engine und super haben diese 3 befehle und ein
# bauendes cmake skript" (Ledger DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md
# :11370-11391).
#
# WARUM HIER UND NICHT IN Code/. Die DREI Befehle gehoeren laut Owner-Wortlaut
# in den Wurzelordner; das "bauende cmake skript" nennt er OHNE Ortsangabe. Es
# liegt weiterhin in Code/CMakeLists.txt und wird von hier aus mit '-S Code'
# angesprochen. Das ist der eingriffsarme Weg: die acht CI-Stellen, die heute
# mit 'cd Code' arbeiten (.gitlab-ci.yml:395,428,478,736,827,1135,1258), bleiben
# unberuehrt. Ein Umzug des CMakeLists waere ein eigenes Paket.
#
# ROLLE DIESES REPOS. Umbrella = ANWENDER. Es entscheidet mit der XML, WAS und
# WIE ausgewertet wird; die Mechanik liegt als Framework in der Cache Engine
# (Planer/CEB/Tier-Binaries). Der Anwender ruft die Planer-CLI auf, nachdem er
# sie per install gebaut hat -- 'make installcheck' prueft genau das.
#
# POSIX sh (Hausdoktrin: kein Python in der Buildchain, kein bash-ismus).
# Pruefbar mit:  sh -n configure.sh
# ASCII-only (Leitplanke). Keine Umlaute, kein UTF-8.
# =============================================================================

set -eu

# -- Voreinstellungen (GNU-Standardverzeichnisse, Makefile Conventions) -------
srcdir=""
builddir="build"
prefix="/usr/local"
exec_prefix=""
bindir=""
sbindir=""
libdir=""
libexecdir=""
includedir=""
datarootdir=""
datadir=""
mandir=""
docdir=""
sysconfdir=""
localstatedir=""

cmake_prog="${CMAKE:-cmake}"
generator=""
build_type="Release"
cmake_extra=""
quiet=0

progname="configure.sh"
pkgname="probst-diplomarbeit"

# Das CMake-Projekt liegt eine Ebene tiefer. Diese eine Zeile ist der ganze
# Unterschied zum ce-Gegenstueck.
cmake_unterverzeichnis="Code"

# -- Hilfsfunktionen ---------------------------------------------------------

fehler() {
    echo "${progname}: FEHLER: $*" >&2
    exit 1
}

melde() {
    [ "$quiet" -eq 1 ] || echo "$*"
}

# Haengt ein Argument an cmake_extra an, EINZELN gequotet. Wir koennen in POSIX
# sh keine Arrays fuehren; die Argumente werden deshalb als sh-Zitat-Text
# gesammelt und beim Aufruf per 'eval' wieder aufgetrennt. Das haelt Werte mit
# Leerzeichen zusammen (Pfade wie "/opt/mein wert" ueberleben das).
anhaengen() {
    _q=$(printf '%s\n' "$1" | sed "s/'/'\\\\''/g")
    cmake_extra="${cmake_extra} '${_q}'"
}

# --enable-foo-bar  -> -DCOMDARE_FOO_BAR=ON      (generische, vorhersagbare Regel)
# --disable-foo-bar -> -DCOMDARE_FOO_BAR=OFF
# Bewusst mechanisch statt kuratiert: eine Handliste der COMDARE_*-Optionen
# muesste bei jeder neuen Option nachgezogen werden und waere binnen Wochen
# unvollstaendig. Wer eine Option ausserhalb des COMDARE_-Raums setzen will,
# nimmt -D<name>=<wert>.
schalter_abbilden() {
    _name=$(printf '%s\n' "$1" | tr 'a-z-' 'A-Z_')
    anhaengen "-DCOMDARE_${_name}=$2"
}

hilfe() {
    cat <<'ENDE'
configure.sh -- GNU-Vorbau fuer die Diplomarbeit (Umbrella; konfiguriert Code/)

  Aufruf:  ./configure.sh [OPTION]...
  Danach:  make && make check && make install

Installationsverzeichnisse (GNU Makefile Conventions):
  --prefix=PFAD           Wurzel der Installation        [/usr/local]
  --exec-prefix=PFAD      Wurzel der Maschinencode-Teile [PREFIX]
  --bindir=PFAD           Programme                      [EPREFIX/bin]
  --sbindir=PFAD          Systemprogramme                [EPREFIX/sbin]
  --libdir=PFAD           Bibliotheken                   [EPREFIX/lib]
  --libexecdir=PFAD       intern aufgerufene Programme   [EPREFIX/libexec]
  --includedir=PFAD       Header                         [PREFIX/include]
  --datarootdir=PFAD      arch-unabhaengige Daten        [PREFIX/share]
  --datadir=PFAD          Programmdaten                  [DATAROOTDIR]
  --mandir=PFAD           Handbuchseiten                 [DATAROOTDIR/man]
  --docdir=PFAD           Dokumentation                  [DATAROOTDIR/doc/NAME]
  --sysconfdir=PFAD       Konfiguration                  [PREFIX/etc]
  --localstatedir=PFAD    veraenderlicher Zustand        [PREFIX/var]

Quell- und Bauverzeichnis:
  --srcdir=PFAD           REPO-Wurzel (nicht Code/)  [Verzeichnis dieses Skripts]
  --build-dir=PFAD        Bauverzeichnis             [build]

Merkmale und Pakete:
  --enable-NAME           setzt -DCOMDARE_NAME=ON   (NAME: Bindestriche werden
  --disable-NAME          setzt -DCOMDARE_NAME=OFF   zu Unterstrichen, Grossschrift)
                          Beispiel: --enable-v32-enable -> -DCOMDARE_V32_ENABLE=ON
  --with-cmake=PFAD       zu verwendendes cmake                    [cmake]
  --with-generator=NAME   CMake-Generator, z.B. Ninja              [CMake-Vorgabe]
  --with-build-type=TYP   Release | Debug | RelWithDebInfo | ...   [Release]
  -D<name>=<wert>         beliebiges CMake-Define durchreichen

Systemtypen (angenommen und aufgezeichnet; Cross-Bau laeuft ueber
  CMAKE_TOOLCHAIN_FILE, siehe -D):
  --build=TYP  --host=TYP  --target=TYP

Sonstiges:
  -q, --quiet, --silent   weniger Ausgabe
  -V, --version           Version ausgeben und beenden
  -h, --help              diese Hilfe

Umgebungsvariablen: CC, CXX, CFLAGS, CXXFLAGS, LDFLAGS, CMAKE

Voraussetzung: die Submodule muessen initialisiert sein
  (git submodule update --init --recursive) -- ohne cache-engine bricht
  Code/CMakeLists.txt mit einer eigenen Meldung ab.

Hinweis zum Bauverzeichnis: 'make distclean' entfernt GENAU das Verzeichnis,
das hier konfiguriert wurde (in config.status vermerkt) -- nicht mehr.
ENDE
}

# -- Argumente lesen ---------------------------------------------------------
# Aufgezeichnet wird die ORIGINAL-Zeile, damit config.status sie wiedergeben
# kann (GNU: "describes which configuration options were specified when the
# program was last configured").
configure_args=""
for _a in "$@"; do
    _q=$(printf '%s\n' "$_a" | sed "s/'/'\\\\''/g")
    configure_args="${configure_args} '${_q}'"
done

while [ $# -gt 0 ]; do
    case "$1" in
        --prefix=*)         prefix=${1#*=} ;;
        --exec-prefix=*)    exec_prefix=${1#*=} ;;
        --bindir=*)         bindir=${1#*=} ;;
        --sbindir=*)        sbindir=${1#*=} ;;
        --libdir=*)         libdir=${1#*=} ;;
        --libexecdir=*)     libexecdir=${1#*=} ;;
        --includedir=*)     includedir=${1#*=} ;;
        --datarootdir=*)    datarootdir=${1#*=} ;;
        --datadir=*)        datadir=${1#*=} ;;
        --mandir=*)         mandir=${1#*=} ;;
        --docdir=*)         docdir=${1#*=} ;;
        --sysconfdir=*)     sysconfdir=${1#*=} ;;
        --localstatedir=*)  localstatedir=${1#*=} ;;

        --srcdir=*)         srcdir=${1#*=} ;;
        --build-dir=*)      builddir=${1#*=} ;;

        --enable-*)         schalter_abbilden "${1#--enable-}" ON ;;
        --disable-*)        schalter_abbilden "${1#--disable-}" OFF ;;

        --with-cmake=*)     cmake_prog=${1#*=} ;;
        --with-generator=*) generator=${1#*=} ;;
        --with-build-type=*) build_type=${1#*=} ;;

        -D*)                anhaengen "$1" ;;

        # Systemtypen: angenommen und in config.status aufgezeichnet. Ein echter
        # Cross-Bau laeuft bei CMake ueber CMAKE_TOOLCHAIN_FILE -- wir tun NICHT
        # so, als koennten wir ein Tripel selbst aufloesen. Das waere geraten.
        --build=*|--host=*|--target=*) : ;;

        -q|--quiet|--silent) quiet=1 ;;
        -V|--version)        echo "${pkgname} configure.sh (GNU-Vorbau)"; exit 0 ;;
        -h|--help)           hilfe; exit 0 ;;

        # GNU-Kompatibilitaet: autotools-Optionen ohne Entsprechung werden
        # angenommen statt abgelehnt -- ein Aufrufer, der ein Standard-Rezept
        # faehrt, soll nicht an einer Fussnote scheitern.
        --cache-file=*|--no-create|--no-recursion|-C|--config-cache) : ;;

        *) fehler "unbekannte Option '$1' (./configure.sh --help zeigt alle)" ;;
    esac
    shift
done

# -- Quellverzeichnis bestimmen und pruefen ----------------------------------
if [ -z "$srcdir" ]; then
    srcdir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
fi
cmake_src="${srcdir}/${cmake_unterverzeichnis}"
[ -f "${cmake_src}/CMakeLists.txt" ] ||
    fehler "in '${cmake_src}' liegt kein CMakeLists.txt (--srcdir=REPO-WURZEL setzen)"

# Fruehe, sprechende Meldung statt eines spaeten CMake-Abbruchs: ohne
# initialisiertes cache-engine-Submodul kann hier nichts entstehen. Code/
# CMakeLists.txt faengt das zwar selbst ab (FATAL_ERROR), aber erst nach der
# halben Konfiguration -- und der Hinweis, WIE man es behebt, fehlt dort.
if [ ! -f "${cmake_src}/external/comdare-cache-engine/CMakeLists.txt" ]; then
    fehler "cache-engine-Submodul nicht initialisiert.
  Abhilfe:  git submodule update --init --recursive"
fi

# -- Abgeleitete Verzeichnisse (GNU-Vorgabewerte) ----------------------------
[ -n "$exec_prefix" ]    || exec_prefix="$prefix"
[ -n "$bindir" ]         || bindir="${exec_prefix}/bin"
[ -n "$sbindir" ]        || sbindir="${exec_prefix}/sbin"
[ -n "$libdir" ]         || libdir="${exec_prefix}/lib"
[ -n "$libexecdir" ]     || libexecdir="${exec_prefix}/libexec"
[ -n "$includedir" ]     || includedir="${prefix}/include"
[ -n "$datarootdir" ]    || datarootdir="${prefix}/share"
[ -n "$datadir" ]        || datadir="${datarootdir}"
[ -n "$mandir" ]         || mandir="${datarootdir}/man"
[ -n "$docdir" ]         || docdir="${datarootdir}/doc/${pkgname}"
[ -n "$sysconfdir" ]     || sysconfdir="${prefix}/etc"
[ -n "$localstatedir" ]  || localstatedir="${prefix}/var"

# -- Werkzeuge pruefen -------------------------------------------------------
command -v "$cmake_prog" >/dev/null 2>&1 ||
    fehler "cmake nicht gefunden ('${cmake_prog}'). --with-cmake=PFAD setzt es."

# -- CMake-Aufruf zusammensetzen ---------------------------------------------
# GNUInstallDirs (Code/CMakeLists.txt:48) liest CMAKE_INSTALL_*; die Namen sind
# dieselben wie die GNU-Verzeichnisvariablen. Absolute Pfade uebernimmt
# GNUInstallDirs unveraendert -- genau das wollen wir, denn der Aufrufer hat sie
# oben explizit gesetzt.
anhaengen "-DCMAKE_INSTALL_PREFIX=${prefix}"
anhaengen "-DCMAKE_INSTALL_BINDIR=${bindir}"
anhaengen "-DCMAKE_INSTALL_SBINDIR=${sbindir}"
anhaengen "-DCMAKE_INSTALL_LIBDIR=${libdir}"
anhaengen "-DCMAKE_INSTALL_LIBEXECDIR=${libexecdir}"
anhaengen "-DCMAKE_INSTALL_INCLUDEDIR=${includedir}"
anhaengen "-DCMAKE_INSTALL_DATAROOTDIR=${datarootdir}"
anhaengen "-DCMAKE_INSTALL_DATADIR=${datadir}"
anhaengen "-DCMAKE_INSTALL_MANDIR=${mandir}"
anhaengen "-DCMAKE_INSTALL_DOCDIR=${docdir}"
anhaengen "-DCMAKE_INSTALL_SYSCONFDIR=${sysconfdir}"
anhaengen "-DCMAKE_INSTALL_LOCALSTATEDIR=${localstatedir}"
anhaengen "-DCMAKE_BUILD_TYPE=${build_type}"

[ -z "${CC:-}" ]       || anhaengen "-DCMAKE_C_COMPILER=${CC}"
[ -z "${CXX:-}" ]      || anhaengen "-DCMAKE_CXX_COMPILER=${CXX}"
[ -z "${CFLAGS:-}" ]   || anhaengen "-DCMAKE_C_FLAGS=${CFLAGS}"
[ -z "${CXXFLAGS:-}" ] || anhaengen "-DCMAKE_CXX_FLAGS=${CXXFLAGS}"
[ -z "${LDFLAGS:-}" ]  || anhaengen "-DCMAKE_EXE_LINKER_FLAGS=${LDFLAGS}"

if [ -n "$generator" ]; then
    anhaengen "-G"
    anhaengen "$generator"
fi

melde "${progname}: Repo-Wurzel      : ${srcdir}"
melde "${progname}: CMake-Quelle     : ${cmake_src}"
melde "${progname}: Bauverzeichnis   : ${builddir}"
melde "${progname}: Praefix          : ${prefix}"
melde "${progname}: cmake            : ${cmake_prog}"
melde ""

eval "set -- ${cmake_extra}"
_rc=0
if [ "$quiet" -eq 1 ]; then
    "$cmake_prog" -B "$builddir" -S "$cmake_src" "$@" >/dev/null || _rc=$?
else
    "$cmake_prog" -B "$builddir" -S "$cmake_src" "$@" || _rc=$?
fi

# Scheitert cmake, wird KEIN config.status geschrieben -- eine halbe Konfiguration
# aufzuzeichnen waere schlimmer als keine, denn 'make' wuerde sie fuer bare Muenze
# nehmen. Das Bauverzeichnis bleibt aber bewusst STEHEN: darin liegt die
# CMake-Diagnose (CMakeCache.txt, CMakeFiles/CMakeError.log), die den Fehler
# ueberhaupt erklaert. Folge, die man kennen muss: 'make distclean' raeumt es
# NICHT weg, weil es ohne config.status gar nicht weiss, dass es existiert --
# nach einem gescheiterten Lauf entfernt man es von Hand oder konfiguriert
# erfolgreich darueber.
if [ "$_rc" -ne 0 ]; then
    echo "" >&2
    echo "${progname}: cmake ist fehlgeschlagen (Exit ${_rc}). KEIN config.status geschrieben." >&2
    echo "${progname}: Das Bauverzeichnis '${builddir}' bleibt stehen -- es traegt die" >&2
    echo "${progname}: CMake-Diagnose. Es wird von 'make distclean' NICHT erfasst." >&2
    exit "$_rc"
fi

# -- config.status schreiben -------------------------------------------------
# GNU verlangt eine Aufzeichnung der zuletzt verwendeten Optionen. Diese Datei
# ist zugleich die Schnittstelle zum Makefile: es liest SRCDIR/BUILDDIR/CMAKE
# von hier. Bewusst POSIX-sh-Zuweisungen (das Makefile liest sie ueber 'sh'),
# und bewusst mit dem Aufruf am Kopf -- wer wissen will, wie dieser Baum
# entstanden ist, liest eine Datei, nicht ein Kommando-Gedaechtnis.
{
    echo "# von configure.sh erzeugt -- NICHT von Hand bearbeiten."
    echo "# Wiederholen laesst sich diese Konfiguration mit:"
    echo "#   ./configure.sh${configure_args}"
    echo "COMDARE_SRCDIR='${srcdir}'"
    echo "COMDARE_CMAKE_SRCDIR='${cmake_src}'"
    echo "COMDARE_BUILDDIR='${builddir}'"
    echo "COMDARE_PREFIX='${prefix}'"
    echo "COMDARE_BINDIR='${bindir}'"
    echo "COMDARE_CMAKE='${cmake_prog}'"
    echo "COMDARE_BUILD_TYPE='${build_type}'"
    echo "COMDARE_CONFIGURE_ARGS=\"${configure_args}\""
} > config.status
chmod 644 config.status

melde ""
melde "${progname}: fertig. config.status geschrieben."
melde "${progname}: weiter mit:  make        (bauen)"
melde "${progname}:              make check  (Tests)"
melde "${progname}:              make install"
