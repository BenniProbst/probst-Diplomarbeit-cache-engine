# VL-6a-Explorer: S-6d-Neuerhebung "Familien-Header" (Erhebung 17.08.2026, ce @ 04ac26fa, read-only)

## 0. Vorbemerkung zur Quellenlage (geprueft)

- Ledger-Fundstelle der 29er-Definition: `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:2729-2735` (KON61-05), woertlich: *"Familien-Header = basename enthaelt version|stamp|semver|fingerprint (24 Dateien in libs/cache_engine); eingehende Include-Zeilen = 29 von 29 (repo-weit 39 = libs 29 + tests 9 + apps 1)."*
- WICHTIGER GEGENFUND (FALLEN-Regel "KON-Nummern kein Autoritaetsbeleg" bestaetigt sich hier konkret): `docs/plaene/20260813-DESIGN-zielstruktur-vier-traeger-unterprojekte.md:134` zeigt, dass die ALTEN Zahlen ("4 Familien, 142 Include-Kanten / 29 Wanderungen") sich urspruenglich auf die VIER TRAEGER-PROJEKTE (planner/ceb/tier/hybrid) bezogen, nicht auf "version/stamp"-Header. KON61-05 hat "29" NEU als Basename-Match-Definition reproduziert und diese Definition per Owner-Wort ("Bitte explore und schaerfen, behalten") UEBERNOMMEN — das ist die Definition, die mein Auftrag mir vorgibt und die ich befolgt habe.

---

## 1. Datei-Erhebung — deklarierte Zaehlweise + Liste

**Deklarierte Zaehlweise:**
- **Muster:** `basename` (letzter Pfadbestandteil) enthaelt case-insensitiv einen der Substrings `version|stamp|semver|fingerprint` (kein Wortgrenzen-Anker).
- **Scope:** rekursiv unter den drei Wurzeln `libs/`, `tools/`, `include/` (Repo-Root). Ein eigenstaendiges Top-Level-`include/` existiert in diesem Repo NICHT (verifiziert: `find . -type d -name include` findet nur Nested-Dirs unter `libs/*/include`, `libs/*/vendor/*/include`, `tools/p27_bundle_finder/include` — keiner davon traegt einen Treffer).
- **Ausschluesse:** jeder Pfad mit Segment `build/` oder `ext/` (an dieser Stelle wirkungslos, da keiner der 25 Treffer dort liegt).
- **Datei-Typ:** Punkt 1 verlangt reinen Basename-Match OHNE Endungsfilter → 25 Dateien. Fuer Punkt 2 (Include-Kanten in "Koepfe") wurden davon nur die 23 echten `.hpp`-Header als Ziel benutzt (nur Header koennen sinnvoll `#include`-Ziel sein); die 2 Nicht-Header (`.lock`, `.cpp`) werden separat ausgewiesen.

**Liste (25 Dateien, Pfade repo-relativ):**

