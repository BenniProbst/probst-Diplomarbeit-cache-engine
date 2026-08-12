## NACHTRAG 12.08.2026 — KON25: DIE F1–F10-ANTWORTEN — DER NENNER IST 32, UND STUFE/PHASE SIND ZWEI KONZEPTE

**Der Owner hat alle zehn Fragen aus KON23-07 beantwortet — sechs direkt (eine mit
Live-Selbstkorrektur), drei mit Explore-Auftrag, zwei mit Kontext-Bitte. Zitate wörtlich,
Kürzungen mit `[…]`.**

---

### KON25-01 — F1 BEANTWORTET: DIE GEKLAMMERTE SYNTAX GILT, NICHTS ÄNDERN

> *„Ja ich meinte die **korrekt geklammerte Syntax für c{p} und c{e} bzw. c{pe}**. Ich möchte
> **daran nichts ändern, übernimm das bis hierhin gültige**."*

⇒ **O-1 ist GESCHLOSSEN.** Kein flacher Alias, kein Katalog-Umbau. Die gebaute Flag-Grammatik v2
(`c{p}`, `c{e}`, `c{p.e}` — die Owner-Schreibweise `c{pe}` meint die gebaute Punkt-Form) ist die
gültige volle Syntax. Der Bau-Posten „O-1-Restschluss" entfällt; optional bleibt der wörtliche
static_assert `"1.0.0.cp"` gegen die Katalog-Wache als Negativ-Pin.

---

### KON25-02 — F2 BEANTWORTET: IMessVisitor IST FLÄCHE 3 — UND DIE KONZEPTE WERDEN VEREINT

> *„Ja genau, **das ist Fläche 3** und **beide Konzepte müssen vereint werden**."*

⇒ Die NAHT-1 vom 09.08. (`IMessVisitor`/`tier_measure_accept`/`MessEdge<Sink>`,
`mess_visitor_abi.hpp`) **ist** der measurement-Durchstich. **Neuer Bau-Posten: die VEREINIGUNG**
— Benennung, Doku und Code führen beide Begriffe zusammen (Fläche-3-Vokabular an die gebaute
Naht), plus die bekannte Deckungslücke (Testziel CEB=AUS/Tier=AN existiert nicht).

---

### KON25-03 — 🔴 F3 BEANTWORTET MIT LIVE-SELBSTKORREKTUR: DER NENNER IST 32

**Owner verbatim, einschließlich der eigenen Korrektur:**

> *„Nun es sind doch 24, weil der Hybrid eigene Achsen unterrhält die grundsätzlich
> Micro-Benchmarking für sich selbst fahren und dann hat er auch Macro-Benchmarking, das sich
> auch separat abschalten lässt, daher 2x2 Möglichkeiten also 4 gegen die 6 CEBs macht 24
> Möglichkeiten. **Stop, das war falsch von mir.** Es sind also **Micro/Macro auf Tier-Binary
> und Hybrid jeweils 2x2=4, also 16** und **Wall-Clock-time auf CEB mit an/aus also 2
> Möglichkeiten**, daher **32 Permutationen** Bezüglich **4 Träger Stufen Mess-System
> Permutationen**."*

    DER GELTENDE NENNER (Owner-Endfassung nach Selbstkorrektur):

      TIER-BINARY   Micro an/aus x Macro an/aus  =  2x2 = 4
      HYBRID        Micro an/aus x Macro an/aus  =  2x2 = 4     } 4 x 4 = 16
      CEB           Wall-Clock-time an/aus       =  2
      ------------------------------------------------------------------
      MESS-SYSTEM-PERMUTATIONEN ueber die 4 Traeger-Stufen  =  16 x 2 = 32

**Damit sind ERSETZT:** die Memory-These „ES SIND ZWÖLF" (10.08.) · die 4!-Rechnung (24) · die
24/48-Frage · **und die erste Hälfte dieser Antwort selbst** (vom Owner ausdrücklich verworfen —
sie bleibt hier als Beleg des Korrekturwegs stehen).

