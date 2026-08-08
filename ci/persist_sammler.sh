#!/usr/bin/env bash
# =============================================================================
#  PERSIST-SAMMLER -- ein Messfenster wird erst zurueckgeschrieben, wenn es
#  MESSWERTE traegt, nicht schon, wenn es Dateien traegt.          (2026-08-08)
# =============================================================================
#
# DER BEFUND, GEGEN DEN ER GEBAUT IST (D3-3):
# Der Job persist:measurements entschied ueber das VORHANDENSEIN von Dateien,
# nicht ueber deren INHALT. Er zaehlte kopierte Dateien in n_csv, machte daraus
# persisted, und reichte an `git add -- measurement/` + `git commit` weiter.
# Eine measurements.csv mit ausschliesslich der Kopfzeile lief dort glatt durch.
# Schaerfer noch: PROVENANCE.txt wird IMMER geschrieben, der Laufordner war also
# NIE leer -- der Commit war selbst dann faellig, wenn ueberhaupt keine Mess-CSV
# vorlag. Das leere Messfenster wurde additiv nach development zurueckgeschrieben
# und lag unter "Messdaten werden nie geloescht" fuer immer im Baum. Das ist
# dieselbe Fehlerklasse wie D3 (leeres Messfenster als Erfolg), eine Stufe
# weiter in der Kette -- und die teuerste, weil sie dauerhaft wird.
#
# WARUM EIN SKRIPT UND NICHT ZWEI GEHEILTE YAML-ZEILEN:
# Logik in einem YAML-Block ist nicht probefaehig. Der Beweis dieses Pakets wird
# AM GIT-ZUSTAND gefuehrt (ci/tests/persist_sammler_probe.sh, Sandbox-Klon), und
# dafuer muss der Entscheider aufrufbar sein. Derselbe Weg wie bei der
# Mess-Ausbeute-Wache: erst string-identisch heben und beweisen, dass sich
# nichts geaendert hat, dann heilen.
#
# ZAEHLWEISE, ausdruecklich benannt -- IDENTISCH zu ci/mess_ausbeute_wache.sh:
#   Datenzeilen = (Zeilen der Datei) - 1, weil die erste Zeile der CSV-Kopf ist.
#   Gezaehlt wird mit awk 'END{print NR+0}', NICHT mit `wc -l`: wc zaehlt
#   Zeilenumbrueche, eine Datei ohne abschliessenden Newline wuerde eine Zeile
#   zu wenig melden. Eine voellig leere Datei hat 0 Zeilen und damit 0
#   Datenzeilen (NICHT -1) -- der Sonderfall ist unten ausdruecklich behandelt.
#   Zwei Gates derselben Kette duerfen sich nicht in der Zaehlweise
#   widersprechen; deshalb wortgleich uebernommen.
#
# WELCHE DATEIEN GEZAEHLT WERDEN -- und worin das von der Wache ABWEICHT:
#   Gezaehlt werden ALLE *.csv unter measure_out/ und measure_out_smoke/ des
#   Laufordners. Die Mess-Ausbeute-Wache zaehlt enger, naemlich nur Dateien
#   namens measurements.csv. Der Unterschied ist gewollt und hier richtig: die
#   Wache fragt "hat der Messlauf sein Hauptergebnis erzeugt", der Sammler
#   fragt "gibt es ueberhaupt Messdaten, die aufzuheben sich lohnt" -- und die
#   per-Binary-result.csv sind echte Messdaten. Die Zaehlweise (awk, minus Kopf,
#   leer = 0) ist dieselbe; nur der Selektor ist breiter.
#
# WARUM DAS GATE AN DEN DATENZEILEN HAENGT UND NICHT AN persisted:
#   persisted zaehlt Artefakt-GRUPPEN (PDF, Manifest, measure_out, smoke). Ein
#   Lauf ohne einen einzigen Messwert, aber mit einem build_manifest.txt, hat
#   persisted=1 -- und haette unter der alten Logik committet. Der Laufordner
#   ist das Mess-Archiv; ein Eintrag ohne Messwert ist dort ein Phantom.
#   BEWUSSTE FOLGE, benannt: bleibt ein Lauf ohne Datenzeilen, wird auch ein
#   vorhandenes PDF/Manifest NICHT zurueckgeschrieben. Beide leben weiter im
#   Pipeline-Artefakt (12 Wochen) bzw. im thesis-Submodul; das Mess-Archiv
#   bleibt dafuer frei von Laufordnern ohne Messwert.
#
# WARUM BASH UND NICHT sh: der gehobene Rumpf nutzt Prozess-Substitution
# (`while ... done < <(find ...)`) und `local` -- beides ist BASH, nicht POSIX.
# Der GitLab-Runner fuehrt `script:` ohnehin unter bash aus.
#
# AUFRUF:
#   bash ci/persist_sammler.sh sammeln <run_ts>
#   bash ci/persist_sammler.sh gate    <run_ts>
#
# EXIT (sammeln): 0 = eingesammelt, Bilanz gedruckt und in PROVENANCE.txt
# EXIT (gate):    0 = ein Commit wurde erzeugt -> der Aufrufer muss pushen
#                10 = KEIN Commit (leeres Messfenster oder nichts einzuchecken);
#                     das ist KEIN Fehler, der Job endet gruen ohne Rueckschrieb
#                 2 = konnte nicht pruefen (Argument fehlt, kein Git-Baum,
#                     Laufordner fehlt, Bilanz widerspricht der PROVENANCE) --
#                     ausdruecklich KEIN Gruen: ein stiller Rueckfall waere
#                     derselbe Defekt wie der geheilte.
#
# UNGEDECKT, ausdruecklich benannt: der Netz-Push-Retry-Pfad (push -o ci.skip,
# non-ff-Erkennung, merge --no-edit, merge --abort) bleibt im YAML und ist ohne
# echten, sich waehrend des Laufs bewegenden origin nicht probefaehig.
# =============================================================================

