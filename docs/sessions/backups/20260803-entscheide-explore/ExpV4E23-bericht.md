Recherche abgeschlossen. Hier die Befunde.

## Rahmenbefund zuerst

**Der V4-Block wurde nie als Block beantwortet** — aber die Owner-Behauptung stimmt weitgehend: fast jeder Teilpunkt ist durch einen **älteren, expliziten Owner-Entscheid** gedeckt. Belege:

- Das Vorlagen-Dokument `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260803-OWNER-VORLAGEN-konsolidiert.md` wurde erst **15:15 Uhr** geschrieben, also *nach* dem Login (14:58). Es konnte vorher gar nicht beantwortet werden.
- Alle echten Owner-Nachrichten des 03.08. vor dem Login (Transkript-Auszug, gefiltert gegen Tool-Results/Teammate-Messages) sind Prozess-Anweisungen: 06:14 Resume, 06:34 Neugründung, 06:45 Duplikat-Rüge, 07:11 Arbeitsweise, 07:43 Parallelisierung, 07:55/08:01 Pause. **Keine Sach-Antwort auf eine Vorlage.**
- Der Owner selbst schrieb um 15:07: „Die 11 Owner-Vorlagen … warten mit laufenden Defaults auf deinen Blick."

Die Auflösung: „gründlich beantwortet" bezieht sich auf die **02.08.-Entscheid-Kette** (E1–E6/R7–R9, Q1/Q2/Q3/Q10, GO ~17:4x auf Q4–Q9) plus die **Kanon-Doktrinen** aus Memory. Die V4-Punkte sind überwiegend Quittungen zu bereits Entschiedenem — mit **einer echten Ausnahme, die in die falsche Richtung läuft** (f1, siehe unten).

Wichtig zur Nummerierung: Dein Auftrag ordnet die Buchstaben anders zu als das Doc. Doc-(g) = ceb_legende (dein f); F-WAISEN steht **gar nicht** in V4, sondern im Lage-Dossier §5 Nr. 20 und Ledger:3712. Ich habe beide Lesarten abgedeckt.

---

## (a) `vX.Y.Ze` ohne HW-Flag = Sentinel

**BEREITS-ENTSCHIEDEN.** Owner-Q3 verbatim (02.08. ~17:0x, `20260802-OWNER-entscheide-…md:62`): *„Das 'e' ist eine Flag und kann später gegen andere Falgs wie 'g' für GPU, 'c' für CPU, 'f' für FPGA und 'n' für NPU code erweitert werden. Wir produzieren nur CPU code, daher müssen alle Versionen mit 'c' oder 'ce' enden. Bitte halte das so fest."*

`v1.0.0e` endet auf `e`, nicht auf `c`/`ce` — per Owner-Wortlaut ungültig. Die bindende Auslegung steht seit dem 02.08. im selben Dokument (`:66-67`): Hardware-Flag zuerst, dann optional `e`; *„Eine Version OHNE Hardware-Flag ist ungültig."* Die A13-M1b-Implementierung (Sentinel/hart, CT-Wache, Negativ-Probe) ist die korrekte Umsetzung. Das ist keine offene Frage — die Vorlage bat um eine entbehrliche Quittung.

## (b) Attributname `os_declaration_source`

**DEFAULT-FREIGEGEBEN-VIA-GO.** Kein Owner-Wortlaut nennt den Namen je. Gedeckt ist er dreifach: Owner-E3 (OS-Unter-Achsen JETZT PFLICHT), Owner-GO ~17:4x (*„volles Go für ALLE geplante offene Arbeit wie vorgegeben"*) und die zugestellte Q8-NUR-KENNTNIS-Meldung ohne Einspruch (Ledger:3650, im Doc §B als VOLLZOGEN geführt). Der Ledger-Nachtrag `:3607` protokolliert das Attribut samt Semantik („ERWARTUNG, nicht Werte-Quelle"). Es gibt hier keinen Owner-Entscheid zu finden, weil keiner nötig war — Implementierungsdetail innerhalb freigegebener Arbeit.

## (d) Hybrid-Stempel-Kennzeichen (Sidecar-only vs. Stempel)

**NICHT-GEFUNDEN als explizite Antwort — aber aus Owner-E1 ableitbar und nicht trigger-fällig.** Das Design-Doc `/home/comdare/…/comdare-cache-engine/docs/architecture/20260802-hybrid_tier_stufe_soll_design.md:432-435` führt den Punkt ausdrücklich als *„NICHT Teil von Q6, weiterhin offen"*.

Die Ableitung, die den Default trägt: Owner-E1 verortet die Dock-Bestückung als *„XML Konfiguration auf Wunsch des anwenders in der Auswertungsphase"* — eine Runtime-Konfiguration kann nicht in einem consteval-Stempel stehen, der golden-/binary_id-tragend ist. Der Default (Sidecar-only) folgt daraus zwingend. Zudem ist er an K1 gekoppelt und erst zum Hybrid-Bau bindend, der per Owner-E1 in der Auswertungsphase liegt. Vor dem Trigger ist hier nichts zu entscheiden.

