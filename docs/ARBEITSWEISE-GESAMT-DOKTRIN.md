# CLAUDE CODE ARBEITSWEISE — GESAMT-DOKTRIN

> **Stand:** 2026-08-08 · **Fassung:** v3.1 (v3 + die neun Luecken, die ein Audit gegen v3 selbst fand)
> **Zweck:** Session-uebergreifende, langfristig bindende Arbeitsanweisung fuer alle
> Claude-Code-Agenten dieses Projekts (Coding, Buildsystem, Infra, Diplomarbeit).
> **Herkunft:** Owner-Auftrag 06.08.2026 — *"Bitte merge die Claude Code Arbeitsweise im
> Memory mit deinen Arbeitsfehler Lehren und kopiere sie in Projekte git als
> Gesamt-Arbeitsanweisungen in die docs dort. Wir wollen das langfristig als Doktrin
> persistieren."*
>
> **AUFBAU:** Teil A = universeller Kern (gilt ueberall) · **Teil V = Verifikations-Doktrin**
> (neu in v3, aus realen Arbeitsfehlern abgeleitet) · Teil B = session-spezifische
> Erweiterungen.
>
> **PFLEGE-REGELN:**
> 1. Teil A und Teil V nur mit expliziter Owner-Freigabe aendern; Aenderungen datieren.
> 2. Session-Spezifisches gehoert in den EIGENEN B-Abschnitt (additiv, datiert, kompakt).
>    Fremde B-Abschnitte nicht editieren.
> 3. **Nichts loeschen** — Ueberholtes als "UEBERHOLT (Datum): …" markieren.
> 4. **Widerspruchsregel:** Owner-Wort > Teil A/V > eigener B-Abschnitt > Session-Memories.
>    Ein B-Abschnitt darf Teil A/V **verschaerfen, nie aufweichen**.
> 5. Jeder Eintrag im Aenderungslog mit Datum + Session + Kurzgrund.

---

# TEIL A — UNIVERSELLER KERN

## A1. Rollen- und Modell-Matrix

**STAND 06.08.2026 (Owner, verbatim): "Fable wird nicht funktionieren und ist aufgebraucht,
bitte wechsel auf Opus 5 max effort"** — Fable 5 faellt als Agenten-Modell komplett aus.

| Rolle | Modell | Zustaendigkeit |
|---|---|---|
| **Lead / Planung / Design / Review / Synthese** | **Opus 5, max effort** | Orchestrierung, Architektur-Entscheidungen, adversariale Reviews, GO/NO-GO, Ledger-/Memory-Pflege, Owner-Entscheidungsfragen |
| **Bau / Struktur / Messung** | **Opus 5, xhigh** | Scaffolding, Verdrahtung, Standardfall-Implementierung, Gate-Inventare |
| **Explore / Recherche** | **Sonnet 5, max effort, "very thorough"** | Korpus-Sweeps, Objekt-Kartierungen, Fundstellen-Suchen — die read-only-Erhebungsklasse. **NIE ein anderes Modell** (Owner-Dauerregel 05./06.08.) |
| **Schwer-Impl / Regressions-Lens** | **Codex** | Neue/komplexe Logik auf gestelltem Geruest; adversariale Zweit-Pruefung |

**Parallelitaet:** Bau-Wellen hart <= 8 gleichzeitige Programmier-Worker. Planungs-,
Design- und Review-Breiten sind davon **ausgenommen** (Owner-Klarstellung 02.08.).
**Bahn-Obergrenze bei Landungen** (06.08. gemessen): **1 Repo-Voll-Gate + 1 Zweit-Repo-Slot
+ n read-only** — mehr ist nicht parallelisierbar, egal wie disjunkt die Dateien sind.

**Kanal-Regel:** Unter `ultracode` laeuft **jede substanzielle Aufgabe ueber das
Workflow-Tool**, nicht ueber Einzel-Agent-Starts. Modell je Phase **explizit** setzen;
Alt-Skripte vor Re-Invoke auf die aktuelle Matrix pruefen.

**WARUM DIE KANAL-REGEL TECHNISCH ZWINGEND IST (08.08.2026 — am Objekt gemessen):** das
Top-Level-Agent-Werkzeug kennt **kein `effort`-Feld** (gemessen ueber 71 Aufrufe: nur
`description`, `isolation`, `model`, `name`, `prompt`, `subagent_type`). Die Matrix oben
schreibt aber Effort-Stufen vor — *"max effort"*, *"xhigh"*. **Diese Vorgaben sind auf dem
Top-Level-Kanal weder einhaltbar noch verletzbar; sie sind dort eine Regel ohne Kanal.**

Daraus folgt: **Aufgaben, fuer die die Matrix eine Effort-Stufe vorschreibt, laufen ueber das
Workflow-Tool.** Ein Top-Level-Agent-Start ist auf Erhebungen ohne Effort-Anforderung
beschraenkt.

**`defaultModel` darf keinen gueltigen Arbeitswert tragen.** Gemessen am 08.08.: **97 von 114
Agenten** wurden allein ueber `defaultModel` besetzt, **4 von 6 Skripten** enthielten
`model:` ueberhaupt nicht. Eine Phase ohne explizites `model` soll beim Start **scheitern**,
nicht stillschweigend auf den Default fallen — sonst ist *"Modell je Phase explizit"* eine
Regel mit eingebautem Umgehungsweg.

## A2.0 REIHENFOLGE (Owner-KERN 08.08.2026 — NEU)

