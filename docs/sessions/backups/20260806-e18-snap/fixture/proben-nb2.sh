#!/usr/bin/env bash
# =====================================================================================
# NB2-PROBEN fuer ci/anhang_forward_core.sh -- die FUENF Codex-Mindestanforderungen aus
# CODEX-VERDIKT-NB-1ae02cdf-NICHT-LANDEN.md plus die dort benannten MITTEL-Restbefunde.
# Je Anforderung ein praeparierter Fehlerfall + das erwartete Verhalten, und wo es
# bezahlbar ist die GEGENPROBE gegen den von Codex verworfenen Stand 1ae02cdf.
#
# AUFRUF (aus dem super-Arbeitsbaum):
#   PATH=/usr/local/texlive/2026/bin/x86_64-linux:$PATH \
#     bash docs/sessions/backups/20260806-e18-snap/fixture/proben-nb2.sh
#
# OFFENGELEGTE HILFSMITTEL (damit nichts "zufaellig" gruen aussieht) -- kein Shim
# beruehrt die zu pruefende Logik selbst, alle sitzen ausschliesslich in $PATH:
#   date-Shim     friert NUR `date -u +%Y%m%d-%H%M%S` ein (Kollisionen erzwingbar)
#   mkdir-Shim    laesst NUR das Anlegen des .tmp-Ordners scheitern, OHNE dass der Pfad
#                 entsteht -> das ist der ECHTE Dateisystem-Fehler (EACCES/ENOSPC-Klasse),
#                 den der alte Stand 99x als "Kollision" fehldeutete
#   cp-Shim       laesst NUR das Schreiben INNERHALB des .tmp-Ordners scheitern
#                 (Transaktions-Bruch mitten im Schreiben)
#   latexmk-Shim  meldet Erfolg, legt aber eine ALTE PDF mit ALTER mtime hin
#                 (= exakt der "Nothing to do"-Fall aus Codex NB2-4)
#   git-Shim      (a) laesst `ls-tree` scheitern (Remote-Fehler -> fail-closed?)
#                 (b) liefert ab dem N-ten `rev-parse HEAD` einen LEEREN String
# =====================================================================================
set -uo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../../.." && pwd)"
CORE="$REPO/ci/anhang_forward_core.sh"
R=/tmp/e18snap-fixture
H=/tmp/e18snap-nb2
FEHLER=0
TEX=/usr/local/texlive/2026/bin/x86_64-linux

ok()   { echo "   OK   : $*"; }
nok()  { echo "   FEHL : $*"; FEHLER=$((FEHLER + 1)); }
pruef(){ if [ "$2" = "$3" ]; then ok "$1 ($2)"; else nok "$1 -- erwartet '$3', ist '$2'"; fi; }
hat()  { if grep -qF "$2" "$1"; then ok "$3"; else nok "$3 -- '$2' fehlt in $1"; fi; }
hatnicht() { if grep -qF "$2" "$1"; then nok "$3 -- '$2' steht doch in $1"; else ok "$3"; fi; }
kopf() { echo; echo "=== $* ==="; }

rm -rf "$H"; mkdir -p "$H/bin" "$H/bin_mkdirfail" "$H/bin_cptmpfail" "$H/bin_nothingtodo" \
                     "$H/bin_lstreefail" "$H/bin_leerhead"
cat > "$H/bin/date" <<'EOF'
#!/bin/sh
if [ "$1" = "-u" ] && [ "$2" = "+%Y%m%d-%H%M%S" ] && [ -n "$E18_FIXED_TS" ]; then echo "$E18_FIXED_TS"; exit 0; fi
exec /usr/bin/date "$@"
EOF
cat > "$H/bin_mkdirfail/mkdir" <<'EOF'
#!/bin/sh
# Faellt NUR fuer den versteckten .tmp-Ordner um -- und legt ihn NICHT an. Genau so sieht
# EACCES/ENOSPC aus: der Pfad existiert hinterher nicht, es ist KEINE Kollision.
for a in "$@"; do last="$a"; done
case "$last" in *.tmp)
  echo "mkdir: cannot create directory '$last': Permission denied (PROBEN-SHIM)" >&2
  exit 1 ;;
