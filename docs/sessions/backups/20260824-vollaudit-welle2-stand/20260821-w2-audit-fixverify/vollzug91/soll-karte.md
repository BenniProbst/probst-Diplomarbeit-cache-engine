# SOLL-KARTE -- #91 Identitaets-Entscheide-Vollzug (E-3, Strang vollzug-91)

Erstellt: 23.08.2026, Sonnet-max-PLANUNGS-ERHEBER (S2-Aufgabe vollzug91) fuer das W2-Audit.
NUR LESEN -- kein Fix, keine Ledger-/Board-Schreibung. Alle Quellen unten mit Datei:Zeile
belegt; woertliche Zitate in Anfuehrungszeichen. Objekt-Gegenproben (git show/log, read-only)
sind einzeln markiert.

**Gegenstand:** ce `bau/vollzug91` @ `6713156b` (Basis `66de5c09`; Worktree
`/home/comdare/wt-ce-vollzug91`; verifiziert 23.08. read-only: `git show --stat 6713156b`
zeigt exakt 10 Pfade -- 3 neue Header unter `libs/cache_engine/include/cache_engine/{lager,
measurement,naming}/`, 1 neuer Header + 1 geaenderte CMakeLists.txt unter `libs/traeger/ceb/`,
4 neue Test-TUs + 1 geaenderte CMakeLists.txt unter `tests/unit/`; Commit-Trailer
`Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>` bestaetigt). Design-Quelle des
Strangs (nicht in meiner SOLL-Quellenliste, aber Provenienz read-only bestaetigt 23.08.):
super `docs/plaene/20260820-DESIGN-91-unifikation-ceb-modulsteuerung-v2.md` @ `0778c6ef`
(`git cat-file -e 0778c6ef:docs/plaene/...` = Datei existiert am Commit; Autor Owner
benjaminelias probst@gmail.com, 20.08. 13:24 UTC, Commit-Betreff nennt selbst "design91-v2
(11 Kandidaten/10 Punkte, I-2 Klasse C, landereif per Lens)"). Ergebnis-Bericht des Strangs
(`vollzug-91-ergebnis.md`, 288 Z.) VOLL gelesen.

**Wichtiger Vorab-Befund (verhindert Phantom-Funde):** Der Task-Name "#91" ist im Wellenplan
DOPPELT belegt -- s. SPANNUNGEN Nr. 1. Der fuer DIESE Aufgabe massgebliche Referent ist
AUSSCHLIESSLICH die "Unifikations-Designplan M0-M14"-Fassung (Board angelegt 17.08.,
KON107-113, Ledger KON113-03), NICHT die aeltere "#91 PHASE 0 (Blocker vor der
Selbstkompilations-Strecke)"-Textstelle aus dem 08.08.-Grundlagentext des Wellenplans
(dort §13.4(a)). Die alte Lesart ist im Ledger explizit geschlossen: *"Task #91 (PHASE 0 als
Blocker) ist damit gegenstandslos"* wird geschlossen und ist als solches erledigt (Ledger:11177).

--------------------------------------------------------------------------------
## PRUEFLISTE

