#!/usr/bin/env bash
# =====================================================================================
# Simulations-Proben fuer die sechs Codex-Befunde an ci/anhang_forward_core.sh +
# gitlab-ci-delta.patch. Jede Heilung hat hier ihren eigenen Pfad, und wo es geht steht
# die GEGENPROBE mit dem alten Stand daneben (vorher-kaputt / nachher-heil).
#
# AUFRUF (aus dem super-Arbeitsbaum):
#   PATH=/usr/local/texlive/2026/bin/x86_64-linux:$PATH \
#     bash docs/sessions/backups/20260806-e18-snap/fixture/proben.sh
#
# OFFENGELEGTE HILFSMITTEL (damit nichts "zufaellig" gruen aussieht):
#   * date-Shim   -- friert NUR `date -u +%Y%m%d-%H%M%S` ein, damit zwei Laeufe garantiert
#                    denselben Zeitstempel waehlen (sonst ist die Kollision nicht erzwingbar).
#   * cp-Shim     -- laesst NUR das Schreiben von compile-export.txt scheitern (simuliert
#                    volle Platte) und beweist damit die errexit-Luecke.
#   * git-Shim    -- schluckt `git remote set-url` (Token-URL) und uebersetzt `push -o ci.skip`;
#                    dadurch laeuft der LITERALE Block (4) des gepatchten Job-Scripts lokal,
#                    OHNE dass eine seiner Zeilen veraendert wird.
#   Kein Shim beruehrt die zu pruefende Logik selbst.
# =====================================================================================
set -uo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../../.." && pwd)"
CORE="$REPO/ci/anhang_forward_core.sh"
R=/tmp/e18snap-fixture
H=/tmp/e18snap-proben
FEHLER=0

ok()   { echo "   OK   : $*"; }
nok()  { echo "   FEHL : $*"; FEHLER=$((FEHLER + 1)); }
pruef(){ if [ "$2" = "$3" ]; then ok "$1 ($2)"; else nok "$1 -- erwartet '$3', ist '$2'"; fi; }
kopf() { echo; echo "=== $* ==="; }

rm -rf "$H"; mkdir -p "$H/bin" "$H/bin_cpfail"
cat > "$H/bin/date" <<'EOF'
#!/bin/sh
if [ "$1" = "-u" ] && [ "$2" = "+%Y%m%d-%H%M%S" ] && [ -n "$E18_FIXED_TS" ]; then echo "$E18_FIXED_TS"; exit 0; fi
exec /usr/bin/date "$@"
EOF
cat > "$H/bin/git" <<'EOF'
#!/bin/sh
if [ "$1" = "remote" ] && [ "$2" = "set-url" ]; then exit 0; fi
if [ "$1" = "push" ] && [ "$2" = "-o" ] && [ "$3" = "ci.skip" ]; then shift 3; exec /usr/bin/git push "$@"; fi
exec /usr/bin/git "$@"
EOF
cat > "$H/bin_cpfail/cp" <<'EOF'
#!/bin/sh
for a in "$@"; do last="$a"; done
case "$last" in *compile-export.txt) echo "cp: PROBEN-SHIM erzwingt Fehlschlag fuer '$last'" >&2; exit 1 ;; esac
exec /bin/cp "$@"
EOF
chmod +x "$H/bin/date" "$H/bin/git" "$H/bin_cpfail/cp"
export PATH="$H/bin:$PATH"
export E18_FIXED_TS=""

# ALT-Stand als Vergleichsobjekt -- die Gegenproben brauchen ihn. BEWUSST auf den Erstwurf-Commit
# GEPINNT und nicht auf HEAD: sobald die Heilung committet ist, waere HEAD der neue Stand und die
# Gegenproben verglichen neu gegen neu (stilles Falsch-Gruen). Ueberschreibbar via E18_ALT_REF.
ALT_REF="${E18_ALT_REF:-bda34e79aa8bde1960c1346a143beb3cd54956dd}"
if ! git -C "$REPO" rev-parse --verify -q "$ALT_REF^{commit}" > /dev/null; then
  echo "FEHLER: ALT-Referenz '$ALT_REF' nicht im Repo -- Gegenproben nicht fahrbar" >&2; exit 1
fi
echo "ALT-Vergleichsstand: $ALT_REF ($(git -C "$REPO" log --format=%s -1 "$ALT_REF" | cut -c1-60))"
git -C "$REPO" show "$ALT_REF:ci/anhang_forward_core.sh" > "$H/core_alt.sh" && chmod +x "$H/core_alt.sh"
git -C "$REPO" show "$ALT_REF:.gitlab-ci.yml" > "$H/alt.yml"
git -C "$REPO" show "$ALT_REF:docs/sessions/backups/20260806-e18-snap/gitlab-ci-delta.patch" > "$H/alt.patch"
( cd "$H" && mkdir -p oldyml && cp alt.yml oldyml/.gitlab-ci.yml && cd oldyml && git apply -p1 ../alt.patch )
# Beide Patch-Staende gehen gegen DIESELBE Basis-YAML (HEAD) -- so ist der Vergleich sauber.
( cd "$H" && mkdir -p newyml && cp alt.yml newyml/.gitlab-ci.yml && cd newyml \
  && git apply -p1 "$REPO/docs/sessions/backups/20260806-e18-snap/gitlab-ci-delta.patch" )
