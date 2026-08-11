# META-GEGENLESUNG: PLANABGRENZUNG + CODEX-VOLLREVIEW, AM OBJEKT
**Stand Di 11.08.2026, ca. 10:30 UTC. Dritte Stufe ueber (1) der Abgrenzung und (2) den Codex-/Meta-Befunden der zehn Pakete. Alles unten selbst gemessen, ausser wo woertlich "aus Bericht, nicht nachgemessen" steht. Werkzeuge: /usr/bin/grep (GNU grep 3.11), git, sed, g++ und clang++ (-std=c++23, je -O0 und -O2). Objektstaende zur Messzeit: super origin/development = 5837ff7f, ce origin/development = 68fbd930, wt-ce-messvisitor HEAD = 31240ac5, wt-ce-d37b HEAD = a881d468, wt-super-d3naht HEAD = 592fdd6f, wt-super-warn HEAD = afa5815a. Platte: 29 G frei von 251 G (df -h, gegen 2,3 MB im Berichtszeitraum).**

**Das eine Ergebnis vorweg, das alles andere ordnet:** Von den Codex-/Meta-Befunden halten am Objekt fast alle -- gefallen ist ausgerechnet einer der Meta-Stufe SELBST (P-STEMPEL Befund 7, "keine Plan-Grundlage": die Grundlage steht in Wellenplan :877-884). Und der einzige als UNGEPRUEFT-strittig markierte Punkt (S7-Baubarkeit) faellt per Compiler GEGEN die Meta-Stufe und FUER Codex. Die Abgrenzung haelt in 14 von 16 gezogenen Stichproben; ihre zwei Fehler sind beide von der Sorte "Korrektur-Einschub im Plan nicht gelesen" (D1g, An-13). Der Workflow war Breite, nicht F1-Fortschritt -- Abschnitt 4 traegt die Rechnung.

---

## 1 ABGRENZUNG, GEGENGELESEN

### 1.1 Stichproben "im Gegenstand" -- 6 von 6 gezogen, 6 halten

| Posten | Plan-Fundstelle, selbst gelesen | Urteil |
|---|---|---|
| D3-7b dreiseitig | Wellenplan :395-396 ("Restposten D3-7b: der dritte Modus fehlt, dreiseitig -- pruef_only erscheint nicht in der Bilanzzeile (ce profile_run_entry.hpp:1268)") und :429-430 (einer der fuenf Restposten) | HAELT woertlich |
| Stempel-Reihenfolge als F1-Blocker | Wellenplan :877-884, Korrektur-Einschub 10.08.: "Und die Reihenfolge ist verkehrt -- Owner 10.08. ... Das ist der einzige verbleibende Blocker vor F1" | HAELT woertlich -- und WIDERLEGT P-STEMPEL-Befund 7, s. 2.1 |
| ##27-31 Nachlauf + V-3/V-8 | :686, :805 ("27-31[CI, Nachlauf bis Di 18.08.]"), :904 (V-3), :909 (V-8) | HAELT; Frist Di 18.08., nicht F1 -- wie angegeben |
| ##23-Abnahme geschaerft | :800-801 ("Zeilenzahl je Blatt gegen Eingangs-CSV"), :921 (##23/##23b); Designplan :64/:67/:68 (T-1/T-4/T-5) | HAELT; Schliessungs-Belege von mir neu gemessen: 282def69 in super origin/development (merge-base rc=0), dcbcbb7d = commit im ce-Submodul UND Vorfahr von ce origin/development ("JA") -- die Stufe-1-Aussage "beide Haelften auf origin/development" stimmt |
| D3-3b | :399-402 (NR-1, "drei Dateien in EINEM Commit") | HAELT; f9ad63af, db6d086f, a4985738, 97fa074a alle als commit in super UND Vorfahr von origin/development (8 von 8 Ancestry-Pruefungen im ersten Messlauf) |
| D2-Familie Bestandsschutz | :113-127; :124 D2-G5 "GEBAUT" | HAELT; Branch w0a/d2-floor existiert lokal + origin, Spitze 7f3901fb (selbst: git rev-parse) |

### 1.2 Stichproben "ausserhalb" / "nie verlangt" -- Nullproben selbst gefahren

Greps ueber alle VIER bindenden Dokumente (GOAL 659 Z. / Wellenplan 1279 Z. / Designplan 311 Z. / Arbeitsweise 570 Z.), case-insensitiv, GNU grep:

```
Wall / Werror / Warnstufe            0 0 0 0   (P-WARN: bestaetigt)
Transposition / P-STEMPEL / K-1      0 0 0 0   (Literale bestaetigt -- Schluss NICHT, s. 2.1)
NOTICE                               0 0 0 0   (P-LIZENZ: bestaetigt)
gate_contribution / richtungsblind   0 0 0 0   (P-GLIED: bestaetigt)
Lizenz                               2 0 0 0   (nur GOAL :66-68 -- die SCHRANKE, kein Bauauftrag: bestaetigt)
DURCHSTICH (Positivkontrolle)        GOAL 3 / Wellenplan 9 case-sensitiv -- exakt die gemeldeten Zahlen
```

GOAL :427 traegt "additiv" tatsaechlich nur im CSV/xlsx-Kontext -- die P-GLIED-Einordnung haelt. GOAL :299-301 traegt den Workflow-Satz woertlich ("Ein Workflow ist kein Fortschritt, solange sein Ergebnis nicht in einem Bau-Paket auf dem kritischen Pfad gelandet ist").

### 1.3 Zwei Fehler der Abgrenzung -- beide aus der Korrektur-Einschub-Klasse

**(a) D1g ist NICHT offen.** "Fehlt noch" Posten 9 fuehrt D1g als unerledigten W0a-Rest ("im Plan nicht als erledigt markiert"). Der Plan selbst sagt das Gegenteil: Wellenplan **An-9 (:1015)** -- "GEMESSEN 10.08.2026 ... Configure-TRIPEL gefahren ... Sechs Zahlen, kein Unterschied ... Keine Zeile Bau-Logik geaendert. **Gelandet als super 41b20a16**." D1g ist als Messungs-/Doku-Posten geschlossen; er gehoert aus der Restliste gestrichen. Korrigierter W0a-Rest: **D1e, D1f, D1c, D2-G2, ##06-CI-Haelfte, ##07** (D2/D2-G1/D2-G3/D2-G4/D2-G5/D5-1/D1g erledigt; D2-G6-Status nicht erhoben).

