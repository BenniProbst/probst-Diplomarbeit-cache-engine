# KON19-EXPLORE-SYNTHESE — E-A · E-B · E-C · E-D · E-E (12.08.2026)

**Grundlage:** Fünf Stränge, je bis zu drei Quellen-Schnitte (Doku / Code / Roh-Transkripte) plus skeptische Gegenprobe am Objekt (ce-HEAD `670483c0`, super-Arbeitsbaum, beide Roh-Transkripte: `46375cdc` = 314 MB, `5a19728e` = 224 MB).

**Lesehinweis Zeilennummern:** Der Ledger ist ein lebendes, am Kopf wachsendes Dokument — er wuchs allein während der Gegenproben von 22386 auf 22856 Zeilen (Beleg: EE-/EB-Prüfung, wc-l-Messungen). Ledger-Zeilenangaben sind Momentaufnahmen; **stabile Anker sind die Abschnitts-IDs** (KON19-01, KON21-01, §69.6, W-2, N-3, S5-06 …). JSONL-Zeilennummern der Roh-Transkripte sind dagegen stabil.

**Qualitätsvermerk:** Drei der fünfzehn Agent-Antworten waren Test-Stubs („TEST", Belege „a/b": E-B Fund 3, E-E Funde 1+2). Die Gegenproben haben sie verworfen und die Lücken selbst am Objekt geschlossen (E-E: eigene vollständige Transkript-Klassifikation; E-D: fehlender Transkript-Schnitt durch die Gegenprobe nachgeholt). Kein Stub ist in die Ergebnisse eingeflossen.

---

## 1. JE STRANG: DIE ANTWORT

### E-A / O-4 — Festplatten-IO als Organ-Meta-Meta, SIMD als System-Meta-Meta — Sicherheit: wahrscheinlich

