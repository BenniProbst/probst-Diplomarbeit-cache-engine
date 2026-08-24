#!/usr/bin/env bash
# =====================================================================================
# anhang_forward_core.sh -- KERN des LaTeX-Anhang-VORWAERTS-Kanals (E-18, Paket B1).
#
# WARUM DIESE DATEI EXISTIERT (und nicht alles im YAML steht):
#   Der Kanal MUSS ohne CI und ohne echte Messung an einem Fixture beweisbar sein
#   (Idempotenz, Whitelist, NO-OP, Nichts-Loeschen). Ein YAML-Script-Block ist nicht
#   fahrbar; darum liegt die gesamte Kern-Logik hier, env-parametrisiert, und die
#   .gitlab-ci.yml umhuellt sie nur mit Credentials + Klon + Gitlink-Bump.
#   EINE Quelle statt zwei -- was die CI tut, ist genau das, was das Fixture beweist.
#
# WAS DER KERN TUT (Quellen-Kaskade, deterministisch):
#   (1) frische Pipeline-Artefakte  <root>/<lang>/tabellen/*.tex   (AF_ARTIFACT_ROOTS,
#       in DEKLARIERTER Reihenfolge; der erste Wurzel-Kandidat mit >0 .tex gewinnt)
#   (2) sonst Korpus-Regeneration aus dem NEUESTEN <AF_CORPUS_ROOT>/<RUN_TS>/ mit
#       Mess-CSV (Selektor AF_RESULT_NAMEN: 'result.csv' UND '*.result.csv';
#       replace-Semantik: neuester Lauf gewinnt) -> WIDE-Konkatenation
#       -> appendix-generator
#   (3) sonst honest-empty: NO-OP-Testat, Exit 0, KEIN Commit
#       (die Thesis haelt das per \InputIfFileExists aus -- Weg A ist gebaut)
#   Danach: Whitelist-Kopie nach <AF_DEST_REPO>/anhang/<lang>/tabellen/, Idempotenz-
#   Pruefung (Commit NUR bei Byte-Delta), Commit mit Provenance, Push mit MERGE-Retry.
#
# HARTE ZUSAGEN (am Fixture bewiesen, s. Plan-Dossier Abschnitt B-2):
#   * schreibt AUSSCHLIESSLICH nach anhang/<lang>/tabellen/<name>.tex  (Whitelist)
#   * loescht NIEMALS Bestand im Ziel-Repo: kein `git rm`, kein `git clean`, kein --force.
#     Der EINZIGE rm-Pfad im ganzen Script ist der Rollback bei ROTEM PDF-Gate, und der
#     entfernt AUSSCHLIESSLICH Pfade, die DIESER Lauf selbst neu angelegt hat: Grundlage
#     ist die Buchfuehrungs-Liste $COPIED_LIST, jeder Eintrag wird zusaetzlich gegen
#     `git ls-files --error-unmatch` geprueft. Getrackte Dateien werden per `git checkout`
#     zurueckgeholt (nie geloescht); fremde unversionierte Dateien im selben Verzeichnis
#     bleiben unangetastet (am Fixture sha256-identisch nachgewiesen).
#   * ohne Byte-Delta entsteht KEIN Commit  (Loop-/Rausch-Wache) -- und "kein Delta"
#     ist BELEGT, nicht behauptet: jede kopierte .tex wird gegen den Index des
#     Ziel-Repos nachgezaehlt; erreicht eine den Index nicht, bricht der Kanal LAUT
#     ab statt "IDEMPOTENT" zu melden (##20, 10.08.2026, Falle F5 unten)
#   * ohne Quelle entsteht KEIN Commit und KEIN Fehler (honest-empty)
#   * landet AUF EINEM TeX-FAEHIGEN RUNNER nie einen Stand, mit dem die Thesis-PDF nicht
#     mehr baut (PDF-GATE; deklarierter Geltungsbereich + Grenzen s.u. -- ohne
#     TeX-Toolchain prueft AF_PDF_GATE=auto NICHTS und sagt das literal)
#   * kein Haken ohne Ausgabe: jede Stufe druckt ihren literalen Zaehler
#
# FUENF TRANSPORT-FALLEN, GEHEILT AM 09./10.08.2026 (P4 + Nachsatz + ##20) -- alle still:
#   (F1) DER SELEKTOR TRAF DIE REALE DATEI NIE. Gesucht wurde '-name "*.result.csv"'
#        (:149 :153 :165 der Vorfassung); der lebende Messweg schreibt 'result.csv'
#        OHNE Praefix. Der Glob verlangt mindestens ein Zeichen plus Punkt davor.
#        Selbst nachgemessen: ein Verzeichnis mit result.csv UND perm_007.result.csv,
#        dann 'find -name "*.result.csv"' liefert ausschliesslich perm_007.result.csv.
#   (F2) DIE LEERHEITSPRUEFUNG VERWARF GENAU EINE DATENZEILE. 'wc -l' zaehlt
#        Zeilenumbrueche; Kopfzeile + EINE Datenzeile ohne Schluss-Newline ergab 1
#        und galt als leer. Das ist exakt der Mini-Messwert des Durchstichs.
#   (F3) DIE KONKATENATION VERKLEBTE ZEILEN. 'tail -n +2 >>' ohne 'awk 1' haengte
#        die erste Datenzeile der naechsten Datei an die letzte der vorigen, sobald
#        der Schluss-Newline fehlte -- aus zwei Messwerten wurde eine kaputte Zeile.
#   (F4) DER HEADER-DIEB (Nachsatz, :277 der Fassung davor). Der Header wurde von
#        der ersten Datei genommen, die der Schleife unterkam -- ohne zu pruefen, ob
#        die ueberhaupt eine erste Zeile HAT. Eine 0-Byte-result.csv, die im 'sort'
#        vor der vollen liegt, lieferte nichts und setzte trotzdem '_hdr=1'; die
#        volle Datei danach kam nur noch durch 'tail -n +2' und verlor ihre
#        Kopfzeile. Das Aggregat war KOPFLOS. Mit EINER Datenzeile der Nachbardatei
#        galt es als leer -> honest-empty, kein Commit, Messwert weg. Mit ZWEI
#        Datenzeilen landete der Commit, und jeder NR>1-Konsument -- auch der echte
#        appendix-generator -- frass die erste Datenzeile als Kopfzeile: ein
#        GRUENER Commit mit einem Messwert weniger. Die Log-Zeile log dabei mit
#        ("1 Zeilen (inkl. 1 Header)", obwohl kein Header da war).
#   (F5) DIE UEBERNAHME INS ZIEL-REPO WURDE NIE NACHGEZAEHLT (10.08.2026, ##20).
#        Gestagt wurde das VERZEICHNIS mit geschluckten Fehlern; ob die kopierten
#        .tex im Index ankamen, hat niemand gefragt. Nahm git sie nicht, sagte der
#        Kanal "IDEMPOTENT: 0 Aenderungen" und ging mit rc=0 -- dasselbe Wort fuer
#        "nichts geaendert" und "nichts angekommen". Ausfuehrlich am Abschnitt (3).
#   Alle fuenf endeten mit rc=0 und einer Ausgabe, die wie ein ehrliches "nichts zu
#   tun" aussah (F4b sogar mit gruenem Commit). Deshalb druckt der Korpus-Zweig
#   jetzt IMMER einen Nenner (korpus_wurzel/vorhanden + laufordner_geprueft/
#   mit_material + header=ja|nein/Datenzeilen) und die Uebernahme ebenfalls
#   (kopiert/im_index/nicht_uebernommen/git_add_fehler): eine Null ohne Nenner ist
#   von einem echten Freispruch nicht zu unterscheiden.
#   Beweis: ci/tests/anhang_forward_probe.sh (Faelle A1-A14, Selbstbiss N1-N7).
#
# WO DIE KONKATENATION SEIT DEM 09.08.2026 WOHNT (P4c):
#   NICHT MEHR HIER. F2/F3/F4 sassen in Zeilen, die WORTGLEICH auch in den beiden
#   measure-Jobs der .gitlab-ci.yml standen -- drei Kopien, von denen nur diese
#   gedeckt war. Sie stehen jetzt EINMAL in ci/wide_aggregat.sh, und alle drei
#   rufen sie. Die Mutanten N2/N3/N5 greifen dort an und decken damit alle drei
#   Aufrufer; Fall A11 haelt fest, dass kein vierter Zwilling zurueckkehrt.
#   HIER GEBLIEBEN ist, was nur den Anhang-Kanal angeht: der Selektor (F1), das
#   'sort' und das Urteil ueber die Zahl (honest-empty).
#
# OFFEN, ausdruecklich NICHT geraten: AF_CORPUS_ROOT zeigt in der Voreinstellung
#   (und im CI-Job, .gitlab-ci.yml AF_CORPUS_ROOT="measurement") auf 'measurement'
#   am Repo-Root. Dieses Verzeichnis EXISTIERT dort nicht mehr -- 'git ls-files
#   measurement/*' liefert 0 Eintraege, der getrackte Korpus liegt seit dem
#   08.08.2026 unter docs/architektur/measurement/ (18 Dateien). Zur CI-Laufzeit
#   legt persist:measurements den Pfad auf dem baremetal-Workspace selbst an; ob
#   der Kanal DEN oder den getrackten Korpus lesen soll, ist eine Owner-Frage und
#   wird hier NICHT durch eine geratene Zweit-Wurzel beantwortet: der archivierte
#   Baum liegt eine Ebene tiefer verschachtelt, eine automatische Aufnahme wuerde
#   den Erstbeleg vom 26.07. als "neuesten Lauf" vorwaerts schieben. Statt zu
#   raten sagt der Kanal jetzt literal 'vorhanden=nein' und nennt den Nenner.
#
# PDF-GATE -- WARUM ES HIER STEHT UND NICHT ERST IN DER 289-PIPELINE:
#   Am Fixture (2026-08-05, echte D-03-Erstbeleg-Daten) hat sich gezeigt, dass der
#   Generator fuer eine Metrik OHNE Messwerte trotzdem eine Heatmap schreibt, deren
#   z-Matrix komplett 0.0000 ist; pgfplots bricht daran FATAL ab ("Error using 'plot
#   graphics': I got too few coordinates") und es entsteht GAR KEINE PDF. Die 12
#   Kern-Tabellen haengen in A_measurements.tex an blankem \input (nur die 5
#   Darstellungs-.tex an \InputIfFileExists) -- eine einzelne Datei wegzulassen ist also
#   KEINE Rettung. Der Kanal prueft darum VOR dem Commit, ob die Thesis mit dem neuen
#   Stand noch baut, und verweigert im Fehlerfall ALLES (alles-oder-nichts, fail-loud).
#   Ohne diese Wache wuerde E-18 einen kaputten Anhang in die Thesis schieben und die
#   PDF-Strecke reissen -- das genaue Gegenteil seines Zwecks.
#
# PDF-GATE -- DEKLARIERTER GELTUNGSBEREICH (bewusste Grenze, kein Versehen):
#   (a) EIN Hauptdokument. run_pdf_gate waehlt das ERSTE Top-Level-*.tex mit \documentclass
#       (`grep -lE '^[^%]*\\documentclass' -- *.tex | head -1`) und baut NUR dieses. Heute
#       deckungsgleich mit dem Vollbestand, weil Projekt 289 genau EIN Top-Level-Haupt-
#       dokument traegt (diplomarbeit.tex; am Gitlink-Checkout 05.08.2026 verifiziert).
#       Kaeme ein zweites hinzu (z.B. ein eigenes EN-Hauptdokument), pruefte das Gate NUR
#       das erste -- dann ist diese Auswahl auf eine LISTE zu erweitern. Bis dahin gilt die
#       Zusage ausdruecklich nur fuer das erste Hauptdokument.
#   (b) KEINE TeX-Toolchain => KEINE Pruefung. AF_PDF_GATE=auto ueberspringt das Gate auf
#       Runnern ohne latexmk/pdflatex und LOGGT das literal ("hier wurde NICHT geprueft").
#       Die Zusage "landet nie einen kaputten Stand" gilt also nur auf TeX-faehigen
#       Runnern; das Restnetz ausserhalb davon ist die 289-Pipeline NACH dem Push.
#       Wer die Pruefung erzwingen will, setzt AF_PDF_GATE=on (fehlende Toolchain = Fehler).
#   (c) Das Gate prueft die BAUBARKEIT, nicht die inhaltliche Richtigkeit der Tabellen.
#
# ENV-KONTRAKT
#   AF_DEST_REPO      (Pflicht) Arbeitsklon des Thesis-Repos (Projekt 289)
#   AF_BRANCH         Ziel-Branch im Ziel-Repo                      (Default: development)
#   AF_LANGS          Komma-Liste der Sprachen                      (Default: de,en)
#   AF_WORK_ROOT      Basis fuer Artefakt-/Korpus-Pfade             (Default: .)
#   AF_ARTIFACT_ROOTS Leerzeichen-Liste der Artefakt-Wurzeln
#                     (Default: Code/measure_out/appendix Code/measure_out_smoke/appendix)
#   AF_CORPUS_ROOT    Rueckschreibe-Korpus                          (Default: measurement)
#                     ACHTUNG: dieser Default zeigt am Repo-Root ins Leere, s.o.
#   AF_RESULT_NAMEN   Namensformen der Mess-CSV, Leerzeichen-Liste
#                     (Default: "result.csv *.result.csv" -- BEIDE, OV-17 offen)
#   AF_GENERATOR      Pfad zur appendix-generator-Binary            (Default: leer)
#   AF_WIDE_AGGREGAT  Pfad zur EINEN WIDE-Konkatenation
#                     (Default: <verzeichnis dieser datei>/wide_aggregat.sh)
#                     Die Probe setzt ihn auf ihre Mutanten (Selbstbiss N2/N3/N5).
#   AF_TMP            Arbeitsverzeichnis                            (Default: mktemp -d)
#   AF_DRY_RUN        true => kopieren+stagen, aber KEIN Commit, KEIN Push
#   AF_NO_PUSH        true => Commit ja, Push nein (Fixture ohne Remote)
#   AF_PDF_GATE       auto (Default) | on | off -- PDF-Bau-Wache vor dem Commit.
#                     auto: laeuft, wenn TeX-Toolchain UND Haupt-.tex vorhanden sind;
#                     on:   fehlende Toolchain ist ein FEHLER; off: bewusst abgeschaltet.
#                     Geltungsbereich s.o. (a)-(c): NUR das ERSTE Top-Level-Haupt-.tex.
#   AF_PUSH_RETRIES   Push-/Merge-Versuche                          (Default: 5)
#   AF_PROV_*         Provenance fuer die Commit-Botschaft (PIPELINE_ID/URL/SUPER_SHA/REF)
#
# EXIT: 0 = Commit gelandet ODER bewusst nichts zu tun. 1 = fail-loud (nie stilles Gruen).
# =====================================================================================
set -euo pipefail

