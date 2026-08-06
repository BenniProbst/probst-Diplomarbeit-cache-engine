# ANKLAGESCHRIFT KOSTENKLAMMERN -- Plan-SOLL gegen Code-IST

Stand 2026-08-06 abends. Lead-Synthese (Opus, max effort), READ-ONLY, kein Commit.
Erhebungsbasis: ce-Arbeitsbaum `/home/comdare/wt-b2-neuanker` (HEAD `034e0068`), super
`/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine` (ce-Submodul `3bbcb8ed`),
Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (Volltext), Dossiers 01.08.
Alle Kern-Fundstellen wurden AM OBJEKT nachgelesen -- Zeilennummern in diesem Dokument
sind am oben genannten Stand geprueft, nicht aus Vorlagen uebernommen.

Owner-Doktrin, die diesen Auftrag traegt (verbatim):
> "Bitte starte einen explore Agenten der alle Kostenklamern findet und als diff nicht
> verifiziert warum sie stimmen koennten, aber scharf kritisiert, welche geplante und
> spaetere Arbeit sie zerstoert haben. [...] Jede einzelne Ledger Aussage gehoert geprueft
> gegen den code und wir sind entschieden GEGEN Kostenklammern und FUER maximale sauberkeit
> und hohes Niveau bei der Implementierung."

Dieses Dokument rechtfertigt KEINE Klammer. Es benennt, was sie zerstoert hat.

---

## 1. BEFUND IN EINEM ABSATZ

Neun Kostenklammern sind am Objekt belegt, dazu zehn weitere aus dem Codex-Durchgang, die
ich nicht selbst nachgelesen habe; von den neun belegten zerstoeren **vier** unmittelbar
geplante Arbeit -- und die schwerste davon trifft nicht Buchhaltung, sondern die empirische
Substanz der Arbeit selbst: der vom Planer erzeugte Voll-Mess-Batch (der Weg, der den
statischen Mess-Job ausdruecklich abgeloest hat und der die 131.072-Zellen-Matrix faehrt)
konfiguriert `cmake` an vier Emissionsstellen **ohne** `-DCOMDARE_ENABLE_PMC=ON`, obwohl
der Owner dieses Flag am 16.07. als "PFLICHT fuer Vollstaendigkeit aller perf-Messwerte"
gesetzt hat -- und der eigens dagegen gebaute "harte PMC-Preflight" wertet genau den
Ausfall, gegen den er gebaut wurde (alle Zaehler 0), als Erfolg und stempelt `pmc=ok`, in
einem Job, der zusaetzlich `allow_failure: true` traegt. Das gemeinsame Muster aller neun
ist identisch und benennbar: **eine Faehigkeit wird nicht verdrahtet, weil ihr Fehlen
HEUTE nichts sichtbar macht** -- die Rechtfertigung heisst mal "opt-in / byte-neutral", mal
"golden-neutral", mal "INERT-by-default", mal "wird ohnehin nicht gelesen"; in jedem Fall
wird ein Zustand, der als Uebergang gemeint war, zum Dauerzustand, und die Wache, die ihn
haette melden sollen, ist so gebaut, dass sie ihn nicht melden kann. Der Preis ist nicht
Rechenzeit, sondern **Beweiskraft**: mehrere Tage Review- und Bauarbeit (T2-A/F4-Eichung,
Bestandslog/Lager, axis-version-lock-Tripwire) sind heute nur an Test-Nahten bewiesen und
haben in keinem realen Lauf je gegriffen.

---

## 2. DIE KLAMMERN, NACH SCHADEN SORTIERT

### KK-1 [ZERSTOERT GEPLANTE ARBEIT -- SCHWERSTER POSTEN] Der Voll-Mess-Batch misst ohne PMC, und sein "harter" Preflight zertifiziert das als Erfolg

**Ort (vier Emissionsstellen, eine Wache, ein Freibrief):**
- `libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:841, 877, 1194, 1342`
  -- alle vier `cmake -B build`-Emissionen setzen `-DCOMDARE_V32_ENABLE=ON`, **keine** setzt
  `-DCOMDARE_ENABLE_PMC=ON`. Repo-weite Gegenprobe: der String `COMDARE_ENABLE_PMC` kommt in
  dieser Datei **null** Mal vor -- im Arbeitsbaum wie im gelandeten Submodul (`3bbcb8ed`).
- `CMakeLists.txt:67` -- `option(COMDARE_ENABLE_PMC ... OFF)`; ohne das Flag definiert CMake
  das Makro nicht (`:77`), und `pmc_source_factory.hpp:30-32` liefert dann `NullPmcSource`.
- `experiment_plan_director.hpp:1362-1364` -- der Preflight baut `m3v2_pmc_smoke` und
  `linux_perf_pmc_smoke` **in genau diesem flaglosen Baum** und ruft `ctest -L pmc`.
- `tests/unit/thesis_tiere/m3v2_pmc_smoke.cpp:71` -- `pmc_seam_ok = delta.available || counters_all_zero`.
- `tests/unit/CMakeLists.txt:3552-3554` -- `linux_perf_pmc_smoke` wird unter `if(UNIX AND NOT APPLE)`
  registriert, **unabhaengig vom Flag**; sein dokumentiertes Verhalten ohne Zugriff ist
  "sauberer Skip (Exit 0, available==0)". Der Preflight bricht also nicht einmal am fehlenden Target ab.
- `experiment_plan_director.hpp:1333` -- `allow_failure: true` auf demselben Job.

**Die zitierte Begruendung -- sie steht direkt ueber dem Preflight (`:1353-1360`, verbatim):**
> "G4a #37 / §66-N2 (PMC-DOKTRIN je Vendor): HARTER PMC-Preflight auf DIESER Lane-Maschine, VOR der ersten
> Messung. Grund: die super-Pipeline haelt zwar pmc:amd/pmc:intel hart, aber dieser Batch laeuft im
> GRANDCHILD-Strang und kann auf jene Jobs kein `needs:` setzen -- **ohne Preflight koennte eine Lane eine
> mehrtaegige Messung mit kaputtem perf_event_open durchlaufen und lauter 0-Zaehler produzieren.**"

Und `:1362-1364` emittiert daraufhin `echo "[PMC-TESTAT] ... pmc=ok"`.

