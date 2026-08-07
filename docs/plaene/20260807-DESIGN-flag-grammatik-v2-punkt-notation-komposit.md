# DESIGN — Flag-Grammatik v2: Punkt-Notation, Komposit-Flags, Klassenname statt Marker

**Stand 07.08.2026 nachmittags. Owner-KERN, in fünf Nachrichten entwickelt.**
Dieses Dokument ist die Bau-Vorlage. Es ersetzt die Q3-Grammatik vom 02.08. vollständig —
**die Syntax wird erneuert, die Struktur bleibt.**

---

## 0. Die Owner-Direktive, die den Rahmen setzt

> *„ich möchte die alten Wege komplett ersetzen und das System erneuern, so wie die Syntax eben
> definiert wurde … Die Struktur der Stempel Zeilen bleibt jedoch gleich bezüglich was dort steht
> und wie viele Achsen und SHA fingerprint"*

**Daraus die Trennlinie:**

| BLEIBT unverändert | WIRD ERSETZT |
|---|---|
| Drei Realm-Zeilen (Organ / System / Mess) | die Schreibweise der Flags |
| `kOrganAxisCount = 18`, Mess-/System-Zahlen | Kardinalität: 1 Zeichen → n Flags |
| Neun Preimage-Glieder, `consteval` SHA512 | `e` = experimental → `e` = efficiency core |
| Meta-Meta-Klammern `[…]` mit Tiefe in Bits 3–5 | Marker `code` → ausgelesener Klassenname |
| Die Stufen-Doktrin (Mess 3, System 2, Organ 2) | — |

---

## 1. Die Grammatik

```
realm-zeile   := <achsen-eintrag> [ ';' <achsen-eintrag> ]*
achsen-eintrag:= <achse> '=' <klasse> '@' <version> [ <meta-meta-gruppe> ]
version       := UINT '.' UINT '.' UINT [ '.' <flag> ]*
flag          := <einzel-flag> | <komposit-flag>
einzel-flag   := 'c' | 'p' | 'e' | 'g' | 'f' | 'n' | <companion>
komposit-flag := '{' <basis> [ '.' <sub> ]* '}'
basis         := 'x128' | 'x256' | 'x512'
meta-meta-gruppe := '[' <achsen-eintrag> [ ';' <achsen-eintrag> ]* ']'
```

**Beispiele:**
```
Organ:   memory_layout=SoaMemoryLayout@1.0.0.c.{x512.f.vl.bw.dq}
System:  simd=x512.f@1.0.0
Mess:    wallclock=WallClockTooling@1.0.0.c
Meta-Meta: external_utils=ExternalUtils@1.0.0.c[simd=x512.f@1.0.0]
```

### 1.1 Die Flags sind FILTER
Owner verbatim: *„jedes character ist ein filter für einen Hardware Bereich oder Eigenschaft in
der die Binary gültig ist und dort laufen kann"*.
Ein Flag sagt: **für diese Hardware wurde der Algorithmus gebaut.** Es ist keine Laufzeit-Option
— die Stufen-Doktrin macht daraus eine Behauptung über einen bereits vollzogenen CT-Einbau.

| Flag | Bedeutung |
|---|---|
| `c` | CPU |
| `p` | performance core — verengt die CPU-Nutzung |
| `e` | **efficiency core** — verengt die CPU-Nutzung. **NICHT MEHR** *experimental* |
| `g` `f` `n` | GPU / FPGA / NPU (reserviert, nicht produziert) |
| `{x512.…}` | AVX-512-Familie mit ihren Subset-Flags |
| `{x256.…}` | AVX2-Familie |
| `gfni` `vaes` `vpclmulqdq` | Companion-Flags — gehören zu keiner Breite, stehen ohne Klammer |

**Reihenfolge ist sachlich egal, wird formal eingehalten.**

### 1.2 Die Komposit-Flags bilden den bestehenden SIMD-Katalog ab
`{x512.f.vl.bw.dq}` → `avx512f`, `avx512vl`, `avx512bw`, `avx512dq` aus `simd_feature_flag.hpp`.
Die Basis `x512` trägt die Breite, die Sub-Flags die Subsets. Unterstriche der Katalog-Token
(`avx512_vbmi2`) fallen in der Notation weg: `{x512.vbmi2}`.