| Nr | WAS gefordert ist (woertlich, Quelle+Zeile) | WIE am Objekt pruefbar | Strang-Bericht BEHAUPTET |
|---|---|---|---|
| P-01 | "Design KOMPLETT (design91-v2, docs/plaene, 0778c6ef -- referenzieren, NICHT neu entwerfen)." (W2-ABFOLGE-DESIGN.md:456-457) | design91-v2 @ 0778c6ef existiert (s.o., read-only bestaetigt); Ergebnis-Datei zitiert es mit Abschnittsnummern statt eigener Neu-Erfindung | JA -- Kopfzeile Z.4-6 "design91-v2 ... VOLL gelesen", jeder I-Punkt zitiert design91-v2-Abschnitte |
| P-02 | "(a) completed-Buchung im Ledger" (W2-ABFOLGE-DESIGN.md:457); ABNAHME "Buchung completed" (:463-464) | Ledger-Grep nach "#91" + Board-Status -- ABER: Ledger/Board-Schreibung ist laut den REGELN dieser gesamten S2-Staffel Lead-only, Straenge liefern nur Entwuerfe | TEIL -- Strang liefert nur ENTWURF (Abschn.6: Board-Zeile + Ledger-Absatz-Entwurf), schreibt bewusst NICHT (korrekt gemaess eigenem Auftragspunkt 6 "NICHT geschrieben"). Objektbefund 23.08.: Ledger-Kopf ist inzwischen KON121 (nicht mehr KON119); kein KON-Absatz mit "6713156b" oder "vollzug91" auffindbar (grep = 0 Treffer) -- die Buchung ist demnach WEITERHIN offen |
| P-03 | I-1/I-5 = "Klasse B 'W2 entscheiden+bauen' (mechanisch entschieden; Bau via D-2/D-4)" (W2-ABFOLGE-DESIGN.md:458) | Datei `libs/cache_engine/include/cache_engine/lager/bestand_schluessel_schema.hpp` muss existieren, NUR CT-Schema, keine Lager-Mechanik (Factory/Schreibweg) | JA fuer I-1-Schema-Anteil: Datei gebaut (git-bestaetigt, 160 Z.); Lager-MECHANIK explizit NICHT gebaut ("bleibt vollstaendig D-2/#57(7)-(9)", Abschn.2a) |
| P-04 | I-1 Bestand 1/2 Komponenten "verbatim vom Objekt" (design91-v2 Abschn.4, zitiert Ergebnis-Datei Abschn.2a) | Quellcode-Vergleich `builder/bestandslog/bestandslog_factory.hpp` BinaryKeyPolicy/MesswertKeyPolicy gegen die neue Schema-Datei | JA -- Abschn.1/I-1-Objektbefund nennt exakt `bestandslog_factory.hpp:42-46/:60/:98` + `messwert_key_source.hpp:25-33` als Quelle |
| P-05 | I-1 Bestand 3/4 Komponenten "verbatim design91-v2: machine_id x voll_stempel_fingerprint x mess_ebenen_kanal_referenz; xml_c14n_hash x machine_id x bestands_stempel_referenzen" (Ergebnis-Datei Abschn.2a, design91-v2-zitierend) | Header-Text der neuen Datei gegen design91-v2 Abschn.4 lesen (AUSSERHALB meiner SOLL-Quellen -- Audit muss design91-v2 selbst gegenlesen, wenn Tiefenpruefung gewuenscht) | JA behauptet; von dieser SOLL-Karte NICHT gegen design91-v2 selbst verifiziert (Scope-Hinweis s.o.) |
| P-06 | I-1 "EINE Hash-Wahrheit sha512/ctsha512" + kanonische Formen, "KEIN neues Verfahren" (Ergebnis-Datei Abschn.2a) | Header-Grep nach zusaetzlichen/neuen Hash-Algorithmen | JA -- "kanonische Formen {canonical_combo, ceb_key_sha512, ctsha512} (KEIN neues Verfahren)" |
| P-07 | Invalidierung "Ergaenzung-ja/Kernbestand-bleibt" nach KON110-04 | Ledger KON110-04 (Zeile 862-867): "KUR VEN-CACHE-OEKONOMIE ... fehlende Permutationen werden im Lager ERGAENZT, der Kernbestand bleibt" | JA zitiert (Abschn.2a: "Invalidierung Ergaenzung-ja/Kernbestand-bleibt (KON110-04)") |
| P-08 | Verbund1-Skip "je-machine_id=true/global=false, Bau-Skip=true/Mess-Skip=false (V-10b)" | Ledger KON101-02 V-10b (Zeile 2068-2070): "no_extension erzeugt denselben Fingerprint ueberall ... Bau-SKIP JA, Mess-SKIP NEIN (Messwerte maschinengebunden...)" | JA, wortgleich uebernommen |
| P-09 | Genus-Namen Bestand 3/4 -- Owner-Namens-SCHEMA ist eigener, separater Entscheid: "das Namens-SCHEMA (was ein Ding IST) bleibt separater Owner-Entscheid" (Ledger KON112-09, Zeile 695) | Pruefen ob die neue Schema-Datei fuer Bestand 3/4 KEINE Genus-Namen erfindet, sondern per Nummer adressiert | JA -- "genus_token fuer Bestand 3/4 ABSICHTLICH LEER ... Schema adressiert ueber Bestand-NUMMER" (Abschn.2a); als F-95/F-97 im Findings-Bestand nachgefuehrt |
| P-10 | I-5 ist NICHT Gegenstand dieses Strangs -- Traeger D-4/#89 (W2-ABFOLGE-DESIGN.md:458, "Bau via D-2/D-4") | Kein I-5-Header im Diff erwartet (git-bestaetigt: keine Hybrid-Datei in den 10 Pfaden) | JA korrekt abgegrenzt -- "I-5 NICHT Gegenstand dieses Strangs (W2-C-Slot, eigener Bau-Agent)" (Abschn.1) |
| P-11 | I-2/I-7 = "Klasse C festschreiben" (W2-ABFOLGE-DESIGN.md:458-459); zusaetzlich E-2-Text: "I-2 Kanal-ID-Schema NUR FESTSCHREIBEN, Reihenfolge-Kanon wallclock/macro/micro V-13" (W2-ABFOLGE-DESIGN.md:450-455) | Datei `libs/cache_engine/include/cache_engine/measurement/kanal_id_schema.hpp` existiert; kein Kollektor/Kanalwerk-Implementierung (die bleibt Bau-Posten) | JA -- Datei gebaut (git-bestaetigt, 137 Z.); Kollektor-Bau ausdruecklich NICHT Teil (s. NICHT-GEFORDERT) |
| P-12 | I-2 Hierarchie "{achse, genus, kategorie}, Tiefe 3" nach KON110-02 | Ledger KON110-02 (Zeile 814-816): "jedes ACHSEN-Interface = eigener Kanal -> gebuendelt in GENUS-Interface-Kanaele -> gebuendelt in w-CEB-AUFRUF-PATTERN" | JA -- exakter Drei-Ebenen-Match (Abschn.3, (3.1)) |
| P-13 | V-13-Kanon: Owner-Wort woertlich "Es wird nur die Reihenfolge wallclock/macro/micro erlaubt, alles andere ist syntaktisch falsch, bitte mit umstellen." (Ledger KON101-01, Zeile 2037-2038) + Konsequenz KON101-02 (Zeile 2075-2078): "STAERKER als Kanonisierung ... jede andere Permutation ist SYNTAKTISCH FALSCH (Wurf, keine stille Normalisierung)" | Header-Konstante `kEbenenKanon`/`ist_kanon_reihenfolge` gegen den Objekt-Text `mess_axes/measurement_tooling_registry.hpp` (ids "wallclock"/"macro"/"micro", Index==Wert) | JA -- "kEbenenKanon {wallclock, macro, micro} + Owner-verbatim-V-13-Doktrin ... Wurf, KEINE stille Normalisierung" (Abschn.3, (3.2)) |
| P-14 | B-19: "Anordnungs-Freigabe je Stufe Subset {W,Ma,Mi}" (Wellenplan:2448-2449); Ledger KON37-03: "jede Stufe traegt ein SUBSET der 3 compile-time-Einrichtungen" | CT-Pruefer muss echte Teilfolgen als GUELTIG akzeptieren (nicht nur die volle 3er-Kette) | JA -- "Teilmengen nach B-19 erlaubt" + Test "Pruefer-Positiv Teilfolgen/B-19" (Abschn.2/Tests) |
| P-15 | `ist_kanon_reihenfolge` als "DEFINITIONS-Seite des #99/B-5f-Durchsetzungs-Traegers (die drei Validierungs-STELLEN baut #99, nicht dieser Strang -- nicht doppeln)" (Ergebnis-Datei Abschn.3) | Grep im Diff: KEINE Aenderung an den drei tatsaechlichen Validierungs-Aufrufstellen (ceb_tooling_list o.ae.) | JA -- nur Definitions-Konstante gebaut, Validierungsstellen ausdruecklich nicht angefasst (Bestands-Pflicht beachtet) |
| P-16 | `KanalDeskriptorIx = uint32` (R1, kein Text im Hot-Path); "Reserviert=3-Doktrin (NICHT still an Hybrid, LESEFALLE HY-0, Traeger HY-C)" (Ergebnis-Datei Abschn.3, (3.4)) | Typgleichheit gegen `MessCheckpointZeile`/`mess_arena.hpp` (`deskriptor_ix u32`); Test soll pruefen dass Reserviert=3 NICHT stillschweigend interpretiert wird | JA -- Mutationsprobe M2 (kMessEbeneOrdinalReserviert 3->2) erzeugt echtes CT-ROT (Abschn.7); HY-0-Entscheid selbst ausdruecklich NICHT getroffen (Traeger HY-C) |
| P-17 | I-7: "in Kraft gesetzt ... der Festschreib-TRAEGER ist das W2-Skelett selbst" (Ergebnis-Datei Abschn.3); Mechanismus nach Ledger KON112-09 (Zeile 694): "Registry-Deklaration MEHRERER Begriffe, compile-time als DASSELBE aufgefasst/umbenannt; UEBERSETZEN = REGRESSION = CT-FEHLER; Code-Adapter nur als Paper-Original-AUSNAHME; XML = WAS/WO/WANN, NIE WIE." | Datei `naming/begriffs_alias_registry.hpp`; `kanon_of`-Funktion muss bei unbekanntem Begriff CT-Fehler werfen (nicht RT) | JA -- "Uebersetzen = consteval kanon_of (unbekannter Begriff = CT-Fehler, R-2); RT-Suche ... liefert nullptr (nie still)" (Abschn.2b) |
| P-18 | I-7 ANWENDUNGS-KANDIDATEN "(Reihung): (1) SPARSE_NODE4_ART/node4 ...; (2) compare/macro/micro == w/ma/mi (KON112-01c); (3) Stufe*/Verbund*-Uebergang bei B-2." (Ledger KON112-09, Zeile 695) | Registry muss GENAU diese drei Kandidatenklassen abdecken, nicht mehr/weniger als Skelett-Erst-Eintraege | JA -- 7 Erst-Eintraege: node4 (1x) + w/ma/mi+compare-Dualitaet (4x) + Verbund-Uebergaenge Stufe1_CeOnly->Verbund1_CeOnly/fulljoin->union (2x) = alle 3 Kandidatenklassen bedient, keine ueberzaehlige |
| P-19 | "M13-/M6-Skelette (W2-D) mitziehen." (W2-ABFOLGE-DESIGN.md:462) | Beide Skelett-Dateien im Diff vorhanden | JA -- naming/begriffs_alias_registry.hpp (M13, deckungsgleich mit P-17/P-18) + traeger/ceb/.../parameter_filter_registry.hpp (M6) |
| P-20 | M6 = "PARALLELE CACHE-ENGINE-REGISTRY FUER PARAMETER-FILTER -- EXISTIERT NOCH NICHT (Bau-Posten). Erster Filter = KUERZESTE GESAMTZEIT als Erfolgs-Filter fuers Ranking ... AUFGABE: Katalog anlegen, AEHNLICH dem Registry-Achsen-Katalog eines Prueflings." (Ledger KON110-03/RF-B, Zeile 827-833) | Datei existiert unter `traeger/ceb/`, GENAU 1 Katalogeintrag, Vorbild `heuristik/axis_optimization_catalog.hpp` NUR gelesen (nicht veraendert) | JA -- "GENAU 1 Eintrag = Filter 1 'kuerzeste_gesamtzeit' an Impact-Rang 1" (Abschn.2c); `heuristik/` git-bestaetigt unberuehrt |
| P-21 | M6 = "ERSTE `<traeger/ceb/...>`-Include-Wurzel nach R5" (Design #29 Par.4.3, zitiert Ergebnis-Datei Abschn.2c); R5: "neue traeger/-Projekte erben KEINE Alt-Wurzeln" | `libs/traeger/ceb/CMakeLists.txt` traegt `target_include_directories(comdare_ceb INTERFACE include/)`-Erweiterung | JA -- CMakeLists.txt geaendert (git-bestaetigt: M libs/traeger/ceb/CMakeLists.txt), eigener Test "Include AUSSCHLIESSLICH ueber LIBRARIES comdare_ceb = Bauweg-Beweis der neuen Include-Wurzel" |
| P-22 | I-8: "vor Kampagne (empfohlen im W2-Schema-Zug, D-2)" -- NUR Bedarfsliste, KEIN Schema-Bau (W2-ABFOLGE-DESIGN.md:459-460); F-95/G-2 (STAFFEL2-SYNTHESE.md:185,232-235): "FRIST: VOR Kampagne Sa 29.08. (Spalten nicht nachtraeglich erhebbar)" | Ergebnis-Datei Abschn.4 muss 3 konkrete Feld-Bedarfe benennen; KEIN XSD/Header fuer die Felder selbst im Diff | JA -- 3 Punkte (kanal_tag, zustands_dimension, machine_id/platform als lesbares Feld) + "KEIN XSD/Schema selbst geaendert" (Abschn.4, korrekt: kein I-8-Feld im 10-Pfade-Diff) |
| P-23 | K-07: "haengt sie an der AxisKind-Entscheidungsklasse ('Owner-Satz VOR Merge', K1=F1-PUSH-SPERRE)?" (W2-ABFOLGE-DESIGN.md:668-669) | `topics/axis.hpp` AxisKind-Landung pruefen (static_assert-Zeilen, Enum-Reihenfolge) gegen Ledger KON101-01/-02 (V-01R Owner-Satz) | JA beantwortet mit NEIN -- axis.hpp:39/:46/:54/:96 zitiert (Abschn.5); zusaetzlich durch juengere Ledger-Schicht KON120-06 Pkt.2 (22.08., Zeile 171-172) bestaetigt: "AxisKind-Drehung owner-angeordnet+gebaut+gelandet (94095eda, Ancestor 66de5c09)" |
| P-24 | "#91-Identitaets-Entscheide n* (kein woertliches 'Owner' im Task-Text)." (W2-ABFOLGE-DESIGN.md:676-677, QUELLE K1:34 -- eigener F-V-Punkt, NICHT identisch mit K-07) | Pruefen ob der Strang fuer JEDEN I-Punkt eine eigene Owner-/KON-Quelle nachweist (statt pauschal "kein Owner-Wort noetig") | JA -- "Jeder I-Punkt traegt sein EIGENES Owner-/KON-Wort (A2.3a-Probe)": I-1 KON110-04+KON101 V-09R/V-10b, I-2 KON101-01 V-13, I-5 KON112-08 (D1-Farben=Design-Vorschlag, ausserhalb), I-7 KON108-02/KON113-03, I-8 Klasse-C additive Spalten (Abschn.5, Pkt.2) |
| P-25 | Frist Mi 26.08. 06:00: "Frist Mi 26. -- danach werden Identitaets-Umbauten teuer." (W2-ABFOLGE-DESIGN.md:460); "(Identitaet vor Mi billig)" (W2-ABFOLGE-DESIGN.md:772) | Commit-Zeitstempel des Branch-Tips vs. Trigger-Termin | JA -- Commit 21.08.2026 12:06 UTC (git-bestaetigt), weit vor Mi 26.08. 06:00 |
| P-26 | 4 neue Tests unterliegen TDD-Vertrag T-1 ("Rot gesehen, dann zurueckgenommen", Designplan-tdd:67), T-3 ("Nenner ... aus einer anderen Quelle als dem Pruefling", Designplan-tdd:69), T-4 ("Gegeneingang", Designplan-tdd:70), T-7 ("existiert erst, wenn er in ctest -N erscheint und sein Binary im Bauweg haengt", Designplan-tdd:73), T-11c ("je neuem Test >=1 Wegwerf-Mutation mit literalem Rot + Gegenprobe-Gruen", Designplan-tdd:647-648) | ctest -N-Sichtbarkeit; Mutationsprotokoll mit Vorher/Nachher-Bilanz | JA fuer alle 5: 4 Tests #511-514 in ctest sichtbar; je 1 Wegwerf-Mutation mit literalem ROT (M1 RT, M2 CT, M3 RT 2x, M4 CT), alle revertiert, Endstand 4/4 Passed (Abschn.7); Nenner explizit "FREMDQUELLIG" (Par.62-B-Genus, Tooling-ids, NodeSparseNode4Art::tag, kExperimentAxisMergeModes, MessEbene) |
| P-27 | T-7-Registrierungskonvention + eigene REGELN: "tests/unit/CMakeLists.txt NUR ans DATEIENDE" | Diff-Position der neuen Test-Bloecke in tests/unit/CMakeLists.txt | JA -- "als EIN Block am DATEIENDE ... registriert (T-7; Kollisionsschutz-Konvention)" (Abschn.2, Tests) |
| P-28 | TABU-Flaechen unberuehrt: axes/, topics/, heuristik/, golden-Dateien byte-stabil, .gitlab-ci.yml nur mit ausdruecklichem Auftrag (eigene REGELN) | `git show --name-status 6713156b` gegen diese Pfade | JA -- 0 Treffer unter axes/topics/heuristik/golden/.gitlab-ci.yml (git-bestaetigt: alle 10 Pfade unter libs/cache_engine/include, libs/traeger/ceb, tests/unit) |
| P-29 | clang-format-22-CI-Formel-Paritaet ueber jede geaenderte Lint-Datei (eigene REGELN) | `scripts/vor_push_alle_wachen.sh --nur=format`-Ausgabe | JA -- "GRUEN '2355 Dateien Vollmenge / 1937 geprueft, davon 0 abweichend'" nach `clang-format-22 -i` ueber 4 zuerst abweichende Dateien (Abschn.7); eigene Falle erkannt (Erstlauf vor `git add` = falsches Gruen, als F-99 dokumentiert) |
| P-30 | ASCII-only in neuen Zeilen (eigene REGELN) | ASCII-Gegenprobe ueber alle neuen/geaenderten Zeilen | JA -- "alle 9 neuen/geaenderten Dateien nonascii=0, Zeilen>120B=0" (Abschn.7; Anmerkung: 9 vs. 10 Pfade, da tests/unit/CMakeLists.txt als reine Anhaenge-Aenderung separat gezaehlt sein duerfte -- keine Widerspruch, nur Zaehl-Nuance) |
| P-31 | Bau-Slot-Protokoll + Vollbau-Treppe (J-0b -> J-1 SIEBEN Werkzeuge -> RE-CONFIGURE -> all -> facade -> comdare_tests -> ctest --no-tests=error, Bilanz literal) (eigene REGELN) | Bauslot-Verzeichnis (falls noch vorhanden) + ctest-Bilanz-Zitat | JA fuer die Bilanz: "100% tests passed, 0 tests failed out of 514" (Abschn.7); ABER: Werkzeug-Roster-Abweichung -- s. SPANNUNGEN Nr. 3 |
| P-32 | Push-Sicherung "git push -o ci.skip origin bau/vollzug91" + Commit-Trailer "Co-Authored-By: Claude Fable 5" (eigene REGELN) | `git log`/`git show` auf dem Branch-Tip | JA -- beides git-bestaetigt (Trailer im Commit; "[new branch]"-Push-Beleg im Bericht, Abschn. ENDSTAND) |

--------------------------------------------------------------------------------
## ABNAHME-FORMELN (woertlich)

1. **E-3-Kernformel** (W2-ABFOLGE-DESIGN.md:463-464): *"ABNAHME: Buchung completed; je
   I-Punkt Vollzugs-/Festschreib-Beleg; Skelette gebaut."*
2. **E-3-Volltext-Rahmen** (W2-ABFOLGE-DESIGN.md:456-464): *"E-3 #91-VOLLZUG: Design KOMPLETT
   (design91-v2, docs/plaene, 0778c6ef -- referenzieren, NICHT neu entwerfen). Offen NUR: (a)
   completed-Buchung im Ledger (b) Identitaets-Entscheide vollziehen: I-1/I-5 = Klasse B 'W2
   entscheiden+bauen' (mechanisch entschieden; Bau via D-2/D-4), I-2/I-7 = Klasse C
   festschreiben, I-8 vor Kampagne (empfohlen im W2-Schema-Zug, D-2). Frist Mi 26. -- danach
   werden Identitaets-Umbauten teuer. K-07-Pruefhinweis (moeglich owner-gated, AxisKind-Klasse)
   -> [F]-Pruefblock. M13-/M6-Skelette (W2-D) mitziehen."*
3. **Slot-Einordnung** (W2-ABFOLGE-DESIGN.md:826-827, TEIL 3 SLOT [E]): *"S3 E-2 #90 + E-3 #91
   (Design/CT, kein Vollbau)"* -- s. SPANNUNGEN Nr. 2 zur Auslegung.
4. **K-07-Frage woertlich** (W2-ABFOLGE-DESIGN.md:668-669): *"K-07/#91-Identitaetsklasse:
   haengt sie an der AxisKind-Entscheidungsklasse ('Owner-Satz VOR Merge', K1=F1-PUSH-SPERRE)?"*
5. **Board-Task-Wortlaut bei Anlage** (Ledger KON113-03, Zeile 618-619): *"#91
   (Unifikations-Designplan M0-M14; Par.75-Sperre faellt erst MIT Design; Identitaets-Entscheide
   vor Mi 26.08.)"*
6. **Modul-Zuordnung M0-M14** (W2-ABFOLGE-DESIGN.md:844, K4-Gegenzaehlungstabelle): *"TEIL2 (15
   Module + I-1..I-8): -> E-3 (Vollzug/Buchung), D-2 (M10/I-1, I-8), D-4 (M14/I-5), E-2 (M2/I-2),
   D-13/#88-Skelette (M6,M13), G (M0,M3..M9,M11,M12-Rest nach Trigger; 2d-Liste komplett als
   G-/Nach-Trigger-Pointer)."* -- definiert die Grenze zwischen E-3-Skelett-Bau und "G"
   (Nach-Trigger, ausserhalb W2).
