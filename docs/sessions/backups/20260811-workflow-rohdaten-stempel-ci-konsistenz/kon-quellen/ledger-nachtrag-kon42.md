## NACHTRAG 12.08.2026 — KON42: OF-2-NEU BEANTWORTET — DIE DOCK-32 IST EIN PROGRAMM-DECKEL, DIE DEFAULT-DOKTRIN IST GESETZT, UND DER HYBRID IST ZWEIWEGIG XML-STEUERBAR

**Owner verbatim 12.08.2026:**

> *„Wir bestätigen die **32 als statische Maximal-Variable der Hybrid-Prüfdocks um die
> Programmgröße einer multi-release Lösung zu deckeln**. Der **Wert ist willkürlich und wird
> später in W7 angepasst**. Ich bestätige, dass **all diese Variablen standardmäßig hart in den
> Planer als default einkompiliert werden und durch jede vorhandene Eingabe in die XML
> überschrieben werden**. Ich bestätige **sonst exakt alles was du dazu gesagt hast**. Die
> **Belegung des Hybrid ist zudem durch die XML als Durchstich für den Hybrid manuell statisch
> wählbar** oder Die **Synthese-Funktionen und Wirkbereiche einzelner Tier-Binaries in der
> Hybrid manuell per XML setzbar**."*

---

### KON42-01 — DIE VIER FESTLEGUNGEN

    (1) DOCK-32 = PROGRAMM-DECKEL, kein Fach-Nenner:
        die 32 der Hybrid-Pruefdocks ist eine STATISCHE MAXIMAL-VARIABLE, deren Zweck
        die DECKELUNG DER PROGRAMMGROESSE einer MULTI-RELEASE-Loesung ist. Der Wert
        ist WILLKUERLICH und wird in W7 angepasst. (Sie ist damit endgueltig von den
        Mess-Belegungen entkoppelt -- KON41-03 bestaetigt.)

    (2) 🔴 DIE DEFAULT-DOKTRIN (neu, traegt S-8/Planer-Design):
        ALLE diese Variablen (Maximal-/Konfigurations-Variablen) werden STANDARDMAESSIG
        HART IN DEN PLANER ALS DEFAULT EINKOMPILIERT und durch JEDE VORHANDENE
        XML-EINGABE UEBERSCHRIEBEN.
        => Kein Pflicht-Attribut in der XML fuer Deckel-Werte; der Planer traegt die
        Defaults compile-time, die XML ist der Override-Kanal. (Konsistent mit der
        geschichteten Wahrheit KON21-02: Code=Freigabe, XML=Realisierung.)

    (3) OF-2-NEU VOLLSTAENDIG BESTAETIGT ("sonst exakt alles"):
        32 = strukturelles MAXIMUM allein der MESS-BELEGUNGEN (2^5-Schalter, KON25-03)
        · real gefordert je XML/Planer · die GROESSEN der Permutations-Schichten
        kommen AUSSCHLIESSLICH aus der S-19-Simulation · die Hybrid-Dock-Zahl ist
        davon unabhaengig. => S-19 hat seinen Mess-Faktor sauber definiert.

    (4) 🔴 DER HYBRID IST ZWEIWEGIG XML-STEUERBAR (neu, traegt HY-A3/B1):
        Weg (i):  die BELEGUNG des Hybrid ist per XML als DURCHSTICH manuell
                  STATISCH waehlbar (welche Tier-Binaries an den Docks)
        Weg (ii): die SYNTHESE-FUNKTIONEN und WIRKBEREICHE einzelner Tier-Binaries
                  im Hybrid sind manuell per XML setzbar
        => der <hybrid_tier>-Parser (HY-A3) traegt BEIDE Wege; die Wirkbereiche
        korrespondieren mit der Komposit-Map des Hybrid-Stempels (KON41-04:
        Synthese-Funktions-Keys -> Pruefdock-Stempel) und den Break-Even-Grenzen
        der Bereichs-Karte (KON7-05).

---

### KON42-02 — KONSEQUENZEN FÜR DIE STRECKE

* **S-19 (#7):** rechnet die Mess-Dimension als „geforderte Belegungen ≤ 32"; die
  Dock-Variable geht als **Programm-Deckel-Konstante** ein, nicht als Kombinatorik-Faktor.
* **S-8/Planer:** die **Default-Doktrin** wird Bau-Auflage — Deckel-/Config-Variablen als
  `constexpr`-Defaults im Planer, XML-Override je Attribut; Q6-MaxN-Korrektur (8→32,
  Strecken-Posten 9) baut direkt die Default-Form.
* **HY-A3 (Strecken-Posten 26):** der `<hybrid_tier>`-Parser bekommt die zwei Steuerwege
  (statische Dock-Belegung ODER Synthese-Funktionen+Wirkbereiche je Tier-Binary).
* **W7-Posten (gezählt):** Dock-Deckel-Anpassung (der willkürliche 32er-Wert).
* **Offene Owner-Fragen: NULL.** (v3.5-GO wartet als Vorlage, blockiert nichts.)
