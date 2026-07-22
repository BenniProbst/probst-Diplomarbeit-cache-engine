# REIHENFOLGE-UPDATE 22.07.2026 — Konsolidierter Gesamtfahrplan nach den heutigen Praezisierungen

> Konsolidiert die User-Praezisierungen des 22.07. in die EINE autoritative Abarbeitungs-Reihenfolge.
> Ersetzt die Reihenfolge-Abschnitte der Kontextuebergabe (Abschnitt 4/C) als juengster Stand; Gesetze in
> Ledger §62-B (P1-P4), §64, §61-KONSOLIDIERUNG(f); Board-Tasks #1-#14 spiegeln diesen Stand.

## ERLEDIGT heute (22.07., alles dual gepusht)
1. Nacht-Audit R1-R9 KOMPLETT: P1 R1-R3+Sweep-[c] (12115 gruen) · P2 R4/R5/R9 (12120 gruen) · P3 R6
   Stufe2_Hybrid · R7+Pin · R8a/b --print-cache-key + YAML-GN_CACHE_KEY (Kern-Befund: Warm-Pull traf
   ce-Pushes nie) · Doku-Fix artifact_cache. B4-Auflage (Ledger (f) + AUTONOM-01).
2. Smoke 12124 = BEFUND-Lauf: Kette vollstaendig bewiesen (16/16 wallclock-Builds gruen, per-Host-
   Serialisierung, echte CSVs); zwei Regressionen identifiziert -> Methodik-Profil-Schnitt (Schichten 1-3
   gelandet ce c85ddafe) + §64 (macro/micro-Lanen gecancelt=success, wallclock misst zu Ende).
3. §62-B-Praezisierungen 1-4 + SHA512/Factory-Bestaende + ETA-Korrektur + §64 komplett (inkl.
   Schichten-Zuordnung + Fundstellen-Beleg) in Ledger/Memory/Board verankert.

## DIE AKTUALISIERTE KETTE (Abgabe-Pfad, sequentiell)
1. **Methodik-Schnitt Schicht 4** (laeuft, Impl-S6-P1): Basename-Forward + Prolog-Re-Derive + YAML-smoke-Zweig.
   -> Commit + Gitlink-Bump (nimmt cf551722+c85ddafe+S4 mit).
2. **§64-Umbau** (Task #14, Fix-Kern klein): m3v2-Combos -> EINE Vollmengen-Combo bzw. leer=[all];
   [all]=vereint/gemischte Abnahme bestaetigen + Tests; Mengen-Stempel (X.Y.Z je Tag); Doku-Nachzug der
   SEPARAT-Stellen. Vorab kurze Agenten-Kartierung der [all]-Naht.
3. **NEUER vereinter Debug-Smoke** = der eigentliche S5-Gate-Beweis: EINE CEB-Lane, debug-parallel
   (#45) + Dual-Compile sichtbar + Cache-Push + HIT-Beweis-Kandidat (GN_DECISION=skip) + R8b-Key-Log.
   Erwartung: >=3x schneller als 12124.
4. **320er** (m3v2-320): VEREINTE Lane (nicht 3), Interim-Host-Lanes per GO (1), wallclock-first-Kern,
   Hochrechnung nach Lane 1.
5. **S7** (Hybrid + M-4 + Mess->PDF + Release-Wallclock-Beweis) -> **S8** (PDF DE+EN, 28.07.).

## DANACH (§63-Endlauf, praezisierte Pakete)
- **#46b** (Task #6, MASSIV praezisiert): versioniertes+gelocktes XML-Bestandslog (Header-Version
  Syntax+Semantik), ZWEI Bestaende als Factory Pattern (Binaries/Messwerte, je eigene Stempel-Strategie),
  4096er-Batches+Zeitstempel, Gleichverteilungs-Pflicht, ETA=Summe(t_i/N_threads) mit Untergrenze
  max(t_i) (Mini-Batch=max-Threads), +50%-Takeover, Schreib-Lock<=erste 30-min-Reservierung, Multi-Write
  waehrend Compile, Batch-Typen-Sequenz, Thread-Budget prod1=32T/prod2=24T, SHA512-Fingerprint-
  Stempel-Zeile (constexpr) + std::map-Lookup. VORBEDINGUNG: K7b/G1-Stempel-Umbau (B6-Auflage;
  traegt jetzt AUCH die SHA512-Zeile).
- #47 COMPARE · #54 emit-Vertrags-Kette (Pruefstand-Batch, von #46b-Reservierungen abgedeckt) ·
  #34-#37 · #49 (Hardware-Achsen; liefert die §62-E-Identitaets-Werte) · #51 · G-Gruppen.
- CI-Wartungs-Merkposten (Task #13): contract-Label-Luecke, Geschwister-Checkout-Race, Suffix-
  Reihenfolge-Single-Source, Mess-Job-Treiber-Bau-Overhead (~14 min/Job — Kandidat: Artefakt-Reuse).
- #48-Scheibe 6 (gegated 320er+GO, v1 darf brechen) — golden_kern traegt kuenftig auch §62-E/§64-Syntax.

## REIHENFOLGE-BEGRUENDUNG
§64 + Methodik-Schnitt kommen VOR dem 320er, weil sie dessen Laufzeit dritteln+ und der 320er sonst
unter dem Regressions-Default (3 Lanen, 1-Thread) mehrtaegig wuerde — exakt die §63-Nachtrag-Logik
(CI/Caching zuerst, dann der Lauf, der davon profitiert).
