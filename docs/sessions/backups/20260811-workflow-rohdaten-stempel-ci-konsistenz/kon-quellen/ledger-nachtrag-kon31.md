## NACHTRAG 12.08.2026 — KON31: R-2 TECHNISCH PRÄZISIERT — DAS PRÜFLINGS-KONZEPT IST EINE MESS-UNTER-ACHSE DES PLANERS

**Owner verbatim 12.08.2026:**

> *„R-2 ist korrekt, aber **technisch gesehen eine Unter-Achse zur Laufzeit in den Mess-Achsen
> des Planers** und damit **kommuniziert in der CEB auch zu deren Laufzeit den Tier-Binary
> compiles freizugeben**. Sonst alles korrekt, **volles GO**."*

    DAS PRÜFLINGS-TEST-KONZEPT, technisch verortet:
      MODELLIERUNG:  UNTER-ACHSE (zur LAUFZEIT) in den MESS-ACHSEN DES PLANERS
      REISEWEG:      Planer (Laufzeit, Mess-Unter-Achse)
                     -> in der CEB kommuniziert (zu DEREN Laufzeit)
                     -> gibt die TIER-BINARY-COMPILES frei
      INHALT:        unveraendert KON30-02 -- der Pruefling erweitert je Organ-Achse
                     die Algorithmen (eigener Stempel), XML-beschraenkbar 1..3 Varianten

**Einordnung:** die *Steuerung* des Prüflings-Verbunds reist damit über die **dreiphasige
Mess-Kette** (Planer-Laufzeit → CEB-Laufzeit → Tier-Compile) — die *erweiterten
Organ-Algorithmen selbst* bleiben zweiphasig freigegeben (KON30-02). Konsistent mit
Haupt-statisch/Unter-dynamisch (D11) und der Mess-Achsen-Hoheit des Planers (§30).

**„Sonst alles korrekt, volles GO"** deckt: die R-1-Kartierung (WF6 läuft) · die
S-19-Präzisierung · die R-4-Streichung · die Wellen-Zuordnung KON27-04 · die
Debug-Betriebsdoktrin-Verbuchung.
