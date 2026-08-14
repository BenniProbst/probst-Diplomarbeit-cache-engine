# A-1 -- VORLAGE-FORM FUER BACKUP-REF-AKTIONEN + AUSGEFUELLTE FASSUNG + E-1..E-4-BILANZ (Task #21, W0b)

Stand: 2026-08-13 * BAU #21 (Klasse (-), kein Bau) * Worktree /home/comdare/wt-super-e21,
Branch bau/e21-vollzug-a1, Basis origin/development @ a103e518.
Herkunft: Task #21 "[W0b/-] E-1..E-4-Vollzug + A-1-Vorlagetext (gate-t die #10-Ref-Haelfte)"
(Wellenplan v2 :2125, Wellenkonsolidierung :188) * Ledger-IV/M-Posten (Stand a103e518 :3081):
"E-1...E-4-Vollzug * der A-1-Vorlagetext vor jeder Backup-Ref-Aktion" * KON37-07 * KON27-04
P.15/P.12.
Quellen (autoritativ, am 13.08. gegengelesen): Rohtranskript
~/.claude/projects/-home-comdare/5a19728e-f6e1-4736-a246-e3fda9ac35a1.jsonl
Z. 35872 (assistant, 2026-08-10T12:20:53Z) * Z. 35912 (user/Owner, 12:40:23Z) *
Z. ~35913-35950 (Ausfuehrung + erster Beleg, bis 12:43Z) * Z. ~36022-36039 (korrigierter
Vollscan, 12:50-12:52Z) * Z. 35995/35999 (Owner zu beiden Remotes, 12:49Z) * Ledger
docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (Anker primaer ueber KON-Kennung,
Zeilennummern nur mit Stand-Angabe a103e518; L-6/KON11-05: Zeilenanker instabil) *
ce origin/development (git grep, nur lesend).
Owner-Zitate in diesem Dokument: gekennzeichnete ASCII-Transliteration (Originale mit
Umlauten/Sonderzeichen an den genannten Fundstellen).
Verbindlichkeit: Ledger-Buchung ist Lead-only -- der zugehoerige KON-Nachtrag liegt dem Lead
als ledger_vorschlag aus #21 vor. Dieses Dokument loescht nichts und ersetzt nichts.

---

## TEIL I -- WIEDERVERWENDBARE VORLAGE-FORM (10 PFLICHTFELDER)

GELTUNG: JEDE Aktion an JEDER Backup-Ref (loeschen remote/lokal, buendeln, ueberfuehren,
umbenennen), in JEDEM der vier Repos, auf JEDEM Remote -- und auch fuer LESENDE Sweeps ueber
fremde Klone, wenn eine Owner-Vorlage sie sequenziert hat. Die Vorlage wird VOR der Aktion
dem Owner vorgelegt; ohne gegenstands-genaues GO geschieht nichts.

Feld 1 -- GEGENSTAND (gegenstands-genau; Nummern sind kein Beleg):
  voller Ref-Name * SHA * Commit-Datum/-Titel * Repo * BEIDE Remotes EINZELN benennen
  (GitLab origin UND GitHub; Owner 10.08., Z. 35995: "hast du auch beide gescrubt? Sonst
  ist es gleich wieder dreckig"; Z. 35999: "Und github ist public" -- GitHub public ist der
  kritischere Fall) * Erreichbarkeit: haengt der Commit an einem Branch?

Feld 2 -- INHALT der Ref:
  was genau drinsteht * Sensitivitaet * sind die Werte noch GUELTIG? Lehre aus dem
  historischen A-2-Text (Z. 35872): "Das Loeschen der Ref entfernt die Kopie, nicht die
  Gueltigkeit" -- Rotation zaehlt mehr als Loeschung.

Feld 3 -- ZWECK der Ref und ob er erfuellt ist (mit Messwert/Beleg, nicht mit Behauptung).

