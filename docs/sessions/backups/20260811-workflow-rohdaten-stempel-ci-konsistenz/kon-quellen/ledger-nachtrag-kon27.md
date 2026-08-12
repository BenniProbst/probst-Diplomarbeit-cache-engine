## NACHTRAG 12.08.2026 — KON27: F6 UND F10 BEANTWORTET — DAS HOME-PRINZIP UND DAS EXPORT-ELEMENT

---

### KON27-01 — 🔴 F6 BEANTWORTET: JEDE ACHSEN-KATEGORIE BRAUCHT IHR EIGENES HOME — MIT GENAU EINEM WÄCHTER

**Owner verbatim 12.08.2026:**

> *„Das Grundproblem der Deckung ist immer noch das **Aufräumproblem**, weil eigentlich **jede
> Achsen-Kategorie ihr eigenes home braucht, für das unter der Stempel-Mechanik genau ein Wächter
> greift**. Daher gilt nach Untergliederung **130 und 152 je nach Achsen-Kategorie**, was nach
> **DREIPHASIG und ZWEIPHASIG Syntax überprüft** werden muss. Die **Organ-Achsen sind derzeit
> axes** und es **braucht noch die Kategorien für Mess/System**. Sofern die **Varianten sich
> unterscheiden, sind sie auch unterschiedliche Versionen der Achsen-Interfaces** und wenn sich
> **deren Algorithmen auch unterscheiden, dann müssen auch diese unterschiedlich versioniert**
> werden (siehe Stempel Achsen interface und Algorithmus Versionierungssystem). **Wir beginnen
> aber zuerst mit einer gültigen golden Version.** Ansonsten brauchen wir das für
> **Mess/System/Organ gleichermaßen gegliedert**."*

**Die 130-vs-152-Frage war falsch dimensioniert — die Antwort ist ein Struktur-Prinzip:**

    DAS HOME-PRINZIP:
      je Achsen-Kategorie EIN Verzeichnis-Home  +  EIN Waechter (Stempel-Mechanik)
        ORGAN   home = axes/   (existiert)          Waechter prueft nach ZWEIPHASIG-Syntax
        SYSTEM  home = FEHLT (anzulegen)            Waechter prueft nach ZWEIPHASIG-Syntax
        MESS    home = FEHLT (anzulegen)            Waechter prueft nach DREIPHASIG-Syntax
      => "130 und 152" gilt JE NACH KATEGORIE nach Untergliederung -- die Zahlen werden
         nach dem Aufraeumen neu geschnitten, nicht vorher entschieden.

    DAS ZWEISTUFIGE VERSIONIERUNGSSYSTEM (Stempel):
      Varianten unterscheiden sich     => verschiedene ACHSEN-INTERFACE-Versionen
      deren Algorithmen unterscheiden  => verschiedene ALGORITHMUS-Versionen
      (Interface-Version und Algorithmus-Version sind ZWEI Ebenen des Stempels)

    DIE REIHENFOLGE:
      1. ZUERST eine GUELTIGE GOLDEN VERSION
      2. dann die Gliederung fuer MESS/SYSTEM/ORGAN GLEICHERMASSEN

**Konsequenzen für den Bau:**
* **S-18 (Achsen-Interface-Trennung) ist damit vollständig definiert:** drei Kategorie-Homes ·
  je Home ein Wächter · zweistufige Versionierung (Interface + Algorithmus) · Prüf-Syntax je
  Phasigkeit. Der C-4-Detail-Klassen-Split (KON17-03) bekommt seine Schnittlinie: **eine
  Detail-Klasse je Kategorie-Home.**
* **Der queuing-Befund ordnet sich ein:** `queuing_q1/q2` sind Organ-Achsen (Stempel-Zeile,
  binary_id) — sie gehören unter das **Organ-Home** (heute liegen ihre 22 Varianten unter
  `topics/queuing/`, außerhalb von `axes/`). Das ist exakt das benannte **Aufräumproblem**.
