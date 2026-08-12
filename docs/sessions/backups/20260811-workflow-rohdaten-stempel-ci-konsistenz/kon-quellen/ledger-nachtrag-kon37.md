## NACHTRAG 12.08.2026 — KON37: ACHT OWNER-ANTWORTEN — DER WALLCLOCK-MERGE, DIE ANORDNUNGS-FREIGABE, UND DER DEBUG-UMSCHALTPUNKT LIEGT BEI T−3

**Der Owner hat die acht Fragen F-A…F-H aus der WF7-Vorlage beantwortet — alle acht. Zwei
Empfehlungen wurden gedreht (F-C: Reihenfolge zählt doch, als statische Freigabe · F-G: wieder
aufnehmen statt deprecaten), eine präzisiert den Terminplan (F-D: echte Messung bei T−3).
Zitate wörtlich, Kürzungen tragen `[…]`.**

---

### KON37-01 — 🔴 F-A BEANTWORTET: DER WALLCLOCK-MERGE GILT — UND DIE MESS-BESTÜCKUNG VERERBT SICH

**Owner verbatim 12.08.2026:**

> *„CEB gibt wallclock build auf der nächsten Träger-Stufe frei, **hat die CEB keine wallclock
> Messfühler, brauchen die dazugehörigen Tier-Binaries auch keine Fläche 3 Übertragung und
> Einrichtung von Wallclock time**. Effektiv wird aber die **Verwendung von Wallclock time auf
> CEB entschieden**. Daher gilt der **Merge**. Die CEB **ruft nur die Messfühler in der
> Tier-Binary und Hybrid auf, die sie selbst gebaut hat** bzw. **baut höhere Träger-Stufen nur
> nach ihren eigenen Messeigenschaften**. **Freigabe also auf Planer, Durchführung im Vertrag
> zwischen CEB und Tier/Hybrid.**"*

    DER MERGE (Lesart 2 bestaetigt -- beide Owner-Worte gelten, auf zwei Ebenen):
      FREIGABE      auf dem PLANER                        (Mess-Achse, Laufzeit)
      ENTSCHEIDUNG  die VERWENDUNG von Wallclock wird AUF DER CEB entschieden
                    (Schalter-Hoheit; KON25-03 "CEB = Wallclock an/aus" bleibt)
      DURCHFUEHRUNG im VERTRAG zwischen CEB und Tier/Hybrid (die dreiphasigen
                    Instrumentierungs-PUNKTE des F2-Gesetzes 06.08. bleiben verteilt)

    🔴 DIE VERERBUNGSREGEL (neu, tragend fuer B3 und den Stempel):
      die CEB BAUT hoehere Traeger-Stufen NUR NACH IHREN EIGENEN MESSEIGENSCHAFTEN
      und RUFT NUR die Messfuehler auf, DIE SIE SELBST GEBAUT HAT.
      => KEINE CEB-Wallclock  =>  KEINE Flaeche-3-Wallclock-Uebertragung/-Einrichtung
         in ihren Tier-Binaries. Die Mess-Bestueckung der Kinder FOLGT der CEB.

**Konsequenz für B3:** der „Wallclock-Umzug Tier→CEB" ist **kein physischer Umzug der
Instrumente**, sondern der Umzug der **Schalter-Hoheit** (der heutige Tier-Pflicht-Wurf
`abi_adapter.hpp:476-491` fällt zugunsten der CEB-Entscheidung). Die Tier-Gates bleiben —
gebaut werden sie nur noch, wenn die erzeugende CEB Wallclock trägt. **Der
Wallclock-SOLL-Konflikt (KON36-01) ist damit aufgelöst: Merge, kein Widerruf.**

---

### KON37-02 — 🔴 F-B BEANTWORTET: DAS AUSWAHL-SUBSYSTEM WIRD NEU GEBAUT, DAS ELEMENT ERWEITERT, DAS ALTE ARCHIVIERT

**Owner verbatim:**

> *„Am besten **direkt neu nach der geänderten Architektur. Das alte archivieren.** Bitte
> bedenke die **Korrelation zwischen Freigabe und Ausführung durch Permutation einer
> freigegebenen Konfiguration per compile time einer höheren Träger-Stufe**. **Ja erweitern
> wie empfohlen, genau wie beschrieben.**"*

    B1 PRAEZISIERT (zweischichtig):
      XML-ELEMENT      <measurement_tooling> wird ERWEITERT (Stufen-Dimension
                       tier/hybrid/ceb statt nur `tools`) -- wie empfohlen
      IMPLEMENTIERUNG  measurement_tooling_registry/canonical_combo werden NEU gebaut
                       nach der geaenderten Architektur (Stufen-Dimension,
                       Belegungs-Zaehlung <= 32); das ALTE wird ARCHIVIERT
                       (konsolidieren -> archivieren -> in der Zielform aktivieren)
      🔴 KORRELATIONS-PFLICHT: FREIGABE (Planer, Laufzeit) und AUSFUEHRUNG korrelieren
                       ueber die PERMUTATION einer FREIGEGEBENEN Konfiguration
                       PER COMPILE TIME der HOEHEREN Traeger-Stufe
                       (= die Filterketten-Mechanik KON9-06, jetzt fuer die Mess-Schalter)