AF_DEST_REPO="${AF_DEST_REPO:-}"
AF_BRANCH="${AF_BRANCH:-development}"
AF_LANGS="${AF_LANGS:-de,en}"
AF_WORK_ROOT="${AF_WORK_ROOT:-.}"
AF_ARTIFACT_ROOTS="${AF_ARTIFACT_ROOTS:-Code/measure_out/appendix Code/measure_out_smoke/appendix}"
AF_CORPUS_ROOT="${AF_CORPUS_ROOT:-measurement}"
AF_GENERATOR="${AF_GENERATOR:-}"
AF_DRY_RUN="${AF_DRY_RUN:-false}"
AF_NO_PUSH="${AF_NO_PUSH:-false}"
AF_PDF_GATE="${AF_PDF_GATE:-auto}"
AF_PUSH_RETRIES="${AF_PUSH_RETRIES:-5}"
AF_PROV_PIPELINE_ID="${AF_PROV_PIPELINE_ID:-NA}"
AF_PROV_PIPELINE_URL="${AF_PROV_PIPELINE_URL:-NA}"
AF_PROV_SUPER_SHA="${AF_PROV_SUPER_SHA:-NA}"
AF_PROV_SUPER_REF="${AF_PROV_SUPER_REF:-NA}"

# ---- DIE EINE WIDE-KONKATENATION: DREI AUFRUFER, EINE DATEI ---------------------------
# SELBSTCHECK (P4c, 2026-08-09):
#   DER DEFEKT, den das heilt: dieselbe Aggregation stand DREIMAL im Bestand --
#     hier, in .gitlab-ci.yml Job measure:smoke und in Job measure:golden-320.
#     Nur DIESE Kopie war gedeckt. Am Objekt nachgemessen, bevor die Datei
#     entstand: ein Mutant, der den beiden YAML-Kopien ihr 'awk 1' nimmt, liess
#     SECHS von sechs lauffaehigen Wachen gruen (die siebte war mit und ohne
#     Mutation gleich rot und taugt nicht als Unterscheider).
#   ZUGESICHERT: es gibt die Konkatenation und die Zaehlung ab jetzt genau
#     einmal, in ci/wide_aggregat.sh. Wer sie dort mutiert, macht diese Probe
#     rot -- und deckt damit alle drei Aufrufer.
#   NICHT zugesichert: dass niemand eine VIERTE Kopie einfuegt. Dagegen steht
#     Fall A11 der Probe (kein Inline-Zwilling mehr in der .gitlab-ci.yml).
AF_SELBST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
AF_WIDE_AGGREGAT="${AF_WIDE_AGGREGAT:-$AF_SELBST_DIR/wide_aggregat.sh}"

