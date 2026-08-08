#!/bin/sh
# REV 7.7 V23.3 (2026-05-14) - Lazy on-demand Benchmark-Daten-Download
# 08.08.2026 (GNU-Bauweg): von Code/tools/ nach scripts/ umgezogen und auf POSIX sh
# gestellt. Aufruf jetzt ueber "make testdata" (TESTDATA_ARGS=... fuer Argumente).
# Ein Datenbeschaffer ist KEIN Test-Runner -- "make check" ersetzt ihn nicht, deshalb
# ist er als einziger aus Code/tools/ erhalten geblieben.
#
# Verwendung:
#   ./fetch_testdata.sh --dataset <name>
#   ./fetch_testdata.sh --list
#   ./fetch_testdata.sh --all
#
# Zielordner: Code/tests/fixtures/external/ (gitignored).
# Memory-Direktive F-EXTRA-5: KEIN Python, nur sh/bat/cmake.

# POSIX sh: kein "-o pipefail" (bash-spezifisch, dash bricht mit
# "Illegal option -o pipefail" ab). Das Skript nutzt keine Pipes, deren
# Zwischenglieder fehlschlagen koennten -- curl steht jeweils allein.
set -eu

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
FIXTURES_DIR="${SCRIPT_DIR}/../Code/tests/fixtures/external"
mkdir -p "${FIXTURES_DIR}"

datasets_list() {
  cat <<EOF
Verfuegbare Datensaetze (V23.3):
  english_words         english-words/words.txt (4 MB, MIT)              Wormhole P07
  sosd_books_200M       SOSD books_200M_uint64 (1.6 GB, CC-BY)            P05/P06/P20
  sosd_fb               SOSD fb_200M_uint64 (1.6 GB, CC-BY)               P11-P19
  sosd_wiki_ts          SOSD wiki_ts_200M_uint64 (1.6 GB, CC-BY)          P11-P19
  pizzachili_dna        Pizza&Chili DNA (404 MB, public)                  P01/P02/P04
  pizzachili_xml        Pizza&Chili XML/DBLP (295 MB, public)             P04
  pizzachili_protein    Pizza&Chili Protein (1.18 GB, public)             P04

ZU BEACHTEN (NICHT automatisiert -- ein Aufruf mit diesen Namen bricht mit
"Unbekannter Datensatz" ab, das ist gewollt und kein Defekt):
  sosd_osm_cellids      SOSD osm_cellids_800M_uint64 (6.4 GB, CC-BY)      P11-P19
                        Stand 08.08.2026: fuer diesen Satz ist KEINE Bezugs-DOI hinterlegt.
                        Er stand bis heute in dieser Liste, ohne dass es ihn im case gab --
                        die Liste versprach also etwas, das das Skript nicht konnte. Statt
                        eine DOI zu raten, steht er jetzt dort, wo er hingehoert.

  it_2004_urls          247 MB, LAW akademisch (User-Auth): Sign-Up auf https://law.di.unimi.it/datasets.php
                        manuell herunterladen + nach ${FIXTURES_DIR}/it_2004/it-2004.urls.gz
EOF
}

fetch_english_words() {
  local out="${FIXTURES_DIR}/english_words"
  mkdir -p "${out}"
  if [ -f "${out}/words.txt" ]; then
    echo "[skip] english_words bereits vorhanden: ${out}/words.txt"
    return 0
  fi
  echo "[fetch] english-words/words.txt (~4 MB)"
  curl -fsSL -o "${out}/words.txt" \
    "https://github.com/dwyl/english-words/raw/master/words.txt"
  echo "[done] ${out}/words.txt"
}

fetch_sosd_books_200M() {
  local out="${FIXTURES_DIR}/sosd"
  mkdir -p "${out}"
  if [ -f "${out}/books_200M_uint64" ]; then
    echo "[skip] sosd_books_200M bereits vorhanden"
    return 0
  fi
  echo "[fetch] SOSD books_200M_uint64 (~1.6 GB)"
  curl -fsSL -o "${out}/books_200M_uint64" \
    "https://dataverse.harvard.edu/api/access/datafile/:persistentId?persistentId=doi:10.7910/DVN/JGVF9A/5YTV8K"
  echo "[done] ${out}/books_200M_uint64"
}