set -euo pipefail

# Wurzeln der Datenzeilen-Bilanz. Beide, nicht nur golden: der Smoke-Lauf
# erzeugt echte Messdaten, und eine Summe ueber nur eine Wurzel wuerde ein
# Fenster faelschlich als leer verwerfen.
ZAEHL_WURZELN="measure_out measure_out_smoke"

MODUS="${1:-}"
RUN_TS="${2:-}"

if [ -z "$MODUS" ] || [ -z "$RUN_TS" ]; then
    echo "AUFRUF: bash ci/persist_sammler.sh <sammeln|gate> <run_ts>" >&2
    exit 2
fi
case "$MODUS" in
    sammeln|gate) : ;;
    *) echo "ABBRUCH: unbekannter Modus '$MODUS' (erlaubt: sammeln, gate)" >&2; exit 2 ;;
esac
git rev-parse --git-dir > /dev/null 2>&1 || {
    echo "ABBRUCH: kein Git-Arbeitsbaum -- der Sammler konnte nicht pruefen." >&2; exit 2; }

BK=measurement; DEST="$BK/$RUN_TS"

CSV_GESAMT=0; CSV_MIT_DATENZEILE=0; DATENZEILEN_GESAMT=0

# Zaehlt die Datenzeilen im Laufordner $1. Setzt die drei Zahlen oben.
# DREI ZAHLEN, nie eine nackte Null: "0 Datenzeilen" heisst etwas voellig
# anderes bei 0 gefundenen CSVs (der Messlauf lief gar nicht) als bei 40
# gefundenen CSVs (40 Prueflinge haben nichts geliefert).
bilanz_zaehlen() {
    local wurzel liste zf zeilen daten
    CSV_GESAMT=0; CSV_MIT_DATENZEILE=0; DATENZEILEN_GESAMT=0
    liste=$(mktemp) || exit 2
    for wurzel in $ZAEHL_WURZELN; do
        [ -d "$1/$wurzel" ] || continue
        find "$1/$wurzel" -type f -name '*.csv' >> "$liste"
    done
    CSV_GESAMT=$(awk 'END{print NR+0}' "$liste")
    while IFS= read -r zf; do
        [ -n "$zf" ] || continue
        zeilen=$(awk 'END{print NR+0}' "$zf")
        if [ "$zeilen" -le 1 ]; then
            daten=0
        else
            daten=$((zeilen - 1))
            CSV_MIT_DATENZEILE=$((CSV_MIT_DATENZEILE + 1))
        fi
        DATENZEILEN_GESAMT=$((DATENZEILEN_GESAMT + daten))
    done < "$liste"
    rm -f "$liste"
}

