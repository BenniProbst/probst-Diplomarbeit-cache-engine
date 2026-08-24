# AUDIT RUNDE 1 -- Strang "pinduo" (#107, D-10a/c) -- Fable-max-AUDITOR

Datum: 2026-08-22 * Objekt: prt-art `bau/pinduo` @ **4941c410ee87a0ed60ca417e18c37be41673e4bb**
(Basis 777fff7; Worktree /home/comdare/wt-prt-pinduo, HEAD gemessen == 4941c410ee..., porcelain **0**).
Audit REIN LESEND (Sonderfall W1L-Lande-Zug aktiv; alle Kommandos read-only: git show/diff/log/ls-remote,
yaml.safe_load auf /tmp-Kopie). Kein Bau-Slot genutzt, kein Fix-Commit noetig.

Gelesen (voll): soll-karte.md (349 Z.) * prtart-pin-duo-ergebnis.md (51 Z.) * LEAD-ENTSCHEIDE (87 Z.) *
W2-ABFOLGE-DESIGN D-10-Block (Z. 377-383) * STAFFEL2-SYNTHESE Status/Phasen/F-85..F-95/G-4/5.1 *
STAFFEL1 F-62 * Ledger-Kopf KON120 (Z. 19-80) + KON119-04/05 (Z. 204-223) * GOAL-v8:114/763/773 *
Wellenplan:955/957/960/3419 * Designplan-tdd:74/645.

## 0. IST-AENDERUNGEN SEIT SOLL-KARTE (Karten-Stand ueberholt, je mit Literal)

