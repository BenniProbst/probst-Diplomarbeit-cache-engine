# KONFORMITAETS-REGISTER — Stand 09.08.2026

> **Auftrag:** Owner 09.08.: *„Du bist erst fertig, wenn die Realität dem Design des Goal v8 und
> all meinen Beschreibungen des session logs und den Planungs/Design Dokumenten vom Abend des
> 08.08.2026, und der letzten 10 Wochen Historien-Entwicklung bis zum 08.08. entspricht, wobei
> jedoch alle konfliktierenden Aussagen mit »neu gewinnt gegen alt« aufgelöst werden."*
>
> **Verfahren:** Strang 16 (`w7nstudfe`). Acht Partitionen entlang der Kettenstationen. Je
> Partition extrahiert Sonnet 5 max jede bindende Design-Aussage mit Zitat, Quelle, Datum,
> Autorität und der Frage *womit ließe sich das messen?*; danach misst Opus 5 max jede am Objekt
> in fünf Stufen: **ERFÜLLT · TEILWEISE · NUR_PAPIER · VERLETZT · NICHT_PRÜFBAR**. Ohne Beleg gilt
> NICHT_PRÜFBAR. Prüffrage für jedes ERFÜLLT: *was bricht, wenn ich es entferne?* — bricht nichts,
> ist es NUR_PAPIER.

---

## ⚠️ ZWEI EINSCHRÄNKUNGEN, DIE VOR JEDER ZAHL STEHEN MÜSSEN

**(1) Ein Werkzeugfehler von mir hat 75 % des Materials verschluckt.** Die Extraktion lieferte
**346** bindende Aussagen aus 7 Stationen. Die Synthese-Stufe bekam davon nur **87** — mein
Script kürzte die Übergabe mit `.slice(0, 150000)`, und die Stationen **s5-messen, s6-auswerten,
s7-release-hybrid, s8-veröffentlichen** fielen heraus. Der Register-Agent hat das **selbst
gemessen und mit Gegenprobe belegt**, statt so zu tun, als hätte er alles:

> „Gegenprobe gefahren: keines der 14 Roh-Transkripte trägt eine Register-ID
> (`grep -c -F 'XMLPL-KETTE-LAGER'` = 0 über alle Logs; Gegenprobe, dass grep greift:
> `measure_host_lane` = 3, `GOAL-V8` = 161 Treffer). **Alle Zahlen unten haben den Nenner 87,
> nicht 346.**"

**(2) Eine ganze Station ist im Register nie angekommen.** `s7-release-hybrid` ist in der
Extraktions-Stufe ausgefallen (`StructuredOutput retry cap exceeded`) — ausgerechnet **HYBRID**,
der Owner-KERN mit *„ALLES PFLICHT"*, der als 0 % gebaut gilt. Sie wird nachgeholt.

**Die Bilanz ist damit eine Untergrenze.** Und der Register-Agent benennt, warum sie sich beim
Nachholen eher verschlechtern wird: die Überraschungsliste zeigt, dass **die schwersten Befunde
in den ungemessenen Stationen liegen** — Hybrid 0 %, Auswertungs-Mathematik ohne Konsumenten,
CSV statt xlsx architektonisch.

---

Alle Stichproben sind gefahren. Ich habe jetzt: die exakte Auszählung des übergebenen Materials, die Objekt-Gegenproben (measure_host_lane, hybrid/, seg_ns=-1, Heuristik-Insel, mess_bestand_, csv/xlsx, Thesis-Submodul) und die seit der Registererhebung eingetretenen Zustandsänderungen (LAG-P1 committed, prt-art jetzt ausgecheckt). Damit schreibe ich die Bilanz.

# DAS KONFORMITAETS-REGISTER — BILANZ, STAND 09.08.2026 ~08:05 UTC

Mess-Anker: super HEAD `af82a611` (Arbeitsbaum sauber), ce-Gitlink `25fe4fbf`, Landungs-Checkout `/home/comdare/wt-super-landung`. Jede eigene Nachmessung traegt Pfad:Zeile; Register-Befunde werden ueber ihre ID referenziert.

---

## 0. MATERIALLAGE — der Nenner des Registers selbst (nicht verhandelbar, darum zuerst)

