# A9 DESIGN-DOSSIER — xlsx-Writer (F3): Vendoring, API, Dateinamen, Lager-Ablage, Scheiben-Plan

Datum: 02.08.2026 (abends) · Design-Agent Fable 5 xhigh · Status: DESIGN (read-only, kein Commit)
Paket: Katalog A9 (`docs/sessions/20260802-KATALOG-offene-strecke-gesamtplan.md:25`), eingeplant GATE 9
(`docs/sessions/backups/20260802-kontext-neugruendung-abend-workflows/00-SYNTHESE-lage-dossier.md:236`).
Owner-Spezifikation F3 (01.08.): "eigener Writer, Fork/Orientierung libxlsxwriter zulaessig; xlsx = Default-Auswerteformat, Unter-Achsen im Dateinamen."

## Quellen (gelesen 02.08.2026)

1. `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (V7.2-Kopf LED:82 verweist auf die Session-Docs 26.07.; keine eigene xlsx-Detailzeile — Doktrin lebt in 2.)
2. `docs/sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md` — KERN=Gesetz: §4 Zwei Lager-Baeume (:54-63), §5 Organ-Gruppen 01..05 (:65-87), §6 xlsx-Doktrin (:89-98), §7 Vollausbau-Einordnung (:100-106)
3. `docs/sessions/20260802-KATALOG-offene-strecke-gesamtplan.md` — A9 (:25), GATE-Einordnung (E.4 Auswertung :68, G-Befund "xlsx nirgends im Code" :236 via Synthese)
4. `docs/sessions/backups/20260802-kontext-neugruendung-abend-workflows/00-SYNTHESE-lage-dossier.md` — Direktive 25 Lager-Baeume/xlsx (:55), Storage-Doktrin (:56), Widerspruch 10 "A9 = Pflicht-Paket, in keiner Welle" (:259)
5. Memory `project_lager_baeume_xlsx_doktrin.md`, `feedback_vendoring_doctrine_ordered_vendor_faithful_selfcontained.md`
6. ce-Ist (live kartiert, Abschnitt 1): `libs/cache_engine/builder/experiment_tree/*`, `profile_facade/*`, `heuristik/*`, `ext/io/liburing/*`, `LICENSE_AUDIT_EXT.md`, `tools/`
7. Online-Verifikation 02.08.: github.com/jmcnamara/libxlsxwriter (Releases) + libxlsxwriter.github.io/license.html

Pfad-Konvention: ce = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine`; super = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`. Anker unten ce-relativ.

---

## 0. Befund-Bestaetigung: xlsx existiert im Code NIRGENDS

Voll-grep ueber `libs/`, `tools/`, `apps/`, `ext/`: genau EIN Treffer, ein Kommentar-Vorgriff in
`libs/cache_engine/include/cache_engine/measurement/axis_error.hpp:420` ("... die xlsx-/Lager-Strecke uebernimmt es ueber dieselbe Vokabel").
Kein Writer, kein Vendor, kein CMake-Ziel. A9 ist ein Vollbau-Paket ab Null — der Katalog-Befund (Synthese :259) ist IST-bestaetigt.

## 1. Ist-Kartierung: CSV-Writer- und measurement-Ausgabe-Pfade (Andock-Naehte)

| Naht | Ort | Rolle fuer A9 |
|---|---|---|
| WIDE-CSV-Schema (Single-Source, 173 Spalten, Semikolon) | `libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:351` (`lazy_csv_header()`), `:452` (`format_csv_row`) | EINZIGE Datenquelle des xlsx-Writers; wird NICHT angefasst (Resume-/Header-Vergleich `:846` haengt daran) |
| Per-Binary `result.csv` + `.stamp` | `cache_engine_builder_iterator.hpp:825-826` (Resume-Pruefung), `:1553-1561` (Schreiben), `:1412-1422` (failed-Marker) | bleibt CSV (Maschinen-/Resume-Format); A9 liest nie stamps |
| Offizielle Gesamt-CSV `e4_xml/measurements.csv` | `profile_facade/profile_run_entry.hpp:449` + `:853`, `experiment_run_entry.hpp:230` + `:406`; Alt-Treiber `builder/experiment_driver/experiment_driver.cpp:515` | Haupt-Input des A9-CLI |
| Mess-Sink-Naht (Storage #51, No-Op-Default) | `MeasurementSinkFn` via `builder/artifact_transport/artifact_cache.hpp` (Alias `cache_engine_builder_iterator.hpp:76-78`), Feuerpunkte `:1594-1598` und `profile_run_entry.hpp:853` | Vorbild fuer die A9-Ablage-Naht: additiv, leer = No-Op = golden/CI byte-identisch |
| Auswerte-Leser (CSV-konsumierend) | `heuristik/measurement_curve_loader.hpp:3`, `builder/best_binary_selector/best_binary_selector_main.cpp:22` (header-getrieben), `builder/experiment_tree/result_ingest.hpp:33` | bleiben CSV-Leser; A9 ergaenzt die menschliche Auswerte-Ausgabe |
| Legacy-Zweitkopf (RFC-4180, Komma) | `builder/commands/result_aggregator.hpp:92` (`result_csv_header()`) | NICHT Andock-Punkt; als Alt-Format kennzeichnen (LED-75-Kandidaten-Pruefung, nicht Teil von A9) |
| Werkzeug-Praezedenz CSV->Bericht | `tools/latex_anhang/` (CSV -> LaTeX-booktabs; `PROJECT_LAYER_MAP.md` L1) | Layer-Beleg: Bericht-WRITER = ce-Mechanik ("WIE"), Auswerte-INHALT = super |
| Vendoring-Praezedenz | `ext/io/liburing/COMDARE-VENDOR-PROVENANCE.md` (Stufe-1-Snapshot, kein Submodule, Prune-Protokoll, Consumer-only-Target) | Blaupause fuer A9-S1 |
| Archiv-Erstbeleg fuer S5 | super `measurement/20260726-164259-d03-strukt-r-erstbeleg/` (`measurements.csv` + `per_binary/`) | read-only Test-Input (Alt-Mess-CSV = Archiv) |

Kern-Konsequenz: Die CSV-Strecke ist die VORSTUFE (Session-Doc 26.07. §6 :91 nennt die CSV-Doktrin woertlich "Vorstufe") und bleibt byte-unberuehrt. A9 ist eine rein ADDITIVE Ablage-/Auswerte-Stufe dahinter: dieselben Zeilen, gerendert als xlsx in den Messdaten-Lager-Baum; CSV = Fallback derselben Factory (F3).

## 2. Vendoring-Entscheid libxlsxwriter

### 2.1 Lizenz-Check (online verifiziert 02.08.)

- **libxlsxwriter**: "FreeBSD license" = **BSD-2-Clause**, Copyright John McNamara 2014-2026. Neuestes Release **1.2.4 (06.01.2026)**. Einzige externe Abhaengigkeit: **zlib**.
- Gebuendelte third_party (libxlsxwriter.github.io/license.html): queue.h/tree.h (BSD), **minizip** (zlib-Lizenz), **tmpfileplus** (**MPL-2.0** — vermeidbar, s.u.), **dtoa Milo Yip** (MIT, optional `USE_DTOA_LIBRARY`), **Openwall MD5** (Public Domain, abschaltbar).
- Vertraeglichkeit: BSD-2/zlib/MIT/PD sind mit der ce-Dual-Lizenz problemlos; Doktrin-Deckung explizit: "vendored ext/ behaelt eigene Lizenzen" (Synthese :72, Lizenz-Endstand 02.08.). MPL-2.0 (tmpfileplus) waere file-level-Copyleft — wir kompilieren es NICHT (`USE_STANDARD_TMPFILE`, POSIX `tmpfile()` reicht auf der Linux-Zielplattform) und prunen die Datei im Snapshot.

### 2.2 Entscheid (Empfehlung, F3-gedeckt)

**Stufe-1-Vendor** nach Doktrin vendor->faithful->selfcontained (Memory `feedback_vendoring_doctrine...`): echten Upstream-Code vendoren, exakt nach liburing-Blaupause (`ext/io/liburing/COMDARE-VENDOR-PROVENANCE.md`):

1. `ext/io/libxlsxwriter/` — Snapshot Tag `v1.2.4` (Tag+Commit-Hash beim Vendoring LIVE erheben und ins Provenance-Doc schreiben; nie aus diesem Dossier abschreiben), `.git/` entfernt (Haus-Doktrin: keine Submodules), geprunt auf `src/` + `include/` + `third_party/{minizip,md5,dtoa}` + Lizenzdateien; ENTFERNT: `test/`, `examples/`, `docs/`, Sprach-Bindings, `third_party/tmpfileplus/` (MPL, ungenutzt), CI-/Paket-Dateien. Eigene `CMakeLists.txt` + `COMDARE-VENDOR-PROVENANCE.md`.
2. `ext/io/zlib/` — zlib ist im ce-Bau heute NICHT vorhanden (grep CMakeLists/cmake: 0 Treffer). Empfehlung: **mit-vendorn** (zlib-Lizenz, ~25 C-Dateien, gleiches Snapshot-Muster) statt `find_package(ZLIB)` — self-contained ueber die 8er-Docker-Matrix, keine dev-Header-Annahme (sauberster, nicht einfachster Weg). Umkehrbar per CMake-Option `COMDARE_SYSTEM_ZLIB` (Default OFF). [Vorlage V-A9-2]
3. CMake-Target `comdare_vendored_xlsxwriter` (static, `EXCLUDE_FROM_ALL`-Verhalten wie liburing: wird NUR gezogen, wenn ein Consumer es braucht) mit Defines: `USE_STANDARD_TMPFILE` (kein MPL-Code), `USE_DTOA_LIBRARY` (MIT; locale-unabhaengige, byte-deterministische double-Ausgabe — Determinismus-Hauswert), MD5 bleibt PD-Bundled (Bild-Dedup-Pfad, harmlos).
4. Buchfuehrung: `LICENSE_AUDIT_EXT.md` + `NOTICE` um beide Snapshots ergaenzen; kein Python, keine Fremdsprache in der Buildchain (libxlsxwriter-Bau = reines C; Python nur upstream fuer Docs/Tests, die geprunt sind) — C++/Drogon-only-Doktrin unberuehrt (C-Vendor-Praezedenz: liburing).

### 2.3 Kein neues Repo / keine Remote-Anlage (geprueft)

Vendoring in `ext/` im ce ist ein **Snapshot im bestehenden Repo** — exakt wie liburing (Provenance-Doc: ".git/ entfernt (Vendor, kein Submodule -- Haus-Doktrin: keine Git-Submodules)"). Die Regel "Remote-Anlage/-Loeschung nur mit je-Repo-GO" (Synthese :83) greift NICHT: es entsteht kein Repo, kein Remote, kein Submodule-Eintrag. Ein "Fork" im GitHub-Sinne ist NICHT noetig; F3 ("Fork ... zulaessig") wird als Stufe-1-Snapshot mit lokalen Patches (falls je noetig, im Provenance-Doc protokolliert) eingeloest. [Vorlage V-A9-1]

## 3. Writer-API (Ziel-Schnittstelle zur Auswertung)

### 3.1 Einordnung und Bauform

- Ort: `libs/cache_engine/builder/lager_ablage/` (Schwester von `builder/bestandslog/` — beides Lager-Strecke; Naming nach Haus-Stil `NAMING_CONVENTIONS.md` §1.2: PascalCase-Domain-Klassen, snake_case-Methoden).
- **header-only-Wrapper? Antwort: geteilt.** Interfaces + Factory + CSV-Fallback = header-only (ce-Hausform). Das xlsx-Backend = EIGENE TU (`xlsx_ergebnis_writer.cpp`) in einem kleinen static Target `comdare_lager_ablage`, das `comdare_vendored_xlsxwriter` **PRIVATE** linkt. Grund: die C-Header (`xlsxwriter.h`) duerfen nicht transitiv in Consumer lecken, und Nicht-Nutzer (golden-/CI-Pfad) duerfen keinen Link-Zwang auf den Vendor bekommen. Praezedenz fuer TU-Bauform: `profile_facade/profile_run_facade.cpp`, `builder/best_binary_selector/best_binary_selector.cpp`.
- Format-Wahl = Laufzeit-Draht (Unter-Achsen-Regel "Haupt=CT/Unter=RT": Rueckschrieb-Methoden sind UNTER-Achsen der Mess-Tooling-Haupt-Achse, LED-54-T2) => GoF **Abstract Factory** mit Runtime-Auswahl xlsx|csv, KEIN std::variant (Verbotskanon; hier schlicht Interface-Polymorphie im Werkzeug-Layer, nicht im Tier-Binary).

### 3.2 Schnittstellen (Soll)

```cpp
namespace comdare::cache_engine::builder::lager_ablage {

enum class ErgebnisFormat { xlsx /*DEFAULT (F3)*/, csv /*Fallback derselben Factory*/ };