# ---- DER SELEKTOR: EINE Definition, DREI Verwendungen ---------------------------------
# SELBSTCHECK (P4, 2026-08-09):
#   ZUGESICHERT: alle drei Fundstellen der Korpus-Kaskade -- Laufordner-Suche,
#     Zaehlung, Konkatenation -- benutzen GENAU DIESE Namensliste. Sie koennen
#     nicht mehr auseinanderlaufen, weil es nur noch eine Stelle gibt, an der ein
#     Name steht. Vor diesem Paket standen drei Kopien des Musters nebeneinander
#     (:149, :153, :165).
#   ZUGESICHERT: BEIDE Namensformen werden akzeptiert.
#     * 'result.csv' OHNE Praefix ist der LEBENDE Messweg. Beleg: ce
#       libs/cache_engine/profile_facade/planner/planner_status_types.hpp:33
#       'inline constexpr char kResultCsvName[] = "result.csv"' und
#       libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:1142
#       'std::filesystem::path const csv_p = dir / "result.csv"'.
#     * '<stem>.result.csv' ist die ARCHIVFORM. Sie existiert real: 8 Dateien
#       unter docs/architektur/measurement/erstbeleg-d03-20260726/.../per_binary/.
#   NICHT zugesichert -- und das ist der Grund fuer die Doppelung: welche der
#     beiden Formen die GEPLANTE ist. Das ist Owner-Frage OV-17 (Ledger:112).
#     Bis zur Antwort werden beide genommen; das ist die einzige Richtung, die
#     keinen Messwert verwerfen kann. Faellt der Entscheid, wird HIER eine Zeile
#     geaendert und sonst nichts.
#   DER DEFEKT, den das heilt: '-name "*.result.csv"' verlangt mindestens ein
#     Zeichen plus Punkt vor 'result.csv' und traf die reale Datei damit NIE --
#     still, mit rc=0 und der Zeile "kein Korpus-Laufordner".
AF_RESULT_NAMEN="${AF_RESULT_NAMEN:-result.csv *.result.csv}"

