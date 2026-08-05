# CE-NACHZIEH-LISTE — Stufen-Doktrin-Konsolidierung (05.08.2026)

Fuer das NAECHSTE ce-Fenster (wt-e24 aktuell von der Eich-Welle belegt — Ein-Agent-Regel; KEINE
ce-Schreibungen in dieser Konsolidierung). Ueberschneidet sich mit Posten 90 (Design-Doc-Nachzug
per LEDGER mittag-10 Konsequenz (a)) — diese Liste ist dessen praezisierte Fundstellen-Form.

Kanon-Referenz: super-Ledger Nachtraege 05.08. mittag-9 + mittag-10 (Owner-abgenommen mittag-11).
Kurzform: MESS=DREISTUFIG dehnbar Planer(RT-Freigabe)->CEB(CT: Mess-Design+Pruefdock-Konfig)->[Hybrid(CT)]->Tier(CT: Observer/Ausstattung) ·
SYSTEM=ZWEISTUFIG dehnbar CEB(RT-Freigabe HW)->[Hybrid(CT): gibt sich selbst+Tiers die System-Config CT mit]->Tier(CT) ·
ORGAN=ZWEISTUFIG hybrid-unberuehrt, NUR in Tier-Binaries (CEB-RT-Freigabe der lazy Permutations-Wahl->Tier-CT) ·
GESETZ: Stufe 1 IMMER RT-Freigabe in der Traeger-Binary, Folgestufen CT-Einbau entlang Planer->CEB->Tier ·
HYBRID=Factory-Pattern-Facade-ADAPTER, organ-frei, erbt als 4. Stufe ALLE Eigenschaften, reicht Mess- UND System-Eigenschaften CT weiter, traegt Mess+System-Stempel, KEINE Organ-Identitaet.

Doku-Doktrin: NIE loeschen — nur additive Korrektur-Vermerke; Original stehen lassen.
Prioritaet: C1 (WIDERSPRUCH) > C2 > C3 > C4.

---

## C1 — WIDERSPRUCH (hoechste Prioritaet)

**Datei:** `docs/architecture/20260802-hybrid_tier_stufe_soll_design.md:286-288` (Abschnitt 6 Punkt 4, A13-Stempel-Schnittstelle)

**Zitat:**
> "**A13-Stempel-Schnittstelle:** Die Hybrid-Identitaet ist die normale Tier-Stempel-Form
> (`[[System],[Organ]]` + SHA512-Zeile) der Hybrid-Binary."

**Problem:** Widerspricht mittag-10 Konsequenz (c): der Hybrid traegt **Mess- UND
System-Stempel-Zeilen seiner Kette, aber KEINE Organ-Permutations-Identitaet** (organ-frei).
"Normale Tier-Stempel-Form [[System],[Organ]]" enthaelt ein Organ-Array und laesst den
Mess-Stempel weg — beides kanon-widrig. K1 (:313-315) im selben Doc stellt die
Organ-binary_id-Losigkeit der Hybrid-.so selbst fest (Doc in sich inkonsistent).

**Vorgeschlagener Vermerk (additiv, direkt an Punkt 4):**
> KORREKTUR-VERWEIS 05.08.2026 (super-Ledger Nachtraege mittag-9/-10, Owner-abgenommen
> mittag-11): Die Hybrid-Identitaet ist NICHT die normale Tier-Stempel-Form. Der Hybrid ist
> organ-frei (Factory-Pattern-Facade-Adapter) und traegt Mess- UND System-Stempel-Zeilen seiner
> Kette, aber KEINE Organ-Permutations-Identitaet; binary_id bleibt Organ-only bei echten Tiers
> (konsistent mit K1). K1-Vorschlag (a) (eigene Einlagerungsform via Stempel-SHA512 statt
> Organ-binary_id) ist im Licht dieser Form neu zu fassen: Preimage = Mess+System-Stempel.

---

## C2 — UNVOLLSTAENDIG (= Posten 90, bereits beauftragt)

**Datei:** `docs/architecture/20260802-hybrid_tier_stufe_soll_design.md` (gesamtes Doc; Anker
:34 "eigene Stufe HINTER der CEB", :281 "Die Hybrid-Stufe erbt dann den finalen Major")

**Zitat (Anker :281):**
> "Die Hybrid-Stufe erbt dann den finalen Major und laedt die Voll-Bau-Binaries ohne Neubau."

