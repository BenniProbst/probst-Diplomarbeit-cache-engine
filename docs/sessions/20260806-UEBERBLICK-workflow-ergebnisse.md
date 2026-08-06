# UEBERBLICK: alle Workflow-Ergebnisse des 06.08.2026

**Zweck.** Dieses Dokument kippt die Ergebnisse aller Workflow-Wellen des 06.08.2026 aus dem
vorherigen Kontext in einen einzigen Ueberblick. Grundlage sind 24 Buendel-Verdichtungen ueber
den Backup-Baum `docs/sessions/backups/20260806-workflow-rohdaten/outputs/` (269 Dateien) plus
die zugehoerigen Journale.

**Lesekonvention — bindend fuer das ganze Dokument.**
Nahezu jede Zahl, jeder SHA und jede `datei:zeile`-Angabe hier ist eine **BEHAUPTUNG des
jeweiligen Agenten-Berichts**, nicht eine von mir nachgemessene Tatsache. Die Verdichtungen
selbst sagen das an vielen Stellen ausdruecklich. Ich kennzeichne:

| Marke | Bedeutung |
|---|---|
| `[B]` | Behauptung eines Berichts, nicht nachverifiziert |
| `[B2]` | Von zwei unabhaengigen Berichten deckungsgleich behauptet (hoehere, aber keine harte Sicherheit) |
| `[B!]` | Behauptung, die von einem anderen Bericht bestritten wird — siehe Abschnitt 4 |
| `[RAW]` | Stammt aus einer Roh-Werkzeugausgabe (grep/ctest/ls), nicht aus einer Agenten-Herleitung |
| `[?]` | Im Quellmaterial ausdruecklich als unklar/unbelegt markiert |

Ohne Marke steht nur, was strukturell aus dem Material folgt (z. B. Dateizaehlungen).

---

## 1. Was gelaufen ist

### 1.1 Uebersicht der Buendel

| Buendel | Inhalt | Dateien | Charakter |
|---|---|---|---|
| 1 | Codex-Focus PMC + nie angeschlossene Faehigkeiten | 2 | Agenten-Berichte |
| 2 | Bestandslog-/Lager-Kette + Zwei-Repo-Belegsuche | 2 | Agenten-Berichte |
| 3 | T2-A/F4-NB3 Bau-Transkript + perm/Topics-Vollerhebung | 2 | 1 Bericht, 1 Rohdaten |
| 4 | MEMORY.md-Kompaktierung + Graph-Umbau (abgebrochen) | 2 | Agenten-Berichte |
| 5 | Transkript-Provenienz + compact-Direktive-Suche | 2 | Rohdaten |
| 6 | super-Sub-Build-Entscheidung + wt-b-r4-ci Bau | 2 | Agenten-Berichte |
| 7 | B14-NB3-Diff + `generated/`-Zensus (abgebrochen) | 2 | 1 Diff, 1 Torso |
| 8 | Sicherheit: gitleaks + pre-secret-scrub | 2 | Rohdaten |
| 9 | Katalog P1–P8 + Rueckfuehrung wt-b14-golden | 2 | Agenten-Berichte |
| 10 | Korpus-Grep Minor-Bump + §66-NACHTRAG/PMC | 2 | Rohdaten |
| 11 | Ledger-Nachtrag "erster echter Pipeline-Lauf" + Bump-Politik | 2 | 1 Journal, 1 grep |
| 12 | B1-Scrub-Roh + Fuenf-Scope-Deep-Research-Welle | 2 | 1 Roh, 1 Grosswelle |
| 13 | LEER-1 | 20 | alle 0 Bytes |
| 14 | LEER-2 | 20 | alle 0 Bytes |
| 15 | STATUS-1 Pipeline/Push/Prozess | 20 | Rohdaten |
| 16 | STATUS-2 Bau/ctest/Heartbeat + 2 Kostenklammer-Abrisse | 20 | Rohdaten |
| 17 | Neuanker T2-A/B14-Kette | 15 | Agenten-Berichte |
| 18 | A1-Scheibe, E18-SNAP, honest-empty/Graph/Gate-8 | 15 | Agenten-Berichte |
| 19 | Kostenklammern, LB-6, Register, F3/F5, R4, Cacheline | 22 | Agenten-Berichte |
| 20 | LEDGER-1: Ledger-/Doktrin-Ausschnitte | 23 | Rohdaten (2 Duplikate) |
| 21 | AUDIT-1: Sweeps und Register | 27 | 3 Berichte, 24 Rohdaten |
| 22 | CI-1: CI/Runner/Aufraeumpass | 22 | Rohdaten |
| 23 | F3/F5/golden/Stempel/Topics-Struktur | 22 | Rohdaten |
| 24 | Diffs, Anklageschrift Kostenklammern, SOTA-Katalog | 19 | gemischt |

Summe der zugewiesenen Dateien: 269. Davon **40 leer (0 Bytes)**, davon 20 in Buendel 13 und
20 in Buendel 14. `[RAW]`

### 1.2 Die inhaltlichen Wellen

| Welle / Datei | Thema | Agenten | Ergebnis in einem Satz |
|---|---|---|---|
| `a9ef0d77beab825cc` | CODEX-FOCUS 1: PMC-Messkette | 1 | Lead-Befund in allen Teilen bestaetigt und verschaerft: der reale Voll-Mess-Pfad konfiguriert ohne `-DCOMDARE_ENABLE_PMC`, vier Wachen fangen es nicht. `[B]` |
| `a11735fcdd4f54b3a` | CODEX-FOCUS 2: gebaute, nie angeschlossene Faehigkeiten | 1 | Alle drei Lead-Befunde plan-gedeckt, zwei davon am Objekt widerlegt; kein Bau-Paket vor der Abgabe noetig. `[B]` |
| `a9a2b597006efcd8c` | CODEX-FOCUS 3: Bestandslog-/Lager-Kette | 1 | Vier von fuenf Posten entlastet; einziger echter Abstand: Lager-Basis-Tests Stufe 1 unvollstaendig, Stufe 2 und xlsx = null. `[B]` |
| `a3115bb12a2a9e09b` | Zwei-Repo-Belegsuche, fuenf Fragen | 1 | Von fuenf gesuchten Dingen existiert eines, eines teilweise, drei gar nicht. `[B]` |
| `a0a5982f72e650725` | GROSS-3: T2-A/F4-NB3 Bau | 1 | Drei Commits, Plan-Stempel-Wache gebaut, drei eigene Selbstkorrekturen (u. a. "clang-format nicht installiert" war falsch). `[B]` |
| `bo44aau0a` | perm-/Topics-Vollerhebung | — | 187 von 429 TUs mit GENONLY-Kanten, 10516 Kanten — Rohliste ohne Verdikt. `[RAW]` |
| `ac42a19adf597bd40` | MEMORY.md-Kompaktierung | 1 | 21192 → 18006 Bytes, Ziel <17,0 KB verfehlt, 197/197 Links erhalten. `[B]` |
| `acdd6a9b1415c4a28` | Graph-Umbau 2D/3D | 1 | **Vom User abgebrochen**; Kern-Zwischenfall: zwei Agenten schrieben zeitgleich in `wt-b-graph`. `[B]` |
| `batvn6yni` | Transkript-Provenienz | — | 4 Transkripte gezaehlt; Owner-Marker-Leck: 5x `suggestion_accepted|human` faellt durch die Extraktor-Regel. `[RAW]` |
| `b1uov0b3l` | compact-Direktive + "codex abgebrochen" | — | Negativ-Resultat: compact-Direktive weder im Ledger noch in Session-Docs. `[RAW]` |
| `af51918544612a92a` | super baut ce-Tests nicht mit? | 1 | Verdikt (a): dokumentierte Festlegung, redundant an drei Orten — aber Owner-Wortlaut deckt nur "strikt gruen". `[B]` |
| `a829a4fdfc5c3b359` | wt-b-r4-ci: Doppel-Job-Key + Version-Lock | 1 | Zwei Commits; Tripwire lief ~3 Wochen in keinem Lauf; danach `AXIS_ALGO_VERSION 1→2`. `[B]` |
| `beze0okll` | B14-NB3 Diff | — | Selbstbau-XML-Parser ersatzlos durch `xmllint` ersetzt, netto -192 Zeilen. `[RAW]` |
| `a007bfb20ae8ddc74` | `generated/`-Zensus | 1 | **Vor der Antwort abgebrochen**; widerlegt aber die Auftrags-Praemisse: 17 Flag-Header und 187/429 TUs haengen an der blossen Wurzel. `[B]` |
| `bnpj776mm.REDACTED` | gitleaks super-Repo | — | `leaks found: 776`, alle in EINEM Commit, zwei NDJSON-Dateien. `[RAW]` |
| `bjycgneji` | pre-secret-scrub | — | `refs/backup/pre-secret-scrub-20260802` nur als Markdown-Erwaehnung belegt, nicht per `git for-each-ref`. `[RAW]` |
| `a67b9019a6f610937` | Katalog P1–P8 lokalisieren | 1 | Katalog gefunden (Dossier 04.08., Z. 737–778); Umfang L; drei Owner-Entscheide blockieren vorgelagert. `[B]` |
| `adeb6e141404a7fd7` | Rueckfuehrung wt-b14-golden | 1 | Auftrag beruhte auf veraltetem Lagebild; Ruecksetzung haette zwei fertige Commits vernichtet — nur gelesen, additiv gesichert. `[B]` |
| `bp7x25tnb` / `bf69f66uh` | Minor-Bump / §66-NACHTRAG | — | Politik im Korpus als entschieden belegt (F4: codegen-Minor = CI-Tripwire hart-rot), Tripwire-Job aber laut GN-8 nie angelegt. `[RAW]` |
| `b4g6y1r2c` | Ledger-Nachtrag nachmittag-9 | — | Erster echter Pipeline-Lauf: 15022 ROT → 15025 SUCCESS (19/19); ce+super synchron auf `e7aa1244`. `[B]` |
| `be52dmp6f` | Bump-Politik/Pflicht | — | Schwerster Treffer: `kCebContractCodegenMinor` wurde trotz Format-3 NICHT gebumpt. `[RAW]` |
| `w76o2kmbd` | Fuenf-Scope-Deep-Research + Konsolidierung | 6 | Bau-Menge 524.288, Mess-Zeit 71,7 Tage gegen 40 verfuegbare, Fingerprint traegt die Mess-Defines nicht. `[B]` |
| Buendel 13/14 | LEER-1/LEER-2 | — | 40 Dateien 0 Bytes; `b*`/`w*` sind Shell-Lauf-IDs, keine Agenten-IDs — der Buendelschnitt war falsch. `[RAW]` |
| Buendel 15 | Pipeline-/Push-Statuszeilen | — | Pipelines 15037/15038/15039/15041 je 2/2, 15048 13/13; gitleaks 89 Funde bei EXIT 0. `[RAW]` |
| Buendel 16 | Bau-/ctest-/Heartbeat-Zeilen | — | Ein vollstaendig gruener Gate-Lauf (`b3vugb9k1`), zwei Wellen an der Kostenklammer verloren. `[RAW]` |
| `wf8v44w0f` | Teil-2-Neuanker Start | 3 | **STOPP vor Schritt 0** wegen Fremd-Session im selben Worktree. `[B]` |
| `wa3azpzk6` | Teil-2-Uebernahme | 3 | 5 von 6 Paketen fertig; Fable "LANDEBEREIT" vs. Codex "nicht freigabefaehig" (2 KRITISCH, 6 HOCH). `[B]` |
| `wapd7pd7p` | T2-A K2+F4 nach Spend-Limit | 1 | 2 Commits, HEAD `3a42bf90`; F4 produktiv inert mangels Host-Belegung. `[B]` |
| `wmhmvlkyd` | Batchplan-Aktivierungskette | 1 | Feld fehlte auf allen drei Facade-Schichten; **BEFUND A** (Plan-Ablage je Lauf statt je Pass) und **BEFUND B** (exit 1 im voll resumierten Fenster). `[B]` |
| `w1xzzb66u` | F4-BILANZ-Heilung | 1 | Befund B geheilt (`847c93c9`); Arithmetik zu Befund A in beide Richtungen korrigiert: bis zu 156 Paesse. `[B]` |
| `wsb78kl70` | T2-A-Nachbesserung | 1 | 4 Commits bis `6c300e68`; KRITISCH: Phasen-Zaehler band nicht an die Indexfolge. `[B]` |
| `w7y69czwo` | T2-A-NB2 Endstand | 1 | HEAD `a9a352bb`; ruegt den Vorgaenger: Code aller fuenf Befunde geschrieben, **kein einziger Biss**. `[B]` |
| `wtpunni0p` | B14-NB2-Verifikation | 1 | 6/6 Befunde gedeckt; Commit-Message "ce UNBERUEHRT" stimmt nicht mehr. `[B]` |
| `w44o34i7j` | B14/KF-6 Kartierung + Bau | 2 | 2 Commits; F-3-Regression im Mess-Tooling neu gefunden (Bau-Matrix-Faktor 3→1). `[B]` |
| `wbd3zs3qy` | B14-Kleinst-Nachbesserung | 1 | Fixup `d8073913`, 1 Datei, nur XML-Kommentartext; (D)-Luecke war groesser als gemeldet. `[B]` |
| `wc2xbd4ay` | Codex-Zweitlens B14/KF-6 | 1 | NICHT OHNE BEFUND: `N=2^17` in der XML nicht kodiert; leere XML wird als `OK` gemeldet. `[B]` |
| `wpzbpjmj1` | B14-Abschluss ce + Codex-Gesamtlens | 2 | Erster Gate-Durchlauf war falsches Gruen (404 statt 408); Patch-Kommentar ueberzeichnet den Ist. `[B]` |
| `wsmsmgp8o` | B14-NB3 super+ce | 2 | xmllint statt Selbstbau-Parser; Praemisse "xmllint bereits im Einsatz" trifft nicht zu. `[B]` |
| `w5u7xpiiz` | B14-NB4 VOLL | 2 | CLU-Blocker geheilt (durchgaengig 16 % statt 8/16/33/66 %); codegen-Minor 8.0→8.1. `[B]` |
| `wdz7tb4cm` | Hauptstrang P0→L1 | 3 | 8 ungelandete Pakete; `axis_version.lock` auf `development` bereits ROT; Trigger-Laufzeit 7,6 h vs. 45,5 h unbekannt. `[B]` |
| `wn5hdyswe` | A1-Scheibe Kartierung+Bau+Review | 3 | `0b5ed557`; Gegenprobe am Alt-Stand: SIGSEGV Exit 139. `[B]` |
| `wo64su8tn` | A1-NB Variante A | 2 | **STOPP** wegen Doppelbelegung `wt-b-a1`; nur lesender Fingerprint-Beweis. `[B]` |
| `wr5l6ao2d` | A1-NB Variante B | 2 | `62d8c715`, 26 Strategien `v1.0.0c`→`v1.0.1c`; Cache-Sichtbarkeits-Begruendung historisch falsch. `[B]` |
| `wmjsu2y29` | Codex-Zweitlens A1 | 1 | 3 Befunde; Semantikaenderung ist cache-unsichtbar; neuer Test zementiert das falsche Orakel. `[B]` |
| `w07qbvcad` | A1-NB2 | 1 | 6 Commits bis `fdfa68ee`; cf22 nicht gelaufen (kein clang-format auf der Maschine). `[B]` |
| `w7rrni258` | E18-SNAP Bau | 2 | `bda34e79`; load-bearing Fund: `.gitignore:49` haette `compile.log` stumm verworfen. `[B]` |
| `wvs8ulxqx` | Codex-Zweitlens E18-SNAP | 1 | 6 Befunde, 3 HOCH; Fable hatte LANDEBEREIT vergeben. `[B]` |
| `wx9unapoc` | E18-SNAP-NB | 2 | `1ae02cdf`, `core.sh` 356→873 Zeilen, Proben 46/0; Rest-Race bleibt. `[B]` |
| `wd626pkat` | E18-SNAP-NB2 | 1 | `5c4cf900`, `core.sh` →1489 Zeilen, Proben 91/0 + 56/0; 7 Restposten. `[B]` |
| `wqjxtc4jv` | honest-empty | 2 | `ba5e48eb`; pdflatex vorher RC=1 ohne PDF, nachher RC=0/3 Seiten. `[B]` |
| `wjpjjbho6` | Codex-Zweitlens honest-empty | 1 | 2 Befunde: echte gemessene 0 wird als "nie ausgefuehrt" klassifiziert. `[B]` |
| `wzmkd5hfd` | honest-empty-NB | 2 | `838612f3`; `executed`-Maske, drei Zell-Klassen, 156/156 `da_unit`. `[B]` |
| `wqxpvgwwt` | Gate 8 Thesis-Repo | 1 | `8970465d`, +199/-2, 23 neue Namen je Sprache, DE 202 / EN 192 Seiten. `[B]` |
| `won0hr04n` | "Baut die Thesis?" | 1 | Ja, beide Sprachen byte-identisch zu CI; aber 28 Abbildungs-Eintraege je Sprache ohne Datei, 17 davon stumm. `[B]` |
| `wgr8gvgza` | Thesis-Posten O-4 + Testoffensive | 3 | O-4 unentschieden (16 von 44 Fragmenten); drei Quellen nennen drei Bau-Mengen. `[B]` |
| `wif8xpy56` | Kostenklammer-Anklage | 4 | 10 Posten K-01..K-10 + 14 Codex-Posten; neue bindende Regel "KEINE KOSTENKLAMMERN". `[B]` |
| `ww7eb5key` | Restposten + Testoffensive | 3 | 6 K-Posten fehlten in der Anklageschrift; 17 `contract`-Targets liefen in keinem Job. `[B]` |
| `wx6bt8o71` | Rest-Kostenklammern | 2 | 4 bleiben offen (P-1..P-4), 7 Entlastungen, 3 Owner-Fragen. `[B]` |
| `w72yytmwm` | LB-6 Stufe 1 Befund+Plan | 2 | Delta = Ruecklese-Biss; drei Bausteine existieren, keiner vereint FS + Zeilenrueckgabe. `[B]` |
| `wv1iqrso9` | LB-6 Stufe 1 Bau | 2 | 3 Commits bis `3558466d`, Verdikt LANDEN; Rest-Race erstmals gemessen (79/200). `[B]` |
| `w010ykgp7` | OE-B vs. T2-A-Kostenklammer | 2 | ENTWARNUNG: zwei verschiedene "Stempel"; die vorgeschlagene Alternative 3 waere aktiv gefaehrlich. `[B]` |
| `wnfai1iau` | TODO-Register-Konsolidierung | 4 | Register P0–P4 + 17 adversariale Befunde B-1..B-17, 3 davon HOCH. `[B]` |
| `wwbu56lus` | Owner-Fragen filtern | 2 | Von 20 Rueckfragen 13 eliminiert, 5 echt offen, 3 neu; 6 Zitatfehler der Erst-Suche korrigiert. `[B]` |
| `wmphtm0ki` | Wellenplan-Vollbild | 2 | Gegenpruefung kippt den dominierenden Befund des juengsten Plans; zwei Gitlinks auf dasselbe Thesis-Repo. `[B]` |
| `wj5ygjg79` | Verlorene Buchfuehrung | 4 | 18 Positionen wirklich verloren (0/0 in Ledger und Register), 2 mit Vor-Trigger-Anspruch. `[B]` |
| `wzktivkld` | V-01/A15-Konsolidierung | 1 | 10 uebernommen / 4 superseded / 5 erledigt / 1 Owner; drei eigene Vorbefunde zurueckgezogen. `[B]` |
| `ww231ccuy` | P2-P8 + Trigger-Reste | 2 | G-E3 real offen (0 Zuweisungen), xlsx 0 Code, E14 0 Treffer; drei Statuskorrekturen gegen das Register. `[B]` |
| `wh14blymc` | A/B/C-Strang-Historie | 3 | Es gibt kein einziges stabiles A/B/C-System; 20 Positionen ohne Vollzugsbeleg. `[B]` |
| `wo2zqnqhb` | F3/F5/R4/Aufraeumpass/B12 | 2 | R4 erledigt und strenger als verlangt; AP-12 wieder angeklagt (in ce gesucht, lebt im super). `[B]` |
| `w2z8rp4xk` | F3 Scheibe-6 Weg a | 1 | Plan 689 Zeilen; groesstes Risiko R1: Rename schaltet die einzige Wache lautlos ab. `[B]` |
| `ws4t2r8ry` | F5 GOLDEN-UPDATE-FENSTER | 1 | Plan 580 Zeilen, 5 Owner-Vorlagen; Blocker: `allowed_variants` mit ungueltigen Registry-Namen. `[B]` |
| `wlrzgpeet` | P-PMC-1 | 1 | Bau-Anweisung entscheidungsreif; neuer Befund: `pmc_branch_misses` ist eine Spalte ohne Datenquelle. `[B]` |
| `wbckbar4m` | R4 CI-Abdeckungs-Invariante | 2 | `baaaea62` + `dcb2f08f`; 9 Tests liefen in keinem Job, Wurzelschnitt gebaut, 3 Beweise literal. `[B]` |
| `wnru437uo` | Build-Graph-Race | 1 | Fehlende `add_dependencies`-Kante; kalt 3/3 Fehlschlag; das CI-Gruen ist geliehen. `[B]` |
| `wm8gs10yi` | Versionierungs-Interface | 2 | Plan 815 Zeilen; CT-SHA-Antwort hart JA; Owner-Zusage nur in Format 3 erfuellt. `[B]` |
| `wouqomuwl` | Posten 92 Option A | 1 | `8065aec0`, 33 Insertions, comment-only literal bewiesen. `[B]` |
| `w2l331gg7` | Deep Research Cache-Line | 3 | prod1 hat 64 B auf allen Ebenen, vierfach belegt; fuer `cacheline` existiert keine Freigabe-Kette. `[B]` |
| `bslpfix3y` | Register + adversariale Pruefung | 6 | Konsolidiertes Register P0–P4 + 17 Befunde; drei eigene Befunde per Live-Pruefung zurueckgenommen. `[B]` |
| `awelche-probleme-und-…` | Wiederkehrende Fehlerklassen | 1 | Literal-64 ueberlebt die B14-Heilung eine Ebene weiter; A-Liste fiel aus der Konsolidierung. `[B]` |
| `abitte-beschreibe-mir-…` | Phase/Welle + A/B/C | 1 | Selbstkorrektur im selben Fork: erst "kenne den Grund nicht", dann nachgeschlagene Aufloesung. `[B]` |
| `bax1kkazq` | ANKLAGESCHRIFT Kostenklammern | 1 | 9 Kostenklammern am Objekt belegt, 4 zerstoeren geplante Arbeit; Planer nie ausgefuehrt. `[B]` |
| `bkdyvpq0p` | SOTA-Visualisierungskatalog | 1 | Acht Formen existieren produktiv; kein Kern-Paper nutzt 2D-Matrix-Heatmap als Hauptform. `[B]` |
| `bf8qegh15` | Neuanker-NB Bau + Review | 2 | `27adebc1` + `77095354`, Fable LANDEBEREIT; E2E-`.rsp`-Beweis steht aus. `[B]` |

