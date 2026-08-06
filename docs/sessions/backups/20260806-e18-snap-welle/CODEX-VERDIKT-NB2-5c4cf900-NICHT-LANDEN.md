# CODEX-VERDIKT E18-SNAP-NB2 (5c4cf900): NICHT-LANDEN -- 06.08.2026 ~13:00

Codex-Thread 019fd70f-a625-7603-b546-cc7629b69751, Diff 1ae02cdf..5c4cf900 (ci/ + docs/).

## PRUEFGRENZE (bindend fuer die Bewertung)
Codex hatte **Datei-/Blob-Lesezugriff, aber KEIN Shell-Exec** (bwrap-Loopback). Die Fixture proben-nb2.sh konnte NICHT ausgefuehrt werden -- alle Befunde stammen aus Code-Lesung, nicht aus Verhalten. Der Lens-Agent hat 2 Zitate stichprobenartig gegen die echten Dateien geprueft (core.sh:769-816, .gitlab-ci.yml:1095-1113) -- beide wortgleich, also keine Halluzination.
**SPANNUNG ZUR BAU-EVIDENZ:** Der NB2-Bau-Agent hatte 91+56 Proben mit ALT/NEU-Gegenproben LITERAL gefahren (echtes TeXLive, echte bare-Remotes). Beides kann zugleich wahr sein: die Proben belegen die GEPRUEFTEN Pfade, Codex findet ANDERE Pfade (v.a. 'nachholen' vs 'recovery'), die die Proben nicht abdecken. Bei der Umsetzung daher je Befund ZUERST reproduzieren.

## Verdikt (woertlich)
"NICHT-LANDEN. Die Anforderungen 2-5 sind nicht vollstaendig erfuellt; besonders die falsche Remote-Belegakzeptanz, der nicht erzwungene Nachhol-Bau, fail-open Fetch, .tmp-False-Positive und die unvollstaendige Recovery-Identitaet sind landeblockierend."

## Kurzurteil der 5 Mindestanforderungen
1. Eindeutige Namen -- TEILWEISE (CI-Kennung + mkdir-Fehlertrennung OK; lokale Host-Normalisierung nicht injektiv).
2. Recovery-Identitaet -- NICHT erfuellt (PENDING vor Push nicht dauerhaft im 288-REMOTE; fremde Marker nie erfuellt [Pfadverlust]; Submodule/Dirty-State ungesichert).
3. Beleg-Validator -- NICHT erfuellt (remote koennen LEERE/fehlende Belegdateien gueltig wirken: cat-file -e prueft nur Existenz; fehlender PDF-Blob -> sha256 des LEEREN Stroms; errefit im if-Kontext aus).
4. Zwangs-Rebuild -- NICHT erfuellt (GATE_ZWANG nur bei AF_MODE=recovery; 'nachholen' und normaler Vorwaertslauf ohne -gg/Neuheitswache -> Alt-PDF kann dem aktuellen HEAD zugeschrieben werden).
5. Transaktion/fail-closed -- NICHT erfuellt (Erst-Fetch-Fehler = fail-open, setzt INIT=1 -> Re-Fetch wird No-op; SIGKILL-.tmp gilt beim Retry als Beleg; mv ist check-then-rename, kein atomares no-clobber).

## Weitere HOCH-Befunde
- CI-INTEGRATION NICHT WIRKSAM (.gitlab-ci.yml:1098-1113): der Writeback-Patch ist NICHT angewandt -> Snapshot+PENDING werden nicht gestagt, der Ordner stirbt am Pipeline-Ende. KONTEXT-Befund (Datei ausserhalb des Diff-Scopes), aber landeentscheidend: ohne Lead-Patch persistiert das Feature nichts.
- Recovery bei rotem 289-Fetch kann nie gelandete SHA belegen (Erreichbarkeitspruefung entfaellt).
- Detached-Recovery ohne submodule update/Cleanliness-Pruefung; Rueckweg mit checkout --force kann fremden getrackten Zustand zerstoeren.
- Git-Index vor dem Commit nicht geleert -> fremd Vorgestagtes wandert in den Commit (git add-Fehler zusaetzlich per || true verschluckt).
- Recovery haengt an vorhandener Anhangquelle (:424-430 exit 0 VOR Remote-Wache/PENDING/Bot-Historie) -- genau die Entkopplung, die HOCH-1 heilen sollte, greift dann nicht.
- Bestehende Ziel-Symlinks umgehen die Whitelist (cp folgt dem Symlink; noclobber schuetzt nur nicht-existente Pfade).

## MITTEL (Auswahl)
TeX-loser Nachhol-Pfad meldet Erfolg ohne Beleg · trap ohne Signal-Reraise + Tmp-Eigentum nur per Pfad statt Token · AF_SNAP_ROOT_STRICT: fremdes Repo akzeptiert, check-ignore-RC1 nicht von Fehler unterschieden, TeX-loser Runner kann faelschlich rot werden · Rollback nur fuer den einen getesteten cp-Abbruch · Bash-case `[0-9a-f]*` prueft NUR das erste Zeichen (gilt fuer 40- UND 64-stellige SHAs!) · Prozesssubstitutions-Fehler unsichtbar · AF_LANGS: Pfadschleifen nutzen das deduplizierte Array, der GENERATOR (:406) bekommt weiterhin die ROHE Variable.

## LEAD-EINORDNUNG
E18-SNAP ist **P4 (nach Trigger) und der CI-Job ist INERT** -- KEIN Blocker des kritischen Pfads. NB3 gehoert ins P4-Fenster, NICHT vor den Trigger. Bei der NB3-Welle gilt: (1) jeden Befund zuerst mit einer PROBE reproduzieren (Bau-Evidenz vs Code-Lesung, s. Pruefgrenze); (2) die Proben-Suite um die von Codex genannten UNGEPRUEFTEN PFADE erweitern (nachholen-Modus, Erst-Fetch-Fehler, SIGKILL-.tmp, Symlink-Ziel) -- das ist der eigentliche Ertrag dieses Verdikts; (3) der .gitlab-ci.yml-Patch (LEAD-ONLY) gehoert mit in dasselbe Fenster, sonst persistiert nichts.
