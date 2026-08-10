# EXTRAKTE — BAND 01 (13 Dateien)

---

## 1. feedback_gattung_genus_interface_messparameter_achsen.md

**THEMA:** Gattung/Genus-Interface liefert Messparameter + Achsen-Profil

**TYP:** feedback

**FAKTEN:**
- Owner-KERN (06.08.2026, im Zuge der E4/17-Ratifikation, wörtlich): "Wir halten fest, dass aus einer Interface Funktion einer Gattung->Genus immer alle in der interface Funktion (etwa eines Suchalgoritmus) vollzogenen Messparameter abrufbar sind, die während des Aufrufs durchlaufen wurden, zusammen mit einem zeitlich geloggten Profil der Achsen-Zugriffsmuster. [...] Die Gattung->Genus verwendet in der Gattung einen Kern der Interfacefunktionen der Tier-Binary und im Genus eine spezifische Erweiterung (etwa bei Containern hat ein std::vector zwar ein push_back und das haben alle Container, aber es hat nicht wie eine double liked list ein push_front)." — OWNER-WORT (06.08.2026)
- NACHTRAG, Owner-KERN wörtlich (06.08.2026): fehlender vierter Layer — "mir besonders welche Genus es unter jeder Gattungen gibt, welchen Interface Kern sie nach aussen im gemeinsamen Gattungs-Kern teilen, und wie jeweils ihre Mikro-, Makro- und Wallclocktime-Messung eingebunden wird. Das ist ein vierter Layer der Observer Stufe im Vertrag zwischen CEB und Tier-Binary!" — OWNER-WORT (06.08.2026)
- Objekt-Beleg (ce anatomy/, Stand Commit c837d830): `AnatomyGenus` (anatomy_base.hpp:98-107) = SearchAlgorithm (Gattung **Map**, volle 18-Organ-Anatomie) + Set/Sequence/Adapter/View (Gattung **Container**, Tier-Metaphern Bird/Reptile/Invertebrate/Plant) = die 5 Genera; Graph-Gattung ist Zielbild (noch nicht Bestand). — MESSUNG (Code-Zitat, Stand c837d830)
- CEB spricht ausschliesslich das ABI-stabile Gattungs-Interface: Map → tier_insert/lookup/erase; Container → ISetTier/ISequenceTier/IAdapterTier/IViewTier + eigenstaendige V2-Sub-Interfaces (append-only). — MESSUNG (Code-Beleg)
- Observer-Stufe: GENAU EINE `IObservableTier::tier_observe` + EIN versionierter POD (axis_stats+seg_ns, ABI-Major-versioniert, Datei observable_tier.hpp, Kennung I1). — MESSUNG (Code-Beleg)
- C6-Ebene: `GenusObserverAggregate<G,N>` = EIN Wire-Layout, VIER genus-getaggte Container-Formen (Set<13>/Sequence<9>/...), 8 Spalten je Achsen-Slot + 4 Gattungs-Zaehler; Schema-Tabelle `GenusAxisFieldNames` = Single Source; Zeilen-Schreiber `genus_axis_row_writer.hpp`. — MESSUNG (Code-Beleg)
- Mess-Einbindung lt. Doku 24 §8.6/8.7: CEB testet Gattungs-API durch → misst eingebaute Observer (dort noch "MIKRO" axis_stats genannt) + Segment-Zeiten ("MAKRO" seg_ns/Pfad B) → zieht POD → persistiert korreliert mit aussen gemessener wall_clock ("WALLCLOCK"). Diese Gattungs/Genus-Mess-Einbindung wird als "der VIERTE Layer der Observer-Stufe" bezeichnet. — AGENTEN-BEHAUPTUNG (06.08., später teilweise widerrufen, s.u.)
- RAHMUNGS-KORREKTUR, Owner wörtlich (06.08.2026): "der Architektur-Kern ist VERGESSEN und GEPLANT, aber er ist nicht neu fuer die observer und die Mess-struktur" — der Vierte-Layer ist KEIN neuer Entscheid, sondern Wiederherstellung eines bereits geplanten, in der Layer-Darstellung vergessenen Kerns. Plan-Träger: Doku 24 (Zwei-Dimensionen-Messmodell §8.6/8.7), I1-Konsolidierung, E-24-C6-Serie. — OWNER-WORT (06.08.2026)
- **OWNER-KORREKTUR, wörtlich (06.08.2026) — widerruft die MIKRO/MAKRO-Zuordnung oben ausdrücklich:** "Micro- und Macro-Benchmarking sind FALSCH und entsprechen nicht dem neuesten Stand der Planung im ledger. Wallclock time wird je Tier-Binary Funktion und ueber eine Kombination einer Last JEWEILS gemessen. ... Der Rest bezueglich Gattung und Genus ist korrekt, aber die Architektur im Code laesst bezueglich Sauberkeit der Layer und Klassen noch Wuensche uebrig." Verworfen: die Zuordnung "MIKRO=axis_stats / MAKRO=seg_ns / WALLCLOCK=aussen". — OWNER-WORT (06.08.2026) — **WIDERSPRUCH zur eigenen Aussage weiter oben im selben Dokument, ausdrücklich vom Owner korrigiert.**
- **KANON-REKONSTRUKTION (06.08.2026, quellen-geerdet) — die danach geltende Fassung:** Bindende Quelle = ce `docs/architecture/messarchitektur_v5_design.md` (Status "bindend", 31.05.; im Juli aktiv zitiert LED:3390). (1) KARTESISCHES MESS-KREUZ (§2, Zeilen 71-100): Achse 1 = BUILD-PROFIL (Tier-Binary-Permutation), Achse 2 = LASTENPROFIL (host-seitig zur Laufzeit, keine CMake-Flags; YCSB A-F, OP-1..6, seed, Pausen, Checkpoints). (2) ZWEI-PHASEN-OP-SCHLEIFE (§4, Zeilen 176-190, "pro Op GENAU 2x, bindend"): je Op (1) tier_save_all (2) op-Erstausführung (3) tier_rollback_all (4) op-measure = wallclock-umklammert (`detail::abi_dur_ns`) + Observer gleichzeitig → WALLCLOCK wird je TIER-BINARY-INTERFACE-FUNKTION x LAST-KOMBINATION (YCSB-Profil x OP-Typ, §5 Zeilen 193-207, `IMeasurableWorkloadHost`) jeweils gemessen — exakt der Owner-Wortlaut. (3) ZWEI-DIMENSIONEN (Doku 24 §8.1/§8.7) bleibt gültig: dieselbe Messung erhebt Wall-Clock UND Achsen-Statistik als zwei korrelierte Dimensionen; seg_ns = orthogonale dritte Größe (reale Per-Achsen-Segmentzeit innerhalb einer Op, Doku 31:42, observable_tier.hpp:134/141-142, Coverage ~100% gegen eigene Wall-Clock). (4) MIKRO/MAKRO-Begriffe stammen NUR aus §47/§54-T2 Mess-Tooling-HAUPT-Achse (LED:2282ff, 20.07.) = CT-Auswahl-Achse {nur Wallclock / Makro-Benchmarks / Micro-Benchmarks über Observer} für CEB-Bestückung, Default=Vollmenge in EINER CEB (LED:3383); war NIE technisch präzisiert, NIE eine Aussage über Wallclock-Granularität. "Meine Projektion auf axis_stats/seg_ns war Fabrikation." — MESSUNG (Doku-Zitat) + AGENTEN-BEHAUPTUNG (Selbstkorrektur)
- OFFENE OWNER-FRAGE F6 (Stand dieser Datei, 06.08.): Verwirft "Micro-/Macro-Benchmarking sind FALSCH" AUCH das §47-Auswahl-Achsen-Konzept selbst, oder nur die Fehldeutung? Kein Supersede-Vermerk auf §47 im Ledger zum Zeitpunkt dieser Datei. — UNKLAR/offen

**STAND:** Geschichtet — Originalaussage TEILWEISE UEBERHOLT (Owner-Korrektur verwirft explizit die MIKRO=axis_stats/MAKRO=seg_ns-Zuordnung), danach durch KANON-REKONSTRUKTION ersetzt (gilt, quellen-geerdet). F6 war zum Dateidatum noch offen. Frontmatter-`description` nennt die Korrekturkette NICHT — Fliesstext ist die dichtere/aktuellere Quelle.

**VERWEISE:** [[feedback_gattung_own_genus_own_abi_nonintersecting_mutually_usable]] (im Index: "Gattung+ABI"), [[feedback_command_pattern_achsen_mess_visitor_container_in_sa]] (im Index: "Cmd+Visitor"), [[reference_thesis_core_contribution_axis_library]] (im Index: "Kern=Achsen") — alle drei bereits im Index verlinkt.

---

## 2. feedback_hardware_erkennung_factory_laufzeit_nie_statisch.md

**THEMA:** Hardware-Erkennung per Factory, nie statisch

**TYP:** feedback