7. **Owner-Verbatim V-13** (Ledger KON101-01, Zeile 2037-2038): *"V-13: Es wird nur die
   Reihenfolge wallclock/macro/micro erlaubt, alles andere ist syntaktisch falsch, bitte mit
   umstellen."*
8. **Owner-Verbatim V-01R (K-07-Grundlage)** (Ledger KON101-01, Zeile 2020-2024): *"V-01R: Das
   AxisKind Enum bezeichnet einfach nur compile time um Welche Mess-Achsen-kategorie es sich bei
   einer Achse handelt also Mess/System/Organ. [...] Daher definitiv mit drehen, sonst ergibt es
   keinen Sinn."*
9. **R-2/I-7-Mechanismus** (Ledger KON112-09, Zeile 694): *"Registry-Deklaration MEHRERER
   Begriffe, compile-time als DASSELBE aufgefasst/umbenannt; UEBERSETZEN = REGRESSION =
   CT-FEHLER; Code-Adapter nur als Paper-Original-AUSNAHME; XML = WAS/WO/WANN, NIE WIE."*
10. **RF-B/M6-Filter-1-Formel** (Ledger KON110-03, Zeile 828-829): *"Erster Filter = KUERZESTE
    GESAMTZEIT als Erfolgs-Filter fuers Ranking."*
