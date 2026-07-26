# SESSION 26.07.2026 — Achsen-Neuordnung, Lager-Baeume, xlsx-Doktrin, Regressions-Register

> Owner-KERN-Beschreibungen aus der Scrub-Fenster-Phase (Kontext-Planung ohne Schreiben),
> hier erstmals persistiert. ALLES in diesem Dokument ist KERN=Gesetz (User-Beschreibung
> schlaegt Plan/Doku; Abweichung = Regression). Volles GO des Owners liegt vor, inkl.
> persistence_target. Einbau: VOR Voll-Bau-4 ("Wir schaffen es und wenn nicht ist auch
> nicht schlimm, hauptsache so ordentlich wie moeglich"). ASCII bis auf §.

## 1. BINDENDE ACHSEN-SORTIERUNG (alle Achsen-Typen; Doku-Verstoesse = Regressionen)

Verzeichnisbaum-/Ordnungs-Kette: (1) MESS-TOOLING (Mess-Haupt-Achse; measurement_category
= ihre Unter-Achsen) -> (2) target_isa -> (3) operating_system (NEU) -> (4)
extension_hardware -> (5) ORGAN-Achsen (T00-T16, unveraendert) -> letztes Haupt-Blatt ->
3 Unter-Ebenen: Mess-Unter -> System-Unter -> Organ-Unter.

## 2. REGRESSIONS-REGISTER (vor Voll-Bau-4 zu beheben)

- **R-A operating_system fehlt** als System-Haupt-Achse. NEU bauen; Unter-Achsen:
  os_version, kernel, build, update_zustand.
- **R-B scheduling ist faelschlich Haupt-Achse** — real UNTER-Achse von target_isa
  (die CPU managed/verschiebt alle Daten einer Maschine).
- **R-C load_framework ist faelschlich System-Haupt-Achse** — technisch META-META-Achse:
  Messung KANN erfolgen, muss aber nicht — der FUENFTE Modus **CUSTOM_COMPILE**
  (Planer-CLI, custom Kompilation) umgeht Debug/Messung/Release/COMPARE. Verortung:
  in der CEB korrekt am ENDE, aber stets die ERSTE Meta-Meta-Achse; dahinter folgt das
  variadische Array der Hardware-Meta-Metas.
- **R-D compiler ist faelschlich Haupt-Achse** — real separate UNTER-Achse, welche die
  fixe Permutations-Rekombination target_isa x extension_hardware x Meta-Meta-Achsen
  (ohne load_framework) als **KOMPLEX-HAUPT-ACHSE nach dem Command-Pattern** annimmt
  (ein Compiler ist fuer diese Rekombination immer passend ausgelegt/verfuegbar; alle 3
  sind Haupt-Achsen, verhalten sich aber wie EINE — Haupt-Achsen bekommen Schichtungen
  in derselben Kategorie). compiler + opt_level + atomic128 = **UNTER-ACHSEN-GRUPPE**
  (untrennbar: nur bestimmte Compiler bieten bestimmte Handles; der Compiler ist aus
  CEB-Sicht ein zur Laufzeit austauschbares Programm).
- **R-E Meta-Meta-Identitaet war falsch dargestellt**: Die Meta-Meta-Haupt-Achsen auf dem
  variadischen Array hinter load_framework (Metaprogrammierung OHNE std::variant) sind
  FESTE Bestandteile der Maschinen-Identitaet. Identitaet ist NUR AUFWAERTS kompatibel:
  GPU einbauen -> CPU-only-Programme laufen weiter + GPU-CPU zusaetzlich; GPU ausbauen ->
  GPU-CPU-Programme gehen nicht mehr. Identitaet = valide unter der Basis-Identitaet in
  Permutation zu allen Hardware-spezifischen Meta-Meta-Achsen (ausser load_framework);
  ALLE Teil-Identitaeten mit kleinerer Hardware-Verwendung sind gueltig. Basis = CPU-only
  (baut/fuehrt langsame Programme aus). ALLE Hardware-Erweiterungen (auf der CPU wie
  extern: SIMD, GPU, FPGA, NPU, ...) werden strategisch in DERSELBEN Haupt-Achse
  modelliert: es gibt Basis-Code und Geraete, die ihn beschleunigen — mehr tut eine
  Hardware-Erweiterung nicht. **extension_hardware = offizieller Command-Pattern-HUB**
  der Hardware-Meta-Meta-Haupt-Achsen; seine Identitaet IST exakt deren Konfiguration.

## 3. DUAL-NATUR (Haupt/Unter ist stufen-relativ)

load_framework und Mess-Tooling sind LAUFZEIT-Unterachsen auf dem PLANER und
COMPILE-TIME-Haupt-Achsen auf der CEB (bestaetigt die §24-Regel: dynamische Einstellungen
der Vorstufe = CT-Draehte der naechsten Stufe).

## 4. ZWEI LAGER-BAEUME (je Realm eigene Wurzel)

- **Messdaten-Baum (csv/xlsx):** Wurzel = Mess-Achsen-Benennungs-Kombinatorik aus den
  BEIDEN verfuegbaren Haupt-Achsen (Mess-Tooling x load_framework) -> darunter EIN
  Ordner-Level mit der GESAMTEN System-Haupt-Achsen-Rekombination als Name (wird laenger;
  Meta-Metas hinten angehaengt, hinter load_framework on/off wenn vorhanden) -> darunter
  die Organ-Gruppen-Ordner (§5) -> Haupt-Blatt -> Mess-Unter -> System-Unter ->
  Organ-Unter -> xlsx.
- **Binaries-Lager:** Wurzel = SYSTEM-Achse direkt; Mess-Achsen-Typ folgt (nicht ganz
  intuitiv) HINTER System- und Organ-Achse als LETZTER/tiefster Haupt-Achsen-Typ.

## 5. ORGAN-GRUPPEN (final, englische Ordnernamen; je Gruppe EIN Ordner, dessen Name die
Werte-Rekombination der Gruppen-Achsen traegt — Tiefe sparen)

