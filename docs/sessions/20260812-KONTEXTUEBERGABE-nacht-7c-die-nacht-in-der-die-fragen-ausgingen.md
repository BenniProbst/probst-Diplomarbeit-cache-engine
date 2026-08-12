# KONTEXTÜBERGABE 12.08.2026 — NACHT 7c: DIE NACHT, IN DER DIE FRAGEN AUSGINGEN

> **Stand:** Mi 12.08.2026, mittags · **F1 in 2 Tagen** (Fr 14.08.) · **Abgabe in 34 Tagen** (Di 15.09.)
> **Einstieg für die Nachfolge:** Ledger-Kopf lesen — **KON33 … KON15** stehen übereinander
> (19 Nachträge in zwei Tagen). **KON33 ist der jüngste Stand.** Danach dieses Dokument, dann
> das **Gesamturteil** (`20260812-GESAMTURTEIL-*`) und **Wellenplan §16**.
> **WF6 läuft noch** (R-1-Messeinrichtungs-Kartierung, `wf_37d98690-317`) — sein Ergebnis wird als
> **KON34** nachgetragen; danach wird kompaktiert.

---

## IN EINEM SATZ

Von neunundzwanzig offenen Fragen sind **alle** beantwortet — die Architektur ist zu Ende geklärt,
die Sicht auf die CI ist wiederhergestellt, und was bleibt, ist **Bau in der Träger-Stufen-Reihenfolge**.

---

## 1. DIE BILANZ DIESER ZWEI TAGE

| | |
|---|---|
| **Ledger** | 21.694 → **23.814 Zeilen** · **19 KON-Nachträge** (KON15 … KON33) |
| **Workflows** | **6** gefahren, **5 gelandet**, 1 läuft · zusammen **~100 Agenten**, 4 Tode (alle kompensiert) |
| **Owner-Fragen** | 19 + 10 + 4 = **33 gestellt · 33 beantwortet · 0 offen** |
| **Commits** | `c36f414a` … `f533aa71` — **19 Landungen**, alle auf beiden Remotes |
| **Pipeline** | super **15732 grün** (erstmals seit dem Scrub unabhängig belegt) · ce **15682 rot, genau 1 Job** |
| **Sicherung** | 235 Journale · 21 KON-Quellen · Owner-Extrakte · **797 M Voll-Ernte + 217 M Session-Log** durabel |

---

## 2. DIE ARCHITEKTUR — was jetzt gilt

### 2.1 Die Kette, konsolidiert aus allen Owner-Worten

    XML (Einstiegs-main.xml, REKURSIV: Teil-Experimente + volle Rezepte; jedes Paper = ein
         Experiment; DIE XML-SYNTAX IST EINE PROGRAMMIERSPRACHE)                    KON19-03
     └> PLANER   einzige DIREKT kompilierte Stufe · X.Y.Z + Fingerprint-SHA
         · B+-Baum lazy, Planer<->CEB synchronisiert
         · PLANUNGS-SIMULATION (S-19): GIBT ES NOCH NICHT -- Achsen erst gruppieren
           und kategorisieren, dann ueber den Baum die echte Permutation RECHNEN   KON30-03
         └> emittiert ueber DAS BAU-MODUL = eine C++23-PLANER-BIBLIOTHEK           KON18-01
             (Builder Pattern, 9 Builder + 1 Director; Emission = BESCHREIBUNG,
              reale Prozesse im BuildOrchestrator; KEINE YAML in der Kette --
              der CiYamlBuilder bleibt fuer den LOKALEN Build)                     KON25-04
             └> CEB   baut als EINZIGE · RAM-sequentiell · selbst "kein AVX"
                 · orchestriert alle Pruefdocks DIREKT ODER delegiert an den Hybrid
                 └> TIER    (Zahl aus der Planungs-Simulation)
                 └> HYBRID  danach, SELBE Stufe (Tiefe 3) · eigenstaendig ueber
                     WIEDERVERWENDETE CEB-MODULE + SYNC-KANAL zur CEB              KON21-01
                     · Transmitter/Multiplexer, KEIN Aggregator                    KON19-02
                     · bis zu 32 Pruefdocks, beliebige Anzahl                      KON28-03
                     └> LAGER = DER EMISSIONS-ABSCHLUSS ("im Lager zu finden")     KON17-02
                         └> MESSUNG  3x success · bis zu 5 PRUEFDOCK-Retries bei failed
                             └> EXPORT  Csv · LatexTable · ComparisonMetrics · XLSX
                                 -> Ziel 3: NUR Zusammenfassung + LaTeX + PDF
                                    + XML-benannte Einzelnachweise (Element je Format,
                                      LaTeX mit Inhaltswahl, PDF-Block LAZY)       KON27-02