**(b) Die ##25-Abhaengigkeit An-13 fehlt.** Wellenplan **:1019**: "Der Durchstich-Mini-Messwert ist mit D5-1-Kanon erhoben -- gesichert durch die Reihenfolge W0a-Lokalspur vor ##25; ohne diese Reihenfolge waere die erste Thesis-Zahl Ausschuss." Keine der drei Stufen nennt diese Kopplung. D5-1 ist laut Task #6 (completed) gebaut -- aus Task-Liste, nicht am Objekt nachgemessen.

**(c) Zusatzbefund zum Einschub selbst (traegt die F1-Risiko-Formulierung):** Der Einschub :877-879 behauptet "**Die Kette bis ##25 DURCHSTICH ist damit leer**" -- im SELBEN Dokument stehen aber ungestrichen in der Kette (:875): D1e, D1f, D1c, D2+D2-G2, D5-1, D3-1, D3-4+D3-5; und :596/:600-601 fuehren D3-1-Marker-Rest und D3-4+D3-5 als offene W0b-Posten. "Der einzige verbleibende Blocker" (:884) ist also eine Aussage ueber die GESTRICHENEN Glieder, nicht ueber die W0b-Postenliste. Die Abgrenzung uebernimmt den Satz in ihr F1-Risiko ("letzter benannter Blocker ... entschaerft") und listet zugleich zehn unbesetzte Posten -- die Spannung stammt aus dem Plan, sie gehoert aber benannt: der Einschub ist an dieser Stelle selbst ein Ueberdehnungs-Kandidat der Klasse, vor der die Aufgabenstellung warnt.

**(d) Kleinere Praezisierung:** Der Betriebsaufwand-Posten stuetzt sich auf "Ein-Blech-Serialitaet (Wellenplan :664, GOAL VII.2)". Beide Stellen existieren woertlich; die EIN-BLECH-REGEL bindet aber **Pipeline-Abnahme-Pakete** ("zweiter Slot nur lokal", GOAL :511; :87-88 "als meine Arbeitsdisziplin"). Zehn parallele LOKALE Bauten verletzen ihren Buchstaben nicht -- sie verletzen den Platz-Kanon aus dem Memory (ein ce-Bau > 6 G). Die Sache bleibt ein echter Betriebsfehler, die Plan-Zitierung ist eine Stufe zu stark.

---

## 2 DIE CODEX-/META-BEFUNDE -- GEHALTEN / GEFALLEN, JE AM OBJEKT

### 2.1 P-STEMPEL (Objekt: wt-ce-messvisitor, HEAD 31240ac5; Datei-SHA bestaetigt: sha256 der anatomy_fingerprint.hpp beginnt 10ffc0dc, wie im Bauplan)

| # | Befund | Urteil | Beleg |
|---|---|---|---|
| 1 | K-2 verdeckt K-1 am Literal-Viertargument | **GEHALTEN, jetzt COMPILER-BELEGT** | Probe p1: zwei Ueberladungen (4x sv + Pack als K-1, 3x sv + Pack als K-2), `static_assert(hexf("", "", "m", "") == 2)` -- **KOMPILIERT in 4 von 4 Konfigurationen** (g++/clang++ x -O0/-O2). K-2 gewinnt; die S4-Abnahme des Bauplans wuerde die reale Alt-Form (:227 dokumentiert) nie treffen |
| 2 | Makro-Rand bleibt positionsbasiert | **GEHALTEN** | anatomy_module_abi_v1.hpp:162-176 selbst gelesen: `COMDARE_ANATOMY_VERSION_STAMP_M(organ_lit, system_lit, measurement_lit)` reicht die Literale positionsbasiert an `anatomy_fingerprint_hex(organ_lit, kSC.view(), measurement_lit, ...)`; test_w10_system_cell_values.cpp:109 ruft die Makro-Form. Die Zahl "23 Vorkommen in 11 Dateien" habe ich nicht nachgezaehlt |
| 3 | adhoc_emitter: zweite Transpositionsflaeche | **GEHALTEN** | adhoc_emitter.hpp:86-89 selbst gelesen: drei typgleiche, defaulted string_view-Parameter; :124-138 konkateniert sie textuell in beide Makro-Formen (2-arg UND 3-arg) |
| 4 | GliedSterbenderString laesst const-string-Rvalue durch | **GEHALTEN, COMPILER-BELEGT** | :288 `concept ... = std::is_same_v<S, std::string>` + vier deleted-Ctors (:293, :363, :376, :404) selbst gelesen. Probe p2a (const std::string Rueckgabe) **KOMPILIERT** 4/4 -> Sperre umgangen, string_view-Ctor uebernimmt (Dangling); p2b (plain string) **FEHLER "call to deleted"** (Sperre wirkt sonst); p2c (remove_cv_t-Fix) **FEHLER wie gefordert** -- der vorgeschlagene Fix schliesst genau die Luecke |
| 5 | S7-Pin deckt char-const*-Flanke nicht | **GEHALTEN, COMPILER-BELEGT** | Probe p4: X mit explicit(string_view) + implizitem X(const char*): `!is_convertible_v<string_view, X>` bleibt wahr UND `take({"a"},{"b"},{"c"})` **KOMPILIERT** 4/4 -- Pin gruen, Positionsform wieder offen |
| 6 | S2-Ankerdrift (GliedCount) | GEHALTEN (gering) | kAnatomyFingerprintGliedCount = 9 steht am Objekt hinter einem Doku-Block bei ca. :416, nicht :413 |
| 7 | "P-STEMPEL hat in KEINEM der vier Dokumente eine Grundlage" | **GEFALLEN im Kern** | Die vier Grep-Literale stimmen (je 0 Treffer, selbst gefahren) -- aber Wellenplan **:877-884** IST die Grundlage: "measurement_line ist len=0 ... **Und die Reihenfolge ist verkehrt** -- Owner 10.08. ... Das ist der **einzige** verbleibende Blocker vor F1". Gegen-Grep selbst: "Stempel" = 5 Treffer Wellenplan, "Reihenfolge ist verkehrt" = 1 Treffer (:881). Das ist eine **Falsch-Null durch falsche Literale** -- exakt die Klasse aus dem Explore-Kanon, hier von der Meta-Stufe selbst produziert. Richtig bleibt nur: das ERSATZPAKET (Transpositions-Sperre als API-Haertung) steht in keinem Plan; der Paket-GEGENSTAND steht in :877-884, und die Stufe-1-Abgrenzung hatte ihn dort korrekt verortet |
| 8 | Referenzbasis weg, neu verankert | **GEHALTEN** | `ls -d /home/comdare/wt-ce-checkpoint /home/comdare/wt-ce-lint` -> beide "No such file or directory" (wt-ce-lint existiert nur noch als prunable-Eintrag der worktree-Liste); Neu-Anker wt-ce-messvisitor per sha256-Praefix 10ffc0dc bestaetigt |