af_finde_result_csv() {   # $1 = Wurzel ; alle weiteren Argumente = zusaetzliche find-Praedikate
  local wurzel="$1"; shift
  local ausdruck="" n rc=0
  # set -f (Glob-Sperre) ist hier PFLICHT, nicht Stil: die Namensliste enthaelt
  # '*'. Ohne die Sperre loeste die Shell sie gegen das ARBEITSVERZEICHNIS auf,
  # bevor find sie ueberhaupt zu sehen bekaeme -- und je nach cwd kaeme ein
  # anderer Selektor heraus. Danach wird sie sofort wieder aufgehoben.
  set -f
  for n in $AF_RESULT_NAMEN; do
    if [ -z "$ausdruck" ]; then ausdruck="-name $n"; else ausdruck="$ausdruck -o -name $n"; fi
  done
  # shellcheck disable=SC2086 -- $ausdruck MUSS wortgetrennt werden, das ist die find-Syntax.
  find "$wurzel" -type f \( $ausdruck \) "$@" || rc=$?
  set +f
  return "$rc"
}

echo "== anhang:forward KERN (E-18 Vorwaerts-Kanal) =="

# ---- (0) Vorbedingungen: fail-loud statt stilles Gruen -------------------------------
if [ -z "$AF_DEST_REPO" ]; then
  echo "FEHLER: AF_DEST_REPO fehlt (Arbeitsklon des Thesis-Repos 289)" >&2; exit 1
fi
if [ ! -d "$AF_DEST_REPO/.git" ]; then
  echo "FEHLER: AF_DEST_REPO='$AF_DEST_REPO' ist kein git-Arbeitsbaum" >&2; exit 1
fi
AF_TMP="${AF_TMP:-$(mktemp -d)}"
mkdir -p "$AF_TMP"
LANGS="$(printf '%s' "$AF_LANGS" | tr ',' ' ')"
echo "   ziel_repo=$AF_DEST_REPO  branch=$AF_BRANCH  sprachen=[$LANGS]"
echo "   work_root=$AF_WORK_ROOT  dry_run=$AF_DRY_RUN  no_push=$AF_NO_PUSH"

# ---- (1) Quellen-Kaskade -------------------------------------------------------------
echo "-- (1) Quellen-Kaskade --"
SRC_ROOT=""
SRC_KIND=""
SRC_NOTE=""

# (1a) frische Pipeline-Artefakte, in DEKLARIERTER Reihenfolge
for root in $AF_ARTIFACT_ROOTS; do
  cand="$AF_WORK_ROOT/$root"
  [ -d "$cand" ] || { echo "   [1a] $root: nicht vorhanden"; continue; }
  n=0
  for lang in $LANGS; do
    [ -d "$cand/$lang/tabellen" ] || continue
    c=$(find "$cand/$lang/tabellen" -maxdepth 1 -type f -name '*.tex' | awk 'END{print NR+0}')
    n=$((n + c))
  done
  echo "   [1a] $root: $n .tex"
  if [ "$n" -gt 0 ] && [ -z "$SRC_ROOT" ]; then
    SRC_ROOT="$cand"; SRC_KIND="artefakt"; SRC_NOTE="$root"
  fi
done