**FAKTEN:**
- Owner-Direktive (27.07.2026, mitten im 6d-Push, gilt als "schon-immer-Gesetz"), Anlass Intel prod2, wörtlich: RAM-Frequenz "sollte nie fest gesetzt werden, sondern wird durch CEB mithilfe der Hardware-Haupt-Systemachsen aus dem OS ausgelesen, daher nie statisch, es braucht eine Klasse mit einem factory Pattern fuer die Hardware Erkennung, welche dies ueber alle Systemachsen wie ISA x OS fuer den Anfang erkennen kann. [...] Es gibt dutzende Bibliotheken welche man je nach OS ebenfalls zur Hilfe nehmen kann." — OWNER-WORT (27.07.2026)
- PRAEZISIERUNG (Owner, 27.07. später): CEB-System-Achsen sind statisch einkompilierte HAUPT-Achsen; vereinfachte Erkennung (ISA-Vendor x OS) läuft beim PLANER zu dessen Laufzeit, um den CEB-Bau CT auf eine Plattform auszurichten. CEB bringt einkompilierte Erkennungs-Software für eine GRÖSSERE CPU-Familie mit + wird um die Stempel ISA x OS erweitert. Zwei-Ebenen-Modell: Planer-RT wählt CT-Spezialisierung → CEB-RT erhebt Feinwerte innerhalb der Familie; Passungs-Stempel macht Fehl-Deploy zur erkennbaren Fehlerklasse. — OWNER-WORT (27.07.2026)
- ERGAENZUNG (Owner, geltende Fassung nach Klärung ~18:05Z, wörtlich): "Der Planer muss zumindest die ISA x OS Komplex-Hauptachse grob erkennen um per Metaprogrammierung eine passende feingranulare Hardware-Erkennung und passende OS handles dafuer mitzugeben bzw. je ISA x OS einzukompilieren (beachte alle vorhandenen ISA und dokumentierte OS). Die feingranulare Erkennung liegt bei der CEB." — OWNER-WORT (27.07.2026, ~18:05Z)
- Geltende Auslegung = K1-K5 im PLAN-Doc, vom Owner ausdrücklich als "goldrichtig" bestätigt: Planer = erster Konsument der Komplex-Achse, mappt Host grob auf eine Zelle; Factory-Spezialisierung über (IsaComplexTyp × OsTyp) im Typ; CT-Totalitätswache über `kAllTargetIsaComplexIds × kAllOperatingSystemIds`; feingranulare Erhebung komplett CEB-seitig. Verworfen bleibt NUR die engere "K1-Schärfungs"-Deutung ("Planer nur CPUID-Vendor/Familie"). — OWNER-WORT + AGENTEN-BEHAUPTUNG (Einordnung)
- FINALE EINORDNUNG (Owner, 27.07. ~18:15Z): HW-Erkennung ist eine WEITERE ZWEIGETEILTE HAUPT-ACHSE über Planer-RUNTIME und CEB-COMPILE-TIME, konkret eine MESS-ACHSE ("misst" Hardware-Eigenschaften; Mess-Realm-Wurzel, Blut-Doktrin, golden-neutral). Planer baut sie in die CEB ein "wie die Mess-Programme" (Registry=Angebot, Profil wählt, CMake-Interface kompiliert ein; je Plattform x Mess-Aufgabe eine passende CEB, Option b). System- und Organ-Achsen der CEB werden davon NICHT berührt. Zweck: CT-Stempel der Tier-Binaries korrekt setzen (W10-Anschluss/Zellwerte-Defines). Details in PLAN-Doc Nachtrag 3 (N1-N5). — OWNER-WORT (27.07.2026, ~18:15Z)
- Negativbeispiel konkret benannt: `ram_frequency_mhz=4800` statisch deklariert in ce-Commit 5dea1258 (machine_identity.hpp) — verstößt gegen die Direktive. — MESSUNG (Code-Beleg, Commit 5dea1258)
- How to apply: (1) Factory-Pattern (GoF) für HW-Erkennung, Auswahl über ISA x OS, später alle Systemachsen. (2) Statische Deklarationen wie in machine_identity.hpp werden zu Erwartungs-/Fallback-Werten degradiert (gekennzeichnet z.B. `declared_not_measured`) oder entfallen; static_assert-Wachen auf Hardware-ZAHLEN sind Regression gegen diese Direktive. (3) Je OS dürfen Bibliotheken helfen; Linux-Priorität: nicht-root-fähige Quellen zuerst (CI läuft als gitlab-runner). — AGENTEN-BEHAUPTUNG
- Recherche-Grundlage: Research-HWDetect-Bericht vom 27.07. — MESSUNG (Referenz)

**STAND:** GILT (letzte Fassung = FINALE EINORDNUNG 27.07. ~18:15Z; per project_20260727_vormittag_o8_fenster_lage.md [Datei 13 dieses Bandes] am selben Abend als "Task-#7-SPEC KOMPLETT" bestätigt — siehe dort).

**VERWEISE:** [[feedback_lehrbuch_design_patterns_only_zero_cost_metaprog]] (Index: "Nur GoF"), [[feedback_system_axes_measurement_own_abstract_root_blood]] (Index: "System/Organ"), [[feedback_haupt_achse_static_unter_achse_runtime_chain_ct_wiring]] (Index: "Haupt=CT/Unter=RT"), [[project_achsen_neuordnung_bindende_sortierung_regressionen]] (Index: "Achsen-Sort."), [[feedback_vendoring_doctrine_ordered_vendor_faithful_selfcontained]] (Index: "vendor→self") — alle im Index verlinkt.

---

## 3. feedback_hybrid_tier_stufe_hinter_ceb_variant_ausnahme.md

**THEMA:** Hybrid-Tier eigene Stufe, std::variant-Ausnahme

**TYP:** feedback (internes `name:`-Feld: `hybrid-tier-stufe-hinter-ceb-variant-ausnahme`, mit Bindestrichen statt Unterstrichen — Namenskonvention älter als Dateiname)

**FAKTEN:**
- Owner-Entscheid E1 (02.08.2026, wörtlich in `super docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md`): Hybrid-Tier-Binaries sind eine **eigene Stufe HINTER der CEB**. Sie tragen **mehrere ABI-stabile Prüf-Docks** und nutzen für deren Einsatz das **Factory Pattern als Proxy** auf ihre Tier-Binaries — dafür als Ausnahme **std::variant** in einem wahlweise statischen oder Runtime-Array (Dock-Anzahl dynamisch einstellbar). Zwischenlösung statische Prüf-Docks ↔ austauschbare plain Tier-Binaries je Prüfdock = **XML-Konfiguration auf Anwenderwunsch in der AUSWERTUNGSPHASE**. — OWNER-WORT (02.08.2026)
- In plain Tier-Binaries bleibt std::variant VERBOTEN; die Ausnahme gilt NUR für die Hybrid-Stufe. — AGENTEN-BEHAUPTUNG (Anwendungsregel, aus Owner-Entscheid abgeleitet)
- Designplanung zwingend Fable 5 xhigh + ultracode (Owner-Auflage); Bau erst in der Auswertungsphase. — OWNER-WORT (02.08.2026)
- **NACHTRAG (Owner-KERN wörtlich, 05.08.2026):** "die Hybriden [sind] ein factory pattern - facade - Adapter" — Factory (Dock-Einsatz), Facade (virtuelles ganzes Tier-Binary nach außen), Adapter (Command-Delegation an statisch zugewiesene echte Tiers); ORGAN-FREI. Hybrid erbt ALLE Eigenschaften vorausgegangener Stufen (Mess DREI-stufig, System ZWEI-stufig dehnbar) und gibt Mess- UND System-Config CT an anhängige Tiers weiter. — OWNER-WORT (05.08.2026)
- Posten 90 (offen, Stand dieser Datei): Design-Doc bei Bau um GoF-Einordnung (Factory-Facade-Adapter) ergänzen. — AGENTEN-BEHAUPTUNG (TODO-Vermerk)

**STAND:** GILT (letzter Stand 05.08.2026; löst laut Datei "den scheinbaren V7.2-Konflikt" — kein Widerruf der Hybrid-Freigabe, sondern Scope-Klärung).

**VERWEISE:** [[no-std-variant-static-axes-bloat]] (= `feedback_no_std_variant_static_axes_bloat.md`, Index: "Kein variant" — verlinkt), [[ceb-drei-modi-arbeitsmodus-hot-tier-switching]] (= `feedback_ceb_drei_modi_arbeitsmodus_hot_tier_switching.md`, Index: "CEB 3 Modi" — verlinkt). **CLUSTER innerhalb dieses Bandes:** entstammt derselben Session-Doc wie Datei 8 (`feedback_stempel_regression_...`) und Datei 10 (`feedback_versions_flag_grammatik_...`) — alle drei aus `super docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md`, alle drei unverlinkt, alle drei verweisen gegenseitig aufeinander.

---

## 4. feedback_implementierung_an_opus_delegieren_fable_als_architekt.md

**THEMA:** Implementierung an Opus delegieren — SUPERSEDED

