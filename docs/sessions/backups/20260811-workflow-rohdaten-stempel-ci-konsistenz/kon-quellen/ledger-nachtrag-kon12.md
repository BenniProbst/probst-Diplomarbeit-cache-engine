## NACHTRAG 11.08.2026 NACHTS — KON12: P-0 IST ENTLASTET, UND ZWEI ZAHLEN SIND NEU ERHOBEN

**Erste Anwendung des Arbeitsprinzips aus KON11-01** (*„konsolidieren · archivieren · in der
Zielform aktivieren"*) — und sie liefert sofort die größte Entlastung dieser Nacht.

---

### KON12-01 — 🟢 PHASE 0 IST KEIN BLOCKER. DER PLANER-KOPF IST GEBAUT UND VERDRAHTET.

**Die Behauptung, die fiel:** der Bauplan vom 19.07. führt in seiner eigenen adversarialen Kritik
einen Blocker — die Analyse habe am ce-Submodul geendet, im super-Repo liege eine **zweite**
`run_experiment_profile`-Funktion, und ein neuer Director daneben wäre die **dritte**
Enumerations-Engine. Der CI-Explore vom 11.08. hat den Blocker bestätigt und den
`ExperimentPlanDirector` als *„unangeschlossen im Submodul"* gemeldet. **Ich hatte das in KON11-01
übernommen. Beides ist am Objekt widerlegt.**

**Messung 11.08. nachts, ce `670483c0` (`wt-ce-warn-libs`) und super `wt-super-landung`:**

| Gegenstand | Befund |
|---|---|
| `ce libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp` | **2352 Zeilen**, existiert |
| Dateien, die `ExperimentPlanDirector` führen | **4** — `profile_run_facade.hpp` · `profile_run_facade.cpp` · der Header selbst · `apps/experiment_planner/main.cpp` |
| Ist es ein echter Aufruf? | **ja** — `profile_run_facade.cpp:1034-1041` **konstruiert** ihn: `auto director = []() -> planner::ExperimentPlanDirector { … return planner::ExperimentPlanDirector{std::move(*trio)}; … }` |
| Die Planer-Binary | `apps/experiment_planner/main.cpp:9`: *„Sie liest die Experiment-XML, **fährt den deterministischen ExperimentPlanDirector-Walk**"* |
| Gegenprobe (Zähl-Werkzeug trifft) | `BuildOrchestrator` = **11** Dateien |

**Und der Konflikt wurde beim Bau bereits aufgelöst.** Der Kopfkommentar des Directors sagt es
wörtlich:

> *„KEINE Aenderung der Callees, **KEIN dritter Enumerations-Walk** (der v32-Antrieb im super-Repo
> **bleibt unberuehrt** — Bauplan **Phase-0-Kritik-Blocker**). Der Perm-Walk ist EINMAL
> implementiert (`walk_perms_`), der Steps-Emitter ist der einzige art-abhaengige Teil."*

**Die Phase-0-Kritik ist im Header namentlich zitiert und beantwortet.** Wer sie heute noch als
offenen Blocker führt, liest den Plan vom 19.07. gegen einen Code, der ihn bereits eingearbeitet
hat.

#### Und die super-Seite ist ebenfalls geklärt

`super Code/02_messung_driver/v32_messreihe_antrieb.hpp` (**329 Zeilen**) ist **nicht** die
konkurrierende zweite Engine, sondern ausdrücklich das designierte Skelett. Kopfkommentar `:3-9`:

> *„**REAKTIVIERT ALS OFFIZIELLES SKELETT** des Planer-Phasen-Walks (Roadmap 20260719 PL-0; Ledger
> §29-Praezisierung (a) + §30-Stufen-Zuordnung Planer=Mess / CEB=System / Tier=Organ) […]
> **Phase 0 = Input-Umstellung unter WIEDERVERWENDUNG dieses Skeletts** (PhaseStrategyFor +
> execute_messreihe als Planer-Phasen-Walk-Skelett)."*

**Aufrufer, gemessen:** `execute_messreihe` erscheint in super-eigenem Code (ohne `external/`)
ausschließlich in **zwei Testdateien** — `Code/tests/unit/test_v32_orchestrator.cpp` und
`Code/02_messung_driver/tests/test_v32_messreihe_antrieb.cpp`. **Kein Produktionspfad.**
Gegenprobe: `run_profile_facade` = 2 Treffer, das Werkzeug sucht.

⇒ **Der Zustand ist nicht „zwei konkurrierende Engines", sondern „ein gebauter, verdrahteter
Director im ce und ein als Wiederverwendungs-Ziel markiertes Skelett im super, das nur Tests
rufen".** Das ist exakt die Lage, die KON11-01 als **unverdrahtet** beschreibt — und die dort
vorgeschriebene Behandlung ist Verdrahtung, nicht Neubau.

**Task #91 (PHASE 0 als Blocker) ist damit gegenstandslos** und wird geschlossen. Was bleibt, ist
kein Blocker, sondern ein **Verdrahtungs-Posten**: die super-Seite auf das ce-seitige Skelett
ziehen, wenn S-8 gebaut wird.

**Korrektur an KON11-01:** die Zeile *„`ExperimentPlanDirector` — existiert, unangeschlossen"* ist
**falsch** und hiermit zurückgezogen. Er ist angeschlossen. Die übrigen zehn Positionen der
Inventur bleiben unberührt; zwei davon sind unten neu vermessen.

---

### KON12-02 — S-14 NEU ERHOBEN: 7 VON 130, NICHT 6 VON 136

Der CI-Explore meldete für die Bump-Wache *„deckt 6 von 136 bump-pflichtigen Dateien, 0 davon unter
`axes/`"*. **Eigene Messung mit ausgeschriebener Zählweise**, ce `670483c0`:

    axes/-Header gesamt                          371   (find libs -path '*axes*' -name '*.hpp')
    davon mit 'algo_version'                     130   (grep -rl)
    Dateien mit 'AXIS_ALGO_VERSION'-Marker         7   (grep -rl ueber libs)
    Eintraege in tools/axis_version_lock/axis_version.lock   9

**Die Größenordnung des Explores hält, die Zahlen nicht.** Maßgeblich ist ab sofort **7 von 130**
mit dieser Zählweise; die Lock-Datei trägt **9** Einträge (die Differenz zu 7 ist nicht aufgeklärt
und gehört beim Ausrollen mitgemessen).

**Der Auftrag bleibt derselbe und ist kein Neubau:** die Wache existiert und ist CI-verdrahtet
(`ce/.gitlab-ci.yml:768-786`). S-14 ist ein **Ausroll-Auftrag** — Marker in die verbleibenden 123
Dateien, oder die Wache generisch über alle `algo_version`-Träger fahren.

---

### KON12-03 — S-17 BESTÄTIGT: DER LAGER-BAUM-WRITER HAT KEINEN AUFRUFER

    Dateien mit 'LagerBaumWriter' in ce/libs + ce/apps :  1   -- seine eigene
    Gegenprobe 'BuildOrchestrator'                     : 11   -- das Werkzeug sucht

**Der Befund des CI-Explores hält unverändert.** Eine gebaute Lager-Schicht ohne jeden Aufrufer —
und damit hat auch die **Messdaten-Kaskade** heute keinen Einsortier-Pfad.

**S-17 bleibt als Verdrahtungs-Posten stehen** und setzt O-9 voraus (NAS-Ordner oder MinIO-Bucket
als Cache-Wurzel), weil der genus-lose Planer sonst kein Ablageziel hat.

---

### KON12-04 — WAS DIESE DREI MESSUNGEN ÜBER DIE METHODE SAGEN

**Dreimal derselbe Ablauf, zweimal mit demselben Ergebnis:** ein Explore meldet „fehlt" oder
„unangeschlossen", die Gegenprobe am Objekt findet es gebaut. Bei P-0 sogar mitsamt der
ausdrücklichen Auflösung des behaupteten Konflikts **im Kopfkommentar der Datei selbst**.

> **Ein Baustein ohne Aufrufer ist von einem fehlenden Baustein nur durch eine gezielte Messung zu
> unterscheiden — nicht durch eine Suche.** Eine Suche nach dem Konsumenten findet nichts und meldet
> „fehlt"; erst die Suche nach dem **Gegenstand** findet ihn.

Das ist die operative Fassung von KON11-01: **vor jedem „das fehlt" steht die Frage „existiert es,
nur ungerufen?"** — und sie ist mit einem `grep -rl` plus Gegenprobe in Sekunden zu beantworten.

**Bilanz der drei Positionen:** eine **entlastet** (P-0), eine **präzisiert** (S-14), eine
**bestätigt** (S-17). Von siebzehn Bau-Teilen sind damit drei geprüft; die übrigen vierzehn gehen
denselben Weg, bevor an ihnen gebaut wird.