block4() {  # $1 = yml, $2 = Ziel; schneidet den Job-Script-Block und daraus Block (4)
  awk 'f==1 && /^      / {print substr($0,7); next} f==1 && /^[[:space:]]*$/ {print ""; next}
       f==1 {exit} /^    - \|$/ && seen==1 {f=1} /^anhang:forward:$/ {seen=1}' "$1" > "$2.full"
  awk '/^# -- \(4\) 288-Writeback/{f=1} f' "$2.full" > "$2"
}
block4 "$H/oldyml/.gitlab-ci.yml" "$H/wb_alt.sh"
block4 "$H/newyml/.gitlab-ci.yml" "$H/wb_neu.sh"

vorher_liste() { find "$1" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort > "$2"; }
neuer_beleg()  { comm -13 "$2" <(find "$1" -mindepth 1 -maxdepth 1 -type d | sort) | head -1; }
lauf() { # Kern-Lauf mit Standard-Fixture-Umgebung; $@ = zusaetzliche env-Zuweisungen vorweg
  env AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=on AF_PROV_SUPER_REF=development "$@" "$CORE" 2>&1
}
neue_tabellen() { # $1 = work-root, $2 = Marke
  mkdir -p "$1/Code/measure_out/appendix/de/tabellen" "$1/Code/measure_out/appendix/en/tabellen"
  printf '%s\n' "\\textbf{DE $2}\\par" > "$1/Code/measure_out/appendix/de/tabellen/T1.tex"
  printf '%s\n' "\\textbf{EN $2}\\par" > "$1/Code/measure_out/appendix/en/tabellen/T1.tex"
}
wb() { # LITERALER Block (4) des gepatchten Job-Scripts; $1 = Block-Datei, $2 = workdir
  ( cd "$2" && env CI_COMMIT_BRANCH=development CI_PIPELINE_ID=4711 COMDARE_WRITEBACK_USER=u \
      COMDARE_WRITEBACK_TOKEN=t CI_SERVER_HOST=h CI_PROJECT_PATH=p SNAP_DIR="${SNAP_DIR:-measurement/thesis_compiles}" \
      NEW_THESIS_SHA="$NEW_THESIS_SHA" bash -c "set -euo pipefail; . $1" 2>&1 )
}

bash "$(dirname "${BASH_SOURCE[0]}")/setup.sh" > /dev/null
echo "Fixture aufgebaut unter $R"

# ------------------------------------------------------------------ HOCH-1: Nachholung
kopf "HOCH-1  Beleg haengt NICHT mehr am Anhang-Byte-Delta"
# Lauf 1 und der Retry MUESSEN dieselben Quell-Tabellen sehen -- sonst gaebe es beim Retry ein
# Byte-Delta und der Nachhol-Fall waere gar nicht getroffen.
neue_tabellen "$R/work" "Lauf 1"
lauf AF_DEST_REPO="$R/dest" AF_WORK_ROOT="$R/work" > "$H/h1_lauf1.log"
SHA1=$(git -C "$R/dest.git" rev-parse development)
pruef "Lauf 1: Beleg erzeugt" "$(find "$R/work/measurement/thesis_compiles" -name QUELLSTAND.txt | wc -l)" "1"
# 288-Crash: Workspace stirbt (frischer Klon ohne Beleg), 289 ist schon gepusht -> 0 Delta
git clone -q -b development "$R/super.git" "$R/w_retry"; git clone -q -b development "$R/dest.git" "$R/d_retry"
neue_tabellen "$R/w_retry" "Lauf 1"
# erst der ALTE Kern auf exakt diesem Zustand:
env AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=on AF_PROV_SUPER_REF=development \
    AF_DEST_REPO="$R/d_retry" AF_WORK_ROOT="$R/w_retry" "$H/core_alt.sh" > "$H/h1_alt.log" 2>&1
pruef "ALT: Beleg nach Retry" "$(find "$R/w_retry/measurement" -name QUELLSTAND.txt | wc -l)" "0"
grep -q "IDEMPOTENT: 0 Aenderungen -> kein Commit" "$H/h1_alt.log" && ok \
    "ALT bricht vor dem Compile ab (Beleg dauerhaft verloren)"
