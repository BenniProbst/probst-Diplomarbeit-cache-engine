# KONSOLIDIERTES LAYER-MODELL DER HAUPT-ACHSEN (Synthese der 3 Erhebungen, live nachverifiziert 26.07.)

Pfad-Legende (alle absolut unter `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/`):
`LED` = `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` · `SESS26` = `docs/sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md` · `ARCH20` = `docs/architektur/2026-07-20-cache-engine-architektur-in-eigenen-worten.md` · `ARCH21` = `docs/architektur/21_SESSION_PLAN_TYPSYSTEM_ACHSEN_ENTSCHEIDUNGEN.md` · `BAUPLAN` = `docs/sessions/backups/20260726-strukt-r-planung-workflow/ergebnisse/00-bauplan-a67e501b.md` · `SYSWELT` = `docs/sessions/backups/20260726-strukt-r-planung-workflow/ergebnisse/01-system-welt-a51c70a7.md` · `SUFFIX` = `docs/sessions/backups/20260726-strukt-r-planung-workflow/ergebnisse/03-modus-suffix-welt-a288b88b.md` · `MEM-ACH` = `/home/comdare/.claude/projects/-home-comdare/memory/project_achsen_neuordnung_bindende_sortierung_regressionen.md`

Ich habe die 8 tragenden Zitate selbst live nachgelesen (LED 2031/2040/2150/2152/2671/2677/2723/2730/3311/3404-3413, ARCH20 35-36/65/73-78, ARCH21 10/16-20/26-31, SESS26 9-52, MEM-ACH 13-32). Alle Zeilennummern der drei Erhebungen stimmen. **Eine Korrektur an Quelle 2:** deren Negativ-Befund "das Wort `rekursiv` wird fuer die Achsen-Struktur an keiner Stelle verwendet" ist falsch — Quelle 2 hat `docs/architektur/` nicht gegrept. ARCH21:26-28 sagt literal "**beim rekursiven Durchgang durch die Achsen-Schichten**".

---

## § 1 — DIE REGELN DES MODELLS (je mit wortgenauem Beleg)

### R1 — CT/RT ist das Haupt/Unter-Kriterium (stufen-relativ angewandt)

`LED:2031` (User 18.07., woertlich): "Weiterer Hinweis zu Haupt-Achsen: sie sollten **in der Regel** statische Einstellungen beinhalten die zur compile time gesetzt und fest verdrahtet sind, hingegen haben Unter-Achsen **in der Regel** runtime Eigenschaften innerhalb des Programmes. Weil wir aber eine Kette Experiment-Planer -> CEB -> Tier-Binary laufen, sind die dynamischen Einstellungen der vorhergehenden Stufe, oft die zu übernehmenden compile Time Drähte der gebauten nachfolgenden Stufe."

`ARCH20:35-36` (ohne Hedge, als "Das durchgehende Prinzip", ARCH20:31): "**Haupt-Achse = compile-time-statisch.** Sie wird fest in das Binary einkompiliert; jede Haupt-Wahl erzeugt ein **eigenes** Binary bzw. eine eigene Baustrecke. Sie trägt einen Versionierungs-Stempel." / "**Unter-Achse = dynamisch.** Sie wird an die *nächste* Stufe als Laufzeitparameter **delegiert** — kein eigenes Binary, sondern eine Variable, die zur Laufzeit variiert."

Als **XOR-Entscheid** operationalisiert nur an einer Stelle, `LED:2671` (§51-B8, User 20.07.): "**SOFERN** deren Eigenschaften **compile-statisch** erkennbar sind (dann Haupt-Achse); ansonsten ist es eine **dynamische System-UNTER-Achse zur Laufzeit**, die bei Messungen an die Tier-Binaries als Variable delegiert wird."

Stufen-Relativitaet, `LED:2040` (§24.C): "die **dynamische Einstellung der Vorstufe ist oft der compile-time-Draht der gebauten Folgestufe.** ⇒ „statisch/dynamisch" ist **stufen-relativ**". Bestaetigt 26.07., `SESS26:50-52`: "load_framework und Mess-Tooling sind LAUFZEIT-Unterachsen auf dem PLANER und COMPILE-TIME-Haupt-Achsen auf der CEB".

Disjunktions-Haerte pro Baum-Node, `ARCH21:19-20`: "ENTWEDER statische compile-time-Algorithmen ODER dynamische Wert-Änderungen. **Die beiden fallen NIE zusammen** (pro Node-Spread genau eine Sorte)."