esac
exec /bin/mkdir "$@"
EOF
cat > "$H/bin_cptmpfail/cp" <<'EOF'
#!/bin/sh
# Bricht das Schreiben MITTEN im .tmp-Ordner ab (Transaktion halb) -- die Ernte nach
# $AF_TMP/compile_snapshot laeuft bewusst durch.
for a in "$@"; do last="$a"; done
case "$last" in */.*.tmp/*) echo "cp: PROBEN-SHIM erzwingt Fehlschlag fuer '$last'" >&2; exit 1 ;; esac
exec /bin/cp "$@"
EOF
cat > "$H/bin_nothingtodo/latexmk" <<'EOF'
#!/bin/sh
# "Nothing to do": meldet Erfolg, baut aber NICHT. Legt stattdessen eine ALTE PDF mit ALTER
# mtime hin -- der Fall, in dem der Vorgaengerstand eine alte PDF mit neuer SHA beschriftete.
echo "Latexmk: Nothing to do for '$*'."
for a in "$@"; do last="$a"; done
out="${last%.tex}.pdf"
printf 'ALTE-PDF-AUS-EINEM-FRUEHEREN-BAU\n' > "$out"
touch -d '2020-01-01 00:00:00' "$out"
exit 0
EOF
cat > "$H/bin_lstreefail/git" <<'EOF'
#!/bin/sh
if [ "$1" = "-C" ]; then sub="$3"; else sub="$1"; fi
if [ "$sub" = "ls-tree" ]; then echo "fatal: PROBEN-SHIM: ls-tree kaputt" >&2; exit 128; fi
exec /usr/bin/git "$@"
EOF
cat > "$H/bin_leerhead/git" <<'EOF'
#!/bin/sh
# Ab dem N-ten `rev-parse HEAD` (exakt dieses Argumentpaar) kommt ein LEERER String mit RC 0
# zurueck -- die Klasse Fehler, die frueher `thesis_commit_sha=` in den Beleg schrieb.
N="${E18_LEER_REVPARSE_AB:-0}"
C="${E18_LEER_ZAEHLER:-/tmp/e18snap-nb2/revparse.cnt}"
if [ "$1" = "-C" ]; then a2="$3"; a3="$4"; else a2="$1"; a3="$2"; fi
if [ "$a2" = "rev-parse" ] && [ "$a3" = "HEAD" ] && [ "$N" != "0" ]; then
  n=$(cat "$C" 2>/dev/null || echo 0); n=$((n+1)); echo "$n" > "$C"
  if [ "$n" -ge "$N" ]; then echo ""; exit 0; fi
fi
exec /usr/bin/git "$@"
EOF
chmod +x "$H/bin/date" "$H/bin_mkdirfail/mkdir" "$H/bin_cptmpfail/cp" \
         "$H/bin_nothingtodo/latexmk" "$H/bin_lstreefail/git" "$H/bin_leerhead/git"
export PATH="$H/bin:$TEX:$PATH"
export E18_FIXED_TS=""

# ALT-Vergleichsstand = der von Codex VERWORFENE NB-Stand. Gegen ihn wird geprueft, was NB2
# wirklich heilt (nicht gegen den Erstwurf -- der ist zwei Stufen alt).
ALT_REF="${E18_ALT_REF:-1ae02cdfca04f399e34abe826f14636652fc0256}"
if ! git -C "$REPO" rev-parse --verify -q "$ALT_REF^{commit}" > /dev/null; then
  echo "FEHLER: ALT-Referenz '$ALT_REF' nicht im Repo -- Gegenproben nicht fahrbar" >&2; exit 1
fi
echo "ALT-Vergleichsstand (von Codex verworfen): $ALT_REF"
git -C "$REPO" show "$ALT_REF:ci/anhang_forward_core.sh" > "$H/core_alt.sh" && chmod +x "$H/core_alt.sh"

neue_tabellen() { # $1 = work-root, $2 = Marke
  mkdir -p "$1/Code/measure_out/appendix/de/tabellen" "$1/Code/measure_out/appendix/en/tabellen"
  printf '%s\n' "\\textbf{DE $2}\\par" > "$1/Code/measure_out/appendix/de/tabellen/T1.tex"
  printf '%s\n' "\\textbf{EN $2}\\par" > "$1/Code/measure_out/appendix/en/tabellen/T1.tex"
}
# Erzeugt Artefakt-Tabellen, die BYTE-GLEICH zum Ziel-Repo sind -> garantiert 0 Anhang-Delta.
# Ohne das entstuende ein Delta und der Lauf ginge in den Vorwaerts-Zweig, statt die Beleg-Frage
# zu stellen -- die Probe pruefte dann etwas anderes als sie behauptet.
tabellen_wie_branch() { # $1 = work-root, $2 = dest-Klon
  local l
  for l in de en; do
    mkdir -p "$1/Code/measure_out/appendix/$l/tabellen"
    cp "$2/anhang/$l/tabellen/"*.tex "$1/Code/measure_out/appendix/$l/tabellen/" 2>/dev/null || true
  done
}
lauf()     { env AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=on AF_PROV_SUPER_REF=development "$@" \
    "$CORE" 2>&1; }
lauf_alt() { env AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=on AF_PROV_SUPER_REF=development "$@" \
    "$H/core_alt.sh" 2>&1; }
snapdirs() { find "$1" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort; }

bash "$(dirname "${BASH_SOURCE[0]}")/setup.sh" > /dev/null
echo "Fixture aufgebaut unter $R"

# ============================================================ (1) EINDEUTIGE NAMEN
kopf "NB2-1a  Zwei PARALLELE Laeufe, GLEICHE Sekunde, GLEICHE Wurzel -> disjunkte Namen OHNE Reservierung"
TS=20260807-100000
git clone -q -b development "$R/super.git" "$R/n1_work"; neue_tabellen "$R/n1_work" "NB2-1a"
git clone -q -b development "$R/dest.git" "$R/n1_dA"; git clone -q -b development "$R/dest.git" "$R/n1_dB"
SNAP="$R/n1_work/measurement/thesis_compiles"
for w in A B; do
  ( E18_FIXED_TS=$TS lauf AF_DEST_REPO="$R/n1_d$w" AF_WORK_ROOT="$R/n1_work" AF_SNAPSHOT_ROOT="$SNAP" \
      AF_SNAP_LAUF_KENNUNG="r9-j100$w" AF_TMP="$(mktemp -d)" AF_NO_PUSH=true > "$H/n1_$w.log" ) &
done
wait
pruef "beide Belege entstanden (2 Ordner)" "$(snapdirs "$SNAP" | wc -l)" "2"
pruef "Name traegt Runner/Job-Kennung A" "$([ -d "$SNAP/$TS-r9-j100A" ] && echo ja || echo nein)" "ja"
pruef "Name traegt Runner/Job-Kennung B" "$([ -d "$SNAP/$TS-r9-j100B" ] && echo ja || echo nein)" "ja"
hatnicht "$H/n1_A.log" "naechstes Suffix" "A brauchte KEIN Kollisions-Suffix (Namen sind schon disjunkt)"
hatnicht "$H/n1_B.log" "naechstes Suffix" "B brauchte KEIN Kollisions-Suffix"
# GEGENPROBE ALT: gleiche Sekunde, getrennte Dateisysteme -> ALT waehlt ZWEIMAL denselben Namen.
git clone -q -b development "$R/super.git" "$R/n1_altA"; git clone -q -b development "$R/super.git" "$R/n1_altB"
neue_tabellen "$R/n1_altA" "NB2-1a alt"; neue_tabellen "$R/n1_altB" "NB2-1a alt"
git clone -q -b development "$R/dest.git" "$R/n1_dAltA"; git clone -q -b development "$R/dest.git" "$R/n1_dAltB"
for w in A B; do
  E18_FIXED_TS=$TS lauf_alt AF_DEST_REPO="$R/n1_dAlt$w" AF_WORK_ROOT="$R/n1_alt$w" AF_NO_PUSH=true > "$H/n1_alt$w.log"
done
_n1_beide=nein
if [ -d "$R/n1_altA/measurement/thesis_compiles/$TS" ] \
   && [ -d "$R/n1_altB/measurement/thesis_compiles/$TS" ]; then
  _n1_beide=ja
fi
pruef "ALT: getrennte Runner waehlen denselben Ordnernamen" "$_n1_beide" "ja"
echo "   (genau daraus wurde beim 288-Merge ein add/add-Konflikt = verlorener Beleg -- Codex HOCH-2)"

kopf "NB2-1b  Gurt bleibt: bei ERZWUNGEN gleicher Kennung waechst weiterhin ein Suffix"
git clone -q -b development "$R/super.git" "$R/n1b_work"; neue_tabellen "$R/n1b_work" "NB2-1b"
git clone -q -b development "$R/dest.git" "$R/n1b_d1"; git clone -q -b development "$R/dest.git" "$R/n1b_d2"
E18_FIXED_TS=$TS lauf AF_DEST_REPO="$R/n1b_d1" AF_WORK_ROOT="$R/n1b_work" AF_SNAP_LAUF_KENNUNG="r1-j1" AF_NO_PUSH=true \
    > "$H/n1b_1.log"
E18_FIXED_TS=$TS lauf AF_DEST_REPO="$R/n1b_d2" AF_WORK_ROOT="$R/n1b_work" AF_SNAP_LAUF_KENNUNG="r1-j1" AF_NO_PUSH=true \
    > "$H/n1b_2.log"
pruef "erster Ordner" "$([ -d "$R/n1b_work/measurement/thesis_compiles/$TS-r1-j1" ] && echo ja || echo nein)" "ja"
pruef "zweiter Ordner mit Suffix -2" \
    "$([ -d "$R/n1b_work/measurement/thesis_compiles/$TS-r1-j1-2" ] && echo ja || echo nein)" "ja"
hat "$H/n1b_2.log" "existiert LOKAL -> naechstes Suffix" "Kollisions-Gurt greift literal"

kopf "NB2-1c  mkdir-FEHLERART: echter Dateisystem-Fehler ist FATAL, nicht 99 Kollisions-Retries"
git clone -q -b development "$R/super.git" "$R/n1c_work"; neue_tabellen "$R/n1c_work" "NB2-1c"
git clone -q -b development "$R/dest.git" "$R/n1c_d"; git clone -q -b development "$R/dest.git" "$R/n1c_d_alt"
env PATH="$H/bin_mkdirfail:$PATH" AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=on \
    AF_PROV_SUPER_REF=development AF_NO_PUSH=true AF_DEST_REPO="$R/n1c_d" AF_WORK_ROOT="$R/n1c_work" \
    "$CORE" > "$H/n1c_neu.log" 2>&1
pruef "NEU: RC bei echtem mkdir-Fehler" "$?" "1"
hat "$H/n1c_neu.log" "KEINE Kollision, sondern ein echter" "NEU nennt die Fehlerart literal"
hat "$H/n1c_neu.log" "Permission denied (PROBEN-SHIM)" "NEU druckt die ORIGINAL-mkdir-Meldung"
pruef "NEU dreht KEINE 99 Runden" "$(grep -c 'naechstes Suffix' "$H/n1c_neu.log")" "0"
# ALT legt den ENDordner direkt an (kein .tmp) -- der Gegen-Shim trifft darum genau diesen Namen.
mkdir -p "$H/bin_mkdirfail_alt"
cat > "$H/bin_mkdirfail_alt/mkdir" <<'EOF'
#!/bin/sh
for a in "$@"; do last="$a"; done
case "$last" in */thesis_compiles/2*)
  echo "mkdir: cannot create directory '$last': Permission denied (PROBEN-SHIM)" >&2
  exit 1 ;;