lauf AF_DEST_REPO="$R/d_retry" AF_WORK_ROOT="$R/w_retry" > "$H/h1_neu.log"
pruef "NEU: Beleg nach Retry nachgeholt" "$(find "$R/w_retry/measurement" -name QUELLSTAND.txt | wc -l)" "1"
Q=$(find "$R/w_retry/measurement" -name QUELLSTAND.txt | head -1)
pruef "NEU: Beleg zeigt auf den gelandeten 289-HEAD" "$(grep '^thesis_commit_sha=' "$Q" | cut -d= -f2)" "$SHA1"
pruef "NEU: Modus ehrlich vermerkt" "$(grep '^modus=' "$Q" | cut -d= -f2)" "nachholen"
pruef "NEU: 289 hat KEINEN neuen Commit bekommen" "$(git -C "$R/dest.git" rev-parse development)" "$SHA1"
lauf AF_DEST_REPO="$R/d_retry" AF_WORK_ROOT="$R/w_retry" > "$H/h1_noop.log"
grep -q "Beleg LOKAL vorhanden" "$H/h1_noop.log" && ok "dritter Lauf ist echtes NO-OP (kein zweiter Compile)"
# REMOTE-Zweig: Beleg liegt auf origin, der Workspace steht auf einem aelteren Commit
git -C "$R/w_retry" add -A -- measurement >/dev/null
git -C "$R/w_retry" -c user.name=f -c user.email=f@l commit -q -m "Beleg gelandet"
git -C "$R/w_retry" push -q origin development
git clone -q -b development "$R/super.git" "$R/w_remote"
git -C "$R/w_remote" checkout -q "$(git -C "$R/w_remote" rev-parse HEAD~1)"
neue_tabellen "$R/w_remote" "Lauf 1"
pruef "REMOTE-Zweig: lokal KEIN Beleg sichtbar" "$(find "$R/w_remote/measurement" -name QUELLSTAND.txt | wc -l)" "0"
lauf AF_DEST_REPO="$R/d_retry" AF_WORK_ROOT="$R/w_remote" > "$H/h1_remote.log"
grep -q "Beleg im REMOTE-Stand vorhanden" "$H/h1_remote.log" && ok \
    "Beleg im REMOTE-Stand erkannt -> kein Doppel-Compile"

# ------------------------------------------------------------------ HOCH-2: Kollision
kopf "HOCH-2  Kollisions-Wahl gegen lokal + REMOTE + mkdir-Lock"
# SEIT NB2 traegt der Ordnername die LAUF-KENNUNG (runneruebergreifend eindeutig, Codex NB2-1).
# Damit kollidieren zwei Laeufe praktisch nicht mehr -- die drei Wachen bleiben aber als GURT
# bestehen, und genau den pruefen diese Proben. Sie ERZWINGEN die Kollision darum ueber
# AF_SNAP_LAUF_KENNUNG (die CI setzt diese Variable nie).
KENN=r42-j4242
TS=20260806-130000
git clone -q -b development "$R/super.git" "$R/w_push"
mkdir -p "$R/w_push/measurement/thesis_compiles/$TS-$KENN"
printf 'thesis_commit_sha=cafebabecafebabecafebabecafebabecafebabe\n' > \
    "$R/w_push/measurement/thesis_compiles/$TS-$KENN/QUELLSTAND.txt"
printf 'PDF eines FREMDEN Runners\n' > "$R/w_push/measurement/thesis_compiles/$TS-$KENN/diplomarbeit.pdf"
# Derselbe Fremd-Beleg zusaetzlich unter dem ALTEN Namensschema (nur Zeitstempel) -- die
# ALT-Gegenprobe unten waehlt genau diesen Namen und laeuft damit in den add/add-Konflikt.
mkdir -p "$R/w_push/measurement/thesis_compiles/$TS"
cp "$R/w_push/measurement/thesis_compiles/$TS-$KENN/"* "$R/w_push/measurement/thesis_compiles/$TS/"
git -C "$R/w_push" add -A -- measurement >/dev/null
git -C "$R/w_push" -c user.name=f -c user.email=f@l commit -q -m "fremder Runner landet $TS"
git -C "$R/w_push" push -q origin development
git clone -q -b development "$R/super.git" "$R/w_koll"
git -C "$R/w_koll" checkout -q "$(git -C "$R/w_koll" rev-parse HEAD~1)"   # kennt den fremden Ordner NICHT
neue_tabellen "$R/w_koll" "Lauf Kollision"
git clone -q -b development "$R/dest.git" "$R/d_koll"
E18_FIXED_TS=$TS lauf AF_DEST_REPO="$R/d_koll" AF_WORK_ROOT="$R/w_koll" AF_SNAP_LAUF_KENNUNG="$KENN" AF_NO_PUSH=true > \
    "$H/h2_remote.log"
grep -q "existiert bereits im REMOTE-Stand" "$H/h2_remote.log" && ok "REMOTE-Belegung erkannt"
pruef "Suffix gewachsen" "$([ -d "$R/w_koll/measurement/thesis_compiles/$TS-$KENN-2" ] && echo ja || echo nein)" "ja"
# Gegenprobe ALT: waehlt den belegten Namen -> add/add-Konflikt beim 288-Merge
git clone -q -b development "$R/super.git" "$R/w_koll_alt"
git -C "$R/w_koll_alt" checkout -q "$(git -C "$R/w_koll_alt" rev-parse HEAD~1)"
neue_tabellen "$R/w_koll_alt" "Lauf Kollision"
git clone -q -b development "$R/dest.git" "$R/d_koll_alt"
env E18_FIXED_TS=$TS AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=on AF_NO_PUSH=true \
    AF_PROV_SUPER_REF=development AF_DEST_REPO="$R/d_koll_alt" AF_WORK_ROOT="$R/w_koll_alt" "$H/core_alt.sh" > \
        "$H/h2_alt.log" 2>&1