| # | Karte sagte | IST am 22.08. (Literal) | Wirkung |
|---|---|---|---|
| I-1 | "KEIN Push nach origin/github" (SPANNUNG 3, P-09) | `ls-remote origin refs/heads/bau/pinduo` = **4941c410ee87a0ed60ca417e18c37be41673e4bb** (== Tip) | **Phase 0c VOLLZOGEN** -- Backup-Loch S1+S2 GESCHLOSSEN; P-09 damit ERFUELLT |
| I-2 | ce-Pin = ce development-Tip | ce `ls-remote origin development` = **ed9f1a3c** (W1L-CI-16069-Heilung); 66de5c09 ist ANCESTOR (merge-base-Beweis), Range 66de5c09..ed9f1a3c = **4 Commits** | KEIN Fund: H-18 entscheidet explizit "Der ce-Pin bleibt 66de5c09 (fester, erreichbarer Commit -- unabhaengig davon, wie weit ce/development bei der Landung ist)"; YAML-Kommentar datiert den Wert korrekt ("Stand 20.08.2026 abends") |
| I-3 | prt-art-Hauptklon auf development @ 777fff7 (E1#6/F-89) | Standalone-Klon /home/comdare/Projekte/Research/comdare-prt-art jetzt auf **main @ 01e8b7d** [origin/main: behind 33]; origin/development weiter **777fff7** (Basis UNBEWEGT), github/development 777fff7 | Post-Strang-Umparken (Lande-Zug-Umfeld/Ein-Schreiber-Doktrin); FINDINGS#14-Status vom 21.08. war korrekt, heutiger Klon-Zustand = Sache des W1L-Zugs. Kein pinduo-Fund |
| I-4 | W1L "in_progress" | Ledger **KON120-04**: CI 16073 @ ed9f1a3c FAILED mit GENAU EINEM roten Test (#509 Debug-Zelle), Fix-Strang laeuft; "prt-art #107-Rezept + super-Vorbereitung unveraendert dahinter" | pinduo-Landeplan UNVERAENDERT gueltig; keine juengere Schicht widerspricht |
| I-5 | Submodul-Klon (REGELN-Pfad Code/external/comdare-prt-art) | development dort **d11781f = STALE** (d11781f ist Vorfahr von 777fff7, merge-base-Beweis; Objekt 4941c41 dort nicht vorhanden) | Nur Frische-Hinweis; wahres Objekt = wt-prt-pinduo + origin. Kein Fund |

## 1. PRUEFLISTEN-TAFEL P-01..P-11 (dreiwertig, je Literal)

### P-01 build:standalone SHA-Pin (FINDINGS#12/KON119-04) -- **ERFUELLT**
Am Objekt (git show 4941c41:.gitlab-ci.yml, grep -n):
Z. **49** `COMDARE_CE_PIN_SHA: "66de5c0972290ec1ae3d219988ecc207d8f5de6b"` (global) *
Anker Z. **87** `.ce-pin-clone: &ce_pin_clone` mit 3 Items (Z. 88-93: `git clone --no-checkout
--reference-if-able ../comdare-cache-engine --dissociate` + CI_JOB_TOKEN-URL, `checkout --detach
"$COMDARE_CE_PIN_SHA"` Z. 92, Echo-Log-Beleg Z. 93) * Job `build:standalone:` Z. **96**, `- *ce_pin_clone`
Z. **104**, Configure Z. **106** mit `-DCOMDARE_CACHE_ENGINE_DIR=$CI_PROJECT_DIR/ce-pin`.
Alle Karten-Zeilennummern EXAKT bestaetigt. ce-Seite: 66de5c09 existiert im ce-Repo (`cat-file -t` = commit),
196a621a ist Vorfahr (merge-base --is-ancestor RC=0 literal).

### P-02 Klassen-Ausdehnung auf 5 Jobs -- **ERFUELLT**
`- *ce_pin_clone` GENAU 5x: Z. **104/125/221/246/274**, zugeordnet build:standalone(96),
build:standalone:debug(116), build:clang(212), build:clang:debug(237), sanitize:asan-ubsan(263) --
deckungsgleich mit der Karte. Struktur-Probe yaml.safe_load: je Job der Anker als verschachtelte
Liste an Position 0, **identical_to_anchor=True 5/5** (GitLab-dokumentiertes flatten-Muster fuer
Script-Anker-Arrays), je **GENAU 1** Configure-Zeile mit PIN-DIR (clang-Jobs gequotet
`-DCOMDARE_CACHE_ENGINE_DIR="$CI_PROJECT_DIR/ce-pin"` Z. 232/257 im `- |`-Block). 6. Job
`build:registry-roundtrip:` Z. **145** traegt EIGENEN Job-Pin Z. **173**
`COMDARE_CE_PIN_SHA: "196a621a8a1180dbd47163b75cbb8b102e66a08b"` (Job>global-Praezedenz, bewusst,
s. NICHT-GEFORDERT 1 der Karte). BEIDE Mengen: Auftrags-Menge {build:standalone}; Bau-Menge = die 5.
Karte-ACHTUNG bestaetigt: sanitize-Pin ist YAML-Konfiguration; Sanitizer-CI-LAUF = P-08/G-4 (offen, getragen).

### P-03 registry_roundtrip.cmake-Kopf (FINDINGS#13) -- **ERFUELLT**
Diff 777fff7..4941c41 -- registry_roundtrip.cmake: numstat **15 0** = REINE INSERTION; neuer Block
`# REFERENZ-KONFIGURATION (SEIT K7b-3/#104, W2 2026-08-20)...` + `# HISTORIE (ueberholte Fassung,
gueltig bis K7b-3/#104 am 20.08.2026 ...)`-Marker; Alt-Block als Kontext byte-erhalten (0 Loeschzeilen
gemessen). GOAL-v8:114-Doktrin ("Doku wird nur deprecatet") eingehalten. SPANNUNG 1 (A-8-Routing):
per STAFFEL2 F-87 ("DEDUP: erledigt S1-F-62") zugunsten pinduo aufgeloest -- hier NICHT neu aufgeworfen,
nicht doppelt gezaehlt; A-8-Abnahme soll auf f1fc5d8 VERWEISEN (Karten-Empfehlung, an Lande-/docs-Zug).

### P-04 FINDINGS#11 Allowlist-Beleg per Branch-CI -- **OFFEN, ORDNUNGSGEMAESS GETRAGEN** (kein Fund)
Vom Strang korrekt NICHT behauptet; getragen als **F-90** (STAFFEL2:180) + **G-4** (STAFFEL2:238) +
**H-18** (STAFFEL2:94-99) + Phase 3/Schritt 14 (STAFFEL2:138-139). Faellt bei ECHTER Branch-CI der
Landung an (kein ci.skip): Pin-Log-Beweis ALLER 6 ce-konsumierenden Jobs (Echo-Zeile Z. 93/187) +
Allowlist-Beleg literal (Praezedenz #104: Pipeline 16048 SUCCESS 9/9 + HTTP 201, KON119-04 verifiziert
Ledger Z. 204-210).

### P-05 Lokale Gruen-Probe ctest 224/224 -- **NICHT-PRUEFBAR AM OBJEKT** (deklariert; kein Fund)
Probe-Verzeichnis laut Bericht nach Belegpruefung abgebaut; das Literal (`100% tests passed, 0 tests
failed out of 224`, Vollbau 60/60, ce-Pin-Echo 66de5c09) liegt im PERSISTIERTEN Strang-Bericht
(backups-workflow, Z. 43). Die Karte selbst raeumt beide Wege ein ("auf den zitierten Log-Text verlassen
ODER Probe neu fahren"); Neuprobe unterlassen: Audit rein lesend (Sonderfall) + die staerkere CI-Haelfte
(alle 6 Jobs im Runner-Kontext) ist ohnehin Pflicht der Landung (G-4) und deckt die lokale Probe mit.
EIN-GRUENES-GATE: das 224er-Gate deckte NUR {prt-art-eigene Tests, gcc, Release, lokal, 1 von 6 Jobs
nachgestellt}; NICHT gedeckt: clang/Debug/Sanitizer/6 CI-Jobs (= P-07/P-08-Mengen).

### P-06 allow_failure-Verbot -- **ERFUELLT**
grep am Tip: GENAU 1 Treffer Z. **211**, reiner KOMMENTAR ("... skip VERBOTEN; kein allow_failure).")
-- VORBESTAND, nicht aus diesem Branch: `git diff 777fff7..4941c41 | grep -c allow_failure` = **0**.
GOAL-v8:763/773 am Original verifiziert (woertlich wie in der Karte zitiert).

### P-07 T-11b 4-Zellen-Kombibau -- **NICHT GEGENSTAND DES STRANGS** (Lande-Zug-Pflicht; kein Fund)
Designplan-tdd:645 am Original verifiziert. STAFFEL2 Phase 4 (Z. 141-147): K17-Vollkombibau EINMAL am
gemergten Endstand, "sinngemaess super/prt-art" -- NACH Phase 3/Schritt 14. Strang behauptet korrekt nur
1/4 Zellen lokal (gcc-Release); die 3 Rest-Zellen = Lande-Zug (Karte NICHT-GEFORDERT 3). Pruefort: #113.

### P-08 V-3/V-5/V-8 CI-Haelfte -- **OFFEN, ORDNUNGSGEMAESS GETRAGEN** (kein Fund)
Wellenplan:955/957/960 am Original verifiziert. Baremetal-Haelfte = P-05 (Berichts-Literal); CI-Haelfte
(Job-IDs + 6 Pin-Log-Zeilen) = YAML-Absicht bis zur Branch-CI der Landung -- identisch mit P-04/G-4
getragen. Uebereinstimmend offen in Strang-Bericht (Offene Punkte 1), F-90, G-4, H-18: kein Widerspruch.

### P-09 Ref-Sicherung -- **ERFUELLT (seit Karten-Erhebung geschlossen)**
Karten-Kommando ausgefuehrt: `ls-remote origin refs/heads/bau/pinduo` =
**4941c410ee87a0ed60ca417e18c37be41673e4bb** == Worktree-HEAD (rev-parse identisch). Phase 0c
(STAFFEL2:113) VOLLZOGEN; SPANNUNG 3 der Karte damit im Sinn "bereits geschlossen" beantwortet.
B14-Ref ebenfalls gesichert: bau/w1luecken-prtart @ **3710ac4c** auf origin (Literal im selben ls-remote).
(github traegt bau/pinduo nicht -- ordnungsgemaess: GitHub = flache Sicherung, Phase 0c verlangt origin.)

### P-10 Lande-Rezept pinduo x B14 -- **ERFUELLT + PRAEMISSE AM OBJEKT BESTAETIGT**
B14-Diff 777fff7..3710ac4c: NUR .gitlab-ci.yml (50+/16-). `git merge-tree --write-tree 4941c41 3710ac4c`:
**"CONFLICT (content): Merge conflict in .gitlab-ci.yml"** (literal) -- die Rezept-Praemisse "sicherer
Merge-Konflikt, gleiche globale Bloecke auf Basis 777fff7" HAELT. Rezept liegt fixiert in Board-#107
(pinduo ZUERST; B14 danach, Konflikt zugunsten D-10a, einziger B14-Mehrwert = Bau-Proben-Notiz;
faellt pinduo aus: B14 = Minimal-Absicherung). W1L (#113) traegt es als "V-F2-Rezept #107" -- KON120-04
bestaetigt "unveraendert dahinter".

### P-11 CI-Dual-Compiler-Geltung prt-art -- **GETRAGENE STAFFEL-3-FRAGE + NEUE POSITIV-MESSUNG**
Getragen: STAFFEL2:277-278 (Scope-Klaerung E-14/E-15 fuer prt-art im YAML-Zug). ZUSATZ-MESSUNG dieses
Audits am Tip (yaml.safe_load): `build:clang`, `build:clang:debug`, `sanitize:asan-ubsan` tragen
**rules: None, when: None, only: None, except: None**; Template `.bm` = nur `tags: [baremetal]`;
`workflow:` laesst Branch-Pipelines zu (`if: $CI_COMMIT_BRANCH`). D. h. am pinduo-Stand existiert
KEINE when:never-/changes:-Drossel auf den clang-/sanitize-Jobs -- die Owner-KERN-Unbedingtheit
(KON119-05, am Original verifiziert) ist fuer prt-arts Bau-Jobs FAKTISCH gegeben. Die formale
Scope-Buchung bleibt beim Staffel-3-YAML-Zug (kein pinduo-Fund, keine Doppel-Erledigung behauptet).

## 2. ZUSATZPRUEFUNGEN (a)-(d)

**(a) TDD-Vertrag T-1..T-9/T-11a-c/T-12a-e**: Branch-Diff = GENAU 3 Dateien (.gitlab-ci.yml,
registry_gen/CMakeLists.txt, registry_gen/registry_roundtrip.cmake; numstat-Literal 58/5 + 3/0 + 15/0)
-- **KEIN neuer C++-Test, keine Datei unter tests/** -> T-1/T-2/T-3/T-4/T-5/T-6/T-7/T-11c GEGENSTANDSLOS
(Karten-Abnahme-Formel 7 bestaetigt). T-8 ATOMARE LANDUNG (Designplan:74 am Original verifiziert) greift
generisch: Pflicht des Lande-Zugs (deckt sich mit G-4/H-18). T-11b: s. P-07.

**(b) GOAL-Doktrinen**: ASCII: Nicht-ASCII in Diff-Plus-Zeilen = **0** (grep -cP literal 0, RC=1);
allow_failure: 0 im Diff (P-06); TABU-Zonen: keine der 3 Dateien unter axes/ topics/ heuristik/,
keine golden-Datei, tests/unit/CMakeLists.txt unberuehrt (Karten-NICHT-GEFORDERT 5 bestaetigt);
.gitlab-ci.yml-Aenderung ist der AUFTRAGSGEGENSTAND selbst (D-10a) -- zulaessig; Ledger/Board/Memory:
im Diff NICHT enthalten (3 Dateien, s. o.) -- Lead-only-Verbot eingehalten; clang-format-22:
gegenstandslos (keine C/C++-Datei geaendert). cmake-Aenderungen: 18 Plus-Zeilen, davon
Nicht-Kommentar = **0** (gemessen) -- reine Doku, kein Funktionsdelta.

**(c) Abnahme-Formeln woertlich**: "beide Pins deterministisch" (W2-ABFOLGE:383) -- Pin (a)
build:standalone-Klasse: fester SHA 66de5c09 global + 5x PIN-DIR = deterministisch (YAML-Ebene
ERFUELLT; CI-Vollzugsbeweis = Landung/V-3); Pin (b) registry-roundtrip: fester SHA 196a621a
(seit #104 CI-bewiesen 16048) UNANGETASTET = deterministisch. "Allowlist-Beleg literal" -- OFFEN,
Lande-Zug (P-04). Karten-Formeln 2-10 je am Original nachgeschlagen (GOAL-v8:114/763/773,
Wellenplan:955/957/960/3419, Designplan:74/645, Ledger KON119-04/05) -- ALLE Zitate der Karte
stimmen woertlich mit den Originalen ueberein.

**(d) Bericht-Behauptungen am Objekt (Stichproben)**:
- "16 Top-Level-Keys" -> gemessen **16** OK * ".ce-pin-clone = Liste" -> list, 3 Items OK *
  "5 Jobs anker3 + je GENAU 1 Configure mit PIN-DIR" -> 5/5 + je 1 OK *
  "registry-roundtrip Script UNANGETASTET, 7 Items, 0 Alias" -> 7 Items, 0 Nicht-String, Script-Zeilen
  nicht im Diff OK * "JOB-Pin 196a621a / GLOBAL 66de5c09" -> Z. 173/49 OK.
- V1-Klon-genuegt-Beweis: CMakeLists.txt:23 (Geschwister-Default) / :27 + :67 (beide Include-Haelften) /
  :38 `option(COMDARE_PRT_ART_USE_CACHE_ENGINE ... OFF)` / :50 `if(COMDARE_PRT_ART_USE_CACHE_ENGINE)` /
  :87 googletest-1.15.2.tar.gz / registry_gen/CMakeLists.txt:18 boost_mp11 -- ALLE am Tip zeilengenau
  bestaetigt (git show Literale im Audit-Lauf).
- "196a621a IST Vorfahr von 66de5c09; 66de5c09 = Tip von development" -> Vorfahr-Beweis OK;
  Tip-Aussage war zum Berichtszeitpunkt korrekt, heute ed9f1a3c (s. I-2, H-18-gedeckt).
- Commit-Reihenfolge/Botschaften: f1fc5d8 (fix(ci), 2026-08-21 10:11:53Z) + 4941c41 (docs(registry_gen),
  10:12:45Z), Botschaft nennt D-10a/FINDINGS#12+#13/KON119-04 -- OK.
- **EINZIGER Zahlen-Fehltritt**: ".gitlab-ci.yml 63+/5-" (Bericht E2-1, von Karte Z. 7-8 uebernommen) --
  numstat-Literal: **58 Insertionen / 5 Loeschungen** (die "63" ist die --stat-Spaltensumme 58+5).
  Gesamtsumme 76+/5- ueber 3 Dateien stimmt. -> FUND A-1 (KLEIN).

## 3. FUNDE

| ID | Schwere | Titel | Beleg | fix_weg |
|---|---|---|---|---|
| A-1 | KLEIN | Stat-Notation "63+/5-" fuer .gitlab-ci.yml ist falsch gelesen: numstat = 58+/5- (63 = Summe) | `git diff --numstat 777fff7..4941c41` -> `58 5 .gitlab-ci.yml`; Bericht Z. 32 + soll-karte Z. 7-8 tragen "63+/5-" | KEINE Datei-Edition der Backup-Rohdaten (BU additiv); die Zahl in kuenftigen Traegern korrekt fuehren: KON120/121-Ledger-ENTWURF bzw. Lande-Protokoll des W1L-Zugs (#113) schreibt ".gitlab-ci.yml 58+/5- (Summe 63)"; Synthese uebernimmt diese Korrektur aus audit-runde-1.md |

Keine ERNST-, keine MILD-Funde: alle Pflicht-Punkte des D-10a/c-Zuschnitts sind am Objekt geliefert
und belegt; alle offenen Punkte sind BEREITS GETRAGENE Posten (F-86/F-90/G-4/H-18/Phase-4, unten) --
nach Audit-Regel KEINE neuen Funde.

## 4. LANDE-AUFLAGEN (getragene OFFENE -- Liste, KEINE neuen Funde)

1. **G-4/H-18/F-90 (P-04/P-08)**: Landung NUR mit ECHTER Branch-CI (kein ci.skip): Pin-Log-Beweis
   ALLER 6 ce-konsumierenden Jobs ("ce-Pin ausgecheckt: <sha> (SOLL <sha>)", YAML Z. 93 + Z. 187)
   + FINDINGS#11-Allowlist-Beleg literal (Messlatte = #104: SUCCESS 9/9 + HTTP 201). Erst-Lauf-Hinweis
   des Berichts beachten (6 Jobs klonen je Workspace; Runner git clean -ffdx wie bei #104).
2. **F-86 (NICHT-GEFORDERT 1)**: registry-roundtrip-Pin-Bump 196a621a -> 66de5c09 (oder juenger)
   NUR ZUSAMMEN mit XML-Byte-Stabilitaets-Beleg (Range 19 Commits/28 Dateien/+1209/-90, NICHT trivial).
3. **T-11b/Phase 4**: 4-Zellen-Kombibau sinngemaess prt-art EINMAL am gemergten Endstand (#113);
   ctest-Bilanz je Zelle literal.
4. **V-F2-Rezept**: pinduo VOR B14; Konflikt (merge-tree-bestaetigt) zugunsten D-10a aufloesen;
   einziger B14-Mehrwert = Bau-Proben-Notiz in den D-10a-variables-Kommentar.
5. **Staffel-3-YAML-Zug**: prt-art-Scope der Dual-Compiler-Pflicht formal buchen (E-14/E-15-Anteile);
   Audit-Messung dieses Laufs als Eingang: clang-/sanitize-Jobs am pinduo-Stand OHNE
   rules/when/only/except-Drossel (faktisch unbedingt).
6. **Doku-Verweis A-8**: A-8-Abnahmepunkt FINDINGS#13 auf Commit f1fc5d8 VERWEISEN (nicht neu
   implementieren) -- SPANNUNG-1-Aufloesung der Karte, DEDUP F-87/S1-F-62.

## 5. VERDIKT

**SITZT** (0 ERNST, 0 MILD, 1 KLEIN). Der Strang hat den D-10a/c-Zuschnitt vollstaendig und
doktrinkonform geliefert; Objekt-Zustand, Ref-Sicherung und Lande-Rezept-Praemissen sind am
22.08. frisch verifiziert. Die verbleibenden Pflichten liegen sauber beim Lande-Zug (#113) und
sind dort bereits verbucht (KON120-04: "#107-Rezept ... unveraendert dahinter").

Selbstcheck: Alle Behauptungen dieses Berichts tragen Literale aus dem Audit-Lauf (git show/diff/
numstat/ls-remote/merge-base/merge-tree/yaml.safe_load/grep -c); kein Erfolg ohne Output; beide
Mengen je Gate benannt; ASCII-only.

---

# AUDIT RUNDE 2 (ADDITIVER NACHTRAG) -- Strang "pinduo" (#107, D-10a/c) -- Fable-max-AUDITOR

Datum: 2026-08-23 (abends) * Objekt HEUTE: prt-art `bau/pinduo` @
**25bbf2e23c91821bd16511c097e76937ca590fda** (3. Commit seit Basis 777fff7; Worktree
/home/comdare/wt-prt-pinduo HEAD == 25bbf2e, porcelain **0**). Audit REIN LESEND
(W1L-Lande-Zug weiter aktiv; alle Proben via git show/diff/log/ls-remote/grep am Objekt bzw.
auf /tmp-Kopien; kein Bau-Slot, kein Fix-Commit, keine Schreibung in wt-prt-pinduo).
Anlass: soll-karte.md wurde am 23.08. AKTUALISIERT (STAND-DELTA: dritter Commit 25bbf2e,
den Runde 1 nicht kennen konnte) und verlangt fuer Runde 2 gezielt das DELTA-Audit
(S-7: "NICHT bei Null neu pruefen ... sondern gezielt NUR den Delta-Commit (P-14) plus den
aktualisierten Push-/Ref-Stand (P-13) ... inklusive der clang-format-22-Pruefung").
Der Auftrags-Steckbrief nannte noch "@ 4941c41" -- der reale Tip ist 25bbf2e; die juengere
Soll-Karte (23.08.) deckt und fuehrt diesen Stand. Hinweis der Karte befolgt: Runde-1-Text
oben bleibt BYTE-UNANGETASTET (BU additiv), dieser Block ist reiner Nachtrag.

Gelesen (voll bzw. Fenster mit Literal-Beleg): soll-karte.md AKTUALISIERT (474 Z., voll) *
audit-runde-1.md oben (voll) * prtart-pin-duo-ergebnis.md (51 Z., voll) * LEAD-ENTSCHEIDE
(87 Z., voll) * T9-Beweisort backups-workflow/20260822-parallel-heilung/pinduo-t9/
(ERGEBNIS.md voll + alle 3 Logs an den Bilanz-/Fund-Zeilen) * SYNTHESE-S2-AUDIT.md
T9/T9b/T10/T10b/T10c-Block (Z.36-80) + Status-Zeile pinduo (Z.19) * SYNTHESE-S2-AUDIT.
VORHER-fortsetzung (pinduo-A1/A2/A3-Stellen Z.21-49) * W2-ABFOLGE-DESIGN Z.375-385/52-56/
72-78/93-96/817-824/845 (selbst nachgelesen) * STAFFEL1 Z.22/165-169/250 * STAFFEL2
Z.20/94-99/175-180/270-278 * Ledger-Kopf: KON121 = juengster KON (grep ^## KON12[2-9] = 0
Treffer), KON120-07 Kern 2 (Board #122: "pinduo-A2/A3-Lead-Posten") + KON120-04
("#107-Rezept ... unveraendert dahinter") an den Originalzeilen.

## R2-0. KONSTANZ-BEWEIS (deckt P-01/P-02/P-04/P-06..P-08/P-10..P-12/P-16/P-17-Basis fort)

`git diff --numstat 4941c41..25bbf2e` = GENAU EINE Zeile:
`7  2  tests/unit/support/lizenz_audit.hpp`. Weder `.gitlab-ci.yml` noch
`registry_gen/registry_roundtrip.cmake` noch `registry_gen/CMakeLists.txt` sind seit dem
Runde-1-Objekt beruehrt -> ALLE Runde-1-Messungen an diesen drei Dateien (Prueftafel oben,
P-01..P-03/P-06/P-09-Anteile, Zusatzpruefungen a/b/c/d) gelten am heutigen Tip FORT.
Commit-Kette am Objekt: 777fff7 (Basis) -> f1fc5d8 -> 4941c41 -> 25bbf2e (git log, 3 Commits).

## R2-1. PRUEFTAFEL RUNDE 2 (dreiwertig, je Literal)

### R2-P-14 T9-Lizenz-Wachen-Fix (Commit 25bbf2e; SPEC = SYNTHESE-S2 T9 (a)-(d), aus
### Erstlauf-ERNST "pinduo-A1" als LANDE-BEDINGUNG) -- **ERFUELLT (alle 4 SPEC-Teile)**

- **(a) exakter Name + Begruendungs-Kommentar**: Diff-Literal: `name == "ce-pin"` NEU in
  `ist_uebersprungenes_verzeichnis()` (kein Praefix-/Substring-Match; die Praefix-Falle
  bleibt laut Kommentar ausdruecklich vermieden) + 5-zeiliger ce-pin/-Kommentarblock
  (".ce-pin-clone-Anker, .gitlab-ci.yml ... EXAKTER Verzeichnisname, kein Praefix (T9,
  22.08.2026)") + Abgrenzung zum KEIN-ext/-Skip ("ce-pin/ ist kein gebuendelter Fremdcode,
  sondern ein CI-Arbeitsstand des Nachbar-Repos"). Wirk-Mechanik am Tip verifiziert:
  `ernte_spdx()` faehrt `fs::recursive_directory_iterator` und ruft bei Verzeichnis-Match
  `it.disable_recursion_pending()` -- der Skip greift auf jeder Ebene per exaktem Namen
  (Bestandsmuster identisch zu ".git"/"build"/"node_modules"; kein neues Muster).
- **(b) K13-Gegenprobe beidseitig**: Beweisort EXISTIERT als GESICHERTE KOPIE:
  /home/comdare/backups-workflow/20260822-parallel-heilung/pinduo-t9/ (4 Dateien).
  ROT-Literal (rot-beweis-vor-fix.log): Z.736 "89% tests passed, 1 tests failed out of 9",
  Z.741 "200 - LizenzKonsistenz.KeinFremderSpdxBezeichnerImEigencode (Failed)", Z.14
  "Vorkommen fremder Bezeichner: 343 (SOLL 0)", Koeder-Zeile Z.357/706
  "ce-pin/t9_koeder_fremdlizenz.hpp:1  Apache-2.0". Fundlisten-Nenner NACHGEZAEHLT:
  `grep -c "ce-pin/"` = **686** = exakt 2x343 (Fundliste doppelt: Test-Output +
  Failure-Message). GRUEN-Literal (gruen-beweis-nach-fix.log): "100% tests passed, 0 tests
  failed out of 9" mit allen 9 Testnamen (#200-#208). Koeder biss (Rot-Seite), Positiv-Fall
  ist der Nenner -- SPEC-Wortlaut erfuellt.
- **(c) voller ctest im CI-aequivalenten Layout**: ctest-224-gruen.log:451 "100% tests
  passed, 0 tests failed out of 224" (Layout laut ERGEBNIS.md: ce-pin/ per CI-Rezept-Klon
  @ 66de5c09 real in der Wurzel, Echo-Beleg "ce-Pin ausgecheckt: 66de5c09... (SOLL
  66de5c09...)", Configure exakt CI). Erstlauf-A3-Auflage (gesicherte Kopie) ERFUELLT.
- **(d) Klon-Umzug abgelehnt**: numstat-Beweis R2-0 -- `.gitlab-ci.yml` NICHT beruehrt;
  geliefert wurde exakt die SPEC-Form "Wachen-Ergaenzung statt Umzug".
- **EIGENE Nachmessungen dieses Audits (nicht aus dem Strang uebernommen)**:
  clang-format-22: `~/.local/bin/clang-format-22 --dry-run --Werror` auf /tmp-Kopie des
  Tip-Standes (mit .clang-format vom Tip daneben) -> **RC=0** (der in KEINER Vorquelle
  gemessene Karten-Pruefpunkt P-14/WIE-PRUEFBAR-NACHTRAG ist damit GESCHLOSSEN) *
  ASCII: `git diff 4941c41..25bbf2e | grep -cP '[^\x00-\x7F]'` = **0** * Zeilenlaengen der
  Plus-Zeilen: max **112** <= 120 (Datei-eigene Regel "Zeilen <= 120 Byte" gehalten) *
  Commit-Trailer `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>` = 1x vorhanden *
  Push-Modalitaet: ERGEBNIS.md-Literal "git push -o ci.skip origin bau/pinduo -> literal
  4941c41..25bbf2e" (Regel-konform: Ref-Sicherung OHNE Pipeline).
- **SPDX-Zahlen-Stichprobe am ce-Pin-Commit 66de5c09** (git grep -o am Commit-Objekt,
  Kandidaten-Endungs-Filter der Wache approximiert): LGPL-2.1-or-later **112** (behauptet
  112, EXAKT) * MIT **71** (behauptet 71, EXAKT) * BSD-2-Clause **48** (behauptet 48,
  EXAKT) * GPL-2.0-only **18** (behauptet 18, EXAKT; ungefiltert 120 -- die 102
  Mehr-Treffer liegen in ext/traversal-Dateien mit Nicht-Kandidaten-Endungen, was die
  Endungs-Filter-Logik der Wache am Objekt BESTAETIGT) * GPL-2.0-or-later **66** (behauptet
  68; Delta 2 = Methoden-Toleranz meines starren grep-Musters "Marke + GENAU ein Leerzeichen"
  gegen den Whitespace-strippenden Parser der Wache -- die massgebliche GESAMTzahl 343 ist
  durch die Fundliste im Rot-Log beglaubigt, s. (b); KEIN Fund).

### R2-P-13 Ref-/Push-Stand (aktualisiert) -- **ERFUELLT (Phase-0-Sicherung auch fuer den
### 3. Commit vollzogen)**

`git ls-remote origin` (Netz-Wahrheit, heute): `refs/heads/bau/pinduo` =
**25bbf2e23c91821bd16511c097e76937ca590fda** == lokaler Branch == Worktree-HEAD *
`refs/heads/development` = **777fff7...** (Basis UNBEWEGT) * `refs/heads/bau/w1luecken-prtart`
= **3710ac4c...** (B14-Faehrte weiter gesichert). github: `ls-remote github
refs/heads/bau/pinduo` = LEER (RC=0) -- wie Runde 1: GitHub = flache Sicherung, Phase 0c
verlangt origin; ordnungsgemaess. Die offene Karten-Frage "war -o ci.skip gesetzt?" ist durch
den PERSISTIERTEN Beweisort beantwortet (Literal s. R2-P-14); die GitLab-API-Gegenprobe
"keine echte Branch-CI gelaufen" bleibt beim Lande-Zug (T9b) -- fail-closed getragen,
kein Fund.

### R2-P-03 ce-Pin-Frische (frisch gemessen, H-18-Doktrin) -- **ERFUELLT / NUR NOTIZ**

HEUTE: ce `development` == `origin/development` = **3841d7175086d5141fb28d6a401ae1ab4d137b30**;
`merge-base --is-ancestor 66de5c09 origin/development` RC=**0** (Pin bleibt erreichbarer
Vorfahr); `rev-list --count 66de5c09..origin/development` = **41** Commits (Runde-1-Messung:
4; Karte verlangte Frisch-Messung statt Fortschreibung). H-18 haelt: Pin NICHT falsch, nur
aelter werdend. LANDE-NOTIZ: die F-86-Harmonisierungs-Range (T10c) waechst weiter -- der
XML-Byte-Stabilitaets-Beleg beim spaeteren Bump wird entsprechend groesser.

### R2-P-15 Lande-Rezept-Praemisse am NEUEN Tip -- **ERFUELLT (Konflikt haelt)**

`git merge-tree --write-tree 25bbf2e 3710ac4c` -> literal **"CONFLICT (content): Merge
conflict in .gitlab-ci.yml"** (objektdatenbank-neutraler Read wie in Runde 1; kein Ref-/
Worktree-Touch). Da 25bbf2e `.gitlab-ci.yml` nicht beruehrt, ist die Konfliktlage identisch
zu Runde 1 -- Rezept "#107: pinduo ZUERST, B14 darauf, Konflikt zugunsten D-10a" bleibt
exakt gueltig (KON120-04: "unveraendert dahinter").

### R2-P-17 TDD-Vertrag auf den Delta-Commit (sinngemaess, lizenz_audit.hpp = bestehende
### Wache, kein 117er-Katalog-Posten) -- **ERFUELLT**

T-1 (Rot vor Heilung): Rot-Literal 1/9 + Exit 8 + Koeder-Fund im PERSISTIERTEN Log (s.
R2-P-14 b) -- echtes Rot am Objekt, nicht behauptet. T-3 (Nenner fremd): Nenner "out of 9"
bzw. "out of 224" stammen aus ctest, nicht aus dem Fix-Code. T-4 (Gegeneingang): die
Koeder-Faelle #205-#208 (LizenzKonsistenzKoeder.*, praeparierter Wegwerf-Baum) laufen NACH
dem Fix weiter GRUEN -- die Wache beisst nachweislich weiter, der Skip macht sie nicht blind.
T-7 (Registrierung): Tests #200-#208 laufen in der 224er-Gesamtsuite (ctest-Nummern im
224er-Log; keine CMakeLists-Aenderung noetig, Bestandstests). T-8 (atomar): 1 Commit,
1 Datei, Fix+Kommentar zusammen; Koeder-Datei NIE committet (numstat-Beweis). T-11c/T-12:
weiterhin gegenstandslos (keine Mess-/Warmup-/Drift-Gate-Flaeche; wie Runde-1-Tafel).

### R2-P-GOAL GOAL-Doktrinen auf das Delta -- **ERFUELLT**

TABU-Zonen: das Delta liegt unter tests/unit/support/ -- nicht unter axes/topics/heuristik/,
keine golden-Datei, tests/unit/CMakeLists.txt unberuehrt (numstat R2-0). allow_failure: 0 im
Delta (keine YAML-Aenderung). Ledger/Board/Memory: NICHT im Diff (1 Datei); T9-ERGEBNIS
deklariert "Keine Ledger-/Board-/Memory-Schreibung" -- konsistent. EIN-BLECH-REGEL: Push mit
ci.skip = kein Pipeline-Paket verbraucht; echte Branch-CI bleibt der Landung vorbehalten.

## R2-2. GETRAGENE OFFENE (Bestand, KEINE Funde -- Traeger je benannt)

1. **T9b/F-90/H-18/G-4**: ECHTE Branch-CI (kein ci.skip) mit Pin-Log-Beweis ALLER 6
   ce-konsumierenden Jobs + FINDINGS#11-Allowlist-Beleg LITERAL (Messlatte #104: SUCCESS 9/9
   + HTTP 201). Durch den T9-Fix ist die bekannte Rot-Huerde (Lizenz-Wache gegen ce-pin/)
   BESEITIGT -- P-05/P-09-CI-Haelfte einen Schritt naeher, aber weiter Lande-Zug (#113,
   Phase 3/Schritt 14 von 14).
2. **S-5/P-19 (CAVE in T9b uebernommen)**: Allowlist-Reichweite 287->ce fuer die 5 neuen
   Jobs in keiner Quelle bestaetigt; greift sie nicht, ist die Einrichtung ein zusaetzlicher
   Schritt VOR der Branch-CI.
3. **F-86/T10c**: registry-roundtrip-Pin-Bump 196a621a -> 66de5c09 (oder juenger) NUR mit
   XML-Byte-Stabilitaets-Beleg; Range heute 41 Commits hinter origin/development-Tip
   (Frisch-Messung R2-P-03) -- waechst.
4. **T10 (= Erstlauf pinduo-A2, Lead-docs, Board #122 per KON120-07)**: A-8-Teilpunkt
   FINDINGS#13 gegen f1fc5d8 verrechnen, kein Neu-Edit.
5. **T10b (= Runde-1-KLEIN A-1, Zahlen-Hygiene)**: kuenftige Traeger schreiben
   ".gitlab-ci.yml 58+/5- (Summe 63)"; Backup-Rohdaten bleiben unveraendert.
6. **Staffel-3-YAML-Zug**: prt-art-Dual-Compiler-Scope formal buchen (E-14/E-15);
   Audit-Eingang aus Runde 1 (P-11): clang-/sanitize-Jobs OHNE rules/when/only/except-
   Drossel.
7. **pinduo-A3 (Erstlauf-Auflage "gesicherte Kopie des 224er-Logs")**: durch den
   T9-Beweisort ERFUELLT (ctest-224-gruen.log liegt) -- hier als VOLLZOGEN quittiert,
   Board-#122-Posten kann vom Lead geschlossen werden.

## R2-3. FUNDE RUNDE 2

**KEINE.** (0 ERNST, 0 MILD, 0 KLEIN neu. Der Runde-1-KLEIN A-1 bleibt getragen bei T10b;
der Erstlauf-ERNST pinduo-A1 ist durch 25bbf2e + Beweisort VOLLZOGEN und hier verifiziert;
pinduo-A2/A3 sind Lead-getragen bzw. vollzogen, s. R2-2.)

Beobachtung OHNE Fund-Status (dokumentiert fuer kuenftige Leser): der ce-pin-Skip wirkt --
wie ALLE Eintraege der Bestandsliste (.git/build/node_modules) -- auf jeder Baumtiefe per
exaktem Namen, nicht nur an der Wurzel. Die CI legt ce-pin/ nur an der Wurzel an; ein
kuenftiges EIGENES Verzeichnis namens "ce-pin" waere vom Lizenz-Scan ausgenommen. Das ist
die T9-SPEC-Form ("EXAKTER Verzeichnisname"), Bestandsmuster und im Kommentarblock der Wache
begruendet -- kein Delta gegen eine Pflicht-Quelle.

## R2-4. VERDIKT RUNDE 2

**SITZT** (0 ERNST, 0 MILD; 1 fortbestehendes, bereits getragenes KLEIN aus Runde 1).
Der Branch ist am heutigen Tip 25bbf2e vollstaendig audit-sauber: die drei Runde-1-Dateien
sind unveraendert (Konstanz-Beweis), der Delta-Commit erfuellt die T9-Lande-Bedingung
(Erstlauf-ERNST pinduo-A1) in allen vier SPEC-Teilen mit persistierten Rot/Gruen-Literalen,
und die bislang ungeprueften Karten-Punkte (clang-format-22, Push-Modalitaet, ce-Frische,
Konflikt-Praemisse am neuen Tip) sind jetzt gemessen. Verbleibende Pflichten liegen
unveraendert und sauber beim Lande-Zug (#113: T9b Branch-CI + Allowlist-Beleg; Schritt 14
von 14) und bei den Lead-docs-Posten (T10/T10b, Board #122).

Selbstcheck: Alle Behauptungen dieses Nachtrags tragen Literale aus dem heutigen Lauf
(git show/diff/log/ls-remote/for-each-ref/merge-base/rev-list/merge-tree/grep -c/
clang-format-22 --dry-run) oder benennen den persistierten Beweisort zeilengenau; kein
Erfolg ohne Output; beide Mengen je Gate benannt; Runde-1-Text unangetastet; ASCII-only.