# (1b) sonst Korpus-Regeneration (replace-Semantik: NEUESTER Laufordner gewinnt)
# SELBSTCHECK Nenner (P4, 2026-08-09):
#   ZUGESICHERT: dieser Zweig druckt IMMER zwei Zahlen mit Nenner --
#     'korpus_wurzel=<pfad> vorhanden=ja|nein' und
#     'laufordner_geprueft=<N> mit_material=<M>'.
#     EINE NULL OHNE NENNER IST VON EINEM ECHTEN FREISPRUCH NICHT ZU
#     UNTERSCHEIDEN. Vorher stand hier nur "kein Korpus-Laufordner mit
#     *.result.csv" -- dieselbe Zeile bei "Korpus leer", "Korpus existiert
#     nicht" und "Selektor trifft nicht". Genau diese Ununterscheidbarkeit hat
#     die Glob-Falle so lange getragen.
#   PREIS, ausdruecklich benannt: fuer den Nenner werden ALLE Laufordner
#     angesehen und nicht mehr beim ersten Treffer abgebrochen. Ordner MIT
#     Material kosten nichts ('-print -quit' haelt beim ersten Fund), Ordner
#     OHNE Material kosten je einen vollen Baumlauf. Das ist der Preis dafuer,
#     dass die Null einen Nenner hat.
#   NICHT geaendert: die replace-Semantik. Der NEUESTE Laufordner (sort -r) mit
#     Material gewinnt weiterhin, jetzt ueber die erste Zuweisung statt ueber
#     ein break.
if [ -z "$SRC_ROOT" ]; then
  CORPUS="$AF_WORK_ROOT/$AF_CORPUS_ROOT"
  RUN_DIR=""
  n_laufordner=0
  n_mit_material=0
  korpus_da=nein
  if [ -d "$CORPUS" ]; then
    korpus_da=ja
    while IFS= read -r d; do
      [ -n "$d" ] || continue
      n_laufordner=$((n_laufordner + 1))
      if [ -n "$(af_finde_result_csv "$d" -print -quit)" ]; then
        n_mit_material=$((n_mit_material + 1))
        [ -z "$RUN_DIR" ] && RUN_DIR="$d"
      fi
    done < <(find "$CORPUS" -mindepth 1 -maxdepth 1 -type d | sort -r)
  fi
  echo "   [1b] korpus_wurzel=$CORPUS vorhanden=$korpus_da"
  echo "   [1b] laufordner_geprueft=$n_laufordner mit_material=$n_mit_material (Selektor: $AF_RESULT_NAMEN)"
  if [ -n "$RUN_DIR" ]; then
    n_csv=$(af_finde_result_csv "$RUN_DIR" | awk 'END{print NR+0}')
    echo "   [1b] Korpus-Regeneration aus $(basename "$RUN_DIR") ($n_csv result.csv, replace-Semantik: neuester Lauf gewinnt)"
    if [ -z "$AF_GENERATOR" ] || [ ! -x "$AF_GENERATOR" ]; then
      echo "FEHLER: Korpus-Daten vorhanden ($n_csv result.csv), aber AF_GENERATOR fehlt/ist nicht ausfuehrbar ('$AF_GENERATOR')." >&2
      echo "       Das ist KEIN honest-empty-Fall, sondern eine kaputte Job-Konfiguration -> Abbruch (kein stilles Gruen)." >&2
      exit 1
    fi
    # WIDE-Aggregat = Header EINMAL + alle Datenzeilen. DIE LOGIK STEHT NICHT MEHR HIER,
    # sondern in ci/wide_aggregat.sh -- gemeinsam mit den beiden measure-Jobs der
    # .gitlab-ci.yml, die vorher jeder eine eigene Kopie trugen (Begruendung und die
    # drei geheilten Defekte F2/F3/F4 ausfuehrlich im Kopf jener Datei).
    # SELBSTCHECK Arbeitsteilung (P4c, 2026-08-09):
    #   ZUGESICHERT: HIER bleibt, was NUR den Anhang-Kanal angeht -- welche Dateien
    #     ueberhaupt gefunden werden (af_finde_result_csv/AF_RESULT_NAMEN), das 'sort',
    #     und das URTEIL ueber die Zahl (honest-empty). DORT liegt, was alle drei
    #     Aufrufer teilen: die Konkatenation und die Zaehlung.
    #   WARUM DAS 'sort' HIER BLEIBT: sonst haetten Kern und CI zwei verschiedene
    #     'sort'-Aufrufe, und die Frage "welche Datei stellt den Header" haette zwei
    #     Antworten. Der Aufrufer legt die Reihenfolge fest, der Aggregator folgt ihr.
    #   NICHT zugesichert: dass der Aggregator existiert. Deshalb der 'test -x'-Vorspann
    #     -- sein Verschwinden als DATEI ist fail-loud, nicht honest-empty.
    WIDE="$AF_TMP/wide_aggregate.csv"
    AF_RC_LISTE="$AF_TMP/wide_rc_liste.txt"
    AF_KENNZAHLEN="$AF_TMP/wide_kennzahlen.env"
    af_finde_result_csv "$RUN_DIR" | sort > "$AF_RC_LISTE"
    if [ ! -x "$AF_WIDE_AGGREGAT" ]; then
      echo "FEHLER: WIDE-Aggregator '$AF_WIDE_AGGREGAT' fehlt oder ist nicht ausfuehrbar." >&2
      echo "       Ohne ihn gaebe es kein Aggregat -- und ein leeres Aggregat waere von" >&2
      echo "       einem echten honest-empty nicht zu unterscheiden. Abbruch." >&2
      exit 1
    fi
    # K11: kein 'rc=$?' hinter einer Pipe. Der Status wird direkt am Aufruf genommen.
    _agg_rc=0
    sh "$AF_WIDE_AGGREGAT" "$AF_RC_LISTE" "$WIDE" "$AF_KENNZAHLEN" || _agg_rc=$?
    if [ "$_agg_rc" -ne 0 ]; then
      echo "FEHLER: WIDE-Aggregation fehlgeschlagen (rc=$_agg_rc) -> Abbruch, kein stilles Gruen." >&2
      exit 1
    fi
    # shellcheck source=/dev/null -- Kennzahlen-Datei, vom Aggregator eben geschrieben.
    . "$AF_KENNZAHLEN"
    _hdr_txt="$WIDE_HEADER"
    # Der Nachsatz steht in einer Variablen, damit die Zeile unter 120 Spalten
    # bleibt (Diff-Hygiene-Wache). Die AUSGABE ist Zeichen fuer Zeichen dieselbe
    # wie vorher -- die Probe prueft sie literal (A1/A3/A6/A8/A9/A10).
    _zaehlweise="Zaehlweise awk NR"
    echo "   [1b] WIDE-Aggregat: $WIDE_ZEILEN Zeilen (header=$_hdr_txt, davon Datenzeilen=$WIDE_DATEN), $_zaehlweise"
    # P29 (10.08.2026) DER NENNER GEHOERT IN DIE AUSGABE (V-1). Die Zeile oben nennt nur
    # das ERGEBNIS; ohne die Grundgesamtheit ist "0 Datenzeilen" nicht von "0 Quellen
    # gelistet" zu unterscheiden. Sie steht ZUSAETZLICH, nicht anstelle: die Probe
    # (A1/A3/A6/A8/A9/A10) fordert die obere Zeile literal.
    _nenner="$WIDE_QUELLEN Quelle(n) gelistet -- $WIDE_MIT_DATEN mit Daten,"
    echo "   [1b] WIDE-Nenner: $_nenner $WIDE_OHNE_DATEN ohne Daten, $WIDE_FEHLEND nicht lesbar"
    if [ "$WIDE_DATEN" -le 0 ]; then
      echo "   [1b] WIDE-Aggregat hat keine Datenzeile -> honest-empty"
    else
      GEN_OUT="$AF_TMP/appendix"
      mkdir -p "$GEN_OUT"
      # honest-empty-tolerant: Teil-Output (n/a-Spalten) ist KEIN Fehler (Spiegel der measure-Jobs).
      "$AF_GENERATOR" "$WIDE" "$GEN_OUT" "--langs=$AF_LANGS" \
        || echo "   [1b] appendix-generator: honest-empty/Teil-Output (n/a-Spalten) -- kein Fehler"
      n=0
      for lang in $LANGS; do
        [ -d "$GEN_OUT/$lang/tabellen" ] || continue
        c=$(find "$GEN_OUT/$lang/tabellen" -maxdepth 1 -type f -name '*.tex' | awk 'END{print NR+0}')
        n=$((n + c))
      done
      echo "   [1b] regeneriert: $n .tex"
      if [ "$n" -gt 0 ]; then
        SRC_ROOT="$GEN_OUT"; SRC_KIND="korpus"; SRC_NOTE="$(basename "$RUN_DIR")"
      fi
    fi
  else
    echo "   [1b] kein Laufordner mit Mess-CSV (Selektor: $AF_RESULT_NAMEN) unter $AF_CORPUS_ROOT/"
    echo "   [1b] das ist eine Null MIT Nenner: $n_laufordner Laufordner angesehen, $n_mit_material mit Material"
  fi
