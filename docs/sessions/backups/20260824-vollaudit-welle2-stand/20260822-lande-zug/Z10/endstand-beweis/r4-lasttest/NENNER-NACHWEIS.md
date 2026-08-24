R4-NENNER-NACHWEIS aus den Bau-Baeumen (Kopien, gesichert 2026-08-23 ~14:0xZ vom Endstand-Pruefer)
GRUND: die r4-ZELLEN-Logs (cifix2-vl3debug/k17-r4-*.log) tragen die Bilanzzeile
'100% tests passed, 0 tests failed out of 544' NICHT -- r1 und r3 trugen sie.
Der NENNER ist aber literal aus CTests eigenem LastTest.log belegbar: dessen letzte
Fortschrittszeile nennt gelaufene/gesamt. Diese Dateien werden vom naechsten ctest-Lauf
im selben Baum UEBERSCHRIEBEN -- deshalb hier als Kopie gesichert.

build-l1         letzte Fortschrittszeile: 544/544 Test   (Datei-mtime 2026-08-23T13:53:33Z)
build-l1-clang   letzte Fortschrittszeile: 544/544 Test   (Datei-mtime 2026-08-23T13:56:03Z)
build-dbg-clang  letzte Fortschrittszeile: 544/544 Test   (Datei-mtime 2026-08-23T13:58:31Z)

ZUORDNUNG Baum -> r4-Zelle (aus kombibau-r4.sh / den Zellen-Logs):
  build-l1        = gcc-rel     (Zellen-Log 13:50:45Z, Total Test time 31.50 sec)
  build-l1-clang  = clang-rel   (13:53:33Z, 32.96 sec)
  build-dbg-clang = clang-dbg   (13:56:03Z, 82.37 sec)
  build-dbg       = gcc-dbg     (13:58:31Z gestartet -- zum Messzeitpunkt NOCH NICHT fertig;
                                 sein LastTest.log trug 13:49:23Z noch den K13-Mutationslauf)

VERGLEICHSZEITEN (gesicherte Kopien, dieselbe Suite):
  r1 @5ddda4e5: gcc-rel 31.26 / clang-rel 32.70 / gcc-dbg 84.69 / clang-dbg 82.05 sec, je LITERAL 544
  r3 @b247a339: gcc-rel 31.43 / clang-rel 32.86 / gcc-dbg 84.23 / clang-dbg 81.80 sec, je LITERAL 544
  r4 @3841d717: gcc-rel 31.50 / clang-rel 32.96 / clang-dbg 82.37 sec (gcc-dbg offen)