### 1.3 Die Asymmetrie System ↔ Organ
Owner verbatim: *„die Systemachse definiert, dass zumindest x512 irgendwie freigegeben ist, aber
das ist eher simd=x512.f@1.0.0 und in der Organ-Achse kann dann ein Algorithmus ein Komposit-flag
verwenden, wenn er simd implementiert"*.

- **System-Achse**: die Flag-Kombination steht **an der Stelle der Klasse** — sie *ist* die
  Identität dieser Achse. Grund: Stufe 1 ist RT-Freigabe an der CEB.
- **Organ-Achse**: das Komposit-Flag hängt **hinter der Version** — es ist eine Eigenschaft des
  einkompilierten Algorithmus. Grund: Stufe 2 ist CT-Einbau im Tier.

**Und nicht jede Achse kann SIMD.** Owner: *„manche Aufgaben machen simd zwecklos"*.
Das ist bereits gebaut: `simd_organ_sensibility.hpp` führt neun Organ-Klassen mit ihren
sinnvollen Flag-Mengen; `prefetch` trägt die **leere** Menge, im Code kommentiert als
*„KEIN SIMD-Flag"*. Drei Zuordnungen sind ehrlich als `speculative` markiert.

---

## 2. `code` ist der Klassenname, nicht ein Literal

Owner verbatim: *„Der ‚code' ist der name der Klasse der Implementierung, die über ein compile
time ausgelesen werden kann. Es ist der angewendete Algorithmus Typ, das Organ welches unter der
Achse einkompiliert wurde."*
Und die Invariante: *„Bei den Papern hat jede Achse im Tier-Binary genau einen compile time
algorithmus."*

### 2.1 Der Ist-Zustand ist eine Drift-Quelle
```cpp
class ByteWisePathCompression : public PathCompressionStrategyBase<ByteWisePathCompression>
    static constexpr std::string_view name() { return "path_compression_byte_wise"; }
```
Klassenname und Stempel-Name sind **verschieden und unabhängig gepflegt**.

### 2.2 Die Technik (Web-Recherche, Owner-beauftragt)
Ohne Standard-Reflection (kommt erst mit C++26) ist der etablierte Weg das constexpr-Parsen von
`__PRETTY_FUNCTION__`. Compiler-abhängige Marker: GCC `" [with T = "`, Clang `" [T = "`,
MSVC `__FUNCSIG__`. Referenz-Implementierung: CTTI `ctti::nameof<T>()`.

### 2.3 **RISIKO und Empfehlung: Wache statt Quelle**
Der Stempel geht ins Fingerprint-Preimage. Ein compiler-abhängig extrahierter Name würde
**zwei Binaries derselben Konfiguration verschiedene Fingerprints** geben (GCC-Kanon vs.
`build:clang` vs. MSVC-Windows-Lane) — das SHA512-Skip-Gate bräche.

**Empfehlung:**
```cpp
static constexpr std::string_view name() { return "path_compression_byte_wise"; }
static_assert(class_name_matches<ByteWisePathCompression>(name()));
```
- Das **Literal bleibt** die Stempel-Quelle → Fingerprint compiler-unabhängig
- Der **CT-Name prüft** dagegen → Drift bricht compile-time
- Normalisierung (Namespace, Template-Args, CamelCase→snake_case) **nur in der Wache**

**Owner-Entscheid offen:** Wache (additiv, kein Byte-Ereignis) oder direkte Quelle (Neuanker
aller Stempel, Wette auf Normalisierungs-Stabilität über drei Compiler)?

---

## 3. Der Hybrid-Stempel

Owner verbatim: *„Hybrid: Kapselt alle möglichen Tier-Binaries, die er connected in [] Klammern
und schreibt die gesamte Stempel-Definition dieser Binaries aus. Der SHA Fingerprint ergibt sich
aus dem überlagerten SHA fingerprint aller Tier-Binaries."*

### 3.1 Das ist die Vollausbau-Stufe einer bestehenden Notation
Die Direktive vom 19.07. (LEDGER:2425) trägt bereits
`[d,e,f,g,h,i]Hybrid-Heuristik-Tier-Binary` — dort als **Legende**. Neu: statt der
Legenden-Buchstaben stehen die **vollen Stempelzeilen** in der Klammer.

### 3.2 Kein Widerspruch zur bisherigen Regel
Mittag-10 sagte: *„der Hybrid trägt Mess- UND System-Stempelzeilen, aber KEINE
Organ-Permutations-Identität"*. Er hat weiterhin keine **eigene** Organ-Identität — er führt die
**fremden** mit. Genau die Facade-Rolle: *„virtuelles ganzes Tier-Binary nach außen, Delegation
an die echten Organ-tragenden Tiers"*.

