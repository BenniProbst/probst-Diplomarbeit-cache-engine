# PAUSE 11.08.2026, NACHT 7 — ABBRUCHSICHER

> **Stand:** Di 11.08.2026, spät · **F1 in 3 Tagen** (Fr 14.08.) · **Abgabe in 35 Tagen**
> **Einstieg für die Nachfolge:** Ledger-Kopf lesen — dort stehen **KON9, KON8-12, KON8, KON7,
> KON6** übereinander. KON9 (368 Z.) ist die geltende Fassung der Stempel-Architektur.

---

## IN EINEM SATZ

Die Stempel-Architektur ist im Owner-Dialog dieser Nacht an sechs Stellen geschärft worden — die
wichtigste: **der Stempel trägt fünf Rollen, nicht eine** (Identität · Cache-Schlüssel ·
Lager-Schlüssel · Skip-Marke · Einordnung), und vier davon sind im Code bereits durchgesetzt.

---

## 1. WAS GELANDET IST

| SHA | Repo | Gegenstand |
|---|---|---|
| `5686a50e` | super | **KON8-12** — Teilmengen-Prüfung gilt überall, der Vertrag nur einmal (76 Z.) |
| `8205e980` | super | **KON9** — die Stempel-Architektur konsolidiert (368 Z., zwölf Abschnitte) |

Ledger: 20.354 → 20.430 → **20.798 Zeilen**. Beide Nachträge auf **beiden** Remotes.

---

## 2. 🔴 DIE ZWEI LAUFENDEN EXPLORES — WIE MAN SIE BIRGT

**Sie laufen weiter, auch wenn diese Session endet.** Ihre Ergebnisse liegen **persistent** im
Journal — das ist der Unterschied zum verlorenen 15-Pakete-Designplan, dessen Ergebnis nur im
flüchtigen Task-Output lag und heute nirgends mehr auffindbar ist (0 Treffer über 180 Outputs).

```
BASIS  ~/.claude/projects/-home-comdare/5a19728e-f6e1-4736-a246-e3fda9ac35a1/subagents/workflows/

  wf_296a2353-2d6/journal.jsonl   STEMPEL-EXPLORE   7 Schnitte + Verify + Synthese
  wf_e9b2cd97-d5f/journal.jsonl   CI-EXPLORE        5 Schnitte + Verify + Synthese
```

**Stand bei Pausenbeginn** (aus dem Journal gemessen, nicht geschätzt):
* Stempel-Explore: **45 Agenten gestartet, 29 fertig** — in der Verify-Phase
* CI-Explore: **5 Agenten gestartet, 0 fertig** — in der Explore-Phase

**Ernte-Anweisung für die Nachfolge:**
1. `journal.jsonl` lesen — **es ist die Wahrheit**, nicht der Task-Output. Jede `"type":"result"`-
   Zeile trägt den Rückgabewert eines Agenten.
2. Die Skripte liegen dauerhaft: `~/.claude/jobs/5a19728e/tmp/wf_stempel_explore.js` und
   `wf_ci_explore.js`. Resume geht mit
   `Workflow({scriptPath: …, resumeFromRunId: "wf_296a2353-2d6"})` — nur in **derselben** Session.
3. **Ein leeres Ergebnis ist kein Beweis für einen leeren Lauf.** Vor jeder Aussage über einen
   Workflow zuerst das Journal ansehen.

### Was die Explores suchen

| Explore | Schnitte |
|---|---|
| **Stempel** | Selbstkompilations-Entwurf · drei Grammatiken je Phasigkeit · mp11/concepts · CEB-Laufzeit-Hardware-Analyse · Hybrid als Multiplexer · **Interface-Arten und Versionierungs-Punkte** · Owner-Antworten dieses Kontextes vollständig |
| **CI** | Owner-Stelle „Mini-Pipeline je Träger" · Stempel als Cache-Schlüssel · Buildsystem-Cache auf NAS + Lager-Einsortierung · CI-IST-Struktur mit Nennern · **harte Blocker für Bau und Wartung** |

---

## 3. DIE OWNER-FESTLEGUNGEN DIESER NACHT

Vollständig mit Zitat und Beleg in **KON9** (Ledger-Kopf). Kurzform:

### 3.1 Ort und Zeit sind zwei Ordnungen

    ORT   (Träger-Ordnung, Vertragskomplex)   Planer ──▶ CEB ──▶ HYBRID ──▶ Tier
    ZEIT  (Erzeugung)  Tier bauen ──▶ Einzelmessung ──▶ Hybrid erzeugen ──▶ einschieben

