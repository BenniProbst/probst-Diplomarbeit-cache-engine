# SESSION-ÜBERGABE 2026-07-11 — GitLab-first-Synchronisierung, Submodul-Endstand und read-only Vier-Linsen-Review

**Session-ID:** 20260711-SESSION-UEBERGABE-gitlab-sync-submodule-stand-und-readonly-review
**Agent:** Codex, Windows/PowerShell, vier parallele Review-Linsen
**Aktiver Auftrag:** Vier Repositories kanonisch von GitLab synchronisieren, alle beschreibbaren Spiegel
angleichen, anschließend den synchronisierten Stand ausschließlich lesend auf Code-, Mess-, CI- und
Thesis-Risiken prüfen.
**Abschlussgrund:** Synchronisierung, Gitlink-Nachzug und gezielte Verifikation sind abgeschlossen; die
bestätigten Defekte und Reproduzierbarkeitslücken sind als 30 eindeutige Review-TODOs erfasst.
**Autorität:** Bei späterem Widerspruch gewinnt der
[Ziele-/Offene-Punkte-Ledger](../DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md), insbesondere dessen jüngster
§12-Eintrag und §13.12.

> **PFLICHT-EINSTIEG NÄCHSTER ZYKLUS:** Zuerst Ledger §12 und §13.12 sowie diese Session lesen. Danach den
> Status aller vier Repositories, die konkreten Gitlinks und beide Superprojekt-Remotes erneut prüfen.
> Review-TODOs nicht allein aufgrund dieser Session als erledigt markieren: Abnahme erfordert die jeweils
> genannten Tests und einen separaten Fix-Commit.

---

## 0. TL;DR

1. Das Superprojekt, cache-engine, prt-art und die Overleaf-/LaTeX-Thesis sind GitLab-first synchronisiert.
   Wo ein beschreibbarer GitHub-Spiegel existiert, stimmen main und development ebenfalls überein.
2. Im Superprojekt verfolgt jedes Top-Level-Submodul explizit development und verwendet update=merge.
   Der cache-engine-Gitlink wurde auf **22ddf94c** aktualisiert; PRT und Thesis waren bereits korrekt gepinnt.
3. Finaler synchronisierter Stand: Super **cc4582a**, cache-engine **22ddf94c**, prt-art **faa4e76e**,
   Thesis **838bf3fc**; der verschachtelte Q01-Gitlink bleibt bewusst **d655418b**.
4. Alle vier Repositories bestanden git fsck --connectivity-only. Die msvc-debug-Konfiguration und drei
   gezielte Tests bestanden. Der Thesis-Komplettbuild wurde nach 54 Sekunden vor Beginn des EN-Builds
   abgebrochen und ist ausdrücklich **kein** Erfolgsbeleg.
5. Das read-only Review bestätigt **30 offene TODOs**: 3 kritisch, 19 hoch, 7 mittel und 1 niedrig.
   Die schwersten aktiven Risiken betreffen Messgültigkeit, ignorierte Tier-Semantik und einen
   LeafOnlyCounter-Use-after-free.
6. In dieser Review-Phase wurde **kein Defekt behoben**. Die einzigen Projektänderungen der Sync-Phase sind
   der dokumentierte Superprojekt-Commit **cc4582a** und die dadurch festgelegten Gitlinks/Submodulregeln.

## 1. AUFTRAG, SCOPE, METHODIK UND TABUS

### 1.1 Scope

Geprüft wurden exakt diese vier Stände:

| Repository | Rolle | Audit-SHA |
|---|---|---|
| probst-diplomarbeit-cache-engine | Superprojekt, Mess-/Auswertungscode, Doku | **cc4582a823e337971d5fa62e8db9a48effecf407** |
| comdare-cache-engine | Tier-Build, Workload-, Mess- und Selektionspfad | **22ddf94cf46e4b717591c619d5aec4c6bdf3db7e** |
| comdare-prt-art | Prüfling, Concurrency und Telemetrie | **faa4e76ee46041257258405e91c88759ed97d7a5** |
| 20260931-overleaf-diplomarbeit | bilinguales LaTeX-Manuskript | **838bf3fc2e2910ad1b2eea138f57cc8c9b41d449** |

Die vier Review-Linsen waren:

1. **C++/Concurrency:** Synchronisationsverträge, Objekt-Lifetime, Datenrennen, Exception-Verträge.
2. **Messpipeline/Statistik/Artefakte:** Workload-Semantik, Gültigkeitsgates, Einheiten, Rangbildung,
   statistische Vergleichbarkeit und atomare Veröffentlichung.
3. **Build/CI/Integration:** reale CMake-Targets, CLI-Gates, Gitlink-Treue, reproduzierbare CI-Definition und
   Preset-Abdeckung.
4. **Thesis/LaTeX/Reproduzierbarkeit:** harte Buildfehler, DE/EN-Gleichwertigkeit, Bibliographie-Gates,
   Messwert-Provenienz und atomare Tabellengenerierung.

### 1.2 Methodik

- Vor jeder Mutation wurden Branch, HEAD, Upstream, git status und rekursiver Submodulstatus geprüft.
- GitLab war die kanonische erste Push-Reihenfolge; GitHub wurde erst danach als Spiegel aktualisiert.
- Branch-Invariante: main muss überall Vorfahr von development sein.
- Kein Rebase, Reset, Stash, Force-Push oder History-Rewrite.
- Top-Level-Gitlinks und der verschachtelte Q01-Pin wurden getrennt behandelt.
- Jeder Befund wurde am finalen SHA erneut gegen den konkreten Pfad und Zeilenbereich gelesen.
- Schweregrade bezeichnen die Auswirkung, nicht die Behebungsreihenfolge:
  - **aktiver Defekt:** aktueller Pfad kann falsches Ergebnis, UB, Datenverlust oder falsches Grün erzeugen;
  - **latentes Risiko:** Vertrag ist gebrochen, wird im aktuellen belegten Produktionspfad aber noch nicht
    vollständig konsumiert;
  - **Reproduzierbarkeitslücke:** Ergebnis kann nicht deterministisch oder vollständig auf Eingaben und
    Toolstände zurückgeführt werden.

### 1.3 Ausdrückliche Nicht-Ziele

- Keine Review-Fixes in dieser Session.
- Keine Änderung der drei External-Default-Branches.
- Keine Cluster-, HPC-, NAS-, Runner- oder Overleaf-Manöver.
- Keine Credentials, Tokens, Passwörter oder privaten Zertifikatsdetails in diesem Dokument.
- Keine pauschale Erfolgsmarke für einen abgebrochenen oder nur teilweise ausgeführten Test.

## 2. VORZUSTAND UND SYNCHRONISIERUNG

### 2.1 Vor dem Vier-Repo-Sync

| Repository | Lokaler Zustand | Remote-Zustand | Delta |
|---|---|---|---|
| Super | main **de653821** | GitLab/GitHub main+development **1f514e0** | lokales main hinter beiden Remotes |
| cache-engine | detached **0b790034** | GitLab/GitHub main+development **22ddf94c** | lokaler Gitlink/Checkout veraltet |
| prt-art | detached **faa4e76e** | GitLab/GitHub main+development **faa4e76e** | Inhalt aktuell, Branchbindung fehlte |
| Thesis | detached **838bf3fc** | main **838bf3fc**, development **35b7d54f** | development musste fast-forwarden |

### 2.2 Dirtiness-Guard vor der Dokumentationsänderung

Am 2026-07-11 um 13:59 CEST wurde unmittelbar vor dem ersten Edit erneut geprüft:

| Repository | Branch | HEAD | Upstream | Worktree |
|---|---|---|---|---|
| Super | development | **cc4582a823e3** | origin/development | sauber |
| cache-engine | development | **22ddf94cf46e** | origin/development | sauber |
| prt-art | development | **faa4e76ee460** | origin/development | sauber |
| Thesis | development | **838bf3fc2e29** | origin/development | sauber |

Der rekursive Submodulstatus hatte kein Plus-, Minus- oder U-Präfix. Es gab daher keine fremden Änderungen,
keine Notwendigkeit für einen separaten Worktree und keinen überlappenden Edit-Konflikt.

Eine **separate**, nicht eingebundene Kopie unter Research/comdare-prt-art enthielt bereits vorhandene
IDE-Dateien und ein ungetracktes external-Verzeichnis. Sie wurde nicht verändert und nicht mit dem
Superprojekt vermischt.

### 2.3 Ausgeführte Synchronisation

- cache-engine:
  - lokales main fast-forward auf **22ddf94c**;
  - development angelegt beziehungsweise verfolgt und auf denselben SHA gebracht;
  - GitLab main/development zuerst, danach GitHub main/development verifiziert.
