## NACHTRAG 11.08.2026 NACHTS — KON16: VIERZEHN OWNER-ANTWORTEN AUF DIE VORGELEGTEN FRAGEN

**Der Owner hat die vierzehn Fragen aus der Kontextübergabe beantwortet. Drei Antworten sind
Explore-Aufträge, drei bitten um mehr Kontext, drei enthalten NEUE Architektur-Aussagen, und
eine blieb offen. Alle Zitate sind wörtlich; Kürzungen tragen `[…]` (KON15-03).**

---

### KON16-01 — FRAGE 1: DIE FLAG-SEMANTIK IST FESTGELEGT. `c` = CPU.

> *„Doch die ist festgelegt und in der vollen Syntax steht **c für CPU** (etwa in **cp** oder
> **ce**). Bitte explore."*

Meine Frage war falsch gestellt: ich hatte die Semantik als **offen** geführt. Sie ist **festgelegt**
— ich kenne sie nur nicht.

    'c'  = CPU
    volle Syntax ist MEHRSTELLIG -- der Owner nennt 'cp' und 'ce' als Beispiele
    -> die 97x '1.0.0.c' im Bestand sind die CPU-Auspraegung, nicht ein Platzhalter

⇒ **Explore-Auftrag:** die vollständige Grammatik der Kürzel finden. Was bedeuten `cp` und `ce`?
Welche weiteren gibt es (gpu/fpga/npu/avx)? Wie werden sie kombiniert?
**Fallstrick:** `ce` ist zugleich die Abkürzung für `cache_engine` — die Bedeutungen sind zu
trennen.

---

### KON16-02 — FRAGE 2: 🔴 ES HÄNGT VON DER SEITE AB. ZWEI SEITEN, ZWEI RICHTUNGEN.

> *„Das kommt darauf an, ob das Flag auf der **freigebenden Seite** oder der **compile time
> Seite** steht (explore). Im Falle der **Freigabe impliziert** es das Vorhandensein und im Falle
> der **compile Seite Fordert** das Flag das Vorhandensein von Hardware **ein**. Im Falle von
> **DREIPHASIG** fordert die **Messachse der CEB** außerdem die **Einhaltung des Vertrages mit den
> Messfühlern** der Tier-Binary bzw. Hybrid."*

Meine Frage war ein Entweder-oder. Die Antwort ist **beides, je nach Seite**:

    FREIGEBENDE Seite   ->  das Flag IMPLIZIERT das Vorhandensein
    COMPILE-TIME Seite  ->  das Flag FORDERT das Vorhandensein von Hardware EIN
    DREIPHASIG          ->  ZUSAETZLICH: die Mess-Achse der CEB fordert die Einhaltung des
                            VERTRAGES mit den MESSFUEHLERN der Tier-Binary bzw. des Hybrid

**Damit ist S-3 kein Entweder-oder mehr, sondern beides an verschiedenen Orten** — eine Wache auf
der Compile-Seite, eine Implikation auf der Freigabe-Seite. Und der Messfühler-Vertrag ist ein
**dritter** Gegenstand, der bisher in keiner Bau-Position steht.

⇒ **Explore-Auftrag:** wo verläuft die Grenze zwischen den beiden Seiten im Code? Welche der 123
Flag-Literale liegen auf welcher Seite? Existiert der Messfühler-Vertrag?

---

### KON16-03 — 🔴 FRAGE 3/4: ES GIBT KEINE YAML. DER PLANER EMITTIERT DIREKT.

> *„Es gibt **keine YAML** sondern der Planer **emittiert direkt eine pipe oder Prozess**, der den
> build auf einer binary fährt. **Jede Träger Stufe emittiert die nächste direkt** und unter
> Verwendung eines **zentralen Bau-Modules**, welches **wiederverwendbar im Builder Pattern** den
> nächsten Träger aufbaut."*

**Das räumt die halbe CI-Fragenliste weg** — und zwar nicht, weil sie beantwortet wurde, sondern
weil sie **gegenstandslos** ist. Ich hatte gefragt: Child-Pipeline oder Job-Gruppe? Kind-YAML
statisch oder emittiert? Beides setzt GitLab-YAML als Träger voraus. **Der Träger ist ein
C++-Prozess.**

    Planer --emittiert--> CEB --emittiert--> Tier --dann--> Hybrid
             (Pipe/Prozess, KEINE YAML)
             ueber EIN zentrales, wiederverwendbares Bau-Modul im Builder Pattern

