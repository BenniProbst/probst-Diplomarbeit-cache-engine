# MANUAL_RUN — Lösung selbst bauen + ausführen (User-Self-Test)
\n> **HINWEIS (2026-07-26, V-0):** Der Permutations-Codegen-Kanal (`comdare_perms_all`, V36.B) ist per
> Owner-Entscheid (Diplom-Ledger §71/§73) RETIRED und wird in den Fassaden-/Planer-Kanal gemerged.
> Die `comdare_perms_all`-Schritte in diesem Manual sind ÜBERGANGSWEISE noch nötig (bis Bauplan
> TEIL V Paket V-2/V-3 den Manifest-Konsum abgelöst hat) und entfallen danach. Master-Manual = `../MANUAL_RUN.md`.

> **Zweck:** den kompletten Mess-/Auswerte-Lauf **von Hand** durchführen, um die Thesis-Ergebnisse selbst zu validieren. Autoritativ über `USAGE.md` (teils stale). **v1, Codex-ermittelt 2026-06-27 — beim ersten Hand-Lauf verifizieren + Abweichungen hier korrigieren** (Memory `feedback_solution_manually_operable_for_user_self_test`; Lücken-Detail: `docs/sessions/20260627-MANUAL-RUN-GAP-ANALYSE-CODEX.md`).

## 0. Voraussetzungen
- Windows + MSVC (VS 2022), CMake ≥ 3.2x, **PowerShell 7 (`pwsh`)**.
- **Boost.MP11 offline** unter `Code/external/comdare-cache-engine/cmake/third_party/boost_mp11/include` (Doku-24-Prerequisite — sonst bricht der cache-engine-Build ab).
- **Optional Real-Messung (Cache-Misses):** Intel PCM + Admin-Rechte (`-DCOMDARE_ENABLE_PMC=ON`). Ohne PMC = Timing-only-Smoke (läuft überall).
- **Optional PDF:** TeXLive/MiKTeX (`pdflatex`/`latexmk`).

## 1. Weg A (EMPFOHLEN): Profil-Flow — ein Profil, ein Kommando

> **DEPRECATED (2026-07-11):** Weg A ruft `build_and_measure_150_tiere.ps1` (Z.16/19/21) auf. Dieses Skript und
> ALLE ce-`*.ps1` wurden am 2026-07-11 bei der Behelfsweg-Bereinigung **entfernt** und sind **nicht mehr
> ausfuehrbar**. **Offizieller Weg heute ist Weg B (`messung_driver` / E4-XML-Profil, s. Abschnitt 3):** XML-Profil
> -> `Code/02_messung_driver`. Das "(EMPFOHLEN)" im Titel ist damit ueberholt; die Zeilen unten bleiben additiv als
> historischer Stand erhalten.

```powershell
cd "Code\external\comdare-cache-engine"
cmake --preset msvc-release
# (a) Profil validieren (Exit 0 = ok, sonst klare Achse+Wert-Meldung):
pwsh .\tests\unit\thesis_tiere\build_and_measure_150_tiere.ps1 -Validate `
  -Profile ".\libs\cache_engine\algorithm_profiles\thesis_profiles\m3v2_study.profile.xml"
# (b) Selbsttest (kleiner Pilot, baut Host + wenige Tiere):
pwsh .\tests\unit\thesis_tiere\build_and_measure_150_tiere.ps1 -RunTest
# (c) Kleiner echter Mess-Lauf:
pwsh .\tests\unit\thesis_tiere\build_and_measure_150_tiere.ps1 `
  -Profile ".\libs\cache_engine\algorithm_profiles\thesis_profiles\m3v2_study.profile.xml" `
  -MaxBinaries 4 -NOps 2000 -NRepeats 1 -WorkingSetN 16384 -RebuildHost
# Ergebnis-CSV: build\thesis_tiere\...
```
(Das Script leitet seinen Repo-Pfad seit 2026-06-27 aus `$PSScriptRoot` ab → läuft portabel, KEIN Pfad-Edit nötig.)

## 2. CSV → Tabelle/Diagramm (TeX)
```powershell
cd "Code"
cmake --preset msvc-release -DCOMDARE_EXPERIMENT_MODE=ON
cmake --build --preset msvc-release --target csv_to_latex_cli diagram_generator_cli
$csv = ".\external\comdare-cache-engine\build\thesis_tiere\<deine>.csv"
.\build\msvc-release\04_csv_to_latex\Release\csv-to-latex.exe $csv ".\build\manual\table.tex" --schema=wide --lang=de
.\build\msvc-release\05_diagram_generator\Release\diagram-generator.exe --surface=ns_per_op $csv ".\build\manual\surface.tex" --lang=de --body-only
```
(PDF: `Code\06_latex_to_pdf\build_thesis.bat` mit `--source/--output/--main`; TeXLive vorausgesetzt.)

## 3. Weg B: messung_driver (mehr Kontrolle — nach den offenen Fixes)
```powershell
cd "Code"
cmake --preset msvc-release -DCOMDARE_EXPERIMENT_MODE=ON
cmake --build --preset msvc-release --target comdare_perms_all      # ZWINGEND zuerst — sonst bricht der Driver ab (Manifeste fehlen)
cmake --build --preset msvc-release --target messung_driver binary_to_csv_cli csv_to_latex_cli diagram_generator_cli
.\build\msvc-release\02_messung_driver\Release\comdare-messung-driver.exe `
  ".\external\comdare-cache-engine\libs\cache_engine\builder\example_configs" `   # config_dir = example_configs (NICHT Code\experiment_config)
  "_runs\manual" --comdare-root="$PWD\external\comdare-cache-engine" `
  --messreihen-xml="$PWD\experiment_config\messreihen.xml"
```

## 4. Smoke vs. Real
- **Smoke** (Standard): ohne `COMDARE_ENABLE_PMC` → reine Timing-Messung, überall lauffähig.
- **Real**: `-DCOMDARE_ENABLE_PMC=ON` + Intel PCM + Admin → echte Cache-Misses/PMC.

## 5. Bekannte Lücken (Stand 2026-06-27 — Task #193)
1. `COMDARE_EXPERIMENT_MODE=ON` ist NICHT Preset-Default → in jeder Build-Zeile mitgeben (oder Preset `_base` ergänzen).
2. `USAGE.md` teils stale (alte Targets/Exe/CLI) → **diese Datei ist autoritativ**.
3. `ExperimentDriver` SOTA-Profil-Pfad ggf. auf `libs/cache_engine/algorithm_profiles/sota` anpassen.
> **Verifikation:** „manuell bedienbar" gilt erst, wenn (a)→(b)→(c)→§2 bei dir literal grün durchläuft. Bitte Abweichungen direkt hier eintragen.