---

### KON37-03 — 🔴 F-C GEDREHT: DIE REIHENFOLGE ZÄHLT — ALS STATISCHE ANORDNUNGS-FREIGABE IN DER MESS-ACHSE

**Owner verbatim:**

> *„Ja die **Reihenfolge muss in einer beliebigen Anordnung statisch in der Mess-Achse
> freigegeben werden, damit die Zeiger und Zustände für an/aus für jede Stufe klar definiert
> ist**. An und für sich hat **jede Stufe also ihre ganz spezifischen Wallclock/Macro/Micro
> compile time Einrichtungen bzw. ein subset der 3**. Die **statische Festlegung „Wie viel"
> ist technisch nicht umsetzbar ohne Planer Simulation**."*

    MEINE EMPFEHLUNG ("nur an/aus") WAR ZU ENG. Es gilt:
      ANORDNUNG   die Reihenfolge wird STATISCH in der MESS-ACHSE FREIGEGEBEN,
                  in BELIEBIGER Anordnung -- ihr ZWECK: die ZEIGER und ZUSTAENDE
                  fuer an/aus sind JE STUFE klar definiert (Adressierungs-Struktur)
      SUBSET      JEDE Stufe traegt ihre spezifischen Wallclock/Macro/Micro-
                  compile-time-Einrichtungen -- ein SUBSET DER DREI
                  (nicht mehr fest "Tier=Micro/Macro, CEB=Wallclock" als Typzwang;
                   die KON25-03-Zuordnung ist die SOLL-BELEGUNG, kein Typ-Verbot)
      WIE VIEL    erst die PLANER-SIMULATION (S-19) -- statisch nicht festlegbar

**Konsequenzen:** **KON34-06(b) ist GESCHLOSSEN** — die Ordnung hat einen Gegenstand, aber
einen **anderen als die alte 6**: sie ist **Freigabe-/Adressierungsstruktur** (statisch, in
der Mess-Achse), keine eigene Permutations-Dimension des Nenners. **B4 präzisiert:** System B's
geordnete Typliste bekommt exakt diese Zielrolle — die statische Anordnungs-Freigabe, über die
die an/aus-Zustände je Stufe adressiert werden (statt `anzahl==6`-Vollmengen-Permutation).
Der Nenner 32 bleibt das Belegungs-Maximum.

---

### KON37-04 — 🔴 F-D BEANTWORTET: `--debug` FÄLLT DREI TAGE VOR DER ABGABE — DIE ECHTE MESSUNG LIEGT BEI T−3

**Owner verbatim:**

> *„**--debug wird 3 Tage vor Abgabe aufgehoben und echt gemessen.** Daher wie empfohlen."*

    UMSCHALTPUNKT  T-3 = ~Sa 12.09.2026 (Abgabe Di 15.09.)
    DAVOR          die gesamte Kette inkl. W3-Kampagne faehrt --debug
                   (nproc-parallel, UNGENAUE Werte -- Verdrahtungs-Verifikation)
    AB T-3         --debug aufgehoben, ECHT gemessen (1 Thread, deterministisch);
                   die ungenauen Debug-Ergebnisse werden GELOESCHT (KON29-01)