- prt-art:
  - lokales development an **faa4e76e** gebunden;
  - GitLab und GitHub main/development bereits inhaltsgleich; Ancestry erneut geprüft.
- Thesis:
  - development von **35b7d54f** auf **838bf3fc** fast-forward;
  - GitLab development aktualisiert; kein zweiter Remote vorhanden.
- Superprojekt:
  - lokales main auf **1f514e0** fast-forward;
  - development aus origin/development;
  - .gitmodules für alle drei Top-Level-Submodule um branch=development und update=merge ergänzt;
  - Code/README.md um die explizite Init-/Remote-Merge-Prozedur ergänzt;
  - cache-engine-Gitlink von **c022ce05** auf **22ddf94c** aktualisiert;
  - Commit **cc4582a823e337971d5fa62e8db9a48effecf407**
    „chore(submodules): track development and refresh integrations“;
  - GitLab development, dann GitLab main, anschließend GitHub development/main gepusht.

### 2.4 Tags

- cache-engine: GitHub-only-Tag **v41-isa-platform-cross-constraint-d29fdef** nach GitLab übertragen.
- cache-engine: 24 GitLab-only-Tags nach GitHub übertragen, darunter die post-/pre-v5-i2/i6-ABI-Marker,
  die V41-F2-Serie und **v41-p2-pre-adhoc-organ-migration**.
- Superprojekt: **pre-c-revert-l1-l2** nach GitHub übertragen.
- prt-art: fünf Tags auf beiden Remotes bereits identisch.

### 2.5 Finaler Remote-/Branch-Endstand

| Repository | GitLab main | GitLab development | GitHub main | GitHub development |
|---|---|---|---|---|
| Super | **cc4582a** | **cc4582a** | **cc4582a** | **cc4582a** |
| cache-engine | **22ddf94c** | **22ddf94c** | **22ddf94c** | **22ddf94c** |
| prt-art | **faa4e76e** | **faa4e76e** | **faa4e76e** | **faa4e76e** |
| Thesis | **838bf3fc** | **838bf3fc** | — | — |

Alle acht vorhandenen main→development-Ancestry-Prüfungen lieferten Exit 0.

Der serverseitige Default-Branch war vor dem nachgelagerten Nutzerauftrag sowohl auf GitLab als auch auf
GitHub noch **main**. Seine Umstellung auf development erfolgt bewusst erst nach Commit und Push dieser
Session und wird separat über die jeweilige Server-API verifiziert. Die Externals bleiben unverändert.

## 3. SUBMODUL-ENDSTAND

| Pfad | Gitlink | Regel |
|---|---|---|
| Code/external/comdare-cache-engine | **22ddf94cf46e4b717591c619d5aec4c6bdf3db7e** | branch=development, update=merge |
| Code/external/comdare-prt-art | **faa4e76ee46041257258405e91c88759ed97d7a5** | branch=development, update=merge |
| thesis/diplomarbeit | **838bf3fc2e2910ad1b2eea138f57cc8c9b41d449** | branch=development, update=merge |
| cache-engine/ext/queuing/Q01-concurrentqueue | **d655418bb644b7f85159d94c591d7d983949fb81** | transitiver, vom Parent gepinnter Gitlink |

Die dokumentierte Update-Prozedur lautet sinngemäß:

1. rekursiv initialisieren;
2. nur die drei Top-Level-Submodule mit remote+merge aktualisieren;
3. transitive Third-Party-Gitlinks wie Q01 nicht eigenmächtig auf einen Branch-Tip verschieben;
4. vor jedem Gitlink-Commit main⊆development und beide beschreibbaren Remotes verifizieren.

## 4. AUSGEFÜHRTE CHECKS UND AUDITUMGEBUNG

### 4.1 Git- und Build-Verifikation

| Check | Ergebnis |
|---|---|
| git fsck --connectivity-only, alle vier Repositories | **PASS** |
| rekursiver Submodulstatus | **PASS**, keine Abweichungspräfixe |
| CMake configure preset msvc-debug, Permutations deaktiviert | **PASS** |
| test_messreihen_workload | **1/1 PASS** |
| test_best_binary_selector_parse_rank | **1/1 PASS** |
| test_cmd2_container_attribution | **1/1 PASS** |

Der initiale Root-Target-Aufruf für test_best_binary_selector_parse_rank traf **MSB1009**. Das ist kein
Registrierungsdefekt: Der direkte verschachtelte VCXPROJ-Build und der anschließende CTest-Lauf bestanden.
test_cmd2_container_attribution wurde aus demselben verschachtelten Buildbaum direkt gebaut und bestand.

Die Configure-Warnungen zu sechs fehlenden Skeleton-Modulen und noch nicht gebauten Codegen-Werkzeugen sind
bekannte Soft-Warnungen; sie wurden nicht als neue harte Defekte eingereiht.

### 4.2 Thesis-Build

pdflatex, bibtex, latexmk und chktex waren installiert. Der vorhandene build_all.ps1-Aufruf überschritt das
harte 50-Sekunden-Prüffenster und wurde nach 54,1 Sekunden beendet, bevor der EN-Build begann. Deshalb gilt:

- **kein** vollständiger DE/EN-Erfolgsbeleg;
- 491 Warning- und 486 Undefined-Matches im abgebrochenen DE-Log sind wegen des unvollständigen Mehrpasslaufs
  **kein** belastbarer finaler Fehlerbestand;
- die vorhandene .blg hatte 0 Treffer für Warning--, Repeated entry oder error;
- kein TeX-Kindprozess blieb zurück;
- der Thesis-Worktree war nach der Prüfung sauber.

### 4.3 Toolreparatur, ausdrücklich kein Codefinding

Die Git-/Netzwerk-Auditumgebung wurde vor dem Sync stabilisiert:

- 52 verwaiste git.exe-Prozesse beendet;
- lokale Benutzerdatei C:\Users\benja\.curlrc um ssl-revoke-best-effort ergänzt;
- Tool-Selbsttests anschließend grün.

Diese Maßnahmen liegen außerhalb des Repositories, enthalten keine Projektaussage und sind **keine**
Reviewbefunde.

## 5. RISIKO- UND PRIORITÄTSMATRIX

Die IDs **REV-CXX-***, **REV-DATA-***, **REV-CI-*** und **REV-TEX-*** sind bewusst session-lokal und global
eindeutig. Sie beanspruchen keine freien Ledger-Nummern #280+ und überschreiben keine bestehenden
Projekt-TODOs.

