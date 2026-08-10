# CE-WORKFLOW "STEMPEL + WARNSTUFE" -- Workflow-Ergebnis (Stand 2026-08-10)

Gegenstand: 2 Straenge, beide im ce-Repo (comdare-cache-engine), beide durch die adversarische
Verify-Lens gefahren.

NENNER der Verdikte:      2 Straenge geprueft -- 0 STIMMT, 2 STIMMT_TEILWEISE (s1, s2), 0 FALSCH.
NENNER der Verify-Lens:   2 Abnahmen gefahren -- 0 nicht widerlegt, 2 REFUTED (s1, s2).
NENNER des Baus:          2 Straenge -- 0 Commits, 0 geaenderte versionierte Dateien, 0 Pushes.
                          Beide Worktrees `git status --porcelain` = 0 Eintraege (je vom Strang
                          selbst berichtet; NICHT von mir nachgemessen, s. Abschnitt 5).

Strang-Kurzschluessel, wie er unten durchgehalten wird:
  s1 = s1-stempel-reihenfolge   (Stempel: SYSTEM vorn, ORGAN hinten -- Owner-Satz 10.08.)
  s2 = s2-warnstufe             (-Wall/-Werror einfuehren, Posten D-3)

Diese Datei ist die Uebergabe. Sie ueberlebt das Ende des Lead-Kontexts.
Regel dieser Datei: keine Zahl ohne Nenner, keine Erfolgsmeldung ohne literale Ausgabe.
Alles, was nur berichtet und von der Lens NICHT unabhaengig nachgefahren wurde, steht
ausdruecklich in Abschnitt 5.

Gemeinsamer Messgegenstand beider Straenge:
  ce-HEAD 6c010cdc7b60d0d4a2fcf5be26bace0e19184503
  s1: Worktree wf_200fefb7-5f7-1, Zweig worktree-wf_200fefb7-5f7-1
  s2: Worktree wf_200fefb7-5f7-2, byte-gleich zu /home/comdare/wt-ce-w0a
      (Zweig w0a/registrierung-sichtbarkeit @ 6c010cdc)
  Verify-Lens s1: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine
  Verify-Lens s2: Wegwerf-Worktree /home/comdare/adv-s2 (nach dem Lauf entfernt)

--------------------------------------------------------------------------------
## 1 WAS LANDEFAEHIG IST

Landefaehig heisst hier: es existiert ein Commit ODER ein anwendbarer Patch, UND die Verify-Lens
hat ihn NICHT widerlegt, UND die Abnahme liegt als literale Ausgabe vor.

NENNER: 2 Straenge -- **0 landefaehige Aenderungen**. Kein Strang hat gebaut, also gibt es weder
Commit noch Patch. Landefaehig sind ausschliesslich BEFUNDE (Abschnitt 1.1/1.2) und die
korrigierten Aufgabendefinitionen (Abschnitt 3). Das ist kein Ausfall: bei s1 war Nicht-Bauen
das richtige Ergebnis (die verordnete Massnahme ist bewiesen wirkungslos), bei s2 haette der
verordnete Weg 194 Warnungen hart rot gemacht.

### 1.1 s1 -- der Befund, der zweimal unabhaengig reproduziert wurde (LANDEFAEHIG als Wissen)

Kern: die verordnete Massnahme "Ebene 1" (Tausch der Parameterliste von
`COMDARE_ANATOMY_VERSION_STAMP_M`) ist BYTE-NEUTRAL. Der Makro-Rumpf referenziert seine Parameter
ausschliesslich ueber die NAMEN; ein Tausch der Parameterliste mit nachgezogenen Argumenten ist
eine bijektive Umbenennung und kann Preimage und POD nicht bewegen.

  Lauf 1 (Strang s1), `g++ -std=c++23 -E -P`, IST-Definition gegen SOLL-Definition:
      /tmp/exp_ist.txt und /tmp/exp_soll.txt -- je 3784 Byte, diff rc=0
      SHA-256 BEIDE: 2480f63fda65f2d7f672e9f9286de21e7a78f0413b52cc6ab87e48872fe02228

  Lauf 2 (Verify-Lens, eigener Lauf, eigene gewuerfelte Koeder-Tokens
  ORG_4097da00c5b869381d0fb96f / SYS_764f8baf6cb8bf0f23f1855a / MES_995d3f69911167228659bac9,
  7 Faelle, stderr je 0 Byte):
      c1 IST(3-arg) vs c2 Ebene-1-Rename+nachgezogener Aufruf : sha 027629346e6daa82... IDENTISCH
      c5 vs c6 (2-arg-Zweig)                                   : sha 09a134277e528f4e... IDENTISCH

  -> Zwei Laeufe, zwei verschiedene Beweismittelbuendel, gleiches Ergebnis. Der Befund haelt.

  Koeder-Gegenprobe (K13, beisst): c3/c7 = vergessene Aufrufstelle. Stille Transposition, NULL
  Diagnostik. Im Preimage steht dann woertlich
      anatomy_fingerprint_hex("SYS_764f...", kSC.view(), ...)
  Das ist die eigentliche Gefahr der Ebene-1-Massnahme: sie erzeugt eine still compilierbare
  Vertauschung ohne jeden Gewinn.