**TYP:** feedback

**FAKTEN:**
- Frontmatter-`description` erklärt die Datei bereits selbst für **SUPERSEDED 26.07.2026** → abgelöst durch `[[feedback_fable5_xhigh_agenten_fuer_alles_kein_opus]]`: nicht mehr Opus, sondern Fable-5-xhigh-Agenten für Verifikation/Planung/Implementierung. Grund: "Opus baute schwerwiegende Fehler." Fable 5 bleibt Architekt/Manager. — AGENTEN-BEHAUPTUNG (Supersede-Vermerk, aber mit explizitem Datum)
- Ursprüngliche User-Direktive (2026-07-19, historisch): Für die Implementierung so viel wie möglich an **Opus-4.8-Agenten** delegieren. Fable 5 (Hauptsession) ist Software-Architekt und Manager, NICHT Implementierer. — OWNER-WORT (19.07.2026)
- Anwendung (historisch): bei Agent-/Workflow-Aufrufen für Implementierung explizit `model: 'opus'` setzen; Workflow-Subagenten liefen bereits default auf claude-opus-4-8. Selbst nur: Architektur/Design, Plan-/Ledger-Pflege, End-Verifikation (Force-Recompile/ctest/CI), Commits+Pushes, Rückfragen an User. — AGENTEN-BEHAUPTUNG (Anwendungsregel)
- Historienkette explizit benannt: vorher Codex (bis 10.07.), dann abgelöst durch Opus-Agenten (ab 19.07., diese Datei), dann laut Supersede-Vermerk abgelöst durch Fable-5-xhigh-Agenten (ab 26.07.). — AGENTEN-BEHAUPTUNG (Verkettung aus Dateiinhalt)

**STAND:** UEBERHOLT (von der Datei selbst erklärt, 26.07.2026, durch `feedback_fable5_xhigh_agenten_fuer_alles_kein_opus.md`). **WICHTIGER BEFUND:** Die Nachfolgedatei `feedback_fable5_xhigh_agenten_fuer_alles_kein_opus.md` **EXISTIERT** im Memory-Verzeichnis (geprüft), ist aber **ebenfalls im Index unverlinkt**. Damit fehlt im aktuell sichtbaren Index sowohl die alte (Opus) als auch die neue (Fable-5-xhigh) Fassung der Implementierungs-Delegationsregel — eine Doktrin-Lücke, kein Einzelfund.

**VERWEISE:** [[feedback_fable5_xhigh_agenten_fuer_alles_kein_opus]] (existiert, unverlinkt — s.o.), [[feedback_selbst_implementieren_ab_20260710_codex_abgeloest]] (Index: "Selbst impl." — verlinkt, dort: "Codex abgelöst — jetzt: Opus-Agenten statt Codex"), [[feedback_jede_aufgabe_ultracode_planungssession_ledger_alle_plandocs]] (Index: "Aufgabe uc" — verlinkt).

---

## 5. feedback_ledger_regulaer_updaten_neuere_fakten_schlagen_aeltere.md

**THEMA:** Ledger regulär updatebar, neuere Fakten siegen

**TYP:** feedback

**FAKTEN:**
- User-Direktive (2026-07-17, wörtlich): „Das ledger darf regulär geupdated werden, nicht nur additiv, sobald der workflow durchdringt. Neuere Fakten schlagen immer ältere Fakten." — OWNER-WORT (17.07.2026)
- Vorherige Praxis war strikt-additiv (nur NACHZIEH-Vermerke, Original stehenlassen) und ließ das Ledger auf ~1800+ Zeilen mit stale Passagen + Widerspruchsschichten anwachsen. — AGENTEN-BEHAUPTUNG (Begründung)
- Anwendung: im LEDGER (`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`) dürfen überholte Aussagen IN-PLACE korrigiert/ersetzt werden; Historie bleibt über git erhalten (jede Änderung committet, granular). Doktrin "nie löschen, nur deprecaten" gilt WEITER für eigenständige Doku/Dossiers (`docs/sessions/backups/`, Architektur-Doks) und uneingeschränkt für Messdaten. — AGENTEN-BEHAUPTUNG (Anwendungsregel)
- Gilt ab Landung des Konsolidierungs-Workflows `wf_d5ba4b2b` (2026-07-17); dessen additive NACHZIEH-Vermerke sind der letzte Alt-Stil und dürfen fortan in reguläre Updates aufgelöst werden. — MESSUNG (Workflow-ID, Datum)

**STAND:** GILT. **Bemerkung:** Diese Datei formuliert exakt die Ledger-Update-Doktrin, die der aktuelle Konsolidierungsauftrag (dieser Job) für die 57 unverlinkten Memory-Dateien NICHT anwendet — dort gilt "nie löschen, nur deprecaten" (per Owner-Auftrag des aktuellen Jobs explizit bestätigt). Zwei verschiedene Dokumentklassen (Ledger vs. Memory-Index) mit unterschiedlicher Lösch-/Update-Doktrin — nicht verwechseln.

**VERWEISE:** [[feedback_never_delete_documentation]] (Index: "Doku deprecaten" — verlinkt), [[feedback_messdaten_nie_loeschen_abi_darf_brechen]] (Index: "Messdaten bleiben" — verlinkt), [[feedback_jede_aufgabe_ultracode_planungssession_ledger_alle_plandocs]] (Index: "Aufgabe uc" — verlinkt).

---

## 6. feedback_pair_explore_with_codex_same_investigation.md

**THEMA:** Jeder Explore-Aufruf parallel mit Codex

**TYP:** feedback

**FAKTEN:**
- Regel: Immer wenn ein Explore-Agent (oder ähnlicher schneller read-only Such-Agent) für eine Untersuchung/Mapping gestartet wird, PARALLEL denselben Auftrag zusätzlich an einen `mcp__codex__codex`-Agenten geben — Parameter: sandbox `read-only`, approval `never`, `model_reasoning_effort: xhigh`, Modell weglassen — mit EXAKT demselben Prompt. — AGENTEN-BEHAUPTUNG (als bindende Selbstregel formuliert, Herkunft-Session originSessionId 78cf67f8-571e-4fcd-a907-1556dbc5be72)
- Begründung: Codex analysiert gründlicher/sieht mehr als schnelle Explore-Agenten; Kombination erhöht Präzision. Konvergenz = hohe Konfidenz; Divergenz = genauer hinschauen vor jedem (evtl. nicht verifizierbaren) Edit. — AGENTEN-BEHAUPTUNG
- Anwendung: Explore- und Codex-Aufruf möglichst im SELBEN Zug (parallel) absetzen. Codex NUR auf Code-Repos (cache-engine/prt-art/super/thesis), NIE Cluster/keys/machines. Gilt generell für Untersuchungen/Mapping, nicht nur Pre-„done"-Reviews. — AGENTEN-BEHAUPTUNG

**STAND: WIDERSPRUCH / möglicherweise verdrängt.** Diese Datei ist mit 34 Tagen die älteste des Bandes und fordert eine **verpflichtende Parallel-Codex-Prüfung bei JEDEM Explore-Aufruf**. Der aktuell sichtbare Index führt stattdessen unter "EXPLORE PFLICHT je Welle+Strang" ein **"2-STUFIG"**-Verfahren (`feedback_explore_kartierung_sonnet5_max_dann_selbst_gegenlesen.md` = "Sonnet5 max, dann selbst gegenlesen") — das ist ERKENNBAR ein anderes Zwei-Stufen-Modell (Sonnet5-max → Selbst-Gegenlesen) als das hier geforderte (Explore-Agent + paralleler Codex-Agent, beide gegenprüfen). Ob die Codex-Pairing-Regel durch das 2-STUFIG-Verfahren ersetzt wurde oder stillschweigend zusätzlich gelten sollte, ist aus den vorliegenden Dateien NICHT zu entscheiden — beide Seiten hier benannt, keine Supersede-Markierung in dieser Datei gefunden.

**VERWEISE:** [[feedback_codex_mcp_review_before_code_complete]] (**existiert im Memory-Verzeichnis, ist unverlinkt** — Cluster-Fund), [[feedback_thorough_assumptions_workflow_planning]] (Index: "Annahmen" — verlinkt), [[feedback_never_guess_always_lookup_state_of_art_and_docs]] (Index: "Nie raten" — verlinkt).

---

## 7. feedback_paketschnitt_nur_im_sessiondoc_existiert_nicht.md

**THEMA:** Paketschnitt nur im Session-Doc = nicht existent

**TYP:** feedback (originSessionId `5a19728e-f6e1-4736-a246-e3fda9ac35a1` — **identisches Session-Präfix wie der aktuelle Konsolidierungs-Job** `/home/comdare/.claude/jobs/5a19728e/`)