| ID | Severity | Einordnung | Kurzbefund | Priorität |
|---|---|---|---|---|
| REV-CXX-01 | kritisch | aktiver Concurrency-Defekt | LeafOnlyCounter reset/record Use-after-free | P0 |
| REV-CXX-02 | hoch | latenter Vertragsdefekt | OLC-Mehrschreiber kann gerade Version publizieren | P1 |
| REV-CXX-03 | hoch | aktiver Datenrace | nicht-atomare Lookup-Hit/Miss-Zähler | P1 |
| REV-CXX-04 | hoch | aktiver Lifetime-/API-Defekt | Pointer/Iteratoren überleben Lock nicht | P1 |
| REV-CXX-05 | hoch | latenter Fatal-Error-Pfad | allokierende Operation ist noexcept | P1 |
| REV-DATA-01 | kritisch | aktiver Messgültigkeitsdefekt | fehlende Scan-Fähigkeit bleibt valide | P0 |
| REV-DATA-02 | kritisch | aktiver Messgültigkeitsdefekt | Insert/Erase/Lookup-Semantik ungeprüft | P0 |
| REV-DATA-03 | hoch | aktiver Konfigurationsdefekt | XML-Form kann still auf Workload C fallen | P1 |
| REV-DATA-04 | hoch | aktiver Parser-/Rankingdefekt | NaN/Inf/partial stod werden akzeptiert | P1 |
| REV-DATA-05 | hoch | aktiver Pfad-/Datenverlustdefekt | --name kann out_dir verlassen | P0 |
| REV-DATA-06 | hoch | aktiver Artefaktkonsistenzdefekt | DLL/Sidecar/Manifest nicht atomar | P1 |
| REV-DATA-07 | hoch | aktive Methodiklücke | Selector mischt unvollständige Messzellen | P0 |
| REV-DATA-08 | hoch | aktiver Einheitenfehler | Zyklen werden als Nanosekunden geplottet | P0 |
| REV-DATA-09 | hoch | aktive Methodiklücke | Legacy-Mikrobench konfundiert Achsen | P1 |
| REV-DATA-10 | hoch | aktiver Statusdefekt | ExperimentDriver meldet bedingungslos Erfolg | P1 |
| REV-DATA-11 | hoch | aktive Vergleichbarkeitslücke | Baseline/Kandidat dürfen andere Workloads nutzen | P1 |
| REV-DATA-12 | mittel | aktive Statistikinkonsistenz | Median für gerade n divergiert | P2 |
| REV-DATA-13 | mittel | Statistik-/Reproduzierbarkeitslücke | neues Welch-Sample, keine Multiplikitätskorrektur | P2 |
| REV-DATA-14 | mittel | aktiver I/O-Integritätsdefekt | Record-Zähler wächst trotz Streamfehler | P2 |
| REV-CI-01 | hoch | aktiver CI-Konfigurationsdefekt | nicht existierendes Messung-Target | P0 |
| REV-CI-02 | mittel | CI-Abdeckungslücke | Bibliotheken statt behaupteter CLIs gebaut | P2 |
| REV-CI-03 | hoch | Integrations-/Reproduzierbarkeitslücke | Downstream main statt Gitlink/development | P1 |
| REV-CI-04 | mittel | latentes zustandsabhängiges Risiko | update=merge im CI-Worktree | P2 |
| REV-CI-05 | mittel | CI-Reproduzierbarkeitslücke | Template-Ref development ist mutable | P2 |
| REV-CI-06 | niedrig | Abdeckungs-/Dokulücke | Build- und Test-Presets asymmetrisch | P3 |
| REV-TEX-01 | hoch | aktiver Buildstatusdefekt | stale PDF kann als OK gelten | P0 |
| REV-TEX-02 | hoch | aktive CI-Abdeckungslücke | Pipeline kann ohne TeX-Gate grün sein | P0 |
| REV-TEX-03 | hoch | aktive Sprachabdeckungslücke | EN-Abgabevariante nicht gegatet | P1 |
| REV-TEX-04 | hoch | Reproduzierbarkeitslücke | Messwert-Provenienz nicht eingefroren | P1 |
| REV-TEX-05 | mittel | aktiver Artefaktkonsistenzdefekt | DE/EN-Tabellen werden teilweise überschrieben | P2 |

**Summen:** 3 kritisch · 19 hoch · 7 mittel · 1 niedrig = **30 offene Review-TODOs**.

## 6. DETAILBEFUNDE UND TODO-VERTRÄGE

### 6.1 C++ und Concurrency

#### REV-CXX-01 — LeafOnlyCounter reset/record Use-after-free

**Status:** offen · **Severity:** kritisch · **Einordnung:** bestätigter aktiver Concurrency-Defekt
**Beleg:** Code/external/comdare-prt-art/prt_art/include/prt_art/telemetry/leaf_only_counter.hpp:92-100,
136-159. ensure_slot gibt eine Referenz auf ein unique_ptr-Ziel zurück, nachdem der Map-Lock freigegeben wurde;
reset hält anschließend den exklusiven Lock und löscht alle Ziele.
**Mechanismus/Impact:** Ein paralleles reset kann zwischen Rückgabe aus ensure_slot und counter.fetch_add
liegen. record_access dereferenziert dann freigegebenen Speicher: Undefined Behavior, möglicher Heap-Abort oder
stille Telemetrie-Korruption. Relaxed-Memory-Order ist nicht die Ursache; die Objekt-Lifetime ist es.
**Abhilfe:** Slot-Lifetime bis nach fetch_add schützen. Geeignete Lösungen sind ein Lock über Lookup und
Inkrement, stabile Slots ohne Löschung oder shared_ptr-basierte Lifetime; Entscheidung anhand Mess-Overhead
treffen.
**Abhängigkeiten:** vor jeder weiteren TSan-Härtung und vor parallelen Messläufen; unabhängig von OLC.
**Akzeptanzkriterien:** Kein Zugriff auf einen gelöschten Slot; reset besitzt klar definierte Semantik gegenüber
laufenden Records; bestehende Gesamtzähler bleiben korrekt.
**Tests:** TSan-Stresstest mit mehreren record_access-Threads und wiederholtem reset; hohe Iterationszahl,
repeat-until-fail; zusätzlich exakte Nach-reset-Zähler unter kontrollierter Barriere.

#### REV-CXX-02 — OLC-Mehrschreiber verletzt den Odd/Even-Vertrag

**Status:** offen · **Severity:** hoch · **Einordnung:** bestätigter latenter Vertragsdefekt
**Beleg:** Code/external/comdare-prt-art/prt_art/include/prt_art/concurrency/olc_with_reserved_blocks.hpp:24-43,
64-80. begin_write verwendet fetch_add(1); ein zweiter gleichzeitiger Writer ändert die Version von ungerade
auf gerade. validate akzeptiert eine unveränderte gerade Version. Writer-Guards werden in
prt_art_search_engine.hpp:123-125,406-425 und 515-549 bereits vor dem tatsächlichen rw_lock konstruiert.
**Mechanismus/Impact:** Während mindestens ein Writer aktiv ist, kann der Marker scheinbar „kein Write“
anzeigen. Ein optimistischer Leser könnte inkonsistente Daten akzeptieren. Im finalen Stand wurden außerhalb
der Tests keine produktiven read_version/validate-Konsumenten gefunden; deshalb latent, nicht als aktuell
belegte Datenkorruption eingestuft.
**Abhilfe:** CAS-Schleife von gerader Version auf nächste ungerade Version; Writer wartet/retryt bei ungerader
Version. end_write publiziert die nächste gerade Generation mit Release-Semantik. Alternativ OLC explizit als
Single-Writer-Vertrag deklarieren und erzwingen.
**Abhängigkeiten:** API-Vertrag vor einer Aktivierung optimistischer Reads festlegen.
**Akzeptanzkriterien:** Solange irgendein Writer aktiv ist, ist keine valide gerade Version sichtbar; Versionen
sind monoton und Wraparound-Verhalten dokumentiert.
**Tests:** deterministischer Zwei-Writer-/Ein-Leser-Interleavingtest, Stress-/TSan-Lauf und Assertions auf
Odd/Even-Invariante sowie monotone Generationen.

#### REV-CXX-03 — Datenrennen in Lookup-Hit/Miss-Zählern

**Status:** offen · **Severity:** hoch · **Einordnung:** bestätigter aktiver Datenrace
**Beleg:** Code/external/comdare-prt-art/prt_art/include/prt_art/identity/prt_art_search_engine.hpp:340-349,
525-529,567-574. Mehrere lookup-Leser halten nur shared_lock und inkrementieren dieselben nicht-atomaren,
mutable uint64_t-Felder.
**Mechanismus/Impact:** Parallel erlaubte Leser schreiben gleichzeitig: C++-Datenrennen, Undefined Behavior
und verlorene Treffer-/Miss-Zählungen. Die Getter lesen ebenfalls ohne eigenen Lock.
**Abhilfe:** relaxed atomics für reine Statistik oder exklusiv gelockte Zähler; Getter konsistent laden.
Statistikreset, falls vorhanden/ergänzt, muss denselben Vertrag verwenden.
**Abhängigkeiten:** mit REV-CXX-04 gemeinsam API-/Lock-Grenzen dokumentieren.
**Akzeptanzkriterien:** TSan-frei; Summe aus Hits und Misses entspricht exakt der Anzahl abgeschlossener
Lookups eines kontrollierten Tests.
**Tests:** Multithread-Lookupmix mit bekannten Treffern/Misses, TSan, hoher Wiederholungszahl.

#### REV-CXX-04 — Unsichere Pointer-, Referenz- und Iterator-Lifetime

**Status:** offen · **Severity:** hoch · **Einordnung:** bestätigter aktiver Lifetime-/API-Defekt
**Beleg:** prt_art_search_engine.hpp:92-120,238-247 für die vector-Fassade sowie :327-371,461-469 für die
Map-Fassade. data, operator[], begin/end, Reverse-Iteratoren und Bounds geben Zugriffe ohne fortbestehenden
Lock zurück; lower_bound/upper_bound/equal_range lassen den Lock vor Nutzung des Iterators los. Auch
size/empty/capacity lesen bei parallelen Schreibern ungeschützt.
**Mechanismus/Impact:** Writer können vector-Reallokation oder Map-Erase auslösen, nachdem der Leser einen
Pointer/Iterator erhalten hat. Ergebnis: Iteratorinvalidierung, Use-after-free oder Datenrennen.
**Abhilfe:** gelockte View-/Callback-API, Snapshot-Rückgabe oder explizites externes ReadGuard-Objekt, das die
Lifetime des Locks umfasst. Ungelockte std-container-ähnliche API nicht als thread-safe ausgeben.
**Abhängigkeiten:** öffentliche Kompatibilitätsentscheidung; zusammen mit REV-CXX-03 testen.
**Akzeptanzkriterien:** Kein öffentlicher Zugriff überlebt seinen Schutzmechanismus; scalar reads sind
synchronisiert; API-Dokumentation benennt Thread-Safety eindeutig.
**Tests:** konkurrierendes Insert/Erase/Reallocation gegen Lesecallbacks/Snapshots unter ASan+TSan; negative
Compile-Tests für entfernte unsichere Rückgaben, falls die API bewusst eingeschränkt wird.

