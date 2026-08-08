# KONSOLIDIERUNG UMBRELLA / CACHE ENGINE — Endprodukt fuer den Owner
**Stand 08.08.2026 · alle Zahlen am Objekt erhoben, Kommandos jeweils genannt · NICHTS geaendert**

---

# 1. DER IST-STAND, ehrlich

| | Umbrella (288, `wt-super-landung`) | Cache Engine (286, `wt-ce-s2`) |
|---|---|---|
| Doku getrackt | **3047** Dateien unter `docs/` | **160** |
| davon sessions | 2359 | 90 |
| termine | 309 | — |
| **plaene** | **119** | **3** |
| architektur/architecture | 54 (`architektur/`) | 43 (`architecture/`) + 1 (`architektur/`) |
| audits | 48 | 3 |
| ledger-sections | 3 | 3 |

`git ls-files docs | wc -l` in beiden Baeumen.

**RICHTIGSTELLUNG ZUR OWNER-ANNAHME.** Die Doku ist **nicht ungetrackt**. `git status --porcelain docs | grep "^??"` liefert in **beiden** Repos **0**. Die einzige echte Luecke waren zwei Analysen, die der Lead heute mit `a15a74a0` ("zwei ungetrackte Analysen nachziehen -- die einzige echte Luecke") nachgezogen hat; deshalb 119 statt der im Auftrag genannten 117.

**WAS TROTZDEM EIN ECHTER BEFUND WAR — und zwar ein groesserer als der vermutete.** Getrackt heisst nicht auffindbar:

- `docs/INDEX.md` (Umbrella, Stand **2026-05-15**) nennt `plaene` **0 Mal** (`grep -c plaene docs/INDEX.md` -> 0). 119 Plandokumente sind aus dem Top-Level-Index heraus unsichtbar.
- `docs/INDEX.md` (CE, Stand **2026-05-08**) nennt `plaene` 0, `sessions` 0, `audits` 0, `ledger-sections` 0. Der CE-Index verschweigt **99 von 160** eigenen Dateien.
- Ein `docs/plaene/INDEX.md` existiert in **keinem** der beiden Repos.

Der Owner hat also die richtige Stoerung gespuert und die falsche Ursache benannt. Es fehlt kein Push — es fehlt ein **Eintrittspunkt**.

**ZWEITER, SCHWERERER BEFUND — der Scope-Bruch ist am CE-Quellcode belegt.** `git grep -n "super docs/" -- libs tests apps tools cmake` in der CE liefert **12 Stellen**, mit den Etiketten *"QUELLE (bindend)"*, *"Plan-Quelle"*, *"Bau-Vorlage"*, *"Quelle des Verbots"*. Sie verteilen sich auf **8 × `super docs/sessions/`, 2 × `docs/audits/`, 2 × `docs/plaene/`**. Ein 286-Only-Klon enthaelt heute Quellcode, der **10 von 12** bindenden Quellen nicht aufloesen kann.

Bissbeweis, dass das Substanz und nicht Formalie ist: `libs/cache_engine/heuristik/break_even.hpp:27` nennt als Quelle `super docs/audits/20260709-axes-optimization-deep-research-BEFUND.md:83-101`. Die **Werte** sind uebertragen (`axis_optimization_catalog.hpp`, 29 KB, T0..T18), die Spalte **"Optimum haengt ab von" nicht**: gemessen im Header — `haengt ab` 0, `Zipf` 0, `Fuellstand` 0, `scan_share` 0; Kontrollmuster `Parameter-Art` 2, Gegenprobe `CatalogAxis` 94 (die Suche ist also nicht stumm). Genau diese Spalte **ist** der Break-Even. Die Frage *"wovon haengt das Optimum ab?"* ist aus dem CE-Klon allein heute **nicht** beantwortbar.

**DRITTER BEFUND — die CE hat kein docs-only-Gate.** `grep -cE "changes:|docs-only" .gitlab-ci.yml`: Umbrella **30**, CE **0**. Jeder reine Doku-Commit in der CE zieht die **volle** Pipeline (lint/build/sanitize/contract/test/chaos) auf dem Runner, der auf dieser Platte liegt. Gegenprobe zur Entlastung: `grep -n "docs/"` im Umbrella-CI -> **0 Treffer** (exit 1), in der CE-CI -> **2 Treffer, beide Kommentar** (:146, :156). Gegenprobe gegen stille Null: `thesis/diplomarbeit` im Umbrella-CI -> 11 Treffer. **Kein Job liest `docs/`. Eine Doku-Sortierung kann keine Pipeline brechen — sie kostet in der CE aber volle Laufzeit.**

