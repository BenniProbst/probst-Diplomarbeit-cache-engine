# V9 — Anker Vollimplementation (2026-05-14, 11:30)

**Vorgaenger:** `20260514-1100-v8-final-stand-und-naechste-schritte.md` §4 (V9-TODOs)
**Modus:** Vollautonom KIV (User-Direktive 2026-05-14: *"starte V9 vollautonom"*)

---

## §1 V9-Tasks (7 Stueck) + Reihenfolge

| # | Task | Repo | Abhaengigkeit |
|---|---|---|---|
| V9.4 | legacy_reimpl physisch verschieben | cache-engine + prt-art | unabhaengig — zuerst (cleanup) |
| V9.5 | Rang-2 + Rang-3 SOTA-Profile (P11-P30) | cache-engine | unabhaengig |
| V9.1 | konkrete Adapter-Subklassen | prt-art | nutzt PrtArtSearchEngineAdapter (V8.9) |
| V9.2 | std::variant Bausteine operationalisieren | cache-engine | nutzt algorithm_baustein.hpp (V8.8) |
| V9.3 | algorithm_profiles → codegen | cache-engine | benoetigt V9.2 + V9.5 |
| V9.6 | messung_driver liest Messreihen-XML | Diplomarbeit | benoetigt V9.3 |
| V9.7 | Final commits + pushes + Submodule-Pins + Session | alle 3 | letzter |

---

## §2 Designentscheidungen (autonom getroffen)

### §2.1 V9.4 Migrations-Strategie
- `git mv` der 14 P*-Subordner aus cache-engine `prt_art/legacy_reimpl/` nach
  prt-art `prt_art/legacy_reimpl/` (per `cp -r` + `git rm -r` da Cross-Repo).
- cache-engine prt_art/legacy_reimpl/CMakeLists.txt + README bleiben als
  DEPRECATED-Marker.
- prt-art bekommt eigene CMakeLists.txt + README in legacy_reimpl/.

### §2.2 V9.5 Rang-2/3 Profile
- Pro Paper ein vollstaendiges Profil mit allen 11 Achsen.
- Wert-Auswahl pro Achse anhand der Tieflektuere (P11-P33 Cluster A-F).
- 22 Profile: P11 P12 P13 P14 P15 P16 P17 P18 P19 P20 P21 P22 P23 P24 P25 P26
  P27 P28 P29 P30 P31 P32 (P33 ist VAMPIR-Poster, kein Algorithmus).

### §2.3 V9.1 Adapter-Subklassen
- 3 konkrete Spezialisierungen:
  - `PrtArtSearchEngineAdapterMap<K, V>` (2 Param, Map-API)
  - `PrtArtSearchEngineAdapterVector<V>` (1 Param, Vector-API)
  - `PrtArtSearchEngineAdapterTuple<K, V1, V2, ...>` (Tuple-API, N>2)
- Implementiert die abstract virtual lookup/insert/erase/size/empty per
  Delegation an impl_->find / insert / erase / size.

### §2.4 V9.2 Variants operationalisieren
- 11 echte `using PageVariant = std::variant<...>` etc. mit Tag-basierten
  Stub-Klassen (z.B. `struct ArtPageTag {};` als Marker — Konkretisierung
  in spaeterer Implementierungs-Phase).
- `eleven_axes_permutation<...>` Type-Alias mit Default-Tags.

### §2.5 V9.3 codegen
- `Codegen::generate_module_from_profile(AlgorithmProfile const&)` neu.
- Generiert pro Profil ein C++-Modul mit ABI-Bindings (`COMDARE_MODULE_V1`
  Macros) basierend auf den Achsen-Werten.

### §2.6 V9.6 messung_driver
- Liest jetzt zusaetzlich `messreihen.xml` (oder das config_a-XML mit
  `<messreihe>`-Tags); leitet Mode (defined/full) an ExperimentDriver weiter.

---

## §3 Akzeptanzkriterien

- [ ] cache-engine `prt_art/legacy_reimpl/P*/` Ordner sind leer / entfernt
- [ ] prt-art `prt_art/legacy_reimpl/P*/` Ordner enthalten 14 Subordner
- [ ] cache-engine `algorithm_profiles/sota/` enthaelt 30 Profile (8 Rang-1 + 22 Rang-2/3)
- [ ] prt-art `prt_art/identity/prt_art_search_engine_adapter.hpp` definiert 3 konkrete Subklassen
- [ ] cache-engine `algorithm_baustein.hpp` definiert echte Variants pro 11 Achsen
- [ ] cache-engine codegen kann ein Profil zu C++-Modul-Quelle transformieren
- [ ] Diplomarbeit messung_driver liest Messreihen-XML
- [ ] cmake configure aller 3 Repos gruen
- [ ] Alle 3 Repos commit + push + Submodule-Pins gebumpt

---

## §4 Querverweis

- V8 Final: `20260514-1100-v8-final-stand-und-naechste-schritte.md` §4 (V9-TODOs)
- Architektur: `20260508 Termin 7/Phase5_UML_Detail/24_architektur_skizze_REV7_2026_05_13.md`
- Memory: `feedback_session_at_95_percent_context.md` (Pflicht-Direktive)
