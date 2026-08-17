# LEDGER-GEGENLESE — SEGMENT KON59 → KON36 (Z. 2834–5258, 13.08./12.08.2026)

Gelesen: Z. 2834–5258 vollständig (5 Häppchen), Datei bei 29858 Zeilen — **keine Drift**, Segmentgrenzen exakt (Beginn `KON59`-Überschrift Z. 2834, Ende `KON36-02` Z. 5258).
Abgeglichen gegen `/home/comdare/.claude/jobs/5a19728e/tmp/kopf_referenz_kon60_93.md`.

---

## (A) LEBEND-ABER-IM-KOPF-UNSICHTBAR

### A.1 — Die KANAL-DOKTRIN (KON50–KON54): fünf Owner-Nachträge, **null** Spuren im Kopf

Das ist der größte zusammenhängende Blindfleck. KON60–93 kennt aus diesem Block nur die Arena-Kette (KON92/93) — die **Naht-, Sprach-, Stumm- und Steuersemantik fehlt komplett**.

- **KON50-01** — Planer↔CEB trägt **dieselbe Flächen-Schablone** wie CEB↔Tier: Fläche 1 = **Control-Interface, stream in / stream out** (hinab: erkannte Anforderungen; hinauf: Status erfolgreich/nicht + **Log-Message warum**), Fläche 2 = der Stempel. Owner: *„die CEB misst und die Daten Verarbeitet, schickt sie dem Planer nur die Ergebnisse ihrer arbeit als Trace für die Kommandozeile"* ⇒ **RÜCKWEG-GRENZE: keine Mess-Rohdaten zum Planer**.
- **KON50-02** — der §38-Rückkanal trägt **DREI** Nachrichtenklassen, nicht eine: (i) Fortschritts-Deltas · (ii) **Status je Anforderung + Fehler-LOG** (neu, owner-gesetzt; Konsumenten T-15b/failed-Doktrin) · (iii) Ergebnis-Trace.
- **KON51-01** — Planer→CEB spricht **AUCH XML, aber GEFILTERT** (nur die Programmteile, die die CEB wirklich braucht, aus der syntax-geprüften Eingangs-XML). Fläche 3 am Prüfdock: **ausgehend Signalfunktion, eingehend Stream der Messwerte nach dem Flush**; Format **KEIN XML — SPARSE BINARY**. *„Die Serialisierung der Werte von measurement ist kein XML sondern sparse binary."*
- **KON51-02** — Arenen: Tier/Hybrid je **eigene, bei Anforderung eingebaute** Mess-Arena für checkpoint-measure; Flush **nur zu definierten Hol-Punkten** in die CEB-RAM-Arena; **Rückschrieb gesammelt am Experiment-Ende**; Warnung an den Planer bei **>6 GB**.
- **KON51-03** — **Stummschaltung**: während der Messung Planer↔CEB stumm; beidseitige Aggregation bis zum **Break des EINZELNEN** Experiments; Fertig-Signal überspringt alle Prioritäten ⇒ **es gibt Prioritätsklassen im Kanal**.
- **KON52-01** — **die OOB-Klasse ist GENAU EINE Nachricht: das Fertig-Signal.** Owner-Begründung, tragend für jeden Kanal-Bau: *„Nur das Fertig-Signal darf die Prioritäten überspringen, weil Zwischen-Signale Latenzen erzeugen, welche Messwerte verfälschen."* Harter RAM-OOB = **XML-Opt-in, kein Default**; Defaults: `ram_warn_grenze` 6 GB, `ram_oob_grenze` **aus**, beide separat XML-einstellbar (S-13/B1-XSD-Posten).
- **KON53-01** — das Inter-Experiment-Fenster ist eine **volle bidirektionale Sync-Barriere**: Startbedingung = alle Nachrichten **beider** Seiten vollständig ausgetauscht (Drain-Quittung). Fortgangs-Wahl: **`--auto`** oder **manuelle Bestätigung**; **die CI-Kette fährt `--auto`** (KON53-02, deklarierte Ableitung).
- **KON54-01/-02** — der Nutzer kann das nächste Teil-Experiment **VERNEINEN**; **`kill`-OOB von der CLI** → Planer → CEB, **halb sauberer Stopp**; *„Ja das Lager heilt das."* Das Planer→CEB-Kommando-Vokabular der Stummphase ist damit abgeschlossen: **{stop_ram_oob, stop_user_kill}**, sonst leer.
- **KON54-03** — halb sauberer Stopp schreibt **NICHTS Unvollständiges ins Lager** (Teilstände wären ein falscher Skip beim Wiederanlauf).

> Bau-Wirkung dieses Blocks: **S-8 (`--auto` neben `--debug`, Bestätigungs-Prompt ja/NEIN, kill-Kommando) · S-10 (Barriere-Protokoll + Prioritäten + OOB) · S-9/S-12 emittieren gegen diese Naht (Prozess+Streams statt YAML) · #20 Fläche-3-Vereinigung · S-13 bleibt GETRENNT (Export/Lager = Daten-Weg, Trace = nur Sicht).** Im Kopf steht als lebender Platz nur „#20 Fläche-3" und „#18 S-13-Bündel" — **ohne diese Semantik**.

### A.2 — Compiler als künftige System-Achse (KON55) — im Kopf nicht vorhanden

- **KON55-01** — Owner verbatim: *„der build auf allen Diplomarbeit Projekten auf der CI und lokal generell zuerst mit clang und auch mit gcc Pflicht ist … Compiler Performance Unterschiede bringen, weshalb sie eine System-Achse belegen werden … Nur clang reicht nicht, weil wir sonst spätestens im CEB Problemen bek[o]mmen."* {clang, gcc} = **Basis-Belegung einer künftigen System-Achse**; S-9/S-11 permutieren künftig **über die Compiler-Belegung**, die Versionen wandern als Achsen-Werte in Stempel/Preimage (System-Realm).
- **KON56-03** — das **Compiler-Achsen-Ruling 17.07.** ist konkret: **5. System-Achse `gcc|clang`, Unterachsen opt/flags/commands, Default `Ofast`**. Der Kopf nennt (KON72) nur „doppelte HW+SW-Versionierung" — **die Achsen-Slot-Belegung selbst fehlt.**

