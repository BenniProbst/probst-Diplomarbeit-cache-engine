## NACHTRAG 12.08.2026 — KON33: DIE SICHT IST WIEDERHERGESTELLT — WAS DER PAT SOFORT ZEIGT

**Der neue PAT ist blind aus dem Vault geholt** (9 Kandidaten, rückwärts geprüft, HTTP 200 bei
`keeper-root-rotation-20260725-r20260801`, scopes api/read/write, gültig bis 2026-10-30). Der Wert
verlässt das Werkzeug nie. **Die blinden Pipeline-Abnahmen (seit Task #75) sind beendet.** Erste
Erhebung:

### KON33-01 — 🟢 super development IST GRÜN — zum ersten Mal seit dem Scrub belegt

    super  Pipeline 15732  SUCCESS  sha=0d6bd74b  (12.08. 08:50Z)  <- mein letzter Commit
           15731 success de4ddf6d · 15730 success eb274f1b — die ganze KON-Serie ist gruen gelandet.

**Alle 17 KON-Nachträge dieser zwei Tage sind pipeline-grün** — das war bisher nur „Protokoll des
Bauenden", jetzt unabhängig geprüft.

### KON33-02 — 🔴 ce 15682 ROT: GENAU EIN JOB, WIE VORHERGESAGT

    ce  Pipeline 15682  FAILED  sha=670483c0
        24 Jobs, GENAU 1 rot:  test:coverage-guard  (stage contract, allow_failure=false)

**Das bestätigt die #80/#84-Analyse punktgenau:** der einzige rote Job ist `test:coverage-guard`
— die 4-ISA-plus-1-Prüfling-Fixture-Sache. Task #14 ist damit exakt umrissen: **ein Job, eine
Ursache-Klasse.** Der Dualreview-Reihenfolge folgen (F1 Operanden vergleichbar VOR F2 when:always).

### KON33-03 — DIE VIER INFRA-TATSACHEN, JETZT BEANTWORTET

    COMDARE_MEASUREMENT_DROP_URL = https://measure-drop.comdare.local
      -> zeigt auf den FILTERPOD-Endpunkt (V80), NICHT direkt cache-engine-experiment/.
         Der Kanal fuehrt also ueber den Filterpod -- die Ziel-3-Route liegt HINTER ihm.
         (Konsistent mit dem Verortungs-Brief 18.07.)
    COMDARE_STORAGE_CACHE = NICHT GESETZT (weder Projekt 288/286 noch Gruppe 3)
      -> der Storage-Cache ist per Variable heute AUS. Fuer S-13/Tests zu setzen.
    NODES: prod1 UND prod2 baremetal ONLINE (Kampagne kann ZWEILANIG fahren, KON29-04
           bestaetigt) · pve1/pve2/node3/node4 OFFLINE · diverse k8s/win/arm/riscv online.
           24 Runner sichtbar, 15 online.
    BESTANDSLOG-unter-Last: aus der API nicht einsehbar -- bleibt Owner-/Infra-Frage
           (Infra laeuft heute mittag, KON32-03).

**Sofort-Folge:** die Betriebs-Prüfposten (Task #21) und die ce-Rot-Heilung (#14) sind nicht mehr
blind. Der main-FF (#19) kann nach grüner ce-Pipeline mit belegter Jobliste gefahren werden.