**Der strittige UNGEPRUEFT-Punkt ist entschieden -- GEGEN die Meta-Stufe, FUER Codex:** Probe p3, `static_assert(!requires { glieder(B{}, A{}, C{}); });` ausserhalb jedes Templates, mit nicht-viablem Aufruf:

```
g++    -std=c++23: error: could not convert 'B{}' from 'B' to 'A'        (harter Fehler, -O0 UND -O2)
clang++ -std=c++23: error: no matching function for call to 'glieder'    (harter Fehler, -O0 UND -O2)
```

Ein nicht-viabler Aufruf in einem requires-Ausdruck ausserhalb abhaengigen Kontexts ist ein harter Uebersetzungsfehler, kein `false`. **S7 ist in der geplanten Form unbaubar** und braucht vor dem Bau eine abhaengige Verpackung (Hilfstemplate mit deduzierten Parametern oder eine is_invocable-artige Trait-Formulierung). Positivkontrolle im selben File: der viable `glieder(A{},B{},C{})`-Fall haelt als `requires`-true.

### 2.2 P-WARN (Objekt: wt-ce-warn-libs, HEAD 669f1526, Branch bau/p-warn-s1-nullkosten-ratsche, dirty 0 -- weiterhin NICHTS gebaut)

Alle 8 Befunde **GEHALTEN**; 6 davon selbst nachgemessen:
- Befund 2 (S1-0(b) unerfuellbar): `git merge-base --is-ancestor 7d4dd809 HEAD` -> **rc=0**; Gegenprobe gegen 6c010cdc -> **rc=1**. Selbst gefahren, exakt wie berichtet.
- Befund 3 (-Werror existiert doch): tools/vor_push_gate/CMakeLists.txt:41-42 selbst gelesen -- `-Werror=return-type -Werror=switch` im GNU|Clang-Zweig, Begruendung :37-40. Zusatz am Objekt: der Kommentar nennt "dieselbe Stufe-1-Haertung wie super Code/ci_wachen" -- die Nullaussage des IST-Explores faellt also noch an einer weiteren, super-seitigen Stelle (nicht einzeln verifiziert).
- Befund 4 (Wirkbreite falsch): compiler_flags.cmake:21-33 selbst gelesen (9 -W-Flags, PRIVATE, CONFIG-Ausdruecke tragen nur -O/-g); **einziger** Aufrufer von COMDARE_set_default_warnings ist gtest_setup.cmake:46 (repo-weiter Grep, 1 Treffer); tests/unit/CMakeLists.txt: **226** comdare_add_test- und **103** nackte add_executable-Zeilenanfaenge (beide Zahlen exakt wie im Bericht); 21 Dateien unter apps/+tools/ mit add_executable, 0 rufen die Warnfunktion; Selbstauskunft :3573-3576 woertlich vorhanden ("traegt also KEINE Hauswarnstufe; genau deshalb blieb dort ein -Wswitch ... unsichtbar").
- Befunde 5-8: Zaehlanker (226) bestaetigt; Vorher-Zahlen-Entwertung folgt aus Befund 2 (Ancestry selbst belegt); #71-Detail und die R-Zweig-Semantik nicht gebaut/nicht geprueft. Task #44 stuetzt unabhaengig: "-Werror global darf NICHT in einem Schritt".

### 2.3 P-CI (Objekte: wt-ce-stagetopo 68fbd930, wt-super-warn afa5815a)

Alle 8 Befunde **GEHALTEN**, 8 von 8 an den Ankern selbst gelesen:
1. Dritte Achse deterministisch rot: ce/.gitlab-ci.yml:510-512 (`-DCOMDARE_CE_PRUEFLINGE=...`) gegen :978 (test:unit ohne); pruefling_fixture/comdare_pruefling.cmake:20-26 registriert test_pruefling_fixture_ladung; ci_test_coverage_guard.sh:818-831 comm in beide Richtungen, jede Abweichung -> CE_FREMD_ROT=1. Der Job-Kommentar :508-509 benennt die gewollte Divergenz selbst. Task #80 ("DETERMINISTISCH rot -- ZWEI Ursachen") bestaetigt den Aufschlag unabhaengig.
2. Scheinbiss-Riegel diskriminiert nicht: arm() druckt den Namen in BEIDEN Zeilen (":221 `[ROT ]  $_name`" / ":237 `[ OK ]  $_name  (rc=..., und die Ausgabe nennt ...)`"), selbstbiss_fall :461 greppt nur `-qF "$4"`. Selbst gelesen; Fix bleibt trivial ("[ROT ]  "+Name).
3. T7 zaehlt Kommentare mit: :374 `grep -cF ... || true` ohne Filter; heute exakt 1 Aufrufstelle (:443, selbst gegrept) -- Luecke strukturell, nicht aktuell.
4. GoogleTests substringbasiert: zuweisungen() :100-107 sammelt jede Nicht-Kommentar-Zeile mit dem Schluessel-Substring, ohne YAML-Struktur. Statisch bestaetigt; Attrappen nicht selbst kompiliert.
5. Stale Kommentar: :1002-1005 steht WEITER im HEAD 68fbd930 ("der VERBRAUCHER fehlt noch ... 17 needs-Kanten") -- Verbraucher existiert (:526-533), Stufen getauscht (:44 test vor :45 contract), Kantenzahl 18 lt. eigener Wache. Drei Angaben, drei falsch -- im Paket, das gegen alternde Kommentar-Zahlen antrat.
6. Fremde-Pipeline-Zweig: awk :196-199 matcht nur die strichlose Form; `- project: ...` faellt in den generischen Listenzweig :193 -> UNAUFLOESBAR/rc=2 statt "gezaehlt, nicht bewertbar" (Kopf :33-35 verspricht das Gegenteil). Heute ohne lebende Kante.
7. Vererbte needs nicht materialisiert: .pmc :173-177 traegt `needs: ["lint:secrets"]` + stage: build; pmc:amd (:229) und pmc:intel (:238) erben per extends -- die zeilenbasierte Wache zaehlt die Kante einmal am Template. 18 gezaehlt, 19 effektiv.
8. stage-Parser ohne Ebenen-Pruefung: :142 `/^[ \t]+stage:/` trifft beliebige Einrueckungstiefe (Blockskalar/verschachteltes Mapping).