#### REV-CXX-05 — Allokierende record-Operation ist noexcept

**Status:** offen · **Severity:** hoch · **Einordnung:** bestätigter latenter Fatal-Error-Pfad
**Beleg:** Code/external/comdare-prt-art/prt_art/include/prt_art/measurement/density_tracker.hpp:21-25.
unordered_map::operator[] kann allokieren und werfen, record ist aber noexcept. Aufrufer erwarten in
prt_art_search_engine.hpp:123-130,285-290,546-564 teilweise bad_alloc-Behandlung.
**Mechanismus/Impact:** Bei Allokationsfehler wird std::terminate ausgelöst; die umgebende catch-Klausel kann
nicht greifen. Ein recoverbarer status_out_of_memory-Pfad wird zum Prozessabbruch.
**Abhilfe:** noexcept entfernen und Exception bis zum vorhandenen Statuspfad propagieren oder innerhalb record
fangen und einen expliziten Status zurückgeben.
**Abhängigkeiten:** Error-Policy der Telemetrie festlegen: Messwertverlust versus harte Operationstransaktion.
**Akzeptanzkriterien:** Fault-Injection führt nicht zu terminate; Aufrufer erhalten den vereinbarten Fehler und
es bleibt kein halbfertiger Counterzustand.
**Tests:** Throwing-/Failing-Allocator-Test für den ersten Map-Insert und Rehash; Prozess darf nicht abbrechen.

### 6.2 Messpipeline, Statistik und Artefakte

#### REV-DATA-01 — Fehlende Scan-Fähigkeit bleibt valide und kann YCSB-E gewinnen

**Status:** offen · **Severity:** kritisch · **Einordnung:** bestätigter aktiver Messgültigkeitsdefekt
**Beleg:** cache-engine workload_orchestrator.hpp:65-73,127-143 überspringt Scan bei scan==nullptr;
experiment_tree/perm_runner.hpp:249-252,268-294 setzt two_phase_valid ausschließlich aus Rollback-Exaktheit.
algorithm_profiles/load_profiles/ycsb_e.xml:9-17 definiert 95 Prozent Scan und 5 Prozent Insert.
**Mechanismus/Impact:** Ein nicht scanbares Tier misst in YCSB-E nur die schnellen fünf Prozent Inserts,
bleibt two_phase_valid und kann im Best-Binary-Selector ein scanbares, vollständig gemessenes Tier schlagen.
op_count bleibt zudem die ursprüngliche Operationszahl, timed_ops enthält weniger Samples.
**Abhilfe:** benötigte Capability-Menge vor dem Lauf aus dem Workload ableiten; fehlende Capability macht die
gesamte Zelle ungültig. Keine partielle Leistungszeile veröffentlichen.
**Abhängigkeiten:** vor REV-DATA-07 und vor jedem #156-/YCSB-E-Lauf.
**Akzeptanzkriterien:** Nicht-scanbares Tier + YCSB-E erzeugt keine valide Rankingzeile; scanbares Tier misst
exakt die generierte Scananzahl; op_count und timed_ops sind konsistent.
**Tests:** Fake-Tier ohne IScannableTier, Fake-Tier mit Scan; deterministische 95/5-Sequenz; Selector-E2E darf
den unvollständigen Kandidaten nicht sehen.

#### REV-DATA-02 — Insert-, Erase- und Lookup-Semantik wird nicht validiert

**Status:** offen · **Severity:** kritisch · **Einordnung:** bestätigter aktiver Messgültigkeitsdefekt
**Beleg:** workload_orchestrator.hpp:75-113 und :145-157 verwirft Insert-/Erase-Rückgaben, prüft Lookup-Hit und
Wert nicht gegen eine Erwartung und akzeptiert RMW auf Miss. perm_runner.hpp:261-275 ignoriert zusätzlich den
Erfolg jedes Load-Inserts.
**Mechanismus/Impact:** Ein Tier, das Daten ablehnt, falsche Werte liefert oder Erase nicht ausführt, kann
two_phase_valid bleiben und wegen weniger realer Arbeit schneller erscheinen. Rollback-Exaktheit beweist
nicht die fachliche Korrektheit des Workloads.
**Abhilfe:** deterministisches Referenzmodell oder erwartete Zustands-/Kardinalitätsprüfung pro Operation;
Loadfehler und Ergebnisabweichung entwerten den Lauf. Performancewerte nur nach bestandenem Korrektheitsgate.
**Abhängigkeiten:** gemeinsam mit REV-DATA-01 vor Selektor und Vollmessung.
**Akzeptanzkriterien:** Jede absichtlich falsche Fake-Tier-Variante wird zuverlässig invalidiert; korrektes Tier
bleibt valide; Fehlergrund wird im Messdatensatz/provenance sichtbar.
**Tests:** Fake-Tiers für abgelehnten Insert, falschen Lookup-Wert, falschen Hit/Miss, wirkungsloses Erase und
unvollständige Loadphase; Referenzmodell-E2E über A-F.

#### REV-DATA-03 — XML-Workload-Zusatzparser akzeptiert weniger Formen als der Hauptparser

**Status:** offen · **Severity:** hoch · **Einordnung:** bestätigter latenter Konfigurationsdefekt
**Beleg:** Code/02_messung_driver/messreihen_workload.hpp:49-72 betrachtet nur direkte
root.children_named("messreihe"). Der kanonische XmlConfigParser akzeptiert in
xml_config_parser.cpp:184-205 sowohl einen Root messreihe als auch rekursiv eingebettete Knoten.
Code/02_messung_driver/main.cpp:191-205,612-624 verbindet beide Resultate über die ID.
**Mechanismus/Impact:** Eine für den Hauptparser gültige Form kann im Zusatzparser keine Workload-Zuordnung
erzeugen. Der Treiber behält dann still seinen bisherigen Default, typischerweise Workload C.
**Abhilfe:** dieselbe rekursive DOM-Traversierung oder das workload-Feld direkt im typisierten Parser
exponieren; unbekannt/fehlend explizit melden, wenn die Messreihe eine Workload-Achse voraussetzt.
**Abhängigkeiten:** Parser-Single-Source-Entscheidung; vor neuen E4-XML-Akten.
**Akzeptanzkriterien:** Root-, Container- und rekursive Form liefern dieselbe ID→Workload-Map; kein stiller
Fallback bei syntaktisch gültigem, semantisch nicht zuordenbarem Tag.
**Tests:** Tabellengetriebene XML-Fixtures für alle Formen sowie unbekannte/duplizierte IDs.

#### REV-DATA-04 — NaN, Infinity und teilweise gelesene Zahlen gelangen ins Ranking

**Status:** offen · **Severity:** hoch · **Einordnung:** bestätigter aktiver Parser-/Rankingdefekt
**Beleg:** best_binary_selector.cpp:28-32 verwendet std::stod ohne Endposition oder isfinite-Prüfung;
:68-106 übernimmt das Ergebnis, filtert nur v<=0 und sortiert direkt.
**Mechanismus/Impact:** "12junk" wird als 12 akzeptiert; NaN passiert den v<=0-Filter. Vergleiche mit NaN
verletzen die für sort benötigte strikte schwache Ordnung und können Ranking/Median nichtdeterministisch machen.
Infinity kann ebenfalls eine formell valide Zelle erzeugen.
**Abhilfe:** from_chars oder stod mit Endindex, vollständigen Tokenverbrauch und std::isfinite verlangen;
ungültige Messzeile mit Diagnose ablehnen.
**Abhängigkeiten:** vor REV-DATA-07/12.
**Akzeptanzkriterien:** nan, inf, -inf, 12junk und leere Pflichtwerte werden verworfen; gültige Dezimal- und
Exponentialwerte bleiben portabel.
**Tests:** Unit-Matrix mit Locale-unabhängigen Grenzfällen und Rankingtest ohne NaN.

#### REV-DATA-05 — --name erlaubt Pfad-Traversal aus dem Artefaktverzeichnis

