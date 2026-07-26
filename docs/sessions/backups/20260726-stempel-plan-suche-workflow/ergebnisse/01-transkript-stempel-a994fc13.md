I have the complete chain. Here is the finding.

---

## BEFUND: Das Stempel-/Versionierungs-Schema ist original geplant — wortgenaue Quellen, chronologisch

Die Owner-Worte aus Q-A (26.07.) sind die **Rückverweis-Zusammenfassung** eines Schemas, das in **vier** vorausgehenden User-Direktiven wörtlich festgelegt wurde. Reihenfolge = Session-Index der Transkripte (`transkript-NN`) bzw. `verlauf-NN`. Jede Fundstelle existiert doppelt: als Transkript-Extrakt (`.../20260726-kontext-neugruendung-workflow/ergebnisse/`) und als Plaintext (`.../20260726-session-plaintext-verlauf/`).

### 1. KEIMZELLE — §-Caching-Einschub „Voraussetzung für golden N" (frühestes)
Quellen: `20260726-kontext-neugruendung-workflow/ergebnisse/27-transkript-20-ac0f3b6a.md:13` (Kürzung, „A5") · wörtlich vollständig in `20260726-session-plaintext-verlauf/verlauf-20.txt:1209`
> „…dass die CI erkennt, ob eine Organ-Achse sich bezüglich eines Achsen-Algorithmus geändert hat, sodass nur Binaries im Baum neu gebaut werden, die das bezüglich er Algorithmus Versionierung betrifft. **Jedes Binary trägt also je Organ-Achse ein Listing mit welchem Algorithmus und Algorithmus-Version sie ausgestattet wurde**… Eine Änderung auf der CEB, welche alle Tier-Binaries betrifft führt zur vollständigen Rekompilation…"

### 2. §43 — „Standard der Deklaration": Stempel IN die Binary, string_view-Arrays je Achse
Quellen: `.../ergebnisse/30-transkript-22-a56ae5c7.md:37` · wörtlich `verlauf-23.txt:151`
> „Bitte erweitere den Standard der Deklaration einer [d,e,f][g,h,i]Tier-Binary… derart, dass **jede Achse den durch sie gewählten Algorithmus… als string_view in die Tier-binary zur Versionierung einkompiliert**… Die Tier-Binaries haben ihren string_view Versionierungs-Stempel über die [d,e,f][g,h,i] Kombination **in 2 verschiedenen String_view Zeilen, eine für System-Achsen und eine für Organ-Achsen Algorithmus-Versionen**… auch [die CEB] hat einen string_view für ihre [a,b,c] Mess-Achsen-Version. Natürlich braucht jede Achsen Version (Mess/System/Organ) jeweils auch die Zuordnung der Achsen-Beschreibung und des gewählten Algorithmus der Haupt-Achse…"

Manager-Verdichtung ebd. `:70` (§43/§43.b): „Stempel **in** die Binary (selbst-identifizierend), **pro Achse zuordenbar** (Achse→Algorithmus→Version). Tier = 2 string_view-Zeilen (System [d,e,f] / Organ [g,h,i]), CEB = 1 Mess-Achsen-Zeile, Planer = Selbst-Version + ISA/OS. X.Y.Z gilt je Achsen-Algorithmus einzeln."

### 3. §58 — DIE detaillierteste Original-Festlegung (deckt Q-A fast wörtlich)
Quellen: `.../ergebnisse/37-transkript-24-a0020951.md:89` · wörtlich `verlauf-24.txt:1065`
> „…dass **der Planer einen eigenen Versions-Stempel X.Y.Z bekommt**, ein jedes CEB hat je einkompilierter Mess-Achse[a,b,c]… **eine eigene Array Versionierung [Xa.Ya.Za,Xb.Yb.Zb,Xc.Yc.Zc] und es gibt keine Gesamt-Versionierung für ein CEB. Eine Tier-Binary hat auch keine Gesamt-Versionierung, aber zwei Array Versionierungen je für die System-Achse und die Organ-Achse SEPARAT**… Daher: **Die Binary-Stempel tragen nur Haupt-Achsen**, weil die dynamischen Laufzeit-Parameter der Unter-Achsen dynamisch zur Laufzeit durch sie hindurchfließen…"

Zugehöriger Einbau-Nachtrag (Planer bekommt eigenen Tag): `.../ergebnisse/37-transkript-24-a0020951.md:89` selbe Direktive; Fixpunkt „Planer = EINZIGE Binary mit einzelnem X.Y.Z".

### 4. §58-Recall — Owner bestätigt es als „schon geplant", nennt Bestehendes als Regression
Quellen: `.../ergebnisse/38-transkript-28-ae354b36.md:16` · wörtlich `verlauf-28.txt:1397`
> „Gut, das mit den Stempeln und der Versionierung hatten wir eigentlich geklärt, dass **jede Haupt-Achse ihren gewählten compile time Algorithmus auf dem Tier-Binary mit X.Y.Z Version benennt**, die gewählt wurde. Dasselbe gilt für alle Haupt-Mess-Achsen für den Planer an die CEB… **Der Planer selbst ist die einzige Binary mit einem schnöden X.Y.Z einzelnen Versionierungstag.** Bitte suche das mit einem Explore Agenten aus Ledger und Diplomarbeit-TODOs heraus, das ist schon geplant und dokumentiert. Aber die beschriebene Versionierungsform ist eine Regression…"

**Autoritative Konsolidierung** (Manager/Explore, kein User-Zitat) `.../ergebnisse/38-transkript-28-ae354b36.md:78`: „**§58-V ist die autoritative Versionierungsform (Explore-Stempel58, verankert super `c4b2cc9`).** Tier = ZWEI separate Arrays (System/Organ), keine Gesamt-Version; CEB = ARRAY je einkompilierter Mess-Haupt-Achse; Planer = EINZIGE Binary mit einzelnem X.Y.Z; X.Y=Feature/Z=Debug je Algorithmus; dritter Tier-Stempel = Merge-Kombination (§59-C)."

---

## Zum Fingerprint-/SHA512-Overlay (ergänzendes Original)
`.../ergebnisse/34-transkript-27-afa04181.md:38` (D13, wörtlich; = `03-user-worte-a944a455.md` Punkt C2):
> „…eine constexpr Funktion als separates Versionierungsinterface auf jedem CEB und Tier-Binary… welches einen **SHA512 über die String-Arrays der bisher existierenden Stempel-Zeilen** bildet… Also bekommen alle binaries zusätzlich eine WEITERE Stempel Zeile mit dem Fingerprint SHA512 über ihre Eigenschaften, sodass er zur compile time berechnet ist…"

---

## KOMPLEX-ACHSE / command pattern / „gemeinsamer komplexer Stempel" — WICHTIGE Einschränkung
Dieser Teilaspekt ist **NICHT wortgleich vorgeplant**. Der einzige verbatim-Beleg des Satzes „Komplex-Achse … formt einen gemeinsamen komplexen Stempel" ist **die Q-A selbst** (`verlauf-32.txt:896`). Vorgeplant war nur das allgemeine **Command-Pattern-Freigabemodell der Meta-Meta-Achsen** (nicht der Einzel-Stempel):
- `.../ergebnisse/17-plaene-ledger-a7b65f9d.md:92` (§54-T): „**Meta-Meta-Achsen per Command-Pattern**".
- `verlauf-27.txt:445`: „Der Binary-Stempel trägt die Meta-Meta-Belegung ohnehin (**dein Command-Pattern-Freigabemodell**)…".
- Offene Rückfragen genau dazu (also noch NICHT entschieden vor Q-A) in `verlauf-32.txt:410-411` (Q-A/Q-B) und `verlauf-31.txt:1479` / `verlauf-32.txt:54` (Q-3 „Stempel-Sichtbarkeit der Komplex-Haupt-Achse", Optionen S1/S2/S3).

Folgerung: Q-A vom 26.07. **verfestigt** für die Komplex-Achse erstmals die Regel „**eine** indirekte Identität / **ein gemeinsamer** Stempel über die gewrappten echten Haupt-Achsen (command pattern)" — sie beantwortet die vorher offene Frage 32:410 („trägt die Komplex-Achse **einen** Stempel oder die N Stempel ihrer Glieder?"). Der Achsen-Typ-/Haupt-Achsen-/Algorithmus-X.Y.Z-Teil hingegen ist wortgenau vorgeplant (§43 → §58 → §58-V).

---

## Kompakte Chronologie (Quelle + Zeile)
1. `verlauf-20.txt:1209` = `ergebnisse/27-transkript-20-ac0f3b6a.md:13` — Keimzelle „je Organ-Achse Algorithmus + Algorithmus-Version".
2. `verlauf-23.txt:151` = `ergebnisse/30-transkript-22-a56ae5c7.md:37` — §43: string_view-Stempel IN die Binary; Tier 2 Zeilen System/Organ; CEB Mess-Zeile.
3. `verlauf-24.txt:1065` = `ergebnisse/37-transkript-24-a0020951.md:89` — §58: Planer eigener X.Y.Z; CEB-Array keine Gesamt-Version; Tier 2 separate Arrays; „Binary-Stempel tragen nur Haupt-Achsen".
4. `verlauf-28.txt:1397` = `ergebnisse/38-transkript-28-ae354b36.md:16` — §58-Recall: „schon geplant"; Planer einzige Binary mit einzelnem X.Y.Z; Bestehendes = Regression. Konsolidiert als §58-V (super-Commit `c4b2cc9`).
5. `verlauf-32.txt:896` — Q-A (26.07.): Rückverweis-Zusammenfassung + **neu** die Komplex-Achsen-Einzelstempel-Regel (command pattern). Command-Pattern-Rahmen vorgeplant in `ergebnisse/17-plaene-ledger-a7b65f9d.md:92` (§54-T) und `verlauf-27.txt:445`.