esac
exec /bin/mkdir "$@"
EOF
chmod +x "$H/bin_mkdirfail_alt/mkdir"
env PATH="$H/bin_mkdirfail_alt:$PATH" AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=on \
    AF_PROV_SUPER_REF=development AF_NO_PUSH=true AF_DEST_REPO="$R/n1c_d_alt" AF_WORK_ROOT="$R/n1c_work" \
    "$H/core_alt.sh" > "$H/n1c_alt.log" 2>&1
pruef "ALT deutet denselben Fehler als Kollision (99 Runden)" "$(grep -c 'mkdir-Lock verloren' "$H/n1c_alt.log")" "99"
hat "$H/n1c_alt.log" "98 Kollisions-Suffixe sind belegt" "ALT meldet am Ende eine FALSCHE Ursache"

# ============================================================ (2) RECOVERY-IDENTITAET
kopf "NB2-2a  Marker im 288-Baum: Beleg fuer die URSPRUENGLICH gepushte SHA, nicht fuer den neuen HEAD"
# Hergang (praeparierter Fehlerfall): Lauf A pusht 289 (SHA_A) und stirbt, NACHDEM sein
# 288-Writeback die Recovery-Identitaet gelandet hat, aber BEVOR der Beleg entstanden ist.
# Danach landet ein FREMDER 289-Commit (HEAD wandert auf SHA_B). Der Retry darf jetzt NICHT
# einfach den neuen HEAD belegen -- SHA_A bliebe sonst fuer immer unbelegt.
git clone -q -b development "$R/super.git" "$R/n2_wA"; neue_tabellen "$R/n2_wA" "NB2-2a"
git clone -q -b development "$R/dest.git" "$R/n2_dA"
lauf AF_DEST_REPO="$R/n2_dA" AF_WORK_ROOT="$R/n2_wA" AF_SNAP_LAUF_KENNUNG="r5-j500" > "$H/n2_laufA.log"
SHA_A="$(git -C "$R/dest.git" rev-parse development)"
hat "$H/n2_laufA.log" "Recovery-Identitaet abgelegt" "Lauf A legt die Recovery-Identitaet VOR dem Push ab"
pruef "Marker nennt die gepushte SHA" \
  "$(sed -n 's/^pending_thesis_commit_sha=//p' "$R/n2_wA/measurement/thesis_compiles/PENDING-r5-j500.txt")" "$SHA_A"
# Der Writeback landet NUR den Marker (der Beleg existierte in diesem Moment noch nicht).
rm -rf "$R/n2_wA/measurement/thesis_compiles/"2*    # Beleg-Ordner: mit dem Workspace gestorben
sed -i '/^erfuellt_durch=/d;/^erfuellt_utc=/d' "$R/n2_wA/measurement/thesis_compiles/PENDING-r5-j500.txt"
git -C "$R/n2_wA" add -A -- measurement >/dev/null
git -C "$R/n2_wA" -c user.name=f -c user.email=f@l commit -q -m "288-Writeback: nur die Recovery-Identitaet"
git -C "$R/n2_wA" push -q origin development
# FREMDER 289-Commit -> der HEAD ist nicht mehr SHA_A
git clone -q -b development "$R/dest.git" "$R/n2_fremd"
printf '%% fremde Zeile\n' >> "$R/n2_fremd/diplomarbeit.tex"
git -C "$R/n2_fremd" -c user.name=f -c user.email=f@l commit -q -am "Y: fremder 289-Commit"
git -C "$R/n2_fremd" push -q origin development
SHA_B="$(git -C "$R/dest.git" rev-parse development)"
echo "   SHA_A (Lauf A, unbelegt) = $SHA_A"
echo "   SHA_B (fremder HEAD)     = $SHA_B"
git clone -q -b development "$R/super.git" "$R/n2_wRetry"; neue_tabellen "$R/n2_wRetry" "NB2-2a"
git clone -q -b development "$R/dest.git" "$R/n2_dRetry"
lauf AF_DEST_REPO="$R/n2_dRetry" AF_WORK_ROOT="$R/n2_wRetry" AF_SNAP_LAUF_KENNUNG="r5-j501" > "$H/n2_retry.log"
Q="$(find "$R/n2_wRetry/measurement/thesis_compiles" -name QUELLSTAND.txt | head -1)"
pruef "NEU: genau EIN Beleg nachgeholt" \
    "$(find "$R/n2_wRetry/measurement/thesis_compiles" -name QUELLSTAND.txt | wc -l)" "1"
pruef "NEU: Beleg zeigt auf SHA_A (Recovery-Identitaet)" "$(sed -n 's/^thesis_commit_sha=//p' "$Q")" "$SHA_A"
pruef "NEU: Modus ehrlich" "$(sed -n 's/^modus=//p' "$Q")" "recovery"
hat "$H/n2_retry.log" "RECOVERY-ZIEL: $SHA_A" "Recovery-Ziel literal benannt"
hat "$H/n2_retry.log" "289-Klon nachweislich zurueck auf $SHA_B" \
    "289-Klon steht wieder auf dem BRANCH-HEAD (Gitlink-Schutz)"
