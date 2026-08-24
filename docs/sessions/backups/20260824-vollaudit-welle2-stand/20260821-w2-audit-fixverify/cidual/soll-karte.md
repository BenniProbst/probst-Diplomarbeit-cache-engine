# SOLL-KARTE -- #106 CI-DUAL R1+R2 (Strang "cidual")

Erstellt: 21.08.2026, Sonnet-max-Planungs-Erheber (NUR LESEN, kein Fix).
Gegenstand: super `bau/cidual` @ **223ab518** (Basis a7e8e151), 1 Datei `.gitlab-ci.yml`,
79 insertions(+)/56 deletions(-). Auftrag laut Steckbrief: R1 = Kill-Switch weg +
`COMDARE_CLANG_MATRIX` gestrichen; R2 = 4x `changes:`-Drosseln weg + `verify:submodules`
unbedingt. Ranks 3-10 der `#106`-Erhebung sind NICHT Teil dieser Aufgabe (siehe
NICHT-GEFORDERT).

**Objektstand verifiziert (diese Erhebung, read-only, super-Hauptklon):**
`bau/cidual` und `origin/bau/cidual` zeigen beide auf `223ab5182fa868f14bafc8c5a941c8c4165c541d`
(identisch); `git merge-base --is-ancestor 223ab518 development` = NEIN (rc=1) -> die
Landung (Merge nach `development`) ist zum Erhebungszeitpunkt NOCH NICHT erfolgt. Die
Commit-Botschaft von 223ab518 bestaetigt R1/R2/verify:submodules/CI-Lint-Befund wortgleich
zum Ergebnis-Bericht des Strangs (Diffstat exakt 79+/56- wie behauptet).

Quellen (alle gelesen): W2-ABFOLGE-DESIGN.md (Block D-6, Z.335-344; Lande-Sequenz Z.768-769,
817-824; Gegenprobe-Liste Z.690; TEIL-3-Slot-Namenskollision Z.811) * LEAD-ENTSCHEIDE-zum-w2-design.md
(voll, 87 Z., insb. YAML-Serialisierungs-Absatz Z.29-31) * Wellenplan v2 par.22.2/T-13
(Z.3238-3326) * DESIGNPLAN-tdd (T-11b, Z.640-648) * GOAL v8 (VII.2 Betriebsregeln Z.636-661,
TEIL IX allow_failure-Verbot Z.728-789) * Ledger KON119-05 (Z.150-160), KON22-01(8)
(Z.9569-9573), KON66-03 (Z.4016-4029) * karte-memory-findings-106.md (voll, 172 Z.) *
ci_dual_erhebung.md Abschnitt 6 Befunde D-1/D-2 (Z.331-399) * ci-dual-r1r2-ergebnis.md (voll,
173 Z.) * STAFFEL1-SYNTHESE.md (Findings F-28..F-34/F-45, Status-Tafel, Lande-Reihenfolge) *
STAFFEL2-SYNTHESE.md (H-17).

---

## PRUEFLISTE