**Das ist die Selbstkompilation aus KON10** — der Entwurf vom 19.07. (Director/Builder +
AxisCommand). Der Owner beschreibt hier nicht etwas Neues, sondern **dasselbe von der
Emissions-Seite her**.

**🔴 Offener Widerspruch zu prüfen:** der Entwurf vom 19.07. nennt einen `CiYamlBuilder`. Wenn es
keine YAML gibt — was ist dieser Builder dann? Entweder ist er überholt (neueres Owner-Wort
schlägt älteren Entwurf) oder er baut etwas anderes als die Träger-Pipeline. **Am Gegenstand zu
klären, nicht am Namen.**

---

### KON16-04 — FRAGE 5: DAS NESTING-BUDGET IST KEIN PROBLEM. TIEFE 3.

> *„Der Hybrid wird durch die **CEB** gebaut und das Budget wird **nicht ausgeschöpft** weil die
> **Tiefe nur 3** ist und **Hybrid und Tier sequentiell auf derselben Stufe** gebaut werden, erst
> **Tier** und später **Hybrid** durch die CEB."*

    Tiefe 1   Planer
    Tiefe 2   CEB
    Tiefe 3   Tier  -- dann, SEQUENTIELL auf DERSELBEN Stufe --  Hybrid

Mein Blocker „das GitLab-Nesting-Budget ist ausgeschöpft" war **an das YAML-Modell gebunden** und
fällt mit ihm. **Und die Sequenz bestätigt ORT ≠ ZEIT von der Bau-Seite:** Tier und Hybrid stehen
auf **derselben Stufe** (Ort), werden aber **nacheinander** gebaut (Zeit).

---

### KON16-05 — FRAGE 8: „ANGEFORDERT" HEISST: DIE GANZE KETTE LÄUFT.

> *„Die Gesamtkette war doch schon immer, dass wir eine **XML konfigurieren** und den **Planer
> starten**, um das Experiment durchzuführen und die Ergebnisse **wie geplant (explore)** an Ziele
> zu exportieren in Formaten wie **latex und PDF, Messwerte als xlsx und wo weiter (explore)**.
> **Angefordert heißt also: Wir starten super als Anwender der Cache engine über die XML und laufen
> die Gesamte Kette.**"*

Meine Frage — Positivliste je Nachweis oder Klassenregel mit Opt-in? — war eine **Erfindung**. Es
gibt keinen Anforderungs-Mechanismus je Artefakt. **super ist der Anwender**, die XML ist die
Konfiguration, und was exportiert wird, ist **das, was geplant war**.

⇒ **Explore-Auftrag, vom Owner zweimal markiert:** *was* war geplant? LaTeX, PDF, xlsx — und was
ist das „und so weiter"?

---

### KON16-06 — 🔴 FRAGE 9: DREI FLÄCHEN, NICHT ZWEI.

> *„Das ist Teil der **Systemachse** und geht **nur als Stempel** mit in **Fläche 2** des Genus
> Interfaces (was ja nach dem Compile durch die CEB mit dem compiler ein Tier-Binary oder Hybrid
> ergibt). Also der **Genus Wert in der CEB hat einen compiler** und **nach dem compile hat das
> Genus interface NUR den measurement Durchstich**. Das **kompilieren und bauen macht ja nur die
> CEB**. Das **Genus ist also Fläche 1** einer Tier-Binary und **Fläche 2 ist der Stempel**.
> **measurement Durchstich ist im prinzip gleichzusetzen mit Fläche 3**, damit wir die
> **Gattung+Genus Funktionsinterfaces nicht ändern müssen**."*

**Der Ledger führte bisher ZWEI Flächen je Binary. Es sind DREI.**

    FLAECHE 1   das GENUS-Interface einer Tier-Binary   (abstract factory, Laufzeit)
    FLAECHE 2   der STEMPEL                             (compile time factory, ABI-stabil)
                -> hier haengt Tools/Compiler dran, als Teil der SYSTEMACHSE
    FLAECHE 3   der MEASUREMENT-DURCHSTICH
                -> eingefuehrt, DAMIT die Gattung+Genus-Funktionsinterfaces
                   NICHT geaendert werden muessen