**Owner-Wort (12.08., KON19-01; Rohtranskript `5a19728e:43879`, human-verifiziert, Rohtext mit Tippfehler „Meta-Mata-", im Ledger sauber transkribiert):**
> „O-4 ist nicht leer, SIMD ist auf der System-Achse bereits eine valide Erweiterung (das IST die Meta-Meta-Achse) und auf Organ hatten wir doch gesagt, dass das Festplatten IO eine solche Achse ist, weil das Genus SearchAlgorithm in der Regel nur im RAM arbeitet, aber die IO Achse erweitern kann. [...] Organ-Meta-Meta-Achsen werden je Tier-Binary und damit je Gattung+Genus verknüpft."

**Die Antwort:** Das „hatten wir doch gesagt" ist als wörtliche Meta-Meta-Entscheidung **nicht auffindbar** — dreifach unabhängig geprüft (Volltext docs/ inkl. Backups; Code; beide Roh-Transkripte). Die Wortverbindung „Festplatten-IO = Meta-Meta-Achse" erscheint vor dem 12.08. nirgends; alle drei „Festplatte"-Treffer im Altbestand sind thematisch fremd (18.07. std::variant-Speicherplatz; 09.08. Build-Cache-Speicherort, `5a19728e:28852`; KON19 selbst). Die **Substanz** der Owner-Begründung existiert dagegen vollständig — als Entscheidung vom **26.07.** (Owner-GO): „NEUE 18. ORGAN-HAUPT-ACHSE `persistence_target` [...]: unterscheidet, ob ein Algorithmus nur in Memory arbeitet oder auf Platte zurückschreiben muss [...] KONSEQUENZ: binary_id 17→18" (docs/sessions/20260726-SESSION-achsen-neuordnung-…:81-87) — fast wortgleich zur heutigen Begründung, aber als **Hauptachse**, nie als „Meta-Meta". Warum damals keine Meta-Meta wählbar war, ist chronologisch zwingend belegt:

1. **26.07.** — Owner-Definition: „Haupt-Achsen eines statischen Arrays unter einer Manager-Haupt-Achse heißen Meta-Meta-Achsen" (E-08) und erster Beleg eines Organ-analogen Arrays (E-10/nr798-B3org; beide docs/sessions/20260726-SESSION-wahrheits-anker-…:44-49/54-56)
2. **27.07.** — OP-11-Verbot: „KEINE Meta-Meta-Einträge in dieser Zeile (RF-7)" (docs/sessions/20260727-PLAN-o8-fenster-…:813-822)
3. **02.08.** — Owner-E2 hebt das Verbot auf (verbatim in organ_meta_meta_axis.hpp:1-24)
4. **12.08.** — erster konkreter Inhaltsvorschlag (Festplatten-IO)

Der Owner benennt also eine echte alte Entscheidung heute erstmals als „Meta-Meta" um — Präzisierung, keine Widerlegung seiner Aussage.

**Am Objekt existiert:**
- **SIMD als System-Meta-Meta, gebaut und bewiesen:** `SimdExternalUtilsFamily final : ExternalUtilsFamilyAxis<…> : SystemMetaMetaAxis<…>` — einzige Instanz im Repo, eigene `axis_code_version="1.0.0.c"`, eigene `SimdSubAxis` (no_extension/avx2/avx512, gcc/clang-Flags symmetrisch), 17 static_asserts, verwaltet vom `ExternalUtilsHub` mit `MetaMetaMembers<SimdExternalUtilsFamily>` (external_utils_family_axis.hpp:71,96-105,150-213). Zwei ehrliche Einschränkungen im Code selbst: `axis_kind()` meldet noch `system_config` (Umschaltung bewusst ins Byte-Fenster hinter O-8 verschoben, Tripwire :115-119); der Hub hat „heute NULL Konsumenten" (:198) — die real ankommenden `-mavx2/-mavx512f`-Flags laufen über einen getrennten, lebenden Kanal, dessen tatsächlicher Ort `profile_facade/profile_run_facade.cpp:200,702-720,1262-1280` ist (Gegenprobe; der Kommentar-Verweis auf `permutation_codegen_tool.cpp` ist stale — 0 find-Treffer).
- **Der Organ-Meta-Meta-Mechanismus:** `OrganMetaMetaAxis<Derived>` (topics/organ_meta_meta_axis.hpp:52-60; Datei 84 Zeilen) mit Diskriminator `organ_meta_meta` (AxisKind, topics/axis.hpp:17-49), bewusst NICHT von OrganAxis abgeleitet (:33-37). Beweis-Typ `ProofOrganMetaMeta` lebt in tests/unit/test_striktheit_axis_dach_guard.cpp:186-201 (Korrektur der Gegenprobe: nicht in der Achsen-Datei).
- **Die IO-Substanz als zwei reguläre Organ-HAUPTACHSEN:** `io_dispatch` Slot **T12** (4 Bausteine, alle ON, ce-CMakeLists.txt:450-453; existiert seit 2026-05-28, PAPER_REFERENCES.md:2) und `persistence_target` Slot **T17** (MemoryOnly ON; DiskWritebackTarget vollständig gebaut, aber per Owner-Entscheid Q-1/Fall B OFF, CMakeLists.txt:462-463; `has_device_writeback_path()==false`, axis_persistence_target_disk_writeback.hpp:67). Beide binary_id-permutierend (cache_engine_axis_registry.xml:83,125 — insgesamt 18 Organ-Hauptachsen T00–T17, bestätigt gegen UML-Atlas :137/:299), beide von `OrganAxis<Derived>` erbend (axis_io_strategy_base.hpp:13; axis_persistence_target_strategy_base.hpp:18). Alle IO-Strategien sind ehrlich deklarierte **RAM-Simulationen** („Hauptagent-Entscheid: io = In-Memory, KEIN Disk-IO", axis_io_dispatch_observable.hpp:13). Das vendorte liburing gehört zum CEB-Spool-Writer, nicht zu diesen Achsen (apps/cache_engine_builder/CMakeLists.txt:37-48 — Grep-Falle).

**Am Objekt fehlt:** jeder Organ-Meta-Meta-**Inhalt** — `abi::OrganMetaMetas = MetaMetaMembers<>` leer, dreifach wortgleich bestätigt (anatomy_version_stamp.hpp:51; organ_meta_meta_axis.hpp:19-20; meta_meta_stamp_suffix.hpp:149); die Organ-Stempelzeile bleibt klammerlos. Bindungsmechanismen vorhanden, aber inert (meta_meta_admission.hpp: „KEINEN Produktions-Konsumenten"; simd_organ_requirement.hpp:40-50,87-91: 9 Organ-Klassen, alle `kRequiredNone`). Eine wörtliche „je-Tier-Binary"-Vorentscheidung existiert nicht — sie folgt aus der stehenden Doktrin GENUS_impl → EXAKT EIN Tier-Binary.

**Konsequenz (Additiv-Doktrin):** Eine Festplatten-IO-Meta-Meta wäre ein **neuer, additiver Typ** über der OrganMetaMetaAxis-Wurzel — die bestehenden T12/T17-Hauptachsen bleiben unangetastet gültig; „Umklassifizierung" wäre strukturell ein Neubau neben dem Bestand (andere Wurzel, andere Pflichten), kein Umbenennen.

---

### E-B / K2 — Hybrid: Schichten und Eigenschaften — Sicherheit: belegt

**Kernergebnis:** K2 ist **beantwortet — zweimal**, und keiner der drei Explore-Agenten hatte die jüngste Fassung:

1. **09.08.** (Ledger, NACHTRAG-Konsolidierung, aktuell ~Z.8396): „K2 — Loader-Extraktion: JA [...] der Loader wandert in eine stufen-neutrale Bibliothek, weil das Prüfdock der CEB und das Prüfdock der Hybrid-Tier-Binary jeweils technisch identisch bei Konfiguration sein müssen."
2. **12.08., KON21-01 „K2 BEANTWORTET"** (aktuell ~Z.262-301) — die geltende, reichere Neufassung; Volltext und Auflösung in **Abschnitt 2**.

Verhältnis: **Verfeinerung, kein Widerspruch** — die Kernaussage „gemeinsamer, nicht duplizierter Lade-Code" bleibt in beiden Fassungen; neu am 12.08. sind Betriebsarten-Modell, Autonomie-Stufe und Sync-Kanal. Die Owner-Rückfrage von heute („Bitte erkläre mir K2 [aber alle Schichten und Eigenschaften von Hybrid sind im session log geplant - explore]", KON19-02) trifft zu: alles steht im Log — die 11.08.-Owner-Vorlage hatte lediglich die 09.08.-Antwort nicht mitgeführt (O-5-Abschnitt ohne Verweis, docs/plaene/20260811-OWNER-VORLAGE-…:160-171), wodurch K2 in KON18/KON19 als offen weiterlief.

**Am Objekt existiert (ce):** Gattung/Genus-Enums `HeuristikAdapter=3` / `FunctionInterfaceReroute=5` verdrahtet (anatomy_base.hpp:89,169,196-199); „Weg C" statisch erzwungen — **kein sechstes Prüfdock** (`pruef_dock_version_for(FunctionInterfaceReroute).empty()`, pruef_dock_version.hpp:199-206; Registry-Größe bleibt 5, test_e24_c4_genus_pruef_docks.cpp:360-401); Concept-Gate mit drei Schranken S1–S3 inkl. echtem Negativ-Compile-Test (heuristik_adapter_gate.hpp:22-35; tests/unit/CMakeLists.txt:2064-2078); Strategy-Skelett je bedientem Genus (5 Spezialisierungen, heuristik_adapter_strategy.hpp:127-171); 2D-Synthese-Matrix (Tiefe=1, Nodes=32 Default, synthese_matrix.hpp:81-87); ABI-Slot `visit_hybrid_reroute` seit Major 9 Vertragsteil, Emitter bewusst 0 bis HY-A2 (mess_visitor_abi.hpp:101-133; test_naht1:233-235 „lebend 0"); K1 im Lager umgesetzt (lager_gattung_token `heuristik_adapter`, 4 Gattungen / 6 Genera, test_lb0:551-616); Break-Even-Scaffolds vorhanden, aber nicht angebunden (best_binary_selector.hpp:360-466; decision_lambda_trees.hpp).

**Am Objekt fehlt:** die drei geplanten Loader-Bausteine `hybrid_dock_factory.hpp` / `hybrid_dock_array.hpp` / `hybrid_binary_proxy.hpp` (0 find-Treffer); jede Produktiv-Verdrahtung (0 „Hybrid"-Treffer in apps/ und im echten Loader-Code module_loader/anatomy_module_loader); der `<hybrid_tier>`-XML-Typ (nur HY-D2-Kommentar-Reserve, experiment_schema.xsd:102-124: „KEIN Typ, KEIN Parser, [...] KEIN Byte-Effekt"); der **Sync-Kanal CEB↔Hybrid** aus KON21-01 (neues Bauteil, bisher nirgends erwähnt); der Emitter der vierten Mess-Ebene (HY-A2). hybrid/README.md (Stand 09.08., 21:26 UTC, Commit e19b72c8) führt K2 noch als offen — normaler Doku-Rückstand hinter der heutigen Owner-Antwort, keine Diskrepanz.

---

### E-C / O-13 — Herkunft von `--dump-plan` / `PlanTextBuilder` — Sicherheit: belegt

**Owner-Wort (12.08., KON19-04; Rohtranskript `5a19728e:43879`, human-verifiziert):**
> „O-13: Das sollte eine Director Methode sein, aber wir müssen mit explore die Quelle bestimmen, weil ich diesen Begriff nicht geprägt habe und auch die Funktion nicht mehr kenne. Ich denke es ist überholt in der heutigen Konstellation und wird nicht mehr benötigt."

**Antwort — Herkunft:** Der Owner hat recht, **beide Begriffe stammen nicht von ihm.** `--dump-plan` wurde am **16.07.2026, 22:52 UTC** von einem Opus-Subagenten geprägt (Design-Dossier, Kopf „Read-only (Opus)", docs/plaene/20260716-…-DOSSIER.md:1-3,21; Erst-Treffer `46375cdc:44755`; der Auftrags-Prompt des Subagenten enthielt das Wort nachweislich nicht — `46375cdc:44717`, 0 Treffer). `PlanTextBuilder` + „Fork B" folgen am **19.07., 03:03 UTC** aus einem 7-Agenten-Syntheselauf (`46375cdc:58548`; docs/plaene/20260719-…-BAUPLAN.md:185: „ist `--dump-plan` (I1) ein dritter trivialer `PlanTextBuilder` [...] oder eine Director-Methode? Bestätigen."). Über beide Transkripte wurden **alle 353 Fundstellen** strukturell klassifiziert (Gegenprobe; Schnitt 3 zählte 396 inkl. Eigen-Echo des laufenden Laufs): **0 mit Owner-Herkunft.** Fork B wurde noch am 19.07. agentisch entschieden („B: ja [sauberer Contract-Test]", FINALES-DESIGN-ABSTRACT:98) und am selben Tag gebaut (ce `c9240477`, 12:51:55 UTC) — ein Owner-GO dazu ist nirgends dokumentiert. Die Ledger-Selbstnotiz („vermutlich 19.07.-Bauplan, Fork B, meine Formulierung") ist damit präzisiert: für PlanTextBuilder/Fork B richtig, für das Flag drei Tage zu spät datiert (16.07., andere Session).

**Zweck:** deterministische, byte-reproduzierbare Zeilentextform des Plans (Format v1.1), golden-neutral, exit 0 ohne Bau/Messung — Contract-Test-Basis und menschenlesbare Kontrolle („Der Plan-Text ist die Form, in der ein Mensch den Plan [sieht]", test_experiment_plan_director.cpp:3291). Nie ein kettentreibender Emitter.

**Am Objekt (ce-HEAD `670483c0`, 12.08. direkt geprüft — schließt die offene Frage von Schnitt 1) — zwei getrennte Schicksale:**
- **Das Flag-Wort `--dump-plan` ist tot, und zwar absichtlich:** seit W1 (05.08., super-Commit `1a3f1f42`, 13:30:21 UTC) beantwortet der Alt-Treiber es nur noch mit Verweiszeile + rc=1 (Code/02_messung_driver/main.cpp:472-486); in der neuen Planer-Binary existiert die Flag-Form nicht („die DEPRECATED Treiber-Flags (--dump-plan & Co.), die bewusst nicht mitwandern", apps/experiment_planner/main.cpp:681).
- **Die Substanz lebt und ist produktionskritisch:** `class PlanTextBuilder final : public IPlanBuilder` (experiment_plan_director.hpp:389), einer von **6** ConcreteBuildern an EINEM Director (:2049); CLI heute `comdare-experiment-planner plan dump` (main.cpp:170-176,728); Byte-Determinismus-Tests (:207,266,1092); hart gegateter CI-Job `visibility:tier-binaries` ohne allow_failure (.gitlab-ci.yml:1394-1436); realer Downstream-Parser `parse_plan_dump()` (tier_binary_report.hpp:132); gelandet 05.08. (Merge `3bf03b01` + Hotfix `60c7c56a`, Pipeline 14674 = success, Gate 405); 55 Commits, gepflegt bis 11.08. (`346b6da9`).

**Einordnung:** Die Owner-Frage entstand aus **vergessener, nicht ungebauter** Arbeit (Wellenplan 08.08.:1658 führte S-8 Teil 1 noch als Zukunft, obwohl drei Tage älter gelandet). Der KON16-03-„Offene Widerspruch" trifft textlich den `CiYamlBuilder`, nicht den PlanTextBuilder — dieser hat nie beansprucht, Kettenglied zu sein. → Urteil als Bau-Posten: **Abschnitt 3.2**.

---

### E-D / T-15b — Prüfdock-Retry: die „bis zu 5 Wiederholungen" — Sicherheit: belegt

**Owner-Wort (12.08.; Rohtranskript `5a19728e:43879`, human-verifiziert = Quelle von KON19-07, wortgleich):**
> „T15b: Das galt doch für den gesamten Messdurchlauf der CEB eines Tier-Binaries am Prüfdock bei failed Ausführung. Die eigentliche success Messung wird ja 3 Mal wiederholt wie geplant - der Mechanismus hier ist ein Robustheitskriterium. Bitte lies das mit Explore nochmal genau nach."

**Originalstelle (GOAL-v8-DOSSIER VI.5, 08.08.; docs/plaene/20260808-GOAL-V8-DOSSIER-…:471-474, Zwilling Lesefassung:122):**
> „Drift-Gate 5% über 3 Wiederholungen; bei Überschreitung den ganzen Lauf neu starten — ein fremder Verbraucher ist aktiv, den man abwarten muss. Beim Scheitern bis zu 5 Wiederholungen. Ein gescheiterter Algorithmus schreibt ‚failed' in die Zelle — nie null, nie leer — und der Lauf misst weiter."

**Antwort:** Der Owner-Satz enthält **zwei verschieden große Mechanismen** (Zwei-Skalen-Befund der Gegenprobe): **T-15a** = Drift-Überschreitung → „ganzen Lauf neu", wobei der Owner „ganzer Lauf" im selben Turn als die gesamte Kampagne definiert („der Lauf über alle Batches an builds und Messungen und Auswertung [...] alles") — Granularität weiter offen (KON18-02). **T-15b** = Scheitern → bis zu **5** Wiederholungen des **gesamten Messdurchlaufs EINER Tier-Binary am Prüfdock**, Charakter Robustheitskriterium. Die S5-06-Registerzeile (09.08.) bündelte beide Sätze in eine Zeile — Mitursache der Fehlzuordnung.

**Am Objekt existiert — die 5 ist heute falsch verdrahtet**, auf der Drift-Instabilitäts-Achse: `DriftGateConfig::max_reruns = 5` (drift_gated_cell.hpp:120; eingezogen mit Commit **ce `4cd1ab91`, 09.08.** — per git log verifiziert, schließt Schnitt 1s offene Frage), durchgereicht in measure_under_setting (iterator :2948-2958, „[T-15-KLAMMER]"), gespiegelt in xml_config_parser.hpp:288/.cpp:361 und planner_mengen_types.hpp:127,319-324, gepinnt in test_t15_drift_gate_messschleife.cpp:249-257 („Owner-Zahl 5"). Drei weitere Ripple-Stellen fand erst die Gegenprobe: iterator :372-383 (sechste Kommentarstelle mit derselben Fehlzuordnung), checkpoint_speicher.hpp:119-123 (Arena-Formel „mit den Vorgabewerten 3 und 5 [...] bis zu 18 Durchläufe je Zelle" = 3×(5+1)), profile_run_facade.cpp:1564,1577. Der damalige Bau-Agent dokumentierte die richtige Lesart selbst und baute sie bewusst nicht: „Diese zweite Achse existiert im Code NICHT, weder hier noch in perm_runner, und wird hier auch nicht erfunden." (drift_gated_cell.hpp:112-116).

**Am Objekt fehlt:** Ein failed-Retry des gesamten Prüfdock-Durchlaufs existiert **nirgends** — jeder Aufrufpfad endet nach genau einem Versuch (`measure_one_binary`: einziger Aufruf iterator :3127; Sequencer: eine for-Schleife, ein `dock->measure()` je Handle, pruef_dock_sequencer.hpp:69-85; perm_runner klassifiziert `SampleStatus::Failed` je Einstellung und kehrt zurück, :175-186/:346-361; 0 Retry-Treffer in pruef_dock/, apps/, ci/ — doppelt gegengeprüft). Die „3 Mal wiederholte success Messung" existiert doppelt: **KF-10** `n_repeats=3` (separat dokumentiert, „NIEMALS interpoliert/gemittelt", repetition_plan.hpp:1-8,28; experiment_run_entry.hpp:86) und Drift-Gruppen-`reps=3` (drift_gated_cell.hpp:100) — der Owner meint mit hoher Wahrscheinlichkeit KF-10 (nur dort entstehen 3 separat sichtbare Zeilen; Indiz, unbewiesen). → Korrigierter Bau-Posten: **Abschnitt 3.1**.

---

### E-E / OD-7 — die 16-Kerne-Entscheidung — Sicherheit: belegt (Timeline); Interpretation offen

**Owner-Wort (12.08., KON19-09; Rohtranskript `5a19728e:43879`, human-verifiziert):**
> „OD-7: Das ist schon entschieden - explore. Aber es müssten 16 Kerne sein."

**Antwort:** Eine frühere 16-Kerne-**Entscheidung** existiert **nicht** — im Gegenteil. Vollständige, human-klassifizierte Timeline (beide Transkripte; genau **vier** echte Owner-Äußerungen zur Zahl):

| Datum | Quelle | Owner-Wort (verbatim) |
|---|---|---|
| 22.07., 08:52 | `46375cdc:71566` | „...prod1 32 Threads und 24 Kerne und prod2 hat 24 Threads und 16 Kerne..." — Ursprung der falschen 24 (Werte zwischen den Maschinen vertauscht) |
| 26.07., 18:53 | `46375cdc:82844` | „OD-7: 24 **Worker** für prod1 und alle Threads für prod2 bei Tier-Binary build oder Messung bei concurrency 1, sonst prod1 concurrency 2 mit je 12 Threads [...]" → wörtlich Ledger §69.6 |
| 06.08., 09:34 | `5a19728e:1331` | „OD-7: Bitte direktive durchsetzen." |
| 10.08., 07:27 | `5a19728e:33224` | „[...] OD-7 lassen wir so." — in Kenntnis des 16-Kerne-Befunds |
| 12.08., 06:49 | `5a19728e:43879` | „Das ist schon entschieden - explore. Aber es müssten 16 Kerne sein." |

Zwischen 10.08., 07:27 und 12.08., 06:29 existiert **keine** weitere Owner-Äußerung zu OD-7 (34 Treffer im Fenster einzeln klassifiziert, 0 human — Gegenprobe). Die Hardware-Tatsache ist seit 09.08. gemessen: prod1 = **16 physische Kerne / 32 Threads** (AMD Ryzen 9 9950X3D; lscpu; Memory-Datei modified 2026-08-09T14:46:56Z).

**Entscheidender Befund (Präzisierung, keine Widerlegung):** Beide Male, als gefragt wurde (10.08. `:33169` und 12.08. `:43864`), hat der **Assistant** OD-7 als „setzt 24 **Kerne** voraus" beschrieben — der Owner-Originalwortlaut (26.07.) sagt durchgehend „**Worker**", nie „Kerne". Die zwei scheinbar widersprüchlichen Owner-Antworten („lassen wir so" vs. „müssten 16 Kerne sein") sind daher möglicherweise Antworten auf **zwei nie sauber getrennte Fragen**: (a) operativer HEAVY-Worker-Deckel, (b) Hardware-Kernzahl.

**Am Objekt hängt an der Zahl:** §69.6 „HEAVY [...] prod1=24 Worker" (Ledger, aktuell ~:14206); `runner-mode.sh:43` `HEAVY_J=24` (Commit `0d7c577`, 27.07. — der Code trägt weiter fest 24, keine 16-Kappung; das 06.08.-Handout :100-106 bestätigt: „KEIN Code-Beleg" für ein 16-Cap); W-2-Block inkl. Warnung „Wer die 24 pauschal streicht, streicht OD-7 mit" (~:5033-5057); zwei unkorrigierte „prod1 = 32 Threads / 24 Kerne"-Zitate (~:13907, ~:13972); N-3/N-4-Kapazitätsrechnung auf „24 Worker je Lane" (0,284 s × 24 = 6,8 s; 64 Slices × 19,4 min = 20,7 h; ~:15570-15589). Die ETA-Kernformel rechnet mit **Threads (32, korrekt)** — der Mess-Deckel hängt primär nicht an 16-vs-24. **Fehlt:** jede 16er-Umsetzung; außerdem die nie zurückgemeldete Live-Verifikation aus dem Handout (5d). prod2 braucht keine Korrektur (16 Kerne/24 Threads, i9-12900K; ältere i9-14900KS-Nennungen vermutlich pre-RMA-stale). → Korrekturliste: **Abschnitt 3.3**.

---

## 2. DIE K2-ERKLÄRUNG

**Was K2 entscheiden muss.** K2 fragt, **welcher Bibliotheks-Schicht die Lade-/Antriebsmaschinerie zugeordnet ist**, die ein Prüfdock braucht, um eine plain Tier-Binary anzusprechen: `AnatomyModuleLoader` (dlopen/LoadLibrary, R5.E, 7-Schritt-Validierung inkl. ABI-Major-Check, RAII „destroy-vor-dlclose") und das „Drive-Bündel" `SearchAlgorithmDrive` (obs/ctrl/rbk/scn, einmalig bei acquire() ermittelt). Beides lag exklusiv in der Builder-/CEB-Schicht, geschützt durch die Doktrin „IPruefDock lebt nur im Builder-Binary" (pruef_dock.hpp:10-14). Da der Hybrid als **Rekursionsebene 3** der Dock-Kette (Ebene 1 Planer-Dock → Ebene 2 CEB-Prüfdock → Ebene 3 Hybrid-Prüfdocks; docs/plaene/20260806-PLAN-messkurven-…:175-188) selbst N gleichartige, ABI-stabile Prüfdocks zu seinen plain Tier-Binaries führt, braucht er dieselbe Lademaschinerie — ohne Builder-Code zu linken. Entstehung der Frage: 02.08.-Design-Review, Befund B2 / Korrektur K2 (A17-hybrid-tier.md:7,15); als Fork formalisiert am 09.08. („E-3 = K2 [...] stufen-neutrale Lib — ja/nein?", HYBRID-Bauplan:216-217).

**Vorfestlegungen im Log/Code, die K2 einrahmen (keine entscheidet K2 selbst):**
1. **Stufen-Doktrin:** MESS dreistufig dehnbar „Planer (Stufe 1 = RT-Freigabe) → CEB (CT-Einbau) → [Hybrid (CT)] → Tier (CT)"; SYSTEM zweistufig dehnbar mit [Hybrid CT]; **ORGAN hybrid-unberührt** (mess_achsen_naht.hpp:156-162). KON13-01-Tabelle (Owner, 11.08.): MESS 3→4 · SYSTEM 2→2 (parallel) · ORGAN 2→2.
2. **Weg C:** `genus()` liefert immer das geerbte Ziel-Genus — **kein sechstes Dock**, statisch erzwungen (pruef_dock_version.hpp:199-206; Registry bleibt 5). Die Außen-Andockseite braucht keinen neuen Loader-Pfad.
3. **Geplante, ungebaute Bausteine:** `hybrid_dock_factory` / `hybrid_dock_array` / `hybrid_binary_proxy` („Proxy je Dock [...], besitzt AnatomyModuleHandle", hybrid/README.md:67-79) — 0 existieren.
4. **XSD-Kommentar-Reserve** `<hybrid_tier>` (dock_array@storage=static|runtime, router/break_even, experiment_schema.xsd:102-124) — „KEIN Typ, KEIN Parser, [...] KEIN Byte-Effekt".
5. **Kein neuer ABI-Schritt:** beide Grenzen bleiben die bestehende Anatomy-ABI, Major 9 (README:87-92).
6. **Vierte Mess-Ebene reserviert:** `visit_hybrid_reroute` seit Major 9 Vertragsteil, Emitter bewusst 0 bis HY-A2 (mess_visitor_abi.hpp:101-133).

**Die Antwort steht im Log — zweifach; die jüngste Fassung gilt.**

*09.08. (Owner):* „der Loader wandert in eine stufen-neutrale Bibliothek, weil das Prüfdock der CEB und das Prüfdock der Hybrid-Tier-Binary jeweils technisch identisch bei Konfiguration sein müssen."

*12.08., KON21-01 „K2 BEANTWORTET" (Owner verbatim):*
> „Die CEB orchestriert alle Prüfdocks direkt oder delegiert dies an den Hybrid, der das für die compile time eingespeisten Synthese-Funktionen nach init am Prüfdock der CEB selbst über wiederverwendete CEB Module übernimmt. Der Hybrid ist später in der Lage eigenständige dynamische modules Lade-Entscheidungen zu treffen, also ist der Hybrid eigenständig, aber hat einen sync Kanal mit der CEB, sofern angeschlossen, um die getroffenen Entscheidungen des Ladens und laufens von Tier-Binaries zur runtime zu beeinflussen."

*Ledger-Auflösung dazu (KON21-01):* „Damit ist die K2-Frage (‚welcher Loader-Schicht?') aufgelöst — die Antwort ist BEIDE, als Betriebsarten, nicht als Fork: die Loader-Fähigkeit wandert als wiederverwendetes CEB-Modul in den Hybrid (Schicht 2), die CEB behält den direkten Weg (Schicht 1) und die Steuerhoheit über den Sync-Kanal."

**Klartext für den Owner:** (a) Die CEB kann jedes Prüfdock weiterhin **direkt** orchestrieren. (b) Oder sie **delegiert** an den Hybrid, der dafür dieselbe Lade-Maschinerie als **wiederverwendetes CEB-Modul** nutzt — kein Loader-Neubau; Bestand ist `AnatomyModuleLoader` (Bestands-Pflicht vor Neubau; exakt die Klasse, die der Code-Schnitt unabhängig als Zentrum identifizierte). (c) Autonomie-Stufe: der Hybrid trifft später eigenständige dynamische Lade-Entscheidungen, bleibt aber über einen **Sync-Kanal** (neues, eigenes Bauteil) zur Laufzeit von der CEB steuerbar. (d) Synthese-Funktionen compile-time eingespeist, Lade-Entscheidungen runtime — dieselbe CT/RT-Trennung wie im übrigen System. KON21-01 verankert sich selbst an KON13-02 (zwei Steuerungswege) und KON19-02 (Transmitter/Multiplexer) — die 09.08.-Fassung wird **verfeinert, nicht widerrufen**.

**Der Eigenschafts-Katalog aus dem Session-Log** (je Zeile Owner-Wort mit Anker):
- **Identität:** eigene Gattung **HEURISTIK-ADAPTER**, Genus **Function-Interface-Reroute** (GO-3, 08.08.: „erzeugt eine neue HEURISTIK-ADAPTER Gattung und ein Genus »Function-Interface-Reroute«"); E-1 = „C UND A — beides": geerbtes Ziel-Genus am Interface, eigene Enum-Werte in der Klassifikation („ein Graph benötigt ein anderes Reroute als SearchAlgorithm"); „einfach eine eigene bereits benannte und geplante Gattung+Genus im System" (E-1, 09.08.); transparenter CT-Pass-through, je Gattung+Genus per Google-Test bewiesen; baumförmige CT-Rekursion (Rest-Tiefen-Countdown bis 0, Tiefe 1 belassen, „muss funktionieren"); formal EINE Binary; allein nicht ansprechbar.
- **Ort ≠ Zeit:** steht VOR dem Tier (Ort), entsteht NACH ihm (Zeit) (KON9-01); „Tier und Hybrid sind gleich auf, weil die CEB ja nur durch Hybrid die erlaubten Eigenschaften der Tier-Binaries durchreicht" (KON8-02); Bau-Tiefe 3, „Hybrid und Tier sequentiell auf derselben Stufe gebaut, erst Tier und später Hybrid durch die CEB" (KON16-04 — löst zugleich O-8/CI-Nesting).
- **Rolle:** Glied der MESS-Kette — „das Hybrid kann nicht bauen, sondern nur Tier-Binaries messen, die schon gebaut sind" (KON13-01); „in all seinen Lebenslagen transparent und ein steuerbarer Multiplexer-Handlanger der CEB" (KON9-03); **Transmitter/Multiplexer, KEIN Aggregator** — Messwerte gehen über Fläche 3 (measurement-Durchstich) DURCH den Hybrid zur CEB (KON19-02, 12.08. — **schließt K5**); Hardware-Optimierung unabhängig von den Tiers; Andock-Bedingung = Genus-Interface-Passung (Fläche 1), keine zweite Freigabestufe.
- **Stempel:** nicht stempelfrei — selbst ein Genus mit Fläche 2, drei Anteile: (1) eigene Mess/System/Organ-Achsen im Stempel, (2) Parameterfunktionen zur Laufzeitanfrage, (3) Tier-Stempel durchgereicht zur Laufzeitanfrage (KON9-02).
- **Messung:** vierte Mess-Ebene dazwischengeschoben („von den 3 Mess-Ebenen dann auf 4 Mess-Ebenen [...] dazwischengequetscht", GO-3); 4! = 24 Rekombinationen neben den 3! = 6 CEBs (Owner 09.08.); 24-vs-48 offen, am 12.08. auf die Planungs-Simulation vertagt (KON19-08); Overhead = Macro-Messung(Hybrid-Aufruf) − bekannte Einzel-Tier-Performance (K5-Formel).
- **Bereichs-Karte:** Break-Even-Punkte = Bereichsgrenzen der Tier-Binary-Wahl (KON7-05); Dock-Anzahl dynamisch, Obergrenze Pflicht in der XML, Default 32 — offener Zahlen-Widerspruch gegen Q6-MaxN 8 (synthese_matrix.hpp:33-51).
- **Bau-Muster:** Factory · Facade · Adapter, organ-frei (Ledger 4091); std::variant-Ausnahme exakt begrenzt auf den DockSlot, std::visit nur an Umschaltpunkten, Hot-Path variant- und castfrei; kein eigener ABI-Schritt.
- **Lager (K1):** „einfach eine weitere Gattung+Genus, die parallel zu allen anderen [...] in den beiden Wurzel-Ordner-Ebenen des Lagerbaumes mit einsortiert wird" (09.08.); L3-Namensverbot ersatzlos aufgehoben, Zugehörigkeits-Wache stattdessen (lager_baum_writer.hpp:12-21,57-62 — umgesetzt und getestet).

---

## 3. KORRIGIERTE BAU-POSTEN

### 3.1 E-D / T-15b — der Prüfdock-Retry zieht um

**NEU ZU BAUEN — „Prüfdock-Retry (Robustheitskriterium)":**
- **Ort:** Wiederholungs-Klammer UM `measure_one_binary(builds[j], ctx.get())` — heute Einzelaufruf cache_engine_builder_iterator.hpp:3127 innerhalb `collect_ordered<CellOutcome>` (:3124-3131).
- **Auslöser:** der GESAMTE Prüfdock-Durchlauf EINER Tier-Binary gilt als failed. Kandidat-Prädikat aus dem Bestand: `oc.load_failed==1` über die drei frühen SourceUnavailable-Pfade (.so-Laden ~:2860-2868; Mess-Konsistenz-Gate :2887-2898; Dock-Antrieb :2900-2913). OFFEN, ob `SampleStatus::Failed` einzelner Einstellungen (perm_runner.hpp:175-186/:346-361) den Binary-Durchlauf mitzieht (→ Abschnitt 4, Punkt 12).
- **Verhalten:** bis zu 5 Wiederholungen des gesamten Durchlaufs als je eigener Versuch (Owner-Grund: „ein fremder Verbraucher ist aktiv, den man abwarten muss"); nach Erschöpfung greift die bestehende failed-Doktrin unverändert (Zelle „failed", nie null; „der Lauf misst weiter" = nächste Zelle/Binary).
- **Ausdrücklich unberührt:** (i) Drift-Gate-`max_reruns` (andere Bedingung: Streuung einer ERFOLGREICHEN Gruppe; andere Einheit: Zelle); (ii) KF-10-Erfolgsmessung `n_repeats=3`; (iii) T-15a (Kampagnen-Neustart bei Drift-Überschreitung — eigener, offener Owner-Punkt).

**MITZUZIEHEN (Ripple-Liste — sonst bleibt eine zweite falsche „Owner-Zahl-5"-Behauptung liegen):**
1. drift_gated_cell.hpp:108-120 — Kommentar umformulieren; `max_reruns`-Default zurück auf reinen Mechanismus-Wert (Signatur-Default 3, drift_detector.hpp:122) — **Owner-/Planungs-Entscheid, nicht stillschweigend**.
2. cache_engine_builder_iterator.hpp:372-383 — sechste Kommentarstelle („Der Default [...] IST die Owner-Regel") korrigieren.
3. xml_config_parser.hpp:268-288 / .cpp:347-364 — `drift_gate_max_reruns` von der Owner-5 entkoppeln; ggf. eigenes XML-Attribut für den Binary-Retry.
4. planner_mengen_types.hpp:127,197-200,319-324 — NEUER, separater Kosten-Faktor für den Binary-Retry (zusätzlich zu `drift_faktor = reps×(max_reruns+1)`); wörtliche Quellenangabe :320 nachziehen.
5. checkpoint_speicher.hpp:119-123 — Arena-Formel („bis zu 18 Durchläufe je Zelle" = 3×(5+1)) muss den binary-weiten ×5 zusätzlich abdecken (Prüfungs-Befund: sonst droht Unterdimensionierung).
6. profile_run_facade.cpp:1564,1577 — Übertragungspunkte nachziehen.
7. test_t15_drift_gate_messschleife.cpp:241-257 — „Owner-Zahl 5"-Pin umschreiben; NEUER Test für den Prüfdock-Retry.
8. Doku: Register S5-06 (09.08.) widerspricht der neuen Zuordnung — datiert korrigieren; Ledger-T-15-Abschnitte nachziehen.

**Herkunft der Fehlzuordnung (für den Ledger):** Commit ce **`4cd1ab91` (09.08.)** legte die Owner-5 auf `DriftGateConfig::max_reruns` — und dokumentierte die richtige Lesart gleichzeitig selbst als existent-aber-ungebaut (drift_gated_cell.hpp:112-116). Die Zwei-Lesarten-Ambiguität war seit KON18-02 aktenkundig; der damalige Agent wählte die falsche der zwei vorgedachten Lesarten.

### 3.2 E-C / O-13 — das ÜBERHOLT-Urteil, präzise

**Herkunftsbeleg (Explore-Auftrag erfüllt):** Begriff nicht vom Owner — `--dump-plan`: Opus-Subagent, 16.07., 22:52 UTC (`46375cdc:44755`; Dossier „Read-only (Opus)"); `PlanTextBuilder`/Fork B: 7-Agenten-Lauf, 19.07., 03:03 UTC (`46375cdc:58548`; BAUPLAN:185); **0 von 353** klassifizierten Transkript-Treffern mit Owner-Herkunft; Fork B agentisch entschieden und gebaut (ce `c9240477`, 19.07., 12:51 UTC), nie owner-bestätigt.

**Das Urteil zerfällt in zwei Posten mit unterschiedlicher Antwort:**
- **(a) Flag-Wort `--dump-plan`: ÜBERHOLT — bestätigt und bereits vollzogen.** Seit W1 (05.08., `1a3f1f42`) im Alt-Treiber tot (Verweiszeile + rc=1, main.cpp:472-486); in der neuen Planer-Binary bewusst nicht mitgewandert (main.cpp:681). **Ledger-Posten:** O-13 für das FLAG als ÜBERHOLT markieren, mit Herkunftsvermerk (16.07. Opus-Subagent / 19.07. Fork B, agentisch) — die KON19-10-Erwartung („vermutlich überholt, dann als ÜBERHOLT markieren") ist damit für das Flag erfüllt.
- **(b) Substanz `PlanTextBuilder` + `plan dump`: NICHT durch Bestand ersetzt — Streichung wäre Abriss aktiver, hart gegateter Funktionalität** (6 Builder an einem Director; Byte-Determinismus-Tests; CI-Job `visibility:tier-binaries` ohne allow_failure; Downstream-Parser `parse_plan_dump`; gepflegt bis 11.08.). Ein existierender Ersatz (Contract-Test/Planungs-Simulation) ist nirgends belegt — die Planungs-Simulation ist im Ledger selbst ein NEUER, noch zu bauender Posten mit Bestandspflicht („Bestand suchen!", Ledger ~:646/722). Der Owner-Satz „Das sollte eine Director Methode sein" ist exakt die am 19.07. NICHT gewählte Fork-B-Alternative → **Bauform-Entscheid** (Refactor: Builder-Logik in Director-Methode falten) **an den Owner, kein Lösch-Entscheid**. Bis dahin: kein Rückbau.
- **Ledger-Präzisierung:** Selbstnotiz „vermutlich 19.07.-Bauplan, Fork B, meine Formulierung" um den drei Tage älteren Flag-Ursprung (16.07., andere Session) ergänzen.
- **Kleiner Doku-Posten:** Code/07_tier_binary_report/main.cpp:8,47 nennt in der Usage-Hilfe noch „comdare-messung-driver plan dump" (seit W1 nicht mehr lauffähig; richtig: „comdare-experiment-planner plan dump").

### 3.3 E-E / OD-7 — Korrekturliste (sieben Posten)

1. **KEINE stillschweigende Änderung** von §69.6 (prod1=24 Worker) oder runner-mode.sh:43 (`HEAVY_J=24`) — dreifach owner-bestätigt (26.07./06.08./10.08., letztere in Kenntnis der 16-Kerne-Messung); der Ledger warnt selbst: „Wer die 24 pauschal streicht, streicht OD-7 mit" (W-2). Zuerst EINE gezielte Rückfrage, die die Kerne/Worker-Konflation auflöst: (a) sinkt der operative HEAVY-Deckel auf 16 — oder (b) bleibt die 24 als bewusste Überbuchung, und „müssten 16 Kerne sein" meint nur die Hardware-Tatsache?
2. Bis zur Antwort: **nur die reinen Hardware-Fakten-Zitate additiv korrigieren** (Ledger-Doktrin: nie löschen): ~:13907 (DEBUG-PARALLELITÄT) und ~:13972 (Thread-Budget) je datierter Vermerk „24 Kerne war falsch, prod1 hat 16 Kerne/32 Threads (lscpu 09.08.; W-2)"; Threadzahl 32 unangetastet.
3. W-2-Tabelle: datierter Nachtrag — „12.08., 06:49 (KON19-09) sagt 16 und nennt es ‚schon entschieden'; Rohtranskript-Prüfung findet keine frühere 16-Entscheidung, wohl aber drei 24-Bestätigungen; Doppel-Lesart offen (Posten 1)."
4. N-3/N-4: Vermerk, dass die 24-Worker-Basis für prod1 an Posten 1 hängt; bei Wechsel auf 16 **frische Kalibrier-Slice mit 16 Workern** fahren statt linearer Umrechnung.
5. Unabhängig vom Ausgang: **Live-Verifikation aus dem 06.08.-Handout (Abschnitt 5d)** nachholen — `CMAKE_BUILD_PARALLEL_LEVEL` am Host nach `runner-mode.sh heavy`; bisher keine Rückmeldung gefunden.
6. Getrennt halten: GitLab-Runner-NORMAL-Concurrency (Ist 4/4 gegen SOLL 2/2, KON-20) — andere Achse, wird durch 16-vs-24 nicht gelöst.
7. Memory `reference_prod1_16_kerne_32_threads_die_24_war_falsch.md`: Satz „Was daraus folgt, ist NICHT entschieden" per datiertem Nachtrag präzisieren (12.08.-Owner-Wort liegt vor, mit Doppel-Lesart), nicht streichen. prod2 braucht keine Korrektur.

---

## 4. WAS OFFEN BLEIBT

**E-A / O-4**
1. **Owner-Entscheid:** Festplatten-IO als NEUER, additiver OrganMetaMetaAxis-Typ bauen (neben, nicht statt T12/T17) — oder war nur die konzeptionelle Verwandtschaft gemeint, operativ getragen vom Bestand? *Warum offen:* Code und Doku tragen beide Lesarten; nur der Owner löst auf. *Nächster Schritt:* Zwei-Wege-Frage in die nächste Owner-Vorlage; bis dahin kein Bau an `OrganMetaMetas`.
2. Verhältnis der zwei SIMD-Strukturen (`SimdExternalUtilsFamily` vs. typverschiedene, bewusst namensgleiche `axis_09b_simd_extension`-Familie): verschmelzen oder getrennt? *Nächster Schritt:* kleiner Folge-Explore; kein O-4-Blocker.
3. Doku-Pflege: stale Verweis `permutation_codegen_tool.cpp` (external_utils_family_axis.hpp:183; test_c3b_kanal_merge_beleg.cpp:25); T-Nummern-Drift in Alt-Dokumenten (T14→T12 für io_dispatch). *Nächster Schritt:* bei nächster Berührung datiert vermerken.

**E-B / K2**
4. KON21-01 trägt — anders als KON19/KON22 — keine Transkript-Zeilenreferenz; wirkt live mitgeschrieben. *Warum offen:* Ledger gilt per Vorrang-Regel, aber die Bestätigung fehlt. *Nächster Schritt:* gezielter grep im aktuellen Transkript `5a19728e`.
5. Zahlen-Widerspruch Dock-Obergrenze **32** (09.08., XML-Default) vs. **8** (Q6, 02.08.) — im Code selbst als „OFFEN FÜR DEN OWNER" markiert (synthese_matrix.hpp:33-51). *Nächster Schritt:* Owner-Frage vor HY-A2.
6. 24-vs-48 Rekombinationen (Fühler-Achse in 4! enthalten?) — vom Owner am 12.08. explizit auf die Planungs-Simulation vertagt (KON19-08); Arbeitsannahme bis dahin: „nur die einfachen CPU-Versionen mit SIMD-Permutationen".
7. Doku-Nachzug: hybrid/README.md (Stand 09.08.) und Konformitäts-Register führen K2 noch als offen — datiert auf KON21-01 nachziehen; **Sync-Kanal CEB↔Hybrid** als neues Bauteil in die Postenliste aufnehmen.
8. `<hybrid>`-XML-Schalter (Mess-Zeile, Muster `load_framework`) — Bauauftrag ohne Datum; Bedeutung von „L1/L2" im lager_baum_writer-Kommentar — Mini-Klärung am Code.

**E-C / O-13**
9. **Owner-Entscheid Bauform:** Substanz löschen / zur Director-Methode refaktorieren / belassen — der Owner-Satz trägt beide Lesarten („überholt [...] nicht mehr benötigt" vs. „sollte eine Director Methode sein"). *Nächster Schritt:* Zwei-Wege-Frage mit dem Objektstand aus 3.2 (b).
10. Deckt der vorhandene `PlanSizeBuilder` (experiment_plan_director.hpp:489, „zählt NUR die Größe des Plans") die geforderte Planungs-Simulation teilweise? *Warum offen:* eigener Ledger-Posten mit Bestandspflicht; hier nur als Bestandsspur markiert. *Nächster Schritt:* Bestandsprüfung im Planungs-Simulations-Posten.
11. Fork-B-Zwischen-Turn (19.07., 03:03 → 12:51 UTC) nicht turngenau rekonstruiert — für die Owner-vs-Assistant-Frage irrelevant (beide Kandidaten Assistant-Seite); nur für lückenlose Prozess-Rekonstruktion offen.

**E-D / T-15b**
12. **Auslöse-Prädikat:** zählt nur `load_failed==1` (SourceUnavailable vor jeder Messung) als „failed Ausführung" — oder auch `SampleStatus::Failed` einzelner Einstellungen? *Nächster Schritt:* Owner-Frage vor Bau.
13. „bis zu 5" = 5 Versuche gesamt oder 1+5 (analog `max_reruns+1`-Konvention)? *Nächster Schritt:* Owner-Frage, eine Zeile.
14. Welche „3" ist „die eigentliche success Messung" — KF-10 `n_repeats` (wahrscheinlich: nur dort entstehen 3 separat dokumentierte Zeilen) oder Drift-Gruppen-`reps`? Indiz stark, unbewiesen; Altlast auch im Code selbst offen gehalten (drift_gated_cell.hpp:93-99). *Nächster Schritt:* bei Posten 12/13 mitfragen.
15. **T-15a** (Drift-Überschreitung → „ganzen Lauf neu" = laut Owner die gesamte Kampagne): Granularität Zelle | 4096er-Batch | Kampagnentag | Kampagne weiter offen (KON18-02) — strikt von T-15b getrennt halten.

**E-E / OD-7**
16. Die Kern-Doppellesart (operativer HEAVY-Deckel vs. Hardware-Fakt) — nur der Owner. *Nächster Schritt:* Rückfrage aus 3.3 Posten 1, formuliert OHNE die bisherige Kerne/Worker-Konflation (beide bisherigen Fragen waren konflationiert — daher sind die Owner-Antworten vom 10.08. und 12.08. möglicherweise kein Widerspruch in der Sache).
17. Handout-5d-Live-Verifikation (nie zurückgemeldet). *Nächster Schritt:* vor dem nächsten Voll-Bau-/Mess-Trigger fahren.
18. KON-20 (GitLab-Concurrency 4/4 vs. 2/2) — separater offener Betriebs-Punkt, unberührt.

**Übergreifend**
19. **Ledger-Zeilendrift:** mehrere Alt-Zitate (E-A Schnitt 1) waren um 235–322 Zeilen verschoben — Inhalte durchweg korrekt (Präzisierung, keine Widerlegung). Regel für alle künftigen Referenzen: **Abschnitts-ID + Datum zitieren**, Zeilennummer nur als Momentaufnahme.