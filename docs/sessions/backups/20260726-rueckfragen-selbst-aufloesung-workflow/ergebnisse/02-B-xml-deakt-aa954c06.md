# 20260726-rueckfragen-selbst-aufloesung-workflow / B-xml-deakt (agent aa954c06)

runId: wf_bb5d71e9-fdb
agentId: aa954c06479a7d9e3
label-Zuordnung: B-xml-deakt (Prompt-Marker-Deckung 100%)

---

PUNKT B - AUFLOESUNG: XML-DEAKTIVIERUNG ACHSE vs BAUSTEIN (Q-1-Nuance)

QUELLENLAGE
- Owner-Wortlaut (einzige Fundstelle, neueste): `docs/sessions/backups/20260726-session-plaintext-verlauf/verlauf-queued-ergaenzung-06.txt:105` - "Q-1: Wie empfohlen, korrekt. Die Achse wird per XML deaktiviert und das muss unterstuetzt sein."
- NICHT ENTSCHEIDBAR aus den Quellen: der Wortlaut der von "wie empfohlen" bestaetigten Empfehlung selbst liegt nicht im Backup (`grep -rn "FALL A"` im gesamten Verlauf-Ordner = 0 Treffer). Q-1=FALL B ist nur als Agenten-Eigenreferat belegt (`verlauf-queued-ergaenzung-06.txt:354`). Ebenso ist die vom Agenten zitierte "Deine Auflage: Registry-XML zeigt disk_writeback mit enabled='false'" (`:657`) im Backup nicht als Owner-Text auffindbar. Beides ist Sekundaerzitat, kein Primaerbeleg.
- Owner sagt "Achse". Gebaut wurde am "Baustein". Diese Ebenen-Differenz ist der ganze Punkt B.

EBENE 1 - ACHSE (Doktrin entscheidet, kein Ermessen)
- `docs/architektur/16_E1_E4_KONSOLIDIERUNG_DOSSIER.md:29` - "Achse = Organ | permutierendes Organ (keine optional - Durchreich statt Weglassen)".
- `docs/architektur/TIER-AUFLOESUNG-AUDIT-UND-MAPPING-PLAN.md:164` - "Eine nicht zutreffende Achse wird nie weggelassen, sondern mit einem konkreten Durchreich-Organ (`None`/...) belegt."
- `docs/architektur/12_queuing_topic_achsen_eigenschaften.md:27-29` - "nicht optional ... waehlt den konkreten Durchreich-Algorithmus (`NoBuffer` ...), NICHT 'Achse weglassen'".
=> "Achse per XML deaktivieren" kann NIE "Slot verschwindet aus Composition/binary_id" bedeuten. Die einzige doktrinkonforme Semantik: Achse bleibt in JEDER binary_id, ist auf ihren Durchreich-Baustein festgenagelt, Kardinalitaet 1, kein Sweep-Beitrag.