pruef "ALT waehlt den belegten Namen" \
    "$([ -d "$R/w_koll_alt/measurement/thesis_compiles/$TS" ] && echo ja || echo nein)" "ja"
git -C "$R/w_koll_alt" add -A -- measurement >/dev/null
git -C "$R/w_koll_alt" -c user.name=f -c user.email=f@l commit -q -m "unser Beleg"
git -C "$R/w_koll_alt" fetch -q origin development
git -C "$R/w_koll_alt" -c user.name=f -c user.email=f@l merge --no-edit origin/development > "$H/h2_merge.log" 2>&1
pruef "ALT: 288-Merge des Writebacks" "$?" "1"
grep -q "CONFLICT (add/add)" "$H/h2_merge.log" && ok \
    "add/add-Konflikt literal -> der Writeback-Retry haette abgebrochen (Beleg weg)"
git -C "$R/w_koll_alt" merge --abort 2>/dev/null
# mkdir-Lock: haengender Symlink auf dem .tmp-Namen -> [ -e ] ist FALSE, mkdir scheitert trotzdem
# (wie beim verlorenen Rennen). Seit NB2 wird im versteckten ".<name>.tmp" gearbeitet -- der Lock
# sitzt darum dort, nicht mehr auf dem Endnamen.
TS2=20260806-140000
git clone -q -b development "$R/super.git" "$R/w_lock"; neue_tabellen "$R/w_lock" "Lauf Lock"
git clone -q -b development "$R/dest.git" "$R/d_lock"
mkdir -p "$R/w_lock/measurement/thesis_compiles"
ln -s /nicht/vorhanden "$R/w_lock/measurement/thesis_compiles/.$TS2-$KENN.tmp"
E18_FIXED_TS=$TS2 lauf AF_DEST_REPO="$R/d_lock" AF_WORK_ROOT="$R/w_lock" AF_SNAP_LAUF_KENNUNG="$KENN" AF_NO_PUSH=true \
    > "$H/h2_lock.log"
grep -q "mkdir-Lock verloren" "$H/h2_lock.log" && ok "mkdir-Lock-Zweig genommen"
pruef "Lock-Fall weicht auf Suffix aus" \
    "$([ -d "$R/w_lock/measurement/thesis_compiles/$TS2-$KENN-2" ] && echo ja || echo nein)" "ja"
# zwei ECHT parallele Laeufe, fixer Zeitstempel, ERZWUNGEN gleiche Kennung, gemeinsame Wurzel:
# so entscheidet allein der atomare Lock -- genau der Gurt, der auch nach NB2 bestehen bleibt.
TS3=20260806-150000
git clone -q -b development "$R/super.git" "$R/w_par"; neue_tabellen "$R/w_par" "Lauf Parallel"
git clone -q -b development "$R/dest.git" "$R/d_parA"; git clone -q -b development "$R/dest.git" "$R/d_parB"
SNAPPAR="$R/w_par/measurement/thesis_compiles"
for w in A B; do
  ( E18_FIXED_TS=$TS3 lauf AF_DEST_REPO="$R/d_par$w" AF_WORK_ROOT="$R/w_par" AF_SNAPSHOT_ROOT="$SNAPPAR" \
      AF_SNAP_LAUF_KENNUNG="$KENN" AF_TMP="$(mktemp -d)" AF_NO_PUSH=true > "$H/h2_par_$w.log" ) &
done
wait
pruef "2 parallele Laeufe -> 2 verschiedene Belege" \
  "$( { [ -d "$SNAPPAR/$TS3-$KENN" ] && [ -d "$SNAPPAR/$TS3-$KENN-2" ]; } && echo ja || echo nein)" "ja"

