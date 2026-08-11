# PLAN 10.08.2026 -- Skript-Abloesung (A) und ISA-Merkmale (B)

ENTWURFSDOKUMENT. Zwei Plaene, ein Dokument. Hier wird nichts gebaut, nichts gepusht, keine Pipeline ausgeloest.

## Auftrag (Owner, 10.08.2026 08:43 UTC, roh verifiziert: 5a19728e-...jsonl:33682, type=user, promptSource=typed)

  (1) "Hinweis: Skripte waren verboten, bitte explore dazu. Du kannst gerne einen kompletten ultracode workflow
      starten, um die Skripte und waechter alle gegen C++ Versionen mit google tests zu ersetzen, danke.
      Bitte erst gruendlich lesen."
  (2) "Weiterhin gibt es dutzende Flags bei AVX und nicht nur 'f' fuer AVX512 -> da fehlt so einiges
      (explore im ledger und session log)."

Aelterer Kern (09.08. 14:34 UTC, roh verifiziert: dieselbe Datei Z. 25562; Original in normaler Satzschreibung,
die Vollversalien-Fassung ist Agenten-Betonung): "Ich sehe einen Haufen shells statt vernuenftiger google tests,
was soll das? ... Skripte sagen gar nichts. Bitte recherchiere Mutations-Sicheres Testen. Die Waisen muessen
fertig gebaut werden, also die C++ Implementierung dazu."

## Zeitanker (T-9) und Nenner (V-1)

- super = /home/comdare/wt-super-landung, development. Erhebung bei HEAD eb8b328b (09:02:07Z); beim Schreiben
  dieses Plans bereits 5ae7c3a2 (09:03:55Z) -- der Baum ist LEBEND, alle Zeilenanker sind am SHA zu pruefen.
- ce = origin/development 9f932e91 (06:28:47Z), read-only per git show erhoben (kein Worktree stand auf dev).
- Skript-Bestand: 58 Dateien (ce 20 + super 38), Auftragszahl 21.510 Zeilen; eigene Messung 20.666 Zeilen
  (Differenz = belegte Live-Drift durch fremde Commits waehrend der Erhebung, beide Zahlen mit Quelle gefuehrt).
- Code/ci_wachen (super): 24 Dateien selbst gezaehlt (1 CMakeLists + 9 include-Header + 8 src + werkbank.hpp/cpp
  + 4 tools-mains). Die Auftragszahl 18 war ein aelterer Stand; das Verzeichnis wuchs waehrend der Erhebung live
  um ci-wide-aggregat und ci-mutations-lauf.
- Quellen: vier Explore-Erhebungen vom 10.08. (Skript-Kartierung, Owner-Wort-Skripte, AVX-Ledger, AVX-Objekt),
  alle Befunde dort mit Datei:Zeile/SHA. Dieses Dokument zitiert nur, was dort am Objekt gemessen wurde.

Randkorrekturen aus den Erhebungen, hier bindend uebernommen:
- AVX512O/H/T sind KEINE Flags -- Grep-Substring-Artefakte aus drei GoogleTest-Namen (test_dataset_filter.cpp
  Z. 35/52/215). Die Owner-Schlussfolgerung (Leiter zu grob) bleibt richtig, dieser Einzelbeleg nicht.
- Die Zeichenkette "isa:avx2+avx512f" existiert an 9f932e91 nicht woertlich; gemeint ist die AND-Bedingung in
  scripts/ci_test_sichtbarkeit_allowlist.txt:44. Die Gegenstandsart "isa:" mit ERLOSCHEN-Richtung existiert.

================================================================================================================
# PLAN A -- DIE SKRIPT-ABLOESUNG
================================================================================================================

## A.0 Grundsatz: priorisieren, nicht alles versprechen

58 Dateien / rund 21.000 Zeilen passen nicht in das Fenster bis 15.09. (Wellenplan: 26 von 27 Werktagen belegt).
Der Plan teilt darum in: PFLICHTKERN (A1-A4), STRECKLISTE (A5-A7, faellt zuerst vom Tisch), NICHT-PORTIEREN
(Klassen N1-N4, ausdruecklich mit Grund). Zweitens: die 12 super-Proben und 3 ce-Selbsttest-Shells (~7.500 Z.)
werden NICHT 1:1 portiert -- sie werden durch die Google-Tests der jeweiligen C++-Wache ERSETZT und fallen mit
ihrer Wache (Paar-Regel). Damit schrumpft die echte Portmenge auf etwa die Haelfte des Bestands.

