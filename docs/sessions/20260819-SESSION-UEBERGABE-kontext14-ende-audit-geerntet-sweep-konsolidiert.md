# SESSION-UEBERGABE KONTEXT 14 ENDE (19.08.2026 mittags) -- AUDIT KOMPLETT GEERNTET (6/6b),
# SWEEP KONSOLIDIERT (Abschnitt 12), g2+v08r GEBAUT, FIX-STRECKE 2 STARTKLAR

> **Frist-Anker:** C-3a-Antwortfrist WAR HEUTE Mi 19.08. (Nachfrage `d8b27633`; ohne Antwort greift
> die DEKLARIERTE Fallregel 18.6(3): #38a2 -> W2-Bump-Buendel mit Freeze-Nachbuchung) ·
> **F2-Identitaets-Freeze Fr 21.08.** · Bau-Trigger Mi 26.08. 06:00 · Kampagne Sa 29.08. ·
> T-3 ~12.09. · Abgabe Di 15.09.
> **Vorgaenger:** K13-Uebergabe (5ca82678) + K14-Pause-Doku (a822c174/1589c5af, Abschnitte gelten
> fort, praezisiert durch DIESE Datei).

## 0. EINLESE-RITUAL KONTEXT 15 (Reihenfolge = Aufgaben-Relevanz!)

**Der fuer die geplanten Aufgaben RELEVANTESTE Ueberblick ist das REGRESSIONEN-REGISTER — es
traegt die komplette Fix-Strecke-2-Eingangsmenge und alle Traeger:**

1. **ZUERST: Regressionen-Register VOLL** (docs/sessions/20260818-SESSION-REGRESSIONEN-*.md,
   1115 Z., Abschnitte 0-12): Abschnitt 6 (Audit-Synthese F1-F9, 3 PUSH-SPERREN) + 6b (111
   Einzelverdikte; Kuerzung deklariert, Volltext = BU-Journal) + 11 (T-Posten) + 12 (80 Sweep-
   Regressionen, X-1..X-17-Strang-Tafel, 12.4-KONSEQUENZ = die Arbeitsliste).
2. **DIESE Uebergabe + Pause-Doku** (20260819-SESSION-PAUSE-k14-*.md, Resume-Rezepte).
3. **Wellenplan par.21** (ab Z.2876) + par.18.3-FREEZE-CHECK-LISTE AM ORIGINAL (Sweep-L1:
   der Analyse-Leser las nur Z.2738ff — Alt-Paragraphen 18.3/19.3 selbst nachlesen!).
4. **Task-Board** (99 Tasks; #15/#17/#95 in_progress mit reichen Metadata) + Wiederaufnahme-
   Register A-G + Ledger-Kopf-Gegenprobe (juengste KON; Stand hier: KON118, KON119 = reserviert
   fuer #15-Lande-Bericht).
5. Memory-Order „nach Compact neu gruenden" gilt: die 4 /goal-Dokumente wurden in K14 KOMPLETT
   gekippt (GOAL 816 · Wellenplan 3156 · Designplan 703 · ARBEITSWEISE 1264) — fuer K15 genuegt
   das par.21-/18.3-Nachlesen + diese Kette, SOFERN K15 direkt weiterarbeitet; bei laengerer
   Pause voll kippen.

## 1. WAS K14 GELIEFERT HAT (alles dual gepusht mit Koeder-Gates, ausser BU-Ordner)

| Ergebnis | Beleg |
|---|---|
| **Neugruendung K14 komplett**: Kippen 4/4 + ultracode-5-Kontexte-Karte (69 Belange/23 Luecken/13 Abweichungen/5 Zuege) | wf_6c904e28 |
| **OWNER-AUDIT KOMPLETT**: 65/65, 688/688, 0 unverifiziert — 502 ERFUELLT/74 UEBERHOLT/89 ABW./22 FEHLT (roh); **LANDBAR_MIT_FIXES F1-F9**, PUSH-SPERREN F1 (V-01R BAUEN — Owner 'definitiv mit drehen'; die K13-NEIN-Probe las die doppelt ueberholte KON5-04-Fehl-Deckung), F2 (clang-debug Basis-Probe @ 20c111c4 + Volllauf am Tip; ENABLE_EXPORTS 0d0ad521-Verdacht), F3 (Endstand decken: Tip e285d316 = 30 Commits, Uebergaben 25/32 falsch) | Register 6 @ afc237d7 |
| **6b-Detail-Tafel**: ALLE 111 Einzelverdikte je ID+Schwere+Beleg (Kuerzung ~230 Z. DEKLARIERT; Volltext = BU-Journal) | f27e7f7c |
| **K13-Transkript-Vollnachvollzug** (Register 11): T-2 Positions-Beweise + T-10 (per Sweep praezisiert: nur BAU-Haelfte offen) + Fallen T-5/T-6 + 4 Aufklaerungen | 7b20f58e |
| **REGRESSION-SWEEP K5-K13** (Register 12, 38 KB): 10/10 Fenster + 3/3 Journal-Gruppen; 103->80 neue Regressionen; **33 Straenge: 16 GEERNTET/17 REKONSTRUIERBAR/0 VERLOREN** (X-1..X-17 mit Rezepten); Register-Korrekturen (T-10-Ernte existiert: wf_969b3bba->KON103-03; 6b-Trunkierung; B3-ANKER = mess_achsen_naht.hpp:477-517, NICHT abi_adapter!) | fef04f57 |
| **12.4-SOFORT-Block VOLLZOGEN**: X-16 Audit-Endstand + X-2 k2-Outputs + K12-10 70 Patches -> ~/backups-workflow/2026081 9-*; X-10/X-8 Einzelkopie-Branches DUAL gesichert (bau/g2-semantik + bau/v08r-fingerprint-sha auf origin+github) | ls-remote literal |
| **#17/g2 LANDEREIF**: 4-Zellen-Kombibau 4x500/500 (volle J-Treppe), keine neuen Commits noetig; Fix-R1 1 Fund BEHOBEN; **ACHTUNG: Worktree-Tip inzwischen cb856212 (ahead=3)** — der Verify-R2 arbeitete weiter; Endtip bei Workflow-Rueckkehr NEU messen+nachsichern | Task-#17-Metadata; Logs ~/backups-workflow/20260819-g2-abnahme-logs/ |
| **#95/V-08R GEBAUT**: wt-ce-v08r @ 0f0742aa (Vertragsbein 64-hex je Traeger + CT-SHA-256-Fuellung + Kompositum 6->8 + A2.5-R1); Verify-Rest = Lande-Stufe; Form-Frage = F2-Vorlage P5 | Task-#95-Metadata |
| **F3-Hygiene-Haelfte VORAB GRUEN** (e114cabd..e285d316, 30 Commits, rc=0) | BU: f3-hygiene-*.log |
| **Owner-Kanal**: C-3a-Nachfrage (Frist heute!) + Infra-Termin-Frage + OV-5b/OV-4 + **E12-Thesis-Meldung** (Commit 09cc728 traegt KI-Trailer auf ALLEN Refs — Owner-gated a Rewrite/b Ausnahme) | d8b27633 + f27e7f7c, Pipelines gruen |
| Wiederaufnahme-Register G (23 Luecken mit Traeger) + V-13-UEBERHOLT-Marker + Task-Pflege #17/#22/#95 | 022271ac |
| **K14-BU-ORDNER** docs/sessions/backups/20260819-kontext14-workflows/ (17 Dateien, 1,6MB inkl. Audit-Journal-ENDSTAND) — **UNCOMMITTED** (Owner-Order: EINE Redaktion NACH allen Rueckkehrern, dann Push) | lokal |

## 2. 🔴 NEUE PRUEF-PFLICHT (Owner 19.08. mittags): UNGELANDETER WORKTREE-FORTSCHRITT

**Objekt-Messung 19.08. ~12:10 (rev-list 20c111c4..HEAD + porcelain je Baum):**

    SERIELLE LANDE-LISTE (Reihenfolge fixiert, nach Fix-Strecke 2 + #93):
    L1  wt-ce-bump15   bau/bump15-preimage-bruch  e285d316  ahead=30  dirty=1 (.review-tmp,
        vor Landung loeschen) — LANDBAR_MIT_FIXES; Lande-Kette par.21.1 + F9-Gates
    L2  wt-ce-g2       bau/g2-semantik            cb856212! ahead=3   dirty=0 — LANDEREIF;
        Tip LEBT (Workflow arbeitet): Endtip messen, origin-Nachsicherung (dort noch 9aa9b9df),
        Harmonisierung: CMakeLists-Tail + algo_semver Term (e) bricht #15-Literale compile-time
        + 5 Text-Flaechen + Floor-Nachzug
    L3  wt-ce-v08r     bau/v08r-fingerprint-sha   0f0742aa  ahead=3   dirty=0 — gebaut;
        finaler Verify + Vollbau in der Lande-Stufe; --dump-plan-Byte-Ereignis deklarieren
    L4  DANACH super-Zug ATOMAR/KON119 (XSD-Patch [BU], Gitlink, PZW live, seg1-04-Annotationen,
        a11_super_patch NUR nach D-9-Abgleich/L9, KON119 mit bump15-a/b/c/d + literalem Endstand)

    NICHT landen (geprueft):
    - golden-rettung @ fbe898be ahead=0 -> X-1-AUSBUCHUNG (Substanz in dev; D12-Muster mit
      Owner-GO fuer Remote-Ref bau/golden-homes @ 5fa37f36 + rescue-Ref; rote 15895 ausbuchen)
    - hy-a/vl12/vl3/xorf/f3v/a11 ahead=0 dirty=0 -> Aufraeum-Block (Liste-C-Doktrin,
      gruen+gemergt+gepusht+Submodul-Check+nested-Wache)
    - k2 ahead=0 **dirty=1** -> VOR Aufraeumen den 1 Eintrag ansehen (vermutlich untracked
      Artefakt; nie blind loeschen)
    - wt-thesis-lizenz @ development dirty=0 -> Aufraeum-Kandidat
    - NESTED wf_e22d25ef-71c-7 @ 7f3901fb **dirty=17** (D2-Strang 10.08., X-11): Diff-BU
      sichern -> dev-Enthaltensein pruefen (#62-Muster) -> Ausbuchung MIT Beleg ODER
      D2c-Wiederaufnahme; + 3 nested wf_5834b706-Baeume (p2/p3/p6, dirty=0) im selben Zug

## 3. LAUFENDE PROZESSE BEI KONTEXT-ENDE

- **g2-Verify** wf_5dd12e19-e73 (Task wt0a9rbks): LEBT (6 results, 12:08; Tip cb856212).
  Bei Rueckkehr: VOLLSTAENDIG lesen + Output/Journal-Endstand in den BU-Ordner + neuen Tip
  dual nachsichern. Stirbt er: Resume scriptPath g2-fertigstellung-slot1-wf_5dd12e19-e73.js
  + resumeFromRunId wf_5dd12e19-e73 — ODER Verify-Rest der Lande-Stufe ueberlassen.
- Sonst: KEINE laufenden Workflows (Audit/Sweep/v08r/Neugruendung/Redaktion-K13 komplett).

## 4. DIE KETTE (fixiert; nichts bleibt liegen) — REIHENFOLGE K15

1. **g2-Rueckkehr ernten** (Abschnitt 3) -> BU-Ordner FINAL (18+ Dateien).
2. **EINE REDAKTION** ueber den VOLLSTAENDIGEN BU-Ordner (Script-Vorlage:
   workflows/scripts/bu-redaktion-kontext14-wf_e8c90d63-0f8.js — Dateiliste um Nachzuegler
   erweitern, K13-Muster: 2 Pruefer + Redakteur, thinking-signature-Klasse, glpat-Prosa-Regel).
3. Nach **FREIGEGEBEN**: BU-Ordner committen + dual pushen (Koeder-Gate 26+Echt-Scan).
4. **FIX-STRECKE 2** (A2.5, Fable max, Bau-Slot 3, wt-ce-bump15 = EIN Schreiber). EINGANGSMENGE
   (Register 12.4 'Fix-Strecke 2 erhaelt ZUSAETZLICH' + Abschnitt 6 KONSEQUENZ):
   **F1** V-01R AxisKind-Dreh + CT-Zuordnung BAUEN (KON101-gedeckt; topics/axis.hpp) ·
   **F2** clang-debug Basis-Probe @ 20c111c4 (Altbestand vs. 0d0ad521-Regression) + Volllauf
   am Tip (Rezept: ~/backups-workflow/20260819-g2-abnahme-logs/ct_g2rest_clang_debug.log;
   Kombibau-Regel 'all'+comdare_tests!) · **F3-Rest** ctest-Volllauf @ e285d316 + Uebergabe-
   Zahlen 25/32->30 als Nachtrag · **F4** je C-3a-Stand (ohne Antwort: 18.6(3)-Fall deklariert
   fahren) · **F5** NP-23/24-POD-Wirksamkeit klaeren · **F6** golden-Ereignis-Zug terminieren
   (B-9 build_version-wirksam! + CRC-Re-Anker B-10.3 + Bissprobe B-11.2 + A-11-Task mit
   T-1-Abnahme) · **F7** Root-Duplikat system_axis_registry.xml · **F8** E-6-Doku 0/3 +
   klassifikation.hpp:28 · **F9** Lande-Rezept exakt + Pre-Push-Script-Mechanisierung (K3/H6)
   + **T-2** Positions-Beweise :609-627 frisch messen + **T-10-BAU-Haelfte** (SHA256-
   Verkettung; Ernte liegt: ~/backups-workflow/20260817-v02r-hybrid-grammatik/) + **L21**
   F-9-Sentinel/TSan-Triage + **6b-Reparatur/X-17** (23er-Matrix aus BU-Journal als 6c) +
   **B3-ANKER-ABGLEICH** (mess_achsen_naht:477-517 vs abi_adapter) VOR #93-D + prt-art-SHA-
   Pin-Task ([K7b-3]) + tools-3-Format-Traeger + M-5/W2-1-Anker. Rekursion bis NULL_NEUE_FUNDE.
5. **#93 W1-AUDIT** (Script w1-vollstaendigkeit-wf.js; konkretisierte Posten je Gruppe aus
   12.4: A=vl3-ROT-3/_pclose/N1-N5-N6/Wstringop · C=HY-A-R2-Lens/rcu-Serien/V-02R-Bau ·
   D=B3 am RICHTIGEN Anker · Straenge=k2-G3/G4) -> Register Abschnitt 9.
6. **SERIELLE LANDUNGEN** L1->L4 (Abschnitt 2) + Task #15 completed NUR wenn golden-
   Nachposten-Zusage aufgeloest (F6/E7!).
7. **F2-VORLAGEN-FENSTER** P1-P6 (P1 entfaellt wenn F1 gebaut; P4=C-3a; P5=V-08R-Form 64-vs-
   128; P6 seg1-44/golden + Kategorie-C-Saetze) + **FREEZE-CHECK Fr 21.08.** (par.18.3 AM
   ORIGINAL + #93-Ist; Fallregel-Buchungen deklarieren).
8. **WE-POSTEN** Sa/So 22./23.: S-19 (#7, Trigger-Zahl!) + T-15b (#13) + I-PMC (#82) +
   Band-B-Slots; Infra-Fenster je Owner-Antwort (Empfehlung war Do abends).
9. **Di-25.-SCHNITT** (#96): JEDEN Register-Posten namentlich; ZUGAENGE aus 12.4: B-8-Task
   (X-13) · VL-6b-Parser (X-15, mit K6-6 in S-13/#18) · Methodik-Override (K12-2, S-8/#22) ·
   Peer-Sessions e1-e4-Triage (X-14) · golden-Refs (X-1) · nested Worktrees (X-11) ·
   #3+#19 zwingend zaehlen (L19) · s13-design Z.1384 J-1-Rezept-Fix (🔴 VOR dem Schnitt!).
10. **Docs-/Memory-Zug** (buendelbar): 13 Fallen-Klassen 12.2c + T-5/T-6 ins Fallen-Register ·
    KON74-04-/KON99-03-/Folge-BU-Spiegel-/hy-a-Lens-Quittungs-Nachtraege · #85-Text-Delta (X-3)
    · Ledger:4501-Mikro-Korrektur · seg3-kon28-01-Marker · Pre-Push-Script.

## 5. OFFENE OWNER-PUNKTE (Stand Kontext-Ende)

- **C-3a**: Frist war HEUTE — ohne Antwort faehrt die Fix-Strecke den 18.6(3)-Fall DEKLARIERT.
- **Infra-Wartungsfenster-TERMIN** (Rotation 286/288/289 + D-3 VOR Mi 26.08.; WE ueberbucht).
- **E12-Thesis**: a) gezielter Rewrite 09cc728 (braucht gegenstands-genaues GO) / b) Ledger-
  Ausnahme. Lokale Thesis-Klone stale — Nachzug nach Entscheid.
- Kenntnisnahmen: OV-5b prod2-online · OV-4-Fakt · T-3-Meldung (axis_cross_product).

## 6. WAS DIESER KONTEXT SONST BERUEHRT HAT (Vollstaendigkeit; je mit Traeger)

Einlese-Ritual K14 vollzogen (4 Dokumente komplett + Ledger-Kopf KON118 + Board) · C-3a/
d8b27633 + Register-Commits afc237d7/f27e7f7c/7b20f58e/022271ac/fef04f57 + Pausen a822c174/
1589c5af (alle Pipelines gruen) · 3 Limit-Tode 05:13 (Audit/g2/v08r) ALLE resumed+komplett ·
Redaktion-K14 wf_e8c90d63 verfrueht gestartet + gestoppt (Owner-Reihenfolge-Korrektur:
Redaktion NACH allen Rueckkehrern) · Kontrollierte Stopps bei Limit-97% + Resumes danach ·
bump15-b-Probe-TUs + g2-Abnahme-Logs + k2-Outputs + 70 Patches + Audit-Endstand persistent
gesichert (B.3) · V-13-stale-Stellung · Task-Metadata #15/#17/#22/#95 reich · Slot-Protokoll
bauslots/ (aktuell leer) · Platte ~95%/13G (df-Gate vor jedem Vollbau!) · build-g2 7,1G
BEHALTEN (Lande-Verifikation) · Sweep-Chronologie 12.2d (Limit-Risse 16.-18.08. dokumentiert).

## 7. SICHERHEITSAUFLAGEN (verbatim-Kern, unveraendert fortgeltend)

Vault NIE greppen (blind mapfile) · Transkripte/agent-*.jsonl NIE committen (BU-Journale sind
Agent-RESULT-Journale und durchlaufen die Redaktion VOR Push) · nie rebase, immer merge ·
main-FF nur volle SHA · gitleaks glpat-+20 Laengen-Assert 26 + Echt-Scan je Push; Koeder-
Literale in Commit-Texten maskieren; lokales gitleaks · AskUserQuestion NIE · Doku nie
loeschen · CI nie canceln · kein add -A · Messdaten nie loeschen · Drei-Bauten-Deckel +
df-Gate · EIN Schreiber je Worktree (bump15=Fix-Strecke2; g2 GEHOERT dem laufenden Workflow
bis Rueckkehr!) · PAT-Header jobs-tmp/glhdr.curlrc via curl -sk -K · NIE SendMessage an
wartende Workflow-Container · Thesis-Commits OHNE KI-Trailer · Worktree-Loeschung erst
gruen+gemergt+gepusht+Submodul+nested-Check · 286er-Mess-Pipeline NIE pollen ·
clang-format-22 (CI entscheidet, M-7-Drift offen) · ctest kuenftig --no-tests=error ·
Kombibau 'all'+comdare_tests · NUR-FABLE-5-MAX bis Widerruf · 🔴 NIE kuerzen/ausbuchen/
verschieben (Dauerregel 18.08.).

## 8. HANDREICHUNG (ADDITIV, Owner-Order 19.08. spaet): VERHALTENSMUSTER + PUSH-SEQUENZ
## JE SCHRITT DES RUECKWEGS — vom heissen Pfad (g2-Rueckkehr) ueber 9 Schritte zum Hauptstrang

### 8.0 DIE STANDARD-PUSH-SEQUENZ (in K14 zehnfach gefahren; gilt fuer JEDEN super-docs-Push)

    (1) git -C <repo> add <EXPLIZITE PFADE>            # NIE add -A
    (2) git commit -m "<typ>(<scope>): <was> -- <kern>" # + Leerzeile + Co-Authored-By:
        Claude Fable 5 <noreply@anthropic.com>          # AUSSER Thesis-Repo: OHNE Trailer!
    (3) KOEDER-GATE:  K=$(head -c 40 /dev/urandom | base64 | tr -dc 'A-Za-z0-9' | head -c 20)
        KOEDER="glpat-$K"; [ ${#KOEDER} -eq 26 ] || ABBRUCH   # Laengen-Assert PFLICHT
        printf 'x %s x\n' "$KOEDER" > $TMPD/kp.txt
        gitleaks stdin --config <repo>/.gitleaks.toml --no-banner < $TMPD/kp.txt; BISS=$?
        [ $BISS -eq 1 ] || ABBRUCH (Wache beisst nicht!)   # rm kp.txt danach
    (4) ECHT-SCAN:    git log -p origin/development..HEAD > $TMPD/pi.txt
        gitleaks stdin --config ... < $TMPD/pi.txt; ECHT=$?
        [ $ECHT -eq 0 ] || STOPP (Fund! NIE pushen)        # rm pi.txt danach
    (5) push origin development && push github development  # BEIDE rc pruefen
    (6) PIPELINE-GRUEN per API: curl -sk -K $TMPD/glhdr.curlrc
        .../projects/288/pipelines?sha=<VOLLE-SHA>  -> status==success
        ("KEINE" beim Erst-Poll = Pipeline noch nicht angelegt -> 20-30s Retry, NIE als
        kein-Pipeline-Verhalten fehldeuten; Praezedenz d8b27633)
    ce-Pushes (Landungen): identisch, aber projects/286 + die F9-Wellen-Ende-Gates VOR (5).

### 8.1 SCHRITT 1 — g2-RUECKKEHR (der heisse Pfad; Verhaltensmuster bei Task-Notification)

    (a) Output VOLL lesen: Notification-Result ist oft TRUNKIERT -> python3 auf
        /tmp/claude-1001/.../tasks/<taskid>.output (json.loads ab erstem '{'), ALLE Felder
        inkl. Rest ab Trunkierungs-Grenze; bei Unklarheit journal.jsonl (= Wahrheit).
    (b) BU-NACHZUG: Output -> BU-Ordner als g2-endergebnis-<taskid>.json; Journal-ENDSTAND
        kopieren, TEILSTAND-gestoppt-Kopie ERSETZEN (rm der alten, Namens-Klarheit).
    (c) TIP MESSEN + NACHSICHERN: git -C /home/comdare/wt-ce-g2 log --oneline -3 + status
        --porcelain; neuen Tip (Stand K14-Ende: cb856212, kann weiter gewachsen sein) DUAL
        sichern: push origin bau/g2-semantik && push github bau/g2-semantik (Ref-Sicherung,
        KEIN Landen). ls-remote-Gegenprobe.
    (d) Task-#17-Metadata um Endstand ergaenzen (Verify-Urteil, letzte Funde/Quittungen).
    (e) FALLS der Workflow stattdessen STIRBT (Limit/Abriss): Journal-Stand sichern, Resume
        per scriptPath+resumeFromRunId NUR wenn Verify-Urteil noch fehlt; die SUBSTANZ ist
        committet — im Zweifel Verify-Rest der Lande-Stufe zuschlagen und weitergehen.

### 8.2 SCHRITT 2 — EINE REDAKTION (Muster K13/wf_a9be8ee1; Script-Vorlage liegt)

    Script workflows/scripts/bu-redaktion-kontext14-wf_e8c90d63-0f8.js EDITIEREN:
    G1/G2-Dateilisten um ALLE Nachzuegler erweitern (g2-endergebnis + g2-journal-ENDSTAND +
    sweep-ergebnis + sweep-journal-ENDSTAND — Ist-Stand des Ordners per ls erheben, Soll =
    JEDE Datei); dann Workflow NEU starten (kein resume — Prompts aendern sich).
    Regeln im Script: je Datei gitleaks stdin --config + Muster-Sweep (glpat-LITERAL vs
    Prosa-Erwaehnung!, PRIVATE KEY, sk-ant-, ghp_, AKIA, glrt-, Bearer, user:pass@,
    Base64>=60 [Hex-Digests/CRC = KEIN Fund]) + Journal-Feldscan (key=v2:<64hex> = Cache-
    Hash, usage-Zaehler = KEIN Fund) + thinking-signature-Klasse -> [REDACTED-thinking-
    signature] byte-genau, JSONL-Validitaet danach pruefen. Redakteur: Gesamt-Gegenprobe
    ueber ALLE Dateien + EIN beissender Wegwerf-Koeder (rc=1) + REDAKTIONS-NOTIZ.md +
    Urteil. K13-REGEL: die Freigabe deckt NUR den Schnappschuss — waechst der Ordner
    danach, braucht der Zuwachs eigene Pruefung.

### 8.3 SCHRITT 3 — BU-PUSH (nach FREIGEGEBEN)

    Standard-Push-Sequenz 8.0 mit: add docs/sessions/backups/20260819-kontext14-workflows/
    (ganzer Ordner inkl. REDAKTIONS-NOTIZ.md). Bei GESPERRT: gesperrte Dateien nachredigieren
    (Redakteurs-Liste), DANN committen. Faellt der Workflow: manuelle Redaktion je Datei
    (gitleaks + Muster-Sweep), NIE ungeprueft pushen. Commit-Text: Koeder-Klassen-Woerter
    maskieren (Regel: Koeder-Literale auch in Commit-Texten maskieren).

### 8.4 SCHRITT 4 — FIX-STRECKE 2 (A2.5; Script NEU schreiben nach Muster bump15-a25-*.js)

    RAHMEN: EIN Workflow, Fable max, Bau-Slot 3 (bauslots/slot3-fixstrecke2 setzen; df-Gate:
    unter 5G NICHT bauen; Platte war 13G/95%), Worktree wt-ce-bump15 = EIN Schreiber (der
    Workflow; Lead fasst den Baum NICHT an). PHASEN: Triage (Eingangsmenge Uebergabe 4.4
    dedupliziert GEGENGEZAEHLT; KRITISCH/ERNST-Volltexte aus BU-Journal audit-wf794b904b-
    journal-ENDSTAND.jsonl lesen, NIE nur 6b) -> Fix-Gruppen sequentiell (T-1 ROT ZUERST je
    Fund, kleine Commits mit expliziten Pfaden, 'fix(a25-f2): <fund> -- <kern>') -> je
    Gruppe inkrementell bauen + gezielte ctests -> Abnahme (Kombibau-Zellen NUR wo beruehrt;
    Regel 'all'+comdare_tests, ctest --no-tests=error) -> VERIFY adversarial -> FIX-Rekursion
    bis NULL_NEUE_FUNDE. QUITTUNG dreiwertig JE Fund (BEHOBEN+Beleg / ENTLASTET+Messung /
    VERTAGT+Grund+Platz+Task). SONDERFAELLE: F2-Basis-Probe = EIGENES Build-Verzeichnis am
    ce-Hauptklon @ 20c111c4 (NICHT im bump15-Baum; Rezept aus ct_g2rest_clang_debug.log-Kopf)
    · F4 ohne C-3a-Antwort = 18.6(3)-Fall DEKLARIERT fahren (Freeze-Nachbuchung notieren,
    KON119-Ausweis vormerken) · F6 golden-Zug als EIGENES golden-Ereignis IM Bruch
    terminieren (EIN Re-Anker; neuer TABU-CRC wird bei der Landungs-Meldung literal
    vorgelegt) · X-17: 23er-Matrix aus BU-Journal Z.144 als Register-6c publizieren.
    ERGEBNIS-Sicherung SOFORT nach Rueckkehr (Output+Journal -> backups-workflow + BU).

### 8.5 SCHRITT 5 — #93 W1-AUDIT

    Script workflows/scripts/w1-vollstaendigkeit-wf.js VOR Start pruefen/anpassen:
    (a) Gruppe E/#17: g2 = LANDEREIF @ <End-Tip> eintragen (nicht mehr 'ungelandet+unfertig');
    (b) Gruppe D/B3: BEIDE Anker messen (mess_achsen_naht.hpp:477-517 PRIMAER, abi_adapter
    :476-491 GEGENPROBE — 12.1-Diskrepanz!); (c) Gruppe A um vl3-ROT-3/_pclose/N1-N5-N6/
    Wstringop, Gruppe C um HY-A-R2-Lens/rcu-Serien/V-02R-Bau, Straenge um k2-G3/G4 ergaenzen
    (12.4-Zugaenge). Ergebnis -> Register Abschnitt 9 + Frist-Dreiteilung; Vor-F2-Posten
    SOFORT ziehen (ggf. in die noch offene Fix-Rekursion einspeisen).

### 8.6 SCHRITT 6 — SERIELLE LANDUNGEN L1-L4 (die PUSH-SEQUENZ der Landungen)

    L1 #15 (ce):
      (1) rm -rf wt-ce-bump15/.review-tmp (dirty=1-Eintrag; vorher reinschauen)
      (2) Im ce-HAUPTKLON: git checkout development (MUSS auf 20c111c4+x stehen; fetch
          vorher) -> git merge --no-ff bau/bump15-preimage-bruch  # EIN Merge, 30+ Commits
      (3) WELLEN-ENDE-GATES AM ENDSTAND (F9, Reihenfolge):
          Lock-REGEN --check (Exit 1 mit 4 versionslosen Traegern ERWARTET) -> Erst-Versionen
          je Traeger vergeben (anatomy_base/observable_tier/pruefling_merge/
          target_isa_complex_axis; inhaltliche Entscheidung, bump15-d-Hinweis) -> --write-
          Regen als EIGENER Commit · kumulative Diff-Hygiene e114cabd..HEAD (Vorab-Lauf war
          GRUEN bis e285d316; nach Merge+Regen NEU fahren) · clang-format MIT DER CI-FORMEL
          (Job-Variablen einsetzen; M-7: CI entscheidet) · Koeder-Gate + Echt-Scan (8.0/3-4,
          Bereich origin/development..HEAD) · Floor GEMESSEN (PRUEFLING-Form! Schalter-
          Zustand literal ins Protokoll) · Vollbau all + --target comdare_tests + voller
          ctest · B-10-Anker-Faelligkeit pruefen (kFrozenFingerprintV1, test_d4:194,
          e24-/w10-Pins) · Beweisorte auf gesicherte Logs zeigen lassen (E3!)
      (4) EIN PUSH dual -> EINE CI (API projects/286, volle SHA, JOBLISTE lesen nie nur
          Gesamtstatus) -> Task-Notification abwarten, NICHT pollen waehrend Mess-Jobs.
    L2 g2: merge --no-ff bau/g2-semantik NACH L1-Gruen. HARMONISIERUNG (A2.1b): CMakeLists-
      Tail-Append pruefen · algo_semver Term (e) bricht #15-Literale der Form
      x.y.z.<flag-doppelt> COMPILE-TIME -> Kombibau des ZUSAMMENGESETZTEN Stands ist der
      Beweis · 5 Text-Meldungsflaechen · Floor-Nachzug (g2 hatte N=500-Basis, der
      Gesamtstand zaehlt NEU). Gates verkuerzt (Hygiene ueber den g2-Bereich, Format,
      Koeder, Floor) -> Push dual -> CI.
    L3 v08r: merge --no-ff bau/v08r-fingerprint-sha NACH L2. Vorher: finaler Verify
      (NULL_NEUE_FUNDE-Rest) + --dump-plan-Byte-Ereignis (' sha256='-Schlussfeld) als
      DEKLARIERTES Ereignis in der Merge-Botschaft. Gates -> Push -> CI.
    L4 super-Zug ATOMAR (EIN Lande-Ereignis, EIN Push):
      a11_super_patch.diff NUR nach D-9-Abgleich (L9: was drpppte die gelandete ce-Haelfte?)
      · XSD-Patch super_xsd_golden_verbund.patch (BU; Subset-Wache koppelt Fixture+XSD =>
      MUSS mit Gitlink in EINEM Commit) · Gitlink -> ce-Merge-SHA · PZW-Anker LIVE neu
      zaehlen (neue Test-.cpp: test_hy_f8_reroute, test_q2_identitaets_riegel, g2-/v08r-
      Tests — ZAEHLEN, nie raten) · seg1-04: 6 stale E-6-Stellen im Hybrid-Bauplan datiert
      ANNOTIEREN · KON119 per scripts/ledger_nachtrag.sh (bump15-a/b/c/d-Namensnennung +
      K16-Vorfallskern + A2.5-Bilanz + TABU-CRC literal + Audit-/Review-Verdikte + F4-/
      18.6(3)-Ausweis + literaler Endstand rev-list --count) · Standard-Push-Sequenz 8.0
      -> super-CI + PZW-Job gruen -> DANN Task #15 completed (NUR wenn golden-Zusage per
      F6 aufgeloest — sonst bleibt #15 in_progress mit benanntem Rest!).

### 8.7 SCHRITTE 7-10 — F2-FENSTER, WE, DI-25, DOCS (Kurz-Handreichung)

    S7 F2-VORLAGEN: EIN Dokument docs/sessions/ (A2.3a-NEIN-Probe je Punkt VOR Versand!);
       P5 V-08R-Form traegt die GEMESSENE Kollision (64-hex gebaut, drehbar); Freeze-Check
       Fr = par.18.3-Liste AM ORIGINAL + #93-Ist, jede Fallregel-Buchung DEKLARIERT.
    S8 WE: S-19 zuerst (produziert die B-4-Zahl = Trigger-Nenner), dann T-15b + I-PMC;
       Bau-Slots beachten; Infra-Fenster je Owner-Antwort.
    S9 DI-25-SCHNITT: Wiederaufnahme-Register A-G + 12.4-Zugaenge + L19 (#3/#19) JE Posten
       namentlich mit Stunden-Slot; VORHER 🔴 s13-design Z.1384 J-1-Rezept-Fix (Ein-Zeiler
       oder JOIN-CHECKLISTE-Verweis; erst pruefen ob der s13-Strang die Datei noch haelt).
    S10 DOCS-/MEMORY-ZUG: 13 Fallen-Klassen 12.2c + T-5/T-6 als Fallen-Register-Memory;
       Quittungs-Nachtraege (KON74-04, KON99-03, JB-2/JB-3, X-3, Ledger:4501,
       seg3-kon28-01); Pre-Push-Script scripts/ (K3/H6: Lande-Gate-Kette mechanisieren,
       Muster ledger_nachtrag.sh — 'Werkzeug schlaegt Disziplin').

### 8.8 QUERSCHNITTS-VERHALTENSMUSTER (in K14 bewaehrt; bei JEDEM Schritt)

    LIMIT-NAEHE (>90%): NICHT weiterlaufen lassen — TaskStop KONTROLLIERT je Workflow,
      Journal-Teilstaende in den BU sichern, Pause-Nachtrag in die lebende Pause-/Uebergabe-
      Doku, Standard-Push. Resume spaeter per scriptPath+resumeFromRunId (Cache traegt
      Fertiges; bei geaenderten Prompts NEU starten).
    LEBENDPROBE: journal.jsonl-Wachstum + results-Zaehler, NIE pgrep; agent-*.jsonl-mtime
      als Zweitprobe.
    RUECKKEHRER: Output IMMER voll lesen (Trunkierung!), SOFORT sichern (B.3: /tmp rotiert),
      dreiwertig verbuchen, Task-Metadata nachziehen.
    EIN SCHREIBER: bump15=Fix-Strecke-2-Workflow · g2=sein Workflow bis Rueckkehr · super-
      docs=Lead · NIE in fremden Baeumen committen; Merges macht der Lead im ce-HAUPTKLON.
    FEHLER AUF DEM RUECKWEG: Pipeline rot -> Befund VOR Fix benennen (Job, Paket, Datei);
      Heilung im QUELL-Worktree, neuer Merge — nie direkt auf development flicken.
