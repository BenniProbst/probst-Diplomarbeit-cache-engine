# ARBEITSWEISE-KIPP + KONFORMITAETS-KORREKTUR (Mo 24.08.2026 ~08:10 UTC)

Owner-Order (verbatim): "Bitte kippe die Claude Code Arbeitsweise und halte dich
strikt daran."

## 1. KIPP-VOLLZUG (Nenner-Pflicht)

/home/comdare/Projekte/docs/ARBEITSWEISE-GESAMT-DOKTRIN.md (Umbrella, GELTENDE
Fassung v4.4, Stand 17.08.) — **1264/1264 Zeilen VOLL gelesen** in 2 Portionen
(1-640, 641-1264). Die super-docs-Datei gleichen Namens ist der 53-Z.-ZEIGER
(Umzug 10.08.) — NICHT die Fassung; Zeilenzahl-Probe wie in der Doktrin
gefordert (dreistellig = Fassung, zweistellig = Zeiger) vor dem Lesen gefahren.

Erfasste Regelflaechen: Teil A (A1 Modell-Matrix + A1.1 Orchestrator-Delegation,
A2.0 Reihenfolge, A2 Pipeline + Landungsklassen, A2.1 parallel bauen/sequentiell
landen inkl. (a)-(d), A2.1a Wellen-Form, A2.1b Harmonisierung + KOMPLEX-FIX,
A2.2 Bestands-Pflicht, A2.3 Zehn-Wochen-Explore + A2.3a Vorlage-Sperre, A2.4
Workflow-Betrieb, A2.5 FIX-Stufe, A3 Guardrails/gitleaks/Worktree-Erhebung, A4-A7)
· Teil V (V0-V14) · Teil B (B.0-B.4, inkl. B.3-NACHTRAG KON97 + 8 owner-gated
Regel-Kandidaten) · Aenderungslog v1-v4.4.

## 2. SELBSTPRUEFUNG DER LAUFENDEN ARBEIT — 2 ABWEICHUNGEN, BEIDE KORRIGIERT

### 2a. 🔴 A2.5 VERLETZT: Workflow-Ketten endeten NACH dem Verify