## A.1 Reihenfolge -- Kriterien und Begruendung

  K-1 URTEIL:  faellt die Datei ein CI-Verdikt (Waechter)? Werkzeuge sind nachrangig -- der Owner-Kern zielt
               auf Urteils-Instanzen ("Skripte sagen gar nichts", "Skripte und waechter").
  K-2 BLIND:   hat sie heute keinen Selbsttest, oder war sie schon einmal nachweislich blind (HOHLE WACHE in
               hardware_filter, Posten "#51 Diff-Hygiene blind fuer Shell", Untergrenze falsch-rot auf prod2)?
  K-3 FERTIG:  existiert der C++-Nachfolger schon (Stufe 1 von 2)? Billigster Abschluss zuerst -- Kanon
               FERTIGE ARBEIT LANDEN.
  K-4 PFAD:    liegt sie auf dem kritischen Pfad (jeder Push, jede Landung, jeder Testlauf)?
  K-5 KOSTEN:  Abloesbarkeitsklasse Text (leicht) < git/Prozess (mittel) < Netzwerk (schwer).
  K-6 EINMAL:  Dateien, die Plan B ohnehin umbaut (Host-Klassen-Familie), werden in Plan A NICHT angefasst --
               kein Doppelport derselben Logik.

Daraus die Paketfolge: A1 (Meta-Wache, geboren rot) -> A2 (die fuenf Fertigen umlegen) -> A3 (der Zwilling auf
dem kritischen Pfad, heilt #51) -> A4 (die vier Selbsttestlosen, w0a-Biss vollenden) -> A5 -> A6 -> A7.

## A.2 Schnittmenge mit dem Bestand Code/ci_wachen

VORHANDEN (super, HEAD 5ae7c3a2): ci_yml_scanner, ergebnis, git_quelle, gitlink_parity, mutations_lauf,
prozess, wide_aggregat, xml_parser, xml_wellformed (je .hpp/.cpp), testwerkbank/werkbank.hpp+.cpp,
4 tool-mains. Dazu ci-mutations-lauf als C++-Mutationsharness (bewusst noch nicht im YAML verdrahtet --
Verdrahtung ist Owner-/Lead-Entscheid, er schreibt in Produktionsdateien).

FEHLENDE BAUSTEINE, damit A1-A6 portierbar sind (je mit erstem Verbraucher):
  1. diff_quelle      -- push-lokaler Diff-Bereich + Datei-Klassifikation (A3). git_quelle deckt Rohzugriff,
                         nicht die Bereichslogik "push-lokal, nie kumulativ" (Referenz Diff-Hygiene-Wache).
  2. ctest_inventar   -- Parser fuer ctest -N + Registrierungs-Abgleich (A4, A6, B3).
  3. text_spalten     -- awk-Ersatz: Spalten-/Schluessel-Wert-Parse fuer die Text-Wachen (A5).
  4. koeder_quelle    -- K13-Koeder-Generator, /dev/urandom-gespeist, seedbar fuer Wiederholbarkeit (alle).
  5. allowlist_leser  -- Gegenstandsarten (isa:, prt-art), ERLOSCHEN-Richtung (A4, B4).
  6. cmake_cache_leser-- CMakeCache-Werte typisiert lesen (B1-B3).
  7. werkbank in ce   -- wachen_werkbank.hpp aus wt-ce-w0a landen (T-6-Symmetrie beider Repos).
OFFEN (Lead): Ort des gemeinsamen Kerns fuer Zwillinge (A3). Zwei Wege: (a) Kern in ce, super nutzt den
vendored Stand -- koppelt an die bekannte Vendor-Sync-Falle (super-CI zieht neue ce-Submodule-Commits nicht);
(b) Duplikat je Repo plus Byte-Paritaets-Wache (heutiges Zwillings-Muster, maschinell bewacht statt manuell).
Vorschlag: (b) im Fenster, (a) als Zielbild danach. Entscheid vor A3-Baubeginn.

## A.3 Die Pakete

### Paket A1 -- Meta-Wache ABLOESUNGS-PARITAET (neu, klein, zuerst)
Gegenstand: Manifest scripts/abgeloest.txt (ein Basename je Zeile, Repo-getrennt) + .gitlab-ci.yml-Scan
(Baustein ci_yml_scanner). Zwei Urteile, beide fail-closed:
  (a) ein abgeloester Basename wird noch per sh/bash im YAML gerufen -> ROT;
  (b) eine C++-Wache existiert als Binary/Testquelle, hat aber keine ctest-Registrierung -> ROT (T-7).
T-1 ROT ZUERST ist hier woertlich: die Wache wird am heutigen Stand GEBOREN ROT (fuenf Abgeloeste, YAML ruft
noch Shell -- der Stufe-1-von-2-Befund). Erst A2 macht sie gruen. Das ist der maschinelle Anker der
Migrations-Invariante (A.5) -- die Klasse "zwei Kopien derselben Logik" bekommt einen Waechter.
Aufwand: 1-2 PT. Abnahme: Google Test Debug UND Release (T-6), Registrierung unter ctest -L ci_wachen; rot am
IST-Stand mit woertlichem Output, gruen nach A2 -- kein Erfolgsvermerk ohne Literal-Output.
Koeder (K13, beidseitig): Wegwerf-YAML mit urandom-benanntem sh-Aufruf eines gelisteten Namens -> muss beissen;
dasselbe YAML ohne Aufruf -> gruen. Fallen-Gegenprobe: Namen mit ".gitlab-ci.yml"-Substring und /builder/-Pfad
in den Koeder aufnehmen (bekannte Substring-Fallen aus dem Fallen-Register).

### Paket A2 -- Umschaltung der fuenf bereits Abgeloesten (Stufe 2 von 2)
Dateien: ci/thesis_gitlink_parity.sh + Probe, scripts/ci_xml_wellformed_guard.sh (super) + Probe,
ci/wide_aggregat.sh. C++-Nachfolger existieren, kompilieren, sind getestet -- die CI ruft noch Shell.
Arbeit: YAML-Aufrufe auf die C++-Fassung umlegen (Fundstellen bei Erhebung: 307/322, 341/356, 376/391,
1076/1077/1092, 2188/2189/2210 -- Zeilen driften, am Bau-SHA neu messen), Shell-Fassung im SELBEN Commit nach
scripts/deprecated/ verschieben (Doku-Kanon: nie loeschen) und in abgeloest.txt eintragen (macht A1 gruen).
Vorbehalt, als Annahme markiert: die Quell-Kommentare verlangen "Lead-Entscheid nach Abnahme" -- dieser Plan
liest den Owner-Auftrag vom 10.08. als genau diesen Entscheid. Widerspricht der Owner, bleibt A2 liegen und
A1 bleibt rot = sichtbarer offener Punkt statt stiller Zustand.
Aufwand: 1-2 PT. Abnahme: A1 gruen; je Wache VOR dem Umlegen ein Koeder beidseitig (derselbe Koeder macht
Shell UND C++ rot; Gut-Eingabe gruen auf beiden). wide_aggregat zusaetzlich: Byte-Vergleich alt/neu an drei
echten Eingaben (das CLI ist als byte-kompatibel gebaut -- das wird gemessen, nicht geglaubt).

### Paket A3 -- Der Zwilling: diff_ascii_width_guard (ce 494 Z. + super 558 Z., EIN Kern)
Hoechste Wache auf dem kritischen Pfad (jeder Push, beide Repos), byte-fast-identische Doppelpflege heute.
Ein C++-Kern (git_quelle + neuer Baustein diff_quelle), zwei duenne Registrierungen (T-6: Debug+Release in
beiden Repos). Im selben Zug wird Posten #51 geheilt: Whitelist statt Blacklist -- die Shell-Blindheit der
Diff-Hygiene faellt mit dem Port, nicht danach. Messbereich bleibt push-lokal, nie kumulativ.
Aufwand: 3-4 PT. Abnahme: alte und neue Fassung ueber denselben drei echten Push-Bereichen mit identischem
Verdikt (Literal-Output beider), erst dann Umlegen+Stilllegen im selben Commit (A1 wacht).
Koeder (K13): (1) Nicht-ASCII-Byte aus /dev/urandom in Wegwerf-Commit, (2) Zeile >120 Byte, (3) Datei einer
heute ungeprueften Klasse (Shell) -- alle drei muessen beidseitig beissen; sauberer Commit gruen.

### Paket A4 -- T-6-Biss vollenden + die vier selbsttestlosen ce-Wachen
Dateien: ci_achsen_roundtrip_wache, ci_test_registrierungs_wache, ci_test_sichtbarkeit_wache (Biss-Proben
liegen UNFERTIG in wt-ce-w0a: wachen_werkbank.hpp + drei test_t6_biss_*.cpp, offener Merge-Konflikt) plus
ci_hy_label_gate (vierte ohne Koeder-Selbsttest, laeuft indirekt ueber ctest-Registrierung tests/CMakeLists:25).
Schritt 1: w0a LANDEN -- fremde, fertige Arbeit zuerst landen, nicht duplizieren. Der Konflikt gehoert dem
Strang, der ihn haelt; dieses Paket beginnt erst nach dessen Landung (Abhaengigkeit ausdruecklich notiert).
Schritt 2: T-1: die gelandeten Biss-Tests muessen die SHELL-Wachen beissen (rot am praeparierten Objekt).
Schritt 3: Port der vier Wachen auf C++ (Bausteine: ctest_inventar, allowlist_leser, prozess, werkbank-ce);
dieselben Biss-Tests muessen die C++-Fassung identisch beissen -- der Biss ist der Traeger der Aequivalenz.
Achtung Kopplung: ci_test_sichtbarkeit_wache referenziert COMDARE_HOST_RUNS_AVX512F an 2 Stellen -- der Port
haelt die Merkmalsabfrage hinter der allowlist_leser-Schnittstelle, damit B4 sie ohne zweiten Port umstellt.
Aufwand: 5-7 PT (nach w0a-Landung). Abnahme: je Wache Biss beidseitig + Registrierung Debug/Release.
Koeder: die w0a-Bisse plus je ein frischer K13-Koeder aus /dev/urandom (nie nur der historische Koeder).

### Paket A5 -- Die neun text-leichten super-Wachen (STRECKLISTE)
anker, bestandslog, durchstich, frische, zellkoordinaten, lauf_marker (DUAL), mess_ausbeute, plan_zahlen,
tests_registrierung. Reihenfolge innerhalb: tests_registrierung_wache ZULETZT -- sie ist Meta-Wache ueber die
12 Proben und aendert ihren Gegenstand mit jeder Stilllegung; sie wird am Ende auf "zaehlt Google-Tests mit
Label ci_wachen" umgestellt (T-7 bleibt: Registrierung ist Teil des Tests).
Proben-Ersatz: die TMPDIR-Wegwerf-Repos der Proben werden Google-Tests auf der werkbank; jede Shell-Probe
faellt im selben Commit wie ihre Wache (Paar-Regel), Eintrag in abgeloest.txt, A1 wacht.
Aufwand: 8-12 PT. Abnahme je Wache wie A3 (Verdikt-Vergleich an echten Eingaben). Koeder: der Bestands-Koeder
der jeweiligen --selbstbiss-Probe wird uebernommen UND um einen frischen urandom-Koeder ergaenzt (K13).

### Paket A6 -- Prozess-Wachen ce (STRECKLISTE)
ci_test_bauweg_wache, ci_test_coverage_guard (+manifest als Bibliotheksfunktion, kein eigenes Binary),
ci_xml_wellformed_guard (ce -- super-Baustein xml_wellformed.hpp direkt wiederverwenden), ci_yaml_key_guard,
lint_layer_includes + lint_flags_includes (eine Include-Lint-Wache; Achtung: lint_flags haengt an GitHub
Actions .github/workflows/ci.yml:22, beide Aufrufer umstellen, sonst lebt dort eine Shell-Kopie weiter).
Aufwand: 6-8 PT. Abnahme/Koeder wie A3/A5; bauweg-Wache erbt ihren K13-urandom-Koeder aus dem Bestand.

### Paket A7 -- git-mittlere super-Reste (STRECKLISTE, letztes Paket)
ci_abnahme06_bedingungs_tabelle (+Selbsttest-Ersatz), persist_sammler (DUAL: sammeln=Werkzeug, gate=Waechter --
nur der gate-Teil ist Portpflicht nach K-1). vor_push_alle_wachen.sh wird NICHT portiert, sondern AUFGELOEST:
sobald die ce-Wachen C++ sind, ist der Treiber ein ctest-Aufruf (ctest -L ci_wachen, Debug+Release) -- ein
Skript weniger statt ein Skript uebersetzt. Aufwand: 4-6 PT.

## A.4 Was NICHT portiert wird -- Klassen, Groesse, Grund

  N1 NETZWERK/S3 (4 Dateien, 862 Z.): object_stat_abnahme (183), object_stat_wache (444),
     comdare_storage_activation (64), fetch_testdata (171). Grund: mc/curl/S3-Credential-Faltung IST hier das
     Werkzeug; ein C++-Port zoege HTTP/S3-Client + Credential-Handling in den Bau -- teurer als der Nutzen,
     und die Urteilslogik ist minimal. Bleiben Shell. Das braucht ein AUSDRUECKLICHES Owner-GO als benannte
     Ausnahme vom "alle"-Auftrag -- hier beantragt, nicht stillschweigend genommen.
  N2 WAISEN (3 Dateien, 452 Z.): copy_results_to_nas (59, Owner-Entscheid 18.07.: NICHT LOESCHEN, Referenz),
     koeder_clang_constexpr_grammatik (154), koeder_clang_cwg1430 (239) -- Regressionsproben bereits geheilter
     Compiler-Bugs, nur manuell. Grund: kein Urteil, kein Aufrufer; deprecaten statt portieren.
  N3 WERKZEUGE MIT GIT/PUSH-SEITENEFFEKT (2 Dateien, 646 Z.): anhang_forward_core (538, LaTeX-Anhang-Kanal:
     kopiert/committet/pusht), ledger_nachtrag (108, Mensch/Agent-Textwerkzeug). Grund: kein Verdikt (K-1);
     ein C++-Programm, das git-Kommandos orchestriert, ist Formwechsel ohne Sicherheitsgewinn. Kandidaten fuer
     NACH dem Fenster, nicht Verzicht fuer immer.
  N4 AN PLAN B DELEGIERT (4 Dateien, 1.618 Z.): ci_host_klassen_bericht (566) + Selbsttest (427),
     ci_host_klassen_gegenorakel (309) + Selbsttest (316). Grund K-6: diese Familie wird durch das
     Merkmals-Mengen-Modell inhaltlich umgebaut -- sie wird EINMAL angefasst, in B2, als C++.
  Dazu: 12 super-Proben (6.955 Z.) + 3 ce-Selbsttest-Shells (577 Z.) -- nicht portiert, sondern durch die
  Google-Tests der C++-Wachen ersetzt (Paar-Regel, siehe A.0).

Summe nicht-portiert/ersetzt: rund 10.100 von 21.500 Zeilen -- der Plan sagt das offen, statt Vollstaendigkeit
zu versprechen, die das Fenster nicht hergibt.

## A.5 Die Migrations-Invariante -- gegen "zwei Kopien derselben Logik"

  1. EIN URTEIL JE GEGENSTAND: Umschaltung (YAML/ctest ruft C++) und Stilllegung der Shell geschehen im
     SELBEN Commit. Kein Schattenbetrieb ueber allow_failure -- das ist seit 06.07. VERBOTEN (Job hart rot).
  2. HART VON TAG EINS: die C++-Wache laeuft ab ihrer Landung als Google Test in den bestehenden Test-Jobs
     (Debug UND Release, T-6) und ist hart rot-faehig. Im Uebergangsfenster urteilen BEIDE hart -- das ist
     fail-closed und erlaubt; gefaehrlich ist nur die heutige Stufe-1-Lage (C++ steht daneben, Shell urteilt).
  3. MASCHINELL BEWACHT: Paket A1 erzwingt beide Richtungen -- abgeloest ohne YAML-Stilllegung = rot,
     C++-Wache ohne Registrierung = rot (T-7). Die Invariante haengt nicht an Disziplin, sondern an einer Wache.
  4. KOEDER VOR DEM UMLEGEN (K13): derselbe Koeder beisst Shell UND C++, die Gut-Eingabe ist auf beiden gruen,
     beides mit woertlichem Output im Abnahmeprotokoll. Erst dann wird umgelegt.
  5. STILLLEGUNG = VERSCHIEBUNG nach scripts/deprecated/ mit Kopfvermerk (Doku nie loeschen) + Manifestzeile.
  6. GEGENPROBE NACH JEDEM PAKET: /usr/bin/grep -n "sh ci/\|sh scripts/\|bash ci/\|bash scripts/" ueber beide
     .gitlab-ci.yml, Ergebnisliste gegen abgeloest.txt -- einmal je Paket-Abnahme, mit Nenner in der Ausgabe.

================================================================================================================
# PLAN B -- DIE ISA-MERKMALE
================================================================================================================

## B.0 Lagebild (aus den Erhebungen, am Objekt)

Drei unverbundene AVX-Vokabulare existieren: (a) die Zwei-Merkmal-Erkennung der Wachen/CMake
(COMDARE_HOST_RUNS_AVX2/AVX512F, je zweimal dupliziert in ce tests/unit/CMakeLists.txt), (b) der 62-Eintraege-
Katalog flag_grammar_catalog.hpp mit 14 x512-Einzelflags (gebaut+gelandet 07.08., static_assert-gehaertet),
(c) die 15 provides_avx512*-Methoden der Organ-Achse axis_09b (12 davon pauschal true = Ueber-Behauptung ohne
produktiven Konsumenten, tautologisch getestet). Dazu drei unabhaengige ERKENNUNGEN (CMake-Laufprobe,
cpuid_probe.hpp, Praeprozessor-Makro der eigenen TU -- letztere die dokumentierte HOHLE WACHE in
hardware_filter.hpp). Die eigentliche Luecke ist die fehlende VERBINDUNG, nicht die fehlende Liste.

## B.1 Die Merkmalsliste des Projekts -- gebraucht vs. genannt

GEBRAUCHT vom Produktionscode heute (Urteils-/Bau-relevant):
  avx2      -- Bau-Flag -mavx2, CMake-Gates, SIMD-Dispatch-Tests.
  avx512f   -- einziger echter _mm512-Bedarf im Nicht-Test-Code: 4 Intrinsics in axis_09_isa_amd64.hpp:88-97,
               alle reines F. Zwischen Bedarf und Bau-Flag klafft hier KEINE Luecke.
GEBRAUCHT von der Provenienz (cpuid_probe.hpp liest heute): avx2, avx512f, avx512bw, avx512vl.
GENANNT/DEKLARIERT, ohne produktiven Konsumenten (Katalog + Achse + Maschinen-Signaturen):
  die 14 x512-Katalogflags: f cd vl dq bw ifma vbmi vbmi2 vnni bitalg vpopcntdq vp2intersect bf16 fp16;
  dazu im 62er-Katalog: 12 x256-, 10 x128-Subflags, 3 companion (gfni vaes vpclmulqdq), 9 skalar, 5 m64.
  Maschinen-Signaturen handkuratiert: Prod1Zen5 = 13 x512-Flags (kein fp16); prod2 RaptorLake = AVX-512
  fused-off (leere x512-Menge) -- die Halbordnung ist real, keine Kette.
ABGELEHNT mit gemessener Begruendung (Reserve-Tabelle, 14 Tokens): avx10 (BasisStrittig, GCC/MSVC-Widerspruch),
  er/pf/4vnniw/4fmaps (NichtBaubar, Xeon-Phi-Erbe), u. a. -- diese Ablehnungen BLEIBEN.

SOLL fuer die Wachen in diesem Fenster: die Menge {avx2} + die 14 x512-Flags. Nicht mehr. x256-/x128-Subflags
kommen erst, wenn ein CMake-Gate oder Organ sie wirklich fordert -- fail-closed: ein unbekanntes Token in
irgendeiner Anforderung ist ROT, nie stumm ignoriert.

## B.2 Die Form: zwei Ebenen -- Kette fuer den Bau, Menge fuer die Merkmale

EBENE 1, BAU-STUFE (Kette, BLEIBT): no_extension < avx2 < avx512. Sie traegt weiterhin: welches -m-Flag die
Binary baut (isa_features.cmake), die Registry-sub_axis "simd" (3 Optionen), die Klassenzuordnung der
Untergrenze. Begruendung: pro Binary zaehlt heute genau EIN Flag-Satz, und auf jeder realen x86-64-CPU
impliziert AVX-512F das AVX2 -- fuer DIESE Frage ist die Kette mathematisch korrekt. Die heutige Leiter wird
also nicht weggeworfen, sie wird auf ihren gueltigen Gegenstand verkleinert und umbenannt.

EBENE 2, MERKMALS-MENGE (NEU SCHARF): Host-Signatur = Menge kanonischer Katalog-Tokens (flag_grammar_catalog
liefert je Merkmal bereits das Tripel Grammatik-Token / cpuinfo-Id / -m-Schalter). Anforderung je Test/Organ =
Menge. Urteil = Teilmengen-Test (Anforderung Teilmenge der Host-Signatur), KEINE Rangzahl. Fail-closed:
unbekanntes Token, leere Signatur oder Widerspruch der Erheber -> BEFUND/rot -- das heutige RANG-minus-1-
Verhalten des Berichts wird uebernommen und verallgemeinert. Das ist exakt das im Bestand bereits inert
gebaute Modell simd_build_gate.hpp + machine_simd_signature.hpp (Ledger-Abschnitt 70.9, RF-6..RF-9):
FERTIGSTELLEN, nicht neu erfinden.

EINE ERHEBUNG statt drei: ein C++-Werkzeug isa-sonde (auf cpuid_probe.hpp, erweitert auf die 14 x512-Bits,
OS-Enablement-Gate OSXSAVE/XGETBV bleibt). CMake ruft die Sonde einmal und erhaelt COMDARE_HOST_ISA_MENGE
(Semikolonliste kanonischer Tokens). Die check_cxx_source_runs-Proben bleiben -- je Merkmal eine -- als
GEGEN-ORAKEL (T-4): beide Wege muessen dieselbe Menge liefern, Differenz = rot. Die Praeprozessor-Erkennung in
hardware_filter.hpp wird durch die Sonde ersetzt (eigene TU -- die Heilung, die der Code-Kommentar
test_dataset_filter.cpp:97-124 selbst benennt; das Paket ist dort als beim Owner liegend markiert -> B5).
Die zwei Alt-Booleans werden waehrend der Migration aus der Menge ABGELEITET und bleiben Quelle fuer
Alt-Konsumenten, mit Paritaets-Assert (Alt-Probe vs. Ableitung, Differenz rot).

WAS AUS DEN DREI TRAEGERN DER LEITER WIRD:
  Untergrenze (ci_test_inventory_floor): von einem harten Wert zu einer Zeile je Bau-Stufe (die "zweistufige
  Untergrenze" = genau der offene Posten D2-G5; heilt die akute prod2-Falsch-Rot-Regression, Pipeline 15515).
  Danach die Regel: jedes in CMake-Gates benutzte Merkmal MUSS eine eigene Untergrenzen-Zeile haben -- neues
  Gate-Merkmal ohne Zeile = rot. Die Untergrenze bleibt an Ebene 1 gebunden (heute 3 Klassen) und waechst nur,
  wenn ein Gate wirklich ein neues Merkmal abfragt -- keine kombinatorische Explosion (bei N freien Merkmalen
  waeren es 2^N Klassen; darum haengt sie NIE an der vollen Menge).
  Allowlist "isa:": BLEIBT als Gegenstandsart samt ERLOSCHEN-Richtung -- sie ist erst heute gebaut und
  erweiterbar, nicht falsch. Erweiterung: der Gegenstand traegt kuenftig eine Merkmals-MENGE in Plus-Schreibung
  (isa:avx2+avx512f+avx512vl); jedes Token wird gegen den Katalog geprueft, unbekannt = rot.
  Host-Klassen-Bericht: von der Rangzahl zum SIGNATUR-BERICHT -- gemessene Menge + abgeleitete Bau-Stufe +
  Abgleich gegen die handkuratierte Erwartung der Maschine (machine_simd_signature); Abweichung = BEFUND.
  Es gibt nur zwei Hosts (LOKAL=prod1, prod2), beide Erwartungen existieren bereits.

## B.3 Die Migration -- Reihenfolge, damit die drei Traeger nie gleichzeitig brechen

  B1 ERHEBUNG (additiv, aendert keinen Konsumenten):
     isa-sonde bauen (C++, Google Tests Debug+Release, T-6-symmetrisch ce/super soweit beide erheben);
     CMake-Gegen-Orakel je Merkmal; COMDARE_HOST_ISA_MENGE in den Cache; Alt-Booleans abgeleitet + Paritaets-
     Assert. Abnahme auf BEIDEN Hosts (prod1: 13 x512-Flags erwartet; prod2: leere x512-Menge erwartet),
     woertlicher Output beider Sonden-Laeufe im Protokoll.
     Koeder: Sonde besitzt einen Test-Injektionsmodus (gefaelschte CPUID-Antwort): Fantasie-Token -> rot;
     leere Menge auf einem Host, dessen Erwartung nicht leer ist -> rot. Aufwand: 2-3 PT.
  B2 BERICHT (erster Konsument, nur beobachtend):
     ci_host_klassen_bericht + gegenorakel als C++ (Plan-A-Klasse N4 landet hier), lesen die MENGE; das
     Gegenorakel konfiguriert weiter echte CMake-Presets je Bau-Stufe. Bricht der Umbau, blockiert er keine
     Registrierung -- darum zuerst. Die Gegenorakel-Asymmetrie (existiert nur in super, 0 Treffer in ce) wird
     hier geschlossen oder als bewusste Entscheidung dem Owner vorgelegt.
     Koeder: Erwartungs-Signatur einer Maschine um ein Flag verfaelscht -> BEFUND. Aufwand: 2-3 PT.
  B3 UNTERGRENZE (zweiter Konsument, urteilend):
     a) AKUT: zweistufig im alten Mechanismus (D2-G5) -- heilt die rote prod2-Pipeline, kleinster Eingriff;
     b) DANACH: Merkmal->Zeile-Regel im neuen Mechanismus (ctest_inventar-Baustein aus Plan A). Zwei getrennte
     Commits, nie beides in einem. Koeder: Untergrenze kuenstlich +1 ueber IST -> rot; Gate-Merkmal ohne
     Zeile -> rot. Aufwand: 1-2 PT.
  B4 ALLOWLIST/SICHTBARKEIT (dritter Konsument, urteilend):
     Mengen-Syntax fuer "isa:"-Gegenstaende; Datei + Wache im selben Commit (ein Repo, atomar). Kopplung zu
     A4: der Port der Sichtbarkeits-Wache haelt die Merkmalsabfrage hinter allowlist_leser -- liegt B1 vor A4,
     portiert A4 direkt auf die Mengen-Schnittstelle; sonst Alt-Semantik portieren und hier umstellen. Beide
     Wege sind zulaessig, der Bau-Strang dokumentiert den gewaehlten.
     Koeder: isa:-Zeile mit unbekanntem Token -> rot; ERLOSCHEN-Zeile, deren Gegenstand wieder auftaucht ->
     rot (heutiges Verhalten erhalten, an einem echten Beispiel gemessen). Aufwand: 1-2 PT.
  B5 EHRLICHKEIT + GATE (OWNER-GATED):
     provides_avx512{bw,dq,vl,...}-Ueber-Behauptung zuruecknehmen: Werte aus der Maschinen-/Bau-Signatur
     ableiten statt pauschal true; den tautologischen static_assert-Test durch Abgleich gegen die isa-sonde am
     realen Bau ersetzen (nur auf Hosts, deren Signatur das Merkmal traegt -- Ebene-2-Gate). Scharfschaltung
     von simd_build_gate = RF-6..RF-9: die Auflage existiert, der Termin nicht -- dieses Teilpaket startet nur
     auf Owner-GO. Das AVX10-Muster ("ehrlich nichts behaupten, was nicht gebaut ist") ist hier die Vorlage.
     Aufwand: 2-4 PT.