### 2.2 Die vier tragenden Prinzipien

**(a) Die Träger-Rakete** *(KON25-08)*: eine Stufe **zündet bei Erfolg** die nächste — aber
**gebaut wird rückwärts**: jedes Binary-Modul ist nach dem Bau **eigenständig** und wird
**ABI-stabil in die vorhergehende Stufe gesteckt**, um von ihr bedient zu werden. *„Wir brennen
die Rakete nicht stufenweise ab, sondern bauen sie stufenweise rückwärts auf."* Jede Stufe hat
die **volle Pipeline** (Bau + Test + **Lint + Release** + Lager-Ablage + J-1…J-4).

**(b) Die geschichtete Wahrheit** *(KON21-02)*: **Code = Wahrheit der FREIGABE** (Registry wird
daraus generiert, Contract-Test bewacht) · **XML = Wahrheit der REALISIERUNG** (Metaprogrammierung
macht die Auswahl zur Binary-Realität) · **jede Binary = XML-Teilmenge des Codes**, `std::variant`
verboten.

**(c) Das Home-Prinzip** *(KON27-01)*: **jede Achsen-Kategorie braucht ihr eigenes Verzeichnis-Home
mit genau EINEM Wächter.** Organ = `axes/` (existiert), **Mess- und System-Homes fehlen**.
Prüf-Syntax je Phasigkeit (DREIPHASIG Mess · ZWEIPHASIG System/Organ). **Zweistufige
Versionierung:** Varianten ≠ → Interface-Versionen ≠; Algorithmen ≠ → Algorithmus-Versionen ≠.
**Zuerst eine gültige golden Version.**

**(d) Drei Flächen** *(KON16-06)*: 1 = Genus-Interface · 2 = Stempel (trägt Tools/Compiler als
**Systemachse**) · 3 = **measurement-Durchstich** — eingeführt, **damit Gattung+Genus-Interfaces
unverändert bleiben**. Fläche 3 **ist** die NAHT-1 vom 09.08. (`IMessVisitor`), beide Konzepte
**sind zu vereinen** *(KON25-02)*.

### 2.3 Stufe ≠ Phase ≠ Prüflings-Verbund — DREI Konzepte

    STUFE      = die BINARY, ein PHYSISCHES Objekt                                 KON25-07
    PHASE      = die CacheEngine-MODI (Konzeption), die UEBER die Stufen laufen
                 = das STATE-PATTERN: Mess- -> Auswertungs- -> Arbeits- -> Hybrid-Modus
                   (Dossier 19 TEIL G, 09./10.07.)                                 KON29-03
    PRUEFLING  = eine EIGENE Achse der VERBUND-/TESTSTRUKTUR -- technisch eine
                 MESS-UNTER-ACHSE des Planers zur Laufzeit, die in der CEB zu deren
                 Laufzeit die TIER-COMPILES freigibt                        KON30-02/KON31
                 (der Pruefling bietet je Organ-Achse zusaetzliche Algorithmen an,
                  IM PRUEFLING VERBUCHT UND VERSIONIERT, MIT EIGENEM STEMPEL;
                  XML-beschraenkbar auf 1..3 Varianten)

*Die frühere „Synonym"-Lesart ist überstimmt; meine Vermengung ist protokolliert
(„Du hast das nicht sauber getrennt").*

### 2.4 Der Mess-Nenner: 32

    TIER   Micro x Macro an/aus = 4   }
    HYBRID Micro x Macro an/aus = 4   }  4 x 4 = 16
    CEB    Wall-Clock an/aus    = 2
    => 32 MESS-SYSTEM-PERMUTATIONEN ueber die vier Traeger-Stufen        KON25-03

**Owner-Live-Selbstkorrektur dokumentiert** (*„Stop, das war falsch von mir"* — die 24 wurde im
selben Satz verworfen). **Ersetzt:** die 12-These, die 4!-Rechnung, die 24/48-Frage.
**Offen und Gegenstand von WF6:** das Verhältnis zur **6er-Anordnungs-Maschinerie** (3!
Wallclock/Makro/Mikro; 32/6 ist nicht ganzzahlig) — der Owner hat es als **Verständnis-Auftrag**
zurückgegeben: *„verstehe die Messeinrichtungen in jeder Träger-Stufe, dann wird es klar."*

