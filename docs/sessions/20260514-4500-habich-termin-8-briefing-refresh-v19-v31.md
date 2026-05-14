# Habich-Termin~8 Briefing Refresh (V19--V31, 2026-05-14, 45:00)

**Vorgaenger:** `20260514-2030-v15-anker.md` (urspruengliches V15.3
Briefing) und `20260514-4400-v31-final-adapters-and-p27.md`
**Hauptthema:** Stand fuer Habich-Termin~8 nach 13 Sprints (V19--V31)
**Zweck:** Refresh der V15.3-Vorbereitung ohne deren Inhalt zu loeschen
(Memory-Direktive "niemals Doku loeschen")

---

## §1 Was sich seit V15 geaendert hat (1-Min-Zusammenfassung)

| Bereich | V15 (Termin~7-Vorbereitung) | V31 (jetzt fuer Termin~8) |
|---|---|---|
| Profile-Schema | nur axes/operations | + `<expected_workload>` (V19) + `<allocator_override>` (V29) |
| Workload-Routing | rein heuristisch (V11.2) | Profil-Override hat Vorrang (V19.3) |
| ResultAggregator | nur ops/sec | + `workload_used`-Spalte (V20.3) |
| Mess-Pipeline-Demo | keine | Sample-Daten + diagram\_generator E2E (V21--V22) |
| Layout cache-engine | flach (cache_engine/, search_engine/...) | konsolidiert in libs/ (V30, ohne `domain/`-Zwischenebene) |
| Adapter cache-engine | 0 (Skelette geplant) | 22 (11 SOTA + 10 Allokator + P01-Pilot) |
| ext-Repo-Aktivierung | manuell | per CMake-Flag `-DCOMDARE_HAVE_<X>=ON` |
| NOTICE | 12 SOTA + 10 Allokator | + Architekt-Direktive II 2026-05-14 |
| P27-Code | "kein public Code" | hp_soft.py erhalten + C++23-Port als `tools/p27_bundle_finder/` |
| thesis main.pdf | ~21 Seiten | 24 Seiten |
| ctest cache-engine | ~50 Tests | + 23 V31-Adapter-Smoke-Tests + 5 P27-Runtime + Codegen/Workload/Aggregator |

---

## §2 Was Habich konkret zu sehen bekommt

### Code (3 Repos)
- `comdare-cache-engine` (16176ee, gepusht): libs/-konsolidiert, 22 Adapter,
  P27-Bundle-Finder, NOTICE Architekt-Direktive II
- `comdare-prt-art` (1a36ab4, gepusht): hybride PrtArtSearchEngine
  (Vector/Map/Tuple-API), 5 P27-Runtime-Tests
- `Diplomarbeit/Code` (4a06797, gepusht): messung\_driver mit
  experiment\_config.xml + diagram\_generator (TikZ)

### Manuskript
- `thesis/main.pdf` (24 Seiten): Kapitel 02 mit zwei Profile-Tabellen
  (30 SOTA + 10 Allokator), Kapitel 04 mit V19--V31 Implementations-
  Geschichte, Kapitel 06 Sample-Diagramm
- `thesis/literatur.bib` mit 33 Paper-Eintraegen

### Doku
- `LICENSE_AUDIT_EXT.md` (V31-PRE Lizenz-Audit, alle 22 Repos)
- `NOTICE` mit Architekt-Direktive II
- `docs/sessions/20260514-44*` (V31-Final-Anker)
- 3 `PROJECT_LAYER_MAP.md` (eines pro Repo) mit V19--V31-Delta

---

## §3 Was bei Habich zu klaeren waere

| # | Frage | Status |
|---|---|---|
| 1 | Architekt-Direktive II OK? Adapter-Aktivierung fuer GPL-3-Repos
       (P04-CoCo-trie, P07-Wormhole) zulassen? | User-Direktive 2026-05-14
       hat das schon entschieden — Habich nur informieren |
| 2 | libs/-Layout ohne `domain/`-Zwischenebene Konvention OK? | Wurde
       ohne Habich-Konsultation entschieden — User-Direktive `Option C+` |
| 3 | P27-Code-Sammelsurium: Re-Implementation der Runtime aus Paper OK? | hp\_soft.py
       als Build-Time-Tool gewinnt; Runtime ist `HierarchicalBundlePrefetcher` Skelett —
       was fehlt fuer Habich-Akzeptanz? |
| 4 | HW-E2E (V21.2) Mess-Reihe: konkretes Setup besprechen | offen,
       User-Pending |
| 5 | Kuehn-Code-Download (P28 DaMoN 2023) | Email war offen — kommt
       was? |
| 6 | Termin-Hilfe ZIH/Cluster-Verbindung Compiler-Provisioning der
       ext-Repos | User-Pending Cluster-Migration laeuft parallel
       (anderer Agent) |

---

## §4 Was bewusst NICHT in V19--V31 enthalten ist

- **HW-E2E Mess-Reihe** (V21.2, Habich-Termin~8 Pflicht-Diskussion)
- **Original-Compiler-Setup pro ext-Repo** (Cluster-Aufgabe, User-Agent)
- **Habich-Direktive Termin~8** (ist dieser Termin)
- **Diplomarbeit-Hauptmessung** (nach Termin~8)

---

## §5 Stand der USER-pending Punkte

| # | Pending | Status |
|---|---|---|
| #74 | Email-Antworten P06, P28, P31, P32, P33 | offen, P27 ABGESCHLOSSEN |
| #77 | Cluster-Migration Fortigate-31G + GitLab | User-Agent parallel |
| #95 | Kuehn-Code-Download P28 DaMoN | offen |
| #109 | Debian-Pod als YCSB-Provider | INFRA, offen |
| #111 | Talos OS Java-Runtime-Provisioning | INFRA, offen |
| V21.2 | HW-E2E Mess-Reihe | Habich-Diskussion noetig |
| V21.5 | Habich-Termin~8 | DIESER TERMIN |

---

## §6 Pin-Kette zum Pruefen vor Termin

```
cache-engine main          16176ee  V31.F (22 Adapter Smoke-Tests)
prt-art development        1a36ab4  Pin cache-engine V31.F
Diplomarbeit main          4a06797  Pin cache-engine + prt-art V31.F
```

Alle 3 Repos sind auf GitHub gepusht (DNS war kurz aus, jetzt wieder OK).

---

## §7 Bezug zu V15.3-Briefing

V15.3 hat die thematischen Achsen (V8-V14) zusammengefasst. Dieses
Refresh-Dokument ergaenzt die zwoelf Sprints V19--V31 ohne V15.3 zu
ersetzen --- beide bleiben erhalten und werden Habich gemeinsam
vorgelegt (Memory-Direktive "niemals Doku loeschen").
