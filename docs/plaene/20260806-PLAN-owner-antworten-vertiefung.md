# PLAN — VERTIEFUNG DER OWNER-ANTWORTEN 06.08. ABENDS

Lead-Konsolidierung der fuenf Scopes (batch · neubau · vortrigger · anhang · strukturell) plus der
drei laufenden Deep-Research-Scopes (Phasen-Fortpflanzung · PMC-ins-Pruefdock · ObservableTier-Audit).

**Rolle:** READ-ONLY. Kein Edit am Code, kein Commit, kein `wt-*` beruehrt. Diagnose ausserhalb des
Repos unter `/tmp/chktexprobe/` (chktex-Gegenprobe) und `/home/comdare/diag-scope4/` (Bestand aus
Scope 4, nur gelesen).

**Erhebungsstand — SELBST am Objekt gemessen, nicht aus den Scopes uebernommen:**

| Gegenstand | Wert | Messmittel |
|---|---|---|
| super `development` = `origin/development` = `github/development` | **`46824fba`** | `git rev-parse`, 3 Refs |
| super `origin/main` = `github/main` | `5534c23c` — **10 Commits main-FF-Rueckstand** | `rev-list --count origin/main..development` |
| ce `development` = `origin/development` = `github/development` | **`b241a272`** | `git rev-parse`, 3 Refs |
| ce `origin/main` = `github/main` | `47c4ef1d` — **6 Commits main-FF-Rueckstand** | `rev-list --count` |
| super-Gitlink auf ce | `47c4ef1d` — **DRIFT gegen den ce-Checkout `b241a272`** | `git ls-tree HEAD` |
| thesis(289) beide Mounts, Zeiger | `8e58f691` (identisch) | `git ls-tree HEAD` |
| thesis `origin/main` = `origin/development` | `8e58f691` | `git rev-parse` |
| thesis `github/main` = `github/development` | `29a1700d` — **5 Commits Rueckstand, FF-faehig** | `rev-list --count github/main..origin/main` = 5 |

---

# TEIL 0 — STAND-KORREKTUR GEGEN DIE FUENF SCOPES

Die Scopes wurden auf super `72eab9ae` / ce `47c4ef1d` erhoben. **Beide Repos sind seitdem
weitergelaufen.** Drei ihrer Befunde sind dadurch erledigt, einer ist neu entstanden:

| Scope-Befund | Damals | HEUTE, am Objekt |
|---|---|---|
| **U-1** ce `b-lb6-stufe1` = `3558466d`, "auf KEINEM Remote" | ungesichert | **ERLEDIGT** — gemerged als `b241a272` (`Merge b-lb6-stufe1`), auf `origin` UND `github`. LB-6 Stufe 1 ist gelandet. |
| **U-2** thesis `a6c7598c`, "auf KEINEM Remote" | ungesichert | **ERLEDIGT** — thesis `origin/main` = `origin/development` = `8e58f691`, drei Commits darueber (`df54a2c`, `a6c7598`, `8e58f69`). |
| **Scope 5 Befund 1**: zwei Thesis-Mounts auf verschiedenen SHAs | 78 Commits auseinander | **SHAs gleichgezogen** (`46824fba`: "BEIDE Thesis-Zeiger auf 8e58f69"). Die **Doppelung selbst besteht fort** — der Strukturbefund bleibt gueltig. |
| **NEU, von mir gemessen** | — | **super-Gitlink zeigt auf `47c4ef1d`, der ce-Checkout steht auf `b241a272`.** Die super-CI baut damit die ce OHNE LB-6 Stufe 1 und ohne die Build-Graph-Kante `678a4487`. Gleiche Fehlerklasse wie der Vorfall `85b74237` -> `72eab9ae` (Scope 5), nur eine Ebene tiefer. Status-Zeile: ` M Code/external/comdare-cache-engine`. **Richtung geprueft (Regel 8): der Checkout ist NACHFAHRE des Zeigers — das `M` ist echter Fortschritt, kein Rueckstand.** |
| **NEU, von mir gemessen** | — | **thesis `github/*` haengt 5 Commits zurueck** (`29a1700d`), darunter Gate 8 und die vier Abend-Verbesserungen. Da Overleaf laut Ledger `:5768` GitHub/main synct, **sieht der Owner in Overleaf den Stand vom 03.08.** FF-Kette gemessen: `github/main..origin/main` = 5, Gegenrichtung 0 — ein reiner Fast-Forward, konfliktfrei. |

**Zwei Pfad-Korrekturen an den Scopes** (fuer die Nachvollziehbarkeit, kein Sachfehler):
Scope 1 und 2 zitieren `libs/cache_engine/builder/planner/experiment_plan_director.hpp`. Dieser Pfad
**existiert nicht**; die Datei liegt unter `libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp`
(selbst per `find` lokalisiert). Die Zeilennummern stimmen.

---

# TEIL 1 — DIE RUECKFRAGEN-LISTE

## 1.1 ELIMINIERT — aus dem Plan bzw. den Owner-Antworten beantwortet

Diese Fragen standen in den Scopes, im Register oder im FAHRPLAN als offen. Sie sind es nicht mehr.
Je mit der Stelle, die sie schliesst.

| # | Frage (wie sie gefuehrt wurde) | ANTWORT + Quelle |
|---|---|---|
| **E-1** | **O-A (Wellenplan): PMC fixen oder honest-0 messen?** — gefuehrt als "der teuerste Entscheid" (`docs/plaene/20260806-PLAN-wellenplan-vollbild-und-parallelisierung.md`, 4.2) | **FIXEN.** Owner 06.08. abends verbatim: *"fixen und neu messen ist **Pflicht**"* und *"**NIE abkuerzen, immer mit deep research fixen**"*. Zusaetzlich die Reichweite: PMC *"MUSS ... eingebaut und gemessen werden und zwar in die CEB fuer deren Pruefdock"*. Die Gegenstelle "honest-0 bis #26" ist bereits im Ledger als SUPERSEDED vermerkt (nachmittag-10 E: *"vier Tage aelter als die Pflicht"*). |
| **E-2** | **O-B: `allow_failure: true` am Mess-Job entfernen?** | **JA, entfernen bzw. auf Zell-Ebene zurueckfuehren.** Owner: *"**PFLICHT, dass das gemessen wird, was gemessen werden kann**"*. Ein `allow_failure: true` (am Objekt: `experiment_plan_director.hpp:1373`; gemessen ce-HEAD 54106bc9, `git grep allow_failure` = 1 Treffer) macht genau diese Pflicht unbeobachtbar. Die konkrete Form (ganz weg vs. Zell-Ebene) ist eine **Bau**-Entscheidung, kein Owner-Entscheid — die Sichtbarkeits-Doktrin "Mess-Fehler => CSV 'failed' + Log" (Kommentar ebd. `:1332`) bleibt der Traeger. |
| **E-3** | **O-C: `COMDARE_BESTANDSLOG` Default AN?** | **JA.** Owner: *"**Pflicht wie im Plan. Rueckfall moeglich mit wiederaufnahme -> wertvoll.**"* Damit ist auch die harte Wache gedeckt, die einen Voll-Lauf ohne Provider abbricht statt stumm zu degradieren (Wellenplan 3B/i-5). |
| **E-4** | **Ist die Batch-Einheit die Binary oder der GitLab-Job?** (Scope 1) | **Die Binary.** Doppelt belegt: Ledger `:3324` verbatim *"die Batches enthalten STETS 4096 **Binaries**"*; Ledger `:3320` *"**Job-Anzahl = O(konstant), NIE O(Binaries)**"*. Am Objekt bestaetigt: `struct BuildJob` = eine Tier-Binary (`build_orchestrator.hpp:125-131`), `kGnBatchSlice = 4096` (`experiment_plan_director.hpp:610`). **Owner-Vorgabe "maximal 4096" und Code-Ist stimmen ueberein** — auf der BAU-Seite. Zur Mess-Seite s. R-2. |
| **E-5** | **R2 E-18-Zielbranch** | **ENTSCHIEDEN: `development`** (Register `:335`: *"ENTSCHIEDEN: (a) development (E-1, frueh-6, L4328) — aus dem Fenster streichen"*). |
| **E-6** | **A1-Freigabe / Bump-Auflage** | **BEANTWORTET** — Ledger nachmittag-10 D: LANDEN mit Bump. Gelandet (`fdfa68ee`, `9eb1e7d6`), im Baum. |
| **E-7** | **Muss der Fingerprint die Mess-Achse ueberhaupt tragen?** (Scope 2) | **JA, und zwar per Owner-Prinzip.** Owner verbatim: *"**Mess-Achsen + System-Achsen + Organ-Achsen identisch -> fingerprint fuer identische binary fuer identische Messdaten**"*. Das ist keine Empfehlung, sondern die benannte *"Hauptidee des Systems und des Lagers"*. Damit ist das **OB** entschieden; offen bleibt nur der **Umfang** (s. R-3). |
| **E-8** | **Darf der zweite Thesis-Mount `Code/external/20260931-overleaf-diplomarbeit` entfallen?** (Scope 5) | **Kein Owner-Entscheid noetig — Bau-Entscheidung mit Deprecation.** Konsumenten-Bilanz von Scope 5 (0 in CI, 0 in CMake) plus der Test, der ihn aktiv ausschliesst (`test_experiment_plan_director.cpp:1854-1856`). Kein Remote wird geloescht, damit greift das Memory `feedback_remote_deletion_requires_explicit_user_authorization` **nicht**. Die Doku-Fundstellen werden deprecated, nicht geloescht (`feedback_never_delete_documentation`). |
| **E-9** | **Overleaf-Naht: darf thesis nach `github/main` gepusht werden?** | **Ja, konfliktfrei.** Von mir gemessen: reiner Fast-Forward (`github/main..origin/main` = 5, Gegenrichtung **0**). Kein Owner-Entscheid, keine Loeschung, kein Force. |
| **E-10** | **`COMDARE_E4_CAP` traegt zwei Bedeutungen** (Scope 1, dort als eigene Rueckfrage markiert) | **Kein Owner-Entscheid.** Von mir gegengeprueft: die Variable ist **im Repo nirgends gesetzt**; ein Umbenennen ist ohne Aussenwirkung. Gehoert in den Aufraeumpass (`feedback_abschluss_aufraeumpass_deprecated_code_entfernen`), nicht in die Owner-Vorlage. |
| **E-11** | **V-11 / PAT-Rotation, 776 Runner-Token** | **TERMINIERT, nicht offen.** Owner-Terminierung liegt vor (Register `:433`: *"NUR-KENNTNIS (Rotation nach Messfenster, Handout liegt)"*). **CAVEAT:** das "Messfenster" ist durch die Frist-Verschiebung auf den 15.09. deutlich laenger geworden — s. meine eigene Rueckfrage M-3. |
| **E-12** | **O-3 Loesch-GO** | **Offen by design**, nach dem Messfenster (Register `:338`). Blockiert keine Welle. Nicht in die Vorlage. |
| **E-13** | **Bridge triggert `branch: main`** (Scope 5 Befund 2) | **ENTSCHIEDEN, gegen eine Aenderung.** Ledger `:2044` verbatim: *"Das Trigger-Design 'super gated auf Modul-**main**' ist **dokumentiert-absichtlich**. Damit Option B (Trigger auf development umverorten) OFF THE TABLE"*. **Konsequenz, die trotzdem gilt:** solange `main` zurueckhaengt (heute: ce 6, super 10 Commits), prueft die Bridge einen alten Stand. Der Fix ist der main-FF, nicht die Bridge. |

