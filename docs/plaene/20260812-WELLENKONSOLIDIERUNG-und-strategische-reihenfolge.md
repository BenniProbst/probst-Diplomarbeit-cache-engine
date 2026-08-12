# WELLENKONSOLIDIERUNG und strategische Reihenfolge — 12.08.2026

**Datei:** `docs/plaene/20260812-WELLENKONSOLIDIERUNG-und-strategische-reihenfolge.md`
**Anlass:** KON19-00 (Owner): die vier /goal-Dokumente (GOAL-v8-Dossier · Wellenplan v2 · DESIGNPLAN-tdd · ARBEITSWEISE-GESAMT-DOKTRIN) werden **Haupt-Referenz** — alle späteren Planungsdokumente werden **gegen sie** gemessen. Nichts wird gelöscht: Original bleibt stehen, Überholtes trägt datierte Marker (Hausdoktrin). **Owner-Merkauftrag 12.08.:** System-A/B-Konflikt (KON34) mit B1–B5 gehört in jede Durchführungs-Planung.
**KON37-09-Auflage vollzogen:** dieses Dokument ist gegen **KON37 (acht Owner-Antworten F-A…F-H) und KON38 (Stempel = Fable 5 max)** abgeglichen, Ledger Z.19–250 am Objekt gegengelesen. Review-Stand: 2× TRAEGT_MIT_FIXES, alle 22 Fixes eingearbeitet.
**Fakten-Quelle bleibt der Ledger:** „LEDGER-KONSOLIDIERUNG IV" (Kapitel A–M inkl. ERGÄNZT-Blöcke) + KON24–KON38. Owner-Wort schlägt alles · Neueres schlägt Älteres.

---

## TEIL A — DIE VIER REFERENZ-NACHTRÄGE (finale, einbaufertige Fassung)

### A.1 GOAL-v8-Dossier — Kopf-Nachtrag

<!-- EINFUEGEN in 20260808-GOAL-V8-DOSSIER-alle-wellen-am-stueck-bis-abgabe.md direkt nach Z.7 "---", vor "## VERSIONSHISTORIE" -->

## REFERENZ-STAND 12.08.2026 — KOPF-NACHTRAG (KON19-00)

