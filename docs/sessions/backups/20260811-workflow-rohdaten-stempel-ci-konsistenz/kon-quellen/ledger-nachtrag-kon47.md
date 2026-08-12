## NACHTRAG 12.08.2026 — KON47: VIER ANTWORTEN — DER F1-WEG IST (a) AM PLANER-TEIL, DAS WARMUP-PAAR IST DIE PFLICHT-REGEL, UND DER BAU BEGINNT

**Der Owner hat FR-1…FR-4 beantwortet — FR-4 korrigiert die KON45-Vorlage (kein separater
Zell-Warmup: das PAAR-Muster je Wiederholung ist die Regel), FR-3 dreht die
Provenienz-Empfehlung (VOLL bauen, wenn an der Reihe). Zitate wörtlich.**

---

### KON47-01 — 🔴 FR-1: OPTION (a) FÜR DEN PLANER-TEIL ZUERST — UND DIE VERTRAGSGRENZEN-DURCHGEHENS-DOKTRIN

**Owner verbatim 12.08.2026:**

> *„Wir müssen mit dem **Planer Binary und der XML als Grundlage für die Features beginnen,
> die dann tatsächlich freigeschaltet werden**. **Existiert denn derzeit der Planer schon in
> der separaten Zielform?** Wir brauchen den **Katalog emitter** und **gehen die Aufgaben aus
> der festgelegten Reihenfolge der Träger-Stufen durch und prüfen je Vertragsgrenze ob alles
> korrekt steht**. Daher **Option (a) für den Planer Teil zuerst**."*

    DER F1-WEG: (a) -- aber als PLANER-TEIL geschnitten:
      der KATALOG-EMITTER (der heute die 2-arg-Form ohne Mess-Zeile emittiert) wird auf
      der Planer-/Emissions-Ebene korrigiert, sodass Emitter und Pruefgate uebereinstimmen
      (Vollmengen-Zeile "[all]" auch auf dem Katalog-Pfad -- konsistent zur Konsumenten-
      seite, KON44-01). KON5-01 ist damit PRAEZISIERT: der leere Mess-Stempel war Emitter-
      Sollverhalten des ALTEN Standes; das SOLL ist jetzt die Konsistenz beider Seiten.
      Preimage-Wirkung (Basis-320-Fingerprints aendern sich): HEUTE KOSTENLOS
      (nie eine Flotte gebaut) -- genau deshalb (a) jetzt.
    DIE DOKTRIN dahinter: Planer-Binary + XML = die GRUNDLAGE der tatsaechlich
      freigeschalteten Features; die Aufgaben werden IN DER TRAEGER-STUFEN-REIHENFOLGE
      durchgegangen und JE VERTRAGSGRENZE geprueft, ob alles korrekt steht
      (Planer->CEB · CEB->Tier · CEB->Hybrid).

