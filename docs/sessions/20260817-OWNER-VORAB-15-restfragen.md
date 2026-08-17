# OWNER-VORAB #15 — DIE 12 REST-FRAGEN NACH ZEHN-WOCHEN-EXPLORE (17.08.2026)

HERKUNFT: OWNER-VORAB-15 (Buendel-Synthese, 13 Kandidaten V-01..V-13) wurde per Zehn-Wochen-
Explore (wf_e129dbb8: 4x Sonnet 5 max very thorough ueber super-Ledger 30214 Z. + 4 Repo-Ledger
+ alle Plaene/Sessions/Memories, Fable-5-max-Synthese; Stichproben S7/S8 am Roh-Transkript
bzw. Ledger-Rohtext BESTANDEN) gegen den Planungsbestand geprueft. ERGEBNIS: 1 Frage komplett
gestrichen (V-07 war entschieden), 7 Frage-Haelften gestrichen (Streichliste S1-S8 in KON100),
1 Empfehlung UMGEDREHT (V-10a: AVX512 GEHOERT IN golden — Owner-KERN 26.07. verbatim, Transkript-
bestaetigt). NUR die folgenden 12 verengten Fragen brauchen das Owner-Wort. Ohne die Antworten
auf V-01R..V-06 + V-08R + V-10b + V-11R kann der #15-Bruch (B-1) nicht starten; V-12/V-13 sind
Fenster-Koppler; V-09R ist Bruch-Schritt B-3.

## V-01R — AxisKind-Enum bei S-6a
KONTEXT: Die Glied-Folge MESS,SYSTEM,ORGAN ist fuer alle drei Aussen-Ebenen ENTSCHIEDEN
(KON21-03, 12.08., Ledger:7695 woertlich "Ja genau, meint auch #87 und #78" — #87 = Makro-/
Argumentfolge). Das AxisKind-Enum (topics/axis.hpp:17-50) traegt stempelwirksame Diskriminator-
Ordinale und wurde bisher owner-gedeckt nur append-only erweitert; die Ordnung lebt in
kSystemAxisOrder.
FRAGE: Dreht das AxisKind-Enum bei S-6a mit, oder bleibt es append-only unveraendert?
EMPFEHLUNG: Unveraendert lassen — Ordnungs-Single-Source ist kSystemAxisOrder; ein Ordinal-Dreh
waere ein zusaetzliches Byte-Ereignis ohne Ordnungs-Gewinn.

## V-02R — Byte-Grammatik der Hybrid-Komposit-Zeile (10. Glied)
KONTEXT: Existenz, Position und Map-VALUE = Tier-SHA sind entschieden (KON41-04, KON47-02
Ledger:4539-4542 "Ja so machen wir es ... nur dessen SHA"). Synthese-Keys existieren nicht;
die Matrix traegt nur Zell-Adressen.
FRAGE: Feld-Ordnung, Trenner und Dock-Adressierung — adressbasierte Keys per stufen_id
(Layer*Nodes+Node) bis HY-A2? Vorschlag: "hy=" + je Dock "<stufen_id>:<tier-sha512-128hex>",
';'-getrennt, deterministisch aufsteigend, leere Zeile == Identitaet (Tier reicht "").
EMPFEHLUNG: So bestaetigen — Stempel-Syntax ist besonders behutsam zu behandeln (Owner 14.08.),
darum die Grammatik als Ein-Satz-Abnahme.

