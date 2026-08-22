# KONTEXT-UEBERGABE K29 -> K30 (Sa 22.08.2026 ~17:00) — Lande-Zug LAEUFT (4/10), CI-Dual-Befund

Owner-Order: "Bitte erstelle eine reiche Kontextuebergabe, der kontext endet jetzt."
Leseordnung im neuen Kontext: (1) diese Uebergabe VOLL, (2) KIPP-RITUAL NEUE FORM (Owner
22.08.: /goal-Trio NIE mehr voll einlesen! NUR ARBEITSWEISE-GESAMT-DOKTRIN voll + ALLE
Memory-Dateien der letzten 3 Tage voll — memory/feedback_nach_jedem_compact_...md traegt
die Regel), (3) Ledger-Kopf (juengste KON; A4-Nachtrag e6c90277 = juengster Eintrag),
(4) KONSOLIDAT-6K.md VOLL (851 Z., ~/backups-workflow/20260822-6k-sweep/ — H-01..H-36,
B-01..B-20, F-01..F-17, Hauptstrang-Kompass) + HEILUNGS-LISTE-2.md (20260822-anschluss-
leser/, H2-01..H2-11 alle BEHOBEN). Vollleseregel gilt (alle Rueckkehrer IMMER voll).

## 1. LAUFENDE WORKFLOWS (NICHT neu starten — Resume-Rezepte unten!)

- **LANDE-WORKFLOW wf_b546634b-3f5 (Task wqmzbglvo) LAEUFT** — sequentielle Landung ALLER
  ungelandeten Strecken (27 Ziele), EIN Schreiber an /home/comdare/wt-ce-lande (Branch
  lande/w2-s1s2), Bauslot slot2. Stand bei Uebergabe: **4/10 ce-Merges vollzogen**
  (881d1a15 s19 · 61d5d139 messfenster · bc056106 s8kopf · b283f86c s13schema @ c76d3116
  = der KORRIGIERTE H-02-Tip). Ref-Sicherung origin lande/w2-s1s2 @ bc056106 (ci.skip;
  nach b283f86c-Merge erneut sichern lassen). Journal = Wahrheit:
  ~/.claude/projects/-home-comdare/5a19728e-*/subagents/workflows/wf_b546634b-3f5/journal.jsonl
  Script (fuer Resume nach Riss): ~/.claude/projects/-home-comdare--claude-projects--home-
  comdare-memory/5a19728e-*/workflows/scripts/lande-zug-sequentiell-wf_b546634b-3f5.js
  -> Workflow({scriptPath, resumeFromRunId: "wf_b546634b-3f5"}). Cache: sollist/inventur/
  plan/Z01 fertig; Lande-Ziele laufen live. Soll-Ist liegt: 20260822-lande-zug/
  wellenplan-soll-ist.md (56 gelandet/94 offen/21 gestrichen) + inventur.md + Z01-Z03-Ordner.
- **Anschluss-Leser wf_94813666-6d3 TERMINAL 9/9** (alle 6 Heilungen BEHOBEN); P12/#114
  terminal (BEWEIS.md abgenommen, E07_GATE=GO). Keine weiteren Agenten.

## 2. REPO-/CI-STAENDE

- ce/development = f729b93a (CI 16088 SUCCESS, volle 27-Job-Matrix inkl. clang-Strecke).
  Floor-Anker 524/520/518. Lande-Zweig lokal b283f86c (s. oben).
- super/development lokal = e6c90277 (A4-Ledger-Nachtrag, UNGEPUSHT — faehrt mit dieser
  Uebergabe per ci.skip mit); beide Remotes = 93542880; davor 38fd6270 = T2-docs-Zug
  (AB-02-Marker + AB-05 + AB-06, auf BEIDEN Remotes).