struct SheetSchluessel {         // EINE gewaehlte Unter-Achsen-Permutation (Reihenfolge = bindende
    std::string mess_unter;      // Sortierung: Mess-Unter -> System-Unter -> Organ-Unter)
    std::string system_unter;
    std::string organ_unter;
};

class IErgebnisBlatt {           // ein Sheet (xlsx) bzw. eine Datei (csv-Fallback)
  public:
    virtual ~IErgebnisBlatt() = default;
    virtual void kopf(std::span<std::string const> spalten) = 0;   // Spalten aus lazy_csv_header()-Split
    virtual void zeile(std::span<std::string const> felder) = 0;   // Felder aus format_csv_row-Split;
  };                                                               // "failed"-Zellen 1:1 durchreichen

class IErgebnisMappe {           // EINE xlsx-Datei bzw. EIN CSV-Dateisatz am selben Baum-Blatt
  public:
    virtual ~IErgebnisMappe() = default;
    virtual void info_blatt(MaschinenSysinfo const&,          // machine_identity.hpp, Provenienz-Kette,
                            HauptAchsenBelegung const&,       //   "n/a statt Null"
                            KonstantenMeta const&) = 0;       // weggelassene konstante Spalten (Doktrin)
    virtual IErgebnisBlatt& blatt(SheetSchluessel const&) = 0; // 1 Sheet je Unter-Achsen-Permutation
    virtual void schliessen() = 0;                             // atomar: tmp-Datei + rename; wirft
};                                                             //   ErgebnisSchreibFehler (Fehlerklasse)

