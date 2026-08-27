# SESSION-ZWISCHENSTAND 27.08.2026 — Architektur und aktuelles Geschehen (VERBATIM)

Owner-Order 27.08.2026 (~12:1xZ): "Bitte beschreibe in deinen eigenen Worten ausführlich die Architektur und was
jetzt passiert." — danach: "Bitte stelle diese Erklärung exakt verbatim in eine Zwischen Session".
Dieses Dokument ist die WORTGLEICHE Abschrift der Lead-Antwort (Session 5a19728e, Fable 5), nichts gekürzt,
nichts transliteriert. Stand der Aussagen: 27.08.2026 ~12:1xZ (Lande-Zug wf_027ac946 gerade gestartet; D1/V-A
prod2 terminal ~12:05Z). Zahlen darin sind Lead-Formulierungen aus dem Gedächtnis-/Objekt-Stand jenes Moments,
keine frischen Messungen; Beweise liegen in den je genannten Beweisorten unter ~/backups-workflow/.

---

# Architektur und aktuelles Geschehen — in meinen Worten

## 1. Was hier gebaut wird

Das Projekt ist ein **Experiment-System für eine Cache-Engine**: ein Rahmen, der viele Varianten einer Datenstruktur-Bibliothek automatisch baut, vermisst und die Ergebnisse bis in die Diplomarbeit (LaTeX/Overleaf) durchreicht. Der Anspruch ist „honest 100 %": nichts wird geschätzt, jede Zahl im Text stammt aus einer nachvollziehbaren Messung derselben Binary, die den Text auch erzeugt.

Es leben vier Git-Repos ineinander: das **super-Repo** (die Diplomarbeit als Umbrella, GitLab-Projekt 288, Apache-lizenziert), darin als Submodule die **cache-engine** (ce, Projekt 286, das eigentliche Framework unter der restriktiven Comdare-Research-Lizenz), **prt-art** (287, ein Modul) und die **thesis** (289, der LaTeX-Text). Daneben das Cluster-Repo mit Infrastruktur und dem Vault für Zugangsdaten. Alles wird zweifach gespiegelt (GitLab im LAN als Autorität, GitHub als Sicherung), und die Doktrin sagt: `main` ist die Autorität, `development` läuft voraus, gemergt wird nur, nie rebased.

## 2. Die Achsen und der Stempel — das Herz der Identität

Eine gebaute Binary ist nicht „die Cache-Engine", sondern **ein Punkt in einem Achsenraum**. Es gibt drei Realms:

- **Organ-Achsen** (18 Kompositions-Achsen: welche Bausteine, Filter, Traversierungen, Allokatoren usw. zusammengesetzt werden). Ihr Produkt ist der Organ-Katalog: 2¹⁷ = 131 072 Kombinationen im goldenen Profil.
- **System-Achsen** unter `target_isa` (Optimierungsstufe {O2, O3}, SIMD {keine Erweiterung, AVX2}, Threads, künftig Scheduling). Sie permutieren ebenfalls — daher ×4.
- **Mess-Achsen** (was gemessen wird, mit welchen Zählern, in welchen Fenstern).

131 072 × 4 = **524 288 Tier-Binaries** (DLLs) für den Voll-Bau — das ist die Zahl, die der Planer selbst per `simulate` aus der goldenen XML errechnet, nicht ich.