### 2.4 P-LIZENZ (Objekt: wt-super-d3naht -- SEIT DEM BERICHT GEBAUT: 592fdd6f "feat(lizenz): NOTICE + Geltungsabschnitt + Lizenz-Konsistenz-Wache", 09:34Z)

- Befund 1 (verfaelschter Apache-Text) **GEHALTEN, selbst gedifft**: `diff LICENSE Forschungsarbeiten/code/P01-ART/unodb/LICENSE` liefert exakt die zwei Bloecke -- Paragraph 6 ohne "reasonable and customary use in" (:140-141) und Paragraph 9 "Accepting Warranty or Support"/".. warranty or support" statt "Additional Liability" (:165-174) -- plus Copyright-Zeile :189.
- Befund 2 in aktualisierter Form: prt-art/LICENSE ist zur super-LICENSE nicht mehr byte-identisch (die super-Datei traegt jetzt 232 Zeilen inkl. Geltungsabschnitt), aber BEIDE tragen weiter die verfaelschte Fassung -- Verbreitungs-Nenner selbst gemessen: "Accepting Warranty or Support" in **genau 2 Dateien** des super-Baums (LICENSE + Code/external/comdare-prt-art/LICENSE), im ce-Baum **0**.
- Befund 3 **EINGETRETEN**: der Bau hat den Defekt konserviert und beurkundet -- NOTICE (144 Z.) sagt "der Volltext liegt in LICENSE", der Geltungsabschnitt haengt UNTER dem verfaelschten Text.
- Befund 4 **GEHALTEN**: lizenz_konsistenz.hpp:79-80 unveraendert `"Apache License"` / `"Version 2.0"` -- die gelandete Wache ist fuer alles unterhalb der Titelzeile blind und kann Befund 1 strukturell nicht sehen.
- Befunde 6/7 am Rand bestaetigt: `git status --porcelain` zeigt weiterhin ` M Code/external/comdare-cache-engine` -- der Rueckwaerts-Gitlink-Drift ist NICHT mitcommittet worden (die S0-Sorge "git add -A nimmt den Drift mit" hat sich nicht materialisiert; die S0-Vorflug-Regel wurde vom Bauer allerdings faktisch uebergangen, denn der Baum war nie leer).
- Befund 5 (changes:paths ohne NOTICE/LICENSE): aus Bericht, nicht nachgemessen; da der Bauplan .gitlab-ci.yml-Aenderungen verbot, besteht die Luecke mit hoher Wahrscheinlichkeit fort.
- **Neuer dringender Posten daraus: LICENSE-Text auf den kanonischen Apache-2.0-Wortlaut heben (2 Bloecke), prt-art nachziehen, Wache auf Inhaltsdigest statt Titel-Substrings -- als EIN Paket, VOR jeder Owner-Vorlage der Lizenzarbeit.**

### 2.5 P-D37B (Objekt: wt-ce-d37b a881d468; super wt-super-landung)

Alle 8 Befunde **GEHALTEN**; Kernpfad vollstaendig selbst gelesen:
- Diff-Umfang bestaetigt: `git diff --stat origin/development...HEAD` = 1 Datei, +12/-0 (profile_run_entry.hpp).
- Befund 2 (Abnehmer-Seite blind): ci/lauf_marker.sh:177 kennt nur `(provision-only)` (awk-Zeile selbst gelesen), :238-239 Default voll; ci/mess_ausbeute_wache.sh:247-251 macht modus=voll bei 0 Zeilen hart rot -- ein pruef_only-Lauf wuerde weiter als voll gelesen. `pruef[_-]only` in super ci/: **0 Dateien mit Treffern**; Gegenprobe `provision[_-]only`: **50 Treffer** (Berichtszahl 48 -- gleiche Richtung, Datei ist seither gewachsen).
- Befund 3 (zweiter Baupunkt): Allowlists :133 (`voll|provision_only|prune_only|auto`) und :188 (ohne auto) tragen pruef_only NICHT -- selbst gelesen.
- Befunde 4+5 (falsche Kommentare): :1272-1274 selbst gelesen ("BEIDE ZUSAETZE ZUGLEICH KANN ES NICHT GEBEN ... faellt ... fail-closed aus"); :233/:236 sind zwei freie bools (die Ausschluss-Behauptung steht nur als Kommentar daneben); Doppel-Token-Zeile traefe :177 -> provision_only -> :247-260 MILDER Zweig exit 0. main.cpp:1377-1388 aus Bericht, nicht nachgelesen.
- Befund 8 (stale Anker): lauf_marker.sh:11-13 zitiert ":1234/:1241", mess_ausbeute_wache.sh:254 druckt dieselben Nummern in die CI-Ausgabe; am Objekt liegen provision_ok/return bei :1292/:1299 -- beide Seiten selbst gelesen.
- **Eigene Zusatzpruefung, die die INERT-Aussage traegt:** der awk-Parser extrahiert felder tokenbasiert (measured=/resumed=/...-Muster), nicht positionsbasiert -- der neue `(pruef-only)`-Token korrumpiert KEIN anderes Feld. "Schadet nicht, behebt nichts" ist damit verifiziert, nicht nur behauptet.
- **Neuer Befund Landung, s. 3.8:** a881d468 ist auf KEINEM Remote-Branch.

### 2.6 P-GLIED (Objekt: wt-ce-messvisitor 31240ac5; 363f0022 ist Vorfahr von HEAD -- selbst geprueft)

