# shellcheck shell=sh
# =============================================================================
#  comdare_bestandslog_activation.sh -- die SCHARFSCHALTUNG des Bestandslogs,
#  an EINER Stelle, fuer BEIDE Wege (GitLab-CI und bare-metal).      (2026-08-09)
# =============================================================================
#
# SELBSTCHECK -- was diese Datei zusichert, und was NICHT:
#   ZUSICHERT: dass bei gesetztem Opt-in die DREI Pflicht-Variablen des Binders
#     (DOC_KEY / OWNER_UUID / MASCHINE) belegt sind, dass der OWNER_UUID der
#     dokumentierten Konvention folgt (CI: CI_JOB_ID@host, lokal: pid@host), und
#     dass ein vom Aufrufer bereits gesetzter Wert NIE ueberschrieben wird.
#   ZUSICHERT NICHT: dass Ebene B (minio) erreichbar ist, dass der Store die
#     Credentials akzeptiert, oder dass das Dokument entsteht. Diese Datei setzt
#     Variablen -- sie spricht nicht mit dem Store. Ob der Binder wirklich
#     gebunden hat, sagt allein die aktiv-Zeile im Log (ci/bestandslog_wache.sh).
#
# DER BEFUND, GEGEN DEN SIE GEBAUT IST (09.08.2026):
# COMDARE_BESTANDSLOG stand in NULL von zwei aktiven .gitlab-ci.yml. Binder,
# Director-Durchreiche und 22 Lager-Header waren fertig -- es fehlte allein der
# Schalter. Und die OWNER-Konvention "CI_JOB_ID@host bzw. pid@host" existierte
# ausschliesslich als KOMMENTAR (planer_block_value.hpp:24-25, null Code-Treffer
# im ganzen ce-Baum, selbst gezaehlt). Eine Konvention im Kommentar ist keine
# Konvention. Hier wird sie ausgefuehrt.
#
# WARUM DER OWNER TRAEGT (und nicht bloss mitlaeuft):
# An der owner_uuid haengt die TAKEOVER-Regel des Lagers: bleibt eine
# Reservierung ueber ETA + 50 % ohne Update, duerfen andere Maschinen sie
# uebernehmen (Owner 22.07.2026). Waere der owner nicht lauf-eindeutig, koennte
# eine Maschine ihre EIGENE laufende Reservierung fuer tot erklaeren und sich
# selbst uebernehmen. CI_JOB_ID ist je Job global eindeutig; der Hostname trennt
# zusaetzlich die Maschinen.
#   EHRLICHE GRENZE des lokalen Falls: pid@host ist nur SOLANGE eindeutig, wie
#   der Prozess lebt -- nach PID-Wiederverwendung koennte ein spaeterer lokaler
#   Lauf denselben owner tragen. Das ist die dokumentierte Konvention und wird
#   hier bewusst NICHT eigenmaechtig um einen Zeitstempel erweitert; im CI-Fall
#   (dem Fall der Mess-Kampagne) tritt er nicht auf.
#
# KOPPLUNG AN DEN STORAGE (kein neuer Entwurf, sondern der vorhandene Kontrakt):
# Der Binder gatet auf minio_enabled() -- ohne Ebene B kann er nur warnen. Im
# Code steht dazu woertlich: "der Betriebs-Kontrakt koppelt COMDARE_BESTANDSLOG
# an den Storage-Push" (ce cache_engine_builder_iterator.hpp:2154). Deshalb gilt
# hier: ist COMDARE_STORAGE_CACHE scharf und COMDARE_BESTANDSLOG NICHT ausdruecklich
# gesetzt, wird das Lager mitgeschaltet. Wer es einzeln abschalten will, setzt
# COMDARE_BESTANDSLOG=false -- das ueberschreibt diese Kopplung.
#
# INERT-BY-DEFAULT: ohne COMDARE_STORAGE_CACHE/COMDARE_BESTANDSLOG faellt genau
# EINE Zeile und es wird KEINE Variable gesetzt -- der golden-Lauf bleibt
# byte-neutral (Doktrin "CI-Gruen = Messung AUS").
#
# QUELLE MIT `.` / `source` (NICHT ausfuehren) -- die Exports muessen in die
# aufrufende Shell wirken, genau wie bei scripts/comdare_storage_activation.sh:
#     . ci/comdare_storage_activation.sh    # Ebene B/C (Creds)  -- ce-Gegenstueck
#     . ci/comdare_bestandslog_activation.sh
#
# KONSUMIERTE ENV (nur Namen):
#   COMDARE_BESTANDSLOG COMDARE_STORAGE_CACHE CI_JOB_ID
#   COMDARE_BESTANDSLOG_DOC_KEY COMDARE_BESTANDSLOG_OWNER_UUID COMDARE_BESTANDSLOG_MASCHINE
#   COMDARE_BESTANDSLOG_MESS_DOC_KEY
# GESETZTE ENV:
#   COMDARE_BESTANDSLOG COMDARE_BESTANDSLOG_DOC_KEY
#   COMDARE_BESTANDSLOG_OWNER_UUID COMDARE_BESTANDSLOG_MASCHINE
#   COMDARE_BESTANDSLOG_MESS_DOC_KEY
#
# SICHERHEIT: hier faellt KEIN Geheimnis an. Alle vier Werte sind unkritisch
# (bool, Objekt-Schluessel im Store, Lauf-UUID, Hostname) -- genau die Klasse,
# die der Director ueber die Trigger-Grenzen literal weiterreichen darf. Die
# MinIO-Rohcreds passieren diese Datei NIE.
#
# Source-sicher: KEIN 'set -e', KEIN 'exit' (beides wuerde die aufrufende Shell
# bzw. den CI-Schritt treffen). POSIX-sh, ASCII-only, kein Python.
# =============================================================================