## (e) Hybrid-Randfragen — deine Vermutung bestätigt sich, mit Präzisierung

**Kardinalität + MaxN=8: BEREITS-ENTSCHIEDEN via Q6-GO.** Owner verbatim ~17:4x, im OWNER-Doc `:76` gesichert: *„Q6 Ein-Gattung-Hybrid + MaxN=8 + LEDGER:187(e) superseded"*. Das Design-Doc führt diese Punkte seit CX-W7 (`fc47c5d9`) korrekt als ENTSCHIEDEN (`:425-431`), K4 ebenfalls (`:349-355`). Im Vorlagen-Doc ist das **(h)**, nicht (e) — und §B dedupliziert es bereits.

**Die echten Design-Fragen 4 und 5 sind ebenfalls gedeckt:** Frage 4 (Verdrängungs-Heuristik LRU/LFU/ARC/GDSF, Zeitpunkt Auswertungsphase) folgt aus Owner-E1s Auswertungsphasen-Verortung. Frage 5 (Plattform-Querschnitt) ist Owner-E4 verbatim: *„Ja bitte schärfen, heute kommt noch RISC-V und ein macOS M1 und macOS x86 dazu"*, mit der bindenden Auslegung „betrifft target_isa/operating_system-Achsen, Runner-Flotte, E-19-Soll; Thesis-Nachzug erst wenn real im Bestand". Der laufende Default (bestehende Loader-Fläche, Doku-Aufnahme in die E-19-Matrix) ist genau das. Beide: **DEFAULT-FREIGEGEBEN-VIA-GO**.

## (f/Doc-g) `ceb_legende`-Mengenform bei 0 bzw. >1

