## NACHTRAG 12.08.2026 — KON21: K2 UND O-14 BEANTWORTET, S-6 ENTSPERRT (fünf Antworten)

**Der Owner hat die K2-Erklärung, die O-14-Neustellung und alle fünf S-6-Fragen aus KON20-03
beantwortet. Damit ist S-6 vollständig entsperrt — die Explore-Auflage (KON15-02) war mit KON20
erfüllt, die Entscheidungs-Sperre fällt mit diesem Nachtrag.**

---

### KON21-01 — 🔴 K2 BEANTWORTET: DIE CEB ORCHESTRIERT DIREKT ODER DELEGIERT — DER HYBRID IST EIGENSTÄNDIG MIT SYNC-KANAL

**Owner verbatim 12.08.2026:**

> *„Die **CEB orchestriert alle Prüfdocks direkt oder delegiert dies an den Hybrid**, der das für
> die **compile time eingespeisten Synthese-Funktionen nach init am Prüfdock der CEB selbst über
> wiederverwendete CEB Module** übernimmt. Der Hybrid ist **später in der Lage eigenständige
> dynamische modules Lade-Entscheidungen zu treffen**, also ist der **Hybrid eigenständig, aber hat
> einen sync Kanal mit der CEB, sofern angeschlossen**, um die getroffenen Entscheidungen des
> Ladens und laufens von Tier-Binaries zur runtime zu beeinflussen."*

    ZWEI BETRIEBSARTEN, beide gueltig:
      (a) CEB orchestriert ALLE Pruefdocks DIREKT
      (b) CEB DELEGIERT an den Hybrid
          - der Hybrid uebernimmt fuer die COMPILE-TIME EINGESPEISTEN
            Synthese-Funktionen
          - NACH init am Pruefdock der CEB
          - ueber WIEDERVERWENDETE CEB-MODULE  <- kein eigener Loader-Neubau:
            derselbe Lade-Code als Bibliothek

    AUTONOMIE-STUFE (spaeter):
      der Hybrid trifft EIGENSTAENDIGE dynamische Module-Lade-Entscheidungen
      => der Hybrid ist EIGENSTAENDIG
      ABER: SYNC-KANAL mit der CEB (sofern angeschlossen), ueber den die CEB
      die Lade-/Lauf-Entscheidungen zur RUNTIME beeinflusst