Feld 4 -- GEPLANTE AKTION praezise + ZEITPUNKT:
  loeschen remote/lokal, buendeln, ueberfuehren, umbenennen; bei Stufenplaenen die JETZT
  anstehende Stufe benennen (Praezedenz-Form KON22-02: stehen lassen -> rechtebeschraenktes
  Bundle nach Lieferphase -> erst dann Remote-Loeschung).

Feld 5 -- WAS UNWIEDERBRINGLICH WAERE:
  welche Information nach der Aktion NIRGENDS mehr existiert; Gegenpruefung lokale Klone
  UND Bundles (Praezedenz: /home/comdare/prescrub-bundles-2026-07-25/ mit SHA256SUMS.txt
  als additives Sicherungs-Muster). DIESES FELD FEHLTE IM HISTORISCHEN A-1 -- neu PFLICHT.

Feld 6 -- EMPFEHLUNG mit BELEG-PLAN:
  welcher Nachweis schliesst die Aktion ab. Fuer Scans PFLICHT-Detail (Falsch-Null-Lehre
  10.08.): gitleaks git folgt nur HEAD -- Vollscan MIT --log-opts=--all fahren und den
  NENNER (Ref-/Commit-Zahl) ausweisen.

Feld 7 -- EXPLORE-KLAUSEL:
  nur vorlegen, was ein GEFAHRENER Explore nicht aufgeloest hat (Praeambel der
  10.08.-Vorlage Z. 35872; KON41-05-Betriebsregel; Memory-Regel Hardware-Erweiterung).

Feld 8 -- HAUSREGELN benennen:
  Remote-Loeschung NUR mit ausdruecklichem, gegenstands-genauem Owner-GO
  (feedback_remote_deletion_requires_explicit_user_authorization -- im historischen Fall
  in der Vorlage selbst zitiert) * Backups additiv, nie loeschen * Doku nie loeschen.

Feld 9 -- VERBUCHUNG IM SELBEN ZUG:
  Vorlage + Owner-Wort (verbatim, mit Zeitstempel/Zeile) + Ausfuehrung + Beleg SOFORT in
  den Ledger. Die KON58-04-Lektion ("ohne Buchung verschwunden") entstand ALLEIN aus der
  fehlenden Buchung, nicht aus fehlender Autorisierung.

Feld 10 -- GELTUNGSBEREICH/BESTAND am Objekt:
  aktuelle Backup-Refs listen (git for-each-ref + ls-remote je Remote), damit die Vorlage
  den Bestand kennt und die Gegenprobe traegt.

---

## TEIL II -- AUSGEFUELLTE FASSUNG: refs/backup/pre-secret-scrub-20260802 (Referenzbeispiel)

STATUS: Aktion bereits VOLLZOGEN am 10.08.2026, owner-autorisiert in derselben Session.
Diese Fassung dient der VERBUCHUNG/KENNTNISNAHME -- es steht KEINE neue Aktion an.

Feld 1 -- GEGENSTAND: refs/backup/pre-secret-scrub-20260802 im super-Repo
  (probst-diplomarbeit-cache-engine). Zuletzt auf origin (GitLab) mit SHA
  5ba3d03fdd5d612d747e18f9b5b4f2d0fdb89f80 (ls-remote-Beleg unmittelbar vor der Loeschung,
  Transkript Z. ~35922); fruehere Erhebung nannte als Anlage-Commit 44820451 (02.08.,
  "backup(e23): Suchlauf-...", Z. ~4845). Der Commit hing an KEINEM Branch. Remotes:
  origin (GitLab) trug die Ref; GitHub war vorher schon leer (VERIFY-KORREKTUR 13.08.:
  das Zitat "github ist sauber" stammt aus der ANLAGE-Aera 02.08., Z. ~4845 -- derselben
  Zeile wie der Anlage-Commit-Beleg; im Loeschfenster Z. 35913-35994 faellt das Wort
  "github" nicht; Bestaetigung Z. ~36039: "GitHub war nie betroffen").
