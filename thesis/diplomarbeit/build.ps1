# Bilingual build of the diploma thesis with MiKTeX (Windows).
#   pwsh -File build.ps1            # English (default)  -> diplomarbeit-en.pdf
#   pwsh -File build.ps1 -Lang de   # German             -> diplomarbeit-de.pdf
# Runs the mandatory 3-pass build with BibTeX (zihpub.cls).
param([ValidateSet('en','de')][string]$Lang = 'en')
$ErrorActionPreference = 'Continue'
$job = "diplomarbeit-$Lang"
$arg = "\def\thesislang{$Lang}\input{diplomarbeit.tex}"
Push-Location $PSScriptRoot
try {
  & pdflatex -interaction=nonstopmode "-jobname=$job" $arg
  & bibtex   $job
  & pdflatex -interaction=nonstopmode "-jobname=$job" $arg
  & pdflatex -interaction=nonstopmode "-jobname=$job" $arg
  if (Test-Path "$job.pdf") {
    Write-Host "OK [$Lang]: $job.pdf ($([math]::Round((Get-Item "$job.pdf").Length/1KB,1)) KB)" -ForegroundColor Green
  } else {
    Write-Host "FEHLER [$Lang]: $job.pdf nicht erzeugt -- siehe $job.log" -ForegroundColor Red
  }
} finally {
  Pop-Location
}