# ------------------------------------------------------------------ HOCH-3: non-FF
kopf "HOCH-3  Re-Fixierung nach non-FF-Push (Merge-Commit)"
git clone -q -b development "$R/dest.git" "$R/d_nff"      # unser Lauf kennt Y NICHT
git clone -q -b development "$R/dest.git" "$R/d_fremd"
perl -0pi -e 's|\\end\{document\}|\\typeout{FREMDZUSATZ-IM-LOG}\n\\end{document}|' "$R/d_fremd/diplomarbeit.tex"
git -C "$R/d_fremd" -c user.name=f -c user.email=f@l commit -q -am "Y: fremder Thesis-Commit mit Log-Marker"
git -C "$R/d_fremd" push -q origin development
git clone -q -b development "$R/super.git" "$R/w_nff"; neue_tabellen "$R/w_nff" "Lauf non-FF"
vorher_liste "$R/w_nff/measurement/thesis_compiles" "$H/h3_vor.txt"
lauf AF_DEST_REPO="$R/d_nff" AF_WORK_ROOT="$R/w_nff" AF_PUSH_RETRIES=3 > "$H/h3_neu.log"
grep -q "RE-ERNTE" "$H/h3_neu.log" && ok "Divergenz erkannt -> Re-Ernte"
QN=$(neuer_beleg "$R/w_nff/measurement/thesis_compiles" "$H/h3_vor.txt")
pruef "Beleg zeigt auf die BRANCH-SPITZE" "$(grep '^thesis_commit_sha=' "$QN/QUELLSTAND.txt" | cut -d= -f2)" \
      "$(git -C "$R/dest.git" rev-parse development)"
pruef "geernteter compile-export stammt aus dem GEMERGTEN Baum" \
      "$(grep -c 'FREMDZUSATZ-IM-LOG' "$QN/compile-export.txt")" "1"
# Gegenprobe ALT
git clone -q -b development "$R/dest.git" "$R/d_nff_alt"; git clone -q -b development "$R/dest.git" "$R/d_fremd2"
perl -0pi -e 's|\\end\{document\}|\\typeout{FREMDZUSATZ2-IM-LOG}\n\\end{document}|' "$R/d_fremd2/diplomarbeit.tex"
git -C "$R/d_fremd2" -c user.name=f -c user.email=f@l commit -q -am "Y2"
git -C "$R/d_fremd2" push -q origin development
git clone -q -b development "$R/super.git" "$R/w_nff_alt"; neue_tabellen "$R/w_nff_alt" "Lauf non-FF alt"
vorher_liste "$R/w_nff_alt/measurement/thesis_compiles" "$H/h3a_vor.txt"
env AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=on AF_PROV_SUPER_REF=development AF_PUSH_RETRIES=3 \
    AF_DEST_REPO="$R/d_nff_alt" AF_WORK_ROOT="$R/w_nff_alt" "$H/core_alt.sh" > "$H/h3_alt.log" 2>&1
QA=$(neuer_beleg "$R/w_nff_alt/measurement/thesis_compiles" "$H/h3a_vor.txt")
if [ "$(grep '^thesis_commit_sha=' "$QA/QUELLSTAND.txt" | cut -d= -f2)" != \
    "$(git -C "$R/dest.git" rev-parse development)" ]; then
  ok "ALT dokumentiert einen Commit, der so nie auf dem Branch stand (Divergenz)"
else nok "ALT haette divergent sein muessen"; fi

# ------------------------------------------------------------------ MITTEL-1: errexit
kopf "MITTEL-1  errexit-Luecke: Schreibfehler beim compile-export"
git clone -q -b development "$R/super.git" "$R/w_err"; neue_tabellen "$R/w_err" "Lauf errexit"
git clone -q -b development "$R/dest.git" "$R/d_err_alt"; git clone -q -b development "$R/dest.git" "$R/d_err_neu"
env PATH="$H/bin_cpfail:$PATH" AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=on AF_NO_PUSH=true \
    AF_PROV_SUPER_REF=development AF_DEST_REPO="$R/d_err_alt" AF_WORK_ROOT="$R/w_err" \
    AF_SNAPSHOT_ROOT="$R/w_err/snap_alt" "$H/core_alt.sh" > "$H/m1_alt.log" 2>&1