### A.3 — Termin-/Kapazitätsrechnung: die Zahlen, die T-3 und den Bau-Trigger tragen

- **KON41-01** — Owner-Auftrag „analysiere das Problem eigenständig", erste Rechnung: Neubau **128 × 19,4 min ≈ 41,4 h einlanig**; *„🔴 DER OV-4-MESS-DECKEL WIRD VOM T-3-FENSTER HER KALIBRIERT"* — Bau + 1-Thread-Messung müssen in **≤2,5 Maschinentagen zweilanig** tragen. **NEUER Strecken-Posten: „OV-4-Deckel = f(T-3-Fenster)" — in W2 mit den S-19-Zahlen rechnen, VOR der GO-Vorlage ##51.** Der Kopf führt „#7 S-19 MEILENSTEIN Sa 22.–Mo 24.08." — **den daran hängenden Deckel-Posten nicht.**
- **KON58-03 (OD-7)** — N-3/N-4 neu gerechnet: zweilanig prod1 @16W ~22,8 h (ANNAHME) gegen prod2 @24W **GEMESSEN 34,4 h** ⇒ **der Engpass bleibt Intel**, die 24→16-Umstufung ändert die zweilanige Wanduhr **nicht**. **Einlanig aber: 41,4 h @24W → ~45,6 h @16W** — die T-3-Rechnung aus KON41-01 wird dadurch **schlechter**, ohne dass irgendwo nachgezogen wurde.
- **KON58-03** — **PFLICHT-NACHKALIBRIERUNG** beim ersten realen 4096er-Batch @16W: **es existiert KEIN amd-16W-Lauf in den Traces** (nur @24W und @32W).
- **KON58-03** — die HEAVY-Schaltung ist **SIGNAL-GATED** (Infra-Zusage 02.08.); das Handout ist **kein** heavy-Signal, sondern nur die Änderung des Deckel-Werts **für das nächste angeforderte Fenster (Bau-Trigger 26.08.)**. ⇒ Für den 26.08. muss jemand **das Signal senden** — nirgends im Kopf.
- **KON36-02/J** — Kapazitäts-Fakt „20,7/34,4 h" und **„8 von 9 thesis_profiles xlsx-blind (Kampagnen-Blocker)"** (KON36-02/H) — der Kopf baut in KON87–89 das Sheet-/CSV-System, kennt diesen Blocker aber nicht.

### A.4 — Identität/Stempel: ein preimage-brechender Bump, der VOR dem F2-Freeze liegen muss

