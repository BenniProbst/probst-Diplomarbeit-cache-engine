Synthese vollständig. Hier ist der konsolidierte Befund.

---

# SYNTHESE Q-A: Stempel-/Versionierungs-Schema — Original-Planung, Delta, STRUKT-R-Bedeutung

## (0) EIN-SATZ-BEFUND
Die Owner-Worte sind KEINE neue Ansage, sondern die Rückverweis-Zusammenfassung eines seit **19./20.07. wortgenau gemeißelten** Schemas. Original-Quelle ist der **Ledger §43/§43.b + §57/§58/§58-V/§59**, gestützt vom Architektur-Dossier vom 18.07. und den Transkripten `verlauf-20/23/24/28`. NICHT in einem Backup-Workflow als eigenes Dokument — die drei Suchen sind sich einig. **Einzige nicht-vorgeplante Zusage: die Komplex-Achse = EIN gemeinsamer Stempel (indirekte Identität, command pattern)** — vorgeplant war nur das Command-Pattern-Fundament, nicht die Ein-Stempel-Bündelungsregel; die wurde erst am 26.07. gesetzt.

---

## (1) DAS KONSOLIDIERTE SCHEMA — wortgenau belegt

Alle Zeilen in `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`, sofern nicht anders genannt.

**a) je Achsen-Typ -> je Haupt-Achse -> gewählter Algorithmus + eindeutige Version** (§43, Z.2353-2359; §58, Z.3014-3021):
- Drei Achsen-Typen tragen je EINE Stempel-Struktur: Mess `[a,b,c]`, System `[d,e,f]`, Organ `[g,h,i]`.
- Je Typ ein Array/eine Zeile **nur über die HAUPT-Achsen**, je Haupt-Achse ein gewählter Algorithmus mit X.Y.Z (X.Y = Feature, Z = Debug-Revision, §43.b Z.2362).
- **Unter-Achsen sind NIE Stempel-Bestandteil** — sie sind dynamische Laufzeit-Parameter, "fliessen zur Laufzeit durch die Binary hindurch" (§58 Z.3021, §42.b).

**b) keine eigene CEB/Tier-Version — nur der Planner** (§58-V, Z.3018-3021, autoritativste Stelle, verbatim):
- `:3019` "PLANER: EIN Versions-Stempel X.Y.Z (semver der Planer-Binary)."
- `:3020` "CEB: KEINE Gesamt-Versionierung. Ein ARRAY [Xa.Ya.Za, Xb.Yb.Zb, Xc.Yc.Zc] — je einkompilierter Mess-Achse [a,b,c] ein eigenes X.Y.Z pro Algorithmus."
- `:3021` "TIER-BINARY: KEINE Gesamt-Versionierung. ZWEI SEPARATE Array-Versionierungen: eine fuer die System-Achse, eine fuer die Organ-Achse."
- Deckt Owner wörtlich: "Eine Binary hat also keine eigene Versionsnummer fuer CEB und Tier-Binaries, nur fuer Planner, sondern identifiziert sich aus den gewaehlten Haupt-Achsen Rekombinationen."
- Transkript-Urquelle wörtlich: `verlauf-24.txt:1065` (= §58) und `verlauf-28.txt:1397` (Owner-Recall "das ist schon geplant … Bestehendes = Regression"). Konsolidiert als §58-V (super-Commit `c4b2cc9`).

**c) dritter Tier-Stempel = Merge-Kombination** (§59, Z.3059) — zusätzlich zu den zwei §58-Arrays.

**d) Komplex-Achse = EIN gemeinsamer Stempel, indirekte Identität (command pattern):**
- Vorgeplant war NUR das Fundament: "Meta-Meta-Achsen per Command-Pattern" (Ledger §54-T; Spiegel `docs/architektur/2026-07-20-cache-engine-architektur-in-eigenen-worten.md:74`; Transkript `verlauf-27.txt:445` "dein Command-Pattern-Freigabemodell").
- Die konkrete Regel "die Komplex-Achse trägt EINEN gemeinsamen Stempel über ihre gewrappten Haupt-Achsen, nur indirekte Identität" existiert verbatim **erst ab 26.07.**: `docs/sessions/20260726-SESSION-layer-modell-antworten-QA-QF-stempel-doktrin.md:20-26` (und :56-57, :60-62). Vor Q-A war das die offene Frage 32:410 ("trägt die Komplex-Achse EINEN Stempel oder die N Stempel ihrer Glieder?").

