## NACHTRAG 12.08.2026 — KON29: DIE DEBUG-BETRIEBSDOKTRIN + WF5 IST GELANDET (die vier KON25-Explores)

---

### KON29-01 — 🔴 DIE DEBUG-BETRIEBSDOKTRIN: ERST FUNKTIONIEREN, DANN ECHT MESSEN

**Owner verbatim 12.08.2026:**

> *„Das Ziel ist erstmal **einen korrekten CI Durchlauf und lokalen Durchlauf zu laufen mit
> ungenauen Messwerten, sodass es überhaupt funktioniert und wir schnell testen können**. Die
> **Kampange fährt das komplette geplante state Pattern als Phasen über die Träger Stufen**
> (siehe Erklärung in diesem Kontext und explore in die Vergangenheit). **Sobald das System
> planmäßig steht und arbeitet stellen wir von Debug auf normal um und löschen die ungenauen
> Messergebnisse und messen echt mit 1 Thread.** **Debug ist hier das flag das quer zum State
> Patter gehörte.** Das ist etwa 1-2 Kontexte her. **Das muss in die Planer CLI mit rein bzw.
> als shell ausführbares flag mit dran, wenn man den Planer auf der shell aufruft (wie
> geplant).**"*

    DIE ZWEI BETRIEBSSTUFEN:
      STUFE 1 (jetzt, --debug):   korrekter CI-Durchlauf + lokaler Durchlauf mit
                                  UNGENAUEN Messwerten -- Ziel: es FUNKTIONIERT,
                                  schnelles Testen. Worker-Deckel 16 wird durch
                                  nproc-paralleles Messen kompensiert (KON28-01).
      UMSCHALTPUNKT:              "sobald das System planmaessig steht und arbeitet"
      STUFE 2 (normal):           Debug -> normal umstellen ·
                                  DIE UNGENAUEN MESSERGEBNISSE LOESCHEN ·
                                  ECHT messen mit 1 THREAD (RunMethodology::Measure)

    ARCHITEKTUR-EINORDNUNG:
      die Kampagne faehrt das KOMPLETTE geplante STATE-PATTERN als PHASEN ueber
      die Traeger-Stufen (die 4 CacheEngine-Modi, Dossier 19 TEIL G:
      Mess- -> Auswertungs- -> Arbeits- -> Hybrid-Modus; "Alles endet in dem
      state pattern der Durchfuehrung", Z. 35912).
      DEBUG IST DAS FLAG QUER ZUM STATE-PATTERN -- orthogonal zu allen Phasen
      (Owner-Verweis: definiert vor 1-2 Kontexten; deckt sich mit der
      RunMethodology-UNTER-Achse, run_methodology_registry.hpp:52).

    BAU-ANFORDERUNG:
      --debug in die PLANER-CLI bzw. als shell-ausfuehrbares Flag beim
      Planer-Aufruf ("wie geplant") -> Teil von S-8/S-12.

**🔴 Benannte Ausnahme der Messdaten-Doktrin:** *„Messdaten werden NIE gelöscht"* bekommt die
**einzige, owner-angeordnete Ausnahme**: die **ungenauen Debug-Messergebnisse** werden beim
Umschalten auf normal **gelöscht** — sie sind Verdrahtungs-Verifikation, keine Messdaten. Die
echten 1-Thread-Messwerte bleiben unantastbar. *(Memory wird entsprechend präzisiert.)*

---

### KON29-02 — E-F5 GELANDET: ZIEL (3) ENTSCHIEDEN — UND DER IST-ZUSTAND VERLETZT DEN ENTSCHEID REAL

Der Entscheid liegt wörtlich im letzten Kontext (Z. 43026, 21:24:47Z = KON13-04): Ziel (3)
bekommt **nur** Zusammenfassung+LaTeX+PDF+angeforderte Einzelnachweise. **Der ungefilterte
Ist-Zustand ist NICHT gedeckt** — Gegenprobe über alle 31 Owner-Nachrichten des letzten
Kontexts: **null** Treffer für „bis S-13"/„übergangsweise". Und der Code verletzt den Entscheid
heute real: `cache_engine_builder_iterator.hpp:3089-3093` ruft `measurement_sink` **unbedingt je
result.csv**; ein Filter existiert nicht. ⇒ **Der S-13-Filter (Task #18) steigt in der
Dringlichkeit: der Kanal sendet heute jede per-Binary-CSV gegen den Owner-Entscheid.**
Die Routing-Mechanik ist seit KON27-02 (Option b) komplett — Rest ist Bau.

---

### KON29-03 — E-F7 GELANDET: DER PLAN IST DOSSIER 19 TEIL G — DIE VIER MODI

**Fundort:** `docs/architektur/19_SCHICHTEN_FERTIGSTELLUNG_E4_E1_INTERFACE_VERTRAEGE.md:119-132`
(TEIL G, User 09./10.07., bindend): *„Alle 4 Phasen der cache-engine (**Mess- → Auswertungs- →
Arbeits- → Hybrid-Modus**) müssen erzeugt und in E4 […] AUTOMATISCH dokumentiert werden"* — die
einzige Bestandsstelle, die „Phase" wörtlich an die vier Betriebsmodi bindet. **Das ist das
State-Pattern aus KON29-01.**

    UMBENENNUNGS-LANDKARTE (alle Stellen am Objekt bestaetigt):
      KLASSE A  "Phase" -> "Traeger-Stufe":  batch_planner.hpp:92-101 (type_phase_rank,
                "Phasen-Raenge" ueber planer/ceb/tier) · bestandslog_document.hpp:117-121
                -> UMBENENNEN, heute kostenlos, ab 26.08. teuer
      BAU-POSTEN (kein Umbenennen): die 4 Modi-Phasen als CODE-Bezeichner = 0 Treffer
                (Gegenprobe RunMethodology 7 Dateien) -- das State-Pattern ist zu BAUEN
      KLASSE C  DRITTES Konzept, von der Owner-Zweiteilung NICHT erfasst: XSD
                <phase merge="Stufe1_CeOnly|Stufe2_PrueflingReplace|Stufe3_FullJoin">
                + MergeStrategy; golden zeigt phase2->Stufe1 (nicht 1:1)
                -> OWNER-FRAGE (Umbenennung braeche Golden-Bytes)
      KLASSE D  Homonyme UNVERAENDERT lassen: §61-Modi-Leiter · "PHASE 1/2"-ABI-Stempel ·
                phase=bau|pruef|mess-CI-Marker · two_phase_valid · COMDARE_PHASE_B/E
    mtime-Gegenprobe: 0 Kandidaten-Dateien am 12.08. angefasst -- Trennung 0 % begonnen.

*Nuance: das 06.08.-Klärungsdokument nannte „PHASE" die Kettenposition — das ist die
12.08.-Bedeutung von STUFE. Beide Alt-Fassungen sind durch KON25-07 überstimmt.*

---

### KON29-04 — E-F9 GELANDET: DER GEN-2-PLAN GILT — ZWEI LÜCKEN VOR DER KAMPAGNE

**Gen 1** (§35/§36, statische CI-Matrix) ist DEPRECATED (RF-4, archiviert). **Gen 2 gilt**
(§62/§62-B, 21.–23.07.): Bestandslog auf minio — *„prod1 baut ALLES, was es kann, und prod2
baut ALLES, was es kann"* — Claims à 4096, 30-min-Pro-forma, ETA=Σt/N, **Takeover bei ETA+50 %**,
Jobs **O(Maschinen)**. **Kern verdrahtet und scharf seit 09.08.** (LAG-P1; 23 Header; Takeover-
Sweep produktiv; in measure:smoke/golden-320/planer:delegate eingebunden).

    ZWEI LUECKEN VOR DER KAMPAGNE:
      (1) window_belongs_to (§62-B-GLEICHVERTEILUNG) gebaut+getestet, NICHT verdrahtet
          (0 Treffer in planer_driven_build) -- verdrahten ODER ausbuchen (Design-Wahl)
      (2) DIE MESSUNG IST NICHT ZWEILANIG: measure:golden-320 ist global-exklusiv
          (resource_group ceb-measurement-exclusive, hart amd/prod1) -- die
          §61-Revision (ceb-measure-<host>, 21.07.) ist bis heute nicht umgesetzt.
          Intel-Gegenstueck fehlt. (Wallclock-Abgabe-Lane bleibt plattformrein prod1.)
    KORREKTUREN: prod2 = i9-12900K seit RMA (~10.07.), nicht i9-14900KS -- funktional
    folgenlos (beide ohne AVX512). Kapazitaet zweilanig: prod1 20,7 h / prod2 34,4 h
    (Engpass) fuers 4-Perm-Profil; 12-Perm nie durchgerechnet (blockiert durch B-4).

---

### KON29-05 — 🔴 E-F3b GELANDET: 6 = ANORDNUNG, 32 = BELEGUNG — UND EIN DOPPELBAU-FUND

**Verschiedene Dimensionen:** die **6** zählt **Anordnungen** (`Permutationen<Liste<Wallclock,
Makro,Mikro>>`, static_assert `anzahl==6`; *„3! = 6 ist eine Zahl über PERMUTATIONEN, nicht über
Teilmengen"*; Ordnung=Identität). Die **32** (KON25-03) zählt **An/Aus-Belegungen**. **32/6 ist
nicht ganzzahlig — anders als bei 12=6×2 kann die 6 in der 32 nicht als Faktor überleben.**

**Chronologie-Korrektur (roh verifiziert):** das letzte Vor-32-Owner-Wort war wieder **„6"**
(10.08. **12:40**Z — also NACH der 12er-Korrektur von 07:27Z). **W-3 („Seite B/12 ist neuer")
kannte diese spätere Äußerung nicht.** *(Ein Schnitt-Nichtfund war eine Encoding-Falsch-Null:
„fakultaet" vs. „fakultät".)*

**🔴 Doppelbau-Fund:** seit 19./20.07. existiert ein **zweites Subsystem derselben drei Namen**
mit **AUSWAHL-Semantik**: `measurement_tooling_registry.hpp` + `plan_legend.hpp` (canonical_combo,
reihenfolge-UNabhängig, „[all]"-Sentinel) + XSD `<combo tools=…>` — **18 Dateien** referenzieren
es (gegen 3 für die 6er-Ordnung), Fan-out „dormant bis S5/S6". **Beide Subsysteme sind heute
inert.** Strukturargument (Ableitung, kein Owner-Wort): im 32er-Modell trägt die CEB nur
Wallclock → `anzahl==1` — die 6er-Maschinerie verlöre ihre Voraussetzung; ein Rückbau wäre aber
laut OV-10 ein **Gate-Modell-Umbau im Identitätsfenster mit Bump-Folge**. → **Owner-Frage.**

---

### KON29-06 — DIE WF5-BAULISTE UND DIE PRÄZISIERTEN OWNER-FRAGEN

**Bau (8 Posten, WF5 §2):** S-13-Filter (dringlich, KON29-02) · Drei-Ziele-XML auf Bestand ·
S-17-Verdrahtung · **Messung zweilanig (§61)** · window_belongs_to verdrahten/ausbuchen ·
Umbenennung Klasse A · Ledger-Doku-Nachträge (W-3-Chronologie · E-F5/7/9/3b auf erledigt ·
Zeilendrift) · Kapazität 12-Perm (blockiert B-4).

**Owner-Fragen (präzisiert, durch Explore nicht auflösbar):**
    R-1  F3b-KERN: ersetzt die 32 die 3!=6-Steuerdock-Maschinerie VOLLSTAENDIG
         (Rueckbau = Gate-Modell-Umbau mit Stempel-Bump), oder bleibt die 6 als
         eigene ORDNUNGS-Dimension daneben? Zusatz: Tier/Hybrid je 2 Instrumente --
         nur an/aus oder auch 2!-Ordnung? Und welches der zwei Subsysteme wird
         fortgefuehrt: die ORDNUNG (mess/, 3 Dateien) oder die AUSWAHL
         (measurement_tooling_registry, 18 Dateien)?
    R-2  F7-KLASSE-C: kuenftiger Name der XSD-Merge-"Phasen" (Stufe1_CeOnly...) --
         drittes Konzept; Umbenennung braeche Golden-/Schema-Bytes
    R-3  B-4: die BAU-MENGE (131072 | 524288 | 1572864 | 2097152) -- blockiert die
         Kapazitaets-Neuberechnung und den Planungs-Simulations-Nenner
    R-4  die "GERADE ANZAHL an Pruefdocks"-Invariante (Z. 35020): WAS zaehlt sie --
         je CEB, gesamt, oder Hybrid-Docks? (Rest von F11; max 32 ist entschieden)
    Dazu INFRA-Tatsachen (aus den Repos nicht einsehbar, seit dem PAT-Scrub blind):
    zeigt COMDARE_MEASUREMENT_DROP_URL live auf cache-engine-experiment/? ist
    COMDARE_STORAGE_CACHE=true als Projekt-Variable gesetzt? pve1/pve2/node3/node4
    online? Bestandslog je real unter Zwei-Maschinen-Last gelaufen?
