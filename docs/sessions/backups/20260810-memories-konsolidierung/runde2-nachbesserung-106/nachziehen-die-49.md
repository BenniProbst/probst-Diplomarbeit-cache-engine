Alle Heilungen verifiziert. Die 6 verbleibenden Über-120-Byte-Zeilen (128-135) gehören dem Parallel-Strang (Tabelle W-21…W-28), nicht mir.

**Dokument:** `/home/comdare/wt-super-landung/docs/plaene/20260810-KONSOLIDIERUNG-unverlinkte-memories.md` (1756 → 2322 Zeilen; der Parallel-Strang schreibt gleichzeitig, meine Edits liefen kollisionsfrei durch, kein Überschreiben)

## Die drei belegten Verluste — geheilt

**S-1 → D-2 (Abschnitt 3.3, Zeile ~949)** · Das `[…]` ist weg, das Owner-Zitat steht **ungekürzt**. Beide verschluckten Sätze sind zurück: „Wir hatten festgelegt, dass alle Achsen ein einheitliches Interface haben." und „…und verwendet in den Funktionen jeweils die Achsen, um die Funktion abzubilden." Dazu ein Absatz, **warum** ungekürzt. Neu **D-2a** (Zeile 962): die „How to apply"-Ableitung wörtlich („Achsen sind die Bausteine der Funktions-Implementierung", „Einheitliches Achsen-Interface bleibt") plus Gattung=Kern / Genus=Erweiterung, sauber als AGENTEN-BEHAUPTUNG getrennt vom OWNER-WORT.

**S-2 → I-6 ff. (Abschnitt 3.8)** · I-6 erweitert um den Beinahe-Charakter des zweiten Falls. Neu **I-6a** (1392): die vollständige ROBUSTE FORM (a)-(d) mit `Configuring incomplete` / `CMake Error` / `FATAL_ERROR`, den letzten ~80 Zeilen und „Negativfälle sind der eigentliche Test". Neu **I-6b** (1402): die zweite Lehre wörtlich (Seed-Stummschaltung nur ZUSTANDS-, nie BEFUND-Signale) — mit der Einordnung, dass (d) vor falsch-rot und diese Lehre vor falsch-grün schützt. Neu **I-7a** (1429): Falle (o) ausgeschrieben — `test:unit` falsch / `build:clang` richtig hergeleitet, Empirie 13526 gegen 13561/13570, und die Regel „Wirksamkeit an `started_at` belegen, nicht am YAML". Neu **I-7b** (1438): PAT-Position 1. von hinten, 7 Kandidaten, mit der Historie (27.07. Position 2). **W-17** trägt jetzt den übersprungenen Zwischenstand Gitlink-dev/main = 13/2 vom 02.08. nachmittags plus die Auflösung, warum er gegen N-7/N-10 steht, und die „Filter-Fehlalarm-Falle".

**S-3 → N-4a / N-1a / H-3a** · Neu **N-4a** (1789): der D3-Paket-Inhalt komplett, inkl. `ci-templates/gitleaks/gitleaks-base.toml` + Heredoc-Materialisierung + Präzedenz projekteigene toml > Basis + geloggt — mit dem ausdrücklichen Hinweis, dass das nicht die Codex-`config.toml`-Fundstellen sind. Neu **N-1a** (1767): die sechs Infra-Handouts namentlich, darunter P9 gitleaks-0-Bytes, plus CiCheck288c und Handout `9ba1479`. Neu **H-3a** (1230): die P9-Empirie — Fix `3d6cbec` (10:15:59Z) gegen Pipeline 13526 (erstellt 07:36:10Z), also „no leaks found" = Historie, kein Befund; dazu 13526 grün inkl. Bridges 13528/13529/13530.

## Meine eigene Stichprobe — beide Zahlen

Gezogen mit `od -An -N4 -tu4 < /dev/urandom`, Modulo über die 54 noch nicht geheilten Dateien.

**5 gezogen · 5 vollständig gelesen · 5 trugen Verluste · davon 1 hart.**