* **golden zuerst:** vor jeder Umgliederung wird eine **gültige golden Version** festgeschrieben
  — der Umbau misst sich an ihr (deckt sich mit der Additiv-Doktrin und „erst laute
  Compile-Fehler, dann verschieben").

---

### KON27-02 — F10 BEANTWORTET: OPTION (b) — DAS EXPORT-ELEMENT JE FORMAT, MIT LAZY-PDF-BLOCK

**Owner verbatim:**

> *„**Option b**. Das Element beschreibt **konkret je ausgegebenes Format wohin das soll** und
> **bei Latex was genau ausgegeben werden soll**. Der **Block für PDF referenziert im xml lazy
> die Latex-Konstruktion** und **exportiert sie an ein bestimmtes Ziel unter hinzunahme der
> übrigen Kapitel und Beschreibungen neben dem generierten Anhang**."*

    DAS S-13-EXPORT-ELEMENT (XSD-Design-Auftrag):
      je FORMAT ein Eintrag:   FORMAT -> ZIEL        (wohin)
      bei LATEX zusaetzlich:   WAS genau ausgegeben wird (Inhalts-Auswahl)
      der PDF-BLOCK:           referenziert LAZY die LaTeX-Konstruktion
                               exportiert an ein bestimmtes ZIEL
                               MIT den uebrigen Kapiteln und Beschreibungen
                               NEBEN dem generierten Anhang
    => Das PDF ist die Komposition: Thesis-Kapitel + generierter Anhang, lazy ueber
       die LaTeX-Konstruktion, Ziel einstellbar (Ziel 3 cache-engine-experiment).

⇒ **S-13 bekommt ein neues XSD-Element** (Design-Vorschlag von mir, gegen die vier
Rückschrieb-Methoden Csv/LatexTable/ComparisonMetrics/Xlsx und den bestehenden inerten
`<storage>`-Slot). Die Einzelnachweis-Frage ist damit beantwortet: **explizit, je Format,
mit Ziel** — keine implizite Pfad-Semantik.

---

### KON27-03 — DIE ÜBRIGEN AUFTRÄGE DIESER RUNDE

    (1) BESITZERLOSE AUFGABEN -> Wellen + Task-Planung   (KON27-04 unten)
    (2) ROHDATEN-NACHSICHERUNG aller ungesicherten Workflows der letzten Tage
    (3) LEDGER-KONSOLIDIERUNG: die KON-Quelldateien liegen unter tmp und sind
        fluechtig -> loeschsicher in den Backup-Ordner; der SESSION-LOG mit allen
        Owner-Antworten wird loeschsicher gesichert (ausserhalb des Trackings --
        Transkripte enthalten Live-Tokens und werden NIE committet; die
        Token-redigierten Owner-Extrakte gehen zusaetzlich ins Repo-Backup)

---

### KON27-04 — 🔴 DIE BESITZERLOSEN AUFGABEN, JETZT WELLEN-ZUGEORDNET (in veranschlagter Priorität)

| Prio | Aufgabe | Welle | Task |
|---|---|---|---|
| 1 | **`##25` DURCHSTICH** — die F1-Lieferung selbst | **W0b, SOFORT** (F1 = Fr 14.08.) | #11 |
| 2 | **ce-Pipeline rot** (#84 Vorbestands-Rot + #80 coverage-guard) | **W0b, vor jeder ce-Landung** | neu #14 |
| 3 | **MinIO-Keys** neu einsetzen + 776 Runner-Token + prod2-`test:secrets` | **W0b/Betrieb, sofort** (System sonst nicht testbar) | #10 |
| 4 | **S-6-Fenster** (S-6a Umstellung + S-6b Sperre + S-6c Wache + harte Umbenennungs-Stellen) — davor Layout-Bump-Konflikt lösen | **W1, vor F2** (preimage-wirksam, heute kostenlos) | neu #15 |
| 5 | **golden Version festschreiben → Kategorie-Homes Mess/System anlegen → je Home EIN Wächter** (= S-18 nach KON27-01; enthält den queuing-Umzug ins Organ-Home) | **W1, vor F2** (KON16-08: hoch; WF3 Z. 34976: Build-Blocker) | neu #16 |
| 6 | **T-15b-Umzug** (Prüfdock-Retry + 8-Punkte-Ripple, Arena-Formel) | **W1** (vor der Kampagne W3) | #13 |
| 7 | **S-19 Planungs-Simulation** finden + bauen (liefert die Bau-Zahlen; Mess-Faktor 32) | **WE 22./23. + W2, vor dem Trigger Mi 26.08.** | #7 |
| 8 | **G-2-Semantik-Nachzug** (Achsen-Nummerierungs-Reihenfolge) | **W1/W2, nach S-18-Homes** | neu #17 |
| 9 | **S-13 Export-Element** (F10-Design, Option b) + Drei-Ziele-Struktur | **W2** (mit S-17 Lager-Verdrahtung) | neu #18 |
| 10 | **main-FF beider Repos** (mit kumulativer Hygiene-Wache) | **nach Paket-Abschluss W0b** | neu #19 |
| 11 | **Fläche-3-Vereinigung** (IMessVisitor ≡ measurement-Durchstich, KON25-02) + Deckungslücke CEB=AUS/Tier=AN | **W1/W2** | neu #20 |
| 12 | **P/E-Core-Cluster** (E17: „deep research Pflicht", nie eingelöst) | **W7** (kein F2-Bezug) — sofern kein Owner-Einspruch | neu #21 |
| 13 | **`mess/`-Subsystem** S-Position (S-9/S-10 naheliegend) | **Zuordnungs-Klärung in W1-Planung** | — (in #16-Beschreibung) |
| 14 | **3 Skelett-Testverzeichnisse** (Eigentümer fehlt seit 06.07.) | **W7** oder deprecaten — Owner-Wahl unkritisch | — |
| 15 | **E-1…E-4-Vollzugsprüfung** + A-1-Vorlagetext nachlesen | **W0b/Betrieb** (Prüfposten, kein Bau) | neu #22 |

**Nicht zugeordnet (warten auf Owner):** F11 Prüfdock-Zählung · OD-7 Worker-Deckel 24/16 ·
E-C-Substanz-Bestätigung · F3b-Ergebnis (WF5 läuft) · Dock-Obergrenze 32 vs. 8.

---

### KON27-05 — E-C FREIGEGEBEN: DIE PLAN-TEXT-SUBSTANZ BLEIBT

**Owner verbatim 12.08.2026:** *„E-C: **Freigabe wie von dir vorgeschlagen**."*

⇒ **Die Substanz bleibt** (Empfehlung angenommen): `PlanTextBuilder` + `plan dump` + der hart
gegatete CI-Job `visibility:tier-binaries` + `parse_plan_dump()` sind bestätigter Bestand.
**O-13 ist vollständig geschlossen:** das Flag-Wort `--dump-plan` ist ÜBERHOLT (seit 05.08.
vollzogen tot), die dahinterliegende Funktionalität ist owner-bestätigt. Herkunftsvermerk
(16.07. Opus-Subagent / 19.07. Fork B agentisch) bleibt als Historie im Ledger (KON26-03).
