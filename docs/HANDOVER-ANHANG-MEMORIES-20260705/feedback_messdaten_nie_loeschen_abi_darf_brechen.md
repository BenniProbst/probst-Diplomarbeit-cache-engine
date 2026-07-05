---
name: feedback_messdaten_nie_loeschen_abi_darf_brechen
description: "Mess-Daten werden NIE gelöscht; ABI/Schema DARF brechen (nicht nur additiv), einzige harte Grenze = alte Messdaten erhalten"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 78cf67f8-571e-4fcd-a907-1556dbc5be72
---

KRITISCHE USER-DIREKTIVE (2026-06-19): **Echte Messdaten werden NIEMALS gelöscht oder „ersetzt".** Anlass: ich hatte (von einem Lese-Agenten übernommen) gesagt „die 120.960-Zeilen-cowfix-v1-Matrix ist inkompatibel zu m3v2 und wird vom m3v2-Lauf ERSETZT" → User: „Um gottes willen nein".

**Die Regel, präzise (User-Klarstellung):** Eine **weitere Tabelle** messen + erstellen ist ok; das **ABI-stabile Interface DARF geändert werden — und NICHT nur additiv** (ein brechender Schema-/ABI-Wechsel ist erlaubt). Die **EINZIGE harte Grenze:** die alten Messdaten **nicht löschen**.

**Why:** Ein 3-Tage-Mess-Lauf (cowfix-v1, echte Daten) ist kostbar und darf nie verfallen; eine korrigierte Neumessung (m3v2) tritt als zweite Generation DANEBEN, ersetzt die alte nicht physisch.

**How to apply:**
- m3v2 schreibt in eine **SEPARATE** Datei (Default `build_version=m3v2`), NIE in die cowfix-v1-Backup-Datei resumen/appenden. `Messdaten-Backup/tier150_measurements_INDEX320_cowfix-v1_2026-06-18.csv` (166 MB, git-LFS + NAS) bleibt unveränderlich.
- Generationen via **`build_version`-Spalte** unterscheiden + in EINER Logik-Matrix vereinen; cowfix-v1 bleibt valide Baseline + Vergleichs-Kontribution.
- **DLL-ABI vs CSV-Daten NIE verwechseln:** ein Anatomie-ABI-Major-Bump (Snapshot-Version 4→5, `COMDARE_ANATOMY_ABI_MAJOR`) macht nur **DLL-Binärartefakte** inkompatibel → Loader-Reject (`FreeLibrary`/`dlclose`) → **neu gebaut**; KEIN Code-Pfad berührt je ein `.csv`. „inkompatibel" gilt nur für DLLs, nie für geschriebene Mess-Zeilen.
- Das CSV-WIDE-Schema ist faktisch **additiv** (`lazy_csv_header()` cache_engine_builder_iterator.hpp:166-199): m3v2 = 162 Spalten = 154 cowfix-v1-Spalten namens-/reihenfolge-identisch + 3 seg_coverage + 5 Tags. Die Analyse-Pipeline ist **header-getrieben** (`parse_wide_csv`, Name→Index) → liest beide Generationen. (Additivität ist NICHT erzwungen — der User erlaubt Brechen — aber sie ist der saubere Ist-Zustand.)
- **„ersetzt"/„verworfen" sind verbotene Formulierungen** für jede Mess-CSV-Matrix. In Docs getilgt: `20260618-M3v2-NEUMESSUNG-DESIGN-SPEC.md` §2, `GOAL-AUTONOM-ABARBEITUNG-20260613.md`:95-96.

Siehe [[project_pmc_cache_misses_windows_linux_gitlab_strategy]] (Cache-Misses=Kernmetrik, künftige additive PMC-Spalten) und [[feedback_no_success_marks_without_literal_output]].
