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
#       *.result.csv (replace-Semantik: neuester Lauf gewinnt) -> WIDE-Konkatenation
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
#   * ohne Byte-Delta entsteht KEIN Commit  (Loop-/Rausch-Wache)
#   * ohne Quelle entsteht KEIN Commit und KEIN Fehler (honest-empty)
#   * landet AUF EINEM TeX-FAEHIGEN RUNNER nie einen Stand, mit dem die Thesis-PDF nicht
#     mehr baut (PDF-GATE; deklarierter Geltungsbereich + Grenzen s.u. -- ohne
#     TeX-Toolchain prueft AF_PDF_GATE=auto NICHTS und sagt das literal)
#   * kein Haken ohne Ausgabe: jede Stufe druckt ihren literalen Zaehler
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
# E-18-SNAP -- COMPILE-SCHNAPPSCHUSS (OWNER-KERN, Ledger frueh-6, VERBATIM):
#   "in Zukunft soll die Diplomarbeit einerseits fertig auf den branch gepusht werden, aber
#    andererseits wird sie zusaetzlich in einen Ordner an der Wurzel der Messwerte kopiert, samt
#    latex compile-export (Benennung nach Datum und Uhrzeit). so laesst sich ein compile
#    nachvollziehen."
#   UMSETZUNG: das PDF-Gate baut die Thesis-PDF ohnehin schon (s.o.) -- E-18-SNAP ERNTET dieses
#   Bau-Produkt, statt ein zweites Mal zu kompilieren. Es landet zusaetzlich unter
#   <AF_SNAPSHOT_ROOT>/<JJJJMMTT-HHMMSS>/ :
#     <haupt>.pdf         die kompilierte Diplomarbeit (Kopie, sha256-verifiziert)
#     compile-export.txt  der vollstaendige latexmk/pdflatex-Lauf (der "latex compile-export")
#     QUELLSTAND.txt      289-SHA + 288-SHA + Kanal-Lauf-ID -> der Compile ist nachvollziehbar
#
#   WARUM compile-export.txt UND NICHT compile.log (load-bearing, nicht kosmetisch): die super-
#   .gitignore ignoriert global `*.log` (Zeile 49) und hat -- anders als fuer `*.csv` (Zeile 43
#   `!measurement/**/*.csv`) -- KEINE Gegenausnahme fuer measurement/. Ein `compile.log` wuerde vom
#   `git add` des Writebacks STILL weggeworfen; der Schnappschuss kaeme ohne sein Kernstueck an.
#   Die .txt-Endung haelt den Schnappschuss ohne .gitignore-Aenderung trackbar; Alternative waere
#   ein `!measurement/**/*.log` analog zur CSV-Zeile (Entscheid Lead, s. Backup-ANWENDUNG.md).
#
#   ADDITIV, NIE UEBERSCHREIBEN (Messdaten-Doktrin): existiert der Zeitstempel-Ordner bereits, wird
#   ein Kollisions-Suffix -2, -3, ... angehaengt. Ein bestehender Ordner wird NIE angefasst, nie
#   ueberschrieben, nie geloescht -- auch nicht teilweise. Die Suffix-Wahl prueft dabei DREI Staende,
#   weil zwei Laeufe in derselben Sekunde auf VERSCHIEDENEN Runnern liegen koennen (Codex HOCH-2):
#     (i)   lokal      -- `[ -e ]` gegen den Arbeitsbaum
#     (ii)  REMOTE     -- `git cat-file -e <fetch>:<pfad>` gegen den Ziel-Branch des 288-Repos; ein
#                         bereits GELANDETER Ordner desselben Zeitstempels ist damit sichtbar, bevor
#                         der Writeback in einen add/add-Merge-Konflikt laeuft (= Beleg-Verlust)
#     (iii) EXKLUSIV   -- `mkdir` OHNE -p ist der atomare Lock: gewinnt nur EIN Lauf; wer verliert,
#                         geht in derselben Schleife auf das naechste Suffix (Retry statt Abbruch)
#   Ist der REMOTE-Stand nicht abfragbar (kein git-Arbeitsbaum, kein Remote, fetch rot), sagt der
#   Kanal das LITERAL und faellt auf (i)+(iii) zurueck -- kein stiller Teil-Schutz.
#
#   ENTKOPPELT VOM ANHANG-BYTE-DELTA (Codex HOCH-1, load-bearing): frueher entschied ALLEIN das
#   Byte-Delta im Anhang, ob ueberhaupt ein Compile und damit ein Schnappschuss entsteht. Ein Lauf,
#   der 289 erfolgreich pusht und danach stirbt (Runner-Crash, 288-Writeback rot), verlor seinen
#   Compile-Beleg damit DAUERHAFT: der Retry findet einen idempotenten Anhang (0 Delta) und stieg vor
#   dem PDF-Gate aus. Ein Marker im Workspace hilft nicht -- der Workspace stirbt mit dem Job.
#   WAHRE QUELLE ist darum der VERGLEICH 289 gegen 288: existiert unter <AF_SNAPSHOT_ROOT> (lokal
#   ODER im Remote-Stand) ein QUELLSTAND.txt mit `thesis_commit_sha=<289-HEAD>`? Wenn nein, holt der
#   Kanal den Beleg NACH (Modus "nachholen": Gate bauen, ernten, ablegen) -- OHNE 289-Commit und
#   OHNE Push, denn es gibt kein Delta. Der QUELLSTAND nennt diesen Modus, und die Commit-Botschaft
#   behauptet in keinem Modus etwas anderes als das, was passiert ist.
#
#   RE-FIXIERUNG NACH NON-FF-PUSH (Codex HOCH-3): der Push-Retry (5) kann einen MERGE-Commit
#   erzeugen. Dann ist der tatsaechlich gelandete HEAD ein anderer als der, aus dessen Baum die PDF
#   gebaut wurde -- ein Schnappschuss mit der alten SHA waere eine DIVERGENTE Dokumentation ("diese
#   PDF gehoert zu Commit X", obwohl X nie so auf dem Branch stand). Phase 2 laeuft darum NACH dem
#   Push und vergleicht den gepushten BAUM mit dem gebauten: gleich => das Bau-Produkt gilt
#   unveraendert; ungleich => RE-ERNTE (Gate erneut, aus dem gemergten Baum). Scheitert die
#   Re-Ernte, wird KEIN Schnappschuss abgelegt und der Kanal bricht LAUT ab -- lieber kein Beleg als
#   ein falscher.
#
#   DEKLARIERTE GRENZE (bewusst, kein Versehen): OHNE Compile gibt es KEINEN Schnappschuss. Wird
#   AF_PDF_GATE uebersprungen (auto ohne TeX-Toolchain) oder ist es off, entsteht gar kein
#   Bau-Produkt -- dann sagt die Funktion das LITERAL, statt einen leeren Ordner anzulegen. Die
#   AF_PDF_GATE-Semantik bleibt dadurch UNVERAENDERT: E-18-SNAP erzwingt kein Gate und verschiebt
#   keine Gate-Grenze, es erntet ausschliesslich, was das Gate ohnehin baut.
#
#   WER COMMITTET: der Kern LEGT den Schnappschuss nur an. In das super-Repo (288) bringt ihn der
#   BESTEHENDE 288-Writeback des Job-Blocks (heute der Gitlink-Bump) -- der muss measurement/
#   mitstagen. Solange diese Job-Block-Aenderung nicht angewandt ist, entsteht der Ordner im
#   CI-Workspace und wird am Pipeline-Ende verworfen (kein Datenverlust, aber auch kein Nutzen).
#
# ENV-KONTRAKT
#   AF_DEST_REPO      (Pflicht) Arbeitsklon des Thesis-Repos (Projekt 289)
#   AF_BRANCH         Ziel-Branch im Ziel-Repo                      (Default: development)
#   AF_LANGS          Komma-Liste der Sprachen                      (Default: de,en)
#   AF_WORK_ROOT      Basis fuer Artefakt-/Korpus-Pfade             (Default: .)
#   AF_ARTIFACT_ROOTS Leerzeichen-Liste der Artefakt-Wurzeln
#                     (Default: Code/measure_out/appendix Code/measure_out_smoke/appendix)
#   AF_CORPUS_ROOT    Rueckschreibe-Korpus                          (Default: measurement)
#   AF_GENERATOR      Pfad zur appendix-generator-Binary            (Default: leer)
#   AF_TMP            Arbeitsverzeichnis                            (Default: mktemp -d)
#   AF_DRY_RUN        true => kopieren+stagen, aber KEIN Commit, KEIN Push
#   AF_NO_PUSH        true => Commit ja, Push nein (Fixture ohne Remote)
#   AF_PDF_GATE       auto (Default) | on | off -- PDF-Bau-Wache vor dem Commit.
#                     auto: laeuft, wenn TeX-Toolchain UND Haupt-.tex vorhanden sind;
#                     on:   fehlende Toolchain ist ein FEHLER; off: bewusst abgeschaltet.
#                     Geltungsbereich s.o. (a)-(c): NUR das ERSTE Top-Level-Haupt-.tex.
#   AF_PUSH_RETRIES   Push-/Merge-Versuche                          (Default: 5)
#   AF_PROV_*         Provenance fuer die Commit-Botschaft (PIPELINE_ID/URL/SUPER_SHA/REF)
#   AF_COMPILE_SNAPSHOT true (Default) | false -- E-18-SNAP-Compile-Schnappschuss an/aus
#   AF_SNAPSHOT_ROOT  Wurzel der Schnappschuss-Ordner ("Wurzel der Messwerte")
#                     (Default: <AF_WORK_ROOT>/<AF_CORPUS_ROOT>/thesis_compiles)
#                     KONTRAKT: der Pfad MUSS im Arbeitsbaum des 288-Repos liegen, sonst kann ihn der
#                     288-Writeback nicht committen. Der Kanal sagt es literal, wenn das nicht gilt.
#                     Der Job-Block reicht denselben Pfad an beide Seiten (EINE Quelle, kein Literal
#                     zweimal) -- s. gitlab-ci-delta.patch, Variable SNAP_DIR.
#   AF_SNAP_REMOTE    Remote fuer die REMOTE-Wache der Suffix-/Nachhol-Entscheidung (Default: origin)
#   AF_SNAP_REMOTE_BRANCH  Branch dort (Default: $AF_PROV_SUPER_REF; "NA"/leer => REMOTE-Wache aus,
#                     literal gemeldet, Rueckfall auf lokale Pruefung + mkdir-Lock)
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
AF_COMPILE_SNAPSHOT="${AF_COMPILE_SNAPSHOT:-true}"
# "Wurzel der Messwerte" = der Rueckschreibe-Korpus; thesis_compiles/ ist dort ein GESCHWISTER der
# measurement/<RUN_TS>/-Laufordner. Das ist mit der Korpus-Kaskade (1b) vertraeglich, WEIL deren
# Laufordner-Auswahl einen Ordner nur nimmt, wenn er *.result.csv enthaelt -- der Schnappschuss legt
# ausschliesslich .pdf/.txt ab und kann daher nie als Mess-Laufordner missgedeutet werden.
# (Wer hier je eine *.result.csv ablegt, bricht genau diese Zusage.)
AF_SNAPSHOT_ROOT="${AF_SNAPSHOT_ROOT:-$AF_WORK_ROOT/$AF_CORPUS_ROOT/thesis_compiles}"
AF_SNAP_REMOTE="${AF_SNAP_REMOTE:-origin}"
AF_SNAP_REMOTE_BRANCH="${AF_SNAP_REMOTE_BRANCH:-$AF_PROV_SUPER_REF}"
# Bau-Produkt-Buchfuehrung des PDF-Gates (von run_pdf_gate gesetzt; leer = es wurde NICHT gebaut).
AF_GATE_MAIN=""
AF_GATE_TOOL=""
AF_GATE_PDF=""
# Betriebsmodus: "vorwaerts" = es gibt ein Anhang-Byte-Delta (Commit+Push);
#                "nachholen" = 0 Delta, aber der Compile-Beleg zum 289-HEAD fehlt (kein Commit).
AF_MODE="vorwaerts"
# REMOTE-Wache (Kollisions- + Nachhol-Entscheidung); von af_snap_remote_init einmalig gesetzt.
AF_SNAP_GIT_TOP=""
AF_SNAP_REL=""
AF_SNAP_REMOTE_REF=""
AF_SNAP_REMOTE_INIT=0

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
# EINE Quelle fuer den Gate-Log-Pfad: run_pdf_gate schreibt ihn, E-18-SNAP erntet ihn als
# "compile-export". Zwei Literale wuerden hier stumm auseinanderlaufen.
AF_GATE_LOG="$AF_TMP/pdf_gate.log"
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
    c=$(find "$cand/$lang/tabellen" -maxdepth 1 -type f -name '*.tex' | wc -l)
    n=$((n + c))
  done
  echo "   [1a] $root: $n .tex"
  if [ "$n" -gt 0 ] && [ -z "$SRC_ROOT" ]; then
    SRC_ROOT="$cand"; SRC_KIND="artefakt"; SRC_NOTE="$root"
  fi