---

# 2. DIE SCOPE-GRENZE

**Sie war nicht zu erfinden. Sie steht seit dem 13.05.2026.**

> *"Die Diplomarbeit bestimmt WAS getestet wird, die CacheEngine bestimmt WIE es getestet wird."*
> — `STRUCTURAL_CORRECTION_diplomarbeit.md:863-873`, Owner verbatim

Bis heute stehende Striktheits-Direktive im Ledger: **`ce = Framework, super = Definition/Bestueckung`** (`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:151`, wortgleich `:193`).

**DIE OPERATIVE FASSUNG — ein einziger Test:**

> Ein Dokument gehoert in die Cache Engine genau dann, wenn es **allein mit dem CE-Baum vollstaendig ausfuehrbar** ist.

Belegt am Code, nicht behauptet: `wt-ce-s2/libs/cache_engine/profile_facade/validate_profile.hpp:572-573` — *"ce darf super nicht inkludieren (Baseline-Layering), daher hier der XSD-Kontrakt als Single-Source zitiert."* Das ist zugleich die Hausloesung fuer Doppelbedarf: **nicht kopieren, nicht ueber die Grenze zeigen, sondern den Kontrakt im eigenen Repo neu aussprechen und die Autoritaet benennen.**

| **UMBRELLA (288)** — WAS + Durchfuehrung + Abgabe | **CACHE ENGINE (286)** — WIE |
|---|---|
| XML-Kette als **Gesamtmodell** (Registry=ANGEBOT, Anwender-XML, Resolver, Featurespace) | XML-**Parser**, Resolver-Implementierung, Profil-/Fixture-Artefakte |
| XSD-**Grammatik** (`Code/test_data_xml/`) | Schema-**Interpretation** |
| CI-Kette, `.gitlab-ci.yml`, Wellen, Reihenfolgen, Freigaben, Fristen | Achsen-/Gattungs-Architektur, ABI, Docks, Stempel |
| Ledger (SSOT), Roadmaps, Wiederanlauf-Briefings | CEB, build_orchestrator, Codegen, Materialisierungs-**Mechanik** |
| Auswertung Binary -> CSV -> LaTeX -> PDF | Mess-**Mechanismus**: ObservableTier, PMC-Erhebung, Fehlerklassen |
| Thesis, Termine, Betreuer, Lizenz, Eigentum | Einzelne Bauteile: Allokatoren, Suchalgorithmen, Node-Shapes, ISA, SIMD |

**"XML" ist KEIN Trennkriterium.** Die XML liegt physisch in beiden Repos. `docs/plaene/20260717-...-OPT-F-XML-SCHEMA.md:3` trennt selbst: *"super=Definition ... ce=Framework"*. Die Linie laeuft **mitten durch die XML-Verarbeitung**: Datei = Umbrella, Parser = CE (`docs/audits/20260709-...-SYNTHESE.md:41`).

**AUSSCHLUSS OHNE ERMESSEN (K3, Owner 07.08.):** Thesis = Benjamin-Elias Probst **privat**, CacheEngine = **BEP Venture UG**. Abgabe-, Termin-, Betreuer-, Fristen- und Lizenzdokumente gehen nie ins Firmen-Repo.

**[SETZUNG] TIEBREAKER zu K3** — noetig, weil K3 sonst mit dem technischen Test kollidiert (z. B. `20260806-PLAN-break-even-und-drei-benchmark-ebenen.md`: Artefakt `break_even.hpp` existiert in der CE, das Dokument zitiert aber die Thesis): **Eigentum sperrt nur, wenn das Dokument Zusagen, Termine, Fristen, Betreuer oder Lizenz FUEHRT. Blosses Zitieren der Thesis als Begruendung ist kein Eigentumsgehalt.** Sonst wandert die gesamte Mess-/Auswertungs-Familie faelschlich ins Umbrella, waehrend ihr Code in der CE liegt.

**GRENZFAELLE, einzeln:**

