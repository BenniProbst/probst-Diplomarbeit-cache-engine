# AUDIT RUNDE 1 -- Strang "cidual" (#106 R1+R2), Fable-max-Auditor

Datum: 22.08.2026 (Erhebung 21./22.08. nachts). Objekt: super `bau/cidual` @
**223ab5182fa868f14bafc8c5a941c8c4165c541d** (Basis a7e8e151, Ancestor-Beweis rc=0,
genau 1 Commit, 1 Datei `.gitlab-ci.yml`, Diffstat literal `79 insertions(+), 56 deletions(-)`).
Alle Messungen read-only am super-Hauptklon (`git show`/`git diff`/`git grep` gegen Refs)
bzw. an gesicherten Kopien (`/tmp` -> Beweiskopie hier im Ordner). KEIN Fix noetig, KEIN
Commit, KEIN Bau (reine YAML-Pruefung, kein Bau-Slot gezogen -- Slot-Protokoll greift nur
vor Bauten; identische Begruendung wie der Strang selbst).

Beweiskopie: `beweis-diff-a7e8e151-223ab518.txt` (253 Z., voller Branch-Diff) in DIESEM Ordner.

Eingang voll gelesen: soll-karte.md (323 Z.) * ci-dual-r1r2-ergebnis.md (173 Z.) *
LEAD-ENTSCHEIDE-zum-w2-design.md (87 Z.) * W2-ABFOLGE-DESIGN D-6-Block Z.335-344 +
Lande-Sequenz Z.768-769/817-824 + Gegenprobe Z.690 + Slot-Kollision Z.811 * STAFFEL1-SYNTHESE
F-28..F-34/F-45 + Status-Tafel Z.19/28/72/85 * STAFFEL2-SYNTHESE H-17 (Z.88-92) + Z.110/134/271/275 *
karte-memory-findings-106.md A5+Teil B (Z.80-115) * Ledger KON119-05 (Z.150-160 literal) *
GOAL v8 Z.760-780 (allow_failure-VERBOT literal) * DESIGNPLAN-tdd T-11b (Z.644-646 literal) *
Wellenplan T-13 (Z.3320-3326 literal).

---

## A. PUNKT-FUER-PUNKT-TAFEL (P-01..P-12, dreiwertig)

