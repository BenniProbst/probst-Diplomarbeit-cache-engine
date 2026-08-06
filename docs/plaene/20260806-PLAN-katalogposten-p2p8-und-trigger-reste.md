# PLAN 06.08.2026 -- DIE UNBEARBEITETEN KATALOG-POSTEN: P2-P8-BAND UND DIE TRIGGER-RESTE

> **STATUS: READ-ONLY-ANALYSE UND PLANUNG. Kein Bau, kein Edit an Code, kein Commit, kein Push.**
> Dieses Dokument ist der einzige Schreibvorgang des Laufs. Es ist ausdruecklich NICHT committet.
>
> **Rolle:** Katalog-Lens auf die Posten, die in keiner heutigen Bau-Welle stecken -- das P2-Band
> (VOR Messbeginn) und die P3-Reste (VOR Trigger). Fuer jeden Posten: Kennung, Plan-Zitat mit
> Datum, Anspruch, Code-Stand am Objekt, Verdikt. Dazu die Streichliste, die Abhaengigkeiten als
> Paare, die Datei-Beruehrungen (Grundlage des Disjunktheits-Beweises) und eine ehrliche
> Termin-Einordnung.
>
> **Vorlauf (Owner-Anordnung eingehalten):** zuerst Ledger rueckwaerts ab Z.4202
> (`nachmittag-10` .. `nachmittag-7`, dann `mittag-24` .. `mittag-12`), dann
> `docs/sessions/20260806-REGISTER-todo-konsolidierung-14-tage.md` inkl. NACHTRAG V-01/A15,
> `docs/plaene/20260806-FAHRPLAN-parallel-sequenz-optimiert.md`,
> `docs/sessions/20260806-FAHRPLAN-hauptstrang-landung.md`,
> `docs/sessions/20260806-PAUSE-abbruchsicher-nachmittag-nach-vierfach-review.md`,
> `docs/sessions/20260806-HANDOUT-od7-runner-direktive-infra.md`, dann die vier Nachbar-Plaene
> von heute Abend (siehe 0.3) -- **erst danach der Code**.
>
> ASCII-only ausser in woertlichen Zitaten.

---

## 0. PRUEFBEREICH, METHODIK, ABGRENZUNG

### 0.1 Die Staende, an denen gemessen wurde (Dateimenge UND Commit-Bereich)

| Gegenstand | Wert |
|---|---|
| super Arbeitskopie | `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine` |
| super HEAD (`development`) | `9f5ff1d2` (Ledger-Nachtrag `nachmittag-10` Abschnitt F) |
| ce Submodul-Checkout (`development`) | `e7aa1244` -- Arbeitsbaum sauber (`git status --porcelain` leer) |
| Cluster-Checkout (nur gelesen) | `/home/comdare/Projekte/Cluster`, `scripts/runner-mode.sh` @ `0d7c577` |
| Lage-Bezug | L1-Buendel GELANDET (T2-A `86be2420`, B14-ce `f577f886`, R4-Wache `b5e0e4e7`), `main`-FF in beiden Repos vollzogen |

**Werkzeug-Disziplin:** `/usr/bin/grep` mit absolutem Pfad; Zaehlungen je mit Bezugsgroesse;
Codex-Laeufe mit `approval-policy: never`, `sandbox: workspace-write`, `cwd` gesetzt, **ohne
jedes `git`** (der Stand wurde Codex als Text mitgegeben).

### 0.2 Eine Beleggrenze, die ausgewiesen gehoert

Beide Codex-Threads meldeten einen Sandbox-Defekt der lokalen Prozess-Ausfuehrung
(`bwrap: setting up uid map: Permission denied` bzw. `loopback: Failed RTM_NEWADDR`) und haben
ihre Positiv-Belege deshalb am verifizierten Baum zu `e7aa1244` gelesen. **Konsequenz, die hier
nicht verschwiegen wird: Codex' Negativ-Aussagen ("0 Treffer") sind formal UNBELEGT.** Alle in
diesem Dokument tragenden Negativ-Befunde (G-E3-Zuweisungen, `NoFilter`, xlsx-Code,
`organ_subaxes`, `stat_`) wurden deshalb **vom Lead selbst mit `/usr/bin/grep` lokal
nachgemessen**; wo das nicht geschah, steht UNBELEGT an der Aussage.

### 0.3 Abgrenzung zu den vier Nachbar-Plaenen von heute Abend (nichts doppelt planen)

Zwischen 18:06 und 19:45 sind parallel entstanden -- **die juengste Fassung gewinnt, dieses
Dokument widerspricht ihnen nicht, es ergaenzt sie:**

| Dokument | Zeit | deckt aus meinem Katalog |
|---|---|---|
| `docs/plaene/20260806-PLAN-wellenplan-vollbild-und-parallelisierung.md` | 19:07 | Wellen/Disjunktheit gesamt; **1.8 KF-6-Entlastung**; 4.3 "was nicht mehr reinpasst" |
| `docs/plaene/20260806-PLAN-lb6-stufe1-oeb-baumform.md` | 19:09 | **K-13 LB-6 Stufe 1** (Bauplan + Delta D1) |
| `docs/plaene/20260806-PLAN-p-pmc-1-messkette.md` | 19:20 | **K-9 PMC** (Bau-Paket P-PMC-1) |
| `docs/plaene/20260806-PLAN-testoffensive-und-gruene-pipeline.md` | 18:06 | Pipeline-Pruefbereich, `xmllint`-Infra-Posten |

Fuer K-9 und K-13 liefert dieses Dokument **keinen zweiten Bauplan**, sondern nur Einordnung,
Verdikt und die Termin-Konsequenz. Der Rest (K-1 bis K-8, K-10 bis K-12, K-14) ist hier zuhause.

---

## 1. KURZ-VERDIKT (die 14 Posten auf einen Blick)

