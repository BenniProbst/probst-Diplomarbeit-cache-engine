# WIEDERAUFNAHME-REGISTER — "ES WIRD NIE ETWAS AUSGEBUCHT ODER VERSCHOBEN" (Owner 18.08. spaet)

> Owner-Order (verbatim-Kern): "Bitte sieh dir die Workflow fork genau an und analysiere die still
> vertagten Features, wir muessen sie fuer volle Funktionalitaet wieder mit aufnehmen und
> strategisch platzieren. Es wird NIE etwas ausgebucht oder verschoben." + Dauerregel desselben
> Tages: "NIE etwas kuerzen, gesamte Kette voll, ALLE Features; morgen mit mehr Kontingent
> multiple Strecken parallel."
> QUELLE: Fork gab-es-denn (18.08., Voll-Kontext-Erhebung) — 8 stille Kuerzungen (alle
> entdeckt+geheilt), 2 Prozess-Faelle, 6 Verdachtsfaelle, Abgrenzungsliste "deklariert".
> DIESES REGISTER ordnet JEDEM vertagten/verschobenen Feature einen Platz VOR der Abgabe zu.
> Kein Posten endet in einem Behaelter; W7 ist ab sofort KEIN Endlager mehr, sondern nur noch
> Nach-Abgabe-Kuer fuer Dinge, die der Owner AUSDRUECKLICH dorthin entschieden hat.
> Feinplatzierung (Stunden je Slot) folgt nach Audit- + #93-Ruecklauf; die POSTEN-ZUORDNUNG
> hier ist vollstaendig. Memory-Anker: feedback_nie_kuerzen_gesamte_kette_voll_alle_features.

## A. STILLE KUERZUNGEN (8) — Heilungs-/Traeger-Check

| Fall | Heilung | Traeger-Status |
|---|---|---|
| Selektiver Rebuild geloescht (ce 813c3232, 27.07.) | C-13 gebucht (Wellenplan 19.3) | 🔴 WAR NUR T-NEU-11 (Rest-Register, kein Board-Task) → **JETZT Task #97**, vor Kampagne Sa 29.08. |
| checkpoint_measure→W7 trotz Owner-KERN | zurueck als B4/System B | ✓ #24/B4 (W2) |
| F-07b Diagramme→W7 mit ERFUNDENER Autorisierung | UEBERHOLT-Marker ff64fe0e | 🔴 BAU-Traeger fehlte → **JETZT Task #98** (W4 mit ##60; Owner-KERN 06.08. 2D+3D SOTA). ZUSATZFUND: Wellenplan §5-Defizit-Arithmetik zaehlt F-07b NOCH als Deckungs-Streichung — die Rechnung ist um diesen Posten zu korrigieren (docs-Zug) |
| "W1 KOMPLETT" nur Straenge; HY-A2/A3 ungebaut | im #15-Bruch nachgebaut | ✓ (e285d316) |
| #17/g2 ungelandet | W1-V1 | ✓ #93 + Lande-Pflicht vor F2 |
| 06_evaluation_methodology still nicht eingebunden | #67: 8/8 abgedeckt, DEPRECATED-Kopf | ✓ (aus still → deklariert) |
| Audit-slice(0,14) + stille Limit-Filterung + Synthese-Dedup-Verlust | Voll-Umbau + Gates + R2 | ✓ (Gates verankert, Memory-Regel) |

## B. DEKLARIERTE VERSCHIEBUNGEN OHNE OWNER-WORT — WIEDER AUFGENOMMEN + PLATZIERT
(Die Order erfasst sie: "deklariert" schuetzt nicht mehr vor der Wiederaufnahme; die alten
Marker bleiben als Historie stehen, dieses Register setzt die NEUE Platzierung daneben.)

