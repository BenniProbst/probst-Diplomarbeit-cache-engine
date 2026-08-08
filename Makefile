# =============================================================================
# probst-diplomarbeit (Umbrella/super) -- Makefile (GNU-Bauweg, 08.08.2026)
# =============================================================================
# WOZU. Der offizielle Linux-Bauweg aus Quellen ist
#   ./configure.sh && make && make check && make install
# (Owner 08.08.2026; Ledger DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md
# :11370-11391). Dieses Makefile ist der GNU-Vorbau -- es BAUT NICHT SELBST,
# sondern reicht an CMake weiter. Das bauende Skript bleibt Code/CMakeLists.txt.
#
# ZIELE nach GNU Makefile Conventions (Standard Targets):
#   all install check installcheck uninstall clean distclean
#   mostlyclean maintainer-clean
# Der GNU-Name des Test-Ziels ist 'check', nicht 'test' -- "Perform self-tests
# (if any). The user must build the program before running the tests, but need
# not install the program."
#
# WOHER DIE KONFIGURATION KOMMT. Ausschliesslich aus config.status, das
# configure.sh schreibt. Dieses Makefile enthaelt bewusst KEINE Vorgabewerte
# fuer Praefix oder Bauverzeichnis: gaebe es sie, waeren sie eine zweite
# Wahrheit neben config.status und wuerden bei jedem Vergessen von
# ./configure.sh still danebenlaufen.
#
# ASCII-only (Leitplanke). Keine Umlaute, kein UTF-8.
# =============================================================================

CONFIG_STATUS = config.status

# Aus config.status gelesen (leer = nicht konfiguriert). Der ':='-Zuweiser
# wertet EINMAL beim Einlesen aus, nicht bei jeder Benutzung.
BUILDDIR   := $(shell test -f ./$(CONFIG_STATUS) && . ./$(CONFIG_STATUS) && printf '%s' "$$COMDARE_BUILDDIR")
SRCDIR     := $(shell test -f ./$(CONFIG_STATUS) && . ./$(CONFIG_STATUS) && printf '%s' "$$COMDARE_SRCDIR")
CMAKE      := $(shell test -f ./$(CONFIG_STATUS) && . ./$(CONFIG_STATUS) && printf '%s' "$$COMDARE_CMAKE")
PREFIX     := $(shell test -f ./$(CONFIG_STATUS) && . ./$(CONFIG_STATUS) && printf '%s' "$$COMDARE_PREFIX")
BINDIR     := $(shell test -f ./$(CONFIG_STATUS) && . ./$(CONFIG_STATUS) && printf '%s' "$$COMDARE_BINDIR")

# Die beiden Werkzeuge, die dieses Repo installiert. Die Planer-CLI ist die,
# die der Anwender laut Owner nach dem Installieren aufruft; der Mess-Treiber
# ist ihr Zwilling aus demselben Rollen-Schnitt.
PLANER_CLI  = comdare-experiment-planner
TREIBER_CLI = comdare-messung-driver

# Sammel-Target und Test-Label der Unit-Suite (Code/CMakeLists.txt:463,
# Code/tests/CMakeLists.txt:17).
TEST_TARGET = comdare_da_unit_tests
TEST_LABEL  = da_unit

# Parallelitaet an CMake durchreichen. Ohne Angabe entscheidet CMake selbst;
# 'make -jN' wirkt NICHT automatisch auf den Unterbau, deshalb explizit.
BUILD_JOBS ?=
ifneq ($(strip $(BUILD_JOBS)),)
  BUILD_PAR = --parallel $(BUILD_JOBS)
else
  BUILD_PAR =
endif

# Zusaetzliche ctest-Argumente fuer 'make check'. Zweck: die CI braucht
# '--output-junit <pfad>' fuer den GitLab-Test-Report, und ohne diese Naht
# muesste sie ctest wieder selbst aufrufen -- also genau den offiziellen Weg
# umgehen, den sie bewachen soll. Die AUSWAHL der Tests (Label da_unit) bleibt
# unveraendert; hier lassen sich nur Ausgabe-Optionen ergaenzen.
CTEST_EXTRA ?=