**Owner verbatim:** *"Bitte arbeite strikt nach der dokumentierten Claude Code Arbeitsweise,
wie vereinbart. Gedaechtnis-review-explore-Design->Bauen->Verify."*

    GEDAECHTNIS  ->  REVIEW  ->  EXPLORE  ->  DESIGN  ->  BAUEN  ->  VERIFY

**KEIN AGENTENSTART OHNE VORAUSGEHENDEN GEDAECHTNIS-BEFUND.** Der Befund ist entweder eine
**Fundstelle** (`memory/<datei>`, Ledger-Zeile, Session-Dokument, Architektur-Doc) **oder**
der ausdrueckliche Satz **"GEDAECHTNIS GEPRUEFT, KEIN TREFFER: `<suchmuster>`"**.

Die Stufe wird bei **jedem neu aufkommenden Thema** erneut durchlaufen, **nicht einmal je
Session**.

*Anlassfall (08.08.):* zwei Explore-Agenten auf Lagerhaltung und Resume-Weg angesetzt —
beides vollstaendig dokumentiert, in Memory **und** Ledger **und** Architektur-Doc. Owner:
*"Die Lagerhaltung ist bekannt, daher ist es unmoeglich, dass das jemand so bauen sollte."*

**Warum diese Stufe als erste faellt und deshalb geschuetzt werden muss:** sie ist die
einzige, die **vorne Zeit kostet und hinten nichts Sichtbares liefert**. Ein Explore-Agent
dagegen produziert einen Bericht — er *sieht aus wie* Fortschritt. Unter Takt ist der Agent
der bequemste Stellvertreter fuer das eigene Lesen.

## A2. Pipeline je Feature-Block

Lead **plant + designt** und klassifiziert → **Opus 5 misst + stellt Geruest** →
**Codex schwere/neue Logik** → **Dual-Review = zwei unabhaengige Lenses** → **Lead-Synthese**
→ **serielle Landung**.

**A2-PFLICHT (Owner 05.08.): DUAL-REVIEW vor JEDER Landung** — Codex **und** ein
unabhaengiger Opus-Review. Die "Ersatz-Lens"-Klausel (ein Lens faellt aus) gilt **nur nach
frischer Defekt-Probe im selben Fenster**, nie fortgeschrieben.

**LANDUNGSKLASSEN (08.08.2026 — Praezisierung, keine Aufweichung):** die Pflicht galt
bisher unterschiedslos fuer jede Landung, auch fuer einen Ledger-Append. Am 08.08. hat das
dazu gefuehrt, dass sie bei **19 Landungen null Mal** eingehalten wurde — und dann bekam
auch der **eine** echte Code-Commit keinen Lens. **Eine ueberdehnte Regel wird als Ganzes
ignoriert.** Deshalb:

| Klasse | Pflicht |
|---|---|
| **Code · Skript · CMake · CI-YAML** | **zwei Lenses** (Codex + unabhaengiger Opus) |
| **Soll-Design** (`.md`, das einen Bau steuert) | **ein Lens** — es ist Ausfuehrungsgrundlage fuer Bau-Agenten |
| reine Doku · Ledger-Nachtrag · Session-Dokument | **kein Lens** |
| **Gitlink-Bump** | **kein Lens, aber zwei Gates:** Ancestor-Beweis **und** gruene Kind-Pipeline (s. V3) |

Die Verschaerfung gegenueber vorher: fuer die erste Klasse ist die Pflicht jetzt
**durchsetzbar**, weil sie nicht mehr an der Masse erstickt.

**Truth-Check** (adversarial) bei **jedem** vermeintlichen Abschluss — auch bei Abnahmen,
nicht nur bei Literal-Diffs. Der Truth-Check ist **Teil der Abschluss-Definition** eines
Abschnitts, nicht optionales Nachlaufen.

**Reihenfolge-Doktrin:** P0 + Paritaet zuerst, dann Domaenen-TIEFE — keine Breadth-Wellen.

**Codex-Betrieb (bewaehrte Rezepte):**
- **Codex NIEMALS selbst `git` ausfuehren lassen** — `git diff`/`git log` haengen
  zuverlaessig bis in den Idle-Timeout. Diff-Text **im Prompt mitliefern**; fuer
  Zusatzkontext auf Datei-Lesewerkzeuge verweisen (kein Shell-git).
- **Grosse Diffs in parallele, thematisch disjunkte Scopes schneiden** statt einen Lens
  seriell durch alle Fragen zu schicken. Review-Agenten sind read-only → keine
  Schreib-Kollision.
- **Ein Codex-Thread kann tot sein, ohne dass die Anfrage schuld ist** — haengt er,
  **frischer Thread** statt Diagnose am Prompt.
- Pflicht-Parameter bei jedem Aufruf: `approval-policy: never`, `sandbox: workspace-write`,
  `cwd: <Repo-Pfad>`.

## A3. Abschluss-Sequenz und Guardrails

- **Nie im Haupt-Worktree bauen:** eigener Worktree (nicht unter `/tmp` — Reaper) +
  `rescue/*`-Refs auf **beide** Remotes vor der Landung.
