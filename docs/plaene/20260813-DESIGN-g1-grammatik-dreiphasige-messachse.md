# DESIGN G-1 — die VEREINFACHTE/AUSGELEGTE Grammatik fuer die DREIPHASIGE Mess-Achse

> **Status: ENTWURF als OWNER-VORLAGE — KEIN BAU.** Owner-Auftrag §15.2 (Wellenplan v2 :1886) /
> KON13-03 (Ledger :5605): *„eine vereinfachte/ausgelegte Grammatik (**Design durch Claude
> vorschlagen**) fuer die DREIPHASIGE Mess-Achse"*.
> **Datum:** 13.08.2026 · **Quellen-Stand:** super-Ledger bis KON59 · ce-Baum @ `5f3f26a5` (nur
> lesend) · **Thema Stempel-Strecke (S-2 Grammatiken)** ⇒ KON38: Fable 5 max.
> **Zielpfad nach Freigabe:** `docs/plaene/20260813-DESIGN-g1-grammatik-dreiphasige-messachse.md`
> (Schwester-Dokument zu `20260807-DESIGN-flag-grammatik-v2-punkt-notation-komposit.md`).
>
> **STATUS-NACHTRAG (Welle-2-Landung, publiziert am Zielpfad):** Entscheidungsstand je F-G1-Frage.
> **ANGENOMMEN (2 von 12): F-G1-1 (EIN Parser -- G-1 als Profil der v2) und F-G1-2 (Kurz-Vokabular
> `m` / `b` `h` `t` / `w` `ma` `mi`)** -- per Owner-B2-Bedingung 13.08. (*"wenn kein widerspruch ...
> autonom uebernehmen (passt)"*, Transkript 52798) UND erfuellter Bedingung: 0/8-Kollisions-Explore
> eigenstaendig reproduziert (8 Token gegen Hardware-Katalog kFlagGrammarCatalog[62]+Reserve[14]
> mit beissender Positiv-Kontrolle `bw`, System-Achsen, 18 Organ-Achsen, cpu_sub p/e, PMC,
> load_framework, Tooling-Ids, Testat-Grammatik, Pruefling-XSD -- 0 Kollisionen). Die autonome
> Uebernahme deckt AUSSCHLIESSLICH diesen B2-Gegenstand; Bau spaeter exakt nach Paragraf 6
> (kMessGrammarCatalog im Mess-Home, Registry-Batterien auf mess_version_is_wellformed).
> **OFFEN (9 von 12): F-G1-3 bis F-G1-10 und F-G1-12** -- nummerierte Owner-Fragen, konservativ
> NICHT als mit-entschieden verbucht. **F-G1-11 (1 von 12):** kein offener Owner-Entscheid mehr --
> Aufloesung aus Bestand per B1/(iii)-Wallclock-Definition (Owner 13.08., Transkript 52798); die
> Abbildung auf die Slot-Projektion ist eigene Konstruktionsarbeit (Komplex-Fix): w-fuehrend,
> wenn die erzeugende CEB w traegt. Der ENTWURF-Status oben gilt fort fuer alles ausser F-G1-1/-2.

---

## 0. Der Auftrag und seine Owner-Worte (verbatim, mit Fundstelle)

**KON13-03 (11.08. nachts, Ledger :5607-5612) — der Auftrag selbst:**
> *„Die Grammatik-Zahl meint **eine vereinfachte/ausgelegte Grammatik** (Design durch Claude
> vorschlagen) **fuer die DREIPHASIGE Mess-Achse** und **eine zweite Grammatik fuer die
> ZWEIPHASIGE System-Achse und Organ-Achse** (existiert schon als volle System-Achsen-Syntax und
> Semantik muss nachgeholt werden in Reihenfolge der Achsen-Nummerierung)."*

Damit fiel KON9-04 („drei Grammatiken je Phasigkeit") in Zahl und Schnitt (Ledger :5619,
:2474): **zwei** Grammatiken, eine je Stufigkeits-Klasse. Die vierphasige braucht keine eigene —
ihr Kern ist dreiphasig.

**KON13-02 (§15.3, Ledger :5576-5585) — die Dreiphasigkeit:**
> *„Weil Hybrid und Tier **unabhaengig voneinander** sind, sind es **2 parallele DREIPHASIG
> Vertraege ueber die Mess-Achse des Planers** […] **Konzeptionell hat die CEB hier 2 dritte
> Phasen**, die sie als Kopf steuert, **in der Anordnung des Ortes allerdings 4 Phasen**."*

    KONZEPTIONELL   Planer ──▶ CEB ──┬──▶ Tier      zwei PARALLELE dreiphasige Vertraege
                                     └──▶ Hybrid    ueber die Mess-Achse des Planers
    AM ORT          Planer ──▶ CEB ──▶ Hybrid ──▶ Tier   (vier Phasen; ORT ≠ ZEIT ≠ PHASE)

**KON16-02 (Ledger :5092-5096) — die drei Lesarten (O-3):**
> *„Das kommt darauf an, ob das Flag auf der **freigebenden Seite** oder der **compile time
> Seite** steht […]. Im Falle der **Freigabe impliziert** es das Vorhandensein und im Falle der
> **compile Seite Fordert** das Flag das Vorhandensein von Hardware ein. Im Falle von
> **DREIPHASIG** fordert die **Messachse der CEB** ausserdem die **Einhaltung des Vertrages mit
> den Messfuehlern** der Tier-Binary bzw. Hybrid."*

**KON37-01 (Ledger :2148-2167) — die Vererbungsregel (Satz 1 VOLLSTAENDIG; die fruehere
[…]-Kuerzung an dieser Stelle war sinnentstellend und ist per A2.5-Review aufgehoben):**
> *„**CEB gibt wallclock build auf der naechsten Traeger-Stufe frei**, hat die CEB keine
> wallclock Messfuehler, brauchen die dazugehoerigen Tier-Binaries auch keine Flaeche 3
> Uebertragung und Einrichtung von Wallclock time. […] Die CEB **ruft nur die Messfuehler in
> der Tier-Binary und Hybrid auf, die sie selbst gebaut hat** bzw. **baut hoehere
> Traeger-Stufen nur nach ihren eigenen Messeigenschaften. Freigabe also auf Planer,
> Durchfuehrung im Vertrag zwischen CEB und Tier/Hybrid.**"*

Der Satz traegt BEIDE Richtungen: keine CEB-Wallclock ⇒ keine tier-seitige Flaeche-3-
Einrichtung; UND die B3-Konsequenz desselben Eintrags (Ledger :2171-2172): *„Die Tier-Gates
bleiben — gebaut werden sie nur noch, wenn die erzeugende CEB Wallclock traegt."* Das
Tier-KOMPILAT ist damit w-ABHAENGIG — eine w-blinde Kind-Projektion verloere diese
Owner-Semantik (Konsequenz: M-8 und F-G1-11).

**KON37-03 (Ledger :2204-2218) — die Anordnungs-Freigabe:**
> *„Ja die **Reihenfolge muss in einer beliebigen Anordnung statisch in der Mess-Achse
> freigegeben werden, damit die Zeiger und Zustaende fuer an/aus fuer jede Stufe klar definiert
> ist**. […] **jede Stufe [hat] ihre ganz spezifischen Wallclock/Macro/Micro compile time
> Einrichtungen bzw. ein subset der 3**. Die statische Festlegung ‚Wie viel' ist technisch nicht
> umsetzbar ohne Planer Simulation."*

**KON25-03 (Ledger :3980-3994) — der Nenner:** Tier Micro×Macro (2×2) · Hybrid Micro×Macro
(2×2) · CEB Wall-Clock an/aus (2) ⇒ **32 = 2^5 Mess-System-Permutationen** ueber die 4
Traeger-Stufen (strukturelles Maximum der BELEGUNGEN; von Dock-Zahl und Schicht-Groessen
entkoppelt, KON41-03/KON42-01).

**Konsolidierung IV (Ledger :2719-2721) — die Vorzeichnung dieses Entwurfs:**
> „G-1 Mess (dreiphasig) — **die v2 deckt sie; Rest = die DREIPHASIG-Pruefsyntax des Homes**."

---

## 1. Der erhobene Gegenstand: WAS die Mess-Achse sagen muss — und wie es heute dasteht

Die Mess-Achse muss vier Aussagen tragen koennen (alle owner-gedeckt, §0):

| # | Aussage | Quelle |
|---|---|---|
| A1 | **Belegung je Traeger-Stufe**: welche Stufe (CEB/Hybrid/Tier) welche Instrumente aus {Wallclock, Macro, Micro} traegt — je Stufe ein **Subset der 3**, an/aus | KON25-03 · KON37-03 |
| A2 | **Anordnung**: die Reihenfolge der Stufen in **beliebiger, statisch freigegebener** Anordnung (Zeiger/Zustaende je Stufe klar definiert) | KON37-03 |
| A3 | **Drei Phasen als drei Seiten desselben Werts**: Planer impliziert (Freigabe) · CEB fordert (Compile) · CEB fordert zusaetzlich den **Messfuehler-Vertrag** (Flaeche 3 = IMessVisitor, KON25-02) | KON16-02 · KON37-01 |
| A4 | **Vererbung**: die Mess-Bestueckung der Kinder FOLGT der CEB — sie baut nur nach eigenen Messeigenschaften und ruft nur selbstgebaute Messfuehler | KON37-01 |

**IST am Objekt (ce `5f3f26a5`):**
* Die Mess-Stempel-Zeile existiert: `measurement_stamp_line()` traegt
  `measurement_tooling=<tooling>@X.Y.Z` + Meta-Meta-Klammer `[load_framework=<id>@X.Y.Z]`
  (`abi/anatomy_version_stamp.hpp:256-307`); leere Zeile = „kein Mess-Tooling einkompiliert".
* Die Tooling-Registry fuehrt **3 Eintraege** wallclock/macro/micro, alle `"1.0.0.c"`
  (`measurement/measurement_tooling_registry.hpp:47-49`) — **ohne Stufen-Dimension**; ihr Neubau
  mit Stufen-Dimension tier/hybrid/ceb und Belegungs-Zaehlung ≤ 32 ist owner-beschlossen
  (KON37-02: erweitern + neu + altes archivieren).
* Die heutige Combo-Notation ist `canonical_combo()`: dedupliziert und **SORTIERT**, kollabiert
  zu `[all]` (`profile_facade/planner/plan_legend.hpp:74-100`). Sortieren zerstoert genau die
  Anordnungs-Information, die KON37-03 verlangt — als CI-**Legende** in Ordnung, als
  **Stempel-Quelle** untauglich.
* **Eine G-1-Grammatik existiert nicht** — Nichtfund mit Gegenprobe: 0 Treffer fuer
  `MessGrammar|mess_grammatik|mess_grammar|MessBelegung|mess_belegung|DREIPHASIG` ueber
  `libs/`+`tests/`; Gegenprobe `canonical_combo` am selben Kommando: 2 Dateien. Deckt sich mit
  dem Ledger-Status „fehlt" (KON13-03-Tabelle :5616).

---

## 2. Die zwei Owner-Woerter tragen den Entwurf: „AUSGELEGT" und „VEREINFACHT"

**These des Entwurfs: G-1 ist ein PROFIL der Flag-Grammatik v2 — keine zweite Sprache.**

* **„ausgelegt"** = eine **Auslegung** der bestehenden v2-Token-Syntax auf den Mess-Gegenstand:
  dieselben Zeichenregeln, derselbe **EINE** Parser `parse_algo_semver`, derselbe **EINE**
  Renderer (`algo_semver.hpp:35-50`: zwei Parser/Renderer fuer eine Grammatik sind die benannte
  Drift-Quelle). Die Konsolidierung IV sagt es woertlich vor: *„die v2 deckt sie; Rest = die
  DREIPHASIG-Pruefsyntax des Homes"* (:2720).
* **„vereinfacht"** = eine **Restriktion** in vier Dimensionen (Abschnitt 5): geschlossenes
  Klein-Vokabular statt offenem Hardware-Katalog · **feste Stufen-Slots** statt freier
  Flag-Liste · Tiefe ≤ 2 statt ≤ 4 · genau EIN Mess-Flag statt 1→n.

Beide Deutungs-Kandidaten aus dem Auftrag („weniger Klammergruppen? feste Phasen-Slots?") sind
damit enthalten — und zwar **ohne neuen Parser**: die Vereinfachung lebt vollstaendig in der
**Pruefsyntax** (Wachen), nicht im Zerleger.

---

## 3. Die Grammatik

### 3.1 EBNF (als Profil der v2 — Token-Syntax unveraendert v2)

    mess_version := UINT '.' UINT '.' UINT '.' 'c' [cpu_sub] '.' mess_flag
    mess_flag    := 'm' '{' stufe [ '.' stufe ]* '}'          -- GENAU EIN 'm' je Mess-Zeile
    stufe        := stufen_token [ '{' belegung '}' ]         -- ohne Klammer = LEERE Belegung
    stufen_token := 'b' | 'h' | 't'                           -- CEB | Hybrid | Tier
    belegung     := instrument [ '.' instrument ]*            -- Menge, Reihenfolge BEWAHRT
    instrument   := 'w' | 'ma' | 'mi'                         -- wallclock | macro | micro
    cpu_sub      := '{' ('p'|'e') [ '.' ('p'|'e') ] '}'       -- unveraendert G-2 (c{p}/c{e}/c{p.e})

Alles ist v2-wohlgeformt: R2 (Punkt vor jedem Flag), R3 (Basis direkt an ihrer Klammer), R4
(keine leere Gruppe, kein fuehrender Punkt), R5 (nur der Punkt trennt) gelten unveraendert.
**Die Produktion ist ABSCHLIESSEND:** zwischen `c`[cpu_sub] und `m` steht NICHTS — Hardware-
Flags jenseits von c/p/e (z. B. `x512{f}`) sind auf der Mess-Zeile Formfehler (Spiegel-Probe
B-5); „Hardware-Katalog fuer den `c`-Teil" in Stufe C meint AUSSCHLIESSLICH c/p/e.
Tiefe: `m`=0, Stufen=1, Instrumente=2 — unter dem v2-Deckel `kMaxFlagDepth == 4` (:434);
Knotenzahl des `m`-Baums maximal 1+3+9=13, die VOLLE Mess-Zeilen-Version traegt mit `c{p.e}`
bis 16 Knoten (13 + c/p/e) — beides « `kMaxFlagNodes == 96` (:429). **Der bestehende Parser
parst jede G-1-Form heute schon** — neu ist ausschliesslich Katalog + Pruefsyntax (Abschnitt 6).

### 3.2 Die Regeln M-1…M-11 (Gegenstueck zu R1–R8 der v2)

* **(M-1) EIN PARSER, EIN RENDERER.** G-1 ist zeichenidentisch v2-Token-Syntax;
  `parse_algo_semver`/`render_algo_semver` bleiben die einzigen. Jede G-1-Durchsetzung laeuft
  ueber `for_each_flag_node` — **kein zweiter Zerleger** (Vorbild `flag_menge_ordnung.hpp:29-30`).
* **(M-2) GENAU EIN `m`-FLAG je Mess-Zeile.** `m` ist die Wurzel des Mess-Namensraums. Identitaet
  ist das **(token, eltern)-Paar** (S-3-Doktrin): `w` unter `b` ist NIE dasselbe Element wie `w`
  unter `t` — der Mess-Namensraum ist vom Hardware-Katalog vollstaendig getrennt
  (Kollisions-Erhebung: 0 von 8 Kandidaten-Token im 62er-Katalog, Anhang §9).
* **(M-3) FESTE TIEFE ≤ 2.** Instrumente tragen KEINE eigenen Untergruppen. Tiefer = Formfehler.
  (Das ist die erste Vereinfachung: v2 erlaubt 4.)
* **(M-4) STUFEN-SLOTS.** Unter `m` stehen 1..3 Gruppen aus {`b`,`h`,`t`}, **jede hoechstens
  einmal**. Ein Slot OHNE Klammer ist die **leere Belegung** (alles aus) — zulaessig und
  bedeutungstragend: der Slot haelt die Stufe im Vertrag adressierbar (KON37-03: „Zeiger und
  Zustaende fuer an/aus fuer jede Stufe klar definiert" — auch der Aus-Zustand braucht seinen
  Zeiger). Leere KLAMMERN `{}` bleiben nach R4 verboten. Mindestens EIN Slot ist Pflicht
  (`1.0.0.c.m` ist Formfehler — F-G1-6).
* **(M-5) INSTRUMENTE.** Unter einer Stufe stehen nur `w`,`ma`,`mi`, **jedes hoechstens einmal
  je Stufe**. Die Grammatik verbietet KEINE Kombination (KON37-03: das SOLL Tier={mi,ma},
  Hybrid={mi,ma}, CEB={w} ist **Soll-Belegung, kein Typ-Verbot** — auch `w` unter `t` ist
  formulierbar, wie es der IST-Bestand heute faktisch lebt). WAS gebaut werden darf, entscheidet
  die Freigabe (Phase 1), nicht die Syntax.
* **(M-6) ANORDNUNG IST INFORMATION.** Der Parser sortiert und normalisiert NICHT (v2-Doktrin
  „der Stempel IST Identitaet", `algo_semver.hpp:52-63`). Die Reihenfolge der Stufen-Gruppen IST
  die **statisch freigegebene Anordnung** (KON37-03); `m{b{w}.t{ma.mi}}` und
  `m{t{ma.mi}.b{w}}` sind ZWEI Werte. `canonical_combo` (sortierend) bleibt CI-Legende und wird
  NIE Stempel-Quelle.
* **(M-7) DREI PHASEN = DREI LESARTEN, nicht drei Syntaxen.** Derselbe String wird gelesen als:
  **Phase 1** (Planer, freigebende Seite): *impliziert* — die Belegung liegt in der
  Freigabe-Menge · **Phase 2** (CEB, Compile-Seite): *fordert* — die CEB baut exakt diese
  Bestueckung und fordert ihre Einrichtungen ein · **Phase 3** (Ziel): die Mess-Achse der CEB
  fordert die **Einhaltung des Messfuehler-Vertrags** (Flaeche 3) exakt nach String. Das bildet
  KON16-02 eins-zu-eins ab — wie bei G-2 haengt die Bedeutung an der SEITE, nicht am Zeichen.
* **(M-8) PROJEKTION — die KIND-Stempel-FORM ist owner-offen (F-G1-11).** Fest steht: die CEB
  stempelt den **vollen** Vertrags-Ausdruck (= ihre Messeigenschaften; sie ist Kopf beider
  Vertraege, KON13-02), und ein Kind KANN nichts tragen, was der Vertrag der bauenden CEB
  nicht nennt — Projektions-**GLEICHHEIT**, keine Teilmenge (F-G1-4). NICHT still festgelegt
  wird die FORM des Kind-Stempels: die reine Slot-Projektion (Tier stempelt nur `m{t{…}}`)
  ist **w-blind** — `m{b{w}.t{ma.mi}}` und `m{b.t{ma.mi}}` projizierten auf DENSELBEN
  Tier-Stempel `m{t{ma.mi}}`, obwohl per KON37-01 Satz 1 + B3-Konsequenz (:2148, :2171-2172)
  das Tier-Kompilat w-abhaengig ist (die Tier-Wallclock-Gates werden gebaut ⇔ die erzeugende
  CEB traegt `w`). Zwei verschiedene Kompilate mit EINEM Stempel sind exakt die
  Alias-Identitaets-Klasse, die KON34-05 (:3229: „Die Mess-Schalter dagegen aendern das
  Kompilat und den Stempel") und die B11-Doktrin des Objekts (`algo_semver.hpp:533-537`)
  verbieten. Die Slot-Projektion ist zudem **nicht injektiv**: derselbe Wert `m{t{ma.mi}}`
  ist zugleich gueltiger CEB-VOLL-Ausdruck (Ein-Slot-Vertrag, M-4) und Kind-Projektion
  beliebiger Herkunft (`m{b{w}.t{ma.mi}}`, `m{b.t{ma.mi}}`, `m{t{ma.mi}.b{w}}`, …) — Rolle
  (Kopf vs. Kind) und Herkunft liegen am TRAEGER (welches Binary die Zeile fuehrt), nicht im
  Wert; Anordnung und Fremd-Slots gehen restlos verloren, obwohl M-6 sie zur
  Identitaets-Information erklaert und KON37-03 Zeiger/Zustaende JE STUFE verlangt
  (→ F-G1-10). Die Kind-Stempel-FORM legt der Owner in **F-G1-11** fest (drei Optionen, §8).
* **(M-9) EXAKTHEIT statt Erweiterungs-Teilmenge.** Fuer die GUELTIGKEIT eines Mess-Stands gilt
  **Gleichheit** der Belegung, nicht Teilmenge: Mess ist der **zweischneidige** Filter (Rang-1,
  KON9-09: „mehr Messfuehler = mehr Latenz") — ein Binary mit weniger Instrumenten kann den
  Vertrag nicht erfuellen (Flaeche 3 fehlt), eines mit mehr verfaelscht die Messung (Latenz).
  Jede Belegungs-Aenderung ist ein anderes Kompilat und ein anderer Stempel (KON34-05). Die
  asymmetrische S-3-Teilmengen-Relation dient G-1 NUR freigabeseitig (gefordert ⊆ freigegeben),
  NIE als Lager-Skip. **Das ist der eine semantische Gegensatz zu G-2** (dort: Erweiterung
  laesst den alten Stand gueltig — additiv monotoner Filter A).
* **(M-10) CPU-PFLICHT BLEIBT.** Die Mess-Zeile traegt ce-eigene Versionen; die F-10-Pflicht
  („mindestens `c`") und beide B12-Wachen gelten unveraendert — `m{…}` ist ein ZUSAETZLICHES
  Flag hinter `.c`, keine Ausnahme-Mechanik (Alternative als F-G1-7 vorgelegt).
* **(M-11) CPU_SUB OHNE DUPLIKATE (A2.5-Schliessung).** In `c{…}` steht jedes Token (`p`,`e`)
  hoechstens einmal. `c{p.p}`/`c{e.e}` sind von der cpu_sub-Produktion ableitbar und heute von
  KEINER Bestands-Wache verboten: die v2 kennt kein Geschwister-Duplikat-Verbot
  (`flag_catalog_is_satisfied` :934-941 prueft nur Zulassung je Knoten; `algo_semver.hpp:1571`
  nennt Redundanz ausdruecklich „eine andere Fehlerklasse" — „Sie ist NICHT gebaut"). G-1
  schliesst die Luecke mess-zeilen-lokal: durchgesetzt in `mess_version_is_wellformed()`
  (Stufe C). Auf System-/Organ-Zeilen bleibt sie unveraendertes G-2-Erbe → G-2-Semantik-
  Nachzug #17.

### 3.3 Wo der Wert wohnt

Der `m`-Ausdruck reist als **Flag-Schwanz der Version** im `measurement_tooling`-Eintrag der
Mess-Stempel-Zeile: `measurement_tooling=<id>@X.Y.Z.c.m{…}` (welche `<id>` bei
Mehr-Stufen-Mischung: F-G1-12). Die Stempel-Wache
`axis_version_entries_are_wellformed` parst Versionen bereits heute mit dem EINEN Parser
(`anatomy_version_stamp.hpp:246-248`) — der Wert faehrt also durch die bestehende
Stempel-Maschinerie ohne Parser-Aenderung. Fuer den PARSER wahr; die konkrete Naht heisst
aber: die Registry-B12-Batterie (`tooling_versionen_wohlgeformt` + Schwester-Wachen,
`measurement_tooling_registry.hpp:58-62`) prueft heute mit `ce_owned_version_is_wellformed`
und lehnte jeden `m`-Schwanz ab — sie wechselt beim Registry-Neubau auf
`mess_version_is_wellformed` (Stufen C/F). Das X.Y.Z bleibt die Code-Identitaet der
Mess-Tooling-Achse (zweistufige Versionierung unberuehrt); der `m`-Schwanz ist die
**Mess-Spezifikation** — exakt das Muster, mit dem KON9-05 die Hardware-Flags als
Spezifikations-Stempel auf X.Y.Z gesetzt hat, hier auf den Mess-Gegenstand uebertragen.
`load_framework` (Lastsequenz) bleibt Meta-Meta-Klammer-Anhang der Zeile (KON37-05: eine
FRAMEWORK-Mess-Achse, liegt selbst auf einem Achsen-Interface — F-G1-9), PMC bleibt
Meta-Meta mit eigener Versions-Quelle (Klasse (k), `pmc_vendor_registry.hpp` — F-G1-8).

---

## 4. Fuenf durchgerechnete Beispiele

### B-1 · Der SOLL-Vertrag CEB→Tier (KON25-03-Belegung, alles an)

    1.0.0.c.m{b{w}.t{ma.mi}}

    Parse (Pre-Order, Tiefe):  c(0) · m(0) · b(1) · w(2) · t(1) · ma(2) · mi(2)
    Lesart Phase 1 (Planer):   diese Belegung ist FREIGEGEBEN (impliziert ihre Baubarkeit)
    Lesart Phase 2 (CEB):      FORDERT: Wallclock-Einrichtung an sich selbst ("misst UM das
                               Tier herum"), Macro+Micro-Einrichtung im Tier-Bau
    Lesart Phase 3 (Tier):     Messfuehler-Vertrag: das Tier exportiert die Flaeche-3-
                               Durchstiche {ma, mi} exakt — UND weil die CEB 'w' traegt,
                               werden die tier-seitigen Wallclock-Gates GEBAUT (KON37-01
                               Satz 1 + B3-Konsequenz :2171-2172): das Tier-Kompilat ist
                               w-abhaengig, nicht nur {ma,mi}-bestimmt
    Kind-Stempel (M-8):        FORM ist F-G1-11 — die reine Slot-Projektion
                               1.0.0.c.m{t{ma.mi}} waere w-blind (zwei Kompilate, EIN Stempel)
    Schalter-Zaehlung:         3 der 5 Nenner-Schalter an: (w,b) (ma,t) (mi,t)

### B-2 · Die Vier-Parteien-Kette: zwei parallele dritte Phasen in EINER Zeile

    1.0.0.c.m{b{w}.h{ma.mi}.t{ma.mi}}          -- die CEB-Messeigenschaft als Kopf

    Zwei GESCHWISTER-Gruppen h und t unter demselben m = die "2 dritten Phasen, die sie als
    Kopf steuert" (KON13-02) -- NICHT geschachtelt: der Kern bleibt dreiphasig, die Grammatik
    macht es sichtbar. Alle 5 Nenner-Schalter an: (w,b) (ma,h) (mi,h) (ma,t) (mi,t) = 2^5-Welt.
    Slot-Projektionen (Kind-Stempel-FORM: F-G1-11):
                   Hybrid  1.0.0.c.m{h{ma.mi}}   ·   Tier  1.0.0.c.m{t{ma.mi}}
    Die Anordnung  b . h . t  ist die statisch freigegebene Anordnung (M-6);
    m{b{w}.t{ma.mi}.h{ma.mi}} waere ein ANDERER Wert.

### B-3 · Wallclock aus — die Vererbungsregel KON37-01 woertlich durchgespielt

    1.0.0.c.m{b.t{ma.mi}}

    'b' ohne Klammer = leere CEB-Belegung: die CEB hat KEINE Wallclock-Messfuehler.
    Folge (KON37-01, Konditional): kein 'w' im Ausdruck => KEIN Kind kann eine Flaeche-3-
    Wallclock-Uebertragung tragen -- exakt der Owner-Satz "brauchen die dazugehoerigen
    Tier-Binaries auch keine Flaeche 3 Uebertragung und Einrichtung von Wallclock time".
    Die KONTRAPOSITION wirkt in B-1: STEHT 'w' im b-Slot, werden die tier-seitigen
    Wallclock-Gates GEBAUT (B3-Konsequenz :2171-2172) -- im Kind-Stempel sichtbar erst
    nach der F-G1-11-Entscheidung.
    Die Entscheidung fiel AUF der CEB (Schalter-Hoheit), die Freigabe kam vom Planer,
    die Durchfuehrung steht im Vertrag -- der Merge aus KON37-01, in einer Zeile lesbar.

### B-4 · Alles aus (Arbeits-/Produktions-Modus) — und warum leere Slots existieren

    1.0.0.c.m{b.t}        gegen        1.0.0.c.m{t.b}

    Beide Slots leer: kein Instrument einkompiliert (reiner Arbeits-Modus). Die STRUKTUR
    bleibt trotzdem stempelbar: Stufen und ANORDNUNG sind adressierbar (KON37-03 -- der
    Aus-Zustand je Stufe ist ein definierter Zustand, kein Fehlen). Die beiden Formen sind
    ZWEI Werte (M-6): die Anordnung ist Information. Abgrenzung zur LEEREN Mess-Zeile
    ("" = kein Mess-Tooling einkompiliert, anatomy_version_stamp.hpp:289-292): leere Zeile
    heisst "Mess-Welt nicht dabei", m{b.t} heisst "dabei, bewusst alles aus".

### B-5 · Die Negativ-Batterie (was die Pruefsyntax ablehnt) und die Exaktheit

    1.0.0.c.m{t{ma}.t{mi}}     ROT: Stufe 't' doppelt                        (M-4)
    1.0.0.c.m{b{w.w}}          ROT: Instrument 'w' doppelt je Stufe          (M-5)
    1.0.0.c.m{x{w}}            ROT: katalogfremdes Stufen-Token              (Katalog-Wache)
    1.0.0.c.m{b{w{f}}}         ROT: Tiefe 3                                  (M-3)
    1.0.0.c.m                  ROT: kein Slot                                (M-4/F-G1-6)
    1.0.0.m{b{w}}              ROT: CPU-Pflicht verletzt (kein 'c')          (M-10/B12)
    1.0.0.c{p.p}.m{b{w}}       ROT: cpu_sub-Duplikat                         (M-11)
    1.0.0.c.x512{f}.m{…}       ROT AUCH AUF DER MESS-ZEILE: zwischen c[cpu_sub] und 'm'
                               steht NICHTS (§3.1) — die Spiegel-Richtung zur Exklusivitaet
    1.0.0.c.x512{f}.m{…} auf einer ORGAN-Zeile: ROT — 'm' ist mess-zeilen-exklusiv
                               (§6, Stufen B/C)

    EXAKTHEIT (M-9), beide Richtungen:
    m{t{ma}}  deckt  m{t{ma.mi}}  NICHT   (Flaeche-3-mi fehlt => Vertrag unerfuellbar)
    m{t{ma.mi}}  deckt  m{t{ma}}  NICHT   (mi-Latenz verfaelscht => kein Lager-Skip)
    WICHTIG: alle Formen der Batterie sind fuer den PARSER wohlgeformt -- er prueft die FORM,
    die Ablehnung ist Sache der Mess-Wachen (dieselbe Arbeitsteilung wie v2/S2-Katalog).

---

## 5. Abgrenzung zu G-2 (System+Organ, zweiphasig)

| Merkmal | **G-2** (existiert, `algo_semver.hpp` R1–R8) | **G-1** (dieser Entwurf) |
|---|---|---|
| Traeger im Stempel | System-/Organ-Zeile | **Mess-Zeile** (`measurement_line`) |
| Phasigkeit | zweiphasig CEB→Tier ‖ CEB→Hybrid | **dreiphasig** Planer→CEB→Ziel, **zweimal parallel**, CEB als Kopf |
| Vokabular | offener Hardware-Katalog, **62 Eintraege** (`flag_grammar_catalog.hpp:176`), waechst mit Hardware (F-5/F-6 unrecherchiert) | **geschlossen: 13 Katalog-Paare** (1 Wurzel `m` + 3 Stufen + 3×3 Instrumente); Erweiterung NUR per Owner-Entscheid (PMC/`ls` = benannte Andockstellen) |
| Flag-Kardinalitaet | R6: 1→n Flags | **genau EIN** `m`-Flag |
| Klammer-Tiefe | ≤ 4 (`kMaxFlagDepth`, :434) | **≤ 2**, fest |
| Struktur | freie Flag-Liste, Reihenfolge sachlich egal (formal bewahrt) | **feste Stufen-Slots** {b,h,t}, je ≤ 1; Reihenfolge = **Anordnungs-Freigabe** (sachlich BEDEUTEND) |
| Gueltigkeits-Semantik | **Teilmenge**: Hardware-ERWEITERUNG laesst den alten Stand gueltig (Filter A, additiv monoton; S-3 `flag_menge_ist_teilmenge`) | **EXAKTHEIT**: jede Belegungs-Aenderung = anderes Binary (Filter B, zweischneidig); Teilmenge nur freigabeseitig |
| Zustand | Syntax gebaut+gelandet 07.08.; **Semantik wird nachgeholt** (#17, in Achsen-Nummerierungs-Reihenfolge) | Entwurf; **Syntax und Semantik in EINEM Stueck** — moeglich, weil das Vokabular geschlossen und klein ist |
| Parser | `parse_algo_semver` | **DERSELBE** (Profil, M-1) |

Gemeinsam bleibt (bewusst): Punkt-Notation, Klammerformen, X.Y.Z-Zahlenwelt inkl.
Sentinel-/Kurzform-Regeln, CPU-Pflicht F-10, die (token,eltern)-Paar-Identitaet und die
Nicht-Normalisierung (Stempel = Identitaet).

---

## 6. Der Compile-Time-Durchsetzungsweg (sechs Stufen, kein neuer Parser)

O-3-Zuordnung vorweg (KON16-02): die **freigebende Seite** (Planer: Code=Wahrheit der Freigabe,
XML=Wahrheit der Realisierung, KON21-02) **impliziert**; die **Compile-Seite** (die von der CEB
emittierte Bau-TU) **fordert** per `static_assert`/concept; **dreiphasig zusaetzlich** fordert
die Mess-Achse der CEB den Messfuehler-Vertrag (Stufe D unten). Jede Wache mit LESBARER
Meldung — erst laute Compile-Fehler, dann verschieben (Hausdoktrin).

* **Stufe A — Parser: NULL Aenderung.** Beweis-Batterie: die Beispiele B-1…B-5 als
  `static_assert(parse_algo_semver(…))`-Positiv-/Negativ-Pins (der Parser akzeptiert ALLE
  Formen; abgelehnt wird in C). Tiefe 2 ≤ 4, Knoten `m`-Baum ≤ 13 / volle Zeile ≤ 16 « 96 —
  am Objekt gedeckt.
* **Stufe B — der Mess-Katalog als EIGENE Tabelle** `kMessGrammarCatalog` im **Mess-Home**
  (analog `flag_grammar_catalog.hpp`, aber getrennt: der Hardware-Katalog trennt ZEICHEN von
  HARDWARE, dieser trennt ZEICHEN von MESS-ARCHITEKTUR). 13 (token,eltern)-Paare:
  (`m`,"") · (`b`|`h`|`t`, `m`) · (`w`|`ma`|`mi`, je Stufe). Wache
  `mess_catalog_is_satisfied()` analog `flag_catalog_is_satisfied()`.
  **AUSDRUECKLICH NICHT:** `m` in den Hardware-Katalog eintragen — das legalisierte `m` still
  auf System-/Organ-Zeilen (genau die Fehlerklasse „still statt laut").
* **Stufe C — die DREIPHASIG-Form-Wachen** (die „Pruefsyntax des Homes", Konsolidierung IV
  :2720): `mess_form_ist_dreiphasig()` ueber `for_each_flag_node`: genau ein `m` · Slots nur
  aus {b,h,t}, je ≤ 1 · ≥ 1 Slot · Tiefe ≤ 2 · Instrumente je Slot ≤ 1. Dazu die
  **Zeilen-Exklusivitaet**: ein NEUES Praedikat `mess_version_is_wellformed()` fuer die
  Mess-Zeile (v2-Form + Hardware-Katalog fuer den `c`-Teil + Mess-Katalog + Form-Wache +
  cpu_sub-Duplikat-Verbot M-11). „Hardware-Katalog fuer den `c`-Teil" meint dabei
  AUSSCHLIESSLICH c/p/e — die Mess-Zeile erlaubt zwischen `c`[cpu_sub] und `m` KEINE
  weiteren Hardware-Flags (die EBNF §3.1 ist abschliessend; Spiegel-Probe B-5).
  Das generische `ce_owned_version_is_wellformed()` bleibt hardware-only und lehnt `m` auf
  System-/Organ-Zeilen weiter ab. Beide sind B12-Wachen-Traeger; die neue Quelle faellt unter
  den P14-Taxonomie-Riegel (der sie namentlich einfordert — gewollt). **Konkrete Umstellung:**
  die Registry-B12-Batterie `tooling_versionen_wohlgeformt` + Schwester-Wachen
  (`measurement_tooling_registry.hpp:58-62`) wechselt von `ce_owned_version_is_wellformed`
  auf `mess_version_is_wellformed` — sonst ist der Registry-Neubau mit `m`-Schwanz
  compile-rot.
* **Stufe D — Projektions- und Messfuehler-Wache am Emissions-Punkt.**
  `mess_projektion(vertrag, stufe)` (constexpr, ueber `for_each_flag_node` + Renderer) liefert
  die Slot-Teilform; die CEB emittiert den Ziel-Bau MIT
  `static_assert(mess_projektion(kCebMessEigenschaft, 't') == kZielMessStempel)` (die genaue
  Kind-Stempel-FORM im Gleichheits-Pin folgt der F-G1-11-Entscheidung; die
  Projektions-Funktion bleibt der Baustein) —
  das ist die **Filterketten-Mechanik** KON9-06 (C++23-concept je Phasigkeit, mp11: „nur
  bestimmte concept builds zur Laufzeit eines niederen Traegers duerfen den compile eines
  hoeheren Traegers bilden") und die **Korrelations-Pflicht** KON37-02 (Freigabe ↔ Ausfuehrung
  ueber die Permutation einer freigegebenen Konfiguration per compile time der hoeheren
  Traeger-Stufe). Dazu je Instrument im Ziel-Slot ein concept-Anspruch an die
  **Flaeche-3-Naht** (`IMessVisitor`/`tier_measure_accept`, `mess_visitor_abi.hpp`, KON25-02):
  Instrument ohne Durchstich = Compile-Fehler, Durchstich ohne Instrument = Compile-Fehler
  (beide Richtungen — „ruft nur die Messfuehler auf, die sie selbst gebaut hat").
* **Stufe E — Freigabe-Relation (S-3 wiederverwendet).** Fuer „gefordert ⊆ freigegeben" wird
  die GEBAUTE asymmetrische Relation `flag_menge_ist_teilmenge` (`flag_menge_ordnung.hpp:76-84`)
  unveraendert benutzt — sie arbeitet bereits (token,eltern)-genau und fail-closed auf
  Sentinel. Fuer die GUELTIGKEIT gilt Gleichheit (M-9); ein Teilmengen-Skip fuer Mess wird
  NICHT gebaut.
* **Stufe F — Anschluss an den Registry-Neubau (KON37-02).** Die Neu-Registry mit
  Stufen-Dimension tier/hybrid/ceb und Belegungs-Zaehlung ≤ 32 ist die TABELLEN-Seite dieser
  Grammatik: `<measurement_tooling>`-XML (erweitert, Stufen-Dimension) → aufgeloeste Belegung →
  EIN `m`-Ausdruck je Vertrag („eine Aufloesung, zwei Verbraucher": Stempel-Glied + Bau-Gates).
  Der Registry-Neubau uebernimmt die Wachen-Umstellung aus Stufe C (B12-Batterie auf
  `mess_version_is_wellformed`); welche `<id>` der `measurement_tooling`-Eintrag bei
  Mehr-Stufen-Belegung traegt (heute GENAU EINE gewaehlte Tooling-id,
  `anatomy_version_stamp.hpp:256-259`), ist F-G1-12.
  Die Deckel-Defaults folgen der Default-Doktrin KON42-01 (constexpr im Planer, XML als
  Override). `canonical_combo` bleibt Legende (sortiert, `[all]`-Kollaps) und speist NIE den
  Stempel.

---

## 7. Was dieser Entwurf NICHT festlegt (Grenzen, mit Begruendung)

1. **Die Position der Mess-Zeile im Stempel-Gefuege** (MESS,SYSTEM,ORGAN-Umstellung S-6a) —
   S-6-Fenster mit eigenem Explore („Glieder-Reihenfolge: zwei Welten"; bis dahin wird an S-6
   NICHTS gebaut). G-1 definiert den WERT der Zeile, nicht ihren Platz.
2. **Der Nenner-Umfang je Lauf**: 32 ist das strukturelle Maximum der Belegungen (KON25-03);
   „wie viel" real gefahren wird, rechnet AUSSCHLIESSLICH die Planer-Simulation S-19
   (KON37-03/KON41-03). Die Grammatik zaehlt nicht, sie benennt.
3. **Die G-2-Semantik** (#17) — eigener Auftrag, in Achsen-Nummerierungs-Reihenfolge; G-1
   greift ihr nicht vor (nur die S-3-Relation wird als Baustein WIEDERVERWENDET).
4. **PMC und Lastsequenz** — bleiben nach Aktenlage Meta-Meta (eigene Versions-Quellen/
   Klammer-Anhaenge); Einbindung als Owner-Fragen F-G1-8/F-G1-9, nicht als stiller Entwurf.
5. **KEIN BAU.** §15.2 verlangt einen Design-VORSCHLAG; jede Zeile dieses Dokuments ist
   Vorlage. Bau erst nach Owner-GO, dann als Stempel-Strecken-Posten (KON38: Fable 5 max).

---

## 8. Offene Owner-Entscheide (nummeriert)

* **F-G1-1 · Profil-Entscheid:** G-1 als **Profil der v2** (EIN Parser, Vereinfachung lebt in
  Katalog+Pruefsyntax des Mess-Homes) statt einer eigenen Sprache — bestaetigen?
  *(Empfehlung: ja — Drift-Doktrin „eine Grammatik existiert nur einmal".)*
* **F-G1-2 · Vokabular:** Kuerzel `m` (Mess-Wurzel) · `b`/`h`/`t` (CEB/Hybrid/Tier) ·
  `w`/`ma`/`mi` (Wallclock/Macro/Micro) — bestaetigen oder andere Kuerzel? *(Erhebung: 0 von 8
  Kandidaten kollidieren mit dem 62er-Hardware-Katalog; laengere Token wie `ceb`/`wallclock`
  waeren ebenso kollisionsfrei, kosten aber Stempel-Laenge in jedem Preimage.)*
* **F-G1-3 · Kein Planer-Slot:** der Planer traegt 0 der 5 Nenner-Schalter (KON25-03) und ist
  Sprecher der Phase 1, kein Belegungs-Traeger — bewusst KEIN `p`-Slot. Bestaetigen? *(Ein
  spaeterer Planer-Messfuehler waere ein ADDITIVES viertes Stufen-Token — kein Umbau.)*
* **F-G1-4 · Vererbungs-Lesart:** „Messeigenschaften der CEB" = der VOLLE Vertrags-Ausdruck
  (CEB stempelt `m{b….h….t…}`); Kinder-Stempel = **Projektions-GLEICHHEIT** (M-8; die FORM
  des Kind-Stempels ist F-G1-11). Bestaetigen?
  *(Alternative waere Teilmengen-Vererbung je Instrument — sie kann das SOLL b{w}/t{ma.mi}
  nicht ausdruecken, weil Tier-Instrumente dann in der CEB-eigenen Belegung stehen muessten.)*
* **F-G1-5 · Exaktheit:** Gueltigkeit der Mess-Belegung = GLEICHHEIT, kein Teilmengen-Skip im
  Lager (M-9, Begruendung zweischneidiger Filter B). Bestaetigen? *(Fuer G-2 bleibt Teilmenge=
  Erweiterung gueltig — der Gegensatz ist gewollt und begruendet.)*
* **F-G1-6 · Leere Slots:** Slot ohne Klammer = leere Belegung ZULAESSIG (`m{b.t}`), `m` ohne
  jeden Slot VERBOTEN. Bestaetigen? *(Traegt die Anordnungs-Freigabe auch im Aus-Zustand.)*
* **F-G1-7 · CPU-Pflicht der Mess-Zeile:** `.c` bleibt VOR `.m{…}` Pflicht (keine
  F-10-Ausnahme, M-10) — oder soll `m` auf der Mess-Zeile das `c` ERSETZEN (dann braucht F-10
  eine Ausnahme-Mechanik)? *(Empfehlung: `.c` behalten — null Sonderwege in den B12-Wachen.)*
* **F-G1-8 · PMC:** bleibt Mess-Meta-Meta mit eigener Versions-Quelle und eigener Permutation
  (AMD≠Intel; Vendor im CEB-Fingerprint) AUSSERHALB des `m`-Flags — oder viertes Instrument-
  Token unter `b`? *(Empfehlung: aussen lassen; die Vendor-Permutation ist keine an/aus-
  Belegung.)*
* **F-G1-9 · Lastsequenz:** bleibt als FRAMEWORK-Mess-Achse (KON37-05) im
  `load_framework`-Meta-Meta-Segment der Mess-Zeile, NICHT im `m`-Flag. Bestaetigen?
* **F-G1-10 · Anordnungs-Deklaration:** Traegt der String selbst die gewaehlte Anordnung (M-6)
  und pinnt eine Mess-Home-Tabelle die FREIGEGEBENE(N) Anordnung(en) (Vorbild
  `kFlagVoraussetzungsKetten`) — oder soll die Anordnung ausschliesslich tabellarisch leben?
  *(Empfehlung: String traegt, Home-Tabelle pinnt — dieselbe Arbeitsteilung wie
  Parser/Katalog.)* **Dazu (A2.5):** braucht die KIND-Identitaet die Vertrags-ANORDNUNG?
  KON37-03 verlangt Zeiger/Zustaende JE STUFE — bei reiner Slot-Projektion geht die Anordnung
  im Kind restlos verloren; die Antwort haengt an der F-G1-11-Entscheidung.
* **F-G1-11 · Kind-Stempel-Form (w-Sichtbarkeit) — NEU, tragend (A2.5):** KON37-01 Satz 1
  (*„CEB gibt wallclock build auf der naechsten Traeger-Stufe frei"*, :2148) und die
  B3-Konsequenz (*„Die Tier-Gates bleiben — gebaut werden sie nur noch, wenn die erzeugende
  CEB Wallclock traegt"*, :2171-2172) machen das Tier-Kompilat w-abhaengig; die reine
  Slot-Projektion ist w-blind (M-8: zwei Kompilate, EIN Stempel — verboten per KON34-05
  :3229 und B11-Doktrin). Drei ehrliche Optionen:
  **(i)** Kinder stempeln den VOLLEN Vertrags-Ausdruck (wie die CEB) — loest auch den
  Anordnungs-Verlust aus F-G1-10 ·
  **(ii)** die Projektion fuehrt vertragswirksame Fremd-Slot-Instrumente als Kontext mit
  (z. B. Tier: die `m{b{w}.t{ma.mi}}`-Projektion behaelt das w-tragende `b`) ·
  **(iii)** `w` gilt als reines CEB-Selbst-Instrument OHNE tier-seitige Naht — dann steht
  das im ausdruecklichen Widerspruch zur B3-Konsequenz „Die Tier-Gates bleiben" (:2171-2172),
  und dieser Widerspruch muss entschieden werden, nicht uebersprungen.
* **F-G1-12 · Tooling-`<id>` bei Mehr-Stufen-Belegung (A2.5):** die Mess-Zeile traegt heute
  GENAU EINE gewaehlte Tooling-id (`anatomy_version_stamp.hpp:256-259`). Mischt der
  `m`-Ausdruck Instrumente mehrerer Toolings ueber die Stufen: welche `<id>` fuehrt der
  `measurement_tooling`-Eintrag? *(Teil des Registry-Neubaus KON37-02 — Stufe F.)*

---

## 9. Erhebungs-Anhang: Zahlen mit Nenner, Fundstellen, Nichtfunde

* **G-2 am Objekt:** `algo_semver.hpp` 1633 Zeilen, EBNF+R1–R8 (:12-33), 317 `static_assert`
  (grep -c, gesamte Datei); `kMaxFlagNodes` 96 (:429), `kMaxFlagDepth` 4 (:434),
  `kMaxSemVerComponentDigits` 6 (:528). Katalog: `flag_grammar_catalog.hpp` 889 Zeilen,
  **62 Eintraege** (Array-Deklaration :176), Basen c/g/f/n (+x128/x256/x512).
* **S-3 gelandet:** `flag_menge_ordnung.hpp` 222 Zeilen, 20 `static_assert`;
  `flag_menge_ist_teilmenge` (:76-84, asymmetrisch, fail-closed), `flag_menge_in_signatur`
  (:101-124), Geschlossenheits-Wache (:161-179), Werkzeug-Grenze == 2 Ketten (:216-220).
* **Mess-IST:** `anatomy_version_stamp.hpp:256-307` (Mess-Zeile + Meta-Meta-Klammer; leere
  Zeile = ehrlich leer), `measurement_tooling_registry.hpp:47-49` (**3 Eintraege**
  wallclock/macro/micro, je `"1.0.0.c"`), `plan_legend.hpp:74-100` (`canonical_combo`
  sortiert + `[all]`-Kollaps).
* **Kollisions-Erhebung:** 8 Kandidaten-Token (`m b h t w ma mi ls`) gegen die 62
  Katalog-Eintraege: **0 Treffer**; Positiv-Gegenprobe am selben Muster: `bw` (avx512bw,
  :252) wird gefunden — das Suchmuster beisst.
* **Nichtfund G-1-Bestand (Bestands-Pflicht A2.2, nach dem GEGENSTAND gesucht):** 0 Treffer
  fuer 6 Begriffe (`MessGrammar`, `mess_grammatik`, `mess_grammar`, `MessBelegung`,
  `mess_belegung`, `DREIPHASIG`) ueber `libs/` + `tests/` des ce-Baums; Gegenprobe am selben
  Kommando: `canonical_combo` → 2 Dateien.
* **Owner-Worte (alle am Ledger-Objekt nachgelesen, Nummern nur als Adresse):** KON13-03
  :5605-5628 · KON13-02 :5572-5601 · §15.2/§15.3 Wellenplan v2 :1886-1910 · KON16-02
  :5090-5110 · KON37-01 :2144-2173 (Satz 1 :2148, B3-Konsequenz :2171-2172) · KON37-02
  :2177-2196 · KON37-03 :2200-2226 · KON37-05
  :2250-2264 · KON25-01/-02/-03 :3953-4007 · KON9-04 :6361-6378 (GESTRICHEN durch KON13-03)
  · KON9-05 :6382-6413 · KON9-06 :6417-6448 · KON42-01 :1761-1791 · KON41-03 :1879-1907 ·
  KON34-05 :3224-3229 · Konsolidierung IV :2713-2727 (Grammatik-Digest) und :2761-2817
  (Mess-Digest inkl. System A/B, 5-Schalter-Karte, `--debug`-Disjunktheit KON34-05).

---

## 10. REVIEW-EINARBEITUNG (A2.5, 13.08.2026)

**Gegenleser-Verdikt: TRAEGT_MIT_FIXES** (Design-Duo-Review 13.08., Objekt-Gegenlese an ce
@ `5f3f26a5` + Ledger: alle G-2-/S-3-/Mess-IST-Fundstellen exakt reproduziert, die
Kollisions-Erhebung 0/8 + Positiv-Probe `bw` bestaetigt, alle 5 Beispiele nachgerechnet,
Kern-These M-1 am Objekt als WAHR belegt, alle Owner-Zitate verbatim an den angegebenen
Zeilen). Eingearbeitete Fixes:

* **FIX 1 (tragend, vor Owner-Vorlage):** das per […] verdeckte Owner-Wort **KON37-01
  Satz 1** (*„CEB gibt wallclock build auf der naechsten Traeger-Stufe frei"*, Ledger :2148)
  in §0 sichtbar gemacht — die Kuerzung war sinnentstellend (V13: […] darf nie Semantik
  verdecken); M-8 neu gefasst (reine Slot-Projektion ist w-blind und kollidierte mit
  KON37-01 Satz 1 + B3-Konsequenz :2171-2172 + KON34-05/B11-Alias-Verbot), B-1 Phase 3
  („keinen mehr, keinen weniger" gestrichen), B-2-Projektionszeile und B-3 (Kontraposition)
  angeglichen; die Kind-Stempel-FORM liegt als neuer Owner-Entscheid **F-G1-11** mit drei
  Optionen vor.
* **FIX 2:** Sprachumfang der Mess-Zeile eindeutig — die EBNF §3.1 ist abschliessend
  (zwischen `c`[cpu_sub] und `m` steht NICHTS; „Hardware-Katalog fuer den `c`-Teil" =
  AUSSCHLIESSLICH c/p/e), Spiegel-Negativ-Probe `1.0.0.c.x512{f}.m{…}` AUCH AUF DER
  MESS-ZEILE ROT in B-5 aufgenommen (§3.1, §6 Stufe C).
* **FIX 3:** Nicht-Injektivitaet der Projektion als Eigenschaft ausgeschrieben (derselbe
  Wert `m{t{ma.mi}}` = CEB-Voll-Ausdruck UND Kind-Projektion beliebiger Herkunft; Rolle und
  Herkunft liegen am TRAEGER, nicht im Wert) und die Anordnungs-Frage an F-G1-10/F-G1-11
  angeschlossen (M-8, §8).
* **FIX 4:** cpu_sub-Duplikat-Luecke geschlossen — neue Regel **M-11** (`c{p.p}` ROT,
  durchgesetzt in `mess_version_is_wellformed()`, Stufe C; auf System-/Organ-Zeilen
  G-2-Erbe → #17), Negativ-Beispiel in B-5.
* **FIX 5 (klein):** (a) B-5-Verweis „§6.2" auf die Stufen-Nomenklatur (§6, Stufen B/C)
  berichtigt · (b) Knotenzahl 13 als `m`-Baum-Zahl praezisiert (volle Zeile mit `c{p.e}`
  bis 16 — Deckel 96 haelt; Zaehlweise: 13 m-Baum + c/p/e) · (c) konkrete Wachen-Umstellung
  benannt (`tooling_versionen_wohlgeformt` + Schwester-Wachen,
  `measurement_tooling_registry.hpp:58-62`, wechseln auf `mess_version_is_wellformed`;
  §3.3, §6 Stufen C/F) · (d) Tooling-`<id>` bei Mehr-Stufen-Belegung als **F-G1-12**
  vorgelegt (heute GENAU EINE id, `anatomy_version_stamp.hpp:256-259`).
