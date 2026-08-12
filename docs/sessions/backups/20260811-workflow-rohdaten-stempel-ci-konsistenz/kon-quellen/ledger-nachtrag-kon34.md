## NACHTRAG 12.08.2026 — KON34: DIE R-1-KARTIERUNG — ZWEI MESS-ARCHITEKTUREN, UND DIE 6 VERLIERT IHREN GEGENSTAND

**Der Owner-Verständnis-Auftrag aus KON30-01 ist erfüllt:** *„verstehe die Messeinrichtungen in
jeder Träger-Stufe […] wo was hingehört und ein oder aus geschalten werden kann bezüglich der
Messachsen."* — **Und er wird klar, genau wie angekündigt.** Volltext:
`docs/sessions/20260812-WF6-SYNTHESE-r1-messeinrichtungs-kartierung.md`.

⚠️ **Deckungsgrenze, ausdrücklich:** Schnitt 2 (SOLL-Zuordnung + fachliche Bedeutung der
6er-Ordnung) **starb am StructuredOutput-Limit** und lag der Synthese **nicht** vor. Sie stützt
sich auf Schnitt 1 (objektverifiziert, 4 Gegenproben) plus eigene Nachmessung. Der Kernbefund ist
damit belegt, die **fachliche Herleitung der 6** kommt aus dem Code selbst, nicht aus einer
Plan-Quelle.

---

### KON34-01 — 🔴 DER KERNBEFUND: ZWEI EINANDER UNBEKANNTE MESS-ARCHITEKTUREN

    SYSTEM A -- LIVE:      #ifdef-Gates in anatomy/abi_adapter.hpp, gespeist ueber
                           mess_achsen_naht.hpp. Das ist, was heute misst.
    SYSTEM B -- DORMANT:   mess::Konfiguration<Is...> + CheckpointMeasure + SteuerDock
                           (17 Dateien) -- 0 PRODUKTIONS-AUFRUFER. abi_adapter.hpp und
                           observable_tier.hpp includieren NICHTS aus mess/ oder
                           measure_storage/ (grep exit 1). Nur zwei Test-/Naht-Dateien
                           rufen es.
    => Die 6er-Maschinerie (static_assert anzahl == 6) lebt in System B -- also in dem
       System, das den Mess-Pfad heute GAR NICHT ERREICHT.

---

### KON34-02 — DIE KARTE: MESSEINRICHTUNG × TRÄGER-STUFE × SCHALTER

| Einrichtung | IST-Träger | IST-Schalter | SOLL (KON25-03) | Zustand |
|---|---|---|---|---|
| **Wallclock/G1** | **Tier** (`abi_adapter.hpp:591-1138`, 30 Gates) | `COMDARE_MEASUREMENT_ON` aus CMake/Env `COMDARE_MEASUREMENT_COMBO`; **Pflicht-Wurf `:476-491`** — Wallclock ist heute **nie abwählbar** | **CEB**, an/aus | verdrahtet, **produktiv ungenutzt**: die CI setzt die Combo **nirgends** — *„wird BEWUSST NICHT gesetzt"* / *„leer == [all] == Vollmenge"* |
| **Macro/G2** | **Tier** (`:1432, :1441-1729`) | `COMDARE_CE_ENABLE_STATISTICS` — gesetzt, sobald Macro **oder** Micro gewählt | **Tier**, an/aus | **EIN geteiltes Gate für G2+G3**, im Code als *„EHRLICHE GRENZE"* benannt — **nicht einzeln schaltbar** |
| **Micro/G3** (18 Segment-Timer) | **Tier** (`:1796, :1799-2072`) | dasselbe Gate; `COMDARE_MEASUREMENT_TOOLING_MICRO=1` **existiert ohne Leser** | **Tier**, an/aus | Herauslösung ist ein **benanntes, unterminiertes Folgepaket** |
| **PMC** (Meta-Meta) | **CEB/Host** (`iterator:2574`), **nicht im Tier-Kompilat** — *„wird IN DER CEB UND DEREN FINGERPRINT VERBAUT"* | `COMDARE_ENABLE_PMC` + `COMDARE_PMC_VENDOR`, vom Planer laufzeitgemessen gesetzt | **CEB** (so schon) | in CI aktiv, **aber ohne Vendor** = Übergangszustand (WARNING); Tier-Fingerprint **pmc-frei** |
| **Hybrid Micro/Macro** | — nur **Platzhalter** (`naht:159-160`) | keiner | **Hybrid**, je an/aus | **GAR NICHT GEBAUT** |
| **System B** | keiner (0 Aufrufer) | reine Typwahl, kein XML/CMake | Träger der Auswahl | **DORMANT** — Owner-KERN 09.08.: muss gebaut werden |