1. `reference_ce_jkette_n316_braucht_v32_enable_on` — **HART.** Führte auf einen **Zahlenfehler des Dokuments**: Abschnitt 5.3 nannte **sechs** Bindestrich-`name:`-Dateien, gemessen sind es **zehn** (Nenner-Gegenprobe: 57/57 haben eine `name:`-Zeile). 5.3 ist jetzt eine 10er-Liste mit beiden Formen je Eintrag und dem Untermuster, dass nur Nr. 10 den Typ-Präfix behält. Zusätzlich in H-5 die vorgeschriebene Meldeform („n=1 ctest-Eintrag mit 8 Fällen") und in W-09 die Org18-Referenz + `FAHRPLAN:42-53`.
2. `feedback_comdare_db_and_buildsystem_separate_ledgers` — **Abschriftsfehler:** das Dokument schrieb `comdare-db-configure.sh` als Dateinamen; gemeint ist die `configure.sh` **im comdare-db-Repo**. Plus die fehlenden Inhaltsklassen (Designs/Analysen/M2/ctest/Build-Fixes/Feature-Stubs), an denen die Trennung erst entscheidbar wird. Geheilt in K-2.
3. `reference_codex_null_junk_artifact_ignore` — klein: der Beleg, dass der Löschversuch real war (Tool-Call vom User rejected), und die Verallgemeinerung auf andere Codex-Junk-Artefakte. C-6.
4. `feedback_paketschnitt_nur_im_sessiondoc_existiert_nicht` — klein: „Die Arbeit war sogar gebaut; verloren war die Buchführung." und „Eine Suche in der Sprache des Suchenden statt in der des Dokuments findet Abwesenheit, wo Anwesenheit ist." L-7/L-8.
5. `reference_buildsystem_xml_grep_parsed_not_strict_xml` — kleinster Fall und **kein** echter Faktenverlust: `xml_parser.sh`/`dependency_resolver.sh` standen bereits in I-1, nur die Identität „I-1 und I-2 meinen denselben Parser" fehlte. I-2.

**Ein 6. Fund außerhalb beider Ziehungen**, per gezielter Suche statt Ziehung: nachdem die Kürzungs-Regel feststand, habe ich das ganze Dokument auf `[…]` in Owner-Zitaten durchsucht. Treffer **F-1** (`feedback_hardware_erkennung_factory_laufzeit_nie_statisch`, Nr. 17). Dort sind zwei Dinge zu trennen: das `[...]` **mitten** im Zitat steht **so in der Quelldatei** — nicht heilbar; die **Schluss-Worte** „um Hardware zu erkennen" hatte dagegen dieses Dokument abgeschnitten. Ebenfalls gefehlt: der Status „gilt als SCHON-IMMER-Gesetz" (rückwirkend bindend), die ganze PRÄZISIERUNG mit Plattform-Familie und **Passungs-Stempel als erkennbare Fehlerklasse** (jetzt **F-1a**), die `declared-only`-Regel und die Lehre „Owner-Korrekturen exakt auf die BENANNTE Fassung beziehen" (jetzt in F-3), sowie der Research-HWDetect-Bericht.

**Insgesamt vollständig gelesen: 9 Dateien** (3 beauftragte + 5 gezogene + Nr. 17). Über beide Ziehungen zusammen: **10 gezogen, 3 mit hartem Verlust, 7 mit mindestens etwas.** Die Quote sinkt nicht mit der Stichprobengröße.

## Was ich am Dokument sonst verankert habe

Abschnitt **7.1** trägt jetzt die Stichproben-Tabelle mit beiden Ziehungen und beiden Zahlen. Abschnitt **7.3** zwei neue Regeln: **keine `[…]`-Kürzung in Owner-Zitaten** (mit dem Hinweis, dass sie an D-2 erkauft wurde) und **eine Abhilfe gehört zu jedem Befund** (aus I-6: das Dokument hatte die Falle, nicht die Gegenmaßnahme). Unter der Herkunfts-Tabelle eine Notiz-Tabelle aller neun Buchstaben-Suffix-Fakten mit Abschnitt, Quelldatei-Nr. und Gegenstand — die Suffixe habe ich gewählt, um die laufende Nummerierung nicht zu verschieben, während der zweite Strang hinten anfügt.

## Was offen bleibt

1. **Das `[...]` in F-1 ist nicht rekonstruierbar** — es stammt aus der Quelldatei. Der Owner-Wortlaut wäre nur im Roh-Transkript vom 27.07.2026 zu finden. Als offener Posten in F-1 vermerkt.
2. **Sechs Zeilen über 120 Byte gehören dem Parallel-Strang**: Zeilen 128-135, Tabelle W-21…W-28 (121-128 B). Ich habe sie nicht angefasst — Kollisionsrisiko. Muss der andere Strang umbrechen.
3. **Abschnitt 7.2 sagt weiterhin, die 49 seien „NICHT konsolidiert"** — das gehört dem Parallel-Strang und muss nach dessen Anfügung nachgezogen werden. Ebenso die Überschrift von Abschnitt 6 („alle 57 Quelldateien") und die Index-Zeile in 7.4, die noch „57 unverlinkte Memories" vorschlägt.
4. **Die Dunkelziffer ist nicht null.** Billigster nächster Schritt (in 7.1 notiert): die gezielte Suche, die Nr. 17 fand — nach Kürzungszeichen, nach fehlenden Abhilfen zu vorhandenen Befunden, und nach Zahlwörtern im Fließtext („sechs Dateien", „drei Fälle"), die gegen den Bestand nachzuzählen sind. Genau dieser dritte Griff hat den 5.3-Fehler gefunden.
5. **W-09 bleibt unaufgelöst** (V32-Kausalität), unverändert — das braucht ein `ctest -N` am heutigen Stand, nicht Dokumentarbeit.