- **`gitleaks` vor jedem Push** — CI-identischer Container `zricethezav/gitleaks:v8.30.1`.
  **Niemals einen Worktree mounten** (Pointer-`.git` → "0 commits scanned"-Vakuum-Gruen).
  **Immer MIT der repo-eigenen `.gitleaks.toml`** (ohne sie Fehlalarme auf deutschen
  Fliesstext) **UND zusaetzlich ueber den Push-INHALT** (`git log -p <remote>..HEAD`) —
  ein Scan ueber den Arbeitsbaum sieht die Commit-Historie nicht.
  **POSITIVE ZUSICHERUNG statt blosser Fehlersuche (08.08.2026):** der Lauf ist erst gueltig,
  wenn die **Zahl gescannter Commits der Zahl der Commits im gemessenen Bereich entspricht**.
  `"0 commits scanned"` ist nur das auffaelligste Symptom — ein Lauf mit `--depth 3` und vier
  eigenen Commits meldet weder Null noch einen Fehler, er meldet **zu wenig**, und nichts
  faengt das. **`--depth` ist keine Bereichsangabe.**
  **Zwei Kanaele, zwei Config-Regeln:** im `git`-Modus auf einem echten Klon zieht gitleaks
  die Repo-Config **automatisch** (belegt: `using existing gitleaks config /repo/.gitleaks.toml
  from (--source)/.gitleaks.toml`). Im **`stdin`-Modus** gibt es keinen Source-Pfad — dort ist
  **`--config` PFLICHT**, sonst laeuft man unbemerkt auf der Default-Config.
- **R4:** kein Push waehrend abhaengiger Pipeline (1 Patch = 1 Pipeline, seriell je Ref).
  **AUSLEGUNG (08.08.2026, aus dem Ledger nach A3 gezogen — eine Auslegung, die man nur im
  Ledger findet, wirkt nicht):** *seriell je Ref*. Wellen auf `dev` und `main` **desselben
  geprueften SHA** duerfen parallel laufen. **Mehrere Pushes auf denselben Ref sind davon
  NICHT gedeckt** — auch dann nicht, wenn sie disjunkte Dateien betreffen.
- **R6:** keine lokalen Vollbauten waehrend Host-CI; buildfreie Verifikation wo moeglich.
- **Git universell:** NUR MERGE, **kein Rebase** · Commits nie droppen · **kein `git add -A`**
  (immer explizite Pfade) · Doku nie loeschen (`git mv`) · Messdaten nie loeschen ·
  CI-Pipelines nie canceln.
- **Disjunkte Datei-Saetze je Agent; Ein-Schreiber-Regel** bei geteilten Dokumenten und
  Hotspot-Dateien. **Ein Worktree hat genau einen Schreiber.** Wer einen fremden betreten
  muss, misst zuerst `status --porcelain` + `log --oneline -1` und **meldet den Fund, bevor
  er etwas veraendert**. `reset --hard`, `checkout -f`, `clean` in fremden Baeumen:
  **verboten**.
- **Negativ-Befund ist KEIN Beweis** — jeder braucht einen dokumentierten Kontrolltest
  (Kommando + woertliche Ausgabe). **Keine Erfolgsmarke ohne literale Tool-Ausgabe.**

## A4. Evidenz, Abbruchsicherheit, Credentials

- **Abbruchsicherheit:** reiche Zwischenstandsdoku + Ledger-Backup im Repo, rescue-Refs
  remote. Nach jedem Neustart **Zustand am OBJEKT rekonstruieren**, nie aus der Summary.
- **Creds nur im Vault**; niemals Klartext in Memory/Repo/Chat. Leak in einer
  Coding-Session = **rotieren** (History-Rewrites sind Infra-Territorium).
- **Neustart vermeintlich toter Agenten NUR nach positivem Todes-Beweis**
  (Transkript-mtime alt + kein Prozess + Journal terminal).
- **Idle-Meldung ohne Bericht ist kein Abschluss-Beweis** — erst Objekt-Zustand pruefen.

## A5. Infra-Abgrenzung

Cluster-/Host-Infra-**Mutation** ist nicht Aufgabe einer Coding-Session. Lesend ok.
Infra-Kernaufgaben stets als **datiertes Handout** in `docs/sessions/` des zustaendigen
Repos (gemessene Befunde + Kausalkette + empfohlene Reihenfolge + Rueckmelde-Kriterium),
nie nur im Chat.

## A6. Architektur-Invariante I24

Auf K8s-Pods nur C++23+ (CMake-gebaut), keine Skripte. Periodisches als C++-Scheduler;
Operator-Tools als C++-CLI. Nicht erfasst: CI-/Runner-Skripte, Host-Tooling, statisches
FE-Bundle.

## A7. Handwerkliches

- **`AskUserQuestion` NIE verwenden** (crasht Sessions) — Rueckfragen im Rueckfragen-/
  Owner-Dokument persistieren.
- Workflow-Skripte: `${JSON.stringify(x)}`-Interpolation nicht escapen.
- **`grep` ist in Agenten-Bash eine Shell-FUNKTION auf ugrep** — fuer exakte Zaehlungen
  **`/usr/bin/grep` absolut** aufrufen. `grep -oP`/`grep -P` bricht auf manchen Varianten
  **stumm**.
- **`set -o pipefail` rettet eine Gate-Pipe NICHT**: stirbt ein mittleres Glied, endet das
  letzte bei leerer Eingabe harmlos, und sein Code gewinnt. **Jede Stufe einzeln ueber
  `PIPESTATUS` pruefen.**

---

# TEIL V — VERIFIKATIONS-DOKTRIN

> **Neu in v3.** Abgeleitet aus **realen Arbeitsfehlern** der Session vom 06.08.2026
> (Lead-Selbstaudit, 16 Fehler in 5 Klassen). Jede Regel hat einen Anlassfall.
> **Diese Regeln verschaerfen Teil A — sie ersetzen ihn nicht.**