**Das Plan-SOLL, woertlich, drei unabhaengige Belege:**
1. LEDGER Z.532 (2026-07-16): *"**I-PMC-1 (F9, User-PFLICHT):** `-DCOMDARE_ENABLE_PMC=ON` in GENAU die 2
   Mess-Jobs [...] Damit schreibt der naechste echte Mess-Lauf `pmc_available=1` + reale `cache_misses_l1`
   (prod1-Beweis 25.06.: 4.190.096)."* Der Owner-Wortlaut dazu, wie er im super-CI zitiert steht
   (`.gitlab-ci.yml:672 / :763`): *"I-PMC-1 (F9, User 2026-07-16 'PFLICHT fuer Vollstaendigkeit aller
   perf-Messwerte')"*, mit dem Nachsatz: *"Ohne das Flag schrieb der offizielle Mess-Lauf
   pmc_available=0/honest-0 trotz fertiger Infra."*
2. LEDGER Z.555 (2026-07-13, honest-100%-Doktrin, User): *"'alles echt gemessen und validiert, nur
   honest-100% akzeptabel' -- in-code-berechenbare Werte MUESSEN real implementiert werden
   (keine Synthese=Phantom, kein Weg-Nullen=honest-0-Aufgeben); [...] PMC/HW-Werte real verdrahtet lesen."*
3. LEDGER Z.3499 (§66-NACHTRAG-2, User 23.07., "KERN=Gesetz"): *"Je Maschine ihr EIGENER PMC-Pflicht-Beweis
   [...] BEIDE hart (kein Gate/allow_failure) -- 'eine Lane darf den gesamten Strang erst abarbeiten, wenn
   IHR pmc-Job erfolgreich ist'."*

**Das Diff:**

| | SOLL | IST |
|---|---|---|
| Flag | `-DCOMDARE_ENABLE_PMC=ON` in JEDEM Mess-Bau (Owner: "PFLICHT") | 4/4 Emissionen des Planers ohne Flag; nur die beiden STATISCHEN super-Jobs (`measure:smoke:672`, `measure:golden-320:763`) tragen es -- und `measure:smoke` ist ausdruecklich als DEPRECATED-Fallback stillgelegt (`super .gitlab-ci.yml:665-669`, "durch die dynamische Kette [...] abgeloest", laeuft nur mit `COMDARE_STATIC_SMOKE_FALLBACK=true`) |
| Wache | "HART in BEIDEN Profilen, auch smoke" (§66-N2: kein Gate, kein allow_failure) | Verdikt `available \|\| counters_all_zero` -- der Ausfallfall IST das Erfolgskriterium; zusaetzlich `allow_failure: true` (`:1333`) |
| Messwerte | `pmc_available=1`, reale `cache_misses_l1/l2/l3`, `dtlb_misses`, `coherence_invalidations` | `NullPmcSource` -> `available=0`, alle sieben Spalten strukturell 0 -- exakt der Zustand, den LEDGER Z.555 als "honest-0-Aufgeben" ausdruecklich verbietet |

**Was zerstoert ist:** Die 131.072-Zellen-Vollmatrix -- der empirische Kern der Diplomarbeit --
liefert auf diesem Weg **keine Cache-Miss-Zahlen**. Eine Arbeit ueber eine Cache-Engine, deren
Voll-Messlauf die Cache-Zaehler nicht einschaltet, verliert genau die Groesse, die ihre These
traegt. Der Schaden ist doppelt: (a) I-PMC-1 wurde am 16.07. gebaut, verifiziert und im Ledger
als erledigt gebucht -- und beim Umbau auf die dynamische Kette (die den statischen Job ersetzte)
**nicht mitgezogen**; das ist ein Rueckfall in einen bereits geschlossenen Zustand. (b) Die Wache,
die genau diesen Rueckfall haette melden muessen, wurde so formuliert, dass sie ihn nicht melden
kann -- und meldet stattdessen `pmc=ok`. Die Inversions-Reparatur vom 13.07. (Kommentar
`m3v2_pmc_smoke.cpp:60-66`: live-PMC darf nicht rot faerben) war richtig; falsch war, sie zum
ALLGEMEINEN Verdikt zu machen, statt sie am Preflight-Ort auf `delta.available` zu verengen.

---

### KK-2 [ZERSTOERT GEPLANTE ARBEIT] `COMDARE_BESTANDSLOG` als Opt-in -- der gesamte Lager-/Resume-/Skip-Komplex ist in jedem real gelaufenen Pfad tot

**Ort:** `libs/cache_engine/profile_facade/profile_run_entry.hpp:436`
```cpp
char const* const bl = std::getenv("COMDARE_BESTANDSLOG");
if (bl == nullptr || std::string_view{bl} != std::string_view{"true"}) return ex::FingerprintFn{};
```
**Die zitierte Begruendung (`:424`, verbatim):**
> "I2 (Lager-Gate): **opt-in** Fingerprint-Provider fuer das .fingerprint-Sidecar (Lager-Index-Anker) [...]
> Gated auf COMDARE_BESTANDSLOG (**Default aus => leer => kein Sidecar => byte-neutral**)."

**Gegenprobe am Objekt:** `COMDARE_BESTANDSLOG` wird als **Wert** an genau zwei Stellen gesetzt --
`tests/unit/test_t2a_f4_facade_plan_durchreichung.cpp:188` und
`tests/unit/thesis_tiere/test_experiment_plan_director.cpp:845`, beide `::setenv` im Test.
In `.gitlab-ci.yml` (ce, 37.256 Byte) und `.gitlab-ci.yml` (super, 90.532 Byte): **null Treffer**.
`apps/experiment_planner/main.cpp:88` liest die Variable und quittiert den Normalfall wortwoertlich
als `// stumm inert`. Der leere Provider reist unveraendert nach `cfg.bestand_fingerprint_fn`
(`profile_run_entry.hpp:632`) und weiter nach `BuildOrchestrator::fingerprint_`, dem **einzigen**
Aufrufer von `dll_is_current`; bei leerer Erwartung gibt `dll_is_current` fail-closed `false` --
jeder produktive Lauf baut also jede Binary neu.