fetch_sosd_fb() {
  local out="${FIXTURES_DIR}/sosd"
  mkdir -p "${out}"
  if [ -f "${out}/fb_200M_uint64" ]; then
    echo "[skip] sosd_fb bereits vorhanden"
    return 0
  fi
  echo "[fetch] SOSD fb_200M_uint64 (~1.6 GB)"
  curl -fsSL -o "${out}/fb_200M_uint64" \
    "https://dataverse.harvard.edu/api/access/datafile/:persistentId?persistentId=doi:10.7910/DVN/JGVF9A/EATHF7"
  echo "[done] ${out}/fb_200M_uint64"
}

fetch_sosd_wiki_ts() {
  local out="${FIXTURES_DIR}/sosd"
  mkdir -p "${out}"
  if [ -f "${out}/wiki_ts_200M_uint64" ]; then
    echo "[skip] sosd_wiki_ts bereits vorhanden"
    return 0
  fi
  echo "[fetch] SOSD wiki_ts_200M_uint64 (~1.6 GB)"
  curl -fsSL -o "${out}/wiki_ts_200M_uint64" \
    "https://dataverse.harvard.edu/api/access/datafile/:persistentId?persistentId=doi:10.7910/DVN/JGVF9A/SVN8PI"
  echo "[done] ${out}/wiki_ts_200M_uint64"
}

fetch_pizzachili_dna() {
  local out="${FIXTURES_DIR}/pizzachili"
  mkdir -p "${out}"
  if [ -f "${out}/dna.gz" ] || [ -f "${out}/dna" ]; then
    echo "[skip] pizzachili_dna bereits vorhanden"
    return 0
  fi
  echo "[fetch] Pizza&Chili DNA (~404 MB)"
  curl -fsSL -o "${out}/dna.gz" \
    "https://pizzachili.dcc.uchile.cl/texts/dna/dna.gz"
  echo "[done] ${out}/dna.gz (gunzip vor Nutzung)"
}

fetch_pizzachili_xml() {
  local out="${FIXTURES_DIR}/pizzachili"
  mkdir -p "${out}"
  if [ -f "${out}/dblp.xml.gz" ] || [ -f "${out}/dblp.xml" ]; then
    echo "[skip] pizzachili_xml bereits vorhanden"
    return 0
  fi
  echo "[fetch] Pizza&Chili XML DBLP (~295 MB)"
  curl -fsSL -o "${out}/dblp.xml.gz" \
    "https://pizzachili.dcc.uchile.cl/texts/xml/dblp.xml.gz"
  echo "[done] ${out}/dblp.xml.gz"
}

fetch_pizzachili_protein() {
  local out="${FIXTURES_DIR}/pizzachili"
  mkdir -p "${out}"
  if [ -f "${out}/proteins.gz" ] || [ -f "${out}/proteins" ]; then
    echo "[skip] pizzachili_protein bereits vorhanden"
    return 0
  fi
  echo "[fetch] Pizza&Chili Protein (~1.18 GB)"
  curl -fsSL -o "${out}/proteins.gz" \
    "https://pizzachili.dcc.uchile.cl/texts/protein/proteins.gz"
  echo "[done] ${out}/proteins.gz"
}

# Dispatch
if [ $# -eq 0 ]; then
  datasets_list
  exit 1
fi

case "$1" in
  --list) datasets_list ;;
  --all)
    fetch_english_words
    fetch_sosd_books_200M
    fetch_sosd_fb
    fetch_sosd_wiki_ts
    fetch_pizzachili_dna
    fetch_pizzachili_xml
    fetch_pizzachili_protein
    echo "[hint] it_2004_urls braucht manuelle User-Aktion (LAW Sign-Up)"
    ;;
  --dataset)
    case "${2:-}" in
      english_words)      fetch_english_words ;;
      sosd_books_200M)    fetch_sosd_books_200M ;;
      sosd_fb)            fetch_sosd_fb ;;
      sosd_wiki_ts)       fetch_sosd_wiki_ts ;;
      pizzachili_dna)     fetch_pizzachili_dna ;;
      pizzachili_xml)     fetch_pizzachili_xml ;;
      pizzachili_protein) fetch_pizzachili_protein ;;
      *) echo "Unbekannter Datensatz: ${2:-}"; datasets_list; exit 2 ;;
    esac
    ;;
  *) echo "Usage: $0 [--list | --all | --dataset <name>]"; exit 1 ;;
esac