**FAKTEN:**
- Am 06.08.2026 am Objekt belegt: Der F9/LB-Paketschnitt LB-0..LB-6 (Lager-Baum-Vollausbau, ausdrücklich Vor-Trigger-Pflicht: "der Voll-Bau-Trigger IST der Baum-Vollausbau") stand ausschließlich in zwei Session-Dokumenten vom 01.08. — MESSUNG
- Gegenprobe mit Musterzählung (Quelle traf 3x):
  | Muster | Ledger | TODO-Register 06.08. (474 Zeilen) |
  |---|---|---|
  | `LB-[0-9]` | 0 | 0 |
  | `OE-B` | 0 | 0 |
  | `F9-Paketschnitt` | 0 | 0 |
  — MESSUNG (Grep-Zählung, mit Gegenprobe an der Quelle)
- Owner-Reaktion, wörtlich zitiert: "wurde nicht gelesen??" — MESSUNG (Owner-Zitat im Nachhinein referenziert)
- Ursache lag NICHT an der Zeitspanne (der 01.08. lag im erhobenen 14-Tage-Fenster), sondern an der fehlenden **QUELLENKLASSE** `docs/sessions/*` — das Register nannte seine Quellen selbst ("Ledger 23.-31.07.", "Ledger 01.-06.08.", "Dossier/Doku-Register", "Live-Lesung des Fahrplans"), aber diese Klasse fehlte. Frühere Zusage "das 14-Tage-Fenster trug alles Aktive" ist für diese Kette widerlegt. — AGENTEN-BEHAUPTUNG (Analyse, mit Messbeleg)
- Zusätzlicher Sucht-Fehler mit gleichem Effekt: ein Scope suchte mit heutiger Vokabel (`Binary-Stub`, `Dummy-Strategie`), während die Planung vom 01.08. andere Wörter führt (`OE-B`, `Dummy-Lager`, `Textdateien mit Stempel-String`). — MESSUNG (Vokabular-Vergleich)
- Regel 10 (Nummerierung der Datei selbst): "ein Paketschnitt, der nur in einem Session-Dokument steht, existiert für die Ausführung nicht — Session-Doc ist BELEG, Ledger+Checkliste sind REGISTER." — AGENTEN-BEHAUPTUNG (verallgemeinerte Lehre)
- How to apply (4 Punkte): (1) jede Kette mit Vor-Trigger-/Abgabe-Anspruch SOFORT in Ledger UND Vor-Trigger-Checkliste eintragen. (2) bei jeder Konsolidierung die QUELLENKLASSEN explizit auflisten — `docs/sessions/*` ausdrücklich mitnehmen oder Ausschluss begründen. (3) bei Negativ-Befunden mindestens zwei Vokabular-Generationen probieren (heutige + vermutete Entstehungszeit). (4) bei jedem "0 Treffer" die Gegenprobe des Musters an einer Datei, die treffen MUSS. — AGENTEN-BEHAUPTUNG

**STAND:** GILT — und ist **methodisch direkt einschlägig für den aktuellen Konsolidierungsauftrag** (Regel 2 verlangt von jeder Konsolidierung die explizite Nennung ihrer Quellenklassen; dieser Extraktions-Job liest ausschließlich die 13 Memory-Dateien aus `band_01`, keine `docs/sessions/*`-Dokumente — dieser Scope-Hinweis sollte bei der Zusammenführung aller Bänder festgehalten werden).

**VERWEISE:** [[reference_rescue_ref_ist_keine_landung]] (**existiert, unverlinkt** — Cluster-Fund, "gesichert != gelandet"), [[feedback_behauptungen_verifizieren_layer_vertraege_halten]] (Index: "Behauptung→Quelle" — verlinkt), [[project_lager_basis_tests_dummy_strategien_stempel]] (**existiert, unverlinkt** — Cluster-Fund, laut Datei "der Owner-KERN, den dieser Schnitt deckt"), [[reference_ugrep_ascii_gate_stille_null]] (Index: "ugrep stille Null" — verlinkt).

---

## 8. feedback_stempel_regression_keine_merge_zeile_meta_meta_realm_ende.md

**THEMA:** Stempel: keine Merge-Zeile, Meta-Meta ans Realm-Ende

**TYP:** feedback (internes `name:` = `stempel-regression-keine-merge-zeile-meta-meta-realm-ende`)

**FAKTEN:**
- Owner-Entscheid **E2 Stempel-REGRESSION** (02.08.2026, wörtlich in `super docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md`): Meta-Meta-Achsen-Stempeleinträge sind PFLICHT wie alle Hauptachsen; der Stempel passt sich **dynamisch per Metaprogrammierung** an. Meta-Meta gehört immer zu Mess-/System-/Organ-Realm → Eintrag wird **dynamisch ANS ENDE der bestehenden Realm-Zeile angehängt**. **Die merge-Zeile darf NICHT EXISTIEREN** (PRT-ART-Prüfling läuft merge GEGEN die Organ-Achsen). Experimentelle Achsen-Algorithmen eines Prüflings: **'e'-Suffix** in der Versionsbezifferung je Achsen-Algorithmus. Das Ist-5-Zeilen-Layout (organ/system/measurement/merge/sha512) ist **defekt**; Realm-Trennung defekt → wirkt auf Lagerhaltung. — OWNER-WORT (02.08.2026)
- Owner-Entscheid **E3 OS-Unter-Achsen** (02.08.2026, gleiche Quelle): Die drei finalen OS-Unter-Achsen (A-08/K-04) sind JETZT Pflicht — Basis der Wiederverwendbarkeit/Zuordbarkeit der Binaries; ohne sie Neubau ALLER Binaries bei OS-Erweiterung. Kontext: Infra installiert weitere OS; **neue Plattformen seit 02.08.: RISC-V, macOS M1, macOS x86**. — OWNER-WORT (02.08.2026)
- Beide Pakete (E2+E3) sind trigger-blockierend vor Voll-Bau-4. — AGENTEN-BEHAUPTUNG (Einordnung)
- How to apply: merge-Zeile entfernen, Meta-Meta-Anhängung bauen, 'e'-Versionierung einführen, OP-11 zurückbauen, SHA512-Skip-Gate/G-E6 erst danach aufsetzen. Lehre aus der Owner-Rüge: Frist-Sparsamkeit nie gegen System-Grundlagen empfehlen. — AGENTEN-BEHAUPTUNG

**STAND:** GILT (letzter erkennbarer Stand in dieser Datei, 02.08.2026, keine Supersede-Markierung gefunden). **Wichtig für STAND-Prüfung:** Datei 11 (`project_20260726_chunk_delta_verlorene_owner_antworten.md`, D-10, 26.07.) hatte die Anzahl der OS-Unter-Achsen noch als OFFENE FRAGE geführt ("3-vs-4-Schnitt (Build separat?) = offene Owner-Rückfrage", Kandidaten: Version/Kernel/Build/Update-Zustand). E3 in dieser Datei (02.08.) beantwortet das: **drei** finale OS-Unter-Achsen. Chronologie: 26.07. offen (3-vs-4) → 02.08. entschieden (drei, Pflicht).

**VERWEISE:** [[hybrid-tier-stufe-hinter-ceb-variant-ausnahme]] (= Datei 3 dieses Bandes, Cluster-Beleg). **CLUSTER:** zusammen mit Datei 3 und Datei 10 aus derselben Owner-Entscheide-Session vom 02.08.2026 — alle drei unverlinkt.

---

## 9. feedback_versionierungs_interface_stempel_ct_namensfunktion.md

**THEMA:** Gesondertes Versionierungs-Interface, CT-Namensfunktion

**TYP:** feedback (internes `name:` = `versionierungs-interface-stempel-ct-namensfunktion`; originSessionId `5a19728e-f6e1-4736-a246-e3fda9ac35a1` — wieder dasselbe Präfix wie der aktuelle Job)

**FAKTEN:**
- Owner-Entscheid zu F7 = "Option b" (06.08.2026, wörtlich): "Bitte Option b: Wir hatten einen komplexen Stempel mit allen Achsen-Kategorien festgelegt mit jeweils versionierten Achsen-Algorithmen und zum Schluss ein SHA Hash als fingerprint. Wir erzeugen eine Funktion, die zur compile time auch den Namen der Funktion aus dieser Rekombination in die binary schreibt und durch ein eigenes Interface der Stempel-Versionierung an jeder Planer/CEB/Tier-Binary anbietet. Dies soll ein gesondertes Versionierungs-Interface sein." — OWNER-WORT (06.08.2026)
- Bestehende Stempel-Substanz als Grundlage: alle Achsen-KATEGORIEN (Mess/System/Organ) mit je versionierten Achsen-Algorithmen, abschließend ein SHA-Fingerprint — **Format 3, 8 Glieder, Frozen-Vektor**. — MESSUNG/OWNER-WORT (Format-Spezifikation, aus Owner-Entscheid)
- NEU (Owner-Entscheid): eine Compile-Time-Funktion, die aus dieser Rekombination den NAMEN bildet und IN DIE BINARY schreibt (kein Laufzeit-String-Bau, keine zweite Ableitung). — OWNER-WORT (06.08.2026)
- NEU (Owner-Entscheid): ein GESONDERTES Versionierungs-Interface (eigenständig, nicht in bestehende Interfaces gemischt), das die Stempel-Versionierung an JEDER Stufe der Kette anbietet: **Planer, CEB, Tier-Binary (und damit auch Hybrid)**. — OWNER-WORT (06.08.2026)
- Begründung: bisher kennt jede Stufe ihren Stempel nur implizit; Namen (Ordner, Plan-Dateien, Sidecars) werden an mehreren Stellen abgeleitet → Drift-Gefahr. Löst zugleich F7 (Plan-Ablage-Name je Pass) strukturell statt per Suffix-Trick. — AGENTEN-BEHAUPTUNG
- Anwendung: analog zur Observer-Konsolidierung I1 (GENAU EINE Schnittstelle + EIN versionierter POD, ABI-Major-versioniert — Bezug zu Datei 1 dieses Bandes), aber als EIGENES Interface neben dem Observer, nicht darin. Name entsteht CT, nicht zur Laufzeit. Interface muss an jedem Dock ABI-stabil angeboten werden. Planung vorweg, Bau realistisch NACH Abgabe; F7-Zwischenstand bis dahin = Option 1 (dokumentierte Grenze). — AGENTEN-BEHAUPTUNG