.DEFAULT_GOAL := all

.PHONY: all install check installcheck uninstall clean distclean \
        mostlyclean maintainer-clean konfiguriert testdata help

# -- Wache: ohne configure.sh geht nichts, und zwar LAUT -----------------------
konfiguriert:
	@test -n "$(BUILDDIR)" || { \
	  echo "FEHLER: nicht konfiguriert -- es gibt kein $(CONFIG_STATUS)."; \
	  echo "  Zuerst:  ./configure.sh [--prefix=PFAD] [--enable-NAME] ..."; \
	  echo "  Hilfe:   ./configure.sh --help"; \
	  exit 1; }
	@test -d "$(BUILDDIR)" || { \
	  echo "FEHLER: Bauverzeichnis '$(BUILDDIR)' fehlt, obwohl $(CONFIG_STATUS) es nennt."; \
	  echo "  Erneut konfigurieren:  ./configure.sh"; \
	  exit 1; }

# -- all: uebersetzt alles ----------------------------------------------------
all: konfiguriert
	$(CMAKE) --build "$(BUILDDIR)" $(BUILD_PAR)

# -- check: Selbsttests -------------------------------------------------------
# AUSWAHL: das Label 'da_unit', gesetzt in Code/tests/CMakeLists.txt:17 ueber
# comdare_da_add_test(). Sie ist damit dieselbe wie im CI-Job test:unit
# (.gitlab-ci.yml:290, 'ctest -L da_unit') -- gebaut wird ebenfalls dasselbe
# Sammel-Target comdare_da_unit_tests.
#
# EHRLICHER UNTERSCHIED ZUR CACHE ENGINE, benannt statt verschwiegen: die ce
# haelt ihre ctest-Auswahlen seit R4 zentral in
# scripts/ci_test_coverage_manifest.sh, und ihr 'make check' BINDET diese Datei
# ein. In diesem Repo gibt es kein solches Manifest -- die Auswahl steht hier
# und ein zweites Mal in .gitlab-ci.yml:290. Das sind zwei Orte fuer eine
# Aussage. Weil die Auswahl hier aus EINEM Label besteht (nicht aus 14
# gepflegten Mustern wie in der ce), ist das Driftrisiko klein, aber nicht
# null: wer das Label aendert, muss beide Stellen anfassen. Ein super-eigenes
# Manifest nach ce-Vorbild ist der benannte Nachfolger, kein Teil dieses Pakets.
#
# VORAUSSETZUNG: die Tests muessen konfiguriert sein. COMDARE_DA_BUILD_TESTS
# steht per Vorgabe auf ON (Code/CMakeLists.txt:69). Die vier V32-Tests haengen
# zusaetzlich an COMDARE_V32_ENABLE (Code/tests/CMakeLists.txt:95) -- wer sie
# will, konfiguriert mit  ./configure.sh --enable-v32-enable.
# DAS RECONFIGURE -- warum es hier steht, obwohl es HEUTE nichts bringt.
# In der cache-engine wird ein Teil der Tests erst registriert, wenn die
# Codegen-Werkzeuge GEBAUT sind und CMake danach ein zweites Mal laeuft; dort am
# Objekt gemessen: 427 Tests bei einem einzigen Configure gegen 431 nach 'all' +
# Reconfigure (vier Tests waren unsichtbar).
#
# EHRLICHE MESSUNG FUER DIESES REPO: hier aendert es HEUTE NICHTS -- 610
# registrierte Tests vor wie nach dem Reconfigure, davon 186 mit Label da_unit.
# Es steht trotzdem, und zwar aus einem Grund statt aus Symmetrie: dieses Repo
# ZIEHT die cache-engine als Sub-Build ein (Code/CMakeLists.txt:211). Sobald ein
# codegen-abhaengiger ce-Test in den super-Baum geraet, greift dieselbe Falle.
# Ein Reconfigure eines bereits gebauten Baums kostet Sekunden; ein still
# fehlender Test kostet eine Regression, die niemand sieht.
check: all
	$(CMAKE) -S "$(SRCDIR)/Code" -B "$(BUILDDIR)"
	$(CMAKE) --build "$(BUILDDIR)" $(BUILD_PAR) --target $(TEST_TARGET)
	ctest --test-dir "$(BUILDDIR)" -L $(TEST_LABEL) --output-on-failure $(CTEST_EXTRA)