Mapping-Reinheit als Gesetz, `LED:3404-3409` (§66-NACHTRAG-3, KERN): "nur compile-time -> compile-time und runtime -> runtime Abbildungen akzeptiert; KEINE runtime->compile-time-Bruecken. ERLAUBT: verschiedene RUNTIME-Varianten der UNTER-Achsen auf dieselben COMPILE-TIME-HAUPT-Achsen".

> **Status "das EINZIGE Kriterium":** Die Owner-Formulierung vom 26.07. ("Haupt-Achsen sind compile time statisch und Unter-Achsen sind laufzeit-dynamisch") ist **haerter als jede Doku-Stelle** — die Doku sagt dreimal "in der Regel" (`LED:2031`, `LED:2040`, `LED:2152`). Nach [[feedback_user_kern_beschreibung_ist_immer_gesetz]] schlaegt die KERN-Beschreibung den Hedge; der Hedge ist damit **superseded**, nicht widerlegt.

### R2 — Komplex-Haupt-Achse: mehrere Haupt-Achsen verhalten sich wie EINE; Haupt-Achsen bekommen Schichtungen

Einzige Definitions-Stelle im gesamten Repo, `SESS26:27-34` (Owner-KERN, verifiziert):

> "**R-D compiler ist faelschlich Haupt-Achse** — real separate UNTER-Achse, welche die fixe Permutations-Rekombination target_isa x extension_hardware x Meta-Meta-Achsen (ohne load_framework) als **KOMPLEX-HAUPT-ACHSE nach dem Command-Pattern** annimmt (ein Compiler ist fuer diese Rekombination immer passend ausgelegt/verfuegbar; **alle 3 sind Haupt-Achsen, verhalten sich aber wie EINE — Haupt-Achsen bekommen Schichtungen in derselben Kategorie**). compiler + opt_level + atomic128 = **UNTER-ACHSEN-GRUPPE** (untrennbar: nur bestimmte Compiler bieten bestimmte Handles; der Compiler ist aus CEB-Sicht ein zur Laufzeit austauschbares Programm)."

Struktur-Vorlaeufer (gleiche Mechanik, nur fuer Hardware und ohne den Begriff), `LED:2677` (§51, verbatim-treu 20.07.): "**META-META-ACHSEN (neuer Begriff, generisch ueber alle Typen):** Haupt-Achsen eines **statischen Achsen-ARRAYS**, die durch eine **normale statische Hauptachse als MANAGER** klassifiziert werden, heissen **„Meta-Meta-Achsen"**."

Der generalisierende Satz, `MEM-ACH:28` (Owner 26.07. spaet): "**NEUES LAYER-MODELL: Haupt-Achsen haben Layer/Rekursivitaet nach Command-Pattern; auch META-META-ACHSEN SIND HAUPT-ACHSEN (CT!), die selbst Unter-Achsen tragen.**"

### R3 — Command-Pattern-Hub: der Manager verwaltet+gibt frei, die Glieder handeln als eigenstaendige Instanzen

`LED:2723` (§54-T5, User 20.07.): "Die **Hardware-Haupt-Achse verwaltet und GIBT FREI** die Meta-Meta-Achsen; jede **Meta-Meta-Achse erteilt dann — als eigenstaendige Instanz nach dem COMMAND-Pattern — Freigaben an die Organ-Achsen.** Konsequenz: die **tatsaechliche System-Achsen- UND Organ-Achsen-ZAHL waechst DYNAMISCH je System-Eigenschaften der Maschine**".

`ARCH20:74`: "Die Hardware-Haupt-Achse **verwaltet und gibt frei**. Jede Meta-Meta-Achse erteilt dann — **als eigenständige Instanz nach dem Command-Pattern** — Freigaben an die Organ-Achsen."

Hub benannt, `SESS26:45-46`: "**extension_hardware = offizieller Command-Pattern-HUB** der Hardware-Meta-Meta-Haupt-Achsen; seine Identitaet IST exakt deren Konfiguration."

### R4 — Rekursivitaet: dasselbe Muster auf jeder Schicht, EIN Concept fuer alle Achsen

