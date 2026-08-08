# VORLAGE — XML-gesteuerte LaTeX-Anlage fuer die Diplomarbeit

**Stand 08.08.2026 · Synthese aus den Entwuerfen, den adversarischen Urteilen und eigener Gegenpruefung am Objekt**

> **Offenlegung zur Quellenlage dieser Vorlage.** Mir wurden zwei Entwuerfe zugestellt (`minimal`, `ct-rein`), der zweite abgeschnitten mitten im CI-Abschnitt; ein dritter war angekuendigt, ist aber nicht angekommen. Die adversarischen Urteile liegen nur fuer `minimal` vor (0 von 3 Stimmen tragfaehig), und auch dieses Urteil bricht am Ende ab. Ich habe deshalb **jede tragende Behauptung, auf der meine Empfehlung steht, selbst am Objekt nachgeprueft** — die Zeilennummern unten sind meine eigenen, nicht uebernommene. Wo ich nicht geprueft habe, steht es da.

---

## 1. WAS BEREITS GEPLANT WAR

Der Auftrag vom 08.08. ist **keine neue Idee**. Er ist die vierte Formulierung derselben Sache, und die dritte davon ist bereits als Ledger-Gesetz gebucht. Die Suche hat gefunden:

### 1.1 Der Owner hat es zweimal selbst formuliert (Juli)

