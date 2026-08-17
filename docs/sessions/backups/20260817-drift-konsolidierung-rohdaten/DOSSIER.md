# KONSOLIDIERUNGS-DOSSIER 16.08.2026 (KON97) — NACHTRAGS-TEXTE FUER DIE 4 /goal-REFERENZDOKUMENTE

Owner-Auftrag 16.08.2026: "konsolidiere die offenen Posten in die 4 /goal Referenzdokumente ...
Drift im /goal-Plan regelmaessig ausgleichen." Material: Kopf-Referenz KON60-93 · Gegenlese-Karte
(73 Posten, Koerbe A-D; Ledger-Buchung = KON96) · 6 Gegenlese-Rohkarten · Rest-Karten r1-r5
(Ur-Ledger Z.16627-30077) · Explore-Karten E1-E4 (10-Wochen-Drift). Regeln eingehalten: additiv,
datiert, nichts geloescht, keine Duplikate zu vorhandenen Markern, neu gewinnt gegen alt,
Ueberholtes aus den Karten NICHT als lebend eingetragen.

VORAB-AUFLAGE (traegt alle vier Abschnitte): die Rest-Karten r1-r5 und Explore-Karten E1-E4 liegen
heute unter `/home/comdare/.claude/jobs/5a19728e/tmp/konso/` — VOR dem Einbau gem. B.3-Nachtrag
(Abschnitt 4) persistent sichern und als KON97 in den Ledger buchen, sonst zeigen die
Karten-Verweise der Nachtraege ins Leere (/tmp-Rotation).

================================================================================================
## ABSCHNITT 1 — GOAL v8
Ziel: docs/plaene/20260808-GOAL-V8-DOSSIER-alle-wellen-am-stueck-bis-abgabe.md

