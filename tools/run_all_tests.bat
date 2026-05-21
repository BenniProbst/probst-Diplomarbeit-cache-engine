@echo off
REM V34.C.1 (2026-05-21) - All-in-one Test-Runner (Windows)
REM
REM Verwendung:
REM   tools\run_all_tests.bat
REM
REM Aggregiert ctest-Ergebnisse aus den 3 Repos.

setlocal enabledelayedexpansion
set "REPO_ROOT=%~dp0.."
pushd "%REPO_ROOT%"

set TOTAL_PASS=0
set TOTAL_FAIL=0
set TOTAL_SKIP=0

call :run_ctest "comdare-cache-engine V32/V34" "Code\external\comdare-cache-engine\build\msvc-release"
call :run_ctest "comdare-prt-art V33"          "Code\external\comdare-prt-art\build\msvc-release"
call :run_ctest "Diplomarbeit V33/V34"         "Code\build\msvc-release-v32"

echo.
echo === Bilanz V34.C all-in-one ===
echo.
echo passed:  !TOTAL_PASS!
echo failed:  !TOTAL_FAIL!
echo skipped: !TOTAL_SKIP!
echo.

popd
if !TOTAL_FAIL! GTR 0 exit /b 1
exit /b 0

:run_ctest
echo.
echo === %~1 ===
echo.
if not exist "%~2" (
    echo SKIP: build directory not found: %~2
    set /a TOTAL_SKIP+=1
    goto :eof
)
ctest --test-dir "%~2" -C Release --output-on-failure
REM ctest exit-code = 0 wenn alle gruen
if !errorlevel! EQU 0 (
    echo Tests in %~1 passed.
) else (
    set /a TOTAL_FAIL+=1
)
goto :eof