**Beides gilt zugleich.** Ich hatte daraus geschlossen, der Hybrid stehe *nicht* vor dem Tier —
falsch, und der zweite Beleg derselben Fehlerklasse an einem Tag (nach „Lager-Ordnung =
Stufen-Ordnung"). Bei jeder Reihenfolge-Aussage über dieses System ist zu benennen, **welche
Ordnung** gemeint ist; es gibt mindestens vier, und sie stimmen nicht überein.

### 3.2 🔴 Der Stempel trägt fünf Rollen

    (1) IDENTITÄT        Fläche 2 -- was die Binary IST
    (2) CACHE-SCHLÜSSEL  neu gebaut wird nur, was sich ändert
    (3) LAGER-SCHLÜSSEL  Einordnung, unter Gattung und Genus
    (4) SKIP-MARKE       für Messdaten
    (5) EINORDNUNG       die zentrale Kurzform im Gesamtsystem

Owner: *„ohne ihn geht nichts."* **Vier der fünf sind im Code durchgesetzt** —
`lager_baum_writer.hpp:50-53` wörtlich: *„Skip-Marke, minio-Key, Bestandslog-`key_sha512` und
Baum-Blatt sind DASSELBE Preimage."* Offen ist allein Rolle (2), der Buildsystem-Cache auf NAS.

**Die Fehlerklasse, die daraus folgt:** eine Implementierungsänderung **ohne `X.Y.Z`-Bump** heißt,
das Binary wird **nicht neu gebaut**. Der Lauf ist dann **schneller und falsch** und sieht aus wie
ein Cache-Treffer. Braucht ein **Werkzeug**, nicht Disziplin — Posten **#90**.

### 3.3 Die weiteren vier

* **Der Hybrid ist ein Genus mit Fläche 2** — eigene Achsen im Stempel, dazu *zur Laufzeitanfrage*
  durchgereicht: die Eigenschaften seiner Parameterfunktionen und die Stempel seiner Tier-Binaries.
  Er ist **transparent**, keine zweite Freigabe-Stufe; die eine Bindung ist das **Genus-Interface**.
* **Drei Grammatiken, geschnitten nach Phasigkeit** — zweiphasig eine, dreiphasig und vierphasig je
  eine eigene. Nicht nach den heutigen Dateien.
* **Die Ordnungs-Relation ist bestätigt** (`x512{f.vl}` ⊆ `x512{f.vl.bw}`) und gilt über dem
  **gesamten Hardware-Satz eines Rechners**. Daraus: jeder Achsen-Algorithmus trägt einen eigenen
  Hardware-Spezifikations-Stempel `X.Y.Z` in **voller System-Achsen-Syntax und -Semantik**.
* **Die Filterkette IST der Selbstkompilations-Mechanismus** — C++23-concept aus mp11, Vertrag
  einer freigebenden Seite gegen ein Compile-Ziel je Phasigkeit. *„nur bestimmte concept builds zur
  Laufzeit eines niederen Trägers dürfen den compile eines höheren Trägers bilden."*

---

## 4. DER SELBSTKOMPILATIONS-ENTWURF — GEFUNDEN

Owner: *„Du hattest das schon entworfen."* Der Begriff **„Selbstkompilation" existiert nirgends**
(0 von 20.798 Ledger-Zeilen, 0 Memory-Dateien; Gegenproben: Stempel 341/40, CEB 671, Hybrid 321).
Die **Sache** steht seit dem 09.08. als **Director/Builder-Muster mit Command-Objekten**:

> *„nur C++ und cmake erlaubt, es gibt ja keine skripte. Der Planer fordert auch in der
> Testsituation dummy commands als **director** von der CEB an."*

**Drei von vier Bausteinen existieren am Objekt** (ce `670483c0`):

| Baustein | Ort | Zustand |
|---|---|---|
| Command als C++23-concept | `topics/axis_command_base.hpp:20` — `concept AxisCommand` | **existiert** |
| Compile-time-Auskunft | `AxisLimitations<Axis>`: `observable` · `original_module` · `compiler` | **existiert** |
| Laufzeit-Pendant | `anatomy/resource_controllable_tier.hpp:63` — `tier_query_resource_caps()` | **existiert** |
| **Die Kette** | mp11-Liste, Phasigkeit, Schritt Freigabe → **Compile** | **fehlt** |

**Die präzise Lücke:** die Naht endet heute bei `tier_apply_resource_control` — sie **steuert eine
bestehende Binary**. Sie soll **den Compile einer neuen bilden**.

Nebenbefund: `builder/commands/` trägt 18 Dateien, aber alles **Mess**-Commands; `i_command.hpp` ist
seit 06.07. **geparkt** (`#267`, Laufzeit-`virtual`) mit dem Vermerk *„Nachfolger der
Command-Semantik = compile-time `AxisCommand`"*. Die Umstellung war angefangen und ist hier
stehengeblieben.

---

## 5. DIE OFFENEN PUNKTE, NACH DRINGLICHKEIT

### Wartet auf die Explores
1. **KON9-Bestandsteil** — der Nachtrag ist gelandet, aber sein IST-Teil ist dünn. Die Explores
   liefern ihn nach.
2. **Der Selbstkompilations-Entwurf im Volltext** — Schnitt 1 des Stempel-Explores.
3. **Die harten Blocker für Bau und Wartung** — Schnitt 5 des CI-Explores. Owner: *„die CI Struktur
   als Gerüst […] ist noch nicht fertig und daher gibt es harte Blocker."*

### Owner-Entscheid, blockiert den Bau
4. **Syntax und Semantik je Achsen-Kategorie** über `c` hinaus. Owner: *„Das ist Pflicht und Basis
   für die Abgabe."* Ohne sie ist die Ordnungs-Relation nicht baubar.
5. **Meta-Meta-Achsen von System und Organ** — ausdrücklich „zu recherchieren" (KON8-12).

### Bau, nach 4 und 5
6. Die drei Grammatiken je Phasigkeit · die Ordnungs-Relation als `constexpr` · die
   Hybrid-Fläche-2-Durchreichung · die **Bump-Pflicht-Wache** (#90).

### Betrieb, unabhängig
7. **#80** coverage-guard deterministisch rot (4 ISA = Sollverhalten + 1 Prüfling-Fixture) ·
   **#84** Vorbestands-Rot · **#83** `lint:format` ohne lokale Deckung · **#89** 13 Shell-Testproben
   (7967 Z.) · **#82** überlebender Mutant · Gitlink-Bump super→ce auf `670483c0` · main-FF beider
   Repos · **#21** `##25` DURCHSTICH ohne Besitzer — **die F1-Lieferung selbst**.

### Reihenfolge (Owner F5/F6)
```
1. Neu gründen                      ERLEDIGT (4 goal-Dokumente + 6 Sessions vom 11.08.)
2. Stempel zuende planen + chatten  LÄUFT    (Architektur steht, Designplan folgt)
3. Pipeline debuggen                OFFEN
4. Konsolidierung (#88)             OFFEN
```

---

## 6. BEFUND: DER 15-PAKETE-DESIGNPLAN IST VERLOREN

`/usr/bin/grep -l 'ST-00\|ST-14\|ST-08'` über **alle 180** Workflow-Outputs vom 11.08. → **0
Treffer**; über `docs/` → **0 Treffer**. Erhalten sind nur die **Paketnamen** und die **vier
Nachbesserungs-Befunde** in `20260811-KONTEXTUEBERGABE-nacht-7-…md` §4.

**Kein Verlust in der Sache:** der Plan war zweimal als NACHBESSERN beurteilt, seine
Verifikationsbasis war 14 Commits alt, und die Architektur hat sich seitdem an sechs Stellen
geschärft. **Neuschnitt gegen den heutigen Stand statt Nachbesserung eines verlorenen Dokuments.**

**Die Lehre, die bleibt:** ein Workflow-Ergebnis, das nicht innerhalb derselben Session in ein
Repo-Dokument oder den Ledger wandert, ist **weg**. Das Journal überlebt, der Task-Output nicht.

---

## 7. BETRIEBSSTAND

```
super  development = 8205e980   (beide Remotes)
ce     development = 670483c0
Platte 20 G frei von 251 G (92 % voll)

Worktrees:   wt-super-landung  5686a50e→8205e980  sauber
             wt-super-warn     afa5815a           sauber
             wt-super-d3naht   e6d90232           1 Datei dirty (Submodul-Drift, bekannt)
             wt-ce-warn-libs   670483c0           sauber   <- der aktuelle ce-Messbaum
             wt-ce-stagetopo   68fbd930           sauber
             wt-ce-messvisitor 31240ac5           sauber
             wt-ce-d37b        346b6da9           sauber   <- 14 Commits alt, NICHT als Basis nehmen
             Projekte          c62c888            sauber   <- Arbeitsweise v3.2 lebt hier

Gitlink super→ce steht auf e114cabd -- der Bump auf 670483c0 ist OFFEN
                                       (setzt grüne ce-Pipeline voraus)
Zwei Explores laufen im Hintergrund (§2).
```

**Werkzeuge, die weiterleben:** `~/.claude/jobs/5a19728e/tmp/pipeline_debug.py` (Pipeline-Status,
PAT blind aus dem Vault) · `job_trace.py` · `ce_pipeline_wache.py` · Symlink
`~/.local/bin/clang-format` → 22.1.8 · die zwei Workflow-Skripte aus §2.

---

## 8. WAS ZUERST ZU TUN IST, WENN ES WEITERGEHT

1. **Die zwei Journals ernten** (§2) — sie sind die Wahrheit über die Explores.
2. **KON9 um den Bestandsteil ergänzen** und als KON10 nachtragen; nichts überschreiben.
3. **Die zwei Owner-Entscheide vorlegen** (§5.4, §5.5) — sie blockieren den Bau, nicht die Planung.
4. **Designplan neu schneiden** gegen den heutigen Stand, mit den vier Nachbesserungs-Befunden
   der Vorfassung als Prüfliste (Basis-Angleich zuerst · Kalender · W1-Kapazität · kein
   Layout-7-Bump).
5. **Dann Pipeline-Debug, dann Konsolidierung (#88)** — die vom Owner gesetzte Reihenfolge.

---

*Erhoben 11.08.2026 nachts. Jede Zahl am Objekt gemessen oder mit Quelle. Wo eine frühere Aussage
von mir widerlegt wurde, steht die Widerlegung dabei — der Bestand an Irrtümern ist selbst ein
Datum.*
