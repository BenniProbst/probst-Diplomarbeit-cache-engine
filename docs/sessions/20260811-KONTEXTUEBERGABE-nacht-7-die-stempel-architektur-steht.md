# KONTEXTÜBERGABE 11.08.2026, NACHT 7 — DIE STEMPEL-ARCHITEKTUR STEHT

> **Stand:** Di 11.08.2026, nachts · **F1 in 3 Tagen** (Fr 14.08.) · **Abgabe in 35 Tagen**
> **Für die Nachfolge:** lies **zuerst** den Ledger-Kopf — dort stehen **KON8, KON7, KON6**
> übereinander (275 + 221 + 269 Zeilen). Dieses Dokument ist die Navigation dazu, nicht ihr Ersatz.

---

## IN EINEM SATZ

Die Stempel-Architektur ist vom Owner in einem langen Dialog **Satz für Satz abgenommen** worden —
zwei Flächen, vier Träger, ein Vertrag, drei Schichten —, alle vier Restpakete sind gelandet, und
was jetzt fehlt, ist **nicht mehr Klärung, sondern Bau**.

---

## 1. DIE ARCHITEKTUR IN ZWÖLF ZEILEN

    FLÄCHE 1 = VERTRAG/FUNKTION     abstract factory (Laufzeit)  -- WAS die Binary KANN
    FLÄCHE 2 = IDENTITÄT            compile time factory         -- WAS die Binary IST

    Planer ──▶ CEB ──┬──▶ Tier          Tier und Hybrid sind GLEICHAUF
                     └──▶ Hybrid

    MESS   DREIPHASIG   Planer gibt frei → CEB baut ein → Tier baut ein   ⇒ EIN VERTRAG
    SYSTEM ZWEIPHASIG   CEB gibt frei → Tier baut ein                     ⇒ kein Vertrag
    ORGAN  ZWEIPHASIG   CEB gibt frei (über die System-Achse) → Tier      ⇒ kein Vertrag

    Zeilen je Träger:   Planer 2 · CEB 3 · Tier 4 · Hybrid 4 + Bereichskarte
    Prüfung:            MIN(Vertrag) ⊆ implementiert ⊆ freigegeben
    Der Stempel FÄLLT AN aus der B+-Baum-Materialisierung -- er wird nicht geschrieben.

**Vollständig mit allen Belegen: Ledger KON7 (10 Abschnitte) und KON8 (11 Abschnitte).**

---

## 2. WAS HEUTE GELANDET IST