11. **TDD-Vertrag-Kernsaetze** (Designplan-tdd:67,69,70,73): T-1 *"Der Test ist am ersten Tag rot,
    ODER sein Biss ist per protokollierter Wegwerf-Mutation bewiesen (Rot gesehen, dann
    zurueckgenommen)."* T-3 *"Jeder Test nennt seine Grundgesamtheit und bezieht sie aus einer
    anderen Quelle als dem Pruefling."* T-4 *"Zu jeder Zusicherung ein Eingang, bei dem sie nicht
    gilt."* T-7 *"Ein Test existiert erst, wenn er in ctest -N erscheint und sein Binary im
    Bauweg haengt."*
12. **GOAL-v8-Nenner-Doktrin** (GOAL-V8-Dossier:640-642): *"Jede Abnahme traegt Nenner, Rot- und
    Gruen-Lauf, frisch gewuerfelten Koeder. Eine Welle ohne beissende Wache gilt als nicht
    abgenommen."*
13. **GOAL-v8 allow_failure-Verbot** (GOAL-V8-Dossier:763): *"`allow_failure: true` ist auf
    JOB-Ebene VERBOTEN."* (fuer #91 nur durch Abwesenheit relevant: kein neuer CI-Job, keine
    .gitlab-ci.yml-Beruehrung im Diff -- Gate nicht getroffen, nicht verletzt.)