BEFUND (am Objekt gemessen, nicht behauptet): der W2-Abschluss-Zug
(wf_08c04723) endete mit `return { design, fix, verify }` — es fehlte die
A2.5-Stufe ("jeder Verify-Fund wird im NAECHSTEN Schritt mit Fable 5 max
behoben, dreiwertig quittiert, rekursiv bis ein Verify-Durchgang NULL neue
Funde liefert"). Der Rueckfragen-Zug (wf_c37fb077) hatte gar keine Verify-/
Gegenlese-Stufe (V10: Doppelpruefung ist die Arbeitsform).

KORREKTUR (beide Scripts ADDITIV gepatcht, Prompts der bestehenden Stufen
byte-identisch -> Journal-Cache bleibt vollstaendig gueltig):
- wf_08c04723: neue Phase **A2.5-Fix** — Schleife FIX -> RE-VERIFY, je mit
  Schema {verdikt: NULL_NEUE_FUNDE|FUNDE_OFFEN, funde[], bilanz}; Abbruch NUR
  bei NULL_NEUE_FUNDE; Sicherheits-Obergrenze 6 Runden wird LAUT gemeldet statt
  still zu kuerzen (Doktrin: "endet, wenn ein Verify-Durchgang null neue Funde
  liefert — nicht, wenn die Geduld endet"). Auflagen im Prompt: vollstaendige
  Fund-Liste (HINWEIS/NOTIZ/Randfall-Klassen existieren nicht), T-1 rot-zuerst
  je Fund, dreiwertige Quittung mit Beleg, gleicher Worktree/Branch, A3-Push-
  Wache, Riss-Schutz A25-FIX-STAND.md.
- wf_c37fb077: neue Phase **Gegenlese+A2.5** — adversarische Gegenlese des
  neuen Ledgers (Vollzaehligkeit gegen 12 Batch-Kondensate, Fold-Korrektheit
  neu-schlaegt-alt, REST-FRAGEN-HAERTE mit Mehrmuster-Gegenprobe gegen den
  alten Ledger [A2.3-Falsch-Null-Klassen], Zitat-Treue V13/V12) -> A2.5-Fix ->
  rekursiv bis NULL neue Funde.
Wirkung: greift beim naechsten Resume/Rueckkehr; die laufenden Agenten wurden
NICHT gestoppt (kein Arbeitsverlust).

### 2b. A3 gitleaks: mein Push-Bereich war zu eng

BEFUND: meine Pushes fuhren `gitleaks detect --source . --log-opts="-1"` —
das prueft EINEN Commit, nicht den Push-Bereich, ohne `-m` (Merge-Commits
werden sonst uebersprungen) und ohne die positive Zusicherung
"gescannte Commits == Commits im Bereich" (A3: "`--depth` ist keine
Bereichsangabe", "0 commits scanned ist nur das auffaelligste Symptom").
KORREKTUR ab sofort (Rezept fuer jeden Push dieser Session):
    N=$(git rev-list --count <remote>/<branch>..HEAD)
    gitleaks detect --source . --config .gitleaks.toml --log-opts="<remote>/<branch>..HEAD -m"
    -> Zeile "N commits scanned" gegen $N pruefen (Nenner-Pflicht V6.1)
    + Koeder aus der WIRKSAMEN Config (glpat- + 20, Laengen-Assert) VOR der Null.
Der Koeder-Teil war bereits konform (v4.1-Regel-Klasse).

## 3. GEPRUEFT UND KONFORM (kein Handlungsbedarf)

- A1/Kanal-Regel: alle 4 Straenge laufen ueber das Workflow-Tool mit explizitem
  model+effort (Top-Level-Agent kennt kein effort-Feld). MODELL-WACHE nach dem
  Sonnet-Fallback-Vorfall etabliert.
- A1.1: greift nicht — der Lead liegt NICHT unter Fable 5 max (Owner-Order
  "voruebergehend ueberall nur Fable 5 max"; Owner-Wort > Teil A, und die
  Doktrin selbst weist diese Order als Session-Memory-Order aus, v3.5-Abgrenzung).
- A2.0: Gedaechtnis-Befund vor jedem Agentenstart (Memories + Doku + Board
  gelesen, Fundstellen benannt).
- A2.4/2: journal.jsonl als Wahrheit; Lebendprobe ueber Journal-/Transkript-
  Wachstum statt pgrep. A2.4/3: kein SendMessage an wartende Workflow-Agenten.
- A3: kein `git add -A` (explizite Pfade), NIE rebase, Doku nie geloescht,
  Messdaten unangetastet, CI nie gecancelt; Worktree-Erhebung ueber
  `git worktree list` je Store (Z11-Raeumung).
- V1/V11: Belegzeile vor jeder Aussage (Zahlen mit Nenner, Kommandoausgabe im
  selben Zug); V12/V13/V14 in den Prompts als Auflage.
- B.3: Ledger nur ueber scripts/ledger_nachtrag.sh (kein `cat >>`); TABU-
  Artefakte unberuehrt; Lead-only-Hotspots nicht parallel beschrieben.

## 4. OFFENE DOKTRIN-POSTEN (bewusst, mit Traeger)

- A2.1b KOMPLEX-FIX: faellig bei der naechsten Wellen-Landung (Lande-Zug
  Z13ff + Wellenplan-Branch); Findings-Sammel-Liste = die W2-Abschluss-
  Pflichttafel (#139) — dort ist die Sammlung bereits Auftrag.
- W2-Audit-Script (wf_98cabd77) traegt Sonnet-max-Erheber aus dem 21.08.:
  alle Erheber sind aus dem Cache terminal, es startet keiner neu — bei einem
  kuenftigen Neubau des Scripts auf Fable-max heben (Owner-Order bis Widerruf).