## B.4 Was an der heutigen Loesung RICHTIG bleibt (ausdruecklich)

  - Die "isa:"-Gegenstandsart der Allowlist samt ERLOSCHEN-Richtung: heute gebaut, erweiterbar -- wird
    Traeger der Mengen-Syntax, nicht ersetzt.
  - Die 3-Stufen-Kette als BAU-Stufe: fuer die Frage "welches -m-Flag baut die Binary" korrekt -- bleibt.
  - Das fail-closed-Verhalten des Berichts (unbekannte Klasse -> BEFUND): wird verallgemeinert, nicht entfernt.
  - flag_grammar_catalog.hpp als kanonisches Vokabular (62 + 14 Reserve, static_assert-gehaertet, dreifache
    Namen je Merkmal): einzige Namensquelle aller neuen Wachen.
  - Die begruendete AVX10-Token-Ablehnung (BasisStrittig) UND das getrennte Konvergenz-Versionsfeld (0/1/2):
    beide bleiben; ihre Zusammenfuehrung ist eine offene Owner-Frage, nicht Teil dieses Fensters.
  - cpuid_probe.hpp mit OS-Enablement-Gate: wird Kern der isa-sonde, nicht ersetzt.
  - Die handkuratierten Maschinen-Signaturen (Prod1Zen5 usw.): werden Erwartungswerte des Signatur-Berichts.