# --- (1) Kopplung an den Storage-Schalter, bevor irgendetwas geprueft wird ---
if [ -z "${COMDARE_BESTANDSLOG:-}" ] && [ "${COMDARE_STORAGE_CACHE:-}" = "true" ]; then
    COMDARE_BESTANDSLOG="true"
    export COMDARE_BESTANDSLOG
    echo "== Bestandslog: aus COMDARE_STORAGE_CACHE=true abgeleitet (Betriebs-Kontrakt) =="
fi

if [ "${COMDARE_BESTANDSLOG:-}" != "true" ]; then
    echo "== Bestandslog INERT (COMDARE_BESTANDSLOG != true) -> Binder stumm, Lauf byte-neutral =="
else
    echo "== Bestandslog SCHARF (COMDARE_BESTANDSLOG=true) =="

    # --- (2) Maschine: der Hostname, unter dem diese Maschine im Lager auftritt ---
    if [ -z "${COMDARE_BESTANDSLOG_MASCHINE:-}" ]; then
        _bl_host=""
        if command -v hostname >/dev/null 2>&1; then
            _bl_host=$(hostname 2>/dev/null || true)
        fi
        if [ -z "$_bl_host" ] && command -v uname >/dev/null 2>&1; then
            _bl_host=$(uname -n 2>/dev/null || true)
        fi
        if [ -z "$_bl_host" ]; then
            # Kein stiller Platzhalter: eine Maschine ohne Namen ist im Lager nicht
            # zuordenbar, und der Nenner jeder Wache waere gegenstandslos.
            _bl_host="unbekannt"
            echo "  [WARNUNG: Hostname nicht ermittelbar (weder hostname noch uname -n)."
            echo "            maschine=unbekannt -- die Zuordnung im Lager ist damit unscharf.]"
        fi
        COMDARE_BESTANDSLOG_MASCHINE="$_bl_host"
        export COMDARE_BESTANDSLOG_MASCHINE
    else
        _bl_host="$COMDARE_BESTANDSLOG_MASCHINE"
        echo "  maschine: vom Aufrufer vorgegeben -- nicht ueberschrieben."
    fi

    # --- (3) owner_uuid: die Konvention, ausgefuehrt statt kommentiert ---
    if [ -z "${COMDARE_BESTANDSLOG_OWNER_UUID:-}" ]; then
        if [ -n "${CI_JOB_ID:-}" ]; then
            COMDARE_BESTANDSLOG_OWNER_UUID="${CI_JOB_ID}@${_bl_host}"
            _bl_owner_quelle="CI_JOB_ID@host (CI-Lauf)"
        else
            COMDARE_BESTANDSLOG_OWNER_UUID="$$@${_bl_host}"
            _bl_owner_quelle="pid@host (bare-metal Lauf)"
        fi
        export COMDARE_BESTANDSLOG_OWNER_UUID
    else
        _bl_owner_quelle="vom Aufrufer vorgegeben -- nicht ueberschrieben"
    fi

    # --- (4) doc_key: das Bestands-Dokument der BINARIES im Objekt-Store ---
    # Realm-Trennung (Owner 22.07.2026, PRAEZISIERUNG-2): es gibt ZWEI Bestaende
    # mit je eigenem Log. Diese Variable speist cfg.bestand_doc_key, also den
    # BINARIES-Bestand; der Mess-Bestand haengt an cfg.mess_bestand_doc_key und
    # wird seit LAG-P2-Rest (Kette D, 09.08.2026) unter (5) gesetzt.
    # Der Default folgt der im ce-Testbestand dominierenden Schreibweise
    # (bestandslog/binary_bestand.xml, u.a. test_g3_lager_presence.cpp:26).
    if [ -z "${COMDARE_BESTANDSLOG_DOC_KEY:-}" ]; then
        COMDARE_BESTANDSLOG_DOC_KEY="bestandslog/binary_bestand.xml"
        export COMDARE_BESTANDSLOG_DOC_KEY
        _bl_key_quelle="Default"
    else
        _bl_key_quelle="vom Aufrufer vorgegeben"
    fi

    # --- (5) mess_doc_key: das Bestands-Dokument der MESSUNGEN (LAG-P2-Rest) ---
    # Der zweite Realm. Er speist cfg.mess_bestand_doc_key und schaltet damit im
    # Iterator mess_bestandslog_active (:2054-2056) -- das Gate, das bis heute nie
    # true wurde, weil die drei mess_bestand_*-Felder KEINEN externen Zuweiser
    # hatten. Zwei Dokumente in EINEM Store, nicht zwei Stores: der Transport ist
    # derselbe wie beim Binary-Genus.
    #
    # DIESE DATEI IST DIE EINZIGE QUELLE DES DEFAULTS. Der Treiber erfindet
    # KEINEN eigenen Default: ist die Variable leer, laeuft das Messwert-Genus
    # schlicht nicht (inert-by-default) und der Treiber sagt das in einer Zeile.
    # Ein zweiter Default im C++-Code waere eine Zweit-Wahrheit, die genau dann
    # auseinanderlaeuft, wenn hier jemand den Namen aendert.
    #
    # DER NAME MUSS SICH VOM BINARY-DOC-KEY UNTERSCHEIDEN. Sind beide gleich,
    # bricht der Treiber mit fehlerklasse=realm_kollision ab (exit 8; eigener
    # rc seit dem Gegenlesen 09.08., damit er das Doppel-Gate exit 6 nicht
    # verdeckt) -- lieber ein lauter Abbruch als zwei Realms, die still in
    # dasselbe Dokument schreiben.
    if [ -z "${COMDARE_BESTANDSLOG_MESS_DOC_KEY:-}" ]; then
        COMDARE_BESTANDSLOG_MESS_DOC_KEY="bestandslog/mess_bestand.xml"
        export COMDARE_BESTANDSLOG_MESS_DOC_KEY
        _bl_messkey_quelle="Default"
    else
        _bl_messkey_quelle="vom Aufrufer vorgegeben"
    fi

    echo "  doc_key  = ${COMDARE_BESTANDSLOG_DOC_KEY}  (${_bl_key_quelle})"
    echo "  mess_key = ${COMDARE_BESTANDSLOG_MESS_DOC_KEY}  (${_bl_messkey_quelle})"
    echo "  owner    = ${COMDARE_BESTANDSLOG_OWNER_UUID}  (${_bl_owner_quelle})"
    echo "  maschine = ${COMDARE_BESTANDSLOG_MASCHINE}"
    echo "  Hinweis: Ebene B (minio) ist Vorbedingung des Binders. Fehlt sie, meldet"
    echo "           der Lauf 'fehlerklasse=lager_ebene_fehlt' und bindet NICHT."

    unset _bl_host _bl_owner_quelle _bl_key_quelle _bl_messkey_quelle
fi
