# PAUSE 27.07.2026 ~19:15Z — ABBRUCHSICHER (Spend-Limit-Ausfall + GitLab-500-Stoerung)

> ZWECK: Verlustfreie Wiederaufnahme nach Doppel-Abbruch: (1) Spend-Limit ~19:04Z killte
> ALLE Agenten (CiCheck288f, Impl-CE-6de, Impl-6f, Impl-2c, Map-VollBau4 — Namen NICHT mehr
> reachable, Nachfolger brauchen frische Spawns), (2) GitLab gestoert. Owner-Wort: Pause.
> Lese-Reihenfolge bei Wiederaufnahme: DIESES Doc -> Memory-Lage-Anker
> (project_20260727_vormittag_o8_fenster_lage, Ende) -> Uebergabe-Doc vom Mittag (§3/§4/§7).

## 0. STOERUNGS-BEFUND GITLAB (19:0x-19:15Z, diagnostiziert, NICHT behoben)

Alle AUTHENTIFIZIERTEN Pfade liefern HTTP 500: API GET /user mit gueltigem PAT = 500,
Sign-in-Seite = 500, Git-HTTP fetch (Cluster + super) = 500. Unauthentifiziert /api/v4/version
= 401 (Router lebt, Backend-Auth kaputt). BELEG Server-seitig statt Token-Problem: die 4
neuesten Vault-PAT-Kandidaten (inkl. des zuletzt funktionierenden) bekommen 500, die 3
aeltesten sauber 401 (ungueltig=erwartet). => INFRA-FALL. Handout nicht pushbar (Henne-Ei);
nach Entstoerung melden oder Owner meldet direkt. github.com-Remotes sind UNABHAENGIG intakt.

## 1. SHA-KANON BEIM ABBRUCH (alles Genannte ist gepusht auf origin+github, ausser origin
##    zuletzt ggf. hinter github wegen Stoerung — dieses Pause-Doc selbst: siehe Fussnote)

- super: dev = 25ad654b (atomisch: Gitlink->803b7d71 + Anwender-XML ram_pair ddr5_2x32);
         main = c19d9c5a. FF main->25ad654b AUSSTEHEND (wartet auf 13623-Gruen-Beleg).
- ce:    dev = 52bcbc76 (V-4-Retire 813c3232 + Identitaets-Test-Registrierung 52bcbc76);
         main = 803b7d71. FF main->52bcbc76 AUSSTEHEND (wartet auf 13625-Gruen-Beleg).
- ci-templates: 5f9e04be (unveraendert seit D3).
- Cluster: lokal 501fcd0-Linie; letzter Stand vor Stoerung gepusht.

## 2. WELLEN BEIM ABBRUCH (Ausgaenge UNBEKANNT — GitLab-500 verhinderte den Not-Read)

- super 13623 (dev 25ad654b): stand 13/13 Jobs GRUEN + Bridge n=1 (cache-engine -> 13624)
  OFFEN. Erwartung: success.
- ce 13624 (main 803b7d71, Bridge-Downstream): stand 15/18 (offen contract:durability,
  pmc:amd), nichts rot, ueberdurchschnittlich lang (~17min) aber Fortschritt.
- ce 13625 (dev 52bcbc76, V-4-Zug): stand 14/18, nichts rot. ERWARTUNG Testnamen-Diff
  host-gleich: -2 (test_permutation_codegen_byte_identity_smoke/_medium) +2
  (test_o4_machine_identity, test_c3a_gate_scharfschaltung), N netto unveraendert
  (prod2=272) — das ist RETIRE-SOLL, KEIN Testverlust.
- RISIKO: Die GitLab-Stoerung kann laufende Jobs gerissen haben (data_integrity/Runner-
  Symptome) — bei Wiederaufnahme mit include_retried=true zaehlen; rote Erstversuche durch
  die Stoerung sind Stoerungs-Folge, kein Paket-Befund.

## 3. WIEDERAUFNAHME-REIHENFOLGE (exakt so)

W0. GitLab-Check: PAT-Prozedur (Blind-Extraktion beider Vaults, rueckwaerts bis HTTP 200;
    Position rotiert). Solange 500: warten/Owner-Infra. 
W1. Wellen-Ausgaenge 13623/13624/13625 erheben (include_retried=true; Erwartungen §2).
W2. Bei Gruen: super-main-FF auf 25ad654b + ce-main-FF auf 52bcbc76 (FF-SHA-Push-Muster,
    beide Remotes; lokale main-Refs mit fetch origin main:main nachziehen).
W3. super-Gitlink-Bump auf 52bcbc76 (EIN Commit, nur Gitlink => 1-Bridge-Klasse), Welle,
    dann super-main-FF. Danach ALLE Linien synchron auf Hauptstrang-Endstand.
W4. Watcher NEU spawnen (CiCheck288g, Opus, read-only): Briefing = Uebergabe-Doc §4/§5 +
    Memory-Fallen (a)-(q) + PAT rueckwaerts + PRO-BRIDGE-MODELL (changes-Gate wirkt PRO
    Bridge: nur .gitlab-ci.yml steht in allen 3 Listen) + Wellen-Referenzen: docs-only-dev
    = 2 Jobs/0 Bridges; docs-only-main = 13/0; Code-only-main = 13/0; CI-Datei = 13/3;
    reiner Gitlink = 13/1. Testzahlen NUR host-gleich (ce prod2=272, prod1=276 NUR PROGNOSE,
    nie gemessen — 5 Wellen in Folge landeten auf prod2; super=144 hostunabhaengig).
    get_sources-Ausschluss VOLLSTAENDIG (Commit-Titel Parent+Submodul + FF-Diff-Stat!).