**Die XML kann es schon, der Planer konsumiert es nicht:** `<measurement_tooling><combo tools=…>`
existiert in **7 Profilen** und wird geparst — aber *„der Plan-Director konsumiert
measurement_tooling NICHT (`measurement_combos_of(categories)` ⇒ 1 Voll-Konfig `[all]`)"*.
`measurement_axis_registry.xml` ist **generierte Ausgabe**, kein Schalter.

**Der Stempel-Anschluss steht bereits:** die Combo wird *„GENAU EINMAL aufgelöst"* und reist als
**Glied [3] ins Tier-Preimage und in die Tier-ABI**; dieselbe Auflösung speist
`perm_mess_defines()` — *„EINE AUFLÖSUNG, ZWEI VERBRAUCHER"*.

---

### KON34-03 — 🔴 DIE AUFLÖSUNG: DIE 6 VERLIERT IHREN GEGENSTAND, WEIL DIE INSTRUMENTE NICHT AN EINEM ORT WOHNEN

**Was die 6 fachlich war:** `steuer_dock.hpp:229-241` erzwingt 6 Docks = **3! Reihenfolgen** der
**einen geordneten Typliste** `Konfiguration<Wallclock,Makro,Mikro>`. **Voraussetzung dieser
Zählung:** alle drei Instrumente bilden **eine gemeinsame Kette an EINEM Ort**, immer vollzählig —
permutiert wird nur ihre **Ordnung**.

**Was die 32 ist:** fünf **unabhängige Schalter** (Tier Micro/Macro · Hybrid Micro/Macro · CEB
Wallclock) ⇒ 2⁵ = **32 Belegungen**.

    DIE HERLEITUNG AUS DER KARTE:
      Die drei Instrumente wohnen NICHT an einem Ort. Wallclock gehoert zur CEB-Stufe,
      Micro+Macro zum Tier, eigene Micro+Macro zum Hybrid. Schon im IST liegt PMC auf
      einer anderen Stufe (CEB/Host) als G1-G3 (Tier).
      => Eine REIHENFOLGE-Permutation ist nur ueber Gliedern definiert, die GEMEINSAM in
         EINER Kette an EINEM Traeger stehen. Instrumente auf verschiedenen Traegerstufen
         stehen in GAR KEINER gemeinsamen Verschachtelungsordnung -- die CEB misst UM das
         Tier herum, das Tier misst IN sich.
      => Was je Stufe uebrig bleibt, ist keine ORDNUNGS-, sondern eine AUSWAHLfrage:
         welche Einrichtungen dieser Stufe sind einkompiliert (an) und welche nicht (aus).
      => 5 Schalter => 32 Belegungen => maximal 32 Docks (je geforderter Belegung eines).

**Die 6 und die 32 sind Antworten auf verschiedene Fragen** — Ordnung einer **ortsfesten
Vollmenge** gegen An/Aus **verteilter** Einrichtungen. **Die Frage der 6 verliert ihren
Gegenstand, sobald die Träger-Stufen-Zuordnung ernst genommen wird.**

**🔴 Und die Karte erklärt, warum der Widerspruch bisher unsichtbar blieb:** der IST-Betrieb fährt
**ausschließlich `[all]`** (die Combo wird nie gesetzt) — **in der Vollmenge sehen beide Modelle
gleich aus.**

**Die Rolle von System B:** es ist der **bereits gebaute Compile-Time-Träger genau dieser
Auswahlfrage** — kodiert heute aber die **falsche Kombinatorik** (Permutation der Vollmenge) und
erreicht den Tier-Pfad nicht. **Nicht löschen** (Owner-KERN 09.08.: checkpoint_measure muss
gebaut werden), sondern **umstellen**: Typwahl = **aktive Teilmenge je Träger-Stufe** statt
Ordnung der Gesamtliste.

