# Traeger-Landkarte der Experiment-/Messreihen-Schemas (Code/test_data_xml/)

> Angelegt in #48-S5 (2026-07-22, XSD-Konsolidierung). Diese Datei ist die
> Landkarte, WELCHER XML-Traeger wofuer kanonisch ist. Sie ist Doku (kein
> CI-Gate); die formale Struktur lebt in den `.xsd`-Dateien, die
> Registry-/Konsistenz-Pruefung im Code-Parser (`validate_profile.hpp`).

## Ziel-Traeger (KERN, ab #48)

| Traeger | Wurzel-Tag | Schema | Rolle |
|---|---|---|---|
| **comdare_experiment v2** | `<comdare_experiment version="2">` | `experiment_schema.xsd` | **KANONISCHES Ziel** ab #48. Traegt das Sektion-59-KERN-Schema (per-Achse `merge`/`pruefling`, `template`, negatives Blacklisting, `run_methodology` exactly-one, `id_namespace`) plus Sektion 62 (`machines`-Menge, `storage`-Slot, compare-Reserve). Referenz-Instanz: `experiment_golden_kern.xml`. |

`experiment_schema.xsd` ist das EINZIGE Ziel-Schema. Jede Schema-Evolution
kommt zuerst hierhin (und in die Referenz-Instanz `experiment_golden_kern.xml`,
Kopf-Block "KANONISCH AB #48"). Das `version`-Attribut ist Pflicht; `v2` ist der
KERN, `v1` bleibt gueltig (Rueckwaerts-Kompatibilitaet, s.u.).

## Interim-/Legacy-Traeger (BEHALTEN, kein Ziel)

| Traeger | Wurzel-Tag | Schema/Datei | Rolle |
|---|---|---|---|
| comdare_experiment v1 | `<comdare_experiment version="1">` | `experiment_schema.xsd` (validiert weiter) | INC-C-Interim-Instanz `experiment_golden.xml` (super + ce-Kopie, Sync-Gate). Die Abgabe-Kette (28.07.) laeuft hierueber; Umhaengung auf v2 ist Scheibe 6 (gegated nach dem 320er + User-GO). NICHT anfassen bis dahin. **Stand 06.08.:** bleibt in Kraft und bleibt bewacht -- `02_messung_driver` treibt `COMDARE_V32_EXPERIMENT_GOLDEN_XML` weiterhin real auf diese Datei. |
| comdare_thesis_profile | `<comdare_thesis_profile>` | `algorithm_profiles/thesis_profiles/SCHEMA.md` (ce) | Interim-Traeger der Abgabe-Kette (die A9-Profile + `all_axes_golden` leben ausschliesslich hier). Traegt eine Teilmenge der KERN-Elemente (System-Achsen, Mess-Unter-Achsen). Konvergenz mit comdare_experiment = Folge-Paket. |
| messreihe_v32 | `<messreihen>` | `messreihe_v32_schema.xsd` + `messreihe_v32_schema_example.xml` | DEPRECATED (Legacy-Fixture, BEHALTEN per INC-D). KEIN Ziel-Traeger; neue Felder gehoeren NUR in `experiment_schema.xsd`. Bleibt am Ort (Test-Referenzen im `messung_driver`). |

## Merkposten

- Die `*.test_data.xml`-Akten sind die Single-Source der Datensatz-Provenienz
  (kein `test_data_sets.xml`-Doppelquell-File).
- Der vierte `run_methodology`-Wert `compare` (Replay-Sichten-Vergleich) ist in
  #48 nur dokumentarische Reserve; die Materialisierung ist Paket #47.
- Der Storage-Slot (`<output><storage>`) ist in #48 INERT deklariert; der Konsum
  (lokal/minio) folgt post-Abgabe (K7b/K8).

## Pflege-Pflicht der GOLDEN-Instanz (A7-KERN, Owner 2026-08-05)

`experiment_golden_kern.xml` ist die **Trigger-Input-Basis des Baus** und muss
laut Owner-Entscheid A7 "bezueglich der vorhandenen Achsen und Einstellungen
staendig geupdated werden, um auch gegen syntaktische Aenderungen konsistent zu
bleiben". Daraus folgt eine feste Reihenfolge bei jeder Achsen-/Schema-Aenderung:

1. Code (Registry / `kCompositionAxisNames` / Wertraum-Header) ist die Autoritaet.
2. `experiment_schema.xsd` bekommt den Kanal (additiv, `minOccurs="0"`, damit
   Bestands-Instanzen gueltig bleiben).
3. `experiment_golden_kern.xml` deklariert ihn und beziffert die Kardinalitaets-Folge.
4. Die Wachen laufen: `xmllint --schema` (Struktur), ctest
   `test_fixture_schema_experiment_golden_kern` (Vokabular gegen die eine XSD;
   ce-seitig seit Weg a 17.08.2026: `experiment_kern_seam_fixture.xml`),
   ctest `test_golden_n_consistency` (Deckung mit dem ce-Schwester-Traeger),
   `validate_experiment_profile` (Registry-/Wert-Ebene, Code).

Eine Aenderung an dieser Datei ist ein **deklariertes Trigger-Input-Ereignis**
(Bau-Matrix-Definition), kein Bruch der Pilot-Byte-Wachen: `golden_fullpilot_320*`,
`permutation_axes.xml`, `m3v2_study.profile.xml` und die CRC-Anker haengen an
anderen Traegern.