DEFINITION - was die Anwender-XML koennen MUSS (Owner-Satz erfuellt gdw. alle 5)
- R-a Achse mit genau einem Wert = Durchreich-Organ deklarierbar. ERFUELLT: `all_axes_golden.profile.xml:56` `<axis ref="persistence_target"><value>persistence_memory_only</value></axis>`.
- R-b Achse aus `<axis_sweeps>` heraushaltbar (Faktor 1). ERFUELLT faktisch (`:60`), aber nur als ABWESENHEIT einer Zeile.
- R-c Die Deaktivierung muss ein POSITIVES XML-Token sein, nicht eine Abwesenheit. NICHT ERFUELLT: heute ist "absichtlich deaktiviert" byte-gleich mit "Sweep-Zeile vergessen"; der Grund fuer die Ruecknahme war der Guard `test_smoke_coverage_profile:141` (>=2 Auspraegungen je deklarierter Sweep-Achse), also ein Umweg per Weglassen (`verlauf-queued-ergaenzung-06.txt:675-682`).
- R-d Der WIRKSAME Hebel muss in der XML liegen. NICHT ERFUELLT: der Hebel ist CMake - `Code/external/comdare-cache-engine/CMakeLists.txt:381` `option(COMDARE_AXIS_PERSISTENCE_ENABLE_DISK_WRITEBACK ... OFF)` -> `:1194-1197` -> `axes/persistence_target/axis_persistence_target_flags.hpp.in:15` -> `axis_persistence_target_disk_writeback.hpp:46 static constexpr bool enabled = flags::disk_writeback_enabled` -> `axis_persistence_target_registry.hpp:31 EnabledTargets = mp_filter<is_enabled, AllTargets>`. Zweiter, separater Handgriff: `profile_facade/source_catalog.hpp:137` "Aufschaltung = K17 auf 2 heben UND COMDARE_AXIS_PERSISTENCE_ENABLE_DISK_WRITEBACK=ON". Kein Produktionspfad leitet diese `-D`-Flags aus der Anwender-XML ab: das einzige Konstrukt, das solche Strings baut, ist `libs/cache_engine/src/permutations/permutation_build_command.hpp:75-78`, und es hat in `libs/`/`tools/` keinen Aufrufer (Grep ohne Treffer); `builder/` emittiert keine `-D`-Zeile.
- R-e Rueckweg per XML (Wiedereinschalten) mit Obergrenze = ANGEBOT. NICHT ERFUELLT und heute prinzipiell unerreichbar: Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:3054` - "`extend` ist erlaubt, Obergrenze = das Registry-ANGEBOT". Das ANGEBOT reflektiert per Leitplanke NUR `Enabled*` (`tools/axis_registry_gen/main.cpp:9-17`, `:289` schreibt `enabled="true"` hartkodiert; Belegkette `verlauf-queued-ergaenzung-06.txt:658-664`), der deaktivierte Baustein steht also nicht im Angebot -> `extend` kann ihn nie erreichen, der Resolver (`§27`, LEDGER:2146: "unregistriert = harter Validierungsfehler") muesste ihn zurueckweisen.

VERDIKT
- Gebaut (ORG-18) ist die Achsen-Ebene doktrinkonform und richtig: Achse in jeder binary_id, Durchreich memory_only, Kardinalitaet 1, `test_org18_persistence_target` §1 beweist AllTargets==2/EnabledTargets==1. Das bleibt unangetastet.
- Der Owner-Satz ist damit NICHT erfuellt: der Schalter liegt in CMake + Katalog-K17, die XML SPIEGELT den Zustand nur (und das nur implizit, per Weglassen). Nach `§27` (Registry=ANGEBOT / Anwender-XML=ANZEIGE, LEDGER:2144) ist genau die umgekehrte Richtung gefordert. => NACHTRAG-ARBEITSPAKET NOETIG (R-c, R-d, R-e; R-a/R-b stehen).

SCOPE-SKIZZE "AP XML-DEAKT" (Reihenfolge = Abhaengigkeit)
1. Schema additiv: `<axis ref>`-Attribut `active="true|false"` (Default true) in `Code/test_data_xml/experiment_schema.xsd`; XSD-Doku verankert die Semantik "Slot bleibt, Wert = Durchreich, kein Sweep" mit Doktrin-Anker 16_E1_E4:29. Alternativ als `<restrict>`-Form nach §59/Fork ⑤ statt eigenem Attribut - Formwahl ist ein GO-Punkt, nicht Ermessen.
2. `profile_facade/validate_profile.hpp` (KEIN Parallel-Validator, LEDGER:2146): `active="false"` erzwingt genau 1 `<value>` und dass dieser der Baseline-/Durchreich-Baustein der Achse ist; eigene Fehlerklasse je Verstoss (Direktive Fehlerklassen je Achse).
3. Coverage-Guard `tests/.../test_smoke_coverage_profile:141` liest `active` statt "nur deklarierte Sweep-Achsen": deaktivierte Achse legal mit 1 Auspraegung, vergessene Sweep-Zeile wieder ein Fehler (behebt R-c).
4. Rueckwaerts-Draht (Kern von R-d): Planer leitet aus der aufgeloesten Achsen-/Baustein-Menge die `-DCOMDARE_AXIS_<X>_ENABLE_<B>=ON|OFF`-Bundles ab und uebergibt sie an den CEB-Configure-Aufruf; `permutation_build_command.hpp` als bestehende Bausteine-Quelle reaktivieren statt neu bauen. Beruehrt Planer-Emission + CEB-Configure, NICHT den Tier-ABI-Vertrag.
5. ANGEBOT-Stufe "deklariert vs aktiv" (Kern von R-e): das Registry-XML braucht eine Ebene, die `extend` erreichen kann, ohne je einen disabled `name()` zu emittieren - der im Verlauf schon formulierte Gegenvorschlag `declared_count="2"` neben `baustein_count="1"` (`verlauf-queued-ergaenzung-06.txt:668-673`). Preis dort literal benannt: Attribut an ALLEN 18 Achsen -> Registry-XML-Byte-Aenderung + Roundtrip-Re-Anker. GO-pflichtig, Byte-Fenster.
6. Beweise: Profil mit `active="false"` -> binary_id weiter 18 Segmente, `permute_axes 18 / sweeps 17`; Profil mit `active="true"` + 2 Werten -> 18 Sweeps UND emittiertes Configure-Kommando enthaelt `ENABLE_DISK_WRITEBACK=ON`; golden 320 byte-identisch, ce-only-Stempel `0xF1C1F26A1232073B` unveraendert.

GATING
- Schritte 1-3 + 6 sind golden-neutral (Default `active="true"`, keine Wert-/Kardinalitaets-Aenderung) -> im normalen Bau-Fenster.
- Schritt 4 golden-neutral solange alle Flags ihre heutigen Defaults erhalten; Schritt 5 ist Registry-Byte-Fenster; ein tatsaechliches Sweepen von disk_writeback hebt die Voll-Topologie 2^17 -> 2^18 und braucht zusaetzlich das golden-Topologie-GO.

Selbstcheck: `grep -P '[^\x00-\x7F]'` auf diesen Text = keine Non-ASCII-Zeichen ausser dem in Quellen zitierten `§`/`⑤`; Zeilen < 80.