pruef "NEU: 289 hat KEINEN neuen Commit bekommen" "$(git -C "$R/dest.git" rev-parse development)" "$SHA_B"
# GEGENPROBE ALT auf EXAKT demselben Zustand
git clone -q -b development "$R/super.git" "$R/n2_wAlt"; neue_tabellen "$R/n2_wAlt" "NB2-2a"
git clone -q -b development "$R/dest.git" "$R/n2_dAlt"
lauf_alt AF_DEST_REPO="$R/n2_dAlt" AF_WORK_ROOT="$R/n2_wAlt" > "$H/n2_alt.log"
QA="$(find "$R/n2_wAlt/measurement/thesis_compiles" -name QUELLSTAND.txt | head -1)"
pruef "ALT belegt den NEUEN HEAD statt der schuldigen SHA" "$(sed -n 's/^thesis_commit_sha=//p' "$QA")" "$SHA_B"
echo "   -> ALT laesst $SHA_A dauerhaft unbelegt (genau der Codex-Rest von HOCH-1)"

kopf "NB2-2b  Ohne Marker: die BOT-HISTORIE in 289 traegt die Recovery-Identitaet"
# Reiner Runner-Tod: nicht einmal der Marker hat es in das 288-Repo geschafft. Dafuer bekommt der
# Lauf eine JUNGFRAEULICHE Schnappschuss-Wurzel -- weder lokal noch remote liegt dort irgendetwas.
git clone -q -b development "$R/super.git" "$R/n2b_w"
git clone -q -b development "$R/dest.git" "$R/n2b_d"
tabellen_wie_branch "$R/n2b_w" "$R/n2b_d"       # 0 Anhang-Delta -> es zaehlt allein die Beleg-Frage
N2B_ROOT="$R/n2b_w/measurement/beleg_wurzel_2b"
pruef "Wurzel ohne jeden Marker" "$(find "$N2B_ROOT" -name 'PENDING-*.txt' 2>/dev/null | wc -l)" "0"
pruef "Wurzel ohne jeden Beleg"  "$(find "$N2B_ROOT" -name QUELLSTAND.txt 2>/dev/null | wc -l)" "0"
lauf AF_DEST_REPO="$R/n2b_d" AF_WORK_ROOT="$R/n2b_w" AF_SNAPSHOT_ROOT="$N2B_ROOT" \
     AF_SNAP_LAUF_KENNUNG="r5-j502" > "$H/n2b.log"
QB="$(find "$N2B_ROOT" -name QUELLSTAND.txt | head -1)"
pruef "NEU: Beleg fuer SHA_A (aus der Bot-Historie, ohne jeden Marker)" "$(sed -n 's/^thesis_commit_sha=//p' "$QB")" \
    "$SHA_A"
hat "$H/n2b.log" "RECOVERY-ZIEL: $SHA_A" "Bot-Historie liefert dieselbe Identitaet ohne jeden Marker"

kopf "NB2-2c  Marker auf eine NIE gelandete SHA -> literal uebersprungen, kein Luegen-Beleg"
git clone -q -b development "$R/super.git" "$R/n2c_w"
git clone -q -b development "$R/dest.git" "$R/n2c_d"
tabellen_wie_branch "$R/n2c_w" "$R/n2c_d"
N2C_ROOT="$R/n2c_w/measurement/beleg_wurzel_2c"; mkdir -p "$N2C_ROOT"
printf 'pending_thesis_commit_sha=%s\n' "0000000000000000000000000000000000000000" \
  > "$N2C_ROOT/PENDING-r0-j0.txt"
lauf AF_DEST_REPO="$R/n2c_d" AF_WORK_ROOT="$R/n2c_w" AF_SNAPSHOT_ROOT="$N2C_ROOT" \
     AF_SNAP_LAUF_KENNUNG="r5-j503" > "$H/n2c.log"
hat "$H/n2c.log" "ist NICHT auf development erreichbar -> uebersprungen" "nie gelandete SHA wird literal verworfen"
pruef "kein Beleg auf die Phantom-SHA" \
  "$(grep -rl '^thesis_commit_sha=0000000000000000000000000000000000000000$' "$N2C_ROOT" 2>/dev/null | wc -l)" "0"

# ============================================================ (3) BELEG-VALIDATOR
# Alle Validator-Proben laufen mit AF_RECOVER_MAX=0: gefragt ist hier AUSSCHLIESSLICH, ob der
# Beleg zum 289-HEAD als gueltig gilt -- die Recovery-Kandidaten (2) sind eine andere Frage und
# wuerden das Bild verwischen (der Fixture-289 traegt aus frueheren Proben unbelegte Bot-Commits).
val_lauf() { lauf AF_RECOVER_MAX=0 "$@"; }

halber_beleg() { # $1 = Ordner, $2 = SHA, $3 = "ohne-export" | "sha-bruch" | "zu-lange-sha"
  mkdir -p "$1"; printf 'PDF-INHALT\n' > "$1/diplomarbeit.pdf"
  local sha256; sha256="$(sha256sum < "$1/diplomarbeit.pdf" | cut -d' ' -f1)"
  [ "$3" = "ohne-export" ] || printf 'log\n' > "$1/compile-export.txt"
  [ "$3" = "sha-bruch" ] && sha256="0000000000000000000000000000000000000000000000000000000000000000"
  local shazeile="thesis_commit_sha=$2"
  [ "$3" = "zu-lange-sha" ] && shazeile="thesis_commit_sha=${2}deadbeef"
  { echo "$shazeile"; echo "super_commit_sha=NA"; echo "kanal_lauf_id=NA"
    echo "pdf_datei=diplomarbeit.pdf"; echo "pdf_sha256=$sha256"
    echo "compile_export=compile-export.txt"; } > "$1/QUELLSTAND.txt"
}
# Baut den Praeparat-Stand: 288-Klon + 289-Klon + 0 Delta + eine jungfraeuliche Beleg-Wurzel.
val_stand() { # $1 = Marke -> setzt VW/VD/VROOT/VSHA
  git clone -q -b development "$R/super.git" "$R/v_${1}_w"
  git clone -q -b development "$R/dest.git"  "$R/v_${1}_d"
  tabellen_wie_branch "$R/v_${1}_w" "$R/v_${1}_d"
  VW="$R/v_${1}_w"; VD="$R/v_${1}_d"; VROOT="$VW/measurement/beleg_wurzel_$1"
  VSHA="$(git -C "$VD" rev-parse HEAD)"
  mkdir -p "$VROOT"
}

kopf "NB2-3a  HALBER Ordner gilt NIE als Beleg (fehlender compile-export)"
val_stand 3a
halber_beleg "$VROOT/20260807-110000-rX-jX" "$VSHA" ohne-export
cp -r "$VW" "$R/v_3a_w_alt"
val_lauf AF_DEST_REPO="$VD" AF_WORK_ROOT="$VW" AF_SNAPSHOT_ROOT="$VROOT" AF_SNAP_LAUF_KENNUNG="r6-j600" > \
    "$H/n3_neu.log"