- Befund 1 (Teilmengen-Skip meldet falschen Fingerprint) **GEHALTEN mit einer Anker-Praezisierung**: build_orchestrator.hpp -- `r.fingerprint = expected_fp;` (bei ca. :783) faellt VOR der Skip-Entscheidung (`dll_is_current` ca. :799), der Skip-Zweig korrigiert nichts (selbst gelesen; der Kommentar :779-782 dokumentiert die Kopplung sogar: "DERSELBE Wert reist im Ergebnis weiter -- der Mess-Resume-Stamp speist sich daraus"). Iterator: `binary_resume_stamp += "|fpr=" + b.fingerprint` (:2713); der b.skipped-gegatete Pfad :2781-2783 ist der LESE-/Resume-Ort, der SCHREIB-Ort ist :2977 (`sf << binary_resume_stamp << ...`) -- die Meta-Formulierung "wird bei :2781 geschrieben" ist um den Schreib/Lese-Unterschied unscharf, die Zwei-Identitaeten-Mechanik (Stamp-Praefix H(B) gegen Lager-Schluessel aus Sidecar H(A), messwert_key_source.hpp:93-95 selbst gelesen) haelt unveraendert.
- Befund 2 (Formwache nur Zeile 1) **GEHALTEN**: fingerprint_sidecar.hpp:166-171 selbst gelesen (fp_erste_zeile + Hex-Pruefung nur darauf); Kommentar :160-165 mit der Drei-Konsumenten-Zusage vorhanden.
- Befunde 3-5: aus Bericht, nicht nachgemessen (bvset-Multimengen-Detail, Snapshot-Historie, Koeder-Guete); V-7-Nachzug 363f0022 in HEAD selbst bestaetigt.

### 2.7 P-AGGREGAT (Objekt: wt-super-landung 5837ff7f)

- Befund 1 (fail-open) **GEHALTEN, semantisch selbst belegt**: ci/wide_aggregat.sh:174-175 traegt `while IFS= read -r rcsv; do [ -n "$rcsv" ] || continue` OHNE Lese-Restbedingung (selbst gelesen). Shell-Probe, literal:

```
printf 'zeile1\nzeile2_ohne_lf' | while IFS= read -r ...   -> "ohne Restbedingung gelesen: 1 von 2"
mit '|| [ -n "$z" ]'                                        -> "mit || [ -n ]: 2 von 2"
```

- Befund 2 (Fixture terminiert jede Zeile) **GEHALTEN**: test_ci_wache_wide_aggregat.cpp:293 `liste << eintrag << "\n"` selbst gelesen.
- Befund 3 (C++-Zwilling divergiert) **GEHALTEN**: wide_aggregat.cpp:49-51 zaehlt den letzten Satz ohne Schluss-Newline ausdruecklich mit (Kommentar woertlich vorhanden).
- Befund 8 (ca6d8af1 existiert doch) **GEHALTEN**: `git cat-file -t ca6d8af1` -> commit; `merge-base --is-ancestor` gegen den Submodul-HEAD -> Vorfahr. Die DIFF-DESIGN-Anweisung "Zitat nicht weitertragen" ist damit als Falsch-Null am veralteten Klon bestaetigt und gehoert zurueckgenommen.
- Befund 7 (wt-super-widefall weg): bestaetigt -- das Verzeichnis fehlt in der wt-Liste (8 wt-Verzeichnisse, keins heisst widefall).
- Befunde 4-6 (t1-Testmodell, Facade-Kommentar, CMake-Kopfzahl): aus Bericht, nicht nachgemessen.

### 2.8 P-WACHEN (Objekte: super + ce-Submodul in wt-super-landung)

- Befund 1 (falsche Notwendigkeits-Behauptung) **GEHALTEN**: Kommentar :1478-1481 woertlich am Objekt; beide Gegenbeispiele von Hand nachgerechnet -- (a) n=2, Referenz {100,1000}, Herausforderer {2000,50}: Verhaeltnis-Median (untere Mitte) 0.05 gegen Roh-Median-Quotient 0.5 -> trennt; (b) gleichsinnig {1,2,3} gegen {2,100,101}: 33.667 gegen 50 -> trennt. Der Monotonie-Satz gilt nur bei konstanter Referenz -- die Voraussetzung fehlt im Kommentar.
- Befund 2 (Nenner-Ansage unscharf) **GEHALTEN**: :609 verspricht "Grundgesamtheit ... aus der ERZEUGTEN DATEI", :761 bezieht N aus `datenzeilen_im_eingang(eingang)` -- derselbe String, der dem Pruefling uebergeben wird (selbst gelesen).
- Befund 3 (kein Lauf-Artefakt nach den Fixes) **GEHALTEN und verschaerft**: alle vier LastTest.log sind vom 09.08. (build-baseline 2026-08-09T10:00:36Z -- exakt die berichtete Blind-Vorfassung --, build-krit 10:17:44Z, build-test 10:05:57Z, build 12:35:07Z; Fix-Commits 10.08. ca. 07:00Z). Kein einziges Log stammt aus der Zeit nach den Fixes.

### 2.9 P-D2FLOOR (Objekt: ce origin/development 68fbd930, via git show)

- Befund 2 (hohle "2") **GEHALTEN, woertlich**: dev test_d2_abdeckungs_wache_nenner.cpp:545 = `EXPECT_TRUE(enthaelt(lauf.ausgabe, "2")) << lauf.ausgabe;` und der Pruefling druckt :505-506 IMMER "HOST-KLASSE ...: avx512f" + "COMDARE_HOST_RUNS_AVX2=..." -- die Ziffer 2 ist unvermeidbar in der Ausgabe.
- Befund 3 (Fehlbetrag ungedeckt) **GEHALTEN**: guard :589 druckt "UNTERSCHRITTEN um $(( CE_FLOOR - CE_GESAMT )) Test(e):"; `grep -c Fehlbetrag` ueber das dev-Skript = **0**.
- Befund 4 (alte Fehldiagnose nicht mehr verboten): der beanstandete Satz lebt woertlich in :277 (selbst gelesen); das Fehlen der Branch-Zusicherung auf dev aus Bericht, nicht einzeln nachgelesen.
- Nicht-Befund (Kern haelt) unabhaengig gestuetzt: Branch w0a/d2-floor existiert (lokal + origin, 7f3901fb), dev-Floor-Datei traegt die drei Klassenzeilen (avx512f/avx2/basis, selbst gelesen). NICHT mergen bleibt richtig; die vier verlorenen Zusicherungen sind ein eigener kleiner Testposten.

### 2.10 P-ABSCHRIFT (Objekt: wf_bc389245-884-7, existiert)

Zwei der Live-Befunde von mir REPRODUZIERT, literal:

```
sh scripts/ci_diff_ascii_width_guard.sh HEAD~1..HEAD --name-only      -> rc=0  "DIFF-HYGIENE-WACHE: GRUEN."
sh scripts/ci_diff_ascii_width_guard.sh --stdin --koeder-abc </dev/null -> rc=0 "DIFF-HYGIENE-WACHE: GRUEN."
```

