## NACHTRAG 12.08.2026 — KON41: VIER ANTWORTEN — DIE GENERALPROBEN-DOKTRIN, DIE DOCK-PERMUTATIONS-ENTWIRRUNG („VÖLLIG FALSCH"), UND DER HYBRID-STEMPEL IST SPEZIFIZIERT

**Der Owner hat OF-5, OF-1, OF-2 und OF-3 beantwortet — OF-2 mit einer scharfen Korrektur an
einer Gleichsetzung, die seit KON28-03 als „Beobachtung" kursierte. Dazu die Betriebsregel:
ab jetzt nur noch Rückfragen, die ein Explore NICHT auflösen kann. Zitate wörtlich.**

---

### KON41-01 — 🔴 OF-5 BEANTWORTET: „BEIDES" — DIE GENERALPROBEN-DOKTRIN

**Owner verbatim 12.08.2026:**

> *„**Beides**, weil wir **immer bis 3 Tage vor Abgabe Generalprobe laufen**, dann die **Builds
> und Messdaten manuell löschen, da ungenau** und dann den **finalen Lauf bis zur Abgabe
> durchfahren**. **Generalprobe wird formal durch das --debug Flag aktiviert.** Das bedeutet der
> **volle Lauf wie von dir beschrieben wird in jeder der beiden Fälle IMMER voll gefahren**.
> Das **Lager fährt skip sobald es voll ist** und wir **verwenden es sowohl während der
> Generalprobe wieder, als auch später bei echten Läufen nach dem manuellen reset**. Wir müssen
> **bei Erfolg jeweils die Binaries und die Messungen nur einmal bauen und durchmessen, danach
> hält das Lager sie verfügbar** und wir können **neue features testen und schnell einbauen**.
> Wir **fahren hauptsächlich die Kette auf der CI. Ziehen sie aber auf lokal nach, sobald CI
> läuft**. Bitte **analysiere das Problem damit eigenständig** und fahre **wie empfohlen mit
> meinen Hinweisen** fort."*

    DIE GENERALPROBEN-DOKTRIN (loest die F-D-Spannung als "BEIDES" auf):
      DAUERZUSTAND bis T-3:   GENERALPROBE -- der VOLLE Lauf (XML->PDF) faehrt IMMER
                              komplett; --debug ist der FORMALE Schalter des Modus.
                              Das Lager macht Wiederholungen billig (Skip sobald voll):
                              einmal gebaut+gemessen => verfuegbar => neue Features
                              schnell testbar.
      T-3 (~Sa 12.09.):       MANUELLER RESET -- Builds UND Messdaten der Generalprobe
                              werden GELOESCHT (da ungenau; die praezisierte
                              KON29-01-Ausnahme: nicht nur Messdaten, auch die Builds).
      T-3 bis ABGABE:         DER FINALE LAUF, voll durchgefahren -- baut und misst
                              EINMAL echt (1 Thread), danach haelt das Lager; die
                              Kette regeneriert bis zur PDF.
      KANAL:                  hauptsaechlich CI; LOKAL wird NACHGEZOGEN, sobald die
                              CI laeuft (Dual-Weg-Richtung: CI zuerst).

**⇒ Die verbuchte Lesart (a) aus KON40-03 gilt, ERWEITERT:** W3 ist nicht die einzige
Generalprobe — der volle Lauf fährt **dauernd** als Generalprobe; W3 ist seine größte Ausbau-
Stufe. Die Posten 45/46 der Strecke bleiben, präzisiert.

