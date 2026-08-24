# FIX RUNDE 1 — Strang "messfenster" (#13/T-15b + #38b/C-05)

Fix-Stufe: Fable-max A2.5 Runde 1. Datum: 22.08.2026 (Auftrag 21.08.).
Objekt: ce `bau/messfenster`, Worktree `/home/comdare/wt-ce-messfenster`.
HEAD-Probe (eigen): `git rev-parse HEAD` = `3a746090ae6abb95ae9c1bce498e1cf54d81f1f3` == Audit-Tip;
`git status --porcelain | wc -l` = 0 (kein dirty-Stand vorhanden, nichts zu uebernehmen);
Ref-Sicherung (eigen): `git ls-remote origin refs/heads/bau/messfenster` =
`3a746090ae6abb95ae9c1bce498e1cf54d81f1f3` — STEHT.
Eingang voll gelesen: audit-runde-1.md (415 Z.) + mess-fenster-ergebnis.md (245 Z. vor Nachtrag).

BEIDE Audit-Funde sind Berichts-/Beweis-Funde mit Fixweg "Kein Code-Delta am Branch noetig"
(Audit A-1 Z.366, A-2 Z.376). Ausgefuehrt wurden die vorgeschriebenen Berichts-Nachtraege plus
EIGENE Nachmessungen (nicht vom Audit abgeschrieben); der Branch traegt 0 neue Commits.

--------------------------------------------------------------------------------

## 1. QUITTUNGEN (dreiwertig, je Fund eigener Beleg)

### A-1 (MILD) — J-1 "6 Werkzeuge" statt SIEBEN, Werkzeug-Liste nicht benannt → **BEHOBEN**

Eigene Verifikation des Fund-Belegs (nicht abgeschrieben): mess-fenster-ergebnis.md trug am
Alt-Stand Z.186 und Z.232 literal "J-1 6 Werkzeuge rc=0" (Voll-Lesung dieser Fix-Stufe), ohne
Namensliste. Fund bestaetigt.

Vollzogener Fix (Fixweg-Komponente 2, die dieser Stufe zugewiesene): NACHTRAG-Block im Abschnitt
"Literale" von /home/comdare/backups-workflow/20260820-w2-sofortstaffel/mess-fenster-ergebnis.md,
jetzt Z.193-208 (Kopf "#### NACHTRAG Fix-Stufe A2.5 R1 (22.08.2026; ...)", Bullet "[A-1]");
Datei 245 → 266 Zeilen, rein additiv, ASCII-Probe der eingefuegten Z.193-213: 0 Non-ASCII-Treffer
(grep '[^ -~]' rc=1).

Eigene Belege, die den Nachtrag tragen (alle diese Fix-Stufe, am Objekt/an persistierten Quellen):

1. WELCHE SECHS (quellenbelegte REKONSTRUKTION, im Nachtrag als solche deklariert — ein eigener
   messfenster-Bau-Log ist nicht persistiert): Die Staffel-Auftrags-Liste nannte SECHS Werkzeuge;
   drei Schwester-Berichte derselben Staffel fuehren sie wortgleich:
   - s19-simulation-ergebnis.md:229-231: "J-1-Treppe (comdare_adhoc_emitter_cli
     comdare_anatomy_codegen_cli comdare_catalog_codegen_cli comdare_axis_registry_gen
     comdare_measurement_axis_registry_gen comdare_system_axis_registry_gen; Auftrags-Liste) RC=0"
   - skip-oekonomie-97-ergebnis.md:104-106: dieselben sechs Namen.
   - traegerbau-s8-ergebnis.md:131-133: dieselben sechs + Konstruktions-Hinweis "alle
     *_registry_gen am Objekt = genau diese 3" — die Sechser-Liste war strukturell
     3 apps-CLIs + 3 registry_gen; comdare_overlay_source_hash_gen (kein *_registry_gen) fehlte.
   Fehlendes siebtes Doktrin-Werkzeug demnach: comdare_overlay_source_hash_gen.