**ANTWORT auf die Owner-Frage (am Objekt gemessen):** Der Planer existiert als **eigene
Binary** (`apps/experiment_planner/CMakeLists.txt:13 add_executable(comdare_experiment_planner)`)
— aber **NICHT in der KON43-Zielform**: die Planer-Substanz (Director, plan_legend,
planner_*-Familie) lebt als `libs/cache_engine/profile_facade/planner/` **im Monolithen**
`libs/cache_engine`, und die apps/-Ebene ist eine Werkzeug-Liste (10 Binaries), keine
Träger-Stufenform. **Das Planer-Unterprojekt ist der erste Schnitt des Monolith-Splits
(Task #29a)** — und nach der Zielform-Pflicht (KON43) baut der F1-Planer-Fix bereits
**in diese Zielform hinein**, wo er Neues anlegt.

---

### KON47-02 — FR-2 BESTÄTIGT + ERWEITERT: SHA IN DER CT-MAP, VOLLE STEMPEL PER INIT-CACHE ZUR LAUFZEIT

**Owner verbatim:**

> *„Ja so machen wir es, wir verwenden für **jedes Tier-Binary nur dessen SHA statt des
> gesamten Stempels**. Wie empfohlen und lässt sich durch **caching der vollen Stempel der
> Tier-Binaries an den Prüfdocks zum init des Hybrids mit den Tier-Binary modules auch von
> der CEB über die Fläche 2 zur Laufzeit abfragen**."*

    CT-MAP (Identitaet):  {Synthese-Funktions-Key -> Tier-SHA (128-hex)} -- Budget haelt.
    RT-CACHE (neu):       beim HYBRID-INIT werden die VOLLEN Tier-Stempel an den
                          Pruefdocks GECACHT (mit den geladenen Tier-Modulen) und sind
                          von der CEB UEBER FLAECHE 2 zur Laufzeit abfragbar.
    => deckt exakt die KON45-01-Aufloesung (CT=Bau-Belegung, RT=IST der Einrichtung,
       RT-Menge ⊆ CT-Map) und KON7-04(7): angeschlossene() ist der Laufzeit-Sammler --
       sein Datenbestand ist DIESER Init-Cache. Bau-Detail fuer HY-A2.

---

### KON47-03 — 🔴 FR-3 GEDREHT: FESTPLATTEN-IO WIRD VOLL GEBAUT — WENN AN DER REIHE

**Owner verbatim:**

> *„Der Festplatten IO Ausbau ist eine **Meta-Meta-Organ-Achse, die voll in alle anderen
> Genus Interface-Funktionen integriert werden muss**. Daher **ja, voll bauen wenn an der
> Reihe**."*

    Die Provenienz-nur-Empfehlung ist ABGELEHNT: der Typ wird VOLL gebaut --
    inklusive der Comp-Gate-Schicht und der Integration in ALLE Genus-Interface-
    Funktionen. TIMING: "wenn an der Reihe" = in der Traeger-/Wellen-Reihenfolge
    (Organ-Achsen-Ausbau; nicht vor F1/F2 erzwungen). Der KON45-02-Befund (Comp-Gate
    fehlt in allen drei Realms, Tripwire simd_build_gate.hpp:272-278) wird damit
    zum Pflicht-Umfang des Postens, nicht zum Ausschluss.

---

### KON47-04 — 🔴 FR-4 PRÄZISIERT DIE WARMUP-REGEL: DAS PAAR (VERWERFEN+SPEICHERN), DREIMAL — PFLICHT UND TESTPFLICHTIG

**Owner verbatim:**

> *„Cache Warmup ist so gebaut, dass **immer 3 mal folgendes passiert: Es wird einmal
> gemessen und verworfen, es wird einmal gemessen und mit warmem cache gespeichert**. Das
> ist **Pflicht für die Forschung, muss getestet sein**, kann bei **--debug auf kaltem Cache
> laufen also nur einmal**. **SONST IMMER ZWEI MAL.**"*

    DIE REGEL (ersetzt die KON45-03-Zell-Warmup-Vorlage -- kein separater Zell-Warmup):
      NORMALBETRIEB   je Wiederholung ein PAAR:
                        Lauf 1: messen und VERWERFEN   (das Warmup)
                        Lauf 2: messen und SPEICHERN   (warmer Cache)
                      x 3 Wiederholungen  =  6 Laeufe, 3 persistierte Werte
                      (KF-10: die 3 gespeicherten EINZELN, nie gemittelt -- unberuehrt)
      --debug         NUR EINMAL, kalter Cache (die Generalproben-Beschleunigung)
      SONST           IMMER ZWEI MAL. PFLICHT FUER DIE FORSCHUNG. MUSS GETESTET SEIN.
    KONSEQUENZEN:
      * der prozess-kalte Erstlauf ist im Paar-Muster AUTOMATISCH gedeckt (Lauf 1 der
        ersten Wiederholung faengt die Kaelte) -- die KON45-Luecke loest sich ueber
        die DURCHSETZUNG des Musters, nicht ueber einen neuen Mechanismus.
      * BAU-/TEST-POSTEN (vor der Kampagne): ALLE Messpfade fahren das Paar-Muster
        (two_phase_measure ist das gebaute Vorbild; der Legacy-Pfad run_observable_perm
        misst heute KALT -> anpassen oder ausbuchen); TESTS nach T-1..T-9 (Paar-Zaehlung
        2x3, --debug-Zweig 1x, Verwerf-Beweis); der --debug-Zweig verzweigt am
        RunMethodology-Flag (quer, KON34-05: beschleunigt, leitet nie um).

---

### KON47-05 — DER BAU BEGINNT

    OFFENE OWNER-FRAGEN: NULL (nur das v3.5-GO wartet als Vorlage, blockiert nichts).
    START (Strecke + KON43-Reihenfolge + Fable-5-max-Order):
      Strang A  ⭐ S-1 Stempel-Basisklasse (kritischer Pfad; Planer-Querschnitt)
      Strang C  ⭐ F1-PLANER-FIX (FR-1/Option a): Katalog-Emitter -> Vollmengen-Zeile,
                 Konsistenz Emitter==Pruefgate, dann der Durchstich-Lauf
      Strang D  #83 lint:format -> #84 -> #80 (ce gruenen, stempelfremd)
    Je Vertragsgrenze wird geprueft (KON47-01-Doktrin); parallel bauen, seriell landen.