### P-01 -- OWNER-MANDAT (Grundsatz, traegt R1+R2 gemeinsam)
**WAS:** Ledger KON119-05 (Z.151-152, Owner-KERN 20.08. ~10:25, woertlich): *"doppelter
Compile-Test gcc+clang ist PFLICHT fuer ALLE Bereiche"* -- Zitat: *"das sehen wir nur durch
einen doppelten compile test fuer ALLE Bereiche."* Verschaerft die aeltere Doktrin Ledger
KON22-01(8) (Z.9569-9573, 10.08., Owner woertlich): *"Er baut immer und es darf nicht nur
clang gruenen, sondern das Projekt muss auch mit gcc parallel bauen, beide compiler Pflicht!
Gebaut wird immer, skip ist VERBOTEN."* Memory-Dauerregel
`feedback_ci_dual_compiler_alle_bereiche_pflicht.md` (MEMORY-Index: "CI-DUAL-COMPILER ALLE
BEREICHE").
**WIE pruefbar:** `super/.gitlab-ci.yml` darf an KEINER Dual-Compile-Zelle mehr einen
`when:never`/`changes:`-Ausschalter tragen; `grep -n COMDARE_CLANG_MATRIX .gitlab-ci.yml` ->
nur Kommentar-Treffer erwartet.
**Strang-Bericht behauptet:** JA (R1 + R2 vollzogen, siehe P-02/P-03).

### P-02 -- R1 = D-1-Fix: Kill-Switch streichen
**WAS:** karte-memory-findings-106.md:105 (Rang 1, woertlich): *"D-1: Kill-Switch
`super/.gitlab-ci.yml:276-277` streichen"* -- Abnahme woertlich: *"`build:clang` traegt
`rules:[{when:on_success}]` byte-identisch zu `.code-rules`; `COMDARE_CLANG_MATRIX=0` kann
die Zelle nicht mehr still loeschen."* Grundlage ci_dual_erhebung.md:364-371 (FIX-SKIZZE D-1,
woertlich): *"super/.gitlab-ci.yml:276-277 ersatzlos streichen... Im selben Commit: die
Kommentare :253-256 und :1279-1281 nachziehen, sonst behaupten sie einen Mechanismus, den es
nicht mehr gibt. KEIN changes:-Skip, KEIN allow_failure noetig."*
**WIE pruefbar:** `git show <SHA>:.gitlab-ci.yml | grep -n COMDARE_CLANG_MATRIX` -> nur
Kommentar-Treffer; YAML-Parse (PyYAML + `!reference`-Tag) -> `build:clang.rules ==
[{'when': 'on_success'}]`.
**Strang-Bericht behauptet:** JA, mit Literal -- ergebnis.md Z.91-92+97-99 (Verifikation
Pkt.1+3): *"GENAU 4 Treffer, alle Prosa-Kommentare (:123, :260, :269, :1279). 0 funktionale
Leser."* + *"alle 6 Jobs tragen `rules = [{'when': 'on_success'}]`"*. OBJEKT-GEGENPROBE (diese
Erhebung): Commit-Botschaft 223ab518 bestaetigt denselben Befund wortgleich.

