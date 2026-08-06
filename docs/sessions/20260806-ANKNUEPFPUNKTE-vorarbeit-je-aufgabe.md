# ANKNUEPFPUNKTE: was die frueheren Wellen zu den heutigen Aufgaben schon herausgefunden haben

Stand: 2026-08-06, abends.
Datenbasis: 121 `result`-Berichte aus 56 Journalen unter
`/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/backups/20260806-workflow-rohdaten/journals/`,
ergaenzt um einzelne gezielte Griffe in `.../20260806-workflow-rohdaten/outputs/`.
Erhoben von zehn Abgleich-Agenten, je einer pro heutiger Aufgabe.

**Beweisstatus, fuer das gesamte Dokument gueltig:** Alles Zitierte sind **Behauptungen der
jeweiligen frueheren Agenten-Berichte**. Weder die Abgleich-Agenten noch dieses Dokument haben
irgendetwas davon am Code nachgeprueft. Wo ein Bericht selbst schreibt "am Objekt gemessen" oder
"selbst ausgefuehrt", ist das vermerkt — es bleibt trotzdem eine ungepruefte Fremdbehauptung.
Wo ein Bericht selbst "UNBELEGT" sagt, ist das mitzitiert. Zeilennummern stammen aus Berichten
gegen die Staende ce `47c4ef1d` / `b241a272` / `e7aa1244` / `3bbcb8ed` und altern; ein Beleg
braucht neben der Zeile einen Suchbegriff (`wf_b242700f-3a0` #9).

Fundstellen-Notation: `wf_<journal-id>` / `<agentId>`, beide aus dem Journal-Verzeichnis oben.

---

## 0. Warum es dieses Dokument gibt

Sechs Bau-Wellen wurden heute gestartet, bevor die gesicherten Ergebnisse der frueheren Wellen
desselben Tages abgeglichen waren. Eine musste sofort gestoppt werden. Dieses Dokument ist die
nachgeholte Grundlage: es sagt je Aufgabe, was schon erhoben, was schon gebaut und was schon
entschieden ist — und wo eine heutige Auftragsannahme einem frueheren Befund widerspricht.

Das Dokument ersetzt keine Neu-Verankerung am Objekt. Es sagt, **wo hinzusehen ist**, bevor
gebaut wird.

---

## 1. DIE WIDERSPRUECHE — zuerst, weil sie am teuersten sind

Sortiert nach Kostenklasse: A = entwertet Bau oder Messung bzw. verstoesst gegen einen
Owner-KERN. B = baut am falschen Objekt oder doppelt vorhandene Arbeit. C = Bezugsgroessen,
Nummern, Register.

### Klasse A — entwertet Bau/Messung oder steht gegen einen Owner-KERN

#### W-01 · M-2-PMC steht gegen den Owner-KERN vom 06.08. abends
- **Auftragsannahme:** `-DCOMDARE_ENABLE_PMC=ON` in jede der vier Emissionsstellen.
- **Frueherer Befund:** `wf_b242700f-3a0` / `ae007fa589f7024e5`, Posten A-1, Owner verbatim:
  *"PMC MUSS eingebaut und gemessen werden und zwar in die CEB fuer deren Pruefdock ... NIE
  abkuerzen, immer mit deep research fixen."* — und der Bericht dazu: *"Also **nicht** eine
  Flag-Zeile in der Emission, sondern die Mess-Achse gibt frei, was messbar ist."* Stufung: T1,
  "blockiert den Messbeginn".
  `wf_514dab7d-8a0` / `ad4d5f57cd9699a9c` §5.3 fuehrt beide Wege als einander ausschliessend:
  Weg A (Compile-Schalter ausserhalb der Achsen-Taxonomie, ~13 TUs, "Owner-KERN (E) ist
  verletzt") vs. Weg B (PMC als Mess-Haupt-Achse, "voller Neubau der Matrix"). Und: *"der
  aktuelle PMC-Plan waehlt bewusst die Bauform, die **keine** Fortpflanzung ausloest ... Nach der
  Stufen-Doktrin ist das kein Vorzug, sondern der Beweis, dass PMC dort nicht als Mess-Achse
  eingebaut ist."*
- **Folge:** Entweder M-2 wird ausdruecklich als Weg-A-Zwischenschritt im Ledger deklariert (dann
  ist bekannt, dass ein spaeteres Weg-B den Voll-Bau entwertet, Faktor "mindestens 131.072 : 0"),
  oder die Welle steht gegen einen Owner-KERN. **Nicht stillschweigend weiterbauen.**

#### W-02 · M-1: "Format-Bump 3→4 voraussichtlich NICHT noetig" steht gegen drei Berichte
- **Auftragsannahme:** Glied [3] existiert, also ist kein Preimage-Formatwechsel noetig.
- **Frueherer Befund:** Alle drei Berichte bestaetigen die Praemisse (Glied [3] existiert) und
  widersprechen der Schlussfolgerung, weil Glied [3] **nicht ausreicht**:
  - `wf_ebe2aced-d4b` / `aa811c70b24c62177`, R-3: *"Glied [3] traegt nur Tooling-Ids +
    Registry-Version + `load_framework`"*; Toolchain-Glied = 9 Felder, *"kein Mess-Define"*;
    *"`COMDARE_MEASUREMENT_ON` veraendert die ABI"* (`abi_adapter.hpp:393` laesst den Adapter nur
    darunter `IObservableTier` erben). Empfehlung: *"JA, jetzt erweitern ... Konsequenz: JA =
    Format-Bump 3→4"*, **"Dringlichkeit: VOR DEM ERSTEN BATCH ... das Fenster schliesst mit der
    ersten geschriebenen `.fingerprint`-Datei."**
  - `wf_ebe2aced-d4b` / `a95076f256a0944d3`, 4.B (III), Buendelungsliste: Punkt 2
    `COMDARE_MEASUREMENT_ON` als Preimage-Feld, Punkt 6 *"`fingerprint_format` 3 → 4 — der Bump
    ist der Mechanismus, der die Welle deterministisch macht statt still kollidieren zu lassen"*.
  - `wf_ebe2aced-d4b` / `a6847e8d9e5bcb322`, D-6/D-7: *"Die Struktur steht, der Inhalt des
    Mess-Glieds ist unvollstaendig"*; Bau-Posten M-7 *"Format-Kennung [0] auf 4 heben"*.
- **Aufloesung (als offene Frage benannt, nicht geraten):** Die heutige Annahme traegt genau
  dann, wenn der D-1-Fix `COMDARE_MEASUREMENT_ON` deterministisch aus der Tooling-Combo ableitet.
  Sie traegt nicht, sobald ein Mess-Define entsteht, das nicht aus der Combo folgt —
  `COMDARE_ENABLE_PMC`, die 16 `measurement_categories`, oder die Release-Nachmessung mit
  `MEASUREMENT_ON=0`. Kein Bericht behauptet, der Bump sei fuer D-1 *allein* zwingend; drei
  behaupten, er sei fuer die Vollstaendigkeit der Naht zwingend. `aa811c70b24c62177` fuehrt ihn
  ausdruecklich als **offenen Owner-Entscheid**.
- **Preisschild aus demselben Bericht:** *"Alle ALPHA/BETA vor dem Batch: 1 Voll-Bau = 34,4 h /
  Ein einziger davon danach: 2 Voll-Baue = 68,8 h + Entwertung aller Messdaten."*

#### W-03 · M-3: "oder ehrlich als honest-0 fuehren" ist als Rueckfalloption bereits ausgeschlossen
- **Auftragsannahme:** L2/L3/Kohaerenz/RAPL entweder real erheben *oder* als honest-0 fuehren.
- **Frueherer Befund:** `wf_ebe2aced-d4b` / `aa811c70b24c62177`, E-1: *"**FIXEN.** Owner verbatim:
  'fixen und neu messen ist **Pflicht**', 'NIE abkuerzen, immer mit deep research fixen'.
  Gegenstelle 'honest-0 bis #26' ist im Ledger als SUPERSEDED vermerkt."* Dazu die
  Doktrin-Grenze (`wf_d023e824-238` / `a9d7004c44011c39b`): honest-100% (Owner 13.07.) *"honest-0
  NUR wo genuin 0"*.
- **Verschaerfung:** `wf_514dab7d-8a0` / `a669786e3f854007d`: `system_axis.hpp:410`/`:413` rufen
  `mark_ok(counters->cache_misses_l2)` bzw. `mark_ok(counters->branch_misses)` — sobald
  irgendein Counter lieferte, werden L2 und BRANCH_MISS als *"`SampleStatus::Ok` mit Wert 0"*
  ausgewiesen. *"Der Nachruest-Weg muss das mitheilen, sonst wird aus honest-0 ein Phantom-Ok."*
  Der ehrliche Zustand ist `mark_source_unavailable`, nicht 0.
- **Folge:** honest-0 ist an mindestens einer Stelle keine gueltige Alternative. Reihenfolge-Auflage
  desselben Berichts: **N-3 (Ehrlichkeit) → N-2 (Probe) → N-1 (Kategorie) → N-4 (Freigabe/Gate).**
  *"Wer N-4 vor N-3 landet, schaltet ein Gate scharf, dessen Urteil noch `mark_ok(0)` lautet."*

#### W-04 · M-6: "Selektion ist Teilmenge der Bau-Menge" ist keine Vorgabe, sondern offene Owner-Frage — und macht die heutige 320er ungueltig
- **Auftragsannahme:** Teilmengen-Validierung ist gesetzt.
- **Frueherer Befund:** `wf_ebe2aced-d4b` / `aa811c70b24c62177`, R-2 fuehrt es als unbeantwortete
  Frage (V1 = Auswahl ueber der Bau-Menge, V2 = zwei unabhaengige Mengen, neue Fehlerklasse
  "gemessen ohne gebaut"). `wf_ebe2aced-d4b` / `aa8ceff625589ccd4`, R-1, mit eigener Sonde
  (`/tmp/scope1probe/count.sh`): *"320er ids total: 320 / davon im 2^17-Raum: **16** / NICHT im
  2^17-Raum: **304**"* — *"Die Antwort entscheidet, ob B-2 eine fail-closed Teilmengen-Wache
  bekommt (dann ist die heutige 320er ungueltig und muss neu deklariert werden)."*
- **Kollision mit "Messdaten nie loeschen":** *"Eine Teilmengen-konforme 320 waere eine andere
  320 ... Empfehlung: **additiv, nicht ersetzend** — die alte 320 als `m3v2_study` unangetastet
  lassen, eine neue `golden_kern_320.profile.xml` als echte Teilmenge des 2^17 anlegen."*
- **Folge:** Eine fail-closed Wache ohne gleichzeitig deklarierte, teilmengen-konforme
  Mess-Selektion macht den heutigen Mess-Weg **rot**, nicht besser.

#### W-05 · M-2: "beide Smokes fail-closed drehen" kann den 13.07.-Inversionsfix zurueckdrehen
- **Auftragsannahme:** beide PMC-Smokes fail-closed.
- **Frueherer Befund:** `wf_216c6dbe-b55` / `ab077c917752b767e`: *"das fruehere Verdikt
  `honest_null` (`!available && all-zero`) ... kippte ein ehrlich-live-PMC (available=1) auf
  SMOKE_FAIL; der 13.07.-Fix (M-CE-25/Muster-F) hat genau das geheilt. Wer die Zeile
  'zurueckdreht', baut den Bug von neuem ein."* `wf_ebe2aced-d4b` / `a6847e8d9e5bcb322` (dort
  "M-2") verbietet die Beruehrung ganz: *"`m3v2_pmc_smoke.cpp:71` **NICHT** anfassen."*
- **Zulaessiger Weg (bereits ausformuliert):** `wf_d5d5761c-1aa` / `a89e6be5a24b83d4d`, B3:
  `constexpr bool kPmcExpected` aus `#if defined(COMDARE_ENABLE_PMC) && defined(__linux__)`;
  `linux_perf_pmc_smoke.cpp:58-63` faellt bei `kPmcExpected && !available` auf SMOKE_FAIL;
  `m3v2_pmc_smoke.cpp:71` wird `available || (!kPmcExpected && counters_all_zero)`.
- **Folge:** "fail-closed" nur ueber ein `kPmcExpected`-Praedikat, nie durch Ruecknahme von
  `|| counters_all_zero`.

#### W-06 · M-5: Der Dock-Einbau ist kein Refactoring, er aendert Messergebnisse
- **Auftragsannahme:** Plan-Ablauf `genus()` → richtiges Pruef-Dock → Schleife (liest sich als
  Umverdrahtung).
- **Frueherer Befund:** `wf_514dab7d-8a0` / `a7fc207bcb25ee4cb`, S1.1-Biss: *"Negativ-Probe mit
  einer Container-Genus-DLL ... **heute wird sie gemessen wie ein SearchAlgorithm**, nach dem Fix
  `dock_status_wrong_genus`"*; A-2: *"Der Gattungs-Diskriminator `genus()` wird im
  Produktionspfad **nie** gelesen."*
- **Folge:** Zellen, die heute Messwerte liefern, werden danach abgelehnt. Im selben Fenster wie
  ein Voll-Messlauf ist das ein Datenrisiko, das der Auftrag nicht benennt.

#### W-07 · Sicherheit: "390 Runner-Token nicht rotiert (heute verifiziert)" — die Verifikation existiert im Bestand nicht, und die Bezugsgroesse stimmt nicht
- **Auftragsannahme:** 390 Token, Rotation heute geprueft, nicht rotiert.
- **Frueherer Befund:** `wf_b242700f-3a0` / `ae007fa589f7024e5`, E-1 (laut Bericht heute live
  nachgeprueft): *"In den beiden Dateien ... `group_projects.ndjson` (**386**) und
  `projects_all.ndjson` (**390**) stehen **zusammen 776** Vorkommen von `runners_token`."* 390 =
  Trefferzahl in **einer** der beiden Dateien; die 390 aus E-23 ist zudem der
  Plausibilitaets-Anker "390 Projekte/109 Gruppen" (`outputs/be52dmp6f.output`). Die README des
  Backups selbst: *"ob die 390 Runner-Registration-Tokens seit dem 02.08. rotiert wurden, ist aus
  diesen Daten **nicht ersichtlich**."*
- **Owner-Stand:** `wf_d023e824-238` / `a1c685e676573d0ee`, Owner verbatim (Transkript
  `2026-08-02T09:25:20.301Z`): *"Entscheid 5 - Bitte nach Messfenster rotieren und bitte handout
  an infra."* Termin-Klasse laut E-1: **T3**, nicht sofort.
- **Folge:** In den 121 Berichten steht keine Messung, kein API-Abruf, kein Token-Vergleich.
  "Nicht rotiert" waere aus diesem Bestand nur der Umkehrschluss aus einem fehlenden Beleg —
  genau die Fehlerklasse, die der Bestand selbst mehrfach benennt. Offen bleibt die
  Terminierungsfrage: `wf_ebe2aced-d4b` / `aa811c70b24c62177`, M-3: *"eine Terminierung, deren
  Bezugsgroesse sich verzehnfacht, ist keine mehr"* (08.08. → 15.09.).

### Klasse B — baut am falschen Objekt oder doppelt vorhandene Arbeit

#### W-08 · M-6: Der Auftrag nennt das falsche Schema
- **Auftragsannahme:** `<measure_selection>` in "Schema + Parser + ThesisProfile + Traeger-Profil",
  Schema = `experiment_schema.xsd`.
- **Frueherer Befund:** `wf_ebe2aced-d4b` / `aa8ceff625589ccd4`, 3.1: *"Es existieren im gesamten
  Projekt genau zwei XSD ... Der **Trigger-Traeger hat gar kein Schema.**
  `all_axes_golden.profile.xml` ist `comdare_thesis_profile` und traegt 0 `xsi:`-Attribute
  (selbst gezaehlt). Autoritaet ist allein `parse_thesis_profile` + `validate_profile`."* Und
  2.2b: *"`experiment_golden_kern.xml` wird im gesamten `.gitlab-ci.yml` **null Mal**
  referenziert"*; Trigger-Profil ist `all_axes_golden.profile.xml` (`.gitlab-ci.yml:1152`).
- **Folge:** Wer `<measure_selection>` nur ins XSD schreibt, hat am Traeger nichts geaendert. Wie
  "Schema" fuer M-6 ueberhaupt aussehen soll (neues XSD? nur `validate_profile`?), ist **unklar**
  — Fehlanzeige, kein Bericht beantwortet es.

#### W-09 · M-3: "L3 real erheben" verdrahtet etwas, das schon verdrahtet ist
- **Auftragsannahme:** L2/L3/Kohaerenz nachruesten.
- **Frueherer Befund:** `wf_ebe2aced-d4b` / `a95076f256a0944d3`, D-4: *"`cache_misses_l2` und
  `coherence_invalidations` werden bewusst nicht geoeffnet (`linux_perf_pmc_source.hpp:194-195`,
  `:208`, `:295`) ... `cache_misses_l3` **wird** als Last-Level geoeffnet (`:192`, `:263-266`) —
  lieferte im D-03-Lauf trotzdem 0 in allen 16 Zeilen. **KORREKTUR zum Wellenplan:** L3 ist nicht
  'nicht gebaut', sondern gebaut und stumm. **Der Fix-Umfang unterscheidet sich dadurch: L3 =
  Diagnose, L2/Kohaerenz = RAW-Event-Neubau.**"* Am Korpus gemessen von zwei unabhaengigen
  Berichten (`wf_216c6dbe-b55` / `ab077c917752b767e`, `wf_4f06e488-670` / `afff42bd0404da387`):
  `pmc_available` 1 in allen 16 Zeilen, L1 und dTLB real, L2/L3/coherence/energy 0.
- **Folge:** Der offene Posten bei L3 ist eine Ursachen-Diagnose (Kandidaten: `perf_event_paranoid`,
  CPU ohne generischen LL-Event, Lesefehler; Ursache laut Bericht **UNBELEGT**), keine
  Nachruestung.

#### W-10 · M-5: Der ObservableTier-/Dock-Audit ist bereits gefahren
- **Auftragsannahme:** "SUCHE: ... ObservableTier-Vertrag".
- **Frueherer Befund:** `wf_514dab7d-8a0` / `a7fc207bcb25ee4cb` ist genau dieser Audit: 9
  Abweichungen A-1..A-9, 6 Gefahren G-1..G-6, gestufte Bau-Anweisung **S0–S5 mit Biss-Test je
  Schritt** und Rebuild-Bilanz je Stufe. Der heutige M-5-Auftrag entspricht dort **S1.1**
  ("Rebuild nach S1 ohne 1.4: Host/CEB neu, Planer –, Tier-Binaries –, ABI-Major bleibt 8").
  `wf_ebe2aced-d4b` / `a6847e8d9e5bcb322` fuehrt den Audit noch als "AUDIT-AUFTRAG, noch nicht
  ausgefuehrt" — dieser Bericht las einen **frueheren** ce-Stand (`47c4ef1d` vs. `b241a272`).
- **Folge:** Audit **verwenden**, nicht wiederholen.

#### W-11 · G-E3: Die "Schwester zu `make_fingerprint_key_fn()`" existiert bereits — aber sie ist etwas anderes
- **Auftragsannahme:** Es braucht ein `make_messwert_key_fn()`.
- **Frueherer Befund:** `outputs/a9a2b597006efcd8c.output` und `outputs/batvn6yni.output`:
  `bestandslog_factory.hpp` fuehrt `make_binary_bestand()` / `make_messwert_bestand()` mit
  `BinaryKeyPolicy` / `MesswertKeyPolicy` als CT-Policy; Test `test_g3_sha512_index.cpp` mit Fall
  `TwoGeneraSeparate` PASSED. Und die Abgrenzung wortwoertlich: *"`bestandslog_factory.hpp` ist
  eine **Key-Ableitungs**-Factory ... sie **berechnet** einen Schluessel aus Stempel-**Zeilen**.
  Sie **erkennt** keinen Stempel aus einer Binary. `fingerprint_key_source.hpp` liest ein
  **Sidecar neben** der Binary."*
- **Offene Luecke, die daraus folgt:** `make_fingerprint_key_fn` ist ein *Provider* ueber
  `.fingerprint`-Sidecars. Fuer das Mess-Genus gibt es kein solches Sidecar — der Baum-Writer
  schreibt keine (`wf_701941f6-2c9` / `a6af7e4a8f0697ad0`: *"0 Treffer `sidecar` in
  `lager_baum_writer.hpp`"*). **Wogegen ein Mess-Genus-Key-Provider lesen soll, ist in keinem der
  121 Berichte benannt. Vor dem Bau zu klaeren.**
- **Namens-Fehlanzeige:** `make_messwert_key_fn` und `messwert_key_hex` haben ueber alle 121
  Berichte und alle 269 `outputs/`-Dateien **0 Treffer**.

#### W-12 · G-E3: drei Felder, aber vier Naehte — das zweite Aktiv-Gate fehlt im Auftrag
- **Auftragsannahme:** drei Iterator-cfg-Felder `mess_bestand_*`.
- **Frueherer Befund:** `wf_216c6dbe-b55` / `ab077c917752b767e`: *"direkt daneben steht
  `mess_bestandslog_active` (`:1665-1668`) mit derselben Luecke ... **Der Fix muss beide Gates
  fassen, sonst heilt er die Haelfte.**"* Bauanweisung `wf_ebe2aced-d4b` / `a6847e8d9e5bcb322`
  (dort "M-6"): *"`cache_engine_builder_iterator.hpp:1658-1660` **UND** `:1665-1668` —
  `cfg.bestand_fingerprint_fn` bzw. `cfg.mess_bestand_fingerprint_fn` in **beide**
  Aktiv-Bedingungen aufnehmen, fail-closed."*
- **Unklar:** ob `cfg.mess_bestand_fingerprint_fn` heute als Feld existiert oder erst zu bauen
  ist — sagt kein Bericht.

#### W-13 · Messbeginn: drei der vier "ungemessenen" Groessen sind gemessen
- **Auftragsannahme:** Bau-Umfang 131.072 / 524.288 / 2.097.152 unentschieden; Zeit je Binary
  ungemessen; `cap`-Frage offen; Fenster global oder je Perm unklar.
- **Frueherer Befund**, alle aus `wf_ebe2aced-d4b` / `aa8ceff625589ccd4`:
  - Umfang: *"Der reale Bau-Umfang ist heute **524.288** Tier-Binaries — nicht 131.072 (das ist
    das Fenster je System-Perm) und nicht 2.097.152 (der Faktor 4 aus `line_size` haengt an einem
    XML-Block, den kein Parser liest, in einer Datei, die die Pipeline nie anfasst)."*
    Bestaetigt in `a6847e8d9e5bcb322`, R-2.
  - Fenster: *"`COMDARE_GN_TOTAL` ist ein Fenster **JE SYSTEM-PERM**, nicht global"*
    (`experiment_plan_director.hpp:989-990` verbatim; `while`-Schleife innerhalb der
    Perm-Schleife `:1230-1272`). Deckungsgleich `wf_24104303-f97` / `aff70699b2fc8788c`.
  - Kappung: *"Es gibt **KEINE Kappung.** ... `profile_effective_cap` liefert `min(131072,
    131072)`. Es kappt nichts. 'gekappt auf 131.072' ist eine Fehlbeschreibung."*
  - Zeit: *"Der FAHRPLAN nennt die Kompilierzeit 'unbekannt, nicht gemessen' — **das ist
    ueberholt.**"* Aus Pipeline 12690: amd 19,4 min / 4096, intel 32,25 min / 4096; abgeleitet
    0,284 s bzw. 0,472 s je Binary wall; Voll-Bau ~34,4 h Wanduhr, Engpass intel.
- **Selbstkennzeichnung des Berichts:** *"Der Zusammenhang 19,4 min ↔ 4096 ist ueber ZWEI
  Dokumente hergestellt ... kein einziger Satz sagt '4096 Binaries in 19,4 min' woertlich.
  Empfehlung: mit dem ersten 4096er-Batch literal nachmessen."*
- **Folge:** Der morgige Batch ist **Bestaetigungsmessung**, nicht Erstmessung.

#### W-14 · Thesis: "Anhang-A-Abbildungen ehrlich machen" unterstellt, Ersatztext sei die einzige Abhilfe
- **Auftragsannahme:** die 17 stummen bzw. 28 fehlenden Eintraege bekommen Ersatztext.
- **Frueherer Befund:** `wf_ebe2aced-d4b` / `a9f196e0e0aaa9bd4` (SCOPE 4) hat den Generator
  gebaut und gefahren: *"**Ich habe es gefahren, nicht abgeleitet:** Generator aus dem
  HEAD-Quelltext gebaut (14,4 s), gegen den heutigen Korpus laufen lassen, **28 von 28 Positionen
  bedient**, Thesis-PDF DE+EN gebaut, 0 Fehler."* Aufteilung: 19 echte Figuren/Tabellen, 6
  ehrliche Vermerk-Dateien, 3 honest-empty. Wirkung: DE 246 statt 202 Seiten, EN 238 statt 192.
- **Folge:** Ein reiner Ersatztext-Pass beschriftet einen Zustand als "ehrlich", den derselbe Tag
  mit echten Daten fuellen konnte. Das ist eine Owner-Entscheidung (O-4), keine Bau-Frage.
  Einschraenkungen desselben Berichts: *"`ld_sweep_*` ist eine Kurve mit EINEM Punkt"*, *"Die
  Flaechen sind 4x2 statt 4x21"*, `erase`/`scan`/`rmw` im Korpus nie ausgefuehrt.

#### W-15 · Thesis: "die zwei Einbindungen konsistent machen" — kein Bericht empfiehlt das, zwei empfehlen das Gegenteil
- **Auftragsannahme:** beide Overleaf-Mounts behalten, Zeiger konsistent halten.
- **Frueherer Befund:** `wf_ebe2aced-d4b` / `a969ce4aadda0858e`: Konsumenten des zweiten Mounts
  gemessen **null** (`.gitlab-ci.yml` 0, alle CMake 0, Baum nur `.gitmodules`); und ein Test
  schliesst ihn aktiv aus (`test_experiment_plan_director.cpp:1854-1856`: *"die Overleaf-Thesis
  wird NICHT geklont"*). Fazit: *"Board-Posten #74 wurde durch Gleichziehen der SHAs geschlossen
  — nicht durch Aufloesung der Doppelung. Genau das hat heute erneut gebissen."* Mit
  7-Schritt-Bau-Anweisung. `wf_b242700f-3a0` / `aa1f413636c35eb1b`, IV-1: *"Wenn nein: entfernen
  ... **das ist die saubere Loesung, weil sie die Ursache streicht statt sie zu bewachen.**"*
- **Zusatz-Vorbedingung, die Konsistenz allein nicht heilt:** `.gitmodules` ist asymmetrisch — der
  vierte Block traegt weder `branch` noch `update`, *"die zweite, unabhaengige Driftquelle"*.
- **Folge:** "Konsistent statt reduzieren" ist ein Owner-Entscheid; wenn er so faellt, gehoert die
  Gleichheits-Wache in `verify:submodules` zwingend dazu.

#### W-16 · Sicherheit: die ASCII-Wache in den super spiegeln = den Defekt mitspiegeln
- **Auftragsannahme:** `ci_diff_ascii_width_guard` fehlt im super, also spiegeln.
- **Frueherer Befund:** Fehlanzeige ist belegt (`wf_b242700f-3a0` / `aba55729d2bd08221`: *"`find`
  ueber den super ausserhalb `external/` = **0** Treffer"*). Aber derselbe Bericht, N-1: *"Die
  Wache bindet das Repo an ihren eigenen Ort, nicht an das Arbeitsverzeichnis des Aufrufers.
  `:141-142` setzt `_ce_repo_root=$(cd "$(dirname $0)/.." && pwd)` ... aufgerufen aus
  `cwd=/home/comdare/wt-b14-ce` meldete die Wache ein fremdes Repo und mass 12578 statt 1450
  Zeilen — **ein GRUEN ueber einen fremden Baum.**"* Im super, der Submodule traegt, ist das der
  Normalfall. Ausserdem Regel 6: *"Die Diff-Hygiene-Wache war dreimal gruen ... und `lint:format`
  fand trotzdem 94 Verstoesse in 13 Dateien. Zwei verschiedene Gegenstaende."*
- **Verwechslungsgefahr:** Der Bestand fuehrt **zwei** im super fehlende Wachen — die ASCII-Wache
  und die Abdeckungs-Invariante (D-3). Der ausformulierte super-Spiegel-Bauplan
  (`wf_ebe2aced-d4b` / `a969ce4aadda0858e`) betrifft **nur** die Abdeckungs-Invariante.

### Klasse C — Bezugsgroessen, Nummern, Register

#### W-17 · Die M-Nummern sind heute doppelt belegt
Im Wellen-/Scheiben-Papier `wf_ebe2aced-d4b` / `a6847e8d9e5bcb322` gilt:

| heutige Kennung | dort belegt mit | heutiger Inhalt heisst dort |
|---|---|---|
| M-1 | "PMC-Flag in alle 4 Emissionen" | **M-7** (Mess-Glied des Fingerprints vervollstaendigen) |
| M-2 | Smokes | (deckungsgleich) |
| M-3 | `allow_failure: true` am Mess-Batch (`:1333`) | **M-14** (L2 + Kohaerenz + branch_misses + IPC) |
| M-5 | P-KAL Kalibrier-Stichprobe | **M-13** (ObservableTier-Vertrags-Audit) |
| M-6 | die beiden Aktiv-Gates (`:1658` und `:1665`) | (heutiges M-6 = XML-Trennung, dort B-D + B-E) |

Wer heute "M-3" sagt und M-14 meint, kollidiert mit einer Welle, die in derselben Zeilenregion
arbeitet wie M-1. Beim Abgleich von Vollzugsmeldungen ist das eine echte Verwechslungsquelle.

#### W-18 · Die Owner-Fragen-Buchstaben F1–F8 sind heute ZWEIMAL vergeben
`wf_12436422-eb1` / `a26e17e103a87ccfa` (14:06 Uhr) fuehrt eine **Vormittagsrunde** F1–F8, von
der **F6** (verwirft "Micro-/Macro-Benchmarking sind FALSCH" auch das §47-Auswahl-Achsen-Konzept
selbst? — *"Kein Supersede-Vermerk auf §47 im Ledger"*) und **F8** (gilt "gleicher Fingerprint ⇒
Messwerte uebertragbar, auch nach Neubau" uneingeschraenkt?) **offen** sind. Die heute Abend
beantworteten F1–F8 sind eine andere, disjunkte Runde. Wer "F6 beantwortet" bucht, schliesst
versehentlich die §47-Frage. Als Dauer-Fehlerklasse belegt (`wf_12436422-eb1` /
`a600af29d90ff73d2`): *"mindestens drei unabhaengige 'Strang A/B/C'-Systeme, mindestens **vier
unabhaengige 'F'-Nummerierungsrunden** ... Die Buchstaben sind Wegwerf-Etiketten einzelner
Planungs-Workflows, keine stabile Projekt-Taxonomie."* Und `wf_d023e824-238` /
`a309ab967d12e52de`: *"vier Nummern-Kollisionen im Korpus: O-2, F6 (dreifach), B12, R2."*

#### W-19 · Das Register fuehrt V-08 als erledigt, obwohl es am Objekt widerlegt ist
`wf_abbabbb4-8c0` / `a0d64249eb63f36f3`: *"V-08 misst nicht gegen 0 — L1/L3/**branch_misses**
real erhoben und emittiert"*, uebernommen in `wf_216c6dbe-b55` / `af80391241cbab43a` und in
Task #8. Widerlegt von zwei unabhaengigen Berichten: `wf_514dab7d-8a0` / `a7fc207bcb25ee4cb`
(*"`branch_misses` — **von KEINER Quelle je geschrieben**; der Kommentar
`cache_engine_builder_iterator.hpp:499-500` behauptet 'PmcCounters ERHEBT branch_misses real' —
falsch am Objekt"*) und `wf_d5d5761c-1aa` / `a89e6be5a24b83d4d` (*"18 Treffer repo-weit: keine
PMC-Quelle weist das Feld jemals zu ... die einzigen Zuweisungen stehen in TESTS"*).
**Wer das Register liest statt den Audit, haelt M-3 fuer erledigt.**

#### W-20 · Die Prioritaetsordnung ist auf den falschen Termin geeicht
`wf_ebe2aced-d4b` / `aa811c70b24c62177`, M-1: *"`grep '15.09|Freitag|woechentlich'` ueber Ledger,
`docs/plaene/`, `docs/sessions/` → **0 Treffer**. Der gesamte Planbestand ist auf 'Abgabe Fr
08.08.' geschrieben ... Ohne diese Festlegung ist die gesamte P0-P4-Ordnung des Registers auf
einen falschen Termin geeicht — sie priorisiert gegen 48 Stunden statt gegen 40 Tage. Groesste
stille Fehlerquelle der aktuellen Planung."* Bestaetigt `wf_b242700f-3a0` / `ae007fa589f7024e5`:
Owner am Abend des 06.08.: **Endtermin 15.09.2026, woechentliche Lieferung freitags**; der 08.08.
war ein Zwischenziel. Betroffen sind mindestens: O-4 (Anhang-A-Reichweite, Default
"NACH-ABGABE" war mit dem 08.08. begruendet), V-11 und der Runner-Token-Posten.

#### W-21 · M-2: der Auftrag nennt "cache_misses-Spalten", ohne zu sagen welche
Drei unvereinbare Aussagen im Bestand: (1) Ledger *"nur L1D + dTLB"*; (2) `wf_b242700f-3a0` /
`ae007fa589f7024e5` mit Live-Gegenueberstellung (mit Flag `cache_misses_l1=4191307`,
`dtlb_misses=1767452`, Rest 0); (3) `wf_d5d5761c-1aa` sieht L3 als korrekt gelabelt. Der reale
Korpus (`measure_out_d03/e4_xml/measurements.csv`, 16 Zeilen, ausgezaehlt von
`wf_ebe2aced-d4b` / `a9f196e0e0aaa9bd4`) entscheidet gegen (3): L2/L3/coherence/energy sind
**0 in allen 16 Zeilen**. Und `pmc_seam_ok = available || all_zero` faengt das nicht.
**Folge:** Ein "PMC=ON"-Erfolgssignal, das L2/L3/coherence/branch_misses weiter 0 laesst, ist
vorprogrammiert, solange der Auftrag die Spalten-Erwartung nicht benennt.

#### W-22 · M-5 / M-1 / G-E3: die Zeilenanker stammen aus verschiedenen ce-Staenden
`wf_732cebce-c68` / `a43fcd1894f5d2111`: ce `development @3bbcb8ed` = **Format 2, 6 Glieder**;
T2-A `@847c93c9` = Format 3, 8 Glieder, *"noch nicht nach ce gelandet"*. Spaeter meldet
`wf_ebe2aced-d4b` / `a6847e8d9e5bcb322` die Landung (`a9a352bb 6c300e68 86be2420`), und
`wf_d5d5761c-1aa` / `ad6f7a811153a2559` liest bereits gegen `e7aa1244`. **Die "Glied [3] von
8"-Annahme ist basis-abhaengig.** Vor jedem Zeilen-Eingriff: `kAnatomyFingerprintGliedCount`
am HEAD belegen (6 oder 8). Dasselbe gilt fuer M-5 (Anker aus `47c4ef1d` und `b241a272`).

---

## 2. JE AUFGABE: die Vorarbeit

### 2.1 M-1 — Identitaets-Naht (Mess-Glied des Fingerprints)

**(a) Vorarbeit.**
- `wf_514dab7d-8a0` / `ad4d5f57cd9699a9c` ist der **Ursprung der D-Nummerierung** des heutigen
  Auftrags. Diff-Tabelle §5.1 enthaelt D-1 (*"0 funktionale Konsumenten von
  `MeasurementTooling`; `-DCOMDARE_MEASUREMENT_ON=1` hart, `profile_run_facade.cpp:274`"*,
  KRITISCH), D-2 (*"`measurement_line`/`measurement_entries` = 0 produktive Leser; kein Gate"*),
  D-4 (*"`kCebFingerprint` rendert das **Angebot** ... nicht injektiv ueber Combos"*). Belege:
  §4.6 (2 Treffer, beide Unit-Tests; `measurement_entries` 0 ausserhalb der Deklaration), §4.3
  (*"Zwei CEBs, gebaut mit `[wallclock]` und mit `[macro]`, tragen denselben `ceb_key_sha512`"*),
  §4.1 (*"JA, als Glied [3] von 8"*).
- `wf_514dab7d-8a0` / `a7fc207bcb25ee4cb` — der ObservableTier-Audit mit S0–S5. Einschlaegig:
  **S2.1** (Define-Satz aus der Combo an *einer* Stelle; Biss: *"`nm`/`readelf` zeigen
  unterschiedliche Symbolmengen; heute byte-identisch bis auf den Stempel-String. **Das ist der
  eine Beweis, der die Achse zur Achse macht.**"*), **S2.3** (Tooling-Konsistenz CEB↔Tier;
  *"Heute laeuft diese Kombination stumm durch."*), **S4.2** (`kCebFingerprint` als Glied
  **oder** `kCebContractCodegenMinor` ableiten).
- Kosten-/Fenster-Rechnung: `wf_ebe2aced-d4b` / `a95076f256a0944d3` (*"`.fingerprint`-Sidecars,
  super-Repo gesamt: **0**"*, *"Es geht heute nichts verloren"*) und `aa8ceff625589ccd4`
  (*"Voll-Bau-Wanduhr beide Lanes parallel = ~34,4 h"*, 524.288 Binaries).
- Stempel-Substanz und Kadenz-Trennung: `wf_732cebce-c68` / `a43fcd1894f5d2111` und der Plan
  `a30ac654c6448ce6a` (`docs/plaene/20260806-PLAN-versionierungs-interface-stempel.md`, 815 Z.):
  *"ABI-Major(8) / POD-Layout(6) / Fingerprint-Format(3) sind heute drei unabhaengige Zaehler mit
  drei Kostenklassen"*.

**(b) Widersprueche.** W-02 (Format-Bump), W-22 (Basis-Drift). Dazu:
- **Zweite Quelle desselben Makros.** `wf_b242700f-3a0` / `ae007fa589f7024e5`, A-5: *"Das Makro
  kommt aus `CMakeLists.txt:135` (`option(COMDARE_MEASUREMENT_MODE ... ON)`) ueber `:141
  add_compile_definitions(COMDARE_MEASUREMENT_ON=1)`. **Was gemessen werden kann, entscheidet
  heute eine CMake-Option, nicht die Mess-Achse.**"* Der Auftrag nennt nur `perm_mess_defines()`.
  Entlastender Gegenbefund: `wf_216c6dbe-b55` / `ab077c917752b767e` hat die realen Tier-`.rsp`
  gelesen (8 von 8 tragen `-DCOMDARE_MEASUREMENT_ON=1`) — stuetzt `perm_mess_defines()` als
  alleinigen Traeger des **Tier**-Pfads; die CMake-Zeile traefe dann CEB/Treiber. **Welche Quelle
  der ABI-Adapter in der `.so` sieht, ist aus den Berichten nicht entscheidbar.**

**(c) Erledigt.**
- Format 3 / 8 Glieder / Glied [3] Mess / [5] Toolchain / [6] bvset: **gebaut und gelandet**
  (`wf_ebe2aced-d4b` / `a6847e8d9e5bcb322`: *"`a9a352bb 6c300e68 86be2420` T2-A / Neuanker Format
  3 GELANDET"*, mit sanktionierter Ausnahme von der Fingerprint-Neutralitaets-Auflage).
- F-3-Regression im Mess-Tooling (3 Ein-Tool-Combos → 1 Vollmengen-Combo): **korrigiert** in
  beiden produktiven XMLs (`wf_65970f05-a49` / `a973e9a0f27a92f92`, `wf_6a3096f7-60d` /
  `ac8f30215f2553e9e`), Bau-Matrix-Folge Tooling-Faktor 3 → 1.
- **D-1, D-2, D-4 selbst: NICHT gebaut.** Kein Bericht meldet eine Aenderung an
  `perm_mess_defines()`, `ceb_version_stamp.hpp` oder ein Tooling-Konsistenz-Gate;
  `perm_mess_defines` erscheint in 4 von 121 Berichten, alle read-only.
- **Achtung Verwechslung:** das "kein Format-Bump noetig" der T2-A-Berichte (`wf_c72fb788-466` /
  `acfb05d0f4faa2f8d`, `a184c5d7f7201a9f0`; `wf_d7a17fc9-ead` / `a3d66ccc3aec5fe08`) bezog sich
  auf **T2-E** (Stempel-Renderer-Dialekt), nicht auf das Mess-Glied.

**(d) Offene Vorbedingungen.**
1. `kCebFingerprint` ins Tier-Preimage zu ziehen ist **Owner-Entscheid**: LEDGER:5792 listet ihn
   unter "NICHT im Tier-Preimage (begruendet)" (`a7fc207bcb25ee4cb`, A-7 / S4.2).
2. Es gibt **kein CEB-seitiges Skip-Gate** — D-4 allein erzeugt keine Wirkung
   (`ad4d5f57cd9699a9c`, §4.4: *"`kCebFingerprint` ist nirgends ein Wiederverwendungs-Kriterium"*).
3. D-2 hat heute keinen Landeplatz im Produktionspfad: `cache_engine_builder_iterator.hpp:2394`
   *"umgeht Registry, `accepts()`, `dock_genus()` und `measure()` vollstaendig"* ⇒ **S1.1 ist
   Vorbedingung fuer D-2** (`a7fc207bcb25ee4cb`, A-2).
4. Wirkt D-1, entsteht sofort eine neue Fehlerklasse ohne Unterscheidungsmittel: das
   **Capability-Bit fehlt** (A-9) — Release-DLL und kaputte DLL landen beide als `load_failed=1`
   + `SourceUnavailable`. Neues `extern "C"`-Symbol ⇒ mit dem ABI-Major zu buendeln (S1.4/S3).
5. **Drei Frozen-Vektoren**, nicht einer: `17148e5a…` in `test_m_w12_stamp_bausteine.cpp:663`,
   `test_g3_sha512_index.cpp:68`, `test_w10_system_cell_values.cpp:432` (`a30ac654c6448ce6a`,
   K1) — *"Jeder Preimage-Dreh kostet also drei Anker, nicht einen."*
6. Das Sicherheitsnetz verschwindet mit dem Trigger: ohne `COMDARE_BESTANDSLOG=true` kein
   `.fingerprint` ⇒ ehrlicher Neubau; der Voll-Bau-4 soll *"mit aktivem Provider"* fahren —
   *"ab dem Trigger ist das Netz weg"* (`a95076f256a0944d3`, §1.D).
7. **F6 der Vormittagsrunde** steht offen (LEDGER:5365) und traegt S2: *"S2 baut die Achse als
   CT-Auswahl-Traeger — das setzt voraus, dass §47 gilt."*

**(e) Fehlanzeigen.**
- Zu `measurement_entries`/`measurement_entry_count` existiert ausser der Zaehlung **kein
  einziger weiterer Befund**. Kein Bericht sagt, wozu die Felder gedacht waren.
- Kein `nm`/`readelf`-Vergleich `[wallclock]` vs. `[all]` existiert; der einzige Bericht, der ihn
  nennt, fuehrt ihn als noch zu erbringenden Biss (S2.1) und die Overhead-Groesse ausdruecklich
  als *"UNBELEGT"*.
- Ob eine Erweiterung des Mess-Arrays einen ABI-Major ausloest: nur eine ausgewiesene
  Nicht-Antwort (`ad4d5f57cd9699a9c`, §6.4: *"waere layout-neutral. **Nicht verifiziert.**"*).
- Hybrid als Traeger der Naht: *"es gibt keinen Hybrid"* (A-8, 3 grep-Treffer, alle
  Kommentar/Pfad).

---

### 2.2 M-2 — PMC-Flag in den Emissionen

**(a) Vorarbeit.** Die Bau-Anweisung ist bereits **verifiziert geschrieben**:
- `wf_d5d5761c-1aa` / `ad6f7a811153a2559` — P-PMC-1 gegengeprueft am Stand `e7aa1244`, *"Kein
  fehlender Schritt gefunden"*, mit fertigem Invarianten-Test im Quelltext und der Begruendung
  gegen den Zahl-Pin: *"Die Wurzel war laut Ledger, dass die PMC-Pflicht an zwei Job-Namen hing
  statt an einer Vollstaendigkeitsbedingung."*
- `wf_d5d5761c-1aa` / `a89e6be5a24b83d4d` — der Plan `docs/plaene/20260806-PLAN-p-pmc-1-messkette.md`
  (651 Z., **nicht committet**), B0–B6 + Wellen W-1..W-5 + O-PMC-1..3. Dessen B2 deckt sich
  woertlich mit der heutigen Auftragsformulierung: *"zu jeder emittierten `cmake -B build`-Zeile,
  deren Folgezeile `--target comdare-messung-driver` baut, gehoert das Flag — heute 4/4, faengt
  eine fuenfte Stelle automatisch ... (der Fall existiert: super `.gitlab-ci.yml:333` haelt einen
  Auswertungs-Job bewusst flaglos). Plus `EXPECT_GT(geprueft, 0u)` gegen die leer-gruen-laufende
  Wache."*
- Weitere: `wf_ebe2aced-d4b` / `a6847e8d9e5bcb322` (M-1/M-2/M-3/M-14 als getrennte Posten);
  `wf_514dab7d-8a0` / `a669786e3f854007d` (Abstands-Bilanz Mess-Achse ↔ PMC, Nachruest-Weg
  N-1..N-4); `wf_514dab7d-8a0` / `a7fc207bcb25ee4cb` (S0.1/S0.2 mit Gegenprobe *"Bau ohne Flag ⇒
  Preflight rot (heute gruen)"*); `wf_d023e824-238` / `a1c685e676573d0ee` (*"Beides ist
  Owner-Pflicht seit 16.07. und keine Wahlfrage"*).
- **Divergenz in der Vorarbeit selbst:** `a7fc207bcb25ee4cb` (S0.1) schlaegt den verworfenen
  Zahl-Pin vor (`grep -c "ENABLE_PMC" == 4`). Der heutige Auftrag folgt zu Recht der anderen
  Fassung.

**(b) Widersprueche.** W-01 (Owner-KERN), W-05 (Inversionsfix), W-21 (Spalten-Erwartung). Dazu:
- **Doku-Drift, zwei Berichte empfehlen Gegenteiliges.** `a89e6be5a24b83d4d`, B5(a):
  *"`linux_perf_pmc_smoke.cpp:4` behauptet Registrierung '+ COMDARE_ENABLE_PMC',
  `tests/unit/CMakeLists.txt:3553` registriert nur unter `if(UNIX AND NOT APPLE)` — **Kommentar
  korrigieren, nicht die Registrierung (sonst braeche der Preflight am fehlenden Target)**."*
  Gegen: `a7fc207bcb25ee4cb`, S0.2: *"`linux_perf_pmc_smoke` unter `COMDARE_ENABLE_PMC`
  registrieren (`CE/tests/unit/CMakeLists.txt:3568`)"*. Abweichende Zeilennummer 3553 vs. 3568.
  Die Registrierungs-Variante verletzt zudem die Ein-Schreiber-Regel (siehe (d) D-9).
- **"Vier Wachen" statt drei** (`wf_216c6dbe-b55` / `a2c3691b77804d30a`, Ledger nachmittag-10 E).
- **Der Preflight ist nicht defekt.** `wf_b242700f-3a0` / `a1ae0111a8ba19b41`: *"Die Wache ist
  nicht defekt; sie beantwortet eine andere Frage."* `wf_24104303-f97` / `aff70699b2fc8788c`:
  *"ab `:66` hat der Test sehr wohl einen Biss ... der Defekt trifft nur den Fall 'Quelle gar
  nicht gebaut'."* Ein Umbau, der diesen Biss mitentfernt, waere eine Regression.

**(c) Erledigt.**
- PMC-Preflight **#37 ist gebaut** (`wf_18a419ce-aad` / `af47374e2633fd61c`,
  `experiment_plan_director.hpp:1269-1280` code-verifiziert). Namenskollision beachten: *"Posten
  37 (Aufraeumpass) ≠ #37 PMC-Preflight (ERLEDIGT)"*. M-2 baut keinen Preflight neu, sondern
  verengt einen bestehenden.
- Das Flag existiert bereits an **zwei anderen Stellen**: super `.gitlab-ci.yml:677`
  (measure:smoke) und `:768` (measure:golden-320), beide Zeilen gelesen (`wf_60a89435-167` /
  `a514b2f38574e4021`). Der Ledger-Haken I-PMC-1 ist gesetzt, aber *"am Objekt unwirksam auf dem
  heutigen Mess-Weg"*.
- **Nichts vom Bau selbst ist gelandet** — kein Bericht meldet eine PMC-Landung.
- Der Plan-Text (651 Z.) ist **nicht committet** und steht unter VERLUSTRISIKO (`git clean`).

**(d) Offene Vorbedingungen.**
1. `allow_failure` deckt am selben Job auch CMake-Configure/Build-Fehler, fehlenden Driver **und
   den PMC-Preflight selbst** (`wf_fc6a7db4-7a2` / `aaf668298aa78ccbf`, `:1342-1363`) ⇒ ein
   fail-closed gedrehter Smoke faerbt den Mess-Batch trotzdem nicht rot. **Muss deklariert
   werden**, sonst dieselbe Klasse Scheinsicherheit.
2. **HARTE SPERRE gegen den Aufraeumpass** (`wf_63e3bb60-ecd` / `aa9448106300ae72e`, AP-12):
   `measure:smoke`/`measure:golden-320` tragen das einzige `-DCOMDARE_ENABLE_PMC=ON` des
   Mess-Pfads — *"erst PMC-Invariante + Wachen-Drehung, dann Entfernung."*
3. `:1194` und `:1342` muessen **gemeinsam** landen (geteiltes `Code/build` ueber
   `emit_gn_out_persistence_variables`); empirisch nachgebaut: ohne Flag 76,7 s / 13 CXX-Compiles,
   mit Flag 12 von 13 Objektdateien erneut kompiliert — einmalig pro Lane, nicht die Matrix.
4. **Ehrlichkeits-Korrektur vor der Scharfschaltung** (N-3 vor N-4): PMC einzuschalten macht L2
   und `branch_misses` aktiv zu Phantom-Ok, weil `mark_ok(0)` greift, sobald irgendein Counter
   liefert. Das ist eine Verschlechterung, die der Auftrag nicht adressiert.
5. **Kollisionsflaeche `experiment_plan_director.hpp`** (`aa811c70b24c62177`, K-1): B-C, B-E, B-F
   schreiben alle dieselbe Datei — *"EIN PAKET. Drei Wellen hiessen drei Voll-Gates und zwei
   garantierte Merge-Konflikte."*
6. **Kopplung an M-1:** `COMDARE_ENABLE_PMC` steht nicht im Fingerprint; *"PMC ist bau-wirksam →
   muss mit B-B in denselben Bump, sonst zweiter Voll-Bau."*
7. **Ohne super-Submodul-Bump (W-5) ist die Landung wirkungslos** (ANKLAGE i-1); Auflage T-1:
   ce-`main`-FF und super-Gitlink-Bump in denselben Arbeitsgang.
8. **Zugriffsbeweis auf beiden Lanes ist UNBELEGT** (O-PMC-2/3c): *"der Trigger kann blockieren,
   wenn eine Lane keinen Zugriff hat"*; `perf_event_paranoid`/RAPL-Lesbarkeit heute nicht
   nachgemessen.
9. **CI-Nenner/Test-Routing:** jeder neue ce-Test verschiebt den Nenner der Abdeckungswache
   (heute 407); `ce tests/unit/CMakeLists.txt` hat **EINEN SCHREIBER (P-A1)** bis A1 gelandet
   ist; `test:unit` faehrt `-LE pmc` ⇒ der neue Invarianten-Test darf kein `pmc`-Label tragen.
10. Offener Owner-Rest: nur Teil (3) von O-A (Anhangs-Umfang) bleibt offen.
11. **Offene Ursachenfrage:** *"UNBELEGT: WARUM der Lauf PMC-Werte hat —
    `-DCOMDARE_ENABLE_PMC=ON` steht in keinem der vier `measure_out_d03-*.log`."* Solange das
    ungeklaert ist, ist die Praemisse "ohne Flag gibt es gar keine Quelle" nicht voll gedeckt.

**(e) Fehlanzeigen.** Keine eigenstaendige Vorarbeit zu `NullPmcSource` (alle 6 Nennungen sind
Konsequenzsaetze). Nur ein Bericht beruehrt die `pmc_*`-CSV-Spalten-Schreiber
(*"schreibt die 8 `pmc_*`-Spalten unkonditioniert ins CSV — an `MeasurementCategory`,
`SystemAxisSample` und `SampleStatus` komplett vorbei"*); ob M-2 daran etwas aendern soll, klaert
kein Bericht. Die Lanes `pmc:amd`/`pmc:intel` hat niemand gelesen. Der Umbau-Commit, der die
PMC-Pflicht am 16.07. fallen liess, ist **nicht identifiziert**. Ob je eine fuenfte
Emissionsstelle existierte: keine Aussage.

---

### 2.3 M-3 — Zaehler (L2 / L3 / Kohaerenz / branch_misses / RAPL)

**(a) Vorarbeit.** Der Inhalt ist **viermal unabhaengig geplant**:
- **B6 + O-PMC-3** im P-PMC-1-Plan (`wf_d5d5761c-1aa` / `a89e6be5a24b83d4d`): *"B6 —
  `branch_misses` verdrahten (optional, Fenster schliesst mit dem Trigger).
  `PERF_COUNT_HW_BRANCH_MISSES`, Muster `:202-207`, **kein RAW-Event**."* Und O-PMC-3(c) = die
  RAPL-Frage woertlich, mit Probe-Vorschlag (`cat`-Einzeiler im pmc-Job vor dem Trigger).
- **S0.3** im ObservableTier-Audit (`wf_514dab7d-8a0` / `a7fc207bcb25ee4cb`), inkl. Biss:
  *"`pmc_branch_misses > 0` bei Zweig-lastiger Last; Kontrast gegen `linear_scan`"*.
- **N-1..N-4** in der Mess-Layer-Erhebung (`wf_514dab7d-8a0` / `a669786e3f854007d`), mit dem
  Verweis auf den existierenden Nachruest-Bauplan
  `docs/sessions/20260601-26-pmc-counter-beschaffungs-spec.md` und dem Befund *"`pmc_flags.hpp.in`
  existiert nicht — waehrend 27 andere Achsen ihr `*_flags.hpp.in` haben. Der Schritt 1 der Spec
  ist der einzige nie ausgefuehrte."*
- **M-14** im Scheiben-Papier (`wf_ebe2aced-d4b` / `a6847e8d9e5bcb322`).
- Vor-Erhebung `wf_d5d5761c-1aa` / `ad6f7a811153a2559`: *"`branch_misses` wird in
  `LinuxPerfPmcSource` gar nicht erst geoeffnet — obwohl `PERF_COUNT_HW_BRANCH_MISSES` derselbe
  billige, portable Counter-Typ ist wie die drei bereits verdrahteten."*
- Korpus-Auszaehlung zweimal unabhaengig: `wf_216c6dbe-b55` / `ab077c917752b767e` und
  `wf_4f06e488-670` / `afff42bd0404da387`.

**Empfehlung aus dem Abgleich: die vorhandene Fassung ziehen, nicht die fuenfte schreiben.**

**(b) Widersprueche.** W-09 (L3 verdrahtet und stumm), W-03 (honest-0 ausgeschlossen /
Phantom-Ok), W-19 (Register fuehrt V-08 als erledigt), W-17 (M-3 = M-14). Dazu:
- **"nur L1D+dTLB" ist zugleich zu pessimistisch und zu optimistisch.** `wf_24104303-f97` /
  `aff70699b2fc8788c`, R-T2: *"widerlegt — `cache_misses_l3` wird aus `PERF_COUNT_HW_CACHE_LL`
  befuellt ... Strukturell 0 bleiben L2, coherence, branch (**drei, nicht vier**). O-A wird
  derzeit auf der falschen Zahl vorbereitet (LEDGER:4540)."* Direkt dagegen `wf_b242700f-3a0` /
  `ae007fa589f7024e5`. Aufloesung ueber D-4: L3 ist verdrahtet **und** liefert 0.

**(c) Erledigt.** Nichts gebaut — kein Bericht meldet einen Commit an `linux_perf_pmc_source.hpp`,
`measurement_category.hpp` oder `system_axis.hpp`. Teil-erledigt ist die Doku-Richtung: der
Ersatztext fuer die Anhang-A-Limitierung ist ausformuliert (`wf_ebe2aced-d4b` /
`a9f196e0e0aaa9bd4`).

**(d) Offene Vorbedingungen.**
1. **Kohaerenz ist heute gar keine Mess-Achse** — `coherence_invalidations` hat CSV-Spalte und
   POD-Feld, aber **keine `MeasurementCategory`** (16 Werte). Die Nachruestung ist eine
   Kategorie-Erweiterung; der Bau bricht beabsichtigt compile-hart an vier/fuenf Stellen
   (`measurement_axis_registry.hpp:23`, `:61`, `system_axis.hpp:27-36`, `:38-42`
   `kPmcCounterCategories` 7→8, `:132-134`). ABI-neutral belegt (0 Treffer in `include/.../abi/`).
2. **Reihenfolge N-3 vor N-4.**
3. **M-14 setzt M-7 (= heutiges M-1) voraus:** *"Sonst wird die L2/L3-Nachruestung nicht in die
   Flotte gebaut."* Mechanismus: *"Zwei CEBs — eine mit `-DCOMDARE_ENABLE_PMC=ON`, eine ohne —
   erzeugen byte-identische Mess-Stempel-Zeilen ... die Umkehrung des Owner-Gesetzes."*
4. **RAPL:** `pmc_energy_micro_joules` ist 0 **obwohl `pmc_available=1`** — die AMD-Zonenfrage
   ist nicht die einzige moegliche Ursache. Provenienz des Korpus ausdruecklich UNBELEGT (nur
   Zeitstempel 26.07. 16:38 und `perm.dll.version`), also **unklar, ob der Lauf auf der AMD-Lane
   lief**.
5. **Nicht raten, fragen:** RAW-Events ueber `/sys/bus/event_source/devices/cpu/events/<name>`
   beziehen. Ausdruecklich UNBELEGT: welche Ereignisse prod1 (Zen 5) und prod2 (Raptor Lake)
   fuehren — *"Ich habe `/sys/bus/event_source/devices/cpu/events/` nicht aufgelistet."*
6. Die Wache faengt den Fehlzustand nicht: `pmc_seam_ok = available || counters_all_zero` ist bei
   `available=1` erfuellt.
7. **`branch_misses` ist ein Schema-Bruch gegen den Alt-Korpus:** 173 Spalten ohne
   `pmc_branch_misses`; ein neuer Lauf hat >= 174 ⇒ *"der Vergleich alt/neu muss projizieren."*
8. Der Thesis-Text haengt daran und ist an vier Stellen falsch; *"die dritte, reale Klasse fehlt —
   verdrahtet, aber ohne Zaehler-Mapping"*; dazu R-T3: *"Spalte heisst `l3`, Counter misst last
   level."*
9. Die Rechtelage der Runner ist Bericht vom 25.06./08.07., **heute nicht nachgemessen**.

**(e) Fehlanzeigen.** Keine Owner-Aussage zum Anhangs-Umfang (gezielt gesucht,
`wf_d023e824-238` / `a1c685e676573d0ee`). Keine Ursache fuer die stumme L3-Spalte. IPC/CPI
ungeklaert (`mark_source_unavailable`, weil der POD keine instructions/cycles fuehrt); ob IPC im
heutigen M-3-Scope liegt: **unklar**. Ob "Last-Level == L3" auf prod1/prod2 gilt:
widerspruechlich, die vorsichtigere Fassung nennt die Probe (`lscpu`-Einzeiler im `pmc`-Job).

---

### 2.4 M-5 — Pruefdock / `IPruefDock::measure()` im Produktionspfad

**(a) Vorarbeit.**
- **Hauptfund:** `wf_514dab7d-8a0` / `a7fc207bcb25ee4cb` (~39,5 kB), A-2: *"Der Pruef-Dock ist aus
  dem Mess-Weg herausgefallen. Plan: V5 §5 `:205-206` 'import → Gate → `select_for` → je
  Lastprofil measure → unload' ... Ist: `cache_engine_builder_iterator.hpp:2394` umgeht Registry,
  `accepts()`, `dock_genus()` und `measure()` vollstaendig ... Folge: Container-/Set-/Sequence-/
  Adapter-/View-Docks (**4 Dateien, 545 Zeilen**) sind produktiv unerreichbar."* Mit S0–S5.
- `wf_514dab7d-8a0` / `a669786e3f854007d` liefert die Plan-/Definitionsseite: kanonische
  Code-Definition (`pruef_dock.hpp:2-8`), *"IPruefDock ist KEINE ABI-Grenze"* (`:10-14`),
  bindender Mess-Vertrag *"import → GATE → messen"* (`:74-79`), Ist-Belegung (5 Docks, Registry,
  Sequencer, `pruef_dock_version.hpp`), W3-Testate (`mess_interface_testate.hpp`, 39.412 B, 7
  mess-gegatete Sub-Interfaces, **alle Tier-seitig**).
  **Falle:** *"'Pruef-Dock' ist im Baum DOPPELT belegt"* — `measurement/simd_build_gate.hpp:1-13`
  nennt sich ebenfalls so und ist **nicht** `IPruefDock`.
- `wf_514dab7d-8a0` / `ad4d5f57cd9699a9c` liefert die Dock-Richtungen: LEDGER:517 *"Experiment-Dock
  (Planer↔CEB) = EINDIMENSIONAL; Pruef-Dock (CEB↔Tier-Binary) = **BIDIREKTIONAL**"*.
- Owner-Zitat D-70 (`wf_18a419ce-aad` / `af13ce811ff3cf21c`, LEDGER:4190): *"die Mess-Achsen geben
  auch CEB Mess-design frei und die CEB setzt das bei compile durch ... und **sich selbst in der
  Konfiguration des Pruefdocks**."*
- `wf_b242700f-3a0` / `ae007fa589f7024e5`, A-5: *"`mess_interface_testate.hpp` (W3-KERN 05.08.,
  Owner-GO R3) ist der bereits gebaute Landeplatz."*

**(b) Widersprueche.** W-06 (Datenwirkung), W-10 (Audit bereits gefahren), W-17 (M-5 = M-13),
W-22 (Basis-Drift). Dazu:
- **Wieviele produktive Aufrufer hat `measure()`?** `a669786e3f854007d` §6: *"produktiv **nur von
  `apps/f15_compare/main.cpp:234`**"*. `a7fc207bcb25ee4cb` §2.6 zaehlt dort **0** und stuft die
  f15-Fundstelle bei `select_for` als **Kommentar** ein. **Vor dem Bau am Objekt aufloesen**,
  sonst wird f15_compare entweder ungeplant mit umgebaut oder uebersehen.
- **"Experiment-Dock vs. Pruef-Dock" unterstellt zwei existierende Docks.** `IExperimentDock`
  existiert im Baum nicht (`a669786e3f854007d`, BAUPLAN:18); `wf_732cebce-c68` /
  `a43fcd1894f5d2111`: *"`grep` nach `add_library(...SHARED...)` fuer eine CEB-Bibliothek liefert
  NICHTS; CEB und Planer laufen heute in-process ... **Nur die Tier-Binary-Grenze ist real
  `dlopen`-basiert.**"*
- **Der vierte Observer-Layer "spaeter" hat einen Preis:** G-6: *"Jede spaetere Nachruestung ist
  ein Wire-/ABI-Ereignis (POD-Erweiterung ⇒ `sizeof != 1344` ⇒ ABI-Major 8→9 ⇒ **alle**
  Permutations-DLLs neu)."* Der Audit buendelt ihn deshalb mit S3.

**(c) Erledigt.**
- Der Audit selbst (siehe W-10).
- **W3-Pruefdock-Testate gebaut UND gruen gelandet:** `wf_996f7155-d3c` / `a5c7d2dfd4b860aa9`:
  *"`#340 test_w3_mess_interface_testate_dock Passed`, `#341 ..._biss Passed` (lauf1 und lauf2
  identisch)"*, Basis 405 + 3 = 408.
