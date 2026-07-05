---
name: reference_buildsystem_scripts_posix_no_grep_p
description: "cd-buildsystem Bash-Skripte nutzen grep -oP/-ozP (PCRE mit \\K und (?s)) für XML-Parsing — funktioniert NUR auf GNU-grep+UTF-8-Locale (Linux-CI), bricht STUMM (2>/dev/null) auf msys(Windows)/Alpine(busybox)/macOS(BSD) → leerer Parse. Portabel via grep -o+sed (Primitive) + awk index() (Blöcke). Dijkstra-Smoke-Test war deshalb nie grün; Discovery-Agenten hatten ihn NICHT ausgeführt, nur behauptet. Meta: Tests durch AUSFÜHREN verifizieren."
metadata:
  node_type: memory
  type: reference
  originSessionId: c6f15797-7fa1-4e66-874f-55631afe1d28
---

**Buildsystem-Portabilitäts-Falle (2026-07-03, verifiziert):** Die Bash-Parser des `cd-buildsystem` (z.B. `dependency-manager/scripts/dependency_resolver.sh`) parsen XML mit **`grep -oP "<tag>\K[^<]+"`** und **`grep -ozP "(?s)<block>.*?</block>"`**. `-P` (PCRE), `\K` und `(?s)` sind **GNU-grep-only + brauchen UTF-8/unibyte-Locale**. Auf **msys(Windows-Git-Bash)** wirft es `grep: -P supports only unibyte and UTF-8 locales`; **Alpine/busybox** + **macOS/BSD grep** kennen `-P` gar nicht → jeweils **leerer Extract**, und `2>/dev/null` verschluckt den Fehler → Folgefehler „empty node name" + falsche „Circular dependency". Auf Linux-CI (GNU-grep, UTF-8) läuft es → der Bug ist auf Nicht-Linux-Ziele (die das Buildsystem laut 8er-Docker-Matrix + mac/RISC-V explizit anpeilt) begrenzt, aber real.

**Portabler Ersatz (angewandt in `dependency_resolver.sh`, commit 6964ee7):**
- Element-Text: `printf '%s\n' "$xml" | grep -o "<${el}>[^<]*" | head -1 | sed "s|^<${el}>||"`
- Attribut: `... | grep -o "${a}=\"[^\"]*\"" | head -1 | sed "s|^${a}=\"||; s|\"\$||"`
- Multi-Line-Block: awk-Helper `_comdare_xml_block` mit `index($0,"<t>"){f=1} f{print} index($0,"</t>"){exit}` (POSIX, kein Regex).
- Plus `.gitattributes` `*.sh/*.cmake text eol=lf` (Skripte auf Windows-Checkout sonst CRLF).

**STAND 2026-07-03: 5 Module portabel** (dependency-manager 3 Dateien, core interface.sh+lib/local_root.sh, compiler-manager, package-manager — je bash -n OK, 0 grep-P, beide Remotes). Nebenbefund: `'name="\\K'`-Doppelescape war latent auch auf Linux kaputt. **GROSSER REST = `build-utilities` Referenz-Parser** `scripts/xml_parser.sh` (~60) + `xml_load.sh` (~30) = ~90 variantenreiche Stellen → **dedizierte systematische Welle** (Codex-Sweep bewährtes Muster ODER verifizierter Transform; Gate=Parser-Selbsttests). Nicht Resolver-/NOTFALL-kritisch. Plus 2 Multi-Block-Fallbacks (resolver:915, downloader:681). Test-Gate Resolver: `tests/run_dijkstra_smoke.sh` (grün).

**META-LEKTION:** Read-only-Discovery-Agenten nannten den Smoke-Test „lauffähig", hatten ihn aber NIE ausgeführt — er war rot. **Tests/Behauptungen über Lauffähigkeit immer durch tatsächliches Ausführen verifizieren** ([[feedback_no_success_marks_without_literal_output]], [[feedback_verify_ist_state_before_gross_tasks]]). Gehört zu [[project_comdare_db_maintenance_standard_and_buildsystem_escalation]].