W5. VOLL-BAU-4-Fahrplan-Kartierung NEU starten (Map-VollBau4 failte VOR erster Lieferung).
    Auftrag rekonstruierbar: 4+1-Beweise-Definition, G6/J-Kette (N=316-Referenz vs. heutiges
    Gate 318 klaeren — J-Kette ist vermutlich EIGENE Zaehlung; V32_ENABLE=ON-Pflicht),
    Trigger-Prozedur (COMDARE_BUILD_GOLDEN_N/planer:delegate/Kaskade), runner-mode.sh heavy
    (c=1, prod1 HEAVY_J=24, prod2 nproc, SIGHUP-only, Infra-Abstimmung VOR Umschaltung),
    Vorbedingungs-Checkliste. Quellen: Ledger juengste §§, Bauplan-V2 TEIL I-V, Uebergabe
    §6g, Sessions 26./27.07. Unter ultracode als Workflow (Leser-Fanout + Synthese + Verify).
W6. Beweis-Strecke -> G6 -> VOLL-BAU-4-Trigger (Task #4). Danach Mess-Durchlauf.

## 4. HEUTE VOLLZOGEN + CI-BEWIESEN (Kurzliste fuer Nachfolger-Kontext)

6a Beweis-2 beidseitig · 6b OP-2 (+Herleitungs-Korrektur needs:[]-Falle) · 6c 2c/OP-8
plan-dump-Form · 6d RAM-4800 (Zwischenstand, wird von Task-#7-Programm abgeloest) · 6e OP-3
+ P8 BEIDE Zwillinge (tier ci + tier cmake, sha256-byte-identisch) · Kanon 15.3 + main==dev-
Disziplin · Task-#7-SPEC KOMPLETT (PLAN-Doc + 3 Nachtraege: zweigeteilte MESS-Achse,
System-/Organ-Achsen unberuehrt, Stempel = Vendor-Erkennungs-Kategorie-Familie x OS;
E-1..E-7 owner-frei; P1 GEBAUT: HardwareProbe-Domaene + SPD-Parser + 8 Fixture-Faelle;
P2-P6 RUHEN bis Voll-Build+Messung) · OP-9 built_stem (Opt-1, Praemissen-Korrektur:
Kappung trifft Plan-Dump nie) · E-2 ddr5_2x32 (+ super-XML-Nachzug atomisch) · 6f V-3-
Retire CI-bewiesen (Codegen-Zeilen 10->0) · V-4-Retire (-2183 Zeilen, ODER-Waechter:590
steht MIT V40.A-Kommentar, Anker bitgleich) · Identitaets-Tests registriert (Gate netto
318, Abdeckung +23 Faelle) · OP-4 VERWORFEN mit Beleg, OP-5 vertagt+Wachbedingung, OP-6
ERLEDIGT · S8 = Owner-Fenster nach Voll-Bau (Entscheide a/b/c offen, Define inert) ·
Zwei-Gate-Prozedur: comdare_permutation_codegen_cli EXISTIERT NICHT MEHR.

## 5. PROZESS-REGELN (fuer alle Nachfolger-Briefings, heute etabliert/bestaetigt)

cf22-Pfad ~/tools/cf22/usr/bin/clang-format-22 + Pflicht-Selbstcheck (dry-run --Werror,
leere Ausgabe LITERAL) in jedem C++-Briefing; Manager-Format-Abnahme vor jedem ce-Push
(zweite Linie). ASCII-Selbstcheck NUR sed-Form (grep -v ist zeilenblind). Freeze-Protokoll:
Paketmeldung -> Manager-Stichprobe -> Push durch Manager -> Bestaetigung -> Entlassung;
Nachrichten an Freeze-Halter NUR 'NUR ZUR KENNTNIS' oder woertlich 'ARBEITSAUFTRAG:'.
ctest zaehlt BINARIES nicht gtest-Faelle. Kein Erfolgs-Haken ohne literale Ausgabe;
Summaries nie durch tail abschneiden. include_retried=true bei jeder Gruen-Aussage.
prod1-276 bleibt PROGNOSE bis zur ersten prod1-P1-Welle.

## 6. RUHENDE BAENDER (unveraendert)

Task #2 Overleaf · #3 Infra-Pendenzen (prod2-SPD-Check P-neu-A, Stufe-1-Kanal P-neu-B
GEFILTERT ohne Seriennummern + boot_id, #437-ccache-Vollzugs-Ping, NEU: GitLab-500) ·
#5 Abgabe+Baender · #6 §75-Pass (zuletzt; Kandidaten u.a. Alt-Flag-Aliase NACH ce-Zug,
OP-9-super-Folge-Mini plan_stem/kCeStemMax optional) · #7 P2-P6 (ruhen; E-2+OP-9 sind
vorgezogen ERLEDIGT) · Ledger-Nachtrag gebuendelt faellig (parse_manifest-Vorwaertszeiger,
OP-4-verworfen, ef94d9f7-Beweiskette-Randnotiz [kein eigener CI-Lauf, Push-HEAD-Regel],
OP-9-Praemissen-Korrektur, Zwei-Gate-Prozedur, E-2/V-4-Vollzug, Gesamtsuite-Referenz
458/5/453 vor V-4 [nach V-4 neu messen]).

*Fussnote Sicherung: Dieses Doc ist lokal committet; origin-Push scheitert an der Stoerung
-> github-Push als Off-site-Sicherung; origin-Nachschub = Teil von W2-Fenster.*
