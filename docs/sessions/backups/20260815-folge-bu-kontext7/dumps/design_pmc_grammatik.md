# DESIGN G-1P -- die SONDER-GRAMMATIK der PMC-Meta-Meta-Achse (dreiphasig, vendor-dimensioniert)

> **Status: ENTWURF als OWNER-VORLAGE -- KEIN BAU.** Task #53 Schritt 1 (Reihenfolge KON64-04:
> PMC zuerst -- "reifster Bestand, kleinste Grammatik"). Owner-Auftrag F-G1-12 neu gefasst
> (14.08., verbatim): *"Wir hatten multiple Mess-Achsen definiert, die jeweils ihre eigene
> Basis-Grammatik fuehren, die wir noch mit Syntax und Semantik designen moechten, bitte
> uebernimm das."*
> **Datum:** 15.08.2026 · **Quellen-Stand:** super-Ledger bis KON65 · G-1-Design inkl. §12
> (Finalfassung) · kon64_sammlung.md Teile 1-6 · PMC-Explore wf_6b1d9de5 (mx_result_voll.json)
> · ce-Baum @ `04f76b65` (development, NUR LESEND).
> **Schwester-Dokument zu:** `docs/plaene/20260813-DESIGN-g1-grammatik-dreiphasige-messachse.md`
> (G-1). Alle Formen unten sind von der v2-Token-Syntax erzeugt; **Syntax-Auflage 14.08.
> eingehalten:** jedes Kuerzel wird ZERLEGT gefuehrt (`pmc{b.t}` = Basis `pmc` + Sub-Flags
> `{b.t}`; `c{p.e}` = Basis `c` + Sub-Flags `{p.e}`) -- flache Formen existieren NICHT.

---

## 0. Der Auftrag und seine Owner-Worte (verbatim, mit Fundstelle)

**F-G1-8-KORREKTUR (14.08., Transkript 5a19728e:55073; gebucht KON64-03):**
> *"Die PMC ist hardware und wird per dreiphasig als Meta-Meta-Achse als eigenstaendig
> eingepflegt, aber nicht in der existierenden Achse, bitte lies den Plan, das ist geplant
> (explore!)."*

Der Owner waehlte damit eine DRITTE Option jenseits der zwei vorgelegten (aussen lassen /
viertes Instrument-Token unter `b`): eine EIGENSTAENDIGE, formal dreiphasige Meta-Meta-Achse.
Der Plan-Explore ist gefahren (KON64-04, wf_6b1d9de5).

**F1 SONDER-GRAMMATIK (15.08., Teil 5; gebucht KON65-03) -- "Korrekt erkannt":**
> *"existiert keine PMC, wird allerdings gar nicht erst eine eingetragen"*

Abwesenheit = **KEIN Eintrag, kein leerer Slot** (bewusster Kontrast zur m-Grammatik M-4, wo
der leere Slot Zeiger-Traeger ist). PMC wird **DREIPHASIG auf CEB UND Tier/Hybrid
eingetragen als PERMUTIERENDE Messeinrichtung**, *"die als ZUSAETZLICHE Achse die Permutation
gegen w/ma/mi erweitert"* -- eine **NENNER-ERWEITERUNG** gegen die 2^5-Welt (KON25-03 bleibt
der w/ma/mi-Kern). Die F1-Frage der Vorlage lautete "PMC-Kind-Projektion (pmc-fuehrend analog
w?)" (KON64-04) -- das "Korrekt erkannt" deckt die pmc-fuehrende Kind-Projektion.

**F2 PLANER-HARDWARE-ERKENNUNG (15.08., Teil 5; gebucht KON65-03), Owner verbatim:**
> *"Technisch gesehen steht PMC zwischen einer System-Achse und einer Mess-Einrichtung. Ich
> entscheide, dass ein als neue Haupt-Achse bzw. Meta-Meta-Achse PMC ausnahmsweise eine
> Hardware-Erkennung im Planer nur fuer PMC durchfuehrt und diese Freigabe an die
> System-Achse freigibt, die hier nur als Proxy fungiert und dann PMC auch als
> Hardware-Eigenschaft und eigene Meta-Meta-System-Achse freigibt."*

**F8 ZWEI PMC-SYSTEME (15.08., Teil 5) -- "exakt korrekt":** AMD und Intel, *"die wir ueber
das Durchreichen kommunizieren, abbilden und durch Kompilate abbilden muessen. Freigabe."*

**Owner 10.08. (wortgleich im Code, `pmc_vendor_registry.hpp:4-10`):**
> *"Das PMC ist eine Meta-Meta-Mess-Achse und wird daher in der CEB und deren Fingerprint
> verbaut, wenn damit gebaut wird. Dabei erkennt jeder Planer auf jeder Maschine fuer sich,
> ob PMC existiert [...] Es entsteht hier wieder eine Permutation, weil ohne in die CEB
> eingebaute PMC, auch die Tier-Binaries keine PMC messen und sich daher der Binary Overhead
> eingebauter Messfuehler unterscheidet/reduziert [...] Jede Hardwareform einer PMC AMD/Intel
> ist zu unterscheiden, es sind 2 verschiedene hardware Komponenten nicht EIN PMC."*

**Owner 06.08. (P/E-Pinning-Mechanik, Memory feedback_pmc_je_mikroarchitektur...):** die CEB
*"kann beide Messfuehler tragen, aber legt die Ergebnisse je PMC getrennt ab [...] startet
einmal die Tier-Binary gepinnt auf einen E-Core und einmal gepinnt auf einen P-Core"* --
*"reine Wiederverwendung durch Achsen-Permutation durch die CEB auf einer dafuer zustaendigen
SYSTEM-Achse."* Und: *"Damit hat die Intel Maschine effektiv 2 PMC und nicht nur eins."*

**KON64-03 MARKER-PFLICHT (3):** *"Ledger:3518 'Tier-Fingerprint pmc-frei' steht gegen die
PMC-Dreiphasigkeit (W2 -- Alias-Klasse analog w-Blindheit): Aufloesung im
PMC-Schwester-Design"* -- geleistet in §7 dieses Entwurfs. (Ledger-Zeilen wandern: der
Gegenstand steht heute in der KON34-02-Karte, Ledger :4419, und der System-A/B-Karte :4079.)

---

## 1. Der erhobene Gegenstand: WAS die PMC-Achse sagen muss -- und wie es heute dasteht

Die PMC-Achse muss vier Aussagen tragen koennen (alle owner-gedeckt, §0):

| # | Aussage | Quelle |
|---|---|---|
| A1 | **Existenz/Einbau**: PMC ist am Host vorhanden UND eingebaut -- sonst GAR KEIN Eintrag (Abwesenheits-Semantik, kein leerer Slot) | F1 · KON65-03 |
| A2 | **Vendor**: WELCHE der zwei Hardware-Komponenten (amd/intel), je mit EIGENER Version; nie beide in einem Kompilat | Owner 10.08. · F8 |
| A3 | **Belegung je Traeger-Stufe**: welche Stufe (CEB/Hybrid/Tier) die permutierende PMC-Einrichtung EINGEBAUT traegt -- die Nenner-Erweiterung gegen w/ma/mi | F1 · KON25-03-Abgrenzung |
| A4 | **Drei Phasen**: Planer-RT-Erkennung (NUR PMC) -> System-Achse als PROXY der Freigabe -> CEB-CT-Einbau -> Vertrag mit Tier/Hybrid (Durchreichen + Kompilate) | F2 · F8 · KON16-02-Analogie |

