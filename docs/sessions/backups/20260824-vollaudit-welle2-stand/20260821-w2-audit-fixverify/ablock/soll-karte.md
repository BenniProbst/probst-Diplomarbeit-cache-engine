# SOLL-KARTE — Aufgabe "ablock" (Strang a-block-docs)

Erhoben: 21.08.2026 · Rolle: Sonnet-max Planungs-Erheber (NUR LESEN, kein Fix) · Objekt-Klon: super-Hauptklon (nur gelesen, `git show`/`log`/`merge-base` gegen Branch-Refs)

STECKBRIEF: a-block-docs = A-Block-Memory-/Docs-Ernte (Lead-Entscheid 21: a-block-Memory-Zug), committet als **a5dc8095**. Kein Bau-Zweig (Doku-/Read-only-Strang). Ergebnis-Bericht voll gelesen: `~/backups-workflow/20260820-w2-sofortstaffel/a-block-docs-ergebnis.md` (366 Z.).

## SCOPE-EINORDNUNG (vor der Pruefliste, damit das Audit den Massstab kennt)

Der Strang definiert seinen eigenen Auftrag in Zeile 3 seines Ergebnis-Berichts: **"W2-ABFOLGE-DESIGN Teil [A] OHNE A-1/A-2 (erledigt) und OHNE Ledger-Schreiben (Lead-only)."** Teil [A] (W2-ABFOLGE-DESIGN.md:37-126) zaehlt **21 Posten A-1..A-21**, mit eigenem Zaehler-Satz Z.126: *"[A]-Zaehler: 21 Posten (A-8 traegt 11, A-9 traegt 5 namentliche Teilpunkte)."* Das ergibt **31 atomare Pflicht-Punkte A-3..A-21** (21 Buchstaben-Posten minus A-1/A-2, minus 2 fuer A-8/A-9 als Sammelposten, plus 11+5 Teilpunkte = 19-2+11+5 = 33; korrekt gezaehlt: A-3,A-4,A-5,A-6,A-7 (5) + A-8-Teilpunkte (11) + A-9-Teilpunkte (5) + A-10..A-21 (12) = **33 atomare Punkte**).

Der eigene **Status-Tafel FINAL** des Strangs (Ergebnis-Datei Abschnitt 3, Z.131-149) traegt jedoch nur **14 Zeilen**: A-5, A-6, A-8/X-3, A-8/K7b-5, A-8/T-5+Z-12, A-8/D-08, A-8/FINDINGS#13, A-9 (als EIN Sammel-Eintrag fuer 5 Teilpunkte), A-13, A-14, A-15, A-16, A-17, A-21. Das deckt **19 der 33 atomaren Punkte** (5 Einzelpunkte + 5 von 11 A-8-Teilpunkten + alle 5 A-9-Teilpunkte + A-21 = 5+5+5+1... exakt: A-5,A-6,A-13,A-14,A-15,A-16,A-17,A-21 = 8 Einzelposten + 5 A-8-Teilpunkte + 5 A-9-Teilpunkte = **18 von 33**). Die STAFFEL1-SYNTHESE.md (juengste Schicht, 21.08., Z.22) uebernimmt diese 14-Zeilen-Tafel als Massstab und wertet **"Lieferung komplett"** — gegen den EIGENEN Auftragstext ("Teil [A] ohne A-1/A-2") ist das eine engere Lesart. Siehe SPANNUNGEN unten fuer die 13 dadurch nicht direkt quittierten Punkte.

---

## PRUEFLISTE

Format je Punkt: **WAS** (Wortlaut+Quelle) · **PRUEFBAR** (Objekt/Kommando) · **BEHAUPTET** (Status laut a-block-docs-ergebnis.md, ggf. mit Fremdbeleg).

### A-3..A-7 (Einzelposten)