fi

# (1c) honest-empty
if [ -z "$SRC_ROOT" ]; then
  echo "=== anhang:forward NO-OP: keine Anhang-Quelle (weder Artefakt noch Korpus) ==="
  echo "    Die Thesis bleibt gruen -- A_measurements.tex bindet die Tabellen per"
  echo "    \\InputIfFileExists ein (Weg A). Kein Commit, kein Fehler."
  exit 0
fi
echo "   QUELLE: kind=$SRC_KIND ref=$SRC_NOTE root=$SRC_ROOT"

# ---- (2) Whitelist-Kopie: NUR anhang/<lang>/tabellen/<name>.tex ----------------------
echo "-- (2) Whitelist-Kopie nach anhang/<lang>/tabellen/ (nie loeschen, nie ausserhalb) --"
copied=0
# Buchfuehrung ueber GENAU die Pfade, die dieser Lauf angefasst hat. Ein etwaiger Rollback
# (PDF-Gate rot) darf ausschliesslich diese wieder wegnehmen -- kein `git clean` ueber ein
# ganzes Verzeichnis, damit fremde unversionierte Dateien im Ziel niemals mitgerissen werden.
COPIED_LIST="$AF_TMP/kopierte_pfade.txt"; : > "$COPIED_LIST"
for lang in $LANGS; do
  src="$SRC_ROOT/$lang/tabellen"
  if [ ! -d "$src" ]; then echo "   [$lang] Quelle fehlt -> 0 kopiert"; continue; fi
  dst="$AF_DEST_REPO/anhang/$lang/tabellen"
  mkdir -p "$dst"
  n=0
  while IFS= read -r f; do
    base="$(basename "$f")"
    # Namens-Wache: nur schlichte .tex-Dateinamen (kein Pfad, kein '..', kein Sonderzeichen).
    case "$base" in
      *[!A-Za-z0-9._-]* | .* | *..* ) echo "   [$lang] UEBERSPRUNGEN (Namens-Wache): $base"; continue ;;
    esac
    cp -- "$f" "$dst/$base"
    printf '%s\n' "anhang/$lang/tabellen/$base" >> "$COPIED_LIST"
    n=$((n + 1))
  done < <(find "$src" -maxdepth 1 -type f -name '*.tex' | sort)
  echo "   [$lang] kopiert: $n .tex -> anhang/$lang/tabellen/"
  copied=$((copied + n))
done
echo "   kopiert gesamt: $copied .tex"
if [ "$copied" -eq 0 ]; then
  echo "=== anhang:forward NO-OP: Quelle vorhanden, aber 0 uebernommene .tex ==="
  exit 0
fi

# ---- (3) Idempotenz: Commit NUR bei Byte-Delta ---------------------------------------
# FUENFTE TRANSPORT-FALLE, GEHEILT AM 10.08.2026 (Posten ##20) -- die letzte still:
#   (F5) DIE UEBERNAHME WURDE NIE NACHGEZAEHLT. Gestagt wurde das VERZEICHNIS
#        ('git add -- "anhang/$lang/tabellen" 2>/dev/null || true'); ob die eben
#        kopierten .tex dabei wirklich in den Index kamen, hat niemand gefragt.
#        Nahm git sie nicht (.gitignore im Ziel-Repo, index.lock, fehlendes
#        Schreibrecht), blieb 'changed' auf 0 -- und der Kanal sagte "IDEMPOTENT:
#        0 Aenderungen", rc=0. DASSELBE WORT fuer "nichts hat sich geaendert" und
#        "nichts ist angekommen". Am Objekt gemessen (10.08.2026, gewuerfelter
#        Koeder): Ziel-Repo mit 'anhang/**/tabellen/*.tex' in der .gitignore ->
#        "kopiert gesamt: 1 .tex" + "gestagte Aenderungen: 0" -> IDEMPOTENT, rc=0,
#        Commits 1->1, Koeder NICHT im Blob. GEGENPROBE ohne die Ignorier-Regel,
#        sonst identische Fixture: Commit, Koeder im committeten Blob. Der Messwert
#        war weg und der Job gruen -- fail-OPEN, die teuerste Richtung.
#
# WARUM NICHT EINFACH DAS '|| true' FAELLT (so verlangte es Posten ##20 woertlich:
#   "`|| true` beim git add faellt") -- am Objekt gemessen und WIDERLEGT: der CI-Job
#   setzt AF_LANGS="de,en", eine Quelle darf aber legitim nur 'de' tragen. Dann gibt
#   es 'anhang/en/tabellen' im Ziel gar nicht, 'git add' bricht mit "pathspec
#   'anhang/en/tabellen' did not match any files" ab und 'set -e' toetet den ganzen
#   Kanal -- gemessen: rc=128, kein Commit, obwohl die de-Haelfte fertig kopiert
#   dalag. Das '|| true' war also nicht der Defekt, sondern die Kruecke fuer ein
#   falsches Pathspec. Geheilt wird das PATHSPEC: gestagt wird genau das, was DIESER
#   Lauf geschrieben hat -- die Buchfuehrungs-Liste $COPIED_LIST, die es fuer den
#   Rollback ohnehin schon gibt. Damit kann 'git add' an einer nicht bedienten
#   Sprache nicht mehr scheitern, und ein Fehlschlag ist wieder ein echter.
#
# SELBSTCHECK (##20, 2026-08-10):
#   ZUGESICHERT: die Null bekommt ihren Nenner. Es wird IMMER gedruckt
#     'Uebernahme-Nenner: kopiert=N im_index=M nicht_uebernommen=K git_add_fehler=F'.
#     "0 Aenderungen" heisst ab jetzt belegbar "alle N liegen im Index und sind
#     byte-gleich zum Bestand" -- und nicht mehr auch "keine ist angekommen".
#   ZUGESICHERT: K>0 oder F>0 ist fail-loud (exit 1) und nennt die DATEINAMEN.
#   NICHT zugesichert: der Push-/Merge-Retry-Pfad danach. Er bleibt ungedeckt
#     (AF_NO_PUSH=true in allen Faellen), s. Testkritik in der Probe.
echo "-- (3) Idempotenz-Pruefung im Ziel-Repo --"
af_add_fehler=0
while IFS= read -r rel; do
  [ -n "$rel" ] || continue
  git -C "$AF_DEST_REPO" add -- "$rel" || af_add_fehler=$((af_add_fehler + 1))
