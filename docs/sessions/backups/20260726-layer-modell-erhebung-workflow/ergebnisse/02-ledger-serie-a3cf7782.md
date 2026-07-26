# ERHEBUNG: LAYER-MODELL DER HAUPT-ACHSEN (Zeitfenster 19.–26.07.2026)

Pfad-Legenden: `LED` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` · `SESS26` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md` · `MEM-ACH` = `/home/comdare/.claude/projects/-home-comdare/memory/project_achsen_neuordnung_bindende_sortierung_regressionen.md` · `MEM-BEST` = `/home/comdare/.claude/projects/-home-comdare/memory/project_bestandslog_abnahmen_baum_heuristik_stempel.md`

**BEFUND VORWEG (ehrlich):** Von den 5 erfragten Punkten sind **2 wortgenau dokumentiert** (3, 4), **1 nur in EINER Zeile** (1), **1 nur analog/anderes Objekt** (2), **1 gar nicht** (5 — OS ist dokumentiert als *normale* System-Haupt-Achse, NICHT als Komplex-Haupt-Achse). Das Ledger endet bei §66-N4; **es gibt KEINEN Ledger-Paragraphen fuer den 26.07.** — die KERN-Beschreibung liegt ausschliesslich in SESS26 + Memory.

---

## (1) KOMPLEX-HAUPT-ACHSEN — Schichtung/Buendelung mehrerer Haupt-Achsen, die sich wie EINE verhalten

**EINZIGE Dokumentationsstelle im gesamten Repo: SESS26:27-34 (R-D).** Wortgenau:

> **SESS26:27-34** — "**R-D compiler ist faelschlich Haupt-Achse** — real separate UNTER-Achse, welche die fixe Permutations-Rekombination target_isa x extension_hardware x Meta-Meta-Achsen (ohne load_framework) als **KOMPLEX-HAUPT-ACHSE nach dem Command-Pattern** annimmt (ein Compiler ist fuer diese Rekombination immer passend ausgelegt/verfuegbar; alle 3 sind Haupt-Achsen, verhalten sich aber wie EINE — Haupt-Achsen bekommen Schichtungen in derselben Kategorie). compiler + opt_level + atomic128 = **UNTER-ACHSEN-GRUPPE** (untrennbar: nur bestimmte Compiler bieten bestimmte Handles; der Compiler ist aus CEB-Sicht ein zur Laufzeit austauschbares Programm)."

Das ist der **einzige wortgenaue Beleg** fuer „Haupt-Achsen bekommen Schichtungen in derselben Kategorie" und fuer „alle 3 sind Haupt-Achsen, verhalten sich aber wie EINE". Spiegelung in MEM-ACH:14 (identischer Inhalt, gekuerzt).

**Wichtig:** Die dokumentierte Komplex-Haupt-Achse ist **exakt und ausschliesslich** `target_isa x extension_hardware x Meta-Meta-Achsen (ohne load_framework)`. **`operating_system` ist dort NICHT enthalten** (siehe Punkt 5).

**Verwandter Layer-Satz im Fenster (anderes Objekt — Tier-Binary, nicht Haupt-Achsen-Schichtung):**
> **LED:3311** (§62-B-NACHTRAG, User-Korrektur 22.07. abends) — "**Tier-Binary = ZWEI STRIKT GETRENNTE LAYER, NIE verschmolzen:** System-Haupt-Achsen [d,e,f] = Hardware-/Umgebungs-Layer und Organ-Haupt-Achsen [g,h,i] = Anwendungs-Logik-Layer bleiben in der Tier-Binary strikt getrennte Schichten (User-Analogie: man setzt auch kein Betriebssystem mit dem Anwendungs-Frontend gleich). Die §42-Schreibweise `[d,e,f,g,h,i]` ist reine NAMENS-AUFZAEHLUNG der Haupt-Achsen im Binary-Namen, KEINE Achsen-Verschmelzung"

⇒ **Spannung, die zu benennen ist:** LED:3311 verbietet *Verschmelzung* von Haupt-Achsen-Klammern; SESS26:31 fordert *Buendelung zu EINER*. Beides ist KERN=Gesetz. Aufloesbar nur, wenn die Komplex-Achse eine **Verwaltungs-/Command-Huelle** ist und die Klammerung je Achse erhalten bleibt — was §66-NACHTRAG-3 stuetzt:
> **LED:3412-3413** — "**ALLE Achsen sind IMMER getrennt zu behandeln und zu KLAMMERN** (keine Fusion in Signaturen/Schluesseln/Stempeln — je Achse ihr eigenes Feld/ihre eigene Klammer)."