> **Owner-Auftrag KON19-00 (12.08.):** dieses Dossier ist — mit Wellenplan v2, DESIGNPLAN-tdd und ARBEITSWEISE-GESAMT-DOKTRIN — **Haupt-Referenzdokument**; spätere Planungsdokumente werden **gegen diese vier gemessen**, nicht umgekehrt. Nichts wird gelöscht: Originaltext bleibt, Überholtes trägt datierte Marker an der Stelle selbst.
> **Fakten-Quelle für den lebenden Stand:** Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`, Abschnitt **„LEDGER-KONSOLIDIERUNG IV"** (A–M inkl. ERGÄNZT) + **KON24–KON38**. Bei Widerspruch: **Owner-Wort schlägt alles · Neueres schlägt Älteres.** Dieses Dossier bleibt Stand 08.08. + datierte Nachträge; es **verweist** auf den Ledger, es dupliziert ihn nicht.

**A. Sach- und Zahlen-Korrekturen** (Original bleibt stehen; Marker an den Stellen selbst):

| Stelle | ALT (08.08.) | GILT (12.08.) | Quelle |
|---|---|---|---|
| VI.1(a) | Kette = 4 lineare Stufen | jede Stufe emittiert die nächste über EIN zentrales **BAU-MODUL** = C++23-Planer-Bibliothek (Builder); NUR der Planer wird direkt kompiliert; **Tiefe 3**, Tier und Hybrid **sequentiell auf derselben Stufe** (erst Tier); **Träger-Rakete**: gezündet vorwärts, **gebaut rückwärts**; **Emission fertig erst, wenn CEBs+Tier+Hybrid IM LAGER sind**. Die **ORT-Reihenfolge der vier Träger gilt unverändert** (s. C) | KON16-03/-04 · KON17-01/-02 · KON18-01 · KON25-08 — Ledger-IV/B |
| VI.2 Titel | „0 % gebaut" | „0 % **ANGESCHLOSSEN**": `hybrid/` trägt 4 Header/943 Z. + 1802 Z. Vorarbeit, 0 Produktions-Konsumenten | Ledger:10813 (+~197) · KON9-02 |
| VI.2 | Gattung/Genus als schlichte Klassifikation | E-1-final 09.08. = **ZWEI Ebenen GEMEINSAM**: `AnatomyGattung::HeuristikAdapter=3` (**4. Gattung**, KEINE Dock-Gattung; `ce anatomy_base.hpp:53-92`, HY-A1) **+** `AnatomyGenus::FunctionInterfaceReroute=5` (**Genus sechswertig**; `:131-169`) + eigene `gattung_of()`; `genus()` einer Hybrid-Binary liefert NIE den Reroute-Wert (**Pass-through, Weg C**). Bauplan = **14 Entscheide** E-1…E-10/K1/K2/K5 inkl. Fristen-Blocker vor jedem Hybrid-Bau | Ledger:10813-10886 (+~197) |
| VI.2 | „drei Mess-Ebenen auf vier erweitert, dazwischengeschoben" | **PRÄZISIERT** (nicht verworfen): das Ebenen-Zählmodell ist überholt — **MESS-NENNER = 32** aus 5 unabhängigen Schaltern (Tier Micro/Macro 2×2 · Hybrid 2×2 · CEB-Wallclock 2); die **eigene Hybrid-Mess-Schicht HÄLT** (KON36-01 zitiert GO-3 als Beleg; B3 baut sie). Je Stufe ein **Subset der 3** Einrichtungen; KON25-03-Zuordnung = SOLL-Belegung, kein Typ-Verbot (KON37-03) | KON25-03 · KON34-03 · KON37-03 — Ledger-IV/E |
| VI.5 | Drift + „bis zu 5 Wiederholungen" als EINE Regel | getrennt: **T-15a** Kampagnen-Neustart bei Drift · **T-15b** Retry-Klammer: Build **UND** Messung dürfen **JE 5-mal** scheitern (nicht 1+5); Erfolg = 3 Wiederholungen je Parameter+Binary, **alle 3 Werte EINZELN persistiert** (KF-10, nie gemittelt); einzige Soft-Ausnahme fehlende Messeinrichtung (PMC) → Warnung in xlsx. 🔴 IST: die 5 liegt FALSCH auf der Drift-Achse (`ce 4cd1ab91`), Fix offen | KON26-04 · KON28-02 · **KON37-06** — Ledger-IV/E |
| IX D2 | „offen" ohne Lösungspfad | ce hat GENAU EINEN roten Job = `test:coverage-guard` (stempelfremder ISA/Host-Grund); Fix-Reihenfolge bindend **erst F1, dann F2** *(F1 = Operanden vergleichbar machen, F2 = `when:always` — **Guard-interne Schritte, NICHT die Fristen F1/F2**; Ledger-IV/J)* | KON8-11 · KON33-02 |
| IX D5 | „offen" | **TEILS**: 3/5 erledigt (2 kanonisch + D5-1 gelandet, `ce c98b4b95`); offen nur D5-2 (Rest 2) + D5-4 | Ledger:11368-11433 (+~197) |
| I.3 / IX | Zeilenanker :1097/:1194 · :1841 · „47/53" | alle gewandert (12.08.: :1810/:2038 · :2736/:2751 · super allein 38/41, Datei 2768 Z.) — **bei Zitat neu zählen; Anker über Symbol/Commit/KON**, nie Zeilennummer | Ledger-IV/L-6 |

**B. Seit 08.08. neu und tragend** — hier fehlend, gilt über den Ledger:

* **STEMPEL als Hauptstrang**: 5 Rollen (durchgesetzt 2) · 3 Flächen (Fläche 3 = measurement-Durchstich, damit Gattung+Genus-Interfaces unverändert bleiben) · 🔴 X.Y.Z-Bump-Pflicht (Änderung ohne Bump ⇒ kein Neubau ⇒ schneller UND falsch) → Ledger-IV/C. **KON38: Stempel-Strecke fährt in ALLEN Workflow-Teilen Fable 5 max.**
* **Zwei Mess-Architekturen**: System A LIVE (#ifdef-Gates) / System B DORMANT (17 Dateien, 0 Produktionsaufrufer). **B1–B5** (Owner-Merkauftrag 12.08.: in jede Durchführungs-Planung), präzisiert durch KON37-01/-02/-03 → Ledger-IV/E · Wellenplan §17.3.
* **STUFE ≠ PHASE ≠ PRÜFLING** — PRÜFLING = Mess-Unter-Achse des Planers zur Laufzeit; `MergeStrategy`-Werte SIND die Verbund-Varianten → Ledger-IV/F. Teil VII nutzt „Phase" nur untechnisch.
* **OD-7**: HEAVY-Deckel **24→16**; `--debug`-Zwei-Stufen-Betrieb; **Umschaltpunkt = T−3 (~Sa 12.09., KON37-04)**: erst dann echt gemessen, Debug-Werte gelöscht (einzige Ausnahme von „Messdaten nie löschen") → Ledger-IV/E+J.
* 🔴 **IST-Verstoß gegen VI.4**: measure-drop-Kanal sendet CSV unbedingt je Binary (KON32-01, „bleibt falsch") · **S-17**: `LagerBaumWriter` 0 Produktionsaufrufer ⇒ Messdaten-Kaskade ohne Einsortier-Pfad (KON12-03) → Ledger-IV/G.
* **BAU-REIHENFOLGE-DOKTRIN** (KON30-03): Träger-Stufen-Reihenfolge, PLANER ZUERST → Ledger-IV/I; S-Strecke S-1…S-21 je Welle: Wellenplan §16.2/§17.
* **Lesehinweis Teil IX**: Nummern sind KEIN Autoritätsbeleg (mind. 3 unabhängige „D2"; zweiter „S-6"/„D-12") — den Gegenstand prüfen → Ledger-IV/L-8.

**C. Gegengeprüft unverändert gültig:** Vier Träger + **ORT-Reihenfolge** (VI.1a) · prod1/prod2-Karte zweilanig (I.3) · allow_failure-Verbot auf JOB-Ebene · xlsx-Standard, csv=Kind (VI.4) · Fristen F1 14.08. / F2 21.08. / Trigger 26.08. / Abgabe 15.09. — **neu dazu: T−3-Anker ~12.09. = echte Messung (KON37-04)** · Name „Function-Interface-Reroute" · fünf Prüffragen (III) + Werkzeugfallen (V) · TDD-Vertrag 117/386 h/157-117-40-62 (VIII).

### A.2 Wellenplan — §17 (ANHÄNGEN nach §16; §16-Kopf ergänzen: „gilt bis KON23, Fortsetzung §17")

# 17. KONSOLIDIERUNG AUF KON24–KON38 + REFERENZ-STATUS (nachgetragen 12.08.2026 abends)

> **Anlass:** KON19-00. §13–§16 bleiben stehen; **§16 gilt bis KON23, was hier steht, gilt vor.** Fakten-Quelle: Ledger „LEDGER-KONSOLIDIERUNG IV" + KON24–KON38 — dieses Kapitel verweist, es dupliziert nicht. Gesamturteil: `docs/sessions/20260812-GESAMTURTEIL-*`. **Betriebsregel KON38:** jeder Stempel-Posten (S-1…S-7, S-14, S-18, B5, Flächen, Preimage, Versionierung, S-17-Schlüsselanteile) fährt in allen Workflow-Teilen `{model:'fable', effort:'max'}`.

## 17.1 OWNER-FRAGEN: F1–F11 UND F-A…F-H ALLE GESCHLOSSEN — Restliste neu geschnitten

§16.4 ist abgelöst: F1–F11 zu (KON25-11 · KON25 · KON27-01/-02 · KON28-03+KON30-04; **R-4 ist GESTRICHEN** — Owner: „streiche diesen missverständlichen Punkt überall", KON30-04; „gerade Anzahl" gilt nur noch für CEBs, KON36/B). Die WF7-Fragen F-A…F-H sind per **KON37 alle acht** beantwortet.

| ZU (12.08. abends) | Quelle |
|---|---|
| Wallclock-SOLL-Konflikt: **MERGE** — Freigabe Planer · Entscheidung/Schalter-Hoheit CEB · Durchführung im Vertrag CEB↔Tier/Hybrid; Vererbungsregel: CEB baut/ruft nur eigene Messeigenschaften | **KON37-01** |
| R-1-Rest: Auswahl-Subsystem wird **NEU gebaut** nach geänderter Architektur, `<measurement_tooling>` **erweitert** (Stufen-Dimension), Altes **ARCHIVIERT**; Korrelations-Pflicht Freigabe↔Ausführung per Compile-Time-Permutation der höheren Stufe | **KON37-02** |
| KON34-06(b): Reihenfolge zählt DOCH — als **statische Anordnungs-Freigabe in der Mess-Achse** (Adressierung, keine Nenner-Dimension) | **KON37-03** |
| E-Label-Doppeldeutung: Umbenennung genehmigt; **Lastsequenz = Framework-Mess-Achse**, keine dritte „Ebene" | **KON37-05** |
| T-15b-Details P.13/14: **je 5** für Build UND Messung; 3 Erfolgs-Werte einzeln (KF-10) | **KON37-06** |
| OD-7-Rest: W3-Kampagne fährt `--debug`; **T−3 (~12.09.) = echte Messung** | **KON37-04** |
| W-6: vier Klone = **Zielzustand** unter Konsolidierungspflicht (#88) | **KON37-07** |

| OFFEN (12.08. abends) | Quelle |
|---|---|
| **R-2** nur noch Bezeichner-VORSCHLAG (durch uns, im S-6-Fenster) | KON30-02 · KON36-02/F |
| **R-3/B-4-Menge**: KEINE Owner-Zahl — „Wie viel ist ohne Planer-Simulation nicht festlegbar" ⇒ **S-19 rechnet sie** | KON37-03 · KON30-03 |
| **KON34-06(d)** 17-vs-18 Dateien System-B-Doppelbau → Owner-Frage OF-1 | KON34-06 |
| **KON34-06(a)** „32 Docks = 32 Mess-Permutationen" — Bestätigung gegen das Subset-Modell → OF-2 | KON28-03 · KON37-03 |
| **O-5/K1** Lager-Identität Hybrid-.so → OF-3 · **O-4-Rest** Festplatten-IO → OF-4 | §16.1 · WF4/E-A |
| **A-1**-Vorlagetext vor jeder Backup-Ref-Aktion (aus §16.4 unverändert) | Ledger-IV/M |
| **NEU:** E-WARMUP-Explore (cache warmup, 10 Wochen) · Posten TEST-KONSOLIDIERUNG (Eigentümer setzen) · **T−3-Ripple** (XML→PDF-Vollautomatik + Lager-Skip + W5-Fenster) | KON37-06/-08/-04 |

## 17.2 DER MESS-NENNER IST 32 — die 6 verliert ihren Gegenstand, die ORDNUNG kehrt als Freigabe zurück

**Owner-Selbstkorrektur** (KON25-03): Tier Micro/Macro 2×2 · Hybrid 2×2 · CEB-Wallclock 2 ⇒ **32 Belegungen aus 5 Schaltern**. Die 6 zählte REIHENFOLGEN einer ortsfesten Vollmenge (KON34-03). **KON37-03 ergänzt:** die KON25-03-Zuordnung ist **SOLL-BELEGUNG, kein Typ-Verbot** — jede Stufe trägt ein **SUBSET der 3** compile-time-Einrichtungen; die Reihenfolge kehrt zurück als **STATISCHE ANORDNUNGS-FREIGABE in der Mess-Achse** (Zeiger/Zustände für an/aus je Stufe = Adressierung, **KEINE Nenner-Dimension; Nenner bleibt 32**). Folgen: §16.3 „CEB-Reihe 5→6→12" ÜBERHOLT (Marker, Zeile bleibt) · §8/OV-10 **gegenstandslos NUR als Nenner-/6er-Frage — Anordnungs-Gegenstand neu per KON37-03** · Kapazität hängt an der **S-19-Ausgabe** (B-4-Zahl), nicht an einer Owner-Antwort.

## 17.3 ZWEI MESS-ARCHITEKTUREN — B1–B5 in die W1-Zeile (Owner-Merkauftrag 12.08.)

**System A (LIVE):** #ifdef-Gates in `anatomy/abi_adapter.hpp` über `mess_achsen_naht.hpp`. **System B (DORMANT):** `mess::Konfiguration`+`CheckpointMeasure`+`SteuerDock`, 17 Dateien, 0 Produktionsaufrufer (KON34-01). **Fristen:** **B3 explizit VOR F2 (Owner-Datum, KON34-04)**; B1/B2/B4/B5 vor F2 als **ABLEITUNG** aus KON6-02/2+KON34-05 eingeplant (kein Owner-Datum; Merkauftrag sagt „in jede Durchführungs-Planung"). Die Posten:
* **B1** XML-Konsum je Stufe — **KON37-02:** `<measurement_tooling>` um Stufen-Dimension erweitern; `measurement_tooling_registry`/`canonical_combo` **NEUBAU** nach geänderter Architektur, Altes **ARCHIVIEREN**; 🔴 Korrelations-Pflicht Freigabe↔Ausführung via Filterketten-Mechanik (KON9-06).
* **B2** Gate-Trennung G2/G3 — ohne sie ist „Tier je an/aus" UNERFÜLLBAR.
* **B3** Hybrid-Gates (erst damit 5 statt 3 Schalter) — **KON37-01:** der „Wallclock-Umzug" ist Umzug der **SCHALTER-HOHEIT**, kein Instrument-Umzug (Tier-Pflicht-Wurf `abi_adapter.hpp:476-491` fällt); **Vererbungsregel** trägt B3+B5: CEB baut höhere Stufen nur nach eigenen Messeigenschaften, ruft nur selbstgebaute Messfühler.
* **B4** System B umstellen+anschließen — **KON37-03-Zielrolle:** die geordnete Typliste wird die **statische Anordnungs-Freigabe** (statt `anzahl==6`-Vollmengen-Permutation).
* **B5** Stempel-Pflicht je Schalter (⭐ Fable max, KON38).
`--debug` und Mess-Schalter **streng disjunkt** (KON34-05). ÜBERHOLT damit: §7-Zeile + §8/OV-2 „checkpoint_measure bleibt spezifiziert, nicht gebaut (W7)" — checkpoint_measure ist Teil von System B; **Owner-KERN 09.08. (paraphrasiert im Ledger, KON34-02/-03): checkpoint_measure muss gebaut werden**; B4 gehört in jede Durchführungs-Planung, nicht nach W7.

## 17.4 T-15 ENTKOPPELT · OD-7/DEBUG · T−3-ANKER · ZWEILANIG GEN-2

* **T-15b** = ZWEITE Retry-Klammer um `measure_one_binary`, von Drift-`max_reruns` (T-15a/D4) verschieden. **KON37-06:** Build und Messung dürfen **JE 5-mal** scheitern (nicht 1+5); Erfolg = 3 Wiederholungen je Parameter+Binary, **alle 3 einzeln persistiert**; Soft-Ausnahme nur fehlende Messeinrichtung (PMC) → xlsx-Warnung. 🔴 die 5 sitzt FALSCH auf der Drift-Achse (`ce 4cd1ab91`), Umzug + 8-Punkte-Ripple (KON26-04/KON28-02). §2-D4-Zeile und §7 bleiben stehen, Fußnote dort.
* **OD-7:** HEAVY-Deckel **24→16**; Kompensation `--debug` (KON26-05/KON28-01). **Umschaltpunkt = T−3 (~Sa 12.09.2026, KON37-04)** — nicht mehr „System steht planmäßig": davor fährt ALLES inkl. W3-Kampagne `--debug` (nproc-parallel, ungenau); ab T−3 echt (1 Thread), **Debug-Ergebnisse löschen** (KON29-01, einzige Ausnahme von „Messdaten nie löschen"). **Ripple (ausweisen, nicht glattrechnen):** echte Messung liegt im bisherigen W5-Fenster ⇒ W3 = **Debug-Generalprobe**, W4 entwickelt an Debug-Zahlen; trägt nur mit **vollautomatischer XML→PDF-Regeneration + Lager-Skip** (Posten in W2/W3).
* **Zweilaniger Kampagnenbetrieb Gen-2** (KON29-04): Bestandslog auf minio · Claims à 4096 · Takeover ETA+50 % · Kapazität prod1 20,7 h / prod2 34,4 h (4-Perm; 12-Perm hängt an der S-19-B-4-Zahl). Lücken: `window_belongs_to` unverdrahtet · Messung selbst nicht zweilanig.

## 17.5 NEUE KONZEPTE UND PRÄZISIERUNGEN

* **PRÜFLING** (Ledger-IV/F): Mess-Unter-Achse des Planers zur Laufzeit; je Organ-Achse zusätzliche Algorithmen, eigener Stempel je Prüflings-Algorithmus, XML-beschränkbar 1–3; `MergeStrategy`-Werte SIND die Verbund-Varianten (KON30-02 · KON31 · KON36/F).
* **HOME-PRINZIP** (KON27-01): je Achsen-Kategorie ein Home + genau EIN Wächter; zweistufige Versionierung; „zuerst gültige golden Version, dann Gliederung"; inkl. queuing-Umzug. Beantwortet §15.9/S-18-Explore vollständig (Marker dort).
* **EXPORT/S-13, Option b** (KON27-02): je FORMAT ein FORMAT→ZIEL-Eintrag; LaTeX mit Inhalts-Auswahl; PDF lazy.
* **BAU-REIHENFOLGE-DOKTRIN**: Owner verbatim (KON30-03): *„Wir beginnen beim Bau genau in der Träger-Stufen-Reihenfolge […]"* — die Pfeilkette **PLANER→CEB→TIER→HYBRID ist die Ledger-Doktrin-Box, kein Owner-Zitat**. §14.3-Graph liest sich mit **S-19** als Knoten zwischen S-7/F2 und Trigger; S-19-Weg: gruppieren → kategorisieren → Permutation über den Experiment-B+-Baum rechnen — **S-19 PRODUZIERT die B-4-Zahl** (KON37-03).
* **E-LABELS** (KON37-05): Erhebungs-Ebenen werden umbenannt (E1–E4 gehört der Experiment-Maschinerie); Achsen-/Gattungs-(Genus-)Aufruf = Aufruf-Ebenen, **Lastsequenz = Framework-Mess-Achse** (liegt selbst auf einem Achsen-Interface) → in die Umbenennungs-Landkarte.
* **Hybrid-Zeitbezug** (KON36/WF7): „eigenständig + Sync-Kanal" = Autonomie-Stufe SPÄTER; JETZT orchestriert die CEB direkt ODER delegiert (Bestand `AnatomyModuleLoader`); S-20 = Neubau für später — betrifft §16.1/O-5 und §8/OV-13; HY-A/B/C-Zerlegung hält.

## 17.6 WELLEN-WIRKUNG — Task-Nummern, keine zweite Zählung

KON27-04 ordnet **15 Aufgaben (Prio 1–15)** den Wellen zu: **Bestand #7/#10/#11/#13 + neu #14–#22, zwei Zeilen OHNE Nummer** — als Cross-Reference-Spalte an die bestehenden ##/S-/D-Tabellen (Ledger-IV/L-8: Nummern sind kein Autoritätsbeleg; KON27-04s „#21/#22" kollidieren mit der Lead-Liste). 🔴 **V-1: der `##25`-DURCHSTICH (DIE F1-Lieferung, Fr 14.08.) war bis 12.08. mittags OHNE Besitzer** — Sofortposten. Layout-Bump-Konflikt (`decl.hpp:293`) bleibt benannter Vorab-Posten des S-6-Fensters. **KON37-08:** die 3 Skelett-Testverzeichnisse sind NICHT mehr W7-Behälter → aktiver Posten TEST-KONSOLIDIERUNG (s. Teil D).