done

# (1b) sonst Korpus-Regeneration (replace-Semantik: NEUESTER Laufordner gewinnt)
if [ -z "$SRC_ROOT" ]; then
  CORPUS="$AF_WORK_ROOT/$AF_CORPUS_ROOT"
  RUN_DIR=""
  if [ -d "$CORPUS" ]; then
    while IFS= read -r d; do
      [ -n "$d" ] || continue
      if [ -n "$(find "$d" -type f -name '*.result.csv' -print -quit)" ]; then RUN_DIR="$d"; break; fi
    done < <(find "$CORPUS" -mindepth 1 -maxdepth 1 -type d | sort -r)
  fi
  if [ -n "$RUN_DIR" ]; then
    n_csv=$(find "$RUN_DIR" -type f -name '*.result.csv' | wc -l)
    echo "   [1b] Korpus-Regeneration aus $(basename "$RUN_DIR") ($n_csv result.csv, replace-Semantik: neuester Lauf gewinnt)"
    if [ -z "$AF_GENERATOR" ] || [ ! -x "$AF_GENERATOR" ]; then
      echo "FEHLER: Korpus-Daten vorhanden ($n_csv result.csv), aber AF_GENERATOR fehlt/ist nicht ausfuehrbar ('$AF_GENERATOR')." >&2
      echo "       Das ist KEIN honest-empty-Fall, sondern eine kaputte Job-Konfiguration -> Abbruch (kein stilles Gruen)." >&2
      exit 1
    fi
    # WIDE-Aggregat = Header EINMAL + alle Datenzeilen (Literal-Spiegel der measure-Jobs).
    WIDE="$AF_TMP/wide_aggregate.csv"; : > "$WIDE"; _hdr=0
    while IFS= read -r rc; do
      [ "$_hdr" = "0" ] && { head -1 "$rc" > "$WIDE"; _hdr=1; }
      tail -n +2 "$rc" >> "$WIDE"
    done < <(find "$RUN_DIR" -type f -name '*.result.csv' | sort)
    echo "   [1b] WIDE-Aggregat: $(wc -l < "$WIDE") Zeilen (inkl. 1 Header)"
    if [ "$(wc -l < "$WIDE")" -le 1 ]; then
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
        c=$(find "$GEN_OUT/$lang/tabellen" -maxdepth 1 -type f -name '*.tex' | wc -l)
        n=$((n + c))
      done
      echo "   [1b] regeneriert: $n .tex"
      if [ "$n" -gt 0 ]; then
        SRC_ROOT="$GEN_OUT"; SRC_KIND="korpus"; SRC_NOTE="$(basename "$RUN_DIR")"
      fi
    fi
  else
    echo "   [1b] kein Korpus-Laufordner mit *.result.csv unter $AF_CORPUS_ROOT/"
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
#
# JE ZEILE: "<zustand_vorher>|<relativer pfad>" -- der Zustand VOR dem cp entscheidet den Rollback
# (Codex MITTEL-3). Ohne ihn loeschte der Rollback auch Dateien, die es vorher schon gab, wenn sie
# nur unversioniert waren -- also FREMDE Dateien, die dieser Lauf lediglich ueberschrieben hat:
#   neu       -- existierte vorher NICHT  -> Rollback loescht sie (sie ist selbst erzeugt)
#   getrackt  -- existierte, ist getrackt -> `git checkout` holt sie zurueck, NIE loeschen
#   fremd     -- existierte, unversioniert-> vor dem cp nach $PREEXIST_DIR gesichert, Rollback
#                stellt den Original-Inhalt WIEDER HER (und loescht sie ebenfalls nie)
COPIED_LIST="$AF_TMP/kopierte_pfade.txt"; : > "$COPIED_LIST"
PREEXIST_DIR="$AF_TMP/vorbestand"; mkdir -p "$PREEXIST_DIR"
preexist_n=0
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
    rel="anhang/$lang/tabellen/$base"
    # Zustand VOR dem cp feststellen -- danach ist er nicht mehr rekonstruierbar.
    sicherung=""
    if [ ! -e "$dst/$base" ]; then
      zustand="neu"
    elif git -C "$AF_DEST_REPO" ls-files --error-unmatch -- "$rel" >/dev/null 2>&1; then
      zustand="getrackt"
    else
      zustand="fremd"
      preexist_n=$((preexist_n + 1))
      sicherung="$preexist_n.bin"
      cp -- "$dst/$base" "$PREEXIST_DIR/$sicherung" \
        || { echo "FEHLER: Vorbestand '$rel' liess sich nicht sichern -> kein Ueberschreiben" >&2; exit 1; }
      echo "   [$lang] Vorbestand gesichert (unversioniert, fremd): $rel -> $sicherung"
    fi
    cp -- "$f" "$dst/$base" || { echo "FEHLER: cp '$f' -> '$dst/$base' fehlgeschlagen" >&2; exit 1; }
    printf '%s|%s|%s\n' "$zustand" "$sicherung" "$rel" >> "$COPIED_LIST"
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