Feld 2 -- INHALT: 776 Runner-Token-Vorkommen (Kopien), alle in EINEM Commit. Sensitivitaet
  hoch. Gueltigkeit: durch Loeschung NICHT beruehrt -- Rotation ist der eigene Posten A-3
  (Owner 10.08.: "A-3: volles go"), Token-Hygiene laeuft dort.
Feld 3 -- ZWECK: Beleg, dass der Scrub nichts zerstoert hat -- ERFUELLT und GEMESSEN:
  390/386 Saetze, 114 Felder, nur runners_token -> [REDACTED].
Feld 4 -- AKTION: Loeschung remote (git push origin --delete) + lokal (git update-ref -d),
  ausgefuehrt unmittelbar nach dem GO (12:40-12:43Z, Z. ~35913-35944), Nachweis in der
  Session: "Backup-Refs auf origin: 0".
Feld 5 -- UNWIEDERBRINGLICH (nachtraeglich erhoben; das Feld fehlte in der historischen
  Vorlage): die Sammel-Kopie der 776 Token in dem einen Commit. KEIN Bundle der Ref
  existiert (KON58-04: "kein Bundle gefunden"; die prescrub-bundles-2026-07-25 decken den
  FRUEHEREN Scrub vom 25.07., nicht diese Ref). Die Token-WERTE selbst existieren bei den
  Runnern weiter (Feld 2) -- verloren ist nur die Kopie, deren Fortbestand ein RISIKO war,
  kein Wert.
Feld 6 -- EMPFEHLUNG + BELEG: Empfehlung der Vorlage war "loeschen, danach Vollscan als
  Beleg 776 -> 0". Beleg geliefert MIT EHRLICHER SELBSTKORREKTUR: der erste "776 -> 0"
  (12:43Z, "6538 Commits, 716 MB -> NO LEAKS FOUND") deckte nur HEAD; der korrigierte
  Vollscan MIT --log-opts=--all: super 6634 Refs erhoben (77 Merges/6557 Nicht-Merges),
  6538 commits scanned, "no leaks found" (12:50-12:51Z, Z. ~36022-36029); ce beide
  Remotes 3374 commits scanned, "no leaks found" (12:52Z, Z. ~36038).
Feld 7 -- EXPLORE-KLAUSEL: erfuellt -- Praeambel der 10.08.-Vorlage: "Ich nenne nur, was
  ein gefahrener Explore nicht aufgeloest hat."
Feld 8 -- HAUSREGELN: eingehalten -- Vorlagetext verbatim (ASCII-Transliteration): "Nach
  Ihrer Regel fasse ich Remote-Refs nicht ohne ausdrueckliches GO an."
Feld 9 -- VERBUCHUNG: FEHLTE -- die EINZIGE Luecke des Falls; Aufloesung siehe A-1-KETTE
  unten und ledger_vorschlag (Lead-only).