**Und der Compiler wandert über die Compile-Grenze:**

    VOR dem Compile:   der Genus-Wert IN DER CEB hat einen Compiler
    NACH dem Compile:  das Genus-Interface hat NUR NOCH den measurement-Durchstich

**Damit ist meine Frage nach einem dritten Genus-Wert `{binary, measurement, tools}` beantwortet:
nein.** Tools/Compiler sind **kein eigener Genus-Wert**, sondern **Teil der Systemachse**, und sie
erreichen die Binary **nur als Stempel** über Fläche 2.

**Fläche 3 ist ein Kunstgriff mit einem klar benannten Zweck:** die Gattung+Genus-Interfaces
bleiben unverändert. Das ist eine **Nicht-Änderungs-Zusage**, die jeder künftige Bau einhalten muss.

---

### KON16-07 — FRAGE 11: DER LEERE EINHÄNGEPUNKT IST GEWOLLT.

> *„Ja wir nutzen es **jetzt aktiv**, genau das ist der Plan."*

⇒ „Einhängepunkt aktiv, Inhalt leer" zählt als **aktiv genutzt**. Die C-1-Bilanz steht damit auf
**6 von 11**, nicht 5.

---

### KON16-08 — FRAGE 13: GN-8-REST HAT PRIORITÄT **HOCH**.

> *„hoch."*

Der Ledger führte die Priorität an zwei Stellen widersprüchlich („niedrig" / „hoch"). **Hoch gilt.**
Die „niedrig"-Stelle ist beim nächsten Durchgang zu korrigieren.

---

### KON16-09 — 🔴 FRAGE 14: STUFE = PHASE. UMBENENNUNG IST ANGEORDNET.

> *„Ja genau ein Synonym, **aber muss jetzt konsistent wegen Kollision umbenannt werden**."*

Bestätigt: die 06.08.-Vokabel **„Stufe"** und die seit KON7 verwendete **„phasig/Phase"** meinen
dasselbe. Die Kollision ist real, und der Owner ordnet die **konsistente Umbenennung** an.

🔴 **Das ist kein Doku-Auftrag allein.** Betroffen sind potenziell **Symbolnamen im Code,
XSD-Elemente, CI-Job-Namen und Fingerprint-Felder** — eine Umbenennung dort ist **ABI- und
preimage-wirksam**. Vor jedem Eingriff ist die Trefferliste nach Härteklassen zu sortieren.
Die Umbenennung selbst ist **heute kostenlos** (es wurde nie eine Flotte gebaut) und **ab
Mi 26.08. teuer**.

---

### KON16-10 — WAS OFFEN BLIEB

    FRAGE  6   je Traeger-TYP oder je INSTANZ           -> "Ich brauche mehr Kontext."
    FRAGE  7   was heisst "eigene Beduerfnisse"         -> "Ich brauche nochmal mehr Kontext."
    FRAGE 12   C-4: Wache erweitern oder zweite bauen   -> "Ich brauche mehr Kontext."
    FRAGE 10   S-13 post-Abgabe oder vorgezogen         -> NICHT BEANTWORTET

**Frage 6 und 7 mussten NEU GESTELLT werden**, weil ihre alte Fassung an das YAML-Modell gebunden
war, das mit KON16-03 entfallen ist:

* **6 neu:** Baut das zentrale Bau-Modul **eine Bau-Vorschrift je Träger-Typ** (vier, jede N-mal
  parametrisiert gefahren) oder **je Instanz eine eigene**?
* **7 neu:** Welche Schritte **emittiert** eine Träger-Stufe für die nächste — nur Compile+Link,
  oder auch Test, Lint, Mess-Lauf, Release, Cache-Ablage? Gleich für alle vier, oder
  trägerspezifisch?
  ⚠️ **Wenn das Bau-Modul die Pflicht-Reihenfolge J-1…J-4 nicht mitemittiert, baut es falsches
  Grün.**

Der Explore-Lauf `wf_eede2f12-7ed` (neun Stränge, 45 Agenten) holt die Entscheidungsgrundlagen
für 6, 7 und 12 — und fährt zugleich die drei Explore-Aufträge aus KON16-01, -02 und -05 sowie
die Objektprüfung der drei neuen Architektur-Aussagen (KON16-03, -06, -09).
