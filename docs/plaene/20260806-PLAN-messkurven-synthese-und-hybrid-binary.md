# Messkurven-Synthese, beste Binaries und die Hybrid-Binary

**Stand:** 06.08.2026 abends · **Klasse:** NACH-ABGABE, Lieferpflicht bis 15.09.2026
**Pfad-Kuerzel:** `SUPER` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine` ·
`CE` = `SUPER/Code/external/comdare-cache-engine` · `LEDGER` =
`SUPER/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`

**Was dieses Dokument ist:** die Zusammenfuehrung eines Strangs, der heute an vier Orten
verstreut liegt (Owner-Verbatim im Ledger, F8-Entscheid, Hybrid-SOLL-Design im ce, Atlas-
Zukunftssektion) und im TODO-Register **nur mit einem** seiner vier Glieder auftaucht.
Jede Aussage traegt eine Fundstelle. Wo der Plan schweigt, steht das mit Nenner da.

---

## 1. Die Einordnung des Owners

**Verbatim (06.08.2026 abends):**

> "Nun die **geplante Auswertung der Binaries mit bestimmen der besten Binaries aus der
> Messkurven-Synthese** ist ja **nach der Abgabe morgen dran** und sie ist **ebenfalls
> detailliert geplant**. Das ist ein **Teil der Hybrid-Binary Definition und deren
> Funktionalitaet-Voraussetzung**."

Der Satz legt drei Dinge fest:

**(1) Terminlich: nach der Abgabe.** Die Auswertungs-Strecke ist kein Vor-Abgabe-Posten. Das
entlastet den 07.08. Es entlastet aber nicht die Verbuchung -- ein Posten ohne Registerzeile
faellt zwischen die Stuehle, unabhaengig von seinem Termin (§6, §7 dieses Dokuments).

**(2) Erkenntnistheoretisch: sie ist geplant, also gelesen statt geraten.** Das ist heute
dreimal ausdruecklich geruegt worden. Dieses Dokument ist die Einloesung: es zitiert die
Planung, es erfindet sie nicht.

**(3) Sachlich: sie ist Teil der Hybrid-Binary-**Definition**, nicht ihre Konfiguration.**
Das ist die staerkste der drei Festlegungen und in §3 am Beleg aufgeloest: die Auswertung
liefert den *Inhalt* der Hybrid-Binary, nicht bloss ihre Einstellungen. Owner `LEDGER:4176`
sagt es mit dem Verb: die ueber multiple Lasten bestimmten multiplen besten Binaries
"**erzeugt**" das Hybrid-Tier-Binary. Die Auswertung ist der Konstruktor.

---

## 2. Was der Plan sagt

### 2.1 Die autoritative Fassung: Owner-Verbatim `LEDGER:4176` (05.08., Atlas-Review Runde 5)

> "...zweitens werden fuer das **Finden der optimalen binary** dann ja im voll-Lauf die
> **Messwerte ausgewertet (steht im Plan!)**, die Messwerte zu **Messkurven synthetisiert**,
> die Messkurven **je Eingangslast verglichen**, um die **beste binary zu finden**, die man
> dann nochmal im **release Modus ohne Mess-Einrichtungen neu kompiliert** und nochmal
> **wallclock time misst**. An dieser stelle koennen dann auch **ueber multiple Lasten
> multiple beste Binaries bestimmt** werden, die ueber eine **Erkennungsheuristik der Last**
> ein **Hybrid-Tier-binary zur aktiven runtime Auswahl der optimalen Tier-Binaries erzeugt**."

**Diese Fassung gilt.** Sie ist Owner-Wortlaut, sie ist die juengste (05.08.), und sie ist die
einzige, die alle sieben Schritte in einer Kette nennt. Alle folgenden Quellen sind
Praezisierungen oder Teilsichten davon.

### 2.2 Die Mathematik-Spezifikation: F8

`LEDGER:2296` -- **F8 [ENTSCHIEDEN -- Hybrid-DoD = minimale Baseline + Spline-Heuristik;
ABGABE-PFLICHT]**, verbatim (Auszug):

> "Die Messungen muessen eine **Spline-Funktion auf jeder Achse** fuer die Modellierung der
> wichtigsten gemessenen numerischen Parameter bereitstellen, um diese Funktionen als
> **Heuristik-Abschaetzung** zu nutzen: bei Eingabe einer Anfrage auf das Interface
> (klassifizierte Operationen x Workload) **rueckwaerts die optimale Binary mit den optimalen
> Algorithmen-Saetzen** ... zu laden."

`LEDGER:2301` -- **Ergaenzung F8, Break-Even-Mathematik**, verbatim (Auszug):

> "Switch-Thresholds = **Schnittpunkte zwischen den f(x)-Spline-Funktionen** der
> Performance-Modellierungen zweier Algorithmen derselben Achse (Beispiel: Allokatoren fuer
> grosse vs kleine Dateien -- Kurven uebereinandergelegt ergeben den Break-Even-Punkt). Da eine
> **voll permutierte Baum-Matrix** aufgebaut ist, ist der **Messwert-Diff jeder Ebene** bekannt
> und **gegen andere Parameter isolierbar** -> ein **vollstaendig isolierbares Modell aus jeder
> einzelnen gemessenen Organ-Achse**..."

*Anmerkung zur Etikette:* F8 traegt im Ledger noch "ABGABE-PFLICHT". Diese Etikette ist gegen
das Zwischenziel 08.08. gerechnet; nach der Frist-Korrektur (`LEDGER:4377`, N-1: Endtermin
**15.09.2026**) gehoert F8 in die Klasse **T3 = vor dem 15.09.2026**. Das deckt sich mit der
Owner-Einordnung aus §1.

### 2.3 Die Doktrin-Ebene: zwei stehende Regeln

**(a) "Min/Max -> Heuristik"** --
`/home/comdare/.claude/projects/-home-comdare/memory/feedback_axes_optimization_semantics_deep_research_observer_strategy.md`
(User 09.07.), Punkte 2 und 3:

> "**Jede Achse hat eine Optimierungs-Eigenschaft = Min ODER Max einer messbaren Groesse**
> (Abwaegung) ... Diese Default-relevante Eigenschaft ist **je Achse zu bestimmen**."
> "**Ziel der Endauswertung:** aus den Messungen **mehrdimensionale Kurven fuer statische
> Heuristik-Einschaetzungen** ueber die Achsen-Parameter bestimmen -> fuer ein ausgemessenes
> System, je **Last** + **Fuellstand** + **Beschaffenheit**, die optimale Konfiguration
> abschaetzen = **echte Optimierung** (nicht blosse Rohmessung)."

**(b) "Messkurven + Chain of Responsibility"** --
`feedback_heuristik_messkurven_typsystem_chain_of_responsibility.md` (User 10.07.),
ausgearbeitet in `SUPER/docs/architektur/20_HEURISTIK_MESSKURVEN_TYPSYSTEM_UND_FILTERKETTE.md`:

- **§B Typsystem** (`:19-35`): je Tier-Binary-Gesamtpermutation eine Wall-Clock-Messkurve als
  `tree<axis compile/dynamic, map<workload-framework, map<workload-type, map<workload-size,
  map<operation_type, map<axis_observer_type, tuple<observer_special_compare_property_type,
  time>>>>>>>` -- "Ergebnis ueber alles: eine **multidimensionale Custom-Datenbank mit
  Messwerten**."
- **§C CoR** (`:43-45`): "Die Auswertungen ergeben automatisch eine **Filterkette**; ...
  **Chain of Responsibility** ... **strikt im CacheEngineBuilder-Bereich** fuer die
  **Kontrolle der Tier-Binary-GENERIERUNG**."
- **§D Messfehler** (`:49-57`): 3-Varianten-Observer-Einbau, 4. Schritt = Heuristik-Tiere ohne
  Observer neu bauen, "**Vergleich rein an der Wall-Clock** gegen alle bekannten
  Tier-Binary-Permutationen **und bekannte Paper-Algorithmen; der Paper-Vergleich geht vor**."

### 2.4 Die Phasen-Fassung: Atlas #zukunft (05.08.)

`SUPER/docs/architektur/05b_uml_klassenatlas_20260805.html:713-760` fuehrt dieselbe Kette als
Phasen-Tabelle. Ihr Status fuer Phase 2 (`:748-750`) ist der ehrlichste Satz im ganzen
Bestand: "**TEIL -- Mathematik IST, Orchestrator + Workload-Cluster + Typsystem-Wurzel
(Posten 11, DATEN-gated LEDGER:263) offen**".

### 2.5 Die Plan-Fassung als Kettenglied: D4

`SUPER/docs/plaene/20260719-FINALES-DESIGN-ABSTRACT-kette-baum-registries.md:30`:

> "**D4 -- Hybrid-Rekursion (optionales 4. Kettenglied).** Die CEB kann **nach der Auswertung
> der Messung** noch effizientere Heuristik-Hybrid-Tier-Binaries entwickeln, die ihrerseits
> echte Tier-Binaries -- delegiert durch die CEB -- entwickeln und laden (rekursive
> Delegation)."

Wortgleich in `SUPER/docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md:245`.

### 2.6 Wo der Plan NICHT steht -- mit Nenner

| Ort | Suche | Ergebnis | Gegenprobe (dass die Suche greift) |
|---|---|---|---|
| **Betreuer-Termine** `SUPER/docs/termine`, **309 Dateien**, davon **38** Office-ZIPs (alle per `unzip -p` entpackt) | `messkurv\|kennlinie\|kurvenschar\|break.?even\|pareto-front`, case-insensitiv | **0** in allen 38 Office-Dokumenten | Dieselbe Suche trifft in den Text-Extraktionen: "Plattformkennlinien" (`Domaenenmodell_PRT_ART.txt:248`), "Pareto (heavy-tail)" (`Habich_Feedback_2026_05_08.txt:306`, = Schluesselverteilung), 19+12+8+6 Paper-Heuristiken (`extract_taxonomien.md:209ff`) |
| **Betreuer-Termine**, dieselben 309 Dateien | `hybrid[- ]tier\|hybrid[- ]binar` | **0** | `hybrid` case-insensitiv trifft **109** Dateien -- alle andere Bedeutung: "Hybrid-CPUs (P-/E-Cores)", "hybride PrtArtSearchEngine", Papercluster `cluster_B_hybrid_bplus.md` |
| **Thesis**, die **sechs eingebundenen** DE-Kapitel (251+523+1525+607+245+220 Zeilen) | `Messkurven-Synthese` | **0/0/0/0/0/0** | Dieselben Dateien treffen `Messkurven-Typsystem` (`03:1383,:1479,:1481,:1522`; `05:140,:144`) und `best_binary_selector` (`01:232`) |
| **ce-Code**, `libs/`+`apps/`+`tools/` | `messkurven.?synthese\|kurven.?synthese` | **0** | Dieselben Baeume treffen `axis_spline`/`break_even`/`measurement_curve_loader` (3 reale Dateien) |

**Schluss:** Die Messkurven-Synthese ist **Owner-/Projekt-intern**. Die Betreuer-Ebene liefert
das Heuristik-**Rohmaterial** (Paper-Heuristiken), nicht das Auswerteverfahren. Die Thesis
fuehrt die Sache unter dem Namen "**Messkurven-Typsystem**". Der Begriff
"Messkurven-Synthese" existiert nur im Owner-Verbatim.

**Welche Fassung gilt:** `LEDGER:4176` (Kette), praezisiert durch F8 `LEDGER:2296/2301`
(Mathematik) und Doc 20 (Typsystem + CoR). Die Thesis ist hier **Beschreibung, nicht
Spezifikation** -- sie formuliert das Messkurven-Typsystem ausdruecklich als *Zielbild*
(`03_messsystem_prtart.tex:1480-1482`).

---

## 3. Die Hybrid-Binary

### 3.1 Definition -- Owner-Entscheid E1, verbatim

`SUPER/docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md:7`:

> "Entscheid 1 - Das ist kein Konflikt, weil die Hybrid-Tier Binaries bei exakter Designplanung
> ... klar als **eine weitere Stufe hinter der CEB** definiert sind. Sie haben **mehrere
> Pruef-docks** und verwenden fuer den Einsatz ihrer Pruef-Docks zur **Proxy Verwendung ihrer
> Tier-Binaries als Factory Pattern**, in der Regel als Ausnahmen std::variant . Aber in den
> plain Tier-Binaries ist das verboten. Die hybrid-Tier-Binaries fahren eine **Zwischenloesung
> zwischen statischen Pruef-Docks und austauschbaren plain Tier-Binaries je Pruefdock**, das
> ist eine **XML Konfiguration auf Wunsch des anwenders in der Auswertungsphase**. Es ist auch
> einstellbar, dass die **Anzahl der ABI stabilen Pruefdocks** an der hybrid-Tier-Binary
> **zahlenmaessig dynamisch variieren** kann, genau dafuer braucht es std::variant in einem
> **wahlweise statischen oder runtime array**."

Die stehende Doktrin-Zeile dazu:
`/home/comdare/.claude/projects/-home-comdare/memory/feedback_hybrid_tier_stufe_hinter_ceb_variant_ausnahme.md:11-15`
-- "In **plain Tier-Binaries bleibt std::variant VERBOTEN**; die Ausnahme gilt NUR fuer die
Hybrid-Stufe." Ledger-Zwilling `LEDGER:96`: der V7.2-Satz ist "**PRAEZISIERT, nicht
aufgeweicht**"; der E-11-Regelkonflikt ist damit aufgeloest -- "kein Konflikt, zwei
Geltungsbereiche".

### 3.2 Rolle in der Kette -- Rekursions-Ebene 3

`CE/docs/architecture/20260802-hybrid_tier_stufe_soll_design.md:55-59`:

| Ebene | Dock |
|---|---|
| 1 | Planer-Dock (Planer -> CEB) |
| 2 | CEB-Pruef-Dock (CEB <-> Tier-Binary), bidirektional, ABI-7 |
| 3 | **Hybrid-Pruef-Docks (Hybrid-Tier-Binary <-> plain Tier-Binaries)** -- "NEU, dieses Design; N Docks statt einem, N dynamisch" |

Schnittstelle beidseitig dieselbe Anatomy-ABI (`:61-68`): nach oben ist die Hybrid-Binary ein
gewoehnliches Tier-Modul am CEB-Pruef-Dock (4 Pflicht-Symbole, Major 7, Magic `.A7.`), nach
unten spricht jedes ihrer Docks dieselbe ABI. "**Folge (wichtigster Freihalte-Entscheid): die
Hybrid-Stufe braucht KEINEN eigenen ABI-Schritt.**"

### 3.3 Vererbung -- das Hybrid-Vererbungs-Gesetz

Owner `LEDGER:4082`, verbatim: "Wenn wir die Hybriden betrachten und sie als vierte Stufe
eingeschoben sind, **erben sie ALLE Eigenschaften vorausgegangener Stufen** und geben die
Eigenschaften der **Mess-Achse an ihre Tier-Binaries zur compile Zeit weiter**".

Owner `LEDGER:4090`, verbatim: "Die **System-Achse ist exakt wie die Messachse dehnbar stufig**
gegen die eingeschobenen Hybriden und die Hybriden **geben sich selbst und ihren Tier-Binaries
die System-Achsen-config per compile time mit**. Die **Organ-Achsen** sind eigentlich nur in
den Tier-binaries verbaut und **beruehren die Hybriden NICHT direkt**, da die Hybriden ein
**factory pattern - facade - Adapter** sind".

Kanonische Form `LEDGER:4090` (Gesamt-Form aus mittag-9 + mittag-10):

- **MESS:** Planer(RT-Freigabe) -> CEB(CT) -> **[Hybrid(CT)]** -> Tier(CT) -- DEHNBAR
- **SYSTEM:** CEB(RT-Freigabe) -> **[Hybrid(CT)]** -> Tier(CT) -- DEHNBAR exakt wie Mess
- **ORGAN:** NUR in den Tier-Binaries verbaut -- **OHNE Hybrid-Beruehrung**

Stempel-Konsequenz `LEDGER:4092`: der Hybrid traegt Mess- UND System-Stempel-Zeilen seiner
Kette, aber **KEINE Organ-Permutations-Identitaet**.

### 3.4 Factory - Facade - Adapter, konkret

Die GoF-Aufloesung steht in `LEDGER:4091` und in der Memory-Zeile (`:17`): "**Factory**
(Dock-Einsatz), **Facade** (virtuelles ganzes Tier-Binary nach aussen), **Adapter**
(Command-Delegation an statisch zugewiesene echte Tiers); **ORGAN-FREI**." Baulich in
`…soll_design.md:78-160`:

| GoF-Rolle | Traeger | Beleg |
|---|---|---|
| Abstract Factory | `HybridDockFactory::make_dock(DockContractDescriptor const&, HybridDockVariant&)` -- "EINZIGER Konstruktions-Ort der Alternativen" | `:84-85`, `:153-157` |
| Proxy (+ Factory Method) | `HybridBinaryProxy` -- `AnatomyModuleHandle` (RAII, move-only) + `SearchAlgorithmDrive`; `obs()` = "gecachter statischer Antrieb -- Hot-Path variant- und cast-frei" | `:140-151` |
| Facade | `hybrid_tier_module.cpp`, `COMDARE_DEFINE_ANATOMY_MODULE`-Export der SearchAlgorithm-Huelle | `:94-95`, `:61-64` |
| Adapter/Command | Delegation an die echten organ-tragenden Tiers | `LEDGER:4091` |
| CT-Strategy | `hybrid_eviction.hpp` | `:89` |
| CT-Chain-of-Responsibility | `hybrid_router.hpp` (Break-Even-Router) | `:90-91` |

**Die variant-Kante exakt** (`:162-175`): erlaubt ist genau `HybridDockVariant` im `DockSlot`;
`std::visit` **nur** an Konfigurations-/Umschaltpunkten, danach wird der monomorphisierte
`IObservableTier*` im Slot gecacht -- "der Op-Hot-Path ist variant-frei und cast-frei".
Beachte `:118-122`: **nur `dock` ist variant, `proxy` NICHT.**

### 3.5 DIE KERNFRAGE: warum braucht sie die Auswertung?

Nicht "sie ist sonst unfertig", sondern **drei benannte, je einzeln belegte
Funktionsausfaelle**:

**(a) Ohne Auswertung bleibt das Dock-Array leer -- die Factory hat nichts zu konstruieren.**
`…soll_design.md:188-190`, verbatim:
> "**Delegierter Bau (LEDGER:2230):** die Hybrid-Stufe kompiliert NIE selbst; sie fordert plain
> Tier-Binaries per **Anforderungs-Manifest (binary_id-Liste)** bei der CEB an; die CEB baut
> oder holt aus dem Lager und liefert .so-Pfade zurueck."

Diese binary_id-Liste **ist** das Ergebnis der Auswertung -- die "multiple besten Binaries ueber
multiple Lasten" aus `LEDGER:4176`. Ohne Rangbildung ueber Kurven weiss die CEB nicht, welche
plain Tiers sie an die Docks haengen soll.

**(b) Ohne Auswertung hat der Router keine Umschaltschwelle -- die Hybrid-Binary degeneriert zu
einem Multiplexer ohne Kriterium.**
`…soll_design.md:192-195`, verbatim:
> "`hybrid_router.hpp` konsumiert **AxisSpline-Kurven** (`heuristik/measurement_curve_loader.hpp`)
> und **BreakEvenPoint-Listen** (`heuristik/break_even.hpp`) und bildet daraus die
> Compile-Time-Chain-of-Responsibility der Heuristik-Ebene".

Und der Break-Even-Punkt *ist* per Owner-Definition der Schnittpunkt zweier synthetisierter
Messkurven (`LEDGER:2301`). Kein Kurvensatz -> keine Schwelle -> keine Laufzeit-Auswahl. Das
ist genau die "Erkennungsheuristik der Last" aus `LEDGER:4176`.

**(c) Ohne Auswertung ist die XML-Anwenderkonfiguration nicht freischaltbar.**
Owner-E1 terminiert sie ausdruecklich: "eine XML Konfiguration auf Wunsch des anwenders **in
der Auswertungsphase**". Die beiden entscheidenden XML-Felder zeigen beide in den Mess-Store --
`…soll_design.md:220-234`: `<tier_binary select="heuristic"/>` und
`<router><break_even source="measurement_store" curves="axis_splines"/></router>`.

**Damit ist der Owner-KERN aus §1 beziffert:**
"Teil der Hybrid-Binary Definition" = **(a)** · "Funktionalitaets-Voraussetzung" = **(b) + (c)**.

**Die zwei Wege sind als §49-Optionen sauber getrennt** (`…soll_design.md:199-203`):
Option 1 = **Einkompilieren** (Kandidaten-Algorithmen derselben Achse statisch hinein, Auswahl
ueber CT-CoR, **kein variant dafuer**) · Option 3 = **Laufzeit-Tausch** (Dock-Array + Eviction,
Umschaltung am Break-Even-Punkt, Verdraengung unter RAM-Budget).

---

## 4. DIE ABHAENGIGKEITSKETTE

```
  [1] MESSUNG          [2] SYNTHESE        [3] RANGBILDUNG     [3b] BESTE       [4] HYBRID
  Voll-Lauf,           Messwerte ->        Kurven-Vergleich    BINARIES         4. Kettenglied
  WIDE-CSV             f(x)-Spline         JE EINGANGSLAST     Release-Rekomp.  hinter der CEB
                       je Achsen-Variante                      + Wallclock
      |                     |                     |                  |               |
      |  (x,y)-Reihen       |  f, g               |  Rang je Last    | binary_id-    |
      |  je (achse,         |  je Kandidat        |                  | Liste (a)     |
      |  variante,          |                     |                  |               |
      |  workload)          |  BreakEvenPoint(x)  |                  |               |
      +-------------------->+-------------------->+----------------->+-------------->+
                            |                                                        |
                            +----- Router-Schwellen (b) -----------------------------+
                            |                                                        |
      +--------------------- XML-Freischaltung (c) ----------------------------------+
                                    |
                            [3c] MULTI-LAST -> LAST-ERKENNUNGSHEURISTIK ------------>+