### Organ-Sub-Achsen (`<organ_subaxes>`, ab 2026-08-06 / KF-6)

Die drei Sonderzweig-Unter-Achsen `cacheline` / `node_width` / `alloc_hw` sind
**keine** der 18 Kompositions-Achsen und gehoeren deshalb **nicht** in
`<axes_default_lookup>` (dessen `ref` wird gegen die ce-Registry aufgeloest und
kennt sie nicht -- `validate_profile` meldete "UNBEKANNTE Achse"). Sie haben seit
diesem Paket einen eigenen Wurzel-Block mit **zeichengleichem Vokabular** zum
`comdare_thesis_profile`-Dialekt (`per_organ`, `line_size`, `alignment`,
`sw_prefetch_hint`, `width_in_lines`, `numa_node`, `page`).

- **Wirkung:** jede deklarierte Sub-Dimension wird beim Konsum eine *statische*
  Ebene (`profile_to_tree.hpp`, `is_static=true`) und geht in die `binary_id` ein --
  sie **multipliziert** die Tier-Binary-Zahl.
- **Stand heute DEKLARATIV:** `parse_experiment_profile` liest den Block noch
  nicht (unbekannte Wurzel-Kinder werden still ignoriert). Lese-, Validier- und
  Codegen-Kanal sind die offene ce-Auflage dieses Pakets.
- **KF-6-Belegung der golden:** `cacheline/line_size` = alle vier CT-Werte
  {32, 64, 128, 256}; `alignment` und `sw_prefetch_hint` bleiben am Achsen-Default.
  Kardinalitaet: Faktor 4, also 4 x 2^17 = 524288 Tier-Binaries (mit alignment und
  sw_hint waeren es 60 x 2^17 = 7864320). Das ist das **line_size-Teilprodukt**;
  die **Gesamt-Bau-Matrix** der golden ist `4 (line_size) x 4 (Systemblock:
  opt_level 2 x simd 2 x target_isa 1) x 2^17 = 2097152` (NB2-Korrektur 06.08.:
  die frueher als Gesamtzahl gefuehrten 524288 liessen den Systemblock aus).
- **HW-Freigabe ist keine XML-Aussage:** gebaut wird die volle Menge; welche
  Permutation auf einer Maschine *gemessen* wird, entscheidet die CEB-/Planungs-
  Grenze einmalig anhand der zur Laufzeit erkannten Line-Groesse.

### Das golden-N (`<run_options>`, ab 2026-08-06 / B14-NB2)

Der Owner-Kanon **golden N = 2^17 = 131072** war bis heute im kanonischen Traeger
`experiment_golden_kern.xml` **nur Fliesstext**; maschinenlesbar existierte er
allein im ce-Schwester-Traeger `all_axes_golden.profile.xml`
(`<run_options cap="131072"/>`). Ein Kommentar ist keine Bauanleitung -- die
frueher deklarierte Form (2 Achsen mit Override, 16 ungenannt = Voll-Sweep)
expandierte gegen die Registry-Kardinalitaeten sogar zu rund `6e10` Binaries und
widersprach damit dem Kanon, den sie tragen soll.

Geheilt auf **drei** Ebenen:

1. **XSD:** neues optionales Wurzel-Element `<run_options>` (`RunOptionsType`),
   Attribut-Satz zeichengleich zum `comdare_thesis_profile`-Dialekt
   (`cap` Pflicht, `n_ops`/`platform`/`build_version`/`resume` optional). `cap` =
   `max_binaries`-Obergrenze (`xml_config_parser.hpp:193`).
2. **Instanz:** alle 18 Kompositions-Achsen tragen ihre `allowed_variants`
   explizit -- exakt die Werte des Schwester-Traegers (2 je Achse,
   `persistence_target` 1). Produkt = `2^17` = 131072, gegen die Registry
   nachgerechnet. Dazu `<run_options cap="131072" build_version="golden_kern"/>`.
3. **Wache:** `test_golden_n_consistency`
   (`Code/tests/golden_n_consistency_check.cmake`) vergleicht beide Traeger ueber
   die Dialekt-Grenze hinweg: gleiche Achsen-Menge, je Achse gleiche
   Auspraegungen, gleiches Produkt, und `Produkt == cap` auf beiden Seiten. Ein
   `cap`, den die Achsen nicht hergeben, ist eine willkuerliche Kappung und wird
   abgelehnt.

**Registry-Namen sind Pflicht:** `allowed_variants` muss `baustein name`-Werte der
`cache_engine_axis_registry.xml` nennen (`validate_experiment_profile` Pruefung
(5)). Die frueher hier stehenden Token `binary_search` / `linear_search` gibt es
dort nicht -- `search_algo` fuehrt `k_ary`, `interpolation`, `eytzinger`,
`linear_scan`. Gepinnt ist `k_ary interpolation`, weil der golden-Raum als "die
ersten 2 Enabled-Werte je Achse" definiert ist (`mp_take_c<...,2>`); ein anderes
Paar waere ein zweiter, widersprechender golden-Raum und muesste **beide** Traeger
zugleich bewegen (offener Owner-Punkt, kein Blocker).