(a) Haupt-Achse ueber Haupt-Achsen, `LED:2730` (§54-T7): "das ergibt eine **zweischichtige Kern-Permutation in einer managenden Haupt-Achse anderer Meta-Meta-Achsen**: Schicht 1 = WELCHE Meta-Meta-Achsen existieren (an/aus), Schicht 2 = die Werte je existierender Meta-Meta-Achse."

(b) Offene Layer-Alternation, `ARCH21:16-18` (autoritatives Layer-Modell, ARCH21:10 "korrigierte **Layer-/Haupt-Unter-Achsen-Modell**"): "**Der Experiment-Baum ist ein B+-Baum, LAYER-sortiert:** jede Achse = ein Layer. Eine **statische (compile-time) Achse** bildet einen strikten Layer; darunter folgen **dynamische Achsen-Nodes**, bis wieder eine statische Achsen-Konfiguration eingehängt ist."

(c) Ein Concept, Unter-Achse = Voll-Achse, `ARCH21:29-31`: "**EIN Concept für alle Achsen — Haupt-Achse + Unter-Achse:** eine Unter-Achse ist eine **VOLL-Achse**, die unter der compile-time-Haupt-Achse ausgeführt wird."

(d) Das literale Wort, `ARCH21:26-27`: "**Decorator über das Visitor-Objekt:** loggt beim **rekursiven Durchgang durch die Achsen-Schichten** den State der Tier-Binary-Wahl (ein Stack)."

(e) Stufen-Rekursion der Kette, `LED:1648-1655` (§18.1.1): "= dasselbe Muster REKURSIV (Planer→CEB gespiegelt zu CEB→Tier, geteilte Concepts)."

### R5 — Meta-Meta-Achsen SIND Haupt-Achsen, CT-statisch ausgerollt

`LED:2730`: "Die Meta-Meta-Achse bleibt dabei eine **VOLLE Haupt-Achse, zur compile time ausgerollt** (die Existenz-Wahl ist compile-time, keine Runtime-Wahl). Damit ist die dynamisch wachsende System-/Organ-Achsen-Zahl (§54-T5) selbst eine **compile-time-permutierte Dimension** der Hardware-Manager-Haupt-Achse."

`ARCH20:75`: "Die Existenz-Wahl ist **compile-time**; die Meta-Meta-Achse bleibt eine **volle, zur compile time ausgerollte Haupt-Achse**." — plus `ARCH20:73` "Eine **statische Hardware-Haupt-Achse** ist der **Manager** über ein **statisches Achsen-ARRAY**."

### R6 — Meta-Metas tragen EIGENE Unter-Achsen (RT) — Owner-KERN, in der Doku nur ableitbar

Owner-Satz: `MEM-ACH:28` (siehe R2). **Kein Doku-Satz sagt das literal** (0 Ko-Vorkommen `meta-meta` x `unter-achse` in `docs/`). Zwingend ableitbar aus zwei Allquantoren:
- `LED:2150` (§28, User-Direktive 19.07.): "Bezüglich der Achsen-Registries trägt **immer eine Haupt-Achse (statisch im Ziel-Binary) auch optionale Unter-Achsen-Einstellungen (meist dynamisch im Ziel-Binary)**."
- `ARCH21:29` "EIN Concept für alle Achsen" + `LED:2730` "VOLLE Haupt-Achse".

Ist-Beleg, dass es faktisch schon so ist: `load_framework` (= nach `SESS26:22-26` die **ERSTE Meta-Meta-Achse**) traegt heute `sub_axis_label()=="workload"` (`SYSWELT:24`, `BAUPLAN:103`).

### R7 — Aufwaerts-Identitaet der Meta-Meta-Schicht

`SESS26:35-46`: "Identitaet ist NUR AUFWAERTS kompatibel: GPU einbauen -> CPU-only-Programme laufen weiter + GPU-CPU zusaetzlich; GPU ausbauen -> GPU-CPU-Programme gehen nicht mehr. […] Basis = CPU-only. ALLE Hardware-Erweiterungen (auf der CPU wie extern: SIMD, GPU, FPGA, NPU, ...) werden strategisch in DERSELBEN Haupt-Achse modelliert". Ledger-Form `LED:3247` (§62-D): "**AEQUIVALENZKLASSE MODULO UNGENUTZTER META-META-ACHSEN** […] BEDINGUNG: zaehlt die Erweiterung einer Meta-Meta-Achse per Stempel zur KOMPILIERTEN Binary, MUSS die assimilierende Maschine sie ebenfalls unterstuetzen".

