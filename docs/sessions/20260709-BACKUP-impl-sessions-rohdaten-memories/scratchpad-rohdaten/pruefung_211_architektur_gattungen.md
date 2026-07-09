# ARCHITEKTUR-VERIFIKATION (READ-ONLY) vor #211: container_-Spiegel vs. Gattungs-/Achsen-Modell — User-Hypothesen gegen Code + Architektur-Docs + DIPLOMARBEIT prüfen

Repos: `C:\Users\benja\OneDrive\Desktop\Diplomarbeit - Datenbanken\Code\external\comdare-cache-engine` (HEAD a1f6024),
Architektur-Docs `C:\Users\benja\OneDrive\Desktop\Diplomarbeit - Datenbanken\docs\architektur\` (nummerierte Docs,
insb. das konsolidierte Master-Architektur-Dokument/Single-Source-of-Truth + Doc 27/28/29 + 10_schichten_modell_M.md),
THESIS-Kapitel `C:\Users\benja\OneDrive\Desktop\Diplomarbeit - Datenbanken\thesis\` (LaTeX, de führt; ch4/Anhang F
sind die Architektur-Kapitel). Alle Aussagen mit file:line bzw. Doc-§. KEINE Edits. Deutsch.

## Anlass
Vor Task #211 (geplanter Fix: eigenes LinearMirrorTraversal für den nicht-authoritativen container_-Spiegel im
SearchAlgorithm-abi_adapter) hat der USER einen Architektur-Defekt-Verdacht geäußert. Der geplante Fix ist auf
HOLD. Prüfe seine Aussagen als HYPOTHESEN H1-H6 — je Hypothese: (i) was sagt der CODE, (ii) was sagen die
Architektur-Docs, (iii) was sagt die THESIS, (iv) Verdikt: bestätigt / teilweise / widerlegt, mit Belegen.

## Die Hypothesen (User-Aussagen 2026-07-02, sinngemäß wörtlich)
- **H1:** „Jedes Container-Tier-Binary ist — wie die Suchalgorithmen — eine ECHTE Implementierung OHNE Spiegel,
  die nach dem exakt gleichen Schema wie die Suchalgorithmen vermessen wird. Die Daten werden direkt und exakt
  in die Container-Tiere gelegt; zusätzliche Interfaces geben dem Anwender Informationen über deren
  Limitationen, sofern vorhanden." → Prüfe: Wie ist die Container-GATTUNG implementiert (GenusBindingTraits,
  per-Gattung Docks/PermutationEngines, Container-Konfiguratoren, q1/q2-Slots)? Hat die Container-Gattung
  einen eigenen Adapter/Mess-Pfad OHNE Zweitstruktur? Gibt es Limitations-Interfaces (oder fehlen sie)?
- **H2:** „Die Messachsen sind immer vollständig fester Bestandteil einer jeden Gattung, sofern die
  compile-Eigenschaft eines Experiments gewählt wurde — für Suchalgorithmen und Container jeweils separat."
  → Prüfe: Sind die 19/26 Achsen je Gattung fest eingebaut (COMDARE_MEASUREMENT_ON/compile-gated)? Separat
  je Gattung oder geteilt?
- **H3:** „Beide Gattungen verwenden vom Code her DIESELBE BASIS der Messachsen, mit Implementierungen der
  jeweils speziellen Achse, deren Eigenschaft gemessen werden soll." → Prüfe: Gibt es die gemeinsame
  Achsen-Basis (axis_base/AxisBase o.ä.) die beide Gattungen konsumieren? Wo sind gattungsspezifische
  Achsen-Implementierungen?
- **H4:** „Zuletzt wurde die Abstraktion der EBENEN definiert — finde diese." → Lokalisiere die aktuelle
  Ebenen-Abstraktion (Task #90: Terminologie-Migration AnatomyGenus → 3 Ebenen Interface/Tier-Unterklasse;
  Master-Architektur-Doc aus MP-B; Doc 27/28/29 §8.1 Adapter-Modell; Thesis-ch4 „EINE Architektur",
  3 Gattungen + 5 Tier-Unterklassen). ZITIERE die kanonische Definition (Doc + Thesis).
- **H5:** „Alle Achsen sind von der Abstraktion her uniform und erweitern ein Basis-Achsen-Interface mit
  gemeinsamer Abstract Factory, Observer und Mess-Verwaltungsfunktion — was aber nur für Achsen gilt, die
  NICHT messen. Unter der abstrakten Achsen-Klasse gibt es OBJEKT-Achsen und MESS-Achsen. Die Mess-Achsen
  sind auf der Systemseite der cache-engine und werden beim Experiment aktiv in die Objekt-Achsen der
  Gattungen eingebaut." → Prüfe gegen: AxisBase/axis_base-Pattern, ObservableAxis, Observable*-Hüllen,
  observer_classification (SearchAlgorithmObserver/DefinitionOnly/ContainerObserver!), AbstractFactory-Slots,
  Mess-Verwaltung (measurement/-Subsystem). Deckt sich die Code-Realität mit dieser Objekt-/Mess-Achsen-
  Zweiteilung? Wo genau weicht sie ab?
- **H6:** „Ein linear-scan-Traversal ist nur ein weiteres XML-Profil für eine Workload und ein Testverfahren
  — das wird NIE fest eingebaut, sofern Last-Generatoren diese Arbeit übernehmen." → Prüfe die Begriffs-Ebenen
  gegen die Thesis: (a) linear_scan als T0-search_algo-ACHSENWERT (Struktur-Baustein, XML-selektiert,
  compile-time — Thesis-Definition?), (b) Scan als WORKLOAD-Zugriffsmuster (YCSB-E/Lastprofil-XML,
  Last-Generator), (c) LinearScanTraversal/SortedBinaryTraversal als ORGAN-Bausteine der composable-Schicht,
  (d) der SPIEGEL-Gebrauch von SortedBinaryTraversal als fest verdrahteter Mess-APPARAT im abi_adapter
  (container_traversal_t-Fallback). Welche dieser 4 Ebenen sind thesis-gedeckt fest, welche gehören in
  XML/Workload, und ist der Apparat-Gebrauch (d) doku-/thesis-konform oder der gerochene Defekt?

## KERNFRAGE (aus H1-H6 abgeleitet)
Der `container_`-Member im SearchAlgorithm-abi_adapter (heute: authoritatives Organ für organ-backed/
store-traversierbare, SortedBinary-SPIEGEL für die Rest-Menge) — ist er:
(i) die legitime Storage-Organ-Komposition der SA-Gattung (nur irreführend „container_" benannt →
    Namens-Kollision mit der Container-GATTUNG, Etiketten-Problem = #224-Terrain),
(ii) ein Architektur-Defekt (Zweitstruktur/Spiegel, den es laut Gattungs-Modell + Thesis gar nicht geben
    dürfte — SA-Tiere sollen wie Container-Tiere DIREKT vermessen werden),
(iii) oder beides vermischt (authoritativer Teil legitim, Spiegel-Teil Defekt)?
Und: Welche der Rest-Zahler (11 Reference-Compositions + markerlose Flach-Wrapper) BRAUCHEN den Spiegel
wirklich noch (Storage-Achsen-Observer/tier_scan/prefetch-descent) — oder können diese Konsumenten aus den
ECHTEN Strukturen bedient werden (for_each_record, eigene Organe), sodass der Spiegel STERBEN kann
(Eliminierung statt Optimierung)? Was wäre der thesis-konforme #211-Zielzustand?

## Output
Je Hypothese H1-H6: Belege (i)-(iii) + Verdikt. Dann KERNFRAGE-Antwort mit konkretem, thesis-konformem
#211-Zielbild (Eliminieren vs. Kapseln vs. Umbenennen + was mit den Konsumenten passiert). Am Ende
„OFFENE FRAGEN". KEINE Implementierung.
