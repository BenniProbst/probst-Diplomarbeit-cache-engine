## Übergreifender Befund zuerst

**Für keine der drei Entscheidungen existiert eine direkte Owner-Antwort.** Das ist kein Suchfehler, sondern am Roh-Transkript bewiesen: `/home/comdare/.claude/projects/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489.jsonl` enthält am 03.08. genau 20 Owner-Nachrichten. Zwischen der Formulierung der Vorlagen (07:21, ein Manager-Text) und dem Login (14:58) liegen exakt vier: „Vorschlag angenommen, Parallelisierung …" (07:43), „Bitte lege eine abbruchsichere Pause ein" (07:55), „Bitte pausiere die workflows" (08:01) — keine davon inhaltlich. Auch die abgeschlossene Kontext-Gegenlese über 86 Owner-Nachrichten führt die elf Vorlagen ausdrücklich weiter als offen (`docs/sessions/backups/20260803-kontext-gegenlese/result-2.json:48`).

Die Auflösung liegt im Owner-Wortlaut selbst (03.08. 15:19): „alle Fragen und Entscheidungen waren vor dem Account login wechsel so gründlich beantwortet, dass du keine Fragen offen hattest, bitte untersuche **jede einzelne Entscheidung auf die korrekte exakte bereits getroffenen Planungen**". Der Owner verweist nicht auf eine verlorene Antwort, sondern auf bereits getroffene Festlegungen. Die habe ich gefunden — und sie ergeben für die drei Punkte drei sehr unterschiedliche Verdikte.

---

## 1. OF-M3-1 (Fingerprint-Preimage-Härtung) — DEFAULT-KORREKT, aber unvollständig

Zwei Owner-Festlegungen decken Option A inhaltlich zwingend:

**Owner-ABNAHME-3+4 (26.07.)**, verbatim aus `/home/comdare/.claude/projects/-home-comdare/memory/project_bestandslog_abnahmen_baum_heuristik_stempel.md`, Punkt 3:

> „ALLE Stempel-Hauptachsen werden als String in der Binary mit ihrer VERSION und dem HASH ALLER SOURCE-CODE-DATEIEN IM OVERLAY als String gehasht -> zusaetzlicher **SHA512-Fingerprint als weitere Stempel-Zeile** (nie zur Laufzeit berechnet; **Binary eindeutig**)."

**Owner-F7 (01.08. 21:33)**, verbatim aus dem Kondensat Zeile 966 (Z90608):

> „F7 - Ja korrekt, es muss ein viertes Prüfkriterium geben bzw. reicht ein check gegen die komplex (siehe meine session log Beschreibung) geplante SHA512 validierung allein, **weil sie die anderen Stempel allein deckt. Das war auch der Sinn des SHA512.**"

Der Owner hat damit zweimal die *Eindeutigkeit* als Zweck des Fingerprints festgelegt. Eine nicht-injektive Konkatenation erfüllt diesen Zweck nachweislich nicht — Option B wäre eine Abweichung vom Owner-KERN, nicht bloß ein akzeptiertes Restrisiko. Die ältere Reihenfolge-Festlegung D3 („Preimage concat(organ+system+measurement+merge) fixe Reihenfolge", `docs/sessions/20260722-SESSION-PAUSE-HANDOVER-netzwechsel.md:50`) bleibt von einem Separator unberührt, da er die Reihenfolge nicht ändert.

**Verdikt: DEFAULT-KORREKT.** Zwei Ergänzungen, die der Lead kennen muss:

Erstens ein Ehrlichkeits-Punkt: Der Code-Kopf `anatomy_fingerprint.hpp:5` etikettiert D3 als „D3 (User-GO 2026-07-22)". Die Transkript-Extraktion führt D1/D2/D3 dagegen als **Manager-Entscheide** (`docs/sessions/backups/20260726-kontext-neugruendung-workflow/ergebnisse/38-transkript-28-ae354b36.md:80`: „B6 K7b-Scheibenplan (Kartierung + Manager-Entscheide) … **D3 = Preimage `concat(...)`**"). Die „User-GO"-Etikettierung im Header ist durch keine Quelle belegt.