**Das Plan-SOLL, woertlich:**
1. F7 SHA512-ONLY-SKIP-GATE-SPEZ (Owner 01.08., `docs/sessions/20260801-KONSOLIDIERT-...md`, Abschnitt 6):
   *"Die Skip-Pruefung laeuft kuenftig NUR gegen die komplex geplante SHA512-Validierung -- sie deckt ALLE
   Stempel allein ('das war der Sinn des SHA512'). **VERDRAENGT:** dll_is_current-Dreifach-Stringvergleich
   [...] **UND den G-C1-Vorschlag 'Fingerprint als VIERTES Gate, opt-in'**."* Und:
   *"UEBERGANGS-REGEL Bestands-Sidecars ohne .fingerprint: FAIL-CLOSED [...] **KEINE Grandfathering-Logik.**"*
2. Owner 05.08. abend-10, Antwort A1 (Freigabe des Zaehler-Resume): *"Nun der Store muss zurueckrollen
   koennen und ohne grosse Verluste resumen. [...] Daher stimme ich deiner Empfehlung mit meiner Anregung
   zu, die Batches persistent vor dem Lauf zu planen. **Freigabe.**"*
3. F9 (01.08.): *"Der Voll-Bau-Trigger IST der Baum-Vollausbau -- Lagerhaltung SAMT BAUM muss VOR dem
   Compile stehen."*

**Das Diff:** Der Plan sagt "ersetzt das alte Gate, immer aktiv, ausdruecklich NICHT opt-in".
Der Code sagt im Kommentar woertlich "opt-in" -- also exakt den vom Plan verworfenen Vorschlag G-C1.
Der Plan sagt "KEINE Grandfathering-Logik"; faktisch ist **jeder** bisherige Lauf ein
Grandfathering-Lauf, weil das Gate strukturell nie greift.

**Was zerstoert ist:**
- Der komplette **T2-A/F4-Eichungsstrang** (Indexfolge-Digest v2, Frozen-Fingerprint-Zeugen,
  Preimage-Format 2->3, Multi-Writer-tmp, `|fpr=`-Haertung; mehrere Tage Fable/Codex/Opus-Review,
  Commits bis `6c300e68`) ist ausschliesslich an injizierten Test-Seams bewiesen. Der Skip hat in
  **keinem** CI-Job je ausgeloest.
- Der am 05.08. persoenlich freigegebene **Zaehler-Resume** hat ohne Provider keinen Anker
  (-> KK-8) und kann zwei Bau-Staende nicht unterscheiden.
- **F9/LB-0..LB-6 (Lager-Baum-Paketschnitt)**, als Vor-Trigger-PFLICHT deklariert, haengt an der
  Fingerprint-Blattidentitaet, die noch nie geschrieben wurde.
- **Task #9 (Lager-Basis-Tests, Owner-KERN 06.08.)**: die geplante Factory soll Stempel aus Binaries
  und xlsx-Legende erkennen -- es gibt in Produktion kein einziges `.fingerprint`-Sidecar zu erkennen.
- **N=2^17**: ohne funktionierendes Skip-Gate zahlt jeder Lauf vollen Neubau fuer 131.072 Binaries --
  gebaut wurde die Architektur, um genau das zu vermeiden.

---

### KK-3 [ZERSTOERT GEPLANTE ARBEIT] `contract:axis-version-lock` doppelt definiert -- der harte Digest-Tripwire ist abgeschaltet

**Ort:** `.gitlab-ci.yml` (ce) definiert denselben Job-Key zweimal: `:343` und `:502`.
In GitLab-YAML gewinnt die **letzte** Definition.

**Die zitierten Begruendungen -- beide stehen im selben File, sie widersprechen sich:**
- `:339` (erste, verliert): *"contract:axis-version-lock (GN-8/O-4, Ledger Sec.32-F4): der
  Heuristik-Header-Tripwire als **HARTES CI-Gate**. Digest-Drift an axis_spline/break_even/
  measurement_curve_loader OHNE algo_version-Bump -> Exit 1 -> Job ROT."*
- `:501` (zweite, gewinnt): *"**INERT-by-default: rules-gated auf COMDARE_AXIS_LOCK_CHECK=="true"**;
  zum Dauergate: rules-Zeile weg."* -- mit `rules: - if: '$COMDARE_AXIS_LOCK_CHECK == "true"'` (`:508`).

**Gegenprobe:** `COMDARE_AXIS_LOCK_CHECK` wird in ce und super **nirgends gesetzt** (nur die beiden
Zeilen der Definition selbst). Der Tripwire laeuft in keiner Pipeline.

**Das Plan-SOLL:** Ledger Sec.32-F4 / GN-8 / O-4 fuehren den Content-Digest-Tripwire als hartes Gate.
LEDGER §51-B7 nennt ihn als **Voraussetzung fuer N=2^17**.

