# FINDINGS-SAMMELLISTE WELLE 2 (GO-maximal-parallel, 13.08.2026) — Auftrag des KOMPLEX-FIX (v4.3/A2.1b)

Form je Zeile: [Quelle] Ort — Fund — Status bei Aufnahme. Der Komplex-Fix quittiert dreiwertig.
Die Liste waechst, bis der letzte Wellen-Workflow zurueck ist (S-7 wwk6fs0bt, Wachen w4kqptnc9,
TEXLIVE wfjg4a9k0, F1-Dual-Lens wv4wbbqnn stehen noch aus — deren Findings HIER nachtragen).

## A. MERGE-REGRESSIONS-PRUEFFLAECHEN (Stufe 2a — am zusammengesetzten Stand)
1. tests/unit/CMakeLists.txt (ce): S-7-Strang UND Wachen-Strang appenden je Tail — Auto-Union
   semantisch pruefen (beide Registrierungs-Bloecke vollstaendig, keine Duplikat-Namen).
2. Floor-Datei ci_test_inventory_floor.txt (ce): S-7 und Wachen-Paket ziehen ggf. je Sprossen
   nach — am Ende EINMAL live messen (drei Absolutzahlen je Host-Klasse), nie Deltas addieren.
3. Wachen-Inventar (NE-16-Nenner, test_t6/vor_push_alle_wachen): neue Wachen/Jobs beider
   ce-Straenge muessen im Inventar-Nenner ankommen; super-Meta-Gate (58b5aff4) zaehlt 13/26 —
   nach der Welle neu enumerieren.
4. algo_version-/Lock-Flaeche (ce): S-7-Regen (Lock v3) gegen den Wachen-Branch — Lock EINMAL
   am Gesamtstand regenerieren+checken (deckt N von N), nie zwei Regen-Staende mergen.
5. Kombibau KON55 (gcc+clang x Debug+Release) + voller ctest am ZUSAMMENGESETZTEN ce-Stand.
6. super: 8 lokale Commits + e21-Merge + Designs + Ledger — Diff-Hygiene + Meta-Gate ueber den
   GESAMTEN Push-Bereich; PZW-Wache nach ce-Gitlink-Bump.

## B. OFFENE FINDINGS DER ZURUECKGEKEHRTEN WORKFLOWS (Stufe 2b)
### F1-Fix (wv83csrmh, A2.5 gelaufen — Reste)
7. [F1] WF-Rezept-Korrektur (Lead-Text ausserhalb Repo): bash statt sh; AF_SNAP_ROOT_STRICT=false
   als Labor-Pflicht-Env; Erwartungswerte 9-Spalten-required[] + op_lookup_p50_ns=1310. → in die
   naechste Kontextuebergabe/Task #41-Text uebernehmen.
8. [F1] VERTAGT: Landung des Zweigs (2 Commits 915038ca+c134b70a) — Merge-Probe beim Landen
   gegen DANN-aktuellen development wiederholen (merge-tree, zuletzt konfliktfrei).
9. [F1] VERTAGT: Thesis-Paket \InputIfFileExists-Hebung lc_surface (de:64ff/en:63ff, Muster
   de:103-283; Warnbeispiel b-gate8) — Owner/Lead-Vormerkung nach F1.
10. [F1] Grep-Warnung: HONEST-EMPTY-Nenner = matrixplot=0 UND honestempty>=1 UND nie-ausgefuehrt=0
    (Original-Artefakte tragen HONEST-EMPTY als Kommentar IN der kaputten Figur).
### e21 (w1pm0nio7, Verify BESTAETIGT — Reste)
11. [e21] Ledger-Nachtrag aus ledger_vorschlag einfuegen (KON-Nummer vergeben; Anker ueber
    KON-Kennung, Zeilennummern galten fuer a103e518).
12. [e21] Lead-Entscheid E-2: „mit mehr Kontext"-Neuvorlage als GEGENSTANDSLOS werten
    (Empfehlung) — als Kenntnisnahme in die naechste Owner-Vorlage.
13. [e21] E-4c KON-57/E-26 TEST-Skip: die EINE Owner-Frage der naechsten Runde (Text liegt in
    der A-1-Vorlage Teil III).