done < "$COPIED_LIST"
# DAS ORAKEL IST DER INDEX, NICHT DER RUECKGABEWERT: gefragt wird nicht, ob
# 'git add' zufrieden aussah, sondern ob die Datei danach WIRKLICH drinsteht.
NICHT_UEBERNOMMEN="$AF_TMP/nicht_uebernommen.txt"; : > "$NICHT_UEBERNOMMEN"
nicht_uebernommen=0
while IFS= read -r rel; do
  [ -n "$rel" ] || continue
  if ! git -C "$AF_DEST_REPO" ls-files --error-unmatch -- "$rel" >/dev/null 2>&1; then
    nicht_uebernommen=$((nicht_uebernommen + 1))
    printf '%s\n' "$rel" >> "$NICHT_UEBERNOMMEN"
  fi
done < "$COPIED_LIST"
im_index=$((copied - nicht_uebernommen))
_uebernahme="kopiert=$copied im_index=$im_index nicht_uebernommen=$nicht_uebernommen"
echo "   Uebernahme-Nenner: $_uebernahme git_add_fehler=$af_add_fehler"
changed=$(git -C "$AF_DEST_REPO" diff --cached --name-only | awk 'END{print NR+0}')
echo "   gestagte Aenderungen: $changed Datei(en)"
if [ "$changed" -gt 0 ]; then git -C "$AF_DEST_REPO" diff --cached --name-only | sed 's/^/     /'; fi
# EINE Entscheidung ueber BEIDE Zahlen: sie sind zwei Symptome desselben Sachverhalts
# -- die kopierte .tex hat den Index nicht erreicht. Zwei getrennte Abbrueche haetten
# bedeutet, dass der erste den zweiten nie zum Zug kommen laesst; der zweite bliebe
# dann ungedeckt, und ein Mutant auf ihn bliebe gruen.
if [ "$nicht_uebernommen" -gt 0 ] || [ "$af_add_fehler" -gt 0 ]; then
  echo "FEHLER: $nicht_uebernommen von $copied kopierten .tex sind NICHT im Index des" >&2
  echo "        Ziel-Repos ('git add' meldete $af_add_fehler Fehlschlag/Fehlschlaege)." >&2
  if [ -s "$NICHT_UEBERNOMMEN" ]; then sed 's/^/          /' "$NICHT_UEBERNOMMEN" >&2; fi
  echo "        Bekannte Ursachen: .gitignore im Ziel-Repo, index.lock eines" >&2
  echo "        Parallel-Laufs, fehlendes Schreibrecht auf dem Klon." >&2
  echo "        Das ist KEIN Idempotenz-Fall: der Messwert waere still verloren und" >&2
  echo "        der Job trotzdem gruen. Abbruch (fail-loud)." >&2
  exit 1
fi
if git -C "$AF_DEST_REPO" diff --cached --quiet; then
  echo "=== anhang:forward IDEMPOTENT: 0 Aenderungen -> kein Commit ==="
  echo "    belegt: alle $copied kopierten .tex liegen im Index und sind byte-gleich."
  exit 0
fi
if [ "$AF_DRY_RUN" = "true" ]; then
  echo "=== anhang:forward DRY-RUN: $changed Aenderung(en) gestaged, KEIN Commit, KEIN Push ==="
  exit 0
fi

