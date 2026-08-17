# ledger-gegenlese-kon1-59 (wf_750a0423-c46) -- 6 Results, ungekuerzt


==========================================================================================
## RESULT 1 (wf_750a0423-c46)
==========================================================================================

# LEDGER-GEGENLESE — SEGMENT KON59 → KON36 (Z. 2834–5258, 13.08./12.08.2026)

Gelesen: Z. 2834–5258 vollständig (5 Häppchen), Datei bei 29858 Zeilen — **keine Drift**, Segmentgrenzen exakt (Beginn `KON59`-Überschrift Z. 2834, Ende 
`KON36-02` Z. 5258).
Abgeglichen gegen `/home/comdare/.claude/jobs/5a19728e/tmp/kopf_referenz_kon60_93.md`.

---

## (A) LEBEND-ABER-IM-KOPF-UNSICHTBAR

### A.1 — Die KANAL-DOKTRIN (KON50–KON54): fünf Owner-Nachträge, **null** Spuren im Kopf

Das ist der größte zusammenhängende Blindfleck. KON60–93 kennt aus diesem Block nur die Arena-Kette (KON92/93) — die **Naht-, Sprach-, Stumm- und 
Steuersemantik fehlt komplett**.

- **KON50-01** — Planer↔CEB trägt **dieselbe Flächen-Schablone** wie CEB↔Tier: Fläche 1 = **Control-Interface, stream in / stream out** (hinab: 
erkannte Anforderungen; hinauf: Status erfolgreich/nicht + **Log-Message warum**), Fläche 2 = der Stempel. Owner: *„die CEB misst und die Daten Verarbeitet, 
schickt sie dem Planer nur die Ergebnisse ihrer arbeit als Trace für die Kommandozeile"* ⇒ **RÜCKWEG-GRENZE: keine Mess-Rohdaten zum Planer**.
- **KON50-02** — der §38-Rückkanal trägt **DREI** Nachrichtenklassen, nicht eine: (i) Fortschritts-Deltas · (ii) **Status je Anforderung + Fehler-LOG** 
(neu, owner-gesetzt; Konsumenten T-15b/failed-Doktrin) · (iii) Ergebnis-Trace.
- **KON51-01** — Planer→CEB spricht **AUCH XML, aber GEFILTERT** (nur die Programmteile, die die CEB wirklich braucht, aus der syntax-geprüften 
Eingangs-XML). Fläche 3 am Prüfdock: **ausgehend Signalfunktion, eingehend Stream der Messwerte nach dem Flush**; Format **KEIN XML — SPARSE BINARY**. 
*„Die Serialisierung der Werte von measurement ist kein XML sondern sparse binary."*
- **KON51-02** — Arenen: Tier/Hybrid je **eigene, bei Anforderung eingebaute** Mess-Arena für checkpoint-measure; Flush **nur zu definierten Hol-Punkten** 
in die CEB-RAM-Arena; **Rückschrieb gesammelt am Experiment-Ende**; Warnung an den Planer bei **>6 GB**.
- **KON51-03** — **Stummschaltung**: während der Messung Planer↔CEB stumm; beidseitige Aggregation bis zum **Break des EINZELNEN** Experiments; 
Fertig-Signal überspringt alle Prioritäten ⇒ **es gibt Prioritätsklassen im Kanal**.
- **KON52-01** — **die OOB-Klasse ist GENAU EINE Nachricht: das Fertig-Signal.** Owner-Begründung, tragend für jeden Kanal-Bau: *„Nur das Fertig-Signal 
darf die Prioritäten überspringen, weil Zwischen-Signale Latenzen erzeugen, welche Messwerte verfälschen."* Harter RAM-OOB = **XML-Opt-in, kein Default**; 
Defaults: `ram_warn_grenze` 6 GB, `ram_oob_grenze` **aus**, beide separat XML-einstellbar (S-13/B1-XSD-Posten).
- **KON53-01** — das Inter-Experiment-Fenster ist eine **volle bidirektionale Sync-Barriere**: Startbedingung = alle Nachrichten **beider** Seiten 
vollständig ausgetauscht (Drain-Quittung). Fortgangs-Wahl: **`--auto`** oder **manuelle Bestätigung**; **die CI-Kette fährt `--auto`** (KON53-02, 
deklarierte Ableitung).
- **KON54-01/-02** — der Nutzer kann das nächste Teil-Experiment **VERNEINEN**; **`kill`-OOB von der CLI** → Planer → CEB, **halb sauberer Stopp**; 
*„Ja das Lager heilt das."* Das Planer→CEB-Kommando-Vokabular der Stummphase ist damit abgeschlossen: **{stop_ram_oob, stop_user_kill}**, sonst leer.
- **KON54-03** — halb sauberer Stopp schreibt **NICHTS Unvollständiges ins Lager** (Teilstände wären ein falscher Skip beim Wiederanlauf).

> Bau-Wirkung dieses Blocks: **S-8 (`--auto` neben `--debug`, Bestätigungs-Prompt ja/NEIN, kill-Kommando) · S-10 (Barriere-Protokoll + Prioritäten + OOB) · 
S-9/S-12 emittieren gegen diese Naht (Prozess+Streams statt YAML) · #20 Fläche-3-Vereinigung · S-13 bleibt GETRENNT (Export/Lager = Daten-Weg, Trace = nur 
Sicht).** Im Kopf steht als lebender Platz nur „#20 Fläche-3" und „#18 S-13-Bündel" — **ohne diese Semantik**.

### A.2 — Compiler als künftige System-Achse (KON55) — im Kopf nicht vorhanden

- **KON55-01** — Owner verbatim: *„der build auf allen Diplomarbeit Projekten auf der CI und lokal generell zuerst mit clang und auch mit gcc Pflicht ist 
… Compiler Performance Unterschiede bringen, weshalb sie eine System-Achse belegen werden … Nur clang reicht nicht, weil wir sonst spätestens im CEB 
Problemen bek[o]mmen."* {clang, gcc} = **Basis-Belegung einer künftigen System-Achse**; S-9/S-11 permutieren künftig **über die Compiler-Belegung**, die 
Versionen wandern als Achsen-Werte in Stempel/Preimage (System-Realm).
- **KON56-03** — das **Compiler-Achsen-Ruling 17.07.** ist konkret: **5. System-Achse `gcc|clang`, Unterachsen opt/flags/commands, Default `Ofast`**. Der 
Kopf nennt (KON72) nur „doppelte HW+SW-Versionierung" — **die Achsen-Slot-Belegung selbst fehlt.**

### A.3 — Termin-/Kapazitätsrechnung: die Zahlen, die T-3 und den Bau-Trigger tragen

- **KON41-01** — Owner-Auftrag „analysiere das Problem eigenständig", erste Rechnung: Neubau **128 × 19,4 min ≈ 41,4 h einlanig**; *„🔴 DER 
OV-4-MESS-DECKEL WIRD VOM T-3-FENSTER HER KALIBRIERT"* — Bau + 1-Thread-Messung müssen in **≤2,5 Maschinentagen zweilanig** tragen. **NEUER 
Strecken-Posten: „OV-4-Deckel = f(T-3-Fenster)" — in W2 mit den S-19-Zahlen rechnen, VOR der GO-Vorlage ##51.** Der Kopf führt „#7 S-19 MEILENSTEIN Sa 
22.–Mo 24.08." — **den daran hängenden Deckel-Posten nicht.**
- **KON58-03 (OD-7)** — N-3/N-4 neu gerechnet: zweilanig prod1 @16W ~22,8 h (ANNAHME) gegen prod2 @24W **GEMESSEN 34,4 h** ⇒ **der Engpass bleibt Intel**, 
die 24→16-Umstufung ändert die zweilanige Wanduhr **nicht**. **Einlanig aber: 41,4 h @24W → ~45,6 h @16W** — die T-3-Rechnung aus KON41-01 wird dadurch 
**schlechter**, ohne dass irgendwo nachgezogen wurde.
- **KON58-03** — **PFLICHT-NACHKALIBRIERUNG** beim ersten realen 4096er-Batch @16W: **es existiert KEIN amd-16W-Lauf in den Traces** (nur @24W und @32W).
- **KON58-03** — die HEAVY-Schaltung ist **SIGNAL-GATED** (Infra-Zusage 02.08.); das Handout ist **kein** heavy-Signal, sondern nur die Änderung des 
Deckel-Werts **für das nächste angeforderte Fenster (Bau-Trigger 26.08.)**. ⇒ Für den 26.08. muss jemand **das Signal senden** — nirgends im Kopf.
- **KON36-02/J** — Kapazitäts-Fakt „20,7/34,4 h" und **„8 von 9 thesis_profiles xlsx-blind (Kampagnen-Blocker)"** (KON36-02/H) — der Kopf baut in 
KON87–89 das Sheet-/CSV-System, kennt diesen Blocker aber nicht.

### A.4 — Identität/Stempel: ein preimage-brechender Bump, der VOR dem F2-Freeze liegen muss

- **KON41-04 (Owner verbatim)** — der Hybrid *„hat also noch eine Zeile mehr als Tier-Binary"*: **vorletzte Zeile = serialisierte compile-time-Map 
{Synthese-Funktions-String-Key → Tier-Binary-am-Prüfdock-Stempel}**, konkateniert über alle belegten Prüfdocks; **letzte Zeile = SHA, der compile time 
AUCH über diese neue Zeile wirkt**. *„Hybrid erbt also das Stempelverhalten von Tier-Binary und fügt die besagte Zeile an der Stelle ein."*
- **KON45-01** — die Bau-Konsequenzen: **10. Glied für ALLE Binaries (Tier trägt ""), Format-Bump 4→5, GliedCount 9→10**; POD `komposit_line/len` 
**append-only, Layout 6→7**; ausdrücklich *„Format+Layout-Bump GEBÜNDELT VOR F2/26.08."* und *„mit dem bereits geplanten WE-Layout-Bump in EINEN Bump 
falten (KON5-04: ein Bruch statt zwei)"*. **Der Kopf setzt den F2-Identitäts-Freeze auf Fr 21.08. und erwähnt weder Format-Bump 4→5 noch Layout 6→7.**
- **KON45-01(5)** / **KON58-11(d)** — **PREIMAGE-BUDGET-BRUCH**: 32 belegte Docks × (Key+128hex+Trenner) ≈ **>4,5 KB sprengen 
`kAnatomyFingerprintPreimageMax=4096`** (anatomy_fingerprint.hpp:68, Wache :478) ⇒ Konstanten heben **MIT Budget-Beleg**. Trägt **keine Task-Nummer**.
- **KON45-01(6)** — die Synthese-Keys **existieren nicht**; `strategie_name()`-Literale („Reroute<View>") **verletzen den Glied-Zeichenvorrat** ⇒ 
**eigene Key-Grammatik nötig**, bis HY-A2 adressbasiert ist.
- **KON47-02 (Owner verbatim)** — *„wir verwenden für jedes Tier-Binary nur dessen SHA statt des gesamten Stempels"* + **RT-Cache**: beim Hybrid-Init 
werden die **vollen** Tier-Stempel an den Prüfdocks gecacht und sind **von der CEB über Fläche 2 zur Laufzeit abfragbar**. Invariante **RT-Menge ⊆ 
CT-Map**.
- **KON58-05** — die **EISERNE REGEL** golden-neutralen Bauens: *keine Datei unter `axes/`, `topics/` oder `heuristik/` anfassen — Overlay-Glied [7] hasht 
deren Quelltext*; Arbeit in `measurement/`, `profile_facade/`, `tests/` ⇒ **SHA-/golden-neutral by construction**.
- **KON58-05** — Korrektur einer Lead-Paraphrase: *„jeder Algorithmus bekommt eine neue Versionszeile"* hat **null Ledger-Treffer**; KON9-05 verlangt nur, 
dass jeder Algorithmus den Stempel **unterstützt** — **keine Literal-Bumps am Aktivierungstag, die 123 Literale bleiben**.

### A.5 — Der Riegel: Betriebsfolgen, die jeden künftigen Strang treffen

Der Kopf kennt nur „Lock 718 deckt 712/712" (KON61). Nicht im Kopf:

- **KON58-01 (🔴 BETRIEBSFOLGE)** — **jede** Änderung an einem der **122 Organ-Träger** erzwingt einen **X.Y.Z-Bump ODER einen bewussten 
Lock-Regen-Commit (`--write`)**; die **30 Forwarder/Prosa-Dateien verlangen IMMER den Regen-Commit**. *„Das trifft die W1-Stränge S-6/S-7 unmittelbar … 
Der Friktions-Aufwand je Strang ist ungeplant und wird beim ersten S-6-Paket GEMESSEN, nicht geschätzt."* — direkt relevant für den lebenden Platz **#15 
S-6-Bündel**.
- **KON58-07 (G2-Heilung)** — **Exit-Code-Semantik**: `--check` endet bei **akzeptiertem Bump mit EXIT 3 „REGEN ERFORDERLICH"** (fail-closed unabhängig 
von der CI-Verdrahtung); der CI-Job fährt **zusätzlich `--write` + `git diff --exit-code`** auf die Lock-Datei. Exit 2 = Mindest-Nenner/Umgebung. Ein reiner 
Bump-Ok-Zweig **reicht nie**.
- **KON58-13 (🔴 LANDE-AUFLAGE, zweig-übergreifend)** — v3-Format + 718er-Register treffen **JEDEN parallelen Zweig**, der das Lock liest oder 
regeneriert: **nach dem Merge auf dem Zielzweig einmal `--check` + `--write` + `git diff` fahren.**
- **KON58-13** — **26 Alt-Home-Dateien fielen AUS dem Schnitt** (telemetry_axis 10 — inzwischen CEB-System-Achse · simd/isa 10 — Build-only Glied [6] · 
cacheline 3 · axis_centric_namespaces.hpp · queuing-Hülle 2), **als bewusster Schnitt-Entscheid**; kehrt telemetry/isa in die Komposition zurück, **nimmt 
der Schnitt sie automatisch wieder auf**.
- **KON58-13 (🔴 NEBENBEFUND, eigener Posten)** — **`-Wstringop-overflow` in libstdc++ `stl_algobase.h`** über die Inlining-Kette 
`axes/alloc/axis_06_allocator_exgen.hpp` in TU `test_v41_topic_traversal`; **Vorbestand**, erstmals von der gcc-Release-Zelle belichtet. Der Schnellfix (Pragma 
am gelockten Träger) ist **ausdrücklich VERWORFEN** (literal-loser Byte-Drift). **Offen, kein Anker im Kopf.**

### A.6 — Bau-Stände und Wachen ohne sichtbaren Nachfolger