**IST am Objekt (ce `04f76b65`, alle Fundstellen frisch nachgelesen):**

* **Identitaets-Quelle existiert:** `pmc_vendor_registry.hpp` (167 Z.) -- constexpr-Registry,
  GENAU ZWEI `PmcVendorInfo`-Eintraege (`:60-63`): `{Amd,"amd","Amd","AuthenticAMD","1.0.0.c"}`
  / `{Intel,"intel","Intel","GenuineIntel","1.0.0.c"}`; paarweise-verschieden-Wachen (`:105-132`)
  gegen stilles Kollabieren; `kPmcStampName = "pmc"` als "die EINE Wahrheit seiner
  Schreibweise" (`:134-136`); fail-closed-Lookups (`:154-165`). B12-Batterie heute auf
  `ce_owned_version_is_wellformed` + `cpu_enforce` (`:68-89`).
* **Erkennung existiert:** `profile_facade/planner/pmc_host_probe.hpp` -- Laufzeit-Probe
  (cpuid + perf_event_open + Pointer-Chase-KOEDER; K13: "oeffnet" genuegt nicht), fail-closed
  (unbekannter Vendor/Nicht-Linux/Probe-nicht-gefahren => KEIN PMC behauptet); Kopf traegt die
  Owner-Praezisierung "es gibt nur EINEN Planer" -> RT-Erkennung je LAUF, nie Bauzeit.
* **Stempel-Glied existiert CEB-SEITIG:** `builder/ceb_version_stamp.hpp:270-345` -- #error
  bei beiden Vendor-Makros ("eine CEB wird auf GENAU EINEM Host gebaut"), EIN Praedikat
  `COMDARE_CEB_HAT_PMC_GLIED`, rendert `pmc=<vendor>@X.Y.Z` als Klammer-Anhang; OHNE Vendor
  ist der Anhang "byte-identisch zum Vor-10.08.-Stand" (`ceb_pmc_segment_len()==0`) -- die
  Abwesenheits-Semantik ist dort im Kleinen SCHON GEBAUT.
* **CI-Beweis existiert:** `.gitlab-ci.yml:186-245` -- `.pmc`-Template + `pmc:amd`/`pmc:intel`
  (tags [baremetal,amd]/[baremetal,intel] -> prod1/prod2), `resource_group` pmu-prod1/pmu-prod2
  (PMU = exklusive Host-Ressource), HART ohne allow_failure; `COMDARE_PMC_LANES` deklariert die
  Vendor-Maschinen-Menge (Comdare: "amd intel" = beide Pflicht).
* **Die "existierende Achse", die es NICHT werden darf:** `PmcSystemAxis` sitzt als einer von
  3 collector-Bausteinen (`system_axis.hpp:389-394`, `measurement_axis_registry.xml:25-34`)
  auf dem `SystemAxis<Derived>`-Sockel -- NICHT auf `MeasurementMetaMetaAxis<Derived>`
  (0 Code-Treffer "Pmc" x "MeasurementMetaMetaAxis", wf_6b1d9de5-Gegenprobe). Die CRTP-Wurzel
  `measurement_meta_meta_axis.hpp` ist fuer MEHRERE Traeger gebaut, hat heute EINEN
  (load_framework; K1-Umzugs-Praezedenz 26.07.).
* **Eine PMC-Grammatik existiert nicht** -- Nichtfund mit Gegenprobe am 15.08. selbst gefahren:
  `"pmc"`-Token im Hardware-Katalog `flag_grammar_catalog.hpp` = **0 Treffer**, `"amd"`/`"intel"`
  als Katalog-Token = **0 Treffer**; Positiv-Kontrolle am selben Muster: `"bw"` = 2 Treffer
  (das Suchmuster beisst). `kMessGrammarCatalog|mess_version_is_wellformed` ueber `libs/` =
  0 Treffer (G-1 selbst ist planmaessig ungebaut -- dieses Dokument haengt sich an den
  G-1-BAU, nicht an einen Bestand).

---

## 2. Die Sonder-Grammatik-These: ABWESENHEIT IST KEIN WERT

**These: die PMC-Achse ist ein v2-PROFIL wie G-1 -- mit EINER Sonder-Regel, die G-1 nicht
hat: der Nichtfall wird NICHT geschrieben.**

Die m-Grammatik traegt den Aus-Zustand als adressierbaren Wert (`m{b.t}` -- leere Slots sind
Zeiger-Traeger, KON37-03). Die PMC-Achse tut das AUSDRUECKLICH NICHT (F1): PMC ist HARDWARE;
ein Slot fuer nicht vorhandene Hardware waere eine Phantom-Adresse. Daraus folgt die
**zweifache Abwesenheit** (beide Faelle formgleich: KEIN Eintrag):

1. **Hardware fehlt** (Host ohne bekanntes PMC): nichts freigebbar, nichts eintragbar.
2. **Hardware vorhanden, aber NICHT eingebaut** (die pmc-lose Haelfte der
   Overhead-Permutation, Owner 10.08.): das Kompilat traegt keinen Eintrag -- der Stempel
   ist das KOMPILAT, "nur Eingebautes" (KON60-08/G-1 §11.1).

Die UNTERSCHEIDUNG der beiden Faelle lebt in **Phase 1** (Planer-Probe-Befund; der Befund
traegt seinen eigenen Nenner, `PmcHostBefund`), NIE im Stempel. Ein Eintrag existiert
**genau dann**, wenn mindestens eine Traeger-Stufe die PMC-Einrichtung eingebaut traegt --
der Eintrag ist immer "wahr", es gibt keine leere Form von ihm.

---

## 3. Die Grammatik

### 3.1 EBNF (als Profil der v2 -- Token-Syntax unveraendert v2, EIN Parser)

    pmc_eintrag  := 'pmc' '=' vendor_id '@' pmc_entry_version    -- Meta-Meta-Eintrag der
                                                                 -- Mess-Zeile; 0 oder 1 mal
    vendor_id    := 'amd' | 'intel'                              -- WERT des EINEN Merkmals,
                                                                 -- aus kPmcVendorRegistry
    pmc_entry_version := UINT '.' UINT '.' UINT '.' 'c' [cpu_sub] '.' pmc_flag
    pmc_flag     := 'pmc' '{' stufe [ '.' stufe ]* '}'           -- GENAU EIN pmc-Flag,
                                                                 -- MINDESTENS EINE Stufe
    stufe        := 'b' | 'h' | 't'                              -- CEB | Hybrid | Tier;
                                                                 -- BLAETTER (keine Kinder),
                                                                 -- je hoechstens einmal
    cpu_sub      := '{' ('p'|'e') [ '.' ('p'|'e') ] '}'          -- unveraendert G-2
                                                                 -- (W7-Andockstelle, §8)