Zweitens — und das ist der wichtigere Fund — **Option A in der jetzigen Fassung greift zu kurz**. Die von F7 beauftragte Konsolidierung (`docs/sessions/20260801-KONSOLIDIERT-gesamtarchitektur-lager-batch-eta-sha512.md:72`) enthält eine bereits getroffene Preimage-Festlegung, die im M3-Dossier nirgends auftaucht:

> „FORMAT-VERSION: das Preimage-Layout traegt eine eigene **fingerprint_format-Kennung als erstes Glied** — Layout-Evolution mismatcht dann deterministisch statt still zu kollidieren."

Dazu kommt aus demselben Dokument (`:103`, VERIFY-Fehler, als „schwerster Befund" markiert) die Auflage, das Sub-Achsen-Werteset-Segment als explizites Preimage-Glied aufzunehmen — sonst würde ein Werteset-Bump unter dem SHA512-only-Gate still reused. Beides sind Preimage-Layout-Änderungen. Wenn A13-M3 das *eine* Neuanker-Fenster ist, gehören sie in denselben C3-Commit; sonst steht ein dritter globaler Neuanker an, genau gegen die Termin-Logik, mit der OF-M3-1 selbst begründet wird.

---

## 2. OF-M3-2 (Overlay-Definition S8) — die drei Festlegungen fehlen, aber der Plan-Widerspruch existiert nicht

**Ich habe die Herkunft von „S8" gefunden.** Es stammt nicht aus einer Owner-Liste, sondern aus dem Abschnitt „(b) ARCHITEKTUR-/SCOPE-ENTSCHEIDUNGEN" eines Transkript-Extrakts, also einem Manager-Entscheid — `docs/sessions/backups/20260802-kontext-neugruendung-abend-workflows/ergebnisse/45-1bbd49eb.md:59`, verbatim:

> „**S8-Overlay:** Naht seit O-8 gebaut und inert; Scharfstellen ist Identitäts-Entscheidung je Tier-Binary, braucht drei Owner-Festlegungen (a) welche Dateimenge, (b) Sortier-Ordnung, (c) Hash je Datei vs. Konkatenation. Verortung: eigenes ce-Paket NACH V-4, in einem Fenster mit Golden-Neuanker; **NICHT Voll-Bau-blockierend**."

Das ist die Quelle, auf die GATE 9 verweist — und GATE 9 zitiert sie nur zur Hälfte. Der Zusatz „NICHT Voll-Bau-blockierend" fehlt dort. **Damit löst sich die Begründung auf, mit der DV-2 zu OF-M3-2 hochgestuft wurde:** Der behauptete Plan-Widerspruch („GATE 9 verortet S8 im Neuanker-Fenster, ein Default ‚nach Abgabe' hätte das superseded") beruht auf einer verkürzten Wiedergabe. Die Ursprungsquelle stuft S8 selbst als nicht blockierend ein. Ein vom Owner zu ratifizierender GATE-9-Supersede-Vermerk ist folglich nicht nötig — es genügt, GATE 9 auf den vollen Wortlaut zu korrigieren.

