# SOLL-KARTE -- Aufgabe #90 P-A Kanalwerk-/Arena-Designplan (E-2, W2-D-Slot)

Erhoben von: Sonnet-max-PLANUNGS-ERHEBER (Read-only), fuer den W2-Audit Fr 21.08.2026 (S2-Aufgabe
"kanalwerk"). Erhebungsdatum: 23.08.2026. Objekt-/Quellen-Snapshot des gepruefften Strangs:
ce/development 66de5c09, super-Ledger-Kopf KON119 (21.08. vormittags) -- dieser Snapshot wird als
SOLL-Basis fuer diese Karte gehalten, weil der Strang-Bericht selbst auf diesem Stand arbeitete.
Wo mein eigenes (spaeteres, read-only) Nachlesen den Stand seither veraendert fand, ist das unten
explizit als ZUSATZBEFUND markiert, NICHT stillschweigend in die SOLL-Zeilen eingemischt.

Wahrheits-Rangfolge angewandt: Owner-Wort (KON-Verbatims) > juengere KON > Wellenplan par.21-23 >
par.17-20 > Designplan-tdd > W2-ABFOLGE-DESIGN > Strang-Bericht. Alle Quellenzeilen sind an den
genannten Dateien nachgelesen (voll, wo verlangt: LEAD-ENTSCHEIDE 87/87 Z., Designplan-tdd-T-Block
Par.11-12 voll, Ledger-Abschnitte C-1..C-17/N-1..N-7 voll [Z.31647-32084], KON93/94/101/110/112/117
voll, das Deliverable selbst voll [414/414 Z.], design91-v2 die einschlaegigen Abschnitte voll).

--------------------------------------------------------------------------------------------------
## PRUEFLISTE

### P-01 -- Designplan MUSS geschrieben werden (die Auftragsgrundlage selbst)
- WAS: Owner (17.08., KON110-02, Ledger Z.822-824): "Dieser Prozess ist beschrieben - frische dein
  Gedaechtnis auf" -> "12W-Explore + gruendlicher Fable-5-max-Designplan PFLICHT vor dem Bau".
  KON110-06 (Ledger Z.906-908): "P-A KANAL-/ARENA-DESIGN (RF-A): 12W-Explore + Fable-max-Designplan
  der checkpoint_measure-Kanal-Hierarchie inkl. Klammer-Zusammenfuehrung -> Teil der ultracode-
  Gesamtkonsolidierung, danach eigener Design-Posten (#53-Umfeld)."
- WIE pruefbar: Datei `docs/plaene/20260820-DESIGN-90-kanalwerk-arena.md` existiert im super-Repo;
  `wc -l` = 414 (Deliverable-Zusage); Inhalt deckt Kanal-Baum-Destillat (Abschnitt 2).
- BEHAUPTET vom Strang: JA (Ergebnis-Datei Kopf: "Designplan GESCHRIEBEN"; Datei liegt, 414 Z.
  gegenlesbar).

### P-02 -- I-2 Kanal-ID-Schema MUSS FESTGESCHRIEBEN werden (Klasse C: nur Festschreibung, KEIN Bau)
- WAS: W2-ABFOLGE-DESIGN.md Z.450-451: "I-2 Kanal-ID-Schema NUR FESTSCHREIBEN, Reihenfolge-Kanon
  wallclock/macro/micro V-13". design91-v2 Z.460-474 (I-2-Eintrag) + Fix-2-Nachtrag Z.465-474:
  "[ID/FIX] fuer I-2 ist richtig (= Klasse C, vor Trigger nur festschreiben; Kollektor-Bau nach
  Trigger)." C-Klasse-Zaehlung: I-2, I-7, I-8 (design91-v2 Z.474/479).
- WIE pruefbar: Design-Dok Abschnitt 3 (3.1-3.6) vorhanden; Klassifikations-Zeile in Abschnitt 3
  ("Klassifikation nach design91-v2 (Fix 2): [ID/FIX] = vor dem Trigger NUR festschreiben") deckt
  sich woertlich mit design91-v2 Z.249-251.
- BEHAUPTET vom Strang: JA (Design-Dok Abschnitt 3, komplett; Ergebnis-Datei nennt "I-2-FESTSCHREIBUNG"
  als eigenen Abschnitt).

### P-03 -- V-13-Kanon (Reihenfolge wallclock/macro/micro) MUSS als einzig erlaubte Serialisierungs-
Reihenfolge festgeschrieben werden; jede Permutation = Wurf, KEINE stille Normalisierung
- WAS: Owner-Verbatim 17.08. (Ledger KON101-01, Z.2037-2038): "V-13: Es wird nur die Reihenfolge
  wallclock/macro/micro erlaubt, alles andere ist syntaktisch falsch, bitte mit umstellen."
  KON101-02 (Ledger Z.2075-2078): "V-13 CEB-LEGENDEN: STAERKER als Kanonisierung -- NUR die
  Reihenfolge wallclock/macro/micro ist erlaubt, jede andere Permutation ist SYNTAKTISCH FALSCH
  (Wurf, keine stille Normalisierung). ceb_tooling_list wird im Bruch (B-5f) auf Ordnungs-
  Validierung umgestellt; die permutierten Zwillings-Schluessel verschwinden dadurch klassenweise."
- WIE pruefbar: Design-Dok Abschnitt 3.2 vorhanden mit woertlichem Owner-Zitat + Durchsetzungs-
  Traeger benannt (Board-#99, B-5f, Di-25). Objekt-Gegenprobe (vom Design selbst zitiert, nicht neu
  zu bauen): `mess_arena.hpp:59` `MessEbene { Compare=0, Macro=1, Micro=2, Reserviert=3 }` deckt
  0/1/2 bereits w-vor-ma-vor-mi (Ordinale muessen nicht gedreht werden -- nur die SERIALISIERTE
  Form ist die Festschreibung).