================================================================================================================
# FENSTER, AUFWANDSSUMME, RANG
================================================================================================================

PFLICHTKERN (Vorschlag): A1 (1-2) + A2 (1-2) + A3 (3-4) + A4 (5-7) + B1 (2-3) + B2 (2-3) + B3 (1-2) = 15-23 PT.
STRECKLISTE: A5 (8-12) + A6 (6-8) + A7 (4-6) + B4 (1-2) + B5 (2-4) = 21-32 PT.
Das Gesamtvolumen (36-55 PT) passt NICHT in das Fenster neben dem Wellenplan (26/27 Werktage belegt) -- der
Plan verspricht darum nur den Pflichtkern und legt die Streckliste dem Owner zur Rangfolge gegen die
Messkampagne vor. B3a (akute prod2-Heilung) ist unabhaengig vom Rest sofort faellig, da heute rot.
Reihenfolge-Abhaengigkeiten: A1 vor A2; w0a-Landung vor A4; B1 vor B2 vor B3b vor B4; B3a jederzeit;
B5 nur auf Owner-GO. Plan A und Plan B koppeln nur an zwei Stellen (N4->B2, A4<->B4), beide oben benannt.

================================================================================================================
# NICHT GELOEST / OFFENE PUNKTE (ehrlich, je mit Traeger)
================================================================================================================

  1. I24 vs. Owner-Kern 09./10.08.: kein Satz im Bestand entscheidet die Spannung ausdruecklich; die
     Schwester-Explore (owner-skriptverbot) traegt sie. Dieser Plan behandelt N1-N3 als BEANTRAGTE Ausnahmen
     vom "alle"-Auftrag -- sie brauchen ein ausdrueckliches Owner-GO.
  2. Ort des gemeinsamen C++-Kerns fuer Zwillinge (ce-Bibliothek ueber vendored Stand vs. Duplikat +
     Byte-Paritaets-Wache): Vorschlag Duplikat im Fenster (Vendor-Sync-Falle), Vereinigung danach --
     Lead-Entscheid VOR A3-Baubeginn.
  3. wt-ce-w0a haelt einen fremden offenen Merge-Konflikt; A4 haengt an dessen Landung. Nicht mein Objekt --
     Koordination mit dem haltenden Strang noetig, Termin unbekannt.
  4. Zahlen-Divergenzen des Auftrags, dokumentiert statt erzwungen: 21.510 vs. 20.666 Zeilen (Live-Drift);
     die AVX-Zaehlungen 48x/48x/26x nicht reproduziert (eigene Messung 17/11/29 an 9f932e91);
     "isa:avx2+avx512f" als Literal nicht existent (Paraphrase der AND-Bedingung).
  5. AVX10: Token-Ablehnung und Versionsfeld sind zwei Antworten auf dieselbe Frage -- Zusammenfuehrung bei
     echter AVX10-Hardware ist offene Owner-Frage.
  6. Q2-C vs. OF-1 (SIMD eigene System-Achse vs. Compiler-Unterachse) formal nie entschieden, nur sachlich
     ueberholt -- beruehrt B nicht unmittelbar, bleibt aber als Altlast stehen.
  7. Ob object_stat_wache.sh direkt aus dem YAML gerufen wird und ob comdare_storage_activation.sh je in einer
     laufenden Pipeline ausgefuehrt wird: beides offen; betrifft nur den Umfang von N1.
  8. Verdrahtung von ci-mutations-lauf in die CI (schreibt in Produktionsdateien): ausdruecklich Owner-/
     Lead-Entscheid; dieser Plan nutzt ihn nur als optionales Abnahme-Werkzeug je Paket, verdrahtet nichts.
  9. Die aelteren Owner-Zitate (19.07./21.07./07.08.) stuetzen sich auf die Ledger-Kennzeichnung
     "verbatim-treu" und wurden nicht gegen aeltere Roh-JSONL nachverifiziert (nur 09.08./10.08. sind roh
     verifiziert). Fuer Plan B ohne Folgen -- die Objektbefunde tragen unabhaengig.

Selbstcheck: Zeilen <= 120 Byte, reines ASCII, keine Pipeline ausgeloest, kein Push, keine Repo-Datei
ausser diesem Dokument angefasst.