| Block | Umfang | NEUE Platzierung (strategisch, fristfest) |
|---|---|---|
| **Band B/W1** ("62 h geschlossen gestrichen", D-2-Marker; 22 Posten: AG-Concepts11/IsComposition/Noexcept, XL-L3/L5, ST-RankingTie/DriftBestwahl, PK-Folgeposten, AS-Katalog/ORG18/Aritaet/NameClean, LG-Kollision/NoThrow/CommitAtom/Zeilenlimit, PM-m3v2Spalten/Outcome/CTZweig/OffZwilling, MT-L9, PE-JobBindung/Startgate) | 62 h | **W2-Randslots Mo/Di 24./25.** (parallel zu S-12/S-13 als disjunkte Test-Straenge, Mehr-Kontingent-Parallelitaet) + **WE 22./23. nach S-19/T-15b-Kern** + Rest **W3-Batch-Pausen [lok]** (§3-W3 erlaubt lokale Arbeit ausdruecklich) |
| **Band B Rest** (37 weitere der 59) | ~104,5 h | **W3-Batch-Pausen [lok]** (5,75 Maschinentage Kampagne = die Maschine misst, die Session baut lokal ohne CI-Last — VEREINBAR mit "null CI-Last": [lok]-Klasse ohne Pipeline) + **W4 Mo-Mi** + **W4-Fangnetz Do/Fr** |
| **Band C** (5 Posten, 13 h) — Begruendungen TEILS UEBERHOLT | 13 h | PM-WinPCM: Windows-Runner sind seit #60 ONLINE (4/4) → **W2/W4 fahrbar** · PM-AmdL3 1-2: CAP_PERFMON = Talos-Lane #87 (Infra-gebunden, sobald v1.13.x) · MT-L8 + PM-PAPI + AG-PunktFixes → **W4** |
| **##40-Restbau** (T-06 KF-6/60, T-07 RAM-Spool, T-08 Dual-ccache, T-09, T-10, T-12 Cross-Genus, T-13/T-14 FK-Walk, W-03, W-08, A14, A10) | ~10-11 WT-Anteil | T-13/T-14 (Fehlerklassen!) = C-12-Pflicht **vor W3** (Wellenplan 19.3 fuehrt sie schon) · Cacheline-/Spool-Achsen (T-07/T-08) **vor dem Trigger Mi 26.08.** falls mengen-wirksam, sonst W2-Slots · Rest **W4** |
| **HY-Vollausbau** (Heuristik-Familie, Mehrfach-Dock>1, scharfe Eviction) | n. geschaetzt | Mehrfach-Dock = HY-B/W3-Design (MaxDocks-static_assert aus A2.5 ist der EHRLICHE Minimal-Pin, kein Verzicht) → **W3-Design + W4-Bau nach HY-C-Kurven** · Heuristik-Familie/Eviction **W4 nach HY-C** |
| **14 W7-Posten §13.3** (#29-Rest #30 #32 #34 #42 #44 #48 #50 #63 #64 #69 #71 #72 #26) + P/E-Core (#21) + IO-Vollausbau (#38a3) + §75-Pass + Record-and-Replay + PV-1 | gemischt | **W4/W5-Randslots, GEZAEHLT** — je Posten beim W2-Planungs-Schnitt (Di 25.) ein konkreter Slot; W5 traegt nur Nicht-Bau-Anteile (Doku/Registrierung); was OBJEKTIV nach der Abgabe liegen MUSS, braucht einen Owner-Satz (Kategorie C), sonst faellt nichts |
| **##15-EMITTER/TEMPLATE + ##24/A9-S5a** ("rutschfaehig") | klein | Rutsch-Klassifizierung AUFGEHOBEN → W2-Slot bzw. W4 |
| **Register-Vollautomation ##31 + D1c-Vollausbau** (Rueckfallstufen) | klein | Rueckfallstufen bleiben UNGEZOGEN (nur bei Riss); Vollformen = W2-W-Posten |

## C. OWNER-ENTSCHIEDENE VERSCHIEBUNGEN — Revision NUR per Owner-Satz (transparent gelistet,
## NICHT eigenmaechtig gekippt; A2.3a: je Zeile steht das Owner-Wort)

| Posten | Owner-Wort | Neubewertungs-Fakt (nur Meldung) |
|---|---|---|
| Vollmessung → Deckel (OV-4, F2-Vorlage "ja" empfohlen+angenommen) | Deckel-Doktrin + S-19 rechnet | physikalisch: >=143 Tage einthreadig — Deckel ist Mess-AUSWAHL, keine Feature-Kuerzung |
| prod2-Lane → Textkorrektur (OV-5(b) "ja" 09.08.) | "prod2 existiert nicht" (damals rc 2) | UEBERHOLT AM OBJEKT: prod2 ist seit #60 online (id=17, Gen-2-Kapazitaet 34,4 h gerechnet) — wenn die Order die pmc:intel-/P-E-Lane zurueckholen soll: EIN Owner-Satz genuegt, Bau-Platz W2/W3 existiert |
| Paper-Kopplung → nach Abgabe (OV-14 "ja" + LEDGER:11128 Ruecksprache) | Owner-Wort 17.08.-Runde | bleibt, ausser Owner dreht |
| Monolith-Split → W7/#88 ("beim Aufraeumen", Owner-B3) | woertlich | bleibt |
| checkpoint_measure (OV-2) | KON34: "muss gebaut werden" | BEREITS ZURUECK (B4) ✓ |
| Debug-Ergebnisse loeschen (KON29-01) | einzige Messdaten-Ausnahme | bleibt (kein Feature) |

## D. VERDACHTSFAELLE (6) — Aufloesung laeuft (Voll-Audit + #93), Ergebnis fliesst hierher
golden-Nachposten E-B-CRC/K1-avx512/telemetry-silent (juengere 19.1-Linie: E-B faehrt IM
#15-golden-Ereignis => Kandidat: VOR die Landung in den Bruch) · V-06 Lesart A (geweitete
Stempel-Pflicht vs. 2 Symbole) · B3 (W1-V2, Owner-Datum vor F2) · B1 (W1-Ende) · A1-Durchzug
9-vs-18 (#44-Rest, W1) · 23 Band-A-Testposten §4-W1 (Ist misst #93 Gruppe G).

## E. KAPAZITAETS-EHRLICHKEIT (Zahl, keine Streichung)
Wiederaufnahme-Volumen grob: 62 h (B/W1) + ~104,5 h (B-Rest) + 13 h (C) + ##40-Reste + W7-Liste
≈ **>200 h zusaetzlich** auf 19 Kalendertage bis T-3. Deckung per Owner-Entscheid: (1) "volles
Risiko" (§14-Praezedenz: Reserve null als Zahl, kein Veto), (2) Mehr-Kontingent-Parallelitaet ab
19.08. (6+ disjunkte Straenge; Bau-Slots-Deckel 3 bleibt), (3) [lok]-Klasse traegt W3 mit (die
Kampagne braucht das Blech, nicht die Session). Der Engpass bleibt EHRLICH: W2 traegt Trigger-
Pflichten ZUERST (S-19-Zahl, S-13-Buendel, VOLLBAU-GATE); Wiederaufnahme-Posten fuellen Slots,
verdraengen nie Trigger-Pflichten — Reihenfolge je Slot beim Di-25.-Schnitt, ALLE gezaehlt.

## F. SOFORT-VOLLZUEGE DIESES REGISTERS
Task #96 (Register-Vollzug + Feinplatzierung nach Audit/#93) · Task #97 (C-13+C-14 vor Kampagne)
· Task #98 (F-07b-Diagramm-Bau W4 + §5-Arithmetik-Korrektur) angelegt. Naechster Schritt: Audit-
Ruecklauf → Fix-Strecke 2 → #93 → Landung; die W2-Feinplatzierung (Di-25.-Schnitt) nimmt JEDEN
Posten dieses Registers namentlich auf.