### 3.3 „Überlagert" — Lead-Lesart, Bestätigung ausstehend
Die Owner-Direktive *„SHA fingerprint bleibt gleich"* wird so gelesen: **die bestehende
SHA512-Bildung bleibt**, der Hybrid bekommt ein zusätzliches Preimage-Glied „Tier-Menge" =
**SHA512 über die lexikografisch sortierte Konkatenation** der Tier-Fingerprints.

**Warum nicht bitweises XOR:** `A XOR A = 0` — identische Tiers löschen sich aus; `{A,B}` und
`{A,B,C,C}` bekämen denselben Wert; keine Kollisionsresistenz. Für einen Cache-Schlüssel, an dem
das Skip-Gate hängt, wäre das eine offene Flanke. Die Sortierung liefert die
Reihenfolge-Unabhängigkeit, die der Owner verlangt, ohne diese Eigenschaften.

**Die XOR-Regel im Ledger meint etwas anderes** (LEDGER:2425): `Tier-Binary XOR Hybrid` ist eine
**Verfügbarkeits**-XOR — entweder permutierte Tiers oder ein Hybrid mit statischem Pick, nie
beides. Sie ist keine Aussage über die Fingerprint-Bildung.

---

## 4. Was der Umbau anfasst

### 4.1 Der Parser hat EINEN Angelpunkt
`algo_semver.hpp` dokumentiert `take_flag_tail` als *„die EINE Stelle, an der die
Owner-Q3-Reihenfolge durchgesetzt wird … Beide Parser teilen sie sich, damit die Grammatik nicht
zweimal existiert und nicht driften kann."* Der Umbau hat damit einen Ort, nicht dreißig.

### 4.2 Sechs Bruchstellen
1. **Kardinalität** 1 → n: `take_hardware_flag` konsumiert genau ein `char`, `HardwareFlag` ist
   ein Skalar-Enum
2. **`e`-Position**: war Suffix nach dem HW-Flag, ist jetzt gleichrangiger Filter
3. **`e`-Bedeutung**: experimental → efficiency
4. **Der Punkt kollidiert mit dem SemVer-Punkt** — der Parser muss Tripel-Segmente von
   Flag-Segmenten trennen. *Lead-Empfehlung: Punkt auch vor dem ersten Flag* (`1.0.0.c.p.e`),
   dann ist jedes Segment gleich behandelt und „Reihenfolge egal" gilt syntaktisch ausnahmslos.
5. **Komposit-Klammern** `{…}` sind eine neue Syntax-Ebene neben `[…]`
6. **POD-Kodierung**: Bit 0 = experimental, Bits 1–2 = HW-Flag (4 Werte). Beide zu eng.
   **Entlastung:** 26 der 32 Bit sind frei — `sizeof == 48` muss nicht brechen.

### 4.3 Weitere Betroffene
- **B12-Wache** *„ce-Registry trägt NIE 'e'"* — wird sinnwidrig, `e` ist ein legitimer Filter
- **Negativ-Test-Batterie** `v1.0.0cc`, `v1.0.0cg`, `v1.0.0ec` — kehren sich um
- **138 Bestands-Literale**
- **THESIS (Quellrang 1)**, `anhang/de/D_building_block_matrix.tex:1138`:
  *„Das Hardware-Flag ist genau ein Kleinbuchstabe"* — muss nachgezogen werden, DE führt

### 4.4 Was NICHT gebaut werden muss (bestätigt statt gebrochen)
- **LEDGER §40.a:2402** trägt die per-Flag-Signatur bereits verbatim
- **LEDGER §37:2348/2356** trägt die Fähigkeitsstufen-Permutation
- **`simd_build_gate.hpp`** trägt die Routen-Leiter NoExtension→Avx2→Avx512, *„kumulativ"*
- **`simd_organ_sensibility.hpp`** trägt die Organ-Sinnhaftigkeit inkl. leerer Mengen
- **Die Leiter ist nur INERT**: `static_assert(!any_organ_declares_required())` — alle neun
  Organ-Klassen tragen die Leermenge. Sie scharfzuschalten ist ein eigener, kleiner Schnitt.

---

## 5. Bau-Reihenfolge (Vorschlag)

