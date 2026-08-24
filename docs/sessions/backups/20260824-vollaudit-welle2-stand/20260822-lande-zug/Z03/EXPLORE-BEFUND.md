# Z03 EXPLORE-BEFUND (3 Achsen, erhoben VOR dem Merge; persistiert nach Commit)

Zug: W2-Lande-Zug (wt-ce-lande, lande/w2-s1s2), Ziel Z03 = Merge 4/10 bau/s13schema.
Ausgangsstand: lande/w2-s1s2 @ bc056106 (Merge 3/10 s8kopf), porcelain 0, df 24G frei.

## 1. STRUKTURELL (git merge-tree --write-tree HEAD c76d3116, selbst gefahren)

- Quelle: bau/s13schema @ c76d3116 = 2 Commits auf Basis 66de5c09
  (ad5c6d66 Kern S13-01..03 + c76d3116 ASCII-Fix S13A-F1); merge-base(HEAD, c76d3116)
  = 66de5c09 (sauber, kein Kreuz-Merge). Diff-Flaeche: 10 Dateien +1095/-78.
- merge-tree: 2 KONFLIKT-Dateien, 4 Auto-Merges.
  - KONFLIKT tests/unit/CMakeLists.txt (3 Bloecke 7579-8008): bekannte Dateiende-
    Harmonisierungs-Flaeche. Beide Seiten reine ANHAENGE nach Basis-Z.7576
    (diff BASE vs head -7576 beider Seiten je leer, selbst gemessen):
    HEAD-Anbau 351 Z. (W1L+s19+messfenster+s8kopf-Bloecke), s13-Anbau 91 Z.
    (test_s13_01/02/03). Git hatte aehnliche include-Listen ZWEIER VERSCHIEDENER
    Tests (test_lg_e2e_xlsx_facade vs test_s13_02) als gemeinsamen Kontext verzahnt
    -> stueckweise Aufloesung verboten, deterministische Rekonstruktion gewaehlt:
    BASE[1..7576] + HEAD[7577..7927] + s13[7577..7667] = 8018 Z.
  - KONFLIKT profile_run_entry.hpp (:1032-1041): messfenster-C-11
    (std::vector mess_warnungen Deklaration + alter roher Strom "csv <<
    r.resumed_csv_rows;") x s13-S13-01 (roher Strom ENTFERNT). Harmonisierung:
    Deklaration BLEIBT, Strom-Zeile ENTFAELLT (resumed-Zeilen reisen im
    gemeinsamen Teil via mappe.blob_aus_csv; C-11-Sammlung/INFO-Blatt-Ausgabe
    im Auto-Merge-Teil intakt).
  - Auto-Merges (Vertragsflaechen-Verdacht geprueft, s.u.): experiment_run_entry.hpp,
    cache_engine_builder_iterator.hpp, xml_config_parser.hpp, m3v2_smoke.profile.xml,
    ergebnis_mappe_naht.hpp (+3 neue Testdateien).
- Lande-seitige Anfasser aller 4 Kollisions-/Auto-Flaechen: NUR messfenster-Merge
  3a746090 (git log 66de5c09..HEAD je Datei, selbst gemessen).
- T-6-Symmetrie-Pruefung: experiment_run_entry.hpp traegt KEIN mess_warnungen --
  auch auf messfenster-Seite nicht (Diff 66de5c09..3a746090 an der Datei: 8 +Zeilen,
  0x mess_warnungen). Keine durch den Merge eingefuehrte Asymmetrie; beide Seams
  tragen persistenz_ok + →-Escape-fertig-Zeile (s13) korrekt.

## 2. DESIGN (Audit-Berichte + Strang-Ergebnisse VOLL gelesen)

Gelesen: SYNTHESE-S1-AUDIT.md (inkl. G1-G9) + SYNTHESE-S2-AUDIT.md (inkl. H1-H5) +
GEGENLESE-GATE.md + s13schema/{soll-karte,audit-runde-1,audit-runde-2,fix-runde-1}.md +
20260820-w2-sofortstaffel/s13-schema-kette-ergebnis.md + p-h-89-ergebnis.md (voll).
- s13schema-Verdikt: r1 FIXES_NOETIG (S13A-F1 ERNST ASCII-Wache ROT 8 Zeilen,
  S13A-F2 KLEIN Interpretations-Vermerk) -> Fix-Runde 1 (Commit c76d3116, 2 Dateien
  12+/8-, Rot->Gruen-Beweis 1095/0/0, Byte-Beweis Pfeil-Escape gcc+clang) ->
  r2 SITZT (2/2 BEHOBEN, 0 neue Funde, LANDEREIF auf c76d3116 + super 1e92b77e).
- Vertraege/Nenner: fertig-Zeilen-PARSE-ANKER U+2192 als →-Escape (Ausgabe-Byte
  identisch, super-Wache lauf_marker.sh ankert "RUN_PROFILE fertig:"); csv_ok= bleibt,
  persistenz_ok= additiv (token-weiser Parser vertraeglich); Resume-Vertrag
  result.csv+stamp AUSSERHALB des Filters (Spannung Nr. 1: Design-INTERPRETATION,
  Owner-Feinabstimmung offen -- NICHT als glatt erledigt fuehren); ctest-Nenner
  Strang 513 = Basis 510 + 3 (Merge-Stand hier hoeher, eigene Messung unten).
- ph89-TEIL-6 (7 Schema-Bedarfe an den s13-Zug) GESICHTET: Nr. 1 TemplateType-
  XSD-Kommentar-Nachzug (tolerant->R-4-hart; Kommentar-only) -- NICHT im super-
  s13-Commit 1e92b77e enthalten (der aendert nur RunMethodologyType/
  WritebackMethodsType); Nr. 2-6 = Struktur-Grammatik (external-Pfad, Markierung,
  Ranking, Klassen-Ladung, D-09-Deckel) -> S13-04ff/Staffel-3-Schema-Zug;
  Nr. 7 = kein Bedarf. ce-Haelfte aendert KEIN XSD -> Einarbeitung hier nicht
  moeglich, VORMERKUNG im Merge-Commit-Text + Restposten an super-Phase/Staffel-3.
- Quer-Auflage G8/H5 fuer den Endstand-Kombibau: 7er-J-1-Liste literal + reales
  Facade-Target comdare_profile_run_facade (Alias comdare_facade existiert nicht).

## 3. HISTORISCH

- git ls-remote origin refs/heads/bau/s13schema = c76d31164d7ffd5ffbb9f776e6839e7fc08114c7
  == quelle_tip (selbst gemessen). Kein juengerer Commit (git log Basis..Tip = genau 2).
- Juengste Runde = audit-runde-2 (22.08. 06:56, SITZT); Fix-Commit 06:35 -- r2 misst
  exakt diesen Tip. Kein Ueberholt-Marker in Synthesen/Gate (S1-Tafel Z.15 + Gate-
  Tafel Z.31 fuehren s13schema SITZT r2 2/2; T-Tips T1-T13 nennen keinen s13-Ersatz).
- H-6-LANDE-KOPPLUNG bindend (beide Commit-Texte): super bau/s13schema @ 1e92b77e
  landet im SELBEN Lande-Ereignis -> super-Phase dieses Zugs (Z16); P-06 in r2
  bestaetigt super UNVERAENDERT @ 1e92b77e.

## ENTSCHEID (vor Eingriff): MERGEN mit 2 Harmonisierungen wie oben; gcc-Release-
Zwischenlauf als Abnahme (Struktur-Risiko Kern-Naht-Konflikt; df 24G > 5G, Owner
erlaubt Zwischenlauf); Endstand-Kombibau T-11b bleibt Zug-Endstufe (K17).