class ErgebnisMappenFactory {    // Abstract Factory; Default xlsx, csv einstellbar (XML/CLI)
  public:
    [[nodiscard]] static std::unique_ptr<IErgebnisMappe>
    oeffne(std::filesystem::path const& blatt_verzeichnis,     // Baum-Blatt (Abschnitt 5)
           std::string const& dateiname_stamm,                 // Abschnitt 4 (ohne Endung)
           ErgebnisFormat f = ErgebnisFormat::xlsx);
};
} // namespace
```

Verhaltensvertraege:
1. **Quelle bleibt CSV**: Der Writer konsumiert ausschliesslich das WIDE-Schema (`lazy_csv_header()`-Spalten, header-getrieben wie `best_binary_selector_main.cpp:22`); er definiert KEINE eigene Spaltenmenge. Fehlende Spalten alter CSVs => leer/n-a (Datenerhaltungs-Muster der bestehenden Leser).
2. **xlsx-Limits als Fehlerklassen**: Sheet-Name hart <=31 Zeichen und ohne `[]:*?/\` => Sheets heissen deterministisch `S001..Snnn` (Reihenfolge = mixed-radix ueber die Unter-Achsen-Permutationen in bindender Sortierung), Klartext-Zuordnung in der Sheet-Legende des INFO-Blatts. Zeilenlimit 1.048.576 => `ErgebnisSchreibFehler{zeilenlimit}` statt stillem Truncate (honest-Doktrin). Fehlerklassen-IDs mit A15/#29 abstimmen (`axis_error.hpp`-Familie; der Kommentar `axis_error.hpp:420` verlangt genau diese Vokabel-Wiederverwendung).
3. **CSV-Fallback = dieselbe Factory**: je Sheet EINE Datei `<stamm>__S001.csv` + `<stamm>__INFO.csv` (Owner-KERN: "CSVs werden im FACTORY PATTERN je Sheet einzeln gebaut"). Semikolon-Konvention wie `lazy_csv_header()`.
4. **Determinismus**: dtoa-Backend + feste Sheet-/Spalten-Reihenfolge => gleicher Input ergibt byte-gleiche Sheets-XML (ZIP-Zeitstempel auf Epoche gepinnt); testbar.
5. **INFO-Blatt** (Pflichtinhalt): Sysinfo der messenden Maschine (HW-Erkennung, Provenienz configured_measured > spd_jedec_base > declared), verwendete HAUPT-Achsen aller drei Typen (Mess/System/Organ), konstante (weggelassene) Unter-Achsen als Meta-Eintraege, Sheet-Legende, Quell-CSV-Pfade + SHA512-Stempel-Referenzen der Quell-Binaries, Schema-/Writer-Version.

### 3.3 Anschluss an die Auswertung (Konsument)

- Haupt-Konsument = neues CLI `tools/mess_report/` (`comdare_mess_report`): offizielle Mess-CSV(s) -> xlsx-Baum. Subcommand-Stil wie Planer-CLI (clig.dev, f5cf3954): `report render|plan|version`; `plan` = dry-run und druckt den Ziel-Baum literal (Kein-✓-ohne-Ausgabe-tauglich).
- Heuristik-Strecke (`measurement_curve_loader.hpp`, `break_even.hpp`, `axis_spline.hpp`) bleibt CSV-Leser (Freeze-Kandidaten laut Synthese 2.4) — xlsx ist AUSGABE-Default der Auswertung, nicht deren Eingabeformat.
- Mess-Zeit bleibt xlsx-frei: `measurement_sink`-Naht und `result.csv`-Pfade unveraendert (Mess-I/O-Doktrin: git-Push + Mess-Sink synchron, keine zusaetzliche I/O-Contention in der Messphase). Die xlsx-Erzeugung laeuft NACH der Messung (Auswerte-/Einlagerungsschritt). Lesart-Bestaetigung als Vorlage V-A9-4 (KERN §6 nennt die CSV-Doktrin ausdruecklich "Vorstufe").

## 4. Dateinamens-Schema mit Unter-Achsen (Single-Source `ergebnis_dateiname.hpp`)

Doktrin (KERN §6 :91-93): Name = NUR Datum + Uhrzeit + dynamische Unter-Achsen-Variablen (aus der CoR-Filterkette der Auswertung); Haupt-Achsen liegen im ORDNER-Pfad und als Metadaten IN der Datei; nie sich aendernde Variablen werden WEGGELASSEN (Meta-Eintrag im INFO-Blatt).

Grammatik (EBNF-artig, ASCII, shell-sicher):

```
dateiname   := datum "-" zeit "_" kvkette "." endung
datum       := YYYYMMDD                  (UTC)
zeit        := HHMMSS                    (UTC; Kollisionsfrei je Blatt-Verzeichnis)
kvkette     := kv ("+" kv)*              (Reihenfolge: Mess-Unter -> System-Unter -> Organ-Unter,
                                          innerhalb des Typs bindende Achsen-Sortierung)