### R8 — Buendelung (Verhalten) vs. Klammerung (Repraesentation) — zwei KERN-Gesetze, Versoehnung ist MEINE Ableitung

`SESS26:31` "verhalten sich aber wie EINE" **gegen** `LED:3412-3413` (§66-N3, KERN): "**ALLE Achsen sind IMMER getrennt zu behandeln und zu KLAMMERN** (keine Fusion in Signaturen/Schluesseln/Stempeln — je Achse ihr eigenes Feld/ihre eigene Klammer)." und `LED:3311` (§62-B-NACHTRAG, KERN): "Die §42-Schreibweise `[d,e,f,g,h,i]` ist reine NAMENS-AUFZAEHLUNG der Haupt-Achsen im Binary-Namen, **KEINE Achsen-Verschmelzung**".
Einzige widerspruchsfreie Lesart: Komplex = **Verwaltungs-/Command-Huelle im Verhalten**, Klammerung bleibt **je Achse in Stempel/Schluessel/Signatur**. Das steht so **nirgends** — Owner-Nachfrage Q-A (§4).

### R9 — Stempel tragen nur Haupt-Achsen; Unter-Achsen erst in der Mess-CSV

`ARCH20:65`: "Alle Binary-Stempel tragen **nur Haupt-Achsen**; die **Unter-Achsen sind dynamische Laufzeit-Parameter**, die durch die Binary hindurchfließen und **nicht gestempelt** werden. Erst die **Mess-CSV** trägt den **voll-permutativen Stempel** — alle Haupt- *und* Unter-Achsen als Kurzform-Legende mit Versionierung je Achse (`Xa[Unter-k, Unter-l, …]`)".

### R10 — Realm-Layer (System vs Organ) sind orthogonal zu Achsen-Layern und werden NIE verschmolzen

`LED:3311`: "**Tier-Binary = ZWEI STRIKT GETRENNTE LAYER, NIE verschmolzen:** System-Haupt-Achsen [d,e,f] = Hardware-/Umgebungs-Layer und Organ-Haupt-Achsen [g,h,i] = Anwendungs-Logik-Layer […] **die Trennung gilt auch STRIKT IN DER LAUFZEIT DER CEB**". Ergaenzt durch die Freigabe-Doppelnatur `LED:2266` (§37): "**Die Freigabe betrifft NUR statische System-HAUPT-Achsen** — NICHT die dynamischen System-UNTER-Achsen, die (wie etwa **Threads**) als **Runtime-Variable an die Tier-Binaries** […] durchgereicht werden."

---

## § 2 — DAS VOLLSTAENDIGE ACHSEN-BILD NACH DIESEM MODELL

Ordnungs-Kette bindend, `SESS26:11-14`: "(1) MESS-TOOLING (Mess-Haupt-Achse; measurement_category = ihre Unter-Achsen) -> (2) target_isa -> (3) operating_system (NEU) -> (4) extension_hardware -> (5) ORGAN-Achsen (T00-T16, unveraendert) -> letztes Haupt-Blatt -> 3 Unter-Ebenen: Mess-Unter -> System-Unter -> Organ-Unter."

**A) MESS-REALM**
- CT-Haupt: `Mess-Tooling` {nur Wallclock | Makro-Benchmarks | Micro-Benchmarks ueber Observer} (`LED:2154`, §54-T2) — je Wahl eine eigene CEB-Strecke `ceb:build:[a,b,c]`.
- RT-Unter: `measurement_category` (16), Ablaufmethodik {Debug | Messung | Release | COMPARE} (4 Modi; `MEM-ACH:30`: "**CUSTOM_COMPILE ist KEIN 5. Modus, sondern CLI-FEATURE**"), Workloads/Datasets, Rueckschrieb-Methoden, `telemetry` (`MEM-ACH:32`: "telemetry ist MESS-TOOLING-UNTERACHSE des PLANERS").
- Dual-Natur: RT-Unter am Planer, CT-Haupt an der CEB (`SESS26:50-52`).