Jede Binary trägt einen **Stempel** (Fingerprint), zusammengesetzt aus nummerierten Gliedern: Organ-Text, Toolchain (Compiler, CEB-Version, und seit gestern das neue Feld `vendoropt=O2`), Overlay-Quellhash, Komposit-Map, System-Suffix. Der Stempel hat fünf Rollen zugleich: er ist **Identität**, **Cache-Schlüssel**, **Lager-Schlüssel**, **Skip-Kriterium** („liegt schon, nicht neu bauen") und **Einordnung** in der Auswertung. Deshalb ist jede Änderung an einem Glied ein *Identitäts-Ereignis*: alle bisher gebauten Binaries werden ungültig. Der Owner hat das ausdrücklich so gewollt — „Invalidieren ist Ziel, kein Migrationszwang" —, aber es bedeutet, dass solche Änderungen **vor dem großen Bau** landen müssen, sonst wird eine ganze Flotte umgestempelt. Genau darum ordnen wir gerade die „Identitäts-Kette" vor den Trigger.

Die goldenen Artefakte (Achsen-Registries, golden-XMLs, CRC-Anker) sind **TABU**: sie dürfen nur mit deklariertem Beweis (SHA-Liste vorher/nachher) angefasst werden, weil an ihnen die Reproduzierbarkeit hängt.

## 3. Die Kette vom XML bis zur Messung

Eingang ist eine **Experiment-XML**. Der **Planer** liest sie, erkennt die Hardware, rechnet den Umfang (`simulate`) und **emittiert den Prozess selbst** — es gibt kein handgeschriebenes CI-YAML für die Kampagne; der Director erzeugt die Kind-Pipelines. Die Träger-Stufen sind: Planer → **CEB** (Cache-Engine-Binary, das Messsystem mit genau einem **Prüfdock**, dem bidirektionalen Vertrag zu den Tier-Binaries) → optional **Hybrid** (eine Tier-Binary, die mehrere Docks dynamisch trägt) → **Tier-Binaries**. Gebaut wird in Batches von 4 096 auf zwei Lanes (AMD auf prod1, Intel auf prod2), die Ergebnisse gehen ins **Lager** (MinIO-Objekte für Binaries, NAS für Messdaten). Am Ende steht eine xlsx-Mappe je Messreihe, aus der die LaTeX-Anhänge und Diagramme entstehen.

## 4. Wie wir arbeiten

Ich bin der orchestrierende Lead; die eigentliche Arbeit verrichten Fable-5-max-Agenten in Workflows, in der Reihenfolge Gedächtnis → Review → Explore → Design → Bau → Verify → Fix. Gebaut wird **parallel in eigenen Worktrees**, gelandet **sequentiell**, und jede Landung hat drei Stufen: Harmonisierung der Schnittstellen beim Mergen, ein **Komplex-Fix** mit einem Kombibau über vier Zellen (gcc und clang, jeweils Release und Debug, kompletter ctest), dann ein einziger Push und eine CI. Sechs Gates stehen vor jedem Push (Diff-Hygiene, Format, gitleaks mit beißendem Köder, Achsen-Lock, Test-Inventar-Floor, TABU-CRC). Jede Behauptung braucht eine literale Ausgabe mit Nenner; alles Wesentliche wird in Beweisorten unter `~/backups-workflow` und im Ledger (nur über das Nachtrags-Skript, neueste Einträge oben) festgehalten. Deine Worte haben Vorrang vor jedem Plan.

## 5. Was jetzt läuft

Sieben Stränge, alle Fable max:

**Der Lande-Zug** (der Auftrag von eben) landet die Identitäts-Kette in dieser Reihenfolge: zuerst die Director-Korrektur (der Bau-Batch überschrieb deinen Deckel von 16 Workern auf prod1 mit 24 — Speicherrisiko), dann den reparierten DTLB-Köder (der PMC-Selbsttest maß nur 128 KiB statt 64 MiB und kippte geschichtsabhängig), dann **VO3-1 global O2**: die ganze Bauwelt inklusive Vendor-Code auf -O2, das neue Stempel-Feld `vendoropt`, und ein hartes CMake-Gate, das jeden fremden Optimierungs-Flag beim Configure abbricht — das ist die Einlösung deines OS-2-Entscheids. Dahinter neutral die Lizenz-/REUSE-Zweige und die neue gitleaks-Regel gegen base64-Private-Keys. Danach ein Kombibau am zusammengesetzten Stand, Push, CI 286; dann im super das atomare Gitlink-Bump samt XSD- und YAML-Nachträgen auf O2, die KON133-Verbuchung, CI 288, main-FF. Parallel läuft der #114-Beweislauf (der Emitter muss auf der neuen Linie erneut byte-gleiche Pläne liefern), anschließend der ##47-Kalibrierlauf mit 64 × 4 = 256 DLLs, der die echten Werte liefert, die S-19 noch fehlen: Sekunden und Bytes pro DLL bei O2, Wiederholrate, und der Lebendbeweis, dass das Lager nach der Schlüssel-Rotation wieder schreibt.

**E-10** baut die 19. Organ-Achse (die Meta-Meta-Achse `disk_io`, Schritt 3 von 7 ist seit einer Stunde fertig, Schritt 4 läuft). Sie ist identitätswirksam und landet deshalb als eigenes Ereignis, sobald Schritt 7 und der Bau-Verify durch sind. **Stempel-Teil-2** baut die Emitter-Hälfte der Stempelpflicht: heute stempeln nur die Suchalgorithmus-Emitter ihre Erzeugnisse, das Hybrid-Makro erzeugt sechs Symbole ohne Stempel — der neue Modul-Emitter hängt die Stempelzeilen an jedes Erzeugnis an, ohne das Makro anzufassen. **D1/V-A** gibt prod2 ein VLAN-20-Bein (.214) und den NFS-Mount, damit die Intel-Lane ihre Ergebnisse überhaupt auf das NAS schreiben kann. Der **Lead-Vollzug** hat KON130–132 gepusht und zieht gerade prt-art `main` nach, damit die super-Pipeline ohne die stale Brücke grün wird. Die **Konsolidierung** schreibt die vier Referenzdokumente in dichte, aufgefrischte Fassungen (drei von vier stehen), damit das Einlese-Ritual künftig Minuten statt Stunden kostet. Der **Fold** verdichtet 116 Rückfragen-Fenster zu einem konsolidierten Frage-Antwort-Ledger.

## 6. Was danach kommt

Wenn der Lande-Zug grün ist, E-10 und Stempel-Teil-2 nachgelandet sind und ##47 die Kalibrierwerte geliefert hat, rechnet S-19 den Voll-Bau exakt durch, ##48 stellt Platz und Dauer gegenüber, und dann folgt der **Trigger ##49**: 524 288 Binaries, geschätzt 224 GB, anderthalb Tage auf zwei Lanes, mit HEAVY-Fenster ohne fremde CI-Last. Darauf baut die Kampagne (Debug-Generalprobe Samstag, echte Messung 12.–14.09.) und die Abgabe am 15.09.

## 7. Was ehrlich noch im Weg steht

Der **Platz**: prod1 hat 15 GB frei, der Voll-Bau braucht über 100 GB je Lane — die Umleitung von `gn_out` auf das NAS ist auf prod2 gerade in Arbeit, auf prod1 noch offen (dein Weg T1 = c). Die **Zeit**: der K-4-Kipppunkt ist morgen 06:00; das Etikett ist die späteste Frist, die technischen Deckel bleiben, und wir kürzen nichts. Und der **Public-Blocker**: der WireGuard-Rotationsbeleg fehlt weiterhin, bevor super wieder öffentlich werden kann.

---

*Nachtrag des Leads beim Ablegen (27.08. ~12:2xZ, nach der Antwort entstanden — nicht Teil des Verbatims):*
*D1/V-A prod2 ist inzwischen VOLLZOGEN (10.0.20.214, NFS-Mount, gn_out-Hook; Cluster 71552c09); die prod1-Hälfte
der gn_out-Umleitung bleibt offen (O-2). Belege: ~/backups-workflow/20260826-lead-vollzug/d1-va-prod2/.*