**Das Diff:** SOLL = Dauergate, rot bei Header-Drift ohne `algo_version`-Bump. IST = ein Job, der nur
laeuft, wenn jemand eine Variable setzt, die niemand setzt. **Was zerstoert ist:** die drei
Heuristik-Strategie-Header (`axis_spline.hpp`, `break_even.hpp`, `measurement_curve_loader.hpp`)
koennen sich seit dem Einbau der zweiten Definition beliebig veraendert haben, ohne dass eine
Versionsnummer nachgezogen wurde -- und genau diese Header bestimmen die Heuristik-Messkurven,
also erneut Thesis-Substanz. Zusatz-Anklage: der Befund steht bereits als Satz in der eigenen
Taskliste (#6: "contract:axis-version-lock ist DOPPELT definiert -> Tripwire de facto AUS") --
er ist erkannt und unbehoben.

---

### KK-4 [LAEUFT STILL FALSCH, SOBALD DIE NAECHSTE STUFE KOMMT] `bestandslog_active` prueft Funktionshuellen statt Schluesselwerte

**Ort:** `libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:1658-1660`
```cpp
bool const bestandslog_active = static_cast<bool>(cfg.bestand_transport.fetch) &&
                                static_cast<bool>(cfg.bestand_transport.store) &&
                                static_cast<bool>(cfg.bestand_key_of) && !cfg.bestand_doc_key.empty();
```
`cfg.bestand_fingerprint_fn` -- der Traeger der Identitaet -- kommt in dieser Bedingung **nicht** vor.

**Die zitierte Begruendung (`:1655-1657`):** *"Aktiv NUR, wenn Transport (fetch+store) + Doc-Key +
Key-Provider gesetzt sind; sonst No-Op => byte-neutral (Muster wie cache_pull)."*

**Der Gegenbeweis steht im selben File, 460 Zeilen darueber (`:1194`, eigener Kommentar):**
> "PRODUKTIV ERREICHBAR, nicht theoretisch: profile_run_entry.hpp LEERT den Provider ohne das
> COMDARE_BESTANDSLOG-Opt-in (:436), bei unbekannter Tier-Realversion (:438, T2-C) und beim
> `na`-Zellwert (:1013, W10-C4) -- **waehrend bestandslog_active an keinem der drei haengt.**"

**Das Diff:** Die Plan-Ebene hat die fail-closed-Konsequenz nachgezogen (`plan_anker_befund`, `:1204ff`),
die **Lager-Ebene nicht**. Sobald jemand das Env-Gate von KK-2 oeffnet (was der Plan verlangt), ist
`bestandslog_active` in genau den zwei Faellen wahr, in denen es falsch sein muesste (T2-C:
unbekannte Tier-Realversion; `na`-Zellwert): das Lager registriert dann Eintraege ohne pruefbaren
Identitaets-Anker. Das ist die Klammer-Form "Wache prueft EXISTENZ statt WERTE" in Reinform -- und
sie wird erst schaedlich, wenn KK-2 repariert wird. Wer nur KK-2 repariert, schaltet KK-4 scharf.

---

### KK-5 [ZERSTOERT GEPLANTE ARBEIT -- WACHE] `allow_failure: true` am Voll-Mess-Batch

**Ort:** `experiment_plan_director.hpp:1333`, direkt unter dem Kommentar:
> "Sichtbarkeits-Doktrin: Mess-Fehler => CSV 'failed' + Log, die Pipeline bleibt gruen (nicht still verschluckt)."

**Das Plan-SOLL** (Memory-KERN `feedback_measurement_failure_visibility_csv_failed_not_null_plus_log`):
Mess-**Fehler** sollen als `'failed'` in der CSV sichtbar sein statt als NULL -- die Doktrin regelt die
DATEN-Sichtbarkeit einzelner Zellen. §66-N2 dagegen sagt fuer die PMC-Strecke ausdruecklich
*"BEIDE hart (kein Gate/**allow_failure**)"*.

**Das Diff:** Die Zell-Sichtbarkeits-Doktrin wurde auf die **Job-Ebene** ausgedehnt, wo sie nicht
gilt. Konsequenz: ein Batch, der am Preflight, am Treiberbau, am Storage oder mitten im Lauf
scheitert, faerbt die Pipeline nicht rot. Zusammen mit KK-1 heisst das: ein mehrtaegiger Messlauf
kann ohne PMC laufen, sein Preflight meldet `pmc=ok`, und selbst wenn er abbricht, bleibt alles gruen.
**Drei Wachen hintereinander, keine kann ausloesen.**

---

### KK-6 [VERZOEGERT / NIVEAU] `PlanFach::offen` wird erhoben, geschrieben -- und von keiner Entscheidung gelesen

**Ort:** `libs/cache_engine/builder/bestandslog/batch_planner.hpp:163` (Feld), `:246` (Rendern),
`:305` (reine Konsistenzpruefung beim Parsen), `:217-232` (`plan_resume_faecher` -- benutzt
ausschliesslich `f.count`).

**Die zitierte Begruendung (`:157-159`):** *"`offen` ist bewusst nur eine Zahl: das Dokument haelt die
ORDNUNG und die FAECHER fest [...] nicht die Miss-Liste -- die ist Lauf-Zustand und wird beim naechsten
Lauf ohnehin frisch erhoben."*

**Das Plan-SOLL** (LEDGER 23.07., BATCH-PLANUNGS-PRAEZISIERUNG): *"Fuer die Lagerhaltung wird jedes
fehlende Binary EINZELN erkannt [...] Konsolidierung + Batch-Planung erfolgen ZU BEGINN, VOR dem ETA,
ASYNC ueber ALLE Binaries."* Und F5: *"ETA-Berechnung ist das zu implementierende Prinzip genau dieses
Kalibrierungslaufes."*

**Das Diff:** Der Resume-Entscheider arbeitet auf Fach-Granularitaet ("ganz oder gar nicht"), obwohl die
Atom-Granularitaet bereits **bezahlt und persistiert** ist. Ein Fach mit 4096 Atomen, von denen 3
fehlten, wird behandelt wie ein leeres Fach. **Was verzoegert ist:** die Mini-Batch-ETA (F5/F6) braucht
genau diese Zahl; sie muss spaeter erst wieder angeschlossen werden. Kein akuter Datenverlust
(`dll_is_current` faengt jedes Einzelatom weiterhin ab) -- aber eine erhobene Groesse, die im Dokument
liegt und nirgends wirkt, ist genau die Sorte Halb-Verdrahtung, die der Owner-KERN 13.07. als
"unverdrahtet/unfertig, nicht tot" benannt hat.

---

### KK-7 [VERZOEGERT / NIVEAU] `active_telemetry_is_silent()` gibt literal `false` zurueck und ignoriert das geparste Profil

**Ort:** `libs/cache_engine/profile_facade/profile_run_facade.cpp:240-241`
```cpp
[[nodiscard]] bool active_telemetry_is_silent() {
    return false; // Default = Active (TelemetryMode::Active); A9.3 golden-neutral: kein Profil-Wiring (s.o.)
}
```
**Die zitierte Begruendung (`:234-239`, verbatim):**
> "BEWUSST KEIN Profil-Wiring hier: telemetry IST eine Registry-System-Achse [...] UND die
> golden-320-Profile deklarieren `<telemetry silent="true">` -- ein Durchreichen von telemetry_silent
> haenge +tel=silent ans golden-build_version und **BRECHE die Byte-Identitaet** [...] Das
> telemetry_silent-Wiring ist damit ein bewusst golden-BRECHENDER Folge-Schritt (eigene Absprache)."

**Das Diff:** Die Profile deklarieren `silent="true"`; der Code liefert unbedingt `false`. Der einzige
Konsument (`:506`) betritt seinen Zweig damit nie -- der Kommentar dort bezeichnet
`build_system_axis_levels()` als "ECHTEN Produktions-Konsumenten", was nur unter einer Bedingung gilt,
die konstant falsch ist. **Was zerstoert ist:** eine deklarierte System-Achsen-Belegung aus dem
autoritativen E4-XML wird stillschweigend verworfen; die Provenienz im `.version`-Sidecar traegt
`Active`, obwohl das Profil `Silent` sagt. Das ist eine XML-Aussage, die die Binary nicht erreicht --
gegen den KERN "E4-XML ist die autoritative Bauanleitung". Ehrlich vermerkt: dieser Fall ist im Code
als aufgeschobener, golden-brechender Schritt benannt, nicht verschwiegen. Er bleibt trotzdem eine
Klammer, weil "golden byte-identisch" hier zum Grund wird, eine Achse nicht zu verdrahten.

---

### KK-8 [SYMPTOM VON KK-2] `kPlanOhneAnker` ist Dauerzustand statt Ausnahme

**Ort:** `libs/cache_engine/builder/bestandslog/planer_driven_build.hpp:297, 301`
```cpp
inline constexpr char kPlanOhneAnker[] = "ohne-anker";
if (!identitaet) return std::string{kPlanOhneAnker};
```
Der Nachbarcode ist sauber und fail-closed (`plan_anker_befund`,
`cache_engine_builder_iterator.hpp:1204-1245`, macht die Degradierung LAUT statt still). Der Vorwurf
richtet sich nicht gegen diese Zeilen, sondern dagegen, dass sie in **jedem real erreichten Lauf** der
einzige betretene Zweig sind: die ~30 Kommentarzeilen "DIE HEILUNG ist die exakte und nicht die
naheliegende" beschreiben einen Digest, der bislang nie gebildet wurde. **Reparatur = KK-2.**

---

### KK-9 [NIVEAU, bereits benannt] `bytes_in_use_peak` traegt den END-Wert; Fragmentierungsfelder bleiben strukturell 0

Selbstdokumentiert ("A8-S3/Befund B7", "Katalog-Entscheid E9") mit ehrlichem `"n/a"` in den
WIDE-Schema-Spalten. Als Klammer zaehlt: die schmale (16-Spalten-)Pipeline traegt den Namen `peak`
fuer einen Endwert; jeder Auswertungspfad, der sie unabhaengig konsumiert, liest ihn als Peak.
Codex nennt `apps/f15_compare/main.cpp:364-376` als solchen Pfad -- von mir **nicht** nachverifiziert.

---

### Nicht selbst nachgelesen (Codex-Durchgang, Provenienz-Vorbehalt -- s. Abschnitt 6)
A-02 (zweiter Profilpfad `ExperimentRunArgs` providerlos; SOTA-Fingerprint nur Existenz- statt
Wertbeweis) · A-03 (N8-Sidecar-Registrierung nur Testattrappe; `continue` bei kaputten Sidecars +
nachfolgendes Loeschen) · A-04 (F9-Lagerbaum/Knotenlog nur Testinseln, Store bleibt flach) ·
A-05 (Messwert-Genus-Felder vom Host nirgends belegt) · A-07 (Storage-/Reservierungs-Aktivierung
fail-open bei Fehlkonfiguration) · A-08 (Transportfehler wird wie "Objekt fehlt" behandelt ->
kann Bestandslog ueberschreiben) · A-10 (RAM/NUMA/Page-Probes test-only) · A-13 (`mc_size_verified`
best-effort `true` bei Fetch-/Parse-Fehler; `artifact_cache.hpp:910, 949, 968`).

---

## 3. DAS MUSTER -- und die bindende Regel

**Warum entstehen diese Klammern?** Am Material lassen sich drei Ursachen belegen, keine davon ist
Nachlaessigkeit:

1. **Der Bau-Agent sieht den heutigen Baum, nicht den Plan.** Er kann verifizieren, was heute
   aufgerufen wird -- er kann nicht sehen, dass eine Naht am 05.08. mit "Freigabe" bestellt wurde und
   am 09.08. der Traeger von LB-0..LB-6 sein soll. "Kein Aufrufer" ist fuer ihn ein messbares Faktum;
   dass es sich um ein Pflicht-Feature handelt, das noch niemand angeschlossen hat, steht nur im
   Ledger. Der Owner hat genau das am 13.07. schon einmal korrigiert (LEDGER Z.555): *"'0 Konsumenten'
   ist bei Pflicht-Features 'unverdrahtet/unfertig', nicht 'tot'"* -- und der Rueckfall ist trotzdem
   erneut eingetreten (KK-1 ist ein Rueckfall hinter einen am 16.07. erledigten Stand).
2. **"Byte-Identitaet / golden-neutral" ist zum universellen Freibrief geworden.** Die Formeln
   "byte-neutral", "golden-neutral", "golden byte-identisch" stehen allein in `libs/` in
   dreistelliger Zahl (Spitzenreiter: `cache_engine_builder_iterator.hpp` 23x,
   `profile_run_facade.cpp` 21x, `build_orchestrator.hpp` 18x). Byte-Identitaet ist eine
   **Regressionsschranke fuer bereits gemessene Ergebnisse** -- sie ist zum Argument dafuer geworden,
   neue Faehigkeiten nicht zu verdrahten (KK-7 sagt es woertlich). Aus einer Schranke gegen Regression
   wurde eine Schranke gegen Fortschritt.
3. **Wachen werden gegen den heute sichtbaren Fall gebaut, nicht gegen den Ausfall.** KK-1 ist der
   Beweis: das Verdikt `available || all_zero` wurde als Fix fuer ein falsch-rotes Ergebnis
   eingefuehrt (live-PMC kippte SMOKE_FAIL) und dabei auf beide Seiten geoeffnet, statt am
   Preflight-Ort auf `available` verengt zu werden. Dasselbe Muster in KK-4 (Existenz statt Wert) und
   KK-3 (zweite Job-Definition mit `rules`-Gate, damit sie "heute niemanden stoert").

Alle drei Ursachen haben dieselbe Signatur: **die Ersparnis ist sofort und sichtbar, der Schaden ist
verzoegert und unsichtbar** -- und das System ist gross genug, dass niemand die Verbindung sieht, wenn
Tage dazwischen liegen.

### DIE BINDENDE REGEL (in jeden kuenftigen Bau-Auftrag kopieren)

> **KEINE KOSTENKLAMMERN: Eine geplante Faehigkeit wird IMMER vollstaendig verdrahtet und in der
> Produktionskette scharf geschaltet -- "heute liest das niemand", "kein Aufrufer", "inert",
> "opt-in", "byte-/golden-neutral", "spart Rechenzeit" sind KEINE Gruende, sondern
> Vollstaendigkeitsbehauptungen ueber ein System, das du nicht ueberblickst; wer eine Faehigkeit
> dennoch nicht scharf schalten kann, baut KEINE Bedingung ein, sondern meldet sie ungebaut an
> den Owner. Und: jede Wache muss den AUSFALL erkennen, gegen den sie gebaut wurde -- ein Verdikt,
> das den Ausfallzustand als Erfolg wertet, ist keine Wache, sondern ein Testat.**

Zusatz-Auflage fuer Reviews: **Wer eine Env-Variable, ein `rules:`-Gate oder ein CMake-Flag als
Aktivierungsbedingung einbaut, muss im selben Commit die Stelle nennen, die es in der Produktion
setzt -- und diese Stelle im Baum belegen.** Alle drei schwersten Posten dieser Anklage
(KK-1, KK-2, KK-3) waeren an dieser einen Auflage gescheitert.

---

## 4. V-POSTEN -- Ledger-Zusagen, die am Code nicht halten

**V-A (schwer) -- I-PMC-1 gilt seit 16.07. als erledigt, ist auf dem heutigen Mess-Weg aber nicht wirksam.**
- *Ledger:* Z.532 und Z.1417 (*"I-PMC-1 ✅ (PMC-Flag in beiden Mess-Jobs)"*), Z.555-Nachzieh
  (*"I-PMC-1 gesetzt 2026-07-16 [...] Rest = I-PMC-2 / I-PMC-3"*).
- *Code-Gegenbeweis:* Die Zusage gilt fuer `measure:smoke` + `measure:golden-320` (super
  `.gitlab-ci.yml:672 / :763` -- dort steht das Flag tatsaechlich). Der Job `measure:smoke` ist seit
  21.07. als DEPRECATED-Fallback stillgelegt (`:665-669`), abgeloest durch die dynamische Kette --
  und `experiment_plan_director.hpp` setzt das Flag an **keiner** seiner vier `cmake`-Emissionen
  (841/877/1194/1342; `grep -c COMDARE_ENABLE_PMC` = 0, auch im gelandeten Submodul `3bbcb8ed`).
  Der Haken im Ledger steht, die Wirkung ist beim Umbau verloren gegangen.

**V-B (schwer) -- "Default-Modus-Konsequenz owner-gedeckt (F7)" ist im Ledger behauptet, im F7-Kanon aber das Gegenteil.**
- *Ledger:* 05.08. Nachtrag "nachmittag-2", Abschnitt JOB-SPERRE BEENDET: *"Default-Modus-Konsequenz
  deklariert (**owner-gedeckt F7**): ohne COMDARE_BESTANDSLOG=true kein Bau-Resume-Skip (ehrlicher
  Neubau); Voll-Bau-4 faehrt mit aktivem Provider; P11 prueft das Env."*
- *Gegenbeweis:* Der zitierte Kanon F7 (Dossier 01.08., Abschnitt 6) benennt "Fingerprint als VIERTES
  Gate, **opt-in**" ausdruecklich als **VERDRAENGTEN** Vorschlag (G-C1). Die Ledger-Zeile traegt kein
  woertliches Owner-Zitat. Sie erklaert damit einen Zustand fuer gedeckt, den das Dokument, auf das
  sie sich beruft, verwirft. Genau diese Argumentationsform hat der Owner am 06.08. (nachmittag-5)
  geruegt: *"Behauptungen der Form 'niemand liest/braucht X' sind VOLLSTAENDIGKEITSAUSSAGEN"*.

**V-C (mittel) -- §66-N2 "BEIDE hart (kein Gate/allow_failure)" gilt fuer die ce-Jobs, nicht fuer den Mess-Batch.**
- *Ledger:* Z.3499, User 23.07., "KERN=Gesetz".
- *Gegenbeweis:* `pmc:amd` / `pmc:intel` (ce `.gitlab-ci.yml:133/139` ueber `.pmc:106-118`) halten die
  Zusage -- sie bauen mit `-DCOMDARE_ENABLE_PMC=ON` und laufen ohne `allow_failure`. Der emittierte
  Mess-Batch dagegen traegt `allow_failure: true` (`experiment_plan_director.hpp:1333`) und einen
  Preflight, dessen Verdikt nicht faellt (`m3v2_pmc_smoke.cpp:71`). Die Doktrin ist an der Stelle
  erfuellt, an der sie nichts kostet, und an der Stelle verletzt, an der sie zaehlt.

**V-D (mittel) -- "contract:axis-version-lock als HARTES CI-Gate" (Sec.32-F4/GN-8/O-4) laeuft in keiner Pipeline.**
- *Gegenbeweis:* Doppelter Job-Key `.gitlab-ci.yml:343` und `:502`; die zweite (gewinnende) Definition
  ist `rules`-gated auf `COMDARE_AXIS_LOCK_CHECK == "true"`, das im gesamten Baum (ce + super)
  nirgends gesetzt wird.

**V-E (mittel) -- honest-100%-Doktrin (13.07.): "kein Weg-Nullen = honest-0-Aufgeben".**
- *Gegenbeweis:* Auf dem generierten Mess-Weg liefert `make_pmc_source()` (`pmc_source_factory.hpp:30-32`)
  die `NullPmcSource`; alle sieben PMC-Spalten sind strukturell 0. Das ist der vom Owner benannte
  honest-0-Zustand, nicht als Ausnahme, sondern als Normalfall des Vollmesslaufs.

**V-F (leicht) -- "bestandslog_active" ist als Lager-Gate dokumentiert, prueft aber nicht die Identitaet.**
- *Gegenbeweis:* `cache_engine_builder_iterator.hpp:1658-1660` gegen den eigenen Kommentar `:1194`
  ("waehrend bestandslog_active an keinem der drei haengt").

**Entlastend vermerkt (kein V-Posten):** Die T2-A/F4-NB3-Welle vom 06.08. hat die aeltere
Kostenklammer in `plan_identitaet_of` (`cfg.batch_plan_datei.empty()`) bereits **entfernt** und die
Entfernung mit einem Alt-Stand-Biss belegt (`test_tp1_planer_filter_iterator.cpp:1789-1791`). Diese
Reparatur ist am Objekt bestaetigt. Sie liegt allerdings nur im ce-Arbeitsbaum `034e0068`; das super
konsumiert `3bbcb8ed` und hat sie noch nicht.

---

## 5. ARBEITSLISTE

Umfangsangaben sind Schaetzungen fuer eine Welle mit Biss (Test, der ohne den Fix rot ist) und
Selbstcheck aus dem Diff. "Abgabe Fr 08.08." ist der harte Rahmen.

### (i) ZERSTOERT GEPLANTE ARBEIT -- SOFORT, vor jedem Messbeginn

| # | Datei:Zeile | Was zu tun ist | Umfang | Abhaengigkeit |
|---|---|---|---|---|
| **i-1** | `libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:1342` (Mess-Batch; danach 841/877/1194 pruefen) | `-DCOMDARE_ENABLE_PMC=ON` in die `cmake`-Emission des Mess-Batches aufnehmen -- I-PMC-1 auf dem dynamischen Weg nachziehen. Biss: ein Director-Test, der die emittierte YAML auf das Flag prueft (Muster `test_experiment_plan_director.cpp` vorhanden). | S (1-2 h) | **Blockiert den Messbeginn.** Unabhaengig von T2-A/B14/A1; beruehrt weder golden-Bytes noch ABI. Nach der Landung: super-Submodul-Bump noetig, sonst wirkungslos. |
| **i-2** | `tests/unit/thesis_tiere/m3v2_pmc_smoke.cpp:71` + `experiment_plan_director.hpp:1362-1364` | Preflight-Verdikt am Preflight-Ort auf **echte Verfuegbarkeit** verengen: der Batch darf nur starten, wenn `pmc_available=1`. Den 13.07.-Inversionsfix NICHT ruecknehmen -- stattdessen zweiter Modus (z.B. `--require-available`) oder Preflight prueft die Ausgabe `pmc_available=1` explizit statt nur den Exit-Code. Biss: Preflight muss ohne Flag rot werden. | S-M (2-3 h) | Zwingend **zusammen mit i-1** landen -- i-1 allein liesse die Wache blind, i-2 allein blockierte den Lauf. |
| **i-3** | `experiment_plan_director.hpp:1333` | `allow_failure: true` am Mess-Batch entfernen oder auf die Zell-Ebene zurueckfuehren (CSV `'failed'` bleibt, der JOB faellt). §66-N2: "kein Gate/allow_failure". | S (< 1 h) | Mit i-1/i-2 in einer Welle. Vorher pruefen, ob eine Pipeline-Politik (Landewarteschlange) daran haengt. |
| **i-4** | `.gitlab-ci.yml` (ce) `:343` vs `:502` | Doppel-Definition aufloesen: die INERT-Variante (`:502` samt `rules`-Zeile) entfernen, die harte (`:343`) behalten -- oder umgekehrt EINE Definition ohne `rules`. Biss: der Abdeckungs-Invarianten-Job aus `dcb2f08f` um eine Doppel-Key-Wache erweitern (YAML-Keys eindeutig). | S (1 h) | **Gehoert in die CI-Invariante (`dcb2f08f`)** -- deren Zweck ist exakt das. Steht bereits als Satz in Task #6. Nach dem Fix laeuft der Tripwire erstmals: mit rotem Ergebnis rechnen (Header koennen seit Wochen driften). |
| **i-5** | `profile_run_entry.hpp:436` (+ Kette bis `build_orchestrator.hpp`) | **Owner-Entscheid noetig (F7 vs. Betriebsrealitaet).** Plan-SOLL ist: Provider immer aktiv, kein Opt-in. Machbar bis Abgabe: Env-Gate umkehren (Default AN, Abschalten nur explizit) ODER das Gate im Trigger-Rezept fuer Voll-Bau-4 verbindlich setzen und im Planer eine harte Wache ergaenzen, die den Voll-Lauf ohne Provider **abbricht** statt stumm zu degradieren. | M-L (0,5-1 Tag; Entscheid vorab) | **Beruehrt T2-A/L1 direkt** (der Eichungsstrang wird damit erstmals produktiv scharf) und ist Voraussetzung fuer P3-TRIGGER Task #4, Task #9 (Lager-Basis-Tests) und F9/LB-*. **Erst nach i-1..i-4**, weil ein scharfes Skip-Gate ohne PMC-Fix nur schneller falsch misst. |
| **i-6** | `cache_engine_builder_iterator.hpp:1658-1660` | `cfg.bestand_fingerprint_fn` in `bestandslog_active` aufnehmen (fail-closed, analog `plan_anker_befund`). Biss: T2-C-Fall + `na`-Fall muessen das Lager stumm halten. | S (1-2 h) | **Muss mit i-5 in derselben Welle landen** -- i-5 allein schaltet KK-4 scharf. Kollisionsgefahr mit T2-A/L1 (dieselbe Datei, gleiche Region wie `plan_anker_befund`): nach T2-A-Landung einplanen. |

### (ii) LAEUFT STILL FALSCH, SOBALD DIE NAECHSTE STUFE KOMMT

| # | Datei:Zeile | Was zu tun ist | Umfang | Abhaengigkeit |
|---|---|---|---|---|
| ii-1 | `batch_planner.hpp:163, 217-232` | `PlanFach::offen` an eine Entscheidung anschliessen -- mindestens als ETA-Eingang, mindestens aber eine Wache, die widerspruechliche Faecher (`offen>0` bei vollstaendig gedecktem Praefix) meldet. | M (3-4 h) | Haengt an F5/F6 (ETA-Konsolidierung). **Nach dem Messfenster** vertretbar, wenn i-5 gelandet ist. |
| ii-2 | `artifact_cache.hpp:910, 949, 968` (A-13) | `mc_size_verified` liefert best-effort `true` bei Fetch-/Parse-Fehler -- gegen fail-closed pruefen. **Nicht von mir verifiziert.** | S-M | Beruehrt Storage/Transport; nicht in den laufenden Paketen. |
| ii-3 | Codex A-03 / A-08 (N8-Sidecar, Transportfehler == "Objekt fehlt") | Am Objekt nachlesen und, falls bestaetigt, fail-closed nachziehen: ein Transportfehler darf das Bestandslog nicht ueberschreiben. **Nicht von mir verifiziert.** | M | Wird scharf, sobald i-5 den Lager-Weg produktiv oeffnet -- dann **vor** dem ersten Push. |
| ii-4 | `apps/f15_compare/main.cpp:364-376` (A-11/KK-9) | Pruefen, ob die schmale Pipeline `bytes_in_use_peak` als Peak auswertet; falls ja, Spalte umbenennen oder echten Peak fuehren. **Nicht von mir verifiziert.** | S | Auswertung/Anhang -- vor dem Thesis-Anhang-Bau. |

### (iii) SAUBERKEIT / NIVEAU

| # | Datei:Zeile | Was zu tun ist | Umfang | Abhaengigkeit |
|---|---|---|---|---|
| iii-1 | `profile_run_facade.cpp:240-241` | `active_telemetry_is_silent()` an das geparste Profil binden (`<telemetry silent="true">`). Ist ausdruecklich golden-brechend -- **Owner-Absprache** (GOLDEN-UPDATE-Fenster). | M | Am GOLDEN-UPDATE-Fenster; **nach Abgabe** vertretbar. |
| iii-2 | quer durch `libs/` | Die Formel "byte-neutral / golden-neutral" als **Begruendung fuer Nicht-Verdrahtung** durchgehen (Spitzenreiter: `cache_engine_builder_iterator.hpp` 23x, `profile_run_facade.cpp` 21x, `build_orchestrator.hpp` 18x) und in zwei Klassen trennen: (a) Regressionsschranke fuer bereits gemessene Bytes = bleibt, (b) Grund, eine Faehigkeit nicht anzuschliessen = Kandidatenliste. | L | **Aufraeumpass am Ende** (Owner-KERN, Task #5, 9 Kandidaten) -- diese Liste dort ergaenzen. |
| iii-3 | `planer_driven_build.hpp:297-312` | Nach i-5: pruefen, ob `kPlanOhneAnker` noch erreichbar ist. Wenn nicht mehr -- als Wache behalten, nicht loeschen (fail-closed-Rest). | S | Nach i-5. |
| iii-4 | Codex A-02/A-04/A-05/A-07/A-10 | Am Objekt nachlesen und einordnen. **Nicht von mir verifiziert.** | M-L | Aufraeumpass / nach Abgabe. |

**Empfohlene Reihenfolge fuer das verbleibende Fenster:** i-1 + i-2 + i-3 als EINE Welle (halber Tag,
blockiert den Messbeginn) -> i-4 (CI-Invariante, parallel moeglich, eigener Owner) -> Owner-Entscheid
zu i-5 -> i-5 + i-6 gemeinsam nach der T2-A/L1-Landung. Alles Uebrige nach dem Messfenster.

---

## 6. WAS ICH NICHT PRUEFEN KONNTE

1. **Ich habe den Planer nicht ausgefuehrt.** KK-1 ist aus der Emissionsquelle
   (`experiment_plan_director.hpp`) belegt, nicht aus einer real erzeugten YAML eines gelaufenen
   Jobs. Dass der 131.072-Lauf tatsaechlich ueber diesen Emissionszweig laeuft (und nicht ueber
   `measure:golden-320`, das das Flag traegt), stuetze ich auf `COMDARE_GN_TOTAL=131072` in der
   Emission, auf die Deprecation-Notiz `super .gitlab-ci.yml:665-669` und auf den KERN "Kette
   Planer/CEB/Tier". **Vor der Reparatur sollte genau das am realen Trigger-Rezept gegengeprueft
   werden** -- falls der Voll-Lauf doch ueber den statischen Job faehrt, mildert das KK-1 (die Wache
   bliebe trotzdem blind).
2. **Keine Pipeline-Historie eingesehen.** Ich habe keine GitLab-Job-Logs gelesen; "in keinem
   real gelaufenen Job aktiv" stuetzt sich auf die Abwesenheit der Variablen im gesamten Baum
   (ce + super, alle YAML/Skripte), nicht auf Job-Ausgaben. Externe Pipeline-Variablen (Projekt-/
   Gruppen-Ebene in GitLab, oder POST-Variablen eines Trigger-Rezepts) sind im Baum **nicht
   sichtbar** -- wenn `COMDARE_BESTANDSLOG` oder `COMDARE_AXIS_LOCK_CHECK` dort gesetzt sind,
   verschiebt sich KK-2/KK-3 von "tot" zu "unsichtbar konfiguriert" (was die Anklage nicht aufhebt:
   eine Faehigkeit, deren Aktivierung nicht im Repo steht, ist nicht reproduzierbar).
3. **Codex konnte in dieser Session keine Prozesse starten** (`bwrap: loopback: Failed RTM_NEWADDR`).
   Es hat seine Befunde ehrlich in `[L]` (vorverifiziert uebergeben) und `[R]` (einem
   Rescue-Snapshot zugeschrieben) getrennt und ausdruecklich gesagt, `git` nicht ausgefuehrt zu
   haben. Ich habe daraufhin die vier folgenreichsten `[R]`-Befunde selbst am Objekt geprueft --
   4/4 bestaetigt, inklusive Zeilennummern und Kommentarwortlaut. Die uebrigen (A-02..A-05, A-07,
   A-08, A-10, A-13, A-14 sowie die Detail-Zeilenbelege innerhalb bestaetigter Punkte) sind
   **nicht nachverifiziert** und in der Arbeitsliste entsprechend markiert. Die hohe Trefferquote
   ist ein Plausibilitaets-Bonus, keine Verifikation.
4. **Kein Bau, kein Test-Lauf.** Ich habe nichts kompiliert und keinen ctest ausgefuehrt; alle
   Aussagen sind Quelltext- und Konfigurationsaussagen.
5. **Zwei Staende.** ce-Arbeitsbaum `034e0068` (mit den ungelandeten T2-A/F4-NB3-Reparaturen) vs.
   super-Submodul `3bbcb8ed` (ohne sie). KK-1 habe ich in **beiden** belegt. Fuer KK-2/KK-4/KK-6/KK-8
   gelten die Zeilennummern des Arbeitsbaums; im gelandeten Stand liegen die entsprechenden Zeilen
   frueher (z.B. `profile_run_entry.hpp:382` statt `:436`).
6. **Ledger-Zeilennummern wandern.** Das Ledger ist append-only und waechst; alle Zitate wurden per
   Volltextsuche am heutigen Stand lokalisiert. Bei spaeterer Nachpruefung ueber den Wortlaut suchen,
   nicht ueber die Zeilennummer.