Verifizierte Stellen (jede auf die Zeile bestaetigt, in beiden Laeufen):
      libs/cache_engine/.../anatomy_fingerprint.hpp:601   {kAnatomyFingerprintFormat, organ,
                                                           system, measurement, ...}
      anatomy_fingerprint.hpp:425                         kAnatomyFingerprintSystemGlied = 2
      abi/anatomy_module_abi_v1.hpp:162                   #define ..._STAMP_M (3-arg)
      abi/anatomy_module_abi_v1.hpp:213                   2-arg-Form
      builder/codegen/adhoc_emitter.hpp:124 / :131        die beiden Emissionsformen
      abi_v1_decl.hpp:254                                 kAnatomyVersionLinesLayout = 6
      anatomy_fingerprint.hpp:641 / :645                  "fingerprint_format=4", GliedCount = 9,
                                                          static_assert-Kopplung
      anatomy_fingerprint.hpp:767                         K-1-Sperre (deckt heute nur die vier
                                                          SCHWANZ-Glieder)
      tests/unit/test_lazy_adhoc_source_gen.cpp:84-95     check_320_byte_identity, exakt 320 ids
      golden-CRC-Anker 0xF1C1F26A1232073B                 in 5 Dateien referenziert

BEFUND-SATZ, der landet: der IST-Stand [Format, organ, system, measurement] ist die exakte
Umkehrung der kanonischen MESS->SYSTEM->ORGAN-Ordnung. Der Owner-Satz trifft POD-Feldreihenfolge
(Ebene 2) und Preimage-Glied-Folge (Ebene 3) -- also genau die beiden Ebenen, die die Aufgabe
mit NICHT BAUEN belegt hatte.

### 1.2 s2 -- was die Lens am selben Objekt selbst reproduziert hat (LANDEFAEHIG als Wissen)

Compiler der Gegenprobe: g++ 15.3.0, clang 22.1.8, cmake 4.3.4. Wegwerf-Worktree /home/comdare/adv-s2,
drei eigene Bauverzeichnisse, alle wieder entfernt; `wt-ce-w0a` unberuehrt (status 0, HEAD
unveraendert), Platte zurueck auf 8,6G.

  (a) `-Wall` steht bereits in `cmake/compiler_flags.cmake:22`.
      Hausnorm `COMDARE_set_default_warnings` (compiler_flags.cmake:21-30):
      -Wall -Wextra -Wpedantic -Wshadow -Wnon-virtual-dtor -Wcast-align -Wold-style-cast
      -Woverloaded-virtual -Wmissing-declarations, fuer GNU|Clang|AppleClang.
  (b) Sie wird an GENAU EINER Stelle gerufen: `cmake/gtest_setup.cmake:46`, innerhalb
      `comdare_add_test`. NENNER: 222 `comdare_add_test`-Zeilen, 221 verschiedene Zielnamen
      (mit `--include=*.cmake` und mit Leerraum vor der Klammer: unveraendert 222).
      -> Die Luecke ist die ABDECKUNG (nur Tests), nicht das Flag.
  (c) `-Werror` im eigenen Code: 0 Treffer (rc=1). Alle -Werror-Treffer im Baum liegen unter
      `ext/` (Fremdcode). Der Posten "-Werror einfuehren" STIMMT also.
  (d) Reihenfolge-Falle J-1..J-4 reproduziert: OHNE Codegen + RE-CONFIGURE ergeben sich exakt
      **164 rc!=0** von 590 compile_commands-Eintraegen. Die Zahl des Strangs stimmt.
  (e) Warnungszensus reproduziert (Nenner: 527 eigene Uebersetzungseinheiten = 590 Eintraege
      minus 63 fremd/generiert; 3 rc!=0 sind GEWOLLTE Negativ-Kompilate --
      test_e24_c1_organ_concept_negativ, test_e24_c4_dock_version_negativ,
      test_hy_a1_reroute_gate_negativ -- also kein blinder Fleck):
          gcc 15.3.0 Release : 194 Warnungen in 70 Zielen
          clang 22.1.8 Release: 102 Warnungen in 21 Zielen
          gcc 15.3.0 Debug   : 161 (datei-dedupliziert)
  (f) P2 (der Wachen-Patch des Vorlaufs) ist KEIN Vorfahr von HEAD (rc=1).

  Falsch-Null-Gegenprobe des Strangs, ausdruecklich mitprotokolliert: `COMDARE_add_test(` ergab 0
  Treffer, weil CMake case-insensitiv ist; geschrieben wird `comdare_add_test(` -> 222.