--------------------------------------------------------------------------------
## NICHT-GEFORDERT (ausdrueckliche Nachfolge-Zuege -- kein Phantom-Fund, wenn hier fehlend)

- **Alte #91-Lesart "PHASE 0"** (Wellenplan:1540-1587, Planer-Kopf/`ExperimentPlanDirector`
  vs. `v32_messreihe_antrieb.hpp`-Duplikat-Sorge): geschlossen/gegenstandslos laut Ledger:11177
  ("Task #91 (PHASE 0 als Blocker) ist damit gegenstandslos und wird geschlossen"). Diese
  Aufgabe hat NICHTS mit Planer-Kopf-Verdrahtung zu tun; ein Audit-Fund "Planer-Kopf nicht
  angefasst" waere ein Phantom.
- **I-5 (Hybrid-Identitaet)**: explizit Traeger D-4/#89 (W2-C-Slot, eigener Bau-Agent), NICHT
  dieser Strang (W2-ABFOLGE-DESIGN.md:458; Ergebnis-Datei Abschn.1).
- **I-1 Lager-MECHANIK** (Factory-Erweiterung, N2-Schreibweg, Invalidierungs-Implementierung,
  Verbund1-Skip-LOGIK): bleibt vollstaendig D-2/#57(7)-(9) (Di-25-Buendel). Nur das CT-SCHEMA
  ist hier Gegenstand (F-96/F-97/G-2 im Findings-Bestand bestaetigen diese Grenze).
