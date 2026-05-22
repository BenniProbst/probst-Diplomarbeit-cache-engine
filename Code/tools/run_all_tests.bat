@echo off
REM V34.C.1 (2026-05-21) + V35.C.1 + V35.E.2 (2026-05-22) - All-in-one Test-Runner (Windows)
REM
REM V35.E.2: nach Code\tools\ verschoben (vorher: tools\ im Diplomarbeit-Repo-Root)
REM
REM Verwendung (aus Diplomarbeit-Repo-Root):
REM   Code\tools\run_all_tests.bat                     REM autodetect
REM   Code\tools\run_all_tests.bat --config Debug
REM   set BUILD_TYPE=Debug && Code\tools\run_all_tests.bat
REM
REM Build-Type-Resolution: CLI --config > ENV BUILD_TYPE > Autodetect
REM   Autodetect-Reihenfolge: Release > Debug > RelWithDebInfo > MinSizeRel > <single-config>

setlocal enabledelayedexpansion
set "CODE_ROOT=%~dp0.."
set "REPO_ROOT=%CODE_ROOT%\.."

set "BUILD_TYPE_OVERRIDE="
:parse_args
if "%~1"=="" goto args_done
if "%~1"=="--config" (
    set "BUILD_TYPE_OVERRIDE=%~2"
    shift
    shift
    goto parse_args
)
if "%~1"=="-h" goto show_help
if "%~1"=="--help" goto show_help
echo unknown arg: %~1 1>&2
exit /b 2
:show_help
echo Usage: run_all_tests.bat [--config Release^|Debug^|RelWithDebInfo^|MinSizeRel]
exit /b 0
:args_done

if not "%BUILD_TYPE_OVERRIDE%"=="" (
    set "DESIRED_BUILD_TYPE=%BUILD_TYPE_OVERRIDE%"
) else (
    set "DESIRED_BUILD_TYPE=%BUILD_TYPE%"
)

pushd "%CODE_ROOT%"

set TOTAL_PASS=0
set TOTAL_FAIL=0
set TOTAL_NOT_FOUND=0
set "RESOLVED_BUILD_TYPE="

set "CE_BUILD=external\comdare-cache-engine\build\msvc-release"
if not exist "%CE_BUILD%" set "CE_BUILD=..\..\Projekte\Research\comdare-cache-engine\build\msvc-release"
set "CE_TESTS=%CE_BUILD%\libs\cache_engine\builder\commands\tests"

set "PA_BUILD=external\comdare-prt-art\build\msvc-release"
if not exist "%PA_BUILD%" set "PA_BUILD=..\..\Projekte\Research\comdare-prt-art\build\msvc-release"
set "PA_TESTS=%PA_BUILD%\tests\unit"

set "DA_BUILD=build\msvc-release-v32"
set "DA_TESTS=%DA_BUILD%\tests"

echo.
echo === comdare-cache-engine V32/V34 ===
echo.
call :run_test_exe "test_permutation_flags_v32" "%CE_TESTS%"
call :run_test_exe "test_commands"              "%CE_TESTS%"
call :run_test_exe "test_engine_adapters"       "%CE_TESTS%"

echo.
echo === comdare-prt-art V33/V34 ===
echo.
call :run_test_exe "test_default_lookup_registry" "%PA_TESTS%"
call :run_test_exe "test_leaf_only_counter"       "%PA_TESTS%"

echo.
echo === Diplomarbeit V33/V34 ===
echo.
call :run_test_exe "test_v32_orchestrator"           "%DA_TESTS%"
call :run_test_exe "test_messreihe_v32_validator"    "%DA_TESTS%"
call :run_test_exe "test_dataset_filter"             "%DA_TESTS%"
call :run_test_exe "test_messreihe_report_exporter"  "%DA_TESTS%"

echo.
echo === Diplomarbeit V35.D Per-Stage-Fixtures ===
echo.
set "DA_03=%DA_BUILD%\03_binary_to_csv"
set "DA_04=%DA_BUILD%\04_csv_to_latex"
set "DA_05=%DA_BUILD%\05_diagram_generator"
set "DA_06=%DA_BUILD%\06_latex_to_pdf"

call :run_test_exe "test_03_binary_to_csv_cached_fixtures"    "%DA_03%"
call :run_test_exe "test_04_csv_to_latex_cached_fixtures"     "%DA_04%"
call :run_test_exe "test_05_diagram_generator_cached_fixtures" "%DA_05%"
call :run_test_exe "test_06_latex_to_pdf_cached_fixtures"     "%DA_06%"

echo.
echo === Bilanz V35.C all-in-one ===
echo.
if "!RESOLVED_BUILD_TYPE!"=="" set "RESOLVED_BUILD_TYPE=^<none-found^>"
if "!DESIRED_BUILD_TYPE!"=="" set "DISPLAY_OVERRIDE=^<autodetect^>"
if not "!DESIRED_BUILD_TYPE!"=="" set "DISPLAY_OVERRIDE=!DESIRED_BUILD_TYPE!"
echo Build-Type: !RESOLVED_BUILD_TYPE!  (Override: !DISPLAY_OVERRIDE!)
echo passed:  !TOTAL_PASS!
echo failed:  !TOTAL_FAIL!
echo not found: !TOTAL_NOT_FOUND!

popd
if !TOTAL_FAIL! GTR 0 exit /b 1
exit /b 0

:run_test_exe
REM args: %~1 = test_name, %~2 = base_dir
set "TEST_NAME=%~1"
set "BASE_DIR=%~2"
set "EXE="
REM 1. Pruefe Override-Pfad
if not "%DESIRED_BUILD_TYPE%"=="" (
    if exist "%BASE_DIR%\%DESIRED_BUILD_TYPE%\%TEST_NAME%.exe" set "EXE=%BASE_DIR%\%DESIRED_BUILD_TYPE%\%TEST_NAME%.exe"
)
REM 2. Autodetect
if "!EXE!"=="" (
    for %%C in (Release Debug RelWithDebInfo MinSizeRel) do (
        if "!EXE!"=="" if exist "%BASE_DIR%\%%C\%TEST_NAME%.exe" (
            set "EXE=%BASE_DIR%\%%C\%TEST_NAME%.exe"
            if "!RESOLVED_BUILD_TYPE!"=="" set "RESOLVED_BUILD_TYPE=%%C"
        )
    )
)
REM 3. Single-config Fallback
if "!EXE!"=="" (
    if exist "%BASE_DIR%\%TEST_NAME%.exe" set "EXE=%BASE_DIR%\%TEST_NAME%.exe"
)
if "!EXE!"=="" (
    echo   [NOT FOUND] %TEST_NAME%
    set /a TOTAL_NOT_FOUND+=1
    goto :eof
)
"!EXE!" --gtest_brief=1 > "%TEMP%\v35c_out.txt" 2>&1
findstr /C:"[  PASSED  ]" "%TEMP%\v35c_out.txt" >nul && (
    REM extrahiere Zahl mit for
    for /f "tokens=4" %%n in ('findstr /C:"[  PASSED  ]" "%TEMP%\v35c_out.txt"') do set "P=%%n"
    set /a TOTAL_PASS+=!P!
    echo   [ OK ] %TEST_NAME%  -^> !P! passed
) || (
    echo   [FAIL] %TEST_NAME%
    type "%TEMP%\v35c_out.txt" | findstr /R "FAILED" | head
    set /a TOTAL_FAIL+=1
)
goto :eof