**Status:** offen · **Severity:** hoch · **Einordnung:** bestätigter aktiver Pfad-/Datenverlustdefekt
**Beleg:** best_binary_selector_main.cpp:37-77/104-118 übernimmt art_name ungeprüft.
best_binary_selector.cpp:164-185 hängt artifact_name direkt an out_dir für DLL, version und Manifest.
**Mechanismus/Impact:** Relative Komponenten wie ../, Verzeichnistrenner oder ein absoluter Pfad können den
vorgesehenen out_dir verlassen und existierende Dateien mit overwrite_existing überschreiben.
**Abhilfe:** ausschließlich einfachen Dateistamm aus einer engen Allowlist akzeptieren; absolute Pfade,
Separatoren, dot/dotdot und reservierte Windows-Namen ablehnen; final normalisierten Zielpfad auf
Containment unter out_dir prüfen.
**Abhängigkeiten:** zusammen mit REV-DATA-06 implementieren.
**Akzeptanzkriterien:** Kein Ziel liegt außerhalb des kanonischen out_dir; bestehende fremde Datei bleibt bei
bösartigen Namen unverändert.
**Tests:** Windows- und POSIX-Traversalformen, absolute Pfade, UNC-/Drive-Formen, Separatoren, dot/dotdot,
reservierte Namen und gültige Unicode-/ASCII-Stämme.

#### REV-DATA-06 — DLL, Sidecar und Manifest werden nicht atomar publiziert

**Status:** offen · **Severity:** hoch · **Einordnung:** bestätigter aktiver Artefaktkonsistenzdefekt
**Beleg:** best_binary_selector.cpp:141-181 überschreibt zuerst DLL und Sidecar; Sidecar-Open/-Write wird nicht
ausgewertet. Erst :184-209 schreibt und prüft das Manifest.
**Mechanismus/Impact:** Fehler nach der DLL-Kopie lassen eine neue DLL mit altem/leerem Sidecar oder altem
Manifest zurück. Konsumenten können einen Mischstand sehen; die Methode meldet bei Sidecarfehler sogar Erfolg.
**Abhilfe:** komplettes Artefaktset in einem temporären sibling-Verzeichnis schreiben, flush/close/hash prüfen
und erst dann atomar umbenennen; vorherige Version bis zum Commit erhalten.
**Abhängigkeiten:** Namenshärtung REV-DATA-05; Provenienzfelder REV-TEX-04.
**Akzeptanzkriterien:** Zu jedem sichtbaren Artefakt existiert genau die passende Sidecar-/Manifest-Version;
Fehler lässt die vorherige Generation vollständig unverändert.
**Tests:** Fault-Injection nach jedem Schreibschritt, Read-only-/Full-Disk-Simulation und paralleler Leser.

#### REV-DATA-07 — Selector gruppiert unvollständige und nicht vergleichbare Messzellen

**Status:** offen · **Severity:** hoch · **Einordnung:** bestätigte aktive Methodiklücke
**Beleg:** best_binary_selector.hpp:78-88 modelliert nur binary_id, Gültigkeit und Metriken;
best_binary_selector.cpp:90-113 gruppiert ausschließlich nach binary_id. Die realen Dimensionen stehen in
cache_engine_builder_iterator.hpp:91-152,190-242 und m3v2_study.profile.xml:123-145.
**Mechanismus/Impact:** Workload, Working Set, Setting, Plattform, Build, Serie, Wiederholung und Quality-Status
gehen verloren. Ein Binary, das in schweren Zellen fehlt, kann allein aus leichten Restzellen einen besseren
Median bekommen. samples bevorzugt nur die Zahl vorhandener Werte, nicht vollständige Zellabdeckung.
**Abhilfe:** kanonischen Cell-Key und Provenienz in MeasurementRow aufnehmen; erwartetes Raster pro Vergleich
festlegen; fehlende Zellen invalidieren oder explizit nach vorab definierter Missing-Data-Policy behandeln.
Ranking je vergleichbarem Stratum, danach wissenschaftlich begründete Aggregation.
**Abhängigkeiten:** REV-DATA-01/02/03/04; Provenienz REV-TEX-04.
**Akzeptanzkriterien:** Zwei Kandidaten werden nur über identische Zellmengen verglichen; Manifest nennt
Dimensionen, Missing-Cells und Aggregationsregel; unvollständiger Kandidat kann nicht durch Weglassen gewinnen.
**Tests:** synthetisches Raster mit absichtlich fehlenden harten Zellen, mehrere Workloads/Working Sets,
Plattformen und Builds; erwartete Disqualifikation beziehungsweise stratifiziertes Ranking.

#### REV-DATA-08 — Durchsatzdiagramm interpretiert CPU-Zyklen als Nanosekunden

**Status:** offen · **Severity:** hoch · **Einordnung:** bestätigter aktiver Einheitenfehler
**Beleg:** Code/02_messung_driver/measurement_writer.hpp:87-105 approximiert total_cycles als
total_us×3000 bei 3 GHz. Code/05_diagram_generator/diagram_generator.cpp:268-294 rechnet
op_count×1e9/total_cycles, als wären Zyklen Nanosekunden. sample_data_generator.cpp:68-75 erzeugt unter dem
Namen cycles numerisch ns/op und maskiert die Inkonsistenz in Demo-Daten.
**Mechanismus/Impact:** Für reale 3-GHz-Daten ist der geplottete Durchsatz ungefähr Faktor drei zu klein.
DVFS/Turbo machen eine feste Frequenzannahme zusätzlich wissenschaftlich ungeeignet. Neuere Pfade verwenden
dasselbe Feld teilweise bereits mit Nanosekunden-Semantik.
**Abhilfe:** eine kanonische Zeiteinheit speichern, vorzugsweise total_ns, oder echte Zyklen plus gemessene
Referenzfrequenz/Duration im Schema führen. Diagramm verwendet nur dimensionskorrekte Felder.
**Abhängigkeiten:** Schema-/ABI-Entscheidung sorgfältig mit bestehenden Freeze-Regeln abstimmen; keine
eigenmächtige ABI-Änderung.
**Akzeptanzkriterien:** Ein bekannter 1-s-/N-Op-Datensatz ergibt exakt N ops/s; echte Zyklen werden nur mit
belegter Zeitbasis umgerechnet; Feldnamen und Thesis-Beschriftung stimmen überein.
**Tests:** dimensionsbasierte Unit-Tests für 1/2/3 GHz, DVFS-unabhängiger Duration-Pfad und Regression gegen
synthetische Beispieldaten.

#### REV-DATA-09 — Legacy-Plugin-Mikrobench isoliert die behaupteten Achsen nicht

**Status:** offen · **Severity:** hoch · **Einordnung:** bestätigte aktive Methodiklücke
**Beleg:** cache-engine/tools/permutation_codegen/codegen.cmake:413-484 führt den Allokatorstress vor t0 aus.
:433-477 schaltet für das Layout zwischen LinearProbeHashSet, linearem SoA-Scan und RadixIndex um.
**Mechanismus/Impact:** Der gemeldete Zeitwert misst den Allokatorpfad nicht, obwohl die Permutation einen
Allocator ausweist. Die Layout-Achse tauscht gleichzeitig den Algorithmus und die asymptotische Komplexität;
Unterschiede sind nicht dem Layout zurechenbar.
**Abhilfe:** entweder den Mikrobench klar als Smoke-/Funktionsprobe kennzeichnen und von wissenschaftlichen
Vergleichen ausschließen oder Achsenexperiment so bauen, dass nur die Zielachse variiert und alle relevanten
Operationen im Timer liegen.
**Abhängigkeiten:** Entscheidung, ob dieser Legacy-Pfad noch Ergebnisquelle ist; REV-DATA-08.
**Akzeptanzkriterien:** Wissenschaftliche Tabellen enthalten keine kausal falsch attribuierten Legacy-Werte;
Achsenvergleich hält Algorithmus, Workload und Operationenzahl konstant.
**Tests:** kontrollierte A/B-Varianten mit identischem Algorithmus, Instrumentation der Allocation-Calls und
Metadatenassertion über den gemessenen Scope.

#### REV-DATA-10 — Klassischer ExperimentDriver markiert jeden Rücklauf als erfolgreich