| Kennung | Posten | Anspruch laut Plan | Verdikt |
|---|---|---|---|
| **K-1** | B5 Mess-Schnitt-Fenster / T6-Einsammel-Naht | P2, vor Messbeginn | **OFFEN** -- Skelett vorhanden, aber als Kommentar UND ueber Pipeline-Grenzen hinweg nicht tragfaehig |
| **K-2** | G-E3 Host-Binder (`mess_bestand_*`) | P2, vor Messbeginn | **OFFEN** -- 0 Zuweisungen von 9 Feld-Treffern; Schreiber ist totes Holz |
| **K-3** | Lager-Kaskaden + xlsx-Geruest (B12) | P2 + "mit in die Abgabe" | **GETEILT: Kaskaden ERLEDIGT, xlsx-Geruest OFFEN** und nicht fristfaehig |
| **K-4** | E14 NoFilter-Blatt (Identitaet) | Owner-GO 06.08. "P2-Bau" | **OFFEN** -- 0 Treffer; Bau bricht golden-320 -> Owner-Rueckfrage |
| **K-5** | Posten 89 T6-Rebound-Leaf-Einpreisung | P2/P3-Checkliste | **OFFEN, aber kein Bau-Posten** -- Auswerte-Auflage, 0 Dateien |
| **K-6** | P2-P8 WIDE-Mess-Schema (~33 `stat_`-Spalten) | P2, vor Messbeginn | **OFFEN** -- Kartierung fertig, Bau 0; Kapazitaet vorhanden (49/144 Slots frei) |
| **K-7** | Ebene-B-Push-Aktivierung (G4/P-A) | P3, vor/mit Voll-Bau | **GEBAUT, INERT** -- Aktivierung = CI-Variable, **kein** Repo-Edit; 1 Ehrlichkeits-Riss |
| **K-8** | Lager-Gate G1 (#27 B/C/D + amd24) | P3, vor Trigger | **VERLORENE BUCHFUEHRUNG** -- Inhalt hier erstmals rekonstruiert, Nachfolger benennbar |
| **K-9** | E8 PMC-Beleg-Form | P3, vor Trigger | **UNTERGEORDNET** -- vom PMC-Sperrposten ueberholt; Bau siehe P-PMC-1 |
| **K-10** | OD-7 Runner-Zahlen HEAVY/NORMAL | P3, vor Trigger | **HALB ERLEDIGT** -- HEAVY konform, NORMAL abweichend; Infra-Lane, Handout liegt |
| **K-11** | KF-6 NTTP-Codegen (Cacheline) | P1 laut Register | **ENTLASTET** -- golden-Block ist inert; kein Trigger-Blocker -> nach Abgabe |
| **K-12** | #46b-Restumfang (G3-Rest) | P2 | **UNBEZIFFERT** -- Restumfang bleibt UNBELEGT; Abgrenzung bei P2-Start |
| **K-13** | LB-6 Stufe 1 Lager-Basis-Tests | Vor-Trigger-PFLICHT | **WEITER als der Ledger sagt** -- Beweise reichen bis LB-3, nicht nur LB-1 |
| **K-14** | Posten 77/78-Auflagen (kReal16-Doku, XorFilter-FN) | P2/Thesis-Band | **OFFEN**, klein, Doku-Charakter (UNBELEGT im Detail) |

---

## 2. DIE POSTEN-DOSSIERS

### K-1 -- B5 Mess-Schnitt-Fenster (T6-Einsammel-Naht + Doppelzaehlungs-Regel)

**Aliasse:** "B5" (Tabelle B), "T6-Einsammel-Naht", "Posten-68 Option B strikt".
**ACHTUNG Namenskollision** (Register :186 fuehrt sie selbst): B5 (Mess-Schnitt, P2) ist **nicht**
B-5-Lebend-Check (Voll-Korpus, P4).

**Plan-Zitat.** `docs/sessions/20260806-REGISTER-todo-konsolidierung-14-tage.md:40` (06.08.):

> "Umsetzung der abend-11-Doktrin (04.08.) im P2-Fenster; Entscheid gefallen, Bau offen.
> **Achtung Namenskollision:** B5 (dieses) != B-5-Lebend-Check (P4)."

**Anspruch.** P2 -- vor Messbeginn (Leitplanke 4 des Fahrplans: "P2-P8+A1+B14+Lager-Geruest VOR
Messbeginn").

**Code-Stand (selbst gemessen, super `9f5ff1d2`).** Die Naht existiert als **auskommentiertes
Skelett**, nicht als Code:

- `.gitlab-ci.yml:1246` `ergebnis:holen` -- der Job existiert und laeuft.
- `.gitlab-ci.yml:1270-1273`, woertlich:
  > `# SKELETT-Naht (GN-11/320er-gated, NICHT aktiv): sammelt die measure_out/-CSVs der Grandchild-Mess-Jobs`
  > `#   mkdir -p "$CI_PROJECT_DIR/measurement/ergebnis"`
  > `#   find "$CI_PROJECT_DIR" -path '*/measure_out/*.csv' -exec cp {} "$CI_PROJECT_DIR/measurement/ergebnis/" \;`
- Aktiv ist nur eine Zaehlung des LOKALEN Verzeichnisses (`:1274-1277`).
- Der aktive Sammler `persist:measurements` (`:842`) nimmt in `needs` (`:852-867`) ausschliesslich
  die **parent-lokalen** Jobs `measure:smoke` (`:651`) und `measure:golden-320` (`:738`); er
  schreibt nach `measurement/<YYYYMMDD-HHMMSS-pipeline>/` (`:882-885`) und ist per
  `COMDARE_PERSIST_MEASUREMENTS` inert (`:871`).
- `.gitlab-ci.yml` enthaelt **0 `dependencies:`-Treffer** (Codex, in dieser Zaehlung UNBELEGT-Grenze
  beachtet).

**BEFUND, der ueber die Registerzeile hinausgeht.** Das Skelett ist nicht nur "nicht aktiv" --
**es kann in der geschriebenen Form nicht funktionieren.** `find "$CI_PROJECT_DIR" ...` sieht den
Arbeitsbereich des EIGENEN Jobs. Die Stufe-2/3-Mess-CSVs entstehen in **Grandchild-Pipelines**
(`planer:delegate` `:1147` erzeugt Child-YAML, `planer:delegate-trigger` `:1200` zuendet es), also
in fremden Pipelines auf potenziell fremden Runnern. Ein Scharfschalten der drei Kommentarzeilen
liefert damit **0 CSVs und einen gruenen Job** -- exakt die Fehlerklasse "eine Zusage, die eine
andere Frage beantwortet" (Ledger-Regel 6). Der echte Weg ist entweder ein `needs:pipeline:`-Bezug
auf die Downstream-Pipeline oder ein API-Abzug -- **beides ist Bau, nicht Kommentar-Entfernung.**

**Verdikt: OFFEN.** Aufwand belastbar hoeher als die "drei Zeilen", die das Skelett suggeriert.

---

### K-2 -- G-E3 Host-Binder (die drei `mess_bestand_*`-Felder)

**Plan-Zitat.** Ledger 04.08. frueh (L3790), uebernommen als Register-Zeile P2 (`:307`, 06.08.):

> "mess_bestand_*-Verdrahtung Iterator->Messwert-Lager (3 cfg-Felder, 0 Konsumenten; deklarierte
> Luecke der A1-Lager-Rest-Welle) -- bei P2-Start pruefen/einplanen, VOR Messbeginn.
> OFFEN-UNGEPRUEFT."

**Anspruch.** P2, vor Messbeginn (Register-Ergaenzung B-15).

**Code-Stand (selbst gemessen, ce `e7aa1244`).**

- `/usr/bin/grep -rn "mess_bestand_" libs tests apps` -> **9 Treffer**, davon **0 Zuweisungen**
  (`/usr/bin/grep -rn "mess_bestand_[a-z_]*\s*=" libs tests apps` -> **0 Zeilen**).
- Deklaration und Konsum liegen in genau EINER Datei:
  `libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp` --
  `:267` `mess_bestand_doc_key`, `:268` `mess_bestand_key_of`, `:271` `mess_bestand_versions`;
  Aktivierungs-Gate `:1667`, Laden `:1669`, Flush `:1871`, Aufruf `:2565`, `observe`-Uebergabe `:2571`.
- Das Genus-1-Pendant ist **vollstaendig durchgereicht** und damit die Vorlage:
  Provider `bestandslog/fingerprint_key_source.hpp:77-80` -> Fassade
  `profile_facade/profile_run_facade.hpp:111` / `.cpp:723` -> `profile_run_entry.hpp:142` -> Iterator-cfg
  `:650` -> Iterator `:220/:1660/:1748`; **6 Zuweisungen in 3 Testdateien** (`test_f3_lager_key_provider_iterator.cpp:174`;
  `test_tp1_planer_filter_iterator.cpp:292/1271/1299/1777`; `test_t2a_f4_facade_plan_durchreichung.cpp:153`).
- Der produktive Setter des Genus-1-Pfades sitzt **ausserhalb der ce**, im Treiber
  (`Code/02_messung_driver/main.cpp`, Gate laut Ledger `nachmittag-8`: `COMDARE_BESTANDSLOG=="true"`
  UND `minio_enabled()`).

**Verdikt: OFFEN, und die Schaerfe ist praezisierbar.** Der Schreiber (`messwert_registrierung.hpp`,
199 Zeilen) ist gebaut und getestet (`tests/unit/test_ge3_messwert_genus_und_ziel.cpp`, **15
TEST-Makros**), aber er ist **totes Holz**, solange kein Host die drei Opt-in-Felder fuellt. Ohne
Binder entsteht im Voll-Bau-4 **kein Messwert-Genus-Eintrag im Lager** -- das ist genau der Zweck,
den Leitplanke 4 ("Messwert-Lager VOR Messbeginn") schuetzen soll.

---

### K-3 -- Lager-Kaskaden + xlsx-Geruest (B12-Geruest)

**Plan-Zitate (zwei, beide bindend).**
Ledger 05.08. abend (Register-Bezug B12):

> "**B12 xlsx-Writer**: waehrend des Voll-Baus bauen, VOR Messbeginn fertig, UND **mit in die
> Abgabe** (vor Fr)."

Owner-Praezisierung 05.08. `nachmittag-3` (Ledger :4163, Kopfzeile verbatim):

> "OWNER-PRAEZISIERUNG Rueckschreibe-Format -- VERBATIM: CSV XOR xlsx, xlsx=DEFAULT, STRATEGY PATTERN"

**Anspruch.** P2 (Geruest) + ausdruecklich **Abgabe-Band**; Fuellung -> P4.

**Code-Stand (selbst gemessen).** Der Posten zerfaellt sauber in zwei Haelften:

1. **Ordner-Kaskaden: ERLEDIGT.** `libs/cache_engine/builder/bestandslog/` traegt **21 Dateien,
   6362 Zeilen**; die Kaskade liegt in `lager_pfad_grammatik.hpp` (574 Z.; Key/Value-Kaskade
   `:297-316`, Organ-Gruppierung `:328-377`, Blatt-Dateiname `:391-431`, Pfad/Objekt-Key `:438-455`)
   und `lager_baum_writer.hpp` (610 Z.; Tiefen `:360-376`, Policies `:387-450`, Depth-first `:526-590`),
   Zielabbildung in `lager_ziel_strategie.hpp` (227 Z., `:106-137`).
2. **xlsx-Writer: 0 produktive Substanz.** `/usr/bin/grep -rli xlsx libs tests scripts cmake tools apps`
   -> **5 Dateien**, und keine davon ist ein Writer: zweimal Pfad-/Namensgrammatik
   (`lager_pfad_grammatik.hpp` -- die Datei erzeugt lediglich Dateinamen mit Endung `xlsx`, z. B.
   `:525-538`), einmal eine Fehlerklasse (`axis_error.hpp`), zweimal Tests. Im super ausserhalb der
   ce: **0 Treffer** in den 9 Fassaden-Ordnern (`Code/01_..09_`, Codex; lokal UNBELEGT).
   Einziges Artefakt ist das SOLL-Design `docs/architecture/20260803-a9_xlsx_writer_f3_soll_design.md`
   (74 xlsx-Zeilen), das selbst `ext/io/zlib/` und `ext/io/libxlsxwriter/` als **neu zu vendorende**
   Abhaengigkeiten nennt (`:391`).

**Verdikt: GETEILT.** Die Kaskaden-Haelfte ist eine **erledigte Position** -- ein vollwertiger
Fund, der aus dem Vor-Trigger-Band gestrichen werden darf. Die xlsx-Haelfte ist ein
**Vendoring-Paket** (`vendor -> faithful -> selfcontained`-Doktrin) und passt in zwei Tage
nachweislich nicht (s. Abschnitt 6).

---

### K-4 -- E14 NoFilter-Blatt (Identitaet)

**Plan-Zitat.** Owner verbatim, Ledger 06.08. `vormittag-22` (Z.5410):

> "E14/Nofilter volles go - die Eingabe ist einfach die ausgabe."

Lesart im selben Nachtrag (Z.5415): "(E14) NoFilter-Blatt = Identitaet (Eingabe==Ausgabe) -> P2-Bau."

**Anspruch.** Der Owner hat den Posten am 06.08. **auf P2-Bau vorgezogen**. Das Register (Zeile
`:110`, committet `vormittag-13`, also FRUEHER) fuehrt ihn noch unter NACH-ABGABE
("Registry-Erweiterung = golden-320-Bruch -> eigenes golden-Neuanker-Fenster nach Abgabe").
**Die Registerzeile ist an dieser Stelle stale; die Owner-Aussage ist juenger und gewinnt.**

**Code-Stand (selbst gemessen).**

- `/usr/bin/grep -rni "nofilter|no_filter|identity_filter|IdentityFilter" libs tests` -> **0 Treffer**.
- Die Filter-Achse hat heute **4 von 4** Blaettern, dreifach gepinnt:
  `libs/cache_engine/axes/filter_axis/axis_filter_registry.hpp:6-9` (Includes) und `:18` (`AllFilters`),
  `libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml:95-100` (Achse T14 + 4 Werte),
  `CMakeLists.txt:386-390` (4 Schalter, je Default ON), `axis_filter_flags.hpp.in:4-7,11-14`.
- `tests/unit/test_v41_axis_filter.cpp:97` **pinnt die Registry-Groesse auf 4**.
- `tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt`: **326 Zeilen = 6 Kopfzeilen + 320
  Permutations-IDs**.

**Verdikt: OFFEN -- und der Owner-GO kollidiert mit dem golden-Bestand.** Ein fuenftes Blatt
aendert den Permutationsraum; die 320er-Golden-Liste und der Groessen-Pin sind dann per
Konstruktion falsch. Das ist **kein Grund, den Owner-GO zu ignorieren**, aber es ist ein
Entscheid, den nur der Owner faellen kann (Abschnitt 8, Frage 1): entweder golden-Neuanker VOR dem
Trigger (teuer, beruehrt die Trigger-Eingabe) oder Bau nach der Messung im ohnehin vorgesehenen
golden-Neuanker-Fenster.

---

### K-5 -- Posten 89: T6-Rebound-Leaf-Einpreisung

**Plan-Zitat.** Register-Nachtrag 06.08. ~10:45, Zeile `:376`:

> "Seit Phase B materialisiert fremde T6-Wahl den Rebound-Leaf statt der Fassade -> Allokationszahlen
> steigen exakt um den Organ-Anteil; MUSS beim ERSTEN Vergleich gegen Alt-Mess-CSV eingepreist
> werden (sonst Falsch-Regressions-Lesung)." -- eingestuft als MESSTECHNIK-KENNTNIS, HOCH/zeitkritisch.

**Anspruch.** P2/P3-Checkliste, wirksam **spaetestens beim ersten Mess-Vergleich** nach dem Trigger.

**Code-Stand (gemessen, Codex + Stichprobe).** Der Rebound-Mechanismus ist Kern-Architektur:
Typauswahl `libs/cache_engine/axes/lookup/composable/search_algo_rebind.hpp:68-103`, effektiver Typ
`libs/cache_engine/anatomy/abi_adapter.hpp:2405-2428`, Nutzung in den drei Messpfaden
(`:599-600`, `:714-715`, `:838-841`); 18 Search-Leaf-Header tragen Rebound-Substanz.
Die Allokationszahlen werden **ungerechnet uebernommen**
(`abi_adapter.hpp:1508-1540` -> `builder/experiment_tree/result_ingest.hpp:148-160`).
**Eine Einpreisungs- oder Korrekturlogik existiert nicht** -- und soll auch nicht existieren.

**Verdikt: OFFEN, aber KEIN Bau-Posten.** Es ist eine **Auswerte- und Deutungsauflage**: der erste
Alt-CSV-Vergleich muss den Organ-Anteil abziehen bzw. den Sprung als bekannten Effekt ausweisen.
Kosten: eine Zeile in der Trigger-/Auswertungs-Checkliste, **0 Dateien im Code**. Genau deshalb
darf er nicht im Bau-Band mitlaufen -- er wuerde dort als "nicht geschafft" verbucht, obwohl er
nichts zu bauen hat.

---

### K-6 -- P2-P8: das WIDE-Mess-Schema (~33 neue `stat_`-Spalten)

**Plan-Zitat.** Ledger 06.08. `vormittag-39/-4` (Z.5504-5509):

> "P2-P8-KARTIERUNG FERTIG -- Delta 33 Spalten/14 Themen, dateidisjunkt zu T2-A, Bau-Queue hinter B14-ce"

Quelle des Katalogs: `docs/sessions/20260804-DOSSIER-achsen-qualitaets-parameter-katalog.md`
Abschnitte 3+4.

**Anspruch.** P2, vor Messbeginn; laut Lead-Entscheid "nach der B14-ce-Landung".

**Code-Stand (selbst gemessen, ce `e7aa1244`).**

- `libs/cache_engine/anatomy/observable_tier.hpp`: `kV3AxisCount = 18` (`:50`),
  `kV3FieldCount = 8` (`:53`), Schema `:69-113`.
- **95 von 144 Slots** (18 Achsen x 8 Felder) sind benannt, **49 von 144 sind `nullptr`** --
  also **34,0 % freie, layout-neutrale Kapazitaet**. Verteilung u. a. T4 4/8, T9 4/8, T10 4/8,
  T11..T17 je 3/8 (= 21/56).
- `stat_`-Spaltennamen im Produktivcode: **1 Treffer in `libs/`**
  (`cache_engine_builder_iterator.hpp:454`, die generische Schema-Schleife), 8 von 12 Treffern
  ueber das ganze Repo liegen in `libs/` oder `tests/`.
- Der CSV-Kopf entsteht generisch aus dem Schema (`iterator.hpp:421-528`, Schleife `:450-460`;
  Datenzeile `:556-804`, Schleife `:703-713`) -- **ein Auffuellen der Slots erfordert am Iterator
  keine Aenderung.**

**BLOCKER-AUFLOESUNG (Korrektur an der Vorerhebung).** Die aeltere Erhebung fuehrte P2-P8 als
"blockiert auf B14-ce; B14-ce ist BLOCKIERT (CLU-Konsument)". **Das ist ueberholt:** B14-ce ist als
`f577f886` im L1-Buendel gelandet, ce `development` = `e7aa1244` ist gruen gemessen
(Pipeline 15025, 19 von 19 fahrenden Jobs). **P2-P8 ist seit heute Nachmittag entblockt.**

**Verdikt: OFFEN (Kartierung ERLEDIGT, Bau 0).** Der Bau ist additiv und ABI-fuehrend (er beruehrt
den Mess-POD), also **Spur-S-Arbeit** -- kein Parallel-Kandidat neben einem zweiten ABI-Paket.

---

### K-7 -- Ebene-B-Push-Aktivierung (G4/P-A)

**Plan-Zitat.** Ledger Par. 66 (23.07., L3476): "(G4) P-A Push-Aktivierung + P-C measure_out (#34/#33 ...)";
Register `:52`:

> "MinIO-Push der Voll-Bau-Binaries in emittierten Batch-Jobs ist INERT -- Aktivierung vor/mit
> Voll-Bau. (P-C measure_out = ERLEDIGT.)"

**Anspruch.** P3, vor/mit dem Voll-Bau-4-Trigger.

**Code-Stand (gemessen).** Die Kette ist **vollstaendig gebaut**, nur nicht scharf:

- Einreihung je frisch gebauter Binary: `cache_engine_builder_iterator.hpp:1730-1744`, Drain `:1927-1935`.
- Transport: `artifact_transport/artifact_cache.hpp:352-413` (perm.dll + Sidecars + `.version`),
  der reale `mc cp`-argv `:898-910`.
- Emission der Storage-Aktivierung in den Batch: `experiment_plan_director.hpp:1203` (Build-Batch),
  `:1351` (Mess-Batch), Prune-Emission `:1452-1459`.
- Schalter: `COMDARE_STORAGE_CACHE == "true"` (`scripts/comdare_storage_activation.sh:33-34`;
  super `.gitlab-ci.yml:596-597` scharf, `:622` INERT). Im super sind es **4 Texttreffer bei 0
  Zuweisungen**; ein Setzen im Repo gibt es nicht.

**ZWEI BEFUNDE.**
(a) **Die Aktivierung ist kein Bau-Posten**, sondern eine Variablen-/Secret-Frage (GitLab-Projekt-
oder Runner-Variable `COMDARE_STORAGE_CACHE=true` plus `COMDARE_MINIO_ENDPOINT`/`_BUCKET` und
`mc` auf dem Runner). Das gehoert in die Trigger-Checkliste und in die Infra-Lane, nicht ins
Bau-Band.
(b) **Der INERT-Zustand ist nicht hart garantiert** (Codex, Kernbeleg selbst gelesen):
`ArtifactCache::from_env()` (`artifact_cache.hpp:232-281`) prueft **nicht** den Schalter, sondern
nur, ob Endpoint UND Bucket nichtleer sind; der False-Zweig (`ce`-Skript `:62-64`, super
`.gitlab-ci.yml:621-623`) **loescht vorhandene Endpoint-/Bucket-Variablen nicht**. Wer die beiden
Variablen aus einem anderen Grund in der Umgebung hat, hat den Push scharf, obwohl der Schalter
"aus" sagt. Fehlerklasse: die Wache beantwortet eine andere Frage als die gestellte.

**Verdikt: GEBAUT, INERT -- Aktivierung = Checklisten-Zeile + Infra; Riss (b) als eigener Posten.**

---

### K-8 -- Lager-Gate G1 (#27 B/C/D + amd24) -- VERLORENE BUCHFUEHRUNG

**Plan-Zitat.** Ledger Par. 66, Z.3476 (23.07.), die **einzige** inhaltliche Fundstelle:

> "Das LAGER-GATE (vor Voll-Bau-4-Trigger) umfasst: (G1) B/C/D+amd24 landen (#27) · (G2)
> STEMPEL-Finalisierung ... (G3) #46b-Bestandslog-Kern ... (G4) P-A Push-Aktivierung + P-C
> measure_out ... (G5) P-B Pruning lokal->0 ..."

Register `:51`: "Landung vor Voll-Bau-4-Trigger; Tasknummer #27 im Nummernraum mehrfach belegt.
**OFFEN-UNGEPRUEFT (kein eindeutiger Schliessbeleg)**".

**Anspruch.** P3, vor dem Voll-Bau-4-Trigger.

**Erhebung (neu, hier erstmals rekonstruiert).** `amd24` kommt im Ledger genau **zweimal** vor
(Z.3476 und Z.4074) und in den Session-/Plan-Docs dreimal. Die zweite Ledger-Stelle loest die
Vokabel auf:

> "(Thread-Budgets §61/amd24) prod1=32T/24K, prod2/amd=24T; Messung=1-Thread exklusiv
> (ceb-measure-<host>)" (Ledger :4074)

Und `docs/sessions/20260723-SESSION-mittag-neustart-zug-vollbau4.md:117` traegt die Aufgabe selbst:

> " 0.1 B/C/D+amd24-Revision abnehmen, committen, Dual-Push (#27) [in Abnahme]"

mit der Legende zwei Absaetze darueber (gleiche Datei): "gn_out-Persistenz Teil A (#30) · **#27
VORGEZOGEN als Teil B** + **Cancel-trap Teil C** (#29) + **K-Label Teil D**".

**Damit ist G1 aufgeloest:** B/C/D sind die drei Teile der `gn_out`-Persistenz-Revision vom
23.07. (Teil B = vorgezogenes #27, Teil C = Cancel-trap, Teil D = K-Label), `amd24` ist die
Thread-Budget-Revision (prod2/amd = 24 Threads) -- also **derselbe Gegenstand, den heute OD-7
traegt**. Der Stand war "[in Abnahme]"; **einen Schliessbeleg gibt es in keiner der vier
Ledger-Quellen** (`/usr/bin/grep "(G1)"` -> 1 Treffer, `amd24` -> 2 Treffer, beide ohne
Vollzugsvermerk).

**Verdikt: VERLORENE BUCHFUEHRUNG mit benennbarem Nachfolger.** Empfehlung (Abschnitt 3): G1 als
eigenstaendiges P3-Gate **streichen** und durch zwei benannte Nachfolger ersetzen -- **OD-7**
(Thread-/Worker-Budgets, K-10) und die **Zaehler-Resume-/Bestandslog-Provider-Zeile** der
Trigger-Checkliste. Der Rest (Cancel-trap, K-Label) liegt in der CI-/Cluster-Lane, fuer diese Linie
read-only, und ist von hier aus **UNBELEGT**. Diese Rekonstruktion gehoert in die parallel laufende
Erhebung zur verlorenen Buchfuehrung (Abschnitt 7).

---

### K-9 -- E8 PMC-Beleg-Form (und ihr Verhaeltnis zum PMC-Sperrposten)

**Plan-Zitat.** Register `:56`:

> "Reicht Permutations-A/B als PMC-Beleg je Achsen-Thema? TRIAGE routete nach A8-S3 (gelandet
> 04.08.), aber **WIDERSPRUCH:** keine Methodik-Bestaetigung im Landungstext auffindbar.
> OFFEN-UNGEPRUEFT (vor Trigger klaeren)."

**Anspruch.** P3, vor Trigger.

**Code-Stand.** Nicht als Code entscheidbar (Methodikfrage). **Ueberholt wird E8 aber von einem
schwereren Befund**, den Ledger `nachmittag-10` Abschnitt E am Objekt belegt und den ich
nachgemessen habe: `libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp` enthaelt
**0 Treffer** fuer `COMDARE_ENABLE_PMC`; die vier Configure-Emissionsstellen (`:841-842`, `:877-878`,
`:1194-1195`, `:1342-1343`) tragen V32 **4/4**, Build-Type **4/4**, Combo **4/4** -- und PMC
**0/4**. Der eigens gebaute #37-Preflight (`:1352-1364`) ruft Targets auf, deren Quelle ohne Flag
gar nicht gebaut ist; `tests/unit/thesis_tiere/linux_perf_pmc_smoke.cpp:58-63` gibt dann
`SMOKE_SKIP ... honest available=0` und **`return 0`**.

**Verdikt: UNTERGEORDNET.** E8 (Beleg-FORM) ist erst sinnvoll zu beantworten, wenn ueberhaupt
Zaehler ungleich 0 entstehen. Bau und Bissfuehrung stehen im eigenen Plan
`docs/plaene/20260806-PLAN-p-pmc-1-messkette.md`; der Owner-Entscheid (drei Teile: Flag als
Invariante, Wache dreht "Quelle nicht gebaut" auf Fehler, Anhangs-Umfang wegen I-PMC-2/3 nur
L1D+dTLB) steht in Ledger `nachmittag-10` Abschnitt H. **E8 selbst wird zur Unterzeile dort und
verliert seinen eigenstaendigen Vor-Trigger-Rang.**

---

### K-10 -- OD-7 Runner-Zahlen HEAVY/NORMAL

**Plan-Zitat.** Owner 26.07. verbatim (aus dem Handout `20260806-HANDOUT-od7-runner-direktive-infra.md:15-17`):

> "24 Worker fuer prod1 und alle Threads fuer prod2 bei Tier-Binary build oder Messung bei
> concurrency 1, sonst prod1 concurrency 2 mit je 12 Threads und prod2 concurrency 2 mit je
> 12 Threads."

Owner-Wiederholung 06.08. `vormittag-22` (ebd. `:28`): **"OD-7: Bitte direktive durchsetzen."**

**Anspruch.** P3, vor dem Voll-Bau-4-Trigger.

**Code-Stand (selbst gemessen, `Cluster/scripts/runner-mode.sh` @ `0d7c577`, Z.43-44):**

```
prod1) NORMAL_CC=4; NORMAL_J=4; HEAVY_CC=1; HEAVY_J=24 ;;
prod2) NORMAL_CC=4; NORMAL_J=4; HEAVY_CC=1; HEAVY_J=$(nproc) ;;
```

- **HEAVY entspricht OD-7** (prod1 24 Worker bei concurrency 1, prod2 nproc) -- **erledigte Haelfte**.
- **NORMAL weicht ab:** 4x4 statt 2x12, auf beiden Hosts.
- **Die Register-Aussage "Ist 3/2 + 16-Kerne-Kappung" ist STALE** (`3/2` stammt aus `2606a0b`,
  eine 16-Kern-Kappung hat **keinen** Code-Beleg) -- das Handout weist es selbst so aus.
- **Chronologie-Falle, die benannt gehoert:** der abweichende NORMAL-Stand stammt aus Commit
  `0d7c577` (27.07. 06:16) mit der Botschaft "Normal-Profil auf c=4@4T beide Hosts (**Owner-Hinweis
  2026-07-27**)" -- also aus einer Owner-Aeusserung, die JUENGER war als OD-7. **Die Owner-Wiederholung
  vom 06.08. ist jedoch die juengste Aussage und gewinnt** ("juengste Fassung gilt").

**Verdikt: HALB ERLEDIGT, Rest in der Infra-Lane.** Fuer diese Linie ist das Cluster-Repo
read-only; das Handout liegt. **Kein Diplom-seitiger Bau-Posten**, aber eine harte
Trigger-Vorbedingung (die Worker-Zahl geht direkt in die Laufzeit-Arithmetik des Voll-Baus ein).

---

### K-11 -- KF-6 NTTP-Codegen (Cacheline-Vollausbau)

**Plan-Zitat.** Register-Korrektur P1 (`:301`): "line_sizes>64 nur ins golden-XML, wenn KF-6-Bau-Teil
vor Trigger landet (OOB-Warnung 62c); sonst zuruecklegen + Regression/TODO-Vermerk."

**Code-Stand (selbst gemessen -- diese Erhebung startete mit einem Alarm und endet mit einer
Entlastung).**

- Das golden-XML traegt die vier Werte: `Code/test_data_xml/experiment_golden_kern.xml:327-330`
  (`<line_size>32/64/128/256`), und es ist **gelandet** (`6558c4ae`, `d8073913`, `953ce412`).
- Der Codegen bindet sie **nicht**: `/usr/bin/grep -n "line_size|cacheline|line_bytes"
  libs/cache_engine/profile_facade/lazy_adhoc_source_gen.hpp` -> **0 Treffer**; die Datei
  `libs/cache_engine/axes/cacheline/cacheline_line_bytes.hpp:16-20` sagt es selbst:
  > "KF-6-NAHT (Posten 62, NICHT hier): heute instanziieren alle Strategie-Basen die
  > Default-CacheLineConfig{} (line_size = B64), weil der Codegen die per-Organ-Config noch nicht
  > als NTTP emittiert."
- **ENTWARNUNG (und der Grund, warum daraus kein 4x-Phantom-Bau wird):** der XML-Block ist inert.
  `/usr/bin/grep -rn "organ_subaxes" libs tests` in der ce -> **0 Treffer**, und das XML selbst
  vermerkt (`:299-303`): *"HEUTE DEKLARATIV: parse_experiment_profile liest <organ_subaxes> noch
  nicht (unbekannte Wurzel-Kinder werden still ignoriert) ... Bis dahin ist der Block wirkungslos
  und die Bau-Matrix unveraendert."* Deckungsgleich mit
  `20260806-PLAN-wellenplan-vollbild-und-parallelisierung.md` Abschnitt 1.8.

**Verdikt: ENTLASTET fuer den Trigger -> NACH ABGABE.** Der OOB-Anteil ist ueber B14-NB3 gelandet
(`abi_adapter.hpp` `:622/:623`, `:731/:732`, `:873/:874` -- abgeleitet statt literal, je mit
`static_assert`). **Die Registerzeile "KF-6 Bau-Teil OFFEN (P1)" ist damit als Trigger-Blocker zu
streichen** -- sonst baut die naechste Runde sie unter Zeitdruck.

---

### K-12 -- #46b-Restumfang (G3-Rest)

**Plan-Zitat.** Register `:41`: "Restbestand des #46b-Vollausbaus nach Herausloesung von RAM-Puffer
(ERLEDIGT), ETA (->B13) und xlsx (->B12): **tatsaechlicher Restumfang unbeziffert.**
OFFEN-UNGEPRUEFT (Dekomposition nicht sauber belegt -- bei P2-Start abgrenzen)."

**Code-Stand.** Die Bausteine liegen im selben 21-Dateien-Verzeichnis wie K-3 (u. a.
`bestandslog_document.hpp` 479 Z., `bestandslog_lock.hpp` 534 Z., `builder_registration.hpp` 709 Z.,
`batch_planner.hpp` 532 Z., `eta_estimator.hpp` 71 Z.). Welche der genannten Restteile
(XML-Bestandslog-Persistenz, avg_size-Log, Gleichverteilung/Takeover) davon gedeckt sind, ist
**ohne einen gezielten Abgleich UNBELEGT** -- ich habe ihn in diesem Lauf nicht gefahren und
behaupte deshalb nichts.

**Verdikt: UNBEZIFFERT.** Der Posten ist kein Bau-Auftrag, sondern ein **Abgrenzungs-Auftrag** von
etwa einer Stunde; er gehoert an den Anfang des P2-Fensters, wo immer das liegt.

---

### K-13 -- LB-6 Stufe 1 (Lager-Basis-Tests) -- KORREKTUR AN DER JUENGSTEN LEDGER-AUSSAGE

**Plan-Zitat.** Owner-Entscheid OE-B (01.08.,
`docs/sessions/20260801-FAHRPLAN-vollbau4-beweise-g6-trigger.md:200-201`):

> "OE-B: GO in Owner-Form: Dummy-Lager im temp-Verzeichnis, Binaries als TEXTDATEIEN mit
> Stempel-String, Test als GOOGLE-TEST (nicht Shell-Skript)."

Ledger `nachmittag-10` Abschnitt F stuft die Restarbeit als **Vor-Trigger-PFLICHT** ein.

**Code-Stand (selbst gemessen).** `tests/unit/test_lb0_lager_pfad_grammatik.cpp`, 598 Zeilen,
**33 TEST-Makros**, aufgeschluesselt nach Praefix: **16 `Lb0*`, 11 `Lb2*`, 6 `Lb3*`** -- darunter
`TEST(Lb3Einlagerung, OeBDummyLagerBeideRealmsAufEchtemDateisystem)` (`:542-569`), der die
Owner-Form woertlich erfuellt: `TempLager`, beide Realms, und (Zitat aus dem Test, `:546-547`)
> `// "Binary" = Textdatei mit Stempel-String (OE-B).`
> `std::string const stempel = "[vereint,O2,avx2][a,b,c]+bt=Release";`
Dazu `test_lb1_knoten_heuristik_log.cpp` mit **23 Makros** (16 `TEST` + 7 `TEST_F`); beide Ziele
sind registriert (`tests/unit/CMakeLists.txt:4951-4964` bzw. `:4966-4977`).

**KORREKTUR.** Ledger `nachmittag-10` Abschnitt F sagt: *"Kein eigener `test_lb2`/`test_lb3`. ...
'LB-0..LB-3 sind gebaut' gilt also fuer die Header; fuer die Beweise gilt es bis LB-1."*
**Am Objekt gilt es bis LB-3** -- die Beweise existieren, sie tragen nur nicht den erwarteten
Dateinamen. Das ist exakt die Fehlerklasse, die derselbe Nachtrag zwei Absaetze frueher selbst
beschreibt ("eine Suche, die die Sprache des Suchenden statt die des Dokuments benutzt, findet
Abwesenheit, wo Anwesenheit ist") -- diesmal ueber Dateinamen statt ueber Vokabeln.

**Verdikt: WEIT FORTGESCHRITTEN.** Der verbleibende Delta ist klein und in
`docs/plaene/20260806-PLAN-lb6-stufe1-oeb-baumform.md` (19:09) bereits ausgearbeitet (D1
Rueckleseprobe u. a.). **Kein zweiter Plan von hier.**

---

### K-14 -- Posten-77/78-Auflagen

**Plan-Zitat.** Register-Korrektur B-11 / P2-Zeile `:308`:

> "kReal16-Doku+Pin-Wache (A2) + XorFilter-FN-Einschraenkungs-Doku inkl. Thesis-/Messbild (A3
> PFLICHT) -- vor Messbild/Messdeutung. OFFEN."

**Code-Stand:** in diesem Lauf **nicht erhoben -- UNBELEGT.** Charakter laut Quelle: eine
Pin-Wache plus zwei Doku-Stellen (ce + Thesis).

**Verdikt: OFFEN, klein.** Gehoert ins Thesis-/Doku-Band (K-14 ist der einzige Posten meines
Katalogs, der die Abgabe-Datei direkt beruehrt), nicht ins Bau-Band.

---

## 3. DIE STREICHLISTE -- mit Begruendung, kein Posten ohne Nachfolger

Owner-Doktrin (Register `:358`): "KEIN Posten wird gestrichen -- jede Aenderung ist Verschiebung,
Status-Korrektur oder Supersede MIT benanntem Nachfolger." Danach ist "Streichung" hier immer
**Streichung aus einem BAND**, nie Loeschung.

| # | Posten | Streichung aus | Begruendung (Beleg) | Nachfolger / neuer Ort |
|---|---|---|---|---|
| S-1 | **KF-6 NTTP-Codegen** (K-11) | P1 / Trigger-Band | golden-`<organ_subaxes>`-Block ist **inert**: 0 Treffer im ce-Parser, XML sagt es selbst (`:299-303`); OOB-Anteil gelandet (`abi_adapter.hpp:622/731/873`) | NACH-ABGABE-Band, Zeile "KF-6 NTTP-Codegen (Posten 62)" |
| S-2 | **Lager-Kaskaden** (Haelfte von K-3) | P2-Band | **gebaut und getestet**: `lager_pfad_grammatik.hpp` 574 Z. + `lager_baum_writer.hpp` 610 Z., Beweise in `test_lb0` (16+11+6 von 33 Makros) | ERLEDIGT-Beleg-Register; offen bleibt nur "xlsx-Geruest" |
| S-3 | **E8 PMC-Beleg-Form** (K-9) | eigenstaendiger P3-Posten | Beleg-FORM ist nachrangig, solange die Quelle nicht gebaut wird (PMC 0/4 Configure-Emissionen) | Unterzeile des PMC-Owner-Entscheids (Ledger `nachmittag-10` H) + `PLAN-p-pmc-1` |
| S-4 | **Lager-Gate G1 (#27 B/C/D + amd24)** (K-8) | P3-Gate-Liste | Gegenstand rekonstruiert (23.07.-Vorlauf 0.1: gn_out-Teile B/C/D + Thread-Budget); **kein Schliessbeleg, aber auch kein eigener Inhalt mehr** | **OD-7** (K-10) + Trigger-Checklisten-Zeile "Bestandslog-Provider/Zaehler-Resume"; Rest -> Infra-Lane, UNBELEGT |
| S-5 | **Posten 89 Rebound-Einpreisung** (K-5) | Bau-Band | 0 Dateien, 0 Code -- reine Deutungsauflage | **Trigger-/Auswertungs-Checkliste**, Zeile "Alt-CSV-Vergleich: Organ-Anteil einpreisen" |
| S-6 | **Ebene-B-Push-Aktivierung** (K-7) | Bau-Band | 0 Zuweisungen im Repo; Aktivierung = CI-/Runner-Variable + `mc` | **Trigger-Checkliste + Infra-Lane**; NEU als eigener Posten: Riss (b) "INERT nicht hart" |
| S-7 | **Lager-Gate G5** (Pruning) | P3 | bereits am 06.08. superseded (Register `:316`) -- hier nur nachgezogen, damit es nicht wieder auftaucht | **O-3 Loesch-GO** (Owner-Fenster) |

**AUSDRUECKLICH NICHT gestrichen:** K-1, K-2, K-4, K-6, K-12, K-13, K-14 -- sie bleiben mit dem
Rang, den ihnen Abschnitt 6 gibt.

---

## 4. ABHAENGIGKEITEN ALS PAARE

Lesart: **A -> B** heisst "A muss vor B stehen"; die Spalte nennt den belegten Grund.

| Paar | Grund (belegt) |
|---|---|
| **L1-Buendel -> K-6 (P2-P8-Bau)** | war die Bau-Queue-Bedingung; **erfuellt** (ce `e7aa1244`), damit entblockt |
| **K-6 (Schema-Slots) -> B12-Fuellung (P4)** | die xlsx-/CSV-Fuellung schreibt die Spalten, die K-6 definiert; WIDE-Schema fliesst automatisch (Ledger `vormittag-4`) |
| **K-2 (G-E3-Binder) -> Messwert-Genus im Lager** | ohne gesetzte `mess_bestand_*`-Felder bleibt `messwert_registrierung.hpp` (199 Z.) wirkungslos ("alle leer => nichts geschieht") |
| **K-2 -> K-1 (T6-Naht) [schwach]** | beide fuellen dasselbe Lager; ohne Binder hat die eingesammelte CSV kein Genus-Ziel. Reihenfolge waehlbar, aber nicht sinnvoll umkehrbar |
| **K-1 (Einsammeln) -> Posten 89 (K-5)** | eingepreist wird beim ERSTEN Vergleich -- der setzt voraus, dass die Stufe-2-CSVs ueberhaupt ankommen |
| **PMC-Owner-Entscheid -> P-PMC-1-Bau -> K-9 (E8)** | dreistufig; die Beleg-Form ist erst nach Zaehlern != 0 beantwortbar |
| **K-10 (OD-7 NORMAL) -> Trigger** | Worker-Zahl geht in die Laufzeit-Arithmetik (`131072 / 24 Worker` -- Wellenplan 4.4) |
| **K-7 (Push scharf) -> Voll-Bau-4** | ohne Push kein Remote-Bestand; ohne Remote-Bestand kein Skip-Gate beim Wiederanlauf |
| **K-7-Riss (b) -> K-7-Aktivierung** | solange `from_env()` den Schalter nicht liest, ist "INERT" eine Zusage ohne Wache |
| **K-4 (E14-Blatt) -> golden-Neuanker** | 5. Blatt bricht `golden_fullpilot_320_binary_ids.txt` (320 IDs) und `test_v41_axis_filter.cpp:97` (Pin auf 4) |
| **K-12 (Abgrenzung) -> P2-Start** | ohne Bezifferung ist der P2-Umfang selbst unbekannt |
| **K-3-xlsx -> Vendoring (`ext/io/zlib`, `ext/io/libxlsxwriter`)** | Soll-Design `:391`; Vendoring-Doktrin (vendor -> faithful -> selfcontained) |
| **K-13 (LB-6 Stufe 1) -> Trigger** | LB-6 deklariert die Stufe als Vor-Trigger-Pflicht ("der Voll-Bau-Trigger IST der Baum-Vollausbau") |

---

## 5. DATEI-BERUEHRUNGEN JE POSTEN (Grundlage des Disjunktheits-Beweises)

Repo-relative Pfade; `ce/` = `Code/external/comdare-cache-engine`, `super/` = Repo-Wurzel.
**Die Spalte "Vollstaendigkeit" ist Teil des Beweises** -- eine Menge, die nicht geschlossen ist,
darf nicht als disjunkt verkauft werden.

| Posten | MUSS-Dateien (belegt) | Vollstaendigkeit |
|---|---|---|
| **K-1** B5/T6-Naht | `super/.gitlab-ci.yml` (Jobs `ergebnis:holen` `:1246-1277`, `persist:measurements` `:842-928`) | **UNBELEGT** -- ob zusaetzlich die CE-Emission (`experiment_plan_director.hpp`) noetig ist, haengt am gewaehlten Uebergabekanal |
| **K-2** G-E3 | `ce/libs/cache_engine/profile_facade/profile_run_facade.hpp` ; `.../profile_run_facade.cpp` ; `.../profile_run_entry.hpp` ; `ce/tests/unit/test_t2a_f4_facade_plan_durchreichung.cpp` ; **Host:** `super/Code/02_messung_driver/main.cpp` | belegt fuer die Durchreichung; der Provider fuer `mess_bestand_doc_key` ist **UNBELEGT** |
| **K-3a** Kaskaden | -- (ERLEDIGT) | -- |
| **K-3b** xlsx-Geruest | keine bestehende Datei zwingend; **neu**: `ext/io/zlib/`, `ext/io/libxlsxwriter/`, `ce/libs/cache_engine/builder/lager_ablage/`, `tools/mess_report/`, CMake | **UNBELEGT** (zukuenftige Substanz) |
| **K-4** E14 | `ce/libs/cache_engine/axes/filter_axis/axis_filter_registry.hpp` ; `.../axis_filter_flags.hpp.in` ; `ce/libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml` ; `ce/CMakeLists.txt` ; `ce/tests/unit/test_v41_axis_filter.cpp` ; **neu**: Blatt-Header ; **golden**: `ce/tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt` | Pfad des neuen Headers **UNBELEGT** |
| **K-5** Posten 89 | **keine** (Checklisten-/Auswerte-Zeile) | vollstaendig |
| **K-6** P2-P8 | `ce/libs/cache_engine/anatomy/observable_tier.hpp` ; `.../abi_adapter.hpp` ; `ce/libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp` ; `ce/tests/unit/test_v41_anatomy_module_abi.cpp` ; `.../test_e24_c10_g5_lade_wache.cpp` ; `.../test_e24_c10_g6_identitaets_bilanz.cpp` | Kern vollstaendig fuer Slot-Fuellen; die konkreten Produzenten je Thema **UNBELEGT** |
| **K-7** Push | **keine** (Variablen/Secrets); fuer Riss (b): `ce/libs/cache_engine/builder/artifact_transport/artifact_cache.hpp` + `super/.gitlab-ci.yml` | belegt |
| **K-8** G1 | **keine** (Buchfuehrung) | -- |
| **K-9** PMC | `ce/libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp` ; `ce/tests/unit/thesis_tiere/test_experiment_plan_director.cpp` ; `.../linux_perf_pmc_smoke.cpp` ; `ce/tests/unit/CMakeLists.txt` | belegte Minimalmenge (Detail: `PLAN-p-pmc-1`) |
| **K-10** OD-7 | `Cluster/scripts/runner-mode.sh` -- **fuer diese Linie read-only** | vollstaendig, aber fremde Lane |
| **K-11** KF-6 | `ce/libs/cache_engine/builder/experiment_tree/profile_to_tree.hpp` ; `.../lazy_adhoc_source_gen.hpp` ; Tests | **UNBELEGT** (Strategy-Binder, HW-Gate) -- und nach Abgabe |
| **K-13** LB-6 | `ce/tests/unit/test_lb0_lager_pfad_grammatik.cpp` (+ ggf. `lager_baum_writer.hpp`, `tests/unit/CMakeLists.txt`) | s. `PLAN-lb6` |

### 5.1 Die Kollisionen, die daraus folgen (ehrlich, nicht beschoenigt)

1. **`ce/.../cache_engine_builder_iterator.hpp`** -- K-2 liest dort, **schreibt aber nicht**
   (die Felder werden bereits konsumiert). **Keine Kollision**, sofern K-2 sich auf die Fassade
   beschraenkt. Wer den Iterator doch anfasst, kollidiert mit allem, was am Mess-Kopf arbeitet.
2. **`ce/.../experiment_plan_director.hpp`** -- **K-9 (PMC) und potenziell K-1** (falls der
   Uebergabekanal ueber die Emission laeuft). **Echte Ein-Schreiber-Flaeche: seriell fahren.**
3. **`super/.gitlab-ci.yml`** -- **K-1**, K-7-Riss (b) und die E-18-Aktivierung teilen die Datei.
   Kein Textkonflikt zu erwarten (verschiedene Bloecke), aber Ein-Schreiber-Disziplin gilt.
4. **`ce/libs/cache_engine/anatomy/observable_tier.hpp` + `abi_adapter.hpp`** -- **K-6 ist
   ABI-tragend.** Solange K-6 laeuft, darf **kein** zweites ABI-/POD-Paket offen sein (ABI-Sparsamkeit
   ist Gesetz, Par. 0-Doktrin).
5. **`ce/CMakeLists.txt` + Registry + golden** -- **K-4 allein**; die golden-Datei ist TABU-nah und
   vertraegt keinen Parallel-Schreiber.

**Damit sind disjunkt und gleichzeitig fahrbar:** K-2 (Fassade) ; K-9 (Plan-Director) ; K-13
(Testdatei) ; K-1 (CI-YAML) -- vier Bahnen ohne gemeinsame Datei. **Nicht** dazu: K-6 (ABI-Sperre)
und K-4 (golden).

---

## 6. PRIORISIERUNG ZUR FRIST -- ehrlich, Optimismus hilft hier niemandem

Frist: **Abgabe Fr 08.08.**, **Trigger-Ziel Do 07.08.**, **Phase 6 = Owner-GO-Stopp**.
Aus meinem Katalog stammt **kein einziger** Posten, der den Bau-Block schlaegt: die Landung von A1
plus ein hart gruener Voll-Lauf bleibt vorrangig (Wellenplan 4.3).

### (A) MUSS vor dem Trigger -- und ist leistbar

| Rang | Posten | Warum jetzt | Aufwand (ehrlich) |
|---|---|---|---|
| 1 | **K-10 OD-7 NORMAL** (Infra-Lane) | Worker-Zahl bestimmt, ob der Voll-Bau in das Fenster passt; Handout liegt seit heute Vormittag | fremde Lane, Diplom-Aufwand ~0 |
| 2 | **K-7 Push-Aktivierung als Checklisten-Zeile** + Riss (b) benennen | ohne Push kein Remote-Bestand, ohne Bestand kein Skip beim Wiederanlauf | Minuten (Checkliste), Riss (b) ~1 h |
| 3 | **K-5 Posten 89 als Checklisten-Zeile** | verhindert eine Falsch-Regressions-Lesung beim ersten Vergleich | Minuten |
| 4 | **K-13 LB-6 Stufe 1 Rest-Delta** | Vor-Trigger-Pflicht laut LB-6; Bausteine + Beweise bis LB-3 stehen | s. `PLAN-lb6` (dort beziffert) |
| 5 | **K-12 #46b-Abgrenzung** | ohne sie ist der P2-Umfang selbst unbekannt -- billigste Klarheit im ganzen Katalog | ~1 h, read-only |

### (B) MUSS vor der Abgabe -- aber nicht vor dem Trigger

| Posten | Warum |
|---|---|
| **K-14 Posten-77/78-Auflagen** | beruehrt Thesis-/Messbild-Doku; PFLICHT laut Owner-A3 |
| **K-9-Anteil "Anhangs-Umfang"** | der Anhang darf keine Limitierung behaupten, die die Messung widerlegt (V-08-Rest) -- Entscheid, kein Bau |

### (C) NACH der Abgabe (mit benanntem Ort)

K-11 KF-6 NTTP-Codegen ; K-4 E14 (falls Owner den golden-Neuanker nicht vorzieht) ;
K-3b xlsx-Writer-Vollausbau ; K-2 in seiner Voll-Form (Provider + Host-Kette) ;
K-1 in seiner Voll-Form (`needs:pipeline`/API-Abzug).

### (D) PASST NICHT MEHR REIN -- klar gesagt

1. **Das P2-Band als Ganzes.** Register-Leitplanke 4 verlangt "P2-P8 + Lager-Geruest + B5 + G-E3 +
   #46b-Rest + 77/78 VOR Messbeginn". **Gebaut ist davon nichts** (K-1 Skelett, K-2 0 Zuweisungen,
   K-3b 0 Code, K-6 0 Code). Zwei Tage neben dem Bau-Block reichen dafuer nicht. Das ist der
   groesste Riss zwischen Plan und Fenster und gehoert in die Owner-Vorlage, **nicht in eine stille
   Verschiebung** (deckungsgleich mit Wellenplan 4.3).
2. **K-3b xlsx-Geruest "mit in die Abgabe".** Der Owner-Satz vom 05.08. abend ist eindeutig -- und
   er ist mit dem heutigen Stand **nicht mehr erfuellbar**: das Soll-Design verlangt zwei neu zu
   vendorende Fremdbibliotheken plus Writer plus CLI plus Tests plus CI. **Der Satz muss ausdruecklich
   zurueckgemeldet werden** (Owner-Frage 3), nicht unterlaufen.
3. **K-6 P2-P8-Bau vor dem Trigger.** 33 Spalten ueber 14 Themen sind ABI-tragende Arbeit; sie
   sperrt die einzige ABI-Spur, die auch A1 und alle Nachbesserungen brauchen.
4. **K-4 E14 vor dem Trigger** -- nur um den Preis eines golden-Neuankers auf der Trigger-Eingabe.
5. **Neuvalidierung von Messwerten nach einem PMC-Fix**: das Flag ist eine Zeile, die
   131.072-Zellen-Matrix ist ein mehrtaegiger Lauf.

**Der eine Satz fuer den Fall, dass es enger wird:** Checklisten-Zeilen (K-5, K-7, K-10) kosten
Minuten und retten die Deutbarkeit der Messung; Bau-Posten (K-6, K-3b, K-4) kosten Tage und
gefaehrden den Trigger. Wer tauscht, tauscht falsch herum.

---

## 7. ZULIEFERUNG AN DIE ERHEBUNG "VERLORENE BUCHFUEHRUNG"

Vier Funde dieses Laufs gehoeren dorthin, nicht in ein Bau-Band:

1. **G1 (#27 B/C/D + amd24) -- aufgeloest** (K-8): B/C/D = die drei Teile der
   `gn_out`-Persistenz-Revision vom 23.07. (Teil B = vorgezogenes #27, Teil C = Cancel-trap,
   Teil D = K-Label), `amd24` = Thread-Budget prod2/amd 24T. Quelle:
   `docs/sessions/20260723-SESSION-mittag-neustart-zug-vollbau4.md:117` + Ledger `:4074`.
   **Kein Schliessbeleg** in vier Ledgern; Nachfolger benannt (S-4).
2. **LB-Beweise reichen bis LB-3, nicht bis LB-1** (K-13): 33 Makros in `test_lb0`, davon 11
   `Lb2*` und 6 `Lb3*`; der OE-B-Dummy-Lager-GTest existiert (`:542`). **Korrektur an Ledger
   `nachmittag-10` Abschnitt F**, also am juengsten Eintrag.
3. **P2-P8 ist entblockt** (K-6): die Blocker-Aussage "haengt an B14-ce (BLOCKIERT)" stammt aus
   der Zeit vor der L1-Landung; B14-ce ist als `f577f886` in `e7aa1244`.
4. **OD-7-Chronologie** (K-10): die Abweichung entstand durch einen **Owner-Hinweis vom 27.07.**
   (Commit `0d7c577`), nicht durch Nachlaessigkeit -- und wird durch die Owner-Wiederholung vom
   06.08. wieder ueberholt. Wer nur den Skript-Stand liest, sieht eine Missachtung, wo eine
   Ueberholung stattgefunden hat. **Beide Aussagen gehoeren in dieselbe Zeile.**

Zusaetzlich als **neuer** Posten (in keiner Liste gefunden): **K-7-Riss (b)** -- `from_env()`
prueft den INERT-Schalter nicht, der False-Zweig raeumt Endpoint/Bucket nicht ab.

---

## 8. OFFENE OWNER-FRAGEN (nicht von dieser Linie entscheidbar)

1. **E14 (K-4):** Der GO lautet "P2-Bau". Ein fuenftes Filter-Blatt bricht die 320er-Golden-Liste
   und den Registry-Pin. **Vor dem Trigger bauen (mit golden-Neuanker) -- oder ins ohnehin
   geplante golden-Neuanker-Fenster nach der Messung?** Empfehlung: nach der Messung; die
   Trigger-Eingabe bleibt sonst nicht stabil.
2. **P2-Band (D-1):** Welche Posten des P2-Bandes duerfen **hinter** den Messbeginn rutschen?
   Leitplanke 4 sagt "alle vorher"; das Fenster sagt "keiner". Ohne Entscheid entsteht die
   Verschiebung stillschweigend -- was die Doktrin ausdruecklich verbietet.
3. **xlsx "mit in die Abgabe" (K-3b):** der Satz vom 05.08. abend ist mit dem heutigen Stand nicht
   erfuellbar (zwei zu vendorende Bibliotheken). **Faellt er, oder faellt etwas anderes?**
4. **K-7 Push-Scharfschaltung:** faehrt der Trigger-Lauf mit `COMDARE_STORAGE_CACHE=true` und
   gesetzten MinIO-Variablen? Vom Repo aus **nicht entscheidbar** (Runner-Env/Projekt-Variablen).

---

## 9. SELBSTCHECK

- Kein Edit an Code, kein Commit, kein Push; kein Worktree unter `/home/comdare/wt-*` beruehrt;
  Cluster nur gelesen.
- Codex zweimal eingesetzt (`approval-policy: never`, `sandbox: workspace-write`, `cwd` gesetzt),
  **ohne jedes `git`**; die Sandbox-Beleggrenze ist in 0.2 ausgewiesen, alle tragenden
  Negativ-Befunde wurden lokal mit `/usr/bin/grep` nachgemessen.
- Jede Zahl mit Bezugsgroesse (9 Feld-Treffer / 0 Zuweisungen ; 49 von 144 Slots ; 4 von 4
  Filter-Blaetter ; 326 = 6 + 320 Zeilen ; 33 = 16 + 11 + 6 Makros ; 21 Dateien / 6362 Zeilen ;
  PMC 0 von 4 Configure-Stellen).
- Nicht Belegbares ist als UNBELEGT gekennzeichnet (K-12 Restumfang, K-14 Detail, mehrere
  MUSS-Mengen).
- Drei erledigte Positionen sind als vollwertige Funde verbucht (Lager-Kaskaden, KF-6-OOB/Inertheit,
  OD-7-HEAVY) -- zwei davon fuehren zu Streichungen aus dem Trigger-Band.
- ASCII-only ausser in woertlichen Zitaten.
