# CODEX-VERDIKT E18-SNAP-NB (1ae02cdf): NICHT-LANDEN -- 06.08.2026 ~10:50

Codex-Thread 019fd696-2e4f-7af0-b3d3-70145cb7f359, Diff eb3d285a..1ae02cdf (ci/), voller Skript-Kontext.

## Verdikt (woertlich)
"NICHT-LANDEN. Von den sechs Altbefunden ist nur MITTEL-2 im engen Sinn vollstaendig behoben. HOCH-1 und HOCH-2 bleiben blockerwuerdig; HOCH-3 garantiert weiterhin keine echte Re-Ernte."

## Status der 6 NB-Heilungen
1. HOCH-1 Beleg-Entkopplung: TEILWEISE (Rest HOCH) -- Retry prueft nur AKTUELLEN 289-HEAD (Lauf-A-Compile nach Fremd-Push unrekonstruierbar); Belegpruefung zu schwach (irgendeine QUELLSTAND-Zeile genuegt, remote git-grep ueber ALLE Dateien, Halb-Ordner geht als Beleg durch); copied=0 beendet vor der Nachhol-Wache.
2. HOCH-2 Kollisions-Lock: NEIN (HOCH) -- mkdir-Lock ist NICHT runneruebergreifend (getrennte Dateisysteme, beide sehen Remote frei); keine atomare verteilte Reservierung; Nachhol-Fenster besonders gross.
3. HOCH-3 Re-Fixierung: TEILWEISE (Rest HOCH) -- Re-Ernte nicht garantiert frisch: nur AF_SNAP_STAGE geloescht, latexmk ohne Clean/Force kann "Nothing to do" liefern -> ALTE PDF mit PUSHED_SHA beschriftet. Noetig: latexmk -gg / frisches Output-Verzeichnis.
4. MITTEL-1 errexit: TEILWEISE -- top_abs/snap_abs/ts ungeprueft; af_sha256-Doppelfehler vergleicht ""=="" -> Uebereinstimmung; AF_NO_PUSH-Pfad kann LEEREN SHA schreiben (thesis_commit_sha= besteht die Pruefung).
5. MITTEL-2 AF_SNAPSHOT_ROOT: GEHEILT. Neuer Randbefund: "muss im 288-Baum liegen" nicht durchgesetzt (fremdes Repo/ausserhalb Repo wird akzeptiert; Toplevel-Gleichheit nicht erkannt) -> Job gruen obwohl Writeback nicht persistieren kann (MITTEL).
6. MITTEL-3 Rollback: TEILWEISE -- TOCTOU exists->cp; frueher exit 1 ohne zentralen Rollback; doppelte AF_LANGS-Eintraege verderben Restore-Reihenfolge; '|' in AF_LANGS beschaedigt Rollback-Protokoll.

## Weitere Kernbefunde
- Stale-Halbzustand: mkdir erzeugt den ENDGUELTIGEN Ordner ohne Owner-Marker/Trap/Cleanup; jeder mkdir-Fehler (EACCES/ENOSPC/...) wird 99x als "Kollision" gedeutet -> Liveness.
- Remote-Fehler FAIL-OPEN (git-grep/cat-file-Fehler = "frei") -- widerspricht Dateikopf.
- Idempotenz: schreiben nie idempotent (immer neuer TS-Ordner); Stage nicht geleert (alte PDFs koennen einwandern); kein Re-Fetch zwischen Belegtest und Schreiben (Duplikate); AF_SNAP_REMOTE_INIT=1 VOR Erfolg gesetzt (sticky-Fehler); FETCH_HEAD als Referent austauschbar.
- git-grep PATHSPEC: Glob-Zeichen in AF_SNAP_REL nicht literal; AF_PROV_SUPER_SHA="NA" unvalidiert; AF_NO_PUSH kann permanenten Beleg auf nie gelandete 289-SHA erzeugen.
- Pruefgrenze: aeusserer 288-Writeback (Vollstaendigkeitswache, kein breites git add auf Teilordner) war NICHT im Diff -- bei NB2 mitpruefen.

## NB2-MINDESTANFORDERUNGEN (Codex woertlich, 5 Punkte)
(1) runneruebergreifend eindeutige Namen ODER echte atomare Remote-Reservierung; (2) dauerhafte Recovery-Identitaet fuer die URSPRUENGLICH gepushte 289-SHA (nicht nur aktueller HEAD); (3) gemeinsamer Validator PDF+Export+QUELLSTAND+Hash; (4) erzwungene Re-Kompilation aus dem gepushten Stand (latexmk -gg o.ae.); (5) transaktionales Cleanup eigener unveroeffentlichter Teilordner + vollstaendige Fehlerpruefung ausserhalb von set -e.

EINORDNUNG: E18-SNAP ist P4 (nach Trigger) und der Job ist INERT bis zur B-5-Scharfschaltung -- KEIN Blocker des kritischen Pfads. NB2-Welle im P4-Fenster VOR der Scharfschaltung; einfachste Erfuellung von (1): Runner-ID/Job-ID in den Ordnernamen (runneruebergreifend eindeutig, ohne verteilte Reservierung).