**Status:** offen · **Severity:** hoch · **Einordnung:** bestätigter aktiver Statusdefekt
**Beleg:** experiment_driver.cpp:464-503 ruft run_workload auf und setzt danach pr.succeeded=true, ohne
Rückgabestatus oder Plausibilitätsgate. Der ABI-Aufruf in module_abi_v1.hpp:102-110 besitzt keinen Statusreturn.
**Mechanismus/Impact:** Null-/Teilrecords oder intern fehlgeschlagene Module werden als erfolgreiche
Messungen exportiert und vom Aggregator berücksichtigt.
**Abhilfe:** expliziten Status-/Validitätskanal definieren, ohne ABI-Freeze-Regeln zu verletzen; bis dahin
hostseitige Record-Invarianten und Capability-/Error-Sidecar prüfen.
**Abhängigkeiten:** ABI-/POD-Regeln und REV-DATA-11; kein Major-Bump ohne bestehende Freigabe.
**Akzeptanzkriterien:** Fake-Modul mit Fehler oder Nullrecord erscheint als failed und wird nicht gerankt;
gültiges Modul bleibt kompatibel.
**Tests:** Fake-ABI-Module mit leerem, partiellem und korrektem Record; Aggregator-E2E.

#### REV-DATA-11 — Baseline und Kandidat können unterschiedliche Workloads vergleichen

**Status:** offen · **Severity:** hoch · **Einordnung:** bestätigte aktive Vergleichbarkeitslücke
**Beleg:** experiment_driver.cpp:386-423/440-501 wählt für Profilmodule Workloads über expected_workload oder
Traversal-Heuristik; Nicht-Profilmodule nutzen den Default. result_aggregator.cpp:14-55 prüft
workload_used vor Ratios nicht.
**Mechanismus/Impact:** Throughput-, Latenz- und Cache-Miss-Verhältnisse können zwei verschiedene
Operationsmischungen vergleichen und als Speedup ausgeben.
**Abhilfe:** Vergleich nur bei identischem vollständigem Workload-/Dataset-/Setting-Key; ansonsten getrennte
Strata oder explizit „nicht vergleichbar“.
**Abhängigkeiten:** gemeinsame Cell-Key-Arbeit mit REV-DATA-07.
**Akzeptanzkriterien:** Aggregator verwirft beziehungsweise trennt A-vs-C; gleicher Workload bleibt
vergleichbar; Export nennt den Vergleichskontext.
**Tests:** Baseline/Kandidat mit A/A, A/C und gleicher ID aber verschiedenem Seed/Dataset.

#### REV-DATA-12 — Median-Definition divergiert bei gerader Stichprobengröße

**Status:** offen · **Severity:** mittel · **Einordnung:** bestätigte aktive Statistikinkonsistenz
**Beleg:** best_binary_selector.cpp:102-106 wählt die untere Mitte. csv_to_latex.cpp:47-53 und
diagram_generator.cpp:319-326 wählen durch nearest-rank die obere Mitte.
**Mechanismus/Impact:** Derselbe gerade Stichprobensatz kann im Ranking einen anderen Median als in Tabelle
und Diagramm besitzen; Rang und publizierter Wert widersprechen sich.
**Abhilfe:** eine zentrale Medianfunktion und eine dokumentierte Definition; bei klassischem Median optional
Mittelwert der beiden mittleren Werte.
**Abhängigkeiten:** REV-DATA-04/07.
**Akzeptanzkriterien:** Alle Konsumenten liefern für n=2,4,6 wertidentische Resultate.
**Tests:** gemeinsame Testvektoren für ungerade, gerade, Duplikate und leere Stichprobe.

#### REV-DATA-13 — Welch-Auswertung verwendet eine neue Stichprobe und keine Multiplikitätskorrektur

**Status:** offen · **Severity:** mittel · **Einordnung:** Statistik-/Reproduzierbarkeitslücke
**Beleg:** Code/02_messung_driver/main.cpp:327-350 erzeugt die publizierten Plugin-Stats. :413-424 führt
dieselben Plugins erneut aus, nur für Welch. :427-471 markiert jedes rohe p<0,05 ohne Holm-, BH- oder andere
vorab definierte Korrektur.
**Mechanismus/Impact:** Deskriptive Werte und Signifikanz beruhen auf verschiedenen Laufbatches; zeitliche
Drift kann beide entkoppeln. Viele Paarvergleiche erhöhen die Family-Wise-Fehlerrate.
**Abhilfe:** denselben Rohsample-Bestand für Deskription und Inferenz persistieren; Hypothesenfamilie und
Korrekturverfahren vorab festlegen; Effektgröße/Konfidenzintervall ergänzen.
**Abhängigkeiten:** stabile Messgültigkeit REV-DATA-01/02.
**Akzeptanzkriterien:** Ein Sample-Hash verbindet Stats und Welch; adjustierte p-Werte und Verfahren stehen im
Export; reproduzierbarer Seed/Run-Kontext.
**Tests:** deterministische Rohsamples mit bekannten p-/adjusted-p-Erwartungen und Vergleichszahl >1.

#### REV-DATA-14 — Binary-Writer kann Teilverlust als Erfolg melden

**Status:** offen · **Severity:** mittel · **Einordnung:** bestätigter aktiver I/O-Integritätsdefekt
**Beleg:** measurement_writer.hpp:34-76 erhöht num_records nach mehreren writes, ohne Streamzustand zu prüfen.
finalize kehrt bei bereits fehlerhaftem Stream vor Headerkorrektur zurück. main.cpp:368-372 meldet geschrieben,
sobald count>0, selbst wenn writer.ok false ist.
**Mechanismus/Impact:** Headerzahl, physische Records und Erfolgsmeldung können auseinanderlaufen; ein
abgeschnittener Datensatz wird als verwertbar angekündigt.
**Abhilfe:** add/finalize liefern Status; count erst nach vollständig erfolgreichem Record erhöhen; temp-Datei,
flush/close/size-Prüfung und atomarer Commit.
**Abhängigkeiten:** Artefaktvertrag REV-DATA-06.
**Akzeptanzkriterien:** Simulierter Schreibfehler liefert nonzero/failed, Header zählt nur vollständige
Records, keine kanonische Teildatei sichtbar.
**Tests:** failing streambuf, Disk-full/Read-only-Verzeichnis, verkürzter Record und erfolgreicher Roundtrip.

### 6.3 Build, CI und Integration

#### REV-CI-01 — analyse:thesis-data baut ein nicht existierendes Target

**Status:** offen · **Severity:** hoch · **Einordnung:** bestätigter aktiver CI-Konfigurationsdefekt
**Beleg:** Superprojekt .gitlab-ci.yml:153-165 fordert target comdare-messung-driver.
Code/02_messung_driver/CMakeLists.txt:4-18 definiert target messung_driver und nur OUTPUT_NAME
comdare-messung-driver. Code/CMakeLists.txt:435-442 enthält den korrekten Sammel-Target comdare_da_tools.
**Mechanismus/Impact:** cmake --build --target löst nach CMake-Targetnamen auf, nicht nach Outputnamen; der Job
kann hart mit „unknown target“ scheitern.
**Abhilfe:** messung_driver oder bevorzugt comdare_da_tools bauen.
**Abhängigkeiten:** mit REV-CI-02 in einem fokussierten CI-Fix.
**Akzeptanzkriterien:** CI-exaktes Configure und Build finden alle Targets; Job liefert Exit 0.
**Tests:** GitLab-CI-Lint, lokaler Ninja-Aufruf mit exakt dem CI-Kommando und Pipelinebeleg.

#### REV-CI-02 — Analysejob baut Bibliotheken, nicht die behaupteten CLIs

**Status:** offen · **Severity:** mittel · **Einordnung:** bestätigte CI-Abdeckungslücke
**Beleg:** .gitlab-ci.yml:164 baut comdare_binary_to_csv, comdare_csv_to_latex und
comdare_diagram_generator. Die ausführbaren Targets heißen laut Code/CMakeLists.txt:439-441
binary_to_csv_cli, csv_to_latex_cli und diagram_generator_cli.
**Mechanismus/Impact:** Ein grüner Library-Build beweist weder Linkbarkeit noch CLI-main/Argumentpfad der
Werkzeuge, die der nachgelagerte Workflow erwartet.
**Abhilfe:** explizite CLI-Targets oder comdare_da_tools bauen und optional --help-Smoke ausführen.
**Abhängigkeiten:** REV-CI-01.
**Akzeptanzkriterien:** alle drei Executables existieren und --help/Minimalaufruf läuft.
**Tests:** CI-Build der CLI-Targets, CTest-/Smoke-Aufrufe und Pfadassertion.

#### REV-CI-03 — Downstream-Gates testen main statt des konsumierten Gitlinks