---

## (2) REKURSIVITAET der Haupt-Achsen-Struktur

**Dokumentiert ist REKURSIVITAET der DOCK-/BINARY-Kette, NICHT der Haupt-Achsen-Struktur.** Alle Fundstellen im Fenster und davor:

> **LED:1648-1655** (§18.1.1 „Rekursive Dock-Topologie — dasselbe Muster auf zwei Ebenen") — "⇒ = dasselbe Muster REKURSIV (Planer→CEB gespiegelt zu CEB→Tier, geteilte Concepts)."

> **LED:447** (2026-07-17, USER-SCHAERFUNG „um ganz sicher zu gehen" — REKURSIVE Dock-Architektur, autoritativ)

Der **einzige** dokumentierte Rekursions-/Schichtungs-Mechanismus *innerhalb* der Achsen-Struktur ist §54-T7 (zweischichtige Kern-Permutation) — wortgenau:

> **LED:2730** (§54-T7, 2026-07-20, User) — "**T7 — Zweischichtige Kern-Permutation der Meta-Meta-Achsen (PRAEZISIERT §51-B3 / §54-T5).** Weil die Meta-Meta-Achsen selbst durch eine **statische Hardware-Haupt-Achse verwaltet** werden, ist diese Haupt-Achse auch **beauftragt, die EXISTENZ aller Meta-Meta-Achsen zu permutieren (an/aus)** — das ergibt eine **zweischichtige Kern-Permutation in einer managenden Haupt-Achse anderer Meta-Meta-Achsen**: Schicht 1 = WELCHE Meta-Meta-Achsen existieren (an/aus), Schicht 2 = die Werte je existierender Meta-Meta-Achse."

⇒ „**eine managende Haupt-Achse anderer Meta-Meta-Achsen**" ist der wortgenaue Keim der Rekursivitaet (Haupt-Achse ueber Haupt-Achsen). Eine **Tiefe > 2** ist NIRGENDS dokumentiert; „rekursiv" wird fuer die Achsen-Struktur an keiner Stelle verwendet (grep `-i rekursiv` ueber LED + alle `docs/sessions/2026-07-2*` / `2026072*`: nur Dock-Topologie und CI-Bridges).

Der stufen-relative Layer-Begriff (Basis des Modells, 10.07., von §28 explizit als Vorlage zitiert):
> **`docs/sessions/backups/20260726-kontext-neugruendung-workflow/ergebnisse/12-transkript-07-a7c70ee8.md:19`** (User woertlich) — "was ich mit tree<axis compile/dynamic,...> genau meinte ist ein B+ Baum der Layer sortiert ist, also im Falle dass eine statische Achse folgt ein strikter Layer im Baum mit dynamischen Achsen nodes, bis wieder die Konfiguration einer statischen Achse einghaengt ist. Jede Achse bildet einen Layer im Baum […] Wenn du tiefer liest, dann haben wir Hauptachsen und Unterachsen definiert, an sich sollten also alle Achsen auf demselben concept beruhen - sie koennen sozusagen als unterklasse aber Voll-Achse unter der compile time Achse der jeweiligen Hauptachse ausgefuehrt sein."

> **`docs/plaene/20260719-archiv-workflow-kontext-KAPSELN.md:262`** — "**Doc-21-Layer-Modell = INTERLEAVED Haupt/Unter, NICHT flache 2-Block-Partition**: statische Haupt-Achse = strikter Layer, ihre dynamischen UNTER-Achsen haengen DARUNTER, bis die naechste statische Konfiguration folgt (static→dyn→static→dyn). Dokumentierter Keim der §28-Regel."

---

## (3) META-META-ACHSEN ALS HAUPT-ACHSEN (CT-statisch) mit EIGENEN Unter-Achsen (RT-dynamisch)

**Teil A „Meta-Meta = VOLLE CT-Haupt-Achse" = wortgenau + mehrfach dokumentiert:**

> **LED:2677** (§51, 2026-07-20, User, „NEUE ACHSEN-KONZEPTE … verbatim-treu") — "**META-META-ACHSEN (neuer Begriff, generisch ueber alle Typen):** Haupt-Achsen eines **statischen Achsen-ARRAYS**, die durch eine **normale statische Hauptachse als MANAGER** klassifiziert werden, heissen **\"Meta-Meta-Achsen\"**. Die Hardware-Haupt-System-Achse ist der Manager ihres Hardware-Erweiterungs-Arrays (jede Erweiterung = eine Meta-Meta-Achse darunter)."

> **LED:2730** (§54-T7) — "Die Meta-Meta-Achse bleibt dabei eine **VOLLE Haupt-Achse, zur compile time ausgerollt** (die Existenz-Wahl ist compile-time, keine Runtime-Wahl). Damit ist die dynamisch wachsende System-/Organ-Achsen-Zahl (§54-T5) selbst eine **compile-time-permutierte Dimension** der Hardware-Manager-Haupt-Achse."

> **LED:2753** (§55) — "**(T7) Zweischichtige Kern-Permutation:** […] Existenz-Wahl ist **compile-time**; die Meta-Meta-Achse bleibt eine VOLLE CT-Haupt-Achse."

> **LED:2723** (§54-T5) — "Die **Hardware-Haupt-Achse verwaltet und GIBT FREI** die Meta-Meta-Achsen; jede **Meta-Meta-Achse erteilt dann — als eigenstaendige Instanz nach dem COMMAND-Pattern — Freigaben an die Organ-Achsen.** Konsequenz: die **tatsaechliche System-Achsen- UND Organ-Achsen-ZAHL waechst DYNAMISCH je System-Eigenschaften der Maschine**"

> **LED:2693** (§52-B3, Aufloesung) — "SOLL (§51-B3): `hardware` wird **MANAGER** (normale statische Haupt-Achse) über ein statisches Achsen-ARRAY; jeder Erweiterungstyp = eigene Haupt-Achse = **Meta-Meta-Achse** (`Avx512ExtensionAxis` mit den 13–14 Flag-Subsets als Domäne, `Avx2ExtensionAxis`, später `GpuExtensionAxis`). **Typsystem (3 CRTP-Ebenen, alle empty/!is_polymorphic/static-dispatch):** (A) `ExtensionHardwareAxis<Derived>` […] (B) `HardwareManagerSystemAxis<Derived>` trägt `extensions = mp_list<…>` + `mp_for_each`-Iteration, (C) `MetaMetaAxisConcept<A,Manager> = ExtensionHardwareAxisConcept<A> && mp_contains<Manager::extensions,A>`. […] **Generalisierung:** dasselbe Manager-Muster für Compiler- und ISA-Achse (alle Freigabe-Haupt-Achsen)."

**Teil B „Meta-Meta-Achsen tragen EIGENE Unter-Achsen (RT-dynamisch)" = NICHT DOKUMENTIERT.**
Gezielter grep ueber das gesamte `docs/`-Verzeichnis nach Ko-Vorkommen `meta-meta` × `unter-achse|unterachse` innerhalb desselben Satzes: **0 Treffer**. Die 13–14 AVX512-Flag-Subsets sind in LED:2693 explizit als **„Domäne"** (= Werte-Menge der Haupt-Achse) benannt, **nicht** als Unter-Achsen. Naechstliegende generische Regel, die es *implizieren wuerde*:
> **LED:2150** (§28, 2026-07-19, User-Direktive verbatim-treu) — "Bezüglich der Achsen-Registries trägt **immer eine Haupt-Achse (statisch im Ziel-Binary) auch optionale Unter-Achsen-Einstellungen (meist dynamisch im Ziel-Binary)**."

⇒ Aus §28 + „Meta-Meta ist VOLLE Haupt-Achse" folgt logisch, dass Meta-Metas Unter-Achsen tragen — **explizit geschrieben steht es nirgends**. Das ist ein echter Doku-Riss, nicht nur ein Verstaendnis-Riss.

**Neu im Fenster, ergaenzend (Identitaet + Mitgliedschaft):**
> **SESS26:35-46 (R-E)** — "**R-E Meta-Meta-Identitaet war falsch dargestellt**: Die Meta-Meta-Haupt-Achsen auf dem variadischen Array hinter load_framework (Metaprogrammierung OHNE std::variant) sind FESTE Bestandteile der Maschinen-Identitaet. Identitaet ist NUR AUFWAERTS kompatibel […] **extension_hardware = offizieller Command-Pattern-HUB** der Hardware-Meta-Meta-Haupt-Achsen; seine Identitaet IST exakt deren Konfiguration."

> **SESS26:22-26 (R-C)** — "**R-C load_framework ist faelschlich System-Haupt-Achse** — technisch META-META-Achse […] Verortung: in der CEB korrekt am ENDE, aber stets die ERSTE Meta-Meta-Achse; dahinter folgt das variadische Array der Hardware-Meta-Metas."

> **MEM-BEST:20** — "**NEUE REGRESSION R-F:** AVX und SIMD gehoeren zu den META-META-Achsen (nicht Unter-Achse von extension_hardware) — konsistent mit R-E (ext_hw = Hub ALLER Beschleuniger)."

> **LED:3247** (§62-D) — "Die Identitaet ist eine AEQUIVALENZKLASSE MODULO UNGENUTZTER META-META-ACHSEN (GPU/FPGA/NPU usw. zaehlen NICHT zur Kern-Identitaet). BEDINGUNG: zaehlt die Erweiterung einer Meta-Meta-Achse per Stempel zur KOMPILIERTEN Binary, MUSS die assimilierende Maschine sie ebenfalls unterstuetzen"

---

## (4) CT/RT als Haupt/Unter-Kriterium — dokumentiert, aber NIE als „das EINZIGE"

**Ursprungs-Direktive (User woertlich, LED:2031, §24-Kopf, 2026-07-18):**
> "Weiterer Hinweis zu Haupt-Achsen: sie sollten **in der Regel** statische Einstellungen beinhalten die zur compile time gesetzt und fest verdrahtet sind, hingegen haben Unter-Achsen **in der Regel** runtime Eigenschaften innerhalb des Programmes. Weil wir aber eine Kette Experiment-Planer -> CEB -> Tier-Binary laufen, sind die dynamischen Einstellungen der vorhergehenden Stufe, oft die zu übernehmenden compile Time Drähte der gebauten nachfolgenden Stufe."

> **LED:2040** (§24.C) — "**Haupt-Achsen** = i.d.R. **statische, zur compile time fest verdrahtete** Einstellungen. **Unter-Achsen** = i.d.R. **Runtime-Eigenschaften** im laufenden Programm. **ABER** durch die Kette **Experiment-Planer → CEB → Tier-Binary** gilt: die **dynamische Einstellung der Vorstufe ist oft der compile-time-Draht der gebauten Folgestufe.** ⇒ „statisch/dynamisch" ist **stufen-relativ**"

**Staerkste Formulierung als ENTSCHEIDUNGS-Kriterium (§51-B8, LED:2671, User-Entscheid 20.07.):**
> "Die **6 System-Achsen sind korrekt** und werden durch eine **7. NUMA/Locking-System-Achse** erweitert — **SOFERN** deren Eigenschaften **compile-statisch** erkennbar sind (dann Haupt-Achse); ansonsten ist es eine **dynamische System-UNTER-Achse zur Laufzeit**, die bei Messungen an die Tier-Binaries als Variable delegiert wird."

⇒ Das ist die einzige Stelle, an der CT/RT **als Klassifikations-Entscheid** (Haupt XOR Unter) operationalisiert wird — dort tatsaechlich als *hinreichendes und notwendiges* Kriterium.

**Weitere Belege im Fenster:**
> **LED:2266** (§37, Punkt 4, User verbatim-treu 19.07.) — "**Die Freigabe betrifft NUR statische System-HAUPT-Achsen** — NICHT die dynamischen System-UNTER-Achsen, die (wie etwa **Threads**) als **Runtime-Variable an die Tier-Binaries als Direkt-Einstellung für eine Messung durchgereicht** werden."

> **LED:2270** (§37-Einordnung) — "Statisch-Haupt (Freigabe) vs dynamisch-Unter (Runtime-Durchreichung, z.B. thread_count als RC-POD) bleibt die §28-Haupt/Unter-Semantik."

> **LED:2152** (§28-Einordnung) — "**Haupt-/Unter-Semantik im Angebot:** Haupt-Achse = CT-statisch einkompiliert (binary_id bei Organ; build_version/Sidecar bei System); ihre Unter-Achsen-Einstellungen = meist **dynamisch im Ziel-Binary** (RC-POD/DynamicDims/Runtime-Werte)"

> **LED:3404-3409** (§66-NACHTRAG-3, MAPPING-REINHEITS-DOKTRIN, User 23.07., KERN=Gesetz) — "std::variant ist in CEB und Tier-Binaries STRIKT VERBOTEN — es mappt eine RUNTIME-Variable auf ein COMPILE-TIME-Ziel und bloated die Binary […] nur compile-time -> compile-time und runtime -> runtime Abbildungen akzeptiert; KEINE runtime->compile-time-Bruecken. ERLAUBT: verschiedene RUNTIME-Varianten der UNTER-Achsen auf dieselben COMPILE-TIME-HAUPT-Achsen (§59-Haupt/Unter-Prinzip)."

> **SESS26:48-52 (§3 DUAL-NATUR)** — "**DUAL-NATUR (Haupt/Unter ist stufen-relativ)** — load_framework und Mess-Tooling sind LAUFZEIT-Unterachsen auf dem PLANER und COMPILE-TIME-Haupt-Achsen auf der CEB (bestaetigt die §24-Regel: dynamische Einstellungen der Vorstufe = CT-Draehte der naechsten Stufe)."

**Nicht dokumentiert:** die Exklusivitaets-Aussage „CT/RT ist das EINZIGE Haupt/Unter-Kriterium". Die Doku sagt durchgaengig „in der Regel" (LED:2031/:2040/:2152) und fuehrt **konkurrierende Kriterien** mit, die im Fenster real fuer Umsortierungen benutzt wurden — z.B. **fachliche Zugehoerigkeit** (SESS26:20-21 R-B: "scheduling […] real UNTER-Achse von target_isa (die CPU managed/verschiebt alle Daten einer Maschine)") und **Untrennbarkeit/Gruppe** (SESS26:32-34 R-D: "untrennbar: nur bestimmte Compiler bieten bestimmte Handles"). Diese Begruendungen sind NICHT CT/RT.

---

## (5) `operating_system` als Komplex-Haupt-Achse mit den 4 RT-Unter-Achsen

**Dokumentiert ist NUR: OS = normale System-HAUPT-Achse (NEU) mit 4 Unter-Achsen. „Komplex" steht dort NICHT.** Vollstaendige Belege:

> **SESS26:11-14** (§1 BINDENDE ACHSEN-SORTIERUNG) — "Verzeichnisbaum-/Ordnungs-Kette: (1) MESS-TOOLING (Mess-Haupt-Achse; measurement_category = ihre Unter-Achsen) -> (2) target_isa -> (3) **operating_system (NEU)** -> (4) extension_hardware -> (5) ORGAN-Achsen (T00-T16, unveraendert) -> letztes Haupt-Blatt -> 3 Unter-Ebenen: Mess-Unter -> System-Unter -> Organ-Unter."

> **SESS26:18-19** (R-A) — "**R-A operating_system fehlt** als System-Haupt-Achse. NEU bauen; Unter-Achsen: os_version, kernel, build, update_zustand."

> **MEM-ACH:13** — "target_isa -> operating_system (NEU, Unter: os_version/kernel/build/update_zustand) -> extension_hardware"

**Der Widerspruch, den der Owner meint, ist damit belegbar:**
- Die dokumentierte Komplex-Haupt-Achse (SESS26:28-29) ist **`target_isa x extension_hardware x Meta-Meta-Achsen (ohne load_framework)`** — `operating_system` ist **kein Glied** dieser Rekombination, obwohl es in der Sortierung (SESS26:12) **zwischen** target_isa und extension_hardware steht.
- Die 4 OS-Werte sind in SESS26:19 **nur „Unter-Achsen"** genannt, **ohne** CT/RT-Attribut.
- Die Korrektur existiert bislang **ausschliesslich** in **MEM-ACH:28** (nicht im Ledger, nicht in SESS26): "**Q-2 KORREKTUR: operating_system ist KOMPLEX-HAUPT-ACHSE** (CT-statisch), seine 4 Werte (os_version/kernel/build/update_zustand) sind UNTER-Achsen = laufzeit-dynamisch. **NEUES LAYER-MODELL: Haupt-Achsen haben Layer/Rekursivitaet nach Command-Pattern; auch META-META-ACHSEN SIND HAUPT-ACHSEN (CT!), die selbst Unter-Achsen tragen.** Owner: \"hier stimmt das Verstaendnis ueber die letzte Woche gar nicht\" -> ultracode-Erhebung beauftragt."

**Ist-Stand Code (read-only verifiziert im Planungs-Workflow 26.07.):**
> **`docs/sessions/backups/20260726-strukt-r-planung-workflow/ergebnisse/03-modus-suffix-welt-a288b88b.md:121`** — "**Kein `+os`-Segment, kein `+sched`-Segment** (verifiziert: `grep -rn \"operating_system|os_version|update_zustand|persistence_target\"` -> **0 Treffer im gesamten Code/**)."

> **`.../ergebnisse/01-system-welt-a51c70a7.md:117` (RISS 7)** — "`scheduling`/`load_framework`/`operating_system` haben keinen POD, keinen Parse-Zweig und keinen XSD-Typ."

Und die offene Teilfrage, die genau am CT/RT-Kriterium haengt:
> **`.../ergebnisse/00-bauplan-a67e501b.md:219` (Q-2b)** — "`update_zustand` (Paket-Stand) aendert sich **ohne Code-Aenderung**. Als CT-Achse ist er strukturell luegen-anfaellig."

---

## ZUSAMMENFASSUNG DER DOKU-RISSE (was wirklich fehlt, nicht nur missverstanden)

| # | Behauptung des KERN-Modells | Doku-Status | Beleg |
|---|---|---|---|
| A | Haupt-Achsen bekommen Layer/Schichtungen; mehrere verhalten sich wie EINE (Command-Pattern) | **1 Satz, 1 Quelle, nicht im Ledger** | SESS26:29-32 |
| B | Rekursivitaet der Haupt-Achsen-Struktur | **nur 2-schichtig („managende Haupt-Achse anderer Meta-Meta-Achsen"), Wort „rekursiv" nie fuer Achsen** | LED:2730; „rekursiv" nur Dock LED:1648/447/1912 |
| C | Meta-Meta = Haupt-Achse, CT-statisch | **wortgenau, 5-fach** | LED:2677/2693/2723/2730/2753 |
| D | Meta-Meta tragen EIGENE Unter-Achsen (RT) | **NICHT dokumentiert** (0 grep-Treffer); nur generisch aus §28 ableitbar; AVX512-Flag-Subsets sind explizit „Domäne", nicht Unter-Achse | LED:2150 vs. LED:2693 |
| E | CT/RT = das EINZIGE Haupt/Unter-Kriterium | **dokumentiert als „in der Regel" + stufen-relativ**; als Entscheid-Kriterium nur in §51-B8; im Fenster wurden R-B/R-D real mit FACHLICHKEIT/UNTRENNBARKEIT begruendet, nicht mit CT/RT | LED:2031/2040/2671/2266/3409; SESS26:20-21/32-34 |
| F | `operating_system` = Komplex-Haupt-Achse mit 4 RT-Unter-Achsen | **NICHT dokumentiert**; SESS26 fuehrt OS als *normale* System-Haupt-Achse und schliesst es aus der Komplex-Rekombination aus; Korrektur existiert nur in MEM-ACH:28 | SESS26:18-19/28-29 vs. MEM-ACH:28 |
| G | Spannung Buendelung vs. Klammerung | **beide KERN=Gesetz, nicht versoehnt** | SESS26:31 („wie EINE") vs. LED:3311 („NIE verschmolzen") + LED:3412 („IMMER … KLAMMERN") |

**Persistenz-Empfehlung (nicht ausgefuehrt):** Ein Ledger-§67 „LAYER-MODELL DER HAUPT-ACHSEN" fehlt vollstaendig; SESS26 + MEM-ACH:25-33 (Q-Antworten) sind derzeit die einzigen Traeger, und MEM-ACH:28 revidiert SESS26 ohne Gegen-Eintrag in SESS26 selbst.

SELBSTCHECK: read-only Erhebung, keine Datei geaendert (nur Read/Bash-grep/awk/sed). Alle Zeilennummern aus Live-Lesung am 26.07.2026. Nicht-ASCII ausschliesslich innerhalb wortgenauer Zitate (Umlaute/Pfeile der Originalquellen) plus `§`.