Alles ist v2-wohlgeformt (R2-R5 unveraendert); der bestehende Parser `parse_algo_semver`
parst jede Form heute schon. Tiefe: `pmc`=0, Stufen=1 -- unter `kMaxFlagDepth == 4`;
Knotenzahl des pmc-Baums maximal 1+3=4, die volle Eintrags-Version mit `c{p.e}` maximal
7 Knoten << `kMaxFlagNodes == 96`. **Die Produktion ist ABSCHLIESSEND:** zwischen
`c`[cpu_sub] und `pmc` steht NICHTS; andere Hardware-Flags auf der pmc-Eintrags-Version
sind Formfehler (Spiegel-Regel zu G-1 §3.1).

**Zerlegungs-Pflicht (Owner 14.08.):** `pmc{b.t}` ist IMMER Basis `pmc` + Sub-Flag-Menge
`{b.t}` -- niemals ein flaches Token "pmcbt"; `c{p.e}` ist Basis `c` + Sub-Flags `{p.e}` --
niemals "cpe". Jede Verwendung in Doku/Wachen/Meldungen fuehrt die zerlegte Form.

**Wo der Eintrag wohnt:** im **Meta-Meta-Klammer-Segment der Mess-Zeile** des jeweiligen
Traeger-Stempels -- fuer die CEB ist das der heutige Klammer-Anhang des Selbst-Stempels
(`ceb_version_stamp.hpp`, dort steht `pmc=<vendor>@X.Y.Z` SCHON); fuer Tier/Hybrid ist es
NEU per Dreiphasigkeit (heute rendert `measurement_stamp_line` nur `[load_framework=...]`)
-- Bau-Naht, kein Bau hier. JE Stempel EIN Zuhause; keine Doppelheimat.

**Zwei Versions-Ebenen, sauber getrennt (Analogie G-1 §3.3 / KON9-05):**