**STAND:** GILT (06.08.2026, jüngster Stand des Bandes zu diesem Thema, keine Widerrufsspur gefunden).

**VERWEISE:** [[feedback_gattung_genus_interface_messparameter_achsen]] (= Datei 1 dieses Bandes, Cluster-Beleg — beide originSessionId 5a19728e, beide 06.08.), [[feedback_compile_time_only_no_runtime]] (Index: "Codegen" — verlinkt), [[feedback_no_runtime_switch]] (Index: "Stat. Dispatch" — verlinkt), [[feedback_recursive_dock_planer_ceb_tier_abi_stable_so]] (Index: "Dock .so" — verlinkt).

---

## 10. feedback_versions_flag_grammatik_dreistellig_hw_flag.md

**THEMA:** Versionsgrammatik dreistellig plus Hardware-Flag

**TYP:** feedback (internes `name:` = `versions-flag-grammatik-dreistellig-hw-flag`)

**FAKTEN:**
- Owner-Entscheid Q3-final (02.08.2026, wörtlich in `super docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md`, Nachtrag ~17:0xZ): Versionierungen sind einheitlich, **immer 3-stellig, beginnen mit 'v'**; Kurzformen (`v1`, `v1e`) sind **VERBOTEN** (Sentinel). Das Suffix ist eine **FLAG-Position**: Hardware-Flag `c`=CPU, `g`=GPU, `f`=FPGA, `n`=NPU, danach optional `e`=experimental. **CPU-only-Scope: ALLE Versionen enden mit `c` oder `ce`** — Beispiele: `v1.0.0c`, `v2.3.4ce`. — OWNER-WORT (02.08.2026)
- Begründung: einheitliche, erweiterbare Versions-Identität über künftige Hardware-Targets; 'e' bleibt die Prüfling-Experimental-Markierung. — AGENTEN-BEHAUPTUNG
- Anwendung: Parser/Renderer/CT-Wachen auf die Flag-Grammatik (Kennung A13-M1b); Bestands-Migration `v1.0.0`→`v1.0.0c` als Byte-Ereignis ins EINE A13-M2/M3-Neuanker-Fenster bündeln (kein zweiter Neuanker); zusätzliche Wache "genau ein Hardware-Flag, im CPU-Scope 'c'" neben der "ce-Registry nie 'e'"-Wache. — AGENTEN-BEHAUPTUNG

**STAND:** GILT (02.08.2026, keine Widerrufsspur in dieser Datei).

**VERWEISE:** [[stempel-regression-keine-merge-zeile-meta-meta-realm-ende]] (= Datei 8 dieses Bandes, Cluster-Beleg). **CLUSTER:** zusammen mit Datei 3 und Datei 8, alle aus `super docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md` — komplettes Owner-Entscheide-Paket vom 02.08. (Hybrid E1 + Stempel-Regression E2 + OS-Unterachsen E3 + Versions-Flag Q3-final) ist im aktuellen Index an KEINER Stelle direkt verlinkt, obwohl laut Datei 8 "trigger-blockierend vor Voll-Bau-4".

---

## 11. project_20260726_chunk_delta_verlorene_owner_antworten.md

**THEMA:** Chunk-Delta 26.07. — durch API-Störung verlorene Owner-Antworten

**TYP:** project

**FAKTEN:**
- Kontext: wortgenau rekonstruierte Owner-Antworten aus "verlauf-31/32" (26.07., API-Verluste), die im Kompaktierungs-Dossier fehlten. Voller Delta-Report D-01..D-17 im Workflow-Output der Session `wshvhykd7`. — MESSUNG (Session-/Workflow-Referenz)
- **D-01 (KERN, Plan-Umbau)**, Owner wörtlich: "Das Design und die Regressionen muessen vor dem voll Build und der voll Messung fest behoben und eingebaut sein." → Lane C (external_utils-HUB) NICHT inert lassen, Rename + R-F-Materialisierung VOR Voll-Bau-4 (nicht Band C). — OWNER-WORT (26.07.2026)
- **D-02:** PMC-Gate hart: `pmc:amd` UND `pmc:intel` müssen auf Comdare gesetzt+erfolgreich sein, bevor eine Maschinen-Lane den Strang abarbeitet (AND auf Comdare, XOR nur bei Fremd-Cluster). Runner-Filter verifizieren; festes PMC-TODO. — OWNER-WORT (26.07.2026)
- **D-03 (Frist-Definition):** Mo 27.07. = erste echte Mess-CSV trifft auf dem NAS ein ("Prof. Habich reicht es die ersten Mess-CSV eintreffen zu sehen"); LaTeX/PDF DANACH aus der Auswertung. — OWNER-WORT (26.07.2026)
- **D-04:** Binaries → ccache/minio; Messergebnisse → PR4100 Cluster_NFS Experiment-Ordner; lokaler Fußabdruck der Maschine gegen null. NAS-Endpoint-Preflight nötig (gleiche mc-Falle wie andernorts). — OWNER-WORT (26.07.2026)
- **D-05:** Voll-Bau invalidiert den Prototyp-Bestand (Ast-Neu-Inventarisierung); Bestandslog wird beim Build UND beim Messen JE REALM fortgeschrieben → Mess-Realm-Writer VOR 01.08. nötig. — OWNER-WORT (26.07.2026)
- **D-06:** Je Commit-Welle: development pushen + main nachziehen (FF) auf BEIDEN Remotes. — OWNER-WORT (26.07.2026)
- **D-07:** CI-Restpunkte vor Build-Neustart klären (sonst Binary-Verlust-Risiko). — OWNER-WORT (26.07.2026)
- **D-08:** github-PAT ist NEU; vor dem nächsten Dual-Push aus dem Cluster-Vault ziehen. — OWNER-WORT (26.07.2026)
- **D-09 (Lane A):** `load_framework` = letztes CEB-Glied UND stets ERSTE Meta-Meta-Achse; on/off-Token gehört in Ordner-/Metadaten-Namen ("hinter load_framework wenn vorhanden on/off"). — OWNER-WORT (26.07.2026)
- **D-10 (Lane A, OFFEN):** OS-Unter-Achsen = Version, Kernel, Build und Update-Zustand "und so weiter" → XML-erweiterbar bauen; **3-vs-4-Schnitt (Build separat?) = offene Owner-Rückfrage**. — OWNER-WORT (26.07.2026), STAND zu diesem Zeitpunkt: UNKLAR. **Diese Frage wird durch Datei 8 dieses Bandes (E3, 02.08.) aufgelöst: "die drei finalen OS-Unter-Achsen ... JETZT Pflicht" — 3-Schnitt gewinnt.**
- **D-11 (offen):** Owner schrieb wörtlich "extermal_utils" (Tippfehler) — Schreibweise "external_utils" ist die Korrektur-Annahme des Agenten, vor Lane C per Ein-Zeiler zu bestätigen. — OWNER-WORT (Tippfehler-Zitat) + AGENTEN-BEHAUPTUNG (Korrektur, ungeprüft)
- **D-12 (Lane A):** Binaries-Lager-Kaskade = System (Wurzel) → ORGAN → Mess (tiefster Typ). — OWNER-WORT (26.07.2026)
- **D-13:** Erlaubnis-Hälfte der Mapping-Reinheit: verschiedene RT-Unter-Achsen-Varianten auf DIESELBE CT-Haupt-Achse sind erlaubt (Begründung für 1 Sheet je Unter-Permutation). — OWNER-WORT (26.07.2026)
- **D-14:** Punkt "2.4-(8)" ist Vor-01.08.-Pflicht und wird NIE als erledigt geführt. — OWNER-WORT (26.07.2026)
- **D-15:** Dossier-Posten (Q-1 enabled=false, A-1 Truncate, R-F, CT/RT-XOR) sind paraphrase-basiert → beim Owner rückbestätigen (Byte-/ABI-relevant). — AGENTEN-BEHAUPTUNG (Unsicherheits-Vermerk)
- **D-17:** thesis-Klon mit Dual-Remote nach `super/Code/external` UND `Projekte/Research` pullen. — OWNER-WORT (26.07.2026)
- **NACHTRAG (F4/F5-Suchlauf, 26.07. ~15:15):** Backup-LÜCKE erklärt: der Plaintext-Extraktor verwarf **982 `queued_command`-Records** (getippte Owner-Nachrichten während Agenten liefen) — deshalb fehlten die Entscheid-Antworten. Behebung: Extraktion um `attachment.queued_command.prompt` erweitern, additiv ergänzt. — MESSUNG (Fehleranalyse mit Zahl)
- Alle 4 Kerne owner-verbatim BESTÄTIGT, mit jsonl-Stellen **79807/79891/79936/79475**: Q-1 ("Wie empfohlen, korrekt. Die Achse wird per XML deaktiviert und das muss unterstuetzt sein"); A-1 (wortgenau: Build-Ende=Regelfall, >4KB=ad hoc, Alleinschreiber-Lock); R-F ("zu denen auch AVX und SIMD gehoeren -> weitere Regression"); CT/RT (Owner-Original = Bikonditional "Haupt=CT statisch, Unter=RT-dynamisch", Kriterium "zur Laufzeit austauschbar => Unter-Achse"). — MESSUNG (jsonl-Zeilen-Belege, wörtliche Owner-Zitate)
- Nebenbefund Q-0, Owner wörtlich: "V2 Byte-Schnitt volles GO. Ich wuensche mir dennoch V3 direkt mit rein" — deckt den Kurs ORG-18+W-13 in V2-Schnitt. — OWNER-WORT (26.07.2026)
- "2.4-(8)" DEFINIERT als Punkt 8/9 in Abschnitt 2.4 des G4b-Verdikts (`backups/20260726-g4b-planung-workflow/ergebnisse/00-verdikt-abeddd8c.md:122`) = "Kein Claim-CHECK, kein Takeover" = ABNAHME-6: `is_reservation_takeable`/`is_takeable_by_eta` (`reservation_lifecycle.hpp`) gebaut+getestet, **0 Produktions-Aufrufer**. Bewusst aus G4b/(d2) herausdefiniert (filternder Provisions-Pfad-Eingriff vor 2-Tage-Lauf = größtes vermeidbares Risiko), PFLICHT vor 01.08. im Phase-4-Paket, erscheint NIE in G4b-Erledigt-Bilanzen. — MESSUNG (Datei:Zeile-Beleg + Code-Fakt)