1. **Doku darf ueber die Grenze zeigen, die Bauflaeche nicht.** Nullbefund mit Gegenprobe: in der CE ueber `*.hpp *.cpp *.h *.cc CMakeLists.txt *.cmake` — `probst-diplomarbeit` 0 · `CMAKE_SOURCE_DIR}/../../..` 0 · `02_messung_driver` 4, **alle vier Kommentar** (ein Treffer im Kommentar ist keine Nutzung). Gegenprobe `cache_engine` in CMakeLists -> Treffer. **Die Sperre gilt fuer Code und CMake, nicht fuer Doku.**
2. **Mess-Kette gegen Mess-Mechanismus.** End-to-End-Ueberblick = Umbrella; ObservableTier/CEB/Pruefdock = CE. Die Formregel *"CE-Dateiliste -> Bauplan"* ist die duennste im Satz — **unsicher, weil sie an der Form haengt, nicht am Gegenstand.** Nicht autonom anwenden.
3. **Sessions ueber CE-Arbeit.** Formal Umbrella-Kategorie, inhaltlich 100 % CE. **Empfehlung: NICHT verschieben** (Praezedenzschaden hoch). Aber: 8 CE-Code-Stellen nennen Sessions als *bindend* — die Loesung ist **Extrakt in eine CE-Kontrakt-Datei**, nicht Umzug.
4. **Doppelt benannte Dateien** (`experiment_golden_kern.xml` super-Master gegen ce-Fixture): Gegenstand ist die Grenze selbst -> Umbrella fuehrt, CE bekommt einen Absatz *"unsere Datei ist Fixture, nicht Master"*.
5. **golden-Neubau / opt-Level-Default:** Entscheid + Fenster ins Umbrella-Ledger, Bauplan in die CE.
6. **Dokumente mit zwei deklarierten Eigentuemern** (`20260719-inc-g6`: *"Owner: super .gitlab-ci.yml, ce build_orchestrator + cmake/"*): **kapitelweise schneiden**, nie ganz verdoppeln.

---

# 3. DER EMPFOHLENE PLAN

**KEINER DER DREI VORLAGEN GEWINNT UNVERAENDERT.** `minimal-bewegung` faellt **0/3** — sein Schritt S5 (5 Kopfzeilen vor den Titel) verschiebt jede Zeile um +5 und entwertet **still** die Zeilenanker. Gemessen: `git grep -ohE "docs/plaene/[A-Za-z0-9_.-]+\.md:[0-9]+" -- docs | wc -l` -> **808** Anker auf **81** der 119 Dateien. Die vorgeschlagene Abnahme `numstat == 5 0` kann Prepend und Append **nicht unterscheiden** und geht gruen durch, waehrend 808 Belege falsch werden. Aus `scope-rein` uebernehme ich den Trailer-Befund, aus `minimal-bewegung` den Kontrakt-Gedanken und die Nicht-Loeschung.

## Der empfohlene Zuschnitt: **INDEX ZUERST, KOPIE NUR WO BEWIESEN**

**BEWEGT WERDEN 0 DATEIEN.** `git mv` kann Repo-Grenzen nicht ueberschreiten; ein "Umzug" waere copy+delete, und Loeschen ist Doktrin-verboten.
**GEAENDERT WERDEN 0 BESTANDSDOKUMENTE.** Kein Kopf-Banner, kein Trailer in `docs/plaene/`. Die Zeiger-Information gehoert in den Index — dann bleiben alle 808 Anker und alle **357** verweisenden Dateien (`git grep -l "docs/plaene/"`; 308 sessions, 37 plaene, 4 architektur, 2 Code, 1 Ledger, 1 ci/archive, u. a.) bitgenau gueltig.
**NEU ANGELEGT WERDEN 4 + N DATEIEN.**

