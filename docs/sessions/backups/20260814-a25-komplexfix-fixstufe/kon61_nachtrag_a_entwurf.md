## NACHTRAG 14.08.2026 -- KON61-NACHTRAG A (A2.5-FIX-STUFE): VERIFY-FUNDE F1-F4 BEHOBEN/VERBUCHT

**Anlass: adversarischer Verify des KF-Pakets (Urteil TRAEGT_MIT_FIXES; 4 Funde + 3 Deckungs-Kennzeichnungen).
A2.5-Stufe per Design Teil D: Verify-Funde im SELBEN Paket beheben (LUECKE=BEHEBUNG). EIN Schreiber beider
Worktrees, EIN Block via scripts/ledger_nachtrag.sh. Kein Push (Stufe 3 folgt). ce bleibt in dieser Stufe
UNBERUEHRT (HEAD 2a3b1eb0, alle Fixes super-seitig; kein erneuter Kombibau noetig -- Doku-/Probe-/BU-Fixes).**

(1) F1 BEHOBEN@853cea9a (super) -- SCHWERSTER FUND, Vor-Push-Blocker: ci/tests/frische_wache_probe.sh Fall F6
    forderte rc==0 der Ausbeute-Wache auf dem F6-Fixture (Altzelle mit Datenzeilen + Neuzelle 0 Datenzeilen,
    modus=voll), um die alte Maskierung zu belegen; die ##26-M==N-Haertung (96ff69d5, KF-S3.1, in KON61-01
    verbucht) macht die Ausbeute-Wache dort SELBST rot (vierter roter Zweig) -- der CI-Job
    test:frische-wache-probe (ohne allow_failure) waere nach dem Stufe-3-Push rot geworden. SCHWESTER-
    KOPPLUNGS-LEHRE: weder Phase 3 (nur die eigene Bissprobe umgebaut) noch Phase 4 (Meta-Gate enumeriert
    scripts/ci_*.sh + ci/*.sh maxdepth 1, ci/tests/ ausdruecklich ausgenommen) fuhr die ci/tests/-Probes am
    zusammengesetzten Stand. FIX: F6-Maskierungs-Beweis neu geschnitten -- LITERALE der Ausbeute-AUSGABE statt
    ihres Urteils (Summen-Literal mit Zahl-Anker; Verbot des Summen-Gate-Riss-Praefixes; kennungsblinder
    M==N-BEFUND); rc des Gegenstuecks nur dokumentiert, sein Urteil haelt ci/tests/mess_ausbeute_bissprobe.sh
    fest. T-1 ROT ZUERST am IST: rc=1, 'PROBE ROT: 1 von 14 Faellen gerissen.', '[ROT ]  F6'; Gegenprobe nach
    Fix: rc=0, 'PROBE GRUEN: 14 von 14 Faellen gehalten.', Selbstbiss 'NENNER SELBSTBISS: 4 Mutanten
    gefahren, 4 gefangen.'; K13 beidseitig (drei Koeder-Ausgaben reissen jeden der drei neuen Checks).
    Verify-Nenner der Kopplungs-Suche: 14 von 14 ci/tests/-Probes frisch gefahren, 13 gruen, exakt 1 rot --
    nach dem Fix 14 von 14 gruen.

(2) F3 BEHOBEN@1bb39761 (super) -- der dritte namentlich beauftragte S3.4-BU-Gegenstand
    'regressions-gesamtbild' war NICHT committet (git ls-files 0 Treffer, Gegenprobe 29 getrackte Dateien
    unter backups/20260814*; Quelle /tmp-Klasse = fluechtig, BU-SOFORT): 166 Dateien (152 w*.json
    Workflow-Ergebnisse + 13 md + 1 txt; Owner-Auftrag 13.08. woertlich im 00-INDEX) additiv nach
    docs/sessions/backups/20260814-regressions-gesamtbild/. Scan-Kette K13: Koeder glpat- + 20 Zufallszeichen
    (LAENGEN-ASSERT '20 == 20 OK') -> KOEDER-SCAN rc=1 'leaks found: 1'; Bestand -> BU-SCAN rc=0
    'no leaks found' ('scanned ~10440823 bytes (10.44 MB)'); Transkript-Sperre 0 *.jsonl.

(3) F2 -- #74-RESTHAELFTE, die von der S1.5-Disposition versprochene KON61-Zeile zum michael_lockfree-
    Lizenz-Detail (HIERMIT verbucht): ce LICENSE_AUDIT_EXT.md:39 '| A03-michael-lockfree | KEINE LICENSE |
    User muss Autoren anschreiben |' ist am Objekt WIDERLEGT -- 4 von 4 Textdateien unter
    ext/allocator/A03-michael-lockfree/ (README, michael.h, michael.c, malloc_new.cpp) tragen den
    'Lesser General Public'-Volltext (LGPL-2.1-or-later), deckungsgleich mit der Gate-Tabelle dieses Ledgers
    ('| michael_lockfree | LGPL-2.1-or-later | BSD-3 |'). Die additive Audit-Korrekturzeile ist ce-Doku-
    Posten des naechsten ce-Slots (kein Vor-Push-Blocker; Doku nie loeschen -- Korrektur additiv mit Marker
    an :39, nicht Ersetzung). TOKEN-FORM-FALLE aktenkundig: Verzeichnis-/Audit-Form 'A03-michael-lockfree'
    (Bindestrich) vs. Gate-/Ledger-Form 'michael_lockfree' (Unterstrich) -- Suchen muessen BEIDE Formen
    fahren; die Unterstrich-Suche allein lieferte im Verify eine Falsch-Null (rc=1 bei existierender
    Bindestrich-Zeile).

(4) F4 ZAHLEN-VERMERK (Commit-Text unveraenderlich, hiermit aktenkundig korrigiert): 1e31cd4b behauptet
    'Zeilen>120: 0 von 477'; das Objekt AM Commit hat 476 Zeilen (git show 1e31cd4b:scripts/
    vor_push_alle_wachen.sh | wc -l = 476; Basis 58b5aff4 = 473 Zeilen, Stat '+4/-1' -- die 477 zaehlte die
    eine Loeschung nicht ab). Die Kernaussage 'Zeilen>120: 0' bleibt richtig; nur der Nenner war um 1 zu
    hoch. Kein Verhaltens-Defekt.

DECKUNGS-GRENZEN DIESER STUFE (Verify-Kennzeichnungen, unveraendert gueltig): (a) Task-Text-Haelften
(#7/#10 Task-#41, #96 Task-#16, #99d Task-#40, #47-Sichtung) ohne Task-Lese-Tool im Roster nicht
objektpruefbar -- der Lead liest mit TaskGet gegen; (b) #38/#81-Pipeline-Messung ist Stufe-3-NACHLAUF nach
dem Push (15764-Trace + neue Job-IDs, Ergebnis via ledger_nachtrag.sh); (c) Meta-Gate-VOLLAUF
(vor_push_alle_wachen.sh-Bilanzzeile) + C1 clang-format + C2 cppcheck bleiben Stufe-3-Auflage am sauberen
Baum NACH Gitlink-Bump (KON60-NACHTRAG A). Diff-Hygiene push-lokal (--bereich origin/development HEAD)
laeuft nach Abschluss aller A2.5-Commits erneut; Ergebnis in der A2.5-BU und im Stufen-Return.

---