**Problem:** Es fehlen (a) die GoF-Einordnung **Factory-Pattern-Facade-ADAPTER** (Factory fuer
Dock-Einsatz, Facade als 'virtuelles ganzes Tier-Binary' nach aussen, Adapter/Delegation per
Command an die echten Organ-tragenden Tiers), (b) das **Vererbungs-Gesetz** (erbt als
eingeschobene 4. Stufe ALLE Eigenschaften vorausgegangener Stufen — nicht nur den ABI-Major),
(c) die **CT-Weitergabe-Pflicht BEIDER Achsen-Arten** (Mess UND System an die anhaengigen
Tiers), (d) die Organ-Unberuehrtheit als Stufen-Aussage (Organ-Achsen NUR in Tier-Binaries).

**Vorgeschlagener Vermerk:** Neuer additiver Abschnitt "Stufen-Doktrin-Nachtrag 05.08.2026"
(z.B. hinter Abschnitt 6) mit der Kanon-Kurzform oben + explizit: Hybrid als 4. Stufe in der
MESS- und SYSTEM-Kette dehnbar eingeschoben, ORGAN-Kette OHNE Hybrid-Beruehrung; Verweis auf
super-Ledger mittag-9/-10.

---

## C3 — UNVOLLSTAENDIG (offene Frage laengst beantwortet)

**Datei:** `docs/architecture/20260802-hybrid_tier_stufe_soll_design.md:443-444` (Offene Frage
6/K4) + `libs/cache_engine/hybrid/README.md:54-56` (K4-Referenz in den Randbedingungen)

**Zitat (Design-Doc):**
> "**K4 (siehe Abschnitt 7):** ist das Framing LEDGER:187(e) 'Heuristik-Optimierung als eigene
> Systemachse' durch das E1-Stufen-Modell superseded?"

**Problem:** Per super-Ledger mittag-Fenster 05.08. (Atlas-Topologie-Freigabe wf_f80815cf)
ENTSCHIEDEN: JA, superseded — "'Systemachse'-Framing der Heuristik per Owner-E1 02.08. ins
Stufen-Modell superseded".

**Vorgeschlagener Vermerk (an beiden Stellen, additiv):**
> BEANTWORTET 05.08.2026: JA — das 'eigene Systemachse'-Framing (LEDGER:187(e)) ist durch das
> E1-Stufen-Modell superseded (super-Ledger 05.08., Atlas-Topologie-Freigabe). Die Heuristik ist
> die optionale Hybrid-Stufe (Factory-Facade-Adapter), keine System-Achse. K4 damit geschlossen.

---

## C4 — UNVOLLSTAENDIG

**Datei:** `libs/cache_engine/hybrid/README.md:22-24`

**Zitat:**
> "Owner-E1 definiert die Hybrid-Tier-Binary als eigene Stufe HINTER der CEB, mit mehreren
> ABI-stabilen Pruef-Docks, Factory-Pattern-Proxy auf ihre Tier-Binaries und `std::variant` als
> begrenzte Ausnahme in einem wahlweise statischen oder Runtime-Dock-Array."

**Problem:** Nur "Factory-Pattern-Proxy"; es fehlen die kanonische GoF-Gesamteinordnung
(Factory-Facade-ADAPTER), die organ-frei-Eigenschaft, das Vererbungs-Gesetz (4. Stufe erbt
alles) und die CT-Weitergabe-Pflicht Mess+System.

**Vorgeschlagener Vermerk (ein additiver Satz + Design-Doc-Verweis genuegt):**
> Nachtrag 05.08.2026: Kanonische Einordnung (super-Ledger mittag-9/-10): der Hybrid ist ein
> Factory-Pattern-Facade-ADAPTER — organ-frei (Organ-Achsen NUR in den echten Tier-Binaries),
> erbt als eingeschobene 4. Stufe ALLE Eigenschaften vorausgegangener Stufen und reicht Mess-
> UND System-Eigenschaften zur Compile-Zeit an seine anhaengigen Tiers weiter; er traegt
> Mess+System-Stempel, KEINE Organ-Identitaet. Details: Design-Doc, Stufen-Doktrin-Nachtrag.

---

## VERIFIZIERT UNKRITISCH im ce (KEINE Aktion)

- `include/cache_engine/measurement/target_isa_system_axis.hpp:1-14` · 
  `libs/cache_engine/profile_facade/profile_run_entry.hpp:856` · 
  `libs/cache_engine/planner/experiment_plan_director.hpp:539/:667` — korrekte
  Stufe-1-/Zulaessigkeits-Kommentare (System-RT-Freigabe bzw. CEB-Bau-Delegations-Naht), kein
  Stufen-Claim, kein Widerspruch.