# -- install: DESTDIR-faehig --------------------------------------------------
# DESTDIR wird dem Praefix VORANGESTELLT (GNU: staged install; CMake dokumentiert
# dasselbe Verhalten fuer 'cmake --install'). Es wird hier bewusst NICHT gesetzt,
# nur durchgereicht -- GNU: "DESTDIR should not be set within the Makefile".
# Vorbehalt, den CMake selbst nennt: DESTDIR traegt auf Unix, nicht auf Windows
# (dort steckt ein Laufwerksbuchstabe im Praefix). Der offizielle Weg ist laut
# Owner ohnehin der Linux-Weg.
install: all
	DESTDIR="$(DESTDIR)" $(CMAKE) --install "$(BUILDDIR)"

# -- installcheck: prueft die INSTALLIERTE Fassung ----------------------------
# Das ist der eigentliche Owner-Nachweis: "Der Anwender ruft also die CLI des
# Planers auf, nachdem er sie per install kompiliert hat." Geprueft werden beide
# installierten Werkzeuge -- die Planer-CLI kommt aus dem ce-Sub-Build
# (Code/CMakeLists.txt:235), der Treiber aus dem eigenen Modul
# (Code/02_messung_driver/CMakeLists.txt:27).
installcheck:
	@_fehlt=0; \
	for _c in $(PLANER_CLI) $(TREIBER_CLI); do \
	  _p="$(DESTDIR)$(BINDIR)/$$_c"; \
	  if test -x "$$_p"; then \
	    echo "installcheck: $$_p vorhanden"; \
	  else \
	    echo "FEHLER: '$$_p' fehlt oder ist nicht ausfuehrbar."; \
	    _fehlt=1; \
	  fi; \
	done; \
	test "$$_fehlt" -eq 0 || { echo "  Zuerst 'make install' (ggf. mit DESTDIR=...)."; exit 1; }; \
	_cli="$(DESTDIR)$(BINDIR)/$(PLANER_CLI)"; \
	"$$_cli" --help >/dev/null 2>&1 || "$$_cli" help >/dev/null 2>&1 || { \
	  echo "FEHLER: '$$_cli' beantwortet weder --help noch help."; \
	  exit 1; }; \
	echo "installcheck: Planer-CLI antwortet -- OK"

# -- uninstall ----------------------------------------------------------------
# CMake bringt kein eigenes uninstall mit, schreibt aber beim Installieren ein
# install_manifest.txt. Genau diese Liste wird hier zurueckgebaut -- nichts
# darueber hinaus, damit ein uninstall nie mehr entfernt als sein install
# angelegt hat. Die Pfade im Manifest tragen KEIN DESTDIR (am Objekt geprueft),
# deshalb wird es hier vorangestellt.
#
# '|| [ -n "$$_f" ]' IST NICHT KOSMETIK. CMake schliesst install_manifest.txt
# NICHT mit einem Zeilenumbruch ab (in der cache-engine am Objekt geprueft:
# letztes Byte ist das 'r' von "planner"). Ein blankes 'while IFS= read -r'
# liefert fuer die letzte Zeile false und bricht ab, BEVOR der Schleifenkoerper
# laeuft -- die letzte Datei des Manifests bliebe stehen, bei Exit-Code 0.
uninstall:
	@_man="$(BUILDDIR)/install_manifest.txt"; \
	test -f "$$_man" || { \
	  echo "FEHLER: '$$_man' fehlt -- ohne Installations-Manifest wird nichts entfernt."; \
	  exit 1; }; \
	while IFS= read -r _f || [ -n "$$_f" ]; do \
	  test -n "$$_f" || continue; \
	  if test -e "$(DESTDIR)$$_f" || test -L "$(DESTDIR)$$_f"; then \
	    rm -f -- "$(DESTDIR)$$_f" && echo "entfernt: $(DESTDIR)$$_f"; \
	  fi; \
	done < "$$_man"