### A.3 Designplan — §10 (ANHÄNGEN nach §9; Meta-Absatz Z.2 um Stand-Hinweis; betroffene Zeilen tragen `[D-n → §10]`)

## 10. NACHTRAG — DRIFT GEGEN KON15–KON38 (12.08.2026) + REFERENZ-STATUS

**Status (KON19-00):** Haupt-Referenzdokument der Testseite. Stand bleibt 08.08. + §9; nicht eingearbeitet war der Architektur-Freeze KON15–KON38 — Differenzen nach §9-Muster, nichts gelöscht. Fakten-Quelle: Ledger-Konsolidierung IV.

**D-1 — Hybrid-Bestand nicht null** (§4/Regel 3, W1-Absatz „definiert HY-A"): KON9-02: `hybrid/` trägt **4 Header/943 Z.**, 0 Konsumenten; `AnatomyGattung::HeuristikAdapter=3` existiert, `AnatomyGenus` **sechswertig** — der HY-Reroute-Vertrag **PINNT** `kGenusCount`, definiert nicht grundauf. TDD-Charakter bleibt: Tests vor dem ANSCHLUSS.
**D-2 — Kapazität** (§8, „~118 h"): #87/#78/#86/KON9-05/HY-A sind **(P), MÜSSEN vor F2, fallen NIE** (§13.3); Reserve-WE 22./23.08. dafür gezogen; **Band B/W1 (62 h) „geschlossen gestrichen"**. §8-Bedingung (2) damit entschieden.
**D-3 — Shell-Bissproben sind Alt-Last** (§9.3 `mess_ausbeute_bissprobe.sh`, **§9.5 (Z.338)** `plan_zahlen_probe.sh`): KON6-05: `ci/tests/*.sh` müssen Google Tests werden, KEINE Ausnahme; Teil der stehenden Regression **S-16** (14 Dateien/8.528 Z., 0 retired; Skip-Verbot KON22). MECHANIK vorbildlich, FORM zu migrieren; **KON37-08s TEST-KONSOLIDIERUNG dockt hier an** (Ziel-Testmodule = Zielstruktur auch für S-16).
**D-4 — S-Strecke hat KEINE Testposten** (Lücke, als GEZÄHLTE Warteliste): S-6, S-13, S-14, S-17…S-21 fehlen im 117er-Katalog; T-9 läuft für den größten Baublock leer. Neu: **S-21 Kategorien-Ordnungs-Wache** (=S-6c, Owner-GO, Vorbild `organ_gruppen_decken_die_komposition`, KON21-03). S-6-Umfang erst nach Layout-Bump-Lösung (`decl.hpp:293`) schätzbar.
**D-5 — xlsx-Nenner** (§2/K7 „null Aufrufer"): KON4-07/R1+KON36-02/H: **8 von 9** `thesis_profiles` xlsx-blind — Kampagnen-Blocker; fehlender T-3-Klasse-Posten mit Profil-Nenner. Lehre L-4: jede „existiert nicht"-Aussage trägt ein Verfallsdatum.
**D-6 — PMC-Vertragsfolge ungetestet**: PMC = Meta-Meta-Achse, AMD/Intel = zwei Komponenten (KON8-12); CI fährt PMC ohne Vendor (WARNING, KON34-02). MT-L11 misst nur Injektion — CEB→Tier-CT-Vertragsanpassung ohne Posten.
**Summen-Regel:** 117/386 h werden NICHT angefasst, bis die S-Strecke durchgezählt ist — sonst derselbe T-3-Fehler, den §9 korrigiert.

### A.4 ARBEITSWEISE v3.5 — VORSCHLAGSLISTE (Owner-Vorlage; Pflege-Regel 1: Teil A/V nur mit Owner-Freigabe)

Befund: **kein ÜBERHOLT-Fall in v3.4** (KON36 korrigierte Ledger-Kapitel B, nicht die Doktrin; alle L-Lehren additiv). Kandidaten — je datierter Absatz + AENDERUNGSLOG „v3.5":
| # | Kandidat | Anlass | wohin |
|---|---|---|---|
| 1 | 10-Wochen-Explore = NORMALFALL jeder Frage + 3 Falsch-Null-Klassen (Encoding · Case · Umbruch ~95) | Memory 10.08. | A2.3 |
| 2 | Platzhalter-Gate: StructuredOutput-Cap erzeugt Stubs — als FEHLSCHLAG erkennen | KON23/KON24 | A2.4 |
| 3 | Synthese-Prompts tragen Titel-+Längen-Auflage | KON36/L-12 | A1+A2.4 |
| 4 | Platte-voll-RECOVERY: `rm -rf ~/.cache/uv/builds-v0` → Workflow stoppen → räumen | ref 11.08. | A2.1(d) |
| 5 | Stillstand: `journal.jsonl` ist die Wahrheit, zuerst `df -h` | ref 09.08. | A4 |
| 6 | SendMessage an WARTENDEN Workflow-Agenten = zweite Instanz — nicht antworten | Fallen 09.08. | A2/A4 |
| 7 | Köder-Rezept + LÄNGE prüfen (19/20-Falle) | L-9 | A3 |
| 8 | Nummern sind KEIN Autoritätsbeleg | L-8 | V12 |
| 9 | Jede Owner-Zitat-Kürzung trägt `[…]` | L-7 | V13 |
| 10 | Zeilenanker instabil — Symbol/Commit/KON | L-6 | V14 |
| 11 | „Plan = Behauptung über den Code" — am Objekt prüfen | L-3 | neben V0 |
| 12 | Dritter Verify-Zustand PRÄZISIERT | L-5 | Verify-Schema |
| 13 | „existiert nicht" trägt VERFALLSDATUM | L-4 | V4/V6 |
| 14 | A2.0-GEDÄCHTNIS-Nichtfund bekommt Gegenprobe-Pflicht wie A2.2 | v3.1/v3.3-Diff | A2.0 |
| **15** | **STEMPEL-THEMA ⇒ alle Workflow-Phasen `{model:'fable', effort:'max'}`** (ersetzt A1-Matrix themenspezifisch; Geltung S-1…S-7, S-14, S-18, B5, Flächen, Preimage, Versionierung, S-17-Schlüsselanteile) | **KON38 — Owner-Anweisung IST die Freigabe-Grundlage, Einarbeitung mit dieser Vorlage** | A1 |

### A.5 ÜBERHOLT-/PRÄZISIERT-MARKER (an die Stellen selbst; einzeilig)

* GOAL VI.1(a) „[PLANER] fragt (Laufzeit)" → ÜBERHOLT 12.08. **nur in der Emissions-/Linear-Lesart** (Bau-Modul/Builder, Tiefe 3, Rakete rückwärts, Emission endet im Lager; KON16…KON25-08) — **ORT-Reihenfolge gilt weiter, s. Abschnitt C**.
* GOAL VI.2-Titel „0 % gebaut" → ÜBERHOLT: „0 % ANGESCHLOSSEN" (943 Z. + 1802 Z., 0 Konsumenten; KON9-02).
* GOAL VI.2 „Owner-KERN 08.08.: Gattung" → PRÄZISIERT: ZWEI Ebenen GEMEINSAM — `AnatomyGattung::HeuristikAdapter=3` (4. Gattung, keine Dock-Gattung) + `AnatomyGenus::FunctionInterfaceReroute=5` (sechswertig); `genus()` NIE Reroute (Pass-through, Weg C) — `anatomy_base.hpp:53-92 + :131-169`; 14 Entscheide.
* GOAL VI.2 „auf **vier** erweitert" → **PRÄZISIERT** (nicht ÜBERHOLT): Nenner=32/5 Schalter; die eigene Hybrid-Mess-Schicht HÄLT und trägt B3 (KON25-03 · KON34-03 · KON37-03).
* GOAL VI.5 „Drift-Gate 5 %" → GETRENNT: T-15a ≠ T-15b (je 5 Build UND Messung, 3 einzeln, KON37-06); 🔴 5 falsch auf Drift-Achse (`ce 4cd1ab91`).
* GOAL I.3 „:1097/:1194" + „47 von 53" → ANKER GEDRIFTET (:1810/:2038 · 38/41): Symbol/Commit/KON, bei Zitat neu zählen.
* GOAL IX D2 → ERGÄNZT: EIN roter Job `test:coverage-guard`; „erst F1, dann F2" = **Guard-interne Schritte (F1=Operanden vergleichbar, F2=when:always), NICHT die Fristen**.
* GOAL IX D5 → TEILS: 3/5 erledigt (`ce c98b4b95`); offen D5-2+D5-4. · GOAL IX „:1841" → GEDRIFTET (:2736/:2751), Sachaussage hält.
* GOAL VII.1 W7 „checkpoint_measure" → ÜBERHOLT: System B/B4, Owner-KERN 09.08. (paraphrasiert) „muss gebaut werden" → Wellenplan §17.3.
* WELLENPLAN Kopf → FORTSCHREIBUNG: §16 (KON16–23) + §17 (KON24–38); bei Widerspruch gilt §17. · §16-Kopf → „gilt bis KON23, Fortsetzung §17".
* WELLENPLAN §16.3 „CEB-Reihe 5→6→12" → ÜBERHOLT (Nenner=32) → §17.2. · §16.4 → ÜBERHOLT: **F1–F11 geschlossen, R-4 GESTRICHEN (KON30-04)**; Offen-Liste → §17.1.
* WELLENPLAN §15.9/S-18 → BEANTWORTET (Home-Prinzip KON27-01) → §17.5. · §7+§8/OV-2 checkpoint_measure → ÜBERHOLT (System B/B4) → §17.3.
* WELLENPLAN §8/OV-10 → gegenstandslos **NUR als Nenner-/6er-Frage; Anordnungs-Gegenstand neu per KON37-03** → §17.2.
* WELLENPLAN §2/§12.4-D4 + §7 „T-15/D4-Streichung" → PRÄZISIERT (T-15b, KON37-06) → §17.4. · §16.1/O-5 + §8/OV-13 → KORRIGIERT (Zeitbezug; S-20=Neubau später) → §17.5. · §14.3 → ERGÄNZT (Doktrin-Box + S-19-Knoten; S-19 produziert B-4) → §17.5.
* DESIGNPLAN §4/Regel 3 „null Zeilen" + W1 „definiert HY-A" → [D-1 → §10] · §2/K7 „null Aufrufer" → [D-5 → §10] · §8 „~118 h" → [D-2 → §10] · §9.3 + **§9.5 (Z.338)** Bissproben → [D-3 → §10].
* Wellenplan §17.1-Quellenzeile „F5,F7 (KON25)" präzisiert: **KON25-11 führte E-F5/E-F7 als EXPLORE; geschlossen via WF4/WF5 + measure-drop KON32-01**.
* ARBEITSWEISE v3.4 → KEIN Marker (Gegenprobe: alle Lehren additiv) — nur v3.5-Vorlage, Owner-gated.

---

## TEIL B — STRATEGISCHE STRECKE (final; Review-Fixes + KON37/KON38 eingearbeitet)

LEGENDE: [P]=vor F2 · [M]=vor Trigger · [W]=vor Gegenstand (Wellenplan:1335-1340) · Stränge A–H = Worktrees, EIN Schreiber je Worktree, parallel bauen — SERIELL landen (1 Lande-Slot/Abend) · **⭐ = KON38: alle Workflow-Teile Fable 5 max** · Kein Gate mehr auf: Wallclock (KON37-01) · R-1 (KON37-02) · OD-7-Rest (KON37-04) · W-6 (KON37-07) · §13.4c (Variante B, Wellenplan:1521-1530) · Stufe/Phase-Klasse A (KON29-03).

**MI 12.08. NACHMITTAG**
1. #11 DURCHSTICH: SOFORT Besitzer setzen — DIE F1-Lieferung (V-1; Wellenplan:1358 nennt ihn „#21" — Gegenstand zählt, nie die Nummer) — C
2. Owner-Fragen-Paket = **nur noch OF-1…OF-4** (Teil C) HEUTE vorlegen; dazu ARBEITSWEISE-v3.5-Vorlage (Teil A.4) übergeben
3. ⭐ S-1 Stempel-Basisklasse beginnen (KON7-08) [P] — Startpunkt kritischer Pfad — A
4. #14 ce grünen, Strang D — **Reihenfolge neu: #83 lint:format ZUERST** ([W] blockiert jede Landung, Wellenplan:1362), dann #84 Vorbestands-Rot → #80 coverage-guard (F1- vor F2-Anteil) — D
5. #9 Referenz-Konsolidierung landen (=#88 P.3; DIESES Dokument + Teil-A-Einpflege) — H

**DO 13.08.**
6. #10 MinIO-Keys + 776-Token-Rotation + test:secrets aus prod2 (KON22-01/5+6) — D
7. #11 Durchstich-Bau ganztägig — C
8. **#83 gelandet, DANN** ⭐ S-1 landen; #4 vorbereiten (S-3/S-7 gebaut+inert, NUR aktivieren) — A
9. #22-Paket: runner-mode.sh:43 HEAVY_J 24→16 + §69.6-Vermerk + **N-3/N-4 SOFORT mit 16 Workern + debug-nproc rechnen (Gate GEFALLEN, KON37-04)** + **Q6-MaxN 8→32 (`synthese_matrix.hpp:33-51`)** + 2 Ledger-Zitat-Korrekturen (KON28-01) — H
10. golden Version festschreiben (golden VOR Homes; Voraussetzung #16) — B
11. ⭐ S-14a Bump-Wache Teil 1 [W] (heute 6/136 gedeckt) — H

**FR 14.08. = F1**
12. #11 ##25-DURCHSTICH LANDET — C
13. #14 Rest: #80/#84 fertig → ce-Pipeline grün — D
14. #21 Prüfposten E-1…E-4 + A-1-Vorlagetext **KOMPLETT abschließbar (W-6-Gate GEFALLEN: Zielzustand, KON37-07)** — H
15. ⭐ #4 S-3-Ordnungs-Relation aktivieren (braucht S-1) [P] — A

**SA 15./SO 16.08. (Reserve-WE gezogen)**
16. ⭐ #4 fertig: S-7 Achsen-Algo-Hardware-Stempel X.Y.Z AKTIV [P] — A
17. ⭐ S-5 Stempel-Factory + Composite je Träger (2/3/4/4+Karte) + dreiwertige Matrix [P] — A — **braucht S-1, S-3; Grammatik v2 ist GEBAUT (§16.1), G-2-SEMANTIK (#17) folgt nach den Homes** (Klammer korrigiert)
18. ⭐ #16 S-18: Homes MESS/SYSTEM + je Home EIN Wächter + zweistufige Versionierung + queuing-Umzug (KON27-01) [P] — B
19. ⭐ Layout-Bump-Konflikt lösen: `anatomy_module_abi_v1_decl.hpp:293` verbietet Layout 7 — VOR S-6a-POD — A
20. #24/B2 Gate-Trennung G2/G3 [P] — ohne B2 „Tier je an/aus" UNERFÜLLBAR — E
21. S-4 Filter-Concepts A+B (braucht S-3; Bauform `ram_probe_chain.hpp`) [M, früh: speist S-8] — G
21b. **NEU: Datei-Mengen-Explore A↔E** (S-6a-Makro/Preimage-Flächen vs. B2/B3/B5-Gates) **VOR Mo 17.**; Schnittmenge ≠ 0 ⇒ B5 (+ B2/B3-Adapteranteile) hinter #15 in den A-Lande-Slot (Merge, nie rebase)

**MO 17.–MI 19.08.**
22. ⭐ #15 S-6-FENSTER: S-6a MESS,SYSTEM,ORGAN an Makro+POD+Preimage + S-6b Transpositions-Sperre + S-6c S-21-Wache + S-6d #67-Benennung; **R-2-Namen (MergeStrategy) hier VORSCHLAGEN** [P] — A
23. #17 G-2-Semantik-Nachzug (System+Organ zweiphasig) NACH #16 [P] — B (⭐ S-2-Anteil)
24. #24/B3 Hybrid-Gates [P] — E — **SOFORT spezifiziert per KON37-01: Umzug der SCHALTER-HOHEIT, kein Instrument-Umzug (Tier-Pflicht-Wurf `abi_adapter.hpp:476-491` fällt); Vererbungsregel: CEB baut/ruft nur eigene Messeigenschaften. Wallclock-/E-Label-Gate GEFALLEN, Eskalations-Klausel entfällt**
25. ⭐ #24/B5 Stempel-Pflicht je Schalter (braucht S-5) [P] — E (Lande-Slot ggf. A, s. 21b)
26. ⭐ HY-A Hybrid-Struktur A1–A3, Fläche 2 (KON9-02/03) [P] — F
27. ⭐ Stempel-ABI-Pflicht 5. Symbol nullptr→Pflicht (KON7-01) + CEB-Stempel CT-Systemanzeige (KON8-03) [P] — F; gleiche ABI-Fläche wie A: landet NACH dem A-Slot, Merge
28. ⭐ SOLL-Versionierung: Planer-SHA + CEB-System-Anteil + Genus zusammengesetzt statt 5 Literale (KON2-06/17) [P] — F
29. Umbenennungs-Landkarte Klasse A („Phase"→„Träger-Stufe", KON29-03 — **Begriffs-Gate GEFALLEN**) + State-Modi + **E-Label-Umbenennung samt Lastsequenz-Einordnung (KON37-05)** [P] · Flag-f-Kollision FPGA/AVX-512 auflösen — F
30. ⭐ #20 IMessVisitor==measurement-Durchstich vereinen [P]; Deckungslücken-Test CEB=AUS/Tier=AN erst NACH B2 — B
31. S-8 Planer-Kopf beginnen: IPlanBuilder/CMakeGraphBuilder/CiYamlBuilder/2-Pass [M] — G — **P-0 BEGLEITEND (§15.5: beim S-8-Bau die super-Seite aufs ce-Skelett ziehen; Regel-2-Zitat ersetzt — P-0 blockiert nicht)**

**DO 20./FR 21.08. = F2 IDENTITÄTS-FREEZE**
32. ⭐ #15 landet als LETZTER Preimage-Schritt — A
33. #17 landet → Stempel-Strecke #4+#15+#16+#17 KOMPLETT → gibt #7 frei (KON17-01) — B
34. #24/B1 landet (KON37-02: `<measurement_tooling>` + Stufen-Dimension; Registry-NEUBAU, Altes ARCHIVIEREN; Korrelations-Pflicht via Filterkette KON9-06) · **B3 landet [P] — Gate entfallen** — E
35. #68 selektiver Rebuild/Additivität [M] beginnen — deklarierter ERSTER Verzicht bei Zeitnot (V-10)
36. FREEZE-CHECK, alle [P]: S-6a–d · S-7 · S-5 · **S-3 · #17/S-2** · ABI-Pflicht · CEB-Stempel · SOLL-Versionierung · HY-A · **B1** · B2/B3/B5 · Umbenennung

**W2 (Sa 22.–Mi 26.08. 06:00 = BAU-TRIGGER · F3 Fr 28.08.)**
37. #7 S-19-Simulation Sa–Mo: gruppieren→kategorisieren→rechnen → **BAU-ZAHLEN Di 25.08.**; **Nenner-Gate = S-19-AUSGABE + KON34-06(a)-Bestätigung (OF-2) — NICHT „R-3": S-19 PRODUZIERT die B-4-Zahl (KON37-03)** — Zirkularität aufgelöst
38. G sequentiell: S-8 → S-9 CEB-Generierung (.so-ABI-Grenze) → S-10 Serialisierung ∥ S-11 ceb:build hart → #3/S-12 vier Mini-Pipelines (heute 0/4 Träger) → #18/S-13 Export+Filter+COMDARE_STORAGE_CACHE
39. S-17 Lager-Baum-Writer [M] ab Sa parallel (⭐ Schlüssel-Anteile) — Emission endet im Lager; setzt O-9 voraus
40. #24/B4 System B umstellen + Builder-Anschluss — **KON37-03-Zielrolle: Typliste = statische Anordnungs-Freigabe (Zeiger/Zustände je Stufe), `anzahl==6` fällt; GATE nur noch KON34-06(d)-Zählung (OF-1) — §13.4c-Gate GESTRICHEN (Variante B gilt, Wellenplan:1521-1530)** — E
41. H: Diff-Hygiene-Wache KUMULATIV → #19 main-FF beider Repos (Fassungen 779/558 Z. angleichen) · #82 Mutant `bvset_ist_teilmenge` · ⭐ **S-14-Vollausrollung/C-4 AB SA 22. PARALLEL in H (von #18 GELÖST; Build-Blocker-Klasse, 6/≥152) — geht ins Trigger-Kriterium**
42. #13 T-15b: **bleibt W2 Sa/So — ABWEICHUNG von KON27-04-Prio-6 (W1) hiermit DEKLARIERT** (W1 vollständig [P]-belegt; Frist „vor Kampagne" hält); Inhalt per **KON37-06: Klammer um BUILD UND MESSUNG, je 5, 3 Erfolgswerte einzeln persistiert** + 8-Punkte-Ripple `checkpoint_speicher.hpp:119-123` · measure-drop-Kanal heilen [W] (KON32-01) — beide vor Kampagne
43. **TRIGGER-KRITERIUM Mi 26.08. 06:00:** #7-Zahlen + S-13/S-17 + B1/B2/B4/B5 + **S-14-Vollausrollung** (+ #68 oder dokumentierter Verzicht)
44. Kampagnen-Vorstaffel ab Sa 29.08.: **ZUERST E-WARMUP-Explore (cache warmup, 10 Wochen, KON37-06)** · S-15/HY-B [GATE O-5/K1=OF-3] · thesis_profiles 8/9 xlsx-blind · zweilanige Messung §61 + window_belongs_to · S-20 Sync-Kanal (AnatomyModuleLoader) · PMC-Vendor · Kapazität 12-Perm [GATE: B-4-Zahl aus S-19]

**T−3-ANKER (KON37-04) — neue Posten:**
45. W3 = **DEBUG-GENERALPROBE** (Kampagne fährt `--debug`); Voraussetzungs-Posten in W2/W3: **XML→PDF VOLLAUTOMATISCH regenerierbar + Lager-Skip deckt den Bau-Anteil**; W4 entwickelt an Debug-Zahlen
46. **NEU in W5: ECHTE MESSUNG Sa 12.–Mo 14.09.** (`--debug` fällt, 1 Thread deterministisch, Debug-Ergebnisse löschen per KON29-01) — harter Termin-Anker der gesamten Strecke

**KRITISCHER PFAD:** S-1 (Mi/Do) → #4 S-3+S-7 (Fr–Sa) → S-5 (Sa/So) → [Layout-Bump `decl.hpp:293`] → #15 S-6-Fenster (Mo–Fr) ⇒ **F2-FREEZE Fr 21.08.** ∥ golden (Do) → #16 Homes (Sa–Mo) → #17 (Mo–Do) — BEIDE Stränge → #7 S-19 (Sa 22.–Mo 24., **produziert B-4**) → **BAU-ZAHLEN Di 25.** ∥ Emissions-Ast: S-3→S-4 + S-8 (P-0 begleitend) → S-9 → S-10∥S-11 → #3/S-12 → #18/S-13 + S-17 → **BAU-TRIGGER Mi 26.08. 06:00** (dazu B1/B2/B4/B5 aus E) → W3-Debug-Generalprobe → **T−3 12.09. echte Messung** → Abgabe 15.09.
**ENGSTE GLIEDER:** (1) Layout-Bump vor S-6a · (2) OF-1/OF-2 (KON34-06 d+a) vor B4/#7-Nenner · (3) S-13/S-17-Landung erst Di 25. — engster Slot · (4) A↔E-Flächen-Disjunktheit (Explore 21b) · (5) XML→PDF-Vollautomatik + Lager-Skip bis W3 (sonst trägt T−3 nicht).

---

## TEIL C — OWNER-FRAGEN-VORLAGE (heute Mi 12.08.; nur noch VIER)

| # | Frage (1 Satz) | Empfehlung | Frist | blockiert |
|---|---|---|---|---|
| OF-1 | KON34-06(d): trägt der System-B-Doppelbau 17 oder 18 Dateien? | 17 als Arbeitshypothese; Zählung am Objekt liegt bei | Mi 19.08. | #24/B4-Umfang (W2) |
| OF-2 | KON34-06(a): bestätigst du „32 Docks = 32 Mess-Permutationen" als Festlegung — im KON37-03-Modell: 32 = Belegungs-Maximum aus 5 Schaltern, je Stufe ein Subset der 3, Dock-ORDNUNG = statische Anordnungs-Freigabe (Adressierung), KEINE Nenner-Dimension? | bestätigen | Fr 21.08. | #7/S-19-Nenner + E-F3b (32-vs-6) |
| OF-3 | O-5/K1: welche Lager-Identität trägt die Hybrid-`.so` (Stempel-/Pfad-Schema im Binaries-Baum)? | wie Tier-Binary, mit Genus-Anteil `FunctionInterfaceReroute` + Karten-Verweis | Fr 21.08. | S-15-Einsortierung + Binaries-Kaskade (W3) |
| OF-4 | O-4-Rest: wird Festplatten-IO ein NEUER additiver OrganMetaMetaAxis-Typ oder trägt der Bestand (T12/T17) die Verwandtschaft schon? | Bestand prüfen lassen, nur bei Lücke neuer Typ | F3 Fr 28.08. | W3-Bauumfang |

**NICHT erneut vorlegen** (geschlossen; Beleg): OD-7/`--debug` (KON37-04) · W-6 (KON37-07) · Wallclock-SOLL (KON37-01) · E-Label (KON37-05) · R-1-Rest (KON37-02) · KON34-06(b) (KON37-03) · T-15b P.12–14 (KON28-02 + KON37-06) · R-3/B-4-Menge (S-19 rechnet sie, KON37-03) · R-4 (GESTRICHEN, KON30-04) · Stufe/Phase Klasse A (KON29-03; Klasse-C-Name = UNSER Vorschlag im S-6-Fenster) · §13.4c (Variante B, Wellenplan:1521-1530) · Dock 32-vs-8 (KON28-03; Q6-MaxN=8 nur Code-Fix → Posten 9, Do 13.).

---

## TEIL D — W7-LISTE, GEZÄHLT (nichts still)

**HERAUSGEZOGEN (KON37-08, Owner dreht F-G):** TEST-KONSOLIDIERUNG — `integration` · `generic_module_tests` · `module_specific_tests`: Eigentümer setzen, JEDEN Test prüfen (was testet er? gebraucht?), in Ziel-Testmodule aufteilen/neu verteilen; dockt an S-16 und #88 an — **aktiver Posten, KEIN W7-Behälter mehr.**

**Nach W7/Abgabe fallen 23 Posten = 9 Behälter + 14 Zähler:**
1. P/E-Core-Cluster: ICpuCore/ICoreLayout/CoreClass, CPUID 0x1A ohne Implementierer (KON20-04)
2. S-16: `ci/tests/*.sh` → Google Tests, ~8.000 Z. gegen 517 GTests (tr-Shim ließ 5/5 Mutanten durch) — Dauerposten; Zielstruktur liefert die TEST-KONSOLIDIERUNG (KON6-05 · KON37-08)
3. NOTICE/GPL-Widerspruch: NOTICE=Apache2.0 vs LICENSE=Dual; wh.c-Kopie ungedeckt vom Vier-Schalter-Gate (KON2-24/25)
4. Betreuer-PDFs (Namen/@tu-dresden) in die Release-Checkliste vor Public-Release (KON22-01/4)
5. Stage-Topologie: coverage-guard vor test:unit; `ctest_unit_inventar.txt` 0 Verbraucher (KON4-03)
6. XML-Wache: zwei unbeobachtbare Zweighälften (grep-Zweig braucht root; Nenner-Mismatch-Mutant überlebt) (KON3-03)
7. Bestandslog-SKIP-Risiko: EIN Eintrag je binary_id mit leerer Zelle trotz 320-facher opt-x-simd-Bindung (KON3-06)
8. Backup-Ref-Löschung gestuft: Bundle nach Lieferphase, Remote-Löschung NUR mit explizitem GO (KON22-02) — davor A-1-Vorlagetext (offen, §17.1)
9. Flag-Katalog-W7-Anteil: 59-Knoten-Vollausbau, g/f/n-Sub-Token — die f-Kollision FPGA/AVX-512 selbst fällt VOR dem Trigger (KON7-06/KON8-09)
10.–23. Die 14 Zähler-Posten: #26 #29 #30 #32 #34 #42 #44 #48 #50 #63 #64 #69 #71 #72 (§14.6/§13.3)