### 2.5 Der Betrieb: zwei Stufen

    STUFE 1 (JETZT):  --debug -- korrekter CI- und lokaler Durchlauf mit UNGENAUEN
                      Messwerten. Ziel: es FUNKTIONIERT, schnell testen.
                      Kompensiert den Worker-Deckel 24 -> 16 (nproc-paralleles Messen).
    UMSCHALTPUNKT:    "sobald das System planmaessig steht und arbeitet"
    STUFE 2:          normal -- DIE UNGENAUEN ERGEBNISSE LOESCHEN, echt mit 1 THREAD.
    --debug ist das Flag QUER zum State-Pattern; gehoert in die PLANER-CLI.     KON29-01

🔴 **Die einzige benannte Ausnahme der Messdaten-Doktrin:** die ungenauen Debug-Ergebnisse werden
beim Umschalten **gelöscht**. Echte Messwerte bleiben unantastbar.

---

## 3. DER BETRIEBSSTAND — mit wiederhergestellter Sicht

    super  development = f533aa71   Pipeline 15732 GRUEN     beide Remotes
    ce     development = 670483c0   Pipeline 15682 ROT -- GENAU 1 Job:
                                    test:coverage-guard (contract, allow_failure=false)
    Projekte           = 531d0ea    nur GitLab
    main-FF beider Repos OFFEN (super main haengt ~25 Commits zurueck)

    PAT     keeper-root-rotation-20260725-r20260801 -- blind aus dem Vault, aktiv,
            api/read/write, gueltig bis 30.10.2026. Werkzeug:
            docs/sessions/backups/.../pat_neu_und_sicht.py (Wert wird NIE ausgegeben)
    RUNNER  24 sichtbar, 15 online -- prod1 UND prod2 baremetal ONLINE (zweilanig
            moeglich); pve1/pve2/node3/node4 offline
    VARS    COMDARE_MEASUREMENT_DROP_URL = https://measure-drop.comdare.local (Filterpod)
            COMDARE_STORAGE_CACHE = NICHT GESETZT (fuer S-13/Tests zu setzen)
    Platte  16 G frei (ein ce-Bau = 6 G -- vor Vollbauten pruefen)
    Laufend WF6 wf_37d98690-317 (R-1-Kartierung) -- sonst nichts

---

## 4. DIE AUFGABEN — wellen-zugeordnet, in veranschlagter Priorität

| Prio | Aufgabe | Welle | Task |
|---|---|---|---|
| **1** | 🔴🔴 **`##25` DURCHSTICH — die F1-Lieferung selbst, Fr 14.08.** | **W0b SOFORT** | #11 |
| **2** | 🔴 **ce grünen** — 1 Job: `test:coverage-guard` | **W0b** | #14 |
| **3** | 🔴 **MinIO-Keys** + 776 Runner-Token + prod2-`test:secrets` | **sofort** | #10 |
| 4 | **S-6-Fenster** (a Umstellung M,S,O · b Transpositions-Sperre · c Kategorien-Wache · harte Umbenennung) — **ein** Fenster, davor Layout-Bump-Konflikt | **W1 vor F2** | #15 |
| 5 | **golden → Kategorie-Homes → je Home ein Wächter** (S-18) | **W1 vor F2** | #16 |
| 6 | **T-15b-Umzug** (Prüfdock-Retry, 8-Punkte-Ripple, **Arena-Formel!**) | **W1** | #13 |
| 7 | **S-19 Planungs-Simulation** — gruppieren → kategorisieren → rechnen | **WE + W2 vor Trigger** | #7 |
| 8 | **G-2-Semantik-Nachzug** (Achsen-Nummerierungs-Reihenfolge) | W1/W2 | #17 |
| 9 | 🔴 **S-13 Export-Element + Filter** (der Kanal ist heute falsch) | **W2** | #18 |
| 10 | **main-FF** beider Repos (kumulative Hygiene-Wache!) | nach W0b | #19 |
| 11 | **Fläche-3-Vereinigung** + Deckungslücke CEB=AUS/Tier=AN | W1/W2 | #20 |
| 12 | **OD-7-Umsetzung** (HEAVY_J 16, `--debug` in die Planer-CLI) | W1 | #22 |
| 13 | **Messung zweilanig** (§61: `ceb-measure-<host>`, Intel-Gegenstück) | vor der Kampagne | (WF5 §2.4) |
| 14 | **window_belongs_to** verdrahten **oder** ausbuchen | vor der Kampagne | (WF5 §2.5) |
| 15 | **CI-Gerüst/S-12** neu gefasst · **S-3/S-7 aktivieren** | W1/W2 | #3, #4 |
| 16 | **Prüfposten**: E-1…E-4 · A-1-Vorlagetext · P/E-Core · Skelett-Tests | W7/Betrieb | #21 |
| — | **Referenz-Konsolidierung** der vier /goal-Dokumente | **nach WF6** | #9 |

