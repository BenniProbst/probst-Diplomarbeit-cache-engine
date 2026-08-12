## NACHTRAG 12.08.2026 — KON17: DIE VIER LETZTEN ANTWORTEN — UND EINE RÜGE, DIE DIE PRIORITÄT SETZT

**Der Owner hat die vier offenen Fragen aus KON16-10 beantwortet. Frage 10 ist eine Korrektur
meiner Prämisse und setzt die Bau-Reihenfolge nach dem Stempel: XML → gesamte Kette → PDF.**

---

### KON17-01 — FRAGE 6: DAS BAU-MODUL BAUT ANFORDERUNGSGETRIEBEN. DIE ZAHL KOMMT AUS DER PLANUNGS-SIMULATION.

> *„Das Baumodul baut jede Träger Stufe auf die **Wünsche, Anforderungen und Freigaben der
> vorangegangenen Träger-Stufe** (**Nur Planer wird direkt kompiliert**). Jeder **CEB Bau sollte
> aufgrund von RAM sequentiell** durchgeführt werden, ebenso die Builds, die dann die CEB
> ihrerseits **verlangt und registriert**. Die **Zahl der Tier-Binaries** (und je XML Anforderung
> des Planers) muss durch den geforderten **Algorithmus der Planungs-Simulation** noch berechnet
> werden, er ist **Pflicht nach der stempel Aufgabe und schon geplant**."*

**Meine Frage „je Typ oder je Instanz?" war falsch dimensioniert.** Das Bau-Modul hat weder vier
starre Vorschriften noch eine je Instanz — es baut **anforderungsgetrieben**:

    Stufe N baut, was Stufe N-1 WUENSCHT, ANFORDERT und FREIGIBT.
    NUR der Planer wird direkt kompiliert -- alles danach entsteht durch Emission.

    SEQUENTIALITAET (RAM):  jeder CEB-Bau sequentiell,
                            ebenso die von der CEB verlangten UND REGISTRIERTEN Builds
    -> deckt sich mit der stehenden Doktrin "Pipelines streng sequentiell, sonst OOM"
    -> "registriert": die CEB traegt ihre verlangten Builds ins Bestandslog/Lager ein

**Die Instanzzahl ist ein Laufzeit-Ergebnis, keine Bau-Vorschrift-Größe:** die Zahl der
Tier-Binaries je XML-Anforderung berechnet der **Algorithmus der Planungs-Simulation** —
**Pflicht nach der Stempel-Aufgabe, schon geplant**. Das deckt sich mit der Doktrin vom 10.08.:
*„Binary-Zahl NUR vom fertigen Planer."*

⇒ **Neuer benannter Bau-Posten: die Planungs-Simulation** (nach dem Stempel, vor bzw. am Kopf
der Kette). Bestands-Pflicht vor dem Bau: der Owner sagt **„schon geplant"** — der Plan ist zu
finden, nicht neu zu erfinden.

---

### KON17-02 — FRAGE 7: BESTÄTIGT. DIE EMISSION ENDET IM LAGER.

> *„Das ist korrekt. Die **Emission ist abgeschlossen, wenn die angeforderten CEBs und
> Tier-Binaries und Hybrid im Lager zu finden sind** und damit in der Phase der Messung verwendet
> werden können."*

Bestätigt ist die Neufassung: die Emission einer Träger-Stufe umfasst mehr als Compile+Link, und
**J-1…J-4 muss mitemittiert werden** (sonst falsches Grün).

**Und das Abschluss-Kriterium ist ein Lager-Kriterium, kein Bau-Kriterium:**

    Emission FERTIG  <=>  angeforderte CEBs + Tier-Binaries + Hybrid stehen IM LAGER
                          und sind damit fuer die MESS-Phase verwendbar

    NICHT fertig bei: "kompiliert", "gelinkt", "Tests gruen", "Prozess beendet".