hat "$H/n3_neu.log" "ist aber KEIN gueltiger Beleg" "NEU benennt den Halb-Ordner literal"
hat "$H/n3_neu.log" "compile-export.txt' fehlt/leer" "NEU nennt das fehlende Pflichtstueck"
pruef "NEU holt den echten Beleg nach" "$(find "$VROOT" -name QUELLSTAND.txt | wc -l)" "2"
git clone -q -b development "$R/dest.git" "$R/v_3a_d_alt"
lauf_alt AF_DEST_REPO="$R/v_3a_d_alt" AF_WORK_ROOT="$R/v_3a_w_alt" \
         AF_SNAPSHOT_ROOT="$R/v_3a_w_alt/measurement/beleg_wurzel_3a" > "$H/n3_alt.log"
hat "$H/n3_alt.log" "Beleg LOKAL vorhanden" "ALT nimmt den HALBEN Ordner als Beleg"
pruef "ALT holt NICHTS nach" "$(find "$R/v_3a_w_alt/measurement/beleg_wurzel_3a" -name QUELLSTAND.txt | wc -l)" "1"

kopf "NB2-3b  Teiltreffer statt ganzer Zeile: laengere SHA im QUELLSTAND ist KEIN Beleg"
val_stand 3b
halber_beleg "$VROOT/20260807-120000-rY-jY" "$VSHA" zu-lange-sha
cp -r "$VW" "$R/v_3b_w_alt"
val_lauf AF_DEST_REPO="$VD" AF_WORK_ROOT="$VW" AF_SNAPSHOT_ROOT="$VROOT" AF_SNAP_LAUF_KENNUNG="r6-j601" > \
    "$H/n3b_neu.log"
pruef "NEU laesst sich vom Teiltreffer NICHT taeuschen (Beleg wird gebaut)" \
  "$(find "$VROOT" -name QUELLSTAND.txt | wc -l)" "2"
git clone -q -b development "$R/dest.git" "$R/v_3b_d_alt"
lauf_alt AF_DEST_REPO="$R/v_3b_d_alt" AF_WORK_ROOT="$R/v_3b_w_alt" \
         AF_SNAPSHOT_ROOT="$R/v_3b_w_alt/measurement/beleg_wurzel_3b" > "$H/n3b_alt.log"
hat "$H/n3b_alt.log" "Beleg LOKAL vorhanden" "ALT nimmt den TEILTREFFER als Beleg (grep -F ohne Zeilenanker)"

kopf "NB2-3c  sha256-Bruch: PDF passt nicht zum QUELLSTAND -> KEIN Beleg"
val_stand 3c
halber_beleg "$VROOT/20260807-130000-rZ-jZ" "$VSHA" sha-bruch
cp -r "$VW" "$R/v_3c_w_alt"
val_lauf AF_DEST_REPO="$VD" AF_WORK_ROOT="$VW" AF_SNAPSHOT_ROOT="$VROOT" AF_SNAP_LAUF_KENNUNG="r6-j602" > "$H/n3c.log"
hat "$H/n3c.log" "sha256-Bruch in" "NEU erkennt den sha256-Bruch und verwirft den Ordner als Beleg"
pruef "NEU legt einen zweiten, gueltigen Beleg an" "$(find "$VROOT" -name QUELLSTAND.txt | wc -l)" "2"
git clone -q -b development "$R/dest.git" "$R/v_3c_d_alt"
lauf_alt AF_DEST_REPO="$R/v_3c_d_alt" AF_WORK_ROOT="$R/v_3c_w_alt" \
         AF_SNAPSHOT_ROOT="$R/v_3c_w_alt/measurement/beleg_wurzel_3c" > "$H/n3c_alt.log"
hat "$H/n3c_alt.log" "Beleg LOKAL vorhanden" "ALT prueft den Hash gar nicht erst"

kopf "NB2-3d  REMOTE-Suche NUR in QUELLSTAND.txt-Pfaden (Fremddatei mit derselben Zeile taeuscht nicht)"
val_stand 3d
# Der Beleg liegt REMOTE -- und zwar in einer Datei, die KEIN QUELLSTAND ist.
git clone -q -b development "$R/super.git" "$R/n3d_seed"
mkdir -p "$R/n3d_seed/measurement/beleg_wurzel_3d"
printf 'thesis_commit_sha=%s\n' "$VSHA" > "$R/n3d_seed/measurement/beleg_wurzel_3d/NOTIZ.txt"
git -C "$R/n3d_seed" add -A -- measurement >/dev/null
git -C "$R/n3d_seed" -c user.name=f -c user.email=f@l commit -q -m "fremde Notiz mit derselben Zeile"
git -C "$R/n3d_seed" push -q origin development
cp -r "$VW" "$R/v_3d_w_alt"
val_lauf AF_DEST_REPO="$VD" AF_WORK_ROOT="$VW" AF_SNAPSHOT_ROOT="$VROOT" AF_SNAP_LAUF_KENNUNG="r6-j604" > \
    "$H/n3d_neu.log"
hatnicht "$H/n3d_neu.log" "Beleg im REMOTE-Stand vorhanden" "NEU liest die Fremddatei NICHT als Beleg"
pruef "NEU holt den echten Beleg nach" "$(find "$VROOT" -name QUELLSTAND.txt | wc -l)" "1"
git clone -q -b development "$R/dest.git" "$R/v_3d_d_alt"
lauf_alt AF_DEST_REPO="$R/v_3d_d_alt" AF_WORK_ROOT="$R/v_3d_w_alt" \
         AF_SNAPSHOT_ROOT="$R/v_3d_w_alt/measurement/beleg_wurzel_3d" > "$H/n3d_alt.log"
hat "$H/n3d_alt.log" "Beleg im REMOTE-Stand vorhanden" \
    "ALT nimmt die Fremddatei als Beleg (git grep ueber ALLE Dateien)"

# ============================================================ (4) ERZWUNGENE RE-KOMPILATION
kopf "NB2-4a  Re-Fixierung nach non-FF: Bau ist erzwungen frisch und wird belegt"
git clone -q -b development "$R/dest.git" "$R/n4_d"
git clone -q -b development "$R/dest.git" "$R/n4_fremd"
perl -0pi -e 's|\\end\{document\}|\\typeout{FREMDZUSATZ-NB2}\n\\end{document}|' "$R/n4_fremd/diplomarbeit.tex"
git -C "$R/n4_fremd" -c user.name=f -c user.email=f@l commit -q -am "Y: fremder Thesis-Commit"
git -C "$R/n4_fremd" push -q origin development
git clone -q -b development "$R/super.git" "$R/n4_w"; neue_tabellen "$R/n4_w" "NB2-4a"
rm -rf "$R/n4_w/measurement/thesis_compiles/2"*
lauf AF_DEST_REPO="$R/n4_d" AF_WORK_ROOT="$R/n4_w" AF_SNAP_LAUF_KENNUNG="r7-j700" AF_PUSH_RETRIES=3 > "$H/n4_neu.log"
hat "$H/n4_neu.log" "RE-ERNTE" "Divergenz erkannt"
hat "$H/n4_neu.log" "ERZWUNGENE Re-Kompilation" "Re-Ernte laeuft mit -gg und geloeschten Bau-Produkten"
hat "$H/n4_neu.log" "Neuheits-Wache" "die neu gebaute PDF ist nachweislich juenger als der Bau-Beginn"
QN="$(find "$R/n4_w/measurement/thesis_compiles" -name QUELLSTAND.txt | head -1)"
pruef "Beleg zeigt auf die BRANCH-SPITZE" "$(sed -n 's/^thesis_commit_sha=//p' "$QN")" \
    "$(git -C "$R/dest.git" rev-parse development)"