*libs/cache_engine (23 .hpp):*
```
builder/bestandslog/fingerprint_key_source.hpp
builder/build_orchestrator/fingerprint_sidecar.hpp
builder/ceb_version_stamp.hpp
builder/experiment_tree/axis_variant_version_table.hpp
builder/experiment_tree/organ_fingerprint.hpp
builder/pruef_dock/pruef_dock_version.hpp
include/cache_engine/abi/anatomy_fingerprint.hpp
include/cache_engine/abi/anatomy_stamp_entries.hpp
include/cache_engine/abi/anatomy_version_stamp.hpp
include/cache_engine/abi/meta_meta_stamp_suffix.hpp
include/cache_engine/abi/system_axis_code_versions.hpp
include/cache_engine/abi/toolchain_stamp_glied.hpp
include/cache_engine/fingerprint/fixed_length_fingerprint.hpp
include/cache_engine/measurement/algo_semver.hpp
include/cache_engine/measurement/axis_version_stamp.hpp
organ_axes/axis_q1_queuing/concepts/axis_q1_queuing_versioned_strategy_concept.hpp
organ_axes/value_handle_axis/axis_14_value_handle_versioned_pointer.hpp
profile_facade/build_type_stamp.hpp
profile_facade/g1_binary_version_stamp.hpp
profile_facade/planner/planner_version.hpp
profile_facade/system_version_suffix.hpp
profile_facade/toolchain_stamp_naht.hpp
topics/value_handle/axis_14_value_handle/axis_14_value_handle_versioned_pointer.hpp
```
*tools/axis_version_lock (2, NICHT Header):*
```
axis_version.lock       (S-14a-Lock-Datenbank selbst, keine .hpp)
axis_version_lock.cpp   (CLI-Implementierung, keine .hpp)
```
Alle anderen `libs/`-Geschwister (common, execution_engine, search_engine, test_infra, traeger — inkl. des frischen `libs/traeger/{planner,ceb,tier,hybrid}`-Skeletons aus #29, geprueft) liefern **0** Treffer.

**Abweichungs-Erklaerung 23 (heute) vs. 23 (17.08 frueh, bestaetigt) vs. 24 (13.08., KON61-05) per git log:**

Innerhalb `libs/cache_engine` (die von KON61-05 genannte Teilmenge) liefert meine Zaehlweise **23**, nicht 24 — und das ist **stabil ueber die gesamte pruefbare Historie**, nicht nur heute:

| Commit | Datum | Anzahl |
|---|---|---|
| `07a60cc7` (Ende Kalendertag 13.08.) | 13.08. 13:46 | 23 |
| `2a3b1eb0` (KON61-01-Referenzpunkt, nahe KON61-05-Messzeitpunkt) | 14.08. 08:16 | 23 |
| `696efef3` (vor #16-Umzug) | 15.08. 05:46 | 23 |
| `5fa37f36~1` (vor golden-fenster-Rekonstruktion) | 15.08. 07:40 | 23 |
| `5fa37f36` (Rekonstruktion, LOESCH-Haelfte fehlte noch) | 16.08. 09:51 | **25** (Uebergangszustand) |
| `2a83e3fe` (Fix, 8 Min. spaeter) | 16.08. 09:59 | 23 |
| `04ac26fa` (HEAD) | 17.08. 07:23 | 23 |

Der EINZIGE Lösch-Event ueber die volle Historie (`git log --all --diff-filter=D`) betrifft ausschliesslich die zwei golden-fenster-Migrationsdateien (`axes/value_handle_axis/axis_14_value_handle_versioned_pointer.hpp` und `topics/queuing/axis_q1_queuing/concepts/axis_q1_queuing_versioned_strategy_concept.hpp`, beide 16.08. 09:59 durch `2a83e3fe` geloescht) — symmetrisch durch die 8 Minuten fruehere Neuanlage unter `organ_axes/...` gedeckt (`5fa37f36`), macht netto **0**. Ergebnis: **die "24" aus KON61-05/13.08. reproduziert an KEINEM git-Objekt-Stand** unter der deklarierten Zaehlweise; der belegbare Wert war zu jedem geprueften Zeitpunkt 23. Bewertung: vermutlich Verzaehlung/Off-by-one im urspruenglichen KON61-05-Zaehlvorgang (oder ein nie committeter Arbeitsstand) — kein realer Datei-Schwund. Die "17.08. frueh: 23" aus meinem Auftrag ist damit voll bestaetigt und zeigt KEINE Bewegung seither.

---

## 2. Include-Kanten-Zaehlung (Punkt 2)

**Deklarierte Zaehlweise:** `grep -rnE '^[[:space:]]*#include'` repo-weit (build/ext ausgeschlossen), Treffer-Zeile geparst auf `#include [<"]<ziel>[>"]`, `<ziel>`-Basename gegen die 22 eindeutigen Basenamen der 23 Header (Punkt 1, Header-Teilmenge) geprueft. **Familien-intern** = die inkludierende Datei ist SELBST einer der 23 Header (ausgeschlossen). Rest klassifiziert nach Top-Level-Verzeichnis der inkludierenden Datei.

**Ergebnis am HEAD (04ac26fa):** 173 rohe Treffer → 27 familien-intern ausgeschlossen → **146 externe Kanten**:

| Bucket | Kanten | Distinkte Dateien |
|---|---|---|
| **libs** | 51 | 37 |
| **tests** | 90 | 44 |
| **apps** | 3 | 2 |
| tools (nicht in KON61-05-Trio benannt) | 2 | 2 |
| **Summe extern** | **146** | 85 |

**Diskrepanz zu KON61-05 (29/9/1=39) — Gegenprobe per git log:** Ich habe dieselbe Zaehlung EXAKT am historischen Referenzpunkt `2a3b1eb0` (14.08., dem in KON61-01 zitierten KF2-Messzeitpunkt) wiederholt — Ergebnis: **identisch** 51/90/3/2 (173 roh, 146 extern). Die Kantenzahl ist seit 14.08. NICHT gewachsen; es handelt sich NICHT um Repo-Drift. Der Unterschied zur zitierten 29/9/1 ist also eine **Methodik-Divergenz**, keine Zeit-Divergenz — ich kann die KON61-05-Zahl unter der woertlich deklarierten Regel ("basename enthaelt ...; eingehende Include-Zeilen ... ohne familien-interne Includes") an keinem Punkt der Historie reproduzieren. Ich lasse das UNAUFGELOEST stehen (kein Rateversuch) und melde es als offenen Klaerungsbedarf — am auffaelligsten: `tests` dominiert bei mir (90) statt `libs` (bei KON61-05 29>9). Meistgezogener Header: `algo_semver.hpp` (23), gefolgt von `anatomy_version_stamp.hpp` (17), `anatomy_fingerprint.hpp` (13).

Vollstaendige Kanten-je-Basename-Tabelle (extern, HEAD=historisch identisch):
```
23 algo_semver.hpp            7  anatomy_stamp_entries.hpp     5 g1_binary_version_stamp.hpp
17 anatomy_version_stamp.hpp  6  toolchain_stamp_naht.hpp      5 axis_14_value_handle_versioned_pointer.hpp (2 Ziel-Dateien! s.u.)
13 anatomy_fingerprint.hpp    6  ceb_version_stamp.hpp         5 planner_version.hpp
11 system_version_suffix.hpp  6  fingerprint_sidecar.hpp       4 axis_q1_queuing_versioned_strategy_concept.hpp
11 axis_variant_version_table.hpp 6 system_axis_code_versions.hpp 3 build_type_stamp.hpp
 7 pruef_dock_version.hpp                                       2 je: organ_fingerprint / toolchain_stamp_glied /
                                                                    fixed_length_fingerprint / fingerprint_key_source /
                                                                    meta_meta_stamp_suffix
                                                                  1 axis_version_stamp.hpp
```
**Caveat:** `axis_14_value_handle_versioned_pointer.hpp` existiert an ZWEI Pfaden (organ_axes/ + topics/, s. Punkt 3) mit identischem Basename — Basename-Matching kann die 5 Kanten nicht eindeutig einer der beiden Dateien zuordnen; 1 davon ist die interne topics→organ_axes-Weiterleitung selbst (bereits als familien-intern ausgeschlossen), die 4 externen (tests) gehen ueberwiegend an die topics-Huelle (`test_v41_axis_14_value_handle.cpp` inkludiert explizit `<topics/value_handle/...>`).

---

## 3. Overlay-Schnitt + S-14a-Lock-Markierung (Punkt 3)

Gegen `builder/overlay_source_set.hpp:130-201` (Struktur direkt gelesen) und `tools/axis_version_lock/axis_version.lock` (718 Records, `grep`-Verifikation je Basename) geprueft:

| Datei | Overlay-Schnitt? | Lock-Record? |
|---|---|---|
| `organ_axes/axis_q1_queuing/concepts/axis_q1_queuing_versioned_strategy_concept.hpp` | JA (Kategorie organ, `queuing_q1`, Zeile 164) | JA — 1 Record (`organ - .../concepts/` + Digest, Version `-`) |
| `organ_axes/value_handle_axis/axis_14_value_handle_versioned_pointer.hpp` | JA (Kategorie organ, `value_handle`, Zeile 152) | JA — 1 Record (`organ 1.0.0.c .../value_handle_axis/`) |
| `topics/value_handle/axis_14_value_handle/axis_14_value_handle_versioned_pointer.hpp` | JA (Kategorie organ, `value_handle`, Zeile 153 — topics-Zweig) | JA — 1 Record (`organ - .../axis_14_value_handle/`) |
| **alle uebrigen 20 Header** | NEIN (liegen in `builder/`, `include/cache_engine/{abi,measurement,fingerprint}/`, `profile_facade/` — keiner dieser Pfade ist ein Eintrag von `kOverlaySourceSet`) | NEIN — 0 Records je Basename |

**17.08.-Karte (GENAU DREI Schnitt-Dateien) VERIFIZIERT — exakt bestaetigt, keine Abweichung.** Die Deckung ist konsistent: Overlay-Mitgliedschaft und Lock-Record fallen fuer alle 23 Header exakt zusammen (3 ja/ja, 20 nein/nein) — die Lock-Grundgesamtheit IST der Overlay-Schnitt (Fixup-3-Entscheid, Task #36), keine Ausnahme gefunden.

Wichtiger NEBENBEFUND (verhindert einen falschen Punkt-4-Vorschlag, s.u.): `topics/value_handle/axis_14_value_handle/...` ist laut `overlay_source_set.hpp:47-59` eine reine **Weiterleitungs-Huelle** (4-5 Zeilen, `#include <organ_axes/...>`), die den Basenamen ihres organ_axes-Vorbilds ABSICHTLICH teilt. Ich habe das gegen 4 weitere Achsen-Paare gegengeprueft (`lookup`/`axis_03a_search_algo`, `alloc`/`axis_06_allocator`, `node`/`axis_04_node_type`, `prefetch_axis`/`axis_07_prefetch`) — in JEDEM Fall ist die topics-Datei eine Teilmenge-per-Basename der organ_axes-Datei. Die Basename-Dopplung bei `axis_14_value_handle_versioned_pointer.hpp` ist also KEIN Einzelfall/Defekt, sondern das durchgaengige Huellen-Muster — eine Umbenennung genau dieses Paares wuerde gegen die Architektur-Konvention verstossen, nicht sie reparieren.

---

## 4. R-2-Bezeichner-Kandidaten je Familie (Vorschlag, Owner bestaetigt spaeter)

**Namens-Konvention-Hinweis (par. 3 des Zielstruktur-Dokuments, `docs/plaene/20260813-DESIGN-zielstruktur-vier-traeger-unterprojekte.md`):** englisch durchgaengig, `planner` (nicht `planer`) als Beispiel der entschiedenen Schreibweise; das Dokument selbst uebergibt die frueheren #67-Zahlen ausdruecklich "neu zu erheben" an S-6d/#67 (Z.134) — es ist also die Quelle, auf die sich mein Auftrag bezieht, nicht ein unabhaengiger dritter Massstab.

**WARNUNG vor Verwechslung — zwei verschiedene "R-2"-Bezeichner existieren im Projekt-Wortschatz** (OV-Nummern-Falle, am Rohtext geprueft): 
1. Ledger-`R-2` = "MergeStrategy"-Bezeichner fuer das Pruefungs-Verbund-Konzept (`KON30-02`, `KON36-02/F`, Zeile 5668 `"F 1 MergeStrategy-Werte SIND die Pruefungs-Verbund-Varianten"`) — bereits beantwortet, ANDERES Thema, nicht Gegenstand dieser Erhebung.
2. Mein Auftrag verwendet `R-2` als EIGENES, lokales Schritt-Label dieser Explore-Kette (Schritt 1 = Erhebung, Schritt 2 = Bezeichner-Vorschlag) — NUR dieses meine ich unten.

**Kernbefund vor den Vorschlaegen:** Die 23 Header verwenden durchweg etablierte, bewusst gewaehlte Domaenen-Begriffe (Stempel/"stamp", Fingerprint, Version, Semver — vgl. Memory "DER STEMPEL TRAEGT FUENF ROLLEN"). Ein pauschales Wegbenennen dieser Woerter wuerde der eigenen Projekt-Terminologie widersprechen. Der Owner-Auftrag lautet "explore und **schaerfen**, behalten" — also PRAEZISIEREN, nicht ersetzen. Ich schlage daher NUR eine gezielte Zonen-Praefix-Schaerfung vor, orientiert an der #29-Besitzkarte (§2 desselben Dokuments), sortiert nach Kanten-Zahl (= Umbau-Risiko) aufsteigend, damit ein Owner-Piloteinsatz beim guenstigsten Fall anfangen kann:

| Familie (nach Traeger-Zone, #29-Besitzkarte) | Dateien (aktuell) | Kanten | R-2-Kandidat (Praefix-Schaerfung) |
|---|---|---|---|
| **Querschnitt/Grammatik — bereits eindeutig, NICHT anfassen** | `algo_semver.hpp` (23), `anatomy_version_stamp.hpp` (17), `anatomy_fingerprint.hpp` (13), `anatomy_stamp_entries.hpp` (7) | hoch | unveraendert lassen — Kernvokabular, hohes Blast-Radius, keine Kollision gefunden |
| **CEB (`builder/`)** | `ceb_version_stamp.hpp` (6, bereits zonen-praefigiert ✓), `axis_variant_version_table.hpp` (11), `pruef_dock_version.hpp` (7), `fingerprint_sidecar.hpp` (6), `organ_fingerprint.hpp` (2), `fingerprint_key_source.hpp` (2) | gemischt | `ceb_axis_variant_version_table.hpp`, `ceb_pruef_dock_version.hpp`, `ceb_fingerprint_sidecar.hpp`, `ceb_organ_fingerprint.hpp`, `ceb_fingerprint_key_source.hpp` |
| **Planner (`profile_facade/`)** | `planner_version.hpp` (5, bereits ✓), `build_type_stamp.hpp` (3), `g1_binary_version_stamp.hpp` (5), `system_version_suffix.hpp` (11), `toolchain_stamp_naht.hpp` (6) | mittel | `planner_build_type_stamp.hpp`, `planner_g1_binary_version_stamp.hpp`, `planner_system_version_suffix.hpp`, `planner_toolchain_stamp_naht.hpp` |
| **Querschnitt-ABI, niedrig-riskant (Pilot-Kandidaten)** | `meta_meta_stamp_suffix.hpp` (2), `toolchain_stamp_glied.hpp` (2), `system_axis_code_versions.hpp` (6), `axis_version_stamp.hpp` (1), `fixed_length_fingerprint.hpp` (2) | niedrig | `axis_version_stamp.hpp` kollidiert lesbar mit `anatomy_version_stamp.hpp`/`ceb_version_stamp.hpp` (3x "*version_stamp.hpp" im Baum) — einziger Kandidat mit echtem Verwechslungsrisiko trotz nur 1 Kante; Vorschlag `measurement_axis_version_entry_stamp.hpp` (zonen- und inhaltsgenau, deckt sich mit `mess_axes/`-Konvention aus S-18/#16) |
| **Overlay-Schnitt-Trio (S-14a-gelockt)** | die 3 aus Punkt 3 | 4-5 | **NICHT anfassen ohne Lock-Regen-Commit** (S-14a-Riegel-Pflicht) — jede Umbenennung hier ist ein bewusster `--write`-Vorgang, kein reiner Text-Edit |

Reihenfolge-Empfehlung bei Umsetzung: niedrigste Kantenzahl zuerst (Zeile 4 der Tabelle), danach CEB/Planner-Zonenpraefixe, `algo_semver`/`anatomy_*`-Kernvokabular zuletzt bzw. gar nicht.

---

## 5. Geprueft / nicht geprueft

**Geprueft (am Objekt, mit Fundstelle):**
- Vollstaendige Datei-Erhebung ueber `libs/`, `tools/`, `include/` bei HEAD `04ac26fa`, inkl. Negativ-Gegenprobe fuer alle libs-Geschwister und den `libs/traeger/`-Skeleton.
- 24-vs-23-Abweichung per `git log`/`git ls-tree` an 7 Commits ueber die volle Zeitspanne 13.08.-17.08. sowie volle Historie fuer Loesch-Events.
- Include-Kanten-Zaehlung repo-weit, HEAD UND am historischen Referenzpunkt `2a3b1eb0` (14.08., Gegenprobe bestaetigt Stabilitaet).
- Overlay-Schnitt-Zugehoerigkeit direkt gegen `overlay_source_set.hpp:130-201` gelesen (nicht nur gegreppt).
- Lock-Record-Zugehoerigkeit direkt gegen `axis_version.lock` gegrept, inkl. Format-Kopf gelesen.
- Basename-Dopplungs-Muster gegen 4 weitere Achsen-Paare gegengeprueft (verhindert Fehlvorschlag in Punkt 4).
- "R-2"-Begriffsklaerung am Rohtext (2 verschiedene Referenten identifiziert).

**Nicht geprueft (ausserhalb Auftrag/Ressourcen dieser Erhebung):**
- KEIN Abgleich mit den ANDEREN VL-6b/VL-6c-Explores (parallel laufend, mir nicht zugaenglich) — moegliche Ueberschneidung mit deren Familien-Definitionen unbekannt.
- KEINE Klaerung, WARUM KON61-05 auf 29/9/1 kam (Methodik dort nicht rekonstruierbar; ich habe nur die Nicht-Reproduzierbarkeit unter der woertlichen Regel belegt, nicht die Ursache).
- KEINE Owner-Ruecksprache zu den R-2-Namensvorschlaegen (per Auftrag explizit "Owner bestaetigt spaeter").
- Include-Kanten wurden NICHT nach direkt/relativ oder Kommentar-Treffer getrennt ausgewiesen (anders als das #29-Dokument in §3/§3a) — meine Zaehlung deckt beides ab (direkte UND relative `#include`-Direktiven), aber ich habe keine Untergliederung danach vorgenommen, da mein Auftrag das nicht verlangte.

**Relevante Dateipfade (alle absolut):**
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/builder/overlay_source_set.hpp`
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/tools/axis_version_lock/axis_version.lock`
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:2719-2735` (KON61-05)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/plaene/20260813-DESIGN-zielstruktur-vier-traeger-unterprojekte.md` (ganz, insb. §3, §134)