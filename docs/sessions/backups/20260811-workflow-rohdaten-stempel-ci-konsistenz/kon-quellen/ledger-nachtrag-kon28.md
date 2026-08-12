## NACHTRAG 12.08.2026 — KON28: OD-7 = 16 MIT --debug-KOMPENSATION · T-15b HART/SOFT · MAXIMAL 32 DOCKS

---

### KON28-01 — 🔴 OD-7 ENTSCHIEDEN: DER WORKER-DECKEL FÄLLT AUF 16 — UND DIE KETTE FÄHRT --debug BIS ZUR ABGABE

**Owner verbatim 12.08.2026:**

> *„Er wird auf **16 heruntergestuft, es gab Probleme**. Aber aufgrund der Planungslage können wir
> die **Kette bis release mit dem --debug Flag fahren, um den Verlust an Kapazität auszugleichen**.
> **Das bleibt auch an bis zur Abgabe.**"*

    ENTSCHEID:      HEAVY-Worker-Deckel  24 -> 16   ("es gab Probleme")
    KOMPENSATION:   die Kette bis RELEASE faehrt mit --debug -- BIS ZUR ABGABE (15.09.)

**Was `--debug` im Bestand IST** (`run_methodology_registry.hpp:54-80`, §61-MODI):

    RunMethodology::Debug    parallel/schnell -- je Maschine parallel bauen UND
                             parallel MESSEN (nproc-parallel, #45/99a608c2)
                             "KEINE Mess-golden-Zahlen (Verifikation der Verdrahtung)"
    RunMethodology::Measure  1-Thread/deterministisch -- DIE golden-Messung
    RunMethodology::Release  Voll-Optimierung ohne Mess-Instrumentierung
    RunMethodology::Compare  liest das Messwertlager, Stufe VOR release

Die Kompensations-Logik ist damit exakt: **debug misst nproc-parallel** statt 1-Thread-
sequentiell — das gleicht die 24→16-Reduktion aus.

**⚠️ Eine Präzisierungsfrage bleibt (an den Owner gestellt, 12.08.):** der Bestand definiert
Debug als *„KEINE Mess-golden-Zahlen"* — gilt `--debug` auch für die **W3-Messkampagne selbst**
(dann sind die Thesis-Zahlen nproc-parallel statt 1-Thread-deterministisch erhoben), oder fährt
die Kampagne `measure` und nur die **Ketten-Durchläufe** davor/danach `--debug`?

**Korrekturliste (Bau-Posten):**
    runner-mode.sh:43           HEAVY_J=24 -> 16
    Ledger ~:13907 / ~:13972    zwei "prod1 = 32 Threads / 24 Kerne"-Zitate (Werte waren
                                zwischen den Maschinen vertauscht, KON26-05)
    N-3/N-4-Kapazitaet          "24 Worker je Lane" -> 16 nachrechnen; die ETA-Kernformel
                                (Threads=32) bleibt unberuehrt
    §69.6                       UEBERHOLT-Vermerk mit KON28-Verweis (nicht loeschen)

---

### KON28-02 — 🔴 T-15b-SEMANTIK ENTSCHIEDEN: HART/SOFT — DIE RETRY-KLAMMER IST VOLLSTÄNDIG SPEZIFIZIERT

**Owner verbatim:**

> *„Die **Einstellungen der Achsen failen immer hart**, bis auf **fehlende Messeinrichtungen auf
> der Mess-Achsen-Kategorie (wie ein fehlendes PMC soft fail)**. Daher **scheitert die Messung bei
> hartem Fehler für die Binary komplett** und bei **soft Fehler wird sie wie geplant als Warnung
> in die xlsx mit eingetragen, aber die Binary wird gebaut, die Messung so weit es geht
> durchgeführt**."*

    HART (Default, ALLE Achsen-Einstellungen):
      eine Einstellung failt  =>  die Messung der Binary scheitert KOMPLETT
                              =>  die T-15b-RETRY-KLAMMER greift (bis zu 5 Versuche)
                              =>  nach Erschoepfung: "failed" in die Zelle, Lauf misst weiter
    SOFT (EINZIGE Ausnahme: fehlende MESSEINRICHTUNG der MESS-Achsen-KategORIE,
          z.B. fehlendes PMC):
      =>  WARNUNG in die xlsx eingetragen
      =>  die Binary WIRD gebaut, die Messung SO WEIT ES GEHT durchgefuehrt
      =>  KEIN Retry, KEIN Komplett-Scheitern

**Damit ist Task #13 vollständig spezifiziert:** der Retry-Auslöser umfasst **beide** Klassen —
die drei SourceUnavailable-Pfade **und** `SampleStatus::Failed` einzelner Achsen-Einstellungen
(hart) — mit der **einen benannten Soft-Ausnahme** (fehlende Mess-Einrichtung → Warnung-in-xlsx-
Pfad; deckt sich mit der stehenden allow_failure-Doktrin ZELLE=Warnung/JOB=rot und dem
PMC-Fallback 5/2/1).

---

### KON28-03 — F11 (ZAHL) ENTSCHIEDEN: DYNAMISCH NACH PLANER/XML, MAXIMAL 32

**Owner verbatim:**

> *„Ja es kommt eh darauf an, **was der Planer aufgrund der XML Einstellung fordert**, aber es
> sind **maximal 32**. Dazu muss man jeweils die **Achsen-Kategorien und alle einzelnen Achsen
> jeder Kategorie verstehen und simulation planen lassen**."*

    PRUEFDOCK-ANZAHL:  dynamisch, vom Planer aus der XML gefordert -- MAXIMAL 32.
    Das Verstaendnis (welche Kategorie, welche Achsen) liefert die PLANUNGS-SIMULATION (S-19).

**Konsequenzen:**
* Der Zahlen-Widerspruch **Dock-Obergrenze 32 (XML-Default) vs. Q6-MaxN 8** (`synthese_matrix.hpp:33-51`)
  ist entschieden: **32 ist das Maximum** — die Q6-MaxN-8 ist zu korrigieren (Bau-Posten, klein).
* Beobachtung (keine Festlegung): **32 Docks maximal = 32 Mess-System-Permutationen** (KON25-03) —
  ob das dieselbe Größe ist, klärt E-F3b (läuft).
* Die „gerade Anzahl"-Invariante (Z. 35020) bleibt der letzte offene F11-Teil — E-F3b untersucht
  die 6er-Zählung am `steuer_dock` und liefert die Grundlage.
