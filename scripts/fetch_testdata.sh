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
                        Quelle ist books_800M_uint64.zst (~4 GB Download); die
                        200M-uint64-Fassung entsteht durch Downsampling, s.u.
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

# --- sosd_books_200M: Konstanten des Rezepts (#203, 2026-09-16) ---------------
# WARUM DIESER BLOCK EXISTIERT (Befund 2026-09-16, am Objekt nachgemessen):
# Die frueheren Zeilen luden den Datensatz von dataverse 5YTV8K. Diese DOI ist
# laut Upstream-Skript (github learnedsystems/SOSD, scripts/download.sh Z.51)
# books_200M_uint32 -- ein ANDERER Datensatz: 32-Bit-Schluessel, md5
# 9f3e578671e5c0348cdddc9c68946770. Der Loader sosd_uint64 (LE-8-Byte-Count +
# N*uint64 LE) kann ihn nicht lesen. Die uint64-Fassung entsteht upstream NICHT
# durch Download, sondern durch Downsampling der 800M-Datei (download.sh Z.53 +
# Z.66 "python3 downsample.py"): jede 4. Zahl, Header auf 200000000 gesetzt.
#
# ZWEITER BEFUND: die Upstream-md5 gilt der DEKOMPRIMIERTEN Datei, nicht dem
# .zst-Archiv -- download_file_zst prueft nach "wget -O - URL | zstd -d > FILE".
# Deshalb prueft dieses Skript die md5 des zstd-Stroms, nie die des Archivs.
SOSD_BOOKS_800M_MD5="8708eb3e1757640ba18dcd3a0dbb53bc"
SOSD_BOOKS_800M_URL="https://www.dropbox.com/s/y2u3nbanbnbmg7n/books_800M_uint64.zst?dl=1"
SOSD_BOOKS_800M_COUNT="800000000"
SOSD_BOOKS_200M_COUNT="200000000"
SOSD_BOOKS_200M_SIZE="1600000008"
SOSD_BOOKS_200M_SHA256="c71eb78eebb746f0e525e47d3d7e6b097f680c45cf17f1ead1d1f22a8950f939"