**Planungs-Ripple (auszuweisen, nicht glattzurechnen):** die **echte Messung liegt damit im
bisherigen W5-Fenster** (12.–15.09., bisher „Sicherung, keine Bau-Eingriffe"). Das trägt nur,
wenn die Kette bis dahin **vollautomatisch** XML→PDF regeneriert (Messung + Auswertung +
Anhang ohne Handarbeit) und das Lager den Bau-Anteil per Skip deckt — die W3-„Kampagne" wird
zur Debug-Generalprobe, die W4-Auswertung entwickelt an Debug-Zahlen. **Geht in die
WF8-Strecke als harter Termin-Anker.**

---

### KON37-05 — F-E BEANTWORTET: E-LABEL-UMBENENNUNG GENEHMIGT — UND DIE LASTSEQUENZ IST EINE FRAMEWORK-MESS-ACHSE

**Owner verbatim:**

> *„Ja wie empfohlen. Dabei ist besonders zu beachten, dass die **Lastsequenz in die framework
> Mess-Achse gehört** und **nicht in derselben Klasse liegt wie ein
> Gattungsaufruf/Genusaufruf/Achsen-Interface-Aufruf, weil sie selbst auf einem
> Achsen-Interface liegt**."*

    GENEHMIGT: die Erhebungs-Ebenen werden UMBENANNT (E1-E4 gehoert kuenftig
    eindeutig der Experiment-Maschinerie).
    🔴 KLASSEN-KORREKTUR dabei: die drei alten "Erhebungs-Ebenen" sind NICHT
    gleichrangig -- Achsenaufruf / Gattungs-(Genus-)Aufruf sind AUFRUF-EBENEN,
    die LASTSEQUENZ ist eine FRAMEWORK-MESS-ACHSE (sie liegt SELBST auf einem
    Achsen-Interface) und wird dort einsortiert, nicht als dritte "Ebene".

---

### KON37-06 — F-H BEANTWORTET: JE 5 FEHLVERSUCHE FÜR BUILD **UND** MESSUNG · 3 ERFOLGS-WERTE EINZELN · NEUER EXPLORE: CACHE-WARMUP

**Owner verbatim:**

> *„Es heißt **ein build oder eine Messung dürfen je 5 Mal scheitern bis wir aufgeben** und
> eine **Messung wird bei Erfolg insgesamt 3 Mal je Parameter und Binary wiederholt und alle
> 3 Werte EINZELN persistiert** (**explore zu cache warmup bei Messung über die letzten 10
> wochen**)."*

    RETRY      BUILD und MESSUNG duerfen JE 5 MAL scheitern -> dann aufgeben
               (die T-15b-Klammer gilt also fuer BEIDE Vorgaenge, je 5 -- nicht 1+5)
    ERFOLG     3 Wiederholungen JE PARAMETER UND BINARY, alle 3 Werte EINZELN
               persistiert (KF-10 bestaetigt; NIE gemittelt)
    🔴 NEUER EXPLORE-AUFTRAG E-WARMUP: "cache warmup bei Messung" ueber die
               letzten 10 Wochen foerdern (Sessions/Plaene/Code/Transkripte)

**T-15b-Detailfragen 13+14 (WF4 §4) sind damit geschlossen;** Task #13 baut mit: Klammer um
Build UND Messung, je 5.

---

### KON37-07 — F-F BEANTWORTET: DIE VIER KLONE SIND ZIELZUSTAND — UNTER KONSOLIDIERUNGSPFLICHT

**Owner verbatim:**

> *„Diese fallen alle in die **Konsolidierungspflicht und die Aufräum Aufgabe um eine saubere
> Ziel-Architektur der Projektstruktur zu erreichen**, daher **Zielzustand wie geplant
> bestätigen**."*

⇒ W-6 ist geschlossen: die vier lokalen Klone sind der **bestätigte Zielzustand** (mit
Sync-Pflicht, Memory-Doktrin gilt) — ihre Ordnung gehört zur **Konsolidierungs-Architektur
(#88)**, nicht zu einem Rückbau.

---

### KON37-08 — 🔴 F-G GEDREHT: DIE SKELETT-TESTVERZEICHNISSE WERDEN WIEDER AUFGENOMMEN

**Owner verbatim:**

> *„Bitte **wieder aufnehmen, deren Kern konsolidieren und Pflegen. Jeden Test prüfen, was er
> testet und ob er noch gebraucht wird, ggf. die Tests in die Ziel-Testmodule aufteilen bzw.
> neu verteilen**."*

    MEINE EMPFEHLUNG ("deprecaten bis W7") IST ABGELEHNT. Neuer Posten
    TEST-KONSOLIDIERUNG: die drei Verzeichnisse (integration ·
    generic_module_tests · module_specific_tests) bekommen einen Eigentuemer;
    JEDER Test wird geprueft (was testet er? wird er gebraucht?); die Tests
    werden in die ZIEL-TESTMODULE aufgeteilt/neu verteilt.
    Dockt an S-16 (Shell->GTest) und die Konsolidierungs-Architektur an.

---

### KON37-09 — BILANZ

    GESCHLOSSEN:  F-A (Wallclock-Merge + Vererbungsregel) · F-B (neu + erweitern +
                  archivieren + Korrelations-Pflicht) · F-C (Anordnungs-Freigabe,
                  KON34-06(b) zu) · F-D (T-3-Umschaltpunkt) · F-E (E-Labels +
                  Lastsequenz-Einordnung) · F-H (5/5 + 3 einzeln; T-15b-Details zu) ·
                  F-F (W-6 zu: Zielzustand) · F-G (Test-Konsolidierung statt deprecaten)
    NEU:          E-WARMUP-Explore (cache warmup, 10 Wochen) · Posten Test-Konsolidierung ·
                  B1/B3/B4-Praezisierungen (Vererbungsregel · Neubau+Archiv ·
                  Anordnungs-Freigabe) · T-3-Termin-Anker fuer die WF8-Strecke
    LAEUFT:       WF8 (wf_4ec570cc, Wellenkonsolidierung + strategische Reihenfolge) --
                  sein Ergebnis wird GEGEN KON37 abgeglichen, bevor es landet