| Schritt | Was | Dateien | Abnahme (literal, kein Haken ohne Ausgabe) |
|---|---|---|---|
| **S0** | Eigene Arbeitsflaeche. `wt-ce-s2` steht auf `bau/a1-m64-medien-basis` (**nicht** development) und wird vom Bau-Agenten beschrieben; `wt-super-landung` traegt fremde gestagete Renames. Zwei neue Worktrees, Branch `doku/scope-sortierung`. Basis **selbst** rechnen (`git merge-base HEAD origin/development`), keine vorgegebene SHA zurueckspiegeln (K9). | 0 | `git status --short` in beiden neu: **leer** |
| **S1** | **`docs/plaene/INDEX.md` (Umbrella, NEU).** 119 Zeilen: Datei, Thema in einem Satz, Klasse (CE-lebend / CE-Historie / geteilt / Umbrella), Autoritaets-Ort. Das ist der Eintrittspunkt, der heute fehlt. | +1 | Zeilenzahl der Tabelle **== 119 == `git ls-files docs/plaene \| wc -l`**; jede Datei genau einmal |
| **S2** | **`docs/INDEX.md` beider Repos nachziehen.** Super: `plaene` fehlt komplett. CE: `plaene`, `sessions`, `audits`, `ledger-sections` fehlen komplett. | 2 geaendert (Index, keine Anker) | `git ls-files docs \| awk -F/ 'NF>2{print $2}' \| sort -u` gegen Index-Tabelle: **Differenz leer** |
| **S3** | **`ce/docs/plaene/INDEX.md` (NEU).** Fuehrt alle CE-relevanten super-Dokumente mit Thema + `super:<pfad> @ <sha> (<datum>)`. Repo-relativ, **nie** `../`, nie `/home/comdare/...`. | +1 | fuer jede Zeile `git -C super cat-file -e <sha>:<pfad>` -> **0 Fehler** |
| **S4** | **`ce/docs/architecture/20260808-KONTRAKTE-an-der-super-naht.md` (NEU).** Je geteiltem Dokument **ein** Absatz, aus sich heraus verstaendlich, Vorbild `validate_profile.hpp:572`. Pflicht-Inhalt sind die **12 am CE-Code belegten** Quellen — insbesondere die fehlende Spalte *"Optimum haengt ab von"* zu `break_even.hpp:27`. | +1 | `grep -c '\.\./'` -> **0**; Lesetest ohne 288-Zugriff besteht |
| **S5** | **Volltext-Kopien — nur der bewiesene Kern.** Nicht 59. Zielordner: Bauteil-/Achsen-/ABI-Spezifikation nach `ce/docs/architecture/` (dort liegen die 43 Soll-Designs), Increment-Dossiers nach `ce/docs/plaene/`. Herkunfts-Banner am **Kopf der Kopie** ist unschaedlich (die Kopie hat keine Alt-Anker). Ketten ziehen gemeinsam (die neun `20260702`-Dossiers mit ihrem MASTERPLAN; `go4-f-abc` mit NACHTRAG-F-B; `OPT-OPTIMIERUNGSSTUFE` mit `OPT-KORRIGIERT`). | **+9 bis +12** | `git -C ce status --porcelain` enthaelt **nur** `docs/`-Pfade, **0** Bau-Dateien |
| **S6** | Ledger: **ein** additiver Nachtrag am Ende. Keiner der 45 `docs/plaene/`-Verweise wird angefasst. | 1 geaendert | `git diff --numstat` -> `n 0` (**0** geloeschte Zeilen); `grep -c 'docs/plaene/'` bleibt **45** |
| **S7** | Landen: **erst CE** (Merge, nie Rebase, Dateiliste explizit — kein `git add -A`, K8), **dann** Umbrella mit gehobenem Gitlink. | — | siehe §4 zur Submodul-Wache |

**BILANZ DES EINGRIFFS: 0 geloescht · 0 bewegt · 0 Bestandsdokumente in `docs/plaene/` geaendert · 0 Bau-Dateien · 0 gebrochene Zeilenanker · neu: 3 Index-/Kontrakt-Dateien + 9-12 Kopien · geaendert: 2 Indizes + 1 Ledger-Anhang (additiv).**

**WARUM NUR 9-12 KOPIEN UND NICHT 59:** Die Klasse-A-Liste der Vorarbeit ist **nicht gegengelesen** — 6 von 59 Koepfen wurden gelesen. Die Hausdoktrin EXPLORE=2-STUFIG verlangt, dass der Lead jede tragende Referenz selbst nachliest; das sind ~53 offene Gegenlesungen. Die **9-12** sind dagegen **bewiesen**: der CE-Quellcode benennt sie selbst als bindend. Sie erfuellen den Kern-Test ohne Ermessen. Der Rest folgt in einer zweiten Welle **nach** Gegenlesung — oder gar nicht.

---

# 4. WAS BRICHT UND WIE ES AUFGEFANGEN WIRD

**Die Verweislast, gemessen:**

