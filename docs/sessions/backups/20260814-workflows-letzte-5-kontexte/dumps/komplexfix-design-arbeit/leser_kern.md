# KERN-LESER EXTRAKTION -- AUFTRAGSGRUNDLAGE KOMPLEX-FIX-DESIGN (13.08.2026)

QUELLEN (13 von 13 gelesen: 12 zugewiesene VOLLSTAENDIG + 1 zusaetzlich am Objekt
vorgefunden; Zeilenzahlen per wc -l):
  1. tmp/welle2_findings_sammelliste.md (205 Z.) -- DER ANKER, 64 Findings + A/C/D
  2. regressions-gesamtbild/00-INDEX.md (25 Z.)
  3. regressions-gesamtbild/00-vorkontext-backups-in-super.txt (8 Z.)
  4. regressions-gesamtbild/20260813-OWNER-VORLAGE-sammelrunde-welle2-vor-komplexfix.md (109 Z.)
  5. regressions-gesamtbild/20260813-PAUSE-2-welle2-workflows-resumebar.md (52 Z.)
  6. regressions-gesamtbild/design_g1.md (540 Z., final)
  7. regressions-gesamtbild/design_zielstruktur.md (199 Z., final)
  8. regressions-gesamtbild/f1lens_dump_voll.md (96 Z.)
  9. regressions-gesamtbild/luecken_dump_voll.md (195 Z.)
 10. regressions-gesamtbild/s7_dump_voll.md (97 Z.)
 11. regressions-gesamtbild/verify_dump_voll.md (293 Z.)
 12. regressions-gesamtbild/wachen_dump_voll.md (69 Z.)
 13. regressions-gesamtbild/20260813-PAUSE-3-vor-landung-workflows-resumebar.md (72 Z.,
     ZUSAETZLICH -- nicht in der Auftrags-Liste, aber juengster Stand 13.08. 15:06 UTC;
     Extraktion in TEIL 11)

ASCII-REGEL: Diese Datei ist ASCII-only. VERBATIM-Uebernahmen sind zeichengetreu bis auf
folgende verlustfreie Transliterationen: em-dash -> "--", Pfeil -> "->", Mittelpunkt -> "*",
rotes Symbol -> "[ROT]", deutsche/typografische Anfuehrungszeichen -> '"' bzw. "'",
Paragraphzeichen -> "Par.", Umlaute -> ae/oe/ue (kamen in den Quellen fast nur schon
transliteriert vor). Zahlen, SHAs, Pfade, Zeilenanker: unveraendert.

FORMAT je Fund/Posten (Teile 2 ff.):
### [<quelldatei>] <laufende-nr>
GEGENSTAND / ORT / SOLL-FIX / STATUS LT. QUELLE / ABHAENGIGKEIT-FLAECHE.

================================================================================
TEIL 1 -- FINDINGS-SAMMELLISTE WELLE 2, VERBATIM (Quelle: tmp/welle2_findings_sammelliste.md,
205 Zeilen, alle 64 Nummern + Abschnitte A/C/D vollstaendig)
================================================================================

# FINDINGS-SAMMELLISTE WELLE 2 (GO-maximal-parallel, 13.08.2026) -- Auftrag des KOMPLEX-FIX (v4.3/A2.1b)

Form je Zeile: [Quelle] Ort -- Fund -- Status bei Aufnahme. Der Komplex-Fix quittiert dreiwertig.
Die Liste waechst, bis der letzte Wellen-Workflow zurueck ist (S-7 wwk6fs0bt, Wachen w4kqptnc9,
TEXLIVE wfjg4a9k0, F1-Dual-Lens wv4wbbqnn stehen noch aus -- deren Findings HIER nachtragen).

## A. MERGE-REGRESSIONS-PRUEFFLAECHEN (Stufe 2a -- am zusammengesetzten Stand)
1. tests/unit/CMakeLists.txt (ce): S-7-Strang UND Wachen-Strang appenden je Tail -- Auto-Union
   semantisch pruefen (beide Registrierungs-Bloecke vollstaendig, keine Duplikat-Namen).
2. Floor-Datei ci_test_inventory_floor.txt (ce): S-7 und Wachen-Paket ziehen ggf. je Sprossen
   nach -- am Ende EINMAL live messen (drei Absolutzahlen je Host-Klasse), nie Deltas addieren.
3. Wachen-Inventar (NE-16-Nenner, test_t6/vor_push_alle_wachen): neue Wachen/Jobs beider
   ce-Straenge muessen im Inventar-Nenner ankommen; super-Meta-Gate (58b5aff4) zaehlt 13/26 --
   nach der Welle neu enumerieren.
4. algo_version-/Lock-Flaeche (ce): S-7-Regen (Lock v3) gegen den Wachen-Branch -- Lock EINMAL
   am Gesamtstand regenerieren+checken (deckt N von N), nie zwei Regen-Staende mergen.
5. Kombibau KON55 (gcc+clang x Debug+Release) + voller ctest am ZUSAMMENGESETZTEN ce-Stand.
6. super: 8 lokale Commits + e21-Merge + Designs + Ledger -- Diff-Hygiene + Meta-Gate ueber den
   GESAMTEN Push-Bereich; PZW-Wache nach ce-Gitlink-Bump.

## B. OFFENE FINDINGS DER ZURUECKGEKEHRTEN WORKFLOWS (Stufe 2b)
### F1-Fix (wv83csrmh, A2.5 gelaufen -- Reste)
7. [F1] WF-Rezept-Korrektur (Lead-Text ausserhalb Repo): bash statt sh; AF_SNAP_ROOT_STRICT=false
   als Labor-Pflicht-Env; Erwartungswerte 9-Spalten-required[] + op_lookup_p50_ns=1310. -> in die
   naechste Kontextuebergabe/Task #41-Text uebernehmen.
8. [F1] VERTAGT: Landung des Zweigs (2 Commits 915038ca+c134b70a) -- Merge-Probe beim Landen
   gegen DANN-aktuellen development wiederholen (merge-tree, zuletzt konfliktfrei).
9. [F1] VERTAGT: Thesis-Paket \InputIfFileExists-Hebung lc_surface (de:64ff/en:63ff, Muster
   de:103-283; Warnbeispiel b-gate8) -- Owner/Lead-Vormerkung nach F1.
10. [F1] Grep-Warnung: HONEST-EMPTY-Nenner = matrixplot=0 UND honestempty>=1 UND nie-ausgefuehrt=0
    (Original-Artefakte tragen HONEST-EMPTY als Kommentar IN der kaputten Figur).
### e21 (w1pm0nio7, Verify BESTAETIGT -- Reste)
11. [e21] Ledger-Nachtrag aus ledger_vorschlag einfuegen (KON-Nummer vergeben; Anker ueber
    KON-Kennung, Zeilennummern galten fuer a103e518).
12. [e21] Lead-Entscheid E-2: "mit mehr Kontext"-Neuvorlage als GEGENSTANDSLOS werten
    (Empfehlung) -- als Kenntnisnahme in die naechste Owner-Vorlage.
13. [e21] E-4c KON-57/E-26 TEST-Skip: die EINE Owner-Frage der naechsten Runde (Text liegt in
    der A-1-Vorlage Teil III).
14. [e21] Dateinamens-Divergenz: FORM-Name 20260813-OWNER-VORLAGE-a1-backup-ref-aktionen.md
    beibehalten (Empfehlung), Schrittfolge-Name verwerfen.
15. [e21] A-3-Rotation 776 Runner-Registration-Token: Owner-GO vom 10.08. NICHT vollzogen
    (KON58-04) -- Infra-Posten, mit Klon-Sweep als Token-Hygiene buendeln (#10).
16. [e21] non-ASCII im BESTAND der minio-Vorlage Z.1-56 -- Lead-Entscheid ob normalisieren
    (Empfehlung: NEIN, Bestand ist Bestand; nur neue Zeilen ASCII).
### Design-Duo (w2zv55j8v + wjrbqudaw -- Reste)
17. [Design] Publikation beider Dokumente (JOB_DIR tmp/design_{zielstruktur,g1}.md, final) als
    docs/plaene/20260813-DESIGN-*.md -- in dieser Welle.
18. [Design] F-G1-11 (Kind-Stempel-Form, 3 Optionen ohne Default) + F-G1-12 (Tooling-id) + 15
    F-G1-Fragen -> naechste Owner-Vorlage.
19. [Design] Feingranulare Matrix-Zellen dem Review entnommen -- #67-Neuerhebung (S-6d) liefert
    Drittzaehlung; Par.6.4 "0 transitive Kanten 4->2" dort mitpruefen.
20. [Design] Ein-Schreiber-Check an Repo-Wurzel-CMakeLists.txt zum Skeleton-Commit-Zeitpunkt
    (WE 15./16., nach ce-Freigabe).
### Luecken-WF (wdfgx3k8f -- Reste, Triage-Bau-Anweisungen liegen im Dump)
21. [Luecken] ##06-CI-voll: super-Job test:abnahme06-voll mit --ctest-liste (Anweisung liegt).
22. [Luecken] D2-G6 (ce): 3 Roundtrip-Gates vermerken + Kommentar-Korrektur + Stash-Koeder.
23. [Luecken] D3-4-Grandchild (ce, Director): BATCH-BILANZ A+B==C + Inhalts-Gate je Batch
    emittieren, byte-fixierte Unit-Literale im selben Commit, T-1.
24. [Luecken] ##23-R1 (ce): 3 von 11 Profilen xlsx additiv (base_pilot, m3v2_smoke,
    wdk_fairness_example; Muster m3v2_study:181-183; Nenner 11 nennen).
25. [Luecken] ##26 (super): M==N haerten (N_LEER>0 && modus=voll => rot) ODER Formel im
    Wellenplan angleichen -- NICHT beides stehen lassen; Bissproben-Fall dazu.
26. [Luecken] NE-19a ce-Kampagne (Lens-B 34/36) + vor_push_alle_wachen ce-Fassung auf
    INVENTAR-Modus + NE-20 ce (arm64-smoke :257, relock :919 -- je deklarieren oder entfernen).
27. [Luecken] NE-16 (ce): test_t6-Wachen-Inventar-Nenner + S-14a-Job -- LAEUFT bereits im
    Wachen-Paket w4kqptnc9 (nicht doppelt).
28. [Luecken] NE-10 (ce): S-3/S-7-Seiten je 2 Zahlen -- LAEUFT im S-7-Explore wwk6fs0bt.
29. [Luecken] ci/tests/-Probes-Kampagne (14 dash-Dateien, ~360 KB) + xml_wellformed_guard
    Stufen-Form -- eigenes Paket, W-Platz nach der Welle.
30. [Luecken] KON59-02-Anker-Drift in den NE-20-Ledger-Nachtrag: relock :898->:919,
    ergebnis:holen :2751->:2809.
