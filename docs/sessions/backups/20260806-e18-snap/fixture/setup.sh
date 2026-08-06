#!/usr/bin/env bash
# Fixture-Aufbau fuer E-18-SNAP. Spiegelt den 289- UND den 288-Stand in den load-bearing Punkten:
#   289 (dest):  EIN Top-Level-Hauptdokument mit \documentclass, .gitignore-Regel diplomarbeit*.pdf
#                (die gebaute PDF ist untracked+ignoriert wie in echt), anhang/<lang>/tabellen/ als
#                Ziel der Whitelist-Kopie, ECHTES bare-Remote (dest.git) -> Push/non-ff-Merge fahrbar
#   288 (work):  Arbeitsklon mit ECHTEM bare-Remote (super.git) -> die REMOTE-Wache der Suffix- und
#                der Nachhol-Entscheidung ist fahrbar; .gitignore spiegelt die super-Regeln
#                (global *.log ohne measurement/-Gegenausnahme, aber !measurement/**/*.csv) und
#                traegt einen Gitlink thesis/diplomarbeit wie das echte Repo.
# Ohne echte Remotes waeren die Codex-Heilungen HOCH-1/HOCH-2/HOCH-3 nicht beweisbar.
set -euo pipefail
ROOT=/tmp/e18snap-fixture
rm -rf "$ROOT"
mkdir -p "$ROOT"

# ---------- 289-Seite ----------------------------------------------------------------
mkdir -p "$ROOT/dest/anhang/de/tabellen" "$ROOT/dest/anhang/en/tabellen"
cat > "$ROOT/dest/.gitignore" <<'EOF'
diplomarbeit*.pdf
*.aux
*.log
*.fls
*.fdb_latexmk
EOF
cat > "$ROOT/dest/diplomarbeit.tex" <<'EOF'
\documentclass{article}
\begin{document}
\section*{E-18-SNAP Fixture}
Dieser Bau haengt echt an den Anhang-Tabellen:
\InputIfFileExists{anhang/de/tabellen/T1.tex}{}{KEINE DE-TABELLE}
\InputIfFileExists{anhang/en/tabellen/T1.tex}{}{KEINE EN-TABELLE}
\end{document}
EOF
git -C "$ROOT/dest" init -q -b development
git -C "$ROOT/dest" add -A
git -C "$ROOT/dest" -c user.name=fixture -c user.email=fixture@local commit -q -m "Fixture-Ausgangsstand 289-artig"
git init -q --bare -b development "$ROOT/dest.git"
git -C "$ROOT/dest" remote add origin "$ROOT/dest.git"
git -C "$ROOT/dest" push -q -u origin development

# ---------- 288-Seite ("Wurzel der Messwerte") ----------------------------------------
mkdir -p "$ROOT/work/measurement" "$ROOT/work/Code/measure_out/appendix/de/tabellen" \
         "$ROOT/work/Code/measure_out/appendix/en/tabellen"
cat > "$ROOT/work/.gitignore" <<'EOF'
*.log
!measurement/**/*.csv
build/
EOF
: > "$ROOT/work/measurement/.gitkeep"
git -C "$ROOT/work" init -q -b development
git -C "$ROOT/work" add -A
# Gitlink wie im echten super-Repo (Wert zeigt bewusst auf den 289-Ausgangsstand).
DEST_HEAD="$(git -C "$ROOT/dest" rev-parse HEAD)"
git -C "$ROOT/work" update-index --add --cacheinfo "160000,$DEST_HEAD,thesis/diplomarbeit"
git -C "$ROOT/work" -c user.name=fixture -c user.email=fixture@local commit -q -m "Fixture-Ausgangsstand 288-artig (Gitlink + measurement/)"
git init -q --bare -b development "$ROOT/super.git"
git -C "$ROOT/work" remote add origin "$ROOT/super.git"
git -C "$ROOT/work" push -q -u origin development

printf '%s\n' '\textbf{DE-Tabelle aus Lauf 1}\par' > "$ROOT/work/Code/measure_out/appendix/de/tabellen/T1.tex"
printf '%s\n' '\textbf{EN-Tabelle aus Lauf 1}\par' > "$ROOT/work/Code/measure_out/appendix/en/tabellen/T1.tex"

echo "Fixture bereit."
echo "  289 dest-HEAD:  $(git -C "$ROOT/dest" rev-parse --short HEAD)   remote: $ROOT/dest.git"
echo "  288 work-HEAD:  $(git -C "$ROOT/work" rev-parse --short HEAD)   remote: $ROOT/super.git"
echo "  289 dest-Dateien:"; git -C "$ROOT/dest" ls-files | sed 's/^/    /'
echo "  288 work-Dateien:"; git -C "$ROOT/work" ls-files | sed 's/^/    /'
