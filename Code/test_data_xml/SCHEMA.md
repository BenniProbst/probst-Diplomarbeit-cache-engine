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
| comdare_experiment v1 | `<comdare_experiment version="1">` | `experiment_schema.xsd` (validiert weiter) | INC-C-Interim-Instanz `experiment_golden.xml` (super + ce-Kopie, Sync-Gate). Die Abgabe-Kette (28.07.) laeuft hierueber; Umhaengung auf v2 ist Scheibe 6 (gegated nach dem 320er + User-GO). NICHT anfassen bis dahin. |
| comdare_thesis_profile | `<comdare_thesis_profile>` | `algorithm_profiles/thesis_profiles/SCHEMA.md` (ce) | Interim-Traeger der Abgabe-Kette (die A9-Profile + `all_axes_golden` leben ausschliesslich hier). Traegt eine Teilmenge der KERN-Elemente (System-Achsen, Mess-Unter-Achsen). Konvergenz mit comdare_experiment = Folge-Paket. |
| messreihe_v32 | `<messreihen>` | `messreihe_v32_schema.xsd` + `messreihe_v32_schema_example.xml` | DEPRECATED (Legacy-Fixture, BEHALTEN per INC-D). KEIN Ziel-Traeger; neue Felder gehoeren NUR in `experiment_schema.xsd`. Bleibt am Ort (Test-Referenzen im `messung_driver`). |

## Merkposten

- Die `*.test_data.xml`-Akten sind die Single-Source der Datensatz-Provenienz
  (kein `test_data_sets.xml`-Doppelquell-File).
- Der vierte `run_methodology`-Wert `compare` (Replay-Sichten-Vergleich) ist in
  #48 nur dokumentarische Reserve; die Materialisierung ist Paket #47.
- Der Storage-Slot (`<output><storage>`) ist in #48 INERT deklariert; der Konsum
  (lokal/minio) folgt post-Abgabe (K7b/K8).