kv          := unterachse "=" wert       ("=" wie binary_id-Segmente axis_path_serialization.hpp:46;
                                          "+" wie build_version-Suffixe +cxx=/+opt=)
wert        := [a-z0-9._-]+              (sanitisiert; "sweep" wenn die Variable im File selbst
                                          ueber Sheets laeuft)
endung      := "xlsx" | "csv"
```

Wachen: Gesamtname <= 200 Bytes (ext4/NAS-Komponentenlimit 255 mit Reserve); Ueberlauf => `ErgebnisSchreibFehler{namenslimit}` + deterministischer Kurzname `<datum>-<zeit>_H=<sha512-hex16-der-kvkette>.xlsx` mit Voll-Kette im INFO-Blatt (nie stilles Kuerzen).

Beispiele (drei, mit Ordner-Kontext aus Abschnitt 5):

1. Wallclock-Sweep ueber die Arbeitsmenge (Mess-Unter-Variablen dynamisch, Rest konstant=>weggelassen):
   `20260812-093011_measurement_category=wallclock+workload=ycsb_a+working_set_n=sweep.xlsx`
   — Sheets S001..S00n = je eine (workload x working_set)-Unter-Permutation; Legende im INFO-Blatt.
2. System-Unter-Gruppe (Compiler-Gruppe R-D) im Opt-Level-Vergleich auf EINEM OS:
   `20260812-101500_opt_level=sweep+atomic128=on.xlsx`
   — os_version/kernel/build (A14 FINALE DREI) sind hier maschinenkonstant => NICHT im Namen, sondern INFO-Metadaten; bei Cross-OS-Aggregat dagegen im Namen: `...+os_version=24.04+kernel=6.17.0-35+build=noble...`
3. Organ-Unter-Variable (Knoten-Shape) unter fixem Haupt-Blatt:
   `20260812-114205_node_fanout=sweep+prefetch_distance=4.xlsx`
   CSV-Fallback derselben Factory dazu: `20260812-114205_node_fanout=sweep+prefetch_distance=4__S001.csv` + `..__INFO.csv`

Abgrenzung: Dateinamen tragen KEINE Stempel und KEINE Versions-Flag-Grammatik (Q3 `vX.Y.Zc` lebt in Stempeln/Registry); Unter-Achsen erscheinen NIE im Stempel (LED-Stempel-Doktrin: "Unter-Achsen nur in Mess-CSV/xlsx") — genau diese Datei ist ihr Zuhause.

## 5. Ablage im Lager-Baum (beide Realm-Wurzeln)

### 5.1 Messdaten-Realm (HIER wohnt xlsx; Default-Ziel NAS measure-drop, konfigurierbar; git-Archiv super `measurement/<ts>/`)

Kaskade exakt nach KERN §4 (:56-61) + §5 (:65-79):

```
<messdaten-wurzel>/                                        (NAS measure-drop; A12-Creds-Paket)
  mess=vereint+load_framework=on/                          (Ebene 1: Mess-Kombinatorik der BEIDEN
                                                            Mess-Haupt-Achsen Mess-Tooling x load_framework)
  target_isa=amd64_v3+operating_system=linux+external_utils=avx2/
                                                           (Ebene 2: EIN Ordner-Level = GESAMTE System-
                                                            Haupt-Rekombination; Meta-Metas HINTEN
                                                            angehaengt, hinter load_framework on/off)
    01_read_path=search_algo-prt_art+cache_traversal-bfs/  (Ebenen 3-7: die 5 Organ-Gruppen-Ordner
    02_layout=node_type-b_tree+memory_layout-soa+.../       01..05 GESCHACHTELT in Speicherhierarchie-
    03_placement=.../04_execution=.../05_write_path_io=.../ Reihenfolge; Ordnername traegt die Werte-
                                                            Rekombination der Gruppen-Achsen)
      blatt/                                               (Ebene 8: Haupt-Blatt = vollstaendige
                                                            Haupt-Achsen-Bindung aller drei Typen)
        mess_unter=<...>/system_unter=<...>/organ_unter=<...>/
                                                           (Ebenen 9-11: die 3 Unter-Ebenen gegen
                                                            Sheet-Explosion, nur soweit noetig)
          20260812-093011_<kvkette>.xlsx                   (Abschnitt 4)