**Abgebrochene / ergebnislose Laeufe:** `acdd6a9b1415c4a28` (User-Abbruch), `a007bfb20ae8ddc74`
(vor der Antwort abgebrochen), `w3v4qep1i` (B14-NB2, Spend-Limit, 253.572 Tokens verloren),
`w6m5i2vnw` (T2-A, Spend-Limit, 278.175 Tokens verloren), `wm4bkvxym` (TaskStop, Doppel-Instanz),
19 weitere stumme Laeufe ohne rekonstruierbaren Bezug. `[B]`

---

## 2. DIE OFFENEN BEFUNDE — das Checkheft

Sortiert nach Dringlichkeit in Gruppen. Innerhalb jeder Gruppe absteigend.

### A. Messvaliditaet — Sperrposten vor Phase 6

| Nr | Was ist offen | Wo | Naechste Handlung | Quelle | Status |
|---|---|---|---|---|---|
| A-1 | **PMC-Flag fehlt im realen Voll-Mess-Pfad.** Alle vier `cmake -B`-Emissionen des dynamischen Pfads setzen `-DCOMDARE_V32_ENABLE=ON`, aber `grep -c COMDARE_ENABLE_PMC` auf der Datei = 0. Default OFF; der Linux-PMC-Header ist `#if defined(COMDARE_ENABLE_PMC) && defined(__linux__)` geguardet ⇒ ohne Flag existiert auf Linux gar keine PMC-Quelle. | ce `libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:841,877,1194,1342`; `CMakeLists.txt:67` (Default OFF), `:69-77` (Linux-Gate) | Flag an `:1194` **und** `:1342` gemeinsam setzen (geteiltes `Code/build`, sonst Voll-Recompile je Job-Wechsel); super-Submodul-Bump zwingend, sonst wirkungslos. Paket P-PMC-1 / i-1. | `a9ef0d77`, `wlrzgpeet`, `bax1kkazq` (KK-1), `b4g6y1r2c`, `bhi82js7w` | `[B2]` — mehrfach unabhaengig am Objekt |
| A-2 | **Vierfache blinde Wache.** `pmc_seam_ok = delta.available \|\| counters_all_zero` — lauter Nullzaehler gilt als bestanden; der #37-Preflight (`ctest -L pmc`, 2 von 407 Tests) besteht ohne Flag und druckt `[PMC-TESTAT] pmc=ok`; `linux_perf_pmc_smoke` hat einen SKIP-Zweig; `pmc:amd/intel` belegen nur den Bau. | ce `m3v2_pmc_smoke.cpp:71`; `experiment_plan_director.hpp:1361-1364`; `linux_perf_pmc_smoke.cpp:63-68` | Fail-closed umbauen via `kPmcExpected`; SKIP→FAIL. | `a9ef0d77`, `bax1kkazq` | `[B]` |
| A-3 | **`allow_failure: true` auf dem Voll-Mess-Batch.** Solange die Zeile steht, ist auch ein roter PMC-Preflight unsichtbar. Kollision: Sichtbarkeits-Doktrin vs. §66-N2 "beide hart, kein allow_failure" (Ledger Z. 3499-3503) und #278 (Ledger Z. 1140). Ledger-Volltext: 20 Treffer, **keiner autorisiert diese Zeile**. | ce `experiment_plan_director.hpp:1332-1333` | **OWNER-ENTSCHEID O-B/O-PMC-1.** Vorschlag: Preflight in eigenen harten Job trennen. | `a9ef0d77`, `wx6bt8o71` (P-1), `wlrzgpeet`, `bael2mfr8` | `[B]` |
| A-4 | **L3/LL, L2, coherence, energy bleiben 0 auch MIT Flag** (I-PMC-2, Ledger Z. 2917; I-PMC-3/#187 ungebaut). Der Anhang kann "Cache-Misses" nur als L1D + dTLB zeigen. | ce `linux_perf_pmc_source.hpp` | **OWNER-ENTSCHEID O-PMC-3 / O-1:** nachziehen oder im Text deklarieren. Vier Thesis-Textstellen (je DE+EN) nennen bis heute nur den Schalter als Ursache: `06_fazit.tex:157-161/153-157`, `03_messsystem_prtart.tex:1051-1053/1036-1038` und `:1003-1004/989-990`, `05_evaluation.tex:179-182/177-179`. | `a9ef0d77`, `won0hr04n`, `bhi82js7w` | `[B!]` — siehe Widerspruch W-1 |
| A-5 | **`pmc_branch_misses` ist eine CSV-Spalte ohne Datenquelle.** Keine PMC-Quelle weist das Feld je zu; die einzigen Zuweisungen stehen in Tests. Die Begruendung fuer den Header behauptet das Gegenteil. | ce `cache_engine_builder_iterator.hpp:499` (Begruendungskommentar) | Entweder verdrahten oder Spalte entfernen; im Anhang nicht als gemessen fuehren. | `wlrzgpeet` | `[B]` — als neu, weder im Ledger noch in der ANKLAGE |
| A-6 | **Fingerprint traegt die Mess-Defines nicht.** Preimage = 8 Glieder, Toolchain-Glied = 9 Felder, **kein Mess-Define**. `COMDARE_MEASUREMENT_ON` ist ABI-wirksam ⇒ Release-Nachmessung erzeugt eine andere Binary mit identischem Fingerprint; `dll_is_current` ist genau ein Vergleich ⇒ **stiller Falsch-Skip**. Heute 0 `.fingerprint`-Sidecars ⇒ Fix kostenlos, danach 34,4 h Neubau. | ce `anatomy_fingerprint.hpp:462-472`; `toolchain_stamp_glied.hpp:246-248`; `profile_run_facade.cpp:274`; `abi_adapter.hpp:393`; `observable_tier.hpp:191,222`; `build_orchestrator.hpp:330-337` | **OWNER-ENTSCHEID R-3, vor dem ersten Batch.** Das Fenster schliesst mit der ersten geschriebenen `.fingerprint`-Datei. | `w76o2kmbd` | `[B]` |
| A-7 | **Peak-Spalte ist falsch etikettiert (P6).** `bytes_in_use_peak` wird aus `axis_stats[6][1]` (Momentanwert) befuellt und als "ECHT aus Observer" ausgewiesen. | ce `measurement_snapshot.hpp:106-107`; Fix-Ort `system_axis.hpp:339-346` | Vor der Messung klaeren — eine bereits vorhandene CSV-Spalte ist inhaltlich unwahr. | `a67b9019` (P6), `bax1kkazq` (KK-9) | `[B]` |
| A-8 | **Literal-64 ueberlebt die B14-Heilung eine Ebene weiter.** CLU-Konsument rechnet `cache_lines * 64`; unter KF-6 ergaebe das 8/16/33/66 % statt durchgaengig ~16 %. `line_bytes` wird im Snapshot nicht transportiert. Zweite schlafende Fundstelle. | ce `system_axis.hpp:336`; `node_width_config.hpp:54`; `measure.hpp:38`; `axis_05_memory_layout_cache_line_aligned.hpp:60` (`kCacheLine = 64`) | Nenner aus derselben Quelle ziehen (freier Slot `axis_stats[5][5]` — das ist ein Schema-Ereignis), fail-closed statt Rueckfall auf 64. In B14-NB4 fuer einen Pfad geheilt. | `awelche-probleme-und-…`, `w2l331gg7`, `w5u7xpiiz` | `[B2]` |
| A-9 | **`ns_per_op` im Workload-Pfad exakt halbiert** (`total_ns/(2·n_ops)`); 320×18×21 = 120.960 Zeilen des Voll-Laufs betroffen. Befund stammt aus Alt-Rohdaten; heutiger Status in den Buendeln **nicht** nachgewiesen. | ce `cache_engine_builder_iterator.hpp:196-198` | Status am HEAD pruefen, bevor gemessen wird. | `bbb1lj3en` (via `bslpfix3y`-Buendel) | `[?]` |

### B. Bau-Menge, Zeitbudget, Machbarkeit

| Nr | Was ist offen | Wo | Naechste Handlung | Quelle | Status |
|---|---|---|---|---|---|
| B-1 | **Drei Quellen nennen drei Bau-Mengen: 524.288 / 2.097.152 / 131.072.** Faktor 16, keine Zahl gemessen. `<run_options cap="131072"/>` ist **dekorativ** — `parse_experiment_profile` enthaelt null Treffer auf `run_options`/`cap`. Real gepinnt wird ueber `COMDARE_GN_TOTAL: "131072"`, aber **je System-Perm**. | Text `05_evaluation.tex:94-101` = 524288; XML `experiment_golden_kern.xml:285` = 2097152; FAHRPLAN:412-422 = 131072; `xml_config_parser.cpp:443-580`; `super/.gitlab-ci.yml:79`; `experiment_plan_director.hpp:989-990` | **T-0: Binaries zaehlen statt addieren**, 2–3 h; `cap` muss wirken oder laut abgelehnt werden. Liefert zugleich die Kalibrier-Stichprobe. **OWNER-ENTSCHEID R-4.** | `wgr8gvgza` (R-T1), `w76o2kmbd`, `wc2xbd4ay`, `wdz7tb4cm` | `[B2]` |
| B-2 | **Kalibrier-Stichprobe fehlt.** 131.072/24 = 5462 je Worker; bei 5 s/Binary ~7,6 h, bei 30 s ~45,5 h. Woertlich: "der Unterschied zwischen geht und geht nicht haengt an einer Zahl, die niemand gemessen hat". Steht in keiner aelteren Liste (V-06/GN-9 hat keinen Slot im Fahrplan-DAG). | — | ~200 Binaries kalibrieren, **vor** dem Trigger. | `wdz7tb4cm`, `wj5ygjg79`, `bnzucc1vg` | `[B]` |
| B-3 | **Mess-Zeit reicht nicht.** 216 Mess-Faecher/Binary × 524.288 = 113.246.208 Messungen × 0,1094 s = 143,4 Tage 1-Thread = **71,7 Tage auf 2 Lanes gegen 40 verfuegbare** (109,4 ms ausdruecklich Untergrenze). Empfehlung Weg C (320er-Auswahl voll + alle Binaries flach) ≈ 3,1 d. Bau selbst 34,4 h (uebernommen, nicht nachgemessen). | Basis: `measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv`, 16 Zeilen, Summe 1.750.887.462 ns | **OWNER-ENTSCHEID R-1: welche Teilmenge gemessen wird.** Ohne ihn ist der 15.09. ein Torso (~56 %). | `w76o2kmbd` | `[B]` |
| B-4 | **304 der 320 heutigen Mess-Binaries liegen ausserhalb des gebauten 2^17-Raums** ⇒ der Fingerprint-KERN traegt fuer ~95 % der Mess-Zeilen nicht. Aufloesung erzwingt entweder eine neue 320er (Bruch der Alt-Vergleichbarkeit) oder eine Erweiterung von `all_axes_golden` (zeit-untragbar). | Zaehlung via `/tmp/scope1probe/count.sh` | Owner-Entscheid an B-3 koppeln. | `w76o2kmbd` (Scope 1) | `[B]` |
| B-5 | **Mess-Seite ist nicht in 4096er-Scheiben geteilt.** Der Bau slict korrekt (`:1240-1252`), die Messung faehrt "das VOLLE `[0:COMDARE_GN_TOTAL)` … einmal je Batch". Der Owner-"Rueckfall mit Wiederaufnahme" hat auf der Mess-Seite kein Korn. | ce `experiment_plan_director.hpp:1367-1369` vs. `:1240-1252` | R-2 zusammen mit der XML-Trennung bauen. | `w76o2kmbd` | `[B]` — als in keinem Scope zuvor enthalten markiert |
| B-6 | **XML kann Bau/Messung heute nicht trennen.** `struct ThesisProfile` hat kein Feld; die Trennung lebt nur in Env (`COMDARE_GOLDEN_N_PROVISION_ONLY`) und einer Emitter-Asymmetrie. Das ist die vom Owner benannte Regression, am Objekt belegt. | ce `xml_config_parser.hpp:242-302` | R-2. | `w76o2kmbd` | `[B]` |
| B-7 | **M-1 Termin-Eichung.** `grep "15.09\|Freitag\|woechentlich"` ueber Ledger und `docs/` = **0 Treffer**; die gesamte P0–P4-Ordnung ist gegen den 08.08. gerechnet, die Frist ist der 15.09. mit Freitags-Lieferung. | — | Groesste stille Fehlerquelle der Planung: Ordnung neu gegen den 15.09. rechnen. | `w76o2kmbd` | `[B]` |
| B-8 | **M-4: vier entkoppelte `4096`-Literale ohne koppelndes `static_assert`.** Zusicherung steht im Prosatext statt in einer Wache. | ce `experiment_plan_director.hpp:610`; `batch_planner.hpp:51`; `planer_driven_build.hpp:60`; `source_catalog.hpp:205` | `static_assert` nachziehen. | `w76o2kmbd` | `[B]` |
| B-9 | **`observer_detail` skaliert nicht** (~97 LaTeX-Zeilen je Messzeile, keine Kappung) — im Voll-Lauf unbaubar. | ce `diagram_generator.cpp:2036-2059` | **Vor** Phase 6 entscheiden. | `w76o2kmbd` | `[B]` |

### C. Abgabe-Substanz — Thesis, Anhang A, PDF

| Nr | Was ist offen | Wo | Naechste Handlung | Quelle | Status |
|---|---|---|---|---|---|
| C-1 | **Zwei Gitlinks auf dasselbe Thesis-Repo.** `thesis/diplomarbeit` = `29a1700d` wurde nicht gebumpt — und genau dieser Pfad baut das PDF ⇒ **Gate 8 (23 Abbildungen) fehlt im gebauten PDF**. | super `.gitlab-ci.yml:560` | Einzeiler-Fix; muss aber jemand sehen. | `wmphtm0ki` | `[B]` |
| C-2 | **Anhang A: 28 echte `InputIfFileExists`-Aufrufe je Sprache, 0 als Datei vorhanden; 17 davon voellig stumm (`{}{}`)** — im PDF nicht als fehlend erkennbar. Anhang A traegt real 8 von 36 moeglichen Abbildungen. Erzeuger-Binary `Code/build-test/…/appendix-generator` ist STALE (03.08. gegen Quellen 06.08.). Nicht `.gitignore`-verursacht. | Thesis `anhang/{de,en}/A_measurements.tex` | **OWNER-ENTSCHEID O-4 / O-2:** Weg 1 (V-04 nach der Abgabe) mit Auflage einer 16. Zeile in `le_limitierung.tex` DE+EN, die "16 von 44" benennt. Weg 2b (Teilfuellung) wurde verworfen. | `won0hr04n`, `wgr8gvgza` | `[B!]` — Zaehlung 28/41 vs. 16/44, siehe W-4 |
| C-3 | **chktex-Blocker.** `chktex -q -n36 -n17` ohne `\|\| true` seit REV2 ⇒ **EXIT 123, 31 Warnungen ueber 8 Dateien** (Variante A 18, Kanal-Variante B 55), sobald Anhang A committet wird. Der `anhang:forward`-Kanal faengt es nicht ab (PDF-Gate prueft nur Baubarkeit). | thesis `.gitlab-ci.yml:45-63`; Ursachen `csv_to_latex.cpp:673,678,969,974,1319,1324,1369,1374`; `appendix_generator.cpp:207,212`; `diagram_generator.cpp:1921`; `ci/anhang_forward_core.sh:64,249-314` | Vor der Anhang-A-Landung heilen. | `w76o2kmbd` (Scope 4) | `[B]` |
| C-4 | **`axis_inventory.tex` wird geschrieben, ist in keiner `.tex` eingebunden.** Dieselbe Luecke wie C-1, nur aelter. | ce `appendix_generator.cpp:423` | **OWNER-ENTSCHEID:** in welchen Abschnitt. | `wqxpvgwwt`, `won0hr04n`, `bjxi5jgry` | `[B2]` |
| C-5 | **B12/xlsx-Geruest: 0 Zeilen Code.** 35 Treffer in 5 Dateien sind nur Datei-Endung in der Namens-Grammatik; `IErgebnisMappe\|InfoBlatt\|libxlsxwriter` = 0; `zlib\|minizip` in CMake = 0. SOLL existiert nur als Dossier (558 Z.). Owner-Terminierung: "vor der Messung, mit in die Abgabe". | ce `docs/architecture/20260803-a9_xlsx_writer_f3_soll_design.md` | Rueckmeldung an den Owner: verlangt zwei zu vendornde Bibliotheken; `libxlsxwriter` kann nicht lesen ⇒ eigener ZIP/XML-Reader oder zweiter Vendor. | `a9a2b597`, `a3115bb12`, `ww231ccuy`, `wo2zqnqhb` | `[B2]` |
| C-6 | **Thesis-Text-Pruefung 234-V-b:** keine Behauptung "Node-Shape-Varianten gemessen" zulaessig — es existieren keine Messreihen (golden-Liste 326 Zeilen, 0 Shape-Treffer). Risiko am aktiven Text: **0 Treffer**, also aktuell nicht vorhanden. | Thesis-Text | Nur beim Schreiben beachten. | `a11735fcd`, `won0hr04n` | `[B]` |
| C-7 | **Datenlage traegt zwei Katalog-Empfehlungen nicht:** `working_set_n` hat genau einen Wert (4096) ⇒ jede Sweep-/3D-Form ueber Fuellstand waere ein Ein-Punkt-Plot; `pruefling_type` durchgaengig `"-"` ⇒ keine `std::map`-Baseline-Zeile ⇒ D3 nicht bedienbar. Zusatz: die Registry kennt keinen `std_map`-Baustein — `std::map` ist Konformitaets-Oracle. | `measurement/20260726-164259-d03-…`, 16 Zeilen; `cache_engine_axis_registry.xml:9-13` | SOTA-Katalog-D3 korrigieren; Anhangs-Konsequenz entscheiden. | `acdd6a9b` | `[B]` |
| C-8 | **8 nicht eingebundene Alt-Kapitel je Sprache** mit veralteter "neunzehn Achsen"-Zaehlung, nur 1 mit Kopfvermerk. Kompilierte Kapitel sagen korrekt 18 / T0–T17. | Thesis-Repo | Aufraeumpass. | `won0hr04n`, `wzktivkld` | `[B]` |
| C-9 | **Schema-Versatz Alt/Neu:** Alt-Korpus 173 Spalten ohne `pmc_branch_misses`, neue Laeufe ≥ 174 — Alt/Neu-Vergleich muss projizieren. | — | Bei der Auswertung beruecksichtigen. | `w76o2kmbd` | `[B]` |

### D. CI-Wachen, stille Fehler, Testabdeckung

| Nr | Was ist offen | Wo | Naechste Handlung | Quelle | Status |
|---|---|---|---|---|---|
| D-1 | **`contract:axis-version-lock` doppelt definiert ⇒ Tripwire faktisch AUS.** Die letzte Definition (rules-gated auf `COMDARE_AXIS_LOCK_CHECK`, das nirgends gesetzt ist) gewinnt. Defekt seit dem Entstehungstag 19.07., ~3 Wochen in keinem Lauf. Empirisch: 31 Schluessel-Zeilen gegen 30 geparste Schluessel. | ce `.gitlab-ci.yml` — Zeilenangaben divergieren zwischen den Berichten (`:393`/`:574`, `:363`/`:522`, `:343`/`:502`) | Fix existiert ungelandet: `597ecffe` + `557d8023` auf `b-r4-ci-abdeckung`; danach ist mit **rotem** Ergebnis zu rechnen. Nach der Heilung nur noch eine Definition (`:447`) + `scripts/ci_yaml_key_guard.sh`. | `a829a4fdfc`, `wdz7tb4cm`, `bbb1lj3en`, `bkygjx34k`, `wx6bt8o71` | `[B!]` — Zeilennummern siehe W-6 |
| D-2 | **Blinder Fleck der neuen Schluessel-Wache:** wird der tragende Job `test:coverage-guard` selbst dupliziert und inert ueberschrieben, faehrt die Wache nicht — "innerhalb der Datei nicht loesbar". | ce `scripts/ci_yaml_key_guard.sh` | Loesung liegt ausserhalb der `.gitlab-ci.yml`. | `a829a4fdfc` | `[B]` |
| D-3 | **Tests, die in keinem CI-Job laufen.** Zwei Zaehlungen: 9 ungedeckte Tests bei 404 registrierten (`wbckbar4m`, live per `ctest --show-only=json-v1`) und 17 `contract`-Targets (`ww7eb5key`). Wurzel: der Ausschluss `-LE contract\|pmc` stuetzt sich auf eine Behauptung vom 06.07., die nie maschinell verifiziert wurde. Rueckfall: `1a111ed6` (13.07.) hatte bereits 21 CI-tote Tests geroutet. | ce `.gitlab-ci.yml`, Kommentar `:476-478` | R4-Wurzelschnitt ist gebaut (`baaaea62`, `dcb2f08f`), aber **ungelandet**; die 9 geheilten Tests sind lokal gruen, **in CI noch nie gelaufen**. | `wbckbar4m`, `ww7eb5key`, `wo2zqnqhb` | `[B!]` — 9 vs. 17, siehe W-5 |
| D-4 | **Weitere nie ausgefuehrte Suiten:** `test_08_appendix_generator`, `test_09_tex_formatter` fehlen im Sammel-Target `comdare_da_unit_tests`; `test_messreihen_workload` (#31-Regressions-Gate) wird weder gebaut noch ausgefuehrt (bare `add_test` ohne Label). | super, laut `docs/audits/20260712-full-line-review-REVIEW-BERICHT.md:219,228` | Ins R4-Manifest ziehen. | `bm7p9qiy6` | `[B]` |
| D-5 | **`xmllint`-Praesenz auf den CI-/baremetal-Runnern unbelegt.** `grep xmllint` ueber `.gitlab-ci.yml` + `ci/` + `Code/` = keine Fundstelle ausser Kommentaren. B14-NB3 macht `xmllint` zur harten FATAL-Pflicht (kein Skip). Landet das ohne Infra-Pruefung, sind die neuen Wachen ein garantierter CI-Rotmacher. | super `Code/tests/xml_canonical_utils.cmake` | **LANDEBLOCKER** — Infra-Pruefung auf prod1/prod2 und allen 8 Docker-Distros vor dem Scharfschalten. | `wsmsmgp8o`, `w5u7xpiiz`, `beze0okll` | `[B2]` |
| D-6 | **`all_axes_golden.profile.xml` ist nicht wohlgeformt** — `--` in Kommentaren, Zeilen 62, 64, 207. libxml2 lehnt die Datei komplett ab; die alte Regex-Wache lief darauf **gruen**. Interim: selbst-zurueckziehendes `PROFILE_ALLOW_COMMENT_TEXT_DEFECT=ON`. | ce `libs/cache_engine/.../thesis_profiles/all_axes_golden.profile.xml` | ce-Fix, danach das Flag aus `Code/tests/CMakeLists.txt` entfernen — sonst schlaegt die Verriegelung nach dem ce-Fix FATAL um. | `wsmsmgp8o`, `beze0okll`, `bode6hvdp` | `[B2]` |
| D-7 | **Fehlende `add_dependencies`-Kante ⇒ Build-Graph-Race.** `test_experiment_plan_director` wird angelegt, ohne `comdare_attach_generated_catalog()` zu rufen; der Header ist auffindbar, aber nicht geordnet ⇒ Flakiness statt lautem Bruch. Kalt **3/3 = 100 % Fehlschlag**, warm 0/20. **Das heutige CI-Gruen ist geliehen** — maskiert durch `COMDARE_TEST_PREBUILD_TARGET`, eine Zeile, die am 26.07. aus anderem Grund dazukam. | ce `tests/unit/CMakeLists.txt:3431-3454`; Fix: eine Zeile nach `:3454` | Einzeiler + Struktur-Haertung (eigener Include-Root + INTERFACE-Ziel). Vorbefund seit `LEDGER:3641` (02.08.) offen. | `wnru437uo` | `[B]` |
| D-8 | **R1 Stumm-Wachen-Risiko bei F3/Weg a.** Nach dem Rename zeigt `-DFIXTURE=` ins Leere ⇒ Skip-Zweig ⇒ `SKIP_REGULAR_EXPRESSION` macht daraus ctest-SKIPPED = kein Fehler ⇒ die einzige Wache des Neu-Paares waere lautlos abgeschaltet, `-L da_unit` bliebe gruen. | super `Code/tests/CMakeLists.txt:174`; `fixture_schema_subset_check.cmake:98-103` (SCHEMA/MASTER sind auf FATAL gezogen, FIXTURE nicht) | Haertung muss in **denselben** Commit wie der Rename. Reihenfolge: B14/NB3 → Weg a → F5. | `w2z8rp4xk`, `wo2zqnqhb` | `[B]` |
| D-9 | **`fixture_schema_subset_check.cmake:138`: leere/abgeschnittene XML wird als `OK` gemeldet** — stumm-gruener Wachverlust. Durch den xmllint-Umbau vermutlich adressiert, **nicht explizit gegengeprueft**. | super | Gegenpruefen. | `wc2xbd4ay` | `[?]` |
| D-10 | **Drei Wachen ohne Biss:** XXE-Sperre (0 XML mit `<!DOCTYPE` im ganzen Baum ⇒ die FATAL-Kante wird nie genommen); Axis-Version-Lock (`grep -rliE 'axis.?version.?lock\|AXIS_ALGO_VERSION'` ueber beide Test-Baeume = 0 Dateien); PMC-Flag-Vertrag (`COMDARE_ENABLE_PMC` 0x im Director). Ein gruener Lauf ist von einem inerten Job nicht unterscheidbar. | ce `xml_canonical_utils.cmake:135` u. a. | T-1/T-2/T-3 der Testoffensive. | `wgr8gvgza` | `[B]` |
| D-11 | **`lint:static`/cppcheck ist der strukturelle Rot-Macher** (Pipelines 14334, 14398, 14571) und das Template liegt in read-only-Cluster-Infra ⇒ jede Heilung ist code-seitiges Ausweichen, nie Ursachenbeseitigung. Beispiel 06.08.: cppcheck 2.21.0 meldet `syntaxError` auf gueltigem C++23, `g++-15 -std=c++23 -fsyntax-only` RC 0. | ce `.gitlab-ci.yml` | Werkzeug-Limit dokumentieren; Inline-Suppression `e7aa1244`. | `bels9fnzc`, `b4g6y1r2c` | `[B]` |
| D-12 | **CI-5 (-j/RAM-Politik je Runner-Tag) offen** — nur globales `CMAKE_BUILD_PARALLEL_LEVEL=6`; prod2 zeigte 36 % Job-Fehlerrate gegen prod1 11 %. | ce `.gitlab-ci.yml` | Per-Tag-Politik oder Split. | `b53n12ezv` | `[B]` |
| D-13 | **OD-7 Runner-Zahlen** — Soll: HEAVY `concurrency=1` (prod1 24 Worker), NORMAL 2×12 je Maschine. Ist laut einem Bericht 3/2 + heavy auf 16 gekappt; ein zweiter Bericht sagt, die Register-Zahl "3/2+16" sei selbst stale und real offen sei nur NORMAL (4/4 statt 2×12), HEAVY sei konform. Zusatz: Tag-Falle `baremetal` gegen `bare-metal` klemmt super-Jobs auf einen einzigen Runner (id=16). | Infra | Infra-Auftrag, ohne Vollzugsbeleg in diesem Material. | `wnfai1iau`, `ww231ccuy`, `bcm42zdx1` | `[B!]` — siehe W-7 |
| D-14 | **Heartbeat-Skript kaputt:** `[: 0\n0: integer expression expected` in zwei unabhaengigen Wellen; der Fortschritts-Vergleich vergleicht einen zweizeiligen String ⇒ jeder darauf gestuetzte Stillstands-Wachhund ist wirkungslos. Trifft direkt die Vollblick-Heartbeat-Regel. | Wellen-Skripte, Zeile 19 bzw. 15 | Reparieren. | Buendel 16 (`bsv6qw1w4`, `bz8fvvsa3`) | `[RAW]` |
| D-15 | **gitleaks: 89 Funde bei EXIT 0.** Nur 3 Funde sichtbar, alle `generic-api-key` aus einem Crawl-Datensatz; ob die restlichen 86 ebenfalls dort stammen, ist **unbelegt**. Ein gruener Exit bei 89 Findings maskiert echte Leaks. Zweiter Fall: gitleaks ohne Repo-Konfig meldete `generic-api-key` auf dem Testnamen `test_f3_lager_key_provider_iterator`. | `ext/traversal/P05-START/START/tests/resources/datasets/eu-2005.urls:763571,763573,763574` | Nachzaehlen; gitleaks immer mit Repo-Konfig **und** ueber den Push-Inhalt (`git log -p <remote>..HEAD`). | `busiw361a`, `b4g6y1r2c` | `[RAW]` + `[B]` |
| D-16 | **Folgeschuld D-10 (Ledger):** die 46er-Differenz lokale ctest-Faelle gegen CI-`test:unit` (Labels `contract\|pmc`) ist einmal zu belegen. | — | Beleg fuehren. | `bicvd3zbl` | `[B]` |

### E. Lager, Bestandslog, Resume, Plan-Ablage

| Nr | Was ist offen | Wo | Naechste Handlung | Quelle | Status |
|---|---|---|---|---|---|
| E-1 | **Kein einziges `.fingerprint`-Sidecar in Produktion.** Der Fingerprint-Provider ist opt-in ueber `COMDARE_BESTANDSLOG`; die Variable wird nur in zwei Tests gesetzt. Folge: Zaehler-Resume, F9/LB-0..LB-6 und Task #9 haengen an einer nie geschriebenen Blattidentitaet; jeder Lauf baut alle 131.072 Binaries neu. | ce `profile_run_entry.hpp:436` | **OWNER-ENTSCHEID N-1/O-C:** Provider Pflicht statt Opt-in. **Achtung:** E-2 wird scharf, sobald das repariert wird — beide muessen in derselben Welle landen. | `bax1kkazq` (KK-2/KK-8), `bbb1lj3en` | `[B]` |
| E-2 | **`bestandslog_active` prueft Funktions-Existenz statt Fingerprint-Identitaet**; daneben hat `mess_bestandslog_active` dieselbe Luecke. Der Gegenbeweis steht im eigenen Kommentar `:1194`. | ce `cache_engine_builder_iterator.hpp:1658-1661` und `:1665-1668` | Ein Fix muss **beide** fassen. Entlastend: alle 9 Konsumenten pruefen den Anker selbst fail-closed. | `bax1kkazq` (KK-4), `a9a2b597` | `[B!]` — a9a2b597 entlastet, bax1kkazq klagt an; siehe W-8 |
| E-3 | **BEFUND A: eine Plan-Ablage je Lauf statt je Pass.** Bis zu **156** Ueberschreibungen je Lauf (4 Perms × (1+17+21)); Plan-Resume greift nur bei genau einem Pass in allen drei Dimensionen. Host-Belegung allein bleibt wirkungslos. | ce `all_axes_golden.profile.xml:66-84` (17 axis_sweeps) | **OWNER-ENTSCHEID F7 unter 3 Optionen**, Empfehlung Option 1 bis Abgabe. | `wmhmvlkyd`, `w1xzzb66u`, `bpf36vyqg` | `[B]` |
| E-4 | **Ebene 1 im produktiven Host weiter INERT.** `pa.batch_plan_datei` = 0 Treffer im super; `LazyRunConfig::batch_plan_korn` ohne Produzenten ⇒ Korn-Heilung produktiv nicht ausloesbar; die Korn-Kette endet an `LazyRunConfig`, kein XML-Feld. Der super-Host-Bau ist spezifiziert (`Code/02_messung_driver/main.cpp:1351`, Einfuegepunkt nach `:1343`, Env `COMDARE_BATCH_PLAN`), aber **nicht gebaut**. | super `Code/02_messung_driver/main.cpp` | Bauen oder ehrlich als ungegatet ausweisen. | `w7y69czwo`, `wapd7pd7p`, `wmhmvlkyd`, `a9a2b597` | `[B2]` |
| E-5 | **G-E3 Host-Binder fehlt.** `mess_bestand_key_of\|doc_key\|versions` haben **0 Zuweisungen** repo-weit — die Messwert→Lager-Verdrahtung existiert nicht, der Schreiber (`dcbaa728`) ist toter Code. | ce | P2-Posten, **vor** Messbeginn. | `ww231ccuy` | `[B]` |
| E-6 | **Ebene-B-Push INERT** (`COMDARE_STORAGE_CACHE` 0 Zuweisungen) und neuer Riss: `from_env()` liest den Schalter nicht ⇒ "INERT" ist nicht hart garantiert. Dazu MAJOR: Pull gegen Raeumung nicht transaktional. | ce `artifact_cache.hpp:232-281`; `artifact_cache.hpp:494-514` mit Kommentar `:504-506`; `cache_engine_builder_iterator.hpp:1244` | R-6 braucht Owner-GO + eine df-Zahl; durchschnittliche `.so`-Groesse **unbelegt**, liefert erst der erste Batch. | `ww231ccuy`, `b1uov0b3l`, `w76o2kmbd` | `[B]` |
| E-7 | **`PlanFach::offen` wird geschrieben und validiert, aber nie konsumiert** — nichts erzwingt, dass die Zahl wahr bleibt. Ein Bericht wertet das als Defekt (KK-6), ein anderer als "abgeleitete Autoritaet auf groeberer Koernung", die vorgeschlagene Praefix-Abschneidung waere eine Regression. | ce `batch_planner.hpp:157-163`, `:163`, `:217-232`; `planer_driven_build.hpp:259-266` | **OWNER-ENTSCHEID:** bleiben (Empfehlung) oder Format-Bump `batchplan-v4`. | `bax1kkazq`, `a9a2b597`, `w7y69czwo` | `[B!]` — siehe W-9 |
| E-8 | **Formwache ist plan-global** — ein einziges nicht materialisierbares Atom setzt die gesamte Plan-Ablage inert. Im golden-Lauf unkritisch, bei Teil-Selektionen faellt der Plan-Resume komplett weg. Ausfallmodus all-or-nothing belegt (golden-320: 320/320 gueltig; `_abi4/5/6`: je 320/320 leer). | ce `cache_engine_builder_iterator.hpp:1265-1283` | Verfeinerung auf Fach-/Atom-Ebene, nach Abgabe, gebuendelt mit Host-Belegung. | `a0a5982f`, `a9a2b597` | `[B2]` |
| E-9 | **Vier Voll-Scope-Codex-Befunde am Resume-Kern bewusst nicht geheilt:** Bau-Zaehler vor dem Drain des async Cache-Push (`iterator:1583`); Mess-Zaehler strukturell kein Praefix (`iterator:2149`); zwei widersprueckliche Fortschritts-Wahrheiten (`planner_status_reader` ignoriert den Resume-Praefix); F4-Bau-Zaehler als zweite, fingerprint-unabhaengige Resume-Autoritaet. In `3a88eb88` teilweise geheilt — ehrlicher Preis: die W11-Zusage "Wall-Clock ~ max(Bau, Push)" gilt ab jetzt **je Fenster**, nicht ueber den Lauf. | ce `cache_engine_builder_iterator.hpp` | Folge-Welle; ETA-Rechnungen entsprechend korrigieren. | `bode6hvdp`, `bpslvuj7f` | `[B]` |
| E-10 | **Lager-Basis-Tests Stufe 1 unvollstaendig.** Attrappe und zeilen-verbatimer Leser existieren, aber in getrennten TUs; **keine TU liest einen mehrzeiligen Stempel aus einem Textdokument zurueck**. Der "Stempel" ist ein **einzeiliger** String. Stufe 2 (Binary-Stub) = 0 (14 SHARED-Test-Ziele, 0 mit `COMDARE_ANATOMY_VERSION_STAMP`, 0 dlsym-Leser). Erkennungs-Factory = 0 und **nirgends geplant** (A9 spezifiziert nur den Writer). | ce `test_lb0_lager_pfad_grammatik.cpp:12-13,542,547-549`; `test_lb1_…:8-9,522,528-529`; `knoten_heuristik_log.hpp:247-315` | Stufe 1 in `wv1iqrso9` gebaut (`ed9fca8e`, `5e6048ff`, `3558466d`) — **ungelandet**. Stufe 2 / Factory / xlsx danach. **OWNER-ENTSCHEID:** eine symmetrische Factory oder zwei? | `a9a2b597`, `a3115bb12`, `w72yytmwm`, `wv1iqrso9` | `[B2]` |
| E-11 | **Rest-Race im Bestandslog-Lock erstmals reproduzierbar gemessen:** in 79 von 200 Laeufen (Verifikation 69/200) waren mehr als ein Thread gleichzeitig im "Alleinschreiber"-Abschnitt, bis zu 3 von 4. Der Test sichert bewusst **keinen** wechselseitigen Ausschluss zu. | ce `bestandslog_lock.hpp` (Kopfkommentar) | Bewerten: ist der deklarierte Rest-Race tragbar? | `wv1iqrso9` | `[B]` |
| E-12 | **Zweites Churn-Leck (ce)** — `blocks[0..j-1]` bei Wurf in der Alloc-Schleife, bis 512 KiB je Fehlschlag; liegt **innerhalb** des gemessenen T6-Fensters, also Mess- statt Bau-Entscheidung. Die Deferral-Begruendung ist woertlich in Kosten-Nutzen-Sprache formuliert — genau das, was die Owner-Doktrin als Kostenklammer verbietet. | ce, alle drei Pfade | Lead-/Owner-Entscheid. | `wsmsmgp8o`, `w5u7xpiiz`, `wdz7tb4cm` | `[B2]` |
| E-13 | **Takeover-Sweep ohne Anker baut, registriert aber nicht** — Verschwendung, keine Falschaussage. | ce `cache_engine_builder_iterator.hpp:1702` | Log-Zeile + Umbenennung `bestandslog_transport_bereit`. | `a9a2b597` | `[B]` |
| E-14 | **`active_telemetry_is_silent()` gibt literal `false`**, obwohl 11 Profile `silent="true"` deklarieren — die XML-Aussage erreicht die Binary nicht. Golden-brechend, braucht das GOLDEN-UPDATE-Fenster. | ce `profile_run_facade.cpp:240-241` | KK-7 / P-4. | `bax1kkazq`, `wx6bt8o71` | `[B]` |
| E-15 | **`COMDARE_LEGACY_MESSREIHEN` = Phantom-Gate** (P-3/K-10); nur 3 Fundstellen. Korrektur des Anklaegers: `test_data_sets.xml` ist **nicht** leer ⇒ Posten schwerer als zuerst geschrieben. | ce `test_data_sets.xml:5`, `xml_config_parser.hpp:14`, `.cpp:147` | Nach golden-320-Subsumtions-Bestaetigung (V-5c). | `wx6bt8o71`, `bui13umv4` | `[B]` |
| E-16 | **Push-Observer (P-2/K-06):** `notify`-Slot existiert in der ABI, wird produktiv mit `nullptr` bedient; `COMDARE_CE_ENABLE_OBSERVER_PUSH:BOOL=OFF` in **allen drei** CMakeCaches. | ce `module_abi_v1.hpp:93-106`; `CMakeLists.txt:168-173`, Kopplung `:171-172` | **OWNER-FRAGE:** ersetzt PULL die Observer-Direktive vom 2026-05-25? | `wx6bt8o71`, `bui13umv4` | `[B]` |

### F. Sicherheit

| Nr | Was ist offen | Wo | Naechste Handlung | Quelle | Status |
|---|---|---|---|---|---|
| F-1 | **776 GitLab Runner-Registration-Tokens live in der super-Historie.** RuleID ausnahmslos `gitlab-rrt`, **alle in genau einem Commit** vom 02.08.2026 19:21Z, verteilt auf zwei NDJSON-Dumps (390 + 386). Scan: `RC=1`, 6226 Commits, 667.77 MB, 18,7 s. Keine Remediation dokumentiert. | super `44820451dad8f7668e6f996a670a963fc97c8276`; `docs/sessions/backups/20260802-e23-suchlauf-belege/e23/projects_all.ndjson`, `.../group_projects.ndjson` | **Tokenrotation + History-Rewrite.** Bis zum Beleg als kompromittiert behandeln. Quarantaene: `/home/comdare/backups-workflow/QUARANTAENE/bnpj776mm.output`. | `bnpj776mm.REDACTED` | `[RAW]` |
| F-2 | **Der Secret-Scrub vom 02.08. hat diesen Commit nicht erfasst** — Scrub und Leak-Commit liegen am selben Tag. Vollstaendigkeit des damaligen Scrubs fraglich; Re-Scan aller 4 Klone und des thesis-Repos fehlt. Der Lauf deckte nur das primaere super-Repo ab. | — | Re-Scan; Baseline-/Ignore-Abgleich. | `bnpj776mm`, `bjycgneji` | `[RAW]` |
| F-3 | **`refs/backup/pre-secret-scrub-20260802` als Rueckkanal auf die ungescrubbte Historie.** Existenz nur aus Session-Doku belegt, **nicht** aus `git for-each-ref`. Verbleib (lokal/remote/welche Klone) unklar. Ein Bericht nennt zusaetzlich `5ba3d03f` auf gitlab origin als "ueberwachten, nicht vergessenen Zustand". Fuer `refs/original/` existiert **0 Regel** im gesamten Doku-Baum. | super | **OWNER-ENTSCHEID O-5.** Loeschung erfordert explizites GO. | `bjycgneji`, `wwbu56lus`, `wif8xpy56` | `[?]` |
| F-4 | **PAT-Rotation #327 / V-11 — "Status unklar" seit 23.07.**, exponierter Vault-PAT. Als Sofort-Posten, deadline-unabhaengig markiert. Zusaetzlich: selbst angelegtes Project-Access-Token id=95 auf 289 (write_repository, Developer, expires 2026-09-30). | Infra | Rotation belegen. | `bode6hvdp`, `wzktivkld`, `blaz582sr`, `bllzbwyly` | `[B]` |
| F-5 | **Der gitleaks-Rohbericht selbst enthielt Klartext-Secrets**; die Datei traegt `.REDACTED`, das Token-Praefix `GR1348941` steht weiterhin drin. Ob weitere nicht redigierte Kopien im Workflow-Backup liegen: nicht geprueft. | Backup-Baum | Pruefen. | `bnpj776mm` | `[?]` |

### G. Landungen, Git-Topologie, ungesicherte Arbeit

| Nr | Was ist offen | Wo | Naechste Handlung | Quelle | Status |
|---|---|---|---|---|---|
| G-1 | **Drei bis vier Paket-Spitzen ohne Remote-Sicherung:** `4b38d072`, `557d8023`, `9934a7e5`, dazu `597ecffe`. "rescue-Ref ist keine Landung", aber ohne rescue-Ref ist es auch keine Sicherung. | ce / super | Rescue-Refs auf beide Remotes. | `wdz7tb4cm` | `[B]` |
| G-2 | **super-Pipeline noch nicht gruen.** Submodul-Bump `9a2ef3b2` (ce → `e7aa1244`) liegt committet und **ungepusht**; super-Format-Heilung des graph-Pakets (160 Verstoesse / 8 Dateien, `b35aea1b`) und `b14-super` stehen aus. | super | Landen. | `b4g6y1r2c` | `[B]` |
| G-3 | **`main`-Fast-Forward offen (ce und super)** — Auflage: Ziel fuer ce ist **`e7aa1244`**, nicht `b5e0e4e7`; `main` darf nie auf einen Stand zeigen, dessen Pipeline rot war. Owner-Ruege dazu: der main-FF zielte auf die Ledger-Spitze `030d2c62` statt auf den Paket-Merge. Regel: main-FF-Ziel = immer der gepinnte SHA des abgeschlossenen Paket-Merges. | ce / super | Owner. | `b4g6y1r2c`, `bx6t00oxd` | `[B]` |
| G-4 | **main-FF auf `030d2c62749d20553fc7e545ebc215e84e6ec78b` nur als "faellig" belegt, nicht als ausgefuehrt.** Keine Bestaetigungszeile im Material. | super | Extern bestaetigen. | `bxnqsje3s` | `[RAW]` |
| G-5 | **super→ce-Gitlink-Drift** (`47c4ef1d` gegen Checkout `b241a272`) + main-FF-Rueckstand ce 6 / super 10 / thesis 5 — die Bridges gaten `branch: main`, bauen also gegen alten Stand. | super | Gitlink nachziehen. | `w76o2kmbd` | `[B!]` — main-Divergenz siehe W-3 |
| G-6 | **Herrenloser Submodul-Drift** `Code/external/20260931-overleaf-diplomarbeit` (`29a1700d` → `ef448e4b`), unversioniert im Baum, gehoert zu keiner Landung. | super | Besitzer bestimmen. | `be52dmp6f` | `[RAW]` |
| G-7 | **E18-SNAP `5c4cf900`: archiviertes Codex-NICHT-LANDEN-Verdikt** fuer exakt diesen SHA, 4/5 Mindestanforderungen offen, `.gitlab-ci.yml`-Patch nicht angewandt ⇒ "persistiert nichts". Ein anderer Bericht nennt 11 HOCH + 6 MITTEL. | super | Klaeren, bevor gelandet wird. | `wdz7tb4cm`, `batjmwr7r` | `[B]` |
| G-8 | **Doppelbelegungen von Worktrees, alle unentschieden:** `wt-b-graph` (zwei Agenten, Snapshot nur unter `/tmp/wt-b-graph-collision-snapshot-114209.diff`, 15.522 B, fluechtig); `wt-b-a1` (zwei Agenten, 30 modifizierte Dateien, "wer landet?" nie beantwortet, Beweise unter `/tmp/a1_fp_*`); `wt-b2-neuanker` (Fremd-PID 546552). | siehe Spalte | Snapshots sichern, bevor `/tmp` geleert wird; Landungsfrage entscheiden. | `acdd6a9b`, `batvn6yni`, `wo64su8tn`, `wf8v44w0f` | `[B2]` |
| G-9 | **Zwei Wellen an der Kostenklammer verloren, ohne jeden Bericht** — B14-NB2 (253.572 Tokens, 140 Tool-Calls) und T2-A (278.175 Tokens, 109 Tool-Calls), Abbruch innerhalb von 15 Sekunden (10:50:11Z / 10:50:26Z), `result.bau = null`. Arbeitsstand liegt allenfalls in `wt-b14-golden` (`b14-golden-kf6`), `wt-b14-ce`, `wt-b2-neuanker` (`b2-neuanker-format3`). | Worktrees | **Sichten und retten, bevor die Worktrees angefasst werden.** | Buendel 16 (`w3v4qep1i`, `w6m5i2vnw`) | `[RAW]` |
| G-10 | **Unversionierte Artefakte in Loeschgefahr:** vier Wellenplan-Traeger, `Code/measure_out_d03/` (66 Dateien / 3,7 MB Rohmessdaten, **nicht** gitignored), mehrere Plandokumente (`20260806-PLAN-*`, 599 / 729 / 651 / 689 / 580 / 815 / 714 Zeilen), `docs/architektur/20260806-DEEP-RESEARCH-cacheline-…md` (580 Z.). `git clean` vernichtet sie. Bei geltender "Messdaten nie loeschen"-Doktrin sind die vier d03-Logs der einzige Zugang zur offenen PMC-Ursachenfrage. | super | Sichern/committen. | `wmphtm0ki`, `w76o2kmbd` (M-5), `wx6bt8o71`, `ww231ccuy` | `[B2]` |
| G-11 | **12 Kopien von `batch_planner.hpp`** ueber 7 Worktrees und 5 Temp-/Scratchpad-Baeume; Inhaltsgleichheit ungeprueft. Ebenso: vier parallele CMake-Bauverzeichnisse in `/tmp`, die einzige nutzbare `clang-format` (18.1.8) in einem fluechtigen `/tmp`-Pfad. | `/tmp`, Worktrees | Drift pruefen, aufraeumen. | `bmwlusoja`, `brnobb988` | `[RAW]` |

### H. Buchfuehrung, Prozess, verlorene Arbeit

| Nr | Was ist offen | Wo | Naechste Handlung | Quelle | Status |
|---|---|---|---|---|---|
| H-1 | **18 Positionen wirklich verloren** (0/0 in Ledger **und** Register): KK-5/P-1, O-A + Kalibrier-Stichprobe, A10, A11, A12/E-14 (NAS-Creds), E-07-Kriterien K1-K5/N1-N3, DEG-3, B2/#180, L19+FS4, D-12/GraphBfs, V41.F.2/F.3, #175, D-8, KF-8, D14b/D14c, W10-00, Chaos-Gate/#459, A9b. **Zwei tragen Vor-Trigger-Anspruch.** 15 weitere waren nur anders benannt — bei sieben haette eine naive Trefferzaehlung das Gegenteil behauptet. | super Ledger + TODO-Register | Nachbuchen; Commit `699edaa2` (Ledger-Nachtrag, 329 Insertions) ist **nicht gepusht**. | `wj5ygjg79` | `[B]` |
| H-2 | **Der Verlustmechanismus laeuft weiter:** die Disposition des einzigen neuen Messvaliditaets-Postens (KK-5) liegt in einer **untracked** Datei. Zwei neue Mechanismen benannt: M3 Namenskollision (A12 findet sich 17x als Substring im golden-CRC) — *eine Trefferzahl ist erst ein Buchungsnachweis, wenn die Treffer gelesen sind*; M4 Stellvertreterbuchung — "Definition liegt vor" ist nicht "Gate erfuellt". | — | Nachbuchungs-Disziplin. | `wj5ygjg79` | `[B]` |
| H-3 | **F9/LB-Paketschnitt nirgends verbucht:** `LB-[0-9]`, `OE-B`, `F9-Paketschnitt` je 0 Treffer im Ledger (5498 Z.) und 0 im TODO-Register; die Kette steht nur in einem Session-Dokument vom 01.08. Damit ist die Zusage "das 14-Tage-Fenster trug alles Aktive" fuer diese Kette widerlegt. | super | Nachbuchung + Vor-Trigger-Checkliste. | `a9a2b597`, `a3115bb12` | `[B2]` |
| H-4 | **A-Liste fiel aus der Konsolidierung**, waehrend die B-Liste derselben Quelle uebernommen wurde — und der Posten, der genau diese Uebertragung anmahnte (A15), war selbst der Verlust. Ursache: das Register ist per Konstruktion ein 14-Tage-Fenster ab 23.07.; der letzte Voll-Block davor (§55, `LEDGER:2829-3060`, 20.07.) wurde nie ueberfuehrt. **20 Positionen ohne Vollzugs- oder Supersede-Beleg**, 6 davon trigger-/abgaberelevant. | super Ledger `:4861`/`:4862` | §55-Reconcile. | `wh14blymc`, `awelche-probleme-und-…` | `[B]` |
| H-5 | **Owner-Marker-Leck im Wahrheits-Anker-Extraktor:** in `46375cdc` stehen 5x `suggestion_accepted \| origin=human`, 1x `typed \| origin=null` und 5x `system \| origin=null`. Die kanonische Regel (`typed` ∪ `queued`) faengt `suggestion_accepted` nicht — bis zu 6 potentiell verlorene Owner-Aeusserungen. | Transkripte | Nachzaehlen, nicht annehmen. | `batvn6yni` | `[RAW]` |
| H-6 | **compact-Direktive existiert in keiner persistenten Quelle** (Ledger leer, Session-Docs leer) — sie lebt nur im Transkript und geht bei jeder Kompaktierung verloren. | — | Persistieren. | `b1uov0b3l` | `[RAW]` |
| H-7 | **Task #21: Codex-Gesamt-Audit lief nie** (`codex_verfuegbar=FALSE`, ehrlich abgebrochen). Stand 06.08. nicht als nachgeholt belegt. | `docs/sessions/20260802-ZWISCHENSTAND-…:109` | Nachholen oder streichen. | `b1uov0b3l` | `[RAW]` |
| H-8 | **`.gitignore:49:*.log` als generische Verlustfalle** — fuer NB3 geheilt (Endung auf `.txt` gezogen, `9c858a73`, 20 Dateien/22.094 Insertions), aber die Regel besteht fuer jede kuenftige Gate-Ablage weiter. Dieselbe Falle traf E18-SNAP (`compile.log` waere stumm verworfen worden). | super | `!measurement/**/*.log`-Negation entscheiden. | `adeb6e141`, `w7rrni258` | `[B2]` |
| H-9 | **`mittag-5`-Ledger-Nachtrag existiert in keiner der 7 Ledger-Kopien** — die F4-BILANZ-Heilung ist nirgends verbucht. Ebenso: Ledger-Nachtraege `vormittag-30`/`-36` nicht auffindbar (0 Treffer in 4297 Zeilen). | super | Nachbuchen. | `w1xzzb66u`, `w07qbvcad` | `[B2]` |
| H-10 | **Zwei nicht gepushte, nicht gemergte Beweisketten-Commits im super:** `c1cdc0da` (NB4-WIP-Provenienz, 25 Dateien) und `9c858a73`. Ausserdem zwei getrennte Ablageorte der B14-Belege (NB3 auf `development`, NB4 auf `b14-golden-kf6`). | super | Zusammenfuehren. | `adeb6e141` | `[B]` |
| H-11 | **Nenner-/Pruefbereichs-Doktrin nicht in Werkzeugform:** derselbe Bau-Agent machte den Fehler "Zahl ohne Pruefbereich" in einer Serie zweimal; die Wache `scripts/ci_diff_ascii_width_guard.sh` existierte im Baum, wurde aber nicht gefahren. Neue Regelzeilen aus dem Pipeline-Lauf: **(6)** "ein gruenes Gate deckt nur seinen eigenen Gegenstand", **(7)** "Gate-Umfang ist repo-spezifisch" (ce 1731 gegen super 59 Dateien im selben Job). | — | Regel in Werkzeugform bringen. | `a0a5982f`, `b4g6y1r2c` | `[B]` |
| H-12 | **Keine Rueckverfolgbarkeit von Shell-Laeufen.** Es existiert im Backup kein Index Kennung → Kommando; der Wellen-Index (`journals/`) deckt nur `a<16 Hex>`-Dateien ab. 19 Laeufe sind unwiederbringlich stumm. Vor jeder Berufung auf eine `b*`/`w*`-Kennung ist zu pruefen, ob die Datei ueberhaupt Inhalt hat. | Backup-Baum | Backup-Design nachziehen. | Buendel 13, 14 | `[RAW]` |

### I. Struktur, Aufraeumpass, Nachrang

| Nr | Was ist offen | Wo | Naechste Handlung | Quelle | Status |
|---|---|---|---|---|---|
| I-1 | **GA-01 [BLOCK]: Fingerprint-Preimage nicht injektiv** — Konkatenation der Stempel-Glieder ohne Trenner, Kollisions-Demo literal gefuehrt. Trifft alle Lager-Keys. In Format 3 durch drei Wachen geheilt, aber die Heilung durchlief drei eigene Selbstkorrekturen. Overlay-Glied inhaltlich weiterhin leer. | ce `anatomy_fingerprint.hpp:69-79`; `lazy_adhoc_source_gen.hpp:268-275` | **OWNER-VORLAGE OF-M3-1** (Preimage-Trenner). | `bx7tcdjkc`, `bgzbboxbe`, `bs0hblt0i` | `[B]` |
| I-2 | **`kCebContractCodegenMinor` nicht gebumpt trotz Format-3-Bump** (MITTEL-HOCH, "VOR LANDUNG ENTSCHEIDEN"). Praezedenzen: A13-M4 bumpte 0→1, W10-M2 1→2. Folge: `build_version`, `.version`-Sidecar und `cache_key_prefix` bewegen sich nicht — und die Zusage "MinIO-Objekte bleiben additiv liegen" ist damit **falsch** (`push_tier_binary` schreibt denselben Key). Gegenlaeufig: B14-NB4 hat 8.0→8.1 gebumpt (`a402cfbc`), waehrend `LEDGER:4821` den B14-codegen-Minor-Entscheid weiter als Owner-offen fuehrt. | ce `anatomy_module_abi_v1_decl.hpp:331-338` | Entscheid-Nachtrag oder Zurueckrollen. **Zusatz: der CI-Tripwire-Job fuer den codegen-Minor ist laut GN-8 nie angelegt** (`ROADMAP.md:80`), obwohl F4 ihn hart-rot freigab. | `be52dmp6f`, `bp7x25tnb`, `bf8qegh15` | `[B!]` — siehe W-10 |
| I-3 | **`target_isa.numa_node`/`page` ohne Konsument und ohne Validierung** — `target_isa.isa` wird geprueft, diese nicht; Exposition heute 0 von 68 Profilen ⇒ kosmetisch, latent messvaliditaets-relevant. **Aber:** ein anderer Bericht widerlegt "null Leser" fuer `numa_node` generell (vollstaendiges RT-Erhebungspaket existiert). | ce `xml_config_parser.hpp:238-239`, `.cpp:130,132`; Wache nach `validate_profile.hpp:1071` | ~20-min-Fix fail-closed, oder nach Abgabe. | `a11735fcd`, `wmphtm0ki` | `[B!]` |
| I-4 | **`COMDARE_VARIANT_GATE` nie aktiviert, aber vollstaendig verdrahtet** und laut Fingerprint-Format 3 per F7-(b) funktional obsolet. **Einschalten waere eine Regression** (Scheinneubauten). Offen bleibt B10: 4+1-Beweise + G6(J-0..J-5) auf geeichtem Stand neu erbringen, Anker = Fingerprint-Mismatch, **nicht** `COMDARE_VARIANT_GATE=true`. Vor-Trigger-Pflicht, CI-Laufzeit. | ce `profile_run_entry.hpp:461-465,472-487`; `build_variant_sidecar.hpp:29-31`; `anatomy_fingerprint.hpp:287-289,427-438` | B10-Pruflauf. | `a11735fcd` | `[B]` |
| I-5 | **`generated/`-Zensus unvollendet:** 18 Loop-/Variablen-Bloecke ohne Endverdikt, kein Nenner-Satz. Praemissen-Korrektur an den Auftraggeber: die blosse Wurzel ist **kein** Copy-Paste-Ballast — 17 generierte Achsen-Flag-Header und 187/429 TUs haengen an ihr; ein pauschaler Streich-Refactor waere eine Regression. Viertes Leck-Muster `COMDARE_MCE24_INCLUDES` unbewertet; `comdare_set_platform_defines` ungeprueft. | ce `tests/unit/CMakeLists.txt:2086` (8 Konsumstellen); `cmake/compiler_flags.cmake:46` | Zensus abschliessen, bevor eine Bau-Anweisung darauf gestuetzt wird. | `a007bfb20` | `[B]` — Bericht abgebrochen |
| I-6 | **187 TUs / 10516 GENONLY-Kanten unausgewertet** — legitime gegen verletzende Kanten nicht getrennt; die `429` in Zeile 1 ist ein Nenner ohne Legende. | Rohliste `bo44aau0a` | Auswerten. | `bo44aau0a` | `[RAW]` |
| I-7 | **AP-13: die Aufraeum-Kandidatenliste enthaelt keinen einzigen Alt-§75-Kandidaten** — *eine Konsolidierung, die eine Quellenklasse auslaesst, liest deren Schweigen als Abwesenheit.* Bestand: 7 Waisen-TUs, Nicht-ASCII-Altbestand (Zahl umstritten: 1132 Dateien mit 83.224x U+2500 gegen 962), Temp-Kollision, Stamp-Write ohne `flush()/good()` (`cache_engine_builder_iterator.hpp:1790-1791`), SA-Dock ohne `dock_version()`. Gegenlaeufig bindend: die §75-**NICHT**-Kandidatenliste (Hybrid-Freihaltung, HY-D2). | ce / super | Aufraeumpass nach allen Aufgaben. | `wo2zqnqhb`, `bjxi5jgry`, `b3vfalq3t`, `bx7tcdjkc` | `[B!]` — 1132 gegen 962 |
| I-8 | **AP-12 wieder angeklagt:** die Vor-Erhebung meldete `measure:smoke`/`measure:golden-320` als "0 Treffer, bereits weg" — gesucht wurde nur in ce. **Beide leben im super** und tragen das **einzige `-DCOMDARE_ENABLE_PMC=ON` des Mess-Pfads**. | super `.gitlab-ci.yml:651`/`:738`, Flag an `:677`/`:768` (auch als `:664-668` DEPRECATED-Block genannt) | Historie behalten oder im §75-Aufraeumpass entfernen — **erst nachdem A-1 gebaut ist**. | `wo2zqnqhb`, `a9ef0d77` | `[B2]` |
| I-9 | **`topics/`-Stubs seit 05.07. eingefroren** (183/190 Byte Forwarder mit `#include <axes/…>`), waehrend die Substanz in `axes/` weiterwandert. Stichprobe umfasst nur 2 Dateien — keine Aussage, ob **alle** `topics/`-Eintraege diese Form haben. | ce `topics/` | Drift pruefen. | `b4l2upgdu` | `[RAW]` |
| I-10 | **Deprecated-API noch in Benutzung:** `run_methodology_for_ids(std::vector<std::string> const&)` erzeugt eine Deprecation-Warnung im Vollbau; Aufrufstelle im Log abgeschnitten. Dazu `-Wunused-result` in `test_experiment_plan_director.cpp:2254/:2256`. | ce `libs/cache_engine/include/cache_engine/measurement/run_methodology_registry.hpp:140` | Aufraeumpass. | `by3qylb3q`, `buigc7s9r` | `[RAW]` |
| I-11 | **Doku-Drift im Code:** `linux_perf_pmc_smoke.cpp:4` behauptet eine `COMDARE_ENABLE_PMC`-Registrierungsbedingung, die `tests/unit/CMakeLists.txt:3553` nicht hat. Dossier-Zeilendrift generell: P2-Schreiberort im Dossier `abi_adapter.hpp:1267-1269`, am HEAD `:1360-1362`. | ce | Nachziehen; Dossier-Zeilen generell als gedriftet behandeln. | `a9ef0d77`, `a67b9019` | `[B]` |
| I-12 | **Graph: 2 Nicht-ASCII-Zeichen (`§`)** in `diagram_generator.cpp:1718/1756`; Voll-Korpus-PDF-Gate aus. | ce | ASCII-Gate. | `wdz7tb4cm` | `[B]` |
| I-13 | **`toolchain_stamp_glied.hpp` Doku-Stempel jetzt auf zwei Zeilen** (74 + 41 Byte, Konkatenation byte-identisch behauptet) — Rest-Risiko, dass ein spaeterer Leser zwei Stempel liest; nur durch Kommentar abgesichert, nicht durch einen Test. | ce | Test nachziehen. | `a0a5982f` | `[B]` |
| I-14 | **MEMORY.md liegt bei 18.006 B statt <17.408 B**; zusaetzlich wurde die "Aelterer Anker ~12:07"-Zeile eigenmaechtig gekuerzt und das Original `/tmp/orig_memory.md` geloescht (kein Rueckvergleich moeglich). | `/home/comdare/.claude/projects/-home-comdare/memory/MEMORY.md` | Ggf. nachkompaktieren. | `ac42a19ad` | `[B]` |

### J. Offene Owner-Entscheide — Sammelliste

Aus allen Buendeln zusammengezogen; die Nummerierungen der Berichte kollidieren teilweise
(siehe Abschnitt 4, W-11).

| Kennung | Frage | Quelle |
|---|---|---|
| O-1 / O-PMC-3 | Anhangsumfang PMC: 3 harte + 1 best-effort Spalte von 7; `branch_misses` jetzt verdrahten? RAPL-Zone auf der AMD-Lane unbelegt. | `wwbu56lus`, `wlrzgpeet` |
| O-2 / O-4 | Anhang-A-Reichweite (Writer M-8/M-9/M-15), Default NACH-ABGABE — aber Anhang A DE+EN haengt daran. | `wwbu56lus`, `wgr8gvgza`, `b6b2ox3j0` |
| O-3 / F6 | Verwirft "Micro/Macro FALSCH" auch die §47-Mess-Tooling-CT-Achse? | `wwbu56lus`, `blaz582sr` |
| O-4 / F8 | Gleicher Fingerprint ⇒ Messwerte uebertragbar? | `wwbu56lus` |
| O-5 | `refs/backup/pre-secret-scrub-20260802` auf origin (776 Runner-Token). | `wwbu56lus` |
| O-A / R-4 | Bau-Matrix-Kappung, Bau-Umfang 524.288 / 1.572.864 / 2.097.152. | `w76o2kmbd`, `wgr8gvgza` |
| O-B / O-PMC-1 | `allow_failure` am Mess-Batch. | `wmphtm0ki`, `wlrzgpeet` |
| O-PMC-2 | Fail-closed: heute ist die gruene PMC-Ampel eine Aussage ueber den Compile, nicht ueber den Hardware-Zugriff. | `wlrzgpeet` |
| N-1 / O-C | Faehrt der Trigger mit gesetztem `COMDARE_BESTANDSLOG`? Vom Repo aus nicht entscheidbar (Runner-Env / GitLab-Projektvariablen / externes Aufrufskript). | `wwbu56lus`, `b4g6y1r2c` |
| N-2 | Das USER-GO fuer die 320er-Abgabemessung wurde nie erteilt, und der Voll-Lauf wird bis Freitag nicht fertig. | `wwbu56lus` |
| N-3 | I-PMC-2/3 (Zen-5-RAW) vor dem Voll-Lauf nachruesten? Empfehlung: nein. | `wwbu56lus` |
| R-1 | Welche Mess-Teilmenge? (71,7 Tage gegen 40 verfuegbare.) | `w76o2kmbd` |
| R-3 | Fingerprint-Fenster: Mess-Defines aufnehmen, vor der ersten `.fingerprint`-Datei. | `w76o2kmbd` |
| R-6 | Ebene-B-Push: GO + df-Zahl. | `w76o2kmbd` |
| E-1..E-5 | F5 GOLDEN-UPDATE-FENSTER: Variante A; Alignment bei line=32; XSD; binary_id-Grammatik-Bruch; atomic128. | `ws4t2r8ry` |
| E-A..E-F | Versionierungs-Interface (6 Vorlagen). | `wm8gs10yi` |
| E2 / E3 / E9 | T6-Slot on-wire gegen Host-Append; Fensterzuordnung A8-S3 gegen E-24-b; frag_milli-Stille-0-Heilung. Blockieren P2–P8 vorgelagert. | `a67b9019` |
| E14 | NoFilter=Identitaet: vor Trigger mit golden-Neuanker? Vom Owner nach dem Register von NACH-ABGABE auf P2/vor Messbeginn vorgezogen; im Code 0 Treffer. | `ww231ccuy` |
| — | `search_algo`-Pin `{k_ary, interpolation}` gegen `{k_ary, linear_scan}` — bewegt **beide** golden-Traeger. | `wtpunni0p`, `ws4t2r8ry`, `bar8e3m70` |
| — | Faellt xlsx mit in die Abgabe? Faehrt der Trigger mit `COMDARE_STORAGE_CACHE`? | `ww231ccuy` |
| — | E18-SNAP: Patch landen; `.gitignore`-Negation; `COMDARE_TEXLIVE_AVAILABLE`; Repo-Wachstum 1–5 MB/Lauf; `PENDING-*.txt`-Aufraeumpolitik; falsche `AF_SNAPSHOT_ROOT` macht den Job jetzt rot statt gruen-ohne-Beleg. | `w7rrni258`, `wd626pkat` |
| — | Neubau-Fenster fuer den PMC-Flagwechsel (kippt den ccache-Key, einmaliger Voll-Recompile auf beiden Lanes). | `a9ef0d77` |
| — | Zweites Churn-Leck: Mess- oder Bau-Entscheidung? Additive `kV3AxisSchema`-Beruehrung eines TABU-Artefakts. | `w5u7xpiiz` |
| OF-M3-1/-2, DV-3 | Preimage-Trenner; Overlay-Definition S8; "v0"-Kurzform-Sentinel. Teil von 11 offenen Owner-Vorlagen (E-21-verbose). | `bbh232y13`, `bsirc9s9q` |
| Q6 | Hybrid = Stufe gegen Systemachse. | `bcygl3vvq` |
| E11 | Phasen-Kardinalitaet `==3` ist laut Owner "komplett falsch" — blockiert S4 seit 16.07. | `b603solu2`, `bg5p0ew8q` |

---

## 3. Artefakte

Alle SHAs sind **Behauptungen** der jeweiligen Berichte. Kein Eintrag ist von mir am Repo
nachgeprueft.

### 3.1 Gelandete Staende (behauptet)

| SHA / Ref | Repo | Traegt |
|---|---|---|
| `e7aa1244` | ce `development` == `main` | Endstand des ersten gruenen Pipeline-Laufs (15025); enthaelt `86be2420` (T2-A-Merge), `f577f886` (B14-ce), `b5e0e4e7` (CI-Invariante) |
| `98952e02` | ce | Format-Nachzug (94 Verstoesse in 13 Dateien, Pruefbereich 1731 Dateien) |
| `86be2420` | ce | Merge T2-A Neuanker Format 3, 27 Commits ab `7969b399` |
| `f577f886` | ce | Merge B14 CLU+XXE, 11 Commits ab `c837d830` |
| `b5e0e4e7` | ce | Merge CI-Invariante + Diff-Hygiene-Wache, 5 Commits ab `3bbcb8ed` |
| `3bbcb8ed` | ce | Posten-92-Landung |
| `c837d830` | ce | DOKU-77/78, CI gruen + main-FF |
| `838612f3` → Merge `40bf8a66` | ce | honest-empty (executed-Maske, drei Zell-Klassen) |
| `be4f0a16` | ce | UML-Atlas |
| `7969b399` | ce | Basis vieler Wellen; W5/W3 gelandet |
| `8970465dcc6fff41a1e1ab74606d6dce2a457224` | thesis 289 | Gate 8: 23 neue Abbildungsnamen je Sprache, +199/-2 |
| `29a1700` / `29a1700d` | thesis | Basis; **Gitlink `thesis/diplomarbeit` steht noch hier** |
| `9a2ef3b2` | super | Submodul-Bump ce `7969b399` → `e7aa1244`, **committet, bewusst nicht gepusht** |

### 3.2 Fertig gebaut, ungelandet

| SHA | Branch / Worktree | Traegt |
|---|---|---|
| `6c300e68` (Kette `511671c9`, `bcc49119`, `823f6eb5`) | `b2-neuanker-format3` / `wt-b2-neuanker` | T2-A-NB: Indexfolge-Bindung (`slice_index_digest`, Format `batchplan-v1`→`v2`), Multi-Writer-`.tmp`, `\|fpr=`-Form, F1-Spiegel |
| `a9a352bb` | `b2-neuanker-format3` | T2-A-NB2 Endstand, Format v2→v3, 9 Dateien +945/-55 |
| `b6d87c08` (mit `71b5586a`, `034e0068`) | `b2-neuanker-format3` | T2-A/F4-NB3: `plan_anker_befund`-Gate, Formwache, clang-format-Nachzug |
| `3a42bf90` (mit `b4c343b9`) | `b2-neuanker-format3` | K2 (`resume-v5`→`v6`, `\|fpr=`) + F4 (Batch-Plan + Phasenzaehler, +899/-38) |
| `847c93c9` | ce | F4-BILANZ-Heilung, 4 Dateien +286/-58 |
| `41091cb4` | ce | Batchplan-Aktivierungskette, 5 Dateien +292/-0, neuer Test `test_t2a_f4_facade_plan_durchreichung` |
| `77095354` (mit `27adebc1`) | `b2-neuanker-format3` | Neuanker-NB: CX-1..CX-4 + FB-1; Frozen ALT `f8f811a9…` → NEU `17148e5a…` |
| `fdfa68ee` (Kette `ce8fb2aa`, `8810cc7f`, `4cdb829a`, `9eb1e7d6`, `f3600109`) | `b-a1-wurf-vertrag` / `wt-b-a1` | A1-NB2: 5 Codex-MITTEL-Befunde, 32 Dateien +1080/-61 |
| `62d8c715` | `b-a1-wurf-vertrag` | A1-NB: 26 Allokator-Strategien `v1.0.0c`→`v1.0.1c`, 31 Dateien +367/-45 |
| `0b5ed557` | `b-a1-wurf-vertrag` | A1-Scheibe: Wurf-Vertrag Posten 71–74 |
| `5c4cf900` (Kette `bda34e79`, `1ae02cdf`) | `b-e18-snap` / `wt-b-e18snap` | E18-SNAP-NB2, `core.sh` 1489 Zeilen; **Codex-NICHT-LANDEN-Verdikt archiviert** |
| `1ba29b63`, `2c631551`, `9934a7e5` | `b14-golden-kf6` / `wt-b14-golden` | B14-NB3 super (xmllint-Umbau) + NB4 |
| `953ce412`, `d8073913`, `71617a1b`, `6558c4ae` | `b14-golden-kf6` | B14/KF-6 Kartierung, Bau, Fixup |
| `16a173f2` → `4b38d072` | `wt-b14-ce` | B14-NB3/NB4 ce; Verdikt LANDEN gilt fuer `4b38d072`, **nicht** `16a173f2` |
| `6a40071f` | ce | B14-Abschluss ce, +101/-15, kein algo_version-Bump |
| `a402cfbc` | ce | codegen-Minor 8.0 → 8.1 |
| `597ecffe`, `557d8023` | `b-r4-ci-abdeckung` / `wt-b-r4-ci` | Doppel-Job-Key-Heilung + `ci_yaml_key_guard.sh`; `AXIS_ALGO_VERSION 1→2` + Lock-Regen |
| `baaaea62`, `dcb2f08f` | `b-r4-ci-abdeckung` | R4: Manifest + Wache (inert), dann Wurzelschnitt + Job `test:coverage-guard` |
| `ed9fca8e`, `5e6048ff`, `3558466d` | `b-lb6-stufe1` / `wt-lb6` | LB-6 Stufe 1: Utility, Ruecklese-Biss, echte FS-Konkurrenz |
| `8065aec0` | `b-p92-registry-kanon` / `wt-b-p92` | Posten 92 Option A, comment-only, 33 Insertions |
| `31af5a92` (Serie `7969a02c..`) | ce | Graph-Umbau |
| `c1cdc0da`, `9c858a73abae6c02cca65dfa8060062d5e642a33` | super | B14-Beweisketten-Sicherungen (25 bzw. 20 Dateien) |
| `699edaa2` | super `development` | Ledger-Nachtrag verlorene Buchfuehrung, 329 Insertions, **nicht gepusht** |
| `b35aea1b` | super | Graph-Paket mit 160 Format-Verstoessen in 8 Dateien |

### 3.3 Worktrees

| Pfad | Branch | Zustand laut Bericht |
|---|---|---|
| `/home/comdare/wt-b2-neuanker` | `b2-neuanker-format3` | T2-A-Kette; Fremd-PID 546552 hat zeitweise mitgeschrieben |
| `/home/comdare/wt-b-a1` | `b-a1-wurf-vertrag` | **Doppelbelegung**; eine Instanz stoppte, die andere committete |
| `/home/comdare/wt-b-graph` | `b-graph-2d3d` | **Kollision, uncommittet**; Snapshot nur unter `/tmp/wt-b-graph-collision-snapshot-114209.diff` |
| `/home/comdare/wt-b-graph2` | — | vorgeschlagenes Ausweich-Ziel, Entscheid nie eingetroffen |
| `/home/comdare/wt-b14-golden` | `b14-golden-kf6` | 2 Commits ueber `1ba29b63`; Rueckbau-Auftrag beruhte auf altem Lagebild |
| `/home/comdare/wt-b14-ce` | — | sauber auf `4b38d072` |
| `/home/comdare/wt-b-e18snap` | `b-e18-snap` | E18-SNAP-Kette |
| `/home/comdare/wt-b-honest-empty` | `b-honest-empty` | honest-empty, gelandet |
| `/home/comdare/wt-b-r4-ci` | `b-r4-ci-abdeckung` | 2+2 Commits, ungepusht |
| `/home/comdare/wt-lb6` | `b-lb6-stufe1` | LB-6 Stufe 1 |
| `/home/comdare/wt-b-gate8` | `b-gate8-graph-abbildungen` | Gate 8 Thesis |
| `/home/comdare/wt-b-p92` | `b-p92-registry-kanon` | Posten 92; unversionierter Build-Baum bleibt zurueck |
| `/home/comdare/wt-genroots-explore` | `b-genroots-explore` | `generated/`-Zensus, read-only |
| `/home/comdare/wt-b-buildgraph` | — | Build-Graph-Race-Diagnose |
| `/home/comdare/wt-e24` | `w5-w3-kern` | W5/W3-Paket, ohne Upstream |

### 3.4 Plan- und Analysedokumente (ueberwiegend untracked)

`docs/plaene/20260806-PLAN-kostenklammer-restposten.md` (599 Z.) ·
`…-katalogposten-p2p8-und-trigger-reste.md` (729 Z.) ·
`…-p-pmc-1-messkette.md` (651 Z.) ·
`…-scheibe6-weg-a-fixture-entflechtung.md` (689 Z.) ·
`…-golden-update-fenster.md` (580 Z.) ·
`…-versionierungs-interface-stempel.md` (815 Z.) ·
`…-thesis-posten-und-testoffensive.md` (714 Z., 40.637 B) ·
`…-lb6-stufe1-oeb-baumform.md` (521 Z.) ·
`…-host-belegung-batch-plan-ablage.md` ·
`…-owner-antworten-vertiefung.md` ·
`…-testoffensive-und-gruene-pipeline.md` ·
`docs/architektur/20260806-DEEP-RESEARCH-cacheline-hardware-vs-achse.md` (580 Z.) ·
`docs/sessions/20260806-ANKLAGE-kostenklammern-plan-diff.md` (im Repo **und** im Desktop-Plain-Backup) ·
`docs/sessions/20260806-FAHRPLAN-hauptstrang-landung.md` ·
`ce docs/architecture/20260803-a9_xlsx_writer_f3_soll_design.md` (558 Z.) ·
`docs/sessions/20260804-DOSSIER-achsen-qualitaets-parameter-katalog.md` (856 Z., Katalog P1–P8 in `:737-778`) ·
Graph-Plan `/home/comdare/.claude/jobs/5a19728e/tmp/graph_design_plan.txt` (22.263 Zeichen) ·
SOTA-Katalog `docs/sessions/backups/20260806-e2a-planungs-welle/ergebnis-roh.json` (Key `result.sota`, 33,6 KB, 19 Formen).

### 3.5 Pipelines (behauptet)

`15022` ROT (289 s, 17 gruen / 2 rot, beide Lint) → `15025` SUCCESS (279 s, 19/19 fahrende Jobs,
1 bewusst `manual`) · `15037`, `15038` (SHA `bd6dfcc2a298340c518ceadafa95c8d86f164ee3`), `15039`,
`15041` je 2/2 · `15048` 13/13 nach ~6 min · `15032`/`15033` Thesis-PDF ·
`15043` 411/411 · aeltere: 14305, 14315, 14321, 14334 (ROT, genau ein Job `lint:static`), 14353,
14363, 14372, 14398, 14498, 14527, 14536, 14569, 14571 (ROT, `contract:conformance`), 14596,
14659, 14674, 14751–14756, 14847 (ce-CI-ROT auf docs-only), 14855, 12757, 12769, 12783,
14382–14385.

---

## 4. Widersprueche und Selbstkorrekturen

Die folgenden Stellen sind die unsichersten des gesamten Materials.

### 4.1 Sachliche Widersprueche zwischen Berichten

**W-1 — PMC L3: befuellt oder strukturell 0?**
`won0hr04n` misst am d03-Korpus (16 Zeilen) `pmc_available=1` mit echten L1D- und dTLB-Werten,
aber **L2, L3, Kohaerenz-Invalidierungen und Energie in allen 16 Zeilen 0**. `wgr8gvgza`
widerlegt die Ledger-Formel "nur L1D + dTLB": `cache_misses_l3` werde aus
`PERF_COUNT_HW_CACHE_LL` befuellt (`:204-205/:262-266`), Energie best-effort aus RAPL;
strukturell 0 seien **L2, coherence, branch** — drei, nicht vier. Beide koennen stimmen (Code
kann befuellen, Korpus trotzdem 0 zeigen), aber die **Ursachenzuschreibung ist unversoehnt**.
`wlrzgpeet` sagt zusaetzlich, die Ledger-Formel sei zugleich zu pessimistisch (L3 real als
Last-Level) und zu optimistisch (`branch_misses` ohne Quelle). **O-1 haengt an dieser Zahl.**

**W-2 — Bau-Menge: 131.072 / 524.288 / 2.097.152.**
Faktor 16 zwischen den Extremen. `05_evaluation.tex:94-101` = 524288, `experiment_golden_kern.xml:285`
= 2097152, FAHRPLAN = 131072; `w76o2kmbd` rechnet 4 System-Perms × 2^17 = 524.288 und nennt
`line_size` inert; `wc2xbd4ay` multipliziert den Systemblock zusaetzlich ×4 auf 2.097.152;
`w44o34i7j` nennt 524288. Keine Zahl ist gemessen.

**W-3 — super-`main`-Divergenz zwischen den Remotes.**
`wdz7tb4cm` behauptet in der Ist-Aufnahme eine Divergenz (origin `9d0f1bad` gegen github
`030d2c62`) und **widerlegt sie im eigenen Fahrplan-Teil (K2)** — beide seien `030d2c62`.
Derselbe Bericht, zwei Aussagen.

**W-4 — Anhang-A-Zaehlung: 28/41 gegen 16/44.**
`won0hr04n` zaehlt am Erzeuger 12 + 28 + 1 = 41 Positionen, davon 28 fehlend. `wgr8gvgza` zaehlt
44 Fragmente je Sprache, 16 vorhanden, 28 fehlen. Der Ledger-Nachtrag `mittag-3` nennt "16 + 23 =
39 Dateien je Sprache". Drei Zaehlungen, ein Gegenstand.

**W-5 — CI-tote Tests: 9 oder 17?**
`wbckbar4m` misst live 9 ungedeckte Tests bei 404 registrierten. `ww7eb5key` nennt 17
CTest-Targets mit Label `contract`, gebaut und in keinem Job ausgefuehrt. Nicht in Deckung
gebracht.

**W-6 — Zeilennummern des Doppel-Jobs `contract:axis-version-lock`.**
`a829a4fdfc` nennt `:393` und `:574`; `bkygjx34k`/`b0xd2tosc` nennen `:363` und `:522`;
`wdz7tb4cm` und `bbb1lj3en` nennen `:343` und `:502`. Der Sachverhalt ist viermal derselbe, die
Zeilenanker sind es nicht — vermutlich verschiedene Repo-Staende, aber ungeprueft.

**W-7 — OD-7 Runner-Zahlen.**
`wnfai1iau` fuehrt "Ist 3/2 + heavy 16 statt 24" als **einzige bekannte aktive Abweichung** von
einer Owner-Direktive. `ww231ccuy` erklaert genau diese Zahl fuer stale: real offen sei nur das
NORMAL-Profil (4/4 statt 2×12), HEAVY sei konform.

**W-8 — `bestandslog_active`: entlastet oder Kostenklammer?**
`a9a2b597` entlastet ausdruecklich (alle 9 Konsumenten pruefen den Anker selbst fail-closed,
`prune_stale_sidecars` schliesst den Stale-Sidecar-Umweg; Rest = Namens-Ungenauigkeit).
`bax1kkazq` fuehrt dieselbe Stelle als KK-4 und sagt, sie werde scharf, sobald KK-2 repariert
wird. Beide koennen recht haben — heute harmlos, morgen nicht.

**W-9 — `PlanFach::offen`: Defekt oder abgeleitete Autoritaet?**
`bax1kkazq` (KK-6): erhoben und persistiert, von keiner Entscheidung gelesen. `a9a2b597`:
**kein Defekt**, die vorgeschlagene Praefix-Abschneidung waere eine Regression; der Zaehler ist
"abgeleitete Autoritaet auf groeberer Koernung", seit `batchplan-v3` dem Fingerprint
untergeordnet.

**W-10 — codegen-Minor gebumpt oder nicht?**
`be52dmp6f` zitiert "[MITTEL-HOCH, VOR LANDUNG ENTSCHEIDEN] `kCebContractCodegenMinor` wurde
NICHT gebumpt" (Format-3 bleibt bei Minor 0). `bp7x25tnb` und `bf8qegh15` nennen den Bump
8.0→8.1 in B14-NB4 (`a402cfbc`) als vollzogen. `LEDGER:4821` fuehrt den B14-codegen-Minor-
Entscheid weiterhin als Owner-offen. Drei Staende, nicht aufgeloest.

**W-11 — Nummernkollisionen.**
Mehrfach dokumentiert: `B5` gegen `B-5`, `R2` gegen `R2`, Posten 36/37 gegen #36/#37, `#27`
mehrfach belegt, `O-2` doppelt, `F6` dreifach, `B12` doppelt. Konsequenz aus `wwbu56lus`:
**Nummern-Anker allein reichen nie.** Ferner: es gibt **kein einziges stabiles A/B/C-System** —
mindestens drei "Strang A/B/C", vier "F1–F14"-Runden, drei "B1–B15"-Listen (`wh14blymc`).

**W-12 — Allokator-Versionstabelle: 3 oder 26 registrierte Varianten?**
Der Fable-Review in `wo64su8tn` sagt, die Tabelle trage nur **3** registrierte Varianten, die
uebrigen 23 seien nur textidentisch und nicht compile-gewacht. `wr5l6ao2d` und `w07qbvcad`
arbeiten mit **26**. Entscheidet, ob der ENFORCE-Beweis 26 Literale oder 3 deckt.

**W-13 — Nicht-ASCII-Altbestand: 1132 oder 962 Dateien?**
`bx7tcdjkc`/`bjxi5jgry` nennen 1132 (dominant 83.224x U+2500); `wo2zqnqhb` nennt 962.

**W-14 — SHARED-Ziele in ce `tests/unit`: 4 oder 14?**
Innerhalb **desselben** Berichts `a9a2b597`: Hauptbericht 4, Nachtrag 14. Der Nachtrag korrigiert
das nicht explizit als Fehler; `a3115bb12` belegt 14 mit Zeilennummern.

**W-15 — Test-Suite-Groessen ohne Zuordnung.**
Im Material erscheinen 1816, 555, 472, 429, 411, 410, 409, 408, 407, 406, 405, 404, 331, 326,
322, 285, 264, 156, 151, 148, 116, 115, 41, 38, 28, 25 — je nach Repo, Worktree, Configure-Pass
und Label-Filter. Erklaerungen dazu: 409 (Wellen-Baum) gegen 405 (frischer Baum) + 2 neue
B14-Tests = 407, Ursache vier configure-zeit-bedingte Tests; kaltes Configure liefert 404 statt
408 (2-Pass-Pflicht: **configure → BAU → configure**); frisches Bau-Verzeichnis 322 statt 326.
**Ohne Worktree-Zuordnung ist keine dieser Zahlen ein Gate-Nachweis.**

**W-16 — B14-Verdikte gegen verschiedene SHAs.**
"NICHT LANDEN" gilt gegen `16a173f2`, "LANDEN" gegen `4b38d072`. Kein Sach-, sondern ein
SHA-Stand-Widerspruch — aber in Auftraegen mehrfach verwechselt. Ebenso: Frozen-Vektor
`17148e5a` (Neuanker-Linie) gegen `0fe275bd` (B14-Linie).

**W-17 — CI-Wachen-Status `b0yl04i56` gegen `brkto3zzo`.**
Auf demselben SHA `be4f0a1633c3b7893a6492a6ead4ff5bd5091ac0` erst "CE-CI-failed — KEIN FF", dann
"CE-RETRY-GRUEN + main-FF". Plausibel als Retry-Aufloesung, aber die Reihenfolge ist aus den
Rohdateien **nicht datiert belegt**.

**W-18 — ABI-/POD-Zeitschichten in derselben Ledger-Datei.**
"ABI-MAJOR==4, kein Bump noetig" steht neben "ABI-Major 7, Magic `.A7.`"; Snapshot-`sizeof`
erscheint als **1416**, **1344** und **1272**; golden-CRC als `0xF1C1F26A1232073B` und
`0x56F1B721C72DC10E`; Achsenzahl als 19 und 18. **Wer eine dieser Dateien isoliert liest, zieht
die falsche Zahl.** Die 18 ist laut Forensik korrekt (INC-2c, 17.07., ce `5fe811db`, 19→18,
sizeof 1416→1344).

**W-19 — 3D-Surface im Anhang.**
`acdd6a9b` sagt, die vorhandene echte 3D-Surface werde nirgends in den Anhang emittiert
(`appendix_generator.cpp:344-353` schreibt nur die 6 `lc_surface_<z>.tex`) — waehrend im selben
Transkript der Stufe-08-Test `Surface3dIsWiredNextToTheExistingHeatmap` **gruen** lief.
Vermutlich Fremd-Agenten-Stand P1b, aber **unklar**.

**W-20 — Wurzelursache honest-empty.**
`bkdyvpq0p`: "`aggregate_surface_matrix` (`:431-458`) liefert `true`, sobald irgendeine Zelle
existiert". `bllzbwyly`: "Matrix-Default 0.0 + `op_<art>_n`-Zaehlspalten werden nicht gelesen".
Zwei leicht abweichende Beschreibungen desselben Fehlers.

**W-21 — 776 gegen 390 Runner-Token.**
Der gitleaks-Lauf nennt 776 Funde; das Task-Board nennt 390 nicht rotierte Token. Teilmenge,
andere Erhebung oder Widerspruch: **nicht abgeglichen**.

### 4.2 Selbstkorrekturen (Agenten gegen sich selbst)

| Korrektur | Bericht |
|---|---|
| "`clang-format` ist nicht installiert" war **falsch** — ein `find /` lief in den 120-s-Timeout und daraus wurde eine Behauptung. Real vorhanden: `clang-format 22.1.8`, CI-identisch. Netto +26 neue Abweichungen durch Handformatierung. | `a0a5982f` |
| "0 Verstoesse" wurde gegen den **eigenen Commit** gemessen, die Wache misst gegen die **Serie**. Lehre: *Pruefbereich gehoert zur Zahl.* Derselbe Fehler in derselben Serie zweimal. | `a0a5982f` |
| "Die Owner-Formel verweist auf ein Dokument, das nicht existiert" / "Planung: nicht vorhanden" — **ausdruecklich zurueckgenommen**; die aeltere Planung vom 01.08. existiert (OE-B / BEWEIS 2 / LB-6). Termin-Einordnung Stufe 1 von "Kann" auf **Vor-Trigger-Pflicht** hochgestuft. | `a9a2b597` |
| "der Vorgaenger hatte den CODE aller fuenf Befunde bereits geschrieben, aber **keinen einzigen Biss**". | `w7y69czwo` |
| Erster Gate-Durchlauf war **falsches Gruen** — 2-Pass kalt ergab 404 statt 408; die Regel lautet configure → **BAU** → configure. Frozen-Vektor `17148e5a` existiert auf diesem Branch nicht. | `wpzbpjmj1` |
| "xmllint bereits im Einsatz" **trifft nicht zu** — keine Fundstelle in `.gitlab-ci.yml`/`ci/`/`Code/`. Erste Praeparate waren Stubs, "deren rotes NEU waere auch ohne Defekt rot gewesen" — verworfen und neu gebaut. | `wsmsmgp8o` |
| **LEAD-FEHLER ehrlich verbucht:** der Codex-KRITISCH-Befund zu `read_batch_plan` war echt, die eigene Entkraeftung falsch — gefolgt von "KORREKTUR MEINER KORREKTUR: `read_batch_plan` WIRD produktiv gerufen, zweimal". Zwei Umkehrungen desselben Befunds. | `bode6hvdp` |
| **Zwei Pfad-Korrekturen an einem Tag:** die Dateien liegen unter `builder/bestandslog/` bzw. `libs/cache_engine/profile_facade/`, nicht `builder/experiment_tree/`. | `bode6hvdp`, `w76o2kmbd` |
| **K-01 widerlegt:** `COMDARE_BESTANDSLOG` **wird** gesetzt (via `experiment_plan_director.hpp:952-955`, belegt durch `test_experiment_plan_director.cpp:845-860`). "K-01 hat einen Repo-Grep als Laufzeit-Aussage genommen." | `ww7eb5key`, `bkiznk8k5`, `wx6bt8o71` |
| Duplikat-Scan war falsch (Schnitt am ersten `:` kollabierte `contract:durability` → `contract`); `git checkout --` nahm den eigenen Bump mit zurueck; `python3` einmalig als Wegwerf-Beweis benutzt (gegen "Kein Python in der Buildchain"). | `a829a4fdfc` |
| Cache-Sichtbarkeit ueber `algo_sig` begruendet — das ist die Vor-A2-Mechanik; seit 05.08. vergleicht `dll_is_current` nur den Fingerprint. Ergebnis stimmt, Wirkkette historisch falsch. | `wr5l6ao2d` (Fable W-1) |
| "die Vorlage ist zur Haelfte falsch" — `active` ist im `comdare_experiment`-Dialekt inert; die Achse herauszurechnen waere selbst ein neuer Defekt gewesen. | `w5u7xpiiz` |
| `binary_search`/`linear_search` sind **keine Registry-Namen**; 524288 als Gesamt-Matrix war stale. | `bar8e3m70`, `ws4t2r8ry` |
| Sechs Zitatfehler und ein gekipptes Verdikt: fuer codegen-Minor existiert **doch** eine Owner-Entscheidung; V6.5-TABU "ABI-MAJOR==4" ist doppelt superseded (heute ABI-7, POD 1344); "0 Treffer pre-secret-scrub" ist falsch. | `wwbu56lus` |
| Drei eigene Vorbefunde zurueckgezogen: V-03 kein Abgabe-Blocker, V-05 kein Mess-Echtheits-Risiko, V-08 misst nicht gegen 0. | `wzktivkld` |
| Drei Statuskorrekturen gegen das Register (O-3-Loesch-GO bereits erteilt, E14 vorgezogen, OD-7-Zahl stale) und eine gegen den juengsten Ledger-Eintrag (Beweise reichen bis LB-3, nicht LB-1). | `ww231ccuy` |
| AP-12 wieder angeklagt (nur in ce gesucht); AP-04 "0 Aufrufer" falsch; AP-05 Umfang unterschaetzt (77 statt 17); AP-07 nicht ausfuehrbar; AP-10 Anker stale. | `wo2zqnqhb` |
| Cold-ICE-Vermutung verworfen (andere Signatur, 0 Ledger-Treffer, Wurzel behoben). | `wnru437uo` |
| Frozen-Vektor `17148e5a` existiert **doch** — an drei Stellen; jeder Preimage-Dreh kostet drei Anker, nicht einen. | `wm8gs10yi` (K1) |
| Codex-Behauptung "CI-Chaos-Job `.gitlab-ci.yml:549`" widerlegt (`grep -i chaos` = 0); D-01..D-17-Verknuepfung zurueckgezogen. | `wj5ygjg79` |
| "die meisten `.log`" praezisiert auf exakt 12 von 18; die MEMORY-Regel "ugrep stille Null" traf auf **diesem** Host nicht zu (`/usr/bin/grep` ist GNU grep 3.11, `-P` arbeitet korrekt) — fuer prod1/prod2 bleibt sie ungeprueft. | `adeb6e141` |
| Eigener gitleaks-Fehlalarm (Lauf ohne Repo-Konfig) ⇒ neue Doktrin: immer mit Repo-Konfig und ueber den Push-Inhalt. | `b4g6y1r2c` |
| Erst "Ich kenne den Grund fuer die A/B/C-Systematik nicht", dann nachgeschlagene Aufloesung im selben Fork. | `abitte-beschreibe-mir-…` |
| Drei eigene Registerbefunde per Live-Pruefung zurueckgenommen (B-5 `wt-b14-golden` existiert doch, B-4 und B-6 stale). | `bslpfix3y` |
| "die 4096 stehen NICHT dort" (Quellen-Korrektur im Plan selbst). | `bl0hbukl7` |
| NB2-Werbung "dependency-freie ctest-Schicht" **widerrufen** — genau diese Dependency-Freiheit habe die sechs Befunde verursacht. | `beze0okll` |

### 4.3 Struktureller Befund zur Review-Qualitaet

Der Codex-Kipp-Zaehler ist im Ledger durchlaufend dokumentiert: honest-empty, E18-SNAP-1, A1,
B14, Teil-2, E18-SNAP-NB, A1 — in **7 von 7 Faellen** sagte Fable "LANDEBEREIT", Codex "NICHT
LANDEN", der Lead folgte Codex. Ab mittag-18 gilt der Owner-Satz "Fable wird nicht funktionieren
und ist aufgebraucht"; Lead und Review laufen seither auf Opus 5. **Alle vormittaeglichen
Fable-LANDEBEREIT-Verdikte des Tages stehen damit in anderem Licht.** `[B]`

Weitere dokumentierte Methodenfallen: **Backup ist nicht Beleg** (4 Wellen-Journale im
Abschluss-Backup waren 125-Byte-Stummel) · **Kommentar ist nicht Doktrin** (zweimal an einem Tag
fuehrte ein Code-Kommentar zu einer falschen Lead-Einordnung: `read_batch_plan`, CI-Negativliste
`.gitlab-ci.yml:476-478`) · **Stub-Praeparate** (rotes NEU waere auch ohne Defekt rot gewesen) ·
`find` auf prod1 ist bfs, `-newermt '-20 minutes'` liefert leer · gitleaks im Container-Mount
scannte 0 Commits.

---

## 5. Was dieser Ueberblick NICHT leisten kann

**5.1 Nichts hier ist nachgemessen.** Ich habe fuer dieses Dokument keinen einzigen SHA, keine
Testzahl, keine Zeilennummer am Repo verifiziert. Die Quelle sind Verdichtungen von Berichten,
die ihrerseits ueberwiegend "Behauptung, nicht nachverifiziert" an ihre eigenen Zahlen schreiben.
Der Ueberblick ist eine **Landkarte der Behauptungslage**, kein Befundregister.

**5.2 40 Dateien waren leer (0 Bytes).** Buendel 13 und 14 tragen zusammen 40 der 269 Dateien,
alle mit `stat -c%s` = 0. Fuer 19 davon liess sich **keine einzige Referenz** im gesamten
Backup-Baum finden. Was dort gelaufen ist, ist unwiederbringlich unbekannt. Einzige Ausnahme:
`wm4bkvxym` — per TaskStop beendete Doppel-Instanz des Graph-Auftrags, deren Zwischenstand
(15,5-KB-Diff, G1-Header-Block + Daten-Realitaetscheck) nur im fluechtigen Job-Tmp lag.

**5.3 Der Buendelschnitt war teilweise falsch.** `b*`- und `w*`-Kennungen sind **Shell-Lauf-IDs**,
keine Agenten-IDs; die Journale fuehren ausschliesslich `a<16 Hex>`. Der im README behauptete
Wellen-Index deckt die gesamte `b*`/`w*`-Klasse nicht ab — auch nicht die grossen,
inhaltsvollen Dateien darin. Fuer diese existiert **keine Zuordnung Kennung → Kommando/Auftrag**.
Wo ich oben einen "Auftrag" nenne, ist er in vielen Faellen aus der Ausgabeform rekonstruiert,
nicht aus einem Prompt gelesen.

**5.4 Rohdaten dominieren.** Von den 24 Buendeln bestehen mindestens 8 ueberwiegend oder
ausschliesslich aus Roh-Werkzeugausgaben (grep-Dumps, `ctest`-Fortschrittszeilen,
Pipeline-Poller, `ps`-Snapshots, `git diff`). Diese Dateien enthalten keine Herleitung, kein
Fazit und keine Selbstkorrektur; die inhaltlichen Aussagen darin stammen teils aus **eingebetteten
Peer-Nachrichten Dritter** und sind damit doppelt ungeprueft.

**5.5 Zwei Berichte sind Torsi.** `acdd6a9b1415c4a28` (Graph-Umbau) wurde vom User abgebrochen,
`a007bfb20ae8ddc74` (`generated/`-Zensus) endete nach dem letzten Thinking-Block ohne finale
Antwort. Beide tragen wichtige Zwischenbefunde, aber keine abgeschlossene Aussage. Zwei weitere
Wellen (`w3v4qep1i`, `w6m5i2vnw`) brachen an der monatlichen Kostenklammer ab und lieferten
`result.bau = null`.

**5.6 Zeitstempel sind unbrauchbar.** Alle Dateien im Backup tragen denselben mtime
(`Aug 6 20:32`) — das ist der Kopierzeitpunkt der Einlagerung, nicht die Laufzeit. Eine
Reihenfolge laesst sich daraus nicht gewinnen. Die Chronologie in Abschnitt 1 ist aus
`startedAt`-Feldern und Ledger-Nachtragsnummern rekonstruiert, nicht aus dem Dateisystem.

**5.7 Wo der Ueberblick duenn ist.**
- **Buendel 5, 10, 20, 22, 23** (Ledger-/Korpus-Greps): dort liegt viel Doktrin-Substanz, die ich
  nur zusammengefasst, nicht durchgearbeitet habe. Insbesondere die §55-Offen-Punkte-Liste aus
  `bybgkjai0` und die Aufraeumpass-Kandidaten aus `bjxi5jgry` verdienen eine eigene Lesung.
- **Die Codex-Befunde A-02 bis A-14** aus der Anklageschrift sind bis auf vier **nicht
  gegengelesen**; besonders A-08 (Transportfehler == "Objekt fehlt" ⇒ kann Bestandslog
  ueberschreiben) wird scharf, sobald der Lager-Weg produktiv oeffnet.
- **Die 10 Codex-Befunde aus `wa3azpzk6`** (2 KRITISCH, 6 HOCH), darunter "beide `target_isa`-
  Zweige gebrochen" (x86/aarch64-Kollision) und "W5 filtert das falsche Fensterkoordinatensystem"
  (`planner_status_reader.hpp:322`), sind in **keinem** spaeteren Bericht adressiert.
- **Der SOTA-Katalog** wurde ohne gerenderte Paper-Abbildungen erstellt (`pdftoppm`/poppler nicht
  installiert) — vieles darin ist als `[Wissen]` markiert.
- **Die Auswertung der 187 GENONLY-TUs** existiert nicht; es gibt nur die Rohliste.
- **`bf209ev1b`**: eine Mess-CSV mit 134 Spalten und `count workloads = 5760`, bei der die 30
  gezeigten "distinct workload"-Zeilen alle byte-identisch sind. Ob der Dump abgeschnitten ist,
  ist **unklar** — vor jeder Konsequenz nachmessen.

**5.8 Was ich bewusst nicht getan habe.** Ich habe keine Behauptung zu einer Tatsache
aufgewertet, keine fehlende Zahl geschaetzt und keine Luecke mit Plausibilitaet gefuellt. Wo das
Quellmaterial "unklar" sagt, steht hier `[?]`.

---

*Erstellt am 06.08.2026 aus 24 Buendel-Verdichtungen ueber
`docs/sessions/backups/20260806-workflow-rohdaten/outputs/` (269 Dateien).*
