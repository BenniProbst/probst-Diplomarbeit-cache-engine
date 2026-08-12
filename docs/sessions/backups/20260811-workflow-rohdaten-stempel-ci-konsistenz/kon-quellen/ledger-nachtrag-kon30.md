## NACHTRAG 12.08.2026 — KON30: R-1…R-4 BEANTWORTET — PRÜFLINGS-KONZEPT, SIMULATIONS-WEG, UND EINE STREICHUNG

---

### KON30-01 — R-1: VERSTÄNDNIS-AUFTRAG — DIE MESSEINRICHTUNGEN JE TRÄGER-STUFE KARTIEREN

**Owner verbatim 12.08.2026:**

> *„bitte **verstehe die Messeinrichtungen in jeder Träger-Stufe** und dann wird es klar, wenn du
> verstehst **wo was hingehört und ein oder aus geschalten werden kann bezüglich der
> Messachsen**."*

⇒ Die 32-vs-6-Frage wird **nicht per Entscheid, sondern per Verständnis** aufgelöst: die
Kartierung *Messeinrichtung → Träger-Stufe → schaltbar ein/aus* macht klar, welche Rolle der
6er-Anordnungs-Maschinerie bleibt. Arbeitsstand der Zuordnung (KON25-03): **CEB = Wallclock
(an/aus) · Tier = Micro+Macro (je an/aus) · Hybrid = eigene Micro+Macro (je an/aus)** ⇒ 32
Belegungen. Der Kartierungs-Auftrag läuft (Task); das Ergebnis wird als KON-Nachtrag vorgelegt,
**nicht** als neue Owner-Frage.

---

### KON30-02 — 🔴 R-2 BEANTWORTET: DAS DRITTE KONZEPT IST DAS PRÜFLINGS-TEST-KONZEPT

**Owner verbatim:**

> *„Das ist korrekt, dass dies das **Prüflings-Test-Konzept** ist und in der XML auf **beliebige
> 1 bis 3 angebotene Varianten beschränkt** werden kann, die wir hier sehen. Es beschreibt ein
> **ganz anderes Konzept und andere Achse der Verbund- und Teststruktur**. Hier werden die
> **zusätzlich in einem Prüfling angebotenen Achsen-Algorithmen der Organ-Achsen der CEB zur
> Freigabe aus der System-Achse mitgegeben (ZWEIPHASIG)**, um diese beim Bau ebenfalls in
> **experimentelle Tier-Binaries zu kompilieren und durchzumessen**. Ein **beliebiger abstrakter
> Satz an Achsen-Genus-Interfaces** bekommt hier durch den Prüfling **je Organ-Achse zusätzlich
> zugeordnete Organ-Achsen-Algorithmen**, die **im Prüfling verbucht und versioniert sind - mit
> eigenem Stempel und allem** - und so den **Permutations-Satz eines Experiment-Rahmens
> erweitern**. Das betrifft also **nur die Erweiterung der Organ-Achsen zur compile time der
> Tier-Binaries und zur Laufzeit der CEB nach Planer-XML Plan**."*

    DAS PRÜFLINGS-TEST-KONZEPT (die XSD-Merge-"Stufen1..3"):
      IST:      eine eigene Achse der VERBUND- und TESTSTRUKTUR --
                weder Traeger-Stufe (Binary) noch Phase (Modi)
      XML:      beschraenkbar auf beliebige 1 bis 3 angebotene Varianten
      MECHANIK: der PRUEFLING (PRT-ART) bietet je Organ-Achse ZUSAETZLICHE
                Achsen-Algorithmen an -- im Pruefling verbucht und versioniert,
                MIT EIGENEM STEMPEL UND ALLEM
                -> der CEB ZUR FREIGABE aus der System-Achse mitgegeben (ZWEIPHASIG)
                -> beim Bau in EXPERIMENTELLE Tier-Binaries kompiliert + durchgemessen
      WIRKUNG:  ERWEITERT den Permutations-Satz eines Experiment-Rahmens
      GRENZE:   betrifft NUR die Organ-Achsen-Erweiterung zur COMPILE-TIME der
                Tier-Binaries und zur LAUFZEIT der CEB, nach Planer-XML-Plan

