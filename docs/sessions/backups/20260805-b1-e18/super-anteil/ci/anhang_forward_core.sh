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
#   * LOESCHT NIE etwas im Ziel-Repo (kein rm, kein `git rm`, kein --force)
#   * ohne Byte-Delta entsteht KEIN Commit  (Loop-/Rausch-Wache)
#   * ohne Quelle entsteht KEIN Commit und KEIN Fehler (honest-empty)
#   * landet NIE einen Stand, mit dem die Thesis-PDF nicht mehr baut (PDF-GATE, s.u.)
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
echo "-- (3) Idempotenz-Pruefung im Ziel-Repo --"
for lang in $LANGS; do
  git -C "$AF_DEST_REPO" add -- "anhang/$lang/tabellen" 2>/dev/null || true
done
changed=$(git -C "$AF_DEST_REPO" diff --cached --name-only | wc -l)
echo "   gestagte Aenderungen: $changed Datei(en)"
if [ "$changed" -gt 0 ]; then git -C "$AF_DEST_REPO" diff --cached --name-only | sed 's/^/     /'; fi
if git -C "$AF_DEST_REPO" diff --cached --quiet; then
  echo "=== anhang:forward IDEMPOTENT: 0 Aenderungen -> kein Commit ==="
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
