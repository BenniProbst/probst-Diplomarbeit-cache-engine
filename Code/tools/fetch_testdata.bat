@echo off
REM REV 7.7 V23.3 (2026-05-14) - Lazy on-demand Benchmark-Daten-Download (Windows-Variante)
REM
REM Verwendung:
REM   fetch_testdata.bat --dataset <name>
REM   fetch_testdata.bat --list
REM   fetch_testdata.bat --all
REM
REM Memory-Direktive F-EXTRA-5: KEIN Python, nur sh/bat/cmake.

setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "FIXTURES_DIR=%SCRIPT_DIR%..\tests\fixtures\external"
if not exist "%FIXTURES_DIR%" mkdir "%FIXTURES_DIR%"

if "%~1"=="" goto :usage
if /i "%~1"=="--list" goto :datasets_list
if /i "%~1"=="--all" goto :fetch_all
if /i "%~1"=="--dataset" goto :dispatch_dataset
goto :usage

:datasets_list
echo Verfuegbare Datensaetze (V23.3):
echo   english_words         english-words/words.txt (4 MB, MIT)
echo   sosd_books_200M       SOSD books_200M_uint64 (1.6 GB, CC-BY)
echo   sosd_fb               SOSD fb_200M_uint64 (1.6 GB, CC-BY)
echo   sosd_wiki_ts          SOSD wiki_ts_200M_uint64 (1.6 GB, CC-BY)
echo   pizzachili_dna        Pizza^&Chili DNA (404 MB, public)
echo   pizzachili_xml        Pizza^&Chili XML (295 MB, public)
echo   pizzachili_protein    Pizza^&Chili Protein (1.18 GB, public)
echo.
echo ZU BEACHTEN (User-Auth):
echo   it_2004_urls          247 MB, LAW akademisch - manuell von https://law.di.unimi.it/datasets.php
goto :eof

:fetch_all
call :fetch english_words
call :fetch sosd_books_200M
call :fetch sosd_fb
call :fetch sosd_wiki_ts
call :fetch pizzachili_dna
call :fetch pizzachili_xml
call :fetch pizzachili_protein
echo [hint] it_2004_urls braucht manuelle User-Aktion (LAW Sign-Up)
goto :eof

:dispatch_dataset
if "%~2"=="" goto :usage
call :fetch %~2
goto :eof

:fetch
set "DS=%~1"
if /i "%DS%"=="english_words" (
  set "OUT=%FIXTURES_DIR%\english_words"
  if not exist "!OUT!" mkdir "!OUT!"
  if exist "!OUT!\words.txt" ( echo [skip] english_words & goto :eof )
  echo [fetch] english-words/words.txt
  curl -fsSL -o "!OUT!\words.txt" "https://github.com/dwyl/english-words/raw/master/words.txt"
  goto :eof
)
if /i "%DS%"=="sosd_books_200M" (
  set "OUT=%FIXTURES_DIR%\sosd"
  if not exist "!OUT!" mkdir "!OUT!"
  if exist "!OUT!\books_200M_uint64" ( echo [skip] sosd_books_200M & goto :eof )
  echo [fetch] SOSD books_200M_uint64 (~1.6 GB)
  curl -fsSL -o "!OUT!\books_200M_uint64" "https://dataverse.harvard.edu/api/access/datafile/:persistentId?persistentId=doi:10.7910/DVN/JGVF9A/5YTV8K"
  goto :eof
)
if /i "%DS%"=="sosd_fb" (
  set "OUT=%FIXTURES_DIR%\sosd"
  if not exist "!OUT!" mkdir "!OUT!"
  if exist "!OUT!\fb_200M_uint64" ( echo [skip] sosd_fb & goto :eof )
  echo [fetch] SOSD fb_200M_uint64 (~1.6 GB)
  curl -fsSL -o "!OUT!\fb_200M_uint64" "https://dataverse.harvard.edu/api/access/datafile/:persistentId?persistentId=doi:10.7910/DVN/JGVF9A/EATHF7"
  goto :eof
)
if /i "%DS%"=="sosd_wiki_ts" (
  set "OUT=%FIXTURES_DIR%\sosd"
  if not exist "!OUT!" mkdir "!OUT!"
  if exist "!OUT!\wiki_ts_200M_uint64" ( echo [skip] sosd_wiki_ts & goto :eof )
  echo [fetch] SOSD wiki_ts_200M_uint64 (~1.6 GB)
  curl -fsSL -o "!OUT!\wiki_ts_200M_uint64" "https://dataverse.harvard.edu/api/access/datafile/:persistentId?persistentId=doi:10.7910/DVN/JGVF9A/SVN8PI"
  goto :eof
)
if /i "%DS%"=="pizzachili_dna" (
  set "OUT=%FIXTURES_DIR%\pizzachili"
  if not exist "!OUT!" mkdir "!OUT!"
  if exist "!OUT!\dna.gz" ( echo [skip] pizzachili_dna & goto :eof )
  echo [fetch] Pizza^&Chili DNA (~404 MB)
  curl -fsSL -o "!OUT!\dna.gz" "https://pizzachili.dcc.uchile.cl/texts/dna/dna.gz"
  goto :eof
)
if /i "%DS%"=="pizzachili_xml" (
  set "OUT=%FIXTURES_DIR%\pizzachili"
  if not exist "!OUT!" mkdir "!OUT!"
  if exist "!OUT!\dblp.xml.gz" ( echo [skip] pizzachili_xml & goto :eof )
  echo [fetch] Pizza^&Chili XML DBLP (~295 MB)
  curl -fsSL -o "!OUT!\dblp.xml.gz" "https://pizzachili.dcc.uchile.cl/texts/xml/dblp.xml.gz"
  goto :eof
)
if /i "%DS%"=="pizzachili_protein" (
  set "OUT=%FIXTURES_DIR%\pizzachili"
  if not exist "!OUT!" mkdir "!OUT!"
  if exist "!OUT!\proteins.gz" ( echo [skip] pizzachili_protein & goto :eof )
  echo [fetch] Pizza^&Chili Protein (~1.18 GB)
  curl -fsSL -o "!OUT!\proteins.gz" "https://pizzachili.dcc.uchile.cl/texts/protein/proteins.gz"
  goto :eof
)
echo Unbekannter Datensatz: %DS%
goto :datasets_list

:usage
echo Usage: %~nx0 [--list ^| --all ^| --dataset ^<name^>]
exit /b 1