**P-01 — A-3 Z-2-Task-Anlage prt-art-roundtrip-SHA-Pin.**
WAS: *"Z-2-Task-Anlage prt-art-roundtrip-SHA-Pin (=T-6/K7b-3; Anlage SOFORT, Bau/Kontrolle in [D] D-10b). ... ABNAHME: Board-Task existiert."* (W2-ABFOLGE-DESIGN.md:53-55; Wellenplan §22.2 T-6, Z.3273-3278: *"NACHZUG: 13.7-Vollzaehligkeits-Gegenprobe dokumentieren + W2-Board-Task SOFORT anlegen, spaetestens Di 25. (#96; 22.4 Z-2)."*).
PRUEFBAR: Board-Task-Liste/`TaskGet` auf einen Task mit Titel/Inhalt "prt-art-roundtrip-SHA-Pin" oder "K7b-3" pruefen.
BEHAUPTET: **NICHT im a-block-docs-Ergebnis erwaehnt** (0 Treffer "A-3"/"Z-2"/"T-6" in der Status-Tafel). Der SUBSTANZ-Fix ist laengst gebaut+CI-bewiesen (#104, K7b-3, Pipeline 16048 SUCCESS) UND ein zweiter Zug (prtart-pin-duo, Task #107) haengt eine fuehrende Fassung nach — die reine *Task-Anlage* selbst (Board-Eintrag) ist in keiner gelesenen Quelle als existent belegt.

**P-02 — A-4 T-18-Kontrolle §22-Sweep-Vollzug.**
WAS: *"§22 committet + Task-Anlagen laut §22.4 Z-1..Z-15 vorhanden (KON119 ist juenger, daher Kontrolle statt Neuvollzug). ... ABNAHME: Commit-/Task-Belege zitiert."* (W2-ABFOLGE-DESIGN.md:56-58; Wellenplan §22.2 T-18, Z.3359-3365: *"GETRAGEN: bisher NUR durch den laufenden wf_d42115cb + Owner-Order 19.08. FEHLT: in Wellenplan (endete bei par.21.6), Board und Register war bis zu diesem Commit NICHTS persistiert ... NACHZUG: dieser Abschnitt vollzieht die Persistierung; die Task-Anlagen/-Updates laut 22.4 sind der zweite Teil (Anlage-Liste liegt der Lead-Session vor)."*).
PRUEFBAR: `git log` auf den Wellenplan-Commit, der §22 einbrachte (bereits als committet vorausgesetzt, seit 19.08.) + Board-Abgleich gegen die 15 Z-Zeilen (Z-1..Z-15, §22.4).
BEHAUPTET: **NICHT im a-block-docs-Ergebnis erwaehnt** und in KEINEM der anderen elf gelesenen `*-ergebnis.md`-Dateien gefunden (Grep "T-18"/"T18"/"Sweep-Vollzug" = 0 Treffer im gesamten sofortstaffel-Ordner). Kandidat fuer eine echte Luecke — Audit sollte direkt gegen `TaskGet`/Board pruefen, ob die Z-1..Z-15-Liste als Tasks existiert.

**P-03 — A-5 X-2-SOFORT-Haelfte (k2-Vollbau-bg-Outputs sichern).**
WAS: *"k2-Vollbau-bg-Outputs nach ~/backups-workflow sichern (Nachbuchung der G3/G4-Literale dann in #93-A, [C] C-9). ... ABNAHME: Outputs gesichert."* (W2-ABFOLGE-DESIGN.md:59-61; Quelle K3:TeilB/X-2).
PRUEFBAR: `ls ~/backups-workflow/20260819-k2-vollbau-outputs/` + `ls ~/backups-workflow/20260821-k2-vollbau-logs-nachzug/`.
BEHAUPTET: **JA, ERLEDIGT** (Ergebnis Abschn. 4.1): zwei bg-Outputs bereits 19.08. gesichert (`bl5ldht9z.output`/`bb3upsvgg.output`, je 46 B, Inhalt `BUILD_ALL_RC=0`) + additiver Nachzug 21.08. (19 Dateien aus `~/.claude/jobs/5a19728e/tmp/` + 2 Build-Protokolle aus `wt-ce-k2`, dort untracked). Objekt-Check moeglich per `ls`.

**P-04 — A-6 X-16-Rest (Repo-BU-Nachzug + K12-10-Patches pruefen).**
WAS: *"Repo-BU-Nachzug + K12-10-Patches pruefen (BU-Ordner bereits GELANDET @9052a56b). ... ABNAHME: Nachzug belegt ODER Leer-Befund dokumentiert."* (W2-ABFOLGE-DESIGN.md:62-64; Quelle K3:TeilB/X-16 + TeilJ).
PRUEFBAR: `git -C super log --oneline -- docs/sessions/backups/20260819-kontext14-workflows/` + `ls ~/backups-workflow/20260819-bump15b-patches/`.
BEHAUPTET: **JA, ERLEDIGT** (Ergebnis Abschn. 4.2): Repo-BU-Nachzug liegt in `docs/sessions/backups/20260819-kontext14-workflows/audit-wf794b904b-journal-ENDSTAND.jsonl` (super-Repo, additiv zum 18.08.-Teilstand), K12-10-Patches in `~/backups-workflow/20260819-bump15b-patches/` (69 Dateien, 3 benannte Klassen).

**P-05 — A-7 X-7 wf_cd301f28-Endzeile quittieren.**
WAS: *"X-7 wf_cd301f28-Endzeile quittieren (KEINE Doppel-Ernte, Inhalt bereits konsolidiert). ... ABNAHME: Quittung im Journal-Sicherungszug B.3."* (W2-ABFOLGE-DESIGN.md:65-66; Quelle K3:TeilB/X-7).
PRUEFBAR: Journal-Sicherungszug (§Teil B.3 des W2-ABFOLGE-DESIGN, nicht Teil meines Lese-Auftrags) auf eine Quittungszeile fuer wf_cd301f28 pruefen.
BEHAUPTET: **NICHT im a-block-docs-Ergebnis erwaehnt.** ACHTUNG NAMENSKOLLISION: `s13-schema-kette-ergebnis.md` fuehrt ebenfalls ein "X-7", aber das ist ein ANDERES Objekt (S-13-Bau-Unterposten X-1..X-9 aus K2/K4, dort explizit *"X-1..X-5/X-7..X-9 + S13-04ff (Arena)... Folgestaffel-Posten, ausdruecklich NICHT dieser Strang"*) — nach der Stempel-Kuerzel-Zerlege-Regel sind das NICHT dieselbe Groesse (A-7s Quelle ist K3:TeilB, s13-schema-kettes X-7 stammt aus K2/K4-Nummerierung). Kein Fremdbeleg fuer A-7 selbst gefunden — Kandidat fuer echte Luecke, Audit sollte den Journal-Sicherungszug B.3 direkt pruefen.

### A-8 — DOCS-ZUG-BUENDEL (11 Teilpunkte, ABNAHME: *"jeder Teilpunkt einzeln abgehakt (11 Teilpunkte)"*, W2-ABFOLGE-DESIGN.md:77)

**P-06 — A-8/X-3 #85-Text-Delta 17:45-Zusaetze.**
WAS: Quelle K3:B/X-3 (in A-8-Zeile referenziert, W2-ABFOLGE-DESIGN.md:68).
PRUEFBAR: Board-Task #85-Text auf "17:45-Zusaetze" UND auf den X-3b-Zusatz ("synthese-p20-roh.json NUR als DELTA") pruefen.
BEHAUPTET: **TEIL-ERLEDIGT** (Ergebnis Abschn. 4.3): 17:45-Zusaetze-Haelfte steht bereits im Task-Text (nicht vom Strang selbst eingebracht); die zweite Haelfte X-3b ("synthese-p20-roh.json NUR als DELTA gegen §20") fehlt im Task-Text und liegt nur als ENTWURF vor (Lead muesste den Task-Text ergaenzen). Board-Task #85 traegt aktuell laut Task-Liste in dieser Session bereits den Zusatz *"X-3: 17:45-Zusätze abhaken; X-3b: synthese-p20-roh.json NUR als DELTA gegen den stehenden §20 einarbeiten (§20 steht seit K11 — KEIN Neueinbau)"* (Task #85) — X-3b ist damit objekt-seitig bereits im Board-Tasktext gelandet.

**P-07 — A-8/K7b-5 KON74-04-"Fassung 4"-Vermerk.**
WAS: *"K7b-5 KON74-04-'Fassung 4'-Vermerk (K3:C)."* Quelle SESSION-DOK: *"[K7b-5] KON74-04 ohne Superseded-Vermerk auf KON80-01/V3; Fassungshistorie ohne 'Fassung 4' ... -> Docs-Zug."*
PRUEFBAR (docs-Haelfte): `git show a5dc8095 -- docs/plaene/20260809-MEASURESTORAGE-design-und-deep-research.md`. PRUEFBAR (Ledger-Haelfte): `grep -n "SUPERSEDED-VERMERK" docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (Ziel: Text unter der Ueberschrift `### KON74-04 -- W-E2: xlsx-SOLL GEHOBEN ...`, Ledger:3208).
BEHAUPTET: **docs-Haelfte JA, Ledger-Haelfte NEIN.** Objektiv verifiziert: `a5dc8095` traegt den Marker Z.159-174 in `MEASURESTORAGE-design-und-deep-research.md` (+16 Zeilen; nennt KON80-01/V3, KON87-Design, Sheet-EBNF, V-A9-6 ENTSCHIEDEN). Der Ledger-Superseded-Vermerk (Ergebnis Abschn. 2, woertlicher ENTWURF-Text vorhanden) ist **objekt-seitig NICHT eingebaut** — `grep -c "SUPERSEDED-VERMERK"` an KON74-04 (Ledger:3208) = 0 Treffer im gesamten Ledger. Ausstehend beim Lead (KON120-Ledger-Zug, siehe SPANNUNGEN).

**P-08 — A-8/JB-4 drei vl6-Ergebnis-Karten nachbuchen.**
WAS: *"JB-4 drei vl6-Ergebnis-Karten nachbuchen (K3:C)."* (W2-ABFOLGE-DESIGN.md:68-69).
PRUEFBAR: nicht abschliessend aus meinen Quellen bestimmbar — noetig waere K3:TeilC (karte-register.md), die NICHT Teil meiner SOLL-Quellen ist; Audit muesste direkt am Objekt pruefen, wo "vl6-Ergebnis-Karten" liegen (vermutlich `docs/sessions/backups/` oder `~/backups-workflow/`) und ob 3 davon "nachgebucht" (dokumentiert/verlinkt) sind.
BEHAUPTET: **NICHT im a-block-docs-Ergebnis erwaehnt.** 0 Treffer "JB-4"/"vl6-Ergebnis-Karten" im Ergebnis-Bericht. Kandidat fuer echte Luecke.

**P-09 — A-8/T-5,Z-12 F8-super-UEBERHOLT-Marker.**
WAS: *"T-5/Z-12 F8-super-UEBERHOLT-Marker (K2:§22.2 T-5)."* Wellenplan §22.2 T-5 (Z.3265-3271): *"20260809-KONFORMITAETS-REGISTER-teil2-stationen-5-bis-8.md, S7-HY-A-PAKETE '(22->23)' + 'HY-A3 toter Kommentar' -- UEBERHOLT-Marker per KON118 faellig. ... FEHLT: die super-Stelle lebt nur als WF-Quittung VERTAGT 'Platz: Docs-Zug' ... NACHZUG: an #85/super-Docs-Zug anhaengen ... (22.4 Z-12)."*
PRUEFBAR: `git show a5dc8095 -- docs/sessions/20260809-KONFORMITAETS-REGISTER-teil2-stationen-5-bis-8.md`.
BEHAUPTET: **JA, OBJEKT-VERIFIZIERT.** `a5dc8095` traegt den UEBERHOLT-Marker Z.211-218 (+9 Zeilen; zitiert KON118, benennt den Phantom-Nenner "22", den toten Kommentar `axis_reflect.hpp:4`, `kGenusBuildSlotCounts 5->6`). Eine ERSTE Stelle derselben Datei (Z.131 zur Zeit des Ergebnis-Berichts, nach dem 21.08.-Zug jetzt weiter verschoben) war bereits seit Commit `012a6087` (19.08., VOR diesem Strang) markiert. Beide Stellen tragen damit je einen datierten Marker.

**P-10 — A-8/T-13,Z-11 Register-3b-Buendel.**
WAS: *"T-13/Z-11 Register-3b-Buendel: Ledger-Marker 'prod1=24' korrigieren (real 16K/32T), SHA-Zuordnung 9f8e2be8-vs-3ba0f7b3, D-1-Kill-Switch-Hinweis (K2:§22.2 T-13)."* Wellenplan §22.2 T-13 (Z.3320-3326): *"GETRAGEN: nur Register Abschnitt 3b (Z.166-169) mit 'W2-Triage'-Vermerk. FEHLT: ausserhalb der Traeger-Abschnitte 12.4+13; kein Task-/Di-25-Slot, nicht in der 12.4-Docs-Zug-Liste. NACHZUG: die 3b-Zeile beim Di-25/#96 in den Docs-Zug uebernehmen (Ledger-Marker + D-2-Entscheid; 22.4 Z-11)."*
PRUEFBAR: Ledger-Grep nach "prod1=24" bzw. "prod1 = 24" (sollte NICHT mehr unkorrigiert stehen) + `git blame` auf die betroffene Zeile.
BEHAUPTET: **NICHT im a-block-docs-Ergebnis erwaehnt** (kein Zeilentreffer "T-13"/"Z-11"/"prod1=24" in dessen Status-Tafel). Indirekter Hinweis: eine eigene, bereits bestehende Memory-Referenz *"prod1 = 16 Kerne/32 Threads, die 24 war falsch"* existiert unabhaengig im Memory-System (nicht als Produkt dieses Strangs erkennbar — kein Datums-/Autorschafts-Beleg in meinen Quellen). Die SHA-Zuordnungs- und D-1-Kill-Switch-Haelften bleiben ganz ungeklaert. Kandidat fuer Teil-Luecke.

**P-11 — A-8/U-4 K16-Stopp-Baustein in Session-Vorlage B.0.**
WAS: *"U-4 K16-Stopp-Baustein in Session-Vorlage B.0 (K2:§22.1 U-4)."* Wellenplan §22.1 U-4 (Z.3226-3230): *"Audit-H4-OFFEN-Teil (Transkript Z70284): der K16-Stopp-Baustein (Schreiberwechsel-Protokoll) fehlt in der Session-Vorlage B.0; 0 Treffer in Board, par.18-21 und Register 12.4+13."*
PRUEFBAR: Session-Vorlage B.0 (Dokument-Fundort ausserhalb meiner SOLL-Quellen) auf einen "K16-Stopp-Baustein"/Schreiberwechsel-Protokoll-Absatz pruefen.
BEHAUPTET: **NICHT im a-block-docs-Ergebnis erwaehnt** (0 Treffer "U-4" in dessen Status-Tafel — die A-9-Zeile des Strangs nennt zwar "T-14/T-15/T-16" aber NICHT U-4, obwohl das Design U-4 explizit unter A-8 buendelt). Kandidat fuer echte Luecke.

**P-12 — A-8/D-08 15-Stationen-Memory-Nachzug.**
WAS: *"D-08 15-Stationen-Memory-Nachzug (K2:§19.4 D-08)."* Wellenplan §19.4 D-08 (Z.2514): *"D-08 15-Stationen-Kette: Plan-/Memory-Nachzug (8-Stationen-Memory korrigieren) (Z14663)."*
PRUEFBAR: `Read` auf `project_verarbeitungskette_acht_stationen_hardware_job_pool.md` (Memory-Datei).
BEHAUPTET: **JA, OBJEKT-VERIFIZIERT, VOLLZOGEN.** Datei-Metadaten `modified: 2026-08-21T09:04:26.074Z` (Zeitfenster von `a5dc8095`, 09:02:36); Inhalt Z.11-14: *"UEBERHOLT (Owner 09.08. abends... Nachzug W2/D-08 21.08.): die Kette hat FUENFZEHN Stationen"* mit vollstaendiger 1-15-Liste. Frontmatter-Description nennt ebenfalls "FUENFZEHN-gliedrige...Korrektur W2/D-08". Dateiname selbst blieb historisch `..._acht_stationen_...` (Doku-Doktrin: Historie nie loeschen, Korrektur additiv) — das ist KEIN Fehler, sondern der bewusste Bestandsschutz.

**P-13 — A-8/FINDINGS#13 registry_roundtrip.cmake-Kopf deprecaten.**
WAS: *"FINDINGS#13 registry_roundtrip.cmake-Kopf deprecaten (K5:C#13)."* Quelle K5:C#13 (karte-memory-findings-106.md).
PRUEFBAR: `git -C prt-art show <Tip>:prt_art/registry_gen/registry_roundtrip.cmake | head -30` gegen den zu landenden Stand.
BEHAUPTET: **NUR ENTWURF, Datei nicht editiert** (Ergebnis Abschn. 4.5, woertlich: *"ENTWURF (Datei NICHT editiert)"*). **FREMDBELEG WICHTIG:** `prtart-pin-duo-ergebnis.md` (Staffel-1-Strang) hat DENSELBEN Befund unabhaengig erhoben UND tatsaechlich UMGESETZT — Branch `bau/pinduo` @ `4941c41`, Zitat: *"registry_roundtrip.cmake-Kopf (FINDINGS#13): neue REFERENZ-KONFIGURATION (SEIT K7b-3/#104...) + HISTORIE (ueberholte Fassung...)-Marker; Alt-Block BYTE-IDENTISCH erhalten."* Diese Fassung ist laut Task #107 die "FUEHRENDE Fassung" fuers Landen. Siehe SPANNUNGEN — zwei Formulierungen desselben Fixes im Umlauf.

**P-14 — A-8/W1-W16-Marker-Kontrolle (docs-only EIN Commit).**
WAS: *"W1-W16-Marker-Kontrolle docs-only EIN Commit (K2:§19.6)."* Wellenplan §19.6 (Z.2582-2622) listet 12 MARKER-AUFTRAEGE (W1 Arena/6GB, W2 Mess-Nenner, W3 Mess-Ebenen, W4 Lastsequenz, W5 3/2/2-Gesetz, W6 HW-Erkennung, W7 Parallel-Deckel, W10 --debug-Ende, W11 Change-Date, W12 Dock-32, W15 Repo-Rollen, W16 checkpoint_measure-Name) — je *"Marker AM ORT, Zeile bleibt"*.
PRUEFBAR: je Marker-Ziel-Datei/-Ledger-Stelle auf den benannten Marker-Text pruefen (12 Einzelproben).
BEHAUPTET: **NICHT im a-block-docs-Ergebnis erwaehnt.** 0 Treffer "W1-W16"/"Marker-Kontrolle" in der Status-Tafel. Kandidat fuer echte Luecke (12 Einzelmarker ungeprueft).

**P-15 — A-8/W18-merge-Zeile AUSTRAGEN, LEDGER:8941, Frist vor 26.08.**
WAS: *"W18-merge-Zeile AUSTRAGEN, LEDGER:8941, Frist vor 26.08. (K2:§19.6)."* Wellenplan §19.6 AUSTRAGUNG (Z.2620-2622): *"W18 merge-Zeile: Owner-Verbot steht; LEDGER:8941 (§59-MERGE-STEMPEL) AUSTRAGEN, bevor jemand den verbotenen Bestand baut — Trigger-Risiko 26.08."*
PRUEFBAR: `grep -n "MERGE-STEMPEL" docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` — Erwartung: KEIN offener/unmarkierter `[§59-MERGE-STEMPEL]`-Eintrag mehr ODER ein AUSTRAGEN-Vermerk direkt an der Stelle.
BEHAUPTET: **NICHT im a-block-docs-Ergebnis erwaehnt UND objekt-seitig NICHT vollzogen — SIEHE SPANNUNGEN (zeitkritisch, Trigger-Risiko 26.08.).**

**P-16 — A-8/##15-K6-Marker-Austragung :22951.**
WAS: *"##15-K6-Marker-Austragung :22951 (K3:TeilJ)."*
PRUEFBAR: Ledger-Zeile um :22951 (aktuelle Zeilennummer nach Drift geprueft) + Grep "##15-K6"/"derive_default_experiment_phases".
BEHAUPTET: **NICHT im a-block-docs-Ergebnis erwaehnt, ABER objekt-seitig BEREITS VOR DIESEM STRANG erledigt** — Ledger:107 (Teil des KON119-Kopfes, also VOR der Staffel geschrieben) traegt bereits: *"Ledger:22951-UEBERHOLT: ##15-K6 derive_default_experiment_phases() IST GEBAUT (K1-K4+K6 alle GEBAUT) -- der :22951-Marker ('ersetzt SPAETER') ist am Objekt UEBERHOLT."* Dieser Punkt war damit schon bei Strang-Start erledigt (wie A-1/A-2) — siehe NICHT-GEFORDERT.

### A-9 — MEMORY-ZUG-BUENDEL (5 Teilpunkte, ABNAHME: *"Memory-/ARBEITSWEISE-Dateien ergaenzt (5 Teilpunkte)"*, W2-ABFOLGE-DESIGN.md:82)

**P-17 — A-9/1 X-6/K9-3 tail-Fallen-Eintrag.**
WAS: Quelle K3:B/X-6=C/K9-3 (Dedup).
PRUEFBAR: `Read` Memory-Datei zum Fallen-Register auf tail-Fenster/LastTestsFailed/etc.
BEHAUPTET: **JA** (Ergebnis Abschn. 4.6, ENTWURF-Datei `a9-1-x6-k9-3-tail-falle-ENTWURF.md`) + **Lead-Vollzug bestaetigt** per LEAD-ENTSCHEIDE Nachtrag 21 (*"Fallen-Register +12 Eintraege (tail-Fenster, LastTestsFailed, CMakeCache-mtime, Basename, ctest-rechtsbuendig, ccache-Hits, ninja-[N-1/N], Target-Namen, gitlab.comdare.local, ENOSPC-Transkript, Queue-Verfall, Edit-Gegenlese, Rot-Lauf-Buchung)"*).

**P-18 — A-9/2 A16-A18 sechs Einzel-Lehren.**
PRUEFBAR/BEHAUPTET: **JA** (Ergebnis Abschn. 4.6, ENTWURF `a9-2-a16-a18-sechs-einzel-lehren-ENTWURF.md`), gedeckt durch dieselbe Lead-Nachtrag-Liste (s.o.).

**P-19 — A-9/3 T-14 K15-Neuzugaenge.**
WAS: Wellenplan §22.2 T-14 (Z.3328-3335): 5 benannte Neuzugaenge (gitlab.comdare.local-Regel, Rot-Lauf-Logs-Pflicht, Transkript-Z45-Artefakt, F5-Edit-Wortlaut-Gegenprobe, Queue-Verfall-Lehre).
BEHAUPTET: **JA** (Ergebnis Abschn. 4.6, `a9-3-t14-k15-neuzugaenge-ENTWURF.md`); alle 5 Elemente erscheinen auch in der Lead-Nachtrag-Liste oben (gitlab.comdare.local, Rot-Lauf-Logs, Queue-Verfall etc.) — deckungsgleich.

**P-20 — A-9/4 T-15 Pre-Push-Gate-Doktrin-Rest.**
WAS: Wellenplan §22.2 T-15 (Z.3337-3342): *"Memory-Eintrag zum Script (K3/H6 'Werkzeug schlaegt Disziplin') + Regel 'Komplex-Fix-Stufe auch bei kleinen Wellen namentlich besetzen' (GOAL-IV.2)."*
PRUEFBAR: `ls` + `Read` `reference_pre_push_gates_sechs_gates_und_komplex_fix_traeger.md`.
BEHAUPTET: **JA, OBJEKT-VERIFIZIERT.** Datei existiert, `modified: ...09:03` (im a5dc8095-Zeitfenster) — mtime `Aug 21 09:03`. Diese Datei ist auch in meiner eigenen system-reminder-MEMORY.md als aktiver Index-Eintrag gelistet (*"PRE-PUSH-GATES 6x + KOMPLEX-FIX-TRAEGER"*).

**P-21 — A-9/5 T-16 Beweisort-Umschrieb + COMDARE_WACHE_STRIKT=1 in L1-Checkliste.**
WAS: Wellenplan §22.2 T-16 (Z.3344-3349).
PRUEFBAR: `Read` `reference_beweisorte_gesicherte_kopien_und_wache_strikt.md`.
BEHAUPTET: **JA, OBJEKT-VERIFIZIERT.** Datei existiert, mtime `Aug 21 09:04`; auch im eigenen system-reminder-MEMORY.md gelistet (*"BEWEISORTE = GESICHERTE KOPIEN ... WACHE_STRIKT=1"*).

### A-10..A-21 (weitere Einzelposten)

**P-22 — A-10 FOLGE-BU-ZUG JB-2 + T-17 fixstrecke2-logs-Schnappschuss.**
WAS: *"JB-2 (8 Dateien + f45e995b-tsan-Patch) + T-17 fixstrecke2-logs-Schnappschuss MIT neuer Redaktionspruefung. ... ABNAHME: additiver BU, Redaktion geprueft."* (W2-ABFOLGE-DESIGN.md:83-85; Wellenplan §22.2 T-17, Z.3351-3357).
PRUEFBAR: `ls docs/sessions/backups/20260819-kontext14-workflows/` auf den NEUEN fixstrecke2-Schnappschuss + Redaktionsprotokoll.
BEHAUPTET: **NICHT im a-block-docs-Ergebnis erwaehnt.** JB-2/T-17 tauchen NUR in `verify-93-ergebnis.md` im Umfeld einer anderen Messung (A/B-Paarlauf-Reproduktion) auf — kein klarer Liefer-Satz fuer die BU-Nachzug-Handlung selbst gefunden. Kandidat fuer Luecke oder Fremd-Lieferung — Audit sollte `verify-93-ergebnis.md` direkt auf einen A-10-Quittungssatz pruefen.

**P-23 — A-11 X-8/#95-Sicherung (Branch bau/v08r-fingerprint-sha auf origin sichern).**
WAS: *"Branch bau/v08r-fingerprint-sha auf origin sichern (`git push -o ci.skip`, reine Ref-Sicherung K5/A1-V6). ... ABNAHME: Branch auf origin sichtbar."* (W2-ABFOLGE-DESIGN.md:86-89).
PRUEFBAR: `git ls-remote origin refs/heads/bau/v08r-fingerprint-sha` + `git merge-base --is-ancestor`.
BEHAUPTET: **NICHT von a-block-docs, aber vollstaendig durch EINEN ANDEREN Strang (kontrollblock) objekt-geprueft und als erledigt/gegenstandslos befundet:** `kontrollblock-ergebnis.md:138-146`, woertlich: *"A-11 (X-8/#95-Sicherung) -- Befund: Branch-Sicherung NICHT noetig ... Der Branch liegt auf origin ... UND sein Tip 0f0742aa ist vollstaendig in development. Branch-Sicherung: NEIN (nichts zu sichern)."* A-11 ist damit sachlich erfuellt, aber NICHT durch a-block-docs geliefert.

**P-24 — A-12 X-17/6c-Publikation (23-Schritte-Deckungs-Matrix + 6b-Reparatur + Kuerzungs-Deklaration).**
WAS: *"23-Schritte-Deckungs-Matrix publizieren, 6b-Zeile seg1-81 reparieren, Kuerzung deklarieren (Lead-docs-Zug NACH WF-Rueckkehr; 6c existiert noch nicht). ... ABNAHME: 6c je Schritt gedeckt/offen publiziert."* (W2-ABFOLGE-DESIGN.md:90-93).
PRUEFBAR: Suche nach einer Datei/einem Abschnitt "6c" (Nachfolger von 6b) in den BU-Ordnern.
BEHAUPTET: **NICHT im a-block-docs-Ergebnis erwaehnt.** Design-Text selbst erklaert dies als *"Lead-docs-Zug NACH WF-Rueckkehr"* — also explizit NICHT fuer den laufenden Strang gedacht, sondern fuer den Lead nach Staffel-Rueckkehr. X-17 taucht nur beilaeufig in `verify-93-ergebnis.md` (N-1..N-6-Matrix, "ETWAS ANDERES" als X-17) auf — kein Liefer-Beleg gefunden. Faktisch (noch) NICHT geliefert, aber laut Design-Text auch nicht zwingend a-block-docs' Aufgabe.

**P-25 — A-13 FINDINGS#14 prt-art-Klon HEAD zurueck auf development.**
WAS: *"prt-art-Klon HEAD zurueck auf development (nach Push). ... ABNAHME: `git branch` zeigt development."* (W2-ABFOLGE-DESIGN.md:94-95; Quelle K5:C#14).
PRUEFBAR: `git -C prt-art branch --show-current`.
BEHAUPTET: **JA** (Ergebnis Abschn. 4.7): *"branch --show-current = development; porcelain 0; Tip 777fff7."* Zusaetzlich unabhaengig durch `prtart-pin-duo-ergebnis.md` bestaetigt (*"FINDINGS#14 ... ist damit BEREITS ERFUELLT"*).

**P-26 — A-14 Betriebszeile Platte (FINDINGS#6 93-94%, eigene Anteile raeumen).**
WAS: *"eigene (nicht-root) Anteile SOFORT raeumen; root-Anteil = U-2 -> [OG-11]. ... ABNAHME: `df -h` vor/nach dokumentiert."* (W2-ABFOLGE-DESIGN.md:96-98).
PRUEFBAR: `df -h /` (aktuell) gegen den im Ergebnis dokumentierten Vorher/Nachher-Wert.
BEHAUPTET: **NUR GEMESSEN, NICHT GERAEUMT** (Ergebnis Abschn. 4.7, woertlich Status "GEMESSEN"): 31G frei/88% zum Messzeitpunkt (besser als FINDINGS#6 93-94%), Liste der Rueckgewinn-Kandidaten (build-kombibau 3.6G, build-l1 3.6G, super build/ 3.2G) erstellt — *"Loeschen = Lead"* laut Ergebnis. Die ABNAHME-Formel selbst verlangt nur "dokumentiert" (nicht zwingend geraeumt) — insofern formal erfuellt, aber die Wellenplan-Quelle (§22.1 U-2/Z-14) fordert eine tatsaechliche Raeumung als eigenen (root-gebundenen, Owner-Betriebspunkt) Folgeschritt, der hier ausdruecklich NICHT vollzogen ist.

**P-27 — A-15 T-1 KON119-Maschinenlesbarkeit.**
WAS: *"A2.5-Bilanz aus Quittungslisten, nie aus Prosa-Summen; 3 Quellen-Dateien nennen. ... ABNAHME: 3 Dateien im KON119-Zug genannt."* (W2-ABFOLGE-DESIGN.md:99-101; Wellenplan §22.2 T-1).
PRUEFBAR: `grep -n "A2.5-BILANZ MASCHINENLESBAR" docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (KON119-02) + Existenzprobe der 3 genannten Dateien.
BEHAUPTET: **JA, BESTANDEN** (Ergebnis Abschn. 4.8): KON119-02-Wortlaut zitiert, 3 Quellen (`fixstrecke1-ergebnis-wiq9ihup1.json`, `a25-runde2-ergebnis.json`, `fixr1_endquittung_fixstrecke2_vollstaendig.md`) mit Groessen-/Datums-Beleg existenzgeprueft.

**P-28 — A-16 A4+F-A-Kontrolle.**
WAS: *"KON119-Pflichten (F4/18.6(3)-Deklaration, F-A-Komplex-Fix-Deklaration, T-A-Ledger-Buchung C-3a) persistiert in fixr1_endquittung Abschnitt 0; F-A in KON119-/Merge-Botschaft deklariert. ... ABNAHME: Wortlaut-Belege zitiert."* (W2-ABFOLGE-DESIGN.md:102-105).
PRUEFBAR: `grep -n "F-A-KOMPLEX-FIX-NACHWEIS" docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (0 Treffer erwartet, siehe unten).
BEHAUPTET: **BESTANDEN MIT 1 REST** (Ergebnis Abschn. 4.8): F4/18.6(3) + T-A-Ledger-Buchung sind woertlich im KON119-Text belegt; das F-A-Komplex-Fix-Literal selbst steht NUR in der Merge-Botschaft `ea7df79b`, NICHT im KON119-Ledgertext — Ergebnis liefert dafuer einen Ledger-ENTWURF ("F-A-KOMPLEX-FIX-NACHWEIS..."). **OBJEKT-VERIFIZIERT: dieser ENTWURF ist NOCH NICHT im Ledger eingebaut** (`grep "F-A-KOMPLEX-FIX-NACHWEIS"` = 0 Treffer im gesamten Ledger). Ausstehend beim Lead.

**P-29 — A-17 K16-CHECK 13.7 (Vollzaehligkeit) + T-19/Z-15.**
WAS: *"wf_46805ad8-Quittungen gegen Deckungs-Tafel ... auf Vollzaehligkeit; T-19/Z-15 F-9-Sentinel+M-2-Einzelbeleg nachschlagen, falls VERTAGT -> HY-B-Task beim Di-25. ... ABNAHME: Vollzaehligkeit + T-19 BEHOBEN/VERTAGT-Beleg."* (W2-ABFOLGE-DESIGN.md:106-110; Wellenplan §22.2 T-19, Z.3367-3373).
PRUEFBAR: Deckungs-Matrix (Ergebnis Abschn. 4.9) gegen `fixr1_endquittung_fixstrecke2_vollstaendig.md` + `fixstrecke2-endergebnis-json` gegenlesen.
BEHAUPTET: **JA, VOLLZAEHLIG / T-19 BEHOBEN** (Ergebnis Abschn. 4.9): vollstaendige F1-F9/T-2/T-10/L21/B3/tools-3/M-5/18.6(3)-Matrix mit Einzelbelegen; T-19 mit zwei literalen Rot-/Gruen-Paaren (F-9-Linker-Fehler + TSan-Data-Race, je mit Gegenprobe) — **kein HY-B-Task noetig** (nicht VERTAGT). Ein kleines Akten-Delta dokumentiert (T-10-Zuordnungszeile fehlt in der md, steht aber im json).

**P-30 — A-18 F-G-Deklaration clang-debug-ENTLASTET fuer den Freeze-Check.**
WAS: *"clang-debug-ENTLASTET fuer den Freeze-Check mitfuehren (GEHEILT lt. §22.0(3); Rest=PIC-Hausnorm=T-4 -> [D] D-8b). ... ABNAHME: Deklaration im Freeze-Check-Text."* (W2-ABFOLGE-DESIGN.md:111-113).
PRUEFBAR: Freeze-Check-Protokoll/F2-Vorlagenfenster auf "F-G"/"A-18"-Zeile pruefen.
BEHAUPTET: **NICHT von a-block-docs, sondern vom Strang vorlagen-fenster geliefert:** `vorlagen-fenster-ergebnis.md:54`, woertlich: *"Teil 2: 3 NIE-KUERZEN-Zusatzbloecke aus B-4/[F]-F-II (OG-18, OG-19, F-G/A-18)."* A-18 ist damit sachlich in das F2-Vorlagenfenster (Freeze-Check-Dokument, Task #108 Z."vorlagen-fenster -> F2-Fenster FINAL... VOLLZOGEN 3e9ec644/8aae5cd2") eingegangen — NICHT durch a-block-docs.

**P-31 — A-20 F-F P2/P3-Vorlagen AM ORIGINAL par.21.6 bauen.**
WAS: *"F-F P2/P3-Vorlagen AM ORIGINAL par.21.6 bauen (Zulieferung ans [B]-Vorlagen-Fenster; Inhalt owner-gated -> [OG-3]/[OG-5]). ... ABNAHME: Vorlagen-Texte liegen dem Fenster bei."* (W2-ABFOLGE-DESIGN.md:119-121).
PRUEFBAR: Freeze-Check-Fenster auf P2/P3-Zeilen pruefen.
BEHAUPTET: A-20 ist **per eigener Design-Definition eine Zulieferung an das [B]-Vorlagen-Fenster**, NICHT an a-block-docs — der Auftragstext selbst weist es dem anderen Strang zu. `vorlagen-fenster-ergebnis.md` traegt P2/P3 (Z.17-18: *"P5-DELTA: #95 VOLLZOGEN..."*, P2 explizit im F2-Vorlagenfenster-Bestand referenziert). Siehe NICHT-GEFORDERT — dieser Punkt ist strukturell keine a-block-docs-Pflicht.

**P-32 — A-21 L2-Optionen A/B vorbereiten (g2-Funde 2-4).**
WAS: *"L2-Optionen A/B vorbereiten (g2-Funde 2-4, X-10-Rest; X-10 selbst ERLEDIGT cb856212). ... ABNAHME: Options-Entscheid dokumentiert, L2-Zug geplant."* (W2-ABFOLGE-DESIGN.md:122-124).
PRUEFBAR: Ergebnis Abschn. 4.10 gegen die Owner-Dauerregel "VERTAGT = nur Zwischenzustand" (Wellenplan §22.0(4)) pruefen; L2-Entscheid-Nachtrag im Ledger/Board suchen.
BEHAUPTET: **JA, DOKUMENTIERT** (Ergebnis Abschn. 4.10): beide Optionen (A = historischer Kurznachweis-Neulauf, ~1 Bau-Slot; B = Deklarations-Weg, 0 Bau-Slots, 4-Punkt-Beleg-Kette) ausgearbeitet, **Empfehlung B** ausgesprochen. **LEAD-ENTSCHEID BEREITS GEFALLEN:** LEAD-ENTSCHEIDE-zum-w2-design.md Nachtrag 20 (Z.76-82) bestaetigt woertlich *"L2-ENTSCHEID = OPTION B ... KEIN historischer 4-Zellen-Neulauf an cb856212"* mit derselben 4-Punkte-Kette — die Entscheidung ist getroffen, die TRAEGERFORM (Ledger-Zeile im naechsten KON-Zug) laut Ergebnis Abschn. 4.10 aber noch nicht als eigene Ledger-Zeile sichtbar (0 Treffer "L2-ENTSCHEID"/"Option B" im Ledger selbst).

---

## ABNAHME-FORMELN (woertliche Kriterien der Quellen)

**Design-Ebene (W2-ABFOLGE-DESIGN.md):**
- Gesamt-A-Block: *"[A]-Zaehler: 21 Posten (A-8 traegt 11, A-9 traegt 5 namentliche Teilpunkte)."* (Z.126)
- A-8-ABNAHME: *"jeder Teilpunkt einzeln abgehakt (11 Teilpunkte)"* (Z.77).
- A-9-ABNAHME: *"Memory-/ARBEITSWEISE-Dateien ergaenzt (5 Teilpunkte)"* (Z.82).
- Prozessregel K17/A2 (bindend fuer JEDEN Posten, auch wenn hier kein Bau stattfindet): *"NIE KUERZEN / VERTAGT nur mit Grund+Platz+Task; landen -> Vertagte durchziehen -> NACHLANDEN."* (Z.23-24, K5/A4).

**Wellenplan-Ebene (§22, juengste Schicht vor F2):**
- Owner-verbatim-Rahmen des ganzen §22-Sweeps: *"Ich sehe hier viele Aufgaben, die zu einem spaeteren Zeitpunkt relevant werden und noch gebaut werden muessen - diese duerfen nicht verloren gehen."* (Z.3162-3164, Owner 19.08.).
- VERTAGT-Dauerregel (traegt A-21/L2 direkt): *"VERTAGT-DAUERREGEL (Owner 19.08.): vertagt ist NUR Zwischenzustand -- landen, dann Vertagte durchziehen, NACHLANDEN; nie ueber Landungen tragen."* (§22.0(4), Z.3189-3191).
- Rangfolge bei Widerspruch: *"Bei Widerspruch: Owner-Wort schlaegt alles, Neueres schlaegt Aelteres."* (Z.3176).
- §19.6-W18-Formel (A-8-Teilpunkt, zeitkritisch): *"W18 merge-Zeile: Owner-Verbot steht; LEDGER:8941 (§59-MERGE-STEMPEL) AUSTRAGEN, bevor jemand den verbotenen Bestand baut — Trigger-Risiko 26.08."* (Z.2620-2622).
- Owner-verbatim hinter W18: *"Owner-E2 02.08. ('Merge Zeile kann daher nicht existieren')"* (Ledger:5089).

**GOAL-v8-Ebene (allgemeine Doktrinen, gelten auch fuer Docs-Arbeit):**
- V11 (Belegzeile): *"Die Messung muss aelter sein als der Satz. ... Jeder aus Kommentar, Ledger oder Bericht uebernommene Zahlenwert braucht eine eigene Ist-Messung, bevor daraus ein Bau-Posten wird."* (GOAL-v8 II.2).
- V1 (Berichte sind Beweismaterial): *"Jede Zahl, jeder SHA und jede Zustandsaussage aus einem Agentenbericht wird vor Weitergabe selbst gemessen oder ausdruecklich als ungeprueft gekennzeichnet."* (II.3) — genau das habe ich fuer diese Soll-Karte an den kritischen Punkten getan (a5dc8095-Diff, Ledger-Greps, Memory-Datei-mtimes).
- Nenner-Doktrin: *"Nicht '3 Fehler', sondern '3 von 14 Jobs'."* (II.5) — angewandt auf "18 von 33 atomaren Punkten direkt quittiert".
- Drei-Ebenen-Trennung: *"OWNER-WORT (Gesetz) · AGENT-BEHAUPTUNG (Material) · OBJEKT-BEFUND (gemessen)."* (II.8) — Struktur dieser Soll-Karte selbst folgt dieser Trennung (WAS=Owner/Design, BEHAUPTET=Agent, PRUEFBAR+meine Objekt-Checks=Objekt-Befund).
- Widersprueche NICHT glattrechnen (II.8) — Grund fuer die SPANNUNGEN-Sektion unten statt einer geglaetteten Zusammenfassung.

---

## NICHT-GEFORDERT (ausdruecklich nicht Teil der a-block-docs-Aufgabe)

1. **A-1 (#102/F6-golden-Zug) und A-2 (U-1/Z-1 s13-J-1-Rezeptfix)** — der Strang definiert seinen eigenen Scope explizit als *"Teil [A] OHNE A-1/A-2 (erledigt)"* (Ergebnis Z.4). Beide waren beim Strang-Start bereits vollzogen: A-1 per Task #102 (GEFAHREN, `kontrollblock-ergebnis.md`: *"A-1 #102 GEFAHREN: 9 golden-102-Commits in dev via ea7df79b"*), A-2 als docs-Ein-Zeiler im s13-Design-Dokument (separate Traeger-Spur, nicht dieser Strang).

2. **A-19 (9.3-Volltext einlesen)** — hat einen EIGENEN, parallelen Strang: LEAD-ENTSCHEIDE-zum-w2-design.md Nr. 10: *"A-19-Volltext-Luecke: eigener Lese-Strang in Staffel 2 (a19-volltexte)."* STAFFEL2-SYNTHESE.md:27 bestaetigt: *"a19-volltexte (A-19: 20-W2-Deklariert + L-B/L-D-Traeger + OV-1/OG-52) | LANDEREIF (read-only, 3/3 Auftragsteile)."* Kein a-block-docs-Gegenstand.

3. **A-20 (F-F P2/P3-Vorlagen)** — der Design-Text selbst weist es dem [B]-Vorlagen-Fenster zu ("Zulieferung ans [B]-Vorlagen-Fenster"); geliefert durch den Strang `vorlagen-fenster` (P2/P3 im F2-Fenster-Bestand, Task #108: *"vorlagen-fenster -> F2-Fenster FINAL + Freeze-Check VOLLZOGEN"*).

4. **Ledger-Schreiben selbst** (nicht nur ENTWUERFE) — der Strang definiert dies ausdruecklich als *"OHNE Ledger-Schreiben (Lead-only)"* (Ergebnis Z.4). Alle Ledger-Aenderungen (K7b-5-Superseded-Vermerk, F-A-KON119-Halbsatz, L2-Option-B-Ledgerzeile) sind bewusst nur als ENTWURF geliefert; ihre tatsaechliche Einarbeitung ist Lead-Sache (KON120-Ledger-Zug, Task #113).

5. **TDD-Vertrag T-1..T-9 (Designplan §3) und die T-11a-c/T-12a-e-Katalogposten** — sie regeln Testarbeit an BAU-Paketen (rot-zuerst, Nenner, Registrierung, atomare Landung). Der a-block-docs-Strang schreibt/aendert keinen Produktionscode und keine Tests (nur `.md`-Dateien) — der TDD-Vertrag hat hier keinen Gegenstand. Ebenso NICHT anwendbar: K17-Kombibau, Bau-Slot-Protokoll, `ctest`-Bilanzen — der Strang fuehrte explizit KEINEN Vollbau (*"KEIN Bau gefahren (docs-/BU-Strang, kein Vollbau) -> kein Bau-Slot gezogen"*, Ergebnis Z.129).

6. **GOAL-v8-CI-/Build-Doktrinen** (allow_failure-Verbot auf Job-Ebene, Hart-Gruen-Pipeline-Doktrin, xlsx-Ausgabe-Doktrin, EIN-BLECH-Regel) — betreffen laufende CI-Pipelines bzw. Mess-Ausgaben; der Strang loest keine Pipeline aus (Commit `a5dc8095` traegt bewusst `ci.skip`-aequivalente Zurueckhaltung: *"Push gebuendelt mit dem naechsten docs-Zug (R6/V5: keine CI waehrend die Staffel baut)"*).

---

## SPANNUNGEN (Widersprueche/offene Kanten zwischen Quellen — nicht glattgezogen)

**S-1 (Scope-Spannung, wichtigste Spannung dieser Karte).** Der Strang definiert seinen SOLL-Rahmen selbst als *"Teil [A] OHNE A-1/A-2"* — das sind 31 Wellenplan-referenzierte atomare Punkte (A-3..A-21 inkl. A-8s 11 und A-9s 5 Teilpunkte). Seine eigene FINALE Status-Tafel deckt nur 18 davon direkt (siehe SCOPE-EINORDNUNG). Die STAFFEL1-SYNTHESE.md (juengste Schicht, 21.08., Z.22) wertet dennoch *"LANDEREIF (Lieferung komplett; Vollzug = Lead)"* — das Wort "komplett" bezieht sich nachweislich auf die verengte 14-Zeilen-Tafel des Strangs, nicht auf den vollen Auftragstext seines eigenen Kopfsatzes. Von den 13 nicht direkt in der Tafel erscheinenden Punkten (A-3, A-4, A-7, A-8/JB-4, A-8/T-13+Z-11, A-8/U-4, A-8/W1-W16, A-8/W18, A-10, A-11, A-12, A-18, A-20) sind **4 objekt-seitig durch ANDERE Straenge sachlich erledigt** (A-11 kontrollblock, A-18+A-20 vorlagen-fenster) oder **vor Strang-Start bereits erledigt** (A-8/##15-K6, siehe P-16), **1 strukturell nicht a-block-docs zugewiesen** (A-12, laut Design-Text "Lead-docs-Zug NACH WF-Rueckkehr"), **2 unklar/ambivalent** (A-3 Task-Anlage-Status unklar, A-10 nur Randerwaehnung in verify-93), und **mindestens 5 ohne jeden gefundenen Beleg** (A-4, A-7, A-8/JB-4, A-8/T-13+Z-11-Rest, A-8/U-4, A-8/W1-W16-Kontrolle) — Audit sollte diese gezielt gegen das Objekt pruefen, bevor "komplett" fuer den gesamten [A]-Block gilt.

**S-2 (zeitkritisch — W18/Ledger-Merge-Zeile, A-8-Teilpunkt, P-15).** Der Wellenplan fordert seit §19.6 (19.08.) ausdruecklich die AUSTRAGUNG der `[§59-MERGE-STEMPEL]`-Zeile *"bevor jemand den verbotenen Bestand baut — Trigger-Risiko 26.08."* Objekt-Befund (21.08.): Der Eintrag existiert im Ledger **weiterhin unmarkiert als offener Bau-Posten** an Z.23173 (*"[§59-MERGE-STEMPEL] K7a Merge-Stempel-POD ... (OFFEN, hoch — golden-Fenster, GO-pflichtig ABI-nah.)"*) sowie als Cross-Referenz in Z.22959. Es existiert zwar eine RETROSPEKTIVE "UEBERHOLT"-Notiz an anderer Ledger-Stelle (Z.5088-5091, datiert auf ein 13.08.-Review, mit dem Owner-Zitat "Merge Zeile kann daher nicht existieren") — diese steht aber NICHT an der Quelle selbst (Z.23173), sodass ein Leser, der nur Z.23173 liest, den verbotenen Bau-Posten weiterhin als offen und "GO-pflichtig" vorfindet. Da der Bau-Trigger Mi 26.08. 06:00 ist, bleibt dies bis zur AUSTRAGUNG AN DER QUELLE ein reales Risiko — weder a-block-docs noch ein anderer gelesener Strang hat dies vollzogen.

**S-3 (FINDINGS#13 doppelt bearbeitet, A-8-Teilpunkt, P-13).** a-block-docs liefert fuer `registry_roundtrip.cmake`-Kopf nur einen ENTWURF-Text (Datei nicht editiert). Der Staffel-1-Strang `prtart-pin-duo` hat DENSELBEN Befund unabhaengig erhoben und TATSAECHLICH umgesetzt (Branch `bau/pinduo` @ `4941c41`, eigene Kopf-Formulierung "REFERENZ-KONFIGURATION (SEIT K7b-3/#104...)" + "HISTORIE"-Marker) und ist laut Task #107 die kuenftig fuehrende Fassung. Die beiden Formulierungen sind inhaltlich verwandt, aber NICHT wortgleich — beim Landen darf nur EINE (die von pinduo, da bereits gebaut+lokal gruen-geprueft: `ctest 224/224`) an das Objekt gehen; a-block-docs' ENTWURF sollte als redundant/verworfen behandelt werden, NICHT zusaetzlich eingebaut, sonst entsteht ein Doppel-Marker-Konflikt.

**S-4 (Ledger-ENTWUERFE noch nicht eingearbeitet, P-07/P-28).** Beide von a-block-docs an den Lead uebergebenen Ledger-ENTWUERFE (K7b-5-Superseded-Vermerk fuer KON74-04; F-A-KON119-Halbsatz) sind zum Zeitpunkt dieser Erhebung **objekt-verifiziert NICHT im Ledger vorhanden** (0 Treffer fuer die vorgeschlagenen Wortlaute "SUPERSEDED-VERMERK" nahe KON74-04 bzw. "F-A-KOMPLEX-FIX-NACHWEIS"). Das ist per Auftrags-Definition KEIN Fehler des a-block-docs-Strangs selbst (Ledger-Schreiben ist explizit Lead-only), aber ein offener Zustand, den das Audit nicht als "erledigt" werten sollte, bis der KON120-Ledger-Zug (Task #113, laufend) diese Haelften traegt. Gleiches gilt fuer den L2-Options-B-Entscheid (P-32): der Lead hat die ENTSCHEIDUNG bereits getroffen (LEAD-ENTSCHEIDE Nr. 20, 21.08.), aber die vorgeschlagene "Ledger-Zeile im naechsten KON-Zug" ist ebenfalls noch nicht sichtbar.

**S-5 (kleine Diff-Diskrepanz, P-07/P-09).** Der Ergebnis-Bericht (Abschn. 5, geschrieben VOR dem finalen Commit) kuendigt fuer den docs-super-Zug *"docs/plaene/...MEASURESTORAGE...[+11 Z.]"* und *"docs/sessions/...KONFORMITAETS-REGISTER...[+9 Z.]"* an. Der tatsaechliche Commit `a5dc8095` liefert **+16 / +9** Zeilen (`git show --stat`). Die KONFORMITAETS-Datei stimmt exakt; die MEASURESTORAGE-Datei traegt 5 Zeilen mehr als angekuendigt — inhaltlich deckt sich der committete Text mit der im Ergebnis Abschn. 2 zitierten Marker-Substanz (KON80-01/V3, KON87, Sheet-EBNF), die Differenz duerfte redaktionelle Ausformulierung beim tatsaechlichen Schreiben sein, keine neue Behauptung. Trotzdem: der Bericht selbst ist an dieser Stelle nicht mehr wortgenau der Beleg fuer das, was am Objekt liegt — das Audit sollte den COMMIT, nicht den Ergebnis-Text, als Quelle der Wahrheit fuer den docs-Teil nehmen (V1-Doktrin: Berichte sind Beweismaterial, kein Beweis).

**S-6 (Push-Stand, Kontext fuer alle A-8-Punkte).** `a5dc8095` ist Vorfahr von lokalem `development` (`git merge-base --is-ancestor` = rc 0), aber **NICHT** von `origin/development` (rc 1) — der Commit ist bewusst noch nicht gepusht (*"Push gebuendelt mit dem naechsten docs-Zug (R6/V5: keine CI waehrend die Staffel baut)"*, Commit-Trailer). Das ist eine deklarierte, keine verdeckte Abweichung — trotzdem sollte das Audit "committet" nicht mit "auf origin gesichert" verwechseln, falls eine BU-/Ref-Sicherungs-Pflicht (Memory: Fertige-Arbeit-Landen-Doktrin) hier separat greift.

**S-7 (A-14, P-26).** Die ABNAHME-Formel des Design-Textes verlangt nur *"df -h vor/nach dokumentiert"* — das ist erfuellt. Die zugrundeliegende Wellenplan-Quelle (§22.1 U-2, Z-14) verlangt aber eine tatsaechliche Betriebshandlung ("Platten-Raeumung prod1"), die laut Ergebnis bewusst dem Lead ueberlassen bleibt ("Loeschen = Lead"). Beide Lesarten sind mit ihren jeweiligen Quellen belegt; das Design (juenger/spezifischer fuer diesen Slot) gewinnt nach Owner-Regel, aber die Wellenplan-Frist ("MUSS vor Sa 22.") ist damit noch nicht materiell eingeloest, nur dokumentiert.