# Downsample-Werkzeug als C-Quelle. KEIN Python: die NO-PYTHON-Direktive
# (F-EXTRA-5/H6, Betreuer-Feedback 2026-05-08, Grund Talos-Kompatibilitaet)
# gilt fuer dieses Skript ausweislich seines eigenen Kopfes. Das Upstream-
# Rezept ist numpy d[::4]; hier ist es ein streamender C-Filter: konstanter
# Speicher, keine 6.4-GB-Zwischendatei, und er prueft beim Schreiben mit.
sosd_downsample_quelle() {
  cat <<'CQUELLE'
/* SOSD-Downsample: LE-8-Byte-Count + N*uint64 LE  ->  jede 4. Zahl (d[::4]).
 * Eingabe: stdin (Rohstrom, z.B. aus "zstd -dc").  Ausgabe: argv[1].
 * Prueft beim Schreiben: Elementzahl, erste/letzte Zahl, Monotonie (SOSD-
 * Schluessel sind sortiert).  Exit 0 nur, wenn alle Pruefungen halten. */
#include <stdio.h>
#include <stdlib.h>

#define IN_ELEMS 262144u
#define OUT_ELEMS 65536u

static unsigned long long le64(const unsigned char *b) {
    unsigned long long v = 0ull;
    int               i;
    for (i = 7; i >= 0; --i) { v = (v << 8) | (unsigned long long)b[i]; }
    return v;
}

static void put_le64(unsigned char *b, unsigned long long v) {
    int i;
    for (i = 0; i < 8; ++i) { b[i] = (unsigned char)((v >> (8 * i)) & 0xFFu); }
}

int main(int argc, char **argv) {
    FILE          *out;
    unsigned char  hdr[8];
    unsigned char *inbuf;
    unsigned char *outbuf;
    unsigned long long n_in, n_out, idx = 0ull, written = 0ull;
    unsigned long long first = 0ull, last = 0ull, prev = 0ull, brueche = 0ull;
    int                have_prev = 0;
    size_t             ofill = 0, got, k;

    if (argc != 2) { fprintf(stderr, "usage: downsample <ausgabedatei>\n"); return 2; }
    if (fread(hdr, 1, 8, stdin) != 8) { fprintf(stderr, "FEHLER: Count-Header fehlt\n"); return 3; }
    n_in  = le64(hdr);
    n_out = (n_in + 3ull) / 4ull;
    if (n_in == 0ull) { fprintf(stderr, "FEHLER: Count-Header ist 0\n"); return 3; }

    out = fopen(argv[1], "wb");
    if (out == NULL) { fprintf(stderr, "FEHLER: Ausgabedatei nicht schreibbar\n"); return 4; }
    put_le64(hdr, n_out);
    if (fwrite(hdr, 1, 8, out) != 8) { fprintf(stderr, "FEHLER: Header-Schreiben\n"); return 4; }

    inbuf  = (unsigned char *)malloc((size_t)IN_ELEMS * 8u);
    outbuf = (unsigned char *)malloc((size_t)OUT_ELEMS * 8u);
    if (inbuf == NULL || outbuf == NULL) { fprintf(stderr, "FEHLER: malloc\n"); return 4; }

    for (;;) {
        got = fread(inbuf, 8, (size_t)IN_ELEMS, stdin);
        if (got == 0) { break; }
        for (k = 0; k < got; ++k, ++idx) {
            unsigned long long v;
            if ((idx & 3ull) != 0ull) { continue; }
            v = le64(inbuf + k * 8u);
            if (written == 0ull) { first = v; }
            if (have_prev != 0 && v < prev) { ++brueche; }
            prev      = v;
            have_prev = 1;
            last      = v;
            put_le64(outbuf + ofill * 8u, v);
            ++ofill;
            ++written;
            if (ofill == (size_t)OUT_ELEMS) {
                if (fwrite(outbuf, 8, ofill, out) != ofill) { fprintf(stderr, "FEHLER: Schreiben\n"); return 4; }
                ofill = 0;
            }
        }
    }
    if (ofill != 0) {
        if (fwrite(outbuf, 8, ofill, out) != ofill) { fprintf(stderr, "FEHLER: Schreiben (Rest)\n"); return 4; }
    }
    if (ferror(stdin) != 0) { fprintf(stderr, "FEHLER: Lesen von stdin\n"); return 3; }
    if (fclose(out) != 0) { fprintf(stderr, "FEHLER: Schliessen der Ausgabedatei\n"); return 4; }

    fprintf(stderr, "[downsample] count_ein=%llu count_aus=%llu gelesen=%llu\n", n_in, n_out, idx);
    fprintf(stderr, "[downsample] erste=%llu letzte=%llu monotonie_brueche=%llu\n", first, last, brueche);
    if (idx != n_in) { fprintf(stderr, "FEHLER: Eingabe unvollstaendig (%llu von %llu)\n", idx, n_in); return 3; }
    if (written != n_out) { fprintf(stderr, "FEHLER: Ausgabe-Zahl %llu != %llu\n", written, n_out); return 3; }
    if (brueche != 0ull) { fprintf(stderr, "FEHLER: %llu Monotonie-Brueche\n", brueche); return 3; }
    return 0;
}
CQUELLE
}

# Baut das Downsample-Werkzeug in ${1} (Verzeichnis); Pfad kommt auf stdout.
sosd_downsample_bauen() {
  _dir="$1"
  _cc="${CC:-}"
  if [ -z "${_cc}" ]; then
    if command -v cc >/dev/null 2>&1; then _cc="cc"
    elif command -v c99 >/dev/null 2>&1; then _cc="c99"
    elif command -v gcc >/dev/null 2>&1; then _cc="gcc"
    else echo "FEHLER: kein C-Compiler (cc/c99/gcc) gefunden" >&2; return 4; fi
  fi
  sosd_downsample_quelle > "${_dir}/sosd_downsample.c"
  "${_cc}" -O2 -o "${_dir}/sosd_downsample" "${_dir}/sosd_downsample.c" >&2 || {
    echo "FEHLER: Uebersetzung des Downsample-Werkzeugs fehlgeschlagen" >&2; return 4; }
  echo "${_dir}/sosd_downsample"
}