--------------------------------------------------------------------------------
## 2 WAS NICHT LANDEN DARF -- MIT GRUND

NENNER: 5 Posten. 3 aus s1, 2 aus s2.

### 2.1 s1-Ebene-1 (Tausch der Makro-Parameterliste) -- DARF NICHT LANDEN

Grund 1: bewiesen wirkungslos. Zwei unabhaengige Praeprozessor-Laeufe, byte-identische Expansion
(Abschnitt 1.1). Was der Owner benennt ("die Anordnung der Stufen") materialisiert im POD und im
Preimage, nicht in einer Parameterliste.
Grund 2: aktiv gefaehrlich. Der Koeder beisst: eine vergessene Aufrufstelle wird still
transponiert, ohne jede Diagnostik.
Grund 3: der Nenner der Aufgabe war falsch. "3 echte Expansionsstellen" stammt aus
`git grep -n '^COMDARE_ANATOMY_VERSION_STAMP'` -- ein Zeilenanfangs-Anker und damit genau die
bekannte Falsch-Null-Klasse. Vollstaendige Aenderungsflaeche einer konsistenten Umstellung:
**46 Vorkommen in 16 Dateien**, nicht 3. Aufschluesselung:
      2 Definitionen        anatomy_module_abi_v1.hpp:162 (3-arg), :213 (2-arg)
      3 direkte Expansionen tests/unit/r3_mess_gate_stamp_module.cpp:60
                            tests/unit/test_d2_mess_konsistenz_gate.cpp:120
                            tests/unit/test_w10_system_cell_values.cpp:109
      4 Emitter, die den Aufruf als TEXT schreiben (in der Beweisliste des Strangs UEBERHAUPT
        NICHT genannt, obwohl das der Perm-/ce-only-Pfad ist):
                            builder/codegen/adhoc_emitter.hpp:124 (2-arg), :131 (3-arg)
                            profile_facade/sota_catalog.hpp:172, :248
      3 literale SLOT-ORDNUNGS-Pins, die bei jedem Emitter-Nachzug hart rot werden:
                            tests/unit/thesis_tiere/test_merge_plan_directive.cpp:174, :183, :199
                            Kommentar bei :168 woertlich: "Die Makro-SLOT-Ordnung ist organ,
                            system, measurement -- literal gepinnt, damit kein Slot still
                            verrutscht."
Damit ist auch "NUR Ebene 1 betroffen" widerlegt.

### 2.2 s1-Ebene-2 (POD-Feldreihenfolge, stamp_layout_version 6 -> 7) -- NICHT OHNE OWNER

Grund: ABI-Bruch. `kAnatomyVersionLinesLayout = 6` (abi_v1_decl.hpp:254). Owner-Vorlage: Abschnitt 6.

### 2.3 s1-Ebene-3 (Preimage-Glied-Folge, fingerprint_format 4 -> 5) -- NICHT OHNE OWNER

Grund: JEDER Tier-SHA-512 aendert sich, jedes 320er-golden-Artefakt wird ungueltig
(`check_320_byte_identity`, golden-CRC 0xF1C1F26A1232073B in 5 Dateien).
Zweiter, harter Grund: die MESS-Position ist NICHT entschieden. Der Owner-Satz ordnet nur
system/organ. Ohne Klaerung ist unklar, ob das Ziel {Format, measurement, system, organ, ...}
oder {Format, system, organ, measurement, ...} ist -- Ebene 3 ist damit heute schlicht nicht
baubar. Owner-Vorlage: Abschnitt 6.

### 2.4 s2 -- ein globales `-Werror` in einem Schritt -- DARF NICHT LANDEN