Position-2-Blindheit und stdin-Verschlucken **GEHALTEN**. Der Objektspeicher-Befund (6) war der schwerste und ist jetzt ENTSCHAERFT -- s. 3.9. Befunde 4/5/7/8 (seit-basis-Nenner-0, Tag-Diagnose, Paritaets-Asymmetrie, veraltete Zeilenanker): aus Bericht, nicht nachgemessen; der Fund-Worktree und der Branch r7-wachen-divergenz -> bcf6bc97 sind von mir verifiziert (for-each-ref, cat-file).

---

## 3 WAS BEIDE STUFEN UEBERSAHEN -- EIGENE FUNDE

1. **Die Meta-Stufe hat ihre eigene Falsch-Null-Klasse produziert (P-STEMPEL Befund 7).** Vier korrekt gemessene 0-Treffer-Literale, aber der Schluss "keine Grundlage in den vier Dokumenten" ist am Objekt falsch: Wellenplan :877-884 traegt den Paketgegenstand als benannten F1-Blocker. Die Stufe-1-Abgrenzung war hier RICHTIG und die Stufe-2-Kritik falsch -- gegenlaeufig zum ueblichen Muster. Regel-Bestaetigung: ein Nichtfund braucht die Gegenprobe MIT SINNVERWANDTEN Literalen, nicht nur mit irgendeinem Positivmuster.

2. **Der S7-Streitpunkt ist compiler-entscheidbar und entschieden (Codex hatte recht).** Beide Vorstufen sagten "nicht kompiliert, kann es nicht entscheiden". Vier Konfigurationen (g++/clang++ x O0/O2) sagen: harter Fehler. Jede kuenftige "Normlesung, nicht kompiliert"-Markierung dieser Groesse gehoert mit einer 5-Zeilen-Probe-TU geschlossen -- Kosten hier: unter einer Minute, Ertrag: ein unbaubarer Bauplan-Schritt VOR dem Bau gefunden.

3. **Drei weitere Normfragen im selben Zug compiler-belegt** (K-2-Verdeckung, const-string-Luecke samt remove_cv_t-Fix-Validierung, Pin-Flanke) -- die P-STEMPEL-Befunde 1/4/5 sind damit nicht mehr Lesart, sondern Messung.

4. **Der Korrektur-Einschub :877-879 widerspricht seinem eigenen Dokument.** "Die Kette bis ##25 ist damit leer" steht gegen die ungestrichenen Glieder in :875 (D1e, D1f, D1c, D2+D2-G2, D5-1, D3-1, D3-4+D3-5) und gegen :596/:600-601. Wer nur den Einschub liest, haelt F1 fuer eine Ein-Blocker-Frage; wer nur die Postenliste liest, uebersieht die Blocker-Entschaerfung. Beide Stufen haben je eine Haelfte uebernommen, keine hat den Widerspruch benannt.

5. **D1g-Staleness und An-13-Luecke der Abgrenzung** (Abschnitt 1.3a/b) -- beide aus derselben Klasse: Plan-Annexe (An-9, An-13) sind Korrektur-Einschuebe, die die Wellen-Abschnitte ueberholen.

6. **T-6-Schwesterflaeche der while-read-Klasse: 8 von 8 super-ci-Skripten mit Leseschleifen tragen KEINE Lese-Restbedingung.** Selbst gemessen (Muster `while IFS= read -r X` gegen `... || [`): anhang_forward_core.sh 5 Schleifen, persist_sammler.sh 3, tests_registrierung_wache.sh 3, mess_ausbeute_wache.sh 2, frische_wache.sh 1, **lauf_marker.sh 1**, wide_aggregat.sh 1 (der bekannte Fall), zellkoordinaten_wache.sh 1 -- **17 Schleifen, 0 mit Restbedingung**. Ob je Eingang ein Schluss-Newline garantiert ist, ist UNTRIAGIERT; kritischster Kandidat ist lauf_marker.sh (ein letzter Marker-Eintrag ohne Schluss-LF fiele still weg -- genau die Modus-Erkennung, an der P-D37B haengt). Und: der ##20-B-Vorschlagstext im Wellenplan :519-524 traegt selbst dieselbe Schleifenform (dort fail-closed wirkend, weil die Zaehlung dann zu NIEDRIG ausfiele -- trotzdem dieselbe Klasse; beim Bau die Restbedingung gleich mitnehmen).

7. **V-8 auf die wide_aggregat-Selbstchecks:** beide Selbstchecks bestehen auf dem leeren Aggregat (0 == 0+0+0 und 0 == 0) -- die ##26-Formelklasse (N>=1 als Boden) fehlt genau dort, wo die Abgrenzung sie als offenen F1-Posten fuehrt. Dieselbe Heilform deckt beide.

8. **Die Landungs-Inventur fehlt in beiden Stufen -- und sie dreht die F1-Bilanz.** Selbst gemessen (`git branch -r --contains`):

```
ce-P-CI     68fbd930  origin/development + github/development   GELANDET
super-P-CI  afa5815a  origin/development + github/development   GELANDET
ce-P-GLIED  31240ac5  origin/development + github/development   GELANDET
ce-D37B     a881d468  KEINE                                     UNGELANDET
super-LIZENZ 592fdd6f KEINE                                     UNGELANDET (frisch)
b6a9fdb5 (super-D37B-Haelfte): nur lokaler Worktree-Branch      UNGELANDET
ce-LIZENZ   f6d13dfb  origin/bau/p6-lizenz-umsetzung            gepusht, nicht auf development
```

**Ausgerechnet das einzige plan-gedeckte F1-Baupaket (D3-7b) ist ungelandet**, und seine Basis ist weitergewandert (a881d468 sitzt auf 669f1526, origin/development steht auf 68fbd930 -- Merge noetig). Dazu die inerte Asymmetrie: ohne die super-Haelfte (lauf_marker + Allowlist + b6a9fdb5-Konfliktaufloesung) bleibt die gelandete ce-Zeile wirkungslos. "FERTIGE ARBEIT LANDEN" ist hier keine Ordnungs-, sondern eine F1-Frage.

