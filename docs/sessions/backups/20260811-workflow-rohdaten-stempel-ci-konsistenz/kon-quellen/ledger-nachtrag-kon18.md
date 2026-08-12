## NACHTRAG 12.08.2026 — KON18: DAS BAU-MODUL IST EINE C++23-PLANER-BIBLIOTHEK + DIE VERGESSENEN FRAGEN

### KON18-01 — 🔴 KERN: KEINE SKRIPTE. DAS BAU-MODUL IST EINE PLANER-BIBLIOTHEK IN C++23.

**Owner verbatim 12.08.2026:**

> *„Wir vermeiden immer noch **skripte außer C++ und cmake** und **gießen alles in binary**. Daher
> ist zum Beispiel das **Baumodul eine Planer Bibliothek in C++23**."*

Das präzisiert KON16-03/KON17-01 um die **Bauform**:

    Das zentrale Bau-Modul (Builder Pattern, emittiert je Traeger-Stufe die naechste)
    ist KEIN Skript, KEIN YAML-Generator, KEIN Shell-Werkzeug --
    es ist eine PLANER-BIBLIOTHEK IN C++23, in Binary gegossen.
    Erlaubte Nicht-C++-Traeger: NUR CMake.

Damit gilt die Architektur-Invariante **I24** (nur C++23+, CMake-gebaut, keine Skripte) ausdrücklich
auch für die Träger-Baukette — und **#89 (14 Shell-Testproben, 8528 Zeilen) wächst weiter gegen
diese Doktrin**.

---

### KON18-02 — DIE VERGESSENEN ENTSCHEIDE — Owner-Frage: *„Welche Entscheidungen und Fragen hatte ich vergessen?"*

Abgleich der Owner-Vorlage (O-1…O-14) und des Ledgers gegen KON15/KON16/KON17. **Beantwortet oder
gegenstandslos:** O-1 (festgelegt, Explore läuft) · O-2 (nie eine Frage) · O-3 (Seiten, KON16-02) ·
O-6/O-7/O-8 (**gegenstandslos** — keine YAML, KON16-03) · O-9 (KON13-04/KON15-05) · O-10 (KON17-01)
· O-11 (KON17-02) · Fragen 10–14 der Übergabe (KON16/KON17).

**OFFEN sind zehn — sechs Owner-Vorlage-Punkte und vier aus dem Ledger:**

    O-4    Meta-Meta-Achsen von System und Organ: der INHALT
           (Organ-Liste heute LEER, System traegt genau eine Familie: SIMD;
            bestimmt die Granularitaet der Freigabe -> ohne sie ist S-3 nicht schneidbar)
    O-5    K2: welcher LOADER-SCHICHT ist der Hybrid zugeordnet?
           K5: wie werden SNAPSHOTS AGGREGIERT, wenn ein Hybrid mehrere
               Tier-Binaries haelt? (ausdruecklich unentschieden; K1 ist teilbeantwortet)
    O-12   Fork E -- XML-KANAL-KONVERGENZ: konvergiert der Planer auf EINE
           XML-Interpreter-Quelle (Experiment- vs. Thesis-Profil)?
           DURCH KON17-04 DRINGLICHER GEWORDEN: "Wir beginnen bei der XML" --
           WELCHE XML ist der Startpunkt der Kette?  (blockiert S-8)
    O-13   Fork B -- --dump-plan als DRITTER PlanTextBuilder oder Director-Methode?
           (klein, blockiert S-8)
    O-14   Fork R1 -- REGISTRY-SINGLE-SOURCE: Code=Wahrheit+Generator-Ausbau
           oder Registry=Hand-Wahrheit?  (blockiert Registry-Arbeit S-2/S-9)
    T-15a  Granularitaet von "GANZER LAUF neu": Zelle | 4096er-Batch |
           Kampagnentag | gesamte Kampagne?  (Bauteil klein, sobald entschieden;
           Wiederaufsetzpunkt existiert)
    T-15b  Lesart der "bis zu 5 WIEDERHOLUNGEN": dieselbe Achse wie max_reruns
           (Drift-Instabilitaet der Gruppe) ODER eine dritte, ungebaute Achse
           (Retry einer GESCHEITERTEN Messung)?  (aus dem Korpus nicht entscheidbar)
    HYB    24 oder 48 Hybrid-Rekombinationen: ist MIT/OHNE Fuehler eine EIGENE
           Ebene (4!->24 vs 48)? Die ZAHL rechnet kuenftig die Planungs-Simulation
           (KON17-01) -- die STRUKTUR-Frage (Fuehler als Ebene ja/nein) bleibt Owner.
    OD-7   setzt 24 Kerne -- prod1 hat 16 Kerne / 32 Threads. Welche Zahl gilt
           fuer die Kapazitaetsrechnung?
    STUFE  Zielbegriff der angeordneten Umbenennung (KON16-09): gewinnt "Phase",
           "Stufe" oder ein dritter Begriff? (Die Trefferliste nach Haerteklassen
           erhebt WF1-G; die BEGRIFFS-Wahl ist Owner.)

**Meine Bringschulden daneben (keine Owner-Fragen):** G-1-Grammatik-Entwurf (nach WF1-A) · die
drei laufenden Explores (WF1 neun Stränge · WF2 zwei Welten + leere Klassen · der
5-Kontexte-Explore) · das Register der leeren Klassen.
