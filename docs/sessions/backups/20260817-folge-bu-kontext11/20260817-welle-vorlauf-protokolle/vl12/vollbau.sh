#!/bin/bash
# VL-1/VL-2 Vollbau nach J-1..J-4 + Nachtrag 10.08. (all -> RECONFIGURE -> comdare_tests -> ctest).
# NICHT committen -- Bau-Protokoll, bleibt untracked im Worktree.
# Aufruf: vollbau.sh <builddir> <logdir>
set -u
BD="$1"
LD="$2"
SRC=/home/comdare/wt-ce-vl12
mkdir -p "$LD"

step() { echo "### $1  $(date -Is)"; }

step "J-1 Werkzeuge"
cmake --build "$SRC/$BD" --target comdare_anatomy_codegen_cli comdare_adhoc_emitter_cli \
      comdare_axis_registry_gen comdare_system_axis_registry_gen comdare_measurement_axis_registry_gen \
      -- -k 0 > "$LD/01_werkzeuge.log" 2>&1
echo "rc_werkzeuge=$?"

step "J-2 RECONFIGURE"
cmake -S "$SRC" -B "$SRC/$BD" > "$LD/02_reconfigure.log" 2>&1
echo "rc_reconf1=$?"

step "J-4a Vollbau all"
# -k 0: die zwei prt-art-Perm-TUs (anatomy_perm_comdare_perms_{pa,full_join}_pilot_*) koennen in einer
# Fixture-only-Pruefling-Konfiguration nicht bauen (prt_art/slots/prt_art_composition_demo.hpp fehlt).
# Ohne -k 0 stoppt ninja dort und die apps/ entstehen nie -> falsches Rot (J-4-Klasse).
cmake --build "$SRC/$BD" -- -k 0 > "$LD/03_all.log" 2>&1
echo "rc_all=$?"

step "J-2b RECONFIGURE nach Vollbau (Nachtrag 10.08.)"
cmake -S "$SRC" -B "$SRC/$BD" > "$LD/04_reconfigure2.log" 2>&1
echo "rc_reconf2=$?"

step "J-3/J-4b explizite Ziele"
cmake --build "$SRC/$BD" --target comdare_limits_generated_source_catalog comdare_profile_run_facade \
      > "$LD/05_explizit.log" 2>&1
echo "rc_explizit=$?"

step "J-4c comdare_tests"
cmake --build "$SRC/$BD" --target comdare_tests > "$LD/06_tests.log" 2>&1
echo "rc_tests=$?"

step "ctest"
( cd "$SRC/$BD" && ctest --output-on-failure -j 8 ) > "$LD/07_ctest.log" 2>&1
echo "rc_ctest=$?"

step "Protokoll-Stand"
find "$SRC/$BD" -name comdare_registrierungs_protokoll.txt -exec cat {} \; > "$LD/08_protokoll.txt" 2>&1
tail -5 "$LD/07_ctest.log"
step "FERTIG"
