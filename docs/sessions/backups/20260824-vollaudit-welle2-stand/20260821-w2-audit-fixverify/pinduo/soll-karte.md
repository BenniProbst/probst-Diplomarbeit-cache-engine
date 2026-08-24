# SOLL-KARTE — #107 prt-art-Pin-Duo (D-10a/c)

Erhoben/AKTUALISIERT: 23.08.2026 (Sonnet-max-Planungs-Erheber, nur lesend). Dies ist eine
AKTUALISIERUNG einer bereits vorliegenden soll-karte.md gleichen Pfads plus einer bereits
gefahrenen `audit-runde-1.md` (Fable-max-Auditor, datiert 22.08., Objekt-Snapshot @ `4941c41`,
Verdikt „SITZT", 0 ERNST/0 MILD/1 KLEIN). Beide wurden VOLL gelesen und sind hier eingearbeitet,
nicht verworfen (NIE-UNINFORMIERT-BAUEN-Doktrin). Diese Fassung traegt zusaetzlich einen
**objekt-frischen Fund, den KEINE der beiden Vorlagen kennt**: der Branch traegt inzwischen einen
DRITTEN Commit (siehe STAND-DELTA unten). Wo diese Karte von der Vorfassung abweicht, ist das
explizit ausgewiesen, nicht glattgezogen.

**Objekt (heute, per `git log`/`for-each-ref`, rein lesend geprueft):** prt-art `bau/pinduo` @
**`25bbf2e23c91821bd16511c097e76937ca590fda`** (Basis 777fff7 = prt-art/development-Tip;
Worktree `/home/comdare/wt-prt-pinduo`, porcelain leer). `origin/bau/pinduo` == lokaler Tip
(gepusht). ce-Pin-Ziel der Klassen-Pin-Familie: 66de5c09 (fest); super a7e8e151 (unberuehrt,
#107 fasst kein super/ce an).

Quellen (Wahrheits-Rangfolge wie vorgegeben: Owner-Wort > juengere KON > Wellenplan par.21-23 >
par.17-20 > Designplan > W2-ABFOLGE-DESIGN > Strang-Bericht; die zwei bereits vorliegenden
Audit-Dateien sind IST-Belege, keine SOLL-Quelle, aber staerker als blosse Behauptung, weil sie
selbst schon Objekt-Literale tragen):
AUFTRAG W2-ABFOLGE-DESIGN.md (D-10-Block Z.377-383, A-3 Z.53-55, Praeambel Z.15-26, [D]-Sequenz
Z.817-824) · LEAD-ENTSCHEIDE-zum-w2-design.md (voll, 87 Z.) · Wellenplan v2 (T-6/Z-2 Z.3273-3278/
3419, par.23.4 Z.3550-3553, V-3/V-8-Gate-Formeln Z.955/960) · Designplan-tdd (TDD-Vertrag §3
Z.63-75, §7 „was NICHT getestet wird" Z.119-130) · GOAL v8 (I.3 Rahmen, II.1-II.8 Arbeitsweise,
VII.2 Betriebsregeln/EIN-BLECH-REGEL Z.636-648, TEIL IX allow_failure-Verbot Z.763/773) · Ledger
KON119-04 (Z.300-306) + KON119-05 (Z.308-318) + KON120/KON121-Kopf (Z.19-166, insbes. „prt-art
#107-Rezept" Z.80/156-157, „pinduo-A2/A3-Lead-Posten" Z.94-96) · STAFFEL1-SYNTHESE.md (Status-Zeile
8/a-block Z.22, F-62 Z.167, Folgepaket-Zeile Z.250) · STAFFEL2-SYNTHESE.md (Status-Zeile 2 Z.20,
H-18 Z.94-99, Phase-0/3 Z.109-139, F-85..F-90 Z.175-180, YAML-Scope-Klarstellung Z.270/277) ·
Strang-Bericht `prtart-pin-duo-ergebnis.md` (voll, 51 Z.) · **plus** `audit-runde-1.md` (voll,
189 Z.) als bereits gemessenes IST · **plus** eigener Objekt-Read heute (git show/log/diff/
for-each-ref auf `wt-prt-pinduo`, rein lesend).

---

## STAND-DELTA seit Runde 1 (WICHTIG fuer eine evtl. Runde 2 — zuerst lesen)

Runde 1 hat den Branch bei Tip `4941c41` gemessen und ihn vollstaendig fuer sauber befunden
(„SITZT"). Seither ist GENAU EIN neuer Commit dazugekommen, den weder die urspruengliche
soll-karte noch audit-runde-1.md kennen:

```
25bbf2e fix(tests): T9 -- Lizenz-Wache ueberspringt den ce-pin-Klon der D-10a-CI-Jobs
        (Author: Benjamin-Elias Probst, Sat Aug 22 12:59:05 2026 +0000)
        tests/unit/support/lizenz_audit.hpp | 9 +++++++--  (7 insertions, 2 deletions)
```

Commit-Botschaft (volltextlich, K13-Beleg enthalten): der `.ce-pin-clone`-Baustein legt den
ce-Stand 66de5c09 als `ce-pin/` in die Projektwurzel; dieser Klon traegt fremde ce-Lizenzkoepfe
(112x LGPL-2.1, 71x MIT, 68x GPL-2.0 aus `ext/`-Fremdcode), die nicht Gegenstand des
prt-art-Audits sind. Ohne Skip waere jede ECHTE Branch-CI (= exakt die D-10c/H-18-Lande-Auflage,
P-05 unten) an `LizenzKonsistenz.KeinFremderSpdxBezeichnerImEigencode` hart rot gelaufen. Beleg im
Commit: VOR dem Fix mit ce-pin-Koeder 1/9 Tests rot (Exit 8, 343 Fremdtreffer, alle unter
`ce-pin/`), NACH dem Fix 9/9 gruen; voller ctest im CI-aequivalenten Layout (ce-pin @ 66de5c09 in
der Wurzel) 224/224. `Co-Authored-By: Claude Fable 5`.

Dieser Commit ist bereits auf `origin/bau/pinduo` (Remote-Tracking-Ref == lokaler Tip, per
`git for-each-ref` geprueft) — der Push ist also seit Runde 1 (die noch bei `4941c41` mass, per
`ls-remote` damals ebenfalls schon gepusht) NOCHMALS erfolgt. Ob dabei `-o ci.skip` gesetzt war
und ob bereits eine ECHTE Branch-CI lief, ist aus Git-Refs allein NICHT ablesbar (Fail-closed,
GOAL II.7 — nicht raten); das ist ein GitLab-Pipeline-Fakt fuer die naechste Audit-Stufe, nicht
fuer diese Karte.

Zusaetzlich objekt-bestaetigt (deckt sich mit Runde-1-P-10, hier nochmals eigenstaendig
nachgemessen): die parallele, unabhaengige Faehrte `bau/w1luecken-prtart` @ `3710ac4` („B14",
21.08., Basis ebenfalls 777fff7, NICHT auf pinduo aufgebaut) pinnt GLOBAL auf den AELTEREN Wert
`196a621a` und deckt NUR 4 der 5 Klassen-Jobs (`build:standalone(:debug)`, `build:clang(:debug)`)
— `sanitize:asan-ubsan` bleibt dort NACHWEISLICH unberuehrt (0 Diff-Zeilen in diesem Job-Block,
selbst nachgemessen). `git merge-tree --write-tree 4941c41 3710ac4` liefert laut Runde-1
(dort bereits gemessen) `CONFLICT (content): Merge conflict in .gitlab-ci.yml` — die
Konflikt-Praemisse des Steckbrief-Hinweises „Rezept #107: pinduo zuerst, B14 darauf" ist damit
objektiv bestaetigt.

**STEMPEL-KUERZEL-WARNUNG:** Das „B14" in `bau/w1luecken-prtart` ist ein LOKALES Kuerzel der
W1-Luecken-Reihe (21.08.) und hat NICHTS mit der gleichnamigen, thematisch unverwandten
historischen Ledger-Position „B14" (§38/§38.b Dock-Serialisierung, Juli 2026, Ledger Z.22926ff)
zu tun. Beide Kuerzel NICHT gleichsetzen (Memory-Doktrin „STEMPEL-KUERZEL IMMER ZERLEGEN").

---

## PRUEFLISTE

**P-01 — KLASSEN-Pin ueber ALLE ce-konsumierenden Bau-Jobs, nicht nur den im Wortlaut genannten.**
WAS: „(a) FINDINGS#12 = KON119-04 build:standalone/COMDARE_CACHE_ENGINE_DIR SHA-pinnen
(Schein-Gruen-Klasse; #104-Muster COMDARE_CE_PIN_SHA + job-lokaler Klon; DEDUP K1:40-Zeile+K5:C#12
= EIN Posten)" (W2-ABFOLGE-DESIGN.md:377-379). Sowohl der D-10a-Wortlaut als auch Ledger KON119-04
(„Gleiche Fehlerklasse build:standalone/COMDARE_CACHE_ENGINE_DIR bleibt Di-25-Posten (FINDINGS
#12)", Z.305-306) nennen im Fliesstext nur den EINEN Job, rahmen ihn aber ausdruecklich als
„Fehlerklasse"/„Schein-Gruen-Klasse" — die Klassen-Lesart ist also bereits im Auftrag angelegt,
nicht erst vom Strang erfunden (siehe SPANNUNG 1).
WIE PRUEFBAR: `git show 25bbf2e:.gitlab-ci.yml | grep -n "ce_pin_clone\|COMDARE_CACHE_ENGINE_DIR"`.
BEHAUPTET/OBJEKT-BESTAETIGT: JA, vollstaendig geliefert. Strang E1#2 „KLASSEN-BEFUND (weiter als
der Wortlaut des Auftrags)": 4 weitere Jobs identifiziert (`build:standalone:debug`,
`build:clang`, `build:clang:debug`, `sanitize:asan-ubsan`), BEIDE Mengen benannt (Auftrags-Menge
{build:standalone} vs. Bau-Menge {5 Jobs}). Runde-1 bestaetigt am Tip `4941c41` zeilengenau:
`- *ce_pin_clone` an Z.104/125/221/246/274, je GENAU 1 Configure-Zeile mit PIN-DIR
(`yaml.safe_load`-Strukturprobe 5/5). Der 3. Commit (25bbf2e) aendert an dieser Datei NICHTS
(nur `lizenz_audit.hpp`) — P-01 bleibt am HEUTIGEN Tip unveraendert erfuellt.

**P-02 — #104-Muster byte-identisch uebernommen (COMDARE_CE_PIN_SHA + job-lokaler Klon per
CI_JOB_TOKEN, `.ce-pin-clone`-Anker).**
WAS: „#104-Muster COMDARE_CE_PIN_SHA + job-lokaler Klon" (W2-ABFOLGE-DESIGN.md:378); Vorbild-Beleg
Ledger KON119-04: „prt-art bau/roundtrip-sha-pin @ 777fff7: COMDARE_CE_PIN_SHA=196a621a... +
job-lokaler Klon via CI_JOB_TOKEN; Branch-CI 16048 SUCCESS 9/9 Jobs" (Ledger:301-302).
WIE PRUEFBAR: Klon-Kommando (`--no-checkout --reference-if-able ... --dissociate`,
`checkout --detach`, rev-parse-Echo-Log) gegen den `build:registry-roundtrip`-Block
byte-vergleichen.
BEHAUPTET/OBJEKT-BESTAETIGT: JA — Strang E1#3+E2; Runde-1 zitiert das Klon-Kommando am Objekt
zeilengenau (Z.87-93 des Ankers).

**P-03 — Konkreter Pin-Wert 66de5c09 ist ein FESTER Snapshot, kein Tracking-Ziel.**
WAS: Steckbrief „COMDARE_CE_PIN_SHA=66de5c09"; H-18 bestaetigt ausdruecklich: „Der ce-Pin bleibt
66de5c09 (fester, erreichbarer Commit — unabhaengig davon, wie weit ce/development bei der
Landung ist)" (STAFFEL2-SYNTHESE.md:96-97).
WIE PRUEFBAR: `git -C ce rev-parse development` gegen `66de5c0972290ec1ae3d219988ecc207d8f5de6b`
— jede Bewegung von ce/development seit Bau macht den Pin NICHT falsch, nur alt.
BEHAUPTET: JA, mit selbst-korrigierender Praezisierung. E1#4 (Erstbericht) unterschaetzte die
Differenz zunaechst („development ist seither 1 Commit weiter"); WIEDERANLAUF-Praezisierung
korrigierte MESSEND: Range 196a621a..66de5c09 = 19 Commits/28 Dateien/+1209/-90, NICHT trivial.
Runde-1 mass ce/development zum eigenen Pruefzeitpunkt bereits bei `ed9f1a3c` (4 Commits weiter
als 66de5c09) — auch DAS aendert an der Pin-Gueltigkeit nichts (H-18-Doktrin). Fuer den JETZIGEN
Pruefzeitpunkt (23.08.) ist ce/development potenziell nochmals weitergewandert; das AUDIT sollte
frisch messen, nicht den Runde-1-Wert fortschreiben.

**P-04 — D-10(b) registry-roundtrip-SHA-Pin ist NICHT Gegenstand von #107 (bereits unter #104
gelandet); Job-Var-Wert 196a621a bleibt unangetastet.**
WAS: „(b) T-6/Z-2 registry-roundtrip-SHA-Pin (K7b-3; Task aus A-3)" (W2-ABFOLGE-DESIGN.md:380);
Wellenplan T-6 (Z.3273-3278) + Z-2 (Z.3419); Ledger KON119-04 (Titel „#104/K7b-3 PRT-ART-PIN
[Schein-Gruen-Klasse geschlossen]", Z.300-306).
WIE PRUEFBAR: `build:registry-roundtrip`-Jobblock im Diff `777fff7..25bbf2e` — Script-Zeilen
muessen ausserhalb des Diffs liegen (nur `variables:`-Kommentar darf sich aendern).
BEHAUPTET/OBJEKT-BESTAETIGT: Strang laesst (b) UNANGETASTET (E2: „Script UNANGETASTET (7 Items,
0 Alias, gemessen)"); Runde-1 bestaetigt den Job-eigenen Pin unveraendert bei `196a621a` (Z.173,
Job-Praezedenz vor global) — korrekt, da (b) ein eigener, bereits abgeschlossener Posten ist
(NICHT-GEFORDERT).

**P-05 — D-10(c)/FINDINGS#11: Job-Token-Allowlist-Beleg LITERAL, per ECHTER Branch-CI.**
WAS: „(c) FINDINGS#11 Job-Token-Allowlist ce<-prt-art nach Kombibau-Push per Branch-CI belegen."
(W2-ABFOLGE-DESIGN.md:380-381); Gesamt-ABNAHME D-10: „beide Pins deterministisch; Allowlist-Beleg
literal." (Z.383); H-18: „dort fallen der Pin-Log-Beweis aller 6 ce-konsumierenden Jobs UND der
FINDINGS#11-Allowlist-Beleg an" (STAFFEL2-SYNTHESE.md:94-99).
WIE PRUEFBAR: GitLab-Pipeline-Log mit Job-IDs aller 6 Jobs + `git-Pin-Echo`-Zeile je Job; GitLab
Job-Token-Allowlist-Eintrag (Projekt-Settings ce, API/UI).
BEHAUPTET: NEIN, EXPLIZIT NICHT von diesem Stream zu liefern. Strang-Status „LANDEREIF (kein
Push, ordergemaess)"; Steckbrief an mich: „KEINE Schreib-Fixes in diesem Worktree". Runde-1
fuehrt dies korrekt als „OFFEN, ordnungsgemaess getragen" (kein Fund). NEUE VORBEDINGUNG seit
Runde 1: der T9-Fix (25bbf2e) beseitigt eine Huerde, die eine ECHTE Branch-CI sonst SOFORT hart
rot haette laufen lassen (Lizenz-Wache) — insofern ist P-05 mit dem 3. Commit einen Schritt NAEHER
an seiner Erfuellbarkeit, aber die eigentliche Branch-CI/Allowlist-Belegung selbst steht weiter aus.

**P-06 — Gesamt-ABNAHME „beide Pins deterministisch; Allowlist-Beleg literal" (Teilstand).**
WAS/QUELLE: W2-ABFOLGE-DESIGN.md:383.
WIE PRUEFBAR: Kombination aus P-01..P-05.
STAND: „beide Pins deterministisch" — YAML-Ebene ERFUELLT (P-01/P-02/P-04: beide Pins sind feste,
job-lokal geklonte SHAs, kein Geschwister-Zufallsstand mehr); CI-Vollzugsbeweis bleibt Landung.
„Allowlist-Beleg literal" — OFFEN (P-05), Lande-Zug.

**P-07 — NIE-KUERZEN: beide Mengen (Auftrags-Menge vs. Bau-Menge) explizit benannt, nicht
glattgezogen.**
WAS: Memory-Dauerregeln „NIE KUERZEN — KETTE VOLL, ALLE FEATURES" / „LUECKE = BEHEBUNGS-PFLICHT";
Wellenplan-Praeambel K5/A4 „NIE KUERZEN / VERTAGT nur mit Grund+Platz+Task" (W2-ABFOLGE-DESIGN.md:23).
WIE PRUEFBAR: Textstelle im Strang-Bericht, die BEIDE Mengen nennt.
BEHAUPTET: JA — E1#2 nennt woertlich „Auftrags-Menge {build:standalone}; Bau-Menge
{build:standalone, build:standalone:debug, build:clang, build:clang:debug, sanitize:asan-ubsan}".

**P-08 — allow_failure-Verbot: keiner der 5 (inkl. sanitize) Jobs traegt `allow_failure` auf
Job-Ebene.**
WAS: GOAL v8 TEIL IX (Z.763): „`allow_failure: true` ist auf JOB-Ebene VERBOTEN." Tabelle (Z.773):
„CI-Job | faellt immer hart rot — nie `allow_failure`." Wellenplan-Praeambel K5/A5 „kein
allow_failure" (W2-ABFOLGE-DESIGN.md:24). Besonders pruefungswuerdig bei `sanitize:asan-ubsan`
(Sanitizer-Jobs tragen in der Praxis haeufig `allow_failure: true`).
WIE PRUEFBAR: `git diff 777fff7..25bbf2e -- .gitlab-ci.yml | grep -c allow_failure`.
BEHAUPTET/OBJEKT-BESTAETIGT: ERFUELLT. Runde-1 misst am Tip GENAU 1 Treffer, und der ist ein
reiner KOMMENTAR („... allow_failure)."), NICHT aus diesem Branch (Diff-Zaehlung `777fff7..4941c41`
= 0 neue allow_failure-Zeilen). Der 3. Commit (25bbf2e) beruehrt `.gitlab-ci.yml` nicht — Befund
bleibt unveraendert gueltig.

**P-09 — V-3/V-8 Wellenplan-Gate-Formeln: Gegenstand statt Ankuendigung, gefahrener Lauf statt
YAML-Absicht.**
WAS: Wellenplan Z.955 „V-3 GATE-VOLLZUG | Job-ID + Log-Zeile eines gefahrenen Laufs. YAML-Absicht
zaehlt nicht." Z.960 „V-8 GEGENSTAND STATT ANKUENDIGUNG ... prueft die Formel am Gegenstand ...,
nie an der Ankuendigung (Log-Zeile, YAML-Eintrag, `message()` zur Configure-Zeit)."
WIE PRUEFBAR: tatsaechlicher `ce-pin/`-Checkout-Ordner samt `git rev-parse HEAD` im CI-Runner-
Workspace (nicht nur die YAML-Zeile).
BEHAUPTET: TEILWEISE erfuellt fuer die BAREMETAL-Haelfte — die lokale Gruenprobe wendet das
Gegenstand-Prinzip bereits an: „lokaler ce-Klon `ce-Pin ausgecheckt: 66de5c0972290ec1ae3d219988ec-
c207d8f5de6b (SOLL ...)`" (echter Objekt-Abgleich, kein reines YAML-Vertrauen), Vollbau 60/60,
`ctest 100% ... 224/224`. Die CI-seitige Haelfte (echter Runner-Workspace, alle 6 Jobs) fehlt noch
— identisch mit P-05.

**P-10 — FINDINGS#13 (registry_roundtrip.cmake-Kopf-Drift) ist FORMAL Task A-8 zugeordnet, NICHT
D-10/#107 — vom Strang additiv (Schwesterpflicht) mitgeliefert.**
WAS: A-8-Block „... FINDINGS#13 registry_roundtrip.cmake-Kopf deprecaten (K5:C#13)"
(W2-ABFOLGE-DESIGN.md:73-74, ABNAHME „11 Teilpunkte einzeln abgehakt", Z.77); Gegenzaehlung
„K5:...#13->A-8" (Z.845). D-10s eigener Wortlaut nennt FINDINGS#13 NICHT.
WIE PRUEFBAR: `git diff 777fff7..4941c41 -- prt_art/registry_gen/registry_roundtrip.cmake
--numstat` — muss REINE INSERTION sein (0 Loeschungen).
BEHAUPTET/OBJEKT-BESTAETIGT: JA geliefert. Runde-1 misst `15 0` (numstat) = reine Insertion;
neuer „REFERENZ-KONFIGURATION"- + „HISTORIE"-Marker, Alt-Block byte-erhalten. STAFFEL2-SYNTHESE
F-87 („DEDUP: erledigt S1-F-62") loest die Doppelbelegung zugunsten pinduo auf. OFFENE
LANDE-AUFLAGE (aus Runde-1 uebernommen): A-8s eigene Teilpunkt-Buchung soll auf pinduo-Commit
f1fc5d8 VERWEISEN statt einen eigenen Entwurfstext (STAFFEL1 F-62: „ENTWURF §4.5") neu zu bauen —
sonst droht Doppelarbeit im a-block-Strang.

**P-11 — FINDINGS#14 (prt-art-HEAD zurueck auf development) ist FORMAL Task A-13 zugeordnet, vom
Strang nur bestaetigt, keine Urheberschaft beansprucht.**
WAS: „A-13 FINDINGS#14 prt-art-Klon HEAD zurueck auf development (nach Push)." ABNAHME:
„`git branch` zeigt development." (W2-ABFOLGE-DESIGN.md:94-95).
WIE PRUEFBAR: `git -C <prt-art-Hauptklon> branch --show-current`.
BEHAUPTET: JA erfuellt, als reine MELDUNG: Strang E1#6 „(Messauftrag, nur MELDEN) ... BEREITS
ERFUELLT — keine Handlung noetig" (HEAD 777fff7, `development`, porcelain leer). Runde-1 notiert
als NEUEREN Objekt-Stand (I-3): der STANDALONE-Hauptklon (nicht der Worktree!) steht inzwischen
auf `main @ 01e8b7d [origin/main: behind 33]` — das ist Lande-Zug-Umfeld/Ein-Schreiber-Betrieb
NACH dem Strang, kein pinduo-Fund und kein Widerspruch zu E1#6s Zeitpunkt-Aussage.

**P-12 — E1#7-Nebenbefund (registry_gen/CMakeLists.txt-Kommentar-Drift „Geschwister"): gleiche
Doku-Drift-Klasse wie FINDINGS#13, additiv nachgezogen.**
WAS: nicht im D-10-Wortlaut selbst, sondern vom Strang beim Explore gefunden (T-6
SCHWESTERPFLICHT-Doktrin, Designplan §3 Z.72).
WIE PRUEFBAR: `git diff 777fff7..4941c41 -- prt_art/registry_gen/CMakeLists.txt` — 3 Kommentar-
zeilen, 0 Funktionsdelta.
BEHAUPTET/OBJEKT-BESTAETIGT: JA — Commit 4941c41, „docs(registry_gen): E1#7-Nachzug". Runde-1
bestaetigt Nicht-Kommentar-Zeilen = 0 (reine Doku).

**P-13 — EIN-BLECH-REGEL: Push/Landung dieses Worktrees erst in der koordinierten
Landereihenfolge, nicht vorzeitig isoliert.**
WAS: GOAL v8 VII.2 „EIN-BLECH-REGEL: hoechstens EIN Pipeline-Abnahme-Paket zur Zeit; zweiter Slot
nur lokal. Bau und Kampagne sind exklusiv." (Z.638); H-18/Phase 0 „bau/pinduo erst SICHERN
(Phase 0), dann Landung mit ECHTER Branch-CI" (STAFFEL2-SYNTHESE.md:94-99, 109-113).
WIE PRUEFBAR: `git for-each-ref refs/remotes/origin/bau/pinduo` (existiert = Phase-0-Sicherung
vollzogen) vs. GitLab-Pipeline-Historie (echte Branch-CI = spaeter, Phase 3/Schritt 14).
BEHAUPTET/OBJEKT-BESTAETIGT: Phase-0-Sicherung ERFUELLT — sowohl zum Runde-1-Zeitpunkt (Tip
`4941c41`, per `ls-remote` bestaetigt) als auch JETZT (Tip `25bbf2e`, per `for-each-ref`
bestaetigt: Remote-Ref == lokaler Tip). Die eigentliche „Landung mit ECHTER Branch-CI" (Phase 3/
Schritt 14 von 14, ALLERLETZTER Schritt der Gesamtsequenz) steht weiter aus — deckt sich mit P-05.

**P-14 — [NEU, Objektfund] T9-Lizenz-Wachen-Fix (Commit 25bbf2e): notwendige Vorbedingung fuer
eine gruene ECHTE Branch-CI, von KEINER Quelle vor 22.08. 12:59 UTC vorhergesehen.**
WAS: kein Quellensatz in den urspruenglichen SOLL-QUELLEN verlangt dies (logische Konsequenz erst
sichtbar, sobald der `.ce-pin-clone`-Mechanismus real durchlaeuft); der Commit selbst traegt eine
vollstaendige K13-Gegenprobe (Vorher/Nachher, Nenner benannt: 1/9 vs. 9/9, 343 Fremdtreffer).
WIE PRUEFBAR: `git show 25bbf2e -- tests/unit/support/lizenz_audit.hpp`; Lauf der Lizenz-Wache
gegen einen `ce-pin/`-Checkout am Objekt.
BEHAUPTET/OBJEKT-BESTAETIGT: JA, mit eigenem Rot/Gruen-Beleg im Commit (T-1/T-8-Doktrin sinngemaess
erfuellt, obwohl kein „Testposten" des 117er-Katalogs). WIE-PRUEFBAR-NACHTRAG: `lizenz_audit.hpp`
ist eine C++-Headerdatei -> die TABU-Regel „clang-format-22 ueber jede geaenderte Lint-Datei"
(Auftrags-REGELN dieser S2-Aufgabe) greift HIER (anders als bei den 3 Dateien aus P-01/P-10/P-12,
die YAML/CMake sind); KEINE der beiden Vorlagen (soll-karte-Erstfassung, audit-runde-1) hat dies
geprueft, da der Commit ihnen unbekannt war — offener Pruefpunkt fuer die naechste Audit-Stufe.

**P-15 — [aus Runde-1 uebernommen, hier erweitert] Lande-Rezept „pinduo zuerst, B14 darauf":
Merge-Konflikt-Praemisse objektiv bestaetigt.**
WAS: Steckbrief-ACHTUNG „Rezept #107: pinduo zuerst, B14 darauf"; kein SOLL-QUELLEN-Dokument
(W2-ABFOLGE-DESIGN/Wellenplan/Designplan/GOAL) erwaehnt „B14"/„w1luecken" ueberhaupt — das Rezept
selbst ist NUR im Ledger-Kopf (KON120-04/KON121, „prt-art #107-Rezept ... unveraendert dahinter",
Z.156-157) und am Objekt (Branch-Existenz) bezeugt, nicht in den urspruenglich benannten
SOLL-QUELLEN.
WIE PRUEFBAR: `git merge-tree --write-tree 4941c41 3710ac4` (Runde-1-Kommando, hier eigenstaendig
nachvollzogen ueber Diff-Vergleich beider Branches gegen dieselbe Basis 777fff7).
BEHAUPTET/OBJEKT-BESTAETIGT: Runde-1 liefert literal `CONFLICT (content): Merge conflict in
.gitlab-ci.yml`. Eigener Diff-Vergleich bestaetigt die URSACHE: `bau/w1luecken-prtart` pinnt
GLOBAL auf `196a621a` (AELTER) statt `66de5c09` und deckt NUR 4/5 Jobs (sanitize:asan-ubsan
NACHWEISLICH mit 0 Diff-Zeilen unberuehrt) — ein reiner Merge wuerde je nach Reihenfolge ENTWEDER
den neueren Pin-Wert ODER die 5. Job-Abdeckung verlieren. Harmonisierung ist NICHT #107s eigener
Auftrag (siehe NICHT-GEFORDERT), sondern Lande-Zug-Aufgabe.

**P-16 — [aus Runde-1 P-11 uebernommen] CI-Dual-Compiler-Faktizitaet: clang-/sanitize-Jobs am
pinduo-Objekt ohne when:/rules:/only:/except:-Drossel.**
WAS: Ledger KON119-05, Owner-KERN 20.08. (verbatim): „das sehen wir nur durch einen doppelten
compile test fuer ALLE Bereiche" (Z.309-315); STAFFEL2-SYNTHESE.md:272 „CI-DUAL-Pflicht gcc+clang
fuer JEDEN Bau-/Test-Job ... kein when:never/changes:-Skip".
WIE PRUEFBAR: `yaml.safe_load` auf `.gitlab-ci.yml`, Praesenz von `rules`/`when`/`only`/`except`
auf `build:clang`, `build:clang:debug`, `sanitize:asan-ubsan` pruefen.
BEHAUPTET/OBJEKT-BESTAETIGT: Runde-1 misst `rules: None, when: None, only: None, except: None`
auf allen dreien; `workflow:` laesst Branch-Pipelines generell zu — die Owner-KERN-Unbedingtheit
ist fuer prt-arts Bau-Jobs FAKTISCH bereits gegeben. Die FORMALE Scope-Buchung (ob das explizit als
#106/D-6-Erfuellung gilt) bleibt beim Staffel-3-YAML-Zug — #107 selbst behauptet hier KEINE
Doppel-Erledigung.

**P-17 — TDD-Vertrag-Anwendbarkeit: T-1..T-9 gegenstandslos fuer die 3 CI-Infrastruktur-Dateien,
sinngemaess erfuellt fuer die C++-Datei aus P-14.**
WAS: Designplan §3 „Gilt ab sofort fuer jedes Paket aller Wellen" (Z.65) — methodischer Anspruch,
KEIN benannter Katalog-Posten (117er-Katalog: 0 Treffer fuer „prt-art"/„Pin" in der Postenliste).
WIE PRUEFBAR: Dateityp-Pruefung des Diffs (`.gitlab-ci.yml`, 2x `.cmake`/`CMakeLists.txt` = keine
Testposten; `lizenz_audit.hpp` = C++, siehe P-14).
BEHAUPTET: Fuer die urspruenglichen 3 Dateien GEGENSTANDSLOS (kein neuer ctest-Test, keine Datei
unter `tests/`), NICHT verletzt. Fuer `lizenz_audit.hpp` (P-14) SINNGEMAESS erfuellt: T-1/T-8
(Rot-vor-Heilung/atomare Landung) durch die im Commit dokumentierte K13-Gegenprobe (1/9 rot ->
9/9 gruen) belegt, obwohl `lizenz_audit.hpp` kein neuer, im 117er-Katalog gezaehlter Testposten
ist, sondern eine bereits bestehende Wache, die um eine Ausnahme ergaenzt wurde.

**P-18 — T-11a-c/T-12a-e (Warmup-Paar, Drift-Gate-Debug, Mutations-Protokoll als eigene
Testklassen): NICHT anwendbar — andere Gegenstandsklasse.**
WAS: Designplan §11/§12-Nachtraege (Warmup-Paar-Pflichttest KON47-04, Drift-Gate-Debug-Ausnahme-
Test Z13762-13898, Mutations-Protokoll-Abnahmeklasse) — alles Mess-/Statistik-/Arena-spezifische
TDD-Sonderpakete.
WIE PRUEFBAR: thematischer Abgleich (keine Messwert-Erzeugung, kein Warmup, kein Drift-Gate in
den geaenderten Dateien).
BEHAUPTET/BEGRUENDUNG: n/a — #107 produziert keine Messwerte, ruehrt keine Warmup-/Drift-Gate-
Logik an. Diese Postenklasse bleibt fuer #107 vollstaendig aussen vor.

**P-19 — Job-Token-Allowlist-Reichweite bleibt in den SOLL-QUELLEN technisch unbelegt (Inferenz).**
WAS: kein Quellensatz bestaetigt ausdruecklich, ob die fuer das #104-Geschwister bereits gesetzte
Allowlist-Eintragung („287->ce per API, HTTP 201", KON119-04) automatisch AUCH die 5 neu gepinnten
Jobs deckt (GitLab Job-Token-Scope ist projekt-paar-, nicht job-scharf — technisch plausibel, aber
nirgends ausdruecklich bestaetigt).
WIE PRUEFBAR: GitLab-Projekteinstellungen ce -> CI/CD -> Job Token Allowlist, Eintrag pruefen.
BEHAUPTET: Der Strang behandelt FINDINGS#11 durchgehend als reine BEWEIS-, nicht
Konfigurationsluecke (Wortwahl „Beleg", nicht „Einrichtung"). Sollte sich am Objekt zeigen, dass
die Allowlist NICHT automatisch greift, waere das ein zusaetzlicher, in keiner Quelle
vorausgesehener Konfigurationsschritt vor der Branch-CI.

---

## ABNAHME-FORMELN (woertlich)

- **D-10 Gesamt** (W2-ABFOLGE-DESIGN.md:383): „ABNAHME: beide Pins deterministisch; Allowlist-Beleg
  literal."
- **A-8** (W2-ABFOLGE-DESIGN.md:77, deckt FINDINGS#13 als einen von 11 Teilpunkten ab): „ABNAHME:
  jeder Teilpunkt einzeln abgehakt (11 Teilpunkte)."
- **A-13** (W2-ABFOLGE-DESIGN.md:95, deckt FINDINGS#14 ab): „ABNAHME: `git branch` zeigt
  development."
- **Wellenplan T-6/par.22.2** (Z.3273-3278, Format GETRAGEN/FEHLT/NACHZUG): „GETRAGEN: 12.4 wies
  die Task-ANLAGE der Fix-Strecke 2 zu. FEHLT: die 15er-Eingangs-/Verify-Liste des WF trug prt-art
  NICHT und kein Board-Task entstand ... NACHZUG: 13.7-Vollzaehligkeits-Gegenprobe dokumentieren +
  W2-Board-Task SOFORT anlegen, spaetestens Di 25."
- **Ledger KON119-04** (Z.300-306): „SCHEIN-GRUEN DREIFACH BEWIESEN ... Gleiche Fehlerklasse
  build:standalone/COMDARE_CACHE_ENGINE_DIR bleibt Di-25-Posten (FINDINGS #12)."
- **GOAL v8 TEIL IX** (Z.763, 773): „`allow_failure: true` ist auf JOB-Ebene VERBOTEN." / „CI-Job |
  faellt immer hart rot — nie `allow_failure`."
- **GOAL v8 VII.2 EIN-BLECH-REGEL** (Z.638): „hoechstens EIN Pipeline-Abnahme-Paket zur Zeit;
  zweiter Slot nur lokal. Bau und Kampagne sind exklusiv."
- **GOAL v8 VII.2** (Z.641-645): „Eine Welle ohne beissende Wache gilt als nicht abgenommen ...
  Zu jeder Abnahme gehoert die Antwort auf 'was erzwingt das Halten?' Zulaessig: ein Werkzeug oder
  eine ausdruecklich als ungedeckt benannte Stelle. 'Wir achten darauf' = nicht abgenommen."
- **Wellenplan V-3** (Z.955): „GATE-VOLLZUG | Job-ID + Log-Zeile eines gefahrenen Laufs.
  YAML-Absicht zaehlt nicht."
- **Wellenplan V-8** (Z.960): „GEGENSTAND STATT ANKUENDIGUNG ... prueft die Formel am Gegenstand
  ..., nie an der Ankuendigung (Log-Zeile, YAML-Eintrag, `message()` zur Configure-Zeit)."
- **STAFFEL2-SYNTHESE H-18** (Z.94-99): „bau/pinduo erst SICHERN (Phase 0), dann Landung mit
  ECHTER Branch-CI (kein ci.skip): dort fallen der Pin-Log-Beweis aller 6 ce-konsumierenden Jobs
  UND der FINDINGS#11-Allowlist-Beleg an. Der ce-Pin bleibt 66de5c09 ... registry-roundtrip bleibt
  BEWUSST auf 196a621a; Bump nur ZUSAMMEN mit XML-Byte-Stabilitaets-Beleg."
- **Designplan-tdd T-6 SCHWESTERPFLICHT** (Z.72, generischer Massstab): „Jeder Fix und jeder Test
  sucht im selben Zug die Schwesterstelle" — durch den KLASSEN-Befund (P-01) UND den E1#7-
  Nachzug (P-12) UND den T9-Lizenzfix (P-14) mehrfach sichtbar erfuellt.
- **Designplan §3 Deckungsfrage** (Z.65, nach §11.3): „was erzwingt das Halten?" — zulaessig ist
  nur ein Werkzeug oder eine benannt ungedeckte Stelle.

---

## NICHT-GEFORDERT (damit das Audit keine Phantom-Funde macht)

- **D-10(b) registry-roundtrip-SHA-Pin selbst** ist NICHT Teil von #107 — bereits unter #104/
  KON119-04 gelandet (Branch-CI 16048 SUCCESS 9/9). Der Strang liess das Script bewusst
  UNANGETASTET; kein Unterlassungs-Defekt.
- **Die Harmonisierung/der Bump des registry-roundtrip-Pins auf 66de5c09 (oder juenger)** ist ein
  separat deklarierter FOLGEPOSTEN nach der Landung (H-18, F-86 „OFFEN — BEWUSST"), NICHT Teil der
  #107-Abnahme selbst.
- **Der volle CI-DUAL-COMPILER-Auftrag (#106/D-6)** — die Owner-KERN-Erhebung „doppelter
  Compile-Test fuer ALLE Bereiche" ueber saemtliche Pipelines aller Repos (Ledger KON119-05: „9/41
  Bau-/Test-Jobs unbedingt dual; 13/23 Konfigurationen sehen NIE clang"; D-6 nennt separat „R8
  K-13 prt-art-Zwilling", objekt-bestaetigt als eigener Branch `bau/ci-dual-prtart` @ `7444ad1`,
  „Key-Hygiene komplett, build:standalone einziger Writer des globalen Keys") — ist ein eigener,
  groesserer Strang. #107 bindet lediglich die BEREITS BESTEHENDEN `build:clang`/
  `build:clang:debug`-Jobs in die neue Pin-Familie ein; es baut keine neuen Dual-Compiler-Jobs.
- **Der tatsaechliche Push und die echte Branch-CI-Ausfuehrung** dieses Worktrees waren dem
  Strang ausdruecklich untersagt bzw. sind Lande-Zug-Aufgabe (Steckbrief: „KEINE Schreib-Fixes in
  diesem Worktree"; H-18/Phase 3/Schritt 14). Das Fehlen eines CI-Beweises im Strang-Bericht ist
  KEIN Strang-Defekt, sondern der geplante Zwischenzustand.
- **FINDINGS#13 (registry_roundtrip.cmake-Kopf) und FINDINGS#14 (prt-art-HEAD)** sind formal den
  Tasks A-8 bzw. A-13 zugeordnet, NICHT D-10. Ihre Bearbeitung durch pinduo ist eine zusaetzliche,
  ueber den D-10-Wortlaut hinausgehende Lieferung (T-6-SCHWESTERPFLICHT-konform), aber ihr
  Vorhandensein zaehlt nicht als „mehr als D-10a/c gefordert = Bonus" — es sind eigenstaendige
  Posten mit eigener ABNAHME.
- **Designplan-tdd T-1..T-5, T-7..T-9 fuer die 3 urspruenglichen CI-Infrastruktur-Dateien**
  greifen nicht: reine CI-YAML- + CMake-Kommentar-Aenderung, kein neuer Testcode.
- **T-11a-c, T-12a-e** (Warmup-Paar, Drift-Gate-Debug-Test, Mutations-Protokoll als S-3/KON55-
  Sonderklasse, Arena-/Full-Join-Schema-Tests) sind mess-/statistik-/arena-spezifische TDD-
  Sonderpakete ohne jeden Bezug zu einer CI-Pin-Aenderung.
- **xlsx-Doktrin / Messkette / GOAL-v8-Messdoktrinen** greifen nicht: #107 produziert keine
  Messwerte, keine CSV-/xlsx-Ausgabe.
- **Die Harmonisierung mit der parallelen `bau/w1luecken-prtart`-Faehrte („B14")** ist NICHT
  #107s eigener Auftrag. Laut Rezept (Ledger KON120-04/KON121, „unveraendert dahinter") laeuft
  pinduo ZUERST, B14 DARAUF — das Aufloesen des objektiv bestaetigten Merge-Konflikts (P-15) ist
  Lande-Zug-Sache.
- **Die Board-Task-ANLAGE selbst (A-3, „Z-2-Task-Anlage prt-art-roundtrip-SHA-Pin")** ist ein
  eigener, fruehester Posten in SLOT [A] mit eigener ABNAHME „Board-Task existiert"
  (W2-ABFOLGE-DESIGN.md:53-55) — Vorbedingung, nicht #107s Nachweispflicht.
- **Kein neuer ctest-Test, keine `tests/unit/CMakeLists.txt`-Aenderung** wird gefordert — D-10
  ist eine CI-Infrastruktur-Auflage, kein benannter Posten des 117er-TDD-Katalogs (0 Treffer fuer
  „prt-art"/„Pin" in der Designplan-Postenliste).

---

## SPANNUNGEN (nicht glattgezogen)

**S-1. Wortlaut vs. tatsaechliche Bau-Menge (Scope-Auslegung, keine Quelle-gegen-Quelle-
Kollision).**
D-10(a) benennt im Wortlaut (W2-ABFOLGE-DESIGN.md:377-379) UND in KON119-04 (Ledger:305-306)
jeweils nur den EINEN Job „build:standalone" (Singular), rahmt ihn aber als „Fehlerklasse"/
„Schein-Gruen-Klasse". Der Strang erweitert eigenstaendig auf 5 Jobs unter Berufung auf die
NIE-KUERZEN/LUECKE=PFLICHT-Doktrin — in sich schluessig und selbst transparent als „weiter als der
Wortlaut" ausgewiesen (E1#2). Keine der SOLL-QUELLEN sanktioniert die 5-Job-Menge VORAB
ausdruecklich (keine juengere KON, kein Wellenplan-Nachtrag nennt sie explizit). Das Audit muss
werten, ob die eigenstaendige Scope-Erweiterung ohne vorherige Owner-Vorlage zulaessig war
(Doktrin spricht dafuer) oder eine eigene Kenntnisnahme-Zeile im naechsten Owner-Fenster braucht.

**S-2. PIN-WERT-DIFFERENZ zwischen Klassen-Pin (66de5c09) und D-10b/registry-roundtrip-Pin
(196a621a) — beide „deterministisch" im Sinne der Abnahme-Formel, aber NICHT identisch.**
Harmonisierung bewusst auf Landung vertagt (LANDUNG-HARMONISIERT-Doktrin, Memory-Index); Meldepflicht
in E1#4/E1#4-PRAEZISIERUNG erfuellt. STAFFEL2-SYNTHESE F-86 bestaetigt: „OFFEN — BEWUSST".

**S-3. FINDINGS#13/#14-Nummernkollision zwischen dem strang-internen Explore-Zaehler und dem
offiziellen K5-Katalog.**
Der pinduo-Strang setzt „FINDINGS#13"/„#14" als eigene, waehrend des E1-Explore fortlaufend
vergebene Labels (Fortsetzung von #11/#12 aus dem D-10-Block). Beide Nummern sind im
K5-memory-findings-106-Katalog bereits ANDERWEITIG vergeben: #13->A-8, #14->A-13
(W2-ABFOLGE-DESIGN.md:845). Sachgegenstand ist in beiden Faellen identisch — keine inhaltliche
Verwechslung, aber eine Label-Doppelbelegung ueber Strang-Grenzen. Fuer #13 bereits per DEDUP
aufgeloest (F-87 „erledigt S1-F-62"); der A-8-Strang selbst blieb laut STAFFEL1-SYNTHESE bei „1x
ENTWURF (FINDINGS#13 prt-art)" stehen — AUDIT-EMPFEHLUNG (aus Runde-1 uebernommen): A-8-Landung
soll GEGEN f1fc5d8 verrechnen, nicht neu bauen. Fuer #14 sauber: pinduo beansprucht keine
Urheberschaft.

**S-4. Lande-Reihenfolge-Position: grobe Originalstelle „in Luecken" (SLOT [D]) vs. praezisierte
Endposition „Schritt 14 von 14" (juengere STAFFEL2-Fortschreibung).**
Die urspruengliche W2-ABFOLGE-DESIGN-Sequenz (SLOT [D], Z.817-824) reiht D-10 grob mittig ein
(„... D-10, D-11, D-13-Randslots in Luecken -> D-12 #19 main-FF -> D-9 #96-Schnitt als
Abschluss-Akt") und behandelt prt-art nicht gesondert (reine ce/super-Zwei-Repo-Betrachtung). Die
juengere, granularere STAFFEL2-SYNTHESE fuehrt H-18 „prt-art als DRITTES Lande-Repo" ein und
setzt pinduo explizit auf Schritt 14 von 14 — ALLERLETZTER Schritt, nach Phase 1 (ce, 10 Merges),
Phase 2 (super, 3 Merges) UND Phase 4 (Endstand-Gates), waehrend die fruehe Sicherung
(`push -o ci.skip`) bereits in Phase 0/Schritt 0c vorgezogen ist. STAFFEL2-SYNTHESE steht in der
vorgegebenen Rangfolge nicht explizit benannt zwischen „W2-ABFOLGE-DESIGN" und „Strang-Bericht" —
sie ist aber inhaltlich genau dort einzuordnen (Synthese mehrerer Strang-Berichte, spaeter
datiert). Das Audit sollte H-18 (Schritt 14 zuletzt) als das fuer die tatsaechliche Landung
massgebliche Detail behandeln, MUSS aber den Widerspruch zur groben SLOT[D]-Reihung benennen statt
still zu uebergehen. Ledger KON120-04/KON121 bestaetigt diese Reihenfolge zusaetzlich als weiterhin
gueltig („#107-Rezept ... unveraendert dahinter").

**S-5. Job-Token-Allowlist-Reichweite bleibt in den SOLL-QUELLEN unbelegt.** Siehe P-19 — reine
Inferenz, keine Quelle bestaetigt oder verneint, ob die #104-Allowlist automatisch die 5 neuen
Jobs deckt.

**S-6. „Staffel 2 hat auftragsgemaess in ALLEN drei Repos KEIN YAML angefasst"
(STAFFEL2-SYNTHESE.md:270) — aufgeloest, KEIN echter Widerspruch zu F-85/P-01.**
Dieser Satz bezieht sich NACHWEISLICH nur auf den separaten E-10/E-14/E-15-YAML-Zug (super-/
ce-Topologie-Variablen, Chaos-Drift-CI-Job, Tag-Mismatch), nicht auf pinduos eigene, disjunkte
prt-art-`.gitlab-ci.yml`-Pin-Aenderung. Derselbe Abschnitt raeumt 7 Zeilen spaeter selbst ein:
„prt-art-Scope pruefen: pinduo aendert dessen YAML bereits (Pin-Familie)" (Z.277). Hier benannt,
damit das Audit es nicht als Widerspruch fehl-liest.

**S-7. [NEU] Zeitliche Luecke zwischen Audit-Runde-1 (22.08., Objekt-Snapshot @ 4941c41) und dem
JETZIGEN Objektstand (23.08., @ 25bbf2e).**
Runde 1 hat ein vollstaendiges, sauberes Verdikt („SITZT", 1 KLEIN) fuer den Objektstand @4941c41
gefaellt. Der Branch traegt seither einen dritten Commit (P-14), den weder die urspruengliche
soll-karte noch Runde 1 kennen konnten. Der neue Commit ist inhaltlich eine SINNVOLLE, gut
belegte Ergaenzung (schliesst eine Luecke, die eine ECHTE Branch-CI sonst blockiert haette) und
KEIN Widerspruch zu Runde 1s Verdikt — aber Runde 1s Verdikt deckt NICHT den 25bbf2e-Stand. Eine
evtl. Runde 2 sollte NICHT bei Null neu pruefen (P-01..P-13/P-15/P-16 bleiben unveraendert
gueltig, da `.gitlab-ci.yml`/die beiden `.cmake`-Dateien seit `4941c41` unangetastet sind),
sondern gezielt NUR den Delta-Commit (P-14) plus den aktualisierten Push-/Ref-Stand (P-13) neu
verifizieren — inklusive der clang-format-22-Pruefung auf `lizenz_audit.hpp`, die bislang in
KEINER Quelle stattfand.

**S-8. STEMPEL-KUERZEL „B14": Namenskollision zwischen `bau/w1luecken-prtart`s lokalem Kuerzel und
einer aelteren, thematisch unverwandten Ledger-Position gleichen Namens.**
Siehe STAND-DELTA oben. Das „B14" in Ledger Z.22926ff (§38/§38.b Dock-Serialisierung, Juli 2026)
ist ein VOLLSTAENDIG ANDERER Gegenstand als das „B14" in der Commit-Botschaft von
`bau/w1luecken-prtart` (W1-Luecken-Reihe, 21.08., ce-Determinismus-Pin). Beide Kuerzel im Audit
NICHT zusammenfuehren.