### P-03 -- R2 = D-2-Fix: changes:-Drossel entfernen
**WAS:** karte-memory-findings-106.md:106 (Rang 2, woertlich): *"D-2: `changes:`-Drossel von
den 4 super-`test:unit*`-Zellen nehmen"* -- Abnahme woertlich: *"alle 4 Zellen laufen bei
JEDER Welle, auch docs-only (vorher 0/4)."* Grundlage ci_dual_erhebung.md:390-393
(FIX-SKIZZE D-2, woertlich): *"An den vier `test:unit*`-Zellen `.code-rules` aus dem `extends`
nehmen und durch `rules: [- when: on_success]` ersetzen... `.ccache-pull` an `test:unit`
bleibt."*
**WIE pruefbar:** `grep -n 'extends:.*code-rules'` -> die 4 `test:unit*`-Zellen + `build:clang`
duerfen NICHT mehr darunter erscheinen; Rules-Feld je Zelle = `on_success`.
**Strang-Bericht behauptet:** JA -- ergebnis.md Z.93-96 (Verifikation Pkt.2): *"GENAU 8
Konsumenten...KEINE der 5 Dual-Zellen, nicht verify:submodules."* OBJEKT-GEGENPROBE: Commit-
Botschaft 223ab518 wortgleich (*"R2 (D-2): .code-rules von den 4 Zellen...genommen; je rules
when:on_success"*).

### P-04 -- Folge-Notwendigkeit: verify:submodules unbedingt
**WAS:** nicht in einer der fuenf Plan-Karten vorformuliert, sondern eine am Objekt
hergeleitete NOTWENDIGE Folge von R2 (DAG-Validitaet der needs-Kette), die der Strang selbst
entdeckt und die der Aufgaben-Steckbrief explizit mit aufnimmt (*"R2 ... + verify:submodules
unbedingt"*). Quelle ci-dual-r1r2-ergebnis.md:47-51 (woertlich): *"Folge-Aenderung NOTWENDIG
(Vor-Pausen-Diff hatte sie schon): verify:submodules trug `extends: [.code-rules]`; build:clang
+ test:unit haengen HART (nicht optional) per needs daran. Liefe verify:submodules in einer
docs-only-Welle nicht, lehnte GitLab die Pipeline-Erzeugung ab (\"undefined need\")."* Commit-
Botschaft 223ab518 bestaetigt: *"Folge am Objekt hergeleitet: verify:submodules ebenfalls
unbedingt (harte needs-Kante beider Ketten; sonst scheiterte die Pipeline-ERZEUGUNG jeder
docs-only-Welle an einem undefined need)."*
**WIE pruefbar:** `grep -n '^verify:submodules'` bis zum naechsten Job -> Rules-Block =
`on_success` (nicht mehr an `.code-rules` haengend); needs-Graph `build:clang`/`test:unit` ->
`verify:submodules` als nicht-optionale Kante.
**Strang-Bericht behauptet:** JA -- bestaetigt durch STAFFEL1-SYNTHESE.md:135 (Finding F-30):
*"harte needs-Kante haette docs-only-Pipeline-Erzeugung scheitern lassen (undefined need) |
BEHOBEN (when:on_success)"*.

### P-05 -- Kommentar-Nachzug an allen Behauptungs-Stellen
**WAS:** Teil der D-1/D-2-Fix-Skizzen selbst (ci_dual_erhebung.md:369-370: *"sonst behaupten
sie einen Mechanismus, den es nicht mehr gibt"*) -- generelle Dokumentations-Redlichkeitspflicht,
keine separate Plan-Quelle.
**WIE pruefbar:** Kommentare an den Kill-Switch-Erklaerstellen, an den 3
optional-needs-Kommentaren (`measure:smoke`, `measure:golden-320`, `planer:delegate`) und am
`.code-rules`-Allowlist-Kommentar muessen den NEUEN Zustand beschreiben, nicht den alten.
**Strang-Bericht behauptet:** JA -- ergebnis.md Z.71-74/83-86 sowie STAFFEL1-SYNTHESE.md
Findings F-31 (Z.136, *"3 optional-needs-Kommentare...inhaltlich ueberholt | BEHOBEN
(Kommentar-Nachzug)"*) und F-32 (Z.137, *".code-rules-Allowlist-Kommentar zaehlte 6 statt 8
Rest-Konsumenten | BEHOBEN vor Commit"*).

### P-06 -- KEIN changes:-Skip, KEIN allow_failure eingefuehrt (Hausregel A5)
**WAS:** karte-memory-findings-106.md:84-88 (A5, woertlich): *"KON22-01(8): beide Compiler
PFLICHT, KEIN `changes:`-Skip. allow_failure-Verbot seit 06.07... gilt auch fuer jede NEUE
Dual-Compile-Zelle, keine der Fix-Skizzen D-1..D-6/D-9 braucht oder darf `allow_failure`
einfuehren."* Verschaerft durch GOAL v8 TEIL IX (Z.763, Owner dreifach woertlich belegt
06.07./26.07./09.08.): *"`allow_failure: true` ist auf JOB-Ebene VERBOTEN."* Owner woertlich
(Z.775-776, 09.08.): *"Wenn dann muss ein Fehler sauber mit einer Warnung an den Anwender
angezeigt und die Messung uebersprungen werden, aber der CI job failed immer hart."*
**WIE pruefbar:** `git show <SHA> -- .gitlab-ci.yml | grep -n '^+' | grep -E
'allow_failure|changes:'` im Diff-Hunk der betroffenen Jobs -> 0 Treffer erwartet.
**Strang-Bericht behauptet:** IMPLIZIT JA (Commit-Botschaft 223ab518 woertlich: *"KEIN
changes:-Skip, KEIN allow_failure"*), aber OHNE eigenen literalen Kommando-Beleg im
Ergebnis-Dokument (anders als P-02/P-03 mit Grep-Zahl) -- vom Audit selbst nachzumessende
Beleg-Luecke, siehe SPANNUNGEN Punkt 3.

### P-07 -- YAML-Wohlform-Probe (Teil des urspruenglichen Arbeitsauftrags)
**WAS:** ci-dual-r1r2-ergebnis.md:8 (Auftrags-Abschnitt, woertlich): *"YAML-Wohlform-Probe
lokal."*
**WIE pruefbar:** `python3` `yaml.safe_load` mit registriertem GitLab-`!reference`-Tag;
GitLab CI-Lint-API (`POST /projects/288/ci/lint`, lesend).
**Strang-Bericht behauptet:** JA -- ergebnis.md Z.97-108 (Verifikation Pkt.3+4): *"WOHLGEFORMT,
59 Top-Level-Schluessel"*; *"valid=true, errors=[], 47 Jobs aufgeloest"*; GEGENPROBE Basis
a7e8e151 ebenfalls dokumentiert (identische 59 Top-Level-Schluessel, `!reference`-Sonderfall
ist Bestand, keine Regression).

### P-08 -- Wirkungs-Nachweis (Job-Delta-Tabelle + Laufzeit-Kosten aus Pipeline 16052)
**WAS:** ci-dual-r1r2-ergebnis.md:9-10 (Auftrag, woertlich): *"Wirkungs-Nachweis: Job-Delta-
Tabelle + Laufzeit-Kosten aus Pipeline-16052-Jobdauern (API lesend, Projekt 288)."*
**WIE pruefbar:** Vorhandensein + Plausibilitaet der Tabellen "Job-Delta-Tabelle" und
"Kosten-Abschaetzung" im Ergebnis-Dokument; Stichprobe der Jobdauern gegen die GitLab-API-
Historie von Pipeline 16052 (Projekt 288, lesend).
**Strang-Bericht behauptet:** JA -- ergebnis.md Z.124-150 (beide Tabellen vorhanden, mit
Zahlen: docs-only-Delta +6 Jobs, ~203-223 s wall obere Schaetzung; Code-Wellen +0 Jobs;
Summe Job-Zeit 337,2 s).

### P-09 -- KEIN Push (Landung faehrt der Lead)
**WAS:** ci-dual-r1r2-ergebnis.md:10 (Auftrag, woertlich): *"KEIN Push, Landung faehrt der
Lead."*
**WIE pruefbar:** `git log origin/bau/cidual` vs. lokalem Branch-Tip; Merge-Status gegen
`development`.
**Strang-Bericht behauptet:** JA (kein Push durch den Strang selbst) -- ergebnis.md Z.169-173:
*"Kein Push erfolgt (Auftrag). Branch-Sicherung per `git push -o ci.skip` steht dem Lead
frei."* OBJEKT-GEGENPROBE (diese Erhebung, 21.08. abends): `origin/bau/cidual` existiert
BEREITS auf demselben SHA 223ab518 wie der lokale Tip -- die ci.skip-Sicherung wurde
zwischenzeitlich nachgeholt (konsistent mit Task-#108-Notiz "Phase 0a/0b VOLLZOGEN (cidual
origin-gesichert ls-remote-bewiesen)"). `git merge-base --is-ancestor 223ab518 development` =
NEIN (rc=1) -> die eigentliche Landung (Merge nach `development`) ist zum Erhebungszeitpunkt
NOCH NICHT erfolgt, konsistent mit "Landung faehrt der Lead" als weiterhin offenem Schritt.

### P-10 -- Ledger-Zeilen-ENTWUERFE liefern (Lead traegt ein)
**WAS:** ci-dual-r1r2-ergebnis.md:158-167 (Abschnitt "Ledger-Zeilen (ENTWURF, Lead-only
einzutragen)") -- getragen von der generellen Berichtsdoktrin GOAL v8 TEIL X (Z.792-802:
"Was gelandet ist... Was offen bleibt") und der Memory-Regel "Ledger/Board/Memory NIE
schreiben (Lead-only; ENTWUERFE in die Berichts-Datei)".
**WIE pruefbar:** Vorhandensein von Ledger-Entwurfszeilen fuer R1, R2 und einem "OFFEN
danach"-Hinweis auf Raenge 3-10 im Ergebnis-Dokument.
**Strang-Bericht behauptet:** JA -- 2 ENTWURF-Zeilen (R1/R2) + 1 "OFFEN danach"-Zeile
vorhanden (ergebnis.md Z.159-167).

### P-11 -- Raenge 3-10 ausdruecklich AUSSERHALB des Auftragszuschnitts (Negativ-Pruefpunkt)
**WAS:** karte-memory-findings-106.md:100-101: *"Termin/Traeger fuer ALLE 10 Raenge identisch:
Di 25.08. (S-12-Umfeld) oder frueher wo leicht, Traeger = Task #106"* -- gilt fuer alle 10
Raenge gemeinsam, aber DIESER Strang deckt nur R1+R2 (Rang 1+2). Selbstauskunft
ergebnis.md:170: *"Raenge 3-10 ausdruecklich NICHT Teil dieses Strangs (Auftragszuschnitt)."*
**WIE pruefbar:** Der Diff darf NUR Kill-Switch/changes-Drossel/`verify:submodules`/
Kommentare beruehren; KEINE der 8 verbleibenden `.code-rules`-Konsumenten (`toolchain:probe`,
`lint:format`, `lint:static`, `analyse:thesis-data`, `visibility:tier-binaries`,
`integration:smoke`, `manifest:provenance`, `prebackup:measurements`) darf eine neue
Dual-Zelle erhalten; KEINE der K-1..K-13-Flaechen (PMC-clang, Sanitizer-Zwillinge,
coverage-guard-clang, etc.) darf im Diff auftauchen.
**Strang-Bericht behauptet:** JA (explizit abgegrenzt, 1 Datei, keine neuen Job-Definitionen;
die einzige Beruehrung der 8 Rest-Konsumenten ist eine Kommentar-Korrektur der Allowlist-Zahl
6->8, KEINE neue Zelle) -- ergebnis.md Z.62-65+117-118.

### P-12 -- Exklusiver YAML-Schreiber waehrend Staffel 1
**WAS:** LEAD-ENTSCHEIDE-zum-w2-design.md:29-31 (woertlich): *"YAML-SERIALISIERUNG: E-14
(Chaos-Drift-CI-Job) + E-15 (Tag-Mismatch) + E-10-YAML-Haelfte beruehren super-/ce-YAML ->
warten auf den exklusiven YAML-Schreiber (ci-dual-r1r2, Staffel 1) und fahren im YAML-Zug der
Staffel 3 / Lande-Folge."* Dieser Strang ist also als EINZIGER Schreiber an
`super/.gitlab-ci.yml` fuer Staffel 1 designiert; andere YAML-beruehrende Vorhaben (E-14/E-15/
E-10-YAML-Haelfte) sind ausdruecklich AUF diesen Strang GEWARTET, nicht umgekehrt.
**WIE pruefbar:** Waehrend der Laufzeit dieses Strangs darf kein anderer Staffel-1-Strang
`super/.gitlab-ci.yml` oder `ce/.gitlab-ci.yml` parallel aendern (Ein-Schreiber-Pflicht,
Memory `feedback_ein_schreiber_je_worktree...md`).
**Strang-Bericht behauptet:** IMPLIZIT erfuellt (nur 1 Datei touched, keine Merge-Konflikt-
Meldung in ergebnis.md; STAFFEL1-SYNTHESE.md nennt fuer `cidual` keine YAML-Kollision) --
keine explizite Selbstaussage im Bericht dazu, da es eine Prozess- statt Objektfrage ist.

---

## ABNAHME-FORMELN (woertliche Zitate der Quellen)

1. **K5 Rang 1 (R1)** -- karte-memory-findings-106.md:105: *"`build:clang` traegt
   `rules:[{when:on_success}]` byte-identisch zu `.code-rules`; `COMDARE_CLANG_MATRIX=0` kann
   die Zelle nicht mehr still loeschen."*
2. **K5 Rang 2 (R2)** -- karte-memory-findings-106.md:106: *"alle 4 Zellen laufen bei JEDER
   Welle, auch docs-only (vorher 0/4)."*
3. **W2-ABFOLGE-DESIGN.md D-6-Block** (Z.343-344): *"ABNAHME: je Rang die K5-Abnahmeformel;
   Meilensteine 22/23 und 41/41 literal."* -- Anmerkung: die zwei Meilensteine (22/23
   Konfigurationen, 41/41 Jobs) betreffen Rang 9 bzw. Rang 10, NICHT R1/R2; fuer R1/R2 gilt
   ausschliesslich die K5-Formel aus den Punkten 1+2 oben.
4. **GOAL v8, allow_failure-Verbot** (Z.763): *"`allow_failure: true` ist auf JOB-Ebene
   VERBOTEN."* Owner-Direktive, dreifach im Roh-Transkript belegt (06.07./26.07./09.08.).
5. **Ledger KON22-01(8)** (Z.9569-9573, Owner woertlich, 10.08.): *"D-2: Er baut immer und es
   darf nicht nur clang gruenen, sondern das Projekt muss auch mit gcc parallel bauen, beide
   compiler Pflicht! Gebaut wird immer, skip ist VERBOTEN."*
6. **Ledger KON119-05** (Z.151-152, Owner-KERN 20.08., woertlich): *"das sehen wir nur durch
   einen doppelten compile test fuer ALLE Bereiche."* Mit Erhebungsstand daneben: *"9/41
   Bau-/Test-Jobs unbedingt dual; 13/23 Konfigurationen sehen NIE clang; super-Kill-Switch
   build:clang when:never (.gitlab-ci.yml:275-277) BESTAETIGT."*
7. **Auftrag des Strangs selbst** (ci-dual-r1r2-ergebnis.md:5-10): *"R1 = D-1: super
   build:clang Kill-Switch (when:never-Zweig, COMDARE_CLANG_MATRIX) entfernen, Job laeuft
   IMMER. R2 = D-2: die changes:-Drosseln der 4 test:unit*-Zellen entfernen (kein
   changes:-Skip, Owner-KERN 20.08. + KON22-01(8)). YAML-Wohlform-Probe lokal.
   Wirkungs-Nachweis: Job-Delta-Tabelle + Laufzeit-Kosten aus Pipeline-16052-Jobdauern (API
   lesend, Projekt 288). KEIN Push, Landung faehrt der Lead."*
8. **karte-memory-findings-106.md, Mandats-Einordnung** (Z.94-101): *"Mandat bereits
   ENTSCHIEDEN, nicht offen (Owner-KERN 20.08.)... NUR die REIHENFOLGE unten ist \"Vorschlag
   an den Lead\"... das macht sie NICHT owner-gated (Blanko-GO deckt Lead-autonome Ausfuehrung
   eines bereits erteilten Mandats)."* -- bestaetigt durch W2-ABFOLGE-DESIGN.md:690
   (F-VI-Gegenprobe-Liste, "BEREITS ENTSCHIEDEN/ERLEDIGT"): *"#106-Mandat Owner-KERN 20.08."*
   -- dieser Strang war zu KEINEM Zeitpunkt owner-gated.

---

## NICHT-GEFORDERT (ausdruecklich nicht Teil dieser Aufgabe -- keine Phantom-Funde)

- **Raenge 3-10 der `#106`-Erhebung** (K-1..K-13-Flaechen: PMC-clang, Sanitizer-Zwillinge,
  coverage-guard-clang, `analyse:thesis-data`-Umstellung, drei Tools-only-Configures,
  `registry-roundtrip`-clang-Zwilling, `is_original:relock`-clang, `parallel:matrix`-
  Vollausbau) -- eigener Traeger, Termin Di 25.08. oder frueher (karte-memory-findings-
  106.md:100-101; STAFFEL1-SYNTHESE.md:231-236, Bereich "#106-R3ff").
- **Neuanlage der Dual-Compiler-Zellen selbst** (`build:clang`, `test:unit:clang`,
  `test:unit:clang:debug`) -- diese existieren bereits aus einer FRUEHEREN, bereits gelandeten
  Runde (Task #56, 15.08., Ledger-Eintrag #56 "LANDE-ZUG CI-DUAL + LIZENZ KOMPLETT"; Branches
  `bau/ci-dual-ce`/`bau/ci-dual-emission`; Ledger KON66-03:4027 nennt zusaetzlich
  `bau/ci-dual-compiler @ 323101d1`). R1/R2 aendern NUR die Gating-Bedingungen an bestehenden
  Zellen, schaffen keine neuen.
- **T-11b 4-Zellen-Kombibau** (DESIGNPLAN-tdd:645, KON55: *"jede Landung ist erst gruen, wenn
  {clang, gcc} x {Debug, Release} = 4 Zellen... durchlaufen"*) -- Pflicht des LANDE-ZUGS (K17,
  Lead-Sache), NICHT dieses Strangs. Der Strang selbst begruendet explizit den Verzicht:
  ergebnis.md:32 *"kein Vollbau noetig (reine YAML-Aenderung, kein C++)"* und Z.87-88 *"KEIN
  Bau-Slot genommen: reiner YAML-Strang, kein Vollbau/Configure noetig (Slot-Protokoll greift
  nur vor Bauten)."*
- **M-6 clang-Warnungs-Review (W2-2)** -- eigenstaendiger, weiterhin OFFENER Pruefposten
  (STAFFEL1-SYNTHESE.md:150, Finding F-45). Design-Zeile W2-ABFOLGE-DESIGN.md:331 stellt klar:
  *"gruene ctest-clang-Zellen ersetzen das Review NICHT."* R1/R2 machen die clang-Zellen zwar
  unbedingt lauffaehig, das ERSETZT aber nicht das separate manuelle Warnungs-Review.
- **docs-only-+6-Jobs-Nachweis** -- bewusst als eigener NACHWEIS-POSTEN vertagt (STAFFEL1-
  SYNTHESE.md:139, Finding F-34), da erst in der ERSTEN docs-only-Welle NACH der Landung
  literal messbar. Der Strang selbst benennt dies explizit (ergebnis.md:152-156, Z.169-170:
  *"KEINE fuer R1/R2. ...NACHWEIS-Posten fuehren, nicht vorziehen."*).
- **Push/Landung selbst** (Merge nach `development`) -- ausdruecklich Lead-Sache
  (ergebnis.md:10, "KEIN Push, Landung faehrt der Lead"); dieser Strang liefert nur den
  landereifen Branch-Stand.
- **Bau-Slot-Protokoll** (mkdir-Slots, Bau-Treppe J-0b..ctest) -- entfaellt fuer diesen Strang,
  da reine YAML-Aenderung ohne C++-Vollbau (vom Strang selbst begruendet, siehe oben).
- **Vorlagen-Ebene ci-templates (Projekt 269), `.test-clang`-Ergaenzung** -- ausdruecklich
  Infra-/Fremdrepo-gated (karte-memory-findings-106.md Abschnitt D, Zeile D-7: *"269 ist fuer
  die Diplomarbeit-Strecke read-only"*), NICHT W2-baubar, NICHT Teil von #106 R1/R2.
- **`build:arm64-smoke` (K-7)** -- Infra-Vorbedingung (arm64-Runner) fehlt, owner-gated,
  ausserhalb dieser Welle (karte-memory-findings-106.md Abschnitt D).
- **Die 8 verbleibenden `.code-rules`-Konsumenten** (`toolchain:probe`, `lint:format`,
  `lint:static`, `analyse:thesis-data`, `visibility:tier-binaries`, `integration:smoke`,
  `manifest:provenance`, `prebackup:measurements`) -- deren Dualisierung ist Teil der Raenge
  3-10, nicht R1/R2 (ergebnis.md:62-65, Commit-Botschaft 223ab518 letzter Absatz).
- **Vorlagen-Pflege `retry: stuck_or_timeout_failure`-Deprecation-Warnung** -- vorbestehend,
  byte-identisch an der Basis, kein R1/R2-Gegenstand (STAFFEL1-SYNTHESE.md:138, Finding F-33,
  "Empfehlung: Vorlagen-Pflege im #106-R3ff-Fenster").

---

## SPANNUNGEN (Widersprueche zwischen Quellen -- juengere Schicht benannt, nicht glattgezogen)

1. **Wellenplan par.22.2/T-13 (aeltere Analyse-Schicht) vs. Ledger KON119-05/Owner-KERN 20.08.
   (juenger):** Wellenplan v2, Abschnitt "22.2 TEIL-GETRAGENE POSTEN", Posten T-13
   ("REGISTER-3b-HINWEIS-BUENDEL", Z.3320-3326) fuehrt den Kill-Switch-Befund (*"super
   build:clang Kill-Switch when:never/docs-only (D-2-Kandidat)"*) nur als GETRAGEN im
   "Register Abschnitt 3b (Z.166-169) mit 'W2-Triage'-Vermerk" und benennt als NACHZUG
   lediglich: *"die 3b-Zeile beim Di-25/#96 in den Docs-Zug uebernehmen (Ledger-Marker +
   D-2-Entscheid; 22.4 Z-11)"* -- d.h. dort ist der Gegenstand als reiner DOKUMENTATIONS-/
   Ledger-Nachzug ohne eigenen Bau-Traeger eingestuft. Die FRISCHERE Owner-Weisung KON119-05
   (20.08., selbes Kalenderfenster wie die Wellenplan-Nachtraege, aber inhaltlich neuer und im
   Rang hoeher) erhebt denselben Gegenstand zu einem vollwertigen 10-Rang-Fix-Auftrag (#106)
   mit SOFORTIGEM Bau-Traeger (Staffel 1). Nach der vorgegebenen Wahrheits-Rangfolge
   (Owner-Wort > juengere KON > Wellenplan par.21-23) GILT KON119-05/#106 -- die tatsaechlich
   gefahrene Code-Fix-Landung ist die korrekte, staerkere Erfuellung; T-13s Docs-Zug-Framing
   ist durch #106 UEBERHOLT, nicht verletzt. Das Audit sollte dies nicht als "T-13 nicht
   erfuellt" werten, da #106 T-13 der Substanz nach uebertrifft.

2. **Namenskollision "ci-dual"/"cidual":** Mindestens DREI verschiedene Gegenstaende tragen
   diesen String im Corpus -- (a) das FRUEHERE, bereits gelandete Task #56 "LANDE-ZUG CI-DUAL"
   (15.08., Branches `bau/ci-dual-ce`, `bau/ci-dual-emission`, laut KON66-03 auch
   `bau/ci-dual-compiler @ 323101d1`), das die Dual-Zellen ERSTMALS gebaut hat; (b) der
   W2-ABFOLGE-DESIGN-Parallelisierungs-Slot "S5 wt-ci-dual" (TEIL 3, Z.811: *"C-6->#3-Vorbau +
   C-7 (Mo)"*), der inhaltlich C-6 (#3/S-12-Traegerreihenfolge) + C-7 (B4-System-B-Umstellung/
   B1-Registry-Neubau) benennt -- thematisch mit CI-Config-Fixes UNVERWANDT, trotz aehnlichem
   Slot-Namen; (c) DIESER Strang/Task #106 R1+R2 mit Branch `bau/cidual` + Worktree
   `wt-super-cidual`. Das Audit sollte Funde/Zahlen aus (a) und (b) nicht versehentlich diesem
   Task (c) zuschreiben.

3. **Beleg-Luecke bei P-06** (kein neues `allow_failure`/`changes:` im Diff): Die Aussage steht
   im Ergebnis-Bericht und in der Commit-Botschaft nur als Fliesstext (*"KEIN changes:-Skip,
   KEIN allow_failure"*), nicht als eigener literaler Kommando-Beleg wie bei P-02/P-03 (dort
   je eine konkrete Grep-/Parse-Zahl). Kein Quellen-Widerspruch, aber eine Beleg-Luecke, die
   das Audit selbst schliessen sollte, z.B. `git show 223ab518 -- .gitlab-ci.yml | grep -n '^+'
   | grep -E 'allow_failure|changes:'` (erwartungsgemaess 0 Treffer).

4. **Push-Status zeitlich uneindeutig:** Der Strang-Bericht (Stand 21.08. Vormittag) sagt
   explizit *"Kein Push erfolgt"* und laesst die ci.skip-Sicherung als Kann-Option fuer den
   Lead offen; die STAFFEL1-SYNTHESE.md (selber Tag, spaeter) fuehrt `cidual` noch als
   *"einziges Backup-Loch"* (Z.28) und traegt die Sicherung als expliziten Phase-0-Schritt
   0a (Z.72) nach. Der Objektstand zum Zeitpunkt DIESER Erhebung (21.08. abends) zeigt jedoch
   bereits `origin/bau/cidual` == lokalem Tip 223ab518 -- die Sicherung ist also zwischenzeitlich
   nachgeholt worden (konsistent mit Task-#108-Notiz "Phase 0a/0b VOLLZOGEN"). Das Audit sollte
   den AKTUELLEN Objektstand pruefen (Branch ist origin-gesichert, aber NOCH NICHT nach
   `development` gemergt), nicht die zum Bericht-Zeitpunkt gueltige Momentaufnahme als weiterhin
   offen behandeln.