14. [e21] Dateinamens-Divergenz: FORM-Name 20260813-OWNER-VORLAGE-a1-backup-ref-aktionen.md
    beibehalten (Empfehlung), Schrittfolge-Name verwerfen.
15. [e21] A-3-Rotation 776 Runner-Registration-Token: Owner-GO vom 10.08. NICHT vollzogen
    (KON58-04) — Infra-Posten, mit Klon-Sweep als Token-Hygiene buendeln (#10).
16. [e21] non-ASCII im BESTAND der minio-Vorlage Z.1-56 — Lead-Entscheid ob normalisieren
    (Empfehlung: NEIN, Bestand ist Bestand; nur neue Zeilen ASCII).
### Design-Duo (w2zv55j8v + wjrbqudaw — Reste)
17. [Design] Publikation beider Dokumente (JOB_DIR tmp/design_{zielstruktur,g1}.md, final) als
    docs/plaene/20260813-DESIGN-*.md — in dieser Welle.
18. [Design] F-G1-11 (Kind-Stempel-Form, 3 Optionen ohne Default) + F-G1-12 (Tooling-id) + 15
    F-G1-Fragen → naechste Owner-Vorlage.
19. [Design] Feingranulare Matrix-Zellen dem Review entnommen — #67-Neuerhebung (S-6d) liefert
    Drittzaehlung; §6.4 „0 transitive Kanten 4→2" dort mitpruefen.
20. [Design] Ein-Schreiber-Check an Repo-Wurzel-CMakeLists.txt zum Skeleton-Commit-Zeitpunkt
    (WE 15./16., nach ce-Freigabe).
### Luecken-WF (wdfgx3k8f — Reste, Triage-Bau-Anweisungen liegen im Dump)
21. [Luecken] ##06-CI-voll: super-Job test:abnahme06-voll mit --ctest-liste (Anweisung liegt).
22. [Luecken] D2-G6 (ce): 3 Roundtrip-Gates vermerken + Kommentar-Korrektur + Stash-Koeder.
23. [Luecken] D3-4-Grandchild (ce, Director): BATCH-BILANZ A+B==C + Inhalts-Gate je Batch
    emittieren, byte-fixierte Unit-Literale im selben Commit, T-1.
24. [Luecken] ##23-R1 (ce): 3 von 11 Profilen xlsx additiv (base_pilot, m3v2_smoke,
    wdk_fairness_example; Muster m3v2_study:181-183; Nenner 11 nennen).
25. [Luecken] ##26 (super): M==N haerten (N_LEER>0 && modus=voll => rot) ODER Formel im
    Wellenplan angleichen — NICHT beides stehen lassen; Bissproben-Fall dazu.
26. [Luecken] NE-19a ce-Kampagne (Lens-B 34/36) + vor_push_alle_wachen ce-Fassung auf
    INVENTAR-Modus + NE-20 ce (arm64-smoke :257, relock :919 — je deklarieren oder entfernen).
27. [Luecken] NE-16 (ce): test_t6-Wachen-Inventar-Nenner + S-14a-Job — LAEUFT bereits im
    Wachen-Paket w4kqptnc9 (nicht doppelt).
28. [Luecken] NE-10 (ce): S-3/S-7-Seiten je 2 Zahlen — LAEUFT im S-7-Explore wwk6fs0bt.
29. [Luecken] ci/tests/-Probes-Kampagne (14 dash-Dateien, ~360 KB) + xml_wellformed_guard
    Stufen-Form — eigenes Paket, W-Platz nach der Welle.
30. [Luecken] KON59-02-Anker-Drift in den NE-20-Ledger-Nachtrag: relock :898→:919,
    ergebnis:holen :2751→:2809.