## V0. Die Grundfigur

**Alle Fehler dieser Klasse haben dieselbe Gestalt:**

> **Eine Messung war fuer sich korrekt und beantwortete die falsche Frage.**

Das gilt fuer Code-Regressionen **und** fuer die eigene Arbeit gleichermassen. Ein Bericht
ist korrekt fuer das, was gelesen wurde — und falsch fuer das, was ist.

## V1. Berichte sind Beweismaterial, kein Beweis

**Jede Zahl, jede SHA, jede Zustandsaussage aus einem Agenten-Bericht ist eine
BEHAUPTUNG.** Vor der Weitergabe — besonders an den Owner — **selbst messen** oder
ausdruecklich als ungeprueft kennzeichnen ("aus Bericht, nicht nachgemessen").

*Anlassfaelle 06.08.:* drei falsche Commit-Zuordnungen an den Owner (ein Gate-Spiegel als
Heilung gemeldet, ein Paket im falschen Repo verortet) · ein voreiliges "geheilt", nachdem
die Bau-Welle es sagte — die Gegenpruefung fand danach zwei Blocker · Formabweichungen als
"kosmetisch" durchgereicht, ohne zu fragen, **welches Gate** sie prueft; sie waren der
Blocker.

## V2. Eine Luecke melden heisst, sie zu uebernehmen

Formulierungen wie **"weiss niemand"**, **"bleibt offen"**, **"muesste geprueft werden"**,
**"bis jemand anderes das macht"**, **"das Werkzeug fehlt hier"**, **"von hier aus nicht
entscheidbar"** sind **Arbeitsauftraege an mich**, keine Statusmeldungen.

**Verfahren (Owner-KERN 06.08.):**
1. **Zwei-Workflow-Muster:** (a) Explore/Planung, **very thorough** — was ist die Luecke,
   was sagt Planung/Ledger, was ist der Ist-Stand, was ist zu tun, welcher Biss belegt es,
   was ist Bau und was ist Owner-Entscheid. Ergebnis: **ohne Rueckfrage ausfuehrbare
   Bau-Anweisung**. (b) **Bau MIT Verifikation** im selben Lauf.
   **KORREKTUR 08.08.2026 zu (a):** der Halbsatz *"was sagt Planung/Ledger"* hat den
   Bestands-Stand bisher **an den Agenten delegiert** — und damit genau das vorgeschrieben,
   was A2.0 verbietet. **Der Ledger-/Planungs-/Memory-Stand ist VOR dem Auftrag vom Lead zu
   erheben und dem Agenten als Befund MITZUGEBEN.** Der Agent **prueft ihn am Objekt gegen,
   er ermittelt ihn nicht.** Ein Explore-Auftrag ohne mitgegebenen Gedaechtnis-Befund ist
   unfertig — er muss die Frage beantworten: *"Wo habe ich schon nachgesehen, und was stand
   dort nicht?"*
2. **Fehlt ein Werkzeug: Alternative suchen**, nicht die Grenze melden. (Ein fehlendes
   `pdftotext` ist kein Grund, eine PDF-Pruefung offenzulassen — `gs -sDEVICE=txtwrite`,
   `mutool`, `qpdf`, oder ein selbst geschriebener Stream-Parser tun es auch.)
3. **Geht es wirklich nicht** (read-only-Grenze, Owner-Autorisierung, echte Infra-Grenze):
   **Aufgabe TROTZDEM einreihen** — als Task mit Ort, naechster Handlung und dem, was fehlt.
   **Nie als blosse Feststellung stehen lassen.**

## V3. Zwischen "gebaut" und "angekommen" liegt eine Kette

**Jede Landung zieht die vollstaendige Kette nach:**

    dev-Push → Pipeline gruen → main-FF (volle Paket-SHA, nie ueber HEAD)
             → Submodul-Bump (eigener Commit, expliziter Pathspec, Kind-SHA in der Nachricht)
             → Zweit-Repo-Pipeline gruen

**Jedes ungeprueft gelassene Glied kostet die Arbeit.** Nach der Landung den **Endzustand**
messen, nicht den Anfangszustand melden.

**WANN main-FF FAELLIG IST (08.08.2026 — das fehlende Abgrenzungskriterium):** V3 verlangt
main-FF *je Landung*, die Gitflow-Doktrin nennt *dev voraus* den Normalzustand. Ohne
Kriterium ist mit dem Dokument allein **nicht entscheidbar**, ob ein Tag 19 Verstoesse
enthaelt oder null — und ein solcher Punkt entzieht sich jedem Audit und jedem Vorsatz.

**Kriterium:** main-FF wird faellig, **sobald ein PAKET als abgeschlossen gilt** — erkennbar
an einem von dreien: Owner-Meldung, Ledger-Abschluss, oder **gruene Zweit-Repo-Pipeline**.
**Zwischen** Paketen ist *dev voraus* der Normalzustand, und dann ist kein FF faellig.

**Und der FF geht auf den BELEGT gruenen Stand, nicht auf den neuesten.** Eine gruene
Pipeline mit drei Jobs (weil `changes:`-Gates den entscheidenden Job uebersprungen haben)
ist **kein** Beleg — vor dem FF die **Jobliste** ansehen, nicht den Gesamtstatus.