- **I-8 Feld-EINBAU** (kanal_tag, zustands_dimension, machine_id/platform als reale Spalten in
  Bestand 2/3, inkl. XSD-Aenderung): NUR die Bedarfsliste ist hier Gegenstand; der eigentliche
  Bau ist G-2 im W2-Schema-Zug, Frist VOR Kampagne Sa 29.08. (STAFFEL2-SYNTHESE.md:232-235,
  F-95).
- **M13-/M6-FUELLUNG** (zusaetzliche Alias-Eintraege ueber die 7 Erst-Eintraege hinaus;
  zusaetzliche Filter ueber "kuerzeste_gesamtzeit" hinaus; XML-Kriterium-Token): "nach Trigger"
  (#88), ausdruecklich NICHT hier (Ergebnis-Datei Abschn.2c: "Fuellung/#88 ... EXPLIZIT NICHT
  hier"; STAFFEL2-SYNTHESE.md:312).
- **Module M0, M3-M5, M7-M9, M11, M12(Rest)**: laut K4-Gegenzaehlungstabelle (W2-ABFOLGE-
  DESIGN.md:844) Traeger "G" = nach Trigger, ausserhalb W2 und ausserhalb dieses Strangs.
- **Kollektor-/Kanalwerk-Implementierung** (die tatsaechliche Verwendung von
  `kanal_id_schema.hpp` durch einen Sammler): "Kollektor-Bau NACH Trigger, #53-gated je Achse
  (Owner-Vorlagen)" (STAFFEL2-SYNTHESE.md F-94). I-2 liefert nur die CT-Festschreibung, keinen
  Konsumenten.
- **#99/B-5f-Validierungsstellen** (die drei tatsaechlichen Aufrufstellen, die
  `ist_kanon_reihenfolge` durchsetzen sollen): "baut #99, nicht dieser Strang -- nicht
  doppeln" (Ergebnis-Datei Abschn.3).