| Repo | SHA | Gegenstand |
|---|---|---|
| super | `e6d90232` | P-LIZENZ · Pipeline **15674, 33/33 grün** |
| ce | `d79bbcdd` | Sammellandung P-WARN + P-D37B · 15675, 23/24 |
| super | `d359920e` | Zwischenstandsdoku (306 Z.) |
| super | `75505b9d` | R3 — D3-7b super-Hälfte |
| **ce** | **`670483c0`** | R5 — r7-Wachen-Divergenz (#79) |
| super | `cf39dc19` | R4 — Wachen-Parität (#77) |
| super | `9f8e2be8` | R2 — CI-Invarianten-Wache |
| super | `02912f52` | Ledger KON6 + KON7 (490 Z.) |
| super | *dieser Commit* | Ledger KON8 (275 Z.) + diese Übergabe |

**Restlandung 4 von 4.** R1-E18SNAP wurde **neu geschnitten**, nicht wie vorgelegt gelandet —
Wirksamkeit war null, der Patch nicht mehr anwendbar, und er hätte zwei gelandete Pakete
zurückgedreht.

---

## 3. DIE FÜNF WORKFLOWS DIESES KONTEXTES

| Run | Gegenstand | Ergebnis |
|---|---|---|
| `wf_b7836b08-f32` | W0b: 5 Pakete bauen + Dual-Review | 15/15 · **0 beidseitig landefähig** |
| `wf_a37d9f8e-c4f` | Heilen + sequentiell landen | 5/5 · 2 Landungen |
| `wf_8e1ff4b7-45e` | Planabgrenzung + Review der 5 Restpakete | 6/6 · 3 landefähig, 2 blockiert |
| `wf_1555a7af-a26` | Historische Plan-Auswertung, 10 Wochen | 4/4 · **78 Chronologie-Einträge, 16 verworfen** |
| `wf_b5f7f3a5-bfd` | Stempel-Explore + Designplan + 2 Lenses | 13/13 · **248 Befunde, 15 Pakete** |
| `wf_1d72821e-0d9` | Restlandung R5/R4/R2 + R1 heilen | 4/4 · **alle gelandet** |
| `wf_283f202c-0ba` | Flag-Katalog Organ/Mess, 10 Wochen | 4/4 · **173 Flag-Fundstellen** |

**Alle Rohergebnisse liegen unter** `/tmp/claude-1001/-home-comdare/…/tasks/w*.output`
(je 70–480 KB). **Sie sind flüchtig** — was daraus zählt, steht in KON6/KON7/KON8.

---

## 4. DER STEMPEL-DESIGNPLAN: 15 PAKETE, ZWEIMAL NACHBESSERN

Beide adversarischen Lenses unabhängig: *„trägt in seiner ARCHITEKTUR und fällt in seiner
BELEGLAGE"* / *„als DESIGN gut, als PLAN unverankert"*.

**Die vier härtesten Befunde — sie sind die Nachbesserungs-Liste:**
1. **Verifikationsbasis 14 Commits alt** (`wt-ce-d37b @ 346b6da9`, 0 voraus / 14 zurück) ⇒ alle
   tragenden Zahlen stichtagsfalsch. **Erstes Paket muss ST-00a Basis-Angleich sein.**
2. **Kalenderfehler:** der Plan schreibt *„Fr 15.08."* — das ist ein **Samstag**.
3. **W1-Kapazität gesprengt:** 58 h in eine Woche, die laut Wellenplan §12.4 schon **99 h Band A**
   trägt und als *„ENGPASS DES GESAMTEN PLANS"* geführt wird.
4. **ST-08 bumpt auf Layout 7**, das `anatomy_module_abi_v1_decl.hpp:293` per `static_assert`
   ausdrücklich als **verboten** festschreibt.

**Die 15 Pakete (12 bestandsneutral):** ST-00 Owner-Vorlage · ST-01 CT-Error-Wachen ·
ST-02 Transpositions-Sperre · ST-03 Glied[6]-Köder · ST-04 Planer-SHA · ST-05 SOTA-Emitter ·
ST-06 CLI-Sichtbarkeit · ST-07 Genus-Interface · **ST-08 POD-Reorder (invasiv)** ·
**ST-09 Invalidierungs-Bündel (invasiv)** · ST-10 Genus-Breite (20 h) ·
**ST-11 selektiver Rebuild (invasiv)** · ST-12 Hybrid-Tier · ST-13 Benennungs-Umzug ·
ST-14 F2-Freeze-Abnahme.

---

## 5. 🔴 EINE LEHRE ÜBER DIE LENSES — sie gilt für jeden Nachfolger

Lens 1 meldete *„`bvset_ist_teilmenge` existiert nicht, 0 Treffer baumweit"*.
**Ich habe das ungeprüft in Task #82 als Korrektur übernommen — und es war falsch.**

Am heutigen Stand existiert die Funktion: `bvset_teilmenge.hpp:165`, aufgerufen in
`build_orchestrator.hpp:444`. Der Lens hatte auf der **14 Commits alten Basis** gemessen, wo die
Datei nicht existiert.

⇒ **ALLE „existiert nicht"-Aussagen dieses Lens sind systematisch verdächtig.** Jede einzeln gegen
`origin/development` nachmessen, bevor sie in einen Bauauftrag wandert.
⇒ Und bei mir: **Prüfung 5 verletzt** — *„prüfe ich die neue Aussage genauso hart wie die alte?"*
13 von 40 Fällen dieser Klasse sind im Projekt belegt; das ist der 14.

---

## 6. VIER ENTLASTUNGEN — der Bau ist billiger als angenommen

1. **golden-320 ist STEMPEL-NEUTRAL** — 0 `@`-Zeichen in 8/8 Golden-/Registry-/Profil-Dateien.
2. **KEINE laufende Mehrtageskampagne** — seit 25.06. nur 15-min-PMC-Smoke.
3. **Es wurde NIE eine Flotte gebaut** (Owner) — jede „das invalidiert die Flotte"-Rechnung ist
   gegenstandslos. **Identitäts-Umbauten sind HEUTE kostenlos**, ab Bau-Trigger Mi 26.08. teuer.
4. **`test:coverage-guard` ist stempelfrei rot** (ISA/Host) — *„alle Blocker klemmen am Stempel"*
   trägt als **Policy** voll, als **technische** Aussage nicht.

---

## 7. ZAHLEN, DIE NICHT STIMMEN

* **153** algo_version-Konstanten: trifft **keine** von fünf Messungen (104/115/124/131 je Muster
  und Scope). Auch die Owner-Zahl „138 Stellen" (07.08.) nicht. Größenordnung ja, Nenner nein.
* **28** `\InputIfFileExists`-Ziele (Wellenplan ##58): gemessen im echten Klon **13**.
* **Der IST-Flag-Bestand:** alle **137** ce-eigenen Literale (123 Organ + 7 System + 6 Mess +
  1 Planer) tragen genau `c` — und sonst nichts.

---

## 8. DIE OFFENEN POSTEN, nach Dringlichkeit

### Vor F1 (Fr 14.08.)
* **#86 Stempel-Mechanik** — der Hauptstrang. Architektur steht (KON7/KON8), Designplan braucht
  eine Nachbesserungsrunde.
* **#21 ##25 DURCHSTICH** — die F1-Lieferung selbst.

### Vor F2 (Fr 21.08. = IDENTITÄTS-FREEZE) — identitätswirksam
* **#87** Funktions-Variablen in Stufigkeits-Ordnung
* **#78** Stempel-Reihenfolge (Ebene 1 **darf nicht** landen — byte-wirkungslos, zweimal per
  SHA-256 belegt)
* **#67** Benennung: vier Familien, 142 Include-Kanten
* **#68** selektiver Rebuild / Additivität

### Flanke, parallelisierbar
* **#80** coverage-guard: 4 ISA (Sollverhalten) + 1 Prüfling-Fixture (echter Befund)
* **#82** überlebender Mutant — **beide Korrekturen im Posten lesen**, die zweite war meine falsche
* **#84** Vorbestands-Rot: 2 Tests + 1 Flattertest
* **#83** `lint:format` ohne Repo-Werkzeug (Symlink gesetzt, Skript fehlt)
* **#89** 13 Shell-Testproben, 7967 Zeilen — **stehende Regression seit 09.08.**
* **#88** Konsolidierungs-Architektur, 4 Repos, ~20.000 Abhängigkeiten davon **64 stille**

---

## 9. WAS ALS NÄCHSTES ZU TUN IST

1. **Designplan nachbessern** — Basis-Angleich zuerst, dann alle Zahlen neu erheben, Kalender und
   Wellen-Kapazität gegen den Wellenplan verankern.
2. **Dann bauen**, in der Owner-Reihenfolge: **erst laute Compile-Fehler, dann verschieben.**
3. **#88 Konsolidierungs-Explore** — noch nicht gestartet.
4. **Verify wiederholen** (#81) über die heute gelandeten Stände.
5. **main-FF beider Repos** — vor dem FF die Hygiene-Wache über den **kumulativen** Bereich
   (heute gemessen: 92 Commits, 15.114 Zeilen, 0 Verstöße).

---

## 10. BETRIEBSSTAND

    super  origin/development = 02912f52 (+ dieser Commit)
    ce     origin/development = 670483c0
    Platte 20 G frei · alle Worktrees sauber · keine laufenden Workflows
    Gitlink super→ce steht auf e114cabd -- der Bump auf 670483c0 ist OFFEN
                                            (setzt grüne ce-Pipeline voraus)

**Werkzeuge, die diese Session gebaut hat und die weiterleben:**
`~/.claude/jobs/5a19728e/tmp/pipeline_debug.py` (Pipeline-Status, PAT blind) ·
`job_trace.py` (Job-Traces) · `ce_pipeline_wache.py` (Monitor, meldet **jeden** terminalen Zustand) ·
Symlink `~/.local/bin/clang-format` → 22.1.8.

---

*Erhoben 11.08.2026. Jede Zahl am Objekt gemessen oder mit Quelle. Wo eine frühere Aussage von mir
widerlegt wurde, steht die Widerlegung dabei — der Bestand an Irrtümern ist selbst ein Datum.*