# ---- (2b) E-18-SNAP-Wachen: REMOTE-Stand + "gibt es den Beleg schon?" -----------------
# Beide Wachen brauchen DENSELBEN Remote-Blick, darum EINE Initialisierung, einmal ausgefuehrt.
# Sie laeuft VOR der Idempotenz-Pruefung, weil genau diese Pruefung ihre Antwort braucht (HOCH-1).
af_snap_remote_init() {
  [ "$AF_SNAP_REMOTE_INIT" = "0" ] || return 0
  AF_SNAP_REMOTE_INIT=1
  # Legt NUR das (leere) Wurzelverzeichnis an -- fuer git ist ein leerer Ordner unsichtbar, es
  # entsteht also nichts Commitbares. Es ist der Bezugspunkt fuer rev-parse --show-toplevel.
  mkdir -p "$AF_SNAPSHOT_ROOT" || { echo "FEHLER: Schnappschuss-Wurzel '$AF_SNAPSHOT_ROOT' nicht anlegbar" >&2; return 1; }
  AF_SNAP_GIT_TOP="$(git -C "$AF_SNAPSHOT_ROOT" rev-parse --show-toplevel 2>/dev/null || true)"
  if [ -z "$AF_SNAP_GIT_TOP" ]; then
    echo "   E-18-SNAP-WACHE: '$AF_SNAPSHOT_ROOT' liegt in KEINEM git-Arbeitsbaum -> REMOTE-Stand nicht"
    echo "   abfragbar; Suffix-/Nachhol-Entscheidung nur lokal + mkdir-Lock. (Kontrakt: die Wurzel"
    echo "   gehoert in den 288-Arbeitsbaum, sonst kann der Writeback sie nicht committen.)"
    return 0
  fi
  local top_abs snap_abs
  top_abs="$(cd "$AF_SNAP_GIT_TOP" && pwd -P)"
  snap_abs="$(cd "$AF_SNAPSHOT_ROOT" && pwd -P)"
  case "$snap_abs" in
    "$top_abs"/*) AF_SNAP_REL="${snap_abs#"$top_abs"/}" ;;
    *)            AF_SNAP_REL="" ;;
  esac
  if [ -z "$AF_SNAP_REL" ] || [ -z "$AF_SNAP_REMOTE_BRANCH" ] || [ "$AF_SNAP_REMOTE_BRANCH" = "NA" ]; then
    echo "   E-18-SNAP-WACHE: REMOTE-Stand AUS (rel='$AF_SNAP_REL' branch='$AF_SNAP_REMOTE_BRANCH')"
    echo "   -> Suffix-/Nachhol-Entscheidung nur lokal + mkdir-Lock (kein Haken ohne Ausgabe)"
    return 0
  fi
  if git -C "$AF_SNAP_GIT_TOP" fetch -q "$AF_SNAP_REMOTE" "$AF_SNAP_REMOTE_BRANCH" 2>/dev/null; then
    AF_SNAP_REMOTE_REF="FETCH_HEAD"
    echo "   E-18-SNAP-WACHE: REMOTE-Stand geholt ($AF_SNAP_REMOTE/$AF_SNAP_REMOTE_BRANCH -> $(git -C "$AF_SNAP_GIT_TOP" rev-parse --short FETCH_HEAD)), Pfad '$AF_SNAP_REL'"
  else
    echo "   E-18-SNAP-WACHE: fetch '$AF_SNAP_REMOTE/$AF_SNAP_REMOTE_BRANCH' fehlgeschlagen -> REMOTE-Stand"
    echo "   NICHT geprueft; Rueckfall auf lokale Pruefung + mkdir-Lock (literal, kein stiller Teil-Schutz)"
  fi
  return 0
}

# Existiert fuer diesen 289-Stand bereits ein Compile-Beleg -- lokal ODER im 288-Remote-Stand?
# DAS ist die vom Workspace UNABHAENGIGE Wahrheit (ein Marker im Workspace stirbt mit dem Job).
af_snapshot_beleg_vorhanden() {
  local sha="$1" treffer=""
  if [ -d "$AF_SNAPSHOT_ROOT" ]; then
    treffer="$(grep -rlF "thesis_commit_sha=$sha" "$AF_SNAPSHOT_ROOT" --include='QUELLSTAND.txt' 2>/dev/null | head -1 || true)"
    if [ -n "$treffer" ]; then
      echo "   E-18-SNAP-WACHE: Beleg LOKAL vorhanden -> $treffer"
      return 0
    fi
  fi
  if [ -n "$AF_SNAP_REMOTE_REF" ]; then
    if git -C "$AF_SNAP_GIT_TOP" grep -q -F "thesis_commit_sha=$sha" "$AF_SNAP_REMOTE_REF" -- "$AF_SNAP_REL" 2>/dev/null; then
      echo "   E-18-SNAP-WACHE: Beleg im REMOTE-Stand vorhanden ($AF_SNAP_REMOTE/$AF_SNAP_REMOTE_BRANCH)"
      return 0
    fi
  fi
  return 1
}

# ---- (3) Idempotenz: Commit NUR bei Byte-Delta ---------------------------------------
echo "-- (3) Idempotenz-Pruefung im Ziel-Repo --"
for lang in $LANGS; do
  git -C "$AF_DEST_REPO" add -- "anhang/$lang/tabellen" 2>/dev/null || true
done
changed=$(git -C "$AF_DEST_REPO" diff --cached --name-only | wc -l)
echo "   gestagte Aenderungen: $changed Datei(en)"
if [ "$changed" -gt 0 ]; then git -C "$AF_DEST_REPO" diff --cached --name-only | sed 's/^/     /'; fi
DEST_HEAD="$(git -C "$AF_DEST_REPO" rev-parse HEAD)"
if git -C "$AF_DEST_REPO" diff --cached --quiet; then
  # KEIN Byte-Delta. Frueher endete der Kanal hier -- und ein Lauf, der 289 gepusht hat und danach
  # starb, verlor seinen Compile-Beleg damit fuer immer (Codex HOCH-1). Die Frage ist NICHT "gibt es
  # ein Delta?", sondern "gibt es fuer den 289-HEAD schon einen Beleg?".
  echo "   IDEMPOTENT: 0 Byte-Delta im Anhang (289-HEAD=$DEST_HEAD)"
  if [ "$AF_COMPILE_SNAPSHOT" != "true" ]; then
    echo "=== anhang:forward IDEMPOTENT: 0 Aenderungen, Schnappschuss abgeschaltet -> kein Commit ==="
    exit 0
  fi
  if ! af_snap_remote_init; then
    echo "FEHLER: E-18-SNAP-Wache liess sich nicht initialisieren -> Abbruch (kein stilles Gruen)" >&2
    exit 1
  fi
  if af_snapshot_beleg_vorhanden "$DEST_HEAD"; then
    echo "=== anhang:forward IDEMPOTENT: 0 Aenderungen UND Compile-Beleg zu $DEST_HEAD liegt vor -> nichts zu tun ==="
    exit 0
  fi
  echo "   E-18-SNAP NACHHOLUNG: zu 289-HEAD $DEST_HEAD existiert KEIN Compile-Beleg (weder lokal noch"
  echo "   im REMOTE-Stand). Typischer Hergang: ein Vorlauf hat 289 gepusht und ist vor dem"
  echo "   288-Writeback gestorben. Es wird JETZT nur der Beleg nachgeholt -- KEIN Commit, KEIN Push."
  AF_MODE="nachholen"
fi
if [ "$AF_DRY_RUN" = "true" ]; then
  if [ "$AF_MODE" = "nachholen" ]; then
    echo "=== anhang:forward DRY-RUN: Nachholung waere faellig (0 Delta, Beleg fehlt), aber KEIN Compile, KEIN Schreiben ==="
  else
    echo "=== anhang:forward DRY-RUN: $changed Aenderung(en) gestaged, KEIN Commit, KEIN Push ==="
  fi
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
  local log="$AF_GATE_LOG" rc=0
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
  # Bau-Produkt fuer E-18-SNAP buchen. Die Auswahl des Hauptdokuments wird BEWUSST nicht ein
  # zweites Mal berechnet ("EINE Quelle statt zwei", s. Datei-Kopf) -- der Schnappschuss erntet
  # exakt das Dokument, das dieses Gate gerade gebaut hat.
  AF_GATE_MAIN="$main"
  AF_GATE_TOOL="$tex_tool"
  AF_GATE_PDF="$AF_DEST_REPO/${main%.tex}.pdf"
  return 0
}
# Der PDF-Bau fasst getrackte Dateien AUSSERHALB von anhang/ an (z.B. die eingecheckte
# diplomarbeit.pdf). Die duerfen den Kanal-Commit nicht verunreinigen -> nach dem Gate
# zuruecksetzen. Der Commit selbst stagt ohnehin NUR anhang/<lang>/tabellen.
pdf_gate_aufraeumen() {
  git -C "$AF_DEST_REPO" checkout -q -- ':(exclude)anhang' . 2>/dev/null || true
}

# ---- (3c) E-18-SNAP: Compile-Schnappschuss (OWNER-KERN Ledger frueh-6) ----------------
# WARUM ZWEI PHASEN -- die Reihenfolge ist load-bearing, nicht Stil:
#   Phase 1 (ERNTEN) MUSS VOR pdf_gate_aufraeumen laufen. Das Aufraeumen holt getrackte Dateien
#     ausserhalb von anhang/ per `git checkout` zurueck. Waere die gebaute PDF im Ziel-Repo
#     getrackt, setzte das Aufraeumen sie auf den EINGECHECKTEN Stand zurueck -- der Schnappschuss
#     zeigte dann eine ALTE PDF und wuerde genau die Nachvollziehbarkeit vortaeuschen, die er
#     herstellen soll. Im 289-Stand vom 06.08.2026 ist diplomarbeit.pdf per .gitignore ignoriert
#     (Regel `diplomarbeit*.pdf`), die frische PDF ueberlebt also zufaellig -- auf dieses
#     Zufallsglueck baut der Kanal NICHT.
#   Phase 2 (SCHREIBEN) kann erst NACH dem Commit laufen: vorher existiert die 289-SHA nicht, und
#     ohne sie ist der Compile nicht nachvollziehbar -- sie ist der halbe Zweck des Ordners.
#     Seit Codex HOCH-3 laeuft sie sogar erst NACH dem PUSH: der Push-Retry kann Merge-Commits
#     anhaengen, und dann ist die SHA, die auf dem Branch landet, eine andere als die des lokalen
#     Commits. Geschrieben wird gegen den GELANDETEN HEAD; weicht dessen Baum vom gebauten ab, wird
#     RE-GEERNTET (s. compile_snapshot_refixieren) statt umdeklariert.
#     AUSNAHME AF_NO_PUSH=true: dann gibt es keinen Push, der lokale Commit IST der Endstand.
AF_SNAP_STAGE="$AF_TMP/compile_snapshot"
af_sha256() { sha256sum < "$1" | cut -d' ' -f1; }

compile_snapshot_einsammeln() {
  if [ "$AF_COMPILE_SNAPSHOT" != "true" ]; then
    echo "   E-18-SNAP: ABGESCHALTET (AF_COMPILE_SNAPSHOT=$AF_COMPILE_SNAPSHOT) -- kein Schnappschuss"
    return 0
  fi
  if [ -z "$AF_GATE_PDF" ]; then
    echo "   E-18-SNAP: KEIN Schnappschuss -- das PDF-Gate hat nicht gebaut (AF_PDF_GATE=$AF_PDF_GATE)"
    echo "   (kein Haken ohne Ausgabe: ohne Compile gibt es nichts nachzuvollziehen; ein leerer"
    echo "    Ordner waere eine Luege. Die AF_PDF_GATE-Semantik bleibt davon unberuehrt.)"
    return 0
  fi
  if [ ! -f "$AF_GATE_PDF" ]; then
    echo "FEHLER: PDF-Gate meldete GRUEN, aber sein Bau-Produkt '$AF_GATE_PDF' existiert nicht." >&2
    echo "       Das ist KEIN honest-empty-Fall, sondern ein Widerspruch in der Kanal-Logik (z.B." >&2
    echo "       latexmk-Ausgabeverzeichnis umgestellt) -> Abbruch statt leerem Schnappschuss." >&2
    return 1
  fi
  if [ ! -f "$AF_GATE_LOG" ]; then
    echo "FEHLER: Gate-Log '$AF_GATE_LOG' fehlt -- der 'latex compile-export' ist der Kern des" >&2
    echo "       Schnappschusses (OWNER-KERN). Ohne ihn wird KEIN halber Ordner abgelegt." >&2
    return 1
  fi
  # ERREXIT-LUECKE (Codex MITTEL-1): diese Funktion laeuft unter `if ! ...`, dort ist `set -e`
  # ABGESCHALTET. Jeder schreibende Schritt wird darum EINZELN geprueft -- sonst kaeme ein halber
  # Schnappschuss durch (z.B. Platte voll) und der Kanal meldete trotzdem Erfolg.
  mkdir -p "$AF_SNAP_STAGE" || { echo "FEHLER: E-18-SNAP: Ernte-Ablage '$AF_SNAP_STAGE' nicht anlegbar" >&2; return 1; }
  local pdf_base sha_src sha_dst
  pdf_base="$(basename "$AF_GATE_PDF")"
  cp -- "$AF_GATE_PDF" "$AF_SNAP_STAGE/$pdf_base" \
    || { echo "FEHLER: E-18-SNAP: PDF '$AF_GATE_PDF' liess sich nicht ernten" >&2; return 1; }
  sha_src="$(af_sha256 "$AF_GATE_PDF")" || { echo "FEHLER: E-18-SNAP: sha256 der Quell-PDF fehlgeschlagen" >&2; return 1; }
  sha_dst="$(af_sha256 "$AF_SNAP_STAGE/$pdf_base")" || { echo "FEHLER: E-18-SNAP: sha256 der geernteten PDF fehlgeschlagen" >&2; return 1; }
  if [ "$sha_src" != "$sha_dst" ]; then
    echo "FEHLER: E-18-SNAP sha256-Mismatch beim Ernten der PDF ($sha_src != $sha_dst)" >&2
    return 1
  fi
  # .txt statt .log ist PFLICHT, nicht Geschmack: die super-.gitignore ignoriert global *.log und
  # hat fuer measurement/ keine Gegenausnahme -> ein compile.log wuerde beim Writeback still
  # weggeworfen (s. Datei-Kopf). Der Inhalt ist unveraendert der volle latexmk/pdflatex-Lauf.
  cp -- "$AF_GATE_LOG" "$AF_SNAP_STAGE/compile-export.txt" \
    || { echo "FEHLER: E-18-SNAP: compile-export '$AF_GATE_LOG' liess sich nicht ernten" >&2; return 1; }
  echo "   E-18-SNAP: geerntet $pdf_base ($(wc -c < "$AF_SNAP_STAGE/$pdf_base") Bytes, sha256=$sha_src)"
  echo "   E-18-SNAP: geerntet compile-export.txt ($(wc -l < "$AF_SNAP_STAGE/compile-export.txt") Zeilen $AF_GATE_TOOL-Ausgabe)"
  return 0
}

# Ist der Kandidat-Ordner im REMOTE-Stand des 288-Repos schon belegt? (RC 0 = belegt)
# Zwei Laeufe derselben Sekunde liegen auf VERSCHIEDENEN Runnern -- ein lokales `[ -e ]` sieht den
# fremden Ordner nie. Wer trotzdem denselben Namen waehlt, produziert beim 288-Writeback einen
# add/add-Merge-Konflikt: der Retry bricht ab, der Compile-Beleg ist weg (Codex HOCH-2).
af_snapshot_remote_belegt() {
  local rel_cand="$1"
  [ -n "$AF_SNAP_REMOTE_REF" ] || return 1
  git -C "$AF_SNAP_GIT_TOP" cat-file -e "$AF_SNAP_REMOTE_REF:$rel_cand" 2>/dev/null
}

compile_snapshot_schreiben() {
  local thesis_sha="$1"
  [ "$AF_COMPILE_SNAPSHOT" = "true" ] || return 0
  # Phase 1 hat mit Begruendung nichts geerntet (kein Compile) -> hier ist ehrlich nichts zu tun.
  [ -d "$AF_SNAP_STAGE" ] || return 0
  af_snap_remote_init || return 1
  local ts basis dir k cand rel_cand f b n
  ts="$(date -u +%Y%m%d-%H%M%S)"     # "Benennung nach Datum und Uhrzeit" (OWNER-KERN), UTC, FS-sicher
  basis="$AF_SNAPSHOT_ROOT/$ts"
  mkdir -p "$AF_SNAPSHOT_ROOT" || { echo "FEHLER: E-18-SNAP: '$AF_SNAPSHOT_ROOT' nicht anlegbar" >&2; return 1; }
  # MESSDATEN-DOKTRIN: NUR ADDITIV. Ein bestehender Ordner wird NIE angefasst, nie ueberschrieben,
  # nie geloescht -- bei gleichem Zeitstempel waechst ein Kollisions-Suffix -2, -3, ... an.
  # DREI Wachen je Kandidat, in dieser Reihenfolge (s. Datei-Kopf):
  #   lokal ([ -e ])  ->  REMOTE (cat-file gegen den Ziel-Branch)  ->  mkdir OHNE -p (atomarer Lock).
  # Der Lock ist der einzige, der auch gegen einen Lauf im SELBEN Workspace zwischen Pruefung und
  # Anlage gewinnt; verliert man ihn, geht dieselbe Schleife weiter (Retry statt Abbruch).
  dir=""; k=1
  while [ "$k" -le 99 ]; do
    if [ "$k" -eq 1 ]; then cand="$basis"; else cand="$basis-$k"; fi
    rel_cand="$AF_SNAP_REL/$(basename "$cand")"
    if [ -e "$cand" ]; then
      echo "   E-18-SNAP: '$cand' existiert LOKAL -> naechstes Suffix"
      k=$((k + 1)); continue
    fi
    if af_snapshot_remote_belegt "$rel_cand"; then
      echo "   E-18-SNAP: '$rel_cand' existiert bereits im REMOTE-Stand ($AF_SNAP_REMOTE/$AF_SNAP_REMOTE_BRANCH) -> naechstes Suffix"
      k=$((k + 1)); continue
    fi
    if mkdir "$cand" 2>/dev/null; then dir="$cand"; break; fi
    echo "   E-18-SNAP: '$cand' wurde parallel belegt (mkdir-Lock verloren) -> naechstes Suffix"
    k=$((k + 1))
  done
  if [ -z "$dir" ]; then
    echo "FEHLER: E-18-SNAP: '$basis' und 98 Kollisions-Suffixe sind belegt (lokal/remote/Lock) -> Abbruch" >&2
    echo "       (ueberschreiben ist unter der Messdaten-Doktrin verboten)" >&2
    return 1
  fi
  n=0
  for f in "$AF_SNAP_STAGE"/*; do
    [ -f "$f" ] || continue
    b="$(basename "$f")"
    cp -- "$f" "$dir/$b" || { echo "FEHLER: E-18-SNAP: '$b' liess sich nicht nach '$dir' schreiben" >&2; return 1; }
    if [ "$(af_sha256 "$f")" != "$(af_sha256 "$dir/$b")" ]; then
      echo "FEHLER: E-18-SNAP sha256-Mismatch beim Ablegen von '$b' in '$dir'" >&2; return 1
    fi
    n=$((n + 1))
  done
  local pdf_name
  pdf_name="$(basename "$AF_GATE_PDF")"
  {
    echo "# E-18-SNAP Compile-Schnappschuss -- QUELLSTAND"
    echo "# OWNER-KERN (Ledger frueh-6): 'so laesst sich ein compile nachvollziehen'."
    echo "# Diese Datei nennt GENAU die Staende, aus denen die danebenliegende PDF entstanden ist:"
    echo "# thesis_commit_sha ist der Quellstand der Diplomarbeit (Projekt 289), super_commit_sha"
    echo "# der Stand des Mess-/Bau-Repos (Projekt 288), der den Kanal-Lauf ausgeloest hat."
    echo "snapshot_id=$(basename "$dir")"
    echo "generiert_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "thesis_commit_sha=$thesis_sha"
    echo "thesis_branch=$AF_BRANCH"
    echo "super_commit_sha=$AF_PROV_SUPER_SHA"
    echo "super_commit_ref=$AF_PROV_SUPER_REF"
    echo "kanal_lauf_id=${AF_PROV_PIPELINE_ID}"
    echo "kanal_lauf_url=${AF_PROV_PIPELINE_URL}"
    echo "quelle_kind=$SRC_KIND"
    echo "quelle_ref=$SRC_NOTE"
    echo "haupt_dokument=$AF_GATE_MAIN"
    echo "tex_werkzeug=$AF_GATE_TOOL"
    echo "pdf_datei=$pdf_name"
    echo "pdf_bytes=$(wc -c < "$dir/$pdf_name")"
    echo "pdf_sha256=$(af_sha256 "$dir/$pdf_name")"
    echo "compile_export=compile-export.txt"
    echo "anhang_dateien_uebernommen=$changed"
    # Modus: "vorwaerts" = dieser Lauf hat den 289-Commit erzeugt; "nachholen" = der 289-Stand lag
    # schon auf dem Branch, nur sein Compile-Beleg fehlte. Der Beleg behauptet nie, mehr getan zu
    # haben, als getan wurde.
    echo "modus=$AF_MODE"
    echo "thesis_commit_aus_diesem_lauf=$([ "$AF_MODE" = "vorwaerts" ] && echo ja || echo nein)"
  } > "$dir/QUELLSTAND.txt" || { echo "FEHLER: E-18-SNAP: QUELLSTAND.txt in '$dir' nicht schreibbar" >&2; return 1; }
  # VOLLSTAENDIGKEITS-WACHE (Codex MITTEL-1): unter `if ! ...` ist `set -e` aus -- ein halb
  # geschriebener Ordner darf NIE als Erfolg durchgehen, sonst stagt ihn der 288-Writeback.
  local fehlend=""
  [ -s "$dir/$pdf_name" ]           || fehlend="$fehlend $pdf_name"
  [ -s "$dir/compile-export.txt" ]  || fehlend="$fehlend compile-export.txt"
  [ -s "$dir/QUELLSTAND.txt" ]      || fehlend="$fehlend QUELLSTAND.txt"
  grep -q "^thesis_commit_sha=$thesis_sha$" "$dir/QUELLSTAND.txt" 2>/dev/null || fehlend="$fehlend QUELLSTAND.txt:thesis_commit_sha"
  grep -q '^pdf_sha256=[0-9a-f]\{64\}$' "$dir/QUELLSTAND.txt" 2>/dev/null   || fehlend="$fehlend QUELLSTAND.txt:pdf_sha256"
  if [ -n "$fehlend" ]; then
    echo "FEHLER: E-18-SNAP: unvollstaendiger Schnappschuss in '$dir' -- fehlt/leer:$fehlend" >&2
    echo "       Ein halber Compile-Beleg ist schlimmer als keiner (er sieht vollstaendig aus)." >&2
    echo "       Der Ordner wird BEWUSST NICHT geloescht (Messdaten-Doktrin); der 288-Writeback" >&2
    echo "       stagt ihn nicht, weil dessen Vollstaendigkeits-Wache dieselben 3 Pflichtstuecke prueft." >&2
    return 1
  fi
  echo "   E-18-SNAP: Schnappschuss abgelegt ($n Bau-Datei(en) + QUELLSTAND.txt, modus=$AF_MODE) -> $dir"
  find "$dir" -type f | sort | sed 's/^/     /'
  return 0
}

if [ "$AF_PDF_GATE" != "off" ]; then
  if ! run_pdf_gate; then
    echo "   Rollback: gestagte Anhang-Aenderungen werden verworfen (nichts wird gelandet)" >&2
    git -C "$AF_DEST_REPO" reset -q HEAD -- anhang || true
    git -C "$AF_DEST_REPO" checkout -q -- anhang || true
    # Entscheidend ist der Zustand VOR dem cp (Codex MITTEL-3), nicht der jetzige: eine fremde
    # unversionierte Datei, die dieser Lauf nur UEBERSCHRIEBEN hat, ist heute genauso
    # "unversioniert" wie eine selbst angelegte -- die alte Pruefung haette sie geloescht.
    #   neu      -> loeschen (selbst erzeugt)
    #   getrackt -> nichts tun (das `git checkout` oben hat sie schon zurueckgeholt)
    #   fremd    -> Original-Inhalt aus der Sicherung WIEDERHERSTELLEN, niemals loeschen
    zurueck=0; erhalten=0; wieder=0
    while IFS='|' read -r zustand sicherung rel; do
      [ -n "$rel" ] || continue
      case "$zustand" in
        neu)
          if git -C "$AF_DEST_REPO" ls-files --error-unmatch -- "$rel" >/dev/null 2>&1; then
            erhalten=$((erhalten + 1))   # wider Erwarten getrackt -> checkout hat entschieden
          else
            rm -f -- "$AF_DEST_REPO/$rel"; zurueck=$((zurueck + 1))
          fi
          ;;
        fremd)
          if cp -- "$PREEXIST_DIR/$sicherung" "$AF_DEST_REPO/$rel"; then
            wieder=$((wieder + 1))
          else
            echo "FEHLER: Rollback konnte den Vorbestand '$rel' nicht wiederherstellen" >&2
          fi
          ;;
        *)
          erhalten=$((erhalten + 1))
          ;;
      esac
    done < "$COPIED_LIST"
    echo "   Rollback: $zurueck selbst angelegte Datei(en) entfernt, $wieder fremde Datei(en) im" >&2
    echo "   Original-Inhalt wiederhergestellt, $erhalten getrackte per checkout zurueckgeholt" >&2
    pdf_gate_aufraeumen
    if [ "$AF_MODE" = "nachholen" ]; then
      echo "=== anhang:forward ABGEBROCHEN: PDF-Gate rot bei der Beleg-NACHHOLUNG ===" >&2
      echo "    Es gab 0 Anhang-Delta -- der bereits gelandete 289-HEAD $DEST_HEAD baut NICHT." >&2
      echo "    KEIN Commit, KEIN Push, KEIN Schnappschuss (ein Beleg fuer einen kaputten Bau" >&2
      echo "    waere eine Luege). Das ist ein echter Befund am 289-Stand, kein Kanal-Fehler." >&2
    else
      echo "=== anhang:forward ABGEBROCHEN: PDF-Gate rot -> KEIN Commit, KEIN Push ===" >&2
    fi
    exit 1
  fi
  # E-18-SNAP Phase 1: ZWINGEND vor dem Aufraeumen (Begruendung s. Funktions-Kopf oben).
  if ! compile_snapshot_einsammeln; then
    echo "=== anhang:forward ABGEBROCHEN: E-18-SNAP konnte den Compile nicht sichern ===" >&2
    echo "    (KEIN Commit, KEIN Push -- der 289-Klon ist ephemer und wird je Lauf neu geholt)" >&2
    exit 1
  fi
  pdf_gate_aufraeumen
else
  echo "   ABGESCHALTET (AF_PDF_GATE=off) -- es wurde NICHT geprueft, ob die PDF noch baut"
  # Ohne Gate gibt es kein Bau-Produkt; die Funktion sagt genau das literal (kein stiller Ausfall).
  if ! compile_snapshot_einsammeln; then
    echo "=== anhang:forward ABGEBROCHEN: E-18-SNAP konnte den Compile nicht sichern ===" >&2
    exit 1
  fi
fi

# ---- (3d) NACHHOLUNG: 0 Byte-Delta, aber der Compile-Beleg zum 289-HEAD fehlte --------
# Hier gibt es NICHTS zu committen und NICHTS zu pushen -- der 289-Stand liegt bereits auf dem
# Branch. Der Schnappschuss wird gegen genau diesen HEAD fixiert; das ist derselbe Baum, aus dem
# das Gate soeben gebaut hat (0 Delta), also KEINE divergente Dokumentation.
if [ "$AF_MODE" = "nachholen" ]; then
  echo "-- (3d) E-18-SNAP NACHHOLUNG (kein Commit, kein Push) --"
  if [ ! -d "$AF_SNAP_STAGE" ]; then
    echo "=== anhang:forward OK: 0 Byte-Delta; Nachholung NICHT moeglich (kein Compile, s.o.) -> nichts abgelegt ==="
    exit 0
  fi
  if ! compile_snapshot_schreiben "$DEST_HEAD"; then
    echo "=== anhang:forward ABGEBROCHEN: E-18-SNAP-Nachholung fehlgeschlagen ===" >&2
    echo "    (nichts committet, nichts gepusht -- der 289-Stand $DEST_HEAD bleibt unveraendert)" >&2
    exit 1
  fi
  echo "=== anhang:forward OK: KEIN Commit (0 Byte-Delta), Compile-Beleg zu $DEST_HEAD NACHGEHOLT ==="
  exit 0
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
# Der Baum, aus dem das Gate gebaut hat. Er ist die Wahrheits-Referenz fuer Phase 2: nur solange
# der GELANDETE HEAD genau diesen Baum traegt, gehoert das Bau-Produkt wirklich zu ihm.
BUILD_TREE="$(git -C "$AF_DEST_REPO" rev-parse 'HEAD^{tree}')"
echo "   gebauter Baum: $BUILD_TREE"

if [ "$AF_NO_PUSH" = "true" ]; then
  # Kein Push => der lokale Commit IST der Endstand; nichts kann noch divergieren.
  echo "-- (4b) E-18-SNAP Compile-Schnappschuss (AF_NO_PUSH=true: lokaler Commit ist der Endstand) --"
  if ! compile_snapshot_schreiben "$(git -C "$AF_DEST_REPO" rev-parse HEAD)"; then
    echo "=== anhang:forward ABGEBROCHEN: E-18-SNAP-Schnappschuss fehlgeschlagen ===" >&2
    echo "    (der 289-Commit ist lokal entstanden, aber NICHT gepusht -- nichts ist gelandet)" >&2
    exit 1
  fi
  echo "=== anhang:forward OK (lokal committet; AF_NO_PUSH=true -> kein Push) ==="
  exit 0
fi

# ---- (5) Push mit MERGE-Retry (KEIN rebase, KEIN --force) ----------------------------
# BEWUSST OHNE `-o ci.skip`: die 289-Pipeline (lint + thesis-pdf de/en) IST der
# Post-measure-Rebuild. 289 triggert 288 nicht zurueck -> kein Loop.
#
# WARUM DER SCHNAPPSCHUSS ERST NACH DEM PUSH GESCHRIEBEN WIRD (Codex HOCH-3): jeder Retry haengt
# einen MERGE-Commit an. Was am Ende auf dem Branch steht, ist dann NICHT der Commit, dessen Baum
# das Gate gebaut hat. Ein vorher geschriebener QUELLSTAND behauptete "diese PDF gehoert zu X" --
# und X traegt einen anderen Inhalt als der Branch. Genau das ist die divergente Dokumentation, die
# der Ordner verhindern soll. Also: erst landen, dann belegen -- und wenn der gelandete Baum ein
# anderer ist, ERNEUT ernten statt umdeklarieren.
echo "-- (5) Push nach $AF_BRANCH (ohne ci.skip: die 289-Pipeline ist der Rebuild) --"
PUSH_MERGES=0
PUSH_OK=false
PUSH_ATTEMPT=0
for attempt in $(seq 1 "$AF_PUSH_RETRIES"); do
  PUSH_ATTEMPT="$attempt"
  if git -C "$AF_DEST_REPO" push origin "HEAD:$AF_BRANCH"; then
    PUSH_OK=true
    break
  fi
  echo "   push abgelehnt (non-ff-Race) -> fetch + MERGE (kein rebase) + retry ($attempt)" >&2
  git -C "$AF_DEST_REPO" fetch origin "$AF_BRANCH"
  if ! git -C "$AF_DEST_REPO" -c user.name="anhang-forward-bot" -c user.email="anhang-forward-bot@ci.local" \
        merge --no-edit -m "Merge origin/$AF_BRANCH in anhang-forward $SRC_NOTE" "origin/$AF_BRANCH"; then
    git -C "$AF_DEST_REPO" merge --abort || true
    echo "FEHLER: unerwarteter Merge-Konflikt (Versuch $attempt) -> echter Bug, Abbruch (kein --force)" >&2
    exit 1
  fi
  PUSH_MERGES=$((PUSH_MERGES + 1))
  sleep $(( (RANDOM % 5) + 2 ))
done
if [ "$PUSH_OK" != "true" ]; then
  echo "FEHLER: Push nach $AF_PUSH_RETRIES Versuchen fehlgeschlagen" >&2
  exit 1
fi
PUSHED_SHA="$(git -C "$AF_DEST_REPO" rev-parse HEAD)"
PUSHED_TREE="$(git -C "$AF_DEST_REPO" rev-parse 'HEAD^{tree}')"
echo "   gepusht (Versuch $PUSH_ATTEMPT): HEAD=$PUSHED_SHA baum=$PUSHED_TREE merges=$PUSH_MERGES"

# ---- (5b) E-18-SNAP Phase 2: Beleg gegen den TATSAECHLICH gepushten HEAD --------------
echo "-- (5b) E-18-SNAP Compile-Schnappschuss (gegen den gelandeten Stand) --"
# Re-Ernte, falls der gelandete Baum nicht der gebaute ist. Nur zwei Ausgaenge sind erlaubt:
# wahrer Beleg oder lauter Abbruch -- niemals ein Beleg mit fremder SHA.
compile_snapshot_refixieren() {
  [ "$AF_COMPILE_SNAPSHOT" = "true" ] || return 0
  [ -d "$AF_SNAP_STAGE" ] || return 0          # nichts geerntet (kein Compile) -> nichts zu richten
  if [ "$PUSHED_TREE" = "$BUILD_TREE" ]; then
    echo "   E-18-SNAP: gelandeter Baum == gebauter Baum ($BUILD_TREE) -> Bau-Produkt gilt unveraendert"
    return 0
  fi
  echo "   E-18-SNAP: der Push lief ueber $PUSH_MERGES Merge-Commit(s); gelandeter Baum $PUSHED_TREE" >&2
  echo "   ist NICHT der gebaute $BUILD_TREE -> RE-ERNTE (nie divergent dokumentieren)" >&2
  if [ "$AF_PDF_GATE" = "off" ]; then
    echo "FEHLER: Re-Ernte unmoeglich (AF_PDF_GATE=off) -- ein Beleg mit fremder SHA waere eine Luege." >&2
    return 1
  fi
  # Der Ernte-Zwischenstand gehoert diesem Lauf allein (fester Name unter $AF_TMP) und wird
  # verworfen, damit keine Datei aus dem ALTEN Bau in den neuen Beleg rutscht.
  rm -rf -- "$AF_SNAP_STAGE" || { echo "FEHLER: Ernte-Ablage '$AF_SNAP_STAGE' nicht raeumbar" >&2; return 1; }
  AF_GATE_PDF=""; AF_GATE_MAIN=""; AF_GATE_TOOL=""
  if ! run_pdf_gate; then
    echo "FEHLER: Re-Ernte: der GEMERGTE Stand $PUSHED_SHA baut nicht -> KEIN Schnappschuss." >&2
    return 1
  fi
  if [ -z "$AF_GATE_PDF" ]; then
    echo "FEHLER: Re-Ernte: das PDF-Gate hat diesmal nicht gebaut -> KEIN Schnappschuss (statt eines" >&2
    echo "       Belegs, der die PDF des VORIGEN Baums traegt)." >&2
    return 1
  fi
  compile_snapshot_einsammeln || return 1
  pdf_gate_aufraeumen
  echo "   E-18-SNAP: re-geerntet aus dem gelandeten Baum $PUSHED_TREE"
  return 0
}
if ! compile_snapshot_refixieren; then
  echo "=== anhang:forward ABGEBROCHEN: 289-Commit IST GEPUSHT ($PUSHED_SHA), aber der Compile-Beleg ===" >&2
  echo "    liess sich nicht wahrheitsgemaess auf diesen Stand fixieren -> KEIN Schnappschuss abgelegt." >&2
  echo "    (Der naechste Lauf holt ihn ueber die Nachhol-Wache nach, sobald der Bau wieder gruen ist.)" >&2
  exit 1
fi
if ! compile_snapshot_schreiben "$PUSHED_SHA"; then
  echo "=== anhang:forward ABGEBROCHEN: 289-Commit IST GEPUSHT ($PUSHED_SHA), aber der Compile-Beleg ===" >&2
  echo "    liess sich nicht ablegen -> KEIN Schnappschuss. Der naechste Lauf holt ihn nach." >&2
  exit 1
fi
echo "=== anhang:forward OK: gepusht (Versuch $PUSH_ATTEMPT) nach $AF_BRANCH ==="
exit 0