### EINBAU-ANWEISUNG
Block 1.1 direkt NACH dem letzten Absatz des 12.08.-Kopf-Nachtrags (Absatz "Die Korrektur-Tabelle
A ... Einzel-Marker.", Z.28), VOR der Trennlinie `---` und der Ueberschrift
"## VERSIONSHISTORIE UND ABLOESUNG". Die Einzel-Marker aus 1.2 an den dort genannten Stellen
einfuegen (je als eigener `> ⚠️`-Blockquote unmittelbar nach der genannten Zeile/dem genannten
Marker; vorhandene Marker bleiben unangetastet).

### 1.1 NACHTRAGS-TEXT (einbaufertig)

## REFERENZ-STAND 16.08.2026 — KONSOLIDIERUNGS-NACHTRAG (KON97)

> **Owner-Auftrag 16.08.:** die offenen Posten der Gegenlese KON1-59 vs. KON60-93, des Ur-Ledgers
> (Z.16627-30077) und der 10-Wochen-Drift-Explores sind in die vier /goal-Referenzdokumente
> konsolidiert; die Gegenlese-Praxis wird wiederkehrender Drift-Ausgleich (ARBEITSWEISE
> B.3-Nachtrag 16.08.). Dieses Kapitel VERWEIST auf Ledger und Karten, es dupliziert nicht.
> **Fakten-Quellen:** Ledger **KON94** (Full-Join FJ-1..FJ-10 + Arena E1-E11 + 6-GB-Schichtung) ·
> **KON95** (O1 markierter Leerwert · O2 Spaltenmenge E(A)=kV3AxisSchema+seg_* · O3 feingliedrig
> disjunkt) · **KON96** (Gegenlese-Karte, Koerbe A-D, 73 Posten) · **KON97** (diese Konsolidierung
> + Rest-Karten r1-r5 + Explore-Karten E1-E4). Bei Widerspruch: Owner-Wort schlaegt alles,
> Neueres schlaegt Aelteres.
>
> **Die tragenden Korrekturen/Ergaenzungen der Architektur- und Betriebs-Wahrheit:**
> **(1) KORB-A-ERWEITERUNG DES BUMP-BUENDELS:** #15 traegt ZUSAETZLICH zu Layout 6→7 + Format 4→5
> (Wellenplan §18) **14 Einzelposten** — u. a. 10. Stempel-Glied (GliedCount 9→10, Hybrid-Map-
> Zeile), Preimage-Budget-Bruch (kAnatomyFingerprintPreimageMax=4096), Synthese-Key-Grammatik,
> Glied-FOLGE/AxisKind-Vorentscheid, work_mode-Enum-Umbau, Stufe/Phase-Umbenennung, E-1-Stempel-
> Felder, prod2-Umbenennung, FullJoin-Umbenennung, S-6-Verbotszonen, 5. ABI-Symbol = Pflicht,
> B3 = Umzug der Schalter-Hoheit, EISERNE REGEL (nichts unter axes/ topics/ heuristik/), KEINE
> 123 Literal-Bumps → Wellenplan **§19.1** (Einzelliste), Ledger KON96/Korb A.
> **(2) DIE KETTE HAT 15 STATIONEN, NICHT 8** (Z14663-14729): nach AUSWERTEN folgt je gemessener
> Last single bauen→messen→compare→release, dann der Hybrid-Vierer; COMPARE ist zweimal eigene
> Station; „Release" = Optimum je Last → Einzel-Marker an VI.1(b).
> **(3) VOLLBAU-GATE (KON22) VOR DEM TRIGGER 26.08.:** „Lagerhaltung fertig UND Stempel fertig
> UND Algorithmen versioniert UND Messung einbaubar" — Gate-Pruefung als Vorlage VOR dem Trigger;
> Bau-Reihenfolge danach (KON17-04): Stempel → Planungs-Simulation → von der XML die GESAMTE
> Kette bis zur PDF — S-13 ist KERN, nicht Anhang → Einzel-Marker an VII.1.
> **(4) KON94/95-ENTSCHEIDE:** Full-Join ab ma-Ebene = FJ-1..FJ-10 als benannte S-13-Bau-Posten;
> Arena-Kette E1-E11 (E11 = Kapazitaet, 6 GB FEST/STATISCH per KON93-C6); O1 markierter Leerwert
> (gebaute honest-empty-Praezedenz, r4 B-06); O2 Spaltenmenge MIT Bezugsgroesse: `seg_*_ns` sind
> kommensurabel mit `seg_run_total_ns`, NIE mit `total_ns` (r1 A-7); O3 feingliedrig disjunkt →
> Wellenplan **§19.5**, Designplan **§12** (Testpflichten).
> **(5) LEBENDE UR-DOKTRIN-BLOECKE (Kopf-Deckung war NULL — nur Verweis, Volltext im Ledger/den
> Karten):** Kanal-Doktrin KON50-54 (drei Nachrichtenklassen hinauf, NIE Mess-Rohdaten zum
> Planer, OOB = genau das Fertig-Signal, Sync-Barriere, gefiltertes XML / sparse binary) ·
> MeasureStorage-Acht-Festlegungen + ZWEI Arenen + Allokations-Verbot (Z15143-15283) · SECHS
> Steuerdocks + Sammel-Release (Z14784-14853) · Emissions-Doktrin (KEINE YAML, zentrales
> C++23-Bau-Modul, Rakete rueckwaerts, Abschluss = Lager-Fund) · Registry = ANGEBOT / Anwender-
> XML = ANZEIGE (.pom-Resolver, DREI art-spezifische Registries, Par.27/28) · EIN-Hauptkanal-
> Doktrin (Par.71/73: „Eine XML, ein Kanal, Punkt") · Lager/Batch/ETA/Takeover + Job-Anzahl
> O(Maschinen) (Par.62-B) · Modi-Volldefinition, RELEASE = „ZIEL DES GESAMTPROJEKTS" (Par.61/
> 62-C) · Mess-Tooling-Vereinigungs-Default (Par.64) · Pruefstand: Google-Tests am Pruefdock VOR
> jeder Messung, Test-Log = Lagerhaltung (Par.62-B/68b) · generalisierte Schnitt-Regel (04.08.) ·
> `checkpoint_measure` C-1..C-17 (08.08.: uniforme IN/OUT-Funktion, eigener Stacktrace,
> virtuelle Thread-Slots — Namens-Herkunft damit VOR KON60(iii), r5 C1) · Record-and-Replay als
> Mess-Vertrag · Release = REKONSTRUKTIONS-Anfrage (loest W9: Binaries muessen nicht aufbewahrt
> werden) · Break-Even = B-Spline B=3, dreimal je Baum-node-Tiefe · Matrix/Baseline/Familie-
> Taxonomie 06./07.07. (traegt #74/W15, Explore-Karte E1).
> **(6) BETRIEBS-WAHRHEIT VOR W3** (Kurzliste, Posten im Wellenplan §19.3): Messung heute NICHT
> zweilanig · Drift-Gate ohne Debug-Ausnahme · HEAVY signal-gated · drei Projekt-Token (286/288/
> 289) nachweislich NICHT rotiert (Owner-Vorlage SOFORT, r3 C11) · PMC: vier Wachen beissen
> nicht, Deckel L1D+dTLB (Owner-Vorlage vor W3, r3 C1/C2).
>
> **Die zu setzenden Einzel-Marker dieses Nachtrags stehen als Liste direkt unter diesem Block;**
> die Wellen-/Task-Wirkung steht im Wellenplan **§19**, die Testseite im Designplan **§12**.

### 1.2 EINZEL-MARKER (Stelle → Marker-Text; je als `> ⚠️`-Blockquote einfuegen)

M-1 · **VI.1(b)**, nach dem Absatz „Diese acht Stationen sind zugleich die Explore-Ausloeseliste."
   (Z.404-409):
   „⚠️ MARKER 16.08.2026 (KON97): PRAEZISIERT — die Verarbeitungskette hat **15 Stationen, nicht
   8** (Z14663-14729): nach AUSWERTEN je gemessener Last single bauen→messen→compare→release,
   dann Hybrid bauen→messen→compare→multi release; COMPARE zweimal eigene Station; ‚Release' =
   Optimum je Last; Single-vor-Hybrid zwingend. Das Acht-Stationen-Bild bleibt als Grobbild;
   die Explore-Ausloeseliste gilt je Station."
M-2 · **VI.2**, nach dem PRAEZISIERT-Marker vom 12.08. (Z.417):
   „⚠️ MARKER 16.08.2026 (KON97): ERGAENZT — das Ausloese-Signal des Hybriden ist das FLATTERN
   der besten Tier-Binary (r5 :28945: Stufe 1 mittelt, Stufe 2 sucht das Flattern gezielt —
   Bereichs-Erkennung, keine Hysterese); Hybrid-Stempel vollstaendig spezifiziert (KON41-04/45/47:
   Map-Zeile, Value = Tier-SHA, Invariante RT ⊆ CT) → #15/HY-A2."
M-3 · **VI.4**, nach dem Kopfabsatz (Z.443-445, „…neuer Datensatz neben dem alten."):
   „⚠️ MARKER 16.08.2026 (KON97): ERGAENZT — Release ist eine REKONSTRUKTIONS-Anfrage an die
   compare-Bibliothek der Messwerte (r5 :29091): Binaries muessen nicht aufbewahrt werden —
   das loest W9 (‚Lager lagert Messdaten') ohne Owner. IST-Luecke: `WritebackMethod` kennt kein
   `xlsx` (Enum dreiwertig, XSD prueft freien String) — vierter Registry-Wert + Enum-Wache =
   #18-Posten (r5 A43)."
M-4 · **VI.5**, nach dem T-15a/b-Marker vom 12.08. (Z.510):
   „⚠️ MARKER 16.08.2026 (KON97): 🔴 das Drift-Gate kennt KEINE Debug-Ausnahme (`RunMethodology`
   in drift_detector.hpp = 0 Treffer; Owner: ‚Pruefer … schaltet Debug daher ab', Z13762-13898) —
   ungebaut ist bei der --debug-Generalprobe ab 29.08. JEDE Zelle rot; Debug-Zahlen sind
   Ausschuss, NIE ins Messwertlager (Sperrform AdmissionStatus existiert). Paket mit T-15/D4,
   VOR W3 → Wellenplan §19.3, Designplan §12/T-12a."
M-5 · **VII.1**, nach dem checkpoint_measure-Marker vom 12.08. (Z.543):
   „⚠️ MARKER 16.08.2026 (KON97): ERGAENZT — vor dem Bau-Trigger Mi 26.08. 06:00 steht das
   VOLLBAU-GATE (KON22): ‚Lagerhaltung fertig UND Stempel fertig UND Algorithmen versioniert UND
   Messung einbaubar' — Gate-Pruefung als Vorlage VOR dem Trigger; danach Bau-Reihenfolge
   KON17-04 (Stempel → Planungs-Simulation → von der XML bis zur PDF). HEAVY ist SIGNAL-GATED:
   das Signal fuer das 26.08.-Fenster muss GESENDET werden (KON58-03)."
M-6 · **VII.2**, ans Ende der Betriebsregeln (nach Z.557):
   „⚠️ MARKER 16.08.2026 (KON97): ERGAENZT — die Messung ist heute NICHT ZWEILANIG
   (`resource_group ceb-measurement-exclusive` hart amd/prod1; §61-Revision `ceb-measure-<host>`
   vom 21.07. nie umgesetzt, Intel-Gegenstueck fehlt; gegen ce `0c80aa78` am Objekt nachmessen,
   r4 C-1) — Bau-Posten VOR W3, sonst faehrt die Kampagne einlanig → Wellenplan §19.3."
M-7 · **TEIL IX**, nach der D3-4-Zeile („Ausgabe-Gate in allow_failure-Job wirkungslos", Z.634):
   „⚠️ MARKER 16.08.2026 (KON97): ERGAENZT — zusaetzlich zur geheilten OV-16-Stelle setzt der
   GENERIERTE Voll-Mess-Batch `allow_failure` auf JOB-Ebene (experiment_plan_director.hpp:
   1332-1333, ausserhalb rules:) — exakt der verbotene Fall ‚ZELLE = Warnung, JOB = rot';
   Task vor W3 (r3 C3) → Wellenplan §19.3."

================================================================================================
## ABSCHNITT 2 — WELLENPLAN v2, NEUER PARAGRAF §19
Ziel: docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md

### EINBAU-ANWEISUNG
Am DATEIENDE anfuegen, direkt NACH der letzten Zeile von §18.8 („… Mess-Permutation DYNAMISCH
>32, NUR S-19 (Meilenstein).", Z.2221), mit einer Leerzeile und `---` davor. §18 bleibt
unveraendert; was §19 praezisiert, steht hier, nicht als Edit dort.

### NACHTRAGS-TEXT (einbaufertig)

---

# 19. DRIFT-KONSOLIDIERUNG 16.08.2026 (KON94-KON97)

> **Anlass:** Owner 16.08.2026 („konsolidiere die offenen Posten in die 4 /goal Referenzdokumente
> … Drift im /goal-Plan regelmaessig ausgleichen"). Quellen: Ledger KON94 (Full-Join FJ-1..FJ-10
> + Arena E1-E11 + 6-GB-Schichtung) · KON95 (O1/O2/O3) · KON96 (Gegenlese-Karte KON1-59 vs.
> KON60-93, 73 Posten Koerbe A-D) · KON97 (Rest-Karten r1-r5 = Ur-Ledger Z.16627-30077 +
> Explore-Karten E1-E4). §13-§18 bleiben stehen; **was hier steht, gilt vor.** Klassen-Regel
> §13.2/§18.1 unveraendert (P/M/W = Wirkung auf den Freeze). Nichts wird gestrichen; Ueberholtes
> aus den Karten ist NICHT uebernommen (Ueberholt-Listen: KON96 + r1-r5/B-Abschnitte).

## 19.1 KORB A → DAS #15-BUMP-BUENDEL (14 Posten, VOR F2 Fr 21.08.)

#15 fuehrt per §18 bereits: Layout 6→7 + Format 4→5 + Budget in EINEM Bruch. Die Gegenlese
(KON96/Korb A) macht daraus das VOLLSTAENDIGE Buendel — jeder Posten einzeln abzunehmen:

    A-01  10. Stempel-Glied fuer ALLE Binaries (Hybrid-Map-Zeile, Tier traegt ""), GliedCount
          9->10 — im SELBEN Bruch wie Format 4->5 + Layout 6->7 (KON45-01 + KON5-04)
    A-02  Preimage-Budget-Bruch: 32 Docks > 4,5 KB sprengen kAnatomyFingerprintPreimageMax=4096
          (anatomy_fingerprint.hpp:68) — Konstante MIT Budget-Beleg heben (KON45-01(5)/KON58-11d)
    A-03  Synthese-Key-Grammatik existiert nicht; Map-VALUE = Tier-SHA statt Voll-Stempel;
          RT-Cache am Dock, Invariante RT ⊆ CT (KON45-01(6) + KON47-02) -> #15/HY-A2
    A-04  VOR dem Bruch entscheiden: Preimage-Glied-FOLGE (fest 9, :601) und AxisKind-Enum-
          Ordnung im SELBEN Bruch? Sonst steht der teuerste Bruch erneut an (KON5-04(3)/KON5-05)
    A-05  work_mode: Debug verlaesst das Enum (Ordinal 0), Build tritt ein, kWorkModeCount=4,
          neue Registry-Zeile; Kette build->measure->compare->release, Besitzer Planer (Z13694)
    A-06  Stufe/Phase-Umbenennung ist preimage-/ABI-wirksam => selbe F2-Frist wie S-6 (KON16-09)
    A-07  E-1-Heuristik-Rekursion: Tiefe + Stufen-IDs als Stempel-Felder (Owner, Z15504) -> #38a2
    A-08  prod2-Umbenennung ("Ja umbenennen"): Registry-Generator spiegelt den Namen (Z15650);
          VORHER prod2-Identitaet messen (lscpu: Alder Lake vs. 14900KS-Etikett, r1 C4)
    A-09  FullJoin (Pruefling-MergeStrategy, golden-byte-wirksam) beim S-6-Bau UMBENENNEN —
          Kollision mit KON91-"FULL JOIN" (KON30-02)
    A-10  S-6-Schnitt KOMPLETT (Umstellung · Transpositions-Sperre · Ordnungs-Wache · #67) +
          VERBOTSZONEN (Lager-Kaskaden, kOrganGruppen*, kSystemAxisOrder, kCompositionAxisNames,
          Hash-Mechanik, Messwert-2-Tupel) = INHALT von #15 (KON21-03/20-02/5-04)
    A-11  5. ABI-Symbol (Stempel) am Loader heute OPTIONAL (nullptr) — SOLL: Pflicht (KON7-01)
    A-12  B3 = Umzug der SCHALTER-HOHEIT zur CEB (abi_adapter.hpp:476-491 faellt), kein
          physischer Umzug; Vererbungsregel KON37-01 -> #24-B3 (vor F2, Owner-Datum)
    A-13  EISERNE REGEL bis zum Fenster: nichts unter axes/ topics/ heuristik/ anfassen —
          Overlay-Glied [7] hasht Quelltext (KON58-05); Arbeitsregel ALLER Straenge
    A-14  KORREKTUR: "jeder Algorithmus bekommt eine neue Versionszeile" hat NULL Ledger-Treffer;
          KON9-05 verlangt nur Stempel-UNTERSTUETZUNG — keine 123 Literal-Bumps (KON58-05)

Zusatz aus r2-r5, DEMSELBEN Fenster zugeordnet (Kurzliste, Details in den Karten): kCebFingerprint
rendert ANGEBOT statt Wahl (r3 A1) · COMDARE_MEASUREMENT_ON ABI-wirksam ohne Preimage-Glied (r3
A3) · O-2 Preimage-Glieder cxx/opt/build_type + bvset fehlen = OWNER-FRAGE Option A/B (r2 A61) ·
VS-A..VS-F STOPP-Gates offen, E-B bricht golden-CRC und fehlt im EINEN golden-Fenster (r4 A-07,
r5 A34) · Versionierungs-Interface + CT-Namensfunktion (Owner-KERN, Vorlaeufer 22.07.; Blocker:
reale Achsen-Typen ohne name(), r3 A6/A7) · run_methodology-Enum-Ordnung = Byte-Ereignis,
Owner-Frage G-5/C-7 (r1 A13, r4 C-7) · all_axes_golden.profile.xml nicht wohlgeformt, Flag-
Ausnahme entfernen (r3 A12) · F5-Owner-Halbsatz: XML-Syntax/Semantik + Planer-Interpreter (r3
A15) · telemetry-silent-Wiring golden-gebunden (r4 A-01) · stale Kommentar
bestandslog_document.hpp:22-26 faellt (r1 A28).

## 19.2 KORB B → DAS Di-25.08.-BUENDEL (#18 S-13 + Arena + #57 Lager + Naehte; 20 Posten)

    B-01  Naht-Schablone Planer<->CEB: 3 Nachrichtenklassen hinauf; NIE Mess-Rohdaten zum
          Planer (KON50-01/-02) -> S-8/S-10/#20
    B-02  Steuer-Naht spricht GEFILTERTES XML; Flaeche 3: Signal aus / Messwert-Stream ein,
          Format SPARSE BINARY (KON51-01) -> #20
    B-03  Arenen je Tier/Hybrid bei Anforderung; Flush nur an Hol-Punkten; Stummschaltung;
          OOB = GENAU das Fertig-Signal; ram_warn 6GB / ram_oob AUS, XML-einstellbar
          (KON51/52) -> S-13-XSD + S-10 (W1-Aufloesung s. 19.6)
    B-04  Inter-Experiment-Fenster = bidirektionale Sync-Barriere; --auto/manuell/VERNEINEN;
          kill-OOB; halb sauberer Stopp schreibt NICHTS Unvollstaendiges (KON53/54) -> S-8+S-10
    B-05  MeasureStorage: acht Owner-Festlegungen + ZWEI Arenen (Mess append / Stack LIFO),
          getrennte Cachelines, ALLOKATIONS-VERBOT in der Aggregation (Z15143-15283) -> E1-E11
    B-06  Ursache-Kette: variadische Mess-Template-Variablen NICHT durch Gattung+Genus
          durchgereicht => keine Arena-Init, kein flush() je Arena, keine Dock-Signale —
          Metaprogrammier-Luecke (Z14855-14921) -> E1-E11-Design
    B-07  Bestands-Fallen: ThreadArena/InMemoryMeasurementBuffer = Anti-Vorlagen;
          LIFOStackBuffer = Queuing-Achse; csv_to_latex -> measure_to_latex = MIGRATION mit
          Konsumenten (Z15248-15271) -> #18 + #74
    B-08  Lagerbaum: ZWEI NEUE WURZELEBENEN Gattung->Genus->Binary|Messung->REST fuer ALLE
          Gattungen/Genera; kostet Pfad-Grammatik + Tests + Wachen (Z15517/K1) -> #57
    B-09  Bestandslog NICHT scharf: mess_bestandslog_active=false; Restliste main.cpp
          ~:1112-1114/:1349-1351 + COMDARE_BESTANDSLOG_MESS_DOC_KEY in die Planer-Forward-Liste
          (Z16487/LAG-P2) -> #57
    B-10  Hybrid: Tier-Bau/-Laden IMMER durch die CEB delegiert; Standard-compare->release VOR
          dem Hybrid-Dock; Loader stufen-neutral (Z15482/OV-13 + K2) -> #57(3)/HY-A
    B-11  measure-drop-Kanal ZWEIFACH heilen: Ziel-Filter UND per-Binary-xlsx (KON32-01) -> S-13
    B-12  Export-Element Option b + vier ct-gesicherte Rueckschrieb-Methoden; PDF ausserhalb
          (KON27-02 + KON23-03) -> S-13-XSD
    B-13  Drei-Ziele-Struktur je XML separat; Runner LESEN nur ccache minio.comdare.de +
          Buildsystem-NAS ("mein letztes Wort") (KON13-04/15-05) -> S-13 + KON67-Abgleich
    B-14  SECHS STEUERDOCKS Planer<->CEB; zwei Rechtsakte (FREIGABE System / DURCHSETZUNG
          Organ); Release nur GESAMMELT vor/nach der Gesamt-Messung (Z14784-14853) -> S-8/S-10
    B-15  Default-Doktrin (constexpr-Defaults, XML ueberschreibt) · Hybrid ZWEIWEGIG
          XML-steuerbar · <hybrid>-Schalter · Hybrid-Meta-Meta = FAMILIE (KON42+Z13999)
          -> S-8/S-13/HY-A3
    B-16  Zielform-Pflicht AB SOFORT: S-8/S-9 in die Vier-Unterprojekt-Form; #29a
          Planer-Unterprojekt = erster Monolith-Schnitt (KON43 + KON47-01) -> W2-Struktur
    B-17  Emissions-Doktrin fuer S-12: KEINE YAML, zentrales C++23-Bau-Modul, Rakete
          rueckwaerts, Abschluss = LAGER-Fund, CEB-Bauten sequentiell (KON16/17/18/25) -> #3
    B-18  vierte Mess-Ebene = SPALTE der Macro-Stufe (Tier-Stempel je Funktionsaufruf);
          Overhead = Differenz (Z15553/K5) -> Mess-Design + S-19-Input
    B-19  B1 "direkt neu, das alte archivieren"; <measurement_tooling> + Stufen-Dimension;
          Korrelations-Pflicht; Anordnungs-Freigabe je Stufe Subset {W,Ma,Mi} (KON37-02/-03)
          -> #24-B1/B4-Design
    B-20  System B (17 Dateien, dormant) traegt die Ordnungs-Maschinerie; B4 = 9 Kern + 8
          Ripple = "Steuerung -> Compile" (KON34-01/04 + KON40-02) -> #24-B4

## 19.3 KORB C → TRIGGER-/W3-VORPOSTEN (Mi 26.08. 06:00 / Kampagne Sa 29.08.; 15 Posten)

    C-01  VOLLBAU-GATE (KON22) als Vorlage VOR dem Trigger — der Kopf kennt den Trigger,
          nicht das Gate
    C-02  HEAVY ist SIGNAL-GATED: das Signal fuer das 26.08.-Fenster muss GESENDET werden
          (KON58-03) -> Betriebs-Task Infra
    C-03  OV-4-Deckel = f(T-3): einlanig 41,4h@24W -> ~45,6h@16W; KEIN amd-16W-Trace;
          Deckel-Rechnung mit S-19-Zahlen VOR GO-Vorlage ##51 + Pflicht-Nachkalibrierung
          (KON41-01 + KON58-03) -> #7-Ausgang
    C-04  T-15 x KF-10 = 9 Messungen je Zelle: MESS-Phase verdreifacht sich -> --check-size +
          S-19-Rechnung (Z15403) -> #7
    C-05  Warmup-PAAR-Pflicht: run_observable_perm misst KALT (perm_runner.hpp:207,213) —
          anpassen oder ausbuchen + Tests (KON47-04) -> vor Kampagne; Testseite Designplan §12
    C-06  5/5-Retry-Klammer: Build UND Messung je 5x; 3 Wiederholungen einzeln persistiert
          (KON37-06) -> #13 T-15b
    C-07  T-15-Luecken: Granularitaet "ganzen Lauf neu starten" UNDEFINIERT; "bis zu 5
          Wiederholungen" zweideutig; T-15 kein CI-Gate (Z15411-15455) -> #13
    C-08  Die 5 sitzt FALSCH auf der Drift-Achse (ce 4cd1ab91): Umzug + 8-Punkte-Ripple;
          Arena-Formel muss x5 ZUSAETZLICH decken (KON26-04) -> #13 (+ 19.6/W1)
    C-09  DRIFT-GATE OHNE DEBUG-AUSNAHME (RunMethodology = 0 Treffer): sonst bei der
          --debug-Generalprobe ab 29.08. JEDE Zelle rot; Debug-Zahlen NIE ins Lager
          (AdmissionStatus existiert) (Z13762-13898) -> Paket mit T-15/D4 VOR W3
    C-10  ZWEILANIGKEIT: resource_group hart amd/prod1; §61-Revision (ceb-measure-<host>) nie
          umgesetzt; Intel-Gegenstueck fehlt; window_belongs_to unverdrahtet; gegen ce 0c80aa78
          nachmessen (KON29-04, r4 C-1) -> Bau-Posten VOR W3
    C-11  HART/SOFT: Achsen failen IMMER hart; NUR fehlende Messeinrichtung (PMC) soft =
          Warnung in die xlsx, Binary WIRD gebaut (KON28-02) -> T-15b/#13
    C-12  Fehlerklassen PFLICHT fuer alle Achsen->Unterachsen->Algorithmen; Stand 0/18 bzw.
          0/121 (Owner 17.07., Z14455) -> T-13/T-14 vor W3
    C-13  Skip-Oekonomie: selektiver Rebuild am 27.07. geloescht (ce 813c3232);
          System-Aenderung erzwingt Vollflotten-Neubau; W12-B + bvset-Richtungs-ctest (A⊂B)
          (KON6-03 + KON2-09/2-13) -> vor der Kampagne wiedergewinnen
    C-14  Bestandslog-SKIP-Risiko: je binary_id EIN Eintrag bei 320 bit-identischen IDs —
          SKIP kann falsch begruendet sein (KON3-06) -> Wache vor Kampagne
    C-15  MinIO Ebene B: gueltiger Beweis = CI-SMOKE mit Beweiszeile + Gegenkoeder HART-ROT im
          Ein-Blech-Fenster; Falle COMDARE_RUN_MEASURE erzeugt measure:golden-320 (timeout 10d)
          (KON58-04/#10 + KON56-01) -> Betriebs-Task vor Kampagne

## 19.4 KORB D → W2-TRIAGE (lebend ohne Frist-Anker; 24 Posten, neben #71)

    D-01  S-3-Abnahme: gebaut (ce 4a89aed5), KON55-Kombibau NIE gefahren; Aktivierungs-Beweis
          "gebaut UND inert" je Seite mit ZWEI Zahlen (KON58-08 + NE-10) -> W1-Rest; Test:
          Designplan §12/T-12e
    D-02  S-7-Bauplan + Fesseln P11->P4 · P6->P4 · P1->P2 · P3->P5 + Lande-Ordnung 1-9; sechs
          von elf Wellen-Posten ohne Kopf-Nachfolger (KON58-05/-10) -> W1/W2-Abgleich
    D-03  Riegel-Betrieb: 122 Traeger = Bump ODER Regen-Commit; --check Exit 3; LANDE-AUFLAGE
          nach JEDEM Merge --check+--write+git diff (KON58-01/-07/-13) -> Lande-Doktrin
    D-04  C-4-Wache modular splitten (deckt 6, >=152 ungedeckt); Home-SEMANTIK: EIN Waechter je
          Home, ZWEIstufige Versionierung, "golden zuerst" (KON17-03/KON2-19 + KON27-01) -> F5
    D-05  Compiler = kuenftige 5. SYSTEM-ACHSE gcc|clang, Unterachsen opt/flags/commands
          (KON55-01 + KON56-03; Ofast-Default s. 19.6/Widersprueche) -> S-9/S-11 + W7
    D-06  vier CacheEngine-Modi als PHASEN (State-Pattern, 0 Code-Treffer) zu BAUEN; compare
          vergleicht heute nichts (KON29-01/-03, r5 A28) -> W2/W3-Design
    D-07  Hybrid = Transmitter/Multiplexer, Glied der MESS-Kette; Autonomie zweistufig, S-20
          spaeter (KON19-02/13-01 + KON21-01/36) -> HY-Design-Register
    D-08  15-Stationen-Kette: Plan-/Memory-Nachzug (8-Stationen-Memory korrigieren) (Z14663)
    D-09  Pruefling = drittes Konzept, XML-beschraenkbar 1..3, ERWEITERT den Permutationssatz
          (KON30-02/KON31) -> S-19-Input + prt-art-Rolle
    D-10  Auswahl-Subsystem (17 Dateien): Fortfuehrungs-Entscheid FEHLT; K4/K5 ohne Eigentuemer
          (KON29-06/R-1 + KON20-04) -> Explore, dann ggf. Owner-Vorlage
    D-11  #19-Vorbedingungen: zwei Diff-Hygiene-Fassungen (super schwaecher, druckt GRUEN) +
          13 ungelandete ce-Branches + BRANCH-PFLICHT (KON5-06 + KON49-03/-04) -> vor #19
    D-12  PUBLIC-GANG-Buendel: Betreuer-PDFs, NOTICE-vs-LICENSE, 5. Schalter kopiert GPL-3
          wh.c UNGEGATET, "BEP" fuer die Person VERBOTEN (KON22/K + KON2-24/25) -> Release-CL
    D-13  ADR-Grundgesetz-Register (25 Entscheidungen, 04.05.) in den Ledger; §63-T T-08/T-19
          (KON-40 + KON-42) -> W4-Thesis-Fundament
    D-14  aufgehobene Streichliste = NEUN lebende Bau-Posten (CEB-27/43/12/34/18/20,
          33-Paper-Generator, Toolchain-Permutation, CEB-19) (Z16345) -> W5-W7-Zuordnung
    D-15  blockierende 09.08.-Entscheide ohne Kopf-Spur: D-5 Bau-vs-Mess-Menge (per r3 B5 als
          BAU-Posten aufgeloest: XML muss trennen, sonst Regression) · CEB-38 · CEB-Identitaet
          A/B · variant-Fehlerklassen-Ausnahme (per E2 Fund 10: Scope-Historie belegt,
          Hybrid-Dock-Ausnahme lebt — r5 A38) (Z16388) -> Explore-Rest, dann Owner
    D-16  Konformitaets-Register: 256 Aussagen, 17% ERFUELLT, +1564h — keine Nachmessung seit
          09.08.; KON82 misst ANDEREN Gegenstand (Z15887/Z16291) -> W4-Realitaetsanker
    D-17  Verifikationsvertrag V-1..V-8 lebt (Kopf-"V1-V10" = Namenskollision); OV-Nummern kein
          Autoritaetsbeleg (Z14501 + Z14434) -> Register-/Vokabelpflege (+ r4 A-08, r5 A59)
    D-18  Wachen-Sammelposten W2: Inventar-Nenner · drei allow_failure gegen Doktrin · libs/
          ohne -Wall · || echo an 3 appendix-Stellen · AF_CORPUS_ROOT tot · ZWEI PARSES ·
          D2-UB + kHashes · Registrierungs-Wache · measure_selection 0 · delete_p99_ns fehlt ·
          docs/termine · n/a-Gate · 289-Writeback (KON59-02/NE-16/-20 + Karte-5) -> #71-Nachbar
    D-19  Infra-Reste: COMDARE_NFS_DROP_TOKEN fehlt (Ebene C inert) · CE_SUBMODULE_TOKEN fehlt ·
          Registration-Token-Reset = Owner-Entscheid · "776" = Trefferzahl (KON58-04) -> Handout
    D-20  Prozess-Register: v3.6 Opus ERHEBT / Fable BEWERTET · v3.7 MAX DREI Vollbauten ·
          v3.8 Wellen-Form · Codex klein + zweiter Lens · ARBEITSWEISE an ZWEI Orten ·
          Ledger-Nachtrag an die LANDUNG · CMakeLists-Hotspot ans DATEIENDE · thematische
          Testnamen · vier /goal-Dokumente = Referenz-Hierarchie (KON58-09/-12 + KON39/38)
    D-21  Owner-ABGABE-PFLICHT: Syntax UND Semantik je Achsen-Kategorie ueber c hinaus;
          G-2-Semantik in Nummerierungs-Reihenfolge; MIN = zwei Filter (KON9-09 + KON13-03)
          -> W4-Pflicht + nach F5
    D-22  Karte-4-Spitzengruppe je eigener W2-Pruefposten: KON-46 Retry 5/2/1 · KON-11/12
          Drift-Wortlaut+n=1 · KON-36 fuenf rote Dauer-Tests · KON2-19 Lock-Gate 1/18 ·
          KON2-20 Stempel-Benennung · MT-L3 Orakel 0/29 · 34x "BLOCKIEREND" nie gebucht
    D-23  offen ohne Anker: -Wstringop-overflow (Pragma-Fix VERWORFEN) · 28-vs-13
          InputIfFileExists (vor F5-Anhang-Gate) · Thesis-Doppel-Submodul = per r5 A54 SOLL
          (Vertrag CI/lokal; .gitmodules-"TOT"-Kommentar richtigstellen, CI-Luecke r4 D-20
          bleibt) · KON12-03/S-17-Einsortier-Pfad am Objekt neu messen (KON58-13/-11) -> Triage
    D-24  Bleib-Notizen gegen Fehl-Abriss: PlanTextBuilder + plan dump + visibility:
          tier-binaries produktionskritisch · System-Achse sitzt IN der CEB · drei
          Versionierungs-IST-Luecken (Planer ohne SHA · CEB-System leer · Genus 5 Literale)
          (KON26-03/27-05 + KON8-04 + KON2-06/17) -> Design-Register + W2-Bau

## 19.5 FJ-1..FJ-10 + E1-E11 — BENANNTE BAU-POSTEN DES S-13-BUENDELS (#18, Di 25.08.)

Das S-13-Buendel (#18) fuehrt ab sofort ZWEI benannte Posten-Reihen (Volltext: Ledger KON92/94):

- **FJ-1..FJ-10 (Full-Join, KON91/KON94):** ab ma-Ebene ALLE Parameter inkl. PMC = FULL JOIN der
  mi-Achsen-Erfolgs-Parameter; Wurzel per XML `artifacts` ODER `binaries+measurement` (default
  getrennt) -> Gattung+Genus-Baum -> Lagerbaum je Genus-Tier-Binary (KON91-P1). Spaltenmenge
  E(A) = kV3AxisSchema + seg_* (KON95-O2) MIT Bezugsgroesse: `seg_*_ns` gegen
  `seg_run_total_ns`, NIE gegen `total_ns` (r1 A-7). Leerwerte nach KON95-O1 (markierter
  Leerwert; gebaute honest-empty-Praezedenz r4 B-06). Namens-Hygiene: `FullJoin`
  (MergeStrategy) ist ein ANDERES Objekt und wird per 19.1/A-09 umbenannt.
- **E1-E11 (Arena-Kette, KON92/KON94):** E1-E10 = S-13-Kernstueck (E6 Drain-Schleife =
  measurement_sink-Heilung); **E11 = Arena-Kapazitaet** (6 GB FEST/STATISCH, Planer-Reservierung
  zu Experiment-Beginn aenderbar, KON93-C6; 10-Wochen-Explore fuehrt x5 und 2-vs-18 als
  Pruefpunkte mit, s. 19.6/W1). ZUSATZ-AUFLAGEN aus r5 (checkpoint_measure C-1..C-17, 08.08.,
  KON94 kennt sie nicht): (i) Hot-Path = EIN statischer Deskriptor-Verweis, nie die
  ausgeschriebene Achsen-Kette; kein Alloc/IO im Hot-Path (C-4) · (ii) Ueberlauf = BEFUND:
  weiterlaufen, zaehlen, beim Auslesen melden — nie blockieren, nie still verwerfen (C-6) ·
  (iii) virtuelle Thread-Slots, Obergrenze = Thread-Unterachse (CT-bekannt, statischer Puffer);
  mehr Threads als Slots = LAUTER Fehlerfall (C-14/15/17) · (iv) thread-lokale Puffer sind eine
  RICHTIGKEITS-Frage (C-10). Testseite: Designplan §12/T-12c+T-12d.

## 19.6 DIE 18 WIDERSPRUECHE — 12 MARKER-AUFTRAEGE + 5 EXPLORE-AUFLOESUNGEN + 1 AUSTRAGUNG

Volltext + Auflösungs-Empfehlungen: KON96/Gegenlese-Karte Abschnitt 2. Hier die Arbeitsliste
(Marker = docs-only-Zug, EIN Commit; Explore = vor dem jeweiligen Bau):

MARKER (jüngeres Owner-Wort gewinnt, Marker AM ORT, Zeile bleibt):
    W1  Arena/6GB: KON93 gilt fuer die GROESSE; Warn-/OOB-KOMMANDO-Semantik bleibt eigenes
        Objekt; x5- und 2-vs-18-Pruefpunkte in den laufenden Explore
    W2  Mess-Nenner: KON71 gewinnt; 32/6->12/4! sind S-19-Eingangshypothesen; "24 oder 48" =
        S-19-Ausgang
    W3  Mess-Ebenen: drei Ebenen, vierte = SPALTE der Macro-Stufe, PMC = Meta-Meta; ACHTUNG
        r5 C4: der "gegenstandslos"-Marker darf NICHT an :28858 (fuenf ORTE, andere Zaehlung)
    W4  Lastsequenz = EIGENE Mess-Achse (KON64/65); UEBERHOLT-Marker an KON37-05
    W5  3/2/2-GESETZ lebt; die MENGE "final drei" ist ueberholt (Compiler-Achse, Meta-Metas)
    W6  HW-Erkennung: KON64/65-F2 gewinnt; bindend-Klausel an KON-03 nachziehen
    W7  Parallel-Deckel: BEIDE gelten (CI-Concurrency vs. lokale Vollbauten); Vorbehalts-Marker
        an KON73 ("unbeschadet v3.7")
    W10 --debug-Ende: T-3 gewinnt; Marker AM ORT (KON28-01 + Kapitel E)
    W11 Change Date: 10.08.2031 FINAL; Segment-Marker (lizenzwirksam)
    W12 Dock-32: Deckel-DEFAULT willkuerlich; XML-Pflichtangabe bei Hybrid-Anforderung bleibt;
        K5-Text per V7 nachziehen
    W15 Repo-Rollen: F6 gewinnt; im #74-Design ausweisen, dass Auswertung aus super wandert —
        kein stiller Umzug (+ E1-Hauptfund: Matrix/Baseline-Taxonomie VOR #74 zitieren)
    W16 checkpoint_measure-Name: kein Sachwiderspruch; KORREKTUR r5 C1: Owner-Wort bereits
        08.08. (C-1..C-17), KON60(iii) = BESTAETIGUNG; "Erfindung"-Befund austragen

EXPLORE (erst am Objekt, Owner nur bei Rest-Diskrepanz):
    W8  KEINE-YAML vs. S-12: Design-Explore der Naht; ACHTUNG r2 C-3: Par.42/40.b meinen die
        TRAEGERKETTE — haelt die Werkstatt-CI-Lesart nicht, Owner-Vorlage mit beiden Wortlauten
    W9  Lager-Inhalt: per r5 A18 AUFGELOEST (Release = Rekonstruktion, Binaries nicht
        aufbewahren) — Explore nur noch als Beleg-Zug am lager_baum_writer, dann Marker
    W13 CEB-Erreichbarkeit 4-vs-6: nach B2-Gate-Trennung am Objekt messen; r5 A14/C6: heute
        max 2 herstellbar, G3-aus-STATISTICS-Gate ist die Vorbedingung
    W14 T17 vs. ORG-19: Explore ob persistence_target daneben besteht; koppelt an K17-Pinning
        und die gedruckte 2^17 (r4 C-6/D-19)
    W17 Backup-Ref: Identitaet pre-secret-scrub-Ref <-> V9 verifizieren; r3 W-r3-6 liefert
        SHA 5ba3d03f + "github war schon 06.08. leer"

AUSTRAGUNG:
    W18 merge-Zeile: Owner-Verbot steht; LEDGER:8941 (§59-MERGE-STEMPEL) AUSTRAGEN, bevor
        jemand den verbotenen Bestand baut — Trigger-Risiko 26.08.

ECHTE OWNER-FRAGEN (kein Explore loest sie; gebuendelt vorlegen): (a) KON3-03 XML-Wache
unbeobachtbare Zweighälften · (b) E-5 kanonischer Kurven-Stack + K4 (GETRENNT) · (c)
Registration-Token-Reset — PLUS aus r1-r5: O-2 Preimage-Glieder (A/B) · VS-A..VS-F ·
AVX-512-in-golden + no_extension-Cross-SKIP (r1 A-12) · PMC-Gueltigkeit/Anhangs-Umfang
(r3 W-r3-2/W-r3-4) · Selektor-Richtungen MAX/MIN (r4 C-5) · ETA-Merge last_update_utc (r5 A48)
· F-01 Talos zuruecknehmen (r3 D1) · Token-Rotation 286/288/289 (r3 C11, SOFORT).

## 19.7 UR-LEDGER-RUECKKEHRER (aus r1-r5 + E1-E4; NUR im Massstab wirklich Ungedecktes)

| # | Posten (Kurzform, Beleg in der Karte) | Quelle | Kl. | Welle |
|---|---|---|---|---|
| R-01 | Planer-Split: ZWINGEND eigene Binary VOR Abgabe (R-G1; Schnitt-Spez liegt) | r2 A40 | P | W1/W2-KOPF |
| R-02 | Lager-Basis-Tests: Dummy-Text-Strategie + leerer Binary-Stub (Owner-KERN) | r3 B1 | M | W2/#57 |
| R-03 | Inventar-Batch-Cache: Host-Belegung fehlt (Ebene 1 inert) + Plan-Ablage 156x | r3 B2/B3/B9 | M | W2/#57 |
| R-04 | LB-4/LB-5/LB-6>1 NICHT gebaut ("Voll-Bau-Trigger IST der Baum-Vollausbau") | r3 B4 | P | vor 26.08. |
| R-05 | XML-Trennung BAU-/MESS-Menge (Owner: "sonst regression"; Schnitt liegt) | r3 B5 | M | W2/S-13-XSD |
| R-06 | WritebackMethod::Xlsx + XSD-Enum-Wache; A9-Bauliste am Objekt nachmessen | r5 A43/A45 | M | W2/#18 |
| R-07 | Bestandslog-SOLL (verteiltes System, 4096/ETA/Takeover/Locks) als Design | r2 A8, E2 F1 | M | W2/#57 |
| R-08 | Batch-Job-Prinzip O(Maschinen): Emissions-Umbau ohne Vollzugsbeleg | r2 A9/C-1 | M | W2->W3 |
| R-09 | G3 aus dem STATISTICS-Gate loesen (6 CEBs; heute max 2; --check-size-Basis) | r5 A14/A24 | M | W2 |
| R-10 | Registry=ANGEBOT/.pom-Resolver + 3 Registries + Generator je Registry | r2 A1-A3 | M | W2-Design |
| R-11 | Resolver fuer target_isa-RT-Unterachsen + core_class-Provenienz (Ω-1..Ω-3) | r4 C-02/C-03 | M | vor W3/#53 |
| R-12 | E-07-Gate: Kriterien 0 Treffer im Code; Position B10 trigger-blockierend | r3 C4 | P | vor 26.08. |
| R-13 | Zwei unwahre Messgroessen (bytes_in_use_peak; CLU-64) vor dem ersten Batch | r3 C5 | P | vor 26.08. |
| R-14 | Chaos-/Drift-Gate ohne Produktions-Aufrufer; CI-Job existiert nicht | r3 C8 | M | vor W3/#13 |
| R-15 | L3-Asymmetrie prod1 (96/32 MB) + Pinning-Pflicht; ungepinnt nicht reprod. | r4 C-01/C-08 | M | W3-Vorb. |
| R-16 | 21-Images-Entscheid (7 OS x 3) — Marker an alle 7/8/18-Stellen | r4 C-05 | W | W2-Marker |
| R-17 | Tag-Mismatch baremetal/bare-metal sperrt Runner id6-9 aus | r1 A46 | M | vor W3 |
| R-18 | adhoc_emitter ohne CI-Job; R5.G-Tests fehlen der Inventur | r1 A34 | M | W2 |
| R-19 | GN-9 Feasibility-Gate ohne Fahrplan-Slot; 4096-static_assert-Schranke | r4 C-04, B-08 | M | #7-Ausgang |
| R-20 | HDR verdrahten (Thesis-Praesens; 1 Include) + p95-Export + 4 Zusagen | r1 A21/A22 | M | vor W4 |
| R-21 | Break-Even: ZWEI Implementierungen + B-Spline/String/3x je node-Tiefe | E3 F1, r5 A15/16 | M | W4-Vorb. |
| R-22 | Record-and-Replay als Mess-Vertrag der 3 Ebenen (Traeger der Elimination) | r5 A17 | M | W2-Design |
| R-23 | Klebe-Zeit der Gattungs-Interfaces = separater Messpunkt (Auswerte-Regel) | r5 A19 | M | W4/#18 |
| R-24 | Sheet-/Profil-Blattfamilien: Blattzahl-Formel + Hyperlinks + Checkpoint-Sp. | r5 A21/A22/A2 | M | W2/#18 |
| R-25 | UltiHash/Produktions-Release-Konzept (H5 + Owner 25.06.; 3x unverfolgt) | E4 F1 | W | Owner+W4 |
| R-26 | BAUSTEINE_BEWERTUNG.md + Habich-Sign-Off je SOTA-Quelle | E4 F2 | W | Owner+W4 |
| R-27 | Nachtrag-1-Register (KON-01..-66) komplett gegen KON60-96 gegenlesen; 6 | E4 §2 | W | W2-Triage |
|      | bestaetigte Luecken: KON-26/-27/-31/-33/-39/-56 (u.a. "sauberste Strategie |  |  |  |
|      | gilt fuer ALLEN Code", nicht nur Infra) |  |  |  |
| R-28 | Bauweg-Doktrin: configure.sh/make/make install/make check im Wurzelordner | r5 A53 | M | W2/#74 |
| R-29 | tier150_measurements.csv ARCHIVIEREN (danach rm-build-Memory nachziehen) | r5 A55 | W | W2 |
| R-30 | Schicht-Verstoss anatomy->builder (Owner-GO "Fenster ist jetzt") | r5 A56 | M | W1/W2 |
| R-31 | LaTeX-Anlage + Textbausteine IN die Abgabe (hebt Betreuer-Auflage, abgest.) | r5 A78 | M | W4 |
| R-32 | Lizenz-Feinheiten: Sperrvermerk+Uni-Ausnahme, privates Copyright, KI-Verbot; | E2 F6, r5 | W | Release-CL |
|      | liburing fehlt in Lizenzdateien; 3 Allokator-Lizenz-Abweichungen | A75, r4 D-01 |  |  |
| R-33 | samba-Vault-Wert kompromittiert -> Rotationsliste (Kopf kennt nur V8) | r5 A74 | W | Infra |
| R-34 | Cross-Plattform-Infra (Win/macOS/7-Linux-Container) + Debug-only-Plattformen: | E2 F2, r4 | W | Explore |
|      | existiert sie noch / bewusst descoped? (sonst still verlorene Anforderung) | C-06 |  |  |
| R-35 | S-7 Locking/Observer-Strang (Owner-PFLICHT deep research; Plan liegt) | r1 A16 | M | W2-Strang |
| R-36 | H1-H7-Fork-Entscheide (H4: std::map-Interfaces variadisch => XSD) + FF0 | r1 A17/A45 | M | W2/#18+W4 |
| R-37 | §75-Kandidatenliste 133/104 offen + §55-RECONCILE 26 offen (Anker migriert) | r5 A57/A58 | W | W7 + Triage |
| R-38 | ETA-Merge verwirft still; last_update_utc-Ein-Feld-Schnitt (Owner offen) | r5 A48/A50 | M | W2/#57 |

**Abgrenzung (nicht doppelt buchen):** Paper-Experiment-XML je Paper steht bereits in §18.8
(Zeile "NEU … W2 mit #18") — Praezisierung dort: Owner-GO 08.08. ("Ja unter sorgfaeltiger Design
Planung bitte bauen") + Ist-Befund 0 Experiment-XML, profile_ref nie dereferenziert (r5 A26,
E3 F2). PMC-Schwester-Design ebenfalls bereits §18.8.

================================================================================================
## ABSCHNITT 3 — DESIGNPLAN-TDD, NEUER NACHTRAG §12
Ziel: docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-wellen.md

### EINBAU-ANWEISUNG
Am DATEIENDE anfuegen, direkt NACH der Summen-Regel-Zeile von §11 („**Summen-Regel
(unveraendert):** 117/386 h bleiben unangetastet; …", Z.601), mit `---` davor.

### NACHTRAGS-TEXT (einbaufertig)

---

## 12. NACHTRAG — KONSOLIDIERUNG 16.08.2026 (KON94–KON97)

**Status (KON19-00):** Fortschreibung von §10/§11 nach demselben Muster; nichts geloescht,
nichts an den Summen. Fakten-Quellen: Ledger KON94 (FJ-1..FJ-10, Arena E1-E11, 6-GB-Schichtung) ·
KON95 (O1/O2/O3) · KON96 (Gegenlese-Karte) · KON97 (Rest-/Explore-Karten). Als GEZAEHLTE
Posten-Liste (5 neue Testklassen), noch NICHT in den 117er-Katalog eingerechnet — dieselbe
Summen-Regel wie §10/D-4.

**T-12a — DRIFT-GATE-DEBUG-AUSNAHME-TEST** (Z13762-13898; Owner: „Pruefer … schaltet Debug daher
ab"): heute `RunMethodology` in drift_detector.hpp = 0 Treffer — bei der --debug-Generalprobe ab
29.08. waere JEDE Zelle rot. GEZAEHLTE Pflichten: (1) unter `--debug` schaltet das Drift-Gate ab
(Verzweigung am RunMethodology-Flag; Koeder: eine Fassung, die Debug-Zellen rot drift-prueft,
wird ROT); (2) Debug-Zahlen tragen die Sperrform (`AdmissionStatus::Gesperrt`, fail-closed) und
erreichen NIE das Messwertlager (Koeder: eine Debug-Zeile, die im Lager landet, wird ROT —
T-4-Gegeneingang); (3) Nenner-Zeile: der Test weist BEIDE Zweige mit literalem Rot/Gruen aus.

**T-12b — WARMUP-PAAR AM LEGACY-PFAD** (KON47-04 + KON58-11(b); ergaenzt T-11a): der
Legacy-Pfad `run_observable_perm` misst heute KALT (perm_runner.hpp:207,213). GEZAEHLTE Pflicht:
ENTWEDER Paar-Zaehlung 2x3 = 6 Laeufe / 3 Werte auch am Legacy-Pfad (T-11a-Norm, Koeder: kalter
Einzel-Lauf, der persistiert, wird ROT) ODER ein Ausbuchungs-Beweis, dass der Pfad von keinem
Produktions-Ziel mehr gefahren wird (Nullbefund NUR mit Gegenprobe „wer ruft ihn?"). Vor der
Kampagne; haengt an Wellenplan §19.3/C-05.

**T-12c — ARENA-KAPAZITAETS-TESTS (E11)** (KON94 + KON93-C6 + r5 C-1..C-17): GEZAEHLTE
Pflichten: (1) Kapazitaet 6 GB FEST/STATISCH, Planer-Reservierung nur zu Experiment-Beginn
(Koeder: Laufzeit-Resize wird ROT); (2) virtuelle Thread-Slots: Obergrenze = Anzahl der
Thread-Unterachse, compile-time bekannt, Puffer statisch (Koeder: Slot-Ueberschreitung ohne
LAUTEN Fehler wird ROT); (3) Ueberlauf = BEFUND: weiterlaufen + zaehlen + beim Auslesen melden
(Koeder: still verworfene Zeilen ODER blockierender Hot-Path werden ROT); (4) Hot-Path-Reinheit:
kein Alloc, kein I/O, EIN Deskriptor-Verweis statt Achsen-Kette (Allokations-Verbot Z15641;
Koeder: eine Aggregations-Allokation wird ROT); (5) IN-ohne-OUT-Invariante je (Prozess, Thread,
Interface) als Auswerte-Wache (r5 A12/N-6).

**T-12d — FULL-JOIN-SCHEMA-TESTS (FJ-1..FJ-10)** (KON91/KON94/KON95): GEZAEHLTE Pflichten:
(1) Spaltenmenge E(A) = kV3AxisSchema + seg_* (KON95-O2) mit BEZUGSGROESSE: Summe der 19
Organ-Segmente + seg_framework_ns == seg_run_total_ns (an golden-Daten verifiziert); Koeder:
ein Test, der seg_*_ns gegen `total_ns` stapelt, wird ROT (Phantom, r1 A-7); (2) markierter
Leerwert nach KON95-O1: ECHT-0 eigene Klasse ≠ nicht-ausgefuehrt = Auslass (honest-empty-
Praezedenz r4 B-06; Koeder: ein zmode=log-Pfad, der eine echte 0 verschluckt, wird ROT);
(3) Full-Join verwirft nichts: je Achse bleibt jede mi-Erfolgs-Spalte erhalten (Koeder:
Spalten-Drop wird ROT); (4) Namens-Wache: `FullJoin` (MergeStrategy) bleibt getrenntes Objekt
bis zur 19.1/A-09-Umbenennung (Kollisions-Koeder).

**T-12e — S-3-KOMBIBAU-NACHWEIS** (KON58-08 + KON59-02/NE-10): S-3 ist gebaut (ce 4a89aed5),
der KON55-Kombibau wurde NIE gefahren (ctest-Starts NULL). GEZAEHLTE Pflichten: (1) die
2x2-Matrix {clang, gcc} x {Debug, Release} je J-1..J-4 + ctest mit literaler Bilanz (T-11b-Norm)
EINMAL real durchfahren und protokollieren; (2) Aktivierungs-Beweis „gebaut UND inert" je
Flag-Seite mit ZWEI Zahlen AM OBJEKT — `bvset_ist_teilmenge` hat 2 PRODUKTIONS-Treffer, „inert"
ist teilwiderlegt und wird gemessen, nicht behauptet; (3) Koeder: eine (token, eltern)-flache
Kuerzel-Pruefung wird ROT (Paar-Identitaet, r4 A-04/r5 A30).

**Summen-Regel (unveraendert):** 117/386 h bleiben unangetastet; T-12a–e sind erst zu addieren,
wenn die S-Strecke (§10/D-4) mit-durchgezaehlt wird — sonst der T-3-Fehler aus §9.

================================================================================================
## ABSCHNITT 4 — ARBEITSWEISE-GESAMT-DOKTRIN (NUR B.3-Nachtrag + Aenderungslog, KEIN Bump)
Ziel: /home/comdare/Projekte/docs/ARBEITSWEISE-GESAMT-DOKTRIN.md

### EINBAU-ANWEISUNG
Block 4.1 INNERHALB von B.3 anfuegen: direkt NACH der letzten B.3-Zeile („- **Handout-Ziel fuer
Infra:** `Cluster/docs/sessions/` (datiert).", Z.953), VOR der Ueberschrift „## B.4". Block 4.2
ans ENDE des AENDERUNGSLOGS (nach dem v4.3-Eintrag, Z.1167). Kopfzeile/Fassung v4.3 NICHT
anfassen; Teil A und Teil V NICHT anfassen.

### 4.1 NACHTRAGS-TEXT B.3 (einbaufertig)

### B.3-NACHTRAG 16.08.2026 (KON97) — Session-Verschaerfungen der Drift-Konsolidierung

- **gitleaks auf prod1 = LOKALES Binary, nicht docker:** der docker-Weg scheiterte reproduzierbar
  an der Submodul-gitdir-Aufloesung (`.git` ist eine DATEI mit `gitdir:`-Zeiger; ohne gemountetes
  Elternrepo laeuft er ins Leere => `no leaks found` bei `0 commits scanned`, rc=0). Regel: die
  Push-Wache faehrt das lokale gitleaks; wird docker doch gebraucht, ist das Elternrepo zu
  mounten (`-v <super>:/super:ro,Z`, Scan-Ziel unter /super) und die COMMIT-ZAHL im Output ist
  PFLICHT-Nenner — 0 gescannte Commits = Pruefung nicht erfolgt, nie gruen.
- **Karten-/Zwischenergebnis-Sicherung SOFORT (/tmp-Rotation):** Werkzeug- und Agenten-Ausgaben
  unter `/tmp` bzw. Job-`tmp/` rotieren; belegter Verlust: die A15-Liste lag nur in
  `tmp/wisfvjd8z.output` (r4 D-11). Regel: jede Karte/Extraktion wird UNMITTELBAR nach
  Fertigstellung an einen persistenten Ort gesichert (`~/backups-workflow/` bzw. `docs/`,
  BU-additiv) und im Ledger mit dem persistenten Pfad referenziert — nie mit dem tmp-Pfad.
- **Einlese-Protokoll-Praxis (KON93-Einlese-Order):** vor jeder Konsolidierung/Synthese werden
  ALLE Material-Dateien VOLLSTAENDIG gelesen und je Datei mit einer Protokollzeile quittiert
  (Datei · Zeilen/Posten · Kernbefund). „Gelesen" ohne Protokollzeile zaehlt nicht; Karten ohne
  Einlese-Protokoll sind fuer die Synthese nicht zitierfaehig.
- **Gegenlese-Praxis = wiederkehrender Drift-Ausgleich (Owner 16.08.):** nach jeder groesseren
  KON-Serie werden die vier /goal-Referenzdokumente per Gegenlese-Karte abgeglichen (Form:
  LEBEND-ungedeckt · UEBERHOLT-ohne-Marker · WIDERSPRUCH ohne Marker · Verstaendnis-Kerne; je
  Befund Anker + Gegenprobe). Einbau IMMER additiv + datiert, Marker AM ORT; Ueberholtes aus
  Karten wird NIE als lebend eingetragen; neu gewinnt gegen alt. Muster: KON96/KON97 +
  Wellenplan §19.

**REGEL-KANDIDATEN v4.4 (Owner-gated — VORSCHLAG, NICHT in Kraft; aus den Lehren r1-r5):**
1. Jedes woertliche Owner-Zitat im REGELTEIL traegt einen GUELTIGKEITSVERMERK, nicht nur ein
   Entstehungsdatum (r1 Z.17604: datierte Momentaufnahmen altern lautlos).
2. V11-Umkehrung: eine Messung VOR der Aussage ist KEINE Bestaetigung — jeder uebernommene
   Zahlenwert braucht eine eigene Ist-Messung, bevor daraus ein Bau-Posten wird (r1 Z.17661).
3. NULLBEFUND-Doktrin: „X fehlt/ist nicht verdrahtet" wird erst mit der Gegenprobe „wer
   inkludiert/linkt/ruft X?" zur Aussage; ein Nullbefund in EINER Quelle ist kein Befund ueber
   die Sache (r4 D-08).
4. Ein Befund traegt sein ERHEBUNGSDATUM; wer ihn zur Handlung macht, misst ihn vorher gegen
   den heutigen HEAD (r4 D-07/REGEL-ZEILE 17).
5. Basis BENENNEN, nicht beziffern: eine SHA im Auftragstext ist eine Momentaufnahme; der
   Agent rechnet die Abzweigung selbst („eine zurueckgegebene Lead-Zahl ist ein Echo") (r5 A65).
6. Defekt-Doktrin-Abbruchgrenze: „zu gross" ist KEIN Haltegrund — „die Doktrin bricht" ist
   einer; dann Architektur-Entscheid vorlegen, nicht die Aufwandsschaetzung (r5 A66).
7. Eine WIEDERHOLTE Owner-Aussage wird nicht erneut quittiert, sondern gegen den eigenen
   Arbeitsgegenstand auf Abweichung geprueft (r5 A67).
8. „Ein Ledger-Satz ist kein Beleg": VOLLZOGEN zaehlt nur mit Code-/Commit-Stichprobe (r5 A58).

### 4.2 AENDERUNGSLOG-EINTRAG (einbaufertig, OHNE Versions-Bump)

- **B.3-NACHTRAG 16.08.2026 (KON97)** (2026-08-16, Diplomarbeit-Session, Owner-Auftrag
  *„konsolidiere die offenen Posten in die 4 /goal Referenzdokumente … Drift im /goal-Plan
  regelmaessig ausgleichen"*): B.3 additiv um vier Session-Verschaerfungen ergaenzt —
  (1) gitleaks auf prod1 lokal statt docker (Submodul-gitdir-Falle, Commit-Zahl =
  Pflicht-Nenner) · (2) Karten-Sicherung SOFORT wegen /tmp-Rotation · (3) Einlese-Protokoll-
  Pflicht vor jeder Konsolidierung · (4) Gegenlese-Praxis als wiederkehrender Drift-Ausgleich
  der vier /goal-Referenzdokumente. Dazu ein benannter Block **REGEL-KANDIDATEN v4.4**
  (8 Kandidaten, Owner-gated, nicht in Kraft). **Kein Versions-Bump; Teil A und Teil V
  unveraendert.** Schwester-Nachtraege gleichen Datums: GOAL-v8-Kopf-Nachtrag KON97 ·
  Wellenplan §19 · Designplan §12.

================================================================================================
## BILANZ

| Dokument | Nachtrag | Posten |
|---|---|---|
| GOAL v8 | Kopf-Nachtrag KON97 (6 Bloecke) + 7 Einzel-Marker M-1..M-7 | 13 |
| Wellenplan v2 | §19.1-19.7: Korb A 14 (+10 Zusatz) · Korb B 20 · Korb C 15 · Korb D 24 · | 73 Korb + |
|  | FJ-10+E-11+4 Auflagen · 12 Marker + 5 Explore + 1 Austragung + Owner-Fragen · | 25 Bau + 18 W + |
|  | 38 Ur-Ledger-Rueckkehrer | 38 R = 154 |
| Designplan-TDD | §12: T-12a..T-12e (Summen-Regel unangetastet) | 5 |
| ARBEITSWEISE | B.3-Nachtrag: 4 Verschaerfungen + 8 v4.4-Kandidaten + 1 Log-Eintrag | 13 |