Grund: es macht sofort 194 gcc-Warnungen (Release, ziel-dedupliziert, in 70 Zielen) und 102
clang-Warnungen (Release, in 21 Zielen) hart rot. Davon liegen allein **26 Warnungen in 12 Zielen,
die die Hausnorm HEUTE SCHON TRAGEN** (18x -Wdangling-else, 4x -Wcomment, 2x -Wsign-compare,
1x -Wrange-loop-construct, 1x -Wstringop-overflow=). Die 12 Ziele:
      test_188_4bb0_pool_organ_wide_key_conformance, test_234_f3_bst_shape,
      test_234_f4_hash_probe_shape, test_ap7_swisstable, test_ap7b_swiss_organ, test_cpuid_probe,
      test_permutation_sampling, test_succinct, test_v41_axis_03a_cross_variant_equivalence,
      test_v41_axis_03a_tier_organ_equivalence, test_v41_axis_filter_surf_louds_organ,
      test_v41_topic_traversal
Der Rest (gcc 168 in 58 Zielen, clang 100 in 20 Zielen) faellt erst mit der Ausweitung an.

### 2.5 s2-S0 ("P2-Wache heilen, weil 590/590 keinen Zielnamen tragen") -- DARF SO NICHT LANDEN

Grund: der Beleg ist selbst eine Falsch-Null durch Bauart. Generator ist `Unix Makefiles`, also
sind alle `-o`-Werte RELATIV (`CMakeFiles/gmock.dir/src/gmock-all.cc.o`). Gemessen an denselben
590 Eintraegen:
      Muster `/CMakeFiles/` (mit fuehrendem Schraegstrich) : **0 von 590** -- konstruktionsbedingt
      Muster `CMakeFiles/`  (ohne Schraegstrich)           : **590 von 590**, Ziel erkennbar bei
                                                             590 von 590, 539 verschiedene Ziele
Das Gegengift liegt im selben Beweismittelbuendel: das Attributionsskript des Strangs benutzt
`CMakeFiles/([^/]+)\.dir/` (ohne Schraegstrich) und meldet woertlich
`davon ohne erkennbaren Ziel-Namen : 0`. Derselbe Satz enthaelt Probe und Widerlegung.
-> Der "P2-Blocker 590/590" traegt keinen Beleg. Die S0-Massnahme mag aus anderen Gruenden richtig
   sein (Ninja/Makefiles-Portabilitaet), aber DIESE Begruendung ist widerlegt und muss vor jedem
   Bau am P2-Quelltext neu gemessen werden.

Zusatz-Widerlegung (kein eigener Landeposten, aber Nenner-Hygiene): der Strang mischt in einer
Zahlenreihe zwei Nenner. 194 und 102 sind ZIEL-dedupliziert, 161 ist DATEI-dedupliziert. In je
einer Basis gemessen:
      ziel-dedupliziert : gcc Rel 194 (70 Ziele) | gcc Debug 190 | clang Rel 102 (21) |
                          clang Debug 102 (21)
      datei-dedupliziert: gcc Rel 165 (89 Dateien) | gcc Debug 161 (87) | clang Rel 70 (42)
Der scheinbare Debug/Release-Abstand von 33 ist in Wahrheit 4 (190 gegen 194) bzw. 4
(161 gegen 165).
Vereinigung betroffener Dateien gcc+clang (datei-dedupliziert): 93 (nur gcc 51, nur clang 8,
beide 34).

--------------------------------------------------------------------------------
## 3 GEAENDERTE AUFGABENDEFINITIONEN

Muster D2-G4/D2-G5: die alte Fassung bleibt STEHEN, die neue steht DANEBEN. Nichts wird geloescht.
NENNER: 2 Korrektur-Einschuebe (s1, s2).