pruef "compile-export stammt aus dem GEMERGTEN Baum" "$(grep -c 'FREMDZUSATZ-NB2' "$(dirname \
    "$QN")/compile-export.txt")" "1"

kopf "NB2-4b  'Nothing to do' darf NIE eine alte PDF mit neuer SHA beschriften"
git clone -q -b development "$R/dest.git" "$R/n4b_d"
git clone -q -b development "$R/dest.git" "$R/n4b_fremd"
perl -0pi -e 's|\\end\{document\}|\\typeout{FREMDZUSATZ-NB2B}\n\\end{document}|' "$R/n4b_fremd/diplomarbeit.tex"
git -C "$R/n4b_fremd" -c user.name=f -c user.email=f@l commit -q -am "Y2"
git -C "$R/n4b_fremd" push -q origin development
git clone -q -b development "$R/super.git" "$R/n4b_w"; neue_tabellen "$R/n4b_w" "NB2-4b"
rm -rf "$R/n4b_w/measurement/thesis_compiles/2"*
# Der Shim greift ERST bei der Re-Ernte, weil der erste Bau (vor dem Push) mit echtem latexmk
# laeuft: dazu wird der Shim ueber eine Datei scharf geschaltet, die der erste Bau erzeugt.
cat > "$H/bin_nothingtodo/latexmk" <<'EOF'
#!/bin/sh
if [ -e /tmp/e18snap-nb2/scharf ]; then
  echo "Latexmk: Nothing to do for '$*'."
  for a in "$@"; do last="$a"; done
  out="${last%.tex}.pdf"
  printf 'ALTE-PDF-AUS-EINEM-FRUEHEREN-BAU\n' > "$out"
  touch -d '2020-01-01 00:00:00' "$out"
  exit 0
fi
: > /tmp/e18snap-nb2/scharf
exec /usr/local/texlive/2026/bin/x86_64-linux/latexmk "$@"
EOF
chmod +x "$H/bin_nothingtodo/latexmk"; rm -f "$H/scharf"
env PATH="$H/bin_nothingtodo:$PATH" AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=on \
    AF_PROV_SUPER_REF=development AF_PUSH_RETRIES=3 AF_SNAP_LAUF_KENNUNG="r7-j701" \
    AF_DEST_REPO="$R/n4b_d" AF_WORK_ROOT="$R/n4b_w" "$CORE" > "$H/n4b_neu.log" 2>&1
pruef "NEU: RC bei 'Nothing to do' in der Re-Ernte" "$?" "1"
hat "$H/n4b_neu.log" "NICHT neu erzeugt" "NEU faengt den 'Nothing to do'-Fall literal"
pruef "NEU legt KEINEN Beleg ab" "$(find "$R/n4b_w/measurement/thesis_compiles" -name QUELLSTAND.txt | wc -l)" "0"
hat "$H/n4b_neu.log" "Recovery-Identitaet steht in" "NEU verweist auf die Recovery-Identitaet fuer den naechsten Lauf"
# GEGENPROBE ALT auf demselben Praeparat
git clone -q -b development "$R/dest.git" "$R/n4b_d_alt"
git clone -q -b development "$R/dest.git" "$R/n4b_fremd2"
perl -0pi -e 's|\\end\{document\}|\\typeout{FREMDZUSATZ-NB2C}\n\\end{document}|' "$R/n4b_fremd2/diplomarbeit.tex"
git -C "$R/n4b_fremd2" -c user.name=f -c user.email=f@l commit -q -am "Y3"
git -C "$R/n4b_fremd2" push -q origin development
git clone -q -b development "$R/super.git" "$R/n4b_w_alt"; neue_tabellen "$R/n4b_w_alt" "NB2-4b alt"
rm -rf "$R/n4b_w_alt/measurement/thesis_compiles/2"* ; rm -f "$H/scharf"
env PATH="$H/bin_nothingtodo:$PATH" AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=on \
    AF_PROV_SUPER_REF=development AF_PUSH_RETRIES=3 \
    AF_DEST_REPO="$R/n4b_d_alt" AF_WORK_ROOT="$R/n4b_w_alt" "$H/core_alt.sh" > "$H/n4b_alt.log" 2>&1
QAB="$(find "$R/n4b_w_alt/measurement/thesis_compiles" -name QUELLSTAND.txt | head -1)"
if [ -n "$QAB" ] && grep -q 'ALTE-PDF-AUS-EINEM-FRUEHEREN-BAU' "$(dirname "$QAB")/diplomarbeit.pdf" 2>/dev/null; then
  ok "ALT beschriftet die ALTE PDF mit der NEUEN SHA (genau der Codex-HOCH-3-Rest)"
else
  nok "ALT-Gegenprobe: erwartet war ein Beleg mit der alten PDF"
fi

# ============================================================ (5) TRANSAKTIONALES CLEANUP
kopf "NB2-5a  Schreibfehler MITTEN im Ordner: kein Endname, kein .tmp-Rest"
git clone -q -b development "$R/super.git" "$R/n5_w"; neue_tabellen "$R/n5_w" "NB2-5a"
git clone -q -b development "$R/dest.git" "$R/n5_d"
env PATH="$H/bin_cptmpfail:$PATH" AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=on \
    AF_PROV_SUPER_REF=development AF_NO_PUSH=true AF_SNAP_LAUF_KENNUNG="r8-j800" \
    AF_DEST_REPO="$R/n5_d" AF_WORK_ROOT="$R/n5_w" "$CORE" > "$H/n5_neu.log" 2>&1