*Anlassfaelle:* ein Paket gepusht und bei Schritt 1 aufgehoert — die Zweit-Repo-Pipeline
misst dann Code, den niemand mehr faehrt · nach einer Landung nicht geprueft, ob die
Agenten-Commits ueberhaupt gepusht sind (vier fertige Verbesserungen lagen unveroeffentlicht)
· nur **einen** von **zwei** Submodul-Zeigern nachgezogen — die CI liest den anderen, die
gebaute PDF war die alte Fassung.

## V4. Verdaechtige das eigene Messverfahren

**Bevor ein Befund gemeldet wird: pruefen, ob das MESSVERFAHREN ihn erzeugt haben koennte.**
Besonders bei **Null-Ergebnissen** ("nichts gefunden") — eine Null ist erst ein Befund, wenn
die **Gegenprobe** zeigt, dass das Verfahren ueberhaupt findet.

*Anlassfaelle:* eine PDF-Textextraktion verband Fragmente mit Leerzeichen → Befund "die
Ersatztexte fehlen im PDF"; LaTeX zerlegt Woerter durch Kerning, ohne Trenner verkettet
standen alle Begriffe da · eine Kapitel-Zaehlung erwischte die **aktiven** statt der
inaktiven Dateien → Befund "nicht erledigt", obwohl fertig · ein lokaler Branch mit
`origin/main` verwechselt → gemeldete "Divergenz", die keine war.

## V5. Parameter in Auftraegen sind selbst Behauptungen

- **merge-base BESTIMMEN LASSEN, nicht vorgeben.** Ein zu enger Pruefbereich meldet gruen,
  wo die Pipeline rot wird.
- **Termine aus der Quelle**, nicht aus dem Gedaechtnis.
- **Widerspricht eine Auflage einer frueheren: den Unterschied ausdruecklich benennen**,
  sonst entsteht Verwirrung statt Klarheit.

*Anlassfaelle:* ein vorgegebener Pruefbereich haette ein Paket faelschlich gruen gemeldet
(der Agent fing es) · eine Format-Auflage widersprach der vorigen ohne Abgrenzung
(punktgenau fuer Diff-Zeilen vs. flaechig fuer Datei-Gates) · ein Termin aus dem Gedaechtnis
statt aus der Quelle — ein ganzer Abend gegen die falsche Frist priorisiert.

## V6. Die zehn Mess-Regeln

Aus realen Regressionen abgeleitet. Jede hat einen Anlassfall im Bestand.

1. **Keine Null ohne Nenner.** "0 Verstoesse" ohne Bezugsgroesse ist kein Beweis.
   Richtig: *"N Zusatzzeilen geprueft, davon X Nicht-ASCII, davon Y ueber 120 Spalten."*
2. **Der Pruefbereich ist Teil der Aussage** — Dateimenge **und** Commit-Bereich, und der
   Bereich ist die **merge-base**, nicht der letzte bequeme SHA. *(Dreimal an einem Tag
   aufgetreten; ueber den engen Bereich meldete dieselbe Wache gruen, ueber die merge-base
   rot.)*
3. **"X liest/braucht niemand" ist eine Vollstaendigkeitsaussage** und verlangt **Code UND
   Tests UND Planung**. Ein grep ueber `libs/` genuegt nie.
4. **Bei generierten Artefakten beweist Abwesenheit im Quell-Repo nichts.** Wer im
   eingecheckten CI-File sucht, sieht emittierte Jobs nicht.
5. **Zur Testzahl gehoert der BAU-ZUSTAND**, nicht nur der Commit. Drei Zustaende, drei
   Zahlen: frischer Klon ohne Vorbau zaehlt **zu wenig** · ein Baum nach vielen Vollaeufen
   zaehlt **zu viel** (`--fresh` loescht den CMakeCache, **nicht** das `generated/`-
   Verzeichnis oder gebaute Tool-Binaries) · nur der **offiziell nachgestellte 2-Pass**
   trifft. **Mengendifferenz immer in BEIDE Richtungen pruefen.**
6. **Ein gruenes Gate deckt nur seinen eigenen Gegenstand.** Vor jeder Freigabe nennen,
   welche Gates gelaufen sind — **und welche nicht**. (Eine Diff-Hygiene-Wache prueft
   Zeichensatz und Breite, **nicht** Formatkonformitaet.)
7. **Ein Gate-Umfang ist repo-spezifisch.** Derselbe Job prueft in einem Repo 1731 und im
   anderen 59 Dateien. **Job-Definition lesen, Variablen einsetzen, lokal reproduzieren** —
   nie eine Zahl zwischen Repos uebertragen.
8. **Ein Submodul-Zeiger kann RUECKWAERTS zeigen.** `M` heisst nicht "neuer". Vor jedem
   Commit, der einen Gitlink beruehren koennte: Richtung per `merge-base --is-ancestor`
   pruefen. *(Ein Zeiger stand 78 Commits zurueck; ein `git add .` haette Kapitel-Substanz
   lautlos zurueckgedreht — im Diff steht nur eine Zeile mit einem Hash.)*
9. **Eine rescue-Ref ist keine Landung.** "Liegt auf origin" beantwortet "ist es gelandet?"
   **nicht** — das tut nur `merge-base --is-ancestor`.
10. **Ein Paketschnitt, der nur in einem Session-Dokument steht, existiert fuer die
    Ausfuehrung nicht.** Jede Kette mit Vor-Trigger- oder Abgabe-Anspruch gehoert in den
    Ledger **und** in die Checkliste — ein Session-Doc ist ein Beleg, kein Register.

## V7. Der Biss prueft die Sache, nicht das Symptom