| Groesse | Wert | Kommando |
|---|---|---|
| Dateien, die `docs/plaene/` nennen | **357** | `git grep -l "docs/plaene/"` |
| davon `docs/sessions/` | 308 | |
| Ledger-Nennungen | 45 | |
| **zeilenverankerte Verweise `X.md:NN`** | **808** | `git grep -ohE "docs/plaene/[...]\.md:[0-9]+" -- docs \| wc -l` |
| betroffene Zieldateien | 81 von 119 | |
| bau-nahe Verweise | 2 (`Code/tests/fixture_schema_subset_check.cmake`, `Code/test_data_xml/experiment_golden_kern.xml`) | |

**WAS NACH DIESEM PLAN BRICHT: nichts davon.** Kein Pfad bewegt sich, keine Zeile verschiebt sich, keine Pipeline liest `docs/`.

**WAS BLEIBT:** (a) Die CE-Kopien starten mit **einem** Commit ohne Vorgeschichte — cross-repo unvermeidbar; deshalb darf das Umbrella-Original nie verschwinden, und der Banner nennt Herkunftspfad **und** SHA. (b) Suchtreffer verdoppeln sich fuer die 9-12 kopierten Dokumente. (c) Reine Doku-Commits in der CE ziehen die volle Pipeline (kein `changes:`-Gate) — deshalb **ein** Buendel-Commit, nicht 12.

## Vorschlag WACHE: `doc-anchor-check`

Es gibt heute **keine** Wache fuer Doku-Verweise (Dateinamensuche ueber `wache|hygiene|drift|verweis|link.?check` liefert nur Treffer in `docs/`). Vorschlag, minimal und ohne Python (Buildchain-Doktrin):

1. Sammelt alle `docs/**/*.md:NN`-Anker aus getrackten Dateien.
2. **Test A (hart, rot):** Zieldatei existiert. Faengt jede Loeschung/Umbenennung.
3. **Test B (hart, rot):** Zeile NN existiert (`NN <= wc -l`). Faengt jedes Kuerzen und out-of-range.
4. **Test C (weich, Warnung):** Zeile NN ist gegenueber dem letzten gruenen Stand **inhaltlich unveraendert** — Fingerabdruck der Zeile in einer getrackten `docs/.anchors.sha`. **Das** ist der Test, den `minimal-bewegung` nicht hatte und der die 808 stillen Falschzitate ueberhaupt sichtbar macht.

**Verortung [SETZUNG]:** nur im **Umbrella**, in der bestehenden docs-only-Lane (30 `changes:`-Gates vorhanden, kein neues Pipeline-Risiko). In der **CE nicht** als Job — dort existiert kein docs-Gate, ein neuer Job wuerde die volle Pipeline an Doku haengen. Dort als lokal aufrufbares Skript, bis der Owner ein Gate will.

---

# 5. AUFWAND UND EINORDNUNG

**Der volle Vorlagen-Plan (59 Kopien) kostet 10-14 Stunden auf dem kritischen Pfad. Ich rate davon ab.** Begruendung, nicht Gefuehl:

- **Frist 15.09., Lieferung freitags. Die Messung hat nicht begonnen.** Sechs rote/gelbe Posten sperren sie (#21 `--check-size`, #46 compare/D2, #49 Paper-XMLs, #52 Experiment-Groesse, #45 LaTeX-Anlage, #48 L3-Asymmetrie). Der volle Plan bewegt **keinen** davon.
- **Er deckt 119 von 3047 Doku-Dateien ab — 3,9 %.** Ein perfekt sortiertes Repo ohne fertige Messung ist keine Diplomarbeit.
- **`docs/plaene/` ist aktive Arbeitsflaeche, keine Ablage:** **33 der 119** Dateien wurden in den letzten 7 Tagen geaendert (`git log --since="7 days ago" --name-only -- docs/plaene`). Jede Einfrier-Mechanik bricht in der naechsten Woche — und trifft bevorzugt die lebenden Dokumente, weil "lebende Bauteil-Spezifikation" und "wird gerade editiert" dieselbe Menge sind.
- **~53 Dokumente sind nicht gegengelesen.** Die Klassifikation ist die einzige Urteilsstelle und sie ist offen.

**KOSTEN DER EMPFOHLENEN FASSUNG (S0-S7): 3-4 Stunden.** Davon ~2 h fuer die 119 Kopfzeilen des Umbrella-Index (die ohnehin faellig sind), ~1 h Kontrakt-Datei, ~0,5 h Kopien + Landung. **Sie erfuellt den Owner-Auftrag** — beide Repos tragen fuer ihren Scope den vollstaendigen Satz —, weil sie den einzigen **beweisbaren** Fehlbestand schliesst (die 12 unaufloesbaren Quellen im CE-Code) und den einzigen **gemessenen** Findbarkeitsdefekt (die drei fehlenden Indizes). Alles Weitere ist Komfort.

**Was sie verdraengt: einen halben Tag.** Was der volle Plan verdraengen wuerde: zwei Arbeitstage in der viertletzten Woche vor der Frist.

---

# 6. WAS DER OWNER ENTSCHEIDEN MUSS

**Selbst entschieden, nur Veto noetig — [SETZUNG]:**

- **[SETZUNG 1]** Keine Kopf-Banner, keine Trailer in `docs/plaene/`. Zeiger-Information ausschliesslich im Index. *(808 Zeilenanker)*
- **[SETZUNG 2]** Kein Umzug, kein `git mv`, keine Loeschung. Kopie + Index + Kontrakt.
- **[SETZUNG 3]** K3-Tiebreaker: Eigentum sperrt nur bei **gefuehrten** Zusagen/Terminen/Fristen/Lizenz, nicht bei blossem Thesis-Zitat.
- **[SETZUNG 4]** Zielordner CE: Bauteil-Spezifikationen nach `docs/architecture/` (43 vorhanden), Increment-Dossiers nach `docs/plaene/`. Die eine `docs/architektur/`-Datei bleibt unangetastet.
- **[SETZUNG 5]** Sessions wandern **nicht**. Die 8 im CE-Code zitierten Session-Fakten kommen als Kontrakt-Absatz in die CE.
- **[SETZUNG 6]** Wache nur im Umbrella, in der bestehenden docs-only-Lane.

**Echt offen — ich kann es nicht ableiten:**

1. **GO / Timing.** Empfohlene Fassung (3-4 h) jetzt, volle Fassung (10-14 h, 59 Kopien) **nach** dem 15.09.? Ich empfehle: **jetzt schlank, voll danach.**
2. **Zweite Welle ja/nein.** Sollen die restlichen ~47 CE-Kandidaten nach Gegenlesung kopiert werden, oder reicht der Index dauerhaft als Eintrittspunkt? *(Kostet ~53 Gegenlesungen.)*
3. **Namenskollision `architecture/` gegen `architektur/`** in der CE, und dasselbe Wort entsteht gerade neu im Umbrella durch fremde Renames. Zusammenlegen ist ein Umbenennungs-Satz — Owner-Sache.
4. **Docs-only-Gate fuer die CE-Pipeline?** Heute zieht jeder Doku-Commit dort den vollen Lauf. Ein `changes:`-Gate waere billig, ist aber ein Eingriff in eine gruene Pipeline.
5. **Tote Overleaf-Einbindung** `Code/external/20260931-overleaf-diplomarbeit` — von `.gitmodules` selbst als TOT markiert, Entfernung ist ausdruecklich Owner-Entscheid (Loeschung = GO). Ausserhalb dieses Auftrags, aber sie loest bei **jedem** Umbrella-Commit die Submodul-Wache aus (`git submodule status` zeigt heute drei `-` und ein `+`).
6. **Die inhaltliche Luecke `break_even`:** Soll die Spalte *"Optimum haengt ab von"* (T0..T18: `scan_share`, Zipf-Skew, Fuellstand, Wertgroessen-Verteilung) in die CE uebertragen werden — als Kontrakt-Absatz oder in den Katalog-Header selbst? Das ist der einzige Punkt, an dem diese Sortierung **die Messung beruehrt**, und damit der einzige, der Vorrang vor der Frist beanspruchen kann.

---

**UNSICHER, WEIL:** Die Zuordnung der 119 Dokumente stammt zu ~53/59 aus einer nicht gegengelesenen Kartierung; die empfohlene Fassung haengt bewusst **nicht** daran (sie stuetzt sich nur auf die 12 am CE-Code belegten Quellen). Die Formregel *"CE-Dateiliste -> Bauplan"* fuer die Mess-Ketten-Dokumente halte ich fuer die schwaechste Regel im Satz — sie darf nicht autonom angewandt werden.