**Damit ist die K2-Frage („welcher Loader-Schicht?") aufgelöst — die Antwort ist BEIDE, als
Betriebsarten, nicht als Fork:** die Loader-Fähigkeit wandert als **wiederverwendetes CEB-Modul**
in den Hybrid (Schicht 2), die CEB behält den direkten Weg (Schicht 1) und die Steuerhoheit über
den **Sync-Kanal**. Das deckt sich mit KON13-02 (zwei Steuerungswege der CEB) und KON19-02
(Transmitter/Multiplexer, Fläche-3-Durchreichung).

⇒ **Bau-Konsequenzen für S-15/HY:** (1) der Loader wird als wiederverwendbares Modul geschnitten
(Bestand: `AnatomyModuleLoader` — Bestands-Pflicht vor Neubau) · (2) der **Sync-Kanal
CEB↔Hybrid** ist ein eigenes Bau-Teil (Runtime-Beeinflussung der Lade-Entscheidungen) ·
(3) die Synthese-Funktionen sind **compile-time eingespeist**, die Lade-Entscheidungen **runtime**
— dieselbe CT/RT-Trennung wie überall (Fläche 2 vs. Laufzeitanfrage).

---

### KON21-02 — 🔴 O-14 BEANTWORTET: OPTION 1 — UND DIE ZWEI WAHRHEITEN SIND GESCHICHTET

**Owner verbatim:**

> *„**Option 1, der Code ist die Wahrheit** und die Registry folgt bezüglich der **Freigabe** an in
> der XML einstellbaren Achsen, **ABER**: Was in der **XML definiert** wird, wird durch die
> **Metaprogrammierung in der Binary Realität** in folgenden Träger-Stufen, wodurch der **Code die
> Wahrheit für die Freigabe** und die **XML die Wahrheit für die Realisierung** wird. Es wird **nur
> das eingebaut, was in der XML steht** (**std::variant verboten wie gehabt**, daher entspricht
> **jede Binary der XML Wahrheit und damit nur einer Teilmenge des Codes**)."*

    DIE GESCHICHTETE WAHRHEIT:
      CODE      = Wahrheit fuer die FREIGABE     (was gebaut werden KANN)
                  -> Registry wird daraus GENERIERT (Option 1, Generator + Contract-Test)
      XML       = Wahrheit fuer die REALISIERUNG (was gebaut WIRD)
                  -> Metaprogrammierung macht die XML-Auswahl zur Binary-REALITAET
                     in den folgenden Traeger-Stufen
      BINARY    = TEILMENGE des Codes, exakt der XML entsprechend
                  (std::variant VERBOTEN -- keine Laufzeit-Auswahl, die Auswahl
                   ist zur Compile-Zeit gefallen)

**Fork R1 ist damit entschieden UND präzisiert:** die 19.07.-Empfehlung (Code=Wahrheit,
Generator-Ausbau, Byte-Diff-Contract-Test) gilt — ergänzt um die Realisierungs-Schicht: **die
Registry ist die generierte Freigabe, die XML ist die verbindliche Auswahl, jede Binary ist die
XML-Teilmenge des Codes.** Das bindet R1 an KON19-03 (die XML-Syntax ist eine Programmiersprache)
und an D5 (Vorstufe dynamisch → Folgestufe CT).

⇒ **Registry-Arbeit in S-2/S-9 ist entblockt.**

---

### KON21-03 — 🔴 DIE FÜNF S-6-ANTWORTEN: S-6 IST ENTSPERRT

| # | Frage (KON20-03) | **Owner-Antwort** |
|---|---|---|
| 1 | SOLL = `MESS,SYSTEM,ORGAN` für alle drei Außen-Ebenen? #87=Argumentfolge, #78=POD-Folge? | *„**Ja genau, meint auch #87 und #78.**"* — SOLL gilt für **alle drei Ebenen** (Makro-Argumentfolge · POD-Feldfolge · Preimage-Glieder), #87 und #78 sind beide gemeint |
| 2 | Welcher Realm gibt die Preimage-Ordnung vor? | *„**Immer der vorangegangene Träger definiert die nächste Träger-Stufe, das ist dynamisch.**"* — die Ordnung ist **kein Realm-Attribut**, sondern folgt der **Träger-Kette**: jede Stufe definiert die nächste, dynamisch |
| 3 | Kategorien-Ordnungs-Wache als neuer Posten zu S-6? | *„**Ja bitte.**"* — die Wache (Vorbild `organ_gruppen_decken_die_komposition`) wird **Teil von S-6** |
| 4 | Transpositions-Sperre: mit S-6 oder vorgezogen? | *„**Mit S-6.**"* |
| 5 | #67 („4 Familien, 142 Include-Kanten", unbelegt): streichen/entkoppeln/belegen? | *„**Bitte explore und schärfen, behalten.**"* — #67 bleibt, die Zahlen werden per Explore neu erhoben |

**Zur Antwort 2, eingeordnet:** die Frage stellte Binaries-Welt (`S,O,M`) gegen Messdaten-Welt
(`M,S,O`) als statische Alternative. Die Antwort verwirft die Prämisse: **die Preimage-Ordnung
folgt der Träger-Hierarchie** — der vorangegangene Träger definiert die nächste Stufe. Das ist
konsistent mit dem SOLL `MESS→SYSTEM→ORGAN` (= Planer→CEB→Tier, die Stufigkeits-Ordnung) und
erklärt, warum das Lager als **Nicht-Träger** seine eigenen Zugriffs-Kaskaden behalten darf
(die „Ausnahme" aus KON6-02/4).

#### DER S-6-BAUAUFTRAG, JETZT VOLLSTÄNDIG GESCHNITTEN

    S-6a  Preimage-/Argument-/POD-Umstellung auf MESS, SYSTEM, ORGAN
          - Makro-Argumentfolge  anatomy_module_abi_v1.hpp:162/:213   (golden-Bruch)
          - POD-Feldfolge        anatomy_module_abi_v1_decl.hpp:200-243
            (APPEND-ONLY => LAYOUT-BUMP noetig; decl.hpp:293 verbietet Layout 7 --
             der Bump und das Verbot sind VOR dem Bau aufzuloesen)
          - Preimage-Glieder     anatomy_fingerprint.hpp:591-603 + Zwillinge + Testliterale
          - invalidiert alle Fingerprints: VOR F2 (heute kostenlos, nie eine Flotte gebaut)
    S-6b  TRANSPOSITIONS-SPERRE fuer die drei rohen string_view-Glieder   (mit S-6)
    S-6c  KATEGORIEN-ORDNUNGS-WACHE (neu, Owner-GO)                       (mit S-6)
    S-6d  #67 Benennung: explore + schaerfen, BEHALTEN -- Zahlen neu erheben
    VERBOTSZONEN (KON20-02): Lager-Kaskaden + kOrganGruppen* + kSystemAxisOrder
          + kCompositionAxisNames + Hash-Mechanik + Messwert-2-Tupel.
          Der Lager-Schluessel wandert automatisch mit.