# ---- (3b) PDF-GATE: baut die Thesis mit dem NEUEN Anhang noch? ------------------------
# ALLES-ODER-NICHTS: schlaegt der Bau fehl, wird der Arbeitsbaum zurueckgesetzt und der
# Kanal bricht LAUT ab -- lieber gar kein Vorwaerts-Schritt als eine kaputte Thesis-PDF.
echo "-- (3b) PDF-Gate (AF_PDF_GATE=$AF_PDF_GATE) --"
run_pdf_gate() {
  local main tex_tool
  main="$(cd "$AF_DEST_REPO" && grep -lE '^[^%]*\\documentclass' -- *.tex 2>/dev/null | head -1)"
  if command -v latexmk >/dev/null 2>&1; then tex_tool=latexmk
  elif command -v pdflatex >/dev/null 2>&1; then tex_tool=pdflatex
  else tex_tool=""; fi
  if [ -z "$main" ] || [ -z "$tex_tool" ]; then
    if [ "$AF_PDF_GATE" = "on" ]; then
      echo "FEHLER: AF_PDF_GATE=on, aber Haupt-.tex='${main:-<keine>}' / TeX-Werkzeug='${tex_tool:-<keins>}'" >&2
      return 1
    fi
    echo "   UEBERSPRUNGEN: Haupt-.tex='${main:-<keine>}' TeX-Werkzeug='${tex_tool:-<keins>}'"
    echo "   (kein Haken ohne Ausgabe: hier wurde NICHT geprueft, ob die PDF noch baut)"
    return 0
  fi
  echo "   baue $main mit $tex_tool ..."
  local log="$AF_TMP/pdf_gate.log" rc=0
  if [ "$tex_tool" = "latexmk" ]; then
    ( cd "$AF_DEST_REPO" && latexmk -pdf -interaction=nonstopmode -halt-on-error "$main" ) > "$log" 2>&1 || rc=$?
  else
    ( cd "$AF_DEST_REPO" && pdflatex -interaction=nonstopmode -halt-on-error "$main" ) > "$log" 2>&1 || rc=$?
  fi
  if [ "$rc" -ne 0 ]; then
    echo "FEHLER: PDF-Gate ROT (rc=$rc) -- der neue Anhang bricht den Thesis-Bau." >&2
    echo "-------- LaTeX-Fehlerzeilen --------" >&2
    grep -nE '^!|^l\.[0-9]+|Fatal error' "$log" | head -12 >&2
    echo "------------------------------------" >&2
    return 1
  fi
  echo "   PDF-Gate GRUEN: $main gebaut"
  return 0
}
# Der PDF-Bau fasst getrackte Dateien AUSSERHALB von anhang/ an (z.B. die eingecheckte
# diplomarbeit.pdf). Die duerfen den Kanal-Commit nicht verunreinigen -> nach dem Gate
# zuruecksetzen. Der Commit selbst stagt ohnehin NUR anhang/<lang>/tabellen.
pdf_gate_aufraeumen() {
  git -C "$AF_DEST_REPO" checkout -q -- ':(exclude)anhang' . 2>/dev/null || true
}
if [ "$AF_PDF_GATE" != "off" ]; then
  if ! run_pdf_gate; then
    echo "   Rollback: gestagte Anhang-Aenderungen werden verworfen (nichts wird gelandet)" >&2
    git -C "$AF_DEST_REPO" reset -q HEAD -- anhang || true
    git -C "$AF_DEST_REPO" checkout -q -- anhang || true
    # NUR die in DIESEM Lauf neu angelegten (= unversionierten) Pfade entfernen. Getrackte
    # Dateien hat das checkout oben schon zurueckgeholt; fremde unversionierte Dateien im
    # selben Verzeichnis bleiben unangetastet (deshalb kein `git clean` ueber das Verzeichnis).
    zurueck=0
    while IFS= read -r rel; do
      [ -n "$rel" ] || continue
      if ! git -C "$AF_DEST_REPO" ls-files --error-unmatch -- "$rel" >/dev/null 2>&1; then
        rm -f -- "$AF_DEST_REPO/$rel"; zurueck=$((zurueck + 1))
      fi
    done < "$COPIED_LIST"
    echo "   Rollback: $zurueck neu angelegte Datei(en) wieder entfernt" >&2
    pdf_gate_aufraeumen
    echo "=== anhang:forward ABGEBROCHEN: PDF-Gate rot -> KEIN Commit, KEIN Push ===" >&2
    exit 1
  fi
  pdf_gate_aufraeumen
else
  echo "   ABGESCHALTET (AF_PDF_GATE=off) -- es wurde NICHT geprueft, ob die PDF noch baut"
fi

# ---- (4) Commit mit Provenance -------------------------------------------------------
echo "-- (4) Commit --"
git -C "$AF_DEST_REPO" -c user.name="anhang-forward-bot" -c user.email="anhang-forward-bot@ci.local" \
  commit -q -m "anhang(E-18): Mess-Anhang aus $SRC_KIND '$SRC_NOTE' vorwaerts gesetzt ($changed Datei(en))

Automatisch erzeugt vom super-CI-Job anhang:forward (E-18 Vorwaerts-Kanal).
quelle_kind=$SRC_KIND
quelle_ref=$SRC_NOTE
super_commit_sha=$AF_PROV_SUPER_SHA
super_commit_ref=$AF_PROV_SUPER_REF
ci_pipeline_id=$AF_PROV_PIPELINE_ID
ci_pipeline_url=$AF_PROV_PIPELINE_URL
generiert_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "   commit: $(git -C "$AF_DEST_REPO" log --oneline -1)"

if [ "$AF_NO_PUSH" = "true" ]; then
  echo "=== anhang:forward OK (lokal committet; AF_NO_PUSH=true -> kein Push) ==="
  exit 0
fi

# ---- (5) Push mit MERGE-Retry (KEIN rebase, KEIN --force) ----------------------------
# BEWUSST OHNE `-o ci.skip`: die 289-Pipeline (lint + thesis-pdf de/en) IST der
# Post-measure-Rebuild. 289 triggert 288 nicht zurueck -> kein Loop.
echo "-- (5) Push nach $AF_BRANCH (ohne ci.skip: die 289-Pipeline ist der Rebuild) --"
for attempt in $(seq 1 "$AF_PUSH_RETRIES"); do
  if git -C "$AF_DEST_REPO" push origin "HEAD:$AF_BRANCH"; then
    echo "=== anhang:forward OK: gepusht (Versuch $attempt) nach $AF_BRANCH ==="
    exit 0
  fi
  echo "   push abgelehnt (non-ff-Race) -> fetch + MERGE (kein rebase) + retry ($attempt)" >&2
  git -C "$AF_DEST_REPO" fetch origin "$AF_BRANCH"
  if ! git -C "$AF_DEST_REPO" -c user.name="anhang-forward-bot" -c user.email="anhang-forward-bot@ci.local" \
        merge --no-edit -m "Merge origin/$AF_BRANCH in anhang-forward $SRC_NOTE" "origin/$AF_BRANCH"; then
    git -C "$AF_DEST_REPO" merge --abort || true
    echo "FEHLER: unerwarteter Merge-Konflikt (Versuch $attempt) -> echter Bug, Abbruch (kein --force)" >&2
    exit 1
  fi
  sleep $(( (RANDOM % 5) + 2 ))
done
echo "FEHLER: Push nach $AF_PUSH_RETRIES Versuchen fehlgeschlagen" >&2
exit 1