```

### Je Pfeil: was fliesst, was faellt aus

| Pfeil | Was genau fliesst | Was faellt aus, wenn das Quellglied fehlt | Beleg |
|---|---|---|---|
| **[1] -> [2]** | (x,y)-Reihen je Gruppe `(sweep_axis, binary_id, workload)`; x = `working_set_n`, y = `ns_per_op` (WIDE-Pfad) bzw. x = `op_count`, y = `total_cycles` (Snapshot-Pfad) | Ohne Messdaten kein Spline: `build()` liefert `std::nullopt` bei < 2 Stuetzstellen -- "**Nie ein Phantom-Modell aus unzureichenden Daten**" | `CE/libs/cache_engine/heuristik/measurement_curve_loader.hpp:11-23`; `axis_spline.hpp:27-28` |
| **[2] -> [3]** | f(x)-Modellkurven je Organ-Achsen-Variante + `BreakEvenPoint{x, y, links_besser, rechts_besser}` aus `d(x) = f(x) - g(x)`, Vorzeichenwechsel + Bisektion | Ohne Kurven wird nicht "je Eingangslast" verglichen, sondern global gemittelt -- **genau der heutige Ist-Zustand**, s. §5 Befund S-1 | `axis_spline.hpp:6-25`; `break_even.hpp:6-19` |
| **[3] -> [3b]** | Ranking je Last -> Kandidatensatz | Ohne Rang kein Kandidat fuer die Release-Rekompilation | `LEDGER:4176` |
| **[3b] -> [4] (a)** | **binary_id-Liste als Anforderungs-Manifest an die CEB** | **Dock-Array leer, Abstract Factory ohne Konstruktionsauftrag** | `…soll_design.md:188-190` |
| **[2] -> [4] (b)** | AxisSpline-Kurven + BreakEvenPoint-Listen an `hybrid_router.hpp` | **Router entscheidungslos** -- keine Umschaltschwelle zur Laufzeit | `…soll_design.md:192-195` |
| **[2] -> [4] (c)** | Mess-Store als Quelle der XML-Felder `select="heuristic"` / `source="measurement_store"` | **Zwischenloesung nicht konfigurierbar** -- die Anwender-XML hat keine Datenbasis | `…soll_design.md:220-234`; Owner-E1 |
| **[3c] -> [4]** | Last-Klassifikator zur Laufzeit | **Multiple beste Binaries bleiben unerreichbar** -- der Hybrid kann nicht wissen, welche Last anliegt; (b) wird permanent wirkungslos | `LEDGER:4176`; Ungedeckt-Beleg s. §5 |

**Die Kette ist streng seriell in (a) und in (c); (b) haengt direkt an [2] und ueberspringt
[3].** Das ist der Grund, warum ein funktionierender `best_binary_selector` allein die
Hybrid-Binary **nicht** freischaltet: er bedient (a), nicht (b).

---

## 5. Der Ist-Stand

### 5.1 Glied [1] MESSUNG -- TEIL-IST

Die reale WIDE-CSV traegt **alle** Spalten, die [2] und [3] brauchen. Belegt an
`measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv` (**173 Spalten**, 16
Datenzeilen): `binary_id`(1), `ns_per_op`(6), `two_phase_valid`(156), die sechs op-p50-Metriken
(8/11/14/20/23) und die sechs Zell-Dimensionen `setting`(2), `workload`(155), `series`(157),
`working_set_n`(159), `platform`(160), `build_version`(161).
**Offen:** der Voll-Lauf selbst (`LEDGER:263` G6 gated).

### 5.2 Glied [2] SYNTHESE -- IST vorhanden, aber DREIFACH und ohne Konsument

**Nenner: 1802 Zeilen ueber drei parallele Stacks, 0 Produktions-Konsumenten.**

| Stack | Dateien | Zeilen | Verfahren | Konsument |
|---|---|---|---|---|
| **①** `CE/libs/cache_engine/heuristik/` | `axis_spline.hpp`, `break_even.hpp`, `measurement_curve_loader.hpp` | 261+148+227 = **636** | Monotone kubische Hermite (**Fritsch-Carlson 1980**) als Default, weil der natuerliche Spline "**UEBERSCHWINGEN**" kann -> "**SCHEIN-Schnittpunkte** im Break-Even-Finder -> **falsche Switch-Thresholds**"; Verfahrenswahl = CT-Strategy, Concept-gehaertet | **nur 3 Tests.** In `libs/` nur Kommentar-Verweise |
| **②** `CE/libs/cache_engine/builder/curve_fit/` + `builder/decision_lambda_trees/` | `curve_fit.hpp`, `decision_lambda_trees.hpp` | 537+129 = **666** | Natuerlicher kubischer Spline **plus eigene Fritsch-Carlson-Kopie** (`curve_fit.hpp:278`: "hier als **eigene builder-Kopie portiert**"), eigener CSV-Leser, eigener Schnittpunkt-Finder (`:387` "analog break_even.hpp sign_tol") | nur `test_hybrid_spline_selector_scaffold` + `test_phase6_vorbau` |
| **③** `best_binary_selector.hpp` Haelfte B | `PiecewiseCurve`, `find_break_evens`, `HybridBinarySelector` | ~**500** | stueckweise linear ueber **synthetischen** Stuetzstellen | nur der synthetische Test |

Stack ③ deklariert die Duplikation selbst -- `decision_lambda_trees.hpp:10-11`: "Der
SELF-CONTAINED best_binary_selector traegt eine **std-only Spiegelung derselben
Rueckwaerts-Wahl** (PiecewiseCurve statt AxisSpline) -- dieses Engine-Modul ist die
AxisSpline-basierte Variante."

**Stack ① ist §75-schutzgelistet** (`LEDGER:3602`): die drei Header "duerfen im
Abschluss-Aufraeumpass **weder entfernt noch umbenannt** werden, weil die Hybrid-Tier-Stufe
(Bau in der Auswertungsphase) unmittelbar auf ihnen aufsetzt" -- Speisung des Break-Even-Routers
HY-B2. **②/③ sind nicht geschuetzt.**

**Nicht vorhanden:** ein Orchestrator "Kurven-Vergleich je Eingangslast" als **ein benannter
Codepfad**. Atlas-Gegenpruefregister `05b:784` (UNGEDECKT 2): "heute verteilt auf
`break_even.hpp` (Schnittpunkte) + `best_binary_selector.hpp` (**Roh-Mediane direkt aus CSV,
konsumiert die Splines NICHT**); die Synthese-Bruecke `hybrid_router.hpp` (SOLL HY-B2)
**existiert nicht**."

### 5.3 Glied [3] RANGBILDUNG / [3b] BESTE BINARIES -- HALB-IST mit fremder Definition

`CE/libs/cache_engine/builder/best_binary_selector/`:

| Datei | Zeilen |
|---|---|
| `best_binary_selector.hpp` | 372 |
| `best_binary_selector.cpp` | 584 |
| `best_binary_selector_main.cpp` | 148 |
| **Summe** | **1104** |

CMake-Target `CE/tools/best_binary_selector/CMakeLists.txt:7`
(`comdare_best_binary_selector`, **nicht** EXCLUDE_FROM_ALL). Zwei ctest-Tests
(`test_best_binary_selector_parse_rank` 200 Z., `test_hybrid_spline_selector_scaffold` 249 Z.),
beide gruen. GoF sauber: Strategy (`RankingCriterion`), Repository (`TiereDllRepository`),
Builder (`ShippedArtifactBuilder`, **atomarer Publish** ueber tmp-Sibling + `fs::rename`).

**Empirisch belegt:** Lauf gegen die reale Messreihe (s. 5.1) und den realen DLL-Baum
`Code/measure_out_d03/e4_xml/dll/` -- 16 Datenzeilen gelesen, 8 distinkte `binary_id`, Sieger
`median=700.000 ns`, Artefakte `best_lookup.dll` (431232 B) + `.algos` + `.version` +
`.manifest.txt` (1946 B) erzeugt. **Es ist kein Geruest.**

**Aber die Definition ist eine andere als die geplante:**

| | IST (`best_binary_selector`) | SOLL (`LEDGER:4176` + F8) |
|---|---|---|
| Kriterium | **eine** Metrik, kleiner=besser (`--metric ns_per_op\|insert\|lookup\|erase\|scan\|rmw`) | f(x)-Modellkurve je Achsen-Variante |
| Aggregation | Median der Zell-Mediane ueber `workload\|working_set_n\|platform\|build_version\|series\|setting`; Kandidat ohne volle Zell-Abdeckung wird **disqualifiziert** | Rueckwaerts-Wahl an der Anfrage-Koordinate |
| Ergebnis | **ein** globaler Sieger je Metrik, ueber alle Lasten **gemittelt** | **ein Sieger JE EINGANGSLAST**, mehrere gleichzeitig |
| Wer entscheidet | der Bediener per `--metric` | die Heuristik |

**Harter Beleg fuer den Bruch:** `/usr/bin/grep -c -E "axis_spline|heuristik/"` in
`best_binary_selector.hpp` = **0** und in `.cpp` = **0** (heute nachgemessen).

**Release-Rekompilation + Wallclock-Nachmessung:** CMake-Schalter vorhanden, **Nachmess-LAUF
ungedeckt**. Teil-verortet in Paket HY-B4 (`…soll_design.md:402`: "Release-Schritt:
Mess-Observer per Metaprogrammierung abschaltbar (LEDGER:3250) + Wallclock-Beweis").

### 5.4 Glied [3c] LAST-ERKENNUNGSHEURISTIK -- UNGEDECKT

Atlas-Gegenpruefregister `05b:786` (UNGEDECKT 4): "auch im **HY-D2-Design-Doc nicht
ausgearbeitet** (grep Erkennungsheuristik/Last-Erkennung/Workload-Erkennung/stochastisch im Doc
= **0**); Deckung ausschliesslich Dossier-19 Punkt 4 ('stochastisch haeufige Workload-Last') +
Owner-R5 verbatim."

**Das ist die einzige Stelle, an der die Owner-Aussage 'ebenfalls detailliert geplant' nicht
traegt** -- hier ist die Planung real luckenhaft, nicht nur ungelesen. Das gehoert dem Owner
gemeldet (§9, F-3).

### 5.5 Glied [4] HYBRID -- UNGEBAUT, by design

**Nenner: 1 Datei, 58 Zeilen, kein Code.**
`find CE/libs/cache_engine/hybrid/ -type f | wc -l` = **1** -> `README.md` (3820 B).
`README.md:1`: "# hybrid/ -- **RESERVIERTER STUB der Hybrid-Tier-Stufe (KEIN CODE)**";
`:5-10`: "reine **NAMENS- UND SCHNITTSTELLEN-RESERVIERUNG** ... KEIN Header, KEINE Quelle,
KEINE CMakeLists, KEIN Build-Anschluss ... **ANFASSEN ERST in der Auswertungsphase**
(Pakete HY-B1..HY-B4), nach Voll-Bau-4 und nach E-24."

**Build-Neutralitaet gegengeprueft:** `CE/libs/cache_engine/CMakeLists.txt` fuehrt genau fuenf
`add_subdirectory`-Zeilen (`:4-8`: builder, profile_facade, concurrency_manager, subsystems,
reclamation); Treffer fuer "hybrid" darin: **0**. Kein GLOB.

**Der Ledger-Stand stimmt also.** Das ist **kein Befund** -- der Bau ist terminlich korrekt auf
die Auswertungsphase gelegt, mit Paketreihenfolge HY-B1a -> HY-B1b -> HY-B2 -> HY-B3 -> HY-B4
(`…soll_design.md:394-402`) und benanntem Minimal-DoD (HY-B1a = F8-Minimal-DoD K6).

**Offen VOR dem Bau:** fuenf bindende Design-Auflagen (`…soll_design.md:306-380`) -- **K1**
Lager-Identitaet der Hybrid-`.so` (sie hat keine Organ-Permutations-`binary_id`), **K2**
Schichten-Zuordnung Loader/Drive, **K5** Snapshot-Aggregations-Semantik ("Bis zum Entscheid
gilt **keine Variante als implizit gesetzt**"), **Q10.3** Stempel-Kennzeichen, **Q10.4**
Verdraengungs-Heuristik-Shortlist. Plus **Posten 90** (`LEDGER:4092`): die GoF-Einordnung und
die CT-Weitergabe **beider** Achsen-Arten sind im Design-Doc vom 02.08. noch nicht enthalten --
die Praezisierungen stammen vom 05.08.

### 5.6 Befunde nach Schwere

| # | Schwere | Befund | Beleg |
|---|---|---|---|
| **S-1** | **HOCH** | **Die Kette ist an ihrer wichtigsten Naht durchtrennt.** [3] konsumiert [2] nicht; `hybrid_router.hpp` existiert nicht. **Zwei unvereinbare Definitionen von "beste Binary"** koexistieren, ohne dass ein Fork gestellt waere. Wer heute [3] ausfuehrt, erhaelt ein Ergebnis nach der **falschen** Definition. | grep = 0/0; Atlas `05b:784` |
| **S-2** | **HOCH** | **Doppelquelle x3** (1802 Z., 0 Prod-Konsumenten). Der Plan zeigt auf Stack ①; der einzige CMake-angebundene CT-Entscheidungsbaum sitzt auf Stack ②; ③ ist eine dritte Spiegelung. Im §75-Aufraeumpass ist ① geschuetzt und ②/③ nicht -- **der Pass wuerde die Entscheidung implizit faellen**. | `decision_lambda_trees.hpp:10-11`, `curve_fit.hpp:278/:387`, `LEDGER:3602` |
| **S-3** | **HOCH** | **Last-Erkennungsheuristik: 0 in Code, 0 im Design-Doc, 0 im Register.** Bindeglied zwischen "multiple beste Binaries" und der Hybrid-Binary; ohne sie ist Ausfall (b) permanent. | Atlas `05b:786` |
| **S-4** | **MITTEL** | **Phantom-Blocker K-5.** `LEDGER:2726` und `:3027` fuehren "best_binary_selector ABI-Spiegel stale, kAbiMajor=5 vs Host 6, OFFEN, hoch". Der Code steht auf **kAbiMajor = 8 / `.A8.`**, dreimal nachgezogen, mit Paritaets-`static_assert` in zwei Tests. Der heutige DIFF-Doc hat den stale Posten geerbt und daraus einen **Vor-Abgabe**-TODO gemacht (`20260806-DIFF-thesis-soll-gegen-ledger-und-code.md:499-505`, §63-T-23: "TODO: §50-K-5 vor Abgabe schliessen"). **Dieser TODO ist gegenstandslos und kann heute gestrichen werden.** | `best_binary_selector.hpp:45-59`; `test_best_binary_selector_parse_rank.cpp:28/:32` |
| **S-4b** | **MITTEL** | **Aber der Ausfuehrungs-Zeitpunkt ist ungeschuetzt.** Live gemessen: eine am 19.07. gebaute Tool-Binary schrieb ins Manifest `abi_major=5` / `abi_magic=0x434f4d444141352e`, waehrend der Quellstand 8 fuehrt. Der `static_assert` schuetzt das **Uebersetzen**, nicht das **Ausfuehren**. Zusaetzlich: `.hpp:50-51` behauptet, der Selector haette "jede neu gebaute Major-7-Binary **verworfen**" -- im gesamten `.cpp` (584 Z.) gibt es **keine** ABI-Pruefung und **keinen** Verwerfungs-Pfad. Der zweite Halbsatz ist **UNBELEGT**. | `.cpp:385-387`, `.hpp:50-59` |
| **S-5** | **MITTEL** | **Stiller Gruppen-Kollaps im Kurven-Loader.** `measurement_curve_loader.hpp:50-51` verbatim: "**Fehlt eine Gruppen-Spalte im Header, faellt ihre Dimension auf '-'** (ehrlich, kein Absturz). x/y MUESSEN existieren, sonst leeres Ergebnis." x/y sind honest-empty-geschuetzt, die **Gruppendimensionen nicht**. Fehlt `workload`, verschmelzen **alle Lasten still zu einer Gruppe** -- und "je Eingangslast" ist die Owner-Definition von [2]. **Klasse: schweigender Ausweich-Wert.** | Zeilenzitat |
| **S-6** | **MITTEL** | **Median-Divergenz REV-DATA-12**, im Code als offen annotiert. `best_binary_selector.cpp:182-183` verbatim: "Median (nearest-rank, UNTERE Mitte vals[(n-1)/2]) ... Achtung: csv_to_latex/diagram_generator nutzen die nearest-rank-OBERE Mitte -- Divergenz bei geradem n = REV-DATA-12 (offen)." **Die Zahl in der Thesis-Tabelle kann von der Zahl abweichen, mit der der Sieger bestimmt wurde.** Nicht im Ledger, nicht im Register. | Zeilenzitat; `20260716-wp5-rev-mining-DISPOSITION.md:53` |
| **S-7** | **MITTEL** | **Leeres Provenienz-Sidecar wird als Erfolg gemeldet.** `best_binary_selector.cpp:326-339`: fehlt `perm.dll.version` in der Quelle, bleibt `dll_build_version` leer, das Sidecar wird als **leere Datei** geschrieben, das Manifest bekommt `dll_build_version=`, und `build()` meldet **Erfolg**. Artefakt mit und ohne Provenienz am Rueckgabewert ununterscheidbar. | Zeilenstelle |
| **S-8** | **GERING** | `--top abc` -> `catch (...) {}` -> still Default 5, keine Diagnose. Kosmetisch, aber formgleich zum verbotenen Muster. | `best_binary_selector_main.cpp:53-56` |
| **S-9** | **GERING** | **Das CLI-Frontend wird in keiner CI-TU uebersetzt.** Nenner: super `.gitlab-ci.yml` 1361 Z. + ce 635 Z. = 1996 Z. `grep -i best_binary` -> **0**; `cmake --build` ohne `--target` -> **0** (kein Job baut `all`). Gegenprobe: `csv_to_latex\|diagram_generator` trifft (`super:400`, `:481`). Die *Logik* laeuft (2 Tests, Label `tools;best_binary` nicht von `-LE pmc` ausgeschlossen), das *Frontend* (148 Z.) nicht. | grep mit Gegenprobe |
| **S-10** | **GERING** | **Anker-Drift in der Doku.** `.hpp:219` und `_main.cpp:23` nennen `build/thesis_tiere/tiere` als tiere-Baum. Real existiert der Pfad nicht: alle 328 gefundenen `perm.dll` liegen unter `<out>/e4_xml/dll/<stem>/perm.dll`. Folgenlos (Pflichtparameter), aber toter Anker. | Zaehlung 328 |

**Geprueft und NICHT beanstandet:** die Zell-Vollstaendigkeitspruefung
`cells.size() != expected_cells.size()` (`.cpp:194`) ist trotz reinem Kardinalitaets-Vergleich
korrekt (`cells` ⊆ `expected_cells` per Konstruktion `:177-179`). `perm.dll` ist auf **beiden**
Plattformen der kanonische Name (`build_orchestrator.hpp:571`; 328x `perm.dll` vs. 0x
`perm.so`).

---

## 6. Die Thesis-Zusage

### 6.1 Der Wortlaut

`SUPER/thesis/diplomarbeit/kapitel/de/01_einleitung.tex:227-233`, unter der Klammer
"*Als Zielsetzung und Ausblick:*":

> "...die **Mess-Pipeline liefert die dafuer noetige Rangbildung bereits**, und ein **erstes
> Inkrement der automatischen Auswahl und des Binary-Versands ist als eigenstaendiges Werkzeug
> (`best_binary_selector`) implementiert**; die heuristik-gesteuerte Vollautomatisierung bleibt
> Ausblick."

Zwei Parallelstellen, konsistent: `03_messsystem_prtart.tex:1401-1402` ("im Rahmen dieser
Arbeit umgesetzt ist davon nur ein erstes Inkrement") und `06_fazit.tex:195-197` ("liegt jedoch
bereits ... vor, das je Metrik die beste Permutation aus den Mess-CSVs rangiert und
ausliefert"). EN-Paritaet vorhanden. **Kein Einleitung<->Fazit-Widerspruch.**

### 6.2 Haelt sie? -- Teilzusage fuer Teilzusage

| Teilzusage | Verdikt | Begruendung |
|---|---|---|
| "Mess-Pipeline liefert die Rangbildung bereits" | **HAELT, eine Stufe grosszuegig** | Die Pipeline liefert die *Datenbasis* (alle Spalten in der realen CSV, §5.1); die Rangbildung rechnet das *Werkzeug* (`rank_binaries`, `.cpp:167-219`). |
| "erstes Inkrement der automatischen **Auswahl** ... implementiert" | **HAELT** | Am Objekt gegen echte Messreihe + echte DLLs durchgelaufen; 1104 Z., 2 gruene ctest, GoF sauber. |
| "... und des **Binary-Versands** ... implementiert" | **SCHWACH** | "Versand" = `fs::copy_file` + `fs::rename` nach `--out <dir>` + Manifest (`.cpp:315`, `:394-403`). Kein Kanal: `grep -i minio` ueber beide CI-Dateien -> 11 Treffer, **alle** ccache oder Ebene-B-Tier-Binary-Cache; `grep -i "best\|shipped\|versand"` ueber `lager_pfad_grammatik.hpp` (574 Z.) -> 2 Treffer, **beide** nur der Namespace. Getragen **allein** vom Zusatz "erstes Inkrement". |
| "heuristik-gesteuerte Vollautomatisierung bleibt Ausblick" | **KORREKT und ehrlich** | Die Feedback-Kante ist im Code **dreifach** als unverdrahtet markiert: `selection_filter_chain.hpp:2-5` ("Schliesst die heute fehlende Feedback-Kante Auswertung (best_binary_selector) -> Generierung"), `:110-113` ("**noch nicht verdrahtet** ... strukturell **UNERREICHBAR**"), `:122-125` ("**DEFERRED (#156)** ... **Bis dahin bleibt die Einhaengung eine reine Identitaet**"). |

**GESAMTVERDIKT: die Zusage HAELT in ihrer engen Fassung.** Sie ist als Ausblick gerahmt, im
Praesens korrekt, das Werkzeug existiert, ist getestet und liefert ein benanntes ABI-Artefakt.
**Der einzige angreifbare Punkt ist das Wort "Binary-Versand"** -- wer darunter einen
Auslieferungskanal versteht, findet eine Verzeichniskopie.

### 6.3 Die zwei Wege -- DIE WAHL GEHOERT DEM OWNER

> **WEG A -- BAUEN.**
> **Umfang:** einen echten Versandkanal an den bestehenden `ShippedArtifactBuilder` haengen.
> Die Naht existiert bereits: `CE/libs/cache_engine/builder/bestandslog/artifact_cache_transport.hpp:3-6`
> ("Die EINE Kante bestandslog -> artifact_transport ... vier ABSTRAKTE Verben ... an die vier
> KONKRETEN Objekt-per-Key-Verben des ArtifactCache"). Im selben Zug fielen S-7 (leeres
> Sidecar) und S-8 (`--top`).
> **Aufwand:** ein kleines Paket (S/M).
> **Folge/Risiko:** ein Bau-Fenster am **Vorabend der Abgabe**, in eine Datei, die heute in
> **keiner CI-TU uebersetzt wird** (S-9) -- ein Compile-Bruch fiele nicht auf. Beruehrt eine
> Flaeche, die die Thesis referenziert.
> **Nutzen:** die Formulierung "Binary-Versand" wird ohne Einschraenkung wahr.

> **WEG B -- AUSSAGE PRAEZISIEREN.**
> **Umfang:** ein Wort. "des **Binary-Versands**" -> "der **Artefakt-Auslieferung als
> eigenstaendige, provenienz-etikettierte Binary**" (Alternative: "... und der Bereitstellung
> des Siegers als eigenstaendige Binary samt Provenienz-Manifest").
> **Stellen:** `de/01_einleitung.tex:231-232`, `de/03_messsystem_prtart.tex:1402`,
> `de/06_fazit.tex:196` **plus** die drei EN-Zwillinge (`en/01:226`, `en/03:1378`, `en/06:190`).
> **Aufwand:** sechs Zeilen + LaTeX-Kette neu bauen.
> **Folge/Risiko:** keines am Code; die Aussage beschreibt exakt, was das Werkzeug tut.

**Meine Einordnung, nicht meine Entscheidung:** **Weg B** ist der risikoaermere -- er beruehrt
die Abgabe-Flaeche nicht, und die Zusage ist bereits durch "erstes Inkrement" gedeckt. Weg A
gehoert sachlich in die Auswertungsphase; er ist ohnehin Teil von **HY-B4** ("delegierter
Bau-Kanal", `…soll_design.md:402`).

**Unabhaengig von A/B, heute erledigbar:** der §63-T-23-Vor-Abgabe-TODO "§50-K-5 vor Abgabe
schliessen" ist **gegenstandslos** (S-4) und kann gestrichen werden. Er bindet sonst
Arbeitszeit, die nicht anfaellt.

---

## 7. Was ins Ledger gehoert

**Nenner der Gegenprobe:** das autoritative Register ist
`SUPER/docs/sessions/20260806-REGISTER-todo-konsolidierung-14-tage.md` (**474 Zeilen**).
Die Suche greift dort: "hybrid" trifft **6x** (Z. 170/345/349/440/443/468), "Spline" **1x**
(Z. 440). Die folgenden Nullen sind also echt.

### 7.1 Was bereits registriert ist (nichts zu tun)

| Posten | Ort | Status |
|---|---|---|
| **V-09 Hybrid-Bau + PL-19/PL-21** ("Heuristik-Hybrid aus realen Messdaten, Spline je Achse, Rueckwaerts-Wahl ... Ist-Beleg heute: `libs/cache_engine/hybrid/` enthaelt NUR README.md") | Register `:440`, Klasse NACH-ABGABE | OFFEN |
| **Posten 90** (Hybrid-Doc: GoF-Einordnung + CT-Weitergabe beider Achsen-Arten) | Register `:349` | OFFEN |
| **V-15** Doku-Widerspruch `…soll_design.md:286-288` "[[System],[Organ]]" gegen den organ-freien Stempel-Kanon | Register `:443` | OFFEN |
| **HY-B1a..HY-B4** + K6-Minimal-DoD | `…soll_design.md:394-402` | verortet |
| **K1/K2/K5/Q10.3/Q10.4** (5 Design-Auflagen) | `…soll_design.md:306-380` | OFFEN |
| **§75-NICHT-KANDIDATEN** (heuristik/ 3 Header freigehalten) | `LEDGER:3602` | Dauer-Auflage |
| **G6/#11** Messkurven-Typsystem-WURZEL + Kurven-Fit-Konsum | `LEDGER:263`, `:216(f)` | OFFEN, DATEN-gated |

### 7.2 Was NICHT registriert ist -- Register-Treffer je 0 bei Nenner 474

| Zugesagt/geplant | Register | Ledger |
|---|---|---|
| Messkurven-Synthese als Posten (`Messkurv` = 0) | **0** | nur Historie `:829` + Owner-Verbatim `:4176` -- **kein Posten** |
| Auswertungs-Orchestrator / Kurven-Vergleich je Eingangslast (`Orchestrator` = 0) | **0** | **0** |
| Doppelquelle-Aufloesung heuristik/ vs curve_fit vs Selektor-Haelfte-B | **0** | **0** |
| Last-Erkennungsheuristik (`Erkennungsheuristik` = 0) | **0** | nur Owner-Verbatim `:4176` |
| Release-Rekompilation + Wallclock-Nachmess-LAUF (`Nachmessung` = 0) | **0** | Owner-Verbatim + `:4241` (nur als *Stempel*-Risiko) |
| Multi-Last -> multiple beste Binaries (`Workload-Cluster` = 0) | **0** | `:215(e)` nur als Modus-Ziel |
| best_binary_selector-Verdrahtung / Feedback-Kante (`best_binary` = 0) | **0** | nur Historie `:841` + der stale K-5 |
| REV-DATA-12 Median-Divergenz (`REV-DATA` = 0) | **0** | **0** (nur `20260716-wp5-rev-mining-DISPOSITION.md:53`) |
| S-5 Gruppen-Kollaps · S-7 leeres Sidecar · S-8 `--top` · S-9 CLI ohne CI · S-10 Anker-Drift | **0** | **0** |

**Von den vier Kettengliedern hat nur [4] Hybrid eine Registerzeile.** [2], [3], [3b] und [3c]
haben keine -- sie leben ausschliesslich im Owner-Verbatim und in der Atlas-Prosa.

### 7.3 FERTIG FORMULIERT -- direkt uebernehmbar

Format: Spalten des Registers (`| Kanon-Name | Inhalt | Status | Quelle(n) |`), Abschnitt
**NACH-ABGABE-Ergaenzung**, unmittelbar **vor** V-09 einzuordnen (V-09a ist dessen Vorbedingung).

```
| **V-09a AUSWERTUNGS-STRECKE** (Vorbedingung von V-09; Traeger: Owner-KERN 06.08. abends
"Auswertung der Binaries mit bestimmen der besten Binaries aus der Messkurven-Synthese ...
Teil der Hybrid-Binary Definition und deren Funktionalitaet-Voraussetzung") | Die Kette
Messung -> Synthese -> Rangbildung -> beste Binaries -> Hybrid in acht Teilposten, s.
V-09a-1..8. Ist-Beleg heute: die Synthese-Mathematik existiert DREIFACH (1802 Z.) mit NULL
Produktions-Konsumenten; best_binary_selector konsumiert die Splines NICHT
(grep axis_spline|heuristik/ = 0/0); hybrid_router.hpp existiert nicht. | OFFEN, T3 |
LEDGER:4176 (Owner-Verbatim) . LEDGER:2296/2301 (F8) .
docs/architektur/20_HEURISTIK_MESSKURVEN_TYPSYSTEM_UND_FILTERKETTE.md .
docs/architektur/05b_uml_klassenatlas_20260805.html:713-786 .
ce docs/architecture/20260802-hybrid_tier_stufe_soll_design.md:188-234 |

| **V-09a-1 Kanonisierung der Kurven-Synthese** (Doppelquelle x3, VOR §75) | ENTSCHEID des
Owners noetig: welcher der drei Stacks ist kanonisch? (1) ce libs/cache_engine/heuristik/
{axis_spline,break_even,measurement_curve_loader}.hpp (636 Z., Fritsch-Carlson, §75-geschuetzt,
Plan-Ziel von HY-B2); (2) ce libs/cache_engine/builder/{curve_fit,decision_lambda_trees}
(666 Z., eigene Fritsch-Carlson-KOPIE curve_fit.hpp:278, eigener CSV-Leser, eigener
Schnittpunkt-Finder :387, aber der EINZIGE CMake-angebundene CT-Entscheidungsbaum);
(3) best_binary_selector-Haelfte-B (std-only PiecewiseCurve, selbst-deklarierte "Spiegelung
derselben Rueckwaerts-Wahl", decision_lambda_trees.hpp:10-11). Alle drei haben 0
Produktions-Konsumenten. RISIKO: im §75-Aufraeumpass ist (1) geschuetzt (LEDGER:3602) und
(2)/(3) nicht -- der Pass faellt die Entscheidung sonst IMPLIZIT. | OFFEN, T3, VOR §75 |
decision_lambda_trees.hpp:10-11 . curve_fit.hpp:278/:387 . LEDGER:3602 |

| **V-09a-2 Auswertungs-Orchestrator (Kurven-Vergleich JE EINGANGSLAST)** | Die einzige
Bruecke [Synthese] -> [Rangbildung]. Heute existiert sie NICHT: Atlas 05b:784 "heute verteilt
auf break_even.hpp (Schnittpunkte) + best_binary_selector.hpp (Roh-Mediane direkt aus CSV,
konsumiert die Splines NICHT); die Synthese-Bruecke hybrid_router.hpp (SOLL HY-B2) existiert
nicht". SOLL: EIN benannter Codepfad, der je Eingangslast (workload) die f(x)-Kurven der
Kandidaten vergleicht statt global zu mitteln. Loest zugleich den heutigen Definitions-Bruch
"beste Binary": IST = ein globaler Sieger je Metrik ueber alle Lasten gemittelt; SOLL =
ein Sieger JE LAST, mehrere gleichzeitig. | OFFEN, T3 | LEDGER:4176 . Atlas 05b:784 |

| **V-09a-3 Workload-Cluster-Bildung (Deep Research)** | Vorbedingung von V-09a-2 und V-09a-4:
welche Eingangslasten bilden eine Klasse? Heute nur als Forschungs-Task benannt
(docs/architektur/19_...:68 "-> neuer Forschungs-Task"), kein Verfahren. | OFFEN, T3 |
Dossier 19 Punkt 2 |

| **V-09a-4 Multi-Last -> multiple beste Binaries** | Owner LEDGER:4176: "An dieser stelle
koennen dann auch ueber multiple Lasten multiple beste Binaries bestimmt werden". Ergebnis =
die binary_id-Liste, die als Anforderungs-Manifest an die CEB geht (soll_design.md:188-190) =
die Bestueckung des Hybrid-Dock-Arrays. OHNE diesen Posten bleibt das Dock-Array leer. |
OFFEN, T3 | LEDGER:4176 . soll_design.md:188-190 |

| **V-09a-5 Release-Rekompilation OHNE Mess-Einrichtungen + Wallclock-NACHMESS-LAUF** | Owner
LEDGER:4176: "die man dann nochmal im release Modus ohne Mess-Einrichtungen neu kompiliert und
nochmal wallclock time misst". IST: CMake-Schalter vorhanden, der NACHMESS-LAUF ist ungedeckt.
Teil-verortet in HY-B4 (soll_design.md:402 "Release-Schritt: Mess-Observer per
Metaprogrammierung abschaltbar (LEDGER:3250) + Wallclock-Beweis") -- als eigener LAUF-Posten
aber nirgends gefuehrt. Doc-20 §D verlangt zusaetzlich den Paper-Vergleich: "Vergleich rein an
der Wall-Clock gegen alle bekannten Tier-Binary-Permutationen und bekannte Paper-Algorithmen;
der Paper-Vergleich geht vor". | OFFEN, T3 | LEDGER:4176 . soll_design.md:402 . Doc 20 §D:49-57 |

| **V-09a-6 LAST-ERKENNUNGSHEURISTIK** | Bindeglied zwischen "multiple beste Binaries" und der
Runtime-Auswahl der Hybrid-Binary. ECHTE PLANUNGSLUECKE, nicht nur ungelesen: Atlas 05b:786
"auch im HY-D2-Design-Doc nicht ausgearbeitet (grep Erkennungsheuristik/Last-Erkennung/
Workload-Erkennung/stochastisch im Doc = 0)". Deckung ausschliesslich Dossier-19 Punkt 4
("stochastisch haeufige Workload-Last") + Owner-Verbatim LEDGER:4176. Ohne diesen Posten
bleibt der Break-Even-Router dauerhaft wirkungslos. | OFFEN, T3, DEEP RESEARCH noetig |
Atlas 05b:786 . LEDGER:4176 |

| **V-09a-7 Feedback-Kante best_binary_selector -> Generierung (DEFERRED #156)** | Die
Auswertung muss auf die Tier-Binary-GENERIERUNG zurueckwirken (Doc 20 §C Chain of
Responsibility, strikt im CEB-Bereich). Im Code DREIFACH als unverdrahtet markiert:
selection_filter_chain.hpp:2-5 ("Schliesst die heute fehlende Feedback-Kante"), :110-113
("noch nicht verdrahtet ... strukturell UNERREICHBAR"), :122-125 ("DEFERRED (#156) ... Bis
dahin bleibt die Einhaengung eine reine Identitaet"). Nach der Kostenklammer-Doktrin
(20260806-PLAN-kostenklammer-restposten.md:18-22) ist der ausgelassene Teil nicht das Werkzeug
(erbracht, getestet), sondern die VERDRAHTUNG. | OFFEN, T3 | selection_filter_chain.hpp:2-5/
:110-113/:122-125 . Doc 20 §C:43-45 |

| **V-09a-8 DATENKORREKTHEIT vor allem anderen (4 Code-Befunde)** | (a) REV-DATA-12
Median-Divergenz: best_binary_selector.cpp:182-183 nutzt die nearest-rank-UNTERE Mitte,
csv_to_latex.cpp:48-54 und diagram_generator.cpp:414-420 die OBERE -- bei geradem n kann die
Thesis-Tabellenzahl von der Zahl abweichen, mit der der Sieger bestimmt wurde; im Code als
"(offen)" annotiert, in KEINEM Register. (b) Stiller Gruppen-Kollaps:
measurement_curve_loader.hpp:50-51 "Fehlt eine Gruppen-Spalte im Header, faellt ihre Dimension
auf '-'" -- fehlt workload, verschmelzen alle Lasten still zu EINER Gruppe, und "je
Eingangslast" ist die Owner-Definition der Synthese; Fix: Kollaps zaehlen und diagnostizieren
analog skipped_rows. (c) best_binary_selector.cpp:326-339: fehlende perm.dll.version -> leeres
Sidecar + leeres dll_build_version im Manifest, build() meldet ERFOLG. (d)
best_binary_selector.hpp:50-51 behauptet, der Selector haette "jede neu gebaute
Major-7-Binary verworfen" -- im gesamten .cpp (584 Z.) gibt es KEINE ABI-Pruefung und KEINEN
Verwerfungs-Pfad; zusaetzlich schreibt eine STALE gebaute Tool-Binary still falsche
ABI-Provenienz (live gemessen: abi_major=5 gegen Quellstand 8), weil der Paritaets-
static_assert nur den Uebersetzungs-, nicht den Ausfuehrungs-Zeitpunkt schuetzt. Alle vier
sind Owner-KERN "stiller Rueckfall verboten". | OFFEN, T2 (vor der Voll-Messung, weil sie
Ergebnis-Zahlen betreffen) | Zeilenstellen wie genannt |
```

**Zusaetzlich zu streichen (1 Zeile):**

```
| **§63-T-23 (best_binary_selector ABI-Spiegel stale)** |
20260806-DIFF-thesis-soll-gegen-ledger-und-code.md:499-505 traegt "TODO: §50-K-5 vor Abgabe
schliessen". GEGENSTANDSLOS: der Code steht auf kAbiMajor=8 / .A8., dreimal nachgezogen
(INC-2d 5->6, ORG-18 6->7, E-24 C8 7->8), mit Paritaets-static_assert in zwei Tests
(test_best_binary_selector_parse_rank.cpp:28/:32). Die Ledger-Zeilen :2726 und :3027 fuehren
einen Stand, den es seit drei Nachzuegen nicht mehr gibt. ZU TUN: Ledger-Vermerk nachziehen,
Vor-Abgabe-TODO streichen. Der Ausfuehrungs-Zeitpunkt-Schutz bleibt offen -> V-09a-8(d). |
ERLEDIGT/KORREKTUR | best_binary_selector.hpp:45-59 |
```

**Optional, abhaengig von der Owner-Wahl in §6.3:**

```
| **V-09a-9 Versandkanal (nur bei WEG A)** | ShippedArtifactBuilder liefert heute nach
--out <dir> per fs::copy_file + fs::rename; kein Kanal (grep -i minio ueber 1996 CI-Zeilen ->
11 Treffer, alle ccache oder Ebene-B-Tier-Binary-Cache; lager_pfad_grammatik.hpp 574 Z. kennt
kein Versand-Artefakt). Naht existiert: bestandslog/artifact_cache_transport.hpp:3-6. Sachlich
Teil von HY-B4 ("delegierter Bau-Kanal"). | OFFEN nur bei WEG A, sonst entfaellt | soll_design.md:402 |

| **V-09a-10 CLI-Frontend ohne CI-Deckung** | best_binary_selector_main.cpp (148 Z.) wird in
KEINER CI-Uebersetzungseinheit uebersetzt: grep -i best_binary ueber super .gitlab-ci.yml
(1361 Z.) + ce .gitlab-ci.yml (635 Z.) -> 0; cmake --build ohne --target -> 0 (kein Job baut
all). Gegenprobe: csv_to_latex|diagram_generator trifft (super:400, :481). Die Ranking-Logik
laeuft (2 Tests, Label tools;best_binary nicht von -LE pmc ausgeschlossen), das Frontend nicht.
Ein Compile-Bruch faellt erst beim manuellen Vollbau auf. | OFFEN, T3 | grep mit Gegenprobe |
```

---

## 8. Zeitliche Einordnung

**Der Rahmen** (`LEDGER:4377`, N-1, verbatim aus `20260806-KONTEXTUEBERGABE-abend-praezise.md:67`
und `docs/ARBEITSWEISE-GESAMT-DOKTRIN.md:359`): "Der End-Termin ist der **15.09.2026** und wir
muessen **JEDEN Freitag neue Ergebnisse liefern**." Die Termin-Klassen sind
(`20260806-DOSSIER-regressionen-checkheft.md:31`, uebernommen in `LEDGER:4400`):
**T1** = vor dem ersten 4096er-Batch · **T2** = vor der Voll-Messung · **T3** = vor dem
15.09.2026 · **T4** = danach.

**Die sechs Freitage** (nachgerechnet): **07.08.** (= erste Wochen-Lieferung, nicht die Abgabe)
· **14.08.** · **21.08.** · **28.08.** · **04.09.** · **11.09.** -- der 15.09.2026 ist ein
Dienstag.

### Voraussetzungs-Graph (was blockt was)

```
  V-09a-8 (Datenkorrektheit)  ──> muss VOR der Voll-Messung stehen (T2), sonst sind
                                  die Zahlen der Auswertung selbst verdaechtig
  Voll-Lauf [1] ──> V-09a-1 (Kanonisierung) ──> V-09a-2 (Orchestrator) ──> V-09a-4 (Multi-Last)
                          │                            ↑                        │
                          │                     V-09a-3 (Cluster)               │
                          │                                                     ▼
                          └──────────────────────────────────> V-09a-5 (Release+Wallclock)
                                                                              │
   V-09a-6 (Last-Erkennung, Deep Research -- laeuft PARALLEL, blockt nur HY-B2) │
                                                                              ▼
   K1/K2/K5/Q10.3/Q10.4 + Posten 90 ──> HY-B1a ──> HY-B1b ──> HY-B2 ──> HY-B3 ──> HY-B4
                                        (F8-Minimal-DoD)      (Router)          (+V-09a-5-Beweis)
   V-09a-7 (Feedback-Kante) ── additiv, jederzeit nach V-09a-2
```

### Vorschlag der Wochen-Zuordnung

| Freitag | Lieferung | Begruendung / Voraussetzung |
|---|---|---|
| **07.08.** | Abgabe + **Register-Nachtrag V-09a-1..8** + Streichung §63-T-23 | Kostet keine Bau-Zeit. Ohne diesen Nachtrag sind acht geplante Posten unsichtbar (§7.2). Owner-Wahl §6.3 (Weg A/B) faellt hier. |
| **14.08.** | **V-09a-8 (Datenkorrektheit, T2)** + **V-09a-1 Owner-Entscheid** | Beides ist Vorbedingung von allem Weiteren. (a)-(d) beruehren Ergebnis-Zahlen und muessen VOR der Voll-Messung stehen. Die Kanonisierung muss VOR dem §75-Aufraeumpass fallen, sonst entscheidet der Pass implizit (S-2). |
| **21.08.** | **V-09a-2 Auswertungs-Orchestrator** (Kern-Bruecke) + Start **V-09a-3** und **V-09a-6** (beide Deep Research, laufen parallel) | Der Orchestrator ist die einzige Naht [2]->[3]. Die beiden Forschungsposten haben lange Vorlaufzeit und blocken spaeter HY-B2. |
| **28.08.** | **V-09a-4 Multi-Last -> multiple beste Binaries** + Abschluss V-09a-3 | Braucht Orchestrator + Cluster. Ergebnis = die binary_id-Liste, ohne die HY-B1a nichts zu bestuecken hat. |
| **04.09.** | **Design-Auflagen K1/K2/K5/Q10.3/Q10.4 + Posten 90 entscheiden**, dann **HY-B1a (F8-Minimal-DoD)** | K5 explizit: "Bis zum Entscheid gilt keine Variante als implizit gesetzt" -- die Auflagen sind bindend VOR dem Bau. HY-B1a = 1 Standard-Dock, ctest-bewiesen (K6). |
| **11.09.** | **HY-B1b + HY-B2** (Dock-Array/Factory/Proxy + Break-Even-Router), **V-09a-5** Release+Wallclock-Nachmessung als Beweis | HY-B2 konsumiert die kanonisierten Kurven aus V-09a-1 und die Last-Erkennung aus V-09a-6. |
| **nach 15.09. (T4)** | **HY-B3** (XML scharf), **HY-B4** (Hybrid-als-Tier-Export, Snapshot-Aggregation nach K5, delegierter Bau-Kanal), **V-09a-7** Feedback-Kante, ggf. **V-09a-9** | HY-B3/B4 sind L-Pakete; die Owner-Etikette "Auswertungsphase" bindet sie nicht an den 15.09. |

**Kritischer Pfad:** V-09a-1 -> V-09a-2 -> V-09a-4 -> HY-B1a -> HY-B2. **Der laengste
Einzelposten mit unbekanntem Boden ist V-09a-6 (Last-Erkennungsheuristik)** -- er ist der
einzige, fuer den heute weder Code noch Design existiert (§5.4), und er muss deshalb
**frueh gestartet** werden, obwohl er erst spaet gebraucht wird.

**Was NICHT auf diesen Pfad gehoert:** der Voll-Lauf [1] selbst. Er ist eigener Posten
(G6/`LEDGER:263`), und die Auswertungs-Strecke kann in ihren Teilen (V-09a-1, -3, -6, -8)
**vor** ihm gebaut werden -- die Mathematik ist gegen die reale CSV bereits lauffaehig (§5.3).

---

## 9. Offene Owner-Fragen

| # | Frage | Sachlage | **Empfehlung** |
|---|---|---|---|
| **F-1** | **Thesis-Zusage "Binary-Versand": Weg A (bauen) oder Weg B (praezisieren)?** | Zusage haelt in enger Fassung; "Versand" = Verzeichniskopie (§6.2). | **Weg B.** Sechs Zeilen Text, kein Code am Vorabend der Abgabe, in einer Datei ohne CI-Deckung (S-9). Weg A gehoert sachlich in HY-B4. |
| **F-2** | **Welcher der drei Synthese-Stacks ist kanonisch?** (heuristik/ · builder/curve_fit+decision_lambda_trees · Selektor-Haelfte-B) | 1802 Z., 0 Prod-Konsumenten, alle drei rechnen dieselbe Rueckwaerts-Wahl. Das Plan-Ziel HY-B2 zeigt auf **①** (`soll_design.md:194`), der §75-Schutz auch (`LEDGER:3602`) -- aber der einzige CMake-angebundene CT-Entscheidungsbaum sitzt auf **②**. | **① `heuristik/` als kanonisch**, ② als *Konsument* umbauen (der Entscheidungsbaum bleibt, sein Kurven-Traeger wird AxisSpline), ③ nach dem Orchestrator-Bau zurueckbauen. Begruendung: nur ① ist plan- und schutzgedeckt, und nur ① traegt die Fritsch-Carlson-Begruendung gegen Schein-Schnittpunkte im Original. **Entscheid muss VOR dem §75-Pass fallen.** |
| **F-3** | **Die Last-Erkennungsheuristik ist NICHT detailliert geplant -- akzeptiert der Owner das als Luecke?** | Owner sagte "ebenfalls detailliert geplant". Das trifft fuer [2] und [4] zu, fuer [3c] nicht: 0 in Code, 0 im HY-D2-Design-Doc, 0 im Register (§5.4). | **Als Luecke melden und als Deep-Research-Posten frueh starten** (V-09a-6, Woche 21.08.). Sie ist der einzige Posten der Kette ohne Boden und blockt HY-B2. |
| **F-4** | **"Beste Binary" = EIN Sieger oder Pareto-FRONT?** | Drei Definitionen koexistieren: IST = ein Sieger je Metrik (`best_binary_selector.hpp:146`); SOLL/F8 = ein Sieger je Eingangslast; Deep-Research-Befund `20260710-kardinalitaeten-…:158` = "**Pareto-Front** (Menge nicht-dominierter Konfigurationen) statt 1 Einzelsieger ... getrennte Kurvenscharen je Objective, keine Mittelung". Als Fork §H-6 verbucht (`Doc 20:119`); `Doc 20:144` behauptet, die sieben §H-Forks seien in Doc 21 entschieden -- **das habe ich nicht am Objekt geprueft**. | **Erst Doc 21 lesen** (`21_SESSION_PLAN_TYPSYSTEM_ACHSEN_ENTSCHEIDUNGEN.md`), dann entscheiden. Wenn dort offen: **Pareto-Front je Workload-Cluster mit Objective-Tag** -- sie ist die einzige Fassung, die "multiple beste Binaries" (LEDGER:4176) mathematisch traegt; der Einzelsieger ist ihr Spezialfall bei einem Objective. |
| **F-5** | **"19 Min/Max-Semantiken je Achse" -- existiert die Festlegung?** | Die Doktrin fordert sie ("je Achse zu bestimmen"), `Doc 20:92` fuehrt sie in der PLAN-Spalte ("HEUTE 2 Objectives impl."). **Ich habe keine Datei gefunden, die je Achse die Optimierungsgroesse festschreibt.** Der IST-Selektor kennt genau eine Richtung (kleiner=besser, 6 ns-Metriken). | **Als eigenen Posten unter V-09a-1 fuehren.** Ohne die Min/Max-Zuordnung je Achse ist der Kurvenvergleich fuer Max-Achsen (z. B. Kompressionsverhaeltnis) systematisch falsch herum -- `break_even.hpp:17` setzt "besser = KLEINERER y-Wert" als **Konvention**, nicht als Achsen-Eigenschaft. |
| **F-6** | **Widerspruch: ist `selection_filter_chain.hpp` IST-Anker oder Dead-Code?** | Atlas `05b:749` fuehrt es als IST-Anker der Auswertungs-CoR; `docs/plaene/20260720-verworfene-referenzen-…:37` nennt es "CoR-Andockpunkt = Dead-Code (0 Prod-Treffer, nur test_d15)". Beide Bestandsaussagen, ungeklaert. Die Datei selbst sagt `:110-113`, ihre Kette sei "strukturell UNERREICHBAR", solange keine Zeilen gefuettert werden. | **Kein Widerspruch, sondern zwei Blickwinkel** -- die Einhaengung existiert, ist aber inert. **Empfehlung: als "gebaut, inert, DEFERRED #156" fuehren** (so steht es im Code) und den Atlas-Eintrag entsprechend qualifizieren. |
| **F-7** | **Darf der §63-T-23-Vor-Abgabe-TODO heute gestrichen werden?** | Er verlangt "§50-K-5 vor Abgabe schliessen"; der Code steht seit drei Nachzuegen auf kAbiMajor=8 mit Paritaets-static_assert (§5.6 S-4). | **Ja, streichen** -- und den Ledger-Vermerk `:2726`/`:3027` nachziehen. Der **Ausfuehrungs**-Zeitpunkt-Schutz bleibt als V-09a-8(d) offen; das ist ein anderer, kleinerer Posten. |
| **F-8** | **Nachtrag Posten 90 ins Hybrid-Design-Doc jetzt oder mit HY-B1a?** | Das Design-Doc stammt vom 02.08., die Owner-Praezisierungen (GoF-Einordnung Factory-Facade-Adapter, CT-Weitergabe **beider** Achsen-Arten) vom 05.08. (`LEDGER:4090/4091/4092`). Registriert als Posten 90 (Register `:349`). | **Mit dem 04.09.-Fenster**, unmittelbar vor HY-B1a. Ein Doku-Nachtrag ohne Bau nuetzt wenig; zusammen mit der K1/K2/K5-Entscheidung wird er zur Bau-Vorlage. Zugleich V-15 (`:443`) miterledigen. |

---

## Anhang: Fundstellen-Verzeichnis (absolute Pfade)

- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`
  -- `:96` V7.2-Praezisierung · `:215(e)` CEB-4-Modi · `:263` G6 · `:2296`/`:2301` F8 ·
  `:2726`/`:3027` stale K-5 · `:3602` §75-Freihaltung · `:4082`/`:4090`/`:4091`/`:4092`
  Vererbungs-Gesetz · `:4176` Owner-Kette · `:4377`/`:4400` Frist-Korrektur
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260806-REGISTER-todo-konsolidierung-14-tage.md` (474 Z.; `:349` Posten 90, `:440` V-09, `:443` V-15)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md:7` (Entscheid E1)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/architektur/20_HEURISTIK_MESSKURVEN_TYPSYSTEM_UND_FILTERKETTE.md` (§B `:19-35`, §C `:43-45`, §D `:49-57`, §G `:92`, §H-6 `:119`, `:144`)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/architektur/05b_uml_klassenatlas_20260805.html` (#zukunft `:713-786`)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/plaene/20260719-FINALES-DESIGN-ABSTRACT-kette-baum-registries.md:30` (D4)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/plaene/20260806-DIFF-thesis-soll-gegen-ledger-und-code.md:499-505` (§63-T-23, gegenstandslos)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/plaene/20260806-PLAN-kostenklammer-restposten.md:18-22` (Kostenklammer-Doktrin)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/audits/20260710-kardinalitaeten-deep-research-BEFUND-KARDINALITAETEN.md:158` (Pareto-Front)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/audits/20260716-wp5-rev-mining-DISPOSITION.md:53` (REV-DATA-12)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/docs/architecture/20260802-hybrid_tier_stufe_soll_design.md` (`:55-68` Ebenen/ABI · `:78-175` GoF+variant · `:188-203` Delegation/Router/§49 · `:220-234` XML · `:306-380` K1/K2/K5/K6 · `:394-402` Pakete · `:468` Null-Beleg)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/heuristik/` -- Stack ①
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/builder/curve_fit/curve_fit.hpp` + `.../builder/decision_lambda_trees/decision_lambda_trees.hpp` -- Stack ②
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/builder/best_binary_selector/` -- Haelfte A + Stack ③
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/builder/experiment_tree/selection_filter_chain.hpp` (`:2-5`, `:110-113`, `:122-125`)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/hybrid/README.md` -- einzige Datei des Ordners
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/thesis/diplomarbeit/kapitel/de/01_einleitung.tex:227-233` · `.../03_messsystem_prtart.tex:1401-1402,:1454-1482,:1519-1522` · `.../06_fazit.tex:195-197` (+ EN-Zwillinge `en/01:226`, `en/03:1378`, `en/06:190`)
- `/home/comdare/.claude/projects/-home-comdare/memory/feedback_hybrid_tier_stufe_hinter_ceb_variant_ausnahme.md` · `feedback_axes_optimization_semantics_deep_research_observer_strategy.md` · `feedback_heuristik_messkurven_typsystem_chain_of_responsibility.md` · `project_owner_kerne_20260806_abend_frist_messkette_ceb.md:14`