**Die eigenständige Analyse (Owner-Auftrag), erste Rechnung:**

    DAS T-3-FENSTER MUSS DEN VOLLEN FINALEN LAUF TRAGEN -- NACH dem Reset heisst das:
      NEUBAU der Binaries    heutige Kennzahl 128 x 19,4 min ~ 41,4 h einlanig
                             (~1,7 Tage; zweilanig weniger, CEB-Bauten RAM-sequentiell;
                             REALE Zahl erst aus S-19)
      + ECHTE MESSUNG        1 Thread deterministisch -- der ALTE Deckel (ETA <= 4,5
                             Maschinentage, OV-4) PASST NICHT in 3 Tage
      + AUSWERTUNG + PDF     automatisch (die Generalprobe hat es zigfach bewiesen)
    => 🔴 DER OV-4-MESS-DECKEL WIRD VOM T-3-FENSTER HER KALIBRIERT:
       Mess-Budget ~ 3 Tage - Bau - PDF-Puffer => die gedeckelte Teilmatrix muss
       (Bau + 1-Thread-Messung) in ~<=2,5 Maschinentagen tragen, zweilanig gerechnet.
       Die FINALE Kalibrierung braucht die S-19-Zahlen (Bau-Menge + Mess-ETA je Zelle).
       NEUER Strecken-Posten: "OV-4-Deckel = f(T-3-Fenster)" -- in W2 mit den
       S-19-Zahlen rechnen, VOR der GO-Vorlage ##51.
    KONSEQUENZ-POSTEN (bestaetigt): XML->PDF-VOLLAUTOMATIK + LAGER-SKIP-BEWEIS sind
    die tragenden W2/W3-Posten; der manuelle Reset ist ein eigener, dokumentierter
    T-3-Schritt (Loeschung NUR auf ausdrueckliches GO zum Zeitpunkt -- Messdaten-
    Doktrin-Ausnahme, jetzt inkl. Builds).

---

### KON41-02 — OF-1 BESTÄTIGT: „Ja korrekt."

**KON34-06(d) ist GESCHLOSSEN:** System B = **17 Code-Dateien** (6 `mess/` + 3
`builder/measure_storage/` + 8 Referenzierer) **+ `hybrid/README.md`** (Doku) **= 18** — beide
kursierenden Zahlen maßen dieselbe Menge. B4-Umfang: 9 Kern-Dateien Umbau, 8 Ripple.

---

### KON41-03 — 🔴 OF-2 „VÖLLIG FALSCH": PRÜFDOCKS ≠ PERMUTATIONEN — DIE GLEICHSETZUNG FÄLLT

**Owner verbatim:**