2. ALLE SIEBEN EXISTIEREN AM TIP mit eigener add_executable-Definition (eigene git-grep-Messung
   @ 3a746090): comdare_adhoc_emitter_cli → apps/adhoc_emitter/CMakeLists.txt ·
   comdare_anatomy_codegen_cli → apps/anatomy_codegen_tool/CMakeLists.txt ·
   comdare_axis_registry_gen → tools/axis_registry_gen/CMakeLists.txt ·
   comdare_catalog_codegen_cli → apps/catalog_codegen_tool/CMakeLists.txt ·
   comdare_measurement_axis_registry_gen → tools/measurement_axis_registry_gen/CMakeLists.txt ·
   comdare_overlay_source_hash_gen → tools/overlay_source_hash_gen/CMakeLists.txt ·
   comdare_system_axis_registry_gen → tools/system_axis_registry_gen/CMakeLists.txt.

3. MECHANISCHE SCHADENS-EINGRENZUNG, SCHAERFER ALS DIE DES AUDITS (neu, eigene Messung): Das
   mutmasslich ausgelassene siebte Werkzeug ist exakt das eine, das der Strang-Schritt
   "--target all rc=0 (2515 Schritte)" OHNEHIN baute —
   tools/overlay_source_hash_gen/CMakeLists.txt:44 `add_executable(comdare_overlay_source_hash_gen
   main.cpp)` OHNE EXCLUDE_FROM_ALL (Kopf Z.3 ausdruecklich: "NICHT EXCLUDE_FROM_ALL (anders als
   die Registry-Generatoren)"), zusaetzlich harte Kanten cmake/overlay_source_hash.cmake:38
   (`COMMAND $<TARGET_FILE:comdare_overlay_source_hash_gen>`) und :45
   (`add_dependencies(comdare_overlay_source_hash comdare_overlay_source_hash_gen)`).
   Die drei *_registry_gen dagegen tragen EXCLUDE_FROM_ALL (tools/axis_registry_gen/
   CMakeLists.txt:27, tools/measurement_axis_registry_gen/CMakeLists.txt:10,
   tools/system_axis_registry_gen/CMakeLists.txt:10) — sie sind echte Nur-J-1-Ziele und waren in
   der Sechser-Liste ENTHALTEN. Unter der Auftrags-Listen-Rekonstruktion wurden damit im
   Strang-Lauf ALLE SIEBEN Werkzeuge gebaut (6 via J-1 + das siebte via all); nur die J-1-STUFE
   nannte sechs. Das ergaenzt die Audit-Eingrenzung (Testzahl 511==510+1) um den Bau-Graph-Beweis.

4. Fixweg-Komponente 1 (7er-J-1 am GEMERGTEN Endstand) ist nicht Gegenstand dieser Stufe: sie ist
   per Audit "K17, ohnehin Pflicht — Phase 3/4" dem Lande-Zug-Kombibau zugewiesen (Traeger
   existiert: Audit §4 "T-11b/K17 ... dort Fund A-1-Fixweg mit abdecken"); der ENTWURF fuer das
   Lande-Protokoll steht unten in §3. BEIDE Mengen benannt: DIESE Quittung deckt Berichts-Nachtrag
   + statische 7-Werkzeuge-/Bau-Graph-Verifikation am Tip; NICHT gedeckt (getragen, nicht vertagt):
   der frische 7er-Treppen-LAUF — der gehoert doktrinal an den gemergten Endstand, nicht an den Tip.

### A-2 (KLEIN) — clang-format-22-Lauf im Bericht nicht ausgewiesen → **BEHOBEN**

Eigene Verifikation des Fund-Belegs: `grep -c 'clang-format' mess-fenster-ergebnis.md` VOR dem
Nachtrag = 0 (grep rc=1). Fund bestaetigt.