- **KON58-08 — S-3 IST GEBAUT (ce `4a89aed5`)**, 8 Dateien, 1101+/12-: `flag_menge_ordnung.hpp` (constexpr Teilmenge über Bestands-Primitive, Element = 
**(token, eltern)-Paar** — *ein `vnni` unter `x256` ist NICHT dasselbe wie unter `x512`*), `kFlagVoraussetzungsKetten` (15 Zeilen, je mit Beleg-Zitat, 
**ungated Konjunktions-Term (d)**), `maschinen_deklarations_naht.hpp` + **DER EINE Aufruf** in `run_experiment_profile_facade`. **🔴 OFFEN und ausdrücklich 
deklariert: der KON55-Kombibau ist NICHT gefahren** („make: Terminated", ctest-Starts = NULL). **Landung/Abnahme von S-3 taucht in KON60–93 nirgends auf.**
- **KON59-02 / NE-10** — vor der S-3/S-7-**Aktivierung**: „beide Seiten gebaut UND inert" je Seite mit **zwei Zahlen** belegen; **`bvset_ist_teilmenge` hat 
2 PRODUKTIONS-Treffer im `build_orchestrator`** ⇒ „inert" ist **teilwiderlegt**.
- **KON58-05 — S-7 (Sa)**: Vollbestands-Beweis über die **Registry-Typlisten** (Nenner gemessen, nicht gepinnt) + Semantik an **synthetischen 
Probe-Klassen** + Zulassungs-Brücke an der **bestehenden per-Binary-Naht**. Kein Nachfolger im Kopf.
- **KON59-02 / NE-16** — `test_t6_wachen_inventar.cpp` **kennt den S-14a-CI-Job nicht** (der Kombibau blieb trotzdem grün): **Inventar-Nenner bestimmen, VOR 
der nächsten neuen Wache**, sonst ist sie wieder unbewacht.
- **KON59-02 / NE-20** — **drei aktive `allow_failure: true`** gegen die Doktrin „allow_failure VERBOTEN" (06.07.): `ce .gitlab-ci.yml:257` arm64-smoke · 
`:898` relock-manual · `super .gitlab-ci.yml:2751` ergebnis:holen. **Urteil sollte der Stufe-2-Nachtrag tragen — im Kopf steht nichts.**
- **KON59 (Kopfzeile)** — Vollständigkeitsprüfung: **538 Erledigt-Behauptungen** (11.–13.08.) am Objekt geprüft — **311 halten voll (58 %), 190 
teilweise, 19 hart gefallen, 18 gegenstandslos.** Der Kopf hat nur KON82 („Fortschrittsaudit 51/51, Verlustliste leer") — **anderer Gegenstand, anderer 
Nenner.**

### A.7 — Vier Bau-Posten OHNE Task-Nummer (KON58-11, BEFUND 2)

Wörtlich als solche verbucht; im Kopf ist nur (a) über KON91/#38a2 aufgehoben:

- **(b) WARMUP-PAAR-DURCHSETZUNG (KON47-04, Owner verbatim):** *„immer 3 mal folgendes passiert: Es wird einmal gemessen und verworfen, es wird einmal 
gemessen und mit warmem cache gespeichert. Das ist Pflicht für die Forschung, muss getestet sein, kann bei --debug auf kaltem Cache laufen also nur einmal. 
**SONST IMMER ZWEI MAL.**"* ⇒ 6 Läufe, 3 persistierte Werte je Zelle. **Der Legacy-Pfad `run_observable_perm` misst heute KALT** (perm_runner.hpp:207,213) 
— anpassen oder ausbuchen, plus Tests nach T-1…T-9. **Nirgends im Kopf.**
- **(c) n/a-ZÄHLER IM INHALTS-GATE (KON44-02):** eine Zeile `n_ops=n/a total_ns=n/a ns_per_op=n/a workload=n/a quality_flag=n/a (provisioned=1)` galt **zwei 
von drei Wachen als GRÜN**; nur `durchstich_wache frische` fing sie. *„OHNE dieses EINE Gate liefe eine n/a-Zeile bis in die Thesis-PDF."* **Nirgends im 
Kopf.**
- **(d) Preimage-Budget-Bruch** — siehe A.4.
- Dazu **zwei unverbuchte Diskrepanzen**: der Wellenplan (##58) nennt **28 `\InputIfFileExists`-Ziele, gemessen sind 13** (vor dem F5-Anhang-Gate zu klären) 
· die **Thesis ist ZWEIMAL als Submodul eingebunden** (`thesis/diplomarbeit` und `Code/external/20260931-overleaf-diplomarbeit`), **beide Pfade in super 
leer**.

### A.8 — Betrieb/Infra: offene Owner-Vorlagen und latente Brüche

- **KON58-04 / #10 MinIO** — die vier Ebene-B-Variablen **existieren** in 288; der **gültige Test ist ein CI-SMOKE** (`measure:smoke` mit 
`COMDARE_STORAGE_CACHE=true`, Beweiszeile *„Ebene B aktiv: mc-Alias=prodcache"*, Gegenköder = HART-ROT bei geleertem Secret) — **in einem RUHIGEN Fenster 
(Ein-Blech, er schreibt in MinIO)**. Trägt er nicht: **MinIO-seitig NEUE Keys** (mc admin = Infra-Territorium). **Task #10 fehlt im Kopf-Taskboard 
vollständig.**
- **KON58-04 / BEFUND 3 (🔴 UNGEBUCHT, OWNER-VORZULEGEN)** — `refs/backup/pre-secret-scrub-20260802` ist **auf BEIDEN origins weg** (ls-remote leer bei 
rc=0, Gegenprobe liefert Tips), lokal 0 Refs, **kein Bundle gefunden**. Weder Bundle-Überführung noch Löschungs-GO sind verbucht. Frage an den Owner: 
*„war das die geplante Vollziehung, und wo liegt das Bundle?"* — *(Möglicher Nachfolger im Kopf: V9 „rescue-Ref", KON76/89/90/93 „V9-Löschung 
vollzogen, Bundle zuerst". Die **Identität beider Objekte ist nirgends festgestellt** — vor dem Ausbuchen zu verifizieren.)*
- **KON58-04 (Nebenbefunde, je eigener Posten)** — **`COMDARE_NFS_DROP_TOKEN` fehlt in 288** ⇒ **Ebene C bleibt inert** · **`CE_SUBMODULE_TOKEN` fehlt bei 
existierendem USER** ⇒ *„die Planer-Emission bräche, sobald dieser Pfad fährt"* · die **„776" ist die Zahl der gitleaks-Treffer (RuleID 
`gitlab-rrt`)**, keine Runner-/Projekt-ID · die Instanz akzeptiert weiterhin Registration-Tokens (`allow_runner_registration_token=true`) — **Reset-Weg ist 
ein Owner-Entscheid** (je Projekt vs. instanzweit).
- **KON56-01 (🔴)** — `measure:smoke` ist rules-gated auf `COMDARE_DURCHSTICH=="true"` und **DISJUNKT zu `COMDARE_RUN_MEASURE`**; letzteres erzeugte 
zusätzlich **`measure:golden-320` (timeout 10 days)** und **belegte den `resource_group`-Slot tagelang**. V3-Falle „Gesamtstatus grün ohne den 
entscheidenden Job" nur per **Jobliste** gefangen. **Betriebsfalle, nicht im Kopf.**
- **KON49-03 (NEBENBEFUND)** — im geteilten ce-Store liegen **13 ungelandete Branches vom 02.–10.08.**, darunter drei vom 10.08. 
(`bau/p2-warnstufe-aufteilen`, `bau/p6-lizenz-umsetzung`, `bau/p3-ci-clang-pflicht`; super-Seiten gelandet, ce-Seiten nie). **Eigener Aufarbeitungs-Posten — 
vor dem main-FF (#19) zu klären: landen oder begründet ausbuchen.** Der Kopf führt #19, **nicht diese Vorbedingung**.
- **KON49-04 (🔴 NEUE WORKFLOW-AUFLAGE)** — **BRANCH-PFLICHT**: Bau-Agenten committen auf **benanntem Branch** (nie detached HEAD), und der **Verify misst 
Branch + Store-Pfad SELBST** und weist ihn aus.
- **KON46-01 (Werkzeug-Falle)** — `git branch -r --contains` **in einem Worktree-Submodul misst den KLON-Zeitpunkt, nicht den Remote-Stand**; vor jeder 
Ref-Aussage `fetch --prune` **im Mess-Baum**. (Hat bereits eine falsche Ledger-Auflage erzeugt.)
- **KON46-03 (Lehre)** — *„ein blind extrahierter Wert ist eine BEHAUPTUNG"* — vor dem Einsetzen gegen die API verifizieren (200-Probe), nie nur 
strukturell.

### A.9 — Struktur/Zielform (KON43, KON47-01) — im Kopf nicht sichtbar

- **KON43-01 (Owner verbatim)** — *„erst den Planer aufbauen, dann die CEB, dann die Tier-Binaries und dann Hybrid. **In der Reihenfolge und nicht 
anders.**"* + *„4 unter-Projekte die in Träger-stufenform aufeinander aufbauen"* + Monolith-Split beim Aufräumen. Stufe N+1 hängt nur von Stufe N ab.
- **KON43-02 — ZIELFORM-PFLICHT AB SOFORT**: **S-8 und S-9 bauen in die Vier-Unterprojekt-Zielform, nicht in den Monolithen**; die Ziel-Ordnerstruktur wird 
**VOR dem S-8-Bau** geschnitten.
- **KON47-01 (Antwort am Objekt)** — der Planer existiert als eigene Binary, **aber NICHT in der Zielform**: die Planer-Substanz lebt in 
`libs/cache_engine/profile_facade/planner/` **im Monolithen**. **„Das Planer-Unterprojekt ist der erste Schnitt des Monolith-Splits (Task #29a)"** — **#29a 
fehlt im Kopf-Taskboard**, ebenso #88 (Konsolidierungs-Architektur).

### A.10 — Steuerung/Defaults/Hybrid-XML (KON42) — im Kopf nicht sichtbar

- **KON42-01(2) DEFAULT-DOKTRIN (Owner verbatim)** — *„all diese Variablen standardmäßig hart in den Planer als default einkompiliert werden und durch 
jede vorhandene Eingabe in die XML überschrieben"* ⇒ **kein Pflicht-Attribut in der XML für Deckel-Werte**; Bau-Auflage für S-8 (`constexpr`-Defaults + 
XML-Override je Attribut).
- **KON42-01(4) HYBRID ZWEIWEGIG XML-STEUERBAR** — Weg (i): **Belegung** des Hybrid per XML als Durchstich manuell statisch wählbar; Weg (ii): 
**Synthese-Funktionen und Wirkbereiche** einzelner Tier-Binaries manuell per XML setzbar ⇒ der `<hybrid_tier>`-Parser (HY-A3) trägt **beide** Wege. **Kein 
HY-A-Posten im Kopf-Taskboard.**
- **KON42-01(1)/KON58-02** — die 32 ist **Programm-Deckel** (`kHybridNodeObergrenzeDefault = 32`), *„der Wert ist willkürlich und wird später in **W7** 
angepasst"* ⇒ **W7-Posten „Dock-Deckel-Anpassung"**. Der Kopf trägt die dritte 32er-Rüge (KON71), **aber nicht den W7-Anpassungsposten**.
- **KON39** — **W7-BILANZ: 23 Posten (9 Behälter + 14 Zähler)**. Der Kopf kennt **kein W7** überhaupt.

### A.11 — Mess-Architektur-Festlegungen aus KON37, die der Kopf nicht führt

- **KON37-01 (🔴 VERERBUNGSREGEL, Owner verbatim)** — *„Die CEB ruft nur die Messfühler in der Tier-Binary und Hybrid auf, die sie selbst gebaut hat 
bzw. baut höhere Träger-Stufen nur nach ihren eigenen Messeigenschaften. Freigabe also auf Planer, Durchführung im Vertrag zwischen CEB und Tier/Hybrid."* 
⇒ **keine CEB-Wallclock ⇒ keine Fläche-3-Wallclock-Einrichtung in ihren Tier-Binaries.** Für B3: der „Wallclock-Umzug" ist **kein physischer Umzug**, 
sondern der Umzug der **Schalter-Hoheit** (`abi_adapter.hpp:476-491` fällt).
- **KON37-03 (🔴 ANORDNUNGS-FREIGABE, Owner verbatim)** — *„die Reihenfolge muss in einer beliebigen Anordnung statisch in der Mess-Achse freigegeben 
werden, damit die Zeiger und Zustände für an/aus für jede Stufe klar definiert ist … jede Stufe also ihre ganz spezifischen Wallclock/Macro/Micro compile 
time Einrichtungen bzw. **ein subset der 3** … Die statische Festlegung ‚Wie viel' ist technisch nicht umsetzbar ohne Planer Simulation."* ⇒ B4: System 
B's geordnete Typliste bekommt **genau diese Zielrolle** (Adressierungsstruktur), **nicht** `anzahl==6`-Permutation.
- **KON37-02 (B1, Owner verbatim)** — *„Am besten direkt neu nach der geänderten Architektur. Das alte archivieren."* + **KORRELATIONS-PFLICHT**: Freigabe 
und Ausführung korrelieren über die **Permutation einer freigegebenen Konfiguration per compile time der höheren Träger-Stufe**. XML-Element 
`<measurement_tooling>` wird um die **Stufen-Dimension tier/hybrid/ceb** erweitert.
- **KON37-06 (Owner verbatim)** — *„ein build oder eine Messung dürfen **je 5 Mal** scheitern bis wir aufgeben"* + 3 Wiederholungen **je Parameter und 
Binary, alle 3 EINZELN persistiert**. Der Kopf führt „#13 T-15b", **nicht die 5/5-Klammer über BEIDE Vorgänge**.
- **KON40-02** — System B = **17 Code-Dateien + 1 README**; **B4-Umfang: 9 Kern-Dateien Umbau, 8 Ripple**. Nebenbefund: das Auswahl-Subsystem hat **17** 
Referenz-Dateien (KON29-05 zählte 18).

### A.12 — Arbeitsweise v3.6–v3.9 (KON58-09) — nur teilweise im Kopf

- **v3.6 / A1 + A1.1 (Owner: *„du bist gerade nur Opus 5 und ERKENNST KEINE FABLE 5 PROBLEME"*)** — Review-Analyse **zweistufig**: **Opus 5 max ERHEBT** 
(alle Pfade, ausgefüllte Wahrheitstafel, urteilt NICHT), **Fable 5 max BEWERTET adversarisch** — **beide Pflicht, ZUSÄTZLICH zum Codex-Lens**. Begründung: 
*„Ein Lead, der seine eigene Review-Analyse führt, ist sein eigener Zweit-Lens; das ist keiner."*
- **v3.7 / A2.1(a2) (Owner: *„prod1 verträgt nur 3 builds wegen Plattenspeicherplatz parallel"*)** — **harte Obergrenze: MAXIMAL DREI GLEICHZEITIGE 
VOLLBAUTEN**, unabhängig vom df-Wert im Startmoment; der KON55-Kombibau zählt als **EIN** Slot. **Siehe (B.2).**
- **v3.8 / A2.1a WELLEN-FORM** — N Worktrees parallel → lokale Vollbauten (≤3) → **Merges seriell und lokal, OHNE Push und OHNE Pipeline dazwischen** 
→ **EIN Push**, wenn alle gelandet sind → **EINE CI**. Bedingung: jedes Paket ist **vor** seinem Merge lokal vollständig grün; jedes Paket landet als 
eigener `--no-ff`-Merge.
- **KON58-06(2) / Codex-Rezept** — Review-Gegenstände in ein **WEGWERF-VERZEICHNIS** kopieren, Codex dort mit vollem Zugriff; **Lens klein schneiden (ein 
Gegenstand, drei Fragen)** + **von Anfang an ein PARALLEL laufender zweiter Lens anderer Herkunft**.
- **KON58-11 / BEFUND 1** — **die ARBEITSWEISE liegt an ZWEI Orten mit VERSCHIEDENEM Inhalt**: `super docs/` trägt **53 Zeilen (ein ZEIGER seit 10.08.)**, 
der Umbrella **988 (die geltende Fassung)**. *„Wer der Memory-Pfadangabe folgt und dort aufhört, liest einen Umzugshinweis und hält ihn für die Doktrin."*
- **KON58-12** — der Ledger kannte den 13.08. **nicht** (Einträge von heute = NULL). Lehre: **der Nachtrag gehört an die LANDUNG gebunden, nicht an den 
Vorsatz** (`scripts/ledger_nachtrag.sh`).
- **KON58-08 (Lehre)** — *„ein Bau, den niemand zu Ende sieht, hat nicht stattgefunden; Bauten laufen im Vordergrund oder abgekoppelt (setsid/nohup), nie 
an der Lebensdauer des Agenten hängend."*
- **KON58-10 (Mechanik)** — der **eine Hotspot `tests/unit/CMakeLists.txt`** wird von **sieben der elf Posten** angefasst; Auflösung: **jeder Strang hängt 
seinen Block ans DATEIENDE mit Strang-Marker**. Und: `test_s5_*`/`test_s7_*` sind im Bestand **mit anderem Gegenstand belegt** (18 bzw. 10 Dateien) ⇒ **neue 
Tests bekommen THEMATISCHE Namen statt Posten-Nummern** (V12-Klasse eine Ebene tiefer).

---

## (B) WIDERSPRÜCHE OHNE TRAGENDEN MARKER

**B.1 — Die „6 GB": Warnschwelle auf Messdaten vs. feste statische Arena**

| Quelle | Wortlaut |
|---|---|
| Segment **KON51-02** | *„🔴 SCHWELLE: **WARNUNG** an den Planer, wenn die CEB **> 6 GB RAM Messdaten hält**"* |
| Segment **KON52-01** | *„V-F2 DEFAULTS: rein informativ · WARN-Grenze und OOB-Grenze **SEPARAT in der XML einstellbar** · Standard = NUR delayed Warnung 
(Schwelle 6 GB) und **KEINE Begrenzung** (OOB aus)"* |
| Kopf **KON93** | *„C6 = **ARENA 6GB FEST, STATISCH**, Planer-Reservierung zu Experiment-Beginn änderbar (10-Wochen-Explore läuft)"* |

Einmal ist die 6 GB eine **XML-überschreibbare Warnschwelle über akkumulierte Messdaten ohne Deckel**, einmal eine **feste statische Arena-Größe, nur über 
die Planer-Reservierung änderbar**. Der Kopf nennt für KON92 „6 Überholt-Marker" in der Arena-Ketten-Karte — **welcher davon (falls einer) diesen Fall 
trägt, steht nirgends.** Auflösung nötig, sonst baut S-13 die XSD-Attribute (`ram_warn_grenze` / `ram_oob_grenze`) gegen ein anderes Objekt als die Arena.

**B.2 — Parallelitäts-Deckel: „maximal drei" gegen „maximal parallel"**

| Quelle | Wortlaut |
|---|---|
| Segment **KON58-09 / v3.7** | *„HARTE OBERGRENZE prod1 — **MAXIMAL DREI GLEICHZEITIGE VOLLBAUTEN** (Owner: ‚prod1 verträgt nur 3 builds wegen 
Plattenspeicherplatz parallel'). **Gilt UNABHÄNGIG vom df-Wert im Startmoment**"* |
| Kopf **KON73** | *„**VOLLES GO maximal parallel**"* (+ F7 Drei-Bereiche-Concurrency: CI-normal 3/2 je 4 Kerne, heavy 16, ce floor((T-4)/4)×4) |

KON73-F7 regelt **CI-Job-Concurrency**, v3.7 regelt **lokale Vollbauten auf prod1** — die beiden Gegenstände sind verschieden, aber „VOLLES GO maximal 
parallel" trägt **keinen Vorbehalt auf den lokalen 3er-Deckel**. Ohne Marker liest sich der Kopf als Aufhebung. (KON49-04 belegt die Kosten: 2,9 G freier 
Platte = **Ursache dreier stummer Agenten-Tode**.)

**B.3 — Lastsequenz: „gehört IN die framework-Mess-Achse" vs. „ist eine EIGENE Mess-Achse"**

| Quelle | Wortlaut |
|---|---|
| Segment **KON37-05** (Owner verbatim) | *„die **Lastsequenz** in die **framework Mess-Achse gehört** und **nicht in derselben Klasse** liegt wie ein 
Gattungsaufruf/Genusaufruf/Achsen-Interface-Aufruf, **weil sie selbst auf einem Achsen-Interface liegt**"* — Verbuchung: *„wird dort **einsortiert**, nicht 
als dritte ‚Ebene'"* |
| Kopf **KON64/65** | *„**Lastsequenz = EIGENE Mess-Achse** (10-Wochen-Explore vor Design)"* |

„In eine Achse einsortiert" ≠ „ist eine eigene Achse" — das ist ein Unterschied im **Achsen-Nenner** und damit im Permutationsraum. KON65 ist neuer und 
gewinnt nach Vorrangregel, **ein Marker, der KON37-05 als überholt ausweist, existiert nicht.**

**B.4 — Projektstruktur: vier Träger-Unterprojekte vs. Repo-Rollen**

| Quelle | Wortlaut |
|---|---|
| Segment **KON43-01(2)** (Owner verbatim) | *„Im Projekt der cache engine brauchen wir also **4 unter-Projekte die in Träger-stufenform aufeinander 
aufbauen**"* + **Zielform-Pflicht ab sofort für S-8/S-9** |
| Kopf **KON73 / F6** | *„Repo-Rollen (ce=Framework, super=Einstieg, XSD-Hoheit→ce #74)"* · Task **#74 Repo-Rollen (W2/W)** |

Formal disjunkt (Unterprojekte **innerhalb** ce), aber der Kopf beschreibt die Zielstruktur **ohne** die Vier-Träger-Gliederung und ohne die Zielform-Pflicht 
— und **#18 S-13-Bündel / #3 S-12 sind lebende Bau-Plätze**, die nach KON43-02 in die Zielform bauen müssten. Ohne Marker ist unklar, ob KON43 fortgilt.

**B.5 — Der Rest von KON58-10: sechs von elf Wellen-Posten ohne sichtbaren Nachfolger**

Der Kopf trägt aus dem disjunkten Wellen-Schnitt nur **P11 (S-14a, KON78 „bereits in dev")**, **P6 (B2, KON70/74)** und **P4 (Homes, F5/KON73)**. **P1 
(S-3), P2 (S-7), P3 (S-5), P5 (Layout-7), P7 (S-4), P10 (MinIO)** haben **keinen** Anker in KON60–93 — obwohl KON58-10 vier **nicht verhandelbare** Fesseln 
benennt (**P11 vor P4 · P6 vor P4 · P1 vor P2 · P3 vor P5**) und die Lande-Ordnung 1–9 festschreibt. Ohne Auflösung ist unklar, ob die Fesseln noch 
gelten oder die Posten ausgebucht sind.

---

## (C) ÜBERHOLT-BESTAND (nur Zählung + Kurzliste)

**Im Segment selbst als überholt/gefallen markiert: 29 Stellen.**

KON59-01 („nur aus Tests" → „vorhanden, aber inert") · KON58-01 Binnenaufteilung 13/16 → 12/18 · KON58-01 eigene Planungszahl 123 → **122** · 
KON58-02 Q6 8 → 32 (vier Doku-Stellen, je NACHZUG-Vermerk) · KON58-03 zwei prod1-Alt-Zitate „32 Threads/24 Kerne" + §69.6 HEAVY-Teil · KON58-06(3) „9 
Einträge" = wc-l-Artefakt (KON12-02-Restposten erledigt) · KON58-10 Ortsangabe `set_active_machine_declaration` (profile_facade → 
`simd_build_gate.hpp:234`) · KON58-13 Lock v2 → v3 + 158 → **718** (v1/v2-Locks werden hart abgewiesen) · KON57-02 #84-Vorbestand (Padding-Bytes) 
erklärt+geheilt · KON55-02 lokaler gcc-only-Kombibau → 2×2-Matrix · KON46-01 KON44-Sequenz-Auflage = Stale-Refs-Artefakt · KON44-01 F1-Blocker (Emitter 
vs. Gate) → KON47-01(a) · KON44-03 289-Variablen → KON46-03 rotiert · KON41-03 KON28-03-„Beobachtung" + KON34-03-Klammer *„VÖLLIG FALSCH"* · 
KON41-02 OF-1 17-vs-18 (dieselbe Menge) · KON41-01 F-D-Spannung → „BEIDES" · KON39 KON30-04/R-4 gestrichen + 11 Alt-Fragen entfallen · KON37-03 eigene 
Empfehlung „nur an/aus" gedreht · KON37-08 eigene Empfehlung „deprecaten bis W7" abgelehnt · KON37-01 Wallclock-SOLL-Konflikt aufgelöst (Merge) · 
KON36-01 Ein-Ort-Prämisse (3! CEB-Versionen) überholt durch KON25-03 + zwei falsche Zitatanker + „32 ersetzt 12"-These widerlegt · KON36-02 eine 
Fehldarstellung (Hybrid „eigenständig") korrigiert + drei Berichts-Behauptungen verworfen · KON45-01(2) Variante (b) verworfen · KON47-04 
KON45-03-Zell-Warmup-Vorlage ersetzt · KON47-03 „Provenienz-nur" abgelehnt · KON52 verengt meine V-F1-Empfehlung (3er-OOB-Klasse → **eine**) · KON54 
hebt KON53-Ableitung 2 zur Festlegung · KON58-09 v3.6–v3.9 lösen v3.5 ab.

**Vom Kopf (KON60–93) erkennbar überholt: 8 weitere.**

KON56-01 `ns_per_op=644.020` → **KON61 NE-01: 1199.047, „644.020 NIE zitieren"** · ctest 485/486 → **KON61 Kombibau 4×491** · KON58-05/-11(a) 
„C-3a-Tripwire bleibt gesperrt" → **KON91 C-3a=JA (#38a2 im W1-Bump-Bündel)** · KON47-03 Festplatten-IO-Framing → **KON80 V10 / ORG-19 (XML-opt-in, 
Genus-Interface +store()/load(), „18 + 1 optionale Meta-Meta")** · KON58-13 S-14a-Landefrage → **KON78 (8cc564d5 bereits in dev)** · KON49-02 manuelle 
Löschregel → **KON82 Worktree-Remove-Wache als Werkzeug** · KON41-03/KON42-01 32er → **KON71 dritte Rüge (dynamisch >32, nur S-19 rechnet)** · KON58-01 
„SYSTEM/MESS-Homes existieren nicht" → **KON73 F5 DREI Homes (mess/system/ORGAN_AXES)**.

---

## (D) TRAGENDE ARCHITEKTUR-KERNE DES SEGMENTS

1. **Die Träger-Kette ist eine Baureihenfolge, kein Bild.** KON43-01: *„erst den Planer aufbauen, dann die CEB, dann die Tier-Binaries und dann Hybrid. In 
der Reihenfolge und nicht anders."* Vier Unter-Projekte in Träger-Stufenform; Stufe N+1 hängt nur von N ab. Zielform-Pflicht ab sofort (KON43-02).
2. **Jede Naht hat dieselbe Schablone: Fläche 1 = Control, Fläche 2 = Stempel** (KON50-01). Planer→CEB: erkannte Anforderungen hinab, **Status + 
Log-„warum" + Ergebnis-Trace** hinauf — **niemals Mess-Rohdaten** (KON50-02).
3. **Steuer-Naht spricht XML (gefiltert), Mess-Naht spricht sparse binary** (KON51-01). Der Planer gibt nur *„gefilterte Programmteile aus der Planer 
Syntax-geprüften Eingangs-XML"* heraus; **jede freigebende Stufe lädt aus ihrer Binary heraus die Module der nächsten**.
4. **Latenz-Reinheit schlägt Betriebs-Sichtbarkeit.** KON52-01, Owner: *„Nur das Fertig-Signal darf die Prioritäten überspringen, weil Zwischen-Signale 
Latenzen erzeugen, welche Messwerte verfälschen."* Genau **eine** OOB-Nachricht; alles andere queued bis zum Break.
5. **Die Barriere zwischen Teil-Experimenten ist die einzige Steuer-Gelegenheit** (KON53-01): voller beidseitiger Flush+Sync, Drain-Quittung als 
Startbedingung, dann `--auto` **oder** manuelle Bestätigung **oder Verneinen** (KON54-01). Nur zwei Kommandos dürfen in die Stummphase: `{stop_ram_oob, 
stop_user_kill}`. *„Ja das Lager heilt das."*
6. **Messen heißt paarweise messen.** KON47-04, Owner: *„Es wird einmal gemessen und verworfen, es wird einmal gemessen und mit warmem cache gespeichert … 
SONST IMMER ZWEI MAL."* 3 Wiederholungen ⇒ 6 Läufe, 3 **einzeln** persistierte Werte; `--debug` = einmal, kalt. Retry: **je 5** für Build **und** Messung 
(KON37-06).
7. **Die Mess-Achse trägt eine statische Anordnungs-Freigabe** (KON37-03, Owner): beliebige Reihenfolge, statisch freigegeben, *„damit die Zeiger und 
Zustände für an/aus für jede Stufe klar definiert ist"*; jede Stufe trägt **ein Subset von {Wallclock, Macro, Micro}**; „wie viel" ist ohne 
Planer-Simulation (S-19) nicht bestimmbar.
8. **Die Mess-Bestückung der Kinder folgt der CEB** (KON37-01, Owner): *„baut höhere Träger-Stufen nur nach ihren eigenen Messeigenschaften"* — Freigabe 
am Planer, Entscheidung an der CEB, Durchführung im Vertrag CEB↔Tier/Hybrid.
9. **Der Compiler wird eine System-Achse belegen** (KON55-01, Owner): clang **und** gcc sind Basis-Pflicht, CI **und** lokal, *„weil Compiler Performance 
Unterschiede bringen"*; konkret die **5. System-Achse `gcc|clang`** mit Unterachsen opt/flags/commands (KON56-03).
10. **Der Hybrid erbt Tier und fügt genau eine Zeile ein** (KON41-04, Owner): vorletzte Zeile = serialisierte compile-time-Map {Synthese-Key → Tier-Stempel} 
über alle belegten Prüfdocks, letzte Zeile = SHA, *„der Hybrid SHA wirkt auch über diese neue Zeile compile time"* ⇒ andere Bestückung = anderer SHA = 
neuer Lager-Datensatz. Als Map-Value gilt der **Tier-SHA**, nicht der Voll-Stempel (KON47-02, Budget).
11. **Deckel-Werte leben im Planer, die XML ist der Override-Kanal** (KON42-01, Owner): *„hart in den Planer als default einkompiliert … durch jede 
vorhandene Eingabe in die XML überschrieben"*. Die 32 der Prüfdocks ist ein **Programm-Deckel**, willkürlich, in W7 anzupassen — und **NICHT** die 
Mess-Permutation (KON41-03: *„Das sind zwei verschiedene Dinge. VÖLLIG FALSCH."*).
12. **Der Stempel ist der Cache- und Lager-Schlüssel — deshalb der Riegel.** KON58-13: die Wache maß den Substring `algo_version` und ließ **235 von 387 
Dateien (60 %) unbewacht**, während sie „GRÜN" meldete. Geheilt über den **Overlay-Schnitt** (`kOverlaySourceSet`) als Grundgesamtheit: 718 Records, 
*„deckt 712 von 712 Overlay-Quellen"*. Fehlerklasse: **„Änderung ohne Bump ⇒ kein Neubau ⇒ schneller UND falsch."**
13. **Betriebsfolge des Riegels** (KON58-01/-07/-13): jede Änderung an den 122 Trägern erzwingt Bump **oder** Lock-Regen; akzeptierter Bump ohne Regen ⇒ 
**Exit 3 „REGEN ERFORDERLICH"**; nach jedem Merge auf dem Zielzweig einmal `--check` + `--write` + `git diff`.
14. **Golden-neutral baut man durch Ortswahl, nicht durch Vorsicht** (KON58-05): nichts unter `axes/`, `topics/`, `heuristik/` anfassen — Overlay-Glied [7] 
hasht deren Quelltext; Arbeit in `measurement/`, `profile_facade/`, `tests/`.
15. **Generalprobe ist der Dauerzustand, nicht ein Termin** (KON41-01, Owner): *„wir immer bis 3 Tage vor Abgabe Generalprobe laufen, dann die Builds und 
Messdaten manuell löschen, da ungenau und dann den finalen Lauf bis zur Abgabe durchfahren. Generalprobe wird formal durch das --debug Flag aktiviert."* Das 
Lager fährt Skip, sobald es voll ist — einmal gebaut+gemessen ⇒ verfügbar. **Kanal: hauptsächlich CI, lokal wird nachgezogen.**
16. **Und die Rechnung dazu ist offen** (KON41-01 + KON58-03): 41,4 h einlanig @24W → ~45,6 h @16W, gegen ein T-3-Fenster von 3 Tagen, aus dem der 
OV-4-Mess-Deckel erst noch **rückwärts kalibriert** werden muss — mit S-19-Zahlen, vor der GO-Vorlage ##51.

==========================================================================================
## RESULT 2 (wf_750a0423-c46)
==========================================================================================

# LEDGER-GEGENLESE — SEGMENT Z. 5259–7900
**Gegenstand:** KONSOLIDIERUNG IV, Kapitel A–M (der „geltende Stand je Thema" aus KON1…KON49) + die Voll-Nachträge **KON34 → KON16-01** (rückwärts). 
Gelesen: 5259–8618 (Segment vollständig + Überlappungspuffer). Abgeglichen gegen `kopf_referenz_kon60_93.md`.

**Vorbemerkung zur Gewichtung:** Kapitel A–M ist *die Nachschlage-Fläche* („Wer heute etwas nachschlägt, liest **hier**", Z. 5263-65). Alles, was dort 
steht und im Kopf KON60-93 fehlt, ist damit nicht nur „vergessen" — es ist **aktiv als geltend markiert** und wird von niemandem mehr gelesen.

---

## A. LEBEND, ABER IM KOPF (KON60-93) UNSICHTBAR

### A-I · Kette, Emission, Bauform (Kapitel B/I)

| # | Anker | Substanz |
|---|---|---|
| A1 | **KON16-03 / KON18-01 / KON17-01** | 🔴 **KEINE YAML in der Trägerkette.** *„der Planer emittiert direkt eine pipe oder Prozess […] Jede Träger 
Stufe emittiert die nächste direkt und unter Verwendung eines zentralen Bau-Modules, welches wiederverwendbar im Builder Pattern den nächsten Träger 
aufbaut."* Bauform: *„das Baumodul [ist] eine Planer Bibliothek in C++23"*, erlaubte Nicht-C++-Träger **nur CMake**. **NUR der Planer wird direkt 
kompiliert.** Im Kopf KON60-93 taucht diese Doktrin **nirgends** auf — dort läuft nur GitLab-CI-Arbeit (CI-DUAL, Workflow-Templates). |
| A2 | **KON25-08** | 🔴 **DIE TRÄGER-RAKETE.** *„wir brennen die Rakete nicht stufenweise ab, sondern bauen sie stufen weise rückwärts auf"* — Stufe 
N zündet bei Erfolg N+1, das fertige Modul N+1 wird **ABI-stabil in die vorhergehende Stufe gesteckt**. Emissionsliste je Stufe = **volle Pipeline**: Bau + 
Test + **LINT + RELEASE** + Lager + J-1…J-4. |
| A3 | **KON17-02** | 🔴 **Emissions-Abschluss ist ein LAGER-Kriterium:** *„Die Emission ist abgeschlossen, wenn die angeforderten CEBs und Tier-Binaries 
und Hybrid im Lager zu finden sind."* Nicht fertig bei „kompiliert/gelinkt/Tests grün". ⇒ die zwei **undurchgesetzten Stempel-Rollen liegen auf dem 
kritischen Pfad**. |
| A4 | **KON17-01** | **Jeder CEB-Bau läuft wegen RAM SEQUENTIELL**, ebenso die von der CEB verlangten *und registrierten* Folge-Builds. Steht neben KON73-F7 
(Drei-Bereiche-Concurrency) ohne dass irgendwo aufgelöst ist, welche Regel beim CEB-Bau gewinnt. |
| A5 | **KON43** | **VIER Träger-Unterprojekte im ce**, in Trägerstufen-Form aufeinander aufbauend, **N+1 hängt nur von N**. Neue Bauten (S-8/S-9) entstehen 
**ab sofort** in der Zielform. (Kopf hat nur #29 „Zielstruktur publiziert"; das Abhängigkeits-Gesetz N+1←N fehlt.) |
| A6 | **KON47** | **Der Planer ist eine EIGENE Binary und steht NICHT in der KON43-Zielform.** Ausnahme zur Vier-Unterprojekte-Regel — im Kopf nirgends. |
| A7 | **KON25-04** | **`CiYamlBuilder` BLEIBT** — ausdrücklich *„für den lokalen build außerhalb der CI"*. Kein Rückbau, aber **nicht** der 
CI-Träger. |
| A8 | **KON9-06 / KON10-05** | Die Selbstkompilation hat eine **gebaute Blaupause**: `catalog_codegen.cmake` (add_custom_command + TARGET_FILE + DEPENDS xml), 
Director = `ExperimentPlanDirector`, **die Filterkette (C++23-concept + mp11) IST der Mechanismus** — *„nur bestimmte concept-builds zur Laufzeit eines 
niederen Trägers dürfen den compile eines höheren Trägers bilden"*. |
| A9 | **KON19-02 / KON13-01** | **Der Hybrid ist Transmitter/Multiplexer, KEIN Aggregator** (je Thread genau eine Tier-Binary; Werte gehen über Fläche 3 
*durch* ihn). Und: *„das Hybrid kann nicht bauen, sondern nur Tier-Binaries messen, die schon gebaut sind"* ⇒ er ist Glied der **MESS**-Kette. |
| A10 | **KON36 (Korrektur) / KON21-01** | Hybrid-Autonomie ist **zweistufig**: **jetzt** orchestriert die CEB alle Prüfdocks direkt **oder delegiert** über 
*wiederverwendete CEB-Module* (Bestand: `AnatomyModuleLoader`); **später** eigenständige Lade-Entscheidungen über den **Sync-Kanal S-20 (Neubau)**. S-20 
kommt im Kopf nicht vor. |
| A11 | **KON8-04** | Die **System-Achse sitzt IN der CEB** und gibt von dort Organ frei — **keine Querkante System→Organ** neben der Trägerkette; der 
Freigeber ist eine **Achse**, kein Träger. |
| A12 | **KON26-03 / KON27-05** | `PlanTextBuilder` + `plan dump` + der **hart gegatete** CI-Job `visibility:tier-binaries` + `parse_plan_dump()` sind 
owner-bestätigt **produktionskritisch und bleiben**; nur das Flag-Wort `--dump-plan` ist überholt. Eine Streichung wäre *„Abriss aktiver, hart gegateter 
Funktionalität"*. |
| A13 | **KON23-05/E** | **0 von 4 Trägern haben einen eigenen Bau-/Test-Job** (super 45 Jobs · ce 25 · „hybrid" 0 Treffer beidseitig). |

### A-II · Stempel (Kapitel C)

| # | Anker | Substanz |
|---|---|---|
| A14 | **KON9-11 / KON13-06-C3** | 🔴 **Fünf Rollen, nur ZWEI durchgesetzt.** Identität + Einordnung laufen produktiv; **Lager-Schlüssel** und 
**Skip-Marke** haben *nur Test-Aufrufer*; **Cache-Schlüssel** offen. Zusammen mit A3 heißt das: der Emissions-Abschluss ist heute **nicht prüfbar**. |
| A15 | **Kapitel C, Fehlerklasse** | 🔴 Änderung ohne `X.Y.Z`-Bump ⇒ kein Neubau ⇒ **schneller UND falsch**, sieht aus wie ein Cache-Treffer. 
*„Braucht ein **Werkzeug**, nicht Disziplin."* |
| A16 | **KON16-06 / KON25-02** | **DREI Flächen** (nicht zwei): 1 Genus-Interface · 2 Stempel (trägt Tools/Compiler als Teil der **Systemachse**) · 3 
measurement-Durchstich = die **NAHT-1 vom 09.08.** (`IMessVisitor`). Owner: *„beide Konzepte müssen vereint werden"* — Bau-Posten. Der Compiler **wandert 
über die Compile-Grenze**: davor im CEB-Genus-Wert, danach trägt das Genus-Interface **nur noch** den Durchstich. |
| A17 | **KON7-07/08** | Die Muster: **COMPOSITE** = *wo/was* (inkl. der **Verbote**) · **STRATEGY** = *was in die Klammer* · **BUILDER** = *wie 
zusammensetzen* · **compile time factory** erzeugt Fläche 2. Alles **CRTP statt `virtual`** — *„wer im Review nach `virtual` sucht, findet keine Factory 
und hält sie fälschlich für nicht gebaut."* |
| A18 | **KON7-03** | **Zeilenzahl folgt der Stufigkeit: Planer 2 · CEB 3 · Tier 4 · Hybrid 4 + Karte.** Die CEB hat **keine Organ-Zeile**, weil Organ bei 
ihr *freigegeben, nicht eingebaut* ist. (Der Kopf kennt via KON60-B1 nur die Tier-4.) |
| A19 | **KON7-01** | 🔴 **Die Identitäts-Fläche ist am ABI heute OPTIONAL** — der Loader verlangt nur 4 Pflicht-Symbole, das **5. (Stempel) darf 
`nullptr` sein**. **SOLL: Pflicht.** Konkreter, unerledigter Bauauftrag. |
| A20 | **KON7-04** | **Fläche 2 hat sieben Interfaces**; `angeschlossene()` existiert **NUR beim Hybrid** und braucht einen **Laufzeit-Sammler** über die 
Dock-Registrierung ⇒ **zwei Mechanismen hinter EINER ABI-Fläche, beim Bau zu trennen**. |
| A21 | **KON41-04 / KON7-05 / KON8-10** | 🔴 **Der HYBRID-STEMPEL ist vollständig spezifiziert:** Tier-Verhalten **+ eine Zeile mehr** = serialisierte 
**compile-time-Map** {Synthese-Funktions-Key → Prüfdock-Tier-Stempel}, konkateniert über alle belegten Docks; letzte Zeile = SHA, **der die Map mit deckt** 
(andere Dock-Belegung ⇒ anderer Hybrid-SHA). Die „Bereichs-Karte" (Grenzen = **Break-Even**) IST diese Map; leer/einbereichig davor ist **Sollverhalten**. |
| A22 | **KON8-03** | Die CEB hat **ZWEI System-Anzeigen**: (1) compile-time → **in** den Stempel; (2) Laufzeit/RAM-Erkennung → **nicht** in den Stempel. 
Das erklärt „CEB-System leer" und ist ein zweiteiliger Bauauftrag. |
| A23 | **KON8-05/06** | **Der Stempel wird nicht geschrieben — er FÄLLT AN** als Resultat der B+-Baum-Materialisierung; Fläche 2 trägt **bewusst kein 
Freigabe-Feld** (Freigabe = Laufzeit-Abfrage am Baum). |
| A24 | **KON8-07** | Die **Composite-Zulassungsmatrix ist DREIWERTIG** (PFLICHT-in-MIN / ERLAUBT / VERBOTEN) — das ist die prüfbare Operationalisierung von 
`MIN ⊆ implementiert ⊆ freigegeben`. |
| A25 | **KON2-15** | Der Vertrag CEB↔Tier ist **produktiv verdrahtet**: `conformance_gate` · `mess_interface_testate` · `mess_konsistenz_gate` — 
letzteres fährt **vor jeder Messung, fail-closed**. |
| A26 | **KON2-09** | **W12-B nur halb erfüllt:** Organ-Änderung invalidiert chirurgisch, **System-Änderung löst weiterhin Vollbau aus.** |
| A27 | **KON21-03 / KON20-02 / KON5-04** | **Der S-6-Schnitt vollständig** (a Umstellung · b Transpositions-Sperre · c Kategorien-Ordnungs-Wache *„Ja 
bitte"* · d #67 behalten) **+ die VERBOTSZONEN** (Lager-Kaskaden, `kOrganGruppen*`, `kSystemAxisOrder`, `kCompositionAxisNames`, Hash-Mechanik, 
Messwert-2-Tupel). Der Kopf führt #15 als Bau-Platz, aber **ohne diesen Inhalt** — insbesondere ohne die Verbotszonen. |
| A28 | **KON2-06/17** | **SOLL-Versionierung je Stufe** + **drei IST-Lücken**: **Planer ohne SHA** · CEB-System-Anteil leer · **Genus handgeschrieben** (5 
Literale, 1 Test-Aufrufer). Alle vier Binaries sollen einen Fingerprint-SHA tragen. |

### A-III · Achsen, Grammatik, Wachen (Kapitel D)

| # | Anker | Substanz |
|---|---|---|
| A29 | **KON27-01** | 🔴 **DAS HOME-PRINZIP, zweistufige Versionierung:** *„jede Achsen-Kategorie [braucht] ihr eigenes home, für das unter der 
Stempel-Mechanik **genau ein Wächter** greift"* — ORGAN=`axes/` (existiert), SYSTEM+MESS **fehlen**; Wächter prüft **ZWEIphasig** (System/Organ) bzw. 
**DREIphasig** (Mess). **Varianten unterscheiden sich ⇒ verschiedene ACHSEN-INTERFACE-Versionen; deren Algorithmen unterscheiden sich ⇒ verschiedene 
ALGORITHMUS-Versionen.** Reihenfolge: *„Wir beginnen aber zuerst mit einer gültigen golden Version."* Der Kopf kennt via KON73-F5 nur „DREI Homes" als 
Zahl — **die Zwei-Ebenen-Versionierung und die Ein-Wächter-Regel fehlen**. |
| A30 | **KON9-05 / KON25-01 / KON23-01** | **Die Flag-Grammatik v2 (gebaut 07.08.) ist die geltende volle Syntax:** `basis := c \| g \| f \| n \| x128 \| x256 
\| x512`, `'c' = CPU`; `p`/`e` sind **Sub-Flags nur unter c**: `c{p}`, `c{e}`, `c{p.e}`. **Flache `cp`/`ce` existieren nicht und würden abgelehnt** 
(static_assert). O-1 ist GESCHLOSSEN. Der Kopf führt neue Tokens (`iw/ima/imi`, `p/b/h/t`, `i{pmc}`) **ohne die Basis-Grammatik zu wiederholen** — genau die 
Falle aus dem Memory-Eintrag „Kürzel immer zerlegen". |
| A31 | **KON13-03** | **ZWEI Grammatiken, nicht drei:** G-1 Mess (dreiphasig, von v2 gedeckt) · **G-2 System+Organ (zweiphasig) — Syntax existiert, die 
SEMANTIK ist nachzuholen *in Reihenfolge der Achsen-Nummerierung***. |
| A32 | **KON16-02 / KON23-02** | 🔴 **Die zwei Flag-Seiten:** *„Im Falle der **Freigabe impliziert** es das Vorhandensein und im Falle der **compile Seite 
Fordert** das Flag das Vorhandensein von Hardware ein."* Dreiphasig zusätzlich: die Mess-Achse der CEB fordert **den Vertrag mit den Messfühlern**. **Beide 
Seiten sind gebaut und heute leer/inert** ⇒ **S-3/S-7 sind Aktivierungs-, keine Neubau-Aufträge.** |
| A33 | **KON17-03 / KON2-19 / KON23-05-F** | 🔴 **Die C-4-Wache** (`contract:axis-version-lock`) sichert heute **6 Heuristik-Header**, Schnittmenge mit 
`axes/` = **0**, ≥152 ungedeckt; die hartkodierte Pfad-Liste war **Mitursache des Drei-Wochen-Ausfalls**. Owner: *„Wache **Modular erweitern** und in 
**Detail-Klassen splitten**"* — **eine Klasse je Kategorie-Home**; Autodiscovery über die Registry-Typlisten ist im Bestand vorgezeichnet. Im Kopf: 
**nichts**. |
| A34 | **KON9-09** | **Rang-1-Owner-Pflicht:** je Achsen-Kategorie die definiert freigegebene **Syntax UND Semantik** — *„Pflicht und Basis für die 
Abgabe"*. Und: **MIN ist ein Querschnittskonzept mit ZWEI Filtern** — System+Organ additiv monoton, **Mess zweischneidig** (mehr Messfühler = mehr Latenz). |
| A35 | **KON7-06 / KON8-09** | **Flag-Katalog-Lücke:** Vollausbau **59 Knoten, alle im c-Zweig**; g/f/n ohne Sub-Token. **Namenskollision `f`=FPGA (Tiefe 0) 
vs. AVX-512-Foundation (unter x512)** wird Risiko, sobald `f` einen Sub-Katalog bekommt. |
| A36 | **KON25-06** | **130/152 aufgeschlüsselt:** 130 = `axes/`-Organ-Header; 152 = +22 `topics/queuing/`-Träger, die `algo_version` tragen, aber **keine** 
Organ-Achsen sind (fehlplatziert). |
| A37 | **KON26-01** | **SIMD-Meta-Meta ist GEBAUT, aber inert:** `SimdExternalUtilsFamily : SystemMetaMetaAxis` mit 17 static_asserts — *aber* `axis_kind()` 
meldet noch `system_config` (hinter O-8 verschoben) und der `ExternalUtilsHub` hat **NULL Konsumenten**; die real wirkenden `-mavx`-Flags laufen über 
`profile_run_facade.cpp`. |

### A-IV · Messung, Betrieb der Kampagne (Kapitel E/J)

| # | Anker | Substanz |
|---|---|---|
| A38 | **KON28-02** | 🔴 **HART/SOFT — Owner verbatim:** *„Die **Einstellungen der Achsen failen immer hart**, bis auf **fehlende Messeinrichtungen auf 
der Mess-Achsen-Kategorie (wie ein fehlendes PMC soft fail)**."* Hart ⇒ Messung der Binary scheitert komplett ⇒ T-15b-Retry-Klammer ⇒ danach `failed` in 
die Zelle. Soft ⇒ **Warnung in die xlsx, Binary WIRD gebaut**, Messung so weit es geht. **Im Kopf: nichts** — obwohl KON64/65 die PMC-Sondergrammatik 
ausbauen. |
| A39 | **KON26-04 / KON28-02** | 🔴 **Die 5 liegt FALSCH auf der Drift-Achse** (ce `4cd1ab91`) — Umzug + **8-Punkte-Ripple**; *„kritischste Stelle: die 
**Arena-Formel** muss den binaryweiten ×5 **zusätzlich** decken."* Nicht verwechseln: KF-10 `n_repeats=3` · Drift-`max_reruns` · T-15a. |
| A40 | **KON34-01/04** | 🔴 **ZWEI EINANDER UNBEKANNTE MESS-ARCHITEKTUREN.** System A (live, `#ifdef`-Gates in `abi_adapter.hpp`) vs. **System B (dormant, 
17 Dateien, 0 Produktions-Aufrufer)** — und genau **dort** lebt die 6er-Maschinerie. **B4 = System B umstellen + über den Builder instanziieren = „der 
fehlende Baustein *Steuerung → Compile*" aus KON10.** Der Kopf verbucht nur B2 als gebaut; **B1/B3/B4/B5 sind unsichtbar**. |
| A41 | **KON34-05** | **`--debug` und die Mess-Schalter sind STRENG DISJUNKT.** Das Flag *„darf alles beschleunigen und nichts umleiten"*; die Schalter 
**ändern Kompilat und Stempel**. Solange die Kette `--debug` fährt, **muss** die Mess-Schaltung davon unabhängig bleiben — sonst ist jedes Ketten-Kompilat 
anders bestückt als das Release-Kompilat. |
| A42 | **KON29-01/03** | 🔴 **Die Kampagne fährt das State-Pattern:** die **vier CacheEngine-Modi als PHASEN** über die Trägerstufen (Dossier 19 TEIL G: 
Mess- → Auswertungs- → Arbeits- → Hybrid-Modus). **Am Objekt: 0 Code-Treffer — das State-Pattern ist zu BAUEN**, nicht umzubenennen. Im Kopf steht 
davon nichts. |
| A43 | **KON29-01** | Die Debug-Doktrin ist die **einzige benannte Ausnahme** der Doktrin *„Messdaten werden NIE gelöscht"*: die ungenauen 
Debug-Messergebnisse werden beim Umschalten **gelöscht**. |
| A44 | **KON41-01** | 🔴 **Der OV-4-Deckel wird vom T−3-Fenster her kalibriert** (Bau + Messung ≤ ~2,5 Maschinentage zweilanig; finale Rechnung mit 
S-19-Zahlen). Der Kopf nennt T-3, **nicht** die daraus folgende Kapazitäts-Auflage. |
| A45 | **KON29-04** | 🔴 **DIE MESSUNG IST NICHT ZWEILANIG.** `measure:golden-320` ist global-exklusiv (`resource_group ceb-measurement-exclusive`, hart 
amd/prod1); die §61-Revision (`ceb-measure-<host>`, 21.07.) ist **bis heute nicht umgesetzt**, das Intel-Gegenstück fehlt. Zweite Lücke: `window_belongs_to` 
gebaut+getestet, **nicht verdrahtet**. Kapazität 4-Perm: prod1 20,7 h / **prod2 34,4 h (Engpass)**; **12-Perm nie durchgerechnet**. |
| A46 | **KON3-03** | 🔴 **XML-Wache: zwei Zweighälften nachweislich unbeobachtbar** (grep-Zweig braucht root; der Nenner-Mismatch-Mutant überlebt). 
**Owner-Frage „zulässig?" ist unbeantwortet** — eine offene Owner-Frage, die im Kopf nirgends geführt wird. |
| A47 | **KON4-03** | **Stage-Topologie-Lücke:** `test:unit` publiziert `ctest_unit_inventar.txt` **ohne Verbraucher**; `test:coverage-guard` liegt in 
**früherer** Stage als `test:unit` (`needs` darf nicht vorwärts zeigen). |
| A48 | **KON5-06** | 🔴 **Zwei divergente Fassungen der Diff-Hygiene-Wache** (ce 779 Z. `--bereich` · super 558 Z. `--seit-basis`/`--bestand`), gemeinsamer 
`--stdin`-Pfad **ohne Abbruch** — **vor dem main-FF misst die schwächere super-Fassung.** Direkt relevant für den offenen Posten #19. |
| A49 | **KON6-05 / S-16** | **Stehende Regression gegen C++/CMake-only:** 13–14 Shell-Testdateien (7.967→8.528 Z.) in `ci/tests` gegen 517 Google Tests; 
**ein `tr`-Shim (exit 127) ließ 5/5 Mutanten fälschlich als „gefangen" durchgehen.** |
| A50 | **KON22-01/7** | **D-1: `test:secrets` verlässt den prod2-CI-Job-Pool — Umsetzung UNGEPRÜFT** (Befund: 16 s grün auf prod1, 102 min Hänger auf 
prod2). |
| A51 | **KON44** | 🔴 **Die stille `n/a`-Falle:** nur **1 von 3 Gates** fängt provisionierte Zeilen ⇒ **eigener Wachen-Posten**. Dazu: 
**289-Writeback-Variablen FEHLEN** (Scrub-Klasse). |

### A-V · XML, Lager, Prüfling (Kapitel F/G/H)

| # | Anker | Substanz |
|---|---|---|
| A52 | **KON19-03** | 🔴 **EINE Einstiegs-XML (`main.xml`), REKURSIV** — referenziert andere XMLs als Teil-Experimente **oder volle Rezepte**; **jedes 
Paper = ein Experiment**; sequentiell, wenn in der main.xml gewünscht. *„Die XML Syntax bildet eine Programmiersprache."* |
| A53 | **KON21-02** | 🔴 **DIE WAHRHEITS-SCHICHTUNG:** *„der **Code** die Wahrheit für die **Freigabe** und die **XML** die Wahrheit für die 
**Realisierung** […] Es wird nur das eingebaut, was in der XML steht (**std::variant verboten**), daher entspricht jede Binary der XML Wahrheit und damit 
**nur einer Teilmenge des Codes**."* Registry wird **aus dem Code generiert** + Contract-Test. Im Kopf: **nichts**. |
| A54 | **KON30-02 / KON31** | 🔴 **DAS PRÜFLINGS-KONZEPT — das dritte Konzept neben Stufe und Phase.** Technisch eine **Mess-UNTER-Achse des Planers zur 
Laufzeit**, die *„in der CEB auch zu deren Laufzeit den Tier-Binary compiles freizugeben"* kommuniziert. Der Prüfling (PRT-ART) bietet **je Organ-Achse 
zusätzliche Algorithmen** an, *„im Prüfling verbucht und versioniert - **mit eigenem Stempel und allem**"*, XML-beschränkbar auf **1..3 Varianten**, 
**erweitert den Permutations-Satz**. Der Kopf führt prt-art nur als Repo-/Lizenz-/Waisen-Thema. |
| A55 | **KON30-02 / KON29-03** | Die drei `MergeStrategy`-Werte (`CeOnly` / `PrueflingReplace` / `FullJoin`) **SIND** die Prüflings-Verbund-Varianten; der 
künftige Bezeichner gehört zur Prüflings-Familie und wird **beim S-6-Fenster-Bau vorgeschlagen** (Golden-Byte-wirksam). |
| A56 | **KON32-01** | 🔴 **IST-VERSTOSS am measure-drop-Kanal, Owner verbatim:** *„Ich **genehmige hiermit ausdrücklich übergangsweise (a) bis wir (c) 
realisiert haben**, der **Kanal bleibt falsch und muss behoben werden wie definiert**."* **Zweifach** zu heilen: Ziel-Filter **UND** per-Binary-Format **xlsx** 
(der Code sendet `result.csv`, `iterator:3089-3093`). |
| A57 | **KON13-04 / KON15-05** | **Die Drei-Ziele-Struktur**, je per XML **separat** konfigurierbar; beide Caches müssen **S3 UND Filesystem** können. 
**Runner dürfen LESEN: NUR ccache auf `minio.comdare.de` + das neue Buildsystem-NAS** — *„Das ist mein letztes Wort dazu."* Ziel 3 = **NUR finale 
Zusammenfassung, LaTeX, PDF + explizit in der XML angeforderte Einzelnachweise**. |
| A58 | **KON12-03** | **S-17:** `LagerBaumWriter` hat **0 Produktionsaufrufer** (Gegenprobe `BuildOrchestrator` = 11) ⇒ **die Messdaten-Kaskade hat heute 
keinen Einsortier-Pfad**; setzt **O-9** voraus. |
| A59 | **KON3-06** | **Bestandslog-SKIP-Risiko:** je `binary_id` wird **ein** Eintrag mit leerer Zelle geschrieben, obwohl die ID über die ganze 
opt×simd-Matrix gebaut wird (**320 IDs bit-identisch**) — **ein SKIP kann falsch begründet sein.** |
| A60 | **KON27-02** | **Das Export-Element (Option b):** je FORMAT ein Eintrag FORMAT→ZIEL; bei LATEX zusätzlich **WAS**; der **PDF-Block referenziert LAZY 
die LaTeX-Konstruktion** und exportiert **mit den übrigen Kapiteln neben dem generierten Anhang**. |
| A61 | **KON23-03** | **VIER compile-time-gesicherte Rückschrieb-Methoden:** `Csv` · `LatexTable` · **`ComparisonMetrics`** · `Xlsx` 
(`kWritebackMethodCount=4`). **PDF liegt ausdrücklich außerhalb** der Rückschrieb-Achse. json/html/svg/png = **belegte Nullen**. |

### A-VI · Bau-Ordnung, Fristen, Owner-Regeln (Kapitel I/K/M + KON37–49)

| # | Anker | Substanz |
|---|---|---|
| A62 | **KON22 (Vollbau-Gate)** | 🔴 **VIER Bedingungen, wörtlich:** *„Wir bauen, wenn **Lagerhaltung fertig UND Stempel fertig UND Algorithmen 
versioniert UND Messung einbaubar**."* Das ist das **Gate vor dem Bau-Trigger Mi 26.08.** — im Kopf steht der Trigger, **nicht das Gate**. |
| A63 | **KON17-04 (die Rüge)** | 🔴 **Bau-Reihenfolge nach dem Stempel:** 1 Stempel · 2 **Planungs-Simulation** · 3 **von der XML die gesamte Kette bis 
zur PDF, von vorn nach hinten, mit allen Abzweigungen.** *„Nein das ist der Kern der Ablage, Opus 5 hat wieder still und heimlich alles ausgeklammert."* — 
S-13 ist **KERN**, ausdrücklich **nicht** post-Abgabe. |
| A64 | **KON30-03** | **S-19-Weg:** (1) Achsen **im Planer** zur Simulation **gruppieren und kategorisieren**, (2) über den **gesamten Experiment-B+-Baum** 
die tatsächliche Permutation **rechnen** — *„Abstufungen, die wir ohne Programm nicht abschätzen KÖNNEN."* B-4 bleibt Kandidaten-Liste, bis das Programm 
rechnet. |
| A65 | **KON11-01** | **ARBEITSPRINZIP:** konsolidieren → archivieren → **in der ZIELFORM aktivieren** — *nie eine vierte Fassung neben drei 
bestehende*. |
| A66 | **KON24-01/Q-f** | **S-14/S-18 sind BUILD-BLOCKER** (*„sonst ist der Build … unmöglich"*), **keine CI-Kosmetik**. |
| A67 | **KON42** | 🔴 **DIE DEFAULT-DOKTRIN:** Variablen werden **hart als Planer-Defaults einkompiliert**, die XML überschreibt. Dazu: **Hybrid zweiwegig 
XML-steuerbar** (statische Dock-Belegung **ODER** Synthese-Funktionen + Wirkbereiche). Der Kopf kennt nur den Dock-Deckel als „willkürlich". |
| A68 | **KON37-01** | **Die VERERBUNGSREGEL:** *die CEB baut höhere Stufen nur nach **eigenen** Messeigenschaften.* Wallclock-Merge: Freigabe **Planer** · 
Schalter-Hoheit **CEB** · Durchführung **im Vertrag**. |
| A69 | **KON37-03** | **Anordnungs-Freigabe** (F-C gedreht) — Gegenstand des Anordnungs-/Ordnungs-Freiheitsgrads je Stufe; im Kopf nicht auffindbar. |
| A70 | **KON39** | 🔴 **Die VIER `/goal`-Dokumente sind Haupt-Referenz:** GOAL-V8-Dossier · **Wellenplan §17** · **Designplan §10** · **ARBEITSWEISE 
v3.5-Vorlage**. Alle späteren Planungsdokumente werden **gegen sie** konsolidiert. Der Kopf zitiert nur den **Wellenplan §18** — die Referenz-Hierarchie 
selbst fehlt. |
| A71 | **KON38** | **Geltungsliste der Fable-5-max-Auflage:** S-1…S-7, S-14, S-18, B5, Flächen, Preimage, Versionierung — *„weil die Komplexität so 
hoch ist"*. (Beim Widerruf der Memory-Blanko-Regel ist **diese** Liste die Rückfallebene.) |
| A72 | **KON45 / KON47** | **Preimage-Budget-Bruch:** Preimage-Max **4096 zu heben**; Map-VALUE = **Tier-SHA statt Voll-Stempel**. **Comp-Gate-Schicht fehlt 
in ALLEN DREI Realms** (eigener Posten). **Warmup-PAAR** (verwerfen + speichern) ×3 = **6 Läufe / 3 Werte**, `--debug` 1× kalt, *„sonst IMMER zwei Mal"*, 
**Pflicht + testpflichtig**; Lücke = **prozess-kalter Erstlauf je Zelle (~2× teurer)**. |
| A73 | **KON22 / Kapitel K** | **Eigentum + Formales:** Thesis = **Benjamin-Elias Probst privat**, CacheEngine + PRT-ART = **BEP Venture UG / Marke Comdare**; 
🔴 **die Abkürzung „BEP" für die PERSON ist VERBOTEN.** **Prüfungsunterlagen** (8 Exposés, 3 PDFs mit Betreuer-Mailverkehr, Anmeldeformular) werden 
**mitveröffentlicht** — die PDFs tragen **Betreuer-Namen/@tu-dresden-Adressen**, gehört **vor dem Public-Release in die Release-Checkliste**. 
**Research-and-Teaching-Klausel bleibt.** |
| A74 | **KON22-02** | 🔴 **Backup-Ref-Löschung gestuft und terminiert:** stehen lassen → **nach der Lieferphase** rechtebeschränktes Bundle → **erst 
dann** Remote-Löschung mit ausdrücklichem, gegenstands-genauem GO. **KEINE Löschung vor der Lieferphase.** |
| A75 | **KON2-24/25** | 🔴 **Lizenz-Widerspruch am Objekt, ungeheilt sichtbar:** `ce/NOTICE` sagt „Apache 2.0", `ce/LICENSE` trägt die Dual-Lizenz; und 
der **fünfte Schalter** `COMDARE_CE_ENABLE_ORIGINAL_CODE_VALIDATION=ON` **kopiert bei jedem Configure GPL-3-Code (`wh.c`)** — **das Vier-Schalter-Gate deckt 
ihn NICHT.** |
| A76 | **Kapitel M** | 🔴 **Der Stunden-/Tage-Aufwand von S-1…S-21 steht an KEINER Stelle** — *„Termine unverändert" ist eine **Owner-Setzung**, 
keine abgeleitete Aussage.* Das ist der einzige explizit ausgewiesene Zeitplan-Vorbehalt im ganzen Kapitel. |
| A77 | **KON29-06 / Kapitel M** | 🔴 **R-1-Rest offen:** zum **AUSWAHL-Subsystem** (`measurement_tooling_registry` / `canonical_combo` / XSD `<combo>`, **18 
Dateien**) fehlt die **Fortführungs-Entscheidung** — KON34/B4 beantwortet nur die Ordnungs-Seite. |
| A78 | **KON20-04 / KON34-06(d)** | **Register-Lücken ohne Eigentümer:** K4 (`mess/`-Subsystem ohne S-Position) · **K5 drei Skelett-Testverzeichnisse seit 
06.07. ohne Eigentümer** · die **17-vs-18-Dateizählung** des System-B-Doppelbaus unaufgeklärt. |
| A79 | **Kapitel L (12 Lehren)** | Methodik-Kern, im Kopf nicht wiederholt: **(1) nach dem GEGENSTAND suchen, nicht nach dem Konsumenten** · (3) *„Der Plan 
ist keine Quelle über den Code, sondern eine **Behauptung** über ihn"* (5 von 5 Bauaufträgen am Objekt falsch) · (4) jede „existiert nicht"-Aussage 
trägt ein **Verfallsdatum** · (5) ein binäres `widerlegt`-Flag trennt „falsch" nicht von „fast richtig" (**9 als widerlegt markierte Verifikationen 
bestätigten den Befund**) · (12) **die Synthese braucht eine Titel- und Längen-Auflage**, sonst geht der Kopf beim Return verloren (zweimal passiert). |

---

## B. WIDERSPRÜCHE OHNE TRAGENDEN MARKER

**B-1 · Der Mess-Nenner: feste 32 vs. dynamisch > 32**
- *Segment (KON25-03, Kapitel E, Z. 5578-82, unmarkiert):* „**DER MESS-NENNER = 32** … TIER 4 } HYBRID 4 } 16 × CEB Wall-Clock 2 = **32**" und (KON25-03 
Schluss) „*Die Planungs-Simulation (S-19) bekommt damit ihren Mess-System-Faktor: **32 ist der Multiplikator der Mess-Dimension***."
- *Kopf (KON71):* „**DRITTE 32er-Rüge (Mess-Permutation DYNAMISCH >32, NUR S-19 rechnet)**"; KON65: „32er-Falle: Belegungs-Welt (2^5) **entkoppelt** von 
Dock-Zahl".
- Kapitel E trägt für den **Nenner** keinen ÜBERHOLT-Vermerk (nur für die Dock-Klammer, KON41-03). Die zentrale Nachschlage-Fläche behauptet damit weiter 
eine statische 32 als S-19-Multiplikator — genau das, was der Owner dreimal gerügt hat.

**B-2 · Arena: „Formel muss ×5 zusätzlich decken" vs. „6 GB FEST, STATISCH"**
- *Segment (KON26-04, Z. 6721-22):* „🔴 `checkpoint_speicher.hpp:119-123`: **die Arena-Formel (18 Durchläufe je Zelle) muss den binary-weiten ×5 
ZUSÄTZLICH decken — sonst UNTERDIMENSIONIERT**"; Kapitel E Z. 5603 wiederholt es als kritischste Ripple-Stelle.
- *Kopf (KON93):* „**C6 = ARENA 6GB FEST, STATISCH**, Planer-Reservierung zu Experiment-Beginn änderbar (10-Wochen-Explore läuft)."
- KON92 nennt zwar eine „Arena-Ketten-Karte (8 Deltas, 6 Überholt-Marker)", aber **kein Marker im Segment und keine Kopf-Zeile sagt, ob die ×5-Deckung 
durch die feste 6 GB erfüllt, ersetzt oder offen ist.** Bei T-15b-Umzug (#13) ist das entscheidungsrelevant.

**B-3 · Zweilanigkeit: Concurrency-Schema vs. „die Messung ist nicht zweilanig"**
- *Segment (KON29-04, Z. 6364-66):* „**DIE MESSUNG IST NICHT ZWEILANIG:** `measure:golden-320` ist global-exklusiv (`resource_group 
ceb-measurement-exclusive`, hart amd/prod1) — die **§61-Revision (`ceb-measure-<host>`, 21.07.) ist bis heute nicht umgesetzt. Intel-Gegenstück fehlt.**"
- *Kopf (KON73-F7):* „Drei-Bereiche-Concurrency (CI-normal 3/2 je 4 Kerne, **heavy 16**, ce floor((T-4)/4)×4, --debug T×1)" + „W3-Kampagne ab Sa 29.08."
- Das Concurrency-Schema setzt Mehrlanigkeit voraus; die Kapazitätsrechnung (prod1 20,7 h / prod2 34,4 h) setzt sie ebenfalls voraus. **Kein Marker sagt, ob 
§61 inzwischen umgesetzt ist.** Wenn nicht, fährt die W3-Kampagne einlanig auf prod1.

**B-4 · „KEINE YAML in der Kette" vs. die gesamte CI-DUAL-Strecke**
- *Segment (KON16-03/KON18-01):* „**Es gibt keine YAML** sondern der Planer emittiert direkt eine pipe oder Prozess … **Erlaubte Nicht-C++-Träger: NUR 
CMake**"; `CiYamlBuilder` bleibt **ausdrücklich nur „für den lokalen build außerhalb der CI"** (KON25-04).
- *Kopf (KON66/72/86 + Task #3):* „CI-DUAL alle Repos gebaut", „Workflow-Template-Fix (keine `${}`-Escapes)", S-12 = „je Trägerstufen-Mini-Pipeline 
gcc+clang × Release+Debug".
- Ungelöst: **emittieren die vier Trägerstufen-Mini-Pipelines GitLab-YAML (dann bricht KON16-03) oder Prozesse (dann fehlt der Bau-Posten)?** Kein Marker auf 
beiden Seiten.

**B-5 · `--debug`: „bis zur Abgabe" vs. „fällt bei T−3"**
- *Segment (KON28-01, Z. 6430/6433, unmarkiert):* Owner: *„**Das bleibt auch an bis zur Abgabe.**"* → „die Kette bis RELEASE fährt mit `--debug` — 
**BIS ZUR ABGABE (15.09.)**"; Kapitel E Z. 5632 wiederholt: *„da die Kette bis zur Abgabe --debug fährt"*.
- *Segment-Index KON37 (Z. 5316) + Kopf:* „**`--debug` fällt bei T−3**" / „T-3 ~Sa 12.09. = manueller Reset + ECHTE Messung".
- Die Auflösung existiert (KON37/KON41-01), **steht aber nur im Index und nicht am Ort** — KON28-01 und Kapitel E behaupten unverändert 15.09.

**B-6 · Change Date: 11.08.2031 vs. 10.08.2031**
- *Segment (KON22-01(2), Z. 7186-88):* „*C-2: Ja, cache engine nach 5 Jahren frei verfügbar ab heute*" → „**~11.08.2031**"; Kapitel K Z. 5837: 
„**FUENF JAHRE nach dem 11.08.2026** wird … frei (~2031)".
- *Kopf (KON60):* „**Change Date 10.08.2031**" (Task #56: „OF-1 FINAL **2031-08-10**").
- Ein Tag Differenz, in Lizenztexten wirksam; das Segment trägt keinen Marker.

**B-7 · Begriffskollision `FullJoin`**
- *Segment (KON30-02):* `FullJoin` ist eine der **drei Prüflings-Verbund-Varianten** (`CeOnly` / `PrueflingReplace` / `FullJoin`), XSD-`<phase merge=…>`, 
**golden-byte-wirksam**.
- *Kopf (KON91):* „ab ma-Ebene ALLE Parameter inkl. PMC = **FULL JOIN** der mi-Achsen-Erfolgs-Parameter".
- Zwei verschiedene Gegenstände unter demselben Wort, ohne dass ein Marker sie trennt — und die Prüflings-Variante soll laut KON30-02 **beim 
S-6-Fenster-Bau umbenannt** werden. Kollisionsgefahr genau im laufenden Bump-Bündel (#15).

**B-8 · Organ-Kanon: „T12/T17 bleiben unangetastet" vs. ORG-19 als required-Deklarant**
- *Segment (KON26-01):* „eine Festplatten-IO-Meta-Meta wäre ein **NEUER, ADDITIVER Typ** über der `OrganMetaMetaAxis`-Wurzel — **T12/T17 bleiben 
unangetastet**; ‚Umklassifizierung' wäre ein Neubau daneben."
- *Kopf (KON80-V10/KON91):* „ORG-19-IO = **erste Organ-Meta-Meta-Achse**, XML-opt-in, Genus-Interface **+store()/load()**"; „erste required-Deklaration = 
**Festplatten-IO/ORG-19**".
- Weich, aber offen: `persistence_target` (T17, heute **OFF** per Owner Q-1/Fall B) und ORG-19 überschneiden sich im Gegenstand; kein Marker sagt, ob T17 
neben ORG-19 bestehen bleibt oder aufgeht.

---

## C. ÜBERHOLT-BESTAND (nur Zählung + Kurzliste)

**Vom Segment selbst als überholt/gestrichen/korrigiert markiert: ≈ 28**
KON4-10 (Stempel-Riss) → KON5-01 · KON14-02 (S-6 pauschal falsch) → KON15-02/KON20 · KON7-06 (Komplexitäts-Leiter) → KON8-08 · KON16-09 (Stufe=Phase 
Synonym) → KON25-07 · KON9-04 (Grammatik-Zuordnung) gestrichen → KON13-03 · KON7-03 „3 für System" fällt → KON13-01 · R-4 „gerade Anzahl 
Prüfdocks" **gestrichen** (Vollzug an 6 Stellen) · KON34-03-Dock-Klammer + KON28-03-„Beobachtung" **„VÖLLIG FALSCH"** → KON41-03 · 
Wallclock-SOLL-Konflikt → **KON37-01 Merge** · `--dump-plan`-Flagwort überholt (Substanz bleibt) · Zwei-Flächen-Fassung KON7-01 → drei Flächen 
KON16-06 · Gen-1-CI-Matrix (§35/§36) DEPRECATED → Gen 2 · Hybrid-Autonomie-Zeitbezug korrigiert (KON36) · ce-Sequenz-Auflage KON44 → KON46 (stale 
Worktree-Refs) · Owner-Vorlage mit ÜBERHOLT-Kopf (V-5) · „ES SIND ZWÖLF" / 4!=24 / 24-vs-48 → **32** · 06.08.-Klärungsdokument STUFE/PHASE 
überstimmt · WF4-24/48-Aussagen (Zeitstand-Vermerk KON26-Kopf) · §69.6 „24 Worker" · KON16-10-Fragen 6/7 neu gestellt, O-6/O-7/O-8 gegenstandslos · 
Schnitt-2-Deckungslücke geschlossen (KON36-01) · KON10-01 „wörtlich" → „inhaltlich" · B-3 anders aufgelöst (KON13-04) · O-2 entfällt an 6 Stellen 
· P-0 blockierend → begleitend · **drei eigene Messungen widerlegt** (LagerBaumWriter-„0 Aufrufer", `algo_version`-Pflicht „nie gebaut", „7 vs. 9 
Marker") · KON3-02 prod2 (26 Tage blockierend) geschlossen · KON2-26 Prüfungsunterlagen-Frage geschlossen.

**Durch den Kopf KON60-93 / die Task-Karte erkennbar überholt: ≈ 14**
Nenner-32-Statik → KON71 dynamisch >32 · „8 von 9 thesis_profiles xlsx-blind" → 11 Profile / 0 xlsx-blind (#56) · ce rot `test:coverage-guard` → 
grün (#14) · MinIO-Keys → geheilt (#10) · Cache-Landschaft Drei-Orte → Ebenen A/B/C (KON66/67) · Meta-Meta-IO „additiver Typ" → ORG-19 (KON80-V10) 
· 6er-Maschinerie/Gate-Trennung → **B2 gebaut** (KON72/74) · F11-Prüfdockzählung → 32er-Falle (KON65/71) · Löschregel KON49 → Worktree-Remove-Wache 
(KON79/82) · OD-7 24→16 → heavy 16 (KON73-F7) · `--debug` bis Abgabe → T−3 · **V-1 `##25`-Durchstich ohne Besitzer → F1 GELIEFERT** (KON63) · 
KON19-00 Referenz-Konsolidierung → vollzogen (KON39/#9) · S-6-Sperre → **ENTSPERRT** (KON74, KON60-04 stale) · Kapitel-M-Eintrag „W-6 ungelöst" ist 
gegenüber KON37 („W-6 Zielzustand") **segment-intern stale**.

---

## D. TRAGENDE ARCHITEKTUR-KERNE DIESES SEGMENTS

1. **Vier Träger, und nur vier** (KON7-02): **Planer → CEB → Tier · Hybrid**; KON43: *„in der Reihenfolge und nicht anders"*, **vier 
Träger-Unterprojekte, N+1 hängt nur von N**.
2. **ORT ≠ ZEIT** (KON9-01/KON13): Ort = Planer→CEB→**Hybrid**→Tier, Zeit = Tier bauen → messen → Hybrid erzeugen → einschieben. **Aus dem 
ORT-Satz folgt KEINE Phasigkeit.** Tiefe 3; Tier und Hybrid **sequentiell auf derselben Stufe**, erst Tier.
3. **Phasigkeit** (KON13-01): MESS 3 (ohne) / **4** (mit Hybrid) · SYSTEM 2‖2 **parallel** · ORGAN 2. Der Hybrid ist Glied der **Mess**-Kette, *„weil das 
Hybrid nicht bauen kann, sondern nur Tier-Binaries messen, die schon gebaut sind"*.
4. **Vier-Parteien-Kette = zweimal dreistellig parallel** (KON13-02): *„Konzeptionell hat die CEB hier **2 dritte Phasen**, die sie als Kopf steuert, in der 
Anordnung des Ortes allerdings **4 Phasen**."* Vertrag entsteht **nur bei Dreiphasigkeit** (KON8-01); `MIN ⊆ implementiert ⊆ freigegeben` gilt **überall** 
(KON8-12).
5. **Die Emission** (KON16-03/KON18-01/KON17-01): **keine YAML** — *„der Planer emittiert direkt eine pipe oder Prozess"* über **ein zentrales Bau-Modul = 
eine C++23-Planer-Bibliothek** (Builder Pattern). **Anforderungsgetrieben:** Stufe N baut, was N−1 wünscht/anfordert/freigibt. **Nur der Planer wird direkt 
kompiliert.**
6. **Die Träger-Rakete** (KON25-08): *„wir brennen die Rakete nicht stufenweise ab, sondern bauen sie stufen weise **rückwärts** auf"* — jedes Modul ist 
nach dem Bau eigenständig und wird **ABI-stabil in die vorhergehende Stufe gesteckt**.
7. **Abschluss = Lager** (KON17-02): *„Die Emission ist abgeschlossen, wenn die angeforderten CEBs und Tier-Binaries und Hybrid **im Lager zu finden** 
sind."* ⇒ Stempel-Rollen 2+3 auf dem kritischen Pfad — und **beide sind heute nicht durchgesetzt** (KON13-06/C-3).
8. **Der Stempel, fünf Rollen** (KON9-11), **drei Flächen** (KON16-06): Genus-Interface · Stempel (Systemachse, Tools/Compiler) · measurement-Durchstich 
— Letzterer existiert *„damit wir die Gattung+Genus Funktionsinterfaces **nicht ändern** müssen"*. Er **fällt an** als Resultat der 
B+-Baum-Materialisierung (KON8-05).
9. **Wahrheits-Schichtung** (KON21-02): *„der **Code** die Wahrheit für die **Freigabe** und die **XML** die Wahrheit für die **Realisierung** […] 
**std::variant verboten** […] jede Binary [entspricht] nur einer **Teilmenge des Codes**."* Dazu KON19-03: **eine rekursive Einstiegs-XML**, *„die XML 
Syntax bildet eine Programmiersprache"*.
10. **Das Home-Prinzip** (KON27-01): *„jede Achsen-Kategorie [braucht] ihr eigenes home, für das unter der Stempel-Mechanik **genau ein Wächter** greift"* 
— Mess **dreiphasig**, System/Organ **zweiphasig** geprüft; **zweistufige Versionierung** (Achsen-Interface-Version **und** Algorithmus-Version); *„Wir 
beginnen aber zuerst mit einer **gültigen golden Version**."*
11. **Die zwei Flag-Seiten** (KON16-02): **Freigabe impliziert · Compile-Seite fordert**; dreiphasig zusätzlich der **Messfühler-Vertrag**. Beide Seiten 
**gebaut und inert** ⇒ S-3/S-7 sind **Aktivierungs**-Aufträge.
12. **Drei nie zu vermengende Konzepte** (KON25-07/KON29-03/KON30-02/KON31): **STUFE** = die Binary, physisch · **PHASE** = die vier CacheEngine-Modi 
(State-Pattern, **0 Code-Treffer — zu bauen**) · **PRÜFLING** = eigene Achse der Verbund-/Teststruktur, technisch **Mess-Unter-Achse des Planers zur 
Laufzeit**, die in der CEB die Tier-Compiles freigibt, *„mit eigenem Stempel und allem"*, XML-beschränkbar 1..3.
13. **Zwei Mess-Architekturen** (KON34-01): System A live (`#ifdef`-Gates), **System B dormant** (17 Dateien, 0 Produktions-Aufrufer) — dort lebt die 
6er-Maschinerie. Deren Umstellung (**B4**) ist *der fehlende Baustein „Steuerung → Compile"*. Die 6 zählt **Ordnungen einer ortsfesten Vollmenge**, die 32 
zählt **An/Aus verteilter Einrichtungen** — *„die CEB misst UM das Tier herum, das Tier misst IN sich."*
14. **Hart/Soft** (KON28-02): *„Die Einstellungen der Achsen **failen immer hart**, bis auf **fehlende Messeinrichtungen** auf der Mess-Achsen-Kategorie (wie 
ein fehlendes PMC **soft fail**)"* — soft ⇒ Warnung in die xlsx, Binary wird trotzdem gebaut.
15. **Zwei Betriebsstufen** (KON29-01): `--debug` jetzt (ungenau, schnell) → Umschaltpunkt *„sobald das System planmäßig steht und arbeitet"* → 
**ungenaue Ergebnisse löschen**, echt mit **1 Thread**. Die **einzige Ausnahme** der Doktrin „Messdaten werden nie gelöscht". `--debug` ist *„das Flag 
**quer** zum State Pattern"* und **streng disjunkt** von den Mess-Schaltern (KON34-05).
16. **Das Vollbau-Gate** (KON22): *„Wir bauen, wenn **Lagerhaltung fertig UND Stempel fertig UND Algorithmen versioniert UND Messung einbaubar**."*
17. **Die Bau-Reihenfolge nach dem Stempel** (KON17-04, die Rüge): 1 Stempel · 2 **Planungs-Simulation** · 3 **von der XML die gesamte Kette bis zur PDF, 
von vorn nach hinten, mit allen Abzweigungen** — S-13/Ablage ist **KERN, nicht Anhang**.
18. **S-19 gibt es noch nicht** (KON30-03): Achsen im Planer **gruppieren + kategorisieren**, dann über den **gesamten Experiment-B+-Baum** rechnen — 
*„Abstufungen, die wir ohne Programm nicht abschätzen KÖNNEN."* Bis dahin ist **B-4 eine Kandidatenliste**, keine Zahl.
19. **Lager und Cache** (KON13-04/KON15-05): drei Orte, **je per XML separat konfigurierbar**, beide Caches **S3 und Filesystem**; Runner lesen **nur** ccache 
auf minio.comdare.de + Buildsystem-NAS — *„Das ist mein letztes Wort dazu."* Im Lager gelten **zwei eigene Kaskaden** (D-12), außerhalb folgt die Ordnung 
**der Trägerkette**: *„Immer der vorangegangene Träger definiert die nächste Träger-Stufe, das ist dynamisch."*
20. **Das Arbeitsprinzip** (KON11-01): **konsolidieren → archivieren → in der ZIELFORM aktivieren** — nie eine vierte Fassung neben drei bestehende. Und 
die Konfliktregel (KON11-02): bei Widerspruch ohne Owner-Wort auf beiden Seiten **zuerst Explore auf Fehlinterpretation** — sie hat in KON13 **11 von 20** 
Widerrufen abgefangen.

**Segment-Datei:** `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`, Z. 5259–7900 (gelesen 
bis 8618).

==========================================================================================
## RESULT 3 (wf_750a0423-c46)
==========================================================================================

# GEGENLESE-KARTE — Segment Z13601–16626 (LEDGER-KONSOLIDIERUNG II, Teil 2)

**Anker-Hinweis:** Mein Segment trägt **keine KONxx-yy-Nummern** — es ist der Rohbestand der **Nachträge vom 09.08.2026 (spät/abends)**, den die 
10.08.-Konsolidierungen (KON1/KON2-Block ab Z11101/Z11899) oberhalb verdichten. Ich ankere deshalb mit **Datum + Nachtrags-Überschrift + Zeilennummer (Z…)** 
des Stands 29858. Alle Zeilen 13601–16626 gelesen.

---

## (A) LEBEND-ABER-IM-KOPF-UNSICHTBAR

### A-I — Achsen / Stempel / Identität (F2-relevant, Freeze Fr 21.08.)

**A1 · `work_mode` = Unter-Achse unter `measurement_category`, VIER States + EIN Flag — mit einem stempel-/ABI-relevanten Enum-Umbau** *(Z13694–13914, 
geltende Fassung; Herleitung Z13915–14094)*
Owner: *„die 5 Begriffe gehören zusammen, aber **Debug ist für normale Benutzer gesperrt**"* und *„Damit ist Debug **als Flag entkoppelt** … es 
beeinflusst zwar die **Ausprägung** der States, aber **nicht ihr Verhalten der Reihenfolge oder Abhängigkeiten**. Es ist also ein **CLI-Flag auf der 
Planer-Shell**."* Kette `build → measure → compare → release`, kumulativ, **Besitzer = PLANER (Director)**. Bau-Auftrag: **`Debug` VERLÄSST das Enum 
(heute Ordinal 0), `Build` tritt ein, `kWorkModeCount = 4`** — ein **lauter Ordinal-/Stempel-Bruch**, Registry-Zeile `{Build, "build", "Build", "Release", 
false, false}`, `kOffizielleWorkModeCount` entfällt ersatzlos.
→ Der Kopf kennt `--debug` nur als **Betriebsschalter** (KON71 zwei Mess-Klassen, W3-Generalprobe, #22 OD-7). **Der Enum-Umbau, die Registry-Zeile und die 
Achsen-Einordnung tauchen nirgends auf** — obwohl sie Ordinale verschieben und damit **vor** den F2-Identitäts-Freeze gehören.

**A2 · Die Debug-Sperre ist eine INTEGRITÄTS-Regel mit fertiger Sperrform im Haus** *(Z13762–13853, Z13884–13898)*
`debug` ist das einzige `work_mode`, das **misst und dabei parallel läuft**; Owner: *„Parallelisierung des Messens mit **MAXIMALER Thread-Zahl** … **egal 
wie genau die Messwerte sind** (Prüfer der Abweichungen der Messwerte-Jitter **schaltet Debug daher ab**)"*. Drei bindende Merkmale: **„in JEDER Factory"** 
(global, nicht je Station) · **maximal**, nicht bloß „nicht 1-Thread" · **Debug-Zahlen sind Ausschuss und dürfen NIE ins Messwertlager**. Sperrform 
existiert: `AdmissionStatus {Zugelassen, Gesperrt}` (`axis_error.hpp:169-178`, fail-closed), Prüfort `validate_profile.hpp` gegen die constexpr-Registry.
**Gemessene Lücke:** `grep -c 'RunMethodology' drift_detector.hpp` = **0** ⇒ die Debug-Ausnahme im Drift-Gate **existiert nicht** und gehört ins **selbe 
Paket wie T-15 + D4**. Im Kopf: kein Wort — bei einer `--debug`-Generalprobe ab 29.08. würde **jede** Debug-Zelle rot.

**A3 · Hybrid-Meta-Meta ist eine FAMILIE, nicht eine Achse — plus `<hybrid>`-XML-Schalter** *(Z13999–14015, Z14082–14083, Z14162–14167)*
Owner: *„weil es **multiple Reroute-Systeme** geben kann, müssen diese als **separate Meta-Meta-Mess-Achsen erweiterbar** sein"* ⇒ **je Reroute-Genus EINE 
`MeasurementMetaMetaAxis`**, alle in **derselben Mess-Zeile** (E2 vom 02.08.: *„dynamisch ans Ende der Kette in den bestehenden Zeilen angehängt"*; RF-7: je 
Achsen-Typ EINE Array-Zeile). Dazu ein `<hybrid>`-XML-Schalter **zu Experiment-Beginn, gleichrangig zu `<measurement_tooling>`**. Der Kopf führt PMC 
(KON64/65) und ORG-19-IO (KON80-V10) als Meta-Metas — **die Hybrid-Familie und der `<hybrid>`-Schalter fehlen**.

**A4 · Der IST-Stand der Mess-Achsen-Registry und die aufgelöste `binary_id="never"`-Spannung** *(Z14105–14116, Z14176–14196)*
`measurement_axis_registry.xml` (generiert) führt **drei** Achsen, **alle `binary_id="never"`, `stage="ct"`**: `measurement_category` (16 Bausteine) · 
`collector` (3: WallClock, ObserverSnapshot, Pmc) · `load_framework` (`measurement_meta_meta`, `sub_axis_label="workload"`). Die Datei benennt ihre Lücke 
selbst (`:59-60`): *„die 3 Mess-Modi Debug/Mess/Release existieren NICHT als Typen → nicht emittiert; erst nach ihrer **Typisierung als Mess-Unter-Achse** 
reflektierbar."*
**Tragende Auflösung:** *„`binary_id` identifiziert das **TIER-BINARY**. Mess-Achsen stehen dort NIE drin. Die 6 (bzw. 24) Varianten sind **CEB**-Binaries 
— ein anderer Gegenstand."* Wer beides gleichsetzt, *„käme auf einen Bump, der nicht anfällt"*. Im Kopf nirgends.

**A5 · E-1-Rekursions-Mechanik: Tiefe und Stufen-IDs stehen IM STEMPEL** *(Z15504–15513)*
Owner-Bauart des HEURISTIK-ADAPTER / Function-Interface-Reroute: *„compile-time transparenter Pass-through"* · *„für JEDE Gattung+Genus per google test 
bewiesen durchlässig"* · *„allein NICHT ansprechbar"* · Rekursion **baumförmig compile-time**, *„Mechanik = **Herunterzählen eines 
Rest-Tiefen-Integers bis 0**"*, *„Tiefe **bei 1 belassen, muss aber funktionieren**"*, **„Tiefe und Heuristik-Funktions-Stufen-IDs im Stempel ablesbar"**, 
*„formal **EINE Binary am Stück**"*. Zwei Stempel-Felder mit Owner-Wortlaut — im Kopf nicht verbucht, obwohl das Bump-Bündel (#15/#38a2) gerade der 
letzte Preimage-Schritt vor F2 ist.

**A6 · Stufen-Vererbungs-GESETZ + „System-Achsen sind final drei"** *(Z15696–15698)*
Vom Owner am 05.08. ausdrücklich **„GESETZ"** genannt: *„Mess ist 3-stufig, System und Organ sind 2-stufig"*, dazu *„Die System-Achsen sind final 
**drei**: `target_isa`, `operating_system`, `external_utils`"*, plus die Stufenzuordnung **Planer → CEB = System → Tier = Organ** (18./19.07.). Der Kopf 
trägt die 3/2/2-Formel nicht (nur Memory), und die „final drei" steht in Spannung zu KON64/65+KON72 (→ B4).

### A-II — Mess-Kette, Kanäle, Speicher

**A7 · K5: die VIERTE Mess-Ebene ist eine SPALTE, kein Kanal** *(Z15553–15572)*
Owner: im `checkpoint_measure` wird *„zusätzlich angegeben, **welche Tier-Binary** (exakter Stempel über deren statisches Interface) **für diesen 
Funktionsaufruf verwendet wurde**"* ⇒ **eine zusätzliche SPALTE in der Macro-Benchmark-Stufe**; *„**Es sind dann 4 statt 3, weil es ein weiteres 
Macro-Benchmarking gibt.**"* Und: **Overhead = Macro-Messung(Hybrid-Aufruf) − bekannte Einzel-Tier-Performance** — *„die eigentlichen 
Tier-Binary-Performance ist ja **VOR der Hybrid-Stufe bekannt**"*. Das ist die **operative Auflösung der Mess-Ebenen-Zählung** und fehlt im Kopf vollständig.

**A8 · SECHS STEUERDOCKS Planer↔CEB — zwei Rechtsakte, Sammel-Release** *(Z14784–14853)*
Owner: *„Damit hat der Planer **6 STEUERDOCKS** — für jede CEB einen, der **genau auf vorhandene einkompilierte Messeinrichtungen passt** und auch **nur 
bestimmte Steuerbefehle freigibt, die tatsächlich existieren laut Plan**."* Der Kanal trägt **zwei nicht austauschbare Rechtsakte**: **FREIGABE der 
System-Achse**, **DURCHSETZUNG der Organ-Achse**. Und eine Mess-Integritätsregel: *„Der **Release** kann nur unter Logging der CEB an den Planer auf die CLI 
des Planers vor oder nach der Gesamt-Messung **GESAMMELT** erfolgen"* — Senden **während** der Messung erzeugt genau die Latenz, die gemessen wird. Im Kopf: 
Docks nur als **Deckel 32** (KON71) — der Planer-seitige Steuerkanal fehlt.

**A9 · Die Kausalkette hinter dem fehlenden Mess-Kanal: EIN Defekt, fünf Stufen** *(Z14855–14921)*
Owner: die variadischen Mess-Template-Variablen werden *„**nicht über Gattung+Genus Interface per Metaprogrammierung durchgereicht** und **in die 
Genus-Implementierung hinter die Gattung+Interface Kaskade gebaut**"* ⇒ kein Signalkanal im Tier-Binary ⇒ **globale Init der zwei 
`checkpoint_measure`-Arenen geht nicht** ⇒ *„die CEB kann … keinen `flush()` der Messwerte (**je Arena getrennt**) beauftragen"* ⇒ am ABI-stabilen 
Prüfdock **können keine Signale gesendet werden**. **Es ist eine METAPROGRAMMIER-Lücke, keine Laufzeit-Lücke** — *„zur Übersetzungszeit oder gar 
nicht"*. Der Kopf trägt die Arena-Karte (KON92 E1-E10, KON93 C6) — **nicht** die Durchreich-Ursache und **nicht** das „flush je Arena getrennt".

**A10 · MeasureStorage: acht Owner-freigegebene Festlegungen — „volles GO, alles korrekt"** *(Z15143–15193, Z15194–15283, Z15630–15644)*
Owner: *„**Alle anderen Annahmen von dir: volles GO, alles korrekt.**"* Damit sind **Festlegung, nicht Vorschlag**: `mmap` statt `pmr`-**Typ** (der virtuelle 
`do_allocate` wird nicht gebraucht) · **lineares Append-Log statt Ring** · kein Lock im Hot-Path · **verifizierte Hauskonstante statt 
`std::hardware_destructive_interference_size`** (Clang: *„not stable between releases"*, flag-abhängig ⇒ *„Bei sechs CEB-Varianten … ist das 
**ABI-Risiko real, nicht theoretisch**"*) · **gezieltes `madvise(MADV_HUGEPAGE)` + Pre-Touch statt systemweitem THP** (systemweit löst synchrone Compaction 
genau im Messfenster aus — *„die subtilste Verzerrungsquelle des ganzen Entwurfs"*) · roh aufnehmen statt bucket-komprimieren · `ErgebnisMappe` als 
Konsument.
Owner zur Zweiteilung: *„`checkpoint_measure` hat also **2 interne Systeme — Mess-Arena und Stack-Arena, custom**"* — Mess-Arena 
APPEND/monoton/Auswertung zum Schluss; **Stack-Arena LIFO, hält nur Referenzen, ist ein Positionsanzeiger (Ebene · Modul · Funktion)**. Überlauf = **zwei 
Fehlerklassen** (Datenverlust vs. Programmierfehler), **getrennte Cachelines Pflicht** (sonst selbstgemachtes False Sharing im Modul, das False Sharing messen 
soll).
Harte Randbedingung: *„**neue Allokationen für die Messwert-Aggregation sind VERBOTEN, weil sie das Bild der Messungen verzerren**"*.
→ KON92/KON93 bauen gerade E1-E10 + 6-GB-Arena — **ohne dass eine dieser acht Festlegungen im Kopf steht**.

**A11 · Vier Bestands-Fallen vor dem MeasureStorage-Bau** *(Z15248–15266)*
`ThreadArena` und `InMemoryMeasurementBuffer` **sehen aus wie die Vorlage und verletzen genau die Randbedingung** (wer sie kopiert, baut den Defekt nach) · 
`LIFOStackBuffer` ist eine **Queuing-Achse des gemessenen Containers**, kein Mess-Aggregat · `IMeasurableWorkloadV3`/`ComdareSegmentLatencyV2` = **der einzige 
allokationsfreie Mechanismus im Haus, 0 Aufrufer in der Produktionskette** · **`csv_to_latex` ist KEIN totes Auslaufmodell** (großes aktives Modul mit CLI 
und mehreren Konsumenten) ⇒ Owner-Auftrag *„**csv_to_latex darf es nicht mehr geben, sondern measure_to_latex**"* bedeutet **Ablösung mit Migrationspfad, 
nicht Neubau auf grüner Wiese**. Im Kopf steht `04_csv_to_latex` **nicht einmal** in der F6-Repo-Rollen-Karte (#74).

**A12 · Die T-15-KOSTENZAHL: die Mess-Phase verdreifacht sich** *(Z15403–15410)*
> *„`reps=3` misst jede Zelle **DREIMAL** statt einmal. Zusammen mit der KF-10-Achse (`<repetitions count=3>`) sind das **9 Messungen je (Binary × 
Einstellung) statt 3**. **Die Mess-Phase verdreifacht sich** — die Bau-Phase nicht. Reruns kommen gedeckelt obendrauf."*
Trifft den Mess-Deckel (ETA ≤ 4,5 Maschinentage) und **muss in die `--check-size`-Rechnung**. Der Kopf lässt S-19 (#7, Sa 22.–Mo 24.08.) die 
Bau-/Mess-Zahlen rechnen — **ohne diesen Faktor 3**.

**A13 · Drei bewusst ungebaute T-15-Teile, davon zwei mit offener Owner-Frage** *(Z15411–15455)*
(1) **„ganzen Lauf neu starten" — die Granularität ist nirgends definiert**: Zelle / 4096er-Batch / Kampagnentag / gesamte mehrtägige Kampagne. Der 
Wiederaufsetzpunkt existiert bereits (Takeover über ETA+50 %, PromiseGuard-Release) — *„sobald die Granularität feststeht, ist das Bauteil klein"*. (2) 
**Retry einer als „failed" klassifizierten Messung** — *„beim Scheitern bis zu 5 Wiederholungen"* ist **zweideutig** (Drift-Rerun **oder** dritte, 
komplett ungebaute Achse; im ganzen `perm_runner`-Pfad gibt es dafür keine Schleife). (3) `chaos:drift` baut heute nur `test_chaos_drift_gate`; **T-15 ist 
kein eigenes CI-Gate**. Im Kopf: nichts davon — obwohl W3 ab 29.08. fährt.

**A14 · LAG-P2 ist NICHT scharf — die Restliste steht konkret da** *(Z16487–16503)*
Bauer wörtlich: *„Ich habe die **Erreichbarkeit** hergestellt und die **Semantik** bewiesen, **NICHT die Wirkung**."* `mess_bestandslog_active` bleibt im 
Produktions-Lauf **false**. Fehlend: drei Deklarationen in `super Code/02_messung_driver/main.cpp` (~:1112-1114), die Belegung im gegateten Zweig, drei 
`pa.*`-Durchreich-Zeilen (~:1349-1351) — **und eine neue Variable `COMDARE_BESTANDSLOG_MESS_DOC_KEY` in die Forward-Liste des Planers** 
(`experiment_plan_director.hpp:1008-1011`), *„weil dynamische Child-Pipelines globale Parent-Variablen **nachweislich nicht erben**"* (belegt an Serie-E2E 
11562/11566). **#57 (Lager-Vollausbau, W2-Pflicht) führt diese vier Punkte nicht** — sein Punkt (4) ist die Teilprojekt-Commit-Skip-Logik, ein anderer 
Gegenstand.

**A15 · Tier-Binaries werden nicht vorgehalten** *(Z14289–14329)*
Owner: *„die **Tier-Binaries NUR direkt im buildsystem cache landen** … weil **die Maschine den Speicher nicht vorhalten kann**, sie werden also auf prod1 
und prod2 nur **hot in den RAM gecached und dann verworfen nach der Ausführung**."* Folgen: **die Lagerhaltung lagert MESSDATEN, nicht Binaries**; der 
Buildsystem-Cache ist die **einzige** Persistenzstufe; die Zwei-Maschinen-Abstimmung betrifft die **Zuteilung von Batches**, nicht das Verteilen fertiger 
Binaries. (→ Spannung B3.)

**A16 · `delete_p99_ns` existiert 0-mal (D5-4)** *(Z16613–16614)*
`serialize_abi_tier_trace_json` emittiert für `delete` **nur p50 und p95**, während `write` und `read` je p50/p95/p99 tragen. Eine durchgängige Lücke in 
der Mess-Emission, die jede p99-Auswertung über Löschoperationen leer laufen lässt. Im Kopf nicht verbucht.

### A-III — Kette, Lager, Hybrid

**A17 · Die Kette hat FÜNFZEHN Stationen, nicht acht** *(Z14663–14729)*
Owner wörtlich: *„nach auswerten kommt erst **single bauen → single messen → single compare → single release optimal Tier-Binary für JEDE gemessene 
Last der Mess-Achse** → **Hybrid-Tier-Binary … bauen → messen → compare → multi release**"*, und: *„Die Strategien für single und hybrid verwenden 
also **exakt dieselben stateful design patterns und Abläufe der Entwicklung**, aber **wir müssen erst für jede Last das optimale Tier-Binary kennen**."* 
Vier Konsequenzen: **COMPARE ist eine eigene Station, zweimal** · **RELEASE heißt „das Optimum je Last", nicht „veröffentlichen"** · der Hybrid-Zweig 
ist **nicht vorziehbar und nicht parallelisierbar** · **die Mess-Achse liefert den Nenner des single-Zweigs** („für JEDE gemessene Last" = eine prüfbare 
Zahl). Der Ledger notiert ausdrücklich, dass die Stationsliste der laufenden Inventur **unvollständig** ist. Im Kopf und in der Memory-Kurzform lebt noch die 
**8-Stationen**-Fassung.

**A18 · K1: der Lagerbaum bekommt ZWEI NEUE WURZELEBENEN — für ALLE Gattungen und Genera** *(Z15517–15542, Z15700–15718)*
Owner: *„**Binary-Ordner und Messung-Ordner branchen unter Gattung → Genus → Binary/Messung → REST wie gehabt.**"*
```
Gattung → Genus → Binary  → System → Organ → Mess     (Binaries-Zweig)
Gattung → Genus → Messung → Mess   → System → Organ   (Messdaten-Zweig)
```
Die Verzweigung Binary/Messung sitzt **UNTER** Gattung→Genus. *„Das ist kein Einwand gegen den Entscheid, sondern die Ansage, dass **K1 mehr kostet als die 
eine Zeile in `lager_pfad_grammatik.hpp:527`**"* — Pfad-Grammatik, Tests und Wachen müssen mit. **#57 (Lager-Vollausbau) nennt diese zwei Wurzelebenen 
nicht.**

**A19 · Hybrid delegiert Tier-Bau und -Laden IMMER durch die CEB — und braucht Standard-`compare→release` vorher** *(Z15482–15494, Z15681–15685)*
Owner (OV-13): *„der **Release wird natürlich VOR der Anwendung der Hybrid-Stufe** mit einem einzelnen direkten Tier-Binary am Prüfdock **getestet und 
bewiesen**, bevor wir überhaupt den Hybrid an die CEB Prüfdock dran hängen. **HY braucht also Standard compare→release durch die CEB.**"* Verwaltung: 
**die CEB** über *„statisches init zu Beginn"* + *„Übertragung der Verhaltens-Heuristik-Funktionen bei Verwendungsbeginn"* am Prüfdock. Dazu K2: der 
Loader wandert in eine **stufen-neutrale Bibliothek**, *„weil das Prüfdock der CEB und das Prüfdock der Hybrid-Tier-Binary jeweils **technisch identisch 
bei Konfiguration** sein müssen"*. Im Kopf: #57 nennt nur „(3) Hybrid-Push-Pfad (heute unbelegt)".

**A20 · Zwei unvereinbare Definitionen von „beste Binary" — der Fork ist real und ungelöst** *(Z16005–16008)*
`best_binary_selector` (1104 Zeilen, zwei grüne ctest, empirisch gegen echte Mess-CSV gelaufen) kürt **einen globalen Sieger je Metrik, gemittelt über alle 
Lasten** — **F8 verlangt einen Sieger JE Eingangslast, mehrere gleichzeitig**. Dazu **E-5, der teuerste ungefällte Entscheid**: *„welcher der drei 
Kurven-Stacks ist kanonisch? **Ohne Entscheid entscheidet der Aufräumpass §75 implizit** — und dann ist die Wahl getroffen, ohne dass jemand sie getroffen 
hat."* (1802 Zeilen Kurven-Synthese über drei parallele Stacks, **null Produktions-Konsumenten**.) Task #21 bucht E-1…E-4c als erledigt — **E-5 ist 
nirgends beantwortet**.

**A21 · K4 wurde nie gefragt — ich habe es durch E-1 ersetzt** *(Z15076–15090)*
Label **K4** gilt laut Design-Dokument seit 02.08. als **ENTSCHIEDEN** (Systemachsen-Framing); das Konformitäts-Register vom 09.08. führt **dasselbe Label** 
als **ungeklärt**, für einen Gattung-gegen-Stufe-Konflikt, der **nirgends ausformuliert** ist. Der Plan fordert *„klären, nicht glätten"* — *„Ich 
habe es geglättet … **K4 wurde nicht einmal gefragt**."* **K4 gehört getrennt von E-1 auf die nächste Owner-Vorlage** und taucht im Kopf nicht auf.

**A22 · `--check-size` ist Vorbedingung der Messplanung, und die Mengenfrage ist per Konstruktion unbeantwortbar** *(Z16020–16031)*
Voll-Matrix ungedeckelt **≥143 Maschinentage** einthreadig (Untergrenze); Deckel **4,5 Maschinentage = 3,1 % davon**. **HY-B steht laut OV-4 außerhalb des 
Deckels und ist unbeziffert**; kein Dokument nennt #Lastprofile oder k je Profil. *„Ehrliche Antwort: unbeantwortbar, bis `--check-size` existiert und EIN 
HY-B-Punkt gemessen ist."* Der Kopf kennt die `check-size`-Lücke (KON73-Explore-Karte) — **nicht** diese Zahlen und **nicht** den unbezifferten HY-B-Rest.

### A-IV — Doktrinen, Zählwerke, Wachen

**A23 · „Wir streichen nichts" — die Beweislast ist umgekehrt** *(Z14330–14366, Z14381–14401, Z14501–14504)*
Owner 09.08. 10:23:05 UTC: *„Ja, **wir streichen nichts und können uns das auch nicht leisten.** Wir parallelisieren disjunkte Arbeit wie in der 
Arbeitsweise beschrieben."* Und: *„der **Wellenplan steht und gilt**, er wird **höchstens durch mich geschärft**, aber das **Fundament bleibt stehen**."*
**Praktische Regel:** *„ein Posten verlässt den Plan nur mit einem **zitierbaren Owner-Satz zum Gegenstand** — nicht mit einer OV-Nummer, nicht mit einer 
Empfehlung, nicht mit Zeitdruck."* Was ausdrücklich **steht**: Wellen W-1…W5, die **Reihenfolge-Zwänge** (D1e vor D1b · D3-7 vor allen D3-Gates · D4a/b 
vor D4c · D5-1 vor jedem ernsten Messwert · HY-A→HY-B→HY-C), der **Verifikationsvertrag V-1…V-8**, der TDD-Vertrag T-1…T-9, die Abnahme-Regel, die 
fünf Prüfungen, der Stellvertreter-Begriff, die Nenner-Pflicht. **V-1…V-8 kommen im Kopf nicht vor** (die dortigen V1–V10 sind Owner-Vorlagen aus KON80 
— eine gefährliche Namenskollision).

**A24 · OV-Nummern sind kein Autoritätsbeleg — der Mechanismus, der falsche Wahrheit erzeugt** *(Z14434–14449)*
Belegt: „OV-18" im Wellenplan v2 ist ein **anderes** OV-18 als das konsolidierte OV-18 im Ledger. *„Über diese Kollision kann ein »OV-x bestätigt« 
**wahr aussehen**, obwohl der Owner zu diesem Gegenstand nie befragt wurde."* Und *„Owner-KERN 1 sagt wörtlich »SPEZIFIZIERT, NICHT GEBAUT«"* hat in 
**beiden** Transkripten **0 Owner-Treffer**. (In Memory als Regel vorhanden — im Kopf nicht.)

**A25 · Owner-Direktive 17.07.: Fehlerklassen sind PFLICHT — Stand 0 von 18 bzw. 0 von 121** *(Z14455–14460)*
Verbatim: *„**Fehlerklassen und Behandlung sind für alle Achsen → Unterachsen → Algorithmen Pflicht.**"* Kettenwirkung: ohne Fehlerklassen **reißt ein 
Hardware-/Compile-Fehlen im Messfenster die Pipeline, statt klassifiziert weiterzumessen** — *„MESSEN wird nicht leer, aber genau dort fragil, wo der Owner 
Schutz angeordnet hat."* T-13/T-14. Im Kopf: nichts.

**A26 · Der 2D/3D-Graphen-KERN (06.08. 05:44 UTC)** *(Z14411–14414)*
Owner: *„eine Heatmap ist vielleicht nicht die geeignete Form, wie machen das die anderen Paper? Orientiere dich daran und **verwende 2D und 3D Graphen**."* 
Die F-07b-Streichbegründung („Tabellen tragen die Aussage") war **wörtlich die Position, die dieser KERN korrigiert hat**; „Streichkaskade bestätigt" 
ist **erfunden** (6 Treffer, alle Agent-Text). Kettenstation **VERÖFFENTLICHEN**. Der Kopf trägt nur die Marker-Setzung (#49-C2), nicht den KERN selbst.

**A27 · `prod2` wird umbenannt — ein Byte-Ereignis, das ein Bump-Fenster braucht** *(Z15650–15651)*
Owner-Kleinentscheid: *„Ja umbenennen"*, weil es dauerhaft so bleibt. **Der Registry-Generator spiegelt den Namen** ⇒ *„in ein Fenster legen, in dem 
ohnehin ein Bump ansteht"*. Mit F2-Freeze am 21.08. und dem Bump-Bündel in W1 ist das **jetzt** das Fenster — im Kopf steht davon nichts.

**A28 · Das Konformitäts-Register: 256 Aussagen, 17 % erfüllt, +1564 h Nachfund** *(Z15887–15977, Z16291–16396)*
| | | |
|---|---|---|
| ERFÜLLT | 44 | **17 %** |
| TEILWEISE | 118 | 46 % |
| NUR_PAPIER | 65 | **25 %** |
| VERLETZT | 22 | **9 %** |
| NICHT_PRÜFBAR | 7 | 3 % |

Kettenmuster: erste 87 Aussagen (XML/Planer/CEB) **23 %**, die vier hinteren Stationen **14 %** — *„je weiter hinten in der Kette, desto weniger 
Realität"*. Aufwand: **~770 h** (erste Messung) **+ 1564 h** (Stationen 5–8). Der Kopf führt als Fortschrittsmaß nur **KON82 (51/51 Posten verortet, 
VERLUSTLISTE LEER)** — ein **anderer Gegenstand** (Posten statt Aussagen). **Eine Nachmessung dieses Registers ist im Kopf nirgends belegt.**

**A29 · Die aufgehobene Streichliste ist eine Liste lebender Bau-Posten** *(Z16345–16360)*
Da die Streichung als Ganzes aufgehoben ist (A23), sind diese neun **Bau-Posten**, nicht Erledigtes: CEB-27 **Arbeitsmodus/Hot-Switching im RAM** (−40 h) · 
CEB-43 + Post-v3 `.so`/`<modules>`-Schnitt (−64 h) · CEB-12 Wallclock-Vollausbau (−28 h) · CEB-34 Release-Rekonstruktion (−24 h) · CEB-18 P/E-Core 
(−16 h) · CEB-20 L2/Kohärenz (−12 h) · **Paper-XML: Generator für 33 statt 3 Referenz-Paper** (−22 h) · Compiler-Unterachsen-Toolchain-Permutation 
(−12 h) · CEB-19 Pinning-Kette (−10 h). Der Kopf führt nur **P/E-Core → W7** (#21) und **P7 Paper-Isolations-Modus** (KON77) — **sieben der neun 
fehlen**.

**A30 · Blockierende Entscheide vom 09.08. ohne Kopf-Spur** *(Z16388–16396)*
**D-5 (Bau- gegen Mess-Menge)** — *„der Bestand widerspricht sich hier selbst: Owner-Entscheid D-3 sagt »Bau folgt Mess«, die 08.08.-Aussage sagt 
»größerer Bau-Satz, Teil davon messen«"* · **CEB-38 (CEB-Änderung = Vollrebuild ja/nein)** · **CEB-Identität A/B** · 
**`std::variant`-Fehlerklassen-Ausnahme** · **Wallclock-Schichtzuordnung** (letzteres per KON60-(iii) gelöst). Die ersten vier sind im Kopf nicht auffindbar.

**A31 · Bündel operativer Wachen und Fallen ohne Kopf-Spur** *(diverse)*
- **Nenner einer Pipeline = `/jobs` UNION `/bridges`** — *„Wer nur `/jobs` zählt, misst strukturell zu wenig"*; und der super-Trigger fährt `branch: 
main`, **nicht den vendorierten Stand** (`super .gitlab-ci.yml:1002-1005`) *(Z13641–13693)*.
- **`libs/` sieht sich selbst NIE mit `-Wall`**: `COMDARE_set_default_warnings()` hat **genau EINEN Aufrufer** (`COMDARE_add_test`) ⇒ 0 von 16 
Bibliotheks-Komponenten mit Warnstufe, Kompilierzeile `-O3 -DNDEBUG -std=c++23`, sonst nichts. *„Die Bau-Jobs melden 0 Warnungen nicht, weil der Code sauber 
ist, sondern weil **niemand hinsieht**"* *(Z14544–14557)*.
- **Offener Defekt D2**: `result_aggregator.hpp` — `fingerprint` ohne Initialisierer, Copy-Konstruktor liest den unbestimmten Wert (UB); **der beißende 
Köder fehlt noch, ausdrücklich offen** *(Z14578)*. Ebenso `axis_filter_bloom.hpp:111` (verdecktes `kHashes` ⇒ **stille Divergenz in einem 
Mess-Algorithmus**, sobald k ≠ 4).
- **Zwei überlebende `allow_failure`-Stellen in ce**: `is_original:relock` (geklärt, kein Verstoß — `when: manual` ohne `allow_failure` setzt die Pipeline 
auf `blocked`) und **`build:arm64-smoke` (`:231`) mit Ablaufdatum im Kommentar: *„advisory bis #179-Bereinigung, danach HART"*** *(Z13634–13640)*.
- **Registrierungs-Wache fehlt**: *„wird der Proben-Job selbst gelöscht, läuft die Probe nicht mehr und **kann ihre eigene Abwesenheit nicht melden**"* ⇒ 
zweite, unabhängige Wache über alle `ci/tests/*.sh` gegen die `.gitlab-ci.yml`. Und: **vier von fünf CI-gerufenen Wachen haben weiterhin keinen Selbsttest** 
*(Z16172–16175, Z16215)*.
- **`|| echo "…kein Fehler"` an ALLEN DREI CI-Aufrufstellen von `appendix_generator_cli` schluckt JEDEN Exit-Code** — *„grün über nichts", diesmal im 
Anhang-Pfad* *(Z15267–15271)*.
- **`AF_CORPUS_ROOT` zeigt ins Leere**: Default `measurement` existiert am Repo-Root nicht; der getrackte Korpus liegt unter `docs/architektur/measurement/` 
(18 Dateien, **8 im Archivformat `<stem>.result.csv`**); `.gitlab-ci.yml:1524` setzt denselben toten Wert *(Z16254–16262)*.
- **ZWEI PARSES, EINE ENTSCHEIDUNG**: `profile_run_facade.cpp:605` und `profile_run_entry.hpp:948` lesen dasselbe Profil zweimal — *„Driften sie, läuft 
die Perm-Schleife **ohne `compile_for_perm`**"* *(Z16126–16129)*.
- **gitleaks-Falle**: auf dem Submodul-Gitdir „0 commits scanned", **rc=0** (relatives `core.worktree`, git bricht mit 128 ab, gitleaks meldet trotzdem 0) 
— *„ohne die Commit-Zahl in der Ausgabe wäre das nicht aufgefallen"* *(Z15336–15339)*.
- **Token-Hygiene**: drei 0600-Dateien mit Zugangsdaten-Charakter im gemeinsamen Scratch (`.tok` 51 Byte = **exakt die Länge des gültigen PAT**), bis drei 
Tage alt ⇒ Regel *„nach jedem Vault-Zugriff sofort `shred -u`, beim Sessionwechsel Scratch gezielt absuchen. **Finder meldet, Lead schreddert.**"* Plus: 
*„vor jedem Vault-Zugriff erst `push --dry-run`"* *(Z15351–15368, Z15092–15100)*.
- **Vendoring-Prüfregel**: den vendorierten Stand **immer** per `git ls-tree HEAD <pfad>` / `git submodule status` lesen, **nie** per `rev-parse` auf einen 
Tracking-Ref im Submodul (kostete eine 85-Commit-Fehleinschätzung) *(Z15843–15849)*.
- Weitere stille Nullen: `Code/**/tests/`-Pathspec (0 Treffer, Exit 1, keine Meldung) · `clang-format` auf `.hpp.in` ohne `--assume-filename` meldet **84 
statt 20** Abweichungen · Biss-Nachvollzüge brauchen eine **frische Vollkopie**, sonst *„stirbt der Mutant an der falschen Ursache"* *(Z15863, 
Z15107–15110)*.
- **`measure_selection` = 0 Treffer im ce-Baum, obwohl Paket #11 als erledigt geführt wird** — ausdrücklich als eigener Prüfposten notiert 
*(Z14207–14209)*.
- **`docs/termine/` wurde nie als Posten eingereiht** (`.docx`/`.pptx` nie durchsucht) *(Z15125–15129)*.

---

## (B) WIDERSPRÜCHE ZUR KOPF-REFERENZ (ohne tragenden Marker)

**B1 · Die Permutations-Nenner 6 / 24 / 48 gegen „dynamisch >32, nur S-19 rechnet"**
- **Segment** *(Z14220–14288)*, Owner verbatim: *„durch **4 Messebenen mit der Hybrid-Struktur** auch **4 fakultät** auch **3 fakultät CEB Systeme** … 
es gibt also **4 fakultät Rekombinationen gegen die 6 CEBs**"* — dazu: *„Die 6 fallen nicht weg; sie sind der Bezugspunkt, gegen den die 24 gemessen 
werden"* und *„sie ist **gesetzt, nicht abgeleitet** — und wird so umgesetzt"*. Ausdrücklich offen gelassen: **24 oder 24 × 2 = 48**.
- **Kopf**: KON71 — *„DRITTE 32er-Ruege (**Mess-Permutation DYNAMISCH >32, NUR S-19 rechnet**)"*; KON64/65 — *„32er-Falle: Belegungs-Welt (2^5) 
entkoppelt von Dock-Zahl"*.
- **Kein Marker verbindet beides.** Offen bleibt, ob 3!/4! heute noch als Nenner gelten oder ob S-19 sie ersetzt — und ob die 24-gegen-48-Frage damit 
gegenstandslos ist oder noch dem Owner gehört.

**B2 · Wie viele Mess-Ebenen sind zu messen — drei, vier oder fünf?**
- **Segment**: *„Der Satz »**vier gemessen, fünfte spezifiziert**« ist **gegenstandslos** — **es sind fünf zu messen**"* *(Z14763)*; zugleich *„3 
Ebenen ⇒ 3! = 6 … ob die Hybrid-Ebene auf 4 hebt, ist die Frage"* *(Z13911–13913)*; und K5: *„**Es sind dann 4 statt 3**, weil es ein weiteres 
Macro-Benchmarking gibt"* *(Z15562)*.
- **Kopf**: durchgängig **w / ma / mi** als die Mess-Ebenen (KON80-V7 *„Break-Even NUR über Organ-Parameter der **w/ma/mi**"*, KON71 iw/ima/imi-Tokens), 
PMC als **eigenständige dreiphasige Meta-Meta-Achse** (KON64/65) — also drei + Meta-Meta.
- **Drei Zählungen, kein auflösender Marker.** Die im Segment als „gegenstandslos" markierte Formel ist die einzige Stelle, die **fünf** sagt.

**B3 · „Die Lagerhaltung lagert MESSDATEN, nicht Binaries" gegen den gebauten Binaries→Lager-Pfad**
- **Segment** *(Z14297–14315)*: *„**Kein Vorhalten auf Platte.** Das ist keine Optimierung, sondern eine Kapazitätsaussage"* · *„**Die Lagerhaltung 
lagert MESSDATEN, nicht Binaries.** … Wer den Lagerbaum als Binary-Archiv liest, plant Platte ein, die es nicht gibt."*
- **Kopf**: KON67 *„Lager=NAS-Wahrheit"*; #48 *„(1) **Binaries→Lager GEBAUT** (lager_baum_writer, Dual-CCache Default MinIO)"*; #49 *„Staffelung 
Owner-verankert: **Binaries+Lager** VOR Darstellung"*; A18 (K1) verlangt sogar einen **Binaries-Zweig** unter Gattung→Genus.
- **Auflösbar** (der „Binaries→Lager"-Pfad könnte genau der Buildsystem-Cache sein) — **aber kein Marker trägt die Auflösung**, und die 
Kapazitätsaussage („die Maschine kann den Speicher nicht vorhalten") gilt unverändert.

**B4 · „Die System-Achsen sind final DREI" gegen die gewachsene System-/PMC-Landschaft**
- **Segment** *(Z15696–15698)*: Stufen-Vererbungs-**GESETZ** (05.08.) — *„Mess ist 3-stufig, System und Organ sind 2-stufig. Die System-Achsen sind 
**final drei**: `target_isa`, `operating_system`, `external_utils`."*
- **Kopf**: KON64/65 *„PMC = **EIGENSTAENDIGE** dreiphasige Meta-Meta-Achse … F2 Planer-HW-Erkennung NUR für PMC, **System-Achse=Proxy**"*; KON72 
*„**F-P7=A cpu_sub**"*, *„**doppelte HW+SW-Versionierung**"*; KON71 *„OS-Realm-Doktrin"*.
- Die 3/2/2-Formel wird im Kopf nirgends bestätigt oder aufgehoben; die Zusatz-Achsen sind mit „final drei" nicht vereinbar.

**B5 · OV-10 „max. 4 erreichbar" gegen die sechs Steuerdocks — im Segment offen, im Kopf nicht geschlossen**
- **Segment** *(Z14841–14852)*: OV-10 führt die CEB-Varianten als *„Teilmengen-Lesart (**max. 4 erreichbar**), Abnahme: 4 + belegte Begründung warum 
nicht 6"* — *„**Dieser KERN nennt 3! = 6**, als Zahl der Steuerdocks."* Zwei Lesarten, **„Vorlage, keine Entscheidung meinerseits"**.
- **Kopf**: keine Spur von OV-10, keine Steuerdock-Zahl. Der Konflikt steht **unverändert offen** und hängt an der Bump-Frage im Freeze-Fenster (*„der 
Gate-Modell-Umbau fällt doch an, mit Bump-Folge"*).

**B6 · Der K5-Dock-Default 32 „IMMER in der XML" gegen „die einzige feste 32 = willkürlicher Dock-Deckel"**
- **Segment** *(Z15553–15558)*: Dock-Anzahl = *„so viele, wie die **gemessenen Break-Even-Grenzen im Standard-Einzel-Release** und **deren Überschnitte 
für Hybrid-compare** ergeben — mit einer **Obergrenze, die bei Hybrid-Anforderung IMMER in der XML stehen muss**, Default **32**."*
- **Kopf**: KON71/Memory — *„die einzige feste 32 = **Dock-Deckel (willkürlich)**"*; KON80-V7 grenzt Break-Even **auf Organ-Parameter der w/ma/mi** ein.
- Die Herleitung („gemessene Break-Even-Grenzen") und die Bewertung („willkürlich") stehen unversöhnt nebeneinander; V7 verengt die Break-Even-Ebene, 
ohne K5 nachzuziehen.

---

## (C) ÜBERHOLT-BESTAND (nur Zählung + Kurzliste)

**Vom Segment selbst markiert: 16 Stellen.**
1. work_mode-Erstfassung „fünf Enum-Werte, `kRunMethodologyCount` 4→5" (durchgestrichen, Z13714)
2. §62-C insoweit superseded durch O-A (Z13986)
3. Streichliste ~228 h **als Ganzes** aufgehoben (Z14330/14501)
4. `checkpoint_measure`-Streichung nach W7 **zurückgenommen**; Wellenplan §7 an dieser Stelle **überholt** (Z14730/14782)
5. „vier gemessen, fünfte spezifiziert" **gegenstandslos** (Z14763)
6. Paper-Kopplung: ~~offen~~ + **datierte KORREKTUR 10.08.2026** (Z14478–14495)
7. xlsx/csv „beide speisen sich aus denselben In-Memory-Zeilen" → csv ist **Kind** (Z14528)
8. „Gattung und Genus sind zwei getrennte Achsen" richtiggestellt (Z14979)
9. OV-13 „Owner-bestätigt" war Selbstbehauptung — 0 Treffer (Z15960)
10. WACHE-3-Begründung „zwei Achsen im selben Iterationsraum" korrigiert (Z15041)
11. Verify-Bericht „fünf Graph-Commits ungelandet" — beide gelandet (Z14420)
12. Eigene Zahlen: „~100 Commits" → 18 · „24 Stellen" → 39/38 · „der Bruch wird laut" → still (Z15841)
13. „34 unbewachte Stellen" → 38 · „Pin 51→50" → **drei** Pins · „Definitionen 1 (heute 2)" → 3 (Z16549)
14. Trennlinie 9-gegen-2 bei `nearest_rank_median` existiert nicht (Z15750)
15. Register-Befund „kein Batch-Job setzt `COMDARE_GN_SIMD`" widerlegt (12/16) (Z16072)
16. D3-2 Wellenplan-Selbstwiderspruch korrigiert (Z16195)

**Vom Kopf erkennbar überholt: 12 Blöcke.**
G2/G3 teilen ein Gate ⇒ „höchstens 2 von 6 CEB-Varianten baubar" → **B2-Gate-Trennung gebaut** (KON72/74) · `origin/development` clang-unbaubar (WACHE 
3) und **`ce build:clang` fährt nie** → **CI-DUAL gcc+clang, Kombibau 4×491** (KON61/66) · `xlsx 0 / csv 36`, „xlsx ist die Ausgabe aktiv verletzt" → 
**Vorlage-B4 xlsx=STAMM/csv=KIND dreiwertig** (KON60) · „csv **flach** in einen Ordner" → **CSV=FACTORY, verschachteltes Filesystem** (KON89-D3) · „der 
Durchstich trägt heute nicht / jede Mess-Abnahme ist ein Stellvertreter" → **F1 GELIEFERT 14.08., Messung 377503** (KON63) · Vendoring-Rückstand 98 
Commits / `a1d0c201` → **mehrfach gebumpt** (KON56/58) · „die drei `wide`-Stellen in EIN Skript ziehen" → **`ci/wide_aggregat.sh` existiert** 
(KON73-F6/#74) · GitLab HTTP 500 / Infra unten → **helm 19.1.4 deployed** (KON72/73) · prod2 „offline/nicht auflösbar" → **Flotte online** (KON71/#60) 
· Wallclock-Schichtzuordnung offen → **KON60-(iii)** · `lager_pfad_grammatik.hpp:527`-Hybrid-Sperre „wartet auf K1" → **K1 entschieden** (im Segment) + 
**#57** · Sheet-/Ausgabe-Fragen des Registers → **KON87/88/91 P1-Vollbild**.

---

## (D) TRAGENDE ARCHITEKTUR-KERNE DIESES SEGMENTS

1. **Die Kette hat 15 Stationen, nicht 8.** Owner: *„nach auswerten kommt erst **single bauen → single messen → single compare → single release** 
optimal Tier-Binary **für JEDE gemessene Last** … → **Hybrid-Tier-Binary bauen → messen → compare → multi release**"* *(Z14667)*. COMPARE ist 
zweimal eine eigene Station; RELEASE heißt „das Optimum je Last", nicht „veröffentlichen".
2. **Symmetrie ist Identität, nicht Ähnlichkeit:** *„Die Strategien für single und hybrid verwenden **exakt dieselben stateful design patterns und 
Abläufe**"* — daraus folgt **ein** Zustandsautomat, **einmal** gebaut. Die Hybrid-Haupt-Achse liefert **nur die Factory, nie den Automaten** 
*(Z14069–14072)*.
3. **`work_mode` ist die Typisierung dieser Kette** — Unter-Achse unter `measurement_category`, State Pattern, **Besitzer = Planer/Director**; `build → 
measure → compare → release`; `--debug` ist ein **orthogonales CLI-Flag**, kein fünfter State, und für Anwender gesperrt *(Z13726–13743)*.
4. **Die Reihenfolge Single-vor-Hybrid ist sachlich zwingend:** *„wir müssen erst für jede Last das optimale Tier-Binary kennen"* ⇒ **HY-A→HY-B→HY-C 
ist nicht parallelisierbar** *(Z14706–14708)*.
5. **Gattung/Genus sind KEINE Achsen.** Owner: *„eine konzeptionelle metaprogrammierte abstrakte Klassenhierarchie … **Gattung+Genus werden als EINZELNES 
Genus Binary kompiliert und das ist EXAKT EIN Tier-Binary**"* *(Z14996)*. Unter dem Genus sitzt eine **abstract factory `_impl`**, je Funktion eine Klasse mit 
**einem Hauptalgorithmus**, *„der **ausschließlich durch Achsen-Interface Aufrufe gestützt**"* ist.
6. **Der Hauptalgorithmus rechnet nicht, er orchestriert** — jede Arbeit liegt in einer Achse; **darum sind die Achsen die einzige messbare Stelle**. Und: 
**der Aufrufgraph ist ein Netz, kein Baum** (rekursiv, quer zu anderen Gattung+Genus) *(Z15020–15025)*.
7. **Das Genus-Interface ist die ABI-Fläche zur CEB:** *„Damit ist das **Genus interface** das, was das **Prüfdock der CEB** sieht. Und dieses braucht auch 
die **Einrichtungen und Erweiterungen metaprogrammiert für die CEB**."* *(Z14999)*
8. **Die Messung gehört IN die Naht, nicht daneben.** Owner: *„der Ansatz mit den **Sidecars ist falsch** … es muss **am Interface ein Mess-Visitor 
übergeben werden** oder bei deaktiviert eben nicht"* — **zweiseitige UND-Aktivierung** (CEB **und** Tier), zero-cost bei aus *(Z14926–14943)*.
9. **Der eine Defekt hinter allem:** die variadischen Mess-Template-Variablen werden *„nicht über Gattung+Genus Interface per Metaprogrammierung 
durchgereicht"* ⇒ kein Kanal im Tier-Binary ⇒ keine Arena-Init ⇒ **kein `flush()` je Arena** ⇒ keine Signale am Prüfdock. **Eine 
Metaprogrammier-Lücke, keine Laufzeit-Lücke** *(Z14859–14886)*.
10. **`checkpoint_measure` ist unantastbar.** Owner: *„**checkpoint measure ist das zentrale Messinstrument des Systems, es MUSS GEBAUT WERDEN. Sonst gibt es 
keine Messungen**"* — und es trägt **zwei interne Systeme**: Mess-Arena (append, monoton) und Stack-Arena (LIFO, Referenzen, Positionsanzeiger 
Ebene·Modul·Funktion) *(Z14734, Z15157)*.
11. **Zwei symmetrische Kanäle, dieselbe Ursache:** Steuerkanal **Planer↔CEB mit 6 Steuerdocks** (Freigabe System-Achse / Durchsetzung Organ-Achse, Release 
nur **gesammelt** vor oder nach der Gesamt-Messung) und Mess-Kanal **CEB↔Tier** (Visitor am Genus-Interface) *(Z14800–14840)*.
12. **Der Messfühler ist ein Verbraucher** — *„Was er kostet, misst er mit. Die Differenz »mit Fühler« gegen »ohne Fühler« **ist** der Messfehler"* 
⇒ die Ebenen müssen **compile-time ein- und ausbaubar** sein *(Z14251–14253)*.
13. **Overhead ist eine Differenz, kein Messkanal:** `Overhead = Macro-Messung(Hybrid-Aufruf) − bekannte Einzel-Tier-Performance`; die vierte Ebene ist 
**eine zusätzliche Spalte** mit dem Tier-Binary-Stempel je Funktionsaufruf *(Z15559–15571)*.
14. **Tier-Binaries werden nicht vorgehalten:** Buildsystem-Cache → hot im RAM → **verworfen**. Gelagert werden **Messdaten** *(Z14293–14311)*.
15. **Der Lagerbaum bekommt zwei neue Wurzelebenen für ALLE Gattungen/Genera:** `Gattung → Genus → Binary|Messung → REST`, die Realm-Trennung ist ein 
**Zweig**, keine Wurzel *(Z15528–15542)*.
16. **csv ist das KIND der xlsx:** *„die csv wird doch **aus der xlsx gebildet, IMMER** … was auf dem RAM liegt ist etwas völlig anderes"* ⇒ ein 
csv-Ergebnis ohne funktionierenden xlsx-Weg ist ein **Widerspruch, kein Sparmodus** *(Z14518–14534)*.
17. **Perzentil-Kanon:** eine Definition `ceil(q*n)-1` (Hyndman/Fan Typ 1), Median = Fall q=0.5; `vals[(n-1)/2]` **ist** dieser Fall für jedes n. Für 
**Konfigurations-Mediane gilt der Kanon, aber nachgelagert**: die Hauptauswertung misst stumpf in voller Granularität, die compare-Phase leitet ab 
*(Z15614–15626, Z16591)*.
18. **Allokations-Verbot:** *„**neue Allokationen für die Messwert-Aggregation sind VERBOTEN, weil sie das Bild der Messungen verzerren**"* — Append in 
einen vor-reservierten, möglichst großen custom Bereich *(Z15641)*.
19. **`debug` beweist die KETTE, `measure` die ZAHL.** Owner: *„die **bereits gebauten hunderttausenden Binaries schnell zu beweisen**, ob sie **prinzipiell 
korrekte xlsx erzeugen und ablegen**"* — F1 ist derselbe Beweis an einem Messwert, `debug` ist er über hunderttausende *(Z13778–13794)*.
20. **Beweislast-Umkehr:** *„**wir streichen nichts** und können uns das auch nicht leisten"* + *„der **Wellenplan steht und gilt**"* ⇒ **ein Posten 
verlässt den Plan nur mit einem zitierbaren Owner-Satz zum Gegenstand.** OV-Nummern sind kein Autoritätsbeleg *(Z14386, Z14334, Z14364, Z14443)*.
21. **Und die Meta-Lehre dieses Segments, wörtlich:** *„**Ein veralteter OFFEN-Eintrag an der Spitze ist teurer als eine fehlende Notiz**, weil er die Suche 
**aktiv beendet**, statt sie nur nicht zu unterstützen. Wer künftig einen Punkt schließt, schließt ihn an der **Spitze** mit, nicht nur am Ort der 
Entscheidung."* *(Z14493–14495)* — genau der Mechanismus, den diese Gegenlese adressiert.

==========================================================================================
## RESULT 4 (wf_750a0423-c46)
==========================================================================================

Suche."* Und: **„Der Plan ist keine Quelle über den Code. Er ist eine Behauptung über ihn."** — der Kern-Explore (KON4-Kopf) fand in 5 von 5 Fällen den 
Bauauftrag am Objekt falsch.

21. **Der teuerste Bruch ist benannt** (KON5-04): drei Ebenen der Reihenfolge-Änderung — Makro-Argumente (golden-Bruch) · POD-Feldfolge (**ABI-Bruch**, 
`stamp_layout_version` 6→7) · **Preimage-Glied-Folge** (`anatomy_fingerprint.hpp:601`, Glied-Count **FEST = 9**) ⇒ *„JEDER SHA-512-FINGERPRINT ÄNDERT 
SICH"*. Empfehlung: Ebene (1), gebündelt — **EIN golden-Bruch statt zwei**.

22. **Identitäts-Umbauten sind heute kostenlos** (KON6-02(2)): *„es wurde noch nie eine Flotte gebaut, daher kein Blocker vorhanden, aber der Bau ist unser 
Ziel."* ⇒ **nicht „erst bauen, dann ordnen", sondern zwingend umgekehrt**; Riegel = **F2 = Identitäts-Freeze**, teuer ab Bau-Trigger Mi 26.08. 06:00.

---

## NACHTRAG — DREI PRIORISIERTE HINWEISE FÜR DIE WEITERVERARBEITUNG

**Sofort pfadwirksam (berühren pendente Tasks):**
1. **KON5-06** — die zwei Fassungen der Diff-Hygiene-Wache (`--stdin` gemeinsam, ce 221 Zeilen stärker) treffen **#19 main-FF** direkt: der Kopf schreibt 
„davor kumulative Hygiene-Wache", das Segment sagt, dass beim super-FF **die schwächere Wache misst und trotzdem GRÜN druckt**.
2. **KON5-04(3) + KON5-05** — vor dem **#15-Bump-Bündel** (ABI 6→7) ist zu entscheiden, ob die **Preimage-Glied-Folge** (Ebene 3, Glied-Count fest = 9) 
und das **Enum `AxisKind{organ, system_measurement, system_config}`** (vierter organ-first-Fundort) mit im selben Bruch liegen. Sonst ist die Stufen-Ordnung 
nur halb angewandt und der teuerste Bruch steht später erneut an.
3. **KON16-09** — die angeordnete **Stufe/Phase-Umbenennung** ist **preimage- und ABI-wirksam** und damit an dieselbe F2-Frist gebunden wie S-6. Sie taucht 
in KON60–93 nirgends auf; wird sie nach dem 26.08. fällig, kostet sie dasselbe wie S-6.

**Höchstes „vergessen"-Risiko (Owner-Wort ohne jeden Kopf-Eintrag):**
- **KON9-09** Abgabe-Pflicht (Owner-Definition Syntax+Semantik je Achsen-Kategorie über `c` hinaus) — *„Das ist Pflicht und Basis für die Abgabe."*
- **KON15-05** Runner-Lese-Riegel — *„Das ist mein letztes Wort dazu."*
- **KON16-02** Messfühler-Vertrag — dritter Vertragsgegenstand, **in keiner Bau-Position**.
- **KON6-02(5)** Verbot, die alten Stempel zurückzuholen.

**Größter wiedergewinnbarer Wert:**
- **KON6-03-Forensik** — der am 27.07. mit `ce 813c3232` gelöschte **selektive Rebuild** (`perm_<id>.version`-Differenz ⇒ MINOR-Bump nur bei betroffenen 
Permutationen). Heute vergleicht `dll_is_current` 128 hex auf Gleichheit ⇒ **Vollflotten-Neubau**. Das ist exakt die Fähigkeit, die die Owner-Regel 
„Hardware-Erweiterung ist additiv" und der Cache-Schlüssel (Stempel-Rolle 2, die einzige ohne Objektbeleg) brauchen. **W12-B** wartet dafür seit dem 19.07.

==========================================================================================
## RESULT 5 (wf_750a0423-c46)
==========================================================================================

der siebten.

**B-3 · Die `merge`-Zeile im Stempel: Verbot gegen offenen Bauauftrag — der Ledger widerspricht sich selbst.**
- *Segment, KON-05, Owner 02.08., „trigger-blockierend vor Voll-Bau-4":* die `merge`-Zeile im Stempel **darf nicht existieren**; Meta-Meta-Achsen hängen 
**dynamisch ans Realm-Ende**.
- *Segment, KON2-34(2), am Objekt gemessen:* „**LEDGER:9468 kennt den Owner-Entscheid E-2 und ordnet die sofortige Entfernung an. ABER: der Ledger 
widerspricht sich SELBST — LEDGER:8941 führt denselben Gegenstand weiter als offenen Bauauftrag (»[§59-MERGE-STEMPEL] … POD 56 → 72, layout 2 → 3, 
OFFEN, hoch«).**" Suchbelege des Melders: `MERGE-STEMPEL` = 9, `Merge Zeile kann daher nicht existieren` = 1. Ausdrücklich markiert als „**relevant VOR 
W2-S-B**".
- *Kopf-Referenz:* KON60-B1 „Tier-Stempel = **4 Zeilen, 2 Arrays**, nur Eingebautes"; Task #15 „Bump-Bündel = **ABI-Layout 6→7** + Format 4→5 in EINEM 
Bruch".

Der Widerspruch ist **nie aufgelöst worden**; er ist nur numerisch überholt (layout 2→3 ist heute 6→7). **Solange die zweite Ledger-Zeile lebt, kann 
jemand die verbotene `merge`-Zeile als Bauauftrag abarbeiten — und erzeugt genau den wertlosen Binary-Bestand, vor dem KON-05 warnt.** Das ist ein 
Trigger-Risiko für den 26.08.

**B-4 · `checkpoint_measure`: „Erfindung, endgültig belegt" gegen „Wallclock = CEB-seitiger checkpoint-measure-Wrapper".**
- *Segment, Block „Drei Entlastungen", 09.08.:* „**»SPEZIFIZIERT, NICHT GEBAUT« — dritte unabhängige Bestätigung des Nullbefunds, diesmal in einem 
inhaltlich völlig anderen Transkript. Die `checkpoint_measure`-Erfindung ist endgültig belegt.**" Und im Segment zweimal als Musterfall zitiert 
(KON-60/A5-19): „eine Begründung, die durch Wiederholung Autorität erlangt hat".
- *Kopf-Referenz, KON60 (iii):* „**Wallclock = CEB-seitiger checkpoint-measure-Wrapper**".

Sachlich vermutlich vereinbar (der Owner hat am 14.08. eine Sache *entschieden*, die vorher nur behauptet war — aus der Erfindung wird ein Entwurf). **Aber 
kein Marker sagt das.** Wer KON60 (iii) liest und im Segment auf „Erfindung, endgültig belegt" stößt, hat zwei sich ausschließende Aussagen zum selben 
Namen. Ein Ein-Satz-Vermerk an KON60 (iii) („der Name stammt aus einer 09.08. widerlegten Behauptung und wird hier NEU vergeben") beendet es.

**B-5 · Hardware-Erkennung: „zweigeteilte MESS-Achse, Planer grob/RT + CEB fein/CT" gegen „Planer-HW-Erkennung NUR für PMC".**
- *Segment, KON-03, Owner-Wort 27.07.:* die Hardware-Erkennung ist „**keine System- und keine Organ-Achse, sondern eine MESS-Achse**, und sie ist 
zweigeteilt: der **Planer** erkennt **grob und zur Laufzeit** und wählt ein; die **CEB** trägt es **fein und zur Compile-Zeit**." Mit dem Zusatz: „*die 
Realm-Zuordnung ist bindend für alle Folgepakete* — eine im falschen Realm angelegte Achse zieht die falsche Registry, den falschen Stempel und die falsche 
Freigabe-Mechanik nach sich."
- *Kopf-Referenz, KON64/65:* „**F2 Planer-HW-Erkennung NUR für PMC, System-Achse = Proxy**".

Die neuere Fassung verengt den Planer-Anteil auf PMC und schiebt den Rest auf einen System-Achsen-Proxy — das **verschiebt die Realm-Zuordnung**, die KON-03 
als „bindend für alle Folgepakete" markiert. Ob KON-03 damit überholt, präzisiert oder nur für PMC ausgenommen ist, sagt niemand.

**B-6 · CEB-Zahl: die Reihe 5 → 6 → 12 hat kein Ende.**
- *Segment, W-3:* Seite A (Owner 08./09.08.): „**3 Stufen und 6 CEBS (nicht 5 das war mein Fehler)**"; Seite B (Owner 10.08. 07:27, E-5, im damaligen Ledger 
0 Treffer): „**Nun eigentlich sind es 12, weil Hybrid einmal mit und einmal ohne Macro-Benchmarking Messfühler gegen die 6 CEBs getestet wird. Mein 
Fehler.**" Aufgelöst zugunsten von 12; ausdrücklich offen gelassen: „**Die Frage 24 oder 48 bleibt davon unberührt und weiterhin NICHT entschieden.**"
- *Kopf-Referenz:* KON71 „DRITTE 32er-Rüge (**Mess-Permutation DYNAMISCH >32, NUR S-19 rechnet sie**)" · KON64/65 „**32er-Falle: Belegungs-Welt (2^5) 
entkoppelt von Dock-Zahl**" · Task #23/KON34 „**die 6 verliert ihren Gegenstand** (Instrumente auf verschiedenen Stufen)".

Die 6 ist erkennbar gefallen. **Ob die 12 mitgefallen ist oder als Zwischenstand weiterlebt, sagt weder KON34 noch KON71.** MEMORY führt sie weiter 
(„CEB-Reihe 5→6→12 (W-3)"). Und die Anschlussfrage „24 oder 48" ist seit dem 10.08. unbeantwortet, ohne dass jemand sie für gegenstandslos erklärt 
hätte. Da S-19 (#7, Sa 22.–Mo 24.08.) die einzige Stelle ist, die diese Zahlen rechnet, gehört die Klärung **vor** S-19.

**B-7 · Repo-Rollen: „WAS / Prüfling / WIE" gegen „Framework / Einstieg".**
- *Segment, KON-41, Owner-Wort 12.04. + 08.05.:* `Diplomarbeit/Code/` = „**WAS + Auswertung**" · `comdare-prt-art` = „**Prüfling**" · 
`comdare-cache-engine` = „**WIE + Werkzeuge**".
- *Kopf-Referenz, KON73-F6:* „Repo-Rollen (**ce = Framework, super = Einstieg**, XSD-Hoheit → ce #74)".

Nicht zwingend unvereinbar — aber F6 ordnet **super** als „Einstieg" ein, während KON-41 super (`Diplomarbeit/Code/`) die **Auswertung** zuweist, und 
genau die Auswertung wandert in #74 teilweise nach ce (05_diagram_generator, 08_appendix_generator, golden-Familie). **Wer #74 abarbeitet, verschiebt 
Auswertungs-Code aus dem Repo, dem der Owner die Auswertung zugewiesen hat.** Das gehört vor dem Umbau ausgesprochen, nicht danach.

**B-8 · Nummern- und Anker-Kollisionen, die aktiv falsche Treffer erzeugen** *(kein Sachwiderspruch, aber dieselbe Wirkung)*.
Drei belegte Fälle in meinem Segment: **`KON-60` (Segment) ≠ `KON60` (Kopf)** · **`F1` = Meilenstein 14.08. gegen `F1` = erste ADR im Register KON-40** 
(„die Verwechslungsgefahr ist real und gehört mitnotiert") · **`G1` = K7b-4-Paket-Codename gegen `G1` = Lager-Gate-Serie G1-G5** (KON2-20: „Zwei 
Bedeutungen, ein Vokabular — ein Argument FÜR die Umbenennung"). Dazu **W-9** als bereits gelöster Präzedenzfall (OV-13 trug zwei Gegenstände) mit der 
Regel: „*eine Berufung auf eine OV-Nummer ist kein Autoritätsbeleg. Zu prüfen ist immer der Gegenstand im Roh-Transkript, nie die Nummer.*"

---

## C) ÜBERHOLT-BESTAND (nur Zählung + Kurzliste)

**Im Segment selbst als erledigt / zurückgenommen / entlastet markiert — 29 Posten:**
KON-06 (Gattung Graph, ausdrücklich zurückgenommen) · W-1 (Paper-Kopplung aufgelöst) · W-2 (prod1 16/32 am Objekt gemessen) · W-3 (6 → 12) · W-4 
(Ledger-Schreibregel für 10.08. aufgehoben) · W-7 (Compiler-Achse als Befund, nicht Bau) · W-8 (drei Platten-Momentaufnahmen) · W-9 (OV-13-Kollision) · 
W-10 (E1 = MILLI-FIXPUNKT, der Finder war überholt) · KON-45 (von DELTA auf Anker-Satz reduziert) · KON2-16(b) (Mess-Array §58-V geschlossen **und** 
bereits nachgetragen) · KON2-22 (Blocker-Kommentar stale, nicht offen) · KON2-34(1) (8 von 9 Commits doch gelandet) · KON2-34(3) (KON-18-Diagnose am Objekt 
widerlegt, Heilung 2026-08-10) · KON3-16 (Testhälfte `test_hy_a1` 0 → 4) · KON3-10 (der gitleaks-Einzelfall geheilt) · KON3-13 (Rückbau sachlich 
abgewendet) · `ddr4_2x32` → `ddr5_2x32` (Juli-Kandidat entlastet) · prod2-configure-Hang 09.07. (als Vorgeschichte absorbiert) · die **33 „GEPRÜFT UND 
GEDECKT"-Positionen** als Block · `is_original:relock` (geklärt, kein Verstoß, Pipeline 15490 als Beleg) · Reichweite-Korrektur 15501 (wird nicht grün und 
soll es nicht) · D2-G1 (durch W-1-Wurzelfix gegenstandslos) · D1b (durch Bauweg-Änderung überholt) · W-1/ST-CTestWache (abgeschlossen, `enable_testing()` 
bei `CMakeLists.txt:695`) · D4-Statistik-Kette a–e (vollständig gebaut, bis ce/main gelandet, Merge `ebb3cf27`) · Magic-Budget (Schaden heute null) · ~11 
undurchsuchte Transkripte (Entlastung des Suchverfahrens) · -Wall-SPEICHER-Klasse (0 von 114 — leer).

**Durch die Kopf-Referenz KON60-93 bzw. die laufende Task-Karte erkennbar überholt — 16 Posten:**
KON-37 (98/366 Trailer → KON76: 0/372) · KON-49 (PRT-ART-Ladeweg → KON74/KON75/#65) · KON-19 (`hy_label_gate`/Vendoring-Pin → #65 gelandet) · KON-50 
(Doku nicht git-getrackt → der Ledger liegt heute im echten Umbrella) · KON-20 (Concurrency-Streit → KON73-F7 Drei-Bereiche-Concurrency) · KON-18 
(486/488 → #14: 482/482, KON61: Kombibau 4×491) · KON-17-Kern (XorFilter 30/256 → KON74 reproduziert, KON80-V1, #70) · KON-52 + KON-45 (Fristen → 
Meilensteine der Kopf-Referenz) · KON-26 (node5/node6, WS2022-Schlüssel → #60) · KON2-01-MinIO-Teil (→ #10, neues Paar `comdare-ci-r20260814`) · W-5 
(Lizenzen offen → KON66/67 + Change Date 10.08.2031) · KON3-14 (`build:clang` opt-in → CI-DUAL, KON66/Task #3) · KON2-30 (2-Pass-Kette → MEMORY 
J-1…J-4) · PA-2/PA-3 (K4-Nachtrag + Waisen-Verbleib → #65 `bau/prtart-waisen-archiv`) · Wellenplan-F-07b (→ ÜBERHOLT-Marker `ff64fe0e`, Task #49) · 
KON-62-Teilbefund „11 Transkripte" (→ KON69: A2-Prüfung 0 Funde).

**Summe: 45 Posten überholt, davon 29 segment-intern markiert und 16 durch neuere KON-Stufen.**

---

## D) TRAGENDE ARCHITEKTUR-KERNE DES SEGMENTS

1. **Die Versionierungs-Ordnung, Owner-Wort 10.08., am selben Tag bestätigt („Das ist jetzt alles korrekt.") — KON2-06:** Achsen-Algorithmus → eigene 
Version, spiegelt sich in der Tier-Binary · Genus (Interface) → **zusammengesetzt, compile time, aus ALLEN Mess/System/Organ-Achsen** · Planer → simple 
X.Y.Z · CEB → **nur Mess + System, keine Organ** · Tier + Hybrid-Tier → Mess + System + Organ. **Fingerprint-SHA tragen alle vier Binary-Typen.** 
„System-Achsen sind die einzigen Achsen mit komplexer Syntax und Grammatik" (CPU/GPU/FPGA/NPU/AVX).
2. **Der Mechanismus dazu — KON2-07:** Organ-Achsen reichen den Algorithmus-Namen über das Achsen-Interface durch und bauen zur compile time einen Stempel 
**in fester Achsen-Reihenfolge in der Organ-Achsen-Klammer**; System-Achsen isoliert für Hardware; Mess-Achsen isoliert beim CEB-Compile; **„die CEB 
übergibt ihre Mess-Achsen Eigenschaften an die Tier-Binaries, damit der Vertrag CEB → Tier-Binary am Prüfdock compile time veränderlich hält."**
3. **Dieser Vertrag existiert und ist produktiv — KON2-15:** `mess_konsistenz_gate.hpp:2` trägt den Owner-Satz als Dateititel; Aufruf fail-closed **vor 
jeder Messung** (`cache_engine_builder_iterator.hpp:2815`), sechs Ablehnungsklassen. Drei Geschwister-Gatter am Dock: **KANN die Hülle es?** 
(`conformance_gate`) · **WIRKT es wirklich?** (`mess_interface_testate`) · **IST die Ausstattung DIE, die die CEB einkompiliert hat?** 
(`mess_konsistenz_gate`).
4. **Identität kommt aus der Rekombination, nicht aus einer Nummer — KON-04, Owner verbatim:** *„Eine Binary hat KEINE eigene Versionsnummer."* Nur der 
Planner trägt eine; CEB und Tier identifizieren sich aus **Haupt-Achsen-Rekombination + Algorithmus-Versionierung**. Wer eine eigene Binary-Version einführt, 
**bricht den Lookup über SHA512-Keys**.
5. **Warum die Skip-Ökonomie heute nicht greift — KON2-09/KON2-10:** §43 war zweiteilig, W12-A (Erzeugung) gebaut, **W12-B (Konsumption) nie abgehakt**. 
Organ-Änderung ist chirurgisch (Glied [1], per-Permutation); **System-Änderung erzwingt Vollbau (Glied [6], run-konstant)**. Ursache ist **der Hash: auf 
einem SHA-512 ist keine Teilmenge prüfbar** — `recorded ⊆ current` ist nicht nachrüstbar, solange das bvset nur gehasht im Sidecar liegt. Das Gegenmuster 
existiert im Haus (Bestandslog v4, OE-C: *„dafür muss die Version LESBAR am Eintrag stehen"*).
6. **Deshalb ist Hardware-Erweiterung teuer, nicht unmöglich — KON2-12/KON-47:** dreifach belegt (`build_orchestrator.hpp:311-312`, 
`driver_build_variant_signature.hpp:33-36`, `dll_is_current:345-352`) bekommt **jede** Tier-Binary bei einer ISA-Erweiterung einen neuen Fingerprint — 
*„nicht unmöglich, sondern wirtschaftlich unbezahlbar"*. Owner-Regel dagegen, verbatim: *„eine Erweiterung der ISA und System-Meta-Meta-Achsen zur 
Hardware-Erweiterung ist stets zulässig, ein Neubau kann nur bei Funktionseinschränkung erfolgen … bei Hardwareerweiterung werden einfach nur die neu 
möglichen fehlenden Permutationen ZUSÄTZLICH gebaut."*
7. **Die Reihenfolge der Reparatur ist begründet, nicht beliebig — KON2-13:** *„1 vor 2, weil ein Hash keine Teilmenge kennt. 2 vor 3, weil Bump-Disziplin 
ohne funktionierendes Gate nur Buchhaltung ist."* Die zwei unvermeidbaren Invalidierungen sind **zu EINEM Vollbau bündelbar** und **bewusst zu terminieren** 
(„kein Grandfathering").
8. **Der Riegel gegen einen erneuten stummen Ausfall ist ein ctest, kein CI-Job — KON2-14:** zwei bvset-Mengen `A ⊂ B`, Forderung **A skippt gegen B, B 
skippt NICHT gegen A** — die Richtungsblindheit ist genau das, was der Test sieht. Plus: Skip-Zähler in die Ausgabe, damit „0 übersprungen bei hunderten 
fälligen" **numerisch auffällig** wird statt nur teuer.
9. **Die wissenschaftliche Begründung des gesamten Massenanfalls — KON-09, Owner verbatim:** *„Ja das bedeutet zehntausende grosse Suchmodul-Binaries… 
und das ist in Ordnung so."* Grund: **dynamisches Laden erzeugt Lade-Latenzen ⇒ verfälscht das Messergebnis ⇒ verboten.** Wer das nicht kennt, schlägt 
beim nächsten Kapazitätsengpass genau das vor und zerstört die Vergleichbarkeit aller Messwerte.
10. **Die Sprache ist eine Ausschluss-Entscheidung — KON-08, Owner verbatim:** *„Eine search algo Achse innerhalb der Search Algo Permutation ist 
Schwachsinn."* Daraus **Achse = Organ**, Permutation = *„genetisches Experiment am Lebewesen"*. Die Metapher ist nicht verhandelbar, weil sie eine abgelehnte 
Konstruktion ausschließt.
11. **Die Richtung der Repos ist eine Owner-Umkehr — KON-63, verbatim:** *„Warum ist jetzt der PRT_ART in der Cache Engine, das ist doch falsch rum."* ⇒ 
PRT_ART ist **Prüfling** und **konsumiert** die CacheEngine (`CLAUDE.md`-Ausnahme S2683); Rollen: `Diplomarbeit/Code/` = WAS + Auswertung · `prt-art` = 
Prüfling · `cache-engine` = WIE + Werkzeuge (KON-41). Die Produktionskante läuft **einseitig ce → prt-art** über `COMDARE_CE_PRUEFLINGE`; die Rückkante 
existiert **ausschließlich artefakt-isoliert in einer Teststufe** — wer sie als Zyklus „repariert", löscht die Teststufe (KON-32).
12. **Die Reihenfolge Pipeline-vor-Messlauf ist Owner-gesetzt — KON-31, verbatim:** *„Die CI/CD ist eigentlich das Fundament"* · *„Der derzeitige Code 
übersteht noch keine Wartbarkeit"* · *„Wir machen erst die Pipeline klar und dann den Messlauf voll treiben."*
13. **Die Bauform aller Wachen ist entschieden — Owner 09.08. verbatim:** *„Ich sehe einen Haufen shells statt vernünftiger google tests … **Skripte 
sagen gar nichts.** Bitte recherchiere Mutations-Sicheres Testen."* plus *„es war ja auch nur C++ und cmake erlaubt"* und KON-34 *„keine skripte ausser 
cmake sparsam"*. Der Weg ist gebaut (`Code/ci_wachen/`, Debug **und** Release) — **die Wachen selbst sind noch Shell, und dieser Ist-Stand steht in keinem 
Plandokument.**
14. **Die Abnahme-Messlatte für Tests — W0b-Verify:** *„Ein Test, der eine Mutation innerhalb der geänderten Datei nicht fängt, ist für diese Sache 
kein Test — auch wenn er grün ist, auch wenn er neu ist, auch wenn er 22 von 22 zeigt."* Konkret: die Naht Naht→Mappe ist ungedeckt (`dimension 
ref="A1:C1"` bei 22/22 PASSED), die Stamm/Kind-Kopplung ebenso (`verworfen()` immer `EXPECT_EQ(…,0u)`).
15. **Die Existenzbedingung von Wissen in diesem Projekt — Mess-Regel 10, verbatim:** *„Ein Paketschnitt, der nur in einem Session-Dokument steht, 
existiert für die Ausführung nicht."* Dazu die Kollisionsregel W-4 (Owner 17.07.): *„Das ledger darf regulär geupdated werden, nicht nur additiv. **Neuere 
Fakten schlagen immer ältere Fakten.**"* — und ihre Gegenseite (20.07., *„Den ledger ändern wir nur noch, wenn ich technische Änderungen aufgreife"*), 
deren isolierte Lesart die Ursache war, dass zwischen 20.07. und 10.08. **nichts** konsolidiert wurde.
16. **Zwei Anker-Disziplinen, aus Schaden gelernt — KON2-31:** der **Messort (Pfad + SHA) gehört in JEDEN Bericht**; Code-Kommentare verweisen auf 
**Paragraphen-Marken (§62-B, §43.b)**, **nie auf Ledger-Zeilennummern** — „der Ledger wächst". Und **V6.5:** zur Testzahl gehört der **BAU-ZUSTAND**, 
nicht nur der Commit (drei Zustände, drei Zahlen: 488 / 490 / 492).
17. **Die härteste Zahl des Segments — KON-42/T-08:** die Anhang-Ergebnistabellen der Arbeit sind aus keinem Repo-Bestand reproduzierbar; **es existiert 
genau EIN echter Mess-Lauf: 16 Zeilen, `057ee3e5`, 26.07.2026.** Daneben T-19: die bias-freie Vollmatrix — *„der methodische Kern der Arbeit"* — ist im 
Register auf einen Doku-Vermerk abgestuft.
18. **Die Grundgesetz-Ebene fehlt im Ledger — KON-40:** 25 Architekturentscheidungen **F1–F15 + F-EXTRA-1..8** (04.05., „beschlossen durch den 
Architekten (Nutzer)"), inklusive Singleton-Form, Observer-Mechanik, Permutationsraum, Codegen-Strategie, ABI-Form und der Habich-Direktive *„Originalcode 
bleibt bit-identisch in `ext/`"*. Der Ledger führt die **Folgen** an dutzenden Stellen, **die Entscheidungen selbst nirgends**.
19. **Die rechtliche Basis ist ein Satz — KON-39, Owner verbatim:** *„Da wir alle Algorithmus-Bestandteile zerschneiden, entsteht für alle 
Permutations-Achsen ein neues Werk. Das gilt für alle Lizenztypen. Repos ohne Lizenztypen haben nur ein formales copyright, also muss nur der Autor beim 
Zitieren genannt werden."* Er löst GPL-3 (P04, P07) und No-License (P06, P25, P30, A03) **ohne Einzelbestätigung** — und wird trotzdem jedes Mal neu 
erfunden.
20. **Die harte Quellen-Grenze — KON-62:** Rohtranskripte existieren erst ab **05./06.07.2026**; März–Juni ist durch den `root`→`comdare`-Umzug 
unwiederbringlich (übernommen: nur Git-Klone + 60 destillierte Memories). **Für diesen Zeitraum sind Session-Dokumente und Memories die einzige Quelle — 
kein weiterer Strang sollte die Suche erneut versuchen.** Das erklärt zugleich das Owner-Wort *„verbatim im Session log der letzten 10 Wochen"*.

---

## ANHANG — WAS BEREITS GETRACKT IST (damit die Elternstelle nicht doppelt bucht)

Aus meinem Segment sind über die laufende Task-Karte **bereits erfasst**: **KON-15** (tote Leser `measurement_on`/`single_thread`), **KON-43** (sechs 
Betreuer-Pflichten: Ordnungsmodi · Common-Denominator · Ablation · Relocation · Prefix-Lookup · `art.profile.xml`; D-12/D-03/D-04), **KON-44** 
(`termine/INDEX.md` auf 15.05. eingefroren, T9–T11 fehlen; Termin 9/10/11 ohne Konsolidierung), **KON-61** (`machines`-Schlüssel 
`cpu_fabrication='amd_zen4_avx512'` gegen belegtes Zen5) und die **concurrency-Owner-Vorlage** — alle fünf unter **Task #71** („Triage-Sammelposten 
Leser-Hebungen"). Sie sind in A oben bewusst nur als Querverweis genannt, nicht als Neufund.

**Segment-Bilanz:** 120 Positionen gelesen (18 + 36 + 66 + W-1…W-10 + 8 Tages-Blöcke) · **45 überholt** (C) · **8 unaufgelöste Widersprüche** (B) · 
**~63 lebende, in KON60-93 unsichtbare Posten** (A), davon nach Hebelwirkung die Spitzengruppe: **KON-46** (Retry-Policy 5/2/1) · **KON-11/KON-12** 
(Drift-Gate-Wortlaut + n=1) · **KON-36** (fünf rote Dauer-Tests) · **KON2-13** (Wiederaufbau-Plan, Pakete 1/2/4/6) · **KON2-19** (Lock-Gate deckt 1 von 18) 
· **KON2-20** (Owner-Bau-Auftrag Stempel-Benennung) · **KON-40** (ADR-Register) · **KON-42** (23 §63-T-Einträge, T-08/T-19/T-21/T-22) · **KON-51 + 
KON2-02 + KON2-26** (Public-Gang-Bündel) · **MT-L3** (0 von 29 eingefrorene Orakel, Regel vor jeder End-Append-Spalte) · **KON3-05/KON2-32** (34 BLOCKIEREND 
nie gebucht).

==========================================================================================
## RESULT 6 (wf_750a0423-c46)
==========================================================================================

# GEGENLESE-KARTE KON1-59 vs KON60-93 (16.08.2026)

Konsolidierung der 5 Segment-Karten (KON59-36 · Konsolidierung IV A-M + KON34-16 · KIV-Rest · KIII/KII-1 · KII-2/Z13601-16626) gegen die Kopf-Referenz 
KON60-93 (Z. 1-2833).
**Anker-Konvention:** `KONxx` = Ledger-Stufe · `KON-xx` (Bindestrich) = Register Konsolidierung II/III — NICHT dasselbe (belegte Kollision KON-60 ≠ KON60) 
· `Z…` = Zeile des 09.08.-Rohbestands (Datei-Stand 29858).
Bereits unter **#71** getrackt (nicht doppelt buchen): KON-15 tote Leser · KON-43 sechs Betreuer-Pflichten · KON-44 termine/INDEX eingefroren · KON-61 
machines-Schlüssel · Concurrency-Owner-Vorlage.

---

## 1) LEBEND-LISTE (dedupliziert, nach Dringlichkeit)

### Korb A — VOR F2 Fr 21.08. (Identitäts-Freeze): gehört in das EINE Bump-/golden-Fenster (#15/#38a2/#16)
1. **KON45-01 + KON5-04** — 10. Stempel-Glied für ALLE Binaries (Hybrid-Map-Zeile, Tier trägt ""), GliedCount 9→10, gebündelt mit Format 4→5 + Layout 
6→7 zu EINEM Bruch („ein golden-Bruch statt zwei") → #15.
2. **KON45-01(5)/KON58-11(d)** — Preimage-Budget-Bruch: 32 Docks ≈ >4,5 KB sprengen `kAnatomyFingerprintPreimageMax=4096` (anatomy_fingerprint.hpp:68); 
Konstante MIT Budget-Beleg heben — trägt bislang KEINE Task-Nummer → #15.
3. **KON45-01(6) + KON47-02** — Synthese-Key-Grammatik existiert nicht (`strategie_name()`-Literale verletzen Glied-Zeichenvorrat); Map-VALUE = Tier-SHA 
statt Voll-Stempel; RT-Cache voller Tier-Stempel am Dock, Invariante RT ⊆ CT → #15/HY-A2.
4. **KON5-04(3) + KON5-05** — VOR dem Bruch entscheiden: gehen Preimage-Glied-FOLGE (fest 9, anatomy_fingerprint.hpp:601) und `AxisKind`-Enum-Ordnung im 
SELBEN Bruch mit? Sonst steht der teuerste Bruch später erneut an → #15-Design.
5. **Z13694 (09.08.)** — `work_mode`: `Debug` verlässt das Enum (Ordinal 0), `Build` tritt ein, `kWorkModeCount=4`, neue Registry-Zeile — lauter 
Ordinal-/Stempel-Bruch; Kette build→measure→compare→release, Besitzer = Planer → ins #15-Fenster.
6. **KON16-09** — angeordnete Stufe/Phase-Umbenennung ist preimage-/ABI-wirksam ⇒ selbe F2-Frist wie S-6; nach dem 26.08. Flotten-Preis → #15-Fenster.
7. **Z15504** — E-1-Heuristik-Rekursion: „Tiefe und Heuristik-Funktions-Stufen-IDs im Stempel ablesbar" (Owner) — zwei zusätzliche Stempel-Felder → 
#15/#38a2.
8. **Z15650** — prod2-Umbenennung („Ja umbenennen"): der Registry-Generator spiegelt den Namen ⇒ in dieses Bump-Fenster legen → #15.
9. **KON30-02** — `FullJoin` (Prüflings-MergeStrategy, golden-byte-wirksam) beim S-6-Fenster-Bau UMBENENNEN — Kollision mit KON91-„FULL JOIN" (anderes 
Objekt) → #15.
10. **KON21-03/KON20-02/KON5-04** — S-6-Schnitt komplett (Umstellung · Transpositions-Sperre · Kategorien-Ordnungs-Wache „Ja bitte" · #67 behalten) + 
VERBOTSZONEN (Lager-Kaskaden, kOrganGruppen*, kSystemAxisOrder, kCompositionAxisNames, Hash-Mechanik, Messwert-2-Tupel) → Inhalt von #15 (Kopf führt #15 
ohne diesen Inhalt).
11. **KON7-01** — 5. ABI-Symbol (Stempel) ist am Loader OPTIONAL (nullptr erlaubt) — SOLL: Pflicht → selbes Fenster (ABI-Fläche).
12. **KON37-01** — B3-„Wallclock-Umzug" = Umzug der SCHALTER-HOHEIT zur CEB (abi_adapter.hpp:476-491 fällt), kein physischer Umzug; Vererbungsregel: CEB 
baut Kinder nur nach eigenen Messeigenschaften → Semantik für #24-B3 (vor F2 Owner-Datum).
13. **KON58-05** — EISERNE REGEL bis zum Fenster: nichts unter axes/ topics/ heuristik/ anfassen (Overlay-Glied [7] hasht Quelltext) — Arbeitsregel ALLER 
parallelen Stränge.
14. **KON58-05 (Korrektur)** — „jeder Algorithmus bekommt eine neue Versionszeile" hat NULL Ledger-Treffer; KON9-05 verlangt nur Stempel-UNTERSTÜTZUNG — 
keine 123 Literal-Bumps einplanen.

### Korb B — W2-Bündel Di 25.08. (#18 S-13 + Arena E1-E10 + #57 Lager + Nähte)
1. **KON50-01/-02** — Naht-Schablone Planer↔CEB: Fläche 1 = Control-Interface stream in/out; hinauf DREI Nachrichtenklassen (Fortschritts-Deltas · Status 
je Anforderung + Fehler-LOG „warum" · Ergebnis-Trace); RÜCKWEG-GRENZE: NIE Mess-Rohdaten zum Planer → S-8/S-10, #20.
2. **KON51-01** — Steuer-Naht spricht GEFILTERTES XML (nur benötigte Programmteile der syntax-geprüften Eingangs-XML); Fläche 3: Signalfunktion aus, 
Messwert-Stream ein — Format SPARSE BINARY, kein XML → #20 Fläche-3-Vereinigung.
3. **KON51-02/-03 + KON52-01** — Arenen je Tier/Hybrid bei Anforderung eingebaut, Flush nur an Hol-Punkten, Rückschrieb am Experiment-Ende; Stummschaltung 
während der Messung; OOB-Klasse = GENAU das Fertig-Signal; `ram_warn_grenze` 6 GB / `ram_oob_grenze` AUS, beide separat XML-einstellbar → S-13-XSD + S-10 
(vorher W1 auflösen).
4. **KON53 + KON54** — Inter-Experiment-Fenster = volle bidirektionale Sync-Barriere (Drain-Quittung); Fortgang `--auto` (CI) ODER manuell ODER VERNEINEN; 
kill-OOB CLI→Planer→CEB; halb sauberer Stopp schreibt NICHTS Unvollständiges ins Lager; Stummphasen-Vokabular = {stop_ram_oob, stop_user_kill} → S-8 + 
S-10.
5. **Z15143-15283** — MeasureStorage, acht Owner-Festlegungen („volles GO, alles korrekt"): mmap · lineares Append-Log · kein Lock im Hot-Path · 
verifizierte Hauskonstante statt `std::hardware_destructive_interference_size` · gezieltes madvise(MADV_HUGEPAGE)+Pre-Touch · roh aufnehmen · ErgebnisMappe 
als Konsument; ZWEI Arenen (Mess append/monoton · Stack LIFO = Positionsanzeiger), getrennte Cachelines, zwei Fehlerklassen; ALLOKATIONS-VERBOT in der 
Aggregation → Arena-Bau E1-E10 (#18-Kernstück).
6. **Z14855-14921** — die Ursache: variadische Mess-Template-Variablen werden NICHT über Gattung+Genus metaprogrammiert durchgereicht ⇒ keine Arena-Init 
⇒ kein `flush()` JE ARENA GETRENNT ⇒ keine Signale am Dock — Metaprogrammier-Lücke, „zur Übersetzungszeit oder gar nicht" → E1-E10-Design.
7. **Z15248-15271** — Bestands-Fallen: ThreadArena/InMemoryMeasurementBuffer = Anti-Vorlagen; LIFOStackBuffer ist Queuing-Achse; IMeasurableWorkloadV3 = 
einziger allokationsfreier Mechanismus (0 Aufrufer); csv_to_latex → measure_to_latex ist MIGRATION mit Konsumenten, kein Neubau → #18 + #74.
8. **Z15517/K1** — Lagerbaum: ZWEI NEUE WURZELEBENEN `Gattung → Genus → Binary|Messung → REST` für ALLE Gattungen/Genera; kostet Pfad-Grammatik 
(lager_pfad_grammatik.hpp:527) + Tests + Wachen → #57 (führt sie nicht).
9. **Z16487/LAG-P2** — Bestandslog NICHT scharf: `mess_bestandslog_active=false` im Prod-Lauf; Restliste: 3 Deklarationen main.cpp ~:1112-1114, Belegung im 
gegateten Zweig, 3 pa.*-Zeilen ~:1349-1351, NEU `COMDARE_BESTANDSLOG_MESS_DOC_KEY` in die Planer-Forward-Liste (Child-Pipelines erben nicht) → #57.
10. **Z15482/OV-13 + K2** — Hybrid: Tier-Bau/-Laden IMMER durch die CEB delegiert; Standard-compare→release VOR dem Hybrid-Dock bewiesen; Loader in 
stufen-neutrale Bibliothek (CEB-Dock ≡ Hybrid-Dock bei Konfiguration) → #57(3)/HY-A.
11. **KON32-01** — measure-drop-Kanal: Owner genehmigte den IST-Verstoß NUR übergangsweise — zweifach heilen: Ziel-Filter UND per-Binary-xlsx (Code 
sendet result.csv, iterator:3089-3093) → S-13.
12. **KON27-02 + KON23-03** — Export-Element Option b (je FORMAT ein Eintrag FORMAT→ZIEL, LATEX+WAS, PDF-Block lazy) + vier ct-gesicherte 
Rückschrieb-Methoden (Csv/LatexTable/ComparisonMetrics/Xlsx; PDF außerhalb) → S-13-XSD.
13. **KON13-04/KON15-05** — Drei-Ziele-Struktur je XML separat; beide Caches S3 UND Filesystem; Runner LESEN nur ccache minio.comdare.de + Buildsystem-NAS 
(„mein letztes Wort"); Ziel 3 = nur Zusammenfassung/LaTeX/PDF + explizit angeforderte Einzelnachweise → S-13 + Abgleich KON67-Topologie.
14. **Z14784-14853** — SECHS STEUERDOCKS Planer↔CEB, passgenau je einkompilierte Messeinrichtung; zwei Rechtsakte (FREIGABE System-Achse / DURCHSETZUNG 
Organ-Achse); Release nur GESAMMELT vor/nach der Gesamt-Messung → S-8/S-10.
15. **KON42-01 + Z13999** — Default-Doktrin (constexpr-Planer-Defaults, XML überschreibt je Attribut) · Hybrid ZWEIWEGIG XML-steuerbar (Dock-Belegung ODER 
Synthese-Funktionen+Wirkbereiche ⇒ HY-A3 trägt beide) · `<hybrid>`-Schalter gleichrangig zu `<measurement_tooling>` + Hybrid-Meta-Meta = FAMILIE (je 
Reroute-Genus eine Achse, selbe Mess-Zeile) → S-8/S-13/HY-A3 (kein HY-Posten im Kopf-Board).
16. **KON43 + KON47-01** — Zielform-Pflicht AB SOFORT: S-8/S-9 in die Vier-Unterprojekt-Form, Ordnerschnitt VOR S-8; Planer-Unterprojekt = erster 
Monolith-Schnitt (#29a fehlt im Board) → W2-Struktur.
17. **KON16-03/18-01/25-08/17-02/17-01** — Emissions-Doktrin für S-12: KEINE YAML, zentrales C++23-Bau-Modul (Builder), Rakete rückwärts + ABI-stabil 
eingesteckt, Emissions-Abschluss = LAGER-Fund, Emissionsliste = volle Pipeline inkl. LINT+RELEASE+J-1…J-4; CEB-Bauten sequentiell (RAM) → #3 S-12-Design 
(mit W8 klären).
18. **Z15553/K5** — die vierte Mess-Ebene ist eine SPALTE der Macro-Stufe (Tier-Stempel je Funktionsaufruf); Overhead = Macro(Hybrid) − bekannte 
Einzel-Tier-Performance → Mess-Design + S-19-Input.
19. **KON37-02/-03** — B1 „direkt neu nach der geänderten Architektur, das alte archivieren"; `<measurement_tooling>` + Stufen-Dimension tier/hybrid/ceb; 
Korrelations-Pflicht Freigabe↔Ausführung; Anordnungs-Freigabe: beliebige Reihenfolge STATISCH freigegeben, je Stufe Subset von {Wallclock, Macro, Micro} → 
#24-B1/B4-Design.
20. **KON34-01/04 + KON40-02** — System B (17 Dateien, dormant, 0 Produktions-Aufrufer) trägt die Ordnungs-Maschinerie; B4 = 9 Kern + 8 Ripple = der 
fehlende Baustein „Steuerung → Compile" → #24-B4 (Kopf verbucht nur B2).

### Korb C — Bau-Trigger Mi 26.08. 06:00 + W3-Kampagne Sa 29.08.
1. **KON22** — VOLLBAU-GATE: „Lagerhaltung fertig UND Stempel fertig UND Algorithmen versioniert UND Messung einbaubar" — Gate-Prüfung als Vorlage VOR 
dem Trigger (Kopf kennt den Trigger, nicht das Gate).
2. **KON58-03** — HEAVY ist SIGNAL-GATED: das Handout ist KEIN Signal; für das 26.08.-Fenster muss das Signal GESENDET werden → Betriebs-Task Infra.
3. **KON41-01 + KON58-03** — OV-4-Mess-Deckel = f(T-3-Fenster): einlanig 41,4 h@24W → ~45,6 h@16W; KEIN amd-16W-Trace existiert; Deckel-Rechnung mit 
S-19-Zahlen VOR GO-Vorlage ##51 + Pflicht-Nachkalibrierung beim ersten 4096er@16W → #7-Ausgang.
4. **Z15403** — T-15×KF-10 = 9 Messungen je Zelle: die MESS-PHASE VERDREIFACHT sich (der Bau nicht); gehört in `--check-size` und die S-19-Rechnung → #7.
5. **KON47-04 + KON58-11(b)** — Warmup-PAAR-Pflicht (1× verwerfen, 1× warm speichern, ×3 = 6 Läufe/3 Werte; `--debug` 1× kalt): `run_observable_perm` 
misst KALT (perm_runner.hpp:207,213) — anpassen oder ausbuchen + Tests → vor Kampagne (keine Task-Nummer).
6. **KON37-06** — 5/5-Retry-Klammer: Build UND Messung dürfen JE 5-mal scheitern; 3 Wiederholungen einzeln persistiert → #13 T-15b.
7. **Z15411-15455** — T-15-Lücken: Granularität von „ganzen Lauf neu starten" UNDEFINIERT (Zelle/Batch/Tag/Kampagne); „bis zu 5 Wiederholungen" 
zweideutig (Drift-Rerun vs. dritte ungebaute Achse); T-15 ist kein CI-Gate → #13.
8. **KON26-04** — die 5 liegt FALSCH auf der Drift-Achse (ce 4cd1ab91): Umzug + 8-Punkte-Ripple; Arena-Formel muss den binaryweiten ×5 ZUSÄTZLICH decken 
→ #13 (+ W1).
9. **Z13762-13898** — Drift-Gate kennt KEINE Debug-Ausnahme (`RunMethodology` in drift_detector.hpp = 0 Treffer; Owner: „Prüfer … schaltet Debug daher 
ab") — sonst ist bei der --debug-Generalprobe ab 29.08. JEDE Zelle rot; Debug-Zahlen sind Ausschuss, NIE ins Messwertlager (Sperrform AdmissionStatus 
existiert) → Paket mit T-15/D4, VOR W3.
10. **KON29-04** — die Messung ist NICHT ZWEILANIG: `resource_group ceb-measurement-exclusive` hart amd/prod1; §61-Revision (`ceb-measure-<host>`, 21.07.) 
nie umgesetzt, Intel-Gegenstück fehlt; `window_belongs_to` gebaut, nicht verdrahtet → Bau-Posten VOR W3 (sonst fährt die Kampagne einlanig).
11. **KON28-02** — HART/SOFT: Achsen-Einstellungen failen IMMER hart; NUR fehlende Messeinrichtung (PMC) soft = Warnung in die xlsx, Binary WIRD gebaut → 
T-15b/#13-Klassifikation.
12. **Owner 17.07. (Z14455)** — Fehlerklassen PFLICHT für alle Achsen→Unterachsen→Algorithmen; Stand 0/18 bzw. 0/121 — ohne sie reißt ein Fehlen im 
Messfenster die Pipeline → T-13/T-14 vor W3.
13. **KON6-03 + KON2-09/2-13** — Skip-Ökonomie: der selektive Rebuild (perm_<id>.version) wurde 27.07. gelöscht (ce 813c3232); System-Änderung erzwingt 
heute Vollflotten-Neubau (ein Hash kennt keine Teilmenge); W12-B + bvset-Richtungs-ctest (A⊂B) → vor der Kampagne wiedergewinnen (trägt die Owner-Regel 
„HW-Erweiterung additiv").
14. **KON3-06** — Bestandslog-SKIP-Risiko: je binary_id EIN Eintrag, obwohl 320 IDs bit-identisch über die opt×simd-Matrix — ein SKIP kann falsch 
begründet sein → Wache vor Kampagne.
15. **KON58-04/#10 + KON56-01** — MinIO Ebene B: Keys geheilt, der GÜLTIGE Beweis fehlt (CI-SMOKE mit Beweiszeile + Gegenköder HART-ROT, im ruhigen 
Ein-Blech-Fenster; trägt er nicht: neue Keys) · Falle: `COMDARE_RUN_MEASURE` erzeugt `measure:golden-320` (timeout 10 days) und belegt den 
resource_group-Slot → Betriebs-Task vor Kampagne.

### Korb D — lebend ohne Frist-Anker (W1-Rest, Wellen, Prozess, Release)
1. **KON58-08 + KON59-02/NE-10** — S-3 GEBAUT (ce 4a89aed5), aber der KON55-Kombibau NIE gefahren (ctest-Starts NULL); Aktivierungs-Beweis „gebaut UND 
inert" je Seite mit ZWEI Zahlen; `bvset_ist_teilmenge` hat 2 PRODUKTIONS-Treffer → S-3-Abnahme W1-Rest.
2. **KON58-05/-10** — S-7-Bauplan (Registry-Typlisten-Nenner, synthetische Proben, per-Binary-Naht) + Fesseln P11→P4 · P6→P4 · P1→P2 · P3→P5 + 
Lande-Ordnung 1-9; sechs von elf Wellen-Posten (S-3, S-7, S-5, Layout-7, S-4, MinIO) ohne Kopf-Nachfolger → Wellenplan-Abgleich W1/W2.
3. **KON58-01/-07/-13** — Riegel-Betrieb: Änderung an 122 Trägern = Bump ODER Regen-Commit (30 Forwarder IMMER Regen); `--check` Exit 3 „REGEN 
ERFORDERLICH"; LANDE-AUFLAGE: nach JEDEM Merge `--check`+`--write`+`git diff`; 26 Alt-Home-Dateien bewusst aus dem Schnitt; Friktion beim ersten S-6-Paket 
MESSEN → Lande-Doktrin (trifft #15/#16/#18/#19).
4. **KON17-03/KON2-19 + KON27-01** — C-4-Wache deckt 6 Heuristik-Header, Schnittmenge mit axes/ = 0, ≥152 ungedeckt; Owner: modular splitten, EINE 
Detail-Klasse je Kategorie-Home; Home-SEMANTIK: EIN Wächter je Home, ZWEIstufige Versionierung (Interface- + Algorithmus-Version), „zuerst eine gültige 
golden Version" → ins F5-Homes-Fenster (Kopf kennt nur die Zahl DREI).
5. **KON55-01 + KON56-03** — Compiler = künftige SYSTEM-ACHSE: {clang, gcc} Basis-Pflicht CI+lokal; Ruling 17.07.: 5. System-Achse `gcc|clang`, Unterachsen 
opt/flags/commands, Default Ofast → S-9/S-11-Design + W7 (im Kopf nirgends).
6. **KON29-01/-03** — die vier CacheEngine-Modi als PHASEN (State-Pattern): 0 Code-Treffer — zu BAUEN; `work_mode` (Korb A5) ist die Typisierung; 
Debug-Löschung = einzige Ausnahme der Messdaten-Doktrin → W2/W3-Design.
7. **KON19-02/KON13-01 + KON21-01/KON36** — Hybrid = Transmitter/Multiplexer (je Thread EIN Tier, Werte gehen DURCH ihn), Glied der MESS-Kette; Autonomie 
zweistufig: jetzt CEB-orchestriert (AnatomyModuleLoader), später Sync-Kanal S-20 (NEUBAU) → HY-Design-Register.
8. **Z14663-14729** — die Kette hat 15 STATIONEN, nicht 8 (single bauen→messen→compare→release JE LAST, dann Hybrid-Vierer); COMPARE zweimal eigene 
Station; „Release" = Optimum je Last → Plan-/Memory-Nachzug (8-Stationen-Memory korrigieren).
9. **KON30-02/KON31** — Prüfling = drittes Konzept: Mess-Unter-Achse des Planers zur Laufzeit, gibt in der CEB Tier-Compiles frei, je Organ-Achse 
zusätzliche Algorithmen „mit eigenem Stempel und allem", XML-beschränkbar 1..3, ERWEITERT den Permutationssatz → S-19-Input + prt-art-Rolle.
10. **KON29-06/R-1 + KON20-04** — Auswahl-Subsystem (17 Dateien): Fortführungs-Entscheid FEHLT; K4 mess/-Subsystem ohne S-Position; K5 drei 
Skelett-Testverzeichnisse ohne Eigentümer → Explore, dann ggf. Owner-Vorlage.
11. **KON5-06 + KON49-03 + KON49-04** — #19-VORBEDINGUNGEN: zwei divergente Diff-Hygiene-Fassungen (super misst schwächer und druckt GRÜN — vor jedem 
main-FF die Wache lokal über den FF-Bereich fahren) + 13 ungelandete ce-Branches 02.-10.08. landen oder begründet ausbuchen; BRANCH-PFLICHT für Bau-Agenten 
(nie detached HEAD, Verify misst Branch+Store selbst) → vor #19.
12. **KON22/Kap. K + KON2-24/25** — PUBLIC-GANG-BÜNDEL: Prüfungsunterlagen-PDFs tragen Betreuer-Namen/@tu-dresden → Release-Checkliste; ce/NOTICE 
(„Apache 2.0") widerspricht ce/LICENSE (Dual); 5. Schalter `COMDARE_CE_ENABLE_ORIGINAL_CODE_VALIDATION` kopiert GPL-3 `wh.c` UNGEGATET; „BEP" für die 
Person VERBOTEN → Release-Checkliste vor jedem Public-Schritt.
13. **KON-40 + KON-42** — ADR-Grundgesetz-Register (25 Entscheidungen F1-F15+F-EXTRA, 04.05.) in den Ledger heben; §63-T: T-08 = es existiert EIN echter 
Mess-Lauf (16 Zeilen, 057ee3e5, 26.07.), T-19 bias-freie Vollmatrix nur Doku-Vermerk → W4-Thesis-Fundament.
14. **Z16345** — die aufgehobene Streichliste = NEUN lebende Bau-Posten (CEB-27 Hot-Switching · CEB-43+.so/<modules> · CEB-12 Wallclock-Vollausbau · 
CEB-34 · CEB-18 P/E · CEB-20 L2 · 33-Paper-Generator · Compiler-Toolchain-Permutation · CEB-19 Pinning); Kopf kennt nur zwei → W5-W7-Zuordnung.
15. **Z16388** — blockierende 09.08.-Entscheide ohne Kopf-Spur: D-5 (Bau- vs. Mess-Menge, Bestand widerspricht sich) · CEB-38 (CEB-Änderung = Vollrebuild?) 
· CEB-Identität A/B · std::variant-Fehlerklassen-Ausnahme → Explore ob beantwortet, sonst Owner-Vorlage.
16. **Z15887/Z16291** — Konformitäts-Register: 256 Owner-Aussagen, 17 % ERFÜLLT, hintere Stationen 14 %, Restaufwand +1564 h — keine Nachmessung seit 
09.08.; KON82 (51/51) misst einen ANDEREN Gegenstand → W4-Realitätsanker.
17. **Z14501 + Z14434** — Verifikationsvertrag V-1…V-8 lebt (Kopf-„V1-V10" aus KON80 = Namenskollision!); OV-Nummern sind kein Autoritätsbeleg (belegte 
OV-18-Kollision; Gegenstand im Roh-Transkript prüfen) → Register-/Vokabelpflege.
18. **KON59-02/NE-16/NE-20 + Karte-5-Bündel** — Wachen-Sammelposten W2: Inventar-Nenner (test_t6 kennt S-14a nicht) · drei allow_failure gegen Doktrin 
(arm64-smoke „advisory bis #179, danach HART", relock-manual, ergebnis:holen) · libs/ sieht sich NIE mit -Wall (1 Aufrufer) · `|| echo` schluckt Exit an 3 
appendix-Stellen · AF_CORPUS_ROOT tot · ZWEI PARSES eine Entscheidung (profile_run_facade:605 / profile_run_entry:948) · D2 fingerprint-UB + 
kHashes-Divergenz · Registrierungs-Wache fehlt · measure_selection 0 Treffer trotz „#11 erledigt" · `delete_p99_ns` fehlt (nur p50/p95) · docs/termine 
nie eingereiht · n/a-Inhalts-Gate (nur 1 von 3 Wachen fängt provisioned-Zeilen) · 289-Writeback-Variablen fehlen.
19. **KON58-04** — Infra-Reste: `COMDARE_NFS_DROP_TOKEN` fehlt (Ebene C inert) · `CE_SUBMODULE_TOKEN` fehlt (Planer-Emission bräche) · 
Registration-Token-Reset = Owner-Entscheid · „776" = gitleaks-Trefferzahl, keine ID → Infra-Handout Teil B.
20. **KON58-09/-12 + KON39 + KON38** — Prozess: v3.6 Opus ERHEBT / Fable BEWERTET (beide Pflicht) · v3.7 MAX DREI Vollbauten prod1 · v3.8 Wellen-Form 
(Merges seriell lokal, EIN Push, EINE CI) · Codex klein + zweiter Lens · ARBEITSWEISE liegt an ZWEI Orten (super = 53-Zeilen-Zeiger, Umbrella = 988 geltend) 
· Ledger-Nachtrag an die LANDUNG binden · Bauten setsid/nohup · CMakeLists-Hotspot: jeder Strang ans DATEIENDE · thematische Testnamen · vier 
/goal-Dokumente = Referenz-Hierarchie · KON38-Geltungsliste = Rückfallebene beim Memory-Widerruf → Prozess-Register.
21. **KON9-09 + KON13-03** — Owner-ABGABE-PFLICHT: definierte Syntax UND Semantik je Achsen-Kategorie über c hinaus („Pflicht und Basis für die Abgabe"); 
G-2-Semantik (System+Organ) in Reihenfolge der Achsen-Nummerierung; MIN = Querschnitt mit ZWEI Filtern (Mess zweischneidig) → W4-Pflichtposten + nach F5.
22. **Karte-4-Spitzengruppe** — je eigener W2-Prüfposten: KON-46 Retry-Policy 5/2/1 · KON-11/12 Drift-Gate-Wortlaut + n=1 · KON-36 fünf rote Dauer-Tests 
· KON2-19 Lock-Gate deckt 1 von 18 · KON2-20 Owner-Auftrag Stempel-Benennung · MT-L3 eingefrorene Orakel 0/29 · KON3-05/KON2-32 34× „BLOCKIEREND" nie 
gebucht.
23. **KON58-13-Nebenbefund + KON58-11** — offen ohne Anker: `-Wstringop-overflow` (libstdc++ via axis_06_allocator_exgen; Pragma-Schnellfix VERWORFEN) · 
28-vs-13 `\InputIfFileExists` (vor F5-Anhang-Gate) · Thesis ZWEIMAL als Submodul, beide Pfade leer · KON12-03/S-17-Einsortier-Pfad (setzt O-9 voraus; „0 
Aufrufer" teilwiderlegt — am Objekt neu messen) → Triage W2.
24. **KON26-03/KON27-05 + KON8-04 + KON2-06/17** — Bleib-/Soll-Notizen gegen Fehl-Abriss: PlanTextBuilder + plan dump + `visibility:tier-binaries` 
produktionskritisch; System-Achse sitzt IN der CEB (kein Quer-Freigeber neben der Kette); drei Versionierungs-IST-Lücken (Planer ohne SHA · CEB-System-Anteil 
leer · Genus 5 handgeschriebene Literale) → Design-Register + W2-Bau.

---

## 2) WIDERSPRUCHS-LISTE (je eine Auflösungs-Empfehlung)

- **W1 · Arena/6 GB:** XML-einstellbare Warn-/OOB-Schwellen auf Messdaten (KON51-02/KON52-01) vs. „ARENA 6GB FEST, STATISCH, Planer-Reservierung" (KON93) 
vs. Arena-Formel muss ×5 zusätzlich decken (KON26-04) vs. Faktor-Widerspruch 2-vs-18 (KON73). **Auflösung:** KON93 (jüngstes Owner-Wort) gilt für die 
GRÖSSE; Warn-/OOB-KOMMANDO-Semantik ist ein anderes Objekt und bleibt; der laufende 10-Wochen-Explore (KON93) führt ×5 und 2-vs-18 als Prüfpunkte mit — 
S-13-XSD erst nach dessen Karte. Kein Owner.
- **W2 · Mess-Nenner:** statische 32 als S-19-Multiplikator (KON25-03) · CEB-Reihe 5→6→12 + „24 oder 48 offen" (W-3/E-5) · 4!-Rekombinationen (Z14220) 
vs. „Mess-Permutation DYNAMISCH >32, NUR S-19 rechnet" (KON71, dritte Rüge). **Auflösung:** KON71 gewinnt; alle statischen Zahlen sind Eingangs-Hypothesen 
für S-19 (#7); ÜBERHOLT-Marker an die Kapitel-E-Stelle; „24 oder 48" wird S-19-Ausgang — Owner NUR, falls S-19 sie nicht determiniert.
- **W3 · Mess-Ebenen 3/4/5:** „fünf zu messen" (Z14763) vs. „4 statt 3" (K5/Z15562) vs. Kopf w/ma/mi + PMC-Meta-Meta. **Auflösung:** per K5 (Owner): 
drei Ebenen, die vierte = SPALTE der Macro-Stufe beim Hybrid, PMC = Meta-Meta, keine Ebene; die Fünf-Formel war bereits als gegenstandslos markiert — Marker 
an alle drei Zählstellen. Kein Owner.
- **W4 · Lastsequenz:** „gehört IN die framework-Mess-Achse, einsortiert" (KON37-05, Owner) vs. „EIGENE Mess-Achse" (KON64/65). **Auflösung:** jüngeres 
Owner-Wort gewinnt (KON64/65); ÜBERHOLT-Marker an KON37-05; der 10-Wochen-Explore vor Design läuft ohnehin.
- **W5 · „System-Achsen final drei" + 3/2/2-GESETZ (05.08., Z15696)** vs. PMC eigenständig / doppelte HW+SW-Versionierung (KON64-72) und 
Compiler-System-Achse (KON55/56). **Auflösung:** das Stufigkeits-GESETZ 3/2/2 lebt (PMC ist dreiphasig — bestätigt es); die MENGE „final drei" ist durch 
jüngere Owner-Worte (Compiler-Achse, Meta-Metas additiv) überholt — Marker setzen. Kein Owner.
- **W6 · HW-Erkennung:** zweigeteilte MESS-Achse Planer grob/RT + CEB fein/CT, Realm „bindend" (KON-03, 27.07.) vs. „Planer-HW-Erkennung NUR für PMC, 
System-Achse=Proxy" (KON64/65-F2). **Auflösung:** jünger gewinnt; die bindend-Klausel an KON-03 mit Marker auf die neue Realm-Verteilung nachziehen.
- **W7 · Parallel-Deckel:** „VOLLES GO maximal parallel" (KON73) vs. „MAXIMAL DREI GLEICHZEITIGE VOLLBAUTEN prod1" (v3.7, Owner). **Auflösung:** 
verschiedene Gegenstände (CI-Job-Concurrency vs. lokale Vollbauten); BEIDE gelten; Vorbehalts-Marker an KON73 („unbeschadet v3.7"). Kein Owner. (Beleg der 
Kosten: 2,9 G freie Platte = drei stumme Agenten-Tode, KON49-04.)
- **W8 · Keine YAML vs. CI-DUAL/S-12:** KON16-03/18-01 (Kette emittiert Prozesse) vs. #3 S-12 „je Trägerstufen-Mini-Pipeline". **Auflösung:** Werkstatt-CI 
(Bau des Frameworks) ≠ Trägerketten-Emission; das S-12-Design muss die Naht explizit ausweisen — Owner-Frage NUR, falls S-12 wirklich GitLab-YAML je 
Trägerstufe emittieren soll (erst Design-Explore).
- **W9 · Lager-Inhalt:** „Die Lagerhaltung lagert MESSDATEN, nicht Binaries; kein Vorhalten" (Owner, Z14289) vs. „Binaries→Lager GEBAUT" (#48) + 
K1-Binaries-Zweig. **Auflösung:** Explore am lager_baum_writer: Binaries-Zweig = Buildsystem-Cache-/Adress-Ebene, kein Platten-Vorhalten; die 
Kapazitätsaussage bleibt bindend. Kein Owner, wenn der Explore die Pfad-Semantik belegt.
- **W10 · `--debug`-Ende:** „bleibt an bis zur Abgabe" (KON28-01) vs. „fällt bei T-3" (KON37/KON41-01, Kopf). **Auflösung:** T-3 gewinnt (jünger); 
Marker AM ORT (KON28-01 + Kapitel E), nicht nur im Index.
- **W11 · Change Date:** ~11.08.2031 (KON22-01/Kap. K) vs. 10.08.2031 FINAL (KON60/#56). **Auflösung:** 10.08.2031 (jünger, als FINAL markiert); 
Segment-Marker setzen — lizenzwirksam.
- **W12 · Dock-32:** „Obergrenze aus gemessenen Break-Even-Grenzen, bei Hybrid-Anforderung IMMER in der XML, Default 32" (K5) vs. „die einzige feste 32 = 
willkürlicher Dock-Deckel, W7-Anpassung" (KON41-03/KON71) + V7 (Break-Even NUR über Organ-Parameter der w/ma/mi). **Auflösung:** Deckel-DEFAULT ist 
willkürlich (dreimal gerügt, jünger); die XML-Pflichtangabe bei Hybrid-Anforderung bleibt; K5-Text per V7 nachziehen. Kein Owner.
- **W13 · CEB-Erreichbarkeit:** OV-10 „max. 4 erreichbar" vs. SECHS Steuerdocks (3!). **Auflösung:** nach der gebauten B2-Gate-Trennung (KON72/74) am 
Objekt messen, ob 6 baubar sind; Owner-Vorlage nur bei Rest-Diskrepanz.
- **W14 · T17 vs. ORG-19:** „Festplatten-IO = NEUER additiver Typ, T12/T17 unangetastet" (KON26-01) vs. ORG-19 = erste Organ-Meta-Meta + erste 
required-Deklaration (KON80-V10/KON91). **Auflösung:** V10 (Owner) gewinnt; Explore, ob `persistence_target` (T17, OFF) daneben bestehen bleibt oder aufgeht; 
Marker.
- **W15 · Repo-Rollen:** super = „WAS + Auswertung" (KON-41, Owner 04/05) vs. „ce=Framework, super=Einstieg" + #74 verschiebt Auswertungs-Werkzeuge nach 
ce (KON73-F6). **Auflösung:** F6 (jünger, Owner-Runde) gewinnt; im #74-Design ausdrücklich ausweisen, dass Auswertung aus super wandert — kein stiller 
Umzug. Kein Owner.
- **W16 · `checkpoint_measure`-Name:** „Erfindung, endgültig belegt" (09.08., dreifach) vs. KON60(iii) „Wallclock = CEB-seitiger 
checkpoint-measure-Wrapper". **Auflösung:** kein Sachwiderspruch — der Owner hat den Namen am 14.08. NEU vergeben (aus Behauptung wurde Entwurf); 
Ein-Satz-Vermerk an KON60(iii). Kein Owner.
- **W17 · Backup-Ref:** KON22-02 „KEINE Löschung vor der Lieferphase" + BEFUND 3 (pre-secret-scrub-Ref auf beiden Origins weg, Bundle unauffindbar, 
ungebucht) vs. KON93 „V9-Löschung vollzogen, Bundle zuerst, Gegenprobe 0/0". **Auflösung:** Explore: Identität pre-secret-scrub-Ref ↔ V9-rescue-Ref 
feststellen + Bundle-Ort/Inhalt verifizieren; Owner NUR bei Nicht-Identität oder fehlendem Bundle.
- **W18 · merge-Zeile:** Owner-Verbot „darf nicht existieren" (KON-05, 02.08.) vs. LEDGER:8941 führt denselben Gegenstand als OFFENEN Bauauftrag 
(§59-MERGE-STEMPEL). **Auflösung:** das Owner-Wort steht; Zeile 8941 AUSTRAGEN, bevor jemand den verbotenen Bestand baut — Trigger-Risiko 26.08. Kein neues 
Owner-Wort nötig.

**Echte Owner-Fragen (kein Explore löst sie):** (a) **KON3-03** — XML-Wache: zwei nachweislich unbeobachtbare Zweighälften, Frage „zulässig?" seit 
Wochen unbeantwortet; (b) **E-5 + K4 (Z16005/Z15076)** — kanonischer Kurven-Stack (sonst entscheidet §75 implizit) und das nie gestellte K4, GETRENNT 
vorlegen; (c) **Registration-Token-Reset** (KON58-04, je Projekt vs. instanzweit). Bedingte Kandidaten nach Explore: W2-Rest (24/48), W8, W13, W17, 
T-15-Granularität (C7), Z16388-Entscheide.

---

## 3) VERSTÄNDNIS-KERNE (30 Sätze, die der Kopf voraussetzt, ohne sie zu wiederholen)

1. **KON43** — Vier Träger in Baureihenfolge: „erst den Planer, dann die CEB, dann die Tier-Binaries und dann Hybrid. In der Reihenfolge und nicht 
anders"; vier Unterprojekte, N+1 hängt nur von N.
2. **KON9-01/KON13** — ORT ≠ ZEIT: Ort Planer→CEB→Hybrid→Tier, Zeit Tier bauen→messen→Hybrid erzeugen; aus dem ORT-Satz folgt KEINE Phasigkeit.
3. **KON13-01** — Phasigkeit MESS 3/4 · SYSTEM 2‖2 · ORGAN 2; der Hybrid ist Glied der MESS-Kette, „weil das Hybrid nicht bauen kann, sondern nur 
Tier-Binaries messen".
4. **KON16-03/17-01/18-01** — KEINE YAML: der Planer emittiert Pipe/Prozess über EIN zentrales C++23-Bau-Modul (Builder); nur der Planer wird direkt 
kompiliert; einzige Nicht-C++-Träger: CMake.
5. **KON25-08** — die Träger-Rakete wird RÜCKWÄRTS aufgebaut; jedes fertige Modul wird ABI-stabil in die vorhergehende Stufe gesteckt.
6. **KON17-02 + KON9-11** — die Emission ist erst abgeschlossen, wenn die Binaries IM LAGER liegen; von den fünf Stempel-Rollen sind nur zwei durchgesetzt 
— Lager-/Skip-/Cache-Rolle liegen auf dem kritischen Pfad.
7. **KON16-06/KON8-05** — DREI Flächen: Genus-Interface · Stempel (trägt die Systemachse inkl. Tools/Compiler) · measurement-Durchstich („damit 
Gattung+Genus-Interfaces unverändert bleiben"); der Stempel wird nicht geschrieben, er FÄLLT AN (B+-Baum-Materialisierung).
8. **Kapitel C/KON58-13** — Fehlerklasse Nr. 1: Änderung ohne X.Y.Z-Bump ⇒ kein Neubau ⇒ „schneller UND falsch" — „braucht ein Werkzeug, nicht 
Disziplin".
9. **KON-04** — „Eine Binary hat KEINE eigene Versionsnummer": Identität = Haupt-Achsen-Rekombination + Algorithmus-Versionierung; eine eigene Nummer 
bricht den SHA512-Lookup.
10. **KON2-06** — Versionierungs-SOLL: Genus ct-zusammengesetzt aus ALLEN Achsen · Planer X.Y.Z · CEB nur Mess+System · Tier/Hybrid alles; alle vier 
Binary-Typen tragen einen Fingerprint-SHA.
11. **KON21-02/KON19-03** — Wahrheits-Schichtung: der CODE ist die Wahrheit für die FREIGABE, die XML für die REALISIERUNG; std::variant verboten; jede 
Binary = Teilmenge des Codes; EINE rekursive Einstiegs-XML — „die XML Syntax bildet eine Programmiersprache".
12. **KON27-01** — Home-Prinzip: je Achsen-Kategorie ein Home mit GENAU EINEM Wächter; zweistufige Versionierung (Achsen-Interface-Version UND 
Algorithmus-Version); „Wir beginnen aber zuerst mit einer gültigen golden Version".
13. **KON16-02** — die zwei Flag-Seiten: FREIGABE impliziert, COMPILE-Seite FORDERT Hardware; dreiphasig zusätzlich der Messfühler-Vertrag; beide Seiten 
gebaut und inert ⇒ S-3/S-7 sind AKTIVIERUNGS-Aufträge.
14. **KON9-05/KON25-01** — Flag-Grammatik v2: `c{p.e}` — p/e nur als Sub-Flags unter c, flache `cp`/`ce` werden per static_assert abgelehnt; Kürzel IMMER 
zerlegen.
15. **KON25-07/KON30-02/KON31** — drei Konzepte, nie vermengen: STUFE (Binary) · PHASE (vier Modi, State-Pattern — 0 Code-Treffer, zu bauen) · PRÜFLING 
(Mess-Unter-Achse mit eigenem Stempel, 1..3 Varianten).
16. **KON34** — zwei Mess-Architekturen: System A live, System B dormant (dort die Ordnungs-Maschinerie); B4 = „Steuerung → Compile"; die 6 zählt 
Ordnungen einer ortsfesten Vollmenge, die 32 An/Aus verteilter Einrichtungen — „die CEB misst UM das Tier herum, das Tier misst IN sich".
17. **NAHT-1/Z14926 + Z14251/K5** — die Messung gehört IN die Naht: Mess-Visitor am Genus-Interface, zweiseitige UND-Aktivierung, zero-cost bei aus 
(Sidecars falsch); der Messfühler ist Verbraucher („Was er kostet, misst er mit") und Overhead ist eine DIFFERENZ, kein Messkanal.
18. **KON47-04/KON37-06** — paarweise messen: 1× verwerfen + 1× warm speichern, ×3 = 6 Läufe/3 einzeln persistierte Werte; `--debug` 1× kalt; Build UND 
Messung dürfen je 5-mal scheitern.
19. **KON50-52** — Kanal-Semantik: genau EINE OOB-Nachricht (das Fertig-Signal), „weil Zwischen-Signale Latenzen erzeugen, welche Messwerte verfälschen"; 
Steuer-Naht gefiltertes XML, Mess-Rückweg sparse binary; NIE Mess-Rohdaten zum Planer.
20. **KON53/54** — die Barriere zwischen Teil-Experimenten ist die einzige Steuer-Gelegenheit (Drain-Quittung, --auto in CI, Verneinen/kill erlaubt); der 
halb saubere Stopp schreibt nichts Unvollständiges — „Ja das Lager heilt das".
21. **KON28-02** — HART/SOFT: „Die Einstellungen der Achsen failen immer hart", nur fehlende Messeinrichtungen (PMC) soft — Warnung in die xlsx, die 
Binary wird trotzdem gebaut.
22. **KON29-01/KON34-05** — zwei Betriebsstufen: `--debug` (parallel-maximal, Zahlen = Ausschuss, einzige Ausnahme der Nie-Löschen-Doktrin) → echte 
Messung 1 Thread; `--debug` ist STRENG DISJUNKT von den Mess-Schaltern (die ändern Kompilat und Stempel).
23. **KON22 + KON17-04** — Vollbau-Gate: „Lagerhaltung fertig UND Stempel fertig UND Algorithmen versioniert UND Messung einbaubar"; Bau-Reihenfolge 
danach: Stempel → Planungs-Simulation → von der XML die GESAMTE Kette bis zur PDF — S-13 ist KERN, nicht Anhang.
24. **KON30-03** — S-19 rechnet, schätzt nicht: Achsen im Planer gruppieren/kategorisieren, dann über den gesamten Experiment-B+-Baum — „Abstufungen, 
die wir ohne Programm nicht abschätzen KÖNNEN".
25. **KON-09 + Z14289** — der Massenanfall ist gewollt („zehntausende … in Ordnung so"), weil dynamisches Laden Lade-Latenz erzeugt und Messwerte 
verfälscht; Tier-Binaries werden NICHT vorgehalten (RAM hot → verworfen), gelagert werden Messdaten.
26. **KON-47/KON2-09/2-13** — Hardware-Erweiterung ist ADDITIV (Neubau nur bei Funktionseinschränkung); ein Hash kennt keine Teilmenge ⇒ Skip braucht die 
LESBARE Version (W12-B); „1 vor 2, weil ein Hash keine Teilmenge kennt. 2 vor 3, weil Bump-Disziplin ohne Gate nur Buchhaltung ist."
27. **KON-63/KON-32** — PRT-ART ist der Prüfling und KONSUMIERT die CacheEngine; die Produktionskante läuft einseitig ce→prt-art, die Rückkante 
existiert nur artefakt-isoliert in einer Teststufe — wer sie „repariert", löscht die Teststufe.
28. **Owner 09.08./W0b** — Wachen sind Google Tests (Debug UND Release): „Skripte sagen gar nichts"; ein Test, der die Mutation in der geänderten Datei 
nicht fängt, ist für diese Sache kein Test.
29. **Z14330/W-9/W-4** — „Wir streichen nichts": ein Posten verlässt den Plan nur mit zitierbarem Owner-Satz zum GEGENSTAND; OV-Nummern sind kein 
Autoritätsbeleg; neuere Fakten schlagen ältere — und wer einen Punkt schließt, schließt ihn an der SPITZE mit.
30. **Z14663 + Z14518/Z15641** — die Kette hat 15 Stationen (compare zweimal, „Release" = Optimum je Last, Single vor Hybrid zwingend); die csv ist das 
KIND der xlsx; neue Allokationen in der Messwert-Aggregation sind VERBOTEN.

---

## 4) BILANZ

| Kategorie | Zahl |
|---|---|
| Lebend-aber-im-Kopf-unsichtbar (roh, 5 Karten) | ~230 Einzelbefunde |
| … konsolidiert in dieser Karte | **73 Posten** (A 14 · B 20 · C 15 · D 24) |
| davon berühren F2 Fr 21.08. | **14** (Korb A) |
| davon berühren W2-Bündel Di 25.08. | **20** (Korb B) |
| davon berühren Trigger Mi 26.08. / W3 29.08. | **15** (Korb C) |
| Widersprüche ohne tragenden Marker (roh 27) | **18 konsolidiert**: 12 per „jüngeres Owner-Wort + Marker", 6 per Explore; echte Owner-Fragen: 3 unbedingt 
+ ≤6 bedingt |
| Überholt-Bestand (segment-intern + durch Kopf) | **~150 Posten** (K1 37 · K2 42 · K4 45 · K5 28; Doppelzählungen abgezogen ~145) |

**Deckungsgrad:** Wo die Karten Nenner tragen (KII/KIII: 63 von 120 unsichtbar; KIV: vergleichbare Quote), deckt der Kopf KON60-93 nur rund die HÄLFTE der 
geprüften Altsubstanz — bei den geschlossenen Owner-Doktrin-Blöcken (Kanal-Doktrin KON50-54, MeasureStorage-Festlegungen, Emissions-Doktrin, Vollbau-Gate, 
Steuerdocks) liegt die Kopf-Deckung bei NULL. Warnzahl KON59: von 538 Erledigt-Behauptungen hielten nur 58 % voll. **Empfehlung:** ein Kopf-Nachtrag (KON94) 
übernimmt mindestens Korb A vollständig + die 18 W-Marker; Korb B/C wandern als Task-Karten-Ergänzungen in #18/#13/#7; Korb D als W2-Triage-Block neben #71.