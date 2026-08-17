# V-02R Explore — Ergebnis (Explorer 1, Plan-/Ledger-Seite)

## KURZBEFUND

Die dokumentierte Hybrid-Stempel-Grammatik EXISTIERT — sie ist NICHT die vom Lead heute vorgeschlagene neue Mikro-Syntax ("hy=" + stufen_id:sha512-128hex), sondern eine bereits am 12.08. vom Owner festgelegte und danach zweimal technisch verfeinerte Form: **Tier-Binary-Stempel + eine neue Zeile = eine für alle belegten Prüfdocks konkatenierte Map (Synthese-Key → Tier-SHA), gefolgt vom normalen Hybrid-Abschluss-SHA, der diese neue Zeile mit abdeckt.** Der einzige echte Bruch zum heutigen Owner-Wortlaut ist die Hash-Länge: der Owner sagt heute erstmals explizit "sha256"; überall sonst, wo im Projekt ein konkreter Algorithmus für Stempel-SHAs benannt ist (Code am Objekt, PLAN-Dokument, KON45-01-Budgetrechnung), ist es SHA-512/128-hex. Das ist der zentrale offene Punkt.

---

## (a) Die dokumentierte Grammatik-Form — wörtlich, mit Fundstellen

**Owner-Kern, 12.08.2026 (KON41-04), Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:5235-5242`:**

> „Der Stempel verwendet die volle Syntax der Organ-Achse und klammert eine serialisierte compile time map bestehend aus Synthese-Funktion-String-Keys und Tier-Binary-am-Prüfdock-Stempel values, konkateniert für alle belegten Prüfdocks, als ein großer Stempel string unter seinen eigenen Tier-Binary Stempelzeilen, hat also noch eine Zeile mehr als Tier-Binary. Der SHA jedes Stempels kommt zum Schluss als letzte Zeile im Hybrid, die Komposit-Stempel-Serialisierungs-Kette als vorletzte Zeile und der Hybrid SHA wirkt auch über diese neue Zeile compile time. Hybrid erbt also das Stempelverhalten von Tier-Binary und fügt die besagte Zeile an der Stelle ein. Bitte dennoch prüfen."

Das ist wortgleich die Formel, die der Owner heute (17.08., KON101-01, Ledger `:26-29`) verkürzt wiederholt: *„Die Grammatik ist die einer Tier-Binary mit durchstich zu einer Verkettung von sha256 der eingesteckten Hybrid-Pruefdock-Tier-Binaries."* — „Tier-Binary-Grammatik" = das Erben der normalen Stempelzeilen; „Durchstich zu einer Verkettung" = die neue Zeile, die zur Komposit-Map/-Kette „durchsticht".

**Verfeinerung 1 — KON45-01 (12.08.), Ledger `:4825-4865`,** löst die Spannung zum bestehenden 9-Glied-Preimage auf und legt technisch fest:
- 10. Glied für **alle** Binaries (Tier trägt `""`), Format-Bump `4→5`, `GliedCount 9→10` (`:4832-4835`).
- POD-seitig: `komposit_line/len` APPEND-ONLY ans POD-Ende, Layout `6→7` (`:4836-4839`).
- Konkatenations-Reihenfolge: **Dock-Index aufsteigend** (`:4858-4859`, „Konkatenation Dock-Index AUFSTEIGEND").
- 🔴 Budget-Bruch: „32 belegte Docks x (Key+128hex+Trenner) ≈ >4,5 KB sprengen ALLEIN kAnatomyFingerprintPreimageMax=4096" (`:4844-4848`) — deshalb Map-VALUE = `Tier-sha512_line (128-hex)`, NICHT der volle Stempel.
- Keys existieren im Code noch nicht als Literal-Strings; die Matrix trägt nur Zell-Adressen (`stufen_id`) — „eigene Key-Grammatik, bis HY-A2 adressbasiert" (`:4849-4852`).

**Verfeinerung 2 — Owner-Kern KON47-02 (12.08.), Ledger `:4686-4699`:**

> „Ja so machen wir es, wir verwenden für jedes Tier-Binary nur dessen SHA statt des gesamten Stempels. Wie empfohlen und lässt sich durch caching der vollen Stempel der Tier-Binaries an den Prüfdocks zum init des Hybrids mit den Tier-Binary modules auch von der CEB über die Fläche 2 zur Laufzeit abfragen."

→ CT-MAP (Identität): `{Synthese-Funktions-Key → Tier-SHA (128-hex)}`; **zusätzlich, getrennt:** RT-CACHE — beim Hybrid-Init werden die vollen Tier-Stempel an den Prüfdocks gecacht und sind von der CEB über Fläche 2 zur Laufzeit abfragbar (`:4693-4699`).

**Dock-Obergrenze — KON28-03 (Owner verbatim, Ledger `:6997-7001`):**

> „Ja es kommt eh darauf an, was der Planer aufgrund der XML Einstellung fordert, aber es sind maximal 32."

→ dynamisch nach Planer/XML, **Deckel 32** — ein „Programm-Deckel", kein Fach-Nenner (bestätigt am Objekt: `heuristik_adapter_synthese_matrix.hpp` Kopf-Kommentar, „NACHZUG 13.08.2026").

**Was der Owner heute ablehnt** (`KON101-02`, Ledger `:49-53`): die Lead-Vorschlags-Grammatik `"hy=" + <stufen_id>:<tier-sha512-128hex>, ';'-getrennt` aus `docs/sessions/20260817-OWNER-VORAB-15-restfragen.md:23-31` (V-02R-Frage dort) — als **eigene neue** Syntax „UEBERHOLT". Sein Verweis auf „in den letzten 10 Wochen entschieden und dokumentiert" zeigt exakt auf KON41-04/KON45-01/KON47-02 oben, nicht auf ein noch unbekanntes Dokument.

**V-04R, heute (Ebenen-Wrap), Ledger `:31-33` + `:58-61`:**

> „Es muss im Hybrid einen Ebenen Wrap der Pruefdock-Tier-Binaries seiner Ebene im Stempel geben bei Abfrage ueber die Flaeche wird das durchgereicht."

→ Ledger-Konsequenz: „die SHA256-Verkettung IST der Ebenen-Wrap; Rekursions-Ablesbarkeit entsteht strukturell je Ebene, kein separates d=<tiefe>-Feld nötig" — löst damit explizit den Vorschlag aus `restfragen.md:47-50` ab (der ein separates `"d=<tiefe>"`-Feld erwogen hatte).

**Objekt-Beleg (ce, development `04ac26fa`, read-only geprüft):**
- `libs/cache_engine/include/cache_engine/abi/anatomy_fingerprint.hpp:116` — `kAnatomyFingerprintFormat = "fingerprint_format=4"` (heute; der 10.-Glied-Bruch auf Format 5 ist noch NICHT gebaut).
- `:416` — `kAnatomyFingerprintGliedCount = 9` (heute; künftig 10).
- `:68` — `kAnatomyFingerprintPreimageMax = 4096` (exakt der Wert, den KON45-01(5) sprengt).
- `:74` — Preimage-Separator ist `'\n'`, aus dem Zeichenvorrat `alnum+"=@;.+_[]"` bewiesen kollisionsfrei.
- `heuristik_adapter_synthese_matrix.hpp:139` — `stufen_id() { return Layer * Nodes + Node; }` — das ist die reale Formel hinter dem in `restfragen.md` vorgeschlagenen adressbasierten Key.
- `docs/plaene/20260806-PLAN-versionierungs-interface-stempel.md:83,343` — „Der abschliessende SHA-512-Fingerprint" / „128-hex SHA-512" — im gesamten 815-Zeilen-Dokument **kein einziger** SHA-256-Treffer.

---

## (b) Wie die Verkettung gebaut ist

- **Reihenfolge:** Dock-Index aufsteigend, dokumentiert (KON45-01 Punkt zwischen `:4858-4859`).
- **Trenner:** NICHT fest dokumentiert. KON45-01(6) benennt das ausdrücklich als offen („eigene Key-Grammatik, bis HY-A2 adressbasiert"); der einzige konkrete Trenner-Vorschlag (`';'` + `"hy="`-Präfix) stammt vom Lead-Vorschlag von heute, den der Owner als überholt/unnötig zurückweist, ohne selbst einen Trenner zu nennen. Gegenprobe: alle `Trenner`-Treffer im Ledger (17 Stellen geprüft) betreffen andere Grammatiken (Preimage-Glied-Trenner `\n`, Flag-Grammatik-Punkt); keiner legt den Komposit-Zeilen-internen Trenner fest.
- **Keys:** ursprünglich „Synthese-Funktion-String-Keys" (KON41-04, Owner-Wortlaut). KON45-01(6) stellt fest, dass diese Strings am Objekt (`heuristik_adapter_strategy.hpp` `strategie_name()`-Literale wie `"Reroute<View>"`) den zulässigen Glied-Zeichenvorrat verletzen — Platzhalter-Grammatik bis adressbasierte `stufen_id()`-Keys aus HY-A2 vorliegen. **Noch nicht entschieden**, ob die finale Form Namens- oder Adress-Keys trägt.
- **SHA je Binary oder SHA über die Verkettung — BEIDES, auf zwei Ebenen:**
  1. Jede eingesteckte Tier-Binary liefert IHRE EIGENE bereits berechnete Abschluss-Stempelzeile (ihr `sha512_line`) unverändert als Map-VALUE — „nur dessen SHA statt des gesamten Stempels" (KON47-02). Das ist **je Binary**, keine Neuberechnung durch den Hybrid.
  2. Der Hybrid selbst trägt — wie jede gestempelte Binary — eine eigene Abschlusszeile, die per Vererbung („Hybrid erbt also das Stempelverhalten von Tier-Binary") über ALLE vorstehenden Zeilen geht; KON41-04 stellt klar, dass diese Abschlusszeile jetzt AUCH die neue Komposit-Zeile umfasst („der Hybrid SHA wirkt auch über diese neue Zeile compile time"). Ein davon **separater** dritter Hash-Schritt „SHA über die ganze Verkettung" ist in keinem Dokument zu finden — die zweite Ebene ist schlicht der immer schon vorhandene Abschluss-Mechanismus, der jetzt eine Zeile mehr umfasst.
- **Ebenen-Rekursion (V-04R):** kein separates Tiefenfeld. Steckt an einem Dock selbst wieder ein Hybrid (rekursiv, `heuristik_adapter_synthese_matrix.hpp`-Kopf: „Rekursion: baumförmig compile-time bis zu begrenzter Tiefe"), liefert dessen eigene, bereits rekursiv aufgebaute Komposit-/Abschlusszeile exakt den Wert, der als Tier-SHA in die äußere Map eingeht — die Tiefe liest sich strukturell aus der Verschachtelung, nicht aus einem Feld. „bei Abfrage über die Fläche wird das durchgereicht" bindet dies an Fläche 2 (Stempel-Interface), nach demselben Transmitter/Multiplexer-Prinzip, das KON19-02 (Ledger `:8048-8065`) für die *andere* Fläche (Fläche 3, Messwerte) bereits für den Hybrid festgestellt hatte — dort aber für Laufzeit-Messdaten, nicht für den CT-Stempel.

---

## (c) Offene Detail-Reste — von den Dokumenten NICHT festgelegt

1. **SHA-256 vs. SHA-512 — der zentrale Rest.** Der Owner sagt heute zum ersten Mal ein konkretes Hash-Verfahren für die Verkettung: „sha256". In JEDER Owner-eigenen Vorgänger-Äußerung (KON41-04, KON47-02) heißt es nur generisch „SHA"/„dessen SHA" — nie mit Bitlänge. Die „128-hex"-Festlegung stammt NICHT vom Owner, sondern ist die eigene technische Distillation der Explorer-/Scribe-Notiz in KON45-01(5)/KON47-02 (die dabei den einzigen im Projekt sonst belegten Stempel-Algorithmus — SHA-512, überall wo er konkret benannt ist: `anatomy_fingerprint.hpp`, das PLAN-Dokument, `src/sha512/ctsha512.hpp` — übernommen hat). SHA-256/64-hex ist im Projekt bisher ausschließlich für zwei ANDERE, explizit als separat deklarierte Zwecke belegt: den „Name" (E-A, Ledger `:28201`, „der Name ist damit KEIN Praefix des Fingerprints [der bleibt SHA-512], sondern ein eigener Hash", `:28214-28216`) und den Planer-eigenen Fingerprint (V-08R, heute). Kein Dokument sagt explizit, dass die Hybrid-Komposit-Werte diesem „Name/Planer"-SHA-256-Muster folgen sollen statt dem „Fingerprint"-SHA-512-Muster — die „Konsistenz-Anker"-Notiz in KON101-02 (Ledger `:53`) ist selbst nur eine heutige interpretierende Randbemerkung, kein Owner-Zitat, und löst die Frage nicht auf. **Folge fürs Bauen:** KON45-01(5)s Budgetrechnung (128-hex je Eintrag) wäre bei SHA-256 (64-hex) neu zu rechnen — der Budget-Bruch fiele ggf. kleiner aus oder entfiele teilweise.
2. **Trenner-Byte** zwischen den Map-Einträgen der Komposit-Zeile: nirgends fixiert (s. (b)).
3. **Key-Form** (Synthese-Funktions-Namensstring vs. adressbasiert `stufen_id()`): als Übergangszustand benannt, nicht final entschieden — abhängig von HY-A2.
4. **Neuer Preimage-Budget-Wert:** KON45-01(5) verlangt „Puffer+Budget-Konstanten heben, Pflicht-Edit MIT Budget-Beleg" — der neue Zahlenwert selbst ist nicht dokumentiert.
5. **Lager-Identität der Hybrid-.so** (K1 im SOLL-Design `docs/architecture/20260802-hybrid_tier_stufe_soll_design.md:330-342`) war am 02.08. noch offen (zwei Optionen a/b); KON41-04 beantwortet sie faktisch mit „LAGER-IDENTITAET vollstaendig: Pfad-Glieder aus den eigenen Zeilen, Blatt-SHA schliesst die DOCK-BELEGUNG ein" (Ledger `:5253-5255`) — das ist eine Auflösung, aber nirgends als expliziter K1-Abschluss im SOLL-Design nachgetragen; wer nur das SOLL-Design liest, sieht K1 fälschlich noch offen.
6. **„measurement-Durchstich" (Fläche 3) ist NICHT dasselbe Konzept.** Der Auftrag nannte dies ausdrücklich als zu prüfende Analogie — Gegenprobe negativ: Fläche 3 (KON16-06/KON19-02, Ledger `:8494-8523`, `:8048-8065`) ist die REDUZIERTE Laufzeit-Genus-Interface-Fläche nach dem Compile (Messwert-Durchreichung, „damit die Gattung+Genus-Funktionsinterfaces nicht geändert werden müssen"), lebt an Fläche 3. Der heutige „Durchstich" der Owner-Formel betrifft dagegen Fläche 2 (den CT-Stempel). Beide Mechanismen teilen nur das Wort, nicht den Gegenstand — sollten in der Synthese nicht vermischt werden.
7. **Snapshot-Aggregations-K5** und **K2-Schichtfrage** aus dem SOLL-Design (Abschnitt 7) bleiben unabhängig davon offen, berühren aber nicht die Byte-Form der Stempelzeile selbst.

---

## (d) Geprüft / nicht geprüft

**GEPRÜFT** (Volltext gelesen bzw. gezielt mit Kontext ±40 Zeilen, Owner-Zitate gegen Rohtext verifiziert):
- Ledger KON101-01/-02/-03 (`:19-86`), KON100-01 (`:87-`), KON41-02..-05 (`:5191-5270`), KON45-01/-02 (`:4818-4867+`), KON47-01..-05 (`:4650-4757`), KON28-03 (`:6995-7012`), E-A/E-B-Block (`:28196-28237`), KON16-06/KON19-02 (`:8048-8065`, `:8494-8523`).
- `docs/sessions/20260817-OWNER-VORAB-15-restfragen.md` — vollständig (alle 12 Fragen, insb. V-02R/V-04R).
- `docs/sessions/20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md` — geprüft (Kopf + Grep), bestätigt: anderes Fragenbündel, verweist selbst auf `restfragen.md` für V-01R..V-13.
- `Code/external/comdare-cache-engine/docs/architecture/20260802-hybrid_tier_stufe_soll_design.md` — vollständig (alle 12 Abschnitte).
- `docs/plaene/20260806-PLAN-versionierungs-interface-stempel.md` — Kopf, Zielbild, POD/Glied-Tabellen, Hybrid-Abschnitte (3.1-3.4) gelesen; auf SHA256/SHA512 vollständig gegrept (0 vs. viele Treffer).
- `docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md` — auf Verkettung/Durchstich/sha256/sha512 gegrept (kein Komposit-Konzept dort, Dokument liegt vor KON41-04).
- Objekt (ce, development, read-only, `04ac26fa`): `anatomy_fingerprint.hpp` (Format/GliedCount/Budget/Separator/Glied-Liste), `heuristik_adapter_synthese_matrix.hpp` (Kopf-Owner-Zitat + `stufen_id()`-Formel + static_asserts).
- Gegenproben durchgeführt: „Trenner" (17 Treffer, keiner legt den Komposit-internen Trenner fest), „eingesteckt/einstecken" (Ledger-Treffer alle geprüft — die Treffer außerhalb des V-02R-Kontexts betreffen ein anderes Thema, Work-Mode/State-Pattern 09.08., nicht die Stempel-Bytes), Ledger-Ordnung bestätigt newest-first (KON101 ist tatsächlich der jüngste Abschnitt, keine neuere KON-Nummer existiert).

**NICHT GEPRÜFT** (Lücken, zur Offenlegung):
- `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (30.363 Zeilen) wurde NICHT End-zu-Ende gelesen, sondern gezielt über die im Auftrag genannten Suchbegriffe/KON-Anker plus Gegenproben erschlossen — bei einem Dokument dieser Größe ist ein Fund abseits dieser Anker nicht mit Sicherheit ausgeschlossen.
- `docs/plaene/20260806-PLAN-versionierungs-interface-stempel.md` (815 Zeilen) wurde nicht vollständig gelesen, sondern Kopf + Grep-Treffer-Umfeld — die restlichen ~650 Zeilen (v.a. Migrations-DAG/Gates ab Abschnitt 4) wurden nicht durchgesehen.
- `docs/sessions/backups/*` (Roh-Transkript-Dumps) wurden NICHT durchsucht — ein erster Versuch lieferte 247 KB Treffer dominiert von Journal-Rauschen; ich habe mich auf die kanonischen Destillate (KON41-04/45-01/47-02) verlassen, da sie selbst als Owner-Zitate geführt sind.
- ce-eigene Ledger-Sections (`Code/external/comdare-cache-engine/docs/ledger-sections/*.md`), die laut Ledger-Kopf (AUDIT-KLAUSEL, `:12-17`) zur 4-Ledger-Vollständigkeit gehören, wurden nicht durchsucht — lag außerhalb des mir zugewiesenen Suchauftrags (PLAN-/Ledger-Seite); falls ein Explorer 2 die Code-Seite fährt, gehört das dorthin.
- Kein Zugriff auf/keine Suche in den rohen Chat-Transkripten des heutigen Owner-Gesprächs jenseits der beiden Session-Dokumente — falls die Owner-Antwort dort einen längeren, disambiguierenden Kontext zu „sha256" enthält, ist das nicht erfasst.