### 3.1 EINSCHUB zu s1 -- Stempel-Reihenfolge

  ALTE FASSUNG (bleibt stehen, zur Historie):
    "s1-stempel-reihenfolge: SYSTEM vorn, ORGAN hinten. Ebene 1 bauen -- die Parameterlisten von
     COMDARE_ANATOMY_VERSION_STAMP_M (anatomy_module_abi_v1.hpp:162 und :213) tauschen und die
     3 Expansionsstellen nachziehen. Ebene 2 (POD-Feldreihenfolge) und Ebene 3
     (Preimage-Glied-Folge) NICHT BAUEN -- ABI-Bruch bzw. golden-Bruch."

  NEUE FASSUNG (gemessen, 2026-08-10, zweimal unabhaengig reproduziert):

    (0) EBENE 1 WIRD ERSATZLOS GESTRICHEN. Sie ist bewiesen byte-neutral (Praeprozessor-Expansion
        identisch, zwei Laeufe, SHA-256 in jedem Lauf gleich) und dabei aktiv gefaehrlich
        (vergessene Aufrufstelle = stille Transposition, null Diagnostik). Sie bewegt die vom
        Owner benannte Stufen-Ordnung um KEIN Byte.

    (1) NENNER-KORREKTUR, bindend fuer jede spaetere Umstellung: die Aenderungsflaeche ist
        46 Vorkommen in 16 Dateien -- 2 Definitionen, 3 direkte Expansionen, 4 Emitter, die den
        Aufruf als TEXT schreiben (adhoc_emitter.hpp:124/:131, sota_catalog.hpp:172/:248), und
        3 literale Slot-Ordnungs-Pins (test_merge_plan_directive.cpp:174/:183/:199).
        Der Zeilenanfangs-Anker `^COMDARE_ANATOMY_VERSION_STAMP` darf NIE wieder als Nenner
        dienen -- er ist die bekannte Falsch-Null-Klasse.

    (2) PAKET A -- OWNER-VORLAGE, KEIN BAU. Wortlaut in Abschnitt 6. Blockiert Ebene 2 und 3.

    (3) PAKET B -- SOFORT BAUBAR, unabhaengig von A, ohne golden-Bruch:
        die Transpositions-Falle schliessen. Organ- und System-Zeile am Makro-Kopf sind heute
        typgleiche nackte String-Literale; eine Vertauschung ist compilierbar und still. Die
        K-1-Sperre (anatomy_fingerprint.hpp:767) schuetzt diese Klasse bereits fuer die vier
        SCHWANZ-Glieder -- sie ist auf die KOPF-Glieder auszudehnen (bzw. es sind typisierte
        Traeger statt nackter Literale einzufuehren).
        ABNAHME: ein gewuerfelter Koeder, der genau die Vertauschung vornimmt, muss hart rot
        werden; die unvertauschte Gegenprobe muss still bleiben. Debug UND Release, gcc UND clang.
        VORBEHALT: die Beschreibung der K-1-Sperre stammt aus einem an dieser Stelle
        ABGESCHNITTENEN Strang-Bericht (s. Abschnitt 5.1). Vor dem Bau ist anatomy_fingerprint.hpp
        um :767 selbst zu lesen.

    (4) PAKET C -- Emitter-Kopplung sichtbar machen. Die 4 Emitter schreiben den Makroaufruf als
        Text; die 3 Slot-Pins pinnen die Reihenfolge literal. Solange beides nicht ueber EINE
        Quelle laeuft, ist jede Reihenfolge-Aenderung eine Mehrstellen-Handarbeit. Dieses Paket
        ist NICHT vermessen worden und ist zunaechst ein Explore-Auftrag, kein Bauauftrag.

### 3.2 EINSCHUB zu s2 -- Warnstufe (D-3)

  ALTE FASSUNG (bleibt stehen, zur Historie):
    "s2-warnstufe: -Wall/-Werror einfuehren (D-3). Owner: 'Ja alle einfuehren.'"

  NEUE FASSUNG (gemessen, 2026-08-10). Der Owner-Wille bleibt bindend -- korrigiert wird nur der
  WEG, nicht das Ziel. Vier Stufen, jede fuer sich hart gruen abnehmbar, jede auf gcc UND clang
  (D-2), Debug UND Release:

    (0) "-Wall einfuehren" ist GEGENSTANDSLOS: `-Wall` steht seit langem in
        cmake/compiler_flags.cmake:22 und wirkt heute auf 221 Ziele. Der offene Posten heisst
        richtig: **Hausnorm auf libs/apps/tools AUSWEITEN + `-Werror` stufenweise EINFUEHREN**.

    S0  P2-Wache heilen -- NUR NACH NEUMESSUNG. In tests/unit/test_warnnorm_abdeckung.cpp den
        Ziel-NAMEN aus `CMakeFiles/<ziel>.dir/` ziehen statt das Ziel-VERZEICHNIS aus dem Praefix
        vor `/CMakeFiles/` (diese Form tragen Unix Makefiles UND Ninja), und die
        Bereichs-Einordnung ueber den Ziel-Namen fuehren.
        VORBEHALT (Abschnitt 2.5): die Begruendung "590/590 ohne Zielnamen" ist ein Artefakt der
        Messsonde des Strangs, nicht ein Befund am P2-Quelltext. Vor dem Bau ist am P2-Quelltext
        selbst zu messen, ob dort der fuehrende Schraegstrich wirklich steht.
        ABNAHME: derselbe Test einmal ueber ein Unix-Makefiles- und einmal ueber ein
        Ninja-Bauverzeichnis, beide gruen, plus der vorhandene Koeder mit praeparierter
        compile_commands.json.

    S1  NULL-KOSTEN-RATSCHE, sofort, wirkt auf alle 221 heutigen Ziele: in
        COMDARE_set_default_warnings ergaenzen
            -Werror=non-virtual-dtor, -Werror=overloaded-virtual, -Werror=pedantic
        Gemessen 0 Treffer ueber beide Compiler und beide Stufen; Koeder beisst bei beiden
        Compilern, saubere Gegenprobe still.
        `-Wcast-align` AUSDRUECKLICH NICHT haerten: dessen Null ist auf x86-64 ein
        Plattform-Artefakt (der Koeder beisst dort auf keinem Compiler) und damit kein Beleg.

    S2  AUSWEITUNG (= das, was P2 baut): Hausnorm auf libs/apps/tools ausdehnen -- 26 neue
        Aufrufstellen plus der Aufruf im Wrapper cmake/comdare_add_library.cmake (deckt 12
        Bibliotheken). Nicht neu bauen, sondern P2 landen. P2 ist kein Vorfahr von HEAD (rc=1).
        VORBEHALT: der Strang-Bericht bricht an dieser Stelle mitten im Satz ab
        ("NICHT vergessen: adapte..."), s. Abschnitt 5.1.

    S3  ENTGIFTEN, DANN HAERTEN, in dieser Reihenfolge und nicht umgekehrt:
        zuerst die 26 Warnungen in den 12 Zielen beseitigen, die die Hausnorm HEUTE SCHON tragen
        (sie blockieren jede Haertung), danach die mit S2 neu sichtbaren
        (gcc 168 in 58 Zielen, clang 100 in 20 Zielen), erst dann globales `-Werror`.
        NENNER-REGEL fuer alle Fortschrittsmeldungen dieses Postens: ZIEL-dedupliziert und
        DATEI-dedupliziert nie in einer Reihe mischen (Abschnitt 2.5).

