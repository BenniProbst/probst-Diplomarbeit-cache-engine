# SESSION-KONTEXT-LOG (2026-07-20) — ALLE User-Direktiven + Fable-Rückfragen (VOLL)

> Isolierter, faithful Kontext-Log dieser Session: alle Nachrichten des Users (wörtlich/sinngetreu)
> + alle von Fable gestellten Rückfragen/Entscheidungspunkte. Quelle für die vollständige
> Persistierung (#22) — es soll NICHT nur der destillierte KERN, sondern der GESAMTE Kontext-Log
> persistiert werden (User-Anweisung). Enthält keine Secrets/Tokens (nur Prosa-Direktiven).

---

## 1. USER-DIREKTIVEN / NACHRICHTEN (chronologisch, wörtlich/sinngetreu)

### U-1 — „Alle Rückfragen gesammelt"
„Ich bin jetzt zurück, bitte stelle jetzt gesammelt alle Rückfragen hier die du hast."

### U-2 — DER KERN (Mess-Schema-Steuerung) + Frage-2/Band-B/S3-GOs
**Frage 1 (KERN):** „Der default geht immer von der Messung aller Achsen und vorhandenen Einstellungen aus, die XML ist also ein negatives blacklisting, indem es aus der generellen whitelist nur spezielle zu messende Teilbereiche freigibt. Das bedeutet, dass als default auch Prüflinge permutativ gemessen werden, die als existierende Cache-Engine-Achsenbibliothek in der XML geladen wurden, falls keine Einschränkung definiert wurde. Wenn kein Prüfling definiert wurde, dann wird nur die Cache-Engine permutativ über sich selbst und über alle Achsen getestet und durchgemessen. Sobald ein Prüfling definiert ist, der in die XML des Planers mit aufgenommen wird, wird auch zuerst der Prüfling (bzw. alle Prüflinge) direkt nach der Cache-Engine durchgemessen (default Modus ist vorhandene Prüflings-Achsen komplett die Cache-Engine-Achsen ersetzen zu lassen und ansonsten mit dem merge mit der Cache-Engine den Umfang des gesamten Cache-Engine+Prüfling -Hybriden zu messen für jeden einzelnen Prüfling). Nachdem alle Prüflinge und die Cache-Engine selbst gemessen sind, werden je Achse die Algorithmen nicht mehr ersetzt, sondern in der Cache-Engine durch einen full join ersetzt, was dann den sogenannten vollständig 'kombiniert' Modus ausmacht, bei dem durch den full join nichts verworfen wird. Das gesamte Mess-Schema muss auf der XML definierbar sein, welche Messmodi einstellbar ist, ob alle Achsen oder nur bestimmte Achsen gemerged oder ersetzt werden sollen und von welchem Prüfling (Variablenname für Prüfling oder statisches 'CacheEngine' pattern als identitäts-Bezeichnung), es muss möglich sein je Achse nur bestimmte zu prüfende Algorithmen zu whitelisten, oder es muss möglich sein ein template (Research-Gesamtalgorithmus) zu laden und diesen je Achse weiter einzuschränken oder zu erweitern, wenn möglich. Daher ist das der Kern des Planers und nicht vertagbar, ohne das haben wir keine Steuerung, das ist der KERN. Bitte entwickle ein Arbeitspaket mit ultracode, um das nachzuziehen. Dabei ist es wichtig, dass der Planer die XML so parst, dass die CEB versteht, was je Achse zu tun ist (Haupt-Achsen werden statisch per Metaprogrammierung in die CEB compiled, daher sind die Interpreter je Haupt-Achse nach CEB compile für die Achsen-Einstellungen zur Laufzeit der CEB (orchestriert durch Planer) fix, was dann zu emit der Tier-Binaries durch CEB führt)."
**Frage 2:** „Volles GO. Jetzt anstoßen, direkt los CI-getrieben."
**Band-B:** „Bitte starte einen ultracode um zu ergründen, welche diff sich gegen den Plan bei Band B mittlerweile ergibt und versuche das Band zu reparieren, erkläre mir die Inhalte mit reichem Kontext hier."
**S3:** „S-3-Resolver volles GO, bitte fehlplatzierte Achsen immer sofort beheben durch eine ultracode Planung mit eigenem sequentiellen Arbeitspaket. Volles GO."

### U-3 — Persistierungs-Ausnahme-Freigabe
„Bitte persistiere nach der vollständigen Konsolidierung und Planung der Agenten meine letzte Nachricht und Architektur in das ledger und in ALLE Planungs- und Architekturdokumente. Die Direktive, dass du das nur auf meine Anweisung selbst tust, bleibt stehen. Hier die Ausnahme Freigabe."

### U-4 — Voll-GO KERN + Forks + Band-B-Rückfrage + Autoritäts-Regel + prt-merge-Klärung
„Das passt alles, ich stimme dem KERN-Plan zu, volles GO. Bitte sorge dafür, dass alle Forks konsolidiert und umgesetzt werden, wie gewünscht. Bezüglich der kritischen Frage zu Band B Planer: volle Freigabe, bitte lege mir die Empfehlungen aber nochmal vor und was genau bricht. Weiterhin ist die Regel, die ich beschrieben habe, diejenige die SCHON IMMER Gesetz war und wenn sich der von dir gerade durzuführende Plan davon unterscheidet, muss es sich um eine Regression oder Ungenauigkeit handeln, bitte orientiere dich eher an meiner letzten Beschreibung. S4 Korrekt aufgelöst, volles GO. Bezüglich golden Relevanz der Prüflings-Relevanz der Prüflings-merges: Ja das ist korrekt, das sind dann die Tier-Binaries mit allen Mess-Artefakten zusammen, die dem jeweiligen Prüfling zugeführt und gespeichert werden (in einem Unterordner unter root lokal (default) oder per XML auch in der cache unter minio.comdare.de) als EIGENER ID-SATZ, soweit nur die Prüflingsseite gemessen wird, ansonsten entsteht für jede Merge und Join-Art eine eigene Messkategorie der Artefakte, die mit gecached wird Daher sagte ich, dass die Namen und Versionen jeder Achsen-Algorithmen immer mit im Stempel deklariert werden müssen, sowie als dritter Tier-Binary Stempel auch die Merge-Kombination."

### U-5 — Runner-Tags Weg (a) + Band-B genehmigt
„Bezüglich der runner S6 Vorbereitung wähle ich Weg (a) und gebe ihn dir frei. Bitte setze die Runner Tags mit Tags, die einer Haupt-Achse gerecht werden (AVX512 hat verschiedene Flags und daher ist jede Art von AVX512-Flag als einzelnes Tag zu deklarieren). Die Tags sollten für den Build nur als UND Bedingung annehmbar sein, wenn alle Haupt-System-Achsen vorhanden sind, dass die Maschine sie wirklich ausführen kann. Band-B volles Go und genehmigt."

### U-6 — Persistierungs-Umfang
„Bitte fahre wirklich nur die sinnvolle Auslegung der Aktualisierung."

### U-7 — Reiche Zwischendoku
„Bitte erstelle eine reiche Zwischendokumentation als Session zu diesem Punkt, um ihn zu sichern."

### U-8 — Die 3 Entscheidungen (①②③) + Klärungen
**① K6b/K7a:** „K6b POD-Layout-ABI-Gate: Das war der Prototyp für Versionierungsstempel, die Anatomy ist also die Rekombination aller in einer Stufe Planer/CEB/Tier vorhandenen Achsen, die hier versioniert werden sollten, wie beschrieben. Das ist im Prinzip schon die Stempel Vorlage. Daher volles GO sie nach Plan zu reaparieren und weiter zu entwickeln. GO."
**② K4/Mess-Tooling:** „Das ist eine Unter-Achse des Mess-Toolings, um eine passende CEB zu bauen, welche per XML Konfigurationen die notwendigen Mittel einkompiliert, um alle oder nur teilweise Einzel-Messeinrichtungen von Wallclock/Makro/Micro nach Plan-Beschreibung mit einzubauen. Volles GO, diese erst bei S6 Scharfzuschalten, wenn der Planer CEB emitten kann, sodass die vorkonfigurierten CEB ihrerseits die korrekt vorbereiteten Tier-Binaries mit diesen Mess-Eigenschaften emitten (Mess-Einstellung Wallclock/Makro/Micro ist compile time in CEB und Tier-Binaries fest per Metaprogrammierung eingerichtet)."
**③ Template:** „Ja korrekt. Bitte bedenke, dass die Cache-Engine registry und die PRT-ART Registry für bekannte Paper, die sie abbilden sogenannte echte Template-Profile führen müssen, also ist jedes Paper ein eigener Prüfling, der den Stand der Technik ergänzt (voll-template-split später in der Cache Engine nach Paper Definitionen und echtem code der nach Achsen vorsortiert ist). Erstmal mode full akzeptiert. Referenzierte templates später wie eben beschrieben, nach dem gesamten v3 Plan. Ich will das benannte <template> Element, wobei wir später die Features dafür erweitern. Volles GO."

### U-9 — Vergessene-TODOs-Sweep
„Ich hatte vorhin eine Planungskonsolidierung verlangt, bitte lies den GESAMTEN Kontext nochmal gründlich auf vergessene TODOs und führe sie durch."

### U-10 — Voll-GO offene Punkte
„Volles GO für die geannten offenen Punkte für refactor."

### U-11 — Voller Kontext-Log persistieren
„Der Persistierungs-Agent schreibt nur den Kern, bitte isoliere ALLE meine Nachrichten aus diesem Kontext zusammen mit deinen Fragen, die du stelltest in ein Session Dokument und weise den Agenten an, nicht nur den Kern zu persistieren, sondern alles aus diesem Kontext-Session-Log."

---

## 2. VON FABLE GESTELLTE RÜCKFRAGEN / ENTSCHEIDUNGSPUNKTE (mit Auflösung)

- **F-1 (auf U-1): Gesammelte Rückfragen.** §12-E11 Phasen-Kardinalität (blockiert S4; Empf. E11-A `<phases>` 1..unbounded); golden-Regen-GO (Frage 2); §32-F8-3 → beim Nachschlagen als **bereits entschieden (§49)** gefunden, daher KEINE Frage; S6 320er downstream. + 2 niedrig-Stakes-Bestätigungen (S3=minimal-3-tief; Resolver INERT-in-Produktion). → U-2/U-4 beantwortet.
- **F-2: Die 6 CoreSchema-Forks** (Manager aus Spec entschieden, Widerspruch erbeten): ① Phasen derived-by-default+Override · ② Träger comdare_experiment · ③ CacheEngine identity=self · ④ Merge-Default replace/merge-Override/fulljoin-Phase3 · ⑤ extend erlaubt · ⑥ K5 additiv. → U-4 „alle Forks umsetzen, volles GO".
- **F-3: Band-B kritische Frage — golden-Relevanz der prt-Merges** (reine Mess-Artefakte vs. eigener id-Satz?). → U-4 „eigener ID-SATZ, Storage lokal/minio, dritter Merge-Stempel".
- **F-4: Band-B-Empfehlungen + was bricht.** → vorgelegt: reparierter Zuschnitt (S4-KERN→Emitter→S5→S6→S7→S8, #19 eingeschmolzen); „was bricht = nichts am eingefrorenen golden (additiver id-Satz)".
- **F-5: Persistierungs-Umfang** (jedes Dokument vs. sinnvolle Auslegung?). → U-6 „nur sinnvolle Auslegung".
- **F-6: Die 3 Entscheidungen ①②③** (K7a-POD-Bump-GO · N>1-Timing · Template mode=full vs. benanntes Element). → U-8 alle drei voll-GO + Klärungen.
- **F-7: Runner-Wege (a/b/c)** für die schwere 2^17-Materialisierung. → U-5 „Weg (a), freigegeben".
- **F-8: main-Lag-Merge-Timing** (ce dev→main, Band-A). → OFFEN (Timing-Entscheid steht aus).
- **F-9: cacheline_study E-1/E-2/E-3** (Reject hart vs. Annotation · live? kanonisieren vs. deprecaten · page_type-Heimat). → E-1/E-2 via „das passt alles" (Annotation zuerst / kanonisieren); E-3 page_type-Heimat OFFEN.

---

## 3. ERTEILTE GOs + FINALE ENTSCHEIDUNGEN (konsolidiert)
KERN-Plan + alle 6 Forks (volles GO, umsetzen) · S4 korrekt aufgelöst · Band-B volle Freigabe/genehmigt · prt-merge = eigener id-Satz + Storage (lokal/minio) + dritter Merge-Stempel + axis-algo-Namen/Versionen immer · Autoritäts-Regel (User-Beschreibung = schon-immer-Gesetz, Abweichung = Regression) · golden-Regen jetzt anstoßen (Verifikation, CRC unverändert) · Runner-Tags Weg (a) freigegeben (flag-granular, UND-Bedingung, echte Maschinen-Fähigkeit) · Persistierungs-Ausnahme (sinnvolle Auslegung, jetzt: VOLLER Kontext-Log) · ① K7a-POD-Bump GO (Anatomy=Stempel-Vorlage) · ② N>1 erst S6 scharf (compile-time-fix in CEB+Tier per Metaprogrammierung) · ③ benanntes `<template>`-Element GO (mode=full jetzt, referenzierte Paper-Templates später; Paper=eigener Prüfling) · vergessene-TODOs-Sweep durchführen · volles GO offene Punkte (refactor).

## 4. OFFEN geblieben (User-Entscheid steht aus)
- **F-8 main-Lag-Merge-Timing** (ce dev→main, Band-A-Abgabe-Merge).
- **F-9-E3 page_type-Heimat** (Organ / System / registry-los).
- **Security-Fund (Sweep):** PAT-Rotation #327 (Vault-PAT-Exposition, Status unklar) — nicht autonom rotiert (bräche API-Zugang), dem User vorgelegt.

## 5. PRE-COMPACTION-KONTEXT
Die Nachrichten/Direktiven VOR der Kontext-Kompaktierung sind in der Session-Summary am Anfang dieses Kontexts festgehalten (u.a. §48-TODO-Ladung, Plan-v3-Überarbeitung, Legenden-Regression-Fluch, v3.2-Erstellung, Autonomie-Grant, Impl-an-Opus-Delegation). Für die Persistierung sind die post-Kompaktierungs-Direktiven (U-1..U-11) autoritativ; die pre-Kompaktierungs-Historie ist in den Session-Docs AUTONOM-01 + ZWISCHENSTAND-02 + im Ledger §52–§58 verankert.