Zu den drei Festlegungen selbst: **(a) Verzeichnis-Schnitt** ist durch die Owner-Abnahme 26.07. („HASH ALLER SOURCE-CODE-DATEIEN IM OVERLAY") nur scheinbar gedeckt — was „das Overlay" ist, definiert keine Quelle. **(c) Hash-Form** ist widersprüchlich angelegt: die Abnahme sagt „als String gehasht" (ein Hash über die Konkatenation), `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:88` sagt „Overlay-Source-Hash**es**" (Plural). **(b) Sortier-Ordnung** kommt in keiner Quelle vor. Bestätigt wird das durch die 01.08.-Konsolidierung selbst (`:106`): „WELCHE Dateimenge ‚das Overlay' ist, ist dort ausdruecklich als OFFENE OWNER-ENTSCHEIDUNG markiert … als eigenen Owner-Entscheid + Bau-Punkt in die F7-Strecke aufnehmen."

**Verdikt: NICHT-GEFUNDEN für alle drei Festlegungen** — der laufende Fallback B (laut Ledger `:3719` bereits aktiv) ist durch die S8-Ursprungsquelle sogar besser gedeckt als die konditionierte Option A. Gesucht in: Ledger, allen `docs/sessions/*.md`, allen 143 Unterordnern von `docs/sessions/backups/`, ce `docs/architecture/`, dem gesamten ce-Code (`COMDARE_OVERLAY_SOURCE_HASH` hat genau drei Fundstellen, alle in `anatomy_fingerprint.hpp:52-55`), dem Kondensat und dem Roh-Transkript.

---

## 3. DV-3 („v0"-Sentinel) — NICHT-GEFUNDEN, und die Default-Begründung hält dem Ist nicht stand

Keine Owner-Aussage berührt den `.algos`-Signatur-Pfad; die Sammelvorlage V4 (deren dritter Teilpunkt CX-W13 ist, `docs/sessions/20260802-PAUSE-abbruchsicher-welle2d-auslaufend.md:75-76`) wurde nie beantwortet. Die nächstliegenden Owner-Wortlaute sind Q3 (02.08. ~17:0x): „Die Kurzform ist verboten, Versionierungen sind **einheitlich und immer 3-Stellig** und beginnen mit 'v'" und Q10 (02.08. ~19:5x): „Bitte ohne 'v', lass es jetzt so, also Option A" — Letzteres belegt, dass der Owner zwischen Roh-Literalen und gerenderter Form unterscheidet, was die Namensraum-Argumentation grundsätzlich stützt.

**Am Ist trägt sie hier aber nicht.** Der Code-Kommentar `axis_variant_version_table.hpp:236-239` begründet die Ausnahme mit „eine SEPARATE, byte-eingefrorene Welt". Die direkt folgende Zeile 240 zeigt jedoch:

```cpp
out += ver.empty() ? std::string_view{"v0"} : ver;
```

Der Sentinel steht in **demselben Slot**, in dem sonst die echte `algo_version` aus der Tabelle landet — und die migriert in M3 auf `v1.0.0c`. Nach dem Fenster enthielte derselbe `.algos`-Slot gemischt `v1.0.0c` und `v0`. Das ist kein getrennter Namensraum, sondern eine Inkonsistenz innerhalb eines Slots, gegen die Q3 „einheitlich … immer 3-stellig" direkt spricht. Bestärkend: Bei A13-M1b wurden zwei der drei `v0`-Sentinel-Stellen auf `v0.0.0` gezogen (byte-neutral); nur diese blieb, weil sie eben *nicht* byte-neutral ist — die Ausnahme ist also aus Kosten-, nicht aus Grammatik-Gründen entstanden.

**Verdikt: NICHT-GEFUNDEN.** Der laufende Default (a) ist keine Owner-Entscheidung, sondern eine Manager-Ausnahme, deren dokumentierte Begründung am Ist widerlegbar ist. Da ein Rückbau nach dem Fenster eine eigene Sidecar-Kaskade kostet, gehört das als echter Entscheidungspunkt vorgelegt — nicht als stiller Default.

---

## Was der Lead daraus mitnehmen sollte

Der bereits vollzogene Stand (Ledger `:3719`: OF-M3-1 = A vollzogen, OF-M3-2 = Fallback B aktiv, DV-3 = (a)) ist in allen drei Punkten vertretbar. Drei Dinge sind aber nachzuziehen: OF-M3-1 Option A ist **unvollständig** (fingerprint_format-Glied und Werteset-Segment gehören in denselben C3-Commit, sonst dritter Neuanker); der für OF-M3-2 vorgesehene **GATE-9-Supersede-Vermerk entfällt** (GATE 9 zitiert die S8-Quelle verkürzt, es liegt kein Plan-Widerspruch vor, nur ein Zitierfehler zu korrigieren); und **DV-3 sollte nicht als Default durchlaufen**, weil seine Code-Begründung dem Ist nicht standhält.

Zentrale Fundstellen: `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260801-KONSOLIDIERT-gesamtarchitektur-lager-batch-eta-sha512.md` (Zeilen 42, 72, 103, 106) · `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/backups/20260802-kontext-neugruendung-abend-workflows/ergebnisse/45-1bbd49eb.md:59` · `/home/comdare/.claude/projects/-home-comdare/memory/project_bestandslog_abnahmen_baum_heuristik_stempel.md` (Punkt 3) · `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/abi/anatomy_fingerprint.hpp:37-55` · `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/builder/experiment_tree/axis_variant_version_table.hpp:236-240`.