Feld 10 -- BESTAND am 13.08.2026 (Objekt-Erhebung, nur lesend, super-Objekt-DB
  wt-super-e21):
    lokal:  refs/heads/backup/pre-diplom-adopt-2026-07-22-development (eec84b0e,
            2026-07-22) * refs/heads/backup/pre-diplom-adopt-2026-07-22-main (332c54af,
            2026-07-21) * refs/heads/backup/pre-identity-adopt-2026-07-26 (557b8b38,
            2026-07-26) * refs/remotes/origin/backup/gitlab-artifact-development-2026-07-25
            (14fd135f, 2026-07-23) * Tag refs/tags/backup/pre-p0-sync-20260722 (3a2f26a5,
            2026-07-22)
    origin: genau EINE backup-Ref: refs/heads/backup/gitlab-artifact-development-2026-07-25
            (14fd135f); der Namensraum refs/backup/* ist LEER
    github: KEINE backup-Refs
    pre-secret-scrub-20260802: in KEINER der drei Listen -- Gegenprobe bestanden
    (rev-parse --verify: NICHT VORHANDEN).

### A-1-KETTE (verbatim, ASCII-Transliteration; Originale an den Fundstellen)

1. VORLAGE (Z. 35872, assistant, 2026-08-10T12:20:53Z): "A-1 - GO fuer die Loeschung von
   refs/backup/pre-secret-scrub-20260802. 776 Runner-Token, alle in einem Commit, der an
   keinem Branch haengt. Die Ref hat ihren Zweck erfuellt -- sie sollte belegen, dass der
   Scrub nichts zerstoert hat, und das ist jetzt gemessen (390/386 Saetze, 114 Felder,
   nur runners_token -> [REDACTED]). Nach Ihrer Regel fasse ich Remote-Refs nicht ohne
   ausdrueckliches GO an. Empfehlung: loeschen, danach Vollscan als Beleg 776 -> 0."
2. OWNER-GO (Z. 35912, user, 12:40:23Z): "A-1: volles GO."
3. AUSFUEHRUNG (Z. ~35913-35944, bis 12:43:05Z): git push origin --delete
   refs/backup/pre-secret-scrub-20260802 + git update-ref -d; Nachweis "Backup-Refs auf
   origin: 0"; GitHub war vorher schon leer.
4. BELEG mit Selbstkorrektur (Z. ~36022-36039, 12:50-12:52Z): Vollscan mit
   --log-opts=--all, super "no leaks found" (6634 Refs/6538 commits), ce beide Remotes
   "no leaks found" (3374 commits).

### KERNBEFUND (widerlegt zwei Ledger-Stellen; Marker sind Lead-only, im ledger_vorschlag)

- Das GO deckte die LOESCHUNG direkt und gegenstands-genau (die Vorlage EMPFAHL die
  Loeschung; "volles GO" galt ihr). KON22-02 ("das A-1-GO deckte den Vollscan-Beleg,
  nicht den Zeitpunkt; keine Loeschung vor der Lieferphase") ist eine Fehl-Rekonstruktion
  OHNE den Vorlagetext -- am Rohtranskript widerlegt.
- KON58-04 Befund 3 ("ohne Buchung verschwunden, Verursacher unbekannt ... war das die
  geplante Vollziehung, und wo liegt das Bundle?") ist AUFGELOEST: Verursacher = die
  10.08.-Session selbst, owner-autorisiert; ein Bundle existiert nicht und war nicht Teil
  der genehmigten Empfehlung; es fehlte NUR die Ledger-Buchung.
- KONSEQUENZ fuer die Owner-Vorlage 13.08. (20260813-OWNER-VORLAGE-minio-keys-und-
  backup-ref.md, Frage 2): schrumpft von "bestaetigst du die Loeschung nachtraeglich?"
  auf eine KENNTNISNAHME-Mitteilung; der owner-gegatete Klon-Sweep entfaellt als
  Ref-Frage und wandert als Token-Hygiene-Punkt zur A-3-Rotation. Frage 1 (MinIO-Keys)
  bleibt unveraendert offen. (NACHTRAG-Block an der Vorlage: additiv, dieser Branch.)

---

## TEIL III -- E-1..E-4-VOLLZUGSBILANZ (E-Block der 10.08.-Vorlage "E -- AUS DEM LEDGER, unbeantwortet")

WARNZEILE E-SERIEN-KOLLISION: mindestens 5 E-Serien im Korpus -- (1) E-01..E-26
Wahrheits-Anker 26.07. (KON-59) * (2) E-1..E-5 Owner-Entscheide 06.08. * (3) E1..E4 ohne
Bindestrich = Erhebungs-/Experiment-Ebenen (E-Label-Umbenennung KON37-05) * (4) E-1..E-10
Hybrid-Entscheide 09.08. * (5) DIESER Block (10.08.-Vorlage Z. 35872). Zusaetzlich nicht
zu verwechseln: "E-1, W-7 und W-6 wieder in voller Laenge einfuegen" (11.08., Z. 42730/
42736) betrifft die Verify-Befunde der Nacht 7b, vollzogen per KON11-03/-04/-05.
IMMER den GEGENSTAND pruefen, nie die Nummer (Ledger-IV/L-8, OV-Regel).

E-1 -- OV-4 MESS-DECKEL. Owner 10.08.: "E-1: Bitte nochmal mit mehr Kontext was das sein
  soll." MATERIELL ERLEDIGT 12.08.: die OF-5-Frage wurde mit Kontext vorgelegt (KON40-03)
  und beantwortet (KON41-01 Generalproben-Doktrin: "Beides", --debug bis T-3, manueller
  Reset Builds+Messdaten, finaler Lauf; Owner-Delegation "analysiere das Problem damit
  eigenstaendig"). Ergebnis: der alte Deckel (ETA <= 4,5 Maschinentage) passt nicht in
  3 Tage -- neuer Strecken-Posten "OV-4-Deckel = f(T-3-Fenster)"; die RECHNUNG ist
  W2-Posten (mit S-19-Zahlen VOR der GO-Vorlage ##51), NICHT #21.
  #21-Anteil: Verbuchung -- datierter UEBERHOLT-Marker an KON2-36 ("OV-4 MESS-DECKEL
  BLEIBT UNBEANTWORTET", Stand a103e518 :9050) auf KON41-01. -> ledger_vorschlag,
  Lead-only. KEINE Owner-Frage mehr.

E-2 -- LEDGER-SELBSTWIDERSPRUCH MERGE-STEMPEL (Vorlage 10.08. zitierte ":9468/:8941" im
  DAMALIGEN Stand; heute tragen diese Zeilennummern andere Gegenstaende -- Zeilenanker
  instabil, L-6). Owner 10.08.: "E-2: Bitte mit mehr Kontext." AM OBJEKT VOLLZOGEN:
  Owner-E2 vom 02.08. ("Merge Zeile kann daher nicht existieren") hat gewonnen; DV-1
  (dokumentierter Default) hat den merge-Stempel-CODE in A13-M3 ERSATZLOS entfernt, die
  Merge-DURCHFUEHRUNG (merge_plan.hpp) blieb. Objekt-Belege ce origin/development
  (13.08. gegengeprueft, nur lesend): adhoc_emitter.hpp:110 ("A13-M3 (Owner-E2): der
  frueher hier stehende merge_stamp-Parameter und sein 4-arg-_MERGE-Zweig sind
  [entfernt]") * anatomy_version_stamp.hpp:392 ("merge_stamp_line-Renderer ... ist
  ERSATZLOS ENTFERNT") * merge_plan.hpp (Merge-Naht lebt, golden-CRC unberuehrt).
  Die woertliche "mit mehr Kontext"-Neuvorlage fand nie statt und ist durch Objekt-
  Vollzug + existierendes Owner-Wort GEGENSTANDSLOS (Empfehlung; Alternativ-Entscheid
  beim Lead -- nur falls der Lead sie doch will, als Zeile in die naechste Owner-Vorlage).
  #21-Anteil: datierte UEBERHOLT-Marker an die zwei heute stalen Zeilen (Stand a103e518
  :18006 "[Par.59-MERGE-STEMPEL] K7a Merge-Stempel-POD ... (OFFEN, hoch)" und :18219
  "DRITTER Merge-Stempel (K7a GELANDET: POD 72/layout 3)"; Anker ueber Wortlaut
  "K7a"/"Merge-Stempel", nicht ueber Zeilennummer) -- Original + Marker, nie loeschen
  (Praezedenz KON58-03). -> ledger_vorschlag, Lead-only.

E-3 -- W-6 VIER LOKALE KLONE. Owner 10.08.: "E-3 W-6: Bitte die Situation genauer
  erklaeren." SCHON ERLEDIGT: Neuvorlage erfolgte als Frage F-F (12.08.); Owner verbatim
  in KON37-07: Zielzustand bestaetigt, unter Konsolidierungspflicht; Ordnung gehoert zur
  Konsolidierungs-Architektur #88. Genau dieses Gate ("W-6-Gate GEFALLEN") macht #21
  KOMPLETT abschliessbar (Wellenkonsolidierung :188, Wellenplan v2 :2125).
  #21-Anteil: keiner mehr; Rest lebt in #88.

E-4 -- DREI WEITERE AUS NACHTRAG I (Bindestrich-Serie KON-12/KON-20/KON-57, NICHT
  KON12/20/57 der Nachtrags-Zaehlung). Owner 10.08.: "E-4: alle mit viel Kontext erneut
  fragen."
  (a) KON-12 (T-5: Zusage 3 Wiederholungen, real 1; Drift-Gate strukturell wirkungslos;
      Owner-Frage war: kennzeichnen oder nachmessen): SOLL-Seite ERLEDIGT per KON37-06/
      F-H (je 5 Fehlversuche fuer Build UND Messung; bei Erfolg 3 Wiederholungen je
      Parameter und Binary, alle 3 Werte EINZELN persistiert, nie gemittelt).
      Bestand-Seite MATERIELL GEDECKT durch KON41-01 (T-3-Reset: Builds+Messdaten der
      Generalprobe werden geloescht; der finale Lauf zaehlt) -- der n=1-Altbestand ist
      Generalprobe ohne Endgueltigkeits-Anspruch.
      #21-Anteil: EINE Ledger-Kennzeichnungs-Zeile "Altbestand n=1 = ohne Drift-Aussage
      (Generalprobe)" -> ledger_vorschlag, Lead-only. KEINE Owner-Frage mehr
      (deklarieren, nicht fragen).
  (b) KON-20 (concurrency=1 gegen OD-7 24-vs-16): Begruendung steht seit Nachtrag I im
      Ledger (concurrency=1 bewusst, damit Messungen nicht gestoert werden; "gewollt,
      kein Defekt"). OD-7-Konflikt aufgeloest: KON26-05 (prod1/prod2 seit 22.07.
      vertauscht; real prod1 = 16 Kerne/32 Threads) + KON28-01 (HEAVY_J 24 -> 16) +
      KON58-03 (Infra-Handout, genau eine Zeile runner-mode.sh:43; Alt-Zitate markiert;
      Par.69.6-HEAVY-prod1-Teil UEBERHOLT; N-3/N-4 neu gerechnet).
      #21-Anteil: nur Feststellung der Verbuchung (hiermit). Operativer Rest (Livecheck
      16-vs-24) = #22(i)/Infra, NICHT #21.
  (c) KON-57 (E-26 vom 26.07. "Wir kompilieren und Testen nur Aenderungen neu" inkl.
      Test-Skip vs. "gesamte Pipeline hart gruen"; KON-01 Lagerhaltungs-Skip als einzige
      belegte Ausnahme; "Nicht glattrechnen."): Seither entschieden sind BAU-Seite
      (Owner 10.08., D-2: "Gebaut wird immer, skip ist VERBOTEN"; KON22-01/8;
      generalisiert KON55-01 auch lokal) und LAGER-Seite (Owner 12.08., KON41-01: "Das
      Lager faehrt skip sobald es voll ist"; KON53/54: Wiederanlauf skippt Fertiges,
      Skip-Doktrin kennt nur GUELTIGEN Bestand). NICHT entschieden ist allein die
      TEST-Schicht. Gegenprobe: "E-26" hat im Ledger keine juengere Fundstelle als
      KON-57/KON-59; die Skip-Entscheide im KON36-58-Band treffen nur Bau- und
      Lager-Seite.
      #21-Anteil: die owner-verlangte Neuvorlage "mit viel Kontext" -- EINZIGER aus dem
      E-Block verbleibender Owner-Entscheid. Vorlage-Zeile siehe unten.

### OWNER-VORLAGE-ZEILE (fuer die naechste Owner-Vorlage; einziger E-Block-Rest)

FRAGE (KON-57-Rest, TEST-Schicht; mit viel Kontext, wie am 10.08. verlangt): Am 26.07.
galt E-26 "Wir kompilieren und Testen nur Aenderungen neu" -- einschliesslich Test-Skip.
Dagegen steht deine Linie "gesamte Pipeline hart gruen" (allow_failure verboten seit
06.07.). Seither hast du entschieden: BAU-Seite 10.08. (D-2): "Gebaut wird immer, skip
ist VERBOTEN" (gilt per KON55-01 auch lokal). LAGER-Seite 12.08. (KON41-01): "Das Lager
faehrt skip sobald es voll ist"; die Skip-Doktrin kennt nur GUELTIGEN Bestand (KON53/54),
und KON-01 (Lagerhaltungs-Skip fuer gruen inventarisierte Binaries) ist die einzige
belegte Ausnahme -- sie deckt Binaries, nicht Tests allgemein. OFFEN ist allein die
TEST-Schicht: Muss jeder Lauf den vollen ctest-Satz fahren (Debug UND Release), oder
duerfen Tests bei nachweislich unveraendertem Pruefgegenstand geskippt werden
(Fingerprint-Beweis + gruen inventarisierter GUELTIGER Bestand, analog Lager-Doktrin)?
EMPFEHLUNG des Bearbeiters: CI faehrt immer Voll-ctest (hart gruen, kein
allow_failure-Aequivalent ueber Test-Skips); Fingerprint-Skip hoechstens lokal als
Arbeitsmittel ohne Beweiskraft; KON-01 bleibt als einzige Ausnahme bestehen. Nicht
glattgerechnet: E-26 wird damit fuer die Test-Schicht ausdruecklich REVIDIERT, nicht
uminterpretiert.

---

## TEIL IV -- GATE #10-REF-HAELFTE + SCOPE-GRENZEN

- GATE #10-REF-HAELFTE: FREI. #10 ("haengt an: A-1-Text aus #21", Wellenplan v2 :2124)
  braucht fuer die Ref-Haelfte KEINE Aktion mehr -- die Ref existiert seit 10.08.
  nirgends (Objekt-Gegenprobe 13.08., Teil II Feld 10); es bleibt reine Verbuchung
  (Lead) + Owner-Kenntnisnahme (NACHTRAG an der Vorlage). Die MinIO-Key-Haelfte von #10
  bleibt unberuehrt OFFEN (Frage 1 der Owner-Vorlage 13.08.).
- P/E-CORE-CLUSTER-ANTEIL: NICHT Teil von #21 (W7-Behaelter, KON27-04 P.12) -- hier
  NICHTS dazu bearbeitet.
- NUMMERN-KOLLISION #21/#22 zwischen KON27-04 und Lead-Liste: dokumentiert
  (Wellenkonsolidierung :107, Ledger-IV/L-8: Nummern sind kein Autoritaetsbeleg) -- der
  GEGENSTAND zaehlt.
- LIVECHECK 16-vs-24: #22(i)/Infra.

SELBSTCHECK: ASCII-only eingehalten (Owner-Zitate als gekennzeichnete ASCII-
Transliteration; Umlaute als ae/oe/ue/ss, Gedankenstriche des Originals als "--",
Pfeile als "->" wiedergegeben); alle Erhebungen nur lesend (ce via
git grep am Objekt, Transkript nur lesend, keine Vault-Datei beruehrt, keine Secrets,
Backup-Refs nur gelistet); kein Push; kein Ledger-Edit (Marker liegen im
ledger_vorschlag); Haupt-super-Baum unangetastet.