Vollzogener Fix: EIGENMESSUNG (nicht die Audit-Zahl uebernommen) + Beleg-Zeile im Bericht:
- Messung: `~/.local/bin/clang-format-22 --dry-run -Werror` (Version literal: "Ubuntu clang-format
  version 22.1.8 (++20260613092238+e80beda6e255-1~exp1~20260613092253.78)") ueber ALLE 19
  geaenderten .hpp/.cpp aus `git diff --name-only 66de5c09..3a746090` (20 Diff-Dateien, davon
  19 Lint-Dateien + tests/unit/CMakeLists.txt; Worktree == Tip, porcelain 0). Ergebnis literal:
  **"BILANZ: 0 von 19 Dateien mit Abweichung"**.
- Beweis-Log persistiert (je Datei OK/ABW + Bilanz):
  /home/comdare/backups-workflow/20260821-w2-audit-fixverify/messfenster/fmt-eigenmessung-fixR1.log
- Berichts-Nachtrag: Bullet "[A-2]" jetzt Z.209-213 der mess-fenster-ergebnis.md;
  `grep -c 'clang-format'` NACH Nachtrag = 1 (Berichts-Luecke geschlossen).
- Deckungs-Aussage: Eigenmessung deckungsgleich mit der Audit-Nachmessung (beide 0/19) — zwei
  unabhaengige Laeufe, dasselbe Objekt 3a746090.

--------------------------------------------------------------------------------

## 2. WARUM KEIN BAU-SLOT / KEINE COMMITS / KEIN PUSH (Begruendung mit beiden Mengen)

- 0 Code-Deltas: BEIDE Fixwege schreiben "Kein Code-Delta am Branch (noetig)" (Audit Z.366/Z.376);
  alle Fix-Gegenstaende liegen in backups-workflow-Berichten. Folge: 0 neue Commits, Tip
  unveraendert `3a746090ae6abb95ae9c1bce498e1cf54d81f1f3`; "Nach jedem Fix-Commit push -o ci.skip"
  ist gegenstandslos (die Ref-Sicherung steht, eigener ls-remote-Beleg oben). porcelain nach
  Abschluss: 0 (Worktree unberuehrt).
- 0 Code-Funde → 0 T-1-Rot-Beweise noetig (T-1 gilt "je Code-Fund"); es gibt keinen Rot-Lauf zu
  persistieren. Persistiert wurde stattdessen das Format-Beweis-Log (fmt-eigenmessung-fixR1.log).
- Bau-Treppe NICHT gefahren (kein Slot gezogen): Ihr Gegenstand waere der byte-identische Tip, den
  der Strang bereits voll gruen fuhr (Berichts-Literale J-0b..ctest 511/511) und den das Audit
  Punkt-fuer-Punkt statisch verifizierte — das Audit selbst zog aus demselben Grund keinen Slot
  (audit-runde-1.md Z.9-11). Der doktrinal geforderte FRISCHE Beweis (7er-J-1 → RE-CONFIGURE →
  Vollbau → ctest, 4-Zellen) gehoert per K17 an den GEMERGTEN ENDSTAND (Audit P-13 + §4; ein Lauf
  am Tip wuerde ihn NICHT ersetzen) und ist dort ohnehin Pflicht; das Worktree-build/-Verzeichnis
  ist zudem planmaessig entfernt (Strang-Bericht Z.237), ein Tip-Neuaufbau wuerde einen der 3
  geteilten Slots des laufenden W1L-Kombibaus fuer einen Beweis ohne neuen Gegenstand binden.
  BEIDE Mengen: GEDECKT durch diese Runde = Berichts-/Beweis-Nachtraege + statische Objekt-
  Verifikate + Format-Eigenmessung; NICHT GEDECKT (Traeger: Lande-Zug K17/H-7) = frischer
  Treppen-/ctest-Lauf und 4-Zellen-Kombibau am Merge-Endstand.
- clang-format-22 "ueber jede geaenderte Lint-Datei": gefahren als --dry-run-Eigenmessung 0/19
  (keine Datei veraendert — es GAB nichts nachzuformatieren; ein Format-Schreib-Lauf haette bei
  0 Abweichungen ein leeres Delta erzeugt).

--------------------------------------------------------------------------------

## 3. ENTWURF fuer das Lande-Zug-Protokoll (Lead-only einzupflegen; deckt A-1-Fixweg-Komponente 1)

In den K17-Kombibau am gemergten Endstand (Phase 3/4 der Synthese-Reihenfolge) woertlich
aufnehmen:

```
J-1 (SIEBEN Werkzeuge, Liste literal ins Protokoll):
cmake --build <bau> --target comdare_adhoc_emitter_cli comdare_anatomy_codegen_cli \
  comdare_axis_registry_gen comdare_catalog_codegen_cli comdare_measurement_axis_registry_gen \
  comdare_overlay_source_hash_gen comdare_system_axis_registry_gen
danach RE-CONFIGURE -> Vollbau (--target all) -> comdare_profile_run_facade -> comdare_tests ->
ctest --no-tests=error (Bilanz literal). Werkzeug-LISTE + RCs literal ins Lande-Protokoll.
Zusatzzeile Phase-3-Warnungs-Review: Format-Stand mitfuehren
("clang-format-22 dry-run 0/N Abweichungen am Merge-Endstand").
```

Hinweis fuer den Lande-Zug: die drei *_registry_gen sind EXCLUDE_FROM_ALL — sie werden NUR von
der expliziten J-1-Zeile gedeckt; ein "all"-Gruen allein beweist sie nicht (Messung §1/A-1 Nr. 3).

--------------------------------------------------------------------------------

## 4. SELBSTCHECK

Vollzaehligkeits-Gate: 2/2 Fund-IDs quittiert (A-1 BEHOBEN, A-2 BEHOBEN; 0 ENTLASTET, 0 VERTAGT).
Jede Quittung traegt eigene Belege (Voll-Lesungen, git-grep/-show-Literale @ 3a746090, eigener
clang-format-Lauf mit persistiertem Log, ls-remote); die Audit-Zahlen wurden unabhaengig
reproduziert, nicht uebernommen. Geschrieben wurde AUSSCHLIESSLICH unter backups-workflow
(Nachtrag additiv, ASCII-only-Probe rc=1; dieses Protokoll; fmt-Log) — ce-Worktree porcelain 0,
Hauptklon nur gelesen, Ledger/Board/Memory/Vault unberuehrt, TABU-Zonen unberuehrt, golden
unberuehrt, kein YAML. Kein Bau-Slot gezogen (Begruendung §2, beide Mengen benannt). Tip
unveraendert; ENTWURF §3 an den Lande-Zug uebergeben.

--------------------------------------------------------------------------------

## 5. WIEDERANLAUF-NACHTRAG (23.08.2026 — additive Re-Verifikation, Schema-Ablieferung)

ANLASS: Der Workflow-Orchestrator startete die Fix-Stufe A2.5 R1 erneut — das Schema-Ergebnis
(StructuredOutput) der 22.08.-Session hat ihn nie erreicht (Klasse "stummer Workflow-Tod";
journal-seitig blieb die Stufe offen). Vorgefunden wurden ALLE Artefakte der 22.08.-Session
vollstaendig (dieses Protokoll §1-§4, fmt-eigenmessung-fixR1.log, Nachtrag Z.193-213 im
Strang-Bericht) SOWIE audit-runde-2.md (RE-VERIFY, VERDIKT "SITZT", 0 neue Funde, M-1..M-12).
Wiederanlauf-Doktrin: nichts abgeschrieben — VIERTE unabhaengige Messreihe gefahren (nach
Audit R1, Fix R1, Audit R2), alle Literale dieser Session:

- W-1 Objekt: `git rev-parse HEAD` = `3a746090ae6abb95ae9c1bce498e1cf54d81f1f3` == `git ls-remote
  origin refs/heads/bau/messfenster`; porcelain-Zeilen 0; Commit-Autor/Trailer "Claude Fable 5
  <noreply@anthropic.com>". Tip byte-identisch mit dem von Audit R1/R2 vermessenen Stand.
- W-2 [A-1] Alt-Literal "J-1 6 Werkzeuge rc=0" GENAU 2x (Z.186 + Z.254, grep -n) — Alt-Text
  erhalten, Nachtrag-Weg eingehalten; Bericht 266 Zeilen; ASCII-Probe Z.193-213: 0 Treffer (rc=1).
- W-3 [A-1] Alle SIEBEN Doktrin-Werkzeuge am Tip mit eigener add_executable-Definition (git grep
  @ 3a746090, 7 Treffer): adhoc_emitter_cli apps/adhoc_emitter/CMakeLists.txt:7 ·
  anatomy_codegen_cli apps/anatomy_codegen_tool/CMakeLists.txt:3 · catalog_codegen_cli
  apps/catalog_codegen_tool/CMakeLists.txt:3 · axis_registry_gen tools/axis_registry_gen/
  CMakeLists.txt:27 (EXCLUDE_FROM_ALL) · measurement_axis_registry_gen tools/measurement_axis_
  registry_gen/CMakeLists.txt:10 (EXCLUDE_FROM_ALL) · system_axis_registry_gen tools/system_
  axis_registry_gen/CMakeLists.txt:10 (EXCLUDE_FROM_ALL) · overlay_source_hash_gen
  tools/overlay_source_hash_gen/CMakeLists.txt:44 (OHNE EXCLUDE_FROM_ALL; Kopf Z.3 woertlich
  "NICHT EXCLUDE_FROM_ALL (anders als die Registry-Generatoren)").
- W-4 [A-1] all-Bindung des siebten Werkzeugs selbst gemessen: cmake/overlay_source_hash.cmake:37
  `add_custom_target(comdare_overlay_source_hash ALL` + :38 `COMMAND
  $<TARGET_FILE:comdare_overlay_source_hash_gen>` + :45 `add_dependencies(comdare_overlay_source_
  hash comdare_overlay_source_hash_gen)` — der Strang-Schritt "--target all rc=0 (2515 Schritte)"
  baute es zwingend (deckt Audit-R2-Befund M-9 "doppelt zwingend" unabhaengig).
- W-5 [A-1] Rekonstruktions-Quellen selbst gelesen, alle drei wortgleich DIESELBE Sechser-Liste
  (mit adhoc_emitter_cli, OHNE overlay_source_hash_gen): s19-simulation-ergebnis.md:229-231 ·
  skip-oekonomie-97-ergebnis.md:104-106 · traegerbau-s8-ergebnis.md:131-133 ("alle *_registry_gen
  am Objekt = genau diese 3; ninja -t targets").
- W-6 [A-2] Diff-Menge selbst hergeleitet: 19 .hpp/.cpp von 20 Diff-Dateien
  (git diff --name-only 66de5c09..3a746090). EIGENER Lauf `~/.local/bin/clang-format-22
  --dry-run -Werror` ("Ubuntu clang-format version 22.1.8 (++20260613092238+e80beda6e255-1~exp1~
  20260613092253.78)") ueber alle 19: **"WIEDERANLAUF-BILANZ: 0 von 19 Dateien mit Abweichung"**
  — vierter unabhaengiger 0/19-Lauf; Log ADDITIV persistiert:
  fmt-eigenmessung-fixR1-wiederanlauf23.log (das 22.08.-Log unangetastet).
- W-7 [A-2] `grep -c 'clang-format' mess-fenster-ergebnis.md` = 1 (Berichts-Luecke geschlossen).

ERGEBNIS: Beide Quittungen (A-1 BEHOBEN, A-2 BEHOBEN) halten der vierten Messreihe stand und
werden mit DIESEN Belegen an den Orchestrator quittiert. Unveraendert aus §2: 0 Code-Deltas,
0 Commits (Tip 3a746090), push gegenstandslos, kein Bau-Slot (der frische 7er-Treppen-/ctest-/
4-Zellen-Lauf gehoert per K17 an den GEMERGTEN Endstand — Traeger Lande-Zug, ENTWURF §3).
Geschrieben in dieser Session NUR: dieser §5 (additiv) + das Wiederanlauf-Log.