bilanz_drucken() {
    echo "-- Datenzeilen-Bilanz (Nenner, nie eine nackte Null) --"
    echo "  csv_gesamt=$CSV_GESAMT"
    echo "  csv_mit_datenzeile=$CSV_MIT_DATENZEILE"
    echo "  datenzeilen_gesamt=$DATENZEILEN_GESAMT"
}

if [ "$MODUS" = sammeln ]; then
# --- BEGINN GEHOBENER BLOCK A (.gitlab-ci.yml 1048-1103, string-identisch) ---
BK=measurement; DEST="$BK/$RUN_TS"; mkdir -p "$DEST"
echo "== persist -> $DEST =="
# ── (2) prebackup(): additiv, sha256-verifiziert, NIE ueberschreiben (Muster aus prebackup:measurements) ──
sha() { sha256sum < "$1" | cut -d' ' -f1; }
prebackup() {
  local src="$1" ver="$2" dir base dst
  dir="$BK/$ver"; mkdir -p "$dir"; base=$(basename "$src"); dst="$dir/$base"
  if [ -e "$dst" ]; then
    if [ "$(sha "$src")" = "$(sha "$dst")" ]; then echo "  idempotent: $base@$ver (gleicher sha256)"; return 0; fi
    echo "  SCHUTZ: $base@$ver ABWEICHENDER sha256 -> Overwrite VERBOTEN"; return 3
  fi
  cp -- "$src" "$dst"
  [ "$(sha "$src")" = "$(sha "$dst")" ] || { echo "  FEHLER: sha-Mismatch $base@$ver"; return 1; }
  echo "  gesichert: $base@$ver (sha256=$(sha "$dst"))"
}
# ── (3) Auswertungs-Dokumente einsammeln (fehlende tolerieren) ──
persisted=0
for pdf in thesis/diplomarbeit/*.pdf; do [ -e "$pdf" ] || continue; prebackup "$pdf" "$RUN_TS"; persisted=$((persisted+1)); done
if [ -f manifest_out/build_manifest.txt ]; then prebackup manifest_out/build_manifest.txt "$RUN_TS"; persisted=$((persisted+1)); fi
# Anti-Phantom (Review 2026-07-12, Ledger §G2 / §0-DoD-6 Mess-Integritaet): der prebackup:measurements-
# Job ist ein reiner MECHANISMUS-SELBSTTEST (synthetische "messung v1/v2"-CSVs in prebackup_selftest_store/).
# Er wird via seinem EIGENEN 12-Wochen-Artefakt belegt und bewusst NICHT in den autoritativen
# measurement/<RUN_TS>/-Baum kopiert — sonst akkumuliert Fake-Material unter der Nie-loeschen-Doktrin.
# REAL versionierte Mess-CSV-Sicherungen (NAS/MinIO) sind #202-gegatet; sobald ein echter Backup-
# Produzent existiert, bekommt er hier einen EIGENEN Sammler, der ausschliesslich echte Daten aufnimmt.
# measure_out/ = die golden-320-Mess-CSVs des measure:golden-320-Jobs (nur bei COMDARE_RUN_MEASURE-Lauf vorhanden).
# NUR *.csv strukturerhaltend kopieren — NIE die ~320 DLL-Binaries (Repo-Bloat). Die .gitignore-Negation
# !measurement/**/*.csv macht die kopierten CSVs trackbar (sonst droppt `git add` sie via *.csv-Regel).
if [ -d Code/measure_out ]; then
  n_csv=0
  while IFS= read -r f; do
    rel="${f#Code/measure_out/}"; mkdir -p "$DEST/measure_out/$(dirname "$rel")"
    cp -- "$f" "$DEST/measure_out/$rel"; n_csv=$((n_csv+1))
  done < <(find Code/measure_out -type f \( -name '*.csv' -o -name '*.tex' \))
  if [ "$n_csv" -gt 0 ]; then echo "  gesichert: measure_out/ ($n_csv Mess-CSVs + regenerierte Anhang-.tex, keine DLL-Binaries)"; persisted=$((persisted+1)); fi