--------------------------------------------------------------------------------
## 4 KOLLISIONEN

  4.1 Reservierte Dateien -- eingehalten. s1 hat super/.gitlab-ci.yml, super/LICENSE und
      ce/tests/unit/test_d2_abdeckungs_wache_nenner.cpp weder gelesen noch angefasst.
      Abgrenzung, ausdruecklich: s1 hat tests/unit/test_d2_mess_konsistenz_gate.cpp GELESEN
      (Treffer der Makro-Suche). Das ist eine ANDERE Datei als die reservierte
      test_d2_abdeckungs_wache_nenner.cpp, und auch sie wurde nur gelesen, nicht geaendert.

  4.2 Geteilter Worktree /home/comdare/wt-ce-w0a. s2 hat NICHT dort gemessen, sondern im eigenen
      Worktree wf_200fefb7-5f7-2 (byte-gleicher HEAD). Die Verify-Lens hat ihrerseits
      /home/comdare/adv-s2 benutzt und wt-ce-w0a nachweislich unberuehrt gelassen
      (status 0, HEAD unveraendert). Kein Zwei-Schreiber-Konflikt.

  4.3 Themenkollision Stempel. In dieser Sitzung laufen zusaetzlich die Agenten
      `stempel-forensik` und `stempel-kartierung` am selben Gegenstand. Bevor irgendetwas zur
      Stempel-Reihenfolge gebaut wird, sind deren Befunde gegen Abschnitt 1.1/2.1 zu MERGEN,
      nicht zu verdraengen. Insbesondere die Nenner-Korrektur (46 Vorkommen in 16 Dateien) muss
      gegen deren Kartierung abgeglichen werden -- wer die kleinere Zahl nennt, hat vermutlich
      denselben Zeilenanfangs-Anker benutzt.

  4.4 Themenkollision Warnstufe / P2. P2 ist kein Vorfahr von HEAD. Wer P2 landet, landet damit
      S2 aus Abschnitt 3.2 -- und macht in demselben Zug die 168 gcc- / 100 clang-Warnungen der
      Ausweitung sichtbar. P2-Landung und S1-Ratsche duerfen NICHT in derselben Pipeline liegen,
      sonst ist bei Rot nicht unterscheidbar, welche der beiden Aenderungen es ausgeloest hat.

  4.5 Bauplatz. Beide Straenge haben Bauverzeichnisse angelegt und wieder entfernt
      (s2: build-gcc, build-clang, build-dbg, config.status; `git ls-files` darauf = 0, es lag
      also keine versionierte Messdatei darin). Trotzdem gilt weiter: vor `rm` eines
      ce-Bauverzeichnisses immer `git ls-files` darauf fahren -- dort liegen versionierte
      Mess-CSV.

  4.6 Wegwerf-Beweismittel liegen ausserhalb der Repos und sind NICHT zum Landen gedacht:
      s1: /tmp/def_ist.h, /tmp/def_soll.h, /tmp/mk_soll.py, /tmp/call_ist.cpp,
          /tmp/call_soll.cpp, /tmp/call_vergessen.cpp, /tmp/exp_*.txt
      Verify s1: /tmp/adv-s1/ (Skript /tmp/adv-s1/mk.py druckt seine Nenner selbst)
      Verify s2: /tmp/attrib.py, /tmp/warnzensus_real.py
      Diese Dateien sind fluechtig. Wer den Befund nachfahren will, erzeugt sie neu -- die
      Rezepte stehen in Abschnitt 1.1 und 1.2.

