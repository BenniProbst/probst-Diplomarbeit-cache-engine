# V-02R Explorer 2 (OBJEKT-/ANALOGIE-SEITE) — Befund

## 0. Rahmen und Stand-Warnung

Alle Pfade relativ zu `Code/external/comdare-cache-engine/` im super-Repo, sofern nicht anders markiert. Geprüft an zwei Ständen:
- **`development`** (Tip `04ac26fa`, read-only) — hier liegt die HEUTIGE Tier-Preimage-Maschinerie (Format 4, 9 Glieder).
- **`bau/hy-a-hybrid-struktur`** (Tip `374c1d12`, davor `c979d1c0`) — hier liegt die Prüfdock-Steck-Mechanik. **Diese Dateien existieren NICHT auf `development`** (`find` über den ganzen Baum: 0 Treffer für `hybrid_dock_array`/`hybrid_dock_contract`); ich musste per `git show <branch>:<pfad>` gegen den Branch lesen. Wer künftig an dieser Stelle sucht: der Branch ist LANDEREIF (Task #80), aber noch nicht in development.

Ledger-Zitate aus `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (super-Repo), Zeilennummern wie **jetzt** gelesen (nicht historisch).

---

## (a) DIE TIER-BINARY-GRAMMATIK — Bauform am Objekt

**Konkrete Bauform, dreifach belegt, alle drei stimmen überein:**

Eine Stempel-Zeile ist eine Folge von Segmenten `<achse>=<variante>@<X.Y.Z>`, **`;`-getrennt**, in **fester kanonischer Achsen-Reihenfolge** (`kCompositionAxisNames`, 18 Slots):

- `libs/cache_engine/builder/experiment_tree/axis_path_serialization.hpp:40-43`: `inline constexpr std::array<std::string_view, 18> kCompositionAxisNames = {"search_algo", "cache_traversal", ..., "persistence_target"};`
- `libs/cache_engine/builder/experiment_tree/axis_variant_version_table.hpp:300-330` (`compose_organ_stamp_line`): *"die kOrganAxisVersionLine 'achse=variant@X.Y.Z;...'"* — Schleife über `kCompositionAxisNames`, je Slot `out += slot; out += '='; out += val; out += '@'; out += algo_semver_string(...)`, Trenner `;` nur zwischen Segmenten (`if (!out.empty()) out += ';';`).
- `libs/cache_engine/builder/experiment_tree/axis_variant_version_table.hpp:273-298` (`compose_algo_signature`): dieselbe Grammatik für die `.algos`-Sidecar-Form.

**Darüber liegt eine ZWEITE Ebene** — die Preimage-Glied-Folge selbst (mehrere solcher Zeilen + Zusatz-Glieder, `'\n'`-getrennt, EINMAL SHA-512):
- `libs/cache_engine/include/cache_engine/abi/anatomy_fingerprint.hpp:82`: `kAnatomyFingerprintSeparator = '\n'` — *"BEWEISBAR kollisionsfrei ... der Stempel-Zeichenvorrat ist auf alnum + '=@;.+_[]' festgelegt ... ein Zeilenumbruch kann in keinem Glied vorkommen"*.
- `:116`: `kAnatomyFingerprintFormat = "fingerprint_format=4"`.
- `:416`: `kAnatomyFingerprintGliedCount = 9`.
- `:537-557`: die 9 Glieder `[0]format [1]organ [2]system [3]mess [4]valueset [5]toolchain [6]bvset [7]overlay [8]messgates`.
- `:735-751` (`anatomy_fingerprint_hex`): `sha512::sha512(...)` über den `'\n'`-Puffer → **128-Hex** (`array<char,129>`).
- `libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1.hpp:162-204` (`COMDARE_ANATOMY_VERSION_STAMP_M`): materialisiert genau diese Glieder als `static constexpr char[]`/POD im Modul.

**Bauform-Kandidat für "die Grammatik einer Tier-Binary" (Owner-Wort):** die '`;`-Segment-Zeile' (organ/system/mess je eine Zeile dieser Form) **plus** die '`\n`-Glied-Folge' (Preimage-Konstruktion mit SHA-512 am Schluss) — beide Ebenen sind gemeint, denn KON41-04 (s.u.) spricht explizit von *"volle Syntax der Organ-Achse"* UND von *"noch eine Zeile mehr ... der SHA jedes Stempels kommt zum Schluss als letzte Zeile"* — das IST exakt die 9(→10)-Glied-Preimage-Architektur.

---

## (b) SHA256-PRÄZEDENZEN am Objekt — fünf Familien, keine davon ist die anatomy_fingerprint-SHA-512-Familie

| # | Fundstelle | Was gehasht wird | Form |
|---|---|---|---|
| 1 | `libs/cache_engine/src/sha256/ctsha.hpp:1-16` | die reine Algorithmus-Implementierung (RFC 6234), *"consteval SHA256 fuer Paper-Original-Code-Validierung"* — `:141-152` `sha256(span)`/`sha256(char const(&)[N])` | Primitive, kein eigener Konsument in dieser Datei |
| 2 | `libs/cache_engine/builder/experiment_tree/organ_fingerprint.hpp:4-33` | `organ_fingerprint_preimage_from_pairs`: **sortiert** (stem-sort == `LC_ALL=C`-Pfadsort) + **konkateniert OHNE Trenner** die `.algos`-Sidecar-Inhalte mehrerer Binaries, **EINMAL SHA256** darüber (Cross-Validierung gegen `find|sort|xargs cat`) | Sort+Concat(raw bytes, no sep)+ONE sha256 |
| 3 | `tools/axis_version_lock/axis_version_lock.cpp:265-269` (`digest_hex_of`) + `:155` (Lock-Zeilenformat `'    <sha256-hex>'`) | **EIN SHA256 PRO DATEI** (nicht Konkatenation mehrerer Dateien vor dem Hash) — Ergebnis wird als 64-Hex-Zeile in einer Lock-Datei je Achsen-Quelldatei geführt | Per-Item-Digest, dann Listung — strukturell am nächsten an "Verkettung von sha256 der ... Tier-Binaries" |
| 4 | `libs/cache_engine/profile_facade/planner/planner_version.hpp:78-84` | **V-08R-Vorbau**: `fingerprint_sha()` liefert `{}`, `kFingerprintShaBewusstLeer = true`, Begründung wörtlich: *"der Planer traegt noch keinen SHA-512-Fingerprint; Fuellung = eigener Posten"* | Deklarierte Lücke, NICHT implementiert; Owner-Auflage 17.08. (KON101-02, Ledger:67-68): SHA256 **nur** über `kPlannerVersion` ("1.0.0.c"), kein eigenes Preimage |
| 5 | Ledger `:28201/:28211` — **E-A** (Owner, 07.08.: *"wir verwenden dann bitte doch der Einfachheit wegen SHA256"*) | SHA-256/64-Hex als **eigener, zweiter Hash über DASSELBE Preimage** wie die SHA-512-Fingerprint-Berechnung — *"ACHTUNG fuer den Bau: der Name ist damit KEIN Praefix des Fingerprints (der bleibt SHA-512), sondern ein eigener Hash ueber dasselbe Preimage"* | **DESIGN-ENTSCHIEDEN, aber NICHT gebaut** (siehe Lücken unten) |

**Gegenprobe zu (5):** `grep -rn "sha256::sha256\|cache_engine::sha256"` über den ganzen Baum trifft nur die Zeilen 1-3 oben — kein Aufrufer verbindet SHA256 mit dem Anatomy-Fingerprint-Preimage. `grep -in "rekombinationsname\|rekombination"` liefert 30+ Treffer, aber keiner benennt eine Name-Hash-Funktion. Der existierende Kürzungs-Mechanismus für lange Namen (`kStemMax=120`, `builder/build_orchestrator/build_orchestrator.hpp:287-294`, `builder/best_binary_selector/best_binary_selector.hpp:101`) nutzt **FNV-1a**, nicht SHA-256 — ein ANDERER, älterer Mechanismus für ein ähnliches Problem (Dateiname-Budget), keine Vorwegnahme von E-A.

---

## (c) VERKETTUNGS-PRÄZEDENZEN am Objekt

1. **kOverlaySourceSet / E-E** (`anatomy_fingerprint.hpp:126-157`, zitiert die Owner-Festlegung 07.08.): *"(1) KONKATENATION, nicht Hash je Datei: die Bytes werden aneinandergehaengt, EINMAL SHA-512 darueber. (2) FESTE STATISCHE ORDNUNG JE ACHSEN-KATEGORIE ... (3) DER SCHNITT: ... plus libs/cache_engine/anatomy/ als gemeinsame Tier-Substanz."* — Muster: fixe Ordnung, roh konkateniert, EIN Hash am Ende.
2. **organ_fingerprint.hpp** (s.o., b/2) — dieselbe Struktur, aber SHA256 statt SHA512, UND die Ordnungsregel ist beweisbar (nicht nur behauptet): `:11-14` beweist Stem-Sort == Pfad-Sort byte-für-byte.
3. **ceb_tooling_list / Mess-Combo-Legende** (`libs/cache_engine/builder/ceb_version_stamp.hpp:358-425`): Token-Segmente `;`-verkettet (`measurement_tooling=<id>@X.Y.Z;...`), **HEUTE in Eingabe-Reihenfolge** (`:372-374`: *"die Tokens in EINGABE-Reihenfolge (nicht Registry-Reihenfolge)"*) — genau der Defekt, den V-13 (Owner 17.08., Ledger:77-80) schließt: *"Es wird nur die Reihenfolge wallclock/macro/micro erlaubt, alles andere ist syntaktisch falsch"* → `ceb_tooling_list wird im Bruch (B-5f) auf Ordnungs-Validierung umgestellt`. **Präzedenz für "feste Ordnung erzwungen, Verstoß = Fehler, nie stille Normalisierung"** — dieselbe Doktrin, die KON45-01(6) für die Hybrid-Zeile fordert (*"Konkatenation Dock-Index AUFSTEIGEND"*, `Ledger:4858-4859`).
4. Die Preimage-Glied-Konkatenation selbst (`anatomy_fingerprint.hpp:668-724`, `anatomy_fingerprint_preimage_emit`) — die Ziel-Architektur, in die das 10. Glied eingehängt wird.

---

## (d) DER MEASUREMENT-DURCHSTICH — Objekt-Beleg

Doktrin, wörtlich am Ledger (Drei-Flächen-Modell, KON16-06):
```
Ledger:5918-5925
FLAECHE 1  Genus-Interface einer Tier-Binary     abstract factory, Laufzeit
FLAECHE 2  der STEMPEL                          compile time factory, ABI-stabil
FLAECHE 3  der MEASUREMENT-DURCHSTICH  = die NAHT-1 vom 09.08. (IMessVisitor)  KON25-02
           existiert, DAMIT Gattung+Genus-Interfaces UNVERAENDERT bleiben
```
Owner-Bestätigung `Ledger:7285-7292` (KON25-02): *"Ja genau, das ist Fläche 3 und beide Konzepte müssen vereint werden."*

**Am Objekt:**
- `libs/cache_engine/anatomy/mess_visitor_abi.hpp:98-139` — `class IMessVisitor`: GoF-Visitor, Double-Dispatch über die dlopen-Grenze. **Bereits VIER Ebenen im Vertrag**, davon die vierte für Hybrid RESERVIERT: `:130-133` `virtual void visit_hybrid_reroute(std::uint64_t from_genus, std::uint64_t to_genus, std::int64_t decision_ns) noexcept = 0;` — Kommentar `:101-103`: *"Die Hybrid-Ebene ist ab diesem Major Teil des Vertrags, obwohl ihr Emitter erst mit HY-A2 kommt -- Reserve mit BENANNTEM Zweck ... damit das Hybrid-Paket keinen zweiten koordinierten ABI-Bruch ... kostet."*
- `libs/cache_engine/builder/pruef_dock/genus_mess_naht.hpp:81-92` (`genus_measure_into`) — der **Durchstich-Punkt** wörtlich: *"Hier, und nur hier, quert der Mess-Visitor das Genus-Interface."*

**Für V-02R heißt das:** die Hybrid-Stufe muss für ihre eigene Messung KEINEN neuen ABI-Schritt einführen — der Durchstich ist schon vierstufig vorgehalten. Offener Bau-Posten (Task #20, unverändert): Vokabular-Vereinigung (IMessVisitor ≡ measurement-Durchstich in Doku/Namensgebung) + Deckungstest CEB=AUS/Tier=AN fehlt (`Ledger:6002`).

---

## (e) DIE PRÜFDOCK-STECK-MECHANIK — Objekt-Beleg (NUR auf `bau/hy-a-hybrid-struktur`)

Drei-Ebenen-Dock-Kette (`hybrid_pruef_dock.hpp:7-13` auf diesem Branch): Ebene 1 Experiment-Dock (Planer↔CEB, noch nicht materialisiert) / Ebene 2 Prüf-Dock (CEB↔Tier, GEBAUT: `IPruefDock`) / **Ebene 3 Hybrid-Prüf-Dock (Hybrid↔plain Tiers, DIESE Dateien)**.

**Vertrag/Typ-Ebene** (`libs/cache_engine/hybrid/hybrid_dock_contract.hpp:169-198`): `enum class HybridDockContract {Standard=0, Rollback=1, Scan=2, ResourceControl=3}` + `kHybridDockContractRegistry` (constexpr, 4 Zeilen, nur `Standard` hat einen gebauten Dock-Typ = F8-Minimal-DoD). `DockContractDescriptor{contract_id, genus}` (`:316-319`) ist die POD-Wire-Form je Slot.

**Array/Steck-Ebene** (`hybrid_dock_array.hpp`): `HybridDockVariant = std::variant<StandardHybridDock>` (`:79`, die EINE erlaubte variant-Stelle außerhalb der CEB) → `DockSlot{dock, desc, antrieb}` (`:101-105`, `antrieb` = gecachter `IObservableTier*`, EINMAL am Umschaltpunkt gesetzt) → `DockArray<Policy>` mit `attach()`→Slot-Index≥0 oder `-status`<0, `detach()` gibt Slots zur Wiederverwendung frei (`:222-231`). `kHybridNodeObergrenzeDefault = 32` (aus `heuristik_adapter_synthese_matrix.hpp:95`, Owner 12.08. *"maximal 32"*, KON28-03) ist der **Programm-Deckel**, kein Fach-Nenner.

**Die eigentliche Dock-ADRESSIERUNG** (das, was der Lead-Vorschlag in `docs/sessions/20260817-OWNER-VORAB-15-restfragen.md:27-28` mit *"adressbasierte Keys per stufen_id (Layer*Nodes+Node)"* meinte, jetzt am Objekt bestätigt): `heuristik_adapter_synthese_matrix.hpp:139` — `SyntheseZelle<Layer,Node,Ziel,Nodes>::stufen_id() { return Layer * Nodes + Node; }`. Owner-Zitat im Datei-Kopf (`:6-9`, E-1 final 09.08.): *"ein Heuristik-Tier-Binary eine 2D-Matrix-Liste mit Synthese-Funktionen fuer jeden inneren Layer und jede Layer-Node erhaelt."* Layer = Rest-Tiefe (rekursiv herunterzählend, heute `kHybridRestTiefeDefault=1`), Node = Dock-Index 0..Nodes-1 **innerhalb dieser Matrix** (nicht global-32; belegt durch `static_assert`e `:243-248`, die zeigen, dass dieselbe (Layer,Node)-Kombination bei Nodes=8 vs. Nodes=32 verschiedene IDs liefert).

**WICHTIGER BEFUND:** `DockArray::attach()` (physischer Slot-Index, first-free, wiederverwendbar) und `SyntheseZelle::stufen_id()` (logische Layer×Node-Adresse) sind **zwei verschiedene, heute NICHT verdrahtete Adressräume** im selben Objekt — welcher davon die Ordnung für die Verkettung im 10. Glied trägt (Slot-Attach-Reihenfolge vs. stufen_id-Reihenfolge), ist am Objekt nicht entschieden.

---

## SYNTHESE — welche Kombination die Owner-Formel am Objekt ergibt

Die Owner-Formel (`Ledger:19-40`, KON101-01, wörtlich): *"Die Grammatik ist die einer Tier-Binary mit durchstich zu einer Verkettung von sha256 der eingesteckten Hybrid-Pruefdock-Tier-Binaries."*

Zusammengelegt mit KON41-04 (`Ledger:5231-5260`, Owner 12.08., noch gültig für die STRUKTUR, nicht mehr für den Hash-Algo) und KON101-02 (`Ledger:49-53`), ergibt sich als am Objekt am besten belegte Kombination:

1. **Zeilen 1..n**: die Hybrid-Binary trägt ihre EIGENEN Stempel-Glieder exakt wie ein plain Tier — Format-4-Preimage-Architektur (`anatomy_fingerprint.hpp`), `;`-Segment-Grammatik (`compose_organ_stamp_line`) unverändert.
2. **Glied [9] (NEU, 10. Glied, Format 4→5-Bump)**: die Komposit-Zeile = **Verkettung** der Prüfdock-Beiträge, **Dock-Index aufsteigend** (KON45-01(6) bleibt auf dieser Achse unwidersprochen), OHNE separaten SHA-Wurf mehr obendrauf — genau das ist der Unterschied zu KON45-01/47-02 (die noch `sha512_line`, 128-Hex, als Map-VALUE hatten): **jeder Dock-Beitrag ist jetzt ein SHA256/64-Hex** statt des SHA512/128-Hex-Fingerprints. Der explizite *"Konsistenz-Anker: SHA-256-Linie wie E-A (Name) und V-08R (Planer)"* (`Ledger:53`) spricht dafür, dass dieser Per-Tier-SHA256 **dieselbe E-A-Konstruktion** ist: ein ZWEITER, eigenständiger SHA-256-Hash über dasselbe Preimage, das auch den SHA-512-Fingerprint des jeweiligen plain Tiers speist (NICHT die ersten 64 Hex-Zeichen des SHA-512, wie E-A ausdrücklich klarstellt).
3. **Letzte Zeile**: der SHA-512-Fingerprint der GESAMTEN Hybrid-Glied-Folge (unveränderte `anatomy_fingerprint_hex`-Mechanik) — *"der Hybrid SHA wirkt auch ueber diese neue Zeile compile time"* (KON41-04) beschreibt exakt das bestehende `anatomy_fingerprint_preimage_emit`-Verhalten (jedes Glied fließt in EINEN SHA-512).

Der "Durchstich" (Owner-Wortwahl) hat damit zwei mögliche, am Objekt beide belegte Lesarten, die sich NICHT gegenseitig ausschließen: (i) strukturell — die Komposit-Zeile "durchsticht" die sonst unveränderte Gattung/Genus-Stempelform genau wie IMessVisitor das Genus-Interface durchsticht, ohne dessen Vertrag zu ändern (Drei-Flächen-Parallele); (ii) mechanisch — sie ist der Kanal, durch den die SHA256-Identität jeder eingesteckten plain-Tier-Binary bis in den Hybrid-SHA-512 "durchgereicht" wird (V-04R, `Ledger:58-61`: *"bei Abfrage ueber die Flaeche wird das durchgereicht"*).

---

## DETAIL-LÜCKEN

1. **Welches Preimage speist den Per-Tier-SHA256?** Die "Konsistenz-Anker"-Formel benennt E-A als Muster, sagt aber nicht explizit, ob der Hybrid pro Dock den vollen Tier-Preimage-String erneut hasht oder ob ein künftiges `kNameSha` (E-A) einfach als zusätzliches POD-Feld am Tier existiert und der Hybrid es nur ausliest. E-A ist selbst NICHT gebaut (siehe b/5 + Gegenprobe) — Explorer 1/Owner-Seite sollte das schließen.
2. **Ordnung: Slot-Index vs. stufen_id.** `DockArray::attach()` (physischer Index) und `SyntheseZelle::stufen_id()` (Layer×Node) sind am Objekt zwei getrennte Adressräume (siehe e). KON45-01(6) verlangt "Dock-Index aufsteigend" — unklar, welcher der beiden Indizes gemeint ist, bzw. ob sie vor B-5 vereinheitlicht werden müssen.
3. **K1 (Lager-Identität der Hybrid-.so selbst)** ist laut soll_design-Nachtrag 17.08. (`docs/architecture/20260802-hybrid_tier_stufe_soll_design.md` Abschnitt 7, auf dem hy-a-Branch) beantwortet ("reguläre Gattung+Genus"), aber **K2** (Loader-/Drive-Schichtung) und **K5** (Snapshot-Aggregations-Semantik) bleiben laut demselben Dokument offen — keiner der 12 V-01R..V-13-Owner-Antworten vom 17.08. berührt K2/K5 explizit.
4. **Format-Bump-Reihenfolge:** ob das 10. Glied VOR oder NACH dem S-6a-POD-Bump (ABI-Layout 6→7) kommt, ist Bau-Reihenfolge, keine Grammatik-Frage — außerhalb meines Objekt-Auftrags, aber Task #15 markiert beide als "EIN Bruch".
5. **hybrid_binary_proxy.hpp / hybrid_tier_module.cpp** (der eigentliche `.so`-Export der Hybrid-Binary) sind NICHT gebaut — ohne sie ist unklar, ob/wie die Komposit-Zeile praktisch am `COMDARE_ANATOMY_VERSION_STAMP`-Makro-Expansionsort injiziert wird (Analogon zu `kToolchainStampGlied`/`kMessGatesTuGlied`, die ja auch injiziert statt inkludiert werden, `anatomy_fingerprint.hpp:303-322,385-397`).

---

## GEPRÜFT / NICHT GEPRÜFT

**Geprüft (Objekt gelesen, Zeilen zitiert oben):** anatomy_fingerprint.hpp komplett · anatomy_module_abi_v1.hpp komplett · ctsha.hpp komplett · organ_fingerprint.hpp komplett · axis_variant_version_table.hpp (Ausschnitt kCompositionAxisNames-Konsumenten) · axis_path_serialization.hpp (Kopf) · ceb_version_stamp.hpp (ceb_tooling_list-Block) · mess_visitor_abi.hpp komplett · genus_mess_naht.hpp komplett · pruef_dock.hpp komplett · planner_version.hpp komplett · axis_version_lock.cpp (sha256-Konsum-Block) · build_orchestrator.hpp (kStemMax-Fund) · auf `bau/hy-a-hybrid-struktur`: soll_design.md komplett, hybrid_dock_contract.hpp komplett, hybrid_dock_array.hpp komplett, hybrid_pruef_dock.hpp komplett, hybrid_dock_factory.hpp (Kopf), heuristik_adapter_synthese_matrix.hpp komplett, hybrid/README.md komplett · Ledger-Abschnitte KON101-01/02, KON100, KON47-02, KON45-01, KON41-04, KON42-01, KON25-02/03, E-A-Nachtrag (07.08.), Drei-Flächen-Doktrin (KON16-06) · Session-Dokument `20260817-OWNER-VORAB-15-restfragen.md` komplett.

**Nicht geprüft (explizit offen gelassen, Gegenprobe wo möglich):** `hybrid_binary_proxy.hpp`, `hybrid_tier_module.cpp`, `hybrid_eviction.hpp`, `hybrid_router.hpp` — existieren nirgends (auch nicht auf hy-a-Branch, per README-Tabelle selbst bestätigt) · `hybrid_dock_factory.hpp` nur Kopf gelesen, nicht die volle `attach()`-Definition · `hybrid_config_xml.hpp` nur extrahiert, nicht gelesen (XML-Parser-Seite, außerhalb meines (a)-(e)-Auftrags) · KON7-04 "2-Zeilen-Form" (von V-08R-Empfehlung zitiert) nicht am Objekt nachgeschlagen · K2/K5-Ledger-Historie (wann/wo diese Auflagen entstanden) nicht zurückverfolgt, nur der aktuelle soll_design-Status zitiert · ob ein GEGENSTAND namens "KompositMapGlied"-Träger (K-1-Muster, in KON45-01 angekündigt) irgendwo im Code als Skeleton existiert — NICHT gefunden (0 Treffer für "KompositMapGlied"/"HybridKomposit" im ganzen Baum inkl. hy-a-Branch), also eine echte Lücke, keine Suchschwäche.