**Der kritische Pfad zum Bau-Trigger (Mi 26.08.):** golden+Homes (5) → S-19 (7) → Bau in
**Träger-Stufen-Reihenfolge**, Planer zuerst. Ohne S-19 hat der Trigger **keinen belegten Umfang**.

---

## 5. WAS DER OWNER IN DIESEN ZWEI TAGEN ENTSCHIEDEN HAT — die Kurzliste

**Architektur:** keine YAML in der Kette · Bau-Modul = C++23-Planer-Bibliothek · drei Flächen ·
Tiefe 3, Tier vor Hybrid auf derselben Stufe · Hybrid eigenständig mit Sync-Kanal · eine rekursive
Einstiegs-XML als Programmiersprache · Code=Freigabe/XML=Realisierung · Home-Prinzip je
Achsen-Kategorie · Stufe/Phase/Prüfling sind drei Konzepte · Träger-Raketen-Aufbau rückwärts.

**Zahlen:** Mess-Nenner **32** · Prüfdocks **max 32, dynamisch** · Worker-Deckel **16** ·
CEB-Reihe 5→6→**12** · „gerade Anzahl an Prüfdocks" **gestrichen**.

**Betrieb:** `--debug` bis zur Abgabe, dann umschalten und ungenaue Ergebnisse löschen ·
beide Compiler Pflicht, **Skip verboten** · `-Wall`/`-Werror` überall (Ziel) · prod2 bleibt ·
measure-drop-Verstoß **übergangsweise genehmigt** bis der Filter steht.

**Lizenz/Formales (aus der 5-Kontexte-Ernte geborgen):** Abgabe = **Ausfertigungsdatum** ·
Cache Engine **frei nach 5 Jahren** (~2031) · Research-and-Teaching-Klausel bleibt ·
Prüfungsunterlagen werden **mitveröffentlicht**.

---

## 6. DIE METHODISCHEN BEFUNDE — sie gelten über diesen Kontext hinaus

**(a) „Gebaut, aber inert" ist das Systemmuster.** Vier unabhängige Quellen: beide Flag-Seiten
existieren und sind leer belegt · das Bau-Modul hat neun Builder und null Hybrid-Anteil · **keine
einzige unbenannte Hülle** (1351 Dateien geprüft) · der Owner selbst: *„wir sind viel weiter als
ich zugeben mag."* ⇒ **Konsolidieren → archivieren → in der Zielform aktivieren** ist die Bauform
der verbleibenden Wochen, nicht eine Arbeitsweise unter mehreren.

**(b) Jede „existiert nicht"-Aussage trägt ein Verfallsdatum.** Der xlsx-Befund war vormittags
wahr und nachmittags falsch — am selben Tag. Zweiter Fall derselben Klasse binnen einer Woche.

**(c) Der Köder-Generator war selbst die Falle.** `head -c 15 | base64 | tr -dc` liefert
**nicht-deterministisch 19 oder 20 Zeichen** — bei 19 beißt gitleaks nicht, und die Null ist
wertlos. **Länge prüfen, bevor die Gegenprobe zählt.** (Fallen-Register ergänzt.)

**(d) Drei Owner-Zitate waren still gekürzt** — eines kappte ein Ende **vor einem Blocker-Folgesatz**.
Regel ab sofort ohne Ausnahme: **jede Kürzung trägt `[…]`.**

**(e) Zwei Agenten-Tode und drei TEST-Stubs** in zwei Läufen ⇒ **Platzhalter-Gate** in künftige
Workflows; und: die **Kompaktheits-/Titel-Auflage** an die Synthese hat den Kopf-Verlust behoben
(WF4/WF5 kamen vollständig zurück, WF1/WF3 nicht).

**(f) Nummern sind kein Autoritätsbeleg.** Ein zweiter „S-6", ein zweites „D-12", drei
S-Zählungen — **vor jeder Posten-Referenz den Gegenstand prüfen, nie die Nummer.**

---

