# Z02 EXPLORE-BEFUND (VOR Merge 3/10: bau/s8kopf -> lande/w2-s1s2)

Datum: 2026-08-22. Pruefer: Fable-max Lande-Schritt Z02 (einziger Schreiber, Bauslot slot2.d "lande-w2-zug").
Doktrin: NIE UNINFORMIERT MERGEN — drei Achsen, Befund dokumentiert VOR dem Eingriff.

## Ausgangslage (gemessen)

- wt-ce-lande: Branch lande/w2-s1s2, HEAD 61d5d1394f4fbeba58218964e7cf6ab71b07ae31, porcelain leer (0 Zeilen).
- HEAD-Historie: 61d5d139 (Merge 2/10 messfenster) -> 881d1a15 (Merge 1/10 s19) -> f729b93a (dev==origin, CI 16088 SUCCESS).

## Achse 1 — STRUKTURELL

- Quell-Tip: bau/s8kopf @ 41ee878056bd0388cd8bcf6472067e20192237c5, lokal == origin
  (git ls-remote origin refs/heads/bau/s8kopf = 41ee8780..., literal gemessen).
- merge-base(61d5d139, 41ee8780) = 66de5c0972290ec1ae3d219988ecc207d8f5de6b (W1-Schlussstein, wie Audit).
- Diff-Menge Basis..Quelle: 8 Dateien, +1266/-5 (deckungsgleich Audit-runde-1 Kopf):
  3 Header libs/traeger/planner/include/traeger/planner/{naht_nachrichten,steuerdock,traeger_rakete}.hpp (alle NEU),
  2 Test-TUs tests/unit/test_s8kopf_planner_kopf.cpp (405 Z., NEU) + test_s8_traeger_grenzwache.cpp (248 Z., NEU),
  3 CMakeLists: apps/experiment_planner (8+/-x), libs/traeger/planner (27+/-x), tests/unit (+59/-0 NUR Dateiende).
- Flaechen-Ueberlappung beider Seiten gegen merge-base (comm -12 der name-only-Diffs):
  GENAU EINE Datei = tests/unit/CMakeLists.txt. Alle anderen 7 Dateien kollisionsfrei.
- git merge-tree --write-tree 61d5d139 41ee8780: RC=1, Ergebnis-Tree 043d6ef5...,
  conflicted entries NUR tests/unit/CMakeLists.txt (Stages 1/2/3) — Beweis-Kopie z02-mergetree.out.
  KEIN Auto-Union: Git meldet die Vertragsflaeche als echten Konflikt -> Harmonisierung von Hand (A2.1b), wie geplant.

### Harmonisierungs-Rezept H-1 (Muster Merges 881d1a15 + 61d5d139)

- Basis-Datei: 7576 Zeilen (endet s6c-Block). Ziel-Seite: 7868 Zeilen
  (s6c -> Trenner "# ===..." + W1-LUECKEN-Block -> s19-Block -> messfenster-Block, alle am DATEIENDE).
- Quell-Seite: 7635 Zeilen; Anhang = Zeilen 7577..7635 (59 Zeilen: Leerzeile + Trenner
  "# =====...", Kommentarkopf "S-8-KOPF (T-NEU-6 Teil 1, 2026-08-20)" + Bloecke
  test_s8kopf_planner_kopf und test_s8_traeger_grenzwache).
- REZEPT: Ziel-Fassung VOLL uebernehmen + s8-Anhang (59 Zeilen, traegt eigenen Trenner) ans DATEIENDE.
  Erwarteter Endstand: 7868 + 59 = 7927 Zeilen. Bloecke BEIDER Seiten VOLL, Trenner dazwischen; keine Zaehlwerke doppelt.

## Achse 2 — DESIGN (Vertraege/Schemas/Nenner)

- Audit-Bericht s8kopf/audit-runde-1.md (28067 B) VOLL gelesen: VERDIKT SITZT, 0 ERNST / 0 MILD / 2 KLEIN
  (S8A-01, S8A-02); alle 26 Prueflisten-Punkte ERFUELLT/getragen; P-19: tests/unit-Anhang NUR Dateiende (+59/-0);
  P-25: keine CI-YAML, allow_failure 0; TABU-Zonen unberuehrt; ASCII 0 Verstoesse; Trailer vorhanden.