pruef "NEU: RC bei Transaktions-Bruch" "$?" "1"
pruef "NEU: KEIN Ordner unter dem Endnamen" "$(snapdirs "$R/n5_w/measurement/thesis_compiles" | wc -l)" "0"
pruef "NEU: KEIN .tmp-Rest" "$(find "$R/n5_w/measurement/thesis_compiles" -maxdepth 1 -name '.*.tmp' | wc -l)" "0"
hat "$H/n5_neu.log" "eigener unveroeffentlichter Rest aufgeraeumt" "trap-Cleanup meldet sich literal"
# GEGENPROBE ALT: derselbe Fehler laesst einen HALBEN Ordner unter dem ENDNAMEN stehen
git clone -q -b development "$R/super.git" "$R/n5_w_alt"; neue_tabellen "$R/n5_w_alt" "NB2-5a alt"
git clone -q -b development "$R/dest.git" "$R/n5_d_alt"
cat > "$H/bin_cptmpfail/cp2" <<'EOF'
placeholder
EOF
env PATH="$H/bin_cpaltfail:$PATH" true 2>/dev/null || true
mkdir -p "$H/bin_cpaltfail"
cat > "$H/bin_cpaltfail/cp" <<'EOF'
#!/bin/sh
# ALT schreibt direkt in den ENDordner (kein .tmp) -- der Shim bricht dort ab.
for a in "$@"; do last="$a"; done
case "$last" in */thesis_compiles/2*/compile-export.txt) echo "cp: PROBEN-SHIM erzwingt Fehlschlag" >&2; exit 1 ;; esac
exec /bin/cp "$@"
EOF
chmod +x "$H/bin_cpaltfail/cp"
env PATH="$H/bin_cpaltfail:$PATH" AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=on \
    AF_PROV_SUPER_REF=development AF_NO_PUSH=true \
    AF_DEST_REPO="$R/n5_d_alt" AF_WORK_ROOT="$R/n5_w_alt" "$H/core_alt.sh" > "$H/n5_alt.log" 2>&1
pruef "ALT hinterlaesst einen halben Ordner unter dem ENDNAMEN" \
  "$(snapdirs "$R/n5_w_alt/measurement/thesis_compiles" | wc -l)" "1"

kopf "NB2-5b  Remote-Fehler ist FAIL-CLOSED (frueher galt er als 'Pfad frei')"
git clone -q -b development "$R/super.git" "$R/n5b_w"; neue_tabellen "$R/n5b_w" "NB2-5b"
git clone -q -b development "$R/dest.git" "$R/n5b_d"
env PATH="$H/bin_lstreefail:$PATH" AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=on \
    AF_PROV_SUPER_REF=development AF_NO_PUSH=true AF_SNAP_LAUF_KENNUNG="r8-j801" \
    AF_DEST_REPO="$R/n5b_d" AF_WORK_ROOT="$R/n5b_w" "$CORE" > "$H/n5b.log" 2>&1
pruef "NEU: RC bei kaputtem Remote-Blick" "$?" "1"
hat "$H/n5b.log" "FAIL-CLOSED" "Remote-Fehler bricht LAUT ab statt 'frei' anzunehmen"
pruef "NEU legt nichts ab" "$(find "$R/n5b_w/measurement/thesis_compiles" -name QUELLSTAND.txt 2>/dev/null | wc -l)" "0"

kopf "NB2-5c  AF_SNAPSHOT_ROOT-Vertrag: vier Verstoesse, vier laute Abbrueche"
git clone -q -b development "$R/super.git" "$R/n5c_w"; neue_tabellen "$R/n5c_w" "NB2-5c"
vertrag() { # $1 = Marke, $2 = Wurzel, $3 = erwarteter Textbaustein
  git clone -q -b development "$R/dest.git" "$R/n5c_d_$1"
  lauf AF_DEST_REPO="$R/n5c_d_$1" AF_WORK_ROOT="$R/n5c_w" AF_SNAPSHOT_ROOT="$2" AF_NO_PUSH=true \
       AF_SNAP_LAUF_KENNUNG="r8-j81$1" > "$H/n5c_$1.log" 2>&1
  local rc=$?
  pruef "Vertrag '$1': RC" "$rc" "1"
  hat "$H/n5c_$1.log" "$3" "Vertrag '$1' literal benannt"
}
vertrag 1 "/tmp/e18snap-nb2-ausserhalb/beleg" "liegt in KEINEM git-Arbeitsbaum"
vertrag 2 "$R/n5c_w"                          "IST das Toplevel des Arbeitsbaums"
vertrag 3 "$R/dest/measurement_fremd"         "NICHT der 288-Baum des Writebacks"
vertrag 4 "$R/n5c_w/build/beleg"              "wird von .gitignore IGNORIERT"
rm -rf /tmp/e18snap-nb2-labor        # Labor-Wurzel liegt ausserhalb des Fixtures -> selbst raeumen
git clone -q -b development "$R/dest.git" "$R/n5c_d_off"
lauf AF_DEST_REPO="$R/n5c_d_off" AF_WORK_ROOT="$R/n5c_w" AF_SNAPSHOT_ROOT="/tmp/e18snap-nb2-labor/beleg" \
     AF_SNAP_ROOT_STRICT=false AF_NO_PUSH=true AF_SNAP_LAUF_KENNUNG="r8-j819" > "$H/n5c_off.log" 2>&1
pruef "STRICT=false: RC" "$?" "0"
hat "$H/n5c_off.log" "Verstoss BEWUSST hingenommen" "Labor-Abschaltung sagt es literal"
pruef "STRICT=false: Beleg entsteht trotzdem" "$(find /tmp/e18snap-nb2-labor/beleg -name QUELLSTAND.txt | wc -l)" "1"

# ============================================================ MITTEL-RESTBEFUNDE
kopf "MITTEL  AF_LANGS: '|' verboten, Duplikate entfernt"
git clone -q -b development "$R/super.git" "$R/m_w"; neue_tabellen "$R/m_w" "MITTEL"
git clone -q -b development "$R/dest.git" "$R/m_d1"
lauf AF_DEST_REPO="$R/m_d1" AF_WORK_ROOT="$R/m_w" AF_LANGS='de|x,en' AF_NO_PUSH=true > "$H/m_pipe.log" 2>&1
pruef "'|' in AF_LANGS: RC" "$?" "1"
hat "$H/m_pipe.log" "Feldtrenner der Rollback-Buchfuehrung" "Grund literal benannt"
git clone -q -b development "$R/dest.git" "$R/m_d2"
lauf AF_DEST_REPO="$R/m_d2" AF_WORK_ROOT="$R/m_w" AF_LANGS='de,de,en,en' AF_NO_PUSH=true \
     AF_SNAP_LAUF_KENNUNG="r9-j900" > "$H/m_dup.log" 2>&1
pruef "Duplikate: RC" "$?" "0"
hat "$H/m_dup.log" "AF_LANGS-Duplikat 'de' entfernt" "Duplikat literal entfernt"
pruef "Duplikate aendern die Buchfuehrung nicht" "$(grep -c '^   kopiert gesamt: 2 .tex' "$H/m_dup.log")" "1"

kopf "MITTEL  Leerer 289-SHA im AF_NO_PUSH-Pfad ist FATAL (frueher: 'thesis_commit_sha=')"
git clone -q -b development "$R/super.git" "$R/m2_w"; neue_tabellen "$R/m2_w" "MITTEL-2"
git clone -q -b development "$R/dest.git" "$R/m2_d"; git clone -q -b development "$R/dest.git" "$R/m2_d_alt"
rm -f "$H/revparse.cnt"
env PATH="$H/bin_leerhead:$PATH" E18_LEER_REVPARSE_AB=2 AF_ARTIFACT_ROOTS="Code/measure_out/appendix" \
    AF_PDF_GATE=on AF_PROV_SUPER_REF=development AF_NO_PUSH=true AF_SNAP_LAUF_KENNUNG="r9-j901" \
    AF_DEST_REPO="$R/m2_d" AF_WORK_ROOT="$R/m2_w" "$CORE" > "$H/m2_neu.log" 2>&1
