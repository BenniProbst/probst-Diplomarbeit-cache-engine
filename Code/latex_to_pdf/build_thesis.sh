#!/bin/sh
# build_thesis.sh — Diplomarbeit/Code Frontend (POSIX, REV 7.6)
# Ruft latex_toolchain.cmake (aus cache-engine) auf, plus eigene Diplomarbeits-
# Manuskript-Pfade.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="../../thesis"
OUTPUT_DIR="../../build/thesis-final"
LATEX_ENGINE="pdflatex"
MAIN_TEX="main.tex"

for arg in "$@"; do
    case "$arg" in
        --source=*) SOURCE_DIR="${arg#--source=}" ;;
        --output=*) OUTPUT_DIR="${arg#--output=}" ;;
        --engine=*) LATEX_ENGINE="${arg#--engine=}" ;;
        --main=*)   MAIN_TEX="${arg#--main=}" ;;
        --help|-h)
            echo "Usage: $0 [--source=DIR] [--output=DIR] [--engine=ENGINE] [--main=FILE]"
            exit 0 ;;
        *)
            echo "Unknown arg: $arg" >&2; exit 4 ;;
    esac
done

cmake \
    -DCOMDARE_THESIS_SOURCE="$SOURCE_DIR" \
    -DCOMDARE_THESIS_OUTPUT="$OUTPUT_DIR" \
    -DCOMDARE_LATEX_ENGINE="$LATEX_ENGINE" \
    -DCOMDARE_THESIS_MAIN_TEX="$MAIN_TEX" \
    -P "$SCRIPT_DIR/latex_toolchain.cmake"
