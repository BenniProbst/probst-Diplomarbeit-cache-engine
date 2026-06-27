# Manuelle Bedienbarkeit — Gap-Analyse + Fix-Plan (Codex gpt-5.5/xhigh, 2026-06-27)

> **Auslöser:** User konnte die Lösung NICHT manuell ausführen (Self-Test) — fehlende Anforderungen der letzten ~10 Tage. Memory `feedback_solution_manually_operable_for_user_self_test`. **Diese Datei = der konkrete Fix-Plan** (Codex-ermittelt, read-only; beim ersten echten Manual-Lauf verifizieren).

## Hauptbefund
ZWEI konkurrierende Manual-Wege: Doku zeigt überwiegend den ALTEN `messung_driver`-Pfad, der praktikable AKTUELLE Weg ist der **Profil-Flow** (`build_and_measure_150_tiere.ps1` + `m3v2_study.profile.xml`). Beide haben Lücken.

## A. Intended Manual Flow (aktueller Profil-Weg — empfohlen)
```powershell
cd "…\Code\external\comdare-cache-engine"
cmake --preset msvc-release
pwsh .\tests\unit\thesis_tiere\build_and_measure_150_tiere.ps1 -Validate -Profile ".\libs\cache_engine\algorithm_profiles\thesis_profiles\m3v2_study.profile.xml"
pwsh .\tests\unit\thesis_tiere\build_and_measure_150_tiere.ps1 -RunTest
pwsh .\tests\unit\thesis_tiere\build_and_measure_150_tiere.ps1 -Profile "…\m3v2_study.profile.xml" -MaxBinaries 4 -NOps 2000 -NRepeats 1 -WorkingSetN 16384 -RebuildHost
# CSV→TeX/Diagramm:
cd "…\Code"; cmake --preset msvc-release -DCOMDARE_EXPERIMENT_MODE=ON
cmake --build --preset msvc-release --target csv_to_latex_cli diagram_generator_cli
# csv-to-latex.exe <csv> <out.tex> --schema=wide --lang=de ; diagram-generator.exe --surface=ns_per_op <csv> <out.tex> --lang=de --body-only
```
(Alter `messung_driver`-Weg nur nach Fixes; config_dir = `libs\cache_engine\builder\example_configs`, NICHT `Code\experiment_config`.)

## B. Priorisierte Gap-Liste (Codex, file:line)
- **P0-1 Top-Level-Manual fehlt / Doku stale:** kein Root-README; `Code/USAGE.md:102` nennt falsche Targets/Exe-Namen. Reale Targets: `messung_driver`, `binary_to_csv_cli`, `csv_to_latex_cli`, `diagram_generator_cli`.
- **P0-2 `messung_driver` ohne Manifeste startet nicht:** bricht vor Config-Parsing ab (`02_messung_driver/main.cpp:216`, `permutations_runtime_check.hpp:104`) → vorher `cmake --build … --target comdare_perms_all` zwingend.
- **P0-3 `COMDARE_EXPERIMENT_MODE` fehlt in Presets:** `CMakePresets.json:14` setzt es nicht; cache-engine default OFF (`…/comdare-cache-engine/CMakeLists.txt:367`) → in `_base` setzen ODER je Commandline `-DCOMDARE_EXPERIMENT_MODE=ON`.
- **P0-4 Config/Profile-Pfade inkonsistent:** `messung_driver` config_dir erwartet 4 Builder-XMLs unter `libs\cache_engine\builder\example_configs` (`xml_config_parser.cpp:70`), nicht `Code\experiment_config`. SOTA-Profile: Driver sucht `cache_engine\algorithm_profiles\sota`, real `libs\cache_engine\algorithm_profiles\sota` (`experiment_driver.cpp:95`).
- **P0-5 Profil-Flow versteckt + Script hart verdrahtet:** nur in `…/comdare-cache-engine/docs/ERWEITERUNGS-LEITFADEN.md:17`; `build_and_measure_150_tiere.ps1` setzt `$repo` HART auf lokalen Absolutpfad + verlangt `build\msvc-release\generated`.
- **P1-6 USAGE-CLI-Args falsch** (binary-to-csv positional, nicht `--in/--out`; csv/diagram andere Optionen).
- **P1-7 PDF/TeXLive-Pfad stale** (`Code\06_latex_to_pdf\build_thesis.bat`, kein `latex_to_pdf_cli`; TeXLive/MiKTeX als Voraussetzung).
- **P1-8 PMC/Real-HW** nicht manual-tauglich getrennt (Smoke ohne PMC vs. Real-Messung mit PMC-Privilegien).

## C. Minimaler Fix-Satz (nächste Session, je Fix Codex-Review + echter Manual-Lauf-Verifikation)
1. **`Code/MANUAL_RUN.md`** (oder Root-README): primärer Flow = `build_and_measure_150_tiere.ps1 -Validate/-RunTest` + kleiner M3V2-Run + CSV→TeX/Diagramm. Smoke-ohne-PMC vs. Real-mit-PMC trennen.
2. **`Code/CMakePresets.json`:** `COMDARE_EXPERIMENT_MODE=ON` in `_base` (Verhaltensänderung → prüfen, ob global gewollt; sonst nur im Manual dokumentieren).
3. **`build_and_measure_150_tiere.ps1`:** `$repo` aus `$PSScriptRoot` ableiten statt Absolutpfad. ← **diese Session bereits angegangen (s.u.)**
4. **`Code/USAGE.md`:** Targets/Exe-Pfade/CLI-Args auf reale Namen korrigieren.
5. **`ExperimentDriver`:** SOTA-Profil-Fallback auf `libs/cache_engine/algorithm_profiles/sota` korrigieren ODER Manual-Pfad-Layout dokumentieren.

> **Verifikation Pflicht:** „manuell bedienbar" gilt erst als erfüllt, wenn ein echter Hand-Lauf der Kette (Validate→RunTest→kleiner Run→CSV→TeX) literal grün durchläuft (kein Erfolgsmark ohne Tool-Ausgabe).
