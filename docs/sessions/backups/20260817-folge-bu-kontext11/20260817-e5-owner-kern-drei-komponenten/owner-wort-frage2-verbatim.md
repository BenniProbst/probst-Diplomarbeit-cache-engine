# E-5 OWNER-KERN (Frage 2, 17.08.2026 abends) — DIE KONSUMKETTE DES EINEN SYSTEMS
# Owner verbatim (vollstaendig, Sicherung fuer KON109):

"Der measurement_curve_loader ist das Puzzleteil, das aus bereits bestehenden
Mess-Parametern, wobei in der XML auch bestimmte zu optimierende Messwerte gewuenscht
werden koennen, zeitliche Kurven ueber die echten Messwert-Parameter der w/ma/mi Ebenen
ermittelt und synthetisiert. Das hier scheint mir also der korrekte Einstiegspunkt fuer
die Funktions-Synthese zu sein. Es kann multiple Schnittepunkte geben, die dann also
Bereiche erkennen lassen, in denen das eine Tier-Binary fuer eine Last staerker ist als
ein anderes. Dieser Vorgang ist sehr rechenaufwaendig, weil faktisch jede Parameterklasse
einer Tier-Binary als Funktion synthetisiert und gegen alle anderen Tier-binaries
verglichen werden muss - uebrig bleiben die Bereiche je Parameter-Wert fuer die eine
bestimmte Tier-Binary unter der Vorgeschichte eines bestimmten inneren Zustandes
(tracing der Operationen auf den Genus-Interfaces und Achsen-interfaces) am besten
geeignet ist. Da es dann je Parameter diese Abschnitte gibt, fragt sich, wie die
einzelnen Parameter zu gewichten sind fuer die Gesamtperformance (Anwender kann das
default in der XML ueberschreiben) und daher ergeben sich ueber den gesamten Mix aller
Parameter Bereiche zusammengezogen auf eine Linie eine Punktemaessige
Ueberlagerungsbewertung des besten Gesamt-Algorithmus ueber multiple Streckenabschnitte
-> das ist der curve_fit der eigentlich den ersten Teil konsumieren sollte, weil ohne
Funktions-Synthetik die curve fit nicht auswertbar sind. Der Hybrid macht nichts
anderes, als den vorbereiteten curve_fit fuer das Laden der fuer eine heuristisch
gemessen/erkannte Last, die optimalen und top-ranking 32 Tier-Binaries in seine
Pruef-Docks zu laden und je Last-Vorbedingung und geschaetztem benoetigten Profil
anzusprechen. Und da kommen wir zur Komponente 3, welche genau den curve_fit konsumiert
und die beste binary dann aus der synthetisierten Bereichs-linie (aus der Berechung der
ranking Parameter-Bewertungs-Schnitte) immer das passende Binary auswaehlt und abwaegt,
ob sich die Latenz fuer den Wechsel von einem Pruef-Dock am hybriden auf ein anderes
Lohnt -> zu feingranulare Wechsel vermeiden. Es ist ein System aus genau diesen
3 Komponenten, stelle gerne weitere Rueckfragen. Die Vermutung war korrekt. Ich
beantworte gleich weiter."

# DESTILLAT (Lead) — die Konsumkette:
STUFE 1  measurement_curve_loader (+ AxisSpline/BreakEven als Mathematik-Kern):
         EINSTIEGSPUNKT der Funktions-Synthese. Zeitliche Kurven ueber die ECHTEN
         Messwert-Parameter der w/ma/mi-Ebenen; XML kann zu optimierende Messwerte
         WUENSCHEN (Ziel-Auswahl). All-vs-All: JEDE Parameterklasse jeder Tier-Binary
         als Funktion synthetisiert und gegen ALLE anderen verglichen (rechenaufwaendig,
         bewusst). Ergebnis: BEREICHE je Parameter-Wert, in denen EINE Tier-Binary am
         besten geeignet ist — KONDITIONIERT auf die Vorgeschichte eines inneren
         Zustandes (TRACING der Operationen auf Genus- und Achsen-Interfaces).
STUFE 2  curve_fit (KONSUMIERT Stufe 1 — "ohne Funktions-Synthetik nicht auswertbar"):
         GEWICHTUNG der Parameter fuer die Gesamtperformance (Default; Anwender-
         Override per XML) -> Ueberlagerung ALLER Parameter-Bereiche zusammengezogen
         auf EINE LINIE = punktemaessige Ueberlagerungsbewertung des besten
         Gesamt-Algorithmus ueber multiple STRECKENABSCHNITTE (Bereichs-Linie).
HYBRID   laedt den VORBEREITETEN curve_fit: je heuristisch gemessener/erkannter Last
         die optimalen TOP-RANKING 32 Tier-Binaries in seine PRUEF-DOCKS; Ansprache je
         Last-Vorbedingung + geschaetztem Profil. (32 = Dock-Deckel.)
STUFE 3  best_binary_selector-B (KONSUMIERT curve_fit): waehlt aus der synthetisierten
         Bereichs-Linie (ranking Parameter-Bewertungs-Schnitte) IMMER das passende
         Binary + WECHSELKOSTEN-ABWAEGUNG: lohnt die Latenz des Dock-Wechsels?
         -> zu feingranulare Wechsel vermeiden (Anti-Flattern).

# NEUE ELEMENTE (bisher in keinem der drei Designplaene):
1. XML-Ziel-Wunsch (zu optimierende Messwerte waehlbar) am Loader-Eingang.
2. Zustands-Vorgeschichte als Kurven-Dimension (Tracing Genus-/Achsen-Interface-Ops).
3. Parameter-Gewichtung: Default + XML-Override.
4. Ueberlagerung -> EINE Bereichs-Linie mit Streckenabschnitten (Punktebewertung).
5. Top-32-Ranking fuellt die Pruef-Docks (verbindet Dock-Deckel 32 mit curve_fit).
6. Wechselkosten-Abwaegung im Selector (Anti-Flattern; Naehe zu KON97-M-2 FLATTERN-
   Ausloeser + Hybrid-Mess-Schicht "Overhead des Reroutes").