## V-03R — EIN golden-Buendel + neuer TABU-Wert
KONTEXT: S-6a-Makro-Tausch ist entschieden (KON21-03); E-B (Owner-SETZUNG "Wir brechen
golden-CRC!") und A-09 brechen jeweils golden. Die "EIN Paket"-Buendelung war bisher nur
Lead-Empfehlung, nie Owner-Wort.
FRAGE: A-09 + E-B + S-6a-Makro (+ ggf. avx512-Filter-Korrektur K1, s.u.) als EIN golden-Ereignis
mit EINEM Re-Anker und neuem TABU-CRC — JA?
EMPFEHLUNG: Ja — Verfahren geuebt (gen_golden_fullpilot --crc64 + Bissprobe, Praezedenz 26.07.);
getrennte Brueche vervielfachen die Re-Anker vor F2. Der neue TABU-Wert wird bei der Landungs-
Meldung literal vorgelegt und mit dem F2-GO bestaetigt.

## V-04R — Form der E-1-Ablesbarkeit (Tiefe + Stufen-IDs)
KONTEXT: Owner-woertlich sind "Tiefe und ... Stufen-IDs IM STEMPEL ABLESBAR" (E-1 final, 09.08.,
Ledger:15868) — die FORM ist nicht festgelegt ("als Stempel-Felder" war Planer-Paraphrase).
stufen_id() ist heute reine constexpr-Funktion; hybrid/ ist frei formbar.
FRAGE: Ablesbarkeit als eigenes Preimage-Glied, als Feld der neuen Hybrid-Komposit-Zeile (V-02R),
oder als POD-Feld?
EMPFEHLUNG: In die ohnehin neue Hybrid-Zeile ("d=<tiefe>" + IDs) — ein Bruch statt zwei;
Preimage-Wirkung ist ueber den Hybrid-SHA gegeben (KON41-04).

## V-05R — Verortung des Rekombinations-Namens
KONTEXT: F7 (06.08., Ledger:24627 woertlich) legt CT-Namensfunktion + genau EIN eigenes
Stempel-Interface je Binary fest. Der Altplan wollte einen separaten POD + 6. Symbol, weil eine
AnatomyVersionLines-Erweiterung "Layout 6->7 ohne Gegenwert" waere — diese Praemisse ist
ENTFALLEN: der 6->7-Bump kommt in DIESEM Buendel ohnehin.
FRAGE: Separater POD + 6. Symbol (Altplan) ODER Name direkt in AnatomyVersionLines im ohnehin
faelligen 6->7-Bump?
EMPFEHLUNG: Integration in AnatomyVersionLines (sizeof 120->152 mit Hybrid-Zeile) — ein
ABI-Symbol weniger; Invariante bleibt: Name = Funktion des Fingerprints, KEIN zweites Ableiten.

## V-06 — Gattungs-Geltungsbereich der Stempel-Symbol-Pflicht
KONTEXT: KON7-01 (11.08.) macht das 5. Symbol zur Pflicht "auf jeder binary", nennt aber nur
die STUFEN — vier der fuenf Gattungs-ABI-Koepfe (set_/sequence_/view_/adapter_module_abi_v1.hpp)
definieren das Symbol nicht (0 VERSION_STAMP-Treffer), und die Gattungs-Fragmentierung war bei
der Freigabe nachweislich nicht mitgedacht. Der gattungs-agnostische Loader laedt alle fuenf.
FRAGE: Gilt die Pflicht gattungs-agnostisch fuer alle fuenf Koepfe, und wird das Symbol je
Gattungs-Kopf oder am gemeinsamen Traeger-Schnitt definiert?
EMPFEHLUNG: Gattungs-agnostisch am gemeinsamen Schnitt — die Drei-Flaechen-Doktrin (Stempel =
eigene Flaeche 2 je Binary, DAMIT Gattung+Genus-Interfaces unveraendert bleiben) spricht gegen
fuenf per-Gattung-Definitionen.

## V-08R — WIE des Planer-fingerprint_sha
KONTEXT: DASS der Planer einen Fingerprint-SHA wie alle Stufen bekommt, ist entschieden
(KON2-06, 10.08., Ledger:11587-11589 + Owner "Das ist jetzt alles korrekt."). planner_version.hpp
deklariert die Luecke LAUT (kFingerprintShaBewusstLeer) und verweist den Preimage-/Glied-
Entscheid auf einen eigenen Posten.
FRAGE: Eigene Planer-Preimage-Glieder im selben Bruch fuellen — und ziehen sie ins TIER-Preimage
ein — oder BewusstLeer bis zu einem spaeteren Posten?
EMPFEHLUNG: Im selben Bruch fuellen (Identitaets-Umbauten sind nur vor F2 kostenlos); Tier-
Preimage-Einzug NUR, wenn der Planer-SHA dort Provenienz traegt (2-Zeilen-Form aus KON7-04
als Muster) — sonst getrennt halten.

## V-09R — prod2: Token-String + RMA-Verfahren
KONTEXT: Umbenennung entschieden ("Ja umbenennen", 09.08., Ledger:16006, ins Bump-Fenster);
der Alder-Lake-Befund ist im Code bereits Wahrheit (kProd2AlderLakeCore); nur der Registry-
String steht noch. Im September kehrt der 14900KS aus der RMA zurueck. Der VORHER-Beleg ist
KEINE Frage mehr (Code hat "Messung schlaegt Planung" vollzogen; 09.08.-lscpu-Beleg liegt).
FRAGE: (1) Ziel-Token exakt "prod2_alder_lake"? (2) RMA-Rueckkehr: additive neue machine_id
oder Re-Etikettierung?
EMPFEHLUNG: (1) Ja (Konvention <host>_<microarch> + existierendes Symbol). (2) Additiv —
Hardware-Regel; Re-Etikettierung vermengte Mess-Provenienz zweier CPUs unter einem Token.

## V-10b — Cross-Maschinen-SKIP fuer no_extension
KONTEXT: Der avx512-Teil ist GESTRICHEN — seit 26.07. andersherum entschieden (Owner-KERN
verbatim, Roh-Transkript-bestaetigt: "AVX512 GEHOERT MIT ... Das golden-Profil hatte avx512
faelschlich als 'nicht universell' herausdefiniert — das ist der Filter, der ENTFAELLT";
4 opt x 3 simd = 12 System-Perms; Ausschluss auf prod2 faellt MASCHINENSEITIG per
HardwareErweiterungFehlt-Gate, nicht als Profil-Filter). Offen bleibt nur: eine no_extension-
Binary traegt auf beiden Maschinen denselben Fingerprint.
FRAGE: Cross-Maschinen-SKIP fuer no_extension — fuer den BAU ja; fuer die MESSUNG auch?
EMPFEHLUNG: Bau-SKIP ja (identische Bytes), Mess-SKIP NEIN — Messwerte sind maschinengebunden;
Par.61 trennt die Host-Lanes, das CSV-platform-Tag traegt die Provenienz.

## V-11R — exakter MergeStrategy-/XML-Token-Name
KONTEXT: Weg a (Fixture-Nachzug) ist ENTSCHIEDEN (Owner verbatim 06.08.: "F3: Bitte sauber die
fixture nachziehen und am besten nochmal gruendlich planen" — fertiger 689-Z.-Plan liegt:
20260806-PLAN-scheibe6-weg-a-fixture-entflechtung.md). Der kuenftige Bezeichner "gehoert zur
Pruefling-Familie und wird beim S-6-Fenster-Bau vorgeschlagen" (KON36) — DIES ist das Fenster.
FRAGE: Ersatz-Bezeichner "PrueflingVerbundStrategy" mit Werten Verbund1_CeOnly / Verbund2_Replace
/ Verbund3_Union und XML-Token "pruefling_verbund" (bzw. Achsen-Token "union" statt "fulljoin",
raeumt die KON91-Kollision) — bestaetigt?
EMPFEHLUNG: Genau so — der exakte String braucht die Owner-Abnahme (Stempel-/XML-Syntax 14.08.).

## V-12 — RunMethodology-/work_mode-Enum-Ordinalwerte
KONTEXT: Die logische Kette build->measure->compare->release und Debug-als-Flag sind
entschieden; die Enum-ORDINALE {debug,measure,release,compare} wurden bewusst NICHT umgestellt
("stempel-/ABI-relevant", registry:19-24), und G-5 haelt genau diese Frage beim Owner.
Registry- und Enum-Reihenfolge divergieren dokumentiert.
FRAGE: Ordinale im #15-Fenster auf die Stufen-Ordnung {Build=0,Measure=1,Compare=2,Release=3}
umstellen, oder Enum einfrieren und die Registry-Ordnung als einzige Ordnungs-Wahrheit fuehren?
EMPFEHLUNG: Im #15-Fenster mitschieben — EIN Byte-Fenster fuer alles; dauerhafte Divergenz ist
eine stehende Verwechslungsquelle.

## V-13 — Kanonisierung permutierter CEB-Legenden
KONTEXT: "[wallclock,micro]" und "[micro,wallclock]" liefern verschiedene Schluessel (gemessen
250be8b2 vs a30fe495); die Kanonisierung deklariert sich im Code selbst als "eigene Scheibe mit
Owner-Entscheid" und waere ein Byte-Ereignis am Tier-Preimage. Nie zuvor vorgelegt (0-Treffer-
Gegenprobe).
FRAGE: Kanonisierung in #15 falten oder Doppel-Schluessel dauerhaft tragen?
EMPFEHLUNG: In #15 falten — letztes kostenloses Fenster; dauerhafte Zwillinge werden zur stillen
Cache-Miss-Quelle.

## AUS DEN STREICHUNGEN ENTSTANDENE AUTONOME POSTEN (kein Owner-Wort noetig; K1-K6 in KON100)
K1 golden-XML-avx512-Filter-Korrektur (2 stale XML-Stellen; Wirksamkeits-Pruefung VOR Edit —
wirksamer Filter = golden-Inhalt = V-03R-Buendel) · K2 Weg-a-Plan umsetzen (Koordination mit K1,
dieselbe Fixture) · K3 Tier-/Hybrid-Erbinnen nach P4/P5 (V-07-Vollzug) · K4 (in dieser Vorlage
vollzogen: Owner-Wortlaut statt Paraphrase) · K5 gruppe6-Namens-Skizze verworfen (Name = Funktion
des Fingerprints) · K6 KON96/97-V-01-Stale-Buchung.