## 7. DIE BERGUNGSWEGE — alles löschsicher

    IM REPO  docs/sessions/backups/20260811-workflow-rohdaten-stempel-ci-konsistenz/
      alle-journale-20260812.tar.gz   ALLE 235 journal.jsonl (2 redigiert: glpat-, ghp_)
      kon-quellen/                    21 KON-Nachtrags-Quelldateien (KON14..KON33)
      owner-extrakte/                 die Owner-Nachrichten aller 6 Kontexte, Token-redigiert
      lauf-wf_*.tar.gz                7 Workflow-Laeufe vollstaendig
      wf_*.js · pat_neu_und_sicht.py · ernte_journal.py    die Werkzeuge
      MANIFEST.md                     7 Nachtraege, jede gitleaks-Null mit Koeder-Beleg

    DURABEL (nie committen -- Live-Token-Risiko)
      /home/comdare/ernte-20260812-nacht7c/
        workflows/          797 M -- alle 235 Laeufe VOLLSTAENDIG (inkl. agent-*.jsonl)
        session-log-*.jsonl 217 M -- der komplette Session-Log mit allen Owner-Antworten
        task-outputs/       1200 Dateien aus /tmp gerettet
      /home/comdare/ernte-20260811-nacht7/    die Vornacht

    SESSION-DOKUMENTE (Repo)
      20260812-GESAMTURTEIL-manuelle-synthese-aller-workflows-nacht-7c.md
      20260812-WF1-SYNTHESE-* + WF1-BERGUNG-verify-ABCD.md (Kopf verloren, aus dem Journal geborgen)
      20260812-WF2-SYNTHESE-* · WF3-SYNTHESE-* · WF4-SYNTHESE-* · WF5-SYNTHESE-*

---

## 8. WAS AUSDRÜCKLICH UNGEPRÜFT BLEIBT

* **Der Stunden-/Tage-Aufwand von S-1…S-21** steht an keiner Stelle. *„Termine unverändert"* ist
  eine **Owner-Setzung**, keine abgeleitete Aussage.
* **B-4, die Bau-Menge** (131.072 · 524.288 · 1.572.864 · 2.097.152) — **erst die Simulation
  rechnet**; jede Kapazitätszahl davor ist ein Kandidat.
* **Die 12-Perm-Kapazität** wurde nie durchgerechnet (die 20,7/34,4 h gelten fürs 4-Perm-Profil).
* **Das „und so weiter" der Exportformate** — vier Methoden belegt, json/html/svg/png sind
  belegte Nullen; einziger ungeprüfter Ort: die **Thesis-/Overleaf-Messwerte-Sektion**.
* **Bestandslog unter Zwei-Maschinen-Last** — nur In-Memory-Tests belegt.
* **E-1…E-4-Vollzug** und der **A-1-Vorlagetext** (vor jeder Backup-Ref-Aktion nachzulesen).
* **#84** (Vorbestands-Rot) erscheint nicht mehr als eigener roter Job — Status neu zu erheben.

---

## 9. DIE ERSTEN SCHRITTE NACH DEM COMPACT

1. **Neu gründen:** vier `/goal`-Dokumente + `ARBEITSWEISE-GESAMT-DOKTRIN.md` (v3.4).
   *GOAL lesen genügt nicht — die Arbeitsweise ist ein eigenes Dokument.*
2. **Ledger-Kopf:** KON33 → KON15 (19 Nachträge). Dann dieses Dokument, das **Gesamturteil**,
   **Wellenplan §16**.
3. **WF6 ernten** (`wf_37d98690-317`, Journal ist die Wahrheit) → als **KON34** landen.
4. **Referenz-Konsolidierung** (#9, KON19-00): die vier `/goal`-Dokumente als Haupt-Referenz
   gegen alle späteren Planungsdokumente.
5. **Dann bauen** — Priorität 1: `##25` DURCHSTICH. Und vor jedem Bau: **Bestands-Pflicht**
   (nach dem **Gegenstand** suchen, nicht nach dem Konsumenten) — diese Strecke hat vier eigene
   Messungen an genau diesem Fehler verloren.

---

*Erhoben 12.08.2026 mittags. Jede Zahl am Objekt gemessen oder mit Quelle; wo eine frühere
Aussage von mir widerlegt wurde, steht die Widerlegung dabei. Der Bestand an Irrtümern ist selbst
ein Datum — und er ist in diesen zwei Tagen kleiner geworden, weil der Owner 33 Fragen beantwortet
hat und vier Workflows sie am Objekt gegengeprüft haben.*