**⚠️ Abgleich-Posten (Explore, keine sofortige Rückfrage):** das Verhältnis der 32 zur älteren
Aussage *„6 builds an CEBs wegen der 3-Fakultät-Mess-Layer-Regelung Wallclock/Macro/Micro"*
(Z. 35912) — die 6 zählte **Anordnungen** (3!), die 32 zählt **An/Aus-Belegungen**; ob beide
Größen koexistieren (Reihenfolge × Belegung) oder die 32 die 6 ersetzt, klärt der Explore am
Bestand, dann ggf. eine präzise Frage.

**Und die Planungs-Simulation (S-19) bekommt damit ihren Mess-System-Faktor:** 32 ist der
Multiplikator der Mess-Dimension, die Organ-/System-Permutationen kommen aus dem B+-Baum dazu.

---

### KON25-04 — F4 BEANTWORTET: DER CiYamlBuilder BLEIBT — FÜR DEN LOKALEN BUILD AUSSERHALB DER CI

> *„Ja **für den lokalen build außerhalb der CI**."*

⇒ Kein Rückbau. Die YAML-Emission bleibt als Werkzeug für den **lokalen** Gebrauch außerhalb der
CI; die CI-Kette selbst fährt über die Prozess-/CMake-Emission (KON16-03/KON18-01). S-12-Posten
entsprechend: beide Emissionswege pflegen, der YAML-Weg ist **nicht** der CI-Träger.

---

### KON25-05 — F5: EXPLORE — DER measure-drop-ENTSCHEID LIEGT IM SESSION-LOG DES LETZTEN KONTEXTS

> *„Das ist **schon entschieden im session log des letzen Kontext** - explore."*

⇒ Explore-Auftrag **E-F5**: den Entscheid (Ziel 2 Buildsystem-Cache vs. Ziel 3
cache-engine-experiment für den HTTPS-PUT-Kanal) im Session-Log des letzten Kontexts fördern.

---

### KON25-06 — F6: KONTEXT-BITTE — die C-4-Scope-Optionen werden mit Unterschieds-Erklärung neu vorgelegt

> *„Bitte erkläre mit mehr Kontext den Unterschied zwischen den Optionen."*

*(Erklärung in der Chat-Antwort vom 12.08.; Kern: 130 = nur `axes/`-Organ-Header · 152 = zusätzlich
die 22 `topics/queuing/`-Träger, die `algo_version` tragen, aber KEINE Organ-Achsen sind.)*

---

### KON25-07 — 🔴 F7 REVIDIERT DIE SYNONYM-THESE: STUFE UND PHASE SIND ZWEI KONZEPTE

> *„Nun die **Träger-Stufe ist die Binary und damit ein physisches Objekt** und die **Phase ist
> ein ganz anderes Konzept der CacheEngine Modi, welche über diese Träger-Stufen ausgeführt
> werden** - das ist **schon geplant bitte explore**. **Du hast das nicht sauber getrennt.**
> Die **Phase sind Konzeption, die Stufen Binaries physisch**."*

    STUFE (Traeger-Stufe)  =  die BINARY -- ein PHYSISCHES Objekt
    PHASE                  =  CacheEngine-MODI (Konzeption), die UEBER die
                              Traeger-Stufen AUSGEFUEHRT werden