**Konsequenzen:** die drei `MergeStrategy`-Werte sind **Prüflings-Verbund-Varianten** (CeOnly /
PrueflingReplace / FullJoin — deckt sich mit D14). Der künftige Name gehört zur
**Prüflings-/Verbund-Familie**, nicht zu Stufe/Phase — der konkrete Bezeichner wird beim
S-6-Fenster-Bau vorgeschlagen (Golden-Byte-wirksam). Und: **der Prüfling trägt eigene Stempel**
— die Prüflings-Algorithmen sind vollwertige Versionierungs-Objekte (deckt sich mit D8:
Organ-Registry + prt_art als Prüflings-Organ-Angebot, und mit KON21-02: Registry = Freigabe).

---

### KON30-03 — 🔴 R-3 BEANTWORTET: DIE SIMULATION GIBT ES NOCH NICHT — DER WEG IST GRUPPIEREN → KATEGORISIEREN → RECHNEN

**Owner verbatim:**

> *„Weiterhin **gibt es die Planungs Simulation noch nicht**, weil die **Achsen im Planer zur
> Simulation noch nicht gruppiert und kategorisiert wurden**, um über den **gesamten
> Experiment-B+-Baum die tatsächliche Permutation zu errechnen**. Weil **jede Achse
> unterschiedlich viele Möglichkeiten und Methoden/Algorithmen hat**, entstehen hier
> **Abstufungen, die wir ohne Programm nicht abschätzen KÖNNEN**. Bitte gehe das **wie geplant
> strategisch durch**, sonst kommen wir nie auf einen Wert. **Wir beginnen beim Bau genau in der
> Träger-Stufen-Reihenfolge um das zu erreichen.**"*

    S-19 PRÄZISIERT -- der Weg zur Zahl:
      1. die Achsen IM PLANER zur Simulation GRUPPIEREN und KATEGORISIEREN
      2. ueber den GESAMTEN Experiment-B+-Baum die tatsaechliche Permutation ERRECHNEN
      (jede Achse hat unterschiedlich viele Moeglichkeiten/Methoden/Algorithmen --
       die Abstufungen sind OHNE PROGRAMM nicht abschaetzbar)

    DIE BAU-REIHENFOLGE-DOKTRIN:  der Bau beginnt GENAU in der
      TRAEGER-STUFEN-REIHENFOLGE:  PLANER -> CEB -> TIER -> HYBRID

⇒ **B-4 (Bau-Menge) ist keine Owner-Zahl** — die vier Kandidaten bleiben Kandidaten, bis die
Simulation rechnet. **Der Bau der Kette beginnt beim Planer** (deckt sich mit „nur der Planer
wird direkt kompiliert"): erst die Achsen-Gruppierung/-Kategorisierung im Planer, dann die
Simulation, dann die Zahlen, dann der Trigger.

---

### KON30-04 — 🔴 R-4 GESTRICHEN: DIE „GERADE ANZAHL"-INVARIANTE GILT NICHT MEHR

**Owner verbatim:**

> *„**Das gilt nicht mehr und ist gestrichen**, es rührt eigentlich daher, dass es nur eine
> **gerade Anzahl an CEBs** geben kann. Die **Hybrid-Docks sind davon komplett ausgenommen und
> tragen jede beliebige Anzahl bis 32 Prüfdocks**. Bitte **streiche diesen missverständlichen
> Punkt überall wo du ihn findest.**"*

    GESTRICHEN:  "es kann nur eine gerade Anzahl an Pruefdocks geben" (Z. 35020)
    HERKUNFT:    die Invariante meinte die GERADE ANZAHL AN CEBs
    GILT:        Hybrid-Docks sind AUSGENOMMEN -- jede beliebige Anzahl BIS 32

**Vollzug der Streichung (ÜBERHOLT-Marker, nichts gelöscht):** KON24-01/§2c (F11-Entstehung) ·
KON24-02 V-9 · KON28-03 (letzter offener F11-Teil) · KON29-06 R-4 · WF3-Synthese §5.4 · das
Gesamturteil §2c/§5. **F11 ist damit vollständig geschlossen** (Zahl: dynamisch, max 32 —
KON28-03; Invariante: gestrichen).

*Und die „Erinnerung erhalten"-Bestätigung des Owners zur `ghp_`-Rotation ist verbucht.*
