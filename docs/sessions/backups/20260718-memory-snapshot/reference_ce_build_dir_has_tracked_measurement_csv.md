---
name: reference_ce_build_dir_has_tracked_measurement_csv
description: ce build/ enthält force-added getrackte Mess-CSV — vor rm -rf build IMMER git ls-files build/ prüfen
metadata: 
  node_type: memory
  type: reference
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

Im ce-Repo (`Code/external/comdare-cache-engine`) ist `build/` per `.gitignore` ignoriert, ABER es gibt mindestens **eine force-added getrackte Ausnahme**: `build/thesis_tiere/tier150_measurements.csv` (~6.7 MB Messdaten). Ein blindes `rm -rf build` löscht diese getrackte Datei aus dem Working-Tree (`git status` zeigt ` D`) und verletzt „Messdaten nie löschen" [[feedback_messdaten_nie_loeschen_abi_darf_brechen]].

**Regel vor jedem `rm -rf build` (clean rebuild):** erst `git -C <ce> ls-files build/` (oder `git status --short | grep '^ D'` danach) prüfen; getrackte build/-Dateien vorher sichern ODER nach dem rm mit `git checkout -- <pfad>` sofort wiederherstellen. Am 2026-07-17 einmal passiert + sofort per `git checkout` restauriert (0 Datenverlust). Clean rebuilds sind bei Achsen-Zahl-Änderungen (z.B. INC-2c 19→18) nötig, weil der Adhoc-Emitter-Cache in `build/generated/` stale 19-Arg-Module hinterlässt — also wird `rm -rf build` weiter vorkommen.