```

Regeln: Ordner-Segmente nutzen DIESELBE kv-Grammatik (`=` innen, `+` als Joiner) — Single-Source `lager_pfad_grammatik.hpp`, geteilt mit dem A1-LB-Schnitt-Baum-Writer. `complete-heuristik.log` je Knoten + SHA512-Overlay + Truncate-Zustandsmaschine gehoeren dem A1-Baum-Writer (Abnahmen 1-6); A9 legt NIE selbst Knoten an, sondern bezieht das Blatt-Verzeichnis vom Baum-Writer/Resolver (ein Schreiber je Knoten, Lock-Regime der Lager-Strecke).

### 5.2 Binaries-Realm (KEIN xlsx)

Wurzel = System-Achse direkt -> Organ -> Mess-Typ als LETZTER/tiefster (KERN §4 :62-63; Default minio, Ebene B async). Inhalt: Binaries + Sidecars (`.algos/.fingerprint/.variant/.version`, `artifact_cache.hpp`) + Test-Logs (LED-68b) + `complete-heuristik.log`. A9 schreibt hier NICHTS; die Verbindung beider Realms ist rein referenziell: das INFO-Blatt jeder xlsx zitiert `binary_id` + SHA512-Fingerprint der vermessenen Binaries (Replay-Schluessel-Schichtung LED-62). Gemeinsam ist AUSSCHLIESSLICH die Grammatik-/Serialisierungs-Single-Source (`axis_path_serialization.hpp` fuer Organ-Segmente, `lager_pfad_grammatik.hpp` fuer kv/Joiner) — damit ist die Realm-Trennung (Owner-E2: "derzeit defekt", A13) auf der Datei-Ebene konstruktiv sauber.

Hybrid-Auflage K1 beachtet: solange die Lager-Identitaet der Hybrid-.so offen ist, nimmt KEIN Lager-Schema Hybrid-Knoten an — die Grammatik reserviert kein Hybrid-Segment und wird bei K1-Entscheid additiv erweitert.

## 6. Scheiben-Plan + Gates

Einordnung: GATE 9 "Restpakete parallelisierbar" (Synthese :236) — NICHT trigger-blockierend, aber PFLICHT vor der Auswertung (E.4) und per R9 ("ALLES genannte wird voll gebaut") nicht streichbar. Worker nach v2.1-Matrix; je Scheibe ultracode VOR+NACH, Kadenz LED-16:190 (Mojibake-0, cf22 --Werror==0, Doppellauf ctest mit N, gitleaks, beide Remotes, CI hart gruen, super-Sub-Build Pflicht, ASCII-Diff-Selbstcheck).

| Scheibe | Inhalt | Worker (v2.1) | Gates (literal) |
|---|---|---|---|
| A9-S1 Vendor | `ext/io/zlib/` + `ext/io/libxlsxwriter/` Snapshots (Tag live pinnen), Provenance-Docs, CMake-Targets consumer-only, `USE_STANDARD_TMPFILE`+`USE_DTOA_LIBRARY`, tmpfileplus geprunt, `LICENSE_AUDIT_EXT.md`+`NOTICE` | Opus 4.8 (leicht/Infra-artig) | Vendor-Target baut lokal standalone+super-Sub-Build; ctest N unveraendert (kein Default-Link); golden byte-neutral (Registry-sha identisch); CI beide Hosts gruen; gitleaks 0 |
| A9-S2 Grammatik | `lager_pfad_grammatik.hpp` + `ergebnis_dateiname.hpp` (Single-Source, Wachen 200-Byte/31-Zeichen/Zeichenklasse), golden-string Unit-Tests nach `test_s1_cache_key_prefix`-Muster | Opus 5 (Struktur nach Design) | Golden-String-Tests gruen (N mitfuehren); Abnahme-Review durch A1-LB-Schnitt-Strang (gemeinsame Single-Source, kein Fork der Grammatik) |
| A9-S3 Writer-Kern | `builder/lager_ablage/`: Interfaces (header-only), `XlsxErgebnisMappe` (TU, PRIVATE-Link), `CsvErgebnisMappe`, Factory, Fehlerklassen-Anschluss (A15-IDs), INFO-Blatt | Codex (schwere/neue Logik) + Dual-Review Fable+Codex | Unit-Tests: ZIP-Struktur-Selbstpruefung per eigenem PK-Signatur-Scanner im Test (kein Python, kein externes Tool); Locale-Determinismus-Test (LC_NUMERIC=de_DE => byte-identisch); Zeilen-/Namenslimit-Negativproben literal |
| A9-S4 CLI + Dual-Weg | `tools/mess_report/` (`comdare_mess_report render|plan|version`, header-getriebener CSV-Leser, CoR-Filter fuer dynamische Variablen, --realm-root/--format/--dry-run), MANUAL_RUN.md-Abschnitt, CI-Job rules-gated inert (CI-Gruen != Auswertung) | Codex | LED-61-Dual-Weg-Beleg: einmal CI-inert-Struktur + einmal lokal ueber offizielles CMake-Target mit literalem Baum-ls; Plan-dump deterministisch (2 Laeufe diff==0) |
| A9-S5 Erstbeleg | Render des Archiv-Bestands super `measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv` (read-only Quelle) in einen lokalen Ziel-Baum; Beleg = literaler Baum + Sheet-Katalog | Manager-Abnahme | Quelle unangetastet (Alt-Mess-CSV=Archiv; Messdaten nie loeschen — nur ADDITIV neue Artefakte); Owner-NUR-KENNTNIS-Meldung mit Beleg-Ausgabe |

Sequenz/Abhaengigkeiten: S1 ab sofort; S2 braucht Abstimmung mit A1 (Baum-Writer nutzt dieselbe Grammatik — wer zuerst landet, stellt die Single-Source, der andere konsumiert); S3 nach S1+S2; S4/S5 nach S3. Beruehrpunkte NULL mit: `lazy_csv_header` (Schema-Freeze), Stempel-Strecke (A13), golden-Fixtures, Pruef-Dock. NAS-Zielpfad-Inbetriebnahme haengt an A12 (bis dahin lokaler Wurzel-Pfad per Konfiguration).

## 7. Konformitaets-Selbstpruefung gegen die Doktrinen

- Vendoring-Doktrin Stufe 1 eingehalten (echter Upstream-Code, liburing-Blaupause) — kein faithful/self-contained noetig.
- Kein Python in der Buildchain (Vendor-Bau = reines C; Tests pruefen ZIP-Struktur mit eigenem C++-Scanner).
- C++/Drogon-only: C-Vendor wie liburing zulaessig; Wrapper/CLI C++23.
- xlsx=Default, CSV=Fallback derselben Factory; Unter-Achsen im Dateinamen; Haupt-Achsen als Ordner+Metadaten; konstante Variablen weggelassen (Meta) — KERN §4/§6 woertlich umgesetzt.
- Kein std::variant, statischer Dispatch wo CT (Grammatik/Serialisierung), RT-Factory nur am Unter-Achsen-Draht (Haupt=CT/Unter=RT-Regel).
- golden-/CI-Neutralitaet: rein additiv, No-Op ohne Consumer, Mess-Pfad byte-unberuehrt.
- Messdaten nie loeschen: Writer schreibt atomar-additiv (tmp+rename), ueberschreibt nie, invalidiert nie.


---

## ANHANG (aus Backup-JSON): entscheidungs_vorlagen

- V-A9-1 [NUR ZUR KENNTNIS, Default: ausfuehren] Vendoring-GO libxlsxwriter: Kontext: F3 (01.08.) erlaubt 'eigener Writer, Fork/Orientierung libxlsxwriter'. Beleg: liburing-Praezedenz ce ext/io/liburing/COMDARE-VENDOR-PROVENANCE.md (Stufe-1-Snapshot ohne .git, 'kein Submodule -- Haus-Doktrin'). Geprueft: Vendoring in ext/ im ce ist ein Snapshot im BESTEHENDEN Repo — es entsteht KEIN neues Repo, KEIN Remote, KEIN Submodule; die Remote-Anlage-nur-mit-je-Repo-GO-Regel greift daher NICHT. Vorhaben: Snapshot Tag v1.2.4 (neuestes Release 06.01.2026, BSD-2-Clause/'FreeBSD', einzige Abhaengigkeit zlib; Tag+Commit beim Vendoring live verifizieren und ins Provenance-Doc schreiben) nach ce ext/io/libxlsxwriter/ inkl. LICENSE_AUDIT_EXT.md- und NOTICE-Nachtrag. Umkehrbarkeit: voll (Snapshot-Loeschung = ein Commit, keine Remote-Spuren). Optionen: (a) ausfuehren [Empfehlung+Default, F3-gedeckt], (b) stattdessen self-contained Minimal-Writer (verstiesse gegen die geordnete Vendoring-Doktrin Stufe 1).
- V-A9-2 [RUECKFRAGE, Default: Option A] zlib-Strategie: Kontext: libxlsxwriter braucht zlib; grep ueber ce CMakeLists.txt + cmake/ = 0 zlib-Treffer, zlib ist heute KEINE ce-Abhaengigkeit. Optionen: (A) zlib mit-vendorn als ext/io/zlib/ (zlib-Lizenz, gleiches liburing-Snapshot-Muster; self-contained ueber die 8er-Docker-Matrix, keine dev-Header-Annahme) [Empfehlung+Default — sauberster, nicht einfachster Weg]; (B) System-zlib via find_package(ZLIB) (weniger Repo-Gewicht, aber alle 8 Docker-Images + beide Hosts brauchen zlib-dev — neue Infra-Annahme + Infra-Handout). Umkehrbarkeit: hoch (CMake-Option COMDARE_SYSTEM_ZLIB, Default OFF, macht beide Wege schaltbar).
- V-A9-3 [NUR ZUR KENNTNIS, Default: so bauen] Third-party-Lizenzhygiene im Snapshot: tmpfileplus (MPL-2.0, file-level Copyleft) wird per USE_STANDARD_TMPFILE NICHT kompiliert und im Snapshot GEPRUNT; dtoa (MIT) wird per USE_DTOA_LIBRARY AKTIVIERT (locale-unabhaengige, byte-deterministische double-Ausgabe); Openwall-MD5 (Public Domain) bleibt gebuendelt; minizip (zlib-Lizenz) ist der ZIP-Packer. Beleg: libxlsxwriter.github.io/license.html (02.08.2026 gelesen). Deckung: Lizenz-Endstand 02.08. 'vendored ext/ behaelt eigene Lizenzen'. Umkehrbarkeit: voll (reine Build-Flags + Prune-Protokoll im Provenance-Doc).
- V-A9-4 [RUECKFRAGE zur Lesart-Bestaetigung, Default: so bauen] Naht-Aufteilung CSV/xlsx: Kontext: KERN 26.07. §6 nennt die CSV-Doktrin woertlich 'Vorstufe' und setzt 'xlsx = kuenftig DEFAULT, CSV einstellbar + Fallback' (Factory). Design-Lesart: die per-Binary result.csv (+Resume-Stamp, cache_engine_builder_iterator.hpp:825/:1553) und die offizielle e4_xml/measurements.csv bleiben das MASCHINEN-/Resume-Format der Mess-Zeit (Mess-I/O-Doktrin: keine zusaetzliche I/O in der Messphase); xlsx ist der DEFAULT der Lager-ABLAGE/AUSWERTUNG dahinter (dieselben Zeilen, gerendert in den Messdaten-Realm-Baum; CSV-Fallback derselben Factory je Sheet). Optionen: (a) Lesart bestaetigen [Empfehlung+Default]; (b) xlsx zusaetzlich schon an der Mess-Zeit-Naht erzeugen (mehr I/O im Messfenster, widerspricht der Contention-Doktrin). Umkehrbarkeit: hoch (Naht ist eine Factory-Konfiguration, kein Formatbruch — die CSV-Quelle bleibt in jedem Fall bestehen).

## ANHANG (aus Backup-JSON): offene_punkte

- Tag-Pin beim Vendoring LIVE verifizieren (Stand 02.08.: v1.2.4 vom 06.01.2026; Tag-Objekt+Commit-Hash gehoeren ins COMDARE-VENDOR-PROVENANCE.md — nie aus dem Dossier abschreiben; nie-raten-Doktrin).
- Sequenz-/Ownership-Entscheid Manager: wer stellt die gemeinsame Single-Source lager_pfad_grammatik.hpp — A9-S2 oder der A1-LB-Schnitt-Baum-Writer (GATE 6)? Beide Straenge duerfen die Grammatik nicht forken; ein Schreiber je Knoten (Lock-Regime) gilt auch fuer A9-S5.
- Fehlerklassen-IDs (ErgebnisSchreibFehler: zeilenlimit/namenslimit/zip_fehler) mit A15/#29-Framework abstimmen, bevor A9-S3 baut (Fehlerklassen-Pflicht ueber alle Achsen/Unter-Achsen/Algorithmen).
- NAS-Wurzelpfad des Messdaten-Realms haengt an A12 (NAS-Creds backup1/backup2, E-14); bis dahin lokaler konfigurierbarer Wurzel-Pfad — Umschaltung ist reine Konfiguration.
- Hybrid-K1 offen: kein Lager-Schema darf Hybrid-Knoten annehmen; die Pfad-Grammatik reserviert bewusst KEIN Hybrid-Segment und wird nach K1-Entscheid additiv erweitert.
- Sheet-Benennung: Default = Kurzcodes S001..Snnn + Klartext-Legende im INFO-Blatt (31-Zeichen-Limit von xlsx); falls der Owner Klartext-Sheetnamen wuenscht, braucht es eine verlustbehaftete Kuerzungsregel — als Geschmacksfrage im naechsten Owner-Vorlagen-Block mitfuehren.
- result_aggregator.hpp:92 (result_csv_header, RFC-4180-Alt-Kopf) ist ein ZWEITER CSV-Kopf neben lazy_csv_header — nicht Teil von A9, aber Kandidat fuer die LED-75-Kandidatenliste (pruefen, ob noch Leser existieren).
- macOS/RISC-V-Plattform-Zugang (Owner-E4, kommen 'heute'): tmpfile()/POSIX-Annahme von USE_STANDARD_TMPFILE gilt auch auf macOS; Windows-Runner braeuchten spaeter eine eigene Tmp-Strategie — bei E-19-Fleet-Erweiterung gegenpruefen.
- Doku-Nachzug nach Bau: MANUAL_RUN.md-Abschnitt (S4), INDEX-/Architektur-Doc fuer builder/lager_ablage/, Ledger-Nachtrag im gebuendelten A11-Paket (nicht solo).