**Das präzisiert KON16-09:** „Synonym" bezog sich auf den vermengten GEBRAUCH — die angeordnete
konsistente Umbenennung ist eine **saubere Trennung der zwei Konzepte**, keine Vereinheitlichung
auf einen Begriff. Mein Fehler ist protokolliert (*„Du hast das nicht sauber getrennt"*). Das
06.08.-Klärungsdokument (STUFE=physische Gliederzahl · PHASE=Konzept-Position) war näher an der
Wahrheit als die Synonym-Lesart.

⇒ **Umbenennungs-Regel für Posten 5 (Bauliste):** wo „Stufe/stufig" das **Modi-Konzept** meint →
„Phase/phasig"; wo „Phase" die **Binary** meint → „Träger-Stufe". Die Härteklassen-Karte (WF1-G)
bleibt gültig; die XSD-Enum-Werte `Stufe1..3` unter dem Element `phase` sind exakt die Kollision.
⇒ Explore-Auftrag **E-F7**: die geplante Trennung im Bestand fördern („das ist schon geplant").

---

### KON25-08 — 🔴 F8 BEANTWORTET: DIE TRÄGER-RAKETE WIRD RÜCKWÄRTS AUFGEBAUT

> *„Ja **absolut gehören diese in jeder Träger-Stufe zur vollen Pipeline dazu**. Eine
> Träger-Stufe **zündet bei erfolg die nächste Stufe (wie bei einer Träger-Rakete)**. Jedes
> binary Modul ist also **nach dem Bau eigenständig** und wird **ABI stabil in die vorhergehende
> Träger-Stufe gesteckt, um von ihr bedient zu werden** - **wir brennen die Rakete nicht
> stufenweise ab, sondern bauen sie stufen weise rückwärts auf**."*

    EMISSIONSLISTE JE TRAEGER-STUFE:  Bau + Test + LINT + RELEASE + Lager-Ablage
                                      (+ J-1..J-4)  =  die VOLLE Pipeline

    DIE RAKETEN-MECHANIK:
      ZUENDUNG   vorwaerts:  Stufe N zuendet bei ERFOLG Stufe N+1
      AUFBAU     RUECKWAERTS: das fertige Binary-Modul N+1 wird ABI-STABIL
                 in die VORHERGEHENDE Stufe N GESTECKT und von ihr BEDIENT
      => kein Abbrennen, sondern stufenweiser Rueckwaerts-AUFBAU

**Das bindet die dlopen-Mechanik an die Emissions-Kette:** die CEB steckt Tier/Hybrid in ihr(e)
Prüfdock(s), der Planer bedient die CEB — jede Stufe ist nach dem Bau **eigenständig** (eigene
volle Pipeline inkl. Lint+Release) und wird **rückwärts eingesteckt**. F8 vervollständigt damit
den S-12-Zuschnitt: die Emissionsliste ist die volle Pipeline, nicht Bau+Test.

---

### KON25-09 — F9 BEANTWORTET: prod2 BLEIBT — MULTI-RUNNER GEGEN DAS LAGER IST GEPLANT

> *„Ja klar bleibt er, das ist auch **geplant wie das gegen das Lager gefahren wird mit
> multiplen gleichgestellten CI runnern und unterschiedlichen nodes im System** - explore."*

⇒ **KON3-02 (seit 17.07. BLOCKIEREND) ist geschlossen: prod2 bleibt im Job-Pool.** Die
Kapazitätsrechnung fährt **zweilanig**. ⇒ Explore-Auftrag **E-F9**: den Plan „multiple
gleichgestellte CI-Runner + unterschiedliche Nodes **gegen das Lager**" im Bestand fördern.

---

### KON25-10 — F10: KONTEXT-BITTE

> *„Bitte mehr Kontext für die Frage."*

*(Erklärung in der Chat-Antwort vom 12.08.; Kern: wie benennt die XML die Einzelnachweise, die
zusätzlich zur finalen Zusammenfassung nach Ziel 3 gehen.)*

---

### KON25-11 — BILANZ UND NEUE EXPLORE-AUFTRÄGE

    GESCHLOSSEN:  F1 (O-1 zu) · F2 (Flaeche 3 = IMessVisitor, VEREINIGEN) ·
                  F3 (NENNER = 32, Selbstkorrektur dokumentiert) ·
                  F4 (CiYamlBuilder bleibt, lokal) · F8 (volle Pipeline +
                  Raketen-Mechanik rueckwaerts) · F9 (prod2 bleibt, zweilanig)
    EXPLORE:      E-F5 measure-drop-Entscheid im letzten Session-Log ·
                  E-F7 die geplante Stufe/Phase-Trennung · E-F9 Multi-Runner-
                  gegen-Lager-Plan · E-F3b Verhaeltnis 32 zu "6 CEB-Builds"
    KONTEXT:      F6 (C-4-Scope) und F10 (Einzelnachweis-Element) werden mit
                  Unterschieds-Erklaerung neu vorgelegt
    OFFEN bleibt: F11 (Pruefdock-Zaehlung) -- von dieser Runde nicht beruehrt
