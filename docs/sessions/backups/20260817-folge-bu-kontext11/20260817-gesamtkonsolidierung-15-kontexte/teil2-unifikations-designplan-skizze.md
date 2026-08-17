# TEIL 2 — UNIFIKATIONS-DESIGNPLAN-SKIZZE "GEMEINSAME MODUL-STEUERUNG DER CEB"

(Basis fuer den von RF-A/KON108-02 verlangten Fable-max-Designplan. Leitsaetze aus der Owner-Runde: EIN Stack aus 3 Komponenten · Messgeraet = checkpoint_measure ueber w/ma/mi · Flaeche 3 je Naht zielverschieden · curve_fit NUR auf der CEB zur Laufzeit · Performance durch Abstraktion, +-3% je Parameter · GESAMMELT-Regel unverletzlich.)

## Module (je: konsumiert -> liefert · Stand · Traeger)

- **M0 STEUER-NAHT Planer<->CEB (S-10)**: konsumiert gefilterte XML-Fragmente + {stop_ram_oob, stop_user_kill} -> liefert Deltas/Status/Trace + OOB-Fertig-Signal; Sync-Barriere. Stand: NICHT GEBAUT. Traeger: S-10-Rahmen (KON50-03), W2-Design/W3-Bau.
- **M1 MESS-NAHT CEB<->Tier (Flaeche 3)**: konsumiert Signalfunktion -> liefert sparse-binary Messwerte-Stream nach Flush (Hol-Punkte, Arenen). Stand: ABI GEBAUT (IMessVisitor/MessEdge). Traeger: #20 (Vereinigung INTRA-Naht + Deckungs-Test).
- **M2 checkpoint_measure-KANALWERK (P-A)**: konsumiert Genus-Kaskade/MK + E(A)-Registrierung (FJ-2) + Ebenen-Flags/CEB-Gates (C-13.3, EIN Mechanismus) -> liefert Kanal-getaggte Roh-Traces in die Mess-Arena; Klammer-Default innerste, Arena-Auswertung fuehrt innere Kanal-Klammern auf aeussere zusammen (C-9-Erweiterung); w-PROFILER buendelt Genus-Kanaele uebers Last-Profil. Stand: Arenen gebaut (Politik-Nachzug), Kanalwerk NICHT. Traeger: #90 (neu, #53-Umfeld), 12W-Explore vor Bau.
- **M3 CEB-SERIEN-FAHRPLAN (Planer)**: konsumiert XML + S-19-Permutationsrechnung -> liefert Serien-CEBs (Messfuehler-Latenz-Differenz) + kalibrierte Rohwerte. Stand: Doktrin 08.08., Maschinerie teils System B/dormant. Traeger: #7/S-19 (Sa 22.-Mo 24.08.), Serien-Smoke in W3.
- **M4 KOMPONENTE 1 -- Funktions-Synthese (measurement_curve_loader)**: konsumiert Messwert-Tabellen (RAM, max Threads, Schwelle offen) + M5 + Tracing-Vorgeschichte (Zustands-Dimension) -> liefert Synthese-Funktionen je Parameterklasse x Tier x Zustand ALS BATCHES in Lager-Typ 3. Auf der VOLLEN CEB (abwaertskompatibel).
- **M5 KURVENMODELL-FACTORY**: konsumiert Rohpunkte -> liefert (auch mathematisch KOMPONIERTE) Modell-Instanzen + Guetemass; verify-sweep waehlt je Teilbereich die Synthese, die die Realitaet besser widerspiegelt; Default-Toleranz +-3% je Parameter; KEIN Bloat auf Kleinst-Messpunkte. Subsumiert die bestehenden AxisSpline/PiecewiseCurve-Formen (std-only-Frage offen).
- **M6 PARAMETER-FILTER-REGISTRY (#88/P-B)**: konsumiert Deep-Research alt (09.07.) + NEU -> liefert Filter-Katalog (Filter 1 = kuerzeste Gesamtzeit; impact-sortiert), Gewichtungs-DEFAULT an M7, XML-waehlbares Release-Kriterium (nach allen 3 Komponentenstufen) an Planer/#49.
- **M7 KOMPONENTE 2 -- curve_fit (auf CEB)**: konsumiert Typ-3-Bestaende + M6-Default + XML-Override -> liefert EINE Bereichs-Linie (Ranking-Parameter-Bewertungs-Schnitte) je Last-Profil; erkennt Optimal-Bereiche (deren ANZAHL = Dock-Zahl der kleinen Hybride, P-C).
- **M8 KOMPONENTE 3 -- best_binary_selector-B**: konsumiert Bereichs-Linie -> liefert Binary-Wahl je Last + Wechselkosten-Abwaegung (Anti-Flattern); Release-Vorschlag.
- **M9 HYBRID-LAUFZEIT (HY-C)**: konsumiert M7/M8-Artefakte + Typ-4-Loesungen + XML-init-Profile (P-D) -> laedt Optimal-Bereichs-Binaries in statisch dimensionierte Docks (P-C), MISST Wechsel-Penalty zur Laufzeit GEGEN (eigene Hybrid-Mess-Schicht), Lookahead ueber ma x w-Wahrscheinlichkeiten.
- **M10 LAGER-BESTAND 3+4 (#57/P-E)**: Factory-Erweiterung Par.62-B; Schluessel machine_id x Stempel/Fingerprint x XML-C14N; Batch-Schreibweg N2-Muster; Ergaenzungs-/Invalidierungs-Regel (Kernbestand bleibt); Verbund1-Skip je machine_id (R-3+V-10b).
- **M11 BATCH-PIPELINE-AUSDEHNUNG**: die 15-Stationen-Kette + Auswerte-Batches; bauen->messen->compare->release woertlich; GESAMMELT-Regel; volle CEB liest Staende der Serien-CEBs.
- **M12 XML-GRAMMATIK-SAMMELZUG (mit #18/#48/#57(6))**: publish-Sektion · Verbund-phases (B-2, bruch-gebunden) · Filter-Kriterium · Hybrid-Strategie-Profile · Markierungs-Grammatik · externe-Pruefling-Pfadangabe (#65-Naht) · profile_ref-ERROR (R-4).
- **M13 BEGRIFFS-ALIAS-REGISTRY (R-2)**: CT-Header; Erst-Eintraege node4, w/ma/mi-Aliasse, Verbund-Uebergang; Uebersetzen=CT-Fehler; Adapter=Paper-Ausnahme.
- **M14 PLANER-RANKING-AUSGABE (P-H-Haelfte)**: konsumiert Markierungen + M6-Kriterien + Lager-Stand -> Experiment-Ende-Report je markierte Achse x Parameter (default ALLE) mit Ranking-Position; iterative Tweak-Runden.

## Bau-Reihenfolge (Abhaengigkeit, nicht Geschmack)
M13-Skelett + M2-DESIGN zuerst (Begriffe + Kanal-IDs sind Fundament fuer alles Messende) -> M10-SCHEMA vor M4 (Batches brauchen Bestand-3-Schluessel) -> M5-Interface vor M4-Vollausbau -> M6-Katalog-Skelett vor M7 (Default-Quelle) -> M7 -> M8 -> M9. M12 sammelt ALLE Grammatik-Elemente in EINEM W2-Zug. M3 haengt an S-19. M0 unabhaengig, aber vor der Voll-Messkampagne.

## W-Zuordnung (F2 Fr 21.08. / Trigger Mi 26.08. / W2 Sa 22.-Di 25.08. / W4 07.-11.09.)
- **W1 (bis F2 Fr 21.08.)**: Unifikations-DESIGNPLAN (dieses Skelett -> Fable-max-Plan) + P-A-Explore-Start + #20-Praezisierung + mess/-S-Register-Nachtrag. IDENTITAETS-ENTSCHEIDE (Typ-3/4-Schluessel, Stempel-Farben-Mechanik, B-2-Scope) VOR Trigger Mi 26.08. ORDNEN -- Umbauten sind heute kostenlos, ab 26.08. teuer.
- **W2 (Sa 22.-Di 25.08., Landung Di 25.08.)**: M12-Grammatik + M10-Schema mit #18/#48/#57 · S-19 (#7) + T-15b (#13) · Ledger-#44/P-H-Bau (R-5) · M6-Katalog-Skelett (#88).
- **W3 (Generalprobe)**: M0-Bau-Rest + M3-Serien-Smoke.
- **W4 (07.-11.09.)**: M9/HY-C (P-C/P-D); #49-Staffelungs-Design VORHER (nach V7-Antwort).

## Offene Ein-Satz-Owner-Fragen (A2.3a-geprueft: nur was kein gefahrener Explore aufloest)
1. (GESTELLT, offen -- nicht doppeln) std-only-Spiegelung des best_binary_selector im Licht von RF-E: bleibt der Spiegel fuer super-Werkzeuge oder wird er Typ-3-Konsument?
2. (in #71-Vorlage einreihen) Auswerte-Phase: volle Thread-Zahl T oder T-4 (F7-Planer-Reserve)?
Alle uebrigen Kandidaten (D1-Farben-Konflikt, Verbund-Name fuer Stufe2_Hybrid) sind DESIGN-Vorschlaege am jeweiligen Fenster, keine Fragen -- NEIN-Probe bestanden nur fuer 1+2.

---