**Status:** offen · **Severity:** hoch · **Einordnung:** bestätigte Integrations-/Reproduzierbarkeitslücke
**Beleg:** .gitlab-ci.yml:106-139 triggert cache-engine, prt-art und Thesis jeweils mit branch: main.
.gitmodules:1-15 verfolgt development; das Superprojekt konsumiert zusätzlich konkrete Gitlink-SHAs.
**Mechanismus/Impact:** Die Superpipeline kann grün sein, obwohl sie einen anderen External-Commit baut als
die Kindpipeline. Nach Divergenz von main/development beweist das Gate den falschen Code.
**Abhilfe:** Kindpipeline auf den unveränderlichen Gitlink-SHA oder einen nachweislich identischen Ref
triggern; Kindjob muss CI_COMMIT_SHA gegen den vom Parent übergebenen Gitlink prüfen.
**Abhängigkeiten:** serverseitiger Default development allein behebt diese SHA-Lücke nicht.
**Akzeptanzkriterien:** Pipeline-Log belegt für jedes External exakt den Super-Gitlink; Abweichung ist harter
Fail.
**Tests:** absichtliche Branch-Divergenz in Testfixture/isoliertem Pipelinefall und SHA-Assert.

#### REV-CI-04 — update=merge macht CI-Checkout zustandsabhängig

**Status:** offen · **Severity:** mittel · **Einordnung:** bestätigtes latentes zustandsabhängiges Risiko
**Beleg:** .gitmodules:4-15 setzt wie vom Entwicklungsworkflow verlangt update=merge.
.gitlab-ci.yml:41-46 nutzt recursive Submodule-Updates; verify:submodules :141-150 druckt Status, lehnt aber
Plus-, Minus- oder U-Präfixe nicht ab.
**Mechanismus/Impact:** Auf persistenten oder wiederverwendeten Worktrees kann CI statt des exakten Gitlinks
einen lokalen Mergezustand bauen.
**Abhilfe:** lokale .gitmodules-Regel beibehalten, aber im CI Checkout-Semantik erzwingen und danach
git submodule status --recursive auf unerlaubte Präfixe hart prüfen.
**Abhängigkeiten:** REV-CI-03.
**Akzeptanzkriterien:** Jeder CI-Submodule-HEAD ist exakt gleich Gitlink; Dirty/Merge/Conflict führt zu Fail.
**Tests:** persistenter Testworktree mit vorgerücktem Submodul und Prefix-Guard.

#### REV-CI-05 — Zentrales CI-Template ist an mutable development gebunden

**Status:** offen · **Severity:** mittel · **Einordnung:** bestätigte CI-Reproduzierbarkeitslücke
**Beleg:** Superprojekt .gitlab-ci.yml:11-14 und Thesis .gitlab-ci.yml:11-14 inkludieren
comdare/cluster/ci-templates mit ref: development.
**Mechanismus/Impact:** Derselbe Projekt-SHA kann an verschiedenen Tagen eine andere Pipelinekonfiguration
erhalten; Audit und Wiederholung sind nicht commitstabil.
**Abhilfe:** Template-Commit-SHA oder unveränderlichen Release-Tag pinnen; Update als expliziten Commit führen.
**Abhängigkeiten:** zentraler Template-Releaseprozess.
**Akzeptanzkriterien:** aufgelöster Include-Ref ist immutable und im Manifest dokumentiert.
**Tests:** CI-Lint mit gepinntem Ref, Wiederholungsprüfung der expandierten YAML.

#### REV-CI-06 — Build- und Test-Presets sind asymmetrisch

**Status:** offen · **Severity:** niedrig · **Einordnung:** bestätigte Abdeckungs-/Dokulücke
**Beleg:** Code/CMakePresets.json:117-138 definiert elf Build-Presets, aber nur sieben Test-Presets.
Es fehlen Tests für ninja-mingw-minsizerel, ninja-mingw-relwithdebinfo, ninja-gcc-release und clang-release.
Code/README.md:86-104 behauptet außerdem acht parallele Jobs, die Presets konfigurieren das nicht.
**Mechanismus/Impact:** Ein offiziell angebotener Buildmodus kann ohne gleichnamigen Standardtest bleiben;
Dokumentation verspricht nicht konfigurierte Parallelität.
**Abhilfe:** Test-Presets ergänzen oder Ausnahmen explizit dokumentieren; Job-Aussage korrigieren oder
entsprechende jobs-Felder ergänzen.
**Abhängigkeiten:** keine; niedrige Priorität.
**Akzeptanzkriterien:** jede angebotene Buildkonfiguration hat einen dokumentierten Testweg; README entspricht
der JSON-Wahrheit.
**Tests:** cmake --list-presets und schema-/Namensabgleich.

### 6.4 Thesis, LaTeX und Reproduzierbarkeit

#### REV-TEX-01 — Lokale Buildskripte akzeptieren stale PDFs als Erfolg

**Status:** offen · **Severity:** hoch · **Einordnung:** bestätigter aktiver Buildstatusdefekt
**Beleg:** thesis/diplomarbeit/build.ps1:5-22 setzt ErrorActionPreference=Continue, prüft nach keinem nativen
Aufruf LASTEXITCODE und verwendet kein -halt-on-error; Erfolg hängt nur von der Existenz des PDF ab.
build_all.ps1:4-22 ignoriert den Exitcode des Teilbuilds und prüft erneut nur vorhandene PDFs.
**Mechanismus/Impact:** Ein alter erfolgreicher PDF-Bestand kann nach neuem LaTeX-/BibTeX-Fehler weiterhin OK
und Exit 0 erzeugen. Ein stale Dokument könnte abgegeben werden.
**Abhilfe:** jeden nativen Exitcode hart prüfen, -halt-on-error verwenden, bei Fehler exit 1; Output unter
temporärem Jobnamen erstellen und erst nach vollständig bestandenem Mehrpasslauf ersetzen; vorzugsweise
gemeinsamer latexmk-Vertrag.
**Abhängigkeiten:** REV-TEX-03; keine Messdatenabhängigkeit.
**Akzeptanzkriterien:** absichtlicher TeX-/BibTeX-Fehler liefert nonzero und ersetzt kein vorhandenes PDF;
Erfolg setzt frischen Zeitstempel und saubere Logs voraus.
**Tests:** stale PDF vorlegen, Syntaxfehler/BibTeX-Fehler injizieren, danach Hash und Exitcode prüfen.

#### REV-TEX-02 — GitLab-CI kann ohne LaTeX-Prüfung grün werden

**Status:** offen · **Severity:** hoch · **Einordnung:** bestätigte aktive CI-Abdeckungslücke
**Beleg:** thesis/diplomarbeit/.gitlab-ci.yml:37-75 erzeugt Lint-/PDF-Job nur bei
COMDARE_TEXLIVE_AVAILABLE=="true"; es gibt keine fehlschlagende Else-Regel. Eine fehlende .blg wird
ausdrücklich akzeptiert.
**Mechanismus/Impact:** Pipelinegrün beweist weder LaTeX-Kompilation noch Bibliographiestufe. Das widerspricht
dem Kommentar „sonst sicherer Fail“.
**Abhilfe:** Jobs immer instanziieren; gepinnte TeX-Live-Umgebung verwenden oder fehlende Toolchain hart
fehlschlagen. Bei vorhandenen Zitaten muss eine frische, saubere .blg existieren.
**Abhängigkeiten:** Infra kann Container/Toolchain liefern, die Pipeline-Semantik selbst bleibt Codeaufgabe.
**Akzeptanzkriterien:** Pipeline ohne Toolchain ist rot statt joblos-grün; zitierende Thesis ohne .blg ist rot;
vollständiger Build erzeugt nachvollziehbares PDF-Artefakt.
**Tests:** CI-Matrix Variable unset/false/true sowie künstlich fehlende .blg.

#### REV-TEX-03 — Englische Abgabevariante ist nicht Teil des CI-Vertrags

**Status:** offen · **Severity:** hoch · **Einordnung:** bestätigte aktive Sprachabdeckungslücke
**Beleg:** thesis/.gitlab-ci.yml:62-79 baut/publiziert nur diplomarbeit.tex beziehungsweise diplomarbeit.pdf.
config/language.tex:1-11 setzt direkten Build auf Deutsch. diplomarbeit.tex:13-31 und build_all.ps1 versprechen
gleichzeitig einen bilingualen Vertrag.
**Mechanismus/Impact:** EN kann unbemerkt Compile-, Verweis-, Zitat- oder Layoutfehler entwickeln; die
mechanische DE/EN-Gleichwertigkeit ist nicht gegatet.
**Abhilfe:** CI-Matrix de/en mit getrennten Jobnamen/PDFs und identischen Warning-, BibTeX- und Verweisgates.
Primär-/Sekundärkommentare konsistent machen.
**Abhängigkeiten:** REV-TEX-01/02.
**Akzeptanzkriterien:** beide PDFs entstehen frisch; beide Logs erfüllen denselben Vertrag; ein Fehler nur in
EN macht die Pipeline rot.
**Tests:** sprachspezifischer absichtlicher Fehler, Cite-/Label-Symmetriescan und PDF-Artefaktprüfung.

