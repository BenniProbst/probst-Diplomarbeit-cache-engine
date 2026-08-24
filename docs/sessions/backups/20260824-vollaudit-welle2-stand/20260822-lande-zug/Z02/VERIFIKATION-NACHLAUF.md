# Z02 VERIFIKATION-NACHLAUF (zweiter Lauf, 2026-08-22 ~16:33 UTC)

LAGE: Der erste Z02-Lauf hat Explore-Befund (14:52), Merge bc056106 (14:53:59) und
Abnahme-Proben (14:54) hinterlegt und ist vor der Ergebnis-Meldung still gestorben
(journal = Wahrheit). Die origin-Ref-Sicherung lag bei Wiederanlauf bereits
(Push 16:31:39, Pipeline 16090 status=skipped = ci.skip, 0 Jobs — R4-konform).
Dieser Nachlauf hat NICHTS uebernommen, sondern alles eigenstaendig am Objekt
nachgemessen (K18). Alle Proben dieses Nachlaufs:

## 1. Merge-Objekt

- HEAD wt-ce-lande = bc0561063f31c8a3f16573c9f93902d132f6c7d4, Branch lande/w2-s1s2,
  porcelain 0 Zeilen. Eltern: 61d5d139 (Ziel) + 41ee8780 (bau/s8kopf) = --no-ff.
- Trailer "Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>" im Body (git show literal).
- Botschaft traegt Strang, Tip, Audit-Verdikt (SITZT 0/0/2 KLEIN), H-1-Harmonisierung,
  Restposten-Traeger S8A-01/S8A-02 (T7/#122), H-15, Kombibau-Deklaration.
- Stat: 8 Dateien +1266/-5 == Audit-runde-1-Kopf (deckungsgleich).

## 2. Strukturelle Reproduktion (eigenstaendig)

- git merge-tree --write-tree 61d5d139 41ee8780: RC=1, Tree 043d6ef5840b...,
  CONFLICT NUR tests/unit/CMakeLists.txt (Stages 1/2/3) — identisch zum Erstlauf-Beleg
  z02-mergetree.out. Kein Auto-Union; Harmonisierung von Hand war Pflicht und geschah.
- Tree-Diff Auto-Merge-Baum (043d6ef5) vs bc056106^{tree}: GENAU 1 Datei
  (tests/unit/CMakeLists.txt, 27+/25- = Konfliktmarker-Fassung vs Union) —
  ALLE anderen 7 Dateien byte-identisch zum Auto-Merge. Keine Fremd-Abweichung im Baum.
- Name-only 61d5d139..bc056106 = exakt die 8 Strang-Dateien (Liste im Terminal-Log).

## 3. H-1-Union byte-bewiesen (Zaehlwerke einmal, nichts doppelt)

- Zeilenzahlen: ZIEL=7868 / QUELLE=7635 / MERGE=7927 (= 7868 + 59; SOLL getroffen).
- cmp(head -7868 der Merge-Fassung, Ziel-Fassung 61d5d139 voll): RC=0 (byte-gleich)
  -> W1-LUECKEN-, s19-, messfenster-Bloecke der Ziel-Seite VOLL erhalten.
- cmp(tail -59 der Merge-Fassung, tail -59 der Quell-Fassung 41ee8780): RC=0 (byte-gleich)
  -> s8-Anhang (eigener Trenner + beide comdare_add_test-Bloecke) VOLL uebernommen.
- Arithmetik 7868+59=7927 + beide cmp-RC=0 => Duplikation mathematisch ausgeschlossen.

## 4. Historisch/Remote

- ls-remote origin: bau/s8kopf = 41ee8780 (Tip juengste Fassung, == Audit-Objekt,
  == Fahrplan #131); lande/w2-s1s2 = bc056106 (Ref-Sicherung liegt).
- Juengste Audit-Runde s8kopf = audit-runde-1 (einzige; GEGENLESE-Tafel bestaetigt,
  Fund-Label-Korrektur G6 beruecksichtigt: S8A-01/S8A-02). Kein Ueberholt-Marker.
- Pipeline-Nenner ref=lande/w2-s1s2 auf 286: 1 Pipeline (16090, skipped, sha bc056106,
  16:31:39Z) — keine laufende/rote Pipeline durch die Ref-Sicherung.
- github: weder lande/w2-s1s2 noch bau/s8kopf vorhanden (ls-remote 0 Zeilen, RC=0) —
  github erhaelt den Stand beim finalen Lande-Push (beide Remotes), planmaessig.

## 5. Kein Zwischenbau, keine Raeumung

- df -h /: 24G frei (Gate >5G erfuellt). Kein Pflicht-Zwischenbau (Branch-Abnahme
  512/512 gcc-Release + 4-Zellen liegt; Baum-Abweichung gegen Auto-Merge = nur die
  dokumentierte Union-Datei => kein Struktur-Risiko). Endstand-Kombibau T-11b deckt.
- Raeumfenster Z11: Build-Cache s8kopf + wt-ce-s8kopf (HEAD 41ee8780, porcelain 0)
  stehen unangetastet.

## 6. S8A-01 (Lande-Protokoll, deckt G8) — 7er-J-1-Liste LITERAL

comdare_adhoc_emitter_cli comdare_anatomy_codegen_cli comdare_axis_registry_gen
comdare_catalog_codegen_cli comdare_measurement_axis_registry_gen
comdare_overlay_source_hash_gen comdare_system_axis_registry_gen
— Endstand-Kombibau faehrt diese SIEBEN literal, dann RE-CONFIGURE
(-DCOMDARE_CE_PRUEFLINGE=<src>/tests/pruefling_fixture), Vollbau, comdare_tests,
ctest --no-tests=error; Facade ueber REALES Target comdare_profile_run_facade.

ERGEBNIS: Merge 3/10 GELANDET und verifiziert; Zug frei fuer Z03 (s13schema c76d3116).