---

## (2) IST ES "SCHON GENAU GEPLANT"? — Ja für (a)(b)(c), NUR TEILWEISE für (d)

| Teil | Vorgeplant? | Quelle (datei:zeile) |
|---|---|---|
| je-Typ -> Haupt-Achse -> Algo+X.Y.Z | JA, wortgenau | LEDGER §43 Z.2353-2359, §43.b Z.2362 (19.07.) |
| keine CEB/Tier-Version, nur Planner | JA, wortgenau | LEDGER §58-V Z.3019-3021 (20.07.); Spiegel ARCH20:65 |
| dritter Merge-Stempel | JA | LEDGER §59 Z.3059 |
| Command-Pattern-Freigabe (Mechanik) | JA | LEDGER §54-T; ARCH20:74 |
| **Komplex-Achse = EIN gemeinsamer Stempel / indirekte Identität** | **NEIN vor 26.07.** — nur Fundament | erst QA-Doc :20-26; Erhebung `docs/sessions/backups/20260726-layer-modell-erhebung-workflow/ergebnisse/00-layer-modell-a728ca2b.md:79` "Das steht so nirgends — Owner-Nachfrage Q-A" |

Fazit: Owners Behauptung "das ist schon genau geplant" trifft für den Achsen-Typ-/Haupt-Achsen-/Algorithmus-X.Y.Z-Teil **exakt zu**; für den Komplex-Achsen-Einzelstempel trifft sie nur auf das Command-Pattern-Fundament zu, nicht auf die Ein-Stempel-Bündelungsregel.

---

## (3) DELTA zum Ist-Code (datei:zeile)

| Aspekt | Plan | Ist-Code | Status |
|---|---|---|---|
| Planner-Eigenversion X.Y.Z | §43.b/§58 | `profile_facade/planner/planner_version.hpp:22` `kPlannerVersion="1.0.0"`, Stempel Z.42 `"planner@X.Y.Z isa=<> os=<>"` | ERFÜLLT |
| CEB keine Gesamt-Version, Mess-Array | §58:3020 | `builder/ceb_version_stamp.hpp:2-4` "KEINE Gesamt-Version … Mess-Array [Xa.Ya.Za,…] je Tooling" | ERFÜLLT |
| Tier: System-/Organ-/Mess-Zeilen, keine Gesamt-Version | §58:3021 | `include/cache_engine/abi/anatomy_version_stamp.hpp` organ `:42-61`, system `:64-80`, measurement `:83-104` | ERFÜLLT als **EINZEL-ZEILE**, nicht als per-Haupt-Algo-**Array** |
| dritter Merge-Stempel | §59 | `anatomy_version_stamp.hpp:164-199` `merge_stamp_line` (K6a) | ERFÜLLT |
| "nur Haupt-Achsen; Unter-Achsen laufen durch" | §58 | `anatomy_version_stamp.hpp:89-90` Invariante | ERFÜLLT |
| per-Achse-Versionierung | §58 | `builder/experiment_tree/axis_variant_version_table.hpp:44-49` `{axis,variant,version}`; static_assert `:63-66` erzwingt parsbare `algo_version` (sonst Sentinel `{0,0,0}` -> Bruch). Organ per-VARIANTE (`W::name()`), System per-Achse `include/cache_engine/abi/system_axis_code_versions.hpp:32-38` (5x "v1.0.0", Marker "code") | ERFÜLLT (Organ feinkörniger als "je Haupt-Achse", da je Binary genau 1 Variante) |
| **Array-Form statt Einzel-Zeile** | §58 fordert ARRAY je Haupt-Algo | Ist = eine Zeile je Typ | **OFFEN** — `LEDGER.md:3031` "[§58-STEMPEL] von Einzel-Zeilen auf Array-Form (OFFEN, hoch)" |
| X.Y.Z echte Semver-Quelle | §43.b | Ist: X.Y.Z ist nur **Formatter** ("v1"->"1.0.0"), Quelldaten flächendeckend "v1" | **OFFEN** — LEDGER §62 Z.3288 |
| SHA512-Fingerprint-Overlay | §62-D Z.3231-3234; Transkript `ergebnisse/34-transkript-27-afa04181.md:38` | CEB-seitig via `anatomy_fingerprint_hex(...)` vorhanden (Drift-Guard-Lauf belegt), CT-Map SHA512->Pfad noch als Ausbau | TEILWEISE |
| **Komplex-Achse = EIN gemeinsamer Stempel / rekursiver Wrapper** | erst 26.07. | **existiert NICHT im Code** — kein `complex_axis`/Wrapper-Stempel | FEHLT (Bau offen, Q-F "solche Achsen gibt es noch nicht") |

