# P2-P8-Katalog-Klaerung (Lens-Ergebnis 06.08., Lead-Kurzfassung)

QUELLE (autoritativ): docs/sessions/20260804-DOSSIER-achsen-qualitaets-parameter-katalog.md -- Abschnitt 4 (A8-S3-ARBEITSLISTE, Z.737-778) = P1..P8(-P11) + Abschnitt 3 (SA-WIRE-BEFUND, Z.674-735) = BINDENDE SLOT-VERGABE + Ereignis-Klassen A/B/C.

POSTEN: P1 zweite Haelfte (fill_observer_v3-Quellen-Umzug, wertaendernd) · P2 T7-Sichtbarkeit (names[5..7]=nullptr -> benennen; billigster Fix; am HEAD verifiziert) · P3 T10-Hypothesen-Zaehler (H3!) · P4 T14-FPR (known_absent) · P5 T4-H1/Format (nur 2 Wire-Slots, Rest AlgoDetail) · P6 T6-Mem-Ehrlichkeit (frag-milli + Peak-Fehl-Etikett measurement_snapshot.hpp:106 heilen) · P7 T0-Latenz-Formel (Vergleichs-/Tiefen-Zaehler) · P8 Sammel (T2/T15/T16/T13/T11/T3/T9/T17).

UMFANG: L -- 12/18 Themen, echte Instrumentierung in axes/-Headern, beruehrt G8-Wire-Flaechen (observable_tier.hpp + abi_adapter.hpp) -> JE COMMIT Byte-Wachen-Nachweis (sizeof==1344, Wire-Diff 0, golden-320 3/3, Roundtrip 4/4, CRC64-Pin).

ABHAENGIGKEITEN: E1 (Milli-Fixpunkt) ENTSCHIEDEN/gelandet · E3 (Fenster) durch Owner-E-4 heute GEDECKT (VOR Messbeginn) · E2 (T6-Peak on-wire vs Host-Append) durch Owner-E-4 als SHORTCUT-R1 gedeckt (n/a + Nach-Abgabe-TODO Wire-Slot) · E9 (frag-milli-Stille-0-Heilung) OFFEN-KLEIN (Fehlerklassen-Doktrin: mit P6 heilen). xlsx: neue Spalten fliessen OHNE Writer-Aenderung ein (lazy_csv_header-WIDE); B12 keine Voraussetzung.

FAHRPLAN-SLOT: CE-Slot nach L1/TP1/P92/B13 (eigenstaendiges Bau-Fenster; parallel zu A1 moeglich -- dateidisjunkt).