- **KON41-04 (Owner verbatim)** — der Hybrid *„hat also noch eine Zeile mehr als Tier-Binary"*: **vorletzte Zeile = serialisierte compile-time-Map {Synthese-Funktions-String-Key → Tier-Binary-am-Prüfdock-Stempel}**, konkateniert über alle belegten Prüfdocks; **letzte Zeile = SHA, der compile time AUCH über diese neue Zeile wirkt**. *„Hybrid erbt also das Stempelverhalten von Tier-Binary und fügt die besagte Zeile an der Stelle ein."*
- **KON45-01** — die Bau-Konsequenzen: **10. Glied für ALLE Binaries (Tier trägt ""), Format-Bump 4→5, GliedCount 9→10**; POD `komposit_line/len` **append-only, Layout 6→7**; ausdrücklich *„Format+Layout-Bump GEBÜNDELT VOR F2/26.08."* und *„mit dem bereits geplanten WE-Layout-Bump in EINEN Bump falten (KON5-04: ein Bruch statt zwei)"*. **Der Kopf setzt den F2-Identitäts-Freeze auf Fr 21.08. und erwähnt weder Format-Bump 4→5 noch Layout 6→7.**
- **KON45-01(5)** / **KON58-11(d)** — **PREIMAGE-BUDGET-BRUCH**: 32 belegte Docks × (Key+128hex+Trenner) ≈ **>4,5 KB sprengen `kAnatomyFingerprintPreimageMax=4096`** (anatomy_fingerprint.hpp:68, Wache :478) ⇒ Konstanten heben **MIT Budget-Beleg**. Trägt **keine Task-Nummer**.
- **KON45-01(6)** — die Synthese-Keys **existieren nicht**; `strategie_name()`-Literale („Reroute<View>") **verletzen den Glied-Zeichenvorrat** ⇒ **eigene Key-Grammatik nötig**, bis HY-A2 adressbasiert ist.
- **KON47-02 (Owner verbatim)** — *„wir verwenden für jedes Tier-Binary nur dessen SHA statt des gesamten Stempels"* + **RT-Cache**: beim Hybrid-Init werden die **vollen** Tier-Stempel an den Prüfdocks gecacht und sind **von der CEB über Fläche 2 zur Laufzeit abfragbar**. Invariante **RT-Menge ⊆ CT-Map**.
- **KON58-05** — die **EISERNE REGEL** golden-neutralen Bauens: *keine Datei unter `axes/`, `topics/` oder `heuristik/` anfassen — Overlay-Glied [7] hasht deren Quelltext*; Arbeit in `measurement/`, `profile_facade/`, `tests/` ⇒ **SHA-/golden-neutral by construction**.
- **KON58-05** — Korrektur einer Lead-Paraphrase: *„jeder Algorithmus bekommt eine neue Versionszeile"* hat **null Ledger-Treffer**; KON9-05 verlangt nur, dass jeder Algorithmus den Stempel **unterstützt** — **keine Literal-Bumps am Aktivierungstag, die 123 Literale bleiben**.

### A.5 — Der Riegel: Betriebsfolgen, die jeden künftigen Strang treffen

Der Kopf kennt nur „Lock 718 deckt 712/712" (KON61). Nicht im Kopf:

- **KON58-01 (🔴 BETRIEBSFOLGE)** — **jede** Änderung an einem der **122 Organ-Träger** erzwingt einen **X.Y.Z-Bump ODER einen bewussten Lock-Regen-Commit (`--write`)**; die **30 Forwarder/Prosa-Dateien verlangen IMMER den Regen-Commit**. *„Das trifft die W1-Stränge S-6/S-7 unmittelbar … Der Friktions-Aufwand je Strang ist ungeplant und wird beim ersten S-6-Paket GEMESSEN, nicht geschätzt."* — direkt relevant für den lebenden Platz **#15 S-6-Bündel**.
- **KON58-07 (G2-Heilung)** — **Exit-Code-Semantik**: `--check` endet bei **akzeptiertem Bump mit EXIT 3 „REGEN ERFORDERLICH"** (fail-closed unabhängig von der CI-Verdrahtung); der CI-Job fährt **zusätzlich `--write` + `git diff --exit-code`** auf die Lock-Datei. Exit 2 = Mindest-Nenner/Umgebung. Ein reiner Bump-Ok-Zweig **reicht nie**.
- **KON58-13 (🔴 LANDE-AUFLAGE, zweig-übergreifend)** — v3-Format + 718er-Register treffen **JEDEN parallelen Zweig**, der das Lock liest oder regeneriert: **nach dem Merge auf dem Zielzweig einmal `--check` + `--write` + `git diff` fahren.**
- **KON58-13** — **26 Alt-Home-Dateien fielen AUS dem Schnitt** (telemetry_axis 10 — inzwischen CEB-System-Achse · simd/isa 10 — Build-only Glied [6] · cacheline 3 · axis_centric_namespaces.hpp · queuing-Hülle 2), **als bewusster Schnitt-Entscheid**; kehrt telemetry/isa in die Komposition zurück, **nimmt der Schnitt sie automatisch wieder auf**.
- **KON58-13 (🔴 NEBENBEFUND, eigener Posten)** — **`-Wstringop-overflow` in libstdc++ `stl_algobase.h`** über die Inlining-Kette `axes/alloc/axis_06_allocator_exgen.hpp` in TU `test_v41_topic_traversal`; **Vorbestand**, erstmals von der gcc-Release-Zelle belichtet. Der Schnellfix (Pragma am gelockten Träger) ist **ausdrücklich VERWORFEN** (literal-loser Byte-Drift). **Offen, kein Anker im Kopf.**

### A.6 — Bau-Stände und Wachen ohne sichtbaren Nachfolger

- **KON58-08 — S-3 IST GEBAUT (ce `4a89aed5`)**, 8 Dateien, 1101+/12-: `flag_menge_ordnung.hpp` (constexpr Teilmenge über Bestands-Primitive, Element = **(token, eltern)-Paar** — *ein `vnni` unter `x256` ist NICHT dasselbe wie unter `x512`*), `kFlagVoraussetzungsKetten` (15 Zeilen, je mit Beleg-Zitat, **ungated Konjunktions-Term (d)**), `maschinen_deklarations_naht.hpp` + **DER EINE Aufruf** in `run_experiment_profile_facade`. **🔴 OFFEN und ausdrücklich deklariert: der KON55-Kombibau ist NICHT gefahren** („make: Terminated", ctest-Starts = NULL). **Landung/Abnahme von S-3 taucht in KON60–93 nirgends auf.**
- **KON59-02 / NE-10** — vor der S-3/S-7-**Aktivierung**: „beide Seiten gebaut UND inert" je Seite mit **zwei Zahlen** belegen; **`bvset_ist_teilmenge` hat 2 PRODUKTIONS-Treffer im `build_orchestrator`** ⇒ „inert" ist **teilwiderlegt**.
- **KON58-05 — S-7 (Sa)**: Vollbestands-Beweis über die **Registry-Typlisten** (Nenner gemessen, nicht gepinnt) + Semantik an **synthetischen Probe-Klassen** + Zulassungs-Brücke an der **bestehenden per-Binary-Naht**. Kein Nachfolger im Kopf.
- **KON59-02 / NE-16** — `test_t6_wachen_inventar.cpp` **kennt den S-14a-CI-Job nicht** (der Kombibau blieb trotzdem grün): **Inventar-Nenner bestimmen, VOR der nächsten neuen Wache**, sonst ist sie wieder unbewacht.
- **KON59-02 / NE-20** — **drei aktive `allow_failure: true`** gegen die Doktrin „allow_failure VERBOTEN" (06.07.): `ce .gitlab-ci.yml:257` arm64-smoke · `:898` relock-manual · `super .gitlab-ci.yml:2751` ergebnis:holen. **Urteil sollte der Stufe-2-Nachtrag tragen — im Kopf steht nichts.**
- **KON59 (Kopfzeile)** — Vollständigkeitsprüfung: **538 Erledigt-Behauptungen** (11.–13.08.) am Objekt geprüft — **311 halten voll (58 %), 190 teilweise, 19 hart gefallen, 18 gegenstandslos.** Der Kopf hat nur KON82 („Fortschrittsaudit 51/51, Verlustliste leer") — **anderer Gegenstand, anderer Nenner.**

### A.7 — Vier Bau-Posten OHNE Task-Nummer (KON58-11, BEFUND 2)

Wörtlich als solche verbucht; im Kopf ist nur (a) über KON91/#38a2 aufgehoben:

- **(b) WARMUP-PAAR-DURCHSETZUNG (KON47-04, Owner verbatim):** *„immer 3 mal folgendes passiert: Es wird einmal gemessen und verworfen, es wird einmal gemessen und mit warmem cache gespeichert. Das ist Pflicht für die Forschung, muss getestet sein, kann bei --debug auf kaltem Cache laufen also nur einmal. **SONST IMMER ZWEI MAL.**"* ⇒ 6 Läufe, 3 persistierte Werte je Zelle. **Der Legacy-Pfad `run_observable_perm` misst heute KALT** (perm_runner.hpp:207,213) — anpassen oder ausbuchen, plus Tests nach T-1…T-9. **Nirgends im Kopf.**
- **(c) n/a-ZÄHLER IM INHALTS-GATE (KON44-02):** eine Zeile `n_ops=n/a total_ns=n/a ns_per_op=n/a workload=n/a quality_flag=n/a (provisioned=1)` galt **zwei von drei Wachen als GRÜN**; nur `durchstich_wache frische` fing sie. *„OHNE dieses EINE Gate liefe eine n/a-Zeile bis in die Thesis-PDF."* **Nirgends im Kopf.**
- **(d) Preimage-Budget-Bruch** — siehe A.4.
- Dazu **zwei unverbuchte Diskrepanzen**: der Wellenplan (##58) nennt **28 `\InputIfFileExists`-Ziele, gemessen sind 13** (vor dem F5-Anhang-Gate zu klären) · die **Thesis ist ZWEIMAL als Submodul eingebunden** (`thesis/diplomarbeit` und `Code/external/20260931-overleaf-diplomarbeit`), **beide Pfade in super leer**.

### A.8 — Betrieb/Infra: offene Owner-Vorlagen und latente Brüche

- **KON58-04 / #10 MinIO** — die vier Ebene-B-Variablen **existieren** in 288; der **gültige Test ist ein CI-SMOKE** (`measure:smoke` mit `COMDARE_STORAGE_CACHE=true`, Beweiszeile *„Ebene B aktiv: mc-Alias=prodcache"*, Gegenköder = HART-ROT bei geleertem Secret) — **in einem RUHIGEN Fenster (Ein-Blech, er schreibt in MinIO)**. Trägt er nicht: **MinIO-seitig NEUE Keys** (mc admin = Infra-Territorium). **Task #10 fehlt im Kopf-Taskboard vollständig.**
- **KON58-04 / BEFUND 3 (🔴 UNGEBUCHT, OWNER-VORZULEGEN)** — `refs/backup/pre-secret-scrub-20260802` ist **auf BEIDEN origins weg** (ls-remote leer bei rc=0, Gegenprobe liefert Tips), lokal 0 Refs, **kein Bundle gefunden**. Weder Bundle-Überführung noch Löschungs-GO sind verbucht. Frage an den Owner: *„war das die geplante Vollziehung, und wo liegt das Bundle?"* — *(Möglicher Nachfolger im Kopf: V9 „rescue-Ref", KON76/89/90/93 „V9-Löschung vollzogen, Bundle zuerst". Die **Identität beider Objekte ist nirgends festgestellt** — vor dem Ausbuchen zu verifizieren.)*
- **KON58-04 (Nebenbefunde, je eigener Posten)** — **`COMDARE_NFS_DROP_TOKEN` fehlt in 288** ⇒ **Ebene C bleibt inert** · **`CE_SUBMODULE_TOKEN` fehlt bei existierendem USER** ⇒ *„die Planer-Emission bräche, sobald dieser Pfad fährt"* · die **„776" ist die Zahl der gitleaks-Treffer (RuleID `gitlab-rrt`)**, keine Runner-/Projekt-ID · die Instanz akzeptiert weiterhin Registration-Tokens (`allow_runner_registration_token=true`) — **Reset-Weg ist ein Owner-Entscheid** (je Projekt vs. instanzweit).
- **KON56-01 (🔴)** — `measure:smoke` ist rules-gated auf `COMDARE_DURCHSTICH=="true"` und **DISJUNKT zu `COMDARE_RUN_MEASURE`**; letzteres erzeugte zusätzlich **`measure:golden-320` (timeout 10 days)** und **belegte den `resource_group`-Slot tagelang**. V3-Falle „Gesamtstatus grün ohne den entscheidenden Job" nur per **Jobliste** gefangen. **Betriebsfalle, nicht im Kopf.**
- **KON49-03 (NEBENBEFUND)** — im geteilten ce-Store liegen **13 ungelandete Branches vom 02.–10.08.**, darunter drei vom 10.08. (`bau/p2-warnstufe-aufteilen`, `bau/p6-lizenz-umsetzung`, `bau/p3-ci-clang-pflicht`; super-Seiten gelandet, ce-Seiten nie). **Eigener Aufarbeitungs-Posten — vor dem main-FF (#19) zu klären: landen oder begründet ausbuchen.** Der Kopf führt #19, **nicht diese Vorbedingung**.
- **KON49-04 (🔴 NEUE WORKFLOW-AUFLAGE)** — **BRANCH-PFLICHT**: Bau-Agenten committen auf **benanntem Branch** (nie detached HEAD), und der **Verify misst Branch + Store-Pfad SELBST** und weist ihn aus.
- **KON46-01 (Werkzeug-Falle)** — `git branch -r --contains` **in einem Worktree-Submodul misst den KLON-Zeitpunkt, nicht den Remote-Stand**; vor jeder Ref-Aussage `fetch --prune` **im Mess-Baum**. (Hat bereits eine falsche Ledger-Auflage erzeugt.)
- **KON46-03 (Lehre)** — *„ein blind extrahierter Wert ist eine BEHAUPTUNG"* — vor dem Einsetzen gegen die API verifizieren (200-Probe), nie nur strukturell.

### A.9 — Struktur/Zielform (KON43, KON47-01) — im Kopf nicht sichtbar

- **KON43-01 (Owner verbatim)** — *„erst den Planer aufbauen, dann die CEB, dann die Tier-Binaries und dann Hybrid. **In der Reihenfolge und nicht anders.**"* + *„4 unter-Projekte die in Träger-stufenform aufeinander aufbauen"* + Monolith-Split beim Aufräumen. Stufe N+1 hängt nur von Stufe N ab.
- **KON43-02 — ZIELFORM-PFLICHT AB SOFORT**: **S-8 und S-9 bauen in die Vier-Unterprojekt-Zielform, nicht in den Monolithen**; die Ziel-Ordnerstruktur wird **VOR dem S-8-Bau** geschnitten.
- **KON47-01 (Antwort am Objekt)** — der Planer existiert als eigene Binary, **aber NICHT in der Zielform**: die Planer-Substanz lebt in `libs/cache_engine/profile_facade/planner/` **im Monolithen**. **„Das Planer-Unterprojekt ist der erste Schnitt des Monolith-Splits (Task #29a)"** — **#29a fehlt im Kopf-Taskboard**, ebenso #88 (Konsolidierungs-Architektur).

### A.10 — Steuerung/Defaults/Hybrid-XML (KON42) — im Kopf nicht sichtbar

- **KON42-01(2) DEFAULT-DOKTRIN (Owner verbatim)** — *„all diese Variablen standardmäßig hart in den Planer als default einkompiliert werden und durch jede vorhandene Eingabe in die XML überschrieben"* ⇒ **kein Pflicht-Attribut in der XML für Deckel-Werte**; Bau-Auflage für S-8 (`constexpr`-Defaults + XML-Override je Attribut).
- **KON42-01(4) HYBRID ZWEIWEGIG XML-STEUERBAR** — Weg (i): **Belegung** des Hybrid per XML als Durchstich manuell statisch wählbar; Weg (ii): **Synthese-Funktionen und Wirkbereiche** einzelner Tier-Binaries manuell per XML setzbar ⇒ der `<hybrid_tier>`-Parser (HY-A3) trägt **beide** Wege. **Kein HY-A-Posten im Kopf-Taskboard.**
- **KON42-01(1)/KON58-02** — die 32 ist **Programm-Deckel** (`kHybridNodeObergrenzeDefault = 32`), *„der Wert ist willkürlich und wird später in **W7** angepasst"* ⇒ **W7-Posten „Dock-Deckel-Anpassung"**. Der Kopf trägt die dritte 32er-Rüge (KON71), **aber nicht den W7-Anpassungsposten**.
- **KON39** — **W7-BILANZ: 23 Posten (9 Behälter + 14 Zähler)**. Der Kopf kennt **kein W7** überhaupt.

### A.11 — Mess-Architektur-Festlegungen aus KON37, die der Kopf nicht führt

- **KON37-01 (🔴 VERERBUNGSREGEL, Owner verbatim)** — *„Die CEB ruft nur die Messfühler in der Tier-Binary und Hybrid auf, die sie selbst gebaut hat bzw. baut höhere Träger-Stufen nur nach ihren eigenen Messeigenschaften. Freigabe also auf Planer, Durchführung im Vertrag zwischen CEB und Tier/Hybrid."* ⇒ **keine CEB-Wallclock ⇒ keine Fläche-3-Wallclock-Einrichtung in ihren Tier-Binaries.** Für B3: der „Wallclock-Umzug" ist **kein physischer Umzug**, sondern der Umzug der **Schalter-Hoheit** (`abi_adapter.hpp:476-491` fällt).
- **KON37-03 (🔴 ANORDNUNGS-FREIGABE, Owner verbatim)** — *„die Reihenfolge muss in einer beliebigen Anordnung statisch in der Mess-Achse freigegeben werden, damit die Zeiger und Zustände für an/aus für jede Stufe klar definiert ist … jede Stufe also ihre ganz spezifischen Wallclock/Macro/Micro compile time Einrichtungen bzw. **ein subset der 3** … Die statische Festlegung ‚Wie viel' ist technisch nicht umsetzbar ohne Planer Simulation."* ⇒ B4: System B's geordnete Typliste bekommt **genau diese Zielrolle** (Adressierungsstruktur), **nicht** `anzahl==6`-Permutation.
- **KON37-02 (B1, Owner verbatim)** — *„Am besten direkt neu nach der geänderten Architektur. Das alte archivieren."* + **KORRELATIONS-PFLICHT**: Freigabe und Ausführung korrelieren über die **Permutation einer freigegebenen Konfiguration per compile time der höheren Träger-Stufe**. XML-Element `<measurement_tooling>` wird um die **Stufen-Dimension tier/hybrid/ceb** erweitert.
- **KON37-06 (Owner verbatim)** — *„ein build oder eine Messung dürfen **je 5 Mal** scheitern bis wir aufgeben"* + 3 Wiederholungen **je Parameter und Binary, alle 3 EINZELN persistiert**. Der Kopf führt „#13 T-15b", **nicht die 5/5-Klammer über BEIDE Vorgänge**.
- **KON40-02** — System B = **17 Code-Dateien + 1 README**; **B4-Umfang: 9 Kern-Dateien Umbau, 8 Ripple**. Nebenbefund: das Auswahl-Subsystem hat **17** Referenz-Dateien (KON29-05 zählte 18).

### A.12 — Arbeitsweise v3.6–v3.9 (KON58-09) — nur teilweise im Kopf

- **v3.6 / A1 + A1.1 (Owner: *„du bist gerade nur Opus 5 und ERKENNST KEINE FABLE 5 PROBLEME"*)** — Review-Analyse **zweistufig**: **Opus 5 max ERHEBT** (alle Pfade, ausgefüllte Wahrheitstafel, urteilt NICHT), **Fable 5 max BEWERTET adversarisch** — **beide Pflicht, ZUSÄTZLICH zum Codex-Lens**. Begründung: *„Ein Lead, der seine eigene Review-Analyse führt, ist sein eigener Zweit-Lens; das ist keiner."*
- **v3.7 / A2.1(a2) (Owner: *„prod1 verträgt nur 3 builds wegen Plattenspeicherplatz parallel"*)** — **harte Obergrenze: MAXIMAL DREI GLEICHZEITIGE VOLLBAUTEN**, unabhängig vom df-Wert im Startmoment; der KON55-Kombibau zählt als **EIN** Slot. **Siehe (B.2).**
- **v3.8 / A2.1a WELLEN-FORM** — N Worktrees parallel → lokale Vollbauten (≤3) → **Merges seriell und lokal, OHNE Push und OHNE Pipeline dazwischen** → **EIN Push**, wenn alle gelandet sind → **EINE CI**. Bedingung: jedes Paket ist **vor** seinem Merge lokal vollständig grün; jedes Paket landet als eigener `--no-ff`-Merge.
- **KON58-06(2) / Codex-Rezept** — Review-Gegenstände in ein **WEGWERF-VERZEICHNIS** kopieren, Codex dort mit vollem Zugriff; **Lens klein schneiden (ein Gegenstand, drei Fragen)** + **von Anfang an ein PARALLEL laufender zweiter Lens anderer Herkunft**.
- **KON58-11 / BEFUND 1** — **die ARBEITSWEISE liegt an ZWEI Orten mit VERSCHIEDENEM Inhalt**: `super docs/` trägt **53 Zeilen (ein ZEIGER seit 10.08.)**, der Umbrella **988 (die geltende Fassung)**. *„Wer der Memory-Pfadangabe folgt und dort aufhört, liest einen Umzugshinweis und hält ihn für die Doktrin."*
- **KON58-12** — der Ledger kannte den 13.08. **nicht** (Einträge von heute = NULL). Lehre: **der Nachtrag gehört an die LANDUNG gebunden, nicht an den Vorsatz** (`scripts/ledger_nachtrag.sh`).
- **KON58-08 (Lehre)** — *„ein Bau, den niemand zu Ende sieht, hat nicht stattgefunden; Bauten laufen im Vordergrund oder abgekoppelt (setsid/nohup), nie an der Lebensdauer des Agenten hängend."*
- **KON58-10 (Mechanik)** — der **eine Hotspot `tests/unit/CMakeLists.txt`** wird von **sieben der elf Posten** angefasst; Auflösung: **jeder Strang hängt seinen Block ans DATEIENDE mit Strang-Marker**. Und: `test_s5_*`/`test_s7_*` sind im Bestand **mit anderem Gegenstand belegt** (18 bzw. 10 Dateien) ⇒ **neue Tests bekommen THEMATISCHE Namen statt Posten-Nummern** (V12-Klasse eine Ebene tiefer).

---

## (B) WIDERSPRÜCHE OHNE TRAGENDEN MARKER

**B.1 — Die „6 GB": Warnschwelle auf Messdaten vs. feste statische Arena**

| Quelle | Wortlaut |
|---|---|
| Segment **KON51-02** | *„🔴 SCHWELLE: **WARNUNG** an den Planer, wenn die CEB **> 6 GB RAM Messdaten hält**"* |
| Segment **KON52-01** | *„V-F2 DEFAULTS: rein informativ · WARN-Grenze und OOB-Grenze **SEPARAT in der XML einstellbar** · Standard = NUR delayed Warnung (Schwelle 6 GB) und **KEINE Begrenzung** (OOB aus)"* |
| Kopf **KON93** | *„C6 = **ARENA 6GB FEST, STATISCH**, Planer-Reservierung zu Experiment-Beginn änderbar (10-Wochen-Explore läuft)"* |

Einmal ist die 6 GB eine **XML-überschreibbare Warnschwelle über akkumulierte Messdaten ohne Deckel**, einmal eine **feste statische Arena-Größe, nur über die Planer-Reservierung änderbar**. Der Kopf nennt für KON92 „6 Überholt-Marker" in der Arena-Ketten-Karte — **welcher davon (falls einer) diesen Fall trägt, steht nirgends.** Auflösung nötig, sonst baut S-13 die XSD-Attribute (`ram_warn_grenze` / `ram_oob_grenze`) gegen ein anderes Objekt als die Arena.

**B.2 — Parallelitäts-Deckel: „maximal drei" gegen „maximal parallel"**

| Quelle | Wortlaut |
|---|---|
| Segment **KON58-09 / v3.7** | *„HARTE OBERGRENZE prod1 — **MAXIMAL DREI GLEICHZEITIGE VOLLBAUTEN** (Owner: ‚prod1 verträgt nur 3 builds wegen Plattenspeicherplatz parallel'). **Gilt UNABHÄNGIG vom df-Wert im Startmoment**"* |
| Kopf **KON73** | *„**VOLLES GO maximal parallel**"* (+ F7 Drei-Bereiche-Concurrency: CI-normal 3/2 je 4 Kerne, heavy 16, ce floor((T-4)/4)×4) |

KON73-F7 regelt **CI-Job-Concurrency**, v3.7 regelt **lokale Vollbauten auf prod1** — die beiden Gegenstände sind verschieden, aber „VOLLES GO maximal parallel" trägt **keinen Vorbehalt auf den lokalen 3er-Deckel**. Ohne Marker liest sich der Kopf als Aufhebung. (KON49-04 belegt die Kosten: 2,9 G freier Platte = **Ursache dreier stummer Agenten-Tode**.)

**B.3 — Lastsequenz: „gehört IN die framework-Mess-Achse" vs. „ist eine EIGENE Mess-Achse"**

| Quelle | Wortlaut |
|---|---|
| Segment **KON37-05** (Owner verbatim) | *„die **Lastsequenz** in die **framework Mess-Achse gehört** und **nicht in derselben Klasse** liegt wie ein Gattungsaufruf/Genusaufruf/Achsen-Interface-Aufruf, **weil sie selbst auf einem Achsen-Interface liegt**"* — Verbuchung: *„wird dort **einsortiert**, nicht als dritte ‚Ebene'"* |
| Kopf **KON64/65** | *„**Lastsequenz = EIGENE Mess-Achse** (10-Wochen-Explore vor Design)"* |

„In eine Achse einsortiert" ≠ „ist eine eigene Achse" — das ist ein Unterschied im **Achsen-Nenner** und damit im Permutationsraum. KON65 ist neuer und gewinnt nach Vorrangregel, **ein Marker, der KON37-05 als überholt ausweist, existiert nicht.**

**B.4 — Projektstruktur: vier Träger-Unterprojekte vs. Repo-Rollen**

| Quelle | Wortlaut |
|---|---|
| Segment **KON43-01(2)** (Owner verbatim) | *„Im Projekt der cache engine brauchen wir also **4 unter-Projekte die in Träger-stufenform aufeinander aufbauen**"* + **Zielform-Pflicht ab sofort für S-8/S-9** |
| Kopf **KON73 / F6** | *„Repo-Rollen (ce=Framework, super=Einstieg, XSD-Hoheit→ce #74)"* · Task **#74 Repo-Rollen (W2/W)** |

Formal disjunkt (Unterprojekte **innerhalb** ce), aber der Kopf beschreibt die Zielstruktur **ohne** die Vier-Träger-Gliederung und ohne die Zielform-Pflicht — und **#18 S-13-Bündel / #3 S-12 sind lebende Bau-Plätze**, die nach KON43-02 in die Zielform bauen müssten. Ohne Marker ist unklar, ob KON43 fortgilt.

**B.5 — Der Rest von KON58-10: sechs von elf Wellen-Posten ohne sichtbaren Nachfolger**

Der Kopf trägt aus dem disjunkten Wellen-Schnitt nur **P11 (S-14a, KON78 „bereits in dev")**, **P6 (B2, KON70/74)** und **P4 (Homes, F5/KON73)**. **P1 (S-3), P2 (S-7), P3 (S-5), P5 (Layout-7), P7 (S-4), P10 (MinIO)** haben **keinen** Anker in KON60–93 — obwohl KON58-10 vier **nicht verhandelbare** Fesseln benennt (**P11 vor P4 · P6 vor P4 · P1 vor P2 · P3 vor P5**) und die Lande-Ordnung 1–9 festschreibt. Ohne Auflösung ist unklar, ob die Fesseln noch gelten oder die Posten ausgebucht sind.

---

## (C) ÜBERHOLT-BESTAND (nur Zählung + Kurzliste)

**Im Segment selbst als überholt/gefallen markiert: 29 Stellen.**

KON59-01 („nur aus Tests" → „vorhanden, aber inert") · KON58-01 Binnenaufteilung 13/16 → 12/18 · KON58-01 eigene Planungszahl 123 → **122** · KON58-02 Q6 8 → 32 (vier Doku-Stellen, je NACHZUG-Vermerk) · KON58-03 zwei prod1-Alt-Zitate „32 Threads/24 Kerne" + §69.6 HEAVY-Teil · KON58-06(3) „9 Einträge" = wc-l-Artefakt (KON12-02-Restposten erledigt) · KON58-10 Ortsangabe `set_active_machine_declaration` (profile_facade → `simd_build_gate.hpp:234`) · KON58-13 Lock v2 → v3 + 158 → **718** (v1/v2-Locks werden hart abgewiesen) · KON57-02 #84-Vorbestand (Padding-Bytes) erklärt+geheilt · KON55-02 lokaler gcc-only-Kombibau → 2×2-Matrix · KON46-01 KON44-Sequenz-Auflage = Stale-Refs-Artefakt · KON44-01 F1-Blocker (Emitter vs. Gate) → KON47-01(a) · KON44-03 289-Variablen → KON46-03 rotiert · KON41-03 KON28-03-„Beobachtung" + KON34-03-Klammer *„VÖLLIG FALSCH"* · KON41-02 OF-1 17-vs-18 (dieselbe Menge) · KON41-01 F-D-Spannung → „BEIDES" · KON39 KON30-04/R-4 gestrichen + 11 Alt-Fragen entfallen · KON37-03 eigene Empfehlung „nur an/aus" gedreht · KON37-08 eigene Empfehlung „deprecaten bis W7" abgelehnt · KON37-01 Wallclock-SOLL-Konflikt aufgelöst (Merge) · KON36-01 Ein-Ort-Prämisse (3! CEB-Versionen) überholt durch KON25-03 + zwei falsche Zitatanker + „32 ersetzt 12"-These widerlegt · KON36-02 eine Fehldarstellung (Hybrid „eigenständig") korrigiert + drei Berichts-Behauptungen verworfen · KON45-01(2) Variante (b) verworfen · KON47-04 KON45-03-Zell-Warmup-Vorlage ersetzt · KON47-03 „Provenienz-nur" abgelehnt · KON52 verengt meine V-F1-Empfehlung (3er-OOB-Klasse → **eine**) · KON54 hebt KON53-Ableitung 2 zur Festlegung · KON58-09 v3.6–v3.9 lösen v3.5 ab.

**Vom Kopf (KON60–93) erkennbar überholt: 8 weitere.**

KON56-01 `ns_per_op=644.020` → **KON61 NE-01: 1199.047, „644.020 NIE zitieren"** · ctest 485/486 → **KON61 Kombibau 4×491** · KON58-05/-11(a) „C-3a-Tripwire bleibt gesperrt" → **KON91 C-3a=JA (#38a2 im W1-Bump-Bündel)** · KON47-03 Festplatten-IO-Framing → **KON80 V10 / ORG-19 (XML-opt-in, Genus-Interface +store()/load(), „18 + 1 optionale Meta-Meta")** · KON58-13 S-14a-Landefrage → **KON78 (8cc564d5 bereits in dev)** · KON49-02 manuelle Löschregel → **KON82 Worktree-Remove-Wache als Werkzeug** · KON41-03/KON42-01 32er → **KON71 dritte Rüge (dynamisch >32, nur S-19 rechnet)** · KON58-01 „SYSTEM/MESS-Homes existieren nicht" → **KON73 F5 DREI Homes (mess/system/ORGAN_AXES)**.

---

## (D) TRAGENDE ARCHITEKTUR-KERNE DES SEGMENTS

1. **Die Träger-Kette ist eine Baureihenfolge, kein Bild.** KON43-01: *„erst den Planer aufbauen, dann die CEB, dann die Tier-Binaries und dann Hybrid. In der Reihenfolge und nicht anders."* Vier Unter-Projekte in Träger-Stufenform; Stufe N+1 hängt nur von N ab. Zielform-Pflicht ab sofort (KON43-02).
2. **Jede Naht hat dieselbe Schablone: Fläche 1 = Control, Fläche 2 = Stempel** (KON50-01). Planer→CEB: erkannte Anforderungen hinab, **Status + Log-„warum" + Ergebnis-Trace** hinauf — **niemals Mess-Rohdaten** (KON50-02).
3. **Steuer-Naht spricht XML (gefiltert), Mess-Naht spricht sparse binary** (KON51-01). Der Planer gibt nur *„gefilterte Programmteile aus der Planer Syntax-geprüften Eingangs-XML"* heraus; **jede freigebende Stufe lädt aus ihrer Binary heraus die Module der nächsten**.
4. **Latenz-Reinheit schlägt Betriebs-Sichtbarkeit.** KON52-01, Owner: *„Nur das Fertig-Signal darf die Prioritäten überspringen, weil Zwischen-Signale Latenzen erzeugen, welche Messwerte verfälschen."* Genau **eine** OOB-Nachricht; alles andere queued bis zum Break.
5. **Die Barriere zwischen Teil-Experimenten ist die einzige Steuer-Gelegenheit** (KON53-01): voller beidseitiger Flush+Sync, Drain-Quittung als Startbedingung, dann `--auto` **oder** manuelle Bestätigung **oder Verneinen** (KON54-01). Nur zwei Kommandos dürfen in die Stummphase: `{stop_ram_oob, stop_user_kill}`. *„Ja das Lager heilt das."*
6. **Messen heißt paarweise messen.** KON47-04, Owner: *„Es wird einmal gemessen und verworfen, es wird einmal gemessen und mit warmem cache gespeichert … SONST IMMER ZWEI MAL."* 3 Wiederholungen ⇒ 6 Läufe, 3 **einzeln** persistierte Werte; `--debug` = einmal, kalt. Retry: **je 5** für Build **und** Messung (KON37-06).
7. **Die Mess-Achse trägt eine statische Anordnungs-Freigabe** (KON37-03, Owner): beliebige Reihenfolge, statisch freigegeben, *„damit die Zeiger und Zustände für an/aus für jede Stufe klar definiert ist"*; jede Stufe trägt **ein Subset von {Wallclock, Macro, Micro}**; „wie viel" ist ohne Planer-Simulation (S-19) nicht bestimmbar.
8. **Die Mess-Bestückung der Kinder folgt der CEB** (KON37-01, Owner): *„baut höhere Träger-Stufen nur nach ihren eigenen Messeigenschaften"* — Freigabe am Planer, Entscheidung an der CEB, Durchführung im Vertrag CEB↔Tier/Hybrid.
9. **Der Compiler wird eine System-Achse belegen** (KON55-01, Owner): clang **und** gcc sind Basis-Pflicht, CI **und** lokal, *„weil Compiler Performance Unterschiede bringen"*; konkret die **5. System-Achse `gcc|clang`** mit Unterachsen opt/flags/commands (KON56-03).
10. **Der Hybrid erbt Tier und fügt genau eine Zeile ein** (KON41-04, Owner): vorletzte Zeile = serialisierte compile-time-Map {Synthese-Key → Tier-Stempel} über alle belegten Prüfdocks, letzte Zeile = SHA, *„der Hybrid SHA wirkt auch über diese neue Zeile compile time"* ⇒ andere Bestückung = anderer SHA = neuer Lager-Datensatz. Als Map-Value gilt der **Tier-SHA**, nicht der Voll-Stempel (KON47-02, Budget).
11. **Deckel-Werte leben im Planer, die XML ist der Override-Kanal** (KON42-01, Owner): *„hart in den Planer als default einkompiliert … durch jede vorhandene Eingabe in die XML überschrieben"*. Die 32 der Prüfdocks ist ein **Programm-Deckel**, willkürlich, in W7 anzupassen — und **NICHT** die Mess-Permutation (KON41-03: *„Das sind zwei verschiedene Dinge. VÖLLIG FALSCH."*).
12. **Der Stempel ist der Cache- und Lager-Schlüssel — deshalb der Riegel.** KON58-13: die Wache maß den Substring `algo_version` und ließ **235 von 387 Dateien (60 %) unbewacht**, während sie „GRÜN" meldete. Geheilt über den **Overlay-Schnitt** (`kOverlaySourceSet`) als Grundgesamtheit: 718 Records, *„deckt 712 von 712 Overlay-Quellen"*. Fehlerklasse: **„Änderung ohne Bump ⇒ kein Neubau ⇒ schneller UND falsch."**
13. **Betriebsfolge des Riegels** (KON58-01/-07/-13): jede Änderung an den 122 Trägern erzwingt Bump **oder** Lock-Regen; akzeptierter Bump ohne Regen ⇒ **Exit 3 „REGEN ERFORDERLICH"**; nach jedem Merge auf dem Zielzweig einmal `--check` + `--write` + `git diff`.
14. **Golden-neutral baut man durch Ortswahl, nicht durch Vorsicht** (KON58-05): nichts unter `axes/`, `topics/`, `heuristik/` anfassen — Overlay-Glied [7] hasht deren Quelltext; Arbeit in `measurement/`, `profile_facade/`, `tests/`.
15. **Generalprobe ist der Dauerzustand, nicht ein Termin** (KON41-01, Owner): *„wir immer bis 3 Tage vor Abgabe Generalprobe laufen, dann die Builds und Messdaten manuell löschen, da ungenau und dann den finalen Lauf bis zur Abgabe durchfahren. Generalprobe wird formal durch das --debug Flag aktiviert."* Das Lager fährt Skip, sobald es voll ist — einmal gebaut+gemessen ⇒ verfügbar. **Kanal: hauptsächlich CI, lokal wird nachgezogen.**
16. **Und die Rechnung dazu ist offen** (KON41-01 + KON58-03): 41,4 h einlanig @24W → ~45,6 h @16W, gegen ein T-3-Fenster von 3 Tagen, aus dem der OV-4-Mess-Deckel erst noch **rückwärts kalibriert** werden muss — mit S-19-Zahlen, vor der GO-Vorlage ##51.