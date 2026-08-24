# NACHLANDE-SCHRITT r4 — VORBEREITUNG (waehrend CI-16097-Wartezeit; read-only am Repo)

Schreiber: Endstand-Pruefer/Schlussstrecke (Lead-Order 23.08., Plan B mit 4 Auflagen).
Erstellt ~09:3x UTC. ASCII-only. VOLLZUG erst nach: CI-16097-TERMINAL + K16-Fenster
(B-Bestaetigung ODER 10-min-Nicht-Aktivitaet belegt) + Mutex (mkdir
bauslots/slot2.d/schlussstrecke-r4.d) + Paragraf-7-Marker.

## 1. CHERRY-ANALYSE 5a8e2841 (gemessen)

- Objekt existiert: git cat-file -t 5a8e2841 = "commit" (dangling nach reset, erreichbar).
- merge-tree --merge-base=b6698eaf b247a339 5a8e2841: GENAU 1 Konflikt =
  tests/unit/test_vl3_debug_stdout_bytegleich.cpp (Blobs base 731ed8fd / ours a2419ac4
  / theirs 6d151187); profile_run_facade.cpp AUTO (b247a339-Diffstat = NUR
  support/pmc_stdout_maskierung.hpp + test_vl3 -> Facade-Hunk kollisionsfrei).
- HARMONISIERUNG test_vl3 (beide Absichten, A2.1b):
  a) Kopf: NACH dem b247a339-Block "DRITTE FLAECHE -- DEFINE-KIPP" den Patch-Block
     "RIEGEL-PRAEZISIERUNG" einfuegen; Formulierungs-Anpassung: Riegel haelt die
     Stoergroesse an der QUELLE an, die Maskierungs-Formen (a)/(b)/(c) BLEIBEN als
     Drift-Wachen scharf (Lead: b247a339 bleibt Drift-Wache; kein Widerspruch der
     beiden Blöcke, Koexistenz-Semantik ausdruecklich).
  b) grundstellung(): Patch-Doku + env_setzen("COMDARE_PMC_PROBE_AUS", "true")
     (Region von b247a339 unberuehrt -> im Konfliktblock von Hand nachziehen).
  c) Test-Reihenfolge am Dateiende-Bereich: ...ValidateBytegleich ->
     MaskierungFormCDecktDefineKippGenau (b247a339) -> PmcProbeLebtOhneRiegel
     (5a8e2841) -> ExitAchtSperreLaesstStdoutLeer.
  d) Semantik-Vertraeglichkeit gemessen: PmcRauschInvarianz + 4 Bytegleich-Faelle
     laufen kuenftig UNTER Riegel (deterministisch); Maskierungs-Nenner >=1 bleibt
     erfuellt (Riegel-Befund emittiert die pmc_befund-Zeile als ERHOBEN=0-Klasse
     weiter); MaskierungFormC ist in-memory (Riegel egal); PmcProbeLebtOhneRiegel
     hebt den Riegel fuer seinen Lauf selbst auf.
- ctest-NENNER: unveraendert 544 (neue TESTs leben im bestehenden Eintrag test_vl3;
  kein Floor-Anker-Delta, Gate [5/6] bleibt 544==544).

## 2. VERSCHAERFUNGS-WORTLAUTE (Lead-Auflage 2; eigener Commit nach dem cherry)

(i) PREFLIGHT-RIEGEL-AUSWEIS mit Mess-rot-K13:
  - Neuer Testfall in test_vl3: TEST(Vl3DebugStdoutByteGleich, RiegelWeistNichtErhebungAus)
    -- unter Riegel MUSS die Emission den Grund AUSWEISEN:
    plan dump-stdout enthaelt "grund=probe_per_env_riegel_nicht_gefahren" UND
    " erhoben=0"; plan ci-stdout traegt die "# PMC-BEFUND lage=unbrauchbar"-Zeile mit
    demselben grund= (Ausweis-Pflicht T-2: der Riegel versteckt nichts, er DEKLARIERT).
  - K13-BISSPROBE (Mess-rot) VOR dem Gruen-Beleg: Mutation = in profile_run_facade.cpp
    die fehlgrund-Zuweisung temporaer entfernen -> Testfall MUSS ROT (Literal sichern:
    rc + "grund=..."-fehlt-Text), Revert, danach 3x GRUEN gcc-dbg (Lead-Muster
    "Test-509 3x Debug"). Beweis-Logs nach nachlande-r4/.
(ii) NUR-TEST-Kommentar an der getenv-Stelle (profile_run_facade.cpp, im Riegel-Block):
  "NUR-TEST-OBERFLAECHE: COMDARE_PMC_PROBE_AUS ist fuer Byte-Vergleichs-Tests
   deklariert (Hermetik); KEIN Betriebs-Schalter -- produktive Nutzung braeuchte ein
   Owner-Wort (E-24-Klasse Abschalt-Oberflaechen). Produktions-Laeufe ohne Riegel
   erheben live (PmcProbeLebtOhneRiegel deckt genau das)."

## 3. ABLAUF-VOLLZUG (nach CI-Terminal + K16-Fenster + Mutex; Auflagen 2-4)

1. K16-Fenster: B-Bestaetigung ODER 10-min-Nicht-Aktivitaet (Prozesse + Beweisordner
   + git-Log) belegen; Paragraf-7-Marker in cifix16095/Z10-PROTOKOLL-FORTSCHREIBUNG.md
   (Traeger-Endentscheidung, Zwei-Push-Genehmigung A2.1a zitieren); Mutex mkdir.
2. cherry-pick 5a8e2841 (kein rebase; --no-commit, Harmonisierung Abschn. 1, Commit
   mit Patch-Botschaft + Harmonisierungs-Vermerk + Trailer).
3. Verschaerfungs-Commit (i)+(ii) inkl. K13-Mess-rot-Beleg vor Gruen.
4. K17-r4: 4 Zellen {gcc,clang}x{Release,Debug} auf build-l1/build-l1-clang/build-dbg/
   build-dbg-clang, je VOLLE Treppe (J-0b PRUEFLINGE -> J-1 7er LITERAL -> RECONF ->
   Vollbau -> Facade comdare_profile_run_facade -> comdare_tests -> ctest
   --no-tests=error), df-Gate je Zelle; DANACH Test-509 3x in build-dbg (Lead-
   Klarstellung); Floor-Anker-Abgleich via Gate [5/6] (Nenner unveraendert 544).
5. Gates 6/6 + gitleaks (Koeder-Selbstbiss + Echt-Scan, commits-scanned == rev-list
   --no-merges b247a339..HEAD) -> R4-Lage messen -> ZWEITER Dual-Push (origin+github;
   deklarierte Zwei-Push-Ausnahme A2.1a, Lead-genehmigt) -> CI 286 bis TERMINAL.
6. Raeumung (O-6-rekursiv): Cache-Doppel-Bedingung; wt-ce-lande-Loeschung; slot2.d
   freigeben; Bilanz-Abschnitt 7 + StructuredOutput.

## 4. AUFLAGEN-REGISTER (woertlich zu befolgen)

- Auflage 1: WARTEN auf B-Push (ERFOLGT, b247a339 beidseitig) + CI-286-TERMINAL (laeuft).
- Auflage 2: K16-Fenster sauber; Paragraf-7-Marker; DANN Nachlande-Schritt (s.o.).
- Auflage 3: 16097 ROT => STOPP, Befund an Lead, KEINE Eigen-Heilung parallel zu B.
- Auflage 4: Falls B den Riegel-Rest selbst faehrt: NICHT doppeln, Traeger-Entscheid
  per Koordination, GENAU EINER, Paragraf-7-Marker.