9. **bcf6bc97 (r7) BERGUNG VOLLZOGEN -- nicht nur angemahnt.** Vorher selbst verifiziert: das Objekt existierte in KEINEM der vier Haupt-ce-Staemme (4 von 4 `cat-file -t` -> "Not a valid object name"), nur im worktree-eigenen Submodul-Gitdir; die Aufraeum-Maschine ist aktiv (5 prunable-Eintraege in der ce-worktree-Liste, Task #41 LANDE-RUNDE in_progress). Vollzug, literal:

```
git -C /home/comdare/wt-ce-stagetopo fetch <wf-Submodul> r7-wachen-divergenz:refs/heads/rettung/bcf6bc97-r7-wachen-divergenz
 * [new branch]  r7-wachen-divergenz -> rettung/bcf6bc97-r7-wachen-divergenz
Kontrolle: git -C wt-ce-stagetopo cat-file -t bcf6bc97 -> commit
           log -1: "bcf6bc97 2026-08-10 18:03:08 +0000 fix(wache): Auffangzweig fuer unbekannte Optionen + --seit-basis, gegen die Fassungs-Divergenz"
Zusatz:    /home/comdare/rettung-bcf6bc97-r7.bundle (35.696.147 Bytes)
```

Additiv, nichts geloescht, nichts gemergt. e36d2607 (super-Geschwister) liegt ohnehin im super-Hauptstore (selbst geprueft). Hinweis: wt-ce-messvisitor ist ein EIGENER Store (kennt bcf6bc97 weiterhin nicht) -- die Bergung liegt im stagetopo/d37b/warn-libs-Familienstore, also genau dort, wo die prunablen Worktrees haengen.

10. **Die Task-Liste ist die dritte veraltete Quelle neben Ledger und Plan.** Am Objekt widerlegt bzw. ueberholt: #79 ("r7 ENDGUELTIG VERLOREN -- Bauauftrag statt Rettung" -- doppelt falsch, Rettung liegt jetzt im Store), #29 (seit 97fa074a erledigt), #42/#53 (seit 282def69/dcbcbb7d gelandet), #64 ("und STAERKER" -- nur 1 von 5 Paaren ist woertlicher Ober-Umfang). Bestaetigt wird umgekehrt #80 (P-CI-Befund 1) und #44 (P-WARN-Etappenregel). Wer Auftraege aus Tasks schneidet, braucht denselben Kern-Explore wie bei Ledger-Zitaten.

11. **Triviale Fix-Hinweise, die beide Stufen schuldig blieben:** Scheinbiss-Riegel auf `"[ROT ]  " + Armname` greppen (eine Zeile); T7 mit dem awk-Kommentarfilter der Nachbar-Wache (tests_registrierung_wache R2) vereinheitlichen; mess_ausbeute-/lauf_marker-Allowlist um pruef_only in EINEM Commit mit der b6a9fdb5-Landung ziehen und die zwei stale Anker :1234/:1241 -> :1292/:1299 im selben Zug nachfuehren (sie stehen in der CI-AUSGABE, nicht nur im Kommentar).

---

## 4 DIE F1-LUECKE (F1 = Fr 14.08.; heute Di 11.08.)

**Plan-Definition (selbst verifiziert):** F1 ist zweigliedrig -- "Nenner-Ehrlichkeit + DURCHSTICH" (GOAL :494; VII.3 :523-529; Wellenplan :689, :802-803, :921). "Jeder Freitag steht allein" (GOAL :63, Wellenplan :41/:664).

**Bilanz des Workflows gegen diese Definition:** 10 Pakete, davon zum Berichtszeitpunkt 2 gebaut, inzwischen 4 mit Commits (P-CI, P-D37B, P-GLIED, P-LIZENZ), davon 3 gelandet -- aber vom ZWEITEN F1-Glied (##25) beruehrt: **0 von 10**. Vom ersten Glied gebaut: genau der D3-7b-Kern -- ungelandet und ohne super-Haelfte inert. GOAL :299-301 ("Ein Workflow ist kein Fortschritt, solange sein Ergebnis nicht in einem Bau-Paket auf dem kritischen Pfad gelandet ist") ist damit woertlich der Massstab, an dem dieser Workflow ueberwiegend NICHT Fortschritt war: er war Verhinderung (P-D2FLOOR-Regression gestoppt, P-STEMPEL-Ebene-1-Fehlbau gestoppt, 3 stale Auftraege erkannt), Rettung (bcf6bc97) und Wissen (8 Wachen-Defekte in P-CI, Apache-Textbefund) -- wertvoll, aber der Freitag braucht eine Tabellenzeile im Thesis-PDF, und dafuer arbeitet weiterhin niemand. Diese Gegenlesung selbst ist ebenfalls Breite; ihre Rechtfertigung ist die gemessene Fehlerquote der Vorstufen (Kern-Explore-Bilanz des Tages: 4 von 21 Definitionen trugen unveraendert; hier: 1 Meta-Befund gefallen, 1 Streitpunkt gegen die Meta-Stufe entschieden, 2 Abgrenzungs-Posten stale).

**Postenliste bis F1, korrigiert und geordnet (dringlichste zuerst):**

1. **##25 DURCHSTICH selbst** -- kein Paket, kein Besitzer. Blocker-Lage heute: die Stempel-Owner-Frage (MESS-Position) ist mit fertiger Vorlage vorzulegen; An-13-Abhaengigkeit D5-1 laut Task #6 erfuellt (aus Task-Liste); der Einschub :884 nennt sonst nichts mehr. **Ohne Besitzer bis Mi mittag ist F1 nur als Ein-Glied-Lieferung (Nenner-Ehrlichkeit) haltbar -- das waere gegen GOAL :494 eine halbe F1.**
2. **P-D37B LANDEN**: a881d468 auf 68fbd930er-Basis mergen und pushen; super-Haelfte (lauf_marker.sh:177-Token, mess_ausbeute-Allowlists :133/:188, b6a9fdb5-Konflikt) in EINEM Zug; stale Anker :1234/:1241 mitziehen. Erst dann ist der einzige gebaute F1-Posten real geschlossen.
3. **D3-4+D3-5** (Wellenplan :775-777, :921; GOAL :598): Inhalts-Gate je Batch, Testat-XOR, Bilanz A+B==C, Byte-Determinismus -- OV-16 ist laut GOAL Teil IX + Task #20 entschieden (allow_failure verboten, #278-Fix gelandet), der Owner-Blocker ist weg, der Bau fehlt.
4. **Task #80 aufloesen** (dritte Achse deterministisch rot) + die 8 P-CI-Wachen-Defekte einplanen -- sonst faehrt der W0b-Nachlauf (##27-31, Frist Di 18.08.) auf einer Wache, deren Riegel nachweislich nicht diskriminieren.
5. **##26** in korrigierter Formel (:27, :688, :921) -- und dieselbe N>=1-Klasse in die wide_aggregat-Selbstchecks (Abschnitt 3.7).
6. **##23-R1** (:421-424): xlsx-Blindheit der acht Profile am HEUTIGEN Gitlink neu auszaehlen, nicht annehmen.
7. **##21 zweite Haelfte** (:794-798, :927): object_stat am Store; MinIO-prod zusaetzlich owner-seitig.
8. **ergebnis:holen allow_failure** (GOAL :626-628; super .gitlab-ci.yml:1841): eigener kleiner Posten, OV-16-Entscheid traegt ihn jetzt.
9. **##20-B-Restbau** (:433-435, :516-530): eine ersetzte git-add-Zeile, offen allein an der Runner-git-Version; dabei die while-read-Restbedingung aus 3.6 gleich mitnehmen.
10. **W0a-Rest, korrigiert**: D1e, D1f, D1c, D2-G2, ##06-CI-Haelfte, ##07 (D1g gestrichen -- An-9/41b20a16; D2-G6-Status unerhoben). "Blockiert durch: W0a" (:691) gilt weiter fuer W0b.
11. **Designplan Band A W0b** (:82): 15 Posten / 40 h ("kein Zaehler luegt mehr ueber seine eigene Menge") -- von keinem der zehn Pakete beruehrt; Einzelstatus nicht erhoben.
12. **P-LIZENZ-Nachschlag** (neu, aus 2.4): kanonischen Apache-Text herstellen + prt-art + Digest-Wache -- kein F1-Blocker, aber vor jeder Owner-Vorlage der Lizenzstrecke.

**Kaskade unveraendert gueltig (selbst an den Zeilen geprueft):** W1 haengt an W0b (:698), ##47 kalibriert sonst ueber ungehaertete Gates (:704), ##23-R1 ist woertlich "Blocker fuer jede echte Kampagne" (:421), das Messfenster Sa 29.08. 06:00 frisst Verzug 1:1 (:710).

---

## 5 UNGEDECKT -- AUSDRUECKLICH

Von mir NICHT gemessen (je "aus Bericht, nicht nachgemessen", sofern oben zitiert):
- **Kein Bau, kein Testlauf:** ich habe keinerlei CMake/ninja/ctest gefahren. Alle Bau-/Suite-Zahlen (482 Registrierungen, 479/480, 21/21, 46 Tests, Codex' 478/479-Inventuren, Warnungszahlen) stammen aus Commits/Berichten. Die vier Compiler-Proben sind -fsyntax-only-Uebersetzungen von Wegwerf-TUs, kein Projektbau.
- **P-STEMPEL:** 48-Aufrufe-Klassifikation; 23 Makro-Vorkommen-Zaehlung; sota_catalog-Milderung.
- **P-WARN:** Codex' Nichtfund "keine Stelle loest -Wnon-virtual-dtor/-Woverloaded-virtual/-Wpedantic aus" (weiterhin die unbelegte tragende Annahme des Pakets); ext/-Fundstellen; Compiler-Semantik von -Werror=pedantic; #71-Mechanik; die awk-Zweitzaehlung der 226.
- **P-CI:** Bissprobe/Selbsttest nicht gefahren; gtests nicht kompiliert; GitLab-extends-Praezedenz nicht gegen Doku geprueft; 18-gegen-19 nur strukturell; Codex' Fixture-Behauptungen (Flow-Mapping-needs etc.) offen.
- **P-LIZENZ:** changes:paths-Luecke am HEAD 592fdd6f; Inhalt der neuen Wache/Tests jenseits der zwei Markerzeilen; Codex' CMake-/gitlink_parity-Anker; Overleaf/thesis-Seite.
- **P-D37B:** main.cpp:1377-1388; iterator :2322/:2376-Priorisierung; b6a9fdb5-Inhalt; Pfeil-Byte-Vergleich; "RUN_PROFILE fertig"-Einmaligkeit (Berichtszahl).
- **P-GLIED:** artifact_cache-Hydrierungsfolge; fingerprint_key_source/planner_status_reader; K1-K7-Koeder-Guete; Windows-Frage.
- **P-AGGREGAT:** t1-Testmodell gegen Facade (Befunde 4-6); voller /tmp/w29probe-Nachlauf (nur die Shell-Semantik reproduziert); Codex' Zeilen-Nenner (100/117/12).
- **P-WACHEN:** saemtliche Vendor-Anker (workbook.c/worksheet.c/utility.c); Lauf der 46er-Suite.
- **P-D2FLOOR:** Branch-Testkoerper (Zitate der Meta-Stufe uebernommen); dev :711-761-Bloecke nur punktuell; kein Mutant gefahren.
- **Abgrenzung:** Owner-Antworten-Posten D-3 (s2-Fassung), Ledger-Zitate (KON2-23ff., sSS 70.9, KON5-06), die zwei Vorlauf-Ergebnisdateien, geerntet_diff.json im Volltext (nur baubar.json-Nenner geprueft: dict mit 5 Eintraegen), Befund #76-Substanz (Riss = Sollverhalten), die 24 ce-Behelfs-CLI-Zaehlung.
- **D5-1/OV-16-Erfuellungsstand:** aus Task-Liste (#6, #20 completed) bzw. GOAL Teil IX -- nicht am Objekt.
- **Eigene Grenze:** die Bergung sichert bcf6bc97 im stagetopo-Familienstore und als Bundle; ob der wf_bc389245-884-7-Worktree noch weitere ungesicherte Objekte traegt (unversionierte Dateien, weitere lose Refs), habe ich nicht inventarisiert.

---

*Methodennotiz: dieser Bericht folgt der Meta-Regel, an der die Vorstufen gemessen wurden -- jede tragende Behauptung entweder mit eigenem Messweg (Kommando + literale Ausgabe) oder als ungeprueft markiert. Zwei Handlungen ueber das Lesen hinaus wurden vollzogen und sind oben literal belegt: die additive Bergung von bcf6bc97 (3.9) und sechs Wegwerf-Probe-TUs in /home/comdare/.claude/jobs/5a19728e/tmp/probe_stempel/ (2.1). Nichts wurde geloescht, kein Repo-Branch bewegt, nichts committet.*
