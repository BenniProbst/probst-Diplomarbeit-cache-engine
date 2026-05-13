@echo off
REM build_thesis.bat — Diplomarbeit/Code Frontend (Windows, REV 7.6)

setlocal EnableDelayedExpansion

set SCRIPT_DIR=%~dp0
set SOURCE_DIR=..\..\thesis
set OUTPUT_DIR=..\..\build\thesis-final
set LATEX_ENGINE=pdflatex
set MAIN_TEX=main.tex

:parse_args
if "%~1"=="" goto run
set ARG=%~1
if "!ARG:~0,9!"=="--source=" set SOURCE_DIR=!ARG:~9!
if "!ARG:~0,9!"=="--output=" set OUTPUT_DIR=!ARG:~9!
if "!ARG:~0,9!"=="--engine=" set LATEX_ENGINE=!ARG:~9!
if "!ARG:~0,7!"=="--main="   set MAIN_TEX=!ARG:~7!
if "%~1"=="--help" goto help
if "%~1"=="-h"     goto help
shift
goto parse_args

:help
echo Usage: build_thesis.bat [--source=DIR] [--output=DIR] [--engine=ENGINE] [--main=FILE]
exit /b 0

:run
cmake ^
    -DCOMDARE_THESIS_SOURCE=%SOURCE_DIR% ^
    -DCOMDARE_THESIS_OUTPUT=%OUTPUT_DIR% ^
    -DCOMDARE_LATEX_ENGINE=%LATEX_ENGINE% ^
    -DCOMDARE_THESIS_MAIN_TEX=%MAIN_TEX% ^
    -P "%SCRIPT_DIR%latex_toolchain.cmake"
exit /b %ERRORLEVEL%