> *„Die **Prüfdocks des Hybrid SIND NICHT die Permutationen der Träger Stufen**, auch wenn
> **beide mit 32 geschätzt** waren, ist es **unmöglich ohne den Planer und
> Simulations-Kalkulation die Größe der Permutations-Schichten zu bestimmen**. Das sind **zwei
> verschiedene Dinge. VÖLLIG FALSCH.** Bitte löse das auf und stelle die Frage nochmal."*

    DIE ENTWIRRUNG -- DREI GROESSEN, die der Bestand vermengt hat:
      (1) MESS-BELEGUNGEN     2^5 = 32 -- die SCHALTER-Kombinatorik (KON25-03).
                              32 ist deren strukturelles MAXIMUM.
      (2) HYBRID-PRUEFDOCKS   dynamisch nach Planer/XML, MAXIMAL 32 (KON28-03) --
                              eine EIGENE Groesse (wie viele Docks der Hybrid fuehrt).
                              Dass beide "32" heissen, war ZUFALL DER SCHAETZUNG.
      (3) PERMUTATIONS-SCHICHTEN der Traeger-Stufen -- ihre GROESSE ist OHNE
                              Planer + Simulations-Kalkulation (S-19) NICHT bestimmbar.
    WIDERLEGT ist damit:
      - die KON28-03-"Beobachtung" ("32 Docks maximal = 32 Mess-System-Permutationen --
        ob das dieselbe Groesse ist, klaert E-F3b") -> Antwort: NEIN, nicht dieselbe.
      - die KON34-03-Klammer "=> maximal 32 Docks (je geforderter Belegung eines)" --
        die Dock-Zahl folgt NICHT aus der Belegungs-Kombinatorik.
      - die OF-2-Formulierung in Teil C des Plan-Dokuments (Marker gesetzt).
    WAS STEHT (unberuehrt): der Mess-NENNER 32 als Belegungs-Maximum (KON25-03,
    Owner-Selbstkorrektur) · Docks <= 32 dynamisch (KON28-03) · Anordnung = statische
    Freigabe (KON37-03). NUR die GLEICHSETZUNG faellt.

**Die entwirrte Neu-Frage (OF-2-neu) ist gestellt** — sie fragt nur noch die Belegungs-Seite
(per Explore nicht auflösbar, Festlegungs-Charakter); Wortlaut in der Chat-Vorlage.

---

### KON41-04 — 🔴 OF-3 BEANTWORTET: DER HYBRID-STEMPEL — ERBT TIER, PLUS DIE KOMPOSIT-MAP-ZEILE

**Owner verbatim:**

> *„Der Stempel verwendet die **volle Syntax der Organ-Achse** und klammert eine **serialisierte
> compile time map bestehend aus Synthese-Funktion-String-Keys und
> Tier-Binary-am-Prüfdock-Stempel values, konkateniert für alle belegten Prüfdocks, als ein
> großer Stempel string unter seinen eigenen Tier-Binary Stempelzeilen**, hat also **noch eine
> Zeile mehr als Tier-Binary**. Der **SHA jedes Stempels kommt zum Schluss als letzte Zeile im
> Hybrid**, die **Komposit-Stempel-Serialisierungs-Kette als vorletzte Zeile** und der **Hybrid
> SHA wirkt auch über diese neue Zeile compile time**. **Hybrid erbt also das Stempelverhalten
> von Tier-Binary und fügt die besagte Zeile an der Stelle ein.** Bitte **dennoch prüfen**."*

    DER HYBRID-STEMPEL (Flaeche 2), SPEZIFIZIERT:
      Zeilen 1..n    wie TIER-BINARY (eigene M/S/O-Zeilen, volle Organ-Achsen-Syntax)
                     -- der Hybrid ERBT das Tier-Stempelverhalten
      VORLETZTE      🔴 NEU: die KOMPOSIT-STEMPEL-SERIALISIERUNGS-KETTE --
                     eine SERIALISIERTE COMPILE-TIME-MAP
                       { Synthese-Funktion-String-Key -> Tier-Binary-am-Pruefdock-Stempel }
                     konkateniert ueber ALLE BELEGTEN Pruefdocks, EIN grosser String
      LETZTE         der SHA des Stempels -- und der Hybrid-SHA WIRKT AUCH UEBER DIE
                     NEUE ZEILE compile time
    => LAGER-IDENTITAET vollstaendig: Pfad-Glieder aus den eigenen Zeilen, Blatt-SHA
       schliesst die DOCK-BELEGUNG ein -- andere Tier-Bestueckung => anderer Hybrid-SHA
       => Neubau/neuer Lager-Datensatz. Die "Bereichs-Karte" (KON7-05) IST diese Map.

**Prüf-Auftrag („dennoch prüfen") läuft als Explore** — insbesondere die Spannung zu KON7-04:
dort war `angeschlossene()` als **Laufzeit-Sammler** über die Dock-Registrierung geführt; die
heutige Spezifikation sagt **compile-time-Map** (konsistent mit KON21-01: Synthese-Funktionen
compile-time eingespeist) — welche Rolle behält der Laufzeit-Anteil (Anteile 2+3 aus KON9-02)?

---

### KON41-05 — BETRIEBSREGEL + VOLLZUG

**Owner:** *„Bitte stelle jetzt noch nicht autonom durch explore auflösbare Rückfragen"* —
⇒ nur noch Fragen mit Festlegungs-Charakter gehen an den Owner; alles andere per Explore.
**Vollzug:** OF-4 (Festplatten-IO) wird NICHT neu gestellt, sondern als Bestands-Explore
gefahren · OF-3-Prüfung läuft (Stempel-Thema ⇒ **Fable 5 max in allen Teilen, KON38**) ·
E-WARMUP (#27) läuft mit · OF-2-neu ist die einzige offene Owner-Frage · v3.5-GO wartet.