- BEHAUPTET vom Strang: JA (Abschnitt 3.2 komplett inkl. Owner-Zitat + Objekt-Beleg).
- ZUSATZBEFUND (eigene Pruefung, ausserhalb des Strang-Berichts): der V-13-Kanon aus 3.2/3.3 wurde
  bereits vom PARALLELEN Strang vollzug-91 in `naming/begriffs_alias_registry.hpp` (ce
  `bau/vollzug91` @ 6713156b) exakt so gebaut (w->wallclock, compare->wallclock [Ebene-0-Dualitaet],
  ma->macro, mi->micro) -- Quelle STAFFEL2-SYNTHESE.md H-11 (Z.57-67). Das ist kein Pflichtpunkt
  DIESES Strangs, aber ein starker externer Konsistenz-Beleg fuer P-02/P-03.

### P-04 -- Ueberlauf-Politik-Nachzug MUSS Teil von #90 sein, OHNE neue Owner-Frage
- WAS: W2-ABFOLGE-DESIGN.md Z.451-452: "Ueberlauf-Politik-Nachzug = #90-Pflichtteil, KEINE
  Owner-Frage." design91-v2 A2.3a-NEIN-Probe K7 (Z.572-574): "Arena-Ueberlauf-Politik: KON93/94
  Owner-hart (harter Abbruch); T-NEU-1: OWNER>PLAN -- mess_arena-WEITERMESSEN ist NACHZUG-Pflicht
  im #90-Zug, keine Frage." [E 20.08., K7: OWNER/KON-WORT LIEGT.]
- WIE pruefbar: Design-Dok Abschnitt 4 (4.1-4.3) vorhanden; keine neue "Owner-Vorlage"-Zeile darin.
- BEHAUPTET vom Strang: JA (Abschnitt 4 komplett; Abschnitt 9 "stellt KEINE neue Owner-Frage").

### P-05 -- Harter Abbruch am RAM-Limit (KON93-02/KON94-02) MUSS als geltende Politik festgeschrieben
werden; das GEBAUTE "zaehlen+weitermessen" MUSS als zu heilender Bestand benannt werden
- WAS: Owner-Verbatim 16.08. (Ledger KON93-02, Z.2552-2554): "Die Kapazitaet wird auf 6GB
  festgesetzt (bitte explore ueber 10 Wochen) und ist statisch, sie kann zu Beginn eines
  Experimentes fuer die Reservierung auf dem Planer veraendert werden." KON93-02 Folgesatz
  Z.2561-2563: "Der Ueberlauf-Pfad bleibt per P2-Wort: harter Abbruch NUR wenn die Mess-Arena
  voll ist; das heute gebaute 'Ueberlauf zaehlen+weitermessen' ... ist in dieser Lesart zu heilen
  (stiller Datenverlust)." KON94-02 (Ledger Z.2485-2492, DREI SCHICHTEN AN ZWEI SPEICHERN): Schicht
  (3) "Kapazitaet 6GB STATISCH je MESS-PROZESS-Arena, voll = harter Abbruch (KON93; Abbruch-Semantik
  per Bestands-Doktrin: failed ohne Retry, Arena-Bestand persistieren)."
- WIE pruefbar: Design-Dok Abschnitt 4.1 (Chronologie C-6 -> KON93-02 -> KON94-02 -> UEBERHOLT-Marker)
  + 4.2 (FESTSCHREIBUNG 5 Punkte) vorhanden; Objekt-Belegzeilen `mess_arena.hpp:36-38/213/263-269`
  als "GEBAUT: ZAEHLEN, MELDEN, WEITERMESSEN" zitiert (zu heilender Bestand, nicht hier zu bauen).
- BEHAUPTET vom Strang: JA (Abschnitt 4.1-4.3 vollstaendig).