> „Ich moechte die dort vorbereiteten Anhaenge-Kapitel automatisiert mithilfe der Interpretation und latex-code-Encodierung direkt mit den aktuellen Messwerten updaten und Messwert-Tabellen und Diagramme erstellen […] **Damit erzeugt ueber die gesamte Kette eine Einstellung der xml eine Diplomarbeit Evaluation mithilfe dynamisch ausgewerteter Messwerte, Tabellen und Diagramme. Damit haben wir eine CI-interaktive Diplomarbeit.**"
> — Owner, ca. 11.–12.07.2026, Transkript-Chunk 10/38, gesichert in `docs/sessions/backups/20260802-kontext-neugruendung-abend-workflows/ergebnisse/13-798ff6f6.md:19`
> *(Datum unsicher: der Chunk-Kopf traegt keine Datumszeile; verortet ueber die #22-Scharfschaltung im selben Chunk.)*

> „**Das Generieren der Latex anhaenge in der Diplomarbeit code ist Haupt-Ziel des Gesamt-Systems** und kombiniert das automatische erstellen der Ergebnisse in die Diplomarbeit PDF mit Auswertungsautomatisierung aus der xml-Kette bis zu den fertigen Ergebnissen (voll-Matrix mit Tabellen, Formeln und Diagrammen der echten Messwerte)."
> — Owner, ca. 13.–14.07.2026, `ergebnisse/17-9b750d94.md:16`

### 1.2 Es ist als Ledger-Gesetz gebucht (16.07.)

> **F1 JA+ERWEITERUNG:** ZIEL: „dass der Anwender (die Diplomarbeit) selbst in der XML waehlen kann, **wie jedes Experiment ausgewertet und veroeffentlicht wird** und wo und wie die Ergebnisse gespeichert werden" — **die Cache Engine stellt als Framework eine BIBLIOTHEK bereit, welche per XML-Config die ‚Programmierung' von Experimenten UND deren Auswertung erlaubt.**
> — `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:533`, 16.07.2026

> **§16.1-C2** — „**Die XML nennt explizit NUR EINEN Pfad: den Ziel-Ordner**, wo die Ergebnisse der Anfrage gespeichert werden" — Ergebnisse erst im BUILD-Pfad, dann build→ziel kopiert/kompiliert. *Code-Anker derselben Sektion: „build→ziel-Copy **fehlt heute**".*
> — `LEDGER.md:1509`, 16.07.2026

> **E-18** = LaTeX-Anhang-VORWAERTS-Kanal je CI (**= HAUPT-ZIEL des Gesamt-Systems**).
> — `LEDGER.md:3554`, 26.07.2026, §68c

### 1.3 Was bereits GEBAUT ist

- **E-18-Vorwaertskanal** (`ci/anhang_forward_core.sh` + Job `anhang:forward`) — gelandet 06.08., aber **INERT**: „Pipeline 14756 angelegt, Job-Liste OHNE anhang:forward […] Job bleibt INERT bis Token/Var-Scharfschaltung. Owner-offen bleibt: **Ziel-Branch development vs. main/Overleaf (R2)**." (`LEDGER.md:7116 ff.`, 06.08.)
- **M08 `appendix_generator`** schreibt heute je Sprache alle Darstellungsformen (Heatmap, 3D, Ratio, Normbar, Sweep, Forest, Pareto, ECDF, Range, Segment-Attribution, Observer-Detail, Achsen-Inventar, Bias, Exchange, Limitierung) — honest-empty-fest.
- **Anhang-Verdrahtung Weg A** (`\InputIfFileExists` mit eigenem Ersatztext) — in `anhang/de/A_measurements.tex` **30 Eintraege**, verifiziert.

### 1.4 Was der Auftrag vom 08.08. NEU hinzufuegt

Drei Dinge, die in **keiner** Quelle vorher stehen (Nullbefund, Muster unten):

1. **Auswahl und Reihenfolge aus der XML.** Bisher galt das Gegenteil: F10 (16.07., `LEDGER:533`) sagt woertlich „aus einem **FEST VERDRAHTETEN** Output des Messsystems".
2. **Aufmachung aus der XML** (welche Darstellungsform fuer welchen Messwert).
3. **Schaltende Textbausteine im Hauptteil** („in der Auswertung und Evaluation").

**Nullbefund-Muster** (alle in `docs/`, `--include=*.md`, `/usr/bin/grep`):
`<darstellung|<figures|<report|<auswertung|<sections|<chapters|<tables>` → 0 · `Reihenfolge.{0,40}(Darstellung|Tabelle|Abbildung)` → 0 einschlaegige · `XML.{0,60}(Darstellung|Abbildung|Tabelle)en?` → 0 · `adaptive (Prosa|Text)|Ergebnis-Makro|Wert-Makro|schaltet.{0,30}Text` → 0 · `newcommand` ueber den ganzen Thesis-Baum (`*.tex`,`*.sty`) → **kein einziges Ergebnis-Makro**.
**Gegenproben, die trafen:** `<writeback_methods` → 3 Treffer · `latex_path` → 8 im ce-Code + 2 im Katalog · `Prosa` im Ledger → 12 (Engine liest Nicht-ASCII korrekt).

### 1.5 Der Betreuer hat 2026-05-08 etwas AEHNLICHES, aber nicht dasselbe verlangt

> „VORDEFINIERTE TEXTBAUSTEINE — Im LaTeX-Sourcecode der Diplomarbeit (**NUR im Appendix-Bereich**) eingebettete Bausteine, die zur Compile-Zeit Werte aus Binary-Dumps einsetzen. Beispiel: `\PRTARTPlot{dataset=YCSB-A, isa=AVX-512, metric=p99-latency, baseline=ART_Node256, compare=PRTART_DenseByte}`"
> — Habich-Feedback H3, `docs/termine/20260508 Termin 7/Habich_Feedback_2026_05_08.txt:106-117`

**Das steht in echter Spannung zum Auftrag vom 08.08.** (Betreuer: nur Appendix; Owner: auch Auswertung/Evaluation) und zur Umsetzungsart (Betreuer: LaTeX liest zur Compile-Zeit Binary-Dumps; hier: der Generator rechnet vorher, LaTeX setzt nur ein). → **Entscheid O-4** in Abschnitt 7.

---

## 2. DER EMPFOHLENE ENTWURF

### 2.1 Das Urteil

**`minimal` faellt durch — nicht wegen seiner Ideen, sondern weil seine Kernbehauptung falsch ist.** Er verspricht Minimal-Invasivitaet durch Wiederverwendung von M08 und E-18. Ich habe die fuenf schwersten Einwaende selbst nachgeprueft; **alle fuenf bestaetigen sich am Objekt**:

| Befund | Beleg (selbst geprueft) |
|---|---|
| Die CI wuerde die **falsche XML-Familie** durchreichen | `.gitlab-ci.yml:723` setzt `COMDARE_THESIS_PROFILE` auf `m3_smoke_coverage.profile.xml`; deren Wurzel ist `<comdare_thesis_profile>` (Zeile 43). `xml_config_parser.cpp:454`: `if (!root \|\| root->tag != "comdare_experiment") return std::nullopt;` → **Nullbefund, die Anlage bliebe leer** |
| `measure:golden-320` **bricht ab** | `COMDARE_THESIS_PROFILE` existiert NUR in `measure:smoke` (`:723`); der golden-Job hat es nicht. Unter `set -euo pipefail` = unbound variable = exit 1 nach bis zu 10 Tagen Messlauf |
| Die Kapitel-Anlage wird **kopiert, aber nie committet** | `ci/anhang_forward_core.sh:235` stagt ausschliesslich `anhang/$lang/tabellen`; `:220` schreibt auch nur diesen Pfad in `$COPIED_LIST`. Eine Datei daneben => `changed=0` => „IDEMPOTENT: 0 Aenderungen" => RC 0. **Stiller Ausfall von Auftragsteil (c)** |
| „Filter" erzeugt **stille Staleness** | `anhang/de/A_measurements.tex` bindet **17 Fragmente mit blankem `\input`** ein (Z. 18,19,33,34,53,61-66,260-263,290). `git ls-files anhang/de/tabellen/` = **18 getrackte Dateien**. Der Kanal loescht nie. Nicht-Schreiben => alte committete Datei bleibt und wird weiter eingebunden => **PDF zeigt Juni-Zahlen ohne Warnung** |
| Die neuen Exit-Codes werden **verschluckt** | `.gitlab-ci.yml:775` und `:867` enden je auf `\|\| echo "appendix-generator: honest-empty/Teil-Output (n/a-Spalten) — kein Fehler"`. Jeder neue Code ist von honest-empty ununterscheidbar |

Dazu bestaetige ich einen sechsten: `kapitel/en/07_results_evaluation.tex` **existiert, ist aber nicht eingebunden** — `diplomarbeit.tex:280-285` bindet `kapitel/\thesislang/01_einleitung … 06_fazit` ein. Die englische Evaluation ist `kapitel/en/05_evaluation.tex`.

**`ct-rein` gewinnt** — und zwar aus einem Grund, der in keinem der Urteile steht: **es schreibt seine eigenen Fragmente in einen eigenen Namensraum, statt die von M08 zu filtern.** Damit sind Blocker 4 (Exchange-Tabellen-Granularitaet: `write_exchange_longtables()` bekommt ein Verzeichnis und benennt selbst) und Blocker 5 (Filter = Staleness) **konstruktiv aufgeloest**, nicht nur repariert. Das ist der Unterschied zwischen „Regie ueber fremde Maschinerie" und „eigene Maschinerie".

### 2.2 Der empfohlene Entwurf: **ANLAGE-XML**

`<report>`-Abschnitt im **`comdare_thesis_profile`**-Kanal → eigenes Modul `Code/10_report_composer` → eigener Namensraum `anhang/<lang>/generated/` → **manifest-getriebene** CI-Kopie ueber den bestehenden E-18-Kanal.

**Was von wem stammt:**

| Idee | Herkunft |
|---|---|
| Eigenes Modul `Code/10_report_composer` statt M08-Regie | **ct-rein** |
| constexpr-Registries (Form/Reducer/Praedikat/Sprache) + statischer Dispatch via `index_sequence`-Fold + `consteval`-Vollstaendigkeitswache | **ct-rein** (Muster aus `writeback_method_registry.hpp`) |
| `report_manifest.txt` mit sha256 je erzeugtem Pfad | **ct-rein** |
| `--check-lang-parity` als HARTER CI-Job (EN fehlt = rot) | **ct-rein** |
| `\csname erg@…\endcsname`-Namensraum statt Einzel-`\newcommand` — nie undefiniert, keine geplatzte PDF | **minimal** |
| `\Erg{}` / `\ErgWenn{}{}{}` als Praeambel-Trio, **Prosa bleibt in der Thesis, nur die Bedingung kommt aus der Messung** | **minimal** |
| `<latex_appendix target_dir>` als der eine XML-Zielordner (§16.1-C2) | **minimal** |
| Deprecate-Schritt fuer die E-18-Negativzusage | **minimal** (S15) |
| **`<report>` haengt an `comdare_thesis_profile`, nicht an `comdare_experiment`** | **neu (meine Gegenpruefung)** — beide Kanaele teilen sich laut `xml_config_parser.cpp:95-96` bereits eine gemeinsame Parse-Funktion; hier wird derselbe Weg gegangen |
| **Das Manifest ist gleichzeitig Staging-Liste, Byte-Delta-Umfang und Rollback-Liste** — eine Liste, drei Verwendungen | **neu** — heilt Blocker 3 an der Wurzel statt per Sonder-ENV |
| **Kein Filtern der M08-Fragmente.** M08 schreibt weiter alle Fragmente unveraendert; `<report>` komponiert nur das Kapitel | **neu** — heilt Blocker 5 vollstaendig und macht die Byte-Identitaets-Zusage trivial wahr |
| **Kein `file_pattern` und keine Prosa in ce** — die Registry kennt nur abstrakte Formen; Dateinamen gehoeren super, Prosa gehoert der Thesis | **neu** — Antwort auf den Layering-/Eigentums-Einwand D2 |

### 2.3 Die drei Setzungen, die ich selbst treffe

Ableitbar, deshalb kein Owner-Entscheid — aber ausdruecklich benannt:

**SETZUNG 1 — Traeger ist `comdare_thesis_profile`.** Die `comdare_experiment`-Familie ist im Messbetrieb nicht angeschlossen (`Code/test_data_xml/experiment_golden.xml` haengt als Compile-Define an einem Test). Die Anlage muss an dem Profil haengen, das die Messung wirklich fuehrt.

**SETZUNG 2 — `<report>` steuert die Komposition, nicht die Erzeugung.** M08 schreibt weiterhin jedes Fragment. Der Composer erzeugt zusaetzlich seine eigenen Bloecke unter `generated/`. Nichts wird jemals „weggelassen" — damit kann keine alte Datei still ueberleben.

**SETZUNG 3 — Prosa lebt in der Thesis, Bedingungen in der Messung.** `<switch>` traegt nur ein Praedikat, nie deutschen oder englischen Satz. Bild-/Tabellenunterschriften duerfen aus der XML kommen (sie kommen heute aus C++-String-Literalen in super — die XML ist kein *neuer* unlinted Ort, sondern ein besser sichtbarer), aber Fliesstext nie.

---

## 3. DER XML-ABSCHNITT IM WORTLAUT

Einzufuegen in ein Thesis-Profil, z. B. `libs/cache_engine/algorithm_profiles/thesis_profiles/m3_golden_coverage.profile.xml`, als Geschwister von `<permute_axes>` / `<run_options>`. **Fehlt der Block, ist das Verhalten byte-identisch zu heute.**

```xml
<comdare_thesis_profile id="m3_golden_coverage" schema_version="1">

  ...  <!-- base_tiers, permute_axes, sweep_axes, writeback_methods, run_options: unveraendert -->

  <!-- =====================================================================
       (a) ZIELORDNER + Sprachen.  dir ist der EINE Pfad im Sinn von 16.1-C2:
       geschrieben wird erst in den BUILD-Pfad, danach dorthin kopiert.
       ${date} loest sich wie in <output> auf.
       ACHTUNG Hausfalle: KEIN doppelter Bindestrich in XML-Kommentaren.
       ===================================================================== -->
  <report dir="_runs/${date}/diplomarbeit_golden/anlage">

    <!-- role="lead" GENAU EINMAL. Fehlt eine follow-Sprache irgendwo,
         bricht der CI-Job report:lang-parity HART ab (Code 15). -->
    <languages>
      <lang code="de" role="lead"/>
      <lang code="en" role="follow"/>
    </languages>

    <!-- =================================================================
         (b) DIE ANFORDERUNG.  Dokument-Reihenfolge IST Ausgabe-Reihenfolge;
         order= ist nur die explizite, stabile Zweitangabe fuer Diffs.
         file= ist ein NAME, kein Pfad:  [A-Za-z0-9_]{1,48}
         ================================================================= -->
    <chapter id="anlage_G" file="G_generierte_ergebnisse" order="10">
      <title lang="de">Erzeugte Ergebnisse der Messkette</title>
      <title lang="en">Generated Results of the Measurement Chain</title>

      <!-- form= MUSS eine id aus kReportFormRegistry sein.
           Unbekanntes Token = HARTER Abbruch mit Auflistung der gueltigen. -->
      <block id="tab_top5_lookup" form="table_longtable" order="10">
        <select metric="op_lookup_p50_ns"/>
        <group_by>search_algo workload</group_by>
        <filter axis="node_type" value="dense_byte"/>
        <sort key="median" dir="asc"/>
        <limit n="5"/>
        <caption lang="de">Die fuenf schnellsten Suchverfahren je Lastprofil</caption>
        <caption lang="en">The five fastest search algorithms per workload</caption>
        <label>tab:gen:top5-lookup</label>
      </block>

      <block id="fig_flaeche_lookup" form="heatmap2d" order="20">
        <select metric="op_lookup_p50_ns"/>
        <axes x="workload" y="search_algo"/>
        <caption lang="de">Latenz-Flaeche Lookup ueber Lastprofil und Suchverfahren</caption>
        <caption lang="en">Lookup latency surface over workload and search algorithm</caption>
        <label>fig:gen:flaeche-lookup</label>
      </block>

      <block id="fig_pareto" form="pareto" order="30">
        <select metric="op_lookup_p50_ns" second_metric="op_lookup_p99_ns"/>
        <caption lang="de">Pareto-Streuung p50 gegen p99 je Konfiguration</caption>
        <caption lang="en">Pareto scatter p50 versus p99 per configuration</caption>
        <label>fig:gen:pareto</label>
      </block>
    </chapter>

    <!-- =================================================================
         (d1) VARIABLEN.  Je <value> genau EIN LaTeX-Makro, aus DERSELBEN
         einmal geparsten WIDE-Matrix.  reducer= aus kReportReducerRegistry.
         ================================================================= -->
    <values>
      <value key="besteLatenzNs"  reducer="min"    metric="ns_per_op"
             format="fixed2" unit="ns"/>
      <value key="refLatenzNs"    reducer="median" metric="ns_per_op"
             filter_axis="search_algo" filter_value="linear_scan"
             format="fixed2" unit="ns"/>
      <value key="permAnzahl"     reducer="count"  metric="ns_per_op"
             format="int"/>

      <!-- GESPERRT bis die COMPARE-Stufe D2 gebaut ist (Task #46).
           argmin und ratio_vs_reference sind AUSWERTUNGS-Semantik und
           duerfen nicht zweimal definiert werden.
      <value key="besterAllokator" reducer="argmin" metric="ns_per_op"
             group_by="memory_layout" format="ident"/>
      <value key="faktorGegenRef"  reducer="ratio_vs_reference" metric="ns_per_op"
             reference_axis="search_algo" reference_value="linear_scan"
             format="fixed2"/>
      -->
    </values>

    <!-- =================================================================
         (d2) SCHALTER.  NUR das Praedikat.  Die Prosa steht in der Thesis,
         auf Deutsch und auf Englisch, dort wo alle andere Prosa steht.
         @key verweist auf ein zuvor deklariertes <value>; nackte Zahl =
         Literal.  Vorwaertsreferenz = harter Fehler.
         ================================================================= -->
    <switches>
      <switch key="refUnterboten" predicate="lt" lhs="@besteLatenzNs"
              rhs="@refLatenzNs" tolerance="0.02"/>
      <switch key="korpusVoll"    predicate="ge" lhs="@permAnzahl" rhs="320"/>
    </switches>

  </report>

</comdare_thesis_profile>
```

**Erzeugtes Layout** unter `<dir>`:

```
<lang>/generated/G_generierte_ergebnisse.tex   <- die Kapitel-Huelle, \input in order-Folge
<lang>/generated/blocks/<block_id>.tex         <- je ein Block-Fragment
<lang>/generated/ergebnis_variablen.tex        <- die Wert-Makros
<lang>/generated/ergebnis_schalter.tex         <- die Flags
report_manifest.txt                            <- eine Zeile je relativem Pfad + sha256
```

Der Namensraum `generated/` ist **getrennt von `tabellen/`**, wo M08 unveraendert weiterschreibt. Keine Datei kollidiert, kein Fragment wird ersetzt.

---

## 4. DIE VARIABLEN- UND TEXTBAUSTEIN-MECHANIK

### Das Problem

Ein `\newcommand{\besteLatenzNs}` waere vor dem ersten Messlauf undefiniert und wuerde die PDF reissen. Heute gibt es im gesamten Thesis-Baum **kein einziges Ergebnis-Makro** (Nullbefund verifiziert, Abschnitt 1.4).

### Der Generator schreibt (DE)

`anhang/de/generated/ergebnis_variablen.tex`:

```latex
% GENERIERT -- nicht von Hand aendern.
% Quelle: <report><values> aus m3_golden_coverage.profile.xml, Lauf 20260808-0412
% Definierte Namen: besteLatenzNs refLatenzNs permAnzahl
\expandafter\gdef\csname erg@besteLatenzNs\endcsname{12,43}
\expandafter\gdef\csname erg@refLatenzNs\endcsname{18,07}
\expandafter\gdef\csname erg@permAnzahl\endcsname{320}
```

`anhang/de/generated/ergebnis_schalter.tex`:

```latex
\expandafter\gdef\csname erg@flag@refUnterboten\endcsname{1}
\expandafter\gdef\csname erg@flag@korpusVoll\endcsname{1}
```

Die EN-Fassung ist **inhaltlich** verschieden, nicht kosmetisch: `{12.43}` statt `{12,43}`. Der Composer benutzt dafuer denselben Lokalisierungs-Helfer wie `04_csv_to_latex` / `05_diagram_generator`.
*Unsicher: ich habe nicht geprueft, ob dort ein gemeinsamer Helfer existiert. Existiert er nicht, ist das der erste Befund des Bau-Pakets — der Helfer wird gezogen, nicht neu erfunden, sonst brechen Zahlenformate zwischen Fliesstext und Tabelle im selben Dokument auseinander.*

### Die Thesis bekommt EINMALIG (Praeambel `diplomarbeit.tex`, hinter `\input{config/language.tex}`)

```latex
\providecommand{\ergUnbekannt}{\textbf{[?]}}
% Wert: nie undefiniert -- ein nicht generierter Name faellt sichtbar auf.
\newcommand{\Erg}[1]{\ifcsname erg@#1\endcsname\csname erg@#1\endcsname\else\ergUnbekannt\fi}
% Schalter: DREI Zweige.  Ohne Messung wird KEINE Behauptung gedruckt.
\newcommand{\ErgWenn}[3]{%
  \ifcsname erg@flag@#1\endcsname
    \ifnum\csname erg@flag@#1\endcsname=1\relax #2\else #3\fi
  \else \ergUnbekannt\fi}
\InputIfFileExists{anhang/\thesislang/generated/ergebnis_variablen.tex}{}{}
\InputIfFileExists{anhang/\thesislang/generated/ergebnis_schalter.tex}{}{}
```

**Der dritte Zweig ist der wichtige Teil.** Ein zweiwertiges `\ErgWenn` haette bei fehlendem Flag den Else-Zweig gedruckt — also eine **inhaltliche Behauptung aus Datenmangel**. Das ist wissenschaftlich schlechter als eine rote PDF. Mit dem dritten Zweig steht dort `[?]`, sichtbar, unuebersehbar, und der Lint aus S12 findet es.

### Im Fliesstext — DE fuehrt

`kapitel/de/05_evaluation.tex`:

```latex
Die schnellste gemessene Konfiguration erreicht \Erg{besteLatenzNs}\,ns/op;
die Referenz \texttt{linear\_scan} liegt bei \Erg{refLatenzNs}\,ns/op ueber
\Erg{permAnzahl} Permutationen.
\ErgWenn{refUnterboten}
  {Die Referenz wird damit unterboten; der Vorteil geht auf die Achsen-Wahl zurueck.}
  {Die Referenz wird nicht unterboten; der erwartete Vorteil der Achsen-Wahl bleibt aus.}
```

### Englisch zieht nach

`kapitel/en/05_evaluation.tex` — **nicht** `07_results_evaluation.tex`; die Datei existiert, ist aber laut `diplomarbeit.tex:280-285` nicht eingebunden (Alt-Struktur, un-included):

```latex
The fastest measured configuration reaches \Erg{besteLatenzNs}\,ns/op;
the \texttt{linear\_scan} reference sits at \Erg{refLatenzNs}\,ns/op across
\Erg{permAnzahl} permutations.
\ErgWenn{refUnterboten}
  {The reference is thereby beaten; the advantage stems from the axis selection.}
  {The reference is not beaten; the expected advantage of the axis selection does not materialise.}
```

Die Makronamen sind sprachneutral, die Werte sprachabhaengig, die Prosa sprachspezifisch und von Hand geschrieben. `\thesislang` waehlt zur Compile-Zeit die richtige Variablen-Datei (`diplomarbeit.tex:18`, `:290-295` — verifiziert).

---

## 5. DIE BAU-SCHRITTE

Jeder Schritt hat ein Abnahmekriterium, das **literale Ausgabe** verlangt — kein Haken ohne Beleg.

| # | Schritt | Abnahme |
|---|---|---|
| **S1** | `report_form_registry.hpp`, `report_reducer_registry.hpp`, `report_predicate_registry.hpp`, `report_language_registry.hpp` in ce unter `libs/cache_engine/include/cache_engine/report/`. **Ohne `file_pattern`-Spalte, ohne Prosa.** Muster: `writeback_method_registry.hpp` (Groessen-Anker, Index-Identitaet, Namen-Anker, `for_each_*`-Fold) | Eine absichtlich hinzugefuegte Enum-Auspraegung ohne Registry-Eintrag bricht den Bau; die `static_assert`-Meldung wird literal gezeigt |
| **S2** | `report_form_impl.hpp`: `template <ReportForm F> struct ReportFormImpl` **primaer undefiniert**, CRTP-Basis, Concept `ReportFormLike`, `visit_report_form()` als `index_sequence`-Fold, `consteval all_report_forms_implemented()` | Eine auskommentierte `ReportFormImpl`-Spezialisierung erzeugt einen Compile-Fehler, nicht eine Laufzeit-Luecke. Meldung literal |
| **S3** | XSD: `ReportType` + `report` `minOccurs="0"` im **`comdare_thesis_profile`**-Typ von `Code/test_data_xml/experiment_schema.xsd`. **Vorher pruefen**, ob `Code/tests/fixture_schema_subset_check.cmake`, `xml_canonical_utils.cmake`, `golden_n_consistency_check.cmake` die Ergaenzung neutral vertragen | Die drei `.cmake`-Pruefungen laufen vor und nach der Ergaenzung mit identischem Ergebnis; beide Ausgaben nebeneinander |
| **S4** | `xml_config_parser.{hpp,cpp}`: `struct ThesisReport` + `parse_thesis_profile`-Block, roh, **keine Token-Pruefung** (Baseline-Layering; Muster `measurement_categories`, `:406-408`) | Round-Trip-Test: Profil ohne `<report>` parst byte-identisch zu vorher; Profil mit `<report>` liefert die Rohstrings |
| **S5** | `validate_profile` (cache_engine-Schicht) prueft `form`/`reducer`/`predicate`/`lang` gegen die Registries, Eindeutigkeit von `block id` **und** `label` ueber das ganze Profil, `role="lead"` genau einmal, `@key`-Rueckwaertsreferenz, Namens-Regexe | Sechs Bissproben, je ein absichtlicher Fehler, je die literale Fehlermeldung mit Auflistung der gueltigen Tokens |
| **S6** | Neues Modul `Code/10_report_composer/` (hpp/cpp/main_cli/CMakeLists/tests), `add_subdirectory` in `Code/CMakeLists.txt`. Linkt `comdare::csv_to_latex`, `comdare::diagram_generator`, `comdare::cache_engine_headers` | `cmake --build --target report_composer_cli` gruen; `report-composer --help` gibt die Usage aus |
| **S7** | `compose_report()`: WIDE-Matrix **einmal** parsen, je Sprache Bloecke + Kapitel-Huelle + Variablen + Schalter schreiben, `report_manifest.txt` mit sha256 je Pfad | Fixture-Lauf: `wc -l report_manifest.txt` und `sha256sum -c` gegen die erzeugten Dateien, beide literal |
| **S8** | Fehlerklassen und getrennte Exit-Codes: `12` honest-empty, `13` unbekannte Form, `14` unbekannter Reducer, `15` Sprach-Luecke, `16` angeforderte Spalte fehlt im Korpus, `17` `@key` ohne `<value>`, `18` id-/label-Kollision. **Jede Klasse zusaetzlich als `WARNUNG fehlerklasse=<name>` ins Log** (Hausmuster: `apps/experiment_planner/main.cpp:95`) | Sieben Bissproben, je der literale Exit-Code plus die `fehlerklasse=`-Zeile |
| **S9** | `--check-lang-parity` als reine Pruefung ohne Schreiben | Profil mit fehlendem `<caption lang="en">` liefert Exit 15 und nennt Block-id und Sprache |
| **S10** | Thesis-Verdrahtung **DE zuerst**: Praeambel-Trio in `diplomarbeit.tex`, dann `\InputIfFileExists{anhang/\thesislang/generated/G_generierte_ergebnisse}` am Ende von `anhang/de/A_measurements.tex`; danach `anhang/en/A_measurements.tex` nachziehen | `latexmk` baut DE und EN ohne die generierten Dateien fehlerfrei; Seitenzahl vor/nach identisch |
| **S11** | Erste echte Nutzung: drei `\Erg{}` und ein `\ErgWenn{}` in `kapitel/de/05_evaluation.tex`, danach `kapitel/en/05_evaluation.tex` | PDF gebaut **ohne** Variablen-Datei zeigt an allen vier Stellen `[?]`; **mit** Variablen-Datei zeigt sie die Werte. Beide PDFs, beide Stellen, im Log |
| **S12** | Namens-Lint (`/usr/bin/grep`, kein neues Werkzeug): jeder im Fliesstext benutzte `\Erg{name}` / `\ErgWenn{name}` muss in der Kommentarzeile „Definierte Namen:" des Manifests vorkommen | Ein absichtlicher Tippfehler laesst den Lint rot werden, mit Nennung des Namens und der Fundstelle |
| **S13** | chktex-Entscheidung fuer generierte Dateien umsetzen: der Composer schreibt `% chktex-file 1 % chktex-file 8` in Kopf jeder erzeugten `.tex` | Der Lint laeuft ueber `anhang/*/generated/` ohne Befund; die Kopfzeile im literalen Auszug |
| **S14** | `ci/anhang_forward_core.sh` **manifest-getrieben** umbauen: Kopie, `$COPIED_LIST`, `git add` und der Byte-Delta-Umfang lesen alle aus `report_manifest.txt` statt aus dem hartkodierten `anhang/$lang/tabellen`. Ziel-Wache: nur Pfade unter `^anhang/(de\|en)/(tabellen\|generated)/` werden akzeptiert, alles andere exit 1. Namens-Wache, „nie loeschen", Idempotenz, PDF-Gate, Rollback: unveraendert | Dry-Run zeigt eine gestagte Datei unter `generated/`; ein Manifest-Eintrag mit `../` bricht mit exit 1 und literaler Meldung |
| **S15** | `.gitlab-ci.yml`: neue Stage `report` mit `report:compose`, `report:lang-parity`, `report:pdf-gate`. `COMDARE_THESIS_PROFILE` **auch** im `measure:golden-320`-`variables:`-Block setzen (auf das golden-Profil) und alle Nutzungen als `${COMDARE_THESIS_PROFILE:-}` schreiben | `measure:golden-320` laeuft mit `set -euo pipefail` durch; der Job-Log zeigt den aufgeloesten Profilpfad literal |
| **S16** | Die drei `\|\| echo "… kein Fehler"`-Stellen (`.gitlab-ci.yml:765,775,857,867`) durch `rc=$?; case` ersetzen: nur `0` und `12` sind gruen, alles andere bricht ab | Ein injizierter Exit 13 macht den Job rot; ein injizierter Exit 12 laesst ihn gruen. Beide Logs |
| **S17** | Golden-Neutralitaets-Beweis: `declared_count` und golden-CRC vor und nach dem Paket | Beide Zahlen literal nebeneinander, identisch. `<report>` ist `binary_id`-neutral — **das ist eine Behauptung, bis sie hier steht** |
| **S18** | Plan-Doku nachziehen: die E-18-Negativzusage „0 Dateien ausserhalb `anhang/<lang>/tabellen/*.tex`" (`docs/sessions/20260805-PLAN-b1-e18-vorwaerts-kanal.md`) **deprecaten, nicht loeschen**; Ledger-Eintrag zu F10 als abgeloest markieren | Beide Dokumente zeigen den Deprecate-Vermerk mit Datum und Ersatz-Verweis |

**S1–S9 und S17 sind unabhaengig vom Owner-Entscheid O-4** (sie bleiben im Anhang). **S11 setzt O-4 voraus.**

---

## 6. DIE SCHWERSTEN EINWAENDE

**E1 — „Die untere Schicht darf die Artefaktnamen der oberen nicht kennen" (D2).**
Gilt und ist beruecksichtigt: die Form-Registry in ce traegt **nur abstrakte Formen** (`heatmap2d`, `pareto`, …), keine `file_pattern`-Spalte. Die Dateinamen entstehen ausschliesslich im super-Modul M10 aus `block id`. Das war der eigentliche Verstoss in `minimal`, nicht die Registry selbst.

**E2 — Eigentums-Vermischung Thesis (BEP privat) / CacheEngine (BEP Venture UG).**
Gilt und ist beruecksichtigt: **kein deutscher oder englischer Fliesstext in ce.** Bild-/Tabellenunterschriften stehen in der Profil-XML, die im ce-Repo liegt — das ist eine bewusste Restlast, siehe **Entscheid O-2**. Die Rechtfertigung, dass die Auswertungs-Steuerung ueberhaupt in ce gehoert, kommt vom Owner selbst: F1, 16.07. — „die Cache Engine stellt als Framework eine BIBLIOTHEK bereit, welche per XML-Config die ‚Programmierung' von Experimenten **UND deren Auswertung** erlaubt".

**E3 — „Neue Steuerung IMMER in die XML, nie als CLI-Arg/env" (D4).**
Teils beruecksichtigt, teils **steht der Einwand**. Die Steuerung liegt in der XML; der Composer bekommt nur den Profilpfad als Argument. Aber `ci/anhang_forward_core.sh` bleibt ein ENV-gesteuertes Shell-Skript. Ich habe die Doppelung des Zielordners beseitigt (das Manifest ist die einzige Wahrheit, `AF_TARGET_DIR` entfaellt), aber der Kanal selbst bleibt Shell. Das restlos aufzuloesen hiesse, den Vorwaertskanal in C++ zu ziehen — ein eigenes Paket. **Rest-Einwand steht, bewusst.**

**E4 — Zwei Autoritaeten fuer die Bildunterschrift (D5).**
`main_cli.cpp:33-35` traegt heute `--bias-label=`, `--bias-caption-de=`, `--bias-caption-en=`. Diese Argumente betreffen **M08**, nicht M10, und werden nicht dupliziert — M10 hat einen eigenen Namensraum. Der Einwand faellt fuer den neuen Entwurf weg, aber der Altbestand bleibt ein Behelfsweg; er gehoert in ein Aufraeum-Paket (Owner-Entscheid nicht noetig, ich reihe ihn ein).

**E5 — Silent Fallback (D7).**
Zur Haelfte beantwortet: `\ErgWenn` hat jetzt **drei** Zweige, druckt bei fehlendem Flag `[?]` statt einer Behauptung. `\Erg{tippfehler}` faellt weiterhin auf `[?]` — bewusst, damit die PDF immer baut — aber S12 macht daraus einen roten Lint. `\InputIfFileExists` bleibt, es ist der einzige Weg, der eine Abgabe nicht reissen laesst. **Der Fallback ist da, aber er ist laut.**

**E6 — Zweite Auswertungs-Wahrheit neben COMPARE/D2 (Task #46).**
Steht und wird nicht aufgeloest, sondern **gesperrt**: `argmin` und `ratio_vs_reference` sind in der Registry vorhanden, aber im Validator bis D2 abgelehnt. Erlaubt sind zunaechst nur `min`, `max`, `median`, `count`. Es darf nicht zwei Definitionen von „bester" geben.

**E7 — Metrik-Decke.** `diagram_generator.hpp:323-324` pinnt `z_field` auf sechs Felder. PMC-Zaehler, Speichergroessen, Durchsatz, `branch_misses` sind heute **nicht anforderbar**. Der Owner sagt „alle Messwerte … die gewuenscht sind". → **Entscheid O-3.**

**E8 — Welches Profil ist autoritativ? (D10)** Unter `thesis_profiles/` liegen 11 Profile. Die Quellen-Kaskade in `anhang_forward_core.sh` nimmt die **erste** Wurzel mit `>0 .tex` aus `AF_ARTIFACT_ROOTS="Code/measure_out/appendix Code/measure_out_smoke/appendix"` — faellt golden aus, gewinnt smoke. → **Entscheid O-1.**

**E9 — Zwei-Repo-Lockstep (D13).** XSD liegt in super, Parser in ce. S3 und S4/S5 sind verschiedene Repos mit Gitlink-Kopplung. Reihenfolge: **erst ce (Parser tolerant gegen Unbekanntes), dann super (XSD + Modul), dann Gitlink-Bump.** So ist kein Zwischenzustand kaputt. Das ist in S3–S6 eingebaut, nicht nachtraeglich.

**E10 — Das PDF-Gate baut nur EINE Sprache.** `.gitlab-ci.yml:612 thesis:pdf` waehlt `grep -lE "\\documentclass" *.tex | head -1`, Default `\thesislang`=`en` (`diplomarbeit.tex:18`). Die zweisprachige Anlage wird also nur zur Haelfte gegen einen echten Bau gehalten. `report:pdf-gate` (S15) muss **beide** Sprachen bauen. *Unsicher: ich habe nicht geprueft, ob Makefile/build.ps1 der Thesis je beide Sprachen bauen koennen.*

---

## 7. WAS DER OWNER ENTSCHEIDEN MUSS

**O-1 — Welches Profil traegt den `<report>`-Block?**
*Empfehlung:* **Nur `m3_golden_coverage`**, und der Vorwaertskanal akzeptiert Smoke-Artefakte nur, wenn kein golden-Artefakt existiert **und** meldet das dann laut im Commit-Text („Quelle: SMOKE").
*Begruendung:* Ein in 11 Profilen gepflegter Block ist genau die handgepflegte Zweitliste, die wir abschaffen wollen. Ein Smoke-Anhang, der still als golden-Anhang in der Abgabe landet, ist ein Abgabe-Risiko.

**O-2 — Duerfen Bild- und Tabellenunterschriften in der Profil-XML stehen (ce-Repo)?**
*Empfehlung:* **Ja, Unterschriften ja — Fliesstext nein.**
*Begruendung:* Diese Texte stehen heute schon als C++-String-Literale in super, sind also bereits unlinted; die XML macht sie sichtbarer und die `--check-lang-parity`-Wache ist strenger als die vorhandene DE/EN-Drift-Wache. Fliesstext dagegen gehoert zwingend in `kapitel/<lang>/`, sonst gibt es einen dritten Prosa-Ort ohne chktex und ohne Drift-Wache. *Gegenargument, das der Owner kennen muss: die XML liegt im ce-Repo (BEP Venture UG); Thesis-Prosa dort ist eine Vermischung der Rechtstraeger — auch bei Bildunterschriften. Alternative waere ein Untertitel-Katalog im Thesis-Repo, den der Composer liest; das kostet einen Schritt mehr und macht die XML unvollstaendig lesbar.*

**O-3 — Wird die Metrik-Decke jetzt geoeffnet?**
*Empfehlung:* **Ja, aber als eigenes, nachgelagertes Paket.** Zunaechst nur die sechs vorhandenen Felder freigeben; die Oeffnung (Metrik-Liste aus der WIDE-Spalten-Registry statt hartkodiert) danach.
*Begruendung:* Ohne Oeffnung sind PMC-Zaehler und `branch_misses` nicht anforderbar, und der Auftrag sagt „alle Messwerte … die gewuenscht sind". Aber die Oeffnung beruehrt `diagram_generator` und damit alle bestehenden Anhang-Fragmente — das gehoert nicht in dasselbe Paket wie die Anlagen-Mechanik.

**O-4 — Duerfen schaltende Textbausteine in Auswertung/Evaluation stehen, entgegen H3?**
*Empfehlung:* **Ja — aber Betreuer vorher informieren**, mit dem Argument, dass die Werte VOR der Kompilation berechnet werden und im Anhang vollstaendig nachvollziehbar belegt sind (kein `--shell-escape`, kein Compile-Zeit-Dump-Lesen).
*Begruendung:* Habich, 08.05.: „NUR im Appendix-Bereich". Der Owner-Auftrag vom 08.08. verlangt ausdruecklich „in der Auswertung und Evaluation". Das ist ein echter Konflikt zwischen Betreuer-Auflage und Owner-Auftrag, den ich nicht entscheiden kann. **S11 ist bis dahin blockiert; S1–S10 und S12–S18 nicht.**

**O-5 — Gilt H3 mit diesem Entwurf als erfuellt?**
*Empfehlung:* **Als erfuellt melden, aber die Abweichung nennen.** H3 skizziert `\PRTARTPlot{…}`, also ein LaTeX-Makro, das zur Compile-Zeit Binary-Dumps liest. Dieser Entwurf loest dieselbe Aufgabe umgekehrt herum.
*Begruendung:* Der Weg ueber Compile-Zeit-Dump-Lesen braucht `--shell-escape` und macht den Thesis-Bau vom Vorhandensein der Binaries abhaengig — fuer eine Abgabe schlechter. Ob die Auflage damit erfuellt ist, entscheidet der Betreuer, nicht wir.

**O-6 — R2 bleibt offen: Ziel-Branch `development` vs. `main`/Overleaf.**
*Keine Empfehlung ohne O-4.* Bis dahin existiert die Anlage nur als Pipeline-Artefakt; `anhang:forward` bleibt INERT. Das ist kein Mangel dieses Entwurfs, sondern eine Vorbedingung, die er nicht selbst aufloesen darf.

---

## 8. WAS AM BESTAND BRICHT — UND WIE ES SICH MELDET

| Was | Wie es bricht | Wie der Bruch sich meldet |
|---|---|---|
| **F10 (16.07., `LEDGER:533`)** — „aus einem **FEST VERDRAHTETEN** Output des Messsystems" | Genau diese Verdrahtung wird aufgehoben. Der Auftrag vom 08.08. widerspricht F10 ausdruecklich | S18 markiert F10 im Ledger als abgeloest, mit Datum und Ersatz. Technisch: **kein** Bruch — fehlt `<report>`, ist alles byte-identisch |
| **E-18-Negativzusage** (`20260805-PLAN-b1-e18-vorwaerts-kanal.md`) — „0 Dateien ausserhalb `anhang/<lang>/tabellen/*.tex`" | Der Composer schreibt nach `anhang/<lang>/generated/`. Die Zusage ist danach falsch | Die Ziel-Wache in S14 laesst genau zwei Praefixe zu und **bricht mit exit 1** bei allem anderen. Der Plan wird deprecatet (S18), nicht geloescht. Die zweite Haelfte der Zusage — „`kapitel/` unberuehrt" — **haelt weiter**: die Fliesstext-Zeilen werden von Hand committet, nie von der CI |
| **§16.1-C2** — „NUR EINEN Pfad" | `<report dir>` ist ein vierter Pfad neben `binary_path`/`csv_path`/`latex_path` | Bewusste Abweichung, gehoert vor den Owner (nicht in eine Fussnote). Die Regel „erst Build-Pfad, dann kopieren" wird eingehalten |
| **`ci/anhang_forward_core.sh`** — das hartkodierte `anhang/$lang/tabellen` an drei Stellen (`:220`, `:235`, Byte-Delta) | Wird durch manifest-getriebene Listen ersetzt | Ohne `report_manifest.txt` faellt der Kern auf das heutige Verhalten zurueck (dokumentiert, kein stiller Pfad). Ein Manifest mit unerlaubtem Praefix bricht laut ab |
| **`.gitlab-ci.yml:765,775,857,867`** — die vier `\|\| echo "… kein Fehler"` | Werden durch `case`-Verzweigung ersetzt. Ab dann sind nur Exit 0 und 12 gruen | **Das ist der Bruch, der am ehesten weh tut:** Fehler, die heute stumm durchlaufen, machen ab S16 Jobs rot. Genau so ist es gewollt. S16 zeigt beide Faelle im Log |
| **`measure:golden-320`** | Bekommt `COMDARE_THESIS_PROFILE` in seinen `variables:`-Block (hat es heute nicht — verifiziert, `.gitlab-ci.yml:723` gilt nur fuer smoke) | Ohne diesen Schritt bricht der Job nach bis zu 10 Tagen Messlauf mit „unbound variable" ab. **Deshalb steht er in S15 und nicht spaeter** |
| **`anhang/<lang>/A_measurements.tex`** | Bekommt eine `\InputIfFileExists`-Zeile am Ende. Der handgeschriebene Teil bleibt vollstaendig | Keine Verdopplung, weil M10 einen eigenen Namensraum hat und M08 unveraendert weiterschreibt. **Das Ausduennen des handgeschriebenen Teils ist ein eigenes Migrations-Paket**, kein Teil dieses |
| **PowerShell-Altweg** (`generate_wide_appendix.ps1`, `generate_measurement_appendix.ps1` im Thesis-Baum) | Erzeugt nach diesem Paket einen Anhang **ohne** Anlage und **ohne** Variablen. Die Thesis kompiliert dank `\InputIfFileExists` stumm mit altem Stand weiter | **Bleibt stehen — Rest-Einwand.** Kein Schritt dieses Pakets beruehrt sie. Sie gehoeren in dasselbe Aufraeum-Paket wie die `--bias-caption-*`-Argumente (E4) |
| **Golden-Katalog / `binary_id`** | Ich **behaupte**, `<report>` ist neutral | S17 ist genau deshalb ein eigener Schritt mit literalem Vorher/Nachher. Bis der Beleg da ist, gilt es als unbelegt |

---

### Restliche Unsicherheiten, ungeschminkt

- Ich habe den dritten Entwurf nie gesehen und das `ct-rein`-Urteil nie erhalten. Es kann darin ein Argument geben, das meine Empfehlung kippt.
- Ob `04_csv_to_latex` / `05_diagram_generator` einen gemeinsamen Zahlenformat-Helfer haben, weiss ich nicht. Falls nein, ist das der erste Befund von S7.
- Wo die XSD ueberhaupt **scharf** validiert wird, konnte ich nicht klaeren — ich habe die drei `.cmake`-Konsumenten nur als Treffer gesehen, nicht gelesen. S3 prueft das, bevor gebaut wird.
- Ob `xml_reader.hpp` CDATA kennt, habe ich nicht verifiziert. Fuer Unterschriften mit `&` oder `<` ist das relevant.