**B) SYSTEM-REALM**
- `target_isa` — CT-Haupt, Glied der Komplex-Achse. RT-Unter: `scheduling` (`SESS26:20-21` R-B), NUMA/locking (`LED:2671` B8: "Unter-Achse UNTER der ISA-Achse"), page_type (§51-B10).
- `operating_system` (NEU) — **CT-Komplex-Haupt-Achse** (`MEM-ACH:28`). RT-Unter: `os_version`, `kernel`, `build`, `update_zustand` (`SESS26:18-19`).
- `extension_hardware` — CT-Haupt **und Command-Pattern-HUB** (`SESS26:45`), Manager ueber das statische Achsen-Array; Glied der Komplex-Achse.
- `load_framework` — **ERSTE Meta-Meta-Achse**, in der CEB am Ende verortet, **ausserhalb** der Identitaets-Rekombination (`SESS26:22-26`, `SESS26:40`). RT-Unter heute: `workload`.
- **Meta-Meta-Achsen** (variadisches Array hinter `load_framework`): SIMD/AVX2/AVX512/GPU/FPGA/NPU… — je eine **volle CT-Haupt-Achse** (R5), je mit **eigenen RT-Unter-Achsen** (R6), Existenz an/aus CT-permutiert durch den Manager (Schicht 1), Werte Schicht 2 (R4a). `MEM-BEST:20`: "AVX und SIMD gehoeren zu den META-META-Achsen (nicht Unter-Achse von extension_hardware)".
- **Unter-Achsen-GRUPPE der Komplex-Haupt-Achse** (untrennbar): `compiler` + `opt_level` + `atomic128`; `compiler` verliert den Haupt-Status (`SESS26:27-34`).
- Dokumentierte Komplex-Rekombination: `target_isa x extension_hardware x Meta-Metas (ohne load_framework)` (`SESS26:28-29`) — **+ operating_system nach der 26.07.-Korrektur, Einbau-Form offen** (§3-D1, §4-Q-B).

**C) ORGAN-REALM**
- 17 Organ-Haupt-Achsen T00–T16 + `persistence_target` als 18. (`MEM-ACH:18`), aktuell `enabled=false` (`MEM-ACH:27`: "Raum bleibt 2^17 bis der echte Schreibpfad existiert"), Gruppen G1–G5 (`MEM-ACH:17`).
- Symmetrisches Manager-Array + Fold-Stempel, `LED:2678` (ORGAN-ANALOGON): "haben die **Organ-Achsen entsprechend ein ANALOGES Haupt-Achsen-Array UND Versionierungs-Stempel** fuer den **durch die CEB materialisierten compile-Raum**" / `ARCH20:76`: "Die Organ-Seite hat symmetrisch ein analoges Manager-Array + aus einem Fold abgeleitete (nicht hartcodierte) Versionierungs-Stempel".
- Freigabe-Doppelnatur: einzelne Achsen tragen **System-Aufnahme UND Organ-Aufnahme** und werden per **State Pattern durchs Pruef-Dock** freigeschaltet (`LED` §37, Punkt 4; Transkript-Quelle `31-transkript-21-af83517c.md:36`); Raum-Ausarbeitung in den Organ-Achsen `LED:2668` (B4).

**D) INVARIANTEN**
Stempel: CEB = Mess-Array je Mess-Haupt-Algorithmus; Tier = zwei separate Arrays (System / Organ); `binary_id` bleibt Organ-only (`ARCH20:65`). Bau-Legende = Haupt-only-Gate (`LED:3309`); Mess-Legende = alle drei Klammern.

---

## § 3 — ABWEICHUNGS-LISTE: mein bisheriges Verstaendnis vs. belegtes Modell (nicht geglaettet)

**D1 — OS als FLACHE Einzel-Haupt-Achse geplant, nicht als Komplex-Haupt-Achse.**
`BAUPLAN:100`: "**R-A** NEU `operating_system_system_axis.hpp` (CRTP nach Vorbild `machine_simd_signature.hpp:31-48`) + 4 Unter-Achsen `os_version/kernel/build/update_zustand`". Kein Layer, kein Command-Pattern, keine Schichtung. Gegen `MEM-ACH:28`. — Nebenbefund: **OS wurde nie als Unter-Achse gefuehrt** (0 Fundstellen); die Owner-Formulierung "Das OS ist keine Unter-Achse" trifft vermutlich meine **Q-2b-Frage** (`BAUPLAN:219`: "`update_zustand` (Paket-Stand) aendert sich **ohne Code-Aenderung**. Als CT-Achse ist er strukturell luegen-anfaellig"), die die 4 Werte implizit als CT-Kandidaten behandelte — genau die verbotene runtime->compile-time-Bruecke (R1/`LED:3406`).

