# LANDE-AUFLAGEN + LEAD-ENTWUERFE -- Aufgabe "ablock", A2.5-Fix-Runde 1 (22.08.2026)

Schreiber: Fable-max-FIX-STUFE ablock (Doku-Strang, KEIN Worktree, KEIN Bau-Slot).
Regel-Rahmen: Ledger/Board/Memory = Lead-only -- dieses Dokument traegt die WORTFERTIGEN
ENTWUERFE + Kontroll-Rohdaten, damit der jeweilige Traeger-Zug ohne Neuerhebung vollziehen kann.
ALLE Zeilennummern = Ledger-Stand 22.08. NACH KON120 (super-HEAD 657003bb, Ledger 32272 Z.);
bei weiterem Drift gelten die mitgegebenen WORTLAUT-ANKER, nie die Nummern allein.
ASCII-only. Owner-Doktrin: Marker AM ORT, Zeile bleibt, NIE loeschen.

--------------------------------------------------------------------------------
## 1. AB-02 (ERNST, ZEITKRITISCH) -- W18: [Par.59-MERGE-STEMPEL] AUSTRAGEN
**Traeger: Lead-Ledger-Zug (KON121 bzw. naechster docs-Zug nach #113), HART VOR Mi 26.08. 06:00 (Bau-Trigger).**

IST (22.08., selbst gemessen): Ledger:23235 lebt UNMARKIERT -- Anker-Wortlaut:
`- **[Par.59-MERGE-STEMPEL]** K7a Merge-Stempel-POD (dritter Tier-Binary-Stempel = Merge-Kombination; POD 56 -> 72, layout 2 -> 3, binary_id/CRC unberuehrt); koppelt an Par.58-STEMPEL (Array-Form). (OFFEN, hoch -- golden-Fenster, GO-pflichtig ABI-nah.)`
Cross-Referenz Ledger:23021 fuehrt `Par.59-Folge-TODOs: ... Par.59-MERGE-STEMPEL ...` weiter als offen.
Die UEBERHOLT-Wahrheit liegt nur FERN der Quelle: :5146-5156 (13.08.-Marker (b): `UEBERHOLT:
Owner-E2 02.08. ("Merge Zeile kann daher nicht existieren") hat gewonnen; DV-1 entfernte den
merge-Stempel-CODE in A13-M3 ERSATZLOS; die Merge-DURCHFUEHRUNG (merge_plan.hpp) blieb`) und
:23762 (DV-1-Default-Zeile). KON120 (657003bb) deckt W18 NICHT (Commit-Gegenstand: Owner-Tranchen/
Resume/V8-prod1-PAT/A3-Handout/4 Tafel-Korrekturen; grep-Gegenprobe: kein Marker an :23235).

ENTWURF (a) -- datierter Marker DIREKT UNTER die :23235-Zeile einfuegen (Zeile selbst bleibt):
```
  > **[AUSGETRAGEN 22.08.2026, W2-docs-Zug A-8/W18 per Wellenplan 19.6]:** Dieser Bau-Posten
  > ist owner-verboten und wird NICHT gebaut. Owner-E2 02.08.: "Merge Zeile kann daher nicht
  > existieren" (Marker-Fenster :5146-5156); DV-1 entfernte den merge-Stempel-CODE in A13-M3
  > ERSATZLOS (Objekt-Belege 13.08.: adhoc_emitter.hpp:110, anatomy_version_stamp.hpp:392,
  > merge_plan.hpp Kopf -- die Merge-DURCHFUEHRUNG merge_plan.hpp blieb). Die Zeile bleibt als
  > Historie stehen; sie ist KEIN offener Bau-Posten und loest KEINEN Trigger-Bau am 26.08. aus.
```
ENTWURF (b) -- an der Folge-TODO-Nennung :23021 (Anker: `Par.59-Folge-TODOs:`) direkt anfuegen:
```
  > **[NACHTRAG 22.08.2026]:** "Par.59-MERGE-STEMPEL" ist aus dieser Folge-TODO-Liste AUSGETRAGEN
  > (Owner-E2 02.08. + DV-1, s. Marker an der [Par.59-MERGE-STEMPEL]-Zeile); die uebrigen
  > Par.59-Folge-TODOs bleiben unberuehrt.
```

--------------------------------------------------------------------------------
## 2. AB-03 (ERNST) -- A-4/T-18: Z-6-Task-Anlage + Z-7/Z-9-Text-Updates (Board = Lead)

T-18-KONTROLLE (der fehlende Liefergegenstand) -- HIER GELIEFERT, 22.08. selbst gemessen:
- Par.22 COMMITTET: Wellenplan-Commit 6104e897 existiert (vom Audit per git log verifiziert;
  22.4-Z-Liste heute wortlautgleich am Objekt Wellenplan :3408-3438 gelesen).
- Z-6: Board-Titel-Volltextbestand #1-#121 (Snapshot 22.08.) traegt KEINEN Task
  "HY-B-Stempel-Export" (0 Treffer "HY-B" in allen 121 Subjects).
- Z-7: TaskGet #24 (22.08., Subject + Description VOLL): kein "FB20-K-1" -- die geforderte
  Nachschaerfung fehlt im Task-Text.
- Z-9: TaskGet #28 (22.08., Subject + Description VOLL): kein "seg4-15" -- die geforderte
  Inventur-Startzahl fehlt im Task-Text.
- Uebrige Z-Zeilen: Z-1 (Fix committet, dev-Kette), Z-2 (#104 completed), Z-3/Z-4/Z-10 (#105),
  Z-12 (a5dc8095, P-09), Z-15 (gedeckt, a-block 4.9: KEIN VERTAGT-Fall, kein HY-B-Task aus T-19
  noetig -- UNABHAENGIG davon bleibt die Z-6-Task-ANLAGE gefordert), Z-13/Z-14 (F2-Fenster/OG),
  Z-11 (AB-05, Abschnitt 4), Z-8 (#93-A-Traeger).

ENTWURF Board-Task-ANLAGE (Z-6, Lead):
```
Subject: HY-B-Stempel-Export (W3) -- gated nach P5 + A-11/#102 (Wellenplan 22.2 T-8 / 22.4 Z-6)
Description: Stempel-Export-Task der HY-B-Strecke; Anlage laut Par.22-Sweep Z-6. GATED: Bau erst
nach P5 + A-11/#102-Vollzug; Di-25/#96 prueft nur die Existenz dieser Task-Zeile.
```
ENTWURF Text-Zusatz #24 (ans Description-Ende): `; Z-7/T-9: B4-Text-Nachschaerfung FB20-K-1
(Par.22-Sweep) -- beim Di-25.-Schnitt abhaken`
ENTWURF Text-Zusatz #28 (ans Description-Ende): `; Z-9/T-11: seg4-15-Messpunkt als
Inventur-STARTZAHL fuehren (Par.22-Sweep)`

--------------------------------------------------------------------------------
## 3. AB-04 (ERNST) -- W1-W16-Marker-Kontrolle: 12-Zeilen-IST-TAFEL (Kontrolle GELIEFERT; Marker-Setzen = Lead-docs-only-Commit vor Di-25)

Liste woertlich Wellenplan :2586-2607; Vollzugs-Signatur-Gegenprobe: grep
"W2-docs-Zug|19.6-Marker|W-Marker gesetzt|Marker 19.6" im Ledger = 0 Treffer (22.08.).
BILANZ: 0 von 12 Markern gesetzt; der 19.6-docs-only-EIN-Commit wurde NIE gefahren.

| W | Ziel (Kurzformel) | IST-Probe 22.08. (Ledger-Stand nach KON120) |
|---|---|---|
| W1 | Arena/6GB: KON93 gilt fuer die GROESSE | KEIN datierter W1-Marker; jung getragene Substanz existiert (KON94-02 :2384 "SCHICHTUNG STATT ABLOESUNG (KORREKTUR AN KON93-02)"; KON112-Schicht :545/:552/:573) -- Marker AM ALT-ORT fehlt |
| W2 | Mess-Nenner: KON71 gewinnt (32/6->12/4!) | grep "12/4" trifft nur Codegen-Fremdstellen (:20913f); KEIN Nenner-Marker |
| W3 | Mess-Ebenen/PMC=Meta-Meta (NICHT an die 5-Orte-Stelle) | KEIN Marker; "gegenstandslos"-grep zeigt keine Mess-Ebenen-Markierung |
| W4 | UEBERHOLT-Marker an KON37-05 | FENSTER :7479-7494 VOLL GELESEN: KEIN Marker (Owner-verbatim-Block endet markerlos vor KON37-06) |
| W5 | 3/2/2 lebt; MENGE "final drei" ueberholt | grep "final drei" = 0 Treffer (Ziel-Wortlaut ggf. anders -- Ort per KON96-Karte Abschnitt B nachschlagen); KEIN Marker |
| W6 | HW-Erkennung: KON64/65-F2 gewinnt; bindend-Klausel an KON-03 | KEIN datierter Marker an einer KON3-Stelle ("bindend"-grep nur Fremdstellen) |
| W7 | Parallel-Deckel: Vorbehalts-Marker an KON73 ("unbeschadet v3.7") | KON73-Block :3320ff traegt KEINEN Vorbehalts-Marker |
| W10 | --debug-Ende: T-3 gewinnt; Marker an KON28-01 + Kapitel E | KON28-01-Treffer (:1767/:5436/:8206/:8460/:8701) = Alt-Substanz, KEIN T-3-Marker |
| W11 | Change-Date 10.08.2031 FINAL; Segment-Marker (LIZENZWIRKSAM!) | Owner-Original-Segment :9427/:9600 ohne Marker; nur Historien-Buchungen (:4669 "11.08. NICHT weitertragen") -- Marker AM SEGMENT fehlt |
| W12 | Dock-32-Deckel willkuerlich; K5-Text per V7 nachziehen | Substanz jung getragen (:587 RF-C "Dock-Zahl STATISCH", KON42-Tafel :7735); KEIN datierter W12-Marker am K5-Alt-Text |
| W15 | Repo-Rollen: F6 gewinnt; im #74-Design ausweisen | #74-Design existiert noch nicht (Task #74 pending "W-G-KARTE LIEGT") -- Marker-Ziel entsteht erst mit dem #74-Design; Traeger vorhanden |
| W16 | checkpoint_measure: "Erfindung"-Befund austragen | Erfindungs-These lebt UNMARKIERT: :15845-15847 "Die checkpoint_measure-Erfindung ist endgueltig belegt." (+ :16855/:16861/:17163) -- Austragungs-Marker fehlt |

LEAD-REZEPT (19.6-Formel): EIN docs-only-Commit; je Ziel datierter Marker AM ORT
("juengeres Owner-Wort gewinnt, Zeile bleibt"); W11 zuerst (lizenzwirksam); W16 zusaetzlich
den "Erfindung"-Befund an :15845-15847 als AUSGETRAGEN kennzeichnen (r5-C1: Owner-Wort bereits
08.08., KON60(iii) = Bestaetigung); W15 als Auflage in das kuenftige #74-Design uebernehmen;
Ergebnis als 12-Zeilen-Tafel im Commit-/KON-Text zitieren (diese Tafel ist das Rohmaterial).

--------------------------------------------------------------------------------
## 4. AB-05 (MILD) -- T-13/Z-11-Rest: par.69.6-Marker + SHA-Zuordnung
**Traeger: Di-25/#96-Docs-Zug (Wellenplan-T-13-NACHZUG-Formel; #96 = Dauer-Register, existiert).**

IST (22.08.): Ledger:23622 (Anker: `**69.6 OD-7 NEUE RUNNER-ZAHLEN`) traegt "prod1=24 Worker"
OHNE Marker; :14453 = Analyse-Zitat, kein Marker AM ORT. KON120-05 "V8-prod1-VOLLZUG" betrifft
den GitHub-PAT-Spiegel prod1 (Store-Zeilen/ls-remote), NICHT die Worker-Zahl.

ENTWURF -- datierter Marker DIREKT UNTER :23622 (Zeile bleibt):
```
  > **[MARKER 22.08.2026, W2-docs-Zug T-13/Z-11]:** "prod1=24 Worker" ist der Owner-
  > BETRIEBSWERT (Worker != Kerne, s. KON26-05/KON28-01-Vermengungs-Befund); die Maschine
  > prod1 hat real 16 Kerne / 32 Threads (Kern-Zahl-Korrektur :9085-9087, Memory-Referenz
  > "prod1 = 16 Kerne/32 Threads, die 24 war falsch"). Zusatz-Notizen: (1) SHA-Zuordnung
  > 9f8e2be8-vs-3ba0f7b3: 3 von 4 Zuordnungen stimmen, seg3-kon8-11 in Register 13.1
  > entlastet. (2) D-1-Kill-Switch-Haelfte GEDECKT durch cidual-Strang (bau/cidual @
  > 223ab518, when:never-Kill-Switch; cidual-Audit F-28 BEHOBEN-im-Branch).
```

--------------------------------------------------------------------------------
## 5. AB-06 (MILD) -- JB-4: KON99-03-Inventar-Nachbuchung
**Traeger: Lead-Ledger-Zug (KON121 / naechster docs-Zug).**

IST (22.08.): KON99-03 (Ledger:2114-2115, Anker: `PERSISTIERT (B.3-Karten-Sicherung)`)
deklariert "(11 Dateien: ...)"; `ls ~/backups-workflow/20260817-buendel15-und-wf10/ | wc -l` = 14;
Delta exakt vl6a-karte.md + vl6b-karte.md + vl6c-karte.md (mtime Aug 17 10:16, die uebrigen 11
Aug 17 08:44); kein Nachbuchungs-Marker im Fenster :2095-2125.

ENTWURF -- Ein-Zeilen-Nachbuchung DIREKT UNTER :2115:
```
  > **[JB-4-NACHBUCHUNG 22.08.2026]:** B.3-Karten-Sicherung real 14 Dateien -- zusaetzlich
  > vl6a-karte.md + vl6b-karte.md + vl6c-karte.md (17.08. 10:16, nach der 11er-Deklaration
  > abgelegt); Karten-Inhalt getragen ueber den X-15/12.4-Zugang.
```

--------------------------------------------------------------------------------
## 6. AB-07 (MILD) -- U-4: K16-Stopp-Baustein in Session-Vorlage B.0
**Traeger: Lead-Docs-/Memory-Zug (Wellenplan :3226-3228: "benannter Punkt der 12.4-Docs-/Memory-Zug-Liste, buendelbar mit den K15-Memory-Neuzugaengen 22.2 T-14").**

FUNDORT-KLAERUNG (Schritt a, 22.08. gemessen): Ein Objekt "Session-Vorlage B.0" existiert
NIRGENDS auffindbar -- Wellenplan-grep "B.0" trifft nur B-01..B-08-Naht-Posten; W2-ABFOLGE-DESIGN
referenziert B.0 nur in der A-8-Zeile (Z.72); docs/sessions traegt nur OWNER-VORLAGE-Dateien;
der U-4-Befund selbst sagt "0 Treffer ... weder 'Stopp-Baustein' noch 'Session-Vorlage'/'B.0'".
FOLGE: Der Lead MUSS zuerst entscheiden, WO die Session-Vorlage B.0 lebt (Kandidaten:
Wellenplan-Session-Gruendungs-Block bzw. das Neugruendungs-/ARBEITSWEISE-Dokument der
Handover-Konvention docs/sessions/, s. reference_diplomarbeit_impl_session_handover_location.md)
oder sie als benannten B.0-Abschnitt NEU anlegen -- erst dann den Baustein einsetzen.

ENTWURF K16-STOPP-BAUSTEIN (Wortlaut aus dem K16-Arbeitsfehler-Memory, Absatz-fertig):
```
K16-STOPP-BAUSTEIN (Schreiberwechsel-Protokoll, Pflicht bei jedem Worktree-Uebergang):
Ein Worktree-Schreiberwechsel ist ein PROTOKOLL (Stopp -> Bestaetigung -> Start), kein Spawn.
1. VOR jedem Nachfolger-Start im selben Worktree: dem Vorgaenger eine explizite STOPP-ORDER
   senden und die Bestaetigung abwarten (oder seine Mailbox-Lage pruefen) -- "Kontext am Ende"
   + saubere Uebergabe ist KEIN Stillstand, solange Nachrichten zustellbar sind; jede
   SendMessage resumed den Agenten.
2. EIN Schreiber je Worktree; git commit nimmt die ganze Staging-Area.
3. Symptom-Erkennung: "Aenderung spurlos verschwunden" oder Fremd-Edits im eigenen Baum
   => SOFORT lsof/Prozessliste auf parallele Schreiber, nicht Umgebungs-Mystik.
(Quelle: K16-Vorfall 18.08.2026, bump15-a/bump15-b; KON119-02-Vorfallskern.)
```
Vollzug danach im KON-/Docs-Zug quittieren (U-4-Zeile).

--------------------------------------------------------------------------------
## 7. AB-09 (MILD) -- A-10: JB-2-Repo-Spiegel + T-17-fixstrecke2-Schnappschuss
**Traeger: W2-Wellen-Ende-Vollaudit-BU (Owner-Dauerregel 21.08., Praezedenz #110/86f4fc1e) bzw. naechster Folge-BU-Zug -- Repo-Commit erforderlich, darum NICHT durch diesen worktree-losen Doku-Strang.**

IST (22.08. gezaehlt): ~/backups-workflow/20260819-fixstrecke2-logs/ = 237 Dateien;
~/backups-workflow/20260817-welle-vorlauf-protokolle/hy-a/ = 8 Logs (4x BEFUND-rcu-*, 2x
F11-vollbau-ctest-*, F1-floor-messung, F1-wachen-abnahme); docs/sessions/backups/ grep
"fixstrecke" = 0 Treffer; kontext14-Ordner = 18 gepruefte Dateien + REDAKTIONS-NOTIZ, KEINE
fixr1_*/fixstrecke2_*-Datei. Quelle also EINLAGIG.

AUFLAGE (Spezifikation fuer den BU-Zug):
1. Beide Bestaende ADDITIV nach docs/sessions/backups/ spiegeln (eigener 20260822er-Ordner
   oder kontext14-Erweiterung; nichts ueberschreiben).
2. gitleaks-Redaktion NEU fahren (stdin-Modus MIT --config PFLICHT; Koeder aus einer Regel der
   wirksamen Config [glpat-+20 gilt, AWS beisst nicht] MUSS beissen [rc=1], Echtlauf rc=0;
   Bilanz JE DATEI). K13-Regel: die 18/18-Freigabe vom 19.08. deckt NUR den Alt-Schnappschuss,
   NICHT diese 237+8 Dateien.
3. REDAKTIONS-NOTIZ-Nachtrag (Datei-Bilanz-Tafel) + eine Zeile zur f45e995b-tsan-Patch-Zuordnung
   (RCU-Doku-Nachzug, s. #80) mitfuehren.
4. Koeder-Literale in Commit-Texten MASKIEREN (stdin-Wache triggert sonst).

--------------------------------------------------------------------------------
## 8. AB-10 (MILD) -- A-13-Drift: Standalone-Klon auf main
**Traeger: Lande-Protokoll #113 (NACH #113-Abschluss; waehrend #113 KEIN Eingriff -- paralleler Schreiber).**

IST (22.08. gemessen): /home/comdare/Projekte/Research/comdare-prt-art -> branch --show-current
= main @ 01e8b7d ("Konsolidierung Rest-TODOs (T1/T2/T4/T7): Fehl-Move-Korrektur ..."); development
= 777fff7; Board #113 in_progress (W1L-LANDUNG laeuft: prt-art pinduo+B14 nach Rezept #107).

AUFLAGE: Nach #113-Abschluss HEAD-Lage NEU messen (`git -C /home/comdare/Projekte/Research/
comdare-prt-art branch --show-current` + `log -1` + `status --porcelain`). Steht der Klon dann
OHNE Lande-Grund weiter auf main: `git switch development` (FINDINGS#14-Klasse; ABNAHME "git
branch zeigt development") und den Befund im #113-Lande-Protokoll quittieren. Steht er wegen der
Landung auf main (z.B. main-FF-Arbeit), gilt der Lande-Grund als Quittung.

--------------------------------------------------------------------------------
SELBSTCHECK: ASCII-only (0 Non-ASCII-Zeilen); alle IST-Angaben dieses Dokuments am 22.08.
selbst gemessen (Ledger-Fenster/greps, ls-Zaehlungen, TaskGet #24/#28, Board-Snapshot #1-#121,
git-Kommandos an ce-/super-/prt-art-Klonen NUR LESEND); keine Ledger-/Board-/Memory-Schreibung
durch diesen Strang.

--------------------------------------------------------------------------------
## 9. VOLLZUGS-STAND-NACHTRAG 23.08.2026 (Wiederanlauf-Messung -- DOPPEL-EINBAU-SPERRE)

Heute (23.08.) am Objekt NEU gemessen (Ledger 32387 Z.; super-HEAD 38428099 "docs:
ABBRUCHSICHERE PAUSE 23.08. ... 3 Workflows gestoppt + 6 Peer-Sessions angehalten"):
- Abschnitt 1 (AB-02, ENTWURF a+b): VOLLZOGEN AM ORT -- Marker (a) steht unter der
  [Par.59-MERGE-STEMPEL]-Zeile (heute :23337; Markerblock :23338-23343, Endzeile "... loest
  KEINEN Trigger-Bau am 26.08. aus."); Marker (b) steht an der Folge-TODO-Liste (heute
  :23121ff). NICHT ERNEUT EINSETZEN (S-3-Doppel-Marker-Klasse).
- Abschnitt 4 (AB-05, Marker-ENTWURF): VOLLZOGEN AM ORT -- Markerblock heute :23731-23737
  unter der 69.6-OD-7-Zeile (:23730), inkl. SHA-Zuordnungs- und Kill-Switch-Notiz.
  NICHT ERNEUT EINSETZEN.
- Abschnitt 5 (AB-06, Nachbuchung): VOLLZOGEN AM ORT -- "[JB-4-NACHBUCHUNG 22.08.2026]" heute
  an :2211ff unter der PERSISTIERT-Zeile (:2209); Ordner-Ist unveraendert 14 Dateien.
  NICHT ERNEUT EINSETZEN.
- Abschnitte 2 (AB-03), 3 (AB-04), 6 (AB-07), 7 (AB-09), 8 (AB-10): WEITER OFFEN --
  Eigenmessungen 23.08.: Ledger-grep "HY-B-Stempel-Export" = 0 Treffer; W4-Fenster (KON37-05,
  heute :7578-7593) und W16-These (:15945f) markerlos (0 der 12 W-Marker gesetzt; die
  vollzogenen W18/T-13/JB-4-Marker gehoeren NICHT zu den 12); einziger "K16-STOPP-BAUSTEIN"-
  Treffer im Wellenplan = der U-4-Befund selbst (:3226); docs/sessions/backups/-grep -i
  fixstrecke RC=1 bei Quellen 237+8 Dateien; prt-art-Standalone weiter main @ 01e8b7d
  (PAUSE-Order haelt das #113-Fenster an, Eingriff bleibt verboten).
Zeilennummern = Stand 23.08. (38428099); es gelten weiterhin die WORTLAUT-ANKER (Z.6-7).

SELBSTCHECK (Nachtrag): Abschnitt 9 = 0 Non-ASCII-Zeilen; Abschnitte 1-8 unangetastet.
