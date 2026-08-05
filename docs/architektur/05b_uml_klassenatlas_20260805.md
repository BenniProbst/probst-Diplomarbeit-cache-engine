# UML-Klassenatlas cache-engine — IST-Stand 2026-08-05 (Nachfolger von 05_uml_klassen.md)

**Stand:** ce `98eea2e7` (Gate 400; unmittelbar vor der S5-05q-Landung `b09ebb8a`/Gate 402 erhoben — die Q1/Q2-Organe sind im Atlas im Vor-Scrub-Stand abgebildet, die Struktur ist identisch)
**Seite:** [`05b_uml_klassenatlas_20260805.html`](05b_uml_klassenatlas_20260805.html) (self-contained, 1,5 MB)
**Gerenderte Fassung** (Mermaid-Diagramme live, Filter, Themes): https://claude.ai/code/artifact/61235adf-e3f9-4000-9e55-4bf4d85ee630 (privates Claude-Artefakt des Owners; Repo-HTML ist die kanonische Kopie)

---

## Umfang

- **1918 Typ-Definitionen** (class/struct/enum/concept, inkl. nested Typen und Template-Spezialisierungen) aus **1211 Headern** unter `libs/cache_engine` — Tests ausgenommen.
- Je Definition: vollstaendiger `template<>`-Kopf inkl. requires, Basen mit CRTP-Kennung, Typaliase, **alle Methodensignaturen vollstaendig** (Sichtbarkeit +/-/#, static/constexpr/virtual, Rueckgabetyp, Parameter mit Typen und Namen, const/noexcept/override/final), Fundstelle `datei:zeile`, Zweck-Satz.
- **92 Mermaid-Beziehungsdiagramme** (Vererbung `<|--`, CRTP `<|..`) ueber **34 Subsystem-Sektionen**: Achsen (axes/), Topics-Doppelwurzel, include/-API, Builder/Experiment-Tree, Anatomy/ABI-Flaeche, Fassaden/Kern.
- Kopf-Sektion: A1–A3-Anatomie-Kern (AdHocComposition → SearchAlgorithmAnatomy → SearchAlgorithmAbiAdapter mit IAnatomyBase/IMeasurableWorkload/IObservableTier; GenusBindingTraits → PermutationEngine; AllocatorStrategyBase-CRTP-Kette), E4→E1-Maschinerie-Fluss, Stereotypen-Legende («CRTP», «template», «concept», «facade», «adapter», «POD»).

## Erhebungsmethode (Nachvollziehbarkeit)

1. 34 parallele Extraktions-Shards (Workflow, read-only am Stand `98eea2e7`), je Shard JSON-Inventar + HTML-Fragment.
2. Unabhaengiger grep-Census je Shard; Befunde: Shard „lookup Teil 1" per Regex-Abkuerzung unvollstaendig (58/114) → Volllektuere-Reparatur mit exakt aufgehendem Census (81+33; nested Node/Slot-Typen; CRTP-Kette `*SearchAlgoCore<Alloc,Self>` → `SearchAlgoBase<Self>` → `OrganAxis<Self>` am Text verifiziert); 19 verdichtete Methodenlisten („+N weitere") auf volle Signaturen expandiert; 6 vergessene Result-structs (Sektion bestandslog/pruef_dock) nachgezogen; Karten-Neubau deterministisch per jq aus dem JSON.
3. Struktur-Sanity: 1918 Karten == JSON-Inventar (abzueglich dokumentierter Pseudo-Eintraege), `<article>`-Balance 0, alle 92 Mermaid-Bloecke mit gueltigem Kopf.

## Bewusste Grenzen

- Funktionslokale `struct`-Definitionen (in Methodenkoerpern) und freie Funktionen sind keine Karten (im jeweiligen Klassen-Zweck vermerkt).
- `topics/traversal` Teil 1 besteht real nur aus Weiterleitungs-Headern (0 Typ-Definitionen — Census-bestaetigt, kein Extraktionsfehler).
- Mermaid-Diagramme zeigen Beziehungen (Vererbung/CRTP), keine Methoden — die vollstaendigen Methoden stehen in den Klassenkarten darunter.
- Im Repo-HTML werden die Mermaid-Bloecke als lesbarer `classDiagram`-Quelltext angezeigt (kein eingebettetes JS); die gerenderte Fassung liegt im o.g. Artefakt.

## Aktualisierung

Neuerhebung nach groesseren Struktur-Wellen: Extraktions-Workflow erneut ueber `libs/cache_engine` fahren (Shard-Plan und Karten-jq siehe Session 05.08.2026, Ledger-Nachtrag vormittag-2), neue HTML als `05c_…<datum>.html` daneben ablegen — dieses Dokument nie loeschen, nur Banner (Doku-Doktrin).
