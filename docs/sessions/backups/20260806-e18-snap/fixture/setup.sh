#!/usr/bin/env bash
# Fixture-Aufbau fuer E-18-SNAP. Spiegelt den 289-Stand in den load-bearing Punkten:
#   * EIN Top-Level-Hauptdokument mit \documentclass
#   * .gitignore-Regel diplomarbeit*.pdf (die gebaute PDF ist untracked+ignoriert wie in echt)
#   * anhang/<lang>/tabellen/ als Ziel der Whitelist-Kopie
set -euo pipefail
ROOT=/tmp/e18snap-fixture
rm -rf "$ROOT/dest" "$ROOT/work"
mkdir -p "$ROOT/dest/anhang/de/tabellen" "$ROOT/dest/anhang/en/tabellen"
mkdir -p "$ROOT/work/Code/measure_out/appendix/de/tabellen" "$ROOT/work/Code/measure_out/appendix/en/tabellen"

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

printf '%s\n' '\textbf{DE-Tabelle aus Lauf 1}\par' > "$ROOT/work/Code/measure_out/appendix/de/tabellen/T1.tex"
printf '%s\n' '\textbf{EN-Tabelle aus Lauf 1}\par' > "$ROOT/work/Code/measure_out/appendix/en/tabellen/T1.tex"

echo "Fixture bereit."
echo "  dest-HEAD:   $(git -C "$ROOT/dest" rev-parse --short HEAD)"
echo "  dest-Dateien:"; git -C "$ROOT/dest" ls-files | sed 's/^/    /'