#### REV-TEX-04 — Messwert-Provenienz ist nicht reproduzierbar eingefroren

**Status:** offen · **Severity:** hoch · **Einordnung:** bestätigte Reproduzierbarkeitslücke
**Beleg:** thesis/generate_wide_appendix.ps1:33-57 referenziert CSV und Generator-Binaries über mutable Pfade
außerhalb des Thesis-Repos; die Root-.gitignore:39 schließt den Default-Messdatenbestand aus. Die Thesis-CI
kompiliert nur committete Fragmente. anhang/de/tabellen/bias_matrix_table.tex:1-2 nennt Generatorart und
Aggregation, aber keinen Input-Hash, Generator-Commit, Build-ID oder vollständigen Aufruf.
anhang/de/A_measurements.tex:3-8 verweist noch auf den im Skript ausdrücklich stale genannten C1-Orchestrator.
**Mechanismus/Impact:** Eine PDF-Zahl lässt sich nicht eindeutig auf unveränderlichen Datensatz,
Generatorstand, Plattform und Kommando zurückführen. Byte-identische Regeneration ist nicht beweisbar.
**Abhilfe:** getracktes Provenienzmanifest mit SHA-256 aller Inputs, Git-SHAs von Super/cache/PRT/Thesis,
Generatorbinary-Hash, Toolchain/Plattform, exaktem Kommando und Schema; CI regeneriert temporär und verlangt
einen leeren Diff.
**Abhängigkeiten:** REV-DATA-06/07/08 und stabile Messdaten.
**Akzeptanzkriterien:** Jede generierte Tabelle ist auf Manifest und Inputhash rückführbar; fremder Datensatz
oder Generator erzeugt harten Diff/Fail.
**Tests:** clean-room-Regeneration, Hash-Manipulation und byte-identischer Vergleich DE/EN.

#### REV-TEX-05 — DE/EN-Tabellengenerierung ist nicht atomar

**Status:** offen · **Severity:** mittel · **Einordnung:** bestätigter aktiver Artefaktkonsistenzdefekt
**Beleg:** thesis/generate_measurement_appendix.ps1:53-80 und generate_wide_appendix.ps1:74-145 schreiben
Sprachen und Einzelartefakte sequenziell direkt in kanonische Zielpfade. Ein später Fehler wirft ab. Nur
le_limitierung erhält teilweise einen temporären Schutz.
**Mechanismus/Impact:** Abbruch kann einen Mischstand aus neuen und alten Tabellen oder DE/EN-Divergenz
hinterlassen.
**Abhilfe:** gesamten Dateisatz in temporären Sprachverzeichnissen generieren, Vollständigkeit/Hashes und
DE/EN-Paarigkeit prüfen, danach atomar ersetzen; zusätzlicher --check-Modus für CI.
**Abhängigkeiten:** Provenienzmanifest REV-TEX-04.
**Akzeptanzkriterien:** Fehler an beliebiger Stelle verändert keinen kanonischen Output; erfolgreicher Lauf
ersetzt beide Sprachsätze vollständig.
**Tests:** Fault-Injection nach jeder Generatorstufe, Hashvergleich vorher/nachher und --check-CI-Test.

## 7. VERWORFENE ODER KORRIGIERTE VERDACHTSMOMENTE

| Verdacht | Urteil und Beleg |
|---|---|
| CMD-2-Container-Attribution zählt doppelt oder hat inkonsistentes Schema | verworfen; Formel/Schema konsistent, gezielter Test 1/1 PASS |
| relaxed atomics im LeafOnlyCounter sind selbst falsch | verworfen; relaxed genügt für reine Zählung, der echte Fehler ist Slot-Lifetime |
| OLC verursacht bereits belegte produktive Korruption | präzisiert; Vertrag defekt, aber produktive read_version/validate-Konsumenten fehlen |
| duplizierte ABI-Konstanten widersprechen sich bereits | verworfen; geprüfte Konstanten stimmen am Audit-SHA überein |
| XML-Whitespace wird ungeprüft übernommen | verworfen; betroffener Parserpfad trimmt den relevanten Text |
| klassischer CSV-Export hat Spaltenversatz | verworfen; 16 Header-/Datenfelder sind ausgerichtet |
| E4-Seed/Resume-Stamp ist nicht deterministisch | verworfen; deterministischer Seed-/Stamp-Pfad belegt |
| Stufe 06 verändert Messdaten | verworfen; keine Datenmutation im geprüften Pfad |
| test_best_binary_selector_parse_rank ist nicht registriert | verworfen; CMake-Executable, add_test, Label und Timeout vorhanden; direkter Build+CTest PASS |
| MSB1009 beweist einen Testdefekt | verworfen; falscher/staler Root-Projekteinstieg, verschachteltes VCXPROJ erfolgreich |
| Skeleton-/Codegen-Configure-Warnungen sind neue harte Defekte | verworfen; bekannte, bewusst weiche Konfigurationshinweise |
| abgebrochene Thesis-Logtreffer sind der finale Warnungsbestand | verworfen; Mehrpasslauf unvollständig, daher keine belastbare Abschlusszahl |

## 8. ABHÄNGIGKEITEN UND EMPFOHLENE FIX-REIHENFOLGE

### P0 — vor jeder wissenschaftlichen Vollmessung

1. **REV-CXX-01** Lifetime-UAF schließen.
2. **REV-DATA-01 + REV-DATA-02** Capability- und Semantikgates gemeinsam bauen.
3. **REV-DATA-05** Pfadcontainment vor weiterer Artefaktveröffentlichung.
4. **REV-DATA-07 + REV-DATA-08** vergleichbare Zellraster und korrekte Einheiten.
5. **REV-CI-01** Analysejob wieder auf einen realen Targetvertrag bringen.
6. **REV-TEX-01 + REV-TEX-02** stale Erfolg und joblos-grüne PDF-Pipeline ausschließen.

### P1 — vor Ranking, Baselinevergleich und Ergebnisübernahme

1. REV-CXX-02..05 als getrennte, klein prüfbare Concurrency-/Error-Inkremente.
2. REV-DATA-03/04 vor Einlesen neuer E4-/Mess-CSV-Akten.
3. REV-DATA-06 vor produktiver Best-Binary-Auslieferung.
4. REV-DATA-09..11 vor wissenschaftlicher Interpretation des Legacy-/Classic-Pfads.
5. REV-CI-03 vor Verwendung der Superpipeline als Gitlink-Beweis.
6. REV-TEX-03/04 vor einer bilingualen, reproduzierbaren Abgabe.

### P2/P3 — Konsistenz und Härtung

REV-DATA-12..14, REV-CI-02/04/05, REV-TEX-05; REV-CI-06 zuletzt. Jeder Fix benötigt einen eigenen
Akzeptanzbeleg und darf nicht mit unabhängigen Review-TODOs zu einem unprüfbaren Großcommit vermischt werden.

## 9. NÄCHSTER ZYKLUS STARTET MIT

1. Alle vier Repositories und Gitlinks erneut literal prüfen; jüngere Ledger-Aussagen schlagen diese Session.
2. Nutzerpriorität für P0 bestätigen beziehungsweise bestehende Ledger-Gates abgleichen.
3. Pro TODO einen fokussierten Dossier-/Fix-/Test-Commit erstellen; keine ABI-/POD-Änderung ohne bestehende
   Freigabe.
4. Zuerst Messgültigkeit statt Performance optimieren: ein schneller, semantisch falscher Lauf ist ungültig.
5. GitLab-first auf development pushen; main bleibt ohne ausdrückliche Merge-Freigabe unverändert.
6. Für jeden behobenen Befund in Ledger §12 additiv Commit, Tests und Reststatus nachtragen.

## 10. ABSCHLUSSINVARIANTEN

- Nichts in-flight; keine versteckten Worktrees oder Stashes erzeugt.
- Kein Review-Fix in diesem Dokumentationscommit.
- Externals bleiben auf den oben genannten Gitlinks und werden durch diese Session nicht verändert.
- Der separate dirty PRT-Klon bleibt unberührt.
- Kein Cluster-/HPC-/NAS-Eingriff.
- Keine Secrets in Session oder Commit.
- Der nachfolgende serverseitige Default-Branch-Wechsel betrifft nur das Superprojekt und löscht weder Branches
  noch verändert er Schutzregeln.