**STAND:** Teils GILT (D-01 bis D-14, D-17 als bindende Owner-Antworten), teils UEBERHOLT durch spätere Entscheide (D-10 OS-Unter-Achsen-Zahl aufgelöst durch Datei 8), teils UNKLAR/offen zum Dateidatum (D-11 Schreibweise, D-15 Rückbestätigungsbedarf).

**VERWEISE:** [[project_achsen_neuordnung_bindende_sortierung_regressionen]] (Index: "Achsen-Sort." — verlinkt), [[project_bestandslog_abnahmen_baum_heuristik_stempel]] (Index: "Abnahmen" — verlinkt), [[project_frist_montag_2707_zeitbudget_bau_messen]] (**existiert, unverlinkt** — Cluster-Fund, auch von Datei 12 referenziert).

---

## 12. project_20260726_nach_trigger_alle_baender_abarbeiten.md

**THEMA:** Nach Trigger alle Bänder am selben Tag abarbeiten

**TYP:** project

**FAKTEN:**
- User-Wunsch (26.07.2026, wörtlich, nach Lager-Gate-Abschluss): "dass wir heute nach dem Start des geplanten Build+Messlauf alle noch offenen Punkte und Baender abarbeiten, soweit wie definiert." — OWNER-WORT (26.07.2026)
- Bedeutung: ~30h-Laufzeit des Voll-Bau-4 (2^17) ist kein Warte-, sondern ein Arbeitsfenster. Nach Trigger (Gate 4) Bänder in Gate-Reihenfolge: Ledger-Nachzug (W-30..W-38 aus dem Lage-Dossier 26.07.), G8-Anhänge-Vorarbeiten (W-31-Klärung B/E), Phase-4-Definiertes (#46b-Vollzug, §65 lokal→0), Band C in freigegebener Reihenfolge (#34 CLI → #35 .so → #36 → #44 → #38 → #37), soweit definiert — Gates G-a..G-j bleiben User-gated. — AGENTEN-BEHAUPTUNG (Interpretation des Owner-Wunsches)
- **Betriebs-Auflage, ERGÄNZUNG (User, 26.07. später), Punkt 1: "Runner-concurrency=1" auf den GitLab-Runnern (prod1/prod2)**, um die Messung nicht zu stören — Pipelines queuen seriell, das ist gewollt, kein Defekt. Bei CI-Staus NICHT an der concurrency drehen. — OWNER-WORT (26.07.2026)
- Punkt 2: nach Fertigstellung der Bänder Dual-Weg-LOKAL-Beweis (cmake+Shell, offizielle Targets, §61-Dual-Weg); lokaler Build-Stand ist ERHEBLICH hinterher = eigenes TODO (Board #10); zugleich 28.07.-Abgabe-Anker (V6.6/F12(i): CI UND standalone messfähig auf EINER Maschine). — OWNER-WORT (26.07.2026)
- Punkt 3: User steht den GESAMTEN Tag (26.07.) für Rückfragen zur Verfügung — echte Entscheidungsfragen dürfen zeitnah gestellt werden statt lange autonom zu hängen. — OWNER-WORT (26.07.2026)
- USER-ENTSCHEIDE 26.07. zu 7 Vorlagen (bindend): (1) W-13 FIXEN vor Trigger. (2) **Bestandslog AN im Voll-Bau-4** — `run_planer_driven_provision` ist der Haupttreiber; Bestand wird später invalidiert+neu gebaut, aber der ERSTE Voll-Build läuft MIT voller Bestandslogik (Option B); Bestandslog wird beim Build UND beim Messen JE REALM gepflegt. (3) N7-Lock NICHT aufschieben — G4b-Verdikt hatte die Lock-Stelle missverstanden ('dauert keine 40 Minuten'); N7 heute korrekt umsetzen. (4) (d2)/E1-E5 heute in aller Gründlichkeit; Vertagung nur unter expliziter User-Abnahme. (5) Scrub-Fenster: anhalten, User sieht es und stößt Infra an. (6) **Voll-Build+Voll-Messung ersatzlos; erste Mess-CSV rechtzeitig aufs NAS = Beweis für Prof. Habich; LaTeX/PDF danach entwickelt. Kein Mess-Teillauf vorgezogen.** (7) **Nach dem Scrub BEIDE Remotes public** (nur Diplomarbeit-Repos — Forschung soll öffentlich sein; übrige Forschung=Products bleibt nicht-public). — OWNER-WORT (26.07.2026)

**STAND:** UEBERHOLT für die operative Frist (26.07.-Kontext liegt weit zurück, Voll-Bau-4 wurde mehrfach verschoben — s. Datei 13), aber die einzelnen Entscheide (Bestandslog-Modus, Remote-public-Freigabe, Dual-Weg-Pflicht) tragen keine erkennbare Widerrufsspur in diesem Band. **WIDERSPRUCH/hochrelevant:** "Runner-concurrency=1" (26.07., User-Wort, Grund: Messung während Voll-Bau nicht stören) ist ein **dritter Datenpunkt** zur heute als kritisch erkannten Runner-Concurrency-Frage — bekannt sind bereits "Wellenplan sagt 2" und "die Wahrheit ist 4" (laut Aufgabenstellung, nicht Teil dieses Bandes). Diese Datei liefert den ÄLTESTEN bekannten Wert (1, mit explizitem Nicht-Stören-Zweck) — die Kette 1 (26.07., hier) → 2 (Wellenplan, undatiert) → 4 (Wahrheit, andere Quelle) sollte bei der Zusammenführung der Bänder chronologisch rekonstruiert werden.

**VERWEISE:** [[feedback_autonomie_modus_plan_autonom_durchziehen]] (Index: "Plan autonom" — verlinkt, §63 bis leeres Backlog), [[project_frist_montag_2707_zeitbudget_bau_messen]] (**existiert, unverlinkt** — Cluster-Fund, identisch mit Datei 11).

---

## 13. project_20260727_vormittag_o8_fenster_lage.md

**THEMA:** O-8-Fenster-Lage, mehrtägiger Statusverlauf 27.07.-02.08.

**TYP:** project

**WICHTIGER BEFUND VORAB:** Frontmatter-`description` sagt "Lage-Anker 27.07. vormittag" — der Fliesstext reicht aber tatsächlich bis **02.08. ~00:xx** (6 Tage weiter als die Beschreibung suggeriert). Klassisches Beispiel für die im Auftrag beschriebene Falle: Beschreibung ist älter als der erweiterte Fliesstext.

**FAKTEN (chronologisch nach Zeitstempel im Dokument):**

- **STAND 27.07. ~08:45Z:** O-8-Fenster an Agent Impl-O8 vergeben (Nachfolger von Impl-V6). Plan = `super docs/sessions/20260727-PLAN-o8-fenster-atomar-ultracode.md` Rev. 3, alle 11 OPs final. 4a-Re-Pin abgenommen: Pins super `6ca9502f` / ce `7dd41b18`; Neu-Basis ce 316 / super 453. ZWEI-GATE-ENTSCHEID (Manager, nach Befund "super 453/453 war NIE belegt"): ce-standalone = scharfes Gate (316/316, CRC `0x56F1B721C72DC10E`, Golden-Doppellauf); super = Integrations-Gate (Erwartung 450/5/453, eingefrorene 5er-Fehlerliste: v31_adapters=SEGV vendor-snmalloc Ledger:514, v41_topic_allocator=Abort dito, limits_entkopplung+lazy_adhoc=CRC-MISMATCH konfigurationsgebunden, axis_registry_roundtrip=contract-Drift gewollt). — MESSUNG (SHA/CRC-Belege)
- CI/Toolchain: Pin-Fix ci-templates development `b0b2fb6` (.test: 15>Default, NIE 13). KANON-Doktrin (Owner 3x wörtlich, Ledger §76): **15.3 = Minimum+Standard+DEFAULT**; 16.0.1-Grün nur Zwischen-Signal; Beweis erst nach Host-Installation 15.3 (prod1+prod2 beide ohne g++-15, Probe-Belege 334243/334819). v2-Image-Digest `a43c7fe5`. — OWNER-WORT (Kanon-Doktrin, 3x wiederholt) + MESSUNG
- **NACHTRAG ~11:50Z (CiCheck288e):** docker-Executor-Pilot lief real — Runner 56, Job 334886 (Projekt 547, Pipeline 13531, main, 09:32:01→09:38:11Z, success), Image trägt Debian 13 trixie, "g++ (GCC) 15.3.0", "cmake version 4.4.0". **Owner-/Manager-Kanon-Entscheid gegen Fehlalarm: Container-15.3 kürzt die Kanon-Welle NICHT ab** — Kanon bleibt ausschließlich Host-g++-15(.3) auf prod1/prod2 (Mess-Doktrin verbietet Container für Messungen). prod1-Host-Ist 11:43Z: kein g++-15, Default 16.0.1 (trunk r16-8100). Nebenbefund: der Pilot-Job war FALSCH-GRÜN (heredoc-printf zerbrach Teststring, Build scheiterte real, danach lief dennoch ein Erfolgs-Echo) — docker-Weg als Bauweg damit UNBEWIESEN. Zusatzbefund: 324s-Finalisierungslücke auch auf Runner 56 (Trace-Ende 09:32:39Z vs. finished_at 09:38:11Z = 332s bei 1s echter Laufzeit). — MESSUNG (Job-IDs, Zeitstempel, wörtliches Fehlerzitat)
- **FINAL-UPDATE ~12:25Z:** O-8-Fenster gelandet. ce dev `7dd41b18`..`e6aeee17` (17 Commits), super dev `6ca9502f`..`88ccd1b7` (5 Commits, Gitlink-Bump), beide Remotes, main unberührt. Nächste Reihenfolge inkl. "**Voll-Bau-4 01.08. (P5-heavy verbindlich c=1/24/nproc)**". — MESSUNG (SHA-Belege) — **die Notation "c=1/24/nproc" mit der Zahl 24 ist möglicherweise die Quelle der heute im Index als falsch erkannten "24" (vgl. Index: "prod1 = 16 Kerne/32 Threads — OD-7 setzt 24: Konflikt"); nicht sicher belegt, aber numerisch auffällig und denselben Kontext (P5/OD-7 heavy) betreffend — sollte gegengeprüft werden.**
- **BEWIESEN ~12:43Z:** O-8 komplett CI-bewiesen (ce 286/13540, 17 Jobs grün; super 288/13545, 13 Jobs+3 Bridges grün; build:clang 66,8s; lint:secrets liest 107,90 MB). SHAs: ce `e6aeee17` / super `b3cf9a3a`. — MESSUNG
- **TAGES-DOPPELABSCHLUSS ~15:10Z:** D3-CI-Paket komplett + Kanon vollzogen: main==development auf ALLEN drei Linien (ce `e6aeee17` / super `d6777094` / ci-templates `5f9e04be`). KANON: gcc-15.3 = nativer alternatives-Default auf BEIDEN Hosts; CI-bewiesen Wellen 288/13555 (13/13+3 Bridges) + 286/13556 (17 grün) komplett auf GNU 15.3.0 (**prod2-Erstbeleg 335376**). Watchdog-Root-Cause gefunden: `gr-eof-watchdog` wertete Log-Stille als Defekt (36 Restarts/24h → Zombies), Fix v3. Erneut: "**Voll-Bau-4 ab 01.08. auf der 15.3-Kanon-Flotte (P5-heavy c=1/24/nproc steht)**." — MESSUNG (SHA, Job-Wellen, Zahl "36 Restarts/24h")
- **KONTEXT-ENDE ~15:30Z:** Übergabe = `super docs/sessions/20260727-UEBERGABE-tages-doppelabschluss-o8-d3-kanon-153.md` (Commit `a4dc6891`, dev+main beider Remotes). main==dev== `a4dc6891` (super) / `e6aeee17` (ce) / `5f9e04be` (ci-templates). — MESSUNG
- **NACHMITTAG ~16:10Z:** 6a geschlossen (Beweis 2 beidseitig terminal: Positiv 13561/13560/13564 success, Negativ 13567+13569 docs-only-main mit bridges=0). Referenz geeicht: docs-only-main=13 Jobs/0 Bridges, docs-only-dev=2 Jobs. 6b OP-2 done: `test:unit needs:["verify:submodules"]` (`abbf53ef`, Welle 13570, 13/13+3/3 grün) — Korrektheits-Fix, kein Scheduling-Fix (frühere Herleitung war falsch: `.test` erbt `needs:[]`). Nach Welle 13574 grün: main-FF auf `57b61af0`. — MESSUNG (Commit-SHAs, Job-Wellen)
- **PROZESS-REGEL ab 17:10Z:** prod1 hat `cf22` (`~/tools/cf22/usr/bin/clang-format-22` = exakt CI-Version 22.1.8, laut Memory `reference_ce_facade_...` bekannt seit 09.07.). Neu ab hier: JEDES Impl-Briefing mit C++-Änderung trägt den cf22-Pfad + Pflicht-Selbstcheck `clang-format-22 --style=file:.clang-format --dry-run --Werror <geänderte Dateien>` mit LITERALER (leerer) Ausgabe in der Paketmeldung; Manager-Format-Abnahme bleibt zweite Linie. Analog ASCII: sed-Form (grep -v ist zeilenblind). — AGENTEN-BEHAUPTUNG (Prozessregel, aus Fehleranalyse "2 vermeidbare Manager-Nachfixes")
- **ABEND ~18:30Z:** Task-#7-Spec komplett (`cad7290e`): HW-Erkennung = zweigeteilte MESS-Achse (Planer-RT baut ein wie Mess-Programme, CEB-CT trägt; Stempel = Vendor-Erkennungs-Kategorie-FAMILIE x OS) — **deckungsgleich mit Datei 2 dieses Bandes (FINALE EINORDNUNG)**. P2-P6 RUHEN per Owner-Wort bis Voll-Build+Messdurchlauf (Ausnahmen: E-2 Schlüssel-Fix + OP-9). Wellen-Modell präzisiert (13600): changes-Gate wirkt PRO BRIDGE — reiner Gitlink-Bump feuert nur `trigger:cache-engine` (1 Bridge); 3-Bridges-Fälle kamen stets von `.gitlab-ci.yml`. Stände: ce main==dev==`a3bc2e13`; super main=`e0893eb5`, dev=`cad7290e`. — MESSUNG (SHAs)
- **~18:50Z:** OP-9 (built_stem additiv v1.1) + E-2 (ram_pair ddr5_2x32, Bump `25ad654b`) + **V-4 RETIRE** (`813c3232`, **-2183 Zeilen**; `comdare_permutation_codegen_cli` EXISTIERT NICHT MEHR) + Identitäts-Tests registriert (`52bcbc76`: test_o4+test_c3a ins Gate, netto **318**). Gate-Referenzen: ce-ctest 318 (+23 gtest-Fälle); super-Gesamtsuite-Referenz war 458/5/453, wird nach V-4 neu zu messen sein (-2/+2 ce-seitig). — MESSUNG (Commit-SHAs, Zeilenzahlen, Testzahlen)
- **~19:15Z ABBRUCHSICHERE PAUSE:** Spend-Limit ~19:04Z killte ALLE Agenten; danach GitLab-500-Störung ALLER Auth-Pfade (neue PAT-Kandidaten=500, alte=401 → serverseitig; github intakt). Autorität: `super docs/sessions/20260727-PAUSE-abbruchsicher-gitlab500-wiederaufnahme.md`. Wellen 13623/13624/13625-Ausgänge unbekannt zu diesem Zeitpunkt. Task-Board vom Spend-Limit-Neustart komplett gelöscht (TaskList leer). — MESSUNG
- **WIEDERAUFNAHME 01.08.2026 ~19:00Z (NICHT 27.07.!):** Pause dauerte **5 Tage** (Serverzeit-Beleg CiCheck288g; Runner-PID 1939298 lief durch, etime 5d). GitLab entstört. Ausfall-Wellen 13623/13624/13625 alle success, kein Job verloren. FFs+Bump gepusht: super main=`25ad654b`, dev=`45519f9b` (Bump auf ce `52bcbc76`); ce main==dev==`52bcbc76`. FRIST-LAGE zu diesem Zeitpunkt: "Voll-Bau+Messung 'ab 01.08.' = HEUTE." — MESSUNG (5-Tage-Lücke belegt, SHAs)
- **01.08. ~20:45Z OWNER-ENTSCHEIDE OE-A..F** (Fahrplan-Doc-Nachtrag, wörtlich dort): **FRIST → FREITAG 08.08.**; alle bekannten Pakete Pflicht vor Voll-Bau (HW-Erkennung P2-P6 reaktiviert, OD-10, E-04/E-18, Benchmarking-Schnitt, xlsx-Factory, 12-Perm "alles was geht"); Beweis 1 = Batch-Wiederaufnahme-Konstruktion (Pflicht, nicht Minimal-Ersatz); Beweis 2 = gtest-Dummy-Lager (Textdateien mit Stempel-String); **OE-C: jede Haupt-Achse trägt Versions-Tag, Version-Bump → selektive Invalidierung aller betroffenen Binaries**; `VARIANT_GATE=true` im Trigger. 3-Dossier-Workflow `wf_62640a90` läuft. — OWNER-WORT (01.08.2026) — **WIDERSPRUCH/UEBERHOLT: die Frist "Freitag 08.08." ist durch die heute im Index geltende Frist "GOAL v8 ... bis 15.09." klar abgelöst worden — beide Werte hier ausdrücklich benannt, die Reihenfolge (08.08. galt zuerst, danach 15.09.) sollte bei jeder Fristangabe mitgeführt werden.**
- **01.08. ~22:00Z ABEND-PAUSE:** Autorität = `super docs/sessions/20260801-PAUSE-abendstand-wiederaufnahme.md`. Tages-Ertrag: OE-A..F+F1-F9 entschieden; P2 HW-Erkennung gebaut+gepusht (Gate **320**); Thesis K0/K1/K2 abgenommen; offen nur F10+F11; kritischer Pfad: Lager-Baum-Vollausbau VOR Trigger (F9). — MESSUNG
- **02.08. ~00:xx KONTEXT-ENDE + NEUGRÜNDUNG:** Autorität = `super docs/sessions/20260802-UEBERGABE-kontextende-neugruendung.md` (main==dev, beide Remotes). 3 frische Agenten: Thesis-Sprachpass, CiCheck288h, Impl-CE-P3. F1-F13+OE-A..F alle entschieden. — MESSUNG

**STAND:** Überwiegend UEBERHOLT (reiner Tages-Statusverlauf, mittlerweile durch spätere Übergabedokumente ersetzt), aber als **historischer SHA-/Zahlen-Anker unverzichtbar** — genau die Art Datei, in der (laut Auftragsbeschreibung) "die 47 von 47" unrekonstruierbar wurde, wenn man sie nicht aufhebt. Frist "08.08." darin ist ausdrücklich durch spätere "15.09." (GOAL v8, heutiger Index) überholt.

**VERWEISE:** [[project_achsen_neuordnung_bindende_sortierung_regressionen]] (Index: "Achsen-Sort." — verlinkt), [[reference_lokale_vollbau_luecken_falsches_gruen]] (**existiert, unverlinkt** — Cluster-Fund), [[reference_ci_trace_parsing_commit_titel_falle]] (**existiert, unverlinkt** — Cluster-Fund, zweimal im Dokument referenziert).

---

# WIDERSPRÜCHE UND CLUSTER-FUNDE (Übersicht)

1. **Runner-Concurrency, drei Datenpunkte über Zeit:** Datei 12 (26.07., User-Wort) = **1** ("um die Messung nicht zu stören"); Aufgabenstellung nennt zusätzlich "Wellenplan sagt 2" und "die Wahrheit ist 4" (Quelle außerhalb dieses Bandes). Chronologische Kette noch nicht vollständig rekonstruiert — dieser Fund liefert den frühesten bekannten Wert.
2. **MIKRO/MAKRO-Messmodell, Selbstkorrektur in Datei 1:** ursprüngliche Zuordnung (MIKRO=axis_stats/MAKRO=seg_ns/WALLCLOCK=außen) vom Owner am 06.08. ausdrücklich für FALSCH erklärt ("Micro- und Macro-Benchmarking sind FALSCH"), danach durch quellengeerdete KANON-REKONSTRUKTION ersetzt (WALLCLOCK je Tier-Binary-Interface-Funktion x Last-Kombination). Frage F6 (betrifft §47-Konzept insgesamt) blieb zum Dateidatum offen.
3. **OS-Unter-Achsen, 3-vs-4 aufgelöst zwischen zwei Dateien desselben Bandes:** Datei 11 (26.07., D-10) führt die Anzahl noch als offene Owner-Rückfrage (Version/Kernel/Build/Update-Zustand); Datei 8 (02.08., E3) entscheidet: drei finale OS-Unter-Achsen, jetzt Pflicht.
4. **Frist-Supersession:** Datei 13 (01.08.) — "FRIST → FREITAG 08.08." (Owner-Entscheide OE-A..F) — vs. heutiger Index — "GOAL v8 ... bis 15.09." Beide Werte mit Datum belegt, ältere klar überholt.
5. **Stale Frontmatter-Description:** Datei 13 beschreibt sich selbst als "Lage-Anker 27.07. vormittag", der Fliesstext reicht aber bis 02.08. — Beispiel für die im Auftrag genannte Falle.
6. **Doppelte unverlinkte Supersession (Datei 4):** die Datei erklärt sich selbst für überholt durch `feedback_fable5_xhigh_agenten_fuer_alles_kein_opus.md` — diese Nachfolgedatei EXISTIERT (geprüft), ist aber ebenfalls unverlinkt. Weder die alte noch die neue Fassung der Implementierungs-Delegationsregel ist im aktuellen Index auffindbar.
7. **Möglicher Prozess-Widerspruch (Datei 6):** "bei JEDEM Explore-Aufruf parallel Codex" (34 Tage alt) vs. heutiges Index-Verfahren "2-STUFIG" (Sonnet5-max, dann selbst gegenlesen) — unterschiedliche Zwei-Stufen-Modelle, Ablöse-Status nicht sicher zu klären.
8. **02.08.-Owner-Entscheide-Paket komplett unverlinkt:** Dateien 3, 8, 10 (Hybrid E1, Stempel-Regression E2, OS-Unterachsen E3, Versions-Flag Q3-final) — alle aus derselben Session `super docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md`, alle als "trigger-blockierend vor Voll-Bau-4" bezeichnet, keines im Index verlinkt.
9. **Numerische Auffälligkeit "24":** Datei 13 nennt zweimal "P5-heavy c=1/24/nproc" (27.07.) im Kontext Infra-Handout P5/OD-7-heavy — möglicher, nicht sicher belegter Ursprung der im heutigen Index als falsch erkannten "24" bei "OD-7 setzt 24: Konflikt" (prod1 hat tatsächlich 16 Kerne/32 Threads).
10. **Weitere existierende, unverlinkte Cluster-Dateien außerhalb dieses Bandes** (Existenz geprüft, Inhalt NICHT gelesen — vermutlich Gegenstand anderer Bänder): `feedback_fable5_xhigh_agenten_fuer_alles_kein_opus.md`, `feedback_codex_mcp_review_before_code_complete.md`, `reference_rescue_ref_ist_keine_landung.md`, `project_lager_basis_tests_dummy_strategien_stempel.md`, `project_frist_montag_2707_zeitbudget_bau_messen.md`, `reference_lokale_vollbau_luecken_falsches_gruen.md`, `reference_ci_trace_parsing_commit_titel_falle.md`.
11. **Methodik-Hinweis (aus Datei 7 selbst abgeleitet):** dieser Extraktions-Job liest ausschließlich die 13 Memory-Dateien aus `band_01` (Quellenklasse: nur `.claude/projects/-home-comdare/memory/*.md`, keine `docs/sessions/*`-Dokumente) — sollte bei Zusammenführung aller Bänder als Scope-Angabe mitgeführt werden.

---

**BEARBEITET: 13 von 13 Dateien aus band_01 (Nenner: 13).**