**Bilanz: 13 von 21 Kandidaten-Fragen sind aus dem Plan bzw. den Abend-Antworten beantwortet.**

## 1.2 DIE VERBLEIBENDEN ECHTEN OWNER-FRAGEN — entscheidungsreif

---

### R-1 — DER MESS-UMFANG. Die Frist reicht fuer den Bau, aber NICHT fuer die Messung.

**Die Frage in einem Satz:**
Welche Teilmenge des Kreuzprodukts *(Binaries x Mess-Settings)* wird tatsaechlich **gemessen** — denn
der volle deklarierte Umfang braucht nach meiner Rechnung **rund 72 Tage auf zwei Lanes**, und bis zum
15.09. sind es **40 Tage**?

**Warum der Owner das entscheiden muss:**
Es ist keine technische, sondern eine inhaltliche Frage — welche Aussage die Arbeit belegen soll.
Sie ist exakt die Frage, fuer die der Owner selbst schon das **Mittel** benannt hat
(*"das muss die XML getrennt fuer build und Messung definieren koennen sonst regression"*), aber noch
nicht die **Zahl**. Und sie ist nicht delegierbar: jede Reduktion streicht eine moegliche Aussage.

**DIE RECHNUNG — jede Zahl mit Bezugsgroesse, von mir am Objekt erhoben.**

*(a) Der Mess-Faecher je Tier-Binary.* Am Objekt aus `all_axes_golden.profile.xml` gelesen und gegen
die Schleifen-Struktur geprueft (`profile_run_entry.hpp:365-380`: die DynDims `concurrency.thread_count`,
`prefetch.hw_prefetcher`, `repetition.repetition_index` plus die injizierte Ebene `workload.workload_id`
sind **dynamische Achsen-Ebenen** und multiplizieren daher; der `<working_set_sweep>` ist die aeussere
N-Schleife und kollabiert laut `:165-166` **nur** im `provision_only`-Bau, nicht im Messen):

| Dimension | Werte | XML-Fundstelle |
|---|---|---|
| `<workloads>` | **6** (ycsb_a..f) | `all_axes_golden.profile.xml:126` |
| `<working_set_sweep>` | **4** (16384 / 131072 / 1048576 / 8388608) | ebd. `:112` |
| `hw_prefetcher` | **3** (all_on / adjacent_off / all_off) | ebd. `:157` |
| `thread_count` | **1** | ebd. `:156` |
| `<repetitions count>` | **3** | ebd. `:160` |
| **Produkt = Mess-Settings je Binary** | **216** | |

*(b) Die Kosten EINER Messung — gemessen, nicht geschaetzt.* Aus dem einzigen getrackten Korpus
`measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv`, Bezugsgroesse **16 Datenzeilen**,
Spalte `total_ns`, von mir ausgezaehlt:

    Summe   = 1.750.887.462 ns = 1,751 s
    Mittel  = 109,4 ms je Messung      Spanne 6,5 ms .. 448,4 ms
    Kontrollrechnung: total_ns == n_ops * ns_per_op  (10000 * 44839,087 = 448.390.870)  -> exakt

*(c) Hochrechnung.* Bezugsgroesse Bau-Menge **524.288 Tier-Binaries** (= 4 System-Perms x 2^17; der
`static_assert(catalog_axis_product<FullSourceCatalog>() == 131072u)` steht in `source_catalog.hpp:169`):

    524.288 Binaries x 216 Settings           = 113.246.208 Einzelmessungen
    x 0,1094 s                                =  12.389.135 s = 3441 h = 143,4 Tage  (1 Thread)
    Messen ist doktrinaer 1-Thread            (experiment_plan_director.hpp:1370-1372: "NUR das MESSEN ist 1-Thread")
    2 Lanes parallel (prod1 + prod2)          =  71,7 Tage Wanduhr
    Verfuegbar 06.08. -> 15.09.               =  40 Tage

**Der Faktor ist rund 1,8 — und 109,4 ms ist ein UNTERGRENZE-Wert, aus zwei unabhaengigen Gruenden:**
(i) der Korpus wurde bei `working_set_n = 4096` gemessen, der golden-Sweep geht bis **8.388.608**
(Faktor 2048 in der Datenmenge); (ii) `total_ns` ist die reine Messphase — Aufbau des Working Sets,
Zwei-Phasen-Warmup und Rollback stehen **nicht** darin, laufen aber auf der Wanduhr mit.

**Zum Vergleich der BAU, der unproblematisch ist** (UEBERNOMMEN aus Scope 3, dort aus den Job-Traces
306305/306306 in `docs/sessions/20260723-SESSION-mittag-neustart-zug-vollbau4.md:41-45`; von mir
nicht nachgemessen): 19,4 min je 4096er-Scheibe auf amd@24W, 32,25 min auf intel@24W; 128 Scheiben,
auf zwei Lanes verteilt => **~34,4 h Wanduhr, Engpass intel**. **Der Bau passt bequem. Die Messung
passt nicht.**

**Empfehlung — und sie ist genau die Struktur, die der Owner selbst benannt hat:**
> **Bauen: voll (alle 524.288). Messen: deklarierte Teilmenge, in der XML getrennt ausgewiesen.**

Begruendung: der Bau kostet 34 h und erfuellt *"ALLER kompilierter binaries"* woertlich; er ist die
Voraussetzung fuer das Lager, den Fingerprint-Beweis und jede spaetere Nachmessung. Die Messung ist
der Engpass, und der Owner hat selbst bereits die Struktur vorgezeichnet: *"danach die **320er XML
Einstellung auf der Basis ALLER kompilierter binaries**"* — das ist bereits eine **Selektion ueber der
Vollmenge**, also genau der vorgeschlagene Schnitt. Zwei Stellschrauben, unabhaengig voneinander:

| Weg | Rechnung | Wanduhr, 2 Lanes | Verlust |
|---|---|---|---|
| **(A) Binaries reduzieren, Faecher voll** — z.B. die 320er-Auswahl | 320 x 216 x 0,1094 s | **2,1 h** | Kartesik nicht flaechendeckend belegt |
| **(B) Faecher reduzieren, alle Binaries** — 1 working_set, 3 workloads, 1 hw_prefetcher, 3 rep = 9 | 524.288 x 9 x 0,1094 s | **~3,0 d** | keine Working-Set-Kurve, kein Prefetcher-Vergleich |
| **(C) beides gestaffelt (EMPFEHLUNG)** | (A) voll + (B) flach | **~3,1 d** | keiner, der die Kernaussage traegt |
| (D) Vollmenge | 524.288 x 216 | **71,7 d** | passt nicht in die Frist |