Der Auftrag nennt **346 bindende Aussagen aus 7 Stationen**. **Uebergeben wurden 87** — s1-xml-planer vollstaendig (40), s3-ceb vollstaendig (42), s4-bauen-lager-jobpool **abgeschnitten** (5 sichtbar; der fuenfte Eintrag `S4-MASCHINENSEITIG-FILTER` bricht mitten im Beleg ab, Luecke/Aufwand fehlen). **Die Stationen s5-messen, s6-auswerten, s7-release-hybrid, s8-veroeffentlichen (259 Aussagen, 75 %) liegen mir nicht vor.** Gegenprobe gefahren: keines der 14 Roh-Transkripte und keine Datei unter `/home/comdare/.claude/jobs/5a19728e/` traegt auch nur eine Register-ID (`grep -c -F 'XMLPL-KETTE-LAGER'` = 0 ueber alle Logs; Gegenprobe, dass grep greift: `measure_host_lane` = 3, `GOAL-V8` = 161 Treffer im Hauptlog). Das Register existiert ausschliesslich im Kontext des aufrufenden Leads.

**Konsequenz:** Alle Zahlen unten haben den Nenner 87, nicht 346. Die Bilanz ist eine **Untergrenze**: die Ueberraschungs- und Abloesungslisten belegen, dass die schwersten Befunde (Hybrid 0 %, Auswertungs-Mathematik 0 Konsumenten, CSV statt xlsx architektonisch, Thesis kennt die Soll-Saetze nicht) in den **ungemessenen** Stationen s5–s8 liegen. Und: **die 259 fehlenden Aussagen muessen als Datei persistiert werden** — solange sie nur im Lead-Kontext leben, ist „346" am 15.09. eine Behauptung ohne Deckung (Pruefung 4).

---

## 1. DIE KONFORMITAETS-BILANZ

| Station | Aussagen | ERFUELLT | TEILWEISE | NUR_PAPIER | VERLETZT | NICHT_PRUEFBAR | wirkungslos+widersprechend | Rest-Aufwand nominal |
|---|---|---|---|---|---|---|---|---|
| s1 XML+Planer | 40 | 9 (23 %) | 21 (53 %) | 8 (20 %) | 2 (5 %) | 0 | 10/40 = 25 % | 339 h |
| s3 CEB | 42 | 10 (24 %) | 23 (55 %) | 6 (14 %) | 2 (5 %) | 1 (2 %) | 8/42 = 19 % | 586 h |
| s4 BAUEN (angeschnitten) | 5 von ? | 1 | 3 | 0 | 1 (o. Aufwand) | 0 | 1/5 | 8,5 h + x |
| s5 MESSEN | **0 von ? uebergeben** | — | — | — | — | — | ungemessen | unbekannt |
| s6 AUSWERTEN | **0 uebergeben** | — | — | — | — | — | ungemessen | unbekannt |
| s7 RELEASE+HYBRID | **0 uebergeben** | — | — | — | — | — | ungemessen | unbekannt |
| s8 VEROEFFENTLICHEN | **0 uebergeben** | — | — | — | — | — | ungemessen | unbekannt |
| **Summe (uebergeben)** | **87** | **20 (23 %)** | **47 (54 %)** | **14 (16 %)** | **5 (6 %)** | **1 (1 %)** | **19/87 = 22 %** | **933,5 h + x** |

In fuenf Sekunden: **Nur 23 % der gemessenen Aussagen sind voll wirksam.** Mehr als jede fuenfte Aussage (22 %) ist wirkungslos deklariert oder aktiv widersprochen. Die Kette ist vorn (s1/s3) immerhin **vermessen** — hinten (s5–s8) ist sie **nicht einmal das**, und genau dort liegen laut Ueberraschungsliste die Totalausfaelle: Station 6 (Heuristik-Insel: 0 Produktions-Konsumenten, von mir nachgeprueft: 8 include-Treffer gesamt, 0 ausserhalb `tests/`), Station 7 (hybrid/ = nur README.md, nachgeprueft), Station 8 (csv=33 / xlsx=0 in `.gitlab-ci.yml` an HEAD af82a611, nachgeprueft). Je weiter hinten in der Kette, desto weniger Realitaet.

Fussnote zur Fairness: 4 der 20 ERFUELLT-Posten tragen trotzdem Aufwand (CEB-25: 3 h, CEB-30: 16 h, CEB-36: 1 h, S4-ZWEIBLECHE: 0,5 h) — „erfuellt" heisst nicht „aufwandsfrei"; diese 20,5 h stecken in der Nominalsumme.

---

## 2. DIE ZEHN SCHWERSTEN LUECKEN — sortiert nach den Kosten spaeten Auffallens