- **HY-0/Reserviert=3-Entscheid** (ob/wie die 4. Hybrid-Ebene den reservierten Ordinalwert
  nutzt): bleibt "Traeger HY-C", nur die LESEFALLE wird offengehalten, nicht entschieden
  (Ergebnis-Datei Abschn.3, (3.4)).
- **hardware_identitaet/machine_id-Harmonisierung** (Vereinigung der zwei Begriffe zu einem
  Feldnamen, oder M13-Alias-Eintrag dafuer): D-2-Fenster-Entscheid, hier nur als "BEIDE verbatim
  uebernommen" dokumentiert, nicht aufgeloest (F-96).
- **R-2-Namens-SCHEMA** (wie Bestand-3/4-Genus-Typen tatsaechlich HEISSEN): Owner-Vorlage an
  der ersten Neu-Benennung im D-2-Fenster (KON112-09; F-97) -- ausdruecklich NICHT hier
  entschieden.
- **Owner-gated-Restposten**, vom Strang selbst als ausserhalb deklariert (Ergebnis-Datei
  Abschn.5): #53-Achsen-Vorlagen je Achse VOR Kollektor-Bau, [OG-20]-POD-Haelfte, #71-Zeile
  T-vs-T-4-Vorlage.
- **T-12d/FJ-1..FJ-10 "Full-Join-Schema-Tests"** (Designplan-tdd:695-703): behandeln die
  xlsx-Spalten-Union (Spalten-Union mi->ma an golden-Daten), ein ANDERER Gegenstand als M13s
  `fulljoin->union`-Umbenennung der `PrueflingVerbundStrategy`. Ledger-Abgrenzung wortgleich
  (Zeile 662-664): *"FJ-1..FJ-10 (KON94-01) betreffen Ueberladung (C) Spalten-Union mi->ma,
  NICHT diese Modi"* (gemeint: die Phasen-/Verbund-Modi replace/merge/fulljoin). Kein
  T-12d-Bezug fuer #91.
- **completed-Buchung selbst** (tatsaechliches Schreiben in Ledger/Board): Lead-only; der
  Strang liefert nur den Entwurf (Abschn.6). Diese SOLL-Karte tut dasselbe -- kein
  Ledger-Schreibzugriff.

--------------------------------------------------------------------------------
## SPANNUNGEN (Widersprueche zwischen Quellen -- nicht glattgezogen)

1. **Task-Nummer-Wiederverwendung "#91"**: Der Wellenplan traegt an ZWEI Stellen
   unterschiedliche Gegenstaende unter derselben Nummer. AELTERE Schicht (08.08.-Grundtext,
   Wellenplan:1540-1587, §13.4(a)): *"#91 PHASE 0 -- Blocker vor der
   Selbstkompilations-Strecke"* (Planer-Kopf/`ExperimentPlanDirector`-Duplikat-Sorge, KEIN
   Wellen-Platz, Empfehlung "(A) Stempel ja, Selbstkompilation nach W7"). JUENGERE Schicht
   (17.08. nachts, Wellenplan:2780-2786, §20.8 + Ledger KON113-03): Board-Neuanlage *"#91
   Unifikations-Designplan M0-M14 (Par.75-Sperre faellt erst MIT diesem Design)"*. Die aeltere
   Lesart ist im Ledger explizit *"gegenstandslos"* erklaert und geschlossen (Ledger:11177,
   nach Verdrahtungs-Nachweis von `ExperimentPlanDirector`). Nach der Rangfolge "juengere KON
   vor Wellenplan par.17-20" gilt die M0-M14-Lesart als einzig gueltiger Referent fuer diese
   Aufgabe -- ein Audit, das gegen §13.4(a) prueft, prueft gegen den falschen Gegenstand.

2. **"kein Vollbau" (Slot-Text) vs. tatsaechlicher Vollbau (Strang-Ausfuehrung)**: TEIL-3-
   Parallelisierungskarte weist E-3 den Slot *"Design/CT, kein Vollbau"* zu
   (W2-ABFOLGE-DESIGN.md:826-827). Der Strang-Bericht dokumentiert dagegen einen kompletten
   Bauslot-Zyklus (Abschn.7: `slot2.d` atomar genommen, J-0b/J-1-Siebentreppe, RE-CONFIGURE,
   `all`, `comdare_profile_run_facade`, `comdare_tests`, `ctest --no-tests=error` mit
   "514/514"-Bilanz -- exakt die in meinen REGELN definierte "Bau-Treppe"). Das ist keine
   Regelverletzung im Sinne der Sache (T-7/T-11c verlangen literale ctest-Bilanz und
   Wegwerf-Mutationen, die ohne Kompilieren nicht moeglich sind; das GOAL-v8-Nennerprinzip
   verlangt ebenso einen Gruen-Lauf als Abnahme-Bestandteil), aber die woertliche
   Slot-Klassifikation "kein Vollbau" widerspricht dem literalen Bauslot-Protokoll. Auslegung
   fuer das Audit: "kein Vollbau" bezieht sich vermutlich auf die grosse
   Lager-/Hybrid-Feature-Integration (D-2/D-4), nicht auf die zum Nachweis der neuen
   CT-Header/Tests noetige Kompilier-Probe -- aber das ist eine Auslegung, keine belegte
   Deckung; das Audit sollte diese Spannung selbst benennen, nicht glattziehen.