Das bindet die Emissions-Kette an die Lager-Schlüssel-Rolle des Stempels (Rolle 3 von 5,
bisher nur test-gerufen) — **ohne funktionierenden Lager-Schlüssel ist „im Lager zu finden"
nicht prüfbar**. Die zwei undurchgesetzten Stempel-Rollen sind damit auf dem kritischen Pfad
der Emission.

---

### KON17-03 — FRAGE 12: DIE WACHE WIRD MODULAR ERWEITERT UND IN DETAIL-KLASSEN GESPLITTET.

> *„Wache **Modular erweitern** und in **Detail-Klassen splitten**."*

Weder „einfach erweitern" noch „zweite daneben": **EINE Wache, modular, in Detail-Klassen
gesplittet.** Die C-4-Trennung („trennen und verdrahten") passiert also **innerhalb** der Wache
als Klassen-Split, nicht durch ein zweites Werkzeug daneben.

---

### KON17-04 — 🔴 FRAGE 10: NEIN. S-13 IST DER KERN DER ABLAGE. DIE RÜGE.

> *„**Nein das ist der Kern der Ablage, Opus 5 hat wieder still und heimlich alles
> ausgeklammert.** Wir beginnen bei der **XML** und bauen von der **Struktur der Prioritäten**
> her **nach dem Stempel** von der XML die **gesamte Kette bis zur PDF** durch **von vorn nach
> hinten, mit allen Abzweigungen, die auf dem Weg auftreten**. Bitte explore über die **letzten
> 5 Kontexte**, um dich einzulesen, meine Owner Nachrichten waren hier **Reich an Schärfung**
> für diese Session."*

**Meine Prämisse war falsch — und sie war die Fehlerklasse selbst.** Ich habe S-13 als
„stand im Plan als post-Abgabe" geführt und dem Owner die Wahl gelassen. Die Antwort: die
Ablage-Struktur ist **der Kern**, und das „post-Abgabe" war ein **stilles Ausklammern** — die
Rüge benennt es als Wiederholungsfall (*„wieder still und heimlich"*).

**DIE BAU-REIHENFOLGE NACH DEM STEMPEL — jetzt gesetzt:**

    1. STEMPEL-AUFGABE            (laeuft -- Thema A)
    2. PLANUNGS-SIMULATION        (Pflicht, "schon geplant" -- berechnet die Binary-Zahl
                                   je XML-Anforderung; KON17-01)
    3. VON DER XML AUS DIE GESAMTE KETTE BIS ZUR PDF
       -- von VORN nach HINTEN
       -- nach der STRUKTUR DER PRIORITAETEN
       -- MIT ALLEN ABZWEIGUNGEN, die auf dem Weg auftreten
       (die Ablage/S-13 ist dabei KERN, nicht Anhang)

⇒ **Explore-Auftrag, sofort:** die letzten **5 Kontexte** dieser Session einlesen — die
Owner-Nachrichten dort sind *„reich an Schärfung"* und die verbindliche Quelle für die
Detail-Gestalt der Kette.

---

### KON17-05 — WAS DAMIT STEHT

    BEANTWORTET:  Frage 6 (anforderungsgetrieben, Zahl aus Planungs-Simulation)
                  Frage 7 (Emission endet IM LAGER)
                  Frage 12 (Wache modular erweitern + Detail-Klassen-Split)
                  Frage 10 (S-13 = KERN; XML->PDF-Kette nach dem Stempel)
    NEU:          Bau-Posten Planungs-Simulation (schon geplant -- Bestand suchen!)
                  Lager als Abschluss-Kriterium der Emission
                  -> Stempel-Rollen 2+3 (Cache-/Lager-Schluessel) liegen auf dem
                     kritischen Pfad der Emission
    LAUFEND:      WF1 (neun Owner-Straenge) · WF2 (zwei Welten + leere Klassen)
                  · der 5-Kontexte-Explore (dieser Auftrag)
