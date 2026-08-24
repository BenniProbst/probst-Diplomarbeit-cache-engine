# skip_anker_bissprobe.cmake -- B11/F-E-Rest (2026-08-21): die MUTATIONSPROBE "ROT statt SKIPPED"
# des B14-NB4-Befund-B4-Ankers.
#
# WAS SIE BEWEIST: der SKIP-Ausdruck der fuenf Fixture-Wachen klassifiziert (a) die LEGITIME
# Marker-Zeile als Skip und (b) einen FATAL-Text, der den Marker MITTEN in einer Zeile mitfuehrt
# (der einzige Einschleus-Weg, s. Kommentar am set_tests_properties-Block), NICHT als Skip.
# Ohne (b) waere der Anker eine Behauptung: ein Rueckbau auf das unverankerte Teilwort bliebe
# unsichtbar, bis eine echoende FATAL-Meldung einen echten Fehler als SKIP verkleidet.
#
# DRIFT-FREI: der Ausdruck reist als -DSKIP_REGEX aus der LIVE-ctest-Property
# (get_test_property in CMakeLists.txt) herein -- KEINE zweite Kopie der Regex. Aendert jemand
# die Property, prueft diese Probe automatisch den neuen Ausdruck.
#
# T-11c-BISS: den Anker in der Property lockern (Teilwort statt (^|\n)...-Bindung) laesst
# Fall (b) matchen -> diese Probe FATALt.

if(NOT DEFINED SKIP_REGEX OR SKIP_REGEX STREQUAL "")
    message(FATAL_ERROR "skip_anker_bissprobe: -DSKIP_REGEX fehlt (muss aus der ctest-Property kommen)")
endif()

# (a) Die legitime Form: der Marker als EIGENE Zeile mit CMake-STATUS-Praefix, wie ihn
# message(STATUS "COMDARE-XML-WACHE-SKIP") in die Testausgabe schreibt.
set(_legitim "irgendein Vorlauf\n-- COMDARE-XML-WACHE-SKIP\nirgendein Nachlauf")
string(REGEX MATCH "${SKIP_REGEX}" _m_legitim "${_legitim}")
if(_m_legitim STREQUAL "")
    message(FATAL_ERROR
        "skip_anker_bissprobe (a): die LEGITIME Marker-Zeile matcht den Skip-Ausdruck NICHT mehr -- "
        "die fuenf Wachen koennten nie wieder sauber skippen. Ausdruck: ${SKIP_REGEX}")
endif()

# (b) Der Einschleus-Fall: der Marker MITTEN in einer FATAL-Zeile (z.B. weil eine Wache einen
# Dateiinhalt echoot, der die Zeichenfolge traegt). Er DARF NICHT als Skip klassifiziert werden.
set(_eingebettet "CMake Error: kaputte Fixture enthaelt COMDARE-XML-WACHE-SKIP im Datei-Echo")
string(REGEX MATCH "${SKIP_REGEX}" _m_eingebettet "${_eingebettet}")
if(NOT _m_eingebettet STREQUAL "")
    message(FATAL_ERROR
        "skip_anker_bissprobe (b): ein MITTEN in der Zeile eingebetteter Marker matcht den "
        "Skip-Ausdruck -- der B4-Anker ist gebrochen (ROT wuerde als SKIPPED verkleidet). "
        "Ausdruck: ${SKIP_REGEX}")
endif()

message(STATUS "skip_anker_bissprobe: beide Klassifikationen korrekt (legitim=SKIP, eingebettet=ROT)")
