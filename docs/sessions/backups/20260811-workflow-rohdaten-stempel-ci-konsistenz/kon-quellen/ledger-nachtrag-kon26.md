## NACHTRAG 12.08.2026 — KON26: WF4 IST GELANDET — DIE FÜNF KON19-EXPLORES

**19 von 21 Agenten (zwei Transkript-Schnitte starben am StructuredOutput-Limit, von den
Gegenproben am Objekt kompensiert; drei TEST-Stubs von den Gegenproben verworfen — der
Platzhalter-Gate-Bedarf ist zum zweiten Mal belegt).** Volltext:
`docs/sessions/20260812-WF4-SYNTHESE-die-fuenf-kon19-explores.md`.
**⚠️ Zeitstand:** WF4 lief **vor** KON25 — seine 24/48-Aussagen zum Hybrid-Nenner sind durch
die **32** (KON25-03) überholt; alles andere gilt.

---

### KON26-01 — E-A: „FESTPLATTEN-IO ALS META-META" IST DIE NEU-BENENNUNG EINER ALTEN ENTSCHEIDUNG

Die Wortverbindung existiert vor dem 12.08. **nirgends** (dreifach geprüft, mit Gegenproben).
Die **Substanz** existiert vollständig — als Owner-GO vom **26.07.**: die 18. Organ-HAUPTACHSE
`persistence_target` („unterscheidet, ob ein Algorithmus nur in Memory arbeitet oder auf Platte
zurückschreiben muss") — **fast wortgleiche Begründung, aber als Hauptachse**. Chronologisch
zwingend: am 26.07. war „Meta-Meta" gerade erst definiert, am 27.07. per OP-11 **verboten**,
am 02.08. per Owner-E2 wieder erlaubt. **Der Owner benennt heute eine echte alte Entscheidung
erstmals als Meta-Meta — Präzisierung, keine Widerlegung.**

    AM OBJEKT: SIMD-Meta-Meta GEBAUT (SimdExternalUtilsFamily : SystemMetaMetaAxis,
      17 static_asserts) -- aber axis_kind() meldet noch system_config (bewusst hinter
      O-8 verschoben) und der ExternalUtilsHub hat NULL Konsumenten; die real wirkenden
      -mavx-Flags laufen ueber profile_run_facade.cpp:200,702-720,1262-1280.
    IO-Substanz = ZWEI regulaere Organ-HAUPTACHSEN: io_dispatch T12 (4 Bausteine ON,
      ehrlich RAM-Simulationen) + persistence_target T17 (MemoryOnly ON; DiskWriteback
      GEBAUT aber per Owner Q-1/Fall B OFF).
    Organ-Meta-Meta-MECHANISMUS existiert (OrganMetaMetaAxis<Derived>), INHALT leer
      (MetaMetaMembers<> dreifach bestaetigt).
    KONSEQUENZ (Additiv-Doktrin): eine Festplatten-IO-Meta-Meta waere ein NEUER,
      ADDITIVER Typ ueber der OrganMetaMetaAxis-Wurzel -- T12/T17 bleiben unangetastet;
      "Umklassifizierung" waere ein Neubau daneben, kein Umbenennen.

---

### KON26-02 — E-B: K2 WAR ZWEIFACH BEANTWORTET — DIE VORLAGE HATTE DIE ERSTE ANTWORT VERLOREN

Die 09.08.-Antwort (*„der Loader wandert in eine **stufen-neutrale Bibliothek**, weil das
Prüfdock der CEB und das Prüfdock der Hybrid-Tier-Binary technisch identisch sein müssen"*)
stand im Ledger — **die Owner-Vorlage vom 11.08. führte sie nicht mit**, wodurch K2 als offen
zirkulierte. KON21-01 (12.08.) **verfeinert** sie (Betriebsarten + Autonomie + Sync-Kanal),
widerruft nichts. Die K2-Erklärung mit dem vollen Eigenschafts-Katalog des Hybrid (Identität ·
Ort≠Zeit · Rolle · Stempel · Messung · Bereichs-Karte · Bau-Muster, jede Zeile Owner-Wort mit
Anker) steht in der WF4-Synthese §2. **Neuer Zahlen-Widerspruch dabei gefunden:** Hybrid-Dock-
Obergrenze **Default 32** (XML) gegen **Q6-MaxN 8** (`synthese_matrix.hpp:33-51`) → in die
offene Liste.

---

### KON26-03 — 🔴 E-C: DAS ÜBERHOLT-URTEIL ZERFÄLLT IN ZWEI POSTEN — DIE SUBSTANZ IST PRODUKTIONSKRITISCH

**Herkunft belegt:** `--dump-plan` prägte ein **Opus-Subagent am 16.07., 22:52 UTC**;
`PlanTextBuilder`/Fork B ein 7-Agenten-Lauf am 19.07.; **0 von 353** klassifizierten
Transkript-Fundstellen tragen Owner-Herkunft; Fork B wurde **agentisch entschieden und gebaut**
(ce `c9240477`), nie owner-bestätigt. Die Owner-Erinnerung („ich habe diesen Begriff nicht
geprägt") ist exakt richtig.

    (a) FLAG-WORT --dump-plan:  UEBERHOLT -- UND BEREITS VOLLZOGEN (seit 05.08. im
        Alt-Treiber tot, rc=1 + Verweis; in der neuen Planer-Binary bewusst nicht
        mitgewandert). O-13 fuer das Flag: ERLEDIGT markiert.
    (b) SUBSTANZ PlanTextBuilder + 'plan dump':  NICHT ueberholt -- PRODUKTIONSKRITISCH:
        einer von 6 Buildern am EINEN Director · Byte-Determinismus-Tests · hart
        gegateter CI-Job visibility:tier-binaries (KEIN allow_failure) · realer
        Downstream-Parser parse_plan_dump() · 55 Commits, gepflegt bis 11.08.
        EINE STREICHUNG WAERE ABRISS AKTIVER, HART GEGATETER FUNKTIONALITAET.

⇒ **Rück-Vorlage an den Owner (ein Satz):** dein „überholt, wird nicht mehr benötigt" trifft
das **Flag** (vollzogen) — die dahinterliegende **Plan-Text-Substanz** trägt heute den
Sichtbarkeits-CI-Job und den Contract-Test. **Bestätige, dass sie bleibt** (Empfehlung: ja) —
oder benenne den Ersatz, bevor gestrichen wird.

---

### KON26-04 — 🔴 E-D: DIE 5 IST FALSCH VERDRAHTET — DER UMZUGS-BAUPLAN STEHT

Der Owner-Satz (GOAL VI.5) enthält **zwei verschieden große Mechanismen**: T-15a (Drift →
Lauf-Neustart; „ganzer Lauf" = die Kampagne, Granularität per KON19-06 = ALLES) und **T-15b
(failed → bis zu 5 Wiederholungen des GESAMTEN Prüfdock-Durchlaufs EINER Tier-Binary)**.
Commit ce **`4cd1ab91` (09.08.)** legte die 5 auf `DriftGateConfig::max_reruns` — **die falsche
der zwei im Commit selbst dokumentierten Lesarten.**

    NEU ZU BAUEN: Retry-Klammer um measure_one_binary (iterator :3127), Ausloeser
      load_failed ueber die drei SourceUnavailable-Pfade, bis zu 5 Versuche, danach
      bestehende failed-Doktrin ("failed" in die Zelle, nie null, Lauf misst weiter).
    UNBERUEHRT: Drift-max_reruns (andere Bedingung/Einheit) · KF-10 n_repeats=3 · T-15a.
    RIPPLE-LISTE (8 Punkte, WF4 §3.1): drift_gated_cell-Kommentar + Default-Rueckbau
      (OWNER-ENTSCHEID, nicht stillschweigend) · iterator :372-383 · xml_config_parser
      (eigenes Attribut fuer den Binary-Retry) · planner_mengen_types (NEUER Kostenfaktor)
      · 🔴 checkpoint_speicher.hpp:119-123: die Arena-Formel (18 Durchlaeufe je Zelle)
        muss den binary-weiten x5 ZUSAETZLICH decken -- sonst UNTERDIMENSIONIERT
      · profile_run_facade-Uebertragungspunkte · Test-Pin umschreiben + neuer Test ·
        Register S5-06 datiert korrigieren.
    OFFEN (Owner/Explore): zieht SampleStatus::Failed EINZELNER Einstellungen den
      Binary-Durchlauf mit?

---

### KON26-05 — 🔴 E-E: ES GAB NIE EINE 16-KERNE-ENTSCHEIDUNG — UND OD-7 SAGT „WORKER", NICHT „KERNE"

**Die vollständige Owner-Timeline (vier echte Äußerungen, human-klassifiziert):** die falsche 24
stammt **vom Owner selbst** (22.07.: *„prod1 32 Threads und 24 Kerne und prod2 24 Threads und
16 Kerne"* — **die Werte der zwei Maschinen vertauscht**; real: prod1 = 16 Kerne/32 Threads
Ryzen 9950X3D · prod2 = 16 Kerne/24 Threads i9-12900K). OD-7 (26.07.) sagt durchgehend
**„24 Worker"**, nie „24 Kerne" — **beide Male, als gefragt wurde, hat der Assistant „Worker"
als „Kerne" wiedergegeben.** Die scheinbar widersprüchlichen Antworten („lassen wir so" 10.08.
vs. „müssten 16 Kerne sein" 12.08.) sind Antworten auf **zwei nie sauber getrennte Fragen**.

    AM OBJEKT: runner-mode.sh:43 HEAVY_J=24 (kein 16-Cap) · §69.6 "24 Worker" ·
      zwei unkorrigierte "32 Threads/24 Kerne"-Ledger-Zitate · N-3/N-4 rechnet
      "24 Worker je Lane" · die ETA-KERNFORMEL rechnet mit THREADS (32, korrekt) --
      der Mess-Deckel haengt NICHT primaer an 16-vs-24.

⇒ **Präzise Owner-Vorlage (ein Satz):** *Hardware-Fakt ist 16 Kerne/32 Threads (prod1) — bleibt
der operative HEAVY-Worker-Deckel bei **24** (thread-orientiert, dein OD-7-Wortlaut „Worker"),
oder wird er auf **16** gesetzt (kern-orientiert, deine heutige Zahl)?* Danach die
Korrekturliste (zwei Ledger-Zitate, ggf. runner-mode.sh).

---

### KON26-06 — BILANZ

    ERLEDIGT:   O-13-Flag (vollzogen) · K2 (zweifach, Katalog steht) · OD-7-Timeline ·
                T-15b-Bauplan · Meta-Meta-Genealogie
    RUECK-VORLAGEN (je 1 Satz):  E-C-Substanz bestaetigen · OD-7 Worker 24 vs. 16
    NEUE WIDERSPRUECHE: Hybrid-Dock-Obergrenze 32 (XML) vs. Q6-MaxN 8 (synthese_matrix)
    LAUFEND:    WF5 (E-F5 · E-F7 · E-F9 · E-F3b) -- danach die REFERENZ-KONSOLIDIERUNG
                (KON19-00)