**Konsequenz beider Wege.** Bei einer Entscheidung fuer (C): die Arbeit hat sowohl die
flaechendeckende Aussage ueber alle 524.288 Binaries (flacher Faecher) als auch die tiefen Kurven
(Working-Set-Sweep, Prefetcher) auf der 320er-Auswahl — und sie **passt mit ~37 Tagen Reserve**.
Bei (D): die Messung ist am 15.09. zu rund 56 % fertig, und es gibt weder Kurven noch Flaeche,
sondern einen Torso.

**Dringlichkeit: VOR DEM ERSTEN 4096er-BATCH MORGEN.** Nicht weil der Bau davon abhinge — er haengt
nicht davon ab —, sondern weil die Antwort die XML-Trennung (R-2) formt, und die XML-Trennung ist die
Datei, aus der der erste Batch gefahren wird.

---

### R-2 — DIE FORM DER XML-TRENNUNG: eine Mess-Selektion oder zwei unabhaengige Mengen?

**Die Frage in einem Satz:**
Soll die geforderte Trennung so aussehen, dass die Mess-Menge eine **deklarierte Auswahl UEBER der
Bau-Menge** ist (ein `<measure_selection>`-Block mit Filtern), oder sollen Bau-Menge und Mess-Menge
**zwei voneinander unabhaengig deklarierte Mengen** sein?