Sortierlogik: kontaminierte Messdaten (unheilbar) > verlorene Maschinentage (Frist frisst sie) > fehlende Abgabe-Substanz (heilbar bis 15.09.) > Betriebsrisiko.

1. **Leere Zell-Koordinaten machen den SKIP simd-blind** (XMLPL-BEIDE-MASCHINEN-BAU (a), XMLPL-62-CACHELOG). Kein Batch-Job setzt `COMDARE_GN_SIMD/OPT/MEASUREMENT_COMBO` → `ZellKoordinaten::empty()` → Dedup faellt auf die simd-blinde Alt-Form. **Seit LAG-P1 committed ist (HEAD af82a611: `COMDARE_BESTANDSLOG` = 8 Treffer, von mir nachgemessen) laeuft das Lager scharf — und der Dedup-Fehler mit ihm.** Faellt es spaet auf, hat eine Maschine Binaries uebersprungen, die sie nie gebaut hat: der golden-Bestand ist kontaminiert, alle bis dahin geernteten Werte verlieren die Deckung. **Fix ~2 h (Env-Export im Emitter verifizieren/setzen) — das billigste Paket gegen den teuersten Schaden. Vor dem ersten scharfen Lager-Lauf.**
2. **PMC ist identitaets-unsichtbar** (CEB-35, CEB-16, CEB-17): gleiche Mess-Achse, gleicher Schluessel, andere Zahlen — Owner-KERN F6 woertlich verletzt (Codebeleg mess_achsen_naht.hpp:538-548 im Register). Spaet auffallen heisst: Zahlen im PDF, deren Herkunft der Fingerprint nicht deckt, und ein **Byte-Ereignis** (10. Preimage-Glied = golden-Neubau), das jeden bis dahin gebauten Bestand invalidiert. Je spaeter, desto groesser der weggeworfene Bestand.
3. **macro und micro bauen byte-identische Tier-Objekte unter verschiedenen Schluesseln** (CEB-30, XMLPL-MESSACHSE-NEUBAU, XMLPL-6CEBS): das Lager fuehrt zwei Identitaeten fuer dasselbe Kompilat, und die Messfehler-Elimination (6 CEBs, Owner-Pflicht) ist **unmoeglich**, solange G3 kein eigenes Gate hat. Faellt das erst bei der Differenz-Arithmetik auf, ist der {macro}/{micro}-Bestand Neubau.
4. **Es gibt keine Wallclock im Wortsinn** (CEB-12): der gesamte Messpfad laeuft auf `steady_clock`, kein absoluter Zeitpunkt wird persistiert (Register: genau 2 `system_clock`-Treffer, beide ausserhalb der Messung). Die Owner-Kurven „ueber die Zeit, Basis f(0)" haben **keine Datenquelle**. Faellt das nach den Messkampagnen auf, sind die Kampagnen fuer die Zeitkurven-Kapitel wertlos → Neumessung in einer Frist, die keine hat. Minimalfix (Lauf-Nullpunkt persistieren) muss VOR die Kampagnen.
5. **Die Maschinen-Zuteilung ist hartkodiert im Emitter, nicht im Lager** (XMLPL-KETTE-LAGER, S4-JOBPOOL-DREI-REGELN; von mir am Objekt nachgelesen: experiment_plan_director.hpp:618-625, woertlich `if (simd_id == "avx2") return "intel"; // (2) Standard-Routing prod2 (schlaegt Combo)`). prod1 baut nie avx2, obwohl es kann; die Combo-Lane-Bindung ersetzt das Owner-Symmetrie-Prinzip durch eine nie protokollierte Gegen-Doktrin („JEDE Combo-Lane bleibt VOLLSTAENDIG auf EINER Maschine"). Spaet auffallen = die Kampagnen sind gelaufen, wie der Owner es NICHT entworfen hat, und ein Umbau danach bricht die Vergleichbarkeit der schon geernteten Lanen.
6. **Kein Mess-Deckel: `<measure_selection>` und `--check-size` existieren nicht** (XMLPL-BAU-MESS-GETRENNT, CEB-37, XMLPL-CHECKSIZE-POSTEN, XMLPL-OV4-DECKEL, CEB-31): die Messmenge ist weder ausdrueckbar noch berechenbar, OV-4 (ETA ≤ 4,5 Maschinentage) nicht entscheidbar, und der Owner-Widerspruch D-5 (Bau=Mess vs. Bau>Mess) ist offen. Wer ohne Deckel startet, verbrennt Maschinentage — der Fehler faellt als **verlorene Woche** auf, nicht als Bug. Blockiert durch Owner-Entscheid.
7. **Hybrid: Pflicht-Gattung, 0 % gebaut, vom Lager compile-hart verboten** (CEB-02, XMLPL-KETTE-8STATION, XMLPL-STUFEN-DEHNBAR; nachgeprueft: `hybrid/` enthaelt nur README.md; lager_pfad_grammatik.hpp:527 wirft auf den Token). Station 7 der Owner-Kette existiert nirgends: kein Typ, kein Parser, keine CI-Stage. Wer spaet anfaengt, trifft den static_assert und die ungeklaerten K1/K2/K4/K5 — ab einem Punkt ist ein Pflichtteil der Arbeit schlicht nicht mehr schaffbar. Keine Datenkontamination, darum hinter den Mess-Luecken.
8. **Die gesamte Auswertungs-Mathematik ist eine unangeschlossene Insel** (CEB-32, CEB-33 + Ueberraschungen; nachgeprueft: `#include "heuristik/` = 8 Treffer, 0 ausserhalb tests; seg_ns wird in allen vier Genus-Sammlern hart auf −1 geschrieben, set_tier_v2.hpp:136 / sequence_tier_v2.hpp:125 / adapter_tier_v2.hpp:118 / view_tier_v2.hpp:96). Break-Even, Spline, Cluster: gebaut, getestet, nie aufgerufen; dazu ~2.400 Zeilen testgruener, unerreichbarer Lager-/xlsx-Code. Faellt es spaet auf, liegen Messwerte da und nichts rechnet — Kapitel 5 ohne Ergebnisse. Heilbar ohne Neumessung, darum Rang 8.
9. **CSV ist architektonisch die Ausgabe** (Ueberraschungen + Abloesung S5-XLSX-NUR; nachgemessen an HEAD af82a611: csv=33, xlsx=0 in `.gitlab-ci.yml`; zwei Stationen heissen `03_binary_to_csv`/`04_csv_to_latex`; die Thesis zementiert CSV in 06_evaluation_methodology.tex:46-48). Der Owner hat es „in der letzten Stunde schon 7 Mal geschrieben". Spaet auffallen = Umbau des kompletten Ausgabepfads unter maximalem Zeitdruck plus Thesis-Textpflicht.
10. **Der ETA-Takeover kann nie feuern** (XMLPL-62-BATCH4096 + Ueberraschung: `eta_s` hat vor `mark_done` keinen Produzenten — der 1,5×ETA-Zweig ist strukturell tot, es urteilt nur die 30-Minuten-pro-forma-Frist). Faellt genau dann auf, wenn eine Maschine mitten in der Messkampagne wirklich stirbt: ein Mehr-Stunden-Batch liegt still, waehrend die Frist laeuft. Dazu fehlt der Owner-benannte Takeover-Test als CI-Probe.

---

## 3. NUR_PAPIER — deklariert und wirkungslos (der gefaehrlichste Bestand)

**14 von 87 (16 %), zusammen 262 h nominal.** Jede Zaehlung, die Deklarationen zaehlt, fuehrt diese 14 als erledigt:

| ID | Kern der toten Deklaration | h |
|---|---|---|
| XMLPL-POSTV3-R1 | .so-Dock-Vertrag: POD gebaut, `[DEPRECATED]`, keine Live-Call-Site | 24 |
| XMLPL-BAU-MESS-GETRENNT | `<measure_selection>`: 0 Code-Treffer, lebt nur in Plaenen | 14 |
| XMLPL-CHECKSIZE-POSTEN | `--check-size`: 0 eigene Treffer, W1-verbindlich | 16 |
| XMLPL-OV4-DECKEL | 4,5-Maschinentage-Deckel: kein Ausdrucksmittel, kein Rechner | 0* |
| XMLPL-CHECKSIZE-DESIGN | Groesse-Planer/Dauer-CEB-Naht: nur Design-Dokument | 8 |
| XMLPL-BAUMENGE-0808 | Bau>Mess: nicht ausdrueckbar, Entscheid D-5 offen | 0* |
| XMLPL-PAPER-XML | 0 von 33 Papern hat ein Experiment-XML | 20 |
| XMLPL-6CEBS | 6 CEB-Permutationen: nur 2 Kompilat-Zustaende herstellbar, keine Differenz-Arithmetik | 20 |
| CEB-13 | 4. Observer-Layer: Wire-Form da, niemand fuellt sie | 32 |
| CEB-18 | P/E-Core-Doppelmessung: Probe+Aktuator da, nie verdrahtet | 24 |
| CEB-29 | 6-CEB-Messfehler-Elimination: Zahl selbst offen (D-3) | 24 |
| CEB-31 | check-size-Dauer auf der CEB: Entwurf komplett, Bau 0 | 24 |
| CEB-32 | Break-Even in CEB-RAM: Mathematik-Insel ohne Aufrufer | 32 |
| CEB-34 | Release=Rekonstruktion: nur Registry-Zeile, kein Kommando | 24 |

*\*0 h, weil der Aufwand vollstaendig in anderen Posten steckt — die Deduplizierung in Abschnitt 5 ist Pflicht, sonst zaehlt man check-size dreifach (16+8+24 h fuer EIN Werkzeug).*

Die zwei giftigsten Formen darin: **(a)** das XSD, das drei Pfade ERZWINGT, die nirgends Schreibziel sind (XMLPL-XML-EIN-PFAD, formal VERLETZT, aber dieselbe Klasse: sieht aus wie Steuerung, laesst sich nicht mal weglassen); **(b)** Deklarations-Defines ohne Leser (macro/micro), die **verschiedene Schluessel auf gleichen Bytes** erzeugen — Papier, das aktiv falsche Identitaeten stiftet. Dazu gehoert als Klasse (s5/s6-Territorium, ungezaehlt): Heuristik-Insel, `hardware_probe_factory` (634 Z., 0 Aufrufer), Lager-Baum-Writer/ErgebnisMappe (~2.400 Z. testgruen unerreichbar) — **testgruen ist hier ein Tarnanstrich: die CI faehrt 431 Tests ueber Code, den der Betrieb nie erreicht.**

---

## 4. VERLETZT — wo die Realitaet einer Festlegung aktiv widerspricht (5 von 87)

Je Stelle: **Regression oder unerkannte Abloesung?**

1. **XMLPL-KETTE-LAGER** (Zuteilung im Emitter statt Lager): **stille Lead-Abloesung, die durch juengeres Owner-Wort zur Regression geworden ist.** Der Code begruendet die Gegen-Doktrin ausfuehrlich (Vergleichbarkeit je Combo-Lane, F-4-Aufloesung — von mir nachgelesen, :610-625), sie wurde aber nie als Abloesung protokolliert, und der Owner hat das Lager-Prinzip am 09.08. erneut gesetzt (Quelle im Register: session-log :21964). Fehlende Protokollzeile AUF BEIDEN SEITEN; nach „neu schlaegt alt" gilt das Lager → Umbau faellig, plus eine Ledger-Zeile, die den Vergleichbarkeits-Einwand des Codes als offene Owner-Frage festhaelt (er ist sachlich nicht dumm: Cross-Lane-Overhead ist plattform-konfundiert).
2. **XMLPL-XML-EIN-PFAD** (drei XSD-Pflichtpfade statt ein Ziel-Ordner, keiner benutzt): **Regression durch stehengebliebenen Altbestand** — §16.1-C2 (16.07.) wurde nie umgesetzt, keine Abloesung auffindbar. Der Ledger kennt die Luecke selbst (:2371 „build->ziel-Copy fehlt heute").
3. **CEB-01-IDENTITAET** (zwei Binaries beanspruchen die CEB-Rolle): **unerkannte Abloesung.** Der W1-Rollen-Schnitt (§60-R3) hat die CEB-Rolle faktisch zu `comdare-messung-driver` gemacht (CI nennt sie 19x, den Alt-Wrapper 0x); das Owner-Wort vom 05.08. nennt `apps/cache_engine_builder`. Keine Code-Regression — eine **fehlende Protokollzeile plus ein faelliger Owner-Entscheid A/B** (Binary umziehen vs. Begriff umschreiben).
4. **CEB-37-XML-BAU-MESSUNG-GETRENNT**: **Regression im Owner-Wortsinn („sonst Regression"), verschraenkt mit einer fehlenden Protokollzeile** — der Owner-Widerspruch D-5 (07.08. Bau=Mess vs. 08.08. Bau>Mess) ist unaufgeloest; der Validator kann vor dem Entscheid nicht gebaut werden, weil D-5 die Richtung der Teilmengen-Garantie bestimmt. Erst Protokoll, dann Bau.
5. **S4-MASCHINENSEITIG-FILTER** (im uebergebenen Material abgeschnitten; Stand VERLETZT lesbar, Beleg/Luecke fehlen): nach der Beleglage der Nachbar-Eintraege (XMLPL-62-UNIVERSALITAET: `host_supports_simd` als „ANNOTATION, kein Filter"; Lane-Pinning als verbotene Vorfilterung) eine **Regression** gegen §62-A (Warnung statt Vorfilter, 21.07., am 09.08. bekraeftigt). **Der Eintrag muss vollstaendig nachgeliefert werden**, bevor ein Bau-Paket daraus wird.

---

## 5. DER REST-BACKLOG bis 15.09. — und die ehrliche Rechnung

**Nominal (alle aufwand_h der 87 Aussagen): 933,5 h** (s1: 339, s3: 586, s4 sichtbar: 8,5) **plus x** (ein abgeschnittener s4-Eintrag, ganz s5–s8).

**Das Register zaehlt mehrfach.** Die grossen Ueberlappungs-Cluster, dedupliziert:

| Cluster (EIN Bau) | nominal | real | Ersparnis |
|---|---|---|---|
| check-size (XMLPL-CHECKSIZE-POSTEN+DESIGN, CEB-31) | 48 | ~24 | 24 |
| measure_selection/Bau-Mess-Trennung (BAU-MESS-GETRENNT, MESS-KERN, CEB-37) | 38 | ~14 | 24 |
| G3-Gate + 6-CEBs + Differenz (6CEBS, CEB-29, CEB-30, MESSACHSE-NEUBAU) | 70 | ~30 | 40 |
| Hybrid Station 7 (CEB-02, STUFEN-DEHNBAR, Teil KETTE-8STATION) | ~90 | ~55 | 35 |
| Lane→Lager/Job-Pool (KETTE-LAGER, S4-JOBPOOL, Teil 62-CACHELOG, BEIDE-MASCHINEN) | 42 | ~24 | 18 |
| PMC-Identitaet (CEB-17, Teil CEB-16, CEB-35) | 40 | ~20 | 20 |
| Messwert-Genus-Host (62-REPLAY; ce-Seite durch LAG-P2 inzwischen geliefert) | 8 | ~4 | 4 |
| **Dedupliziert gesamt** | | | **~165** |

**Realer Backlog der 87 gemessenen Aussagen: ~770 h.**

**Zeitbudget:** Heute 09.08., Abgabe 15.09. = **37 Kalendertage**; Liefertakte 14.08. (T+5), 21.08. (T+12), 28.08. (T+19), 04.09. (T+26), 11.09. (T+33). Netto-Baukapazitaet bei realistischen 12 h/Tag (Lead+Agenten, abzueglich Explore-Pflicht je Welle UND Strang, 5 Pruefungen, TDD-Vertrag, Reviews, main-FF, Betriebsstoerungen wie das aktuelle GitLab-500): **~440 h**; selbst optimistische 16 h/Tag ergeben **~590 h**.

**Es passt nicht: ~770 h Bedarf gegen 440–590 h Budget = Fehlbetrag 180–330 h — und das deckt nur die 25 % vermessenen Aussagen.** Die ungemessenen 75 % enthalten nachweislich grosse Bauten (xlsx-Gesamtumbau: heute 0 xlsx-Treffer in der CI; Auswertungs-Anschluss; Thesis-Nachzug: der lebende Text kennt acht Stationen, vier Modi, sechs CEBs, PMC-je-Kernklasse und den vierten Observer-Layer nicht). Ein Plan, der das nicht sagt, waere schlimmer als keiner.

**Was zuerst fallen muesste** (Entscheidungsvorlage — jede Zeile braucht Owner-GO, mehrere Posten sind Owner-Pflichten; die Liste nimmt bewusst NICHTS aus der Datenintegritaets-Klasse):

| Streichung/Minimalform (→ nach Abgabe) | Entlastung |
|---|---|
| CEB-27 Arbeitsmodus (Hot-Switching im RAM) + Vollzug Compare-D2 auf Minimalform | 60 → ~20: **−40** |
| CEB-43 + XMLPL-POSTV3-R1 .so-/<modules>-Schnitt (Textemission laeuft) | **−64** |
| CEB-12 Wallclock-Vollausbau → nur absoluter Nullpunkt + eine Checkpoint-Ebene | 40 → 12: **−28** |
| CEB-34 Release-Rekonstruktion | **−24** |
| CEB-18 P/E-Core → nur prod2-Probe | 24 → 8: **−16** |
| CEB-20 L2/Kohaerenz → nur L2 je eine RAW-Zeile pro µArch | 20 → 8: **−12** |
| XMLPL-PAPER-XML+PERMUTATION → 3 Referenz-Paper statt Generator fuer 33 | 32 → 10: **−22** |
| XMLPL-COMPILER-UNTERACHSEN Toolchain-Permutation | **−12** |
| CEB-19 Pinning-Kette → Resolver nur core_class | 16 → 6: **−10** |
| **Summe Entlastung** | **~228 h** |

Damit: ~770 − 228 ≈ **~540 h Pflichtkern** — an der Obergrenze des Budgets, **ohne** s5–s8-Neufunde und **nur**, wenn die blockierenden Entscheide **bis Mi 12.08.** fallen: D-3 (6 vs. 8 vs. 4/5 CEB-Varianten), D-5 (Bau vs. Mess-Menge), K1/K2/K4/K5 (Hybrid), PMC-als-Preimage-Glied (Byte-Ereignis!), CEB-Identitaet A/B, CEB-38-Frage (CEB-Aenderung=Vollrebuild ja/nein), Wallclock-Schichtzuordnung (CEB-11), std::variant-Fehlerklassen-Ausnahme (CEB-22). **Jede Woche Entscheid-Verzug frisst einen Puffer, den es nicht gibt.**

Bau-Reihenfolge nach Schadenslogik (aus Abschnitt 2): zuerst die Datenintegritaets-Trias (Zell-Env ~2 h, PMC-Glied ~12 h, G3-Gate ~16 h ≈ **30 h, verhindert die unheilbare Klasse**), dann Mess-Deckel (~38 h), dann Lane→Lager (~24 h), dann Zeit-Nullpunkt (~12 h), dann Auswertungs-Anschluss (~32 h), dann xlsx-Durchstich (s5/s8), dann Hybrid-Minimal (~55 h), Rest nach Wellenplan.

---

## 6. WAS NICHT PRUEFBAR IST — und wie man es pruefbar macht

1. **CEB-41 buildsystem.xml-Hands-off** (einziger formaler NICHT_PRUEFBAR-Eintrag): die Datei existiert in keinem Repo — „unangetastet" ist trivial wahr, als Zusage leer. **Pruefbar machen:** Owner-Klaerpunkt, ob die Direktive vom 07.07. fortgilt; wenn ja, eine CI-Pfad-Wache („Diplomarbeits-Commits duerfen `**/buildsystem.xml` nicht anfassen") — dann erzwingt etwas das Halten, statt dass Abwesenheit es simuliert.
2. **Die Betriebsbeweis-Klasse** — Aussagen, deren Mechanik belegt, deren Betrieb aber nie beobachtet wurde: SKIP-Doktrin (XMLPL-FINGERPRINT: nie ein „zweiter Lauf = 0 neue Binaries, N SKIPs" gefahren), ETA-Takeover (XMLPL-62-BATCH4096: kein Test mit kuenstlich verzoegertem Batch), minio-Objekt-Entstehung (XMLPL-62-CACHELOG: die neue Wache prueft die Log-AUSSAGE, nicht das Objekt; LAG-P1-Restabnahme ohnehin durch GitLab-500 blockiert). **Pruefbar machen: je EINE CI-Probe** — Doppellauf-Probe, Takeover-Probe mit verzoegertem Update, `object_stat` gegen minio nach echtem Lauf. Das ist die woertliche Antwort auf Pruefung 4: **nur eine Wache in der CI erzwingt das Halten; alles andere ist am 15.09. eine Behauptung.**
3. **„Zwei echte Runner existieren"** (S4-ZWEIBLECHE): von diesem Host aus nicht messbar (kein GitLab-Zugriff, Cluster read-only, GitLab liefert aktuell 500). **Pruefbar machen:** ein Job-Artefakt mit `hostname`-Beweis von prod2 oder eine Runner-Listen-Abfrage vom Cluster-Host; Register-Anker generell auf **Job-Namen statt Zeilennummern** umstellen (das Register hat sich selbst zweimal bei gewanderten Zeilen ertappt).
4. **Der abgeschnittene S4-Eintrag und die 259 nicht uebergebenen Aussagen**: nicht bewertbar, weil nicht vorhanden — das ist ein Unterschied zu „nicht pruefbar". **Pruefbar machen: die Stations-Register s4(voll)/s5/s6/s7/s8 als Datei persistieren** (Vorschlag: `docs/plaene/20260809-KONFORMITAETS-REGISTER-346.json` + je Eintrag Uhrzeit-Anker). Ohne das hat die Definition von „fertig" selbst keinen pruefbaren Traeger.
5. **Die Thesis als hoechste Autoritaet ist im Landungs-Checkout leer** (nachgeprueft: `thesis/diplomarbeit/` = leeres Submodul; der lebende Text liegt in `/home/comdare/wt-thesis-nachzug`). Jede „THESIS zuerst"-Pruefung misst hier gegen nichts. **Pruefbar machen:** Submodul initialisieren oder den Register-Anker offiziell auf wt-thesis-nachzug umstellen — und die zwei bekannten Thesis-Gegensaetze (CSV in 06_evaluation_methodology.tex:46-48; Sieben-Phasen statt acht Stationen in 04_concept_architecture.tex:303-311) als P-1-Textpflichten fuehren.

---

## 7. ZUSTANDSAENDERUNGEN SEIT DER REGISTER-ERHEBUNG (das Register altert in Stunden)

Von mir am Objekt nachgemessen, 09.08. ~08:02–08:08 UTC:

- **LAG-P1 ist inzwischen COMMITTET**: super HEAD af82a611, Arbeitsbaum **sauber**, `COMDARE_BESTANDSLOG` = 8 Treffer in `.gitlab-ci.yml`, `ci/bestandslog_wache.sh` + `ci/comdare_bestandslog_activation.sh` getrackt. Die Register-Ueberraschung „alles UNCOMMITTED" ist ueberholt — **und Luecke Nr. 1 (simd-blinder Dedup) ist damit von latent auf akut gewechselt.**
- **Das prt-art-Submodul ist im Landungs-Checkout jetzt VOLL ausgecheckt** (`Code/external/comdare-prt-art/prt_art/algorithm_profiles/prt_art_axis_registry.xml` vorhanden). Die Ueberraschung „leer in 4/4 Worktrees" gilt hier nicht mehr; der bisher ungepruefte `comdare_experiment`-Validierungszweig ist jetzt pruefBAR — die Probe steht aus.
- **LAG-P2 (Messwert-Genus)**: ce-seitig auf wt-ce-xml gelandet, aber `grep -c -F 'mess_bestand_' Code/02_messung_driver/main.cpp` = **0** — die super-Host-Belegung fehlt weiter (deckt sich mit Task #23 und state.json „host wiring incomplete"). Im Landungs-Checkout bleibt das Messwert-Genus tot.
- **LAG-P4-Kornwache weiter nicht im gepinnten ce** (Gitlink 25fe4fbf; die drei static_asserts liegen nur auf wt-ce-xml 8cbf83d5). Der ce-Stand in super haengt laut Task #25 **98 Commits** zurueck — bis zum Gitlink-Bump ist ein Teil der „gebauten" Wachen im Bau-Stand unwirksam.
- csv=33 / xlsx=0 in der CI-Datei: unveraendert; der Sammler-Fix (d7b779f7) aendert das Suchmuster im Skript, nicht den Erzeugungspfad.

**Empfehlung aus der Alterung:** Das Register braucht Uhrzeit-Anker je Beleg und eine persistierte, versionierte Traeger-Datei — sonst misst jeder Nachrechner gegen einen anderen Baum, und die Bilanz zerfaellt in Anekdoten.

---

### SCHLUSSSATZ OHNE BESCHOENIGUNG

Von 87 vermessenen Aussagen sind 20 voll wirksam (23 %), 19 wirkungslos oder aktiv widersprochen (22 %); 259 von 346 Aussagen sind ueberhaupt nicht vermessen und nirgends persistiert. Der deduplizierte Rest-Backlog allein der vermessenen Aussagen (~770 h) uebersteigt das realistische Restbudget (440–590 h) um 180–330 h. **„Alle Wellen am Stueck bis 15.09." ist zum heutigen Stand nur mit der 228-h-Streichliste, mit Owner-Entscheiden bis 12.08. und ohne neue Grossfunde in s5–s8 rechnerisch haltbar — und die teuersten Risiken (simd-blinder SKIP, PMC-Identitaet, macro/micro-Doppelidentitaet, fehlende Zeitachse) muessen VOR der ersten scharfen Messkampagne geschlossen sein, weil sie die einzige unheilbare Schadensklasse tragen: kontaminierte Messdaten.**