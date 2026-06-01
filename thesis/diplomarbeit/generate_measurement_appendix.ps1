# generate_measurement_appendix.ps1 — C1 (2026-06-01)
# Orchestrator: erzeugt aus EINER 16-Spalten-measurements.csv je Sprache (de+en)
# ein booktabs-Tabellen-Fragment + ein pgfplots-Diagramm-Fragment und legt sie
# nach anhang/<lang>/tabellen/ ab. Danach genuegt `build.ps1 -Lang de|en`, um den
# befuellten Mess-Anhang (A_measurements) zu erzeugen.
#
# Bilingual via die CLI-Schalter --lang=de|en (C2): lokalisierte Spaltenkoepfe
# (Zyklen vs cycles) + Diagramm-Titel/Achsen (Comdare-Messvergleich vs ...).
#
#   pwsh -File generate_measurement_appendix.ps1
#   pwsh -File generate_measurement_appendix.ps1 -Csv <pfad> -SpecId v5_demo
#
param(
  # Quell-CSV (16-Spalten-Schema, ComdareMeasurementSnapshotV1). Default = realer
  # Pipeline-Lauf aus dem aktiven msvc-g1-Build.
  [string]$Csv = "..\..\Code\build\msvc-g1\pipeline_real_organ\measurements.csv",
  # Eindeutige Kennung der Messreihe (Dateiname + LaTeX-Label).
  [string]$SpecId = "v5_pipeline_demo",
  # Build-Verzeichnis, in dem csv-to-latex.exe + diagram-generator.exe liegen.
  [string]$CodeBuildDir = "..\..\Code\build\msvc-g1"
)
$ErrorActionPreference = 'Stop'
Push-Location $PSScriptRoot
try {
  $csvPath = (Resolve-Path $Csv).Path
  $csvToLatex = Join-Path $CodeBuildDir "04_csv_to_latex\Release\csv-to-latex.exe"
  $diagramGen = Join-Path $CodeBuildDir "05_diagram_generator\Release\diagram-generator.exe"
  foreach ($exe in @($csvToLatex, $diagramGen)) {
    if (-not (Test-Path $exe)) { throw "CLI-Exe fehlt: $exe (Code-Build erforderlich)" }
  }
  $csvToLatex = (Resolve-Path $csvToLatex).Path
  $diagramGen = (Resolve-Path $diagramGen).Path

  # Sprach-spezifische Captions (Label bleibt identisch: pro Build wird nur EINE
  # Sprache via \thesislang inkludiert, daher kein Label-Konflikt).
  #
  # Tabellen-Caption: ROH an csv-to-latex uebergeben — das CLI escaped selbst
  # (escape_latex). Diagramm-Caption: schreiben WIR direkt ins .tex → hier muessen
  # wir LaTeX-Sonderzeichen der SpecId selbst escapen (sonst bricht der rohe `_`
  # im Textmodus + propagiert in die .lof → "Missing $ inserted").
  $specIdTex = $SpecId -replace '([\\&%#_{}$])', '\$1'
  $captions = @{
    de = "Messreihe ${SpecId}: vorkonfigurierte Tier-Permutationen (Pfad A, run_workload)";
    en = "Measurement series ${SpecId}: pre-configured tier permutations (Path A, run_workload)"
  }
  $diagCaptions = @{
    de = "Zyklen je Tier-Permutation (${specIdTex})";
    en = "Cycles per tier permutation (${specIdTex})"
  }
  $label = "tab:measurements:${SpecId}"
  $diagLabel = "fig:measurements:${SpecId}"

  foreach ($lang in @('de','en')) {
    $outDir = Join-Path $PSScriptRoot "anhang\$lang\tabellen"
    New-Item -ItemType Directory -Force -Path $outDir | Out-Null
    $tableTex = Join-Path $outDir "${SpecId}_table.tex"
    $diagBody = Join-Path $outDir "${SpecId}_diagram_body.tex"
    $diagTex  = Join-Path $outDir "${SpecId}_diagram.tex"

    & $csvToLatex $csvPath $tableTex "--caption=$($captions[$lang])" "--label=$label" "--lang=$lang"
    if ($LASTEXITCODE -ne 0) { throw "csv-to-latex ($lang) EXIT=$LASTEXITCODE" }

    & $diagramGen $csvPath $diagBody "--lang=$lang" "--body-only"
    if ($LASTEXITCODE -ne 0) { throw "diagram-generator ($lang) EXIT=$LASTEXITCODE" }

    # Diagramm-Body (reine tikzpicture, --body-only) in eine figure mit spec-Caption
    # + Label wrappen, damit er im Abbildungsverzeichnis erscheint und referenzierbar ist.
    $fig = @(
      "% AUTO-GENERATED durch generate_measurement_appendix.ps1 (lang=$lang)",
      "\begin{figure}[!htbp]",
      "\centering",
      "\input{anhang/$lang/tabellen/${SpecId}_diagram_body.tex}",
      "\caption{$($diagCaptions[$lang])}",
      "\label{$diagLabel}",
      "\end{figure}"
    ) -join "`n"
    Set-Content -Path $diagTex -Value $fig -Encoding UTF8

    Write-Host "OK [$lang]: $tableTex + $diagTex" -ForegroundColor Green
  }
  Write-Host "Fertig. Anhang einbinden via \input{anhang/<lang>/tabellen/${SpecId}_table.tex} bzw. _diagram.tex" -ForegroundColor Cyan
} finally {
  Pop-Location
}