**D2 — Komplex-Haupt-Achse als Einzelfall-Konstrukt statt als Gesetz.**
`BAUPLAN:102` / `SYSWELT:190`: "neu `ceb_complex_system_axis.hpp` […] `template <class TargetIsa, class ExtHw, class... MetaMetas> struct CompoundSystemAxis`" — Existenzgrund war **ausschliesslich**, die `SubAxisGroup<compiler, opt_level, atomic128>` aufzunehmen. Der Satz, der es zum allgemeinen Gesetz macht, stand wortgenau da und wurde nicht als solches gelesen: `SESS26:31` "**Haupt-Achsen bekommen Schichtungen in derselben Kategorie**".

**D3 — Meta-Metas als DATEN (Descriptor-Span) statt als volle Haupt-Achsen-Typen.**
`BAUPLAN:54`/`:163`, `SYSWELT:191`: `std::span<MetaMetaDescriptor const> meta_metas()`. Ein Descriptor kann **keine** eigenen Unter-Achsen tragen, **nicht** CT-existenz-permutiert werden und **keinen** eigenen Stempel fuehren. Gegen `LED:2730`/`ARCH20:75` ("VOLLE Haupt-Achse, zur compile time ausgerollt") und gegen R6.

**D4 — Schicht-Taxonomie genau 2-stufig und strukturell nicht rekursiv.**
`SYSWELT:189`/`BAUPLAN:99`: `CebSubAxis<Derived, ParentAxis>` mit `static_assert(CebSystemAxisConcept<ParentAxis>)` — das Praedikat erzwingt eine **System-Haupt-Achse** als Parent und schliesst damit aus, dass (a) eine Meta-Meta-Achse Parent ist, (b) eine Unter-Achse selbst Unter-Achsen traegt. Dazu `AxisKind` + **genau ein** neuer Wert `system_meta_meta` = **festes 3. Level**, nicht offene Tiefe. Gegen R4b/R4c ("bis wieder eine statische Achsen-Konfiguration eingehängt ist", "EIN Concept für alle Achsen").

**D5 — Erfundenes Sammel-Label statt Mechanismus.**
`SYSWELT:190`: `axis_label()` mit "ein NEUER Name, z.B. `\"build_target_complex\"`", `SYSWELT:178`: "Die Komplex-Haupt-Achse braucht ein LABEL (heute existiert keins). Alle `parent=\"...\"`-Strings der Gruppe zeigen darauf." Wenn **jede** Haupt-Achse komplex sein kann, ist ein hartkodierter Sammelname falsch; gebraucht wird ein generischer Huellen-Mechanismus. Zudem kollidiert ein fusioniertes Label mit `LED:3412` ("je Achse ihr eigenes Feld/ihre eigene Klammer").

**D6 — Q-3-Stempel-Tabelle setzt 4 flache Haupt-Zeilen voraus.**
`BAUPLAN:221` S1/S2/S3 gehen alle von "4 Haupt-Zeilen + Komplex-Achse bleibt CEB-intern" aus. Der Owner hat **S2 angenommen** (`MEM-ACH:29`) — S2 muss nun als **rekursive Klammer-Notation** gelesen werden (Meta-Metas sind Haupt-Zeilen mit eigenen Unter-Zeilen), nicht als 4-Zeilen-Tabelle. Zusatz `MEM-ACH:29`: "die Klammerung/3-Achsen-Typen-Definition ist **SEIT MONTAG (20.07.) geplant** -> Explore-Suche nach der Definitions-Stelle beauftragt" (laeuft, Explore-Q3).

**D7 — Interner Widerspruch in meiner eigenen Ist-Kartierung, ungeloest.**
`SYSWELT:139` (RISS 8): "die Haupt-Legende muss **target_isa x os x ext_hw x MetaMetas** tragen" — hier steht `os` **im** Komplex-Produkt, gegen `SESS26:28-29` (OS nicht aufgezaehlt) und gegen den Typ `CompoundSystemAxis<TargetIsa, ExtHw, MetaMetas...>` (kein `Os`-Parameter). Die 26.07.-Korrektur entscheidet zugunsten von RISS 8 — die Bauplan-Signatur ist die Regression.