**Grundsatz: EIN Byte-Ereignis, kein zweiter Neuanker.** Jede Zwischenstufe mit uneindeutigen
Stempeln ist ein Zustand, in dem Caches falsch treffen.

| Stufe | Inhalt | Byte-Ereignis? |
|---|---|---|
| **S1** | Grammatik-Kern: Parser auf n Flags + Punkt-Trennung + Komposit-Klammern, `HardwareFlag` → Flag-Menge, POD-Kodierung breiter | nein (noch kein Literal geändert) |
| **S2** | Wachen umdrehen: B12, Negativ-Batterie, `cpu_only_policy`, die fünf ENFORCE-Stellen | nein |
| **S3** | **Migration der 138 Literale** auf die neue Schreibweise, in EINEM Commit | **JA — der eine Neuanker** |
| **S4** | Klassennamen-Wache (`static_assert`) additiv | nein |
| **S5** | SIMD-Leiter scharfschalten: Organ-Klassen deklarieren ihre required-Flags | ja, aber getrennt entscheidbar |
| **S6** | Hybrid-Stempelzeile + Tier-Mengen-Glied im Preimage | ja, eigenes Fenster |
| **S7** | Thesis-Nachzug (DE führt, EN nachziehen) | nein |

---

## 6. Offene Owner-Entscheide

1. **Punkt vor dem ersten Flag?** `1.0.0.c.p.e` (Empfehlung) oder `1.0.0c.p.e`
2. **Klassenname: Wache oder Quelle?** (Abschnitt 2.3)
3. **„Überlagert" = SHA über sortierte Konkatenation?** (Abschnitt 3.3) — bei echtem XOR muss
   die Duplikat-Auslöschung als bewusster Entscheid gebucht werden
4. **Companion-Flags ohne Klammer?** `…{x512.f}.gfni` — sie sind keine Breiten-Eigenschaft
5. **`v`-Präfix**: die rohe Form verlangt heute `v1.0.0c`, die gerenderte ist `1.0.0c`. Der Owner
   schreibt durchgehend ohne `v`. Bleibt die rohe Form mit `v`, oder fällt das Präfix?

---

## 7. OWNER-ENTSCHEIDE 07.08. nachmittags — ALLE FUENF BEANTWORTET, ZWEI KORREKTUREN