pruef "ALT: RC trotz Schreibfehler" "$?" "0"
pruef "ALT legt einen HALBEN Beleg ab" "$(find "$R/w_err/snap_alt" -type f | wc -l)" "2"
grep -q '^compile_export=compile-export.txt' "$R/w_err/snap_alt"/*/QUELLSTAND.txt \
  && ok "ALT-QUELLSTAND behauptet einen compile-export, den es nicht gibt"
env PATH="$H/bin_cpfail:$PATH" AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=on AF_NO_PUSH=true \
    AF_PROV_SUPER_REF=development AF_DEST_REPO="$R/d_err_neu" AF_WORK_ROOT="$R/w_err" \
    AF_SNAPSHOT_ROOT="$R/w_err/snap_neu" "$CORE" > "$H/m1_neu.log" 2>&1
pruef "NEU: RC bei Schreibfehler" "$?" "1"
pruef "NEU legt NICHTS ab" "$(find "$R/w_err/snap_neu" -type f 2>/dev/null | wc -l)" "0"
pruef "NEU committet auch nichts" "$(git -C "$R/d_err_neu" rev-parse HEAD)" \
    "$(git -C "$R/dest.git" rev-parse development)"

# ------------------------------------------------------------------ MITTEL-2 + Commit-Text
kopf "MITTEL-2  AF_SNAPSHOT_ROOT-Override: der Writeback stagt den GEWAEHLTEN Pfad"
git clone -q -b development "$R/super.git" "$R/w_ovr"; neue_tabellen "$R/w_ovr" "Lauf Override"
git clone -q -b development "$R/dest.git" "$R/d_ovr"
export SNAP_DIR="measurement/eigene_beleg_wurzel"
lauf AF_DEST_REPO="$R/d_ovr" AF_WORK_ROOT="$R/w_ovr" AF_SNAPSHOT_ROOT="$R/w_ovr/$SNAP_DIR" AF_NO_PUSH=true > \
    "$H/m2_kern.log"
git -C "$R/w_ovr" config user.name f; git -C "$R/w_ovr" config user.email f@l
export NEW_THESIS_SHA=$(git -C "$R/d_ovr" rev-parse HEAD)
wb "$H/wb_neu.sh" "$R/w_ovr" > "$H/m2_neu.log"
pruef "NEU: Beleg im 288-Remote gelandet" \
  "$(git -C "$R/super.git" ls-tree -r --name-only development | grep -c "$SNAP_DIR/")" "3"
grep -q 'Gitlink auf .* + Compile-Schnappschuss (3 Datei(en))' "$H/m2_neu.log" \
  && ok "Commit-Text nennt BEIDES, weil beides gestagt ist"
git clone -q -b development "$R/super.git" "$R/w_ovr_alt"; neue_tabellen "$R/w_ovr_alt" "Lauf Override alt"
git clone -q -b development "$R/dest.git" "$R/d_ovr_alt"
# Der Klon traegt den bereits gelandeten Beleg des NEU-Laufs -- gefragt ist der Ordner, den DIESER
# Lauf anlegt. Darum Vorher/Nachher-Differenz statt "irgendein Ordner".
vorher_liste "$R/w_ovr_alt/$SNAP_DIR" "$H/m2a_vor.txt"
lauf AF_DEST_REPO="$R/d_ovr_alt" AF_WORK_ROOT="$R/w_ovr_alt" AF_SNAPSHOT_ROOT="$R/w_ovr_alt/$SNAP_DIR" AF_NO_PUSH=true \
    > "$H/m2_kern_alt.log"
NEUSTER=$(basename "$(neuer_beleg "$R/w_ovr_alt/$SNAP_DIR" "$H/m2a_vor.txt")")
git -C "$R/w_ovr_alt" config user.name f; git -C "$R/w_ovr_alt" config user.email f@l
export NEW_THESIS_SHA=$(git -C "$R/d_ovr_alt" rev-parse HEAD)
wb "$H/wb_alt.sh" "$R/w_ovr_alt" > "$H/m2_alt.log"
pruef "ALT: derselbe Beleg im Remote" \
  "$(git -C "$R/super.git" ls-tree -r --name-only development | grep -c "$NEUSTER")" "0"
grep -q '+ Compile-Schnappschuss' "$H/m2_alt.log" && ok \
    "ALT-Commit-Text behauptet einen Schnappschuss, der nicht drin ist"

kopf "patch:76  Vollstaendigkeits-Wache im Writeback"
unset SNAP_DIR
git clone -q -b development "$R/super.git" "$R/w_halb"
git -C "$R/w_halb" config user.name f; git -C "$R/w_halb" config user.email f@l
export NEW_THESIS_SHA=$(git -C "$R/w_halb" ls-tree HEAD thesis/diplomarbeit | awk '{print $3}')
mkdir -p "$R/w_halb/measurement/thesis_compiles/20260806-170000"
printf 'PDF\n'                 > "$R/w_halb/measurement/thesis_compiles/20260806-170000/diplomarbeit.pdf"
printf 'thesis_commit_sha=x\n' > "$R/w_halb/measurement/thesis_compiles/20260806-170000/QUELLSTAND.txt"
wb "$H/wb_neu.sh" "$R/w_halb" > "$H/p76_neu.log"
pruef "NEU: RC bei halbem Beleg" "$?" "1"
pruef "NEU stagt nichts" "$(git -C "$R/w_halb" diff --cached --name-only | wc -l)" "0"
wb "$H/wb_alt.sh" "$R/w_halb" > "$H/p76_alt.log"
grep -q 'create mode .*20260806-170000' "$H/p76_alt.log" && ok "ALT committet den halben Beleg klaglos"

kopf "patch NB2  Writeback: 40-hex-Wache + .tmp-Halbstand wird NIE gestagt"
git clone -q -b development "$R/super.git" "$R/w_hex"
git -C "$R/w_hex" config user.name f; git -C "$R/w_hex" config user.email f@l
export NEW_THESIS_SHA=$(git -C "$R/w_hex" ls-tree HEAD thesis/diplomarbeit | awk '{print $3}')
DH="$R/w_hex/measurement/thesis_compiles/20260806-190000-r1-j1"; mkdir -p "$DH"
printf 'PDF\n' > "$DH/diplomarbeit.pdf"; printf 'log\n' > "$DH/compile-export.txt"
printf 'thesis_commit_sha=nicht-hex\n' > "$DH/QUELLSTAND.txt"
wb "$H/wb_neu.sh" "$R/w_hex" > "$H/pnb2_hex.log"
pruef "NEU: RC bei nicht-hex thesis_commit_sha" "$?" "1"
grep -q 'thesis_commit_sha=<40-hex>' "$H/pnb2_hex.log" && ok "Writeback nennt die verletzte Formregel literal"
pruef "NEU stagt nichts" "$(git -C "$R/w_hex" diff --cached --name-only | wc -l)" "0"
git clone -q -b development "$R/super.git" "$R/w_tmp"
git -C "$R/w_tmp" config user.name f; git -C "$R/w_tmp" config user.email f@l
export NEW_THESIS_SHA=$(git -C "$R/w_tmp" ls-tree HEAD thesis/diplomarbeit | awk '{print $3}')
DT="$R/w_tmp/measurement/thesis_compiles/.20260806-191000-r1-j1.tmp"; mkdir -p "$DT"
printf 'HALBE-PDF\n' > "$DT/diplomarbeit.pdf"
DG="$R/w_tmp/measurement/thesis_compiles/20260806-191000-r1-j2"; mkdir -p "$DG"
printf 'PDF\n' > "$DG/diplomarbeit.pdf"; printf 'log\n' > "$DG/compile-export.txt"
printf 'thesis_commit_sha=%s\n' "$NEW_THESIS_SHA" > "$DG/QUELLSTAND.txt"
wb "$H/wb_neu.sh" "$R/w_tmp" > "$H/pnb2_tmp.log"
grep -q 'abgebrochener Schnappschuss-Halbstand' "$H/pnb2_tmp.log" && ok ".tmp-Halbstand literal gemeldet"
pruef ".tmp-Halbstand entfernt" "$([ -e "$DT" ] && echo da || echo weg)" "weg"
pruef "kein .tmp-Pfad im 288-Remote" \
  "$(git -C "$R/super.git" ls-tree -r --name-only development | grep -c '\.tmp/')" "0"
pruef "der VOLLSTAENDIGE Beleg daneben landet trotzdem" \
  "$(git -C "$R/super.git" ls-tree -r --name-only development | grep -c '20260806-191000-r1-j2/')" "3"

kopf "Commit-Text  dritter Fall: nur Beleg, Gitlink unbewegt"
git clone -q -b development "$R/super.git" "$R/w_txt"
git -C "$R/w_txt" config user.name f; git -C "$R/w_txt" config user.email f@l
export NEW_THESIS_SHA=$(git -C "$R/w_txt" ls-tree HEAD thesis/diplomarbeit | awk '{print $3}')
D="$R/w_txt/measurement/thesis_compiles/20260806-180000"; mkdir -p "$D"
printf 'PDF\n' > "$D/diplomarbeit.pdf"; printf 'log\n' > "$D/compile-export.txt"
printf 'thesis_commit_sha=%s\n' "$NEW_THESIS_SHA" > "$D/QUELLSTAND.txt"
wb "$H/wb_neu.sh" "$R/w_txt" > "$H/txt_neu.log"
grep -q 'Compile-Schnappschuss (3 Datei(en)), Gitlink unveraendert bei' "$H/txt_neu.log" \
  && ok "Commit-Text sagt: nur Beleg, Gitlink unbewegt" || nok "dritter Commit-Text-Fall"

# ------------------------------------------------------------------ MITTEL-3: Rollback
kopf "MITTEL-3  Rollback loescht nur SELBST erzeugte Dateien"
git clone -q -b development "$R/super.git" "$R/w_roll"
mkdir -p "$R/w_roll/Code/measure_out/appendix/de/tabellen" "$R/w_roll/Code/measure_out/appendix/en/tabellen"
printf '%s\n' '\textbf{DE-T1 neu}\par'      > "$R/w_roll/Code/measure_out/appendix/de/tabellen/T1.tex"
printf '%s\n' '\undefinedcommandXY'         > "$R/w_roll/Code/measure_out/appendix/de/tabellen/T2.tex"
printf '%s\n' '\textbf{DE-T3 aus Kanal}\par'> "$R/w_roll/Code/measure_out/appendix/de/tabellen/T3.tex"
printf '%s\n' '\textbf{EN-T1 neu}\par'      > "$R/w_roll/Code/measure_out/appendix/en/tabellen/T1.tex"
roll_dest() { git clone -q -b development "$R/dest.git" "$1"
  printf 'FREMD-INHALT-T3 (unversioniert)\n' > "$1/anhang/de/tabellen/T3.tex"
  printf 'nie angefasst\n'                   > "$1/anhang/de/tabellen/FREMD.txt"; }
roll_dest "$R/d_roll"
perl -0pi -e 's|\\end\{document\}|\\InputIfFileExists{anhang/de/tabellen/T2.tex}{}{}\n\\end{document}|' \
    "$R/d_roll/diplomarbeit.tex"
git -C "$R/d_roll" -c user.name=f -c user.email=f@l commit -q -am "T2 wird eingebunden"
git -C "$R/d_roll" push -q origin development
T3VOR=$(sha256sum < "$R/d_roll/anhang/de/tabellen/T3.tex" | cut -d' ' -f1)
lauf AF_DEST_REPO="$R/d_roll" AF_WORK_ROOT="$R/w_roll" AF_NO_PUSH=true > "$H/m3_neu.log"
pruef "NEU: RC bei rotem PDF-Gate" "$?" "1"
pruef "NEU: fremde T3.tex erhalten" "$(sha256sum < "$R/d_roll/anhang/de/tabellen/T3.tex" 2>/dev/null | cut -d' ' -f1)" \
    "$T3VOR"
pruef "NEU: selbst angelegte T2.tex entfernt" "$([ -e "$R/d_roll/anhang/de/tabellen/T2.tex" ] && echo da || echo weg)" \
    "weg"
pruef "NEU: unbeteiligte FREMD.txt unangetastet" "$(cat "$R/d_roll/anhang/de/tabellen/FREMD.txt")" "nie angefasst"
roll_dest "$R/d_roll_alt"
env AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=on AF_NO_PUSH=true AF_PROV_SUPER_REF=development \
    AF_DEST_REPO="$R/d_roll_alt" AF_WORK_ROOT="$R/w_roll" "$H/core_alt.sh" > "$H/m3_alt.log" 2>&1
pruef "ALT: fremde T3.tex" "$([ -e "$R/d_roll_alt/anhang/de/tabellen/T3.tex" ] && echo da || echo GELOESCHT)" \
    "GELOESCHT"

# ------------------------------------------------------------------ Grenzen unveraendert
kopf "Grenzen unveraendert (Regression)"
git clone -q -b development "$R/super.git" "$R/w_off"; neue_tabellen "$R/w_off" "Lauf gate-off"
git clone -q -b development "$R/dest.git" "$R/d_off"
VOR=$(find "$R/w_off/measurement/thesis_compiles" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
env AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=off AF_NO_PUSH=true AF_PROV_SUPER_REF=development \
    AF_DEST_REPO="$R/d_off" AF_WORK_ROOT="$R/w_off" "$CORE" > "$H/g_off.log" 2>&1
grep -q "KEIN Schnappschuss -- das PDF-Gate hat nicht gebaut" "$H/g_off.log" && ok \
    "ohne Compile kein Beleg, literal begruendet"
pruef "Ordnerzahl unveraendert" \
    "$(find "$R/w_off/measurement/thesis_compiles" -mindepth 1 -maxdepth 1 -type d | wc -l)" "$VOR"
git clone -q -b development "$R/super.git" "$R/w_leer"; git clone -q -b development "$R/dest.git" "$R/d_leer"
lauf AF_DEST_REPO="$R/d_leer" AF_WORK_ROOT="$R/w_leer" AF_SNAPSHOT_ROOT=/tmp/e18snap-nie AF_NO_PUSH=true > \
    "$H/g_leer.log"
grep -q "NO-OP: keine Anhang-Quelle" "$H/g_leer.log" && ok "honest-empty unveraendert"
pruef "honest-empty legt keine Wurzel an" "$([ -e /tmp/e18snap-nie ] && echo ja || echo nein)" "nein"
git clone -q -b development "$R/super.git" "$R/w_aus"; neue_tabellen "$R/w_aus" "Lauf ausserhalb"
git clone -q -b development "$R/dest.git" "$R/d_aus"
rm -rf /tmp/e18snap-ausserhalb
lauf AF_DEST_REPO="$R/d_aus" AF_WORK_ROOT="$R/w_aus" AF_SNAPSHOT_ROOT=/tmp/e18snap-ausserhalb/beleg AF_NO_PUSH=true > \
    "$H/g_aus.log"
# SEIT NB2 ist das kein blosser Hinweis mehr, sondern ein VERTRAGSBRUCH mit lautem Abbruch: eine
# Wurzel, die der 288-Writeback nie committen kann, darf keinen gruenen Job erzeugen (Codex MITTEL-2).
pruef "Wurzel ausserhalb eines Arbeitsbaums: RC" "$?" "1"
grep -q "liegt in KEINEM git-Arbeitsbaum" "$H/g_aus.log" && ok \
    "Wurzel ausserhalb eines Arbeitsbaums: literal gemeldet, kein stiller Teil-Schutz"
grep -q "AF_SNAPSHOT_ROOT-Vertrag VERLETZT" "$H/g_aus.log" && ok \
    "Vertragsbruch fuehrt zum Abbruch statt zu stillem Gruen"
pruef "kein Beleg ausserhalb des 288-Baums" \
    "$([ -e /tmp/e18snap-ausserhalb/beleg/QUELLSTAND.txt ] && echo ja || echo nein)" "nein"

echo
if [ "$FEHLER" -eq 0 ]; then echo "=== PROBEN GRUEN: alle Pfade belegt (0 Abweichungen) ==="; exit 0; fi
echo "=== PROBEN ROT: $FEHLER Abweichung(en) ==="; exit 1