**Warum der Owner das entscheiden muss:**
Der Owner hat die Trennung zur Pflicht gemacht (*"sonst regression"*), aber die Semantik entscheidet
ueber eine Kern-Eigenschaft: ob eine Mess-Menge existieren kann, die **nicht** gebaut wurde. Das
beruehrt unmittelbar das Fingerprint-Prinzip (*"identisch -> identische binary fuer identische
Messdaten"*), denn eine unabhaengige Mess-Menge kann auf Binaries zeigen, die es nicht gibt.

**Der Ist-Stand, von mir am Objekt geprueft:**
- `struct ThesisProfile` (`xml_config_parser.hpp:242-302`) hat **kein einziges Feld**, das Bau- und
  Mess-Menge trennt. Ich habe die Struktur vollstaendig gelesen.
- Die Trennung existiert **nur zur Laufzeit**: `provision_only` (*"true = nur bauen, nicht messen"*,
  `profile_run_entry.hpp:213`) und `pruef_only`, beide aus Env belegt
  (`COMDARE_GOLDEN_N_PROVISION_ONLY`, `COMDARE_PRUEF_ONLY`).
- **Damit ist die vom Owner benannte Regression exakt am Objekt belegt: die XML kann es heute nicht.**

**ZWEITER, SCHWERERER BEFUND — von mir gefunden, in keinem der fuenf Scopes:**
> **Die MESS-Seite ist nicht in 4096er-Scheiben geteilt.** Der Bau-Batch slict korrekt
> (`experiment_plan_director.hpp:1240-1252`: `while [ "$START" -lt "$TOTAL" ]` mit `SLICE=4096`).
> Der Mess-Batch dagegen faehrt das **volle Fenster in EINEM Treiber-Aufruf je Perm**:
> `experiment_plan_director.hpp:1367-1369`, Kommentar verbatim:
> *"Mess-Fenster = das VOLLE [0:COMDARE_GN_TOTAL) der Zelle (BYTE-GLEICH zur Vor-S4-Emission). Einmal je Batch."*
>
> Die Owner-Vorgabe lautet aber *"batch Einteilung in maximal 4096 jobs fuer **compile und Messung**"*.
> **Die Bau-Seite erfuellt sie, die Mess-Seite nicht.** Konsequenz ohne Fix: ein Mess-Lauf ist eine
> einzige, ungeteilte Einheit von (nach R-1) mehreren Wochen ohne Zwischen-Commit-Punkt — jeder
> Abbruch verliert alles seit Beginn, und der vom Owner als *"wertvoll"* bezeichnete
> *"Rueckfall mit wiederaufnahme"* hat auf der Mess-Seite kein Korn, an dem er greifen koennte.

**Empfehlung: Auswahl UEBER der Bau-Menge (Variante 1), plus 4096er-Scheiben auch im Mess-Batch.**
Begruendung: Variante 1 macht die Aussage *"gemessen wird eine Teilmenge dessen, was gebaut wurde"*
zu einer **strukturellen Garantie** statt zu einer Zusicherung, die jemand einhalten muss. Sie ist
damit dieselbe Fehlerklasse-Vermeidung wie der Fingerprint selbst. Variante 2 waere maechtiger, aber
sie erlaubt genau den Zustand, den das Fingerprint-Prinzip ausschliessen soll.

**Konsequenz beider Wege.** Variante 1: der Parser braucht ein `<measure_selection>` mit Filtern
(Achsen-Werte, Perm-Auswahl, Faecher-Reduktion) und eine Validierung "Selektion ist Teilmenge der
Bau-Menge" — mittlere Bau-Groesse, eine Datei mehr im Parser-Schnitt. Variante 2: zwei vollstaendige
Mengen-Deklarationen, doppelte Validierung, und eine neue Fehlerklasse "gemessen ohne gebaut", die
laufzeitseitig gefangen werden muss.

**Dringlichkeit: VOR DEM ERSTEN 4096er-BATCH MORGEN** (die Trennung ist die Voraussetzung dafuer,
dass der erste Batch ueberhaupt sagen kann, was er misst) — die 4096er-Scheiben im Mess-Batch
spaetestens **vor der Voll-Messung**.

---

### R-3 — WIE WEIT REICHT DER FINGERPRINT? Und ist die Release-Nachmessung im Abgabe-Umfang?

**Die Frage in einem Satz:**
Soll der Fingerprint **den vollstaendigen Satz der bau-wirksamen Mess-Defines** tragen (namentlich
`COMDARE_MEASUREMENT_ON` und `COMDARE_ENABLE_PMC`) — was ihn **jetzt** einmalig kostenlos aendert,
**nach** dem Flottenbau aber einen zweiten Voll-Bau von ~34 h erzwingt?

**Warum der Owner das entscheiden muss:**
Weil die Antwort daran haengt, ob die vom Owner selbst geplante **Release-Nachmessung**
(*"nochmal im release Modus ohne Mess-Einrichtungen neu kompiliert"*, Ledger NACHTRAG 05.08.
nachmittag-1) bis zum 15.09. im Umfang ist. Ist sie es, MUSS der Fingerprint die Defines tragen —
und zwar bevor die Flotte gebaut wird. Ist sie es nicht, ist die Erweiterung Hygiene und kann warten.

**Der Befund, von mir am Objekt nachgeprueft (Scope 2 hatte ihn, ich habe ihn verifiziert):**

- Die Preimage-Glieder sind genau acht (`anatomy_fingerprint.hpp:462-472`, selbst gelesen):
  `{Format, Organ, System, MESSUNG, Sub-Achsen, Toolchain, bvset, Overlay}`.
- Glied [3] "MESSUNG" traegt **nur** die Tooling-Ids samt Registry-Version und das `load_framework`.
- Das Toolchain-Glied hat **9 Felder** (`toolchain_stamp_glied.hpp:246-248`, selbst gelesen):
  `cxx, opt, ext, ceb, target, tel, bt, gate, atomic128` — **kein Mess-Define darunter.**
- **`COMDARE_MEASUREMENT_ON` veraendert die ABI der Tier-Binary.** Am Objekt:
  `perm_mess_defines()` setzt es hart auf `1` (`profile_run_facade.cpp:274`), und
  `abi_adapter.hpp:393` (`#if COMDARE_MEASUREMENT_ON`) laesst den Adapter **nur unter diesem Define**
  zusaetzlich `IObservableTier` erben (`observable_tier.hpp:191`, `:222`).
- **Folge:** eine Release-Nachmessung mit `COMDARE_MEASUREMENT_ON=0` erzeugt eine **andere Binary mit
  identischem Fingerprint**. Und der Fingerprint IST das Skip-Kriterium — `dll_is_current`
  (`build_orchestrator.hpp:330-337`, selbst gelesen) ist genau **ein** Vergleich:
  `return *vorhanden == expected_fingerprint;`. Ergebnis: **stiller Falsch-Skip**, also die
  Release-Messung misst die Mess-Binary.
- Dasselbe gilt fuer `COMDARE_ENABLE_PMC`: die Option existiert (`ce CMakeLists.txt:67-107`) und
  `add_compile_definitions(COMDARE_ENABLE_PMC)` veraendert den Bau — **im Fingerprint steht sie nicht.**

**Empfehlung: JA, jetzt erweitern — Glied [5] (Toolchain) um ein Feld `mess` fuer den Define-Satz.**
Begruendung, dreifach: (i) Das Owner-Prinzip verlangt es bereits — *"Mess-Achsen + System-Achsen +
Organ-Achsen identisch -> fingerprint fuer identische binary"*; `MEASUREMENT_ON` ist eine bau-wirksame
Eigenschaft der Mess-Achse. (ii) Der Zeitpunkt ist **kostenlos**: heute existieren **0 `.fingerprint`-
Sidecars** (Scope 2 hat es gezaehlt, `find` ueber das super-Repo). Nach dem Flottenbau kostet dieselbe
Aenderung 34 h Bau plus alle bis dahin gemessenen Daten. (iii) Es ist die konkrete, am Objekt
belegte Form des vom Owner verlangten **ObservableTier-Vertrags-Audits** — der Vertrag ist genau
deshalb *"in Gefahr"*, weil sein Vorhandensein bau-wirksam, aber unstempelbar ist.

**Konsequenz beider Wege.** JA: ein Format-Bump 3->4, eine Welle im ce, die golden-Id-Fixtures ziehen
nach; danach ist jede kuenftige Mess-System-Aenderung sichtbar. NEIN: die Flotte wird gebaut, und die
erste Release-Nachmessung liefert stumm die falschen Binaries — ein Fehler, der in den Daten nicht
sichtbar ist, weil beide Laeufe plausible Zahlen produzieren.

**Dringlichkeit: VOR DEM ERSTEN 4096er-BATCH MORGEN.** Dies ist die einzige Frage dieser Liste, bei
der ein "spaeter" den Preis um mehrere Groessenordnungen erhoeht. Sobald die erste Binary mit einem
`.fingerprint` auf der Platte liegt, ist das Fenster zu.

---

### R-4 — DER BAU-UMFANG: 524.288, 1.572.864 oder 2.097.152?

**Die Frage in einem Satz:**
Welche System-Perm-Menge und welcher `line_size`-Status gelten fuer den Voll-Bau — die heute im
Traeger-Profil deklarierten **4 Perms (524.288 Binaries)**, die Doktrin V7.4 mit **12 Perms
(1.572.864)**, oder zusaetzlich der `line_size`-Faktor 4 (**2.097.152**)?

**Warum der Owner das entscheiden muss:**
Drei Dokumente nennen drei Zahlen, und der FAHRPLAN fuehrt die Frage selbst als *"der wichtigste
offene Punkt des ganzen Fahrplans"* (`20260806-FAHRPLAN-hauptstrang-landung.md`, Abschnitt 5, O-A).
Sie ist dort ausdruecklich als **inhaltlich, nicht technisch** klassifiziert: *"soll die Abgabe-Messung
den vollen KF-6-Vollausbau fahren, oder eine deklariert reduzierte, repraesentative Teilmenge?"*

**Der Ist-Stand, von mir am Objekt geprueft:**
- Das Trigger-Traeger-Profil `all_axes_golden.profile.xml:189-198` deklariert **opt {O2,O3} x simd
  {no_extension, avx2} = 4 Perms**. Der Kommentar `:183-188` begruendet es: *"Ofast bewusst
  WEGGELASSEN — bricht IEEE-754-/Run-to-Run-Determinismus"*, *"avx512 nicht universell"*.
  **=> 4 x 131.072 = 524.288 ist der reale Ist-Umfang.**
- Der `line_size`-Faktor 4 haengt an `<organ_subaxes>` in `experiment_golden_kern.xml`, das laut
  Scope 1 weder geparst wird noch in der Pipeline referenziert ist (Scope-1-Befund, UEBERNOMMEN —
  von mir nicht nachgemessen).
- `cap="131072"` (`all_axes_golden.profile.xml:161`) ist keine Kappung: `min(cap, basis_count)` =
  `min(131072, 131072)` (Scope-1-Befund, UEBERNOMMEN).

**Empfehlung: bei 4 Perms / 524.288 bleiben; `line_size` und O0/O1/avx512 deklariert als
NACH-ABGABE ausweisen.**
Begruendung: der Profil-Kommentar traegt bereits eine **fachliche** Begruendung fuer genau diesen
Schnitt (Determinismus, Universalitaet auf beiden Lanes) — er ist keine Sparmassnahme, sondern eine
Mess-Methodik-Entscheidung, die in der Arbeit verteidigbar ist. Der Owner-KERN A4 *"es muessen dennoch
alle unterstuetzt sein, sofern von der Hardware freigegeben"* fordert **Unterstuetzung**, nicht Messung
aller Kreuzprodukte — die Unterscheidung, die der FAHRPLAN selbst benennt.

**Konsequenz beider Wege.** 524.288: Bau 34,4 h, Aussage "2 Optimierungsstufen x 2 ISA-Breiten,
determinismus-begruendet". 1.572.864: Bau ~103 h = 4,3 Tage, und O0/O1 liefern Messwerte, die die
Arbeit nicht braucht (Debug-Optimierungsstufen in einer Performance-Studie). 2.097.152: Bau ~138 h,
und `organ_subaxes` muss vorher ueberhaupt erst an den Parser angeschlossen werden (KF-6-NTTP-Codegen,
im Register als NACH-ABGABE gefuehrt).

**Dringlichkeit: VOR DER VOLL-MESSUNG.** Nicht vor dem ersten Batch — der erste Batch ist eine Scheibe
aus Perm 0 und in allen drei Varianten identisch.

---

### R-5 — ANHANG A: reicht die Mechanik, oder muessen M-8 und M-15 noch gebaut werden?

**Die Frage in einem Satz:**
Der Owner hat *"Ja bitte mit in die Abgabe"* gesagt — gilt das nur fuer die **28 fehlenden
Abbildungen** (die laut Scope 4 heute schon vollstaendig baubar sind), oder auch fuer die beiden
**noch gar nicht existierenden** Auswertungs-Writer M-8 (Achsen-Sensitivitaets-/Varianz-Attribution)
und M-15 (Welch-Konsument als eigene WIDE-Auswertungsstufe)?

**Warum der Owner das entscheiden muss:**
Weil die Praemisse der urspruenglichen Frage (Register `:432`, O-4) **widerlegt** ist: Anhang A haengt
NICHT an M-8/M-9/M-15. Scope 4 hat den Generator aus dem HEAD-Quelltext gebaut und gefahren — **28 von
28 Positionen bedient**, PDF DE+EN, 0 Fehler. Damit ist *"Ja bitte mit in die Abgabe"* fuer die
Abbildungen **bereits erfuellbar**, und die Frage nach M-8/M-15 ist eine **andere, neue**: nicht
"blockiert es die Abgabe", sondern "welche Auswertungstiefe soll die Arbeit haben".

**Was sich durch die Frist-Verschiebung geaendert hat:** der Register-Default-Vorschlag lautete
*"NACH-ABGABE"* — begruendet mit dem 08.08.-Termin. Bei **40 Tagen** statt zwei ist diese Begruendung
weg. M-8 und M-15 sind reine super-Auswertungsstufen ohne ce-Beruehrung und ohne Neubau-Folge.

**Empfehlung: M-9 (die drei unverdrahteten Writer) jetzt verdrahten, M-8 und M-15 nach dem ersten
echten Mess-Korpus bauen.**
Begruendung: M-9 ist **fertiger Code ohne Konsument** — Scope 4 hat alle drei gegen den heutigen
Korpus gefahren, alle `status_ok` mit echten Zeilen. Sie zu verdrahten kostet je eine Zeile in der
Facade und eine `\input`-Zeile; sie NICHT zu verdrahten ist genau die vom Owner geruegte Kostenklammer
(*"landet, kostet nichts, ist eh inert"*). M-8 und M-15 dagegen sind **Varianz- und Signifikanz-
Auswertungen** — sie brauchen einen Korpus mit echten Wiederholungen, den es heute nicht gibt
(der getrackte Korpus hat `repetition` = **1 einziger Wert**, von Scope 4 ausgezaehlt). Sie vor der
Messung zu bauen hiesse, sie gegen Daten zu entwickeln, die ihre Aussage nicht tragen.

**Konsequenz beider Wege.** Jetzt bauen: zwei super-Wellen gegen einen Korpus ohne Wiederholungen,
mit dem Risiko, sie nach der Messung nochmal anzufassen. Nach dem Korpus: die Arbeit hat bis dahin
Anhang A vollstaendig, und die Statistik-Stufen entstehen gegen echte Daten.

**Dringlichkeit: VOR DEM 15.09.** Blockiert weder Batch noch Voll-Messung.

---

### R-6 — EBENE-B-PUSH: geht die Flotte ausser Haus?

**Die Frage in einem Satz:**
Sollen die 524.288 Tier-Binaries waehrend des Baus in den Ebene-B-Store (minio) gepusht werden —
was ein Owner-GO fuer die Cluster-Schreibrichtung braucht, weil diese Linie read-only gefuehrt wird?

**Warum der Owner das entscheiden muss:**
Die Cluster-read-only-Doktrin (`feedback_diplomarbeit_impl_agent_cluster_readonly_no_infra`) verbietet
mir die Schreibrichtung, und Ebene-B ist Infrastruktur. Zusaetzlich ist der Bestand dort **UNBELEGT**:
Scope 2 konnte ihn nicht enumerieren, und der Ledger fuehrt die Nicht-Enumeration als bereits
verbuchten Zustand (NACHTRAG 05.08. nachmittag-2, TP1-FINAL-INVENTUR (b): *"Physische Ebene-B-
Enumeration ENTFAELLT BEGRUENDET"*). Ich kann die Frage also nicht durch Messen aufloesen.

**Was der Owner bereits gesagt hat und was daraus NICHT folgt:** *"Rueckfall moeglich mit
wiederaufnahme -> wertvoll"* deckt den **Bestandslog** (das XML-Ledger, das sagt, welche Scheibe fertig
ist). Es deckt **nicht** automatisch den Binary-Store — Wiederaufnahme auf derselben Maschine
funktioniert von der lokalen Platte. Ebene-B ist die Absicherung gegen **Maschinen**-Verlust.

**Empfehlung: JA, aktivieren — aber erst nach einer df-Messung am Host.**
Begruendung: 524.288 Binaries sind der Ertrag von 34,4 h Rechenzeit auf zwei Maschinen. Geht eine
Lane verloren, kostet das ohne Ebene-B den halben Bau. Die Bezugsgroesse fuer den Platzbedarf fehlt
mir jedoch — **UNBELEGT: die durchschnittliche `.so`-Groesse der Flotte habe ich nicht gemessen**
(die 90 lokal gefundenen `perm_*.so` stammen aus Test-Fixtures und Alt-Baeumen, nicht aus einem
golden-Bau). Genau diese Zahl ist der Posten **V-06-Rest ETA-Erst-Batch-Abnahme** (Register `:437`):
*"das ERSTE Mini-Batch des Voll-Bau-4 liefert t/TU und Bytes/DLL — diese beiden Zahlen sind VOR dem
Weiterlaufen der Matrix gegen den Plattenstand abzunehmen"*. **Der erste 4096er-Batch morgen liefert
sie.** Der Entscheid kann daher unmittelbar nach ihm fallen, mit Zahl statt ohne.

**Konsequenz beider Wege.** JA: Netz-/Platzbudget im Cluster, Push-Zeit je Scheibe. NEIN: ein
Maschinenausfall kostet bis zu 34 h Rechenzeit, und der vom Owner als wertvoll bezeichnete Rueckfall
endet an der Maschinengrenze.

**Dringlichkeit: nach dem ersten Batch, VOR DER VOLL-MESSUNG.**

---

## 1.3 MEINE EIGENEN RUECKFRAGEN — was ich aus dem Plan NICHT beantworten konnte

### M-1 — Welcher "Abgabe"-Begriff gilt fuer die zweistufige Frist?

**Wonach gesucht wurde:** `/usr/bin/grep -n "15.09\|15\.09\.2026\|Freitag\|woechentlich"` ueber
Ledger, `docs/plaene/`, `docs/sessions/` — **0 Treffer**. Der gesamte Planbestand ist auf
*"Abgabe Fr 08.08."* geschrieben (u.a. `20260806-PLAN-wellenplan-...md`, 4.1). Der Ledger endet mit
`nachmittag-10`; die Abend-Antworten sind **noch nirgends verbucht**.

**Die Frage:** Bezeichnet "Abgabe" ab sofort den **15.09.**, und was genau ist am jeweiligen
**Freitag** faellig — ein Zwischenstand, ein neuer Mess-Korpus, oder ein kompilierendes PDF?

**Empfehlung:** Den 15.09. als Abgabe fuehren und die Freitage als **Ergebnis-Kadenz** definieren
(je Freitag: ein gruener Voll-Lauf + ein neuer, in Anhang A sichtbarer Datenstand). Das macht die
Kadenz messbar statt deklarativ und passt zur Owner-Formulierung *"neue Ergebnisse liefern"*.
**Ohne diese Festlegung ist die gesamte P0-P4-Prioritaetsordnung des Registers auf einen falschen
Termin geeicht** — sie priorisiert gegen 48 Stunden, nicht gegen 40 Tage. Das ist die groesste
stille Fehlerquelle der aktuellen Planung.

### M-2 — Bleibt "die 320er XML Einstellung" eine eigene Datei oder wird sie die Mess-Selektion?

**Wonach gesucht wurde:** `all_axes_golden.profile.xml` (der Trigger-Traeger, `cap="131072"`),
`m3v2_smoke.profile.xml`, sowie die 320er-Fixture
`tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt`. Ich finde die 320er als **Test-Fixture
und Legenden-Begriff**, aber **kein `*320*.profile.xml`** als eigenstaendige Mess-Einstellung.

**Die Frage:** Ist die "320er XML Einstellung" (a) das bestehende golden-Profil mit einer
320er-Selektion, oder (b) eine separate Profil-Datei, die noch anzulegen ist?

**Empfehlung:** (a) — als `<measure_selection>` im golden-Profil, denn genau das ist die in R-2
vorgeschlagene Struktur, und der Owner-Satz *"320er XML Einstellung **auf der Basis ALLER
kompilierter binaries**"* beschreibt woertlich eine Selektion ueber der Vollmenge, keine zweite Datei.
Diese Rueckfrage faellt weg, sobald R-2 entschieden ist.

### M-3 — Verschiebt die neue Frist die Termine der terminierten Sicherheitsposten?

**Wonach gesucht wurde:** Register `:433` (V-11 PAT-Rotation) und `:338` (O-3 Loesch-GO), beide auf
*"nach Messfenster"* terminiert; Task #10 (776 Runner-Token) ist rot markiert.

**Die Frage:** "Nach Messfenster" hiess bisher "in wenigen Tagen". Es heisst jetzt "in bis zu sechs
Wochen". Bleiben die Sicherheitsposten so terminiert?

**Empfehlung:** V-11 und den Runner-Token-Posten **auf einen festen Freitag ziehen** statt an das
Messfenster zu koppeln — eine Terminierung, deren Bezugsgroesse sich verzehnfacht hat, ist keine
Terminierung mehr. O-3 (Loesch-GO) kann am Messfenster bleiben, weil er nichts gefaehrdet.

### M-4 — Vier unabhaengige Literale `4096`, durch nichts gekoppelt

**Wonach gesucht wurde:** `/usr/bin/grep -rn "kGnBatchSlice\s*=\|kBuildSliceGrain\s*=\|
kMaxMaterializableCatalogCardinality\s*="` sowie eine Suche nach einem koppelnden `static_assert`
(`static_assert.*kGnBatchSlice|static_assert.*kBuildSliceGrain`) — **letztere: 0 Treffer.**

**Der Befund (eigen, in keinem Scope):** die Zahl 4096 lebt an **vier** Stellen als eigenstaendiges
Literal:

    profile_facade/planner/experiment_plan_director.hpp:610   kGnBatchSlice = 4096
    builder/bestandslog/batch_planner.hpp:51                  kGnBatchSlice = 4096   (zweite Definition!)
    builder/bestandslog/planer_driven_build.hpp:60            kBuildSliceGrain = 4096
    profile_facade/source_catalog.hpp:205                     kMaxMaterializableCatalogCardinality = 4096

Drei davon tragen Kommentare der Form *"spiegelt experiment_plan_director kGnBatchSlice=4096"* —
also eine **Zusicherung im Prosa-Text statt einer Wache**. Genau die Fehlerklasse, die der Ledger
als Regel 6 fuehrt (*"eine Zusage, die eine andere Frage beantwortet als die gestellte"*).

**Die Frage:** Soll das im Aufraeumpass auf **eine** Konstante mit `static_assert`-Kopplung gezogen
werden, oder ist die Spiegelung bewusst (Layering: `builder/` darf `profile_facade/` nicht sehen)?

**Empfehlung:** Eine Konstante in der tiefsten gemeinsamen Schicht, die drei anderen als
`static_assert`-gekoppelte Spiegel. Kosten: Minuten. Nutzen: die Owner-Vorgabe "maximal 4096" ist
danach an **einer** Stelle aenderbar statt an vier. **Kein Blocker**, aber ein billiger Posten fuer
den Aufraeumpass.

### M-5 — Was ist mit `Code/measure_out_d03/`?

**Wonach gesucht wurde:** `git status --porcelain` (untracked), Scope 4 (byte-identische Dublette des
getrackten Korpus), Wellenplan WELLE 0 Punkt 0.3 (*"offen"*).

**Die Frage:** Der einzige Mess-Lauf mit `pmc_available=1` liegt untracked im Baum, waehrend das
Memory `feedback_messdaten_nie_loeschen_abi_darf_brechen` gilt. Sichern oder als Dublette verwerfen?

**Empfehlung:** **Sichern** (Backup-Ort, additiv) — auch wenn es eine Dublette des getrackten Korpus
ist, sind die **vier Logs** (`measure_out_d03-{bau,mess,pruef,validate}.log`) NICHT dubliert, und
Scope 4 fuehrt als UNBELEGT, **warum** dieser Lauf PMC-Werte hat (`-DCOMDARE_ENABLE_PMC=ON` steht in
keinem der Logs). Die Logs sind damit der einzige Zugang zu einer offenen Ursachenfrage im
teuersten Posten des Projekts.

---

# TEIL 2 — DIE BAU-BEWERTUNG

## 2.0 Der Kern in einem Satz

**Vier Pakete schreiben dieselbe Datei (`experiment_plan_director.hpp`), und zwei Pakete aendern den
Fingerprint. Beides zusammengefasst heisst: EIN ce-Buendel vor dem Flottenbau, danach nie wieder.**

## 2.1 KLASSE (i) — BLOCKIERT DAS ERSTE 4096er-BATCH MORGEN

| Paket | Inhalt | Warum blockierend | Bahn |
|---|---|---|---|
| **B-A · GITLINK-NACHZUG** | super-Gitlink von `47c4ef1d` auf `b241a272` (ce-Kopf) | Die super-CI baut sonst eine ce OHNE die Build-Graph-Kante `678a4487` und ohne LB-6. Der Batch faehrt aus der super-Pipeline. | Landebahn |
| **B-B · FINGERPRINT-FORTPFLANZUNG** (R-3) | Glied [5] um Mess-Define-Feld erweitern (`MEASUREMENT_ON`, `ENABLE_PMC`); Format-Bump 3->4; golden-Id-Fixtures nachziehen | **Das Fenster schliesst mit der ersten gebauten Binary.** Heute: 0 `.fingerprint`-Sidecars = kostenlos. Danach: 34,4 h Neubau. | ce-Voll-Gate |
| **B-C · PMC-WELLE** (E-1, Owner-Pflicht) | i-1 `-DCOMDARE_ENABLE_PMC=ON` in die vier Emissionen **als Invariante, nicht am Job-Namen**; i-2 Preflight auf `pmc_available=1` verengen; i-3 `allow_failure` (`:1373`); T-ii-1 Emissions-Test | Owner: *"fixen und neu messen ist Pflicht"*. Und: PMC aendert den Bau -> **muss mit B-B in denselben Fingerprint-Bump**, sonst zweiter Voll-Bau. | ce-Voll-Gate |
| **B-D · XML-TRENNUNG** (R-2) | `<measure_selection>` in Schema + Parser + `ThesisProfile` + Traeger-Profil | Owner: *"sonst regression"*. Der erste Batch muss sagen koennen, was er baut und was er misst. | ce-Voll-Gate |
| **B-E · MESS-BATCH 4096** (R-2, 2. Teil) | Mess-Emission in `kGnBatchSlice`-Scheiben, wie die Bau-Emission | Owner: *"maximal 4096 jobs fuer compile **und Messung**"*. Heute nur compile. | ce-Voll-Gate |
| **B-F · BESTANDSLOG i-5/i-6** (E-3, Owner-Pflicht) | Default AN bzw. harte Wache; `bestand_fingerprint_fn` in **beide** `*_active`-Praedikate, fail-closed | Owner: *"Pflicht wie im Plan"*. Ohne Provider entsteht kein `.fingerprint` -> **jeder Wiederanlauf baut alles neu** (Laufzeit-Multiplikator, nicht Hygiene). | ce-Voll-Gate |
| **B-G · OBSERVABLETIER-AUDIT** (Owner-Auftrag, Deep Research) | Vertrags-Audit; Bau-Anteil = der `MEASUREMENT_ON`-Anteil aus B-B | Owner: *"der Vertrag der ObservableTier ist in Gefahr und muss auditiert werden"*. Die Achse selbst bleibt (*"KERN Achse des Planers"*). | read-only, dann ce |

**ENTSCHEIDE, DIE VOR DEM BATCH FALLEN MUESSEN:** R-1 (Mess-Umfang), R-2 (XML-Form), R-3 (Fingerprint-
Reichweite). Alles drei formt B-B/B-D/B-E.

## 2.2 KLASSE (ii) — BLOCKIERT DIE VOLL-MESSUNG (nicht den ersten Batch)

| Paket | Inhalt | Quelle |
|---|---|---|
| **B-H · MESS-SELEKTION FUELLEN** | Die aus R-1 folgende konkrete Selektion in die XML schreiben | R-1 |
| **B-I · L2/L3/KOHAERENZ** | I-PMC-2 (L3-Mapping + branch_misses) und I-PMC-3/#187 (L2 + coherence via Zen-5-RAW) | **Owner-KERN:** *"gehoert in die Messachse und wird durch die CEB einkompiliert nach Planer Freigabe ... direkt nachruesten nach Plan. PFLICHT und KERN der ANLAGE."* Ohne sie zeigt der Anhang selbst mit PMC nur L1D + dTLB (Ledger nachmittag-10 E). |
| **B-J · PHASEN-FORTPFLANZUNG** (Owner-Auftrag, Deep Research) | Vertrag **CEB vs Tier-Binary** / **CEB vs Tier-Hybrid-Binary** mechanisch schliessen: heute reist `kCebFingerprint` als Provenienz in den Bestandslog-Record (`profile_run_facade.cpp:901`, von mir verifiziert), **aber kein Gate vergleicht ihn**. `dll_is_current` kennt nur das `.fingerprint`-Sidecar. | Owner: *"Dadurch muss bei einem neuen Messsystem auch die CEB und ALLE Binaries fuer die Mess-Achsen-Einstellung neu gebaut werden"* |
| **B-K · V-06 ERST-BATCH-ABNAHME** | t/TU und Bytes/DLL aus dem ersten Batch gegen den Plattenstand abnehmen | Register `:437` |
| **B-L · EBENE-B-PUSH** | Nach R-6 aktivieren + df-Wache scharf | R-6 |
| **B-M · P11-PRE-FLIGHT / TRIGGER-CHECKLISTE** | B9 (umklassiert P4->P3), Env-Check, OD-7-Runner, Posten 89, **ein hart gruener Voll-Lauf** | Wellenplan WELLE 4: *"sonst faehrt der Trigger als Blackbox"* |
| **B-N · main-FF BEIDE REPOS** | ce 6, super 10 Commits Rueckstand (von mir gezaehlt) | Die Bridges triggern `branch: main` (E-13). Solange `main` zurueckhaengt, **gated die super-Pipeline gegen einen alten ce-Stand**. |

## 2.3 KLASSE (iii) — BLOCKIERT DIE ABGABE 15.09.

| Paket | Inhalt | Status |
|---|---|---|
| **B-O · chktex-HEILUNG DER WRITER** | **VON MIR GEMESSEN, harter Blocker:** 38 generierte `.tex` gegen die CI-Flags gefahren (`chktex -q -n36 -n17` mit `.chktexrc`, CWD-treu in `/tmp/chktexprobe/`) -> **EXIT 123, 31 Warnungen ueber 8 Dateien**. Vier Defekt-Klassen, alle in den C++-Writern:<br>· **W1 x28** — `\endfirsthead`/`\endhead`/`\endfoot`/`\endlastfoot` mit Folge-Leerzeichen (`04_csv_to_latex/csv_to_latex.cpp:673,678,969,974,1319,1324,1369,1374` + `08_appendix_generator/appendix_generator.cpp:207,212`)<br>· **W8 x1** — `latency_ecdf.tex:58`, Bindestrich statt Halbgeviert (`05_diagram_generator/diagram_generator.cpp:1921`, Literal `"ECDF der Gesamt-Latenz - Verteilung ueber Konfigurationen"`)<br>· **W11 x1** — `le_limitierung.tex:33`, literales `...` statt `\ldots`<br>· **W18 x1** — `le_limitierung.tex:35`, deutsche Anfuehrungszeichen statt `` `` ``/`''` | **NEU.** Sobald Anhang A generiert und committet wird, geht `lint:latex` (thesis `.gitlab-ci.yml:45-63`) **rot** — der Job hat seit REV2 **kein `\|\| true`** mehr. Heute gruen nur, weil die Dateien nicht im Repo liegen. |
| **B-P · ANHANG-A-EHRLICHKEIT** | Die widerlegte Limitierungs-Zeile (`anhang/{de,en}/A_measurements.tex`: *"Cache-Misses L1--L3 derzeit 0/nicht erhoben"*) steht neben einem Korpus mit `pmc_available=1` und realen L1-/dTLB-Zaehlern. Ausserdem: `le_limitierung.tex` behauptet *"Nur 4 Achsen variieren"*, der Korpus variiert **3**. | Owner: *"Aber **erst die Messdaten beheben**."* Register `:418` fuehrt es als daten-gated an Phase 6 — **das ist ueberholt, der Satz ist HEUTE widerlegt.** |
| **B-Q · M-9-VERDRAHTUNG** | 3 fertige Writer ohne Konsument (`sota_series`, `sweep_axis`, `seg_coverage`) | R-5 |
| **B-R · THESIS-MOUNT-REDUKTION** | Ein Mount, Doku deprecated | E-8, Scope-5-Bauanweisung |
| **B-S · OVERLEAF-NAHT** | thesis `origin/main` -> `github/main` (FF, 5 Commits) | E-9 |
| **B-T · P2 MESSWERT-LAGER** | Lager-Kaskaden + **xlsx-Geruest** (Scope 3: am Objekt **eine einzige Erwaehnung**, `lager_ziel_strategie.hpp:166`, ein Kommentar — kein Writer), B5 Mess-Schnitt, G-E3-Host-Binder, Posten-77/78-Auflagen | Leitplanke 4: *"VOR Messbeginn Pflicht"* — durch die Frist-Verschiebung nach (iii) entspannt, aber **wenn die Messung laeuft, ist es zu spaet**: das Lager nimmt die Daten auf. **Serialisierungs-Risiko, s. Rueckfrage an den Lead unten.** |
| **B-U · LB-6 BEWEISE 1+4** | Batch-Wiederaufnahme-Konstruktion (= B10); Bestandslog-E2E gegen echtes minio | Owner: *"Rueckfall moeglich mit wiederaufnahme -> wertvoll"* — der Beweis dieser Eigenschaft fehlt. |

## 2.4 KLASSE (iv) — DANACH

M-8 · M-15 (R-5) · KF-6-NTTP-Codegen / `organ_subaxes` (R-4) · `COMDARE_E4_CAP`-Umbenennung (E-10) ·
Vier-4096-Konstanten-Kopplung (M-4) · B3 OS-U4/A14-Rest · B8-Zitat-Drift · V-20-Sammelzeile ·
die bindende NACH-ABGABE-Kette (Register `:344`) · O-3 · W-11 · W2-Codegen-Zielform.

## 2.5 DIE NEUBAU-BUENDELUNG — der teuerste Fehler und wie er vermieden wird

**Ein zweiter Voll-Neubau kostet 34,4 h Wanduhr plus die Entwertung aller bis dahin gemessenen Daten.**
Es gibt genau **zwei** Aenderungsklassen, die ihn ausloesen:

**KLASSE ALPHA — aendert das Fingerprint-Preimage (entwertet 100 % der Flotte):**
`B-B` (Glied-Erweiterung + Format-Bump 3->4) · `B-C` (`ENABLE_PMC` wird bau-wirksam) ·
`B-G` (`MEASUREMENT_ON` wird stempelbar) · und **jede** kuenftige Aenderung an
`kMeasurementToolingRegistry` oder am `load_framework`.
=> **ALLE IN EIN BUENDEL, EIN BUMP, VOR DEM ERSTEN BATCH.**
Begruendung am Objekt: Glied [3] ist lauf-konstant und `dll_is_current` vergleicht das **ganze**
Preimage — eine Teilmenge der Flotte gibt es nicht. Scope 2 formuliert es korrekt:
*"Eine Mess-Achsen-Aenderung, die Glied [3] bewegt, invalidiert 100 % der Flotte."*

**KLASSE BETA — aendert die CEB, nicht die Tier-Binary:**
`B-I` (L2/L3/Kohaerenz) · `B-J` (Fortpflanzungs-Vertrag).
Hier ist der Owner-Satz die Spezifikation: *"muss bei einem neuen Messsystem auch die CEB und ALLE
Binaries fuer die Mess-Achsen-Einstellung neu gebaut werden"*. **Solange B-J nicht gebaut ist,
loest eine CEB-Aenderung KEINEN Binary-Neubau aus** — die Binaries blieben stehen und die Messdaten
waeren still inkonsistent. Sobald B-J gebaut ist, loest B-I einen Voll-Neubau aus.
=> **B-I und B-J muessen VOR dem Flottenbau zusammen entschieden sein.** Entweder beide vorher
(dann ein Bau), oder B-I bewusst als zweite Mess-Kampagne planen (dann zwei Baeue, bewusst).

**DIE EINE ZAHL, DIE DAS BUENDEL RECHTFERTIGT:**

    Alle Klasse-ALPHA- und -BETA-Posten vor dem Batch : 1 Voll-Bau = 34,4 h
    Ein einziger davon danach                        : 2 Voll-Baue = 68,8 h + Entwertung aller Messdaten
                                                       (bei 3 d Messung nach R-1-Weg (C): + 3 d)

**Explizit NICHT neubau-relevant** (duerfen jederzeit, auch nach dem Batch): B-O, B-P, B-Q, B-R, B-S
(alle super/thesis, beruehren keine Tier-Binary), B-T (Lager nimmt auf, veraendert nicht), B-N
(reiner FF), B-A (Gitlink).

---

# TEIL 3 — DIE DISJUNKTHEIT

## 3.1 Die Bahn-Obergrenze — bindend

Verbatim aus `docs/plaene/20260806-FAHRPLAN-parallel-sequenz-optimiert.md`, Leitplanken 1 und 2
(zitiert in `20260806-PLAN-wellenplan-...md:520-536`):

> "1. CPU: max EIN ce-Voll-Gate (-j6 nice, 2-Pass-Configure, Doppellauf 2x seriell) + max EIN
> super-Slot (-j3 nice); ohne Voll-Gate max zwei -j3.
> 2. Landebahn: EIN Koordinator (Lead), Landungen streng seriell, jeder Merge genau einmal."

| Bahn | gleichzeitig |
|---|---|
| ce-Voll-Gate | **1** |
| super-Slot | **1** |
| Landebahn | **1** |
| read-only / Doku / Analyse | **n** |

## 3.2 Die Datei-Mengen je Paket — `D(X)` = was das Paket SCHREIBT

| Paket | `D(X)` | Bahn |
|---|---|---|
| **B-A** | `Code/external/comdare-cache-engine` (Gitlink) | Landebahn |
| **B-B** | `abi/anatomy_fingerprint.hpp` · `abi/anatomy_version_stamp.hpp` · `abi/toolchain_stamp_glied.hpp` · `profile_facade/profile_run_facade.cpp` · `builder/build_orchestrator/build_orchestrator.hpp` · `tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt` + Stempel-Tests | ce-Voll-Gate |
| **B-C** | `profile_facade/planner/experiment_plan_director.hpp` · `tests/.../linux_perf_pmc_smoke.cpp` · `tests/unit/.../test_experiment_plan_director.cpp` | ce-Voll-Gate |
| **B-D** | `common/serialization/xml_config_parser/xml_config_parser.{hpp,cpp}` · `experiment_schema.xsd` · `algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml` · `profile_facade/profile_run_entry.hpp` · `profile_facade/validate_profile.hpp` | ce-Voll-Gate |
| **B-E** | `profile_facade/planner/experiment_plan_director.hpp` · dessen Test | ce-Voll-Gate |
| **B-F** | `profile_facade/profile_run_entry.hpp` · `profile_facade/profile_run_facade.hpp` · `profile_facade/planner/experiment_plan_director.hpp` | ce-Voll-Gate |
| **B-G** | (Audit read-only) danach ggf. `anatomy/observable_tier.hpp` · `anatomy/abi_adapter.hpp` | read-only -> ce |
| **B-O** | `Code/04_csv_to_latex/csv_to_latex.cpp` · `Code/05_diagram_generator/diagram_generator.cpp` · `Code/08_appendix_generator/appendix_generator.cpp` | super-Slot |
| **B-Q** | `Code/08_appendix_generator/appendix_generator.cpp` · `thesis .../anhang/{de,en}/A_measurements.tex` | super-Slot |
| **B-P** | `thesis .../anhang/{de,en}/A_measurements.tex` | thesis (kein Bau-Gate) |
| **B-R** | `.gitmodules` · Gitlink · 2 Plan-Doks (Deprecation-Kopf) | super-Slot |
| **B-S** | (nur Push, kein Baum) | Landebahn |
| **B-T** | `Code/…` Lager-/xlsx-Pfade + ce `builder/bestandslog/*` | super-Slot **und** ce — s. Konflikt K-5 |

## 3.3 DIE KONFLIKTE — und die daraus folgende Serialisierung

| # | Konflikt | Beweislage | Konsequenz |
|---|---|---|---|
| **K-1** | **B-C, B-E, B-F schreiben ALLE `experiment_plan_director.hpp`** | Von mir am Objekt: die Datei traegt `allow_failure` (`:1373`), den PMC-Preflight (`:1362`), das Mess-Fenster (`:1367`), die Bau-Slice-Schleife (`:1240-1252`) und die Bestandslog-Durchreichung (`:952-955`) | **EIN PAKET.** Nicht drei Wellen — drei Wellen hiessen drei Voll-Gates und zwei garantierte Merge-Konflikte in derselben Datei. |
| **K-2** | **B-B beruehrt `profile_run_facade.cpp`, B-F beruehrt `profile_run_facade.hpp`** | `perm_mess_defines()` (`.cpp:273-275`) vs. die `*_active`-Praedikate (`.hpp`) | Verschiedene Dateien, aber **dieselbe Uebersetzungseinheit und derselbe Vertrag**. Disjunktheit **nicht beweisbar** -> **serialisieren, bzw. in K-1 mit aufnehmen.** |
| **K-3** | **B-D beruehrt `profile_run_entry.hpp`, B-F ebenfalls** | `provision_only` (`:213`) und `bestand_fingerprint_fn` liegen in derselben Struktur | **serialisieren, bzw. in K-1 mit aufnehmen.** |
| **K-4** | **B-O und B-Q schreiben beide `08_appendix_generator/appendix_generator.cpp`** | B-O heilt `:207,212` (chktex-W1), B-Q verdrahtet die drei M-9-Writer in die Facade | **serialisieren: B-O zuerst** (sonst erzeugt B-Q neue W1-Verstoesse, die B-O bereits geheilt hatte). |
| **K-5** | **B-T schreibt in beide Repos** | Lager-Kaskaden (super) + Bestandslog-Baumform (ce `builder/bestandslog/`) | **Disjunktheit nicht beweisbar gegen B-F** (`builder/bestandslog/`). -> **B-T strikt NACH dem ce-Buendel.** |
| **K-6** | **B-R aendert `.gitmodules`** | `.gitmodules` steht in der `changes`-Liste **aller drei** Bridges (`.gitlab-ci.yml:249, :267, :285`; Scope-5-Befund) | Kein Bruch, aber **drei Kind-Pipelines je Landung**. -> **allein landen, nicht mit einer Bau-Welle buendeln.** |
| **K-7** | **B-A vs. jede ce-Landung** | Der Gitlink zeigt auf einen ce-Commit | **B-A ist immer der LETZTE Schritt** einer ce-Landung, nie ein eigenstaendiges Paket. |

## 3.4 DIE RESULTIERENDE REIHENFOLGE

```
LANDEBAHN (seriell, EIN Koordinator)
  |
  L-0  B-A Gitlink-Nachzug auf b241a272        [sofort, Minuten -- heilt die aktuelle Drift]
  |
  +--> [OWNER: R-1, R-2, R-3]  <-- HARTER STOPP, alles Weitere haengt daran
  |
  L-1  ce-BUENDEL "MESS-ANLAGE"  = B-B + B-C + B-D + B-E + B-F + B-G(Bau-Anteil)
  |      EIN Branch, EIN Voll-Gate, EIN Dual-Review, EINE Landung, EIN Fingerprint-Bump 3->4
  |      Begruendung: K-1 + K-2 + K-3 (gemeinsame Dateien) UND Klasse ALPHA (gemeinsamer Neubau)
  |      -> ce main-FF (6 Commits Rueckstand) -> super-Bump -> super main-FF (10) -> gruen
  |
  L-2  B-M Trigger-Checkliste + P11 + ein hart gruener Voll-Lauf
  |
  L-3  ERSTER 4096er-BATCH  -> liefert B-K (t/TU, Bytes/DLL)
  |      -> [OWNER: R-6 Ebene-B, jetzt MIT Zahl]
  |
  +--> [OWNER: R-4 Bau-Umfang]  -> B-H Mess-Selektion fuellen
  |
  L-4  VOLL-BAU (34,4 h) -> VOLL-MESSUNG (nach R-1)


super-SLOT (parallel zu L-1, nachweislich disjunkt: 0 gemeinsame Dateien mit dem ce-Buendel)
  |
  S-1  B-O chktex-Heilung der drei Writer      [muss vor B-Q]
  S-2  B-Q M-9-Verdrahtung                     [K-4: nach B-O]
  S-3  B-R Thesis-Mount-Reduktion              [K-6: allein landen]
  S-4  B-T P2 Messwert-Lager                   [K-5: erst NACH L-1]


READ-ONLY (n Agenten, jederzeit)
  |
  B-G Audit-Anteil (ObservableTier-Vertrag) · B-J Fortpflanzungs-Analyse · B-I Deep Research
  L2/L3/Kohaerenz · B-P Anhang-Ehrlichkeits-Textpass (Entwurf) · B-U LB-6-Beweis-Entwuerfe
  · Ledger-Nachtrag (NUR der Lead, nach der Landung, einmal -- Wellenplan Teil 5 Punkt 5)


THESIS-BAHN (eigene Pipeline, kein ce-/super-Gate)
  |
  B-S Overleaf-Naht (FF, 5 Commits) · B-P Anhang-A-Ehrlichkeit
```

## 3.5 WAS AUSDRUECKLICH NICHT PARALLEL GEHT

Zusaetzlich zu den 10 Punkten des Wellenplans (Teil 5) gelten aus dieser Konsolidierung:

11. **B-C, B-E, B-F nicht als getrennte Wellen** (K-1). Eine Datei, ein Schreiber.
12. **Kein Klasse-ALPHA-Posten nach dem ersten Batch.** Das Fenster schliesst mit der ersten
    geschriebenen `.fingerprint`-Datei.
13. **B-Q nicht vor B-O** (K-4).
14. **B-T nicht neben dem ce-Buendel** (K-5).
15. **B-R nicht gebuendelt** (K-6, drei Kind-Pipelines).

## 3.6 WO ICH DISJUNKTHEIT NICHT BEWEISEN KANN — serialisiert

| Paar | Warum unbewiesen |
|---|---|
| B-B / B-F | K-2: `profile_run_facade.{hpp,cpp}`, gemeinsamer Vertrag |
| B-D / B-F | K-3: `profile_run_entry.hpp`, gemeinsame Struktur |
| B-T / B-F | K-5: `builder/bestandslog/` in beiden |
| B-I / B-J | beide beruehren die CEB-Mess-Provenienz (`ceb_version_stamp.hpp`); der Schnitt ist erst nach dem Deep Research bekannt |
| B-G / B-B | der ObservableTier-Audit kann `abi_adapter.hpp` beruehren, das B-B ueber das Define mitbestimmt |

**Alle fuenf sind im ce-Buendel L-1 zusammengefasst — das ist die Serialisierung.**

---

# ANHANG — WAS ICH SELBST GEMESSEN HABE (Reproduktionsanweisung)

| Aussage | Kommando |
|---|---|
| Repo-Staende, main-FF-Rueckstaende, Gitlink-Drift | `git rev-parse` / `git rev-list --count` / `git ls-tree HEAD` in super, ce, thesis |
| chktex-Gate rot, EXIT 123, 31 Warnungen / 8 Dateien | `.chktexrc` + generierte `.tex` nach `/tmp/chktexprobe/`, dann `find . -name "*.tex" -not -path "./_*" -print0 \| xargs -0 -r chktex -q -n36 -n17` |
| 109,4 ms Mittel je Messung, 16 Zeilen | `awk -F';' 'NR>1{s+=$5;n++} END{print s/n/1e6}' measurement/20260726-…/measurements.csv` |
| `total_ns == n_ops * ns_per_op` | Kontrollrechnung Zeile 2: `10000 * 44839,087 = 448.390.870` = `total_ns` |
| Mess-Faecher 216 | `all_axes_golden.profile.xml:112,126,156,157,160` + Schleifen-Nachweis `profile_run_entry.hpp:165-166, 365-380` |
| Mess-Batch NICHT in 4096er-Scheiben | `experiment_plan_director.hpp:1367-1369` vs. Bau-Schleife `:1240-1252` |
| 4 entkoppelte `4096`-Literale | `grep -rn "kGnBatchSlice\s*=\|kBuildSliceGrain\s*=\|kMaxMaterializable…\s*="` + Suche nach koppelndem `static_assert` = **0 Treffer** |
| `ThesisProfile` ohne Bau/Mess-Trennung | `xml_config_parser.hpp:242-302` vollstaendig gelesen |
| `dll_is_current` = EIN Vergleich | `build_orchestrator.hpp:330-337` |
| Fingerprint-Glieder = 8, Toolchain-Felder = 9 ohne Mess-Feld | `anatomy_fingerprint.hpp:462-472` · `toolchain_stamp_glied.hpp:246-248` |
| `MEASUREMENT_ON` bau-wirksam | `profile_run_facade.cpp:274` · `abi_adapter.hpp:393` · `observable_tier.hpp:191,222` |
| `COMDARE_ENABLE_PMC` = 0 Treffer im Director | `grep -n "COMDARE_ENABLE_PMC" experiment_plan_director.hpp` |
| `kCebFingerprint` reist als Provenienz, kein Gate | `profile_run_facade.cpp:901` -> `planer_block_value.hpp:59-66` -> `bestandslog_document.hpp:256` |

**UNBELEGT und in dieser Rolle nicht belegbar:** durchschnittliche `.so`-Groesse der golden-Flotte
(Bezugsgroesse fuer R-6) · minio-/Ebene-B-Bestand (Cluster read-only) · Ursache der PMC-Werte im
d03-Korpus (`-DCOMDARE_ENABLE_PMC=ON` steht in keinem der vier Logs) · die Slice-Bauzeiten
19,4/32,25 min (UEBERNOMMEN aus `docs/sessions/20260723-SESSION-mittag-neustart-zug-vollbau4.md:41-45`,
von mir nicht nachgemessen).