**Owner verbatim:** *"Wir muessen keine Compiler Unterschiede Weg-normalisieren, weil jeder
Compiler einen eigenen Permutations-Zweig an binaries erzeugt. Sie MUESSEN sich unterscheiden.
[...] 1. Ja punkt vor dem ersten Flag. 2. Wache und string view Definition in jeder Organ-Klasse
als einzukompilierende Definition. 3. Wir brechen es und definieren es wie hier geschehen neu.
Regel: Hinter [ gibt es keinen fuehrenden Punkt. Bitte empfohlen sortierte Konkatenation.
Frage 4: ja o[h]ne Klammern und einfach durch Punkt trennen. Frage 5: Ja das v faellt jetzt"*

### E-1 COMPILER-UNTERSCHIEDE SIND GEWOLLT -- mein Risiko-Einwand ist ENTKRAEFTET
Jeder Compiler erzeugt einen **eigenen Permutations-Zweig** an Binaries; die Fingerprints
**MUESSEN** sich unterscheiden. Damit faellt der Grund, den CT-Klassennamen zu normalisieren --
und der Grund, ihn aus dem Stempel herauszuhalten, ebenfalls. Abschnitt 2.3 ist insoweit
ueberholt: es gab kein Problem.

### E-2 KLASSENNAME: WACHE **UND** string_view-DEFINITION
Beides, nicht eines von beidem: die `string_view`-Definition bleibt **in jeder Organ-Klasse** als
einzukompilierende Definition, und die CT-Wache prueft sie gegen den ausgelesenen Klassennamen.

### E-3 DER HYBRID -- OWNER-RUECKNAHME
Owner verbatim: *"mein Fehler, ja der hybrid wird ja zu seiner Laufzeit konfiguriert und gesetzt
und ist nur ein Multi-Signal-Mutex der an das richtige Tier-Binary durchleitet."*
=> Der Hybrid schreibt **NICHT** die vollen Stempel seiner Tiers aus. Die Regel aus mittag-10
bleibt unveraendert gueltig: er traegt Mess- und System-Stempelzeilen, **keine
Organ-Permutations-Identitaet**. Abschnitt 3.1/3.2 dieses Dokuments ist damit **zurueckgenommen**.
Sein Fingerprint leitet sich weiterhin aus den durchgeleiteten Tier-Fingerprints ab --
**per SHA512 ueber die lexikografisch sortierte Konkatenation**, nicht per XOR (Owner: *"Bitte
empfohlen sortierte Konkatenation"*).

### E-4 DIE FUENF SYNTAX-ENTSCHEIDE
| # | Frage | Entscheid |
|---|---|---|
| 1 | Punkt vor dem ersten Flag? | **JA** -- `1.0.0.c.p.e` |
| 2 | Klassenname Wache oder Quelle? | **BEIDES** (E-2) |
| 3 | Ueberlagerung | **sortierte Konkatenation**, kein XOR |
| 4 | Companion-Flags | **ohne Klammern**, durch Punkt getrennt |
| 5 | `v`-Praefix | **FAELLT** |

### E-5 ZUSATZREGEL: HINTER `[` KEIN FUEHRENDER PUNKT
Owner verbatim: *"Hinter [ gibt es keinen fuehrenden Punkt."* Die Meta-Meta-Klammer beginnt
unmittelbar mit dem ersten Eintrag.

### E-6 KORREKTUR MEINES EIGENEN DESIGNS (Abschnitt 1, war falsch)
Ich hatte die Meta-Meta-Gruppe **am einzelnen Achsen-Eintrag** notiert. Falsch. Der Bestand haengt
sie **ans ENDE der Realm-Zeile** -- nach Owner-E2 vom 02.08.: *"wird sie auch einfach dynamisch ans
Ende der Kette in den bestehenden Zeilen angehaengt"*, im Header als Zusage (1) festgehalten:
*"nie als eigene Zeile und nie zwischen die Haupt-Achsen"*. Das deckt sich mit der
Owner-Beschreibung `[Mess-Achse,...Mess-Meta-Meta][System-Achse,...][Organ-Achse,...]`.
Die **Komposit-Flags** dagegen sind je Algorithmus -- das ist die neue Ebene.

---

## 8. DIE FINALE GRAMMATIK (bindend)

```
realm-zeile := <eintrag> [ ';' <eintrag> ]* [ <meta-meta-gruppe> ]
eintrag     := <achse> '=' <klasse> '@' <version>
version     := UINT '.' UINT '.' UINT [ '.' <flag> ]*
flag        := <einzel> | <komposit>
einzel      := 'c' | 'p' | 'e' | 'g' | 'f' | 'n'
             | 'gfni' | 'vaes' | 'vpclmulqdq' | 'fma' | 'f16c' | ...   (Companion, ohne Klammer)
komposit    := '{' <basis> [ '.' <sub> ]* '}'
basis       := 'x128' | 'x256' | 'x512'
meta-meta-gruppe := '[' <eintrag> [ ';' <eintrag> ]* ']'

KLAMMER-REGEL (Owner 07.08.): hinter '[' UND hinter '{' steht NIE ein fuehrender Punkt.
Die Klammer beginnt unmittelbar mit ihrem ersten Element. Der Punkt trennt nur INNERHALB
einer Ebene und VOR einer oeffnenden Klammer ('...c.{x512.f}').
```

**KEIN `v`-Praefix mehr.** Rohe und gerenderte Form fallen damit zusammen.

**Beispiele:**
```
Organ:    memory_layout=SoaMemoryLayout@1.0.0.c.p.{x512.f.vl.bw.dq}.gfni
System:   simd=x512.f@1.0.0
Realm:    search_algo=Art@1.0.0.c;node_type=Node4@1.0.0.c[simd=x512.f@1.0.0]
```

**`e` = efficiency core.** Die Bedeutung *experimental* ist ersatzlos deprecated.
**Reihenfolge sachlich egal, formal eingehalten.**

---

## 9. OWNER-ENTSCHEIDE F-1..F-10 (07.08. spaeter Nachmittag) — ALLE ZEHN BEANTWORTET

### F-1 · Was gestempelt wird: (a) das `string_view` der Wache
Owner verbatim: *"Dort steht ein std::string_view der Wache, die in der Klasse nochmal
statisch/compile time mit ihrem internen auslesbaren Stempel benannt und versioniert wird, dieser
wird beim compile time bau einfach zur compile time ausgelesen und in die jeweilige binary
uebernommen samt Metaprogrammierung fuer die String syntax und semantik."*
=> **STRUKTUR-VORGABE:** es gibt **mehr als nur die Wache** je Klasse -- die statischen Eintraege
folgen dem **Schema eines Organ-Algorithmus unter einer Achse**, nach einem gemeinsamen
**abstrakten Klassen-Schema, von dem ALLE Organe bezueglich Versionierung erben:
`compile_time_organ_version`.**
Das ist ein eigener Bau-Posten: die abstrakte Basis existiert heute nicht; die Achsen tragen
`name()` und `algo_version` einzeln und unverbunden.

### F-2 · `e` und `p` sind SUB-Flags unter `c`
Owner verbatim: *"Das sind jetzt efficiency cores als sub-Flag unter c fuer CPU code."*
=> `c` ist die Basis, `p` (performance core) und `e` (efficiency core) sind ihre Verfeinerungen.
**Validierungsregel:** `p` oder `e` ohne `c` ist ungueltig.
**Schreibweise:** flach mit Punkt (`1.0.0.c.p.e`) -- die Sub-Beziehung ist semantisch, nicht
syntaktisch geklammert. (Owner-Beispiel `memory@1.0.0c.p.e.{...}` zeigt sie flach.)
=> Das alte experimental-Bit 0 im POD wird damit frei.

### F-3 · POD-Kodierung: HASH
Die Flag-Menge wird als **Hash** der normalisierten Flag-Zeichenkette kodiert, nicht als Bitmaske
ueber einen festen Katalog. Damit ist die Katalog-Groesse nicht gedeckelt.

### F-4 · Migration: **(a) UND (b)**
Owner verbatim: *"a UND b. Das v weg und alle 138 Stellen tragen die Anzeige von dem was sie
leisten."*
=> Nicht nur mechanisch. **Jede der 138 Stellen bekommt ihre ECHTEN Flags** -- was der Algorithmus
tatsaechlich leistet. Das ist inhaltliche Arbeit je Achse und braucht die
Sinnhaftigkeits-Matrix (`simd_organ_sensibility.hpp`) als Quelle.

### F-5 · `x128` bleibt — mit Recherche-Auftrag
Owner verbatim: *"Korrekt, bitte Webrecherche ueber alle SIMD Versionen und Vorgaenger
Erweiterungen fuer 32bit UND 64 bit ISA. In Indien ist 32bit noch aktuell unter Windows 10.
Bitte zieh das autonom gerade."*
=> **Workflow `wf_93522b50-447` laeuft** (5 Lenses: x86-Historie MMX..AVX10, AVX-512-Subsets,
32-bit-Lage IA-32, Companion/Scalar, ARM/RISC-V + Vektorlaengen-Agnostik).

### F-6 · `x256` ist selbst ein Komposit-Flag wie `x512`
Owner verbatim: *"Es ist x256 und per web recherche mal die wenigen Spezial-Komposit-Flags
raussuchen, die es haben kann. Es ist auch selbst ein Komposit-Flag wie x512."*

### F-7 · NUR der Punkt
Owner verbatim: *"Ja wir verwenden NUR den Punkt."* => `avx512_vbmi2` -> `{x512.vbmi2}`.
Unterstriche der Katalog-Token fallen in der Notation weg.

### F-8 · Scalar-Flags: uniform, System-Achse gibt frei, Organ baut ein
Owner verbatim: *"Sie werden uniform angegeben und in der System-Achse definiert freigegeben und
koennen bei Machbarkeit und verfuegbarkeit von SIMD-faehiger Software in den Organ-Achsen
eingebaut werden wie beschrieben - Optimierung je Achsen-Algorithmus in getrennter Auspraegung
dort."*

### F-9 · DER HYBRID HAT EINE EIGENE ORGAN-ACHSE — die sortierte Konkatenation ENTFAELLT
Owner verbatim: *"Die sortierte Konkatenation wird nicht, wir schreiben auf den Hybriden doch nur
Mess-Achse/System-Achse/Hybrid-Organ-Achse. Hybride haben ihre eigene Adapter Gattung und damit
eigene Achsen und eigene Organ-Algorithmen, daher existiert eine Hybrid-Organ-Achse die auf die
optimierte heuristische Weiterleitung anhand der Messkurven und auswertungsergebnisse abzielt, die
zu beginn der Messung (initialisierung) am Pruefdock durch die CEB uebermittelt werden."*
=> **NEU UND WICHTIG:** der Hybrid hat eine **eigene Adapter-Gattung** mit **eigenen Achsen** und
**eigenen Organ-Algorithmen**. Seine drei Realm-Zeilen sind
**Mess-Achse / System-Achse / HYBRID-Organ-Achse**. Die Hybrid-Organ-Achse traegt die
**optimierte heuristische Weiterleitung** anhand der Messkurven und Auswertungsergebnisse, die die
CEB bei der **Initialisierung am Pruefdock** uebermittelt.
=> Damit ist die mittag-10-Regel *"Hybrid traegt KEINE Organ-Identitaet"* praezisiert: er traegt
keine **Tier-Organ**-Identitaet, sehr wohl aber seine **eigene Hybrid-Organ**-Achse. Sein
Fingerprint bildet sich damit **regulaer aus seinen eigenen neun Gliedern** -- kein Sonderweg,
keine Konkatenation, kein XOR.
=> Abschnitte 3.1/3.2/3.3 dieses Dokuments sind damit **vollstaendig zurueckgenommen**.

### F-10 · Ersatz fuer die B12-Wache: bestaetigt
Owner: *"Der vorschlag trifft ins Schwarze. Genau so."*
=> Die alte Wache *"ce-Registry traegt NIE 'e'"* wird ersetzt durch
**"ce-eigene Achsen tragen mindestens `c`"**.

### KLAMMER-REGEL, vervollstaendigt
Owner: *"und hinter { steht auch nie direkt ein fuehrender Punkt"*
=> Hinter **`[`** UND hinter **`{`** steht nie ein fuehrender Punkt.

### F-9 BESTAETIGT (Owner, unmittelbar danach)
Owner verbatim: *"Ja genau, der Hybrid hat seine eigenen Organ-Achsen fingerprint und ebenfalls
Mess/System/Organ/SHA Zeilen"*
=> Der Hybrid traegt **die vollen vier Zeilen wie jede Tier-Binary**: Mess-Achse, System-Achse,
**eigene** Organ-Achse (die Hybrid-Adapter-Gattung) und die SHA-Zeile. Kein Sonderformat, kein
Sonderweg in der Fingerprint-Bildung -- nur ein anderer Organ-Inhalt.

### F-2 KORRIGIERT (Owner, 07.08. spaet): `c{p.e}` -- p und e sind je ein KOMPOSIT-FLAG
Owner verbatim: *"Ich will fuer cpu gerne c{p.e}, waehrend {p} fuer die performance cores default
ist. p und e sind je ein Komposit-Flag"*

=> **Die Schreibweise ist `c{p.e}`, NICHT `c.p.e`.** Meine flache Lesart war falsch.
- `c` ist die **Basis** (CPU), unmittelbar gefolgt von ihrer Komposit-Klammer -- **ohne Punkt
  zwischen Basis und Klammer**, analog zur Klammer-Regel "hinter { kein fuehrender Punkt".
- `p` und `e` sind **je selbst ein Komposit-Flag**, koennen also eigene Sub-Flags tragen.
- **`{p}` ist der DEFAULT**: ohne explizite Klammer gilt performance core.
  Daraus folgt: `...@1.0.0.c` == `...@1.0.0.c{p}` semantisch.

**Konsequenz fuer die Grammatik:** die Basis-Klammer-Bindung `<basis>'{'...'}'` gilt einheitlich
fuer `c`, `x128`, `x256`, `x512` -- ueberall Basis direkt gefolgt von der Klammer. Der Punkt
trennt nur zwischen GESCHWISTERN auf derselben Ebene.

```
version  := UINT '.' UINT '.' UINT [ '.' <flag> ]*
flag     := <basis> [ '{' <sub> [ '.' <sub> ]* '}' ] | <companion>
basis    := 'c' | 'g' | 'f' | 'n' | 'x128' | 'x256' | 'x512'
sub      := <token> [ '{' <sub> [ '.' <sub> ]* '}' ]     -- rekursiv, p und e sind selbst Basen
```

**Beispiele:**
```
memory_layout=SoaMemoryLayout@1.0.0.c{p.e}.x512{f.vl.bw.dq}.gfni
search_algo=Art@1.0.0.c                      == ...c{p}  (Default)
simd=x512{f}@1.0.0                           (System-Achse: Flags an der Klassen-Stelle)
```