31. [Luecken] E-Serien-Kollision der Triage (las #21 als K1/K2/K5 statt 10.08.-Vorlage) —
    im Ledger-Nachtrag als aufgeklaert verbuchen (e21-Explore ist autoritativ; K1/K2/K5 per
    OF-3-Marker ohnehin zu).
32. [Luecken] Zaehlwerk-Auflösungen in den Ledger: 137=123+7+6+1 (KON8-08; drei „unaufgeklaert"-
    Vermerke :5272/:5395/:5470 schliessen) · #67: 29er-Definition uebernehmen, 142 historisch ·
    KON11-01-Elferliste-Bilanz (4 widerlegt/1 teil/5 halten).
33. [Luecken] B5-Seriell-Entscheid (hinter S-5→S-6a) in den Ledger/W1-Plan — in #24 verbucht,
    Ledger-Zeile fehlt noch.
34. [Luecken] 🔴 UMBRELLA-CI strukturell rot seit 06.03. (macos/windows-Jobs ohne Runner;
    15790 fuer v4.2 lief bei Erhebung) → Owner-/Infra-Vorlage; allow_failure verboten.
### Frueher aufgelaufen (noch unbesessen)
35. [Triage #31] Ledger-Verbuchung der 13 Branch-Urteile (8 ausbuchen/4 ueberholt/1 landen) +
    Hygiene danach (Store-2-Auscheck auf development, wf-Worktrees -15/-16 frei, wf_e22d25ef
    erst nach Sichtung der 17 untracked Skripte, d3naht-Gitlink nie committen).
36. [P6] #42 bau/p6-lizenz-umsetzung landen (Slot nach P2, vor main-FF; 4 Auflagen im Task).
37. [Monitor] P3-Regel-Kandidat: Monitor-Lebendprobe beim Scharfschalten → in die Arbeitsweise
    (naechste v4.x).
38. [#81] Wiederhol-Verify W0b (Task #43, Bau-Anweisung liegt) — eigener Verify-WF, kann Teil
    des Komplex-Fix-Verify sein oder separat.

## C. NACH DER WELLE (nicht Komplex-Fix, nur Ordnung)
- F1-Echtlauf (Messung + ANHANG_FORWARD, bash-Rezept) + 288-Gitlink BEIDE Thesis-Zeiger +
  E-18-SNAP → F1-Endbeleg.
- Owner-Vorlagen-Runde: C-3a (Mi 19.08.) · MinIO-Keys · A-3-Token · E-4c Test-Skip ·
  F-G1-Fragen · E-2-Kenntnisnahme · Umbrella-CI.

### TEXLIVE-Gate (wfjg4a9k0 — KOMPLETT: Bau+2 Lenses+Fix, Branch bau/texlive-gate-haertung ahead 4: bb03d53b+2cea7287+6bd5b263+5363eebb, Suite 18/18)
39. [texgate] LANDEN in dieser Welle: 4 Commits (Haertung AF_PDF_GATE=on + Kommentar-Fix +
    Enum-Wache/Mehr-Hauptdokument-Wache im Kern + Anker-Nachzug 10 stale). Worktree
    wt-super-texgate nach Merge+gruen freigeben.
40. [texgate] 🔴 NACH DEM MERGE: die 11 CI-INV-Kopfzahlen am GEMERGTEN Stand nachmessen
    (Anker-Drift systemisch, 2. Grossflaechen-Fall; Werkzeug/Schleifen-Probe /tmp/texgate_fix).
41. [texgate] Infra-Posten VOR COMDARE_ANHANG_FORWARD-Flip: TeX im gitlab-runner-Job-PATH —
    /usr/local/bin traegt seit 03.07. root-Symlinks (zweite Quelle, Kontrafaktual entschaerft);
    erster scharfer Lauf beantwortet empirisch, beide Ausgaenge tragen (II.7). Ich pruefe die
    Projekt-Variablen (TEXLIVE_AVAILABLE/ANHANG_FORWARD) per PAT beim Echtlauf.
42. [texgate] VORGEMERKT (Objekt erzwingt seit 6bd5b263 laut): Listen-Erweiterung des PDF-Gates
    bei Einfuehrung eines 2. Hauptdokuments (EN) = eigener Design+Bau+Verify-Zug (kaskadiert in
    E-18-SNAP-Ernte-Vertrag AF_GATE_MAIN/PDF) — kein head-1-Einzeiler.
43. [texgate] Prozess-Lehre: Standort-Angaben (ahead N) je Stufe FRISCH messen, nie uebernehmen
    (Stufen-Versatz Fund 8 vs 18).