**D8 — Suffix-Welt behandelt OS als flaches Segment.**
`SUFFIX:134`: "`+os=<...>` (3) operating_system NEU, weglassbar wenn nicht deklariert"; `SUFFIX:195` Ordnungs-Wache "+target vor +os vor +ext vor +cxx vor +opt vor +a128 vor +bt vor +ceb". Nach R9 korrekt (nur Haupt gestempelt), aber die 4 OS-Unter-Achsen brauchen einen **CSV-Spalten-Weg**, den die Suffix-Welt nicht kennt.

**D9 — Kriterien-Mischung in meinen eigenen Regressions-Begruendungen.**
`SESS26:20-21` begruendet R-B fachlich ("die CPU managed/verschiebt alle Daten einer Maschine"), `SESS26:32-34` begruendet R-D mit Untrennbarkeit — **beides nicht CT/RT**. Nach R1 muessten `scheduling` (RT-setzbar: plausibel, nie verifiziert) und `opt_level`/`atomic128` (auf Tier-Ebene **CT-Draehte**!) je per CT/RT gepruefte Unter-Achsen sein. `opt_level` als Unter-Achse ist **nur ueber Stufen-Relativitaet** (`LED:2040`) haltbar: Planer-dynamisch -> Tier-CT. Das habe ich nie explizit ausgewiesen.

**D10 — "Layer" wurde von mir nur im Realm-Sinn verwendet.**
Mein Session-Doc nutzt Layer ausschliesslich als System-vs-Organ-Trennung (`LED:3311`). Das neue Modell hat **zwei orthogonale Layer-Begriffe**: horizontal = Realm-Layer (nie verschmolzen), vertikal = Achsen-Layer innerhalb einer Haupt-Achse (Schichtung/Buendelung). Das Ist-Code-Wort dafuer existiert schon: `SYSWELT:11` "`topics::Axis<Derived>` | `topics/axis.hpp:26-30` | **Layer-Supertype**, empty, CRTP".

**D11 — Ist-Code kennt das Kriterium ueberhaupt nicht (Blocker, nicht nur Verstaendnis).**
`SYSWELT:45` (RISS 1): "**Es gibt KEINE `CebSubAxis`-Wurzel.** Haupt/Unter unterscheidet sich ausschliesslich durch die Anwesenheit eines `parent_axis_label()`-Members — ein reiner Konventions-String, nicht typisiert." `SYSWELT:63` (RISS 2): "`stage=\"ct\"|\"runtime\"` ist die EINZIGE Schicht-Information in der XML; ein 3. Level (Meta-Meta) hat kein Vokabular." `SYSWELT:10`: `topics::AxisKind` hat "NUR 3 Werte: `organ`, `system_measurement`, `system_config`. **Kein `meta_meta`**".

**D12 — AVX512-Flag-Subsets: "Domäne" vs. Unter-Achsen.**
`LED:2693` nennt die 13–14 Flag-Subsets explizit "**Domäne**" der Meta-Meta-Achse (= Werte-Menge, CT). Nach R6 koennten Teile davon RT-Unter-Achsen sein; §66-N3 spricht sogar von einem "**Runtime-Flag-Lookup … runtime->runtime ueber vorberechnete Werte**" (`LED:3410-3411`). Ungeklaert.

**D13 — Persistenz-Riss.**
Es gibt **keinen Ledger-Paragraphen fuer den 26.07.**; das Layer-Modell existiert nur in `SESS26` + `MEM-ACH:25-32`, und `MEM-ACH:28` **revidiert `SESS26` ohne Gegen-Eintrag in `SESS26`**. Ein §67 "LAYER-MODELL DER HAUPT-ACHSEN" fehlt vollstaendig.

---

## § 4 — WO DIE QUELLEN SCHWEIGEN (Owner-Nachfragen, nichts erfunden)

**Q-A (Buendelung vs. Klammerung):** Wie verhalten sich "verhalten sich wie EINE" (`SESS26:31`) und "ALLE Achsen sind IMMER getrennt zu … KLAMMERN" (`LED:3412`) zueinander? Meine Lesart: Buendelung = Verhalten/Freigabe, Klammerung = Stempel/Schluessel/Signatur bleibt je Achse. **Nicht belegt.** Folgefrage: traegt die Komplex-Achse **einen** Stempel oder N Stempel ihrer Glieder?

