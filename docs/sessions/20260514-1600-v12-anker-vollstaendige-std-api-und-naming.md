# V12 — Anker: Vollstaendige std-Container-Interfaces + Naming-Audit (2026-05-14, 16:00)

**Vorgaenger:** `20260514-1530-v11-final-stand.md`
**Modus:** Vollautonom (User-Direktive 2026-05-14:
*"Standardinterface fuer Suchalgorithmen war nicht vollstaendig — std::vector
hat wesentlich mehr Funktionen bei 1 Param + std::map bei 2+ Params.
Pruefe zusaetzlich, ob die Benennung aller namespaces und variablen
kanonisch genug ist, um von einem Entwickler verstanden zu werden."*)

---

## §1 User-Direktiven V12

### DI-1: Vollstaendigkeit der hybriden std-Container-API
- 1 Template-Param → muss **vollstaendige std::vector-API** anbieten
- 2 Template-Params → muss **vollstaendige std::map-API** anbieten
- N>2 Template-Params → std::map mit std::tuple<V...>-Values

### DI-2: Kanonische Benennung
- Namespace-Konsistenz pruefen
- Variablen-Naming Konsistenz (snake_case + Trailing-Underscore-Members)
- Abkuerzungsfreie, sprechende Identifier

---

## §2 V12-Tasks (8 Stueck)

| # | Task | Repo | Abhaengigkeit |
|---|---|---|---|
| V12.0 | Anker mit User-Feedback (dieses Dokument) | Diplomarbeit | (in diesem Push) |
| V12.1 | PrtArtSearchEngine Vector-API vervollstaendigen | prt-art | Audit existierende Methoden |
| V12.2 | PrtArtSearchEngine Map-API vervollstaendigen | prt-art | Audit existierende Methoden |
| V12.3 | search_engine ABI Container-Vertraege erweitern | cache-engine | Foundation fuer V12.4 |
| V12.4 | PrtArtSearchEngineAdapter neue ABI-Methoden | prt-art | nutzt V12.3 |
| V12.5 | Naming-Audit Namespaces + Variablen | alle 3 | unabhaengig |
| V12.6 | baustein_variants Achsen 2-11 (analog V11.4) | cache-engine | erweitert V11.4 |
| V12.7 | Tests + cmake configure | alle 3 | nach allen Code-Changes |
| V12.8 | Final commits + pushes + Pin-Bumps + Session | alle 3 | letzter |

---

## §3 V12.1 Vector-API Audit

### §3.1 Bereits vorhanden (in PrtArtSearchEngine<Value>)
- `size`, `empty`, `capacity`, `max_size`
- `at`, `front`, `back`, `data`
- `begin`, `end`, `cbegin`, `cend`
- `push_back` (2x), `pop_back`, `set_at`, `insert_at`, `erase_at`
- `clear`, `resize` (2x), `reserve`, `shrink_to_fit`, `assign`

### §3.2 Fehlt (V12.1 ergaenzt)
- `operator[](size_type)` — non-throwing access (vs `at` der std::optional returnt)
- `emplace_back(Args&&...)` — variadic emplace
- `rbegin/rend`, `crbegin/crend` — Reverse-Iteratoren
- `swap(other)` — Member-Swap
- `assign(InputIt, InputIt)` — Range-assign

---

## §4 V12.2 Map-API Audit

### §4.1 Bereits vorhanden (in PrtArtSearchEngine<Key, Value>)
- `size`, `empty`, `count`, `contains`
- `lookup`, `find`, `at`
- `begin/end/cbegin/cend`
- `lower_bound`, `upper_bound`, `equal_range`
- `range_query` (custom)
- `insert` (1- und N-Versions), `insert_mapped`
- `erase`, `clear`, `set`
- Mess-Hooks (`total_inserts`, `total_erases`, `total_hits`, `total_misses`)

### §4.2 Fehlt (V12.2 ergaenzt)
- `max_size`
- `emplace`, `emplace_hint`, `try_emplace`
- `insert_or_assign`
- `operator[](Key)` — Lazy-Insert mit Default-Value
- `rbegin/rend/crbegin/crend`
- `swap(other)`
- `key_comp`, `value_comp`
- `merge`, `extract`

---

## §5 V12.5 Naming-Audit Strategie

### §5.1 Namespace-Konsistenz pruefen
- `comdare::*` (Top-Level)
- `comdare::cache_engine::*` (cache-engine)
- `comdare::prt_art::*` (prt-art)
- `comdare::experiment::*` (Aggregator)
- `comdare::workload_generator::*`
- `comdare::builder::*` (CacheEngineBuilder)
- `comdare::builder::xml::*`, `comdare::builder::codegen::*`, etc.

Pruefen: Sind die Schichten konsistent? `comdare::cache_engine::baustein` vs
`comdare::cache_engine::baustein_t` etc.

### §5.2 Variablen-Naming
- Pflicht: snake_case fuer Variablen + Funktionen
- Pflicht: trailing `_` fuer private Member-Variablen
- Pflicht: `kCamelCase` (k-prefix) fuer constexpr static globals
- Pflicht: `PascalCase` fuer Klassen/Structs

### §5.3 Audit-Befund
- pruefen mit grep auf typische Anti-Patterns:
  - Variablen ohne `_` als private (gegen Konvention)
  - Klassen mit camelCase (sollte PascalCase sein)
  - Abkuerzungen wie `tmp`, `tbl`, `ce_perm` (sollten ausgeschrieben sein)
  - Magic-Number-Konstanten ohne benannte constexpr

---

## §6 Akzeptanzkriterien V12

- [ ] PrtArtSearchEngine<Value> hat operator[], emplace_back, swap, rbegin/rend
- [ ] PrtArtSearchEngine<Key,Value> hat operator[], emplace, try_emplace, insert_or_assign, swap
- [ ] search_engine ABI hat count/contains/clear (Default-Bodies)
- [ ] PrtArtSearchEngineAdapter Subklassen implementieren neue ABI-Methoden
- [ ] baustein_variants Achsen 2-11 mit description + paper_ref
- [ ] Naming-Audit-Bericht in Session-Doku
- [ ] cmake configure aller 3 Repos gruen
- [ ] Alle 3 Repos commit + push + Submodule-Pins gebumpt

---

## §7 Querverweise
- V11-Final: `20260514-1530-v11-final-stand.md` (V12-TODOs §6)
- V11-Anker: `20260514-1430-v11-anker-mit-delta.md`
- Memory: `feedback_session_at_95_percent_context.md`