31. [Luecken] E-Serien-Kollision der Triage (las #21 als K1/K2/K5 statt 10.08.-Vorlage) --
    im Ledger-Nachtrag als aufgeklaert verbuchen (e21-Explore ist autoritativ; K1/K2/K5 per
    OF-3-Marker ohnehin zu).
32. [Luecken] Zaehlwerk-Aufloesungen in den Ledger: 137=123+7+6+1 (KON8-08; drei "unaufgeklaert"-
    Vermerke :5272/:5395/:5470 schliessen) * #67: 29er-Definition uebernehmen, 142 historisch *
    KON11-01-Elferliste-Bilanz (4 widerlegt/1 teil/5 halten).
33. [Luecken] B5-Seriell-Entscheid (hinter S-5->S-6a) in den Ledger/W1-Plan -- in #24 verbucht,
    Ledger-Zeile fehlt noch.
34. [Luecken] [ROT] UMBRELLA-CI strukturell rot seit 06.03. (macos/windows-Jobs ohne Runner;
    15790 fuer v4.2 lief bei Erhebung) -> Owner-/Infra-Vorlage; allow_failure verboten.
### Frueher aufgelaufen (noch unbesessen)
35. [Triage #31] Ledger-Verbuchung der 13 Branch-Urteile (8 ausbuchen/4 ueberholt/1 landen) +
    Hygiene danach (Store-2-Auscheck auf development, wf-Worktrees -15/-16 frei, wf_e22d25ef
    erst nach Sichtung der 17 untracked Skripte, d3naht-Gitlink nie committen).
36. [P6] #42 bau/p6-lizenz-umsetzung landen (Slot nach P2, vor main-FF; 4 Auflagen im Task).
37. [Monitor] P3-Regel-Kandidat: Monitor-Lebendprobe beim Scharfschalten -> in die Arbeitsweise
    (naechste v4.x).
38. [#81] Wiederhol-Verify W0b (Task #43, Bau-Anweisung liegt) -- eigener Verify-WF, kann Teil
    des Komplex-Fix-Verify sein oder separat.

## C. NACH DER WELLE (nicht Komplex-Fix, nur Ordnung)
- F1-Echtlauf (Messung + ANHANG_FORWARD, bash-Rezept) + 288-Gitlink BEIDE Thesis-Zeiger +
  E-18-SNAP -> F1-Endbeleg.
- Owner-Vorlagen-Runde: C-3a (Mi 19.08.) * MinIO-Keys * A-3-Token * E-4c Test-Skip *
  F-G1-Fragen * E-2-Kenntnisnahme * Umbrella-CI.

### TEXLIVE-Gate (wfjg4a9k0 -- KOMPLETT: Bau+2 Lenses+Fix, Branch bau/texlive-gate-haertung ahead 4: bb03d53b+2cea7287+6bd5b263+5363eebb, Suite 18/18)
39. [texgate] LANDEN in dieser Welle: 4 Commits (Haertung AF_PDF_GATE=on + Kommentar-Fix +
    Enum-Wache/Mehr-Hauptdokument-Wache im Kern + Anker-Nachzug 10 stale). Worktree
    wt-super-texgate nach Merge+gruen freigeben.
40. [texgate] [ROT] NACH DEM MERGE: die 11 CI-INV-Kopfzahlen am GEMERGTEN Stand nachmessen
    (Anker-Drift systemisch, 2. Grossflaechen-Fall; Werkzeug/Schleifen-Probe /tmp/texgate_fix).
41. [texgate] Infra-Posten VOR COMDARE_ANHANG_FORWARD-Flip: TeX im gitlab-runner-Job-PATH --
    /usr/local/bin traegt seit 03.07. root-Symlinks (zweite Quelle, Kontrafaktual entschaerft);
    erster scharfer Lauf beantwortet empirisch, beide Ausgaenge tragen (II.7). Ich pruefe die
    Projekt-Variablen (TEXLIVE_AVAILABLE/ANHANG_FORWARD) per PAT beim Echtlauf.
42. [texgate] VORGEMERKT (Objekt erzwingt seit 6bd5b263 laut): Listen-Erweiterung des PDF-Gates
    bei Einfuehrung eines 2. Hauptdokuments (EN) = eigener Design+Bau+Verify-Zug (kaskadiert in
    E-18-SNAP-Ernte-Vertrag AF_GATE_MAIN/PDF) -- kein head-1-Einzeiler.
43. [texgate] Prozess-Lehre: Standort-Angaben (ahead N) je Stufe FRISCH messen, nie uebernehmen
    (Stufen-Versatz Fund 8 vs 18).

### S-7 (wsukojf00 -- KOMPLETT: Explore+Bau+Verify TRAEGT_MIT_FIXES+Fix; Branch bau/s7-algo-hardware-stempel @ 178bb1fb = 548fecd2+ec3c71fa+178bb1fb; Riegel-Echtfall-Probe ROT->write->GRUEN kryptographisch verifiziert; Floor neu 491/487/485)
44. [S-7] [ROT] LEAD-PFLICHT VOR LANDUNG: Kombibau-Restlauf-Belege lesen --
    /usr/bin/grep -E 'tests passed|failed out of' /home/comdare/s1-logs/s7fix-{gcc-rel,gcc-dbg,clang-rel,clang-dbg}-ctest.log
    SOLL 4x '0 tests failed out of 490'; tail s7fix-kombibau-master.log SOLL 'ENDE fail=0' + Raeum-Belege 0/0.
45. [S-7] LANDENDER Riegel-Echtfall steht weiter aus (S-7 ausserhalb Lock-Domaene, NULL-BEWEIS
    sha e7263b82 unveraendert) -- Pflichtschritt beim naechsten echten algo_version-Bump
    (S-6-Fenster/Bump-Buendel W1, Tasks #15/#24/#38a2+d) einplanen + Riegel-Protokoll.
46. [S-7] NE-10-Ledger-Korrektur (in KON-Nachtrag): mp_size-Nenner der registrierten
    Organ-Population = 126 (nicht 122; 122 = Varianten mit EIGENEM Literal, 123 Literale da
    k_ary zwei traegt), enabled=83; bvset_ist_teilmenge = AKTIVE Produktions-Skip-Logik
    (nicht inert); Riegel-Praemisse 'S-7 aendert algo_version-Traeger' war falsch (KON58-01
    durch KON58-05/Schnitt Z.315 ueberholt).
47. [S-7] MEMORY-NACHZUG: 'Floor-Sprossen im SELBEN Commit' ist stale -- der Datei-Kopf
    (ci_test_inventory_floor.txt:22-28, autoritativ) + S-3-Praezedenz verlangen den EIGENEN
    Commit; Memory-/Task-Zeilen anpassen.
48. [S-7] STALE-Kommentar simd_build_gate.hpp:196-197 (verweist :458-459, real :759ff/:781ff)
    -- Nachzug in einem Paket, das die Datei anfassen darf.
49. [S-7] Beobachtungsposten: test_d2_abdeckungs_wache_nenner fiel 1x unter paralleler
    Volllast (1 von 490, clang-Release-Erstlauf; einzeln 41/41, Wiederholung 490/490 gruen)
    -- Flaky-Kandidat unter Last, beobachten.
50. [S-7] j14.sh (s1-logs) traegt SRC hartkodiert (wt-ce-warn-libs) -- Nachfolger
    j14-s7fix-kombibau.sh existiert; bei Gelegenheit SRC/Tags parametrisieren.
51. [S-7] P4-WEICHE dokumentiert: legt P4 die MESS-/SYSTEM-Homes als Verzeichnis-Form an,
    ruecken die neuen S-7-Header NACHTRAEGLICH in den Fingerprint (golden-brechend) --
    Entscheid faellt bei P4; Header-Kopf traegt den Hinweis.
52. [S-7] kVollausbau nicht signaturfaehig (T-4-Gegeneingang verbaut): erwartet der Owner
    spaeter Vollausbau-Zulassung, braucht der 23er-Signatur-Katalog additive Erweiterung.
53. [S-7] ctest-Erwartung nach Landung: 490 ohne / 491 mit Pruefling-Schalter; J-4-Hinweis:
    test_profile_roundtrip ist EXCLUDE_FROM_ALL -- CI/Zellen muessen das Ziel explizit bauen.

### Wachen-Paket (wcy14e42k -- KOMPLETT: Bau+Verify TRAEGT_MIT_FIXES+Fix 5/5 BEHOBEN; Branch bau/wachen-floor-inventar @ 07a60cc7 = 092ab7e9+6eb72ace+0fbcb049+07a60cc7; Kombibau 4x488/488; Floor-Wache jetzt ANKER exakt mit Nachzug-Pflicht, t6-Inventar 25 Jobs/33 Schluessel + S-14a gedeckt + Scanner gehaertet fail-closed)
54. [Wachen] LANDEN in dieser Welle: Branch-Tip 07a60cc7 (der Pause-WIP c0ff9986 ist inhaltsgleich
    darin aufgegangen, git diff leer -- Landung nimmt 07a60cc7). CMakeLists-Hotspot UNBERUEHRT
    (0 Diff-Zeilen) -- Harmonisierungs-Flaeche 1 entspannt sich; Floor-Flaeche 2 BLEIBT:
    S-7 hob auf 491/487/485 (eigener Commit ec3c71fa), Wachen-Branch laesst 489/485/483 --
    beim seriellen Merge gewinnt S-7-Stand + EINMAL Live-Messung am Gesamtstand (jetzt mit
    ANKER-Semantik: Nachzug im SELBEN Change des Merges!).
55. [Wachen] BU-SOFORT nach Landung: /tmp/a25_wachen_fix/ (Manifest + 13 Logs + Koeder) additiv
    nach super docs/sessions/backups/ (Secret-Scan mit beissendem Koeder vorher).
56. [Wachen] super-Aequivalente derselben Wachen-Klassen (kTabelle-Hinweis 'in super existiert
    die gtest-Fassung bereits') NICHT erhoben -- eigener Posten nach der Welle.
57. [Wachen] RAHMEN-Soll '2172 Ninja-Schritte' stale (live 2188 am neuen Stand) -- bei naechster
    Rezept-Zitierung live bestaetigen statt kopieren (Floor-Kopf nennt keine Schrittzahl).
58. [Wachen] Kombibau-Interpretation deklariert: EIN Kombibau (4 Zellen) auf dem Gesamtstand
    beider Commits statt 8 Vollbauten -- Komplex-Fix prueft den zusammengesetzten ce-Stand
    ohnehin nochmal (Flaeche 5), damit gedeckt.
59. [Wachen] Scanner-Kante dokumentiert+gehaertet: '"k" :' (Leerraum vor Doppelpunkt) landet
    fail-closed in 'unverstanden' (ASSERT-ROT, 0 von 33 betroffen) -- bewusste Richtung, kein
    Handlungsbedarf; nur als Kante im Kopf benannt.

## D. [ROT] KOMPLEX-FIX-AUFLAGE: PAUSEN-SORGFALT (Owner 13.08. -- "besondere Sorgfalt gegen die
## urspruengliche Anforderung" fuer alle pausierten Workflows)
Durch TaskStop/WIP/Resume-mit-Cache koennen Ungenauigkeiten entstanden sein. Der Komplex-Fix
prueft je pausiertem Workflow SOLL-IST GEGEN DEN ORIGINAL-AUFTRAGSTEXT (das Workflow-Script,
nicht die Quittung!), vier Achsen:
  (P1) AUFTRAGS-DECKUNG: jede Pflicht/jeder Schritt des Original-Prompts einzeln am Objekt
       quittiert? (Quittungen koennen Luecken haben -- Praezedenz: Wachen-Verify fand die
       fehlende 6eb72ace-Quittung, S-7-Quittung war transport-abgeschnitten.)
  (P2) CACHE-STALE-KONTEXT: die gecachten Stufen (Explore/Bau/Verify) stammen von VOR der
       Pause -- ihre Lageangaben (z.B. 'CI 15785 laeuft noch', development-Stand a103e518,
       'ce schreibgesperrt') waren zur Fix-Zeit stale. Pruefen, ob daraus falsche Annahmen
       in Fixes/Entscheide flossen.
  (P3) WIP-UEBERNAHME VOLLSTAENDIG: c642c35d (F1-Fix, per Amend in 915038ca) * 6b89fce5
       (Luecken-Stufe-2, per checkout je Datei in 76a345e3ff.) * c0ff9986 (Wachen, in
       07a60cc7, diff leer belegt) -- je nachpruefen: nichts aus dem WIP verloren, nichts
       Ungeprueftes uebernommen, keine Doppel-Arbeit (zwei Fassungen derselben Aenderung).
  (P4) FIX-STUFEN-VOLLSTAENDIGKEIT: die nach Resume gelaufenen Fix-Stufen bekamen ihre
       Fund-Listen aus dem Cache -- VOLLE Liste abgearbeitet (Anzahl Quittungen == Anzahl
       Funde) und keine zwischen Stop und Resume aufgelaufenen Zusatz-Funde uebersehen?
BETROFFENE WORKFLOWS: Pause 1: wf_a7e55a90-2a8 (F1-Fix) + wf_046aab6c-928 (Luecken) *
Pause 2: wf_81efb13f-45b (S-7) + wf_b6b05f65-923 (Wachen) + wf_61f2b36f-712 (F1-Lens).
Die Original-Scripts liegen unter .../workflows/scripts/ (Pfade im 00-INDEX des
Gesamtbilds); Journale unter .../subagents/workflows/<runId>/journal.jsonl.

### F1-Dual-Lens (wre78fwii -- KOMPLETT: 2 Codex-Lenses TRAEGT + Fable GRUEN + Fix 20 Quittungen
### [4 BEHOBEN/15 ENTLASTET/1 VERTAGT]; F1-Branch jetzt @ 8e9a31d2 = 4 Commits: 915038ca+c134b70a+ff9a517b+8e9a31d2; da_unit 405/405 Release+Debug)
60. [F1-Lens] LANDEREIF: bau/f1-1x1-honest-empty @ 8e9a31d2 -- neue Tests Surface2x3StaysRealFigure
    (Gegenkoeder >2x2) + RatioMatrixTrueZeroOnAllOnes (alte 2x1-Zahlen festgenagelt) + Numerus-Fix
    degenerate_size_note (Plural bei N>1, T-1 rot->gruen) + Wachen-Meldung nennt Kriterium statt
    geratener Shell. Byte-Parity 60/64 von Fix-Stufe selbst nachgerechnet (cmp).
61. [F1-Lens] [ROT] N1 ce-DATEN-DRIFT (VERTAGT, ce-Territorium): test_axis_registry_roundtrip ROT --
    committete cache_engine_axis_registry.xml entspricht nicht der Code-Reflektion (u.a.
    memory_layout_packed_bitmap neu). Pflicht-Fix im ce: Generator-Lauf (comdare_axis_registry_gen,
    2-Pass) + XML-Commit. In den Komplex-Fix (ce-Seite) aufnehmen -- VOR dem Push, sonst faellt
    der contract-Job am zusammengesetzten Stand.
62. [F1-Lens] VERTAGT 16b: latexmk-PDF-Gate + Thesis-Regeneration im CI = der anhang:forward-Job
    des Echtlaufs nach der Landung (Gate seit texgate hart on) -- geplant, kein Rest.
63. [F1-Lens] N2 Colorbar-Tick-Kollision ('$0$' neben '$10^{-2}$' bei All-Ones+Zero) -- Bestand
    seit P2, testfixiert; spaeterer Kosmetik-Posten (Tick-Dedupe), kein F1-Gegenstand.
64. [F1-Lens] N3 Gate-Beobachtung: blankes ctest in build-test = 886 Tests/474 Not-Run --
    Vollgruen-Gate ist 'ctest -L da_unit' bzw. make check; Roundtrip-Werkzeuge nur nach
    explizitem 2-Pass-Bau. In Lande-/CI-Rezepte uebernehmen.

================================================================================
TEIL 2 -- OWNER-VORLAGE 13.08. (SAMMELRUNDE): FRAGEN A1..D4 MIT GEGENSTAND
Quelle: 20260813-OWNER-VORLAGE-sammelrunde-welle2-vor-komplexfix.md (109 Z.)
Rahmen lt. Vorlage: 9 von 9 Wellen-Workflows KOMPLETT; KEINE der Fragen blockiert die
Drei-Stufen-Landung; jede Frage in einem Satz beantwortbar.
================================================================================

### [owner-vorlage] 1 (A1)
GEGENSTAND: C-3a Comp-Gate-Paket-Entscheid -- welche Organ-Achse bekommt die ERSTE echte required-Deklaration (aktiviert das gebaute Comp-Gate; heute alle Mengen leer = inert).
ORT: Vorlage 136a1798; Frist Mi 19.08.
SOLL/FIX: Ohne Antwort bis Mi zieht die Fallregel 18.6(3) (#38a2 rutscht ins W2-Bump-Buendel, Freeze-Nachbuchung deklariert). S-7-Zusatz: Zulassungs-Bruecke gebaut und nachweisbar inert -- die Antwort aktiviert beide Gates in einem Zug.
STATUS LT. QUELLE: offen (fristgebunden)
ABHAENGIGKEIT/FLAECHE: S-7-Branch (simd_build_gate-Tripwire unberuehrt); Tasks #38a2, W1-Bump-Buendel.

### [owner-vorlage] 2 (A2)
GEGENSTAND: MinIO-Keys neu erzeugen (Owner oder Infra) fuer beide Endpunkte.
ORT: Vorlage a82078cb Frage 1; Task #10.
SOLL/FIX: Blind-Smoke ist ROT (kein gueltiges Paar im Vault, Koeder-gedeckt); blockiert den MinIO-Rueckschrieb-Systemtest (W3-Strecke), nicht die Landung.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: W3-Strecke; Infra.

### [owner-vorlage] 3 (B1)
GEGENSTAND: F-G1-11 Kind-Stempel-Form (w-Sichtbarkeit) -- wichtigste G-1-Frage, Review-Hauptfund: Owner-Wort "CEB gibt wallclock build auf der naechsten Traeger-Stufe frei" macht das Tier-KOMPILAT w-abhaengig, die vorgeschlagene Slot-Projektion war w-blind (Alias-Klasse).
ORT: design_g1.md (final), F-G1-11; Ledger :2148/:2169-2173.
SOLL/FIX: Drei Optionen, bewusst ohne Default: (i) Kinder stempeln den VOLLEN Vertrags-Ausdruck (loest auch den Anordnungs-Verlust), (ii) Projektion fuehrt vertragswirksame Fremd-Slot-Instrumente als Kontext mit, (iii) w gilt als reines CEB-Selbst-Instrument ohne Tier-Naht (widerspraeche B3-Satz "Die Tier-Gates bleiben" -- muesste ausdruecklich widerrufen werden). Frage: (i), (ii) oder (iii)?
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: F-G1-4/-10 und Stufe-D-Pin-Form haengen daran; Finding 18.

### [owner-vorlage] 4 (B2)
GEGENSTAND: G-1 als Ganzes -- Profil-Entscheid + Vokabular.
ORT: design_g1.md (final, 540 Z., reviewt).
SOLL/FIX: Bestaetigung von G-1 als PROFIL der bestehenden v2-Grammatik (EIN Parser; M-1) mit Kurz-Vokabular m / b h t / w ma mi (Kollisions-Erhebung: 0 von 8 im 62er-Katalog); uebrige F-G1-Fragen stehen nummeriert im Design, Antworten je in einem Satz.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: F-G1-1..-12; Stempel-Strecke KON38.

### [owner-vorlage] 5 (B3)
GEGENSTAND: Zielstruktur-Defaults -- Einspruchs-Frage gegen die Design-Defaults.
ORT: design_zielstruktur.md (final, 199 Z., reviewt); Bau erst WE/nach S-8-Plan.
SOLL/FIX: Defaults: libs/traeger/{planer,ceb,tier,hybrid} als Wurzel * heuristik/ -> HYBRID * mess/-Kaskade -> TIER (Naht-Typen -> Querschnitt) * adjazente Stufen-Kanten. OFFEN als Namens-Detail: "planer" (DE, neu) neben bestehendem profile_facade/"planner" (EN) -- Kollision VOR dem ersten Umzug entscheiden.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Skeleton-Commit WE 15./16. (Finding 20); S-8.

### [owner-vorlage] 6 (B4)
GEGENSTAND: ##26-Formel -- harter M==N-Zweig oder Formel angleichen (Widerspruch Wache vs. Plan).
ORT: ci/mess_ausbeute_wache.sh (super); Wellenplan v2 :27-Formel.
SOLL/FIX: Empfehlung: harten Zweig NUR bei modus=voll (leere Datei im Vollmodus = rot), Warnung bleibt fuer provision/pruef -- erhaelt beide Doktrinen. Frage: so bauen?
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Finding 25; Luecken-Dump ##26-Bau-Anweisung.

### [owner-vorlage] 7 (B5)
GEGENSTAND: kVollausbau-Zulassung (S-7-Randfrage) -- 59-Knoten-Vollausbau bewusst NICHT signaturfaehig (T-4-Gegeneingang).
ORT: algo_stempel_zulassung.hpp (S-7-Branch); algo_semver.hpp:1232.
SOLL/FIX: Frage: so belassen (Empfehlung: ja) oder spaetere Vollausbau-Zulassung erwartet (dann additiver 23er-Signatur-Katalog-Ausbau als eigener Posten)?
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Finding 52.

### [owner-vorlage] 8 (C1)
GEGENSTAND: A-3-Token-Rotation -- 776 Runner-Registration-Token, Instanz akzeptiert weiterhin Registration-Tokens; Owner-GO vom 10.08. NICHT vollzogen (KON58-04).
ORT: GitLab-Instanz (Infra).
SOLL/FIX: Frage: Reset JE PROJEKT oder INSTANZWEIT (Infra-Handout folgt dann)?
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Finding 15; Task #10 (Token-Hygiene-Buendel).

### [owner-vorlage] 9 (C2)
GEGENSTAND: Umbrella-CI strukturell rot seit 06.03. (macOS-/Windows-Jobs ohne Runner); ARBEITSWEISE-Pushes v4.0-v4.3 koennen dort nie gruen werden; allow_failure verboten.
ORT: Umbrella-Repo comdare/projekte, CI.
SOLL/FIX: Frage: (a) Runner bereitstellen, (b) Job-Rules auf vorhandene Runner einschraenken, oder (c) Doku-only-Pipeline fuer docs/-Aenderungen? Empfehlung: (b) als kleinster Schnitt.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Finding 34; Push->gruen-Doktrin (NE-27-Rest).

### [owner-vorlage] 10 (C3)
GEGENSTAND: TeX im gitlab-runner-Job-PATH -- PDF-Gate jetzt hart on (fail-closed); /usr/local/bin traegt seit 03.07. Symlinks.
ORT: gitlab-runner-Host; ci/anhang_forward_core.sh (Gate).
SOLL/FIX: Kein Entscheid noetig, nur Kenntnisnahme: erster scharfer anhang:forward-Lauf beantwortet empirisch; wenn Runner die Symlinks nicht sieht, ist der Lauf LAUT rot (gewollt) und TeX-in-PATH wird Infra-Posten.
STATUS LT. QUELLE: nur-hinweis (Kenntnisnahme)
ABHAENGIGKEIT/FLAECHE: Finding 41; F1-Echtlauf.

### [owner-vorlage] 11 (D1)
GEGENSTAND: Backup-Ref pre-secret-scrub-20260802 -- bereits am 10.08. mit Owner-"volles GO" geloescht; Kette am Roh-Transkript belegt (Vorlage 12:20Z -> GO 12:40Z -> Loeschung 12:43Z -> Vollscan 776->0).
ORT: Roh-Transkript 5a19728e (L35872/35912/35924f); MinIO-Vorlage Frage 2.
SOLL/FIX: MinIO-Vorlage Frage 2 ist damit Kenntnisnahme, keine Frage mehr.
STATUS LT. QUELLE: nur-hinweis (Kenntnisnahme)
ABHAENGIGKEIT/FLAECHE: e21-Verify Quittungen 3/5.

### [owner-vorlage] 12 (D2)
GEGENSTAND: E-2 Merge-Stempel -- die am 10.08. erbetene "mit mehr Kontext"-Neuvorlage ist GEGENSTANDSLOS; Owner-E2 vom 02.08. am Objekt vollzogen (merge_stamp ersatzlos entfernt, dreifach belegt).
ORT: ce adhoc_emitter.hpp:110, anatomy_version_stamp.hpp:392, merge_plan.hpp; Ledger :18006/:18219 (stale).
SOLL/FIX: Zwei stale Ledger-Zeilen bekommen Marker.
STATUS LT. QUELLE: nur-hinweis (Kenntnisnahme)
ABHAENGIGKEIT/FLAECHE: Finding 12; Ledger-Nachtrag (Finding 11).

### [owner-vorlage] 13 (D3)
GEGENSTAND: E-4c KON-57/E-26 TEST-SKIP -- die EINE echte Altfrage des E-Blocks: TEST-Schicht aus Owner-E-26 ("Wir kompilieren und Testen nur Aenderungen neu") gegen "Pipeline hart gruen"; Bau-Seite (skip VERBOTEN) und Lager-Seite (Skip nur gueltiger Bestand) sind entschieden.
ORT: Ledger KON-57 :10051, D-2 :4404; A-1-Vorlage Teil III (Text liegt).
SOLL/FIX: Frage: bleibt VOLL-ctest in jeder Pipeline Pflicht (Empfehlung -- heutige Praxis, Kombibau 4 Zellen), oder ist Fingerprint-basierter Test-Skip zulaessig (dann eigener Wachen-Posten)?
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Finding 13.

### [owner-vorlage] 14 (D4)
GEGENSTAND: Landender Riegel-Echtfall -- S-7 lag ausserhalb der Lock-Domaene (Praemisse stale); Wache per transienter Echtbaum-Probe kryptographisch bewiesen (ROT->Regen->GRUEN).
ORT: s1-logs/s7-riegel-echtfall-20260813.log; axis_version.lock sha e7263b82.
SOLL/FIX: Erster LANDENDER Echtfall als Pflichtschritt beim naechsten echten algo_version-Bump (S-6-Fenster/Bump-Buendel W1) eingeplant. Kenntnisnahme.
STATUS LT. QUELLE: nur-hinweis (Kenntnisnahme)
ABHAENGIGKEIT/FLAECHE: Finding 45; Tasks #15/#24/#38a2+d.

### [owner-vorlage] 15 (Landungs-Plan nach GO)
GEGENSTAND: Was nach Owner-GO sofort laeuft (kein Entscheid, Blanko-GO-gedeckt): die DREI-STUFEN-LANDUNG.
ORT: Vorlage, Schlussabschnitt.
SOLL/FIX: Verbatim: "DREI-STUFEN-LANDUNG (v4.3/A2.1b): serielle Merges mit Harmonisierung (ce: S-7 178bb1fb + Wachen 07a60cc7 + p6-Lizenz f6d13dfb + Registry-XML-Regen [F1-Lens N1]; super: F1-Paket 8e9a31d2 + texgate 5363eebb + e21 fe7bb459 + 8 lokale Commits + Designs + Ledger-Nachtrag) -> KOMPLEX-FIX (ein Fable-5-max-Workflow: Merge-Regressionen + 64-Findings-Liste + Pausen-Sorgfalt P1-P4 gegen die Original-Auftraege) -> EIN Push je Repo, EINE CI, Gitlink-Bump + PZW -> F1-ECHTLAUF (Messung + ANHANG_FORWARD, bash-Rezept) -> F1-Endbeleg."
STATUS LT. QUELLE: offen (wartet auf Owner-GO)
ABHAENGIGKEIT/FLAECHE: ALLE Merge-Flaechen 1-6 (Sammelliste A); Findings 39/54/60/61/36.

================================================================================
TEIL 3 -- RAHMEN-FAKTEN AUS PAUSE-2-DOKUMENT UND 00-INDEX (fuer P2-Stale-Checks)
================================================================================

### [pause2] 1
GEGENSTAND: Stand bei Pause 2 (13.08.): NICHTS gepusht seit a103e518 (super) / b7ffecb->6d7fc83 (Umbrella); super development @ a103e518 == origin, 8 lokale Commits a103e518..f3017a77 (Luecken-Stufe 2 + Fixes) LOKAL; ce development @ 5f3f26a5 == origin (CI 15785 success, Gitlink f6829547 gelandet); Umbrella @ 6d7fc83 (v4.3) gepusht, CI strukturell rot.
ORT: PAUSE-2-Dokument Abschnitt 2.
SOLL/FIX: Sammel-Push kommt mit der Drei-Stufen-Landung; diese Stand-Angaben sind der P2-Referenzrahmen (gecachte Stufen nannten teils aeltere Staende).
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Merge-Flaeche 6 (super Push-Bereich); Pausen-Sorgfalt P2.

### [pause2] 2
GEGENSTAND: Die drei per TaskStop gestoppten Workflows + WIP-Staende: S-7 wf_81efb13f-45b (WIP wt-ce-mess-ordnung @ ec3c71fa, Agent committete selbst), WACHEN wf_b6b05f65-923 (WIP wt-ce-wachen @ c0ff9986, WIP-Commit UNGEPRUEFT ueber 0fbcb049), F1-LENS wf_61f2b36f-712 (wt-f1-1x1 sauber @ c134b70a).
ORT: PAUSE-2-Dokument Abschnitt 1; Scripts unter .../workflows/scripts/, Journale .../subagents/workflows/<runId>/journal.jsonl.
SOLL/FIX: Resume-Rezepte mit Prompt-Ergaenzung (bestehenden Branch uebernehmen statt neu anlegen); journal VOR Resume lesen (F1-Lens).
STATUS LT. QUELLE: behoben (alle drei resumed und KOMPLETT lt. Sammelliste-Koepfe); Original-Scripts bleiben P1-Referenz
ABHAENGIGKEIT/FLAECHE: Pausen-Sorgfalt P1-P4 (Sammelliste Abschnitt D).

### [pause2] 3
GEGENSTAND: Branch-Inventar bei Pause 2: super bau/e21-vollzug-a1 (3 Commits), bau/texlive-gate-haertung (4), wip/luecken-stufe2-pause-1308 (Sicherung); ce bau/f1-1x1-honest-empty @ c134b70a, bau/s7-algo-hardware-stempel @ ec3c71fa, bau/wachen-floor-inventar @ c0ff9986, bau/p6-lizenz-umsetzung @ f6d13dfb (Triage-LANDEN-Fall).
ORT: PAUSE-2-Dokument Abschnitt 2.
SOLL/FIX: Landereife Endstaende sind INZWISCHEN weiter (F1 8e9a31d2, S-7 178bb1fb, Wachen 07a60cc7) -- Standort-Angaben je Stufe FRISCH messen (Finding 43).
STATUS LT. QUELLE: teilweise (Momentaufnahme, ueberholt)
ABHAENGIGKEIT/FLAECHE: Merge-Flaechen 1-6.

### [pause2] 4
GEGENSTAND: Auflagen unveraendert: Fable 5 max bis Widerruf * Luecken immer Pflicht * A2.5 + Komplex-Fix * Vault blind * nie rebase * kein add -A * Pipelines nie canceln * gitleaks glpat-+20 aus wirksamer Config * Drei-Bauten-Deckel * ein Schreiber je Worktree.
ORT: PAUSE-2-Dokument Abschnitt 4.
SOLL/FIX: Gelten fuer den Komplex-Fix unveraendert.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: alle Stufen.

### [00-index] 1
GEGENSTAND: Regressions-Gesamtbild = Auftrags-Grundlage des KOMPLEX-FIX (v4.3/A2.1b Stufe 2); Kontext-1-Workflows wgrkst273 (Wellen-Landung P1+P11, ce 5f3f26a5, CI 15785), wuwemnde5 (F1_NICHT_BELEGT, diagram_generator-Defekt), wvi23h1ux (F9-Heilung + #31-Triage 13 Branches) + 8 committete Backups (NN-*.json, u.a. Ultracode-Vollstaendigkeit wtk6lmhln 745KB); Kontext-2-Workflows wv83csrmh, wdfgx3k8f, w1pm0nio7, w2zv55j8v, wjrbqudaw, wfjg4a9k0, wwk6fs0bt, w4kqptnc9, wv4wbbqnn.
ORT: 00-INDEX.md; Backups: super docs/sessions/backups/20260813-luecken-und-vollstaendigkeit/ (01-wtk6lmhln.json .. 08-w9ezc7zw6.json, 8 von 8 lt. Vorkontext-Datei).
SOLL/FIX: Zusammenhaengend auswerten und einbauen; danach als Backup additiv nach super docs/sessions/backups/ (Secret-Scan mit beissendem Koeder VOR dem Commit).
STATUS LT. QUELLE: offen (Backup-Pflicht nach dem Komplex-Fix)
ABHAENGIGKEIT/FLAECHE: BU-SOFORT-Regel; Merge-Flaeche 6.

================================================================================
TEIL 4 -- EXTRAKTION s7_dump_voll.md (S-7 Bau-Rest + Verify + Fix; Branch
bau/s7-algo-hardware-stempel, Basis 5f3f26a5, Endstand 178bb1fb = 548fecd2+ec3c71fa+178bb1fb)
================================================================================

### [s7_dump] 1
GEGENSTAND: Quittungs-Bestand Bau (alle ERFUELLT): Schritt 1 Referenzen (df 38G, Lock-sha e7263b82..., 2181 Z./718 Records), Schritt 2 S-7a Header algo_stempel_zulassung.hpp (169 Z., 12+ CT-Asserts, kVollausbau 59 Knoten T-4-Gegeneingang), Schritt 3 S-7b Bruecke (build_orchestrator.hpp AlgoVersionFn opt-in, r.status=-4 'simd-gate(stempel)', cache_engine_builder_iterator.hpp, profile_run_entry.hpp EIN Aktivierungs-Aufruf, stale Kommentar :314-316 nachgezogen), Schritt 4 S-7c Tests (vollbestand 4 Faelle: 126 registriert/83 enabled/Inertheit 0 von 504; bruecke 8 Faelle: Nullwirkung 0 von 249), T-1 rot zuerst, T-11c M1/M2/M3, Schritt 5 Floor-Sprossen eigener Commit ec3c71fa (491/487/485 LIVE), Schritt 6 Riegel-Sequenz, Schritt 7 Kombibau 4x '0 tests failed out of 490', cf22 clean, Schritt 8 Commits ohne Push, A2.5 dreiwertig.
ORT: s7_dump_voll.md Bau-Teil; commits 548fecd2+ec3c71fa.
SOLL/FIX: P1-Deckungspruefung gegen Original-Script wf_81efb13f-45b (Quittung war transport-abgeschnitten -- Praezedenzfall der D-Auflage).
STATUS LT. QUELLE: behoben@548fecd2+ec3c71fa (Bau komplett)
ABHAENGIGKEIT/FLAECHE: Pausen-Sorgfalt P1/P2; Merge-Flaechen 1/2/4/5.

### [s7_dump] 2
GEGENSTAND: Riegel-Echtfall = transiente Echtbaum-Probe an gelocktem Traeger axis_03a_search_algo_array256.hpp: ROT Exit 1 'Digest geaendert OHNE gueltigen Version-Bump (1.0.0.c -> 1.0.0.c)' -> --write (Lock-sha e580a636...) -> GRUEN '718 Dateien ... deckt 712 von 712 Overlay-Quellen' -> byte-identische Ruecknahme (sha wieder e7263b82...); PLUS NULL-BEWEIS am S-7-Diff (check GRUEN, --write diff-leer, sha unveraendert -- S-7 verschiebt 0 Preimage-Bytes).
ORT: /home/comdare/s1-logs/s7-riegel-echtfall-20260813.log (32 Z.; Symlink 20260814 -> 20260813).
SOLL/FIX: Kein Riegel-Defekt; die Probe landet nie. Erster LANDENDER Echtfall bleibt Pflichtschritt beim naechsten echten algo_version-Bump.
STATUS LT. QUELLE: behoben (Probe erbracht), Rest offen (landender Echtfall)
ABHAENGIGKEIT/FLAECHE: Finding 45; Owner-Frage D4; W1-Bump-Buendel #15/#24/#38a2+d.

### [s7_dump] 3
GEGENSTAND: floor_neu = avx512f 491 / avx2 487 / basis 485, LIVE gemessen (kalter build-covguard, Pruefling-Schalter, 5 von 5 Bloecke AKTIV; +2 je Sprosse = die zwei neuen S-7-Registrierungen; comm beide Richtungen exakt).
ORT: scripts/ci_test_inventory_floor.txt @ ec3c71fa (eigener Commit).
SOLL/FIX: Beim seriellen Merge gewinnt S-7-Stand; am Gesamtstand EINMAL live nachmessen (Anker-Semantik: Nachzug im SELBEN Change des Merges).
STATUS LT. QUELLE: behoben@ec3c71fa (fuer S-7-Stand); Merge-Messung offen
ABHAENGIGKEIT/FLAECHE: Merge-Flaeche 2; Finding 54 (Wachen-Branch laesst 489/485/483).

### [s7_dump] 4
GEGENSTAND: Bau offener Punkt: NE-10-Korrekturtext fuer den Ledger (KON59-02-Nachtrag): (a) mp_size-Nenner der vollen registrierten Organ-Population = 126, nicht 122 (122 = Varianten mit EIGENEM Literal; 123 Literale = 97+2+24, k_ary traegt zwei); enabled = 83; (b) bvset_ist_teilmenge = aktive Produktions-Skip-Logik (1 echte Aufrufstelle build_orchestrator.hpp Schritt (8)), KEINE S-7-Seite; (c) Riegel-Praemisse 'S-7 aendert algo_version-Traeger' war falsch (NULL-BEWEIS).
ORT: Ledger (KON-Nachtrag ausstehend); Zahlen im Test gemessen.
SOLL/FIX: Korrekturtext in den KON-Nachtrag uebernehmen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Finding 46; Ledger-Nachtrag (Finding 11); Merge-Flaeche 6.

### [s7_dump] 5
GEGENSTAND: STALE-Fund (gemeldet, nicht angefasst, Scope-Grenze 9): simd_build_gate.hpp:196-197 verweist auf 'build_orchestrator.hpp:458-459' -- Gate-Block liegt real bei :759ff (nach S-7 :781ff).
ORT: ce libs/.../simd_build_gate.hpp:196-197.
SOLL/FIX: Nachzug gehoert einem Paket, das simd_build_gate.hpp anfassen darf.
STATUS LT. QUELLE: offen (nur-gemeldet)
ABHAENGIGKEIT/FLAECHE: Finding 48.

### [s7_dump] 6
GEGENSTAND: Beobachtungsposten: test_d2_abdeckungs_wache_nenner fiel EINMAL unter paralleler ctest-Volllast (1 von 490, clang-Release-Erstlauf; Einzel-Lauf 41/41, Wiederholung 490/490 gruen) -- Flaky-Kandidat unter Last.
ORT: tests/unit/test_d2_abdeckungs_wache_nenner.cpp (shellt ci_test_coverage_guard.sh).
SOLL/FIX: Beobachten; kein S-7-Gegenstand (kein beruehrtes File im Pfad).
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Finding 49; Merge-Flaeche 5 (Kombibau am Gesamtstand).

### [s7_dump] 7
GEGENSTAND: J-4-Hinweis: test_profile_roundtrip ist per comdare_thesis_adhoc_executable EXCLUDE_FROM_ALL (tests/unit/CMakeLists.txt:5557) -- nackter Vollbau ohne explizites Ziel-Target liefert 'Not Run'.
ORT: ce tests/unit/CMakeLists.txt:5557.
SOLL/FIX: CI/Zellen muessen das Ziel explizit bauen (Bestands-Eigenschaft, kein S-7-Defekt).
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Finding 53/64 (N3); Merge-Flaeche 5.

### [s7_dump] 8
GEGENSTAND: Kein Push erfolgt (Auftrag); Lead landet den Zweig bau/s7-algo-hardware-stempel seriell als Welle; Worktree /home/comdare/wt-ce-mess-ordnung sauber, Bauverzeichnisse geraeumt.
ORT: Branch bau/s7-algo-hardware-stempel; Worktree wt-ce-mess-ordnung.
SOLL/FIX: Serielle Landung durch Lead.
STATUS LT. QUELLE: offen (Landung)
ABHAENGIGKEIT/FLAECHE: Drei-Stufen-Landung; Merge-Flaechen 1/2/4/5.

### [s7_dump] 9
GEGENSTAND: C-3a-Abgrenzung: der Kommentar simd_build_gate.hpp bleibt auch nach S-7 korrekt -- erste echte required-Deklaration ist der Owner-Paket-Entscheid C-3a (Vorlage 136a1798, Frist Mi 19.08.); S-7 hat kSimdOrganRequirement und den Tripwire nicht beruehrt.
ORT: ce simd_build_gate.hpp (Tripwire static_assert organ_required_union_size()==0, :272).
SOLL/FIX: Keine Aktion im Komplex-Fix; Owner-Frage A1.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Owner-Frage A1.

### [s7_dump] 10
GEGENSTAND: Bau-Konflikt 1 ANWEISUNG vs OBJEKT: 'literal LEER => Ablehnung' am Objekt widerlegt (profile_to_tree.hpp:104-125 emittiert statische Sub-Achsen-Ebenen; base_pilot/cacheline_study permutieren cacheline real) -- Ausfuehrung: LEER = neutral uebersprungen, im Provider-Kontrakt dokumentiert, Test LeeresLiteralIstNeutralerNichtTraeger.
ORT: ce profile_to_tree.hpp:104-125; algo_stempel_zulassung-Naht.
SOLL/FIX: Deklarierte Objekt-Abweichung -- bei P1-Pruefung gegen Original-Prompt als begruendete Abweichung werten.
STATUS LT. QUELLE: behoben@548fecd2 (deklariert)
ABHAENGIGKEIT/FLAECHE: Pausen-Sorgfalt P1.

### [s7_dump] 11
GEGENSTAND: Bau-Konflikt 2: Sentinel-bei-Varianten-Miss brach test_t2a_f4_facade_plan_durchreichung (planner_thesis_min permutiert search_algo=bplus, Enabled-Tabelle fuehrt 4 andere) -- Ausfuehrung: Provider liefert nackte Tabellen-Antwort (leer bei JEDEM Miss => neutral); Drift-Wache compile-hart am Tabellen-Bau; Gate bleibt fail-closed fuer GELIEFERTE Sentinel-Literale.
ORT: ce compose_algo_signature :269/:291; Test SentinelLiteralFaelltFailClosed.
SOLL/FIX: A2.5-Fix im selben Paket (t2a 'Passed', 4 Zellen 490/490).
STATUS LT. QUELLE: behoben@548fecd2
ABHAENGIGKEIT/FLAECHE: Pausen-Sorgfalt P1.

### [s7_dump] 12
GEGENSTAND: Bau-Konflikt 3: Branchname-Divergenz -- Task-Order bau/s7-algo-hardware-stempel ausgefuehrt; Schnitt-Dokument nennt bau/s7-achsen-algo-stempel (Divergenz war in der Anweisung deklariert).
ORT: Branch bau/s7-algo-hardware-stempel.
SOLL/FIX: Keine; nur Kenntnis fuer P1.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Pausen-Sorgfalt P1.

### [s7_dump] 13
GEGENSTAND: K11-Selbstmeldung Bau: ein frueher Smoke-Check erhob rc nach einer Pipe; sofort verworfen und sauber wiederholt; fehlerhaftes Ergebnis nie als Beleg verwendet.
ORT: S-7-Bau-Protokoll.
SOLL/FIX: Keine.
STATUS LT. QUELLE: behoben (im Lauf)
ABHAENGIGKEIT/FLAECHE: -.

### [s7_dump] 14
GEGENSTAND: Verify-Fund 1 (FIX-PFLICHT, einziger objektwirksamer): Nenner '151 added-Zeilen' der Diff-Probe in scripts/ci_test_inventory_floor.txt in KEINEM Scope reproduzierbar (real: CMakeLists 40 / tests-unit 449 / Commit 736 / beide 770, 717 nicht-leer; Muster-Treffer 3 von 770, alle in der Floor-Datei selbst).
ORT: ce scripts/ci_test_inventory_floor.txt.
SOLL/FIX: Fix-Commit 178bb1fb ersetzt den Satz durch scope-explizite Nenner (40/449/770, Messbereich 5f3f26a5..ec3c71fa per SHA, Korrektur-Vermerk); nur '#'-Kommentarzeilen (+7/-1), Wertzeilen 491/487/485 byte-identisch; Verify: Vollzelle gcc-15 Release auf 178bb1fb '0 tests failed out of 490'.
STATUS LT. QUELLE: behoben@178bb1fb
ABHAENGIGKEIT/FLAECHE: Merge-Flaeche 2.

### [s7_dump] 15
GEGENSTAND: Verify-Fund 2 (Riegel-Einordnung): 'Echtfall' ist transiente Probe, kein gelandeter Echtfall; ERFUELLT gilt nur mit dieser Einordnung; Builder hatte transparent deklariert.
ORT: Riegel-Log + Commit 548fecd2 ('verschiebt KEIN Preimage-Byte').
SOLL/FIX: Entlastet; offener Rest als neuer Fund an Lead/Owner ausgewiesen (landender Echtfall, naechster Bump).
STATUS LT. QUELLE: behoben (entlastet); Rest offen
ABHAENGIGKEIT/FLAECHE: Finding 45; Owner-Frage D4.

### [s7_dump] 16
GEGENSTAND: Verify-Fund 3 (Beleg-Hygiene): die 4 Kombibau-Zellen existierten nur als Commit-/Quittungstext, keine persistierten ctest-Logs; Fix-Stufe startete Nachmessung aller 4 Zellen auf 178bb1fb via j14-s7fix-kombibau.sh, Zelle 1 gcc-15 Release KOMPLETT gruen, Rest lief bei Abruf noch (setsid-detached).
ORT: /home/comdare/s1-logs/s7fix-*-ctest.log + s7fix-kombibau-master.log.
SOLL/FIX: Verbatim Lead-TASK vor Landung: "/usr/bin/grep -E 'tests passed|failed out of' /home/comdare/s1-logs/s7fix-{gcc-rel,gcc-dbg,clang-rel,clang-dbg}-ctest.log => SOLL 4x '... 0 tests failed out of 490'; tail /home/comdare/s1-logs/s7fix-kombibau-master.log => SOLL 'S7FIX-KOMBIBAU ENDE fail=0' + alle Raeum-Belege 0/0."
STATUS LT. QUELLE: teilweise (VERTAGT; Behebung gestartet, Lead-Lesung Pflicht)
ABHAENGIGKEIT/FLAECHE: Finding 44 [ROT]; VOR serieller Landung des S-7-Zweigs.

### [s7_dump] 17
GEGENSTAND: Verify-Fund 4 (Kosmetik): Riegel-Protokollname trug Morgen-Datum (20260814 bei mtime 13.08.); uebergebene Quittung mitten im Kombibau-Beleg abgeschnitten (Transportfehler, nicht Objekt).
ORT: s1-logs; Fix: mv auf s7-riegel-echtfall-20260813.log + Symlink 20260814->20260813 (Commit-Botschaft 548fecd2 bleibt aufloesbar); Inhalt byte-stabil sha256 1d6d191b...
SOLL/FIX: Behoben; fehlende Quittungs-Felder (riegel_echtfall/konflikte) im Fix-Report erneut geliefert.
STATUS LT. QUELLE: behoben
ABHAENGIGKEIT/FLAECHE: Pausen-Sorgfalt P1 (Quittungs-Luecken-Praezedenz).

### [s7_dump] 18
GEGENSTAND: Verify-Fund 5 (Notiz): T-1 fuer test_stempel_zulassung_bruecke lief als 'M1 = objektseitiges Rot' (3 FAILED) statt Test-vor-Objekt-Rot -- deklariert, End-to-End-Test braucht das Objekt; K13-Biss erfuellt (Rot riss GENAU die 3 Ablehnungs-Faelle).
ORT: Commit 548fecd2 (Deklaration literal).
SOLL/FIX: Entlastet, festgehalten fuer Protokoll-Vollstaendigkeit.
STATUS LT. QUELLE: behoben (entlastet)
ABHAENGIGKEIT/FLAECHE: -.

### [s7_dump] 19
GEGENSTAND: Neuer Fund: j14.sh in /home/comdare/s1-logs traegt SRC=/home/comdare/wt-ce-warn-libs HARTKODIERT (Zeile 8), war fuer S-7-Worktree unbrauchbar (erklaert fehlende Zell-Persistierung); Nachfolger j14-s7fix-kombibau.sh persistiert Tails, prueft df-Gate >8G, raeumt nur bei Beleg 0/0.
ORT: /home/comdare/s1-logs/j14.sh:8; j14-s7fix-kombibau.sh.
SOLL/FIX: Bei naechster Gelegenheit SRC/Tags parametrisieren.
STATUS LT. QUELLE: offen (Werkzeug-Hygiene)
ABHAENGIGKEIT/FLAECHE: Finding 50.

### [s7_dump] 20
GEGENSTAND: Verify-Entlastungen (Kurzinventar): Riegel kryptographisch reproduziert (wortgleiche Meldung, identischer Lock-Hash e580a636...); NE-10 bestaetigt (bvset 2 Treffer, Freigabe-Seite 1 Produktions-Aufruf, 123 Literale nachgezaehlt 97+2+24); Preimage-Scope eingehalten (Diff exakt 8 Dateien, keine axes/topics/heuristik/anatomy, golden 0/0, kein Push, nie rebase); Tests beissen (eigene M1-Stichprobe); Floor-Kette verankert (Datei-Kopf verlangt EIGENEN Commit -- Briefing-Zeile 'im SELBEN Commit' stale; ctest -N 490 eindeutige Namen, 491 mit Pruefling-Schalter schluessig).
ORT: s7_dump verify-entlastungen.
SOLL/FIX: Memory-/Task-Zeilen 'Floor-Sprossen im SELBEN Commit' anpassen (Finding 47).
STATUS LT. QUELLE: behoben (Entlastungen); Memory-Nachzug offen
ABHAENGIGKEIT/FLAECHE: Finding 47; Merge-Flaeche 2.

================================================================================
TEIL 5 -- EXTRAKTION wachen_dump_voll.md (Wachen-Paket #39+NE-16; Branch
bau/wachen-floor-inventar, Basis 5f3f26a5, Endstand 07a60cc7 = 092ab7e9+6eb72ace+0fbcb049+07a60cc7)
================================================================================

### [wachen_dump] 1
GEGENSTAND: Quittungs-Bestand Bau: NE-16 Schritt 3 (EXPECT_LE -> EXPECT_EQ Warteliste 3 von 3; Klasse-B-Zaehlung je Art mit Nenner '28 Tabellenzeilen: WacheJob 1, WachenTraeger 3, WacheExtern 3, SuiteTraeger 16, Bau 1, Manuell 1, Template 3', WacheJob UNGEDECKT 0 von 1 Pflicht), Schritt 4b Mutations-Protokoll beidseitig am lebenden Objekt (zz_probe_wache RC=1; toter Block contract:mess_report_smoke RC=1; je Ruecknahme RC=0), NE-16-Commit 6eb72ace (genau 1 Datei test_t6_wachen_inventar.cpp, +283/-14, Floor 489/485/483 bleibt), Kombibau KON55 4 Zellen nacheinander je '100% tests passed, 0 tests failed out of 488' (489 minus 1 Pruefling-Fixture), Raeumen mit Belegpruefung (0 csv/xlsx, Diff exakt 4 Dateien), KEIN PUSH.
ORT: wachen_dump Bau-Teil; commits 092ab7e9+6eb72ace.
SOLL/FIX: P1-Deckungspruefung gegen Original-Script wf_b6b05f65-923.
STATUS LT. QUELLE: behoben@092ab7e9+6eb72ace
ABHAENGIGKEIT/FLAECHE: Pausen-Sorgfalt P1/P3; Merge-Flaechen 1/2/3/5.

### [wachen_dump] 2
GEGENSTAND: Bau offener Punkt Kombibau-Interpretation: NE-16 verlangte 'dieselben 4 Zellen wie #39' -- gefahren wurde EIN Kombibau (4 Zellen) auf dem Gesamtstand NACH beiden Commits; falls Lead 8 Vollbauten meint, steht das aus.
ORT: wachen_dump bau.offene_punkte.
SOLL/FIX: Lt. Sammelliste 58 deklariert und durch Komplex-Fix-Flaeche 5 (Kombibau am zusammengesetzten Stand) gedeckt.
STATUS LT. QUELLE: behoben (gedeckt per Deklaration)
ABHAENGIGKEIT/FLAECHE: Merge-Flaeche 5; Finding 58.

### [wachen_dump] 3
GEGENSTAND: Schrittzahl-SOLL: RAHMEN nannte '2172 Schritte' (Floor-Kopf-Stand 6c010cdc); Live-Bau meldete 2188 Ninja-Schritte; harte SOLLs (489 Tests, 5 von 5 Bloecke) trafen exakt.
ORT: wachen_dump bau.offene_punkte.
SOLL/FIX: Lead soll RAHMEN-Soll aktualisieren; bei naechster Rezept-Zitierung live bestaetigen statt kopieren.
STATUS LT. QUELLE: offen (Doku-Nachzug)
ABHAENGIGKEIT/FLAECHE: Finding 57.

### [wachen_dump] 4
GEGENSTAND: is_original:relock traegt 'allow_failure: true' (.gitlab-ci.yml:919) bei rules when:manual -- Memory-Regel 'allow_failure VERBOTEN seit 06.07' koennte greifen; ausserhalb des Wachen-Auftrags, YAML nicht angefasst.
ORT: ce .gitlab-ci.yml:919 (und arm64-smoke :257 lt. Luecken-WF).
SOLL/FIX: Je Stelle pruefen ob Infra-Grund traegt; wenn ja DEKLARIERTE-AUSNAHME-Kommentar in der 83e06159-Form, wenn nein entfernen (Empfehlung aus Luecken-Dump NE-20-VERTAGT).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Finding 26; Finding 30 (Anker-Drift :898->:919).

### [wachen_dump] 5
GEGENSTAND: SUPER-Repo-Aequivalente derselben Wachen-Klassen (kTabelle-Hinweis 'In super existiert die gtest-Fassung bereits') laut Mandat NICHT ERHOBEN.
ORT: super (ausserhalb wt-ce-wachen).
SOLL/FIX: Eigener Posten nach der Welle.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Finding 56.

### [wachen_dump] 6
GEGENSTAND: Scanner-Grenze (T-9, im Test dokumentiert): job_schluessel() ist kein YAML-Parser -- Schluessel mit Kommentar/Leerraum hinter ':' wuerde nicht als Job gezaehlt (am Objekt 0 von 33 betroffen); V4-ASSERTs machen stumpfes Messgeraet laut.
ORT: ce tests/unit/test_t6_wachen_inventar.cpp.
SOLL/FIX: Durch Verify-F4-Fix GEHAERTET (Block/Flow/quotiert erkannt, FAIL-CLOSED-Rest 'unverstanden' => ASSERT-ROT).
STATUS LT. QUELLE: behoben@07a60cc7
ABHAENGIGKEIT/FLAECHE: Finding 59 (Restkante '"k" :' fail-closed, gewollt).

### [wachen_dump] 7
GEGENSTAND: Build-Baeume entfernt (Raeumen-Pflicht); Reproduktions-Rezept dokumentiert: CC=gcc-15 CXX=g++-15 sh ./configure.sh --with-generator=Ninja --enable-build-tests --build-dir=build-covguard -DCOMDARE_CE_PRUEFLINGE="$PWD/tests/pruefling_fixture" && make inventar BUILD_JOBS=4.
ORT: wachen_dump bau.offene_punkte.
SOLL/FIX: Rezept fuer Reproduktion der Guard-Belege.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Merge-Flaeche 2 (Live-Messung am Gesamtstand).

### [wachen_dump] 8
GEGENSTAND: Bau-Konflikte: KEINE -- tests/unit/CMakeLists.txt (S-7-Hotspot) in beiden Commits unangetastet; Diff 5f3f26a5..HEAD = genau 4 Dateien (guard.sh, floor.txt, test_d2, test_t6); einziger Schreiber, kein Push.
ORT: Branch bau/wachen-floor-inventar.
SOLL/FIX: Harmonisierungs-Flaeche 1 (CMakeLists-Auto-Union) entspannt sich -- trotzdem lt. Flaeche 1 semantisch pruefen (S-7 appenden am Tail).
STATUS LT. QUELLE: behoben (belegt)
ABHAENGIGKEIT/FLAECHE: Merge-Flaeche 1; Finding 54.

### [wachen_dump] 9
GEGENSTAND: Verify-Fund F1: Quittung unvollstaendig -- deckte nur 092ab7e9 (#39), brach in 5c ab; zweiter Commit 6eb72ace (NE-16/KON59-02, 297 von 425 Paket-Diff-Zeilen = groesster Einzelteil) fehlte komplett.
ORT: wachen_dump verify.funde.
SOLL/FIX: Fix = nachgereichte Quittung (kein Code): Klasse-B-Nenner live '25 Jobs von 33 Top-Level-Schluesseln (5 reserviert, 3 Templates)'; kJobTabelle 28 Zeilen; WacheJob UNGEDECKT 0 von 1; S-14a-Riegel (contract:axis-version-lock) in der Tabelle => KON59-02 gedeckt; K13 beidseitig frisch nachgefahren (Koeder zz_probe_flow/zz_probe_quoted ROT MIT NAMEN, toter Block ROT, Ruecknahmen gruen); Guard live 489 == Anker 489.
STATUS LT. QUELLE: behoben (Quittung nachgereicht, am Endstand 07a60cc7 verifiziert)
ABHAENGIGKEIT/FLAECHE: Pausen-Sorgfalt P1-Praezedenz; Merge-Flaeche 3.

### [wachen_dump] 10
GEGENSTAND: Verify-Fund F2: Raeum-/Bau-Beleg fehlte (build-covguard/config.status bei Uebernahme weg; RAHMEN-Pflicht Raeumen mit Belegpruefung + BU-SOFORT nicht in der Quittung).
ORT: wt-ce-wachen.
SOLL/FIX: Fix: Neubau nach Floor-Kopf-Rezept reproduziert ALLE Zahlen; csv/xlsx 8 von 8 committete Fixtures, 0 untracked, 0 im Bau-Baum; BU-SOFORT-Quelle /tmp/a25_wachen_fix/ (00_MANIFEST.txt + 13 Logs + Koeder) fuer Backup-Commit nach super docs/sessions/backups/ (Parent-Schritt, kein Push hier).
STATUS LT. QUELLE: behoben (Belege frisch); BU-Commit offen
ABHAENGIGKEIT/FLAECHE: Finding 55; Merge-Flaeche 6 (super-Backup-Commit).

### [wachen_dump] 11
GEGENSTAND: Verify-Fund F3: Wortlaut-Nachzug im Guard-Output ('UNTERGRENZE (committet)', 'von mindestens', Ausweis-Titel) obwohl Zahl seit #39 EXAKTER Anker.
ORT: ce scripts/ci_test_coverage_guard.sh (Endstand: 685 'ANKER (exakt, committet, ...)', 709 'genau erreicht: X == Anker Y', 1529 Ausweis).
SOLL/FIX: Behoben durch 0fbcb049 (aus dem unterbrochenen Lauf uebernommen, vollstaendig verifiziert inkl. Mutations-Gegenprobe K13; abhaengige Test-Literale im selben Change, T-1 3 von 42 rot gegen alten Guard).
STATUS LT. QUELLE: behoben@0fbcb049
ABHAENGIGKEIT/FLAECHE: Pausen-Sorgfalt P3 (WIP-Uebernahme).

### [wachen_dump] 12
GEGENSTAND: Verify-Fund F4: NE-16-Scanner-Kante -- job_schluessel() erkannte nur '^<schluessel>:$'; Flow-Form ('job: {script: ...}') und quotierte Schluessel fielen STILL aus der Klasse-B-Menge.
ORT: ce tests/unit/test_t6_wachen_inventar.cpp.
SOLL/FIX: Scanner GEHAERTET statt nur dokumentiert (+116/-17): drei Formen erkannt, FAIL-CLOSED-Rest 'unverstanden' => ASSERT-ROT mit Wortlaut; neuer TEST ScannerErkenntBlockFlowUndQuotierteSchluessel (13 Probe-Zeilen = 6 Jobs + 2 reserviert + 1 Template + 1 unverstanden + 3 Nicht-Top-Level); T-1 rot zuerst; K13 beidseitig (alter Scanner + 2 Koeder STILL GRUEN 25/33; gehaertet ROT MIT NAMEN 27/35; Koeder weg 4 von 4 GRUEN). WIP c0ff9986 inhaltlich 1:1 uebernommen, als 07a60cc7 neu committet (soft-reset, kein reset --hard), git diff c0ff9986..07a60cc7 leer.
STATUS LT. QUELLE: behoben@07a60cc7
ABHAENGIGKEIT/FLAECHE: Pausen-Sorgfalt P3 (WIP diff leer belegt); Merge-Flaeche 3.

### [wachen_dump] 13
GEGENSTAND: Verify-Fund F5: Quittungs-Anker veraltet (Zeilennummern zeigten auf Zwischenstand vor NE-16).
ORT: ce scripts/ci_test_coverage_guard.sh Endstand-Adressen: Exit-4-Vorrang 1511-1513; ANKER-Meldung 685; Unterschreitung 686-689; Ueberschreitung/Nachzug 690-707; 'genau erreicht' 709-710; Ausweis 1529.
SOLL/FIX: Alle Anker am Endstand 07a60cc7 live neu vermessen; 0fbcb049-Commit-Text nennt dieselben Adressen (konsistent).
STATUS LT. QUELLE: behoben
ABHAENGIGKEIT/FLAECHE: Anker-Drift-Klasse (vgl. Finding 40).

### [wachen_dump] 14
GEGENSTAND: Fix-Abschluss: KEIN NEUER FUND von Defekt-Qualitaet (4 von 4 t6, 42 von 42 d2, Guard Exit 0, Selbsttest 10/11/0, Hygiene 0/0/0). Hinweis (a): WIP-Commit c0ff9986 existiert auf dem Branch NICHT mehr -- ersetzt durch inhaltsgleichen 07a60cc7 (git diff leer); Landung nimmt Branch-Tip 07a60cc7. Hinweis (b): YAML-legale Form '"k" :' landet benannt im FAIL-CLOSED-Rest (ASSERT-ROT), 0 von 33 betroffen -- gewollt.
ORT: Branch bau/wachen-floor-inventar @ 07a60cc7; neue_commit_shas 0fbcb049+07a60cc7.
SOLL/FIX: Landung nimmt 07a60cc7.
STATUS LT. QUELLE: behoben; Landung offen
ABHAENGIGKEIT/FLAECHE: Finding 54/59; Merge-Flaechen 1/2/3/5.

### [wachen_dump] 15
GEGENSTAND: Verify-Entlastungen (Kurzinventar): Worktree exakt wie behauptet (2 Commits, 4 Dateien, kein Upstream); Alt-Stand-Anker stimmen (A2.2); Wache 1 beisst beidseitig am echten Objekt (Anker 488 => Exit 4 'FLOOR-NACHZUG FEHLT'; 490 => 'UNTERSCHRITTEN um 1'; 489 => GRUEN '489 == 489'); Floor live gemessen (eigener Bau, 5 von 5 Bloecke, ctest -N 489); Selbsttest-Biss belegt (Mutations-Koeder Zeile 703, 42 von 42 gruen; 43. TEST = _WIN32-SKIP-Shim erklaert 41->42); Wache 2 beisst (zz_verify_probe); T-3 beide Nenner fremd (awk-Gegenzaehlung 33 = 25+3+5); Floor-Wertzeilen byte-identisch (489/485/483), Kopf auf ANKER+Nachzug umgestellt, Altwortlaut als HISTORIE.
ORT: wachen_dump verify.entlastungen.
SOLL/FIX: Keine.
STATUS LT. QUELLE: behoben (Entlastungen)
ABHAENGIGKEIT/FLAECHE: Merge-Flaechen 2/3.

================================================================================
TEIL 6 -- EXTRAKTION f1lens_dump_voll.md (F1-Dual-Lens wre78fwii; Branch
bau/f1-1x1-honest-empty @ 8e9a31d2 = 915038ca+c134b70a+ff9a517b+8e9a31d2)
Hinweis: Dump enthaelt Fable-Funde AB 3 (Funde 1-2 nur ueber Fix-Quittungen abgedeckt).
================================================================================

### [f1lens_dump] 1
GEGENSTAND: Fable-Fund 3(b): 4 gehobene Ratio-Fixtures -- 3 unangetastet in den Asserts; ABER Fixture RatioMatrixTrueZeroNumeratorIsDisplayableButZeroDenominatorIsOmitted (:1483, 2x1->2x2 mit NEUER Spalte 100/50) traegt GEAENDERTE Erwartungszahlen (0-Klasse -2.0000 -> -1.3010, NEU point meta min/max +-1.3010, NEU (1,0,0.5000)[-0.3010]); regelkonform nachgerechnet gegen diagram_generator.cpp:417-448 (Semantik dieselbe REGEL, Zahlen nicht).
ORT: Code/05_diagram_generator/tests/test_05_diagram_generator_cached_fixtures.cpp:1483.
SOLL/FIX: Zahlenwechsel im Commit-Body aktenkundig machen (geschah in ff9a517b, Quittung 15i).
STATUS LT. QUELLE: behoben@ff9a517b (Body-Nachtrag)
ABHAENGIGKEIT/FLAECHE: Pausen-Sorgfalt P4.

### [f1lens_dump] 2
GEGENSTAND: Fable-Fund 4(c): BASH-WACHE am Objekt verifiziert (ci/anhang_forward_core.sh:289-299): sh-Aufruf rc=1, 3 FEHLER-Zeilen auf STDERR, POSIX-rein, vor set -euo pipefail (:301); die 3 Ueberlaengen :570/:572/:573 existieren byte-gleich an Basis 3ce69ed2 (nicht vom Diff eingefuehrt).
ORT: super ci/anhang_forward_core.sh:289-299.
SOLL/FIX: Kosmetik-Hinweise (rc 2->1, zsh/ksh-Meldung) -- letzteres in 8e9a31d2 behoben (Quittung 13a).
STATUS LT. QUELLE: behoben (verifiziert)
ABHAENGIGKEIT/FLAECHE: Finding 7 (WF-Rezept bash statt sh).

### [f1lens_dump] 3
GEGENSTAND: Fable-Fund 5(d): MANUAL_RUN.md:279-Nachzug KORREKT (':1310ff'; '(3b) PDF-GATE' literal an :1310, einziger lebender Zeilen-Verweis); CI-Aufrufstellen bestaetigt (.gitlab-ci.yml:2454/:2501, Probe :288 'bash $KERN').
ORT: super MANUAL_RUN.md:279; ci/anhang_forward_core.sh:1310.
SOLL/FIX: Keine.
STATUS LT. QUELLE: behoben (verifiziert)
ABHAENGIGKEIT/FLAECHE: -.

### [f1lens_dump] 4
GEGENSTAND: Fable-Fund 6(e): Commit-Body-Verschweigungen: (i) 915038ca verschweigt Fixture-Zahlenwechsel; (ii) Singular 'Der Messwert selbst ist' auch bei N>1 (1xN/Nx1, kosmetisch); (iii) kein Hinweis, dass Gegenkoeder-Bestand >2x2 nur indirekt gedeckt. POSITIV: Stufe05=51 gruen eigener Lauf, T-1-Rot-Log exakt 3 Tests (543/544/545), Regen-Nenner exakt 4 von 64, surf-1x1-Zusage objektbelegt, Worktree sauber.
ORT: Commits 915038ca; diagram_generator.cpp:1066-1075/:1108-1123/:155-160.
SOLL/FIX: (i) Body-Nachtrag, (ii) Numerus-Fix, (iii) direkter 2x3-Koeder -- alle drei in ff9a517b/8e9a31d2 behoben (Quittungen 15i/15ii/15iii+11).
STATUS LT. QUELLE: behoben@ff9a517b+8e9a31d2
ABHAENGIGKEIT/FLAECHE: Pausen-Sorgfalt P4.

### [f1lens_dump] 5
GEGENSTAND: Fable-Fund 7 (Grenze des Lens): make check 403 Release+Debug nicht selbst wiederholt; latexmk-PDF-Gate + Thesis-Klon-Regeneration nicht selbst gefahren; Byte-Parity der 60 unveraenderten .tex nicht nachgerechnet.
ORT: /tmp/f1_bau/, /tmp/f1_fix_lab/ (Logs stichprobenhaft gegengelesen).
SOLL/FIX: Durch Fix-Stufe geschlossen: 16a (da_unit 405/405 R+D), 16c (cmp 60/64), 16b VERTAGT (anhang:forward-Job des Echtlaufs).
STATUS LT. QUELLE: teilweise (16b vertagt)
ABHAENGIGKEIT/FLAECHE: Finding 62; F1-Echtlauf.

### [f1lens_dump] 6
GEGENSTAND: Fix-Quittung Fund 1 [ENTLASTET]: Landungsklassen-Pflicht (2 Lenses Code+Script) -- Prozessfeststellung ohne Defekt; Diff-Patches existieren (/tmp/f1_diff_full.patch 31854 B, lensA 29986 B, lensB 1868 B).
ORT: /tmp/f1_diff_*.patch.
SOLL/FIX: Keine.
STATUS LT. QUELLE: behoben (entlastet)
ABHAENGIGKEIT/FLAECHE: -.

### [f1lens_dump] 7
GEGENSTAND: Fix-Quittung Fund 2 [ENTLASTET]: Wache deckt 1x1/1xN/Nx1 in beiden Modi, kein Umgehungspfad; Mutant M1 belegt diagram_generator.cpp:330 als einzigen Entscheidungspunkt; da_unit 405/405 Release UND Debug.
ORT: diagram_generator.cpp:330; /tmp/f1_fix2_mutant1_2x3.log.
SOLL/FIX: Keine.
STATUS LT. QUELLE: behoben (entlastet)
ABHAENGIGKEIT/FLAECHE: -.

### [f1lens_dump] 8
GEGENSTAND: Fix-Quittung Fund 3 [ENTLASTET]: Wachen-Position korrekt, kein NxM-Regressionsrisiko; echte NxM direkt testfixiert (Surface2x3StaysRealFigure, Eckwerte verbatim).
ORT: Stufe05 53/53 + da_unit 405/405 R+D.
SOLL/FIX: Keine.
STATUS LT. QUELLE: behoben (entlastet)
ABHAENGIGKEIT/FLAECHE: -.

### [f1lens_dump] 9
GEGENSTAND: Fix-Quittung Fund 4 [BEHOBEN]: Kombination 'echte 0 + alle positiven Verhaeltnisse exakt 1.0' wieder in EINEM Test: RatioMatrixTrueZeroOnAllOnesWidensAxisThenPlacesZeroClassBelow (2x2, 0-Klasse -2.0000, Domaene +-2 = Zahlen des alten 2x1-Korpus); Mutant M2 beweist Koeder-Biss (52/53), P2-t2/P2-t5 beweisbar blind.
ORT: Commit ff9a517b; /tmp/f1_fix2_mutant2_zeroclass.log.
SOLL/FIX: Keine weitere.
STATUS LT. QUELLE: behoben@ff9a517b
ABHAENGIGKEIT/FLAECHE: Finding 60/63 (N2 haengt an diesem Test).

### [f1lens_dump] 10
GEGENSTAND: Fix-Quittung Fund 5 [ENTLASTET]: Lens-B-Gesamturteil (11 Befunde, alle HINWEIS) -- kein tragender Mangel; Einzelposten in Quittungen 6/7/13a-c/14 abgeschlossen, ein Teilfix in 8e9a31d2.
ORT: f1lens_dump.
SOLL/FIX: Keine.
STATUS LT. QUELLE: behoben (entlastet)
ABHAENGIGKEIT/FLAECHE: -.

### [f1lens_dump] 11
GEGENSTAND: Fix-Quittungen Fund 6(i)/(ii)/(iii) [je ENTLASTET]: (i) exportiertes BASH_VERSION taeuscht Guard nicht (export -p enthaelt es nicht; Theoriefall = Vor-Fix-Zustand); (ii) /bin/sh=bash-im-POSIX-Modus wird korrekt durchgelassen (prod1: /bin/sh ist dash, kein lokaler Traeger); (iii) Dot-Sourcing aus Nicht-Bash: kein '.'/'source'-Aufrufer im Repo (0 Treffer), Script als Programm dokumentiert.
ORT: ci/anhang_forward_core.sh; /tmp/f1_fix2_bash_exports.txt.
SOLL/FIX: Keine.
STATUS LT. QUELLE: behoben (entlastet, 3 von 3)
ABHAENGIGKEIT/FLAECHE: -.

### [f1lens_dump] 12
GEGENSTAND: Fix-Quittung Fund 7 [ENTLASTET]: kein CI-Aufrufweg bricht; wc -l 1842 konstant, '(3b) PDF-GATE' :1310, Shebang-Direktstart unberuehrt.
ORT: ci/anhang_forward_core.sh.
SOLL/FIX: Keine.
STATUS LT. QUELLE: behoben (entlastet)
ABHAENGIGKEIT/FLAECHE: -.

### [f1lens_dump] 13
GEGENSTAND: Fix-Quittung Fund 8 [ENTLASTET]: Pruefgrenze beider Lenses (bwrap-Blockade, Inline-Diff) -- transparente Grenzfeststellung; dateiabhaengige Kernaussagen in der Fix-Stufe erneut am Objekt bestaetigt.
ORT: Reads :140/:259-343/:417-448/:473-586; Mutanten an :330 und :432/:436.
SOLL/FIX: Keine.
STATUS LT. QUELLE: behoben (entlastet)
ABHAENGIGKEIT/FLAECHE: Codex-Lens-Memory (bwrap-Faelle).

### [f1lens_dump] 14
GEGENSTAND: Fix-Quittung Fund 9 [ENTLASTET]: Rahmen eingehalten (Schreiben nur Worktree + /tmp, kein Push, /usr/bin/grep absolut); eine dash-rc-Messung hinter tail-Pipe als K11 erkannt und ohne Pipe wiederholt (dash rc=1).
ORT: f1lens_dump.
SOLL/FIX: Keine.
STATUS LT. QUELLE: behoben (entlastet)
ABHAENGIGKEIT/FLAECHE: K11-Falle (real beissend, s. N4).

### [f1lens_dump] 15
GEGENSTAND: Fix-Quittung Fund 10 [ENTLASTET]: kein Falsch-Ausloeser der Wache; CLI-Proben (2x3/3x2 echte Figur, 1x3 Platzhalter) dauerhaft testfixiert; ragged-Matrix hat keinen Repo-Erzeuger und war vor dem Fix gleichermassen latex-fatal.
ORT: Surface2x3StaysRealFigure (53/53 beide Konfigs).
SOLL/FIX: Keine.
STATUS LT. QUELLE: behoben (entlastet)
ABHAENGIGKEIT/FLAECHE: -.

### [f1lens_dump] 16
GEGENSTAND: Fix-Quittung Fund 11 [BEHOBEN]: Gegenkoeder-Luecke Spalten>2 im Nicht-Ratio-Pfad (2x3) -- Test Surface2x3StaysRealFigure ergaenzt; Mutant 'nx != 2' reisst GENAU diesen Test (52/53), Revert 53/53 R+D.
ORT: Commit ff9a517b; /tmp/f1_fix2_mutant1_2x3.log, _gate_final_*.log.
SOLL/FIX: Keine weitere.
STATUS LT. QUELLE: behoben@ff9a517b
ABHAENGIGKEIT/FLAECHE: Finding 60.

### [f1lens_dump] 17
GEGENSTAND: Fix-Quittung Fund 12 [ENTLASTET]: die 4 gehobenen Ratio-Fixtures (Zahlenwechsel regelkonform); alle in 53/53 beider Konfigurationen erneut gefahren; Erwartungszahlen-Wechsel jetzt im Body von ff9a517b aktenkundig.
ORT: test_05_diagram_generator_cached_fixtures.cpp.
SOLL/FIX: Keine weitere.
STATUS LT. QUELLE: behoben (entlastet)
ABHAENGIGKEIT/FLAECHE: -.

### [f1lens_dump] 18
GEGENSTAND: Fix-Quittung Fund 13a [BEHOBEN]: zsh/ksh-Aufrufer bekamen dash-benannte Meldung -- Zeile 296 nennt jetzt das Erkennungskriterium ('BASH_VERSION leer -- z.B. sh/dash/zsh/ksh') statt geratener Shell; Proben sh/dash/busybox je rc=1 ohne Pipe.
ORT: Commit 8e9a31d2; ci/anhang_forward_core.sh:296.
SOLL/FIX: Keine weitere.
STATUS LT. QUELLE: behoben@8e9a31d2
ABHAENGIGKEIT/FLAECHE: Finding 60 ('Wachen-Meldung nennt Kriterium').

### [f1lens_dump] 19
GEGENSTAND: Fix-Quittungen Fund 13b/13c [je ENTLASTET]: (13b) drei Ueberlaengen :570/:572/:573 byte-gleich an Basis 3ce69ed2, nicht vom Paket eingefuehrt; (13c) rc-Wechsel 2->1 fuer sh-Fehlaufruf = dokumentierter Exit-Vertrag (:286), kein Repo-Aufrufer unterscheidet.
ORT: ci/anhang_forward_core.sh.
SOLL/FIX: Keine.
STATUS LT. QUELLE: behoben (entlastet, 2 von 2)
ABHAENGIGKEIT/FLAECHE: -.

### [f1lens_dump] 20
GEGENSTAND: Fix-Quittung Fund 14 [ENTLASTET]: MANUAL_RUN.md:279-Nachzug ':1310ff' nach 8e9a31d2 erneut exakt.
ORT: MANUAL_RUN.md:279.
SOLL/FIX: Keine.
STATUS LT. QUELLE: behoben (entlastet)
ABHAENGIGKEIT/FLAECHE: -.

### [f1lens_dump] 21
GEGENSTAND: Fix-Quittungen Fund 15(i)/(ii)/(iii) [je BEHOBEN]: (i) Body-Nachtrag Fixture-Zahlenwechsel literal in ff9a517b (kein Rewrite der Historie, nie rebase/amend); (ii) Numerus-Fix degenerate_size_note: Vermerk zaehlt darstellbare Zellen mit Writer-Logik, Singular nur bei genau einem Messwert, de+en; T-1 Plural-Assertions ROT am Alt-Code (52/53) -> GRUEN 53/53 R+D; (iii) direkter 2x3-Bestandskoeder + Benennung im Body.
ORT: Commit ff9a517b; /tmp/f1_fix2_rot_numerus.log.
SOLL/FIX: Keine weitere.
STATUS LT. QUELLE: behoben@ff9a517b (3 von 3)
ABHAENGIGKEIT/FLAECHE: Finding 60.

### [f1lens_dump] 22
GEGENSTAND: Fix-Quittung Fund 16a [ENTLASTET]: 403er-Kombigate nachgefahren auf offiziellem Weg (ctest -L da_unit, identisch .gitlab-ci.yml:290): Release 405/405 rc=0 UND Debug 405/405 rc=0 (403 Bestand + 2 neue Tests).
ORT: /tmp/f1_fix2_dagate_release.log, _debug.log.
SOLL/FIX: Keine.
STATUS LT. QUELLE: behoben (entlastet)
ABHAENGIGKEIT/FLAECHE: -.

### [f1lens_dump] 23
GEGENSTAND: Fix-Quittung Fund 16b [VERTAGT]: latexmk-PDF-Gate + Thesis-Klon-Regeneration nicht selbst gefahren -- PDF-Gate ist das Alles-oder-Nichts-Gate des anhang-Kerns im CI-Lauf; Bau-Stufe hat es fuer exakt diesen Diff mit Logs belegt; lokaler latexmk-Lauf gehoert nicht zum Fix-Stufen-Gate.
ORT: MANUAL_RUN.md:277-279; Kern :1310ff.
SOLL/FIX: Platz: anhang:forward-Job des naechsten CI-Laufs der Welle (Landung).
STATUS LT. QUELLE: teilweise (vertagt, geplant)
ABHAENGIGKEIT/FLAECHE: Finding 62; F1-Echtlauf; texgate-Gate hart on.

### [f1lens_dump] 24
GEGENSTAND: Fix-Quittung Fund 16c [ENTLASTET]: Byte-Parity selbst gemessen -- cmp ueber alle 64 Pfade: identisch=60 verschieden=4 fehlend=0; die 4 Differenzen exakt die 4 Dateien aus regen_diff.txt (lc_surface_ns_per_op + lc_surface_op_lookup_p50_ns, de+en).
ORT: /tmp/f1_bau/regen_liste.txt; /tmp/f1_art vs /tmp/f1_regen.
SOLL/FIX: Keine.
STATUS LT. QUELLE: behoben (entlastet)
ABHAENGIGKEIT/FLAECHE: Finding 60 (Byte-Parity 60/64).

### [f1lens_dump] 25
GEGENSTAND: Neuer Fund N1 [VERTAGT, ce-Territorium]: test_axis_registry_roundtrip ROT mit BYTE-DRIFT -- committete ce-Registry-XML (libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml) entspricht nicht der Reflektion des aktuellen ce-Codes (u.a. memory_layout_packed_bitmap neu); ausserhalb des F1-Diffs und des da_unit-Gates; system-/measurement-Roundtrip nach 2-Pass-Bau gruen, Achsen-Roundtrip bleibt Daten-Drift des ce-Submodulstands.
ORT: ce libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml.
SOLL/FIX: Behebung = Generator-Lauf (comdare_axis_registry_gen, 2-Pass) + XML-Commit IM ce-Repo; in den Komplex-Fix (ce-Seite) aufnehmen -- VOR dem Push, sonst faellt der contract-Job am zusammengesetzten Stand.
STATUS LT. QUELLE: offen (Pflicht-Fix ce)
ABHAENGIGKEIT/FLAECHE: Finding 61 [ROT]; Drei-Stufen-Landung ce (Registry-XML-Regen ist dort als 4. ce-Merge-Posten genannt); Merge-Flaeche 5.

### [f1lens_dump] 26
GEGENSTAND: Neuer Fund N2 (dokumentiert + testfixiert, Bestand seit P2): Colorbar-Tick-Kollision '$0$' neben '$10^{-2}$' bei All-Ones+Zero; schon der alte 2x1-Korpus emittierte exakt diese Liste; im neuen Test bewusst festgeschrieben.
ORT: RatioMatrixTrueZeroOnAllOnesWidensAxisThenPlacesZeroClassBelow (Kommentar).
SOLL/FIX: Moeglicher spaeterer Kosmetik-Posten (Tick-Dedupe), kein F1-Gegenstand.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Finding 63.

### [f1lens_dump] 27
GEGENSTAND: Neuer Fund N3 (Gate-Beobachtung, J-1-Muster): blankes 'ctest' im build-test-Baum zaehlt 886 Tests mit 474 Not-Run (ce-Registrierungen ohne gebaute Binaries) -- als Vollgruen-Gate ungeeignet; offizielles Gate 'ctest -L da_unit' (.gitlab-ci.yml:290) bzw. make check; Roundtrip-Werkzeuge erst nach explizitem 2-Pass-Bau.
ORT: super build-test; .gitlab-ci.yml:290.
SOLL/FIX: In Lande-/CI-Rezepte uebernehmen.
STATUS LT. QUELLE: offen (Rezept-Nachzug)
ABHAENGIGKEIT/FLAECHE: Finding 64; Merge-Flaeche 6.

### [f1lens_dump] 28
GEGENSTAND: Neuer Fund N4 (Arbeitsbeleg K11, transparent): erste dash-Nachprobe mass rc hinter tail-Pipe (faelschlich 0); ohne Pipe wiederholt -> dash rc=1 -- bestaetigt die Rahmen-Regel 'rc ohne Pipe' als real beissende Falle.
ORT: f1lens_dump.
SOLL/FIX: Keine (Regel bestaetigt).
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: K11-Doktrin.

================================================================================
TEIL 7 -- EXTRAKTION luecken_dump_voll.md (Luecken-WF wdfgx3k8f: Triage + Bau1 + Bau2 +
Verify + Fix; 8 super-Commits lokal a103e518..f3017a77 + Umbrella 2142439)
================================================================================

### [luecken_dump] 1
GEGENSTAND: Triage W0a/D1e (f15-CLI Baukante+Wrapper) = SCHON_ERLEDIGT (cli_smoke.cmake existiert, CMakeLists:1734-1763, gelandet 84672350); Restlisten-Fuehrung war Plan-Artefakt.
ORT: ce tests/unit/cli_smoke.cmake; tests/unit/CMakeLists.txt:1734-1763.
SOLL/FIX: Rest-Verifikation (1 Zeile, kein Bau): im naechsten gruenen ce-test:unit-Log pruefen, dass f15_compare_cli_smoke in build/Testing/ctest_unit_inventar.txt steht.
STATUS LT. QUELLE: behoben@84672350; Mini-Restverifikation offen
ABHAENGIGKEIT/FLAECHE: naechste gruene ce-CI (nach dem Push).

### [luecken_dump] 2
GEGENSTAND: Triage W0a/D1f (5 STATUS_OUT / 3 Zustaende) = SCHON_ERLEDIGT (anatomy_codegen_runner.cmake:31/:134-153/:87-92; ERROR eliminiert; Zaehl-Drift 5-vs-6 aufgeklaert: 6 Vorkommen ueber 5 Bloecke, 1 if/else-Paar).
ORT: ce cmake/anatomy_codegen_runner.cmake.
SOLL/FIX: Optionaler Doku-Nachzug: im Wellenplan v2 die Zahl '5 Bloecke (6 Vorkommen, 1 if/else-Paar)' nachtragen.
STATUS LT. QUELLE: behoben; optionaler Doku-Nachzug offen
ABHAENGIGKEIT/FLAECHE: -.

### [luecken_dump] 3
GEGENSTAND: Triage W0a/D1c (Abdeckungs-Wache Vollausbau, 3 Zahlen aus 3 Quellen) = SCHON_ERLEDIGT (dritte Achse D1c fail-closed, Exit-Klasse 4; CI-bewiesen 15751 SUCCESS, coverage-guard 21 min, Selbsttest 5/5).
ORT: ce scripts/ci_test_coverage_guard.sh :41/:855-905/:1366.
SOLL/FIX: Keine (Floor-Nachzug-Wache ist eigener Posten Task #39, dort gelaufen).
STATUS LT. QUELLE: behoben
ABHAENGIGKEIT/FLAECHE: -.

### [luecken_dump] 4
GEGENSTAND: Triage W0a/D2-G2 (Registrierung ohne Bau macht Hauptpipeline rot) = SCHON_ERLEDIGT (eigener contract-Job test:coverage-guard mit Vollbau, ce .gitlab-ci.yml:318ff/:529-558); Buchstabe 'TIMEOUT x4' als ctest-Property gegenstandslos (Job-Timeout greift).
ORT: ce .gitlab-ci.yml:318ff.
SOLL/FIX: Falls x4-TIMEOUT-Zusicherung gewollt: timeout-Schluessel am Job test:coverage-guard auf 21 min x 4 = 84m (eine YAML-Zeile).
STATUS LT. QUELLE: behoben; optionale YAML-Zeile offen
ABHAENGIGKEIT/FLAECHE: -.

### [luecken_dump] 5
GEGENSTAND: Triage W0a/##06-CI-Haelfte (Bedingungs-Tabelle als CI-Job mit IST-Nenner) = TEILS_OFFEN: Zusicherungs-Job faehrt nur --nur-zusicherung --gegen-vorlage; VOLLE Formel braucht --ctest-liste; Voraussetzung (ce test:unit publiziert Inventur-Artefakt) seit D1c GELIEFERT; kein Job faehrt die volle Formel (0 Treffer 'abnahme06' in ce-YAML).
ORT: super .gitlab-ci.yml:1132-1144; scripts/ci_abnahme06_bedingungs_tabelle.sh (Kopf :91-104).
SOLL/FIX: Verbatim Bau-Anweisung: "super .gitlab-ci.yml: Job test:abnahme06-voll neben :1132 anlegen; Schritt 1: Inventur beziehen - entweder per cross-project-Artefakt (curl mit CI_JOB_TOKEN auf das letzte gruene ce-test:unit-Artefakt build/Testing/ctest_unit_inventar.txt, ref development) oder als needs auf einen super-Job, der den vendorierten Baum konfiguriert und 'ctest -N' nach datei schreibt; Schritt 2: sh scripts/ci_abnahme06_bedingungs_tabelle.selbsttest.sh, dann sh scripts/ci_abnahme06_bedingungs_tabelle.sh --ctest-liste <datei>; Abnahme: die 6 Formel-Zahlen (bedingte_registrierungen=18/bedingungs_klassen=14/erfuellt/allowlist_mit_begruendung/ohne_allowlist_eintrag=0/allowlist_zusicherung_verletzt=0) MIT Host-Kennung literal im Job-Log; kein allow_failure."
STATUS LT. QUELLE: teilweise (Bau-Anweisung liegt)
ABHAENGIGKEIT/FLAECHE: Finding 21.

### [luecken_dump] 6
GEGENSTAND: Triage W0a/##07 (f15-Risse, ctest-N-Sichtbarkeit + Wachen-Zuordnung) = SCHON_ERLEDIGT (deckungsgleich mit D1e-Landung; Wachen-Zuordnung via comdare_registrierung_vermerken BLOCK r5d_f15_compare_cli_smoke).
ORT: ce tests/unit/CMakeLists.txt:1753-1763.
SOLL/FIX: Gleiche 1-Zeilen-Restverifikation wie D1e.
STATUS LT. QUELLE: behoben; Mini-Restverifikation offen
ABHAENGIGKEIT/FLAECHE: naechste gruene ce-CI.

### [luecken_dump] 7
GEGENSTAND: Triage W0a/D2-G6 (Roundtrip-Gates) = TEILS_OFFEN: 3 Registry-Roundtrip-Gates haengen an Datei-Existenz (CMakeLists :5611/:5641/:5656 'AND EXISTS'), Kommentar :5631-5636 verkauft stille Abschaltung als Merkmal, KEIN comdare_registrierung_vermerken an diesen Bloecken; stille Abschaltung heute indirekt gefangen (Floor + D1c-Achse).
ORT: ce tests/unit/CMakeLists.txt:5611/:5641/:5656.
SOLL/FIX: Verbatim: "(a) an allen 3 Gates else-Zweig mit comdare_registrierung_vermerken STATUS UEBERSPRUNGEN + GRUND ergaenzen und den Kommentar 'bewaffnet sich automatisch' durch die Pflicht-Erwartung ersetzen (fehlende XML = vermerkter, sichtbarer Skip). (b) Standard-Bissprobe fahren und protokollieren: system_axis_registry.xml per git stash entfernen, configure, Guard-Lauf MUSS rot mit Namen und 'Inventur N, Untergrenze M, Differenz -k', stash pop, Gegenprobe gruen; Protokoll ins Paket (Koeder beidseitig, K13)."
STATUS LT. QUELLE: teilweise (Bau-Anweisung liegt)
ABHAENGIGKEIT/FLAECHE: Finding 22; ce-Schreibrecht (nach Landung).

### [luecken_dump] 8
GEGENSTAND: Triage W0b/D3-4+D3-5 (lebender Mess-Job) = TEILS_OFFEN: Grossteils geheilt (allow_failure-Emission entfernt, Testat-XOR gebaut, Byte-Determinismus-Tests, Inhalts-Gate super-seitig KOMPLETT inkl. n/a-Zaehler CI-bewiesen 15764); OFFEN am emittierten Grandchild-Batch: (i) KEIN Inhalts-Gate je Batch in der emittierten YAML, (ii) Batch-Bilanz A+B==C nirgends.
ORT: ce experiment_plan_director.hpp (Mess-Batch-Emission vor 'exit $FAIL' :1720).
SOLL/FIX: Verbatim: "Zaehler emittieren - A=$((A+1)) im else-Zweig (MESS-TESTAT), B=$((B+1)) im FEHLER-Zweig, C als Literal aus perms.size(); danach 'echo \"[BATCH-BILANZ] gemessen=$A fehler=$B zellen=C\"; [ $((A+B)) -eq C ] || exit 1'. Inhalts-Gate je Batch: awk-Inline-Gate emittieren (echte Datenzeilen ueber measure_out/<slug> >= 1, n/a-Zeilen zaehlen NICHT - awk-Muster byte-gleich zu ci/mess_ausbeute_wache.sh:262 uebernehmen). Byte-fixierte Unit-Test-Literale im SELBEN Commit nachziehen; T-1 rot zuerst (Mutant: FEHLER-Zelle erzeugen, Bilanz muss reissen)."
STATUS LT. QUELLE: teilweise (Bau-Anweisung liegt)
ABHAENGIGKEIT/FLAECHE: Finding 23; ce-Schreibrecht.

### [luecken_dump] 9
GEGENSTAND: Triage W0b/D3-8 (Frische-Wache PIPELINE_ID) = SCHON_ERLEDIGT (ci/frische_wache.sh vollstaendig, gelandet 028684ac, CI-bewiesen 15764 Job 376333 SUCCESS).
ORT: super ci/frische_wache.sh; .gitlab-ci.yml:1969-1970.
SOLL/FIX: Keine; Scharf-Schaltung mit ergebnis:holen bleibt planmaessig W2 (eigener W2-Posten).
STATUS LT. QUELLE: behoben
ABHAENGIGKEIT/FLAECHE: W2.

### [luecken_dump] 10
GEGENSTAND: Triage W0b/##08-Rest (lazy_csv_header EINMAL, Schema-Freeze) = GEGENSTANDSLOS: Freeze gebaut+bewacht (kWideSchemaFreezeStufe1=189); EINMAL-Invariante haelt (genau 1 Definition, 19 Nutzer-Dateien); 'lazy Header-Emission' darf laut v2-Fussnote NIE gebaut werden (Bau-VERBOT).
ORT: ce schema_freeze.hpp; cache_engine_builder_iterator.hpp:549.
SOLL/FIX: Nichts bauen; Restlisten-Pflege: '##08-Rest' streichen mit den drei Messungen als Begruendung.
STATUS LT. QUELLE: behoben (gegenstandslos); Restlisten-Pflege offen
ABHAENGIGKEIT/FLAECHE: Wellenplan-Pflege.

### [luecken_dump] 11
GEGENSTAND: Triage W0b/##20-B-Restbau = SCHON_ERLEDIGT in besserer Form (ci/anhang_forward_core.sh:1173-1210 staged einzeln, Orakel INDEX, Uebernahme-Nenner-Zeile, fail-loud; gelandet 88464ac7 + 38b6bdbd); Runner-git-Version GEGENSTANDSLOS (--pathspec-from-file nicht verwendet).
ORT: super ci/anhang_forward_core.sh:1173-1210.
SOLL/FIX: Restlisten-Pflege: ##20-B streichen; Wellenplan-Fussnote um Vollzugs-Vermerk ergaenzen.
STATUS LT. QUELLE: behoben; Restlisten-Pflege offen
ABHAENGIGKEIT/FLAECHE: Wellenplan-Pflege.

### [luecken_dump] 12
GEGENSTAND: Triage W0b/##23-R1 (thesis_profiles xlsx-blind) = TEILS_OFFEN, am Gitlink NEU ausgezaehlt: 11 vendorierte Profile, 8 MIT xlsx, 3 OHNE (base_pilot, m3v2_smoke, wdk_fairness_example); alte Zaehlung 'mit_xlsx=1 ohne_xlsx=8 ueber Nenner 9' ueberholt (heute 3 von 11).
ORT: ce libs/cache_engine/algorithm_profiles/thesis_profiles/*.profile.xml.
SOLL/FIX: Verbatim: "In den 3 Profilen den Block aus m3v2_study.profile.xml:181-183 additiv uebernehmen (<method value=\"xlsx\"/> + Kommentarzeile); Abnahme: fuer alle 11 Profile /usr/bin/grep -c xlsx >= 1 (Nenner 11 nennen). ADDITIV halten - S-13 (#18, W2 Di 25.08.) schneidet das Export-Element neu und darf diese Zeilen ersetzen, nicht umgekehrt. Landung im naechsten ce-Slot NACH der laufenden Wellen-Landung."
STATUS LT. QUELLE: teilweise (Bau-Anweisung liegt)
ABHAENGIGKEIT/FLAECHE: Finding 24; S-13/#18; ce-Slot nach Landung.

### [luecken_dump] 13
GEGENSTAND: Triage W0b/##26 (measure-Gate Formel N>=1 UND M==N UND Z>=1) = TEILS_OFFEN: N>=1 hart (:239), Z>=1 hart bei voll (:334-346), M==N nur WARNUNG (:355-358) mit Owner-KERN-Begruendung Sichtbarkeit -- widerspricht korrigierter v2-Formel (:27) und v1-Koeder (:593).
ORT: super ci/mess_ausbeute_wache.sh:355-358.
SOLL/FIX: Verbatim: "harten Zweig bauen: nach :355 'if [ \"$N_LEER\" -gt 0 ] && [ \"$MODUS\" = voll ]; then echo FEHLER ... exit 1; fi' (Warnung bleibt fuer provision_only/pruef_only); Bissproben-Fall in ci/tests/mess_ausbeute_bissprobe.sh ergaenzen: 2 CSVs, eine auf Kopfzeile reduziert => rot mit 'M von N', Gegenprobe gruen. Falls die weiche Form fachlich gewollt bleibt, stattdessen die ##26-Formel im Wellenplan v2 per datiertem Nachtrag ans Objekt angleichen und das Owner-Zitat als Begruendung setzen - NICHT beides stehen lassen."
STATUS LT. QUELLE: teilweise (Owner-Frage B4 entscheidet die Richtung)
ABHAENGIGKEIT/FLAECHE: Finding 25; Owner-Frage B4.

### [luecken_dump] 14
GEGENSTAND: Triage W0b/##27-##31 (Nachlauf) = GANZ_OFFEN: ##31 Wachen-Register NICHT gebaut (0 Treffer in beiden CIs; wachen_paritaet.sh ist NICHT das Register); ##27-##30 haben KEINE Einzeldefinition (0 Treffer ausser Sammelzeilen); bewusst hinter S-2 verschoben (v2:1742).
ORT: beide Repos, CI-YAMLs.
SOLL/FIX: Im Slot hinter S-2, nicht vor F1: (1) ##31 nach v2-Formel bauen (Grundmenge je Lauf frisch zaehlen: heute super ci/ 17 + ci/tests/ 14 + scripts/ 11, ce scripts/ ~25; Abgleich beidseitig rot, je Wache GEFAHRENER Koeder, Rueckfallstufe manuell versioniertes Register). (2) Fuer ##27-##30 ZUERST Definitions-Explore in GOAL-v8-Rohquellen; ohne Gegenstand je Nummer als GEGENSTANDSLOS ausbuchen mit 0-Treffer-Beleg.
STATUS LT. QUELLE: offen (terminiert hinter S-2)
ABHAENGIGKEIT/FLAECHE: Slot hinter S-2.

### [luecken_dump] 15
GEGENSTAND: Triage W0b/#21-Pruefposten E-1..E-4-Vollzug = war GANZ_OFFEN; Gegenstaende E-1 (KON11-03 Weg C), E-2=K1, E-3=K2, E-4=K5; Dringlichkeit durch KON58-04 Befund 3 erhoeht (A-1-Vorlagetext fuer Owner-Frage backup-ref).
ORT: Ledger :4123-4124, :13180-13182; Task #21.
SOLL/FIX: Pruef-Explore READ-ONLY je E-Entscheid; A-1-Vorlagetext (Roh ~Z.35872) woertlich uebernehmen; via scripts/ledger_nachtrag.sh verbuchen; #10-Ref-Haelfte entsperren. ACHTUNG: Genau das hat der e21-WF w1pm0nio7 INZWISCHEN geleistet (Verify BESTAETIGT, s. Teil 8) -- nicht doppeln; Rest = Ledger-Nachtrag (Finding 11).
STATUS LT. QUELLE: behoben durch e21-WF (Ledger-Nachtrag offen)
ABHAENGIGKEIT/FLAECHE: Findings 11/13/31; Task #21/#10.

### [luecken_dump] 16
GEGENSTAND: Triage #81 (Owner-Auftrag: Verify ueber W0b-Bauposten wiederholen) = GANZ_OFFEN: 0 Treffer '#81' im Ledger (26997 Z.); Owner-Wortlaut 11.08. inkl. Pflicht 'er muss die Pipeline messen'; Teil-Beweise ersetzen den beauftragten Wiederhol-Verify nicht.
ORT: 20260811-KONTEXTUEBERGABE-...md:67-75; nacht-7:164; Task #43.
SOLL/FIX: Verify-Workflow nach A1/v3.6 fahren (Opus 5 max ERHEBT, Fable 5 max BEWERTET, Codex-Lens klein geschnitten): Gegenstaende = W0b-Endstaende (mess_ausbeute/frische/lauf_marker/persist_sammler/anhang_forward + emittierte Director-YAML) MIT Pipeline-Messung (15764-Trace, Job-IDs zitieren); Ergebnis mit #81-Referenz via ledger_nachtrag.sh.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Finding 38; kann Teil des Komplex-Fix-Verify sein oder separat.

### [luecken_dump] 17
GEGENSTAND: Zaehlwerk 137-vs-123 Flag-Literale AUFGEKLAERT (Scope-Differenz, kein Drift): 123 = same-line im Organ-Scope (97x 1.0.0.c + 24x 1.0.2.c + 2x 1.0.1.c; 122 Lock-Traeger-Dateien + 1 Doppel-Literal k_ary); 137 (KON9-05) = alle ce-eigenen Literale, Ledger loest bei KON8-08 (:6862-6863) selbst auf: 137 = 123 Organ + 7 System + 6 Mess + 1 Planer; heute reproduziert die 137 NICHT mehr (same-line ausserhalb axes/topics = 0 von 0; telemetry inzwischen CEB-System-Achse).
ORT: Ledger :5272/:5395/:5470 (drei 'unaufgeklaert'-Vermerke); Kommando im Dump ausgeschrieben.
SOLL/FIX: Die drei 'Differenz 14 unaufgeklaert'-Vermerke schliessen (Ledger-Nachtrag).
STATUS LT. QUELLE: behoben (aufgeklaert); Ledger-Verbuchung offen
ABHAENGIGKEIT/FLAECHE: Finding 32.

### [luecken_dump] 18
GEGENSTAND: Zaehlwerk #67 '142 Include-Kanten / 29 Wanderungen': Kanten-Definition fuer 142 EXISTIERT NICHT (0 Belegstellen; einzige Treffer die Unbelegt-Vermerke :4528/:4630/:5789); die 29 IST reproduzierbar unter sauberer Definition (Familien-Header basename version|stamp|semver|fingerprint, 24 Dateien; eingehende Include-Zeilen libs = 29 von 29; repo-weit 39 = libs 29 + tests 9 + apps 1); 142 reproduziert kein heutiger Schnitt (ausgehende Kanten 175; Ledger :8722 summiert 60).
ORT: Ledger :4528 (Owner: 'Bitte explore und schaerfen, behalten').
SOLL/FIX: Bau-Anweisung fuer S-6d/#67: die 29er-Definition als Kanten-Definition in den Wellenplan uebernehmen (Kommando ausgeschrieben), 142 als historisch ohne Definition markieren.
STATUS LT. QUELLE: offen (S-6d-Neuerhebung)
ABHAENGIGKEIT/FLAECHE: Findings 19/32; S-6d.

### [luecken_dump] 19
GEGENSTAND: Zaehlwerk KON11-01-Elferliste, Zeile fuer Zeile am ce 5f3f26a5: BILANZ 4 widerlegt (1 Director unangeschlossen, 3 axis_version_lock, 7 IResourceControllableTier, 11 Hybrid ohne Stempel-Bezug), 1 teilwiderlegt (2 LagerBaumWriter: Kern '0 Produktions-Aufrufer' stimmt noch), 5 stimmen (4 run_selection_filter_chain, 6 AxisCommand, 8 i_command GEPARKT, 9 v32_messreihe_antrieb, sowie 5/10 Bestandsaussagen); admit_organ als unverdrahtet ebenfalls widerlegt (5 Dateien).
ORT: luecken_dump zaehlwerke; ce 5f3f26a5.
SOLL/FIX: KON11-01-Elferliste-Bilanz in den Ledger (4 widerlegt/1 teil/5 halten).
STATUS LT. QUELLE: behoben (erhoben); Ledger-Verbuchung offen
ABHAENGIGKEIT/FLAECHE: Finding 32.

### [luecken_dump] 20
GEGENSTAND: A/E-Mengen (Strang A = S-6a-Umstellung, Strang E = B2/B3/B5-Gates): SCHNITTMENGE NICHT leer -- 3 von 12 geprueften E-Dateien mit harter Include-Kante auf A-Kern (mess_konsistenz_gate.hpp, lazy_adhoc_source_gen.hpp, ceb_version_stamp.hpp) + Glied-[3]-Inhaltskopplung mess_achsen_naht.hpp + 1 gemeinsamer Test (test_r3_mess_gates_spiegel.cpp); hybrid-Gates vollstaendig disjunkt (0 Treffer).
ORT: ce libs (Datei-Anker im Dump); WF6-Synthese :38/:40/:44.
SOLL/FIX: FOLGE fuer B5-Lande-Slot (vor Mo 17.08. zu fixieren): B5 darf NICHT parallel zum S-6a-Fenster fahren; B5 seriell HINTER S-5 -> S-6a in dasselbe W1-Fenster (ein Schreiber je Datei); B2/B3-Hybrid-Anteile parallelisierbar; einzige geteilte B2/B3-Datei mit S-6a-Naehe ist mess_achsen_naht.hpp -- dort denselben Seriell-Slot verwenden.
STATUS LT. QUELLE: offen (Ledger-/W1-Plan-Zeile fehlt, in #24 verbucht)
ABHAENGIGKEIT/FLAECHE: Finding 33; Tasks #24/#15; Frist vor Mo 17.08.

### [luecken_dump] 21
GEGENSTAND: Bau1-Quittungsbestand (alle BEHOBEN): NE-13 GOLDEN-VERSION.md (367d732c, G-2026-07-26, 4 Fixtures je 320 ids), NE-18 Ledger-Korrektur admit_organ_on_machine (e8126eb1, 'vorhanden, aber inert', KON59), NE-11a BU-SOFORT 7 von 8 (6316c2d2), NE-11b Werkzeuge versioniert (8f4b4f1a: minio_blind_smoke.sh + worktree_remove_safe.sh), NE-26 Marker-Nachzug 13 Stellen (e3e75350), NE-21 Designplan Par.11 (3ce69ed2), NE-27 ARBEITSWEISE v4.1 (Umbrella 2142439, gepusht).
ORT: super development lokal; Umbrella.
SOLL/FIX: P1-Deckung gegen Original-Script wf_046aab6c-928 (Pause-1-Workflow).
STATUS LT. QUELLE: behoben (7 von 7 Quittungen)
ABHAENGIGKEIT/FLAECHE: Pausen-Sorgfalt P1/P3; Merge-Flaeche 6.

### [luecken_dump] 22
GEGENSTAND: Bau1 offener Punkt: Datei 01-wtk6lmhln.json (745 KB) zunaechst NICHT committet (15er-BU-grep biss auf Prosa 'glpat-Regel-Klassen-Lehre'; echtes gitleaks 0 findings = provozierter Falsch-Positiv).
ORT: super docs/sessions/backups/20260813-luecken-und-vollstaendigkeit/01-wtk6lmhln.json.
SOLL/FIX: Lead-Entscheid committen oder Allowlist -- in Bau2 GELOEST: 5d67207b committet den 8. Output mit K13-konformer Scan-Kette (Koeder glpat-+20 rc=1, Datei rc=0, 31 Prosa-Vorkommen als Nenner belegt).
STATUS LT. QUELLE: behoben@5d67207b
ABHAENGIGKEIT/FLAECHE: Pausen-Sorgfalt P3/P4.

### [luecken_dump] 23
GEGENSTAND: Bau1/Fix offener Punkt: UMBRELLA-PIPELINE-GRUEN nicht verifiziert (kein glab im PATH, kein API-Token, anonymer Zugriff 404); Push selbst bestaetigt (HEAD==origin/development); inzwischen Remote-HEAD b7ffecb (v4.2), spaeter 6d7fc83 (v4.3); Umbrella-CI ohnehin strukturell rot (Owner-Frage C2).
ORT: Umbrella comdare/projekte, Commits 2142439/b7ffecb/6d7fc83.
SOLL/FIX: Pipeline-Status verifizieren sobald glab/API-Zugang (Push->gruen-Doktrin); strukturell haengt es an Owner-Frage C2.
STATUS LT. QUELLE: offen (vertagt)
ABHAENGIGKEIT/FLAECHE: Finding 34; Owner-Frage C2.

### [luecken_dump] 24
GEGENSTAND: Bau1-Anomalie scripts/minio_blind_smoke_v2.sh: 261-Byte-Fragment unbekannter Herkunft, erstellt waehrend des Laufs, nie in git -- in Bau2 ENTLASTET: Duplikat-Fragment des WIP (5 Zeilen, bricht im Kopf ab); Werkzeug vollstaendig versioniert als scripts/minio_blind_smoke.sh (8f4b4f1a, 92 Z., Herkunft im Kopf); Stub bleibt nur im Sicherungs-Branch.
ORT: super scripts/; wip/luecken-stufe2-pause-1308.
SOLL/FIX: Keine (aufgeklaert).
STATUS LT. QUELLE: behoben (entlastet)
ABHAENGIGKEIT/FLAECHE: Pausen-Sorgfalt P3.

### [luecken_dump] 25
GEGENSTAND: Bau1-Beobachtung: KONKURRIERENDER super-Schreiber waehrend des Laufs (Wellen-Landung committete 6c4cc130 + 01e091f6 auf development) -- disjunkte Dateien, linear, kein Konflikt; jeder eigene Commit einzeln geprueft (kein Fremd-File eingeschleppt).
ORT: super development.
SOLL/FIX: Kein Schaden; gemeldet (Ein-Schreiber-Regel-Randfall).
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Pausen-Sorgfalt P2.

### [luecken_dump] 26
GEGENSTAND: Bau2-Quittungsbestand: WIP-Haertung anker_wache + tests_registrierung_wache uebernommen+geprueft (76a345e3), 8. Backup (5d67207b), minio pipefail-Mindesthaertung + host_klassen_bericht Stufen-Form (eacd3182), NE-19b vor_push_alle_wachen.sh super-Spiegel INVENTAR-MODUS M=26, 13 gefahren/13 begruendet ausgeschlossen (58b5aff4 + Fix 1e31cd4b --bereich statt Bare-Range), NE-20 ergebnis:holen DEKLARIERTE AUSNAHME + KETTEN-RISS OK-Zeilen beider Mess-Jobs an realen Anhang-Lauf gebunden (83e06159).
ORT: super development lokal (6 Commits).
SOLL/FIX: P1/P3-Deckung; NE-19a-Nenner: 38 ausfuehrbare *.sh, 3 von 38 mit pipefail, 34 dash (Stufen-Form), 1 bash gefixt.
STATUS LT. QUELLE: behoben (6 von 6 Commits)
ABHAENGIGKEIT/FLAECHE: Pausen-Sorgfalt P1/P3; Merge-Flaechen 3/6.

### [luecken_dump] 27
GEGENSTAND: Bau2 offener Punkt: ci/tests/-Probes (14 von 38 Dateien, alle dash, ohne pipefail) als Bissproben je eigener CI-Job klassifiziert; Urteils-Pipe-Einzelhaertung in Stufen-Form = EIGENES Paket (~360 KB Skripttext); dazu scripts/ci_xml_wellformed_guard.sh Zaehl-Pipes mit '|| true' nicht auf Stufen-Form umgebaut.
ORT: super ci/tests/ (14 Dateien); scripts/ci_xml_wellformed_guard.sh.
SOLL/FIX: Eigenes Paket, gleiche Hausform wie 76a345e3; xml_wellformed_guard bei der Probes-Kampagne mitnehmen; W-Platz nach der Welle.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Finding 29.

### [luecken_dump] 28
GEGENSTAND: Bau2 offener Punkt ce-Seite nach Ende der Schreibsperre: (a) NE-19a-Kampagne (Lens-B 34 von 36), (b) vor_push_alle_wachen.sh ce-Fassung auf INVENTAR-Modus heben (super-Fassung 58b5aff4 als Vorlage; ce-Vorlage in 4 verify-Klonen identisch md5 d49fbcea), (c) NE-20-Triage arm64-smoke :257 + is_original:relock :919 je Stelle (DEKLARIERTE-AUSNAHME-Kommentar in 83e06159-Form oder entfernen).
ORT: ce scripts/ + .gitlab-ci.yml.
SOLL/FIX: Wie (a)-(c); Empfehlungen je Quittung im Dump.
STATUS LT. QUELLE: offen (vertagt wegen ce-Schreibsperre)
ABHAENGIGKEIT/FLAECHE: Finding 26; Merge-Flaeche 3 (Inventar-Nenner).

### [luecken_dump] 29
GEGENSTAND: Bau2 offener Punkt Ledger: KON59 traegt den NE-20-Triage-Platzhalter aus Stufe 1 -- kann vom Lead mit 83e06159 geschlossen werden (Stufe 2 hatte keinen Ledger-Auftrag).
ORT: Ledger KON59.
SOLL/FIX: Platzhalter mit 83e06159 schliessen; Anker-Drift (Finding 30) mitfuehren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Findings 11/30; Merge-Flaeche 6.

### [luecken_dump] 30
GEGENSTAND: Bau2-Rahmen: alle 6 Commits LOKAL auf development (a103e518..83e06159), NICHT gepusht; wip/luecken-stufe2-pause-1308 unangetastet als Sicherung; ce nie beschrieben; Lauf-Logs der Belege unter /tmp fluechtig (vpw_final.log u.a. -- bei Bedarf vom Lead sichern).
ORT: super development lokal; /tmp.
SOLL/FIX: Sammel-Push mit der Landung; /tmp-Belege bei Bedarf sichern.
STATUS LT. QUELLE: offen (Push steht aus)
ABHAENGIGKEIT/FLAECHE: Merge-Flaeche 6.

### [luecken_dump] 31
GEGENSTAND: Verify-Fund 1: b2-Quittung unvollstaendig uebermittelt (JSON bricht in Posten 2 ab); fuer 5 der 6 Stufe-2-Commits lag KEINE Quittung vor; am Objekt tragen alle 5.
ORT: luecken_dump verify.funde.
SOLL/FIX: ENTLASTET am Objekt (Meta-Gate gruen ueber origin/development...HEAD); Text-Gegenlese der Quittungen als offener Punkt an den NAECHSTEN Verify (volle b2-Liste: 5d67207b, eacd3182, 58b5aff4, 1e31cd4b, 83e06159 + 76a345e3).
STATUS LT. QUELLE: teilweise (Objekt entlastet, Text-Gegenlese offen)
ABHAENGIGKEIT/FLAECHE: Pausen-Sorgfalt P1/P4 (Quittungs-Luecken-Klasse).

### [luecken_dump] 32
GEGENSTAND: Verify-Fund 2: NE-11b-Quittung 'bash+sh -n ok' als Pauschalaussage falsch -- sh -n (dash) reisst auf minio_blind_smoke.sh rc=2 (Array-Syntax Z.51); Objekt selbst ok (Shebang bash).
ORT: super scripts/minio_blind_smoke.sh.
SOLL/FIX: Behoben f3017a77: Kopf dokumentiert Syntax-Gate 'bash -n' ausdruecklich.
STATUS LT. QUELLE: behoben@f3017a77
ABHAENGIGKEIT/FLAECHE: -.

### [luecken_dump] 33
GEGENSTAND: Verify-Fund 3: Kommentar '/usr/bin/grep ist hier ugrep' in ci/anker_wache.sh:103 und ci/tests_registrierung_wache.sh:117 faktisch falsch (GNU grep 3.11; ugrep = interaktive FUNKTION).
ORT: super ci/anker_wache.sh:103; ci/tests_registrierung_wache.sh:117.
SOLL/FIX: Behoben e96b67e8 (Kommentar berichtigt; Mittel -F/K13 unveraendert korrekt; Gegenproben gruen).
STATUS LT. QUELLE: behoben@e96b67e8
ABHAENGIGKEIT/FLAECHE: -.

### [luecken_dump] 34
GEGENSTAND: Verify-Fund 4: NE-26-Entlastungs-Zitat unpraezise (KON39-Marker real Z.2019 bzw. 2035, nicht zitierte Z.2031); Substanz stimmt (Marker vorhanden, Nachzug unnoetig).
ORT: Wellenplan Par.16.4.
SOLL/FIX: Entlastet; Fehler nur in Zeilenzahl des Verify-Belegs.
STATUS LT. QUELLE: behoben (entlastet)
ABHAENGIGKEIT/FLAECHE: -.

### [luecken_dump] 35
GEGENSTAND: Verify-Fund 5: NE-27 'Eigene +Zeilen ASCII' gilt 27 von 28 (1 ererbter Mittelpunkt-Trenner U+00B7 in der Stand/Fassung-Kopfzeile; Format-konsistent zum Parent, im Umbrella ausserhalb des super-Mandats).
ORT: Umbrella-Commit 2142439.
SOLL/FIX: Entlastet, kein neuer Streuzeichen-Verstoss.
STATUS LT. QUELLE: behoben (entlastet)
ABHAENGIGKEIT/FLAECHE: -.

### [luecken_dump] 36
GEGENSTAND: Verify-Fund 6: KON59-02-Zeilenanker gedriftet -- ce relock-manual :898 (Mess-Stand f23c18e2) -> :919 (Gitlink 5f3f26a5); super ergebnis:holen :2751 -> :2809 (nach 83e06159); ce arm64-smoke :257 unveraendert; exakt die Anker-Verjaehrungs-Klasse der anker_wache.
ORT: ce .gitlab-ci.yml:919; super .gitlab-ci.yml:2809.
SOLL/FIX: VERTAGT: Anker-Nachtrag gehoert in den NE-20-Triage-Stufe-2-Ledger-Nachtrag (KON59-02-Vormerkung); korrigierte Anker hier gemessen und belegt.
STATUS LT. QUELLE: teilweise (vertagt, Werte liegen)
ABHAENGIGKEIT/FLAECHE: Finding 30; Ledger-Nachtrag.

### [luecken_dump] 37
GEGENSTAND: Verify-Fund 7: NE-27 PIPELINE-GRUEN weiter offen (Umbrella-Push b7ffecb/v4.2 ohne Pipeline-Pruefung; glab fehlt, PAT-Zug ist Blind-Doktrin).
ORT: Umbrella comdare/projekte.
SOLL/FIX: VERTAGT: verifizieren sobald glab/API-Zugang; von der Quittung selbst als VERTAGT deklariert.
STATUS LT. QUELLE: teilweise (vertagt)
ABHAENGIGKEIT/FLAECHE: Finding 34; Owner-Frage C2.

### [luecken_dump] 38
GEGENSTAND: Fix-Abschluss Luecken-WF: neue Commits e96b67e8 + f3017a77 (damit 8 lokale super-Commits a103e518..f3017a77); offene Punkte: volle b2-Quittungsliste an naechsten Verify, NE-20-Triage Stufe 2 Anker, NE-27 Pipeline, Sammel-Push.
ORT: super development lokal.
SOLL/FIX: Wie gelistet.
STATUS LT. QUELLE: offen (Sammel-Push + Restposten)
ABHAENGIGKEIT/FLAECHE: Merge-Flaeche 6; Findings 30/34/38.

================================================================================
TEIL 8 -- EXTRAKTION verify_dump_voll.md (4 Bloecke: 1. wv83csrmh F1-Fix,
2. w2zv55j8v Reviews Zielstruktur+G1, 3. w1pm0nio7 e21-Verify, 4. wjrbqudaw Design-A2.5-Fix)
================================================================================

### [verify_dump] 1
GEGENSTAND: F1-Fix Quittung 1 [VERTAGT]: Landung des Zweigs bau/f1-1x1-honest-empty durch den Lead seriell (R4/A2.1a); development wanderte waehrend der Stufe (a103e518 stale, zuletzt 83e06159); merge-base 3ce69ed2; Merge-Probe merge-tree --write-tree rc=0 KONFLIKTFREI (tree 864959b5); 0 development-Commits beruehren Code/05_diagram_generator.
ORT: wt-f1-1x1; Branch damals 2 Commits (915038ca+c134b70a), heute 4 (@ 8e9a31d2).
SOLL/FIX: Lead merged beim Landen gegen DANN-aktuellen development und wiederholt die Merge-Probe.
STATUS LT. QUELLE: offen (Landung)
ABHAENGIGKEIT/FLAECHE: Finding 8; Drei-Stufen-Landung super.

### [verify_dump] 2
GEGENSTAND: F1-Fix Quittung 2 [BEHOBEN]: 'sh ci/anhang_forward_core.sh' stirbt unter dash (rc=2 'set: Illegal option -o pipefail') -- POSIX-reine BASH-WACHE vor dem ersten Bashismus (c134b70a); T-1 rot/gruen belegt; voller Labor-Beweislauf rc=0 ('kopiert gesamt: 64 .tex', 'PDF-Gate GRUEN', 0x 'matrix input=image'); Repo-Aufrufstellen waren schon korrekt.
ORT: super ci/anhang_forward_core.sh (Wache vor :301); Commit c134b70a.
SOLL/FIX: WF-Rezept-TEXT liegt ausserhalb des Repos -> Korrektur-Task an Lead (neuer Fund 1).
STATUS LT. QUELLE: behoben@c134b70a (Objekt); Rezept-Text offen
ABHAENGIGKEIT/FLAECHE: Finding 7.

### [verify_dump] 3
GEGENSTAND: F1-Fix Quittung 3 [ENTLASTET]: AF_SNAP_ROOT_STRICT=false ist der im Script dokumentierte Labor-Weg (:265-271, 'die CI setzt es NIE'); CI unberuehrt (AF_WORK_ROOT=$CI_PROJECT_DIR, STRICT default true); b4476fc-Rueckbau verifiziert (aus keinem Ref erreichbar).
ORT: ci/anhang_forward_core.sh:265-271/:866-871; .gitlab-ci.yml:2490.
SOLL/FIX: Keine (dokumentiertes Laborverhalten); Erwartungs-Korrektur in den WF-Rezept-Task.
STATUS LT. QUELLE: behoben (entlastet)
ABHAENGIGKEIT/FLAECHE: Finding 7.

### [verify_dump] 4
GEGENSTAND: F1-Fix Quittung 4 [VERTAGT]: Thesis-Paket lc_surface-Block auf \InputIfFileExists heben (de:64ff/en:63ff blankes \input; IIFE-Muster im selben File de:103-283, 30 Vorkommen; Warnbeispiel Branch b-gate8-graph-abbildungen).
ORT: Thesis anhang/de/A_measurements.tex:64, en:63.
SOLL/FIX: Eigenes Thesis-Paket nach F1 (Owner/Lead-Vormerkung); lc_surface_*-Block mit eigenem Ersatztext heben.
STATUS LT. QUELLE: teilweise (vertagt, vorgemerkt)
ABHAENGIGKEIT/FLAECHE: Finding 9; nach F1.

### [verify_dump] 5
GEGENSTAND: F1-Fix Quittung 5 [BEHOBEN]: Explore-Korrektur 'alle 05er-Fixtures 2x2' war falsch; 4 Ratio-Tests (2x1/3x1/1x1) auf 2x2/3x2 gehoben, Semantik unveraendert; T-1 rot (ctest rc=8, Faelle 543-545) -> Stufe05 51/51 R+D; volle Suiten 403/403.
ORT: Commit 915038ca; test_05_diagram_generator_cached_fixtures.cpp:1483/:1568/:1610-1613/:1640-1643.
SOLL/FIX: Keine weitere (Protokoll-Korrektur getragen).
STATUS LT. QUELLE: behoben@915038ca
ABHAENGIGKEIT/FLAECHE: -.

### [verify_dump] 6
GEGENSTAND: F1-Fix Quittungen 6/7/8/9 [je ENTLASTET]: (6) stale Vor-Pause-Logs additiv archiviert (/tmp/f1_bau/stale_prepause/, 16 Dateien); (7) bash statt sh war die einzig korrekte Abweichung (Shebang bash, /bin/sh=dash); (8) af rc=0 nur mit AF_SNAP_ROOT_STRICT=false bei /tmp-WORK_ROOT -- frische Messung rc=0, Thesis-Klon vollstaendig zurueckgesetzt (main@29a1700d, Labor-Commit aus keinem Ref); (9) Minimal-CSV-Header/op_lookup_p50_ns=55 der Anweisung falsch -- Objekt verlangt 9-Spalten-required[] (diagram_generator.cpp:895-897), echter Wert 1310 in allen 3 CSV-Formen.
ORT: /tmp/f1_bau/, /tmp/f1_fix_lab/; diagram_generator.cpp:895-899.
SOLL/FIX: Erwartungswerte ins WF-Rezept (Finding 7).
STATUS LT. QUELLE: behoben (entlastet, 4 von 4)
ABHAENGIGKEIT/FLAECHE: Finding 7; Pausen-Sorgfalt P2 (stale Anweisungen belegt).

### [verify_dump] 7
GEGENSTAND: F1-Fix neuer Fund 1: WF-Rezept-Korrektur an den Lead: (a) 'sh ci/anhang_forward_core.sh' -> 'bash ci/anhang_forward_core.sh'; (b) AF_SNAP_ROOT_STRICT=false als Pflicht-Env fuer Labor-Laeufe ausserhalb git-Baum; (c) Erwartungswerte auf Objekt ziehen (9-Spalten-required[], op_lookup_p50_ns=1310).
ORT: WF-Rezept-Text (ausserhalb Repo, Task #41-Text).
SOLL/FIX: In naechste Kontextuebergabe/Task #41 uebernehmen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Finding 7.

### [verify_dump] 8
GEGENSTAND: F1-Fix neue Funde 2/3/4: (2) development wanderte zweimal waehrend der Fix-Stufe; Merge blieb in jeder Messung konfliktfrei -- Lead wiederholt Merge-Probe beim Landen; (3) Zeilen-Verweis-Hygiene: einziger lebender Verweis MANUAL_RUN.md:279 nachgezogen, datierte Verweise bewusst nicht angefasst (Doku-nie-loeschen); (4) Grep-Warnung: Original-Artefakte tragen 'HONEST-EMPTY' NUR als Kommentar IN der kaputten Figur -- tragfaehiger Nenner: matrixplot=0 UND honestempty>=1 UND nie-ausgefuehrt=0 (regenerierte 4 Dateien erfuellen ihn).
ORT: MANUAL_RUN.md:279; /tmp/f1_art/.../appendix vs /tmp/f1_regen_wf/...
SOLL/FIX: Merge-Probe wiederholen (Finding 8); HONEST-EMPTY-Nenner in Pruefungen verwenden (Finding 10).
STATUS LT. QUELLE: offen (2), nur-hinweis (3/4)
ABHAENGIGKEIT/FLAECHE: Findings 8/10.

### [verify_dump] 9
GEGENSTAND: Review Zielstruktur F1 (HART): K3 unterzaehlt -- Querschnitt->CEB ist 6 Kanten aus 2 Dateien (zusaetzlich abi/cache_engine_execution_engine_adapter.hpp:14-16 relativ -> builder/commands/*), Summe verbotene Richtung 61 (59 Lib = 49+1+3+6 + 2 App), nicht 58; Par.3b(5) 'sonst 0' falsch; Methodenfehler: relative Includes in include/ uebersehen.
ORT: ce include/cache_engine/api/i_cache_engine_tools.hpp:23-25 + abi/cache_engine_execution_engine_adapter.hpp:14-16.
SOLL/FIX: Fix 1+2 (Matrix ersetzen mit Ein-Zaehlweise; K3 neu: '6 Kanten, 2 Dateien', Aufloesung #88 beide Koepfe entkoppeln).
STATUS LT. QUELLE: behoben (eingearbeitet lt. wjrbqudaw Q1)
ABHAENGIGKEIT/FLAECHE: Finding 19 (#67-Drittzaehlung); #88.

### [verify_dump] 10
GEGENSTAND: Review Zielstruktur F2 (HART): Matrix-Zeile tier falsch -- tier->Fach = 4 und tier->Querschnitt = 1 (perm_runner.hpp:26-30), nicht 0/0; stufen-neutral erlaubt, Nullen am Objekt widerlegt.
ORT: ce harness/perm_runner.hpp:26-30.
SOLL/FIX: Fix 3 (Tier-Korrektur + Messmethoden-Klammer 'Kommentar-Erwaehnungen zaehlen nicht').
STATUS LT. QUELLE: behoben (eingearbeitet lt. wjrbqudaw Q2)
ABHAENGIGKEIT/FLAECHE: Finding 19.

### [verify_dump] 11
GEGENSTAND: Review Zielstruktur F3 (HART): Querschnitt->Fach = 20, nicht 0 (anatomy 13, topics 4, axes 3; Schwerpunkt abi/) -- die ABI-Deklaration zieht Flaeche-1-Vertraege aus anatomy; der Querschnitt lehnt am Fach; das Design verschwieg diese Abhaengigkeit.
ORT: ce abi/anatomy_module_abi_v1_decl.hpp:17-20 u.a.
SOLL/FIX: Fix 2-Anteil: Par.3b(5) ersetzt (Folgerung fuer Par.1 bleibt; wer Querschnitt konsumiert, bekommt anatomy transitiv mit; bei #88 entscheiden: Vertraege heben oder Kante deklarieren).
STATUS LT. QUELLE: behoben (eingearbeitet lt. wjrbqudaw Q3)
ABHAENGIGKEIT/FLAECHE: #88.

### [verify_dump] 12
GEGENSTAND: Review Zielstruktur F4 (MITTEL): CEB->Fach = 147, nicht 134 (anatomy 85 = 74 direkt + 11 relativ, topics 48, axes 12, compositions 1, src 1); planer->Querschnitt 56 echte (58 enthielt 2 Kommentar-Treffer), planer->Fach 25; Methodenfehler doppelt (Kommentar-Treffer, relative Kanten).
ORT: ce libs (Datei-Liste im Dump).
SOLL/FIX: Fix 1 (Ein-Zaehlweise, Folge-Angleichungen Par.1 74->85, R8 134->147).
STATUS LT. QUELLE: behoben (eingearbeitet lt. wjrbqudaw Q4)
ABHAENGIGKEIT/FLAECHE: Finding 19.

### [verify_dump] 13
GEGENSTAND: Review Zielstruktur F5 (HART): Par.4.2 'NUR NEUE Dateien' UNBAUBAR -- es gibt KEIN libs/CMakeLists.txt; libs/* haengt direkt an Repo-Wurzel-CMakeLists.txt (Z.737-753); libs/traeger/ braucht dort GENAU EINE Anschluss-Zeile = Aenderung einer bestehenden, stark frequentierten Datei (Ein-Schreiber-Konfliktflaeche); KON59-02-Timing-Auflage fehlte.
ORT: ce CMakeLists.txt (Wurzel) Z.737-753.
SOLL/FIX: Fix 4: '1 Commit: NEUE Dateien libs/traeger/** PLUS GENAU EINE Anschluss-Zeile add_subdirectory(libs/traeger)'; Ein-Schreiber-Check vor Commit; Timing: ce-Schreibsperre aufgehoben, dann WE-15./16.-Fenster.
STATUS LT. QUELLE: behoben (eingearbeitet lt. wjrbqudaw Q5)
ABHAENGIGKEIT/FLAECHE: Finding 20; Owner-Frage B3; WE 15./16.

### [verify_dump] 14
GEGENSTAND: Review Zielstruktur F6 (MITTEL): Bruecken-Whitelist kollidiert mit A2.2 -- vier Naht-Familien decken nur 41 der 49 K1-Kanten; ungedeckt u.a. codegen 2 (adhoc_emitter+type_name, die S-8s 2-Pass braucht), driver_build_variant_signature 2, je 1 workload_driver/lager_ablage/ceb_version_stamp/artifact_transport.
ORT: design_zielstruktur Par.4.3.
SOLL/FIX: Fix 5: Whitelist = K1-Vollmenge (10 Familien: 26/8/6/2/2/1x5); Bruecke ausserhalb der Liste erlaubt bei Besitzkarten-Nachtrag im selben Commit (lauter Zugang statt Verbot).
STATUS LT. QUELLE: behoben (eingearbeitet lt. wjrbqudaw Q6)
ABHAENGIGKEIT/FLAECHE: S-8; A2.2-Doktrin.

### [verify_dump] 15
GEGENSTAND: Review Zielstruktur F7 (KLEIN, Praezision+Anker): (a) Mini-Pipeline-Anker ist KON10-02 (nicht KON25-04/-08 allein); (b) TEIL2-Zitatort experiment_dock_payload.hpp:24; (c) Monolith 18 Unterverzeichnisse, 16 mit C++; (d) builder 35 Unterverz. = 22 C++ + 13 leere Skelette (#88-Triage); (e) R5 unvollstaendig: DRITTE Include-Wurzel libs/cache_engine/src macht <measurement/...> u.a. mehrdeutig (<concepts> kollidiert mit C++-Std-Header); (f) Apps-Zaehlung inkonsequent (5 ->builder-Kanten der 3 Werkzeug-Apps nicht gezaehlt -- Zaehlentscheid deklarieren).
ORT: design_zielstruktur Par.1/2/3.
SOLL/FIX: Fix 6 (Anker+R5 nachschaerfen; planer->src 2 als Mini-Familie; 'traeger/ erbt KEINE Alt-Wurzel').
STATUS LT. QUELLE: behoben (eingearbeitet lt. wjrbqudaw Q7)
ABHAENGIGKEIT/FLAECHE: #88; Finding 19.

### [verify_dump] 16
GEGENSTAND: Review Zielstruktur GEGENPROBEN GRUEN (Kernaussagen halten): 1.292 D./157.192 Z. exakt; K1=49 mit Familien-/Datei-Dichte; ceb->planer 0; tier->ceb 10; ceb->tier 3; K2-Zyklus 48/58/40; Fach->Traeger 0; hybrid/heuristik-Inseln; apps 9 (KON47-01 '10' als Abweichung deklariert); tests/unit 500 + 3 Skelette; #67 '142/29' = 0 Ledger-Belegstellen; Wellenplan-Anker exakt.
ORT: verify_dump Review-Zielstruktur Fund 8.
SOLL/FIX: Keine (Verdikt-Kontext, in Par.7 des Designs zusammengefasst).
STATUS LT. QUELLE: behoben (bestaetigt)
ABHAENGIGKEIT/FLAECHE: -.

### [verify_dump] 17
GEGENSTAND: Zielstruktur Designer-offene-Punkte 1-4: (1) Wurzel+Namen der 4 Unter-Projekte (Default libs/traeger/{planer,ceb,tier,hybrid}, Ziele comdare_planer/_ceb/_tier_emission/_hybrid; Kollision planner(EN) vs planer(DE) VOR erstem Umzug entscheiden); (2) heuristik/ (6 D./1.961 Z.) Default HYBRID -- Planer-Mitnutzung Break-Even-Karte spaetestens bei HY-A bestaetigen; (3) mess/-Schnitt Default Kaskade->TIER, Naht-Typen -> Querschnitt (loest K2, 3 Kanten; Zeitpunkt #18/S-13 oder W7/#88); (4) Stufen-Kante Default adjazent-only, transitives Durchgreifen entscheidet erster Bedarfsfall LAUT (heute 0 gemessen).
ORT: design_zielstruktur offene Punkte.
SOLL/FIX: Owner-Frage B3 deckt die Defaults; Namens-Kollision separat entscheiden.
STATUS LT. QUELLE: offen (Owner)
ABHAENGIGKEIT/FLAECHE: Owner-Frage B3; Finding 19 (Par.6.4-Nachpruefung).

### [verify_dump] 18
GEGENSTAND: Zielstruktur Designer-offene-Punkte 5-8: (5) experiment_tree-Besitz (26 der 49 K1-Kanten) Default plan-seitige Single-Source-Header -> Planer/Querschnitt bei #88; (6) Lager-Substanz (bestandslog 23 D./7.203 Z. + lager_ablage 2 D./929 Z.) Querschnitt-Kandidat vs CEB-Eigentum -- bei S-17 festzurren; (7) Timing-Lesart: Skeleton-Commit WE 15./16. VOR erstem S-8-Commit (Inhalts-Regel bindet, Owner-Einspruch moeglich); (8) apps-Ebene traegt exakt 9 add_executable (KON47-01 nannte '10') -- bei naechster Ledger-Fortschreibung korrigieren oder 10. Binary benennen.
ORT: design_zielstruktur offene Punkte.
SOLL/FIX: Wie je Punkt; (8) in den Ledger-Nachtrag.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: #88; S-17; Ledger-Nachtrag (Finding 11).

### [verify_dump] 19
GEGENSTAND: Review G1 Funde 1-3 (VERIFIZIERT/NACHGERECHNET): alle G-2-Fundstellen stimmen (algo_semver.hpp 1633 Z./317 static_assert, Kataloge, Wachen); Kollisions-Erhebung 0 von 8 Token im 62er-Katalog reproduziert (Positiv-Gegenprobe bw beisst; Falsch-Null-Warnung: erst das Eintrags-Format {"tok", ...} liefert Zahlen); alle 5 Beispiele nachgerechnet, Kern-These M-1 ('der bestehende Parser parst jede G-1-Form heute schon') am Objekt WAHR.
ORT: ce algo_semver.hpp, flag_grammar_catalog.hpp:176ff, flag_menge_ordnung.hpp, anatomy_version_stamp.hpp, measurement_tooling_registry.hpp:47-49, plan_legend.hpp:74-84.
SOLL/FIX: Keine (Bestaetigungen).
STATUS LT. QUELLE: behoben (bestaetigt)
ABHAENGIGKEIT/FLAECHE: Owner-Frage B2.

### [verify_dump] 20
GEGENSTAND: Review G1 HAUPTFUND (Fund 4): M-8-Projektion verliert Owner-Semantik -- Owner-Satz 'CEB gibt wallclock build auf der naechsten Traeger-Stufe frei' (Ledger :2148) war im Design-Par.0-Zitat durch [...] AUSGELASSEN; Tier-KOMPILAT ist w-abhaengig, M-8-Projektions-Stempel w-blind: m{b{w}.t{ma.mi}} und m{b.t{ma.mi}} projizieren BEIDE auf 1.0.0.c.m{t{ma.mi}} -- zwei Kompilate, EIN Stempel = verbotene Alias-Identitaets-Klasse (KON34-05 :3229, B11 algo_semver.hpp:533-537); Design in sich inkonsistent (B-3 argumentiert selbst mit Kind-Wirkung).
ORT: design_g1 M-8/B-1; Ledger :2148-2154/:2169-2173.
SOLL/FIX: FIX 1: Owner-Wort in Par.0 sichtbar machen; Projektions-Regel so fassen, dass die CEB-w-Entscheidung im KIND-Stempel ankommt; drei ehrliche Optionen als neuer Owner-Entscheid F-G1-11 (i/ii/iii) ohne Default; B-1 Phase-3-Zeile korrigieren.
STATUS LT. QUELLE: behoben (eingearbeitet lt. wjrbqudaw Q8); Owner-Entscheid offen
ABHAENGIGKEIT/FLAECHE: Owner-Frage B1 (F-G1-11); Finding 18.

### [verify_dump] 21
GEGENSTAND: Review G1 Ambiguitaet (a) (Fund 5): 1.0.0.c.m{t{ma.mi}} ist ZUGLEICH gueltiger CEB-Voll-Vertragsausdruck (M-4, Ein-Slot) UND Tier-Projektions-Stempel JEDES Vertrags mit t{ma.mi} -- Anordnung und Fremd-Slots gehen per M-8 restlos verloren, obwohl M-6/KON37-03 sie zur Identitaets-Information erklaeren; mit dem w-Fund echte Lager-Identitaets-Kollision.
ORT: design_g1 M-8; Ledger :2211-2213.
SOLL/FIX: FIX 3: Nicht-Injektivitaet als Eigenschaft ausschreiben (Rolle/Herkunft liegen am TRAEGER, nicht im Wert); an F-G1-10 anschliessen (Kind-Anordnung; haengt an F-G1-11).
STATUS LT. QUELLE: behoben (eingearbeitet lt. wjrbqudaw Q10); Owner-Entscheid offen
ABHAENGIGKEIT/FLAECHE: Owner-Frage B1; F-G1-10.

### [verify_dump] 22
GEGENSTAND: Review G1 Ambiguitaet (b) (Fund 6): Sprachumfang der Mess-Zeile unterspezifiziert -- EBNF Par.3.1 erlaubt zwischen c[cpu_sub] und m NICHTS; Stufe C lesbar als 'beliebige katalog-gedeckte Hardware-Flags vor m zulaessig'; B-5 prueft nie die Spiegel-Richtung (x512{f} auf MESS-Zeile).
ORT: design_g1 Par.3.1 vs Stufe C.
SOLL/FIX: FIX 2: EBNF gilt (NUR c[{p|e|p.e}] vor genau einem m); B-5 um Spiegel-Negativ-Probe '1.0.0.c.x512{f}.m{...} ROT AUCH AUF DER MESS-ZEILE' ergaenzen.
STATUS LT. QUELLE: behoben (eingearbeitet lt. wjrbqudaw Q9)
ABHAENGIGKEIT/FLAECHE: Owner-Frage B2.

### [verify_dump] 23
GEGENSTAND: Review G1 Ambiguitaet (c) (Fund 7): c{p.p}/c{e.e} von der G-1-EBNF ableitbar, von keiner M-Regel und keiner Bestands-Wache verboten (v2 kennt kein Geschwister-Duplikat-Verbot; algo_semver :1571 nennt Redundanz 'andere Fehlerklasse') -- heute form- UND katalog-gruen.
ORT: design_g1 cpu_sub-Produktion; ce algo_semver.hpp:934-941/:1571.
SOLL/FIX: FIX 4: neue Regel M-11 'CPU_SUB OHNE DUPLIKATE' (durchgesetzt in mess_version_is_wellformed, mess-zeilen-lokal; auf System-/Organ-Zeilen ausgewiesenes G-2-Erbe -> #17); B-5-Beispiel '1.0.0.c{p.p}.m{b{w}} ROT (M-11)'.
STATUS LT. QUELLE: behoben (eingearbeitet lt. wjrbqudaw Q11)
ABHAENGIGKEIT/FLAECHE: #17 (G-2-Semantik-Nachzug).

### [verify_dump] 24
GEGENSTAND: Review G1 Fund 8 (VERIFIZIERT): alle Owner-Zitate verbatim korrekt an den angegebenen Ledger-Zeilen (KON13-02/-03, KON16-02, KON37-01/-02/-03/-05, KON25-03, KON9-06/-09, KON34-05, Konsolidierung IV, Wellenplan Par.15.2); Nichtfund G-1-Bestand plausibel (ce_owned_version_is_wellformed :1042 lehnt katalogfremdes m heute ueberall ab).
ORT: Ledger (Zeilen im Dump).
SOLL/FIX: Keine.
STATUS LT. QUELLE: behoben (bestaetigt)
ABHAENGIGKEIT/FLAECHE: -.

### [verify_dump] 25
GEGENSTAND: Review G1 Kleinfunde (Fund 9): (1) 'Knotenzahl maximal 13' zaehlt nur m-Baum (volle Zeile bis 16, Deckel 96 haelt); (2) Geisterverweis 'Par.6.2' in B-5; (3) Par.3.3 verschweigt konkrete Naht: Registry-B12-Batterie (tooling_versionen_wohlgeformt, measurement_tooling_registry.hpp:58-62) ruft heute ce_owned_version_is_wellformed und wuerde jeden m-Schwanz ABLEHNEN -- Umstellung auf mess_version_is_wellformed noetig; (4) offen welche <id> der measurement_tooling-Eintrag bei Mehr-Stufen-Mischung traegt (heute GENAU EINE, anatomy_version_stamp.hpp:256-259).
ORT: design_g1 Par.3.1/3.3, Stufe C/F; ce measurement_tooling_registry.hpp:58-62.
SOLL/FIX: FIX 5 (a-d): Verweis berichtigen; 13/16 praezisieren; Wachen-Umstellung dreifach benennen; (d) als neuer Owner-Entscheid F-G1-12 (Tooling-id).
STATUS LT. QUELLE: behoben (eingearbeitet lt. wjrbqudaw Q12); F-G1-12 offen
ABHAENGIGKEIT/FLAECHE: Owner-Frage B2; Finding 18.

### [verify_dump] 26
GEGENSTAND: Review G1 Fund 10 (WAS TRAEGT, ohne Befund): Profil-These M-1 am Objekt bewiesen; Vokabular kollisionsfrei (0/8); M-6 = Nicht-Normalisierungs-Doktrin; M-9-Exaktheit owner-gedeckt (KON9-09+KON34-05); M-5 woertlich Ledger :2216-2217; Grenzen Par.7 sauber (S-6-Sperre, S-19-Vorbehalt); die 10 Owner-Fragen sind echte offene Punkte.
ORT: design_g1.
SOLL/FIX: Keine.
STATUS LT. QUELLE: behoben (bestaetigt)
ABHAENGIGKEIT/FLAECHE: Owner-Frage B2.

### [verify_dump] 27
GEGENSTAND: G1 Designer-offene-Punkte = die F-G1-Fragen (verbatim-kurz): F-G1-1 Profil-Entscheid (G-1 als Profil der v2, EIN Parser); F-G1-2 Vokabular m / b h t / w ma mi (0 von 8 Kollisionen) oder laengere Token; F-G1-3 KEIN Planer-Slot (Planer traegt 0 der 5 Nenner-Schalter; spaeterer Planer-Messfuehler = additives viertes Stufen-Token); F-G1-4 Vererbung = Projektions-GLEICHHEIT, nicht Teilmenge; F-G1-5 Exaktheit als Gueltigkeits-Relation fuer Mess (kein Teilmengen-Lager-Skip; Gegensatz zur G-2-Erweiterungs-Teilmenge); F-G1-6 leere Slots zulaessig, leeres m verboten; F-G1-7 CPU-Pflicht der Mess-Zeile (.c bleibt vor .m ODER m ersetzt c mit Ausnahme-Mechanik in beiden B12-Wachen); F-G1-8 PMC ausserhalb des m-Flags belassen oder viertes Instrument-Token unter b; F-G1-9 Lastsequenz im load_framework-Meta-Meta-Segment belassen; F-G1-10 Anordnungs-Deklaration (String + Mess-Home-Tabelle pinnt freigegebene Anordnungen, oder rein tabellarisch).
ORT: design_g1 offene Punkte 1-10.
SOLL/FIX: Je Owner-Antwort in einem Satz (Owner-Frage B2-Klammer).
STATUS LT. QUELLE: offen (Owner)
ABHAENGIGKEIT/FLAECHE: Owner-Fragen B1/B2; Finding 18.

### [verify_dump] 28
GEGENSTAND: G1 Designer-Abhaengigkeiten 11-15: (11) Position der Mess-Zeile im Stempel-Gefuege gehoert dem S-6-Fenster (an S-6 wird nichts gebaut) -- G-1 definiert nur den WERT; (12) Registry-Neubau KON37-02 (Stufen-Dimension tier/hybrid/ceb, Belegung <= 32, altes archivieren) = Tabellen-Seite; Bau-Reihenfolge gegen B1-B5 beim Zuschnitt festlegen; (13) G-2-Semantik-Nachzug (#17) separat; G-1 nutzt nur gelandete S-3-Relation; (14) Nenner-Umfang je Lauf rechnet ausschliesslich die Planer-Simulation S-19; (15) kein Bau erfolgt (READ-ONLY), Lead persistiert nach docs/plaene/20260813-DESIGN-g1-grammatik-dreiphasige-messachse.md, Bau nach Owner-GO unter KON38 (Fable 5 max).
ORT: design_g1 offene Punkte 11-15.
SOLL/FIX: Publikation (Finding 17); Bau-Reihenfolge beim Zuschnitt.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Findings 17/18; S-6-Sperre; S-19.

### [verify_dump] 29
GEGENSTAND: e21-Verify URTEIL: QUITTUNG BESTAETIGT, EIN KLEINFUND DIREKT BEHOBEN -- alle 3 Commits existieren (f1b05256 Vorlage 286 Z., bd02e7ab +28 Z. additiv, fe7bb459 = Verify-Fix), Worktree wt-super-e21 sauber auf bau/e21-vollzug-a1 (Basis a103e518, ahead 3, kein Push, Ledger unberuehrt); A-1-Kette am Rohtranskript REAL (GO deckte die Loeschung; Vollscan 776->0; 'GitHub war nie betroffen' an 36039); E-1..E-4-Vollzuege real am Ledger und am ce-Objekt 5f3f26a5.
ORT: /home/comdare/wt-super-e21, Branch bau/e21-vollzug-a1 @ fe7bb459.
SOLL/FIX: Landung des Branches (Drei-Stufen-Landung super); Ledger-Nachtrag aus ledger_vorschlag (Finding 11).
STATUS LT. QUELLE: behoben (bestaetigt); Landung offen
ABHAENGIGKEIT/FLAECHE: Merge-Flaeche 6; Findings 11-16.

### [verify_dump] 30
GEGENSTAND: e21-Verify Quittungen 1-3+5 (BESTAETIGT): Worktree-Anlage + 2 Commits ohne Push (Q1); Vorlage-Form vollstaendig 10 Pflichtfelder Teil I+II, ASCII 0 Treffer im Nachtrag (Q2); historische A-1-Kette am Rohtranskript (L35872 Vorlage 12:20:53Z mit 'Empfehlung: loeschen, danach Vollscan als Beleg 776', L35912 Owner-GO 12:40:23Z, Loeschung L35924/35925 'Backup-Refs auf origin: 0', korrigierter Vollscan L36022-36039) (Q3); Ref-Bestand + Bundles exakt (5 Refs mit SHAs, pre-secret-scrub-20260802 nicht vorhanden, prescrub-bundles 4 + SHA256SUMS vom 25.07.) (Q5).
ORT: docs/plaene/20260813-OWNER-VORLAGE-a1-backup-ref-aktionen.md; Rohtranskript 5a19728e.
SOLL/FIX: Keine.
STATUS LT. QUELLE: behoben (bestaetigt, 4 von 4)
ABHAENGIGKEIT/FLAECHE: Owner-Frage D1.

### [verify_dump] 31
GEGENSTAND: e21-Verify Quittung 4 (BEHOBEN): Zitat-Anker 'github ist sauber' Z.~35934 war falsch -- Zitat stammt aus Anlage-Aera 02.08. (Z.~4845); im Loeschfenster 35913-35994 faellt 'github' nicht; Sachaussage wahr (gedeckt durch ~36039).
ORT: Commit fe7bb459 (nur Feld 1 angepasst, ASCII-only).
SOLL/FIX: Keine weitere.
STATUS LT. QUELLE: behoben@fe7bb459
ABHAENGIGKEIT/FLAECHE: -.

### [verify_dump] 32
GEGENSTAND: e21-Verify Quittungen 6-10 (BESTAETIGT): E-1 OV-4 Mess-Deckel = SCHON_ERLEDIGT (KON40-03/KON41-01; stale Marker KON2-36 :9050 vorhanden, korrekt als ledger_vorschlag geroutet); E-2 Merge-Stempel am Objekt vollzogen (adhoc_emitter.hpp:110, anatomy_version_stamp.hpp:392; stale Zeilen :18006 vs :18219 real); E-3 W-6 vier Klone = SCHON_ERLEDIGT (#21 komplett abschliessbar, W-6-Gate GEFALLEN); E-4a KON-12 T-5 = SOLL erledigt (KON37-06 verbatim); E-4b KON-20/OD-7 + E-4c KON-57/E-26 gedeckt -- juengste Fundstelle :9370 nennt den Test-Schicht-Widerspruch weiterhin offen => Owner-Vorlage-Zeile sachlich gedeckt; KON22-02 :4419 belegt die Fehl-Rekonstruktions-These ('das A-1-GO deckte den Vollscan-Beleg, nicht den Zeitpunkt. Keine Loeschung vor der Lieferphase').
ORT: Ledger (Zeilen im Dump); ce 5f3f26a5.
SOLL/FIX: E-2-stale-Zeilen Marker (Owner-Frage D2); E-4c als Owner-Frage D3.
STATUS LT. QUELLE: behoben (bestaetigt, 5 von 5)
ABHAENGIGKEIT/FLAECHE: Owner-Fragen D2/D3; Findings 12/13.

### [verify_dump] 33
GEGENSTAND: e21-Verify neuer Fund 1 (INFO an Lead, Haupt-Baum tabu): der ce-Modules-Store des HAUPT-super-Baums (/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/.git/modules/Code/external/comdare-cache-engine) ist STALE -- origin/development=f23c18e2, Objekt 5f3f26a5 FEHLT dort, waehrend der super-Gitlink 5f3f26a5 pinnt; wer im Haupt-Baum submodule update ohne Fetch faehrt, laeuft auf fehlenden Commit. wt-super-landung-Store ist aktuell.
ORT: /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/.git/modules/...
SOLL/FIX: Lead: Haupt-Baum-Store fetchen (nicht vom Verify behebbar).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: nach Gitlink-Bump erneut relevant (PZW/4-Klone-Sync-Regel).

### [verify_dump] 34
GEGENSTAND: e21-Verify neuer Fund 2 (KLEIN): docs/plaene/20260813-OWNER-VORLAGE-minio-keys-und-backup-ref.md traegt in den BESTANDs-Zeilen 1-56 non-ASCII (Em-Dashes, Mittelpunkte); Nachtrag selbst ASCII-sauber; fremden Bestand nicht angefasst.
ORT: super docs/plaene/20260813-OWNER-VORLAGE-minio-keys-und-backup-ref.md Z.1-56.
SOLL/FIX: Lead-Entscheid ob normalisieren (Empfehlung lt. Sammelliste 16: NEIN, Bestand ist Bestand; nur neue Zeilen ASCII).
STATUS LT. QUELLE: offen (Lead-Entscheid)
ABHAENGIGKEIT/FLAECHE: Finding 16.

### [verify_dump] 35
GEGENSTAND: wjrbqudaw Design-A2.5-Fix Quittungsbestand: 14 Quittungen -- Q1-Q7 = Zielstruktur F1-F7 EINGEARBEITET (Matrix mit Ein-Zaehlweise, K3 6/2, Querschnitt->Fach 20, CEB->Fach 147, Par.4.2 Anschluss-Zeile + Timing, Whitelist K1-Vollmenge, Anker/R5); Q8-Q12 = G1 Fixes 1-5 EINGEARBEITET (Satz-1 sichtbar + F-G1-11, EBNF abschliessend + Spiegel-Probe, Nicht-Injektivitaet + F-G1-10, M-11, Kleinfunde + F-G1-12); Q13 ENTLASTET (Bestaetigungs-Funde, als Verdikt-Kontext in Par.7 bzw. Par.10); Q14 EINGEARBEITET (Abschnitt 'REVIEW-EINARBEITUNG (A2.5, 13.08.2026)' am Ende beider Dokumente, Zaehlweisen mitgefuehrt).
ORT: design_zielstruktur.md (neuer Par.7) + design_g1.md (neuer Par.10), beide final im JOB_DIR tmp/.
SOLL/FIX: Keine weiteren Dokument-Eingriffe; Publikation als docs/plaene/20260813-DESIGN-*.md steht aus.
STATUS LT. QUELLE: behoben (14 von 14 quittiert)
ABHAENGIGKEIT/FLAECHE: Finding 17 (Publikation in dieser Welle).

### [verify_dump] 36
GEGENSTAND: wjrbqudaw Restfragen 1-5: (1) F-G1-11 + F-G1-12 sind NEUE Owner-Entscheide; F-G1-4/-10 und Stufe-D-Pin-Form haengen an F-G1-11; (2) feingranulare Matrix-Zellwerte (topics/axes 15/4/48/12, 11-relativ-Liste, abi 11/measurement 4/Rest 5) dem Gegenleser-Review entnommen -- #67-Neuerhebung (S-6d) liefert Drittzaehlung; (3) Publikation steht aus (Zielpfade docs/plaene/20260813-DESIGN-*, erst nach Owner-GO bzw. Aufhebung der Schreibsperre); (4) Ein-Schreiber-Check an Wurzel-CMakeLists.txt zum Skeleton-Commit-Zeitpunkt DURCHZUFUEHREN; (5) Par.6.4 'heute 0 transitive Kanten 4->2' vom Review nicht beanstandet, von Neumessung nicht beruehrt -- bei #67-Neuerhebung mitpruefen.
ORT: verify_dump wjrbqudaw-Restfragen.
SOLL/FIX: Wie je Punkt.
STATUS LT. QUELLE: offen (5 von 5)
ABHAENGIGKEIT/FLAECHE: Findings 17/18/19/20; Owner-Fragen B1/B3.

================================================================================
TEIL 9 -- EXTRAKTION design_zielstruktur.md (DESIGN #29 Zielstruktur-Schnitt, 199 Z., FINAL
inkl. Review-Einarbeitung Par.7; Quellen-Stand ce @ 5f3f26a5, Ledger-Kopf KON59)
================================================================================

### [design_zielstruktur] 1
GEGENSTAND: Zielbild + Besitzkarte: vier traeger-eigene Zonen (libs/traeger/{planer,ceb,tier,hybrid}, Stufen-Regel N+1 haengt NUR an N) + zwei stufen-neutrale Zonen (Querschnitt include/cache_engine/, Fach axes/topics/anatomy/...); Aufmass Monolith 1.292 C++-Dateien / 157.192 Zeilen, Zerlegung exakt 219+209+864 D. = 1.292 (Traeger 37 Prozent / Querschnitt / Fach); Owner verbatim KON43: "erst den Planer aufbauen, dann die CEB, dann die Tier-Binaries und dann Hybrid. In der Reihenfolge und nicht anders."
ORT: design_zielstruktur.md Par.1-2; ce @ 5f3f26a5 (nur lesend vermessen).
SOLL/FIX: Nur der Schnitt-Plan; voller Monolith-Split ist W7/#88 (KON43-02 "nicht vor F1/F2 erzwungen"); Ziel-Targets comdare_planer/_ceb/_tier_emission/_hybrid; neue Projekte bekommen EIGENE Include-Wurzel <traeger/...>, PUBLIC-Wurzel des Monolithen wird NICHT erweitert.
STATUS LT. QUELLE: offen (Design final, Bau erst WE/nach S-8-Plan)
ABHAENGIGKEIT/FLAECHE: Owner-Frage B3; Findings 17/20; S-8/S-9/S-12/#28/#67.

### [design_zielstruktur] 2
GEGENSTAND: Nummern-Warnung (V12): im Wellenplan existieren ZWEI "#29" -- W7-Zaehl-Posten "wide_aggregat-Dedup" (Par.13.3, Z.1452/1756) und DIESER Par.18.4-Posten "Zielstruktur-Schnitt" (Z.2152).
ORT: Wellenplan v2 Z.1452/1756 vs Z.2152.
SOLL/FIX: In jeder Task-Liste den GEGENSTAND mitfuehren, nie die Nummer allein.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Risiko R3.

### [design_zielstruktur] 3
GEGENSTAND: Kanten-Matrix final (A2.5-Neumessung, EINE Zaehlweise: echte #include-Direktiven am Zeilenanfang, direkt+relativ, ohne Kommentar-Treffer): Summe verbotene Richtung = 59 Lib-Kanten (49+1+3+6) + 2 App-Kanten (apps/experiment_planner->builder) = 61 von 1.292 Dateien; Zaehlentscheid deklariert: die 5 ->builder-Kanten der drei Bau-Modul-Werkzeug-Apps (adhoc_emitter 2, catalog_codegen_tool 2, anatomy_codegen_tool 1) bewusst NICHT gezaehlt (Behelfs-CLIs, Absorption W7/#88).
ORT: design_zielstruktur.md Par.3/3a.
SOLL/FIX: Matrix ist die frische, objektgemessene Basis fuer die #67-Neuerhebung (S-6d).
STATUS LT. QUELLE: behoben (eingearbeitet, Review F1-F4)
ABHAENGIGKEIT/FLAECHE: Finding 19 (#67-Drittzaehlung); Owner-Frage B3.

### [design_zielstruktur] 4
GEGENSTAND: K1 -- RICHTUNGS-INVERSION PLANER->CEB (49+2 Kanten, Hauptlast): Schwerpunkt experiment_tree 26, bestandslog 8, build_orchestrator 6, codegen 2, driver_build_variant_signature 2, je 1 x5; dichteste Dateien profile_run_facade.cpp (8), profile_run_entry.hpp (7), lazy_adhoc_source_gen.hpp (6), experiment_plan_director.hpp (5); Code deklariert heutige Schichtung woertlich "TEIL2 lebt in der BUILDER-Schicht" (experiment_dock_payload.hpp:24); daneben planer->src 2 als eigene Mini-Familie (Fach-Richtung).
ORT: ce profile_facade/ -> builder/ (49 Kanten) + apps/experiment_planner (2).
SOLL/FIX: Aufloesung #88 (plan-seitige Single-Source-Header -> Planer/Querschnitt, Builder-/Iterator-Seite bleibt CEB); bis dahin S-8-Regel Par.4-Brueckenmarker.
STATUS LT. QUELLE: offen (#88)
ABHAENGIGKEIT/FLAECHE: Risiko R1; Schnitt-Posten Bruecken-Regel; Owner-Punkt 5 (experiment_tree-Besitz).

### [design_zielstruktur] 5
GEGENSTAND: K2 -- ZYKLUS builder<->mess (3 Kanten, measure_storage-Naht): checkpoint_measure.hpp:48 -> mess/konfiguration.hpp UND konfiguration.hpp:58 -> mess_arena.hpp + mess_naht.hpp:40 -> checkpoint_measure.hpp; egal wie mess/ zugeordnet wird, EINE Haelfte ist verboten.
ORT: ce builder/measure_storage/ + mess/.
SOLL/FIX: Geteilte Typen (MessEbene, MessCheckpointZeile, Arena-Formel-PODs) in den Querschnitt include/cache_engine/measurement/ heben -- Zeitfenster: mit #18/S-13 oder spaetestens #88; R2-Auflage: #13 (T-15b) und #18/S-13 erhalten den K2-Befund als Auflage ("Typ-Hebung mitdenken, Knoten nicht verdicken").
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Tasks #13/#18/S-13; Owner-Punkt 3 (mess-Schnitt).

### [design_zielstruktur] 6
GEGENSTAND: K3 -- QUERSCHNITT->CEB (6 Kanten, 2 Dateien: api/i_cache_engine_tools.hpp:23-25 + abi/cache_engine_execution_engine_adapter.hpp:14-16, ein ABI-Header der Stempel-Zone zieht Builder-Kommando-Interna); DAZU Querschnitt->Fach = 20 Kanten (abi/ 11, measurement/ 4, Rest 5; Ziele anatomy 13 / topics 4 / axes 3, alle relativ) -- der Querschnitt lehnt am Fach, wer ihn konsumiert bekommt anatomy transitiv mit.
ORT: ce include/cache_engine/api/ + abi/.
SOLL/FIX: #88: beide K3-Koepfe entkoppeln (Interface im Querschnitt, Implementierung im CEB-Projekt); bei #88 entscheiden: Flaeche-1-Vertraege in den Querschnitt heben ODER die Kante Querschnitt->Fach deklarieren. Folgerung fuer Par.1 (keine Compile-Kante CEB->TIER noetig) bleibt bestehen.
STATUS LT. QUELLE: offen (#88)
ABHAENGIGKEIT/FLAECHE: S-1..S-7-Stempel-Zone; Review F1/F3 (eingearbeitet).

### [design_zielstruktur] 7
GEGENSTAND: K4 -- PLANER->TIER (1 Kante): profile_run_facade.cpp -> harness/ (Stufe 1->3 rueckwaerts); Gegenstuecke ceb->tier 3 (iterator->harness 2 + checkpoint_measure->mess 1) loesen sich mit derselben Zuordnungsentscheidung; harness->builder (8) und mess->builder (2) sind als Stufe-3->2-Kanten stufenkonform.
ORT: ce profile_facade/profile_run_facade.cpp.
SOLL/FIX: Aufloesung mit K1 (Fassade delegiert kuenftig ueber die CEB-Stufe bzw. Lauf-Einstieg wandert).
STATUS LT. QUELLE: offen (#88)
ABHAENGIGKEIT/FLAECHE: K1.

### [design_zielstruktur] 8
GEGENSTAND: Schnitt-Posten VOR S-8 (bewusst minimal): (1) Zielbild+Besitzkarte als Plan-Dokument landen (der eigentliche W-Posten); (2) Skeleton-Commit = 1 Commit: NEUE Dateien libs/traeger/** PLUS GENAU EINE Anschluss-Zeile add_subdirectory(libs/traeger) in der Repo-Wurzel-CMakeLists.txt (es gibt KEIN libs/CMakeLists.txt; libs/* haengt an der Wurzel Z.737-753); je Projekt leeres INTERFACE-Ziel mit stabilem Namen, target_link_libraries bildet Stufenkette N+1->N compile-time ab; (5) Neutralitaets-Beleg: preimage-/golden-neutral, kein Versions-Bump, keine Beruehrung der 158/718-Riegel-Menge.
ORT: Repo-Wurzel-CMakeLists.txt Z.737-753 (einzige Bestands-Beruehrung).
SOLL/FIX: Timing-Voraussetzung: ce-Schreibsperre der Wellen-Landung (KON59-02) aufgehoben, dann WE-15./16.-Fenster VOR dem ersten S-8-Commit (Strecke P.31 startet S-8 Mo 17.); Ein-Schreiber-Konflikt an der Wurzel-CMakeLists.txt VOR dem Commit gegen parallele WE-Straenge pruefen.
STATUS LT. QUELLE: offen (WE 15./16., nach ce-Freigabe)
ABHAENGIGKEIT/FLAECHE: Finding 20; Owner-Frage B3; Restfrage 4 (wjrbqudaw).

### [design_zielstruktur] 9
GEGENSTAND: Bruecken-Regel fuer S-8/S-9 (Zielform-Pflicht KON43-02 konkretisiert): Neubauten unter traeger/planer/ bzw. traeger/ceb/; erlaubte Includes ohne Auflage: Querschnitt + Fach + eigene Stufe + Stufe N-1; Bestands-Wiederverwendung aus builder/ erlaubt MIT greppbarem ASCII-Marker "// TRAEGER-BRUECKE(#88): <Zielort>"; brueckenfaehig ist die K1-Vollmenge (10 Naht-Familien, 49 Kanten gedeckt); Bruecke AUSSERHALB der Liste erlaubt bei Besitzkarten-Nachtrag im selben Commit (lauter Zugang statt Verbot, A2.2-konform). DAZU Grenz-Wache als Google-Test (kein Shell, KON6-05; Muster test_vs_taxonomie_klassen_grep): (a) keine Include-Kante Stufe N->N+1 in libs/traeger/, (b) jede traeger->builder-Kante traegt den Marker; zieht MIT dem ersten S-8-Commit ein.
ORT: design_zielstruktur.md Par.4.3/4.4.
SOLL/FIX: NE-16-Auflage (KON59-02) gilt: neuer ctest/CI-Job ZUERST in den Wachen-Inventar-Nenner, sonst entsteht wieder eine unbewachte Wache.
STATUS LT. QUELLE: offen (mit S-8-Paket)
ABHAENGIGKEIT/FLAECHE: Merge-Flaeche 3 (Inventar-Nenner); Findings 3/54.

### [design_zielstruktur] 10
GEGENSTAND: NICHT vor S-8 (alles W7/#88 "beim Aufraeumen"): KEIN Datei-Umzug des Bestands, KEINE Include-Rewrites im 1.292-Dateien-Monolithen, KEINE CMake-Umverdrahtung bestehender Ziele, KEINE Aufloesung K1-K4 (nur Deklaration+Marker), KEINE Absorption der 9 apps-/13 tools-Behelfs-CLIs, KEINE Test-Umzuege (#28 macht W2 nur Eigentuemer+Inventur), KEINE CI-Job-Aenderungen (Mini-Pipelines baut S-12), KEINE modules/-Bereinigung; #29-Rest ist in W7 (Par.18.5) bereits verbucht.
ORT: design_zielstruktur.md Par.4 (NICHT-Liste).
SOLL/FIX: Scope-Wache fuer den Komplex-Fix: nichts davon jetzt anfassen.
STATUS LT. QUELLE: nur-hinweis (Scope-Grenze)
ABHAENGIGKEIT/FLAECHE: W7/#88.

### [design_zielstruktur] 11
GEGENSTAND: Risiken R1-R8 mit Gegenmitteln: R1 K1 waechst waehrend S-8 (Gegenmittel Bruecken-Regel+Grenz-Wache im SELBEN Paket); R2 K2-Knoten waechst in W2 (#13/#18-Auflage); R3 Nummern-Doppel #29 (V12 Gegenstand mitfuehren); R4 Namens-Drift bricht S-12 (nur ueber ALIAS-Ziele drehen, nie Erst-Namen brechen); R5 Include-Wurzel-Kollision (<cache_engine/...> doppelt lesbar; DRITTE Wurzel libs/cache_engine/src macht <measurement/...>, <concepts/...>, <permutations/...>, <sha512/...> mehrdeutig, measurable_concept.hpp von axes 77x als <measurement/...> gezogen; traeger/ erbt KEINE Alt-Wurzeln); R6 WE-Kapazitaet (Skeleton <=1 kleiner Slot); R7 Verwechslung modules/-Altskelett (README-Hinweis + Deprecation bei #88, nie loeschen); R8 "ceb haengt an tier"-Fehllesart (147 builder->Fach-Kanten sind CEB->FACH; Besitzkarte ist die Referenz).
ORT: design_zielstruktur.md Par.5.
SOLL/FIX: Gegenmittel je Risiko wie genannt.
STATUS LT. QUELLE: nur-hinweis (Risiken-Register)
ABHAENGIGKEIT/FLAECHE: S-8/S-12/#67/#88.

### [design_zielstruktur] 12
GEGENSTAND: Offene Owner-Punkte 1-7 (Default steht, Owner kann drehen): (1) Wurzel+Namen libs/traeger/*, Ziele comdare_*; Entscheid planner(EN-Bestand profile_facade/planner) vs planer(DE-Ziel) VOR dem ersten Umzug; (2) heuristik/-Zuordnung Default HYBRID, Planer-Mitnutzung Break-Even (KON7-05) bei HY-A bestaetigen; (3) mess/-Schnitt Default Kaskade->TIER, Naht-Typen->Querschnitt (loest K2), Zeitpunkt #18/S-13 oder #88; (4) Stufen-Kante Default adjazent-only, transitives Durchgreifen entscheidet erster Bedarfsfall LAUT (heute 0 solcher Kanten gemessen); (5) experiment_tree-Besitz Default Split bei #88; (6) Lager-Substanz (bestandslog 23 D./7.203 Z. + lager_ablage 2 D./929 Z.) Querschnitt-Kandidat vs CEB -- bei S-17 festzurren; (7) Timing-Lesart Skeleton WE 15./16. VOR S-8 (Inhalts-Regel bindet, Owner-Einspruch moeglich). DAZU: apps-Zaehlung 9 statt "10" (KON47-01) bei naechster Ledger-Fortschreibung korrigieren; #67-Uebergabe: 29er-Kanten-Definition (Kommando ausgeschrieben) in den Wellenplan, 142 als historisch ohne Definition markieren.
ORT: design_zielstruktur.md Par.6 + Par.3c-Uebergabe; Erhebungs-Nachweis Footer.
SOLL/FIX: Antworten je in einem Satz moeglich (Owner-Frage B3 deckt die Defaults).
STATUS LT. QUELLE: offen (7 Punkte + 2 Nachtraege)
ABHAENGIGKEIT/FLAECHE: Owner-Frage B3; Findings 18/19/32; S-6d/#67.

### [design_zielstruktur] 13
GEGENSTAND: Review-Einarbeitung Par.7: Gegenleser-Verdikt TRAEGT_MIT_FIXES; Kernaussagen halten am Objekt (Aufmass exakt, K1=49, ceb->planer 0, Fach->Traeger 0, Inseln, Umbrella-Ein-Punkt, alle KON-Anker verifiziert, #67-"142/29" mit 0 Belegstellen bestaetigt); eingearbeitet F1-F7 (K3=6/Summe 61, tier-Zeile 4+1, Querschnitt->Fach 20, CEB->Fach 147/Zaehlweise, Anschluss-Zeile+Timing, Whitelist K1-Vollmenge, Praezision/Anker/R5-src).
ORT: design_zielstruktur.md Par.7.
SOLL/FIX: Keine weiteren Dokument-Eingriffe; Publikation als docs/plaene/20260813-DESIGN-*.md in dieser Welle.
STATUS LT. QUELLE: behoben (7 von 7 eingearbeitet); Publikation offen
ABHAENGIGKEIT/FLAECHE: Finding 17.

================================================================================
TEIL 10 -- EXTRAKTION design_g1.md (DESIGN G-1 Grammatik dreiphasige Mess-Achse, 540 Z., FINAL
inkl. Review-Einarbeitung Par.10; Quellen-Stand super-Ledger bis KON59, ce @ 5f3f26a5)
================================================================================

### [design_g1] 1
GEGENSTAND: Auftrag/Status: ENTWURF als OWNER-VORLAGE, KEIN BAU (Par.15.2 Wellenplan v2 :1886 / KON13-03 Ledger :5605: "eine vereinfachte/ausgelegte Grammatik (Design durch Claude vorschlagen) fuer die DREIPHASIGE Mess-Achse"); KON13-03 strich KON9-04 ("drei Grammatiken"): ZWEI Grammatiken, eine je Stufigkeits-Klasse; Nenner 32 = 2^5 Mess-System-Permutationen (KON25-03: Tier 2x2, Hybrid 2x2, CEB Wallclock 2).
ORT: design_g1.md Par.0; Zielpfad nach Freigabe docs/plaene/20260813-DESIGN-g1-grammatik-dreiphasige-messachse.md.
SOLL/FIX: Bau erst nach Owner-GO, dann als Stempel-Strecken-Posten (KON38: Fable 5 max).
STATUS LT. QUELLE: offen (Owner-Vorlage)
ABHAENGIGKEIT/FLAECHE: Owner-Fragen B1/B2; Findings 17/18.

### [design_g1] 2
GEGENSTAND: IST am Objekt (ce 5f3f26a5): Mess-Stempel-Zeile existiert (measurement_stamp_line, anatomy_version_stamp.hpp:256-307; leere Zeile = "kein Mess-Tooling einkompiliert"); Tooling-Registry fuehrt 3 Eintraege wallclock/macro/micro je "1.0.0.c" OHNE Stufen-Dimension (measurement_tooling_registry.hpp:47-49) -- Neubau mit Stufen-Dimension tier/hybrid/ceb + Belegungs-Zaehlung <=32 ist owner-beschlossen (KON37-02); canonical_combo dedupliziert und SORTIERT (plan_legend.hpp:74-100) -- zerstoert die Anordnungs-Information aus KON37-03: als CI-Legende ok, als STEMPEL-QUELLE untauglich; G-1-Bestand Nichtfund mit Gegenprobe (0 Treffer fuer 6 Begriffe ueber libs/+tests/; Gegenprobe canonical_combo 2 Dateien).
ORT: ce anatomy_version_stamp.hpp:256-307; measurement_tooling_registry.hpp:47-49; plan_legend.hpp:74-100.
SOLL/FIX: Registry-Neubau (Stufe F) = Tabellen-Seite der Grammatik; canonical_combo bleibt Legende und speist NIE den Stempel.
STATUS LT. QUELLE: offen (Bau nach Owner-GO)
ABHAENGIGKEIT/FLAECHE: KON37-02-Registry-Neubau; F-G1-12.

### [design_g1] 3
GEGENSTAND: Kern-These + Regeln: G-1 ist PROFIL der Flag-Grammatik v2, keine zweite Sprache ("ausgelegt" = Auslegung der v2-Token-Syntax, "vereinfacht" = Restriktion in 4 Dimensionen: geschlossenes 13er-Vokabular, feste Stufen-Slots {b,h,t} je <=1, Tiefe <=2, genau EIN m-Flag); EBNF abschliessend (zwischen c[cpu_sub] und m steht NICHTS); Regeln M-1..M-11: EIN Parser/EIN Renderer (M-1, parse_algo_semver parst jede G-1-Form heute schon), (token,eltern)-Identitaet (M-2), Anordnung IST Information (M-6, m{b{w}.t{ma.mi}} != m{t{ma.mi}.b{w}}), drei Phasen = drei LESARTEN desselben Strings (M-7, KON16-02), EXAKTHEIT statt Teilmenge fuer Gueltigkeit (M-9, zweischneidiger Filter, KEIN Lager-Skip; Teilmenge NUR freigabeseitig via S-3), CPU-Pflicht bleibt (M-10).
ORT: design_g1.md Par.2-3; Kollisions-Erhebung 0 von 8 Kandidaten-Token im 62er-Katalog (Positiv-Gegenprobe bw beisst).
SOLL/FIX: Owner-Bestaetigung B2 (Profil + Vokabular m / b h t / w ma mi).
STATUS LT. QUELLE: offen (Owner-Frage B2)
ABHAENGIGKEIT/FLAECHE: Owner-Frage B2; F-G1-1/-2.

### [design_g1] 4
GEGENSTAND: M-8/F-G1-11 (Review-Hauptfund, eingearbeitet): die CEB stempelt den VOLLEN Vertrags-Ausdruck; reine Slot-Projektion des Kindes ist w-BLIND (m{b{w}.t{ma.mi}} und m{b.t{ma.mi}} projizieren auf DENSELBEN Tier-Stempel, obwohl per KON37-01 Satz 1 ":2148" + B3-Konsequenz ":2171-2172" das Tier-Kompilat w-abhaengig ist) = Alias-Identitaets-Klasse, verboten per KON34-05 :3229 + B11-Doktrin (algo_semver.hpp:533-537); Slot-Projektion zudem NICHT injektiv (derselbe Wert = CEB-Voll-Ausdruck UND Kind-Projektion beliebiger Herkunft; Rolle/Herkunft liegen am TRAEGER).
ORT: design_g1.md M-8 (Par.3.2) + Par.8 F-G1-11.
SOLL/FIX: Kind-Stempel-FORM legt der Owner in F-G1-11 fest (3 Optionen ohne Default: (i) voller Ausdruck / (ii) Kontext-Mitfuehrung vertragswirksamer Fremd-Slot-Instrumente / (iii) w als CEB-Selbst-Instrument -- widerspraeche B3 "Die Tier-Gates bleiben", muesste ausdruecklich widerrufen werden).
STATUS LT. QUELLE: offen (Owner-Frage B1/F-G1-11)
ABHAENGIGKEIT/FLAECHE: Owner-Frage B1; F-G1-4/-10 und Stufe-D-Pin-Form haengen daran; Finding 18.

### [design_g1] 5
GEGENSTAND: M-11 (A2.5-Schliessung): cpu_sub-Duplikate c{p.p}/c{e.e} sind von der Produktion ableitbar und heute von KEINER Bestands-Wache verboten (v2 kennt kein Geschwister-Duplikat-Verbot; flag_catalog_is_satisfied :934-941 prueft nur Zulassung je Knoten; algo_semver.hpp:1571 "andere Fehlerklasse ... NICHT gebaut").
ORT: design_g1.md M-11; Negativ-Beispiel B-5 (1.0.0.c{p.p}.m{b{w}} ROT).
SOLL/FIX: Schliessung mess-zeilen-lokal in mess_version_is_wellformed() (Stufe C); auf System-/Organ-Zeilen unveraendertes G-2-Erbe -> G-2-Semantik-Nachzug #17.
STATUS LT. QUELLE: offen (Bau nach Owner-GO)
ABHAENGIGKEIT/FLAECHE: #17 (G-2-Semantik).

### [design_g1] 6
GEGENSTAND: Durchsetzungsweg Stufen A-C (kein neuer Parser): Stufe A Parser NULL Aenderung + Beweis-Batterie (B-1..B-5 als static_assert-Pins; Tiefe 2<=4, m-Baum <=13 / volle Zeile <=16 << 96); Stufe B kMessGrammarCatalog als EIGENE Tabelle im Mess-Home (13 (token,eltern)-Paare; AUSDRUECKLICH NICHT m in den Hardware-Katalog eintragen -- legalisierte m still auf System-/Organ-Zeilen); Stufe C DREIPHASIG-Form-Wachen (mess_form_ist_dreiphasig ueber for_each_flag_node) + NEUES Praedikat mess_version_is_wellformed() (v2-Form + c/p/e + Mess-Katalog + Form-Wache + M-11); ce_owned_version_is_wellformed bleibt hardware-only; KONKRETE Umstellung: Registry-B12-Batterie tooling_versionen_wohlgeformt + Schwester-Wachen (measurement_tooling_registry.hpp:58-62) wechselt auf mess_version_is_wellformed -- sonst Registry-Neubau mit m-Schwanz compile-rot.
ORT: design_g1.md Par.6 Stufen A-C; neue Quelle faellt unter P14-Taxonomie-Riegel (gewollt).
SOLL/FIX: Wie beschrieben, mit LESBARER Meldung je Wache (erst laute Compile-Fehler, dann verschieben).
STATUS LT. QUELLE: offen (Bau nach Owner-GO)
ABHAENGIGKEIT/FLAECHE: Stempel-Strecke KON38; Merge-Flaeche ce (spaeter).

### [design_g1] 7
GEGENSTAND: Durchsetzungsweg Stufen D-F: Stufe D Projektions-/Messfuehler-Wache am Emissions-Punkt (mess_projektion constexpr; static_assert-Gleichheits-Pin -- genaue Kind-Stempel-FORM folgt F-G1-11; je Instrument concept-Anspruch an die Flaeche-3-Naht IMessVisitor/tier_measure_accept BEIDE Richtungen: Instrument ohne Durchstich = Compile-Fehler, Durchstich ohne Instrument = Compile-Fehler); Stufe E Freigabe-Relation: GEBAUTE S-3-Relation flag_menge_ist_teilmenge (flag_menge_ordnung.hpp:76-84) unveraendert fuer "gefordert TEILMENGE freigegeben"; ein Teilmengen-Skip fuer Mess wird NICHT gebaut; Stufe F Anschluss Registry-Neubau (XML mit Stufen-Dimension -> aufgeloeste Belegung -> EIN m-Ausdruck je Vertrag, "eine Aufloesung, zwei Verbraucher"; Deckel-Defaults nach KON42-01).
ORT: design_g1.md Par.6 Stufen D-F.
SOLL/FIX: Wie beschrieben; welche Tooling-<id> die Mess-Zeile bei Mehr-Stufen-Belegung traegt = F-G1-12 (heute GENAU EINE id, anatomy_version_stamp.hpp:256-259).
STATUS LT. QUELLE: offen (Bau nach Owner-GO)
ABHAENGIGKEIT/FLAECHE: F-G1-11/-12; KON37-02.

### [design_g1] 8
GEGENSTAND: Grenzen des Entwurfs (bewusst NICHT festgelegt): (1) Position der Mess-Zeile im Stempel-Gefuege = S-6-Fenster mit eigenem Explore ("Glieder-Reihenfolge: zwei Welten"; bis dahin wird an S-6 NICHTS gebaut); (2) Nenner-Umfang je Lauf rechnet AUSSCHLIESSLICH die Planer-Simulation S-19; (3) G-2-Semantik #17 eigener Auftrag in Achsen-Nummerierungs-Reihenfolge; (4) PMC und Lastsequenz bleiben Meta-Meta (F-G1-8/-9, kein stiller Entwurf); (5) KEIN BAU -- jede Zeile ist Vorlage.
ORT: design_g1.md Par.7.
SOLL/FIX: Scope-Wache: der Komplex-Fix baut hier nichts.
STATUS LT. QUELLE: nur-hinweis (Scope-Grenzen)
ABHAENGIGKEIT/FLAECHE: S-6-Sperre (MEMORY); S-19; #17.

### [design_g1] 9
GEGENSTAND: Offene Owner-Entscheide F-G1-1..F-G1-10 (nummeriert, Antwort je 1 Satz): F-G1-1 Profil der v2 bestaetigen (Empfehlung ja); F-G1-2 Vokabular m/b/h/t/w/ma/mi (0 von 8 Kollisionen); F-G1-3 KEIN Planer-Slot (Planer traegt 0 der 5 Nenner-Schalter; spaeterer Planer-Messfuehler = additives viertes Token); F-G1-4 Vererbung = Projektions-GLEICHHEIT auf vollem Vertrags-Ausdruck (FORM ist F-G1-11); F-G1-5 Exaktheit als Gueltigkeit (kein Teilmengen-Skip; Gegensatz zu G-2 gewollt); F-G1-6 leere Slots zulaessig, m ohne Slot verboten; F-G1-7 .c bleibt Pflicht vor .m (Empfehlung: keine F-10-Ausnahme); F-G1-8 PMC bleibt Meta-Meta AUSSERHALB des m-Flags (Empfehlung: aussen; Vendor-Permutation ist keine an/aus-Belegung); F-G1-9 Lastsequenz bleibt FRAMEWORK-Mess-Achse im load_framework-Segment; F-G1-10 String traegt Anordnung + Mess-Home-Tabelle pinnt Freigaben (Vorbild kFlagVoraussetzungsKetten); Zusatz: braucht die KIND-Identitaet die Vertrags-ANORDNUNG (haengt an F-G1-11).
ORT: design_g1.md Par.8.
SOLL/FIX: In die naechste Owner-Vorlage (Antworten im Design genuegen je in einem Satz -- so schon in Owner-Frage B2 angelegt).
STATUS LT. QUELLE: offen (10 Fragen)
ABHAENGIGKEIT/FLAECHE: Owner-Fragen B1/B2; Finding 18.

### [design_g1] 10
GEGENSTAND: F-G1-11 (NEU, tragend) + F-G1-12 (NEU) + Review-Einarbeitung Par.10: Verdikt TRAEGT_MIT_FIXES (alle Fundstellen exakt reproduziert, 5 Beispiele nachgerechnet, M-1 am Objekt WAHR, Owner-Zitate verbatim); eingearbeitet FIX 1 (KON37-01 Satz 1 sichtbar, M-8 neu, B-1/B-2/B-3 angeglichen, F-G1-11 mit 3 Optionen), FIX 2 (EBNF abschliessend + Spiegel-Probe 1.0.0.c.x512{f}.m{...} ROT auch auf Mess-Zeile), FIX 3 (Nicht-Injektivitaet ausgeschrieben, an F-G1-10 angeschlossen), FIX 4 (M-11), FIX 5 (Kleinfunde a-d inkl. Wachen-Umstellung benannt + F-G1-12 vorgelegt).
ORT: design_g1.md Par.8 (F-G1-11/-12) + Par.10.
SOLL/FIX: F-G1-11: Owner waehlt (i)/(ii)/(iii); F-G1-12: Tooling-id bei Mehr-Stufen-Belegung (Teil des Registry-Neubaus KON37-02, Stufe F).
STATUS LT. QUELLE: behoben (5 von 5 Fixes eingearbeitet); Owner-Entscheide offen
ABHAENGIGKEIT/FLAECHE: Owner-Frage B1; Finding 18.

### [design_g1] 11
GEGENSTAND: Publikations-Posten: design_g1.md (38.862 Bytes lt. wjrbqudaw) + design_zielstruktur.md (30.225 Bytes) liegen final und unpubliziert im JOB_DIR tmp/; Zielpfade docs/plaene/20260813-DESIGN-g1-grammatik-dreiphasige-messachse.md (Schwester zu 20260807-DESIGN-flag-grammatik-v2) und 20260813-DESIGN-zielstruktur*.
ORT: /home/comdare/.claude/jobs/5a19728e/tmp/design_{g1,zielstruktur}.md (Kopien im regressions-gesamtbild/).
SOLL/FIX: Publikation als docs/plaene/20260813-DESIGN-*.md in dieser Welle (Finding 17), nach Aufhebung der Schreibsperre.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Finding 17; Merge-Flaeche 6 (super-Push-Bereich).

================================================================================
TEIL 11 -- EXTRAKTION 20260813-PAUSE-3-vor-landung-workflows-resumebar.md (72 Z.;
ZUSAETZLICHE Quelle, nicht in der Auftrags-Liste -- am Objekt im regressions-gesamtbild/
vorgefunden, 13.08. 15:06 UTC = JUENGSTER Stand, nach allen anderen Quellen)
================================================================================

### [pause3] 1
GEGENSTAND: Pause 3 (13.08. 15:06 UTC): Owner-Order "Bitte pausiere alle agenten und dann abbruch sichere pause"; alle drei laufenden Tasks per TaskStop beendet; KEINE Bauprozesse (pgrep ninja/ctest = 0); kein Worktree traegt uncommittete Aenderungen aus dieser Runde (Workflows read-only).
ORT: regressions-gesamtbild/20260813-PAUSE-3-vor-landung-workflows-resumebar.md Kopf.
SOLL/FIX: Wiederanlauf nach Abschnitt 1 (zwei resumebare Workflows).
STATUS LT. QUELLE: nur-hinweis (Rahmen)
ABHAENGIGKEIT/FLAECHE: Pausen-Sorgfalt D (dritte Pause -- P1-P4-Pruefung sinngemaess auch fuer die nach Pause 3 resumten Straenge).

### [pause3] 2
GEGENSTAND: KOMPLEX-FIX-DESIGN-Workflow (dieser; zuletzt w5yb7s1p9, Run wf_3b74b5cc-5c5): Stand beim Stop started=26, results=0 -- KEIN Agent terminal fertig, alle 13 Leser laufen nach Resume erneut (Cache leer); Arbeits-Dateien leser_01..12.md + leser_kern.md ueberleben und werden beim Resume neu/weiter geschrieben; Ziel-Datei komplexfix_design.md; Phasen: 13 Leser (parallel) -> 4 Pruefer (ce/super/Flaechen/Pausen-Sorgfalt) -> Designer -> Vollstaendigkeits-Kritiker (+1 Fix-Runde).
ORT: tmp/komplexfix_design_arbeit/ + tmp/komplexfix_design.md.
SOLL/FIX: Resume via Workflow({scriptPath: ".../komplexfix-design-vollbefunde-wf_3b74b5cc-5c5.js", resumeFromRunId: "wf_3b74b5cc-5c5"}).
STATUS LT. QUELLE: offen (laeuft -- diese Datei ist Teil davon)
ABHAENGIGKEIT/FLAECHE: Designer-Phase konsumiert diese Extraktion.

### [pause3] 3
GEGENSTAND: GROSSER 6-CLUSTER-EXPLORE (zuletzt wmuecx7r9, Run wf_32d107d3-d7f): Stand beim Stop started=19, results=8 IM CACHE (alle 6 Sonnet-Explores + 2 Fable-Tieflesen fertig; 4 Tieflesen + Synthese laufen neu); Ergebnis = Synthese "VERSTAENDNIS-GRUNDLAGE LANDUNG+KOMPLEX-FIX" (deckt Owner-Explores B1/B2/B4/B5/D4 + required-Beispiele fuer A1).
ORT: Workflow wf_32d107d3-d7f (Scripts unter -home-comdare-Projekte-Cluster).
SOLL/FIX: Resume wie dokumentiert; Ergebnis vor Landung+Komplex-Fix UNGEKUERZT lesen (Kuerzungs-Lehre).
STATUS LT. QUELLE: offen (Resume ausstehend/parallel)
ABHAENGIGKEIT/FLAECHE: Owner-Fragen A1/B1/B2/B4/B5/D4.

### [pause3] 4
GEGENSTAND: S-7-KOMBIBAU KOMPLETT -- KEINE OFFENE BAU-ARBEIT: alle 4 Zellen "100% tests passed, 0 tests failed out of 490" am HEAD 178bb1fb (Baum sauber): gcc-rel + gcc-dbg Erstfahrt (Logs s7fix-gcc-*-ctest.log, 13:44-13:50); clang-rel + clang-dbg Rest-Fahrt nach setsid-Neustart (s7fix-kombibau-rest-master.log, ENDE fail=0 14:58:42; Skript j14-s7fix-kombibau-rest.sh); Bauverzeichnisse mit Belegpruefung (0/0) geraeumt; S-7 LANDEREIF.
ORT: /home/comdare/s1-logs/s7fix-* + s7fix-kombibau-rest-master.log; Branch bau/s7-algo-hardware-stempel @ 178bb1fb (wt-ce-mess-ordnung).
SOLL/FIX: Deckt die SOLL-Seite von Finding 44 [ROT] (4x 490 + ENDE fail=0 + Raeum-Belege 0/0); die formale LEAD-PFLICHT (Belege selbst lesen mit dem Finding-44-Kommando) bleibt VOR der seriellen Landung bestehen. ACHTUNG: das Master-Log der Rest-Fahrt heisst s7fix-kombibau-REST-master.log (Finding 44 nennt s7fix-kombibau-master.log -- beide pruefen).
STATUS LT. QUELLE: behoben (Kombibau komplett); Lead-Lesung offen
ABHAENGIGKEIT/FLAECHE: Finding 44; Merge-Flaeche 5; s7_dump 16.

### [pause3] 5
GEGENSTAND: LANDE-INVENTAR (am Objekt verifiziert 13.08. 14:55 UTC): super development lokal fa75d47c, origin a103e518, 10 Commits offen [DRIFT: aeltere Quellen (PAUSE-2, Sammelliste A.6, Owner-Vorlage) nennen 8 lokale Commits a103e518..f3017a77 -- Stand-Angaben je Stufe FRISCH messen, Finding 43]; super-Branches e21 fe7bb459 (3 Commits), texgate 5363eebb (4), f1-1x1 8e9a31d2 (4); ce development 5f3f26a5 (== origin); ce-Branches s7 178bb1fb, wachen 07a60cc7, p6 f6d13dfb (NUR Haupt-Klon-Store!); super-p6 (44b49194) ist GELANDET (merge-base-Beweis rc=0).
ORT: PAUSE-3 Abschnitt 5.
SOLL/FIX: Vor Diff-Hygiene/Meta-Gate (Merge-Flaeche 6) die lokale Commit-Zahl am Objekt frisch erheben, nicht aus Quellen uebernehmen.
STATUS LT. QUELLE: nur-hinweis (Inventar, juengster Stand)
ABHAENGIGKEIT/FLAECHE: Merge-Flaeche 6; Finding 43 (Standort-Angaben frisch messen).

### [pause3] 6
GEGENSTAND: Drei-Stufen-Landung (praezisierte Fassung, Owner-GO-gedeckt): ce seriell S-7 178bb1fb -> Wachen 07a60cc7 -> p6-Lizenz f6d13dfb -> Registry-XML-Regen N1; super F1 8e9a31d2 -> texgate 5363eebb -> e21 fe7bb459 + 10 lokale Commits + Designs (B3: "planner"!) + KON60-Nachtrag. AUFLAGE p6: f6d13dfb liegt NUR im Haupt-Klon-ce-Store (/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/.git/modules/...) -- vor dem Merge in den Lande-Store FETCHEN [kreuzt sich mit e21-Verify neuem Fund 1: derselbe Haupt-Klon-Store ist stale, origin/development=f23c18e2 -- beide Befunde zusammen behandeln]. Harmonisierungs-Flaechen: CMakeLists-Tails, Floor EINMAL live am Gesamtstand (S-7 491/487/485 vs Wachen 489/485/483 sind zwei AUSGANGSSTAENDE, KEINE Summanden), Wachen-Inventar, Lock einmal regenerieren, Kombibau am Gesamtstand. KEIN Push in dieser Stufe. Danach: KOMPLEX-FIX (Fable 5 max, komplexfix_design.md als Auftrag, VOR dem Push) -> EIN Push je Repo + EINE CI + Gitlink-Bump/PZW -> A1-Durchzug -> F1-Echtlauf.
ORT: PAUSE-3 Abschnitt 4; KON60-Nachtrag ist NEU gegenueber Owner-Vorlage/Sammelliste (dort Finding 11: KON-Nummer vergeben).
SOLL/FIX: Landungs-Reihenfolge und p6-Fetch-Auflage verbatim uebernehmen; "B3: planner!" = die Namens-Kollision planner(EN)/planer(DE) ist beim Design-Landen mitzunehmen (Owner-Frage B3).
STATUS LT. QUELLE: offen (nach Owner-GO)
ABHAENGIGKEIT/FLAECHE: Merge-Flaechen 1-6; Findings 11/61; Owner-Frage B3; verify_dump 33 (staler Haupt-Klon-Store).

### [pause3] 7
GEGENSTAND: Gestoppte Hilfs-Tasks: PLATTEN-WAECHTER (war bqxxlbcco) bei Wiederanlauf neu starten (run_in_background-Kommando dokumentiert: while true; df -BG avail; <=9G KRITISCH, <=14G WARNUNG, sleep 60); Kombibau-Waechter b1kdjkga7 FERTIG (Zweck erfuellt), nicht neu starten.
ORT: PAUSE-3 Abschnitt 3.
SOLL/FIX: Platten-Waechter vor grossen Bauten neu starten (volle Platte legt auch die Hooks lahm -- MEMORY).
STATUS LT. QUELLE: offen (Neustart bei Wiederanlauf)
ABHAENGIGKEIT/FLAECHE: Merge-Flaeche 5 (Kombibau am Gesamtstand braucht Platz-Gate).

================================================================================
BILANZ
================================================================================

QUELLEN GELESEN: 13 von 13 (12 zugewiesene VOLLSTAENDIG + 1 zusaetzlich am Objekt
vorgefundene 20260813-PAUSE-3-vor-landung-workflows-resumebar.md, 72 Z. -- juengster
Stand 15:06 UTC, fuer Lande-Inventar und S-7-Kombibau-Abschluss unverzichtbar).

EINTRAEGE: 190 im Extraktions-Format ueber 10 Teile (TEIL 2-11):
  owner-vorlage 15 * pause2 4 * 00-index 1 * s7_dump 20 * wachen_dump 15 *
  f1lens_dump 28 * luecken_dump 38 * verify_dump 36 * design_zielstruktur 13 *
  design_g1 11 * pause3 7 -- Summe 188 nummerierte + TEIL 1 (Sammelliste verbatim,
  64 Findings + Abschnitte A 1-6 / C / D P1-P4, alle 205 Quellzeilen) + diese Bilanz.
  KORREKTUR der Zaehlung: 15+4+1+20+15+28+38+36+13+11+7 = 188 Eintraege.

LUECKEN/DRIFTS FUER DEN DESIGNER (Quellen-Widersprueche, KEINE Bewertung hier):
  L1  Super-Lokal-Stand: "8 lokale Commits a103e518..f3017a77" (PAUSE-2, Sammelliste A.6,
      Owner-Vorlage, luecken_dump FIX) vs "10 Commits offen, lokal fa75d47c" (PAUSE-3,
      14:55 UTC, juenger) -- am Objekt frisch messen (Finding 43-Lehre).
  L2  Sammelliste-Kopfzeilen 4-5 sind STALE: nennen S-7 wwk6fs0bt / Wachen w4kqptnc9 /
      F1-Dual-Lens wv4wbbqnn als "stehen noch aus", die Abschnitts-Header tragen andere
      IDs (S-7 wsukojf00, Wachen wcy14e42k, F1-Lens wre78fwii) und KOMPLETT-Status;
      00-INDEX nennt ebenfalls wwk6fs0bt/w4kqptnc9/wv4wbbqnn -- Workflow-IDs am Journal
      verifizieren, nicht aus Kopfzeilen uebernehmen.
  L3  Finding 44 nennt s7fix-kombibau-master.log; PAUSE-3 nennt fuer die clang-Rest-Fahrt
      s7fix-kombibau-REST-master.log (ENDE fail=0 14:58:42) -- Lead-Lesung muss BEIDE
      Master-Logs pruefen.
  L4  p6-Fetch-Auflage (PAUSE-3) und staler Haupt-Klon-ce-Store (verify_dump 33) betreffen
      DENSELBEN Store -- gemeinsam behandeln (fetch bringt beides in Ordnung, danach
      4-Klone-Sync pruefen).
  L5  KON60-Nachtrag (PAUSE-3) vs "KON-Nummer vergeben" (Finding 11) -- vor dem
      Ledger-Nachtrag pruefen, ob KON60 schon vergeben ist (KON35-Luecke als Praezedenz:
      nie doppelt/nie Luecke unerklaert).
  L6  Owner-Vorlage Lande-Block nennt "8 lokale Commits + Designs + Ledger-Nachtrag";
      PAUSE-3 nennt "10 lokale Commits + Designs (B3: planner!) + KON60-Nachtrag" --
      die juengere Fassung traegt zwei Zusaetze (planner-Kollision, KON60), die aeltere
      ist der Owner vorgelegte Text: beim Vollzug die PAUSE-3-Fassung fahren, in der
      Owner-Kommunikation die Abweichung deklarieren.

ARBEITSREGELN DIESER DATEI: NUR LESEN + diese Extraktion; Repos/Worktrees READ-ONLY;
Redundanz zwischen Quellen ist beabsichtigt (Dedup macht der Designer); praezise
Anweisungen verbatim uebernommen (transliteriert nach Kopf-Regel); jede Zahl mit Nenner
soweit die Quelle einen traegt.

SELBSTCHECK: ASCII-only (LC_ALL=C, Muster [^\x09\x0A\x20-\x7E], SOLL 0 Treffer -- nach
dem Schreiben am Objekt gemessen); keine Platzhalter, keine leeren Abschnitte; 13 von 13
Quellen vollstaendig gelesen; 188 Format-Eintraege + Sammelliste verbatim (205 von 205
Quellzeilen); Schreiborte nur unterhalb tmp/komplexfix_design_arbeit/.