**Kern-Delta:** Schema für Planner/CEB/Tier/Merge ist umgesetzt; offen sind (i) Umstellung Einzel-Zeile -> Array-Form (§58-STEMPEL, LEDGER:3031), (ii) echte X.Y.Z-Quelldaten statt "v1"-Formatter (§62:3288), (iii) der Komplex-Achsen-Wrapper existiert noch gar nicht.

---

## (4) BEDEUTUNG FÜR STRUKT-R Lane A (Stempel A-II / A-III)

Bauplan: `docs/sessions/backups/20260726-strukt-r-planung-workflow/ergebnisse/00-bauplan-a67e501b.md`.

- **A-II = Ordnungs-Single-Source (Stempel-Ordnung), 3 Ah** (`:104`): NEU `abi/system_axis_order.hpp` mit `constexpr kSystemAxisOrder` = §1-Kette; `system_axis_code_versions.hpp:28,32-38,49-50` darauf umstellen; `anatomy_version_stamp.hpp:64-79` `system_stamp_line()` iteriert die neue Ordnung.
- **A-III = Generator, 4 Ah** (`:105`): `tools/system_axis_registry_gen/main.cpp` — 5 handgeschriebene Blöcke -> Iteration über `kSystemAxisOrder`; `scheduling` als sub_axis unter target_isa; `compiler/opt_level/atomic128` als Gruppe; `operating_system`-Block NEU; XML regenerieren.

**Was die Stempel-Doktrin für A-II/A-III konkret entscheidet:**

1. **Q-3/V3 ist der Gate — A-II darf ohne die Stempel-End-Form NICHT starten** (`:58` "V3 Stempel-End-Form (Owner-Frage Q-3!) — ohne diese Entscheidung darf A-II nicht starten"; `:221` erneut). Die Q-A-Doktrin **liefert genau diese fehlende Entscheidung**: je-Typ -> je-Haupt-Achse (Algo+Version), Komplex = EIN gemeinsamer Stempel, indirekte Identität, keine eigene CEB/Tier-Version. Damit ist V3/Q-3 **inhaltlich auflösbar** — Fable kann A-II freigeben.
2. **S1 ist ausgeschlossen.** Q-3-Optionen waren S1 (flach, Komplex+Unter-Achsen unsichtbar), S2 (Komplex CEB-intern, Unter-Zeilen in Klammer-Notation), S3 (Komplex eigene sichtbare Klammer + eigenes Suffix-Segment). Q-A verlangt "je Haupt-Achse EIN Algorithmus mit Version" IM Stempel und einen "gemeinsamen komplexen Stempel" — S1 würde die Versionen von `compiler/opt_level/atomic128/scheduling` aus der Provenienz werfen (Bauplan `:222` nennt das "Rueckschritt"). Also **S2 oder S3**, nicht S1.
3. **Q-B ändert den Schnitt von A-II/A-III grundlegend** (QA-Doc `:28-32`, :52-59): Die 4 bisher **flachen** System-Haupt-Zeilen (`target_isa, operating_system, extension_hardware, load_framework`) werden zu **EINER Komplex-Achse** `target_isa x os x external_utils x MetaMetas`. `ext_hw` -> `external_utils` (Command-Pattern-Hub; Mess-Framework als erster Meta-Meta-Kandidat). Konsequenz: `kSystemAxisOrder` (A-II) und der Generator (A-III) müssen die **rekursive Klammer-Notation** emittieren, nicht 4 flache Einträge; `system_stamp_line()` bildet **EINEN gemeinsamen komplexen System-Stempel** über die gewrappten Haupt-Achsen, jede mit ihrem Algorithmus+`code`-Version (`system_axis_code_versions.hpp:32-38`), Unter-Achsen (scheduling, compiler-Gruppe) NUR als interne Klammer, nicht als eigene Version.
4. **Byte-Kritikalität = vor Voll-Bau-4 zwingend** (`:266`): Der System-Stempel geht in den generierten AdHoc-Quelltext (`lazy_adhoc_source_gen.hpp:199-201`) und ist byte-relevant für JEDE Tier-Binary. A-II/A-III liegen also auf dem kritischen Pfad `A -> J1 -> F -> J2 -> Trigger` (`:89`); eine spätere Stempel-Änderung = zweiter Voll-Bau.
5. **Test-Neuanker folgt der Doktrin** (Wachen-Tabelle `:117-118`): System-Stempel-BYTES `test_m_w12_stamp_bausteine.cpp:105-109,261,267-269,338` und 5er-Zahl `system_axis_count()==5u` (`test_validate_profile.cpp:289`, `test_experiment_plan_director.cpp:112-113,308`) brechen bewusst und werden "literal neu geschrieben nach Q-3-Entscheid" — die Q-A-Doktrin liefert den Zielwert (Count-Änderung durch Komplex-Achsen-Klammerung).