* Das **X.Y.Z.c der Registry** (`"1.0.0.c"` je Vendor) ist die CODE-Identitaet der jeweiligen
  Hardware-Komponente -- die beiden Systeme versionieren UNABHAENGIG (Owner 10.08.;
  Registry-Kommentar: "ein Event-Set-Wechsel auf der AMD-Seite bewegt die intel-Version
  nicht"). Registry-Literale bleiben BELEGUNGS-FREI.
* Der **`pmc{...}`-Schwanz** ist die VERTRAGS-Spezifikation dieses Kompilats -- er wird bei
  der Aufloesung an die Vendor-Version ANGEHAENGT ("eine Aufloesung, zwei Verbraucher":
  Stempel-Glied + Bau-Gates; Muster G-1 Stufe F).

### 3.2 Die Regeln PM-1...PM-10 (Gegenstueck zu M-1...M-11 der G-1)

* **(PM-1) EIN PARSER, EIN RENDERER.** Zeichenidentisch v2; `parse_algo_semver`/
  `render_algo_semver` bleiben die einzigen; jede Durchsetzung laeuft ueber
  `for_each_flag_node`. Kein zweiter Zerleger.
* **(PM-2) ABWESENHEIT = KEIN EINTRAG (die Sonder-Regel).** Es gibt KEINE leere Form:
  kein `pmc`-Flag ohne Stufe, keine leere Klammer, kein Eintrag ohne eingebaute Einrichtung.
  Eintrag vorhanden <=> mindestens eine Stufe traegt die PMC-Einrichtung EINKOMPILIERT.
  Beide Abwesenheits-Faelle (§2) sind formgleich; die Unterscheidung ist Phase-1-Wissen
  (Planer-Befund), kein Stempel-Wissen.
* **(PM-3) VENDOR = WERT, NICHT FLAG.** Hoechstens EIN pmc-Eintrag je Stempel; sein Wert
  stammt aus der GESCHLOSSENEN Zwei-Werte-Menge der Registry (amd|intel), jede mit EIGENER
  Version. Ein Kompilat traegt NIE beide (eine CEB wird auf genau einem Host gebaut --
  #error-Wache existiert). Die Vendor-Dimension permutiert NICHT je Host, sondern ueber die
  MASCHINEN des Clusters (prod1=amd, prod2=intel; CI-Lanes `COMDARE_PMC_LANES`): **zwei
  Mess-Welten, je eigene Kompilate** ("durch Kompilate abbilden", F8). Das DURCHREICHEN
  (F8) ist der Phasen-Transport §6: Probe-Befund -> System-Proxy -> CEB-Bau -> Kind-Bau.
* **(PM-4) STUFEN-MENGE, TIEFE 1.** Unter `pmc` stehen 1..3 Stufen-Token aus {`b`,`h`,`t`},
  jedes hoechstens einmal, als BLAETTER (Instrument-Untergruppen gibt es nicht -- das
  Instrument IST die PMC; w/ma/mi gehoeren der m-Grammatik). Identitaet ist das
  (token,eltern)-Paar (S-3-Doktrin): `b` unter `pmc` ist NIE dasselbe Element wie `b` unter
  `m` -- die bewusste WIEDERVERWENDUNG des Stufen-Vokabulars (F-G1-2) kostet keinen
  Namensraum.
* **(PM-5) CEB-VORAUSSETZUNG.** `t` oder `h` im pmc-Flag ERFORDERT `b`. Owner 10.08.:
  "ohne in die CEB eingebaute PMC, auch die Tier-Binaries keine PMC messen"; deckungsgleich
  mit der Stufen-Ordnung KON65-02 ("Traeger Stufen, die naeher an der CEB sind, [haben]
  immer einen Funktionsumfang groesser gleich der nachfolgenden"). `pmc{b}` allein ist der
  klassische CEB-only-Zustand (heutiger IST).
* **(PM-6) SLOT-DECKUNG + SPIEGEL-ORDNUNG (vorgelegt als F-P4).** Die pmc-Stufen sind eine
  TEILMENGE der m-Slots derselben Mess-Zeile (nur adressierbare Stufen des Vertrags koennen
  eine Einrichtung tragen; der m-Slot darf dabei leer sein: `m{b.t{ma.mi}}` + `pmc{b.t}` ist
  zulaessig). Ihre REIHENFOLGE spiegelt die m-Anordnung -- die statisch freigegebene
  Anordnung (KON37-03/M-6) existiert je Stempel GENAU EINMAL; eine zweite, abweichende
  Ordnung im pmc-Flag waere eine zweite Anordnungs-Wahrheit (Alias-/Widerspruchs-Klasse).
  Der Parser normalisiert weiterhin NICHTS (v2-Doktrin); die Spiegel-Ordnung ist
  WACHEN-Sache.
* **(PM-7) DREI PHASEN = DREI LESARTEN + die PMC-AUSNAHME in Phase 1.** Derselbe Eintrag
  wird gelesen als: **Phase 1** (Planer, freigebende Seite): *impliziert* -- ABER die
  Freigabe-Quelle ist hier ausnahmsweise die PLANER-HARDWARE-ERKENNUNG (NUR fuer PMC, F2),
  durchgereicht ueber die SYSTEM-ACHSE ALS PROXY · **Phase 2** (CEB, Compile-Seite):
  *fordert* -- die CEB baut exakt diese Vendor+Belegung und fordert ihre Einrichtungen ein ·
  **Phase 3** (Ziel): Vertrag der PERMUTIERENDEN Einrichtung zwischen CEB und Tier/Hybrid
  exakt nach Eintrag (Einrichtungs-Gates, Pinning-Fenster). Wie bei G-1: die Bedeutung
  haengt an der SEITE, nicht am Zeichen.
* **(PM-8) KIND-STEMPEL PMC-FUEHREND (analog w, G-1 §11.2).** Traegt die erzeugende CEB die
  PMC eingebaut, fuehrt die Kind-Mess-Zeile den pmc-Eintrag MIT dem `b` (pmc-fuehrend);
  das Kind ergaenzt seine EIGENE Stufe genau dann, wenn eigene PMC-Einrichtungen eingebaut
  sind; fremde Geschwister-Slots entfallen (11.2-Regel). Traegt die CEB kein PMC: KEIN
  Eintrag beim Kind (PM-2 -- nie eine leere Form als "Projektion"). Konsequenz und
  W2-Aufloesung: §7.
* **(PM-9) EXAKTHEIT + VENDOR-RIEGEL.** Fuer die Gueltigkeit eines Mess-Stands gilt
  GLEICHHEIT von Vendor UND Belegung (M-9/12.2 unveraendert: jede Aenderung = anderes
  Kompilat = anderer Stempel, KON34-05). Das Lager paart NIE amd gegen intel und NIE
  pmc-tragend gegen pmc-frei; Overhead ist die Differenz zweier Messungen desselben Vendors
  (K5-Doktrin; Paar-Mechanik 11.3: je Paar genau EIN Schalter-Unterschied).
* **(PM-10) CPU-PFLICHT BLEIBT.** Die pmc-Eintrags-Version traegt `.c` vor dem pmc-Flag
  (F-10/M-10; die Registry-Batterie erzwingt `c` heute schon, `pmc_vendor_registry.hpp:85-89`).
  cpu_sub-Duplikatverbot M-11 gilt mit (`c{p.p}` ROT).

---

## 4. Fuenf durchgerechnete Beispiele

### BP-1 · Der heutige IST als Grammatik-Wert: CEB-only

    pmc=amd@1.0.0.c.pmc{b}

    Parse (Pre-Order, Tiefe):  c(0) · pmc(0) · b(1)
    Phase 1: Probe-Befund amd auf prod1 -> Freigabe via System-Proxy
    Phase 2: CEB baut die amd-Einrichtung an sich selbst (misst UM das Kind herum,
             Pinning-Permutation via System-Achse)
    Phase 3: Kinder tragen KEINE eigene PMC-Einrichtung; ihr Stempel fuehrt den Eintrag
             pmc-fuehrend mit (PM-8) -- Kind-Zeile: pmc=amd@1.0.0.c.pmc{b}
    Heutige Renderer-Form pmc=amd@1.0.0.c (ceb_version_stamp) ist die belegungs-freie
    Vorstufe; der pmc{b}-Schwanz macht die Stufen-Dimension explizit (Bau-Naht §9/C).

### BP-2 · Voll-Belegung: die permutierende Einrichtung auf allen drei Stufen

    pmc=intel@1.0.0.c.pmc{b.h.t}

    Alle drei Stufen tragen eingebaute PMC-Einrichtungen (Nenner-Erweiterung maximal).
    Kind-Projektionen (PM-8, analog 11.2):
        Tier    pmc=intel@1.0.0.c.pmc{b.t}     (eigene Stufe + fuehrendes b)
        Hybrid  pmc=intel@1.0.0.c.pmc{b.h}     (fremder Geschwister-Slot entfaellt)
    Spiegel-Ordnung (PM-6): steht die m-Anordnung derselben Zeile auf b.h.t, ist
    pmc{t.b} Formfehler der Wache (nicht des Parsers).

### BP-3 · Abwesenheit -- der Nichtfall wird nicht geschrieben

    (Mess-Zeile OHNE pmc-Eintrag)

    Fall 1: Host ohne PMC (Probe fail-closed) -- nichts freigebbar.
    Fall 2: Host MIT PMC, Kompilat ohne Einbau (die pmc-lose Haelfte der
            Overhead-Permutation) -- "nur Eingebautes".
    BEIDE Faelle: byte-identischer Stempel zum Vor-PMC-Stand (am Objekt schon so gebaut:
    ceb_pmc_segment_len()==0). KONTRAST zu G-1: m{b.t} (alles aus) ist ein WERT mit
    Zeigern je Stufe; die PMC kennt keinen solchen Wert (F1: "wird gar nicht erst eine
    eingetragen"). Die Aussage "PMC war da, aber aus" lebt im Planer-Befund/Plan (Phase 1),
    nicht im Stempel.

### BP-4 · Das Overhead-Paar (Paar-Doktrin 11.3, K5)

    Kompilat A:  ...c.m{b{w}.t{ma.mi}}   +   pmc=amd@1.0.0.c.pmc{b.t}
    Kompilat B:  ...c.m{b{w}.t{ma.mi}}   +   (kein pmc-Eintrag)

    Je Paar genau EIN Schalter-Komplex Unterschied: die PMC-Belegung. Die Differenz der
    beiden Messungen IST der PMC-Overhead (Owner 10.08.: der Binary Overhead eingebauter
    Messfuehler "unterscheidet/reduziert" sich -- exakt darum ist die PMC eine EIGENE
    permutierende Achse und kein Immer-an). NIE amd gegen intel paaren (PM-9); das
    intel-Gegenstueck ist ein EIGENES Paar auf prod2.

### BP-5 · Die W7-Andockstelle: Intel "effektiv 2 PMC" -- beide Formen (Entscheid W7, §8)

    Option A (Sub-Flags, cpu_sub wiederverwendet):
        pmc=intel@1.0.0.c{p.e}.pmc{b}      -- EINE CEB traegt beide Domaenen-Fuehler;
        pmc=intel@1.0.0.c{p}.pmc{b}        -- P-Domaene allein (Pinning-Lauf 1)
        pmc=intel@1.0.0.c{e}.pmc{b}        -- E-Domaene allein (Pinning-Lauf 2)
    Option B (Vendor-Auffaecherung der Registry):
        pmc=intel_p@1.0.0.c.pmc{b}  und  pmc=intel_e@1.0.0.c.pmc{b}   -- zwei Werte,
        zwei Kompilate (PM-3: je Kompilat genau ein Wert)
    Beide sind von der EBNF §3.1 heute schon erzeugbar bzw. rein ADDITIV (B: neue
    Registry-Werte; Hardware-Erweiterung ist additiv-Doktrin) -- W7 muss die Grammatik
    NICHT umbauen.

---

## 5. Die Negativ-Batterie (was die Pruefsyntax ablehnt)

    pmc=amd@1.0.0.c.pmc            ROT: Flag ohne Stufe -- Abwesenheit hat KEINE
                                        leere Form (PM-2/PM-4)
    pmc=amd@1.0.0.c.pmc{}          ROT: leere Gruppe (v2-R4)
    pmc=amd@1.0.0.c.pmc{t}         ROT: t ohne b -- CEB-Voraussetzung (PM-5)
    pmc=amd@1.0.0.c.pmc{b.b}       ROT: Stufen-Duplikat (PM-4)
    pmc=amd@1.0.0.c.pmc{b{w}}      ROT: Tiefe 2 -- Stufen sind Blaetter; w gehoert
                                        der m-Grammatik (PM-4)
    pmc=arm@1.0.0.c.pmc{b}         ROT: katalogfremder Vendor (Registry fail-closed;
                                        eine dritte Hardwareform bricht per
                                        kPmcVendorCount-Anker compile-time)
    pmc=amd@1.0.0.pmc{b}           ROT: CPU-Pflicht verletzt, kein c (PM-10/B12)
    pmc=amd@1.0.0.c{p.p}.pmc{b}    ROT: cpu_sub-Duplikat (M-11-Erbe)
    pmc=amd@1.0.0.c.x512{f}.pmc{b} ROT: Hardware-Flag auf der pmc-Eintrags-Version --
                                        die Produktion §3.1 ist abschliessend
    pmc=amd@1.0.0.c.m{b}           ROT: m ist der measurement_tooling-Version
                                        vorbehalten; Katalog-Trennung (§9/B)
    pmc=amd@... UND pmc=intel@...  ROT: zwei Eintraege/zwei Werte in einem Stempel --
       in EINER Zeile                   ein Host, ein Kompilat, ein Wert (PM-3;
                                        #error-Wache am Objekt)
    pmc-Eintrag auf System-/       ROT: Zeilen-Exklusivitaet -- der Eintrag wohnt im
       Organ-Zeile                      Meta-Meta-Segment der MESS-Zeile (§3.1)
    m{...} traegt 'pmc' als Token  ROT: pmc ist KEIN viertes Instrument unter b --
       (z.B. m{b{w.pmc}})               vom Owner ausdruecklich verworfen (F-G1-8)

    WICHTIG (wie G-1 B-5): fast alle Formen sind fuer den PARSER wohlgeformt -- er prueft
    die FORM; die Ablehnung ist Sache der pmc-Wachen (dieselbe Arbeitsteilung wie v2/S2).

---

## 6. Die Dreiphasigkeit ausgeschrieben: Erkennung -> Proxy -> permutierende Einrichtung

    PHASE 1a  PLANER (Laufzeit, JE LAUF)     pmc_host_probe: cpuid-Vendor + Koeder-Biss;
              -- die AUSNAHME (F2): die       fail-closed. Der Befund traegt den Nenner
              EINZIGE Hardware-Erkennung      (PmcHostBefund). KEINE andere Achse erbt
              im Planer, NUR fuer PMC         diese Ausnahme.
    PHASE 1b  SYSTEM-ACHSE ALS PROXY (F2)    die Freigabe wird AN die System-Achse
                                              durchgereicht; sie "fungiert nur als Proxy"
                                              und gibt PMC "als Hardware-Eigenschaft und
                                              eigene Meta-Meta-System-Achse" frei -- der
                                              Proxy ist Durchleitung, KEINE zweite Heimat.
    PHASE 2   CEB (Compile)                  CT-Einbau von Vendor + Belegung (heute:
                                              COMDARE_ENABLE_PMC + COMDARE_PMC_VENDOR ->
                                              COMDARE_CEB_HAT_PMC_GLIED; Ziel: je Stufe
                                              eigene Einbau-Gates, §9/D).
    PHASE 3   TIER/HYBRID (Ziel)             Vertrag der PERMUTIERENDEN Einrichtung:
                                              Kind-Einrichtungen pmc-bedingt gebaut,
                                              Kind-Stempel pmc-fuehrend (PM-8); das
                                              P/E-Pinning bleibt SYSTEM-Achsen-Permutation
                                              (Owner 06.08. Punkt 5), nicht PMC-Sache.

**DURCHREICHEN + KOMPILATE (F8):** die zwei Systeme amd/intel werden (a) ueber genau diese
Phasen-Kette KOMMUNIZIERT (Befund -> Proxy -> Bau-Parameter -> Kind-Bau) und (b) durch
GETRENNTE KOMPILATE ABGEBILDET -- je Vendor-Maschine ihre eigene Kompilat-Welt mit eigener
Komponenten-Version; die CI erzwingt beide Welten hart (Lanes amd+intel, PMU-Exklusivitaet
je Host per resource_group).

**NENNER-ERWEITERUNG, Zaehlweise getrennt (F1):** KON25-03 bleibt der w/ma/mi-Kern
(32 = 2^5). Die PMC multipliziert als EIGENE, ZUSAETZLICHE Achse dazu -- strukturell je
pmc-Host: {kein Eintrag} + die b-fuehrenden Stufen-Mengen {b}, {b.h}, {b.t}, {b.h.t}
= **5 Zustaende** (unter PM-5; ohne PM-5 waeren es 1+7=8). Strukturelles Maximum je
pmc-Host damit 32 x 5; auf einem PMC-losen Host degeneriert der Faktor zu 1 (nur "kein
Eintrag"). Die Vendor-Dimension multipliziert NICHT je Host (ein Host = ein Vendor),
sondern trennt Mess-Welten ueber die Maschinen. **WIE VIELE Zustaende real gefahren
werden, rechnet AUSSCHLIESSLICH die Planer-Simulation S-19** (KON37-03/KON41-03; die
Grammatik zaehlt nicht, sie benennt). Belegungs-Welt bleibt von Dock-Zahl/
Schicht-Groessen ENTKOPPELT (32er-Fallen-Korrektur, KON65-03).

---

## 7. Die W2-Alias-Aufloesung: "Tier-Fingerprint pmc-frei" gegen die Dreiphasigkeit

**Der Konflikt (KON64-03 Marker-Pflicht 3):** die KON34-02-Karte (Ledger :4419; historische
Adresse :3518) und die System-A/B-Karte (:4079) fuehren PMC als *"CEB/Host [...] nicht im
Tier-Kompilat -- Tier-Fingerprint pmc-frei"*; Commit f4dcc234 landete ausdruecklich
"Tier-Seite unberuehrt". Die F1-Entscheidung stellt PMC dagegen DREIPHASIG "auf CEB UND
Tier/Hybrid" als permutierende Messeinrichtung. Ein pmc-blinder Kind-Stempel waere exakt
die Alias-Klasse der w-Blindheit (G-1 M-8): zwei Kind-Kompilate -- eines unter einer
pmc-CEB gebaut/vertragen, eines nicht -- truegen EINEN Stempel (verboten per KON34-05
"Die Mess-Schalter ... aendern das Kompilat und den Stempel" + B11-Doktrin).

**Die Aufloesung -- der pmc-fuehrende Kind-Stempel analog w (PM-8, Muster G-1 §11.2):**

1. Traegt die erzeugende CEB die PMC, fuehrt die Kind-Mess-Zeile den pmc-Eintrag mit
   `b` VOR der eigenen Stufe (pmc-fuehrend); die eigene Stufe steht genau dann dabei,
   wenn das Kind eigene Einrichtungen traegt (BP-1/BP-2).
2. Damit Stempel-Differenz IMMER Kompilat-Differenz ist (kein Alias in KEINER Richtung),
   muessen die tier-/hybrid-seitigen PMC-Vertrags-Einrichtungen pmc-BEDINGT GEBAUT werden
   -- das exakte Gegenstueck zur w-Regel "Die Tier-Gates bleiben -- gebaut werden sie nur
   noch, wenn die erzeugende CEB Wallclock traegt" (KON37-01-B3; fuer w owner-final per
   KON65-02 Option (a)). Das IST genau der Bau-Inhalt von F1 ("auf CEB UND Tier/Hybrid
   einzutragen als PERMUTIERENDE Messeinrichtung").
3. Der Satz "Tier-Fingerprint pmc-frei" wird damit zur HISTORIE des CEB-only-IST: nach
   Owner-GO erhaelt die KON34-02-Zeile (und :4079) einen datierten UEBERHOLT-Marker
   (Doku-Doktrin: Original bleibt stehen) -- analog dem bereits gesetzten Marker am
   06.08.-PMC-Plan :363 (KON65-03, Marker-Pflicht 1).
4. **Zeit-Anker W2:** der Bau haengt am Mess-Schalter-Paket B1-B5 (Task #24, W2-Anteil)
   und am KON37-02-Registry-Neubau (§9/F) -- KEIN Bau aus diesem Dokument.

Die Nicht-Injektivitaet des WERTS (derselbe Eintrag als Kopf- und als Kind-Form) bleibt wie
bei G-1 unschaedlich: Rolle und Herkunft liegen am TRAEGER (welcher Stempel die Zeile
fuehrt), und der Kind-Stempel ist der KOMPILAT-Stempel als Ganzes (G-1 §11.1).

---

## 8. Die W7-Andockstelle: P/E-Domaenen ("Intel effektiv 2 PMC") -- beide Formen, Empfehlung

Owner-Woerter im Spann: *"Damit hat die Intel Maschine effektiv 2 PMC"* (06.08.) UND
*"Die CEB kann beide Messfuehler tragen [...] reine Wiederverwendung durch
Achsen-Permutation [...] auf einer dafuer zustaendigen SYSTEM-Achse"* (06.08., Punkt 5,
Mechanik-Korrektur) UND *"es sind 2 verschiedene hardware Komponenten"* (10.08., ueber
amd/intel). P/E-Core ist per #21 nach **W7** verschoben -- dieses Design haelt NUR die
Andockstelle offen; beide Optionen sind ohne Grammatik-Umbau erreichbar (BP-5):

* **Option A -- Sub-Flags (cpu_sub wiederverwendet):** die PMU-Domaene faehrt als
  `c{p}` / `c{e}` / `c{p.e}` auf der pmc-Eintrags-Version. KEIN neues Token; deckt "eine
  CEB traegt beide Messfuehler" (c{p.e}-Kompilat) woertlich; die Domaenen-WAHL je Lauf
  bleibt System-Achsen-Permutation (Pinning), exakt wie der Owner die Mechanik korrigiert
  hat; die Registry bleibt bei ZWEI Hardware-Komponenten (10.08. woertlich). Kosten: das
  cpu_sub-Vokabular p/e traegt auf dieser einen Zeile die Zusatz-Lesart "PMU-Domaene"
  (fuer eine PMU ist das dieselbe Aussage: die P-Core-PMU ist die PMC der P-Kerne).
* **Option B -- Vendor-Auffaecherung:** die Registry faechert auf (z.B. `intel_p`,
  `intel_e`; bis zu 4 Domaenen laut 06.08.-Plan). Traegt das Owner-Wort "effektiv 2 PMC"
  woertlich in die Werte-Menge; Konsequenz aus PM-3: je Domaene ein EIGENES CEB-Kompilat
  (das 06.08.-Plan-Angebot O-A "zwei CEB-Kompilate auf prod2"). Kosten: "eine CEB traegt
  beide" ist dann NICHT ausdrueckbar; die Zwei-Komponenten-Aussage des 10.08. wird zur
  Vier-Werte-Menge.

**Empfehlung: Option A.** Sie haelt alle drei Owner-Worte gleichzeitig (zwei Komponenten
in der Registry · eine CEB kann beide Fuehler tragen · Domaenen-Wahl = System-Permutation)
und braucht null neue Token. Option B bleibt additiv nachruestbar, falls W7 getrennte
Kompilate je Domaene verlangt. **Entscheid faellt in W7, nicht hier** (F-P7).

---

## 9. Der Compile-Time-Durchsetzungsweg (sechs Stufen, kein neuer Parser; Anschluss KON37-02)

* **Stufe A -- Parser: NULL Aenderung.** Beweis-Batterie: BP-1...BP-5 und die
  Negativ-Batterie als `static_assert(parse_algo_semver(...))`-Pins (der Parser akzeptiert
  die FORMEN; abgelehnt wird in C). Tiefe 1 <= 4, Knoten <= 7 << 96 -- am Objekt gedeckt.
* **Stufe B -- der PMC-Katalog als EIGENE Mini-Tabelle** `kPmcGrammarCatalog` im Mess-Home
  (Muster kMessGrammarCatalog, G-1 Stufe B): **4 (token,eltern)-Paare**: (`pmc`,"") ·
  (`b`|`h`|`t`, `pmc`). Die Vendor-IDs sind KEINE Katalog-Token, sondern WERTE aus
  `kPmcVendorRegistry` (PM-3). **AUSDRUECKLICH NICHT:** `pmc` in den Hardware-Katalog oder
  in den kMessGrammarCatalog eintragen -- das legalisierte `pmc` still auf fremden
  Zeilen/unter `m` (F-G1-8-Verwerfung wuerde still rueckgaengig). Kollisions-Erhebung
  15.08.: `"pmc"`/`"amd"`/`"intel"` 0 Treffer im 62er-Hardware-Katalog, Positiv-Kontrolle
  `"bw"` beisst (§1).
* **Stufe C -- die Form-Wachen ("Pruefsyntax des Homes").** ZWEI Praedikate, weil zwei
  Versions-Ebenen (§3.1): `pmc_component_version_is_wellformed()` fuer die BELEGUNGS-FREIEN
  Registry-Literale (uebernimmt die heutige Batterie `pmc_vendor_versionen_wohlgeformt`,
  `pmc_vendor_registry.hpp:68-89`, und verbietet dort JEDEN pmc-Schwanz) und
  `pmc_entry_version_is_wellformed()` fuer die GERENDERTE Eintrags-Form (v2-Form +
  c-Pflicht + cpu_sub-Duplikatverbot + pmc-Katalog + PM-2/PM-4/PM-5: genau ein pmc-Flag,
  >= 1 Stufe, je <= 1, Blaetter, b-Pflicht bei t/h). Dazu die ZEILEN-Wachen: hoechstens
  EIN pmc-Eintrag je Mess-Zeile (PM-3); pmc-Stufen <= m-Slots + Spiegel-Ordnung (PM-6,
  zeilen-uebergreifendes Praedikat am ganzen Mess-Zeilen-Wert); `pmc` bleibt auf System-/
  Organ-Zeilen und unter `m` ROT. Jede Wache mit LESBARER Meldung (erst laute
  Compile-Fehler, dann verschieben -- Hausdoktrin).
* **Stufe D -- Einbau-Aequivalenz + Projektion am Emissions-Punkt.** Die
  Abwesenheits-Semantik wird BEIDSEITIG erzwungen: Einrichtung eingebaut OHNE Eintrag =
  Compile-Fehler (stiller Alias) UND Eintrag OHNE eingebaute Einrichtung = Compile-Fehler
  (Phantom) -- das Praedikaten-Muster existiert (`COMDARE_CEB_HAT_PMC_GLIED` liest heute
  EINE Bedingung fuer Laenge UND Renderer; Ziel: je Stufe ein Gate-Paedikat). Dazu
  `pmc_projektion(vertrag, stufe)` (constexpr ueber `for_each_flag_node` + Renderer) mit
  `static_assert(pmc_projektion(kCebPmcEigenschaft, 't') == kZielPmcEintrag)` am
  CEB-Emissions-Punkt -- dieselbe Filterketten-/Korrelations-Mechanik wie G-1 Stufe D
  (KON9-06/KON37-02). Der RT-Gegeneingang am Lauf-Host bleibt (`pmc_startup_pruefung`,
  Phase-1-Wahrheit ist Laufzeit-Wahrheit).
* **Stufe E -- Freigabe-Relation, PMC-Sonderweg.** "gefordert <= freigegeben" hat hier eine
  LAUFZEIT-Quelle (Probe-Befund je Planer-Lauf, F2-Ausnahme) statt einer reinen
  CT-Tabelle: der Befund tritt als Bau-Parameter (heute `-DCOMDARE_PMC_VENDOR=...`) in die
  CT-Welt ein; fail-closed in jeder Lage (unbekannter Vendor/keine Probe => keine
  Freigabe => kein Eintrag). Die S-3-Teilmengen-Relation wird NUR freigabeseitig
  wiederverwendet; Gueltigkeit bleibt Gleichheit (PM-9).
* **Stufe F -- Anschluss an den Registry-Neubau (KON37-02).** Der owner-beschlossene
  Neubau ("direkt neu nach der geaenderten Architektur. Das alte archivieren." --
  `<measurement_tooling>` erhaelt die Stufen-Dimension tier/hybrid/ceb) bekommt die
  PMC-SCHWESTER-SPALTE: ein `<pmc>`-Element mit derselben Stufen-Dimension (Vendor kommt
  NIE aus der XML, sondern aus dem Probe-Befund des Laufs -- die XML sagt WO eingebaut
  werden soll, der Host sagt OB und WELCHER Vendor). Aufloesung -> EIN pmc-Eintrag je
  Vertrag ("eine Aufloesung, zwei Verbraucher": Stempel-Glied + Bau-Gates). Die
  KORRELATIONS-PFLICHT (KON37-02) gilt woertlich: Freigabe (Planer, Laufzeit) und
  Ausfuehrung korrelieren ueber die Permutation einer freigegebenen Konfiguration per
  compile time der hoeheren Traeger-Stufe. Der WARNING->FATAL-Flip bei ON-ohne-Vendor
  (CMakeLists.txt, angekuendigt "NACH dem Super-Nachzug") gehoert sachlich in dieses
  Paket (F-P9).

---

## 10. Abgrenzung zu G-1 (m-Grammatik) -- die Sonder-Grammatik in einer Tabelle

| Merkmal | **G-1 `m`** (Mess-Belegung) | **G-1P `pmc`** (dieser Entwurf) |
|---|---|---|
| Traeger im Stempel | `measurement_tooling`-Version der Mess-Zeile | EIGENER Meta-Meta-Eintrag `pmc=<vendor>@...` der Mess-Zeile |
| Abwesenheit | leere Zeile = "Mess-Welt nicht dabei"; `m{b.t}` = dabei, alles aus (Zeiger je Stufe) | **KEIN Eintrag** -- fuer Hardware-Fehlen UND Nicht-Einbau gleichermassen; es gibt KEINEN Aus-Wert |
| Leere Slots | ZULAESSIG und bedeutungstragend (F-G1-6: nur dreiphasig/Mess) | **VERBOTEN** -- jede genannte Stufe traegt eingebaut (F1-Sonderregel) |
| Wert-Dimension | Belegungs-MENGE je Stufe (w/ma/mi) | Vendor-WERT (amd|intel, geschlossen, je eigene Version) + Stufen-MENGE |
| Phasigkeit | dreiphasig Planer->CEB->Ziel, zweimal parallel | dreiphasig MIT Phase-1-AUSNAHME: Planer-HW-Erkennung NUR hier; System-Achse als PROXY |
| Nenner | der 2^5-Kern (KON25-03) | ZUSAETZLICHE multiplizierende Achse (je pmc-Host strukturell 5 Zustaende unter PM-5); Vendor trennt Welten ueber Maschinen |
| Kind-Stempel | w-fuehrend (11.2, KON65-02) | **pmc-fuehrend** analog w (PM-8, §7) |
| Tiefe unter der Wurzel | 2 (Stufe -> Instrument) | **1** (Stufen sind Blaetter) |
| Katalog | kMessGrammarCatalog, 13 Paare | kPmcGrammarCatalog, **4 Paare** + Vendor-WERTE aus kPmcVendorRegistry |
| Parser | `parse_algo_semver` | **DERSELBE** (Profil, PM-1) |

Gemeinsam bleibt (bewusst): Punkt-Notation, Klammerformen, X.Y.Z-Zahlenwelt, CPU-Pflicht,
(token,eltern)-Paar-Identitaet, Nicht-Normalisierung, Exaktheits-Doktrin der Gueltigkeit,
Stufen-Vokabular b/h/t.

---

## 11. Was dieser Entwurf NICHT festlegt (Grenzen, mit Begruendung)

1. **KEIN BAU.** Jede Zeile ist Vorlage; Bau erst nach Owner-GO, als Stempel-Strecken-/
   W2-Posten (Mess-Schalter B1-B5 #24, KON37-02-Neubau, G-1-Bau); Fable 5 max bleibt die
   Strecken-Auflage (KON38).
2. **Die P/E-Domaenen-Entscheidung** -- W7 per #21; hier nur die Andockstelle (§8).
3. **Die Fahr-Zahl** -- S-19 rechnet; die Grammatik benennt (§6).
4. **Die exakte Objekt-Naht der Kind-Einrichtungen** (welche Gates im Tier-/Hybrid-Bau
   pmc-bedingt entstehen) -- Bau-Explore am dann gebauten Objekt (Muster 11.4-Entscheid
   "am Objekt", nicht im Design).
5. **Die Lastsequenz-Achse** -- eigenes Schwester-Design NACH ihrem 10-Wochen-Explore
   (Owner-Pflicht, F-G1-9/KON64-03); dieses Dokument greift ihr nicht vor.
6. **Der Verbleib der 7 Mess-Kategorien** (CACHE_MISS_L1...ENERGY_J am collector-Baustein)
   -- Daten-Taxonomie, nicht Grammatik; Klaerung im KON37-02-Neubau (F-P8-Anteil).

---

## 12. Offene Owner-Entscheide (nummeriert)

* **F-P1 · Profil + Eintragsform:** PMC-Grammatik als v2-PROFIL (EIN Parser); Eintragsform
  `pmc=<vendor>@X.Y.Z.c.pmc{<stufen>}` -- Root-Token `pmc` (== kPmcStampName, Kollision
  0 Treffer mit Positiv-Kontrolle), Stufen-Vokabular b/h/t wiederverwendet.
  Bestaetigen? *(Empfehlung: ja -- Drift-Doktrin "eine Grammatik existiert nur einmal";
  der Namens-Doppelklang pmc=...pmc{...} ist Selbstbeschreibung, Kosten 4 Zeichen.)*
* **F-P2 · Zweifache Abwesenheit:** KEIN Eintrag sowohl bei fehlender Hardware ALS AUCH
  bei vorhandener-aber-nicht-eingebauter PMC (Stempel = nur Eingebautes; die
  Unterscheidung lebt im Planer-Befund der Phase 1). Bestaetigen? *(Empfehlung: ja --
  deckt F1 verbatim und den gebauten ceb_pmc_segment_len()==0-Zustand.)*
* **F-P3 · CEB-Voraussetzung als FORM-Regel:** `pmc{t}`/`pmc{h}` ohne `b` = Formfehler
  (PM-5; Owner 10.08. + Stufen-Ordnung KON65-02). Bestaetigen? *(Alternative: nur
  freigabeseitig verbieten und die Form offen lassen -- dann truege die Grammatik
  Zustaende, die nie gebaut werden duerfen.)*
* **F-P4 · Slot-Deckung + Spiegel-Ordnung:** pmc-Stufen sind Teilmenge der m-Slots
  derselben Zeile, Reihenfolge spiegelt die m-Anordnung (keine zweite
  Anordnungs-Wahrheit). Bestaetigen? *(Alternative: freie Ordnung als eigene Information
  nach M-6 -- dann sind pmc{b.t} und pmc{t.b} ZWEI Werte; Empfehlung: Spiegel-Pflicht.)*
* **F-P5 · pmc-fuehrender Kind-Stempel + Kompilat-Konsequenz:** Kind fuehrt den Eintrag
  mit `b`, eigene Stufe nur bei eigenem Einbau; tier-/hybrid-seitige
  PMC-Vertrags-Einrichtungen werden pmc-BEDINGT gebaut (Stempel-Differenz =
  Kompilat-Differenz, analog w/KON65-02); danach datierter UEBERHOLT-Marker an die
  Ledger-Zeilen "Tier-Fingerprint pmc-frei" (KON34-02 :4419, System-A/B :4079).
  Bestaetigen? *(Das ist die W2-Alias-Aufloesung aus KON64-03 Marker-Pflicht 3, §7.)*
* **F-P6 · Nenner-Zaehlweise:** je pmc-Host strukturell 5 Zustaende (kein Eintrag + 4
  b-fuehrende Stufen-Mengen) multiplizierend zum 2^5-Kern; Vendor trennt Mess-Welten
  ueber Maschinen (multipliziert nicht je Host); real gefahren rechnet S-19.
  Bestaetigen? *(Nur die ZAEHLWEISE; keine Fahr-Zahl.)*
* **F-P7 · W7-Andockstelle P/E:** Option A (cpu_sub `c{p}`/`c{e}`/`c{p.e}` auf der
  pmc-Eintrags-Version; eine CEB kann beide Domaenen tragen, Pinning bleibt
  System-Achse) vs Option B (Vendor-Auffaecherung intel_p/intel_e, je eigenes Kompilat).
  *(Empfehlung: A; Entscheid erst in W7 noetig -- beide additiv, §8.)*
* **F-P8 · Typ-Heimat:** die eigenstaendige Achse als ZWEITER Traeger der gebauten
  CRTP-Wurzel (`PmcMeasurementMetaMetaAxis : MeasurementMetaMetaAxis<...>`;
  Vorbild load_framework), `pmc_vendor_registry` bleibt Identitaets-Quelle,
  `pmc_host_probe` bleibt Erkennung; `PmcSystemAxis` BLEIBT im collector als der
  System-PROXY, den F2 der System-Achse ausdruecklich zuweist (KEIN K1-artiger
  Voll-Umzug). Bestaetigen? *(Alternative: Voll-Umzug wie load_framework -- dann braucht
  die F2-Proxy-Rolle einen neuen System-Traeger.)*
* **F-P9 · Abloesung des Ad-hoc-Mechanismus:** die #if-Kaskade
  (`COMDARE_CEB_HAT_PMC_GLIED`) wird beim Achsen-Bau auf die Katalog-/Praedikat-Form
  umgestellt (Renderer bleibt); der WARNING->FATAL_ERROR-Flip bei ON-ohne-Vendor kommt
  in DIESES Paket. Bestaetigen?
* **F-P10 · XML-Form im KON37-02-Neubau:** `<pmc>`-Element mit Stufen-Dimension analog
  dem erweiterten `<measurement_tooling>`; Vendor NIE aus der XML (nur aus dem
  Probe-Befund des Laufs) -- XML sagt WO, der Host sagt OB/WELCHER. Bestaetigen?

---

## 13. Erhebungs-Anhang: Zahlen mit Nenner, Fundstellen, Nichtfunde

* **Registry am Objekt:** `pmc_vendor_registry.hpp` 167 Zeilen; 2 Eintraege (`:60-63`),
  beide Version `"1.0.0.c"`; 9 static_assert-Wachen (davon 1 #if-geschartet; grep
  'static_assert' = 11 Zeilen, 2 davon Kommentar-Nennungen) inkl. paarweise-verschieden
  (`:105-132`) und Namens-/Erkennungs-Anker; `kPmcStampName` (`:136`); fail-closed-Lookups
  (`:154-165`); B12-Batterie auf `ce_owned_version_is_wellformed` (`:68-89`).
* **Stempel-Glied:** `ceb_version_stamp.hpp:270-345` -- #error-Kaskade, EIN Praedikat,
  Segment-Laenge inkl. fuehrendem ';', 0 bei pmc-losem Bau.
* **CI:** `.gitlab-ci.yml` -- `.pmc`-Template `:186-225`, `COMDARE_PMC_LANES` Default
  "amd intel" (`:66`), resource_group pmu-prod1/pmu-prod2, HART (kein allow_failure).
* **Kollisions-Erhebung (15.08., dieser Entwurf):** `"pmc"` 0 · `"amd"`+`"intel"` 0
  Treffer in `flag_grammar_catalog.hpp`; Positiv-Kontrolle `"bw"` = 2 Treffer am selben
  Kommando (`/usr/bin/grep -c`).
* **Nichtfund G-1-Bau (Gegenprobe):** `kMessGrammarCatalog|mess_version_is_wellformed`
  ueber `libs/` = 0 Treffer -- G-1 ist Design-Stand, planmaessig; dieser Entwurf haengt
  an dessen BAU (Stufe B/C-Muster), nicht an einem Phantom-Bestand.
* **Owner-Worte (alle nachgelesen):** F-G1-8-Korrektur Transkript 5a19728e:55073 /
  KON64-03 (Ledger :438-441) · F1/F2/F8 kon64_sammlung.md Teil 5 (:163-199) / KON65-03
  (Ledger :266-303) · Owner 10.08. wortgleich `pmc_vendor_registry.hpp:4-10` · P/E-Kern
  06.08. mx_result_voll.json pmc.owner_entscheide (Memory-verbatim) · KON37-02 Ledger
  :3449-3470 · Marker-Pflicht 3 Ledger :450-456 · KON34-02-Karte :4419 · System-A/B
  :4079 · G-1 §12.5 (`20260813-DESIGN-g1-...md:816-841`) · G-1 §11.1/11.2 (Kind-Stempel/
  w-fuehrend :582-631) · KON65-02 (w final, Ledger :235-247).
* **ce-Stand der Objekt-Lesungen:** `04f76b65` (development); der wf_6b1d9de5-Explore mass
  @ `4f18f478` -- alle hier zitierten PMC-Fundstellen am neueren Stand reproduziert.