3. **J-1-"SIEBEN Werkzeuge"-Roster-Abweichung**: Meine eigenen REGELN (identischer
   Prozessvertrag fuer diese S2-Staffel) nennen als J-1-Siebentreppe: `comdare_adhoc_emitter_cli
   comdare_anatomy_codegen_cli comdare_axis_registry_gen comdare_catalog_codegen_cli
   comdare_measurement_axis_registry_gen comdare_overlay_source_hash_gen
   comdare_system_axis_registry_gen`. Der Strang-Bericht (Abschn.7) nennt dagegen
   `comdare_adhoc_emitter_cli, comdare_anatomy_codegen_cli, comdare_catalog_codegen_cli,
   comdare_axis_registry_gen, comdare_system_axis_registry_gen,
   comdare_measurement_axis_registry_gen, comdare_axis_version_lock` als "SIEBEN" -- OHNE
   `comdare_overlay_source_hash_gen`, DAFUER MIT `comdare_axis_version_lock`. Objektbefund
   (23.08., read-only): BEIDE Targets existieren real (`tools/overlay_source_hash_gen/
   CMakeLists.txt:44` bzw. `tools/axis_version_lock/CMakeLists.txt:10`, beide
   `EXCLUDE_FROM_ALL`). `comdare_axis_version_lock` ist zusaetzlich als expliziter
   Test-Abhaengigkeits-Anker eines VORBESTEHENDEN, unabhaengigen Tests verdrahtet
   (`tests/unit/CMakeLists.txt:1976`: `add_dependencies(test_s14_axis_version_lock_tripwire
   comdare_axis_version_lock)`) -- das legt nahe, dass es beim `comdare_tests`-Bauschritt als
   Nebeneffekt einer BESTEHENDEN Testabhaengigkeit mitgebaut wurde, nicht zwingend als Teil der
   generischen J-1-Vorkonfigurations-Treppe. Das Audit sollte am Bau-Log (falls
   `build-vollzug91/` noch vorhanden ist -- laut Bericht "steht noch", Entfernung erst nach
   gruen+gemergt) pruefen, welche 7 (oder 8) Werkzeuge tatsaechlich vor RE-CONFIGURE liefen,
   statt die Prosa-Aufzaehlung ungeprueft zu uebernehmen.

4. **Ledger-Aktualitaet: "#91 ... OHNE Traeger benannt" NACH der Landereif-Meldung**: Ledger
   KON120-07 (22.08. FRUEH, Lead-Eintrag, Zeile 99-100) fuehrt *"#91 (Unifikations-Designplan,
   Frist Mi 26.) + #86 (ORG-19-IO, Owner-GO 17.08.) OHNE Traeger benannt -- Buendel-Strang nach
   D-08-Explore-Rueckkehr."* Das ist ZEITLICH NACH dem Strang-Endstand LANDEREIF (21.08.,
   Ergebnis-Datei) UND nach STAFFEL2-SYNTHESE.md (ebenfalls 21.08., Statuszeile 22: "vollzug-91
   ... LANDEREIF"). Zum KON120-07-Zeitpunkt war der Branch `bau/vollzug91@6713156b` also
   bereits fertig+gepusht+gruen, aber der Lead-Ledger-Eintrag registriert #91 trotzdem noch als
   traegerlos. Das ist vermutlich ein Aktualisierungs-Verzug im Lead-Ueberblick (die
   Gesamtdoku-Sweeps laufen parallel zu den Bau-Straengen), keine inhaltliche Bau-Luecke -- aber
   das Audit sollte pruefen, ob der Branch inzwischen tatsaechlich in die Di-25-Landesequenz
   (D-13-Randslot laut K4-Tabelle) eingeplant/gemergt wurde, oder ob die formale
   Traeger-Zuordnung weiterhin fehlt. Ergaenzend, NICHT als Widerspruch: KON120-06 (22.08.,
   Zeile 171-172) bestaetigt unabhaengig und NACH allem oben die K-07-Antwort zusaetzlich
   ("AxisKind-Drehung owner-angeordnet+gebaut+gelandet, 94095eda, Ancestor 66de5c09") -- das
   staerkt P-23, wird hier nur der Vollstaendigkeit halber mitgefuehrt.

5. **"T-6"-Namensraum-Kollision**: mindestens drei verschiedene Gegenstaende heissen "T-6" in
   den Quellen. (a) Designplan-tdd T-6 "SCHWESTERPFLICHT" (Designplan-tdd:72): *"Jeder Fix und
   jeder Test sucht im selben Zug die Schwesterstelle."* (b) Wellenplan-Board-Task "T-6/K7b-3"
   (prt-art-roundtrip-SHA-Pin, ein CI-Pinning-Posten, W2-ABFOLGE-DESIGN.md:53-54, unrelated).
   (c) Eine konkrete Testdatei `test_t6_wachen_inventar.cpp`, die der Strang selbst als
   Objektbefund zitiert (Ergebnis-Datei Abschn.1, Zeile 46-47: zaehlt CI-gerufene `scripts/*.sh`
   + Top-Level-Jobs). Der Satz *"kein T-6-Nenner-Nachzug noetig (NE-16 unberuehrt)"* bezieht
   sich NUR auf Gegenstand (c) -- ein CI-Job-Zaehlwerk --, NICHT auf die TDD-Vertrag-Pflicht
   T-6/Schwesterpflicht (a). Das Audit darf diese beiden nicht verwechseln: die
   Schwesterpflicht-Frage ("wurden Schwesterstellen zu den 4 neuen Tests gesucht?") ist mit dem
   Satz "T-6-Nenner steht" NICHT beantwortet.