---

### KON34-04 — DIE BAU-POSTEN B1…B5

    B1  XML-KONSUM (der eigentliche Schalter): der Plan-Director konsumiert
        <measurement_tooling> ende-zu-ende (Combos aus dem Profil statt hart [all]);
        das Element um die STUFEN-DIMENSION erweitern -- heute nennt es nur `tools`,
        nicht tier/hybrid/ceb, KON25-03 verlangt Schalter JE STUFE. Dock-Anzahl folgt
        dynamisch, Obergrenze 32. KEINE YAML -- Emission ueber das zentrale Bau-Modul.
    B2  GATE-TRENNUNG G2/G3: eigenes Micro-Gate statt des geteilten
        COMDARE_CE_ENABLE_STATISTICS; die bereits emittierten
        COMDARE_MEASUREMENT_TOOLING_MACRO/MICRO=1 bekommen LESER.
        OHNE B2 ist "Tier = Micro+Macro je an/aus" UNERFUELLBAR.
    B3  HYBRID-GATES: von Platzhalter zu echten Gates -- erst damit existieren die
        FUENF Schalter; heute sind nur 2^3 = 8 Belegungen adressierbar.
        Der Wallclock-Umzug Tier -> CEB hebt zugleich den Pflicht-Wurf auf CEB-Ebene.
        VOR F2 (heute kostenlos, ab 26.08. teuer).
    B4  SYSTEM B UMSTELLEN UND ANSCHLIESSEN: static_assert(anzahl == 6) faellt zugunsten
        der Belegungs-Zaehlung (dynamisch <= 32); Instanziierung durch den Builder --
        das ist der fehlende Baustein "Steuerung -> Compile" aus KON10.
    B5  STEMPEL-PFLICHT: jeder neue Stufen-Schalter laeuft durch die EINE bestehende
        Aufloesung und damit ins Tier-Preimage-Glied [3]; CEB-seitig ist das
        PMC-Vendor-Glied das Vorbild. Aenderung ohne X.Y.Z-Bump => schneller UND falsch.

---

### KON34-05 — `--debug` UND DIE MESS-SCHALTER SIND STRENG DISJUNKT

`--debug` ist *„CLI-Flag auf der Planer-Shell, **orthogonal zu allen vier States**"*, es *„wirkt
auf die **Ausprägung** (max. Threads, Jitter-Prüfer aus), **NIE auf Reihenfolge oder
Abhängigkeiten**"* — Zweckformel: *„darf **alles beschleunigen und nichts umleiten**"*
(Ledger :7694-7716). **Die Mess-Schalter dagegen ändern das Kompilat und den Stempel.**

🔴 **Da die Kette per KON28-01 bis zur Abgabe mit `--debug` fährt, MUSS die Mess-Schaltung von
`--debug` unabhängig bleiben** — sonst wäre jedes Ketten-Kompilat **anders bestückt** als das
Release-Kompilat. Einziger Berührpunkt: `Debug` liefert *„KEINE Mess-golden-Zahlen (Verifikation
der Verdrahtung)"* — **Debug-Läufe verifizieren die neuen Schalter, bewerten sie nicht.**

---

### KON34-06 — WAS AUCH JETZT OFFEN BLEIBT

    (a) Der Owner-Haken zur Herleitung: der Ledger fuehrt "32 Docks = 32 Mess-Permutationen"
        ausdruecklich als BEOBACHTUNG, keine Festlegung (KON28-03). Diese Kartierung liefert
        die HERLEITUNG -- die Bestaetigung steht aus.
    (b) Ob REIHENFOLGE INNERHALB einer Stufe je Mess-Gegenstand eine Rolle spielt, ist
        unentschieden (dieselbe offene Frage wie 4!=24/48 beim Hybrid).
    (c) Schnitt 2 fehlte der Synthese -- die SOLL-Zuordnung aus den PLAENEN ist damit nicht
        gegengelesen; die Herleitung stammt aus dem CODE.
    (d) Die 17-vs-18-Dateizaehlung des Doppelbaus blieb unaufgeklaert.