- Vertragsflaechen-Gegenprobe am ZIEL (61d5d139): alle vom s8-Anhang genutzten Funktionen existieren —
  comdare_add_test 270 / comdare_prepare_thesis_object_dir 20 / comdare_attach_generated_catalog 13 /
  COMDARE_TEST_TMP_BUILD_TAG 1 (verzeichnisweite Definition) / comdare_set_platform_defines 123 Treffer;
  comdare_planner existiert als INTERFACE-Target im Ziel (libs/traeger/planner/CMakeLists.txt:5, #29-Skeleton) —
  die Quell-Seite erweitert DIESE Datei (27+), Datei NICHT in der Ueberlappungsmenge -> kollisionsfrei.
- Nenner: Strang bringt +2 ctest-Eintraege (im Strang #507/#508 bei Basis-Nenner 510); Endstand-Soll der
  vollen Serie ~520er-Klasse (H-1); Endstand-Nenner wird EINMAL live am Kombibau gemessen (H-7), keine Deltas vorab.
- H-15 (traeger/-Baum s8kopf x vollzug91): durch Lande-Reihenfolge gedeckt — s8kopf = Merge 3/10 VOR vollzug91 = 6/10;
  vollzug91-Merge sichtet dann gegen den bereits gelandeten s8-Stand.
- KLEINs mit G6-IDs:
  S8A-01 = 7er-J-1-Liste LITERAL ins Lande-Protokoll (deckt G8) -> HIER erfuellt, s. Abschnitt "S8A-01" unten.
  S8A-02 = Zeilen-Anker main.cpp real :714-719 (statt :721-726 in Kopf-TU/Bericht) — Korrektur beim NAECHSTEN
  Anfassen der Kopf-TU, KEIN Fix-Commit im Merge -> Restposten-Traeger T7/#122 (Z21).

## Achse 3 — HISTORISCH

- Juengste Audit-Runde s8kopf = audit-runde-1.md (einzige Runden-Datei im Strang-Ordner; GEGENLESE-GATE-Tafel
  bestaetigt: "s8kopf | audit-runde-1 | SITZT (0/0/2 KLEIN S8A-01/-02) | Verdikt OK; Fund-Label falsch -> G6").
- Tip-Aktualitaet: 41ee8780 == origin (ls-remote heute) == Auftrags-SOLL == Audit-Objekt. KEIN juengerer Stand,
  KEIN Ueberholt-Marker fuer s8kopf in Synthese S1 (G1-G9) oder Gate; Fahrplan #131 nennt denselben Tip.
- Reihenfolge-SOLL: #131 Phase 1 = s19 -> messfenster -> s8kopf -> ... — Merges 1/10 + 2/10 liegen (881d1a15, 61d5d139),
  s8kopf ist turnusgemaess Merge 3/10.

## S8A-01 — LANDE-PROTOKOLL-EINTRAG (7er-J-1-Werkzeugliste LITERAL, deckt G8)

Der K17-Endstand-Kombibau dieses Lande-Zugs faehrt die VOLLE J-1-Treppe mit SIEBEN Werkzeugen LITERAL:
comdare_adhoc_emitter_cli comdare_anatomy_codegen_cli comdare_axis_registry_gen comdare_catalog_codegen_cli
comdare_measurement_axis_registry_gen comdare_overlay_source_hash_gen comdare_system_axis_registry_gen
— danach RE-CONFIGURE (-DCOMDARE_CE_PRUEFLINGE=<src>/tests/pruefling_fixture), dann Vollbau (--target all),
dann comdare_tests, dann ctest --no-tests=error; Facade ueber das REALE Target comdare_profile_run_facade
(Alias "comdare_facade" existiert nicht, RC=1-Beweis skip97/verify2-all.log).
Der Strang selbst fuhr 6/7 (comdare_overlay_source_hash_gen fehlte in Aufzaehlung/Commit-Message);
Wirkung nachweislich NULL (Audit: 0 overlay-bedingte Registrierungen in tests/unit, --target all baute
das Werkzeug ohnehin, Basis-Nenner 510 dreifach quer-korroboriert). KEINE Code-Aenderung noetig.

## ENTSCHEID

Alle drei Achsen sauber: Merge 3/10 FREI. Form: git merge --no-ff bau/s8kopf; Konflikt tests/unit/CMakeLists.txt
nach Rezept oben harmonisieren (Ziel voll + 59-Zeilen-s8-Anhang, Soll 7927 Z.); kein Pflicht-Zwischenbau
(Branch-4-Zellen-Abnahme liegt, gcc-Release "100% tests passed ... out of 512" im Strang; Endstand-Kombibau deckt);
Cache-/Worktree-Raeumung NICHT hier (Raeumfenster Z11).