**Q-B (Einbau-Form von OS):** Drei mit den Quellen vereinbare Lesarten, keine entschieden:
(i) OS ist ein **4. Glied** der EINEN Komplex-Achse -> `target_isa x os x ext_hw x MetaMetas` (deckt `SYSWELT:139`);
(ii) OS ist eine **zweite, eigene** Komplex-Haupt-Achse **neben** der ISA/HW-Komplex-Achse (deckt `SESS26:28-29`, das OS nicht auffuehrt);
(iii) "Komplex" ist eine **Eigenschaft jeder Haupt-Achse** (= sie traegt Layer/Schichtung), nicht ein Buendel-Konstrukt — dann ist OS "komplex", weil es 4 Unter-Layer traegt. Fuer (iii) spricht `MEM-ACH:28` ("Haupt-Achsen haben Layer/Rekursivitaet"), gegen (iii) spricht `SESS26:31` ("alle 3 … wie EINE"). **Owner-Entscheid nötig, blockiert D1/D6/D7.**

**Q-C (RT-Natur der 4 OS-Unter-Achsen — technisch schaerfste Frage):** Nach `ARCH20:36` ist eine Unter-Achse "eine Variable, die zur Laufzeit variiert" und nach `LED:2266` wird sie "als Runtime-Variable … durchgereicht". `os_version`/`kernel`/`build`/`update_zustand` sind vom Programm aber **nicht variierbar** — sie sind beobachtete Host-Fakten. Sind sie **RT-Provenienz-Unter-Achsen** (zur Laufzeit **gemessen**, nur CSV-Spalten, nicht permutiert) oder echte delegierte Variablen (dann: wer setzt sie)? Keine Quelle behandelt "gemessene" vs. "gesetzte" Unter-Achsen.

**Q-D (Rekursions-Tiefe):** Keine Quelle nennt Tiefe, Abbruchbedingung oder ein rekursives Concept fuer Haupt-Achsen. Offen: Kann eine Meta-Meta-Achse **selbst** Manager/Komplex-Achse sein (Meta-Meta-Meta)? Kann eine Unter-Achse Unter-Achsen tragen (`ARCH21:29` "Unter-Achse ist eine VOLL-Achse" legt es nahe, sagt es nicht)?

**Q-E (Mitgliedschafts-Regel):** Keine Quelle sagt, **welche** Haupt-Achsen komplex sein duerfen bzw. nach welchem Kriterium Glieder gebuendelt werden. `SESS26:31` sagt nur "in derselben Kategorie" — ob "Kategorie" = Achsen-Typ (Mess/System/Organ) oder feiner (Hardware/Umgebung), ist offen.

**Q-F (Mess-/Organ-Realm-Symmetrie):** Fuer Mess-Achsen und Organ-Achsen ist **keine** Komplex-Haupt-Achse dokumentiert. Gilt R2 dort ebenfalls (die Organ-Gruppen G1–G5 waeren die naheliegenden Kandidaten), oder ist Komplexbildung System-only?

**Q-G (Quellen-Abdeckungs-Luecke):** Der Transkript-Korpus endet am **23.07.**; **kein Chunk deckt 24.–26.07.** ab. Die muendliche Herleitung des Layer-Modells liegt damit in keiner erfassbaren Quelle — nur `SESS26` (26.07. Nachmittag) und `MEM-ACH:25-32` (26.07. spaet) existieren. Falls es dazwischen weitere KERN-Saetze gab, sind sie **nicht persistiert**.

**Q-H (Definitions-Stelle "seit Montag"):** `MEM-ACH:29` behauptet, die Klammerung/3-Achsen-Typen-Definition sei **seit 20.07. geplant**. In den drei Erhebungen ist die naechstliegende Stelle `LED:3412` (23.07.) — die 20.07.-Definitions-Stelle wurde **nicht gefunden**; Explore-Q3 sucht noch.

---

SELBSTCHECK: read-only, keine Datei geschrieben oder geaendert (nur Bash/sed-Lesungen). Alle Zeilennummern am 26.07. live nachgeprueft; die Zitate in §1 habe ich selbst gegen LED/ARCH20/ARCH21/SESS26/MEM-ACH verifiziert (Quelle-2-Negativbefund zu "rekursiv" korrigiert). Nicht-ASCII ausschliesslich innerhalb wortgenauer Zitate (Umlaute/Anfuehrungszeichen/Pfeile der Originalquellen) plus §.