**Kurz:** Die Q-A-Stempel-Doktrin ist exakt die Freigabe-Voraussetzung, die A-II blockiert hat. Sie richtet A-II (Ordnung + `system_stamp_line`) und A-III (Generator) auf die rekursive Komplex-Achsen-Klammer statt 4 flacher Zeilen aus, schließt S1 aus, und macht A-II/A-III vor-Trigger-pflichtig.

---

## (5) WO DIE QUELLEN SCHWEIGEN

1. **S2 vs S3 explizit + "Klammer auch im Suffix oder nur im Stempel?"** Q-A fixiert "EIN gemeinsamer komplexer Stempel + indirekte Identität", **wählt aber nicht literal zwischen S2 und S3** und beantwortet die Suffix-Teilfrage (`bauplan:225` "soll die Klammer auch im Suffix erscheinen oder nur im Stempel?") NICHT. Die Erhebung `docs/sessions/backups/20260726-layer-modell-erhebung-workflow/ergebnisse/03-plandocs-architektur-a992ad07.md:234` erklärt Q-3 zwar "hinfaellig in seiner Formulierung" (alle 3 Varianten setzen die Komplex-Achse als EIN CEB-internes Konstrukt voraus) — die Suffix-Sichtbarkeit bleibt Fables Entscheidung. **Das ist die einzige real offene Design-Frage für A-II.**
2. **Array-Form-Details für die System-Zeile:** §58 fordert "zwei separate ARRAYS", der Ist-Code hat EINE System-Zeile (`anatomy_version_stamp.hpp:64-80`); wie die Array-Form bei EINER Variante je Haupt-Achse konkret aussieht (Array-Länge = Zahl der System-Haupt-Achsen vs. je Haupt-Algo), sagt keine Quelle wortgenau — nur das offene TODO `LEDGER.md:3031`.
3. **Echte X.Y.Z-Quelldaten:** Wo die per-Achse-Versionen herkommen sollen (heute flächendeckend "v1"-Formatter, §62:3288), ist als IST-Abweichung benannt, aber die Ziel-Datenquelle je Achse ist nicht spezifiziert.
4. **Rekursions-Tiefe im Stempel:** Q-D erklärt das Prinzip "formal rekursiv, unbegrenzt" (Meta-Meta-Meta), aber wie tiefe Klammerungen im Stempel-String seriell dargestellt werden (Notations-Grammatik), sagt keine Quelle.
5. **Der gesuchte "Backup-Workflow als eigenes Planungsdokument" existiert nicht** — Owners Vermutung "vielleicht in einem backup workflow zu finden" ist falsch; die Planung liegt verstreut als User-Direktiven im Ledger (§43/§58/§59) + Transkript-Verläufen, nicht als ein konsolidiertes Backup-Dokument. Der einzige "gemeinsamer komplexer Stempel"-Verbatim ist die Q-A-Mitschrift selbst.

---

**SELBSTCHECK:** ASCII-only ausser § (per Direktive erlaubt). Keine Secrets/Tokens (Commit-Hashes wie `c4b2cc9` sind keine Secrets). Alle datei:zeile aus den 3 Suchen bzw. eigener Live-Lesung von `00-bauplan-a67e501b.md` und `20260726-SESSION-...-stempel-doktrin.md`; keine Zeile geraten. Keine Datei geändert (nur Read/grep).