- Die 5 Docks + Registry + Sequencer + Versionierungs-Header existieren — **Wiederanbindung, kein
  Neubau**.
- Fixtures existieren: `test_e24_c10_genus_dll_roundtrip.cpp`, `genus_module_set_defekt.cpp`,
  `test_v5_two_phase_driver.cpp`.
- `test_experiment_dock_payload` existierte, lief aber nie (*"neun kommen in der gesamten
  `.gitlab-ci.yml` null Mal vor ... ihre Assertions liefen nie"*); geheilt per R4 am 06.08.,
  Nachweis gruen in `wf_728af669-2f7` / `ae3ba30475a1c7561`.

**(d) Offene Vorbedingungen.**
1. **Der Pruefstand VOR der Messung ist Owner-Gesetz und nicht gebaut** (§68b, LEDGER:3319:
   *"direkt am PRUEFDOCK ueber den Aufruf von GOOGLE-TESTS als PRUEFSTAND ... erst Build+Pruef-Batch,
   nach Durchlauf erst die Messung"*). Ist: `pruef_only.hpp:29-40` faehrt ausschliesslich
   `run_conformance_gate` gegen `std::map` — keine Mess-Interface-Testate, keine Google-Tests,
   kein PMC. M-5 nennt nur `measure()`, nicht den Pruefstand-Zweig (S1.2).
2. **Tooling-Konsistenz CEB↔Tier fehlt am Dock** (S2.3): *"CEB `[all]` gegen Tier `[wallclock]` ⇒
   harter Reject. Heute laeuft diese Kombination stumm durch."*
3. **Zwei Aufraeumpass-Posten am Dock stehen auf "NACH Abgabe" und kollidieren:** Posten 33
   (SetDock/SetPruefDock-Doppelschicht) und **Posten 35 (SA-Dock ohne `dock_version()`-Member)**
   — genau die Gattung, die M-5 in den Produktionspfad zieht, traegt keine Dock-Version, obwohl
   `pruef_dock_version.hpp:11-16` sagt: *"aendert sich sein Antriebs-/Gate-/Serialisierungs-
   Verhalten, aendert sich die Bedeutung der erzeugten Mess-Zeilen."*
4. **Capability-Bit fehlt** (A-9) ⇒ S1.4, mit S3 zu buendeln, nicht mit S1.
5. **Reihenfolge:** *"S0/S1 sind ABI-neutral und terminkritisch"*; S0 = PMC-Ehrlichkeit, also
   heute in Arbeit. Und: *"Rebuild nach S0 ... Fingerprints bewegen sich nicht ⇒ und genau
   deshalb ist **S4 Pflicht**, sonst mischen sich Vor-/Nach-PMC-Zeilen unter einer Identitaet."*
6. **F6 (Vormittagsrunde) offen** — betrifft S2, und ueber Owner-D-70 mittelbar auch M-5.
7. **Re-Anker-Pass** vor jedem Zeilen-Eingriff (Anker aus `47c4ef1d` / `b241a272`).

**(e) Fehlanzeigen.** Kein Vollzugsvermerk zu S1.1 in irgendeinem der 121 Berichte. Keine
Kosten-/Laufzeitmessung des Umbaus. Kein Hybrid (*"es gibt keinen Hybrid"*). **Kein Testat prueft
die CEB-Seite:** *"`grep -ric "pmc" libs/cache_engine/builder/pruef_dock/*.hpp` → 16 Dateien,
JEDE 0."* Ob `IPruefDock::measure()` in heutiger Signatur den PMC-/Zwei-Phasen-Weg tragen kann,
beantwortet kein Bericht — **unklar**.

---

### 2.5 M-6 — XML-Trennung Bau / Messung

**(a) Vorarbeit.** Der Bauplan existiert konkreter als der heutige Auftrag:
`wf_ebe2aced-d4b` / `aa8ceff625589ccd4`, Posten **B-2**: Ort `xml_config_parser.{hpp,cpp}` +
`profile_run_entry.hpp` + Traeger `all_axes_golden.profile.xml`; `ThesisProfile` bekommt
`measure_axes` + `measure_options`, *"Abwesend = leer = Mess-Menge == Bau-Menge = byte-identisch
zum Ist"*; `run_profile` baut zwei Views (`basis_view` / `mess_view`); **harte Teilmengen-Wache
fail-closed**; Emitter `experiment_plan_director.hpp:1366-1369` liest die Mess-Menge statt
`0:${COMDARE_GN_TOTAL}`; drei Tests, darunter Golden-Neutralitaet (byte-identische Emission ohne
`measure_axes`) und Biss-Beweis (Wert ausserhalb `permute_axes` ⇒ Exit != 0).

Ist-Befund Parser: *"`ThesisProfile` fuehrt EINE Selektion ... Suche nach
`provision_only|golden_range|pruef_only` ueber `libs/common/serialization/` und beide XSD: **0
Treffer**."*

Wo die Trennung heute lebt (Tabelle 3.3): `COMDARE_GOLDEN_N_PROVISION_ONLY` /
`COMDARE_GOLDEN_N_RANGE` als Env; Bau = 4096er-Scheiben hart im Emitter (`:1238-1256`), Mess =
volles Fenster hart (`:1366-1369`). *"die einzige Stelle, an der heute 'gebaut != gemessen'
ausdrueckbar ist, ist ein hartkodierter String-Unterschied in zwei C++-Emitter-Funktionen — nicht
die XML, die der Owner als Bauanleitung fuehrt."*

Zwei unabhaengige Bestaetigungen: `a95076f256a0944d3` D-3 (*"FEHLENDE FAEHIGKEIT — der Owner-Satz
beschreibt einen Neubau, keine bestehende Naht"*) und `a6847e8d9e5bcb322` D-4 (*"Getrennt sind
heute nur die JOBS"*).

**Der zweite, schwerere Befund** (`aa811c70b24c62177`, ausdruecklich *"von mir gefunden, in keinem
der fuenf Scopes"*): **die Mess-Seite ist nicht in 4096er-Scheiben geteilt** — `:1367-1369`
verbatim *"Mess-Fenster = das VOLLE [0:COMDARE_GN_TOTAL) der Zelle ... Einmal je Batch."* Der
zugehoerige Bauposten B-3 verlangt **eine gemeinsame Emitter-Funktion**, nicht zwei Kopien
(sonst driftet das Korn, an dem der Plan-Stempel haengt).

**(b) Widersprueche.** W-08 (falsches Schema), W-04 (Teilmenge ist offene Owner-Frage). Dazu:
- **Der Elementname ist nicht gesetzt:** `aa811c70b24c62177` schreibt `<measure_selection>`,
  `aa8ceff625589ccd4` schlaegt begruendet `<measure_axes>` + `<measure_options cap="320"/>` vor —
  *"Vokabular zeichengleich zu `permute_axes`, damit EINE Lese-Naht bleibt"*. Kein Bericht
  entscheidet.
- **4096er-Mess-Scheibung reicht nicht, um die Mess-Menge zu begrenzen:** *"Das Fenster wirkt NUR
  im Basis-Pass (`profile_run_entry.hpp:761`). Die 17 `<axis_sweep>`-Paesse laufen in jedem der
  32 Scheiben-Aufrufe je Perm ungefenstert voll durch ... im Mess-Batch ~78 zusaetzlich gemessene
  Zellen je Perm-Aufruf."*
- **`<measurement_tooling>` ist kein Bau/Mess-Trennkanal** (`ad4d5f57cd9699a9c`, D-7: *"in
  `validate_profile.hpp:497/1285` selbst als 'nur geparst+getragen' markiert"*), sondern
  bau-wirksam (Define an allen vier CEB-Compile-Stellen) ⇒ gehoert in die Fingerprint-Diskussion.

**(c) Erledigt.**
- `<measure_selection>` / `<measure_axes>`: **nichts gebaut.** Repo-weite Suche ueber alle 121
  Berichte trifft ausschliesslich die beiden Planungs-Berichte.
- **Korn-Divergenz (Voraussetzung der Mess-Scheibung) ist teil-geheilt.** Erstmeldung
  `wf_fb6c8801-be1` / `a93988d7b685098ce` (`iterator:2340` hart vs. `:1109` parametrisch);
  Heilung `wf_d7a17fc9-ead` / `a3d66ccc3aec5fe08`: *"`LazyRunConfig::batch_plan_korn` +
  `plan_slice_korn(cfg)` als DIE Quelle beider Wege ... **kBuildSliceGrain hat nur noch EINE
  Stelle**"*, mit Alt-Stand-Biss. **Aber: in `/home/comdare/wt-b2-neuanker`, Branch
  `b2-neuanker-format3`, HEAD `a9a352bb`, "NICHT gepusht", Format-Bump `batchplan-v2 -> v3`,
  clang-format-Gate steht aus.** Widerspricht teilweise M-4 (`aa811c70b24c62177`: vier entkoppelte
  4096-Literale, **0 Treffer** fuer ein koppelndes `static_assert`) — beide lasen verschiedene
  Staende.
- Die **Bau**-Seite der 4096er-Scheibung existiert (`kGnBatchSlice = 4096`,
  `experiment_plan_director.hpp:610`, *"HARTE inline-Konstante mit BEWUSST KEINEM
  Env-Override"*). Nur die Mess-Seite fehlt.

**(d) Offene Vorbedingungen.**
1. **M-6 darf laut Vorarbeit nicht als eigene Welle laufen.** M-6 = B-D + B-E; K-1: B-C/B-E/B-F
   schreiben alle `experiment_plan_director.hpp`; K-3: B-D und B-F beide `profile_run_entry.hpp`.
   Empfohlene Form: *"L-1 ce-BUENDEL 'MESS-ANLAGE' = B-B + B-C + B-D + B-E + B-F + B-G — EIN
   Branch, EIN Voll-Gate, EIN Dual-Review, EINE Landung, EIN Bump 3->4."*
2. **Kollision mit F5 / `wt-b14-golden`:** ein additiver XSD-Entwurf fuer `organ_subaxes` liegt
   bereits im blockierten `wt-b14`-Worktree (+ca.100 Z.), und F5 plant `xml_config_parser.{hpp,cpp}`
   + `axis_path_serialization.hpp`. Wer M-6 dort baut, kollidiert.
3. **Die Wache muss mitgezogen werden:** `Code/tests/golden_n_consistency_check.cmake` um
   `measure_axes` erweitern, *"sonst faellt genau der neue Block aus der Deckung — mit demselben
   Ergebnis wie beim ungeparsten `organ_subaxes`."*
4. **Der Mess-Batch findet die gebauten Binaries lokal gar nicht** (B-4): Bau-Baum
   `Code/gn_out/...` vs. Mess-Baum `Code/measure_out/...`; Bruecke ist nur der Lager-Pull.
   *"Ohne Lager baut der Mess-Batch die 131.072 je Perm neu"*, und der Emitter-Kommentar
   `:1440-1442` (*"der Mess-Batch findet sie vor"*) ist **heute falsch**. Eine Mess-Scheibung ohne
   B-4 scheibt Neubauten, nicht Messungen.
5. **Ungeprueft:** ob `validate_profile` ein `measure_axes` strukturell ablehnen wuerde.
6. **Die Zahl fehlt:** Owner hat das Mittel benannt, nicht die Mess-Menge. Zwei Rechenwege
   weichen voneinander ab (71,7 d Vollmenge auf 2 Lanes bei 40 verfuegbaren Tagen vs. ~266 h =
   11,1 d je Perm fuer den heute emittierten Mess-Batch).
7. **Korn nicht je Phase verschieden** (R-6): beide Phasen auf 4096, kleineres Mess-Korn erst mit
   fail-loud-Wache gegen abweichendes Bau-Korn.
8. **`cap` traegt bereits zwei Semantiken**; `measure_options cap` waere die dritte. Zusatz aus
   dem Codex-Review des B14-XSD: `run_options` schema-gueltig aber vom Parser ignoriert; XSD
   erlaubt `xs:unsignedInt`, Parser-`cap` ist `int`.

**(e) Fehlanzeigen.** Kein Bericht nennt einen Schema-Ort im `comdare_thesis_profile`-Dialekt
(er hat kein XSD). Kein Bericht untersucht die Emission des Mess-Batch-Testats am Objekt. Kein
Bericht prueft, ob `all_axes_golden.profile.xml` einen Kandidaten fuer eine sinnvolle
Mess-Teilmenge enthaelt (die 320er-Analyse betrifft `m3v2_study.profile.xml`). Keine Aussage zum
`<working_set_sweep>`-Kollaps und zur Interaktion mit `--validate`/Trockenlauf.

---

### 2.6 G-E3 und Lager-Basis-Tests

**(a) Vorarbeit.**
- **G-E3, am Objekt gemessen:** `wf_89ef6075-d52` / `af7c11bdc4317f6b3`: der produktive
  **Schreiber** existiert seit `dcbaa728` (03.08., `messwert_registrierung.hpp`, verdrahtet in
  `cache_engine_builder_iterator.hpp:1667-1669/1871/2565-2571`) — *"**Aber:** `grep -rn
  "mess_bestand_key_of\s*=\|mess_bestand_doc_key\s*=\|mess_bestand_versions\s*="` liefert **0
  Treffer** ... Zum Vergleich das Genus-1-Pendant `bestand_key_of` ist ueber
  `profile_run_facade.cpp:723` → `profile_run_entry.hpp:650` bis zum Aufrufer durchgereicht.
  **Die Asymmetrie ist am Objekt bestaetigt, nicht vermutet.** ... weiterhin real offen — der
  Schreiber ist tot code, weil das Opt-in-Feld nie gefuellt wird."*
  **Das ist die vollstaendige Kette, die der Host-Binder nachbauen muss.**
- Ursprungsbuchung Ledger Z.3790 (04.08.): *"G-E3-Host-Binder fehlt (3 Iterator-cfg-Felder
  `mess_bestand_*` mit 0 Konsumenten — eigenes Fenster)."*
- Ein Test existiert: `test_ge3_messwert_genus_und_ziel.cpp:9` (OE-B), aber mit `FakeStore`
  (In-Memory), keine echten Textdateien.
- **Lager-Basis-Tests:** Delta-Analyse vor dem Bau (`wf_84d76563-de5` / `a68ad892fddac5c5c`:
  *"Drei Bausteine existieren, aber kein einziger vereint 'echtes Dateisystem' +
  'Stempel-Zeilen zurueckgelesen und einzeln ausgewertet'"*); Plan `ab565ced2dfa81182`
  (`docs/plaene/20260806-PLAN-lb6-stufe1-oeb-baumform.md`, 521 Z.) mit Neubefund zur Fixture-Wurzel
  (`fs::remove_all(basis)` unter `temp_directory_path()`; `comdare_test_tmp.hpp` von 39 TUs
  genutzt, 12 nicht, darunter `test_lb0`/`test_lb1`); Bau-Bericht `wf_701941f6-2c9` /
  `a6af7e4a8f0697ad0` mit Gate-Ausgaben und Mutations-Bissen an Produktionscode.
- Stufe 2 ist bereits ausformuliert: Vorlage `tests/unit/genus_buildvariant_avx2.cpp` (30 Z.,
  echte SHARED-Lib); dreiteiliger Biss in `outputs/a9a2b597006efcd8c.output` (neue Quelle
  `version_stamp_stub_module.cpp`, `dlopen`+`dlsym` auf `comdare_anatomy_version_lines`,
  Vergleich gegen `lazy_adhoc_fingerprint_for`, plus Leerheits-Beweis
  `dlsym(handle, "comdare_create_anatomy") == nullptr`). **STOPP-Klausel:**
  *"`tests/unit/CMakeLists.txt` ist Kollisionsgebiet — Ein-Schreiber-Regel."*

**(b) Widersprueche.** W-11 (Key-Factory existiert / Provider-Ziel unbenannt), W-12 (viertes
Gate). Dazu:
- **LB-6 ist mit Stufe 1 NICHT erfuellt, und die Herabstufung ist offen.** `wf_84d76563-de5` /
  `ab565ced2dfa81182`: *"LB-6 nennt vier Gegenstaende; Stufe 1 deckt den ersten und die Haelfte
  des vierten. Beweis 1 ist per OE-A ausdruecklich 'PFLICHT zu konstruieren' ... Beweis 4
  verlangt echtes minio ... **+ eine deklarierte Herabstufung von Beweis 1, Beweis 4 und der
  echten Nebenlaeufigkeit im Ledger UND in der VOR-TRIGGER-CHECKLISTE**. Ohne den dritten Punkt
  wird 'Stufe 1 fertig' beim naechsten Lesen zu 'LB-6 fertig'."* Der Landungsbericht meldet die
  Landung, **nennt die Herabstufung nicht als vollzogen** und fuehrt B-U weiter.
- **Die Rueckstellungsbegruendung "Kollision mit M-1" ist zu eng:** K-5 sagt *"B-T strikt NACH dem
  ce-Buendel"* (Buendel = B-B..B-G), und `wf_89ef6075-d52` / `af7c11bdc4317f6b3`: *"G-E3, P2-P8,
  B14/KF-6, E8-PMC und Ebene-B-Push beruehren alle `cache_engine_builder_iterator.hpp` bzw.
  `experiment_plan_director.hpp` ... **kein Paar davon ist automatisch dateidisjunkt**."*
- **"0 Konsumenten = tot" ist eine geruegte Fehlerklasse:** LEDGER Z.555 (zitiert in
  `wf_e89471ed-48e` / `ac796f5e5aa046934`): *"'0 Konsumenten' ist bei Pflicht-Features
  'unverdrahtet/unfertig', nicht 'tot'"* — *"der Rueckfall ist trotzdem erneut eingetreten."*
- **K-01 "totes Holz" ist widerlegt** (`wf_216c6dbe-b55` / `af80391241cbab43a`, Ledger
  nachmittag-8 C; literal gegengeprueft von `ab077c917752b767e`): der Plan-Director reicht
  `COMDARE_BESTANDSLOG` per `append_forward_var_literal` durch (`:952-955`, Test `:845-860`).

**(c) Erledigt.**
- **LB Stufe 1 gebaut und gelandet** (`3558466d`, 3 Commits, 5 Dateien, +506/-37; gemerged als
  `b241a272`, auf beiden Remotes).
- Stufe 1 umfasst mehr als angenommen: auch echte 2-Thread-FS-Konkurrenz, mit gemessener
  Race-Statistik *"In 79 von 200 Laeufen waren mehr als ein Thread zugleich drin, bis zu 3 von
  4"* — der Agent hat **bewusst keine** wechselseitige Ausschluss-Zusicherung assertiert.
  **Diese Entscheidung nicht versehentlich rueckgaengig machen.**
- Der Mess-Genus-Schreiber ist gebaut und gelandet ⇒ G-E3 ist **reine Host-Verdrahtung**.
- Die Key-Policy existiert (W-11), ein Fake-basierter Test existiert.
- Der Bauplan fuer Stufe 2 existiert vollstaendig — nicht neu erarbeiten.

**(d) Offene Vorbedingungen.**
1. **Bestandslog ist Opt-in mit Default AUS** (`profile_run_entry.hpp:435`); beide Aktiv-Gates
   ohne Fingerprint-Bedingung. O-C ist laut `a6847e8d9e5bcb322` beantwortet ("aktiv") ⇒ i-5 + i-6
   werden Pflicht, **beide** Gates muessen gefasst werden. Ohne diesen Entscheid ist ein perfekter
   Host-Binder wirkungslos.
2. **Zeitfenster:** *"Leitplanke 4 sagt 'VOR Messbeginn Pflicht'; wenn die Messung laeuft, ist es
   zu spaet — das Lager nimmt die Daten auf."* xlsx am Objekt: **eine** Erwaehnung, ein Kommentar,
   **kein Writer gebaut**.
3. **LB-0..LB-6 sind im 14-Tage-Register nicht verbucht:** `LB-[0-9]` Ledger 8 / Register 0;
   `OE-B` Ledger 3 / Register 0 — *"Die 8 Ledger-Treffer sind nicht die Buchung des
   Paketschnitts, sondern die Buchung seines Fehlens."*
4. **Kein `test_lb2`/`test_lb3`** — die Beweislage reicht nur bis LB-1.
5. **Stufe 2 haengt an F7/Option b** (Owner-KERN): *"der Stub ist genau die Binary, die NUR dieses
   Interface traegt — Interface-Bau und Stub-Test gehoeren in dieselbe Planung."* Termin-Basis der
   Vertagung war der 08.08. und ist gegen den 15.09. neu zu bewerten.
6. **Vier Owner-Entscheide vor Stufe 2** (`outputs/a9a2b597006efcd8c.output`): jetzt gegen
   `comdare_anatomy_version_lines()` oder auf S1/S3 warten? Erkennungs-Richtung der Factory
   (Writer vs. Reader, eine oder zwei)? `libxlsxwriter` kann nicht lesen — eigener ZIP/XML-Leser
   oder zweiter Vendor? Eigenes Dossier fuer die Welle (heute existiert **kein** Plandokument;
   *"Die Owner-Formel 'Ich erwarte laut Plan' verweist auf ein Dokument, das nicht existiert"* —
   7 Zeilen in 1 von 1096 super-`docs/*.md`, 0 von 153 ce-`docs/*.md`).
7. **Dauer-Auflage:** *"Kosten-Klammern um Stempel-Bildung sind gegen die Testwelle zu pruefen,
   BEVOR sie eingebaut werden."*
8. **Zu verifizieren:** ob der super-Gitlink-Nachzug (super baute eine ce ohne LB-6) tatsaechlich
   vollzogen ist — die Task-Liste behauptet es, ungeprueft.

**(e) Fehlanzeigen.** `make_messwert_key_fn` 0 Treffer, `messwert_key_hex` 0 Treffer,
"Lager-Genus" als Begriff 0 Treffer (der Sachverhalt heisst `MesswertKeyPolicy` / "die ZWEI
Genera"). **LB-4 und LB-5 haben in keinem der 121 Berichte einen inhaltlichen Befund** (LB-5 kommt
in genau einem Bericht ueberhaupt vor). Der xlsx-Legenden-Sheet-**Leser** ist *"nirgends geplant
und nirgends gebaut"*. Wogegen ein Mess-Genus-Key-Provider lesen soll: unbenannt. Ob
`cfg.mess_bestand_fingerprint_fn` existiert: unklar.

---

### 2.7 Messbeginn und erstes 4096er-Batch

**(a) Vorarbeit.** Vier tragende Berichte, alle in `wf_ebe2aced-d4b` bzw. `wf_24104303-f97`:
`aa8ceff625589ccd4` (SCOPE 1: Einheit = Binary, 524.288, keine Kappung, GN_TOTAL je Perm,
Slice-Zeiten aus Pipeline 12690, ETA 34,4 h, 128 Scheiben, Mess-ETA 7,3 s/Zelle, 16/320-Sonde),
`aa811c70b24c62177` (Mess-ETA aus echtem CSV: 216 Mess-Faecher je Binary, Mittel 109,4 ms,
Spanne 6,5..448,4 ms; vier Wege A/B/C/D, Empfehlung C ~3,1 d; **L-3 ERSTER 4096er-BATCH** als
eigene Station), `a6847e8d9e5bcb322` (SCHEIBE 0 mit Rezept 0.1–0.6), `aff70699b2fc8788c`
(R-T1 "Drei Quellen, drei Bau-Mengen — und die Kappung wird nicht gelesen"; T-0 als hoechster
Vor-Trigger-Posten).

Herkunft des Postens: `wf_33deb4c4-2ad` / `ae7366a54872e7adf`: *"eine **Kalibrier-Stichprobe** (ca.
200 Binaries im Trigger-Modus, Zeit stoppen, hochrechnen) — Kosten Minuten. Die Owner-Doktrin
deckt das Rutschen des Triggers; sie deckt nicht einen Trigger, dessen Laufzeit man nicht kennt."*
Buchungsstand: **0/0** in Ledger und Register (`wf_7a560997-167` / `a2be55b663e992396`).

Runner-Basis: `Cluster/scripts/runner-mode.sh` (`0d7c577`) `HEAVY_J=24` (prod1) /
`HEAVY_J=$(nproc)` (prod2) — HEAVY entspricht bereits OD-7; die 24W-Hochrechnung steht damit auf
tragfaehigem Runner-Ist, **nur der Live-Host-Check fehlt**.

**(b) Widersprueche.** W-13 (drei der vier Groessen sind gemessen). Dazu:
- **Vierte Zahl:** `aa811c70b24c62177` fuehrt zusaetzlich **1.572.864** (V7.4-Doktrin, 12
  System-Perms) und empfiehlt, bei 4 Perms zu bleiben; der Owner-Entscheid vom 26.07. (D-34,
  *"opt-Stufen O0-O3 Voll-Bau; AVX512 gehoert mit (12 System-Perms)"*) ist **in keinem Bericht
  aufgeloest**.
- **Slice 4096 ist keine waehlbare Groesse:** vier entkoppelte Definitionen, **0 Treffer** fuer
  ein koppelndes `static_assert`, drei Kommentare als *"Zusicherung im Prosatext statt einer
  Wache"*. Und die Owner-Vorgabe "maximal 4096" ist nur auf der Bau-Seite umgesetzt.
- **Offene Rechenluecke (Ableitung des Abgleichs, kein Berichtsbefund):** Scope 3 schreibt
  *"`COMDARE_GN_TOTAL=4096` liefert morgen exakt das erste Batch"*, Scope 1 sagt, das Fenster
  gelte je Perm ⇒ auf einer Lane mit 2 Perms zwei Scheiben, ueber 4 Perms 16.384 Binaries.
  **Kein Bericht rechnet das aus.** Mit dem Trockenlauf B-1/T-0(a) in Minuten zu klaeren.
- **"VERWERFBAR, weil er den alten Fingerprint traegt"** findet sich in keinem Bericht. Die
  Berichte behandeln den ersten Batch als **Lieferung** (*"ein gemessenes 4096er-Batch mit realen
  PMC-Zahlen, die gezaehlte Gesamtmenge, die Laufzeit-Hochrechnung"*) und als **Messinstrument**
  fuer V-06-Rest (t/TU und Bytes/DLL). Ein verworfener Batch liefert V-06 trotzdem; er kollidiert
  aber mit der PMC-Lieferzusage.

**(c) Erledigt.** Zeitmessung je Slice, Frage global-vs-je-Perm, cap-Frage, Voll-Bau- und
Mess-Hochrechnung liegen vor (W-13). Zwei Drittel von O-A sind entschieden (§41, LEDGER:2411,
Owner 19.07.: *"Wir bauen alles new golden und messen alles mit der 320er"*). Der Batch-Plan-/
Resume-Blocker, der ein vollstaendig resumiertes 4096er-Fenster rot gemacht haette, ist geheilt
(`wf_e5857a4b-aed` / `aade6dd7ea869c022` Befund; Heilung `wf_15269bed-b2c` / `a4ccc540110e1cf79`,
HEAD `41091cb4`) — **Grenze:** *"der Teil-Resume ist auf Iterator-Ebene bewiesen, nicht auf
Fassaden-Ebene."*

**(d) Offene Vorbedingungen.**
1. **Ohne `COMDARE_BESTANDSLOG=true` traegt der Batch gar keinen Fingerprint**, nicht "den alten"
   — der Provider liefert sonst `FingerprintFn{}`, `dll_is_current` faellt fail-closed, *"jeder
   produktive Lauf ohne `COMDARE_BESTANDSLOG=true` baut jede Binary neu"*. Zusatz F-9:
   `bestandslog_active` prueft `bestand_fingerprint_fn` **nicht** — fail-closed nachzuziehen, in
   derselben Welle wie die Provider-Scharfschaltung.
2. **Ein Mess-Anteil findet die Binaries nicht** (verschiedene Baeume, Bruecke nur der
   Lager-Pull).
3. **Mess-Batch ungeschnitten** — bei `GN_TOTAL=4096` harmlos, beim Voll-Lauf ~266 h je Perm.
4. **17 Sweep-Paesse laufen je Scheibe ungefenstert** — und der Fingerprint-Skip, auf den sich
   "billig" stuetzt, ist ohne Provider tot.
5. **Die PMC-Zusage der Scheibe-0-Lieferung ist nicht erfuellbar**, solange die PMC-Welle nicht
   gelandet ist (`grep -c COMDARE_ENABLE_PMC` = 0 am Stand `e7aa1244`).
6. **Das Fingerprint-Fenster schliesst mit der ersten geschriebenen `.fingerprint`-Datei**, nicht
   mit dem ersten Batch. Ein als verwerfbar deklarierter Kalibrier-Batch loest die Klemme nur,
   wenn seine Binaries weder ins Lager gepusht noch als Messgrundlage verwendet werden — **kein
   Bericht sagt das explizit; das ist eine Luecke, keine Deckung.**
7. **T-0(a) Trockenlauf ist noch nicht gelaufen** und ist bindend zuerst: *"B-1 vor allem anderen
   (es ist der einzige Posten ohne Code-Aenderung und liefert die Zahl, auf der B-2..B-5 stehen)."*
8. **Gitlink-Drift:** *"Die super-CI baut sonst eine ce ohne LB-6 ... **Der Batch faehrt aus
   dieser Pipeline.**"*
9. **Statusanzeige koennte bei genau `4096:4096` falsch lesen** (`wf_996f7155-d3c` /
   `a16540fca4b28b4ec`, HOCH: *"Bei `4096:4096` werden typischerweise alle realen Zellen zu
   Fremdfenstern"*) — **Einschraenkung: Review lief vor den T2-A-Landungen, Geltung heute unklar.**
10. **Platz:** df-Stand "OFFEN-UNGEPRUEFT", avg-`.so`-Groesse UNBELEGT — der erste Batch liefert
    sie; die df-Wache ist Vorbedingung der **Fortsetzung**.
11. **Frist 15.09.** (siehe W-20).

**(e) Fehlanzeigen.** Keine tatsaechlich gefahrene Kalibrier-Stichprobe. Keine gemessene
Bytes-je-`.so`-Zahl (*"UNBELEGT und in dieser Rolle nicht belegbar"*). Kein Bericht behandelt
einen Batch als "verwerfbar". Der Konflikt 4 vs. 12 Perms ist unaufgeloest. Ob die
Runner-Kapazitaet 34,4 h ohne Timeout traegt: *"Nicht geprueft."* Ob 7,3 s/Mess-Zelle bei 2^17
haelt: *"UNBELEGT."*

---

### 2.8 Thesis und Abgabe

**(a) Vorarbeit.**
- **Gate 8 selbst:** `wf_c974dbd3-351` / `a09efecaf80db1e64` — `8970465d`, nur
  `anhang/{de,en}/A_measurements.tex`, +199/-2, 23 neue Namen je Sprache; Probe `de: RC=0, 202
  pages, 919275 bytes` / `en: RC=0, 192 pages, 885362 bytes`.
- **Thesis-Bau komplett gefahren:** `wf_4f06e488-670` / `afff42bd0404da387` — `RC_DE=0/RC_EN=0`,
  Gate 2 `LaTeX Warning` = 0, Gate 3 `.blg` = 0, DE `alphadin.bst`, EN `alpha.bst`, 180
  `\bibitem` aus 182 `@`-Eintraegen; Byte-Groessen und Seitenzahlen identisch mit den fuer
  CI 15032/15033 protokollierten Werten. **`pwsh` fehlt lokal** ⇒ `build.ps1`-Weg nicht fahrbar.
  Zaehlung: *"Von diesen 28 existiert 0 als Datei — je Sprache, beide identisch"*; 11 mit
  sichtbarem Kursiv-Ersatztext, **17 voellig stumm (`{}{}`)** — *"Sie sind im PDF nicht als
  fehlend erkennbar."* Umgekehrte Falle genau 1x (`axis_inventory.tex`). DE/EN-Paritaet:
  *"vollstaendig deckungsgleich."*
- **Anhang A fuellbar:** siehe W-14.
- **Zwei Mounts:** siehe W-15.

**(b) Widersprueche.** W-14, W-15. Dazu:
- **Drift-Richtung hat sich am selben Abend umgedreht:** `af80391241cbab43a` (~18:34) misst
  rueckwaerts, `aa1f413636c35eb1b` und `a6847e8d9e5bcb322` messen spaeter vorwaerts. **Richtung je
  Gitlink neu messen (`git merge-base --is-ancestor`), nie uebernehmen.**
- **"Gate 8 nicht gelandet" ist widerlegt:** `ab077c917752b767e`: *"Thesis-Repo `origin/main` und
  `origin/development` = `8970465d`. Gate 8 ist gelandet."* Gefehlt hat der **super-Gitlink**.
- **Die Register-Begruendung "Anhang A ist gefuellt und kompiliert" ist seit Gate 8 halb falsch**
  (8 von 36 moeglichen Abbildungen; Datei 137 → 237 Zeilen, Zuwachs unbefuellt).
- **Die Limitierungszeile ist heute schon widerlegt:** Korpus fuehrt `pmc_available=1` mit realen
  L1/dTLB-Werten; `le_limitierung.tex:2` behauptet zudem 4 variierende Achsen, gemessen sind es
  drei. **Gegen-Behauptung im selben Bestand:** `a1a2b9a86da2d064f` nennt dieselbe Zeile *"korrekt
  fuer den aktuellen (Flag-aus) Smoke-Lauf"*; `aff70699b2fc8788c` widerspricht wiederum dem
  Ledger. **Drei Berichte, drei PMC-Staende — wer die PMC-Textstellen anfasst, muss selbst
  nachmessen.**

**(c) Erledigt.** Die 23 Eintraege (Gate 8, gelandet). **Ersatztexte fuer vier Gruppen sind
bereits geschrieben** (`8e58f691`, DE+EN) — heute ist also der Rest, nicht das Ganze.
`axis_inventory.tex` ist eingebunden (`a6c7598c`) ⇒ drei Posten erledigt, die aeltere Berichte
desselben Tages noch offen fuehren. Die Alt-Kapitel-Markierung ist gebaut, **additiv** (16
Dateien, +74 Zeilen, 0 Loeschungen) — der urspruengliche Verschiebe-Vorschlag wurde
zurueckgezogen. Der super-Gitlink `thesis/diplomarbeit` ist nachgezogen (`72eab9ae`).
**Nicht verifizierbar:** die in der Aufgabenliste genannten SHAs `19e1592` / `123b2f32` kommen im
gesamten Backup **0-mal** vor — sie sind nach dem Backup entstanden; der heutige Auftrag koennte
bereits erfuellt sein.

**(d) Offene Vorbedingungen.**
1. **Die Thesis-Arbeit liegt auf KEINEM Remote:** Branch `b-thesis-ehrlichkeit-anhang` =
   `a6c7598c`, 3 Commits ueber dem Zeiger, **+ 2 dirty Dateien** (`anhang/{de,en}/A_measurements.tex`),
   Remote NEIN. *"Beide sind LEBENDE Baeume (Fremd-Schreiber moeglich); ich habe sie NICHT
   angefasst."* Handlung, Prioritaet 0.1: rescue-Ref auf **beide** Remotes, 15 min, ohne
   Vorbedingung. Ebenso `8e58f691`: *"Auf keinem Remote."* **Die SCOPE-5-Bau-Anweisung Schritt 3
   (`mv` des Arbeitsbaums) wuerde diese Arbeit ohne Sicherung mitnehmen.**
2. **HARTER BLOCKER `chktex`:** `.gitlab-ci.yml:63` des Overleaf-Mounts faehrt `chktex -q -n36
   -n17` **ohne `|| true`**. Gemessen: Baseline 0, Variante A 18, Variante B 55; zweite Messung
   *"EXIT 123, 31 Warnungen ueber 8 Dateien"*. *"Sobald Anhang A committet wird, geht
   `lint:latex` rot ... Heute gruen nur, weil die Dateien nicht im Repo liegen."* **Auch fuer
   einen reinen Ersatztext-Pass relevant** (W18 `„…"` statt `\enquote{}`, W11 `...` statt
   `\ldots`) — `chktex -q -n36 -n17` lokal fahren, bevor gepusht wird.
3. **Gate 8 ist nicht in Overleaf:** `origin/main` (GitLab) = `8970465d`, `github/main` =
   `29a1700d`. *"Die Reparatur `72eab9ae` hat die CI-PDF geheilt, die Overleaf-Sicht nicht."*
   Empfehlung: sofort, unabhaengig von allem anderen. Der Ledger-Satz "Overleaf synct GitHub/main"
   ist zitiert, **die Sync-Mechanik selbst ist unbelegt**.
4. **`.gitmodules` asymmetrisch** (siehe W-15).
5. **Auf `main` moeglicherweise nicht geheilt** — beide Gitlinks dort `29a1700d` (vor Gate 8), und
   alle drei Bridges triggern `main`. *(Task-Liste fuehrt es als geheilt — Stand neu messen.)*
6. **`axis_inventory.tex` entsteht im CI nie** (Generator wird ohne `--*-registry` gerufen) —
   eine **neue** Luecke, entstanden durch die bereits erledigte Anhang-D-Einbindung; stumm
   (`\InputIfFileExists`).
7. **Das vorhandene Generator-Binary ist STALE** (03.08. 15:29 vs. Quellen 06.08. 17:46; `strings`
   0 Treffer auf `lc_surface3d|lc_normbar|ld_sweep`).
8. **O-4 ist offener Owner-Entscheid mit vier gegensaetzlichen Empfehlungen** (Weg 1 / NACH-ABGABE
   / Weg 2 Vollausbau mit Owner-Zitat *"Ja bitte mit in die Abgabe. Aber erst die Messdaten
   beheben"* / vierter Weg "44/44 aus ZWEI deklarierten Korpora" mit Pflicht-Auflage, die Naht im
   Dokument sichtbar zu machen).
9. Kleinere Auflagen: Voll-Korpus-PDF-Gate steht laut Ledger aus; `observer_detail.tex` reisst die
   Breite (12 Overfull hbox a 1563,6 pt; *"skaliert nicht"* bei Voll-Lauf);
   Gruppen-Ersatztext-Granularitaet ist eine **bewusste, begruendete** Entscheidung —
   "28/28 eigene Ersatztexte" waere ihre Umkehrung, *"vertretbar, aber ein Entscheid, kein Fix"*,
   und laut B-4 *"erst nach dem B-2-Messwert entscheidbar — nicht blind aendern."*

**(e) Fehlanzeigen.** Kein Bericht empfiehlt "beide Mounts behalten". Kein Bericht misst `chktex`
ueber ein `A_measurements.tex` **mit** neuen Ersatztexten — fuer den heutigen Pass **unbelegt**.
Niemand hat die Overleaf-Sync-Mechanik gemessen. Kein Zaehl-Gate "Eintrag ohne Datei" existiert
(zweimal vorgeschlagen, nirgends gebaut). Ob der d03-Korpus die Default-Referenz `linear_scan`
fuehrt: **UNBELEGT**. Zur `alphadin`-Frage genau eine Messung, keine Gegenprobe.

---

### 2.9 Sicherheit und CI

**(a) Vorarbeit.** E23-Scrub/Backup-Ref/Runner-Token (`wf_b242700f-3a0` / `ae007fa589f7024e5`,
E-1, mit Wurzel: *"Die Verifikation lief gegen den **Zweig**, nicht gegen alle Refs ... Ein
Scrub-Verify, das nur den Arbeitszweig scannt, sagt nichts ueber Backup-Refs — und Backup-Refs
werden mitgepusht."*; Einordnung *"internes GitLab, Repo privat — kein oeffentliches Leck, aber
seit 02.08. fuer jeden mit Lesezugriff abrufbar"*). Verfahrens-Delta und Empfehlung
(`wf_d023e824-238` / `a1c685e676573d0ee`, O-5): *"Stehen lassen bis nach der Abgabe, dann in ein
lokales Bundle ueberfuehren und die Remote-Ref loeschen."* Der Erst-Explore
(`a9d7004c44011c39b`) ist **teilweise widerlegt**: *"Der Ref ist ein **ueberwachter**, kein
vergessener Zustand."*

ASCII-/Breiten-Wache: Anatomie der kaputten Hand-Pipe und die Klassenregel
(`wf_b242700f-3a0` / `a1ae0111a8ba19b41` SW-4, `aba55729d2bd08221`: *"fehlendes Werkzeug = FATAL
statt stiller Null"*, *"eine Gate-Meldung, die aus einer nackten Null besteht. 'ASCII: 0' ist kein
Beweis."*). Reale Wachen-Laeufe mit literalem Auswurf in `wf_60a89435-167` / `a9704c3e0afa7d32b`,
`wf_701941f6-2c9`, `wf_e18c1d53-77d`.

CI-Abdeckungs-Invariante `dcb2f08f`: Analyse (`wf_728af669-2f7` / `a60d6bdaecdb0f383`, 9 Tests in
keinem Job) und Bau+Biss (`ae3ba30475a1c7561`, `ABDECKUNGS-WACHE: ROT (Exit 1)` →
`407 von 407 GRUEN (Exit 0)`, Jobs 21→22). Klassen-Fassung (`a1ae0111a8ba19b41` SW-2): *"Am 13.07.
hatte ein manueller Audit bereits 21 CI-tote Tests geroutet. In drei Wochen waren neun neue
nachgewachsen. **Ein manueller Fix haelt hier nachweislich nicht.**"*

Doppelschluessel-Wurzelanalyse (SW-1): *"`contract:axis-version-lock` war **18 Tage lang** gar
nicht vorhanden ... YAML-Mappings verwerfen bei doppeltem Schluessel kommentarlos alles ausser der
letzten Definition — letzte nach **Textposition**, nicht nach Commit-Zeit. Die spaetere
Verschaerfung verlor also gegen die fruehere Abschwaechung."* **Was durchkam:** zwei semantische
Drifts an `measurement_curve_loader.hpp` ohne `AXIS_ALGO_VERSION`-Bump (`150b0ede` 26.07.,
`0fdeccff` 02.08.) — *"In einer Arbeit, deren Kernbeitrag Messkurven sind, ist das kein
CI-Problem, sondern ein Ergebnis-Problem."* Unabhaengig von Codex bestaetigt.

Super-Spiegel der Abdeckungs-Invariante: vollstaendige, ohne Rueckfrage ausfuehrbare
Bau-Anweisung in `wf_ebe2aced-d4b` / `a969ce4aadda0858e` (inkl. FROZEN-Block mit 9 namentlichen
Rot-Tests und drei Beweisen).

**(b) Widersprueche.** W-07 (Runner-Token), W-16 (ASCII-Wache spiegeln). Dazu:
- **Doppelschluessel-Lage hat sich am 06.08. zweimal gedreht:** frueh EXIT 1 auf main / EXIT 0 auf
  development; spaeter *"auch `main` ist geheilt, weil main==dev"*. **Offen ist nur noch, ob die
  ueberlebende Definition beisst:** `grep -rEi 'axis.?version.?lock|AXIS_ALGO_VERSION'` ueber die
  Test-Baeume = **0 Treffer** — *"Ohne diesen Test ist ein gruener Job von einem inerten Job
  weiterhin ununterscheidbar."*
- **gitleaks-Submodul-"stille Null" ist dokumentiert, mit Rezept** (`outputs/be52dmp6f.output`:
  *"erster Scan '0 commits scanned' (thesis ist Submodul mit Pointer-`.git`) → Fix: Hauptrepo
  (super) mounten + Submodul-Pfad ⇒ '5 commits scanned, no leaks'"*), plus Dauer-Regel *"IMMER mit
  Repo-`.gitleaks.toml` UND ueber den Push-Inhalt"*. **Abgrenzung:** die verwandte ugrep-Falle ist
  ausdruecklich **NICHT CI-wirksam** (*"Kein CI-Job war betroffen — der Schaden war auf die
  manuelle Agenten-Prozedur begrenzt"*), und ein rueckwirkender Pruefauftrag ueber Gate-Zusagen
  **laeuft bereits** (nicht doppelt starten).
- **`.gitleaks.toml` / A11:** *"`.gitleaks.toml:23-29` traegt den `.ccache/`-Allowlist-Eintrag
  weiterhin, mit eigenem Kommentar 'Dieser Eintrag MUSS hier stehen' ... **Das widerspricht dem
  A11-'Drop'-Plan direkt** — braucht einen Owner-Entscheid."* Buchungsstand 0/0.

**(c) Erledigt.** ASCII-/Breiten-Wache im ce gebaut, gelandet, mit Bissbeweis-Datei
(`scripts/ci_diff_ascii_width_guard.bissbeweis.txt`; Korrektur an einer Zuarbeit: die
Job-Definition liegt in `ce/.gitlab-ci.yml`, nicht `ci/gitlab-ci.yml`). Doppelschluessel geheilt
(`597ecffe` + `557d8023`, zusammengefuehrt auf die **strengere** Wirkung, Drift nachgezogen).
Schluessel-Wache `ci_yaml_key_guard.sh` existiert und ist erster Schritt in `test:coverage-guard`.
Abdeckungs-Invariante gelandet, R4 *"vollstaendig erledigt"*. E23-Scrub der Arbeitslinie vollzogen
— offen ist ausschliesslich der Backup-Ref. **Die Ref-Loeschung ist bereits owner-entschieden, und
zwar auf "nicht jetzt".**

**(d) Offene Vorbedingungen.**
1. ASCII-Wache nicht 1:1 spiegeln (W-16): entweder `--stdin`-Pfad erzwingen oder Repo-Root aus dem
   Aufrufer-cwd.
2. Der super-Abdeckungs-Spiegel braucht eine Sonderregel, *"sonst meldet sie 313
   falsch-ungedeckte"*.
3. Der AUSSCHLUSS-Block gilt nur, wenn `verify:gitlink-vs-downstream` gruen ist — *"Ohne diesen
   Job zaehlt die Ausnahme nicht als Deckung."* Dieser Job existiert noch nicht.
4. **T-i-2 (Mutationsprobe am Axis-Lock)** ist die eigentliche offene Arbeit, ~1–3 h; *"wer ihn
   scharfstellt, riskiert Rot"* ⇒ eigene Bahn (P-LOCK-A).
5. Jeder neue ce-Test verschiebt den Nenner (heute 407) — *"Zwei gleichzeitige Registrierungen
   machen ein Rot unzurechenbar."*
6. Die Abdeckungswache kann ihre eigene Anwesenheit nicht erzwingen.
7. **Die Trigger-Kopplung entwertet Wachen-Aussagen strukturell:** drei Bridges mit `branch: main`
   fest verdrahtet — *"Eine Deckung, die auf einem Zweignamen statt auf dem eingebundenen SHA
   beruht, ist nur so lange wahr, wie beide zufaellig gleich sind."* Auflage T-1: ce-`main`-FF und
   super-Gitlink-Bump in denselben Arbeitsgang.
8. gitleaks vor dem Push, nicht nur ueber den Baum; ein Selbstaudit fuehrt *"gitleaks-vor-Push
   fehlte"* als eine von drei echten Abweichungen.
9. **Das E-23-Inventar hat ein Verfallsdatum** (max. 7 Tage, Erhebung 02.08. ⇒ 09.08.); die
   Klausel haengt am A11-Nachtrag mit Buchungsstand 0/0.
10. Termin-Rahmen 15.09. macht mehrere Sicherheits-Vertagungen neu bewertungsbeduerftig.

**(e) Fehlanzeigen.** Kein Bericht hat je einen super-seitigen ASCII-Job gebaut, geplant oder
beauftragt — der einzige Satz dazu ist die Fehlanzeige selbst. Keine Messung zur
Token-**Rotation**. Keine CI-seitige gitleaks-Submodul-Pruefung mit stiller Null (die belegte
Instanz ist ein manueller Agentenlauf). Eine dritte Sache namens "CI-Invariante" neben
`dcb2f08f` und `ci_yaml_key_guard.sh` gibt es im Bestand nicht — falls der Auftrag etwas anderes
meint, ist das **unklar**. Ob `lint:secrets` im super die Submodule mitscannt: **kein Bericht**.

---

### 2.10 Owner-Entscheide

**(a) Vorarbeit.** Vier unabhaengige, teils numerisch kollidierende Sammlungen:
- **Kanonische O-Liste** (`wf_216c6dbe-b55` / `af80391241cbab43a`, "B-VII — OWNER-FENSTER"):
  O-A..O-H, O-4, plus B14-Bump, Cacheline-Achse, Map-Gattungs-Kern-Reichweite, O-3, #327, E7,
  O-Token.
- **Sechs echte Fragen der Abend-Vertiefung** (`wf_ebe2aced-d4b` / `aa811c70b24c62177`): R-1
  Mess-Umfang (rot, *"VOR DEM ERSTEN BATCH"*), R-2 Form der XML-Trennung, R-3
  Fingerprint-Reichweite, R-4 Bau-Umfang, R-5 Anhang A, R-6 Ebene-B-Push; plus eigene Rueckfragen
  M-1 Abgabe-Begriff, M-2 "320er XML", M-3 Sicherheitsposten-Termine, M-4 vier 4096-Literale,
  M-5 `Code/measure_out_d03/`.
- **Dritte O-Nummerierung** (`wf_d023e824-238` / `a1c685e676573d0ee`): 16 beantwortet, echt offen
  O-1..O-5, neu N-1..N-3. **Kollidiert numerisch mit dem OWNER-FENSTER.** N-2 verbatim: *"Nicht
  gefunden: ein erteiltes GO ... '→ 320er-Abgabemessung (manual+USER-GO)' (LEDGER V7.4
  GATE-REIHENFOLGE, Z. 104)."*
- **Fuenf Golden-Fenster-Entscheide** E-1..E-5 (`wf_6a3096f7-60d` / `af3654f0689f07b00`), je mit
  Optionen und Empfehlung; **sechs Versions-Interface-Entscheide E-A..E-F**
  (`wf_732cebce-c68` / `a30ac654c6448ce6a`) mit Gate-Regel *"STOPP (generell): ohne Entscheid kein
  Byte"*; **drei PMC-Entscheide O-PMC-1..3** (`wf_d5d5761c-1aa` / `a89e6be5a24b83d4d`); **vier
  Fragen, die in keiner O-Liste stehen** (`wf_89ef6075-d52` / `a4f166dfb399a186a`).

**(b) Widersprueche.** W-18 (F-Nummern doppelt), W-20 (Termin). Dazu:
- **O-A steht auf einer Fiktion** (keine Kappung, siehe W-13/D-3) und ist zu 2/3 vorentschieden
  (§41).
- **O-B: drei Fassungen.** *"BEANTWORTET (die Kollision existiert nicht)"* vs. *"UNENTSCHIEDEN →
  O-B, zwei Owner-Doktrinen kollidieren"* vs. *"JA, entfernen — die konkrete Form ist Bau-, nicht
  Owner-Entscheid."*
- **O-C: "erledigt" vs. "nicht erledigt" innerhalb derselben Welle.** Trigger-POST-Variable
  erklaert die 0 Treffer; die Gegenprobe: *"O-C ist nicht erledigt, sondern verengt auf 'Rezept
  liegt vor, Vollzug unbestaetigt'."*
- **O-E ist falsch gefasst:** die Praemisse "null Leser" ist widerlegt (Konsumenten in
  `tools/system_axis_registry_gen/main.cpp:375-376`, `numa_page_probe.hpp`), und es gibt eine
  **Namensfalle** — die zweite, voll verdrahtete Unterachse `alloc_hw.numa_node` (152 vs. 23
  Treffer). *"Wer hier ungeprueft 'anschliesst', trifft die falsche Achse."*
- **O-F ist bereits entschieden** (Shaped-Emission = spezifizierter default-OFF-Zustand,
  Owner-Entscheid G-234V-b); der Restposten ist Bau, terminiert auf "nach Abgabe".
- **O-4: Praemisse am Objekt falsch** (Anhang A haengt an keinem von M-8/M-9/M-15).
- **F2 (dreiphasig/zweiphasig): zwei Berichte derselben Welle widersprechen sich** — belegt vs.
  *"Welche Lesart gilt, ist UNBELEGT."*
- **Die heutige F8-Antwort ("PMC in die Messachse") ueberstimmt eine ausdrueckliche
  Gegenempfehlung** (`a1c685e676573d0ee`, N-3: *"NEIN — nicht vor dem Voll-Lauf ... ein falsch
  kodiertes Event liefert plausible falsche Zahlen statt eines ehrlichen 0"*). Die technische
  Auflage (Validierung gegen eine Referenz vor dem Lauf) steht damit ungebucht im Raum; der Weg
  liegt vor (`PerfCounter::open` deaktiviert bei Fehlschlag nur das eine Feld — *"sie kann nicht
  raten, weil sie fragt"*).

**(c) Erledigt.** O-G (main-FF freigegeben; **Vollzug ist wiederholt faellig**, spaetere Messung
zeigt erneut Rueckstand), O-H (gegenstandslos), O-3 (Loesch-GO erteilt, *"das Register ist damit
stale"*), A1-Freigabe, R2 (E-18-Zielbranch = `development`), 13 von 21 Kandidatenfragen ohne
Owner beantwortbar (E-1..E-13), Vormittags-F1/F3/F4/F5/F7, Anhang A bereits erzeugt,
Kalibrier-Zahl vorhanden, F5s additiver Kern gelandet, OD-7 zu streichen.

**(d) Offene Vorbedingungen.** Fingerprint-Fenster schliesst mit der ersten gebauten Binary
(Klasse ALPHA in ein Buendel); **E-1 ist ein harter BLOCKER** (`experiment_golden_kern.xml:96`
schreibt `binary_search linear_search`, Registry fuehrt sie nicht, `validate_profile.hpp:1249-1258`
lehnt hart ab); *"STOPP: ohne Entscheid kein Byte"* fuer E-A..E-F, **E-F fehlt in jeder
Sammlung**; Mess-Seite ohne 4096er-Korn; chktex; O-D kleiner als angenommen, aber P-XXE erhoeht
die Zahl auf 6; ohne O-C/F7-Provider ist der Bestandslog ein Laufzeit-Multiplikator; PMC hat vier
Wachen, von denen keine beisst; das PMC-Anhangs-Versprechen ist heute falsch; **das USER-GO fuer
die 320er-Abgabemessung ist nie erteilt**; das gesamte P2-Band ist Vor-Messbeginn-Pflicht und
ungebaut (*"Nichts davon ist gebaut ... der groesste ehrliche Riss zwischen Plan und Fenster"*);
zwei heisse Dateien machen die Parallelisierung angreifbar; E8 Status unklar.

**(e) Fehlanzeigen.** Siehe Abschnitt 5.

---

## 3. WAS DOPPELT BEAUFTRAGT WURDE

Alles hier ist entweder bereits gebaut, bereits erhoben oder bereits ausformuliert. **Verwenden,
nicht wiederholen.**

| # | Heutiger Auftrag | Was schon existiert | Fundstelle |
|---|---|---|---|
| D-1 | M-5 "SUCHE: ObservableTier-Vertrag" | vollstaendiger Audit A-1..A-9, G-1..G-6, Bau-Anweisung **S0–S5 mit Biss je Schritt** und Rebuild-Bilanz | `wf_514dab7d-8a0` / `a7fc207bcb25ee4cb` |
| D-2 | M-2 Bau-Anweisung | **verifizierte** Bau-Anweisung P-PMC-1 (*"Kein fehlender Schritt gefunden"*) + Plan-Dokument 651 Z. mit B0–B6, W-1..W-5, O-PMC-1..3, fertiger Invarianten-Test im Quelltext | `wf_d5d5761c-1aa` / `ad6f7a811153a2559`, `a89e6be5a24b83d4d` |
| D-3 | M-3 planen | derselbe Inhalt **viermal** geplant: B6+O-PMC-3, S0.3, N-1..N-4, M-14. Wer neu plant, baut die fuenfte Fassung | 2.3 (a) |
| D-4 | M-6 Bauplan | Posten **B-2** ist konkreter als der Auftrag (Feldnamen, Views, Wache, drei Tests inkl. Golden-Neutralitaet und Biss); B-3 fuer die Mess-Scheibung | `wf_ebe2aced-d4b` / `aa8ceff625589ccd4` |
| D-5 | G-E3 "`make_messwert_key_fn` als Schwester" | Key-Ableitung existiert als `MesswertKeyPolicy` in `bestandslog_factory.hpp`, mit Test `TwoGeneraSeparate` PASSED; gesucht ist ein **Provider**, dessen Ziel unbenannt ist | `outputs/a9a2b597006efcd8c.output`, `outputs/batvn6yni.output` |
| D-6 | G-E3 Host-Binder-Kette suchen | Kette am Objekt gemessen und benannt (`profile_run_facade.cpp:723` → `profile_run_entry.hpp:650`), 0-Treffer-Beleg fuer die Mess-Seite | `wf_89ef6075-d52` / `af7c11bdc4317f6b3` |
| D-7 | Lager-Basis-Tests Stufe 1 | **gebaut und gelandet** (`3558466d` → `b241a272`), inkl. echter FS-Konkurrenz mit gemessener Race-Statistik | `wf_701941f6-2c9` / `a6af7e4a8f0697ad0`; `wf_ebe2aced-d4b` / `aa811c70b24c62177` |
| D-8 | Lager-Basis-Tests Stufe 2 planen | Bauplan komplett ausformuliert (Vorlage, dreiteiliger Biss, Leerheits-Beweis) | `outputs/a9a2b597006efcd8c.output`; `wf_84d76563-de5` / `ab565ced2dfa81182` |
| D-9 | Kalibrier-Stichprobe "Zeit je Binary" | gemessen seit 23.07. aus Pipeline 12690 (19,4 / 32,25 min je 4096) — der Batch ist **Bestaetigungsmessung** | `wf_ebe2aced-d4b` / `aa8ceff625589ccd4` |
| D-10 | Bau-Umfang / cap / Fensterlage klaeren | alle drei am Objekt entschieden (524.288; keine Kappung; je Perm) | ebd. + `wf_24104303-f97` / `aff70699b2fc8788c` |
| D-11 | Anhang A "ehrlich machen" | Generator gefahren, **28/28 Positionen bedient**, PDF DE+EN 0 Fehler; 4 Gruppen-Ersatztexte bereits geschrieben (`8e58f691`) | `wf_ebe2aced-d4b` / `a9f196e0e0aaa9bd4`; `wf_b242700f-3a0` / `aa1f413636c35eb1b` |
| D-12 | `axis_inventory.tex` einbinden | eingebunden in `a6c7598c` (Anhang D) | `wf_ebe2aced-d4b` / `a6847e8d9e5bcb322` |
| D-13 | Alt-Kapitel markieren | gebaut, additiv, 16 Dateien +74 Zeilen, 0 Loeschungen | `wf_24104303-f97` / `aff70699b2fc8788c` |
| D-14 | Doppelschluessel `contract:axis-version-lock` | geheilt auf `development` **und** `main`; offen ist nur die Mutationsprobe T-i-2 | `wf_216c6dbe-b55` / `ab077c917752b767e` |
| D-15 | gitleaks-Submodul-Falle | dokumentiert mit Rezept und als Dauer-Regel gebucht; rueckwirkender Pruefauftrag laeuft bereits | `outputs/be52dmp6f.output`; `wf_216c6dbe-b55` / `af80391241cbab43a` |
| D-16 | PMC-Preflight | **#37 ist gebaut** (`experiment_plan_director.hpp:1269-1280`); M-2 verengt, baut nicht neu | `wf_18a419ce-aad` / `af47374e2633fd61c` |
| D-17 | Korn-Divergenz Bau/Mess | geheilt in `wt-b2-neuanker` (`plan_slice_korn`), **ungepusht**, clang-format-Gate offen | `wf_d7a17fc9-ead` / `a3d66ccc3aec5fe08` |
| D-18 | F5-Golden-Update-Fenster als eigene Welle | additiver Kern S0–S5 **bereits gelandet**, mitgefahren in B14-NB2 | `wf_63e3bb60-ecd` / `a86b541d9987df382` |

---

## 4. DIE OFFENEN OWNER-FRAGEN, konsolidiert

**Vorbemerkung zur Zuordnung:** Der Wortlaut der acht heute Abend beantworteten Fragen F1–F8
(Messfreigabe · dreiphasig · PMC-Pflicht · Parallelisierung · ObservableTier · Fingerprint-
Identitaet · Bestandslog · PMC-Messachse) steht in **keinem** der 121 Berichte. Die Spalte
"durch heute Abend erledigt" ist daher eine **inhaltliche Ableitung des Abgleich-Agenten**, kein
Beleg — bei F2 und F4 passen mehrere Kandidaten. Sie ist zu verifizieren, bevor daraus etwas
geschlossen wird.

### 4.1 Vermutlich durch die acht Antworten von heute Abend erledigt

| Frage | Inhalt | Abgeleitete Zuordnung |
|---|---|---|
| O-A (Teil 1+2) | PMC fixen oder honest-0; Bau-Matrix des golden | F3 (PMC-Pflicht) — plus §41 hatte 2/3 bereits vorentschieden |
| O-B | `allow_failure` am Mess-Batch | mittelbar ueber F3; die konkrete Form ist laut `aa811c70b24c62177` **Bau-Entscheid** |
| O-C | Faehrt der Trigger mit `COMDARE_BESTANDSLOG`? | F7 (Bestandslog) — *Streit "erledigt vs. verengt auf 'Vollzug unbestaetigt'"* bleibt |
| R-1 / R-2 | Mess-Umfang; Form der XML-Trennung | F1 / F2 (unsicher) |
| R-3 | Fingerprint-Reichweite / Preimage | F6 (Fingerprint-Identitaet) — **aber der Format-Bump-Entscheid selbst ist damit nicht automatisch gefallen, siehe W-02** |
| ObservableTier-Vertrag | Audit-Auftrag | F5 |
| PMC als Mess-Achse | Weg A vs. Weg B | F8 — **ueberstimmt die Gegenempfehlung N-3**, deren Auflage offen bleibt |

### 4.2 Weiterhin offen — nach Dringlichkeit

**Blockiert Bau oder Messung:**
1. **E-1 search_algo-Pin** — `experiment_golden_kern.xml:96` besteht den Validator nicht.
   HARTER BLOCKER. (`wf_6a3096f7-60d` / `af3654f0689f07b00`)
2. **E-A..E-F Versions-Interface** (sechs, **E-F fehlt in jeder Sammlung**) mit Gate *"ohne
   Entscheid kein Byte"*. (`wf_732cebce-c68` / `a30ac654c6448ce6a`)
3. **Format-Bump 3→4 / Mess-Define im Toolchain-Glied** — Fenster schliesst mit der ersten
   `.fingerprint`-Datei. (`aa811c70b24c62177`, R-3)
4. **USER-GO fuer die 320er-Abgabemessung** — nie erteilt (LEDGER V7.4 Z.104).
   (`wf_d023e824-238` / `a1c685e676573d0ee`, N-2)
5. **Teilmengen-Semantik der Mess-Menge** (V1 vs. V2) und die **Zahl** der Mess-Menge — 304 von
   320 liegen ausserhalb des gebauten Raums. (R-2 / R-1)
6. **`kCebFingerprint` ins Tier-Preimage?** LEDGER:5792 schliesst ihn heute begruendet aus.
7. **4 Perms vs. 12 Perms** (Owner-D-34 vom 26.07. gegen die heutige Empfehlung) — **in keinem
   Bericht aufgeloest**.

**Betrifft die Abgabe:**
8. **O-4 Anhang-A-Reichweite** — vier gegensaetzliche Empfehlungen; Praemisse widerlegt;
   Default-Begruendung "NACH-ABGABE" haengt am 08.08.
9. **Zwei Overleaf-Mounts: reduzieren oder bewachen?** (kein Bericht empfiehlt "beide behalten")
10. **O-PMC-3 Anhangs-Umfang**, drei Teilfragen (a) Spalten, (b) `branch_misses` jetzt, (c) RAPL.

**Offene Grundsatzfragen:**
11. **F6 (Vormittagsrunde):** verwirft "Micro-/Macro-Benchmarking sind FALSCH" auch §47? **Kein
    Supersede-Vermerk im Ledger.** Traegt S2 des ObservableTier-Audits.
12. **F8 (Vormittagsrunde):** gilt "gleicher Fingerprint ⇒ Messwerte uebertragbar, auch nach
    Neubau" uneingeschraenkt?
13. **O-D** `xmllint` nachinstallieren oder 5 (mit P-XXE: 6) Fixture-Wachen herausnehmen — es gibt
    einen dritten Weg (verankerter SKIP-Marker).
14. **O-E** `target_isa.numa_node`/`.page` — **in der falschen Fassung gestellt** (Namensfalle
    `alloc_hw.numa_node`).
15. **O-F / 234-V-b Shaped-Emission** — laut zwei Berichten bereits entschieden (default-OFF).
16. **E-2..E-5** Golden-Fenster (Alignment bei line=32, XSD-Umfang, binary_id-Grammatik-Bruch
    TABU-6, `compiler/atomic128`).
17. **E7** Multi-Thread-Messflaeche (Phase-6-Doktrinfrage).
18. **Map-Gattungs-Kern-Reichweite** — zaehlen SA-Zusatz-Subinterfaces dazu?
19. **`op_types`** OP-1..OP-3 vs. OP-4 der Alt-golden — *"Kein Ist-Beleg, welcher Satz der
    golden-Soll ist."*
20. **B14-Bump-Frage** und **B14 Teil 2** (mittag-22 nennt zwei Entscheide, die Liste nur einen).
21. **i-5** Provider-Opt-in umkehren oder harte Wache — *"der Zwilling zu D4, fehlt komplett."*
22. **A11** `.gitleaks.toml`-Allowlist: gilt der Drop-Plan noch?
23. **Bucket-Invalidierung beim Bump 8.0→8.1** — Owner-Entscheid, sobald ein schuetzenswerter
    Bestand existiert.
24. **KF-6-Wiring vs. Wache** (bewusster golden-Bruch oder lauter Widerspruchs-Melder).
25. **Herabstufung von LB-6 Beweis 1 + Beweis 4 + echter Nebenlaeufigkeit** — muss deklariert
    werden, sonst wird "Stufe 1 fertig" zu "LB-6 fertig".
26. **Vier Stufe-2-Entscheide** (Symbol jetzt oder S1/S3 abwarten; Reader/Writer eine Factory oder
    zwei; xlsx-Leser; eigenes Dossier).
27. **Vier Fragen ohne O-Nummer** (`wf_89ef6075-d52` / `a4f166dfb399a186a`): E14 vor/nach Trigger;
    welche P2-Posten duerfen hinter den Messbeginn rutschen; faellt xlsx in die Abgabe; **faehrt
    der Trigger mit `COMDARE_STORAGE_CACHE` + MinIO** (Zwilling zu O-C, fehlt in jeder Liste).
28. **Cacheline-Achse** — heute gegenstandslos, *"wird aber scharf, sobald KF-6 nachgeruestet
    wird."*
29. **Drei Overlay-Festlegungen** (`anatomy_fingerprint.hpp:103-107`: Dateimenge, Sortierung,
    Hash-Form) — *"Owner-Entscheid, nicht zu raten."*
30. **`axis_inventory.tex`**: in welchen Anhang-Abschnitt gehoert die Tabelle?
31. **Doppelter Gitlink / Bridge-Branch**: Gleichheits-Wache; `branch: $CI_COMMIT_REF_NAME` vs.
    SHA-Vergleichs-Job.
32. **V-05-Rest-Herabstufung** und **V-11-Rotationsfenster**.
33. **Scheibe-6-Weg** — *"Vor jeder mechanischen Aenderung: Owner-Entscheid einholen ... Erst nach
    GO ausfuehren."*

**Terminiert, aber durch die Fristverschiebung neu zu bewerten:**
34. **O-Token / O-5** — 776 `runners_token` in `refs/backup/pre-secret-scrub-20260802` =
    `5ba3d03f`. Owner: *"nach Messfenster rotieren, handout an infra"*; Loeschung der Remote-Ref
    nur mit **expliziter** Autorisierung. M-3 des Abend-Plans: *"auf einen festen Freitag ziehen."*
35. **#327 PAT-Rotation** — dieselbe Klasse.
36. **E-23-Inventar** laeuft am 09.08. ab (max. 7 Tage).

**Nie uebergeben:** Kein Bericht behauptet, die Owner-Vorlage sei jemals uebergeben worden. Sie
ist mehrfach als Aufgabe gefuehrt (1D-1), nie als erledigt.

---

## 5. Grenzen dieses Abgleichs

1. **Nichts ist am Code nachgeprueft.** Weder die zehn Abgleich-Agenten noch dieses Dokument haben
   eine der zitierten Behauptungen am Objekt verifiziert. Auch Saetze der Form "am Objekt
   gemessen" bleiben Fremdbehauptungen.
2. **Zeilennummern altern.** Die Anker stammen aus Berichten gegen ce `47c4ef1d`, `b241a272`,
   `e7aa1244`, `3bbcb8ed` und super `72eab9ae`, `46824fba`. Mehrere Berichte lasen **verschiedene
   Staende desselben Tages** und widersprechen sich deshalb (W-22, M-6/Korn-Divergenz,
   M-5/Aufrufer-Zaehlung). Auflage: `git merge-base --is-ancestor` bzw. Suchbegriff statt Zeile.
3. **Ein Pfad ist nachweislich falsch zitiert:** `libs/cache_engine/builder/planner/experiment_plan_director.hpp`
   existiert nicht; die Datei liegt unter `libs/cache_engine/profile_facade/planner/...`.
   Zeilennummern stimmen laut `aa811c70b24c62177`.
4. **Die Zuordnung der heutigen F1–F8 zu den Berichtsfragen ist Ableitung, kein Beleg** (siehe
   4.0). Der Wortlaut der acht Fragen steht in keinem Journal.
5. **Nummern-Kollisionen sind systematisch, nicht Einzelfaelle:** mindestens vier
   F-Nummerierungsrunden, drei "Strang A/B/C"-Systeme, drei O-Nummerierungen, zwei M-Belegungen,
   je zwei Bedeutungen fuer O-2, B12, R2, drei fuer F6. **Jede Referenz braucht Datum und
   Sachbezug.**
6. **Der Bestand endet vor dem heutigen Abend.** Die SHAs `19e1592` und `123b2f32` aus der
   laufenden Aufgabenliste kommen im gesamten Backup (Journale + 269 `outputs/`) **0-mal** vor.
   Was heute Abend nach dem Backup gebaut oder gelandet wurde, ist hier weder bestaetigt noch
   bestritten. Mehrere Punkte (Bridge-Heilung, super-Gitlink-Nachzug, Anhang-A-Ersatztexte) sind
   deshalb ausdruecklich **vor Neu-Beauftragung am Objekt zu pruefen**.
7. **Zwei Berichte verweisen auf Code-Lesungen, die nur in `outputs/` stehen**, nicht in den
   Journalen (`a9a2b597006efcd8c`, `batvn6yni`, `be52dmp6f`, `b28mpyfcd`, `buzy17z4a`). Die
   `outputs/` wurden nur gezielt, nicht vollstaendig gelesen — **269 Dateien, davon ein knappes
   Dutzend gesichtet**. Dort koennen weitere Befunde liegen.
8. **Nicht gelesen wurden:** die Transkripte selbst (nur ueber Zitate frueherer Berichte
   erreichbar), der Ledger, das 14-Tage-Register, die Plandokumente unter `docs/plaene/`. Mehrere
   der wichtigsten Belege (Owner-Zitate, LEDGER-Zeilennummern) sind **Zitate aus zweiter Hand**.
9. **Ein Plan-Dokument mit 651 Zeilen (P-PMC-1) und eines mit 521 Zeilen (LB-6 Stufe 1) sind laut
   Bericht nicht committet** und damit `git clean`-gefaehrdet. Ob sie noch existieren, ist hier
   nicht geprueft.
10. **Fehlanzeigen sind Fehlanzeigen im Bestand**, nicht im Projekt: "kein Bericht sagt X" heisst
    nicht "X existiert nicht".