- prt-art dev 777fff7 · bau/pinduo @ 25bbf2e FUEHREND (T9-Fixup vollzogen, 224/224) ·
  B14 3710ac4c dahinter (Rezept #107). CAVE Lande-Zug-Inventur: Hauptklon-Submodul-Stand
  ce STALE (lokal d11781fa) — vor Phase 3 fetchen.
- ce bau/o2-standard @ fa48a551 == origin (E-7-Landeziel; O3-Waehlbarkeit erhalten).
- Board bis #132 (NEU: #131 = Lande-Zug-Fahrplan · #132 = envoy-CrashLoop-Infra-Task).
  Ledger-Kopf: NACHTRAG-zu-KON120-02 (A4) > KON121. KON122 faehrt AN der Landung
  (Phase 5; Pointer: 20260822-lande-zug/LEAD-POINTER-kon122-e6-zeilen.md).

## 3. 🔴 OFFENER PRUEFAUFTRAG (Owner-/btw K29-Ende, WOERTLICH): MERGE-FULL-JOIN-VERIFIKATION

Owner: "Und du bist dir ganz sicher, dass der merge wirklich einen full join faehrt und
nicht immer nur eine der beiden Seiten als aktuell deklariert und einfach uebernimmt?"

🟢 FORK-ANTWORT (K29-Ende, Objekt-Beweis fuer die ERSTEN 5/10 Merges — Fork "und-du-bist"):
JA, echte Voll-Unionen, keine Seiten-Uebernahmen. Drei unabhaengige Messungen: (1) ours/
theirs-Detektion 0/5 (kein Merge-Tree == Eltern-Tree); (2) Blob-Erhaltung beidseitig, 517
Datei-Pruefungen — einzige Abweichung pmc_event_biss.hpp = deklarierte ADDITIVE A2.1b-
Portierung des dev-PMC-Fixes (kPmcKoederFenster=5, "damit BEIDE Verbraucher identisch
urteilen"), nichts entfernt; (3) Testregistrierungen streng monoton 378->380->381->383->
386->388, Stichproben-Namen beider Seiten vorhanden. Nebenbefund positiv: Workflow faehrt
Harmonisierung als EIGENE Commits (96a69ba3 B06xS13-Kreuz-Luecke). Stand-Delta: Workflow
war bei Fork-Messung schon 5/10 (pmcpaket gemergt). DIE PROBE UNTEN BLEIBT PFLICHT fuer
die Merges 6-10 + Endstand.

EHRLICHE LAGE (Stand vor dem Fork-Beweis): (a) Merges 1-2 (s19, messfenster) hat der Lead selbst als VOLL-BLOCK-UNION
harmonisiert — beide Endsektionen der Konfliktflaeche tests/unit/CMakeLists.txt KOMPLETT
uebernommen (git show HEAD:<datei> + <tip>:<datei>, beide Bloecke aneinandergefuegt,
Marker=0, test-Namen beider Seiten vorhanden). (b) Merges 3-4 (s8kopf, s13schema) fuhr der
Workflow-Agent nach demselben REGELN-Rezept — SEINE Harmonisierung ist noch NICHT
lead-verifiziert. (c) Auto-Merges ausserhalb der Konfliktflaechen sind git-Union per
3-Wege-Merge, ABER: A2.1b sagt "Auto-Union = Anfangsverdacht".
PFLICHT-PROBE AM ENDSTAND (objektiv, deckt alle 10 Merges — in den Endstand-Schritt des
Workflows einfordern bzw. Lead-seitig nachmessen):
  1. ctest -N am Endstand: JEDER Test JEDES gemergten Strangs muss existieren (Union-
     Nenner: Strang-Solls 512/511/513/... aus den Audit-Berichten; Endstand-Soll
     ~529er-Klasse laut S2-SYNTHESE — EINMAL live messen, NIE Deltas addieren [H-7]).
     Fehlt ein Strang-Test => eine Seite wurde verworfen statt vereinigt.
  2. Je Merge-Commit: git show <merge> --stat gegen den Strang-Diff — 0-Datei-Merges oder
     Merges, deren Datei-Menge deutlich unter dem Strang-Diff liegt, sind Verwerf-Verdacht.
  3. grep-Stichprobe je Strang-Leitsymbol am Endstand (z.B. test_s19_simulation_rechnung,
     test_t15b_retry_warmup_paar, traeger/planner-Pfad s8kopf, S13-Export-Symbole,
     pmc_raw_event_katalog, paper_pruefling_registry, e07_gate_kriterien, test_c13/c14,
     kampvor-Kriterien) — jedes muss treffen.
  4. K17-Endstand-Kombibau 4 Zellen + volle 7er-J-1-Liste = die Kompilier-Wahrheit.

## 4. CI-DUAL-BEFUND (Owner-Verdacht BESTAETIGT, 22.08. gemessen)

- **super: clang laeuft NIE** — build:clang traegt #273-CLANG_MATRIX-Ausschalter
  (CLANG_MATRIX!=1 => never; 14x when:never in der YAML). HEILUNG FERTIG: bau/cidual @
  223ab518 (R1+R2), landet in Phase 2 des laufenden Zugs.
- **ce: Matrix existiert, ABER Stage-Luecke** — build:clang when:on_success OHNE needs =>
  bei JEDEM lint-Rot (16069, 16085: lint:static) wird die GESAMTE clang-Strecke geskippt,
  waehrend test:unit (needs: lint:secrets, DAG-befreit) laeuft. Asymmetrie: gcc beweist,
  clang schweigt in roten Pipelines. FIX-Kandidat in #106-Metadata verbucht (build:clang
  needs-Befreiung wie test:unit; Di-25-Zug mit #3).
- Gruene Pipelines 16088/16073: 4-Zellen-Matrix lief VOLL (27 Jobs, build:clang+
  test:unit:clang+clang:debug success).

## 5. K29-VOLLZUEGE (fuer KON122-Buchung; Belege je in ~/backups-workflow/)

- Nachverbuchung 6 unverbuchter Workflows (20260822-nachverbuchung/): W1L-Landung war
  KOMPLETT in dev (#113 completed: ee8abb86+65c51eeb -> Heilungskette -> f729b93a CI 16088);
  W2-RE-VERIFY 14x SITZT (wf_f3f75b60); 2 Gegenlese-Gates TRAEGT_MIT_FIXES (Synthese-
  Korrekturen G1-G9/H1-H5 additiv gesetzt); variant-Riegel #117 GELANDET (Test #519).
- #114/B10 KOMPLETT: E07_GATE=GO (BEWEIS.md 212 Z. voll abgenommen; Koeder rot-zuerst,
  golden 832 sha256 identisch). VORBEHALT: E07-Q1-Re-Run (<1h, BEWEIS.md Par.9) auf der
  FINAL eingefrorenen Trigger-Linie — haengt an #131-Endstand.
- Anschluss-Leser: Fenster 83684-84707 voll; Kernfund VIER-QUELLEN-FALLE (7/9 Owner-
  Nachrichten nur als queue-operation/enqueue — user-only-Extrakte zeigen falsches
  Owner-Schweigen); verankert in Fallen-Register + Extraktor-Referenz (DRITTE KORREKTUR)
  + MEMORY.md; Referenz-Skript extraktor-vier-quellen.py.
- Memory NEU: feedback_sequentiell_landen_cache_je_schritt_nie_gleichzeitig_mergen.md
  (O-6/O-8 verbatim; O-7 ueberholt — Verbot trifft NUR "gleichzeitig", Umfang NIE kuerzen;
  build-b10-Klasse-Ausnahme) + feedback_nie_uninformiert_mergen_oder_bauen_explore_pflicht.md
  (O-9: vor JEDEM Merge/Bau Explore strukturell+design+historisch) + Kipp-Ritual-Aenderung.
- Board: #132 envoy angelegt; #121-Vorab-Pflicht gesetzt (3 Thesis-Hashes von GITHUB
  fetchen — GitLab-main 26 Commits zurueck!); A4-Ledger-Nachtrag e6c90277.
- R-TAFEL-V2-WIEDERVORLAGE liegt: ~/backups-workflow/20260822-r-tafel-vorlage/ (R1-R8 mit
  vollem Kontext + 12W-Explore-Grundlagen + G-1-Doppelbestaetigung F-G1-8/F-G1-9; R0
  existiert nicht — Tafel ist R1-R8).

## 6. OFFENE OWNER-EINGAENGE (12; E-7-Minimalantwort-Vorlage nach Lande-Bilanz bauen)

R1-R8 (=F-01..F-08, Wiedervorlage liegt) · 🔴 F-02/R7 Enum-Ordnung VOR Mi 26 06:00 ·
🔴 F-09 S-19-SCHEMA-Fragen (<n_ops>/<drift_gate> ins Schema? Mess-Teilmengen-Traeger?
NICHT die Compiler-O2/O3! — vor Di-25-Schema-Schnitt) · F-10 Root-Neustart-GO ("morgen
dann"=22.08., ueberfaellig) · F-13 Codex-14-Klassen-Scope (EINZIGE main-FF-Restbedingung) ·
F-16 3 Thesis-Auftraege aus 728fc74 · F-18 D-08-ABI (Owner-Vorlage F01-F17.md) · F-19
#91-E-Punkte · G-1: nur noch 2 Bestaetigungen (F-G1-8 PMC dreiphasig, F-G1-9 Lastsequenz
eigene Achse).

## 7. FRISTEN + NAECHSTER SCHRITT IM NEUEN KONTEXT

Fristen: Di 25 Schnitt (#3/#18/#48/#57/#105/#99/#96/#106-R3-10; F-09 vorher!) ·
**Mi 26 06:00 TRIGGER** (davor: #131-Endstand + E07-Q1-Re-Run + D-08-Design/#91-Entscheide
[H-23, TRAEGERLOS in Ausfuehrung!] + #38a2/#86-Bau + R7-Antwort) · Sa 29 Kampagne (davor
I-8) · Di 15.09. Abgabe.

NAECHSTER SCHRITT: (1) Kipp-Ritual NEUE FORM fahren (Abschn. 0). (2) Lande-Workflow-Stand
messen (Journal + Zweig-Tip; bei Riss: Resume-Rezept Abschn. 1; Merges NIE doppelt fahren —
Explore-Pflicht findet Vorgefundenes). (3) Rueckkehrer voll lesen. (4) Merge-Full-Join-
Probe (Abschn. 3) am Endstand einfordern/nachmessen. (5) Nach Zug-Bilanz: E-7-Owner-
Vorlage (Abschn. 6) + KON122 + Soll-Ist gegen Designplan (#128, Hauptstrang-Zweck).
Arbeitsmodus: langsam, hauptsaechlich sequentiell, token-sparsam, NIE kuerzen, Beleg vor
Aktion, O-9-Explore vor jedem Merge/Bau.