fi
# measure_out_smoke/ = die Smoke-/Coverage-Mess-CSVs des measure:smoke-Jobs (#26/GO-5) — gleiche
# additive Mechanik, eigener Zielordner (kollisionsfrei zum golden-Lauf derselben Pipeline).
if [ -d Code/measure_out_smoke ]; then
  n_csv=0
  while IFS= read -r f; do
    rel="${f#Code/measure_out_smoke/}"; mkdir -p "$DEST/measure_out_smoke/$(dirname "$rel")"
    cp -- "$f" "$DEST/measure_out_smoke/$rel"; n_csv=$((n_csv+1))
  done < <(find Code/measure_out_smoke -type f \( -name '*.csv' -o -name '*.tex' \))
  if [ "$n_csv" -gt 0 ]; then echo "  gesichert: measure_out_smoke/ ($n_csv Smoke-Mess-CSVs + regenerierte Anhang-.tex, keine DLL-Binaries)"; persisted=$((persisted+1)); fi
fi
# --- ENDE GEHOBENER BLOCK A (bis hierher string-identisch) -------------------
    # HEILUNG (D3-3): erst zaehlen, dann die PROVENANCE schreiben. Die drei
    # Zahlen sind ADDITIV -- alle bisherigen Felder bleiben unveraendert
    # stehen, damit niemand, der die Datei heute liest, still bricht.
    bilanz_zaehlen "$DEST"
    {
      echo "# persist:measurements Laufordner — Provenance (#22, Ledger §11-G)"
      echo "run_ts=$RUN_TS"
      echo "generated_at_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
      echo "ci_pipeline_id=${CI_PIPELINE_ID:-NA}"; echo "ci_pipeline_url=${CI_PIPELINE_URL:-NA}"
      echo "super_commit_sha=${CI_COMMIT_SHA:-$(git rev-parse HEAD 2>/dev/null || echo NA)}"
      echo "super_commit_ref=${CI_COMMIT_REF_NAME:-NA}"; echo "persisted_artifact_count=$persisted"
      echo "csv_gesamt=$CSV_GESAMT"
      echo "csv_mit_datenzeile=$CSV_MIT_DATENZEILE"
      echo "datenzeilen_gesamt=$DATENZEILEN_GESAMT"
    } > "$DEST/PROVENANCE.txt"
    echo "-- Laufordner --"; find "$DEST" -type f | sort
    bilanz_drucken
    echo "  persisted_artifact_count=$persisted"
    if [ "$CSV_GESAMT" -gt 0 ] && [ "$CSV_MIT_DATENZEILE" -lt "$CSV_GESAMT" ]; then
        echo "BEFUND: $((CSV_GESAMT - CSV_MIT_DATENZEILE)) von $CSV_GESAMT CSV-Datei(en) tragen KEINE Datenzeile."
        echo "        Das ist ein Befund, kein Rauschen -- er gehoert in die Auswertung."
    fi
    if [ "$persisted" -eq 0 ]; then
        echo "WARNUNG: keine Auswertungs-Dokumente gefunden (nur PROVENANCE.txt)"
    fi
    # Das `exit 0` ist Pflicht, nicht Kosmetik: stuende hier als letzte
    # Anweisung das urspruengliche `[ "$persisted" -eq 0 ] && echo ...`, waere
    # dessen rc=1 im NORMALFALL (persisted != 0) der Exit-Status des Skripts.
    # Im YAML-Block folgten weitere Kommandos, dort fiel das nicht auf.
    exit 0
fi

# =============================================================================
#  MODUS gate -- das Commit-Gate. Hier entscheidet sich, ob ein Messfenster
#  dauerhaft in den Baum kommt.
# =============================================================================
if [ ! -d "$DEST" ]; then
    echo "ABBRUCH: Laufordner '$DEST' fehlt -- 'sammeln' lief nicht oder scheiterte." >&2
    echo "         Kein Gruen ohne Pruefung." >&2
    exit 2
fi