# -- testdata: projekteigenes Ziel (KEIN GNU-Standardziel) --------------------
# Beschafft die Benchmark-Korpora (~30 GB, lazy on-demand) nach
# Code/tests/fixtures/external/ (gitignored).
#
# WARUM ES DIESES ZIEL GIBT: mit dem GNU-Bauweg sind die Behelfswege unter
# Code/tools/ entfallen -- run_all_tests.{sh,bat} und cross_compiler_matrix.sh
# ersatzlos, denn 'make check' tut dasselbe besser. fetch_testdata ist aber KEIN
# Test-Runner, sondern ein DATENBESCHAFFER: 'make check' ersetzt ihn nicht, und
# ihn mit den Behelfswegen zu entfernen waere ein stiller Funktionsverlust
# gewesen. Das Skript ist deshalb nach scripts/ umgezogen und bekommt hier sein
# offizielles Ziel. GNU kennt projekteigene Ziele neben den Standard-Zielen.
#
# Ohne Argument listet es die Datensaetze, statt 30 GB zu ziehen -- ein
# versehentliches 'make testdata' soll die Leitung nicht dichtmachen.
TESTDATA_ARGS ?= --list
testdata:
	sh scripts/fetch_testdata.sh $(TESTDATA_ARGS)

# -- clean / mostlyclean ------------------------------------------------------
clean: konfiguriert
	$(CMAKE) --build "$(BUILDDIR)" --target clean

mostlyclean: clean

# -- distclean ----------------------------------------------------------------
# GNU: "Delete all files ... that are created by configuring or building the
# program ... 'make distclean' should leave only the files that were in the
# distribution."
#
# ENTFERNT WIRD GENAU DAS IN config.status VERMERKTE BAUVERZEICHNIS -- kein
# fest verdrahtetes 'rm -rf build'. Grund, benannt statt stillschweigend: die
# Messdaten-Doktrin (Messdaten werden nie geloescht). In diesem Repo traegt
# Code/build/ zwar null getrackte Dateien ('git ls-files Code/build/' = 0), in
# der cache-engine lag bis eb96b76a eine getrackte Mess-CSV unter build/. Ein
# 'rm -rf build' als Gewohnheit ist deshalb die falsche Gewohnheit -- dieses
# Ziel loescht, was configure.sh angelegt hat, und nichts sonst.
distclean:
	@test -n "$(BUILDDIR)" || { \
	  echo "nichts zu tun: kein $(CONFIG_STATUS) vorhanden."; exit 0; }
	@test "$(BUILDDIR)" != "." && test "$(BUILDDIR)" != "/" || { \
	  echo "FEHLER: unplausibles Bauverzeichnis '$(BUILDDIR)' -- abgebrochen."; exit 1; }
	rm -rf -- "$(BUILDDIR)"
	rm -f -- ./$(CONFIG_STATUS)

maintainer-clean: distclean
	@echo "maintainer-clean: identisch zu distclean -- dieses Projekt haelt keine"
	@echo "  eingecheckten Generate, die nur Betreuer neu erzeugen koennen."

# -- help ---------------------------------------------------------------------
help:
	@echo "probst-diplomarbeit (Umbrella) -- GNU-Bauweg"
	@echo ""
	@echo "  ./configure.sh [--prefix=PFAD] ...   konfigurieren (--help zeigt alles)"
	@echo "  make                                 uebersetzen"
	@echo "  make check                           Selbsttests (ctest -L $(TEST_LABEL))"
	@echo "  make install [DESTDIR=PFAD]          installieren"
	@echo "  make installcheck                    installierte CLIs pruefen"
	@echo "  make uninstall                       per install_manifest zurueckbauen"
	@echo "  make clean                           Bauartefakte entfernen"
	@echo "  make distclean                       Bauverzeichnis + config.status entfernen"
	@echo ""
	@echo "  BUILD_JOBS=N                         Parallelitaet an cmake --build"