### P-01 OWNER-MANDAT -- ERFUELLT
Ledger KON119-05 am Objekt gegengelesen (Z.150-157, woertlich): "doppelter Compile-Test
gcc+clang ist PFLICHT fuer ALLE Bereiche ('das sehen wir nur durch einen doppelten compile
test fuer ALLE Bereiche') ... kein when:never-/changes:-Skip". Objekt-Beleg: YAML-Parse am
Tip (PyYAML SafeLoader + registriertem `!reference`-Tag) -> ALLE 6 Zellen (`build:clang`,
`test:unit`, `test:unit:debug`, `test:unit:clang`, `test:unit:clang:debug`,
`verify:submodules`) tragen exakt `rules=[{'when': 'on_success'}]`; `grep -n
COMDARE_CLANG_MATRIX` am Tip = 4 Treffer, ALLE Prosa-Kommentare (:123, :261, :270, :1280),
0 funktionale Leser.

### P-02 R1 = D-1 Kill-Switch streichen -- ERFUELLT
- Basis-Zustand literal bestaetigt: `git show a7e8e151:.gitlab-ci.yml` -> :123
  `COMDARE_CLANG_MATRIX: "1"` (globale Variable), :276 `- if: '$COMDARE_CLANG_MATRIX != "1"'`
  + :277 `when: never` (Kill-Switch als ERSTE rules-Zeile von build:clang), dahinter die
  9-Pfad-`changes:`-Kopie (= "5. Drossel") + `when: never`-Schluss -- der volle alte
  Rules-Block ist im Beweis-Diff Z.87-113 als Streichung sichtbar.
- Tip-Zustand: build:clang `rules=[{'when': 'on_success'}]` (Parse literal); Variable :123
  ersatzlos gestrichen (Diff Z.9-13, ersetzt durch Erklaer-Kommentar).
- Leser-Nachweis ueber den GANZEN Baum am Tip: `git grep -n COMDARE_CLANG_MATRIX 223ab518`
  = 142 Text-Treffer + 1 Binaerdatei, Datei-Aufschluesselung: 4x `.gitlab-ci.yml` (die 4
  Prosa-Kommentare) + ALLE uebrigen unter `docs/` (sessions/backups/Ledger/architektur).
  **0 Treffer in `ci/`, `scripts/`, `Code/`** -- damit ist auch die Emitter-Seite gedeckt
  (der dynamische planer-Child kann keinen Leser emittieren, den es im Code nicht gibt).
- K5-Abnahmeformel Rang 1: erster Halbsatz ("`build:clang` traegt `rules:[{when:on_success}]`")
  LITERAL erfuellt; "`COMDARE_CLANG_MATRIX=0` kann die Zelle nicht mehr still loeschen"
  erfuellt (kein if-Leser in den rules, kein Leser im Baum). Zum Halbsatz "byte-identisch zu
  `.code-rules`" siehe Abschnitt C (Formel-interne Spannung, kein Objekt-Mangel).

### P-03 R2 = D-2 changes:-Drossel weg -- ERFUELLT
- Tip-Parse: alle 4 `test:unit*`-Zellen OHNE `.code-rules` im extends
  (`test:unit: [.test, .ccache-pull]` -- `.ccache-pull` bleibt wie die Fix-Skizze fordert;
  die 3 anderen `[.test]`), je eigene `rules: - when: on_success`.
- `grep -n 'extends:.*code-rules'` am Tip = GENAU 8 Konsumenten (:255 toolchain:probe,
  :340 lint:format, :345 lint:static, :1485 analyse:thesis-data, :1520
  visibility:tier-binaries, :1571 integration:smoke, :1610 manifest:provenance, :1664
  prebackup:measurements). Basis hatte 13 -> Delta genau 5 = 4x test:unit* + verify:submodules.
  KEINE der 5 Dual-Zellen, nicht verify:submodules -- wie behauptet.
- K5-Abnahmeformel Rang 2 ("alle 4 Zellen laufen bei JEDER Welle, auch docs-only, vorher
  0/4"): erfuellt -- `when: on_success` ohne if/changes = Existenz in jeder Welle;
  Basis-Parse zeigt die 4 Zellen ohne eigene rules an `.code-rules` haengend (docs-only
  = 0/4), literal nachvollzogen.

### P-04 verify:submodules unbedingt (Folge-Notwendigkeit) -- ERFUELLT
Tip-Parse: `verify:submodules` OHNE extends (Basis: `[.code-rules]`), `rules=[{'when':
'on_success'}]`, `needs: [lint:secrets]`; `lint:secrets` selbst `rules=[{'when':
'on_success'}]` (Kettenfuss unbedingt). Harte, NICHT-optionale needs-Kanten am Tip:
`build:clang.needs=['verify:submodules']` und `test:unit.needs=['verify:submodules']`
(Parse literal) -- genau die DAG-Begruendung des Strangs ("undefined need" bei docs-only,
F-30 BEHOBEN). Begruendungs-Kommentar am Job im Diff (Beweis-Diff Z.200-208) vorhanden.

### P-05 Kommentar-Nachzug an allen Behauptungs-Stellen -- ERFUELLT
Im Beweis-Diff saemtlich enthalten: (1) variables-Block-Erklaerung statt Variable (Z.10-13);
(2) `.code-rules`-Kopf: 5 Dual-Zellen + verify:submodules als Nicht-Konsumenten benannt
(Z.21-24); (3) `.code-rules`-Allowlist-Kommentar zaehlt die **8** Rest-Konsumenten korrekt
auf (Z.41-45: toolchain:probe, lint:format/static, analyse, visibility, integration,
manifest, prebackup = 8; F-32-Fix am Objekt bestaetigt); (4) build:clang-Kopf + Innen-
Kommentare auf R1+R2-Stand (Z.53-58, 67-72, 82-83); (5) :1279-Block neu ("ALLE Zellen der
Kette laufen unbedingt ... GESTRICHEN", Z.169-172); (6) die 3 optional-needs-Kommentare
nachgezogen: measure:smoke (Z.224-226), measure:golden-320 (Z.236-239), planer:delegate
(Z.248-250) -- `optional: true` bleibt je als deklarierter harmloser Gurt (F-31 BEHOBEN
bestaetigt); (7) wachen_paritaet-Kommentar in Vergangenheitsform korrigiert (Z.36-39).

### P-06 KEIN changes:-Skip / KEIN allow_failure eingefuehrt (A5) -- ERFUELLT (Beleg-Luecke der Soll-Karte GESCHLOSSEN)
Audit-Messung literal: `grep -E '^\+\s*(allow_failure|changes)\s*:' beweis-diff...txt`
-> **0 Treffer (rc=1)**. Die 8 String-Treffer von `allow_failure|changes:` in Zusatzzeilen
(Diff Z.21, 72, 124, 155, 171, 172, 178, 190) sind SAEMTLICH Kommentarzeilen (`+#`/`+  #`).
Nebenbefund Bestand (KEIN Fund): am Tip existiert genau EIN funktionales `allow_failure:
true` (:2951, Job `ergebnis:holen`, unter `when: manual`) -- an der Basis byte-identisch
vorbestehend (:2928; Versatz exakt der Netto-Shift +23 = 79-56) und mit DEKLARIERTE-
AUSNAHME-Kommentar (NE-20-Triage 13.08.) samt Re-Triage-Auflage versehen; kein R1/R2-Delta.

### P-07 YAML-Wohlform-Probe -- ERFUELLT
Eigenstaendig reproduziert: PyYAML SafeLoader + `!reference`-Tag -> TIP **59 Top-Level-
Schluessel**, alle 6 Zellen `when: on_success`; BASIS ebenfalls 59 (kein Top-Level-Delta =
keine neuen Jobs). GEGENPROBE plain `yaml.safe_load` (ohne Tag): scheitert an TIP und BASIS
IDENTISCH am vorbestehenden `!reference` (TIP Zeile 1992 / BASIS Zeile 1973 -- gleiche
Konstruktion, nur diff-verschoben; Bericht sagte ":1991 ff.", deckungsgleich) -> Bestand,
keine Regression. CI-Lint-API-Anteil siehe P-08/NICHT-PRUEFBAR-Absatz; die "47 Jobs
aufgeloest"-Zahl ist OFFLINE korroboriert: Zensus der nicht-versteckten, nicht-reservierten
Top-Level-Keys am Tip = **exakt 47 Jobs** (Liste im Audit-Lauf literal ausgegeben; das
Remote-Include base-pipeline.yml traegt nur versteckte Vorlagen bei, keine eigenen Jobs).

### P-08 Wirkungs-Nachweis (Job-Delta + Kosten 16052) -- ERFUELLT mit deklarierter Teil-Grenze
- Beide Tabellen vorhanden (ergebnis.md Z.124-150) und in sich exakt: Summe 7.4+77.7+91.6+
  42.4+104.0+14.1 = **337.2 s** (stimmt literal); clang-kritischer Pfad 7.4+77.7+104.0+14.1
  = **203.2 s** ohne bzw. +14..19 s lint:secrets = **217.2-222.2 s** -> die berichtete Spanne
  "~203-223 s" ist exakt die [ohne/mit-lint:secrets]-Klammer; gcc-Kette 7.4+91.6+42.4 =
  **141.4 s** (stimmt literal). Job-Delta docs-only 22->28 = +6 konsistent mit dem
  Basis-Parse (0/6 existierten docs-only) und der 6er-Zellenliste.
- **NICHT-PRUEFBAR (Teil, mit Grund):** die API-Stichprobe der Ist-Dauern von Pipeline 16052
  sowie 16053 (22 Jobs/68 s), Projekt-/Gruppen-Variablen (11 Schluessel/leer) und CI-Lint
  `valid=true/errors=[]` verlangen ein Token; die Audit-REGELN verbieten dem Auditor
  Vault-Zugriff ("Vault/keys NIE lesen"). Unauthentifizierte Gegenprobe literal: `curl ...
  /api/v4/projects/288/pipelines/16052` -> **HTTP=404**. BEIDE Mengen benannt: verifiziert =
  Tabellen-Existenz, Arithmetik, Zellenliste, 47-Job-Zensus; nicht verifiziert = die
  API-seitigen Rohwerte (Plausibilitaet hoch: interne Konsistenz exakt, Zahlen mehrfach
  quer-referenziert in Commit-Botschaft + STAFFEL1-SYNTHESE F-28/F-34).

### P-09 KEIN Push durch den Strang / Landung Lead -- ERFUELLT (aktueller Stand gemessen)
`bau/cidual` == `origin/bau/cidual` == 223ab518 (rev-parse literal identisch) -- die
ci.skip-Ref-Sicherung ist wie in der Soll-Karte (Spannung 4) beschrieben zwischenzeitlich
durch den Lead/#108-Phase-0a erfolgt, KEIN Widerspruch zum Strang-Bericht ("Kein Push
erfolgt (Auftrag)", Stand 21.08. vormittags). `git merge-base --is-ancestor 223ab518
development` -> **rc=1**, dito gegen `origin/development` -> **rc=1**: die LANDUNG ist auch
zum Audit-Zeitpunkt (22.08. nachts) NOCH NICHT erfolgt; Ledger traegt noch KEIN KON120
(grep-Zaehlung 0). Worktree `/home/comdare/wt-super-cidual`: HEAD == 223ab518, `git status
--porcelain` leer (porcelain-count=0).

### P-10 Ledger-Zeilen-ENTWUERFE -- ERFUELLT
ergebnis.md Z.158-167: 2 ENTWURF-Zeilen (R1, R2) + 1 "OFFEN danach"-Zeile (Raenge 3-10,
Traeger Task #106, Di 25.08. oder frueher) vorhanden; Ledger selbst vom Branch unberuehrt
(Diff = exakt 1 Datei `.gitlab-ci.yml`) -- Lead-only-Doktrin eingehalten.

### P-11 Raenge 3-10 NICHT beruehrt (Negativ-Pruefpunkt) -- ERFUELLT
Der Diff besteht aus genau 12 Hunks, alle innerhalb der sanktionierten Flaeche (variables-
Kommentar, .code-rules-Kommentare, build:clang, 4x test:unit*, verify:submodules, 3x
optional-needs-Kommentar). Die 8 Rest-Konsumenten haengen am Tip unveraendert an
`.code-rules` (Grep-Liste P-03; nur Zeilen-Shift, kein Funktions-Delta); Top-Level-Zahl
59==59 -> KEINE neue Job-Definition, keine K-1..K-13-Flaeche im Diff.

### P-12 Exklusiver YAML-Schreiber Staffel 1 -- ERFUELLT (objektseitig)
Schleife ueber ALLE `bau/*`-Branches im super: KEIN anderer Branch traegt `.gitlab-ci.yml`
im Diff gegen seine Basis (Ausgabe leer). `bau/s13schema` (1e92b77e) beruehrt nur
`Code/test_data_xml/experiment_schema.xsd`; STAFFEL2-SYNTHESE H-17 bestaetigt Disjunktheit
cidual (.gitlab-ci.yml) x kampvor-super (ci/*.sh). Prozess-Seite (zeitliche Exklusivitaet
waehrend der Staffel) per Objekt nicht rueckwirkend messbar -- kein Kollisionsindiz in
keiner Synthese, kein Merge-Konflikt-Vermerk; als erfuellt gewertet.

---

## B. ZUSATZPRUEFUNGEN (a)-(d)

**(a) TDD-Vertrag je neuem Test:** GEGENSTANDSLOS mit Beleg -- der Branch-Diff umfasst
exakt 1 Datei (`.gitlab-ci.yml`), 0 Testdateien, 0 C++: T-1/T-3/T-4/T-7/T-11c haben keinen
Gegenstand. T-11b (4-Zellen-Kombibau) ist laut DESIGNPLAN-tdd Z.646 ausdruecklich
"Abnahme-Regel ... sie gehoert in die Wellen-Abnahme (par.4)" = Pflicht des LANDE-ZUGS
(K17), nicht dieses Strangs -- deckungsgleich mit Soll-Karte NICHT-GEFORDERT.

**(b) GOAL-Doktrinen:** ASCII: 0 Nicht-ASCII-Zeichen in allen Zusatzzeilen (grep -P
rc=1) + 0 Zeilen >120 (awk leer) -- Strang-Behauptung bestaetigt. allow_failure: 0
eingefuehrt (P-06); der einzige Bestands-Treffer ist die deklarierte NE-20-Ausnahme
(byte-identisch an der Basis). TABU-Zonen: axes/ topics/ heuristik/ golden
tests/unit/CMakeLists.txt saemtlich unberuehrt (1-Datei-Diff); `.gitlab-ci.yml` ist vom
Strang-Auftrag AUSDRUECKLICH getragen (#106 R1/R2 = genau diese Datei). Ledger/Board/
Memory: nicht beschrieben (ENTWUERFE im Bericht). Commit-Trailer `Co-Authored-By: Claude
Fable 5 <noreply@anthropic.com>` vorhanden (git log literal).

**(c) Abnahme-Formeln woertlich:** Formel 2 (R2), 4 (GOAL IX), 5 (KON22-01/8), 6 (KON119-05)
und 7 (Strang-Auftrag) woertlich erfuellt (Belege in A). Formel 1 (R1): der operative Teil
woertlich erfuellt; der Halbsatz "byte-identisch zu `.code-rules`" ist im kombinierten
R1+R2-Endzustand IN SICH unerfuellbar (die `.code-rules`-VORLAGE behaelt planmaessig ihr
docs-only-Gate fuer die 8 Rest-Konsumenten; eine on_success-Zelle kann dazu nicht
byte-identisch sein). Aufloesung nach Wahrheits-Rangfolge: Owner-Wort KON22-01(8)
("skip ist VERBOTEN") + KON119-05 verlangen genau den gebauten on_success-Zustand; die
Byte-Identitaet besteht stattdessen ZWISCHEN den rules-Bloecken aller 6 Zellen (jede exakt
`rules:\n    - when: on_success`, im Diff literal 6x identisch). Kein Objekt-Mangel; als
Formel-interne Spannung dokumentiert (die Soll-Karte fuehrte sie nicht -- Ergaenzung dieses
Audits). Formel 3 (Meilensteine 22/23, 41/41): betrifft Rang 9/10, hier nicht anwendbar
(Soll-Karte Anm. identisch). Wellenplan-T-13-Spannung: Lesart der Soll-Karte am Original
bestaetigt (T-13 Z.3320-3326 = Docs-Zug-Framing; #106 uebertrifft es der Substanz nach;
T-13s eigener Docs-NACHZUG "3b-Zeile beim Di-25/#96 in den Docs-Zug" bleibt als GETRAGENER
Posten des #96/Di-25-Zugs offen -- kein Fund gegen diesen Strang).

**(d) Bericht-Stichproben am Objekt:** 14 Kern-Behauptungen nachgemessen; 12 halten literal
(Diffstat 79+/56-, Tip-SHA, 4 Kommentar-Treffer, 8 Konsumenten, 59 Top-Level, 6x
on_success, needs-Kanten, `.ccache-pull`-Erhalt, Allowlist-8er-Fix, plain-parse-Bestand,
Arithmetik beider Tabellen, ASCII/Breite 0/0). ZWEI Deltas (beide KLEIN, unten als Funde):
Zeilennummern-Staleness und die 3-Bruecken-Aufzaehlung.

---

## C. FUNDE

### F-CD-1 -- KLEIN -- Bericht-Zeilennummern der Verifikationspunkte 1+2 sind am Commit-Objekt um +1 verschoben (Vor-Fix-Messung)
ergebnis.md Z.91-96 zitiert ":123, :260, :269, :1279" (CLANG_MATRIX) und ":254, :339, :344,
:1484, :1519, :1570, :1609, :1663" (8 Konsumenten). Am Tip 223ab518 liegen die Treffer
literal bei **:123, :261, :270, :1280** bzw. **:255, :340, :345, :1485, :1520, :1571,
:1610, :1664** -- 11 von 12 Positionen +1. Ursache-rekonstruiert: die Greps liefen VOR dem
"Genauigkeits-Fix vor Commit" (Allowlist-Kommentar 6->8, ergebnis.md Z.117-118), der netto
+1 Zeile im Bereich :171 ff. einfuegte (:123 liegt davor und blieb). SUBSTANZ beider
Behauptungen (4 Treffer alle Prosa / genau 8 Konsumenten, namentlich identisch) haelt
vollstaendig.
**fix_weg:** KEINE Objekt-Aenderung; ergebnis.md NICHT editieren (BU-additiv-Doktrin,
Rohdaten). Korrektur traegt DIESES Audit: Synthese/Ledger-Zug zitiert kuenftig die
Tip-Nummern (:123/:261/:270/:1280 bzw. :255/:340/:345/:1485/:1520/:1571/:1610/:1664) --
eine Zeile im Synthese-Dokument bzw. beim KON120-Eintrag genuegt.

### F-CD-2 -- KLEIN -- Explore-Behauptung "Alle 3 Trigger-Bridges forwarden yaml_variables:false" zaehlt die 4. Bridge nicht; Schlussfolgerung dennoch wahr (vom Audit unabhaengig geschlossen)
ergebnis.md Z.41-43 begruendet "KEIN Downstream-Effekt" allein mit den 3 Modul-Bridges
(trigger:cache-engine/prt-art/thesis, am Tip :1377-78/:1395-96/:1413-14 je
`yaml_variables: false` + `pipeline_variables: false`). Am Objekt existiert eine VIERTE
Bridge `planer:delegate-trigger` mit `yaml_variables: true` (Tip :2921, Allowlist-
Kommentar :2892-93): an der BASIS wurde die globale Variable dorthin (super-eigener
planer-Child) faktisch geforwardet. Die SCHLUSSFOLGERUNG haelt trotzdem, doppelt belegt:
(1) `git grep COMDARE_CLANG_MATRIX 223ab518` -> 0 Treffer in `Code/`/`ci/`/`scripts/`
(kein Emitter kann einen Child-Leser erzeugen), (2) nach R1 existiert die Variable nicht
mehr -- nichts zu forwarden. Der COMMITTETE Kommentar (:124-125) ist praezise ("den
Modul-Pipelines (alle 3 Trigger ...)"), nur die Bericht-Prosa verkuerzt.
**fix_weg:** KEINE Objekt-Aenderung noetig. Beim KON120-/Synthese-Eintrag zu R1 den
Halbsatz ergaenzen: "4. Bridge planer:delegate-trigger (yaml_variables:true) unschaedlich --
0 Leser in Code/-Emittern (git grep am Tip), Variable seit R1 nicht mehr existent." --
damit ist die Beweiskette auch fuer Nachleser vollstaendig.

---

## D. GETRAGENE OFFENE POSTEN (KEINE neuen Funde -- nur gelistet, Traeger vorhanden)
- F-33 retry-deprecated-Warnung der Vorlage (byte-identisch vorbestehend) -> #106-R3ff-Fenster.
- F-34 docs-only-+6-Jobs-Literal-Nachweis -> NACHWEIS-Posten in der ersten docs-only-Welle
  NACH der Landung (nicht vorziehbar).
- F-45/M-6 clang-Warnungs-Review (W2-2) -> eigener Pruefposten, gruene clang-Zellen ersetzen
  es NICHT (Design-Zeile W2-ABFOLGE Z.331).
- Raenge 3-10 (K-1..K-13) -> eigene Straenge, Traeger Task #106, Di 25.08. oder frueher.
- T-13-Docs-Nachzug (3b-Zeile in den Docs-Zug) -> #96/Di-25 (Wellenplan Z.3325-3326).
- T-11b-Kombibau + Landung selbst (Merge nach development, aktuell NICHT erfolgt,
  rc=1-Beweis) -> Lande-Zug des Leads (K17), Lande-Reihenfolge Phase 2/7 bzw. S2-Z.134.

## E. VERDIKT
**SITZT** -- 0 ERNST, 0 MILD, 2 KLEIN (reine Bericht-Doku-Deltas, Objekt fehlerfrei).
Der Branch 223ab518 erfuellt R1+R2 vollstaendig, alle 12 Prueflisten-Punkte ERFUELLT
(P-07/P-08 mit deklarierter, begruendeter API-Teilgrenze und starker Offline-Korroboration),
Abnahme-Formeln substanziell woertlich erfuellt, GOAL-Doktrinen eingehalten. LANDEREIF
bestaetigt; die Landung selbst (Lead, K17-Kombibau, Code-Welle beweist R1 + halben R2)
steht noch aus.

Selbstcheck: ASCII-only ja; alle Zahlen mit Nenner/Quelle; jede ERFUELLT-Zeile mit
Literal-Beleg; keine Vault-Lesung, keine Schreibzugriffe auf Repos/Ledger.