- **Jede Wache braucht einen Biss:** Wache entfernen → **rot**, wieder einbauen → **gruen**,
  Ausgabe **woertlich**. Ein Test ohne belegten Biss ist wertlos.
- **Bei nicht-deterministischen Defekten (Races) prueft der Biss die STRUKTUR, nicht das
  Timing.** *(Beispiel: die fehlende Ordnungskante wurde nicht ueber Wiederholungslaeufe
  belegt, sondern ueber die Abhaengigkeitszeile des Build-Graphen — vorher ohne, nachher
  mit.)*
- **Produktions-Mutation schlaegt Test-Mutation.** Der staerkste Beleg ist: unter der
  eingebauten Mutation werden **nur die neuen** Tests rot, waehrend der Bestand gruen bleibt
  — dann war der Bestand fuer diese Fehlerklasse blind.
- **Nie eine Zusicherung assertieren, die das Design nicht gibt.** *(Ein Konkurrenz-Test
  behauptet keinen wechselseitigen Ausschluss, wenn das Design ihn nicht zusagt — er prueft,
  dass die Kollisionen unschaedlich sind. Alles andere ist ein Flake-Erzeuger.)*

## V8. Die Heilung trifft oft neben die Wunde

- **Wer eine Existenz-Bedingung als Heilung einer Deckungs-Frage baut, heilt nur den ersten
  Vertreter der Klasse.** *(Eine Wache fragte "gibt es einen Provider?" statt "decken seine
  Werte etwas?" — ein vorhandener Provider mit Leerwerten erzeugte denselben Defekt.)*
- **Die Kette bis zum LETZTEN Verbraucher pruefen**, nicht nur die Fundstelle. *(Ein
  geheiltes Feld half nicht, weil ein Verbraucher eine Ebene weiter mit einem harten Literal
  rechnete — die Heilung haette dort NEUE Falschwerte erzeugt.)*
- **Eine Pflicht, die an Namen oder Zahlen haengt statt an einer Invariante, geht beim
  naechsten Wechsel verloren.** *(Ein Mess-Flag war an zwei Job-Namen geheftet; beim Wechsel
  des Pfades blieb es auf den abgeloesten Jobs zurueck.)*

## V9. Format-Rauschen und Gegenstand des Gates

- **Diff-Zeilen-Gates** (Zeichensatz, Zeilenbreite) → punktgenau arbeiten
  (`clang-format --lines=<a>:<b>`), **nie flaechig**.
- **Datei-Gates** (`lint:format`) → **flaechig** ist die geforderte Loesung, nicht das
  Rauschen.
- **Der Unterschied ist der GEGENSTAND des Gates, nicht die Groesse des Eingriffs.**
- **Format-Rauschen in fremden Paketen ist teurer als der Verstoss, den es heilt** — es
  macht Diffs unlesbar und verwischt die Verantwortlichkeit.

## V10. Was zuverlaessig funktioniert

**Jeder ernsthafte Fund kam daher, dass jemand die EIGENE fruehere Aussage widerlegt hat** —
eine Sonde, die die falsche Frage stellte; eine Empfehlung an einer ungemessenen Zahl; ein
Schluss aus einem abgebrochenen Werkzeuglauf; drei falsche Commit-Zuordnungen.

**Doppelpruefung ist kein Luxus, sondern die Arbeitsform. Und die eigene vorige Aussage ist
der erste Kandidat fuer die naechste Pruefung.**

**Eine Entlastung ist ein vollwertiges Ergebnis.** Ein am Objekt entkraefteter Befund spart
Arbeit — er gehoert genauso dokumentiert wie ein bestaetigter, sonst kehrt er beim naechsten
Suchlauf zurueck und jemand baut, was nicht gebaut werden muss.

## V11. Die Belegzeile — die Messung muss AELTER sein als der Satz (NEU 08.08.2026)

**V1 deckt Agentenberichte, V6.6 die Gate-Nennung — aber keine Regel verlangte bisher, dass
die Belegausgabe VOR der Aussage im Protokoll steht.** Genau daran ist am 08.08. die Mehrzahl
der Fehler gescheitert: **alle** Messungen existierten, sie kamen nur **zu spaet**.

**Die Regel:** jeder Zustandssatz an den Owner oder in einen Commit-Text traegt die
**Kommandoausgabe, auf die er sich stuetzt, im selben Block** — oder den ausdruecklichen
Marker **"aus Bericht, nicht nachgemessen"**.

> **Eine Messung, die nach der Aussage erfolgt, ist eine KORREKTUR, kein Beleg.**

**Warum das die wirksamste Einzelregel ist (gemessen am 08.08.):** wo der Truth-Check
**vorher** lief, fing er **4 von 4** (ein abgebrochener `git add`, eine falsche
GELANDET-Meldung, eine falsche Heilungsbeschreibung, eine Koeder-Gegenprobe). Wo er nachlief,
war die falsche Aussage **sechsmal** bereits beim Owner, einmal schon im Commit-Text, einmal
schon in der CI (ein Repo 43 Minuten rot). **Die Pruefung trifft praktisch immer — sie kommt
nur zu spaet.** V11 verschiebt sie um genau eine Position nach vorn.

**Die Figur, die V11 unterbindet** (V0 eine Ebene konkreter): *der naechstliegende
Stellvertreter wird fuer den Gegenstand genommen.* Elf Belege an einem Tag, alle nach
demselben Schnittmuster:

| gefragt war | genommen wurde |
|---|---|
| Was tut die Funktion? | der Diff ihrer **Verwendung** |
| Ist die Pipeline gruen? | der **Gesamtstatus** statt der Jobliste |
| Hat gitleaks etwas geprueft? | `rc=0` statt der Zeile *"N commits scanned"* |
| Was steht im Commit? | die **SHA** statt `git show --stat` |
| Stimmt die Testzahl? | der **Agentenbericht** statt eines eigenen `ctest` |
| Was ist bereits entschieden? | ein **Explore-Agent** statt des Gedaechtnisses |
| Was misst diese Pipe? | `$?` statt `PIPESTATUS` |

**Jeder Stellvertreter ist billig, benachbart und plausibel.** Keiner ist Faulheit; jeder
beantwortet eine Frage, die der eigentlichen sehr aehnlich sieht. Genau deshalb faellt die
Vertauschung nicht auf — **sie faellt erst auf, wenn man den Gegenstand doch noch anfasst.**

---

# TEIL B — SESSION-SPEZIFISCHE ERWEITERUNGEN

## B.0 VORLAGE fuer neue Sessions

    ## B.<n> <Session-Name> (<Maschine/Session-ID>, angelegt <Datum>)
    - Kernauftrag: <1 Satz>
    - SSOT/Ledger: <Pfad>
    - Lead-only-Hotspots (nie parallel): <Dateien/Dokumente>
    - Abweichungen/Verschaerfungen gegenueber Teil A/V: <nur Verschaerfungen>
    - Session-Gates/Fenster: <Owner-Gates, Datums-Gates>
    - Handout-Ziel fuer Fremd-Zustaendigkeiten: <Pfad>

## B.1 shsd-Coding-Session (node0)

- LOCKED-Reihenfolge: P0 + Paritaet zuerst, dann Domaenen-Tiefe; keine Breadth-Wellen.
- Lead-only-Hotspots: `envelope.proto`, `MODULE_VERSIONS.json`,
  `shsd-webserver/main.cpp`, `adminTabs.ts`.
- Additive Flyway mit Registry-Check; Testmode-Schalter nie setzen.
- Infra-Handouts nach: `Expansion/Cluster Installation/docs/sessions/`.

## B.2 Buildsystem-Session (Laptop)

- Kernauftrag: GOAL v6 — cd-buildsystem als Fabrik konstruieren (17 Straenge, 4 Wellen).
- SSOT: `cd-buildsystem-core/docs/BUILDSYSTEM-LEDGER.md`.
- Lead-only-Hotspots: Ledger, Rueckfragen-Doc, `buildsystem.xsd`, Strang-Stand.
- Doktrinen: MATRIX (Modules=Metaprogrammierung, Products=Fassade, nie ABI brechen) ·
  IN STEIN (from-source `-O3`, `buildsystem.xml` = SSoT, QuadSync-Paritaet, fail-closed) ·
  Branches nur `development`/`main` · Dual-Remote-Pflicht.

## B.3 Diplomarbeit-Session (prod1)

- **Kernauftrag:** Cache-Engine-EXPERIMENT-SYSTEM top-down honest-100%.
- **SSOT/Ledger:** `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (Nachtraege
  **rueckwaerts**, neueste oben).
  **MECHANISMUS (08.08.2026): `sh scripts/ledger_nachtrag.sh <datei|->`. `cat >>` auf den
  Ledger ist VERBOTEN.** Die Regel "neueste oben" beschrieb bisher nur eine **Eigenschaft** —
  am 08.08. gingen **alle sieben** Nachtraege per `cat >>` ans Dateiende, wo sie bei 12.167
  Zeilen niemand findet. *Eine Eigenschaft muss man sich merken, einen Einfuegepunkt nicht.*
  Das Skript bestimmt den Einfuegepunkt (erste Zeile nach dem Kopf-Block — der Kopf waechst,
  eine feste Zahl waere die naechste Falle), prueft die Zeilenzahl **vor** dem Ersetzen und
  laesst den Ledger sonst unangetastet.
- **Lead-only-Hotspots (nie parallel):** der Ledger (append-only, **Ein-Schreiber** — zwei
  gleichzeitige Nachtraege kollidieren garantiert am Dateiende) · `.gitlab-ci.yml` beider
  Repos · `tests/unit/CMakeLists.txt` · golden-/TABU-Artefakte.
- **Verschaerfungen ggue. Teil A/V:**
  - **Zwei-Gate-Modell:** ce-standalone scharf + Gesamtsuite mit eingefrorener Menge.
  - **cf22-Selbstcheck-Pflicht** vor jedem ce-Push.
  - **Frozen-Formulierung praezise:** *"Frozen-BLOCK Zeilen <a>-<b> byte-unbewegt"* —
    **nicht** "Fixtures blob-identisch" (eine Fixture-Datei kann mitformatiert werden,
    ohne dass der Frozen-Block sich bewegt).
  - **FF-SHA-Push-Muster** fuer den `main`-Nachzug: `push origin <VOLLE-SHA>:refs/heads/main`,
    **nie ueber `HEAD`**.
  - **TABU byte-stabil:** `golden_fullpilot_320*`, `permutation_axes.xml`,
    `m3v2_study.profile.xml`, die Registry-XMLs, CRC-Anker, Wire-PODs. **Additive
    Beruehrungen reservierter Slots** sind auszuweisen, nie stillschweigend.
- **Owner-KERNe 06.08. (Mess-Kette):**
  - **Endtermin 15.09.2026**, **woechentliche Lieferung jeden Freitag**.
  - **Batch max 4096** fuer compile **und** Messung.
  - **Die XML muss Bau und Messung GETRENNT definieren koennen** — "nur weil sie kompiliert
    werden sollten, heisst es nicht, dass sie gemessen werden muessen; sonst Regression".
  - **Mess-Achsen-Aenderung erzwingt CEB- UND Binary-Neubau** (dreiphasig/zweiphasig) —
    Vertrag CEB vs Tier-Binary bzw. Tier-Hybrid beachten. **Was denselben Neubau erzwingt,
    gehoert in EINE Welle.**
  - **Die Mess-Achse gibt fuer die CEB frei, was messbar ist**; was messbar ist, **MUSS**
    gemessen werden — PMC gehoert **ueber die Mess-Achse in die CEB und ins Pruefdock**,
    nicht ueber ein globales Compile-Flag.
  - **Fingerprint-Doktrin:** Mess-Achsen + System-Achsen + Organ-Achsen identisch →
    identische Binary → identische Messdaten. **Hauptidee des Systems und des Lagers.**
  - **"NIE abkuerzen, immer mit deep research fixen."**
- **Handout-Ziel fuer Infra:** `Cluster/docs/sessions/` (datiert).

## B.4 *(frei fuer weitere Sessions — Vorlage B.0 nutzen)*

---

# AENDERUNGSLOG

- **v1** (2026-07, shsd-Session): Ursprungsfassung — Modell-Matrix, Pipeline, Guardrails,
  Infra-Abgrenzung, I24, Handwerkliches.
- **v2** (2026-07-31, Buildsystem-Session, Owner-Auftrag): Konsolidierung — v1 als
  universeller Kern (Teil A); session-spezifische Details nach Teil B; Erweiterungs-
  Konventionen eingefuehrt.
- **v2.1** (2026-08-01, Owner-Direktive): Planung UND Design ueber dedizierte Planungs-
  Agenten, Modell-je-Phase explizit.
- **Nachtraege 02.–05.08.:** gitleaks-Form praezisiert · R4 strikt · Truth-Check bei jedem
  Paket-Abschluss · Dual-Review-Pflicht (Codex **und** unabhaengiger Zweit-Lens) ·
  Codex-Diff-inline-Rezept · Explore-Besetzung Sonnet 5 max effort "very thorough" ·
  Lead-Selbst-Edits nur fuer mechanische Klassen.
- **Modell-Matrix-Aenderung** (2026-08-06, Owner): Fable 5 faellt aus →
  Lead/Planung/Design/Review/Synthese = **Opus 5 max effort**; Bau = Opus 5;
  Explore = Sonnet 5; Codex unveraendert.
- **v3** (2026-08-06, Diplomarbeit-Session, Owner-Auftrag *"merge die Arbeitsweise mit
  deinen Arbeitsfehler-Lehren … langfristig als Doktrin persistieren"*): **TEIL V
  (Verifikations-Doktrin) neu** — abgeleitet aus 16 realen Lead-Arbeitsfehlern in 5 Klassen
  und den zehn Mess-Regeln einer Session, die 30+ Regressionen fand. Teil A um die
  gemessenen Betriebsrezepte ergaenzt (gitleaks mit Repo-Config **und** Push-Inhalt,
  `grep`-Shell-Funktion, `PIPESTATUS`, Ein-Schreiber-Regel fuer Worktrees, Bahn-Obergrenze
  bei Landungen, Codex-git-Haenger). B.3 um die Owner-KERNe der Mess-Kette erweitert.

- **v3.1** (2026-08-08, Diplomarbeit-Session, Owner-Freigabe *"Alle Punkte, die du mir
  uebertraegst gebe ich autonom frei. Volles GO dafuer."*): **neun Luecken geschlossen, die
  ein Audit gegen v3 selbst gefunden hat** — 136 Regeln erfasst, 100 am Objekt geprueft,
  52 verletzt. Neu bzw. praezisiert:
  **A2.0 REIHENFOLGE** (Gedaechtnis -> Review -> Explore -> Design -> Bauen -> Verify; kein
  Agentenstart ohne Gedaechtnis-Befund) · **A2 Landungsklassen** (die undifferenzierte
  Dual-Review-Pflicht war ueberdehnt und wurde deshalb als Ganzes ignoriert) ·
  **A1 Kanal-Regel technisch begruendet** (das Top-Level-Agent-Werkzeug hat kein
  `effort`-Feld — gemessen ueber 71 Aufrufe) und **`defaultModel` ohne gueltigen Arbeitswert**
  (97 von 114 Agenten liefen ueber den Default) · **A3 gitleaks positive Zusicherung**
  (N == Commits im Bereich; `--depth` ist keine Bereichsangabe) und **stdin-Modus braucht
  `--config`** · **A3 R4-Auslegung aus dem Ledger nach A3 gezogen** · **V2.1(a) korrigiert**
  (der Halbsatz *"was sagt Planung/Ledger"* delegierte das Gedaechtnis-Lesen an den Agenten —
  also genau das, was A2.0 verbietet) · **V3 main-FF-Faelligkeitskriterium** (ohne es war
  nicht entscheidbar, ob ein Tag 19 Verstoesse enthaelt oder null) · **V11 Belegzeile NEU**
  (die Messung muss aelter sein als der Satz) · **B.3 `scripts/ledger_nachtrag.sh`**,
  `cat >>` verboten.
  **Der Anlass war zur Haelfte eine Vertragsluecke:** die vom Owner genannte Sequenz stand
  gar nicht im Dokument, und V2.1(a) schrieb das Gegenteil vor.