**DEFAULT-FREIGEGEBEN-VIA-GO, mit starker Formanalogie aus dem Owner-KERN.** Zur `ceb_legende` selbst existiert kein Owner-Wort. Die Schreibweise ist aber durch die Owner-Stempel-Doktrin vorgezeichnet (Memory `project_bestandslog_abnahmen_baum_heuristik_stempel.md`, Owner 26.07. „ganz wichtig"): *„Die Binary selbst ist die AEUSSERE Klammer ueber ihre Typ-Klammern, Komma-getrennt, nie verschmolzen: … `[[d,e,f],[g,h,i]]`Tier-Binary; CEB = `[[a,b,c]]`CEB"* — plus Owner-Q1 (~12:1x): *„Wie empfohlen nach Klammern"*. Die vorgeschlagene `[[a,b,c],[d,e,f]]`-Form ist damit die kanonisch konsistente; „leer bei 0" entspricht dem Ist („leer = nicht gemeldet"). Kostenfreie Doku-Festlegung, kein Wire-Ereignis — der >1-Fall entsteht erst mit dem Hybrid-Bau in der Auswertungsphase.

## (g) F-WAISEN — 7 Waisen-TUs

**BEREITS-ENTSCHIEDEN in der Richtung, Vollzug terminiert.** Owner verbatim 27.07. ~00:40 (Memory `feedback_abschluss_aufraeumpass_deprecated_code_entfernen.md`): *„Bitte merke dir, dass nach der Bearbeitung aller bekannten Aufgaben die deprecated header und toter code aufgeraeumt und entfernt werden muessen."* Eine nie in einer CMakeLists registrierte Test-TU ist genau das — nie gebaut, nie ausgeführt.

Der Ist-Stand ist bereits owner-konform: V2/F-WAISEN-Default (b) wurde in Welle 2b vollzogen (`bec73aa9`: halbordnung repariert + registriert, Testzahl 327), Restbestand 7 auf der §75-Kandidatenliste (Ledger:3712, mit Namen: br4_emit, br4_load, kf16_e2e_real_build, test_a9b, test_c3b, test_d4b, test_rf2_admission_marker_inert). Die Owner-Regel gibt auch das Verfahren vor: je Fund Aufrufer-Grep = 0 belegen, Tests nachziehen, granularer Commit. Ein separater Owner-Entscheid je TU ist nicht nötig — nur die Anwendung der Regel im Abschluss-Aufräumpass.

---

## E-23-GOs

### (f1) Branch-Doktrin — **hier liegt der eine echte Fund: die Empfehlung widerspricht dem Owner**

**BEREITS-ENTSCHIEDEN, aber gegen die V4-Empfehlung.** Owner-Direktive 07.07. (Fleet-weit, verbatim in Memory `feedback_gitflow_branch_doktrin_main_authoritaet_development_voraus.md`):

> **main** = Default-/Haupt-Branch, stabile Basis, traegt den NEUESTEN Stand … **Neue Repos: default=main + development-Arbeitsbranch.**

Präzisiert 13.07. (*„stehe immer auf development. main ist immer ein Vorfahr von development"*) und 21.07. (*„DURCHGEPLANTE Punkte → main"*). Damit ist der **Ist-Zustand (alle vier Mess-Projekte auf Default `main`) doktrin-konform** — und die V4-(f1)-Empfehlung „Default überall auf `development` umstellen" ist die Option, die der Owner bereits verworfen hat. Die im Doc als „Veto = Ledger-/Doku-Nachzug der Konvention" bezeichnete Variante ist die tatsächlich entschiedene. Die zitierte Gegenquelle ist schwach: GOALV2-Q5 steht im Ledger nur als Zellen-Konvention „branch development" (Ledger:728) und Schritt-0 protokolliert eine einmalige Anlage mit `default-branch development` (Ledger:730) — beides deckt keine Fleet-Regel gegen die explizite 07.07.-Direktive.

Für die Divergenz gilt ebenfalls Entschiedenes:
- **comdare-metrics (76)**, development 19.07. voraus main 07.07.: Das **erfüllt** die Invariante `main ⊆ development`. Der Migrations-Blocker ist nicht der Default, sondern dass main den neuesten Stand nicht trägt — Auflösung per 21.07.-Präzisierung: `development → main` **mergen** (Memory `feedback_nie_rebase_immer_merge.md`: nie rebase). Danach zieht jeder Default-Read den frischen Stand, ohne dass ein Default bewegt wird.
- **Umbrella (300)**, main 26.07. neuer als development 12.07.: Das **verletzt** die Invariante → per Doktrin `main → development` back-mergen.

Empfehlung an dich: (f1) nicht als offene Frage vorlegen, sondern als **Korrektur der eigenen Empfehlung** — mit dem 07.07.-Zitat als Beleg.

### (f2) Tombstone-Köpfe auf 293/294/295/297/298

**NICHT-GEFUNDEN** als Freigabe; Richtung aber unstrittig. Die Maßnahme ist additiv-doku-only und deckungsgleich mit `feedback_never_delete_documentation` („nur ergänzen oder als deprecated markieren"), und der E-23-Bericht hält ausdrücklich fest: kein Löschen. Der 26.07.-GO *„Ich gebe alle offenen Punkten wie empfohlen frei"* (= F0–F5=A) kann das **nicht** decken: er datiert sechs Tage vor dem Suchlauf, der die fehlenden Etiketten am 02.08. überhaupt erst erhoben hat. Es sind fünf Schreib-Zugriffe auf fremde Modul-Repos — hier ist eine Freigabe sachlich fällig, aber unkritisch und nach Abgabe terminiert (Migration = Projektende, Ledger G5/#274).

### (f3) `comdare-analysis` als b3-analysis-Zelle

**Richtung DEFAULT-FREIGEGEBEN, Anlage-GO und Name NICHT-GEFUNDEN.** Die Richtung ist per **F4=A** entschieden (Owner 26.07., E-23-Doc `:94`: *„F4=A baseline_3-analysis JETZT mit erstem Inhalt anlegen"*). Aber derselbe Vorgang protokolliert die Einschränkung selbst — Ledger:550: *„Ein-Blick-GO = ‚alle A' → erster Increment README:7-Fix + b3-analysis/09_tex_formatter (**je Remote-je-GO**)"*, verstärkt durch `feedback_remote_deletion_requires_explicit_user_authorization`: *„Remote-Repos/-Branches NIE löschen/**anlegen** ohne expliziten User-Auftrag je Repo (Sammel-Freigaben decken NUR die lokal benannten Artefakte, nicht Remotes)."* Der Name `comdare-analysis` ist ein Vorschlag der E-23-Session vom 02.08. und nirgends bestätigt. Ein Pauschal-GO kann das strukturell nicht ersetzen — die Doktrin fordert das Einzel-GO.

---

## Was ich dem Owner vorlegen würde

Von acht V4-Teilpunkten sind **sechs erledigt** (a, b, d, e, f/ceb_legende, g/F-WAISEN) — sie brauchen keine Antwort, nur einen Deduplizierungs-Vermerk. Übrig bleiben genau zwei Dinge, und beide sind erst nach der Abgabe fällig: die **je-Repo-Anlage-/Schreib-GOs** für f2 und f3 samt Namensbestätigung. Punkt **f1 ist keine Frage mehr, sondern eine Korrektur**: die eigene Empfehlung läuft gegen die Owner-Gitflow-Direktive vom 07.07.; richtig ist Default bleibt `main` plus `development → main`-Merge bei Projekt 76 und `main → development`-Back-Merge beim Umbrella 300.

Relevante Pfade: `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md` (Zeilen 62-68 Q3, 76 Q6-GO), `…/docs/sessions/20260802-SESSION-e23-gitlab-api-suchlauf-modulmigration.md` (Zeilen 55-56 D-2/D-3, 86 Tombstones, 94 F0–F5, 111 Anlage-Bedarfe), `…/docs/sessions/20260803-OWNER-VORLAGEN-konsolidiert.md` §A.7 + §B, `…/Code/external/comdare-cache-engine/docs/architecture/20260802-hybrid_tier_stufe_soll_design.md:423-444`, `…/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` Zeilen 550, 728, 730, 3607, 3712.