### P-06 -- Der TDD-Designplan-Wortlaut T-12c(3) MUSS als UEBERHOLT erkannt/verifiziert werden
(nicht neu behauptet, sondern AM OBJEKT des Designplans nachgelesen)
- WAS: Designplan-tdd Z.680-681 (T-12c(3), Original-Pflicht): "Ueberlauf = BEFUND: weiterlaufen +
  zaehlen + beim Auslesen melden." Designplan-tdd Z.686-693 (UEBERHOLT-MARKER 17.08.2026,
  KON99/KON100): "Pflicht (3) ... ist durch die JUENGERE Owner-Linie ueberholt -- KON93-02/KON94-02
  (P2-Owner-Wort 16.08. verbatim: 'Der harte Abbruch kann also nur am RAM Limit sterben, wenn die
  Mess-Arena voll ist'): volle Mess-Arena = HARTER ABBRUCH, failed ohne Retry, Arena-Bestand
  persistieren ... Der Koeder-Teil 'still verworfene Zeilen werden ROT' bleibt gueltig; der
  Weiterlauf-Teil ist zu ersetzen (Rangfolge OWNER > PLAN). Geltende Fassung: s13-Design
  20260817-DESIGN-s13-buendel-di25.md S13-05/S13-07."
- WIE pruefbar: `grep -n "UEBERHOLT-MARKER" docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-
  wellen.md` -> Treffer bei Z.686 (eigene Nachpruefung: Marker sitzt Z.686-693, unmittelbar NACH
  T-12c Z.676-684 -- die Strang-Zitatzeile "Z.676-690" trifft den Block, endet aber 3 Zeilen VOR dem
  tatsaechlichen Marker-Ende Z.693; inhaltlich ohne Abweichung, siehe SPANNUNGEN/Fussnote).
- BEHAUPTET vom Strang: JA ("T-12c(3)-UEBERHOLT-Marker VERIFIZIERT am Objekt: ... Z.676-690
  (Marker 17.08., geltende Fassung s13 S13-05/S13-07)").

### P-07 -- Kollektor darf NUR geschnitten (Schnittstellen/Ein-Ausgaenge definiert), NICHT gebaut
werden; Bau bleibt NACH dem Trigger, im #53-Strang
- WAS: W2-ABFOLGE-DESIGN.md Z.452-453: "Kollektor-BAU bleibt nach Trigger; #53-Umfeld-Kette pruefen,
  nicht isoliert bauen." KON110-06 (Ledger Z.906-908): "... Teil der ultracode-Gesamtkonsolidierung,
  danach EIGENER Design-Posten (#53-Umfeld)." design91-v2 Z.245-247: "[RT] fuer den Kollektor-BAU
  (nach 12W-Explore, #90-Designplan, #53-Strang)."
- WIE pruefbar: Design-Dok Abschnitt 7 (7.1-7.3) vorhanden, formuliert als Pflichten/Schnittflaechen
  OHNE Implementierung; Objekt-Gegenprobe bleibt nach dem Design unveraendert 0 Treffer fuer
  `kanal_baum|kanalwerk|channel_tree` (kein neuer Code in libs/); keine neue TU/kein neues Target in
  CMakeLists.txt aus diesem Strang.
- BEHAUPTET vom Strang: JA (Abschnitt 7 komplett; Kopf-Absatz Punkt 4 "Kollektor-BAU bleibt NACH dem
  Trigger, [RT] nach 12W-Explore, im #53-Strang"; Ergebnis-Datei bestaetigt "KEIN Vollbau").

### P-08 -- #53-Umfeld-Kette MUSS dokumentiert (nicht isoliert gebaut) werden
- WAS: W2-ABFOLGE-DESIGN.md Z.453: "#53-Umfeld-Kette pruefen, nicht isoliert bauen." KON110-06
  benennt #90 woertlich im "#53-Umfeld".
- WIE pruefbar: Design-Dok Abschnitt 8 vorhanden mit 5 konkreten Kopplungspunkten (PMC-Nenner
  KON65-03/F1, iw/ima/imi-Flags KON72-02, AND-Freigabe F-P8, Nenner-Doktrin dynamisch>32/NUR-S-19,
  Owner-Vorlage-je-Achse-Gate).
- BEHAUPTET vom Strang: JA (Abschnitt 8 komplett, 5 Punkte + Reihungs-Folgesatz).

### P-09 -- KEIN Bau-Slot / kein Vollbau fuer diesen Strang (design-only, Doku-/Read-only)
- WAS: Aufgaben-Steckbrief (Auftrag dieser Erhebung): "Kein Bau-Zweig (Doku-/Read-only-Strang)."
  W2-ABFOLGE-DESIGN.md Z.826-827 (TEIL 3, Slot [E]): "S3 E-2 #90 + E-3 #91 (Design/CT, kein
  Vollbau)."
- WIE pruefbar: `git worktree list` im ce- und super-Repo zeigt keinen kanalwerk-90-Branch/Worktree;
  kein Eintrag unter `~/.claude/jobs/5a19728e/tmp/bauslots/` fuer den kanalwerk-Strang.
- BEHAUPTET vom Strang: JA (Ergebnis-Datei Kopf: "Design-only: KEIN Worktree noetig ..., KEIN
  Vollbau, KEIN Bau-Slot belegt"; STAFFEL2-SYNTHESE.md Status-Tafel Zeile 3: "kein Branch ...
  kein Bau-Slot").

### P-10 -- E1-E11-Arena-Kette MUSS eingebettet werden (Traeger-Zuordnung, KEIN Doppel-Entwurf)
- WAS: KON94-02 (Ledger Z.2501-2503): "E11 NEU ('KON93-Kapazitaets-Vollzug', 5 Teilposten,
  E11.1-3 VOR E9) -- KEIN bestehender Posten E1-E10 traegt den Kapazitaets-Bau." W2-ABFOLGE-
  DESIGN.md D-1-Zug fuehrt die Kette als "E1-E11-Arena-Kette (E11=6GB; r5-C-1..C-17-Auflagen)".
- WIE pruefbar: Design-Dok Abschnitt 6 vorhanden (Tabelle E1-E11, Spalte Traeger/Status je Zeile,
  kein neuer Bau-Vorschlag, nur Zuordnung).
- BEHAUPTET vom Strang: JA (Abschnitt 6 komplett inkl. Tabelle + r5-C-1..C-17-Zuordnungssatz).

### P-11 -- Das Design darf KEINE neue Owner-Frage stellen (A2.3a-NEIN-Probe negativ fuer alle
Design-Entscheide dieses Dokuments)
- WAS: generelle Doktrin (A2.3a) + design91-v2 K7-Probe (s. P-04) + explizite Eigenzusage des
  Auftrags ("keine Owner-Frage").
- WIE pruefbar: Design-Dok Abschnitt 9 ("stellt KEINE neue Owner-Frage (K7-Probe: Ueberlauf-Politik
  durch KON93/94 entschieden; Klammer-Aufloesung liegt in der beauftragten Design-Autoritaet,
  5(a))"); Abschnitt 5(a) begruendet die Klammer-Spannungs-Aufloesung ausdruecklich als
  Design-Entscheid, nicht als neue Frage.
- BEHAUPTET vom Strang: JA.

### P-12 -- EISERNE REGEL: nichts unter axes/ topics/ heuristik/ anfassen
- WAS: bindende TABU-Regel (Auftrag dieser Erhebung + Design-Dok Abschnitt 9 selbst: "EISERNE
  REGEL: nichts unter axes/ topics/ heuristik/ ... axes-Aenderung = golden-Ereignis").
- WIE pruefbar: `git status`/Diff-Scope des Strangs zeigt NUR die eine neue Datei
  `docs/plaene/20260820-DESIGN-90-kanalwerk-arena.md`; keine Beruehrung von axes/, topics/,
  heuristik/ moeglich, da kein Code-Pfad angefasst wurde.
- BEHAUPTET vom Strang: JA implizit (SELBSTCHECK: "keine Datei ausser dieser hier geschrieben").

### P-13 -- ASCII-only in neuen Zeilen
- WAS: bindende Regel (Auftrag dieser Erhebung + Memory-Doktrin "ASCII+Selbstcheck").
- WIE pruefbar: `grep -nP "[^\x00-\x7F]" docs/plaene/20260820-DESIGN-90-kanalwerk-arena.md` sollte
  0 Treffer liefern.
- BEHAUPTET vom Strang: JA (Ergebnis-Datei: "ASCII-Gegenprobe 0 Nicht-ASCII-Zeilen"; Design-Dok
  eigenes SELBSTCHECK: "ASCII-only").

### P-14 -- Kanal-Adresse als Registry-konforme Token-Kette (Achse->Genus->w/PROFILER), NIE freier
Name; Kuerzel NIE flach gelesen (Grammatik-Wache je Position, Stempel-Syntax-Doktrin)
- WAS: KON110-02 (Ledger Z.814-816): "KANAL-HIERARCHIE: jedes ACHSEN-Interface = eigener Kanal ->
  gebuendelt in GENUS-Interface-Kanaele -> gebuendelt in w-CEB-AUFRUF-PATTERN." design91-v2 I-2:
  "Kanal-Adresse = Registry-konforme Tokens entlang Achse->Genus->w/PROFILER." Memory-Doktrin
  "STEMPEL-KUERZEL IMMER ZERLEGEN" (`cpe`=`c{p.e}`, NIE flach).
- WIE pruefbar: Design-Dok Abschnitt 3.1 vorhanden.
- BEHAUPTET vom Strang: JA (Abschnitt 3.1 komplett, inkl. Grammatik-Beispiel `pmc{c.{p.e}}.b.t`).

### P-15 -- ORG-19 (#86) MUSS als eigener Genus-Kanal im Kanalwerk registriert werden (Auflage,
NUR Design-Festschreibung -- Bau liegt bei #86)
- WAS: KON112-01 BAU-FOLGEN (Ledger Z.651): "ORG-19 MUSS als eigener Genus-Kanal im Kanalwerk
  registriert werden" (store()/load() erweitert das Genus-Interface). design91-v2 Z.230-232
  bestaetigt dieselbe Auflage ("#86, KON112-01").
- WIE pruefbar: Design-Dok Abschnitt 3.1 vorhanden ("ORG-19-Auflage (#86, KON112-01 BAU-FOLGEN):
  ... ORG-19 wird als EIGENER Genus-Kanal im Kanalwerk registriert -- die Adresse entsteht aus
  derselben Baum-Regel, kein Sonderpfad").
- BEHAUPTET vom Strang: JA (als Auflage benannt, korrekt NICHT als abgeschlossener Bau -- #86 ist
  ein eigener Board-Task).

### P-16 -- compare/macro/micro == w/ma/mi MUSS als Alias (M13-Registry), NICHT als Rename
festgeschrieben werden (I-7-Rangfolge: Alias VOR Rename)
- WAS: KON112-01(c) (Ledger Z.650): "Namens-Paar compare/macro/micro ... vs w/ma/mi -- Abbildung
  ist konsistent ..., Harmonisierung als ERSTER ANWENDUNGSFALL der R-2-Alias-Registry (KON112-09)."
  design91-v2 I-7 (Z.481-483): "Alias-vor-Rename-Rangfolge (M13): hiermit im Design festgeschrieben."
- WIE pruefbar: Design-Dok Abschnitt 3.3 vorhanden.
- BEHAUPTET vom Strang: JA (Abschnitt 3.3 komplett inkl. I-7-Rangfolge-Verweis).

### P-17 -- MessEbene::Reserviert=3 darf NICHT stillschweigend an die Hybrid-Ebene vergeben werden
(LESEFALLE HY-0 bleibt ein offener, EIGENER Entscheid fuer das HY-C-Design)
- WAS: Soll-Design Offener Punkt 3 (LESEFALLE HY-0, via KON112-01/KON110-02 referenziert): die
  4. Hybrid-Mess-Ebene (GO-3) ist ein ANDERER Gegenstand als der Filter-Rang.
- WIE pruefbar: Design-Dok Abschnitt 3.4 vorhanden ("FESTGESCHRIEBEN: der Enum-Wert Reserviert=3
  wird NICHT stillschweigend an die Hybrid-Ebene vergeben ... Bis dahin ist 3 reserviert und jede
  Verwendung ein Wurf").
- BEHAUPTET vom Strang: JA (Abschnitt 3.4 + Abschnitt 2 LESEFALLE-Absatz).

### P-18 -- I-8-Persistenz-Kopplung: Design MUSS das Kanal-Tag-Feld definieren; der FELD-EINBAU
selbst liegt im Schema-Zug (D-2/#57), NICHT in diesem Strang
- WAS: design91-v2 I-8 (Z.484-488): "Mess-Records tragen ab Kampagne Kanal-Tag, Zustands-Dimension
  ..., machine_id/platform-Tag. Spaetestens VOR der Kampagne Sa 29.08. wirksam, empfohlen im
  W2-Schema-Zug mit I-1."
- WIE pruefbar: Design-Dok Abschnitt 3.5 vorhanden, mit korrekter Abgrenzung ("der Feld-EINBAU
  laeuft im Schema-Zug (D-2/#57-Umfeld), nicht hier").
- BEHAUPTET vom Strang: JA (Abschnitt 3.5 komplett, Abgrenzung korrekt gezogen).

### P-19 -- Marker-Kandidaten MUESSEN BENANNT (nicht gesetzt) werden
- WAS: KON112-11(10) (Ledger Z.712): "Objekt-Nachzug (kein Doku-Marker): mess_arena.hpp
  Ueberlauf-Weitermessen -> KON93/94-Politik (harter Abbruch) im P-A-Zug." Design-Dok eigener
  Anspruch: "Marker-Kandidaten werden BENANNT, gesetzt werden sie im docs-/Lande-Zug."
- WIE pruefbar: Design-Dok Abschnitt 4.3 vorhanden (mess_arena.hpp-Kopfblock, stale
  Faktor-2-Kommentar, OP-1-Divergenz, MEASURESTORAGE-Plan-Ueberlauf-Absatz -- alle als KANDIDATEN,
  nicht als vollzogene Edits).
- BEHAUPTET vom Strang: JA (Abschnitt 4.3 komplett).
- ZUSATZBEFUND (eigene Pruefung): der stale Faktor-2-Kommentar (mess_arena.hpp:222-224) ist laut
  STAFFEL2-SYNTHESE.md H-14 (Z.78-79) BEREITS durch den Strang "messfenster" (S1 F-08) geheilt --
  "die kanalwerk-90-Notiz dazu ist damit erledigt." Kein Fehler des kanalwerk-Strangs (der Marker
  wurde korrekt nur BENANNT, nicht gesetzt); die Erledigung kam aus einem anderen, parallelen
  Strang. Die OP-1-Kommentar-Divergenz bleibt offen und zieht im S13-07-Umbau-Commit mit (H-14).

### P-20 -- Objekt-IST-Gegenproben MUESSEN am Objekt gemessen, nicht behauptet werden
- WAS: Bestands-Pflicht-Doktrin (Memory) + design91-v2-Praxis (jede M-Zeile mit IST-Beleg).
- WIE pruefbar: `grep -rniE "kanal_baum|kanalwerk|channel_tree" libs/ tests/` (ohne build/) gegen den
  genannten Objekt-Stand; `grep -rn PROFILER libs/cache_engine/mess/ libs/cache_engine/builder/
  measure_storage/`.
- BEHAUPTET vom Strang: JA (Abschnitt 1, "GEGENPROBEN (V0/V1, 21.08.): ... 0 Treffer"; explizit als
  Bestaetigung der design91-v2-M2-Zeile "Arenen gebaut; Kanalwerk 0 Treffer" bezeichnet).

### P-21 -- Vollzugsbilanz MUSS ERLEDIGT und OFFEN-MIT-TRAEGER sauber trennen
- WAS: implizite Sorgfalts-/Beweisdoktrin (jede Behauptung mit Traeger, kein Vermischen).
- WIE pruefbar: Design-Dok Abschnitt 10 vorhanden.
- BEHAUPTET vom Strang: JA (Abschnitt 10: 6 Punkte "MIT DIESEM DOKUMENT ERLEDIGT" (a)-(f) + 5 Punkte
  "OFFEN MIT TRAEGER", jeweils mit Traeger-Name).

### P-22 -- Deliverable MUSS letztlich im docs-Zug COMMITTET werden (Uebergabe an den Lead, nicht
Pflicht des kanalwerk-Strangs selbst zu vollziehen)
- WAS: STAFFEL2-SYNTHESE.md H-17 (Z.88-93): "kanalwerk DESIGN-90-docs-Commit (Botschaft liegt) ...
  DESIGN-90 muss VOR/mit vollzug91-Ledger-Buchung committed sein (I-2-Schema-Quelle)."
- WIE pruefbar: `git log --oneline -- docs/plaene/20260820-DESIGN-90-kanalwerk-arena.md` auf
  ce/super `development`.
- BEHAUPTET vom Strang: NEIN als "erledigt" -- der Strang liefert nur die FERTIGE Commit-Botschaft
  und uebergibt explizit an den Lead ("Lead: Datei im docs-Zug committen"); das ist SOLL-konform
  (kein Schreibrecht im Hauptklon fuer einen Design-only-Strang).
- ZUSATZBEFUND (eigene, read-only Pruefung im super-Hauptklon, 23.08.): Commit `5b5a818f`
  "docs(plaene): DESIGN #90/P-A Kanalwerk+Arena -- I-2 Kanal-ID-Schema FESTGESCHRIEBEN (Klasse C),
  Ueberlauf-Politik-Nachzug (KON93/94; TDD-Designplan-T-12c(3)-Wortlaut UEBERHOLT, Marker liegt),
  E1-E11-Einbettung, Kollektor-Schnitt (Bau NACH Trigger, #53-Strang)" liegt bereits auf
  `development` (Ahnenschaft zu aktuellem HEAD `cb38cc9f` bestaetigt per `git log --oneline --
  <Pfad>` auf dem ausgecheckten `development`-Zweig) und traegt die exakte, im Strang-Bericht
  vorgeschlagene Botschaft. Der Uebergabe-Punkt ist damit zum Erhebungszeitpunkt (23.08.) bereits
  vom Lead vollzogen -- das ist eine NACHTRAEGLICHE Tatsache ausserhalb des Strang-Berichts selbst
  (der den Stand vom 21.08. VOR der Landung beschreibt) und sollte vom Audit als "erfuellt", nicht
  als offene Luecke gefuehrt werden.

### P-23 -- (Lead-Territorium, NICHT Strang-Pflicht) Board-#90 -> completed-Kandidat + Ledger-Buchung
- WAS: Ergebnis-Datei "Offene Punkte": "Board-#90 -> completed-Kandidat (Abnahme E-2: 'Designplan
  fertig; I-2 festgeschrieben; Abhaengigkeit zu #53 dokumentiert' -- alle drei Teile liegen)."
- WIE pruefbar: Board-Zustand #90 (ausserhalb meines Lesezugriffs als Datei); Ledger-Nachtrag nach
  KON119 mit #90-Buchung (per Grep im aktuellen Ledger-Kopf, s. SPANNUNGEN unten).
- BEHAUPTET vom Strang: NEIN als vollzogen -- ausdruecklich als Uebergabe an den Lead formuliert
  (Board-/Ledger-Schreibrechte sind Lead-only, s. Auftragsregeln dieser Erhebung selbst). Gehoert
  NICHT in eine "Luecke" des kanalwerk-Strangs, wenn es beim Audit noch offen erscheint.

--------------------------------------------------------------------------------------------------
## ABNAHME-FORMELN (woertlich)

1. **W2-ABFOLGE-DESIGN.md Z.454-455 (die primaere, fuer den Strang bindende Formel):**
   "ABNAHME: Designplan fertig; I-2 festgeschrieben; Abhaengigkeit zu #53 dokumentiert."
   (QUELLE-Zeile davor: "QUELLE K1:32; K4:TEIL2 M2/I-2 + 2f W2-D; K2:Par.18.4-Kontext.")

2. **KON110-02 (Ledger Z.822-824), die auftraggebende Owner-Formel:**
   "Dieser Prozess ist beschrieben - frische dein Gedaechtnis auf" -> "12W-Explore + gruendlicher
   Fable-5-max-Designplan PFLICHT vor dem Bau (in der ultracode-Gesamtkonsolidierung enthalten)."

3. **design91-v2 K7-Probe (Z.572-574), Abnahme der Ueberlauf-Politik-Teilfrage:**
   "Arena-Ueberlauf-Politik: KON93/94 Owner-hart (harter Abbruch); T-NEU-1: OWNER>PLAN --
   mess_arena-WEITERMESSEN ist NACHZUG-Pflicht im #90-Zug, keine Frage."

4. **design91-v2 Z.249-251, Abnahme der I-2-Klassifikation:**
   "[20.08.v2, Fix 2] Etikett BESTAETIGT: [ID/FIX] fuer I-2 ist richtig (= Klasse C, vor Trigger
   nur festschreiben; Kollektor-Bau nach Trigger)."

5. **Designplan-tdd Z.692 (Rangfolge-Formel fuer die Ueberlauf-Heilung):**
   "Geltende Fassung: s13-Design 20260817-DESIGN-s13-buendel-di25.md S13-05/S13-07." (D.h.: #90
   DEFINIERT die Politik, S13-05/06/07 im D-1-Zug Di 25.08. BAUT sie -- das ist keine #90-Pflicht.)

6. **KON101-02 V-13 (Ledger Z.2075-2078), Abnahme-Formel des Reihenfolge-Kanons:**
   "NUR die Reihenfolge wallclock/macro/micro ist erlaubt, jede andere Permutation ist SYNTAKTISCH
   FALSCH (Wurf, keine stille Normalisierung)."

7. **Design-Dok Abschnitt 10 (Selbst-Abnahme des Strangs, deckt sich mit Formel 1):**
   "MIT DIESEM DOKUMENT ERLEDIGT: (a) Designplan P-A liegt (KON110-02-Pflicht); (b) I-2
   festgeschrieben (Abschnitt 3; Klasse-C-Vollzugsbeleg fuer E-3/#91); (c) Ueberlauf-Politik-Nachzug
   dokumentarisch vollzogen (Abschnitt 4; Bau-Traeger S13-05/06/07); (d) E1-E11 eingebettet
   (Abschnitt 6); (e) Kollektor-Schnitt gelegt (Abschnitt 7); (f) #53-Abhaengigkeit dokumentiert
   (Abschnitt 8)."

8. **Design-Dok Selbstcheck-Zeile (Abschnitt "SELBSTCHECK"):**
   "ASCII-only; keine Owner-Frage neu gestellt; keine Datei ausser dieser hier geschrieben; alle
   Zeilen-/Zahl-Angaben am Objekt bzw. an der benannten Quelle nachgelesen (Stand ce 66de5c09,
   21.08.2026)."

--------------------------------------------------------------------------------------------------
## NICHT-GEFORDERT (deklarierte Nachfolge-Zuege -- KEIN Phantom-Fund, wenn hier ungebaut)

- **Kollektor-BAU** (der eigentliche Code, der aus den zwei Arenen den Kanal-Baum macht): explizit
  NACH dem Trigger Mi 26.08. 06:00, im #53-Strang, nach 12W-Explore (Design-Dok 7.3, KON110-06).
  0 Treffer `kanal_baum|kanalwerk|channel_tree` am Objekt ist daher der KORREKTE Zustand nach diesem
  Strang, nicht eine Luecke des Strangs.
- **S13-05/S13-06/S13-07-Umbau am Code** (mess_arena.hpp auf harten Abbruch umstellen, virtuelle
  Thread-Slots, Deckel-Mechanik): Traeger ist der D-1-Zug (#18, Di 25.08.08.), s. Designplan-tdd
  UEBERHOLT-Marker + Design-Dok 4.2 letzter Satz ("Dieses Dokument definiert die Politik ...; es
  eroeffnet KEINEN zweiten Bau-Ort").
- **B-5f Ordnungs-Validierung** (ceb_tooling_list auf die V-13-Kanon-Reihenfolge pruefen, Code):
  eigener Board-Task #99 (Design-Dok 3.2: "Durchsetzungs-Traeger: B-5f ... = Board-#99 ... dieses
  Dokument definiert die Regel, #99 baut die Validierung -- nicht doppeln").
- **I-8-Feldeinbau** (Kanal-Tag/Zustands-Dimension/machine_id real in die Record-Struktur einbauen):
  Schema-Zug D-2/#57-Umfeld (Design-Dok 3.5; design91-v2 I-8).
- **mess_arena.hpp-Kommentar-Nachzug + MEASURESTORAGE-Plan-Marker SETZEN** (Code-Kommentare wirklich
  umschreiben, Doku-UEBERHOLT-Banner wirklich einfuegen): naechster docs-/Bau-Zug (Design-Dok 4.3:
  "Kein Doku-Marker, sondern Code-Kommentar-Nachzug im Umbau-Commit").
- **F-G1-4(b)-Klammer-Wrapper bauen**: bleibt Papier bis zum Kollektor-Bau (Design-Dok 5(b);
  KON112-12(9)).
- **Hybrid-Ebenen-Tag-Entscheid** (ob/wie MessEbene::Reserviert=3 fuer die Hybrid-Macro-Schicht
  vergeben wird): eigener, noch nicht getroffener Entscheid im HY-C-/GO-3-Design NACH Trigger
  (Design-Dok 3.4, 3.6).
- **Stapel-Kapazitaets-Formel-Erhebung** (Soll-Design Offener Punkt 4: die 64u-Test-Konstante ist
  kein Kanon): gehoert zum Kollektor-/S13-06-Umfeld (Design-Dok 3.6).
- **Zell-/POD-Haelfte des markierten Leerwerts**: S13-11, POD-Haelfte NUR nach [OG-20]
  (Design-Dok 3.6).
- **#53 PMC-Schwester-Design selbst** (Board #53, in_progress, owner-gated fuer BAU): NICHT Teil
  von #90 -- #90 dokumentiert nur die ABHAENGIGKEIT dazu (Design-Dok Abschnitt 8), baut/entscheidet
  #53 nicht mit.
- **Owner-Vorlage je Achse** (#53, "VOR Bau"): bleibt owner-gated und ausserhalb dieses Strangs
  (Design-Dok 8.5, 9).
- **Jede neue Owner-Frage**: A2.3a-Probe war fuer alle Design-Entscheide dieses Dokuments NEGATIV
  (K7 in design91-v2 fuer die Ueberlauf-Politik; die Klammer-Spannungs-Aufloesung in Design-Dok
  Abschnitt 5(a) ist ausdruecklich als Design-Entscheid deklariert, keine neue Frage).
- **Board-#90-Statuswechsel auf "completed" + Ledger-Buchung**: Lead-Territorium (Board/Ledger sind
  laut den Regeln dieser Erhebung selbst "Lead-only" zu schreiben); vom kanalwerk-Strang nur als
  Vorschlag/Uebergabe formuliert, nicht selbst vollzogen (s. P-23).
- **Der eigentliche docs-Commit**: war zum Zeitpunkt des Strang-Berichts (21.08.) explizit an den
  Lead uebergeben, nicht Strang-Pflicht (s. P-22; per Zusatzbefund inzwischen ohnehin erledigt).

--------------------------------------------------------------------------------------------------
## SPANNUNGEN (Quellen-Widersprueche -- benannt, nicht glattgezogen)

### S-1 -- Klammer-Default "nur innerste" (17.08., KON110-02) vs. C-1/N-4 "jede Ebene schreibt
IN/OUT" (08.08.) -- DIE zentrale, vom Auftrag selbst benannte Spannung
- SEITE A (08.08., Ledger N-4/C-1, Z.31687-31697/31850-31855): checkpoint_measure ist EINE
  uniforme Funktion; je Aufruf ZWEI Checkpoints (IN bei Interface-enter, OUT bei return), auf JEDER
  aktiven Ebene -- zwingend, weil sonst ein nie zurueckkehrender Aufruf UNSICHTBAR waere
  (N-6-Regression) und die C-9-Rekonstruktion ihre Stapel-Kanten verloere.
- SEITE B (17.08., KON110-02, Ledger Z.817-821): "KLAMMER-SEMANTIK: default wird NUR die INNERSTE
  checkpoint_measure-Klammer gemessen; umklammernde checkpoint_measure messen selbst immer groebere
  Ein-/Ausstiegspunkte eines Parameters ueber die inneren Klammern hinweg."
- KON112-01 selbst haelt beide Seiten fuer STEHEND und "designpflichtig, NICHT glattrechnen"
  (Ledger Z.650) und weist die Aufloesung ausdruecklich dem P-A-Designplan zu ("Aufloesungs-
  Kandidat C-13.3 ..., gehoert in den P-A-Designplan").
- WAS DER STRANG DARAUS MACHT (Design-Dok Abschnitt 5(a)): eine DREI-EBENEN-TRENNUNG (Einbau
  compile-time via CEB-Gates / Schreiben: JEDE eingebaute Ebene schreibt IN/OUT roh, N-4
  unveraendert / Auswerten: Klammer-Default ist eine reine AUSWERTE-Regel beim Kollektor). Der
  Strang erklaert das ausdruecklich als "Design-Entscheid, KEINE neue Owner-Frage" und beruft sich
  auf den KON110-02-Auftrag selbst als Design-Autoritaet dafuer.
- AUDIT-HINWEIS: Diese Aufloesung ist eine NEUE, vom Strang selbst formulierte Interpretation --
  beide Owner-Wortlaute bleiben zwar unangetastet stehen (wie gefordert), aber ob die
  Drei-Ebenen-Trennung tatsaechlich BEIDE Owner-Saetze operational erfuellt (insbesondere: verliert
  die Auswerte-Default-Regel wirklich keine N-6-Wache?), ist eine INHALTLICHE Design-Pruefung, die
  das Audit selbst fuehren sollte -- diese Karte transportiert nur, DASS die Spannung offen benannt
  UND eine Aufloesung vorgeschlagen wurde, nicht, dass die Aufloesung selbst schon extern verifiziert
  ist (Bau-Abnahme dafuer liegt sowieso erst beim Kollektor-Bau, Design-Dok 5(a) letzter Satz).

### S-2 -- Terminologie-Kollision "V-13": DREI verschiedene V-N-Zaehlungen im Korpus
- Wellenplan Par.6 "DER VERIFIKATIONSVERTRAG" (Z.945-960) zaehlt V-1 bis V-8 (Nenner/Koeder/
  Gate-Vollzug/Differenz-Beleg/Dual-Weg/Plan-Nenner/Fremder-Nenner/Gegenstand-statt-Ankuendigung) --
  eine Wachen-/Test-Doktrin fuer CI-Guards, geht NICHT bis V-13.
- Ledger KON101 (17.08.) zaehlt eine EIGENE Owner-Antwort-Runde V-01R bis V-13 (die Antworten auf
  `docs/sessions/20260817-OWNER-VORAB-15-restfragen.md`) -- HIER liegt das im Auftrag gemeinte
  "V-13" (Reihenfolge-Kanon wallclock/macro/micro).
- GOAL v8 (Z.140-141) referenziert nur "V-1...V-7" und meint damit die Wellenplan-Par.6-Zeilen
  ("Der TDD-Vertrag T-1...T-9 ... ergaenzt V-1...V-7 um die Testseite").
- AUDIT-HINWEIS: Das Wellenplan-Par.6-Verifikationsvertrag (Koeder/Nenner-Pflichten) ist fuer diesen
  DESIGN-ONLY-Strang inhaltlich NICHT einschlaegig (kein Test/keine Wache wurde gebaut) und darf
  nicht mit dem hier gemeinten KON101-V-13 verwechselt werden. Kein Widerspruch in der SACHE, aber
  ein Namensraum-Risiko fuer die Audit-Lesung -- deshalb hier explizit aufgeloest.

### S-3 -- Design-Dok-Zitatzeile "Z.676-690" vs. tatsaechliche Marker-Ausdehnung Z.676-693
(kleine, sachlich folgenlose Ungenauigkeit)
- Das Design-Dok (Abschnitt 4.1) und die Strang-Ergebnisdatei zitieren den TDD-Designplan-
  UEBERHOLT-Marker als "Z.676-690". Eigene Nachlesung: T-12c beginnt Z.676, die eigentliche
  Original-Pflicht (3) steht Z.680-681, der UEBERHOLT-MARKER-Block selbst laeuft Z.686-693 (endet
  also 3 Zeilen NACH der zitierten Obergrenze). Inhaltlich deckt das Zitat den richtigen Block;
  die Zeilenangabe ist um ~3 Zeilen zu eng. Kein Bewertungs-Fehler, nur eine Praezisions-Notiz fuer
  ein etwaiges Literal-Nachmessen durch das Audit.

### S-4 -- Post-KON119-Nachtrag "kanalwerk KW-A1" (Board #122) -- neuere Schicht als der Strang-
Snapshot, Inhalt hier NICHT aufloesbar
- Ledger KON120-07 (22.08. frueh, Z.94-96, JUENGER als der fuer diesen Strang gehaltene
  KON119-Stand): "Traegerlose SITZT-KLEIN-Funde der 6 SITZT-Straenge -> Board #122 (kanalwerk
  KW-A1, cidual A1, trigfix KLEIN-1, ph89 A-1, pmcpaket AUD-1, s8kopf K-1 + pinduo-A2/A3-
  Lead-Posten)."
- AUDIT-HINWEIS: "kanalwerk KW-A1" ist NICHT Teil der SOLL-QUELLEN dieser Erhebung (kein Volltext
  in Ledger/Designplan/W2-ABFOLGE-DESIGN auffindbar; nur die Routing-Zeile selbst existiert) und
  kann daher hier NICHT inhaltlich bewertet werden. Da die juengere Schicht Vorrang hat, sollte das
  Audit Board #122 auf den KW-A1-Eintrag pruefen, statt ihn stillschweigend zu uebergehen oder ihn
  faelschlich als bereits in dieser Karte gedeckt zu behandeln.

### S-5 -- I-2-Klassifikation B vs. C in design91-v2 -- SELBST-KORRIGIERT, keine offene Spannung,
aber Fundort bleibt an der alten Stelle stehen (Verwechslungsgefahr)
- design91-v2 fuehrte I-2 urspruenglich in der KLASSE-B-Liste ("in W2 ENTSCHEIDEN + BAUEN",
  Z.446/460-464) und markierte dort per "[20.08.v2, Fix 2]"-Nachtrag (Z.465-474) die
  UMKLASSIFIZIERUNG nach Klasse C ("VOR Trigger nur FESTSCHREIBEN"). Der Fliesstext bleibt an der
  alten (B-)Stelle stehen, der Fix-Kommentar unmittelbar darunter macht die Korrektur explizit;
  die C-Klassen-Liste selbst (Z.476-479) traegt einen Verweis-Nachtrag zurueck. Das Design-Dok
  #90 selbst folgt konsequent der KORRIGIERTEN Lesart (Klasse C). KEIN echter Quellen-Widerspruch
  fuer das Audit -- nur ein Hinweis, falls beim Nachlesen von design91-v2 an der ALTEN Textstelle
  (Z.460-464) faelschlich "Klasse B" als aktuell gelesen wuerde.