fetch_sosd_books_200M() {
  local out="${FIXTURES_DIR}/sosd"
  local dst="${out}/books_200M_uint64"
  local zst="${out}/books_800M_uint64.zst"
  local tmpdir=""
  local tool=""
  local ist_md5=""
  local ist_sha=""
  local ist_size=""
  mkdir -p "${out}"

  # Idempotenz: vorhandene Zieldatei mit korrekter Groesse UND sha256 -> nichts tun.
  if [ -f "${dst}" ]; then
    ist_size="$(wc -c < "${dst}" | tr -d ' ')"
    ist_sha="$(sha256sum "${dst}" | cut -d' ' -f1)"
    if [ "${ist_size}" = "${SOSD_BOOKS_200M_SIZE}" ] && [ "${ist_sha}" = "${SOSD_BOOKS_200M_SHA256}" ]; then
      echo "[skip] sosd_books_200M vorhanden und geprueft: ${dst}"
      echo "[skip] size=${ist_size} sha256=${ist_sha}"
      return 0
    fi
    echo "[warn] ${dst} vorhanden, aber size/sha256 weichen ab -- wird neu erzeugt."
    echo "[warn] ist:  size=${ist_size} sha256=${ist_sha}"
    echo "[warn] soll: size=${SOSD_BOOKS_200M_SIZE} sha256=${SOSD_BOOKS_200M_SHA256}"
  fi

  # Quelle: books_800M_uint64.zst (~4 GB). curl -C - setzt einen Abbruch fort.
  if [ ! -f "${zst}" ]; then
    echo "[fetch] SOSD books_800M_uint64.zst (~4 GB, Quelle des 200M-Satzes)"
  else
    echo "[fetch] setze vorhandenes ${zst} fort (curl -C -)"
  fi
  curl -fL -C - --retry 5 --retry-delay 10 --connect-timeout 30 -o "${zst}" "${SOSD_BOOKS_800M_URL}"

  # Upstream-Pruefsumme gilt dem DEKOMPRIMIERTEN Strom (s. Kopf dieses Blocks).
  echo "[pruefe] md5 des dekomprimierten Stroms gegen Upstream ..."
  ist_md5="$(zstd -dc "${zst}" | md5sum | cut -d' ' -f1)"
  if [ "${ist_md5}" != "${SOSD_BOOKS_800M_MD5}" ]; then
    echo "FEHLER: md5 ${ist_md5} != Upstream ${SOSD_BOOKS_800M_MD5} -- Abbruch." >&2
    return 5
  fi
  echo "[ok] md5=${ist_md5} (Upstream books_800M_uint64)"

  # Downsample: jede 4. Zahl, Header 200000000, streamend.
  tmpdir="$(mktemp -d)" || return 4
  tool="$(sosd_downsample_bauen "${tmpdir}")" || { rm -rf "${tmpdir}"; return 4; }
  echo "[downsample] ${zst} -> ${dst} (jede 4. Zahl, Header ${SOSD_BOOKS_200M_COUNT})"
  if ! zstd -dc "${zst}" | "${tool}" "${dst}.part"; then
    echo "FEHLER: Downsample fehlgeschlagen -- ${dst}.part bleibt zur Ansicht liegen." >&2
    rm -rf "${tmpdir}"
    return 5
  fi
  rm -rf "${tmpdir}"
  mv "${dst}.part" "${dst}"

  # Harte Gates an der fertigen Datei: Groesse, Count-Header, sha256.
  ist_size="$(wc -c < "${dst}" | tr -d ' ')"
  if [ "${ist_size}" != "${SOSD_BOOKS_200M_SIZE}" ]; then
    echo "FEHLER: Groesse ${ist_size} != ${SOSD_BOOKS_200M_SIZE} -- Abbruch." >&2
    return 5
  fi
  echo "[ok] size=${ist_size}"
  ist_sha="$(sha256sum "${dst}" | cut -d' ' -f1)"
  echo "[ok] sha256=${ist_sha}"
  if [ "${ist_sha}" != "${SOSD_BOOKS_200M_SHA256}" ]; then
    echo "FEHLER: sha256 ${ist_sha} != ${SOSD_BOOKS_200M_SHA256} -- Abbruch." >&2
    return 5
  fi
  echo "[done] ${dst}"
  echo "[hinweis] ${zst} bleibt als Bestands-Extra liegen (nie automatisch geloescht)."
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