--------------------------------------------------------------------------------
## 5 WAS UNGEDECKT BLEIBT

### 5.1 Abgeschnittene Strang-Berichte -- die groesste Luecke

Mindestens 6 Stellen der Zulieferung brechen mitten im Satz ab. Der Inhalt hinter dem Bruch ist
NICHT eingegangen und darf nicht als gemessen gelten:
      s1 MESSORT      : "Der genannte MESSORT" -- der Abgleich mit dem vorgegebenen Messort
                        bricht ab; unklar, ob er stimmte.
      s1 BEFUND       : "K13-GEGENPROBE, KOEDER BEIDE RICHTUN" -- die zweite Koeder-Richtung
                        fehlt.
      s1 KORRIGIERT   : "...schuetzt genau diese Klasse bereits fuer die vier SCHWANZ-Glied" --
                        die Begruendung von Paket B endet hier.
      s2 KERN 4       : "FOLGE: ein globales -Werror macht" -- die Folgerung fehlt (aus Kontext
                        rekonstruiert in Abschnitt 2.4; die Rekonstruktion ist meine, nicht die
                        des Strangs).
      s2 S2           : "NICHT vergessen: adapte" -- eine Auflage zu S2 fehlt vollstaendig.
      Verify s1/s2    : beide Refutationen brechen ab ("Eine bijektive Umbenennung der
                        Makro-Parameter mit nachgezogenen Argumenten *" bzw. "Zusatz:").
Folge: S2 und Paket B sind NICHT freigabereif. Vor ihrem Bau ist der jeweilige Strang neu zu
befragen oder am Objekt neu zu messen.

### 5.2 Nicht nachgemessen von mir (ich habe berichtet, nicht gemessen)

  - `git status --porcelain` = 0 in beiden Strang-Worktrees: von den Straengen berichtet, von
    dieser Uebergabe NICHT nachgefahren.
  - Die Existenz und der Inhalt der /tmp-Beweismittel: nicht nachgefahren (fluechtig).
  - Dass s1 wirklich keine versionierte Datei angefasst hat: nur ueber die Selbstauskunft gedeckt.

### 5.3 Sachlich ungedeckt

  - **Die MESS-Position ist offen.** Ohne Owner-Antwort ist Ebene 3 nicht baubar (Abschnitt 6).
  - **Kein Vollbau, keine ctest-Laeufe.** Beide Straenge haben ausschliesslich compile_commands-
    getriebene Einzelkompilate bzw. Praeprozessor-Laeufe gefahren. Die Pflicht-Reihenfolge
    J-1..J-4 (Werkzeuge -> RE-CONFIGURE -> Vollbau -> --target comdare_tests -> ctest) ist in
    KEINEM der beiden Straenge komplett gefahren worden. Jedes "gruen" in dieser Datei bezieht
    sich ausschliesslich auf den benannten Einzelgegenstand.
  - **Kein CI-Lauf.** Alles ist lokal (prod1). Die Lokal-Release-Luecke gilt unveraendert.
  - **Warnungszensus nur x86-64.** `-Wcast-align` ist deshalb ausdruecklich nicht bewertbar.
  - **Die 46/16 des s1-Nenners** sind von der Verify-Lens erhoben, aber nicht ein zweites Mal
    unabhaengig gegengezaehlt. Sie sind belastbarer als die "3", aber selbst noch einfach belegt.
  - **Paket C (Emitter-Kopplung)** ist vollstaendig unvermessen -- Explore-Auftrag, kein
    Bauauftrag.
  - **Der IST-Befund `measurement_line` ist leer, weil der Perm-Pfad den 2-arg-Zweig trifft**
    (Gedaechtnis-Stand) wurde in diesem Workflow NICHT nachgemessen, obwohl s1 genau den
    2-arg-Zweig (abi_v1_decl :213, adhoc_emitter.hpp:124) angefasst hat. Das ist die
    naheliegendste offene Anschlussmessung.

--------------------------------------------------------------------------------
## 6 IST DIE STEMPEL-REIHENFOLGE ERLEDIGT?  -- NEIN. OWNER-VORLAGE, FERTIG FORMULIERT

ANTWORT AUF DIE FRAGE: **Die Stempel-Reihenfolge ist NICHT erledigt.** Was erledigt ist, ist
ausschliesslich der Nachweis, dass der bisher vorgesehene Weg (Ebene 1) sie nicht anfasst. Die
Sache selbst -- SYSTEM vorn, ORGAN hinten -- liegt vollstaendig in Ebene 2 und Ebene 3 und
braucht eine Owner-Entscheidung, weil beide gewollt-invalidierend und gross sind.

Vorlage zum woertlichen Vorlegen:

    Dein Satz vom 10.08. lautet: "system sollte immer vorn stehen und organ hinten. Das
    entspricht der Anordnung der Stufen."

    Der IST-Stand ist die exakte Umkehrung: der Stempel traegt heute
        [fingerprint_format, organ, system, measurement, ...]
    (anatomy_fingerprint.hpp:601, kAnatomyFingerprintSystemGlied = 2 auf :425).

    Wir haben gemessen, wo dein Satz materialisiert. NICHT in der Makro-Parameterliste: ein
    Tausch dort ist byte-neutral (Praeprozessor-Expansion in zwei unabhaengigen Laeufen
    identisch). Dein Satz trifft genau zwei Stellen, und beide brechen Bestand:

      EBENE 2 -- die POD-Feldreihenfolge. stamp_layout_version 6 -> 7
                 (kAnatomyVersionLinesLayout = 6, abi_v1_decl.hpp:254). Das ist ein ABI-Bruch:
                 jeder Loader, der den Stempel auslesen will, aendert sich mit.

      EBENE 3 -- die Preimage-Glied-Folge. fingerprint_format 4 -> 5
                 (anatomy_fingerprint.hpp:641/:645, GliedCount 9, per static_assert gekoppelt).
                 Folge: JEDER Tier-SHA-512 aendert sich. Jedes 320er-golden-Artefakt wird
                 ungueltig (check_320_byte_identity fordert exakt 320 ids; der golden-CRC-Anker
                 0xF1C1F26A1232073B ist in 5 Dateien verankert).

    Beides ist nach deiner eigenen Doktrin gewollt ("Bestand invalidieren ist gewollt, kein
    Migrationszwang"). Die GROESSE des Bruchs -- alle vier Binary-Typen, der Katalog und der
    vorhandene Messbestand -- macht es aber zu deiner Entscheidung, nicht zu unserer.

    ZWEITE FRAGE, ohne die wir Ebene 3 nicht bauen koennen: WO STEHT MESS?
    Dein Satz ordnet nur system und organ zueinander. Die Wendung "Mess/System/Organ" an anderer
    Stelle ist eine Aufzaehlung, kein Ordnungssatz. Es sind genau zwei Ziele moeglich:

      (a) {fingerprint_format, measurement, system, organ, ...}
          -- Mess ganz vorn; liest sich als "gemessen wird zuerst, dann freigegeben, dann
             durchgesetzt".
      (b) {fingerprint_format, system, organ, measurement, ...}
          -- Mess ganz hinten; liest sich als "die Stufen zuerst, die Messung als Anhang".

    Bitte entscheide: (a) oder (b). Solange das offen ist, ist Ebene 3 nicht baubar, und wir
    ruehren den Stempel nicht an.

    Was wir OHNE deine Antwort machen koennen, und wozu wir raten: die Transpositions-Sperre.
    Organ- und System-Zeile sind heute typgleiche nackte String-Literale -- eine Vertauschung
    compiliert still durch. Wir haben das mit einem Koeder gezeigt: eine vergessene Aufrufstelle
    erzeugt ohne jede Warnung ein Preimage, in dem der System-Wert an der Organ-Stelle steht.
    Diese Sperre bricht keinen Bestand und macht die spaetere Umstellung -- egal ob (a) oder
    (b) -- ueberhaupt erst sicher durchfuehrbar.

--------------------------------------------------------------------------------
ENDE. Erzeugt 2026-08-10 aus den Berichten der Straenge s1/s2 und den zwei adversarischen
Verify-Laeufen. Kein Bau, kein Commit, kein Push in dieser Runde.