| Ordner | Achsen |
|---|---|
| 01_read_path | search_algo, cache_traversal |
| 02_layout | node_type, memory_layout, path_compression, filter, serialization |
| 03_placement | mapping, allocator, value_handle, index_organization, migration_policy |
| 04_execution | concurrency, prefetch |
| 05_write_path_io | queuing_q1, queuing_q2, io_dispatch, **persistence_target (NEU)** |

Fachliche Basis (Owner-beauftragte Recherche): Idreos Periodic Table / Data Calculator
(Layout ⊥ Algorithmen), RUM-Conjecture (Read/Update/Memory), External-Memory-/
ideal-cache-Modell (Wirkungsfeld je Hierarchie-Ebene). Reihenfolge 01->05 =
Speicherhierarchie absteigend (Rechenwerk -> Cache-Line -> RAM -> Storage).

**NEUE 18. ORGAN-HAUPT-ACHSE `persistence_target`** (Owner-GO): unterscheidet, ob ein
Algorithmus nur in Memory arbeitet oder auf Platte zurueckschreiben muss. Bausteine:
`memory_only` (Default, golden_wired, Durchreich-Semantik) + `disk_writeback`; spaeter
erweiterbar. KONSEQUENZ: binary_id 17->18 (kCompositionAxisNames, AdHocComposition-
static_assert, Observer-POD axis_stats[17], golden-CRC) = bewusster golden-/ABI-Bruch im
OFFENEN §66-G2-Bruch-Fenster — Einbau VOR Voll-Bau-4, damit der neue golden die 18.
Achse von Geburt an traegt.

## 6. MESS-ERGEBNIS-CODIERUNG (xlsx-Doktrin)

- CSV-Doktrin (Vorstufe): dynamische Unter-Achsen-Variablen IMMER direkt im Dateinamen;
  Name = NUR Datum + Uhrzeit + Unter-Achsen-Variablen; Lage = Haupt-Achsen-Ordner;
  Haupt-Achsen-Einstellungen als Metadaten IN der Datei (vollstaendig identifizierbar).
- **xlsx = kuenftig DEFAULT**, CSV einstellbar + Fallback. CSVs werden im FACTORY PATTERN
  je Sheet einzeln gebaut; xlsx = EINE Datei mit EINEM Sheet je gewaehlter
  Unter-Achsen-Permutation + zusaetzlichem INFO-Sheet (Sysinfo der testenden Maschine +
  verwendete Haupt-Achsen). Gegen Sheet-Explosion wirken die 3 Unter-Ebenen unter dem
  Haupt-Blatt (Mess-Unter -> System-Unter -> Organ-Unter).

## 7. EINSCHUB VOR VOLL-BAU-4 (Plan-Aenderung)

Neues Pflicht-Paket **STRUKT-R** (Regressions-Behebung R-A..R-E + persistence_target +
Registry-/Generator-Umbau + §61-Modus-Registry um CUSTOM_COMPILE + Identitaets-
Halbordnung) VOR dem Trigger, im selben Bruch-Fenster wie W-13 (dessen Suffix-Ordnung
der neuen bindenden Sortierung folgt). Lager-Baum-Materialisierung (Ordner-Kaskaden,
xlsx-Writer) = Design jetzt fix, Vollausbau im #46b-/vor-01.08.-Paket.

## 8. IDENTITAETS-DOKTRIN + FINALE LINIE (Infra-Handover 26.07.)

Diplom-Repos = einheitlich `Benjamin-Elias Probst <benjamineliasprobst@gmail.com>`
(Studenten-Autorschaft, pruefungsrechtlich; lokale git-config in allen 5 Repos gesetzt).
Finale HEADs nach Scrub+Blob-Purge+Identity-Normalisierung: super e542effb, ce ce81ec62,
prt-art 32e8ffa8 (dev=main, Laptop=node7=gitlab=github). prod1-Adoption vollzogen
(backup-Ref pre-identity-adopt-2026-07-26). OFFEN bei mir: overleaf-Content-Gabelung
(github-main c2d3c51e 18 Commits Habich-Runde-2 vs gitlab-dev ef448e4b 9 Commits
Konsolidierung) MERGEN (nie rebase, Superset, Konflikte kapitelweise) -> DANACH overleaf
identity-normalisieren -> super-Gitlink nachziehen. gitlab-Visibility aktuell private;
public via dedizierter Gruppe = separater Infra-Schritt (URL-Wechsel wird angekuendigt).
