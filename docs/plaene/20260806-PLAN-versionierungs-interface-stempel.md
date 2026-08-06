# PLAN: GESONDERTES VERSIONIERUNGS-INTERFACE + CT-NAMENSFUNKTION

> **Status:** DESIGN-BAUPLAN, Phase 2 der Planungs-Welle `wf_732cebce`
> (Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:4243-4246`).
> Phase 1 = Ist-Erhebung der Stempel-Substanz (in diesem Dokument verarbeitet und punktuell am Objekt
> nachgeprueft; zwei Korrekturen an der Erhebung stehen in Abschnitt 0.2).
> **KEIN Code-Bau, KEIN Commit aus diesem Dokument.** Es liefert Zielbild, Interface-Entwurf,
> Migrations-DAG, Gates und Owner-Entscheid-Vorlagen.

> **OWNER-DIREKTIVE VERBATIM** (Ledger `:4243`, F7-Entscheid UND neuer Architektur-KERN):
> "Bitte Option b: Wir hatten einen komplexen Stempel mit allen Achsen-Kategorien festgelegt mit jeweils
> versionierten Achsen-Algorithmen und zum Schluss ein SHA Hash als fingerprint. Wir erzeugen eine Funktion,
> die zur compile time auch den Namen der Funktion aus dieser Rekombination in die binary schreibt und durch
> ein eigenes Interface der Stempel-Versionierung an jeder Planer/CEB/Tier-Binary anbietet. Dies soll ein
> gesondertes Versionierungs-Interface sein."

---

## 0. IST-ANKER UND ZWEI KORREKTUREN AN DER ERHEBUNG

### 0.1 Geprueft am Objekt (2026-08-06)

Pfad-Kuerzel: `super/` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`,
`ce/` = `super/Code/external/comdare-cache-engine`, `t2a/` = `/home/comdare/wt-b2-neuanker`.

| Anker | Wert |
|---|---|
| ce HEAD (Submodul-Stand) | `3bbcb8ed` -- Preimage-**Format 2**, `kAnatomyFingerprintGliedCount = 6` (`ce/libs/cache_engine/include/cache_engine/abi/anatomy_fingerprint.hpp:64,104`) |
| t2a HEAD | `847c93c9` -- Preimage-**Format 3**, `kAnatomyFingerprintGliedCount = 8` (`t2a/libs/cache_engine/include/cache_engine/abi/anatomy_fingerprint.hpp:89,341`) |
| ABI-Major | **8**, Magic `COMDA.A8.` (`.../abi/anatomy_module_abi_v1_decl.hpp:89,93`) |
| `kAnatomyVersionLinesLayout` | **6**, Gleichheits-Wache `stamp_pod_has_entries` (`.../anatomy_module_abi_v1_decl.hpp:234,253-255`) |
| golden-CRC | `kNewGolden131072Crc64 = 0xF1C1F26A1232073B` (`.../profile_facade/source_catalog.hpp:183-187`) |
| golden-320 | `tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt` (+ `_abi4/_abi5/_abi6`) |

### 0.2 Zwei Korrekturen an der Erhebung

**(K1) Der Frozen-Vektor `17148e5a...` EXISTIERT** -- die Erhebung meldete ihn als "in keinem der beiden
Baeume auffindbar". Er steht in T2-A an **drei** Stellen, alle mit demselben Wortlaut:
`t2a/tests/unit/test_m_w12_stamp_bausteine.cpp:663`, `t2a/tests/unit/test_g3_sha512_index.cpp:68`,
`t2a/tests/unit/test_w10_system_cell_values.cpp:432`. Der ce-Stand fuehrt an denselben drei Stellen den
Format-2-Vorgaenger `0fe275bd...` (`ce/.../test_m_w12_stamp_bausteine.cpp:565`, `:test_g3_sha512_index.cpp:45`,
`:test_w10_system_cell_values.cpp:418`). Der T2-A-Vektor ist in **END-FORM** eingefroren: Toolchain- und
bvset-Glied tragen realistische **Literale** (`test_m_w12_stamp_bausteine.cpp:653-660`), bewusst maschinen-fremd,
damit der Anker in der 8er-Docker-Matrix ueberhaupt stabil sein kann. Das ist fuer den Migrations-DAG
entscheidend: **es gibt drei Frozen-Stellen, nicht eine**, und jeder Preimage-Dreh kostet alle drei.

**(K2) Die zentrale Frage "kann der SHA-Fingerprint CT gebildet werden" ist keine offene Frage --
sie ist beantwortet, und zwar durch den Bestand.** `anatomy_fingerprint_hex(...)` ist **`consteval`**
(`t2a/.../abi/anatomy_fingerprint.hpp:584`) ueber der voll `constexpr`-faehigen Primitive
`ce/libs/cache_engine/src/sha512/ctsha512.hpp:99-151`, deren NIST-Pruefvektoren als `static_assert`
einkompiliert sind (`ctsha512.hpp:197-206`). Der Hash wird heute in **jedem** emittierten Tier-Modul zur
Compile-Zeit gebildet, innen im Makro (`.../abi/anatomy_module_abi_v1.hpp:159-160`). Details in Abschnitt 2.3.

---

## 1. ZIELBILD

### 1.1 In Owner-Sprache

Jede Binary, die in dieser Kette entsteht -- der **Planer**, die **CEB**, jede **Tier-Binary** (und damit auch
die Hybrid-Stufe) -- traegt ihren **Stempel** eingebrannt bei sich und bietet ihn ueber **eine einzige,
gesonderte Schnittstelle** an. Der Stempel ist derselbe komplexe Stempel, der schon festgelegt ist: **alle
Achsen-Kategorien** (Organ, System, Mess) mit **je versionierten Achsen-Algorithmen**, dazu die
Toolchain-Achsen, die Enable-Mengen und das Werteset -- und **zum Schluss der SHA-Fingerprint** ueber genau
diese Rekombination. Aus derselben Rekombination entsteht **zur Compile-Zeit** der **Name**, und dieser Name
steht **in der Binary**. Wer wissen will, welche Version in einem Stueck steckt, fragt das Interface -- an
jeder Stufe dieselbe Frage, dieselbe Antwort-Form, keine zweite Ableitung irgendwo daneben.

### 1.2 Praezise

Das Versionierungs-Interface ist **kein neuer Stempel**. Es ist die **eine Anbieter-Flaeche** ueber der
bestehenden Stempel-Substanz. Es bietet an:

| Was | Woher (Single-Source im Bestand) |
|---|---|
| **Achsen-Kategorie Organ** -- 18 Haupt-Achsen, je `achse=algo@X.Y.Z[flag]` | `abi/anatomy_version_stamp.hpp:81-116` (`organ_stamp_line<Comp>()`) bzw. `builder/experiment_tree/axis_variant_version_table.hpp:296-326` (`compose_organ_stamp_line`) |
| **Achsen-Kategorie System** -- 3 Haupt-Achsen + Meta-Meta-Klammer | `abi/anatomy_version_stamp.hpp:144-161` (`system_stamp_line()`) |
| **Achsen-Kategorie Mess** -- Tooling-Haupt-Wahl + `[load_framework=...]` | `abi/anatomy_version_stamp.hpp:216-231,239-258` |
| **Sub-Achsen-Werteset** | `abi/subaxis_valueset_segment.hpp` (`kSubAxisValuesetSegment`) |
| **Toolchain-Achsen** (Compiler inkl. Realversion+Flags, opt_level, atomic128, ext/bt/gate/ceb) | `abi/toolchain_stamp_glied.hpp` (Glied [5], Format 3) |
| **Build-Enable-Menge** (page_type/simd_extension/general_hardware) | `builder/build_variant_set_signature.hpp` (Glied [6], Format 3) |
| **Overlay-Source-Hash** | Glied [7], heute leer (OF-M3-2 = Fallback B) |
| **Der abschliessende SHA-512-Fingerprint** | `abi/anatomy_fingerprint.hpp:584-599` (`consteval anatomy_fingerprint_hex`) |
| **Der CT-Rekombinations-NAME** | **NEU** -- Abschnitt 2 |
| **Die Stufen-Kennung** (planer/ceb/tier/hybrid) | **NEU** -- reines Datenfeld, kein Dispatch |

Und es bietet das an **wo**:

| Stufe | Dock heute | Dock nach diesem Plan |
|---|---|---|
| **Tier-Binary** (.so/.dll) | optionales 5. `extern "C"`-Symbol `comdare_anatomy_version_lines()` (`abi/anatomy_module_abi_v1_decl.hpp:280-286`), POD `AnatomyVersionLines`, Layout 6, `sizeof==120` (`:241`) | zusaetzliches **optionales 6. Symbol** `comdare_version_stamp()` mit dem NEUEN POD. Kein ABI-Major-Bump (dieselbe Begruendung wie `:139-146`: keine Loader-Pflicht) |
| **CEB** (`apps/cache_engine_builder`) | `ceb_version_stamp()` -- ein **eigener** String-Renderer + **eigene** SHA-Provenienz `kCebFingerprint` (`builder/ceb_version_stamp.hpp`), ausgegeben im Log-Kopf (`apps/cache_engine_builder/main.cpp:161`) | derselbe POD, gefuellt durch **dieselbe** Renderer-Kette; `ceb_version_stamp()` wird zur **Ausgabe-Form des POD** statt zu einem dritten Ableitungsweg |
| **Planer** (`apps/experiment_planner`) | `planner_version_stamp()` -- Selbst-Version + ISA/OS, **ohne** Achsen-Kategorien, **ohne** Fingerprint (`profile_facade/planner/planner_version.hpp:56-66`); Subkommando `version` (`apps/experiment_planner/main.cpp:261-263`) | derselbe POD; die Planer-Stufe fuellt die Achsen-Kategorie-Glieder mit dem **Angebot**, das sie kennt, und laesst die uebrigen ehrlich leer (honest-empty statt Fuellwert) |
| **Hybrid** | -- | in-process derselbe POD ueber einen `constexpr`-Accessor; kein `dlopen`, kein `dynamic_cast` |

### 1.3 Warum GESONDERT und nicht ins Observer-Interface

Der Owner sagt ausdruecklich "gesondert". Die Trennung ist technisch zwingend, nicht Geschmack -- **fuenf**
unabhaengige Gruende, jeder fuer sich hinreichend:

**(a) Andere Lebensdauer: CT-IDENTITAET vs RT-MESSUNG.** Der Stempel steht fest, sobald die Binary existiert;
er ist fuer ihre gesamte Lebensdauer konstant und muss lesbar sein, **bevor irgendeine Instanz existiert** --
das Skip-Gate `dll_is_current` (`builder/build_orchestrator/build_orchestrator.hpp:293-299`) entscheidet ueber
den Bau, ohne je `comdare_create_anatomy()` zu rufen. Genau deshalb ist der bestehende Stempel-Zugang ein
freies `extern "C"`-Symbol und **keine** Methode an `IAnatomyBase`. Der Observer-Snapshot ist das exakte
Gegenteil: er ist **pro Instanz**, **pro Messphase**, veraenderlich und wird per
`tier_reset_statistics()` genullt (`anatomy/observable_tier.hpp:199`). Ein Interface, das beides traegt,
haette zwei unvereinbare Lebensdauer-Vertraege in einer vtable.

**(b) Andere Konsumenten.** Observer-Konsument = der messende Host im Mess-Fenster (CSV-Spalten, Pfad-B-Timing).
Stempel-Konsumenten = Bau-Skip-Gate, `.fingerprint`-Sidecar (`profile_facade/fingerprint_sidecar.hpp`),
Lager-/Bestand-Schluessel (`BinaryKeyPolicy::derive_key`), `|fpr=`-Resume-Stamp
(`builder/experiment_tree/cache_engine_builder_iterator.hpp:1826-1841`, nur T2-A), CSV-Provenienz-Tags,
Plan-Ablage. **Keiner** davon laeuft im Mess-Fenster. Kein Konsument braucht je beide gleichzeitig.

**(c) Andere Versionierungs-Kadenz -- der teuerste Grund.** Es gibt heute **drei** unabhaengige Zaehler,
und das ist eine Errungenschaft, keine Unordnung:

| Zaehler | Wert heute | Bumpt wann | Kosten eines Bumps |
|---|---|---|---|
| `COMDARE_ANATOMY_ABI_MAJOR` | 8 (`decl:89`) | vtable-/Pflicht-Symbol-Bruch | Loader lehnt alle Alt-DLLs ab -> **Flotten-Neubau** |
| `kAnatomyVersionLinesLayout` | 6 (`decl:234`) | Stempel-POD-Feld dazu/weg | nur Leser-Gate; **kein** Loader-Ereignis (`decl:225-227` woertlich: "unabhaengig vom ABI-Major") |
| `kAnatomyFingerprintFormat` | 3 (`anatomy_fingerprint.hpp:89`) | Preimage-Glied dazu/weg/umsortiert | **jeder** Fingerprint verschiebt sich -> Flotten-Invalidierung + **drei** Frozen-Vektoren neu ankern |

Wuerde der Stempel im Observer-Interface wohnen, kollabierten Spalte 1 und 2: **jede** neue Stempel-Glied-Idee
kostete einen ABI-Major und damit einen Flotten-Neubau, und **jedes** neue Observer-Feld kostete umgekehrt eine
POD-Layout-Drehung an der Identitaets-Flaeche. Die Gesondertheit **ist** die Kadenz-Trennung.

**(d) Andere Verfuegbarkeit.** `IObservableTier` wird vom ABI-Adapter **nur bei `COMDARE_MEASUREMENT_ON`**
zusaetzlich geerbt (`anatomy/observable_tier.hpp:182-184`). Der Stempel muss auch in der funktional-only-DLL
lesbar sein -- sonst waere die Identitaet ausgerechnet dort unsichtbar, wo sie fuer den Bau-Skip gebraucht wird.

**(e) Die Stufen sind strukturell verschieden.** Planer und CEB sind **ausfuehrbare Programme**
(`apps/experiment_planner`, `apps/cache_engine_builder`), keine ladbaren Anatomie-Module: sie haben kein
`IAnatomyBase`, keine vtable ueber eine dlopen-Grenze, keinen `dynamic_cast`-Pfad. Ein vtable-Sub-Interface
kann dort per Konstruktion nicht angeboten werden. Das gesonderte Interface loest das, indem sein **Kern der
POD + der eine Renderer** ist und die vtable **nur eine** von drei Andock-Formen (Abschnitt 3.4).

---

## 2. DIE CT-NAMENSFUNKTION

### 2.1 Die Invariante, die alles traegt

> **DER NAME IST EINE FUNKTION DES FINGERPRINTS -- UND NIE EIN PREIMAGE-GLIED.**

Beides ist noetig. Waere der Name aus den Achsen-Strings **neben** dem Fingerprint gebaut, waere er genau die
Zweit-Ableitung, die der Owner ("kein zweites Ableiten") abschafft -- und er koennte driften. Waere er
umgekehrt selbst ein Preimage-Glied, waere die Rechnung zirkulaer (Name haengt am Hash haengt am Namen). Die
einzige widerspruchsfreie Anordnung ist die einseitige: **Glieder -> Preimage -> Fingerprint -> Name.**
Aus ihr folgt unmittelbar der wichtigste Migrations-Satz dieses Plans: **die Einfuehrung des Namens ist
preimage-neutral** -- kein Byte des Preimage bewegt sich, kein Frozen-Vektor faellt (Abschnitt 5, S2).

### 2.2 Wie der Name entsteht (C++23-Mittel des Bestands)

Der Bestand liefert das Muster bereits fertig -- es muss nicht erfunden, nur wiederverwendet werden. Die
Zwei-Schritt-`consteval`-Groessenrechnung steht literal im Stempel-Makro
(`abi/anatomy_module_abi_v1.hpp:154-157`): erst `complete_system_stamp_line_size(...)` als `consteval`-Laenge,
dann `complete_system_stamp_line_array<N>(...)` als fixes `char`-Array mit `.chars` / `.size()` / `.view()`.
Der Grund fuer die Zwei-Schritt-Form ist C++23-hart: ein `constexpr std::string` kann eine konstante
Auswertung nicht verlassen; ein `std::array<char, N>` kann es.

```cpp
// abi/version_stamp_name.hpp (NEU) -- Skizze, ASCII, header-only, keine Abhaengigkeit nach builder/
namespace comdare::cache_engine::abi {

/// Die Namens-GRAMMATIK. Sie steht als benannte Konstante da, damit der Selbstcheck sie zitieren kann.
///   cds<layout> "_" <stufe> "_f" <fpformat> "_a" <abimajor> "." <cebminor> "_" <hexN>
/// Beispiel: cds1_tier_f3_a8.0_17148e5a4d0f4a2d96e1f5
inline constexpr std::size_t kStampNameHexLen = 24; // OWNER-ENTSCHEID E-A (16 / 24 / 32)

template <std::size_t N>
struct StampNameArray {
    std::array<char, N + 1> chars{}; // nullterminiert -> direkt als char const* in den POD
    [[nodiscard]] constexpr std::string_view view() const noexcept { return {chars.data(), N}; }
    [[nodiscard]] constexpr std::size_t      size() const noexcept { return N; }
};

/// Schritt 1: die Laenge, consteval (exakt das complete_system_stamp_line_size-Muster).
[[nodiscard]] consteval std::size_t stamp_name_size(StampStage stufe, std::uint32_t abi_major,
                                                    std::uint32_t ceb_minor) noexcept;

/// Schritt 2: das Array, consteval. FP ist der 129-Byte-Hex aus anatomy_fingerprint_hex().
template <std::size_t N>
[[nodiscard]] consteval StampNameArray<N> stamp_name_array(StampStage stufe, std::uint32_t abi_major,
                                                           std::uint32_t ceb_minor,
                                                           std::array<char, 129> const& fp);
}
```

**Wie er IN die Binary kommt:** exakt wie der Fingerprint heute. Im Makro-Rumpf steht
`static constexpr auto kFP = ...anatomy_fingerprint_hex(...)` (`anatomy_module_abi_v1.hpp:159-160`), und
`kFP.data()` wandert als `char const*` ins POD (`:179`). Der Name kommt als
`static constexpr auto kNM = ...stamp_name_array<...>(...)` daneben. Ein `static constexpr`-Array im
Funktionsrumpf hat statische Speicherdauer -> es liegt in `.rodata` der `.so`, ist mit `strings` sichtbar und
ueber den POD-Zeiger lesbar. **Architektonisch kostet der Name damit nichts Neues** -- er benutzt denselben
Materialisierungs-Weg, der fuer den Fingerprint seit K7b-3 gruen laeuft.

**Die Wachen** (Klasse der bestehenden `assert_version_grammar<W>()`, `axis_variant_version_table.hpp:60-112`):

1. `static_assert(stamp_name_is_wellformed(kNM.view()))` -- Grammatik. Alphabet als **echte Teilmenge** von
   `anatomy_glied_zeichen_erlaubt` (`anatomy_fingerprint.hpp:139-143`) **minus `/` und `:`**, weil der Name
   dateisystem-tauglich sein muss (F7, Abschnitt 4a).
2. `static_assert(stamp_name_hex_prefix(kNM.view()) == fp_prefix(kFP, kStampNameHexLen))` -- **die
   Rueckwaerts-Bindung.** Sie ist der Beweis, dass der Name aus dem Fingerprint kommt und nicht neben ihm
   entsteht. Ohne sie waere die Zusage dieses ganzen Plans eine Absichtserklaerung (dieselbe Lehre wie NB2-2,
   `anatomy_fingerprint.hpp:189-194`).
3. Fehlerklasse bei Verletzung zur Laufzeit: `fehlerklasse=stempel_name_grammatik` (Muster
   `fehlerklasse=stempel_injektivitaet`, `anatomy_fingerprint.hpp:167-172`).

**mp11 bleibt, wo es ist.** Die Typlisten-Iteration (`mp_for_each` ueber die Enabled-Registries in
`reflect_versions<List>()`, `axis_variant_version_table.hpp:119-223`) laeuft **einmal** und erzeugt die
Achsen-Tabelle. Die Namensfunktion traversiert **nichts** davon erneut -- sie konsumiert den fertigen
Fingerprint. Das ist der ganze Anti-Drift-Punkt: eine zweite Traversierung waere eine zweite Wahrheit.

### 2.3 HARTE ANTWORT: Kann der SHA-Fingerprint selbst CT gebildet werden?

**JA -- und er wird es bereits. Die Frage ist im Bestand entschieden, nicht offen.**

Beleg, dreifach am Objekt:

1. `[[nodiscard]] consteval std::array<char,129> anatomy_fingerprint_hex(...)`
   (`t2a/.../abi/anatomy_fingerprint.hpp:584-599`) -- **`consteval`**, also **erzwungene** Compile-Zeit-Auswertung.
2. Die Primitive `sha512_bytes` ist voll `constexpr`
   (`ce/libs/cache_engine/src/sha512/ctsha512.hpp:99-144`), inklusive der drei NIST-/FIPS-180-4-Pruefvektoren
   als `static_assert` (`:197-206`) -- ein falscher Rundenkonstanten-Wert braeche bereits das Uebersetzen.
3. Der produktive Aufruf steht **innen im Stempel-Makro** (`abi/anatomy_module_abi_v1.hpp:159-160`), also in
   jeder emittierten Tier-Binary. Der emittierte Quelltext bleibt dabei byte-identisch (`anatomy_fingerprint.hpp:14-16`).

**Aufwand / Compile-Zeit-Kosten, beziffert:**

| Groesse | Wert | Quelle |
|---|---|---|
| Preimage-Puffer-Obergrenze | 4096 B = 32 SHA-512-Bloecke | `anatomy_fingerprint.hpp:57` |
| Summe der Glied-Budgets (maschinell) | 3745 B, `static_assert`-gedeckt | `:374-391` |
| Realer Preimage heute (Format 3) | ~1500 B ~ 12 Bloecke (Organ <=762 + System ~150 + Mess <200 + Werteset + Toolchain ~120 + bvset) | `:38-56` (Budget-Beleg an den Ist-Daten) |
| Rechen-Umfang je Fingerprint | 12 Bloecke x (64 Schedule-Schritte + 80 Runden) ~ 1,7e3 `constexpr`-Schritte auf `uint64` | `ctsha512.hpp:54-96` |
| Separates Funktionsrumpf-Budget | 50 KB (`kMaxFunctionBodyBytes`) -- eine Groessenordnung ueber uns | `ctsha512.hpp:164-166` |

Gegen gcc's Default `-fconstexpr-ops-limit` (3,3e7) liegt das um **vier Groessenordnungen** darunter. **Die
Kosten sind ausserdem nicht geschaetzt, sondern bereits bezahlt**: die Flotte uebersetzt heute mit genau diesem
consteval-Fingerprint gruen. Das neue Interface fuegt **null** zusaetzliche Hash-Rechnung hinzu -- es liest den
Wert, der ohnehin entsteht. (Wenn eine Zahl gewuenscht ist statt eines Arguments: ein `-ftime-report` auf der
Stempel-TU vor/nach ist ein billiges Gate, s. Abschnitt 6, G-S3.)

**Die ehrliche Einschraenkung -- und sie ist die eigentliche Antwort auf die Frage.** CT-SHA gilt genau dort,
wo die Glieder Compile-Zeit-Konstanten sind. Es gibt **zwei** Aufrufer-Familien:

| Familie | Glieder-Herkunft | Hash | Bewertung |
|---|---|---|---|
| **(A) Tier-Binary** | Literale + Compile-Defines (`COMDARE_TOOLCHAIN_STAMP_GLIED`, `COMDARE_BUILD_VARIANT_SET_SIGNATURE`, `COMDARE_SYSTEM_CELL_VALUES`) | **consteval, IST** | doktrin-konform: compile-time only |
| **(B) CEB / Planer** | erst zur CEB-**Laufzeit** bekannt (welche Permutation, welche Toolchain-Zelle, welche Enable-Menge) | **RT**, ueber `lazy_adhoc_fingerprint_for` (`profile_facade/lazy_adhoc_source_gen.hpp:358`) bzw. `BinaryKeyPolicy::derive_key` | **kein** Doktrin-Bruch, s.u. |

Familie (B) ist **keine** Ausnahme von "compile-time only", sondern die dokumentierte **dynamisch-Vorstufe ->
statisch-Folgestufe**-Bruecke: die CEB permutiert die Toolchain-Achse zur Laufzeit und friert die Wahl beim Bau
der Tier-Binary als CT-Konstante ein (`abi/toolchain_stamp_glied.hpp:19-22` woertlich, Paragraf 24.C
ACHSEN-KETTEN-STATIK). Ein consteval-Hash **kann** dort per Konstruktion nicht greifen -- die Eingabe existiert
zur Uebersetzungszeit der CEB noch nicht.

**Deshalb die saubere Trennung, die dieser Plan vorschlaegt:**

> **CT-NAME und CT-HASH an der Tier-Binary (beides consteval, beides IST bzw. neu-aber-kostenlos).
> An CEB/Planer: derselbe Hash ueber denselben `constexpr`-KERN, nur mit RT-Senke -- die
> PREIMAGE-ORDNUNG ist CT-verankert, die Arithmetik ist dieselbe Funktion.**

Das ist nicht behauptet, sondern seit NB2-2 **Mechanik**: es gibt genau **eine** Preimage-Konstruktion,
`anatomy_fingerprint_preimage_emit<Senke>` (`anatomy_fingerprint.hpp:557-564`), und die beiden Wege
unterscheiden sich **nur in der Senke** -- `PreimageBytesSenke<N>` fuer consteval, `PreimageStringSenke` fuer
RT (`:535-546`). Ordnung, Separator **und** Wache stehen physisch nur einmal da (`:511-515`). Die Gleichheit
beider Wege ist zusaetzlich testbar bewiesen: `test_w10_system_cell_values.cpp:431-441` fuehrt die
**RT**-Ableitung `BinaryKeyPolicy::derive_key(frozen)` gegen **denselben** Frozen-Hex, den der
**consteval**-Weg in `test_m_w12_stamp_bausteine.cpp:663` erzeugt.

**Fazit in einem Satz:** Der CT-SHA ist machbar, ist IST, und kostet nichts Neues; RT-Hash gibt es nur dort,
wo die Eingabe erst zur Laufzeit existiert, und dort ist er derselbe Kern mit anderer Senke -- der Name ist
**ueberall** CT ableitbar, weil er nur den Hex braucht.

### 2.4 "den Namen der Funktion ... in die binary schreibt" -- drei Lesarten, ehrlich getrennt

Der Owner-Wortlaut laesst offen, ob der Name als **Daten** oder als **Symbolname** in die Binary soll. Beides
ist machbar, mit sehr verschiedenen Kosten:

| Weg | Wie | Byte-Wirkung | Bewertung |
|---|---|---|---|
| **(i) Emitter schreibt den Namen als Makro-Argument** | Der Codegen kennt den Fingerprint bereits (RT-Zwilling) und emittiert `COMDARE_VERSION_STAMP_NAMED("cds1_tier_...")` | **bricht die Emitter-Round-Trip-Byte-Wache** (`tests/unit/test_lazy_adhoc_source_gen.cpp`) und damit potenziell den golden-CRC `0xF1C1F26A1232073B` | **NICHT empfohlen.** Teuerster Weg fuer den geringsten Zusatznutzen |
| **(ii) Name als DATEN in `.rodata`** | `static constexpr auto kNM = stamp_name_array<...>(...)` neben `kFP`, Zeiger im POD | **byte-neutral**: die Berechnung passiert innen in der Makro-Expansion, der emittierte Quelltext bleibt identisch -- exakt die K7b-3-Praezedenz (`anatomy_fingerprint.hpp:14-16`) | **EMPFOHLEN.** `strings libperm.so \| grep cds1_` beantwortet die Frage schon ohne Loader |
| **(iii) Name im SYMBOL, ohne Quelltext-Aenderung** | `template <StampName NM> extern "C++" ...` -- ein NTTP-Klassentyp (C++20) traegt die Zeichen in die **Mangelung**, also erscheint der Hex in `nm -D` | byte-neutral am Quelltext; die Mangelform ist compiler-abhaengig (Itanium vs MSVC) | **OPTIONAL**, als Zugabe zu (ii). Braucht eine demangel-tolerante Wache, sonst ist sie in der 8er-Docker-Matrix sproede |

**Empfehlung: (ii) als Kern, (iii) als spaetere Zugabe, (i) nur unter ausdruecklichem Owner-Entscheid im
F5-Golden-Fenster.** Der Grund fuer die Absage an (i) ist nicht Bequemlichkeit, sondern die
Byte-Wachen-Rechnung: (i) kostet einen golden-CRC-Neuanker fuer eine Information, die (ii) fuer null Bytes liefert.

---

## 3. INTERFACE-ENTWURF (nach dem I1-Muster)

Vorbild ist die **I1-Observer-Konsolidierung** (`docs/architecture/31_observer_interface_konsolidierung_i1.md`,
Kopf in `anatomy/observable_tier.hpp:13-19`): **GENAU EINE** Schnittstelle, **EIN** versionierter POD, flach und
`memcpy`-faehig, Versionierung ueber **einen** Zaehler, Abfrage **1x kalt** je Modul, fehlend -> `nullptr` ->
sauberer Degrade. Dieser Entwurf uebernimmt jeden dieser fuenf Punkte und ergaenzt genau eine Sache, die I1
nicht brauchte: **drei Andock-Formen ueber denselben POD**, weil Planer und CEB keine Module sind (1.3e).

### 3.1 Der eine POD

```cpp
// abi/version_stamp_interface.hpp (NEU) -- ASCII, header-only, abi/-Schicht (zieht NIE builder/ oder profile_facade/)

/// Die Achsen-KATEGORIE eines Glieds. Reines Datenfeld -- KEIN Dispatch-Diskriminant.
/// Die Werte sind die benannten Preimage-Positionen aus anatomy_fingerprint.hpp:427-438.
enum class StampGliedKategorie : std::uint32_t {
    format = 0, organ = 1, system = 2, mess = 3, werteset = 4, toolchain = 5, bvset = 6, overlay = 7
};

/// EIN Preimage-Glied als ABI-stabiler POD. {ptr,len}-Sichten INS Literal (D2-Doktrin: eine Laenge,
/// kein '\0'-Vertrauen) -- exakt die AnatomyStampEntryV1-Form (anatomy_module_abi_v1_decl.hpp:158-167).
struct ComdareStampGlied {
    char const*   schluessel;      ///< benannte Kategorie als Text ("organ", "toolchain", ...)
    std::uint64_t schluessel_len;
    char const*   wert;            ///< der Glied-Wert, byte-identisch zu dem, der ins Preimage ging
    std::uint64_t wert_len;
    std::uint32_t kategorie;       ///< StampGliedKategorie
    std::uint32_t reserved;        ///< 0
};
static_assert(sizeof(ComdareStampGlied) == 40);   // Pin, s. Versionierungs-Regel
static_assert(alignof(ComdareStampGlied) == 8);
static_assert(std::is_standard_layout_v<ComdareStampGlied>);
static_assert(std::is_trivially_copyable_v<ComdareStampGlied>);

/// Die Stufe. DATENFELD, nicht Dispatch (Doktrin: kein RT-Switch auf Haupt-Achsen).
enum class StampStage : std::uint32_t { planer = 0, ceb = 1, tier = 2, hybrid = 3 };

/// ComdareVersionStampSnapshot -- DER EINE versionierte Stempel-POD des Versionierungs-Interfaces.
/// Er traegt DAS PREIMAGE (in Preimage-Ordnung, kategorie-benannt) + DEN FINGERPRINT + DEN CT-NAMEN.
struct ComdareVersionStampSnapshot {
    std::uint32_t stamp_layout_version;  ///< == kComdareVersionStampLayout (GLEICHHEITS-Wache, s. 3.3)
    std::uint32_t stage_kind;            ///< StampStage
    std::uint32_t fingerprint_format;    ///< 3 (aus kAnatomyFingerprintFormat)
    std::uint32_t abi_major;             ///< COMDARE_ANATOMY_ABI_MAJOR
    std::uint32_t ceb_contract_minor;    ///< kCebContractCodegenMinor
    std::uint32_t glieder_count;         ///< == kAnatomyFingerprintGliedCount (8)
    char const*   name;                  ///< der CT-Rekombinations-Name (nullterminiert)
    std::uint64_t name_len;
    char const*   fingerprint;           ///< 128-hex SHA-512 (nullterminiert)
    std::uint64_t fingerprint_len;       ///< immer 128
    ComdareStampGlied const* glieder;    ///< die Glied-Folge IN PREIMAGE-ORDNUNG; nie nullptr (Sentinel-Doktrin)
    std::uint64_t            glieder_len;
};
static_assert(sizeof(ComdareVersionStampSnapshot) == 72);  // 6x uint32 + 2x{ptr,u64} + {ptr,u64} + {ptr,u64}
static_assert(alignof(ComdareVersionStampSnapshot) == 8);
static_assert(std::is_standard_layout_v<ComdareVersionStampSnapshot>);
static_assert(std::is_trivially_copyable_v<ComdareVersionStampSnapshot>);

inline constexpr std::uint32_t kComdareVersionStampLayout = 1;
```

*(Die beiden `sizeof`-Pins sind gerechnet, nicht gemessen -- sie sind als **Gate** formuliert: bricht der Wert
beim ersten Bau, wird er dort einmal bewusst gesetzt, wie bei `AnatomyVersionLines` `sizeof==120`
(`anatomy_module_abi_v1_decl.hpp:241-243`).)*

**Warum der POD das Preimage MITTRAEGT statt nur den Hash:** damit der Stempel **selbstpruefend** ist. Wer
den POD hat, kann den Fingerprint nachrechnen (`verify_version_stamp`, 3.5) -- die Frage "welche Version steckt
in dieser Binary" wird damit nicht nur beantwortet, sondern **beweisbar** beantwortet. Ein POD, der nur 128 Hex
traegt, waere eine Behauptung.

### 3.2 Die eine Fuell-Funktion (die Anti-Drift-Naht)

```cpp
/// DIE EINE Fuellung. Sie zieht ihre Glieder aus anatomy_fingerprint_glieder() -- also aus DERSELBEN
/// einen Ordnungs-Quelle (anatomy_fingerprint.hpp:462-472), aus der auch der Hash entsteht.
/// KEIN Aufrufer darf die Glieder selbst zusammenstellen; genau das waere die Zweit-Ableitung.
[[nodiscard]] constexpr ComdareVersionStampSnapshot
make_version_stamp(StampStage stufe,
                   std::span<std::string_view const> glieder,   // aus anatomy_fingerprint_glieder(...)
                   std::string_view fingerprint_hex,
                   std::string_view ct_name,
                   std::span<ComdareStampGlied const> glied_pods) noexcept;
```

Und die Bindung, die die Owner-Zusage "**alle** Achsen-Kategorien" erstmals **maschinell** macht -- heute ist
sie nur ein Absatz:

```cpp
// Beweis, nicht Kommentar: der POD traegt GENAU die Preimage-Glieder, in GENAU der Preimage-Ordnung.
static_assert(kStampKategorieAtPosition[kAnatomyFingerprintSystemGlied]    == StampGliedKategorie::system);
static_assert(kStampKategorieAtPosition[kAnatomyFingerprintToolchainGlied] == StampGliedKategorie::toolchain);
static_assert(kStampKategorieAtPosition[kAnatomyFingerprintBvsetGlied]     == StampGliedKategorie::bvset);
static_assert(kStampKategorieAtPosition[kAnatomyFingerprintOverlayGlied]   == StampGliedKategorie::overlay);
static_assert(kStampKategorieCount == kAnatomyFingerprintGliedCount);
// Und die drei Owner-Kategorien sind einzeln bezeugt -- eine fehlende waere ab hier compile-hart:
static_assert(hat_kategorie(StampGliedKategorie::organ));
static_assert(hat_kategorie(StampGliedKategorie::system));
static_assert(hat_kategorie(StampGliedKategorie::mess));
```

Das ist der einzige Ort im ganzen Entwurf, an dem echte **neue** Zusicherung entsteht: die
Vollstaendigkeits-Aussage wird von Prosa zu `static_assert`. Sie ist die Antwort auf den A2-Nachreview-Befund
C1 in Dauerform -- eine kuenftig **fehlende** Kategorie braeche den Bau, statt still eine Blindstelle zu lassen.

### 3.3 Versionierungs-Regel -- drei Knoepfe, sauber getrennt

| Aenderung | Knopf | Kosten | Owner-Entscheid? |
|---|---|---|---|
| **Feld an den POD anhaengen** | `kComdareVersionStampLayout` +1, Gleichheits-Wache nachziehen | Leser mit altem Layout degradieren sauber; kein Loader-Ereignis | nein |
| **Feld aus dem POD ENTFERNEN / umsortieren** | dito, aber **Gleichheits**-Wache ist Pflicht | siehe K-4-Lehre: `>=` waere ab dem ersten Entfall falsch (`anatomy_module_abi_v1_decl.hpp:246-255`) | nein |
| **Neues PREIMAGE-Glied** | `kAnatomyFingerprintFormat` 3->4 | **jeder** Fingerprint verschiebt sich, drei Frozen-Vektoren neu ankern, Flotten-Invalidierung | **JA** |
| **vtable / Pflicht-Symbol am Tier** | `COMDARE_ANATOMY_ABI_MAJOR` | Loader lehnt alle Alt-DLLs ab | **JA** |
| **CEB-universelle Codegen-Quelle** | `kCebContractCodegenMinor` | `+ceb=`-Shift -> alle `.version` mismatchen -> Neubau + neuer Objekt-Store-Bucket | **JA** (M4-/W10-M2-/E-24-C8-Praezedenz) |

**Die Gleichheits-Wache ist Pflicht ab Tag eins**, nicht erst beim ersten Entfall:

```cpp
[[nodiscard]] constexpr bool version_stamp_layout_ok(ComdareVersionStampSnapshot const& v) noexcept {
    return v.stamp_layout_version == kComdareVersionStampLayout;  // GLEICHHEIT, nie >=
}
// CT-Negativ-Probe wie anatomy_module_abi_v1_decl.hpp:265-274: Layout 0 und Layout 2 MUESSEN false liefern.
```

### 3.4 Abfrage-Muster je Stufe

**Tier-Binary (.so/.dll) -- das optionale 6. Symbol, KEIN ABI-Major-Bump:**

```cpp
extern "C" COMDARE_ANATOMY_ABI_EXPORT
::comdare::cache_engine::abi::ComdareVersionStampSnapshot const* comdare_version_stamp() noexcept;
```
Der Loader verlangt weiter nur die **vier** Pflicht-Symbole (`anatomy_module_abi_v1_decl.hpp:119-137`); ein
Modul ohne Stempel-Makro exportiert das Symbol schlicht nicht -> `dlsym` liefert `nullptr` -> **honest-empty**,
kein Fehler. Abfrage **1x kalt je Modul** beim Laden, nie im Hot-Loop -- dieselbe Regel wie der
`dynamic_cast<IObservableTier*>` (`anatomy/observable_tier.hpp:24-25`).

**CEB / Planer (Programme) -- zwei Formen desselben POD:**
- prozess-intern: `constexpr` Accessor `ceb_version_stamp_pod()` / `planner_version_stamp_pod()`;
- prozess-extern: Subkommando `version-stamp` neben dem bestehenden `version`
  (`apps/experiment_planner/main.cpp:23-24,261-263`), das den POD in **derselben** Zeilenform rendert.
  Der CEB-Log-Kopf (`apps/cache_engine_builder/main.cpp:161`) wird von einem eigenen Renderer zur
  **Ausgabe des POD**.

**Hybrid:** kein `dlopen`, kein `dynamic_cast` -- der in-process komponierte Tier liefert denselben POD ueber
den `constexpr`-Accessor. **Kein `std::variant`**: die Hybrid-Ausnahme (Owner-KERN "Hybrid-Tier HINTER CEB;
variant NUR dort") wird hier **nicht** gebraucht, weil der POD flach ist und die Stufe ein `uint32`-Datenfeld.

**Doktrin-Nachweis, Punkt fuer Punkt:**

| Doktrin | Erfuellung |
|---|---|
| kein `std::variant` ausser Hybrid | POD ist flach; `stage_kind` ist `uint32`-DATEN |
| kein RT-Switch auf Haupt-Achsen | die Achsen erscheinen als **Text-Glieder**, nie als Dispatch-Diskriminante. Die einzige Leser-Verzweigung ist auf `stage_kind` -- eine **Diagnose**-Verzweigung auf ein Datenfeld, keine Achsen-Wahl |
| ABI-stabil an jedem Dock | nur `uint32`/`uint64`/`char const*`, `standard_layout` + `trivially_copyable`, `sizeof`/`alignof` gepinnt, `memcpy`-faehig |
| statischer Dispatch / CT | Fuellung `constexpr`; am Tier `consteval` materialisiert |
| Fehlerklassen-Pflicht | `stempel_name_grammatik`, `stempel_pod_layout`, `stempel_selbstpruefung` (+ bestehende `stempel_injektivitaet`) |
| Layer-Vertrag | Header wohnt in `abi/` und zieht **nie** `builder/` oder `profile_facade/` -- die Werte werden **injiziert** (K-1-Muster, `anatomy_fingerprint.hpp:281-285`) |

### 3.5 Die Selbstpruefung

```cpp
/// Rechnet den Fingerprint AUS DEM POD nach und vergleicht ihn mit dem POD-Feld; prueft zusaetzlich,
/// dass der Name der Hex-Praefix-Funktion des Fingerprints entspricht. Zwei Gleichheiten, ein Verdikt.
[[nodiscard]] bool verify_version_stamp(ComdareVersionStampSnapshot const& v);
```
Sie benutzt den **RT-Zweig desselben Kerns** (`anatomy_fingerprint_preimage` -> `sha512::sha512`) und ist damit
kein vierter Ableitungsweg, sondern die Gegenprobe. Sie ist die praezise Antwort auf 4c: nicht nur "welche
Version steckt drin", sondern "und der Stempel stimmt mit sich selbst ueberein".

---

## 4. WAS DAS INTERFACE LOEST

### 4a. F7 -- die Plan-Ablage bekommt ihren Namen driftfrei

**Heute:** `batch_plan_datei` ist ein Pass-**unabhaengiger** Pfad (`profile_facade/profile_run_facade.hpp:128`
-> `profile_run_entry.hpp:182,659` -> `builder/experiment_tree/cache_engine_builder_iterator.hpp:243,1122,2266`).
Bis zu 156 Ueberschreibungen je Lauf sind moeglich; die Owner-Vorlage nannte das als Option 1 (bis Abgabe) mit
Option 2 "Stempel-abgeleiteter Name im Iterator" als Zielbild. Owner hat **F7 = Option b** entschieden und den
Namen ausdruecklich "als Ausfluss des neuen Interfaces" gebunden (Ledger `:4243`).

**Danach:** `batch_plan_datei = <wurzel> / ("plan_" + stamp_name() + ".txt")`. Der Name kommt aus dem POD der
**CEB-Stufe** -- also aus derselben Quelle, die auch das Skip-Gate und den `|fpr=`-Resume-Stamp speist. Damit:
- 156 Ueberschreibungen werden 156 **unterscheidbare** Dateien, ohne dass jemand eine Pass-Nummer erfindet;
- der Resume findet **seinen** Plan, nicht irgendeinen (`:2266-2275`);
- die Namens-Bildung ist **keine** neue Konvention, sondern ein Lesen -- also nichts, was driften kann.

**Reihenfolge-Auflage:** dieser Schritt kommt **nach** den zwei offenen T2-A-Befunden (Zaehler bindet nicht
eindeutig an die Indexfolge; fester `.tmp`-Name ist nicht Multi-Writer-sicher, Ledger-Nachtrag mittag-13 C).
Ein Namens-Umbau auf beweglichem Boden waere die teuerste Reihenfolge.

### 4b. Die gefundenen ZWEIT-Ableitungen -- was faellt und was bleibt

| Zweit-Ableitung (aus der Erhebung) | Datei:Zeile | Wird geloest? |
|---|---|---|
| `perm_suffix`-Renderer **vs** Toolchain-Glied [5] -- zwei physische Renderer ueber dieselben Rohwerte, gekoppelt nur durch einen `static_assert` auf Feld-Reihenfolge | `profile_facade/system_version_suffix.hpp` (`kSuffixSegmentOrder`) vs `abi/toolchain_stamp_glied.hpp:25-30` | **JA, aber erst in S7** -- und nur, weil der Ordner-/CSV-Name dann aus dem POD-Namen kommt. Der Suffix bleibt als reine Legende bestehen (nie loeschen, nur deprecaten) |
| `ceb_version_stamp()` als **dritter** Ableitungsweg der Mess-Zeile -- genau die O-8-Schritt-12-Drift, die schon einmal zugeschlagen hat | `builder/ceb_version_stamp.hpp:7-13` (der Header dokumentiert seinen eigenen Sturz) | **JA, in S4** -- er wird zur Ausgabe-Form des POD |
| `planner_version_stamp()` -- eigene Stempel-Welt ohne Achsen-Kategorien und ohne Fingerprint | `profile_facade/planner/planner_version.hpp:56-66` | **JA, in S4** -- gleiche POD-Form, ehrliche Leer-Glieder |
| `.algos` / `.version` / `.variant`-Sidecars als je eigene Komposition | `builder/build_orchestrator/build_orchestrator.hpp:222,228,235`; `axis_variant_version_table.hpp:259-285` | **JA, in S6** -- Renderings des POD statt eigener Rechnungen. Sie sind seit der A2-Eichung ohnehin reine Provenienz (Skip haengt nur an `.fingerprint`, `:293-299`) |
| CSV-Provenienz-Tags `perm_build_version` / `perm_tag_build_version` | `profile_run_entry.hpp:931-932`, `experiment_run_entry.hpp:327-328` | **JA, in S7** (haengt an derselben Suffix-Kette) |
| `\|fpr=`-Resume-Stamp | `cache_engine_builder_iterator.hpp:1826-1841` (nur T2-A) | **schon einzeln geloest**; das Interface macht es **strukturell** und heilt nebenbei die L1-Auflage "Provider EINMAL lesen" -- der POD **ist** die eine Lesung |
| `serialize_composition_path<P>()` **vs** `serialize_composition_from_slots<C>()` | `builder/experiment_tree/axis_path_serialization.hpp:56-92` | **NEIN -- und bewusst nicht.** Siehe 4d |

### 4c. "Welche Version steckt in dieser Binary?" -- an jeder Stufe beantwortbar

Vier Wege, je nach dem, was der Fragende zur Hand hat:

1. **Ohne alles:** `strings libperm_<id>.so | grep '^cds1_'` -- der CT-Name liegt in `.rodata`.
2. **Mit `nm`:** das Symbol `comdare_version_stamp` ist da oder nicht (und mit Variante (iii) steht der Hex in
   der Mangelung).
3. **Mit Loader:** `dlsym` -> POD -> Name, Fingerprint, **und alle acht Glieder benannt nach Achsen-Kategorie**.
4. **Als Programm:** `comdare_experiment_planner version-stamp`, `cache_engine_builder`-Log-Kopf.
5. **Beweisend:** `verify_version_stamp(pod)` -- Fingerprint aus dem POD nachgerechnet.

### 4d. Was es NICHT loest (ehrlich)

- **Die `binary_id` bleibt unberuehrt -- und muss es.** `serialize_composition_path` / `_from_slots`
  (`axis_path_serialization.hpp:56-92`) sind zwei Codepfade, die per Design round-trip-gleich sein muessen.
  Sie speisen golden-320 und den CRC-Anker `0xF1C1F26A1232073B`. Der Stempel-Name ist ein **zweiter,
  zusaetzlicher** Griff, **kein Ersatz** der `binary_id`. Wer beides fusionieren wollte, zahlte golden-320 +
  CRC + jede Mess-Archiv-Grammatik. **Nicht in diesem Plan.**
- **Der `organ_stamp_line<Comp>()`-BLOCKER bleibt.** Die realen AdHocComposition-Achsen-Typen tragen kein
  `name()`/`algo_version` -- nur die Registry-Wrapper (`abi/anatomy_version_stamp.hpp:75-80`, der Header
  benennt es selbst). Das Interface **erbt** den heutigen Emitter-Weg ueber `compose_organ_stamp_line`; es
  heilt die Metadaten-Frage nicht.
- **Das Overlay-Glied bleibt leer.** Der Codegen fuer den Overlay-Source-Hash existiert nicht
  (`anatomy_fingerprint.hpp:99-107`, OF-M3-2 = Fallback B). Das Interface traegt den Slot, nicht den Inhalt.
- **F8 (Determinismus) wird nicht beruehrt.** Der Fingerprint ist die Identitaet der **Bau-Eingabe**, nicht der
  erzeugten Bytes. Waere ein Bau nicht-deterministisch, waere der Stempel weiterhin korrekt und die
  Messwert-Uebertragbarkeit trotzdem fraglich -- ein Determinismus-Posten, kein Stempel-Posten.
- **Keine Bau-Zeit-Ersparnis, keine Aenderung der Skip-Semantik.** `.fingerprint` bleibt das einzige
  Skip-Kriterium.
- **Kein Ersatz fuer `AnatomyVersionLines`.** Der alte POD bleibt (Doku-/Code-Doktrin: deprecaten, nie
  beilaeufig loeschen). Ihn zu **erweitern** statt danebenzustellen waere teurer: Layout 6->7 und die
  K-4-Gleichheits-Wache wuerde **jedes** existierende Modul ablehnen -- ein Flotten-Ereignis ohne Gegenwert.

---

## 5. MIGRATIONS-DAG

Legende: **[PN]** = preimage-neutral (kein Byte des Preimage bewegt sich, kein Frozen-Vektor faellt).
**[BE]** = Byte-Ereignis ausserhalb des Preimage (Sidecar/Log/Ordner). **[FP]** = Fingerprint-Ereignis ->
**OWNER-ENTSCHEID** + Neu-Ankern.

```
S0  T2-A landen (Format 3, 8 Glieder)                       [PN]  <- VORBEDINGUNG
     |
S1  abi/version_stamp_interface.hpp: POD + Kategorie-Bindung [PN]  <- KLEINSTER ERSTER SCHRITT
     |
S2  abi/version_stamp_name.hpp: CT-Namensfunktion + Wachen   [PN]
     |
     +--> S3  Tier-Dock: 6. extern "C"-Symbol, INNEN im Makro [PN]
     |          |
     +--> S4  CEB-/Planer-Dock: Renderer werden POD-Ausgaben  [PN] (Text byte-identisch halten!)
                |
                +--> S5  F7: batch_plan_datei aus stamp_name()    [PN]
                |
                +--> S6  Sidecars .version/.algos/.variant aus POD [BE]  -> OWNER-ENTSCHEID E-C
                |
                +--> S7  perm_suffix / Ordner / CSV aus dem Namen  [BE, ARCHIV-GRAMMATIK] -> E-D, F5-Fenster
                |
                +--> S8  Overlay-Glied scharfschalten             [FP]  -> E-E (optional, nicht gefordert)
                |
                +--> S9  CT-Name auch im SYMBOL                    (ii/iii [PN]; i [FP+CRC]) -> E-B
```

### S0 -- T2-A landen. **[PN]** *Vorbedingung, kein eigener Schritt dieses Plans.*
Die Owner-Direktive nennt woertlich "Format 3, 8 Glieder, Frozen-Vektor" (Ledger `:4244`) -- das ist der
**T2-A**-Stand, nicht `development`. Ein Interface, das nur gegen `3bbcb8ed` (Format 2, 6 Glieder) baut,
verfehlte die vom Owner selbst zitierte Grundlage. Der Anker `17148e5a...` ist **innerhalb** von T2-A schon
zweimal bewusst gedreht worden (O-2/C-2, dann NB/CX-4 END-Form); die Landung selbst dreht ihn **nicht**.

### S1 -- Der POD und die Kategorie-Bindung. **[PN]**
Neuer Header `libs/cache_engine/include/cache_engine/abi/version_stamp_interface.hpp`. **Kein** Konsument,
**kein** Dock, **kein** Name. Enthaelt: die beiden PODs, `kComdareVersionStampLayout = 1`, die
Gleichheits-Wache samt CT-Negativ-Proben, `make_version_stamp`, und die `static_assert`-Kette aus 3.2, die die
Owner-Zusage "alle Achsen-Kategorien" erstmals maschinell macht.
*Beruehrt kein Preimage, keine `binary_id`, keinen Sidecar, kein Symbol.*

### S2 -- Die CT-Namensfunktion. **[PN]**
Neuer Header `abi/version_stamp_name.hpp` nach dem Zwei-Schritt-`consteval`-Muster (2.2). Die
Rueckwaerts-Bindung (`static_assert` Name-Hex == Fingerprint-Praefix) ist Teil dieses Schritts, nicht spaeter.
**Preimage-neutral per Invariante** (2.1): der Name ist Funktion des Fingerprints und geht nie ins Preimage.

### S3 -- Tier-Dock. **[PN]**
Das optionale 6. `extern "C"`-Symbol, gefuellt **innen** in der Expansion von
`COMDARE_ANATOMY_VERSION_STAMP_M` (`abi/anatomy_module_abi_v1.hpp:150-188`) aus **denselben** Literalen.
**Kritische Auflage:** die Makro-**Aritaet** darf sich nicht aendern -- der Emitter emittiert weiterhin
byte-identisch `COMDARE_ANATOMY_VERSION_STAMP(...)` / `..._M(...)`
(`builder/codegen/adhoc_emitter.hpp:114,121`; `profile_facade/sota_catalog.hpp:172,248`). Das ist exakt die
K7b-3-Praezedenz, die den golden-CRC schon einmal unberuehrt gelassen hat (`anatomy_fingerprint.hpp:14-16`).
`AnatomyVersionLines` bleibt unveraendert, Layout **6**.

### S4 -- CEB-/Planer-Dock. **[PN]**
`ceb_version_stamp()` und `planner_version_stamp()` werden **Renderer des POD**. **Auflage: die gerenderte
Textform bleibt in diesem Schritt byte-identisch** -- reine Umverdrahtung. Grund: der Drift-Guard
`A5CebVersionStamp... ("EINE Wahrheit")` in `test_m_w12_stamp_bausteine.cpp` ist die Wache, die den O-8-Schritt-12-
Fehler **gefunden** hat; er darf beim Umbau weder rot werden noch abgeschwaecht werden.
`kCebFingerprint` bleibt damit unveraendert.

### S5 -- F7: Plan-Ablage aus dem Namen. **[PN]**
Siehe 4a. **Nach** den zwei offenen T2-A-Befunden.

### S6 -- Sidecars aus dem POD. **[BE]** -> **OWNER-ENTSCHEID E-C**
`.version` / `.algos` / `.variant` werden Renderings. Selbst wenn die Bytes gleich bleiben sollen: sobald
**eine** Zeichenkette wandert, mismatcht `dll_is_current` -- also **Neubau der Flotte** und, falls
`+ceb=` mitgeht, ein **neuer Objekt-Store-Bucket**. Das ist eine deklarierte, einmalige Invalidierung nach der
M4-/W10-M2-/E-24-C8-Praezedenz (`anatomy_module_abi_v1_decl.hpp:340-412`) und braucht deshalb einen Entscheid,
kein Bau-Urteil. **Preimage bleibt unberuehrt** -- Sidecars sind seit A2 reine Provenienz.

### S7 -- `perm_suffix` / Ordner / CSV aus dem Namen. **[BE, ARCHIV-GRAMMATIK]** -> **OWNER-ENTSCHEID E-D**
Der teuerste Schritt, und der einzige, der **Messdaten-Vergleichbarkeit** beruehrt: Ordnernamen und
CSV-Provenienz-Spalten wandern. Das ist strukturgleich zu dem Bruch, den das F5-Fenster bereits als TABU-6
fuehrt ("neue Laeufe tragen ein zusaetzliches Segment, **kein Zeilen-Join alt-gegen-neu ueber die rohe
binary_id mehr**", `docs/plaene/20260806-PLAN-golden-update-fenster.md`, Abschnitt 0). **Auflage aus der
Messdaten-Doktrin** (Messdaten nie loeschen): fuer eine Uebergangszeit tragen die CSV **beide** Spalten --
den alten `perm_build_version`-Suffix **und** den neuen `stamp_name` -- damit Alt-Laeufe joinbar bleiben.
**Gehoert in das F5-Golden-Fenster**, nicht davor.

### S8 -- Overlay-Glied scharfschalten. **[FP]** -> **OWNER-ENTSCHEID E-E**
Fuellt Glied [7] -> **jeder** Fingerprint verschiebt sich -> **alle drei** Frozen-Vektoren neu ankern
(`test_m_w12_stamp_bausteine.cpp:663`, `test_g3_sha512_index.cpp:68`, `test_w10_system_cell_values.cpp:432`)
-> Flotten-Invalidierung. **Von der Owner-Direktive nicht gefordert**; hier nur der Vollstaendigkeit halber und
mit der klaren Empfehlung, ihn **nicht** im selben Fenster wie S1-S5 zu fahren -- ein Fenster, ein Anker.

### S9 -- Der Name auch im Symbol. -> **OWNER-ENTSCHEID E-B**
Variante (ii) ist bereits mit S3 erledigt (Daten in `.rodata`). Variante (iii) (NTTP-Mangelung) ist **[PN]**
und billig. Variante (i) (Emitter schreibt den Namen in den Quelltext) ist **[FP + CRC]** und wird
**abgeraten** (2.4).

### 5.1 TABU-/BYTE-WACHEN -- exakte Beruehrungs-Matrix

| Wache | Fundstelle | Beruehrt von | Nicht beruehrt von |
|---|---|---|---|
| **golden-320** `golden_fullpilot_320_binary_ids.txt` (+`_abi4/5/6`) | `tests/unit/thesis_tiere/` | nur S9(i); mittelbar S7 (Archiv-Join, nicht die Datei) | S0-S6, S8, S9(ii/iii) |
| **golden-CRC** `kNewGolden131072Crc64 = 0xF1C1F26A1232073B` | `profile_facade/source_catalog.hpp:183-187` | nur S9(i) | alle uebrigen |
| **Emitter-Round-Trip-Byte-Wache** | `tests/unit/test_lazy_adhoc_source_gen.cpp` | nur S9(i) | S3 **sofern** die Makro-Aritaet unveraendert bleibt |
| **Frozen-Fingerprint `17148e5a...`** (DREI Stellen) | `test_m_w12_stamp_bausteine.cpp:663`, `test_g3_sha512_index.cpp:68`, `test_w10_system_cell_values.cpp:432` | nur S8 (und jede kuenftige Preimage-Aenderung) | S1-S7, S9(ii/iii) |
| **`kAnatomyVersionLinesLayout == 6`** + `stamp_pod_has_entries` | `abi/anatomy_module_abi_v1_decl.hpp:234,253-274` | **niemand** -- der neue POD steht **daneben**, nicht drin (bewusst, s. 4d) | alle |
| **ABI-Major 8 / Magic `COMDA.A8.`** | `abi/anatomy_module_abi_v1_decl.hpp:89,93` | **niemand** -- das neue Symbol ist optional, keine Loader-Pflicht | alle |
| **CEB-Drift-Guard `A5CebVersionStamp` ("EINE Wahrheit")** | `test_m_w12_stamp_bausteine.cpp` | S4 -- **muss gruen bleiben, unveraendert** | alle uebrigen |
| **Budget-`static_assert` `kAnatomyFingerprintBudgetSum`** | `anatomy_fingerprint.hpp:383-391` | S8 | alle uebrigen |

**Der eine Satz, auf den es ankommt:** **S1 bis S5 sind saemtlich preimage-neutral.** Der komplette Kern der
Owner-Direktive -- gesondertes Interface, CT-Namensfunktion, Angebot an allen drei Stufen, F7 geloest -- laesst
sich bauen, **ohne** dass ein einziger Frozen-Vektor faellt und **ohne** dass die Flotte invalidiert wird. Erst
S6/S7 kosten Bytes (ausserhalb des Preimage) und erst S8 kostet den Fingerprint. Diese Trennung ist der
wichtigste Entwurfs-Ertrag dieses Dokuments.

### 5.2 OWNER-ENTSCHEID-VORLAGEN

| Id | Frage | Optionen | Empfehlung |
|---|---|---|---|
| **E-A** | Wie viele Hex-Zeichen traegt der Name? | (a) 16 = 64 bit; (b) **24 = 96 bit**; (c) 32 = 128 bit | **(b)**. Bei 2^17 Binaries liegt die Geburtstags-Kollisionswahrscheinlichkeit bei 96 bit jenseits jeder praktischen Relevanz; 24 Zeichen halten den Dateinamen kurz. Der **volle** 128-Hex bleibt im POD |
| **E-B** | Soll der Name auch im **Symbol** stehen? | (i) Emitter schreibt ihn (bricht golden-CRC); (ii) nur `.rodata`; (iii) NTTP-Mangelung | **(ii) + spaeter (iii)**. (i) kostet einen CRC-Neuanker fuer Null-Zusatznutzen |
| **E-C** | Duerfen die drei Provenienz-Sidecars auf den POD gezogen werden, mit einmaliger Bucket-Invalidierung? | (a) ja, im selben Fenster; (b) ja, aber getrennt; (c) nein, Sidecars bleiben wie sie sind | **(b)** -- ein Fenster, ein Invalidierungs-Ereignis |
| **E-D** | Duerfen Ordnernamen/CSV-Spalten auf den Stempel-Namen umgestellt werden? | (a) ja, mit Doppel-Spalte in der Uebergangszeit; (b) ja, hart; (c) nein | **(a)**, und ausschliesslich **im F5-Fenster** -- die Messdaten-Doktrin verlangt die Joinbarkeit der Alt-Laeufe |
| **E-E** | Overlay-Glied jetzt scharfschalten? | (a) ja; (b) nein, spaeteres eigenes Fenster | **(b)** -- er ist von der Direktive nicht gefordert und kostet den Anker |
| **E-F** | Traegt die **Planer**-Stufe leere Achsen-Kategorie-Glieder (honest-empty), oder ein eigenes, kuerzeres Glieder-Set? | (a) **honest-empty**, gleiche 8 Positionen; (b) eigenes Set | **(a)** -- ein POD-Layout fuer alle Stufen; leer heisst leer, nicht "anders" |

---

## 6. GATES JE SCHRITT (literal, uebernehmbar in Wellen-Auftraege)

> Formulierung so, dass sie in einen Wellen-Auftrag kopiert werden kann. **Kein Haken ohne literale Ausgabe.**

**G-S0 (T2-A-Landung)**
- "`git -C <ce> log --oneline -1` zeigt den Merge-Commit; `grep -n 'kAnatomyFingerprintGliedCount =' <ce>/libs/cache_engine/include/cache_engine/abi/anatomy_fingerprint.hpp` liefert literal `8`."
- "`ctest` der ce-Unit-Suite: 0 Fehlschlaege, Zahl der Tests literal ausgewiesen; die drei Frozen-Stellen tragen literal `17148e5a`."
- **STOPP:** T2-A nicht gelandet -> **kein** Schritt dieses Plans beginnt.

**G-S1 (POD)**
- "`g++ -std=c++23 -fsyntax-only` auf einer TU, die nur `abi/version_stamp_interface.hpp` inkludiert: RC=0, literal ausgewiesen."
- "Die `static_assert`-Kette 3.2 ist im Header vorhanden und wird durch eine **Negativ-Probe** belegt: eine absichtlich falsche Kategorie-Position bricht den Bau **mit Namensnennung** (Fehlertext literal zeigen)."
- "`sizeof`-Pins stehen als `static_assert` und sind **am Objekt** bestaetigt (Compiler-Ausgabe im Fehlerfall zitieren, sonst gruen literal)."
- "ASCII-Selbstcheck aus dem Diff: 0 Nicht-ASCII-Zeichen. TABU-Scan: 0."
- **STOPP:** ein `static_assert` musste abgeschwaecht werden, um gruen zu werden -> abbrechen und melden.

**G-S2 (CT-Name)**
- "Die Rueckwaerts-Bindung `stamp_name_hex_prefix(name) == fp_prefix(fingerprint)` steht als `static_assert` **und** wird durch eine Negativ-Probe belegt (manipuliertes Namens-Literal -> Bau bricht, Text literal)."
- "Der Name ist **kein** Preimage-Glied: `grep -n 'kStampName\|stamp_name' <ce>/libs/cache_engine/include/cache_engine/abi/anatomy_fingerprint.hpp` liefert **0 Treffer**."
- "Frozen-Vektoren unveraendert: die drei Stellen tragen weiterhin literal `17148e5a...` (Ausgabe zeigen)."
- **STOPP:** ein Frozen-Vektor bewegt sich -> sofort abbrechen, das darf in S2 nicht passieren.

**G-S3 (Tier-Dock)**
- "Der emittierte Quelltext ist byte-identisch: die Emitter-Round-Trip-Byte-Wache (`test_lazy_adhoc_source_gen`) ist gruen, Ausgabe literal."
- "`kNewGolden131072Crc64` unveraendert; golden-320-Dateien unveraendert (`git status --short` zeigt sie **nicht**)."
- "Ein gebautes Referenz-Modul exportiert das Symbol: `nm -D <modul>.so | grep comdare_version_stamp` liefert eine Zeile (literal)."
- "Ein **ohne** Stempel-Makro gebautes Modul liefert `dlsym == nullptr` und der Host degradiert sauber (honest-empty), Log-Zeile literal."
- "Optional, falls eine Compile-Zeit-Zahl gewuenscht: `-ftime-report` auf der Stempel-TU vor/nach, beide Zahlen literal."
- **STOPP:** die Makro-Aritaet muesste sich aendern -> abbrechen; das waere ein golden-Ereignis und braucht E-B.

**G-S4 (CEB-/Planer-Dock)**
- "Der CEB-Drift-Guard `A5CebVersionStamp` ist **gruen und unveraendert** (Diff des Test-Files: 0 Zeilen)."
- "`ceb_version_stamp()` liefert **byte-identischen** Text wie vor dem Umbau (beide Ausgaben literal nebeneinander)."
- "`kCebFingerprint` unveraendert (Wert literal vor/nach)."
- "`comdare_experiment_planner version-stamp` gibt den POD aus; `... version` bleibt byte-identisch."
- **STOPP:** die gerenderte Zeile wandert -> abbrechen; das ist ein Byte-Ereignis und gehoert nach S6.

**G-S5 (F7)**
- "Ein Lauf mit >=2 Paessen erzeugt >=2 **unterscheidbare** Plan-Dateien (Verzeichnis-Listing literal)."
- "Resume findet den **eigenen** Plan: Teil-Resume-Test gruen, Log-Zeile literal."
- "Die zwei offenen T2-A-Befunde (Indexfolge-Bindung, `.tmp`-Multi-Writer) sind vorher geheilt und mit Objekt-Reproduktion belegt."
- **STOPP:** einer der beiden T2-A-Befunde ist offen -> nicht beginnen.

**G-S6 / G-S7 / G-S8 / G-S9(i)**
- "**OWNER-ENTSCHEID liegt schriftlich vor** (E-C / E-D / E-E / E-B), im Ledger verbucht, mit dem gewaehlten Buchstaben."
- "Bucket-/Anker-Bilanz **ausgewiesen, nicht behauptet**: welche Sidecars/Anker/Frozen-Vektoren sich bewegen, je mit altem und neuem Wert literal."
- "Fuer S7 zusaetzlich: die Doppel-Spalten-Uebergangsform ist gebaut und an **einem** Alt-Lauf als joinbar belegt."
- **STOPP (generell):** ohne Entscheid kein Byte.

### 6.1 STOPP-Klauseln, uebergreifend

1. **Ein Fenster, ein Anker.** Faellt in einem Fenster mehr als **ein** Fingerprint-/CRC-Anker, ist die
   Schnittfuehrung falsch -- abbrechen und neu schneiden.
2. **Kein gruen durch Abschwaechung.** Wird eine bestehende Wache (Drift-Guard, Frozen-Vektor, CRC,
   Gleichheits-Wache) angefasst, um einen Schritt gruen zu bekommen, ist der Schritt gescheitert, nicht die Wache.
3. **Kein Schritt ohne literale Ausgabe.** Kein Haken ohne zitierten Compiler-/ctest-/`nm`-Output.
4. **Layer-Vertrag ist bindend.** Zieht `abi/` je `builder/` oder `profile_facade/`, sofort abbrechen -- die
   Werte werden **injiziert** (K-1-Muster), nie hereingeholt.
5. **Messdaten nie loeschen.** Beruehrt ein Schritt Ordnernamen oder CSV-Spalten ohne Uebergangs-Joinbarkeit,
   abbrechen.

---

## 7. EINORDNUNG

### 7.1 Aufwand

| Schritt | Umfang | Risiko |
|---|---|---|
| S1 POD | 1 Header + 1 Test-TU | **niedrig** -- kein Konsument, kein Byte |
| S2 CT-Name | 1 Header + Wachen in derselben Test-TU | **niedrig** -- preimage-neutral per Invariante |
| S3 Tier-Dock | Makro-Erweiterung (innen) + Loader-Probe + 1 Test | **mittel** -- die Byte-Wachen liegen daneben; die K7b-3-Praezedenz zeigt aber, dass es geht |
| S4 CEB/Planer | 2 Renderer umverdrahten + CLI-Subkommando | **mittel** -- der Drift-Guard ist scharf und soll es bleiben |
| S5 F7 | Namens-Ableitung im Iterator | **mittel** -- abhaengig von zwei offenen T2-A-Befunden |
| S6 Sidecars | 3 Renderer + Bucket-Ereignis | **hoch** -- Flotten-Neubau |
| S7 Ordner/CSV | Suffix-Kette + Archiv-Uebergang | **sehr hoch** -- Mess-Archiv-Grammatik |
| S8 Overlay | Codegen + 3 Frozen-Neuanker | **sehr hoch** -- Fingerprint-Ereignis |

### 7.2 Vor der Abgabe (Fr 08.08.)?

**Nein. Nichts davon. Ich komme zum selben Schluss wie die Auftrags-Erwartung.**

Begruendung, nicht Hoeflichkeit:

1. **S0 ist noch nicht erfuellt.** T2-A ist "LANDEBEREIT", nicht gelandet, und traegt zwei offene, vom Lead
   uebernommene Befunde (Zaehler-Indexfolge-Bindung als **Korrektheits-Bug am Kern des Resume**;
   `.tmp`-Multi-Writer). Jeder Schritt dieses Plans baut auf T2-A.
2. **Das Zeitbudget gehoert dem Trigger.** Ziel-Trigger ist Do 07.08., Abgabe Fr 08.08. In diesem Fenster
   stehen B14, F3-Weg-a, das F5-Golden-Fenster und der Voll-Bau. Ein neues Interface -- selbst ein
   preimage-neutrales -- konkurriert dort um genau die Gates, die den Trigger tragen.
3. **Der Nutzen faellt nach der Messung an, nicht davor.** Was das Interface loest (F7-Plan-Ablage,
   Zweit-Ableitungs-Beseitigung, "welche Version steckt drin"), zahlt sich in der **Auswertung** und in der
   **Fortschreibung** aus. Fuer den einen Voll-Lauf bis Abgabe traegt die bereits entschiedene F7-**Option 1**
   (Pass-unabhaengiger Pfad).
4. **Der teuerste Teil ist ohnehin owner-entscheid-gebunden** (E-C bis E-E) und gehoert in das F5-Fenster
   bzw. dahinter.

**Eine Sache kostet null Bau-Zeit und sollte im F5-Fenster trotzdem mitgedacht werden:** dass dort **kein
weiterer Preimage-Dreh verbraucht** wird, den man nicht braucht. Denn S1-S5 kommen ohne Dreh aus -- wenn das
F5-Fenster den Anker fuer etwas anderes ausgibt, kostet das dieses Vorhaben nichts; gibt es ihn aber
**mehrfach** aus, wird die Reihenfolge hinterher teurer. Das ist eine **Notiz**, kein Auftrag.

### 7.3 Der kleinste sinnvolle ERSTE Schritt

> **S1 allein: `abi/version_stamp_interface.hpp` -- der POD, die Kategorie-Bindung, die Gleichheits-Wache.
> Kein Dock, kein Name, kein Konsument.**

Warum genau dieser Schnitt:

- Er ist **preimage-neutral, golden-neutral, ABI-neutral, sidecar-neutral** -- er kann zu **jedem** Zeitpunkt
  landen, auch mitten in einem Mess-Fenster, ohne irgendetwas zu invalidieren.
- Er liefert sofort den einzigen **neuen** Beweis dieses ganzen Vorhabens: die Owner-Zusage "**alle**
  Achsen-Kategorien" wird von einem Absatz zu einer Kette von `static_assert`s. Das ist die Dauerform der
  Heilung des A2-Nachreview-Befunds C1 -- eine kuenftig fehlende Kategorie braeche ab dann den Bau.
- Er ist die **Vorbedingung fuer alle** anderen Schritte und blockiert keinen davon.
- Umfang: **ein** Header plus **eine** Test-TU. Nach der Abgabe, nach S0.

---

## ANHANG A: Fundstellen-Register (alles am Objekt geprueft, 2026-08-06)

| Gegenstand | Datei:Zeile |
|---|---|
| Preimage-Ordnung (DIE EINE Quelle) | `abi/anatomy_fingerprint.hpp:462-472` (T2-A) |
| Benannte Glied-Positionen | `abi/anatomy_fingerprint.hpp:350,359-361` |
| consteval-Fingerprint | `abi/anatomy_fingerprint.hpp:584-599` |
| Ein Preimage-Kern, zwei Senken | `abi/anatomy_fingerprint.hpp:517-573` |
| Injektivitaets-Wache + Fehlerklasse | `abi/anatomy_fingerprint.hpp:139-173` |
| Budget-`static_assert` | `abi/anatomy_fingerprint.hpp:374-391` |
| consteval SHA-512 + NIST-Vektoren | `src/sha512/ctsha512.hpp:99-151,197-206` |
| Compile-Budget 50 KB | `src/sha512/ctsha512.hpp:164-166` |
| Stempel-Makro (Materialisierung) | `abi/anatomy_module_abi_v1.hpp:150-197` |
| Zwei-Schritt-consteval-Array-Muster | `abi/anatomy_module_abi_v1.hpp:154-157` |
| ABI-Major / Magic | `abi/anatomy_module_abi_v1_decl.hpp:89,93` |
| Pflicht-Symbole (vier) | `abi/anatomy_module_abi_v1_decl.hpp:119-137` |
| Optionales Probe-Symbol | `abi/anatomy_module_abi_v1_decl.hpp:280-286` |
| `AnatomyVersionLines` + Layout 6 + `sizeof 120` | `abi/anatomy_module_abi_v1_decl.hpp:180-244` |
| K-4 Gleichheits-Wache + CT-Negativ-Proben | `abi/anatomy_module_abi_v1_decl.hpp:246-274` |
| CEB-Contract-Minor + Bump-Praezedenzen | `abi/anatomy_module_abi_v1_decl.hpp:329-429` |
| Organ-/System-/Mess-Stempel-Zeilen | `abi/anatomy_version_stamp.hpp:81-116,144-161,216-296` |
| `organ_stamp_line`-BLOCKER | `abi/anatomy_version_stamp.hpp:75-80` |
| Toolchain-Glied + Suffix-Kopplung | `abi/toolchain_stamp_glied.hpp:5-30` |
| bvset-Glied | `builder/build_variant_set_signature.hpp` |
| Achsen-Versions-Tabelle / Grammatik-Wache | `builder/experiment_tree/axis_variant_version_table.hpp:60-112,119-223,259-326` |
| binary_id-Serialisierung (TABU-nah) | `builder/experiment_tree/axis_path_serialization.hpp:40,52-92` |
| Sidecars + Skip-Gate | `builder/build_orchestrator/build_orchestrator.hpp:222,228,235,293-299` |
| RT-Fingerprint-Zwilling | `profile_facade/lazy_adhoc_source_gen.hpp:358` |
| CEB-Selbst-Stempel (3. Ableitungsweg) | `builder/ceb_version_stamp.hpp:1-25` |
| Planer-Selbst-Stempel | `profile_facade/planner/planner_version.hpp:56-66` |
| Planer-CLI | `apps/experiment_planner/main.cpp:23-24,261-263` |
| CEB-Log-Kopf | `apps/cache_engine_builder/main.cpp:161` |
| I1-Observer-Muster (Vorbild) | `anatomy/observable_tier.hpp:13-27,132-200` |
| Frozen-Fingerprint (drei Stellen, T2-A) | `tests/unit/test_m_w12_stamp_bausteine.cpp:663`, `tests/unit/test_g3_sha512_index.cpp:68`, `tests/unit/test_w10_system_cell_values.cpp:432` |
| golden-CRC-Anker | `profile_facade/source_catalog.hpp:183-187` |
| F5-Golden-Fenster (TABU-6, Archiv-Grammatik) | `super/docs/plaene/20260806-PLAN-golden-update-fenster.md` |
| Owner-Direktive + KERN in drei Teilen | `super/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:4243-4246` |

**Selbstcheck:** Datei ASCII-only (keine Nicht-ASCII-Zeichen im Diff dieses Dokuments); alle Datei:Zeile-Anker
am Objekt gelesen; keine Bau-, Commit- oder Konfigurations-Aktion ausgefuehrt.