pruef "NEU: RC bei leerem HEAD" "$?" "1"
hat "$H/m2_neu.log" "nicht aufloesbar" "NEU bricht mit literalem Grund ab"
pruef "NEU legt keinen Beleg ab" \
    "$(find "$R/m2_w/measurement/thesis_compiles" -name QUELLSTAND.txt 2>/dev/null | wc -l)" "0"
rm -f "$H/revparse.cnt"
env PATH="$H/bin_leerhead:$PATH" E18_LEER_REVPARSE_AB=2 AF_ARTIFACT_ROOTS="Code/measure_out/appendix" \
    AF_PDF_GATE=on AF_PROV_SUPER_REF=development AF_NO_PUSH=true \
    AF_DEST_REPO="$R/m2_d_alt" AF_WORK_ROOT="$R/m2_w" AF_SNAPSHOT_ROOT="$R/m2_w/snap_alt" \
    "$H/core_alt.sh" > "$H/m2_alt.log" 2>&1
if grep -rq '^thesis_commit_sha=$' "$R/m2_w/snap_alt" 2>/dev/null; then
  ok "ALT schreibt einen Beleg mit LEERER thesis_commit_sha"
else
  nok "ALT-Gegenprobe: erwartet war 'thesis_commit_sha=' ohne Wert"
fi

kopf "MITTEL  Glob-Zeichen in der Schnappschuss-Wurzel (Pathspec-Falle)"
git clone -q -b development "$R/super.git" "$R/m3_w"; neue_tabellen "$R/m3_w" "MITTEL-3"
GLOBROOT="$R/m3_w/measurement/th[e]sis*compiles"
git clone -q -b development "$R/dest.git" "$R/m3_d"
lauf AF_DEST_REPO="$R/m3_d" AF_WORK_ROOT="$R/m3_w" AF_SNAPSHOT_ROOT="$GLOBROOT" AF_NO_PUSH=true \
     AF_SNAP_LAUF_KENNUNG="r9-j902" > "$H/m3.log" 2>&1
pruef "Glob-Wurzel: RC" "$?" "0"
pruef "Glob-Wurzel: Beleg entsteht" "$(find "$GLOBROOT" -name QUELLSTAND.txt | wc -l)" "1"
hat "$H/m3.log" "E-18-SNAP-VERTRAG: erfuellt" "Vertrag auch bei Glob-Zeichen sauber aufgeloest"

kopf "MITTEL  Zentraler Rollback auch bei Abbruch WAEHREND der Kopie"
git clone -q -b development "$R/super.git" "$R/m4_w"
mkdir -p "$R/m4_w/Code/measure_out/appendix/de/tabellen" "$R/m4_w/Code/measure_out/appendix/en/tabellen"
printf '%s\n' '\textbf{DE-A}\par' > "$R/m4_w/Code/measure_out/appendix/de/tabellen/A1.tex"
printf '%s\n' '\textbf{DE-B}\par' > "$R/m4_w/Code/measure_out/appendix/de/tabellen/B1.tex"
printf '%s\n' '\textbf{EN-A}\par' > "$R/m4_w/Code/measure_out/appendix/en/tabellen/A1.tex"
git clone -q -b development "$R/dest.git" "$R/m4_d"
mkdir -p "$H/bin_cpb1fail"
cat > "$H/bin_cpb1fail/cp" <<'EOF'
#!/bin/sh
for a in "$@"; do last="$a"; done
case "$last" in */anhang/de/tabellen/B1.tex) echo "cp: PROBEN-SHIM erzwingt Fehlschlag fuer B1.tex" >&2; exit 1 ;; esac
exec /bin/cp "$@"
EOF
chmod +x "$H/bin_cpb1fail/cp"
env PATH="$H/bin_cpb1fail:$PATH" AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=on \
    AF_PROV_SUPER_REF=development AF_NO_PUSH=true \
    AF_DEST_REPO="$R/m4_d" AF_WORK_ROOT="$R/m4_w" "$CORE" > "$H/m4_neu.log" 2>&1
pruef "NEU: RC bei cp-Abbruch mitten in der Kopie" "$?" "1"
hat "$H/m4_neu.log" "Rollback (cp fehlgeschlagen)" "zentraler Rollback greift auch hier"
pruef "NEU: die vorher kopierte A1.tex ist zurueckgenommen" \
  "$([ -e "$R/m4_d/anhang/de/tabellen/A1.tex" ] && echo da || echo weg)" "weg"
env PATH="$H/bin_cpb1fail:$PATH" AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=on \
    AF_PROV_SUPER_REF=development AF_NO_PUSH=true \
    AF_DEST_REPO="$R/m4_d" AF_WORK_ROOT="$R/m4_w" "$H/core_alt.sh" > "$H/m4_alt.log" 2>&1
pruef "ALT laesst die halbe Kopie im Ziel-Repo stehen" \
  "$([ -e "$R/m4_d/anhang/de/tabellen/A1.tex" ] && echo da || echo weg)" "da"
rm -f "$R/m4_d/anhang/de/tabellen/A1.tex"

kopf "REGRESSION  Grenzen unveraendert"
git clone -q -b development "$R/super.git" "$R/g_off"; neue_tabellen "$R/g_off" "gate-off"
git clone -q -b development "$R/dest.git" "$R/g_off_d"
rm -rf "$R/g_off/measurement/thesis_compiles/2"*
env AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=off AF_NO_PUSH=true \
    AF_PROV_SUPER_REF=development AF_DEST_REPO="$R/g_off_d" AF_WORK_ROOT="$R/g_off" "$CORE" > "$H/g_off.log" 2>&1
hat "$H/g_off.log" "KEIN Schnappschuss -- das PDF-Gate hat nicht gebaut" "ohne Compile kein Beleg, literal begruendet"
git clone -q -b development "$R/super.git" "$R/g_leer"; git clone -q -b development "$R/dest.git" "$R/g_leer_d"
lauf AF_DEST_REPO="$R/g_leer_d" AF_WORK_ROOT="$R/g_leer" AF_SNAPSHOT_ROOT=/tmp/e18snap-nb2-nie AF_NO_PUSH=true > \
    "$H/g_leer.log" 2>&1
hat "$H/g_leer.log" "NO-OP: keine Anhang-Quelle" "honest-empty unveraendert"
pruef "honest-empty legt keine Wurzel an" "$([ -e /tmp/e18snap-nb2-nie ] && echo ja || echo nein)" "nein"

echo
if [ "$FEHLER" -eq 0 ]; then echo "=== NB2-PROBEN GRUEN: alle Pfade belegt (0 Abweichungen) ==="; exit 0; fi
echo "=== NB2-PROBEN ROT: $FEHLER Abweichung(en) ==="; exit 1