# ERNEUT ZAEHLEN statt der Textdatei zu glauben: das Gate darf sich nicht auf
# eine Zahl verlassen, die es selbst nicht nachgerechnet hat. Die PROVENANCE
# dient danach als GEGENPROBE -- weichen beide ab, ist etwas zwischen Sammeln
# und Gate passiert, und dann wird nicht geraten, sondern abgebrochen.
bilanz_zaehlen "$DEST"
PROV="$DEST/PROVENANCE.txt"
PROV_N=$(awk -F= '/^datenzeilen_gesamt=/{print $2+0; found=1} END{if(!found) print "KEINE"}' "$PROV" 2>/dev/null || echo KEINE)
if [ "$PROV_N" = KEINE ]; then
    echo "ABBRUCH: '$PROV' traegt kein Feld datenzeilen_gesamt= -- Bilanz nicht gegenpruefbar." >&2
    exit 2
fi
if [ "$PROV_N" -ne "$DATENZEILEN_GESAMT" ]; then
    echo "ABBRUCH: Bilanz widerspricht der PROVENANCE: nachgezaehlt=$DATENZEILEN_GESAMT, PROVENANCE=$PROV_N." >&2
    echo "         Zwischen Sammeln und Gate hat sich der Laufordner veraendert. Kein Rueckschrieb." >&2
    exit 2
fi

gate_verweigern() {
    echo "KEIN COMMIT: das Messfenster traegt 0 Datenzeile(n)."
    echo "  csv_gesamt=$CSV_GESAMT  csv_mit_datenzeile=$CSV_MIT_DATENZEILE  datenzeilen_gesamt=$DATENZEILEN_GESAMT"
    echo "  Eine vorhandene Datei ist KEIN Messwert. Der Laufordner bleibt auf der"
    echo "  Platte (das Artefakt haelt ihn 12 Wochen), aber er wird NICHT additiv"
    echo "  nach '$( [ -n "${CI_COMMIT_BRANCH:-}" ] && echo "$CI_COMMIT_BRANCH" || echo development )' zurueckgeschrieben."
    exit 10
}
if [ "$DATENZEILEN_GESAMT" -eq 0 ]; then gate_verweigern; fi   # GATE-MUTATIONSMARKE

echo "COMMIT-GATE OK: $DATENZEILEN_GESAMT Datenzeile(n) aus $CSV_MIT_DATENZEILE von $CSV_GESAMT CSV-Datei(en) -> Rueckschrieb."

# --- BEGINN GEHOBENER BLOCK B (.gitlab-ci.yml 1105 + 1110-1112) ---------------
# ZWEI Abweichungen vom gehobenen Rumpf, beide ausdruecklich benannt:
#
# (a) Das `exit 0` im "nichts einzuchecken"-Zweig ist ein `exit 10`, damit der
#     Aufrufer "kein Commit" von "Commit erzeugt" unterscheiden kann. Im YAML
#     war dieser Unterschied die Job-Grenze selbst.
#
# (b) `git add -- measurement/` ist `git add -- "$DEST"`. Das ist KEINE
#     Kosmetik, sondern die zweite Haelfte dieser Heilung, und ohne sie waere
#     die erste wirkungslos: persist:measurements laeuft auf einem PERSISTENTEN
#     baremetal-Workspace (tags: [baremetal], GIT_STRATEGY: fetch). Der
#     Laufordner einer vom Gate ABGELEHNTEN Pipeline bleibt dort auf der Platte.
#     Staged der naechste Lauf `measurement/` als GANZES, nimmt sein Commit das
#     abgelehnte, leere Fenster mit -- das Phantom kaeme eine Pipeline spaeter
#     doch in den Baum. Das Gate haette es dann nicht verhindert, sondern nur
#     verschoben. Gestaged wird deshalb ausschliesslich der Laufordner DIESES
#     Laufs; measurement/<RUN_TS>/ ist ohnehin disjunkt (Begruendung der
#     Merge-Strategie im Job-Kopf). Gedeckt durch Fall P11 der Probe.
git config user.name "measurement-bot"; git config user.email "measurement-bot@ci.local"
git add -- "$DEST"
if git diff --cached --quiet; then echo "nichts einzuchecken (leerer Commit vermieden)"; exit 10; fi
git commit -m "measurement(#22): Lauf ${CI_PIPELINE_ID:-NA} ${RUN_TS} [skip ci]"
# --- ENDE GEHOBENER BLOCK B ---------------------------------------------------
exit 0
