# SESSION-Beleg E-21-Erst-Vollzug (02.08.2026, ~18:3x CEST) — STACK-Form der Tasks-Liste + V7.6-Verankerung

> Erst-Vollzug der V7.6-SICHTBARE-TODO-DOKTRIN (LEDGER:103, eingehängt nach V7.5; Owner-E-21 verbatim aus dem Wahrheits-Anker :101-104, PFLICHT seit Owner-R7 02.08.). Entwurfs-Quelle: Welle-2a-Paket E21-Regeln (`backups/20260802-bauplan-welle2a-workflows/`), Lead-Vollzug durch den Manager. Variante A (flach, ohne neuen Wurzel-Sammel-Task) per Entwurfs-Empfehlung.

## Vorher/Nachher-Tabelle (aus der TaskList-Tool-Ausgabe abgeleitet, nicht handgepflegt)

| # | ALT (literal) | NEU (literal) | Status |
|---|---|---|---|
| 7 | ce-TP1 pushen nach Truth-Check-PASS (dev, main-FF, Gitlink-Bump) | unverändert (completed, vor Umstellung abgeschlossen) | completed |
| 8 | Bauplan-Welle 1 starten (nach Limit-Reset 12:30 UTC): OS-U1/U2, A13-M1, FK-0, HY-D1/D2 | [S0] Bauplan-Welle 1: OS-U1/U2 + A13-M1 + FK-0 + HY-D1/D2 — GELANDET+GEPUSHT (ce e859bac7, CI 279 grün) | completed |
| 9 | TP1-Nachbesserung: N1 Sweep-Haertung, N2 B-1 Push-Sichtbarkeit, N3 B-2/B-3 + Iterator-Anker | unverändert (completed, vor Umstellung abgeschlossen) | completed |
| 10 | F3-Testschuld: Iterator-Test für B-1-Verdrahtung (werfender Push → Eintrag nicht registriert) | [S1] (Folgeschuld) F3-Testschuld: Iterator-Test für B-1-Verdrahtung (werfender Push → Eintrag nicht registriert) | pending |
| 11 | A13-M1b: Flag-Grammatik-Umbau (Owner-Q3-final) — Kurzform-Rückbau + HW-Flag-Pflicht | wird nach Wellen-Grün als completed gepoppt (gelandet in 7603453b inkl. Manager-Fixup) | pending→completed |
| 12 | — (neu) | [S0] Bauplan-Welle 2a seriell landen: M1b+FK-1+FK-2 (16 Commits + Fixup) + E02 + E21-Vollzug | in_progress |

Regeln des Vollzugs eingehalten: nur subject umbenannt bzw. additiv neu; kein Merge, keine Löschung, Status nur wo real vollzogen (Welle 1 ist gelandet+CI-belegt). Rest-Stack = #10 (Folgeschuld), #11 (Pop nach Wellen-Grün), #12 (Wurzel der laufenden Front).

## Drei-Ebenen-Verankerung (vollzogen)

1. **Normativ:** LEDGER **V7.6** (Z.103) — STACK/LIFO-Regeln (i), VERBOSE-Rückfragen (ii), VOLL-PERSISTENZ (iii); Nummern-Kollision V5.8 im Entwurf erkannt und als V7.6 aufgelöst (V5.8 historisch TABU-Kern-belegt).
2. **Kontext-übergreifend:** Memory `feedback_todo_stack_lifo_verbose_owner_fragen_vollpersistenz.md` + MEMORY.md-Zeile; zusätzlich Vier-Ledger-Audit-Nachtrag an `feedback_immer_ledger_zuerst_lesen_vor_handeln` UND `feedback_before_each_todo_agent_reads_full_ledger_then_manual_details` (E-02/A16-Auflage).
3. **Beleg-Ebene:** dieses Doc.

Offener Entwurfs-Punkt (Owner-frei): Parallel-Wellen-Strang-Präfix `[S1|Lager]` (Punkt (i).8) ist Manager-Ergänzung, nicht Owner-Wortlaut — gilt als Default, Einspruch möglich.
